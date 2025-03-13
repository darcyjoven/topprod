# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp570.4gl
# Descriptions...: 請購轉入採購分配作業
# Date & Author..: 94/08/30 By Apple
# by kitty.......: 1.detail作完後,確認碼已變成'y'但未display 2.增加R.刪除功能
# modify 99/03/24: By Pets :NO.3061--分配量(pmn09)應扣除已轉採購量, >0時才可帶出
# modify 99/03/25: By Carol:NO.3062--1.取替代料件數量計算修正
#                                    2.p570_inspmn()
#                                      加select ima35,ima36 INTO pmn52,pmn54
# Modify.........: No:7714 03/08/06 By Mandy pmm44的預設值應為'1'
# Modify.........: No:8203 03/09/17 By Mandy 1.單身 及 轉出會檢查料件供應商 ... 可是變數下錯了 ...
# Modify.........: No:8360 03/10/01 By Melody 轉品名規格時應考慮 MISC料  
# Modify.........: No.8841 03/12/04 By Kitty pml12,pmn122 不可為null否則轉ap會有問題
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0327 04/10/27 By Mandy 單身加秀廠商簡稱
# Modify.........: No.MOD-4A0345 04/10/28 By Mandy 產出至apmt540所秀的訊息改到COMMIT WORK 後再show
# Modify.........: No.MOD-4A0356 04/11/02 By Nicola p_ze有C開頭的錯誤碼
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0091 04/11/12 By Mandy 刪除資料後,show的筆數有誤
# Modify.........: No.MOD-4B0294 04/11/29 By Smapmin 調整螢幕變數傳遞位置,料件編號與廠商編號開窗,修正SELECT條件
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530332 05/03/29 By Mandy 產生後,單身底稿未show出
# Modify.........: No.MOD-540149 05/04/22 By Mandy 畫面p570_choice_w單身的選擇,按了選擇或取消後畫面沒有立即show'Y'or 'N'
# Modify.........: No.MOD-540122 05/05/02 By Mandy pmm40 依幣別取位
# Modify.........: No.FUN-550089 05/05/17 By Danny 採購含稅單價
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-560014 05/06/08 By day  單據編號修改
# Modify.........: No.FUN-560063 05/06/14 By Elva 新增雙單位內容
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.MOD-580205 05/08/24 By Nicola 建議p570_pnn05置于g_sma.sma63='1'的判斷後面
# Modify.........: No.MOD-580166 05/08/24 By Nicola 產生分配底稿後,按[轉出],回到apmp570分配底稿畫面時,單身資料消失了
# Modify.........: No:BUG-580302 05/08/26 By Mandy 1.將MOD-580205的修正做復原,並將CALL p570_pnn05()後的NEXT FIELD pnn05 MARK掉
# Modify.........: No.MOD-580302 05/08/26 By Mandy 2.p570_pnn05()做相關修正
# Modify.........: No.MOD-590119 05/09/09 By Carrier 多單位set_origin_field修改
# Modify.........: No.MOD-580207 05/09/12 By Nicola 抓取pmh07的資料給pmn123
# Modify.........: No.MOD-5A0045 05/10/05 By Nicola '轉出'時,產生的採購單的'MRP可用'要='y'  '多角拋轉'要='n'
#                                                   '產生'時,採購和計價數量為null
# Modify.........: No.FUN-590130 05/10/13 By Rosayu 1.產生到單身資料時，若有多筆資料產生改成顯示在array一個畫面
# Modify.........: 2.轉出時若是多張採購單也是用一個畫面顯示多筆採購單即可
# Modify.........: No.MOD-590422 05/10/24 By Nicola 產生的action中，加入請購單項次選項
# Modify.........: No.TQC-5B0100 05/11/16 By Vivien 不使用多單位時，畫面中不可顯示‘單位一數量’
# Modify.........: No.MOD-5B0165 05/11/22 By Rosayu 取價未考慮asms250'採購單價是否為零'(sma112)控管
# Modify.........: No.MOD-5B0332 05/11/29 By Rosayu 產生時加卡請購確認碼
# Modify.........: No.MOD-5B0333 05/11/29 By Rosayu 1.替代率換算2.更新已轉採購數量問題單位一跟計價單位無內容
# Modify.........: No.MOD-5C0101 05/12/20 By Nicola 轉出員工及部門控管
# Modify.........: No.FUN-610018 06/01/06 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610067 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-620037 06/02/20 By pengu 刪除單身的BEFORE DELETE段刪除時，少pnn06的判斷  
# Modify.........: No.FUN-630006 06/03/06 By Nicola 預設pmm909="2"
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-630040 06/03/23 By Nicola 若單身項次為統購料,則不可拋採購單
# Modify.........: No.FUN-5C0074 06/03/28 By yoyo 單身稅別先取供應商基本檔的慣用稅別,再取請購單稅別
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640058 06/04/08 By Nicola 清除訊息
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.MOD-640515 06/04/20 By Claire pmn31 比照sapmt540做檢查 
# Modify.........: No.TQC-650108 06/05/24 By cl 增加料件多屬性
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.MOD-660090 06/06/22 By Rayven 料件多屬性補充修改，check_料號()內應再加傳p_cmd的參數
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670089 06/07/20 By Claire pmn88,pmn88t比照sapmt540計算方式
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690047 06/09/28 By Sarah pmm45,pmn38需抓請購單的pmk45,pml38寫入
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6A0072 06/11/15 By pengu 未依ima15 default pmn64 (保稅否)
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modfiy.........: No.CHI-690043 06/11/22 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modify.........: No.FUN-620055 06/11/29 By rainy "apm-911" 如果sma32 = Y時,應該要看此料件是ABC那一類,SUM(pnn09)應該要和 (pml20-pml21)*各類的差異比百
# Modify.........: No.TQC-6B0173 06/12/01 By ray 拋轉到采購單上的金額應該是計價數量*單價,而不是采購數量*單價
# Modify.........: No.MOD-6C0017 06/12/06 By claire 應取代1傳入pnn09
# Modify.........: No.MOD-690047 06/12/08 By pengu 轉出採購後在UPDATE請購單身的"已轉採購量"異常
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.FUN-710030 07/01/22 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-710136 07/01/31 By Smapmin 自行決定供應商一定要輸入供應商代號
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730046 07/03/14 By claire 計算pmm40,pmm40t直接sum(pmn88) sum(pmn88t)
# Modify.........: No.TQC-730022 07/03/22 By rainy 新增傳參數
# Modify.........: No.MOD-750068 07/05/15 By claire 需考慮MISC區不做料件供應商管制
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760110 07/05/15 By claire g_success='Y' 才顯示整批產出訊息
# Modify.........: No.FUN-770056 07/07/16 By kim 配合MSV版所需做的調整
# Modify.........: No.FUN-710060 07/08/08 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-780097 07/08/17 By claire 不做料件供應商管制時, 不應控卡料件供應商未建檔
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.CHI-770033 07/09/17 By claire 將請購備註(pmo_file)寫入採購備註
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.MOD-7A0176 07/10/30 By Carol 依主要供應商自動產生時,有輸入供應商的料號應產生資料 
# Modify.........: No.MOD-780236 07/10/30 By pengu 參數不使用計價單位且分配條件選擇2"依料件廠商分配率"
#                                                  則產生至採購單上的計價單位會異常
# Modify.........: No.MOD-7B0112 07/11/14 By Pengu 調整g_pmn array的欄位順序
# Modify.........: No.TQC-7C0168 07/12/26 By xufeng 1.在生成按鈕打開的對話框里，依次輸入請購單號，采購人員，依采購員生成幾個欄位后，若直接點確定，系統會提示供應商欄位是必輸的；
#                                                   若走過廠商分配條件后再確定，不會提示供應商欄位必輸。 
#                                                   2.在生成按鈕打開的對話框里，廠商分配條件選擇2或3，在后續生成的過程中若某一筆請購單單身的料在料件供應商資料檔里面抓不到，
#                                                   會導致運行結果為資料異動更新不成功。不會生成任何資料，也沒有任何關于單身的報錯提示信息。 
# Modify.........: No.TQC-7C0176 07/12/29 By wujie  轉出功能時，點否退出會死循環
# Modify.........: No.FUN-810017 08/01/29 By jan    新增服飾作業
# Modify.........: No.FUN-7B0018 08/02/01 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810045 08/02/13 By rainy  項目管理，將項目相關欄位帶入採購單
# Modify.........: No.CHI-820014 08/03/14 By claire 單價超限率(sma84)的設定應以原始取出單價與目前交易單價比較
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pml66,pmn66,pmm06,pmk06
# Modify.........: No.CHI-840007 08/04/09 By Dido 給予pmn40會計科目預設值
# Modify.........: No.CHI-840078 08/04/30 By cliare 有勾選自動確認且有勾選應簽核,不可執行確認
# Modify.........: No.MOD-870176 08/07/14 By Smapmin修改傳入s_defprice()的參數 
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-880131 08/08/18 By Smapmin 改寫CHI-770033寫入備註的方式
# Modify.........: No.MOD-880211 08/08/26 By Smapmin 調整條件式判斷
# Modify.........: No.MOD-880151 08/09/01 By Smapmin 請/採數量勾稽應以資料庫存在的資料做比較,而非只有畫面上的資料做比較
#                                                    單身自行輸入時,pnn17/pnn36應該要給值
# Modify.........: No.MOD-890163 08/09/17 By Smapmin 修改完分配量後,計價數量並未更新
# Modify.........: No.FUN-870124 08/09/01 By jan 服飾作業功能完善
# Modify.........: No.CHI-890026 08/10/06 By Smapmin 依照稅別含稅否重新計算含稅/未稅金額
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-8A0136 FUN-8A0129 08/10/30 By arman  
# Modify.........: No.FUN-8A0142 FUN-8A0129 08/10/30 By arman  
# Modify.........: No.MOD-8B0155 08/11/14 By Pengu 合併產生採購單時特別說明資料會異常
# Modify.........: No.MOD-8B0273 08/11/27 By chenyu 采購單單頭單價含稅時，單身未稅單價=未稅金額/數量
# Modify.........: No.CHI-8C0008 08/12/04 By Smapmin 將pnn16隱藏起來
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-920046 09/02/12 By Smapmin 分配條件選擇1.依料件主要供應商, 
#                                                    產生到底稿時,幣別抓取供應商慣用幣別
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-930224 09/04/03 By Smapmin 程式原先只有於輸入供應商編號時控管,產生底稿時未過濾pmcacti,故針對產生底稿時過濾pmcacti.
# Modify.........: No.MOD-940072 09/04/14 By Smapmin 分批拋轉採購單,第二次拋轉時計價數量有誤
# Modify.........: No.MOD-940133 09/04/14 By Smapmin 請/採數量勾稽時,改以庫存單位為基礎來做比較
# Modify.........: No.MOD-940058 09/04/14 By Smapmin 單頭的特別說明未產生至採購單
# Modify.........: No.TQC-940174 09/04/28 By Carrier 按"廠商分配比率"方式產生單身時,單價default錯誤
# Modify.........: No.MOD-940366 09/04/28 By lutingting產生采購單時,采購版本號應default為0
# Modify.........: No.FUN-940083 09/05/06 By zhaijie新增VIM管理否欄位判斷
# Modify.........: No.MOD-970191 09/07/24 By Smapmin 增加sma112的控卡點
# Modify.........: No.MOD-950222 09/07/28 By sherry 計價數量沒有產生  
# Modify.........: No.MOD-970249 09/07/29 By Dido 調整 icd 行業別判斷
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990254 09/09/29 By Smapmin 採購相關日期依請購單到廠日期是否相符為依據
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.FUN-9A0068 09/10/29 By destiny 修正VMI管理否的抓值设定
# Modify.........: No.FUN-9A0065 09/11/03 By baofei 請購單轉採購時，需排除"電子採購否(pml92)"='Y'的資料	
# Modify.........: No.FUN-9B0016 09/11/06 By Sunyanchun post no
# Modify.........: No.MOD-9B0041 09/11/06 By lilingyu 點擊"重新整理"按鈕時,如果有多人操作時,程序會死掉
# Modify.........: No:FUN-9B0085 09/11/23 By Smapmin 訊息匯整資料多顯示單號/項次/料號
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:MOD-9B0162 09/12/02 By lilingyu 在單身點擊分配量進行修改后會引出錯誤提示"料件主檔無此編號"
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9B0169 09/12/04 By Smapmin 增加ima152的控管.以及解決Blanket PO已轉量沒有回寫的問題
# Modify.........: No:MOD-9C0285 09/12/21 By Cockroach 檢查價格以決定欄位是否可以錄入
# Modify.........: No:MOD-A10046 10/01/08 By Smapmin 確認人來源default請購單上的
# Modify.........: No.FUN-A10034 10/01/09 By chenmoyan 排除"電子採購否(pml92)"='Y'的資料
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A10164 10/01/27 By Smapmin 預設超短交率
# Modify.........: No:MOD-A10185 10/02/01 By Smapmin 單價為null或是0時才重新取價
# Modify.........: No.TQC-960336 10/03/04 By vealxu 修改選取oay22的條件
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A70004 10/07/02 By yinhy pmn012為NULL給一空格
# Modify.........: No.FUN-A80001 10/08/02 By destiny 增加截止日期判断逻辑
# Modify.........: No:CHI-A70049 10/07/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-A80150 10/09/13 By sabrina GP5.2號機管理
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0025 10/11/24 By chenying 修改Sybase問題
# Modify.........: No.TQC-AB0041 10/12/20 By lixh1    將部份SQL改為通用SQL
# Modify.........: No:TQC-AC0224 10/12/20 By suncx 採購類型為自訂貨才能由程序轉採購單
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.MOD-AC0402 10/12/30 By chenying 還原TQC-AB0025的修改
# Modify.........: No.TQC-B10028 11/01/06 By destiny 单身下条件后依然会将所有资料查询出来
# Modify.........: No.TQC-B10036 11/01/07 By zhangll 修改特定条件下单身价格修改不了的情况
# Modify.........: No:CHI-B10018 11/01/10 By Smapmin 從pmh_file預設廠商料號
# Modify.........: No:MOD-B10092 11/01/13 By Summer 未考慮請轉採分配走核價時，往後打採購日期，導致取價錯誤 
# Modify.........: No:MOD-B30076 11/03/10 By Summer 單身顯示的品名要與請購單相同 
# Modify.........: No:MOD-B30399 11/03/14 By Summer mfg3528的控管移至AFTER FIELD 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B40143 11/04/19 By Summer 產生到採購單上的稅別,應與apmp570單身的pmc47一致
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-B60077 11/06/23 By JoHung AFTER FIELD 分配量 及 AFTER INPUT時，呼叫s_sizechk
# Modify.........: No:FUN-B70015 11/07/07 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No:FUN-B70121 11/07/28 By zhangll 增加pnz07判斷，決定取到了單價是否可以修改
# Modify.........: No:TQC-B70212 11/07/29 By zhangll 抓取gec資料時缺少關鍵字索引
# Modify.........: No:TQC-B80055 11/08/04 By zhangll 價格條件抓取方式調整
# Modify.........: No:CHI-B80006 11/08/04 By johung 查詢結果排除已結案或未轉採購量為0
# Modify.........: No:FUN-BB0084 11/11/23 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/11/25 By xianghui 增加數量欄位小數取位
# MOdify.........: No.FUN-910088 11/11/28 By chenjing 增加數量欄位小數取位
# Modify.........: No:TQC-BC0112 12/01/20 By SunLM MARK MOD-B10092所修改內容,系統不再用sma841判斷
# Modify.........: No:TQC-BC0132 12/01/20 By SunLM 廠牌資料以請購單為主
# Modify.........: No:TQC-BC0133 12/01/20 By SunLM 修改替代料號開窗
# Modify.........: No:TQC-BC0134 12/01/20 By SunLM 修改替代料號開窗,生效日期判定
# Modify.........: No:FUN-C10002 12/02/01 By bart 作業編號pmn78帶預設值
# Modify.........: NO:FUN-C20008 12/02/09 By madey 增加依據資料歸屬設定update資料所有人及資料所屬部門
# Modify.........: No:TQC-BC0089 12/02/10 By destiny 厂商分配条件为4时供应商栏位才能输入
# Modify.........: No:MOD-C10135 12/02/13 By jt_chen 請轉採的底稿上沒有可以維護付款條件的地方,故寫入採購單時,應抓採購單上的供應商的付款條件
# Modify.........: No:MOD-C10099 12/02/24 By Vampire 增加寫入"收貨部門"、"運送方式"
# Modify.........: No:TQC-C10118 12/02/27 By SunLM 只有核准的供應商料件才能替代
# Modify.........: No:MOD-BB0252 12/02/29 By Summer FOREACH choice_cs INTO l_tmp[g_cnt].* 欄位數不對
# Modify.........: No:FUN-C30055 12/03/12 By huangrh 支持服飾流通請購轉入採購
# Modify.........: No:MOD-C30879 12/03/28 By SunLM pnn05開窗時分條件,若ima915=2 or3,維持原樣,否則開窗不限定在pmh_file內必須存在
# Modify.........: No:TQC-C40235 12/04/24 By zhuhao 轉出時，p570_inspmn()中料件的取價類型默認為空值，應改為如果取價類型為空，則給默認值4.其它
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3525->axm-627
# Modify.........: No:MOD-C30797 12/06/11 By Vampire CALL q_pom2,增加傳參數判斷稅別
# Modify.........: No:TQC-C60137 12/06/15 By zhuhao 程序過單
# Modify.........: No:FUN-C60093 12/06/25 By huangrh 服飾流通：轉出多筆採購單身時，採購單沒有單身數據。
# Modify.........: No:MOD-C70182 12/07/17 By Elise 將l_sql型態改為STRING
# Modify.........: No:TQC-C70166 12/07/24 By zhuhao 整批處理時採購單號開窗
# Modify.........: No:TQC-C70202 12/07/27 By zhuhao mfg3528的控管前需判斷狀態是否修改欄位值
# Modify.........: No:MOD-C70231 12/08/15 By Vampire 調整AFTER INPUT更新建議數量的地方,增加更新計價數量
# Modify.........: No:MOD-C90068 12/09/18 By SunLM 將未核價的錯誤信息全部show出來
# Modify.........: No:TQC-C90091 12/09/21 By dongsz 增加pml01、ima43兩個欄位的開窗
# Modify.........: No:MOD-D10042 13/01/28 By Elise 單身幣別欄位輸入後，應判斷輸入內容是否存在於幣別檔(azi_file)
# Modify.........: No:CHI-B80097 13/03/13 By Elise [整批產生]之"請購單號"及[轉出]之QBE所有欄位建議增加可開窗查詢(複選)
# Modify.........: No:CHI-C10037 13/03/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
# Modify.........: No:CHI-CC0033 13/03/27 By jt_chen 兩角修改
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 請購單轉採購時，請購單備註pml06帶入採購單備註pmn100
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_argv1         STRING,    #TQC-730022
    g_argv2         STRING,    #TQC-730022
    g_pml           RECORD LIKE pml_file.*,
    g_pml_t         RECORD LIKE pml_file.*,
    g_pnn2          RECORD LIKE pnn_file.*,
    g_pnn01         LIKE pnn_file.pnn01,
    g_pnn02         LIKE pnn_file.pnn02,
    g_pnn17         LIKE pnn_file.pnn17,
    g_pnn20         LIKE pnn_file.pnn20,
    g_pnn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pnn13       LIKE pnn_file.pnn13,   #廠商編號
        pnn03       LIKE pnn_file.pnn03,   #料件編號
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx01,   #No.FUN-680136 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,   #No.FUN-680136 VARCHAR(10)
                    att02     LIKE imx_file.imx02,   #No.FUN-680136 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,   #No.FUN-680136 VARCHAR(10)
                    att03     LIKE imx_file.imx03,   #No.FUN-680136 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,   #No.FUN-680136 VARCHAR(10)
                    att04     LIKE imx_file.imx04,   #No.FUN-680136 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,   #No.FUN-680136 VARCHAR(10)
                    att05     LIKE imx_file.imx05,   #No.FUN-680136 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,   #No.FUN-680136 VARCHAR(10)
                    att06     LIKE imx_file.imx06,   #No.FUN-680136 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,   #No.FUN-680136 VARCHAR(10)
                    att07     LIKE imx_file.imx07,   #No.FUN-680136 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,   #No.FUN-680136 VARCHAR(10)
                    att08     LIKE imx_file.imx08,   #No.FUN-680136 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,   #No.FUN-680136 VARCHAR(10)
                    att09     LIKE imx_file.imx09,   #No.FUN-680136 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,   #No.FUN-680136 VARCHAR(10)
                    att10     LIKE imx_file.imx10,   #No.FUN-680136 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,   #No.FUN-680136 VARCHAR(10)
        ima02       LIKE ima_file.ima02,   #品名規格
        ima021_1    LIKE ima_file.ima021,  #規格
        pnn05       LIKE pnn_file.pnn05,   #廠商編號
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱 #MOD-4A0327
        pnn07       LIKE pnn_file.pnn07,   #分配率
        pnn08       LIKE pnn_file.pnn08,   #替代量
        pnn09       LIKE pnn_file.pnn09,   #原分配量
        pnn33       LIKE pnn_file.pnn33,
        pnn34       LIKE pnn_file.pnn34,
        pnn35       LIKE pnn_file.pnn35,
        pnn30       LIKE pnn_file.pnn30,
        pnn31       LIKE pnn_file.pnn31,
        pnn32       LIKE pnn_file.pnn32,
        pnn36       LIKE pnn_file.pnn36,
        pnn37       LIKE pnn_file.pnn37,
        pnn18       LIKE pnn_file.pnn18,   #Blanket P/O單號
        pnn19       LIKE pnn_file.pnn19,   #Blanket P/O項次
        pnn10       LIKE pnn_file.pnn10,   #採購單價
        pnn10t      LIKE pnn_file.pnn10t,  #含稅單價   No.FUN-550089
        pnn12       LIKE pnn_file.pnn12,   #採購單位
        pnn11       LIKE pnn_file.pnn11,   #交貨日期
        pnn919      LIKE pnn_file.pnn919,  #計畫批號   #FUN-A80150 add
        pnn06       LIKE pnn_file.pnn06,   #幣別  
        pmc47       LIKE pmc_file.pmc47,   #稅別       No.FUN-550089
        gec04       LIKE gec_file.gec04,   #稅率       No.FUN-550089
        pnn16       LIKE pnn_file.pnn16    #修正否    #No.MOD-7B0112 add
                    END RECORD,
    g_pnn_t         RECORD                 #程式變數 (舊值)
        pnn13       LIKE pnn_file.pnn13,   #廠商編號
        pnn03       LIKE pnn_file.pnn03,   #料件編號
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx01,   #No.FUN-680136 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,   #No.FUN-680136 VARCHAR(10)
                    att02     LIKE imx_file.imx02,   #No.FUN-680136 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,   #No.FUN-680136 VARCHAR(10)
                    att03     LIKE imx_file.imx03,   #No.FUN-680136 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,   #No.FUN-680136 VARCHAR(10)
                    att04     LIKE imx_file.imx04,   #No.FUN-680136 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,   #No.FUN-680136 VARCHAR(10)
                    att05     LIKE imx_file.imx05,   #No.FUN-680136 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,   #No.FUN-680136 VARCHAR(10)
                    att06     LIKE imx_file.imx06,   #No.FUN-680136 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,   #No.FUN-680136 VARCHAR(10)
                    att07     LIKE imx_file.imx07,   #No.FUN-680136 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,   #No.FUN-680136 VARCHAR(10)
                    att08     LIKE imx_file.imx08,   #No.FUN-680136 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,   #No.FUN-680136 VARCHAR(10)
                    att09     LIKE imx_file.imx09,   #No.FUN-680136 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,   #No.FUN-680136 VARCHAR(10)
                    att10     LIKE imx_file.imx10,   #No.FUN-680136 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,   #No.FUN-680136 VARCHAR(10)
        ima02       LIKE ima_file.ima02,   #品名規格
        ima021_1    LIKE ima_file.ima021,  #規格
        pnn05       LIKE pnn_file.pnn05,   #廠商編號
         pmc03       LIKE pmc_file.pmc03,   #廠商簡稱 #MOD-4A0327
        pnn07       LIKE pnn_file.pnn07,   #分配率
        pnn08       LIKE pnn_file.pnn08,   #替代量
        pnn09       LIKE pnn_file.pnn09,   #原分配量
        pnn33       LIKE pnn_file.pnn33,
        pnn34       LIKE pnn_file.pnn34,
        pnn35       LIKE pnn_file.pnn35,
        pnn30       LIKE pnn_file.pnn30,
        pnn31       LIKE pnn_file.pnn31,
        pnn32       LIKE pnn_file.pnn32,
        pnn36       LIKE pnn_file.pnn36,
        pnn37       LIKE pnn_file.pnn37,
        pnn18       LIKE pnn_file.pnn18,   #Blanket P/O單號
        pnn19       LIKE pnn_file.pnn19,   #Blanket P/O項次
        pnn10       LIKE pnn_file.pnn10,   #採購單價
        pnn10t      LIKE pnn_file.pnn10t,  #含稅單價   No.FUN-550089
        pnn12       LIKE pnn_file.pnn12,   #採購單位
        pnn11       LIKE pnn_file.pnn11,   #交貨日期
        pnn919      LIKE pnn_file.pnn919,  #計畫批號   #FUN-A80150 add
        pnn06       LIKE pnn_file.pnn06,   #幣別  
        pmc47       LIKE pmc_file.pmc47,   #稅別       No.FUN-550089
        gec04       LIKE gec_file.gec04,   #稅率       No.FUN-550089
        pnn16       LIKE pnn_file.pnn16    #修正否    #No.MOD-7B0112 add
                    END RECORD,
    tm  RECORD				   # Print condition RECORD
          wc        LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(300)   # Where Condition
          wc2       LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(300)   # Where Condition
          pmk02     LIKE pmk_file.pmk02,    
          desc      LIKE ze_file.ze03,     #No.FUN-680136 VARCHAR(10)
          purpeo    LIKE ima_file.ima43,       
          deldate   LIKE type_file.dat,    #No.FUN-680136 DATE                      
          a         LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01) 
          d         LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
          pmc01     LIKE pmc_file.pmc01,   #供應商編號 NO:6998
          pmc03     LIKE pmc_file.pmc03    #供應商簡稱
       END RECORD,
    tm3 RECORD				               # Print condition RECORD
          wc        LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(300)   # Where Condition
          type      LIKE type_file.chr3,   #No.FUN-680136 VARCHAR(03)
          slip      LIKE oay_file.oayslip, #No.FUN-680136 VARCHAR(05)    #No.FUN-550060
          purdate   LIKE type_file.dat,    #No.FUN-680136 DATE
          pmm12     LIKE pmm_file.pmm12,
          pmm13     LIKE pmm_file.pmm13 
       END RECORD,
       g_img09         LIKE img_file.img09,
       g_ima25         LIKE ima_file.ima25,
       g_ima31         LIKE ima_file.ima31,
       g_ima44         LIKE ima_file.ima44,
       g_ima906        LIKE ima_file.ima906,
       g_ima907        LIKE ima_file.ima907,
       g_ima908        LIKE ima_file.ima908,
       g_tot           LIKE img_file.img10,
       g_factor        LIKE pnn_file.pnn17,
       g_qty           LIKE img_file.img10,
       g_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       g_buf           LIKE gfe_file.gfe02,
       g_pnn38         LIKE pnn_file.pnn38,
       g_pnn38t        LIKE pnn_file.pnn38t,
       g_pom RECORD LIKE pom_file.*,
       g_pon RECORD LIKE pon_file.*,
       g_pnn03_sub      LIKE pnn_file.pnn03,
       g_pnn08_sub      LIKE pnn_file.pnn08,
       g_t1             LIKE oay_file.oayslip,  #No.FUN-550060  #No.FUN-680136 VARCHAR(5)
       g_t2             LIKE gem_file.gem01,    #No.FUN-680136 VARCHAR(6)
       g_exit           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
       g_cmd            LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
       g_pnn15          LIKE pnn_file.pnn15,
       g_bno,g_eno      LIKE pmk_file.pmk01,
       g_po,g_auno      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
       g_pmm    RECORD LIKE  pmm_file.*,
       g_pmn    RECORD LIKE  pmn_file.*,
       g_buf1          LIKE type_file.chr1000,      #TQC-650108  #No.FUN-680136 VARCHAR(30)
       g_buf2          LIKE type_file.chr1000,      #TQC-650108  #No.FUN-680136 VARCHAR(01)
       g_gec07         LIKE gec_file.gec07,   #No.FUN-550089                    
       g_wc,g_wc2,g_sql    string,        #No.FUN-550089  #No.FUN-580092 HCN
       g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
       g_char          LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
       g_wc_count,g_wc2_count    string #MOD-4B0091  #No.FUN-580092 HCN
DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD
         imx00         LIKE imx_file.imx00,
         imx           ARRAY[10] OF LIKE imx_file.imx01 
         END RECORD
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE   lg_smy62      LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的
DEFINE   lg_group      LIKE smy_file.smy62   #當前單身中采用的組別 
DEFINE   g_pmo DYNAMIC ARRAY OF RECORD
         pmo01      LIKE pmo_file.pmo01,
         pmo02      LIKE pmo_file.pmo02,
         pmo03      LIKE pmo_file.pmo03,
         pmo04      LIKE pmo_file.pmo04,
         pmo05      LIKE pmo_file.pmo05,
         pmo06      LIKE pmo_file.pmo06,
         pmoplant   LIKE pmo_file.pmoplant,  #FUN-980006 add
         pmolegal   LIKE pmo_file.pmolegal   #FUN-980006 add
         END RECORD,
         g_ac       LIKE type_file.num10
DEFINE   g_pnnislk01   LIKE pnni_file.pnnislk01  #No.FUN-810017
DEFINE   g_pmlislk01   LIKE pmli_file.pmlislk01  #No.FUN-870124
DEFINE   g_pmni RECORD LIKE pmni_file.*          #No.FUN-810017                                                                              
DEFINE   g_pnni RECORD LIKE pnni_file.*          #No.FUN-810017
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE   g_msg2          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100) #FUN-590130 add
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE  g_show_msg      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      pnn01       LIKE pnn_file.pnn01,   #廠商編號
      pnn02       LIKE pnn_file.pnn02,   #料件編號
      pnn05       LIKE pnn_file.pnn05    #廠商編號
                 END RECORD,
      g_i         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      g_gaq03_f1  LIKE gaq_file.gaq03,
      g_gaq03_f2  LIKE gaq_file.gaq03,
      g_gaq03_f3  LIKE gaq_file.gaq03
