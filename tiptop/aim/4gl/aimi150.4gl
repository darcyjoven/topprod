# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: aimi150.4gl
# Descriptions...: 料件基本資料建立
# Date & Author..: No.FUN-670033 06/08/30 By Mandy
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件" 
# Modify.........: Mo.FUN-6A0061 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-增加科目二開窗
# Modify.........: No.TQC-730112 07/04/12 By Mandy 將CALL aws_efapp_flowaction() 移至BEFORE MENU,可避免在畫面上按滑鼠右鍵，會出現簽核的指令
# Modify.........: No.TQC-740090 07/04/16 By Mandy 1.單據更改後,"資料更改者"沒有更新 
#                                                  2.資料拋轉時,s_carry_data()內的畫面多一個欄位'已存在',存放該要拋轉的資料是否存在當筆的那個資料庫
# Modify.........: No.TQC-740169 07/04/26 By Mandy 資料拋轉時,s_carry_date 重新給default 邏輯
# Modify.........: No.TQC-740334 07/04/27 By Mandy 當新增一筆申請類別為'U:修改'的申請單時,某些欄位內容錯誤,會帶修改的料件編號在ima_file內的資料
# Modify.........: No.TQC-740343 07/04/27 By Mandy 資料拋轉時,資料所有者,資料所有部門,資料修改者,最近修改日 等欄位錯誤
# Modify.........: No.TQC-750007 07/05/02 By Mandy 1.串EasyFlow未OK
#                                                  2.修改時,狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.TQC-750017 07/05/04 By Mandy 用EasyFlow簽核時,有幾個欄位無法show出,因為其為非主畫面aimi150.per 上的欄位
#                                                  解法:將這些欄位加在aimi150.per上,但是隱藏起來
#                                                  imaa130/imaa31/imaa44/imaa55/imaa63
# Modify.........: No.TQC-750141 07/05/25 By jamie 1.新增料件, 分群碼default時出現aoo-001, 則停留在分群碼, 應同 aimi100作法, 顯示錯誤提示後應仍可繼續輸入
#                                                  2.輸入分群碼後, 詢問是否依分群碼default, 選'N', 仍出現 anm-001 訊息
#                                                  3.資料拋轉action建議多加'全選' '全不選' 選項
#                                                  4.拋轉DB記錄請一按該action就秀出, 不要等按了確定才秀資料
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.TQC-780004 07/08/01 By Mandy Action "資料拋轉"時,若申請類別為'新增'時,資料已存在的不能選取,做拋轉
#                                                                      若申請類別為'修改'時,資料不存在的不能選取,做拋轉,避免不必要的錯誤產生!
# Modify.........: No.FUN-710060 07/08/08 By jamie 1.增加欄位imaa915"是否需做供應商的管制
#                                                  2.新增料件時依分群碼做default 
# Modify.........: No.CHI-780006 07/08/09 By jamie 增加CR列印功能
# Modify.........: No.MOD-780101 07/08/17 By jamie 資料拋轉失敗
# Modify.........: No.MOD-780102 07/08/17 By Mandy AFTER INPUT 的重要欄位判斷只在申請類別為:'I':新增時才需判斷
# Modify.........: No.MOD-790149 07/09/28 By Pengu p_flow設定新增時通知人員及建議執行程式但卻未成功
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/15 By saki 自定義欄位程式段刪除
# Modify.........: No.MOD-7C0118 07/12/18 By Pengu 1.修改[分群碼]後，會跳出aec-014的錯誤訊息
#                                                  2.無法修改成功。
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0084 08/01/23 By Mandy AFTER FIELD imaa01 若imaa00為"新增",控管申請料件編號不可重覆
# Modify.........: No.MOD-820154 08/02/26 By Pengu 當執行拋轉資料庫時會造成無窮回圈
# Modify.........: No.MOD-810253 08/02/26 By Pengu 按下【資料拋轉】不選任何營運中心按下確定，系統會將此申請單的狀態改為2.已拋轉
# Modify.........: No.FUN-7C0010 08/03/11 By Carrier 將"資料拋轉"的邏輯移至s_aimi100_carry.4gl中
# Modify.........: NO.FUN-840018 08/04/03 by yiting 加入拋轉歷史查詢功能
# Modify.........: NO.FUN-840042 08/04/11 by TSD.Wind 自定欄位功能修改
# Modify.........: NO.CHI-840022 08/04/20 By Mandy (1)申請時,料號可空白
#                                                  (2)送簽中,未拋轉前,可補料號
#                                                  (3)拋轉前,check必需有料號
#                                                  (4)若有用自動編號,補料號時,可另按Action產生
# Modify.........: NO.MOD-840160 08/04/20 By kim 修改錯誤訊息內容
# Modify.........: NO.MOD-840275 08/04/20 By Mandy 申請單確認後且已正式拋轉，但仍可取消確認
# Modify.........: No.FUN-840160 08/04/23 By Nicola 加入批/序號管理
# Modify.........: NO.TQC-850019 08/05/13 By claire 使用更改性質的單據申請時,key值空白未控卡
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.FUN-840114 08/05/29 By sherry 建議aimi150申請單需有復制功能
# Modify.........: No.MOD-880060 08/08/07 By claire 設定品名規格化時,並不會自動開窗
# Modify.........: No.MOD-880063 08/08/08 By claire 畫面action出現英文btn01,btn02...btn_detail
# Modify.........: No.TQC-890025 08/09/08 By claire 以流通配銷參數控管page07要不要顯示
# Modify.........: No.MOD-890132 08/09/12 By claire 以補料號方式輸入料號(參數設自動編碼),會清空原有的品名
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-910003 09/01/03 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.FUN-8C0086 09/01/21 BY claire 加入 imaa601
# Modify.........: No.FUN-930108 09/03/25 BY zhaijie新增imaa926-AVL否欄位
# Modify.........: No.FUN-950083 09/06/24 By mike 在i150_y_chk() 中呼叫i150_chk_rel_imaa06()進行相關欄位資料是否存在，              
#                                                 若不存再請show訊息并不允許確認              
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960126 09/10/20 By Pengu 新增料件時應遵循資料中心的關連與控管
# Modify.........: No:MOD-970083 09/10/20 By Pengu 3774行，變數給錯
# Modify.........: No:MOD-970122 09/10/20 By Pengu 補登料號時須判斷imaa571與imaa133是否為NULL，若是則default imaa01
# Modify.........: No.FUN-9B0099 09/11/18 By douzh 给imaa926设定默认值,避免栏位为NULL情况出现
# Modify.........: No.TQC-9C0004 09/12/10 By lilingyu 當與EF整合,復制單據時,若原被復制單據是需簽核單據,要復制成不需簽核的單據,"是否簽核"欄位應該為N
# Modify.........: No.MOD-9C0244 09/12/19 By wujie    imaa922预设为Y
# Modify.........: No:MOD-9C0243 09/12/22 By Pengu 1.若不是最後規格主件時，規格主件欄位應不可輸入
#                                                  2.開窗沒有資料
# Modify.........: No:MOD-9C0392 09/12/24 By Pengu 新增申請單時會強制要輸入料號
# Modify.........: No:TQC-A10017 10/01/07 BY lilingyu 新增單據時,"imaa919 imaa922"未default 值
# Modify.........: No:TQC-A10023 10/01/08 BY lilingyu 新增單據時,"安全存量 安全期間 最高存量 有效天數"未控管負數
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.TQC-A40111 10/04/30 By destiny 当使用品名规则输入时，品名仍是自行录入
# Modify.........: No:MOD-A50099 10/05/20 By Sarah 在imaa918或imaa921欄位連續勾選、取消、再勾選時,imaa919/920/922/923/924/925等欄位開關會異常
# Modify.........: No:MOD-A60090 10/06/14 By Sarah 單位一致性處理
# Modify.........: No:MOD-A60104 10/06/15 By Sarah 新增時,若有修改庫存單位(imaa25)也應詢問aim-020
# Modify.........: No:CHI-A80023 10/08/23 By Summer 增加檢核,若確認時料件編號還沒輸入,但資料中心拋轉設為1.自動拋轉時,提示訊息
# Modify.........: No.FUN-950057 10/09/03 By vealxu gew03 = '1'時,確認時自動拋轉 
# Modify.........: No.FUN-A90049 10/09/21 By vealxu 規通料件整合商戶料號合併到 ima_file， ima_file加一料件性質判斷為企業料號或商戶料號
# Modify.........: No:MOD-AA0040 10/10/11 By sabrina aimi150_curo已無作用，將此段mark
# Modify.........: No:MOD-AA0162 10/10/26 By sabrina 修改MOD-AA0040錯誤 
# Modify.........: No:MOD-A80234 10/10/29 By Smapmin 單據新增前再次判斷料件編號是否重複
# Modify.........: No.FUN-AB0011 10/11/03 By vealxu 拿掉新增時料號的管控
# Modify.........: No.TQC-AB0051 10/11/14 By destiny 删除时没有清空画面 
# Modify.........: No:MOD-A10092 10/11/25 By sabrina 複製時應允許料號不輸入
# Modify.........: No:TQC-AB0197 10/11/29 By chenying 會計科目二 欄位無管控 
# Modify.........: No:CHI-AC0001 10/12/08 By Summer 申請作業上的欄位本來就可能與基本資料的不同,修改為直接抓取每個欄位放到g_imaa的變數裡
# Modify.........: No:CHI-AC0026 10/12/16 By Summer 單據刪除時,相關文件沒有一併刪除
# Modify.........: No:MOD-AC0307 10/12/24 By jan 資料重複的那個error msg 請改為彈出來(cl_err的第三餐數改為1)
# Modify.........: No:MOD-AC0330 10/12/27 By liweie 申請類別選則修改時無法新增,加入到料件申請資料主檔(imaa_file)失敗,修改給imaa26、imaa261、imaa262預設值
# Modify.........: No.FUN-AC0083 10/12/28 By vealxu 5.2版新增量化規格及量化單位的功能，但在申請單中沒有此二欄位
# Modify.........: No.FUN-B10049 11/01/26 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B30043 11/03/11 By shenyang aimi150應該加入同aimi100_icd的"ICD"頁簽，只有icd行業才顯示，aimi150應改為區分行業別程式,
# Modify.........: No.MOD-B30157 11/03/12 By sabrina 若為icd業，則不顯示"批/序號管理"頁籤
# Modify.........: No.MOD-B30173 11/03/12 By sabrina 料號不輸入時，主分群碼選ICD_WF後，主分群碼會被清空 
# Modify.........: No.MOD-B30242 11/03/12 By sabrina 複製時，imaa571預設新的imaa01的值 
# Modify.........: No.TQC-B30116 11/03/14 By destiny 新增时，未做相应的单别设置
# Modify.........: No.MOD-B30519 11/03/15 By jan aici020 新增參數
# Modify.........: No:MOD-B40095 11/04/18 By Summer aim-150的控卡要排除'無效'的資料,另外,無效資料又要變為有效資料時,要確認已沒有有效資料存在 
# Modify.........: No:MOD-B40151 11/04/18 By Smapmin 來源碼無法輸入R類
# Modify.........: No:MOD-B40150 11/04/18 By Smapmin 選完分群碼後,沒有default批序號的設定
# Modify.........: No:FUN-B30192 11/05/03 By shenyang 添加字段imaicd14,imaicd15,imaicd16
# Modify.........: No:FUN-B50106 11/05/19 By lixh1 將imaicd_file中的字段移到imaa_file中,將程式由aimi150.src.4gl還原成aimi150.4gl 
# Modify.........: Mo:FUN-B30092 11/05/27 By Polly 1.量化規格開窗改抓q_gfo
#                                                  2.ringmenu加掛量化規格(quantifying)action
# Modify.........: Mo:TQC-B60117 11/06/16 By zhangweib 新增一筆資料，點擊“審核”鈕，系統出現錯誤提示：“ 字段錯誤.”
# Modify.........: No:TQC-B60177 11/06/20 By lixiang  增加切換語言別的ACTION
# Modify.........: No:TQC-B60128 11/06/21 By wuxj     增加上下筆功能action
# Modify.........: No:TQC-B60184 11/06/21 By wuxj     增加【更改】、【複製】、【無效】、【打印】、【幫助】按鈕
# Modify.........: No:FUN-B70057 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No.FUN-B70051 11/07/19 By xianghui 開窗要可以挑申請料號或是料件主檔
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B50096 11/09/14 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
#                                                  增加欄位imaa159
# Modify.........: No.FUN-B90035 11/09/14 By lixh1 給imaa159默認值
# Modify.........: No:CHI-B80032 11/10/08 By johung 修正批/序號管理欄位控管
# Modify.........: No:TQC-B90236 11/10/27 By zhuhao 增加欄位 imaa928，imaa929,和一個ACTION 特性維護
# Modify.........: No:FUN-BB0083 11/11/30 By xujing 增加數量欄位小數取位
# Modify.........: No:MOD-BC0002 11/12/01 By ck2yuan 申請類別為修改時 LEFT OUTER JOIN imaa_file 取得imaa_file的欄位資料
# Modify.........: No:FUN-BC0103 12/01/13 By jason 增加PIN COUNT等欄位for ICD
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0106 12/02/02 by Jason 新增"ICD料件製程資料維護作業"按鈕 for ICD
# Modify.........: No:FUN-C20025 12/02/08 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:TQC-C20137 12/02/13 By bart imaa_file有些欄位為ICD行業別使用,但設為NOT NULL時其它行業別也應該給予預設值
# Modify.........: No:TQC-C20075 12/02/17 By SunLM 修正imaaoriu,imaaorig不能查詢的問題
# Modify.........: No:FUN-C30017 12/03/07 By Mandy TP端簽核時,[資料拋轉歷史]/[資料拋轉]/[取消確認]/[量化規格]/[特性維護]/[ICD料件製程資料維護作業] ACTION要隱藏
# Modify.........: No:TQC-C30163 12/03/09 By xjll bug修改複製一筆數據后點選補料號欄位停在料件編號欄位，但是卻停在imaa928
# Modify.........: No:MOD-C30091 12/03/09 By bart 當ima918/ima921都沒有勾選時,ima925應該不需要輸入,請設為noentry
# Modify.........: No:MOD-C30099 12/03/10 By bart "查詢測試料件"(qry_test_item)這個ACTION是ICD特有的,請判斷當為ICD行業別時才做顯示
# Modify.........: No:MOD-C30206 12/03/10 By bart 將所有imaaicd13欄位mark掉 還原
# Modify.........: No:MOD-C30208 12/03/10 By fengrui 參照FUN-AB0011拿掉新增時料號的管控
# Modify.........: No:MOD-C30207 12/03/10 By zhuhao imaa929欄位控管
# Modify.........: No:MOD-C30147 12/03/10 By yuhuabao 錄入分群碼時帶入特性資料至imad_file
# Modify.........: No:MOD-C30238 12/03/12 By bart 料件特性 BIN群組BODY選取時,母體料號未能自動帶入
# Modify.........: No:MOD-C30513 12/03/12 By bart 新增或修改時,輸入完"母體料號"imaicd01後,應依"母體料號"預設Gross Die(imaicd14)
# Modify.........: No:TQC-C30184 12/03/13 By xjll imaaicd17字段為空時給默認值 '3'
# Modify.........: No:FUN-C30026 12/03/14 By bart 增加母料號否
# Modify.........: No:FUN-C30206 12/03/15 By bart 當料件狀態為1時(未測WAFE)母體料號為料件自己時,不控卡必需存在料件主檔
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30278 12/03/28 By bart 判斷imaicd05改為判斷imaicd04
# Modify.........: No:TQC-C40036 12/04/09 By fengrui 修改刪除后後續操作
# Modify.........: No:TQC-C40037 12/04/09 By fengrui 申請類別(ima00)="U"時,特性主料編號不可維護
# Modify.........: No:TQC-C40038 12/04/09 By fengrui imaa929欄位添加aim1145檢驗和控管
# Modify.........: No:TQC-C40044 12/04/10 By fengrui 復制資料時,將原資料的imad_file資料復制,添加imaa918控管
# Modify.........: No.TQC-C40084 12/04/12 By fengrui 不使用'查詢測試料件'時，給出相應的提示信息
# Modify.........: No:TQC-C40078 12/04/13 By fengrui 修正料件狀態對良率、刻號/BIN、DATECODE否控管
# Modify.........: No:TQC-C40099 12/04/13 By fengrui 修正料件編號報錯信息條件
# Modify.........: No.TQC-C40231 12/05/08 By fengrui 刪除后如果無上下筆資料，則清空變量
# Modify.........: No.FUN-C40011 12/05/15 By bart aimi150拋轉時同aimi100自動產生料號
# Modify.........: No.FUN-C50111 12/05/25 By bart 當料件狀態為0.Body時,執行「補料號」後要將imaa01同步寫到imaaicd01
# Modify.........: No.FUN-C50132 12/05/30 By bart WITH HOLD
# Modify.........: No.TQC-C60006 12/06/01 By bart ICD行業別「確認」時,不要自動執行資料拋轉;只有當按下「資料拋轉」時才可以自動產生料件跟BOM
# Modify.........: No.TQC-C60004 12/06/01 By bart 1.複製時,當料件狀態為0,母體料號要寫入複製後維護的imaa01;當料件狀態為1,母體料號要清空
#                                                 2.補料號時,當料件狀態為0,母體料號要寫入維護的imaa01;當料件狀態不為0,母體料號要讓USER自行維護
# Modify.........: No:FUN-C60061 12/06/18 By bart 自動產生料號後顯示產生哪些料號
# Modify.........: No:MOD-C60188 12/06/22 By bart 修改寫入g_imaa.imaa571的條件
# Modify.........: No.FUN-C60046 12/06/18 By bart sma94控制是否顯示特性料件
# Modify.........: No.TQC-C80034 12/08/06 By qiull 將maauser,maagrup改為imaauser,imaagrup
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C50068 12/11/07 By bart 增加imaa721欄位
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-CB0052 12/11/19 By xianghui 發票倉庫控管改善
# Modify.........: No:CHI-CB0017 12/12/17 By Lori 申請類別為修改時,需將來源的相關文件複製寫入
# Modify.........: No:MOD-D10213 13/01/24 By bart 複製時，簽核欄位應重抓單別設定資料
# Modify.........: No:CHI-CA0073 13/01/30 By pauline 將ima1015用ima1401替代
# Modify.........: No.FUN-D30003 13/03/04 By qiull 新增imaa163/imaa1631，oaz92='Y'(科目二：多帳套)且大陆版时显示
# Modify.........: No.MOD-D30199 13/03/22 By bart 缺,
# Modify.........: No.CHI-CA0056 13/03/22 By bart 成本分群碼預設null
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
# Modify.........: No.FUN-D60083 13/08/27 By yangtt 新增費用科目，費用科目二 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imaa       RECORD LIKE imaa_file.*,
       g_imaa_t     RECORD LIKE imaa_file.*,
       g_imaa_o     RECORD LIKE imaa_file.*,
       g_imaa01_t   LIKE imaa_file.imaa01,
       g_imaano_t   LIKE imaa_file.imaano,
       g_imaicd    RECORD LIKE imaicd_file.*, #FUN-B30043
       g_imaicd_t  RECORD LIKE imaicd_file.*, #FUN-B30043
       g_imaicd_o  RECORD LIKE imaicd_file.*, #FUN-B30043 
       g_ind        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      ind02   LIKE ind_file.ind02,
                      ind03   LIKE ind_file.ind03
                    END RECORD,
       g_ind_t      RECORD                 #程式變數 (舊值)
                      ind02   LIKE ind_file.ind02,
                      ind03   LIKE ind_file.ind03
                    END RECORD,
       g_rec_b      LIKE type_file.num10,   #No.FUN-690026 INTEGER
       g_d2         LIKE imaa_file.imaa26,
       g_cmd        LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(70)
       g_wc         STRING,        
       g_wc2        STRING,        
       g_sql        STRING,
       g_flag       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_flag1      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_imaa906    LIKE imaa_file.imaa906, 
       g_imaa907    LIKE imaa_file.imaa907,
       g_imaa908    LIKE imaa_file.imaa908,
       l_azp03      LIKE azp_file.azp03,
       l_zx07       LIKE zx_file.zx07,
       g_argv1      LIKE imaa_file.imaano,
       g_flag2      LIKE type_file.chr1,    #No:MOD-960126 add
       l_zx09       LIKE zx_file.zx09,
       g_s          LIKE type_file.chr1,          #料件處理狀況  #No.FUN-690026 VARCHAR(1)
       g_sw         LIKE type_file.num5           #No.FUN-690026 SMALLINT
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr,g_chr1        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2              LIKE type_file.chr1    #No.FUN-610013   #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_forupd_sql        STRING
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10,  #No.FUN-690026 INTEGER
       mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT       #No.FUN-6A0061
DEFINE g_gen02             LIKE gen_file.gen02 
DEFINE g_on_change_02      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_on_change_021     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_t1                LIKE smy_file.smyslip  #No.FUN-690026 VARCHAR(5)
DEFINE g_laststage         LIKE type_file.chr1    #FUN-580158
DEFINE g_gev04             LIKE gev_file.gev04    #no.FUN-840018 add
DEFINE  g_show_msg    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          imabdate    LIKE imab_file.imabdate,
                          imabdb      LIKE imab_file.imabdb    
                      END RECORD,
        g_gaq03_f1    LIKE gaq_file.gaq03,
        g_gaq03_f2    LIKE gaq_file.gaq03
 
DEFINE  g_msg2        LIKE type_file.chr1000     #CHAR(100) 
DEFINE   g_str           STRING                 #CHI-780006 add
DEFINE   g_input_itemno  LIKE type_file.chr1   #CHI-840022---add
#No.TQC-B90236 -------------------- add start ---------------------
DEFINE g_imad               RECORD LIKE imad_file.*,
       g_ima                RECORD LIKE ima_file.*,
       g_ima_t              RECORD LIKE ima_file.*
#No.TQC-B90236 -------------------- add end -----------------------
DEFINE g_imaa25_t     LIKE imaa_file.imaa25  #單位舊值  FUN-BB0083 add
DEFINE g_bma                RECORD LIKE bma_file.*   #FUN-C40011

