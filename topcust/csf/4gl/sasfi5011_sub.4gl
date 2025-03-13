# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Program name...: sasfi501_sub.4gl
# Description....: 提供sasfi501.4gl使用的sub routine
# Date & Author..: 07/04/27 by kim (FUN-740187)
# Modify.........: No.MOD-740055 07/05/03 By pengu 備料有三筆資料狀況為 3, U, U時sasfi501 中計算欠料資料時會錯誤
# Modify.........: No.MOD-750112 07/05/28 By pengu 使用多單位時當扣帳日期!=單據日期時會無法過帳還原
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.MOD-790054 07/09/17 By Pengu 當使用多單位且母單位數量為0時，會無法過帳還原
# Modify.........: No.MOD-790100 07/09/20 By Pengu 調整變數l_sfe.sfs03改為l_sfs.sfs03
# Modify.........: No.MOD-790112 07/09/21 By Pengu 使用多單位無法過帳還原
# Modify.........: No.CHI-7A0034 07/10/24 By Carol 扣帳合理性檢查調整-for非超領狀況
# Modify.........: No.MOD-7A0201 07/10/31 By Pengu 在計算替代料的欠料量時會異常
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810045 08/03/01 By rainy  項目管理:專案相關欄位代入tlf
# Modify.........: No.FUN-810038 08/03/15 By kim GP5.1 ICD
# Modify.........: No.CHI-830032 08/03/27 By kim GP5.1 整合測試
# Modify.........: No.MOD-840551 08/04/23 By kim GP5.1顧問測試修改
# Modify.........: No.CHI-860032 08/06/24 By Nicola 批/序號修改
# Modify.........: No.MOD-870053 08/07/04 By claire 以扣帳日期check成本關帳日
# Modify.........: No.FUN-860014 08/07/08 By sherry 過帳不可先判斷日期,輸完再檢查
# Modify.........: No.MOD-850212 08/07/14 By Pengu 調整CHI-7A0034的修改
# Modify.........: No.FUN-870117 08/07/25 by ve007 按作業編號成套發料 
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值(sfa27)
# Modify.........: No.MOD-890107 08/09/11 By claire asf-724 加上料號提示
# Modify.........: No.MOD-890117 08/09/12 By claire 委外工單需待委外採購單發出後才可對發料單庫存扣帳
# Modify.........: No.TQC-890051 08/09/24 by sherry 過區only
# Modify.........: No.FUN-840012 08/09/30 By kim 確認段移到_sub
# Modify.........: No.MOD-870247 08/10/02 By claire 由單據日改為用過帳日控卡倉儲批的有效否
# Modify.........: No.MOD-870305 08/10/02 By claire 領料退時, 若已發數為0也要控卡不能退料
# Modify.........: No.MOD-880077 08/10/02 By claire 庫存扣帳時改了扣帳日但實際上卻沒有寫入
# Modify.........: No.CHI-870030 08/10/02 By claire 於確認段時加入若為"退料單"時, 更新i501sub_u_sfa資料後, 再判斷是否符合完工套數的控管
# Modify.........: No.MOD-8A0088 08/10/09 By chenl  工單欠料補料審核及過賬時，對單身料號發料進行判斷，查看發料量是否大于欠料量，若大于欠料量則不予審核。
# Modify.........: No.MOD-8B0086 08/11/12 By chenyu 將FUN-870051修改的內容先mark掉
# Modify.........: No.MOD-8B0159 08/11/15 By Sarah 當應發數(sfa05)為0時不可過帳
# Modify.........: No.MOD-8C0098 08/12/10 By claire MOD-8B0086 mark 處取消
# Modify.........: No.FUN-8C0072 08/12/11 By sherry sfe27為被替代料
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-910049 09/01/06 By claire 退料時,未考慮已收貨的驗退量
# Modify.........: No.MOD-910166 09/01/15 By claire imd_file需檢核imd11='Y'
# Modify.........: No.MOD-910221 09/01/20 By claire sfb97手冊編號寫入tlf64
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.FUN-910077 09/02/17 By for ICD 委外發料單在委外採購單未發出時時也可過帳
# Modify.........: No.MOD-920284 09/02/23 By claire 委外採購單,有代買料情況
# Modify.........: No.FUN-920175 09/02/24 By kim 取消確認/作廢段程式拆解到_sub.4gl中，以便後續程序呼叫
# Modify.........: No.FUN-930108 09/03/18 By zhaijie過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.TQC-930166 09/03/31 By chenyu l_sql中from寫成f)rom
# Modify.........: No.MOD-940139 09/04/10 By lutingting當成套發料單過賬還原時,加入sfpconf<>'X' 的判斷
# Modify.........: No.TQC-930155 09/04/14 By dongbg open cursor或fetch cursor失敗時不要rollback,給g_success賦值
# Modify.........: No.FUN-940008 09/04/28 By hongmei GP5.0發料改善
# Modify.........: No.MOD-940308 09/05/20 By Pengu 若直接在發料單做取代料時，在過帳時會出現asf-081的錯誤
# Modify.........: No.MOD-940320 09/05/20 By Pengu 庫存扣帳時img_file的異動日應該要用單據的扣帳日期
# Modify.........: No.MOD-940311 09/05/20 By Pengu 回寫欠料量(sfa07)時，一般的欠料有做單位的取位，但是在替代時沒有做取位
# Modify.........: No.MOD-940387 09/05/20 By Pengu 倉庫可用否應考慮是否為發料狀態  
# Modify.........: No.FUN-940083 09/05/22 By shiwuying 採購改善-VMI,增加VMI結算收貨入庫
# Modify.........: No.MOD-950232 09/05/25 By mike 調整MOD-910166修改的程式段有用imd11判斷是否為可用倉的程式段,                      
#                                                 均須還原不做控管  
# Modify.........: No.TQC-940099 09/06/05 By jan 修改程序BUG
# Modify.........: No.CHI-960053 09/06/30 By mike 請在確認段加上asf-999的判斷，并新增錯誤訊息"單頭無此工單號碼，不允許確認"         
# Modify.........: No.FUN-950088 09/07/01 By hongmei過賬以及過賬還原時增加sfs36,sfe36的處理
# Modify.........: No.FUN-950037 09/07/10 By jan for ICD：發料單過帳時并未將發料量回寫到備料檔的sfaiicd04/sfaiicd05
# Modify.........: No.MOD-950184 09/07/29 By sherry 事后倒扣料的單子，過賬日期應該和入庫單在同一年月內 
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.TQC-980097 09/08/14 By sherry 應根據作業編號發料
# Modify.........: No.FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870100 09/08/20 By cockroach    對ina12,inapos賦默認值
# Modify.........: No.MOD-980185 09/08/21 By Smapmin 修正MOD-940311
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:CHI-9A0020 09/10/28 By mike 在作废还原时，请判断发料单第二单身(sfs_file)中的工单号码是否已经有结案的，        
# Modify.........: No:TQC-9A0194 09/10/31 By kim GP5.2發料改善測試修改
# Modify.........: No:CHI-980013 09/11/02 By jan 欠料量回寫要排除 sfa11='X' 的料
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No:TQC-960059 09/11/13 By jan 過帳段產生p_flow的判斷式錯誤
# Modify.........: No:MOD-9A0074 09/11/24 By sabrina 過帳時應用sfp03做為庫存異動時間
# Modify.........: No:MOD-9B0079 09/11/24 By sabrina 拆件式工單不做套數何理性控管
# Modify.........: No:FUN-9B0140 09/11/25 by dxfwo 最小套數應考慮作業編號
# Modify.........: No:FUN-9B0149 09/11/27 by kim sfa_file key值加sfa27
# Modify.........: No:TQC-9C0069 09/12/10 by sherry GP5.2發料改善:替代料若超過主料+替料料的應發數總和，應該也要可以超領
# Modify.........: No:TQC-9C0064 09/12/10 by sherry sfa07的值通過CALL s_shortqty得到  
# Modify.........: No:TQC-9C0078 09/12/11 by jan VIM扣帳時出現-391的錯誤
# Modify.........: No:TQC-9C0149 09/12/17 by jan INSERT rva_file時給rva32/rvamksg賦初值
# Modify.........: No:CHI-9C0031 09/12/18 by kim GP5.2發料改善
# Modify.........: No.TQC-9C0158 09/12/19 By chenmoyan 工單發料單扣帳在進行VMI相關資料產生時出問題:一張收貨單對應多張入庫單
# Modify.........: No:MOD-9C0308 09/12/21 by kim GP5.2發料改善-更新首站製程數量後,WIP數量不可為負值
# Modify.........: No:TQC-9C0163 09/12/22 By Carrier VMI时,发料单对收货入库单一一对应
# Modify.........: No:TQC-9C0174 09/12/28 By sherry 在asfi510 asfi520里面維護的批序號內容,在asfi511 asfi526等作業里面查不到
# Modify.........: No:FUN-9C0073 10/01/04 By chenls 程序精簡
# Modify.........: No.FUN-A10001 10/01/06 By dxfwo 採購改善-VMI,增加VMI結算收貨入庫
# Modify.........: No.FUN-9C0040 10/02/02 By jan 增加回收料的相關處理
# Modify.........: No.FUN-960037 10/03/02 By chenls 增加對製程類工單的判斷
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.TQC-A30091 10/03/19 By lilingyu 工單成套退料,過賬還原時,會將工單的狀態碼變成"發放"
# Modify.........: No.FUN-A20048 10/03/25 By liuxqa 增加工单备置，过账和还时，如有备置，则先处理备置。
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A40047 10/04/12 By Sarah 將過帳段檢查倉庫是否為WIP倉往前移到確認段
# Modify.........: No:FUN-A30093 10/04/14 By jan 欠料量回寫要排除 sfa11='C' 的料
# Modify.........: No:MOD-A40068 10/04/16 By Sarah 作廢還原前需檢核工單已確認
# Modify.........: No:MOD-A40140 10/04/23 By Sarah asfi512過帳時,不做替代料asf-642的檢核
# Modify.........: No:FUN-A50072 10/05/18 By Cockroach s_defprice-->s_defprice_new
# Modify.........: No:MOD-A50140 10/06/01 By Sarah 產生收貨單時,rvb30要給予l_rvb.rvb07
# Modify.........: No:FUN-A60028 10/06/09 By lilingyu 平行工藝
# Modify.........: No.FUN-A60028 10/06/18 By vealxu 平行工藝  
# Modify.........: No.FUN-A60042 10/06/28 By liuxqa add sif13 
# Modify.........: No:MOD-A30097 10/07/23 By Pengu 過帳還原在判斷是否有超領單時應排除作廢單據
# Modify.........: No:FUN-A60095 10/07/26 By kim 可發/可退量要考慮盤盈虧量
# Modify.........: No:FUN-A70125 10/07/26 By lilingyu 平行工藝
# Modify.........: No:FUN-A70143 10/07/29 By jan 平行工藝(l_ecm63=0-->l_ecm63=1)
# Modify.........: No:CHI-A70060 10/08/03 By Summer ICD段調整,判斷sfp06='1'的改成sfp06 MATCHES '[1234]',
#                                                   sfp06='6'的改成sfp06 MATCHES '[6789]',
#                                                   sfp06 MATCHES '[16]'的改成sfp06 MATCHES '[12346789]'
# Modify.........: No:MOD-A80053 10/08/06 By sabrina asf-351錯誤訊息應只檢查sfp06 MATCHES '[13]'就好 
# Modify.........: No:MOD-A90175 10/09/27 By sabrina 過帳及過帳還原時不更新user及日期
# Modify.........: No:MOD-AA0017 10/10/06 By sabrina 領料單作廢時，應將apmt730的領料單號更新為null
# Modify.........: No:MOD-AA0077 10/10/15 By sabrina 領料單作廢時，應將asrt300的領料單號更新為null
# Modify.........: No.FUN-A40022 10/10/25 By jan 退料批號需等于發料批號
# Modify.........: No:MOD-AB0026 10/11/03 By sabrina asf-724的g_showmsg漏給了
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No:TQC-AB0301 10/12/02 By jan 調整報錯信息/發料量or退料量為0時不可確認
# Modify.........: No.TQC-AB0394 10/12/04 By vealxu 下階料報廢，單位無法錄入通過,序號sfl041無法錄入通過
# Modify.........: No.TQC-AC0077 10/12/08 By jan 倒扣料時應該不要異動ecm301
# Modify.........: No.TQC-AC0082 10/12/08 By jan 平行工藝不走製程BOM，發料單扣帳時無法正確回寫ecm301
# Modify.........: No.TQC-AC0083 10/12/08 By jan 平行工藝不走製程BOM，發料單扣帳時回寫ecm301邏輯修改
# Modify.........: No.TQC-AC0298 10/12/20 By jan sie07=sfs30 ==> sie07=sfs06
# Modify.........: No.TQC-A50122 10/12/22 By destiny 工單補料時檢查單身相同工單下的相同料件的補料量是否大於欠料量
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.MOD-AC0336 10/12/28 By jan 從抓製程料號
# Modify.........: No:MOD-AC0409 10/12/30 By sabrina 在確認段時判斷該單別是否有做設限倉
# Modify.........: No:MOD-B10096 11/01/13 By sabrina 將TSD0020、TSD0022錯誤訊息改為標準的ze代碼
# Modify.........: No:MOD-B10169 11/01/21 By lilingyu 調用i501sub_z()函數時,需要增加控管是否在事務裡面
# Modify.........: No:MOD-B20080 11/02/17 By sabrina 在計算發料量是否有大於"已發-應發"時，變數未清空
# Modify.........: No:TQC-B30039 11/03/04 By jan TQC-A50122 少處理了製程段和製程序
# Modify.........: No:FUN-B20070 11/03/07 By jan 應考慮分批發料
# Modify.........: No:MOD-B30062 11/03/08 By sabrina RETURN l_rvb.rvb01,l_rvb.rvb02應在call i501_vmi_tlf()及i501_vmi_tlff()之後
# Modify.........: No:TQC-B30117 11/03/14 By destiny 走VMI仓发料流程时,tlf024计算有误
# Modify.........: No:MOD-B30434 11/03/14 By lixh1   成套發料單過帳還原時不用檢查是否存在超領單,有超領就可超退
# Modify.........: No:MOD-B30702 11/03/31 By destiny 退料单过帐时回收料数量更新有问题      
# Modify.........: No:FUN-B20009 11/04/07 By lixh1   增加對sif012,sif013的賦值
# Modify.........: No:FUN-B40053 11/04/20 By suncx   VMI退料時，不需產生收貨單
# Modify.........: No:FUN-AC0074 11/04/28 By jan 工單備置邏輯更改  
# Modify.........: No:TQC-B40227 11/05/03 By lilingyu 成本關帳之後,如果程序是在關帳之前打開的,仍然可以過賬,庫存仍可以異動 
# Modify.........: No:FUN-9A0095 11/05/11 By abby MES整合追版
# Modify.........: No:TQC-A10124 11/05/11 By abby MES取/替代料件功能
# Modify.........: No.FUN-B50059 11/05/12 By kim 還原FUN-A60095中,和sfa064有關的所有調整
# Modify.........: No:MOD-B50119 11/05/18 By zhangll 已發套數計算方式按作業編號和非作業編號分類匯總
# Modify.........: No:FUN-AB0001 11/05/25 By Lilan EF(EasyFlow)整合調整
# Modify.........: No:TQC-B60001 11/06/01 By zhangll 控管退料量不可大於已發量
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B60091 11/06/15 By jan 發料單過帳時若有取替代資料補能過帳
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:FUN-A70095 11/07/11 by destiny 比较已发数量和应发数量时，没有考虑回收料发料量为负数的情况
# Modify.........: No:FUN-B70074 11/07/26 By lixh1 添加行業別表的新增於刪除
# Modify.........: No:FUN-B70061 11/07/28 By jason 過帳,和還原行業別表同步異動
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No:MOD-B80175 11/08/17 By lilingyu "發料控管套數"為N時,成套退料單的退料套數在過賬後顯示為負數
# Modify.........: No:TQC-B80160 11/08/22 By zhangll qty1_1,qty1_2,qty2_1,qty2_2變量需先清空
# Modify.........: No:FUN-B80129 11/08/25 By jan 過帳時，檢查已發>應發那段(asf-627)，倒扣料應該維持舊邏輯，允許已發>應發，差異量產生到超領量
# Modify.........: No.MOD-B90008 11/09/06 By lilingyu 工藝工單按作業編號發料,首站報工完第二站成套發料過賬後未報工的狀況下對成套發料單取消過賬時報錯
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0050 11/10/10 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.TQC-B90236 11/11/08 By zhuhao FUNCTION i501sub_u_o_sfa中，增加判斷
# Modify.........: No.CHI-BA0020 11/11/10 By jason 過帳時取替代料檢查已發數量不可大於應發數量時,不可將超領量納入
# Modify.........: No:MOD-BB0111 11/11/12 By johung 調整i501_tlff_c問題
# Modify.........: No.TQC-B80182 11/11/14 By Carrier 拆件式工单退单确认及发料过帐还原时,若有拆件入库单时,卡发料套数不为0
# Modify.........: No:FUN-B80093 11/11/24 By pauline 增加VIM控管
# Modify.........: No:FUN-BB0083 11/11/28 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/12/05 By xianghui 增加數量欄位小數取位
# Modify.........: No:MOD-C10100 12/01/11 By lilingyu 將過賬段判斷asf-361的邏輯，往前移到審核段來判斷
# Modify.........: No:TQC-C10033 12/01/11 By lilingyu 還原MOD-C10100 MARK的部分
# Modify.........: No:TQC-BB0243 12/01/16 By Carrier insert rvu_file时rvu11给NULL
# Modify.........: No:FUN-C10035 12/01/11 By Lilan MES整合BUG修正:工單型態='1'or'13'的發料資訊才拋MES
# Modify.........: No.FUN-BC0104 12/01/31 By xianghui 數量異動回寫qco20
# Modify.........: No:MOD-C10171 12/01/30 By bart 排除sfa11為消耗性料件或回收料件
# Modify.........: No:MOD-C20095 12/02/09 By ck2yuan 控卡asf-081的應參考sma107
# Modify.........: No:TQC-C20353 12/02/21 By SunLM 如果生產日報工單轉出已經核准,則不允許發,退料過帳還原
# Modify.........: No:TQC-C30044 12/03/02 By yuhuabao 配方替代時過帳時出現asf-081 
# Modify.........: No:MOD-C20155 12/03/07 By ck2yuan 若走VMI退料且不允許負庫存,會造成無法過帳 先調整參數使其過帳再還原參數
# Modify.........: No:MOD-C30882 12/03/29 By SunLM 非std行業別刪除rvb的同時刪除rvbi
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No:TQC-C40174 12/04/26 By lixh1 過帳段增加對批序號的控管,否則在自動過帳時不能對批序號數量進行邏輯檢查
# Modify.........: No:MOD-C50071 12/05/14 By ck2yuan 1.產生至倉退單時rvu116預設都會給1，因此倉退時預設rvu10='Y'
#                                                    2.倉退的異動命令(tlf13)改為apmt1072
# Modify.........: No:MOD-C50170 12/05/23 By ck2yuan 扣帳還原時,不應影響 最近入庫日、最近出庫日、最近異動日、最近盤點日
# Modify.........: No:MOD-C50190 12/05/24 By suncx 若走VMI發料時且不允許負庫存,會造成無法過帳 先調整參數使其過帳再還原參數
# Modify.........: No:MOD-C50220 12/05/28 By suncx MOD-C50190多改
# Modify.........: No:TQC-C50233 12/05/29 By SunLM call了2次s_umfchk(),將轉換率乘了2次
# Modify.........: No:TQC-C50247 12/05/31 By SunLM 修正TQC-C50233,单位轉換時候來源和目的取反
# Modify.........: No:TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk(p_sfp01)添加參數
# Modify.........: No:TQC-C60083 12/06/13 By lixh1 修正asfi526做批序號控管不能庫存過帳的問題
# Modify.........: No:MOD-C60093 12/06/18 By ck2yuan 給tlf901值
# Modify.........: No:MOD-B60169 12/06/18 By ck2yuan 成套發料若發料套數為0也不可以過帳
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No:MOD-C60234 12/06/28 By suncx 使用平行工藝，不使用工藝BOM時，發料更新ecm301(良品轉入量)錯誤
# Modify.........: No:TQC-C70011 12/07/09 By fengrui 已入庫工單的發料單不可過帳還原
# Modify.........: No:TQC-C70080 12/07/12 By suncx VMI流程,發料單過帳時會自動產生雜發單/JIT收貨單/入庫單,相應退料單過帳會自動產生雜收單/倉退單,目前生成單據的日期都是g_today,不合理,應改為發料單扣帳日期
# Modify.........: No:FUN-C70014 12/07/12 By suncx 新增Run Card發料
# Modify.........: No:TQC-C70085 12/07/13 By fengrui 修正i501sub_y_chk函數中的RETURN
# Modify.........: No.FUN-C70087 12/08/09 By bart 整批寫入img_file
# Modify.........: No:MOD-C80077 12/08/16 By suncx 過帳還原時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No:MOD-C90004 12/09/03 By suncx 拆件式工單，完工入庫後，進行發料過賬還原未管控住 
# Modify.........: No:FUN-C30138 12/09/18 By bart 配方替代於發料單過帳還原時，回寫工單數量於被替代料
#                                                 退料時，過帳回寫被替代料，過帳還原時寫入替代料
# Modify.........: No:TQC-C90083 12/09/18 By chenjing 若工單有check in 則不允許過帳還原，取消審核和刪除
# Modify.........: No:FUN-C90077 12/09/18 By lixh1 退料時有取替代控管取替代的數量
# Modify.........: No:TQC-C90111 12/09/28 By lixh1 撈取退料資料時,因為包含在事務中,在撈取退料數量是會把本筆資料也算進去,故要剔除本筆資料
# Modify.........: No:CHI-C90045 12/10/09 By bart 委外工單確認時，自動產生委外採購單,發料單自動扣帳確認,工單確認需連動
# Modify.........: No:MOD-C90067 12/10/11 By Elise where條件少了被替代料號sfs27,導致發料單無法確認
# Modify.........: No.TQC-CA0035 12/10/15 By suncx RunCard發料QC測試BUG處理
# Modify.........: No.MOD-C90217 12/10/29 By Elise 剩餘超領的數量不可小於total超領退數量
# Modify.........: No.FUN-CB0043 12/11/26 By bart sfe_file增加自定義欄位
# Modify.........: No.MOD-CB0217 12/11/30 By Elise 呼叫s_upimg之前給l_ima25值
# Modify.........: No.FUN-CB0087 12/12/11 By qiull 庫存單據理由碼改善,fengrui:sfs_file、審核添加非空檢查,xujing:inb_file 
# Modify.........: No.MOD-CC0198 12/12/21 By suncx 修正MOD-C10171遺漏部分
# Modify.........: No.MOD-CC0288 12/12/28 By suncx 不走發料套數管控時，asfi519更新工單狀態有問題
# Modify.........: No.MOD-D10032 13/01/06 By suncx 倒扣料庫存過賬時，對於過賬日期的管控報錯信息有誤
# Modify.........: No.MOD-D10094 13/01/10 By suncx 平行工藝發料，不適應BOM工藝時，更新ecm301有問題
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:CHI-B50041 13/01/18 By Alberti  在成套發料作業要可以進行第二次取替代
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗
# Modify.........: No:CHI-BA0003 13/01/22 By Alberti 調整lock img fail訊息
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D30027 13/03/07 By bart ICD使用一般料時需考慮料號是否多單位
# Modify.........: No:MOD-C80233 13/03/08 By Alberti 製程首站的良品轉入數量不考慮工單完工誤差率,如果有誤差，應可使用bonus
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No.MOD-D30125 13/03/15 By Alberti 1.已發數量應去發料檔中看此作業變號最小發料套數 2. 除了第一站外，其餘不回寫工單單頭套數
# Modify.........: No:MOD-C80038 13/03/15 By Alberti 過帳還原,應考慮Bonus數量
# Modify.........: No:TQC-D30044 13/03/18 By fengrui 負庫存依據imd23判斷
# Modify.........: No.DEV-D30026 13/03/19 By Nina GP5.3 追版:DEV-CC0001、DEV-D10009為GP5.25 的單號
# Modify.........: No:FUN-D30065 13/03/20 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原			
# Modify.........: No.TQC-D30053 13/03/21 By bart 回寫工單數量時需考慮是否走製成
# Modify.........: No.MOD-D30184 13/03/21 By bart 錯誤訊息sdf-349 需顯示工單號碼
# Modify.........: No.MOD-D30209 13/03/25 By bart 單身無資料時，不允許確認過帳。
# Modify.........: No:MOD-D30246 13/03/29 By bart 如果 作業編號，製程段為空 則也要回寫
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.CHI-C80013 13/04/12 By Alberti aimp880會call確認與過帳段,因aimp880有s_showmsg_init 與 s_showmsg,故增加判斷若經由aimp880呼叫則不呼叫那兩隻sub
# Modify.........: No.DEV-D40013 13/04/22 By Mandy 純過單用
# Modify.........: No.MOD-D50031 13/05/08 By suncx 退料過賬時，管控退料量不能大於已發+超領-報廢
# Modify.........: No:FUN-D50017 13/06/19 By fengrui sfe_file新增理由碼sfe37
# Modify.........: No:MOD-D60189 13/06/27 By yuhuabao 允许发料量为0
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:MOD-DB0006 13/11/01 By suncx 退料時排除asf-507的管控

DATABASE ds
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE g_ina_vmi      RECORD LIKE ina_file.*  #No.FUN-940083
DEFINE g_inb_vmi      RECORD LIKE inb_file.*  #No.FUN-940083
DEFINE g_sfs_sif      RECORD LIKE sfs_file.*  #No.FUN-A20048
DEFINE g_cnt_vmi      LIKE type_file.num5     #No.FUN-940083
DEFINE g_flag_vmi     LIKE type_file.chr1     #No.FUN-940083
DEFINE g_sfs_vmi      DYNAMIC ARRAY OF RECORD LIKE sfs_file.*   #No.FUN-940083
DEFINE g_forupd_sql   STRING     #NO.FUN-9B0016
DEFINE g_line         LIKE type_file.num5     #No.TQC-9C0158
DEFINE g_rva_no       LIKE rva_file.rva01     #FUN-A10001 
DEFINE g_sfp01        LIKE sfp_file.sfp01     #TQC-A30091 
DEFINE g_sfs10        LIKE sfs_file.sfs10     #MOD-B90008
DEFINE g_msg          LIKE type_file.chr1000   #CHI-BA0003 add
DEFINE g_mesflag_t    VARCHAR(1)              #FUN-C10035 add
DEFINE g_mesflag      VARCHAR(1)              #FUN-C10035 add
DEFINE g_mescnt       SMALLINT                #FUN-C10035 add
DEFINE g_sfb02        LIKE sfb_file.sfb02     #FUN-C10035 add
DEFINE g_sfa11        LIKE  sfa_file.sfa11     #MOD-C10171
DEFINE g_aimp880      LIKE type_file.chr1      #CHI-C80013 add

FUNCTION i501sub_lock_cl()
   LET g_forupd_sql = "SELECT * FROM sfp_file WHERE sfp01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i501sub_cl CURSOR FROM g_forupd_sql
END FUNCTION
 
#p_argv1 : #1.發料 2.退料 #TQC-890051
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
FUNCTION i501sub_s(p_argv1,p_sfp01,p_inTransaction,p_ask_post)
   DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_sfq02  LIKE sfq_file.sfq02 #No.B519 010512
   DEFINE l_sfs03  LIKE sfs_file.sfs03
   DEFINE l_sfs04  LIKE sfs_file.sfs04
   DEFINE l_sfs05  LIKE sfs_file.sfs05
   DEFINE l_sfa06  LIKE sfa_file.sfa06
   DEFINE l_sfa161 LIKE sfa_file.sfa161
   DEFINE l_sfq03  LIKE sfq_file.sfq03
   DEFINE l_sfs    RECORD LIKE sfs_file.*  #No.FUN-610090
   DEFINE l_qty    LIKE sfb_file.sfb09 #No.TQC-690084 
   DEFINE p_argv1  LIKE type_file.chr1 #FUN-740187
   DEFINE p_sfp01  LIKE sfp_file.sfp01 #FUN-740187
   DEFINE l_sfp    RECORD LIKE sfp_file.* #FUN-740187   
   DEFINE p_inTransaction LIKE type_file.num5 #FUN-740187
   DEFINE p_ask_post LIKE type_file.chr1 #FUN-740187
   DEFINE p_code   LIKE type_file.chr1
 
DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
DEFINE l_imm01         LIKE imm_file.imm01      #No.FUN-610090
DEFINE l_yy,l_mm       LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE l_forupd_sql    STRING
DEFINE l_ima906        LIKE ima_file.ima906 #FUN-740187
DEFINE l_str           STRING
DEFINE l_sfp03_new     LIKE sfp_file.sfp03  #MOD-840551
DEFINE l_sfp03         LIKE sfp_file.sfp03  #FUN-860014
DEFINE l_sfb100        LIKE sfb_file.sfb100 #MOD-890117 
DEFINE l_sfb02         LIKE sfb_file.sfb02  #MOD-890117 
DEFINE l_pmm25         LIKE pmm_file.pmm25  #MOD-890117 
DEFINE l_pmm18         LIKE pmm_file.pmm18  #MOD-890117 
DEFINE l_sfa07         LIKE sfa_file.sfa07  #MOD-8A0088
DEFINE l_sfa05         LIKE sfa_file.sfa05  #MOD-8B0159 add
DEFINE l_sie11         LIKE sie_file.sie11  #No.FUN-A20048 add 
#DEFINE l_sie10        LIKE sie_file.sie10  #No.FUN-A20048 add #FUN-AC0074 mark
#DEFINE l_sig05        LIKE sig_file.sig05  #No.FUN-A20048 add #FUN-AC0074 mark

DEFINE lj_result       LIKE type_file.chr1  #No.FUN-930108 存s_incchk()返回值
DEFINE l_sfe01         LIKE sfe_file.sfe01
DEFINE l_sfe07         LIKE sfe_file.sfe07
DEFINE l_sfe14         LIKE sfe_file.sfe14
DEFINE l_sfe17         LIKE sfe_file.sfe17
DEFINE l_sfe27         LIKE sfe_file.sfe27
DEFINE l_sfe012        LIKE sfe_file.sfe012
DEFINE l_sfe013        LIKE sfe_file.sfe013
DEFINE l_sfa11         LIKE sfa_file.sfa11  #FUN-A70095
#TQC-C40174 ------------Begin--------------
DEFINE l_sfp06         LIKE sfp_file.sfp06
DEFINE l_rvbs06        LIKE rvbs_file.rvbs06
DEFINE l_r             LIKE type_file.chr1
DEFINE l_fac           LIKE img_file.img34
DEFINE l_ima918        LIKE ima_file.ima918
DEFINE l_ima921        LIKE ima_file.ima921
DEFINE l_img09         LIKE img_file.img09
DEFINE g_rvbs00        LIKE rvbs_file.rvbs00
DEFINE l_str1          STRING
DEFINE l_str2          STRING
#TQC-C40174 ------------End----------------
DEFINE l_rvbs09        LIKE rvbs_file.rvbs09     #TQC-C60083 
#DEFINE l_img_table     STRING                  #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table    STRING                  #FUN-C70087  #FUN-CC0095
DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
DEFINE l_flag          LIKE type_file.chr1     #FUN-C70087
DEFINE l_sfq04     LIKE sfq_file.sfq04     #MOD-D30125 
DEFINE l_sfq012    LIKE sfq_file.sfq012    #MOD-D30125 
DEFINE l_sfa013    LIKE sfa_file.sfa013    #MOD-D30125
DEFINE l_qty1      LIKE sfb_file.sfb08     #MOD-D30125
DEFINE l_qty2      LIKE sfb_file.sfb08     #MOD-D30125

   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-740187
   #IF NOT s_industry('icd') THEN  #CHI-C90045  #FUN-CC0095
      #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
      #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   #END IF  #CHI-C90045  #FUN-CC0095
   
   LET g_success='Y' #FUN-740187
   IF s_shut(0) THEN 
      LET g_success='N' 
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)       #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)     #FUN-CC0095
      #END IF  #CHI-C90045                        #FUN-CC0095
      RETURN 
   END IF
 
   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01=p_sfp01
    LET l_sfp.sfp03 = g_today   #add by wangxt170210
   IF l_sfp.sfp01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success='N' 
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)     #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)   #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   SELECT * INTO l_sfp.* FROM sfp_file
    WHERE sfp01 = l_sfp.sfp01
     LET l_sfp.sfp03 = g_today   #add by wangxt170210
   IF l_sfp.sfpconf = 'N' THEN
      CALL cl_err('','aba-100',1)
      LET g_success='N' 
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   #-->已扣帳
   IF l_sfp.sfp04 = 'Y' THEN
      CALL cl_err('sfp04=Y','asf-643',1)
      LET g_success='N' 
      #IF NOT s_industry('icd') THEN #CHI-C90045 #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   IF l_sfp.sfpconf = 'X' THEN  #FUN-660106
      CALL cl_err('','9024',1)
      LET g_success='N'
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   #No.TQC-B80182  --Begin
   #拆件式工单若有入库的时候,要卡一定有发料,至于发多少,不管控
   IF l_sfp.sfp06='6' THEN
      CALL i501sub_disassemble(l_sfp.sfp01,'2')
      IF g_success = 'N' THEN 
         #IF NOT s_industry('icd') THEN #CHI-C90045 #FUN-CC0095
         #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
         #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
         #END IF  #CHI-C90045  #FUN-CC0095
         RETURN 
      END IF
   END IF
   #No.TQC-B80182  --End

   LET l_sfp03 = l_sfp.sfp03                                                
   IF p_ask_post='Y' THEN  #FUN-840012 外部呼叫的程式不可出現詢問視窗
      IF NOT cl_confirm('mfg0176') THEN 
         LET g_success='N' 
         #IF NOT s_industry('icd') THEN #CHI-C90045 #FUN-CC0095
         #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
         #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
         #END IF  #CHI-C90045  #FUN-CC0095
         RETURN 
      END IF                                              
      INPUT l_sfp.sfp03 WITHOUT DEFAULTS FROM sfp03                                   
      
          AFTER FIELD sfp03
             IF NOT cl_null(l_sfp.sfp03) THEN
                IF g_sma.sma53 IS NOT NULL AND l_sfp.sfp03 <= g_sma.sma53 THEN
                   CALL cl_err('','mfg9999',0) 
                   NEXT FIELD sfp03
                END IF
                CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm
                IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                   CALL cl_err(l_yy,'mfg6090',0) 
                   NEXT FIELD sfp03
                END IF
                IF l_sfp.sfp06 = '4' THEN                                                                                           
                   LET l_cnt = 0                                                                                                    
                   SELECT COUNT(*) INTO l_cnt FROM sfu_file                                                                         
                    WHERE sfu09 = l_sfp.sfp03                                                                                       
                     #AND to_char(sfu02,'yy/mm') != to_char(l_sfp.sfp03,'yy/mm') #CHI-A70060 mark  
                      AND (YEAR(sfu02) != YEAR(l_sfp.sfp03) AND MONTH(sfu02) != MONTH(l_sfp.sfp03)) #CHI-A70060  
                   IF l_cnt > 0 THEN                                                                                                
                     #CALL cl_err(l_sfp.sfp03,'asf-140',0)   #MOD-D10032 mark                                                                       
                      CALL cl_err(l_sfp.sfp03,'asf1037',0)   #MOD-D10032 add                                                                       
                      NEXT FIELD sfp03                                                                                              
                   END IF                                                                                                           
                END IF                                                                                                              
             END IF
          AFTER INPUT 
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                LET l_sfp.sfp03=l_sfp03
                DISPLAY BY NAME l_sfp.sfp03
                LET g_success = 'N'
                #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
                #   CALL s_padd_img_drop(l_img_table)     #FUN-CC0095
                #   CALL s_padd_imgg_drop(l_imgg_table)   #FUN-CC0095
                #END IF  #CHI-C90045  #FUN-CC0095
                RETURN
             END IF
             IF NOT cl_null(l_sfp.sfp03) THEN
                IF g_sma.sma53 IS NOT NULL AND l_sfp.sfp03 <= g_sma.sma53 THEN
                   CALL cl_err('','mfg9999',0) 
                   NEXT FIELD sfp03
                END IF
                CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm
                IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                   CALL cl_err(l_yy,'mfg6090',0) 
                   NEXT FIELD sfp03
                END IF
             ELSE
                CONTINUE INPUT
             END IF
          ON ACTION CONTROLG 
             CALL cl_cmdask()
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
      END INPUT                                                                    
   
      DECLARE i501sub_s_c CURSOR FOR SELECT * FROM sfs_file
             WHERE sfs01 = p_sfp01
      LET g_success = "Y"
      CALL s_showmsg_init()
 
      FOREACH i501sub_s_c INTO l_sfs.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         CALL s_incchk(l_sfs.sfs07,l_sfs.sfs08,g_user)
             RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = l_sfs.sfs02,"/",l_sfs.sfs07,"/",l_sfs.sfs08,"/",g_user
            CALL s_errmsg('sfs02,sfs07,sfs08,inc03',g_showmsg,'','asf-888',1)
         END IF
         #str-------add by guanyao160804  #过账前判断批号是否是实发数量的一半
         #IF l_sfs.sfsud07 < (l_sfs.sfs05/2) THEN 
         #   CONTINUE FOREACH 
         #ELSE 
         #   CALL s_errmsg('sfs02,sfs04',l_sfs.sfs02,'','csf-063',1)
         #   LET g_success = 'N' 
         #   CONTINUE FOREACH 
         #END IF 
         #end-------add by guanyao160804
      END FOREACH
      CALL s_showmsg()
      IF g_success ='N' THEN
         #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
         #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
         #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
         #END IF  #CHI-C90045  #FUN-CC0095
         RETURN
      END IF
   END IF
   LET l_sfp03 = l_sfp.sfp03                                               
 
   IF g_sma.sma53 IS NOT NULL AND l_sfp.sfp03 <= g_sma.sma53 THEN  ##MOD-870053 modify
      CALL cl_err('','mfg9999',0)
      LET g_success='N'
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm  ##MOD-870053 modify sfp02->sfp03
 
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(l_yy,'mfg6090',0)
      LET g_success='N'
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM sfs_file
    WHERE sfs01 = l_sfp.sfp01
#     AND sfs05 > 0    #MOD-D60189 mark
 
   IF l_cnt = 0 THEN
      CALL cl_err('','asf-348',0)
      LET g_success='N'
      #IF NOT s_industry('icd') THEN #CHI-C90045  #FUN-CC0095
      #   CALL s_padd_img_drop(l_img_table)    #FUN-CC0095
      #   CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
      #END IF  #CHI-C90045  #FUN-CC0095
      RETURN
   END IF

   #FUN-C70087---begin
   DECLARE i501_s1_c4 CURSOR FOR SELECT * FROM sfs_file
     WHERE sfs01 = l_sfp.sfp01 
   #CHI-C90045
   IF s_industry('icd') THEN  
      FOREACH i501_s1_c4 INTO l_sfs.*
         IF STATUS THEN EXIT FOREACH END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM img_file
          WHERE img01 = l_sfs.sfs04
            AND img02 = l_sfs.sfs07
            AND img03 = l_sfs.sfs08
            AND img04 = l_sfs.sfs09
         IF l_cnt = 0 THEN
            CALL s_add_img(l_sfs.sfs04, l_sfs.sfs07,
                           l_sfs.sfs08, l_sfs.sfs09,
                           l_sfp.sfp01, l_sfs.sfs02,
                           l_sfp.sfp02)
         END IF
         #MOD-D30027---begin
         SELECT ima906 INTO l_ima906
           FROM ima_file
          WHERE ima01 = l_sfs.sfs04
         #IF g_sma.sma115 = 'Y' THEN
         IF g_sma.sma115 = 'Y' AND (l_ima906 = '2' OR l_ima906 = '3') THEN
         #MOD-D30027---end
            CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,
                            l_sfs.sfs08,l_sfs.sfs09,
                            l_sfs.sfs30) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,
                               l_sfs.sfs08,l_sfs.sfs09,
                               l_sfs.sfs30,l_sfs.sfs31,
                               l_sfp.sfp01,
                               l_sfs.sfs02,0) RETURNING l_flag
            END IF 
            CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,
                            l_sfs.sfs08,l_sfs.sfs09,
                            l_sfs.sfs33) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,
                               l_sfs.sfs08,l_sfs.sfs09,
                               l_sfs.sfs33,l_sfs.sfs34,
                               l_sfp.sfp01,
                               l_sfs.sfs02,0) RETURNING l_flag              
            END IF
         END IF    
      END FOREACH 
   ELSE
   #CHI-C90045---end
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   FOREACH i501_s1_c4 INTO l_sfs.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_sfs.sfs04
         AND img02 = l_sfs.sfs07
         AND img03 = l_sfs.sfs08
         AND img04 = l_sfs.sfs09
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfp.sfp01,l_sfs.sfs02,l_sfp.sfp03,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfp.sfp01,l_sfs.sfs02,l_sfp.sfp03) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,
                       l_sfs.sfs08,l_sfs.sfs09,
                       l_sfs.sfs30) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs30,l_sfp.sfp01,l_sfs.sfs02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs30,l_sfp.sfp01,l_sfs.sfs02) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,
                       l_sfs.sfs08,l_sfs.sfs09,
                       l_sfs.sfs33) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs33,l_sfp.sfp01,l_sfs.sfs02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs33,l_sfp.sfp01,l_sfs.sfs02) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
            
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095 
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_drop(l_img_table) #FUN-CC0095 
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
               #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095 
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095 
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
               #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
               RETURN 
            END IF 
         END IF #FUN-CC0095 
      ELSE
         #CALL s_padd_img_drop(l_img_table) #FUN-CC0095 
         #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095 
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
         #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095 
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095 
   #FUN-C70087---end
   END IF  #CHI-C90045
   LET g_mescnt = 1           #FUN-C10035 add

   DECLARE i501_s1_c3 CURSOR FOR SELECT * FROM sfs_file
     WHERE sfs01 = l_sfp.sfp01
      LET g_success = "Y"

      IF cl_null(g_aimp880) THEN   #CHI-C80013 add
         CALL s_showmsg_init()   #No.FUN-6C0083 
      END IF                       #CHI-C80013 add
 
   FOREACH i501_s1_c3 INTO l_sfs.*
      IF STATUS THEN
         EXIT FOREACH
      END IF

#TQC-C40174 -----------------Begin-----------------
      LET l_str2 = g_prog
      LET l_str1 = l_str2.subString(1,6)
      IF l_str1 = 'asfi51' THEN
         IF g_prog = 'asfi510' THEN
            SELECT sfp06 INTO l_sfp06 FROM sfp_file
             WHERE sfp01 = p_sfp01
            IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF
            IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF
            IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF
            IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF
            IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF   #FUN-C70014
         ELSE
            LET g_rvbs00 = g_prog
         END IF
      END IF

      IF l_str1 = 'asfi52' THEN
         IF g_prog = 'asfi520' THEN
           SELECT sfp06 INTO l_sfp06 FROM sfp_file
            WHERE sfp01 = p_sfp01
           IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi526' END IF
           IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi527' END IF
           IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi528' END IF
           IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi529' END IF
         ELSE
           LET g_rvbs00 = g_prog
         END IF
      END IF


      SELECT ima918,ima921 INTO l_ima918,l_ima921
        FROM ima_file
       WHERE ima01 = l_sfs.sfs04
         AND imaacti = "Y"

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN

#TQC-C60083 ---------------Begin----------------
           IF l_sfp.sfp06 MATCHES '[6789B]' THEN 
              LET l_rvbs09 =1 
           ELSE 
              LET l_rvbs09 = -1 
           END IF 
#TQC-C60083 ---------------End------------------

         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_rvbs00  #TQC-9C0174
            AND rvbs01 = l_sfs.sfs01
            AND rvbs02 = l_sfs.sfs02
         #  AND rvbs09 = -1         #TQC-C60083  mark
            AND rvbs09 = l_rvbs09   #TQC-C60083
            AND rvbs13 = 0

         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF

         SELECT img09 INTO l_img09
           FROM img_file
          WHERE img01=l_sfs.sfs04
            AND img02=l_sfs.sfs07
            AND img03=l_sfs.sfs08
            AND img04=l_sfs.sfs09

         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_img09)
              RETURNING l_r,l_fac

         IF l_r = 1 THEN LET l_fac = 1 END IF

         IF (l_sfs.sfs05 * l_fac) <> l_rvbs06 THEN
            IF g_bgerr THEN
              CALL s_errmsg('sfs01','','','aim-011',1)
            ELSE
              CALL cl_err(l_sfs.sfs04,"aim-011",1)
            END IF
            LET g_totsuccess='N'
            EXIT FOREACH
         END IF
      END IF
#TQC-C40174 -----------------End-------------------

     #FUN-C10035 add str -----
     #當與MES整合,檢查此張發料單的工單是否有混雜:與MES整合工單及不與MES整合的工單
     #與MES整合:工單型態(sfb02)= 1 or 13   
      IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
         CALL i501_sub_chk_sfb01(l_sfs.sfs03,g_mescnt)  #傳入:工單單號,第幾筆資料
         IF g_mesflag <> g_mesflag_t THEN               #本張工單的整合類型與上張工單不符
            CALL cl_err('','asf-146',1)                 #與MES整合時,發料單內的工單型態需一致
            LET g_success = "N"
            EXIT FOREACH
         END IF
         LET g_mescnt = g_mescnt + 1
      END IF
     #FUN-C10035 add end -----
 
      IF NOT s_industry('icd') THEN  #FUN-910077
         SELECT sfb02,sfb100 INTO l_sfb02,l_sfb100 FROM sfb_file                                                                               
          WHERE sfb01 = l_sfs.sfs03    
         IF (l_sfb02 = '7' OR l_sfb02 = '8') AND l_sfb100 = '1' THEN
            DECLARE i501_s1_c9 CURSOR FOR 
            SELECT pmm25,pmm18  INTO  l_pmm25,l_pmm18
              FROM pmm_file,pmn_file
             WHERE pmm01=pmn01
               AND pmn41=l_sfs.sfs03
            FOREACH i501_s1_c9 INTO l_pmm25,l_pmm18
              IF l_pmm25='2' AND l_pmm18='Y' THEN
                 CONTINUE FOREACH
              ELSE
                LET g_showmsg = l_sfs.sfs03
                IF g_bgerr THEN
                  CALL s_errmsg('sfs03',g_showmsg,'','mfg3333',1)
                ELSE
                  CALL cl_err(g_showmsg,'mfg3333',0)
                END IF
                LET g_totsuccess='N'
                LET g_success="Y"
              END IF
            END FOREACH
         END IF
      END IF
      
      SELECT COUNT(*) INTO l_cnt FROM img_file
       WHERE img01 = l_sfs.sfs04   #料號
         AND img02 = l_sfs.sfs07   #倉庫
         AND img03 = l_sfs.sfs08   #儲位
         AND img04 = l_sfs.sfs09   #批號
         AND img18 < l_sfp.sfp03   #扣帳日
      IF l_cnt > 0 THEN    #大於有效日期
          LET g_showmsg = l_sfs.sfs04,"/",l_sfs.sfs07,"/",l_sfs.sfs08,"/",l_sfs.sfs09
          IF g_bgerr THEN
            CALL s_errmsg('sfs04,sfs07,sfs08,sfs09',g_showmsg,'','aim-400',1)
         ELSE
            CALL cl_err(g_showmsg,'aim-400',0)   #須修改
         END IF
         LET g_totsuccess='N'
         LET g_success="Y"
         CONTINUE FOREACH   
      END IF
      IF g_prog = 'asfi513' THEN
         IF cl_null(l_sfs.sfs012) THEN LET l_sfs.sfs012=' ' END IF   #FUN-A50066 add
         IF cl_null(l_sfs.sfs013) THEN LET l_sfs.sfs013=0   END IF   #FUN-A50066 add
         CALL s_shortqty(l_sfs.sfs03,l_sfs.sfs04,l_sfs.sfs10,
                   l_sfs.sfs06,l_sfs.sfs27,
                   l_sfs.sfs012,l_sfs.sfs013)   #FUN-A50066 add
              RETURNING l_sfa07
         IF cl_null(l_sfa07) THEN LET l_sfa07 = 0 END IF
         IF l_sfs.sfs05 > l_sfa07 THEN
            LET l_str = ''
            LET l_str = l_sfs.sfs03,' -',l_sfs.sfs04,' -',l_sfs.sfs05,'>',l_sfa07,'\n'
            IF g_bgerr THEN 
               CALL s_errmsg('sfs03,sfs04,sfs05',l_str,'','asf-987',1)
            ELSE
               CALL cl_err(l_str,'asf-987',1)
            END IF 
            LET g_totsuccess = 'N'
            EXIT FOREACH
         END IF
      END IF
       #當應發數(sfa05)為0時不可過帳
      IF g_prog = 'asfi511' THEN
         IF l_sfs.sfs26 MATCHES '[SUTBC]' THEN   #TQC-C30044 add 'BC'
           #MOD-C20095 str add-----
           #SELECT sfa05 INTO l_sfa05 FROM sfa_file
           # WHERE sfa01 = l_sfs.sfs03
           #   AND sfa03 = l_sfs.sfs04      #No.FUN-940008
           #   AND sfa08 = l_sfs.sfs10
           #   AND sfa12 = l_sfs.sfs06
           #  #AND sfa27 = l_sfs.sfs27  #FUN-9B0149 ##TQC-B60091
           #   AND sfa012= l_sfs.sfs012  #FUN-A60028 
           #   AND sfa013= l_sfs.sfs013  #FUN-A60028
           #IF cl_null(l_sfa05) OR l_sfa05 = 0 THEN
           #   SELECT sfa05 INTO l_sfa05 FROM sfa_file
           #    WHERE sfa01 = l_sfs.sfs03
           #      AND sfa03 = l_sfs.sfs04
           #      AND sfa08 = l_sfs.sfs10
           #      AND sfa12 = l_sfs.sfs06
           #      AND sfa27 = l_sfs.sfs27  #FUN-9B0149
           #      AND sfa012= l_sfs.sfs012  #FUN-A60028 
           #      AND sfa013= l_sfs.sfs013  #FUN-A60028       
           #END IF
            IF g_sma.sma107 = 'N' THEN
               SELECT sfa05 INTO l_sfa05 FROM sfa_file
                WHERE sfa01 = l_sfs.sfs03
                  AND sfa03 = l_sfs.sfs04
                  AND sfa08 = l_sfs.sfs10
                  AND sfa12 = l_sfs.sfs06
                  AND sfa012= l_sfs.sfs012
                  AND sfa013= l_sfs.sfs013
            ELSE
               SELECT sum(sfa05) INTO l_sfa05 FROM sfa_file
                WHERE sfa01 = l_sfs.sfs03
                  AND sfa08 = l_sfs.sfs10
                  AND sfa12 = l_sfs.sfs06
                  AND sfa27 = l_sfs.sfs27
                  AND sfa012= l_sfs.sfs012
                  AND sfa013= l_sfs.sfs013
            END IF
           #MOD-C20095 end add-----
         ELSE
            SELECT sfa05 INTO l_sfa05 FROM sfa_file
             WHERE sfa01 = l_sfs.sfs03
               AND sfa03 = l_sfs.sfs04
               AND sfa08 = l_sfs.sfs10
               AND sfa12 = l_sfs.sfs06
               AND sfa27 = l_sfs.sfs27   #FUN-940008 add
               AND sfa012= l_sfs.sfs012  #FUN-A60028 
               AND sfa013= l_sfs.sfs013  #FUN-A60028     
         END IF             #MOD-940308 add
         IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF
         IF l_sfa05 = 0 THEN
            LET l_str = ''
            LET l_str = l_sfs.sfs03,' -',l_sfs.sfs04,'\n'
            IF g_bgerr THEN
               CALL s_errmsg('sfs03,sfs04',l_str,'','asf-081',1)
            ELSE
               CALL cl_err(l_str,'asf-081',1)
            END IF
            LET g_totsuccess='N'
            LET g_success="Y"
            CONTINUE FOREACH
         END IF
      END IF
     END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     
     IF cl_null(g_aimp880) THEN   #CHI-C80013 add 
        CALL s_showmsg()   
     END IF                       #CHI-C80013 add   
     IF g_success = 'N' THEN 
        IF NOT s_industry('icd') THEN #CHI-C90045
           #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095   
           #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
        END IF  #CHI-C90045
        RETURN 
     END IF  #No.MOD-8A0088
   
     IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
        SELECT COUNT(*) INTO l_cnt FROM sfq_file,sfb_file
         WHERE sfq01 = l_sfp.sfp01
     AND sfq02 = sfb01
     AND sfb81 > l_sfp.sfp03
        IF l_cnt > 0 THEN
           CALL cl_err('','asf-349',0)
           LET g_success='N' 
           IF NOT s_industry('icd') THEN #CHI-C90045
              #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
              #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
           END IF  #CHI-C90045
           RETURN
        END IF
     END IF
   
     IF l_sfp.sfp06 = '6' THEN    #成套退料                                                                                           
       #LET l_sql = "SELECT DISTINCT sfq02 FROM sfq_file",               #MOD-D30125 mark   
        LET l_sql = "SELECT DISTINCT sfq02,sfq04,sfq012 FROM sfq_file",  #MOD-D30125          
        " WHERE sfq01 = '",l_sfp.sfp01,"'"                                                                                
        PREPARE i526_prepare FROM l_sql                                                                                               
        DECLARE i526_sfq02 CURSOR FOR i526_prepare                                                                                    
       #FOREACH i526_sfq02 INTO l_sfq02                  #MOD-D30125        
        FOREACH i526_sfq02 INTO l_sfq02,l_sfq04,l_sfq012 #MOD-D30125   
           #MOD-D30125---begin
             IF NOT cl_null(l_sfq04) AND l_sfq04 <> ' ' AND g_sma.sma73 = 'Y' THEN
                IF cl_null(l_sfq012) THEN LET l_sfq012 = ' ' END IF 
                SELECT MIN(sfa013) INTO l_sfa013
                  FROM sfa_file
                 WHERE sfa01 = l_sfq02
                   AND sfa08 = l_sfq04
                   AND sfa012 = l_sfq012
                IF cl_null(l_sfa013) THEN LET l_sfa013 = 0 END IF 
                LET l_cnt=0  
                CALL s_minp_routing(l_sfq02,g_sma.sma73,0,l_sfq04,l_sfq012,l_sfa013)
                     RETURNING l_cnt,l_qty1

                SELECT ecm311+ecm312+ecm313+ecm314+ecm316+ecm321-ecm322 INTO l_qty2
                  FROM ecm_file
                 WHERE ecm01 = l_sfq02
                   AND ecm04 = l_sfq04
                   AND ecm012 = l_sfq012
                IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF 
                LET l_qty = l_qty1 - l_qty2
             ELSE  
            #MOD-D30125---end               
                SELECT sfb081-sfb09 INTO l_qty FROM sfb_file                                                                               
                WHERE sfb01 = l_sfq02          
             END IF  #MOD-D30125
     IF cl_null(l_qty) THEN LET l_qty = 0 END IF                                                                                
     SELECT sfq03 INTO l_sfq03 FROM sfq_file                                                                                    
      WHERE sfq01 = l_sfp.sfp01                                                                                                 
        AND sfq02 = l_sfq02                                                                                                     
     IF l_sfq03 > l_qty THEN                                                                                                    
        CALL cl_err(l_sfq03,'asf-705',0)                                                                                        
        LET g_success='N' 
        IF NOT s_industry('icd') THEN #CHI-C90045
           #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
           #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
        END IF  #CHI-C90045
        RETURN                                                                                                                  
     END IF                                                                                                                     
        END FOREACH                                                                                                                   
     END IF                                                                                                                           
   
     IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
         LET l_sfq02=NULL
         DECLARE i501_cs10 CURSOR FOR
    SELECT sfq02 FROM sfq_file
     WHERE sfq02 NOT IN (SELECT sfs03 FROM sfs_file WHERE sfs01=l_sfp.sfp01)
       AND sfq01=l_sfp.sfp01
      #AND sfq03 > 0       #MOD-B60169 mark
       AND sfq03 >= 0      #MOD-B60169 add
   
         FOREACH i501_cs10 INTO l_sfq02
      IF STATUS THEN LET l_sfq02=NULL END IF
      EXIT FOREACH
         END FOREACH
   
         IF NOT cl_null(l_sfq02) THEN
            CALL cl_err(l_sfq02,'asf-361',0)
            LET g_success='N' 
            IF NOT s_industry('icd') THEN #CHI-C90045
               #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
               #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
            END IF  #CHI-C90045
            RETURN
         END IF
     END IF
   
     #成套發料須check工單套數資料要存在--for計算成本用
    #IF l_sfp.sfp06 = '1' THEN  #FUN-740187
     IF l_sfp.sfp06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM sfq_file
         WHERE sfq01 = l_sfp.sfp01
        IF l_cnt = 0 THEN
           CALL cl_err('','asf-363',0)
           LET g_success='N' 
           IF NOT s_industry('icd') THEN #CHI-C90045
              #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
              #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
           END IF  #CHI-C90045
           RETURN
        END IF
     END IF
   
     LET l_sfp03_new=l_sfp.sfp03  #MOD-840551
     IF cl_null(l_sfp03_new) THEN
        LET l_sfp03_new=l_sfp.sfp02
     END IF
     IF p_ask_post='Y' THEN #FUN-740187
        LET l_sfp.sfp03=l_sfp03_new
        DISPLAY BY NAME l_sfp.sfp03
        LET l_sfp03_new=l_sfp.sfp03
     END IF
   
     IF NOT p_inTransaction THEN #FUN-740187
        BEGIN WORK
     END IF
    
     #str-----add by guanyao160721
     IF l_sfp.sfp06 = '1' OR l_sfp.sfp06 = '3' OR l_sfp.sfp06 = '2' THEN
        IF g_success = 'Y' THEN 
           #CALL i501_ins_sel(l_sfp.sfp01)               #mark by guanyao17
           CALL i501_ins_sel(l_sfp.sfp01,l_sfp03_new)
        END IF 
     END IF 
     #end-----add by guanyao160721
     #str-----add by guanyao160804
     #IF l_sfp.sfp06 = '1' OR l_sfp.sfp06 = '3' THEN
     #   IF g_success = 'Y' THEN 
     #      CALL i501_upd_sfs(l_sfp.sfp01)
     #   END IF
     #END IF 
     #end-----add by gaunyao160804
   
 #  IF g_success = 'Y' THEN  #FUN-B80093 mark                              #MOD-C10100    #TQC-C10033
     IF g_success = 'Y' AND  g_sma.sma93 = 'Y' THEN  #FUN-B80093 add      #MOD-C10100   因正式區sma32未增加好，暫MARK，待後續還原  #TQC-C10033
        DECLARE i501sub_sfs_cs CURSOR FOR SELECT * FROM sfs_file
          WHERE sfs01 = l_sfp.sfp01 ORDER BY sfs07,sfs08 
   
     LET g_cnt_vmi = 1
     FOREACH i501sub_sfs_cs INTO g_sfs_vmi[g_cnt_vmi].*
        IF STATUS THEN EXIT FOREACH END IF
        SELECT COUNT(*) INTO l_cnt
          FROM pmc_file
         WHERE pmc917 = g_sfs_vmi[g_cnt_vmi].sfs07
           AND pmc918 = g_sfs_vmi[g_cnt_vmi].sfs08
        IF l_cnt = 0 THEN CONTINUE FOREACH  END IF
        IF l_cnt > 0 THEN 
           CALL i501sub_VMI_settlement(l_sfp.*,g_sfs_vmi[g_cnt_vmi].*) 
        END IF    
        LET g_cnt_vmi = g_cnt_vmi + 1
     END FOREACH
     LET g_cnt_vmi = g_cnt_vmi - 1
     END IF
     #FUN-A20048 add --begin
     IF g_success = 'Y' THEN
        IF l_sfp.sfp06 MATCHES '[13]' THEN  #FUN-AC0074
            DECLARE  i501sub_sif_cs CURSOR FOR SELECT * FROM sfs_file 
              WHERE sfs01 = l_sfp.sfp01 
            FOREACH i501sub_sif_cs INTO g_sfs_sif.*
              IF STATUS THEN EXIT FOREACH END IF
              CALL s_updsie_sie(g_sfs_sif.sfs01,g_sfs_sif.sfs02,'1') #FUN-AC0074 add
            END FOREACH  #FUN-AC0074 add  
        END IF #FUN-AC0074
         #FUN-AC0074--mark-------
         #LET l_cnt = 0                   
         #SELECT COUNT(*) INTO l_cnt FROM sia_file,sic_file WHERE sia01=sic01 AND siaconf='Y'
         #   AND sic03=g_sfs_sif.sfs03 
         #IF l_cnt = 0 THEN CONTINUE FOREACH END IF 
         #IF l_cnt >0 THEN  
         #LET l_cnt = 0         
         #SELECT COUNT(*),SUM(sie11) INTO l_cnt,l_sie11 #TQC-AC0298
         #  FROM sie_file 
         # WHERE sie01= g_sfs_sif.sfs04 AND sie02= g_sfs_sif.sfs07
         #   AND sie03=g_sfs_sif.sfs08 AND sie04=g_sfs_sif.sfs09 AND sie05= g_sfs_sif.sfs03 AND sie06=g_sfs_sif.sfs10
         #   AND sie07=g_sfs_sif.sfs06 AND sie08=g_sfs_sif.sfs27 AND sie11 > 0   #TQC-AC0298               
         #   AND sie012=g_sfs_sif.sfs012  #FUN-A60028 
         #   AND sie013=g_sfs_sif.sfs013  #FUN-A60028 
         #IF l_cnt > 0 THEN   
         # IF l_sie11 >= g_sfs_sif.sfs05  THEN  #TQC-AC0298 
         #    UPDATE sie_file SET sie10 = sie10+g_sfs_sif.sfs05,sie11= sie11-g_sfs_sif.sfs05,sie12 = g_today, 
         #                         sie13 = g_sfs_sif.sfs01,sie14 = g_sfs_sif.sfs02 
         #      WHERE sie01= g_sfs_sif.sfs04 
         #        AND sie02= g_sfs_sif.sfs07
         #        AND sie03=g_sfs_sif.sfs08 
         #        AND sie04=g_sfs_sif.sfs09 
         #        AND sie05= g_sfs_sif.sfs03 
         #        AND sie06=g_sfs_sif.sfs10
         #        AND sie07=g_sfs_sif.sfs06  #TQC-AC0298 
         #        AND sie08=g_sfs_sif.sfs27 
         #        AND sie012=g_sfs_sif.sfs012    #FUN-A60028 
         #        AND sie013=g_sfs_sif.sfs013    #FUN-A60028 
         #     IF SQLCA.SQLERRD[3]=0 THEN
         #        CALL cl_err3("upd","sie_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
         #        LET g_success = 'N'             
         #     END IF
         # ELSE 
         #   UPDATE sie_file SET sie10 = g_sfs_sif.sfs05,sie11= 0,sie12 = g_today,
         #                       sie13 = g_sfs_sif.sfs01,sie14 = g_sfs_sif.sfs02 
         #    WHERE sie01= g_sfs_sif.sfs04 
         #      AND sie02= g_sfs_sif.sfs07
         #      AND sie03=g_sfs_sif.sfs08 
         #      AND sie04=g_sfs_sif.sfs09 
         #      AND sie05= g_sfs_sif.sfs03 
         #      AND sie06=g_sfs_sif.sfs10
         #      AND sie07=g_sfs_sif.sfs06  #TQC-AC0298 
         #      AND sie08=g_sfs_sif.sfs27 
         #      AND sie012=g_sfs_sif.sfs012  #FUN-A60028 
         #      AND sie013=g_sfs_sif.sfs013  #FUN-A60028   
         #   IF SQLCA.SQLERRD[3]=0 THEN
         #      CALL cl_err3("upd","sie_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
         #      LET g_success = 'N'             
         #   END IF            
         # END IF 
         # LET l_cnt = 0 
         # SELECT COUNT(*),SUM(sig05) INTO l_cnt,l_sig05  #TQC-AC0298
         #    FROM sig_file WHERE sig01 = g_sfs_sif.sfs04 AND sig02 = g_sfs_sif.sfs07
         # AND sig03= g_sfs_sif.sfs08 AND sig04 = g_sfs_sif.sfs09
         # AND sig05 > 0 
         # IF l_cnt > 0 THEN 
         #   IF l_sig05 >= g_sfs_sif.sfs05 THEN #TQC-AC0298
         #     UPDATE sig_file SET sig05 =sig05-g_sfs_sif.sfs05,sig07 = g_today
         #        WHERE sig01 = g_sfs_sif.sfs04 AND sig02 = g_sfs_sif.sfs07
         #     AND sig03= g_sfs_sif.sfs08 AND sig04 = g_sfs_sif.sfs09
         #     IF SQLCA.SQLERRD[3]=0 THEN
         #        CALL cl_err3("upd","sig_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
         #        LET g_success = 'N'             
         #     END IF
         #   ELSE 
         #     CALL cl_err('g_sfs_sif.sfs01','asf-901',1)
         #     LET g_success ='N'
         #     RETURN
         #   END IF 
         # END IF 
         # CALL i501sub_ins_sif('1',g_sfs_sif.*) 
         #END IF 
         #END IF 
        #END FOREACH   
        #FUN-AC0074--end--mark------
      END IF    
     #FUN-A20048 add --end
   
     CALL i501sub_lock_cl()
   
     OPEN i501sub_cl USING l_sfp.sfp01
     IF STATUS THEN
        CALL cl_err("OPEN i501sub_cl:", STATUS, 1)
        CLOSE i501sub_cl
        IF NOT p_inTransaction THEN ROLLBACK WORK END IF #FUN-740187
        LET g_success='N' 
        IF NOT s_industry('icd') THEN #CHI-C90045
           #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
           #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
        END IF  #CHI-C90045
        RETURN
     END IF
   
     FETCH i501sub_cl INTO l_sfp.*          # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err(l_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i501sub_cl
        IF NOT p_inTransaction THEN ROLLBACK WORK END IF #FUN-740187
        LET g_success='N' 
        IF NOT s_industry('icd') THEN #CHI-C90045
           #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
           #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
        END IF  #CHI-C90045
        RETURN
     END IF
   
     LET l_sfp.sfp03 = l_sfp03_new   #MOD-880077 add
   
   
     UPDATE sfp_file SET sfp04='Y',
             sfp03=l_sfp03_new   #MOD-840551
            #sfpmodu=g_user,                  #MOD-A90175 mark       
            #sfpdate=g_today  #NO:6908        #MOD-A90175 mark   
       WHERE sfp01=l_sfp.sfp01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp04",1)  #No.FUN-660128
        LET g_success = 'N'
     ELSE
        LET l_sfp.sfp04='Y' #FUN-740187
        CALL i501sub_s1(l_sfp.*) RETURNING l_sfp.*
        IF g_success = 'Y' THEN
     IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
        CALL i501sub_s2(p_argv1,l_sfp.*)
     ELSE
        CALL i501sub_s2_asr(p_argv1,l_sfp.*) #FUN-5C0114
     END IF
        END IF
     END IF
  #No.FUN-A10001  mark by dxfwo 
  #   IF g_success = 'Y' THEN
  #      CALL i501sub_VMI_settlement(l_sfp.*)
  #   END IF
  #No.FUN-A10001  mark by dxfwo  
   
     IF s_industry('icd') THEN
        CALL i501sub_ind_icd_upd_sfb08('Y',l_sfp.*)
     END IF

  #FUN-9A0095 add MES ----
   IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
      IF g_mesflag = 'Y' THEN          #FUN-C10035 add
        # CALL aws_mescli()
        # 傳入參數: (1)程式代號(2)功能選項：insert(新增),update(修改),delete(刪除)(3)Key
        #發料單過帳
        #IF l_sfp.sfp06 MATCHES "[1234]" THEN
        IF l_sfp.sfp06 MATCHES "[1234D]" THEN #FUN-C70014 add 'D'
           IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN  #FUN-CC0122 add
              CASE aws_mescli('asfi511','insert',l_sfp.sfp01)
                 WHEN 1       #呼叫 MES 成功
                      MESSAGE 'UPDATA O.K, UPDATA MES O.K'
                 WHEN 2       #呼叫 MES 失敗
                      LET g_success = 'N'
                 OTHERWISE    #其他異常
                      LET g_success = 'N'
              END CASE
           END IF
         END IF                                                     #FUN-CC0122 add
        
        #退料單過帳
        #IF l_sfp.sfp06 MATCHES "[5678]" AND g_aza.aza96 MATCHES "[Nn]" THEN #CHI-A70060 mark
         IF l_sfp.sfp06 MATCHES "[6789]" AND g_aza.aza96 MATCHES "[Nn]" THEN #CHI-A70060
           CASE aws_mescli('asfi526','insert',l_sfp.sfp01)
              WHEN 1       #呼叫 MES 成功
                   MESSAGE 'UPDATA O.K, UPDATA MES O.K'
              WHEN 2       #呼叫 MES 失敗
                   LET g_success = 'N'
              OTHERWISE    #其他異常
                   LET g_success = 'N'
           END CASE
         END IF
      END IF                             #FUN-C10035 add
   END IF
  #FUN-9A0095 add end-----
   
     #FUN-AC0074--begin--add--
     DECLARE i501sub_sie_c CURSOR FOR
      SELECT DISTINCT sfe01,sfe07,sfe14,sfe17,sfe27,sfe012,sfe013
        FROM sfe_file 
       WHERE sfe02=l_sfp.sfp01
     #SELECT DISTINCT sfs03,sfs04,sfs10,sfs06,sfs27.sfs012,sfs013
     #  FROM sfs_file 
     # WHERE sfs01=l_sfp.sfp01
     FOREACH i501sub_sie_c INTO l_sfe01,l_sfe07,l_sfe14,l_sfe17,l_sfe27,l_sfe012,l_sfe013
              SELECT sfa06,sfa05 INTO l_sfa06,l_sfa05 FROM sfa_file
               WHERE sfa01 = l_sfe01
                 AND sfa03 = l_sfe07
                 AND sfa08 = l_sfe14
                 AND sfa12 = l_sfe17
                 AND sfa27 = l_sfe27
                 AND sfa012= l_sfe012
                 AND sfa013= l_sfe013
              IF cl_null(l_sfa06) THEN LET l_sfa06=0 END IF
              IF cl_null(l_sfa05) THEN LET l_sfa05=0 END IF
              #FUN-A70095--begin
              SELECT sfa11 INTO l_sfa11 FROM sfa_file 
               WHERE sfa01 = l_sfe01
                 AND sfa03 = l_sfe07
                 AND sfa08 = l_sfe14
                 AND sfa12 = l_sfe17
                 AND sfa27 = l_sfe27
                 AND sfa012= l_sfe012
                 AND sfa013= l_sfe013
              IF l_sfa11='S' THEN    
                 IF l_sfa06 <0 THEN 
                    LET l_sfa06=l_sfa06*-1
                 END IF 
                 IF l_sfa05<0 THEN 
                     LET l_sfa05=l_sfa05*-1
                 END IF 
              END IF 
              #FUN-A70095--end
              SELECT SUM(sie11) INTO l_sie11 FROM sie_file
               WHERE sie05 = l_sfe01
                 AND sie01 = l_sfe07
                 AND sie06 = l_sfe14
                 AND sie07 = l_sfe17
                 AND sie08 = l_sfe27
                 AND sie012= l_sfe012
                 AND sie013= l_sfe013
               IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
               IF l_sfa06+l_sie11 > l_sfa05 THEN
                  LET g_success = 'N'
                  CALL cl_err('','asf-889',1)
                  EXIT FOREACH
               END IF
     END FOREACH
     #FUN-AC0074--end--add-----
     IF g_success = 'Y' THEN #TQC-960059
        IF NOT p_inTransaction THEN #FUN-740187
     COMMIT WORK
        END IF #TQC-960059
        CALL cl_flow_notify(l_sfp.sfp01,'S')
     ELSE
       IF NOT p_inTransaction THEN  #TQC-960059
     ROLLBACK WORK
       END IF
     END IF
  #   IF g_success = 'Y' AND g_flag_vmi = 'Y' THEN
  #     CALL i501sub_VMI_conf(l_sfp.sfp01)
        IF g_success = 'N' THEN
          IF NOT p_inTransaction THEN           #MOD-B10169
             CALL i501sub_z('1',l_sfp.sfp01,'',TRUE)
          END IF                                #MOD-B10169
          IF NOT s_industry('icd') THEN #CHI-C90045
             #CALL s_padd_img_drop(l_img_table)   #FUN-CC0095 
             #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095 
          END IF  #CHI-C90045
          RETURN
        END IF
  #   END IF
     SELECT sfp04,sfpmodu,sfpdate     #NO:6908
       INTO l_sfp.sfp04,l_sfp.sfpmodu,l_sfp.sfpdate
       FROM sfp_file WHERE sfp01=l_sfp.sfp01
     IF l_sfp.sfp04 = "N" THEN
        DECLARE i501_s1_c2 CURSOR FOR SELECT * FROM sfs_file
    WHERE sfs01 = l_sfp.sfp01
   
        LET l_imm01 = ""
        LET g_success = "Y"

        IF cl_null(g_aimp880) THEN   #CHI-C80013 add
           CALL s_showmsg_init()   #No.FUN-6C0083 
        END IF                       #CHI-C80013 add   
   
        IF NOT p_inTransaction THEN #FUN-740187
           BEGIN WORK
        END IF
   
        FOREACH i501_s1_c2 INTO l_sfs.*
     IF STATUS THEN
        EXIT FOREACH
     END IF
     IF g_sma.sma115 = 'Y' THEN
        SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_sfs.sfs04  #FUN-740187
        IF l_ima906 = '2' THEN  #子母單位
           LET l_unit_arr[1].unit= l_sfs.sfs30
           LET l_unit_arr[1].fac = l_sfs.sfs31
           LET l_unit_arr[1].qty = l_sfs.sfs32
           LET l_unit_arr[2].unit= l_sfs.sfs33
           LET l_unit_arr[2].fac = l_sfs.sfs34
           LET l_unit_arr[2].qty = l_sfs.sfs35
           CALL s_dismantle(l_sfp.sfp01,l_sfs.sfs02,l_sfp.sfp03,
          l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
          l_sfs.sfs09,l_unit_arr,l_imm01)
            RETURNING l_imm01
           IF g_success='N' THEN 
        LET g_totsuccess='N'
        LET g_success="Y"
        CONTINUE FOREACH   #No.FUN-6C0083
           END IF
        END IF
     END IF
        END FOREACH
   
        IF g_totsuccess="N" THEN
     LET g_success="N"
        END IF

        IF cl_null(g_aimp880) THEN   #CHI-C80013 add
           CALL s_showmsg()   #No.FUN-6C0083
        END IF                       #CHI-C80013 add
   
        IF NOT p_inTransaction THEN
     IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
        COMMIT WORK
        LET l_str="aimt324 '",l_imm01,"'"
        CALL cl_cmdrun_wait(l_str)
     ELSE
        ROLLBACK WORK
     END IF
        ELSE
     IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
        LET l_str="aimt324 '",l_imm01,"'"
        CALL cl_cmdrun_wait(l_str)
     END IF
        END IF
     END IF
     IF NOT s_industry('icd') THEN #CHI-C90045
        #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095 
        #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095 
     END IF  #CHI-C90045
  END FUNCTION

  #FUN-A20048 --begin 
  #FUN-AC0074--begin--mark-----
  #FUNCTION i501sub_ins_sif(p_sia04,l_sfs)
  # DEFINE p_sia04      LIKE sia_file.sia04
  # DEFINE l_sfs        RECORD LIKE sfs_file.*
  # DEFINE l_sif        RECORD LIKE sif_file.*
  #
  # INITIALIZE l_sif.* TO NULL
  #      CASE p_sia04
  #  WHEN '1'  #備置
  #     LET l_sif.sif09=1
  #  WHEN '2'  #退備置
  #     LET l_sif.sif09=-1
  #      END CASE  
  #  LET l_sif.sif01 = l_sfs.sfs04
  #  LET l_sif.sif02 = l_sfs.sfs07
  #  LET l_sif.sif03 = l_sfs.sfs08
  #  LET l_sif.sif04 = l_sfs.sfs09
  #  LET l_sif.sif05 = l_sfs.sfs03
  #  LET l_sif.sif06 = l_sfs.sfs10
  #  LET l_sif.sif07 = l_sfs.sfs06  #TQC-AC0298
  #  LET l_sif.sif08 = l_sfs.sfs27
  #  LET l_sif.sif10 = g_today
  #  LET l_sif.sif11 = g_sfs_sif.sfs01
  #  LET l_sif.sif12 = g_sfs_sif.sfs02
  #  LET l_sif.siflegal = g_legal
  #  LET l_sif.sifplant = g_plant
  #  LET l_sif.sif13 = l_sfs.sfs05      #FUN-A60042 add
  #  #FUN-B20009 ----------------Begin---------------------
  #  LET l_sif.sif012 = l_sfs.sfs012  
  #  LET l_sif.sif013 = l_sfs.sfs013 
  #  IF cl_null(l_sif.sif012) THEN
  #     LET l_sif.sif012 = ' '
  #  END IF
  #  IF cl_null(l_sif.sif013) THEN
  #     LET l_sif.sif013 = 0 
  #  END IF
  #  #FUN-B20009 ----------------End-----------------------
  #
  #  INSERT INTO sif_file VALUES(l_sif.*)
  #  IF STATUS THEN
  #     CALL cl_err3("ins","sif_file",l_sif.sif11,l_sif.sif12,STATUS,"","ins sif",1)  #No.FUN-660128
  #     LET g_success='N' 
  #     RETURN
  #  END IF
  #END FUNCTION  
  #FUN-AC0074--end--mark-------
  #FUN-A20048 --end 
   
  FUNCTION i501sub_VMI_settlement(p_sfp,l_sfs)
   DEFINE p_sfp      RECORD LIKE sfp_file.*
   DEFINE l_sfs      RECORD LIKE sfs_file.*
   DEFINE l_pmc      RECORD LIKE pmc_file.*
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_rvb01    LIKE rvb_file.rvb01    #No.TQC-9C0163
   DEFINE l_rvb02    LIKE rvb_file.rvb02    #No.TQC-9C0163
   #DEFINE l_sma894_3 LIKE type_file.chr1    #MOD-C20155 add #TQC-D30044 mark
   #DEFINE l_sma894_6 LIKE type_file.chr1    #MOD-C20155 add #TQC-D30044 mark
    
   SELECT * INTO l_pmc.* FROM pmc_file
    WHERE pmc917 = l_sfs.sfs07
     AND pmc918 = l_sfs.sfs08
        #MOD-C50220 mark begin------------------
        ##MOD-C50190  add begin-----------------
        #LET l_sma894_3 = g_sma.sma894[3,3]
        #LET l_sma894_6 = g_sma.sma894[6,6]
        #LET g_sma.sma894[3,3] = 'Y'
        #LET g_sma.sma894[6,6] = 'Y'
        ##MOD-C50190  add end-------------------
        #MOD-C50220 mark end--------------------
        CALL i501sub_VMI_insinainb(p_sfp.sfp06,l_sfs.*,l_pmc.*,p_sfp.*)
        IF g_success = 'N' THEN RETURN  END IF
        
       #CALL i501sub_VMI_insrvarvb(p_sfp.sfp06,l_sfs.*,l_pmc.*)  RETURNING l_rvb01,l_rvb02  #FUN-B40053 mark
       #FUN-B40053 add begin--------------------------------- 
        IF p_sfp.sfp06 MATCHES '[1234AC]' THEN
          #CALL i501sub_VMI_insrvarvb(p_sfp.sfp06,l_sfs.*,l_pmc.*)  RETURNING l_rvb01,l_rvb02   #TQC-C70080 mark
           CALL i501sub_VMI_insrvarvb(p_sfp.sfp06,l_sfs.*,l_pmc.*,p_sfp.sfp03)  RETURNING l_rvb01,l_rvb02   #TQC-C70080 add sfp03
        END IF
       #FUN-B40053 add -end----------------------------------
        IF g_success = 'N' THEN RETURN END IF
   
        #TQC-D30044--mark--str--
        #MOD-C20155 str  add-----
        #   LET l_sma894_3 = g_sma.sma894[3,3]
        #   LET l_sma894_6 = g_sma.sma894[6,6]
        #   LET g_sma.sma894[3,3] = 'Y'
        #   LET g_sma.sma894[6,6] = 'Y'
        #MOD-C20155 end add------
        #TQC-D30044--mark--end--

       #CALL i501sub_VMI_insrvurvv(l_rvb01,l_rvb02,p_sfp.sfp06,l_sfs.*,l_pmc.*)  #TQC-C70080 mark
        CALL i501sub_VMI_insrvurvv(l_rvb01,l_rvb02,p_sfp.sfp06,l_sfs.*,l_pmc.*,p_sfp.sfp03) #TQC-C70080 add sfp03
        IF g_success = 'N' THEN RETURN END IF
   
        #MOD-C20155 str  add-----
        #   LET g_sma.sma894[3,3] = l_sma894_3 #TQC-D30044 mark
        #   LET g_sma.sma894[6,6] = l_sma894_6 #TQC-D30044 mark
        #MOD-C20155 end add------

  END FUNCTION
   
  FUNCTION i501sub_VMI_insinainb(p_sfp06,p_sfs,p_pmc,p_sfp)
   DEFINE p_sfp      RECORD LIKE sfp_file.*    #No.FUN-A10001 
   DEFINE p_sfs      RECORD LIKE sfs_file.*
   DEFINE p_pmc      RECORD LIKE pmc_file.*
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE li_result  LIKE type_file.num5
   DEFINE p_sfp06    LIKE sfp_file.sfp06
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_factor   LIKE type_file.num5
   DEFINE l_type     LIKE type_file.num5       #No.FUN-A10001
   DEFINE l_ima906   LIKE ima_file.ima906      #No.FUN-A10001
   DEFINE l_ima25    LIKE ima_file.ima25       #No.FUN-A10001
   DEFINE l_imgg21   LIKE imgg_file.imgg21     #No.FUN-A10001
   DEFINE l_ina10    LIKE ina_file.ina10          #FUN-CB0087 xj
     SELECT COUNT(*) INTO l_cnt FROM ina_file WHERE ina103 = p_sfs.sfs01
     IF l_cnt = 0 THEN
        IF p_sfp06 MATCHES '[1234AC]' THEN
     LET g_ina_vmi.ina00 = '1'
     LET g_ina_vmi.ina01 = p_pmc.pmc922
    #CALL s_auto_assign_no("aim",g_ina_vmi.ina01,g_today,'1',"ina_file","ina01","","","")  #TQC-C70080 mark
     CALL s_auto_assign_no("aim",g_ina_vmi.ina01,p_sfp.sfp03,'1',"ina_file","ina01","","","")   #TQC-C70080 
        RETURNING li_result,g_ina_vmi.ina01
     IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN
     END IF
        ELSE
     LET g_ina_vmi.ina00 = '3'
     LET g_ina_vmi.ina01 = p_pmc.pmc923
    #CALL s_auto_assign_no("aim",g_ina_vmi.ina01,g_today,'2',"ina_file","ina01","","","")   #TQC-C70080 mark
     CALL s_auto_assign_no("aim",g_ina_vmi.ina01,p_sfp.sfp03,'2',"ina_file","ina01","","","")  #TQC-C70080
        RETURNING li_result,g_ina_vmi.ina01
     IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN
     END IF
        END IF
       #LET g_ina_vmi.ina02 = g_today       #TQC-C70080 mark
       #LET g_ina_vmi.ina03 = g_today       #TQC-C70080 mark
        LET g_ina_vmi.ina02 = p_sfp.sfp03   #TQC-C70080 add
        LET g_ina_vmi.ina03 = p_sfp.sfp03   #TQC-C70080 add 
        LET g_ina_vmi.ina04 = g_grup
        LET g_ina_vmi.ina08 = '1'
        LET g_ina_vmi.inaprsw = 0
  #     LET g_ina_vmi.inapost = 'N'    #No.FUN-A10001
        LET g_ina_vmi.inapost = 'Y'    #No.FUN-A10001
        LET g_ina_vmi.inauser = g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_ina_vmi.inagrup = g_grup
        LET g_ina_vmi.inadate = g_today
        LET g_ina_vmi.inamksg = 'N'
  #     LET g_ina_vmi.inaconf  = 'N'   #No.FUN-A10001
        LET g_ina_vmi.inaconf  = 'Y'   #No.FUN-A10001   
        LET g_ina_vmi.ina11 = g_user
        LET g_ina_vmi.inaspc = 0
        LET g_ina_vmi.ina103 = p_sfs.sfs01 
        LET g_ina_vmi.inaplant = g_plant #FUN-980008 add
        LET g_ina_vmi.inalegal = g_legal #FUN-980008 add
        LET g_ina_vmi.ina12   = 'N'      #FUN-870100 ADD 
        LET g_ina_vmi.inapos  = 'N'      #FUN-870100 ADD 
   
        LET g_ina_vmi.inaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_ina_vmi.inaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO ina_file VALUES (g_ina_vmi.*)
        IF STATUS THEN 
     LET g_success = 'N'
     RETURN
        END IF
     END IF
     
     LET g_inb_vmi.inb01 = g_ina_vmi.ina01
   
     SELECT max(inb03)+1 INTO g_inb_vmi.inb03
       FROM inb_file
      WHERE inb01 = g_inb_vmi.inb01
     IF cl_null(g_inb_vmi.inb03) THEN
        LET g_inb_vmi.inb03 = 1
     END IF
     LET g_inb_vmi.inb04 = p_sfs.sfs04
     LET g_inb_vmi.inb05 = p_pmc.pmc915
     LET g_inb_vmi.inb06 = p_pmc.pmc916
     LET g_inb_vmi.inb07 = p_sfs.sfs09
     LET g_inb_vmi.inb08 = p_sfs.sfs06
   
     SELECT img09 INTO l_img09 FROM img_file
      WHERE img01 = p_sfs.sfs04
        AND img02 = p_sfs.sfs07
        AND img03 = p_sfs.sfs08
        AND img04 = p_sfs.sfs09
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs06,l_img09)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET g_inb_vmi.inb08_fac = l_factor
     LET g_inb_vmi.inb09 = p_sfs.sfs05
     LET g_inb_vmi.inb10 = 'N'
     LET g_inb_vmi.inb902 = p_sfs.sfs30
   
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs30,l_img09)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET g_inb_vmi.inb903 = l_factor
     LET g_inb_vmi.inb904 = p_sfs.sfs32
     LET g_inb_vmi.inb905 = p_sfs.sfs33
   
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs33,l_img09)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET g_inb_vmi.inb906 = l_factor
     LET g_inb_vmi.inb907 = p_sfs.sfs35
     LET g_inb_vmi.inb930 = p_sfs.sfs930
     LET g_inb_vmi.inb16 = g_inb_vmi.inb08
     LET g_inb_vmi.inb922 = g_inb_vmi.inb902
     LET g_inb_vmi.inb923 = g_inb_vmi.inb903
     LET g_inb_vmi.inb924 = g_inb_vmi.inb904
     LET g_inb_vmi.inb925 = g_inb_vmi.inb905
     LET g_inb_vmi.inb926 = g_inb_vmi.inb906
     LET g_inb_vmi.inb927 = g_inb_vmi.inb907
     LET g_inb_vmi.inbplant = g_plant #FUN-980008 add
     LET g_inb_vmi.inblegal = g_legal #FUN-980008 add
    #FUN-CB0087-xj---add---str
     IF g_aza.aza115 = 'Y' THEN
        SELECT ina10 INTO l_ina10 FROM ina_file WHERE ina01 = g_inb_vmi.inb01
        CALL s_reason_code(g_inb_vmi.inb01,l_ina10,'',g_inb_vmi.inb04,g_inb_vmi.inb05,g_ina_vmi.ina04,g_ina_vmi.ina11) RETURNING g_inb_vmi.inb15
        IF cl_null(g_inb_vmi.inb15) THEN
           CALL cl_err('','aim-425',1)
           LET g_success = 'N'
           RETURN 
        END IF
     END IF
    #FUN-CB0087-xj---add---end
     INSERT INTO inb_file VALUES(g_inb_vmi.*)
     IF STATUS THEN
        LET g_success = 'N'
        RETURN
     END IF
    ##NO.FUN-A10001   add--begin
     IF g_ina_vmi.ina00='1' THEN
        LET l_type = -1
     ELSE
        LET l_type = 1
     END IF
     CALL s_upimg(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
      l_type,g_inb_vmi.inb09*g_inb_vmi.inb08_fac,g_ina_vmi.ina02,'','','','',
      g_inb_vmi.inb01,g_inb_vmi.inb03,'','','','','','','','','','','','')
     IF g_ina_vmi.ina00 = '1' THEN 
       CALL i501_vmi_tlf(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
             g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'2',              
             g_inb_vmi.inb11,'',g_inb_vmi.inb01,g_inb_vmi.inb03,
            #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04)  #TQC-C70080 mark
             g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,g_ina_vmi.ina02)  #TQC-C70080 add g_ina_vmi.ina02
      END IF 
      IF g_ina_vmi.ina00 = '3'  THEN                  
       CALL i501_vmi_tlf(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
             g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'1',
             g_inb_vmi.inb01,g_inb_vmi.inb03,g_inb_vmi.inb11,'',
            #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04) #TQC-C70080 mark
             g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,g_ina_vmi.ina02) #TQC-C70080 add g_ina_vmi.ina02
      END IF                    
     #多單位處理
     SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file WHERE ima01 =  p_sfs.sfs04
     IF l_ima906 = '2' THEN
        IF NOT cl_null(g_inb_vmi.inb905) THEN
     CALL s_umfchk(g_inb_vmi.inb04,g_inb_vmi.inb905,l_ima25) RETURNING l_cnt,l_imgg21
     CALL s_upimgg(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,
             g_inb_vmi.inb07,g_inb_vmi.inb905,l_type,
             g_inb_vmi.inb907,g_ina_vmi.ina02,g_inb_vmi.inb04,
             g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
             '',g_ina_vmi.ina01,g_inb_vmi.inb03,'',g_inb_vmi.inb905,
             '',l_imgg21,'','','','','','','',g_inb_vmi.inb906)
     IF g_ina_vmi.ina00 = '1' THEN 
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'2',
            g_inb_vmi.inb01,g_inb_vmi.inb03,g_inb_vmi.inb11,'',
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   #TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)   #TQC-C70080 add g_ina_vmi.ina02
     END IF 
     IF g_ina_vmi.ina00 = '3'  THEN                  
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'1',
            g_inb_vmi.inb11,'',g_inb_vmi.inb01,g_inb_vmi.inb03,
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   #TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)   #TQC-C70080 add g_ina_vmi.ina02
     END IF 
        END IF
        IF NOT cl_null(g_inb_vmi.inb902) THEN
     CALL s_umfchk(g_inb_vmi.inb04,g_inb_vmi.inb902,l_ima25) RETURNING l_cnt,l_imgg21
     CALL s_upimgg(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,
             g_inb_vmi.inb07,g_inb_vmi.inb902,l_type,
             g_inb_vmi.inb904,g_ina_vmi.ina02,g_inb_vmi.inb04,
             g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
             '',g_ina_vmi.ina01,g_inb_vmi.inb03,'',g_inb_vmi.inb902,
             '',l_imgg21,'','','','','','','',g_inb_vmi.inb903)
     IF g_ina_vmi.ina00 = '1' THEN 
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'2',
            g_inb_vmi.inb01,g_inb_vmi.inb03,g_inb_vmi.inb11,'',
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   #TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)  #TQC-C70080 add g_ina_vmi.ina02
     END IF 
     IF g_ina_vmi.ina00 = '3'  THEN                  
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'1',
            g_inb_vmi.inb11,'',g_inb_vmi.inb01,g_inb_vmi.inb03,
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   #TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)   #TQC-C70080 add g_ina_vmi.ina02
     END IF 
        END IF
     END IF
     IF l_ima906 = '3' THEN
        IF NOT cl_null(g_inb_vmi.inb905) THEN
     CALL s_umfchk(g_inb_vmi.inb04,g_inb_vmi.inb905,l_ima25) RETURNING l_cnt,l_imgg21
     CALL s_upimgg(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,
             g_inb_vmi.inb07,g_inb_vmi.inb905,l_type,g_inb_vmi.inb907,
             g_ina_vmi.ina02,g_inb_vmi.inb04,g_inb_vmi.inb05,
             g_inb_vmi.inb06,g_inb_vmi.inb07,'',g_ina_vmi.ina01,
             g_inb_vmi.inb03,'',g_inb_vmi.inb905,'',l_imgg21,'',
             '','','','','','',g_inb_vmi.inb906)
     IF g_ina_vmi.ina00 = '1' THEN 
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'2',
            g_inb_vmi.inb01,g_inb_vmi.inb03,g_inb_vmi.inb11,'',
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   ##TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)   #TQC-C70080 add g_ina_vmi.ina02
     END IF 
     IF g_ina_vmi.ina00 = '3'  THEN                  
      CALL i501_vmi_tlff(g_inb_vmi.inb04,g_inb_vmi.inb05,g_inb_vmi.inb06,g_inb_vmi.inb07,
            g_inb_vmi.inb09*g_inb_vmi.inb08_fac,'1',
            g_inb_vmi.inb11,'',g_inb_vmi.inb01,g_inb_vmi.inb03,
           #g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'')   #TQC-C70080 mark
            g_inb_vmi.inb08,g_inb_vmi.inb08_fac,g_ina_vmi.ina04,'',g_ina_vmi.ina02)  #TQC-C70080 add g_ina_vmi.ina02
     END IF 
        END IF
     END IF
           
    ##NO.FUN-A10001   add--end
  END FUNCTION

    ##NO.FUN-A10001   add--begin
 #FUNCTION i501_vmi_tlf(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_factor,p_gov) #FUN-740187
  FUNCTION i501_vmi_tlf(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_factor,p_gov,p_sfp03) #TQC-C70080 add p_sfp03
     DEFINE
        p_part  LIKE img_file.img01,   ##料件編號(p_part)
        p_ware  LIKE img_file.img02,   ##倉庫 #MOD-580001
        p_loca  LIKE img_file.img03,   ##儲位 #MOD-580001
        p_lot   LIKE img_file.img04,   ##批號 #MOD-580001
        p_qty   LIKE img_file.img10,   #No.FUN-680121 DECIMAL (11,3),            ##數量
        p_sta   LIKE type_file.chr1,   ##1.雜收2.雜發3.收貨4.入庫5.倉退
        p_no    LIKE inb_file.inb01,   ##单据编号
        p_no1   LIKE inb_file.inb03,   ##单据项次
        p_no2   LIKE inb_file.inb11,   ##单据编号(参考号码) 
        p_no3   LIKE inb_file.inb03,   ##单据项次
        p_factor LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),       ##轉換率
        p_unit  LIKE ima_file.ima25,   ##單位
        p_gov   LIKE ina_file.ina04,   ##部門 
        p_sfp03 LIKE sfp_file.sfp03,   #TQC-C70080 add   
        l_ima25    LIKE ima_file.ima25,
        l_ima86    LIKE ima_file.ima86,
        l_sta      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
        l_cnt      LIKE type_file.num5,    #No.FUN-680121 SMALLINT
        p_argv1    LIKE type_file.chr1,    #FUN-740187
        l_sfp      RECORD LIKE sfp_file.*, #FUN-740187
        l_sfs      RECORD LIKE sfs_file.*  #FUN-740187
   
     INITIALIZE g_tlf.* TO NULL
       LET g_tlf.tlf01=p_part        #異動料件編號
       SELECT ima25,ima86 INTO l_ima25,l_ima86 FROM ima_file WHERE ima01 = p_part
       CASE p_sta
    WHEN '1'  #雜收
       #TQC-B30117--begin--mark
       #LET g_tlf.tlf02=50
       #LET g_tlf.tlf020=g_plant
       #LET g_tlf.tlf021=p_ware 
       #LET g_tlf.tlf022=p_loca
       #LET g_tlf.tlf023=p_lot 
       #LET g_tlf.tlf024=' '
       #LET g_tlf.tlf025=l_ima25
       #LET g_tlf.tlf026=p_no
       #LET g_tlf.tlf027=p_no1
       #LET g_tlf.tlf03=90
       #LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf02=90
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf03=50
       LET g_tlf.tlf030=g_plant
       LET g_tlf.tlf031=p_ware 
       LET g_tlf.tlf032=p_loca 
       LET g_tlf.tlf033=p_lot 
       LET g_tlf.tlf035=p_unit
       LET g_tlf.tlf036=p_no
       LET g_tlf.tlf037=p_no1        
       LET g_tlf.tlf026=p_no2  
       #TQC-B30117--end
    WHEN '2'  #雜發
       #TQC-B30117--begin--mark
       #LET g_tlf.tlf02=90
       #LET g_tlf.tlf020=g_plant
       #LET g_tlf.tlf021=' '
       #LET g_tlf.tlf022=' '
       #LET g_tlf.tlf023=' '
       #LET g_tlf.tlf024=' '
       #LET g_tlf.tlf025=' '
       #LET g_tlf.tlf026=p_no
       #LET g_tlf.tlf03=50
       #LET g_tlf.tlf030=g_plant
       #LET g_tlf.tlf031=p_ware
       #LET g_tlf.tlf032=p_loca 
       #LET g_tlf.tlf033=p_lot 
       #LET g_tlf.tlf034=' ' 
       #LET g_tlf.tlf035=p_unit
       #LET g_tlf.tlf036=p_no2 
       #LET g_tlf.tlf037=p_no3 
       LET g_tlf.tlf02=50          
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=p_ware     
       LET g_tlf.tlf022=p_loca      
       LET g_tlf.tlf023=p_lot      
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=p_unit     
       LET g_tlf.tlf026=p_no2      
       LET g_tlf.tlf027=p_no3      
       LET g_tlf.tlf03=90          
       LET g_tlf.tlf030=g_plant
       LET g_tlf.tlf031=' '        
       LET g_tlf.tlf032=' '        
       LET g_tlf.tlf033=' '        
       LET g_tlf.tlf034=' '
       LET g_tlf.tlf035=' '        
       LET g_tlf.tlf036=p_no       
       LET g_tlf.tlf037=' '          
       #TQC-B30117--end
    WHEN '3'  #收貨
       LET g_tlf.tlf02=11
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=' '
       LET g_tlf.tlf022=' '
       LET g_tlf.tlf023=' '
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=' '
       LET g_tlf.tlf03=20
       LET g_tlf.tlf030=g_plant 
       LET g_tlf.tlf031=p_ware
       LET g_tlf.tlf032=p_loca 
       LET g_tlf.tlf033=p_lot
       LET g_tlf.tlf034='' 
       LET g_tlf.tlf035='' 
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
    WHEN '4'  #入庫
       LET g_tlf.tlf02=20
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=' '
       LET g_tlf.tlf022=' '
       LET g_tlf.tlf023=' '
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=' '
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf027=p_no1
       LET g_tlf.tlf03=50
       LET g_tlf.tlf031=p_ware 
       LET g_tlf.tlf032=p_loca
       LET g_tlf.tlf033=p_lot 
       LET g_tlf.tlf034 = ' '
       LET g_tlf.tlf035 = l_ima25
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
    WHEN '5'  #倉退
       LET g_tlf.tlf02 = 50
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=p_ware 
       LET g_tlf.tlf022=p_loca
       LET g_tlf.tlf023=p_lot 
       LET g_tlf.tlf024 = ' '
       LET g_tlf.tlf025 = l_ima25
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf027=p_no1
       LET g_tlf.tlf03=31
       LET g_tlf.tlf031=' '
       LET g_tlf.tlf032=' '
       LET g_tlf.tlf033=' '
       LET g_tlf.tlf034=' '
       LET g_tlf.tlf035=' '
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
       END CASE
       LET g_tlf.tlf04= ' '
       LET g_tlf.tlf05= ' ' 
      #LET g_tlf.tlf06=g_today  #TQC-C70080 mark
       LET g_tlf.tlf06=p_sfp03  #TQC-C70080
       LET g_tlf.tlf07=g_today
       LET g_tlf.tlf08=TIME
       LET g_tlf.tlf09=g_user
       LET g_tlf.tlf10=p_qty

       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf12=p_factor
    WHEN '2'  #雜發
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf12=p_factor
    WHEN '3'  #收貨
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf12=p_factor
    WHEN '4'  #入庫
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf12=p_factor
    WHEN '5'  #倉退
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf12=p_factor
       END CASE

       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlf.tlf13='aimt302'
    WHEN '2'  #雜發
       LET g_tlf.tlf13='aimt301'
    WHEN '3'  #收貨
       LET g_tlf.tlf13='apmt1101'
    WHEN '4'  #入庫
       LET g_tlf.tlf13='apmt150'
    WHEN '5'  #倉退
      #LET g_tlf.tlf13='apmt150'    #MOD-C50071 mark
       LET g_tlf.tlf13='apmt1072'   #MOD-C50071 add
       END CASE

       LET g_tlf.tlf17=' '

       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlf.tlf19=p_gov  
       LET g_tlf.tlf60=p_factor
    WHEN '2'  #雜發 
       LET g_tlf.tlf19=p_gov
       LET g_tlf.tlf60=p_factor
    WHEN '3'  #收貨
       LET g_tlf.tlf19=p_gov
       LET g_tlf.tlf60=p_factor
    WHEN '4'  #入庫
       LET g_tlf.tlf19=p_gov
       LET g_tlf.tlf60=p_factor
    WHEN '5'  #倉退
      LET g_tlf.tlf19=p_gov
      LET g_tlf.tlf60=p_factor
       END CASE

       LET g_tlf.tlf20=' '
       LET g_tlf.tlf61= l_ima86

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

      #MOD-C60093 str add-----
       IF NOT cl_null(g_tlf.tlf902) THEN
         SELECT imd09 INTO g_tlf.tlf901  
           FROM imd_file
          WHERE imd01=g_tlf.tlf902
            AND imdacti = 'Y'

         IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF
       ELSE
         LET g_tlf.tlf901=' '
       END IF
      #MOD-C60093 end add-----

       LET g_tlf.tlfplant= g_plant
       LET g_tlf.tlflegal= g_legal

       IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
    IF NOT s_tlfidle(g_plant,g_tlf.*) THEN        #更新呆滯日期
       CALL cl_err('upd ima902:','9050',1)
       LET g_success='N'
    END IF
       END IF
       LET g_tlf.tlf012=' '  #FUN-A60028
       LET g_tlf.tlf013=0    #FUN-A60028
#TQC-B40227 --begin--
    SELECT sma53 INTO g_sma.sma53 FROM sma_file
    IF g_sma.sma53 IS NOT NULL AND g_tlf.tlf06 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',1)
        LET g_success = 'N'
     END IF
#TQC-B40227 --end--
       INSERT INTO tlf_file VALUES (g_tlf.*)
         IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tlf_file",'','',SQLCA.sqlcode,"","",1)
         END IF      
  END FUNCTION

# FUNCTION i501_vmi_tlff(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_fac,p_gov,p_tlff219)  #TQC-C70080 mark
  FUNCTION i501_vmi_tlff(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_fac,p_gov,p_tlff219,p_sfp03)   #TQC-C70080 add p_sfp03
     DEFINE
        p_part  LIKE img_file.img01,   ##料件編號(p_part)
        p_ware  LIKE img_file.img02,   ##倉庫 #MOD-580001
        p_loca  LIKE img_file.img03,   ##儲位 #MOD-580001
        p_lot   LIKE img_file.img04,   ##批號 #MOD-580001
        p_qty   LIKE img_file.img10,   #No.FUN-680121 DECIMAL (11,3),            ##數量
        p_sta   LIKE type_file.chr1,   ##1.雜收2.雜發3.收貨4.入庫5.倉退
        p_no    LIKE inb_file.inb01,   ##单据编号
        p_no1   LIKE inb_file.inb03,   ##单据项次
        p_no2   LIKE inb_file.inb11,   ##单据编号(参考号码) 
        p_no3   LIKE inb_file.inb03,   ##单据项次
        p_fac   LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),      ##轉換率
        p_unit  LIKE ima_file.ima25,   ##單位
        p_gov   LIKE ina_file.ina04,   ##部門 
        p_tlff219  LIKE tlff_file.tlff219, ##單位別(1.第二單位   2.第一單位)
        p_sfp03    LIKE sfp_file.sfp03,   #TQC-C70080 add   
        l_ima25    LIKE ima_file.ima25,
        l_imgg10   LIKE imgg_file.imgg10,
        l_sta      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
        l_cnt      LIKE type_file.num5,    #No.FUN-680121 SMALLINT
        p_argv1    LIKE type_file.chr1,    #FUN-740187
        l_sfp      RECORD LIKE sfp_file.*, #FUN-740187
        l_sfs      RECORD LIKE sfs_file.*  #FUN-740187
       LET g_tlff.tlff01=p_part
       SELECT imgg10 INTO l_imgg10 FROM img_file
        WHERE img01 = p_part
    AND img02 = p_ware
    AND img03 = p_loca
    AND img04 = p_lot
       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlff.tlff02=90
       LET g_tlff.tlff026=p_no
       LET g_tlff.tlff03=50
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware 
       LET g_tlff.tlff032=p_loca 
       LET g_tlff.tlff033=p_lot 
       LET g_tlff.tlff035=p_unit
       LET g_tlff.tlff036=p_no2
       LET g_tlff.tlff037=p_no3         
    WHEN '2'  #雜發
       LET g_tlff.tlff02=50
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware
       LET g_tlff.tlff022=p_loca
       LET g_tlff.tlff023=p_lot
       LET g_tlff.tlff024=l_imgg10
       LET g_tlff.tlff025=p_unit
       LET g_tlff.tlff026=p_no
       LET g_tlff.tlff027=p_no1
       LET g_tlff.tlff03=50
       LET g_tlff.tlff036=p_no2
    WHEN '3'  #收貨
       LET g_tlff.tlff02=11
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=''
       LET g_tlff.tlff022=''
       LET g_tlff.tlff023=''
       LET g_tlff.tlff024=''
       LET g_tlff.tlff025=''
       LET g_tlff.tlff026=p_no
       LET g_tlff.tlff027=p_no1
       LET g_tlff.tlff03 =20
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware
       LET g_tlff.tlff032=p_loca
       LET g_tlff.tlff033=p_lot
       LET g_tlff.tlff034=''
       LET g_tlff.tlff035=''
       LET g_tlff.tlff036=p_no2
       LET g_tlff.tlff037=p_no3
    WHEN '4'  #入庫
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff02  = 20
       LET g_tlff.tlff021 = ' '
       LET g_tlff.tlff022 = ' '
       LET g_tlff.tlff023 = ' '
       LET g_tlff.tlff024 = ' '
       LET g_tlff.tlff025 = ' '
       LET g_tlff.tlff026 = p_no
       LET g_tlff.tlff027 = p_no1
       LET g_tlff.tlff03=50 
       LET g_tlff.tlff031=p_ware
       LET g_tlff.tlff032=p_loca
       LET g_tlff.tlff033=p_lot
       LET g_tlff.tlff035=l_ima25
       LET g_tlff.tlff036=p_no2
       LET g_tlff.tlff037=p_no3
    WHEN '5'  #倉退
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff02 = 50
       LET g_tlff.tlff021=p_ware
       LET g_tlff.tlff022=p_loca
       LET g_tlff.tlff023=p_lot
       LET g_tlff.tlff025 = l_ima25
       LET g_tlff.tlff026 = p_no
       LET g_tlff.tlff027 = p_no1
       LET g_tlff.tlff03=31
       LET g_tlff.tlff031=' '
       LET g_tlff.tlff032=' '
       LET g_tlff.tlff033=' '
       LET g_tlff.tlff035=' '
       LET g_tlff.tlff036=p_no2
       LET g_tlff.tlff037=p_no3
       END CASE

       LET g_tlff.tlff04= ' '
       LET g_tlff.tlff05= ' '
      #LET g_tlff.tlff06=g_today  #TQC-C70080 mark
       LET g_tlff.tlff06=p_sfp03  #TQC-C70080 add
       LET g_tlff.tlff07=g_today
       LET g_tlff.tlff08=TIME
       LET g_tlff.tlff09=g_user
       LET g_tlff.tlff10=p_qty
       LET g_tlff.tlff11=p_unit
       LET g_tlff.tlff12=p_fac
       LET g_tlff.tlff219=p_tlff219
       LET g_tlff.tlff220=p_unit

       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlff.tlff13='aimt302'
    WHEN '2'  #雜發
       LET g_tlff.tlff13='aimt301'
    WHEN '3'  #收貨
       LET g_tlff.tlff13='apmt1101'
    WHEN '4'  #入庫
       LET g_tlff.tlff13='apmt150'
    WHEN '5'  #倉退
       LET g_tlff.tlff13='apmt150'
       END CASE

       LET g_tlff.tlff14=' '
       LET g_tlff.tlff17=' '

       CASE p_sta
    WHEN '1'  #雜收
       LET g_tlff.tlff19=p_gov
    WHEN '2'  #雜發
       LET g_tlff.tlff19=p_gov
    WHEN '3'  #收貨
       LET g_tlff.tlff19=p_gov
    WHEN '4'  #入庫
       LET g_tlff.tlff19=p_gov
    WHEN '5'  #倉退
       LET g_tlff.tlff19=p_gov
       END CASE

       LET g_tlff.tlff20=' '
       LET g_tlff.tlff60=1

        CASE
     WHEN g_tlff.tlff02=50 
        LET g_tlff.tlff902=g_tlff.tlff021
        LET g_tlff.tlff903=g_tlff.tlff022
        LET g_tlff.tlff904=g_tlff.tlff023
        LET g_tlff.tlff905=g_tlff.tlff026
        LET g_tlff.tlff906=g_tlff.tlff027
        LET g_tlff.tlff907=-1
     WHEN g_tlff.tlff03=50 
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
        LET g_tlff.tlff906=0
        LET g_tlff.tlff907=0
        END CASE

       LET g_tlff.tlffplant= g_plant
       LET g_tlff.tlfflegal= g_legal
       LET g_tlff.tlff012=' '  #FUN-A60028
       LET g_tlff.tlff013=0    #FUN-A60028

       INSERT INTO tlff_file VALUES (g_tlff.*)

  END FUNCTION      
        

    ##NO.FUN-A10001   add--end      
   
#FUNCTION i501sub_VMI_insrvarvb(p_sfp06,p_sfs,p_pmc)
FUNCTION i501sub_VMI_insrvarvb(p_sfp06,p_sfs,p_pmc,p_sfp03)  #TQC-C70080 add p_sfp03
   DEFINE p_sfs      RECORD LIKE sfs_file.*
   DEFINE p_pmc      RECORD LIKE pmc_file.*
   DEFINE p_sfp03    LIKE sfp_file.sfp03    #TQC-C70080 add
   DEFINE l_rva      RECORD LIKE rva_file.*
   DEFINE l_rvb      RECORD LIKE rvb_file.*
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE li_result  LIKE type_file.num5
   DEFINE p_sfp06    LIKE sfp_file.sfp06
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima44    LIKE ima_file.ima44
   DEFINE l_ima908   LIKE ima_file.ima908
   DEFINE l_factor   LIKE type_file.num5
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_type     LIKE type_file.num5    #No.FUN-A10001
   DEFINE l_pmc01    LIKE pmc_file.pmc01    #No.FUN-A10001
   DEFINE l_pmc01a   LIKE pmc_file.pmc01    #No.FUN-A10001
   DEFINE l_chr      LIKE type_file.chr1    #No.FUN-A10001 
     SELECT rva01 INTO l_rva.rva01 FROM rva_file,rvb_file
      WHERE rva117 = p_sfs.sfs01
        AND rvb01 = rva01
     SELECT pmc01 INTO l_pmc01 FROM pmc_file #No.FUN-A10001  
      WHERE pmc915 = p_sfs.sfs07             #No.FUN-A10001
        AND pmc916 = p_sfs.sfs08             #No.FUN-A10001   
     SELECT rva05 INTO l_pmc01a FROM rva_file 
      WHERE rva01 = g_rva_no    
     IF l_pmc01a <> l_pmc01 AND l_pmc01a IS NOT NULL THEN 
       LET l_chr = 'Y'
     END IF        
      
     IF STATUS = 100 OR l_chr = 'Y' THEN
        LET l_rva.rva01 = p_pmc.pmc919
       #CALL s_auto_assign_no("apm",l_rva.rva01,g_today,"3","rva_file","rva01","","","")  #TQC-C70080 mark
        CALL s_auto_assign_no("apm",l_rva.rva01,p_sfp03,"3","rva_file","rva01","","","")  #TQC-C70080 
          RETURNING li_result,l_rva.rva01
        IF (NOT li_result) THEN
           LET g_success = 'N'
           RETURN NULL,NULL
        END IF
   
        LET l_rva.rva02 = ''
        LET l_rva.rva04 = 'N'
        LET l_rva.rva05 = p_pmc.pmc01
        LET g_rva_no = l_rva.rva05    #No.FUN-A10001
       #LET l_rva.rva06 = g_today  #TQC-C70080 mark
        LET l_rva.rva06 = p_sfp03  #TQC-C70080 add
        LET l_rva.rva10 = 'REG'
        LET l_rva.rvaprsw = 'Y'
  #     LET l_rva.rvaconf = 'N'   #No.FUN-A10001
        LET l_rva.rvaconf = 'Y'   #No.FUN-A10001
        LET l_rva.rvaprno = 0
        LET l_rva.rvaacti = 'Y'
        LET l_rva.rvauser = g_user
        LET l_rva.rvagrup = g_grup
        LET l_rva.rvadate = g_today
        LET l_rva.rva00 = '2'
        LET l_rva.rva117 = p_sfs.sfs01 #No.FUN-A10001
        LET l_rva.rva111 = p_pmc.pmc17
        LET l_rva.rva112 = p_pmc.pmc49
        LET l_rva.rva113 = p_pmc.pmc22
   
        IF g_aza.aza17 = l_rva.rva113 THEN
     LET l_rva.rva114 = 1
        ELSE
    #CALL s_curr3(l_rva.rva113,g_today,g_sma.sma904)       #TQC-C70080 mark 
     CALL s_curr3(l_rva.rva113,l_rva.rva06,g_sma.sma904)   #TQC-C70080
       RETURNING l_rva.rva114
        END IF
        LET l_rva.rva115 = p_pmc.pmc47
   
        SELECT gec04 INTO l_rva.rva116
    FROM gec_file
    WHERE gec01 = l_rva.rva115
      AND gec011 = '1'
        LET l_rva.rva117 = p_sfs.sfs01
        LET l_rva.rva29 = ' '    #NO.FUN-960130
        LET l_rva.rva32 = '0'    #TQC-9C0149
        LET l_rva.rvamksg = 'N'  #TQC-9C0149
       
        LET l_rva.rvaplant = g_plant #FUN-980008 add
        LET l_rva.rvalegal = g_legal #FUN-980008 add
   
        LET l_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
        LET l_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO rva_file VALUES(l_rva.*)
        IF STATUS THEN
     LET g_success = 'N'
     RETURN NULL,NULL
        END IF
     END IF
   
     SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = l_rva.rva01
     LET l_rvb.rvb01 = l_rva.rva01
     
     SELECT max(rvb02)+1 INTO l_rvb.rvb02
       FROM rvb_file
      WHERE rvb01 = l_rvb.rvb01
     IF cl_null(l_rvb.rvb02) THEN
        LET l_rvb.rvb02 = 1
     END IF
  #  LET l_rvb.rvb03 = ''         #No.FUN-A10001
     LET l_rvb.rvb03 = 0          #No.FUN-A10001
     LET l_rvb.rvb04 = ''         
     LET l_rvb.rvb05 = p_sfs.sfs04
     LET l_rvb.rvb06 = 0
     LET l_rvb.rvb07 = p_sfs.sfs05
     LET l_rvb.rvb08 = l_rvb.rvb07
     LET l_rvb.rvb09 = 0
     LET l_rvb.rvb11 = 0
     LET l_rvb.rvb12 = g_today
     LET l_rvb.rvb13 = ''
     LET l_rvb.rvb14 = ''
     LET l_rvb.rvb15 = 0
     LET l_rvb.rvb16 = 0
     LET l_rvb.rvb17 = ''
     LET l_rvb.rvb18 = 10
     LET l_rvb.rvb19 = 1
     LET l_rvb.rvb20 = ''
     LET l_rvb.rvb21 = ''
     LET l_rvb.rvb29 = 0
     LET l_rvb.rvb30 = l_rvb.rvb07  #MOD-A50140 mod 0->l_rvb.rvb07
     LET l_rvb.rvb31 = l_rvb.rvb07
     LET l_rvb.rvb32 = 0
     LET l_rvb.rvb33 = 0
     LET l_rvb.rvb34 = ''
     LET l_rvb.rvb35 = 'N'
     LET l_rvb.rvb36 = p_sfs.sfs07
     LET l_rvb.rvb37 = p_sfs.sfs08
     LET l_rvb.rvb38 = p_sfs.sfs09
     LET l_rvb.rvb39 = 'N'
     LET l_rvb.rvb80 = p_sfs.sfs30
   
     SELECT ima02,ima44,ima908 INTO l_ima02,l_ima44,l_ima908
       FROM ima_file
      WHERE ima01 = p_sfs.sfs04
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs30,l_ima44)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET l_rvb.rvb81 = l_factor
     LET l_rvb.rvb82 = p_sfs.sfs32
     LET l_rvb.rvb83 = p_sfs.sfs33
   
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs33,l_ima44)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET l_rvb.rvb84 = l_factor
     LET l_rvb.rvb85 = p_sfs.sfs35
     LET l_rvb.rvb86 = l_ima908
     LET l_rvb.rvb90 = p_sfs.sfs06 #add by TQC-C50233
     CALL i501sub_VMI_set_rvb87(l_rvb.*) RETURNING l_rvb.rvb87
   
    #FUN-A50072 MARK&ADD-------------------------------------------------------
    #CALL s_defprice(l_rvb.rvb05,l_rva.rva05,l_rva.rva113,g_today,l_rvb.rvb87,'',
    #                l_rva.rva115,l_rva.rva116,'1',l_rvb.rvb86,'',l_rva.rva112,
    #                l_rva.rva111)
    #CALL s_defprice_new(l_rvb.rvb05,l_rva.rva05,l_rva.rva113,g_today,l_rvb.rvb87,'',   #TQC-C70080 mark
     CALL s_defprice_new(l_rvb.rvb05,l_rva.rva05,l_rva.rva113,l_rva.rva06,l_rvb.rvb87,'',   #TQC-C70080
         l_rva.rva115,l_rva.rva116,'1',l_rvb.rvb86,'',l_rva.rva112,
         l_rva.rva111,g_plant)
    #FUN-A50072 END-------------------------------------------------------------
        RETURNING l_rvb.rvb10,l_rvb.rvb10t,
                  l_rvb.rvb42,l_rvb.rvb43   #TQC-AC0257 add
     LET l_rvb.rvb88 = l_rvb.rvb10 * l_rvb.rvb87
     LET l_rvb.rvb88t = l_rvb.rvb10t * l_rvb.rvb87
     LET l_rvb.rvb331 = 0
     LET l_rvb.rvb332 = 0
     LET l_rvb.rvb930 = p_sfs.sfs930
     LET l_rvb.rvb051 = l_ima02
     LET l_rvb.rvb89 = 'N'
     #LET l_rvb.rvb90 = p_sfs.sfs06 #mark by TQC-C50233
   
     SELECT img09 INTO l_img09 FROM img_file
      WHERE img01 = p_sfs.sfs04
        AND img02 = p_sfs.sfs07
        AND img03 = p_sfs.sfs08
        AND img04 = p_sfs.sfs09
     CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs06,l_ima44)
        RETURNING l_cnt,l_factor
     IF l_cnt = 1 THEN LET l_factor = 1 END IF
     LET l_rvb.rvb90_fac = l_factor
     #LET l_rvb.rvb42 = ' '   #NO.FUN-960130
     IF cl_null(l_rvb.rvb42) THEN LET l_rvb.rvb42 = '4' END IF  #TQC-AC0257 add
     LET l_rvb.rvbplant = g_plant #FUN-980008 add
     LET l_rvb.rvblegal = g_legal #FUN-980008 add
     INSERT INTO rvb_file VALUES(l_rvb.*)
     IF STATUS THEN
        LET g_success = 'N'
        RETURN NULL,NULL
     END IF 
     LET g_line = l_rvb.rvb02     #TQC-950158
    #RETURN l_rvb.rvb01,l_rvb.rvb02   #No.TQC-9C0163  #MOD-B30062 mark
    ##NO.FUN-A10001   add--begin
     CALL i501_vmi_tlf(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
           l_rvb.rvb08,'3','','',l_rvb.rvb01,l_rvb.rvb02,
          #l_rvb.rvb90,l_rvb.rvb90_fac,l_rva.rva05)  #TQC-C70080 mark
           l_rvb.rvb90,l_rvb.rvb90_fac,l_rva.rva05,l_rva.rva06)   #TQC-C70080 add l_rva.rva06
           
     CALL i501_vmi_tlff(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
            l_rvb.rvb08,'3',l_rvb.rvb04,l_rvb.rvb03,l_rvb.rvb01,
            l_rvb.rvb02,l_rvb.rvb90,
            l_rvb.rvb90_fac,l_rva.rva05,'',l_rva.rva06)   #TQC-C70080 add l_rva.rva06
    ##NO.FUN-A10001   add--end   
     RETURN l_rvb.rvb01,l_rvb.rvb02   #MOD-B30062 add

  END FUNCTION
   
  FUNCTION i501sub_VMI_set_rvb87(p_rvb)
   DEFINE p_rvb        RECORD LIKE rvb_file.*
   DEFINE l_ima25      LIKE ima_file.ima25      #ima單位
   DEFINE l_ima44      LIKE ima_file.ima44      #ima單位
   DEFINE l_ima906     LIKE ima_file.ima906 
   DEFINE l_fac2       LIKE img_file.img21      #第二轉換率
   DEFINE l_qty2       LIKE img_file.img10      #第二數量
   DEFINE l_fac1       LIKE img_file.img21      #第一轉換率
   DEFINE l_qty1       LIKE img_file.img10      #第一數量
   DEFINE l_tot        LIKE img_file.img10      #計價數量
   DEFINE l_factor     LIKE ima_file.ima31_fac
   DEFINE l_cnt        LIKE type_file.num5
   
     SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
       FROM ima_file WHERE ima01=p_rvb.rvb05
     IF SQLCA.sqlcode = 100 THEN
        IF p_rvb.rvb05 MATCHES 'MISC*' THEN
     SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
       FROM ima_file WHERE ima01='MISC'
        END IF
     END IF
     IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
   
     LET l_fac2=p_rvb.rvb84
     LET l_qty2=p_rvb.rvb85
     IF g_sma.sma115 = 'Y' THEN
        LET l_fac1=p_rvb.rvb81
        LET l_qty1=p_rvb.rvb82
     ELSE
        LET l_fac1=1
        LET l_qty1=p_rvb.rvb07
#TQC-C50247 mark beg-----
#        CALL s_umfchk(p_rvb.rvb05,p_rvb.rvb86,l_ima44)
#     RETURNING l_cnt,l_fac1
#        IF l_cnt = 1 THEN
#     LET l_fac1 = 1
#        END IF
#TQC-C50247 mark end-----
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
        LET l_tot=l_qty1*l_fac1
     END IF
     IF cl_null(l_tot) THEN LET l_tot = 0 END IF
     LET l_factor = 1
#TQC-C50247 add begin
     IF g_sma.sma115 = 'Y' THEN 
        CALL s_umfchk(p_rvb.rvb05,l_ima44,p_rvb.rvb86)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
     ELSE
        CALL s_umfchk(p_rvb.rvb05,p_rvb.rvb90,p_rvb.rvb86)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF   
     END IF  	
     LET l_tot = l_tot * l_factor
#TQC-C50247 add end     
     LET p_rvb.rvb87 = l_tot
     LET p_rvb.rvb87 = s_digqty(p_rvb.rvb87,p_rvb.rvb86)  #FUN-BB0083   add
     RETURN p_rvb.rvb87
  END FUNCTION
   
 #FUNCTION i501sub_VMI_insrvurvv(p_rvb01,p_rvb02,p_sfp06,p_sfs,p_pmc)   #No.TQC-9C0163
  FUNCTION i501sub_VMI_insrvurvv(p_rvb01,p_rvb02,p_sfp06,p_sfs,p_pmc,p_sfp03)   #TQC-C70080 add p_sfp03
   DEFINE p_rvb01      LIKE rvb_file.rvb01               #No.TQC-9C0136
   DEFINE p_rvb02      LIKE rvb_file.rvb02               #No.TQC-9C0136
   DEFINE p_sfs        RECORD LIKE sfs_file.*
   DEFINE p_pmc        RECORD LIKE pmc_file.*
   DEFINE p_sfp03      LIKE sfp_file.sfp03     #TQC-C70080 add 
   DEFINE l_rva        RECORD LIKE rva_file.*
   DEFINE l_rvb        RECORD LIKE rvb_file.*
   DEFINE l_rvu        RECORD LIKE rvu_file.*
   DEFINE l_rvv        RECORD LIKE rvv_file.*
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
   DEFINE p_sfp06      LIKE sfp_file.sfp06
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_type       LIKE type_file.num5     #No.FUN-A10001
   DEFINE l_ima25      LIKE ima_file.ima25     #No.FUN-A10001 
   DEFINE l_ima906     LIKE ima_file.ima906    #No.FUN-A10001  
   DEFINE l_imd10      LIKE imd_file.imd10     #No.FUN-A10001
   DEFINE l_imd11      LIKE imd_file.imd11     #No.FUN-A10001
   DEFINE l_imd12      LIKE imd_file.imd12     #No.FUN-A10001
   DEFINE l_imd13      LIKE imd_file.imd13     #No.FUN-A10001
   DEFINE l_imd14      LIKE imd_file.imd14     #No.FUN-A10001
   DEFINE l_imd15      LIKE imd_file.imd15     #No.FUN-A10001
   DEFINE l_imgg21     LIKE imgg_file.imgg21   #No.FUN-A10001 
   DEFINE l_pmc01      LIKE pmc_file.pmc01     #No.FUN-A10001
   DEFINE l_pmc01a     LIKE pmc_file.pmc01     #No.FUN-A10001
   DEFINE l_chr        LIKE type_file.chr1     #No.FUN-A10001  
   DEFINE l_ima02      LIKE ima_file.ima02     #No.FUN-B40053
   DEFINE l_ima44      LIKE ima_file.ima44     #No.FUN-B40053
   DEFINE l_ima908     LIKE ima_file.ima908    #No.FUN-B40053
   DEFINE l_factor     LIKE type_file.num5     #No.FUN-B40053
     LET g_rva_no = ''
     SELECT rvu01 ,rvu00 INTO l_rvu.rvu01,l_rvu.rvu00 FROM rvu_file,rvv_file
      WHERE rvu117 = p_sfs.sfs01
        AND rvu01 = rvv01
        AND rvv32 = p_sfs.sfs07
        AND rvv33 = p_sfs.sfs08
        AND rvv34 = p_sfs.sfs09
     IF p_sfp06 MATCHES '[1234AC]' THEN   #FUN-B40053 新增是否為退料的判斷
        SELECT rva_file.*,rvb_file.* INTO l_rva.*,l_rvb.*
          FROM rva_file,rvb_file
         WHERE rva01 = rvb01
           AND rvb01 = p_rvb01
           AND rvb02 = p_rvb02
     #FUN-B40053 add begin-----------------------------------------
     ELSE
        #給l_rva賦值
        LET l_rva.rva05  = p_pmc.pmc01
        LET l_rva.rva10  = 'REG'
        LET l_rva.rva111 = p_pmc.pmc17
        LET l_rva.rva112 = p_pmc.pmc49
        LET l_rva.rva113 = p_pmc.pmc22
        IF g_aza.aza17 = l_rva.rva113 THEN
           LET l_rva.rva114 = 1
        ELSE
          #CALL s_curr3(l_rva.rva113,g_today,g_sma.sma904)     #TQC-C70080 mark 
           CALL s_curr3(l_rva.rva113,l_rva.rva06,g_sma.sma904) #TQC-C70080 
              RETURNING l_rva.rva114
        END IF
        LET l_rva.rva115 = p_pmc.pmc47
        SELECT gec04 INTO l_rva.rva116 FROM gec_file WHERE gec01 = l_rva.rva115 AND gec011 = '1'
        
        #給l_rvb賦值
        LET l_rvb.rvb07 = p_sfs.sfs05
        LET l_rvb.rvb05 = p_sfs.sfs04
        LET l_rvb.rvb36 = p_sfs.sfs07
        LET l_rvb.rvb37 = p_sfs.sfs08
        LET l_rvb.rvb38 = p_sfs.sfs09
        LET l_rvb.rvb90 = p_sfs.sfs06
        LET l_rvb.rvb04 = ''
        LET l_rvb.rvb03 = 0
        LET l_rvb.rvb82 = p_sfs.sfs32
        LET l_rvb.rvb83 = p_sfs.sfs33
        SELECT ima02,ima44,ima908 INTO l_ima02,l_ima44,l_ima908
          FROM ima_file
         WHERE ima01 = p_sfs.sfs04
        CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs30,l_ima44)
           RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_rvb.rvb81 = l_factor
        LET l_rvb.rvb051= l_ima02
        LET l_rvb.rvb80 = p_sfs.sfs30
        LET l_rvb.rvb85 = p_sfs.sfs35
        LET l_rvb.rvb86 = l_ima908
        LET l_rvb.rvb89 = 'N'

        CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs33,l_ima44)
           RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_rvb.rvb84 = l_factor

        CALL s_umfchk(p_sfs.sfs04,p_sfs.sfs06,l_ima44)
            RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN LET l_factor = 1 END IF
        LET l_rvb.rvb90_fac = l_factor
        LET l_rvb.rvb930= p_sfs.sfs930

        CALL i501sub_VMI_set_rvb87(l_rvb.*) RETURNING l_rvb.rvb87
        LET l_rvb.rvb88 = l_rvb.rvb10 * l_rvb.rvb87
        LET l_rvb.rvb88t= l_rvb.rvb10t * l_rvb.rvb87
       #CALL s_defprice_new(l_rvb.rvb05,l_rva.rva05,l_rva.rva113,g_today,l_rvb.rvb87,'',   #TQC-C70080 mark
        CALL s_defprice_new(l_rvb.rvb05,l_rva.rva05,l_rva.rva113,l_rva.rva06,l_rvb.rvb87,'', #TQC-C70080
                            l_rva.rva115,l_rva.rva116,'1',l_rvb.rvb86,'',l_rva.rva112,
                            l_rva.rva111,g_plant)
        RETURNING l_rvb.rvb10,l_rvb.rvb10t,l_rvb.rvb42,l_rvb.rvb43
     END IF
     #FUN-B40053 add -end------------------------------------------
     SELECT UNIQUE rvu01 INTO l_rvu.rvu01 FROM rvu_file,rvv_file
      WHERE rvu117 = p_sfs.sfs01
        AND rvu01 = rvv01
     SELECT pmc01 INTO l_pmc01 FROM pmc_file #No.FUN-A10001  
      WHERE pmc915 = p_sfs.sfs07             #No.FUN-A10001
        AND pmc916 = p_sfs.sfs08             #No.FUN-A10001   
     SELECT rvu04 INTO l_pmc01a FROM rvu_file 
      WHERE rvu01 = g_rva_no    
     IF l_pmc01a <> l_pmc01 AND l_pmc01a IS NOT NULL THEN 
       LET l_chr = 'Y'
     END IF        
      
     IF STATUS = 100 OR l_chr = 'Y' THEN      
        IF p_sfp06 MATCHES '[1234AC]' THEN
           LET l_rvu.rvu00 = '1'
           LET l_rvu.rvu01 = p_pmc.pmc920
          #CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'7',"rvu_file","rvu01","","","")  #TQC-C70080 mark
           CALL s_auto_assign_no("apm",l_rvu.rvu01,p_sfp03,'7',"rvu_file","rvu01","","","")  #TQC-C70080
              RETURNING li_result,l_rvu.rvu01
           IF (NOT li_result) THEN
              LET g_success = 'N'
              RETURN
           END IF
        ELSE
           LET l_rvu.rvu00 = '3'
           LET l_rvu.rvu01 = p_pmc.pmc921
          #CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'4',"rvu_file","rvu01","","","")  #TQC-C70080 mark
           CALL s_auto_assign_no("apm",l_rvu.rvu01,p_sfp03,'4',"rvu_file","rvu01","","","")  #TQC-C70080
               RETURNING li_result,l_rvu.rvu01
           IF (NOT li_result) THEN
              LET g_success = 'N'
              RETURN
           END IF
        END IF
        SELECT pmmpos INTO l_rvu.rvupos FROM pmm_file
         WHERE pmm09 = p_pmc.pmc01
        IF cl_null(l_rvu.rvupos) THEN 
           LET l_rvu.rvupos = 'N'
        END IF
        LET l_rvu.rvu02 = l_rva.rva01
       #LET l_rvu.rvu03 = g_today    #TQC-C70080 mark
        LET l_rvu.rvu03 = p_sfp03    #TQC-C70080 add 
        LET l_rvu.rvu04 = l_rva.rva05
        LET g_rva_no = l_rvu.rvu04
        LET l_rvu.rvu05 = p_pmc.pmc03
        LET l_rvu.rvu06 = g_grup
        LET l_rvu.rvu07 = g_user
        LET l_rvu.rvu08 = l_rva.rva10
        LET l_rvu.rvu09 = ''
       #IET l_rvu.rvu10 = 'N'  #MOD-C50071 mark
       #MOD-C50071 str add-----
        IF l_rvu.rvu00 = '3' THEN
          LET l_rvu.rvu10 = 'Y'
        ELSE
          LET l_rvu.rvu10 = 'N'
        END IF
       #MOD-C50071 end add-----
        LET l_rvu.rvu12 = l_rva.rva116
        LET l_rvu.rvu20 = 'N'
  #     LET l_rvu.rvuconf = 'N'
        LET l_rvu.rvuconf = 'Y'          #No.FUN-A10001
        LET l_rvu.rvuacti = 'Y'          #No.FUN-A10001
        LET l_rvu.rvuuser = g_user
        LET l_rvu.rvugrup = g_grup
        LET l_rvu.rvudate = g_today
        LET l_rvu.rvu11 = NULL           #No.TQC-BB0243
        LET l_rvu.rvu111 = l_rva.rva111
        LET l_rvu.rvu112 = l_rva.rva112
        LET l_rvu.rvu113 = l_rva.rva113
        LET l_rvu.rvu114 = l_rva.rva114
        LET l_rvu.rvu115 = l_rva.rva115
        LET l_rvu.rvu116 = '1'
        LET l_rvu.rvu117 = p_sfs.sfs01
        LET l_rvu.rvu21 = ' '
        LET l_rvu.rvu900 = '0'
       #LET l_rvu.rvumksg = ' '          #FUN-AB0001 mark
        LET l_rvu.rvu17  = '1'           #簽核狀況:1.已核准  #FUN-AB0001 add
        LET l_rvu.rvumksg= 'N'           #是否簽核           #FUN-AB0001 add
   
        LET l_rvu.rvuplant = g_plant #FUN-980008 add
        LET l_rvu.rvulegal = g_legal #FUN-980008 add
        LET l_rvu.rvuoriu = g_user      #No.FUN-980030 10/01/04
        LET l_rvu.rvuorig = g_grup      #No.FUN-980030 10/01/04
        LET l_rvu.rvu27   = '1'         #TQC-B60065
        INSERT INTO rvu_file VALUES(l_rvu.*)
        IF STATUS THEN
     LET g_success = 'N'
     RETURN
        END IF
     END IF
     LET l_rvv.rvv01 = l_rvu.rvu01

     SELECT max(rvv02)+1 INTO l_rvv.rvv02
       FROM rvv_file
      WHERE rvv01 = l_rvv.rvv01
     IF cl_null(l_rvv.rvv02) THEN
        LET l_rvv.rvv02 = 1
     END IF
     LET l_rvv.rvv03 = l_rvu.rvu00
     LET l_rvv.rvv04 = l_rvb.rvb01
     LET l_rvv.rvv05 = l_rvb.rvb02
     LET l_rvv.rvv06 = l_rva.rva05
    #LET l_rvv.rvv09 = g_today   #TQC-C70080 mark
     LET l_rvv.rvv09 = p_sfp03   #TQC-C70080 add
     LET l_rvv.rvv17 = l_rvb.rvb07
     LET l_rvv.rvv18 = ''
     LET l_rvv.rvv23 = 0
     LET l_rvv.rvv25 = 'N'
     LET l_rvv.rvv26 = ''       
     LET l_rvv.rvv31 = l_rvb.rvb05
     LET l_rvv.rvv031 = l_rvb.rvb051
     LET l_rvv.rvv32 = l_rvb.rvb36
     LET l_rvv.rvv33 = l_rvb.rvb37
     LET l_rvv.rvv34 = l_rvb.rvb38
     LET l_rvv.rvv35 = l_rvb.rvb90
     LET l_rvv.rvv35_fac = l_rvb.rvb90_fac
     LET l_rvv.rvv36 = l_rvb.rvb04
     LET l_rvv.rvv37 = l_rvb.rvb03
     LET l_rvv.rvv38 = l_rvb.rvb10
     LET l_rvv.rvv38t = l_rvb.rvb10t
     LET l_rvv.rvv40 = 'N'
     LET l_rvv.rvv41 = ''
     LET l_rvv.rvv80 = l_rvb.rvb80
     LET l_rvv.rvv81 = l_rvb.rvb81
     LET l_rvv.rvv82 = l_rvb.rvb82
     LET l_rvv.rvv83 = l_rvb.rvb83
     LET l_rvv.rvv84 = l_rvb.rvb84
     LET l_rvv.rvv85 = l_rvb.rvb85
     LET l_rvv.rvv86 = l_rvb.rvb86
     LET l_rvv.rvv87 = l_rvb.rvb87
     LET l_rvv.rvv39 = l_rvb.rvb88
     LET l_rvv.rvv39t = l_rvb.rvb88t
     LET l_rvv.rvv930 = l_rvb.rvb930
     LET l_rvv.rvv88  = 0
     LET l_rvv.rvv89 = l_rvb.rvb89
     LET l_rvv.rvv10 = ' '         #NO.FUN-960130 
     LET l_rvv.rvvplant = g_plant #FUN-980008 add
     LET l_rvv.rvvlegal = g_legal #FUN-980008 add
     #FUN-CB0087---add---str---
     IF g_aza.aza115 = 'Y' THEN
        CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
        IF cl_null(l_rvv.rvv26) THEN
           CALL cl_err('','aim-425',1)
           LET g_success = 'N'
           RETURN 
        END IF
     END IF
     #FUN-CB0087---add---end---
     INSERT INTO rvv_file VALUES(l_rvv.*)
     IF STATUS THEN
        LET g_success = 'N'
        RETURN
     END IF
    ##NO.FUN-A10001   add--begin
     SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file 
      WHERE ima01 = p_sfs.sfs04 
     SELECT imd10,imd11,imd12,imd13,imd14,imd15 INTO l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15
       FROM imd_file 
      WHERE imd01 = l_rvv.rvv32 
     IF p_sfp06 MATCHES '[1234AC]' THEN
        LET l_rvu.rvu00 = '1'   
     END IF      
     IF l_rvu.rvu00 = '1' THEN 
       SELECT COUNT(*) INTO l_cnt FROM img_file 
        where img01=l_rvv.rvv31
    AND img02=l_rvv.rvv32
    AND img03=l_rvv.rvv33
    AND img04=l_rvv.rvv34
        IF l_cnt = 0  THEN 
         INSERT INTO img_file(img01,img02,img03,img04,img09,img10,img17,
            img18,img20,img21,img22,img23,img24,img25,
            img27,img28,imgplant,imglegal)
           VALUES(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_ima25,0,g_today,g_lastdat,1,1,
            l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15,
            g_plant,g_legal)
        END IF 
        CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,+1,
         l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,l_rvv.rvv31,
         l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv01,
         l_rvv.rvv02,l_rvb.rvb90,l_rvv.rvv17,l_ima25,l_rvv.rvv35_fac,
         1,'','','','','','','')
    IF l_rvu.rvu00 = '1' THEN
      CALL i501_vmi_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
            l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
           #l_rvv.rvv35_fac,l_rvv.rvv06)  #TQC-C70080 mark
            l_rvv.rvv35_fac,l_rvv.rvv06,l_rvv.rvv09)  #TQC-C70080 add l_rvv.rvv09
    END IF 
    IF l_rvu.rvu00 = '3' THEN 
      CALL i501_vmi_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv01,
            l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
           #l_rvv.rvv35_fac,l_rvv.rvv06)  #TQC-C70080 mark
            l_rvv.rvv35_fac,l_rvv.rvv06,l_rvv.rvv09)  #TQC-C70080 add l_rvv.rvv09
    END IF      
      ELSE
      CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,0,
             l_rvv.rvv17*l_rvv.rvv35_fac,l_rvv.rvv09,'','','',
             '',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',
             0,0,'','')
    IF l_rvu.rvu00 = '1' THEN
      CALL i501_vmi_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
            l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
           #l_rvv.rvv35_fac,l_rvv.rvv06)  #TQC-C70080 mark
            l_rvv.rvv35_fac,l_rvv.rvv06,l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
    END IF 
    IF l_rvu.rvu00 = '3' THEN 
      CALL i501_vmi_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
            l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
           #l_rvv.rvv35_fac,l_rvv.rvv06)    #TQC-C70080 mark
            l_rvv.rvv35_fac,l_rvv.rvv06,l_rvv.rvv09)  #TQC-C70080 add l_rvv.rvv09
    END IF 
      END IF     
    #多單位處理
         IF l_rvu.rvu00='1' THEN
      LET l_type = +1
         ELSE
      LET l_type = 0
         END IF
         IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
           l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
           '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')   #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
           l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')   #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv80,l_type,l_rvv.rvv82,l_rvu.rvu02,l_rvv.rvv31,
           l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,'','','','',
           l_rvv.rvv80,'',l_imgg21,'','','','','','','',
           l_rvv.rvv81)
         IF l_rvu.rvu00 = '1' THEN
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')  #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
           l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')  #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
      END IF
         END IF
         IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
           l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
           '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')  #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
           CALL i501_vmi_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
           l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
          #l_rvv.rvv35_fac,l_rvv.rvv06,'')  #TQC-C70080 mark
           l_rvv.rvv35_fac,l_rvv.rvv06,'',l_rvv.rvv09)   #TQC-C70080 add l_rvv.rvv09
         END IF 
      END IF
         END IF

    ##NO.FUN-A10001   add--end   
  END FUNCTION
   
  #FUNCTION i501sub_VMI_conf(p_sfp01)
  # DEFINE p_sfp01      LIKE sfp_file.sfp01
  # DEFINE l_cnt        LIKE type_file.num5
  # DEFINE l_rva        RECORD LIKE rva_file.*
  # DEFINE l_rvu        RECORD LIKE rvu_file.*
  # DEFINE l_cmd        LIKE type_file.chr1000
  # DEFINE l_rvaconf    LIKE rva_file.rvaconf
  # DEFINE l_rvuconf    LIKE rvu_file.rvuconf
  # DEFINE l_rvu01      LIKE rvu_file.rvu01
  # DEFINE l_inaconf    LIKE ina_file.inaconf
  # DEFINE l_inapost    LIKE ina_file.inapost
  # 
  # #####--執行雜收/發單(saimt370)確認及過帳功能 --#####
  #   IF g_ina_vmi.ina00 = '1' THEN
  #      LET l_cmd = "aimt370 '1' '",g_ina_vmi.ina01 CLIPPED,"' 'stock_post' "
  #   ELSE
  #      LET l_cmd = "aimt370 '3' '",g_ina_vmi.ina01 CLIPPED,"' 'stock_post' "
  #   END IF
  #   CALL cl_cmdrun_wait(l_cmd)
  # 
  #   SELECT inaconf,inapost INTO l_inaconf,l_inapost
  #     FROM ina_file
  #    WHERE ina01 = g_ina_vmi.ina01
  #   IF l_inapost <> 'Y' THEN
  #      LET g_success = 'N'
  #   END IF
  # #####------------------------------------------#####
  # 
  # #####--執行收貨單(spmt110)確認功能 ------------#####
  #   IF g_success = 'Y' THEN
  #   DECLARE i501sub_VMI_rva CURSOR FOR 
  #   SELECT * INTO l_rva.* FROM rva_file WHERE rva117=p_sfp01
  #   FOREACH i501sub_VMI_rva INTO l_rva.*
  # 
  #      LET l_cmd = "apmt111 '",l_rva.rva01 CLIPPED,"' '' '1' "
  #      CALL cl_cmdrun_wait(l_cmd)
  #      SELECT rvaconf INTO l_rvaconf
  #        FROM rva_file
  #       WHERE rva01 = l_rva.rva01
  #      IF l_rvaconf <> 'Y' THEN
  #         LET g_success = 'N'
  #         EXIT FOREACH
  #      END IF
  # 
  #   #####--執行入庫/退貨單(spmt720)確認功能 -------#####
  #      LET l_cmd = "apmt720 '",l_rva.rva01 CLIPPED,"' '' '5' "
  #      CALL cl_cmdrun_wait(l_cmd)
  #      SELECT rvuconf INTO l_rvuconf
  #        FROM rvu_file
  #       WHERE rvu02  = l_rva.rva01
  #         AND rvu117 = p_sfp01
  #      IF l_rvuconf <> 'Y' THEN
  #         LET g_success = 'N'
  #         EXIT FOREACH
  #      END IF
  #   #####------------------------------------------#####
  #   END FOREACH
  #   END IF
  # #####------------------------------------------#####
  # 
  #   IF g_success = 'N' THEN
  #      DECLARE i501sub_VMI_rva1 CURSOR FOR
  #       SELECT * INTO l_rva.* FROM rva_file WHERE rva117=p_sfp01
  #      FOREACH i501sub_VMI_rva1 INTO l_rva.*
  #         SELECT rvu01,rvuconf INTO l_rvu01,l_rvuconf
  #           FROM rvu_file
  #          WHERE rvu02  = l_rva.rva01
  #            AND rvu117 = p_sfp01
  #         IF l_rvuconf  = 'Y' THEN
  #            LET l_cmd = "apmt720 '",l_rva.rva01 CLIPPED,"' '' 'Z' "
  #            CALL cl_cmdrun_wait(l_cmd)
  #         END IF
  #         DELETE FROM rvu_file WHERE rvu01 = l_rvu01
  #         DELETE FROM rvv_file WHERE rvv01 = l_rvu01
  # 
  #         SELECT rvaconf INTO l_rvaconf
  #           FROM rva_file
  #          WHERE rva01 = l_rva.rva01
  #         IF l_rvaconf  = 'Y' THEN
  #            LET l_cmd = "apmt111 '",l_rva.rva01 CLIPPED,"' '' 'V' "
  #            CALL cl_cmdrun_wait(l_cmd)
  #         END IF
  #         DELETE FROM rva_file WHERE rva01 = l_rva.rva01
  #         DELETE FROM rvb_file WHERE rvb01 = l_rva.rva01
  #      END FOREACH
  # 
  #      SELECT inaconf,inapost INTO l_inaconf,l_inapost
  #        FROM ina_file
  #       WHERE ina01 = g_ina_vmi.ina01
  #      IF l_inapost = 'Y' OR l_inaconf = 'Y' THEN
  #         LET l_cmd = "aimt370 '",g_ina_vmi.ina00,"' '",g_ina_vmi.ina01 CLIPPED,"' 'vmi_undo' "
  #         CALL cl_cmdrun_wait(l_cmd)
  #      END IF
  #      DELETE FROM ina_file WHERE ina01 = g_ina_vmi.ina01
  #      DELETE FROM inb_file WHERE inb01 = g_ina_vmi.ina01
  #   END IF
  #END FUNCTION
   
 #FUNCTION i501sub_VMI_z(p_sfp01)           #MOD-C20155 mark
  FUNCTION i501sub_VMI_z(p_sfp01,p_argv1)   #MOD-C20155 add
   DEFINE p_sfp01  LIKE sfp_file.sfp01
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_cnt1   LIKE type_file.num5
   DEFINE l_cnt2   LIKE type_file.num5
   DEFINE p_argv1  LIKE type_file.chr1      #MOD-C20155 add
   
     LET g_success = 'Y'
     SELECT COUNT(*) INTO l_cnt
       FROM rvu_file
      WHERE rvu117 = p_sfp01
     SELECT COUNT(*) INTO l_cnt1
       FROM rvw_file,rvu_file
      WHERE rvw08 = rvu01
        AND rvu117 = p_sfp01
     SELECT COUNT(*) INTO l_cnt2
       FROM apb_file,rvu_file
      WHERE apb21 = rvu01
        AND rvu117 = p_sfp01
     IF l_cnt > 0 THEN
        IF l_cnt1 > 0 OR l_cnt2 > 0 THEN
     CALL cl_err('','asf-199',1)
     LET g_success = 'N'
     RETURN
        ELSE
    #CALL i501sub_VMI_z1(p_sfp01)            #MOD-C20155 mark
     CALL i501sub_VMI_z1(p_sfp01,p_argv1)    #MOD-C20155 add
    
     IF g_success = 'N' THEN RETURN END IF
        END IF
     END IF
  END FUNCTION
   
 #FUNCTION i501sub_VMI_z1(p_sfp01)          #MOD-C20155 mark
  FUNCTION i501sub_VMI_z1(p_sfp01,p_argv1)  #MOD-C20155 add
   DEFINE p_sfp01      LIKE sfp_file.sfp01
   DEFINE l_rva        RECORD LIKE rva_file.*
   DEFINE l_rvu        RECORD LIKE rvu_file.*
   DEFINE l_ina        RECORD LIKE ina_file.*
   DEFINE l_rvb        RECORD LIKE rvb_file.*
   DEFINE l_rvv        RECORD LIKE rvv_file.*
   DEFINE l_inb        RECORD LIKE INb_file.* 
   DEFINE l_ina01      LIKE ina_file.ina01
   DEFINE l_rvu01      LIKE rvu_file.rvu01
   DEFINE l_rvuconf    LIKE rvu_file.rvuconf
   DEFINE l_rvaconf    LIKE rva_file.rvaconf
   DEFINE l_inapost    LIKE ina_file.inapost
   DEFINE l_cmd        LIKE type_file.chr1000
   DEFINE l_type       LIKE type_file.num5     #No.FUN-A10001
   DEFINE l_ima25      LIKE ima_file.ima25     #No.FUN-A10001
   DEFINE l_rvb90      LIKE rvb_file.rvb90     #No.FUN-A10001 
   DEFINE l_ima906     LIKE ima_file.ima906    #No.FUN-A10001
   DEFINE l_cnt        LIKE type_file.num5     #No.FUN-A10001
   DEFINE l_imgg21     LIKE imgg_file.imgg21   #No.FUN-A10001 
   #FUN-BC0104-add-str--
   DEFINE l_rvv04  LIKE rvv_file.rvv04,
          l_rvv05  LIKE rvv_file.rvv05,
          l_rvv45  LIKE rvv_file.rvv45,
          l_rvv46  LIKE rvv_file.rvv46,
          l_rvv47  LIKE rvv_file.rvv47,
          l_flagg  LIKE type_file.chr1,
          l_rvv02  LIKE rvv_file.rvv02,
          l_qcl05  LIKE qcl_file.qcl05,
          l_type1  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_rvv_a  DYNAMIC ARRAY OF RECORD
          rvv04    LIKE  rvv_file.rvv04,
          rvv05    LIKE  rvv_file.rvv05,
          rvv45    LIKE  rvv_file.rvv45,
          rvv46    LIKE  rvv_file.rvv46,
          rvv47    LIKE  rvv_file.rvv47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   DEFINE l_inb01  LIKE inb_file.inb01
   DEFINE l_inb03  LIKE inb_file.inb03
   DEFINE l_inb46  LIKE inb_file.inb46
   DEFINE l_inb47  LIKE inb_file.inb47
   DEFINE l_inb48  LIKE inb_file.inb48
   DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
          inb01    LIKE  inb_file.inb01,
          inb03    LIKE  inb_file.inb03,
          inb48    LIKE  inb_file.inb48,
          inb46    LIKE  inb_file.inb46,
          inb47    LIKE  inb_file.inb47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   DEFINE p_argv1      LIKE type_file.chr1     #MOD-C20155 add
   #DEFINE l_sma894_3   LIKE type_file.chr1     #MOD-C20155 add #TQC-D30044 mark
   #DEFINE l_sma894_6   LIKE type_file.chr1     #MOD-C20155 add #TQC-D30044 mark

   #FUN-BC0104-add-end--
    ##NO.FUN-A10001   add--begin 
     DECLARE i501sub_VMI_rva2 CURSOR FOR                                           
     SELECT * INTO l_rva.* FROM rva_file WHERE rva117=p_sfp01                     
     DECLARE i501sub_VMI_rvu2 CURSOR FOR 
     SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu117=p_sfp01
     DECLARE i501sub_VMI_ina2 CURSOR FOR                                           
     SELECT * INTO l_ina.* FROM ina_file WHERE ina103 = p_sfp01
    
  #   FOREACH i501sub_VMI_rva2 INTO l_rva.*
   
  #      LET l_cmd = "apmt720 '",l_rva.rva01 CLIPPED,"' '' 'Z' "
  #      CALL cl_cmdrun_wait(l_cmd)
     #TQC-D30044--mark--str--
     #MOD-C20155 str  add-----
     # IF p_argv1 = '1' THEN
     #    LET l_sma894_3 = g_sma.sma894[3,3]
     #    LET l_sma894_6 = g_sma.sma894[6,6]
     #    LET g_sma.sma894[3,3] = 'Y'
     #    LET g_sma.sma894[6,6] = 'Y'
     # END IF
     #MOD-C20155 end add------
     #TQC-D30044--mark--end--
  #還原入庫/退貨單
     FOREACH i501sub_VMI_rvu2 INTO l_rvu.*
        DECLARE i501sub_VMI_rvv2 CURSOR FOR 
        SELECT * INTO l_rvv.* FROM rvv_file WHERE rvv01=l_rvu.rvu01
        FOREACH i501sub_VMI_rvv2 INTO l_rvv.*
         IF l_rvu.rvu00 = '1' THEN 
            SELECT rvb90 INTO l_rvb90 FROM rvb_file 
             WHERE rvb01 = l_rva.rva01  
           #MOD-CB0217---add---S
            LET l_ima25=''
            SELECT ima25 INTO l_ima25 FROM ima_file
             WHERE ima01 = l_rvv.rvv31
           #MOD-CB0217---add---S
            CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,-1,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,l_rvv.rvv31,
                   l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv01,
                   l_rvv.rvv02,l_rvb90,l_rvv.rvv17,l_ima25,l_rvv.rvv35_fac,
                   1,'','','','','','','')
         ELSE 
            CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,1,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvv.rvv09,'','','',
                   '',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',
                   0,0,'','') 
         END IF                                       
          
         DELETE FROM tlf_file
          WHERE tlf01 =l_rvv.rvv31
            AND ((tlf026=l_rvu.rvu01 AND tlf027=l_rvv.rvv02) OR
                 (tlf036=l_rvu.rvu01 AND tlf037=l_rvv.rvv02)) #異動單號/項次
         SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file 
          WHERE ima01 = l_rvv.rvv31
    #多單位處理
         IF l_rvu.rvu00='1' THEN
      LET l_type = -1
         ELSE
      LET l_type = 1
         END IF                 
         IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN 
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
           l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
           '','','',l_rvv.rvv84)
      END IF                                         
      IF NOT cl_null(l_rvv.rvv80) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv80,l_type,l_rvv.rvv82,l_rvu.rvu02,l_rvv.rvv31,
           l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,'','','','',
           l_rvv.rvv80,'',l_imgg21,'','','','','','','',
           l_rvv.rvv81)
      END IF 
         END IF 
         IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
           l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
           '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
           '','','',l_rvv.rvv84)  
      END IF 
         END IF    
         DELETE FROM tlff_file
    WHERE tlff01 =l_rvv.rvv31
      AND ((tlff026=l_rvu.rvu01 AND tlff027=l_rvv.rvv02) OR
           (tlff036=l_rvu.rvu01 AND tlff037=l_rvv.rvv02)) #異動單號/項次
        END FOREACH                                                                 
        DELETE FROM rvu_file WHERE rvu01 = l_rvu.rvu01
        IF STATUS THEN LET g_success = 'N' RETURN END IF
        #FUN-BC0104-add-str--
        LET l_cn = 1
        DECLARE upd_rvv_qco20 CURSOR FOR
         SELECT rvv02 FROM rvv_file WHERE rvv01=l_rvu.rvu01
        FOREACH upd_rvv_qco20 INTO l_rvv02
           CALL s_iqctype_rvv(l_rvu.rvu01,l_rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg
           LET l_rvv_a[l_cn].rvv04 = l_rvv04
           LET l_rvv_a[l_cn].rvv05 = l_rvv05
           LET l_rvv_a[l_cn].rvv45 = l_rvv45
           LET l_rvv_a[l_cn].rvv46 = l_rvv46
           LET l_rvv_a[l_cn].rvv47 = l_rvv47
           LET l_rvv_a[l_cn].flagg = l_flagg
           LET l_cn = l_cn + 1
        END FOREACH
        #FUN-BC0104-add-end--
        DELETE FROM rvv_file WHERE rvv01 = l_rvu.rvu01
        IF STATUS THEN LET g_success = 'N' RETURN END IF
        #FUN-BC0104-add-str--
        FOR l_c=1 TO l_cn-1
           IF l_rvv_a[l_cn].flagg = 'Y' THEN
              CALL s_qcl05_sel(l_rvv_a[l_c].rvv46) RETURNING l_qcl05
              IF l_qcl05 ='1' THEN LET l_type1='5' ELSE LET l_type1 ='1' END IF
              IF NOT s_iqctype_upd_qco20(l_rvv_a[l_c].rvv04,l_rvv_a[l_c].rvv05,l_rvv_a[l_c].rvv45,l_rvv_a[l_c].rvv47,l_type1) THEN
                 LET g_success ='N'
                 RETURN
              END IF
           END IF
        END FOR
        #FUN-BC0104-add-end--
     END FOREACH      
     #TQC-D30044--mark--str--
     #MOD-C20155 str  add-----
     # IF p_argv1 = '1' THEN
     #    LET g_sma.sma894[3,3] = l_sma894_3
     #    LET g_sma.sma894[6,6] = l_sma894_6
     # END IF
     #MOD-C20155 end add------
     #TQC-D30044--mark--end--

  #還原收貨單
     FOREACH i501sub_VMI_rva2 INTO l_rva.*

  #      LET l_cmd = "apmt111 '",l_rva.rva01 CLIPPED,"' '' 'V' "
  #      CALL cl_cmdrun_wait(l_cmd)
        DECLARE i501sub_VMI_rvb2 CURSOR FOR 
        SELECT * INTO l_rvb.* FROM rvb_file WHERE rvb01=l_rva.rva01
        FOREACH i501sub_VMI_rvb2 INTO l_rvb.* 
     DELETE FROM tlf_file
      WHERE tlf036 = l_rvb.rvb01
        AND tlf037 = l_rvb.rvb02
        AND tlf01  = l_rvb.rvb05
     DELETE FROM tlff_file
      WHERE tlff036 = l_rvb.rvb01
        AND tlff037 = l_rvb.rvb02
        AND tlff01  = l_rvb.rvb05
        END FOREACH 

        DELETE FROM rva_file WHERE rva01 = l_rva.rva01
        IF STATUS THEN LET g_success = 'N' RETURN END IF
        DELETE FROM rvb_file WHERE rvb01 = l_rva.rva01
        #IF STATUS THEN LET g_success = 'N' RETURN END IF  #MOD-C30882 mark
#MOD-C30882 add begin
        IF STATUS THEN 
           LET g_success = 'N' 
           RETURN 
        ELSE 
           IF NOT s_industry('std') THEN
              IF NOT s_del_rvbi(l_rva.rva01,'','') THEN
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF        
##MOD-C30882 add end
        END IF         
     END FOREACH
   
  #  SELECT ina01 INTO l_ina01 FROM ina_file WHERE ina103 = p_sfp01
  #  LET l_cmd = "aimt370 '",g_ina_vmi.ina00,"' '",l_ina01 CLIPPED,"' 'vmi_undo' "        
  #  CALL cl_cmdrun_wait(l_cmd)
  #還原雜收/發單
     FOREACH i501sub_VMI_ina2 INTO l_ina.*
        DECLARE i501sub_VMI_inb2 CURSOR FOR 
        SELECT * INTO l_inb.* FROM inb_file WHERE inb01=l_ina.ina01   
        FOREACH i501sub_VMI_inb2 INTO l_inb.*
     IF l_ina.ina00='1' THEN
        LET l_type = 1
     ELSE
        LET l_type = -1
     END IF
     CALL s_upimg(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
            l_type,l_inb.inb09*l_inb.inb08_fac,l_ina.ina02,'','','','',
            l_inb.inb01,l_inb.inb03,'','','','','','','','','','','','')  
     DELETE FROM tlf_file
      WHERE tlf01 =l_inb.inb04
        AND ((tlf026=l_ina.ina01 AND tlf027=l_inb.inb03) OR
       (tlf036=l_ina.ina01 AND tlf037=l_inb.inb03)) #異動單號/項次
        AND tlf06 =l_ina.ina02
     #多單位處理
     SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file WHERE ima01 =  l_inb.inb04
     IF l_ima906 = '2' THEN
        IF NOT cl_null(l_inb.inb905) THEN
           CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
           CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
             l_inb.inb07,l_inb.inb905,l_type,
             l_inb.inb907,l_ina.ina02,l_inb.inb04,
             l_inb.inb05,l_inb.inb06,l_inb.inb07,
             '',l_ina.ina01,l_inb.inb03,'',l_inb.inb905,
             '',l_imgg21,'','','','','','','',l_inb.inb906)
        END IF
        IF NOT cl_null(l_inb.inb902) THEN
           CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_ima25) RETURNING l_cnt,l_imgg21
           CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
             l_inb.inb07,l_inb.inb902,l_type,
             l_inb.inb904,l_ina.ina02,l_inb.inb04,
             l_inb.inb05,l_inb.inb06,l_inb.inb07,
             '',l_ina.ina01,l_inb.inb03,'',l_inb.inb902,
             '',l_imgg21,'','','','','','','',l_inb.inb903)
        END IF
     END IF
     IF l_ima906 = '3' THEN
        IF NOT cl_null(l_inb.inb905) THEN
           CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
           CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
             l_inb.inb07,l_inb.inb905,l_type,l_inb.inb907,
             l_ina.ina02,l_inb.inb04,l_inb.inb05,
             l_inb.inb06,l_inb.inb07,'',l_ina.ina01,
             l_inb.inb03,'',l_inb.inb905,'',l_imgg21,'',
             '','','','','','',l_inb.inb906) 
        END IF
     END IF   
     DELETE FROM tlff_file
      WHERE tlff01 =l_inb.inb04
        AND ((tlff026=l_ina.ina01 AND tlff027=l_inb.inb03) OR
       (tlff036=l_ina.ina01 AND tlff037=l_inb.inb03)) #異動單號/項次
        AND tlff06 =l_ina.ina02 #異動日期
        END FOREACH             
        DELETE FROM ina_file WHERE ina01 = l_ina.ina01
        IF STATUS THEN LET g_success = 'N' RETURN END IF
        #FUN-BC0104-add-str--
        LET l_cn =1
        LET l_flagg =''
        DECLARE upd_inb_qco20 CURSOR FOR
         SELECT inb03 FROM inb_file WHERE inb01 = l_ina.ina01
        FOREACH upd_inb_qco20 INTO l_inb03
           CALL s_iqctype_inb(l_ina.ina01,l_inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
           LET l_inb_a[l_cn].inb01 = l_inb01
           LET l_inb_a[l_cn].inb03 = l_inb03
           LET l_inb_a[l_cn].inb46 = l_inb46
           LET l_inb_a[l_cn].inb48 = l_inb48
           LET l_inb_a[l_cn].inb47 = l_inb47
           LET l_inb_a[l_cn].flagg = l_flagg
           LET l_cn = l_cn + 1
        END FOREACH
        #FUN-BC0104-add-end--
        DELETE FROM inb_file WHERE inb01 = l_ina.ina01
        IF STATUS THEN LET g_success = 'N' RETURN END IF
        #FUN-BC0104-add-str--
        FOR l_c=1 TO l_cn-1
           IF l_inb_a[l_c].flagg = 'Y' THEN
              CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
              IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
              IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb01,l_inb_a[l_c].inb03,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN 
                 LET g_success="N"
                 RETURN
              END IF
           END IF
        END FOR
        #FUN-BC0104-add-end--
     END FOREACH     
     ##NO.FUN-A10001   add--end   
  END FUNCTION
   
  FUNCTION i501sub_s1(l_sfp)
    DEFINE qty1,qty2  LIKE sfb_file.sfb081   #No.FUN-680121 DEC(15,3)
    DEFINE qty1_1,qty1_2  LIKE sfb_file.sfb081   #MOD-B50119  add 已發按作業編號的套數和已發不按作業編號的套數
    DEFINE qty2_1,qty2_2  LIKE sfb_file.sfb081   #MOD-B50119  add 已退按作業編號的套數和已發不按作業編號的套數
    DEFINE l_minopseq LIKE type_file.chr6    #No.FUN-680121 VARCHAR(6)
    DEFINE l_sfb    RECORD LIKE sfb_file.*
    DEFINE l_sfp    RECORD LIKE sfp_file.* #FUN-740187
    DEFINE l_sfq    RECORD LIKE sfq_file.* #FUN-740187
    DEFINE l_str    STRING
    DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01  #FUN-810038
    DEFINE l_sfbi   RECORD LIKE sfbi_file.*
   
    DEFINE l_sql    string                   
    DEFINE l_n      LIKE type_file.num5      
    DEFINE l_sfq03  LIKE sfq_file.sfq03     
    DEFINE l_sfq04  LIKE sfq_file.sfq04      
    DEFINE l_sfp04  LIKE sfp_file.sfp04 
    DEFINE l_ecm04  LIKE ecm_file.ecm04  #MOD-D30125 
    DEFINE l_ecm012 LIKE ecm_file.ecm012 #MOD-D30125     
    
    IF g_sma.sma129='N' THEN
       #檢查過賬后之已發套數(sfb081)是否大于生產數量(sfb08)的邏輯段
       #移到i501sub_u_sfa的最后檢查
       #因為過賬后之已發套數(sfb081)改由sfa06回推,
       #故必須在取得過賬后的sfa06之后,再做這段檢查
       #當g_sma.sma129='Y'或NULL時(使用套數管理),則維持舊邏輯
       RETURN l_sfp.*
    END IF
    
    DECLARE i501_s1_c CURSOR FOR
        SELECT * FROM sfq_file WHERE sfq01=l_sfp.sfp01
   
    FOREACH i501_s1_c INTO l_sfq.*
        IF STATUS THEN
           CALL cl_err('for sfq:',STATUS,1) LET g_success='N' EXIT FOREACH   
        END IF
        IF cl_null(l_sfq.sfq02) THEN CONTINUE FOREACH END IF
        LET l_str='s1:',l_sfq.sfq02 #FUN-740187
        CALL cl_msg(l_str) #FUN-740187
        #message 'sel sfb'
   
        IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN
           SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=l_sfq.sfq02
           IF STATUS THEN
              CALL cl_err3("sel","sfb_file",l_sfq.sfq02,"",STATUS,"","sel sfb",1)  #No.FUN-660128
              LET g_success='N' EXIT FOREACH 
           END IF
   
           IF l_sfb.sfb04='1' THEN
              CALL cl_err('sfb04=1','asf-381',1) LET g_success='N' EXIT FOREACH
           END IF
   
           IF l_sfb.sfb04='8' THEN
              CALL cl_err('sfb04=8','asf-345',1) LET g_success='N' EXIT FOREACH
           END IF
   
           IF l_sfb.sfb04<'4' THEN LET l_sfb.sfb04='4' END IF
        END IF
   
        IF l_sfq.sfq03 = 0 THEN CONTINUE FOREACH END IF   #MOD-4C0058 add
   
        IF s_industry('icd') THEN
           SELECT * INTO l_sfbi.* FROM sfbi_file WHERE sfbi01=l_sfq.sfq02
           LET l_ecdicd01 = NULL
           SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
            WHERE ecd01 = l_sfbi.sfbiicd09
        END IF
   
        LET qty1 = 0
        LET qty2 = 0
   
        IF s_industry('slk') THEN 
           SELECT COUNT(*) INTO l_n FROM sfp_file,sfq_file
            WHERE sfp06='1'
              AND sfp01=sfq01
              AND sfq02=l_sfq.sfq02
              AND sfp04='Y' 
              AND sfq04  =' ' 
           IF l_n>0 THEN   
              LET l_sql = "SELECT max(sum(sfq03)) from sfp_file ,sfq_file ",
                          " where sfp06 ='1' and sfp01=sfq01 and sfq02 ='",l_sfq.sfq02,"'",
                          "   and sfp04 = 'Y'  and sfq04 = ' ' group by sfq04" 
           ELSE 
              LET l_sql = "SELECT min(sum(sfq03)) from sfp_file ,sfq_file ",  #No.TQC-930166 add
                          " where sfp06 ='1' and sfp01=sfq01 and sfq02 ='",l_sfq.sfq02,"'",
                          "   and sfp04 = 'Y'  group by sfq04"
           END IF 
           DECLARE i501_cs41 CURSOR FROM l_sql   
           FOREACH i501_cs41 INTO qty1
               IF STATUS THEN LET qty1=0 END IF
               EXIT FOREACH
           END FOREACH                       
         
        ELSE 
          #MOD-B50119  mod
          #DECLARE i501_cs4 CURSOR FOR
          # SELECT SUM(sfq03) FROM sfp_file,sfq_file
          #  WHERE sfp06='1'
          #    AND sfp01=sfq01
          #    AND sfq02=l_sfq.sfq02
          #    AND sfp04='Y'
          #  GROUP BY sfq04
          #  ORDER BY 1 DESC
    
          #FOREACH i501_cs4 INTO qty1
          #  IF STATUS THEN LET qty1=0 END IF
          #  EXIT FOREACH
          #END FOREACH
           LET qty1_1 = 0   #TQC-B80160 add
           LET qty1_2 = 0   #TQC-B80160 add
           #作業編號最大已發套數
           DECLARE i501_cs4_1 CURSOR FOR
            SELECT SUM(sfq03) FROM sfp_file,sfq_file
            #WHERE sfp06='1'
             WHERE sfp06 IN ('1','D')  #FUN-C70014 sfp06='1' --> sfp06 IN ('1','D')
               AND sfp01=sfq01
               AND sfq02=l_sfq.sfq02
               AND sfp04='Y'
               AND sfq04 IS NOT NULL
               AND sfq04 != ' '
             GROUP BY sfq04
             ORDER BY 1 DESC

           FOREACH i501_cs4_1 INTO qty1_1
                   IF STATUS THEN LET qty1_1=0 END IF
                   EXIT FOREACH
           END FOREACH

           #未按作業編號已發套數
           DECLARE i501_cs4_2 CURSOR FOR
            SELECT SUM(sfq03) FROM sfp_file,sfq_file
            #WHERE sfp06='1'  
             WHERE sfp06 IN ('1','D')  #FUN-C70014 sfp06='1' --> sfp06 IN ('1','D')
               AND sfp01=sfq01
               AND sfq02=l_sfq.sfq02
               AND sfp04='Y'
               AND (sfq04 IS NULL OR sfq04 = ' ')
             GROUP BY sfq04
             ORDER BY 1 DESC

           FOREACH i501_cs4_2 INTO qty1_2
                   IF STATUS THEN LET qty1_2=0 END IF
                   EXIT FOREACH
           END FOREACH
           IF cl_null(qty1_1) THEN LET qty1_1=0 END IF
           IF cl_null(qty1_2) THEN LET qty1_2=0 END IF
           LET qty1 = qty1_1 + qty1_2
          #MOD-B50119  mod--end
        END IF      #No.FUN-870117 
        IF s_industry('slk') THEN  
           IF l_n>0 THEN   
              LET l_sql = "SELECT max(sum(sfq03)) from sfp_file ,sfq_file ",
                          " where sfp06 ='6' and sfp01=sfq01 and sfq02 ='",l_sfq.sfq02,"'",
                          "   and sfp04 = 'Y'  and sfq04 = ' ' group by sfq04" 
           ELSE 
              LET l_sql = "SELECT min(sum(sfq03)) from sfp_file ,sfq_file ",  #No.TQC-930166 add
                          " where sfp06 ='6' and sfp01=sfq01 and sfq02 ='",l_sfq.sfq02,"'",
                          "   and sfp04 = 'Y'  group by sfq04"
           END IF 
           DECLARE i501_cs51 CURSOR FROM l_sql 
           FOREACH i501_cs51 INTO qty2
               IF STATUS THEN LET qty2=0 END IF
               EXIT FOREACH
           END FOREACH  
        ELSE                          
          #MOD-B50119  mod      
          #DECLARE i501_cs5 CURSOR FOR
          # SELECT SUM(sfq03) FROM sfp_file,sfq_file
          #  WHERE sfp06='6'
          #    AND sfp01=sfq01
          #    AND sfq02=l_sfq.sfq02
          #    AND sfp04='Y'
          #  GROUP BY sfq04
          #  ORDER BY 1 DESC       
          #FOREACH i501_cs5 INTO qty2
          #    IF STATUS THEN LET qty2=0 END IF
          #    EXIT FOREACH
          #END FOREACH
           LET qty2_1 = 0   #TQC-B80160 add
           LET qty2_2 = 0   #TQC-B80160 add
           #作業編號最大已退套數
           DECLARE i501_cs5_1 CURSOR FOR
            SELECT SUM(sfq03) FROM sfp_file,sfq_file
             WHERE sfp06='6'
               AND sfp01=sfq01
               AND sfq02=l_sfq.sfq02
               AND sfp04='Y'
               AND sfq04 IS NOT NULL
               AND sfq04 != ' '
             GROUP BY sfq04
             ORDER BY 1 DESC
           FOREACH i501_cs5_1 INTO qty2_1
               IF STATUS THEN LET qty2_1=0 END IF
               EXIT FOREACH
           END FOREACH

           #未按作業編號已退套數
           DECLARE i501_cs5_2 CURSOR FOR
            SELECT SUM(sfq03) FROM sfp_file,sfq_file
             WHERE sfp06='6'
               AND sfp01=sfq01
               AND sfq02=l_sfq.sfq02
               AND sfp04='Y'
               AND (sfq04 IS NULL OR sfq04 = ' ')
             GROUP BY sfq04
             ORDER BY 1 DESC
           FOREACH i501_cs5_2 INTO qty2_2
               IF STATUS THEN LET qty2_2=0 END IF
               EXIT FOREACH
           END FOREACH
           IF cl_null(qty2_1) THEN LET qty2_1=0 END IF
           IF cl_null(qty2_2) THEN LET qty2_2=0 END IF
           LET qty2 = qty2_1 + qty2_2
          #MOD-B50119  mod--end
        END IF      #No.FUN-870117 
   
        IF qty1 IS NULL THEN LET qty1=0 END IF
        IF qty2 IS NULL THEN LET qty2=0 END IF
        IF s_industry('icd') THEN
     #  成套發料：
     #  1若工單作業群組=3.DS或4.ASS
     #   1.1若預計生產數量(sfbiicd04) <> 0, 則用預計生產數量控卡發料數
     #   1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
     #      則用生產數量控卡發料數
     #  2.其他: 比照標準作法
     IF l_ecdicd01 MATCHES '[34]' THEN
        IF NOT cl_null(l_sfbi.sfbiicd04) AND l_sfbi.sfbiicd04 <> 0 THEN
           IF (qty1-qty2)>l_sfbi.sfbiicd04 THEN    # 發料套數大於生產套數
        CALL cl_err('sum(sfq03)>sfbiicd04','asf-447',1) 
       #LET g_success='N' RETURN          #TQC-940099
        LET g_success='N' RETURN l_sfp.*  #TQC-940099
           END IF
        ELSE
           IF (qty1-qty2)>l_sfb.sfb08 THEN    # 發料套數大於生產套數
        CALL cl_err('sum(sfq03)>sfb08','asf-447',1) 
       #LET g_success='N' RETURN          #TQC-940099
        LET g_success='N' RETURN l_sfp.*  #TQC-940099
           END IF
        END IF
     ELSE
        IF (qty1-qty2)>l_sfb.sfb08 THEN    # 發料套數大於生產套數
           CALL cl_err('sum(sfq03)>sfb08','asf-447',1) 
          #LET g_success='N' RETURN          #TQC-940099
           LET g_success='N' RETURN l_sfp.*  #TQC-940099
        END IF
     END IF
        ELSE
     IF l_sfp.sfp06<>'2' THEN #TQC-670083
        IF (qty1-qty2)>l_sfb.sfb08 THEN # 發料套數大於生產套數
           CALL cl_err('sum(sfq03)>sfb08','asf-447',1) 
           LET g_success='N' 
           RETURN l_sfp.*
        END IF
     END IF
        END IF
        LET l_minopseq = NULL
        LET l_sfb.sfb081 = qty1 - qty2
   
      IF s_industry('slk') THEN 
      SELECT  sfq04,sfq03,sfp04 INTO l_sfq03,l_sfq04,l_sfp04 FROM  sfp_file,sfq_file where sfp01 = sfq01
         AND  sfq02 = l_sfq.sfq02 AND sfp01 = p_sfp01  
        IF l_sfp04='N' THEN             
         IF  cl_null(l_sfq04) THEN
      IF l_sfq03< l_sfb.sfb081 THEN
        LET l_sfb.sfb081 = l_sfb.sfb081 + l_sfq03
      ELSE 
        LET l_sfb.sfb081 = l_sfq03 
      END IF    
         END IF 
        END IF     
       END IF            
     
        IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
     IF l_sfb.sfb25 IS NULL OR l_sfb.sfb25>l_sfp.sfp03 THEN
        LET l_sfb.sfb25=l_sfp.sfp03
     END IF
     IF l_sfb.sfb93 = 'Y' THEN  #TQC-D30053
        #MOD-D30125---begin
        IF cl_null(l_sfq.sfq012) THEN LET l_sfq.sfq012 = ' ' END IF 
        SELECT ecm04,ecm012 INTO l_ecm04,l_ecm012
          FROM ecm_file
         WHERE ecm01 = l_sfq.sfq02
         ORDER BY ecm03
        IF l_sfq.sfq04 = l_ecm04 AND l_ecm012 = l_sfq.sfq012 THEN 
        #MOD-D30125---end
        #message 'upd sfb'
           UPDATE sfb_file SET sfb04=l_sfb.sfb04,
                sfb87='Y',
                sfb88=l_sfp.sfp08,
                sfb25=l_sfb.sfb25,
                sfb081=l_sfb.sfb081
            WHERE sfb01=l_sfq.sfq02
       #MOD-D30125---begin     
        ELSE 
           #MOD-D30246---begin
           IF l_sfq.sfq04 = ' ' AND l_sfq.sfq012 = ' ' THEN
              UPDATE sfb_file SET sfb04=l_sfb.sfb04,
                   sfb87='Y',
                   sfb88=l_sfp.sfp08,
                   sfb25=l_sfb.sfb25,
                   sfb081=l_sfb.sfb081
               WHERE sfb01=l_sfq.sfq02
           ELSE
           #MOD-D30246---end 
              UPDATE sfb_file SET sfb04=l_sfb.sfb04,
                     sfb87='Y',
                     sfb88=l_sfp.sfp08,
                     sfb25=l_sfb.sfb25
               WHERE sfb01=l_sfq.sfq02
           END IF   #MOD-D30246
        END IF 
        #MOD-D30125---end
     #TQC-D30053---begin
     ELSE
        UPDATE sfb_file SET sfb04=l_sfb.sfb04,
               sfb87='Y',
               sfb88=l_sfp.sfp08,
               sfb25=l_sfb.sfb25,
               sfb081=l_sfb.sfb081
         WHERE sfb01=l_sfq.sfq02
     END IF 
     #TQC-D30053---end
     
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("upd","sfb_file",l_sfq.sfq02,"",STATUS,"","upd sfb",1)  #No.FUN-660128
        LET g_success='N' RETURN l_sfp.*
     END IF
        END IF
        #message ''
        IF g_success='N' THEN RETURN l_sfp.* END IF
    END FOREACH
    RETURN l_sfp.*
  END FUNCTION
   
  FUNCTION i501sub_s2(p_argv1,l_sfp)
    DEFINE l_ima108 LIKE ima_file.ima108
    DEFINE l_n      LIKE type_file.num5    #No.FUN-680121 SMALLINT
    DEFINE l_sfp    RECORD LIKE sfp_file.* #FUN-740187
    DEFINE l_sfs    RECORD LIKE sfs_file.* #FUN-740187
    DEFINE l_sfe    RECORD LIKE sfe_file.* #No.MOD-790112 add
    DEFINE l_sfb    RECORD LIKE sfb_file.* #FUN-740187
    DEFINE l_str    STRING #FUN-740187
    DEFINE p_argv1  LIKE type_file.chr1 #FUN-740187
    DEFINE l_flag          LIKE type_file.num5  #TQC-9A0194
    DEFINE l_sfe01  LIKE sfe_file.sfe01
    DEFINE l_sfe07  LIKE sfe_file.sfe07
    DEFINE l_sfe14  LIKE sfe_file.sfe14
    DEFINE l_sfe012 LIKE sfe_file.sfe012   #FUN-A60028 add by vealxu
    DEFINE l_sfe013 LIKE sfe_file.sfe013   #FUN-A60028 add by vealxu
#   DEFINE l_sql  STRING #MOD-C60234   #MOD-D10094 mark

    IF cl_null(g_aimp880) THEN   #CHI-C80013 add 
       CALL s_showmsg_init()   #No.FUN-6C0083 
    END IF                       #CHI-C80013 add
    
    DECLARE i501_s2_c CURSOR FOR
      SELECT * FROM sfs_file,sfb_file
       WHERE sfs01=l_sfp.sfp01 AND sfs03=sfb01
    FOREACH i501_s2_c INTO l_sfs.*, l_sfb.*
        IF STATUS THEN
           CALL cl_err('for sfs:',STATUS,1) LET g_success='N' EXIT FOREACH   
        END IF
        IF cl_null(l_sfs.sfs04) THEN CONTINUE FOREACH END IF
   
        IF l_sfb.sfb04='8' THEN
           CALL cl_err('sfb04=8','asf-345',1) LET g_success='N' EXIT FOREACH
        END IF
   
        IF s_industry('icd') THEN      
           CALL i501sub_ind_icd_s2(l_sfp.*,l_sfs.*,l_sfb.*)
        END IF
   
        #扣帳日期不可小於工單開立日期
        IF l_sfp.sfp03 < l_sfb.sfb81 THEN
           CALL cl_err('check sfp03:','asf-349',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        LET l_str='s2:',l_sfs.sfs02 #FUN-740187
        CALL cl_msg(l_str) #FUN-740187
        SELECT ima108 INTO l_ima108 FROM ima_file
         WHERE ima01=l_sfs.sfs04
        IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
           SELECT COUNT(*) INTO l_n FROM imd_file
            WHERE imd01=l_sfs.sfs07 AND imd10='W'
              AND imdacti = 'Y' #MOD-4B0169
           IF l_n = 0 THEN
              LET g_totsuccess='N'
              LET g_success="Y"
              LET g_showmsg = l_sfs.sfs04,"/",l_sfs.sfs07  #MOD-890107 add
              IF g_bgerr THEN
                 CALL s_errmsg('sfs04,imd01',g_showmsg,'','asf-724',1)
                 CONTINUE FOREACH
              ELSE
                 LET g_success="N"
                 CALL cl_err(g_showmsg,'asf-724',1)
                 EXIT FOREACH
              END IF
           END IF
        END IF
        #message 'update imgg_file'
        IF g_sma.sma115 = 'Y' THEN
           IF l_sfs.sfs32 != 0 OR l_sfs.sfs35 != 0 THEN
              CALL i501sub_update_du('s',p_argv1,l_sfp.*,l_sfs.*,l_sfe.*)    #No.MOD-790112 add l_sfe
              IF g_success='N' THEN
                 LET g_totsuccess='N'
                 LET g_success="Y"
                 CONTINUE FOREACH   #No.FUN-6C0083
              END IF
           END IF
        END IF
        #message 'update img_file'
        #str-----add by guanyao160903
        IF l_sfs.sfs07 <> l_sfs.sfsud02 THEN 
           LET l_sfs.sfs08 = ' '
        END IF 
        #end-----add by guanyao160903
        CALL i501sub_update(l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,
             l_sfs.sfs05,l_sfs.sfs06,1,p_argv1,l_sfp.*,l_sfs.*) #FUN-740187
        IF g_success='N' THEN 
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
        END IF  #No.+052 010404 by plum
        #message '_u_sfa'
        CALL i501sub_u_sfa('s',p_argv1,l_sfp.*,l_sfs.*,l_sfb.*)
        IF g_success='N' THEN RETURN END IF

#MOD-B90008 --begin--
        LET g_sfs10 = NULL
        LET g_sfs10 = l_sfs.sfs10
#MOD-B90008 --end--

        IF l_sfp.sfp06 MATCHES '[6789B]'  AND l_sfb.sfb02 != '11' THEN   #No:MOD-9B0079 modify
          #MOD-C10171--begin--
           SELECT sfa11 INTO g_sfa11 FROM sfa_file
            WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs04
              AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
              AND sfa27=l_sfs.sfs27
              AND sfa012=l_sfs.sfs012 
              AND sfa013=l_sfs.sfs013   
          #MOD-C10171--end--  
        #  CALL i501sub_qty('s',l_sfb.*)               #FUN-C70037  mark       
        #  CALL i501sub_qty('s',l_sfp.sfp03,l_sfb.*)   #FUN-C70037  #FUN-C90077 mark
           CALL i501sub_qty('s',l_sfs.*,l_sfp.sfp03,l_sfp.sfp06,l_sfb.*)       #FUN-C90077
           IF g_success='N' THEN RETURN END IF  
        END IF
    END FOREACH
   
    #若走制程且為首站,則將最小齊套數寫到ecm301:
    #因為最小齊套數必須所有發料單身都跑完再抓s_minp出來的數字才正確,故要跑完上一個迴圈再重跑才正確
    IF l_sfp.sfp06  NOT MATCHES '[49]' THEN  #TQC-AC0077
       DECLARE i501_s3_c CURSOR FOR
         SELECT sfe01,sfe07,sfe14,sfe012,sfe013,sfb_file.* FROM sfe_file, sfb_file    #FUN-A60028 add sfe012,sfe013 by vealxu
          WHERE sfe02=l_sfp.sfp01 AND sfe01=sfb01
            AND sfb93='Y'
       FOREACH i501_s3_c INTO l_sfe01,l_sfe07,l_sfe14, l_sfe012, l_sfe013, l_sfb.*          #FUN-A60028 add l_sfe012,l_sfe013 by vealxu
         #MOD-D10094 mark begin------------------------------
         ##MOD-C60234 add begin--------------------
         #IF cl_null(l_sfe14) AND g_sma.sma541 = 'Y' THEN
         #   LET l_sql = "SELECT DISTINCT A.ecm012 FROM ecm_file A",
         #               " WHERE A.ecm01 = '",l_sfe01,"'",
         #               "   AND 0 = (SELECT COUNT(*) FROM ecm_file B ",
         #               " WHERE B.ecm01 = A.ecm01",
         #               "   AND B.ecm015=A.ecm012)"
         #   DECLARE s_schdat_min_ecm03_c CURSOR FROM l_sql
         #   FOREACH s_schdat_min_ecm03_c INTO l_sfe012
         #      CALL i501sub_upd_ecm301('s',l_sfe01,l_sfe07,l_sfe14,l_sfb.*,l_sfe012,l_sfe013)
         #           RETURNING l_flag
         #      IF NOT l_flag THEN
         #         LET g_success = 'N'
         #      END IF
         #   END FOREACH
         #ELSE
         ##MOD-C60234 add end----------------------
         #MOD-D10094 mark end---------------------------------
             CALL i501sub_upd_ecm301('s',l_sfe01,l_sfe07,l_sfe14,l_sfb.*,l_sfe012,l_sfe013,l_sfp.*)    #FUN-A60028 add l_sfe012,l_sfe013 by vealxu 
             RETURNING l_flag
             IF NOT l_flag THEN
                LET g_success = 'N'
             END IF
         #END IF   #MOD-C60234 add  #MOD-D10094 mark
       END FOREACH
    END IF  #TQC-AC0077

    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    IF cl_null(g_aimp880) THEN   #CHI-C80013 add
       CALL s_showmsg()   #No.FUN-6C0083
    END IF                       #CHI-C80013 add   
   
    
  END FUNCTION
   
  FUNCTION i501sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_argv1,l_sfp,l_sfs)
    DEFINE p_ware  LIKE img_file.img02,   ##倉庫 #MOD-580001
     p_loca  LIKE img_file.img03,   ##儲位 #MOD-580001
     p_lot   LIKE img_file.img04,   ##批號 #MOD-580001
     p_qty   LIKE img_file.img10,   #No.FUN-680121 DECIMAL (11,3),        ##數量
     p_uom   LIKE img_file.img09,   ##img 單位 #MOD-590028
     p_factor LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),   ##轉換率
     u_type   LIKE type_file.num5,      #No.FUN-680121 SMALLINT,    # +1:入庫 -1:出庫
     l_qty    LIKE img_file.img10,      #No.FUN-680121 DECIMAL (11,3),        ##異動後數量
     l_ima01  LIKE ima_file.ima01,
     l_ima25  LIKE ima_file.ima25,      #MOD-590028 ima_file.ima01->ima_file.ima25
  #        l_imaqty LIKE ima_file.ima262,
     l_imaqty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
     l_imafac LIKE img_file.img21,
     l_img RECORD
           img10   LIKE img_file.img10,
           img16   LIKE img_file.img16,
           img23   LIKE img_file.img23,
           img24   LIKE img_file.img24,
           img09   LIKE img_file.img09,
           img21   LIKE img_file.img21
           END RECORD,
     l_cnt  LIKE type_file.num5,    #No.FUN-680121 SMALLINT
     l_date LIKE type_file.dat      #No.FUN-680121 DATE #FUN-550011
    DEFINE p_argv1 LIKE type_file.chr1 #FUN-740187
    DEFINE l_sfp RECORD LIKE sfp_file.* #FUN-740187
    DEFINE l_sfs RECORD LIKE sfs_file.* #FUN-740187
    DEFINE l_img18  LIKE img_file.img18
      IF cl_null(p_ware) THEN LET p_ware=' ' END IF
      #IF cl_null(p_loca) THEN LET p_loca=' ' END IF   #mark by guanyao160804
      #str-----add by guanyao160808
      IF l_sfs.sfsud02 <> l_sfs.sfs07 THEN 
         #LET p_loca=' '  #add by guanyao160804
         SELECT ecd07 INTO p_loca FROM ecd_file WHERE ecd01=l_sfs.sfs10
         IF cl_null(p_loca) THEN LET p_loca=' ' END IF
      ELSE 
         IF cl_null(p_loca) THEN LET p_loca=' ' END IF
      END IF 
      #end-----add by guanyao160808
      IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
      IF cl_null(p_qty)  THEN LET p_qty=0 END IF
   
      IF p_uom IS NULL THEN
         CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
      END IF
   
      LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21,img18 FROM img_file",
             "  WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? AND img18>=to_date('",g_today,"','yy/mm/dd') ", #tianry add img18
             " FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE img_lock CURSOR FROM g_forupd_sql
   
      OPEN img_lock USING l_sfs.sfs04,p_ware,p_loca,p_lot
     
      IF STATUS THEN 
         SELECT  img18 INTO l_img18 FROM img_file WHERE img01=l_sfs.sfs04 AND img02=p_ware AND img03=p_loca AND img04=p_lot
         #CALL cl_err('lock img fail',STATUS,1)    #CHI-BA0003 mark
         #CHI-BA0003 -- begin --
         LET g_msg = 'lock img fail:',l_sfs.sfs02,'/',l_sfs.sfs04,'/',p_ware,'/',p_loca,'/',p_lot,'/',l_img18
 
         CALL cl_err(g_msg,STATUS,1)
          CALL cl_err(l_img18,STATUS,0)
        #CHI-BA0003 -- end --
         CLOSE img_lock
         LET g_success='N' RETURN
      END IF
   
      FETCH img_lock INTO l_img.*,l_img18
      IF STATUS THEN
         SELECT  img18 INTO l_img18 FROM img_file WHERE img01=l_sfs.sfs04 AND img02=p_ware AND img03=p_loca AND img04=p_lot
        # CALL cl_err('lock img fail',STATUS,1)   #CHI-BA0003 mark
        #CHI-BA0003 -- begin --
         LET g_msg = '',l_sfs.sfs02,'/',l_sfs.sfs04,'/',p_ware,'/',p_loca,'/',p_lot,'/',l_img18
         CALL cl_err(g_msg,100,1)
        #CHI-BA0003 -- end --         
         CLOSE img_lock
         LET g_success='N' RETURN
      END IF
   
      IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   
      #  在扣庫存之前，重新抓取單位換算率 ------
      CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_img.img09)
     RETURNING l_cnt,p_factor
   
      IF l_cnt THEN
         CALL cl_err(l_sfs.sfs04,'asf-816',1) LET g_success='N' RETURN
      END IF
   
   
      CASE WHEN p_argv1='1' LET u_type=-1
           LET l_qty= l_img.img10 - p_qty*p_factor #No.MOD-570241
     WHEN p_argv1='2' LET u_type=+1
           LET l_qty= l_img.img10 + p_qty*p_factor #No.MOD-570241
      END CASE
   
      IF u_type=-1 THEN
         LET l_date=l_sfp.sfp03
         IF l_date IS NULL THEN LET l_date=l_sfp.sfp02 END IF
        #FUN-D30024--modify--str--
        #IF NOT s_stkminus(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,
        #l_sfs.sfs05,p_factor,l_date,g_sma.sma894[3,3]) THEN
         IF NOT s_stkminus(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,
         l_sfs.sfs05,p_factor,l_date) THEN
        #FUN-D30024--modify--end--
      LET g_success='N'
      RETURN
         END IF
      END IF

      CALL s_upimg(l_sfs.sfs04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,l_sfp.sfp03, #FUN-8C0084   #No.MOD-940320 add
       '','','','',l_sfs.sfs01,l_sfs.sfs02,   #No.CHI-860032
       '','','','','','','','','','','','')
   
      IF g_success='N' THEN
         CALL cl_err(l_sfs.sfs04,'9050',0) RETURN
      END IF
   
      LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE"  
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE ima_lock CURSOR FROM g_forupd_sql
   
      OPEN ima_lock USING l_sfs.sfs04
      IF STATUS THEN
         CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
      END IF
   
      FETCH ima_lock INTO l_ima25  #,g_ima86 #FUN-740187
      IF STATUS THEN
         CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
      END IF
   
      IF l_sfs.sfs06=l_ima25 THEN
         LET l_imafac = 1
      ELSE
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_ima25)
      RETURNING l_cnt,l_imafac
      END IF
   
      IF cl_null(l_imafac)  THEN
        ### -------料號/發料單位無法轉換 -----####
        CALL cl_err('料號/發料單位無法轉換',STATUS,1)
        LET g_success ='N'
      END IF
   
      LET l_imaqty = p_qty * l_imafac
   
      CALL s_udima(l_sfs.sfs04,l_img.img23,l_img.img24,l_imaqty,
          l_sfp.sfp03,u_type)  RETURNING l_cnt   #MOD-9A0074 modify
   
      IF g_success='N' THEN
         CALL cl_msg("s_udima error:") #FUN-740187
         RETURN
      END IF
   
      #---insert tlf_file
      CALL i501sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,u_type,p_argv1,l_sfp.*,l_sfs.*) #FUN-740187
   
      #---insert sfe_file
      CALL i501sub_sfe(l_sfp.*,l_sfs.*)
   
      #---delete sfs_file
      DELETE FROM sfs_file WHERE sfs01=l_sfp.sfp01 AND sfs02=l_sfs.sfs02
   
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("del","sfs_file",l_sfp.sfp01,l_sfs.sfs02,STATUS,"","del sfs",1)  #No.FUN-660128
   
    LET g_success='N'   
   
      END IF

      #FUN-B70061 --START--
      IF NOT s_industry('std') THEN
         IF NOT s_del_sfsi(l_sfp.sfp01,l_sfs.sfs02,'') THEN
            LET g_success='N'
         END IF
      END IF 
      #FUN-B70061 --END--
   
  END FUNCTION
   
  FUNCTION i501sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
        u_type,p_argv1,l_sfp,l_sfs) #FUN-740187
     DEFINE
        p_ware  LIKE img_file.img02,   ##倉庫 #MOD-580001
        p_loca  LIKE img_file.img03,   ##儲位 #MOD-580001
        p_lot   LIKE img_file.img04,   ##批號 #MOD-580001
        p_qty   LIKE img_file.img10,       #No.FUN-680121 DECIMAL (11,3),            ##數量
        p_uom   LIKE img_file.img09,       ##img 單位 #MOD-580001
        p_factor LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),       ##轉換率
        p_unit  LIKE ima_file.ima25,       ##單位
        p_img10    LIKE img_file.img10,    #異動後數量
        u_type     LIKE type_file.num5,    #No.FUN-680121 SMALLINT,# +1:入庫 -1:出庫
        l_sfb02    LIKE sfb_file.sfb02,
        l_sfb03    LIKE sfb_file.sfb03,
        l_sfb04    LIKE sfb_file.sfb04,
        l_sfb22    LIKE sfb_file.sfb22,
        l_sfb27    LIKE sfb_file.sfb27,
        l_sfb97    LIKE sfb_file.sfb97,    #MOD-910221 add
        l_sta      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
        l_cnt      LIKE type_file.num5,    #No.FUN-680121 SMALLINT
        p_argv1    LIKE type_file.chr1,    #FUN-740187
        l_sfp      RECORD LIKE sfp_file.*, #FUN-740187
        l_sfs      RECORD LIKE sfs_file.*  #FUN-740187
   
     INITIALIZE g_tlf.* TO NULL
     LET g_tlf.tlf01=l_sfs.sfs04         #異動料件編號
     IF p_argv1='1' THEN
        #----來源----
        LET g_tlf.tlf02=50                  #'Stock'
        LET g_tlf.tlf020=g_plant
        LET g_tlf.tlf021=p_ware             #倉庫
        LET g_tlf.tlf022=p_loca             #儲位
        LET g_tlf.tlf023=p_lot              #批號
        LET g_tlf.tlf024=p_img10            #異動後數量
        LET g_tlf.tlf025=p_uom              #庫存單位(ima_file or img_file)
        LET g_tlf.tlf026=l_sfs.sfs01        #雜發/報廢單號
        LET g_tlf.tlf027=l_sfs.sfs02        #雜發/報廢項次
        #---目的----
        LET g_tlf.tlf03=60                  #'WIP'
        LET g_tlf.tlf036=l_sfs.sfs03        #WO no
     END IF
     IF p_argv1='2' THEN
        #----來源----
        LET g_tlf.tlf02=60                  #'WIP'
        LET g_tlf.tlf026=l_sfs.sfs03        #WO no
        #---目的----
        LET g_tlf.tlf03=50                  #'Stock'
        LET g_tlf.tlf030=g_plant
        LET g_tlf.tlf031=p_ware             #倉庫
        LET g_tlf.tlf032=p_loca             #儲位
        LET g_tlf.tlf033=p_lot              #批號
   
        LET g_tlf.tlf034=p_img10            #異動後數量
        LET g_tlf.tlf035=p_uom             #庫存單位(ima_file or img_file)
        LET g_tlf.tlf036=l_sfs.sfs01        #雜收單號
        LET g_tlf.tlf037=l_sfs.sfs02        #雜收項次
     END IF
     LET g_tlf.tlf04= ' '             #工作站
     LET g_tlf.tlf05=l_sfs.sfs10      #作業序號
     LET g_tlf.tlf06=l_sfp.sfp03      #發料日期
     LET g_tlf.tlf07=g_today          #異動資料產生日期
     LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
     LET g_tlf.tlf09=g_user           #產生人
     LET g_tlf.tlf10=p_qty            #異動數量
     LET g_tlf.tlf11=p_uom      #發料單位
     LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
     LET l_sfb97 = ''                 #MOD-910221 add
     SELECT sfb97 INTO l_sfb97 FROM sfb_file WHERE sfb01=b_sfs.sfs03  #MOD-910221 add
     LET g_tlf.tlf64 = l_sfb97        #手冊編號  #MOD-910221
     CASE WHEN l_sfp.sfp06='1' LET g_tlf.tlf13='asfi511'       ##成套發料
    WHEN l_sfp.sfp06='2' LET g_tlf.tlf13='asfi512'       ##超領
    WHEN l_sfp.sfp06='3' LET g_tlf.tlf13='asfi513'       ##補料
    WHEN l_sfp.sfp06='4' LET g_tlf.tlf13='asfi514'       ##領料
    WHEN l_sfp.sfp06='D' LET g_tlf.tlf13='asfi519'       ##Run Card成套發料   #FUN-C70014 add
    WHEN l_sfp.sfp06='6' LET g_tlf.tlf13='asfi526'       ##成套退料
    WHEN l_sfp.sfp06='7' LET g_tlf.tlf13='asfi527'       ##超領退
    WHEN l_sfp.sfp06='8' LET g_tlf.tlf13='asfi528'       ##補料退
    WHEN l_sfp.sfp06='9' LET g_tlf.tlf13='asfi529'       ##領料退
    WHEN l_sfp.sfp06='A' LET g_tlf.tlf13='asri210'       ##ASR發料
    WHEN l_sfp.sfp06='B' LET g_tlf.tlf13='asri220'       ##ASR退料
    WHEN l_sfp.sfp06='C' LET g_tlf.tlf13='asri230'       ##ASR領料
     END CASE
     #LET g_tlf.tlf14=''                       #異動原因  #FUN-CB0087
     LET g_tlf.tlf14=l_sfs.sfs37               #異動原因  #FUN-CB0087
     LET g_tlf.tlf17=l_sfs.sfs21              #Remark
     LET g_tlf.tlf19=l_sfp.sfp07            #Dept code
     IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
        SELECT sfb27 INTO g_tlf.tlf20 FROM sfb_file WHERE sfb01=l_sfs.sfs03
     ELSE
        LET g_tlf.tlf20=' '
     END IF
   
     LET g_tlf.tlf61=p_uom
     LET g_tlf.tlf62=l_sfs.sfs03    #參考單號
     LET g_tlf.tlf930=l_sfs.sfs930  #FUN-670103
     SELECT sfb27,sfb271,sfb50,sfb51 
       INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
       FROM sfb_file
      WHERE sfb01 = l_sfs.sfs03
     IF SQLCA.sqlcode THEN
       LET g_tlf.tlf20 = ' '
       LET g_tlf.tlf41 = ' '
       LET g_tlf.tlf42 = ' '
       LET g_tlf.tlf43 = ' '
     END IF
     LET g_tlf.tlf27 = l_sfs.sfs27  #FUN-9B0149
     LET g_tlf.tlf012= l_sfs.sfs012 #FUN-A60028
     LET g_tlf.tlf013= l_sfs.sfs013 #FUN-A60028
     CALL s_tlf(1,0)
  END FUNCTION
   
  FUNCTION i501sub_sfe(l_sfp,l_sfs)
    DEFINE l_sfe    RECORD LIKE sfe_file.*
    DEFINE l_sfp    RECORD LIKE sfp_file.* #FUN-740187
    DEFINE l_sfs    RECORD LIKE sfs_file.* #FUN-740187
    DEFINE l_sfei   RECORD LIKE sfei_file.* #FUN-B70061
    DEFINE l_sfsi   RECORD LIKE sfsi_file.* #FUN-B70061
    DEFINE l_sql    STRING                  #FUN-B70061
   
    INITIALIZE l_sfe.* TO NULL
    LET l_sfe.sfe01 = l_sfs.sfs03
    LET l_sfe.sfe02 = l_sfs.sfs01
    LET l_sfe.sfe03 = l_sfp.sfp08
    LET l_sfe.sfe04 = l_sfp.sfp03
    LET l_sfe.sfe05 = TIME
    CASE WHEN l_sfp.sfp06='1' LET l_sfe.sfe06 = '1'
         WHEN l_sfp.sfp06='2' LET l_sfe.sfe06 = '3'
         WHEN l_sfp.sfp06='3' LET l_sfe.sfe06 = '1'
         WHEN l_sfp.sfp06='4' LET l_sfe.sfe06 = '2'
         WHEN l_sfp.sfp06='6' LET l_sfe.sfe06 = '4'
         WHEN l_sfp.sfp06='7' LET l_sfe.sfe06 = '4'
         WHEN l_sfp.sfp06='8' LET l_sfe.sfe06 = '4'
         WHEN l_sfp.sfp06='9' LET l_sfe.sfe06 = '4'
         WHEN l_sfp.sfp06='A' LET l_sfe.sfe06 = '1' #FUN-5C0114
         WHEN l_sfp.sfp06='B' LET l_sfe.sfe06 = '4' #FUN-5C0114
         WHEN l_sfp.sfp06='C' LET l_sfe.sfe06 = '2' #FUN-5C0114
         WHEN l_sfp.sfp06='D' LET l_sfe.sfe06 = '1' #FUN-C70014 add
    END CASE
    LET l_sfe.sfe07 = l_sfs.sfs04
    LET l_sfe.sfe08 = l_sfs.sfs07
    LET l_sfe.sfe09 = l_sfs.sfs08
    LET l_sfe.sfe10 = l_sfs.sfs09
    LET l_sfe.sfe11 = l_sfs.sfs21
    LET l_sfe.sfe14 = l_sfs.sfs10
    LET l_sfe.sfe16 = l_sfs.sfs05
    LET l_sfe.sfe17 = l_sfs.sfs06
    LET l_sfe.sfe24 = g_tlf.tlf13
    LET l_sfe.sfe25 = g_user
    LET l_sfe.sfe28 = l_sfs.sfs02
    LET l_sfe.sfe26 = l_sfs.sfs26
    LET l_sfe.sfe30 = l_sfs.sfs30
    LET l_sfe.sfe31 = l_sfs.sfs31
    LET l_sfe.sfe32 = l_sfs.sfs32
    LET l_sfe.sfe33 = l_sfs.sfs33
    LET l_sfe.sfe34 = l_sfs.sfs34
    LET l_sfe.sfe35 = l_sfs.sfs35
    LET l_sfe.sfe36 = l_sfs.sfs36   #FUN-950088 add
    LET l_sfe.sfe930 = l_sfs.sfs930 #FUN-670103
    LET l_sfe.sfe27 = l_sfs.sfs27 #FUN-8C0072
    #FUN-CB0043---begin
    LET l_sfe.sfeud01 = l_sfs.sfsud01
    LET l_sfe.sfeud02 = l_sfs.sfsud02
    LET l_sfe.sfeud03 = l_sfs.sfsud03
    LET l_sfe.sfeud04 = l_sfs.sfsud04
    LET l_sfe.sfeud05 = l_sfs.sfsud05
    LET l_sfe.sfeud06 = l_sfs.sfsud06
    LET l_sfe.sfeud07 = l_sfs.sfsud07
    LET l_sfe.sfeud08 = l_sfs.sfsud08
    LET l_sfe.sfeud09 = l_sfs.sfsud09
    LET l_sfe.sfeud10 = l_sfs.sfsud10
    LET l_sfe.sfeud11 = l_sfs.sfsud11
    LET l_sfe.sfeud12 = l_sfs.sfsud12
    LET l_sfe.sfeud13 = l_sfs.sfsud13
    LET l_sfe.sfeud14 = l_sfs.sfsud14
    LET l_sfe.sfeud15 = l_sfs.sfsud15
    #FUN-CB0043---end
    LET l_sfe.sfeplant = g_plant #FUN-980008 add
    LET l_sfe.sfelegal = g_legal #FUN-980008 add
    LET l_sfe.sfe012   = l_sfs.sfs012   #FUN-A60028
    LET l_sfe.sfe013   = l_sfs.sfs013   #FUN-A60028
    LET l_sfe.sfe014   = l_sfs.sfs014   #FUN-C70014 add
    #LET l_sfe.sfe26    = l_sfs.sfs37   #FUN-CB0087 add #FUN-D50017 mark
    LET l_sfe.sfe37    = l_sfs.sfs37    #FUN-D50017 add
 
    
#FUN-A70125 --begin--
   IF cl_null(l_sfe.sfe012) THEN
     LET l_sfe.sfe012 = ' '
   END IF 
   IF cl_null(l_sfe.sfe013) THEN
     LET l_sfe.sfe013 = 0 
   END IF 
#FUN-A70125 --end--
   IF cl_null(l_sfe.sfe014) THEN LET l_sfe.sfe014=' ' END IF  #FUN-C70014 add
   INSERT INTO sfe_file VALUES(l_sfe.*)
    IF STATUS THEN
       CALL cl_err3("ins","sfe_file",l_sfe.sfe01,"",STATUS,"","ins sfe",1)  #No.FUN-660128
       LET g_success='N'
    #FUN-B70061 --START--
    ELSE 
       IF NOT s_industry('std') THEN
          LET l_sql = "SELECT * FROM sfsi_file",
                      " WHERE sfsi01 = '", l_sfs.sfs01, "'",
                      " AND sfsi02 = '", l_sfs.sfs02, "'"
          DECLARE sfsi_cl CURSOR FROM l_sql
          OPEN sfsi_cl 
          IF SQLCA.sqlcode THEN
             CALL cl_err("OPEN sfsi_cl:", STATUS, 1)
             LET g_success='N'
          ELSE
             INITIALIZE l_sfsi.* TO NULL
             INITIALIZE l_sfei.* TO NULL 
             FETCH sfsi_cl INTO l_sfsi.*
             IF SQLCA.sqlcode THEN
                CALL cl_err('lock sfsi_cl fail',STATUS,1)
                LET g_success='N'
             ELSE 
                LET l_sfei.sfei02  = l_sfsi.sfsi01
                LET l_sfei.sfei28  = l_sfsi.sfsi02
                LET l_sfei.sfeiicd028 = l_sfsi.sfsiicd028
                LET l_sfei.sfeiicd029 = l_sfsi.sfsiicd029
                LET l_sfei.sfeilegal = l_sfsi.sfsilegal
                LET l_sfei.sfeiplant = l_sfsi.sfsiplant
                IF NOT s_ins_sfei(l_sfei.*,l_sfei.sfeiplant) THEN
                   LET g_success='N'
                END IF
             END IF 
          END IF
          CLOSE sfsi_cl
       END IF 
    #FUN-B70061 --END--
    END IF
  END FUNCTION
   
  FUNCTION i501sub_u_sfa(p_code,p_argv1,l_sfp,l_sfs,l_sfb)
    DEFINE p_code         LIKE type_file.chr1    #No.FUN-680121 VARCHAR(01)
    DEFINE l_tlf10  LIKE tlf_file.tlf10
    DEFINE l_tlf13  LIKE tlf_file.tlf13
    DEFINE l_sfb05  LIKE sfb_file.sfb05
    DEFINE l_sfa    RECORD LIKE sfa_file.*
    DEFINE o_sfa    RECORD LIKE sfa_file.*
    DEFINE l_used         LIKE sfa_file.sfa06
    DEFINE sfa06_t,sfa062_t LIKE sfa_file.sfa06  #No.FUN-680121 DEC(15,3)
    DEFINE ss_sfa05       LIKE sfa_file.sfa05 #
    DEFINE ss_sfa06       LIKE sfa_file.sfa06 #MOD-550045
    DEFINE p_argv1  LIKE type_file.chr1  #FUN-740187
    DEFINE l_sfp    RECORD LIKE sfp_file.*  #FUN-740187
    DEFINE l_sfs    RECORD LIKE sfs_file.*  #FUN-740187
    DEFINE l_sfb    RECORD LIKE sfb_file.*  #FUN-740187
    DEFINE l_str    STRING #FUN-740187
    DEFINE l_sfai   RECORD LIKE sfai_file.* #No.FUN-7B0018
    DEFINE l_new_set       LIKE sfq_file.sfq03  
    DEFINE l_sfb081        LIKE sfb_file.sfb081
    DEFINE l_ecm03         LIKE ecm_file.ecm03
    DEFINE l_tlff10 LIKE tlff_file.tlff10   #FUN-950037
    DEFINE l_tlff13 LIKE tlff_file.tlff13   #FUN-950037
    DEFINE l_sfaiicd04_t,l_sfaiicd05_t  LIKE sfai_file.sfaiicd04  #FUN-950037
    DEFINE l_used_icd   LIKE sfa_file.sfa06  #FUN-950037
    DEFINE l_ima25      LIKE ima_file.ima25  #FUN-950037
    DEFINE l_factor     LIKE ima_file.ima31_fac  #FUN-950037
    DEFINE l_cnt        LIKE type_file.num5      #FUN-950037
    DEFINE l_flag       LIKE type_file.num5
    DEFINE l_sfq04      LIKE sfq_file.sfq04  #CHI-9C0031
    DEFINE l_sfa05      LIKE sfa_file.sfa05  #FUN-C30138
    DEFINE l_sfa05_r    LIKE sfa_file.sfa05  #TQC-CA0035
    DEFINE l_ecm04      LIKE ecm_file.ecm04  #MOD-D30125
    DEFINE l_ecm012     LIKE ecm_file.ecm012  #MOD-D30125
    DEFINE l_sql        STRING               #MOD-D50031

    DECLARE i501_tlf_c CURSOR FOR
       SELECT tlf13,SUM(tlf10) FROM tlf_file
        WHERE tlf62 =l_sfs.sfs03 AND tlf01 =l_sfs.sfs04
          AND tlf11 =l_sfs.sfs06 AND tlf05 =l_sfs.sfs10
          AND tlf27 =l_sfs.sfs27   #FUN-9B0149
          AND tlf012=l_sfs.sfs012  #FUN-A60028
          AND tlf013=l_sfs.sfs013  #FUN-A60028
        GROUP BY tlf13
    LET sfa06_t=0 LET sfa062_t=0
    #message 'foreach tlf'
    FOREACH i501_tlf_c INTO l_tlf13,l_tlf10
      IF STATUS THEN
         CALL cl_err('foreach tlf',STATUS,1) LET g_success='N' EXIT FOREACH   
      END IF
      CASE WHEN l_tlf13='asfi511' LET sfa06_t =sfa06_t +l_tlf10
     WHEN l_tlf13='asfi512' LET sfa062_t=sfa062_t+l_tlf10
     WHEN l_tlf13='asfi513' LET sfa06_t =sfa06_t +l_tlf10
     WHEN l_tlf13='asfi514' LET sfa06_t =sfa06_t +l_tlf10
     WHEN l_tlf13='asfi519' LET sfa06_t =sfa06_t +l_tlf10   #FUN-C70014 add
     WHEN l_tlf13='asfi526' LET sfa06_t =sfa06_t -l_tlf10
     WHEN l_tlf13='asfi527' LET sfa062_t=sfa062_t-l_tlf10
     WHEN l_tlf13='asfi528' LET sfa06_t =sfa06_t -l_tlf10
     WHEN l_tlf13='asfi529' LET sfa06_t =sfa06_t -l_tlf10
     OTHERWISE CONTINUE FOREACH
      END CASE
    END FOREACH

#MOD-D50031 add begin----------------------------------
    IF p_argv1 = '2' THEN
       LET l_sql = "SELECT SUM(tlf10) FROM tlf_file",
                   " WHERE tlf62 ='",l_sfs.sfs03,"' AND tlf01 ='",l_sfs.sfs04,"'",
                   "   AND tlf11 ='",l_sfs.sfs06,"' AND tlf05 ='",l_sfs.sfs10,"'",
                   "   AND tlf13 ='asft670'",
                   "   AND tlf012='",l_sfs.sfs012,"'",
                   "   AND tlf013=",l_sfs.sfs013
       PREPARE i501_tlf_cc FROM l_sql
       EXECUTE i501_tlf_cc INTO l_tlf10
       IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF
       LET sfa06_t = sfa06_t - l_tlf10
    END IF
#MOD-D50031 add end------------------------------------
    
    LET l_sfaiicd04_t=0 
    LET l_sfaiicd05_t=0
    IF s_industry('icd') THEN
       IF g_sma.sma115='Y' THEN
    DECLARE i501_tlff_c CURSOR FOR
      SELECT tlff13,SUM(tlff10) FROM tlff_file  #FUN-9B0149
       WHERE tlff62=l_sfs.sfs03 AND tlff01=l_sfs.sfs04
        #AND tlff11=l_sfs.sfs06 AND tlff05=l_sfs.sfs10   #MOD-BB0111 mark
         AND tlff11=l_sfs.sfs33 AND tlff05=l_sfs.sfs10   #MOD-BB0111
         AND tlff27=l_sfs.sfs27   #FUN-9B0149
         AND tlff012=l_sfs.sfs012  #FUN-A60028
         AND tlff013=l_sfs.sfs013  #FUN-A60028
       GROUP BY tlff13
    #message 'foreach tlff'
    FOREACH i501_tlff_c INTO l_tlff13,l_tlff10
      IF STATUS THEN
         CALL cl_err('foreach tlff',STATUS,1) 
         LET g_success='N' 
         EXIT FOREACH   
      END IF
      CASE WHEN l_tlff13='asfi511' LET l_sfaiicd04_t = l_sfaiicd04_t + l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi512' LET l_sfaiicd05_t = l_sfaiicd05_t + l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi513' LET l_sfaiicd04_t = l_sfaiicd04_t + l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi514' LET l_sfaiicd04_t = l_sfaiicd04_t + l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi519' LET l_sfaiicd04_t = l_sfaiicd04_t + l_tlff10    #FUN-C70014 add
           WHEN l_tlff13='asfi526' LET l_sfaiicd04_t = l_sfaiicd04_t - l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi527' LET l_sfaiicd05_t = l_sfaiicd05_t - l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi528' LET l_sfaiicd04_t = l_sfaiicd04_t - l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           WHEN l_tlff13='asfi529' LET l_sfaiicd04_t = l_sfaiicd04_t - l_tlff10   #MOD-BB0111 l_tlf10 -> l_tlff10
           OTHERWISE CONTINUE FOREACH
      END CASE
    END FOREACH
       END IF
    END IF
    
    #message 'sel sfa 3'
    SELECT * INTO l_sfa.* FROM sfa_file
        WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs04
          AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
          AND sfa27=l_sfs.sfs27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 modify
          AND sfa012=l_sfs.sfs012  #FUN-A60028
          AND sfa013=l_sfs.sfs013  #FUN-A60028
  CASE WHEN SQLCA.SQLCODE=0
        #FUN-C30138---begin
        IF p_argv1='1' AND l_sfs.sfs26 MATCHES '[BC]' THEN
           LET l_sfa.sfa05 = l_sfs.sfs05
        END IF  
        IF p_argv1='2' AND l_sfs.sfs26 MATCHES '[BC]' THEN 
           IF p_code = 'z' THEN
              LET l_sfa.sfa05 = l_sfa.sfa06+l_sfs.sfs05
           END IF 
        END IF  
        #TQC-CA0035 add begin------------------------------------------
        #Run Card發料應發數量計算
        IF l_sfp.sfp06 = 'D' THEN
           SELECT shm08*sfa16 INTO l_sfa05_r FROM shm_file,sfa_file
            WHERE shm012 = sfa01 AND shm01 = l_sfs.sfs014
              AND sfa01 = l_sfs.sfs03 AND sfa03 = l_sfs.sfs04 
              AND sfa08 = l_sfs.sfs10
              AND sfa012 = l_sfs.sfs012 AND sfa013 = l_sfs.sfs013
              AND sfa12 = l_sfs.sfs06 AND sfa27 = l_sfs.sfs27
           IF l_sfa05_r < l_sfa.sfa05 THEN
              LET l_sfa.sfa05 = l_sfa05_r
           END IF
        END IF
        #TQC-CA0035 add end--------------------------------------------
        #FUN-C30138---end
        IF NOT s_industry('std') THEN  #FUN-9B0149 add
           #FUN-950037................begin
           SELECT * INTO l_sfai.* FROM sfai_file
         WHERE sfai01=l_sfs.sfs03 AND sfai03=l_sfs.sfs04
           AND sfai12=l_sfs.sfs06 AND sfai08=l_sfs.sfs10
           AND sfai27=l_sfs.sfs27
           AND sfai012=l_sfs.sfs012  #FUN-A60028 
           AND sfai013=l_sfs.sfs013  #FUN-A60028
           
        END IF
        EXIT CASE
      WHEN SQLCA.SQLCODE=100 AND l_sfs.sfs26 MATCHES '[SUBC]'  #TQC-C30044 ADD 'BC'
        CALL i501sub_u_o_sfa(p_argv1,l_sfs.*,l_sfb.*) # 將原sfa項次應發減少,替代碼 1/2 -> 3/4
        IF g_success='N' THEN RETURN END IF
        LET l_sfa.sfa01=l_sfs.sfs03
        SELECT sfb02 INTO l_sfa.sfa02
         FROM sfb_file
        WHERE sfb01=l_sfa.sfa01
        LET l_sfa.sfa03 =l_sfs.sfs04
        LET l_sfa.sfa04 =0
        LET l_sfa.sfa05 =l_sfs.sfs05
        LET l_sfa.sfa06 =0
        LET l_sfa.sfa061=0
        LET l_sfa.sfa062=0
        LET l_sfa.sfa063=0
        LET l_sfa.sfa064=0
        LET l_sfa.sfa065=0
        LET l_sfa.sfa066=0
        LET l_sfa.sfa08 =l_sfs.sfs10
        LET l_sfa.sfa11 ='N'
        LET l_sfa.sfa12 =l_sfs.sfs06
        IF l_sfa.sfa08 IS NULL THEN LET l_sfa.sfa08=' ' END IF
        LET l_sfa.sfa13 =1
        LET l_sfa.sfa16 =0
        LET l_sfa.sfa161=0
        LET l_sfa.sfa25 =0
        LET l_sfa.sfa26 =l_sfs.sfs26
        LET l_sfa.sfa27 =l_sfs.sfs27
        LET l_sfa.sfa28 =l_sfs.sfs28
        LET l_sfa.sfaacti ='Y'
        IF cl_null(l_sfa.sfa100) THEN
           LET l_sfa.sfa100 = 0
        END IF
   
        LET l_sfa.sfaplant = g_plant #FUN-980008 add
        LET l_sfa.sfalegal = g_legal #FUN-980008 add
        LET l_sfa.sfa012   = l_sfs.sfs012   #FUN-A60028
        LET l_sfa.sfa013   = l_sfs.sfs013   #FUN-A60028
#FUN-A70125 --begin--
        IF cl_null(l_sfa.sfa012) THEN
           LET l_sfa.sfa012 = ' ' 
        END IF 
        IF cl_null(l_sfa.sfa013) THEN
           LET l_sfa.sfa013 = 0 
        END IF 
#FUN-A70125 --end--
        INSERT INTO sfa_file VALUES(l_sfa.*)
        IF STATUS THEN
           CALL cl_err3("ins","sfa_file",l_sfa.sfa01,"",STATUS,"","ins sfa",1)  #No.FUN-660128
           LET g_success='N' RETURN 
        ELSE
           IF NOT s_industry('std') THEN
             INITIALIZE l_sfai.* TO NULL
               LET l_sfai.sfai01 = l_sfa.sfa01
               LET l_sfai.sfai03 = l_sfa.sfa03
               LET l_sfai.sfai08 = l_sfa.sfa08
               LET l_sfai.sfai12 = l_sfa.sfa12
               LET l_sfai.sfai27 = l_sfa.sfa27  #FUN-950037
               LET l_sfai.sfai012 = l_sfa.sfa012 #FUN-A60028
               LET l_sfai.sfai013 = l_sfa.sfa013 #FUN-A60028
                  IF NOT s_ins_sfai(l_sfai.*,'') THEN
                     LET g_success = 'N'
                  END IF
           END IF
        #NO.FUN-7B0018 08/02/25 add --end
          #TQC-A10124 add str --
          #新增取/替代料件除了回寫工單單身外,也要重新發送工單單身用料給MES
           IF g_aza.aza90 MATCHES "[Yy]" THEN
             #FUN-C10035 add str -----
              SELECT sfb02 INTO g_sfb02
                FROM sfb_file
               WHERE sfb01 = l_sfs.sfs03
              IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN     #FUN-CC0122 add g_sfb02 = '5'
             #FUN-C10035 add end -----
                #CALL aws_mescli
                #傳入參數: (1)程式代號
                #          (2)功能選項：insert(新增),update(修改),delete(刪除)
                #          (3)Key
                 CASE aws_mescli('asfi301','update',l_sfs.sfs03)
                    WHEN 1  #呼叫 MES 成功
                         MESSAGE 'UPDATE O.K, UPDATE MES O.K'
                         LET g_success = 'Y'
                    WHEN 2  #呼叫 MES 失敗
                         LET g_success = 'N'
                    OTHERWISE  #其他異常
                         LET g_success = 'N'
                 END CASE
              END IF                           #FUN-C10035 add
           END IF
          #TQC-A10124 add end --
        END IF
         #若由 asfp510 串過來，且 sfa 無資料(在來源工單與目的工單的成品料號，不
         #同時會有的情形)，則以下不 check NO:0694
         WHEN SQLCA.SQLCODE=100 AND g_prog='asfp510' #FUN-740187
        RETURN
    OTHERWISE
        CALL cl_err('sel sfa05',STATUS,1) LET g_success='N' RETURN
    END CASE
    
    #FUN-9C0040--begin--add---------------
    IF p_argv1='2' AND l_sfa.sfa11='S' THEN
       LET sfa06_t = sfa06_t * (-1)
       LET sfa062_t = sfa062_t * (-1)
       LET l_sfa.sfa05=l_sfa.sfa05 * (-1)
    END IF
    #FUN-9C0040--end--add------------------

    LET l_used = sfa06_t + sfa062_t
    
    IF s_industry('icd') THEN
       IF g_sma.sma115='Y' THEN
    LET l_used_icd = l_sfaiicd04_t + l_sfaiicd05_t
       END IF
    END IF
    
    ## 此需區別工單本身是要退料的,當工單本身為要退料則應發量會為負
    IF l_sfp.sfp06='8' AND l_sfa.sfa05 <0 THEN
       IF l_used <= l_sfa.sfa05 THEN  #FUN-B50059
          LET sfa06_t=l_sfa.sfa05
          LET sfa062_t=l_used-l_sfa.sfa05
          IF s_industry('icd') THEN
             IF g_sma.sma115='Y' THEN
                LET l_sfaiicd04_t = l_sfai.sfaiicd01
                LET l_sfaiicd05_t = l_used_icd - l_sfai.sfaiicd01
             END IF
          END IF
       ELSE
          LET sfa06_t=l_used
          LET sfa062_t=0
          IF s_industry('icd') THEN
             IF g_sma.sma115='Y' THEN
                LET l_sfaiicd04_t = l_used_icd
                LET l_sfaiicd05_t = 0
             END IF
          END IF
       END IF
    ELSE
       IF cl_null(l_sfa.sfa064) THEN LET l_sfa.sfa064 = 0 END IF       
    END IF
#FUN-B80129--begin--add-----
    IF l_sfp.sfp06 MATCHES '[49]' THEN  
       IF l_used <= l_sfa.sfa05 THEN
          IF p_code = 'z' THEN
             LET sfa06_t = l_used + l_sfa.sfa064
             LET sfa062_t = 0
          ELSE
             LET sfa06_t  = l_used
             LET sfa062_t = 0
          END IF
       ELSE
          LET sfa06_t = l_sfa.sfa05
          LET sfa062_t= l_used - l_sfa.sfa05
       END IF
    END IF
#FUN-B80129--end--add----
   
    IF sfa06_t > l_sfa.sfa05 AND  #FUN-B50059
      ((p_argv1 = '1') OR (p_argv1='2' AND l_sfb.sfb02 NOT MATCHES '[58]')) THEN   #NO:7075 add sfb02 '8'狀態
      LET l_str='LINE No:',l_sfs.sfs02 USING '####' ,' sel sfa05'
      CALL cl_err(l_str,'asf-642',1) LET g_success='N' RETURN
    END IF
    IF sfa06_t < 0 AND   #FUN-B50059
      ((p_argv1 = '1') OR (p_argv1='2' AND l_sfb.sfb02 NOT MATCHES '[58]')) THEN   #NO:7075
      IF l_sfa.sfa05 >= 0 THEN   #MOD-870305 add '='
         LET l_str='LINE No:',l_sfs.sfs02 USING '####' ,' sfa06<0'
         CALL cl_err(l_str,'asf-533',1) LET g_success='N' RETURN
      END IF
    END IF
   
    #FUN-9C0040--begin--add---------------
    IF p_argv1='2' AND l_sfa.sfa11='S' THEN
       LET sfa06_t  = sfa06_t * (-1)
       LET sfa062_t = sfa062_t * (-1)
       LET l_used   = l_used * (-1)
       LET l_sfa.sfa05=l_sfa.sfa05 * (-1)
    END IF
    #FUN-9C0040--end--add------------------
              
   #FUN-B50059 mark (S)
   ##FUN-A60095(S)
   ##累積發料量+盤虧數量超過應發時,則發料量需扣除盤虧量回寫至已發量,即總發料量最大不能超過應發量
   #IF NOT (p_argv1 = '2' AND l_sfa.sfa11 = 'S') THEN  #MOD-B30702
   #   IF sfa06_t > l_sfa.sfa05 THEN 
   #      LET sfa06_t = l_sfa.sfa05
   #   END IF
   ##已退+盤盈數量小於0時,則退料量需扣除盤盈量回寫至已發量,即最小不能低於0
   #   IF sfa06_t < 0 THEN 
   #      LET sfa06_t = 0
   #   END IF
   #END IF              #MOD-B30702
   ##FUN-A60095(E)
   #FUN-B50059 mark (E)

    LET sfa06_t = s_digqty(sfa06_t,l_sfa.sfa12)    #FUN-BB0085
    LET sfa062_t = s_digqty(sfa062_t,l_sfa.sfa12)    #FUN-BB0085
    # 應更新未備料量sfa25
    UPDATE sfa_file SET sfa06 =sfa06_t,
            sfa062=sfa062_t,
            sfa25 = l_sfa.sfa05 - sfa06_t
    WHERE sfa01=l_sfs.sfs03 
      AND sfa03=l_sfs.sfs04
      AND sfa12=l_sfs.sfs06 
      AND sfa08=l_sfs.sfs10
      AND sfa27=l_sfs.sfs27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 modify
      AND sfa012=l_sfs.sfs012   #FUN-A60028 
      AND sfa013=l_sfs.sfs013   #FUN-A60028
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa06/sfa062",1)  #No.FUN-660128
       LET g_success='N' RETURN
    END IF
    #FUN-C30138---begin
    IF l_sfs.sfs26 MATCHES '[BC]' THEN 
       LET l_sfa05 = l_sfs.sfs05/l_sfs.sfs28
       IF p_argv1='1' THEN
          IF p_code='s' THEN
             UPDATE sfa_file SET sfa05 = sfa05 + l_sfa.sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs04
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)
                LET g_success='N' RETURN
             END IF  

             UPDATE sfa_file SET sfa05 = sfa05 - l_sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs27  
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013     

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)
                LET g_success='N' RETURN
             END IF  
          END IF
          IF p_code='z' THEN
             UPDATE sfa_file SET sfa05 = sfa05 - l_sfa.sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs04
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)
                LET g_success='N' RETURN
             END IF  

             UPDATE sfa_file SET sfa05 = sfa05 + l_sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs27  
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013    

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)
                LET g_success='N' RETURN
             END IF  
          END IF 
       END IF 

       IF p_argv1='2' THEN
          IF p_code='s' THEN
             UPDATE sfa_file SET sfa05 = sfa05 - l_sfs.sfs05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs04
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013
             
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1) 
                LET g_success='N' RETURN
             END IF
             
             UPDATE sfa_file SET sfa05 = sfa05 + l_sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs27  
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013     

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)
                LET g_success='N' RETURN
             END IF             
          END IF
          IF p_code='z' THEN
             UPDATE sfa_file SET sfa05 = sfa05 + l_sfs.sfs05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs04
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1)  
                LET g_success='N' RETURN
             END IF
             
             UPDATE sfa_file SET sfa05 = sfa05 - l_sfa05
              WHERE sfa01=l_sfs.sfs03 
                AND sfa03=l_sfs.sfs27  
                AND sfa12=l_sfs.sfs06 
                AND sfa08=l_sfs.sfs10
                AND sfa27=l_sfs.sfs27  
                AND sfa012=l_sfs.sfs012   
                AND sfa013=l_sfs.sfs013    

             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa05",1) 
                LET g_success='N' RETURN
             END IF
          END IF 
       END IF 
    END IF 
    #FUN-C30138---end
    IF s_industry('icd') THEN
       IF g_sma.sma115='Y' THEN
    UPDATE sfai_file SET sfaiicd04 = l_sfaiicd04_t,
                         sfaiicd05 = l_sfaiicd05_t
     WHERE sfai01=l_sfs.sfs03 
       AND sfai03=l_sfs.sfs04
       AND sfai12=l_sfs.sfs06 
       AND sfai08=l_sfs.sfs10
       AND sfai27=l_sfs.sfs27 
       AND sfai012=l_sfs.sfs012    #FUN-A60028 
       AND sfai013=l_sfs.sfs013    #FUN-A60028 
          
       END IF
    END IF
    
    #CHI-BA0020 mark (S) GP5.25的超領量不會回寫到已發量,所以取替代也不應該回寫    
    ##asfi512過帳時,不做下列替代料asf-642的檢核
    #IF g_prog != 'asfi512' THEN   #MOD-A40140 add
    ##MOD-550045 第二次取替代料時,若已發>應發-->應寫回最後加總後的應發量及已發量
    ##不應寫回超領量
    #IF (l_sfs.sfs26='S' OR l_sfs.sfs26='U' ) AND  p_code = 's' THEN
    #END IF
    #IF l_used > l_sfa.sfa05  #FUN-B50059
    #   AND (l_sfs.sfs26='S' OR l_sfs.sfs26='U')
    #   AND p_code = 's' THEN
    #      # 計算原主件及取替代件總應發量
    #      SELECT sum(sfa05),sum(sfa06) INTO ss_sfa05,ss_sfa06 FROM sfa_file  #FUN-B50059
    #       WHERE sfa01=l_sfs.sfs03 AND sfa27=l_sfs.sfs27
    #         AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
    #         AND sfa012=l_sfs.sfs012   #FUN-A60028 
    #         AND sfa013=l_sfs.sfs013   #FUN-A60028
    #      
    #      LET ss_sfa06 = ss_sfa06 + sfa062_t
    #      IF ss_sfa06 > ss_sfa05 THEN
    #      LET l_str='LINE No:',l_sfs.sfs02 USING '####' ,' sel sfa05'
    #      CALL cl_err(l_str,'asf-642',1) LET g_success='N' RETURN
    #   END IF
    #   # 將替代料號增加應發量
    #   UPDATE sfa_file SET sfa06 =sfa06_t+sfa062_t,
    #     sfa062 =0,
    #     sfa05  =sfa06_t+sfa062_t,
    #     sfa25  =0
    #    WHERE sfa01=l_sfs.sfs03 
    #      AND sfa03=l_sfs.sfs04
    #      AND sfa12=l_sfs.sfs06 
    #      AND sfa08=l_sfs.sfs10
    #      AND sfa27=l_sfs.sfs27  #No:FUN-870051 #No:MOD-8B0086 mark  #MOD-8C0098 modify
    #      AND sfa012=l_sfs.sfs012    #FUN-A60028 
    #      AND sfs013=l_sfs.sfs013    #FUN-A60028
    #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
    #CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs04,STATUS,"","upd sfa06/sfa062/sfa05",1)  #No.FUN-660128
    #LET g_success='N' RETURN 
    #   END IF
    #   # 將原主要料號扣除應發量
    #   IF cl_null(l_sfs.sfs27) THEN
    #SELECT sfa27,sfa28 INTO l_sfs.sfs27,l_sfs.sfs28 FROM sfa_file
    # WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs04
    #   AND sfa08=l_sfs.sfs10 AND sfa12=l_sfs.sfs06
    #   AND sfa27=l_sfs.sfs27  #No:FUN-870051 #No:MOD-8B0086 mark  #MOD-8C0098 modify
    #   AND sfa012=l_sfs.sfs012   #FUN-A60028 
    #   AND sfa013=l_sfs.sfs013   #FUN-A60028
    #   AND (sfa26='U' OR sfa26='S')
    #   END IF
    #   SELECT sfa05,sfa06 into ss_sfa05,ss_sfa06 FROM sfa_file
    #    WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs27
    #      AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
    #      AND sfa27=l_sfs.sfs27  #No:FUN-870051 #No:MOD-8B0086 mark  #MOD-8C0098 modify
    #      AND sfa012=l_sfs.sfs012   #FUN-A60028
    #      AND sfa013=l_sfs.sfs013   #FUN-A60028
    #   UPDATE sfa_file SET sfa05 = ss_sfa05 - sfa062_t,
    #                       sfa25 = ss_sfa05 - sfa062_t -ss_sfa06
    #    WHERE sfa01=l_sfs.sfs03 
    #      AND sfa03=l_sfs.sfs27
    #      AND sfa12=l_sfs.sfs06 
    #      AND sfa08=l_sfs.sfs10
    #      AND sfa27=l_sfs.sfs27  #No:FUN-870051 #No:MOD-8B0086 mark  #MOD-8C0098 modify
    #      AND sfa012=l_sfs.sfs012    #FUN-A60028 
    #      AND sfa013=l_sfs.sfs013    #FUN-A60028 
    #   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
    #CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs27,STATUS,"","upd sfa05/or ss_sfa05 is null",1)  #No.FUN-660128
    #LET g_success='N' RETURN 
    #   END IF
    #END IF
    #END IF   #MOD-A40140 add
    #CHI-BA0020 mark (E)
    
    IF l_sfa.sfa26 MATCHES '[13]' AND sfa06_t>0 THEN  #更新實際取代日
       LET l_sfb05=NULL
       SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_sfs.sfs03
       UPDATE bmd_file SET bmd09=l_sfp.sfp03
        WHERE bmd01=l_sfs.sfs04
    AND bmd02='1'
    AND (bmd08=l_sfb05 OR bmd08='ALL')
    AND bmd09 IS NULL
    END IF
    IF l_sfa.sfa26 ='S' AND sfa06_t>0 THEN  #更新最近替代日
       LET l_sfb05=NULL
       SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_sfs.sfs03
       UPDATE bmd_file SET bmd09=l_sfp.sfp03
        WHERE bmd04=l_sfs.sfs04
    AND bmd02='2'
    AND (bmd08=l_sfb05 OR bmd08='ALL')
    AND (bmd09 IS NULL OR bmd09<l_sfp.sfp03)
    END IF
   
  #FUN-A20037 --begin--
    IF l_sfa.sfa26 ='Z' AND sfa06_t>0 THEN  #更新最近替代日
       LET l_sfb05=NULL
       SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_sfs.sfs03
       UPDATE bon_file SET bon12 = l_sfp.sfp03 
        WHERE bonacti = 'Y'
    AND (bon02 = l_sfb05 OR bon02 = '*')
    AND (bon12 IS NULL OR bon12 < l_sfp.sfp03) 
    AND bon01 = l_sfs.sfs04
    AND bon01 IN(SELECT bmb03 FROM bmb_file WHERE bmb01=bon02 AND bmb16='7' )
    END IF
  #FUN-A20037 --end--

    IF g_sma.sma129='N' THEN
       #IF l_sfp.sfp06 MATCHES '[134689]' THEN #sfp06=超領(2),超退(7),    #MOD-CC0288 mark
        IF l_sfp.sfp06 MATCHES '[134689D]' THEN #sfp06=超領(2),超退(7),    #MOD-CC0288 add D
                 #重復性生產(ABC)的發料量
                 #不會計入sfa06,所以不會
                 #影響sfb081的結果
     CALL s_shortqty_max_sfb081(l_sfs.sfs03) 
          RETURNING l_flag,l_sfb081      #不管過賬或取消過賬,推算sfa06后的
                 #最大套數(sfb081)必是正確的最終最大套數
     IF NOT l_flag THEN
        CALL cl_err("","asf1003",0)
        LET g_success='N'
     ELSE
        #檢查發料套數不可大于生產套數:不需判斷sfp06的狀態,因sfa06已是考慮sfp06='1' or '6'的值
        IF l_sfb.sfb08 < l_sfb081 THEN
           CALL cl_err('sfb081 > sfb08','asf-447',1) 
           LET g_success='N' 
        ELSE
           IF l_sfp.sfp06 MATCHES '[16]' THEN  #只有成套領和成套退有sfq_file資料
        
        LET l_sfq04 = NULL
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM sfq_file
          WHERE sfq01 = l_sfs.sfs01
            AND sfq02 = l_sfs.sfs03
            AND sfq04 = l_sfs.sfs10
        IF l_cnt > 0 THEN
           LET l_sfq04 = l_sfs.sfs10
        ELSE
           SELECT COUNT(*) INTO l_cnt FROM sfq_file
             WHERE sfq01 = l_sfs.sfs01
               AND sfq02 = l_sfs.sfs03
               AND sfq04 = ' '
           IF l_cnt > 0 THEN
        LET l_sfq04 = ' '
           ELSE
        SELECT MIN(sfq04) INTO l_sfq04 FROM sfq_file
                WHERE sfq01 = l_sfs.sfs01
            AND sfq02 = l_sfs.sfs03
           END IF
        END IF
        IF l_sfq04 IS NULL THEN
           CALL cl_err('upd sfq','asf-134',0)
           LET g_success='N' 
        END IF
        IF p_code ='s' THEN              #過賬
           LET l_new_set = l_sfb081 - l_sfb.sfb081  #此次過賬的實際套數,l_sfb081在取得時
                      #已經過單位換算和小數取位故此處
                      #不需再處理,且必不為NULL
#MOD-B80175 --begin--
           IF g_prog = 'asfi526' AND l_new_set < 0 THEN    
                LET l_new_set = l_sfb.sfb081 - l_sfb081
           END IF 
#MOD-B80175 --end--
           UPDATE sfq_file SET sfq03 = l_new_set
            WHERE sfq01 = l_sfs.sfs01
              AND sfq02 = l_sfs.sfs03
              AND sfq04 = l_sfq04
           IF SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err('upd sfq','9050',0)
              LET g_success='N' 
           END IF
        ELSE  #取消過賬
           UPDATE sfq_file SET sfq03 = sfq08
             WHERE sfq01 = l_sfs.sfs01
               AND sfq02 = l_sfs.sfs03
               AND sfq04 = l_sfq04
           IF SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('upd sfq','9050',0)
        LET g_success='N' 
           END IF
        END IF
           END IF            
       
           #以下這段由原來的_s1()復制過來
           IF l_sfb.sfb04='1' THEN
        CALL cl_err('sfb04=1','asf-381',1) 
        LET g_success='N'
           END IF
           
           IF l_sfb.sfb04='8' THEN
        CALL cl_err('sfb04=8','asf-345',1) 
        LET g_success='N'
           END IF
           IF l_sfb.sfb04<'4' THEN 
        LET l_sfb.sfb04='4' 
           END IF
           IF l_sfb.sfb25 IS NULL OR l_sfb.sfb25>l_sfp.sfp03 THEN
        LET l_sfb.sfb25=l_sfp.sfp03
           END IF
           LET l_sfb.sfb87='Y'
           LET l_sfb.sfb88=l_sfp.sfp08
           LET l_sfb.sfb25=l_sfb.sfb25
   
           LET l_sfb.sfb081 = l_sfb081   #后面的子函數會用到 l_sfb的值,
                 #在此重設l_sfb.sfb081后就不需要再重撈一次
           #MOD-D30246---begin
           #IF l_sfb.sfb93 = 'Y' THEN  #TQC-D30053
           #   #MOD-D30125---begin
           #   SELECT ecm04,ecm012 INTO l_ecm04,l_ecm012
           #     FROM ecm_file
           #    WHERE ecm01 = l_sfs.sfs03
           #    ORDER BY ecm03
           #   IF l_ecm04 = l_sfs.sfs10 AND l_ecm012 = l_sfs.sfs012 THEN 
           #      #MOD-D30125---end
           #MOD-D30246---end
                 UPDATE sfb_file SET sfb04 = l_sfb.sfb04,
                   sfb87 = l_sfb.sfb87,
                   sfb88 = l_sfp.sfp08,
                   sfb25 = l_sfb.sfb25,
                   sfb081= l_sfb.sfb081
                   WHERE sfb01 = l_sfb.sfb01
           #MOD-D30246---begin        
           #      #MOD-D30125---begin
           #   ELSE
           #         UPDATE sfb_file SET sfb04 = l_sfb.sfb04,
           #                sfb87 = l_sfb.sfb87,
           #                sfb88 = l_sfp.sfp08,
           #                sfb25 = l_sfb.sfb25
           #          WHERE sfb01  = l_sfb.sfb01
           #   END IF  
           #   #MOD-D30125---end
           ##TQC-D30053---begin
           #ELSE
           #   UPDATE sfb_file SET sfb04 = l_sfb.sfb04,
           #          sfb87 = l_sfb.sfb87,
           #          sfb88 = l_sfp.sfp08,
           #          sfb25 = l_sfb.sfb25,
           #          sfb081= l_sfb.sfb081
           #    WHERE sfb01 = l_sfb.sfb01
           #END IF 
           ##TQC-D30053---end
           #MOD-D30246---end
           IF SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err('upd sfb','9050',0)
              LET g_success='N' 
           END IF
        END IF      
     END IF
        END IF
    END IF
  END FUNCTION
   
  FUNCTION i501sub_upd_ecm301(p_code,l_sfs03,l_sfs04,l_sfs10,l_sfb,l_sfs012,l_sfs013,l_sfp)   #FUN-A60028 add l_sfs012,l_sfs013 by vealxu
     DEFINE p_code        LIKE type_file.chr1
     DEFINE l_sfb RECORD  LIKE sfb_file.*
     DEFINE l_sfp RECORD  LIKE sfp_file.*
     DEFINE l_ima153      LIKE ima_file.ima153
#    DEFINE l_ecm57_gfe03 LIKE gfe_file.gfe03    #FUN-A60028
     DEFINE l_ecm58_gfe03 LIKE gfe_file.gfe03    #FUN-A60028 
     DEFINE l_ecm62       LIKE ecm_file.ecm62    #FUN-A60028
     DEFINE l_ecm63       LIKE ecm_file.ecm63    #FUN-A60028 
     DEFINE l_ecm58       LIKE ecm_file.ecm58    #FUN-A60028
     DEFINE l_cnt         LIKE type_file.num5    #FUN-A60028 
     DEFINE l_flag        LIKE  type_file.num5
     DEFINE l_mesg        STRING
     DEFINE l_ecm03       LIKE ecm_file.ecm03
     DEFINE l_ecm04       LIKE ecm_file.ecm04
     DEFINE l_ima55       LIKE ima_file.ima55
     DEFINE l_ima56       LIKE ima_file.ima56
     DEFINE l_ecm57       LIKE ecm_file.ecm57
     DEFINE l_ecm301      LIKE ecm_file.ecm301
     DEFINE g_min_set     LIKE ecm_file.ecm301
     DEFINE l_factorx     LIKE ecm_file.ecm301
     DEFINE l_sfs03       LIKE sfs_file.sfs03
     DEFINE l_sfs04       LIKE sfs_file.sfs04
     DEFINE l_sfs10       LIKE sfs_file.sfs10
     DEFINE l_shb111      LIKE shb_file.shb111  #MOD-9C0308
     DEFINE l_sfs012      LIKE sfs_file.sfs012  #FUN-A60028 by vealxu
     DEFINE l_sfs013      LIKE sfs_file.sfs013  #FUN-A60028 by vealxu
     DEFINE l_sfa012      LIKE sfa_file.sfa012  #TQC-AB0394
     DEFINE l_sfa013      LIKE sfa_file.sfa013  #TQC-AB0394
     DEFINE l_flag1       LIKE type_file.num5   #MOD-AC0336
     DEFINE l_sfb05       LIKE sfb_file.sfb05   #MOD-AC0336
     DEFINE l_find        LIKE type_file.chr1   #MOD-D10094

     LET l_find = 'N'    #MOD-D10094
     #TQC-AB0394--begin---add---
     IF g_sma.sma541 = 'Y' AND cl_null(l_sfs012) THEN
        IF cl_null(l_sfs10) THEN   #TQC-AC0083
           CALL s_schdat_min_ecm03(l_sfb.sfb01)
           RETURNING l_sfa012,l_sfa013
           LET l_sfs012=l_sfa012
           LET l_find = 'Y'  #MOD-D10094
        ELSE
           #TQC-AC0083--begin--add-----
           DECLARE i501_upd_ecm_c1 CURSOR FOR
              SELECT ecm012 FROM ecm_file
               WHERE ecm01=l_sfb.sfb01
                 AND ecm04=l_sfs10
               ORDER BY ecm012
           FOREACH i501_upd_ecm_c1 INTO l_sfa012
              LET l_sfs012=l_sfa012
              LET l_find = 'Y'  #MOD-D10094
              EXIT FOREACH
           END FOREACH
           #TQC-AC0083--end--add---------
        END IF
       #MOD-D10094 mark begin------------------------------
       ##MOD-C60234 add begin-------------------
       ##若走平行工藝,須判斷如果本製程段無上製程段
       #CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag1,l_sfb05
       #LET l_cnt = 0
       #SELECT COUNT(*) INTO l_cnt FROM ecu_file
       # WHERE ecu01=l_sfb05
       #   AND ecu02=l_sfb.sfb06
       #   AND ecu015=l_sfs012
       #IF l_cnt > 0 THEN
       #   RETURN TRUE
       #END IF
       ##MOD-C60234 add end---------------------
       #MOD-D10094 mark end------------------------------
     END IF
     #TQC-AB0394--end--add---
     LET l_ecm03=0
     SELECT MIN(ecm03) INTO l_ecm03
       FROM ecm_file
      WHERE ecm01=l_sfb.sfb01
        AND ecm012 = l_sfs012    #FUN-A60028 
     IF STATUS THEN LET l_ecm03=0 END IF
   
     IF cl_null(l_ecm03) OR l_ecm03 = 0 THEN 
        #CALL cl_err('','sdf-349',1)  #MOD-D30184
        CALL cl_err(l_sfb.sfb01,'sdf-349',1) #MOD-D30184
        RETURN FALSE
     END IF
         
#FUN-A60028 --begin--
    #IF g_sma.sma541='Y' THEN  #TQC-AC0082
     IF g_sma.sma542='Y' THEN  #TQC-AC0082
        #若走平行工藝,須判斷如果本製程段無上製程段,
        #且為最小製程序,才需累加寫 ecm301,否則由asft700回寫.   
        CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag1,l_sfb05  #MOD-AC0336
        LET l_cnt = 0   
        SELECT COUNT(*) INTO l_cnt FROM ecu_file
         WHERE ecu01=l_sfb05    #MOD-AC0336
           AND ecu02=l_sfb.sfb06
           AND ecu015=l_sfs012
        IF l_cnt > 0 THEN
           RETURN TRUE
        END IF
        IF l_ecm03 <> l_sfs013 THEN
           RETURN TRUE
        END IF
     END IF
#FUN-A60028 --end--    

     #判斷是否為制程首站 or 作業編號為空白
     SELECT ecm04 INTO l_ecm04 
      FROM ecm_file
           WHERE ecm01 = l_sfb.sfb01
         AND ecm03 = l_ecm03
         AND ecm012 = l_sfs012    #FUN-A60028 
     IF l_ecm04 IS NULL THEN
        LET l_ecm04 = ' '
     END IF
     
     IF (l_ecm04 = l_sfs10) OR (l_sfs10=' ') THEN
        LET g_min_set=0
        CALL s_get_ima153(l_sfs04) RETURNING l_ima153  
       #CALL s_minp_routing(l_sfs03,g_sma.sma73,l_ima153,l_sfs10,l_sfs012,l_sfs013)  #No.FUN-9B0140     #FUN-A60028 add sfs012,sfs013 by vealxu #MOD-C80233 mark
        CALL s_minp_routing(l_sfs03,g_sma.sma73,0,l_sfs10,l_sfs012,l_sfs013)        #MOD-C80233 add
        RETURNING l_flag,g_min_set
        IF l_flag !=0  THEN
           CALL cl_err(l_sfs03,'asf-549',1)
           RETURN FALSE
        END IF
        
        #---------------- 單位換算-------------------------#
        SELECT ima55,ima56 INTO l_ima55,l_ima56 FROM ima_file 
        WHERE ima01=l_sfb.sfb05
        IF STATUS THEN LET l_ima55=' ' END IF
#FUN-A60028 --begin--         
#       SELECT ecm57,gfe03 INTO l_ecm57,l_ecm57_gfe03
#        FROM ecm_file LEFT OUTER JOIN gfe_file ON (ecm_file.ecm57 = gfe_file.gfe01)
#       WHERE ecm01=l_sfb.sfb01
#         AND ecm03=l_ecm03
#       IF STATUS THEN LET l_ecm57=' ' END IF
#       IF l_ecm57_gfe03 IS NULL THEN
#          LET l_ecm57_gfe03 = 0
#       END IF
#             
#       CALL s_umfchk(l_sfb.sfb05,l_ima55,l_ecm57)             
#       IF l_flag = 1 THEN
#           LET l_mesg = NULL  
#           LET l_mesg = l_sfb.sfb05,"(ima55/ecm57):"
#           CALL cl_err(l_mesg,'abm-731',1)
#           RETURN FALSE
#       END IF
        SELECT ecm58,ecm62,ecm63,gfe03 INTO l_ecm58,l_ecm62,l_ecm63,l_ecm58_gfe03
         FROM ecm_file LEFT OUTER JOIN gfe_file ON (ecm_file.ecm58 = gfe_file.gfe01)
        WHERE ecm01=l_sfb.sfb01
          AND ecm03=l_ecm03
          AND ecm012 = l_sfs012  #FUN-A60028
          
        IF STATUS THEN LET l_ecm58=' ' END IF
        IF l_ecm58_gfe03 IS NULL THEN
           LET l_ecm58_gfe03 = 0
        END IF
        IF cl_null(l_ecm62) THEN 
           LET l_ecm62 = 1   #FUN-A70143
        END IF 
        IF cl_null(l_ecm63) THEN 
           LET l_ecm63 = 1   #FUN-A70143 
        END IF 
#FUN-A60028 --end--

        #最小齊套數不需考慮ima56,實際發多少就是多少,故只需考慮單位換算和小數取位
#FUN-A60028 --begin--
#       LET l_ecm301 = g_min_set*l_factorx
#       LET l_ecm301 = cl_digcut(l_ecm301,l_ecm57_gfe03)
        LET l_ecm301 = g_min_set*l_ecm62/l_ecm63
        LET l_ecm301 = cl_digcut(l_ecm301,l_ecm58_gfe03)
#FUN-A60028 --end--
   
        #過帳後,ecm301不可小於本站的報工數,否則wip qty 會為負
        SELECT SUM(shb111) INTO l_shb111 
          FROM shb_file
         WHERE shb05=l_sfb.sfb01
           AND shb06=l_ecm03
           AND shb012=l_sfs012  #FUN-A60028
           AND shbconf = 'Y'    #FUN-A70095
        IF SQLCA.sqlcode OR l_shb111 IS NULL THEN
     LET l_shb111 = 0
        END IF
#str----add by huanglf160819        
  #      IF l_ecm301 < l_shb111 THEN
  #   LET g_showmsg = l_sfs03,"/",l_sfs04,"/",l_sfs10
     #str----add by huanglf160817
  #   IF l_sfp.sfp06 !='1' THEN  
  #       CALL s_errmsg('sfs04,sfs04,sfs10',g_showmsg,'','asf-135',1)
  #   RETURN FALSE
   #  END IF  
     #str----add by huanglf160817
#        END IF
#str----end by huanglf160819        
        #過賬和取消過賬的結果已反映到最小套數上,故不需考慮本次為過賬或取消過賬,直接將結果更新到ecm301
        #MOD-D10094  add --begin
        #首站可能不止一笔
        IF l_find = 'Y' THEN
           UPDATE ecm_file SET ecm301=l_ecm301
            WHERE ecm01=l_sfb.sfb01
              AND ecm03=l_ecm03
              AND (ecm011 IS NULL OR ecm011 = ' ')
        ELSE
        #MOD-D10094 add --end
           UPDATE ecm_file SET ecm301=l_ecm301
            WHERE ecm01=l_sfb.sfb01 
              AND ecm03=l_ecm03
              AND ecm012=l_sfs012  #FUN-A60028
        END IF #MOD-D10094
        IF SQLCA.sqlerrd[3]=0 THEN
     CALL cl_err3("upd","ecm_file",l_sfb.sfb01,l_ecm03,STATUS,"","upd ecm301",1)
     RETURN FALSE
        END IF
     END IF
     RETURN TRUE
  END FUNCTION
   
  FUNCTION i501sub_u_o_sfa(p_argv1,l_sfs,l_sfb) # 將原sfa項次應發減少,替代碼 1/2 -> 3/4
       DEFINE o_sfa RECORD LIKE sfa_file.*
       DEFINE p_argv1 LIKE type_file.chr1
       DEFINE l_sfs RECORD LIKE sfs_file.* #FUN-740187
       DEFINE l_sfb RECORD LIKE sfb_file.* #FUN-740187
   
       SELECT * INTO o_sfa.* FROM sfa_file
       WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs27   #No.FUN-940008    #TQC-B60091
         AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
         AND sfa27=l_sfs.sfs27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 modify
         AND sfa012=l_sfs.sfs012   #FUN-A60028 
         AND sfa013=l_sfs.sfs013   #FUN-A60028
       IF STATUS THEN
          CALL cl_err3("sel","sfa_file",l_sfs.sfs03,l_sfs.sfs27,STATUS,"","sel o.sfa.*",1)  #No.FUN-660128
          LET g_success='N' RETURN
       END IF
       IF o_sfa.sfa26 = '0' THEN
          CALL cl_err('o.sfa26=0','mfg6201',1) LET g_success='N' RETURN
       END IF
       IF o_sfa.sfa26 = '1' THEN LET o_sfa.sfa26 = '3' END IF
       IF o_sfa.sfa26 = '2' THEN LET o_sfa.sfa26 = '4' END IF
       IF o_sfa.sfa26 = '7' THEN LET o_sfa.sfa26 = '8' END IF  #FUN-A20037 add
       IF o_sfa.sfa26 = '9' THEN LET o_sfa.sfa26 = 'A' END IF  #TQC-B90236 add
       LET o_sfa.sfa05 = o_sfa.sfa05 - l_sfs.sfs05/l_sfs.sfs28
       IF o_sfa.sfa05 < 0 AND
         ((p_argv1 = '1') OR (p_argv1='2' AND l_sfb.sfb02 NOT MATCHES '[58]')) THEN  #NO:7075
          CALL cl_err('o.sfa05<0','asf-447',1) LET g_success='N' RETURN
       END IF
       IF o_sfa.sfa05 < o_sfa.sfa06 AND  #FUN-B50059
          (((p_argv1 = '1') OR (p_argv1='2' AND l_sfb.sfb02 NOT MATCHES '[58]'))) THEN
           CALL cl_err('o.sfa05<0','asf-447',1) LET g_success='N' RETURN
       END IF
       UPDATE sfa_file SET sfa05=o_sfa.sfa05, sfa26=o_sfa.sfa26
       WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs27   #No.FUN-940008 #TQC-B60091
         AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
         AND sfa27=l_sfs.sfs27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 modify
         AND sfa012=l_sfs.sfs012    #FUN-A60028 
         AND sfa013=l_sfs.sfs013    #FUN-A60028 
       IF STATUS THEN
          CALL cl_err3("upd","sfa_file",l_sfs.sfs03,l_sfs.sfs27,STATUS,"","upd o.sfa05",1)  #No.FUN-660128
          LET g_success='N' RETURN
       END IF
  END FUNCTION

#FUN-A60095 mark(S)
#  FUNCTION i501sub_short(l_sfp)
#    DEFINE l_gfe03        LIKE gfe_file.gfe03
#    DEFINE qty1,qty2  LIKE sfq_file.sfq03    #No.FUN-680121 DEC(15,3)
#    DEFINE l_sql          LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(500)
#    DEFINE l_sfp          RECORD LIKE sfp_file.*  #FUN-740187
#    DEFINE l_sfa          RECORD LIKE sfa_file.*  #FUN-740187
#    DEFINE l_issue_set    LIKE sfa_file.sfa07     #No.FUN-680121 DEC(15,3),
#   
#    CALL cl_msg('short process ...')
#    UPDATE sfa_file SET sfa07=0
#       WHERE sfa01 IN
#    (SELECT sfs03 FROM sfs_file WHERE sfs01=l_sfp.sfp01 GROUP BY sfs03)
#    IF STATUS THEN 
#       CALL cl_err3("upd","sfs_file","","",STATUS,"","u sfa07",1)  #No.FUN-660128
#       LET g_success='N' RETURN END IF
#    UPDATE sfa_file SET sfa07=0
#       WHERE sfa01 IN
#    (SELECT sfe01 FROM sfe_file WHERE sfe02=l_sfp.sfp01 GROUP BY sfe01)
#    IF STATUS THEN 
#       CALL cl_err3("upd","sfe_file","","",STATUS,"","u sfa07",1)  #No.FUN-660128
#       LET g_success='N' RETURN END IF
#   
#    SELECT sfp04 INTO l_sfp.sfp04 FROM sfp_file WHERE sfp01=l_sfp.sfp01
#   
#    IF l_sfp.sfp04 = 'Y' THEN   #已過帳
#       LET l_sql="SELECT sfa_file.* FROM sfa_file ",
#           " WHERE sfa01 IN (SELECT UNIQUE sfe01 FROM sfe_file ",
#           "                  WHERE sfe02='",l_sfp.sfp01,"')",
#           "   AND sfa26 IN ('0','1','2','3','4','5','T','S','U','7','8','Z')",  #bungo:7111 add '5T' #FUN-740187  #FUN-A20037 add '7,8,Z'
#           "   AND sfa05 >= 0 " #B502 010508     #bugno:5397 modify >=.....
#    ELSE
#       LET l_sql="SELECT sfa_file.* FROM sfa_file",
#           " WHERE sfa01 IN (SELECT sfs03 FROM sfs_file ",
#           "                WHERE sfs01='",l_sfp.sfp01,"' GROUP BY sfs03) ",
#    #在欠料補料單還原確認計算欠料量有問題
#           "   AND sfa26 IN ('0','1','2','3','4','5','T','S','U','7','8','Z')", #FUN-740187  #FUN-A20037 add '7,8,Z'
#           "   AND sfa05 >= 0 "  #B502 010508    #bugno:5397 modify >=.......
#   
#    END IF
#   
#    PREPARE i501_short_pre FROM l_sql
#    DECLARE i501_short_c CURSOR FOR i501_short_pre
#   
#    FOREACH i501_short_c INTO l_sfa.*
#      IF STATUS THEN CALL cl_err('f sfa',STATUS,1)LET g_success='N' RETURN END IF
#      IF l_sfa.sfa11 = 'X' THEN CONTINUE FOREACH END IF  #CHI-980013
#      IF l_sfa.sfa11 = 'C' THEN CONTINUE FOREACH END IF  #FUN-A30093
#      LET qty1 = 0
#      LET qty2 = 0
#   
#  #計算單身備料成套已發料總數量
#      DECLARE i501_cs6 CURSOR FOR
#       SELECT SUM(sfq03) FROM sfp_file,sfq_file
#        WHERE sfp06='1'
#    AND sfp01=sfq01
#    AND sfq02=l_sfa.sfa01
#    AND sfp04='Y'
#        GROUP BY sfq04
#        ORDER BY 1 DESC
#      FOREACH i501_cs6 INTO qty1
#        IF STATUS THEN LET qty1=0 END IF
#        EXIT FOREACH
#      END FOREACH
#   
#  #計算單身備料成套退料總數量
#      DECLARE i501_cs7 CURSOR FOR
#       SELECT SUM(sfq03) FROM sfp_file,sfq_file   #發料套數合計
#        WHERE sfp06='6'           #6:成套退料
#    AND sfp01=sfq01
#    AND sfq02=l_sfa.sfa01
#    AND sfp04='Y'
#        GROUP BY sfq04
#        ORDER BY 1 DESC
#      FOREACH i501_cs7 INTO qty2
#        IF STATUS THEN LET qty2=0 END IF
#        EXIT FOREACH
#      END FOREACH
#      IF qty1 IS NULL THEN LET qty1=0 END IF
#      IF qty2 IS NULL THEN LET qty2=0 END IF
#   
#      LET l_issue_set=qty1-qty2     #實際已發套數
#   
#      IF l_sfa.sfa26 MATCHES '[0125T7]' AND l_sfa.sfa05 > 0 THEN   #bugno:7111 add '5T'  #FUN-A20037 ADD '7'
#         ## sfa07=(套數*QPA)-已發[sfa06]-代買[sfa065]
#         LET l_sfa.sfa07=l_issue_set*l_sfa.sfa161-l_sfa.sfa06-l_sfa.sfa065
#         IF l_sfa.sfa064<0 THEN
#      LET l_sfa.sfa07=l_sfa.sfa07+l_sfa.sfa064   #bugno:5383  add sfa064
#         END IF
#         #-->考慮單位小數取位
#         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sfa.sfa12
#         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
#         CALL cl_digcut(l_sfa.sfa07,l_gfe03) RETURNING l_sfa.sfa07
#         IF l_sfa.sfa07>0 THEN
#      UPDATE sfa_file SET sfa07=l_sfa.sfa07
#       WHERE sfa01=l_sfa.sfa01 AND sfa27=l_sfa.sfa03
#         AND sfa12=l_sfa.sfa12 AND sfa08=l_sfa.sfa08
#         AND sfa012=l_sfa.sfa012   #FUN-A60028 
#         AND sfa013=l_sfa.sfa013   #FUN-A60028
#      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#         CALL cl_err3("upd","sfa_file",l_sfa.sfa01,l_sfa.sfa03,STATUS,"","upd sfa07",1)  #No.FUN-660128
#         LET g_success='N' RETURN
#      END IF
#         END IF
#         CONTINUE FOREACH
#      END IF
#      IF l_sfa.sfa26 MATCHES '[34SU8Z]' THEN CALL i501sub_short2(l_sfa.*,l_issue_set) END IF  #FUN-A20037 add '8,Z'
#    END FOREACH
#    IF SQLCA.sqlcode THEN CALL cl_err('f sfa',STATUS,1)LET g_success='N' RETURN END IF
#  END FUNCTION
#
#  # 當有替代狀況時, 須作以下處理
#  FUNCTION i501sub_short2(l_sfa,l_issue_set)
#    DEFINE short_qty   LIKE sfa_file.sfa06  #No.FUN-680121 DEC(15,3)
#    DEFINE l_sfb08     LIKE sfb_file.sfb08  #MOD-4B0145  add
#    DEFINE l_gfe03     LIKE gfe_file.gfe03  #No.MOD-940311 add
#    DEFINE l_sfa       RECORD LIKE sfa_file.*  #FUN-740187
#    DEFINE l_sfa2      RECORD LIKE sfa_file.*  #FUN-740187
#    DEFINE l_issue_set LIKE sfa_file.sfa07     #No.FUN-680121 DEC(15,3),
#    DEFINE l_sfbiicd04 LIKE sfbi_file.sfbiicd04,  #預計生產數量
#     l_sfbiicd09 LIKE sfbi_file.sfbiicd09,  #ecd作業編號
#     l_ecdicd01  LIKE ecd_file.ecdicd01     #ecd作業群組
#   
#      SELECT SUM(sfa06) INTO l_sfa.sfa06 FROM sfa_file
#         WHERE sfa01=l_sfa.sfa01 AND sfa03=l_sfa.sfa03   #MOD-4B0145  modify sfa27->sfa03
#          AND sfa12=l_sfa.sfa12 AND sfa08=l_sfa.sfa08
#          AND sfa27=l_sfa.sfa27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 cancel mark
#          AND sfa012=l_sfa.sfa012   #FUN-A60028 
#          AND sfa013=l_sfa.sfa013   #FUN-A60028
#      IF STATUS THEN 
#         CALL cl_err3("sel","sfa_file",l_sfa.sfa01,l_sfa.sfa27,STATUS,"","s/sfa",1)  #No.FUN-660128
#         LET g_success='N' RETURN END IF
#      IF l_sfa.sfa06 IS NULL THEN LET l_sfa.sfa06 = 0 END IF
#      IF cl_null(l_sfa.sfa161) OR l_sfa.sfa161 = 0 THEN LET l_sfa.sfa161 = 1 END IF
#   
#      SELECT sfb08 INTO l_sfb08 FROM sfb_file
#       WHERE sfb01 = l_sfa.sfa01
#   
#   
#      SELECT sfbiicd04,sfbiicd09 INTO l_sfbiicd04,l_sfbiicd09
#        FROM sfbi_file
#       WHERE sfbi01 = l_sfa.sfa01
#   
#      IF l_sfa.sfa26 MATCHES '[SUZ]' THEN  #FUN-A20037 add 'Z'
#         LET short_qty=l_issue_set*(l_sfa.sfa05/l_sfb08) - l_sfa.sfa06
#         IF s_industry('icd') THEN
#      #  成套發料：
#      #  1若工單作業群組=3.DS或4.ASS
#      #   1.1若預計生產數量(sfbiicd04) <> 0, 則用預計生產數量控卡發料數
#      #   1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
#      #      則用生產數量控卡發料數
#      #  2.其他: 比照標準作法 
#      IF l_ecdicd01 MATCHES '[34]' THEN
#         IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
#      LET short_qty=l_issue_set*(l_sfa.sfa05/l_sfbiicd04) - l_sfa.sfa06
#         ELSE
#      LET short_qty=l_issue_set*(l_sfa.sfa05/l_sfb08) - l_sfa.sfa06
#         END IF
#      ELSE
#         LET short_qty=l_issue_set*(l_sfa.sfa05/l_sfb08) - l_sfa.sfa06
#      END IF
#         END IF
#   
#  display 'l_sfa.sfa26:',l_sfa.sfa26
#  display 'l_issue_set*l_sfa.sfa161-l_sfa.sfa06=short_qty:',short_qty
#      ELSE
#  #                   (實際發料應發套數 * QPA)-已發[sfa06]
#         LET short_qty=l_issue_set*l_sfa.sfa161-l_sfa.sfa06
#  display 'l_sfa.sfa26:',l_sfa.sfa26
#  display 'l_issue_set*l_sfa.sfa161-l_sfa.sfa06=short_qty:',short_qty
#      END IF
#  ##
#   
#      DECLARE i501_short_c2 CURSOR FOR
#        SELECT * FROM sfa_file       #MOD-4B0145  sfa27 -> sfa03
#        WHERE sfa01=l_sfa.sfa01 AND sfa03=l_sfa.sfa03
#          AND sfa08=l_sfa.sfa08 AND sfa12=l_sfa.sfa12
#          AND sfa27=l_sfa.sfa27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 cancel mark
#          AND sfa012=l_sfa.sfa012    #FUN-A60028
#          AND sfa013=l_sfa.sfa013    #FUN-A60028
#        ORDER BY sfa03, sfa27
#      FOREACH i501_short_c2 INTO l_sfa2.*     #應發(含替代)料件(l_sfa2
#         IF STATUS THEN CALL cl_err('f sfa2',STATUS,1) RETURN END IF
#         IF l_sfa2.sfa05<=l_sfa2.sfa06 THEN CONTINUE FOREACH END IF
#         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sfa.sfa12
#         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
#  #                    ( 應發  -  已發 ) / 替代率
#         IF short_qty>(l_sfa2.sfa05-l_sfa2.sfa06) THEN
#  display 'short_qty>(l_sfa2.sfa05-l_sfa2.sfa06)/l_sfa2.sfa28'
#      LET l_sfa2.sfa07=(l_sfa2.sfa05-l_sfa2.sfa06) - l_sfa2.sfa065
#  display 'l_sfa2.sfa07=',l_sfa2.sfa07
#           IF l_sfa2.sfa07 <0 THEN LET l_sfa2.sfa07=0 END IF
#           CALL cl_digcut(l_sfa2.sfa07,l_gfe03) RETURNING l_sfa2.sfa07     #No.MOD-940311 add   #MOD-980185
#           UPDATE sfa_file SET sfa07=l_sfa2.sfa07
#          WHERE sfa01=l_sfa2.sfa01 AND sfa03=l_sfa2.sfa03
#            AND sfa12=l_sfa2.sfa12 AND sfa08=l_sfa2.sfa08
#            AND sfa27=l_sfa2.sfa27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 cancel mark
#            AND sfa012=l_sfa2.sfa012   #FUN-A60028 
#            AND sfa013=l_sfa2.sfa013   #FUN-A60028
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err3("upd","sfa_file",l_sfa2.sfa01,l_sfa2.sfa03,STATUS,"","upd sfa07",1)  #No.FUN-660128
#        LET g_success='N' RETURN
#           END IF
#           LET short_qty=short_qty-(l_sfa2.sfa05-l_sfa2.sfa06) - l_sfa2.sfa065
#           CONTINUE FOREACH
#      ELSE
#  display 'short_qty>(l_sfa2.sfa05-l_sfa2.sfa06)/l_sfa2.sfa28'
#           LET l_sfa2.sfa07=short_qty - l_sfa2.sfa065
#  display 'l_sfa2.sfa07=',l_sfa2.sfa07
#           IF l_sfa2.sfa07 <0 THEN LET l_sfa2.sfa07=0 END IF
#           CALL cl_digcut(l_sfa2.sfa07,l_gfe03) RETURNING l_sfa2.sfa07     #No.MOD-940311 add   #MOD-980185
#           UPDATE sfa_file SET sfa07=l_sfa2.sfa07
#          WHERE sfa01=l_sfa2.sfa01 AND sfa03=l_sfa2.sfa03
#            AND sfa12=l_sfa2.sfa12 AND sfa08=l_sfa2.sfa08
#            AND sfa27=l_sfa2.sfa27  #No.FUN-870051 #No.MOD-8B0086 mark  #MOD-8C0098 cancel mark
#            AND sfa012=l_sfa2.sfa012    #FUN-A60028
#            AND sfa013=l_sfa2.sfa013    #FUN-A60028 
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err3("upd","sfa_file",l_sfa2.sfa01,l_sfa2.sfa03,STATUS,"","upd sfa07",1)  #No.FUN-660128
#        LET g_success='N' RETURN
#           END IF
#           EXIT FOREACH
#         END IF
#      END FOREACH
#  END FUNCTION
#FUN-A60095 mark(E)

  FUNCTION i501sub_s2_asr(p_argv1,l_sfp)
    DEFINE l_ima108 LIKE ima_file.ima108
    DEFINE l_n      LIKE type_file.num5    #No.FUN-680121 SMALLINT
    DEFINE p_argv1  LIKE type_file.chr1    #FUN-740187
    DEFINE l_sfp    RECORD LIKE sfp_file.* #FUN-740187
    DEFINE l_sfs    RECORD LIKE sfs_file.* #FUN-740187
    DEFINE l_sfe    RECORD LIKE sfe_file.* #No.MOD-790112 add
   
    DECLARE i501_s2_c1 CURSOR FOR
      SELECT * FROM sfs_file
       WHERE sfs01=l_sfp.sfp01
    FOREACH i501_s2_c1 INTO l_sfs.*
        IF STATUS THEN
     CALL cl_err('for sfs:',STATUS,1) LET g_success='N' EXIT FOREACH   
        END IF
        IF cl_null(l_sfs.sfs04) THEN CONTINUE FOREACH END IF
   
        SELECT ima108 INTO l_ima108 FROM ima_file
         WHERE ima01=l_sfs.sfs04
        IF l_ima108='Y' THEN
     SELECT COUNT(*) INTO l_n FROM imd_file
      WHERE imd01=l_sfs.sfs07 AND imd10='W'
         AND imdacti = 'Y'
     IF l_n = 0 THEN
         LET g_totsuccess='N'
         LET g_success="Y"
         LET g_showmsg = l_sfs.sfs04,"/",l_sfs.sfs07  #MOD-890107 add
         IF g_bgerr THEN
      CALL s_errmsg('sfs04,imd01',g_showmsg,'','asf-724',1)
      CONTINUE FOREACH
         ELSE
      LET g_success="N"
      CALL cl_err(g_showmsg,'asf-724',1)
      EXIT FOREACH
         END IF
     END IF
        END IF
   
        IF g_sma.sma115 = 'Y' THEN
     IF l_sfs.sfs32 != 0 OR l_sfs.sfs35 != 0 THEN
        CALL i501sub_update_du('s',p_argv1,l_sfp.*,l_sfs.*,l_sfe.*)    #No.MOD-790112 add l_sfe
        IF g_success='N' THEN 
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
        END IF
     END IF
        END IF
        #str-----add by guanyao160903
        IF l_sfs.sfs07 <> l_sfs.sfsud02 THEN 
           LET l_sfs.sfs08 = ' '
        END IF 
        #end-----add by guanyao160903
        CALL i501sub_update(l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,
             l_sfs.sfs05,l_sfs.sfs06,1,p_argv1,l_sfp.*,l_sfs.*)
        IF g_success='N' THEN 
     LET g_totsuccess='N'
     LET g_success="Y"
     CONTINUE FOREACH   #No.FUN-6C0083
        END IF
    END FOREACH
    
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
   
    CALL s_showmsg()   #No.FUN-6C0083
   
    
  END FUNCTION
   
  #p_type : s-過帳 ; w-取銷過帳
  FUNCTION i501sub_update_du(p_type,p_argv1,l_sfp,l_sfs,l_sfe)    #No.MOD-790112 add l_sfe
  DEFINE l_ima25   LIKE ima_file.ima25,
         u_type    LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
         p_type    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01)
         p_argv1   LIKE type_file.chr1,    #FUN-740187
         l_sfp     RECORD LIKE sfp_file.*, #FUN-740187
         l_sfs     RECORD LIKE sfs_file.*, #FUN-740187
         l_sfe     RECORD LIKE sfe_file.*, #FUN-740187
         l_ima906  LIKE ima_file.ima906,   #FUN-740187
         l_ima907  LIKE ima_file.ima907    #FUN-740187
   
     IF g_sma.sma115 = 'N' THEN RETURN END IF
   
     IF p_type = 's' THEN
        CASE WHEN p_argv1 ='1' LET u_type=-1
       WHEN p_argv1 ='2' LET u_type=+1
        END CASE
     ELSE
        CASE WHEN p_argv1 ='1' LET u_type=+1
       WHEN p_argv1 ='2' LET u_type=-1
        END CASE
     END IF
   
     IF p_type = 's' THEN
        SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
         WHERE ima01 = l_sfs.sfs04
        SELECT ima25 INTO l_ima25 FROM ima_file
         WHERE ima01=l_sfs.sfs04
     ELSE
        SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
         WHERE ima01 = l_sfe.sfe07
        SELECT ima25 INTO l_ima25 FROM ima_file
         WHERE ima01=l_sfe.sfe07
     END IF
     IF SQLCA.sqlcode THEN
        LET g_success='N' RETURN
     END IF
     IF l_ima906 = '2' THEN  #子母單位
        IF p_type = 's' THEN
     IF NOT cl_null(l_sfs.sfs33) THEN
        CALL i501sub_upd_imgg('1',l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
               l_sfs.sfs09,l_sfs.sfs33,l_sfs.sfs34,l_sfs.sfs35,u_type,'2',l_sfp.*)
        IF g_success='N' THEN RETURN END IF
   
        IF NOT cl_null(l_sfs.sfs35) AND l_sfs.sfs35 <> 0 THEN
           CALL i501sub_tlff(l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_ima25,
              l_sfs.sfs35,0,l_sfs.sfs33,l_sfs.sfs34,u_type,'2',p_argv1,l_sfp.*,l_sfs.*)
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
        ELSE
     IF NOT cl_null(l_sfe.sfe33) THEN
        CALL i501sub_upd_imgg('1',l_sfe.sfe07,l_sfe.sfe08,l_sfe.sfe09,
               l_sfe.sfe10,l_sfe.sfe33,l_sfe.sfe34,l_sfe.sfe35,u_type,'2',l_sfp.*)
        IF g_success='N' THEN RETURN END IF
     END IF
        END IF
        IF p_type = 's' THEN
     IF NOT cl_null(l_sfs.sfs30) THEN
        CALL i501sub_upd_imgg('1',l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
               l_sfs.sfs09,l_sfs.sfs30,l_sfs.sfs31,l_sfs.sfs32,u_type,'1',l_sfp.*)
        IF g_success='N' THEN RETURN END IF
   
        IF NOT cl_null(l_sfs.sfs32) AND l_sfs.sfs32 <> 0 THEN
           CALL i501sub_tlff(l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_ima25,
           l_sfs.sfs32,0,l_sfs.sfs30,l_sfs.sfs31,u_type,'1',p_argv1,l_sfp.*,l_sfs.*)
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
        ELSE
     IF NOT cl_null(l_sfe.sfe30) THEN
        CALL i501sub_upd_imgg('1',l_sfe.sfe07,l_sfe.sfe08,l_sfe.sfe09,
               l_sfe.sfe10,l_sfe.sfe30,l_sfe.sfe31,l_sfe.sfe32,u_type,'1',l_sfp.*)
        IF g_success='N' THEN RETURN END IF
     END IF
        END IF
        IF p_type = 'w' THEN
     CALL i501sub_tlff_w(l_sfp.*,l_sfe.*)    #No.MOD-790112 add l_sfp
     IF g_success='N' THEN RETURN END IF
        END IF
     END IF
     IF l_ima906 = '3' THEN  #參考單位
        IF p_type = 's' THEN
     IF NOT cl_null(l_sfs.sfs33) THEN
        CALL i501sub_upd_imgg('2',l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
               l_sfs.sfs09,l_sfs.sfs33,l_sfs.sfs34,l_sfs.sfs35,u_type,'2',l_sfp.*)
        IF g_success = 'N' THEN RETURN END IF
   
        IF NOT cl_null(l_sfs.sfs35) AND l_sfs.sfs35 <> 0 THEN
           CALL i501sub_tlff(l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_ima25,
              l_sfs.sfs35,0,l_sfs.sfs33,l_sfs.sfs34,u_type,'2',p_argv1,l_sfp.*,l_sfs.*)
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
        ELSE
     IF NOT cl_null(l_sfe.sfe33) THEN
        CALL i501sub_upd_imgg('2',l_sfe.sfe07,l_sfe.sfe08,l_sfe.sfe09,
               l_sfe.sfe10,l_sfe.sfe33,l_sfe.sfe34,l_sfe.sfe35,u_type,'2',l_sfp.*)
        IF g_success = 'N' THEN RETURN END IF
     END IF
        END IF
        IF p_type = 'w' THEN
     CALL i501sub_tlff_w(l_sfp.*,l_sfe.*)    #No.MOD-790112 add l_sfp
     IF g_success='N' THEN RETURN END IF
        END IF
     END IF
   
  END FUNCTION
   
  FUNCTION i501sub_tlff_w(l_sfp,l_sfe)    #No.MOD-790112 add l_sfp
     DEFINE l_sfe  RECORD LIKE sfe_file.*
     DEFINE l_sfp  RECORD LIKE sfp_file.*  #No.MOD-790112 add
   
      CALL cl_msg("d_tlff!")  #FUN-840012
      CALL ui.Interface.refresh()
   
      DELETE FROM tlff_file
       WHERE tlff62=l_sfe.sfe01
        AND ((tlff026=l_sfe.sfe02 AND tlff027=l_sfe.sfe28) OR
       (tlff036=l_sfe.sfe02 AND tlff037=l_sfe.sfe28))
         AND tlff06 =l_sfp.sfp03 #異動日期
   
      IF STATUS THEN
         CALL cl_err3("del","tlff_file",l_sfe.sfe01,"",STATUS,"","del tlff",1)  #No.FUN-660128
         LET g_success='N' RETURN
      END IF
  END FUNCTION
   
  FUNCTION i501sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
             p_imgg09,p_imgg211,p_imgg10,p_type,p_no,l_sfp)
    DEFINE p_imgg00   LIKE imgg_file.imgg00,
     p_imgg01   LIKE imgg_file.imgg01,
     p_imgg02   LIKE imgg_file.imgg02,
     p_imgg03   LIKE imgg_file.imgg03,
     p_imgg04   LIKE imgg_file.imgg04,
     p_imgg09   LIKE imgg_file.imgg09,
     p_imgg10   LIKE imgg_file.imgg10,
     p_imgg211  LIKE imgg_file.imgg211,
     l_ima25    LIKE ima_file.ima25,
     l_ima906   LIKE ima_file.ima906,
     l_imgg21   LIKE imgg_file.imgg21,
     p_no       LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
     p_type     LIKE type_file.num10    #No.FUN-680121 INTEGER
    DEFINE l_cnt      LIKE type_file.num5     #FUN-740187
    DEFINE l_sfp      RECORD LIKE sfp_file.*
   
      LET g_forupd_sql = "SELECT imgg01,imgg02,imgg03,imgg04,imgg00,imgg09 FROM imgg_file ",
             " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
             "  AND imgg00= ? AND imgg09= ? FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

      DECLARE imgg_lock CURSOR FROM g_forupd_sql
   
      OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg00,p_imgg09
      IF STATUS THEN
         CALL cl_err("OPEN imgg_lock:", STATUS, 1)
         LET g_success='N'
         CLOSE imgg_lock
         RETURN
      END IF
      FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg00,p_imgg09
      IF STATUS THEN
         CALL cl_err('lock imgg fail',STATUS,1)
         LET g_success='N'
         CLOSE imgg_lock
         RETURN
      END IF
   
      SELECT ima25,ima906 INTO l_ima25,l_ima906
        FROM ima_file WHERE ima01=p_imgg01
      IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
         CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660128
         LET g_success = 'N' RETURN
      END IF
   
      CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
      RETURNING l_cnt,l_imgg21
      IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
         CALL cl_err('','mfg3075',0)
         LET g_success = 'N' RETURN
      END IF
      CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,l_sfp.sfp03,  #FUN-8C0084   #No.MOD-940320 add
      '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
      IF g_success='N' THEN RETURN END IF
   
  END FUNCTION
   
  FUNCTION i501sub_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
         u_type,p_flag,p_argv1,l_sfp,l_sfs)
  DEFINE
  #  l_ima262   LIKE ima_file.ima262,
     l_avl_stk  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
     l_ima25    LIKE ima_file.ima25,
     l_ima55    LIKE ima_file.ima55,
     l_ima86    LIKE ima_file.ima86,
     p_ware     LIKE img_file.img02,   ##倉庫
     p_loca     LIKE img_file.img03,   ##儲位
     p_lot      LIKE img_file.img04,       ##批號
     p_unit     LIKE img_file.img09,
     p_qty      LIKE img_file.img10,       ##數量
     p_img10    LIKE img_file.img10,       ##異動後數量
     l_imgg10   LIKE imgg_file.imgg10,
     p_uom      LIKE img_file.img09,       ##img 單位
     p_factor   LIKE img_file.img21,     ##轉換率
     u_type     LIKE type_file.num5,    #No.FUN-680121 SMALLINT, ##+1:雜收 -1:雜發  0:報廢
     p_flag     LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
     l_cnt      LIKE type_file.num5,    #No.FUN-680121 SMALLINT
     p_argv1   LIKE type_file.chr1,    #FUN-740187
     l_sfp     RECORD LIKE sfp_file.*, #FUN-740187
     l_sfs     RECORD LIKE sfs_file.*  #FUN-740187
   
  #  CALL s_getima(l_sfs.sfs04) RETURNING l_ima262,l_ima25,l_ima55,l_ima86  #NO.FUN-A20044
     CALL s_getima(l_sfs.sfs04) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86 #NO.FUN-A20044
   
     IF cl_null(p_ware) THEN LET p_ware=' ' END IF
     IF cl_null(p_loca) THEN LET p_loca=' ' END IF
     IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
     IF cl_null(p_qty)  THEN LET p_qty=0    END IF
   
     IF p_uom IS NULL THEN
        CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
     END IF
     SELECT imgg10 INTO l_imgg10 FROM imgg_file
       WHERE imgg01=l_sfs.sfs04 AND imgg02=p_ware
         AND imgg03=p_loca      AND imgg04=p_lot
         AND imgg09=p_uom
      IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
     INITIALIZE g_tlff.* TO NULL
   
     LET g_tlff.tlff01=l_sfs.sfs04         #異動料件編號
     IF p_argv1='1' THEN
        #----來源----
        LET g_tlff.tlff02=50                  #'Stock'
        LET g_tlff.tlff020=g_plant
        LET g_tlff.tlff021=p_ware             #倉庫
        LET g_tlff.tlff022=p_loca             #儲位
        LET g_tlff.tlff023=p_lot              #批號
        LET g_tlff.tlff024=l_imgg10           #異動後數量
        LET g_tlff.tlff025=p_uom              #庫存單位(ima_file or img_file)
        LET g_tlff.tlff026=l_sfs.sfs01        #雜發/報廢單號
        LET g_tlff.tlff027=l_sfs.sfs02        #雜發/報廢項次
        #---目的----
        LET g_tlff.tlff03=60                  #'WIP'
        LET g_tlff.tlff036=l_sfs.sfs03        #WO no
     END IF
     IF p_argv1='2' THEN
        #----來源----
        LET g_tlff.tlff02=60                  #'WIP'
        LET g_tlff.tlff026=l_sfs.sfs03        #WO no
        #---目的----
        LET g_tlff.tlff03=50                  #'Stock'
        LET g_tlff.tlff030=g_plant
        LET g_tlff.tlff031=p_ware             #倉庫
        LET g_tlff.tlff032=p_loca             #儲位
        LET g_tlff.tlff033=p_lot              #批號
   
        LET g_tlff.tlff034=l_imgg10           #異動後數量
        LET g_tlff.tlff035=p_uom             #庫存單位(ima_file or img_file)
        LET g_tlff.tlff036=l_sfs.sfs01        #雜收單號
        LET g_tlff.tlff037=l_sfs.sfs02        #雜收項次
     END IF
     LET g_tlff.tlff04= ' '             #工作站
     LET g_tlff.tlff05=l_sfs.sfs10      #作業序號
     LET g_tlff.tlff06=l_sfp.sfp03      #發料日期
     LET g_tlff.tlff07=g_today          #異動資料產生日期
     LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
     LET g_tlff.tlff09=g_user           #產生人
     LET g_tlff.tlff10=p_qty            #異動數量
     LET g_tlff.tlff11=p_uom      #發料單位
     LET g_tlff.tlff12 =p_factor        #發料/庫存 換算率
     CASE WHEN l_sfp.sfp06='1' LET g_tlff.tlff13='asfi511'       ##成套發料
    WHEN l_sfp.sfp06='2' LET g_tlff.tlff13='asfi512'       ##超領
    WHEN l_sfp.sfp06='3' LET g_tlff.tlff13='asfi513'       ##補料
    WHEN l_sfp.sfp06='4' LET g_tlff.tlff13='asfi514'       ##領料
    WHEN l_sfp.sfp06='6' LET g_tlff.tlff13='asfi526'       ##成套退料
    WHEN l_sfp.sfp06='7' LET g_tlff.tlff13='asfi527'       ##超領退
    WHEN l_sfp.sfp06='8' LET g_tlff.tlff13='asfi528'       ##補料退
    WHEN l_sfp.sfp06='9' LET g_tlff.tlff13='asfi529'       ##領料退
    WHEN l_sfp.sfp06='A' LET g_tlff.tlff13='asri210'       ##ASR發料
    WHEN l_sfp.sfp06='B' LET g_tlff.tlff13='asri220'       ##ASR退料
    WHEN l_sfp.sfp06='C' LET g_tlff.tlff13='asri230'       ##ASR領料
     END CASE
     LET g_tlff.tlff14=''                       #異動原因
     LET g_tlff.tlff17=l_sfs.sfs21              #Remark
     LET g_tlff.tlff19=l_sfp.sfp07            #Dept code
     SELECT sfb27 INTO g_tlff.tlff20 FROM sfb_file WHERE sfb01=l_sfs.sfs03
   
     LET g_tlff.tlff61=p_uom
     LET g_tlff.tlff62=l_sfs.sfs03    #參考單號
     LET g_tlff.tlff930=l_sfs.sfs930  #FUN-670103
     LET g_tlff.tlff27 = l_sfs.sfs27  #FUN-9B0149
     IF cl_null(l_sfs.sfs35) OR l_sfs.sfs35=0 THEN
        CALL s_tlff(p_flag,NULL)
     ELSE
        CALL s_tlff(p_flag,l_sfs.sfs33)
     END IF
  END FUNCTION
   
  FUNCTION i501sub_refresh(p_sfp01)
    DEFINE p_sfp01 LIKE sfp_file.sfp01
    DEFINE l_sfp RECORD LIKE sfp_file.*
   
    SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01=p_sfp01
    RETURN l_sfp.*
  END FUNCTION
   
  FUNCTION i501sub_ind_icd_s2(l_sfp,l_sfs,l_sfb)
    DEFINE l_sfp RECORD LIKE sfp_file.*
    DEFINE l_sfs RECORD LIKE sfs_file.*
    DEFINE l_sfb RECORD LIKE sfb_file.*
    DEFINE l_sfbi RECORD LIKE sfbi_file.*
    DEFINE l_flag   LIKE type_file.num5
    DEFINE l_idc RECORD LIKE idc_file.*
    DEFINE l_sfbiicd18 LIKE sfbi_file.sfbiicd18
    DEFINE l_sfbiicd12 LIKE sfbi_file.sfbiicd12
    DEFINE l_rvv01 LIKE rvv_file.rvv01
    DEFINE l_rvv02 LIKE rvv_file.rvv02
    DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
    DEFINE l_sfsi RECORD LIKE sfsi_file.*   #TQC-B80005
   
    SELECT * INTO l_sfbi.*
      FROM sfbi_file
     WHERE sfbi01=l_sfb.sfb01
   
    #TQC-B80005 --START--
    SELECT * INTO l_sfsi.* FROM sfsi_file
     WHERE sfsi01 = l_sfs.sfs01 AND sfsi02 = l_sfs.sfs02  
    #TQC-B80005 --END-- 
   
   #CASE WHEN l_sfp.sfp06 = '1' #CHI-A70060 mark
    CASE WHEN l_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
        #當產生發料單時，若工單為FT則回寫datecode sfbiicd07,PINCOUNT sfbiicd18,PKG sfbiicd12
        SELECT ecdicd01 INTO l_ecdicd01
        FROM ecd_file
        WHERE ecd01 = l_sfbi.sfbiicd09
        
        IF l_ecdicd01 = '5' THEN
           SELECT * INTO l_idc.*  #串出出庫的idc
             FROM idc_file
            WHERE idc01 = l_sfs.sfs04
        AND idc02 = l_sfs.sfs07
        AND idc03 = l_sfs.sfs08
        AND idc04 = l_sfs.sfs09
               AND idc05 = ' '
               AND idc06 = ' '  
        
           SELECT idd10,idd11 INTO l_rvv01,l_rvv02 #串出IC入庫的單號項次
             FROM idd_file
            WHERE idd01 = l_sfs.sfs04
        AND idd02 = l_sfs.sfs07
        AND idd03 = l_sfs.sfs08
        AND idd04 = l_sfs.sfs09
        AND idd05 = ' '
        AND idd06 = ' '  
        AND idd12 = '6' #IC 入庫
        AND ROWNUM = 1
        
           SELECT sfbiicd18,sfbiicd12 INTO l_sfbiicd18 , l_sfbiicd12
             FROM sfb_file , rvv_file ,sfbi_file
            WHERE sfb01 = rvv36
        AND rvv01 = l_rvv01
        AND rvv02 = l_rvv02
        AND sfbi01= sfb01
         
           IF cl_null(l_sfbi.sfbiicd07) THEN
        UPDATE sfbi_file 
           SET sfbiicd07 = l_idc.idc11
         WHERE sfb01 = l_sfb.sfb01
           END IF
           IF cl_null(l_sfbi.sfbiicd18) THEN
        UPDATE sfbi_file 
           SET sfbiicd18 = l_sfbiicd18
         WHERE sfb01 = l_sfb.sfb01
           END IF
           IF cl_null(l_sfbi.sfbiicd12) THEN
        UPDATE sfbi_file 
           SET sfbiicd12 = l_sfbiicd12
         WHERE sfb01 = l_sfb.sfb01
           END IF
        END IF 
 
       CALL s_icdpost(-1,l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
              l_sfs.sfs09,l_sfs.sfs06,l_sfs.sfs05,
              l_sfs.sfs01,l_sfs.sfs02,l_sfp.sfp02,
              'Y','','',l_sfsi.sfsiicd029,l_sfsi.sfsiicd028,'') #FUN-B30187 #TQC-B80005 #FUN-B80119--傳入p_plant參數''---
        RETURNING l_flag

        IF l_flag = 0 THEN LET g_success = 'N' RETURN END IF
        #複製生產說明(ico_file)
        CALL i501sub_ind_icd_ins_ico(l_sfs.*)
        IF g_success = 'N' THEN RETURN END IF
        #WHEN l_sfp.sfp06 = '6' #CHI-A70060 mark
         WHEN l_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
 
        CALL s_icdpost(1,l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
             l_sfs.sfs09,l_sfs.sfs06,l_sfs.sfs05,
             l_sfs.sfs01,l_sfs.sfs02,l_sfp.sfp02,
             'Y','','',l_sfsi.sfsiicd029,l_sfsi.sfsiicd028,'') #FUN-B30187 #TQC-B80005 #FUN-B80119--傳入p_plant參數''---
        RETURNING l_flag

        IF l_flag = 0 THEN LET g_success = 'N' RETURN END IF
     END CASE
  END FUNCTION
   
  #複製生產說明: 若生產料號作業群組 = '5.FT' , 
  #1.由用發料料號串正背印檔(icl_file) , 複製類別= '0.Logo', '1 正印', '2 背印',
  #  '3 正印備註'及 '4 背印備註', 
  #2.如果用發料料號選取不到, 則用母體料號串正背印檔 ; 
  #若生產資訊檔中有資料註明Date Code否(ico05) ='Y', 則用所挑選批號之Date Code
  #則將備註(ico06)中[DATECODE]字樣置(Date Code:取idc11不為空白的第一筆)
  FUNCTION i501sub_ind_icd_ins_ico(l_sfs)
     DEFINE l_sfbiicd09    LIKE sfbi_file.sfbiicd09,
      l_sfbiicd14    LIKE sfbi_file.sfbiicd14,
      l_ecdicd01     LIKE ecd_file.ecdicd01,
      l_idc11        LIKE idc_file.idc11,
      l_ico          RECORD LIKE ico_file.*,
      l_icl          RECORD LIKE icl_file.*,
      l_sfs          RECORD LIKE sfs_file.*
   
     SELECT sfbiicd09,sfbiicd14 
       INTO l_sfbiicd09,l_sfbiicd14 FROM sfbi_file
      WHERE sfbi01 = l_sfs.sfs03
     IF cl_null(l_sfbiicd09) THEN RETURN END IF
     SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01 = l_sfbiicd09
     IF cl_null(l_ecdicd01) OR l_ecdicd01 <> '5' THEN RETURN END IF
   
     DECLARE idc_cs CURSOR FOR
      SELECT idc11 FROM idc_file
       WHERE idc01 = l_sfs.sfs04 AND idc02 = l_sfs.sfs07
         AND idc03 = l_sfs.sfs08 AND idc04 = l_sfs.sfs09
         AND idc11 IS NOT NULL
   
     LET l_idc11 = ' '
     FOREACH idc_cs INTO l_idc11
         EXIT FOREACH
     END FOREACH
   
     # For aicp050 only : 將所選取之發料料號之Date Code回寫工單(idc的datecode)
     IF g_prog = 'aicp050' THEN  #工單換批
        UPDATE sfbi_file SET sfbiicd07 = l_idc11 WHERE sfbi01 = l_sfs.sfs03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err('UPD sfbiicd07:',SQLCA.sqlcode,1)
     LET g_success = 'N' RETURN
        END IF
     END IF
   
     DECLARE icl_cs1 CURSOR FOR
      SELECT * FROM icl_file
       WHERE icl01 = l_sfs.sfs04
         AND icl02 IN ('0','1','2','3','4')
         AND icl02 NOT IN (SELECT ico03 FROM ico_file
          WHERE ico01 = l_sfs.sfs03
            AND ico02 = 0
            AND ico03 IN ('0','1','2','3','4'))
     FOREACH icl_cs1 INTO l_icl.*
       IF SQLCA.sqlcode THEN
    CALL cl_err('foreach icl_cs1',SQLCA.sqlcode,1)
    LET g_success = 'N'
    RETURN
       END IF
       INITIALIZE l_ico.* TO NULL
       LET l_ico.ico01 = l_sfs.sfs03
       LET l_ico.ico02 = 0
       LET l_ico.ico03 = l_icl.icl02
       LET l_ico.ico04 = l_icl.icl03
       LET l_ico.ico05 = l_icl.icl04
       LET l_ico.ico06 = l_icl.icl05
       LET l_ico.ico07 = NULL
       LET l_ico.icouser = g_user
       LET l_ico.icodate = g_today
       LET l_ico.icomodu = NULL
       LET l_ico.icoacti = 'Y'
       #若生產資訊檔中有資料註明Date Code否(ico05)or (icl04) ='Y',
       #將備註(ico06)中[DATECODE]字樣置(Date Code:取idc11不為空白的第一筆)
       IF l_ico.ico05 = 'Y' THEN
    CALL cl_replace_str(l_ico.ico06,'[DATECODE]',l_idc11)
         RETURNING l_ico.ico06
       END IF
       LET l_ico.icooriu = g_user      #No.FUN-980030 10/01/04
       LET l_ico.icoorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO ico_file VALUES(l_ico.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
    LET g_success = 'N' RETURN
       END IF
     END FOREACH
   
     DECLARE icl_cs2 CURSOR FOR
      SELECT * FROM icl_file
       WHERE icl01 = l_sfbiicd14
         AND icl02 IN ('0','1','2','3','4')
         AND icl02 NOT IN (SELECT ico03 FROM ico_file
             WHERE ico01 = l_sfs.sfs03
               AND ico02 = 0
               AND ico03 IN ('0','1','2','3','4'))
     FOREACH icl_cs2 INTO l_icl.*
       IF SQLCA.sqlcode THEN
    CALL cl_err('foreach icl_cs2',SQLCA.sqlcode,1)
    LET g_success = 'N'
    RETURN
       END IF
       INITIALIZE l_ico.* TO NULL
       LET l_ico.ico01 = l_sfs.sfs03
       LET l_ico.ico02 = 0
       LET l_ico.ico03 = l_icl.icl02
       LET l_ico.ico04 = l_icl.icl03
       LET l_ico.ico05 = l_icl.icl04
       LET l_ico.ico06 = l_icl.icl05
       LET l_ico.ico07 = NULL
       LET l_ico.icouser = g_user
       LET l_ico.icodate = g_today
       LET l_ico.icomodu = NULL
       LET l_ico.icoacti = 'Y'
       #若生產資訊檔中有資料註明Date Code否(ico05)or (icl04) ='Y',
       #將備註(ico06)中[DATECODE]字樣置(Date Code:取idc11不為空白的第一筆)
       IF l_ico.ico05 = 'Y' THEN
    CALL cl_replace_str(l_ico.ico06,'[DATECODE]',l_idc11)
         RETURNING l_ico.ico06
       END IF
       INSERT INTO ico_file VALUES(l_ico.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    CALL cl_err('ins ico_file:',SQLCA.sqlcode,1)
    LET g_success = 'N' RETURN
       END IF
     END FOREACH
  END FUNCTION
   
  #更新生產數量(sfb08) :若生產工單之作業群組=3.DS OR 4.ASS,
  #將若所發之料為已測wafer,已挑選之pass bin之數量回寫至生產工單
  FUNCTION i501sub_ind_icd_upd_sfb08(p_post,l_sfp)
     DEFINE p_post      LIKE type_file.chr1
     DEFINE l_sfs03     LIKE sfs_file.sfs03,
      l_sfs35     LIKE sfs_file.sfs35,
      l_sfb08     LIKE sfb_file.sfb08,
      l_sfbiicd04 LIKE sfbi_file.sfbiicd04,
      l_ecdicd01  LIKE ecd_file.ecdicd01,
      l_qty       LIKE sfb_file.sfb08,
      l_sql       STRING,
      l_msg       STRING,
      l_sfp       RECORD LIKE sfp_file.*
   
     #IF l_sfp.sfp06 NOT MATCHES '[1]' THEN RETURN END IF   #只針對成套發料 #CHI-A70060 mark
     CASE WHEN p_post = 'Y'
         #因為已過帳,所以撈sfe_file
         LET l_sql = "SELECT sfe01,sfe35,sfb08,sfbiicd04,ecdicd01 ",
         "  FROM sfe_file,sfb_file,ecd_file,sfbi_file ",
         " WHERE sfe02 = '",l_sfp.sfp01 CLIPPED,"' ",
         "   AND sfbi01=sfb01 ",
         "   AND sfe01 = sfb01 AND sfbiicd09 = ecd01 ",
         "   AND sfbiicd04 IS NOT NULL AND sfbiicd04 <> 0 ",
         "   AND ecdicd01 IN ('3','4') "
         #因為未過帳,所以撈sfs_file
    WHEN p_post = 'N'
         LET l_sql = "SELECT sfs03,sfs35,sfb08,sfbiicd04,ecdicd01 ",
         "  FROM sfs_file,sfb_file,ecd_file,sfbi_file  ",
         " WHERE sfs01 = '",l_sfp.sfp01 CLIPPED,"' ",
         "   AND sfbi01=sfb01 ",
         "   AND sfs03 = sfb01 AND sfbiicd09 = ecd01 ",
         "   AND sfbiicd04 IS NOT NULL AND sfbiicd04 <> 0 ",
         "   AND ecdicd01 IN ('3','4') "
     END CASE
     PREPARE sfe_pre FROM l_sql
     DECLARE sfe_cs CURSOR FOR sfe_pre
   
     FOREACH sfe_cs INTO l_sfs03,l_sfs35,l_sfb08,l_sfbiicd04,l_ecdicd01
        IF SQLCA.sqlcode THEN CALL cl_err('sfs_cs',SQLCA.sqlcode,0) 
     LET g_success = 'N' EXIT FOREACH 
        END IF
   
        IF cl_null(l_sfs35) THEN
     LET l_sfs35=0
        END IF
        CASE
      WHEN p_post = 'Y'   #過帳
           #若生產數量等於0,直接更新
           #若生產數量不等於0,則生產數量=生產數量+參考數量(sfs35)
           IF cl_null(l_sfb08) OR l_sfb08 = 0 THEN
        LET l_qty = l_sfs35
           ELSE
        LET l_qty = l_sfb08 + l_sfs35
           END IF
      WHEN p_post = 'N'   #過帳還原
           LET l_qty = l_sfb08 - l_sfs35
           IF l_qty < 0 THEN LET l_qty = 0 END IF
        END CASE
        UPDATE sfb_file SET sfb08 = l_qty WHERE sfb01 = l_sfs03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     LET l_msg = 'UPDATE WO:',l_sfs03,' sfb08'
     CALL cl_err(l_msg,SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
        END IF
     END FOREACH
  END FUNCTION
   
FUNCTION i501sub_y_chk(p_sfp01,p_action_choice) #TQC-C60079 add
     DEFINE l_cnt        LIKE type_file.num10   #No.FUN-680121 INTEGER
     DEFINE l_str        STRING                 #No.MOD-8A0088
     DEFINE l_rvbs06     LIKE rvbs_file.rvbs06   #No.FUN-860045
     DEFINE p_sfp01      LIKE sfp_file.sfp01  #FUN-840012
     DEFINE l_sfp RECORD LIKE sfp_file.* #FUN-840012
     DEFINE l_sfs RECORD LIKE sfs_file.* #FUN-840012
     DEFINE l_ima918     LIKE ima_file.ima918
     DEFINE l_ima921     LIKE ima_file.ima921
     DEFINE l_ima930     LIKE ima_file.ima930  #DEV-D30040 add
     DEFINE l_ima108     LIKE ima_file.ima108  #MOD-A40047 add
     DEFINE l_img09      LIKE img_file.img09
     DEFINE l_r          LIKE type_file.chr1   #No.FUN-860045
     DEFINE l_fac        LIKE img_file.img34   #No.FUN-860045
     DEFINE l_sfa07      LIKE sfa_file.sfa07   #No.MOD-8A0088 
     DEFINE l_sfa05      LIKE sfa_file.sfa05  #TQC-980097
     DEFINE l_sfa06      LIKE sfa_file.sfa06  #TQC-980097
     DEFINE l_sfa05_1    LIKE sfa_file.sfa05   #TQC-980097
     DEFINE l_sfa06_1    LIKE sfa_file.sfa06   #TQC-980097
     DEFINE l_sfs05      LIKE sfs_file.sfs05   #No:CHI-B50041 add
     DEFINE l_sfa28      LIKE sfa_file.sfa28   #No:CHI-B50041 add
     DEFINE l_sfa11      LIKE sfa_file.sfa11  #TQC-B60001 add
     DEFINE l_ime12      LIKE ime_file.ime12  #FUN-9A0068
     DEFINE l_sfp06      LIKE sfp_file.sfp06
     DEFINE g_rvbs00     LIKE rvbs_file.rvbs00
     DEFINE l_str1       STRING
     DEFINE l_str2       STRING
     DEFINE l_gem01      LIKE gem_file.gem01   #TQC-C60207
     DEFINE l_pmc01      LIKE pmc_file.pmc01   #TQC-C60207

   #FUN-A40022--begin--add----------
#  DEFINE l_imaicd13   LIKE imaicd_file.imaicd13  #FUN-BA0050
   DEFINE l_sfe16a     LIKE sfe_file.sfe16
   DEFINE l_sfe16b     LIKE sfe_file.sfe16
   DEFINE l_sfe16c     LIKE sfe_file.sfe16
   #FUN-A40022--end--add--------------
   DEFINE l_ima159     LIKE ima_file.ima159       #FUN-BA0050
   
   #TQC-A50122--begin--add----------
   DEFINE l_sfs03a     LIKE sfs_file.sfs03
   DEFINE l_sfs04a     LIKE sfs_file.sfs04
   DEFINE l_sfs05a     LIKE sfs_file.sfs05
   DEFINE l_sfs27a     LIKE sfs_file.sfs27
   DEFINE l_sfs06a     LIKE sfs_file.sfs06
   DEFINE l_sfs10a     LIKE sfs_file.sfs10
   DEFINE l_sfa05a     LIKE sfa_file.sfa05
   DEFINE l_sfa06a     LIKE sfa_file.sfa06
   DEFINE l_sfs012     LIKE sfs_file.sfs012 #TQC-B30039
   DEFINE l_sfs013     LIKE sfs_file.sfs013 #TQC-B30039
   #TQC-A50122--end--add--------------
   DEFINE l_sfq02      LIKE sfq_file.sfq02   #MOD-C10100
   DEFINE l_rvbs09     LIKE rvbs_file.rvbs09 #TQC-B90236 add
   DEFINE p_action_choice STRING             #CHI-C30106---add

  #CHI-C30106---add---S
   IF NOT cl_null(p_action_choice) THEN
      IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
         p_action_choice CLIPPED = "insert"
      THEN
          SELECT * INTO l_sfp.* FROM sfp_file
                               WHERE sfp01=p_sfp01
         IF l_sfp.sfpmksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
            IF l_sfp.sfp15 != '1' THEN
               CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
               LET g_success = 'N'
               #RETURN l_sfp.*  #TQC-C70085 mark
               RETURN           #TQC-C70085 add
            END IF
         END IF
         IF NOT cl_confirm('axm-108') THEN
            LET g_success = 'N'
            #RETURN l_sfp.*  #TQC-C70085 mark
            RETURN           #TQC-C70085 add
         END IF
      END IF
     #FUN-AB0001 add end --------
   END IF
  #CHI-C30106---add---E

     LET g_success = 'Y'
   
     LET l_str2 = g_prog
     LET l_str1 = l_str2.subString(1,6)
     IF l_str1 = 'asfi51' THEN
        IF g_prog = 'asfi510' THEN
           SELECT sfp06 INTO l_sfp06 FROM sfp_file
            WHERE sfp01 = p_sfp01
           IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF
           IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF
           IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF
           IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF
           IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF   #FUN-C70014
        ELSE
           LET g_rvbs00 = g_prog
        END IF
     END IF
     IF l_str1 = 'asfi52' THEN
        IF g_prog = 'asfi520' THEN
          SELECT sfp06 INTO l_sfp06 FROM sfp_file
           WHERE sfp01 = p_sfp01
          IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi526' END IF
          IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi527' END IF
          IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi528' END IF
          IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi529' END IF
        ELSE
          LET g_rvbs00 = g_prog
        END IF
     END IF
     IF cl_null(p_sfp01) THEN 
        CALL cl_err('',-400,0) 
        LET g_success = 'N'
        RETURN 
     END IF
   
     SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
     IF l_sfp.sfpconf='Y' THEN
        LET g_success = 'N'           
        CALL cl_err('','9023',0)      
        RETURN
     END IF

     #MOD-D30209---begin
     SELECT COUNT(*) INTO l_cnt
       FROM sfs_file
      WHERE sfs01 = p_sfp01
     IF l_cnt = 0 THEN
        LET g_success = 'N'           
        CALL cl_err('','asf-348',0)      
        RETURN
     END IF 
     #MOD-D30209---end
   
     IF l_sfp.sfpconf = 'X' THEN
        LET g_success = 'N'   
        CALL cl_err(' ','9024',0)
        RETURN
     END IF
     SELECT COUNT(*) INTO l_cnt FROM sfp_file
        WHERE sfp01= p_sfp01
     IF l_cnt = 0 THEN
        LET g_success = 'N'
        CALL cl_err('','mfg-009',0)
        RETURN
     END IF

#TQC-C60207 ----------------Begin---------------
     IF NOT cl_null(l_sfp.sfp07) THEN
        SELECT gem01 INTO l_gem01 FROM gem_file
         WHERE gem01 = l_sfp.sfp07
           AND gemacti = 'Y'
        IF STATUS THEN
           SELECT pmc01 INTO l_pmc01 FROM pmc_file
            WHERE pmc01 = l_sfp.sfp07
              AND pmcacti = 'Y'
           IF STATUS THEN
              LET g_success = 'N'
              CALL cl_err(l_sfp.sfp07,'asf-683',0)
              RETURN
           END IF
        END IF
     END IF
#TQC-C60207 ----------------End-----------------

#MOD-C10100 --begin--
  IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN

     #sfq_file的工單一定要存在sfs_file裡
      LET l_sfq02=NULL
      DECLARE i501_chk_sfq02 CURSOR FOR
      SELECT sfq02 FROM sfq_file
       WHERE sfq02 NOT IN (SELECT sfs03 FROM sfs_file WHERE sfs01=l_sfp.sfp01)
         AND sfq01=l_sfp.sfp01
         AND sfq03 >= 0

      FOREACH i501_chk_sfq02 INTO l_sfq02
        IF STATUS THEN
           LET l_sfq02=NULL
        END IF
        EXIT FOREACH
      END FOREACH

      IF NOT cl_null(l_sfq02) THEN
         CALL cl_err(l_sfq02,'asf-361',0)
         LET g_success='N'
         RETURN
      END IF
   END IF
#MOD-C10100 --end--

     #No.TQC-B80182  --Begin
     #拆件式工单若有入库的时候,要卡一定有发料,至于发多少,不管控
     IF l_sfp.sfp06='6' THEN
        CALL i501sub_disassemble(l_sfp.sfp01,'2')
        IF g_success = 'N' THEN RETURN END IF
     END IF
     #No.TQC-B80182  --End

     #TQC-A50122--begin
     #工單補料時檢查單身相同工單下的相同料件的補料量是否大於欠料量
     IF l_sfp.sfp06='3' OR l_sfp.sfp06='1' THEN 
        DECLARE i501_y_chk_sfs05 CURSOR FOR 
         SELECT sfs03,sfs04,sfs27,sfs06,sfs10,sfs012,sfs013 FROM sfs_file  #TQC-B30039
                WHERE sfs01=p_sfp01
        FOREACH i501_y_chk_sfs05 INTO l_sfs03a,l_sfs04a,l_sfs27a,
                                      l_sfs06a,l_sfs10a,l_sfs012,l_sfs013  #TQC-B30039 
            SELECT SUM(sfs05) INTO l_sfs05a FROM sfs_file,sfp_file                                                                                                                  
             WHERE sfs03=l_sfs03a                                                                                                                                          
               AND sfs04=l_sfs04a                                                                                                                                                
               AND sfs27=l_sfs27a   
               AND sfs06=l_sfs06a                                                                                                                                         
               AND sfs10=l_sfs10a                                                                                                                                               
               AND sfs012=l_sfs012  #TQC-B30039
               AND sfs013=l_sfs013  #TQC-B30039
               AND sfs01 = p_sfp01                                                                                                                                                                           
               AND sfp01=sfs01 AND sfpconf !='X'  
           #SELECT sum(sfa05),sum(sfa06) INTO l_sfa05a,l_sfa06a FROM sfa_file WHERE sfa01=l_sfs03a AND sfa03=l_sfs04a #FUN-B20070  #MOD-C90067 mark
           #MOD-C90067---S---
            SELECT sum(sfa05),sum(sfa06) INTO l_sfa05a,l_sfa06a
              FROM sfa_file
             WHERE sfa01=l_sfs03a
               AND sfa03=l_sfs04a
               AND sfa27=l_sfs27a
           #MOD-C90067---E---            

            IF l_sfs05a >l_sfa05a-l_sfa06a THEN                                                                                                                                                
               CALL cl_err(l_sfs04a CLIPPED,'asf-351',0) 
               LET g_success='N' 
               EXIT FOREACH 
            END IF 
        END FOREACH   
        IF g_success = 'N' THEN RETURN END IF
     END IF 
     #TQC-A50122--end      

     LET g_mescnt = 1            #FUN-C10035 add

     #Cehck 單身 料倉儲批是否存在 img_file
     DECLARE i501_y_chk_c CURSOR FOR SELECT * FROM sfs_file
                                      WHERE sfs01=p_sfp01
     FOREACH i501_y_chk_c INTO l_sfs.*

       #FUN-C10035 add str -----
       #當與MES整合,檢查此張發料單的工單是否有混雜:與MES整合工單及不與MES整合的工單
       #與MES整合:工單型態(sfb02)= 1 or 13
        IF g_aza.aza90 MATCHES "[Yy]" THEN
           CALL i501_sub_chk_sfb01(l_sfs.sfs03,g_mescnt)
           IF g_mesflag <> g_mesflag_t THEN          #本張工單的整合類型與上張工單不符
              CALL cl_err('','asf-146',1)            #與MES整合時,發料單內的工單型態需一致
              LET g_success = "N"
              EXIT FOREACH
           END IF
           LET g_mescnt = g_mescnt + 1
        END IF
       #FUN-C10035 add end -----

       #MOD-AC0409---add---start---
        IF NOT s_chksmz(l_sfs.sfs04, p_sfp01,
                        l_sfs.sfs07, l_sfs.sfs08) THEN
           LET g_success = "N"
           EXIT FOREACH
        END IF
       #MOD-AC0409---add---end---
        #Add No.FUN-AB0054
        IF NOT s_chk_ware(l_sfs.sfs07) THEN  #检查仓库是否属于当前门店
           LET g_success = "N"
           EXIT FOREACH
        END IF
        #End Add No.FUN-AB0054

        #FUN-CB0087--add--str--
        IF g_aza.aza115='Y' AND cl_null(l_sfs.sfs37) THEN
           CALL cl_err('','aim-888',1)
           LET g_success = "N"
           EXIT FOREACH
        END IF 
        #FUN-CB0087--add--end--
        #FUN-A40022--begin--add------------
#       IF s_industry('icd') THEN      #FUN-BA0050 mark
#       IF l_sfp.sfp06 MATCHES '[6789B]' AND cl_null(l_sfs.sfs09)  #FUN-BA0050
#          AND NOT cl_null(l_sfs.sfs04)                            #FUN-BA0050
#         THEN                                                     #FUN-BA0050
        IF cl_null(l_sfs.sfs09) AND NOT cl_null(l_sfs.sfs04) THEN  #FUN-BA0050
        #FUN-BA0050 --------------Begin-------------------
        #        LET l_imaicd13 = ''
        #        SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
        #         WHERE imaicd00= l_sfs.sfs04 
        #        IF l_imaicd13 = 'Y' THEN
           LET l_ima159 = ''
           SELECT ima159 INTO l_ima159 FROM ima_file
            WHERE ima01 = l_sfs.sfs04
      #str----mark by guanyao160714
      #     IF l_ima159 = '1' THEN
      #  #FUN-BA0050 --------------End---------------------
      #        LET g_success = 'N' 
      #        CALL cl_err(l_sfs.sfs04,'aim-034',1)
      #        CONTINUE FOREACH
      #     END IF
      #end----mark by guanyao160714
        END IF
        IF s_industry('icd') THEN   #FUN-BA0050 add
           IF l_sfp.sfp06 MATCHES '[6789B]' THEN
              LET l_cnt = 0
              
              SELECT COUNT(*) INTO l_cnt
                FROM sfe_file,sfp_file
               WHERE sfe02 = sfp01
                 AND sfp06 IN ('1','2','3','4','A')
                 AND sfp04 = 'Y'
                 AND sfe01 = l_sfs.sfs03
                 AND sfe07 = l_sfs.sfs04
              IF l_cnt > 0 AND l_sfs.sfs09 <> 'X' THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfe_file,sfp_file
                  WHERE sfe02 = sfp01
                    AND sfp06 IN ('1','2','3','4','A')
                    AND sfp04 = 'Y'
                    AND sfe01 = l_sfs.sfs03
                    AND sfe07 = l_sfs.sfs04
                    AND sfe10 = l_sfs.sfs09
                 IF cl_null(l_cnt) OR l_cnt = 0 THEN
                    LET g_success = 'N' 
                   #CALL cl_err(l_sfs.sfs04,'TSD0020',1)         #MOD-B10096 mark  
                    CALL cl_err(l_sfs.sfs04,'asf-171',1)         #MOD-B10096 add 
                    CONTINUE FOREACH
                 END IF
              END IF

              IF l_sfp.sfp06 MATCHES '[6789B]' AND
                 NOT cl_null(l_sfs.sfs09) AND 
                 NOT cl_null(l_sfs.sfs04) 
              THEN
                #此批號已發數量
                 LET l_sfe16a = 0
                 SELECT SUM(sfe16) INTO l_sfe16a  
                   FROM sfe_file,sfp_file
                  WHERE sfe01 = l_sfs.sfs03
                    AND sfe07 = l_sfs.sfs04
                    AND sfe10 = l_sfs.sfs09
                    AND sfe02 = sfp01
                    AND sfp06 IN ('1','2','3','4','A')
                 IF cl_null(l_sfe16a) THEN LET l_sfe16a = 0 END IF
                #此批號已退數量
                 LET l_sfe16b = 0
                 SELECT SUM(sfe16) INTO l_sfe16b  
                   FROM sfe_file,sfp_file
                  WHERE sfe01 = l_sfs.sfs03
                    AND sfe07 = l_sfs.sfs04
                    AND sfe10 = l_sfs.sfs09
                    AND sfe02 = sfp01
                    AND sfp06 IN ('6','7','8','9','B')
                 IF cl_null(l_sfe16b) THEN LET l_sfe16b = 0 END IF

                #此張單子退料數量
                 LET l_sfe16c = 0
                 SELECT SUM(sfs05) INTO l_sfe16c  
                   FROM sfs_file
                  WHERE sfs03 = l_sfs.sfs03
                    AND sfs04 = l_sfs.sfs04
                    AND sfs09 = l_sfs.sfs09
                    AND sfs01 = l_sfp.sfp01
                 IF cl_null(l_sfe16c) THEN LET l_sfe16c = 0 END IF

                 LET l_sfe16a = l_sfe16a-l_sfe16b-l_sfe16c
                 IF l_sfe16a < 0 AND l_sfs.sfs09 <> 'X' THEN
                    #數量不可大于該批號于發料單發出批號的數量
                     LET g_success = 'N' 
                    #CALL cl_err(l_sfs.sfs04,'TSD0022',1)      #MOD-B10096 mark  
                     CALL cl_err(l_sfs.sfs04,'aim-037',1)      #MOD-B10096 add 
                     CONTINUE FOREACH
                 END IF
              END IF
           END IF
        END IF
        #FUN-A40022--end--add---------------  

        SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930 
          FROM ima_file
         WHERE ima01 = l_sfs.sfs04
           AND imaacti = "Y"

        IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add
        
        IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
#TQC-B90236   ---beign---add
           IF l_sfp.sfp06 MATCHES '[6789B]' THEN
              LET l_rvbs09 =1 
           ELSE 
              LET l_rvbs09 = -1
           END IF 
#TQC-B90236   ---end---
           SELECT SUM(rvbs06) INTO l_rvbs06
             FROM rvbs_file
            WHERE rvbs00 = g_rvbs00  #TQC-9C0174
              AND rvbs01 = l_sfs.sfs01
              AND rvbs02 = l_sfs.sfs02
             #AND rvbs09 = -1          #TQC-B90236  --MARK--
              AND rvbs09 = l_rvbs09    #TQC-B90236  --ADD-- 
              AND rvbs13 = 0
              
           IF cl_null(l_rvbs06) THEN
              LET l_rvbs06 = 0
           END IF
              
           SELECT img09 INTO l_img09
             FROM img_file
            WHERE img01=l_sfs.sfs04
              AND img02=l_sfs.sfs07
              AND img03=l_sfs.sfs08
              AND img04=l_sfs.sfs09
   
           CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_img09) 
                RETURNING l_r,l_fac

           IF l_r = 1 THEN LET l_fac = 1 END IF
   
           IF (l_ima930 = 'Y' and l_rvbs06 <> 0) OR l_ima930 = 'N' THEN  #DEV-D30040
              IF (l_sfs.sfs05 * l_fac) <> l_rvbs06 THEN
                 LET g_success = "N"
                 CALL cl_err(l_sfs.sfs04,"aim-011",1)
                 EXIT FOREACH
              END IF
           END IF                                                        #DEV-D30040
        END IF
        
       #str MOD-A40047 add
        #若為SMT料則倉庫需為WIP倉
        SELECT ima108 INTO l_ima108 FROM ima_file
         WHERE ima01=l_sfs.sfs04
        IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM imd_file
            WHERE imd01=l_sfs.sfs07 AND imd10='W'
              AND imdacti = 'Y'
           LET g_showmsg = l_sfs.sfs04,"/",l_sfs.sfs07  #MOD-AB0026 add
           IF l_cnt = 0 THEN
              LET g_success = "N"
              CALL cl_err(g_showmsg,'asf-724',1)
              EXIT FOREACH
           END IF
        END IF
       #end MOD-A40047 add

# MOD-D60189 ------- mark ---------- begin
        #TQC-AB0301--begin--add---- 
#       IF l_sfs.sfs05 = 0 THEN
#          LET g_success = "N"
#          CALL cl_err(l_sfs.sfs04,'asf-153',1)
#          EXIT FOREACH
#       END IF
        #TQC-AB0301--end--add----
# MOD-D60189 ------- mark ---------- end
#str------mark by guanyao160714
#        IF l_sfp.sfp06 NOT MATCHES '[6789B]' THEN  #MOD-DB0006
#           LET l_cnt=0
#           SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=l_sfs.sfs04
#              #AND img02=l_sfs.sfs07
#              AND img02=l_sfs.sfsud02
#              AND img03=l_sfs.sfs08
#              AND img04=l_sfs.sfs09
#           IF l_cnt=0 THEN
#              SELECT ime12  INTO l_ime12 FROM imd_file,ime_file
#               WHERE imd01 = ime01
#                 AND imd01 = l_sfs.sfs07
#                 AND ime02 = l_sfs.sfs08
#                 AND imeacti = 'Y'    #FUN-D40103
#              IF l_ime12 = '2' THEN 
#              ELSE       
#                 LET g_success='N'
#                 LET l_str = l_sfs.sfs02,' - ',l_sfs.sfs04   #No.MOD-830099 add
#                 CALL cl_err(l_str,'asf-507',1)              #No.MOD-830099 modify
#              END IF                                       #No.FUN-9A0068
#              EXIT FOREACH
#           END IF
#        END IF #MOD-DB0006
#end------mark by guanyao160714
        LET l_sfa05_1 = NULL         #MOD-B20080 add
        LET l_sfa06_1 = NULL         #MOD-B20080 add
        SELECT sfa05,sfa06,sfa28,sfa11 into l_sfa05,l_sfa06,l_sfa28,l_sfa11 FROM sfa_file  #FUN-B50059 #TQC-B60001 add sfa11  #No:CHI-B50041  add sfa28
         WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs04
           AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
           AND sfa27 = l_sfs.sfs27  #FUN-9B0149 
           AND sfa012= l_sfs.sfs012   #FUN-A60028
           AND sfa013= l_sfs.sfs013   #FUN-A60028
               AND sfa27=l_sfs.sfs27   #MOD-A40164 add
     #------------No:CHI-B50041  add
         IF l_sfp.sfp06 MATCHES '[13]' THEN
         #取替代料控管
            IF l_sfs.sfs26 MATCHES '[US]' AND g_sma.sma107 = 'Y' THEN        
               SELECT SUM(sfa05/sfa28),SUM(sfa06/sfa28) into l_sfa05_1,l_sfa06_1 FROM sfa_file
               WHERE sfa01=l_sfs.sfs03 AND sfa27=l_sfs.sfs27
               AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
             
               IF cl_null(l_sfa05_1) THEN LET l_sfa05_1 = 0 END IF
               IF cl_null(l_sfa06_1) THEN LET l_sfa06_1 = 0 END IF
               IF l_sfa05_1 - l_sfa06_1 < l_sfs.sfs05/l_sfa28 THEN
                  CALL cl_err(l_sfs.sfs04,'asf-351',1) 
                  LET g_success='N'
                  EXIT FOREACH     
               END IF 
             ELSE
         #------------No:CHI-B50041  end
       #IF l_sfp.sfp06 MATCHES '[134]' AND         #MOD-A80053 mark
        #-----------No:CHI-B50041 modify
        #IF l_sfp.sfp06 MATCHES '[13]' AND          #MOD-A80053 add
        #   l_sfa05-l_sfa06 < l_sfs.sfs05 THEN
               IF l_sfa05_1-l_sfa06_1 < l_sfs.sfs05 THEN 
            #-----------No:CHI-B50041 end
                  CALL cl_err(l_sfs.sfs04,'asf-351',1) 
                  LET g_success='N'
                  EXIT FOREACH     
               END IF
            END IF                                    #No:CHI-B50041  add
         END IF                                       #No:CHI-B50041  add
        #TQC-B60001 add
        IF l_sfp.sfp06='6' AND l_sfa11<>'S' THEN  #成套退料
           IF l_sfs.sfs05 >l_sfa06 THEN
              CALL cl_err(l_sfs.sfs05,"abm-010",1)
              LET g_success='N'
              EXIT FOREACH     
           END IF
        END IF
        #TQC-B60001 add--end
        IF g_prog = 'asfi513' THEN
           IF cl_null(l_sfs.sfs012) THEN LET l_sfs.sfs012=' ' END IF   #FUN-A50066 add
           IF cl_null(l_sfs.sfs013) THEN LET l_sfs.sfs013=0   END IF   #FUN-A50066 add
           CALL s_shortqty(l_sfs.sfs03,l_sfs.sfs04,l_sfs.sfs10,
                           l_sfs.sfs06,l_sfs.sfs27,
                           l_sfs.sfs012,l_sfs.sfs013)   #FUN-A50066 add
                RETURNING  l_sfa07
           IF cl_null(l_sfa07) THEN LET l_sfa07 = 0 END IF
           IF l_sfs.sfs05 > l_sfa07 THEN
              LET l_str = ''
              LET l_str = l_sfs.sfs03,' -',l_sfs.sfs04,' -',l_sfs.sfs05,'>',l_sfa07,'\n'
              CALL cl_err(l_str,'asf-987',1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END IF

        IF g_prog='asfi511' THEN                                                                                                      
           LET l_cnt=0                                                                                                                
           SELECT COUNT(*) INTO l_cnt FROM sfq_file                                                                                   
            WHERE sfq01=p_sfp01                                                                                                       
              AND sfq02=l_sfs.sfs03                                                                                                   
           IF l_cnt=0 THEN                                                                                                            
              LET l_str=l_sfs.sfs03                                                                                                   
              CALL cl_err(l_str,'asf-000',1)                                                                                          
              LET g_success='N'                                                                                                       
              EXIT FOREACH                                                                                                            
           END IF                                                                                                                     
        END IF                                                                                                                        
     END FOREACH
     #add by donghy 161106 增加管控：第一单身作业编号不能为空;
     IF g_prog='asfi511' OR g_prog='asfi513' OR g_prog='asfi526' THEN
        SELECT COUNT(*) INTO l_cnt FROM sfq_file,sfb_file                                                                                   
        WHERE sfq01=p_sfp01 AND (sfq04 IS NULL OR sfq04 =' ' OR sfq04 = '')
        AND sfq02 = sfb01 AND sfb02 <>'5'
        
        IF l_cnt > 0 THEN
           CALL cl_err(l_str,'csf-519',1)  
           LET g_success='N'           
        END IF
     END IF
     IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION i501sub_y_upd(p_sfp01,p_action_choice,p_inTransaction)  
   DEFINE l_forupd_sql    STRING
   DEFINE p_sfp01         LIKE sfp_file.sfp01
  #DEFINE p_action_choice LIKE type_file.chr1         #FUN-AB0001 mark
   DEFINE p_action_choice STRING                      #FUN-AB0001 add
   DEFINE l_sfp    RECORD LIKE sfp_file.*
   DEFINE p_inTransaction LIKE type_file.num5
   #str-----add by guanyao160804
   DEFINE l_sql           STRING
   DEFINE l_img10         LIKE img_file.img10
   DEFINE l_sfs02         LIKE sfs_file.sfs02
   DEFINE l_sfs04         LIKE sfs_file.sfs04
   DEFINE l_sfs05         LIKE sfs_file.sfs05
   DEFINE l_sfsud07       LIKE sfs_file.sfsud07
   #end-----add by guanyao160804
 
   LET g_success = 'Y'                                #FUN-AB0001 add

  #CHI-C30106---mark---S
  #IF NOT cl_null(p_action_choice) THEN
  #  #FUN-AB0001 mark str ------
  #  #IF NOT cl_confirm('axm-108') THEN 
  #  #   SELECT * INTO l_sfp.* FROM sfp_file
  #  #                        WHERE sfp01=p_sfp01
  #  #   RETURN l_sfp.* 
  #  #END IF
  #  #FUN-AB0001 mark end ------
  #  #FUN-AB0001 add str -------
  #   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
  #      p_action_choice CLIPPED = "insert"
  #   THEN
  #       SELECT * INTO l_sfp.* FROM sfp_file
  #                            WHERE sfp01=p_sfp01
  #      IF l_sfp.sfpmksg='Y' THEN #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
  #         IF l_sfp.sfp15 != '1' THEN
  #            CALL cl_err('','aws-078',1) #此狀況碼不為「1.已核准」，不可確認!!
  #            LET g_success = 'N'
  #            RETURN l_sfp.*
  #         END IF
  #      END IF
  #      IF NOT cl_confirm('axm-108') THEN
  #         LET g_success = 'N'
  #         RETURN l_sfp.*
  #      END IF
  #   END IF
  #  #FUN-AB0001 add end --------
  #END IF
  #CHI-C30106---mark---E
   #str------add by guanyao160804  #过账前判断批号是否是实发数量的一半
   #CALL s_showmsg_init()
   #LET l_sql = "SELECT sfs02,sfs04,sfs05,sfsud07 FROM sfs_file WHERE sfs01 = '",p_sfp01,"'"
   #PREPARE i501_sfsud07_pre FROM l_sql                                                                                               
   #DECLARE i501_sfsud07_cur CURSOR FOR i501_sfsud07_pre 
   #LET l_sfs02 = ''
   #LET l_sfs04 = ''
   #LET l_sfs05 = ''
   #LET l_sfsud07 = ''
   #FOREACH i501_sfsud07_cur INTO l_sfs02,l_sfs04,l_sfs05,l_sfsud07
   #   LET l_img10 = 0
   #   SELECT SUM(img10) INTO l_img10 FROM img_file WHERE img01 = l_sfs04 AND img02 = 'XBC'
   #   IF cl_null(l_img10) THEN LET l_img10 = 0 END IF 
   #   #SELECT ima64 INTO l_ima64 FROM ima_file WHERE ima01=l_sfs04
   #   IF l_sfsud07 < (l_sfs05/2) THEN 
   #      CONTINUE FOREACH 
   #   ELSE 
   #      CALL s_errmsg('sfs02,sfs04',l_sfs02,'','csf-063',1)
   #      LET g_success = 'N' 
   #      CONTINUE FOREACH 
   #   END IF 
   #END FOREACH   
   #IF g_success = 'N' THEN 
   #   CALL s_showmsg()
   #   RETURN 
   #END IF 
   #end------add by guanyao160804

   LET g_success = 'Y'
 
   IF NOT p_inTransaction THEN #FUN-840012
      BEGIN WORK
   END IF
 
   LET g_forupd_sql = "SELECT * FROM sfp_file WHERE sfp01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i501sub_upd_cl CURSOR FROM g_forupd_sql
 
   OPEN i501sub_upd_cl USING p_sfp01
   IF STATUS THEN
      CALL cl_err("OPEN i501sub_upd_cl:", STATUS, 1)
      CLOSE i501sub_upd_cl
      IF NOT p_inTransaction THEN #FUN-840012
         ROLLBACK WORK
      END IF
      RETURN l_sfp.*
   END IF
 
   FETCH i501sub_upd_cl INTO l_sfp.*     # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i501sub_upd_cl 
       ROLLBACK WORK 
       RETURN l_sfp.*
   END IF
   CLOSE i501sub_upd_cl

   UPDATE sfp_file 
      SET sfpconf = 'Y'
         ,sfp15 = '1'                    #FUN-AB0001 add 
    WHERE sfp01 = l_sfp.sfp01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfpconf",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF

  #FUN-AB0001---mark--str---
  #IF g_success='Y' THEN
  #   IF NOT p_inTransaction THEN #FUN-840012
  #      COMMIT WORK
  #   END IF
  #   LET l_sfp.sfpconf='Y'
  #   CALL cl_flow_notify(l_sfp.sfp01,'Y')
  #ELSE
  #   ROLLBACK WORK
  #   LET l_sfp.sfpconf='N'
  #END IF
  #FUN-AB0001---mark--end---

   #FUN-AB0001---add---str---
   IF g_success='Y' THEN
      IF NOT p_inTransaction THEN #FUN-840012
         IF l_sfp.sfpmksg = 'Y' AND l_sfp.sfpconf = 'N' THEN  #簽核模式
            CASE aws_efapp_formapproval()                     #呼叫 EF 簽核功能
                 WHEN 0  #呼叫 EasyFlow 簽核失敗
                      LET l_sfp.sfpconf="N"
                      LET g_success = "N"
                      ROLLBACK WORK
                      RETURN l_sfp.*
                 WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                      LET l_sfp.sfpconf="N"
                      ROLLBACK WORK
                      RETURN l_sfp.*
            END CASE
         END IF
         IF g_success='Y' THEN
            LET l_sfp.sfp15='1'                #執行成功, 狀態值顯示為 '1' 已核准
            LET l_sfp.sfpconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
            COMMIT WORK
            CALL cl_flow_notify(l_sfp.sfp01,'Y')
         ELSE
            LET l_sfp.sfpconf='N'
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      ELSE
         LET l_sfp.sfpconf='Y'
         LET l_sfp.sfp15='1'                   #執行成功, 狀態值顯示為 '1' 已核准 
         CALL cl_flow_notify(l_sfp.sfp01,'Y')
      END IF
   ELSE
      ROLLBACK WORK
      LET l_sfp.sfpconf='N'
   END IF
   #FUN-AB0001---add---end---

   RETURN l_sfp.*
END FUNCTION
 
#FUNCTION i501sub_qty(p_cmd,p_sfb)            #FUN-C70037  mark
#FUNCTION i501sub_qty(p_cmd,p_sfp03,p_sfb)    #FUN-C70037  #FUN-C90077 mark
FUNCTION i501sub_qty(p_cmd,p_sfs,p_sfp03,p_sfp06,p_sfb)    #FUN-C90077
  DEFINE  p_sfb       RECORD LIKE sfb_file.*
  DEFINE  p_cmd       LIKE type_file.chr1 
  DEFINE  l_cnt       LIKE type_file.num5  
  DEFINE  l_min_set   LIKE sfq_file.sfq03
  DEFINE  l_qty       LIKE sfv_file.sfv09     
  DEFINE  l_ecm315    LIKE ecm_file.ecm315    #MOD-C80038 add
  DEFINE  l_ima153    LIKE ima_file.ima153   #FUN-910053 
  DEFINE  l_shb06     LIKE shb_file.shb06    #FUN-960037
  DEFINE  p_sfp03     LIKE sfp_file.sfp03    #FUN-C70037 
  DEFINE  p_sfp06     LIKE sfp_file.sfp06    #FUN-C70037
  DEFINE  p_sfp01     LIKE sfp_file.sfp01    #FUN-C90077
  DEFINE  l_sfe16     LIKE sfe_file.sfe16    #FUN-C90077
  DEFINE  l_sfe16_1   LIKE sfe_file.sfe16    #FUN-C90077
  DEFINE  l_year      LIKE azn_file.azn02    #FUN-C90077 add # 年度
  DEFINE  l_month     LIKE azn_file.azn04    #FUN-C90077 add # 期別
  DEFINE  l_totsfs05  LIKE sfs_file.sfs05    #FUN-C90077
  DEFINE  p_sfs       RECORD LIKE sfs_file.* #FUN-C90077
  DEFINE  l_sql       STRING                 #FUN-C90077
  DEFINE  l_qty_temp  LIKE sfe_file.sfe16    #FUN-C90077
  DEFINE  l_qty_chk   LIKE sfe_file.sfe16    #FUN-C90077
  DEFINE  l_min_qty   LIKE sfe_file.sfe16    #FUN-C90077 
  DEFINE  l_sfe       RECORD LIKE sfe_file.* #FUN-C90077
  DEFINE  l_sfa       RECORD LIKE sfa_file.* #FUN-C90077
  DEFINE  l_sfe16_new LIKE sfe_file.sfe16    #TQC-C90111 
 
  IF p_sfb.sfb39 != '2' THEN
       #工單完工方式為'2' pull 不check min_set
        LET l_min_set = 0 
        LET l_qty = 0 
        CALL s_get_ima153(p_sfb.sfb05) RETURNING l_ima153  #FUN-910053  
  #     CALL s_minp(p_sfb.sfb01,g_sma.sma73,l_ima153,'','','')    #FUN-910053   #FUN-A60028 add 2'' by vealxu  #FUN-C70037 mark
  #      IF p_sfb.sfbud05='Y' THEN LET g_sma.sma73='N'  END IF  #tianry add end   161221
        CALL s_minp(p_sfb.sfb01,g_sma.sma73,l_ima153,'','','',p_sfp03)          #FUN-C70037 
                    RETURNING l_cnt,l_min_set
        IF l_cnt !=0  THEN
           CALL cl_err(p_sfb.sfb01,'asf-549',1)
           LET g_success = 'N'
           RETURN
        END IF

        IF p_sfb.sfb94 = 'Y' THEN
           SELECT SUM(qcf091) INTO l_qty FROM qcf_file
                        WHERE qcf02 = p_sfb.sfb01
                          AND qcf14 = 'Y'
                          AND (qcf09 = '1' OR qcf09 = '3')
 
        ELSE
           IF p_sfb.sfb02='7' OR p_sfb.sfb02='8' THEN
              CASE p_sfb.sfb04
              WHEN '6'  #委外收貨
              SELECT SUM(rvb07-rvb29) INTO l_qty FROM rvb_file,rva_file  #MOD-910049 add -rvb29
                          WHERE rvb34 = p_sfb.sfb01
                            AND rvb01 = rva01
                            AND rvb05 = p_sfb.sfb05  #MOD-920284 add  #代買料情況
                            AND rvaconf != 'X'
              WHEN '7'  #委外入庫
              SELECT SUM(rvb07-rvb29) INTO l_qty FROM rvb_file,rva_file  #MOD-910049 add -rvb29
                          WHERE rvb34 = p_sfb.sfb01
                            AND rvb01 = rva01
                            AND rvb05 = p_sfb.sfb05  #MOD-920284 add  #代買料情況
                            AND rvaconf != 'X'
              OTHERWISE
              END CASE 
           ELSE
              SELECT SUM(sfv09) INTO l_qty FROM sfv_file,sfu_file 
                      WHERE sfv11 = p_sfb.sfb01
                        AND sfv01 = sfu01
                        AND sfuconf != 'X'
           END IF 
        END IF
        IF cl_null(l_qty) THEN LET l_qty = 0 END IF 
        LET l_ecm315 = 0                                                         #MOD-C80038 add
        SELECT SUM(ecm315) INTO l_ecm315 FROM ecm_file WHERE ecm01=p_sfb.sfb01   #MOD-C80038 add
        IF cl_null(l_ecm315) THEN LET l_ecm315 = 0 END IF                        #MOD-C80038 add
#        LET l_min_set = l_min_set - l_qty              #FUN-960037 --- mark
#          IF l_min_set < 0 THEN                        #FUN-960037 --- mark
         #IF (l_min_set - l_qty) < 0 THEN               #FUN-960037 --- add   #MOD-C80038 mark
          IF (l_min_set - l_qty + l_ecm315) < 0 THEN                          #MOD-C80038 add 
             IF p_cmd = 's' THEN 
                CALL cl_err(p_sfb.sfb01,'asf-871',1)
             ELSE 
                CALL cl_err(p_sfb.sfb01,'asf-870',1)
             END IF
             LET g_success="N"
             RETURN
          END IF 


   #FUN-960037 -------add begin
   #檢查不可少於一般工單報工的量
   LET l_qty=0
   SELECT SUM(srg05) INTO l_qty FROM srg_file,srf_file
                     WHERE srf01=srg01 AND srfconf='Y' 
                     AND srg16=p_sfb.sfb01
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
   IF cl_null(g_sfa11) THEN LET g_sfa11 = ' ' END IF #MOD-C10171
   #IF (l_min_set - l_qty) < 0 THEN   #MOD-C10171 mark
   #str-----mark by guanyao160819
   --IF (l_min_set - l_qty) < 0 AND g_sfa11 <> 'E' AND g_sfa11 <> 'S' THEN  #MOD-C10171
     --IF p_cmd = 's' THEN 
        --CALL cl_err(p_sfb.sfb01,'asf-879',1)  #asf-879:該筆資料過帳後,發料套數會小於工單報工數量!
     --ELSE 
        --CALL cl_err(p_sfb.sfb01,'asf-880',1)  #asf-880:該筆資料過帳還原後,發料套數會小於工單報工數量!
     --END IF
     --LET g_success="N"
     --RETURN
   --END IF
   #end-----mark by guanyao160819

   #檢查不可少於製程工單報工的量
   IF g_sma.sma541 ='N' THEN  #FUN-A60028
      LET l_shb06=NULL
      SELECT MIN(shb06) INTO l_shb06 FROM shb_file WHERE shb05 = p_sfb.sfb01
                                                     AND shbconf = 'Y'    #FUN-A70095
      IF (SQLCA.sqlcode = 0) AND l_shb06 IS NOT NULL THEN  #有製程報工資料才檢查
         LET l_qty=0
         SELECT SUM(shb111+shb112+shb113+shb114+shb115+shb17) INTO l_qty
                           FROM shb_file
                          WHERE shb05=p_sfb.sfb01
#MOD-B90008--begin--
#                           AND shb06=l_shb06
                            AND shb081=g_sfs10
#MOD-B90008--end--
                            AND shbconf = 'Y'  #FUN-A70095
         IF cl_null(l_qty) THEN
            LET l_qty = 0
         END IF
        #IF (l_min_set - l_qty) < 0 THEN   #MOD-CC0198 mark
        #str-----mark by guanyao160819  临时取消
         --IF (l_min_set - l_qty) < 0 AND g_sfa11 <> 'E' AND g_sfa11 <> 'S' THEN   #MOD-CC0198 add
           --IF p_cmd = 's' THEN 
              --CALL cl_err(p_sfb.sfb01,'asf-879',1)  #asf-879:該筆資料過帳後,發料套數會小於工單報工數量!
           --ELSE 
              --CALL cl_err(p_sfb.sfb01,'asf-880',1)  #asf-880:該筆資料過帳還原後,發料套數會小於工單報工數量!
           --END IF
           --LET g_success="N"
           --RETURN
         --END IF
         #end----mark by guanyao160819
      END IF
      #FUN-960037 -------add end
      END IF
#FUN-C90077 ----------------Begin----------------
#跨越補單考慮取替代
      LET l_sql= "SELECT sfa_file.*,sfe_file.* ",  #檢查可以用發料套數
                 "  FROM sfe_file,sfa_file ",
                 " WHERE sfe01=sfa01 AND sfe07=sfa03 AND sfe17=sfa12 ",
                 "   AND sfe14=sfa08 AND sfe27=sfa27 AND sfe012 = sfa012 AND sfe013 = sfa013 ",
                 "   AND sfe01 = '", p_sfs.sfs03 ,"' AND sfe27 = ? ",
                 "   AND sfe07 = ? ",   
                 "   AND sfa11 NOT IN ('E','S')  ",
                 "   AND sfe06 IN ('1','2','3','4') AND sfe04 > '", p_sfp03 ,"' ",
                 " ORDER BY sfe04 "
      IF g_sma.sma542 = 'Y' AND p_sfb.sfb93 ='Y'
         AND (p_sfs.sfs012 IS NOT NULL OR p_sfs.sfs012 <> '') THEN
         LET l_sql=l_sql CLIPPED," AND sfe012='",p_sfs.sfs012,"' ",
                                 " AND sfe013='",p_sfs.sfs013,"' "
      ELSE
         IF p_sfs.sfs10 IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED," AND sfe14='",p_sfs.sfs10,"' "
         END IF
      END IF
      PREPARE i501sub_sfe16_pre FROM l_sql
      DECLARE i501sub_sfe16_cur CURSOR FOR i501sub_sfe16_pre 
     CALL s_yp(p_sfp03) RETURNING l_year,l_month  
   #跨月補單
     IF (l_year*12+l_month) <> (g_sma.sma51*12+g_sma.sma52) THEN
        IF p_cmd = 's' THEN
           SELECT SUM(sfe16) INTO l_sfe16 FROM sfe_file
            WHERE sfe01 = p_sfs.sfs03
              AND sfe07 = p_sfs.sfs04
              AND sfe14 = p_sfs.sfs10
              AND sfe17 = p_sfs.sfs06
              AND sfe27 = p_sfs.sfs27
              AND sfe012 = p_sfs.sfs012
              AND sfe013 = p_sfs.sfs013   
              AND sfe06 IN ('1','2','3') 
              AND sfe04 <= p_sfp03
           SELECT SUM(sfe16) INTO l_sfe16_1 FROM sfe_file
            WHERE sfe01 = p_sfs.sfs03
              AND sfe07 = p_sfs.sfs04
              AND sfe14 = p_sfs.sfs10
              AND sfe17 = p_sfs.sfs06
              AND sfe27 = p_sfs.sfs27
              AND sfe012 = p_sfs.sfs012
              AND sfe013 = p_sfs.sfs013
              AND sfe06 = '4'
              AND sfe04 <= p_sfp03
           IF cl_null(l_sfe16_1) THEN
              LET l_sfe16_1 = 0
           END IF
           SELECT SUM(sfe16) INTO l_sfe16_new FROM sfe_file
            WHERE sfe01 = p_sfs.sfs03
              AND sfe02 = p_sfs.sfs01
               AND sfe07 = p_sfs.sfs04
              AND sfe14 = p_sfs.sfs10
              AND sfe17 = p_sfs.sfs06
              AND sfe27 = p_sfs.sfs27
              AND sfe012 = p_sfs.sfs012
              AND sfe013 = p_sfs.sfs013
              AND sfe06 = '4'
              AND sfe04 <= p_sfp03
           IF cl_null(l_sfe16_new) THEN
              LET l_sfe16_new = 0
           END IF
           CALL i501sub_totsfs05(p_sfp01,p_sfp03,p_sfp06,p_sfs.sfs02,p_sfs.sfs03,p_sfs.sfs04,p_sfs.sfs06,p_sfs.sfs10,p_sfs.sfs27)
                RETURNING l_totsfs05
           LET l_min_qty = l_sfe16 - l_sfe16_1 - l_totsfs05 + l_sfe16_new
           LET l_qty_chk = l_min_qty
           FOREACH i501sub_sfe16_cur USING p_sfs.sfs27,p_sfs.sfs07 INTO l_sfa.*,l_sfe.*
              LET l_qty_temp = 0      #沒有考慮誤差率
              IF l_sfe.sfe06 MATCHES '[123]' THEN
                 LET l_qty_chk = l_qty_chk + l_qty_temp
              ELSE
                 LET l_qty_chk = l_qty_chk - l_qty_temp
              END IF
              IF l_qty_chk < l_min_qty THEN LET l_min_qty = l_qty_chk END IF
           END FOREACH
           IF p_sfs.sfs05 > l_min_qty THEN  
              CALL cl_err(p_sfs.sfs04,'asf-609',0)
              LET g_success="N"
              RETURN
           END IF
        END IF
     END IF
#FUN-C90077 ----------------End------------------
   END IF
END FUNCTION

#FUN-C90077 ----------------Begin----------------
#此函數用于計算退料未過賬量,若有需要可直接擴展為未過賬量計算。
FUNCTION i501sub_totsfs05(p_sfp01,p_sfp03,p_sfp06,p_sfs02,p_sfs03,p_sfs04,p_sfs06,p_sfs10,p_sfs27)
DEFINE   l_tot        LIKE sfs_file.sfs05
DEFINE   p_sfp03      LIKE sfp_file.sfp03   
DEFINE   p_sfp01      LIKE sfp_file.sfp01
DEFINE   p_sfs02      LIKE sfs_file.sfs02
DEFINE   p_sfs03      LIKE sfs_file.sfs03
DEFINE   p_sfs04      LIKE sfs_file.sfs04
DEFINE   p_sfs06      LIKE sfs_file.sfs06  
DEFINE   p_sfs10      LIKE sfs_file.sfs10 
DEFINE   p_sfp06      LIKE sfp_file.sfp06
DEFINE   p_sfs27      LIKE sfs_file.sfs27  
   LET l_tot = 0
   IF p_sfp06 MATCHES '[68]' THEN
      SELECT SUM(sfs05/sfa28) INTO l_tot  FROM sfs_file,sfp_file,sfa_file
       WHERE sfs01  = sfp01
         AND sfp04 != 'Y'
         AND sfp06  = p_sfp06
         AND ((sfs01 != p_sfp01)
          OR (sfs01 = p_sfp01 AND sfs02 != p_sfs02))
         AND sfs03  = p_sfs03
         AND sfa01  = sfs03
         AND sfa27  = p_sfs27
         AND sfa03  = sfs04
         AND sfs06  = p_sfs06
         AND sfs10  = p_sfs10
         AND sfpconf != 'X'
         AND sfp03 <= p_sfp03
   ELSE
      SELECT SUM(sfs05) INTO l_tot  FROM sfs_file,sfp_file
       WHERE sfs01  = sfp01
         AND sfp04 != 'Y'
         AND sfp06  = p_sfp06
         AND ((sfs01 != p_sfp01)
          OR (sfs01 = p_sfp01 AND sfs02 != p_sfs02))
         AND sfs03  = p_sfs03
         AND sfs27  = p_sfs27
         AND sfs04  = p_sfs04
         AND sfs06  = p_sfs06
         AND sfs10  = p_sfs10
         AND sfpconf != 'X'
         AND sfp03 <= p_sfp03
   END IF
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","sfs_file","sfs05","",SQLCA.sqlcode,"","sel sum(sfs05)",1)
      LET l_tot = 0
   END IF
   IF cl_null(l_tot) THEN
      LET l_tot=0
   END IF
   RETURN l_tot
END FUNCTION

#FUN-C90077 ----------------End------------------
 
FUNCTION i501sub_w(p_sfp01,p_action_choice,p_call_transaction)
  DEFINE p_sfp01         LIKE sfp_file.sfp01
  DEFINE p_action_choice STRING
  DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
  DEFINE l_sfp RECORD    LIKE sfp_file.*
  DEFINE l_sfq02   LIKE sfq_file.sfq02   #No.TQC-750029
  DEFINE l_cnt     LIKE type_file.num5   #No.TQC-750029
 
   LET g_success='Y'
   IF cl_null(p_sfp01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
  #IF l_sfp.sfpconf='N' THEN LET g_success='N' RETURN END IF  #FUN-AB0001 mark
  #FUN-AB0001 add str---
   IF l_sfp.sfpconf='N' THEN 
      LET g_success='N' 
      CALL cl_err('','9025',0) 
      RETURN 
   END IF  
  #FUN-AB0001 add end--- 

   IF l_sfp.sfpconf='X' THEN CALL cl_err(' ','9024',0) LET g_success='N' RETURN END IF

   IF l_sfp.sfp04='Y' THEN
      CALL cl_err('sfp04=Y:','afa-101',0)
      LET g_success='N' RETURN
   END IF
 
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-109') THEN LET g_success='N' RETURN END IF
   END IF
   
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
 
   CALL i501sub_lock_cl()
   
   OPEN i501sub_cl USING l_sfp.sfp01
   IF STATUS THEN
      CALL cl_err("OPEN i501sub_cl:", STATUS, 1)
      CLOSE i501sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   FETCH i501sub_cl INTO l_sfp.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i501sub_cl 
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   CLOSE i501sub_cl
   
   LET g_success = 'Y'
   UPDATE sfp_file 
      SET sfpconf = 'N' 
         ,sfp15 = '0'                 #FUN-AB0001 add
    WHERE sfp01 = l_sfp.sfp01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
   ELSE
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF
END FUNCTION
 
FUNCTION i501sub_z(p_argv1,p_sfp01,p_action_choice,p_call_transaction)
  DEFINE l_ima931        LIKE ima_file.ima931  #DEV-D30026 add
  DEFINE p_argv1         LIKE type_file.chr1  #1:領料;2:退料
  DEFINE p_sfp01         LIKE sfp_file.sfp01
  DEFINE p_action_choice STRING
  DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
  DEFINE l_sfp RECORD    LIKE sfp_file.*
  DEFINE l_rvu RECORD    LIKE rvu_file.*  #NO.FUN-A10001   
  DEFINE l_rvv RECORD    LIKE rvv_file.*  #NO.FUN-A10001   
  DEFINE l_yy,l_mm LIKE type_file.num5
 #DEFINE l_sie10   LIKE sie_file.sie10    #No.FUN-A20048 #FUN-AC0074 mark
  DEFINE l_sfb04   LIKE sfb_file.sfb04,
         l_sfq02   LIKE sfq_file.sfq02,
         l_sfb02   LIKE sfb_file.sfb02, #MOD-540074
         l_sfe01   LIKE sfe_file.sfe01, #TQC-C70011
         l_sfm07   LIKE sfm_file.sfm07, #NO:6968
         l_sfm09   LIKE sfm_file.sfm07, #NO:6968
         l_cnt     LIKE type_file.num5               #MOD-540074  #No.FUN-680121 SMALLINT
  DEFINE lj_result    LIKE type_file.chr1  #No.MOD-C80077 存s_incchk()返回值
  DEFINE l_sfe RECORD LIKE sfe_file.*      #No.MOD-C80077
  DEFINE l_sfa062  LIKE sfa_file.sfa062    #MOD-C90217 add
 
   LET g_success='Y'
   IF s_shut(0) THEN LET g_success='N' RETURN END IF
   IF cl_null(p_sfp01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
   IF l_sfp.sfp01 IS NULL THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
   IF l_sfp.sfp04='N' THEN LET g_success='N' RETURN END IF #-->已扣帳
   IF l_sfp.sfpconf='X' THEN CALL cl_err('','9024',1) LET g_success='N' RETURN END IF #FUN-660106
#FUN-D30065 ----------Begin-------------		
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原 		
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'		
   IF g_ccz.ccz28  = '6' THEN		
      CALL cl_err('','apm-936',1)		
      LET g_success = 'N'
      RETURN		
   END IF 		
#FUN-D30065 ----------End---------------		

   #TQC-C20353 add begin 如果生產日報工單轉出中存在核准的單子,則不允許過帳還原
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE (shj02 = p_sfp01 OR shj03 = p_sfp01) #包括發,退料單
      AND shjconf = 'Y'
   IF l_cnt > 0 THEN 
      CALL cl_err('','asf-592',1)
      LET g_success = 'N'
      RETURN 
   END IF    
   #TQC-C20353 add end

#TQC-C90083--add--
   LET l_sfq02 = ' '
   DECLARE i501_z_check CURSOR FOR
   SELECT sfq02 FROM sfq_file WHERE sfq01=l_sfp.sfp01
   FOREACH i501_z_check INTO l_sfq02
      IF STATUS THEN
         CALL cl_err('FOREACH',STATUS,0)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM sha_file
       WHERE sha01 = l_sfq02 
      IF l_cnt > 0 THEN 
         CALL cl_err(l_sfq02,'asf-277',1)
         LET g_success = 'N'
         RETURN
      END IF
      #DEV-D30026---add---str---
      IF g_aza.aza131 = 'Y' THEN #是否與M-Barcode整合='Y'
          LET l_ima931 = ''
          SELECT ima931
            INTO l_ima931
            FROM ima_file,sfb_file
           WHERE ima01 = sfb05
             AND sfb01 = l_sfq02
          IF NOT cl_null(l_ima931) AND l_ima931 = 'Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM tlfb_file
               WHERE tlfb07 = l_sfq02
                 AND tlfb11 = 'abat022'
              IF l_cnt > 0 THEN
                 #此工單在條碼入庫掃瞄作業已有數量，不可過帳還原。
                 CALL cl_err(l_sfq02,'aba-125',1)
                 LET g_success = 'N'
                 RETURN
              END IF
          END IF 
      END IF
      #DEV-D30026---add---end---
  END FOREACH 
#TQC-C90083--add--
  #日期由扣帳日期做判斷,不用輸入日期

   #TQC-C70011--add--str--       #入庫單中存在,則不允許過帳還原,排除分批發料\退料
   IF g_sma.sma73 = 'N' THEN     #不檢查發料最小套數
      IF l_sfp.sfp06 NOT MATCHES '[6789B]' THEN   #排除退料
         LET l_sfe01 = ''
         DECLARE i501_z_c3 CURSOR FOR
            SELECT DISTINCT(sfe01) FROM sfe_file WHERE sfe02=l_sfp.sfp01
         FOREACH i501_z_c3 INTO l_sfe01
            IF STATUS THEN
               CALL cl_err('FOREACH',STATUS,0)
               LET g_success='N'
               EXIT FOREACH 
            END IF

            SELECT COUNT(*) INTO l_cnt FROM sfe_file,sfp_file  #排除分批發料,工單單號存在于多張已過帳的發料單中
             WHERE sfe01 = l_sfe01
               AND sfe02 = sfp01
               AND sfp01 <> l_sfp.sfp01
               AND sfp04 = 'Y'
               AND sfp06 IN ('1','2','3','4','A','C','D')    #FUN-C70014 add 'D'
            IF l_cnt > 0 THEN CONTINUE FOREACH END IF

            SELECT COUNT(*) INTO l_cnt FROM sfv_file
             WHERE sfv11 = l_sfe01 
               AND sfv01 IN (SELECT sfu01 FROM sfu_file
                              WHERE sfu00 = '1'
                                AND sfuconf <> 'X')  
            IF l_cnt > 0 THEN
               CALL cl_err(l_sfp.sfp01,'asf1032',1)
               LET g_success = 'N'
               RETURN
            END IF
            SELECT COUNT(*) INTO l_cnt FROM ksd_file
             WHERE ksd11 = l_sfe01
               AND ksd01 IN (SELECT ksc01 FROM ksc_file
                              WHERE ksc00 = '1'
                                AND kscconf <> 'X')
            IF l_cnt > 0 THEN
               CALL cl_err(l_sfp.sfp01,'asf1032',1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END IF
   #TQC-C70011--add--end--

   IF g_sma.sma53 IS NOT NULL AND l_sfp.sfp03 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) LET g_success='N' RETURN
   END IF

   CALL s_yp(l_sfp.sfp03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(l_yy,'mfg6090',0) LET g_success='N' RETURN
   END IF
 
   #當sfp06(發料類別)=1時,檢查每一個sfq02(工單號碼)是否已有欠料補料,若有則警告並Return
   IF l_sfp.sfp06='1' THEN
      LET l_sfq02 = ''
      DECLARE i501_z_c1 CURSOR FOR
         SELECT sfq02 FROM sfq_file WHERE sfq01=l_sfp.sfp01
      FOREACH i501_z_c1 INTO l_sfq02
         IF STATUS THEN
            CALL cl_err('FOREACH',STATUS,0) 
            LET g_success='N'
            EXIT FOREACH 
         END IF
         #當欠料補料單未過帳,需檢查sfq_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfs_file
          WHERE sfp01=sfs01 AND sfs03=l_sfq02 AND sfp06='3'
            AND sfpconf<>'X'     #MOD-940139
         IF l_cnt > 0 THEN
            CALL cl_err(l_sfq02,'asf-463',1)   #已有欠料補料資料,不可過帳還原!
            LET g_success='N'
            RETURN 
         END IF
         #若欠料補料單已過帳,需檢查sfe_file
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfe_file
          WHERE sfp01=sfe02 AND sfe01=l_sfq02 AND sfp06='3'
            AND sfpconf<>'X'     #MOD-940139
         IF l_cnt > 0 THEN
            CALL cl_err(l_sfq02,'asf-463',1)   #已有欠料補料資料,不可過帳還原!
            LET g_success='N'
            RETURN 
         END IF
#MOD-B30434 --------------------------Bgin-----------------------------------
#         #當超領單未過賬，需要檢查sfq_file
#         LET l_cnt = 0
#         SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfs_file
#          WHERE sfp01=sfs01 AND sfs03=l_sfq02 AND sfp06='2'
#            AND sfpconf<>'X'     #No:MOD-A30097 add
#         IF l_cnt > 0 THEN
#            CALL cl_err(l_sfq02,'asf-464',1)   #已有超領料資料，不可過賬還原
#            LET g_success='N'
#            RETURN 
#         END IF
#        #若超領單已經過賬，需要檢查sfe_file
#        LET l_cnt = 0
#        SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfe_file
#         WHERE sfp01=sfe02 AND sfe01=l_sfq02 AND sfp06='2'
#           AND sfpconf<>'X'     #No:MOD-A30097 add
#        IF l_cnt > 0 THEN
#           CALL cl_err(l_sfq02,'asf-464',1)   #已有超領料資料，不可過賬還原
#           LET g_success='N'
#           RETURN 
#        END IF
#MOD-B30434 --------------------------End-----------------------------------
      END FOREACH
   END IF    

   #No.TQC-B80182  --Begin
   #拆件式工单若有入库的时候,要卡一定有发料,至于发多少,不管控
   IF l_sfp.sfp06='1' THEN
      CALL i501sub_disassemble(l_sfp.sfp01,'1')
      IF g_success = 'N' THEN RETURN END IF   #MOD-C90004
   END IF
   #No.TQC-B80182  --End

#MOD-C80077 add begin-----------------------------
   #判斷發料單單身資料
   DECLARE i501_z_c4 CURSOR FOR SELECT * FROM sfe_file
     WHERE sfe02 = l_sfp.sfp01
      LET g_success = "Y"

   CALL s_showmsg_init()

   FOREACH i501_z_c4 INTO l_sfe.*
      IF STATUS THEN
         EXIT FOREACH
      END IF

      #判斷該user是否有使用此倉儲的權限
      CALL s_incchk(l_sfe.sfe08,l_sfe.sfe09,g_user)
          RETURNING lj_result
      IF NOT lj_result THEN
         LET g_showmsg = l_sfe.sfe07,"/",l_sfe.sfe08,"/",l_sfe.sfe09,"/",g_user
         CALL s_errmsg('sfe07,sfe08,sfe09,inc03',g_showmsg,'','asf-888',1)
         LET g_totsuccess='N'
         CONTINUE FOREACH
      END IF

     #MOD-C90217---add---S
      IF g_prog = 'asfi512' THEN
        #工單目前超領數量
         LET l_sfa062=0
         SELECT sfa062 INTO l_sfa062 FROM sfa_file
          WHERE sfa01 = l_sfe.sfe01
            AND sfa03 = l_sfe.sfe07

         IF cl_null(l_sfa062) THEN LET l_sfa062=0 END IF

         IF l_sfa062 - l_sfe.sfe16 < 0 THEN
            LET g_success = 'N'
            CALL cl_err('','asf1034',1)
            RETURN
         END IF
      END IF
     #MOD-C90217---add---E

   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
#MOD-C80077 add end-------------------------------

   IF g_success = 'N' THEN RETURN END IF
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('asf-663') THEN LET g_success='N' RETURN END IF       #NO.TQC-750225
   END IF
 
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
   
   LET g_success = 'Y'
 
  ##NO.FUN-A10001   add--begin   
   SELECT * INTO l_rvu.* FROM rvu_file
    WHERE rvu117 = p_sfp01 
   SELECT * INTO l_rvv.* FROM rvv_file
    WHERE rvv01 = l_rvu.rvu01 
   SELECT COUNT(*) INTO l_cnt
     FROM pmc_file
    WHERE pmc917 = l_rvv.rvv32
      AND pmc918 = l_rvv.rvv33
   IF l_cnt > 0 THEN          
     #CALL i501sub_VMI_z(p_sfp01)          #MOD-C20155 mark
      CALL i501sub_VMI_z(p_sfp01,p_argv1)  #MOD-C20155 add
      IF g_success = 'N' THEN
         IF p_call_transaction THEN
            ROLLBACK WORK
         END IF
         RETURN
      END IF
   END IF      
  ##NO.FUN-A10001   add--end

   CALL i501sub_lock_cl()
 
   OPEN i501sub_cl USING l_sfp.sfp01
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
   FETCH i501sub_cl INTO l_sfp.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i501sub_cl
      LET g_success='N'
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      RETURN
   END IF
 
 
   UPDATE sfp_file SET sfp04='N' 
                      #sfpmodu=g_user,                 #MOD-A90175 mark    
                      #sfpdate=g_today  #NO:6908       #MOD-A90175 mark  
    WHERE sfp01=l_sfp.sfp01
   IF STATUS THEN
      CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp04",1)  #No.FUN-660128
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CALL i501sub_s1(l_sfp.*) RETURNING l_sfp.*
 
   LET g_sfp01 = l_sfp.sfp01   #TQC-A30091 
   
   IF NOT l_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
      CALL i501sub_z2(p_argv1,l_sfp.*)     

      LET g_mescnt = 1    #FUN-C10035 add
 
      DECLARE i501_z_c CURSOR FOR
        SELECT DISTINCT sfq02,sfb04,sfb02 FROM sfq_file,sfb_file  #MOD-540074 add sfb02
        WHERE sfq01=l_sfp.sfp01
          AND sfq02=sfb01
      FOREACH i501_z_c INTO l_sfq02,l_sfb04,l_sfb02  #MOD-540074 add l_sfb02
         IF STATUS THEN CALL cl_err('foreach z',STATUS,0) EXIT FOREACH END IF        
         CALL i501sub_chk_sfb04(l_sfq02,l_sfb04)   #bugno:6050  

        #FUN-C10035 add str ---
        #與MES整合時,發料單的工單型態應該要一致(屬於整合或不整合),故取一筆即可
         IF g_mescnt = 1 THEN
            LET g_sfb02 = l_sfb02
            LET g_mescnt = 2
         END IF
        #FUN-C10035 add end ---
      END FOREACH
 
      #W.還原時
      #因挪料作業產生的發/退料單sfp09='Y'
      #發料單=> update sfp09 = 'N'(此張發料單UPDATE就好,相對的退料單不用UPDATE),不刪除記錄檔sfm_file,sfn_file
      #退料單=> update sfp09 = 'N'(此張退料單UPDATE就好,相對的發料單不用UPDATE),不刪除記錄檔sfm_file,sfn_file
      IF l_sfp.sfp09 = 'Y' THEN
          UPDATE sfp_file
             SET sfp09 = 'N' 
                #sfpmodu=g_user,            #MOD-A90175 mark  
                #sfpdate=g_today            #MOD-A90175 mark   
           WHERE sfp01 = l_sfp.sfp01
          IF SQLCA.sqlcode THEN
              LET g_success = 'N'
          END IF
      END IF

     #FUN-9A0095 add begin ------------------
      IF g_success = 'Y' THEN
         IF g_aza.aza90 MATCHES "[Yy]" THEN
            IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN   #FUN-C10035 add   #FUN-CC0122 add g_sfb02 = '5'
              #CALL aws_mescli
              #傳入參數:  (1)程式代號
              #         (2)功能選項：insert(新增),update(修改),delete(刪除)
              #         (3)Key
               IF l_sfp.sfp06 MATCHES "[1234]" THEN    #發料
                  CALL i501_mes('asfi511',l_sfp.sfp01)
               END IF
             
              #IF l_sfp.sfp06 MATCHES "[5678]" AND g_aza.aza96 MATCHES "[Nn]" THEN    #退料 #CHI-A70060 mark
               IF l_sfp.sfp06 MATCHES "[6789]" AND g_aza.aza96 MATCHES "[Nn]" THEN    #退料 #CHI-A70060
                  CALL i501_mes('asfi526',l_sfp.sfp01)
               END IF
            END IF                                     #FUN-C10035 add
         END IF
      END IF
     #FUN-9A0095 add end --------------------

   ELSE
      CALL i501sub_z2_asr(p_argv1,l_sfp.*) #FUN-5C0114
   END IF
 
  #FUN-A20048 --begin
      IF l_sfp.sfp06 MATCHES '[13D]' THEN #FUN-AC0074   #FUN-C70014 add 'D'
         DECLARE  i501sub_sif_cs1 CURSOR FOR SELECT * FROM sfs_file 
           WHERE sfs01 = l_sfp.sfp01 
         FOREACH i501sub_sif_cs1 INTO g_sfs_sif.*
           IF STATUS THEN EXIT FOREACH END IF
           CALL s_updsie_unsie(g_sfs_sif.sfs01,g_sfs_sif.sfs02,'1') #FUN-AC0074 add
           IF g_success = 'N' THEN EXIT FOREACH END IF #FUN-AC0074 add
         END FOREACH  #FUN-AC0074 add
      END IF  #FUN-AC0074
      #FUN-AC0074--begin--mark-----
      # LET l_cnt = 0                   
      # SELECT COUNT(*) INTO l_cnt FROM sia_file,sic_file WHERE sia01=sic01 AND siaconf='Y'
      #      AND sic03=g_sfs_sif.sfs03 
      # IF l_cnt = 0 THEN CONTINUE FOREACH END IF 
      # IF l_cnt >0 THEN  
      #   LET l_cnt = 0         
      #   SELECT COUNT(*),SUM(sie10) INTO l_cnt,l_sie10  #TQC-AC0298
      #     FROM sie_file WHERE sie01= g_sfs_sif.sfs04 AND sie02= g_sfs_sif.sfs07
      #      AND sie03=g_sfs_sif.sfs08 AND sie04=g_sfs_sif.sfs09 AND sie05= g_sfs_sif.sfs03 AND sie06=g_sfs_sif.sfs10
      #      AND sie07=g_sfs_sif.sfs06 AND sie08=g_sfs_sif.sfs27 AND sie10 > 0  #TQC-AC0298                
      #      AND sie012=g_sfs_sif.sfs012   #FUN-A60028 
      #      AND sie013=g_sfs_sif.sfs013   #FUN-A60028
      #   IF l_cnt > 0 THEN   
      #    IF l_sie10 >= g_sfs_sif.sfs05  THEN  #TQC-AC0298
      #      UPDATE sie_file SET sie10 = sie10-g_sfs_sif.sfs05,sie11= sie11+g_sfs_sif.sfs05,sie12 = g_today,
      #             sie13 = g_sfs_sif.sfs01,sie14 = g_sfs_sif.sfs02 
      #       WHERE sie01= g_sfs_sif.sfs04 AND sie02= g_sfs_sif.sfs07
      #      AND sie03=g_sfs_sif.sfs08 AND sie04=g_sfs_sif.sfs09 AND sie05= g_sfs_sif.sfs03 AND sie06=g_sfs_sif.sfs10
      #      AND sie07=g_sfs_sif.sfs06 AND sie08=g_sfs_sif.sfs27  #TQC-AC0298
      #      AND sie012=g_sfs_sif.sfs012   #FUN-A60028 
      #      AND sie013=g_sfs_sif.sfs013   #FUN-A60028 
      #      IF SQLCA.SQLERRD[3]=0 THEN
      #         CALL cl_err3("upd","sie_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
      #         LET g_success = 'N'             
      #      END IF
      #    ELSE 
      #      UPDATE sie_file SET sie10 = 0,sie11= g_sfs_sif.sfs05,sie12 = g_today,
      #             sie13 = g_sfs_sif.sfs01,sie14 = g_sfs_sif.sfs02 
      #       WHERE sie01= g_sfs_sif.sfs04 AND sie02= g_sfs_sif.sfs07
      #      AND sie03=g_sfs_sif.sfs08 AND sie04=g_sfs_sif.sfs09 AND sie05= g_sfs_sif.sfs03 AND sie06=g_sfs_sif.sfs10
      #      AND sie07=g_sfs_sif.sfs06 AND sie08=g_sfs_sif.sfs27  #TQC-AC0298
      #      AND sie012=g_sfs_sif.sfs012   #FUN-A60028 
      #      AND sie013=g_sfs_sif.sfs013   #FUN-A60028 
      #      IF SQLCA.SQLERRD[3]=0 THEN
      #         CALL cl_err3("upd","sie_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
      #         LET g_success = 'N'             
      #      END IF            
      #    END IF 
      #    LET l_cnt = 0 
      #    SELECT COUNT(*) INTO l_cnt
      #       FROM sig_file WHERE sig01 = g_sfs_sif.sfs04 AND sig02 = g_sfs_sif.sfs07
      #          AND sig03= g_sfs_sif.sfs08 AND sig04 = g_sfs_sif.sfs09                 
      #    IF l_cnt > 0 THEN         
      #      UPDATE sig_file SET sig05 =sig05+g_sfs_sif.sfs05,sig07 = g_today
      #         WHERE sig01 = g_sfs_sif.sfs04 AND sig02 = g_sfs_sif.sfs07
      #            AND sig03= g_sfs_sif.sfs08 AND sig04 = g_sfs_sif.sfs09
      #      IF SQLCA.SQLERRD[3]=0 THEN
      #         CALL cl_err3("upd","sig_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,SQLCA.sqlcode,"","up sie10",1)
      #         LET g_success = 'N'             
      #      END IF
      #    END IF 
      #    DELETE FROM sif_file WHERE sif11=g_sfs_sif.sfs01 AND sif12 = g_sfs_sif.sfs02
      #    IF SQLCA.sqlerrd[3] = 0 THEN 
      #       CALL cl_err3("del","sif_file",g_sfs_sif.sfs01,g_sfs_sif.sfs02,sqlca.sqlcode,"","del sif01",1)
      #       LET g_success ='N'
      #    END IF 
      #   END IF 
      #END IF     
     #END FOREACH  
     #FUN-AC0074--end--mark------
#FUN-A20048 --end 

   IF s_industry('icd') THEN
      CALL i501sub_ind_icd_upd_sfb08('N',l_sfp.*)  #FUN-810038
   END IF

   #str-----add by guanyao160721
   IF l_sfp.sfp06 = '1' OR l_sfp.sfp06 = '3' OR l_sfp.sfp06 = '2' THEN 
      IF g_success = 'Y' THEN
         CALL i501sub_un_imm(l_sfp.sfp01)
      END IF 
   END IF 
   #end-----add by guanyao160721
 
   IF g_success = 'Y' THEN
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
   ELSE
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF
  CALL cl_msg("")  #FUN-920175

END FUNCTION
 
FUNCTION i501sub_z2(p_argv1,l_sfp)
  DEFINE p_argv1 LIKE type_file.chr1
  DEFINE l_flag  LIKE type_file.num5  #FUN-810038
  DEFINE l_sfp   RECORD LIKE sfp_file.*
  DEFINE l_sfe   RECORD LIKE sfe_file.* 
  DEFINE l_sfs   RECORD LIKE sfs_file.* 
  DEFINE l_sfb   RECORD LIKE sfb_file.*
  DEFINE l_sfs03       LIKE sfs_file.sfs03
  DEFINE l_sfs04       LIKE sfs_file.sfs04
  DEFINE l_sfs10       LIKE sfs_file.sfs10
  DEFINE l_sfs012      LIKE sfs_file.sfs012,   #FUN-A60028   add by vealxu
         l_sfs013      LIKE sfs_file.sfs013    #FUN-A60028   add by vealxu
  DEFINE l_sfei RECORD LIKE sfei_file.*        #TQC-B80005       
# DEFINE l_sql  STRING #MOD-C60234   #MOD-D10094 mark
 
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE i501_z2_c CURSOR FOR
          SELECT * FROM sfe_file, sfb_file
           WHERE sfe02=l_sfp.sfp01 AND sfe01=sfb01
  FOREACH i501_z2_c INTO l_sfe.*, l_sfb.*
      IF STATUS THEN
         CALL cl_err('for sfe:',STATUS,1) LET g_success='N' EXIT FOREACH  
      END IF
      IF l_sfb.sfb04='8' THEN
         CALL cl_err('sfb04=8','asf-345',1) LET g_success='N' EXIT FOREACH
      END IF
      MESSAGE 'z2:',l_sfe.sfe28
   
      IF s_industry('icd') THEN
         #TQC-B80005 --START--
         SELECT * INTO l_sfei.* FROM sfei_file
          WHERE sfei02 = l_sfe.sfe02 AND sfei28 = l_sfe.sfe28  
         #TQC-B80005 --END--
        #CASE WHEN l_sfp.sfp06 = '1' #CHI-A70060 mark
         CASE WHEN l_sfp.sfp06 MATCHES '[1234D]' #CHI-A70060   #FUN-C70014 add 'D'
                   CALL s_icdpost(-1, l_sfe.sfe07,l_sfe.sfe08,l_sfe.sfe09,
                                      l_sfe.sfe10,l_sfe.sfe17,l_sfe.sfe16,
                                      l_sfe.sfe02,l_sfe.sfe28,l_sfp.sfp02,
                                       'N','','',l_sfei.sfeiicd029,l_sfei.sfeiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                        RETURNING l_flag   
                   IF l_flag = 0 THEN LET g_success = 'N' EXIT FOREACH END IF
             #WHEN l_sfp.sfp06 = '6' #CHI-A70060 mark
              WHEN l_sfp.sfp06 MATCHES '[6789]' #CHI-A70060
                   CALL s_icdpost(1, l_sfe.sfe07,l_sfe.sfe08,l_sfe.sfe09,
                                     l_sfe.sfe10,l_sfe.sfe17,l_sfe.sfe16,
                                     l_sfe.sfe02,l_sfe.sfe28,l_sfp.sfp02,
                                      'N','','',l_sfei.sfeiicd029,l_sfei.sfeiicd028,'') #FUN-B30187 #TQC-B80005 #FUN-B80119--傳入p_plant參數''--- 
                        RETURNING l_flag
                   IF l_flag = 0 THEN LET g_success = 'N' EXIT FOREACH END IF
         END CASE
      END IF
 
      IF g_sma.sma115 = 'Y' THEN
         CALL i501sub_update_du('w',p_argv1,l_sfp.*,l_sfs.*,l_sfe.*)      #No.MOD-790112 add l_sfe
         IF g_success='N' THEN 
            LET g_totsuccess='N'
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
      END IF
      CALL i501sub_z_update(p_argv1,l_sfe.*,1)                            #FUN-920175
 
      CALL i501sub_sfs(l_sfp.sfp06,l_sfe.*) RETURNING l_sfs.*
      DELETE FROM sfe_file WHERE sfe02=l_sfe.sfe02 AND sfe28=l_sfe.sfe28
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("del","sfe_file",l_sfe.sfe02,l_sfe.sfe28,STATUS,"","del sfe",1)  #No.FUN-660128
         LET g_success='N'
      END IF

      #FUN-B70061 --START--
      IF NOT s_industry('std') THEN
         IF NOT s_del_sfei(l_sfe.sfe02,l_sfe.sfe28,'') THEN
            LET g_success='N'
         END IF
      END IF 
      #FUN-B70061 --END--
 
      IF g_success='N' THEN 
         LET g_totsuccess='N'
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
         #RETURN 
      END IF
      CALL i501sub_u_sfa('z',p_argv1,l_sfp.*,l_sfs.*,l_sfb.*) #FUN-740187
      IF g_success='N' THEN RETURN END IF

#MOD-B90008 --begin--
        LET g_sfs10 = NULL
        LET g_sfs10 = l_sfs.sfs10
#MOD-B90008 --end--

      IF l_sfb.sfb02 != '11' THEN           #No:MOD-9B0079 add
         #MOD-C10171 ---begin
         SELECT sfa11 INTO g_sfa11 FROM sfa_file
            WHERE sfa01=l_sfs.sfs03 AND sfa03=l_sfs.sfs04
              AND sfa12=l_sfs.sfs06 AND sfa08=l_sfs.sfs10
              AND sfa27=l_sfs.sfs27  
              AND sfa012=l_sfs.sfs012  
              AND sfa013=l_sfs.sfs013  
         #MOD-C10171 ---end
      #  CALL i501sub_qty('z',l_sfb.*)         #CHI-870030  add  #FUN-C70037 mark
      #  CALL i501sub_qty('z',l_sfp.sfp03,l_sfb.*)    #FUN-C70037   #FUN-C90077 mark
      #  CALL i501sub_qty('z',l_sfp.sfp01,l_sfp.sfp03,l_sfp.sfp06,l_sfb.*)    #FUN-C90077
         CALL i501sub_qty('z',l_sfs.*,l_sfp.sfp03,l_sfp.sfp06,l_sfb.*)        #FUN-C90077 
      END IF                                #No:MOD-9B0079 add
      IF g_success='N' THEN RETURN END IF   #CHI-870030  add
  END FOREACH
  #若走制程且為首站,則將最小齊套數寫到ecm301:
  #因為最小齊套數必須所有發料單身都跑完再抓s_minp出來的數字才正確,故要跑完上一個迴圈再重跑才正確
  IF l_sfp.sfp06  NOT MATCHES '[49]' THEN  #TQC-AC0077
     DECLARE i501_z3_c CURSOR FOR
             SELECT sfs03,sfs04,sfs10,sfs012,sfs013,sfb_file.* FROM sfs_file, sfb_file   #FUN-A60028 add sfs012,sfs013 by vealxu 
              WHERE sfs01=l_sfp.sfp01 AND sfs03=sfb01  #No.FUN-9B0140 
                AND sfb93='Y'
     FOREACH i501_z3_c INTO l_sfs03,l_sfs04,l_sfs10,l_sfs012,l_sfs013,l_sfb.*            #FUN-A60028 add l_sfs012.l_sfs013 by vealxu 
       #MOD-D10094 mark begin----------------------------------
       ##MOD-C60234 add begin--------------------
       #IF cl_null(l_sfs10) AND g_sma.sma541 = 'Y' THEN
       #   LET l_sql = "SELECT DISTINCT A.ecm012 FROM ecm_file A",
       #               " WHERE A.ecm01 = '",l_sfs03,"'",
       #               "   AND 0 = (SELECT COUNT(*) FROM ecm_file B ",
       #               " WHERE B.ecm01 = A.ecm01",
       #               "   AND B.ecm015=A.ecm012)"
       #   DECLARE s_schdat_min_ecm03_c1 CURSOR FROM l_sql
       #   FOREACH s_schdat_min_ecm03_c1 INTO l_sfs012
       #      CALL i501sub_upd_ecm301('z',l_sfs03,l_sfs04,l_sfs10,l_sfb.*,l_sfs012,l_sfs013)
       #          RETURNING l_flag
       #      IF NOT l_flag THEN
       #         LET g_success = 'N'
       #      END IF
       #   END FOREACH
       #ELSE
       ##MOD-C60234 add end----------------------
       #MOD-D10094 mark end-----------------------------------
           CALL i501sub_upd_ecm301('z',l_sfs03,l_sfs04,l_sfs10,l_sfb.*,l_sfs012,l_sfs013,l_sfp.*)   #FUN-A60028 add l_sfs012.l_sfs013 by vealxu 
                RETURNING l_flag
           IF NOT l_flag THEN
              LET g_success = 'N'
           END IF
       #END IF #MOD-C60234 add  #MOD-D10094 mark
     END FOREACH
  END IF #TQC-AC0077
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 
FUNCTION i501sub_z_update(p_argv1,l_sfe,p_factor)
   DEFINE p_argv1 LIKE type_file.chr1
   DEFINE p_ware  LIKE img_file.img02,    ##倉庫 #MOD-580001 #FUN-920175 mark
          p_loca  LIKE img_file.img03,    ##儲位 #MOD-580001 #FUN-920175 mark
          p_lot   LIKE img_file.img04,    ##批號 #MOD-580001 #FUN-920175 mark
          p_qty   LIKE img_file.img10,  #No.FUN-680121 DECIMAL (11,3),        ##數量 #FUN-920175 mark
          p_uom   LIKE img_file.img09,   ##img 單位 #MOD-580001  #FUN-920175 mark
          p_factor LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),  ##轉換率
          u_type   LIKE type_file.num5,      #No.FUN-680121  SMALLINT,    # +1:入庫 -1:出庫
          l_qty    LIKE img_file.img10,      #No.FUN-680121 DECIMAL (11,3),        ##異動後數量
          l_ima01  LIKE ima_file.ima01,
          l_ima25  LIKE ima_file.ima01,
#         l_imaqty LIKE ima_file.ima262,
          l_imaqty LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
          l_imafac LIKE img_file.img21,
          l_sfe    RECORD LIKE sfe_file.*,  #FUN-920175
          l_sfp06  LIKE sfp_file.sfp06,     #FUN-920175
          l_img RECORD
                img10   LIKE img_file.img10,
                img16   LIKE img_file.img16,
                img23   LIKE img_file.img23,
                img24   LIKE img_file.img24,
                img09   LIKE img_file.img09,
                img21   LIKE img_file.img21
                END RECORD,
          l_cnt  LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_forupd_sql STRING
   DEFINE l_ima918 LIKE ima_file.ima918
   DEFINE l_ima921 LIKE ima_file.ima921
   DEFINE la_tlf   DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
   DEFINE l_sql    STRING                                    #NO.FUN-8C0131 
   DEFINE l_i      LIKE type_file.num5                       #NO.FUN-8C0131 
   DEFINE l_d      DATE
 
    LET p_ware = l_sfe.sfe08  #FUN-920175
    LET p_loca = l_sfe.sfe09  #FUN-920175
    LET p_lot  = l_sfe.sfe10  #FUN-920175
    LET p_qty  = l_sfe.sfe16  #FUN-920175
    LET p_uom  = l_sfe.sfe17  #FUN-920175    
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    #IF cl_null(p_loca) THEN LET p_loca=' ' END IF  #mark by guanyao160804
    #str-----add by guanyao160808
    IF l_sfe.sfeud02 <> l_sfe.sfe08 THEN 
       #LET p_loca=' ' #add by guanyao160804
       SELECT ecd07 INTO p_loca FROM ecd_file WHERE ecd01=l_sfe.sfe14
       IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    ELSE 
       IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    END IF 
    #如果是7号之前的所有过账单，则默认库位为' ' add by donghy 161115
    LET l_d = '16/11/07'
    IF l_sfe.sfe04 < l_d THEN 
       LET p_loca=' '
    END IF
    #如果是7号之前的所有过账单，则默认库位为' ' add by donghy 161115
    #end-----add by guanyao160808
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    LET g_forupd_sql="SELECT img10,img16,img23,img24,img09,img21 ",
                     "  FROM img_file ",
                     "  WHERE img01= ? AND img02= ? AND img03= ? AND img04=? ",
                     "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock2 CURSOR FROM g_forupd_sql
 
    OPEN img_lock2 USING l_sfe.sfe07,p_ware,p_loca,p_lot
    IF STATUS THEN
       #CALL cl_err('lock img fail',STATUS,1)   #CHI-BA0003 mark
       #CHI-BA0003 -- begin --
       LET g_msg = 'lock img fail:',l_sfe.sfe28,'/',l_sfe.sfe07,'/',p_ware,'/',p_loca,'/',p_lot
       CALL cl_err(g_msg,STATUS,1)
      #CHI-BA0003 -- end -- 
       CLOSE img_lock2
       LET g_success='N'
       RETURN
    END IF
 
    FETCH img_lock2 INTO l_img.*
    IF STATUS THEN
      # CALL cl_err('lock img fail',STATUS,1)   #CHI-BA0003 mark
       #CHI-BA0003 -- begin --
       LET g_msg = 'lock img fail:',l_sfe.sfe28,'/',l_sfe.sfe07,'/',p_ware,'/',p_loca,'/',p_lot
       CALL cl_err(g_msg,STATUS,1)
      #CHI-BA0003 -- end -- 
       CLOSE img_lock2
       LET g_success='N'
       RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN
       LET l_img.img10=0
    END IF
 
    CASE WHEN p_argv1='1' LET u_type=+1
         WHEN p_argv1='2' LET u_type=-1
    END CASE
   
    #  在扣庫存之前，重新抓取單位換算率 ------
    CALL s_umfchk(l_sfe.sfe07,l_sfe.sfe17,l_img.img09)
         RETURNING l_cnt,p_factor
    IF l_cnt THEN
       CALL cl_err(l_sfe.sfe07,'asf-816',1) LET g_success='N' RETURN  #FUN-920175
    END IF
 
    CALL s_upimg(l_sfe.sfe07,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today, #FUN-8C0084
                 '','','','',l_sfe.sfe02,l_sfe.sfe28,   #No.CHI-860032
                 '','','','','','','','','','','','')

    IF g_success='N' THEN 
       CALL cl_msg("s_upimg error:")  #FUN-920175
       RETURN 
    END IF
 
    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock2 CURSOR FROM g_forupd_sql
 
    OPEN ima_lock2 USING l_sfe.sfe07
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock2
       LET g_success='N' RETURN
    END IF
 
    FETCH ima_lock2 INTO l_ima25   #,g_ima86  #FUN-740187
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock2
       LET g_success='N' RETURN
    END IF
 
    IF l_sfe.sfe17=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(l_sfe.sfe07,l_sfe.sfe17,l_ima25)
                RETURNING l_cnt,l_imafac
    END IF
 
    IF cl_null(l_imafac)  THEN
       ####Modify:98/11/15 -----料號/異動單位無法轉換 ----####
       CALL cl_err('料號/異動單位無法轉換',STATUS,1)
       LET g_success ='N'
    END IF
 
    LET l_imaqty = p_qty * l_imafac

   #MOD-C50170 str mark------ 
   #CALL s_udima(l_sfe.sfe07,l_img.img23,l_img.img24,l_imaqty,
   #                g_today,u_type)  RETURNING l_cnt
   #IF g_success='N' THEN 
   #   #ERROR "s_udima error:"  #FUN-920175
   #   CALL cl_msg("s_udima error:")  #FUN-920175
   #   RETURN 
   #END IF
   #MOD-C50170 end mark------

  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf62 = '",l_sfe.sfe01,"'",
                 "    AND ((tlf026='",l_sfe.sfe02,"' AND tlf027=",l_sfe.sfe28,") OR ",
                 "        (tlf036='",l_sfe.sfe02,"' AND tlf037=",l_sfe.sfe28,")) "
    DECLARE i501_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH i501_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end
    DELETE FROM tlf_file
           WHERE tlf62=l_sfe.sfe01
             AND ((tlf026=l_sfe.sfe02 AND tlf027=l_sfe.sfe28) OR
                  (tlf036=l_sfe.sfe02 AND tlf037=l_sfe.sfe28))
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("del","tlf_file",l_sfe.sfe01,"",STATUS,"","del tlf",1)  #No.FUN-660128
       LET g_success='N' 
    END IF
    ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end  
    SELECT ima918,ima921 INTO l_ima918,l_ima921
      FROM ima_file
     WHERE ima01 = l_sfe.sfe07
       AND imaacti = "Y"
    
    IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
       DELETE FROM tlfs_file
        WHERE tlfs01 = l_sfe.sfe07
          AND tlfs10 = l_sfe.sfe02
          AND tlfs11 = l_sfe.sfe28
 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN      
          CALL cl_err('del tlfs',STATUS,0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i501sub_sfs(l_sfp06,l_sfe)
  DEFINE l_sfp06 LIKE sfp_file.sfp06
  DEFINE l_sfe RECORD LIKE sfe_file.*
  DEFINE l_sfs RECORD LIKE sfs_file.*
  DEFINE l_sfsi   RECORD LIKE sfsi_file.*  #FUN-B70074
  DEFINE l_sfei   RECORD LIKE sfei_file.*  #FUN-B70061
  DEFINE l_sql    STRING                   #FUN-B70061 
  DEFINE l_sfp07      LIKE sfp_file.sfp07  #FUN-CB0087 製造部門
  DEFINE l_sfp16      LIKE sfp_file.sfp16  #FUN-CB0087 申請人
 
  INITIALIZE l_sfs.* TO NULL
  LET l_sfs.sfs01 = l_sfe.sfe02
  LET l_sfs.sfs02 = l_sfe.sfe28
  LET l_sfs.sfs03 = l_sfe.sfe01
  LET l_sfs.sfs04 = l_sfe.sfe07
  LET l_sfs.sfs05 = l_sfe.sfe16
  LET l_sfs.sfs06 = l_sfe.sfe17
  LET l_sfs.sfs07 = l_sfe.sfe08
  LET l_sfs.sfs08 = l_sfe.sfe09
  LET l_sfs.sfs09 = l_sfe.sfe10
  LET l_sfs.sfs10 = l_sfe.sfe14
  LET l_sfs.sfs21 = l_sfe.sfe11
  LET l_sfs.sfs26 = l_sfe.sfe26
  LET l_sfs.sfs27 = l_sfe.sfe27   #No.FUN-940008
  IF (cl_null(l_sfs.sfs27)) AND (NOT l_sfp06 MATCHES '[ABC]') THEN 
     SELECT UNIQUE sfa27,sfa28 INTO l_sfs.sfs27,l_sfs.sfs28
                FROM sfa_file
               WHERE sfa01=l_sfs.sfs03
                 AND sfa03=l_sfs.sfs04
                 AND sfa08=l_sfs.sfs10   #FUN-940008 add
                 AND sfa12=l_sfs.sfs06   #FUN-940008 add
              #  AND sfa27=l_sfs.sfs27   #FUN-940008 add  #TQC-B60091
                 AND sfa012=l_sfs.sfs012  #FUN-A60028
                 AND sfa013=l_sfs.sfs013  #FUN-A60028 
  END IF 
  IF cl_null(l_sfs.sfs28) THEN 
     SELECT sfa28 INTO l_sfs.sfs28 FROM sfa_file
                                  WHERE sfa01=l_sfs.sfs03
                                    AND sfa03=l_sfs.sfs04
                                    AND sfa08=l_sfs.sfs10
                                    AND sfa12=l_sfs.sfs06
                                    AND sfa27=l_sfs.sfs27
                                    AND sfa012=l_sfs.sfs012  #FUN-A60028 
                                    AND sfa013=l_sfs.sfs013  #FUN-A60028
  END IF 
  IF cl_null(l_sfs.sfs27) THEN LET l_sfs.sfs27=l_sfs.sfs04 END IF
  IF cl_null(l_sfs.sfs28) THEN LET l_sfs.sfs28=1           END IF
  LET l_sfs.sfs30 = l_sfe.sfe30
  LET l_sfs.sfs31 = l_sfe.sfe31
  LET l_sfs.sfs32 = l_sfe.sfe32
  LET l_sfs.sfs33 = l_sfe.sfe33
  LET l_sfs.sfs34 = l_sfe.sfe34
  LET l_sfs.sfs35 = l_sfe.sfe35
  LET l_sfs.sfs36 = l_sfe.sfe36   #FUN-950088 add
  IF cl_null(l_sfs.sfs10) THEN LET l_sfs.sfs10=' ' END IF
  LET l_sfs.sfs930= l_sfe.sfe930 #FUN-670103
  IF cl_null(l_sfs.sfs27) THEN LET l_sfs.sfs27=l_sfs.sfs04 END IF  #No.MOD-8B0086 add
  IF cl_null(l_sfs.sfs27) THEN
     LET l_sfs.sfs27 = ' '
  END IF
  LET l_sfs.sfsplant = g_plant #FUN-980008 add
  LET l_sfs.sfslegal = g_legal #FUN-980008 add
  #FUN-CB0043---begin
  LET l_sfs.sfsud01 = l_sfe.sfeud01
  LET l_sfs.sfsud02 = l_sfe.sfeud02
  LET l_sfs.sfsud03 = l_sfe.sfeud03
  LET l_sfs.sfsud04 = l_sfe.sfeud04
  LET l_sfs.sfsud05 = l_sfe.sfeud05
  LET l_sfs.sfsud06 = l_sfe.sfeud06
  LET l_sfs.sfsud07 = l_sfe.sfeud07
  LET l_sfs.sfsud08 = l_sfe.sfeud08
  LET l_sfs.sfsud09 = l_sfe.sfeud09
  LET l_sfs.sfsud10 = l_sfe.sfeud10
  LET l_sfs.sfsud11 = l_sfe.sfeud11
  LET l_sfs.sfsud12 = l_sfe.sfeud12
  LET l_sfs.sfsud13 = l_sfe.sfeud13
  LET l_sfs.sfsud14 = l_sfe.sfeud14
  LET l_sfs.sfsud15 = l_sfe.sfeud15
  #FUN-CB0043---end
  LET l_sfs.sfs012   = l_sfe.sfe012  #FUN-A60028
  LET l_sfs.sfs013   = l_sfe.sfe013  #FUN-A60028
  LET l_sfs.sfs014   = l_sfe.sfe014  #FUN-C70014 add
  #LET l_sfs.sfs37    = l_sfe.sfe26  #FUN-CB0087 add #FUN-D50017 mark
  LET l_sfs.sfs37    = l_sfe.sfe37   #FUN-D50017 add 
  
#FUN-A70125 --begin--
   IF cl_null(l_sfs.sfs012) THEN
     LET l_sfs.sfs012 = ' '
   END IF  
   IF cl_null(l_sfs.sfs013) THEN
     LET l_sfs.sfs013 = 0 
   END IF  
#FUN-A70125 --end-- 
  IF l_sfs.sfs014 IS NULL THEN LET l_sfs.sfs014=' ' END IF #FUN-C70014  add
  #FUN-CB0087---add---str---
  IF g_aza.aza115 = 'Y' AND cl_null(l_sfs.sfs37) THEN
     SELECT sfp07,sfp16 INTO l_sfp07,l_sfp16 FROM sfp_file WHERE sfp01 = l_sfs.sfs01 
     CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp16,l_sfp07) RETURNING l_sfs.sfs37
     IF cl_null(l_sfs.sfs37) THEN 
        CALL cl_err('','aim-425',1) 
        LET g_success = 'N'
     END IF
  END IF
  #FUN-CB0087---add---end--
  INSERT INTO sfs_file VALUES(l_sfs.*)
  IF STATUS THEN
     CALL cl_err3("ins","sfs_file",l_sfs.sfs01,l_sfs.sfs02,STATUS,"","ins sfs",1)  #No.FUN-660128
     LET g_success='N'
#FUN-B70074 --------------------Begin---------------------
  ELSE
     IF NOT s_industry('std') THEN
        #INITIALIZE l_sfsi.* TO NULL       #FUN-B70061 mark                 
        #LET l_sfsi.sfsi01 = l_sfs.sfs01   #FUN-B70061 mark
        #LET l_sfsi.sfsi02 = l_sfs.sfs02   #FUN-B70061 mark
        
        #FUN-B70061 --START--
        LET l_sql = "SELECT * FROM sfei_file",
                    " WHERE sfei02 = '", l_sfe.sfe02, "'",
                    " AND sfei28 = '", l_sfe.sfe28, "'"
        DECLARE sfei_cl CURSOR FROM l_sql
        OPEN sfei_cl 
        IF SQLCA.sqlcode THEN
           CALL cl_err("OPEN sfei_cl:", STATUS, 1)
           LET g_success='N'
        ELSE
           INITIALIZE l_sfsi.* TO NULL
           INITIALIZE l_sfei.* TO NULL 
           FETCH sfei_cl INTO l_sfei.*
           IF SQLCA.sqlcode THEN
              CALL cl_err('lock sfei_cl fail',STATUS,1)         
           LET g_success='N'
        ELSE 
              LET l_sfsi.sfsi01  = l_sfei.sfei02
              LET l_sfsi.sfsi02  = l_sfei.sfei28
              LET l_sfsi.sfsiicd028 = l_sfei.sfeiicd028
              LET l_sfsi.sfsiicd029 = l_sfei.sfeiicd029
              LET l_sfsi.sfsilegal = l_sfei.sfeilegal
              LET l_sfsi.sfsiplant = l_sfei.sfeiplant
              IF NOT s_ins_sfsi(l_sfsi.*,l_sfsi.sfsiplant) THEN
                 LET g_success='N'
        END IF   
           END IF
           CLOSE sfei_cl      
        END IF        
        #FUN-B70061 --END--    
        
        #IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN #FUN-B70061 mark          
        #   LET g_success='N'                            #FUN-B70061 mark
        #END IF                                          #FUN-B70061 mark
     END IF   
#FUN-B70074 --------------------End-----------------------
  END IF
  RETURN l_sfs.*
END FUNCTION
 
FUNCTION i501sub_z2_asr(p_argv1,l_sfp)
  DEFINE p_argv1 LIKE type_file.chr1
  DEFINE l_sfp   RECORD LIKE sfp_file.*
  DEFINE l_sfe RECORD LIKE sfe_file.*
  DEFINE l_sfs RECORD LIKE sfs_file.*
  
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE i501_z2_c1 CURSOR FOR
          SELECT * FROM sfe_file WHERE sfe02=l_sfp.sfp01
  FOREACH i501_z2_c1 INTO l_sfe.*
     IF STATUS THEN
        CALL cl_err('for sfe:',STATUS,1) LET g_success='N' EXIT FOREACH  
     END IF
 
     IF g_sma.sma115 = 'Y' THEN
        CALL i501sub_update_du('w',p_argv1,l_sfp.*,l_sfs.*,l_sfe.*)      #No.MOD-790112 add b_sfe
        IF g_success='N' THEN 
           LET g_totsuccess='N'
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
        END IF
     END IF
 
     CALL i501sub_z_update(p_argv1,l_sfe.*,1)
     IF g_success='N' THEN 
        LET g_totsuccess='N'
        LET g_success="Y"
        CONTINUE FOREACH   #No.FUN-6C0083
     END IF
  END FOREACH
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 
FUNCTION i501sub_chk_sfb04(p_sfb01,p_sfb04)    #bugno:6050 add
 DEFINE  p_sfb01         LIKE sfb_file.sfb01,
         p_sfb04         LIKE sfb_file.sfb04,
         l_sfs03         LIKE sfs_file.sfs03,
         l_sfb04         LIKE sfb_file.sfb04,
         l_cnt1,l_cnt2   LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
      LET l_cnt1 = 0
      LET l_cnt2 = 0

                 
      SELECT COUNT(DISTINCT sfp01) INTO l_cnt2
        FROM sfp_file,sfe_file
       WHERE sfe01 = p_sfb01
         AND sfp01 = sfe02
#        AND sfp01 != g_sfp.sfp01                          #TQC-A30091              
         AND (sfp01 != g_sfp01 AND g_sfp01 IS NOT NULL)    #TQC-A30091
         AND sfpconf !='X'  #FUN-660106
         
      IF cl_null(l_cnt1)  THEN LET l_cnt1 = 0 END IF
      IF cl_null(l_cnt2)  THEN LET l_cnt2 = 0 END IF
 
      #無此工單發料相關資料則將sfb04 update 為 2.工單已發放
      IF (l_cnt1+l_cnt2) = 0 THEN
         IF NOT cl_null(p_sfb04) AND p_sfb04 <= '4' THEN
            UPDATE sfb_file SET sfb04 = '2'
             WHERE sfb01 = p_sfb01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","upd_sfb04",1)  #No.FUN-660128
               LET g_success = 'N'
            END IF
         END IF
      END IF
END FUNCTION
 
#FUNCTION i501sub_x(p_sfp01,p_action_choice,p_call_transaction)           #CHI-D20010
FUNCTION i501sub_x(p_sfp01,p_action_choice,p_call_transaction,p_type)     #CHI-D20010 
   DEFINE p_sfp01 LIKE sfp_file.sfp01
   DEFINE p_action_choice STRING
   DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
   DEFINE l_sfp   RECORD LIKE sfp_file.*
   DEFINE l_cnt   LIKE  type_file.num5   #TQC-780029
   DEFINE l_flag  LIKE  type_file.num5   #FUN-810038   
   DEFINE l_sfs03 LIKE sfs_file.sfs03    #CHI-9A0020  
   DEFINE l_chr   LIKE type_file.chr1    #MOD-A40068 add
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag1   LIKE type_file.chr1  #CHI-D20010

   LET g_success='Y'

   IF s_shut(0) THEN LET g_success='N' RETURN END IF
 
   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
   
   #-->畫面上沒有發料單號不可作廢
   IF cl_null(l_sfp.sfp01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF #FUN-660134
   
   #-->確認不可作廢
   IF l_sfp.sfpconf = 'Y' THEN CALL cl_err('',9023,0) LET g_success='N' RETURN END IF #FUN-660106
 
   #FUN-AB0001 add str ---
   IF l_sfp.sfp15 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
      RETURN
   END IF
   IF l_sfp.sfpconf='Y' AND l_sfp.sfp15 = "1" AND l_sfp.sfpmksg = "Y"  THEN
      CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
      RETURN
   END IF
   #FUN-AB0001 add end ---

   IF l_sfp.sfp06 = '4' AND l_sfp.sfpconf <> 'X' THEN #FUN-920175
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM sfu_file WHERE sfu09 = l_sfp.sfp01
      IF l_cnt > 0 THEN
         CALL cl_err(l_sfp.sfp01,'asf-623',0)
         LET g_success='N' 
         RETURN
      END IF
   END IF

   IF l_sfp.sfpconf='X' THEN                                                                                                        
      DECLARE sfb28_cs CURSOR FOR                                                                                                   
        SELECT sfs03 FROM sfs_file WHERE sfs01=l_sfp.sfp01                                                                          
      FOREACH sfb28_cs INTO l_sfs03                                                                                                 
         LET l_cnt=0                                                                                                                
         SELECT COUNT(*) INTO l_cnt FROM sfb_file                                                                                   
          WHERE sfb01=l_sfs03 AND sfb28 IS NOT NULL                                                                                 
         IF l_cnt <> 0 THEN
            LET g_success='N'
            LET l_chr = '1'   #MOD-A40068 add
            EXIT FOREACH
         END IF
        #str MOD-A40068 add
        #未確認工單不可作廢還原
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM sfb_file
          WHERE sfb01=l_sfs03 AND sfb87!='Y'
         IF l_cnt <> 0 THEN
            LET g_success='N'
            LET l_chr = '2'
            EXIT FOREACH
         END IF
        #end MOD-A40068 add
      END FOREACH                                                                                                                   
      IF g_success='N' THEN 
        #str MOD-A40068 mod
        #CALL cl_err(l_sfs03,'asf-833',0)
         IF l_chr = '1'  THEN
            CALL cl_err(l_sfs03,'asf-833',0)
         ELSE
            CALL cl_err(l_sfs03,'asf-830',0)
         END IF
        #end MOD-A40068 mod
         RETURN
      END IF   
   END IF                                                                                                                           

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF l_sfp.sfpconf='X' THEN RETURN END IF
   ELSE
      IF l_sfp.sfpconf<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
 
   CALL i501sub_lock_cl()
 
   OPEN i501sub_cl USING l_sfp.sfp01
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   FETCH i501sub_cl INTO l_sfp.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i501sub_cl
      LET g_success='N'
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      RETURN
   END IF
 
   IF s_industry('icd') THEN
      #若已有ida/idb詢問且一併刪
      LET l_cnt = 0 
     #CASE WHEN l_sfp.sfp06 = '1' #CHI-A70060 mark
      CASE WHEN l_sfp.sfp06 MATCHES '[1234D]' #CHI-A70060   #FUN-C70014 add 'D'
                SELECT COUNT(*) INTO l_cnt FROM idb_file
                 WHERE idb07 = l_sfp.sfp01
          #WHEN l_sfp.sfp06 = '6' #CHI-A70060 mark
           WHEN l_sfp.sfp06 MATCHES '[6789]' #CHI-A70060
                SELECT COUNT(*) INTO l_cnt FROM ida_file
                 WHERE ida07 = l_sfp.sfp01
      END CASE
      IF l_cnt > 0 THEN
         #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作?
         IF NOT cl_null(p_action_choice) THEN
            IF NOT cl_confirm('aic-112') THEN
               CLOSE i501sub_cl
               IF p_call_transaction THEN
                  ROLLBACK WORK
               END IF
               LET g_success='N'
               RETURN
            END IF
         END IF
 
        #CASE WHEN l_sfp.sfp06 = '1' #CHI-A70060 mark
         CASE WHEN l_sfp.sfp06 MATCHES '[1234D]' #CHI-A70060  #FUN-C70014 add 'D'
                   CALL s_icdinout_del(-1,l_sfp.sfp01,'','')  #FUN-B80119--傳入p_plant參數''---
                        RETURNING l_flag
             #WHEN l_sfp.sfp06 = '6' #CHI-A70060 mark
              WHEN l_sfp.sfp06 MATCHES '[6789]' #CHI-A70060
                   CALL s_icdinout_del(1,l_sfp.sfp01,'','')   #FUN-B80119--傳入p_plant參數''---
                        RETURNING l_flag
         END CASE
         IF l_flag = 0 THEN
            CLOSE i501sub_cl
            IF p_call_transaction THEN
               ROLLBACK WORK
            END IF
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
 
   IF NOT cl_null(p_action_choice) THEN
      #IF NOT cl_void(0,0,l_sfp.sfpconf) THEN #FUN-660106   #CHI-D20010
       IF p_type = 1 THEN LET l_flag1 = 'N' ELSE LET l_flag1 = 'X' END IF    #CHI-D20010
       IF NOT cl_void(0,0,l_flag1) THEN                                     #CHI-D20010 
         CLOSE i501sub_cl
         IF p_call_transaction THEN
            ROLLBACK WORK
         END IF
         LET g_success='N'
         RETURN
      END IF
   END IF
 
  #IF l_sfp.sfpconf ='N' THEN  #FUN-660106              #CHI-D20010
   IF p_type = 1 THEN                                   #CHI-D20010
       LET l_sfp.sfpconf= 'X'  #FUN-660106
       LET l_sfp.sfp15  = '9'  #FUN-AB0001 add
       IF l_sfp.sfp06 = '4' THEN
          LET l_cnt = 0 
          SELECT COUNT(*) INTO l_cnt FROM sfu_file
           WHERE sfu09 = l_sfp.sfp01
          IF l_cnt > 0 THEN
             UPDATE sfu_file SET sfu09 = NULL
              WHERE sfu09 = l_sfp.sfp01
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfu_file",l_sfp.sfp01,"",STATUS,"","upd sfu",1) 
                LET g_success = 'N'
             END IF
          END IF
         #MOD-AA0017---add---start---
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM rvu_file
           WHERE rvu16 = l_sfp.sfp01
          IF l_cnt > 0 THEN
             UPDATE rvu_file SET rvu16 = NULL
              WHERE rvu16 = l_sfp.sfp01
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","rvu_file",l_sfp.sfp01,"",STATUS,"","upd rvu",1)
                LET g_success = 'N'
             END IF 
          END IF 
         #MOD-AA0017---add---end---
       END IF
      #MOD-AA0077---add---start---
       IF l_sfp.sfp06 = 'C' THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM srf_file
           WHERE srf06 = l_sfp.sfp01
          IF l_cnt > 0 THEN
             UPDATE srf_file SET srf06 = NULL
              WHERE srf06 = l_sfp.sfp01
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","srf_file",l_sfp.sfp01,"",STATUS,"","upd srf",1)  #No.FUN-660128
                LET g_success = 'N'
             END IF
          END IF
       END IF
      #MOD-AA0077---add---end---
   ELSE
       LET l_sfp.sfpconf='N'    #FUN-660106
       LET l_sfp.sfp15  ='0'    #FUN-AB0001 add
   END IF
   LET l_sfp.sfpmodu=g_user     #NO:6908
   LET l_sfp.sfpdate=g_today    #NO:6908
   UPDATE sfp_file
       SET sfpconf=l_sfp.sfpconf,   #FUN-660106
           sfpmodu=l_sfp.sfpmodu,
           sfpdate=l_sfp.sfpdate
          ,sfp15  =l_sfp.sfp15      #FUN-AB0001 add
       WHERE sfp01  =l_sfp.sfp01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       LET g_success = 'N' #FUN-920175 add
   END IF
 
   CLOSE i501sub_cl
 
   IF g_success = 'Y'THEN
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
      CALL cl_flow_notify(l_sfp.sfp01,'V')
   ELSE
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF
 
END FUNCTION
#  No.FUN-9C0073-----------By  chenls    10/01/04

#FUN-9A0095 add --------------------
FUNCTION i501_mes(p_key1,p_key2)
   DEFINE p_key1   LIKE type_file.chr10
   DEFINE p_key2   LIKE type_file.chr500

   # CALL aws_mescli
   # 傳入參數: (1)程式代號
   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
   #           (3)Key
   CASE aws_mescli(p_key1,'delete',p_key2)
     WHEN 1        #呼叫 MES 成功
         MESSAGE 'UNDO POST O.K, UNDO POST MES O.K'
         LET g_success = 'Y'
     WHEN 2        #呼叫 MES 失敗
         LET g_success = 'N'
     OTHERWISE     #其他異常
         LET g_success = 'N'
   END CASE
END FUNCTION
#FUN-9A0095 add end ----------------

#No.TQC-B80182  --Begin
FUNCTION i501sub_disassemble(p_sfp01,p_type)
   DEFINE p_sfp01      LIKE sfp_file.sfp01
   DEFINE p_type       LIKE type_file.chr1
   DEFINE l_sfq02_11   LIKE sfq_file.sfq02
   DEFINE l_sfq03_11   LIKE sfq_file.sfq03
   DEFINE l_sfb081_11  LIKE sfb_file.sfb081
   DEFINE l_cnt        LIKE type_file.num10

   #拆件式工单若有入库的时候,要卡一定有发料,至于发多少,不管控
   DECLARE i501_11_sfq02_cs CURSOR FOR
    SELECT sfq02,SUM(sfq03),sfb081 FROM sfq_file,sfb_file
    WHERE sfq02 = sfb01
      AND sfq01 = p_sfp01
      AND sfb02 = '11'
    GROUP BY sfq02,sfb081
   FOREACH i501_11_sfq02_cs INTO l_sfq02_11,l_sfq03_11,l_sfb081_11
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ksd_file,ksc_file
       WHERE ksc01 = ksd01
         AND ksd11 = l_sfq02_11
         AND kscconf <> 'X'
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt <= 0 THEN
         CONTINUE FOREACH
      END IF
      IF l_sfb081_11 - l_sfq03_11 <= 0 THEN
         IF p_type = '1' THEN
            #拆件工单已有入库资料,故本单发料不可取消过帐还原
            CALL cl_err(l_sfq02_11,'asf-261',1)
         ELSE
            #拆件工单已有入库资料,故本单退料不可过帐
            CALL cl_err(l_sfq02_11,'asf-262',1)
         END IF
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#No.TQC-B80182  --End


#FUN-C10035 add str ------
FUNCTION i501_sub_chk_sfb01(p_sfb01,p_cnt)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE p_cnt     SMALLINT


       SELECT sfb02 INTO g_sfb02
         FROM sfb_file
        WHERE sfb01 = p_sfb01

       IF p_cnt = 1 THEN
         #紀錄第一筆工單是否屬於與MES整合(紀錄舊值與初始化)
          IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN   #FUN-CC0122 add g_sfb02 = '5'
             LET g_mesflag_t = 'Y'                 #屬於與MES整合的工單型態
             LET g_mesflag = 'Y'
          ELSE
             LET g_mesflag_t = 'N'                 #非與MES整合的工單型態
             LET g_mesflag = 'N'
          END IF
       ELSE
          IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN    #FUN-CC0122 add g_sfb02 = '5'
             LET g_mesflag = 'Y'
          ELSE
             LET g_mesflag = 'N'
          END IF
       END IF
END FUNCTION
#FUN-C10035 add end ------
#CHI-C80013 str add-----
FUNCTION i501sub_aimp880()

    LET g_aimp880 = 'Y'

END FUNCTION
#CHI-C80013 end add-----
                              
#DEV-D40013 add

#str----add by guanyao160720
FUNCTION i501sub_un_imm(p_sfp01)
DEFINE p_sfp01     LIKE sfp_file.sfp01
DEFINE l_x         LIKE type_file.num5
DEFINE l_imm01     LIKE imm_file.imm01
DEFINE l_imm03     LIKE imm_file.imm03
DEFINE l_imm       RECORD LIKE imm_file.*
DEFINE l_ccz       RECORD LIKE ccz_file.*
DEFINE l_count     LIKE type_file.num5
DEFINE l_yy,l_mm   LIKE type_file.num5

     LET l_x = 0 
     SELECT COUNT(*) INTO l_x FROM imm_file WHERE imm09 = p_sfp01
     IF l_x >0 THEN 
        LET l_imm03 =''
        LET l_imm01 = ''
        SELECT imm03,imm01 INTO l_imm03,l_imm01 FROM imm_file WHERE imm09 = p_sfp01
        IF l_imm03 != 'Y' THEN 
           CALL cl_err('','aim-206',0)
           LET g_success ='N'
           RETURN 
        END IF 
        SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = l_imm01
        LET l_count = 0 
        SELECT COUNT(*) INTO l_count 
          FROM oga_file
         WHERE oga70 = l_imm.imm01  
        #FUN-BC0062 ---------Begin--------
        #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
        SELECT ccz_file.* INTO l_ccz.* FROM ccz_file WHERE ccz00='0'
        IF l_ccz.ccz28  = '6' AND g_success = 'Y' THEN  #TQC-D40005 add
           CALL cl_err('','apm-936',1)
           LET g_success = 'N' 
           RETURN 
        END IF   
           #---NO.CHI-780041 start---非借貨出貨單來源之調撥單才可以過帳還原
        IF l_count <> 0 THEN                 #CHI-870036 Add "OR g_count <> 0"
           CALL cl_err('','aim1008',1)
           LET g_success = 'N'           #No.TQC-9B0120
           RETURN 
        ELSE  
           IF l_imm.imm03 = 'N' THEN
              CALL cl_err('','aim-206',0)
              LET g_success = 'N'           #No.TQC-9B0120
              RETURN 
           END IF                           #No.TQC-9B0120
           IF g_sma.sma53 IS NOT NULL AND l_imm.imm17 <= g_sma.sma53 THEN  #FUN-D40053
              CALL cl_err('','mfg9999',0)
              LET g_success = 'N'
              RETURN 
           END IF
           CALL s_yp(l_imm.imm17) RETURNING l_yy,l_mm  #FUN-D40053
           IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
              CALL cl_err(l_yy,'mfg6090',0)
              LET g_success = 'N'
              RETURN 
           ELSE
              IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
                 CALL cl_err(l_mm,'mfg6091',0)
                 LET g_success = 'N' 
                 RETURN 
              END IF
           END IF                                              
           IF g_success = 'Y' THEN         
              CALL p378_s1(l_imm.imm01,'Y') 
              IF g_success ='Y' THEN 
                 CALL i501sub_imm_z(l_imm.imm01)
                 IF g_success = 'Y' THEN 
                    CALL i501sub_imm_r(l_imm.imm01)
                 END IF 
              END IF 
           ELSE 
              LET g_success = 'N'
              RETURN 
           END IF   
        END IF       
     END IF 
END FUNCTION 

FUNCTION i501sub_imm_z(p_imm01)
   DEFINE l_cnt     LIKE type_file.num5      #FUN-680010  #No.FUN-690026 SMALLINT
   DEFINE p_imm01   LIKE imm_file.imm01
   DEFINE l_imm     RECORD LIKE imm_file.*

   SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01
   IF l_imm.immconf='N' THEN 
      CALL cl_err('','9025',1) 
      LET g_success = 'N'
      RETURN 
   END IF
   IF l_imm.immconf = 'X' THEN 
      CALL cl_err(' ','9024',0) 
      LET g_success = 'N'
      RETURN 
   END IF
   #-->已有QC單則不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = l_imm.imm01 AND qcs00='C'  
      AND qcs14 <> 'X'         #MOD-AB0161 add
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_imm.imm03='Y' THEN
      CALL cl_err('imm03=Y:','afa-101',0)
      LET g_success = 'N'
      RETURN
   END IF

   #FUN-AC0074--begin--add----
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM sie_file
     WHERE sie05=l_imm.imm01
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-248',0)
       LET g_success = 'N'
       RETURN
    END IF
    #FUN-AC0074--end--add----
   LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t324_cl CURSOR FROM g_forupd_sql
   OPEN t324_cl USING l_imm.imm01  
   IF STATUS THEN
      CALL cl_err("OPEN t324_cl:", STATUS, 1)
      CLOSE t324_cl
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t324_cl INTO l_imm.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t324_cl 
      LET g_success = 'N'
      RETURN
   END IF
   UPDATE imm_file 
      SET immconf = 'N',
          imm15 = '0'  #FUN-A60034 add
    WHERE imm01 = l_imm.imm01 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
      RETURN 
   END IF

   IF g_success = 'N' THEN 
      RETURN 
   END IF
   
   CLOSE t324_cl          #MOD-AA0103 add
END FUNCTION

FUNCTION i501sub_imm_r(p_imm01)
DEFINE l_imm    RECORD LIKE imm_file.*
DEFINE p_imm01  LIKE imm_file.imm01
DEFINE l_i      LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5

     SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01
###############删除
    IF l_imm.imm15 MATCHES '[Ss]' THEN
       CALL cl_err('','aws-200',0) #送簽中,不可刪除資料
       LET g_success = 'N'
       RETURN
    END IF

    LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t324_cl_r CURSOR FROM g_forupd_sql
    OPEN t324_cl_r USING l_imm.imm01    
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)
       LET g_success = 'N'
       RETURN
    ELSE
       FETCH t324_cl_r INTO l_imm.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = l_imm.imm01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
    CALL cl_msg("Delete imm,imn!")
    DELETE FROM imm_file WHERE imm01 = l_imm.imm01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("del","imm_file",l_imm.imm01,"",SQLCA.sqlcode,
                    "No imm deleted","",1)   #NO.FUN-640266 #No.FUN-660156
       LET g_success = 'N'
       RETURN
    END IF
    LET l_count = 0
    SELECT COUNT(*) INTO l_count FROM imn_file WHERE imn01 = l_imm.imm01
    DELETE FROM imn_file WHERE imn01 = l_imm.imm01 
    #FOR l_i = 1 TO l_count
    #   IF NOT s_lot_del(g_prog,l_imm.imm01,'',0,g_imn[l_i].imn03,'DEL') THEN     #TQC-B90236 add         
    #      LET g_success = 'N'
    #      RETURN  
    #   END IF
    #   IF NOT s_lot_del(g_prog,l_imm.imm01,'',0,g_imn[l_i].imn03,'DEL') THEN     #TQC-B90236 add
    #      ROLLBACK WORK
    #      RETURN  
    #   END IF
    #END FOR
    UPDATE rmd_file SET rmd34=NULL WHERE rmd34=l_imm.imm01   #MOD-A40161 #從後面往前移
    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
    VALUES ('aimt324',g_user,g_today,g_msg,l_imm.imm01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
    CLOSE t324_cl_r
END FUNCTION 
#end----add by guanyao160720
#str----add by guanyao160601
#FUNCTION i501_ins_sel(p_sfp01)          #mark by guanyao170110
FUNCTION i501_ins_sel(p_sfp01,p_sfp03)   #add by guanyao170110
DEFINE l_sql      STRING 
DEFINE l_imm      RECORD LIKE imm_file.*
DEFINE l_imn      RECORD LIKE imn_file.*
DEFINE l_sfs   RECORD 
     sfs04        LIKE sfs_file.sfs04,
     sfs05        LIKE sfs_file.sfs05,
     sfs06        LIKE sfs_file.sfs06,
     sfs07        LIKE sfs_file.sfs07,
     sfs08        LIKE sfs_file.sfs08,
     sfs09        LIKE sfs_file.sfs09,
     sfs10        LIKE sfs_file.sfs10,
     sfsud02      LIKE sfs_file.sfsud02,
     sfsud07      LIKE sfs_file.sfsud07
     END RECORD 
DEFINE l_img10    LIKE img_file.img10
DEFINE l_img10_1  LIKE img_file.img10
DEFINE l_qty_1    LIKE type_file.num10
DEFINE l_qty      LIKE type_file.num15_3
DEFINE l_ima64    LIKE ima_file.ima54
DEFINE l_sfs05    LIKE sfs_file.sfs05 
DEFINE li_result  LIKE type_file.num5
DEFINE l_seq      LIKE type_file.num5
DEFINE l_slip     LIKE smy_file.smyslip
DEFINE l_ima24    LIKE ima_file.ima24
DEFINE l_sfp      RECORD LIKE sfp_file.*
DEFINE p_sfp01    LIKE sfp_file.sfp01
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_ima55_fac  LIKE ima_file.ima55_fac
DEFINE p_sfp03    LIKE sfp_file.sfp03      #add by guanyao170110
   
   IF p_sfp01 IS NULL THEN 
      CALL cl_err("",-400,0)  
      RETURN
   END IF 

   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
   IF l_sfp.sfpconf = 'N' THEN
      CALL cl_err(l_sfp.sfp01,'9029',0)
      RETURN
   END IF
   IF l_sfp.sfp04 = 'Y' THEN
      CALL cl_err(l_sfp.sfp01,'csf-012',0) 
      RETURN
   END IF

   #BEGIN WORK 
   LET g_success = 'Y'
   SELECT smyslip INTO l_slip FROM smy_file WHERE smysys = 'aim' AND smykind ='4' 
   IF cl_null(l_slip) THEN 
      RETURN 
   END IF 
   #CALL s_auto_assign_no("aim",l_slip,g_today,"","imm_file","imm01","","","")   #mark by guanyao170110
   CALL s_auto_assign_no("aim",l_slip,p_sfp03,"","imm_file","imm01","","","")    #add by guanyao1700110
      RETURNING li_result,l_imm.imm01
   IF (NOT li_result) THEN
      LET g_success = 'N'
   END IF
   LET l_imm.imm15 = '0'       
   LET l_imm.immmksg = "N"               
   LET l_imm.imm16 = g_user
   #LET l_imm.imm02  =g_today               #mark by guanyao160901
   #LET l_imm.imm17  =g_today  #FUN-D40053  #mark by guanyao160901
   #LET l_imm.imm02=l_sfp.sfp03              #add by guanyao160901   #mark by guanyao170110
   #LET l_imm.imm17=l_sfp.sfp03              #add by guanyao160901   #mark by guanyao170110
   LET l_imm.imm02=p_sfp03                  #add by guanyao170110
   LET l_imm.imm17=p_sfp03                  #add by guanyao170110
   LET l_imm.imm03  = 'N'
   LET l_imm.imm09  = l_sfp.sfp01
   LET l_imm.immconf= 'N' #FUN-660029
   LET l_imm.immspc = '0' #FUN-680010
   LET l_imm.imm10  = '1'   #FUN-BC0036
   LET l_imm.imm14  = ''
   SELECT gen03 INTO l_imm.imm14 FROM gen_file WHERE gen01=g_user
   IF cl_null(l_imm.imm14) THEN
      LET l_imm.imm14  = g_grup
   END IF
   LET l_imm.immuser=g_user
   LET l_imm.immoriu = g_user 
   LET l_imm.immorig = g_grup 
   LET l_imm.immgrup=g_grup
   LET l_imm.immdate=g_today
   LET l_imm.immplant = g_plant
   LET l_imm.immlegal = g_legal   
   LET l_imm.imm12=''          
   LET l_imm.immacti = 'Y'
   INSERT INTO imm_file VALUES (l_imm.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","imm_file",l_imm.imm01,"",SQLCA.sqlcode,"",
                   "ins imm",1) 
      LET g_success = 'N' 
   END IF 

   LET l_seq= 1
   LET l_sql = "SELECT sfs04,sfs05,sfs06,sfs07,sfs08,sfs09,sfs10,sfsud02,sfsud07 FROM sfs_file WHERE sfs01 = '",l_sfp.sfp01,"'"
   PREPARE i501_sfs04_pre1_1 FROM l_sql
   DECLARE i501_sfs04_curs1_1 CURSOR FOR i501_sfs04_pre1_1
   FOREACH i501_sfs04_curs1_1 INTO l_sfs.*
      IF STATUS THEN
         ROLLBACK WORK  
         RETURN 
      END IF
      #str-----add by guanyao160720
      IF l_sfs.sfs07 = l_sfs.sfsud02 THEN 
         CONTINUE FOREACH 
      END IF 
      #end-----add by guanyao160720
      LET l_img10 =0
      SELECT SUM(img10) INTO l_img10 FROM img_file WHERE img01=l_sfs.sfs04 AND img02=l_sfs.sfs07
      IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
      #IF l_img10 < l_sfs.sfs05 THEN  #mark by guanyao160720
      IF l_sfs.sfsud07 > 0 THEN 
         #str-----mark by guanyao160720
         #LET l_img10_1 = l_sfs.sfs05-l_img10
         #SELECT ima64 INTO l_ima64 FROM ima_file WHERE ima01 = l_sfs.sfs04
         #IF cl_null(l_ima64) OR l_ima64= 0 THEN 
         #   LET l_ima64 = 1
         #END IF 
         #LET l_qty = l_img10_1/l_ima64
         #SELECT TRUNC(l_img10_1/l_ima64) INTO l_qty_1 FROM dual
         #IF l_qty_1 = l_qty THEN 
         #   LET l_sfs05 = l_img10_1
         #ELSE 
         #   LET l_sfs05 = l_ima64*(l_qty_1+1)
         #END IF 
         #end-----mark by guanyao160720
         LET l_sfs05 = l_sfs.sfsud07  #add by guanyao160720
         IF cl_null(l_sfs05) THEN 
            CALL cl_err('','csf-013',0)
            EXIT FOREACH
            LET g_success = 'N'  
         END IF
          
         LET l_imn.imn01 = l_imm.imm01 #TQC-9B0031
         LET l_imn.imn03 = l_sfs.sfs04
         LET l_imn.imn04 = l_sfs.sfsud02
         LET l_imn.imn05 = l_sfs.sfs08   #add by guanyao160803
         #LET l_imn.imn05 = ' '            #add by guanyao160803
         LET l_imn.imn06 = l_sfs.sfs09  
         #str---add by guanyao160829
         SELECT ima25,ima55_fac INTO l_imn.imn09,l_ima55_fac FROM ima_file 
           WHERE ima01 = l_sfs.sfs04  #add by guanyao160829 
         
         LET l_imn.imn20 = l_imn.imn09
         #LET l_imn.imn09 = l_sfs.sfs06
         #LET l_imn.imn20 = l_imn.imn09
         #end---add by guanyao160829
         IF cl_null(l_ima55_fac) THEN LET l_ima55_fac = 1 END IF
         LET l_sfs05 = l_sfs05 * l_ima55_fac #转换率
         LET l_imn.imn10 = l_sfs05 
         LET l_imn.imn22 = l_sfs05
         LET l_imn.imn10 =s_digqty(l_imn.imn10, l_imn.imn09)  #FUN-D50028
         LET l_imn.imn22 =s_digqty(l_imn.imn22, l_imn.imn20)  #FUN-D50028
         #SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_sfs.sfs04
         #IF cl_null(l_ima24) THEN 
         #   LET l_ima24 = 'N'
         #END IF 
         LET l_imn.imn29 = 'N'
         SELECT MAX(imn02) INTO l_imn.imn02 FROM imn_file
          WHERE imn01 = l_imn.imn01
         IF cl_null(l_imn.imn02) THEN
            LET l_imn.imn02 = 0
         END IF 
         LET l_imn.imn02=l_imn.imn02+1 
         LET l_imn.imn21 = 1
         LET l_imn.imn27 = 'N'                                                                                             
         LET l_imn.imn15 = l_sfs.sfs07
         #LET l_imn.imn16 = l_sfs.sfs08   #mark by guanyao160803
         #LET l_imn.imn16 = ' '            #add by guanyao160803
         SELECT ecd07 INTO l_imn.imn16 FROM ecd_file WHERE ecd01=l_sfs.sfs10
         IF cl_null(l_imn.imn16) THEN LET l_imn.imn16 = ' ' END IF
         LET l_imn.imn17 = l_sfs.sfs09         
         LET l_imn.imn28 = ''
         LET l_imn.imnplant = g_plant 
         LET l_imn.imnlegal = g_legal 
         IF cl_null(l_imn.imn05) THEN LET l_imn.imn05 = ' ' END IF  #TQC-9B0031
         IF cl_null(l_imn.imn06) THEN LET l_imn.imn06 = ' ' END IF  #TQC-9B0031
         IF cl_null(l_imn.imn16) THEN LET l_imn.imn16 = ' ' END IF  #TQC-9B0031
         IF cl_null(l_imn.imn17) THEN LET l_imn.imn17 = ' ' END IF  #TQC-9B0031
         INSERT INTO imn_file VALUES(l_imn.*)                     
         IF SQLCA.SQLCODE THEN                                     
            CALL cl_err3("ins","imn_file",l_imn.imn01,"",SQLCA.sqlcode,"",
                         "ins imn",1)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
         LET l_seq = l_seq+1                  
      END IF  
   END FOREACH
   IF l_seq =  1 THEN 
      #LET g_success = 'N'  #mark by guanyao160802
      #DELETE FROM imm_file WHERE imm01 = l_imn.imn01  #mark by guanyao160825
      DELETE FROM imm_file WHERE imm01 = l_imm.imm01   #add by guanyao160825
      RETURN 
   END IF 

   IF g_success = 'Y' THEN 
      CALL t324sub_y_chk(l_imm.imm01) 
      IF g_success='Y' THEN
         CALL t324sub_y_upd(l_imm.imm01,"confirm",TRUE)
         IF g_success = 'Y' THEN 
            CALL t324sub_s(l_imm.imm01,'','',TRUE)
         END IF 
      END IF
   END IF 
   CALL s_showmsg()
   IF g_success = 'Y' THEN 
      #CALL cl_cmmsg(1)
      #COMMIT WORK 
      CALL cl_get_feldname('imm01', g_lang) RETURNING g_msg
      CALL cl_show_array(base.TypeInfo.CREATE(l_imm.imm01), g_msg, g_msg)
   ELSE 
   #   CALL cl_rbmsg(1)
   #   ROLLBACK WORK 
      RETURN 
   END IF 
   
END FUNCTION 
#end----add by guanyao160601
#str----add by guanyao160804
--FUNCTION i501_upd_sfs(p_sfp01)
--DEFINE p_sfp01    LIKE sfp_file.sfp01
--DEFINE l_sql      STRING 
--
    --DROP TABLE l_sfs_tmp
    --CREATE TEMP TABLE l_sfs_tmp(
       --sfs01_tmp       VARCHAR(20),
       --sfs02_tmp       SMALLINT,
       --sfs04_tmp       VARCHAR(40),
       --sfs05_tmp       DECIMAL(15,3),
       --sfsud07_tmp     DECIMAL(15,3))    
--
    --DELETE FROM l_sfs_tmp
    --INSERT INTO l_sfs_tmp SELECT x.* FROM 
     --(SELECT sfs01,sfs02,sfs04,sfs05,sfsud07 FROM sfs_file WHERE sfs01 = p_sfp01 ORDER BY sfs02) x
    --LET l_sql = "SELECT * FROM l_sfs_tmp ORDER BY sfs02"
    --PREPARE i501_sfs_ins FROM l_sql
    --
--END FUNCTION 
#end----add by guanyao160804