DEFINE g_term     LIKE pmk_file.pmk41   #No.FUN-930148
DEFINE g_price    LIKE pmk_file.pmk20   #No.FUN-930148
DEFINE g_chr      LIKE type_file.chr1   #MOD-9B0162 
DEFINE g_pnz08    LIKE pnz_file.pnz08    #FUN-C40089
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)       #參數-1(請購單號s) #TQC-730022
   LET g_argv2 = ARG_VAL(2)       #參數-2(g_wc) #TQC-730022
   LET g_bgjob = ARG_VAL(3)                          #TQC-730022
   LET g_prog = "apmp570_slk"    #No.FUN-810017                                                                                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
    DROP TABLE p570_tmp
    CREATE TEMP TABLE p570_tmp(
      choice    LIKE type_file.chr1,  
      supr      LIKE pmh_file.pmh02,
      curr      LIKE pmh_file.pmh13,
      price     LIKE pmh_file.pmh12,
      price_t   LIKE pmh_file.pmh12,
      rate      LIKE pmh_file.pmh11)
 
    DROP TABLE p570_tmp2
    CREATE TEMP TABLE p570_tmp2(
       pmm01  LIKE pmm_file.pmm01)                #No.FUN-550060
 
    OPEN WINDOW p570_w WITH FORM "apm/42f/apmp570"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    #初始化界面的樣式(沒有任何默認屬性組)                                                                                           
    LET lg_smy62 = ''                                                                                                               
    LET lg_group = ''                                                                                                               
    CALL p570_refresh_detail()
 
    CALL cl_set_comp_visible("pnn16",FALSE)   #CHI-8C0008
    CALL cl_set_comp_visible("pml919,pnn919",g_sma.sma1421='Y')   #FUN-A80150 add
    
    #FUN-C30055---add--begin--
    IF g_azw.azw04='2' THEN
       CALL cl_set_comp_visible("pmlislk01",FALSE)
    END IF 
    #FUN-C30055---add--end--
   
    CALL p570_def_form() 
    
    IF NOT cl_null(g_argv1) THEN 
       CALL p570_g()
       IF INT_FLAG THEN 
            LET INT_FLAG = 0 
       ELSE 
           CALL p570_q('g')
       END IF
    END IF  #TQC-730022 如有傳參數則直接開產生的畫面
 
    CALL p570_menu()
    CLOSE WINDOW p570_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION p570_cs(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    CLEAR FORM                                        #清除畫面
   CALL g_pnn.clear()
  IF p_cmd != 'g' THEN 
    IF NOT cl_null(g_argv1) THEN                     #TQC-730022
       LET g_wc = g_argv2 CLIPPED   #TQC-730022
       LET g_wc2 = " 1=1 "
    ELSE
         CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pnn01 TO NULL    #No.FUN-750051
   INITIALIZE g_pnn02 TO NULL    #No.FUN-750051
         CONSTRUCT g_wc ON pml01,pml02,pnn15 FROM pml01,pml02,ima43  
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
        #TQC-C90091 add str---
         ON ACTION controlp
            CASE
               WHEN INFIELD(pml01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_pmk02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pml01
                  NEXT FIELD pml01
               WHEN INFIELD(ima43)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima43
                  NEXT FIELD ima43
               OTHERWISE
                  EXIT CASE
            END CASE
        #TQC-C90091 add end---
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
         IF INT_FLAG THEN RETURN END IF
         CONSTRUCT g_wc2 ON pnn13,pnn03,pnn05,pnn07,pnn08,pnn09,pnn33,
                            pnn34,pnn35,pnn30,pnn31,pnn32,pnn36,pnn37,pnn18,
                             pnn19,pnn10,pnn10t,pnn12,pnn11,pnn919,pnn06,pnn16  #MOD-4B0294  調整螢幕變數傳遞位置  #FUN-A80150 add pnn919
                       FROM s_pnn[1].pnn13,s_pnn[1].pnn03,s_pnn[1].pnn05,
                            s_pnn[1].pnn07,s_pnn[1].pnn08,s_pnn[1].pnn09,
                            s_pnn[1].pnn33,s_pnn[1].pnn34,s_pnn[1].pnn35,
                            s_pnn[1].pnn30,s_pnn[1].pnn31,s_pnn[1].pnn32,
                            s_pnn[1].pnn36,s_pnn[1].pnn37,
                            s_pnn[1].pnn18,s_pnn[1].pnn19,s_pnn[1].pnn10,
                            s_pnn[1].pnn10t,                 #No.FUN-550089
                             s_pnn[1].pnn12,s_pnn[1].pnn11,s_pnn[1].pnn919,s_pnn[1].pnn06,          #MOD-4B0294  調整螢幕變數傳遞位置  #FUN-A80150 add pnn919
                            s_pnn[1].pnn16
             ON ACTION controlp
               CASE
                   WHEN INFIELD(pnn03) #料件編號    #MOD-4B0294 新增料件編號開窗
#FUN-AA0059---------mod------------str-----------------
                   
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form     = "q_pnn"
#                     LET g_qryparam.state    = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_pnn","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO pnn03
                     NEXT FIELD pnn03
                   WHEN INFIELD(pnn05) #廠商編號    #MOD-4B0294 新增廠商編號開窗
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_pnn2"
                     LET g_qryparam.state    = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pnn05
                     NEXT FIELD pnn05
                  WHEN INFIELD(pnn33)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gfe"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pnn33
                       NEXT FIELD pnn33
 
                  WHEN INFIELD(pnn30)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gfe"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pnn30
                       NEXT FIELD pnn30
 
                  WHEN INFIELD(pnn36)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gfe"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pnn36
                       NEXT FIELD pnn36
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
 
         
         END CONSTRUCT
         IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      END IF  #TQC-730022
  ELSE LET g_wc2 = "1=1"
  END IF
      LET g_sql = "SELECT UNIQUE pnn01,pnn02 ",
                  "  FROM pnn_file,pml_file,pmk_file",
                  " WHERE pnn01 = pml01 AND ", 
                  "       pml01 = pmk01 AND ", 
                  "       pnn01 = pmk01 AND ",
                  "       pnn02 = pml02 AND ", 
                  "       pml16 NOT IN('6','7','8') AND   ",   #CHI-B80006 add
                  "       pml20 - pml21 > 0 AND ",             #CHI-B80006 add
                  g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1,2"
           IF g_wc.getindexof('pmli',1) > 0  THEN
            LET g_sql = "SELECT UNIQUE pnn01,pnn02 ",
                         "  FROM pnn_file, pml_file, pmk_file,pmli_file",
                         " WHERE pnn01 = pml01 AND ", 
                         "       pml01 = pmk01 AND ", 
                         "       pnn01 = pmk01 AND ",
                         "       pnn02 = pml02 AND ",
                         "       pml16 NOT IN('6','7','8') AND   ",   #CHI-B80006 add
                         "       pml20 - pml21 > 0 AND ",             #CHI-B80006 add
                         "       pmli01 = pml01 AND ",
                         "       pmli02 = pml02 AND ",
                         g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                         " ORDER BY 1,2"
           END IF             
 
      PREPARE p570_prepare FROM g_sql
      DECLARE p570_cs                         #SCROLL CURSOR
          SCROLL CURSOR WITH HOLD FOR p570_prepare
 
      LET g_sql="SELECT DISTINCT pml01,pml02 ",
                " FROM pnn_file,pml_file,pmk_file ",
                " WHERE pnn01=pml01 AND ",
                "       pmk01=pml01 AND ",
                "       pnn01=pmk01 AND ",
                "       pml16 NOT IN('6','7','8') AND   ",   #CHI-B80006 add
                "       pml20 - pml21 > 0 AND ",             #CHI-B80006 add
                "       pnn02=pml02 ",
                " AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED,
                " INTO TEMP x "
        IF g_wc.getindexof('pmli',1) > 0 THEN
         LET g_sql="SELECT DISTINCT pml01,pml02 ",
                   " FROM pnn_file,pml_file,pmk_file,pmli_file ",
                   " WHERE pnn01=pml01 AND ",
                   "       pmk01=pml01 AND ",
                   "       pnn01=pmk01 AND ",
                   "       pnn02=pml02 AND ",
                   "       pml16 NOT IN('6','7','8') AND   ",   #CHI-B80006 add
                   "       pml20 - pml21 > 0 AND ",             #CHI-B80006 add
                   "       pmli01=pml01 AND ",
                   "       pmli02=pml02  ",
                   " AND ",g_wc CLIPPED,
                   " AND ",g_wc2 CLIPPED,
                   " INTO TEMP x "
       END IF           
        DROP TABLE x
    PREPARE p570_precount_x FROM g_sql
    EXECUTE p570_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE p570_precount FROM g_sql
    DECLARE p570_count CURSOR FOR p570_precount
     LET g_wc_count = g_wc  #MOD-4B0091
     LET g_wc2_count = g_wc2#MOD-4B0091
END FUNCTION
 
#中文的MENU
FUNCTION p570_menu()
 
   WHILE TRUE
      CALL p570_bp("G")
      CASE g_action_choice
 
           WHEN "generate" 
            IF cl_chk_act_auth() THEN
                CALL p570_g()
                IF INT_FLAG THEN 
                     LET INT_FLAG = 0 
                ELSE 
                    CALL p570_q('g')
                END IF
            END IF
 
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p570_q('q')
            END IF
 
           WHEN "detail" 
            IF cl_chk_act_auth() THEN
                CALL p570_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "transfer_out" 
            IF cl_chk_act_auth() THEN
                CALL p570_t()
            END IF
 
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL p570_r()
            END IF
 
           WHEN "help" 
            CALL cl_show_help()
 
           WHEN "exit"
            EXIT WHILE
 
           WHEN "controlg"
            CALL cl_cmdask()
 
           WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
   
FUNCTION p570_r()                     #整批刪除96-05-29新增
DEFINE sr RECORD
          pnn01	LIKE pnn_file.pnn01,
          pnn02	LIKE pnn_file.pnn02,
          pnn03	LIKE pnn_file.pnn03, #FUN-770056
          pnn05	LIKE pnn_file.pnn05, #FUN-770056
          pnn06	LIKE pnn_file.pnn06 #FUN-770056
          END RECORD,
    #l_sql 	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)  #MOD-C70182 mark
     l_sql      STRING,                 #MOD-C70182
     l_cnt      LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
  OPEN WINDOW p570_r WITH FORM "apm/42f/apmp570_r"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_locale("apmp570_r")
 
  WHILE TRUE 
    CONSTRUCT BY NAME g_wc ON pnn01,pnn02  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END CONSTRUCT
    IF INT_FLAG THEN  LET INT_FLAG=0 EXIT WHILE END IF
    IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
    END IF
    IF cl_sure(20,16) THEN                  #確定是否刪除
        LET l_sql = " SELECT pnn01,pnn02,pnn03,pnn05,pnn06 ", #FUN-770056
                      " FROM pnn_file",
                      " WHERE " , g_wc CLIPPED
 
        PREPARE p570_prepare_r FROM l_sql
        DECLARE p570_cur CURSOR FOR p570_prepare_r
 
        LET g_forupd_sql = "SELECT pnn01,pnn02,pnn03,pnn05,pnn06 ",
                           " FROM pnn_file WHERE pnn01=? AND pnn02=? AND pnn03=? AND pnn05=? AND pnn06=? FOR UPDATE " #FUN-770056:此處請勿拆行寫,否則MSV版會錯
 
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE p570_curl CURSOR FROM g_forupd_sql
 
     LET g_success = 'Y'
     BEGIN WORK
     CALL s_showmsg_init()        #No.FUN-710030
     FOREACH p570_cur INTO sr.*
       IF SQLCA.sqlcode THEN 
          IF g_bgerr THEN
             CALL s_errmsg("","","foreach del:",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","foreach del:",1)
          END IF
          LET g_success = 'N'  #No.FUN-8A0086
          EXIT FOREACH 
       END IF
       IF g_success="N" THEN
          LET g_totsuccess="N"
          LET g_success="Y"
       END IF
 
       OPEN p570_curl USING sr.pnn01,sr.pnn02,sr.pnn03,sr.pnn05,sr.pnn06
       IF STATUS THEN
          LET g_success = 'N'
          IF g_bgerr THEN
             CALL s_errmsg("","","OPEN p570_curl:",SQLCA.sqlcode,1)
             CLOSE p570_curl
             CONTINUE FOREACH
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","OPEN p570_curl:",1)
             CLOSE p570_curl
             ROLLBACK WORK
             RETURN
          END IF
       END IF
       FETCH p570_curl INTO sr.pnn01,sr.pnn02,sr.pnn03,sr.pnn05,sr.pnn06 #FUN-770056
          IF STATUS THEN 
          IF g_bgerr THEN
             CALL s_errmsg("","",sr.pnn01,SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"",sr.pnn01,1)
          END IF
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF   
          MESSAGE sr.pnn01,' ',sr.pnn02,' ',sr.pnn03,' ',sr.pnn05,' ',sr.pnn06 #FUN-770056
          DELETE FROM pnn_file WHERE pnn01=sr.pnn01 AND pnn02=sr.pnn02 AND pnn03=sr.pnn03 AND pnn05=sr.pnn05 AND pnn06=sr.pnn06   #刪除底稿
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
             IF g_bgerr THEN
                CALL s_errmsg("pnn01",sr.pnn01,"delete pnn_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pnn_file",sr.pnn01,"",SQLCA.sqlcode,"","delete pnn_file error",1)
                EXIT FOREACH
             END IF
          ELSE
             IF NOT s_del_pnni(sr.pnn01,sr.pnn02,sr.pnn03,sr.pnn05,sr.pnn06,'') THEN
                EXIT FOREACH
             END IF                                                       
          END IF
     END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     CALL s_showmsg()
 
     CALL cl_end(21,20)
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE 
           ROLLBACK WORK
        END IF
    END IF
 END WHILE
 CLOSE WINDOW p570_r 
 LET l_cnt=0
 SELECT COUNT(*) INTO l_cnt
   FROM pnn_file
  WHERE pnn01 = g_pnn01
    AND pnn02 = g_pnn02 
 IF l_cnt =0 THEN
    CLEAR FORM
   CALL g_pnn.clear()
 END IF
 LET g_sql="SELECT DISTINCT pml01,pml02 ",
           " FROM pnn_file,pml_file,pmk_file ",
           " WHERE pnn01=pml01 AND ",
           "       pmk01=pml01 AND ",
           "       pnn01=pmk01 AND ",
           "       pnn02=pml02 ",
           " AND ",g_wc_count CLIPPED,
           " AND ",g_wc2_count CLIPPED,
           " INTO TEMP Y "
         IF g_wc.getindexof('pmli',1) > 0 THEN
         LET g_sql="SELECT DISTINCT pml01,pml02 ",
                   " FROM pnn_file,pml_file,pmk_file,pmli_file ",
                   " WHERE pnn01=pml01 AND ",
                   "       pmk01=pml01 AND ",
                   "       pnn01=pmk01 AND ",
                   "       pnn02=pml02 AND ",
                   "       pmli01=pml01 AND ",
                   "       pmli02=pml02  ",
                   " AND ",g_wc_count CLIPPED,
                   " AND ",g_wc2_count CLIPPED,
                   " INTO TEMP Y "
          END IF         
 DROP TABLE y 
 PREPARE p570_precount_y FROM g_sql
 EXECUTE p570_precount_y
 
     LET g_sql="SELECT COUNT(*) FROM y "
 
 PREPARE p570_precount_yy FROM g_sql
 DECLARE p570_count_y CURSOR FOR p570_precount_yy
 OPEN p570_count_y
 #FUN-B50063-add-start--
 IF STATUS THEN
    CLOSE p570_cs
    CLOSE p570_count_y
    COMMIT WORK
    RETURN
 END IF
 #FUN-B50063-add-end-- 
 FETCH p570_count_y INTO g_row_count
 #FUN-B50063-add-start--
 IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
    CLOSE p570_cs
    CLOSE p570_count_y
    COMMIT WORK
    RETURN
 END IF
 #FUN-B50063-add-end--
 DISPLAY g_row_count TO FORMONLY.cnt
 OPEN p570_cs
 IF g_curs_index = g_row_count + 1 THEN
    LET g_jump = g_row_count
    CALL p570_fetch('L')
 ELSE
    LET g_jump = g_curs_index
    LET g_no_ask = TRUE
    CALL p570_fetch('/')
 END IF
 
END FUNCTION
 
   
FUNCTION p570_g()
 DEFINE  l_cnt   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_pnn   RECORD LIKE pnn_file.*,
         l_cnt_tot,l_tot,l_tot_1 LIKE pmh_file.pmh11,
         l_n1    LIKE type_file.num5,        #No.FUN-8A0129
         l_count1    LIKE type_file.num5,    #No.FUN-8A0136
         i       LIKE type_file.num5,        #No.FUN-8A0129
         l_sma46  LIKE sma_file.sma46,       #No.FUN-8A0129
         l_pnn03  LIKE pnn_file.pnn03,       #No.FUN-8A0129
         l_str    LIKE pnn_file.pnn03,       #No.FUN-8A0136
         l_qty_tot       LIKE pml_file.pml20,
         l_flag          LIKE type_file.num5,     #No.FUN-680136 SMALLINT,
         l_qty           LIKE pnn_file.pnn09,
         l_ima44         LIKE ima_file.ima44,
         l_ima54         LIKE ima_file.ima54,
         l_pml20         LIKE pml_file.pml20,
         l_pml80         LIKE pml_file.pml80,
         l_pml81         LIKE pml_file.pml81,
         l_pml82         LIKE pml_file.pml82,
         l_pml83         LIKE pml_file.pml83,
         l_pml84         LIKE pml_file.pml84,
         l_pml85         LIKE pml_file.pml85,
         l_pml86         LIKE pml_file.pml86,
         l_pml87         LIKE pml_file.pml87,
         l_pmh02         LIKE pmh_file.pmh02,
         l_pmh11         LIKE pmh_file.pmh11,
         l_pmh12         LIKE pmh_file.pmh12,
         l_pmh13         LIKE pmh_file.pmh13,
         l_pml34         LIKE pml_file.pml34,
         l_pml07         LIKE pml_file.pml07,
         l_pmk01         LIKE pmk_file.pmk01,
         l_pmk22         LIKE pmk_file.pmk22,
         l_ima021        LIKE ima_file.ima021,
         l_gec04         LIKE gec_file.gec04,       #No.FUN-550089
         l_pnn33         LIKE pnn_file.pnn33,
         l_pnn34         LIKE pnn_file.pnn34,
         l_pnn35         LIKE pnn_file.pnn35,
         l_pnn30         LIKE pnn_file.pnn30,
         l_pnn31         LIKE pnn_file.pnn31,
         l_pnn32         LIKE pnn_file.pnn32,
         l_pnn36         LIKE pnn_file.pnn36,
         l_pnn37         LIKE pnn_file.pnn37,
         l_pml21         LIKE pml_file.pml21,
        #l_sql           LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(600)  #MOD-C70182 mark
         l_sql           STRING,                  #MOD-C70182
         l_cmd           LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(30)
         l_name          LIKE type_file.chr20,   #No.FUN-680136 VARCHAR(20)
         l_n             LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE  l_show_msg      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pnn01       LIKE pnn_file.pnn01,   #廠商編號
        pnn02       LIKE pnn_file.pnn02,   #料件編號
        pnn05       LIKE pnn_file.pnn05    #廠商編號
                   END RECORD,
        l_i         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_gaq03_f1  LIKE gaq_file.gaq03,
        l_gaq03_f2  LIKE gaq_file.gaq03,
        l_gaq03_f3  LIKE gaq_file.gaq03
DEFINE  l_pmk       RECORD LIKE pmk_file.*     #No.FUN-930148
DEFINE l_ima915     LIKE ima_file.ima915     #FUN-710060 add
DEFINE l_pmcacti    LIKE pmc_file.pmcacti   #MOD-930224
DEFINE l_pnni       RECORD LIKE pnni_file.*  #No.FUN-7B0018
DEFINE l_pmlislk01  LIKE pmli_file.pmlislk01 #No.FUN-810017
 
   OPEN WINDOW p570_g WITH FORM "apm/42f/apmp570_a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("apmp570_a")
   #FUN-C30055---add--begin--
   IF g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("pmlislk01",FALSE)
   END IF
   #FUN-C30055---add--end--
 
   WHILE TRUE 
      MESSAGE ""   #No.MOD-640058
      CLEAR FORM
     
     IF NOT cl_null(g_argv1) THEN
         DISPLAY  g_argv1 TO pmk01
         LET g_wc = g_argv2
     ELSE
     CONSTRUCT BY NAME g_wc ON pmk01,pml02,pmk04,pml35     #No.MOD-590422
                               ,pmlislk01                  #No.FUN-810017
 
#TQC-C70166 -- mark -- begin
#&ifdef SLK
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(pmlislk01)  
#                 CALL cl_init_qry_var()                                                                                         
#                 LET g_qryparam.form  = "q_skd1"                                                                              
#                 LET g_qryparam.state = "c"                                                                                  
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
#                 DISPLAY g_qryparam.multiret TO pmlislk01
#                 NEXT FIELD pmlislk01
#             OTHERWISE
#                EXIT CASE
#             END CASE
#&endif
#TQC-C70166 -- mark -- end
        #TQC-C70166 -- add -- begin
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form  = "q_pmk02" #CHI-B80097 mark
                  LET g_qryparam.form  = "q_pmk6"  #CHI-B80097
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk01
                  NEXT FIELD pmk01
               WHEN INFIELD(pmlislk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_skd1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmlislk01
                  NEXT FIELD pmlislk01
              OTHERWISE
                 EXIT CASE
              END CASE
        #TQC-C70166 -- add -- end
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
      END CONSTRUCT
 
      IF INT_FLAG THEN
         CLOSE WINDOW p570_g
         EXIT WHILE
      END IF
    END IF   #TQC-730022
 
      IF g_wc = ' 1=1' THEN
        CALL cl_err('','9046',0)
        CONTINUE WHILE
      END IF
 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.a = 'Y'
      LET tm.d = '2'
      LET tm.deldate = NULL
      LET l_pnn.pnn19 = NULL #BugNo:6632
 
      INPUT BY NAME tm.purpeo,tm.deldate,tm.a,tm.d,tm.pmc01 #NO:6998
                    WITHOUT DEFAULTS 
         BEFORE INPUT 
            CALL cl_set_comp_required("pmc01",FALSE)   
      
         AFTER FIELD purpeo
            IF cl_null(tm.purpeo) THEN
               NEXT FIELD purpeo
            ELSE
               CALL p570_purpeo('a')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(tm.purpeo,g_errno,0)
                  NEXT FIELD purpeo
               END IF
            END IF
      
         AFTER FIELD a
            IF tm.a IS NULL OR tm.a NOT MATCHES'[YN]' THEN
               NEXT FIELD a 
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]' THEN
               NEXT FIELD d 
            END IF 
            #TQC-BC0089--begin
            IF tm.d MATCHES'[123]' THEN
               CALL cl_set_comp_entry("pmc01",FALSE)
            ELSE
               CALL cl_set_comp_entry("pmc01",TRUE)
            END IF
            #TQC-BC0089--end
            CALL p570_set_no_required_h()   #MOD-710136
            CALL p570_set_required_h()   #MOD-710136
 
         BEFORE FIELD pmc01 #NO:6998
            IF tm.d != '4' THEN 
               EXIT INPUT
            END IF
 
         AFTER FIELD pmc01
            IF NOT cl_null(tm.pmc01) THEN
               CALL p570_pmc01() #check pmc01
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD pmc01
               END IF
            ELSE
               LET tm.pmc03 = NULL
            END IF
            DISPLAY BY NAME tm.pmc03
      
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
              CALL cl_cmdask()
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(purpeo)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = tm.purpeo
                    CALL cl_create_qry() RETURNING tm.purpeo
                    DISPLAY tm.purpeo TO FORMONLY.purpeo   
                 WHEN INFIELD(pmc01)  #NO:6998
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc"
                    LET g_qryparam.default1 = tm.pmc01
                    CALL cl_create_qry() RETURNING tm.pmc01
                    DISPLAY BY NAME tm.pmc01
                    CALL p570_pmc01()
                    NEXT FIELD pmc01
                 OTHERWISE
                    EXIT CASE
              END CASE
 
         AFTER INPUT 
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
      END INPUT
 
      IF INT_FLAG THEN  
         CLOSE WINDOW p570_g 
         EXIT WHILE
      END IF
 
      IF NOT cl_sure(20,20) THEN 
         LET INT_FLAG = 1 
         CLOSE WINDOW p570_g
         EXIT WHILE 
      END IF 
      
      CALL cl_wait()
 
      #-->產生分配檔資料
      CASE      
        WHEN tm.d = '1'    #料件主要供應商
          OR tm.d = '4'    #自行決定供應商
             LET l_sql = "SELECT pml01,pml02,pml04,pml42,(pml20-pml21),pml34,",
                         "  ima44,ima54,pml07,pml919,pmk22,pml83,pml84,pml85,pml80, ",   #FUN-A80150 add pml919
                         "  pml81,pml82,pml86,pml87,pml21,pmlislk01 ",   
                         "  FROM pmk_file,pml_file,ima_file,pmli_file",
                         "  WHERE pmk01 = pml01 ",
                         "   AND pmk18 = 'Y'",    #MOD-5B0332 add
                         "   AND pml04 = ima01 ",
                         "   AND pml20 > pml21 ",
                         "    AND pml16 IN ('1','2') ",
                         "   AND pml011 !='SUB' ",    #97-05-08
                         "   AND pml190 = 'N'",   #No.FUN-630040
#MOD-AC0402-----------------mod------------------str-----------------------------------
##TQC-AB0025----------mod-------------str------------------------------------------------
##                        "   AND pml02 NOT IN (SELECT pnn02 FROM pnn_file",
##                        "                      WHERE pnn01 = pml01      ",
##                        "                        AND pnn02 = pml02)     ",
#                        "   AND pml02 NOT IN (SELECT pnn02 FROM pnn_file LEFT OUTER JOIN pml_file ON ",
#                        "                            pnn01 = pml01      ",
#                        "                        AND pnn02 = pml02)     ",
##TQC-AB0025----------mod-------------end-----------------------------------------------
                         "   AND pml02 NOT IN (SELECT pnn02 FROM pnn_file",
                         "                      WHERE pnn01 = pml01      ",
                         "                        AND pnn02 = pml02)     ",
#MOD-AC0402-----------------mod------------------end----------------------------------
                         "   AND pml01 = pmli01 ",                                                                                           
                         "   AND pml02 = pmli02 ",
                         "   AND pml92 <> 'Y' ",    #FUN-A10034
                         "   AND pml50 = '1' ",   #TQC-AC0224 add
                         "   AND ",g_wc CLIPPED
             #-->屬於此採購員料件
             IF tm.a = 'Y' 
             THEN LET l_sql = l_sql clipped,
                              " AND ima43 = '",tm.purpeo,"'" clipped
             END IF
             PREPARE p570_prepare1 FROM l_sql
             DECLARE pml_curs1  CURSOR FOR p570_prepare1
             LET g_success = 'Y'
             LET g_exit  = 'Y'
             BEGIN WORK
             LET l_i = 1             #FUN-590130 add
             CALL l_show_msg.clear() #FUN-590130 add
             CALL s_showmsg_init()        #No.FUN-710030
 
              
             FOREACH pml_curs1 INTO l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,
                                    l_pnn.pnn13,l_pnn.pnn09,l_pml34,
             ##No.B470 SQL 取得資料為幣別不為料名
                                    l_pnn.pnn12,l_pnn.pnn05,l_pml07,l_pnn.pnn919,l_pmk22,
                                    l_pnn.pnn33,l_pnn.pnn34,l_pnn.pnn35,
                                    l_pnn.pnn30,l_pnn.pnn31,l_pnn.pnn32,
                                    l_pnn.pnn36,l_pnn.pnn37,l_pml21
                                   ,l_pmlislk01     #No.FUN-810017
              
                IF SQLCA.sqlcode THEN 
                   IF g_bgerr THEN
                      CALL s_errmsg("","","pml_curs1",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","pml_curs1",1)
                   END IF
                   LET g_success = 'N'  #No.FUN-8A0086
                   EXIT FOREACH
                END IF
                #主要供應廠商未輸入,請至料件基本資料維護-採購資料(aimi103)輸入!
                IF tm.d = '1' THEN #依料件主要供應商 NO:6998
                    IF cl_null(l_pnn.pnn05) THEN
                       IF g_bgerr THEN
                          LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03   #FUN-9B0085
                          CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-571",1)   #FUN-9B0085
                          CONTINUE FOREACH
                       ELSE
                          CALL cl_err3("","","","","apm-571","",l_pnn.pnn03,1)
                          CONTINUE FOREACH      #MOD-7A0176 add 
                       END IF
                    END IF
                END IF
                IF tm.d = '4' THEN #自行決定供應商  NO:6998
                    LET l_pnn.pnn05 = tm.pmc01
                END IF
 
                LET l_pmcacti=''
                SELECT pmcacti INTO l_pmcacti FROM pmc_file
                  WHERE pmc01=l_pnn.pnn05
                IF l_pmcacti MATCHES '[PHN]' THEN
                   IF g_bgerr THEN
                      LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn05   #FUN-9B0085
                      CALL s_errmsg("pnn01,pnn02,pnn03,pnn05",g_showmsg,"","9038",1)   #FUN-9B0085
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err(l_pnn.pnn05,"9038",1)
                      CONTINUE FOREACH       
                   END IF
                END IF
      
                IF l_pnn.pnn09 <= 0 THEN LET g_success ='N' END IF 
                LET g_exit = 'N'
                LET l_pnn.pnn07 = 100              #分配率
                LET l_pnn.pnn08 = 1                #單位替代量
                LET l_pnn.pnn15 = tm.purpeo        #採購員
                
                IF cl_null(tm.deldate) THEN 
                     LET l_pnn.pnn11 = l_pml34     #到廠日期
                ELSE LET l_pnn.pnn11 = tm.deldate  #到廠日期
                END IF
                #若無指定幣別則 default 供應商的慣用幣別
                   SELECT pmc22 INTO l_pmk22 FROM pmc_file
                    WHERE pmc01=l_pnn.pnn05
      
                SELECT gec04 INTO l_gec04 FROM pmc_file,gec_file
                 WHERE pmc01 = l_pnn.pnn05 AND gec01 = pmc47
                   AND gec011 = '1'  #進項 TQC-B70212 add

                IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF
      
                LET l_pnn.pnn06 = l_pmk22   #先用原請購單幣別,如找不到時再用ima的
                IF l_pnn.pnn13 IS NULL OR l_pnn.pnn13 = ' ' 
                THEN LET l_pnn.pnn13 = '0'
                END IF
                IF cl_null(l_pnn.pnn05) THEN LET l_pnn.pnn05=' ' END IF
                #---增加單位換算(因要計算轉出量,故以請購->採購之換算率)
                CALL s_umfchk(l_pnn.pnn03,l_pml07,l_pnn.pnn12)
                    RETURNING l_flag,l_pnn.pnn17 
                IF l_flag THEN 
                  ###Modify:98/11/15 --------單位換算率抓到----#####
                   IF g_bgerr THEN
                      LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pml07,l_pnn.pnn12   #FUN-9B0085
                      CALL s_errmsg("pnn01,pnn02,pnn03,pml07,pnn12",g_showmsg,"","abm-731",1)   #FUN-9B0085
                   ELSE
                      CALL cl_err3("","","","","abm-731","","pml07/pnn12: ",1)
                   END IF
                  LET g_success ='N'
                  LET l_pnn.pnn17=1 
                END IF
                LET l_pnn.pnn09=l_pnn.pnn09*l_pnn.pnn17
                LET l_pnn.pnn09 = s_digqty(l_pnn.pnn09,l_pnn.pnn12)   #FUN-910088--add--
                
                #---存換算率以採購對請購之換算率
                CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pml07)
                    RETURNING l_flag,l_pnn.pnn17 
                IF l_flag THEN 
                  ### --------單位換算率抓到----#####
                  IF g_bgerr THEN
                     LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn12,l_pml07   #FUN-9B0085
                     CALL s_errmsg("pnn01,pnn02,pnn03,pnn12,pml07",g_showmsg,"","abm-731",1)   #FUN-9B0085
                  ELSE
                     CALL cl_err3("","","","","abm-731","","pnn12/pml07: ",1)
                  END IF
                  LET g_success ='N' 
                  LET l_pnn.pnn17=1 
                END IF
                LET l_pnn.pnn16 = 'Y'              #修正否
                IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
                   LET l_pnn.pnn36=l_pnn.pnn12
                   LET l_pnn.pnn37=l_pnn.pnn09
                END IF
                IF l_pml21 > 0 THEN
                   CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                        RETURNING l_flag,g_factor
                   IF l_flag THEN
                       LET g_factor=1
                   END IF
                   LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
                   LET l_pnn.pnn32 = s_digqty(l_pnn.pnn32,l_pnn.pnn30)   #FUN-910088--add--
                   LET l_pnn.pnn35 = 0
                   CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                        RETURNING l_flag,g_factor
                   IF l_flag THEN
                       LET g_factor=1
                   END IF
                   LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
                END IF
                SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pnn.pnn06   #No.CHI-6A0004
                SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
                LET g_term = l_pmk.pmk41 
                IF cl_null(g_term) THEN 
                  SELECT pmc49 INTO g_term
                    FROM pmc_file 
                   WHERE pmc01 = l_pnn.pnn05
                END IF 
                LET g_price = l_pmk.pmk20
                IF cl_null(g_price) THEN 
                  SELECT pmc17 INTO g_price
                    FROM pmc_file 
                   WHERE pmc01 = l_pnn.pnn05
                END IF 
                LET l_pnn.pnn36 = l_pml07 
                LET l_pnn.pnn37 = s_digqty(l_pnn.pnn37,l_pnn.pnn36)   #FUN-910088--add--
                SELECT pmc47 INTO g_pmm.pmm21
                  FROM pmc_file
                  WHERE pmc01 =l_pnn.pnn05
                SELECT gec04 INTO g_pmm.pmm43
                  FROM gec_file
                 WHERE gec01 = g_pmm.pmm21
                   AND gec011 = '1'  #進項 TQC-B70212 add
                CALL s_defprice_new(l_pnn.pnn03,l_pnn.pnn05,l_pnn.pnn06,g_today,l_pnn.pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",l_pnn.pnn36,'',g_term,g_price,g_plant) 
                   RETURNING l_pnn.pnn10,l_pnn.pnn10t,
                             g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add  
               #CALL p570_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t)   #MOD-9C0285 ADD
                CALL p570_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t,g_term)   #MOD-9C0285 ADD  #TQC-B80055 mod
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                 END IF
                IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
                LET l_pnn.pnn10 = cl_digcut(l_pnn.pnn10,t_azi03)  #No.CHI-6A0004
                LET l_pnn.pnn10t= cl_digcut(l_pnn.pnn10t,t_azi03)  #No.CHI-6A0004
                LET l_pnn.pnnplant = g_plant #FUN-980006 add
                LET l_pnn.pnnlegal = g_legal #FUN-980006 add
                INSERT INTO pnn_file VALUES(l_pnn.*)
                IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
                   LET g_success = 'N'
                   IF g_bgerr THEN
                      LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn05,"/",l_pnn.pnn06
                      CALL s_errmsg("pnn01,pnn02,pnn03,pnn05,pnn06",g_showmsg,"ins pnn #1",SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err3("ins","pnn_file","l_pnn.pnn01","l_pnn.pnn02",SQLCA.sqlcode,"","ins pnn #1",0)
                      EXIT FOREACH
                   END IF
                ELSE    #No.FUN-830132
                   INITIALIZE l_pnni.* TO NULL
                   LET l_pnni.pnni01 = l_pnn.pnn01
                   LET l_pnni.pnni02 = l_pnn.pnn02
                   LET l_pnni.pnni03 = l_pnn.pnn03
                   LET l_pnni.pnni05 = l_pnn.pnn05
                   LET l_pnni.pnni06 = l_pnn.pnn06
                   LET l_pnni.pnnislk01 = l_pmlislk01
                   IF NOT s_ins_pnni(l_pnni.*,'') THEN
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
                END IF
                LET l_show_msg[l_i].pnn01=l_pnn.pnn01
                LET l_show_msg[l_i].pnn02=l_pnn.pnn02
                LET l_show_msg[l_i].pnn05=l_pnn.pnn05
                LET l_i = l_i + 1
      
             END FOREACH
             IF g_totsuccess="N" THEN
                LET g_success="N"
             END IF
 
             #-->無符合條件資料
             IF g_exit = 'Y' THEN 
                CALL cl_err(l_pnn.pnn01,'mfg2601',1)
                CONTINUE WHILE
             ELSE
               IF g_success = 'Y' THEN  #MOD-760110 add
                #以陣列方式show出所產生的資料
                LET g_msg = NULL
                LET g_msg2= NULL
                LET l_gaq03_f1 = NULL
                LET l_gaq03_f2 = NULL
                LET l_gaq03_f3 = NULL
                CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
                CALL cl_get_feldname('pnn01',g_lang) RETURNING l_gaq03_f1
                CALL cl_get_feldname('pnn02',g_lang) RETURNING l_gaq03_f2
                CALL cl_get_feldname('pnn05',g_lang) RETURNING l_gaq03_f3
                LET g_msg2 = l_gaq03_f1 CLIPPED,'|',l_gaq03_f2 CLIPPED,'|',l_gaq03_f3 CLIPPED
                CALL cl_show_array(base.TypeInfo.create(l_show_msg),g_msg         ,g_msg2)
               END IF         #MOD-760110 add
             END IF
             CALL s_showmsg()     #MOD-930224 
             IF g_success = 'Y' THEN
                CALL cl_cmmsg(1) COMMIT WORK 
             ELSE
                CALL cl_rbmsg(1) ROLLBACK WORK 
             END IF
        WHEN tm.d = '2' OR tm.d = '3'    #依料件供應商比率分配
             LET l_sql = "SELECT pml01,pml02,pml04,pml42,(pml20-pml21), ",
                         "  pml80,pml81,pml82,pml83,pml84,pml85,pml86,pml87, ", #No.FUN-560063
                         "  pml34,ima44,ima54,pml07,pml919,ima021,pml21,pmlislk01 ", #No.FUN-540194  #FUN-A80150 add pml919
                         "  FROM pmk_file,pml_file,ima_file,pmli_file",
                         "  WHERE pmk01= pml01 ",
                         "   AND pmk18 = 'Y'",     #MOD-5B0332 add
                         "   AND pml04 = ima01 ",
                         "   AND pml20 > pml21 ",
                         "    AND pml16 IN ('1','2') ",
                         "   AND pml190 = 'N'",   #No.FUN-630040
                         "   AND pml92 <> 'Y' ",    #FUN-A10034
                         "   AND pml02 NOT IN (SELECT pnn02 FROM pnn_file",
                         "                      WHERE pnn01 = pml01      ",
                         "                        AND pnn02 = pml02)     ",
                         "   AND pml01 = pmli01 ",
                         "   AND pml02 = pmli02 ",
                         "   AND ",g_wc
             #-->屬於此採購員料件
             IF tm.a = 'Y' 
             THEN LET l_sql = l_sql clipped,
                              " AND ima43 = '",tm.purpeo,"'" clipped
             END IF
             PREPARE p570_prepare2 FROM l_sql
             DECLARE pml_curs2  CURSOR FOR p570_prepare2
      
             #-->廠商分配資料
             LET l_sql = "SELECT pmh02,pmh11,pmh12,pmh13",
                         "  FROM pmh_file ",
                         " WHERE pmh01 = ? ",
                         "   AND pmh05 = '0' ",    #已核准
                         "   AND pmh21 = ' ' ",                                           #CHI-860042                               
                         "   AND pmh22 = '1' ",                                           #CHI-860042
                         "   AND pmh23 = ' '",                             #No.CHI-960033
                         "   AND pmhacti = 'Y'",                                          #CHI-910021
                         "   AND pmh02 IN (SELECT pmc01 FROM pmc_file ",   #MOD-930224
                         "   WHERE pmcacti = 'Y')"   #MOD-930224
             IF tm.d = '2' THEN 
                  LET l_sql = l_sql clipped," AND pmh11 > 0 "
             ELSE 
                  LET l_sql = l_sql clipped," AND pmh11 >=0 "
             END IF
             LET l_sql = l_sql CLIPPED," ORDER BY pmh02,pmh13 "
             PREPARE p570_pvender FROM l_sql
             DECLARE vender_c  CURSOR FOR p570_pvender
             #-->總分配率
             LET l_sql = "SELECT SUM(pmh11) FROM pmh_file ",
                         " WHERE pmh01= ? ",
                         "   AND pmh05 = '0' ",   #已核准
                         "   AND pmh21 = ' ' ",                                           #CHI-860042                               
                         "   AND pmh22 = '1' ",                                           #CHI-860042
                         "   AND pmh23 = ' '",                             #No.CHI-960033
                         "   AND pmhacti = 'Y'",                                          #CHI-910021
                         "   AND pmh02 IN (SELECT pmc01 FROM pmc_file ",   #MOD-930224
                         "   WHERE pmcacti = 'Y')"   #MOD-930224
        
             PREPARE p570_psum FROM l_sql
             DECLARE sum_cur   CURSOR FOR p570_psum 
 
             LET l_sql = "SELECT SUM(pmh11) FROM pmh_file ",
                         " WHERE pmh01= ? ",
                         "   AND pmh05 = '0' ",   #已核准
                         "   AND pmh21 = ' ' ",                                           #CHI-860042                               
                         "   AND pmh22 = '1' ",                                           #CHI-860042
                         "   AND pmh23 = ' '",                             #No.CHI-960033
                         "   AND pmhacti = 'Y'"                                           #CHI-910021
        
             PREPARE p570_psum_1 FROM l_sql
             DECLARE sum_cur_1   CURSOR FOR p570_psum_1 
      
             LET g_success = 'Y'
             LET g_exit = 'Y'
             LET g_i = 1             #FUN-590130 add
             CALL l_show_msg.clear() #FUN-590130 add
      
             CALL cl_outnam('apmp570') RETURNING l_name

             BEGIN WORK   #MOD-9B0041
             START REPORT p570_rep TO l_name
      
             CALL s_showmsg_init()        #No.FUN-710030
             FOREACH pml_curs2 INTO l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,
                                    l_pnn.pnn13,l_pml20,
                                    l_pml80,l_pml81,l_pml82,l_pml83,l_pml84,
                                    l_pml85,l_pml86,l_pml87,l_pml34,
                                    l_ima44,l_ima54,l_pml07,l_pnn.pnn919,l_ima021,l_pml21 
                                    ,l_pmlislk01  #No.FUN-870124
                IF SQLCA.sqlcode THEN 
                   IF g_bgerr THEN
                      CALL s_errmsg("","","pml_curs2",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","pml_curs2",0)
                   END IF
                   LET g_success = 'N'  #No.FUN-8A0086
                   EXIT FOREACH
                END IF
                #請購-已轉採購量須大於0  
                IF l_pml20 <= 0 THEN CONTINUE FOREACH END IF 
                LET g_exit = 'N'
                #-->總分配率
                OPEN sum_cur USING l_pnn.pnn03
                IF SQLCA.sqlcode THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("","","open sum_cur",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","open sum_cur",0)
                   END IF
                END IF
                SELECT sma46 INTO l_sma46 FROM sma_file 
                   FOR i=1 TO length(l_pnn.pnn03)
                      IF l_pnn.pnn03[i,i] = l_sma46 THEN
                         LET l_pnn03 = l_pnn.pnn03[1,i-1]
                         EXIT FOR 
                      END IF
                   END FOR    
                OPEN sum_cur_1 USING l_pnn03        #No.FUN-8A0129
                IF SQLCA.sqlcode THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("","","open sum_cur_1",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","open sum_cur_1",0)
                   END IF
                END IF
                FETCH sum_cur INTO l_tot  
                IF SQLCA.sqlcode THEN 
                   IF g_bgerr THEN
                      CALL s_errmsg("","","sum_cur",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","sum_cur",1)
                   END IF
                END IF 
                FETCH sum_cur_1 INTO l_tot_1    #No.FUN-8A0129  
                IF SQLCA.sqlcode THEN 
                   IF g_bgerr THEN
                      CALL s_errmsg("","","sum_cur_1",SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("","","","",SQLCA.sqlcode,"","sum_cur_1",1)
                   END IF
                END IF 
                CLOSE sum_cur 
                CLOSE sum_cur_1      #No.FUN-8A0129 
                IF cl_null(l_tot) AND cl_null(l_tot_1) THEN
                    #此料件的料件/供應商資料未建立(apmi254)!
                   IF g_bgerr THEN
                      LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03   #FUN-9B0085
                      CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-572",1)   #FUN-9B0085
                      LET g_success = 'N' #MOD-C90068 add
                      CONTINUE FOREACH  #MOD-C90068 add                      
                   ELSE
                      CALL cl_err3("","","","","apm-572","",l_pnn.pnn03,1)
                   END IF
                   CALL s_showmsg()      #No.TQC-7C0168
                   CALL cl_rbmsg(1)
                   ROLLBACK WORK
                   EXIT CASE
                END IF
                IF g_success = 'N' THEN CONTINUE FOREACH  END IF  #MOD-C90068 add,將核價信息全部遍歷一遍
                LET l_cnt_tot = 0
                LET l_qty_tot = 0
                DELETE FROM p570_tmp
                SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=l_pnn.pnn03
                IF l_ima915='2' OR l_ima915='3' THEN 
                    SELECT COUNT(*) INTO l_n
                      FROM pmh_file
                     WHERE pmh01 = l_pnn.pnn03
                       AND pmh05 = '0' 
                       AND pmh21 = " "                                             #CHI-860042                                      
                       AND pmh22 = '1'                                             #CHI-860042
                       AND pmh23 = ' '                                             #CHI-960033
                       AND pmhacti = 'Y'                                           #CHI-910021
                    SELECT COUNT(*) INTO l_n1
                      FROM pmh_file
                     WHERE pmh01 = l_pnn03
                       AND pmh05 = '0' 
                       AND pmh21 = " "                                             #CHI-860042                                      
                       AND pmh22 = '1'                                             #CHI-860042
                       AND pmh23 = ' '                                             #CHI-960033
                       AND pmhacti = 'Y'                                           #CHI-910021
                    IF STATUS OR SQLCA.sqlcode OR (l_n <=0 AND l_n1 <=0) THEN      #No.FUN-8A0129 add l_n1 
                        LET g_exit = 'Y' 
                        #此料件的料件/供應商資料未建立(apmi254)!
                       IF g_bgerr THEN
                          LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03   #FUN-9B0085
                          CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-572",1)   #FUN-9B0085
                       ELSE
                          CALL cl_err3("","","","","apm-572","",l_pnn.pnn03,1)
                       END IF
                    END IF
                END IF
               #在apmt420中沒有這個明細料號資料則抓款式的資料
               IF tm.d = '2' THEN
                SELECT COUNT(*) INTO l_count1 FROM pmh_file  WHERE pmh01= l_pnn.pnn03
                AND pmh05 = '0' AND pmh21 = ' ' AND pmh22 = '1' AND pmh11 > 0
                AND pmh23 = ' '                                             #CHI-960033
                AND pmhacti = 'Y'                                           #CHI-910021 
                ORDER BY pmh02,pmh13 
               ELSE
                SELECT COUNT(*) INTO l_count1 FROM pmh_file  WHERE pmh01= l_pnn.pnn03
                AND pmh05 = '0' AND pmh21 = ' ' AND pmh22 = '1' AND pmh11 >=0
                AND pmh23 = ' '                                             #CHI-960033
                AND pmhacti = 'Y'                                           #CHI-910021 
                ORDER BY pmh02,pmh13 
               END IF
               IF l_count1 <= 0 THEN
                  LET l_str = l_pnn03
               ELSE
                  LET l_str = l_pnn.pnn03
               END IF
 
               FOREACH vender_c USING l_str
                  INTO l_pmh02,l_pmh11,l_pmh12,l_pmh13
                  IF SQLCA.sqlcode THEN 
                     IF g_bgerr THEN
                        CALL s_errmsg("","","vender_c",SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("","","","",SQLCA.sqlcode,"","vender_c",0)
                     END IF
                     EXIT FOREACH
                  END IF
                  
                  SELECT gec04 INTO l_gec04 FROM pmc_file,gec_file
                   WHERE pmc01 = l_pmh02 AND gec01 = pmc47
                     AND gec011 = '1'  #進項 TQC-B70212 add
                  IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF
                  
                  IF cl_null(l_tot) THEN
                     LET l_tot = l_tot_1
                  END IF
                  OUTPUT TO REPORT p570_rep(l_pmh02,l_pmh11,l_pmh12,l_pmh13,
                                            l_pnn.*,
                                            l_pml20,l_pml80,l_pml81,l_pml82,
                                            l_pml83,l_pml84,l_pml85,l_pml86, 
                                            l_pml87,l_pml34,l_ima44,l_ima54,
                                            l_pml07,l_ima021,l_pml21,l_tot,l_gec04,l_pmlislk01)  
               END FOREACH         
      
            END FOREACH
            IF g_totsuccess="N" THEN
               LET g_success="N"
            END IF
 
            FINISH REPORT p570_rep
            IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
            #-->無符合條件資料
            IF g_exit = 'Y' THEN 
               CALL cl_err(l_pnn.pnn01,'mfg2601',1)
               CONTINUE WHILE
            ELSE
               #以陣列方式show出所產生的資料
               LET g_msg = NULL
               LET g_msg2= NULL
               LET g_gaq03_f1 = NULL
               LET g_gaq03_f2 = NULL
               LET g_gaq03_f3 = NULL
               CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
               CALL cl_get_feldname('pnn01',g_lang) RETURNING g_gaq03_f1
               CALL cl_get_feldname('pnn02',g_lang) RETURNING g_gaq03_f2
               CALL cl_get_feldname('pnn05',g_lang) RETURNING g_gaq03_f3
               LET g_msg2 = g_gaq03_f1 CLIPPED,'|',g_gaq03_f2 CLIPPED,'|',g_gaq03_f3 CLIPPED
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg         ,g_msg2)
            END IF
 
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN
               CALL cl_cmmsg(1)
               COMMIT WORK 
            ELSE
               CALL cl_rbmsg(1)
               ROLLBACK WORK 
            END IF
         OTHERWISE
            EXIT CASE
      END CASE  
 
      CALL cl_end(20,20)
      CLOSE WINDOW p570_g 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
REPORT p570_rep(l_pmh02,l_pmh11,l_pmh12,l_pmh13,l_pnn,
                l_pml20,l_pml80,l_pml81,l_pml82,l_pml83,l_pml84,l_pml85,
                l_pml86,l_pml87,l_pml34,l_ima44,l_ima54,l_pml07,l_ima021,
                l_pml21,l_tot,l_gec04,l_pmlislk01)   
DEFINE  l_pnn     RECORD LIKE pnn_file.*,
        l_pmh02   LIKE pmh_file.pmh02,
        l_pmh11   LIKE pmh_file.pmh11,
        l_pmh12   LIKE pmh_file.pmh12,
        l_pmh19   LIKE pmh_file.pmh19,  #No.FUN-610018
        l_pmh13   LIKE pmh_file.pmh13,
        l_pml20   LIKE pml_file.pml20,
        l_pml80         LIKE pml_file.pml80,
        l_pml81         LIKE pml_file.pml81,
        l_pml82         LIKE pml_file.pml82,
        l_pml83         LIKE pml_file.pml83,
        l_pml84         LIKE pml_file.pml84,
        l_pml85         LIKE pml_file.pml85,
        l_pml86         LIKE pml_file.pml86,
        l_pml87         LIKE pml_file.pml87,
        l_pml21         LIKE pml_file.pml21,
        l_pml34   LIKE pml_file.pml34,
        l_pml07   LIKE pml_file.pml07,
        l_ima44   LIKE ima_file.ima44,
        l_ima54   LIKE ima_file.ima54,
        l_ima021  LIKE ima_file.ima021,
        l_gec04          LIKE gec_file.gec04,       #No.FUN-550089
        l_cnt_tot,l_tot  LIKE pmh_file.pmh11,
        l_flag    LIKE type_file.num5,   #No.FUN-680136 SMALLINT
        l_qty     LIKE pnn_file.pnn09,
        l_qty_tot        LIKE pml_file.pml20,
        l_n              LIKE type_file.num5,    #No.FUN-680136 SMALLINT
        l_pnn10t         LIKE pnn_file.pnn10t,    #No.FUN-550089
        sr RECORD 
                  choice   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
                  supr     LIKE pmh_file.pmh02,   #No.FUN-680136 VARCHAR(10)
                  curr     LIKE pmh_file.pmh13,   #No.FUN-680136 VARCHAR(04)
                  price    LIKE pmh_file.pmh12,   #No.FUN-680136 dec(20,6) #FUN-4C0011
                  price_t  LIKE pmh_file.pmh12,   #No.FUN-680136 dec(20,6) #No.FUN-550089
                  rate     LIKE pmh_file.pmh11    #No.FUN-680136 dec(8,4)
        END RECORD
DEFINE  l_pmk       RECORD LIKE pmk_file.*      #No.FUN-930148        
DEFINE  l_pnni      RECORD LIKE pnni_file.*       #No.FUN-7B0018
DEFINE l_pmlislk01  LIKE pmli_file.pmlislk01   #No.FUN-870124
 
#ORDER EXTERNAL BY l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,l_pmh02,l_pmh13 #MOD-BB0252 mark 
 ORDER BY l_pnn.pnn01,l_pnn.pnn03,l_pmh02,l_pmh13                      #MOD-BB0252 add 
FORMAT 
  BEFORE GROUP OF l_pmh02
   DELETE FROM p570_tmp
   
  AFTER GROUP OF l_pmh13
     SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmh13   #No.CHI-6A0004
      SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
      LET g_term = l_pmk.pmk41 
      IF cl_null(g_term) THEN 
         SELECT pmc49 INTO g_term
           FROM pmc_file 
          WHERE pmc01 = l_pmh02
      END IF 
      LET g_price = l_pmk.pmk20
      IF cl_null(g_price) THEN 
         SELECT pmc17 INTO g_price
           FROM pmc_file 
          WHERE pmc01 = l_pmh02
      END IF   
      LET l_pnn.pnn36 = l_pml07  
      SELECT pmc47 INTO g_pmm.pmm21
       FROM pmc_file
      WHERE pmc01 =l_pmh02
     SELECT gec04 INTO g_pmm.pmm43
       FROM gec_file
      WHERE gec01 = g_pmm.pmm21
        AND gec011 = '1'  #進項 TQC-B70212 add
     CALL s_defprice_new(l_pnn.pnn03,l_pmh02,l_pmh13,g_today,l_pnn.pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',l_pnn.pnn36,'',g_term,g_price,g_plant)
        RETURNING l_pmh12,l_pmh19,
                  g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add                                               
    #CALL p570_price_check(l_pmh02,l_pmh12,l_pmh19)      #MOD-9C0285 ADD
     CALL p570_price_check(l_pmh02,l_pmh12,l_pmh19,g_term)      #MOD-9C0285 ADD  #TQC-B80055 mod
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,1)
      END IF
     IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
     LET l_pmh12 = cl_digcut(l_pmh12,t_azi03)  #No.CHI-6A0004
     LET l_pnn10t = l_pmh19 
     LET l_pnn10t = cl_digcut(l_pnn10t,t_azi03)  #No.CHI-6A0004
     INSERT INTO p570_tmp VALUES('N',l_pmh02,l_pmh13,l_pmh12,l_pnn10t,l_pmh11)
 
  AFTER GROUP OF l_pmh02
     SELECT COUNT(*) INTO l_n FROM p570_tmp
     IF l_n > 1 THEN
        CALL p570_choice(l_pnn.pnn01,l_pnn.pnn03)
     ELSE
        UPDATE p570_tmp SET choice='Y'
     END IF
     LET l_cnt_tot=0
     LET l_qty_tot=0
     DECLARE tmp_cs CURSOR FOR
       SELECT * FROM p570_tmp WHERE choice='Y'
     FOREACH tmp_cs INTO sr.*
               LET l_pnn.pnn30 = l_pml80
               LET l_pnn.pnn31 = l_pml81
               LET l_pnn.pnn33 = l_pml83
               LET l_pnn.pnn34 = l_pml84
               LET l_pnn.pnn36 = l_pml86
               LET l_pnn.pnn37 = l_pml87   #No.MOD-5A0045
               LET l_pnn.pnn32 = l_pml82   #No.MOD-5A0045
               LET l_pnn.pnn35 = l_pml85   #No.MOD-5A0045
               #-->分配數量
               LET l_cnt_tot = l_cnt_tot + sr.rate
               IF l_cnt_tot = l_tot THEN 
                  LET l_pnn.pnn09 = l_pml20 - l_qty_tot 
                  IF l_pml21 > 0 THEN
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
                     LET l_pnn.pnn35 = 0
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
                  END IF
               ELSE 
                  LET l_qty = l_pml20 * sr.rate /l_tot
                  LET l_pnn.pnn09 = l_qty
                  IF l_pml21 > 0 THEN
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
                     LET l_pnn.pnn35 = 0
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
                  ELSE
                     LET l_pnn.pnn32 = l_pml82 * sr.rate/l_tot
                     LET l_pnn.pnn35 = l_pml85 * sr.rate/l_tot
                     LET l_pnn.pnn37 = l_pml87 * sr.rate/l_tot
                  END IF
                  LET l_qty_tot = l_qty_tot + l_pnn.pnn09
               END IF
               LET l_pnn.pnn32 = s_digqty(l_pnn.pnn32,l_pnn.pnn30)   #FUN-910088--add--
               LET l_pnn.pnn35 = s_digqty(l_pnn.pnn35,l_pnn.pnn33)   #FUN-910088--add--
               LET l_pnn.pnn37 = s_digqty(l_pnn.pnn37,l_pnn.pnn36)   #FUN-910088--add--
 
               LET l_pnn.pnn05 = l_pmh02          #供應商
               LET l_pnn.pnn06 = sr.curr          #幣別
               LET l_pnn.pnn07 = sr.rate          #分配率
               LET l_pnn.pnn08 = 1                #單位替代量
               LET l_pnn.pnn10 = sr.price         #最近採購單價
               LET l_pnn.pnn10t= sr.price_t       #No.FUN-550089
               LET l_pnn.pnn12 = l_ima44          #採購單位 
             #---增加單位換算(因要計算轉出量,故以請購->採購之換算率)
             CALL s_umfchk(l_pnn.pnn03,l_pml07,l_pnn.pnn12)
                 RETURNING l_flag,l_pnn.pnn17 
             IF l_flag THEN 
                 ### -----單位換算率抓不到-------####
                 CALL cl_err('pml07/pnn12: ','abm-731',1) 
                 LET g_success ='N' 
                 LET l_pnn.pnn17=1 
             END IF
             LET l_pnn.pnn09=l_pnn.pnn09*l_pnn.pnn17
             LET l_pnn.pnn09 = s_digqty(l_pnn.pnn09,l_pnn.pnn12)   #FUN-910088--add--
             #---存換算率以採購對請購之換算率
             CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pml07)
                  RETURNING l_flag,l_pnn.pnn17 
             IF l_flag THEN  
                 ### ---單位換算率抓不到 -----#####
                 CALL cl_err('pnn12/pml07: ','abm-731',1)
                 LET g_success ='N' 
                 LET l_pnn.pnn17=1 
             END IF
               IF g_sma.sma116 MATCHES '[02]' THEN   
                  LET l_pnn.pnn36=l_pnn.pnn12
                  LET l_pnn.pnn37=l_pnn.pnn09
               END IF
               LET l_pnn.pnn15 = tm.purpeo        #採購員
               IF cl_null(tm.deldate) THEN 
                    LET l_pnn.pnn11 = l_pml34     #到廠日期
               ELSE LET l_pnn.pnn11 = tm.deldate  #到廠日期
               END IF
               IF l_pnn.pnn13 IS NULL OR l_pnn.pnn13 = ' ' 
               THEN LET l_pnn.pnn13 = '0'
               END IF
              IF cl_null(l_pnn.pnn05) THEN LET l_pnn.pnn05=' ' END IF
               LET l_pnn.pnn16 = "Y"   
               CALL s_defprice_new(l_pnn.pnn03,l_pnn.pnn05,l_pnn.pnn06,g_today,l_pnn.pnn37,'',
                                   g_pmm.pmm21,g_pmm.pmm43,'1',l_pnn.pnn36,'',g_term,g_price,g_plant)
                  RETURNING l_pnn.pnn10,l_pnn.pnn10t,
                            g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
              #CALL p570_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t)    #MOD-9C0285 ADD
               CALL p570_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t,g_term)    #MOD-9C0285 ADD  #TQC-B80055 mod
               IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
               LET l_pnn.pnnplant = g_plant #FUN-980006 add
               LET l_pnn.pnnlegal = g_legal #FUN-980006 add
               INSERT INTO pnn_file VALUES(l_pnn.*)
               IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
                  CALL cl_err3("ins","pnn_file","","",SQLCA.sqlcode,"","ins pnn #2",0)  #No.FUN-660129
                  LET g_success = 'N'
                  EXIT FOREACH
               ELSE    #No.FUN-830132       
                  INITIALIZE l_pnni.* TO NULL
                  LET l_pnni.pnni01 = l_pnn.pnn01
                  LET l_pnni.pnni02 = l_pnn.pnn02
                  LET l_pnni.pnni03 = l_pnn.pnn03
                  LET l_pnni.pnni05 = l_pnn.pnn05
                  LET l_pnni.pnni06 = l_pnn.pnn06
                  LET l_pnni.pnnislk01 = l_pmlislk01  #NO.FUN-870124
                  IF NOT s_ins_pnni(l_pnni.*,'') THEN
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
               END IF
              LET g_show_msg[g_i].pnn01=l_pnn.pnn01
              LET g_show_msg[g_i].pnn02=l_pnn.pnn02
              LET g_show_msg[g_i].pnn05=l_pnn.pnn05
              LET g_i = g_i + 1
 
    END FOREACH
END REPORT
 
FUNCTION  p570_choice(l_no,l_item)
 DEFINE l_tmp DYNAMIC ARRAY OF RECORD 
              choice   LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
              supr     LIKE pmh_file.pmh02,     #No.FUN-680136 VARCHAR(10)
              curr     LIKE pmh_file.pmh13,     #No.FUN-680136 VARCHAR(04)
              price    LIKE pmh_file.pmh12,     #No.FUN-680136 dec(20,6) #FUN-4C0011
              rate     LIKE pmh_file.pmh11      #No.FUN-680136 dec(8,4)
             END RECORD,
        s_rate  LIKE pmh_file.pmh11,     #No.FUN-680136 dec(8,4)
        l_cnt   LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_exit  LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
        l_no    LIKE pnn_file.pnn01,
        l_item  LIKE pnn_file.pnn03
 DEFINE l_cnt2  LIKE type_file.num5      #MOD-BB0252 add
 
 
   OPEN WINDOW p570_choice_w WITH FORM "apm/42f/apmp570_c" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("apmp570_c")
 
 WHILE TRUE
        MESSAGE "P/R NO:",l_no," Item:",l_item  CLIPPED 
        DISPLAY l_no TO FORMONLY.pnn01   #MOD-BB0252 add
        DISPLAY l_item TO FORMONLY.pnn03 #MOD-BB0252 add
        DECLARE choice_cs CURSOR FOR 
        #SELECT * FROM p570_tmp                           #MOD-BB0252 mark
         SELECT choice,supr,curr,price,rate FROM p570_tmp #MOD-BB0252
 
        CALL l_tmp.clear()
 
        LET l_exit='Y'
        LET g_cnt=1                                         #總選取筆數
        FOREACH choice_cs INTO l_tmp[g_cnt].*
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)   #No.FUN-660129
                EXIT FOREACH
            END IF
            LET g_cnt = g_cnt + 1                           #累加筆數
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',1)                     #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF
        CALL l_tmp.deleteElement(g_cnt) #MOD-BB0252 add
        LET g_cnt=g_cnt-1                                   #正確的總筆數
        CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
        CALL cl_getmsg('apm-998',g_lang) RETURNING g_msg
       #DISPLAY "" AT 1,1      #CHI-A70049 mark             #清除不要的資訊
       #DISPLAY g_msg AT 2,1   #CHI-A70049 mark             #顯示操作指引
        LET l_cnt=0                                     #已選筆數
       #CALL cl_set_act_visible("accept,cancel", FALSE) #MOD-BB0252 mark
        #DISPLAY ARRAY l_tmp TO s_tmp.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #MOD-540149 #MOD-BB0252 mark
       #MOD-BB0252 add --start--
       INPUT ARRAY l_tmp WITHOUT DEFAULTS FROM s_tmp.*
          ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       #MOD-BB0252 add --end--

          BEFORE ROW                #MOD-540149
             LET l_ac = ARR_CURR()  #MOD-540149

       #MOD-BB0252 add --start--
          AFTER FIELD choice 
             IF NOT cl_null(l_tmp[l_ac].choice) THEN
                IF l_tmp[l_ac].choice NOT MATCHES "[YN]" THEN
                   NEXT FIELD choice 
                END IF
             END IF
             LET l_cnt2 = 0
             FOR l_cnt = 1 TO l_tmp.getlength() 
                IF l_tmp[l_cnt].choice = 'Y' THEN
                   LET l_cnt2 = l_cnt2 + 1
                END IF
             END FOR
             IF l_cnt2 > 1 THEN   #必須挑選一筆
                CALL cl_err('','apm-999',1) 
                NEXT FIELD choice 
             END IF

          AFTER ROW
             IF INT_FLAG THEN
                EXIT INPUT
             END IF
          
          AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT
             END IF

             SELECT SUM(rate) INTO s_rate FROM p570_tmp
             FOR l_cnt = 1 TO l_tmp.getlength() 
                 IF l_tmp[l_cnt].choice='Y' THEN
                    LET l_tmp[l_cnt].rate = s_rate
                    UPDATE p570_tmp SET rate=l_tmp[l_cnt].rate,
                                        choice='Y'
                     WHERE supr=l_tmp[l_cnt].supr 
                       AND curr=l_tmp[l_cnt].curr
                    IF STATUS THEN
                       LET g_success='N'
                       CALL cl_err3("upd","p570_tmp",l_tmp[l_cnt].supr,l_tmp[l_cnt].curr,STATUS,"","upd p570_tmp:",1) 
                       EXIT FOR    
                    END IF
                  END IF
             END FOR
       #MOD-BB0252 add --end--

            ON ACTION CONTROLG
                CALL cl_cmdask()
            ON ACTION CONTROLN  #重查
               #LET l_exit='N' #MOD-BB0252 mark
               #EXIT DISPLAY   #MOD-BB0252 mark
                CONTINUE WHILE #MOD-BB0252

           #MOD-BB0252 mark --start--
           #ON ACTION select_cancel  #選擇或取消
           #    LET l_ac = ARR_CURR()
           #    IF l_tmp[l_ac].choice ='N' THEN
           #       LET l_tmp[l_ac].choice='Y'          #設定為選擇
           #       LET l_cnt = l_cnt + 1
           #    ELSE
           #       LET l_tmp[l_ac].choice='N'          #設定為取消
           #       LET l_cnt = l_cnt - 1
           #    END IF
           #     DISPLAY l_tmp[l_ac].choice TO choice #MOD-540149
           #MOD-BB0252 mark --end--
 
            ON ACTION exit                           #MOD-540149
              LET g_action_choice="exit"
             #EXIT DISPLAY #MOD-BB0252 mark
              EXIT INPUT   #MOD-BB0252
          
          
          #MOD-BB0252 mark --start-- 
          #ON ACTION accept
          #   LET g_action_choice="detail"
          #   LET l_ac = ARR_CURR()
          #   EXIT DISPLAY
          
          #ON ACTION cancel
          #   LET g_action_choice="exit"
          #   EXIT DISPLAY
          #MOD-BB0252 mark --end--
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
             #CONTINUE DISPLAY #MOD-BB0252 mark
              CONTINUE INPUT   #MOD-BB0252
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
       
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
 
        
       #END DISPLAY #MOD-BB0252 mark
        END INPUT   #MOD-BB0252
       #MOD-BB0252 mark --start--
       #CALL cl_set_act_visible("accept,cancel", TRUE)
       #IF l_exit='N' THEN
       #    CONTINUE WHILE
       #END IF
       #IF l_cnt != 1 THEN                                  #必須挑選一筆
       #   CALL cl_err('','apm-999',1) CONTINUE WHILE
       #ELSE
       #   EXIT WHILE
       #END IF
       #MOD-BB0252 mark --end--
         IF INT_FLAG THEN                                  #MOD-540149 移至此
          #LET INT_FLAG = 0 LET g_success='N' EXIT WHILE #MOD-BB0252 mark
           LET INT_FLAG = 0 LET g_success='N'            #MOD-BB0252
        END IF #使用者中斷
    CLOSE WINDOW p570_choice_w #MOD-BB0252 add
    EXIT WHILE                 #MOD-BB0252 add
 END WHILE
#MOD-BB0252 mark --start--
#SELECT SUM(rate) INTO s_rate FROM p570_tmp
#FOR l_ac=1 TO g_cnt
#    IF l_tmp[l_ac].choice='Y' THEN
#       LET l_tmp[l_ac].rate = s_rate
#       UPDATE p570_tmp SET rate=l_tmp[l_ac].rate,
#                           choice='Y'
#        WHERE supr=l_tmp[l_ac].supr 
#          AND curr=l_tmp[l_ac].curr
#       IF STATUS THEN
#          LET g_success='N'
#          CALL cl_err3("upd","p570_tmp",l_tmp[l_ac].supr,l_tmp[l_ac].curr,STATUS,"","upd p570_tmp:",1)  #No.FUN-660129
#          EXIT FOR    
#       END IF
#     END IF
#END FOR
#   CLOSE WINDOW p570_choice_w
#MOD-BB0252 mark --end--
END FUNCTION
   
FUNCTION  p570_purpeo(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_gen02         LIKE gen_file.gen02,  
    l_genacti       LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti 
      INTO l_gen02,l_genacti
      FROM gen_file 
     WHERE gen01 = tm.purpeo
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-017'
                                   LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_gen02  TO FORMONLY.gen02 
    END IF
END FUNCTION
 
#Query 查詢     
FUNCTION p570_q(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_pnn.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
 
    IF g_sma.sma120 = 'Y'  THEN                                                                                                      
       LET lg_smy62 = ''                                                                                                             
       LET lg_group = ''                                                                                                             
       CALL p570_refresh_detail()                                                                                                    
    END IF                                                                                                                           
 
    CALL p570_cs(p_cmd)
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN p570_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pml.* TO NULL
    ELSE
        OPEN p570_count
        FETCH p570_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL p570_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION p570_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,        #處理方式  #No.FUN-680136 VARCHAR(1)
    l_pmkuser       LIKE pmk_file.pmkuser,      #FUN-4C0056 add
    l_pmkgrup       LIKE pmk_file.pmkgrup,      #FUN-4C0056 add
    l_slip          LIKE pmh_file.pmh02         #No.FUN-680136 VARCHAR(10)  #TQC-650108 add
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p570_cs INTO g_pnn01,g_pnn02
        WHEN 'P' FETCH PREVIOUS p570_cs INTO g_pnn01,g_pnn02
        WHEN 'F' FETCH FIRST    p570_cs INTO g_pnn01,g_pnn02
        WHEN 'L' FETCH LAST     p570_cs INTO g_pnn01,g_pnn02
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
            FETCH ABSOLUTE g_jump p570_cs INTO g_pnn01,g_pnn02
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnn02,SQLCA.sqlcode,0)
        INITIALIZE g_pnn01 TO NULL  #TQC-6B0105
        INITIALIZE g_pnn02 TO NULL  #TQC-6B0105
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
    SELECT * INTO g_pml.* FROM pml_file WHERE pml01 = g_pnn01
                                          AND pml02 = g_pnn02 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pml_file",g_pnn01,g_pnn02,SQLCA.sqlcode,"","",0)  #No.FUN-660129
       INITIALIZE g_pml.* TO NULL
       RETURN
    ELSE 
       SELECT pmkuser,pmkgrup INTO l_pmkuser,l_pmkgrup FROM pmk_file  #FUN-4C0056 add
        WHERE pmk01 = g_pnn01
       LET g_data_owner = l_pmkuser      #FUN-4C0056 add
       LET g_data_group = l_pmkgrup      #FUN-4C0056 add
       IF NOT cl_null(g_pnn01) THEN
          LET g_t1=s_get_doc_no(g_pnn01)
          IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN                                                                 
             #讀取smy_file中指定作業對應的默認屬性群組                                                                            
             SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1                                                        
             #刷新界面顯示                                                                                                        
             CALL p570_refresh_detail()                                                                                           
          ELSE                                                                                                                    
             LET lg_smy62 = ''                                                                                                    
          END IF          
       END IF
       #在使用Q查詢的情況下得到當前對應的屬性組smy62
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                                
          LET l_slip = g_pml.pml01[1,g_doc_len]                                                                                         
          SELECT smy62 INTO lg_smy62 FROM smy_file                                                                                      
             WHERE smyslip = l_slip                                                                                                     
       END IF                            
       CALL p570_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p570_show()
  DEFINE l_ima43   LIKE ima_file.ima43,
         l_ima45   LIKE ima_file.ima45,
         l_ima46   LIKE ima_file.ima46,
         l_ima021  LIKE ima_file.ima021,
         l_gen02   LIKE gen_file.gen02,
         l_diff    LIKE pml_file.pml20
   DEFINE l_pmlislk01 LIKE pmli_file.pmlislk01  #No.FUN-810017
    LET g_pml_t.* = g_pml.*                #保存單頭舊值
    DISPLAY BY NAME g_pml.pml01, g_pml.pml02, g_pml.pml42, g_pml.pml04,
                    g_pml.pml08, g_pml.pml041, g_pml.pml20, g_pml.pml21,
                    g_pml.pml07, g_pml.pml919                        #FUN-A80150 add pml919     
    SELECT pmk02 INTO tm.pmk02 FROM pmk_file WHERE pmk01 = g_pml.pml01
    CALL s_prtype(tm.pmk02) RETURNING tm.desc
    DISPLAY tm.pmk02 TO FORMONLY.pmk02
    DISPLAY tm.desc  TO FORMONLY.desc
    LET l_diff  = g_pml.pml20 - g_pml.pml21
    DISPLAY l_diff  TO FORMONLY.diff   
    SELECT ima46,ima45,ima021
      INTO l_ima46,l_ima45,l_ima021
      FROM ima_file
     WHERE ima01 = g_pml.pml04
    DISPLAY l_ima46 TO FORMONLY.ima46  
    DISPLAY l_ima45 TO FORMONLY.ima45  
    DISPLAY l_ima021 TO FORMONLY.ima021  
    SELECT unique pnn15 INTO g_pnn15 
                        FROM pnn_file WHERE pnn01 = g_pml.pml01
                                        AND pnn02 = g_pml.pml02
    IF g_pnn15 IS NOT NULL AND g_pnn15 != ' ' 
    THEN SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_pnn15
    END IF
    DISPLAY g_pnn15 TO FORMONLY.ima43   
    DISPLAY l_gen02 TO FORMONLY.gen02   
    IF g_azw.azw04 <>'2' THEN
       SELECT pmlislk01 INTO l_pmlislk01 FROM pmli_file
        WHERE pmli01=g_pml.pml01
          AND pmli02=g_pml.pml02
       DISPLAY l_pmlislk01 TO FORMONLY.pmlislk01
    END IF
    CALL p570_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION p570_b()
DEFINE
    l_str           LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(80)
    l_direct        LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01) 
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680136 SMALLINT
    l_i             LIKE type_file.num5,     #No.FUN-550089  #No.FUN-680136 SMALLINT
    l_modify_flag   LIKE type_file.chr1,     #單身更改否  #No.FUN-680136 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)   #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_insert        LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01) #可新增否
    l_update,l_a    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01) #可更改否 (含取消)
    l_jump          LIKE type_file.num5,     #No.FUN-680136 SMALLINT #判斷是否跳過AFTER ROW的處理
    t_pnn10         LIKE pnn_file.pnn10,
    t_pnn10t        LIKE pnn_file.pnn10t,    #No.FUN-610018
    l_flag          LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    l_b2            LIKE ima_file.ima31,
    l_ima130        LIKE ima_file.ima130,                                                                                 
    l_ima131        LIKE ima_file.ima131,                                                                                 
    l_ima25         LIKE ima_file.ima25,                                                                                  
    l_imaag         LIKE ima_file.imaag,
    l_imaacti       LIKE ima_file.imaacti,
    l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否  #No.FUN-680136 SMALLINT
DEFINE  l_ima53     LIKE ima_file.ima53      #MOD-640515
 
   DEFINE   li_i         LIKE type_file.num5     #No.FUN-680136 SMALLINT                                                                                                   
   DEFINE   l_count      LIKE type_file.num5     #No.FUN-680136 SMALLINT                                                                                                   
   DEFINE   l_temp       LIKE ima_file.ima01                                                                                       
   DEFINE   l_check_res  LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE   li_result    LIKE type_file.num5     #No.CHI-690066 add  SMALLINT
   DEFINE   l_ima915     LIKE ima_file.ima915    #FUN-710060 add
   DEFINE   l_pnn10      LIKE pnn_file.pnn10,    #No.CHI-820014
            l_pnn10t     LIKE pnn_file.pnn10t    #No.CHI-820014
   DEFINE   l_pnni       RECORD LIKE pnni_file.* #No.FUN-7B0018
   DEFINE   l_pmk        RECORD LIKE pmk_file.*   #No.FUN-930148
   DEFINE   l_pnn09      LIKE pnn_file.pnn09     #CHI-B60077 add
   
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_pml.pml01) THEN RETURN END IF
 
    CALL cl_opmsg('b')
    IF cl_null(g_pnn_t.pnn05) THEN LET g_pnn_t.pnn05=' ' END IF
 
     LET g_forupd_sql = "SELECT pnn13,pnn03,'','','','','','','','','','','','',",
                        " '','','','','','','','','',' ',' ',pnn05,' ',pnn07,pnn08,pnn09,",
                       "       pnn33,pnn34,pnn35,pnn30,pnn31,pnn32,pnn36,pnn37,",#FUN-560063
                             " pnn18,pnn19,pnn10,pnn10t,pnn12,pnn11,pnn919,pnn06,pnn16,", #No.FUN-550089   #FUN-A80150 add pnn919  
                             " ' ',0 ",        #No.FUN-550089 FUN-610018
                        " FROM pnn_file ",
                       "  WHERE pnn01 = ? AND pnn02 = ? ", 
                         " AND pnn03 = ? AND pnn05 = ? ",  
                         " AND pnn06 = ? ",
                         " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p570_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pnn WITHOUT DEFAULTS FROM s_pnn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL p570_set_entry_b()
            CALL p570_set_no_entry_b()
            SELECT pml21 INTO g_pml.pml21 FROM pml_file 
              WHERE pml01 = g_pml.pml01
                AND pml02 = g_pml.pml02
            DISPLAY g_pml.pml21 TO pml21
            LET g_confirm = '0'   #CHI-B60077 add
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pnn_t.* = g_pnn[l_ac].*  #BACKUP
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_pnn[l_ac].pnn03)
                       RETURNING g_flag,g_ima906,g_ima907
 
                  CALL s_chk_va_setting1(g_pnn[l_ac].pnn03)
                       RETURNING g_flag,g_ima908
                  CALL p570_set_entry_b()
                  CALL p570_set_no_entry_b()
                  CALL p570_set_no_required()
                  CALL p570_set_required()
               END IF 
              #TQC-B80055 mod
              #CALL p570_price_check(g_pnn_t.pnn05,g_pnn_t.pnn10,g_pnn_t.pnn10t)  #FUN-B70121 add
               SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01 
               LET g_term = l_pmk.pmk41
               IF cl_null(g_term) THEN
                 SELECT pmc49 INTO g_term
                   FROM pmc_file
                  WHERE pmc01 = g_pnn_t.pnn05
               END IF
               CALL p570_price_check(g_pnn_t.pnn05,g_pnn_t.pnn10,g_pnn_t.pnn10t,g_term)  #FUN-B70121 add
              #TQC-B80055 mod--end
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pnn[l_ac].* TO NULL      #900423
            INITIALIZE arr_detail[l_ac].* TO NULL #TQC-650108 ADD
            IF l_ac > 1 THEN 
               LET g_pnn[l_ac].pnn11 = g_pnn[l_ac-1].pnn11
            END IF
            LET g_pnn[l_ac].pnn08 = 1   #No.+221 add
            LET g_pnn_t.* = g_pnn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
               IF cl_null(g_pnn[l_ac].pnn19) THEN 
                  CALL g_pnn.deleteElement(l_ac)   #取消 Array Element
                  NEXT FIELD pnn18 
                  CANCEL INSERT
               END IF
            END IF
            IF g_sma.sma115 = 'Y' THEN
               
               CALL s_chk_va_setting(g_pnn[l_ac].pnn03)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD pnn03
               END IF
 
               CALL s_chk_va_setting1(g_pnn[l_ac].pnn03)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD pnn03
               END IF
                           
               CALL p570_du_data_to_correct()
               
               #計算pnn09的值,檢查數量的合理性
               CALL p570_set_origin_field()
               CALL p570_check_inventory_qty()  
                   RETURNING g_flag
               IF g_flag = '1' THEN
                  IF g_ima906 = '3' OR g_ima906 = '2' THEN  
                     NEXT FIELD pnn35
                  ELSE
                     NEXT FIELD pnn32
                  END IF
               END IF
            END IF
            LET g_pnn38  = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
            LET g_pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
            INSERT INTO pnn_file(pnn01, pnn02, pnn03, pnn05, pnn06,
                                 pnn07, pnn08, pnn09, pnn10, pnn11, pnn919,   #FUN-A80150 add pnn919
                                 pnn12, pnn13, pnn14, pnn15, pnn16, pnn17,   #MOD-880151   增加pnn17
                                 pnn18, pnn19, pnn20, pnn10t,   #No.FUN-550089
                                 pnn30, pnn31, pnn32, pnn33, pnn34,
                                 pnn35, pnn36, pnn37, pnn38, pnn38t,pnnplant,pnnlegal)  #FUN-980006 add pnnplant,pnnlegal 
                          VALUES(g_pml.pml01,g_pml.pml02,
                                 g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,
                                 g_pnn[l_ac].pnn06,g_pnn[l_ac].pnn07,
                                 g_pnn[l_ac].pnn08,g_pnn[l_ac].pnn09,
                                 g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn11, g_pnn[l_ac].pnn919,   #FUN-A80150 add pnn919
                                 g_pnn[l_ac].pnn12,g_pnn[l_ac].pnn13,
                                 g_pnn[l_ac].pnn03,g_pnn15,'Y',g_pnn17,   #MOD-880151   增加pnn17
                                 g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,
                                 g_pnn20,g_pnn[l_ac].pnn10t,     #No.FUN-550089
                                 g_pnn[l_ac].pnn30,g_pnn[l_ac].pnn31,
                                 g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn33,
                                 g_pnn[l_ac].pnn34,g_pnn[l_ac].pnn35,
                                 g_pnn[l_ac].pnn36,g_pnn[l_ac].pnn37,
                                 g_pnn38,g_pnn38t,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pnn_file",g_pml.pml01,g_pml.pml02,SQLCA.sqlcode,"","",0)  #No.FUN-660129
               CANCEL INSERT
            ELSE
               INITIALIZE l_pnni.* TO NULL
               LET l_pnni.pnni01 = g_pml.pml01
               LET l_pnni.pnni02 = g_pml.pml02
               LET l_pnni.pnni03 = g_pnn[l_ac].pnn03
               LET l_pnni.pnni05 = g_pnn[l_ac].pnn05
               LET l_pnni.pnni06 = g_pnn[l_ac].pnn06
               IF NOT s_ins_pnni(l_pnni.*,'') THEN
                  CANCEL INSERT
               END IF
           END IF
 
        AFTER FIELD pnn13  #料件編號
            IF NOT cl_null(g_pnn[l_ac].pnn13) THEN  
               IF g_pnn[l_ac].pnn13 NOT MATCHES '[10S]' THEN
                  NEXT FIELD pnn13
               END IF
            END IF
 
        AFTER FIELD pnn03   #料件編號
     
         CALL p570_check_pnn03('pnn03',l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti    
         IF NOT l_check_res THEN NEXT FIELD pnn03 END IF  
         SELECT imaag INTO l_imaag FROM ima_file
          WHERE ima01=g_pnn[l_ac].pnn03
         IF (NOT cl_null(l_imaag)) AND (l_imaag!='@CHILD') THEN 
            CALL cl_err(l_imaag,"aim1004",1)
            NEXT FIELD pnn03
         END IF
         #FUN-910088--add--start--
         LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)
         LET g_pnn[l_ac].pnn32 = s_digqty(g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn30)
         LET g_pnn[l_ac].pnn35 = s_digqty(g_pnn[l_ac].pnn35,g_pnn[l_ac].pnn33)
         LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)  
         DISPLAY BY NAME g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn35,g_pnn[l_ac].pnn37
         #FUN-910088--add--end--

 
      BEFORE FIELD att00                                                                                                            
        #下面是十個輸入型屬性欄位的判斷語句         
      AFTER FIELD att00
          #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件 
          SELECT COUNT(ima01) INTO l_count FROM ima_file 
            WHERE ima01 = g_pnn[l_ac].att00 AND imaag = lg_smy62
          IF l_count = 0 THEN
             CALL cl_err_msg('','aim-909',lg_smy62,0)
             NEXT FIELD att00          
          END IF
 
          IF p_cmd='u' THEN
             CALL  cl_set_comp_entry("att01,att01_c,att02,att02_c,att03,att03_c,                                    att04,att04_c,att05,att05_c,att06,att06_c,                                    att07,att07_c,att08,att08_c,att09,att09_c,att10,att10_c",TRUE)
            
 
          END IF
          #如果設置為不允許新增
      
      AFTER FIELD att01
          CALL p570_check_att0x(g_pnn[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01 END IF              
      AFTER FIELD att02
          CALL p570_check_att0x(g_pnn[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02 END IF
      AFTER FIELD att03
          CALL p570_check_att0x(g_pnn[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03 END IF
      AFTER FIELD att04
          CALL p570_check_att0x(g_pnn[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04 END IF
      AFTER FIELD att05
          CALL p570_check_att0x(g_pnn[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05 END IF          
      AFTER FIELD att06
          CALL p570_check_att0x(g_pnn[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06 END IF
      AFTER FIELD att07
          CALL p570_check_att0x(g_pnn[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07 END IF
      AFTER FIELD att08
          CALL p570_check_att0x(g_pnn[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08 END IF
      AFTER FIELD att09
          CALL p570_check_att0x(g_pnn[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09 END IF
      AFTER FIELD att10                                                                                                             
          CALL p570_check_att0x(g_pnn[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090                                                               
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att10 END IF
      #下面是十個輸入型屬性欄位的判斷語句 
      AFTER FIELD att01_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att01_c,1,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF                                                                         
      AFTER FIELD att02_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090                                                            
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF                                                                         
      AFTER FIELD att03_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att03_c,3,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF                                                                         
      AFTER FIELD att04_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att04_c,4,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF                                                                         
      AFTER FIELD att05_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att05_c,5,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF
      AFTER FIELD att06_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att06_c,6,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF                                                                         
      AFTER FIELD att07_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att07_c,7,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF                                                                         
      AFTER FIELD att08_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att08_c,8,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF                                                                         
      AFTER FIELD att09_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att09_c,9,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                           
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF                                                                         
      AFTER FIELD att10_c                                                                                                           
          CALL p570_check_att0x_c(g_pnn[l_ac].att10_c,10,l_ac,p_cmd) RETURNING  #No.MOD-660090                                                          
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
          IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
        BEFORE FIELD pnn05   
            CALL p570_set_entry_b()
            #FUN-B70121 add
            IF p_cmd='u' THEN
              #TQC-B80055 mod
              #CALL p570_price_check(g_pnn_t.pnn05,g_pnn_t.pnn10,g_pnn_t.pnn10t)
               SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01 
               LET g_term = l_pmk.pmk41
               IF cl_null(g_term) THEN
                 SELECT pmc49 INTO g_term
                   FROM pmc_file
                  WHERE pmc01 = g_pnn_t.pnn05
               END IF
               CALL p570_price_check(g_pnn_t.pnn05,g_pnn_t.pnn10,g_pnn_t.pnn10t,g_term)
              #TQC-B80055 mod
            END IF
            #FUN-B70121 add--end
 
        AFTER FIELD pnn05   #廠商編號
            IF NOT cl_null(g_pnn[l_ac].pnn05) THEN
               CALL p570_pnn05_1() #check pmc01
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_pnn[l_ac].pnn05=g_pnn_t.pnn05
                  NEXT FIELD pnn05
               END IF
 
               IF g_pnn[l_ac].pnn03[1,4] <> 'MISC' THEN
                   CALL p570_pnn05(p_cmd)   
                   SELECT ima915 INTO l_ima915 FROM ima_file         #FUN-710060 mod
                    WHERE ima01=g_pnn[l_ac].pnn03                    #FUN-710060 mod
                   IF NOT cl_null(g_errno) AND (l_ima915='2' OR l_ima915='3') THEN  #FUN-710060 mod  #MOD-780097 modify add sma63='1'   #MOD-880211
                       CALL cl_err('',g_errno,0)
                       LET g_pnn[l_ac].pnn05=g_pnn_t.pnn05
                       NEXT FIELD pnn05 #MOD-580302 MARK掉   #MOD-780097 cancel mark
                   END IF
                   IF l_ima915='2' OR l_ima915='3' THEN              #FUN-710060 mod
 
                       LET g_cnt = 0                    #No:8203
                       SELECT COUNT(*) INTO g_cnt FROM pmh_file
                        WHERE pmh01 = g_pnn[l_ac].pnn03 #料件編號 #No:8203
                          AND pmh02 = g_pnn[l_ac].pnn05 #供應廠商編號
                          AND pmh13 = g_pnn[l_ac].pnn06 #採購幣別
                          AND pmh05 = '0'# 已核准
                          AND pmh21 = " "                                             #CHI-860042                                   
                          AND pmh22 = '1'                                             #CHI-860042
                          AND pmh23 = ' '                                             #CHI-960033
                          AND pmhacti = 'Y'                                           #CHI-910021
                       IF g_cnt <= 0 THEN
                           LET g_char = NULL
                           LET g_char= "(",g_pnn[l_ac].pnn03 CLIPPED,'+',g_pnn[l_ac].pnn05 CLIPPED,")"
                           LET g_char = g_char CLIPPED
                           #此料件+供應商資料(pmh_file)尚未核准,請查核...!
                           CALL cl_err(g_char,'mfg3043',1)
                           NEXT FIELD pnn05
                       END IF
                   END IF
               END IF
            END IF
            CALL p570_set_no_entry_b()      #No.FUN-550089

       #MOD-D10042 add start -----
        AFTER FIELD pnn06   #幣別
           IF NOT cl_null(g_pnn[l_ac].pnn06) THEN
              SELECT COUNT(*) INTO g_cnt FROM azi_file
               WHERE azi01 = g_pnn[l_ac].pnn06 AND aziacti = 'Y'
              IF g_cnt = 0 THEN
                 CALL cl_err("","mfg3008",1)
                 NEXT FIELD pnn06
              END IF
           END IF
       #MOD-D10042 add end   -----
 
        AFTER FIELD pnn08   #替代率   
            IF NOT cl_null(g_pnn[l_ac].pnn08) THEN 
               IF g_pnn[l_ac].pnn08 < 1 THEN
                  LET g_pnn[l_ac].pnn08 = g_pnn_t.pnn08 
                  NEXT FIELD pnn08
               END IF 
            END IF 
 
        AFTER FIELD pnn09   #原分配量 
           IF NOT cl_null(g_pnn[l_ac].pnn09) THEN 
              LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)  #FUN-910088--add--
              DISPLAY BY NAME g_pnn[l_ac].pnn09                                      #FUN-910088--add-- 
              IF g_pnn[l_ac].pnn09 < 0 THEN   #MOD-940133
                 LET g_pnn[l_ac].pnn09 = g_pnn_t.pnn09 
                 NEXT FIELD pnn09
              END IF 
#CHI-B60077 -- begin --
             #CALL s_sizechk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn09,g_lang) #CHI-C10037 mark
              CALL s_sizechk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn09,g_lang,g_pnn[l_ac].pnn12) #CHI-C10037 add
                 RETURNING g_pnn[l_ac].pnn09
              DISPLAY g_pnn[l_ac].pnn09 TO pnn09
              LET g_confirm = '0'
#CHI-B60077 -- end --
              #MOD-B30399 add --start--
              IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
                 IF p570_available_qty('2') THEN  
                    NEXT FIELD pnn09
                 END IF
              END IF
              #MOD-B30399 add --end--
              IF g_pnn[l_ac].pnn37 = 0 OR 
                    (g_pnn_t.pnn09 <> g_pnn[l_ac].pnn09 OR 
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN                                               
                 CALL p570_set_pnn37()
              END IF
              IF cl_null(g_pnn[l_ac].pnn37) THEN                                                                                   
                 CALL p570_set_pnn37()                                                                                             
              END IF                                                                                                               

              IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN #No.FUN-550089
                IF g_chr = 'Y' THEN LET g_errno = '' END IF   #MOD-9B0162
                #SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
                 SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01  #TQC-B80055 mod
                 LET g_term = l_pmk.pmk41 
                 IF cl_null(g_term) THEN 
                   SELECT pmc49 INTO g_term
                     FROM pmc_file 
                    WHERE pmc01 = g_pnn[l_ac].pnn05
                 END IF 
                 LET g_price = l_pmk.pmk20
                 IF cl_null(g_price) THEN 
                   SELECT pmc17 INTO g_price
                     FROM pmc_file 
                    WHERE pmc01 = g_pnn[l_ac].pnn05
                 END IF   
                 SELECT pmc47 INTO g_pmm.pmm21
                  FROM pmc_file
                  WHERE pmc01 =g_pnn[l_ac].pnn05  
                 SELECT gec04 INTO g_pmm.pmm43
                   FROM gec_file
                  WHERE gec01 = g_pmm.pmm21                   
                    AND gec011 = '1'  #進項 TQC-B70212 add
                 CALL s_defprice_new(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,
                                 g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                                 g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant) 
                    RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                              g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
                #CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t)    #MOD-9C0285 ADD
                 CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term)    #MOD-9C0285 ADD  #TQC-B80055 mod
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                  END IF
                 IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
                 LET t_pnn10 = g_pnn[l_ac].pnn10
                 LET t_pnn10t= g_pnn[l_ac].pnn10t   #No.FUN-610018
                 IF NOT cl_null(g_pnn[l_ac].pnn18) AND 
                    NOT cl_null(g_pnn[l_ac].pnn19) THEN
                    SELECT * INTO g_pon.* FROM pon_file 
                     WHERE pon01 = g_pnn[l_ac].pnn18
                       AND pon02 = g_pnn[l_ac].pnn19
                    CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t) 
                         RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
                 END IF
                 CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10  #No.CHI-6A0004
                 CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
                 CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
              END IF      
           END IF 
        
        AFTER FIELD pnn34  #第二轉換率
           IF NOT cl_null(g_pnn[l_ac].pnn34) THEN
              IF g_pnn[l_ac].pnn34=0 THEN
                 NEXT FIELD pnn34
              END IF                                
           END IF
 
        AFTER FIELD pnn35  #第二數量
          IF NOT cl_null(g_pnn[l_ac].pnn35) THEN
             LET g_pnn[l_ac].pnn35 = s_digqty(g_pnn[l_ac].pnn35,g_pnn[l_ac].pnn33)  #FUN-910088--add--
             DISPLAY BY NAME g_pnn[l_ac].pnn35                                      #FUN-910088--add--
             IF g_pnn[l_ac].pnn35 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD pnn35
             END IF
             IF p_cmd = 'a' OR  p_cmd = 'u' AND 
                g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 THEN                                               
                IF g_ima906='3' THEN
                   LET g_tot=g_pnn[l_ac].pnn35*g_pnn[l_ac].pnn34
                   IF cl_null(g_pnn[l_ac].pnn32) OR g_pnn[l_ac].pnn32=0 THEN #CHI-960022
                      LET g_pnn[l_ac].pnn32=g_tot*g_pnn[l_ac].pnn31
                      LET g_pnn[l_ac].pnn32 = s_digqty(g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn30)   #FUN-910088--add--
                      DISPLAY BY NAME g_pnn[l_ac].pnn32                      #CHI-960022
                   END IF                                                    #CHI-960022
                END IF
             END IF                                 
          END IF
          IF g_pnn[l_ac].pnn37 = 0 OR 
                (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR 
                 g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                 g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                 g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                 g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN                                               
             CALL p570_set_pnn37()
          END IF
          CALL cl_show_fld_cont()
           
        AFTER FIELD pnn31  #第一轉換率
           IF NOT cl_null(g_pnn[l_ac].pnn31) THEN
              IF g_pnn[l_ac].pnn31=0 THEN
                 NEXT FIELD pnn31
              END IF                                
           END IF
 
        AFTER FIELD pnn32  #第一數量
          IF NOT cl_null(g_pnn[l_ac].pnn32) THEN
             LET g_pnn[l_ac].pnn32 = s_digqty(g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn30)  #FUN-910088--add--
             DISPLAY BY NAME g_pnn[l_ac].pnn32                                      #FUN-910088--add--
             IF g_pnn[l_ac].pnn32 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD pnn32
             END IF                               
          END IF
          #計算pmn20,pmn07的值,檢查數量的合理性
           CALL p570_set_origin_field()
           CALL p570_check_inventory_qty()  
               RETURNING g_flag
           IF g_flag = '1' THEN
              IF g_ima906 = '3' OR g_ima906 = '2' THEN  
                 NEXT FIELD pnn35
              ELSE
                 NEXT FIELD pnn32
              END IF
           END IF
           IF g_pnn[l_ac].pnn37 = 0 OR (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR 
                  g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                  g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                  g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                  g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN                                               
              CALL p570_set_pnn37()
           END IF
           CALL cl_show_fld_cont()
                       
        BEFORE FIELD pnn37
           IF g_sma.sma115 ='Y' THEN
              CALL p570_set_no_required()
              CALL p570_set_required()
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF g_pnn[l_ac].pnn37 = 0 OR 
                    (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR 
                     g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                     g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                     g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN                                               
                 CALL p570_set_pnn37()
              END IF
           ELSE
              IF g_pnn[l_ac].pnn37 = 0 OR 
                    (g_pnn_t.pnn09 <> g_pnn[l_ac].pnn09 OR 
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN                                               
                 CALL p570_set_pnn37()
              END IF
           END IF
 
        AFTER FIELD pnn37 
          IF NOT cl_null(g_pnn[l_ac].pnn37) THEN
             LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)  #FUN-910088--add--
             DISPLAY BY NAME g_pnn[l_ac].pnn37                                      #FUN-910088--add--
             IF g_pnn[l_ac].pnn37 < 0 THEN
                CALL cl_err('','aim-391',0)  #
                NEXT FIELD pnn37
             END IF                                
          END IF
          IF g_pnn[l_ac].pnn37 != g_pnn_t.pnn37 THEN 
           SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
           LET g_term = l_pmk.pmk41 
           IF cl_null(g_term) THEN 
             SELECT pmc49 INTO g_term
              FROM pmc_file 
              WHERE pmc01 =g_pnn[l_ac].pnn05
           END IF 
           LET g_price = l_pmk.pmk20
           IF cl_null(g_price) THEN 
              SELECT pmc17 INTO g_price
               FROM pmc_file 
              WHERE pmc01 =g_pnn[l_ac].pnn05
           END IF  
           SELECT pmc47 INTO g_pmm.pmm21
             FROM pmc_file
           WHERE pmc01 =g_pnn[l_ac].pnn05  
           SELECT gec04 INTO g_pmm.pmm43
             FROM gec_file
            WHERE gec01 = g_pmm.pmm21  
              AND gec011 = '1'  #進項 TQC-B70212 add
           CALL s_defprice_new(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_today,
                               g_pnn[l_ac].pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",
                               g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
                  RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                            g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
          #CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t)    #MOD-9C0285 ADD
           CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term)    #MOD-9C0285 ADD  #TQC-B80055 mod
           IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
           END IF        
 
        AFTER FIELD pnn10   #採購單價  
            IF NOT cl_null(g_pnn[l_ac].pnn10) THEN 
               IF g_pnn[l_ac].pnn10 < 0 THEN #MOD-5B0165
                  CALL cl_err(g_pnn[l_ac].pnn10,'mfg1322',0) #MOD-5B0165 add
                  LET g_pnn[l_ac].pnn10 = g_pnn_t.pnn10 
                  NEXT FIELD pnn10
               END IF
               #參數設定單價不可為零
               #FUN-C40089---begin
               SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[l_ac].pnn05
               IF cl_null(g_pnz08) THEN 
                  LET g_pnz08 = 'Y'
               END IF 
               IF g_pnz08 = 'N' THEN 
               #IF g_sma.sma112= 'N' THEN 
               #FUN-C40089---end
                  IF g_pnn[l_ac].pnn10 <= 0 THEN
                     LET g_pnn[l_ac].pnn10 = g_pnn_t.pnn10
                     CALL cl_err('','axm-627',1)  #FUN-C50076
                     NEXT FIELD pnn10
                  END IF
               END IF
                SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
                LET g_term = l_pmk.pmk41 
                IF cl_null(g_term) THEN 
                  SELECT pmc49 INTO g_term
                    FROM pmc_file 
                   WHERE pmc01 =g_pnn[l_ac].pnn05
                END IF 
                LET g_price = l_pmk.pmk20
                IF cl_null(g_price) THEN 
                  SELECT pmc17 INTO g_price
                    FROM pmc_file 
                   WHERE pmc01 =g_pnn[l_ac].pnn05
                END IF  
                SELECT pmc47 INTO g_pmm.pmm21
                   FROM pmc_file
                   WHERE pmc01 =g_pnn[l_ac].pnn05  
                SELECT gec04 INTO g_pmm.pmm43
                  FROM gec_file
                 WHERE gec01 = g_pmm.pmm21     
                   AND gec011 = '1'  #進項 TQC-B70212 add
                CALL s_defprice_new(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_today,
                                g_pnn[l_ac].pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",
                                g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
                   RETURNING l_pnn10,l_pnn10t,
                             g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add                           
               #CALL p570_price_check(g_pnn[l_ac].pnn05,l_pnn10,l_pnn10t)     #MOD-9C0285  ADD
                CALL p570_price_check(g_pnn[l_ac].pnn05,l_pnn10,l_pnn10t,g_term)     #MOD-9C0285  ADD  #TQC-B80055 mod
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                 END IF
                 IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
               #----- check採購單價超過最近採購單價% 96-06-25
               IF g_sma.sma84 != 99.99 AND g_pnn[l_ac].pnn03[1,4] <>'MISC' THEN   #CHI-820014
                  IF l_pnn10 != 0 THEN
                     IF g_pnn[l_ac].pnn10 > l_pnn10*(1+g_sma.sma84/100) THEN
                        IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                           CALL cl_err(g_pnn[l_ac].pnn03,'apm-240',1) #No:8752  
                           NEXT FIELD pnn10
                        ELSE
                           CALL cl_err('','apm-240',1)
                        END IF
                     END IF
                  ELSE 
                  SELECT ima53 INTO l_ima53 FROM ima_file
                   WHERE ima01=g_pnn[l_ac].pnn03    #CHI-820014
                  IF l_ima53 != 0 THEN  #有單價才能比較 No:8752
                     IF g_pnn[l_ac].pnn10*g_pmm.pmm42 > l_ima53*(1+g_sma.sma84/100) #No.8618
                     THEN
                        IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                            CALL cl_err(g_pmn.pmn04,'apm-240',0) #No:8752
                            NEXT FIELD pnn10
                        ELSE
                            CALL cl_err('','apm-240',0)
                        END IF
                     END IF
                  END IF
                  END IF  #CHI-820014 add
               END IF
 
               CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10  #No.CHI-6A0004
               LET g_pnn[l_ac].pnn10t =
                   g_pnn[l_ac].pnn10 * ( 1 + g_pnn[l_ac].gec04 /100)    
               CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
            END IF 
 
        AFTER FIELD pnn10t   #含稅單價
            IF NOT cl_null(g_pnn[l_ac].pnn10t) THEN
               #參數設定單價不可為零
               #FUN-C40089---begin
               SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[l_ac].pnn05
               IF cl_null(g_pnz08) THEN 
                  LET g_pnz08 = 'Y'
               END IF 
               IF g_pnz08 = 'N' THEN 
               #IF g_sma.sma112= 'N' THEN 
               #FUN-C40089---end
                  IF g_pnn[l_ac].pnn10t <= 0 THEN
                     LET g_pnn[l_ac].pnn10t = g_pnn_t.pnn10t
                     CALL cl_err('','axm-627',1)  #FUN-C50076
                     NEXT FIELD pnn10t
                  END IF
               END IF
               CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t   #No.CHI-6A0004
               LET g_pnn[l_ac].pnn10 =
                   g_pnn[l_ac].pnn10t / ( 1 + g_pnn[l_ac].gec04 / 100)
               CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10     #No.CHI-6A0004
            END IF
 
        AFTER FIELD pnn18   #Blanket P/O單號
            IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
               CALL p570_pnn18()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_pnn[l_ac].pnn18,g_errno,0)
                  NEXT FIELD pnn18
               END IF
               IF g_pnn[l_ac].pnn05 != g_pom.pom09 THEN    #廠商編號不合
                   CALL cl_err(g_pnn[l_ac].pnn05,'apm-903',0)   #No.MOD-4A0356
                  NEXT FIELD pnn18
               END IF
            END IF
 
        AFTER FIELD pnn19   #Blanket 項次
            IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
               IF cl_null(g_pnn[l_ac].pnn19) THEN 
                  NEXT FIELD pnn18 
               END IF
            END IF
            IF NOT cl_null(g_pnn[l_ac].pnn19) THEN
               IF ((g_pnn[l_ac].pnn19 != g_pnn_t.pnn19 OR g_pnn_t.pnn19 IS NULL)
               OR (g_pnn[l_ac].pnn18 != g_pnn_t.pnn18 OR g_pnn_t.pnn18 IS NULL)) THEN
                  SELECT * INTO g_pon.* FROM pon_file 
                   WHERE pon01 = g_pnn[l_ac].pnn18
                     AND pon02 = g_pnn[l_ac].pnn19
                  IF STATUS THEN
                      CALL cl_err3("sel","pon_file",g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,"apm-902","","",0)  #No.FUN-660129
                     NEXT FIELD pnn18
                  END IF
                  #NO.FUN-A80001--begin
                  IF tm3.purdate > g_pon.pon19 THEN
                     CALL cl_err('','apm-815',1)
                     NEXT FIELD pnn19
                  END IF
                  #NO.FUN-A80001--end
                  #Blanket P/O 之單位轉換因子
                  CALL s_umfchk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn12,
                                g_pon.pon07)
                            RETURNING l_flag,g_pnn20
                  IF l_flag THEN 
                     CALL cl_err('','abm-731',1) 
                     NEXT FIELD pnn18
                  END IF
                  #輸入之數量不合大於Blanket P/O 之
                  #申請數量-已轉數量(pon20-pon21)
                  IF g_pnn[l_ac].pnn09 > g_pon.pon20 - g_pon.pon21 THEN
                      CALL cl_err('','apm-905',0)   #No.MOD-4A0356
                     NEXT FIELD pnn18
                  END IF
                  CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t) 
                       RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
                  CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10  #No.CHI-6A0004
                  CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t   #No.CHI-6A0004
                  CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
               END IF
             END IF
 
        AFTER FIELD pnn11
           LET li_result = 0
           CALL s_daywk(g_pnn[l_ac].pnn11) RETURNING li_result
 
           IF li_result = 0 THEN      #0:非工作日
              CALL cl_err(g_pnn[l_ac].pnn11,'mfg3152',1)
           END IF 
           IF li_result = 2 THEN      #2:無設定資料
              CALL cl_err(g_pnn[l_ac].pnn11,'mfg3153',1)
           END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_pnn_t.pnn13) AND
               g_pnn_t.pnn13 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
                DELETE FROM pnn_file
                 WHERE pnn01 = g_pml.pml01   AND
                       pnn02 = g_pml.pml02   AND
                       pnn03 = g_pnn_t.pnn03 AND
                       pnn05 = g_pnn_t.pnn05 AND
                       pnn06 = g_pnn_t.pnn06
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pnn_file",g_pnn_t.pnn03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE    #No.FUN-830132
                   IF NOT s_del_pnni(g_pml.pml01,g_pml.pml02,g_pnn_t.pnn03,
                                     g_pnn_t.pnn05,g_pnn_t.pnn06,'') THEN              
                      ROLLBACK WORK
                      CANCEL DELETE 
                   END IF                                                       
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pnn[l_ac].* = g_pnn_t.*
               CLOSE p570_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pnn[l_ac].pnn13,-263,1)
               LET g_pnn[l_ac].* = g_pnn_t.*
            ELSE
               IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
                  IF cl_null(g_pnn[l_ac].pnn19) THEN 
                     NEXT FIELD pnn18 
                  END IF
               END IF 
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_pnn[l_ac].pnn03) THEN
                      SELECT ima25,ima31 INTO g_ima25,g_ima31 
                        FROM ima_file WHERE ima01=g_pnn[l_ac].pnn03
                   END IF
 
                   CALL s_chk_va_setting(g_pnn[l_ac].pnn03)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pnn03
                   END IF
                   CALL s_chk_va_setting1(g_pnn[l_ac].pnn03)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pnn03
                   END IF
            
                   CALL p570_du_data_to_correct()
             
                   #計算pnn09的值,檢查數量的合理性
                   CALL p570_set_origin_field()
                   CALL p570_check_inventory_qty()  
                       RETURNING g_flag
                   IF g_flag = '1' THEN
                      IF g_ima906 = '3' OR g_ima906 = '2' THEN  
                         NEXT FIELD pon35
                      ELSE
                         NEXT FIELD pon32
                      END IF
                   END IF
                END IF
                LET g_pnn38  = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
                LET g_pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
               UPDATE pnn_file SET pnn13=g_pnn[l_ac].pnn13,
                                   pnn03=g_pnn[l_ac].pnn03,
                                   pnn05=g_pnn[l_ac].pnn05,
                                   pnn06=g_pnn[l_ac].pnn06,
                                   pnn07=g_pnn[l_ac].pnn07,
                                   pnn08=g_pnn[l_ac].pnn08,
                                   pnn09=g_pnn[l_ac].pnn09,
                                   pnn32=g_pnn[l_ac].pnn32,
                                   pnn35=g_pnn[l_ac].pnn35,
                                   pnn37=g_pnn[l_ac].pnn37,
                                   pnn38=g_pnn38,
                                   pnn38t=g_pnn38t,
                                   pnn10=g_pnn[l_ac].pnn10,
                                   pnn10t=g_pnn[l_ac].pnn10t,    #No.FUN-550089
                                   pnn11=g_pnn[l_ac].pnn11,
                                   pnn919=g_pnn[l_ac].pnn919,   #FUN-A80150 add
                                   pnn12=g_pnn[l_ac].pnn12,
                                   pnn18=g_pnn[l_ac].pnn18,
                                   pnn19=g_pnn[l_ac].pnn19,
                                   pnn20=g_pnn20,   #MOD-9B0169
                                   pnn16='Y'
               WHERE pnn01=g_pml.pml01   AND
                     pnn02=g_pml.pml02   AND
                     pnn03=g_pnn_t.pnn03 AND
                     pnn05=g_pnn_t.pnn05 AND
                     pnn06=g_pnn_t.pnn06
 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pnn_file",g_pnn[l_ac].pnn03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
                 LET g_pnn[l_ac].* = g_pnn_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac             #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_pnn[l_ac].* = g_pnn_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pnn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF 
               CLOSE p570_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac             #FUN-D30034 add
            CLOSE p570_bcl
            COMMIT WORK
 
       AFTER INPUT
#CHI-B60077 -- begin --
         FOR l_i = 1 TO g_pnn.getLength()
           #CALL s_sizechk(g_pnn[l_i].pnn03,g_pnn[l_i].pnn09,g_lang) #CHI-C10037 mark
            CALL s_sizechk(g_pnn[l_i].pnn03,g_pnn[l_i].pnn09,g_lang,g_pnn[l_i].pnn12)  #CHI-C10037 add
               RETURNING l_pnn09
            IF g_confirm = '1' THEN
               LET g_pnn[l_i].pnn09 = l_pnn09
               LET g_pnn[l_i].pnn09 = s_digqty(g_pnn[l_i].pnn09,g_pnn[l_i].pnn12)   #FUN-910088--add--
               #MOD-C70231 add start -----
               LET l_ac = l_i
               CALL p570_set_pnn37()
               #MOD-C70231 add end   -----
               DISPLAY g_pnn[l_i].pnn09 TO pnn09
               UPDATE pnn_file SET pnn09 = g_pnn[l_i].pnn09
                  ,pnn37 = g_pnn[l_i].pnn37 #MOD-C70231 add
                  WHERE pnn01 = g_pml.pml01
                    AND pnn02 = g_pml.pml02
                    AND pnn03 = g_pnn[l_i].pnn03
                    AND pnn05 = g_pnn[l_i].pnn05
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","pnn_file",g_pnn[l_i].pnn03,"",SQLCA.sqlcode,"","",0)
               END IF
            ELSE
               IF g_confirm = '2' THEN
                  EXIT FOR
               END IF
            END IF
         END FOR
#CHI-B60077 -- end --
         IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
            IF p570_available_qty('1') THEN #MOD-B30399 add '1'
               NEXT FIELD pnn13
            END IF
         END IF
 
         ON ACTION CONTROLP
            CASE
            #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面 
            #BEFORE FIELD att00來做開窗了                                                                                           
            #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
            WHEN INFIELD(att00)                                                                                                     
               #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------                                                                                              
#               CALL cl_init_qry_var()             
#               LET g_qryparam.form ="q_ima_p"                                                                                       
#               LET g_qryparam.arg1 = lg_group                                                                                       
#               CALL cl_create_qry() RETURNING g_pnn[l_ac].att00
               CALL q_sel_ima(FALSE, "q_ima_p","","","lg_group","","","","",'' ) RETURNING g_pnn[l_ac].att00
#FUN-AA0059---------mod------------end-----------------                                                                     
               DISPLAY BY NAME g_pnn[l_ac].att00   
               NEXT FIELD att00         
 
               WHEN INFIELD(pnn03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmd3"   #TQC-BC0133 change q_bmd -->q_bmd3  #TQC-BC0134
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.default1 = g_pnn[l_ac].pnn03
                  LET g_qryparam.arg1 = g_pml.pml04
                  LET g_qryparam.arg2 = g_pml.pml33     #TQC-BC0134 add
                  CALL cl_create_qry() RETURNING g_pnn03_sub,g_pnn08_sub
# 取替代料處理 ...............................
                   DISPLAY g_pnn03_sub TO pnn03       
                   DISPLAY g_pnn08_sub TO pnn08       
                  IF NOT cl_null(g_pnn03_sub) THEN 
                     CALL p570_s(l_ac) 
                     CALL p570_b_fill(' 1=1')
                     LET l_exit_sw='n' 
                     CLOSE p570_bcl
                     COMMIT WORK
                     EXIT INPUT 
                  END IF 
               WHEN INFIELD(pnn05)
#MOD-C30879 add begin
#                  CALL q_pmh3(FALSE,TRUE,g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn09,'1',g_pnn[l_ac].pnn12) #NO:7178 add g_pnn[l_ac].pnn09  #No.FUN-670099  #No.FUN-930148 add pnn12
#                       RETURNING g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,
#                                 g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t   #No.FUN-610018
                   SELECT ima915 INTO l_ima915 FROM ima_file   
                    WHERE ima01=g_pnn[l_ac].pnn03                  
                   IF (l_ima915 = '2' OR l_ima915 = '3') AND g_pnn[l_ac].pnn03[1,4] <> 'MISC' THEN 
                      CALL q_pmh3(FALSE,TRUE,g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn09,'1',g_pnn[l_ac].pnn12) #NO:7178 add g_pnn[l_ac].pnn09  #No.FUN-670099  #No.FUN-930148 add pnn12
                        RETURNING g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,
                                  g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t   #No.FUN-610018
                   ELSE 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_pmc01"
                      LET g_qryparam.default1 = g_pnn[l_ac].pnn05
                      CALL cl_create_qry() RETURNING g_pnn[l_ac].pnn05
                   END IF    	                
#MOD-C30879 add end 
                   DISPLAY BY NAME g_pnn[l_ac].pnn05        #No.MOD-490371
                   DISPLAY BY NAME g_pnn[l_ac].pnn06        #No.MOD-490371
                   DISPLAY BY NAME g_pnn[l_ac].pnn10        #No.MOD-490371
                   DISPLAY BY NAME g_pnn[l_ac].pnn10t       #No.FUN-610018
                   CALL p570_pnn05_1()                      #MOD-4A0327
            WHEN INFIELD(pnn18) #Blanket P/O
               #CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19                  #MOD-C30797 mark
               CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_pnn[l_ac].pmc47) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19 #MOD-C30797 add
                   DISPLAY BY NAME g_pnn[l_ac].pnn18        #No.MOD-490371
                   DISPLAY BY NAME g_pnn[l_ac].pnn19        #No.MOD-490371
               NEXT FIELD pnn18
 
            WHEN INFIELD(pnn19) #Blanket P/O
               #CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19                   #MOD-C30797 mark
               CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn06,g_pnn[l_ac].pmc47) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19 #MOD-C30797 add
                   DISPLAY BY NAME g_pnn[l_ac].pnn18        #No.MOD-490371
                   DISPLAY BY NAME g_pnn[l_ac].pnn19        #No.MOD-490371
               NEXT FIELD pnn19
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
     
     END INPUT
 
     IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
        IF p570_available_qty('1') THEN #MOD-B30399 add '1'  
           LET l_exit_sw = 'N' 
           CALL p570_b()   #MOD-880151
        END IF
     END IF
 
END FUNCTION
   
FUNCTION  p570_sum_tot()
#  DEFINE l_tot1     LIKE ima_file.ima26   #No.FUN-680136 DEC(15,3) #FUN-A20044
  DEFINE l_tot1     LIKE type_file.num15_3 #FUN-A20044
#  DEFINE l_tot2     LIKE ima_file.ima26   #No.FUN-680136 DEC(15,3) #FUN-A20044
  DEFINE l_tot2     LIKE type_file.num15_3 #FUN-A20044
 
    SELECT SUM(pnn09/pnn08) INTO l_tot1 FROM pnn_file
     WHERE pnn01 = g_pml.pml01 AND pnn02 = g_pml.pml02
       AND pnn09 > 0 AND pnn08 > 0
 
  IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF 
  LET l_tot2  =( g_pml.pml20 - g_pml.pml21 ) - l_tot1  #未轉採購量-單身合計
  IF l_tot2 >= 0  THEN 
     RETURN 'Y'
  ELSE 
     RETURN 'N'
  END IF 
END FUNCTION
 
FUNCTION  p570_ima02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_ima44         LIKE ima_file.ima44,
    l_imaacti       LIKE ima_file.imaacti 
DEFINE  l_flag      LIKE type_file.chr1     #MOD-880151
 
    LET g_chr = 'N'  #MOD-9B0162
    LET g_errno = ' '
    #-->讀取料件主檔
    SELECT ima02,ima021,ima44,imaacti
      INTO g_pnn[l_ac].ima02,g_pnn[l_ac].ima021_1,l_ima44,l_imaacti
                         FROM ima_file
                        WHERE ima01 =g_pnn[l_ac].pnn03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_pnn[l_ac].ima02 = NULL
                                   LET l_ima44 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_pnn[l_ac].pnn12 = l_ima44
    CALL s_umfchk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn12,g_pml.pml07)
        RETURNING l_flag,g_pnn17 
    IF l_flag = 1 THEN                                                        
       LET g_pnn17=1                                                        
    END IF
    IF cl_null(g_pnn[l_ac].pnn36) THEN 
       SELECT pml86 INTO g_pnn[l_ac].pnn36 FROM pml_file
         WHERE pml01 = g_pml.pml01 AND pml02 = g_pml.pml02
       IF g_sma.sma116 MATCHES '[02]' THEN 
          LET g_pnn[l_ac].pnn36 = g_pnn[l_ac].pnn12
       END IF
    END IF

#No.TQC-960336---start---
    IF cl_null(g_pnn[l_ac].pnn30) THEN
       SELECT pml80,pml81
         INTO g_pnn[l_ac].pnn30,g_pnn[l_ac].pnn31
         FROM pml_file
        WHERE pml01 = g_pml.pml01
          AND pml02 = g_pml.pml02
    END IF
    IF cl_null(g_pnn[l_ac].pnn33) THEN
       SELECT pml83,pml84
         INTO g_pnn[l_ac].pnn33,g_pnn[l_ac].pnn34
         FROM pml_file
        WHERE pml01 = g_pml.pml01
          AND pml02 = g_pml.pml02
    END IF
    DISPLAY BY NAME g_pnn[l_ac].pnn30,g_pnn[l_ac].pnn31,
                    g_pnn[l_ac].pnn33,g_pnn[l_ac].pnn34 
#No.TQC-960336---end---

    IF cl_null(g_pnn[l_ac].pnn03) AND NOT cl_null(g_errno) THEN
       LET g_chr = 'Y'
    END IF
END FUNCTION
   
FUNCTION  p570_pnn03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_bmd07         LIKE bmd_file.bmd07
 
    LET g_errno = ' '
    SELECT bmd07 INTO l_bmd07
      FROM bmd_file 
     WHERE bmd01 = g_pml.pml04
       AND bmd02 = '2'
       AND bmd04 = g_pnn[l_ac].pnn03
       AND bmdacti = 'Y'                                           #CHI-910021
       AND bmd05 = (SELECT max(bmd05) from bmd_file
                     WHERE bmd01 = g_pml.pml04
                       AND bmd02 = '2'
                       AND bmdacti = 'Y'                                           #CHI-910021
                       AND bmd04 = g_pnn[l_ac].pnn03)
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2767'
                                   LET l_bmd07  = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_pnn[l_ac].pnn08  = l_bmd07
    END IF
 
END FUNCTION
   
FUNCTION  p570_pnn05(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_pmc22     LIKE pmc_file.pmc22,
       l_pmhacti   LIKE pmh_file.pmhacti,
       l_pmh11     LIKE pmh_file.pmh11,#MOD-580302
       l_pmh12     LIKE pmh_file.pmh12,#MOD-580302
       l_pmh13     LIKE pmh_file.pmh13 #MOD-580302
DEFINE l_ima915    LIKE ima_file.ima915  #FUN-710060 add
DEFINE l_pmk       RECORD LIKE pmk_file.*   #No.FUN-930148 
 
    IF cl_null(g_pnn[l_ac].pnn06) THEN
       SELECT pmc22 INTO l_pmc22 FROM pmc_file
        WHERE pmc01 = g_pnn[l_ac].pnn05
    ELSE
       LET l_pmc22 = g_pnn[l_ac].pnn06
    END IF
 
    LET g_errno = ' '
    SELECT pmh11,pmh12,pmh13,pmhacti
       INTO l_pmh11,l_pmh12,l_pmh13,l_pmhacti     #MOD-580302
      FROM pmh_file
     WHERE pmh01 = g_pnn[l_ac].pnn03
       AND pmh02 = g_pnn[l_ac].pnn05
       AND pmh13 = l_pmc22
       AND pmh21 = " "                                             #CHI-860042                                                      
       AND pmh22 = '1'                                             #CHI-860042
       AND pmh23 = ' '                                             #CHI-960033
       AND pmhacti = 'Y'                                           #CHI-910021
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3323'
         WHEN l_pmhacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_pnn[l_ac].pnn07) THEN LET g_pnn[l_ac].pnn07 = l_pmh11 DISPLAY BY NAME g_pnn[l_ac].pnn07 END IF
    IF cl_null(g_pnn[l_ac].pnn10) THEN LET g_pnn[l_ac].pnn10 = l_pmh12 DISPLAY BY NAME g_pnn[l_ac].pnn10 END IF
    IF cl_null(g_pnn[l_ac].pnn06) THEN LET g_pnn[l_ac].pnn06 = l_pmh13 DISPLAY BY NAME g_pnn[l_ac].pnn06 END IF
 
    SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pnn[l_ac].pnn03  #FUN-710060 add
     IF l_ima915='0' OR l_ima915='1' THEN   #FUN-710060 mod
        LET g_errno = ' '
     END IF 
    IF cl_null(g_errno) THEN #NO:6998,select pmh_file 無誤的才call s_defprice
       IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN    #MOD-A10185
         #SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
          SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01  #TQC-B80055 mod
          LET g_term = l_pmk.pmk41 
          IF cl_null(g_term) THEN 
             SELECT pmc49 INTO g_term
               FROM pmc_file 
              WHERE pmc01 = g_pnn[l_ac].pnn05
          END IF 
          LET g_price = l_pmk.pmk20
          IF cl_null(g_price) THEN 
             SELECT pmc17 INTO g_price
              FROM pmc_file 
              WHERE pmc01 = g_pnn[l_ac].pnn05
          END IF   
          SELECT pmc47 INTO g_pmm.pmm21
                     FROM pmc_file
                     WHERE pmc01 =g_pnn[l_ac].pnn05 
          SELECT gec04 INTO g_pmm.pmm43
            FROM gec_file
           WHERE gec01 = g_pmm.pmm21             
             AND gec011 = '1'  #進項 TQC-B70212 add
          CALL s_defprice_new(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,
                         g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
             RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                       g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
          IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
         #CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t)   #MOD-9C0285 ADD
          CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term)   #MOD-9C0285 ADD  #TQC-B80055 mod
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
          END IF
       END IF   #MOD-A10185
       IF NOT cl_null(g_pnn[l_ac].pnn18) AND NOT cl_null(g_pnn[l_ac].pnn19) THEN
          SELECT * INTO g_pon.* FROM pon_file 
             WHERE pon01 = g_pnn[l_ac].pnn18
               AND pon02 = g_pnn[l_ac].pnn19
          CALL s_bkprice(g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_pon.pon31,g_pon.pon31t) 
               RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
       END IF
    END IF
 
END FUNCTION
 
FUNCTION p570_pnn18()
  SELECT * INTO g_pom.* FROM pom_file
   WHERE pom01 = g_pnn[l_ac].pnn18
   CASE WHEN STATUS = 100                    LET g_errno = 'apm-902'   #No.MOD-4A0356
       WHEN g_pom.pom25 MATCHES '[678]'     LET g_errno = 'mfg3258'
       WHEN g_pom.pom25 = '9'               LET g_errno = 'mfg3259'
       WHEN g_pom.pom25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
       WHEN g_pom.pom18 = 'N'               LET g_errno = 'apm-292'
       OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
   
FUNCTION p570_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON pnn13,pnn03,ima02,pnn05,pnn06,pnn07,
                       pnn08,pnn09,pnn12,pnn10,pnn11,pnn919,pnn18,pnn19   #FUN-A80150 add pnn919
                  FROM s_pnn[1].pnn13,s_pnn[1].pnn03,
                       s_pnn[1].ima02,s_pnn[1].pnn05,
                       s_pnn[1].pnn06,s_pnn[1].pnn07,
                       s_pnn[1].pnn08,s_pnn[1].pnn09,
                       s_pnn[1].pnn12,s_pnn[1].pnn10,
                       s_pnn[1].pnn11,s_pnn[1].pnn919,s_pnn[1].pnn18,   #FUN-A80150 add pnn919
                       s_pnn[1].pnn19
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END CONSTRUCT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    CALL p570_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION p570_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
       l_gec07 LIKE gec_file.gec07       #No.FUN-610018
    LET g_sql =
        #為新程序增加了21個欄位的空白顯示
        "SELECT pnn13,pnn03,'','','','','','','','','','','','','','',",
        "       '','','','','','','',ima02,ima021,pnn05,pmc03,pnn07,",  
        "       pnn08,pnn09,pnn33,pnn34,pnn35,pnn30,pnn31,pnn32,pnn36,",
        "       pnn37,pnn18,pnn19,pnn10,pnn10t,pnn12,pnn11,pnn919,pnn06,",#No.FUN-550089   #No.MOD-7B0112 delete pnn16  #FUN-A80150 add pnn919
        "        ' ',0,pnn16 ",             #No.FUN-5C0074  #No.MOD-7B0112 add pnn16
       #"  FROM pnn_file, OUTER ima_file,OUTER pmc_file ",                     #MOD-4A0327    #TQC-AB0041
        "  FROM pnn_file LEFT OUTER JOIN ima_file ON pnn03 = ima_file.ima01 ", #TQC-AB0041
        "  LEFT OUTER JOIN pmc_file ON pnn05 = pmc_file.pmc01 ",               #TQC-AB0041    
       #" WHERE pnn03 = ima_file.ima01 ",         #TQC-AB0041 
       #"  AND  pnn01 ='",g_pnn01,"'",            #TQC-B10028
        " WHERE pnn01 ='",g_pnn01,"'",            #TQC-B10028
       #"  AND  pnn02 ='",g_pnn02,"'",            #TQC-AB0041
        "  AND  pnn02 =",g_pnn02,                 #TQC-AB0041   
        "  AND ",  p_wc2 CLIPPED,                        #MOD-4B0294  調整SELECT條件  
       #"  AND pnn05 = pmc_file.pmc01 ",          #TQC-AB0041               #MOD-4A0327
         " ORDER BY pnn13,pnn07 "                                              #MOD-4B0294(END)  調整SELECT條件 
 
    PREPARE p570_pb FROM g_sql
    DECLARE pnn_curs                       #CURSOR
        CURSOR FOR p570_pb
 
    CALL g_pnn.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET g_gec07 = 'N'       #No.FUN-550089
    FOREACH pnn_curs INTO g_pnn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_pnn[g_cnt].att00,g_pnn[g_cnt].att01,g_pnn[g_cnt].att02,                                                         
                  g_pnn[g_cnt].att03,g_pnn[g_cnt].att04,g_pnn[g_cnt].att05,                                                         
                  g_pnn[g_cnt].att06,g_pnn[g_cnt].att07,g_pnn[g_cnt].att08,                                                         
                  g_pnn[g_cnt].att09,g_pnn[g_cnt].att10                                                                             
           FROM imx_file WHERE imx000 = g_pnn[g_cnt].pnn03                                                                          
                                                                                                                                    
           LET g_pnn[g_cnt].att01_c = g_pnn[g_cnt].att01                                                                            
           LET g_pnn[g_cnt].att02_c = g_pnn[g_cnt].att02                                                                            
           LET g_pnn[g_cnt].att03_c = g_pnn[g_cnt].att03                                                                            
           LET g_pnn[g_cnt].att04_c = g_pnn[g_cnt].att04                                                                            
           LET g_pnn[g_cnt].att05_c = g_pnn[g_cnt].att05                                                                            
           LET g_pnn[g_cnt].att06_c = g_pnn[g_cnt].att06                                                                            
           LET g_pnn[g_cnt].att07_c = g_pnn[g_cnt].att07                                                                            
           LET g_pnn[g_cnt].att08_c = g_pnn[g_cnt].att08 
           LET g_pnn[g_cnt].att09_c = g_pnn[g_cnt].att09                                                                            
           LET g_pnn[g_cnt].att10_c = g_pnn[g_cnt].att10                                                                            
                                                                                                                                    
        END IF  
        #MOD-B30076 add --start--
        IF g_pnn[g_cnt].pnn03[1,4]='MISC' THEN
           LET g_pnn[g_cnt].ima02= g_pml.pml041      
        END IF
        #MOD-B30076 add --end--
        SELECT pmc47 INTO g_pnn[g_cnt].pmc47
          FROM pmc_file
         WHERE pmc01 = g_pnn[g_cnt].pnn05
        IF g_pnn[g_cnt].pmc47 IS NULL THEN
           SELECT pmk21 INTO g_pnn[g_cnt].pmc47
             FROM pmk_file
            WHERE pmk01 = g_pml.pml01
        END IF
        IF NOT cl_null(g_pnn[g_cnt].pmc47) THEN     #No.FUN-560102
           SELECT gec04,gec07 INTO g_pnn[g_cnt].gec04,l_gec07    #No.FUN-610018
             FROM gec_file
            WHERE gec01 = g_pnn[g_cnt].pmc47
              AND gec011 = '1'  #進項 TQC-B70212 add
           IF l_gec07 = 'Y' THEN   #No.FUN-610018
              LET g_gec07 = 'Y'
           END IF
        END IF
        LET g_cnt = g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pnn.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
    CALL p570_refresh_detail()  #TQC-650108 add  刷新單身的欄位顯示
END FUNCTION
 
FUNCTION p570_bp(p_ud)
 
    DEFINE p_ud            LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    DISPLAY ARRAY g_pnn TO s_pnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION generate
           LET g_action_choice="generate"   
           EXIT DISPLAY
 
        ON ACTION transfer_out
           LET g_action_choice="transfer_out"    
           EXIT DISPLAY
 
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
 
        ON ACTION help
           LET g_action_choice="help"     
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL p570_def_form()   #FUN-610067
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit"     
           EXIT DISPLAY
 
        ON ACTION first
           CALL p570_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION previous
           CALL p570_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION jump
           CALL p570_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION next
           CALL p570_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION last
           CALL p570_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DISPLAY
     
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    
        ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p570_t()
DEFINE  l_show_msg      DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       pmm01       LIKE pmm_file.pmm01   #採購單號
                   END RECORD,
       l_i         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
       l_gaq03_f1  LIKE gaq_file.gaq03
 
     DEFINE l_pmm01 LIKE pmm_file.pmm01 #MOD-4A0345
 
    LET g_action_choice = ""      #No.TQC-7C0176
 
    OPEN WINDOW p5701_w WITH FORM "apm/42f/apmp570_b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmp570_b")

    IF g_azw.azw04='2' THEN
       CALL cl_set_comp_visible("pnnislk01",FALSE)
    END IF
 
    CALL p570_tm()
    IF INT_FLAG THEN  
       LET INT_FLAG = 0 
       CLOSE WINDOW p5701_w
       CALL p570_b_fill(' 1=1')  #No.FUN-560063
       RETURN
    END IF
 
    INITIALIZE g_pmm.* TO NULL			# Default condition
    INITIALIZE g_pmn.* TO NULL			# Default condition
    IF cl_sure(0,0) THEN 
       BEGIN WORK
       LET l_i = 1 #FUN-590130 add
       CALL l_show_msg.clear() #FUN-590130 add
       CALL g_pmo.clear()   #MOD-880131
       LET g_ac = 1   #MOD-880131
       LET g_success ='Y'
       DELETE FROM p570_tmp2  #MOD-4A0345
        CALL p570_gen() 
        IF g_success = 'Y' THEN
           CALL cl_cmmsg(1) COMMIT WORK 
           CALL p570_ins_pmo()   #MOD-880131
           DECLARE p570_pmm01 CURSOR FOR
            SELECT pmm01 FROM p570_tmp2
           FOREACH p570_pmm01 INTO l_pmm01
             LET l_show_msg[l_i].pmm01=l_pmm01
             LET l_i = l_i + 1
           END FOREACH
           #以陣列方式show出所產生的資料
           LET g_msg = NULL
           LET g_msg2= NULL
           LET l_gaq03_f1 = NULL
           CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
           CALL cl_get_feldname('pmm01',g_lang) RETURNING l_gaq03_f1
           LET g_msg2 = l_gaq03_f1 CLIPPED
           CALL cl_show_array(base.TypeInfo.create(l_show_msg),g_msg         ,g_msg2)
           CLOSE WINDOW p5701_w     
        ELSE
           CALL cl_rbmsg(1) ROLLBACK WORK 
           CLOSE WINDOW p5701_w     
        END IF
    END IF
    CLOSE WINDOW p5701_w     #No.TQC-7C0176
    ERROR ""
 
END FUNCTION 
   
FUNCTION p570_tm()
 DEFINE  l_cnt      LIKE type_file.num5,       #No.FUN-680136 SMALLINT
         li_result  LIKE type_file.num5        #No.FUN-550060  #No.FUN-680136 SMALLINT
 DEFINE  l_oay22    LIKE oay_file.oay22,       #No.TQC-650108
         l_errmsg   LIKE ze_file.ze03          #No.FUN-680136 VARCHAR(50) #No.TQC-650108  
 
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm3.purdate = g_today
   CLEAR FORM 
   WHILE TRUE 
     CONSTRUCT BY NAME  tm3.wc ON pnn01,pnn06,pnn05,pnn15
                                  ,pnnislk01 #No.FUN-810017

#CHI-B80097 --- start --- 
#&ifdef SLK
#CHI-B80097 ---  end  ---
        ON ACTION CONTROLP
           CASE
            #CHI-B80097 --- start ---
             WHEN INFIELD(pnn01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_pnn01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnn01
                  NEXT FIELD pnn01
             WHEN INFIELD(pnn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnn06
                  NEXT FIELD pnn06
             WHEN INFIELD(pnn05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_pnn2"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnn05
                  NEXT FIELD pnn05
             WHEN INFIELD(pnn15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pnn15
                  NEXT FIELD pnn15
            #CHI-B80097 ---  end  ---
             WHEN INFIELD(pnnislk01)  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form  = "q_skd1"                                                                                   
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO pnnislk01
                  NEXT FIELD pnnislk01
          OTHERWISE
               EXIT CASE
          END CASE
#CHI-B80097 --- start ---
#&endif
#CHI-B80097 ---  end  ---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
     IF INT_FLAG THEN EXIT WHILE END IF
     IF tm3.wc = ' 1=1' THEN
        CALL cl_err('','9046',0)
        CONTINUE WHILE
     END IF
     EXIT WHILE 
   END WHILE
   IF INT_FLAG THEN RETURN END IF
   INPUT BY NAME tm3.slip,tm3.purdate,tm3.pmm12,tm3.pmm13 
                 WITHOUT DEFAULTS 
      AFTER FIELD slip 
         #==>檢查單別一定要輸入,否則不允許通過
         IF cl_null(tm3.slip) THEN
            NEXT FIELD slip
         ELSE
             IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
#                SELECT oay22 INTO l_oay22 FROM smy_file        #No.TQC-960336
                SELECT oay22 INTO l_oay22 FROM oay_file         #No.TQC-960336                                                                          
#                 WHERE smyslip = tm3.slip                      #No.TQC-960336
                 WHERE oayslip = tm3.slip                       #No.TQC-960336 
                IF cl_null(tm3.slip) THEN
                   CALL cl_err(tm3.slip,"apm-576",1)
                   NEXT FIELD slip
                END IF
             END IF
             CALL s_check_no("apm",tm3.slip,"","2","","","")
               RETURNING li_result,tm3.slip
             DISPLAY BY NAME tm3.slip
             IF (NOT li_result) THEN
      	       NEXT FIELD slip
             END IF
         END IF
 
      AFTER FIELD purdate
         IF tm3.purdate IS NULL OR tm3.purdate = ' ' 
         THEN NEXT FIELD purdate
         END IF
 
      AFTER FIELD pmm12                      #採購人員
        IF NOT cl_null(tm3.pmm12) THEN 
           CALL p570_pmm12()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm3.pmm12,g_errno,0)
              NEXT FIELD pmm12
           END IF
        END IF
 
      AFTER FIELD pmm13                      #採購部門
        IF NOT cl_null(tm3.pmm12) THEN   #No.MOD-5C0101
           IF cl_null(tm3.pmm13) THEN 
              NEXT FIELD pmm13
           ELSE
              CALL p570_pmm13()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm3.pmm13,g_errno,0)
                 NEXT FIELD pmm13
              END IF
           END IF
        END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(slip) 
                  CALL q_smy(FALSE,FALSE,tm3.slip,'APM','2') RETURNING tm3.slip #TQC-670008
                  DISPLAY tm3.slip TO FORMONLY.slip 
                  NEXT FIELD slip 
               WHEN INFIELD(pmm12) #採購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = tm3.pmm12
                  CALL cl_create_qry() RETURNING tm3.pmm12
                  DISPLAY BY NAME tm3.pmm12 
                  CALL p570_pmm12()
                  NEXT FIELD pmm12
               WHEN INFIELD(pmm13) #請購DEPT
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = tm3.pmm13
                  CALL cl_create_qry() RETURNING tm3.pmm13
                  DISPLAY BY NAME tm3.pmm13 
                  CALL p570_pmm13()
                  NEXT FIELD pmm13
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        AFTER INPUT 
          IF INT_FLAG THEN EXIT INPUT END IF
          IF tm3.slip IS NULL OR tm3.slip = ' ' THEN 
             NEXT FIELD slip
          END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN RETURN END IF
END FUNCTION
   
FUNCTION p570_pmm12()  #人員
         DEFINE l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti
 
	  LET g_errno = ' '
	  SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03 
            FROM gen_file WHERE gen01 = tm3.pmm12
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gen02 TO FORMONLY.gen02
          LET tm3.pmm13=l_gen03 
          DISPLAY BY NAME tm3.pmm13 
END FUNCTION
 
FUNCTION p570_pmm13()    #部門
         DEFINE l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti
 
	  LET g_errno = ' '
	  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
				  WHERE gem01 = tm3.pmm13
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION 
   
FUNCTION p570_gen()
    DEFINE l_qty     LIKE pml_file.pml03,
           l_pnn_o   RECORD LIKE pnn_file.*,
           l_imb118  LIKE imb_file.imb118,
           l_ima49   LIKE ima_file.ima49,
           l_ima491  LIKE ima_file.ima491,
           l_release LIKE pml_file.pml21,
           l_pnn09   LIKE pnn_file.pnn09,
           l_smy62   LIKE smy_file.smy62,
           t_smy62   LIKE smy_file.smy62,
           l_cnt       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
           l_seq       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          #l_sql       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)  #MOD-C70182 mark
           l_sql       STRING,                 #MOD-C70182
           l_slip      LIKE pmn_file.pmn123,   #No.FUN-680136 VARCHAR(10)
           l_msg1      LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(1000)              
  DEFINE  l_over    LIKE pml_file.pml20        #FUN-620055
  DEFINE  l_ima07   LIKE ima_file.ima07        #FUN-620055
  DEFINE  l_ima915  LIKE ima_file.ima915       #FUN-710060 add
  DEFINE l_pnn08 LIKE pnn_file.pnn08,
         l_pnn17 LIKE pnn_file.pnn17,
         l_sum   LIKE pnn_file.pnn09,
         l_pml09 LIKE pml_file.pml09
  
   LET l_msg1= NULL 
    LET l_sql = " SELECT pnn_file.*,",
                "        pml_file.*,'',ima49,ima491,pnnislk01 ", 
                " FROM pnn_file,pml_file, ima_file,pnni_file ",
                " WHERE pnn01 = pml01 AND pnn02 = pml02 ",
                "    AND pml16 IN ('1','2') AND pnn03 = ima_file.ima01 ",
                "   AND pml92 <> 'Y' ",    #FUN-A10034
                "   AND pnn01 = pnni01 ",                                                                                         
                "   AND pnn02 = pnni02 ",
                "   AND pnn03 = pnni03 ",
                "   AND pnn05 = pnni05 ",
                "   AND pnn06 = pnni06 ",
                "   AND ",tm3.wc CLIPPED
   #-->廠商/幣別/採購員
   LET l_sql = l_sql clipped," ORDER BY pnn05,pnn06,pnn15,pnn01,pnn02,pnn03"
 
   PREPARE p570_preg FROM l_sql 
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p570_curg CURSOR WITH HOLD  FOR p570_preg
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('declare p570_curg:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   LET l_pnn_o.pnn05 = '@' 
   LET l_pnn_o.pnn06 = '@' 
   LET l_pnn_o.pnn15 = '@' 
   #-->採購單身預設值
   CALL p570_pmnini()
   FOREACH p570_curg INTO g_pnn2.*,
                          g_pml.*,
                          l_imb118,l_ima49,l_ima491
                          ,g_pnnislk01  #No.FUN-810017
       IF SQLCA.sqlcode THEN 
          CALL cl_err('p570_curg',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       #FUN-C40089---begin
       SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn2.pnn05
       IF cl_null(g_pnz08) THEN 
          LET g_pnz08 = 'Y'
       END IF 
       IF g_pnz08 = 'N' AND (g_pnn2.pnn10 <= 0 OR g_pnn2.pnn10t <= 0) THEN
       #IF g_sma.sma112 = 'N' AND (g_pnn2.pnn10 <= 0 OR g_pnn2.pnn10t <= 0) THEN
       #FUN-C40089---end
          CALL cl_err('','axm-627',1)  #FUN-C50076
          LET g_success = 'N'
          RETURN
       END IF
       IF NOT cl_null(g_pnn2.pnn18) AND NOT cl_null(g_pnn2.pnn19) THEN 
          CALL p570_pnn03_chk(g_pnn2.pnn18,g_pnn2.pnn19,g_pnn2.pnn03) RETURNING  g_success
          IF g_success = 'N' THEN
             LET g_msg = g_pnn2.pnn18 CLIPPED,"+",g_pnn2.pnn19
             CALL cl_err(g_msg CLIPPED,g_errno,1)
             RETURN
          END IF
       END IF
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                            
          LET l_slip = g_pnn2.pnn01[1,g_doc_len]                                                                                     
          SELECT smy62 INTO l_smy62 FROM smy_file                                                                                  
             WHERE smyslip = l_slip  
          LET l_slip = tm3.slip[1,g_doc_len]                                                                                     
          SELECT smy62 INTO t_smy62 FROM smy_file                                                                                  
             WHERE smyslip = l_slip  
          IF l_smy62 != l_smy62 THEN
             LET l_msg1=l_msg1 CLIPPED,' ',l_slip CLIPPED
             CONTINUE FOREACH
          END IF                                                                                              
       END IF              
 
       IF g_pnn2.pnn03[1,4] <> 'MISC' THEN       #MOD-750068 add
       SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pnn2.pnn03
       IF l_ima915='2' OR l_ima915='3' THEN 
           LET g_cnt = 0               #No:8203
           SELECT COUNT(*) INTO g_cnt
             FROM pmh_file
            WHERE pmh01 = g_pnn2.pnn03 #料件編號 #No:8203
              AND pmh02 = g_pnn2.pnn05 #供應廠商編號
              AND pmh13 = g_pnn2.pnn06 #採購幣別
              AND pmh05 = '0'# 已核准
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #CHI-960033
              AND pmhacti = 'Y'                                           #CHI-910021
           IF g_cnt <= 0 THEN
               LET g_char = NULL
               LET g_char= "(",g_pnn2.pnn03,'+',g_pnn2.pnn05,")"
               LET g_char = g_char CLIPPED
               #此料件+供應商資料(pmh_file)尚未核准,請查核...!
               CALL cl_err(g_char,'mfg3043',1)
               LET g_success = 'N'
               RETURN
           END IF
       END IF
       END IF    #MOD-750068 add
       LET l_sum = 0
       DECLARE pnn_cur CURSOR FOR
         SELECT pnn09,pnn08,pnn17 FROM pnn_file
           WHERE pnn01 = g_pnn2.pnn01
             AND pnn02 = g_pnn2.pnn02
       FOREACH pnn_cur INTO l_pnn09,l_pnn08,l_pnn17
         SELECT pml09 INTO l_pml09 FROM pml_file
           WHERE pml01 = g_pnn2.pnn01
             AND pml02 = g_pnn2.pnn02
         LET l_sum = l_sum + ((l_pnn09/l_pnn08*l_pnn17)*l_pml09)
       END FOREACH
 
        LET l_over = 0
        IF g_sma.sma32 = "Y" THEN  #請採購需要勾稽時
           SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
            WHERE ima01=g_pml.pml04
           CASE
              WHEN l_ima07='A'  #計算可容許的數量
                   LET l_over = g_pml.pml20 * (g_sma.sma341/100)
              WHEN l_ima07='B'
                   LET l_over = g_pml.pml20 * (g_sma.sma342/100)
              WHEN l_ima07='C'
                   LET l_over = g_pml.pml20 * (g_sma.sma343/100)
              OTHERWISE
                   LET l_over=0
           END CASE
        END IF
 
       LET g_pml.pml20 = g_pml.pml20 * g_pml.pml09   #MOD-940133
       LET l_over = l_over* g_pml.pml09   #MOD-940133
 
       #採購分配數量合計不可大於請購未轉採購量
       SELECT pml21*pml09 INTO g_pml.pml21 FROM pml_file    #MOD-940133
         WHERE pml01 = g_pml.pml01
           AND pml02 = g_pml.pml02
       IF (g_pml.pml20+l_over-g_pml.pml21) < l_sum THEN  #FUN-620055     #MOD-940133
           LET g_msg = g_pml.pml01 CLIPPED,'+',g_pml.pml02 USING '##',
                       '+',g_pnn2.pnn05
           CALL cl_err(g_msg CLIPPED,'apm-911',1)
           IF g_sma.sma33='R' THEN   #reject   #FUN-620055
             CONTINUE FOREACH   
           END IF                          #FUN-620055 
       END IF 
       SELECT imb118 INTO l_imb118 FROM imb_file WHERE imb01 = g_pnn2.pnn03 
       IF STATUS  THEN LET l_imb118 ='' END IF 
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM pnn_file 
        WHERE pnn01 = g_pnn2.pnn01 and pnn02 = g_pnn2.pnn02
                                   and pnn16 = 'Y' 
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
       IF g_pnn2.pnn09 = 0 THEN 
           #-->轉出後刪除
           DELETE FROM pnn_file WHERE pnn01=g_pnn2.pnn01 AND pnn02=g_pnn2.pnn02 AND pnn03=g_pnn2.pnn03 AND pnn05=g_pnn2.pnn05 AND pnn06=g_pnn2.pnn06
           IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN 
              LET g_success ='N' 
              CALL cl_err3("del","pnn_file","","",SQLCA.sqlcode,"","(p570: delete error)",1)  #No.FUN-660129
              RETURN 
           ELSE    #No.FUN-830132
              IF NOT s_del_pnni(g_pnn2.pnn01,g_pnn2.pnn02,g_pnn2.pnn03,
                                g_pnn2.pnn05,g_pnn2.pnn06,'') THEN              
                 LET g_success ='N' 
                 RETURN 
              END IF                                                       
           END IF
           CONTINUE FOREACH 
       END IF
       IF g_pml.pml92 = 'Y' THEN
         CONTINUE FOREACH
       END IF    
       #-->採購單頭產生     
       IF g_pnn2.pnn05 IS NULL THEN LET g_pnn2.pnn05 =' ' END IF
       IF g_pnn2.pnn06 IS NULL THEN LET g_pnn2.pnn06 =' ' END IF
       IF g_pnn2.pnn15 IS NULL THEN LET g_pnn2.pnn15 =' ' END IF
       IF g_pnn2.pnn05 != l_pnn_o.pnn05 OR     #廠商
          g_pnn2.pnn06 != l_pnn_o.pnn06 OR     #幣別
          g_pnn2.pnn15 != l_pnn_o.pnn15        #採購員  
       THEN CALL p570_pmmsum(g_pmm.pmm01)
            CALL p570_pmmini()
            IF g_success = 'N' THEN EXIT FOREACH END IF
            LET l_seq = 1
       END IF
       #-->採購單身產生     
       CALL p570_inspmn(l_seq,l_imb118,l_ima49,l_ima491)
       IF g_success = 'N' THEN EXIT FOREACH END IF
       LET l_seq = l_seq + 1
       #-->轉出後刪除
       DELETE FROM pnn_file WHERE pnn01=g_pnn2.pnn01 AND pnn02=g_pnn2.pnn02 AND pnn03=g_pnn2.pnn03 AND pnn05=g_pnn2.pnn05 AND pnn06=g_pnn2.pnn06
        IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN 
           LET g_success ='N' 
           CALL cl_err3("del","pnn_file","","",SQLCA.sqlcode,"","(p570: del pnn error)",1)  #No.FUN-660129
           EXIT FOREACH
        ELSE    #No.FUN-830132
           IF NOT s_del_pnni(g_pnn2.pnn01,g_pnn2.pnn02,g_pnn2.pnn03,
                             g_pnn2.pnn05,g_pnn2.pnn06,'') THEN              
              LET g_success ='N' 
              EXIT FOREACH
           END IF                                                       
        END IF
       #-->更新已轉採購量
       CALL p570_pml(g_pnn2.pnn01,g_pnn2.pnn02)
       #-->更新已轉採購量(Blanket PO)
       IF NOT cl_null(g_pnn2.pnn18) THEN
          CALL p570_pon(g_pnn2.pnn18,g_pnn2.pnn19)
       END IF
       IF g_success='N' THEN 
          EXIT FOREACH
       END IF
       UPDATE pmk_file SET pmk25='2'  
        WHERE pmk01 = g_pnn2.pnn01 
          AND pmk01 IN (SELECT pml01 FROM pml_file
                         WHERE pml01=g_pnn2.pnn01 AND pml16='2')
       IF SQLCA.sqlcode THEN 
          LET g_success ='N' 
          CALL cl_err3("upd","pmk_file",g_pnn2.pnn01,"",SQLCA.sqlcode,"","(p570: up_pmk error)",1)  #No.FUN-660129
          EXIT FOREACH
       END IF
#FUN-C60093----add---begin----
       IF g_azw.azw04 = '2' THEN
          IF NOT p570_inspmnslk() THEN
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       END IF
#FUN-C60093----add---end----

       LET l_pnn_o.* = g_pnn2.* 
   END FOREACH  
##FUN-C30055----add--------
#&ifdef SLK
#   IF g_azw.azw04 = '2' THEN
#      IF NOT p570_inspmnslk() THEN
#         LET g_success = 'N'
##        RETURN
#      END IF
#   END IF
#&endif 
##FUN-C30055----end--------
   IF g_success = 'Y' THEN CALL p570_pmmsum(g_pmm.pmm01)  END IF
    
    IF NOT cl_null(l_msg1) THEN
       CALL cl_err(l_msg1,"apm-575",1)
 
    END IF
 
END FUNCTION

#FUN-C30055----add--------
FUNCTION p570_inspmnslk() 
  DEFINE l_cnt           LIKE type_file.num10
  DEFINE l_pmnslk04      LIKE pmnslk_file.pmnslk04
  DEFINE l_pmnslk        RECORD LIKE pmnslk_file.*
  DEFINE l_ima151        LIKE ima_file.ima151
  DEFINE l_pmlslk21      LIKE pmlslk_file.pmlslk21
  DEFINE l_n             LIKE type_file.num10

  DECLARE pmnslk_cs CURSOR FOR SELECT pmlslk04,pmlslk02 FROM pmlslk_file WHERE pmlslk01=g_pnn2.pnn01

  LET l_cnt=1
  INITIALIZE l_pmnslk.* TO NULL
  FOREACH pmnslk_cs INTO l_pmnslk.pmnslk04,l_pmnslk.pmnslk25
    
    LET l_n=0
    SELECT COUNT(*) INTO l_n FROM pmn_file WHERE pmn01=g_pmm.pmm01 
                                             AND pmn24=g_pnn2.pnn01
                                             AND pmn25 IN (SELECT pml02 FROM pml_file,pmli_file
                                                                  WHERE pml01=pmli01
                                                                    AND pml02=pmli02
                                                                    AND pmli01=g_pnn2.pnn01                    
                                                                    AND pmlislk03=l_pmnslk.pmnslk25)
    IF cl_null(l_n) OR l_n=0 THEN
       CONTINUE FOREACH
    END IF
                                                                            
    LET l_pmnslk.pmnslk01 = g_pmm.pmm01
    LET l_pmnslk.pmnslk02 = l_cnt
    LET l_pmnslk.pmnslklegal = g_legal
    LET l_pmnslk.pmnslkplant = g_plant

    SELECT ima02 INTO l_pmnslk.pmnslk041 FROM ima_file WHERE ima01=l_pmnslk.pmnslk04

    SELECT DISTINCT pmn07,pmn08,pmn24,pmn30,pmn31,pmn31t,pmn33,pmn34,pmn35,
                    pmn52,pmn54,pmn56,pmn44,pmn73,pmn74 
     INTO l_pmnslk.pmnslk07,l_pmnslk.pmnslk08,l_pmnslk.pmnslk24,l_pmnslk.pmnslk30,l_pmnslk.pmnslk31,
          l_pmnslk.pmnslk31t,l_pmnslk.pmnslk33,l_pmnslk.pmnslk34,l_pmnslk.pmnslk35,l_pmnslk.pmnslk52,
          l_pmnslk.pmnslk54,l_pmnslk.pmnslk56,l_pmnslk.pmnslk44,l_pmnslk.pmnslk73,l_pmnslk.pmnslk74
     FROM pmn_file,pmni_file 
      WHERE pmn01=pmni01 
        AND pmn02=pmni02
        AND pmn01=g_pmm.pmm01
        AND pmn24=g_pnn2.pnn01
        AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file
                                      WHERE pml01=pmli01
                                        AND pml02=pmli02
                                        AND pmli01=g_pnn2.pnn01             #请购单号
                                        AND pmlislk03=l_pmnslk.pmnslk25)   #母料件項次

     SELECT SUM(pmn20),SUM(pmn88),SUM(pmn88t) INTO l_pmnslk.pmnslk20,l_pmnslk.pmnslk88,l_pmnslk.pmnslk88t
       FROM pmn_file,pmni_file WHERE pmn01=pmni01
                                 AND pmn02=pmni02
                                 AND pmn01=g_pmm.pmm01 
                                 AND pmn24=g_pnn2.pnn01 
                                 AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file 
                                                          WHERE pml01=pmli01
                                                            AND pml02=pmli02
                                                            AND pmli01=g_pnn2.pnn01             #请购单号
                                                            AND pmlislk03=l_pmnslk.pmnslk25)   #母料件項次

        
     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk20) THEN
        LET l_pmnslk.pmnslk20 =0 
     END IF
     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk88) THEN
        LET l_pmnslk.pmnslk88 = 0
     END IF
     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk88t) THEN
        LET l_pmnslk.pmnslk88t = 0
     END IF
     IF cl_null(l_pmnslk.pmnslk30) THEN LET l_pmnslk.pmnslk30=0 END IF
     IF cl_null(l_pmnslk.pmnslk31) THEN LET l_pmnslk.pmnslk31=0 END IF
     IF cl_null(l_pmnslk.pmnslk31t) THEN LET l_pmnslk.pmnslk31t=0 END IF
     IF cl_null(l_pmnslk.pmnslk44) THEN LET l_pmnslk.pmnslk44=0 END IF
     CALL cl_digcut(l_pmnslk.pmnslk88,t_azi04) RETURNING  l_pmnslk.pmnslk88 
     CALL cl_digcut(l_pmnslk.pmnslk88t,t_azi04) RETURNING l_pmnslk.pmnslk88t 

     INSERT INTO pmnslk_file VALUES(l_pmnslk.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        RETURN FALSE
     ELSE
        UPDATE pmni_file SET pmnislk03=l_cnt WHERE pmni01=g_pmm.pmm01 
                                               AND pmni02 IN (SELECT pmn02 FROM pmn_file WHERE pmn01=g_pmm.pmm01
                                                                 AND pmn24=g_pnn2.pnn01
                                                                 AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file 
                                                                              WHERE pml01=pmli01
                                                                                AND pml02=pmli02
                                                                                AND pmli01=g_pnn2.pnn01             #请购单号
                                                                                AND pmlislk03=l_pmnslk.pmnslk25))   #母料件項次
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           RETURN FALSE
        END IF
     END IF
     SELECT SUM(pml21) INTO l_pmlslk21 FROM pml_file,pmli_file 
      WHERE pml01=pmli01
        AND pml02 IN(SELECT pml02 FROM pml_file,pmli_file WHERE pml01=pmli01
                                                            AND pml02=pmli02
                                                            AND pmli01=g_pnn2.pnn01            #请购单号
                                                            AND pmlislk03=l_pmnslk.pmnslk25)   #母料件項次
     IF SQLCA.sqlcode OR cl_null(l_pmlslk21) THEN
        LET l_pmlslk21 = 0
     END IF
     UPDATE pmlslk_file SET pmlslk21=l_pmlslk21 WHERE pmlslk01=g_pnn2.pnn01 AND pmlslk02=l_pmnslk.pmnslk25
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        RETURN FALSE
     END IF
     
     LET l_cnt=l_cnt+1
  END FOREACH
  RETURN TRUE   

  END FUNCTION
#FUN-C30055----end--------
   
FUNCTION p570_pmmini()
 DEFINE  l_smyno   LIKE pmm_file.pmm01,
         l_pmc14   LIKE pmc_file.pmc14,
         l_pmc15   LIKE pmc_file.pmc15,
         l_pmc16   LIKE pmc_file.pmc16,
         l_pmc17   LIKE pmc_file.pmc17,
         l_pmc47   LIKE pmc_file.pmc47,
         l_pmh14   LIKE pmh_file.pmh14,
         l_pmc49   LIKE pmc_file.pmc49,     #No.FUN-930148
         l_pmk     RECORD LIKE pmk_file.*
 DEFINE li_result  LIKE type_file.num5   #No.FUN-560014  #No.FUN-680136 SMALLINT
 DEFINE l_str      LIKE type_file.chr300 #No.FUN-C20008
 DEFINE  l_smy72   LIKE smy_file.smy72   #CHI-CC0033 add
 
   #-->只輸入單別且為自動編號，且為不存存的採購單
    CALL s_auto_assign_no("apm",tm3.slip,tm3.purdate,"2","","","","","")
        RETURNING li_result,l_smyno                                         
        IF (NOT li_result) THEN                                                   
           CALL cl_err('','mfg3326',1) 
           LET g_success = 'N' 
        END IF                                                                    
   message l_smyno
   CALL ui.Interface.refresh()
   #-->請購單
   SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pnn2.pnn01
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","pmk_file",g_pnn2.pnn01,"",SQLCA.sqlcode,"","sel pmk",1)  #No.FUN-660129
      LET g_success = 'N'
   END IF             
  #CHI-CC0033 -- add start -- 預設單別單據性質 -S
   SELECT smy72 INTO l_smy72 FROM smy_file 
    WHERE smyslip=tm3.slip   
   IF NOT cl_null(l_smy72) THEN   
      LET g_pml.pml011  = l_smy72                #性質
   END IF
  #CHI-CC0033 -- add end --

   IF g_pml.pml011 IS NULL OR g_pml.pml011 = ' ' 
   THEN LET g_pml.pml011 = 'REG' 
   END IF
   LET g_pmm.pmm01   = l_smyno                   #單號
   LET g_pmm.pmm02   = g_pml.pml011              #性質
   LET g_pmm.pmm03   = 0                         #變更序號   #MOD-940366 
   LET g_pmm.pmm905 = 'N'   #No.MOD-5A0045
   IF l_pmk.pmk02 = 'TAP' THEN
      LET g_pmm.pmm02='TAP'             #單據性質
      LET g_pmm.pmm901 = 'Y'
      LET g_pmm.pmm902 = 'N'
      LET g_pmm.pmm905 = 'N'
      LET g_pmm.pmm906 = 'Y'
   ELSE
      LET g_pmm.pmm901 = 'N'                     #非三角貿易代買單據
   END IF
   LET g_pmm.pmm04   = tm3.purdate               #採購日期
   LET g_pmm.pmm05   = l_pmk.pmk05               #專案編號
   LET g_pmm.pmm08   = l_pmk.pmk08               #PBI 
   LET g_pmm.pmm09   = g_pnn2.pnn05              #廠商編號
   SELECT pmc14,pmc15,pmc16,pmc17,pmc47,pmc49
      INTO l_pmc14,l_pmc15,l_pmc16,l_pmc17,l_pmc47,l_pmc49                #No.FUN-930148
     FROM pmc_file 
    WHERE pmc01 = g_pmm.pmm09
   LET g_pmm.pmm41 = l_pmk.pmk41
   IF cl_null(l_pmk.pmk41) THEN
      LET  g_pmm.pmm41 = l_pmc49
   END IF    
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmc_file",g_pmm.pmm09,"",SQLCA.sqlcode,"","sel pmc",1)  #No.FUN-660129
      LET g_success='N'
      LET l_pmc14 = ' '      LET l_pmc15 = ' '
      LET l_pmc16 = ' '      LET l_pmc17 = ' '
      LET l_pmc47 = ' '      LET g_pmm.pmm41=' '
   END IF
   IF g_success='N' THEN RETURN END IF
   SELECT gen03 INTO g_pmm.pmm13 FROM gen_file
    WHERE gen01=g_pnn2.pnn15
   IF cl_null(l_pmk.pmk10) THEN LET l_pmk.pmk10 = l_pmc15 END IF
   IF cl_null(l_pmk.pmk11) THEN LET l_pmk.pmk11 = l_pmc16 END IF
   IF cl_null(l_pmk.pmk18) THEN LET l_pmk.pmk18 = l_pmc14 END IF
  #IF cl_null(l_pmk.pmk20) THEN LET l_pmk.pmk20 = l_pmc17 END IF #MOd-C10135 mark
  #IF cl_null(l_pmk.pmk21) THEN LET l_pmk.pmk21 = l_pmc47 END IF #MOD-B40143 mark
   LET l_pmk.pmk20 = l_pmc17                                     #MOD-C10135 add
   LET l_pmk.pmk21 = l_pmc47                                     #MOD-B40143
   LET g_pmm.pmm10   = l_pmk.pmk10               #送貨地址     
   LET g_pmm.pmm11   = l_pmk.pmk11               #帳單地址
   IF NOT cl_null(tm3.pmm12) THEN
      LET g_pmm.pmm12   = tm3.pmm12              #採購員   
      LET g_pmm.pmm13   = tm3.pmm13   #No.MOD-5C0101
   ELSE
      SELECT unique pnn15 
        INTO g_pnn15 
        FROM pnn_file 
       WHERE pnn01 = g_pml.pml01
         AND pnn02 = g_pml.pml02
      LET g_pmm.pmm12   = g_pnn15                #採購員   
      SELECT gen03 INTO g_pmm.pmm13
        FROM gen_file
       WHERE gen01 = g_pmm.pmm12
   END IF
   LET g_pmm.pmm15   = l_pmk.pmk15                #確認人   #MOD-A10046 
   LET g_pmm.pmm20   = l_pmk.pmk20               #付款方式
   LET g_pmm.pmm21   = l_pmk.pmk21               #稅別
   SELECT gec04 INTO g_pmm.pmm43 FROM gec_file   #稅率
    WHERE gec01 = g_pmm.pmm21
      AND gec011='1'  #進項
   IF g_pmm.pmm43 IS NULL THEN LET g_pmm.pmm43   = 0 END IF
   LET g_pmm.pmm22   = g_pnn2.pnn06              #幣別
   CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) RETURNING g_pmm.pmm42 #FUN-640012
   IF cl_null(g_pmm.pmm42) THEN LET g_pmm.pmm42=1 END IF
      LET g_pmm.pmm25   = '0'                  #狀況
      LET g_pmm.pmm18   = 'N'                  #確認碼
   IF g_smy.smydmy4 = 'Y' AND g_smy.smyapr='N' THEN
      LET g_pmm.pmm25   = '1'                  #狀況
      LET g_pmm.pmm18   = 'Y'                  #確認碼
   END IF
   LET g_pmm.pmm27   = g_today
   LET g_pmm.pmm30   = 'Y'               LET g_pmm.pmm31 = g_sma.sma51 
   LET g_pmm.pmm32   = g_sma.sma52       LET g_pmm.pmm40 = 0
   LET g_pmm.pmm40t  = 0   #No.FUN-610018
   LET g_pmm.pmm44   = '1' #No:7714
   LET g_pmm.pmm45   = l_pmk.pmk45
   LET g_pmm.pmm46   = 0                 LET g_pmm.pmm47 = 0
   LET g_pmm.pmm48   = 0                 LET g_pmm.pmm49 = 'N'
   LET g_pmm.pmm909="2"              #No.FUN-630006
   LET g_pmm.pmmprsw = 'Y'               LET g_pmm.pmmprno = 0    
   LET g_pmm.pmmprdt = ' '
   LET g_pmm.pmmmksg = g_smy.smyapr      LET g_pmm.pmmsign = g_smy.smysign
   LET g_pmm.pmmdays = g_smy.smydays     LET g_pmm.pmmprit = g_smy.smyprit
   LET g_pmm.pmmsseq = 0                 LET g_pmm.pmmsmax = 0
   LET g_pmm.pmmuser = g_user            LET g_pmm.pmmgrup = g_grup
   LET g_pmm.pmmmodu = ' '               LET g_pmm.pmmdate = g_today
   LET g_pmm.pmmacti = 'Y'
#  LET g_pmm.pmm51 = ' '      #NO.FUN-960130           #NO.FUN-9B0016     #FUN-B70015  mark                                                                       
   LET g_pmm.pmm51 = '1'      # FUN-B70015
   LET g_pmm.pmmpos = 'N'      #NO.FUN-960130
   LET g_pmm.pmmplant = g_plant #FUN-980006 add
   LET g_pmm.pmmlegal = g_legal #FUN-980006 add
   LET g_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET g_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   LET g_pmm.pmmcrat = g_today     #TQC-B10028
   LET g_pmm.pmmdate = NULL        #TQC-B10028
   #MOD-C10099 ----- modify start -----
   LET g_pmm.pmm14   = l_pmk.pmk14   #收貨部門
   LET g_pmm.pmm16   = l_pmk.pmk16   #運送方式
   LET g_pmm.pmm17   = l_pmk.pmk17   #代理商
   #MOD-C10099 ----- modify end -----
   INSERT INTO pmm_file VALUES(g_pmm.*)
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("ins","pmm_file","","",SQLCA.sqlcode,"","ins pmm",1)  #No.FUN-660129
      LET g_success = 'N'
   #NO. FUN-C20008----- start -----
   ELSE
      LET l_str = "pmm01 = '",g_pmm.pmm01,"'"
      CALL s_upd_owner_group("pmm_file",l_str) #依據資料歸屬設定update資料所有人及資料所屬部門
   #NO. FUN-C20008----- end   -----
   END IF

   DECLARE pmo_curs_1 CURSOR FOR
     SELECT * FROM pmo_file
       WHERE pmo01 = g_pnn2.pnn01 AND pmo03 = '0' 
 
   FOREACH pmo_curs_1 INTO g_pmo[g_ac].*
      IF STATUS THEN
         CALL cl_err('pmo_curs',STATUS,0)
         LET g_success = 'N'
      END IF
 
      LET g_pmo[g_ac].pmo01 = g_pmm.pmm01
      LET g_pmo[g_ac].pmo02 = '1'
      LET g_pmo[g_ac].pmo03 = '0'
      LET g_ac = g_ac + 1
 
   END FOREACH
    INSERT INTO p570_tmp2 VALUES(g_pmm.pmm01)                 #MOD-4A0345
END FUNCTION
   
FUNCTION p570_pmnini()
   LET g_pmn.pmn11 = 'N'                   #LET g_pmn.pmn13  = 0    #MOD-A10164 
   LET g_pmn.pmn14 = g_sma.sma886[1,1]     LET g_pmn.pmn15  =g_sma.sma886[2,2]
   LET g_pmn.pmn23 = ' '                 
   LET g_pmn.pmn36 = ' '                   LET g_pmn.pmn37 = ' '
   LET g_pmn.pmn38 = 'Y'                   LET g_pmn.pmn40 = ' '
   LET g_pmn.pmn41 = ' '                   LET g_pmn.pmn43 = 0  
   LET g_pmn.pmn431 = 0  
   LET g_pmn.pmn50 = 0 
   LET g_pmn.pmn51 = 0                     #LET g_pmn.pmn52 = 0 
   LET g_pmn.pmn52 =' '  #倉庫
   
   LET g_pmn.pmn53 = 0                     LET g_pmn.pmn54 = 0 
   LET g_pmn.pmn55 = 0                     LET g_pmn.pmn56 = ' ' 
   LET g_pmn.pmn57 = 0                     LET g_pmn.pmn58 = 0 
   LET g_pmn.pmn59 = ' '                   LET g_pmn.pmn60 = ' '
END FUNCTION
   
FUNCTION p570_inspmn(p_seq,p_imb118,p_ima49,p_ima491)
  DEFINE  p_seq     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          p_imb118  LIKE imb_file.imb118,
          p_ima49   LIKE ima_file.ima49,
          p_ima491  LIKE ima_file.ima491,
          l_sw      LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE  l_pnn10t  LIKE pnn_file.pnn10t    #No.CHI-820014
  DEFINE  l_gec07   LIKE gec_file.gec07     #CHI-890026 
  DEFINE  l_pmh24   LIKE pmh_file.pmh24     #NO.FUN-940083
  DEFINE  l_pmc914  LIKE pmc_file.pmc914    #NO.FUN-940083
  DEFINE  l_pmni    RECORD LIKE pmni_file.* #No.FUN-7B0018
  DEFINE  l_pmk     RECORD LIKE pmk_file.*   #No.FUN-930148
  
   LET g_pmn.pmn63 = g_pml.pml91          #No.FUN-920183
   LET g_pmn.pmn01 = g_pmm.pmm01          LET g_pmn.pmn011= g_pmm.pmm02 
   LET g_pmn.pmn02 = p_seq                
   LET g_pmn.pmn61 = g_pml.pml04          #被替代料件
 
   IF g_pnn2.pnn03[1,4]='MISC' THEN
      LET g_pmn.pmn041= g_pml.pml041         
   ELSE
      SELECT ima02 INTO g_pmn.pmn041 FROM ima_file
       WHERE ima01 = g_pnn2.pnn03
   END IF
 
   LET g_pmn.pmn05 = g_pml.pml05
   LET g_pmn.pmn07 = g_pnn2.pnn12         LET g_pmn.pmn08 = g_pml.pml08
   LET g_pmn.pmn80 = g_pnn2.pnn30
   LET g_pmn.pmn81 = g_pnn2.pnn31 
   LET g_pmn.pmn82 = g_pnn2.pnn32 
   LET g_pmn.pmn83 = g_pnn2.pnn33
   LET g_pmn.pmn84 = g_pnn2.pnn34 
   LET g_pmn.pmn85 = g_pnn2.pnn35 
   LET g_pmn.pmn86 = g_pnn2.pnn36
   LET g_pmn.pmn87 = g_pnn2.pnn37 
   #---->訂購數量必須將其轉換成採購單位
   IF g_pmn.pmn07 != g_pmn.pmn08 THEN 
      CALL s_umfchk(g_pnn2.pnn03,g_pmn.pmn07,g_pmn.pmn08)
           RETURNING l_sw,g_pmn.pmn09
      IF l_sw  THEN 
          #### ------單位換算率抓不到 ---------####
          CALL cl_err('pmn07/pmn08: ','abm-731',1)
          LET g_success = 'N' 
      END IF
   ELSE 
       LET g_pmn.pmn09 = 1                       #採購/料件庫存轉換
   END IF
 
   LET g_pmn.pmn121= g_pnn2.pnn17                #請購與採購轉換率
   LET g_pmn.pmn16 = g_pmm.pmm25
   LET g_pmn.pmn20 = g_pnn2.pnn09                #採購數量
   LET g_pmn.pmn24 = g_pnn2.pnn01                #請購單號
   LET g_pmn.pmn25 = g_pnn2.pnn02                #項次
   LET g_pmn.pmn30 = p_imb118                    #標準價格
#TQC-BC0112 mark begin
#   #MOD-B10092 add --start--
#   IF g_sma.sma841 MATCHES '[567]' THEN  #走核價制
#      SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pnn2.pnn01
#      LET g_term = l_pmk.pmk41 
#      IF cl_null(g_term) THEN 
#         SELECT pmc49 INTO g_term
#           FROM pmc_file 
#          WHERE pmc01 = g_pnn2.pnn05
#      END IF 
#      LET g_price = l_pmk.pmk20
#      IF cl_null(g_price) THEN 
#        SELECT pmc17 INTO g_price
#          FROM pmc_file 
#         WHERE pmc01 = g_pnn2.pnn05
#      END IF 
#      SELECT pmc47 INTO g_pmm.pmm21
#       FROM pmc_file
#      WHERE pmc01 =g_pnn2.pnn05   
#      SELECT gec04 INTO g_pmm.pmm43
#        FROM gec_file
#       WHERE gec01 = g_pmm.pmm21 
#         AND gec011 = '1'  #進項 TQC-B70212 add
#      #重新取價     
#      CALL s_defprice_new(g_pnn2.pnn03,g_pnn2.pnn05,g_pnn2.pnn06,tm3.purdate,g_pnn2.pnn37,'',
#                          g_pmm.pmm21,g_pmm.pmm43,"1",g_pnn2.pnn36,'',g_term,g_price,g_plant)
#               RETURNING g_pnn2.pnn10,g_pnn2.pnn10t,
#                         g_pmn.pmn73,g_pmn.pmn74
#   END IF
#   #MOD-B10092 add --end--
#TQC-BC0112 mark end
   LET g_pmn.pmn31 = g_pnn2.pnn10                #採購單價
   IF cl_null(g_pmn.pmn31) THEN
        LET g_pmn.pmn31 = 0.0
   END IF
   IF cl_null(g_pmm.pmm43) THEN
        SELECT pmm43 INTO g_pmm.pmm43 FROM pmm_file WHERE pmm01 = g_pmn.pmn01
        IF SQLCA.SQLCODE THEN LET g_pmm.pmm43 = 0.0 END IF
   END IF
 
   LET g_pmn.pmn31t = g_pnn2.pnn10t               #採購含稅單價
   LET g_pmn.pmn44 = 0                    
   IF g_pnn2.pnn11 = g_pml.pml34 THEN
      LET  g_pmn.pmn33 = g_pml.pml33
      LET  g_pmn.pmn34 = g_pml.pml34   
      LET  g_pmn.pmn35 = g_pml.pml35   
   ELSE
      IF cl_null(g_pnn2.pnn11) THEN
         LET  g_pmn.pmn34=g_pml.pml34
      ELSE
         LET  g_pmn.pmn34=g_pnn2.pnn11
      END IF
      IF g_pmn.pmn34 < g_pmm.pmm04 THEN
         LET g_pmn.pmn34 = g_pmm.pmm04
      END IF
      CALL s_aday(g_pmn.pmn34,-1,p_ima49) RETURNING g_pmn.pmn33
      CALL s_aday(g_pmn.pmn34,1,p_ima491) RETURNING g_pmn.pmn35
   END IF
   LET g_pmn.pmn38 = g_pml.pml38   #FUN-690047 add
   LET g_pmn.pmn44 = g_pmn.pmn31 * g_pmm.pmm42   #本幣單價
   LET g_pmn.pmn04 = g_pnn2.pnn03                
   LET g_pmn.pmn42 = g_pnn2.pnn13                #替代碼
   LET g_pmn.pmn919 = g_pnn2.pnn919         #FUN-A80150 add
   IF g_pmn.pmn42 IS NULL OR g_pmn.pmn42 = ' '
   THEN LET g_pmn.pmn42 = '0'
   END IF
   LET g_pmn.pmn62 = g_pnn2.pnn08                #替代率
   IF g_pmn.pmn62 IS NULL OR g_pmn.pmn62 = ' '
   THEN LET g_pmn.pmn62 = 1
   END IF
   LET g_pmn.pmn63='N'
   LET g_pmn.pmn64='N'
   LET g_pmn.pmn65='1'
   LET g_pmn.pmn50=0  
   LET g_pmn.pmn51=0  
   LET g_pmn.pmn53=0  
   LET g_pmn.pmn55=0  
   LET g_pmn.pmn57=0  
   LET g_pmn.pmn67 = g_pml.pml67
   LET g_pmn.pmn68 = g_pnn2.pnn18 #Blanket PO
   LET g_pmn.pmn69 = g_pnn2.pnn19 #Blanket PO
   LET g_pmn.pmn70 = g_pnn2.pnn20 #Blanket PO(轉換率)
   LET g_pmn.pmn930= g_pml.pml930 #成本中心 #FUN-670051 
   LET g_pmn.pmn122= g_pml.pml12   #No:8841
   IF cl_null(g_pmn.pmn122) THEN LET g_pmn.pmn122=' ' END IF    #No:8841
   LET g_pmn.pmn40 = g_pml.pml40
   LET g_pmn.pmn401 = g_pml.pml401
   LET g_pmn.pmn96 = g_pml.pml121
   LET g_pmn.pmn97 = g_pml.pml122
   LET g_pmn.pmn98 = g_pml.pml90
   LET g_pmn.pmn100 = g_pml.pml06  #FUN-D40042 備註
   LET g_pmn.pmn88  = g_pmn.pmn31  * g_pmn.pmn87   #未稅金額
   LET g_pmn.pmn88t = g_pmn.pmn31t * g_pmn.pmn87   #含稅金額
   SELECT gec07 INTO l_gec07 FROM gec_file  
    WHERE gec01 = g_pmm.pmm21 
      AND gec011 = '1'  #進項 TQC-B70212 add
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file 
    WHERE azi01=g_pmm.pmm22 AND aziacti = 'Y' 
   IF l_gec07 = 'N' THEN 
      LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
   ELSE
      LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
   END IF
   LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88,t_azi04)        #No.CHI-6A0004                                                            
   LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,t_azi04)       #No.CHI-6A0004                                                             
   SELECT ima35,ima36,ima15,ima39 INTO g_pmn.pmn52,g_pmn.pmn54,g_pmn.pmn64,g_pmn.pmn40 #CHI-840007 
      FROM ima_file WHERE ima01=g_pmn.pmn04
 
   #TQC-BC0132 begin add 
   SELECT pml123 INTO g_pmn.pmn123 FROM pml_file
    WHERE pml01 = g_pmn.pmn24
      AND pml02 = g_pmn.pmn25
   IF cl_null(g_pmn.pmn123) THEN    
      SELECT pmh07 INTO g_pmn.pmn123 FROM pmh_file
       WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
         AND pmh13 = g_pmm.pmm22
         AND pmh21 = " "                                             #CHI-860042                                                       
         AND pmh22 = '1'                                             #CHI-860042
         AND pmh23 = ' '                                             #CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021
   END IF 
   #TQC-BC0132 end add
   LET g_pmn.pmn90  = g_pmn.pmn31   #MOD-B10092 add   TQC-BC0112 can not mark  
  #MOD-B10092 mark --start--
  # SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
  # LET g_term = l_pmk.pmk41 
  # IF cl_null(g_term) THEN 
  #    SELECT pmc49 INTO g_term
  #      FROM pmc_file 
  #     WHERE pmc01 = g_pmm.pmm09
  # END IF 
  # LET g_price = l_pmk.pmk20
  # IF cl_null(g_price) THEN 
  #   SELECT pmc17 INTO g_price
  #     FROM pmc_file 
  #    WHERE pmc01 = g_pmm.pmm09
  # END IF 
  # SELECT pmc47 INTO g_pmm.pmm21
  #  FROM pmc_file
  # WHERE pmc01 =g_pmm.pmm09   
  # SELECT gec04 INTO g_pmm.pmm43
  #  FROM gec_file
  #   WHERE gec01 = g_pmm.pmm21 
  # CALL s_defprice_new(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_today,g_pmn.pmn87,'',
  #                     g_pmm.pmm21,g_pmm.pmm43,"1",g_pmn.pmn86,'',g_term,g_price,g_plant)
  #    RETURNING g_pmn.pmn90,l_pnn10t,
  #              g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
  # IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
  #                        
  # CALL p570_price_check(g_pmm.pmm09,g_pmn.pmn90,l_pnn10t)   #MOD-9C0285 ADD
  #  IF NOT cl_null(g_errno) THEN
  #     CALL cl_err('',g_errno,1)
  #  END IF
  #LET g_pmn.pmn90  = cl_digcut(g_pmn.pmn90,t_azi03)                                                               
  #MOD-B10092 mark --end--                                                              
 
   SELECT pmh24  INTO l_pmh24 FROM pmh_file 
     WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
       AND pmh13 = g_pmm.pmm22 AND pmh21 = " "
       AND pmh22 = '1' AND pmhacti = 'Y'
       AND pmh23 = ' '                                             #CHI-960033
   IF NOT cl_null(l_pmh24) THEN
      LET g_pmn.pmn89=l_pmh24
   ELSE
      SELECT pmc914 INTO l_pmc914 FROM pmc_file
        WHERE pmc01 = g_pmm.pmm09
      IF l_pmc914 = 'Y' THEN
        LET g_pmn.pmn89 = 'Y'
      ELSE
        LET g_pmn.pmn89 = 'N'
      END IF 
   END IF 
 
   IF cl_null(g_pmn.pmn01) THEN LET g_pmn.pmn01 = ' ' END IF
   IF cl_null(g_pmn.pmn02) THEN LET g_pmn.pmn02 = 0 END IF
  #LET g_pmn.pmn73 = ' '   #NO.FUN-960130                     #TQC-C40235 mark
   IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-C40235 add
   LET g_pmn.pmnplant = g_plant #FUN-980006 add
   LET g_pmn.pmnlegal = g_legal #FUN-980006 add
   IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF  #TQC-9B0203
   IF cl_null(g_pmn.pmn012) THEN LET g_pmn.pmn012 = ' ' END IF  #TQC-A70004
   CALL s_overate(g_pmn.pmn04) RETURNING g_pmn.pmn13   #MOD-A10164
   #-----CHI-B10018---------
   LET g_pmn.pmn06 = NULL
   SELECT pmh04 INTO g_pmn.pmn06 FROM pmh_file
           WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
             AND pmh13 = g_pmm.pmm22
             AND pmh21 = " "                                             
             AND pmh22 = '1'                                             
             AND pmh23 = ' '       
             AND pmhacti = 'Y'                                           
   #-----END CHI-B10018----- 
   CALL s_schdat_pmn78(g_pmn.pmn41,g_pmn.pmn012,g_pmn.pmn43,g_pmn.pmn18,   #FUN-C10002
                                   g_pmn.pmn32) RETURNING g_pmn.pmn78      #FUN-C10002
   INSERT INTO pmn_file VALUES(g_pmn.*)
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("ins","pmn_file","","",SQLCA.sqlcode,"","ins pmn",1)  #No.FUN-660129
      LET g_success = 'N'
   ELSE    #No.FUN-830132 
      INITIALIZE l_pmni.* TO NULL
      LET l_pmni.pmni01 = g_pmn.pmn01
      LET l_pmni.pmni02 = g_pmn.pmn02
      LET l_pmni.pmnislk01 = g_pnnislk01 #No.FUN-810017
#FUN-C30055---add-----------------
      IF g_azw.azw04 ='2' THEN
         SELECT DISTINCT(COALESCE(imx00,pmn04)) INTO l_pmni.pmnislk02 
          FROM pmn_file LEFT JOIN imx_file ON imx000=pmn04
           WHERE pmn01=g_pmn.pmn01
             AND pmn02=g_pmn.pmn02
      END IF
#FUN-C30055----end----------------
      IF NOT s_ins_pmni(l_pmni.*,'') THEN
         LET g_success = 'N'
      END IF
   END IF
 
   DECLARE pmo_curs CURSOR FOR
     SELECT * FROM pmo_file
       WHERE pmo01 = g_pmn.pmn24 AND pmo03 = g_pmn.pmn25
 
   FOREACH pmo_curs INTO g_pmo[g_ac].*
      IF STATUS THEN
         CALL cl_err('pmo_curs',STATUS,0)
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_pmo[g_ac].pmo01 = g_pmn.pmn01
      LET g_pmo[g_ac].pmo02 = '1'
      LET g_pmo[g_ac].pmo03 = g_pmn.pmn02
      LET g_ac = g_ac + 1
 
   END FOREACH
 
END FUNCTION
   
FUNCTION p570_pmmsum(p_pmm01)
 DEFINE  p_pmm01 LIKE pmm_file.pmm01, 
         l_tot   LIKE pmm_file.pmm40,
         lt_tot  LIKE pmm_file.pmm40t  #No.FUN-610018
 
#==>更新採購單上的總金額
   SELECT SUM(pmn88),SUM(pmn88t)     #MOD-730046 
     INTO l_tot,lt_tot
     FROM pmn_file
     WHERE pmn01 = p_pmm01
   IF l_tot > 0 THEN
      SELECT azi04 INTO t_azi04  #No.CHI-6A0004
        FROM azi_file
       WHERE azi01=g_pmm.pmm22
         AND aziacti ='Y'
      CALL cl_digcut(l_tot,t_azi04) RETURNING l_tot  #No.CHI-6A0004
      CALL cl_digcut(lt_tot,t_azi04) RETURNING lt_tot  #No.CHI-6A0004
      UPDATE pmm_file SET pmm40 = l_tot,
                          pmm40t= lt_tot
                    WHERE pmm01 = p_pmm01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pmm_file",p_pmm01,"",SQLCA.sqlcode,"","(p200: update pmm_file error)",1)  #No.FUN-660129
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION p570_s(p_ac)     #取替代料件處理 NO:3062 --- 1999/03/26
   DEFINE  p_ac,l_n       LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE  l_pnn09        LIKE pnn_file.pnn09
   DEFINE  l_gec04        LIKE gec_file.gec04     #No.FUN-550089
   DEFINE  l_pnn17        LIKE pnn_file.pnn17     #MOD-5B0333 add
   DEFINE  l_pnn30        LIKE pnn_file.pnn30     #MOD-5B0333 add
   DEFINE  l_pnn36        LIKE pnn_file.pnn36     #MOD-5B0333 add
   DEFINE  l_flag2        LIKE type_file.num5     #MOD-880151
   DEFINE  l_flag         LIKE type_file.chr1     #No.FUN-7B0018
   DEFINE  l_pnni         RECORD LIKE pnni_file.* #No.FUN-7B0018
 
   LET l_pnn09 = g_pnn[p_ac].pnn09
   
   SELECT COUNT(*) INTO l_n FROM pnn_file 
    WHERE pnn01=g_pml.pml01 AND pnn02=g_pml.pml02 
   IF l_n = 0  THEN RETURN  END IF
 
   IF g_pnn03_sub != g_pnn[p_ac].pnn03 OR cl_null(g_pnn[p_ac].pnn03) THEN    #MOD-880151
      LET l_n = l_n + 1 
      LET g_pnn[l_n].pnn13='S'
      LET g_pnn[l_n].pnn03=g_pnn03_sub 
      LET g_pnn[l_n].pnn08=g_pnn08_sub 
 
      DECLARE p570_s_cl CURSOR FOR 
        SELECT pmh02,pmh11,pmh12,pmh13 FROM pmh_file 
         WHERE pmh01 = g_pnn03_sub AND pmhacti = 'Y' 
           AND pmh21 = " "                                             #CHI-860042                                                  
           AND pmh22 = '1'                                             #CHI-860042
           AND pmh23 = ' '                                             #CHI-960033
           AND pmhacti = 'Y'                                           #CHI-910021
           AND pmh05 = '0'                                             #TQC-C10118
 
      OPEN p570_s_cl
      FETCH p570_s_cl INTO g_pnn[l_n].pnn05,g_pnn[l_n].pnn07,
                           g_pnn[l_n].pnn10,g_pnn[l_n].pnn06
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pnn[l_n].pnn05,SQLCA.sqlcode,1)
      END IF 
      CLOSE p570_s_cl 
 
      SELECT ima02,ima021,ima44,ima908  INTO     #MOD-5B0333 add
             g_pnn[l_n].ima02,g_pnn[l_n].ima021_1,g_pnn[l_n].pnn12,g_pnn[l_n].pnn36  #MOD-5B0333 add
        FROM ima_file    
       WHERE ima01=g_pnn03_sub 
      IF STATUS THEN  
         LET g_pnn[l_n].ima02 =''
         LET g_pnn[l_n].ima021_1 =''
      END IF 
      LET g_pnn[l_n].pnn30 = g_pnn[l_n].pnn12  #MOD-5B0333 add
      IF cl_null(g_pnn[l_n].pnn07) THEN LET g_pnn[l_n].pnn07 = 0 END IF
      LET g_pnn[l_n].pnn09 = g_pnn[p_ac].pnn09 * g_pnn[l_n].pnn08 
      LET g_pnn[l_n].pnn09 = s_digqty(g_pnn[l_n].pnn09,g_pnn[l_n].pnn12)   #FUN-910088--add--
      LET g_pnn[l_n].pnn32 = g_pnn[p_ac].pnn32 * g_pnn[l_n].pnn08
      LET g_pnn[l_n].pnn32 = s_digqty(g_pnn[l_n].pnn32,g_pnn[l_n].pnn30)   #FUN-910088--add--
      LET g_pnn[l_n].pnn35 = g_pnn[p_ac].pnn35 * g_pnn[l_n].pnn08
      LET g_pnn[l_n].pnn35 = s_digqty(g_pnn[l_n].pnn35,g_pnn[l_n].pnn33)   #FUN-910088--add--
      LET g_pnn[l_n].pnn37 = g_pnn[p_ac].pnn37 * g_pnn[l_n].pnn08
      LET g_pnn[l_n].pnn37 = s_digqty(g_pnn[l_n].pnn37,g_pnn[l_n].pnn36)   #FUN-910088--add--
      IF g_pnn[l_n].pnn09 = 0  THEN 
         INITIALIZE g_pnn[l_n].* TO NULL 
         RETURN  END IF 
 
      IF cl_null(g_pnn[l_n].pnn10) THEN LET g_pnn[l_n].pnn10 = 0 END IF
      LET g_pnn[l_n].pnn16 = 'Y' 
      LET g_pnn[l_n].pnn11 = g_pnn[p_ac].pnn11
 
      SELECT azi03 INTO t_azi03 FROM azi_file   #No.CHI-6A0004
       WHERE azi01 = g_pnn[l_n].pnn06
      LET g_pnn[l_n].pnn10 = cl_digcut(g_pnn[l_n].pnn10,t_azi03)  #No.CHI-6A0004
      SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
       WHERE gec01 = pmc47 AND pmc01 = g_pnn[l_n].pnn05
         AND gec011 = '1'  #進項 TQC-B70212 add
      IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF 
      LET g_pnn[l_n].pnn10t = g_pnn[l_n].pnn10 * ( 1 + l_gec04 / 100 )
      LET g_pnn[l_n].pnn10t = cl_digcut(g_pnn[l_n].pnn10t,t_azi03)  #No.CHI-6A0004
      LET g_pnn38  = g_pnn[l_n].pnn10 * g_pnn[l_n].pnn37
      LET g_pnn38t = g_pnn[l_n].pnn10t * g_pnn[l_n].pnn37
      CALL s_umfchk(g_pnn[l_n].pnn03,g_pnn[l_n].pnn12,g_pml.pml07)
          RETURNING l_flag2,l_pnn17 
      IF l_flag2 = 1 THEN                                                        
         LET l_pnn17=1                                                        
      END IF
      IF cl_null(g_pnn[l_n].pnn36) THEN 
         SELECT pml86 INTO g_pnn[l_n].pnn36 FROM pml_file
           WHERE pml01 = g_pml.pml01 AND pml02 = g_pml.pml02
         IF g_sma.sma116 MATCHES '[02]' THEN 
            LET g_pnn[l_n].pnn36 = g_pnn[l_n].pnn12
         END IF
      END IF
 
      INSERT INTO pnn_file(pnn01, pnn02, pnn03, pnn05, pnn06,
                           pnn07, pnn08, pnn09, pnn10, pnn11, pnn919,        #FUN-A80150 add pnn919
                           pnn12, pnn13, pnn14, pnn15, pnn16, pnn10t, pnn17, #MOD-5B0333 add
                           pnn30, pnn31, pnn32, pnn33, pnn34,
                           pnn35, pnn36, pnn37, pnn38, pnn38t,pnnplant,pnnlegal) #FUN-980006 add pnnplant,pnnlegal
       VALUES(g_pml.pml01,g_pml.pml02,
              g_pnn[l_n].pnn03,g_pnn[l_n].pnn05,
              g_pnn[l_n].pnn06,g_pnn[l_n].pnn07,
              g_pnn[l_n].pnn08,g_pnn[l_n].pnn09,
              g_pnn[l_n].pnn10,g_pnn[l_n].pnn11,
              g_pnn[l_n].pnn919,                   #FUN-A80150 add
              g_pnn[l_n].pnn12,g_pnn[l_n].pnn13,
              g_pnn[l_n].pnn03,g_pnn15,'Y',g_pnn[l_n].pnn10t,  #No.FUN-550089
              l_pnn17,        #MOD-5B0333 add
              g_pnn[l_n].pnn30,g_pnn[l_n].pnn31,
              g_pnn[l_n].pnn32,g_pnn[l_n].pnn33,
              g_pnn[l_n].pnn34,g_pnn[l_n].pnn35,
              g_pnn[l_n].pnn36,g_pnn[l_n].pnn37,
              g_pnn38,g_pnn38t,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","pnn_file",g_pnn[l_n].pnn03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
          INITIALIZE g_pnn[l_n].* TO NULL
       ELSE 
         LET g_pnn[p_ac].pnn09 = 0 
         UPDATE pnn_file SET pnn09=0 
          WHERE pnn01 = g_pml.pml01  AND 
                pnn02 = g_pml.pml02  AND 
                pnn03 = g_pnn[p_ac].pnn03  AND 
                pnn05 = g_pnn[p_ac].pnn05   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","pnn_file",g_pnn[p_ac].pnn03,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
          ELSE 
             INITIALIZE l_pnni.* TO NULL
             LET l_pnni.pnni01 = g_pml.pml01
             LET l_pnni.pnni02 = g_pml.pml02
             LET l_pnni.pnni03 = g_pnn[l_n].pnn03
             LET l_pnni.pnni05 = g_pnn[l_n].pnn05
             LET l_pnni.pnni06 = g_pnn[l_n].pnn06
             LET l_flag = s_ins_pnni(l_pnni.*,'')
             MESSAGE '(SUB)insert pnn_file OK! update pnn_file OK !' 
          END IF 
       END IF 
   END IF                        
END FUNCTION 
 
#update 請購單身之已轉採購數量及狀況碼
FUNCTION  p570_pml(p_pmn24,p_pmn25)
  DEFINE p_pmn24   LIKE pmn_file.pmn24
  DEFINE p_pmn25   LIKE pmn_file.pmn25
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pmn20   LIKE pmn_file.pmn20
  DEFINE l_pmn62   LIKE pmn_file.pmn62
  DEFINE l_pmn121  LIKE pmn_file.pmn121
  DEFINE l_pml07   LIKE pml_file.pml07  #FUN-BB0084
  DEFINE l_sql     STRING               #No.MOD-690047 add
 
      LET l_sum=0
 
      LET l_sql = " SELECT pmn20,pmn62,pmn121 FROM pmn_file ",
                  " WHERE pmn24='",p_pmn24 CLIPPED,"'",
                 #" AND pmn25='",p_pmn25 CLIPPED,"'",      #TQC-AB0041
                  " AND pmn25=",p_pmn25 CLIPPED,           #TQC-AB0041
                  " AND pmn16<>'9' "
      PREPARE p570_prepare3 FROM l_sql
      DECLARE p570_cur3 CURSOR FOR p570_prepare3
      FOREACH p570_cur3 INTO l_pmn20,l_pmn62,l_pmn121
         IF SQLCA.sqlcode THEN 
            LET g_success = 'N'
            CALL cl_err('UPDATE pml21 error',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_pmn62) THEN
            LET l_pmn62 = 1
         END IF
         IF cl_null(l_pmn121) THEN
            LET l_pmn121 = 1
         END IF
         LET l_sum = l_sum + (l_pmn20/l_pmn62*l_pmn121)
      END FOREACH
#FUN-BB0084 --------------Begin----------------
      SELECT pml07 INTO l_pml07 FROM pml_file
       WHERE pml01=p_pmn24 AND pml02=p_pmn25
      LET l_sum = s_digqty(l_sum,l_pml07)
#FUN-BB0084 --------------End------------------      
      UPDATE pml_file SET pml16='2',pml21=l_sum
       WHERE pml01=p_pmn24 AND pml02=p_pmn25
         AND pml92<>'Y'       #FUN-A10034
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pml_file",p_pmn24,p_pmn25,SQLCA.sqlcode,"","upd pml",1)  #No.FUN-660129
         RETURN
      END IF
END FUNCTION
 
#update Blanket PO單身之已轉採購數量及狀況碼
FUNCTION p570_pon(p_pmn68,p_pmn69)
  DEFINE p_pmn68   LIKE pmn_file.pmn68
  DEFINE p_pmn69   LIKE pmn_file.pmn69
  DEFINE l_pon20   LIKE pon_file.pon20
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pon07   LIKE pon_file.pon07   #FUN-BB0085

      #NO.FUN-A80001--begin
      IF g_pmm.pmm04>g_pon.pon19 THEN 
         CALL cl_err('','apm-815',1)  
         LET g_success='N'
         RETURN 
      END IF 
      #NO.FUN-A80001--end  
      LET l_sum=0
      #數量/替代率*對請購換算率
      SELECT SUM(pmn20/pmn62*pmn70) INTO l_sum FROM pmn_file
       WHERE pmn68=p_pmn68 AND pmn69=p_pmn69
         AND pmn16<>'9'    #取消(Cancel)
      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
      #是否超過未轉量
      SELECT pon20 INTO l_pon20 FROM pon_file
       WHERE pon01 = p_pmn68 AND pon02 = p_pmn69
      IF cl_null(l_pon20) THEN LET l_pon20 = 0 END IF
      IF l_pon20 - l_sum < 0 THEN
         LET g_success='N'
          CALL cl_err('','apm-905',1)   #No.MOD-4A0356
         RETURN
      END IF
      #FUN-BB0085-add-str--
      SELECT pon07 INTO l_pon07 FROM pon_file 
       WHERE pon01=p_pmn68 AND pon02=p_pmn69
      LET l_sum = s_digqty(l_sum,l_pon07)
      #FUN-BB0085-add-end--
      #UPDATE 單身狀況碼及已轉量
      UPDATE pon_file SET pon16='2',pon21=l_sum
       WHERE pon01=p_pmn68 AND pon02=p_pmn69
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pon_file",p_pmn68,p_pmn69,SQLCA.sqlcode,"","upd pon",1)  #No.FUN-660129
         RETURN
      END IF
      #UPDATE 單頭狀況碼
      UPDATE pom_file SET pom25='2'  
        WHERE pom01=p_pmn68 AND pom01 NOT IN
             (SELECT pon01 FROM pon_file WHERE pon01=p_pmn68
                          AND pon16 NOT IN ('2'))
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pom_file",p_pmn68,"",SQLCA.sqlcode,"","upd pom",1)  #No.FUN-660129
         RETURN
      END IF
END FUNCTION
 
FUNCTION p570_available_qty(p_flag) #MOD-B30399 add p_flag 
DEFINE    l_sum           LIKE pml_file.pml20,
          l_over          LIKE pml_file.pml20,     #No.FUN-680136 DECIMAL(13,3)
          l_k             LIKE type_file.num5,     #檢查重複用  #No.FUN-680136 SMALLINT
          l_ima07         LIKE  ima_file.ima07
DEFINE    l_pnn           RECORD LIKE pnn_file.*   #MOD-880151
DEFINE    l_pml09         LIKE pml_file.pml09   #MOD-940133
DEFINE    p_flag          LIKE type_file.chr1   #MOD-B30399 add  
DEFINE    l_flag2         LIKE type_file.num5   #MOD-B30399 add  
DEFINE    l_pnn17         LIKE pnn_file.pnn17   #MOD-B30399 add

    LET l_sum = 0
    IF p_flag = '1' THEN #MOD-B30399 add
       LET g_sql =
           "SELECT * FROM pnn_file ",
           "  WHERE  pnn01 ='",g_pml.pml01,"'",
           "    AND  pnn02 ='",g_pml.pml02,"'"
    #MOD-B30399 add --start--
    ELSE
       LET g_sql =
           "SELECT * FROM pnn_file ",
           "  WHERE  pnn01 ='",g_pml.pml01,"'",
           "    AND  pnn02 ='",g_pml.pml02,"'",
           "    AND  pnn01 NOT IN (SELECT pnn01 FROM pnn_file ",
           "                        WHERE  pnn01 ='",g_pml.pml01,"'",
           "                          AND  pnn02 ='",g_pml.pml02,"'",
           "                          AND  pnn03 ='",g_pnn[l_ac].pnn03,"'",
           "                          AND  pnn05 ='",g_pnn[l_ac].pnn05,"'",
           "                          AND  pnn06 ='",g_pnn[l_ac].pnn06,"')"
    END IF
    #MOD-B30399 add --end--

    PREPARE p570_pb2 FROM g_sql
    DECLARE pnn_curs2 CURSOR FOR p570_pb2                 
    FOREACH pnn_curs2 INTO l_pnn.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_pnn.pnn03 IS NULL OR l_pnn.pnn03 = ' '
          THEN EXIT FOREACH
        END IF
        IF l_pnn.pnn08 IS NULL THEN
           LET l_pnn.pnn08=1
        END IF
        SELECT pml09 INTO l_pml09 FROM pml_file
          WHERE pml01 = g_pml.pml01
            AND pml02 = g_pml.pml02
        LET l_sum = l_sum + ((l_pnn.pnn09/l_pnn.pnn08*l_pnn.pnn17)*l_pml09)
    END FOREACH   
    #TQC-C70202 -- add -- begin
    IF (g_pnn[l_ac].pnn03<>g_pnn_t.pnn03) OR 
       (g_pnn[l_ac].pnn05<>g_pnn_t.pnn05) OR 
       (g_pnn[l_ac].pnn06<>g_pnn_t.pnn06) THEN
       LET l_sum = l_sum - ((g_pnn_t.pnn09/g_pnn_t.pnn08*l_pnn.pnn17)*g_pml.pml09)
    END IF
    #TQC-C70202 -- add -- end
    #MOD-B30399 add --start--
    IF p_flag = '2' THEN
       CALL s_umfchk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn12,g_pml.pml07)
           RETURNING l_flag2,l_pnn17 
       IF l_flag2 = 1 THEN                                                        
          LET l_pnn17=1                                                        
       END IF
       LET l_sum = l_sum + ((g_pnn[l_ac].pnn09/g_pnn[l_ac].pnn08*l_pnn17)*g_pml.pml09)
    END IF
    #MOD-B30399 add --end--
 
    SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
     WHERE ima01=g_pml.pml04
    CASE
       WHEN l_ima07='A'  #計算可容許的數量
            LET l_over=g_pml.pml20 * (g_sma.sma341/100)
       WHEN l_ima07='B'
            LET l_over=g_pml.pml20 * (g_sma.sma342/100)
       WHEN l_ima07='C'
            LET l_over=g_pml.pml20 * (g_sma.sma343/100)
       OTHERWISE
            LET l_over=0
    END CASE
    LET g_pml.pml20 = g_pml.pml20 * g_pml.pml09   #MOD-940133
    LET l_over = l_over * g_pml.pml09   #MOD-940133
 
    SELECT pml21*pml09 INTO g_pml.pml21 FROM pml_file    #MOD-940133
      WHERE pml01 = g_pml.pml01
        AND pml02 = g_pml.pml02
    IF l_sum > (g_pml.pml20 - g_pml.pml21)+l_over THEN 
        CALL cl_err(g_pml.pml01,'mfg3528',0)
          IF g_sma.sma33='R'    #reject
             THEN
             RETURN -1
          END IF
    END IF
    RETURN 0
END FUNCTION
 
FUNCTION p570_pmc01() #NO:6998
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
          LET g_errno = ""
          SELECT pmc03,pmcacti INTO tm.pmc03,l_pmcacti FROM pmc_file
           WHERE pmc01 = tm.pmc01
          CASE
              WHEN SQLCA.sqlcode=100   LET g_errno  ='aap-000' #無此供應廠商, 請重新輸入!
                                       LET tm.pmc03  = NULL
                                       LET l_pmcacti=NULL
              WHEN l_pmcacti='N'       LET g_errno='9028'
              WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
              OTHERWISE
                   LET g_errno=SQLCA.sqlcode USING '------'
          END CASE
          DISPLAY BY NAME tm.pmc03
END FUNCTION
FUNCTION p570_pnn05_1() #NO:6998
   DEFINE l_pmcacti LIKE pmc_file.pmcacti,
          l_gec07   LIKE gec_file.gec07  #No.FUN-610018
 
          LET g_errno = ""
          SELECT pmc03,pmcacti,pmc47
            INTO g_pnn[l_ac].pmc03,l_pmcacti,g_pnn[l_ac].pmc47
             FROM pmc_file                            #MOD-4A0327
           WHERE pmc01 = g_pnn[l_ac].pnn05
          CASE
              WHEN SQLCA.sqlcode=100   LET g_errno  ='aap-000' #無此供應廠商, 請重新輸入!
                                       LET l_pmcacti=NULL
              WHEN l_pmcacti='N'       LET g_errno='9028'
              WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
              OTHERWISE
                   LET g_errno=SQLCA.sqlcode USING '------'
          END CASE
          IF g_pnn[l_ac].pmc47 IS NULL THEN
             SELECT pmk21 INTO g_pnn[l_ac].pmc47 
               FROM pmk_file
              WHERE pmk01 = g_pml.pml01
          END IF
 
          SELECT azi03 INTO t_azi03 FROM azi_file  #No.CHI-6A0004
           WHERE azi01 = g_pnn[l_ac].pnn06
          SELECT gec04,gec07 INTO g_pnn[l_ac].gec04,l_gec07   #No.FUN-610018
            FROM gec_file
           WHERE gec01 = g_pnn[l_ac].pmc47
             AND gec011 = '1'  #進項 TQC-B70212 add
          #Add No.TQC-B10036
          IF SQLCA.sqlcode THEN
            #LET g_errno = 'mfg3044'
             LET g_errno = 'art-493'  #TQC-B70212 mod
          END IF
          #End Add No.TQC-B10036
 
          IF l_gec07 = 'N' THEN
             CALL cl_set_comp_entry("pnn10t",FALSE)
          ELSE
             CALL cl_set_comp_entry("pnn10",FALSE)
          END IF
END FUNCTION
 
FUNCTION p570_set_entry_b()
 
   CALL cl_set_comp_entry("pnn10,pnn10t",TRUE) 
   CALL cl_set_comp_entry("pnn32,pnn35,pnn37",TRUE)
 
END FUNCTION
 
FUNCTION p570_set_no_entry_b()
 
   DEFINE l_gec07 LIKE gec_file.gec07
   SELECT gec07 INTO l_gec07   #No.FUN-610018
     FROM gec_file
    WHERE gec01 = g_pnn[l_ac].pmc47
      AND gec011 = '1'  #進項 TQC-B70212 add
   IF cl_null(l_gec07) THEN LET l_gec07 = 'N' END IF
   IF l_gec07 = 'N' THEN
      CALL cl_set_comp_entry("pnn10t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pnn10",FALSE)
   END IF
   IF g_ima906 = '1' THEN                                                      
      CALL cl_set_comp_entry("pnn35",FALSE)
   END IF    
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("pnn36,pnn37",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION p570_set_required()
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN                                                     
      CALL cl_set_comp_required("pnn35,pnn32",TRUE)                                    
   END IF
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_pnn[l_ac].pnn30) THEN
      CALL cl_set_comp_required("pnn32",TRUE)   
   END IF
   IF NOT cl_null(g_pnn[l_ac].pnn33) THEN
      CALL cl_set_comp_required("pnn35",TRUE)
   END IF                                                    
   IF NOT cl_null(g_pnn[l_ac].pnn36) THEN
      CALL cl_set_comp_required("pnn37",TRUE)
   END IF
END FUNCTION
 
FUNCTION p570_set_no_required()                                                 
                                                                                
  CALL cl_set_comp_required("pnn35,pnn32,pnn37",FALSE)                                      
                                                                                
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION p570_du_data_to_correct()
 
   IF cl_null(g_pnn[l_ac].pnn30) THEN 
      LET g_pnn[l_ac].pnn31 = NULL
      LET g_pnn[l_ac].pnn32 = NULL
   END IF
   
   IF cl_null(g_pnn[l_ac].pnn33) THEN 
      LET g_pnn[l_ac].pnn34 = NULL
      LET g_pnn[l_ac].pnn35 = NULL
   END IF   
 
   IF cl_null(g_pnn[l_ac].pnn36) THEN
      LET g_pnn[l_ac].pnn37 = NULL
   END IF
 
   DISPLAY BY NAME g_pnn[l_ac].pnn31
   DISPLAY BY NAME g_pnn[l_ac].pnn32
   DISPLAY BY NAME g_pnn[l_ac].pnn34
   DISPLAY BY NAME g_pnn[l_ac].pnn35
   DISPLAY BY NAME g_pnn[l_ac].pnn36
   DISPLAY BY NAME g_pnn[l_ac].pnn37
 
END FUNCTION
 
FUNCTION p570_set_pnn37()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pnn[l_ac].pnn03
    IF SQLCA.sqlcode =100 THEN                                                  
       IF g_pnn[l_ac].pnn03 MATCHES 'MISC*' THEN                                
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906               
            FROM ima_file WHERE ima01='MISC'                                    
       END IF                                                                   
    END IF                                                                      
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pnn[l_ac].pnn34
       LET l_qty2=g_pnn[l_ac].pnn35
       LET l_fac1=g_pnn[l_ac].pnn31
       LET l_qty1=g_pnn[l_ac].pnn32
    ELSE
       LET l_fac1=1 
       LET l_qty1=g_pnn[l_ac].pnn09
       CALL s_umfchk(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn12,l_ima44)               
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
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_pnn[l_ac].pnn03,l_ima44,g_pnn[l_ac].pnn36)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN 
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_pnn[l_ac].pnn37 = l_tot
    LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)   #FUN-910088--add--
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION p570_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pnn_file.pnn34,
            l_qty2   LIKE pnn_file.pnn35,
            l_fac1   LIKE pnn_file.pnn31,
            l_qty1   LIKE pnn_file.pnn32,
            l_factor LIKE ima_file.ima31_fac,  #No.FUN-680136 DECIMAL(16,8)
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima44 INTO l_ima25,l_ima44 
      FROM ima_file WHERE ima01=g_pnn[l_ac].pnn03
    IF SQLCA.sqlcode = 100 THEN                                                 
       IF g_pnn[l_ac].pnn03 MATCHES 'MISC*' THEN                                
          SELECT ima25,ima44 INTO l_ima25,l_ima44                               
            FROM ima_file WHERE ima01='MISC'                                    
       END IF                                                                   
    END IF                                                                      
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_pnn[l_ac].pnn34
    LET l_qty2=g_pnn[l_ac].pnn35
    LET l_fac1=g_pnn[l_ac].pnn31
    LET l_qty1=g_pnn[l_ac].pnn32
    
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_pnn[l_ac].pnn09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2 
                   LET g_pnn[l_ac].pnn09=l_tot
          WHEN '3' LET g_pnn[l_ac].pnn09=l_qty1
                   IF l_qty2 <> 0 THEN                                          
                      LET g_pnn[l_ac].pnn34=l_qty1/l_qty2                      
                   ELSE                                                         
                      LET g_pnn[l_ac].pnn34=0                                  
                   END IF
       END CASE
       LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)    #FUN-910088--add--
    END IF
 
    IF cl_null(g_pnn[l_ac].pnn36) THEN
       LET g_pnn[l_ac].pnn36 = g_pnn[l_ac].pnn12
       LET g_pnn[l_ac].pnn37 = g_pnn[l_ac].pnn09
    END IF
END FUNCTION
 
FUNCTION p570_check_inventory_qty()
DEFINE   t_pnn10         LIKE pnn_file.pnn10
DEFINE   t_pnn10t        LIKE pnn_file.pnn10t    #No.FUN-610018
DEFINE   l_pmk           RECORD LIKE pmk_file.*   #No.FUN-930148
 
   IF NOT cl_null(g_pnn[l_ac].pnn09) THEN 
      IF g_pnn[l_ac].pnn09 < 1 THEN
         LET g_pnn[l_ac].pnn09 = g_pnn_t.pnn09 
         RETURN 1
      END IF 
      IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN #No.FUN-550089
        #SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
         SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01  #TQC-B80055 mod
         LET g_term = l_pmk.pmk41 
         IF cl_null(g_term) THEN 
            SELECT pmc49 INTO g_term
              FROM pmc_file 
             WHERE pmc01 = g_pnn[l_ac].pnn05
         END IF 
         LET g_price = l_pmk.pmk20
         IF cl_null(g_price) THEN 
            SELECT pmc17 INTO g_price
              FROM pmc_file 
             WHERE pmc01 = g_pnn[l_ac].pnn05
         END IF   
         SELECT pmc47 INTO g_pmm.pmm21
         FROM pmc_file
         WHERE pmc01 =g_pnn[l_ac].pnn05
         SELECT gec04 INTO g_pmm.pmm43
           FROM gec_file
          WHERE gec01 = g_pmm.pmm21  
            AND gec011 = '1'  #進項 TQC-B70212 add

         CALL s_defprice_new(g_pnn[l_ac].pnn03,g_pnn[l_ac].pnn05,
                         g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant) 
            RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                      g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
        #CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t)   #MOD-9C0285 ADD
         CALL p570_price_check(g_pnn[l_ac].pnn05,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term)   #MOD-9C0285 ADD  #TQC-B80055 mod
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
           END IF
         IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
         LET t_pnn10 = g_pnn[l_ac].pnn10
         LET t_pnn10t= g_pnn[l_ac].pnn10t   #No.FUN-610018
         IF NOT cl_null(g_pnn[l_ac].pnn18) AND 
            NOT cl_null(g_pnn[l_ac].pnn19) THEN
            SELECT * INTO g_pon.* FROM pon_file 
             WHERE pon01 = g_pnn[l_ac].pnn18
               AND pon02 = g_pnn[l_ac].pnn19
 
            CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t) 
               RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
         END IF
         CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10  #No.CHI-6A0004
         CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
         CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t  #No.CHI-6A0004
      END IF      
   END IF 
   
   RETURN 0
END FUNCTION
 
FUNCTION p570_def_form() 
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pnn33,pnn35,pnn30,pnn32",FALSE)
      CALL cl_set_comp_visible("pnn09,pnn12",TRUE)
   ELSE
      CALL cl_set_comp_visible("pnn09,pnn12",FALSE)
      CALL cl_set_comp_visible("pnn33,pnn35,pnn30,pnn32",TRUE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn33",g_msg CLIPPED)   
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn35",g_msg CLIPPED)   
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn30",g_msg CLIPPED)   
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn32",g_msg CLIPPED)   
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn33",g_msg CLIPPED)   
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn35",g_msg CLIPPED)   
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn30",g_msg CLIPPED)   
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg                         
      CALL cl_set_comp_att_text("pnn32",g_msg CLIPPED)   
   END IF
   CALL cl_set_comp_visible("pnn31,pnn34",FALSE)
   IF g_sma.sma116 MATCHES '[02]' THEN    
       CALL cl_set_comp_visible("pnn36,pnn37",FALSE)
   END IF
END FUNCTION
 
FUNCTION p570_refresh_detail()                                                                                                      
  DEFINE l_compare          LIKE smy_file.smy62                                                                                     
  DEFINE li_col_count       LIKE type_file.num5     #No.FUN-680136 SMALLINT                                                                                                
  DEFINE li_i, li_j         LIKE type_file.num5     #No.FUN-680136 SMALLINT                                                                                                
  DEFINE lc_agb03           LIKE agb_file.agb03                                                                                     
  DEFINE lr_agd             RECORD LIKE agd_file.*                                                                                  
  DEFINE lc_index           STRING                                                                                                  
  DEFINE ls_combo_vals      STRING                                                                                                  
  DEFINE ls_combo_txts      STRING                                                                                                  
  DEFINE ls_sql             STRING                                                                                                  
  DEFINE ls_show,ls_hide    STRING                                                                                                  
  DEFINE l_gae04            LIKE gae_file.gae04 
 
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組                                                                           
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND (NOT cl_null(lg_smy62)) THEN
     #顯示什麼組別的信息，如果有單身，則進行下面的邏輯判斷                                                                          
     IF g_pnn.getLength() = 0 THEN                                                                                                  
        LET lg_group = lg_smy62                                                                                                     
     ELSE                              
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的                                                      
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況                                                      
       #則返回一個NULL，下面將不顯示任明細屬性列                                                                                    
       FOR li_i = 1 TO g_pnn.getLength()                                                                                            
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了                                                    
         #則不進行下面判斷直接退出了                                                                                                
         IF  cl_null(g_pnn[li_i].att00) THEN                                                                                        
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF                                                                                                                     
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pnn[li_i].att00
         #第一次是賦值                                                                                                              
         IF cl_null(lg_group) THEN                                                                                                  
            LET lg_group = l_compare                                                                                                
         #以后是比較                                                                                                                
         ELSE                                                                                                                       
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)                                                               
           IF l_compare <> lg_group THEN                                                                                            
              LET lg_group = ''                                                                                                     
              EXIT FOR                                                                                                              
           END IF                                                                                                                   
         END IF                                                                                                                     
       END FOR                                                                                                                      
     END IF           
 
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group 
     SELECT gae04 INTO l_gae04 FROM gae_file                                                                                        
       WHERE gae01 = g_prog AND gae02 = 'pnn03' AND gae03 = g_lang                                                                  
     CALL cl_set_comp_att_text("att00",l_gae04)
     IF NOT cl_null(lg_group) THEN                                                                                                  
        LET ls_hide = 'pnn03'                                                                                                 
        LET ls_show = 'att00'                                                                                                       
     ELSE                                                                                                                           
        LET ls_hide = 'att00'                                                                                                       
        LET ls_show = 'pnn03'                                                                                                 
     END IF           
     CALL lr_agc.clear()
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    LET li_i = 1
    LET ls_hide = 'att00'
    LET ls_show = 'pnn03'
  END IF
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#-------------------------料件多屬性修改--------------
#--------------具體細節請閱讀saxmt400.4gl-------------
 
FUNCTION p570_check_pnn03(p_field,p_ac,p_cmd) #No.MOD-660090                                                                                            
DEFINE                                                                                                                              
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,     #No.FUN-680136 SMALLINT  #g_pnn數組中的當前記錄下標                                                                 
                                                                                                                                    
  l_ps                        LIKE sma_file.sma46,                                                                                  
  l_str_tok                   base.stringTokenizer,                                                                                 
  l_tmp, ls_sql               STRING,                                                                                               
  l_param_list                STRING,                                                                                               
  l_cnt, li_i                 LIKE type_file.num5,     #No.FUN-680136 SMALLINT                                                                                             
  ls_value                    STRING,                                                                                               
  ls_pid,ls_value_fld         LIKE ima_file.ima01,                                                                                  
  ls_name, ls_spec            STRING,                                                                                               
  lc_agb03                    LIKE agb_file.agb03,                                                                                  
  lc_agd03                    LIKE agd_file.agd03,                                                                                  
  ls_pname                    LIKE ima_file.ima02,                                                                                  
  l_misc                      LIKE gfe_file.gfe01,     #No.FUN-680136 VARCHAR(04)                                                                                          
  l_n                         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
  l_oeb06                     LIKE oeb_file.oeb06,
  l_b2                        LIKE ima_file.ima31,                                                                                  
  l_ima130                    LIKE ima_file.ima130,                                                                                 
  l_ima131                    LIKE ima_file.ima131,                                                                                 
  l_ima25                     LIKE ima_file.ima25,                                                                                  
  l_imaacti                   LIKE ima_file.imaacti,                                                                                
  l_qty                       LIKE type_file.num10,    #No.FUN-680136 INTEGER                                                                                              
  l_nul                       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
  p_cmd                       LIKE type_file.chr1   #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
DEFINE l_flag                 LIKE type_file.chr1   #No.FUN-7B0018
 
  IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR                                                          
     ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR                                                          
     ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR                                                          
     ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN 
 
     LET ls_pid = g_pnn[p_ac].att00   # ls_pid 父料件編號                                                                           
     LET ls_value = g_pnn[p_ac].att00   # ls_value 子料件編號                                                                       
     IF cl_null(ls_pid) THEN   
        CALL p570_set_no_entry_b()  
        CALL p570_set_required()   
        RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
     END IF 
     #取出當前母料件包含的明細屬性的個數                                                                                            
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =                                                                         
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)                                                                           
     IF l_cnt = 0 THEN                                                                                                              
        CALL p570_set_no_entry_b()                                                                                                  
        CALL p570_set_required()                                                                                                    
         RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF      
     FOR li_i = 1 TO l_cnt                                                                                                          
         #如果有任何一個明細屬性應該輸而沒有輸的則退出                                                                              
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
            CALL p570_set_no_entry_b()                                                                                     
            CALL p570_set_required()                                                                                                
            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti  
         END IF                                                                                                                     
     END FOR  
     #得到系統定義的標准分隔符sma46                                                                                                 
     SELECT sma46 INTO l_ps FROM sma_file 
     #合成子料件的名稱                                                                                                              
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱                                                                
       WHERE ima01 = ls_pid                                                                                                         
     LET ls_spec = ls_pname  # ls_spec 子料件名稱  
     FOR li_i = 1 TO l_cnt                                                                                                          
         LET lc_agd03 = ""                                                                                                          
         LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]                                                           
         SELECT agd03 INTO lc_agd03 FROM agd_file                                                                                   
          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
         IF cl_null(lc_agd03) THEN                                                                                                  
            LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]                                                            
         ELSE                                                                                                                       
            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03                                                                              
         END IF                                                                                                                     
     END FOR     
     #解析ls_value生成要傳給cl_copy_bom的那個l_param_list                                                                           
     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)                                                                     
     LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉                                                                  
                                                                                                                                    
     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",                                                                     
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",                                                                
                  "ORDER BY agb02"                                                                                                  
     DECLARE param_curs CURSOR FROM ls_sql                                                                                          
     FOREACH param_curs INTO lc_agb03                                                                                               
       #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致                                                                 
       IF cl_null(l_param_list) THEN                                                                                                
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()                                                                
       ELSE                                                                                                                         
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
       END IF                                                                                                                       
     END FOREACH 
     #調用cl_copy_ima將新生成的子料件插入到數據庫中                                                                                 
     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN         
        #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去                
        LET ls_value_fld = ls_value                                             
        INSERT INTO imx_file VALUES(ls_value_fld,ls_pid,arr_detail[p_ac].imx[1],                                                    
          arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4], 
          arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
          arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10])
        #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証                                                    
        #記錄的完全同步                                                                                                             
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err3("ins","imx_file",ls_value_fld,ls_pid,SQLCA.sqlcode,
                        "","Failure to insert imx_file , rollback insert to ima_file !",1)  #No.FUN-660129
           DELETE FROM ima_file WHERE ima01 = ls_value_fld
           IF s_industry('icd') THEN				
              LET l_flag = s_del_imaicd(ls_value_fld,'')
           END IF						
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
        END IF                                                                                                                      
     END IF   
     LET g_pnn[p_ac].pnn03 = ls_value                                                                                               
  ELSE                                                                                                                              
    IF ( p_field <> 'pnn03' )AND( p_field <> 'imx00' ) THEN                                                                         
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
    END IF                                                                                                                          
  END IF                      
 
  IF NOT cl_null(g_pnn[l_ac].pnn03) THEN  
 
     IF cl_null(lg_smy62) THEN                                                                                                      
       IF g_sma.sma120 = 'Y' THEN                                                                                                   
          CALL cl_itemno_multi_att("pnn03",g_pnn[l_ac].pnn03,"","1","9") 
               RETURNING l_nul,g_pnn[l_ac].pnn03,l_oeb06
          DISPLAY g_pnn[l_ac].pnn03 TO pnn03                                                                                        
       END IF                                                                                                                       
     END IF                
     #-->原料件不可被替代
     IF g_pml.pml42 = '0' THEN 
        IF g_pnn[l_ac].pnn03 != g_pml.pml04 THEN 
           CALL cl_err(g_pnn[l_ac].pnn03,'mfg3529',0)
            RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
        END IF
     END IF
     #-->替代料件檢查 
     IF g_pnn[l_ac].pnn03 != g_pml.pml04 THEN 
        CALL p570_pnn03(p_cmd)
        IF NOT cl_null(g_errno) THEN
           CALL cl_err('',g_errno,0)
           LET g_pnn[l_ac].pnn03=g_pnn_t.pnn03
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
        END IF
     END IF
     CALL p570_ima02(p_cmd)
     IF NOT cl_null(g_errno) THEN
        CALL cl_err('',g_errno,0)
        LET g_pnn[l_ac].pnn03=g_pnn_t.pnn03
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
     END IF
     RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  ELSE
     IF ( p_field = 'pnn03' )OR( p_field = 'imx00' ) THEN   
        CALL p570_set_no_entry_b() 
        CALL p570_set_required() 
        CALL p570_ima02(p_cmd)
         RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     ELSE 
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
     END IF
  END IF