MAIN
   DEFINE l_ica40       LIKE ica_file.ica40 
   DEFINE l_sma120      LIKE sma_file.sma120   #TQC-C60004
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730061
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   LET g_input_itemno = 'N' #CHI-840022--add
   IF g_aza.aza60 !='Y' THEN #不使用廠商申作業
      #參數設定不使用申請作業,所以無法執行此支程式!
      CALL cl_err('','axm-253',1)
      EXIT PROGRAM
   END IF 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0074
 
   LET g_argv1 = ARG_VAL(1)
   IF fgl_getenv('EASYFLOW') = "1" THEN
         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
   INITIALIZE g_imaa.* TO NULL
   INITIALIZE g_imaa_t.* TO NULL
   INITIALIZE g_imaa_o.* TO NULL
   LET g_forupd_sql = " SELECT * FROM imaa_file ",
                     " WHERE imaano = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aimi150_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 5
 
   OPEN WINDOW aimi150_w AT p_row,p_col WITH FORM "aim/42f/aimi150"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_required("imaa01",FALSE) #No:MOD-A10092 add
   CALL cl_set_comp_visible("imaaicd12",FALSE)  #FUN-C30235
   #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
   #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
   CALL aws_efapp_toolbar()    #FUN-580158

  #FUN-D30003---add---str---
   SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
   IF g_aza.aza26='2' AND g_oaz.oaz92='Y' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("imaa163,imaa1631",TRUE)
      ELSE
         CALL cl_set_comp_visible("imaa163",TRUE)
         CALL cl_set_comp_visible("imaa1631",FALSE)
      END IF
   ELSE
       CALL cl_set_comp_visible("imaa163,imaa1631",FALSE)
   END IF
   #FUN-D30003---add---end---

   #FUN-D60083--add--str--
   IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_visible("imaa164,imaa1641",TRUE)
   ELSE
      CALL cl_set_comp_visible("imaa164",TRUE)
      CALL cl_set_comp_visible("imaa1641",FALSE)
   END IF
   #FUN-D60083--add--end--

  IF g_aza.aza50='N' THEN                                                                                                          
     CALL cl_set_comp_visible("page07",FALSE)  
  ELSE                                                                                                                    
     CALL cl_set_comp_visible("page07",TRUE)  
  END IF                                  
  CALL cl_set_comp_visible("Page1", FALSE)          #FUN-B30043
  CALL cl_set_comp_visible("Page2", FALSE)          #FUN-BC0106
   #下面隱藏的欄位是為了要在EasyFlow能夠正確show出,但是實際上aimi150.per主畫面不需要show這些欄位
   CALL cl_set_comp_visible("imaa130,imaa31,imaa44,imaa55,imaa63",FALSE) 
   CALL cl_set_comp_visible("imaa910",g_sma.sma118='Y')
   CALL cl_set_comp_visible("imaaag",g_sma.sma120 = 'Y')
   CALL cl_set_comp_visible("imaa906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("imaa907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("imaa908",g_sma.sma116 MATCHES '[123]')    
   CALL cl_set_comp_visible("group044",g_sma.sma116 MATCHES '[123]' OR g_sma.sma115='Y')    
   CALL cl_set_comp_visible("imaa391",g_aza.aza63='Y')  #FUN-740033
   CALL cl_set_comp_visible("page11",g_sma.sma124!='icd')   #MOD-B30157 add 

   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("imaa907",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("imaa907",g_msg CLIPPED)
   END IF
   #FUN-C60046---begin
   IF g_sma.sma94 = 'Y' THEN
      CALL cl_set_comp_visible("imaa928,imaa929,Group3",TRUE)
      CALL cl_set_act_visible("feature_maintain",TRUE)
   ELSE 
      CALL cl_set_comp_visible("imaa928,imaa929,Group3",FALSE)
      CALL cl_set_act_visible("feature_maintain",FALSE)
   END IF 
   #FUN-C60046---end
   #TQC-C60004---begin
   SELECT sma120 INTO l_sma120 FROM sma_file
   IF l_sma120="Y" THEN
      CALL cl_set_comp_visible("imaa151",TRUE)
   ELSE
      CALL cl_set_comp_visible("imaa151",FALSE)
   END IF
   #TQC-C60004---end
   SELECT zx07,zx09 INTO l_zx07,l_zx09 FROM zx_file
    WHERE zx01 = g_user
   IF SQLCA.sqlcode THEN
      LET l_zx07 = 'N'
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CALL aimi150_q()
   END IF
#FUN-B50106 --------------------Begin---------------------------------
   CALL cl_set_act_visible("icd_processitem",FALSE)   #FUN-BC0106
   CALL cl_set_act_visible("qry_test_item", FALSE) #MOD-C30099
   IF s_industry('icd') THEN
      CALL cl_set_comp_visible("Page1", TRUE)
      CALL cl_set_comp_visible("Page2", TRUE)   #FUN-BC0106
      CALL cl_set_act_visible("qry_test_item", TRUE) #MOD-C30099
      SELECT ica40 INTO l_ica40 FROM ica_file WHERE ica00 = '0'
      #FUN-BC0106 --START mark--
      #IF l_ica40 = 'N' THEN   
      #   CALL cl_set_act_visible("icd_processitem",FALSE)
      #END IF   
      #FUN-BC0106 --END mark--
      CALL cl_set_act_visible("icd_processitem",TRUE)   #FUN-BC0106
      CALL cl_set_comp_visible("imaaicd02,imaaicd03,imaaicd06",FALSE) 
   END IF 
#FUN-B50106 --------------------End-----------------------------------
   LET g_action_choice = ""
   CALL aimi150_menu()
 
   CLOSE WINDOW aimi150_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0074
END MAIN
 
FUNCTION aimi150_curs()

   CLEAR FORM
   CALL g_ind.clear()

   IF cl_null(g_argv1) THEN
      INITIALIZE g_imaa.* TO NULL 
      CONSTRUCT BY NAME g_wc ON 
       imaa00  ,imaano  ,imaa01  ,imaa02  ,imaa021 ,imaa06 ,imaa08 ,imaa13 ,imaa03 ,imaa915, imaa1010,imaa92,imaa926, #FUN-710060 add imaa915       #FUN-AC0083 add imaa926
       imaaag  ,imaa910 ,
   #FUN-B50106 ----------------------Begin------------------------
       imaaicd05,imaaicd01,imaaicd16,imaaicd04,imaaicd10,imaaicd12,
   #   imaaicd14,imaaicd15,imaaicd09,imaaicd08,imaaicd13,imaaicd11,      #FUN-B50096
       imaaicd14,imaaicd15,imaaicd09,imaaicd08,imaaicd17,imaaicd11,                #FUN-B50096 #FUN-BC0103 add imaaicd17   
   #FUN-B50106 ----------------------End--------------------------
       imaaicd18,imaaicd19,imaaicd20,imaaicd21,                          #FUN-BC0103 
       imaa105 ,imaa14  ,imaa107 ,imaa147,imaa109,imaa903,imaa24 ,imaa911, imaa151,         #FUN-930108 add imaa926      #FUN-AC0083 add imaa022,imaa251 mark imaa926 #FUN-B80186   #FUN-C30026 add imaa151  
       imaa07  ,imaa70  ,imaa37  ,imaa51  ,imaa27  ,imaa28 ,imaa271,imaa71 ,
       imaa25  ,imaa35  ,imaa36  ,imaa23  ,
       imaa918,imaa919,imaa920,imaa921,imaa922,imaa923,imaa924,imaa925,   #No.MOD-840160
       imaa928,imaa929,                                                    #TQC-B90236
       imaa906 ,imaa907,imaa908,imaa159,   #FUN-B50096 add imaa159
       imaa12  ,imaa39  ,imaa163,imaa391 ,imaa1631,ima164,ima1641,imaa15  ,imaa905,imaa09 ,imaa10 ,imaa11,imaa022,imaa251,  #FUN-B80186  #FUN-D30003 add>imaa163,imaa1631  #FUN-D60083 add imaa164,imaa1641
       imaa1001,imaa1002,imaa1015,imaa1014,imaa1016,
       imaauser,imaagrup,imaamodu,imaadate,imaaacti,imaaoriu,imaaorig, #TQC-C20075 add
       imaaud01,imaaud02,imaaud03,imaaud04,imaaud05,
       imaaud06,imaaud07,imaaud08,imaaud09,imaaud10,
       imaaud11,imaaud12,imaaud13,imaaud14,imaaud15
       
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 

         ON ACTION controlp
            CASE
               WHEN INFIELD(imaano)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_imaano'
                    LET g_qryparam.state  = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaano
                    NEXT FIELD imaano
               WHEN INFIELD(imaa01) #料件編號    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaa"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa01
                  NEXT FIELD imaa01
               WHEN INFIELD(imaa13) #規格主件
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaa4"     
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "C"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa13
                  NEXT FIELD imaa13
               WHEN INFIELD(imaa06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa06
                  NEXT FIELD imaa06
               WHEN INFIELD(imaaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaag
                  NEXT FIELD imaaag
               WHEN INFIELD(imaa09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa09
                  NEXT FIELD imaa09
               WHEN INFIELD(imaa10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa10
                  NEXT FIELD imaa10
               WHEN INFIELD(imaa11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa11
                  NEXT FIELD imaa11
               WHEN INFIELD(imaa12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa12
                  NEXT FIELD imaa12
               WHEN INFIELD(imaa109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa109
                  NEXT FIELD imaa109

               #FUN-AC0083 ----------add start---------
               WHEN INFIELD(imaa251)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form   = "q_imaa251"   #NO.FUN-B30092 mark
                  LET g_qryparam.form   = "q_gfo"       #NO.FUN-B30092
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa251
                  NEXT FIELD imaa251
               #FUN-AC0083 ----------add end--------- 

               WHEN INFIELD(imaa25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa25
                  NEXT FIELD imaa25
               WHEN INFIELD(imaa34) #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_smh"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa34
                  NEXT FIELD imaa34
               WHEN INFIELD(imaa35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa35
                  NEXT FIELD imaa35
               WHEN INFIELD(imaa36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa36
                  NEXT FIELD imaa36
               WHEN INFIELD(imaa23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa23
                  NEXT FIELD imaa23
               WHEN INFIELD(imaa39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa39
                  NEXT FIELD imaa39
               #FUN-D30003---add---str---
               WHEN INFIELD(imaa163)
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa163
                  NEXT FIELD imaa163
               WHEN INFIELD(imaa1631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1631
                  NEXT FIELD imaa1631
               #FUN-D30003---add---end---
               #FUN-D60083--add--str--
               WHEN INFIELD(imaa164)
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa164
                  NEXT FIELD imaa164
               WHEN INFIELD(imaa1641)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa16341
                  NEXT FIELD imaa1641
               #FUN-D60083--add--end--
               WHEN INFIELD(imaa391)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa391
                  NEXT FIELD imaa391
               WHEN INFIELD(imaa907) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa907
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa907
                  NEXT FIELD imaa907
               WHEN INFIELD(imaa908) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa908
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa908
                  NEXT FIELD imaa908
               WHEN INFIELD(imaa920)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa920
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa920
               WHEN INFIELD(imaa923)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gei2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa923
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa923
#No.TQC-B90236 ---- add start -------
               WHEN INFIELD(imaa929)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imaa929"   #No.MOD-840254  #No.MOD-840294
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa929
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa929
#No.TQC-B90236 ---- add end ---------

#FUN-B50106 -----------------------Begin-----------------------------
               WHEN INFIELD(imaaicd01) #母體料號 
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_imaaicd"         #FUN-B70051
                  LET g_qryparam.form     = "q_imaicd"         #FUN-B70051
                  LET g_qryparam.state    = "c"
                 #LET g_qryparam.where    = " imaaicd05 = '1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NUL) " 
                  #LET g_qryparam.where    = " imaicd05 = '1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL) "     #FUN-B70051  #FUN-C30278
                  LET g_qryparam.where    = " (imaicd04='0' OR imaicd04='1') AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NUL) "    #FUN-C30278
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaicd01 
                  NEXT FIELD imaaicd01                    
         #FUN-B30192--add--begin
               WHEN INFIELD(imaaicd16) 
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_imaaicd" 
                  LET g_qryparam.form     = "q_imaicd"            #FUN-B70051
                  LET g_qryparam.state    = "c"
                  #LET g_qryparam.where    = " imaaicd04 = '4'"     #FUN-B70051
                  LET g_qryparam.where    = " imaicd04 = '1'"     #FUN-B70051
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaicd16 
                  NEXT FIELD imaaicd16                  
         #FUN-B30192--add--end
               WHEN INFIELD(imaaicd10) #作業群組
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_icd11"  
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = 'U'        
                  NEXT FIELD imaicd10                    
                  DISPLAY g_qryparam.multiret TO imaaicd10
                  NEXT FIELD imaaicd10                    
               WHEN INFIELD(imaaicd11) #New Code申請單號   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_icw"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO imaaicd11  
                  NEXT FIELD imaaicd11             
#FUN-B50106 --------------------------End----------------------------
               OTHERWISE EXIT CASE
            END CASE
 
#FUN-B70051-add-str--
         #"查詢測試料件"
         ON ACTION qry_test_item
            CASE
               WHEN INFIELD(imaaicd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaaicd"
                  LET g_qryparam.state    = "c"
                  #LET g_qryparam.where    = " imaaicd05='1'"  #FUN-C30278
                  LET g_qryparam.where    = " imaaicd04='0' OR imaaicd04='1'"   #FUN-C30278
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaicd01
                  NEXT FIELD imaaicd01
               WHEN INFIELD(imaaicd16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaaicd"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where    = " imaaicd04='1'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaicd16
                  NEXT FIELD imaaicd16 
              OTHERWISE
                 CALL cl_err('','aic-327',0)       #TQC-C40084
                 EXIT CASE
           END CASE
                  
#FUN-B70051-add-end--

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
         ON ACTION qbe_select
           CALL cl_qbe_select()
         ON ACTION qbe_save
	   CALL cl_qbe_save()
      END CONSTRUCT
   ELSE
      LET g_wc = "imaano = '",g_argv1,"'"
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF

   #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')  #TQC-C80034  mark
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imaauser', 'imaagrup') #TQC-C80034  add
   LET g_sql = "SELECT imaano FROM imaa_file ", # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED,
               " ORDER BY imaano"
   PREPARE aimi150_prepare FROM g_sql
   DECLARE aimi150_curs SCROLL CURSOR WITH HOLD FOR aimi150_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
   PREPARE aimi150_precount FROM g_sql
   DECLARE aimi150_count CURSOR FOR aimi150_precount
 
END FUNCTION
 
FUNCTION aimi150_menu()
   DEFINE l_flowuser      LIKE type_file.chr1  
   DEFINE l_creator       LIKE type_file.chr1  
   DEFINE l_imabdate      LIKE imab_file.imabdate
   DEFINE l_cmd           LIKE type_file.chr1000,   #No.FUN-690026 VARCHAR(72)
          l_priv1         LIKE zy_file.zy03,        # 使用者執行權限
          l_priv2         LIKE zy_file.zy04,        # 使用者資料權限
          l_priv3         LIKE zy_file.zy05         # 使用部門資料權限
   DEFINE l_sub_imaa01    LIKE imaa_file.imaa01,
          l_sub_imaa02    LIKE imaa_file.imaa02
   DEFINE l_imabdb        LIKE imab_file.imabdb     #TQC-750141 add
   DEFINE l_str     STRING                   #FUN-C60061
   DEFINE l_ima01   LIKE ima_file.ima01      #FUN-C60061
 
   MENU ""
 
      BEFORE MENU
         CALL cl_set_act_visible("add_multi_attr_sub",FALSE)  #No.MOD-5A0223 --add
         CALL cl_navigator_setting(g_curs_index, g_row_count) #No.MOD-880063 add
         IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
             CALL cl_set_act_visible("aps_related_data",FALSE)
         END IF
         #傳入簽核模式時不應執行的 action 清單
         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval,
                                    carry_data,qry_carry_history,unconfirm,quantifying,feature_maintain,icd_processitem") #FUN-C30017 add
               RETURNING g_laststage
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL aimi150_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL aimi150_q()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL aimi150_r()
         END IF
 
         ON ACTION qry_carry_history
            LET g_action_choice = "qry_carry_history"
            IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_imaa.imaa01) THEN
                   SELECT gev04 INTO g_gev04 FROM gev_file
                    WHERE gev01 = '1' AND gev02 = g_plant
                   IF NOT cl_null(g_gev04) THEN
                      LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_imaa.imaa01,'"'
                      CALL cl_cmdrun(l_cmd)
                   END IF
                ELSE
                   CALL cl_err('',-400,0)
                END IF
            END IF
 
      ON ACTION easyflow_approval            
          LET g_action_choice="approval_status"   
          IF cl_chk_act_auth() THEN
            #FUN-C20025 add str---
             SELECT * INTO g_imaa.* FROM imaa_file
              WHERE imaano = g_imaa.imaano
             CALL aimi150_show()
            #FUN-C20025 add end---
             CALL i150_ef()         
             CALL aimi150_show()  #FUN-C20025 add                   
          END IF
 
      ON ACTION approval_status                 
          LET g_action_choice="approval_status"
          IF cl_chk_act_auth() THEN
             IF aws_condition2() THEN
                  CALL aws_efstat2()        
             END IF
          END IF
 
      ON ACTION confirm           
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
             CALL i150_y_chk()          #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                 CALL i150_y_upd()      #CALL 原確認的 update 段
             END IF
         END IF
          
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i150_z()
         END IF
 
      #補料號
      ON ACTION input_itemno
         LET g_action_choice="input_itemno"
         IF cl_chk_act_auth() THEN
             LET g_errno=''
             CASE 
              WHEN g_imaa.imaa1010='2'
                    LET g_errno = 'axm-225'
                    #已拋轉，不可再異動!
              WHEN g_imaa.imaa00 = 'U' 
                    LET g_errno = 'aim-158'
                    #只在申請類別為"新增"時,可使用此Action!
              OTHERWISE
                   LET g_errno=''
             END CASE
             IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_imaa.imaano,g_errno,1)
             ELSE
                 LET g_input_itemno = 'Y'
                 CALL aimi150_u('a')      #No:MOD-970122 modify
                 LET g_input_itemno = 'N'
             END IF
         END IF
 
      #@ON ACTION 資料拋轉
       ON ACTION carry_data
           LET g_action_choice="carry_data"
            IF cl_chk_act_auth() AND     #cl_prichk('7') AND
               NOT cl_null(g_imaa.imaa01) THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               CALL i150_dbs(g_imaa.*)   #No.FUN-7C0010
               #FUN-C60061---begin
               LET l_str = NULL
               DECLARE ima01_c1 CURSOR FOR SELECT imaicd00
                                             FROM imaicd_file
                                            WHERE imaicd11 = g_imaa.imaano
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
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
               #FUN-C40011---begin
               #ICD行業別時,自動產生出來的BOM也要做資料拋轉
               IF s_industry('icd') THEN   
                  LET g_sql = "SELECT bma01,bma06,bma10 FROM bma_file",
                              " WHERE bmaicd01='",g_imaa.imaano CLIPPED,"'",
                              " ORDER BY bma01,bma06"
                  PREPARE i150_bma_p FROM g_sql
                  DECLARE i150_bma_cs CURSOR WITH HOLD FOR i150_bma_p  #FUN-C50132  WITH HOLD
                  
                  FOREACH i150_bma_cs INTO g_bma.bma01,g_bma.bma06,g_bma.bma10  
                     CALL s_abmi600_com_carry(g_bma.bma01,g_bma.bma06,g_bma.bma10,g_plant,1)
                  END FOREACH
               END IF
               #FUN-C40011---end
            ELSE
                #料號為空,請補上料號
                CALL cl_err(g_imaa.imaano,'aim-157','1')
            END IF
            SELECT * INTO g_imaa.* FROM imaa_file 
             WHERE imaano = g_imaa.imaano
            CALL aimi150_show() 
#TQC-B60184  --BEING---ADD 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL aimi150_u('u')      #No:MOD-970122 modify
         END IF
#TQC-B60184  --END--

#TQC-B60128  --BEING---ADD
      ON ACTION first
         CALL aimi150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION previous
         CALL aimi150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION jump
         CALL aimi150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION next
         CALL aimi150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION last
         CALL aimi150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#TQC-B60128  ---END---

#TQC-B60184  ---begin--- add
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i150_show_pic() #圖示
         CALL cl_show_fld_cont()

      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL aimi150_x()
            CALL aimi150_show()
         END IF

     ON ACTION reproduce
        LET g_action_choice="reproduce"
        IF cl_chk_act_auth() THEN
           CALL aimi150_copy()

        END IF

      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i150_out()
         END IF

      ON ACTION help
         CALL cl_show_help()
#TQC-B60184  ---END---
 
      ON ACTION exit
         LET g_action_choice='exit'
         EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
      #庫存
      ON ACTION inventory
         LET g_msg="aimi151 '",g_imaa.imaano,"'"
         CALL cl_cmdrun_wait(g_msg) 
         SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
         CALL aimi150_show()
 
     
#NO.FUN-B30092  ------------------------add start------------------------
      #量化
      ON ACTION quantifying
         LET g_msg="aooi104 '",g_imaa.imaano,"'"
         CALL cl_cmdrun_wait(g_msg)
         SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
         CALL aimi150_show()
#NO.FUN-B30092 --------------------------add end------------------------

      #銷售
      ON ACTION sales
         LET g_action_choice="sales"
            LET g_cmd = "aimi152 '",g_imaa.imaano,"'"
            CALL  cl_cmdrun_wait(g_cmd) 
         SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
         CALL aimi150_show()
 
      #採購
      ON ACTION purchase
            LET g_action_choice="purchase"
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi153 '",g_imaa.imaano,"' '",g_flag1,"'"
            CALL cl_cmdrun_wait(g_msg) 
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
            CALL aimi150_show()
 
      #生管
      ON ACTION production
            LET g_action_choice="production"
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi154 '",g_imaa.imaano,"'"
            CALL cl_cmdrun_wait(g_msg) 
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
            CALL aimi150_show()
 
      #成本
      ON ACTION cost
            LET g_action_choice="cost"
            LET l_priv1=g_priv1
            LET l_priv2=g_priv2
            LET l_priv3=g_priv3
            LET g_msg="aimi155 '",g_imaa.imaano,"'"
            CALL cl_cmdrun_wait(g_msg) 
            LET g_priv1=l_priv1
            LET g_priv2=l_priv2
            LET g_priv3=l_priv3
            SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
            CALL aimi150_show()
 
#TQC-B60128---BEGIN---MARK
#     #No.TQC-B60177--add--
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()
#     #No.TQC-B60177--end--
#TQC-B60128---end--

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
         LET g_action_choice='exit'
         CONTINUE MENU
 
        #"准"
        ON ACTION agree
            LET g_action_choice="agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL i150_y_upd()      #CALL 原確認的 update 段
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
                          IF NOT cl_null(g_argv1) THEN
                                CALL aimi150_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete, reproduce, detail, query, locale,
                                void,confirm, undo_confirm,easyflow_approval,
                                    carry_data,qry_carry_history,unconfirm,quantifying,feature_maintain,icd_processitem") #FUN-C30017 add
                                      RETURNING g_laststage
                          ELSE
                              EXIT MENU
                          END IF
                        ELSE
                            EXIT MENU
                        END IF
                    ELSE
                        EXIT MENU
                    END IF
              END IF
 
         #"不准"
         ON ACTION deny
            LET g_action_choice="deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_imaa.imaa1010 = 'R'
                      DISPLAY BY NAME g_imaa.imaa1010
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL aimi150_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,reproduce, detail, query, locale,void,
                                confirm, undo_confirm,easyflow_approval,
                                    carry_data,qry_carry_history,unconfirm,quantifying,feature_maintain,icd_processitem") #FUN-C30017 add
                                      RETURNING g_laststage
                          ELSE
                                 EXIT MENU
                          END IF
                      ELSE
                             EXIT MENU
                      END IF
                   ELSE
                       EXIT MENU
                   END IF
                END IF
              END IF
            #END IF
 
         #@WHEN "加簽"
         ON ACTION modify_flow
            LET g_action_choice="modify_flow"
              IF aws_efapp_flowuser() THEN
                 LET g_laststage = 'N'
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #"撤簽"
         ON ACTION withdraw
            LET g_action_choice="withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
 
         #"抽單"
         ON ACTION org_withdraw
            LET g_action_choice="org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
#No.TQC-B90236 ---------------------- add start -------------------
         ON ACTION feature_maintain     #特性維護
               IF cl_chk_act_auth() AND g_imaa.imaa01 IS NOT NULL THEN
                  #CALL aimi150_add(g_imaa.imaa01,g_imaa.imaa918,g_imaa.imaa928,g_imaa.imaa929)#FUN-C30017 mark
                  #FUN-C30017---add---str---
                   IF g_imaa.imaa1010 NOT MATCHES '[Ss]' THEN 
                       CALL aimi150_add(g_imaa.imaa01,g_imaa.imaa918,g_imaa.imaa928,g_imaa.imaa929)
                   ELSE
                       CALL cl_err('','mfg3557',0) #本單據目前已送簽或已核准
                   END IF
                  #FUN-C30017---add---end---
               END IF
#No.TQC-B90236 ---------------------- add end ---------------------
        #"簽核意見"
         ON ACTION phrase
            LET g_action_choice="phrase"
              CALL aws_efapp_phrase()

       #FUN-BC0106 --START--
       ON ACTION icd_processitem
          LET g_action_choice = "icd_processitem"
          IF cl_chk_act_auth() THEN                                                        
             LET l_cmd = "aici020 '",g_imaa.imaaicd01,"' ' '"                          
             CALL cl_cmdrun_wait(l_cmd)                                       
          END IF
       #FUN-BC0106 --END--
 
        #相關文件"
        ON ACTION related_document                          #No.FUN-680046
           LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imaa.imaano IS NOT NULL THEN
                  LET g_doc.column1 = "imaano"
                  LET g_doc.value1 = g_imaa.imaano
                  CALL cl_doc()
              END IF
           END IF
#FUN-B30192--mark
#&ifdef ICD
#      ON ACTION icd_base_data
#         IF NOT cl_null(g_imaa.imaa01) THEN
#            LET g_action_choice="icd_base_data"
#            IF cl_chk_act_auth() THEN
#               LET g_msg="aici001 '",g_imaa.imaa01,"'"
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#      ON ACTION icd_maskgroup
#         IF NOT cl_null(g_imaa.imaa01) THEN
#            LET g_action_choice="icd_maskgroup"
#            IF cl_chk_act_auth() THEN
#               SELECT icb02 INTO g_icb02 FROM icb_file,imaicd_file   
#                 WHERE imaicd00 = g_imaa.imaa01 AND icb01 = imaicd01   
#               LET g_msg="aici004 '",g_icb02,"'"   
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#      ON ACTION icd_processitem
#         IF NOT cl_null(g_imaa.imaa01) THEN
#            LET g_action_choice="icd_processitem"
#            IF cl_chk_act_auth() THEN
#               SELECT imaicd01 INTO g_imaicd.imaicd01 FROM imaicd_file   
#                 WHERE imaicd00 = g_imaa.imaa01                            
#             # LET g_msg="aici020 '",g_imaicd.imaicd01,"'"       #MOD-B30519        
#               LET g_msg="aici020 '",g_imaicd.imaicd01,"' ''"    #MOD-B30519            
#               CALL cl_cmdrun_wait(g_msg)
#            END IF
#         END IF
#&endif
#FUN-B30192--mark 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE          
         LET g_action_choice = "exit"
         EXIT MENU
 
      &include "qry_string.4gl"
 
   END MENU
 
   CLOSE aimi150_curs
 
END FUNCTION
 
FUNCTION aimi150_carry_data()
 DEFINE l_imabdate      LIKE imab_file.imabdate                  
 DEFINE l_imabdb        LIKE imab_file.imabdb                    
 
          LET g_sql= "SELECT imabdate,imabdb ",
                     "  FROM imab_file ",
                     " WHERE imabtype= '1' ",
                     "   AND imabno= '",g_imaa.imaano CLIPPED,"'"
          
          DECLARE i150_carry_data CURSOR FROM g_sql
          OPEN i150_carry_data 
          LET g_i = 1
          FOREACH i150_carry_data INTO l_imabdate,l_imabdb 
             LET g_show_msg[g_i].imabdate = l_imabdate
             LET g_show_msg[g_i].imabdb   = l_imabdb
             LET g_i = g_i + 1
          END FOREACH
 
          LET g_msg = NULL
          LET g_msg2= NULL
          LET g_gaq03_f1 = NULL
          LET g_gaq03_f2 = NULL
          CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
          CALL cl_get_feldname('imabdate',g_lang) RETURNING g_gaq03_f1
          CALL cl_get_feldname('imabdb',g_lang) RETURNING g_gaq03_f2
          LET g_msg2 = g_gaq03_f1 CLIPPED,'|',g_gaq03_f2 CLIPPED
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg         ,g_msg2)
 
END FUNCTION
 
FUNCTION imaa_default()
 
   LET g_imaa.imaa00 ='I'   #新增
   LET g_imaa.imaa1010 ='0' #0:開立
   LET g_imaa.imaa92 ='N'   #不需簽核
   LET g_imaa.imaa07 = 'A'
   LET g_imaa.imaa08 = 'P'
   LET g_imaa.imaa108= 'N'
   LET g_imaa.imaa14 = 'N'
   LET g_imaa.imaa903= 'N' 
   LET g_imaa.imaa905= 'N'
   LET g_imaa.imaa15 = 'N'
   LET g_imaa.imaa16 = 99
   LET g_imaa.imaa18 = 0
   LET g_imaa.imaa09 = ' '
   LET g_imaa.imaa10 = ' '
   LET g_imaa.imaa11 = ' '
   #LET g_imaa.imaa12 = ' '  #CHI-CA0056
   LET g_imaa.imaa12 = ''  #CHI-CA0056
   LET g_imaa.imaa23 = ' '
   LET g_imaa.imaa24 = 'N'
   LET g_imaa.imaa911= 'N'   
   LET g_imaa.imaa022 = 0       #FUN-AC0083 add 
   LET g_imaa.imaa926= 'N'      #FUN-930108 add
   LET g_imaa.imaa26 = 0
   LET g_imaa.imaa261= 0
   LET g_imaa.imaa262= 0
   LET g_imaa.imaa27 = 0
   LET g_imaa.imaa271= 0
   LET g_imaa.imaa28 = 0
   LET g_imaa.imaa30 = g_today 
   LET g_imaa.imaa31_fac = 1
   LET g_imaa.imaa32 = 0
   LET g_imaa.imaa33 = 0
   LET g_imaa.imaa37 = '0'
   LET g_imaa.imaa38 = 0
   LET g_imaa.imaa40 = 0
   LET g_imaa.imaa41 = 0
   LET g_imaa.imaa42 = '0'
   LET g_imaa.imaa44_fac = 1
   LET g_imaa.imaa45 = 0
   LET g_imaa.imaa46 = 0
   LET g_imaa.imaa47 = 0
   LET g_imaa.imaa48 = 0
   LET g_imaa.imaa49 = 0
   LET g_imaa.imaa491 = 0
   LET g_imaa.imaa50 = 0
   LET g_imaa.imaa51 = 1
   LET g_imaa.imaa52 = 1
   LET g_imaa.imaa140 = 'N'
   LET g_imaa.imaa53 = 0
   LET g_imaa.imaa531 = 0
   LET g_imaa.imaa55_fac = 1
   LET g_imaa.imaa56 = 1
   LET g_imaa.imaa561 = 1  #最少生產數量
   LET g_imaa.imaa562 = 0  #生產時損耗率
   LET g_imaa.imaa57 = 0
   LET g_imaa.imaa58 = 0
   LET g_imaa.imaa59 = 0
   LET g_imaa.imaa60 = 0
   LET g_imaa.imaa601 = 0  #FUN-8C0086 add
   LET g_imaa.imaa61 = 0
   LET g_imaa.imaa62 = 0
   LET g_imaa.imaa63_fac = 1
   LET g_imaa.imaa64 = 1
   LET g_imaa.imaa641 = 1   #最少發料數量
   LET g_imaa.imaa65 = 0
   LET g_imaa.imaa66 = 0
   LET g_imaa.imaa68 = 0
   LET g_imaa.imaa69 = 0
   LET g_imaa.imaa70 = 'N'
   LET g_imaa.imaa107= 'N'
   LET g_imaa.imaa147= 'N' 
   LET g_imaa.imaa71 = 0
   LET g_imaa.imaa72 = 0
   LET g_imaa.imaa721 = 0  #CHI-C50068
   LET g_imaa.imaa75 = ''
   LET g_imaa.imaa76 = ''
   LET g_imaa.imaa77 = 0
   LET g_imaa.imaa78 = 0
   LET g_imaa.imaa80 = 0
   LET g_imaa.imaa81 = 0
   LET g_imaa.imaa82 = 0
   LET g_imaa.imaa83 = 0
   LET g_imaa.imaa84 = 0
   LET g_imaa.imaa85 = 0
   LET g_imaa.imaa852= 'N'
   LET g_imaa.imaa853= 'N'
   LET g_imaa.imaa871 = 0
   LET g_imaa.imaa86_fac = 1
   LET g_imaa.imaa873 = 0
   LET g_imaa.imaa88 = 1
   LET g_imaa.imaa91 = 0
   LET g_imaa.imaa93 = "NNNNNNNN"
   LET g_imaa.imaa94 = ''
   LET g_imaa.imaa95 = 0
   LET g_imaa.imaa96 = 0
   LET g_imaa.imaa97 = 0
   LET g_imaa.imaa98 = 0
   LET g_imaa.imaa99 = 0
   LET g_imaa.imaa100 = 'N'
   LET g_imaa.imaa101 = '1'
   LET g_imaa.imaa102 = '1'
   LET g_imaa.imaa103 = '0'
   LET g_imaa.imaa104 = 0
   LET g_imaa.imaa910 = ' '  
   LET g_imaa.imaa105 = 'N'
   LET g_imaa.imaa110 = '1'
   LET g_imaa.imaa139 = 'N'
   LET g_imaa.imaaacti= 'Y'                   #有效的資料
   LET g_imaa.imaauser= g_user
   LET g_imaa.imaaoriu = g_user #FUN-980030
   LET g_imaa.imaaorig = g_grup #FUN-980030
   LET g_imaa.imaagrup= g_grup                #使用者所屬群
   LET g_imaa.imaadate= g_today
   LET g_imaa.imaa901 = g_today               #料件建檔日期
   LET g_imaa.imaa912 = 0   
   #產品資料
   LET g_imaa.imaa130 = '1'
   LET g_imaa.imaa121 = 0
   LET g_imaa.imaa122 = 0
   LET g_imaa.imaa123 = 0
   LET g_imaa.imaa124 = 0
   LET g_imaa.imaa125 = 0
   LET g_imaa.imaa126 = 0
   LET g_imaa.imaa127 = 0
   LET g_imaa.imaa128 = 0
   LET g_imaa.imaa129 = 0
   LET g_imaa.imaa141 = '0'
   LET g_imaa.imaa1001 = ''                                                                                                           
   LET g_imaa.imaa1002 = ''                                                                             
   LET g_imaa.imaa1014 = '1' 
   LET g_imaa.imaa159 = '3'    #FUN-B90035
#FUN-B50106 ----Begin-------
   #IF s_industry('icd') THEN  #TQC-C20137  mark
      LET g_imaa.imaaicd04 = '9'
      #LET g_imaa.imaaicd05 = '6'   #FUN-C30278
      LET g_imaa.imaaicd05 = '5'    #FUN-C30278
      LET g_imaa.imaaicd08 = 'N'
      LET g_imaa.imaaicd09 = 'N'
      LET g_imaa.imaaicd13 = 'N'  #MOD-C30206
      LET g_imaa.imaaicd14 = '0'
      LET g_imaa.imaaicd15 = '0'    #TQC-C20137
      LET g_imaa.imaaicd17 = '3'   #FUN-BC0103      
   #END IF                     #TQC-C20137  mark
#FUN-B50106 ----End----------
   #單位控制部分
   IF g_sma.sma115 = 'Y' THEN #使用多單位
      #sma122:1:母子單位
      #       2:參考單位
      #       3:兩者
      IF g_sma.sma122 MATCHES '[13]' THEN
         LET g_imaa.imaa906 = '2' #母子
      ELSE
         LET g_imaa.imaa906 = '3' #參考
      END IF
   ELSE
      LET g_imaa.imaa906 = '1'    #單一
   END IF
   LET g_imaa.imaa909 = 0
 
   #批/序號資料
   LET g_imaa.imaa918 = "N"
   LET g_imaa.imaa919 = "N"  #TQC-A10017
   LET g_imaa.imaa921 = "N"
   LET g_imaa.imaa922 = "N"  #TQC-A10017
   LET g_imaa.imaa924 = "N"
   LET g_imaa.imaa925 = "1"
   LET g_imaa.imaa151 = "N"   #FUN-BC0103 
   LET g_imaa.imaa154 = " "   #FUN-BC0103

END FUNCTION
 
FUNCTION aimi150_a()
   DEFINE   li_result        LIKE type_file.num5                    
DEFINE l_imzicd79   LIKE imz_file.imzicd79  #FUN-980063
   LET g_wc = NULL
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_ind.clear()
   INITIALIZE g_imaa.*   LIKE imaa_file.*
   INITIALIZE g_imaa_t.* LIKE imaa_file.*
   LET g_imaa01_t = NULL
   LET g_imaano_t = NULL
   LET g_imaa_o.*=g_imaa.* 
   LET g_imaa.imaa928= 'N'    #TQC-B90236 add  
   CALL imaa_default()
   CALL cl_opmsg('a')
 
   WHILE TRUE
      INITIALIZE g_imaa_o.*  TO NULL
      CALL aimi150_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_imaa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_ind.clear()
         EXIT WHILE
      END IF
 
      IF g_imaa.imaano IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF g_imaa.imaa31 IS NULL THEN
         LET g_imaa.imaa31=g_imaa.imaa25
         LET g_imaa.imaa31_fac=1
      END IF
 
      IF g_imaa.imaa133 IS NULL THEN
         LET g_imaa.imaa133 = g_imaa.imaa01
      END IF
 
      IF g_imaa.imaa571 IS NULL THEN
         LET g_imaa.imaa571 = g_imaa.imaa01
      END IF
 
      IF g_imaa.imaa44 IS NULL OR g_imaa.imaa44=' ' THEN
         LET g_imaa.imaa44=g_imaa.imaa25   #採購單位
         LET g_imaa.imaa44_fac=1
      END IF
 
      IF g_imaa.imaa55 IS NULL OR g_imaa.imaa55=' ' THEN
         LET g_imaa.imaa55=g_imaa.imaa25   #生產單位
         LET g_imaa.imaa55_fac=1
      END IF
 
      IF g_imaa.imaa63 IS NULL OR g_imaa.imaa63=' ' THEN
         LET g_imaa.imaa63=g_imaa.imaa25   #發料單位
         LET g_imaa.imaa63_fac=1
      END IF
 
      LET g_imaa.imaa86=g_imaa.imaa25   #庫存單位=成本單位
      LET g_imaa.imaa86_fac=1
 
      IF g_imaa.imaa35 IS NULL THEN
         LET g_imaa.imaa35=' ' 
      END IF
 
      IF g_imaa.imaa36 IS NULL THEN
         LET g_imaa.imaa36=' '
      END IF
 
      IF g_imaa.imaa910 IS NULL THEN
         LET g_imaa.imaa910=' ' 
      END IF
 
      IF g_imaa.imaa926 IS NULL THEN
         LET g_imaa.imaa926='N' 
      END IF
      IF g_imaa.imaa922 IS NULL THEN
         LET g_imaa.imaa922='N' 
      END IF
      LET g_imaa.imaa913 = "N"
      
      #MOD-AC0330-----start------
      IF g_imaa.imaa26 IS NULL THEN
         LET g_imaa.imaa26 = 0 
      END IF
 
      IF g_imaa.imaa261 IS NULL THEN
         LET g_imaa.imaa261 = 0 
      END IF
      
      IF g_imaa.imaa262 IS NULL THEN
         LET g_imaa.imaa262 = 0 
      END IF
      #MOD-AC0330------end--------      
      
      #FUN-AC0083 ---------add start-------
      IF cl_null(g_imaa.imaa022) THEN
         LET g_imaa.imaa022 = 0 
      END IF 
      #FUN-AC0083 --------add end---------- 

      BEGIN WORK    
 
      CALL s_auto_assign_no("aim",g_imaa.imaano,g_imaa.imaadate,"Z","imaa_file","imaano","","","") RETURNING li_result,g_imaa.imaano
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_imaa.imaano
      IF cl_null(g_imaa.imaa01) THEN
          LET g_imaa.imaa01 = ' '
      END IF
      LET g_imaa.imaaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_imaa.imaaorig = g_grup      #No.FUN-980030 10/01/04
      LET g_imaa.imaa120 = '1'          #No.FUN-A90049 
#FUN-B50106 -----------------------Begin-----------------------lixh1
      IF cl_null(g_imaa.imaaicd04) THEN
         LET g_imaa.imaaicd04 = ' '
      END IF  
      IF cl_null(g_imaa.imaaicd05) THEN
         LET g_imaa.imaaicd05 = ' '
      END IF
      IF cl_null(g_imaa.imaaicd08) THEN
         LET g_imaa.imaaicd08 = 'N'
      END IF
      IF cl_null(g_imaa.imaaicd09) THEN
         LET g_imaa.imaaicd09 = 'N'
      END IF
      IF cl_null(g_imaa.imaaicd13) THEN #MOD-C30206
         LET g_imaa.imaaicd13 = 'N'     #MOD-C30206
      END IF                            #MOD-C30206
      IF cl_null(g_imaa.imaaicd14) THEN
         LET g_imaa.imaaicd14 = 0
      END IF
      IF cl_null(g_imaa.imaaicd15) THEN
         LET g_imaa.imaaicd15 = 0
      END IF
#FUN-B50106 -----------------------End------------------------
      IF cl_null(g_imaa.imaa159) THEN    #FUN-B90035
         LET g_imaa.imaa159 = '3'        #FUN-B90035
      END IF                             #FUN-B90035
#TQC-C30184-----add---begin---------------
      IF cl_null(g_imaa.imaaicd17) THEN
         LET g_imaa.imaaicd17 = '3'
      END IF
#TQC-C30184-----end------------------------
      INSERT INTO imaa_file VALUES(g_imaa.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,
                      "","",1)  
         ROLLBACK WORK    
         CONTINUE WHILE
      ELSE             
         LET g_imaa_t.* = g_imaa.*                # 保存上筆資料
         SELECT imaano INTO g_imaa.imaano FROM imaa_file
          WHERE imaano = g_imaa.imaano
      END IF

      IF g_imaa.imaa00 = 'U' THEN   #CHI-CB0017 add
         CALL i150_copy_refdoc()    #CHI-CB0017 add
      END IF                        #CHI-CB0017 add

      CALL cl_flow_notify(g_imaa.imaano,'I')     #No.MOD-790149 add
      COMMIT WORK
      CALL cl_err("","aim-005",0) #執行成功！  #MOD-840160
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i150_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF g_imaa.imaa00='I' THEN #新增
      CALL cl_set_comp_entry("imaa06 ,imaa08 ,imaa13 ,imaa03,imaa915",TRUE)  #FUN-710060 add imaa915
      CALL cl_set_comp_entry("imaaag  ,imaa910 ,imaa105 ,imaa14  ,imaa107 ,imaa147,imaa109,imaa903,imaa24 ,imaa911,imaa926",TRUE)   #FUN-930108 add imaa926        
      CALL cl_set_comp_entry("imaa07  ,imaa70  ,imaa37  ,imaa51  ,imaa27  ,imaa28 ,imaa271,imaa71",TRUE)
      CALL cl_set_comp_entry("imaa25  ,imaa35  ,imaa36  ,imaa23  ,imaa906 ,imaa907,imaa908",TRUE)
      CALL cl_set_comp_entry("imaa12  ,imaa39  ,imaa391 ,imaa15  ,imaa09  ,imaa10 ,imaa11",TRUE)
      CALL cl_set_comp_entry("imaa1001,imaa1002,imaa1015,imaa1014,imaa1016",TRUE)
      CALL cl_set_comp_entry("imaa02,imaa021",TRUE)
      CALL cl_set_comp_entry("imaa918,imaa919,imaa920,imaa921,imaa922",TRUE)   #No.MOD-840160
      CALL cl_set_comp_entry("imaa923,imaa924,imaa925",TRUE)   #No.MOD-840160
      CALL cl_set_comp_entry("imaa022,imaa251",TRUE)           #No.FUN-AC0083
      CALL cl_set_comp_entry("imaa159",TRUE)  #TQC-C60004
   END IF
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN       
      CALL cl_set_comp_entry("imaa00,imaano,imaa01,imaa25,imaa910,imaa55",TRUE) 
      CALL cl_set_comp_visible("imaaag",g_sma.sma120 = 'Y' )  
   END IF
 
      CALL cl_set_comp_entry("imaa13,imaa903",TRUE)
 
   IF (NOT g_before_input_done) THEN  #單位控制方式/計價單位 
      CALL cl_set_comp_entry("imaa906,imaa907,imaa908",TRUE)
   END IF
 
   IF INFIELD(imaa906) OR (NOT g_before_input_done) THEN  #第二單位 
      CALL cl_set_comp_entry("imaa907",TRUE)
   END IF
   CALL cl_set_comp_entry("imaa918,imaa919,imaa920,imaa921",TRUE)   #MOD-A50099 add
   CALL cl_set_comp_entry("imaa922,imaa923,imaa924,imaa925",TRUE)   #MOD-A50099 add
   #MOD-C30091---begin
   #CALL cl_set_comp_entry("imaa922,imaa923,imaa924,imaa925",TRUE)   #MOD-A50099 ---ADD
   CALL cl_set_comp_entry("imaa922,imaa923,imaa924",TRUE)
   IF g_imaa.imaa918 = 'Y' OR g_imaa.imaa921 = 'Y' THEN 
      CALL cl_set_comp_entry("imaa925",TRUE)  
   ELSE 
      CALL cl_set_comp_entry("imaa925",FALSE) 
   END IF 
   #MOD-C30091---end
#FUN-B50106 -----------------Begin---------------------------
   IF s_industry('icd') THEN
      IF g_imaa.imaaicd04 = '0' OR g_imaa.imaaicd04 = '1' OR g_imaa.imaaicd04 = '2' THEN #FUN-C30278
         CALL cl_set_comp_entry("imaaicd14",TRUE)
      END IF
      CALL cl_set_comp_entry("imaaicd08",TRUE)
      CALL cl_set_comp_entry("imaaicd17,imaaicd18,imaaicd19,imaaicd20,imaaicd21",TRUE) #FUN-BC0103
   END IF
#FUN-B50106 -----------------End-----------------------------
END FUNCTION
 
FUNCTION i150_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE li_count  LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE lc_sql    STRING   
   DEFINE l_errno   STRING  
   DEFINE l_n       LIKE type_file.num5

   IF g_imaa.imaa00='U' OR g_input_itemno = 'Y' THEN #修改
      CALL cl_set_comp_entry("imaa06 ,imaa08 ,imaa13 ,imaa03,imaa915",FALSE)  #FUN-710060 add
      CALL cl_set_comp_entry("imaaag  ,imaa910 ,imaa105 ,imaa14  ,imaa107 ,imaa147,imaa109,imaa903,imaa24 ,imaa911,imaa926",FALSE)    #FUN-930108 add imaa926     
      CALL cl_set_comp_entry("imaa07  ,imaa70  ,imaa37  ,imaa51  ,imaa27  ,imaa28 ,imaa271,imaa71",FALSE)
      CALL cl_set_comp_entry("imaa25  ,imaa35  ,imaa36  ,imaa23  ,imaa906 ,imaa907,imaa908",FALSE)
      CALL cl_set_comp_entry("imaa12  ,imaa39  ,imaa391 ,imaa15  ,imaa09  ,imaa10 ,imaa11",FALSE)
      CALL cl_set_comp_entry("imaa1001,imaa1002,imaa1015,imaa1014,imaa1016",FALSE)
      CALL cl_set_comp_entry("imaa918,imaa919,imaa920,imaa921,imaa922",FALSE)   #No.MOD-840160
      CALL cl_set_comp_entry("imaa923,imaa924,imaa925",FALSE)   #No.MOD-840160
      CALL cl_set_comp_entry("imaa022,imaa251",FALSE)           #No.FUN-AC0083 
      CALL cl_set_comp_entry("imaa159",FALSE)        #FUN-B90035
     #FUN-B50106 ----------Begin----------
      IF s_industry('icd') THEN
         CALL cl_set_comp_entry("imaaicd01,imaaicd02,imaaicd03,imaaicd04,imaaicd05,imaaicd06,imaaicd08,imaaicd09, 
                                 imaaicd10,imaaicd11,imaaicd12,imaaicd14,imaaicd15,imaaicd16",FALSE)  #FUN-B50096 mark imaaicd13 
      END IF 
     #FUN-B50106 ----------End------------
      IF g_input_itemno = 'Y' THEN
          CALL cl_set_comp_entry("imaa02,imaa021",FALSE)
          #TQC-C60004---begin
          IF s_industry('icd') THEN 
             IF g_imaa.imaaicd04 = '0' THEN
                CALL cl_set_comp_entry("imaaicd01",FALSE)
             ELSE
                CALL cl_set_comp_entry("imaaicd01",TRUE)
             END IF 
          END IF 
          #TQC-C60004---end
      END IF
   END IF
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imaa00,imaano",FALSE)
      IF g_imaa.imaa00 = 'U' THEN #申請類別U:修改時,不能改料件編號
          CALL cl_set_comp_entry("imaa01",FALSE)
      END IF
   END IF
 
#lixh1-------- 
     IF g_imaa.imaa08 != 'T' THEN
         CALL cl_set_comp_entry("imaa13",FALSE)
      END IF
      IF NOT (g_sma.sma104 = 'Y' AND g_imaa.imaa08 MATCHES "[MT]") THEN
         CALL cl_set_comp_entry("imaa903",FALSE)
      END IF
 
   IF NOT g_before_input_done THEN
      IF g_sma.sma118 !='Y' THEN
         CALL cl_set_comp_entry("imaa910",FALSE)
      END IF
 
      IF g_sma.sma115 = 'N' THEN
         LET g_imaa.imaa906 = '1'
         LET g_imaa.imaa907 = NULL
         DISPLAY BY NAME g_imaa.imaa906,g_imaa.imaa907
         CALL cl_set_comp_entry("imaa906,imaa907",FALSE)
      ELSE
         IF cl_null(g_imaa.imaa907) THEN
            LET g_imaa.imaa907 = g_imaa.imaa25
            DISPLAY BY NAME g_imaa.imaa907
         END IF
      END IF
 
      IF g_sma.sma116 = '0' THEN    #0:不使用計價單位
         LET g_imaa.imaa908 = NULL
         DISPLAY BY NAME g_imaa.imaa908
         CALL cl_set_comp_entry("imaa908",FALSE)
      ELSE
         IF cl_null(g_imaa.imaa908) THEN
            LET g_imaa.imaa908 = g_imaa.imaa25
            DISPLAY BY NAME g_imaa.imaa908
         END IF
      END IF
   END IF
 
   IF (p_cmd = 'u' )AND( g_sma.sma120 = 'Y')  THEN
      IF g_imaa.imaaag = '@CHILD' THEN
         CALL cl_set_comp_visible("imaaag",FALSE)
      ELSE
         #如果該料件已經包含了子料件則不允許修改他的屬性群組
         LET lc_sql = "SELECT COUNT(*) FROM imaa_file WHERE imaaag = '@CHILD' ",
                      "AND imaaag1 = '",g_imaa.imaaag,"' AND imaa01 LIKE '",
                      g_imaa.imaa01,"%' "
 
         DECLARE lcurs_qry_imaa CURSOR FROM lc_sql
 
         OPEN lcurs_qry_imaa
         FETCH lcurs_qry_imaa INTO li_count
         IF li_count > 0 THEN
            CALL cl_set_comp_visible("imaaag",FALSE)
         ELSE
            CALL cl_set_comp_visible("imaaag",g_sma.sma120 = 'Y')
         END IF
         CLOSE lcurs_qry_imaa
      END IF
   END IF
#TQC-C40037--mark--str--
  #No.TQC-B90236--------------add-------------begin---
  # IF g_imaa.imaa00='U' THEN
  #    CALL cl_set_comp_entry("imaa928,imaa929",FALSE)
  # ELSE
  #    CALL cl_set_comp_entry("imaa928,imaa929",TRUE)
  # END IF
  ##IF (p_cmd = 'u' )AND(g_imaa.imaa928='Y') THEN   #MOD-C30207  mark
  # IF g_imaa.imaa928='Y' THEN                      #MOD-C30207  add
  #    CALL cl_set_comp_entry("imaa929",FALSE)
  #    LET g_imaa.imaa929=''
  #    DISPLAY g_imaa.imaa929 TO imaa929
  # ELSE
  #    CALL cl_set_comp_entry("imaa929",TRUE)
  # END IF
  #No.TQC-B90236--------------add-------------end-----   
#TQC-C40037--mark--end--
#TQC-C40037--add--str--
   IF g_imaa.imaa00='U' THEN
      CALL cl_set_comp_entry("imaa928,imaa929",FALSE)
   ELSE
      CALL cl_set_comp_entry("imaa928,imaa929",TRUE)
      IF g_imaa.imaa928='Y' THEN              
         CALL cl_set_comp_entry("imaa929",FALSE)
         LET g_imaa.imaa929=''
         DISPLAY g_imaa.imaa929 TO imaa929
      END IF
   END IF
#TQC-C40037--add--end--
   IF g_imaa.imaa906 = '1' THEN
      LET g_imaa.imaa907 = NULL
      DISPLAY BY NAME g_imaa.imaa907
      CALL cl_set_comp_entry("imaa907",FALSE)
   END IF
 
   IF g_imaa.imaa918 = 'N' THEN
      CALL cl_set_comp_entry("imaa919",FALSE) #MOD-A50099 mod
   ELSE                                       #MOD-A50099 add
      CALL cl_set_comp_entry("imaa919",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_imaa.imaa919 = 'N' THEN
      CALL cl_set_comp_entry("imaa920",FALSE)
   ELSE                                       #MOD-A50099 add
      CALL cl_set_comp_entry("imaa920",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_imaa.imaa921 = 'N' THEN
      CALL cl_set_comp_entry("imaa922,imaa924",FALSE) #MOD-A50099 mod
   ELSE                                               #MOD-A50099 add
      CALL cl_set_comp_entry("imaa922,imaa924",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_imaa.imaa922 = 'N' THEN
      CALL cl_set_comp_entry("imaa923",FALSE)
   ELSE                                       #MOD-A50099 add
      CALL cl_set_comp_entry("imaa923",TRUE)  #MOD-A50099 add
   END IF
 
   IF g_imaa.imaa918 = 'N' AND g_imaa.imaa921 = 'N' THEN
      CALL cl_set_comp_entry("imaa925",FALSE)
   ELSE                                       #MOD-A50099 add
      CALL cl_set_comp_entry("imaa925",TRUE)  #MOD-A50099 add
   END IF
   IF s_industry('icd') THEN
      IF g_imaa.imaaicd04 <> '0' AND g_imaa.imaaicd04 <> '1' AND g_imaa.imaaicd04 <> '2' THEN   #FUN-C30278
         CALL cl_set_comp_entry("imaaicd14",FALSE)
         LET g_imaa.imaaicd14 = 0
      END IF
      #FUN-BC0103 --START--
      IF g_imaa.imaaicd04 <> '3' THEN
         CALL cl_set_comp_entry("imaaicd17",FALSE)
      END IF 
      IF g_imaa.imaaicd17 <> '2' THEN
         CALL cl_set_comp_entry("imaaicd18,imaaicd19,imaaicd20,imaaicd21",FALSE)
      END IF 
      #FUN-BC0103 --END--
   END IF
   SELECT COUNT(*) INTO l_n FROM rva_file,rvb_file WHERE rva01 = rvb01 AND rvb05 = g_imaa.imaa01 AND rvaconf= 'Y'
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("imaaicd08",FALSE)
   END IF     
  #lixh1-------------------
  #FUN-B50106 ----Begin----- mark
  #IF s_industry('icd') THEN
  #   IF g_imaa.imaaicd04 <> '1' AND g_imaa.imaaicd04 <> '2' THEN
  #      CALL cl_set_comp_entry("imaaicd14",FALSE)
  #      LET g_imaa.imaaicd14 = 0
  #   END IF
  #END IF
  #FUN-B50106 ----End------- mark
END FUNCTION
 
FUNCTION i150_set_required()
 
   IF g_sma.sma115= 'Y' THEN
      CALL cl_set_comp_required("imaa907",TRUE)
   END IF
 
   IF g_sma.sma116 MATCHES '[123]' THEN    
      CALL cl_set_comp_required("imaa908",TRUE)
   END IF
 
   IF g_imaa.imaa919 = "Y" THEN
      CALL cl_set_comp_required("imaa920",TRUE)
   END IF
 
   IF g_imaa.imaa922 = "Y" THEN
      CALL cl_set_comp_required("imaa923",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i150_set_no_required()
 
   CALL cl_set_comp_required("imaa907",FALSE)
   CALL cl_set_comp_required("imaa908",FALSE)
   CALL cl_set_comp_required("imaa01",FALSE) #CHI-840022
   CALL cl_set_comp_required("imaa920,imaa923",FALSE)   #No.MOD-840160 
 
END FUNCTION
 
 
FUNCTION aimi150_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_misc          LIKE type_file.chr4,    #No.FUN-690026 VARCHAR(04)
          l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
          l_buf           LIKE aag_file.aag02, 
          l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_factor        LIKE img_file.img21 
   DEFINE l_viewcad_cmd   LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(200)
   DEFINE lc_sma119       LIKE sma_file.sma119, 
          li_len          LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE li_result       LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE l_imaa01        STRING 
   DEFINE l_imaano        LIKE imaa_file.imaano
 # DEFINE l_imaa120       LIKE imaa_file.imaa120  #No.FUN-A90049 add   #FUN-AB0011
   DEFINE l_ima120        LIKE ima_file.ima120    #FUN-AB0011
   DEFINE l_chose    LIKE type_file.num5    #TQC-B90236 
   DEFINE l_case          STRING                  #FUN-BB0083 add
   DEFINE l_ima918       LIKE ima_file.ima918  #TQC-C40038
   LET g_d2=g_imaa.imaa262-g_imaa.imaa26
   LET g_flag1 = p_cmd
   IF p_cmd = 'u' THEN LET g_imaa.imaadate = g_today END IF
 
   LET g_on_change_02 = TRUE   
   LET g_on_change_021= TRUE  
 
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
   BEGIN WORK  #MOD-C30147 add
   INPUT BY NAME g_imaa.imaaoriu,g_imaa.imaaorig,
              g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021 ,
              g_imaa.imaa06  ,g_imaa.imaa08  ,g_imaa.imaa13  ,g_imaa.imaa03  ,g_imaa.imaa915, g_imaa.imaa1010, g_imaa.imaa92,  #FUN-710060 add imaa915
              g_imaa.imaaag  ,g_imaa.imaa910 ,
#FUN-B50106 -----------------------------------Begin-----------------------------
              g_imaa.imaaicd05,g_imaa.imaaicd01,g_imaa.imaaicd16,g_imaa.imaaicd04,
              g_imaa.imaaicd10,g_imaa.imaaicd12,g_imaa.imaaicd14,g_imaa.imaaicd15,
          #   g_imaa.imaaicd09,g_imaa.imaaicd08,g_imaa.imaaicd13,  #FUN-B50096 
              g_imaa.imaaicd09,g_imaa.imaaicd08,g_imaa.imaaicd17,  #FUN-B50096 #FUN-BC0103 add imaaicd17
#FUN-B50106 -----------------------------------End-------------------------------
              g_imaa.imaaicd18,g_imaa.imaaicd19,g_imaa.imaaicd20,g_imaa.imaaicd21,   #FUN-BC0103
              g_imaa.imaa105 ,g_imaa.imaa14  ,g_imaa.imaa107 ,g_imaa.imaa147,g_imaa.imaa109,g_imaa.imaa903,g_imaa.imaa24 ,g_imaa.imaa911, g_imaa.imaa151,  #FUN-C30026 add g_imaa.imaa151
              #g_imaa.imaa022 ,g_imaa.imaa251, #FUN-AC0083 add imaa022,imaa251 #FUN-B80186  
              g_imaa.imaa926,                 #FUN-930108 add imaa926
              g_imaa.imaa07  ,g_imaa.imaa70  ,g_imaa.imaa37  ,g_imaa.imaa51  ,g_imaa.imaa27  ,g_imaa.imaa28 ,g_imaa.imaa271,g_imaa.imaa71 ,
              g_imaa.imaa25  ,g_imaa.imaa35  ,g_imaa.imaa36  ,g_imaa.imaa23  ,
              g_imaa.imaa918,g_imaa.imaa919,g_imaa.imaa920,g_imaa.imaa921,   #No.MOD-840160
              g_imaa.imaa922,g_imaa.imaa923,g_imaa.imaa924,g_imaa.imaa925,   #No.MOD-840160
              g_imaa.imaa928,g_imaa.imaa929,                                     #TQC-B90236 --ADD
              g_imaa.imaa906 ,g_imaa.imaa907,g_imaa.imaa908,g_imaa.imaa159,  #FUN-B50096 add imaa159
              g_imaa.imaa12  ,g_imaa.imaa39  ,g_imaa.imaa163,g_imaa.imaa391 ,g_imaa.imaa1631,  #FUN-D30003---add>imaa163,imaa1631
              g_imaa.imaa164, g_imaa.imaa1641,                                                 #FUN-D60083 add
              g_imaa.imaa15  ,g_imaa.imaa905,g_imaa.imaa09 ,g_imaa.imaa10 ,g_imaa.imaa11,
              g_imaa.imaa022 ,g_imaa.imaa251,   #FUN-B80186
              g_imaa.imaa1001,g_imaa.imaa1002,g_imaa.imaa1015,g_imaa.imaa1014,g_imaa.imaa1016,
              g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti,
              g_imaa.imaaud01,g_imaa.imaaud02,g_imaa.imaaud03,g_imaa.imaaud04,
              g_imaa.imaaud05,g_imaa.imaaud06,g_imaa.imaaud07,g_imaa.imaaud08,
              g_imaa.imaaud09,g_imaa.imaaud10,g_imaa.imaaud11,g_imaa.imaaud12,
              g_imaa.imaaud13,g_imaa.imaaud14,g_imaa.imaaud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd)
            CALL i150_set_no_required()  
            CALL i150_set_required()    
            LET g_before_input_done = TRUE
            IF g_action_choice = "reproduce" THEN
               CALL cl_set_comp_entry("imaa01",FALSE)
            END IF
            #TQC-C30163----add------
            IF g_action_choice = "input_itemno" THEN
               CALL cl_set_comp_entry("imaa01",TRUE)
               #TQC-C60004---begin
               IF s_industry('icd') THEN 
                  IF g_imaa.imaaicd04 = '0' THEN
                     CALL cl_set_comp_entry("imaaicd01",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("imaaicd01",TRUE)
                  END IF 
               END IF 
               #TQC-C60004---end
            END IF
            #TQC-C30163---end-------
            #FUN-BB0083---add---str
            IF p_cmd = 'u' THEN 
               LET g_imaa25_t = g_imaa.imaa25
            END IF
            IF p_cmd = 'a' THEN
               LET g_imaa25_t = NULL
            END IF
            #FUN-BB0083---add---end 
            CALL cl_set_docno_format("imaano")  #TQC-B30116 
            CALL cl_chg_comp_att("imaa01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
           #FUN-B50106 --------------------Begin----------------------
            IF s_industry('icd') THEN
               #CALL i150_ind_icd_chg_imaaicd05(g_imaa.imaaicd05)  #FUN-C30278
               CALL i150_ind_icd_chg_imaaicd04(g_imaa.imaaicd04)   #FUN-C30278
            END IF
           #FUN-B50106 --------------------End------------------------
 
        AFTER FIELD imaa00
            IF cl_null(g_imaa.imaa00) THEN
                NEXT FIELD imaa00
            END IF
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd)
             
        #只要申請類別(I:新增 U:修改)有變,料件編號imaa01就應重key
        ON CHANGE imaa00
            LET g_imaa.imaa01  = NULL
            LET g_imaa.imaa02  = NULL
            LET g_imaa.imaa021 = NULL
            LET g_imaa_t.imaa01  = NULL
            LET g_imaa_t.imaa02  = NULL
            LET g_imaa_t.imaa021 = NULL
            DISPLAY BY NAME g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa021
 
        AFTER FIELD imaano
          IF NOT cl_null(g_imaa.imaano) THEN
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n
               FROM imaa_file 
              WHERE imaano=g_imaa.imaano
             IF l_n > 0 THEN
                CALL cl_err('sel imaa:','-239',0)
                NEXT FIELD imaano
             END IF
             LET g_t1=s_get_doc_no(g_imaa.imaano)
  	     CALL s_check_no('aim',g_imaa.imaano,"","Z","imaa_file","imaano","") RETURNING li_result,g_imaa.imaano 
             IF (NOT li_result) THEN
                  LET g_imaa.imaano=g_imaa_t.imaano
                  NEXT FIELD imaano
             END IF
             LET g_t1=g_imaa.imaano[1,g_doc_len]
             LET  g_imaa.imaa92 = g_smy.smyapr
             DISPLAY By NAME g_imaa.imaa92
          END IF
 
        BEFORE FIELD imaa01
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入
               CALL s_inp5(6,14,g_imaa.imaa01) RETURNING g_imaa.imaa01
               DISPLAY BY NAME g_imaa.imaa01
            END IF
 
            IF g_imaa.imaa00 = 'I' AND cl_null(g_imaa.imaa01) THEN #新增且申請料件編號為空時,才CALL自動編號附程式
                IF g_aza.aza28 = 'Y' THEN
                   CALL s_auno(g_imaa.imaa01,'1','') RETURNING g_imaa.imaa01,g_imaa.imaa02  #No.FUN-850100
                   IF NOT cl_null(g_imaa_t.imaa02) THEN
                      IF g_imaa_t.imaa02 <> g_imaa_o.imaa02 THEN
                         LET g_imaa.imaa02 = g_imaa_o.imaa02
                      ELSE 
                         LET g_imaa.imaa02 = g_imaa_t.imaa02
                      END IF 
                   END IF
                END IF
            END IF
 
        AFTER FIELD imaa01
            IF NOT cl_null(g_imaa.imaa01) THEN
               #-----MOD-A80234---------
               #IF cl_null(g_imaa_t.imaa01) OR ( g_imaa.imaa01 != g_imaa_t.imaa01) THEN
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_imaa.imaa01 != g_imaa01_t) THEN
               #-----END MOD-A80234-----
                  #FUN-B70057 add
                  IF g_imaa.imaa01[1,1] = ' ' THEN
                     CALL cl_err(g_imaa.imaa01,"aim-671",1)
                     LET g_imaa.imaa01 = g_imaa_t.imaa01
                     DISPLAY BY NAME g_imaa.imaa01
                     NEXT FIELD imaa01
                  END IF
                  #FUN-B70057 add--end
                  IF g_imaa.imaa00 = 'I' THEN #新增
                    #FUN-AB0011 ---------------------mark start-----------------------
                    ##No.FUN-A90049 -----------------add 申請類別為新增時，依料件性質show不同訊息 --
                    #IF NOT s_chk_item_no(g_imaa.imaa01,g_plant) THEN
                    #   SELECT imaa120 INTO l_imaa120 FROM imaa_file WHERE imaa01 = g_imaa.imaa01 
                    #   IF l_imaa120 = '1' THEN
                    #      CALL cl_err(g_imaa.imaa01,'aim-023',0)
                    #   ELSE
                    #      IF l_imaa120 = '2' THEN
                    #         CALL cl_err(g_imaa.imaa01,'aim-024',0) 
                    #      END IF 
                    #  END IF 
                    #  LET g_imaa.imaa01 = g_imaa_t.imaa01
                    #  DISPLAY BY NAME g_imaa.imaa01
                    #  NEXT FIELD imaa01
                    #END IF 
                    ##No.FUN-A90049  ---------------add end---------------------
                    #FUN-AB0011 ----------------------mark end-------------------------
                      SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = g_imaa.imaa01
                      IF l_n > 0 THEN
                       # CALL cl_err(g_imaa.imaa01,-239,1) #FUN-7C0084 mod     #FUN-AB0011 mark
                        #FUN-AB0011 -----------------add start------------------------
                         SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_imaa.imaa01
                         IF l_ima120 = '2' THEN
                            #CALL cl_err(g_imaa.imaa01,'aim-023',1)  #MOD-AC0307 #TQC-C40099 mark
                            CALL cl_err(g_imaa.imaa01,'aim-024',1)   #TQC-C40099 add
                         ELSE
                            #CALL cl_err(g_imaa.imaa01,'aim-024',1)  #MOD-AC0307 #TQC-C40099 mark
                            CALL cl_err(g_imaa.imaa01,'aim-023',1)   #TQC-C40099 add
                         END IF
                        #FUN-AB0011 ------------------add end-------------------------
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      SELECT count(*) INTO l_n FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_imaa.imaa01,-239,1) 
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      CALL s_field_chk(g_imaa.imaa01,'1',g_plant,'ima01') RETURNING g_flag2
                      IF g_flag2 = '0' THEN
                         CALL cl_err(g_imaa.imaa01,'aoo-043',1)
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                  ELSE
                      SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = g_imaa.imaa01
                         AND (ima120 = '1' OR ima120 = NULL OR ima120 = ' ')  #FUN-A90049 add
                      IF l_n <= 0 THEN
                         #FUN-AB0011 -----------add start-----------
                         SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_imaa.imaa01
                         IF l_ima120 = '2' THEN
                            CALL cl_err(g_imaa.imaa01,'aim-025',1)
                            LET g_imaa.imaa01 = g_imaa_t.imaa01
                            DISPLAY BY NAME g_imaa.imaa01
                         ELSE
                         #FUN-AB0011 ----------add end---------------     
                            #無此料件編號, 請重新輸入
                            CALL cl_err(g_imaa.imaa01,'ams-003',1) #FUN-7C0084 訊息代碼錯誤,調整
                            LET g_imaa.imaa01 = g_imaa_t.imaa01
                            DISPLAY BY NAME g_imaa.imaa01
                         END IF        #FUN-AB0011 add 
                         NEXT FIELD imaa01
                      END IF
                      LET l_imaano = NULL
                      SELECT imaano INTO l_imaano FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'U' #修改
                         AND imaa1010 != '2' 
                         AND imaaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_imaano) THEN
                         #已存在一張相同料號,但未拋轉的料件申請單!
                         CALL cl_err(l_imaano,'aim-150',1)
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      
                      LET g_imaa_t.imaa00  = g_imaa.imaa00
                      LET g_imaa_t.imaano  = g_imaa.imaano
                      LET g_imaa_t.imaa011 = g_imaa.imaa011
                      LET g_imaa_t.imaa92  = g_imaa.imaa92
                      LET g_imaa_t.imaa1010= g_imaa.imaa1010
                      LET g_imaa_t.imaaacti= g_imaa.imaaacti
                      LET g_imaa_t.imaauser= g_imaa.imaauser
                      LET g_imaa_t.imaagrup= g_imaa.imaagrup
                      LET g_imaa_t.imaamodu= g_imaa.imaamodu
                      LET g_imaa_t.imaadate= g_imaa.imaadate
                     #CHI-AC0001 mod --start--
                     #SELECT 'U','@1','@2',ima_file.* INTO g_imaa.* FROM ima_file
                      SELECT 'U','@1','@2', 
                             ima01,     ima02,     ima021,   ima03,     ima04,    
                             ima05,     ima06,     ima07,    ima08,     ima09,    
                             ima10,     ima11,     ima12,    ima13,     ima14,    
                             ima15,     ima16,     ima17,    ima17_fac, ima18,    
                             ima19,     ima20,     ima21,    ima22,     ima23,    
                             ima24,     ima25,     ima26,    ima261,    ima262,   
                             ima27,     ima271,    ima28,    ima29,     ima30,    
                             ima31,     ima31_fac, ima32,    ima33,     ima34,    
                             ima35,     ima36,     ima37,    ima38,     ima39,    
                             ima40,     ima41,     ima42,    ima43,     ima44,    
                             ima44_fac, ima45,     ima46,    ima47,     ima48,    
                             ima49,     ima491,    ima50,    ima51,     ima52,    
                             ima53,     ima531,    ima532,   ima54,     ima55,    
                             ima55_fac, ima56,     ima561,   ima562,    ima57,    
                             ima571,    ima58,     ima59,    ima60,     ima61,    
                             ima62,     ima63,     ima63_fac,ima64,     ima641,   
                             ima65,     ima66,     ima67,    ima68,     ima69,    
                             ima70,     ima71,     ima72,    ima73,     ima74,    
                             ima86,     ima86_fac, ima87,    ima871,    ima872,   
                             ima873,    ima874,    ima88,    ima881,    ima89,    
                             ima90,     ima91,     ima92,    ima93,     ima94,    
                             ima95,     ima75,     ima76,    ima77,     ima78,    
                             ima79,     ima80,     ima81,    ima82,     ima83,    
                             ima84,     ima85,     ima851,   ima852,    ima853,   
                             ima96,     ima97,     ima98,    ima99,     ima100,   
                             ima101,    ima102,    ima103,   ima104,    ima105,   
                             ima106,    ima107,    ima108,   ima109,    ima110,   
                             ima111,    ima121,    ima122,   ima123,    ima124,   
                             ima125,    ima126,    ima127,   ima128,    ima129,   
                             ima130,    ima131,    ima132,   ima133,    ima134,   
                             ima135,    ima136,    ima137,   ima138,    ima139,   
                             ima140,    ima141,    ima142,   ima143,    ima144,   
                             ima145,    ima146,    ima147,   ima148,    ima901,   
                             ima902,    ima903,    ima904,   ima905,    ima906,   
                             ima907,    ima908,    ima909,   ima910, 
                            #FUN-B50106 -----------Begin-----------------
                             imaaicd01,imaaicd02,imaaicd03,
                             imaaicd04,imaaicd05,imaaicd06,
                             imaaicd08,imaaicd09,imaaicd10,
                            #imaaicd12,imaaicd13,imaaicd14,   #FUN-B50096 mark imaaicd13
                             imaaicd12,imaaicd14,             #FUN-B50096
                             imaaicd15,imaaicd16, 
                            #FUN-B50106 -----------End-------------------
                             imaaicd17,imaaicd18,imaaicd19,imaaicd20,imaaicd21,   #FUN-BC0103  #MOD-D30199
                             imaacti,  
                             imauser,   imagrup,   imamodu,  imadate,   imaag,    
                             imaag1,    imaud01,   imaud02,  imaud03,   imaud04,  
                             imaud05,   imaud06,   imaud07,  imaud08,   imaud09,  
                             imaud10,   imaud11,   imaud12,  imaud13,   imaud14,  
                             imaud15,   ima1001,   ima1002,  ima1003,   ima1004,  
                             ima1005,   ima1006,   ima1007,  ima1008,   ima1009,  
                             ima1010,   ima1011,   ima1012,  ima1013,   ima1014,  
                            #ima1015,   ima1016,   ima1017,  ima1018,   ima1019,   #CHI-CA0073 mark 
                             ima1401,   ima1016,   ima1017,  ima1018,   ima1019,   #CHI-CA0073 add 
                             ima1020,   ima1021,   ima1022,  ima1023,   ima1024,  
                             ima1025,   ima1026,   ima1027,  ima1028,   ima1029,  
                             ima911,    ima912,    ima913,   ima914,    ima391,   
                             ima1321,   ima915,    ima918,   ima919,    ima920,   
                             ima921,    ima922,    ima923,   ima924,    ima925,   
                             ima601,    ima926,    imaoriu,  imaorig,   ima153,  
                             ima120,    ima159,    ima151,   ima721,ima163,ima1631  #FUN-B50096 add ima159   #FUN-C30026 add ima151 #CHI-C50068  #FUN-D30003---add>ima163,ima1631
                        INTO g_imaa.imaa00,     g_imaa.imaano,     g_imaa.imaa011,    
                             g_imaa.imaa01,     g_imaa.imaa02,     g_imaa.imaa021,   g_imaa.imaa03,     g_imaa.imaa04,    
                             g_imaa.imaa05,     g_imaa.imaa06,     g_imaa.imaa07,    g_imaa.imaa08,     g_imaa.imaa09,    
                             g_imaa.imaa10,     g_imaa.imaa11,     g_imaa.imaa12,    g_imaa.imaa13,     g_imaa.imaa14,    
                             g_imaa.imaa15,     g_imaa.imaa16,     g_imaa.imaa17,    g_imaa.imaa17_fac, g_imaa.imaa18,    
                             g_imaa.imaa19,     g_imaa.imaa20,     g_imaa.imaa21,    g_imaa.imaa22,     g_imaa.imaa23,    
                             g_imaa.imaa24,     g_imaa.imaa25,     g_imaa.imaa26,    g_imaa.imaa261,    g_imaa.imaa262,   
                             g_imaa.imaa27,     g_imaa.imaa271,    g_imaa.imaa28,    g_imaa.imaa29,     g_imaa.imaa30,    
                             g_imaa.imaa31,     g_imaa.imaa31_fac, g_imaa.imaa32,    g_imaa.imaa33,     g_imaa.imaa34,    
                             g_imaa.imaa35,     g_imaa.imaa36,     g_imaa.imaa37,    g_imaa.imaa38,     g_imaa.imaa39,    
                             g_imaa.imaa40,     g_imaa.imaa41,     g_imaa.imaa42,    g_imaa.imaa43,     g_imaa.imaa44,    
                             g_imaa.imaa44_fac, g_imaa.imaa45,     g_imaa.imaa46,    g_imaa.imaa47,     g_imaa.imaa48,    
                             g_imaa.imaa49,     g_imaa.imaa491,    g_imaa.imaa50,    g_imaa.imaa51,     g_imaa.imaa52,    
                             g_imaa.imaa53,     g_imaa.imaa531,    g_imaa.imaa532,   g_imaa.imaa54,     g_imaa.imaa55,    
                             g_imaa.imaa55_fac, g_imaa.imaa56,     g_imaa.imaa561,   g_imaa.imaa562,    g_imaa.imaa57,    
                             g_imaa.imaa571,    g_imaa.imaa58,     g_imaa.imaa59,    g_imaa.imaa60,     g_imaa.imaa61,    
                             g_imaa.imaa62,     g_imaa.imaa63,     g_imaa.imaa63_fac,g_imaa.imaa64,     g_imaa.imaa641,   
                             g_imaa.imaa65,     g_imaa.imaa66,     g_imaa.imaa67,    g_imaa.imaa68,     g_imaa.imaa69,    
                             g_imaa.imaa70,     g_imaa.imaa71,     g_imaa.imaa72,    g_imaa.imaa73,     g_imaa.imaa74,    
                             g_imaa.imaa86,     g_imaa.imaa86_fac, g_imaa.imaa87,    g_imaa.imaa871,    g_imaa.imaa872,   
                             g_imaa.imaa873,    g_imaa.imaa874,    g_imaa.imaa88,    g_imaa.imaa881,    g_imaa.imaa89,    
                             g_imaa.imaa90,     g_imaa.imaa91,     g_imaa.imaa92,    g_imaa.imaa93,     g_imaa.imaa94,    
                             g_imaa.imaa95,     g_imaa.imaa75,     g_imaa.imaa76,    g_imaa.imaa77,     g_imaa.imaa78,    
                             g_imaa.imaa79,     g_imaa.imaa80,     g_imaa.imaa81,    g_imaa.imaa82,     g_imaa.imaa83,    
                             g_imaa.imaa84,     g_imaa.imaa85,     g_imaa.imaa851,   g_imaa.imaa852,    g_imaa.imaa853,   
                             g_imaa.imaa96,     g_imaa.imaa97,     g_imaa.imaa98,    g_imaa.imaa99,     g_imaa.imaa100,   
                             g_imaa.imaa101,    g_imaa.imaa102,    g_imaa.imaa103,   g_imaa.imaa104,    g_imaa.imaa105,   
                             g_imaa.imaa106,    g_imaa.imaa107,    g_imaa.imaa108,   g_imaa.imaa109,    g_imaa.imaa110,   
                             g_imaa.imaa111,    g_imaa.imaa121,    g_imaa.imaa122,   g_imaa.imaa123,    g_imaa.imaa124,   
                             g_imaa.imaa125,    g_imaa.imaa126,    g_imaa.imaa127,   g_imaa.imaa128,    g_imaa.imaa129,   
                             g_imaa.imaa130,    g_imaa.imaa131,    g_imaa.imaa132,   g_imaa.imaa133,    g_imaa.imaa134,   
                             g_imaa.imaa135,    g_imaa.imaa136,    g_imaa.imaa137,   g_imaa.imaa138,    g_imaa.imaa139,   
                             g_imaa.imaa140,    g_imaa.imaa141,    g_imaa.imaa142,   g_imaa.imaa143,    g_imaa.imaa144,   
                             g_imaa.imaa145,    g_imaa.imaa146,    g_imaa.imaa147,   g_imaa.imaa148,    g_imaa.imaa901,   
                             g_imaa.imaa902,    g_imaa.imaa903,    g_imaa.imaa904,   g_imaa.imaa905,    g_imaa.imaa906,   
                             g_imaa.imaa907,    g_imaa.imaa908,    g_imaa.imaa909,   g_imaa.imaa910, 
                            #FUN-B50106 ------------------Begin--------------------
                             g_imaa.imaaicd01,g_imaa.imaaicd02,g_imaa.imaaicd03,
                             g_imaa.imaaicd04,g_imaa.imaaicd05,g_imaa.imaaicd06,
                             g_imaa.imaaicd08,g_imaa.imaaicd09,g_imaa.imaaicd10,
                            #g_imaa.imaaicd12,g_imaa.imaaicd13,g_imaa.imaaicd14,   #FUN-B50096 mark imaaicd13
                             g_imaa.imaaicd12,g_imaa.imaaicd14,                    #FUN-B50096 
                             g_imaa.imaaicd15,g_imaa.imaaicd16,   
                            #FUN-B50106 ------------------End---------------------- 
                             g_imaa.imaaicd17,  g_imaa.imaaicd18,  g_imaa.imaaicd19, g_imaa.imaaicd20,  g_imaa.imaaicd21,  #FUN-BC0103 
                             g_imaa.imaaacti,  
                             g_imaa.imaauser,   g_imaa.imaagrup,   g_imaa.imaamodu,  g_imaa.imaadate,   g_imaa.imaaag,    
                             g_imaa.imaaag1,    g_imaa.imaaud01,   g_imaa.imaaud02,  g_imaa.imaaud03,   g_imaa.imaaud04,  
                             g_imaa.imaaud05,   g_imaa.imaaud06,   g_imaa.imaaud07,  g_imaa.imaaud08,   g_imaa.imaaud09,  
                             g_imaa.imaaud10,   g_imaa.imaaud11,   g_imaa.imaaud12,  g_imaa.imaaud13,   g_imaa.imaaud14,  
                             g_imaa.imaaud15,   g_imaa.imaa1001,   g_imaa.imaa1002,  g_imaa.imaa1003,   g_imaa.imaa1004,  
                             g_imaa.imaa1005,   g_imaa.imaa1006,   g_imaa.imaa1007,  g_imaa.imaa1008,   g_imaa.imaa1009,  
                             g_imaa.imaa1010,   g_imaa.imaa1011,   g_imaa.imaa1012,  g_imaa.imaa1013,   g_imaa.imaa1014,  
                             g_imaa.imaa1015,   g_imaa.imaa1016,   g_imaa.imaa1017,  g_imaa.imaa1018,   g_imaa.imaa1019,  
                             g_imaa.imaa1020,   g_imaa.imaa1021,   g_imaa.imaa1022,  g_imaa.imaa1023,   g_imaa.imaa1024,  
                             g_imaa.imaa1025,   g_imaa.imaa1026,   g_imaa.imaa1027,  g_imaa.imaa1028,   g_imaa.imaa1029,  
                             g_imaa.imaa911,    g_imaa.imaa912,    g_imaa.imaa913,   g_imaa.imaa914,    g_imaa.imaa391,   
                             g_imaa.imaa1321,   g_imaa.imaa915,    g_imaa.imaa918,   g_imaa.imaa919,    g_imaa.imaa920,   
                             g_imaa.imaa921,    g_imaa.imaa922,    g_imaa.imaa923,   g_imaa.imaa924,    g_imaa.imaa925,   
                             g_imaa.imaa601,    g_imaa.imaa926,    g_imaa.imaaoriu,  g_imaa.imaaorig,   g_imaa.imaa153,  
                             g_imaa.imaa120,    g_imaa.imaa159,    g_imaa.imaa151,   g_imaa.imaa721,   g_imaa.imaa163,g_imaa.imaa1631 #FUN-D30003---add>ima163,ima1631               #FUN-B50096 add imaa159   #FUN-C30026 add g_imaa.imaa151 #CHI-C50068
                        FROM ima_file
                     #CHI-AC0001 mod --end--
                       LEFT OUTER JOIN imaa_file ON imaa01=ima01    #MOD-BC0002 add
                       WHERE ima01 = g_imaa.imaa01
                      LET g_imaa.imaa00  = g_imaa_t.imaa00 
                      LET g_imaa.imaano  = g_imaa_t.imaano 
                      LET g_imaa.imaa011 = g_imaa_t.imaa011
                      LET g_imaa.imaa92  = g_imaa_t.imaa92
                      LET g_imaa.imaa1010= g_imaa_t.imaa1010
                      LET g_imaa.imaaacti= g_imaa_t.imaaacti
                      LET g_imaa.imaauser= g_imaa_t.imaauser
                      LET g_imaa.imaagrup= g_imaa_t.imaagrup
                      LET g_imaa.imaamodu= g_imaa_t.imaamodu
                      LET g_imaa.imaadate= g_imaa_t.imaadate
                      CALL aimi150_show()
                  END IF
               END IF
            ELSE                             
             IF g_imaa.imaa00<>'I' THEN
              #CALL cl_err('',-400,0)                #MOD-A10092 mark
               CALL cl_err('','aim-157',0)           #MOD-A10092 add     
               DISPLAY BY NAME g_imaa.imaa01 
               NEXT FIELD imaa01             
             END IF
            END IF
 
        BEFORE FIELD imaa02
            IF g_imaa.imaa00 = 'I' THEN
               #IF g_sma.sma64='Y' AND (g_imaa.imaa02 IS NULL OR g_imaa.imaa02='') THEN  #MOD-880060 modify
                IF g_sma.sma64='Y' AND cl_null(g_imaa.imaa02) THEN  #TQC-A40111 modify
                   CALL s_desinp(6,4,g_imaa.imaa02) RETURNING g_imaa.imaa02
                   DISPLAY BY NAME g_imaa.imaa02
                END IF
            END IF
 
        AFTER FIELD imaa02                     #MOD-890132
           LET g_imaa_o.imaa02 = g_imaa.imaa02    #MOD-890132 
 
        AFTER FIELD imaa06   #分群碼
          IF g_imaa.imaa06 IS NOT NULL AND g_imaa.imaa06 != ' '
              THEN  #MOD-490474
              CALL s_field_chk(g_imaa.imaa06,'1',g_plant,'ima06') RETURNING g_flag2
              IF g_flag2 = '0' THEN
                 CALL cl_err(g_imaa.imaa06,'aoo-043',1)
                 LET g_imaa.imaa06 = g_imaa_o.imaa06
                 DISPLAY BY NAME g_imaa.imaa06
                 NEXT FIELD imaa06
              END IF
                   IF (g_imaa_o.imaa06 IS NULL) OR (g_imaa.imaa06 != g_imaa_o.imaa06) THEN #MOD-490474
                      IF p_cmd='u' THEN                          #FUN-650045
                         CALL s_chkitmdel(g_imaa.imaa01) RETURNING g_errno
                      ELSE
                         LET g_errno=NULL
                      END IF
 
                      IF cl_null(g_errno) THEN                   #FUN-650045
                         CALL aimi150_imaa06('Y')                #default 預設值
                         IF NOT i150_chk_rel_imaa06(p_cmd) THEN
                         END IF
                      ELSE
                         CALL aimi150_imaa06('N')                #只check 對錯,不詢問
                      END IF
 
                   ELSE
                      CALL aimi150_imaa06('N')                   #只check 對錯,不詢問
                   END IF #No:7062
 
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_imaa.imaa06,g_errno,0)
                      LET g_imaa.imaa06 = g_imaa_o.imaa06
                      DISPLAY BY NAME g_imaa.imaa06
                   END IF
            END IF
            LET g_imaa_o.imaa06 = g_imaa.imaa06
            CALL i150_set_entry(p_cmd)    #No:MOD-9C0243 add
            CALL i150_set_no_entry(p_cmd) #No:MOD-9C0243 add
 
        AFTER FIELD imaaag
            IF NOT cl_null(g_imaa.imaaag) THEN
                SELECT count(*) INTO l_n FROM aga_file
                    WHERE aga01 = g_imaa.imaaag
                IF l_n <= 0 THEN
                    CALL cl_err('','aim-910',1)
                    NEXT FIELD imaaag
                END IF
            END IF
 
        BEFORE FIELD imaa08
            CALL i150_set_entry(p_cmd)
 
        ON CHANGE imaa08  #來源碼
            IF NOT cl_null(g_imaa.imaa08) THEN
               #IF g_imaa.imaa08 NOT MATCHES "[CTDAMPXKUVZS]"   #MOD-B40151
               IF g_imaa.imaa08 NOT MATCHES "[CTDAMPXKUVRZS]"   #MOD-B40151
                    OR g_imaa.imaa08 IS NULL
                  THEN CALL cl_err(g_imaa.imaa08,'mfg1001',0)
                       LET g_imaa.imaa08 = g_imaa_o.imaa08
                       DISPLAY BY NAME g_imaa.imaa08
                       NEXT FIELD imaa08
                  ELSE IF g_imaa.imaa08 != 'T' THEN
                          LET g_imaa.imaa13 = NULL
                          DISPLAY BY NAME g_imaa.imaa13
                       END IF
               END IF
               LET l_misc=g_imaa.imaa01[1,4]
               IF l_misc='MISC' AND g_imaa.imaa08 <>'Z' THEN
                   CALL cl_err('','aim-805',0)
                   NEXT FIELD imaa08
               END IF
               LET g_imaa_o.imaa08 = g_imaa.imaa08
               IF g_imaa.imaa08 NOT MATCHES "[MT]" THEN 
                   LET g_imaa.imaa903 = 'N'
                   LET g_imaa.imaa905 = 'N'
                   DISPLAY BY NAME g_imaa.imaa903,g_imaa.imaa905
               END IF
            END IF
            CALL i150_set_entry(p_cmd)    #No:MOD-9C0243 add
            CALL i150_set_no_entry(p_cmd)

       #FUN-B50106 -------Begin---------- 
        AFTER FIELD imaa08
            CALL i150_set_no_entry(p_cmd)
       #FUN-B50106 -------End------------        
 
        BEFORE FIELD imaa13               #No:MOD-9C0243 add
            CALL i150_set_entry(p_cmd)    #No:MOD-9C0243 add
            CALL i150_set_no_entry(p_cmd) #No:MOD-9C0243 add

        AFTER FIELD imaa13  #規格主件料件(source code 為 'T'時才輸入)
           IF NOT cl_null(g_imaa.imaa13) THEN
               IF (g_imaa.imaa08 = 'T') AND (g_imaa.imaa13 IS NULL
                         OR g_imaa.imaa13 = ' ' )
                 THEN CALL cl_err(g_imaa.imaa13,'mfg1327',0)
                      LET g_imaa.imaa13 = g_imaa_o.imaa13
                      DISPLAY BY NAME g_imaa.imaa13
                      NEXT FIELD imaa13
               END IF
               IF g_imaa.imaa18 IS NOT NULL
                  THEN IF (g_imaa_o.imaa13 IS NULL ) OR (g_imaa_o.imaa13 != g_imaa.imaa13)
                         THEN SELECT imaa08 FROM imaa_file
                                            WHERE imaa01 = g_imaa.imaa13
                                              AND imaa08 matches 'C'
                                              AND imaaacti matches'[Yy]'
                              IF SQLCA.sqlcode != 0 THEN
                                 CALL cl_err3("sel","imaa_file",g_imaa.imaa13,"",
                                               "mfg1328","","",1)  
                                 LET g_imaa.imaa13 = g_imaa_o.imaa13
                                 DISPLAY BY NAME g_imaa.imaa13
                                 NEXT FIELD  imaa13
                              END IF
                      END IF
               END IF
            END IF
            LET g_imaa_o.imaa13 = g_imaa.imaa13
 
        AFTER FIELD imaa14  #工程料件
            IF NOT cl_null(g_imaa.imaa14) THEN
               IF g_imaa.imaa14 NOT MATCHES "[YN]" THEN
                  CALL cl_err(g_imaa.imaa14,'mfg1002',0)
                  LET g_imaa.imaa14 = g_imaa_o.imaa14
                  DISPLAY BY NAME g_imaa.imaa14
                  NEXT FIELD imaa14
               END IF
            END IF
            LET g_imaa_o.imaa14 = g_imaa.imaa14
 
        BEFORE FIELD imaa903              #No:MOD-9C0243 add
            CALL i150_set_entry(p_cmd)    #No:MOD-9C0243 add
            CALL i150_set_no_entry(p_cmd) #No:MOD-9C0243 add

        AFTER FIELD imaa903  #可否做聯產品入庫
            IF NOT cl_null(g_imaa.imaa903) THEN
               IF g_imaa.imaa903 NOT MATCHES "[YN]" THEN
                  CALL cl_err(g_imaa.imaa903,'mfg1002',0)
                  LET g_imaa.imaa903 = g_imaa_o.imaa903
                  DISPLAY BY NAME g_imaa.imaa903
                  NEXT FIELD imaa903
               END IF
               LET g_imaa_o.imaa903 = g_imaa.imaa903
               IF cl_null(g_imaa.imaa905) THEN
                   LET g_imaa.imaa905 = 'N'
                   DISPLAY BY NAME g_imaa.imaa905
               END IF
            END IF
 
        AFTER FIELD imaa24  #檢驗否
            IF NOT cl_null(g_imaa.imaa24) THEN
               IF g_imaa.imaa24 not matches '[YN]' THEN
                  NEXT FIELD imaa24
               END IF
            END IF
            LET g_imaa_o.imaa24 = g_imaa.imaa24
 
          AFTER FIELD imaa27
           IF NOT i150_imaa27_check() THEN NEXT FIELD imaa27 END IF  #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imaa.imaa27) THEN
           #   IF g_imaa.imaa27 < 0 THEN
           #      CALL cl_err('','aec-020',0)
           #       NEXT FIELD imaa27
           #   END IF 
           #END IF
           #FUN-BB0083---mark---end 

         AFTER FIELD imaa28
           IF NOT cl_null(g_imaa.imaa28) THEN
              IF g_imaa.imaa28 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT 
              END IF
           END IF

           AFTER FIELD imaa271
            IF NOT i150_imaa271_check() THEN NEXT FIELD CURRENT END IF  #FUN-BB0083 add
           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imaa.imaa271) THEN
           #   IF g_imaa.imaa271 < 0 THEN
           #      CALL cl_err('','aec-020',0)
           #       NEXT FIELD CURRENT 
           #   END IF
           #END IF
           #FUN-BB0083---mark---end

         AFTER FIELD imaa71
           IF NOT cl_null(g_imaa.imaa71) THEN
              IF g_imaa.imaa71 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD imaa71
              END IF
           END IF

        AFTER FIELD imaa911  #重複性生產料件
            IF NOT cl_null(g_imaa.imaa911) THEN
               IF g_imaa.imaa911 not matches '[YN]' THEN
                  NEXT FIELD imaa911
               END IF
            END IF
            LET g_imaa_o.imaa911 = g_imaa.imaa911
 
       #FUN-AC0083 ----------add start-----------------
        AFTER FIELD imaa022
          IF NOT cl_null(g_imaa.imaa022) THEN
             IF g_imaa.imaa022 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD CURRENT
             END IF
          END IF 
          IF cl_null(g_imaa.imaa022) THEN
             LET g_imaa.imaa022 = 0
          END IF 

        AFTER FIELD imaa251
          IF NOT cl_null(g_imaa.imaa251) THEN 
             CALL i150_chk_imaa251()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0) 
                NEXT FIELD CURRENT
             END IF 
          END IF 
       #FUN-AC0083 ----------add end------------------
 
        AFTER FIELD imaa926  #AVL否
            IF NOT cl_null(g_imaa.imaa926) THEN
               IF g_imaa.imaa926 not matches '[YN]' THEN
                  NEXT FIELD imaa926
               END IF
            END IF
            LET g_imaa_o.imaa926 = g_imaa.imaa926
 
        AFTER FIELD imaa107  #插件位置
            IF cl_null(g_imaa.imaa107) OR g_imaa.imaa107 NOT MATCHES '[YN]' THEN
               NEXT FIELD imaa107
            END IF
            LET g_imaa_o.imaa107 = g_imaa.imaa107
 
        AFTER FIELD imaa147  #插件位置與QPA是否要勾稽
            IF NOT cl_null(g_imaa.imaa147) THEN
               IF g_imaa.imaa147 NOT MATCHES '[YN]' THEN
                  NEXT FIELD imaa147
               END IF
            END IF
            LET g_imaa_o.imaa147 = g_imaa.imaa147
 
        AFTER FIELD imaa15  #保稅料件
            IF NOT cl_null(g_imaa.imaa15) THEN
               IF g_imaa.imaa15 NOT MATCHES "[YN]" THEN
                  CALL cl_err(g_imaa.imaa15,'mfg1002',0)
                  LET g_imaa.imaa15 = g_imaa_o.imaa15
                  DISPLAY BY NAME g_imaa.imaa15
                  NEXT FIELD imaa15
               END IF
            END IF
            LET g_imaa_o.imaa15 = g_imaa.imaa15
 
        AFTER FIELD imaa109
            IF NOT cl_null(g_imaa.imaa109) THEN
               IF (g_imaa_o.imaa109 IS NULL) OR (g_imaa.imaa109 != g_imaa_o.imaa109)
                    THEN 
                   IF NOT i150_chk_imaa109() THEN
                      NEXT FIELD imaa109
                   END IF
               END IF
            END IF
            LET g_imaa_o.imaa109 = g_imaa.imaa109
 
        AFTER FIELD imaa910
            IF cl_null(g_imaa.imaa910) THEN
                LET g_imaa.imaa910 = ' '
            END IF
#FUN-B50106 ----------------------Begin---------------------------------
   

      AFTER FIELD imaaicd01 
         IF NOT i150_ind_icd_chk_item('imaaicd01',g_imaa.imaaicd01) THEN 
            LET g_imaa.imaaicd01=g_imaa_o.imaaicd01                    
            NEXT FIELD CURRENT
         ELSE
            CALL i150_ind_icd_set_default(g_imaa.imaaicd05,g_imaa.imaaicd01)   
         END IF
         IF g_imaa.imaaicd04 = '1' OR g_imaa.imaaicd04 = '2' THEN    #FUN-C30278
            IF NOT cl_null(g_imaa.imaaicd01) THEN      #FUN-C30278
         #MOD-C30513---begin
               SELECT imaicd14 INTO g_imaa.imaaicd14 FROM imaicd_file WHERE imaicd00 = g_imaa.imaaicd01
               DISPLAY BY NAME g_imaa.imaaicd14
         #MOD-C30513---end
            END IF     #FUN-C30278
         END IF     #FUN-C30278
         
         #FUN-B70051-mark-str--
         #IF g_imaa.imaaicd04 MATCHES'[1234]' THEN
         #   CALL cl_set_comp_required("imaaicd01",TRUE)
         #ELSE
         #   CALL cl_set_comp_required("imaaicd01",FALSE)
         #END IF
         #FUN-B70051-mark-end--


      BEFORE FIELD imaaicd04    #FUN-B50106
         CALL i150_set_entry(p_cmd)   
         
      
      ON CHANGE imaaicd04   #FUN-B50106 
         CALL i150_ind_icd_chg_imaaicd04(g_imaa.imaaicd04)   #FUN-C30278
         CALL i150_set_entry(p_cmd)       
         CALL i150_set_no_entry(p_cmd)      
      
      #FUN-B70051-mark-str--
      ##FUN-B50106 ----------Begin----------------------
      #   IF g_imaa.imaaicd04 MATCHES'[1234]' THEN
      #      CALL cl_set_comp_required("imaaicd01",TRUE)
      #   ELSE
      #      CALL cl_set_comp_required("imaaicd01",FALSE)
      #   END IF
      ##FUN-B50106 ----------End------------------------
      #FUN-B70051-mark-end--
      BEFORE FIELD imaaicd08     #FUN-B50106
        CALL i150_set_entry(p_cmd)
        CALL i150_set_no_entry(p_cmd)

      AFTER FIELD imaaicd10      #FUN-B50106
         IF NOT i150_ind_icd_chk_imaaicd10(g_imaa.imaaicd10) THEN   #FUN-B50106  
            LET g_imaa.imaaicd10 = g_imaa_o.imaaicd10    #FUN-B50106  
            NEXT FIELD CURRENT
         END IF

      AFTER FIELD imaaicd04    
         #FUN-C30278---begin
         IF g_imaa.imaaicd04 = '1' OR g_imaa.imaaicd04 = '2' THEN  
            IF NOT cl_null(g_imaa.imaaicd01) THEN 
               SELECT imaaicd14 INTO g_imaa.imaaicd14 FROM imaaicd_file WHERE imaaicd00 = g_imaa.imaaicd01
               DISPLAY BY NAME g_imaa.imaaicd14
            END IF 
         END IF   
         CALL i150_set_no_entry(p_cmd)     #TQC-C40078 add 
         #FUN-C30278---end
         #FUN-C30278---begin mark
         #FUN-C30206---begin
         #  IF g_imaa.imaaicd05 <> '1' THEN 
         #     IF g_imaa.imaaicd04 <> '0' AND g_imaa.imaaicd04 <> '1' THEN
         #        LET g_imaa.imaaicd01 = NULL 
         #        DISPLAY BY NAME g_imaa.imaaicd01
         #     END IF 
         #  END IF 
         #FUN-C30206---end
         #FUN-C30278---end
         #FUN-B70051-mark-str--
         #IF g_imaa.imaaicd04 MATCHES'[1234]' THEN
         #   CALL cl_set_comp_required("imaaicd01",TRUE)
         #ELSE
         #   CALL cl_set_comp_required("imaaicd01",FALSE)
         #END IF
         #FUN-B70051-mark-end--
     #   IF g_imaa.imaaicd04 = '1' THEN                #FUN-B50106
     #      LET g_imaa.imaaicd16 = g_imaa.imaaicd01    #FUN-B50106
     #   END IF                                        #FUN-B50106

      #MOD-C30238---begin
      AFTER FIELD imaaicd05
         #FUN-C30278---begin
         IF g_imaa.imaaicd05 = '6' THEN
            IF cl_null(g_imaa.imaaicd04) THEN 
               LET g_imaa.imaaicd04 = '9'
            END IF 
            DISPLAY BY NAME g_imaa.imaaicd04
         END IF
         #FUN-C30278---end
         #IF g_imaa.imaaicd05='1' AND cl_null(g_imaa.imaaicd01) THEN  #FUN-C30278
            #CALL i150_ind_icd_chg_imaaicd05(g_imaa.imaaicd05)   #FUN-C30278
            CALL i150_ind_icd_set_default(g_imaa.imaaicd05,g_imaa.imaaicd01)
         #END IF  #FUN-C30278
      #MOD-C30238---end
     
      AFTER FIELD imaaicd15
         IF g_imaa.imaaicd15 < 0 THEN
            CALL cl_err('','aec-020',0)
            NEXT FIELD imaaicd15
         END IF 
      AFTER FIELD imaaicd16
         IF NOT cl_null(g_imaa.imaaicd16) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM imaicd_file
             WHERE imaicd00 = g_imaa.imaaicd16
               AND imaicd04 = '1'
            IF l_n < 1 THEN
               CALL cl_err('','aim-029',0)
               NEXT FIELD imaaicd16
            END IF
         END IF
      #FUN-BC0103 --START--
      AFTER FIELD imaaicd17
         CALL i150_set_entry(p_cmd)
         CALL i150_set_no_entry(p_cmd) 
      #FUN-BC0130 --END--   
      ON CHANGE imaaicd05
         IF g_imaa.imaaicd05<>g_imaa_o.imaaicd05 OR g_imaa_o.imaaicd05 IS NULL THEN 
            #CALL i150_ind_icd_chg_imaaicd05(g_imaa.imaaicd05)   #FUN-B50106  #FUN-C30278
            CALL i150_ind_icd_set_default(g_imaa.imaaicd05,g_imaa.imaaicd01)    #FUN-B50106
         END IF
           
#FUN-B50106 --------------------------End------------------------------
        AFTER FIELD imaa105
            IF NOT cl_null(g_imaa.imaa105) THEN
              IF g_imaa.imaa105 NOT MATCHES "[YN]" THEN
                 CALL cl_err(g_imaa.imaa105,'mfg1002',0)
                 LET g_imaa.imaa105 = g_imaa_o.imaa105
                 DISPLAY BY NAME g_imaa.imaa105
                 NEXT FIELD imaa105
              END IF
            END IF
            LET g_imaa_o.imaa105 = g_imaa.imaa105
 
#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
        AFTER FIELD imaa70  #消耗料件
            IF NOT cl_null(g_imaa.imaa70) THEN
               IF g_imaa.imaa70 NOT MATCHES '[YN]' THEN
                  CALL cl_err(g_imaa.imaa70,'mfg1002',0)
                  LET g_imaa.imaa70 = g_imaa_o.imaa70
                  DISPLAY BY NAME g_imaa.imaa70
                  NEXT FIELD imaa70
               END IF
            END IF
            LET g_imaa_o.imaa70 = g_imaa.imaa70
 
        AFTER FIELD imaa09                     #其他分群碼一
           IF g_imaa.imaa09 IS NOT NULL AND g_imaa.imaa09 != ' ' THEN
               IF NOT i150_chk_imaa09() THEN
                   NEXT FIELD imaa09
               END IF
           END IF
           LET g_imaa_o.imaa09 = g_imaa.imaa09
 
        AFTER FIELD imaa10                     #其他分群碼二
           IF g_imaa.imaa10 IS NOT NULL AND g_imaa.imaa10 != ' ' THEN
               IF NOT i150_chk_imaa10() THEN
                   NEXT FIELD imaa10
               END IF
           END IF
           LET g_imaa_o.imaa10 = g_imaa.imaa10
 
        AFTER FIELD imaa11                     #其他分群碼三
           IF g_imaa.imaa11 IS NOT NULL AND g_imaa.imaa11 != ' ' THEN
               IF NOT i150_chk_imaa11() THEN
                   NEXT FIELD imaa11
               END IF
           END IF
           LET g_imaa_o.imaa11 = g_imaa.imaa11
 
        BEFORE FIELD imaa1014                                                                                                        
            IF p_cmd='a' THEN                                                                                                       
               LET g_imaa.imaa1014='1'                                                                                                
            END IF                                                                                                                  
                                                                                                                                    
        AFTER FIELD imaa1014                                                                                                         
            IF NOT cl_null(g_imaa.imaa1014) THEN                                                                                      
               IF g_imaa.imaa1014 NOT MATCHES '[123456]' THEN                                                                         
                  NEXT FIELD imaa1014                                                                                                
               END IF                                                                                                               
            END IF                                                                                                                  
                                    
        AFTER FIELD imaa12                     #其他分群碼四
             IF g_imaa.imaa12 IS NOT NULL AND g_imaa.imaa12 != ' ' THEN
                 IF NOT i150_chk_imaa12() THEN
                     NEXT FIELD imaa12
                 END IF 
             END IF
             LET g_imaa_o.imaa12 = g_imaa.imaa12
 
        AFTER FIELD imaa25            #庫存單位
            IF NOT cl_null(g_imaa.imaa25) THEN
                IF NOT i150_chk_imaa25() THEN
                   NEXT FIELD imaa25
                END IF 
            END IF
           #str MOD-A60090 add                     
            IF NOT cl_null(g_imaa.imaa25) AND p_cmd='u' THEN
               SELECT COUNT(*) INTO l_n FROM imaa_file
                WHERE (imaa63 <> g_imaa.imaa25 OR
                       imaa31 <> g_imaa.imaa25 OR
                       imaa44 <> g_imaa.imaa25 OR  
                       imaa55 <> g_imaa.imaa25
                      )  
                  AND imaa01=g_imaa.imaa01
                  AND imaano=g_imaa.imaano
               IF l_n > 0 THEN  
                  LET g_msg=cl_getmsg('aim-020',g_lang) 
                  IF cl_prompt(0,0,g_msg) THEN     
                     CALL aimi150_a_updchk()
                  END IF
               ELSE 
                  IF g_imaa.imaa25<>g_imaa_o.imaa25 THEN
                     CALL aimi150_a_updchk()
                  END IF
               END IF
            END IF
           #end MOD-A60090 add
           #str MOD-A60104 add
           #新增時,若有修改庫存單位(ima25)也應詢問aim-020
            IF NOT cl_null(g_imaa.imaa25) AND p_cmd='a' THEN
               IF g_imaa.imaa25 <> g_imaa_o.imaa25 OR
                  g_imaa.imaa63 <> g_imaa.imaa25 OR
                  g_imaa.imaa31 <> g_imaa.imaa25 OR
                  g_imaa.imaa44 <> g_imaa.imaa25 OR
                  g_imaa.imaa55 <> g_imaa.imaa25 THEN
                  LET g_msg=cl_getmsg('aim-020',g_lang)
                  IF cl_prompt(0,0,g_msg) THEN
                     CALL aimi150_a_updchk()
                  END IF
               END IF
            END IF
           #end MOD-A60104 add
            LET g_imaa_o.imaa25 = g_imaa.imaa25
            LET g_imaa.imaa86=g_imaa.imaa25
           #FUN-BB0083---add---str
              LET l_case = ''
              IF NOT i150_imaa27_check() THEN
                 LET l_case = "imaa27"
              END IF
              IF NOT i150_imaa271_check() THEN
                 LET l_case = "imaa271"
              END IF              
              IF NOT i150_imaa51_check() THEN
                 LET l_case = "imaa51"
              END IF
              LET g_imaa25_t = g_imaa.imaa25
              CASE l_case
                   WHEN "imaa51"
                      NEXT FIELD imaa51
                   WHEN "imaa271"
                      NEXT FIELD imaa271
                   WHEN "imaa27"
                      NEXT FIELD imaa27
                   OTHERWISE EXIT CASE
               END CASE
           #FUN-BB0083---add---end
 
        AFTER FIELD imaa35
            IF g_imaa.imaa35 !=' ' AND g_imaa.imaa35 IS NOT NULL THEN
                IF NOT i150_chk_imaa35() THEN
                   NEXT FIELD imaa35
                END IF 
            END IF
	IF NOT s_imechk(g_imaa.imaa35,g_imaa.imaa36) THEN NEXT FIELD imaa36 END IF         #FUN-D40103 add
 
        AFTER FIELD imaa36
	#FUN-D40103--mark--str--
        #    IF g_imaa.imaa36 !=' ' AND g_imaa.imaa36 IS NOT NULL THEN
        #       SELECT * FROM ime_file WHERE ime01=g_imaa.imaa35
        #          AND ime02=g_imaa.imaa36
        #       IF SQLCA.SQLCODE THEN
        #          CALL cl_err3("sel","ime_file",g_imaa.imaa36,"","mfg1101",
        #                       "","",1)  
        #          NEXT FIELD imaa36
        #       END IF
        #    END IF
 	#FUN-D40103--mark--end--
            IF cl_null(g_imaa.imaa36) THEN LET g_imaa.imaa36 = ' ' END IF                      #FUN-D40103 add
            IF NOT s_imechk(g_imaa.imaa35,g_imaa.imaa36) THEN NEXT FIELD imaa36 END IF         #FUN-D40103 add

        AFTER FIELD imaa23
             IF NOT cl_null(g_imaa.imaa23) THEN
                 IF NOT i150_chk_imaa23() THEN
                    NEXT FIELD imaa23
                 END IF 
             END IF
             LET g_imaa_o.imaa23 = g_imaa.imaa23             

#FUN-B90035 --------------Begin-----------------
         AFTER FIELD imaa159
            IF cl_null(g_imaa.imaa159) THEN
               LET g_imaa.imaa159 = '3'
            END IF
            DISPLAY BY NAME g_imaa.imaa159
#FUN-B90035 --------------End-------------------
 
         BEFORE FIELD imaa918
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd)   #CHI-B80032 add
            CALL i150_set_no_required()     #CHI-B80032 add
         
        #AFTER FIELD imaa918  #MOD-A50099 mark
         ON CHANGE imaa918    #MOD-A50099
#CHI-B80032 -- begin --
            IF cl_null(g_imaa.imaa918) OR g_imaa.imaa918 = 'N' THEN
               LET g_imaa.imaa919 = 'N'
               LET g_imaa.imaa920 = NULL
               DISPLAY BY NAME g_imaa.imaa919,g_imaa.imaa920
            END IF
#CHI-B80032 -- end --
         IF g_imaa.imaa918 = 'Y' AND cl_null(g_imaa.imaa925) THEN 
            LET g_imaa.imaa925 = '1'
            DISPLAY BY NAME g_imaa.imaa925
         END IF 
         #MOD-C30091---end
            CALL i150_set_no_entry(p_cmd)

         #TQC-C40044--add--str--
         AFTER FIELD imaa918
            IF cl_null(g_imaa.imaa918) OR g_imaa.imaa918 = 'N' THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM imad_file
                   WHERE imad01 = g_imaa.imaa01
                     AND imad03 = 2
              IF l_n > 0 THEN
                  CALL cl_err('','aim1157',0)
                  LET g_imaa.imaa918 = 'Y'
                  DISPLAY BY NAME g_imaa.imaa918
                  NEXT FIELD imaa918
               END IF
            END IF
         #TQC-C40044--add--end--
         BEFORE FIELD imaa919
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd) #CHI-B80032 add
            CALL i150_set_no_required()
            CALL i150_set_required()      #CHI-B80032 add
         
        #AFTER FIELD imaa919  #MOD-A50099 mark
         ON CHANGE imaa919    #MOD-A50099
#CHI-B80032 -- begin --
            IF cl_null(g_imaa.imaa919) OR g_imaa.imaa919 = 'N' THEN
               LET g_imaa.imaa920 = NULL
               DISPLAY BY NAME g_imaa.imaa920
            END IF
#CHI-B80032 -- end --
            CALL i150_set_no_entry(p_cmd)
            CALL i150_set_required()
         
         AFTER FIELD imaa920
            IF NOT cl_null(g_imaa.imaa920) THEN
               SELECT COUNT(*) INTO l_n FROM geh_file,gei_file
                WHERE geh04 = '5' 
                  AND geh01 = gei03 
                  AND gei01 = g_imaa.imaa920 
               IF l_n = 0 THEN
                  CALL cl_err(g_imaa.imaa920,'aoo-112',0)
                  NEXT FIELD imaa920
               END IF
            END IF
         
         BEFORE FIELD imaa921
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd)   #CHI-B80032 add
         
        #AFTER FIELD imaa921  #MOD-A50099 mark
         ON CHANGE imaa921    #MOD-A50099
#CHI-B80032 -- begin --
            IF cl_null(g_imaa.imaa921) OR g_imaa.imaa921 = 'N' THEN
               LET g_imaa.imaa922 = 'N'
               LET g_imaa.imaa923 = NULL
               LET g_imaa.imaa924 = 'N'
               DISPLAY BY NAME g_imaa.imaa922,g_imaa.imaa923,g_imaa.imaa924
            END IF
#CHI-B80032 -- end --
         #MOD-C30091---begin
         IF g_imaa.imaa921 = 'Y' AND cl_null(g_imaa.imaa925) THEN 
            LET g_imaa.imaa925 = '1'
            DISPLAY BY NAME g_imaa.imaa925
         END IF 
         #MOD-C30091---end
            CALL i150_set_no_entry(p_cmd)
         
         BEFORE FIELD imaa922
            CALL i150_set_entry(p_cmd)
            CALL i150_set_no_entry(p_cmd)   #CHI-B80032 add
            CALL i150_set_no_required()
            CALL i150_set_required()        #CHI-B80032 add
         
        #AFTER FIELD imaa922  #MOD-A50099 mark
         ON CHANGE imaa922    #MOD-A50099
#CHI-B80032 -- begin --
            IF cl_null(g_imaa.imaa922) OR g_imaa.imaa922 = 'N' THEN
               LET g_imaa.imaa923 = NULL
               DISPLAY BY NAME g_imaa.imaa923
            END IF
#CHI-B80032 -- end --
            CALL i150_set_no_entry(p_cmd)
            CALL i150_set_required() 
         
         AFTER FIELD imaa923
            IF NOT cl_null(g_imaa.imaa923) THEN
               SELECT COUNT(*) INTO l_n FROM geh_file,gei_file 
                WHERE geh04 = '6'
                  AND geh01 = gei03
                  AND gei01 = g_imaa.imaa923 
               IF l_n = 0 THEN
                  CALL cl_err(g_imaa.imaa923,'aoo-112',0)
                  NEXT FIELD imaa923
               END IF
            END IF
         
         AFTER FIELD imaa925
            IF g_imaa.imaa925 NOT MATCHES '[123]' THEN
               NEXT FIELD imaa925
            END IF
#N0.TQC-B90236 ------------- add start ----------------
         AFTER FIELD imaa928
            IF cl_null(g_imaa.imaa928) THEN
               CALL cl_err('',1205,0)
               NEXT FIELD imaa928
            ELSE
               IF g_imaa.imaa928 = "N" THEN
                  CALL cl_set_comp_entry('imaa929',TRUE)
               ELSE
                  CALL cl_set_comp_entry('imaa929',FALSE)
                  LET g_imaa.imaa929 = ''
               END IF
            END IF
         ON CHANGE imaa928
            IF g_imaa.imaa928 = "N" THEN
               CALL cl_set_comp_entry('imaa929',TRUE)
            ELSE
               CALL cl_set_comp_entry('imaa929',FALSE)
               LET g_imaa.imaa929 = ''
            END IF

         AFTER FIELD imaa929
            IF NOT cl_null(g_imaa.imaa929) THEN
               SELECT COUNT(ima01) INTO l_chose FROM ima_file WHERE ima928 = "Y" AND ima01=g_imaa.imaa929
               IF l_chose = 0 THEN
                  CALL cl_err('','aim1116',0)
                  NEXT FIELD imaa929
               END IF
               #TQC-C40038--add--str--
               SELECT ima918 INTO l_ima918 FROM ima_file
                WHERE ima01 = g_imaa.imaa929
               IF l_ima918 = 'Y' AND g_imaa.imaa918 <> 'Y' THEN
                  CALL cl_err('','aim1145',0)
                  LET g_imaa.imaa929 = g_imaa_t.imaa929
                  NEXT FIELD imaa929
               END IF
               #TQC-C40038--add--end--
            END IF

#No.TQC-B90236 ------------- add end -----------------
        AFTER FIELD imaa07  #ABC 碼
            IF NOT cl_null(g_imaa.imaa07) THEN
               IF g_imaa.imaa07 NOT MATCHES'[ABC]' THEN
                   CALL cl_err(g_imaa.imaa07,'mfg0009',0)
                   LET g_imaa.imaa07 = g_imaa_o.imaa07
                   DISPLAY BY NAME g_imaa.imaa07
                   NEXT FIELD imaa07
               END IF
            END IF
            LET g_imaa_o.imaa07 = g_imaa.imaa07
 
        AFTER FIELD imaa37  #補貨策略碼
            IF NOT cl_null(g_imaa.imaa37) THEN
               IF g_imaa.imaa37 NOT MATCHES "[012345]" THEN
                   CALL cl_err(g_imaa.imaa37,'mfg1003',0)
                   LET g_imaa.imaa37 = g_imaa_o.imaa37
                   DISPLAY BY NAME g_imaa.imaa37
                   NEXT FIELD imaa37
               END IF
               #--->補貨策略碼為'0'(再訂購點),'5'(期間採購)
               IF ( g_imaa.imaa37='0' OR g_imaa.imaa37 ='5' )
                  AND ( g_imaa.imaa08 NOT MATCHES '[MSPVZ]' )
               THEN CALL cl_err(g_imaa.imaa37,'mfg3201',0)
                    LET g_imaa.imaa37 = g_imaa_o.imaa37
                    DISPLAY BY NAME g_imaa.imaa37
                    NEXT FIELD imaa37
               END IF
            END IF
            LET g_imaa_o.imaa37 = g_imaa.imaa37
 
        AFTER FIELD imaa51
            IF NOT i150_imaa51_check() THEN NEXT FIELD imaa51 END IF  #FUN-BB0083 add
            #FUN-BB0083---mark---str
            #IF NOT cl_null(g_imaa.imaa51) THEN
            #   IF g_imaa.imaa51 <= 0
            #   THEN CALL cl_err(g_imaa.imaa51,'mfg1322',0)
            #        LET g_imaa.imaa51 = g_imaa_o.imaa51
            #        DISPLAY BY NAME g_imaa.imaa51
            #        NEXT FIELD imaa51
            #   END IF
            # ELSE 
            #   LET g_imaa.imaa51 = 1
            #   DISPLAY BY NAME g_imaa.imaa51
            #END IF
            #LET g_imaa_o.imaa51 = g_imaa.imaa51
            #FUN-BB0083---mark---end
 
        AFTER FIELD imaa39
            IF NOT cl_null(g_imaa.imaa39) OR g_imaa.imaa39 != ' '  THEN
               IF NOT i150_chk_imaa39() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imaa.imaa39 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa39 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imaa.imaa39
                  DISPLAY BY NAME g_imaa.imaa39  
                  #FUN-B10049--end                   
                  NEXT FIELD imaa39
               END IF 
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_imaa.imaa39
                         AND aag07 != '1'  
                         AND aag00 = g_aza.aza81  #No.FUN-730020
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa39 = g_imaa.imaa39
            
       #FUN-D30003---add---str---
       AFTER FIELD imaa163
            IF NOT cl_null(g_imaa.imaa163) OR g_imaa.imaa163 != ' '  THEN
               IF NOT i150_chk_imaa163() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa163
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa163 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_imaa.imaa163
                  DISPLAY BY NAME g_imaa.imaa163
                  NEXT FIELD imaa163
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_imaa.imaa163
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa163 = g_imaa.imaa163

       AFTER FIELD imaa1631
          IF NOT cl_null(g_imaa.imaa1631) OR g_imaa.imaa1631 != ' '  THEN
             IF NOT i150_chk_imaa1631() THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_imaa.imaa1631
                LET g_qryparam.construct = 'N'
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa1631 CLIPPED,"%' "                                              
                CALL cl_create_qry() RETURNING g_imaa.imaa1631
                DISPLAY BY NAME g_imaa.imaa1631
                NEXT FIELD imaa1631
             END IF
           SELECT aag02 INTO l_buf FROM aag_file
                  WHERE aag01 = g_imaa.imaa1631
                    AND aag07 != '1'
                    AND aag00 = g_aza.aza82
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa1631 = g_imaa.imaa1631
       #FUN-D30003---add---end---

       #FUN-D60083--add--str--
       AFTER FIELD imaa164
            IF NOT cl_null(g_imaa.imaa164) OR g_imaa.imaa164 != ' '  THEN
               IF NOT i150_chk_imaa164() THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa164
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa164 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_imaa.imaa164
                  DISPLAY BY NAME g_imaa.imaa164
                  NEXT FIELD imaa164
               END IF
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_imaa.imaa164
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa164 = g_imaa.imaa164

       AFTER FIELD imaa1641
          IF NOT cl_null(g_imaa.imaa1641) OR g_imaa.imaa1641 != ' '  THEN
             IF NOT i150_chk_imaa1641() THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_imaa.imaa1641
                LET g_qryparam.construct = 'N'
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa1641 CLIPPED,"%' "  
                CALL cl_create_qry() RETURNING g_imaa.imaa1641
                DISPLAY BY NAME g_imaa.imaa1641
                NEXT FIELD imaa1641
             END IF
           SELECT aag02 INTO l_buf FROM aag_file
                  WHERE aag01 = g_imaa.imaa1641
                    AND aag07 != '1'
                    AND aag00 = g_aza.aza82
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa1641 = g_imaa.imaa1641
       #FUN-D60083--add--end--

       #TQC-AB0197----------add-----------str--------------
       AFTER FIELD imaa391 
          IF NOT cl_null(g_imaa.imaa391) OR g_imaa.imaa391 != ' '  THEN
             IF NOT i150_chk_imaa391() THEN 
                #FUN-B10049--begin
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_aag"                                   
                LET g_qryparam.default1 = g_imaa.imaa391 
                LET g_qryparam.construct = 'N'                
                LET g_qryparam.arg1 = g_aza.aza82  
                LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa391 CLIPPED,"%' "                                                                        
                CALL cl_create_qry() RETURNING g_imaa.imaa391
                DISPLAY BY NAME g_imaa.imaa391  
                #FUN-B10049--end                  
                NEXT FIELD imaa391
             END IF
           SELECT aag02 INTO l_buf FROM aag_file
                  WHERE aag01 = g_imaa.imaa391
                    AND aag07 != '1'
                    AND aag00 = g_aza.aza82 
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa391 = g_imaa.imaa391   
       #TQC-AB0197----------add-----------end-------------- 
 
      BEFORE FIELD imaa906
         CALL i150_set_entry(p_cmd)
 
      AFTER FIELD imaa906
         IF NOT cl_null(g_imaa.imaa906) THEN
            IF g_sma.sma115 = 'Y' THEN
               IF g_imaa.imaa906 IS NULL THEN
                  CALL cl_err(g_imaa.imaa906,'aim-998',0)
                  NEXT FIELD imaa906
               END IF
               IF g_sma.sma122 = '1' THEN
                  IF g_imaa.imaa906 = '3' THEN
                     CALL cl_err('','asm-322',1)
                     NEXT FIELD imaa906
                  END IF
               END IF
               IF g_sma.sma122 = '2' THEN
                  IF g_imaa.imaa906 = '2' THEN
                     CALL cl_err('','asm-323',1)
                     NEXT FIELD imaa906
                  END IF
               END IF
               IF g_imaa.imaa906 <> '1' THEN
                  IF cl_null(g_imaa.imaa907) THEN
                     LET g_imaa.imaa907 = g_imaa.imaa25
                     DISPLAY BY NAME g_imaa.imaa907
                  END IF
               END IF
               IF g_sma.sma116 MATCHES '[123]' THEN    #No.FUN-610076
                  IF cl_null(g_imaa.imaa908) THEN
                     LET g_imaa.imaa908 = g_imaa.imaa25
                     DISPLAY BY NAME g_imaa.imaa908
                  END IF
               END IF
            END IF
            IF g_imaa906 <> g_imaa.imaa906 AND g_imaa906 IS NOT NULL AND p_cmd = 'u' THEN
               IF NOT cl_confirm('aim-999') THEN
                  LET g_imaa.imaa906=g_imaa906
                  DISPLAY BY NAME g_imaa.imaa906
                  NEXT FIELD imaa906
               END IF
            END IF
         END IF
         CALL i150_set_no_entry(p_cmd)
 
      AFTER FIELD imaa907
         IF NOT cl_null(g_imaa.imaa907) THEN
           IF NOT i150_chk_imaa907(p_cmd) THEN
              NEXT FIELD imaa907
           END IF
         END IF
 
      BEFORE FIELD imaa908
         IF cl_null(g_imaa.imaa908) THEN
            IF g_sma.sma116 MATCHES '[123]' THEN    
               LET g_imaa.imaa908 = g_imaa.imaa25
               DISPLAY BY NAME g_imaa.imaa908
            END IF
         END IF
 
      AFTER FIELD imaa908
         IF NOT cl_null(g_imaa.imaa908) THEN
           IF NOT i150_chk_imaa908(p_cmd) THEN
              NEXT FIELD imaa908
           END IF
         END IF
 
      AFTER FIELD imaaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imaaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
           LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_imaa.imaa00 = 'I' THEN #申請類別為新增 #MOD-780102 add if 判斷
                IF ( g_imaa.imaa37='0' OR g_imaa.imaa37 ='5' )
                   AND ( g_imaa.imaa08 NOT MATCHES '[MSPVZ]' )
                THEN CALL cl_err(g_imaa.imaa37,'mfg3201',1)
                     NEXT FIELD imaa01
                     DISPLAY BY NAME g_imaa.imaa37
                     DISPLAY BY NAME g_imaa.imaa08
                END IF
                IF g_sma.sma115 = 'Y' THEN
                   IF g_imaa.imaa906 IS NULL THEN
                      NEXT FIELD imaa906
                   END IF
                END IF
                IF g_sma.sma122 = '1' THEN
                   IF g_imaa.imaa906 = '3' THEN
                      CALL cl_err('','asm-322',1)
                      NEXT FIELD imaa906
                   END IF
                END IF
                IF g_sma.sma122 = '2' THEN
                   IF g_imaa.imaa906 = '2' THEN
                      CALL cl_err('','asm-323',1)
                      NEXT FIELD imaa906
                   END IF
                END IF
             ELSE
                IF cl_null(g_imaa.imaa01)  THEN 
                   DISPLAY BY NAME g_imaa.imaa01
                   NEXT FIELD imaa01
                END IF
            END IF #MOD-780102 add 

            #-----MOD-A80234---------
            IF NOT cl_null(g_imaa.imaa01) THEN
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_imaa.imaa01 != g_imaa01_t) THEN
                  IF g_imaa.imaa00 = 'I' THEN #新增
                      LET l_n = 0 
                      SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = g_imaa.imaa01
                      IF l_n > 0 THEN
                         CALL cl_err(g_imaa.imaa01,-239,1) 
                         LET g_imaa.imaa01 = ''
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      LET l_n = 0 
                      SELECT count(*) INTO l_n FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_imaa.imaa01,-239,1) 
                         LET g_imaa.imaa01 = ''
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                  ELSE
                      LET l_imaano = NULL
                      SELECT imaano INTO l_imaano FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'U' #修改
                         AND imaa1010 != '2' 
                         AND imaaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_imaano) THEN
                         #已存在一張相同料號,但未拋轉的料件申請單!
                         CALL cl_err(l_imaano,'aim-150',1)
                         LET g_imaa.imaa01 = ''
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                  END IF
               END IF
            END IF
            #-----END MOD-A80234-----
        ON ACTION controlp
            CASE
               WHEN INFIELD(imaano)
                  LET g_t1 = s_get_doc_no(g_imaa.imaano)    
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','Z') RETURNING g_t1 
                  LET g_imaa.imaano = g_t1
                  DISPLAY BY NAME g_imaa.imaano
                  NEXT FIELD imaano
               WHEN INFIELD(imaa01) #料件編號
                    IF g_imaa.imaa00='U' THEN
                        #'U':修改時查ima01
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = 'q_ima'
                        LET g_qryparam.default1 = g_imaa.imaa01
                        LET g_qryparam.where    = " ( ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "  #FUN-AB0011 add
                        CALL cl_create_qry() RETURNING g_imaa.imaa01
                        DISPLAY BY NAME g_imaa.imaa01
                        NEXT FIELD imaa01
                    END IF
               WHEN INFIELD(imaa13) #規格主件
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaa4"     #No:MOD-9C0243 modify
                  LET g_qryparam.default1 = g_imaa.imaa13
                  LET g_qryparam.arg1     = "C"
                  LET g_qryparam.where    = " imaa08 MATCHES '",g_qryparam.arg1,"'"
                  CALL cl_create_qry() RETURNING g_imaa.imaa13
                  DISPLAY BY NAME g_imaa.imaa13
                  NEXT FIELD imaa13
               WHEN INFIELD(imaa06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.default1 = g_imaa.imaa06
                  CALL cl_create_qry() RETURNING g_imaa.imaa06
                  DISPLAY BY NAME g_imaa.imaa06
                  NEXT FIELD imaa06
               WHEN INFIELD(imaaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.default1 = g_imaa.imaaag
                  CALL cl_create_qry() RETURNING g_imaa.imaaag
                  DISPLAY BY NAME g_imaa.imaaag
                  NEXT FIELD imaaag
               WHEN INFIELD(imaa09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa09
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_imaa.imaa09 #6818
                  DISPLAY BY NAME g_imaa.imaa09
                  NEXT FIELD imaa09
               WHEN INFIELD(imaa10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa10
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_imaa.imaa10 #6818
                  DISPLAY BY NAME g_imaa.imaa10
                  NEXT FIELD imaa10
               WHEN INFIELD(imaa11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa11
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_imaa.imaa11 #6818
                  DISPLAY BY NAME g_imaa.imaa11
                  NEXT FIELD imaa11
               WHEN INFIELD(imaa12) #其他分群碼四
                  CALL cl_init_qry_var()   #MOD-5A0094
                  LET g_qryparam.form    = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa12
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_imaa.imaa12 #6818
                  DISPLAY BY NAME g_imaa.imaa12
                  NEXT FIELD imaa12
               WHEN INFIELD(imaa109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa109
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_imaa.imaa109
                  DISPLAY BY NAME g_imaa.imaa109
                  NEXT FIELD imaa109

               #FUN-AC0083 ---------add start-------
               WHEN INFIELD(imaa251)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_gfe"       #NO.FUN-B30092 mark
                  LET g_qryparam.form     = "q_gfo"       #NO.FUN-B30092
                  LET g_qryparam.default1 = g_imaa.imaa251
                  CALL cl_create_qry() RETURNING g_imaa.imaa251
                  DISPLAY BY NAME g_imaa.imaa251
                  NEXT FIELD imaa251
               #FUN-AC0083 ---------add end---------

               WHEN INFIELD(imaa25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa25
                  CALL cl_create_qry() RETURNING g_imaa.imaa25
                  DISPLAY BY NAME g_imaa.imaa25
                  NEXT FIELD imaa25
               WHEN INFIELD(imaa34) #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_smh"
                  LET g_qryparam.default1 = g_imaa.imaa34
                  CALL cl_create_qry() RETURNING g_imaa.imaa34
                  DISPLAY BY NAME g_imaa.imaa34
                  NEXT FIELD imaa34
               WHEN INFIELD(imaa35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd"
                  LET g_qryparam.default1 = g_imaa.imaa35
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                  CALL cl_create_qry() RETURNING g_imaa.imaa35
                  DISPLAY BY NAME g_imaa.imaa35
                  NEXT FIELD imaa35
               WHEN INFIELD(imaa36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.default1 = g_imaa.imaa36
                  LET g_qryparam.arg1     = g_imaa.imaa35 #倉庫編號 #MOD-4A0063
                  LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                  CALL cl_create_qry() RETURNING g_imaa.imaa36
                  DISPLAY BY NAME g_imaa.imaa36
                  NEXT FIELD imaa36
               WHEN INFIELD(imaa23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = g_imaa.imaa23
                  CALL cl_create_qry() RETURNING g_imaa.imaa23
                  DISPLAY BY NAME g_imaa.imaa23
                  LET g_gen02 = ""
                  SELECT gen02 INTO g_gen02
                    FROM gen_file
                   WHERE gen01=g_imaa.imaa23
                  DISPLAY g_gen02 TO FORMONLY.gen02
                  NEXT FIELD imaa23
               WHEN INFIELD(imaa39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa39
                  LET g_qryparam.arg1     = g_aza.aza81  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_imaa.imaa39
                  DISPLAY BY NAME g_imaa.imaa39
                  NEXT FIELD imaa39
               #FUN-D30003---add---str---
               WHEN INFIELD(imaa163)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa163
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_imaa.imaa163
                  DISPLAY BY NAME g_imaa.imaa163
                  NEXT FIELD imaa163
               WHEN INFIELD(imaa1631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa1631
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_imaa.imaa1631
                  DISPLAY BY NAME g_imaa.imaa1631
                  NEXT FIELD imaa1631
               #FUN-D30003---add---end---

               #FUN-D60083--add--str--
               WHEN INFIELD(imaa164)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa164
                  LET g_qryparam.arg1     = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_imaa.imaa164
                  DISPLAY BY NAME g_imaa.imaa164
                  NEXT FIELD imaa164
               WHEN INFIELD(imaa1641)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa1641
                  LET g_qryparam.arg1     = g_aza.aza82
                  CALL cl_create_qry() RETURNING g_imaa.imaa1641
                  DISPLAY BY NAME g_imaa.imaa1641
                  NEXT FIELD imaa1641
               #FUN-D60083--add--end--

               WHEN INFIELD(imaa391)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa391
                  LET g_qryparam.arg1     = g_aza.aza82  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_imaa.imaa391
                  DISPLAY BY NAME g_imaa.imaa391
                  NEXT FIELD imaa391
             WHEN INFIELD(imaa907) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imaa.imaa907
                CALL cl_create_qry() RETURNING g_imaa.imaa907
                DISPLAY BY NAME g_imaa.imaa907
                NEXT FIELD imaa907
             WHEN INFIELD(imaa908) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imaa.imaa908
                CALL cl_create_qry() RETURNING g_imaa.imaa908
                DISPLAY BY NAME g_imaa.imaa908
                NEXT FIELD imaa908
             WHEN INFIELD(imaa920)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gei2"
                LET g_qryparam.default1 = g_imaa.imaa920
                LET g_qryparam.where = " geh04='5'"
                CALL cl_create_qry() RETURNING g_imaa.imaa920
                DISPLAY g_imaa.imaa920 TO imaa920
             WHEN INFIELD(imaa923)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gei2" 
                LET g_qryparam.default1 = g_imaa.imaa923
                LET g_qryparam.where = " geh04='6'"
                CALL cl_create_qry() RETURNING g_imaa.imaa923
                DISPLAY g_imaa.imaa923 TO imaa923
#No.TQC-B90236 ---- add start -------
            WHEN INFIELD(imaa929)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imaa929_1"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_imaa.imaa929
               CALL cl_create_qry() RETURNING g_imaa.imaa929
               DISPLAY g_imaa.imaa929 TO imaa929
               NEXT FIELD imaa929
#No.TQC-B90236 ---- add end ---------
#FUN-B50106 --------------------Begin-------------------------
             WHEN INFIELD(imaaicd01) #母體料號   #FUN-B50106
                CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_imaaicd"   #FUN-B50106    #FUN-B70051 amrk
                LET g_qryparam.form     = "q_imaicd"       #FUN-B70051
               #LET g_qryparam.where    = " imaaicd05='1'"   #FUN-B50106     #FUN-B70051 mark
                #LET g_qryparam.where    = " imaicd05='1'"    #FUN-B70051    #FUN-C30278
                LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"    #FUN-C30278
                LET g_qryparam.default1 = g_imaa.imaaicd01   #FUN-B50106 
                CALL cl_create_qry() RETURNING g_imaa.imaaicd01    #FUN-B50106
                DISPLAY BY NAME g_imaa.imaaicd01                   #FUN-B50106
                NEXT FIELD imaaicd01                               #FUN-B50106
             WHEN INFIELD(imaaicd16) #外編子體 (客戶下單料號)
                CALL cl_init_qry_var()
               #LET g_qryparam.form     = "q_imaaicd"          #FUN-B70051
                LET g_qryparam.form     = "q_imaicd"           #FUN-B70051
               #LET g_qryparam.where    = " imaaicd04='4'"     #FUN-B70051
                LET g_qryparam.where    = " imaicd04='1'"     #FUN-B70051
                LET g_qryparam.default1 = g_imaa.imaaicd16
                CALL cl_create_qry() RETURNING g_imaa.imaaicd16
                DISPLAY BY NAME g_imaa.imaaicd16 
             WHEN INFIELD(imaaicd10) #作業群組 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_icd11" 
                LET g_qryparam.arg1 = 'U'      
                LET g_qryparam.default1 = g_imaa.imaaicd10
                CALL cl_create_qry() RETURNING g_imaa.imaaicd10
                DISPLAY BY NAME g_imaa.imaaicd10
                NEXT FIELD imaaicd10
#FUN-B50106 -------------------End------------------------------
               OTHERWISE EXIT CASE
            END CASE
 
#FUN-B70051-add-str--
        #"查詢測試料件"
        ON ACTION qry_test_item
           CASE 
              WHEN INFIELD(imaaicd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_imaaicd"
                 #LET g_qryparam.where    = " imaaicd05='1'"     #FUN-C30278
                 LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"    #FUN-C30278
                 LET g_qryparam.default1 = g_imaa.imaaicd01
                 CALL cl_create_qry() RETURNING g_imaa.imaaicd01
                 DISPLAY BY NAME g_imaa.imaaicd01
                 NEXT FIELD imaaicd01
              WHEN INFIELD(imaaicd16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_imaaicd"
                 #LET g_qryparam.where    = " imaaicd05='1'"    #FUN-C30278
                 LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"    #FUN-C30278
                 LET g_qryparam.default1 = g_imaa.imaaicd01
                 CALL cl_create_qry() RETURNING g_imaa.imaaicd16
                 DISPLAY BY NAME g_imaa.imaaicd16
                 NEXT FIELD imaaicd16
              OTHERWISE
                 CALL cl_err('','aic-327',0)       #TQC-C40084
                 EXIT CASE
           END CASE
#FUN-B70051-add-end--
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION update
            IF NOT cl_null(g_imaa.imaa01) THEN
               LET g_doc.column1 = "imaa01"
               LET g_doc.value1 = g_imaa.imaa01
               CALL cl_fld_doc("imaa04")
            END IF
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  

          ON ACTION auto_getno
            IF g_imaa.imaa00 = 'I' AND cl_null(g_imaa.imaa01) THEN #新增且申請料件編號為空時,才CALL自動編號附程式
                IF g_aza.aza28 = 'Y' THEN
                   CALL s_auno(g_imaa.imaa01,'1','') RETURNING g_imaa.imaa01,g_imaa.imaa02  #No.FUN-850100
                   IF NOT cl_null(g_imaa_t.imaa02) THEN
                      IF g_imaa_t.imaa02 <> g_imaa_o.imaa02 THEN
                         LET g_imaa.imaa02 = g_imaa_o.imaa02
                      ELSE 
                         LET g_imaa.imaa02 = g_imaa_t.imaa02
                      END IF 
                   END IF
                   DISPLAY BY NAME g_imaa.imaa01,g_imaa.imaa02
                END IF
            END IF
             
    END INPUT
    IF INT_FLAG THEN ROLLBACK WORK RETURN END IF     #MOD-C30147
    COMMIT WORK                                      #MOD-C30147
#No.TQC-B90236 ----------------- add start ----------------------------
    IF g_imaa_t.imaa928= "Y" AND g_imaa.imaa928= "N" THEN
       DELETE FROM imad_file WHERE imad01 = g_imaa.imaa01
    END IF
    IF (g_imaa.imaa929 != g_imaa_t.imaa929
       OR (cl_null(g_imaa.imaa929) AND NOT cl_null(g_imaa_t.imaa929))
       OR (NOT cl_null(g_imaa.imaa929) AND  cl_null(g_imaa_t.imaa929))) 
       OR (p_cmd='a' AND NOT cl_null(g_imaa.imaa929)) THEN
       DELETE FROM imad_file WHERE imad01= g_imaa.imaa01
       LET g_sql= "SELECT * FROM imac_file WHERE imac01='", g_imaa.imaa929,"'"
       PREPARE aimi_bc FROM g_sql
       DECLARE aimi_cs CURSOR FOR aimi_bc
       FOREACH aimi_cs INTO g_imad.*
          INSERT INTO imad_file(imad01,imad02,imad03,imad04,imad05,imaduser,imadgrup,imadorig,imadoriu)
          VALUES(g_imaa.imaa01,g_imad.imad02,g_imad.imad03,g_imad.imad04,'',g_user,g_grup,g_grup,g_user)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","imad_file",g_imaa.imaa01,"",SQLCA.sqlcode,"","",1)
             RETURN
          END IF
       END FOREACH
       SELECT COUNT(*) INTO l_n FROM inj_file WHERE inj01 = g_imaa.imaa01
       IF l_n = 0 THEN  #不存在料件的特性資料檔時 才可進行特性維護
          CALL aimi150_add(g_imaa.imaa01,g_imaa.imaa918,g_imaa.imaa928,g_imaa.imaa929)
       END IF
    END IF
#No.TQC-B90236 ----------------- add end ------------------------------
 
    IF g_imaa.imaaag IS NOT NULL THEN
       CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
    END IF
 
END FUNCTION
 
#str MOD-A60090 add
FUNCTION aimi150_a_updchk()
   LET g_imaa.imaa31=g_imaa.imaa25
   LET g_imaa.imaa31_fac=1

   LET g_imaa.imaa44=g_imaa.imaa25   #採購單位
   LET g_imaa.imaa44_fac=1

   LET g_imaa.imaa55=g_imaa.imaa25   #生產單位
   LET g_imaa.imaa55_fac=1

   LET g_imaa.imaa63=g_imaa.imaa25   #發料單位
   LET g_imaa.imaa63_fac=1

   LET g_imaa.imaa86=g_imaa.imaa25   #庫存單位=成本單位
   LET g_imaa.imaa86_fac=1
END FUNCTION
#end MOD-A60090 add

 FUNCTION aimi150_imaa06(p_def) 
   DEFINE
               p_def          LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
               l_ans          LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
               l_msg          LIKE ze_file.ze03,       #No.FUN-690026 VARCHAR(57)
               l_imz02        LIKE imz_file.imz02,
               l_imzacti      LIKE imz_file.imzacti,
               l_imaaacti     LIKE imaa_file.imaaacti,
               l_imaauser     LIKE imaa_file.imaauser,
               l_imaagrup     LIKE imaa_file.imaagrup,
               l_imaamodu     LIKE imaa_file.imaamodu,
               l_imaadate     LIKE imaa_file.imaadate
   DEFINE     l_imad          RECORD LIKE imad_file.*   #MOD-C30147
   DEFINE     l_imzc          RECORD LIKE imzc_file.*   #MOD-C30147
 
   LET g_errno = ' '
   LET l_ans=' '
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_imaa.imaa06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN #MOD-490474
      CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
      CALL cl_confirm('mfg5033') RETURNING l_ans
      IF l_ans THEN
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
                 imz59 ,imz60,imz601,imz61,imz62,   #FUN-930108--add imz601
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
                 imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,    #MOD-B40150
                 imz928,imz929,                                #TQC-B90236
                 imz926,             #FUN-930108 add imz926
                 imz136,imz137,imz391,imz1321,
                 imz72
                 ,imzicd01,imzicd04,imzicd05,imzicd16,  #FUN-B30192
                 imzicd08,imzicd09,imzicd10,            #FUN-B30192
               # imzicd12,imzicd13,imzicd14,imzicd15,   #FUN-B30192 #FUN-B50096
                 imzicd12,imzicd14,imzicd15,            #FUN-B50096 mark imzicd13
                 imzicd17,imzicd18,imzicd19,imzicd20,imzicd21,   #FUN-BC0103
                 imz022,imz251,imz159,imz163,imz1631                   #FUN-B30092 add  #FUN-B50096 add imz159  #FUN-D30003--add>imz163,imz1631
                 INTO g_imaa.imaa06,l_imz02,g_imaa.imaa03,g_imaa.imaa04,
                      g_imaa.imaa07,g_imaa.imaa08,g_imaa.imaa09,g_imaa.imaa10,
                      g_imaa.imaa11,g_imaa.imaa12,g_imaa.imaa14,g_imaa.imaa15,
                      g_imaa.imaa17,g_imaa.imaa19,g_imaa.imaa21,
                      g_imaa.imaa23,g_imaa.imaa24,g_imaa.imaa25,g_imaa.imaa27, #No:7703 add imaa24
                      g_imaa.imaa28,g_imaa.imaa31,g_imaa.imaa31_fac,g_imaa.imaa34,
                      g_imaa.imaa35,g_imaa.imaa36,g_imaa.imaa37,g_imaa.imaa38,
                      g_imaa.imaa39,g_imaa.imaa42,g_imaa.imaa43,g_imaa.imaa44,
                      g_imaa.imaa44_fac,g_imaa.imaa45,g_imaa.imaa46,g_imaa.imaa47,
                      g_imaa.imaa48,g_imaa.imaa49,g_imaa.imaa491,g_imaa.imaa50,
                      g_imaa.imaa51,g_imaa.imaa52,g_imaa.imaa54,g_imaa.imaa55,
                      g_imaa.imaa55_fac,g_imaa.imaa56,g_imaa.imaa561,g_imaa.imaa562,
                      g_imaa.imaa571,
                      g_imaa.imaa59, g_imaa.imaa60,g_imaa.imaa601,g_imaa.imaa61,g_imaa.imaa62,  #FUN-8C0086 add imaa601
                      g_imaa.imaa63, g_imaa.imaa63_fac,g_imaa.imaa64,g_imaa.imaa641,
                      g_imaa.imaa65, g_imaa.imaa66,g_imaa.imaa67,g_imaa.imaa68,
                      g_imaa.imaa69, g_imaa.imaa70,g_imaa.imaa71,g_imaa.imaa86,
                      g_imaa.imaa86_fac, g_imaa.imaa87,g_imaa.imaa871,g_imaa.imaa872,
                      g_imaa.imaa873, g_imaa.imaa874,g_imaa.imaa88,g_imaa.imaa89,
                      g_imaa.imaa90,g_imaa.imaa94,g_imaa.imaa99,g_imaa.imaa100,     #NO:6842養生
                      g_imaa.imaa101,g_imaa.imaa102,g_imaa.imaa103,g_imaa.imaa105,  #NO:6842養生
                      g_imaa.imaa106,g_imaa.imaa107,g_imaa.imaa108,g_imaa.imaa109,  #NO:6842養生
                      g_imaa.imaa110,g_imaa.imaa130,g_imaa.imaa131,g_imaa.imaa132,  #NO:6842養生
                      g_imaa.imaa133,g_imaa.imaa134,                            #NO:6842養生
                      g_imaa.imaa147,g_imaa.imaa148,g_imaa.imaa903,
                      l_imaaacti,l_imaauser,l_imaagrup,l_imaamodu,l_imaadate,
                      g_imaa.imaa906,g_imaa.imaa907,g_imaa.imaa908,g_imaa.imaa909, #FUN-540025
                      g_imaa.imaa911,  
                      g_imaa.imaa918,g_imaa.imaa919,g_imaa.imaa920,   #MOD-B40150 
                      g_imaa.imaa921,g_imaa.imaa922,g_imaa.imaa923,   #MOD-B40150 
                      g_imaa.imaa924,g_imaa.imaa925,  #MOD-B40150 
                      g_imaa.imaa928,g_imaa.imaa929,                    #TQC-B90236
                      g_imaa.imaa926,                                 #FUN-930108--add imaa926
                      g_imaa.imaa136,g_imaa.imaa137,
                      g_imaa.imaa391,g_imaa.imaa1321,g_imaa.imaa915   #FUN-710060 add   
               #FUN-B50106 ---------------------------Begin-----------------------------------    
                     ,g_imaa.imaaicd01,g_imaa.imaaicd04,g_imaa.imaaicd05,g_imaa.imaaicd16,
                      g_imaa.imaaicd08,g_imaa.imaaicd09,g_imaa.imaaicd10,g_imaa.imaaicd12,                  
                    # g_imaa.imaaicd13,g_imaa.imaaicd14,g_imaa.imaaicd15,       #FUN-B50096
                      g_imaa.imaaicd14,g_imaa.imaaicd15,                        #FUN-B50096 
               #FUN-B50106 ---------------------------End-------------------------------------
                      g_imaa.imaaicd17,g_imaa.imaaicd18,g_imaa.imaaicd19,g_imaa.imaaicd20,g_imaa.imaaicd21,   #FUN-BC0103
                      g_imaa.imaa022,g_imaa.imaa251,g_imaa.imaa159,g_imaa.imaa163,g_imaa.imaa1631         #FUN-B30092 add   #FUN-B50096 add imaa159 #FUN-D30003--add>imaa163,imaa1631
                 FROM  imz_file
                 WHERE imz01 = g_imaa.imaa06

       #MOD-C30147 ----- add ----- begin
       DELETE FROM imad_file WHERE imad01 = g_imaa.imaa01
       DECLARE imad_ins CURSOR FOR
             SELECT * FROM imzc_file WHERE imzc01 = g_imaa.imaa06
       FOREACH imad_ins INTO l_imzc.*
          IF STATUS THEN
             CALL cl_err('foreach:',STATUS,1)
             EXIT FOREACH
          END IF
          LET l_imad.imad01   = g_imaa.imaa01
          LET l_imad.imad02   = l_imzc.imzc02
          LET l_imad.imad03   = l_imzc.imzc03
          LET l_imad.imad04   = l_imzc.imzc04
          LET l_imad.imad05   = l_imzc.imzc05
          LET l_imad.imaduser = l_imzc.imzcuser
          LET l_imad.imadgrup = l_imzc.imzcgrup
          LET l_imad.imadoriu = l_imzc.imzcoriu
          LET l_imad.imadorig = l_imzc.imzcorig
          LET l_imad.imadmodu = l_imzc.imzcmodu
          LET l_imad.imaddate = l_imzc.imzcdate
         
          INSERT INTO imad_file VALUES(l_imad.*)

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","imad_file","aimi150","",SQLCA.sqlcode,"","",1)
             EXIT FOREACH
          END IF
       END FOREACH
       #MOD-C30147 ----- add ----- end
       IF g_imaa.imaa99 IS NULL THEN LET g_imaa.imaa99 = 0 END IF
       IF g_imaa.imaa133 IS NULL THEN LET g_imaa.imaa133 = g_imaa.imaa01 END IF
       IF g_imaa.imaa01[1,4]='MISC' THEN 
          LET g_imaa.imaa08='Z'
       END IF
       #MOD-C30091---begin
       IF cl_null(g_imaa.imaa159) THEN
          LET g_imaa.imaa159 = '3'
       END IF 
       IF g_imaa.imaa918 = 'Y' OR g_imaa.imaa921 = 'Y' THEN
          IF cl_null(g_imaa.imaa925) THEN
             LET g_imaa.imaa925 = '1'
          END IF 
       END IF 
       #MOD-C30091---end
       IF cl_null(g_errno)  AND l_ans ="1"  THEN   
          CALL aimi150_show()
       END IF
     END IF
  END IF
END FUNCTION
 
#FUN-AC0083 ------------add start---------
FUNCTION i150_chk_imaa251()
#DEFINE l_gfe01    LIKE gfe_file.gfe01     #NO.FUN-B30092 mark
#DEFINE l_gfeacti  LIKE gfe_file.gfeacti   #NO.FUN-B30092 mark
 DEFINE l_gfo01    LIKE gfo_file.gfo01
 DEFINE l_gfoacti  LIKE gfo_file.gfoacti

 LET g_errno= ""
# SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file  #NO.FUN-B30092 mark
#  WHERE gfe01 = g_imaa.imaa251                              #NO.FUN-B30092 mark
  SELECT gfo01,gfoacti INTO l_gfo01,l_gfoacti FROM gfo_file  #NO.FUN-B30092
   WHERE gfo01 = g_imaa.imaa251                              #NO.FUN-B30092


  CASE
   WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg0019'
  #WHEN l_gfeacti ='N'      LET g_errno = 'aec-090'     #NO.FUN-B30092 mark
  #                         LET l_gfe01 = NULL          #NO.FUN-B30092 mark
  #                         LET l_gfeacti = NULL        #NO.FUN-B30092 mark
   WHEN l_gfoacti ='N'      LET g_errno = 'aec-090'     #NO.FUN-B30092
                            LET l_gfo01 = NULL          #NO.FUN-B30092
                            LET l_gfoacti = NULL        #NO.FUN-B30092
   OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
  END CASE
END FUNCTION
#FUN-AC0083 ------------add end----------

FUNCTION aimi150_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi150_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_imaa.* TO NULL
        INITIALIZE g_imaa_t.* TO NULL
        INITIALIZE g_imaa_o.* TO NULL
        CLEAR FORM
   CALL g_ind.clear()
        RETURN
    END IF
    MESSAGE "Searching!"
    OPEN aimi150_count
    FETCH aimi150_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi150_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL
    ELSE
        CALL aimi150_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION aimi150_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     aimi150_curs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS aimi150_curs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    aimi150_curs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     aimi150_curs INTO g_imaa.imaano
        WHEN '/'
            IF (NOT mi_no_ask) THEN        #No.FUN-6A0061
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump aimi150_curs INTO g_imaa.imaano
            LET mi_no_ask = FALSE    #No.FUN-6A0061
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flimaa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_imaa.* FROM imaa_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imaano = g_imaa.imaano
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_data_owner = g_imaa.imaauser    
        LET g_data_group = g_imaa.imaagrup    
        CALL aimi150_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi150_show()
 
    SELECT imaa93 INTO g_imaa.imaa93 FROM imaa_file
     WHERE imaano=g_imaa.imaano
    LET g_imaa_t.* = g_imaa.*
    LET g_d2=g_imaa.imaa262-g_imaa.imaa26
    DISPLAY BY NAME g_imaa.imaaoriu,g_imaa.imaaorig,
              g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021 ,g_imaa.imaa06 ,g_imaa.imaa08 ,g_imaa.imaa13 ,g_imaa.imaa03 ,g_imaa.imaa915, g_imaa.imaa1010,g_imaa.imaa92,  #FUN-710060 add ima915
              g_imaa.imaaag  ,g_imaa.imaa910 ,g_imaa.imaa105 ,g_imaa.imaa14  ,g_imaa.imaa107 ,g_imaa.imaa147,g_imaa.imaa109,g_imaa.imaa903,g_imaa.imaa24 ,g_imaa.imaa911, g_imaa.imaa022, g_imaa.imaa251,g_imaa.imaa926, #FUN-930108 add imaa926    #FUN-AC0083 add imaa022,imaa251
              g_imaa.imaa07  ,g_imaa.imaa70  ,g_imaa.imaa37  ,g_imaa.imaa51  ,g_imaa.imaa27  ,g_imaa.imaa28 ,g_imaa.imaa271,g_imaa.imaa71 ,
              g_imaa.imaa25  ,g_imaa.imaa35  ,g_imaa.imaa36  ,g_imaa.imaa23  ,g_imaa.imaa906 ,g_imaa.imaa907,g_imaa.imaa908,g_imaa.imaa159,   #FUN-B50096 add imaa159
              g_imaa.imaa918 ,g_imaa.imaa919 ,g_imaa.imaa920 ,  #No.FUN-810036
              g_imaa.imaa921 ,g_imaa.imaa922 ,g_imaa.imaa923 ,  #No.FUN-810036
              g_imaa.imaa924 ,g_imaa.imaa925 ,   #No.FUN-810036
              g_imaa.imaa928 ,g_imaa.imaa929 ,   #No.TQC-B90236
              g_imaa.imaa151 ,   #FUN-C30026
              g_imaa.imaa12  ,g_imaa.imaa39  ,g_imaa.imaa163,g_imaa.imaa391 ,g_imaa.imaa1631,   #FUN-D30003--add>imaa163,imaa1631
              g_imaa.imaa15  ,g_imaa.imaa905,g_imaa.imaa09 ,g_imaa.imaa10 ,g_imaa.imaa11, 
              g_imaa.imaa1001,g_imaa.imaa1002,g_imaa.imaa1015,g_imaa.imaa1014,g_imaa.imaa1016,
              g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti, 
              g_imaa.imaaud01,g_imaa.imaaud02,g_imaa.imaaud03,g_imaa.imaaud04,
              g_imaa.imaaud05,g_imaa.imaaud06,g_imaa.imaaud07,g_imaa.imaaud08,
              g_imaa.imaaud09,g_imaa.imaaud10,g_imaa.imaaud11,g_imaa.imaaud12,
              g_imaa.imaaud13,g_imaa.imaaud14,g_imaa.imaaud15
#FUN-B50106 -------------Begin------------- 
   DISPLAY BY NAME g_imaa.imaaicd01,
                   g_imaa.imaaicd02,
                   g_imaa.imaaicd03,
                   g_imaa.imaaicd04,
                   g_imaa.imaaicd05,
                   g_imaa.imaaicd06,
                   g_imaa.imaaicd08,
                   g_imaa.imaaicd09,
                   g_imaa.imaaicd10,
                   g_imaa.imaaicd11,
                   g_imaa.imaaicd12,
              #    g_imaa.imaaicd13,   #FUN-B50096
                   g_imaa.imaaicd14,
                   g_imaa.imaaicd15,
                   g_imaa.imaaicd16,
                   g_imaa.imaaicd17,   #FUN-BC0103
                   g_imaa.imaaicd18,   #FUN-BC0103
                   g_imaa.imaaicd19,   #FUN-BC0103
                   g_imaa.imaaicd20,   #FUN-BC0103
                   g_imaa.imaaicd21   #FUN-BC0103
#FUN-B50106 -------------End---------------
 
    DISPLAY BY NAME g_imaa.imaa130,g_imaa.imaa31,g_imaa.imaa44,g_imaa.imaa55,g_imaa.imaa63
 
    IF NOT cl_is_multi_feature_manage(g_imaa.imaa01) THEN
       CALL cl_set_act_visible("add_multi_attr_sub",FALSE)
    ELSE
       CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
    END IF
 
    IF g_sma.sma120 = 'Y' THEN
       CALL cl_set_comp_visible("imaaag",TRUE)
    END IF
 
    LET g_doc.column1 = "imaa01"
    LET g_doc.value1 = g_imaa.imaa01
    CALL cl_get_fld_doc("imaa04")
     LET g_gen02 = ""
     SELECT gen02 INTO g_gen02
       FROM gen_file
      WHERE gen01=g_imaa.imaa23
     DISPLAY g_gen02 TO FORMONLY.gen02
 
    CALL i150_show_pic()
    CALL cl_show_fld_cont()   
END FUNCTION
 
FUNCTION aimi150_u(p_cmd)       #CHI-840022---mod   #No:MOD-970122 modify
    DEFINE l_imzacti  LIKE imz_file.imzacti
    DEFINE p_cmd      LIKE type_file.chr1           #No:MOD-970122 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
    IF g_imaa.imaaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_imaa.imaano,'mfg1000',0)
       RETURN
    END IF
    #非開立狀態，不可異動！
   #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_input_itemno = 'N' THEN #CHI-840022 add if 判斷
        IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imaa01_t = g_imaa.imaa01
    LET g_imaano_t = g_imaa.imaano
    LET g_imaa_o.* = g_imaa.*
    LET g_imaa_t.* = g_imaa.*       #MOD-890132 add
       BEGIN WORK    
 
    OPEN aimi150_cl USING g_imaa.imaano
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK     
       RETURN
    END IF
    FETCH aimi150_cl INTO g_imaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK    
       RETURN
    ELSE   #TQC-660102

    END IF
    LET g_imaa.imaamodu = g_user                   #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    LET g_imaa906 = g_imaa.imaa906
    LET g_imaa907 = g_imaa.imaa907
    LET g_imaa908 = g_imaa.imaa908
    #TQC-C60004---begin
    IF s_industry('icd') THEN 
       IF g_imaa.imaaicd04 = '0' THEN
          LET g_imaa.imaaicd01 = g_imaa.imaa01
          CALL cl_set_comp_entry("imaaicd01",FALSE)
       ELSE
          CALL cl_set_comp_entry("imaaicd01",TRUE)
       END IF 
    END IF 
    #TQC-C60004---end
    
    CALL aimi150_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_imaa.imaamodu = g_user                   #修改者
        LET g_imaa.imaadate = g_today                  #修改日期
        CALL aimi150_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imaa.*=g_imaa_t.*
            CALL aimi150_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK       #FUN-680010
            EXIT WHILE
        END IF
        #為了擋user是使用copy,但使用的舊料件的主分群碼已無效
        LET g_errno=' '
        SELECT imzacti INTO l_imzacti FROM imz_file
         WHERE imz01 = g_imaa.imaa06
        CASE
           WHEN SQLCA.SQLCODE = 100
              LET g_errno = 'mfg3179'
           WHEN l_imzacti='N'
              LET g_errno = '9028'
           OTHERWISE
              LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(g_imaa.imaa06,g_errno,1)
           DISPLAY BY NAME g_imaa.imaa06
           ROLLBACK WORK       
           BEGIN WORK         
           CONTINUE WHILE
        END IF
       IF g_imaa.imaa1010 MATCHES '[RW]' THEN
           LET g_imaa.imaa1010 = '0' #開立
       END IF
        IF cl_null(g_imaa.imaa01) THEN
            LET g_imaa.imaa01 = ' '
        END IF
       IF p_cmd = 'a' AND g_imaa.imaa00 = 'I' THEN 
          IF cl_null(g_imaa.imaa571) OR g_imaa_t.imaa01 = g_imaa.imaa571 THEN #MOD-C60188
             LET g_imaa.imaa571 = g_imaa.imaa01
          END IF

          IF cl_null(g_imaa.imaa133) THEN
             LET g_imaa.imaa133 = g_imaa.imaa01
          END IF
          #FUN-C50111---begin
          IF g_imaa.imaaicd04 = '0' THEN
             LET g_imaa.imaaicd01 = g_imaa.imaa01
          END IF 
          #FUN-C50111---end
       END IF 
        UPDATE imaa_file SET imaa_file.* = g_imaa.*    # 更新DB
            WHERE imaano = g_imaano_t             # COLAUTH?
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ROLLBACK WORK
           BEGIN WORK
           CONTINUE WHILE
        ELSE           
           LET g_errno = TIME
           LET g_msg = 'Chg No:',g_imaa.imaano
           INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
              VALUES ('aimi150',g_user,g_today,g_errno,g_imaa.imaano,g_msg,g_plant,g_legal) #No.FUN-980004
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","aimi150","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              BEGIN WORK
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi150_cl
    COMMIT WORK #TQC-740090 add
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
    CALL aimi150_show()                                            
END FUNCTION
 
FUNCTION aimi150_x()
    DEFINE
        l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n   LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_imaano      LIKE imaa_file.imaano #MOD-B40095 add
 
    LET g_errno = ''   
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #非開立狀態，不可異動！
   #狀況=>R:送簽退回,W:抽單 也要可以做無效切換
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 

   #MOD-B40095 add --start--
   IF g_imaa.imaa00 = 'U' AND g_imaa.imaaacti='N' THEN
      LET l_imaano = NULL                                       
      SELECT imaano INTO l_imaano FROM imaa_file                
       WHERE imaa01 = l_newno01                             
         AND imaa00 = 'U' #修改                                 
         AND imaa1010 != '2'                                    
         AND imaaacti != 'N' 
      IF NOT cl_null(l_imaano) THEN                             
         #已存在一張相同料號,但未拋轉的料件申請單!              
         CALL cl_err(l_imaano,'aim-150',1)                      
         RETURN
      END IF               
   END IF
   #MOD-B40095 add --end--

    BEGIN WORK
    OPEN aimi150_cl USING g_imaa.imaano
    FETCH aimi150_cl INTO g_imaa.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL aimi150_show()
 
    IF cl_exp(0,0,g_imaa.imaaacti) THEN
        LET g_chr=g_imaa.imaaacti
        IF g_imaa.imaaacti='Y' THEN
            LET g_imaa.imaaacti='N'
        ELSE
            LET g_imaa.imaaacti='Y'
        END IF
        UPDATE imaa_file
            SET imaaacti=g_imaa.imaaacti,
                imaamodu=g_user, 
                imaadate=g_today,
                imaa1010 ='0' #開立 #TQC-750007 add
            WHERE imaano=g_imaa.imaano
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","imaa_file",g_imaa_t.imaano,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
        END IF
    END IF
    CLOSE aimi150_cl
    COMMIT WORK
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL aimi150_show()                                            
END FUNCTION
 
FUNCTION aimi150_r()
    DEFINE l_chr    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_azo06  LIKE azo_file.azo06
    DEFINE l_n       LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #非開立狀態，不可異動！
   #狀況=>R:送簽退回,W:抽單 也要可以做刪除
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 
 
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
 
    BEGIN WORK
 
    OPEN aimi150_cl USING g_imaa.imaano
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-680010      #FUN-B80070---回滾放在報錯後---
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0) 
       ROLLBACK WORK         #FUN-B80070--add--
       RETURN
    END IF
    FETCH aimi150_cl INTO g_imaa.*
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-680010    #FUN-B80070---回滾放在報錯後---
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK           #FUN-B80070--add--
       RETURN
    END IF
    CALL aimi150_show()
    CALL s_chkitmdel(g_imaa.imaano) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,0) RETURN END IF
    IF cl_delete() THEN
        #CHI-AC0026 add --start--
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "imaano"
        LET g_doc.value1 = g_imaa.imaano
        CALL cl_del_doc()
        #CHI-AC0026 add --end--
        DELETE FROM imaa_file WHERE imaano = g_imaa.imaano
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           ROLLBACK WORK  
           RETURN        
        ELSE           
           #TQC-C40036--add--str--
           #No.TQC-B90236 ----------------- add start ----------------
           DELETE FROM imad_file WHERE imad01 = g_imaa_t.imaa01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imad_file",g_imad.imad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ELSE
              CLEAR FORM
           END IF
           #No.TQC-B90236 ----------------- add end ------------------
           #TQC-C40036--add--end--
           LET g_msg=TIME
           #增加記錄料號
           LET l_azo06='R: ',g_imaa.imaano CLIPPED
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004
              VALUES ('aimi150',g_user,g_today,g_msg,g_imaa.imaano,l_azo06,g_plant,g_legal) #FUN-980004
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","aimi150","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN
           END IF
           MESSAGE 'DELETE O.K'     #TQC-C40036  add
           CLEAR FORM #No.TQC-AB0051    
           CALL g_ind.clear()
           OPEN aimi150_count
           FETCH aimi150_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
 
           OPEN aimi150_curs
           #TQC-C40036--mark--str--
           #IF g_curs_index = g_row_count + 1 THEN
           #   LET g_jump = g_row_count
           #   CALL aimi150_fetch('L')
           #ELSE
           #   LET g_jump = g_curs_index
           #   LET mi_no_ask = TRUE      #No.FUN-6A0061
           #   CALL aimi150_fetch('/')
           #END IF
           #TQC-C40036--mark--end--
           #TQC-C40036--add--str--
           IF g_row_count >= 1 THEN
              IF g_curs_index = g_row_count + 1 THEN
                 LET g_jump = g_row_count
              ELSE
                 LET g_jump = g_curs_index
              END IF
              LET mi_no_ask = TRUE
              CALL aimi150_fetch('/')
           ELSE 
              INITIALIZE g_imaa.* TO NULL  #TQC-C40231 add
           END IF
           #TQC-C40036--add--end--
        END IF
#TQC-C40036--mark--str--
##No.TQC-B90236 ----------------- add start ----------------
#        DELETE FROM imad_file WHERE imad01 = g_imaa_t.imaa01
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("del","imad_file",g_imad.imad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
#        ELSE
#           CLEAR FORM
#        END IF
##No.TQC-B90236 ----------------- add end ------------------
#TQC-C40036--mark--end--
    END IF
    CLOSE aimi150_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi150_copy()
    DEFINE
        l_imaa   RECORD LIKE imaa_file.*,
        l_smd   RECORD LIKE smd_file.*,
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_newno,l_oldno LIKE imaa_file.imaano,
        l_imaano LIKE imaa_file.imaano,
        l_newno00        LIKE imaa_file.imaa00,
        l_newno01,l_oldno01 LIKE imaa_file.imaa01
    DEFINE  li_result   LIKE type_file.num5 
    DEFINE l_imaa92_o     LIKE imaa_file.imaa92  #TQC-9C0004      
    DEFINE l_smyapr       LIKE smy_file.smyapr   #TQC-9C0004        
    DEFINE l_ima120       LIKE ima_file.ima120   #FUN-A90049
    DEFINE l_imaaicd04    LIKE imaa_file.imaaicd04  #TQC-C60004
    DEFINE l_imaaicd01    LIKE imaa_file.imaaicd01  #TQC-C60004
    
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i150_set_entry('a')
    LET g_before_input_done = TRUE

    SELECT imaa92 INTO l_imaa92_o FROM imaa_file
     WHERE imaano = g_imaa.imaano     
 
    INPUT l_newno00,l_newno,l_newno01 FROM imaa00,imaano,imaa01
                                                                                
        AFTER FIELD imaa00                                                      
            IF cl_null(l_newno00) THEN                                      
                NEXT FIELD imaa00                                               
            END IF                                                              
                                                                                
        AFTER FIELD imaano                                                      
 
          IF NOT cl_null(g_imaa.imaano) THEN                                    
             LET l_n = 0                                                        
             SELECT COUNT(*) INTO l_n                                           
               FROM imaa_file                                                   
              WHERE imaano=l_newno                                      
             IF l_n > 0 THEN                                                    
                CALL cl_err('sel imaa:','-239',0)                               
                NEXT FIELD imaano                                               
             END IF                                                             
             LET g_t1=s_get_doc_no(l_newno)                               
             CALL s_check_no('aim',l_newno,"","Z","imaa_file","imaano","")
                  RETURNING li_result,l_newno                     
             IF (NOT li_result) THEN                                            
                  LET l_newno=l_oldno                             
                  NEXT FIELD imaano                                             
             END IF                                                             
             LET g_t1=l_newno[1,g_doc_len]                                
             CALL s_auto_assign_no("aim",l_newno,g_today,"Z","imaa_file","imaano","","","") RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                 NEXT FIELD imaano 
              END IF
              DISPLAY l_newno TO imaano
             SELECT smyapr INTO l_smyapr FROM smy_file
              WHERE smyslip = g_t1
            END IF  
 
        BEFORE FIELD imaa01                                                     
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入                             
               CALL s_inp5(6,14,l_newno01) RETURNING l_newno01
               DISPLAY l_newno01 TO imaa01                             
            END IF                                                              
                                                                                
            IF l_newno00 = 'I' AND cl_null(l_newno01) THEN #新增且申請料
                IF g_aza.aza28 = 'Y' THEN                                       
                   CALL s_auno(l_newno01,'1','') RETURNING l_newno01,g_imaa.imaa02
                END IF                                                          
            END IF                                                              
         
        AFTER FIELD imaa01                                                      
            IF NOT cl_null(l_newno01) THEN                                  
               IF cl_null(l_oldno01) OR ( l_newno01!= l_oldno01) THEN
                  #FUN-B70057 add
                  IF l_newno01[1,1] = ' ' THEN
                     CALL cl_err(l_newno01,"aim-671",0)
                     LET l_newno01 = l_oldno01            
                     DISPLAY BY NAME l_newno01                         
                     NEXT FIELD imaa01                                      
                  END IF
                  #FUN-B70057 add--end
                  IF g_imaa.imaa00 = 'I' THEN #新增                             
                  #MOD-C30208--mark--str--    
                  #   #No.FUN-A90049 -----------------add 申請類別為新增時，依料件性質show不同訊息 ----------------
                  #   #IF NOT s_chk_item_no(g_imaa.imaa01,g_plant) THEN                   #MOD-C30208  mark
                  #   IF NOT s_chk_item_no(l_newno01,g_plant) THEN                        #MOD-C30208  add 
                  #      SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_imaa.imaa01
                  #      IF l_ima120 = '1' THEN
                  #         CALL cl_err(g_imaa.imaa01,'aim-023',0)
                  #      ELSE
                  #         IF l_ima120 = '2' THEN
                  #            CALL cl_err(g_imaa.imaa01,'aim-024',0)
                  #         END IF
                  #      END IF
                  #      LET g_imaa.imaa01 = g_imaa_t.imaa01
                  #      DISPLAY BY NAME g_imaa.imaa01
                  #      NEXT FIELD imaa01
                  #   END IF
                  #MOD-C30208--mark--end--    
                    #No.FUN-A90049  ---------------add end----------------------------------------------------
                      SELECT count(*) INTO l_n FROM ima_file                    
                       WHERE ima01 = l_newno01                             
                      IF l_n > 0 THEN                                           
                         CALL cl_err(l_newno01,-239,1) #FUN-7C0084 mod      
                         LET l_newno01 = l_oldno01            
                         DISPLAY BY NAME l_newno01                         
                         NEXT FIELD imaa01                                      
                      END IF                                                    
                      SELECT count(*) INTO l_n FROM imaa_file                   
                       WHERE imaa01 = l_newno01                   
                         AND imaa00 = 'I' #新增                                 
                      IF l_n > 0 THEN                                           
                         CALL cl_err(l_newno01,-239,1)                      
                         LET l_newno01 = l_oldno01         
                         DISPLAY  l_newno01  TO imaa01                 
                         NEXT FIELD imaa01                                      
                      END IF          
                  ELSE                                                          
                      SELECT count(*) INTO l_n FROM ima_file                    
                       WHERE ima01 = l_newno01                       
                         AND (ima120 = '1' OR ima120 = NULL OR ima120 = ' ')  #FUN-A90049 add
                      IF l_n <= 0 THEN                                          
                         #無此料件編號, 請重新輸入                              
                         CALL cl_err(l_newno01,'ams-003',1) #FUN-7C0084 訊息
                         LET l_newno01 = l_oldno01                    
                         NEXT FIELD imaa01                                      
                      END IF                                                    
                      LET l_imaano = NULL                                       
                      SELECT imaano INTO l_imaano FROM imaa_file                
                       WHERE imaa01 = l_newno01                             
                         AND imaa00 = 'U' #修改                                 
                         AND imaa1010 != '2'                                    
                         AND imaaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_imaano) THEN                             
                         #已存在一張相同料號,但未拋轉的料件申請單!              
                         CALL cl_err(l_imaano,'aim-150',1)                      
                         LET l_newno01 = l_oldno01                    
                         DISPLAY l_newno01 TO imaa01                        
                         NEXT FIELD imaa01                                      
                      END IF               
                   END IF                                                                                
                END IF                                                                                
            #-----------------No:MOD-A10092 add
             ELSE                             
                IF l_newno00 <> 'I' THEN
                  CALL cl_err('','aim-157',0)     
                  NEXT FIELD imaa01             
                END IF
            #-----------------No:MOD-A10092 end
             END IF                                                                                
        ON ACTION controlp                                                      
            CASE                                                                
               WHEN INFIELD(imaano)                                             
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','Z') RETURNING g_t1         
                  LET l_newno = g_t1                                      
                  DISPLAY BY NAME l_newno                                 
                  NEXT FIELD imaano                                             
               WHEN INFIELD(imaa01) #料件編號                                   
                    IF g_imaa.imaa00='U' THEN                                   
                        #'U':修改時查ima01                                      
                        CALL cl_init_qry_var()                                  
                        LET g_qryparam.form = 'q_ima'                           
                        LET g_qryparam.where    = " ( ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "  #FUN-AB0011 add
                        LET g_qryparam.default1 = l_newno01                 
                        CALL cl_create_qry() RETURNING l_newno01            
                        DISPLAY BY NAME l_newno01                           
                        NEXT FIELD imaa01                                       
                    END IF       
            OTHERWISE EXIT CASE                                                 
         END CASE 
     #----------------No:MOD-A10092 add
      AFTER INPUT
         IF l_newno00 <> 'I' AND cl_null(l_newno01)  THEN    
            NEXT FIELD imaa01
         END IF
     #----------------No:MOD-A10092 end
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
        DISPLAY BY NAME g_imaa.imaano
        RETURN
    END IF
    IF NOT cl_confirm('mfg-065') THEN RETURN END IF
    CALL cl_err('','aim-993','0')
    IF cl_null(l_newno01) THEN LET l_newno01 = ' ' END IF   #No:MOD-A10092 add
   
    DROP TABLE x
    
    SELECT * FROM imaa_file WHERE  imaano = g_imaa.imaano INTO TEMP x
    #TQC-C60004---begin
    IF s_industry('icd') THEN  
       SELECT imaaicd04, imaaicd01 INTO l_imaaicd04,l_imaaicd01 FROM imaa_file
        WHERE imaano = g_imaa.imaano
       IF l_imaaicd04 = '0' THEN
          LET l_imaaicd01 = l_newno01
       ELSE
          LET l_imaaicd01 = NULL 
       END IF  
    END IF 
    #TQC-C60004---end
    
    UPDATE x 
      SET imaa00 = l_newno00,
          imaano = l_newno, 
          imaa01 = l_newno01,
          imaa571 = l_newno01,       #MOD-B30242 add
          imaa1010 = '0',     #No.FUN-610013
          imaauser=g_user,    #資料所有者
          imaagrup=g_grup,    #資料所有者所屬群
          imaamodu=NULL,      #資料修改日期
          imaadate=g_today,   #資料建立日期
          imaaacti='Y',       #有效資料
          imaaicd01 = l_imaaicd01,  #TQC-C60004
          imaa92=l_smyapr     #MOD-D10213
          

    INSERT INTO imaa_file SELECT * FROM x
    #MOD-D10213---begin mark
    #IF l_imaa92_o = 'Y' AND l_smyapr = 'N' THEN 
    #     UPDATE imaa_file SET imaa92 = 'N' 
    #      WHERE imaano = l_newno
    #END IF 
    #MOD-D10213---end
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_imaa.imaano,SQLCA.sqlcode,0)
    ELSE
       #TQC-C40044--add--str--
       DROP TABLE y
       SELECT * FROM imad_file WHERE  imad01 = g_imaa.imaa01 INTO TEMP y
       UPDATE y 
          SET imad01 = l_newno01,
              imaduser=g_user,    #資料所有者
              imadgrup=g_grup,    #資料所有者所屬群
              imadorig=g_grup,      
              imadoriu=g_user   
       INSERT INTO imad_file SELECT * FROM y
       IF SQLCA.sqlcode THEN
          CALL cl_err(l_newno01,SQLCA.sqlcode,0)
       END IF
       #TQC-C40044--add--end--
       CALL s_zero(l_newno)            
 
       LET l_oldno = g_imaa.imaano
      
       SELECT imaa_file.* INTO g_imaa.* FROM imaa_file
                      WHERE imaano = l_newno
       CALL aimi150_u('u')     #No:MOD-970122 modify
 
       # CALL aws_spccli_base()
       # 傳入參數: (1)TABLE名稱, (2)新增資料,
       #           (3)功能選項：insert(新增),update(修改),delete(刪除)
       CASE aws_spccli_base('imaa_file',base.TypeInfo.create(g_imaa),'insert')
          WHEN 0  #無與 SPC 整合
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
          WHEN 1  #呼叫 SPC 成功
               MESSAGE 'INSERT O.K, INSERT SPC O.K'
               COMMIT WORK 
          WHEN 2  #呼叫 SPC 失敗
               ROLLBACK WORK
       END CASE
 
       #SELECT imaa_file.* INTO g_imaa.* FROM imaa_file  #FUN-C30027
       #               WHERE imaano = l_oldno            #FUN-C30027
    END IF
    #LET g_imaa.imaano = l_oldno                         #FUN-C30027
    CALL aimi150_show()
END FUNCTION
 
FUNCTION i150_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        sr              RECORD LIKE imaa_file.*,
        l_chr           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_wc            STRING                  #MOD-AA0162 add 
 
    IF cl_null(g_wc) THEN
        LET g_wc=" imaa01='",g_imaa.imaa01,"'"
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM imaa_file ",         # 組合出 SQL 指令   #MOD-AA0162 add   
              " WHERE ",g_wc CLIPPED                                  #MOD-AA0162 add  
   #MOD-AA0040---mark---start---
   #LET g_sql="SELECT * FROM imaa_file ",         # 組合出 SQL 指令
   #          " WHERE ",g_wc CLIPPED
   #PREPARE aimi150_p1 FROM g_sql                 # RUNTIME 編譯
   #DECLARE aimi150_curo                          # CURSOR
   #    CURSOR FOR aimi150_p1
 
   #FOREACH aimi150_curo INTO sr.*
   #    IF SQLCA.sqlcode THEN
   #       CALL cl_err('foreach:',SQLCA.sqlcode,1)
   #       EXIT FOREACH
   #    ELSE
   #    END IF
   #END FOREACH
   #MOD-AA0040---mark---end---
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(g_wc,'imaa01,imaa02,imaa05,imaa08,imaa25')
         #RETURNING g_wc       #MOD-AA0162 mark    
         #LET g_str = g_wc     #MOD-AA0162 mark        
          RETURNING l_wc       #MOD-AA0162 add 
          LET g_str = l_wc     #MOD-AA0162 add
    END IF
    LET g_str = g_str
 
    CALL cl_prt_cs1('aimi150','aimi150',g_sql,g_str) 
 
   #CLOSE aimi150_curo         #MOD-AA0040 mark
    ERROR ""
 
END FUNCTION
FUNCTION i150_chk_imaa09()
   IF cl_null(g_imaa.imaa09) THEN
      RETURN TRUE
   END IF
   CALL s_field_chk(g_imaa.imaa109,'1',g_plant,'ima109') RETURNING g_flag2
   IF g_flag2 = '0' THEN
      CALL cl_err(g_imaa.imaa109,'aoo-043',1)
      LET g_imaa.imaa109 = g_imaa_o.imaa109
      DISPLAY BY NAME g_imaa.imaa109
      RETURN FALSE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_imaa.imaa09 AND azf02='D' 
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa09,"","mfg1306","","",1)  
      LET g_imaa.imaa09 = g_imaa_o.imaa09
      DISPLAY BY NAME g_imaa.imaa09
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa10()
   IF cl_null(g_imaa.imaa10) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_imaa.imaa10 AND azf02='E' #6818
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa10,"","mfg1306","","",1)  
      LET g_imaa.imaa10 = g_imaa_o.imaa10
      DISPLAY BY NAME g_imaa.imaa10
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa11()
   IF cl_null(g_imaa.imaa11) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_imaa.imaa11 AND azf02='F' #6818
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa11,"","mfg1306","","",1)
      LET g_imaa.imaa11 = g_imaa_o.imaa11
      DISPLAY BY NAME g_imaa.imaa11
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa12()
   IF cl_null(g_imaa.imaa12) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_imaa.imaa12 AND azf02='G' #6818
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa12,"","mfg1306","","",1)
      LET g_imaa.imaa12 = g_imaa_o.imaa12
      DISPLAY BY NAME g_imaa.imaa12
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa23()
   IF cl_null(g_imaa.imaa23) THEN
      RETURN TRUE
   END IF
   LET g_gen02 = ""                         
    SELECT gen02 INTO g_gen02 FROM gen_file 
    WHERE gen01=g_imaa.imaa23
      AND genacti='Y'
    DISPLAY g_gen02 TO FORMONLY.gen02      
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","gen_file",g_imaa.imaa23,"","aoo-001","","",1) 
      LET g_imaa.imaa23 = g_imaa_o.imaa23      
      DISPLAY BY NAME g_imaa.imaa23           
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa25()
   IF cl_null(g_imaa.imaa25) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
     WHERE gfe01=g_imaa.imaa25
       AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa25,"","mfg1200","","",1)  
      DISPLAY BY NAME g_imaa.imaa25
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa31()
   IF cl_null(g_imaa.imaa31) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_imaa.imaa31
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa31,"","mfg1311","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa35()
DEFINE l_imd   RECORD LIKE imd_file.*   #FUN-CB0052
   IF cl_null(g_imaa.imaa35) THEN
      RETURN TRUE
   END IF
#  SELECT * FROM imd_file WHERE imd01=g_imaa.imaa35 AND imdacti='Y'                 #FUN-CB0052 mark
   SELECT * INTO l_imd.* FROM imd_file WHERE imd01=g_imaa.imaa35 AND imdacti='Y'    #FUN-CB0052
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","imd_file",g_imaa.imaa35,"","mfg1100","","",1)
      RETURN FALSE
   ELSE
      #FUN-CB0052--add--str--
      IF l_imd.imd10 MATCHES '[Ii]' THEN
         CALL cl_err(l_imd.imd10,'axm-693',0)
         RETURN FALSE 
      ELSE
         RETURN TRUE
      END IF
      #FUN-CB0052--add--end--      
     #RETURN TRUE   #FUN-CB0052 mark
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa39()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa39) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa39
             AND aag07 != '1'  
             AND aag00 = g_aza.aza81  #No.FUN-730020
   IF l_cnt=0 THEN     # Unique
      #CALL cl_err(g_imaa.imaa39,"anm-001",1) #FUN-B10049
      CALL cl_err(g_imaa.imaa39,"anm-001",0) #FUN-B10049
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

#FUN-D30003---add---str---
FUNCTION i150_chk_imaa163()
DEFINE l_cnt LIKE type_file.num10
   IF cl_null(g_imaa.imaa163) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa163
             AND aag07 != '1'
             AND aag00 = g_aza.aza81
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa163,"anm-001",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#FUN-D30003---add---end---
#TQC-AB0197---------------add------------str---------------
FUNCTION i150_chk_imaa391()
DEFINE l_cnt LIKE type_file.num10 
   IF cl_null(g_imaa.imaa391) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa391
            AND aag07 != '1'
            AND aag00 = g_aza.aza82
   IF l_cnt=0 THEN
      #CALL cl_err(g_imaa.imaa391,"anm-001",1) #FUN-B10049
      CALL cl_err(g_imaa.imaa391,"anm-001",0) #FUN-B10049
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#TQC-AB0197---------------add------------end---------------
#FUN-D30003---add---str---
FUNCTION i150_chk_imaa1631()
DEFINE l_cnt LIKE type_file.num10
   IF cl_null(g_imaa.imaa1631) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa1631
            AND aag07 != '1'
            AND aag00 = g_aza.aza82
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa1631,"anm-001",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#FUN-D30003---add---end---

#FUN-D60083--add--str--
FUNCTION i150_chk_imaa164()
DEFINE l_cnt LIKE type_file.num10
   IF cl_null(g_imaa.imaa164) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa164
             AND aag07 != '1'
             AND aag00 = g_aza.aza81
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa164,"anm-001",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i150_chk_imaa1641()
DEFINE l_cnt LIKE type_file.num10
   IF cl_null(g_imaa.imaa1641) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa1641
            AND aag07 != '1'
            AND aag00 = g_aza.aza82
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa1641,"anm-001",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#FUN-D60083--add--end--
 
FUNCTION i150_chk_imaa43()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa43) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM gen_file
      WHERE gen01=g_imaa.imaa43
        AND genacti='Y'
   IF SQLCA.SQLCODE OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa43,'apm-048',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa44()
   IF cl_null(g_imaa.imaa44) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
      WHERE gfe01=g_imaa.imaa44
        AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa44,"","apm-047","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa54()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa54) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM pmc_file
      WHERE pmc01 = g_imaa.imaa54
        AND pmcacti='Y'
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa54,'mfg3001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa55()
   IF cl_null(g_imaa.imaa55) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_imaa.imaa55
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa55,"","mfg1325","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa571()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa571) THEN
      RETURN TRUE
   END IF
 
   IF g_imaa.imaa01=g_imaa.imaa571 THEN
      RETURN TRUE
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM ecu_file WHERE ecu01=g_imaa.imaa571
      AND ecuacti = 'Y'  #CHI-C90006
   IF l_cnt =0 THEN              #No:MOD-970083 modify
      CALL cl_err(g_imaa.imaa571,'aec-014',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa63()
   IF cl_null(g_imaa.imaa63) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_imaa.imaa63
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa63,"","mfg1326","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa67()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa67) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM gen_file
      WHERE gen01=g_imaa.imaa67
        AND genacti='Y'
   IF SQLCA.SQLCODE OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa67,'arm-045',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa86()
   IF cl_null(g_imaa.imaa86) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_imaa.imaa86
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa86,"","mfg1203","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa87()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa87) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt
      FROM smg_file WHERE smg01 = g_imaa.imaa87
                      AND smgacti='Y'
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa87,'mfg1313',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa872()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa872) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt
      FROM smg_file WHERE smg01 = g_imaa.imaa872
                      AND smgacti='Y'
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa872,'mfg1313',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa874()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa874) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt
      FROM smg_file WHERE smg01 = g_imaa.imaa874
                      AND smgacti='Y'
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa874,'mfg1313',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa109()
   IF cl_null(g_imaa.imaa109) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_imaa.imaa109 AND azf02='8'
        AND azfacti='Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa109,"","mfg1306","","",1)  
      LET g_imaa.imaa109 = g_imaa_o.imaa109
      DISPLAY BY NAME g_imaa.imaa109
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa131()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   SELECT COUNT(*) INTO l_cnt FROM oba_file
    WHERE oba01=g_imaa.imaa131
   IF STATUS THEN
      CALL cl_err(g_imaa.imaa131,'aim-142',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa132()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa132) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt FROM aag_file
          WHERE aag01 = g_imaa.imaa132
            AND aag00 = g_aza.aza81  #No.FUN-730020
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa132,"anm-001",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa133(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa133) THEN
      RETURN TRUE
   END IF
   IF p_cmd='u' THEN
      SELECT COUNT(*) INTO l_cnt FROM imaa_file
       WHERE imaa01 = g_imaa.imaa133
      IF l_cnt = 0  THEN
         CALL cl_err(g_imaa.imaa133,'axm-297',1)
         RETURN FALSE
      ELSE
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa134()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa134) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM obe_file
      WHERE obe01=g_imaa.imaa134
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa134,'axm-810',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa136()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   IF cl_null(g_imaa.imaa136) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM imd_file 
      WHERE imd01=g_imaa.imaa136 
        AND imdacti='Y'
   IF SQLCA.SQLCODE OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa136,'mfg1100',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa137()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imeacti LIKE ime_file.imeacti  #No.TQC-D50116 add
DEFINE l_err     LIKE ime_file.ime02    #No.TQC-D50116 add

   IF cl_null(g_imaa.imaa137) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_imaa.imaa136
                                              AND ime02=g_imaa.imaa137
   IF SQLCA.SQLCODE OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa137,'mfg1101',0)
      RETURN FALSE
   ELSE
	#FUN-D40103--add--str--
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01=g_imaa.imaa136
         AND ime02=g_imaa.imaa137
      IF l_imeacti = 'N' THEN 
         LET l_err = g_imaa.imaa137                        #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF   #TQC-D50116 add
         CALL cl_err_msg("","aim-507",g_imaa.imaa136 || "|" || l_err,0)  #TQC-D50116
         RETURN FALSE
      END IF
      #FUN-D40103--add--end--
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i150_chk_imaa907(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_factor        LIKE img_file.img21
   IF cl_null(g_imaa.imaa907) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
    WHERE gfe01=g_imaa.imaa907
      AND gfeacti IN ('Y','y')
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa907,"","mfg0019","","",1)
      LET g_imaa.imaa907 = g_imaa_o.imaa907
      DISPLAY BY NAME g_imaa.imaa907
      RETURN FALSE
   END IF
  #MOD-B30173---add---start---
   IF cl_null(g_imaa.imaa01) THEN
      RETURN TRUE
   END IF
  #MOD-B30173---add---end---
   #母子單位時,第二單位必須和imaa25有轉換率
   CALL s_du_umfchk(g_imaa.imaa01,'','','',g_imaa.imaa25,
                    g_imaa.imaa907,g_imaa.imaa906)
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_imaa.imaa01,g_errno,0)
      RETURN FALSE
   END IF
   IF g_imaa907 <> g_imaa.imaa907 AND g_imaa907 IS NOT NULL AND p_cmd = 'u' THEN
      IF NOT cl_confirm('aim-999') THEN
         LET g_imaa.imaa907=g_imaa907
         DISPLAY BY NAME g_imaa.imaa907
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i150_chk_imaa908(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_factor LIKE img_file.img21
   IF cl_null(g_imaa.imaa908) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
    WHERE gfe01=g_imaa.imaa908
      AND gfeacti IN ('Y','y')
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa908,"","mfg0019","","",1)
      LET g_imaa.imaa908 = g_imaa_o.imaa908
      DISPLAY BY NAME g_imaa.imaa908
      RETURN FALSE
   END IF
   IF cl_null(g_imaa.imaa01) THEN
      RETURN TRUE
   END IF
  #MOD-B30173---add---start---
   IF cl_null(g_imaa.imaa01) THEN
      RETURN TRUE
   END IF
  #MOD-B30173---add---end---
   #計價單位時,計價單位必須和imaa25有轉換率
   CALL s_du_umfchk(g_imaa.imaa01,'','','',g_imaa.imaa25,
                    g_imaa.imaa908,'2')
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_imaa.imaa01,g_errno,0)
      RETURN FALSE
   END IF
   IF g_imaa908 <> g_imaa.imaa908 AND g_imaa908 IS NOT NULL AND p_cmd = 'u' THEN
      IF NOT cl_confirm('aim-999') THEN
         LET g_imaa.imaa908=g_imaa908
         DISPLAY BY NAME g_imaa.imaa908
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i150_chk_rel_imaa06(p_cmd)
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF NOT i150_chk_imaa09() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa10() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa11() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa12() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa23() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa25() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa31() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa35() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa39() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa43() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa44() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa54() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa55() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa571() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa63() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa67() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa86() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa87() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa872() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa874() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa109() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa131() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa132() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa133(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa134() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa136() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa137() THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa907(p_cmd) THEN
      RETURN FALSE
   END IF
   IF NOT i150_chk_imaa908(p_cmd) THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i150_ef()
 
   CALL i150_y_chk()
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
 
   IF aws_efcli2(base.TypeInfo.create(g_imaa),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_imaa.imaa1010 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
       DISPLAY BY NAME g_imaa.imaa1010
   ELSE
       LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION i150_show_pic()
     IF g_imaa.imaa1010 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_imaa.imaaacti)
# Memo        	: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION
 
FUNCTION i150_y_chk()
   DEFINE l_imaa01     LIKE imaa_file.imaa01
   DEFINE l_tqo01      LIKE tqo_file.tqo01 
   DEFINE l_tqk01      LIKE tqk_file.tqk01
   DEFINE l_n          LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE p_cmd        LIKE type_file.chr1    #FUN-950083  
   LET g_success = 'Y'
 
   IF (g_imaa.imaano IS NULL) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN 
   END IF
   IF g_imaa.imaaacti='N' THEN 
       #本筆資料無效
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_imaa.imaa1010='1' THEN
       #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_imaa.imaa1010='2' THEN
       #已拋轉，不可再異動!
       CALL cl_err(g_imaa.imaano,'axm-225',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF NOT i150_chk_rel_imaa06(p_cmd) THEN                                                                                           
      #相關欄位控管                                                                                                                 
     #CALL cl_err('',-1106,1)   #TQC-B60117 Mark                                                                                                    
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
END FUNCTION
 
FUNCTION i150_y_upd()
DEFINE l_gew03   LIKE gew_file.gew03   #CHI-A80023 add
DEFINE l_gev04   LIKE gev_file.gev04   #CHI-A80023 add
DEFINE l_imaa94  LIKE imaa_file.imaa94 #FUN-C40011
DEFINE l_str     STRING                   #FUN-C60061
DEFINE l_ima01   LIKE ima_file.ima01      #FUN-C60061
   
   LET g_success = 'Y'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640184 
   THEN 
      IF g_imaa.imaa92='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_imaa.imaa1010 != '1' THEN
            #此狀況碼不為「1.已核准」，不可確認!!
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能
   END IF
 
  BEGIN WORK
  OPEN aimi150_cl USING g_imaa.imaano                                            
  IF STATUS THEN                                                               
      CALL cl_err("OPEN aimi150_cl:", STATUS, 1)                                  
      CLOSE aimi150_cl                                                            
      ROLLBACK WORK                                                            
      RETURN                                                                   
  END IF                                                                       
  FETCH aimi150_cl INTO g_imaa.*                                                
  IF SQLCA.sqlcode THEN                                                        
     CALL cl_err('',SQLCA.sqlcode,1)                                           
     RETURN                                                                    
  END IF                                     
  CALL aimi150_show()
  LET g_chr = g_imaa.imaa1010
  UPDATE imaa_file 
     SET imaa1010='1' #1:已核准
   WHERE imaano = g_imaa.imaano
  IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_imaa.imaa1010=g_chr                                              
      DISPLAY BY NAME g_imaa.imaa1010
  END IF    
  #FUN-C40011---begin
  IF s_industry('icd') THEN
     IF cl_null(g_imaa.imaa94) THEN
        SELECT MAX(icu02) INTO l_imaa94
          FROM icu_file
         WHERE icu01 = g_imaa.imaaicd01
        UPDATE imaa_file
           SET imaa94 = l_imaa94
           WHERE imaano = g_imaa.imaano
        IF SQLCA.SQLERRD[3]=0 THEN                                                 
           CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)
        END IF 
     END IF 
  END IF 
  #FUN-C40011---end  
  CLOSE aimi150_cl      
  COMMIT WORK
   SELECT * INTO g_imaa.* FROM imaa_file
    WHERE imaano = g_imaa.imaano
  CALL aimi150_show()
   IF g_success = 'Y' THEN
      IF g_imaa.imaa92 = 'Y' THEN  #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_imaa.imaa1010='1'          #執行成功, 狀態值顯示為 '1' 已核准
         COMMIT WORK
         CALL cl_flow_notify(g_imaa.imaano,'Y')
         DISPLAY BY NAME g_imaa.imaa1010
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
   CALL i150_show_pic() #圖示

   IF NOT s_industry('icd') THEN  #TQC-C60006
      #CHI-A80023 add --start--
      SELECT gev04 INTO l_gev04 FROM gev_file
       WHERE gev01 = '1' and gev02 = g_plant
    # SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file   #FUN-950057
      SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file #FUN-950057 
       WHERE gew01 = l_gev04
         AND gew02 = '1'
      IF l_gew03 = '1' THEN
         IF cl_null(g_imaa.imaa01) THEN
            CALL cl_err(g_imaa.imaano,'aim-160','1')
         ELSE
            CALL i150_dbs(g_imaa.*)
            #FUN-C60061---begin
            LET l_str = NULL
            DECLARE ima01_c2 CURSOR FOR SELECT imaicd00
                                          FROM imaicd_file
                                         WHERE imaicd11 = g_imaa.imaano
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
            SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
            CALL aimi150_show()  
         END IF
      END IF
      #CHI-A80023 add --end--
    END IF  #TQC-C60006
END FUNCTION
 
FUNCTION i150_z()
   DEFINE l_imaa01 LIKE imaa_file.imaa01
    
   IF (g_imaa.imaano IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_imaa.imaaacti='N' THEN 
      #本筆資料無效
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_imaa.imaa1010 = 'S' THEN
      #送簽中, 不可修改資料!
      CALL cl_err(g_imaa.imaano,'apm-030',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_imaa.imaa1010 !='1' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF
   
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #是否確定執行取消確認(Y/N)?
   BEGIN WORK
 
   OPEN aimi150_cl USING g_imaa.imaano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN aimi150_cl:", STATUS, 1)                                  
       CLOSE aimi150_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH aimi150_cl INTO g_imaa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL aimi150_show()
   LET g_chr=g_imaa.imaa1010
   UPDATE imaa_file 
      SET imaa1010='0' #0:開立
    WHERE imaano = g_imaa.imaano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
       CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       LET g_imaa.imaa1010=g_chr                                              
       DISPLAY BY NAME g_imaa.imaa1010
   END IF                                                                     
   CLOSE aimi150_cl     
   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
   COMMIT WORK
   CALL aimi150_show()
END FUNCTION
 
#No.FUN-7C0010  remove i150_dbs()等作業至s_aimi100_carry.4gl
#No.FUN-9C0072 精簡程式碼
#當料件特性='5',帶入相關預設值
#FUN-B30043--add--begin
#輸入料件特性後,做欄位控管
#FUN-C30278---begin
#FUN-B50106 -------------------------------Begin-----------------------------------
##FUNCTION i150_ind_icd_chg_imaaicd05(p_imaaicd05)
#   DEFINE p_imaaicd05 LIKE imaa_file.imaaicd05 #料件特性:1.母體料號(BODY) 2.預測料號(外編母體) 3.光罩 4.外編子體 5.生產性料號 6.原物料
#   CALL cl_set_comp_entry("imaaicd01,imaaicd02,imaaicd03",TRUE)
#FUN-B50106 --------------------Begin------------------------------
#   IF g_input_itemno = 'Y' THEN   
#      CALL cl_set_comp_entry("imaaicd01,imaaicd02,imaaicd03",FALSE)
#   END IF                        
##FUN-B50106 --------------------End--------------------------------
#   CASE p_imaaicd05
#      WHEN "1"
#         LET g_imaa.imaaicd01 = g_imaa.imaa01
#         DISPLAY BY NAME g_imaa.imaaicd01
#         CALL cl_set_comp_entry("imaaicd01",FALSE)
#      WHEN "2"
#         LET g_imaa.imaaicd02 = g_imaa.imaa01
#         DISPLAY BY NAME g_imaa.imaaicd02
#         CALL cl_set_comp_entry("imaaicd02",FALSE)
#      WHEN "4"
#         LET g_imaa.imaaicd03=g_imaa.imaa01
#         DISPLAY BY NAME g_imaa.imaaicd03
#         CALL cl_set_comp_entry("imaaicd03",FALSE)
#   END CASE
#END FUNCTION    

FUNCTION i150_ind_icd_chg_imaaicd04(p_imaaicd04)
   DEFINE p_imaaicd04 LIKE imaa_file.imaaicd04
   CALL cl_set_comp_entry("imaaicd01,imaaicd02,imaaicd03",TRUE)
   IF g_input_itemno = 'Y' THEN   
      CALL cl_set_comp_entry("imaaicd01,imaaicd02,imaaicd03",FALSE)
      #TQC-C60004---begin
      IF s_industry('icd') THEN 
         IF g_imaa.imaaicd04 = '0' THEN
            LET g_imaa.imaaicd01 = g_imaa.imaa01
            CALL cl_set_comp_entry("imaaicd01",FALSE)
         ELSE
            CALL cl_set_comp_entry("imaaicd01",TRUE)
         END IF 
      END IF 
      #TQC-C60004---end
   END IF                        
   IF p_imaaicd04 = '0' THEN
      LET g_imaa.imaaicd01=g_imaa.imaa01
      DISPLAY BY NAME g_imaa.imaaicd01
      CALL cl_set_comp_entry("imaaicd01",FALSE)
   END IF 
END FUNCTION  
#FUN-C30278---end
#當料件特性='5',帶入相關預設值
 
FUNCTION i150_ind_icd_set_default(p_imaaicd05,p_imaaicd01) 
   DEFINE p_imaaicd05     LIKE imaa_file.imaaicd05
   DEFINE p_imaaicd01     LIKE imaa_file.imaaicd01
   DEFINE l_imaaicd02     LIKE imaa_file.imaaicd02
   DEFINE l_imaaicd03     LIKE imaa_file.imaaicd03
   DEFINE l_imaaicd04     LIKE imaa_file.imaaicd04
   DEFINE l_imaaicd06     LIKE imaa_file.imaaicd06
   DEFINE l_imaaicd10     LIKE imaa_file.imaaicd10
   IF cl_null(p_imaaicd01) OR cl_null(p_imaaicd05) THEN 
      RETURN
   END IF
   CASE p_imaaicd05
      WHEN "5"
         SELECT imaaicd02,imaaicd03,imaaicd04,imaaicd06,imaaicd10
           INTO l_imaaicd02,l_imaaicd03,l_imaaicd04,l_imaaicd06,l_imaaicd10
           FROM imaa_file
          WHERE imaa01=p_imaaicd01
         IF cl_null(g_imaa.imaaicd02) THEN
            LET g_imaa.imaaicd02 = l_imaaicd02
         END IF
         IF cl_null(g_imaa.imaaicd03) THEN
            LET g_imaa.imaaicd03 = l_imaaicd03
         END IF
         IF cl_null(g_imaa.imaaicd04) THEN
            LET g_imaa.imaaicd04 = l_imaaicd04
         END IF
         IF cl_null(g_imaa.imaaicd05) THEN
            LET g_imaa.imaaicd06 = l_imaaicd06
         END IF
         IF cl_null(g_imaa.imaaicd10) THEN
            LET g_imaa.imaaicd10 = l_imaaicd10
         END IF
         DISPLAY BY NAME g_imaa.imaaicd02,g_imaa.imaaicd03,
                         g_imaa.imaaicd04,g_imaa.imaaicd06,
                         g_imaa.imaaicd10
      WHEN "6" #6.原物料 沒有作業群組
         LET g_imaa.imaaicd10 = NULL       #FUN-980063
         DISPLAY BY NAME g_imaa.imaaicd10  #FUN-980063
      OTHERWISE
         IF cl_null(g_imaa.imaaicd10) THEN
            SELECT imaaicd10 INTO g_imaa.imaaicd10 FROM imaa_file
                                           WHERE imaa01=p_imaaicd01
            DISPLAY BY NAME g_imaa.imaaicd10
         END IF
   END CASE
END FUNCTION 
FUNCTION i150_ind_icd_chk_item(p_feld,p_value)
   DEFINE p_feld  LIKE gaq_file.gaq01 #欄位名稱
   DEFINE p_value LIKE ima_file.ima01 #欄位值
   DEFINE l_imaaicd04 LIKE imaa_file.imaaicd04   #FUN-B50106 #料件狀態 : 0. BODY  1.未測WAFER  2.已測WAFER  3.未測IC  4.已測IC  9.OTHER
   DEFINE l_imaaicd05 LIKE imaa_file.imaaicd05   #FUN-B50106 #料件特性 : 1.母體料號(BODY) 2.預測料號(外編母體) 3.光罩 4.外編子體 5.生產性料號 6.原物料
   DEFINE l_imaaacti  LIKE imaa_file.imaaacti

   IF cl_null(p_value) THEN
      RETURN TRUE
   END IF
   #FUN-C30278---begin
   IF g_imaa.imaaicd04 = '0' AND p_value = g_imaa.imaa01 THEN
      RETURN TRUE
   END IF 
   #CASE g_imaa.imaaicd05    #FUN-B50106
   #   WHEN "1"
   #      IF p_feld='imaaicd01' AND p_value=g_imaa.imaa01 THEN   #FUN-B50106
   #         RETURN TRUE
   #      END IF
   #   WHEN "2"
   #      IF p_feld='imaaicd02' AND p_value=g_imaa.imaa01 THEN   #FUN-B50106  
   #         RETURN TRUE
   #      END IF
   #   WHEN "4"
   #      IF p_feld='imaaicd03' AND p_value=g_imaa.imaa01 THEN   #FUN-B50106 
   #         RETURN TRUE
   #      END IF
   #END CASE
   #FUN-C30278---end
   #FUN-C30206---baegin
   IF g_imaa.imaaicd04 = '1' AND p_value = g_imaa.imaa01 THEN 
      RETURN TRUE
   ELSE 
   #FUN-C30206---end
#FUN-B70051-add-str-- 
      SELECT imaicd04,imaicd05,imaacti
        INTO l_imaaicd04,l_imaaicd05,l_imaaacti
        FROM imaicd_file,ima_file
       WHERE ima01 = imaicd00 AND imaicd00 = p_value
      IF SQLCA.sqlcode = 100 THEN 
#FUN-B70051-add-str--
         SELECT imaaicd04,imaaicd05,imaaacti
           INTO l_imaaicd04,l_imaaicd05,l_imaaacti
           FROM imaa_file
          WHERE imaa01 = p_value
      END IF                #FUN-B70051
      CASE
         WHEN SQLCA.sqlcode<>0
            CALL cl_err3("sel","imaa_file",p_value,"",100,"","",1) 
         WHEN cl_null(l_imaaacti) OR l_imaaacti<>'Y'
            CALL cl_err3("sel","imaa_file",p_value,"","apm-800","","",1)
         WHEN cl_null(l_imaaicd04) OR cl_null(l_imaaicd05)  #FUN-B50106
            CALL cl_err(p_value,"aic-047",1)
         #WHEN l_imaaicd05 = '6'   #FUN-B50106  #FUN-C30278
         #WHEN l_imaaicd04 = '0' OR l_imaaicd04 = '1'  #FUN-C30278  
         #   CALL cl_err(p_value,"aic-105",1)  #FUN-C30278 
         WHEN l_imaaicd04 = '9'   #FUN-B50106
            CALL cl_err(p_value,"aic-106",1)
         #WHEN (p_feld="imaaicd01") AND (l_imaaicd05<>"1")  #母體料號    #FUN-B50106
         WHEN (p_feld="imaaicd01") AND (l_imaaicd04<>"0" AND l_imaaicd04<>"1")  #母體料號     #FUN-C30278
            CALL cl_err(p_value,"aic-100",1)
         WHEN (p_feld="imaaicd02") AND (l_imaaicd05<>"2")  #外編母體 (預測料號)   #FUN-B50106
            CALL cl_err(p_value,"aic-101",1)
         WHEN (p_feld="imaaicd03") AND (l_imaaicd05<>"4")  #外編子體 (客戶下單料號) #FUN-B50106
            CALL cl_err(p_value,"aic-102",1)
         WHEN (p_feld="imaaicd06") AND (NOT l_imaaicd04 MATCHES '[12]')  #內編子體 (Wafer料號)   #FUN-B50106
            CALL cl_err(p_value,"aic-103",1)
         OTHERWISE
            RETURN TRUE
      END CASE
   END IF #FUN-C30206
   RETURN FALSE
END FUNCTION
 
FUNCTION i150_ind_icd_chk_imaaicd10(p_imaaicd10)  #FUN-B50106 
  DEFINE p_imaaicd10 LIKE imaa_file.imaaicd10 #FUN-B50106
  DEFINE l_icd01    LIKE icd_file.icd01
  DEFINE l_icd02    LIKE icd_file.icd02
  DEFINE l_icdacti  LIKE icd_file.icdacti
 
  IF cl_null(p_imaaicd10) THEN   #FUN-B50106
     RETURN TRUE
  END IF
  SELECT icd01,icd02,icdacti
    INTO l_icd01,l_icd02,l_icdacti
    FROM icd_file
   WHERE icd01=p_imaaicd10   #FUN-B50106
     AND icd02='U'        #No.TQC-910034 add
  CASE
     WHEN SQLCA.sqlcode<>0
        CALL cl_err3("sel","icd_file",p_imaaicd10,"",100,"","",1)   #FUN-B50106
     WHEN cl_null(l_icdacti) OR l_icdacti<>'Y'
        CALL cl_err3("sel","icd_file",p_imaaicd10,"","apm-800","","",1) #FUN-B50106
     WHEN cl_null(l_icd02) OR l_icd02<>'U'
        CALL cl_err3("sel","icd_file",p_imaaicd10,"","aic-317","","",1) #FUN-B50106 
     OTHERWISE
       RETURN TRUE
  END CASE
  RETURN FALSE
END FUNCTION
#FUN-B50106 -----------------------------End----------------------------
#FUN-B30043--add--end
#FUN-BB0083---add---str
FUNCTION i150_imaa27_check()
#imaa27 的單位 imaa25
   IF NOT cl_null(g_imaa.imaa25) AND NOT cl_null(g_imaa.imaa27) THEN
      IF cl_null(g_imaa_t.imaa27) OR cl_null(g_imaa25_t) OR g_imaa_t.imaa27 != g_imaa.imaa27 OR g_imaa25_t != g_imaa.imaa25 THEN 
         LET g_imaa.imaa27=s_digqty(g_imaa.imaa27, g_imaa.imaa25)
         DISPLAY BY NAME g_imaa.imaa27  
      END IF  
   END IF
   IF NOT cl_null(g_imaa.imaa27) THEN
      IF g_imaa.imaa27 < 0 THEN
         CALL cl_err('','aec-020',0)
         RETURN FALSE
      END IF 
   END IF  
RETURN TRUE
END FUNCTION

FUNCTION i150_imaa271_check()
#imaa271 的單位 imaa25
   IF NOT cl_null(g_imaa.imaa25) AND NOT cl_null(g_imaa.imaa271) THEN
      IF cl_null(g_imaa_t.imaa271) OR cl_null(g_imaa25_t) OR g_imaa_t.imaa271 != g_imaa.imaa271 OR g_imaa25_t != g_imaa.imaa25 THEN 
         LET g_imaa.imaa271=s_digqty(g_imaa.imaa271, g_imaa.imaa25)
         DISPLAY BY NAME g_imaa.imaa271  
      END IF  
   END IF
   IF NOT cl_null(g_imaa.imaa271) THEN
      IF g_imaa.imaa271 < 0 THEN
         CALL cl_err('','aec-020',0)
         RETURN FALSE 
      END IF
    END IF
RETURN TRUE
END FUNCTION


FUNCTION i150_imaa51_check()
#imaa51 的單位 imaa25
   IF NOT cl_null(g_imaa.imaa25) AND NOT cl_null(g_imaa.imaa51) THEN
      IF cl_null(g_imaa_t.imaa51) OR cl_null(g_imaa25_t) OR g_imaa_t.imaa51 != g_imaa.imaa51 OR g_imaa25_t != g_imaa.imaa25 THEN 
         LET g_imaa.imaa51=s_digqty(g_imaa.imaa51, g_imaa.imaa25)
         DISPLAY BY NAME g_imaa.imaa51  
      END IF  
   END IF
   IF NOT cl_null(g_imaa.imaa51) THEN
      IF g_imaa.imaa51 <= 0 THEN 
         CALL cl_err(g_imaa.imaa51,'mfg1322',0)
         LET g_imaa.imaa51 = g_imaa_o.imaa51
         DISPLAY BY NAME g_imaa.imaa51
         RETURN FALSE
      END IF
   ELSE 
      LET g_imaa.imaa51 = 1
      DISPLAY BY NAME g_imaa.imaa51
   END IF
   LET g_imaa_o.imaa51 = g_imaa.imaa51
RETURN TRUE
END FUNCTION
#FUN-BB0083---add---end

#CHI-CB0017 add begin---
FUNCTION i150_copy_refdoc()
   DEFINE l_gca01_o    LIKE gca_file.gca01
   DEFINE l_gca01_n    LIKE gca_file.gca01
   DEFINE l_filename   LIKE gca_file.gca07
   DEFINE l_gca        RECORD LIKE gca_file.*
   DEFINE l_gcb        RECORD LIKE gcb_file.*
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num5

   LET l_gca01_o = "ima01=",g_imaa.imaa01
   LET l_gca01_n = "imaano=",g_imaa.imaano
   LET l_sql = "SELECT * FROM gca_file WHERE gca01 = '",l_gca01_o,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE doc_pre1 FROM l_sql
   DECLARE doc_cur1 CURSOR WITH HOLD FOR doc_pre1
   FOREACH doc_cur1 INTO l_gca.*
      LET l_filename = s_get_docnum(l_gca.gca08)
      LET l_sql = " INSERT INTO gca_file",
                  "  (gca01 ,",
                  "   gca02 ,",
                  "   gca03 ,",
                  "   gca04 ,",
                  "   gca05 ,",
                  "   gca06 ,",
                  "   gca07 ,",
                  "   gca08 ,",
                  "   gca09 ,",
                  "   gca10 ,",
                  "   gca11 ,",
                  "   gca12 ,",
                  "   gca13 ,",
                  "   gca14 ,",
                  "   gca15 ,",
                  "   gca16 ,",
                  "   gca17 )",
                  " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                  "          ?,?,?,?,?,   ?,?       )"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE ins_doc FROM l_sql
      EXECUTE ins_doc USING l_gca01_n,
                            l_gca.gca02,
                            l_gca.gca03,
                            l_gca.gca04,
                            l_gca.gca05,
                            l_gca.gca06,
                            l_filename,
                            l_gca.gca08,
                            l_gca.gca09,
                            l_gca.gca10,
                            l_gca.gca11,
                            l_gca.gca12,
                            l_gca.gca13,
                            l_gca.gca14,
                            l_gca.gca15,
                            l_gca.gca16,
                            l_gca.gca17
      IF SQLCA.sqlcode THEN
          LET g_msg = 'INSERT ','gca_file'
          CALL cl_err(g_msg,'lib-028',1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF

      DISPLAY "Insert gca_file/Rows: ",l_gca01_n," / ",SQLCA.sqlerrd[3]   #Background Message
      DISPLAY "l_filename: ",l_filename   #Background Message

      LET l_sql = " SELECT * FROM gcb_file",
                  "   WHERE gcb01= '",l_gca.gca07,"' "
      PREPARE doc_pre2 FROM l_sql
      DECLARE doc_cur2 CURSOR WITH HOLD FOR doc_pre2
      LOCATE l_gcb.gcb09 IN MEMORY
      FOREACH doc_cur2 INTO l_gcb.*
          LET l_sql = " INSERT INTO gcb_file",
                      "   ( gcb01 ,",
                      "     gcb02 ,",
                      "     gcb03 ,",
                      "     gcb04 ,",
                      "     gcb05 ,",
                      "     gcb06 ,",
                      "     gcb07 ,",
                      "     gcb08 ,",
                      "     gcb09 ,",
                      "     gcb10 ,",
                      "     gcb11 ,",
                      "     gcb12 ,",
                      "     gcb13 ,",
                      "     gcb14 ,",
                      "     gcb15 ,",
                      "     gcb16 ,",
                      "     gcb17 ,",
                      "     gcb18 )",
                      " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                      "          ?,?,?,?,?,   ?,?,?     )"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE ins_doc2 FROM l_sql
         EXECUTE ins_doc2 USING l_filename,
                                l_gcb.gcb02,
                                l_gcb.gcb03,
                                l_gcb.gcb04,
                                l_gcb.gcb05,
                                l_gcb.gcb06,
                                l_gcb.gcb07,
                                l_gcb.gcb08,
                                l_gcb.gcb09,
                                l_gcb.gcb10,
                                l_gcb.gcb11,
                                l_gcb.gcb12,
                                l_gcb.gcb13,
                                l_gcb.gcb14,
                                l_gcb.gcb15,
                                l_gcb.gcb16,
                                l_gcb.gcb17,
                                l_gcb.gcb18
         IF SQLCA.sqlcode THEN
             LET g_msg = 'INSERT ','gcb_file'
             CALL cl_err(g_msg,'lib-028',1)
             LET g_success = 'N'
             EXIT FOREACH
         END IF
         DISPLAY "Insert gcb_file/Rows: ",l_filename," / ",SQLCA.sqlerrd[3]   #Background Message
         FREE l_gcb.gcb09
      END FOREACH
   END FOREACH
END FUNCTION
#CHI-CB0017 add end-----