END FUNCTION  
 
FUNCTION p570_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE                                                                                                                              
  p_value      LIKE imx_file.imx01,                                                                                                 
  p_index      LIKE type_file.num5,     #No.FUN-680136 SMALLINT                                                                                                            
  p_row        LIKE type_file.num5,                                                                                                                #No.FUN-680136 SMALLINT
  li_min_num   LIKE agc_file.agc05,                                                                                                 
  li_max_num   LIKE agc_file.agc06,                                                                                                 
  l_index      STRING,                                                                                                              
  p_cmd        LIKE type_file.chr1,     #No.MOD-660090                                                                                                                                      #No.FUN-680136 VARCHAR(1)
  l_check_res  LIKE type_file.num5,     #No.FUN-680136 SMALLINT                                                                                                         
  l_b2         LIKE ima_file.ima133,    #No.FUN-680136 VARCHAR(30)                                                                                                         
  l_imaacti    LIKE ima_file.imaacti,                                                                                            
  l_ima130     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)                                                                                                          
  l_ima131     LIKE ima_file.ima131,    #No.FUN-680136 VARCHAR(10)                                                                                                         
  l_ima25      LIKE ima_file.ima25 
 
  IF cl_null(p_value) THEN                                                                                                          
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                      
  END IF 
 
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN                                                                          
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)                                                                          
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                      
  END IF  
 
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL p570_check_pnn03('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
#FUN-910088--add--start--
  LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)
  LET g_pnn[l_ac].pnn32 = s_digqty(g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn30)
  LET g_pnn[l_ac].pnn35 = s_digqty(g_pnn[l_ac].pnn35,g_pnn[l_ac].pnn33)
  LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)  
#FUN-910088--add--end--
END FUNCTION
 
FUNCTION p570_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_index  STRING,
  p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
  l_check_res     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2            LIKE ima_file.ima133,   #No.FUN-680136 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) 
  l_ima131        LIKE ima_file.ima131,   #No.FUN-680136 VARCHAR(10)
  l_ima25         LIKE ima_file.ima25
 
  IF cl_null(p_value) THEN 
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF    
 
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL p570_check_pnn03('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
#FUN-910088--add--start--
  LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)
  LET g_pnn[l_ac].pnn32 = s_digqty(g_pnn[l_ac].pnn32,g_pnn[l_ac].pnn30)
  LET g_pnn[l_ac].pnn35 = s_digqty(g_pnn[l_ac].pnn35,g_pnn[l_ac].pnn33)
  LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)  
#FUN-910088--add--end--
END FUNCTION  
 
FUNCTION p570_set_no_required_h()                                                 
   CALL cl_set_comp_required("pmc01",FALSE)   
END FUNCTION
 
FUNCTION p570_set_required_h()                                                 
   IF tm.d = '4' THEN 
      CALL cl_set_comp_required("pmc01",TRUE)
   END IF
END FUNCTION
 
FUNCTION p570_ins_pmo()
   DEFINE i            SMALLINT
   DEFINE l_success    LIKE type_file.chr1
 
   LET l_success = 'Y'
   BEGIN WORK
 
   IF g_ac > 1 THEN
      FOR i = 1 TO g_ac - 1
         INSERT INTO pmo_file VALUES(g_pmo[i].*)
         IF SQLCA.SQLCODE THEN
            CALL cl_err('ins_pmo:',SQLCA.SQLCODE,0)
            LET l_success = 'N'
            EXIT FOR
         END IF
      END FOR
   END IF
 
   IF l_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION

FUNCTION p570_pnn03_chk(p_pmn68,p_pmn69,p_pmn04)
DEFINE l_pon04      LIKE pon_file.pon04,
       l_success    LIKE type_file.chr1,
       l_ima152     LIKE ima_file.ima152,
       l_ima151     LIKE ima_file.ima151,
       l_pmu        RECORD LIKE pmu_file.*,
       l_pmn04_cut  LIKE pmu_file.pmu06,
       l_tpmu00     LIKE type_file.num5,
       l_n,l_n1     LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_agb03a     LIKE agb_file.agb03,
       l_agb03b     LIKE agb_file.agb03,
       l_agb03c     LIKE agb_file.agb03,
       l_imx01      LIKE imx_file.imx01,
       l_imx02      LIKE imx_file.imx02,
       l_imx03      LIKE imx_file.imx03,
       l_imx00      LIKE imx_file.imx00,
       l_imx01a     LIKE imx_file.imx01,
       l_imx02a     LIKE imx_file.imx02,
       l_imx03a     LIKE imx_file.imx03,
       l_imx01b     LIKE imx_file.imx01,
       l_imx02b     LIKE imx_file.imx02,
       l_imx03b     LIKE imx_file.imx03,
       l_pmu03      LIKE pmu_file.pmu03,
       l_tpmu03     LIKE pmu_file.pmu03,
       l_tpmu04     LIKE pmu_file.pmu04,
       p_pmn04      LIKE pmn_file.pmn04,
       p_pmn68      LIKE pmn_file.pmn68,
       p_pmn69      LIKE pmn_file.pmn69

  LET l_success ='Y'
  LET g_errno = ''

  SELECT pon04 INTO l_pon04
              FROM pon_file
              WHERE pon01= p_pmn68
              AND  pon02 = p_pmn69
            SELECT ima152,ima151 INTO l_ima152,l_ima151
              FROM ima_file
              WHERE ima_file.ima01=l_pon04
            IF g_pnn2.pnn03!=l_pon04 THEN
              IF l_ima152='0' THEN     #No.FUN-840178
                LET g_errno = 'apm-340'
                LET l_success ='N'
                RETURN l_success
              ELSE
                IF l_ima151='Y' THEN       #采購料號為母料號
                  IF l_ima152='1' THEN     #依替代原則         #No.FUN-840178
                     SELECT * FROM ima_file WHERE ima_file.ima01=g_pnn2.pnn03
                       AND ima_file.ima01 IN(
                     SELECT imx000 FROM imx_file
                       WHERE imx_file.imx00=l_pon04)
                         AND ima_file.imaacti='Y'   #必須是相同母料號的明細料號
                     IF SQLCA.sqlcode=0 THEN
                        SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                          AND pmv_file.pmv06='Y'
                          AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                        IF l_n=0 THEN
                           SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='1'
                           SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='2'
                           SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                             WHERE ima01=l_pon04 AND imaag=agb_file.agb01
                               AND agb02='3'
                           SELECT imx01,imx02,imx03 INTO l_imx01,l_imx02,l_imx03
                             FROM imx_file WHERE imx000=g_pnn2.pnn03
                           SELECT COUNT(*) INTO l_n
                             FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                              AND pmv_file.pmv09<=tm3.purdate
                              AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                          IF l_n=0 THEN
                             LET g_errno = 'apm-345'
                             LET l_success ='N'
                             RETURN l_success
                          ELSE
                            IF l_agb03a IS NOT NULL AND l_agb03a!=' ' THEN
                               SELECT COUNT(*) INTO l_n
                                 FROM pmv_file
                                WHERE pmv_file.pmv01=l_pon04
                                  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                                  AND pmv_file.pmv09<=tm3.purdate
                                  AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10=' ')
                                  AND pmv_file.pmv03=l_agb03a AND pmv_file.pmv04='*'    #No.FUn-870117
                                  AND (pmv_file.pmv05=l_imx01 OR pmv_file.pmv05='*')
                               IF l_n=0 THEN
                                  LET g_errno = 'apm-341'
                                  LET l_success ='N'
                                  RETURN l_success
                               ELSE
                                 IF l_agb03b IS NOT NULL AND l_agb03b!=' '  THEN
                                    SELECT COUNT(*) INTO l_n
                                    FROM pmv_file
                                    WHERE pmv_file.pmv01=l_pon04
                                    AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                                    AND pmv_file.pmv09<=tm3.purdate
                                    AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                    AND pmv_file.pmv03=l_agb03b AND pmv_file.pmv04='*'    #No.FUn-870117
                                    AND (pmv_file.pmv05=l_imx02 OR pmv_file.pmv05='*')
                                    IF l_n=0 THEN
                                       LET g_errno = 'apm-343'
                                       LET l_success ='N'
                                       RETURN l_success
                                    ELSE
                                      IF l_agb03c IS NOT NULL AND l_agb03c!=' ' THEN
                                         SELECT COUNT(*) INTO l_n
                                           FROM pmv_file
                                          WHERE pmv_file.pmv01=l_pon04
                                            AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                                            AND pmv_file.pmv09<=tm3.purdate
                                            AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                            AND pmv_file.pmv03=l_agb03c AND pmv_file.pmv04='*'    #No.FUn-870117
                                            AND (pmv_file.pmv05=l_imx03 OR pmv_file.pmv05='*')
                                        IF l_n=0 THEN
                                           LET g_errno = 'apm-344'
                                           LET l_success ='N'
                                           RETURN l_success
                                         END IF
                                      END IF
                                  END IF
                               END IF
                            END IF
                          END IF
                        END IF
                      END IF
                     ELSE
                       LET g_errno = 'apm-346'
                       LET l_success ='N'
                       RETURN l_success
                     END IF
                   ELSE
                     IF l_ima152='2' THEN   #依替代群組          #No.FUN-840178
                        SELECT COUNT(*) INTO l_n FROM pnc_file
                        WHERE pnc_file.pnc01=l_pon04
                          AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pnn2.pnn05)
                          AND pnc_file.pnc03=g_pnn2.pnn03
                          AND pnc_file.pnc04<=tm3.purdate AND (pnc_file.pnc05>tm3.purdate
                           OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                       IF l_n=0 THEN
                          LET g_errno = 'apm-347'
                          LET l_success ='N'
                          RETURN l_success
                       END IF
                    END IF
                  END IF
             ELSE
          #表示是多屬性明細料號
                IF l_n>0  THEN
                  IF l_ima152='1' THEN
                    SELECT * FROM imx_file,ima_file
                     WHERE ima_file.ima01=g_pnn2.pnn03
                     AND imx_file.imx000=ima_file.ima01
                     AND imx_file.imx00 IN(
                     SELECT imx00 FROM imx_file WHERE imx_file.imx000=l_pon04)
                     AND ima_file.imaacti='Y'
                    IF SQLCA.sqlcode=0 THEN
                      SELECT a.imx00 INTO l_imx00
                        FROM imx_file a, imx_file b
                       WHERE a.imx000=g_pnn2.pnn03
                         AND b.imx000=l_pon04
                         AND a.imx00=b.imx00
                      SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                         AND pmv_file.pmv06='Y'
                         AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                      IF l_n=0 THEN
                        SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='1'
                        SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='2'
                        SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                         WHERE ima01=l_pon04 AND imaag1=agb_file.agb01
                           AND agb02='3'
                        SELECT imx01,imx02,imx03 INTO l_imx01a,l_imx02a,l_imx03a
                          FROM imx_file WHERE imx000=l_pon04
                        SELECT imx01,imx02,imx03 INTO l_imx01b,l_imx02b,l_imx03b
                          FROM imx_file WHERE imx000=g_pnn2.pnn03
                        SELECT COUNT(*) INTO l_n
                          FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                           AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                           AND pmv_file.pmv09<=tm3.purdate
                           AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                        IF l_n=0 THEN
                           LET g_errno = 'apm-345'
                           LET l_success ='N'
                           RETURN l_success
                        ELSE
                          IF l_agb03a IS NOT NULL  THEN
                            IF l_imx01a != l_imx01b THEN 
                               LET l_n =1 
                            ELSE    
                            SELECT COUNT(*) INTO l_n
                             FROM pmv_file
                            WHERE pmv_file.pmv01=l_imx00
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                              AND pmv_file.pmv09<=tm3.purdate
                              AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                              AND pmv_file.pmv03=l_agb03a AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx01a)
                              AND (pmv_file.pmv05=l_imx01b OR pmv_file.pmv05='*')
                           END IF 
                           IF l_n=0 THEN
                              LET g_errno = 'apm-341'
                              LET l_success ='N'
                              RETURN l_success
                           ELSE
                             IF l_agb03b IS NOT NULL  THEN
                                IF l_imx02a != l_imx02b THEN 
                               LET l_n =1 
                            ELSE
                                SELECT COUNT(*) INTO l_n
                                FROM pmv_file
                                WHERE pmv_file.pmv01=l_imx00
                                AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                                AND pmv_file.pmv09<=tm3.purdate
                                AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                AND pmv_file.pmv03=l_agb03b AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx02a)
                                AND (pmv_file.pmv05=l_imx02b OR pmv_file.pmv05='*')
                            END IF     
                                IF l_n=0 THEN
                                  LET g_errno = 'apm-343'
                                  LET l_success ='N'
                                  RETURN l_success
                                ELSE
                                  IF l_agb03c IS NOT NULL  THEN
                                  IF l_imx01a != l_imx02b THEN 
                                     LET l_n =1 
                                  ELSE
                                     SELECT COUNT(*) INTO l_n
                                     FROM pmv_file
                                     WHERE pmv_file.pmv01=l_imx00
                                       AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_pnn2.pnn05)
                                       AND pmv_file.pmv09<=tm3.purdate
                                       AND (pmv_file.pmv10>tm3.purdate OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                                       AND pmv_file.pmv03=l_agb03c AND (pmv_file.pmv04 = '*' OR pmv_file.pmv04 = l_imx03a)
                                       AND (pmv_file.pmv05=l_imx03b OR pmv_file.pmv05='*')
                                   END IF     
                                    IF l_n=0 THEN
                                       LET g_errno = 'apm-344'
                                       LET l_success ='N'
                                       RETURN l_success
                                    END IF
                                  END IF
                                END IF
                             END IF
                           END IF
                         END IF
                      END IF
                    END IF
                 ELSE
                    LET g_errno = 'apm-346'
                    LET g_pnn2.pnn03=l_pon04
                    LET l_success ='N'
                    RETURN l_success
                END IF
              ELSE
                IF l_ima152='2' THEN
                  SELECT COUNT(*) INTO l_n FROM pnc_file
                  WHERE pnc_file.pnc01=l_pon04
                  AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pnn2.pnn05)
                  AND pnc_file.pnc03=g_pnn2.pnn03
                  AND pnc_file.pnc04<=tm3.purdate AND (pnc_file.pnc05>tm3.purdate
                  OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                  IF l_n=0 THEN
                   LET g_errno = 'apm-347'
                   LET l_success ='N'
                   RETURN l_success
                  END IF
                END IF
              END IF
            ELSE  #為其他一般料號
                IF l_ima152='1' THEN
                  DROP TABLE tpmu_file
                  CREATE TEMP TABLE tpmu_file(
                  tpmu00      DECIMAL(5,0)   NOT NULL,   
                  tpmu01      CHAR(40)       NOT NULL,   #料號
                  tpmu02      CHAR(10)       NOT NULL,   #供應商，*號代表不區分供應商
                  tpmu03      DECIMAL(5,0)   NOT NULL,   #起始碼
                  tpmu04      DECIMAL(5,0)   NOT NULL,   #截至碼
                  tpmu05      CHAR(20)       NOT NULL,   #原值
                  tpmu06      CHAR(20)       NOT NULL    #替代值
                  );
                  DECLARE t110_pmu_cl CURSOR WITH HOLD FOR
                     SELECT * FROM pmu_file
                      WHERE pmu_file.pmu01=l_pon04
                      AND (pmu_file.pmu02='*' OR pmu_file.pmu02=g_pnn2.pnn05)
                      AND pmu_file.pmu07<=tm3.purdate
                      AND (pmu_file.pmu08>tm3.purdate OR pmu_file.pmu08 IS NULL OR pmu_file.pmu08='')
                      ORDER BY pmu03
                     LET l_tpmu00=0
                     FOREACH t110_pmu_cl INTO l_pmu.*
                      IF l_pmu.pmu03!=l_pmu03 OR l_pmu03 IS NULL THEN
                        LET l_tpmu00=l_tpmu00+1
                      END IF
                      INSERT INTO tpmu_file VALUES (
                      l_tpmu00,l_pmu.pmu01,l_pmu.pmu02,l_pmu.pmu03,
                      l_pmu.pmu04,l_pmu.pmu05,l_pmu.pmu06)
                     END FOREACH
                  FOR l_i=1 TO l_tpmu00
                    SELECT unique tpmu03,tpmu04 INTO l_tpmu03,l_tpmu04
                    FROM tpmu_file
                    WHERE tpmu00=l_i
                    LET l_pmn04_cut=g_pnn2.pnn03[l_tpmu03,l_tpmu04]
                    SELECT COUNT(*) INTO l_n
                    FROM tpmu_file
                    WHERE tpmu_file.tpmu00=l_i
                    AND tpmu_file.tpmu06=l_pmn04_cut
                  END FOR
                    IF l_n=0 THEN
                     LET g_errno = 'apm-348'
                     LET l_success ='N'
                     RETURN l_success
                    END IF
                ELSE
                   IF l_ima152='2' THEN
                      SELECT COUNT(*) INTO l_n FROM pnc_file
                       WHERE pnc_file.pnc01=l_pon04
                       AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_pnn2.pnn05)
                       AND pnc_file.pnc03=g_pnn2.pnn03
                       AND pnc_file.pnc04<=tm3.purdate AND (pnc_file.pnc05>tm3.purdate
                       OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
                   IF l_n=0 THEN
                    LET g_errno = 'apm-347'
                    LET l_success ='N'
                    RETURN l_success
                   END IF
                  END IF
                END IF
               END IF
              END IF
            END IF
          END IF
          RETURN l_success
END FUNCTION

#FUNCTION p570_price_check(p_pnn05,p_pnn10,p_pnn10t)
FUNCTION p570_price_check(p_pnn05,p_pnn10,p_pnn10t,p_term)  #TQC-B80055 mod
   DEFINE p_pnn05    LIKE pnn_file.pnn05
   DEFINE p_pnn10    LIKE pnn_file.pnn10
   DEFINE p_pnn10t   LIKE pnn_file.pnn10t
   DEFINE p_term     LIKE pmk_file.pmk41  #TQC-B80055 add
   DEFINE l_pmc49    LIKE pmc_file.pmc49
   DEFINE l_pmc47    LIKE pmc_file.pmc47  #FUN-B70121 add
   DEFINE l_pnz04    LIKE pnz_file.pnz04
   DEFINE l_pnz07    LIKE pnz_file.pnz07  #FUN-B70121 add
   DEFINE l_gec07    LIKE gec_file.gec07  #FUN-B70121 add
   DEFINE l_pnn03    LIKE pnn_file.pnn03  #FUN-BC0088 add

   IF NOT cl_null(p_pnn05) THEN
      SELECT pmc49,pmc47 INTO l_pmc49,l_pmc47 FROM pmc_file  #FUN-B70121 add pmc47
       WHERE pmc01 = p_pnn05
      IF SQLCA.sqlcode THEN 
      	 CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
      	 RETURN
      END IF	    
   END IF
   IF cl_null(p_term) THEN LET p_term = l_pmc49 END IF  #TQC-B80055 add
   
   IF NOT cl_null(l_pmc49) THEN
      SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file  #FUN-B70121 add pnz07
       WHERE pnz01 = p_term   #TQC-B80055 l_pmc49->p_term
      IF SQLCA.sqlcode THEN 
         CALL cl_err( 'sel pnz04' , SQLCA.sqlcode,0)
         RETURN
      END IF	   	   
   END IF 
  #FUN-B70121 mod
  #IF l_pnz04 = 'Y'  THEN 
  #   IF g_gec07 = 'Y' THEN
  #      CALL cl_set_comp_entry("pnn10",FALSE)  
  #      IF p_pnn10t = 0 OR cl_null(p_pnn10t) THEN 
  #         CALL cl_set_comp_entry("pnn10t",TRUE) 
  #      ELSE 
  #         CALL cl_set_comp_entry("pnn10t",FALSE)  	 
  #      END IF
  #   ELSE
  #      CALL cl_set_comp_entry("pnn10t",FALSE)  
  #      IF p_pnn10 = 0 OR cl_null(p_pnn10) THEN 
  #         CALL cl_set_comp_entry("pnn10",TRUE)
  #      ELSE 
  #         CALL cl_set_comp_entry("pnn10",FALSE)     
  #      END IF       	     	   	  		  
  #   END IF
  #ELSE
  #   CALL cl_set_comp_entry("pnn10",FALSE)  
  #   CALL cl_set_comp_entry("pnn10t",FALSE) 
  #END IF
   SELECT gec07 INTO l_gec07
     FROM gec_file
    WHERE gec01 = l_pmc47
      AND gec011 = '1'  #進項
   IF cl_null(l_gec07) THEN LET l_gec07='N' END IF

   #FUN-BC0088 ----- add start -----
     SELECT pnn03 INTO l_pnn03
    FROM pnn_file
   WHERE pnn01 = g_pml.pml01 AND pnn02 = g_pml.pml02
   IF l_pnn03[1,4] = 'MISC' THEN
      IF l_gec07 = 'Y' THEN   #含税
         CALL cl_set_comp_entry("pnn10",FALSE)
         CALL cl_set_comp_entry("pnn10t",TRUE)
      ELSE
         CALL cl_set_comp_entry("pnn10",TRUE)
         CALL cl_set_comp_entry("pnn10t",FALSE)
      END IF
      RETURN
   END IF
   #FUN-BC0088 ----- add end -----

   IF l_gec07 = 'Y' THEN   #含税
      IF p_pnn10t = 0 OR cl_null(p_pnn10t) THEN
         #未取到含税单价
         IF l_pnz04 = 'Y'  THEN   #未取到单价可人工输入
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      ELSE
         #有取到含税单价
         IF l_pnz07 = 'Y' THEN    #取到价格可修改
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      END IF
   ELSE                    #不含税
      IF p_pnn10 = 0 OR cl_null(p_pnn10) THEN
         #未取到税前单价
         IF l_pnz04 = 'Y'  THEN   #未取到单价可人工输入
            CALL cl_set_comp_entry("pnn10",TRUE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      ELSE
         #有取到税前单价
         IF l_pnz07 = 'Y' THEN    #取到价格可修改
            CALL cl_set_comp_entry("pnn10",TRUE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      END IF
   END IF
  #FUN-B70121 mod--end


END FUNCTION  
#No:TQC-C60137 過單
#No:FUN-9C0071--------精簡程式-----

