# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft803.4gl
# Descriptions...: 工單單身變更作業
# Date & Author..: 03/03/20 By Carol   #MODNO:6896  for 養生計划
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位用like方式
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0048 06/11/13 By kim 14項測試問題修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0020 06/12/05 By sarah 此程式僅供大陸使用,尚未正式提供,僅供測試
# Modify.........: No.FUN-710026 07/01/26 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-740158 07/04/27 By kim 6項測試問題修改
# Modify.........: No.FUN-750003 07/05/02 By kim 若工單形態='7' (委外工單) ,'8'(委外再加工單)不可變更 snb82a(部門廠商)
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760120 07/06/20 By rainy 變更發出沒更新料號
# Modify.........: No.TQC-790064 07/09/11 By xiaofeizhu 查詢時，狀態攔位是灰色的，不可用
# Modify.........: No.TQC-7C0012 07/12/04 By lumxa   工單變更單的狀態為修改時，系統用變更后的料號去更新SFA_FILE,錯誤
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-810119 08/03/24 By Pengu 變更發料料號時，BOM料號欄位未一起變更
# Modify.........: No.MOD-7B0170 08/03/25 By Pengu 1.替代率不應default值
#                                                  2.替代碼為[346]時才可變更替代率
# Modify.........: No.MOD-840016 08/04/08 By Pengu 檢查料件是否存在BOM中時未考慮未考慮sma887[1]='N'不檢查
# Modify.........: No.MOD-840410 08/04/21 By Pengu 已有完工入庫數量的工單，應該不允許變更
# Modify.........: No.FUN-840068 08/04/22 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-850128 08/05/16 By claire 走製程的工單,變更生產數量,要回寫到製程的良品轉入量(ecm301)
# Modify.........: No.MOD-850278 08/05/27 By claire s_showmsg()需使用才能將錯誤顯示
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.MOD-830205 08/07/04 By Pgengu 單身新增元件時經過"替代率'欄位會將數量清空
# Modify.........: No.FUN-870051 08/07/18 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.FUN-870092 08/08/15 By Mandy 平行加工
# Modify.........: No.FUN-870101 08/08/21 By jamie MES整合
# Modify.........: No.MOD-880069 08/08/08 By claire 委外工單且sfb39=1(撿料)才不可變更
# Modify.........: No.MOD-880149 08/08/20 By claire 變更生產數量應考慮發料單位批量及最小發料數量
# Modify.........: No.MOD-890125 08/09/12 By claire 變更備料數量應考慮發料單位批量及最小發料數量
# Modify.........: No.MOD-850143 08/05/13 By chenl 修正單頭變更前數量顯示錯誤的問題。
# Modify.........: No.MOD-890289 08/09/29 By claire 以SET取替代方式的備料調整應發數應重計QPA
# Modify.........: No.TQC-890064 08/09/30 By Mandy 資源項次0的部分,應該可以變更(日期),但不能刪除
# Modify.........: No.TQC-890064 08/09/30 By Mandy 平行加工非0的項次全刪光時,ecm61(平行加工否)欄位應變N,且項次為0的資料(vlj_file)應砍掉
# Modify.........: No.TQC-8A0013 08/10/08 By Mandy 平行加工變更時=>新增資源:(1)需同步增加vne_file (2)重新計算vne06的值
#                                                                  刪除資源:(1)需同步刪除vne_file (2)重新計算vne06的值
# Modify.........: No.MOD-8A0097 08/10/13 BY claire  變更前數量不應重取
# Modify.........: No.MOD-8A0099 08/10/13 By chenl   增加錯誤信息報錯點及修正函數返回不關閉cursor及事務。
# Modify.........: No.MOD-8A0179 08/10/21 By chenyu 單身替代率變更后沒有更新
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.MOD-8B0145 08/11/14 By clover  LET l_sna.sna06a應於l_sna.sna05a取完小數位後再給值
# Modify.........: No.MOD-8C0036 08/12/04 By claire 變更料號若已存在sfs_file,sfe_file則不允許變更
# Modify.........: No.MOD-8C0077 08/12/09 By sherry 變更發出時，應判斷最早入庫日期與關帳日期的大小
# Modify.........: No.MOD-8C0111 08/12/11 By sherry Fix sfa27問題
# Modify.........: No.FUN-8B0095 08/12/16 By jan 增加判斷即使 成本已關帳,但該工單仍未 發料,入庫 ,仍可變更
# Modify.........: No.MOD-8C0254 08/12/25 By chenyu BEFORE FIELD snb022后面的判斷應該用l_n
# Modify.........: No.MOD-910072 09/01/07 By claire 變更料號若已存在sfs_file,sfe_file則不允許變更(控制by料號)
# Modify.........: No.MOD-910151 09/01/14 By claire 變更發出前要再確認變更數量是否小於發料套數
# Modify.........: No.MOD-910228 09/01/20 By claire 變更數量重計超領量未考慮最小發料數量
# Modify.........: No.MOD-920167 09/02/12 By claire 變更替代量應控卡應發不可小於已發
# Modify.........: No.MOD-920180 09/02/13 By chenyu 變更發出前要檢查是否存在未過賬的發料，退料單
# Modify.........: No.FUN-920208 09/03/06 By sabrina 與EasyFlow整合
# Modify.........: No.MOD-930054 09/03/13 By Pengu 更新超領量時應考慮已發數量和理性
# Modify.........: No.MOD-930118 09/03/31 By chenyu 如果沒有變更料號，變更單位，取轉換率的時候應該用變更前的料號
# Modify.........: No.FUN-940008 09/05/04 By hongmei GP5.2發料改善
# Modify.........: No.MOD-930226 09/05/25 By Pengu 無l_sfa.sfa12與l_sfa.sfa03變數
# Modify.........: No.MOD-940036 09/05/25 By Pengu 無法正確顯示單頭變更前的數量
# Modify.........: No.MOD-930248 09/05/25 By Pengu 實際qpa（sna161a）欄位應加檢查應考慮發料備數
# Modify.........: No.MOD-950223 09/05/25 By mike 目前系統無法對SCROLLGRID物件會出excel所以請調整將asft803的匯出EXCEL action給取消
# Modify.........: No.MOD-950266 09/06/01 By mike 請在AFTER FIELD sna28a(替代率)判斷替代率是否小於等于0，若小於等于0則不允許
# Modify.........: No.MOD-960267 09/06/23 By lilingyu 變更發出時即定義g_success = 'Y'
# Modify.........: No.CHI-950047 09/07/17 By jan 如果替代料(或主料)由"消耗性料件"變更為"一般料件"或由"一般料件"變更為"消耗性料件"時，
# .............................................. 請檢查此工單之備料若存在其主料(或替代料) 則主料和替代料的來源特性需一致
# Modify.........: No.TQC-970377 09/08/07 作業編號錄入無效值,未加控管
# Modify.........: No.FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980140 09/08/18 By Carrier 單身錄入時,檢查錄入的內容會不會造成"發出"后的重復問題
# Modify.........: No.MOD-980153 09/08/20 By Smapmin 單頭變更前的資料應該維持該次變更前的資料
# Modify.........: No.FUN-970114 09/08/21 By mike 請改寫asf-243錯誤訊息的判斷，將錯誤訊息呈現所有未過帳的單據號碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990150 09/10/08 By Smapmin 當工單型態是倒扣料時，則工單變更單身的料件來源碼應為"E:消耗性料件"
# Modify.........: No:CHI-990024 09/10/27 By Smapmin 工單變更若輸入數量為0, 會卡不可小於最少發料數量, 將此控管以開窗方式詢問
# Modify.........: No.CHI-960054 09/11/02 By jan 1：畫面修改2：新增 審核 取消審核 作廢 action
# Modify.........: No.CHI-980013 09/11/02 By jan sna11b/sna11a 的combobox.item加上"X:資訊參考"
# Modify.........: No.FUN-980045 09/11/02 By jan snb82a 增加開窗功能
# Modify.........: No.TQC-990054 09/11/02 By jan 程式調整
# Modify.........: No.FUN-990059 09/11/02 By jan 單身新增替代碼欄位
# Modify.........: No.CHI-970059 09/11/02 By jan 備料變更后，同一張工單，sfa03不可重復
# Modify.........: No:MOD-960041 09/11/27 By sabrina 在計算應發數量時在考慮生產批量時應排除應發量為0的部分
# Modify.........: No:MOD-960246 09/11/27 By sabrina 重推開工與完工日時位檢核工作日
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9C0040 10/02/01 By jan 回收料不可變更
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A10013 10/03/15 By Lilan EasyFlow(EF)自動確認功能
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A20037 10/04/02 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:MOD-A30062 10/04/07 By Summer 變更套數時,應發量計算公式有誤,應改為變更套數*QPA
# Modify.........: No:MOD-A30186 10/04/07 By Summer 1.a()段自動產生單身的程式段移到一個新FUNCTION t803_g_b()
#                                                   2.u()段判斷snb08a欄位是否有改變,若有改變
#                                                     (1)單身筆數為0時自動產生單身
#                                                     (2)單身已有資料詢問是否重新產生,選是則刪除舊資料後重新產生
# Modify.........: No.FUN-A30093 10/04/15 By jan 客供料不可變更
# Modify.........: No:MOD-A40088 10/04/16 By Sarah 若發料數不為0,才check最小發料數量
# Modify.........: No.TQC-A60087 10/06/21 By lilingyu call s_shortqty時,增加傳遞2個參數
# Modify.........: No.FUN-A60070 10/06/22 By lilingyu 平行工藝
# Modify.........: No.FUN-A60070 10/06/24 By lilingyu 平行工艺:asft803拆单处理
# Modify.........: No.TQC-A60120 10/06/28 By lilingyu 製程段號、製程序控管也可不輸入值
# Modify.........: No:MOD-A70161 10/07/21 By Sarah 調整最大變更版本值的抓法
# Modify.........: No:MOD-A70165 10/07/21 By Sarah MOD-A30062修改還原
# Modify.........: No:MOD-A10184 10/08/03 By Pengu 更改時單頭生產數量會無法修改
# Modify.........: No:MOD-A80072 10/08/10 By sabrina 變更後生產數量不可以大於訂單量
# Modify.........: No:MOD-A90166 10/09/26 By Carrier 变更后生产数量不可以大于已报工数量
# Modify.........: No:MOD-AA0079 10/10/14 By sabrina 已結案的工單不可做工單變更
# Modify.........: No:MOD-AA0100 10/10/18 By sabrina 調整傳入的record變數
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:MOD-AA0160 10/10/26 By sabrina 還原CHI-970059
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No:MOD-A90168 10/11/09 By sabrina 若以有發料量時則不允許變更發料單位
# Modify.........: No:MOD-AB0099 10/11/10 By sabrina 當簽核狀況為"2:發出"時，不可按確認
# Modify.........: No:MOD-AB0169 10/11/17 By sabrina 新增寫入t803_duptmp時增加判斷，若寫入值為null且資料重複時就不需顯示asf-272訊息
# Modify.........: No.FUN-AB0054 10/11/18 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No:MOD-A20057 10/03/17 By Pengu 1.修改新增單身資料時未回寫sfai_file
#                                                  2.取替代碼應只有"0,1,2"等選項
# Modify.........: No:MOD-AB0228 10/11/26 By sabrina 單身新增料件時，應帶出替代碼欄位
# Modify.........: No.TQC-AB0379 10/11/30 By vealxu 變更發出時會出現以下詢問視窗，不管選是會選否，變更都不會發出，此訊息請改為報錯訊息
# Modify.........: No.TQC-AB0395 10/12/02 By vealxu 問題一：asft803 單頭變更後製造部門開窗放大鏡呈灰色狀
#                                                   問題二：審核狀態下點擊更改按鈕，提示asf-592錯誤資訊，沒有中文說明
#                                                   問題三：工單變更發出時提示-391錯誤
# Modify.........: No:MOD-AC0134 10/12/16 By sabrina t803_g1_buf()的sfa02不應抓sna02(工單變更單版本)
# Modify.........: No:MOD-930138 10/12/25 By sabrina 調整t803_b()中所有AFTER FIELD 段的DISPLAY 改成用DISPLAY BY NAME方式撰寫
# Modify.........: No.TQC-AC0374 10/12/29 By liweie 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No:CHI-B10025 11/01/12 By Smapmin 委外採購單確認後,不可修改廠商
# Modify.........: No:MOD-B20064 11/02/16 By sabrina 判斷單身資料是否重覆時要多判斷作業編號
# Modify.........: No.FUN-B10056 11/02/21 By vealxu 修改制程段號的管控
# Modify.........: No:MOD-B20135 11/02/23 By sabrina 錯誤訊息asf-050，應再加上[已確認未發出]也要卡關
# Modify.........: No.TQC-B30079 11/03/08 By destiny orig,oriu新增时无值
# Modify.........: No:MOD-B30063 11/03/08 By sabrina 作業編號應要可以變更為空白
# Modify.........: No:CHI-B10031 11/02/10 By sabrina 當snb01為7/8時，開窗內容應改為廠商
# Modify.........: No:MOD-B30442 11/03/14 By shenyang
# Modify.........: No:MOD-B30473 11/03/14 By sabrina 計算工單數量時要排除已作廢的工單
# Modify.........: No:FUN-B20087 11/04/19 By jan 變更合拼單時，要考慮生產數量的比例
# Modify.........: No:TQC-B40099 11/04/19 By destiny 单身取消后，单头资料没有清空
# Modify.........: No:FUN-9A0095 11/04/27 By abby MES整合功能追版
# Modify.........: No:TQC-B40221 11/04/28 By zhangll 發料倍量控管算法修正
# Modify.........: No.FUN-B30192 11/05/05 By shenyang  修改字段icb05
# Modify.........: No.FUN-B50046 11/05/19 By abby APS GP5.25追版 str----------------------------------------
# Modify.........: No:FUN-960104 09/07/06 By Duke 平行加工變更模式調整成鎖定設備變更
# Modify.........: No:FUN-980080 09/08/20 By Mandy APS多機台鎖定功能調整
# Modify.........: No:FUN-A10134 10/01/27 By Mandy 有跟APS整合時,add 預計開工前/後時間,預計完工前/後時間,紀錄到[時:分]
# Modify.........: No:FUN-B50046 11/05/19 By abby APS GP5.25追版 end----------------------------------------
# Modify.........: No:MOD-B50239 11/05/30 By Vampire 將 LOCK 放到確認判斷前面
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:TQC-B60183 11/06/22 By Pengu 相同元件但作業編號不一樣時無法做變更
# Modify.........: No:MOD-B40140 11/07/18 By Vampire 單身新增時，判斷資料是否重覆應到作業編號才判斷
# Modify.........: No:MOD-B50059 11/07/18 By Vampire 判斷單身資料是否有重覆時，應多串變更版本(snb02)
# Modify.........: No:MOD-B60227 11/07/18 By Vampire 當工單型態等於再加工工單時，不去控管生產數量
# Modify.........: No:MOD-B70082 11/08/10 By Summer 如果不改單身，單頭應該也要可以變更
# Modify.........: No:TQC-B80235 11/08/30 By houlia 取消報錯信息asf-589
# Modify.........: No:TQC-B80242 11/08/31 By houlia 作業編號賦值調整
# Modify.........: No:TQC-B90004 11/09/01 By houlia 只變更作業編號時賦值有誤
# Modify.........: No:TQC-B90020 11/09/05 By houlia 变更日期控制不能大于工单开单日期
# Modify.........: No:FUN-B20056 11/09/09 By jason 新增上階料件
# Modify.........: No:MOD-BA0105 11/10/17 By johung 調整數量修改後回推QPA的公式
# Modify.........: No:TQC-BA0086 11/11/02 by destiny insert sfa_file时如sfa32没值应赋为'N'
# Modify.........: No:MOD-BB0176 11/11/26 By johung 工單串此程式時，變更發出ACTION不應隱藏
# Modify.........: No:MOD-BB0218 11/11/18 By Sarah 單身新增時,先以key值檢查資料是否已存在工單備料檔,若已存在則不允許存檔
# Modify.........: No:MOD-BB0311 11/11/28 By ck2yuan 變更工單新增項次多次 增加判斷sna02 避免控卡asf-272
# Modify.........: No.FUN-BB0085 11/12/05 By xianghui增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/12/19 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-BC0154 12/01/10 By destiny 在关账日期以后入库的工单可以做变更
# Modify.........: No:MOD-BC0240 12/01/17 By ck2yuan 變更工單新增 輸入應發數量帶出QPA
# Modify.........: No:MOD-BC0267 12/01/17 By ck2yuan 變更生產數量時,需多考慮損耗率
# Modify.........: No:MOD-C10067 12/02/01 By ck2yuan 修改t803_sna03() 當料號為NULL時就不抓品名

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BB0086 12/02/02 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C20027 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C10093 12/02/11 By lilingyu 通過工單CALL變更單時,灰掉錄入刪除等按鈕
# Modify.........: No:TQC-C10106 12/02/12 By lilingyu 通過工單CALL變更單時，如果查詢不到資料，開放錄入按鈕給用戶
# Modify.........: No:MOD-C10051 12/02/13 By lilingyu 工單在變更發出時，並未考慮到回寫工藝工單的首站良品轉入量
# Modify.........: No:MOD-C20061 12/02/16 By ck2yuan 若有工單的最早入庫日小于當前系統的關帳日期則不允許確認
# Modify.........: No:TQC-C20073 12/02/16 By ck2yuan 若走委外,變更時檢查是否有收貨單應過濾作廢的收貨單
# Modify.........: No:TQC-C20403 12/02/29 By ck2yuan 為避免錯誤,給sna27b值
# Modify.........: No:CHI-C20053 12/03/01 By bart 增加規格欄位
# Modify.........: No:FUN-C30293 12/03/29 By Abby 執行[單身],按"確定",狀況碼變成0.開立
# Modify.........: No:FUN-C10045 12/04/19 By bart 委外代買量變更
# Modify.........: No:MOD-C40167 12/04/20 By ck2yuan 若替代量為0,則將sna28a設為NULL 避免後續錯誤產生
# Modify.........: No:FUN-C10049 12/05/07 By bart sna11b/sna11a 的combobox.item加上"S:回收料"
# Modify.........: No:TQC-C50087 12/05/10 By fengrui 修改日期控管
# Modify.........: No:TQC-C50088 12/05/11 By fengrui 添加日期行事歷控管，日期預計值考慮新錄入變更日期
# Modify.........: No:MOD-C50079 12/05/11 By Elise 作廢後應不允許修改
# Modify.........: No:TQC-C50151 12/05/17 By fengrui 添加舊值初始化
# Modify.........: No:CHI-C30107 12/06/05 By yuhuabao 整批修改確認時先彈出詢問再進行chk
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-C70014 12/07/13 By wangwei 新增RUN CARD發料作業
# Modify.........: No:CHI-BA0015 12/07/24 By ck2yuan sna11b/sna11b加上S:回收料控卡
# Modify.........: NO:FUN-C70015 12/08/09 By bart 單身不可變更替代料
# Modify.........: No:CHI-C50052 12/08/15 By ck2yuan 變更生產數量時，應考慮原QPA，改變下階料的應發量
#                                                    增加生產數量，此時又有部分取替代，則將多出來的應發量加在主料
#                                                    減少生產數量，有部分取替代，先扣主料可扣的應發量，不夠扣時才扣副料的應發量
# Modify.........: NO:FUN-C30147 12/08/16 By bart 工單變更時，委外代買量加判斷IF 採購單未確認 THEN 維持原狀自動異動採購單 ELSE 判斷變更後代買量不可小於委外採購量
# Modify.........: NO:MOD-C90114 12/09/20 By Elise 將sna605a 修正為 sna065a
# Modify.........: NO:MOD-C90009 12/09/21 By Elise snb82a中MATCHES寫法改成IN寫法
# Modify.........: NO:MOD-C90171 12/10/11 By Elise 退料後、已發數量為0，應扣除退料的數量
# Modify.........: No:MOD-C90216 12/10/12 By ELise 工單變更後主料採購數量需更新
# Modify.........: No:MOD-CA0126 12/11/09 By Elise 修正變更後的應發數量(sna05a)
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.MOD-CC0043 12/12/26 By Elise 變更作業編號加上aim-801控卡,發料後再進行作業變號前應先做退料
# Modify.........: No.MOD-D10064 13/01/09 By bart 工單單身新增，會一直在QPA及pcs來回，無法跳到作業編號
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗
# Modify.........: No:FUN-CC0094 13/01/22 By chenjing 增加變更發出時間、日期、人員
# Modify.........: No:MOD-D10252 13/01/30 By bart 修改MOD-C10051控卡時機點
# Modify.........: No:TQC-D10103 13/02/01 By chenjing 修改snbsendt賦值
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: NO:CHI-C90030 13/03/05 By Alberti 針對sna065的欄位entry控卡,搬至t803_chk_sna065a
# Modify.........: NO:MOD-C90066 13/03/05 By Alberti t803_chksna05a中串bmd_file部分拿掉
# Modify.........: No:CHI-B80044 13/03/05 By Alberti 訂單轉工單生產數量若有設批量，則控卡不可超過最大生產批量
# Modify.........: No:MOD-D30053 13/03/07 By bart pmn87,pmn88,pmn88t需一併更新
# Modify.........: No:MOD-D30093 13/03/11 By bart 生產數量變更標準工時與機時都要跟著更改
# Modify.........: No:MOD-D30168 13/03/20 By bart 計算QPA需考慮單頭是否變更生產數量
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40062 13/04/10 By suncx 調整更新ecm301的時機
# Modify.........: No:MOD-D40083 13/04/15 By bart 修改計算訂單數量條件
# Modify.........: No:FUN-D60056 13/06/19 By lixh1 單身開窗可以支持多選,插入多行功能
# Modify.........: No:MOD-DC0038 13/12/06 By suncx FUN-D60056修改導致無法手動進單身錄入資料

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_snb           RECORD LIKE snb_file.*,       #WO (假單頭)
    g_snb_t         RECORD LIKE snb_file.*,       #WO (舊值)
    g_snb_o         RECORD LIKE snb_file.*,       #WO (舊值)
    g_sfb           RECORD LIKE sfb_file.*,
    g_ima           RECORD LIKE ima_file.*,
    g_bmb           RECORD LIKE bmb_file.*,
    b_sna           RECORD LIKE sna_file.*,
    g_sfa           RECORD LIKE sfa_file.*,
    g_sfa_t         RECORD LIKE sfa_file.*,
    g_snb01_t       LIKE snb_file.snb01,
    g_snb02_t       LIKE snb_file.snb02,
    g_snb08a_t     LIKE snb_file.snb08a,              #TQC-C50088 add
    g_snb13a_t     LIKE snb_file.snb13a,              #TQC-C50088 add
    g_snb15a_t     LIKE snb_file.snb15a,              #TQC-C50088 add
    g_yy,g_mm       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_sna           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                      sna04   LIKE sna_file.sna04,
                      sbefore LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                      sna012b LIKE sna_file.sna012b,        #TQC-A60087
                      sna013b LIKE sna_file.sna013b,        #TQC-A60087
                      sna03b  LIKE sna_file.sna03b,
                      ima02b  LIKE ima_file.ima02,
                      ima021b LIKE ima_file.ima021,  #CHI-C20053
                      sna05b  LIKE sna_file.sna05b,
                      sna065b LIKE sna_file.sna065b, #FUN-C10045
                      sna161b LIKE sna_file.sna161b,
                      sna26b  LIKE sna_file.sna26b,  #FUN-990059
                      sna28b  LIKE sna_file.sna28b,
                      sna12b  LIKE sna_file.sna12b,
                      sna13b  LIKE sna_file.sna13b,
                      sna11b  LIKE sna_file.sna11b,
                      sna08b  LIKE sna_file.sna08b,
                      sna29b  LIKE sna_file.sna29b, #FUN-B20056
                      safter  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                      sna012a LIKE sna_file.sna012a,        #TQC-A60087
                      sna013a LIKE sna_file.sna013a,        #TQC-A60087
                      sna03a  LIKE sna_file.sna03a,
                      ima02a  LIKE ima_file.ima02,
                      ima021a LIKE ima_file.ima021,  #CHI-C20053
                      sna05a  LIKE sna_file.sna05a,
                      sna065a LIKE sna_file.sna065a,  #FUN-C10045
                      sna161a LIKE sna_file.sna161a,
                      sna26a  LIKE sna_file.sna26a,  #FUN-990059
                      sna28a  LIKE sna_file.sna28a,
                      sna12a  LIKE sna_file.sna12a,
                      sna13a  LIKE sna_file.sna13a,
                      sna11a  LIKE sna_file.sna11a,
                      sna08a  LIKE sna_file.sna08a,
                      sna29a  LIKE sna_file.sna29a, #FUN-B20056
                      sna50 LIKE sna_file.sna50
                    END RECORD,
    g_sna_t         RECORD    #程式變數舊值
                      sna04   LIKE sna_file.sna04,
                      sbefore LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                      sna012b LIKE sna_file.sna012b,        #TQC-A60087
                      sna013b LIKE sna_file.sna013b,        #TQC-A60087
                      sna03b  LIKE sna_file.sna03b,
                      ima02b  LIKE ima_file.ima02,
                      ima021b LIKE ima_file.ima021,  #CHI-C20053
                      sna05b  LIKE sna_file.sna05b,
                      sna065b LIKE sna_file.sna065b,  #FUN-C10045
                      sna161b LIKE sna_file.sna161b,
                      sna26b  LIKE sna_file.sna26b,  #FUN-990059
                      sna28b  LIKE sna_file.sna28b,
                      sna12b  LIKE sna_file.sna12b,
                      sna13b  LIKE sna_file.sna13b,
                      sna11b  LIKE sna_file.sna11b,
                      sna08b  LIKE sna_file.sna08b,
                      sna29b  LIKE sna_file.sna29b, #FUN-B20056
                      safter  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
                      sna012a LIKE sna_file.sna012a,        #TQC-A60087
                      sna013a LIKE sna_file.sna013a,        #TQC-A60087
                      sna03a  LIKE sna_file.sna03a,
                      ima02a  LIKE ima_file.ima02,
                      ima021a LIKE ima_file.ima021,  #CHI-C20053
                      sna05a  LIKE sna_file.sna05a,
                      sna065a LIKE sna_file.sna065a,  #FUN-C10045
                      sna161a LIKE sna_file.sna161a,
                      sna26a  LIKE sna_file.sna26a,  #FUN-990059
                      sna28a  LIKE sna_file.sna28a,
                      sna12a  LIKE sna_file.sna12a,
                      sna13a  LIKE sna_file.sna13a,
                      sna11a  LIKE sna_file.sna11a,
                      sna08a  LIKE sna_file.sna08a,
                      sna29a  LIKE sna_file.sna29a, #FUN-B20056
                      sna50   LIKE sna_file.sna50
                    END RECORD,
    g_sfa29         DYNAMIC ARRAY of LIKE sfa_file.sfa29,        #No.FUN-680121 VARCHAR(40)#程式變數(Program Variables)
    g_wc,g_wc2,g_sql    STRING,       #No.FUN-680121 VARCHAR(1000)
    g_argv1             LIKE snb_file.snb01,
    g_argv2             LIKE snb_file.snb02,
    g_argv3             STRING,                       #FUN-920208 add
    g_delete            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_cmd               LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
    g_rec_b             LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    g_t1                LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
    l_ac                LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)
DEFINE g_chr2          LIKE type_file.chr1            #No.CHI-960054 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10           #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_confirm       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_approve       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_post          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_close         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_valid         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE l_zemsg         LIKE ze_file.ze03
DEFINE g_mhead         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)#060404 by ryf
DEFINE g_laststage     LIKE type_file.chr1          #No.FUN-920208
DEFINE li_where        STRING                       #No.FUN-940008 add
DEFINE l_sfa27         LIKE sfa_file.sfa27          #No.FUN-940008 add
DEFINE l_sfa28         LIKE sfa_file.sfa28          #No.FUN-940008 add
DEFINE g_sfb05         LIKE sfb_file.sfb05          #FUN-A60070
DEFINE g_sfb06         LIKE sfb_file.sfb06          #FUN-A60070
DEFINE g_sna12a_t      LIKE sna_file.sna12a         #FUN-910088--add--
DEFINE g_sna27b        LIKE sna_file.sna27b        #TQC-C20403 add
DEFINE g_multi_sna03b,g_multi_sna08b  STRING                      #FUN-D60056
define g_multi_sna27b   string  #$darcy:2022/06/15 add

MAIN

   IF FGL_GETENV("FGLGUI") <> "0" THEN  #若為背景執行則不定義系統畫面預設值 #FUN-A10013 add
    OPTIONS
        INPUT NO WRAP
   END IF                               #FUN-A10013 add

   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

   LET g_wc2=' 1=1'

   LET g_forupd_sql = "SELECT * FROM snb_file ",
                      " WHERE snb01 = ? AND snb02 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t803_cl CURSOR FROM g_forupd_sql

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090

   IF g_bgjob = "N" OR cl_null(g_bgjob) THEN       #FUN-A10013 add
     OPEN WINDOW t803_w WITH FORM "asf/42f/asft803"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

     CALL cl_ui_init()
   END IF                                          #FUN-A10013 add

   LET g_snb.snb04 = '2'

   SELECT ze03 INTO l_zemsg FROM ze_file
    WHERE ze01 = 'asf-832' AND ze02 = g_lang

   DISPLAY l_zemsg CLIPPED TO FORMONLY.desc1
   LET g_argv1     = ARG_VAL(1)
   LET g_argv2     = ARG_VAL(2)
   LET g_argv3     = ARG_VAL(3)     #功能  #FUN-920208 add

   CALL t803_check_duplicate_1()  #No.MOD-980140
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
      LET g_argv2 = aws_efapp_wsk(2)   #參數:key-2
   END IF

#FUN-A60070 --begin--
  IF g_sma.sma541 = 'Y' THEN
     CALL cl_set_comp_visible("dummy11,dummy12,sna012a,sna012b,sna013a,sna013b",TRUE)
  ELSE
     CALL cl_set_comp_visible("dummy11,dummy12,sna012a,sna012b,sna013a,sna013b",FALSE)
	END IF
#FUN-A60070 --end--

   CALL t803_aps_ui_default() #FUN-A10134 add

   #建立簽核模式時的 toolbar icon
   CALL aws_efapp_toolbar()

  #FUN-A10013 mark str ---
  #IF NOT cl_null(g_argv1) THEN
  #     CALL t803_q()
  #END IF
  #FUN-A10013 mark end ---
  #FUN-A10013 add str -----
   IF NOT cl_null(g_argv1) THEN
     #以g_argv3判斷直接執行哪種功能：
      CASE g_argv3
         WHEN "efconfirm"
            CALL t803_q()
            CALL t803_y_chk()       #CALL 原確認段的 check 段
            IF g_success = "Y" THEN
               CALL t803_y_upd()    #CALL 原確認段的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t803_q()
      END CASE
   END IF
  #FUN-A10013 add end

  #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, unconfirm, change_release,easyflow_approval,change_aps_processing")  #CHI-960054 #FUN-960104 mark
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, unconfirm, change_release,easyflow_approval,aps_ch_locked_machine")  #CHI-960054 #FUN-960104 mod   #CHI-D20010 add undo_void
       RETURNING g_laststage  #傳入簽核模式時不應執行的 action 清單

   CALL t803_menu()

   CLOSE t803_cl
   CALL t803_check_duplicate_3()  #No.MOD-980140
   CLOSE WINDOW t803_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090

END MAIN

#QBE 查詢資料
FUNCTION t803_cs()
    IF NOT cl_null(g_argv1) THEN
       LET g_snb.snb01=g_argv1 #FUN-6B0048
       LET g_snb.snb02=g_argv2 #FUN-6B0048
       LET g_wc = "snb01 = '",g_argv1,"' "
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc CLIPPED," AND snb02 = ",g_argv2 CLIPPED
       END IF
       LET g_wc2= " 1=1"
       SELECT ze03 INTO l_zemsg FROM ze_file
        WHERE ze01 = 'asf-832' AND ze02 = g_lang
       DISPLAY l_zemsg CLIPPED TO FORMONLY.desc1
       DISPLAY BY NAME g_snb.snb01,g_snb.snb02
    ELSE
       CLEAR FORM
       CALL g_sna.clear()
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_snb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON snb01,snb02,snb022,snbconf,snb99, snbmksg,     #FUN-920208 add snb99,snbmksg
                                 snbuser,snbmodu,snbgrup,snbdate,
                                 snbsendu,snbsendd,                    #FUN-CC0094 add
                                 snbud01,snbud02,snbud03,snbud04,snbud05,
                                 snbud06,snbud07,snbud08,snbud09,snbud10,
                                 snbud11,snbud12,snbud13,snbud14,snbud15
        ON ACTION controlp
           CASE
             WHEN INFIELD(snb01)    #查詢符合條件的單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfb02"
                  LET g_qryparam.construct= "Y"
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO snb01
                  NEXT FIELD snb01
             OTHERWISE EXIT CASE
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION about         #FUN-6B0048
             CALL cl_about()      #FUN-6B0048

          ON ACTION help          #FUN-6B0048
             CALL cl_show_help()  #FUN-6B0048

          ON ACTION controlg      #FUN-6B0048
             CALL cl_cmdask()     #FUN-6B0048


       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('snbuser', 'snbgrup') #FUN-980030

       IF INT_FLAG THEN
          RETURN
       END IF

      CONSTRUCT g_wc2 ON
                 sna04,sna012b,sna013b,sna03b,sna05b,sna065b,sna161b,sna26b,sna12b,sna11b,sna29b,  #FUN-A60070 add sna012b,sna013b #FUN-B20056 add sna29b  #FUN-C10045 add sna065b
                 sna012a,sna013a,sna03a,sna05a,sna065a,sna161a,sna26a,sna12a,   #FUN=990059 #FUN-A60070 add sna012a,sna013a  #FUN-C10045 add sna065a
                 sna11a,sna29a,sna50   #FUN-B20056 add sna29a
                  FROM
                s_sna[1].sna04,
                s_sna[1].sna012b,s_sna[1].sna013b,      #FUN-A60070 add
                s_sna[1].sna03b,s_sna[1].sna05b,s_sna[1].sna065b,s_sna[1].sna161b,s_sna[1].sna26b,s_sna[1].sna12b, #FUN-990059 #FUN-C10045 add s_sna[1].sna065b
                s_sna[1].sna11b,s_sna[1].sna29b,   #FUN-B20056 add sna29b
                s_sna[1].sna012a,s_sna[1].sna013a,     #FUN-A60070 add
                s_sna[1].sna03a,s_sna[1].sna05a,s_sna[1].sna065a,s_sna[1].sna161a,s_sna[1].sna26a,s_sna[1].sna12a, #FUN-990059 #FUN-C10045 add s_sna[1].sna065a
                s_sna[1].sna11a,s_sna[1].sna29a,s_sna[1].sna50   #FUN-B20056 add sna29a

        ON ACTION controlp
           CASE                        #查詢符合條件的料號
             WHEN INFIELD(sna12a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sna12a
                  NEXT FIELD sna12a
             WHEN INFIELD(sna08a)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfa08
                  NEXT FIELD sna08a
#FUN-A60070 --begin--
             WHEN INFIELD(sna012b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sna012b"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sna012b
                  NEXT FIELD sna012b
             WHEN INFIELD(sna012a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sna012a"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sna012a
                  NEXT FIELD sna012a
#FUN-A60070 --end--
             OTHERWISE EXIT CASE
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION about         #FUN-6B0048
             CALL cl_about()      #FUN-6B0048

          ON ACTION help          #FUN-6B0048
             CALL cl_show_help()  #FUN-6B0048

          ON ACTION controlg      #FUN-6B0048
             CALL cl_cmdask()     #FUN-6B0048
       END CONSTRUCT

       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF

    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = "SELECT snb01,snb02 FROM snb_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY snb01,snb02"
    ELSE
       LET g_sql = "SELECT UNIQUE snb01,snb02 ",
                   " FROM snb_file,sna_file ",
                   " WHERE snb01 = sna01 ",
                   "  AND  snb02 = sna02 ",
                   "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY snb01,snb02 "
    END IF
    PREPARE t803_prepare FROM g_sql      #預備一下
    DECLARE t803_b_cs                    #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR t803_prepare

    IF g_wc2 = " 1=1" THEN               #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM snb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT snb01) FROM snb_file,sna_file ",
                  " WHERE sna01=snb01 AND sna02=snb02 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t803_precount FROM g_sql
    DECLARE t803_count CURSOR FOR t803_precount

END FUNCTION

FUNCTION t803_menu()
  DEFINE l_creator   LIKE type_file.chr1     #「不准」時是否退回填表人 #FUN-920208
  DEFINE l_flowuser  LIKE type_file.chr1     # 是否有指定加簽人員      #FUN-920208
  DEFINE l_wc STRING #FUN-6B0048

  LET l_flowuser = "N"   #FUN-920208


   WHILE TRUE
      CALL t803_bp("G")
      CASE g_action_choice

          WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t803_a()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t803_u()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t803_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t803_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t803_r()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t803_x()    #CHI-D20010
               CALL t803_x(1)   #CHI-D20010
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t803_x(2)
            END IF
         #CHI-D20010---end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       WHEN "memo"
            IF g_snb.snbconf !='X' THEN
               CALL t803_memo()
            END IF
         WHEN "output"
            IF cl_null(g_snb.snb01) OR cl_null(g_snb.snb02) THEN
               CALL cl_err('','-400',1)
               LET g_action_choice=NULL
               RETURN
            END IF
            IF cl_chk_act_auth() THEN
               LET l_wc=' snb01= "',g_snb.snb01,'" AND snb02=',g_snb.snb02,' '
               #LET g_msg="asfr803 ", #FUN-C30085 mark
               LET g_msg="asfg803 ", #FUN-C30085 add
                         "'",g_today,"'",
                         " '",g_user,"'",
                         " '",g_lang,"'",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",l_wc,"'",
                         " 'N' ",
                         " '3'"
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_snb.snb01 IS NOT NULL THEN
                LET g_doc.column1 = "snb01"
                LET g_doc.column2 = "snb02"
                LET g_doc.value1 = g_snb.snb01
                LET g_doc.value2 = g_snb.snb02
                CALL cl_doc()
             END IF
          END IF

         WHEN "easyflow_approval" #EF 送簽
            IF cl_chk_act_auth() THEN
              #FUN-C20027 add str---
               SELECT * INTO g_snb.* FROM snb_file
                WHERE snb01 = g_snb.snb01
                  AND snb02 = g_snb.snb02
               CALL t803_show()
               CALL t803_b_fill(' 1=1')
              #FUN-C20027 add end---
               CALL t803_ef()
               CALL t803_show()  #FUN-C20027 add
            END IF
         #@WHEN "簽核狀況"
          WHEN "approval_status"
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN
                    CALL aws_efstat2()
               END IF
            END IF

         WHEN "agree"               #執行 EF 簽核, "准" 功能
            IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關並且無加簽人員
                #CALL t803_y_upd(g_snb.snb01,g_snb.snb02)      #CALL 原確認的update段  #FUN-A10013 mark
                 CALL t803_y_upd()                             #FUN-A10013 add
                 CALL t803sub_refresh(g_snb.snb01) RETURNING g_snb.*
                 CALL t803_show()
            ELSE
               LET g_success = "Y"
               IF NOT aws_efapp_formapproval() THEN #執行 EF 簽核
                  LET g_success = "N"
               END IF
            END IF
            IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)  #取得單號
                      LET g_argv2 = aws_efapp_wsk(2)   #參數:key-2
                      IF NOT cl_null(g_argv1) THEN   #自動 query 帶出資料
                        CALL t803_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale,void, confirm, unconfirm, change_release, easyflow_approval,change_aps_processing")	 #CHI-960054
                        CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale,void, undo_void, confirm, unconfirm, change_release, easyflow_approval,aps_ch_locked_machine") #CHI-960054 #FUN-960104 mod  #CHI-D20010 add undo_void
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

         WHEN "deny"    #執行 EF 簽核, "不准" 功能
            IF (l_creator := aws_efapp_backflow() ) IS NOT NULL THEN #退回關卡
              IF aws_efapp_formapproval() THEN    #執行 EF 簽核
                 IF l_creator = "Y" THEN          #當退回填表人時
                    LET g_snb.snb99 = 'R'          #顯示狀態碼為 'R' 送簽退回
                    DISPLAY BY NAME g_snb.snb99
                 END IF
                 IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN  #取得下一筆簽核單號
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)  #取得單號
                      LET g_argv2 = aws_efapp_wsk(2)   #參數:key-2
                      IF NOT cl_null(g_argv1) THEN    #自動 query 帶出資料
                        CALL t803_q()
                      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale,void, confirm, unconfirm, change_release, change_release, easyflow_approval,change_aps_processing")	#CHI-960054  #CHI-D20010 mark
                        CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, unconfirm, change_release,easyflow_approval,aps_ch_locked_machine")  #CHI-960054 #FUN-960104 mod  #CHI-D20010 add undo_void
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

         WHEN "modify_flow"   #執行 EF 簽核, "加簽" 功能
            IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
               LET l_flowuser = 'Y'
            ELSE
               LET l_flowuser = 'N'
            END IF

         WHEN "withdraw"      #執行 EF 簽核, "撤簽" 功能
            IF cl_confirm("aws-080") THEN
               IF aws_efapp_formapproval() THEN
                  EXIT WHILE
               END IF
            END IF

         WHEN "org_withdraw"  #執行 EF 簽核, "抽單" 功能
            IF cl_confirm("aws-079") THEN
               IF aws_efapp_formapproval() THEN
                  EXIT WHILE
               END IF
            END IF

         WHEN "phrase"         #執行 EF 簽核, "簽核意見" 功能
            CALL aws_efapp_phrase()

         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t803_unconfirm()
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
              #CALL t803_confirm()            #FUN-A10013 mark
              #FUN-A10013 add str -----
               CALL t803_y_chk()              #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t803_y_upd()           #CALL 原確認的 update 段
               END IF
              #FUN-A10013 add end -----
            END IF

        #FUN-960104 MARK --STR--------------------------------
        #WHEN "change_aps_processing"
        #    IF cl_chk_act_auth() THEN
        #       IF cl_chk_act_auth() THEN
        #            CALL t803_change_aps_pro()
        #       END IF
        #    END IF
        #FUN-960104 MARK --END--------------------------------

        #FUN-960104 ADD --STR---------------------------------
         #APS鎖定設備變更
         WHEN "aps_ch_locked_machine"
            IF cl_chk_act_auth() THEN
               CALL t803_change_apslocked_mach()
            END IF
        #FUN-960104 ADD --END---------------------------------

         WHEN "change_release"
            IF cl_chk_act_auth() THEN
               IF cl_chk_act_auth() THEN
                  CALL t803_g()
               END IF
            END IF
          #FUN-9A0095 mark str---------------------------------
          #IF g_snb.snbconf = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          #   # 傳入參數: (1)程式代號
          #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
          #   #           (3)Key
          #   CASE aws_mescli('asft803','',g_snb.snb01)
          #      WHEN 0  #無與 MES 整合
          #           MESSAGE 'INSERT O.K'
          #      WHEN 1  #呼叫 MES 成功
          #           MESSAGE 'INSERT O.K, INSERT MES O.K'
          #      WHEN 2  #呼叫 MES 失敗
          #           RETURN FALSE
          #   END CASE
          #END IF
          #FUN-9A0095 mark end---------------------------------
           CALL t803_pic()

      END CASE
   END WHILE
END FUNCTION

FUNCTION t803_a()
  DEFINE  i     LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE  l_no  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sfa RECORD LIKE sfa_file.*,
          l_sna RECORD LIKE sna_file.*
  DEFINE  l_ima64         LIKE ima_file.ima64,
          l_ima641        LIKE ima_file.ima641,
          l_gfe03         LIKE gfe_file.gfe03,
          l_sfaqty        LIKE sfa_file.sfa05,
          l_sna04         LIKE sna_file.sna04,
          l_sna05a        LIKE sna_file.sna05a,
          l_subqty        LIKE sfa_file.sfa05,   #主料被替代量
          l_sna06a        LIKE sna_file.sna06a,  #單頭變更時記錄原發數量
          l_double        LIKE type_file.num10
  DEFINE  l_sfa03         LIKE sfa_file.sfa03    #FUN-940008 add
    IF s_shut(0) THEN RETURN END IF
   #MESSAGE ""                                   #FUN-A10013 mark
    CALL cl_msg("")                              #FUN-A10013 add
    CLEAR FORM
    CALL g_sna.clear()
    CALL g_sfa29.clear()

    INITIALIZE g_snb.* LIKE snb_file.*             #DEFAULT 設定
    INITIALIZE g_snb_t.* LIKE snb_file.*           #DEFAULT 設定
    INITIALIZE g_snb_o.* LIKE snb_file.*           #DEFAULT 設定
    #TQC-C50151--add--str--
    LET g_snb08a_t = NULL
    LET g_snb13a_t = NULL
    LET g_snb15a_t = NULL
    #TQC-C50151--add--str--
    LET g_snb.snb01  = ''
    LET g_snb.snb022 = g_today
    LET g_snb.snb04 = '2'
    SELECT ze03 INTO l_zemsg FROM ze_file
        WHERE ze01 = 'asf-832' AND ze02 = g_lang
    DISPLAY l_zemsg CLIPPED TO FORMONLY.desc1
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_mhead = 'N'  #060404 by ryf
        LET g_snb.snbconf = 'N'                    #發出否
        LET g_snb.snbgrup=g_grup
        LET g_snb.snbdate=g_today
        LET g_snb.snbuser=g_user
        LET g_snb.snb99 = '0'                 #FUN-920208 add
        LET g_snb.snbmksg = 'N'               #FUN-920208 add
        LET g_snb.snbplant = g_plant #FUN-980008 add
        LET g_snb.snblegal = g_legal #FUN-980008 add
        LET g_snb.snborig=g_grup     #TQC-B30079
        LET g_snb.snboriu=g_user     #TQC-B30079

        CALL t803_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            INITIALIZE g_snb.* TO NULL
            CLEAR FORM       #TQC-B40099
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET g_snb.snb04 = '2'
        LET g_snb.snboriu = g_user      #No.FUN-980030 10/01/04
        LET g_snb.snborig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO snb_file VALUES(g_snb.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        ELSE
            SELECT snb01,snb02 INTO g_snb.snb01,g_snb.snb02 FROM snb_file
             WHERE snb01 = g_snb.snb01
               AND snb02 = g_snb.snb02
        END IF

        CALL g_sna.clear()
        CALL g_sfa29.clear()
        INITIALIZE g_sna_t.* TO NULL
        LET g_rec_b = 0

        IF NOT cl_null(g_snb.snb08a) THEN
           CALL t803_g_b()   #MOD-A30186 add   #自動產生單身
           #str MOD-A30186 mark
           #SELECT COUNT(*) INTO l_no FROM sfa_file WHERE sfa01=g_snb.snb01
           #IF l_no>0 THEN
           #   LET g_forupd_sql = "SELECT * FROM sfa_file ",
           #                      " WHERE sfa01 = ? "
           #   PREPARE ct803_prepare FROM g_forupd_sql
           #   DECLARE ct803_cl CURSOR FOR ct803_prepare
           #
           #   LET l_no=0
           #   FOREACH ct803_cl USING g_snb.snb01 INTO l_sfa.*
           #      LET l_no=l_no+1
           #      LET l_sna.sna01  =g_snb.snb01
           #      LET l_sna.sna02  =g_snb.snb02
           #      LET l_sna.sna022 =g_snb.snb022
           #      LET l_sna.sna04  =l_no
           #      LET l_sna.sna10  ='2'
           #      LET l_sna.sna03b =l_sfa.sfa03
           #      LET l_sna.sna05b =l_sfa.sfa05
           #      LET l_sna.sna06b =l_sfa.sfa06
           #      LET l_sna.sna062b=l_sfa.sfa062
           #      LET l_sna.sna065b=l_sfa.sfa065
           #      LET l_sna.sna07b =l_sfa.sfa07
           #      LET l_sna.sna08b =l_sfa.sfa08
           #      LET l_sna.sna100b=l_sfa.sfa100
           #      LET l_sna.sna11b =l_sfa.sfa11
           #      LET l_sna.sna12b =l_sfa.sfa12
           #      LET l_sna.sna13b =l_sfa.sfa13
           #      LET l_sna.sna161b=l_sfa.sfa161
           #      LET l_sna.sna26b =l_sfa.sfa26
           #      LET l_sna.sna27b =l_sfa.sfa27
           #      LET l_sna.sna28b =l_sfa.sfa28
           #      LET l_sna.sna30b =l_sfa.sfa30
           #      LET l_sna.sna31b =l_sfa.sfa31
           #
           #      LET l_sna.snaplant = g_plant #FUN-980008 add
           #      LET l_sna.snalegal = g_legal #FUN-980008 add
           #    # LET l_sna.sna05a =l_sfa.sfa05*g_snb.snb08a/g_snb.snb08b  #MOD-A30062 mark
           #      LET l_sna.sna05a =g_snb.snb08a*l_sna.sna161b             #MOD-A30062
           #     LET l_sna06a = l_sna.sna05a
           #     #考慮變更生產數量時,備料的最小發料數量及發料單位批量
           #     #Inflate With Minimum Issue Qty And Issue Pansize
           #     SELECT ima64,ima641 INTO l_ima64,l_ima641
           #       FROM ima_file    WHERE ima01=l_sfa.sfa03
           #     IF l_sna.sna05a != 0 THEN     #No:MOD-960041 add
           #        IF l_ima641 != 0 AND l_sna.sna05a < l_ima641 THEN
           #           LET l_sna.sna05a=l_ima641
           #        END IF
           #        IF l_ima64!=0 THEN
           #           LET l_double=(l_sna.sna05a/l_ima64)+ 0.999999
           #           LET l_sna.sna05a=l_double*l_ima64
           #        END IF
           #     END IF                   #No:MOD-960041 add
           #
           #     #-->考慮單位小數取位
           #      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sfa.sfa12
           #      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
           #      CALL cl_digcut(l_sna.sna05a,l_gfe03) RETURNING l_sfaqty
           #      LET l_sna.sna05a =  l_sfaqty
           #
           #     LET l_sna.sna06a =l_sna.sna05a   #No.MOD-8B0145
           #
           #     #-->重新計算QPA
           #      LET l_subqty=0
           #      SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
           #               WHERE sfa01 = g_snb.snb01
           #                   AND sfa27 = l_sna.sna03b
           #                   AND sfa26 IN ('S','U','Z')   #FUN-A20037 add 'Z'
           #      IF cl_null(l_subqty) THEN
           #        LET l_subqty=0
           #      END IF
           #     IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
           #        LET l_subqty=l_subqty*g_snb.snb08a/g_snb.snb08b
           #     END IF
           #     IF l_sfa.sfa26 MATCHES '[SUTsutZz]' THEN #替代料只能變更替代率   #FUN-A20037 add 'Zz'
           #        LET l_sna.sna161a = 0
           #           LET l_sna.sna28a=l_sna.sna05a/l_sna06a*l_sna.sna28b #考慮單頭變更的狀況
           #     ELSE
           #	      LET l_sna.sna161a=(l_sna.sna05a+l_subqty)/g_snb.snb08a
           #     END IF
           #      INSERT INTO sna_file VALUES(l_sna.*)
           #   END FOREACH
           #
           #   CALL t803_b_fill(' 1=1')
           #END IF
           #end MOD-A30186 mark
        END IF

        CALL t803_b()                   #輸入單身

        #FUN-A10013 add str ---
        IF NOT cl_null(g_snb.snb01) AND NOT cl_null(g_snb.snb02) AND
           g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN
           LET g_action_choice = "insert"

           CALL t803_y_chk()                            #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t803_y_upd()                         #CALL 原確認的 update 段
              CALL t803sub_refresh(g_snb.snb01) RETURNING g_snb.*
              CALL t803_show()
           END IF
        END IF
        #FUN-A10013 add end ---

        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION t803_i(p_cmd)
DEFINE g_h1         LIKE type_file.chr2     #FUN-A10134 add
DEFINE g_m1         LIKE type_file.chr2     #FUN-A10134 add
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(70)
    l_snb02         LIKE type_file.num5,          #No.FUN-680121 #變更序號
    l_n             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_n1            LIKE type_file.num5,          #No.CHI-960054
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_snb01         LIKE snb_file.snb01,
    l_sfb081        LIKE sfb_file.sfb081,
    l_sfb24         LIKE sfb_file.sfb24,
    l_sfb25         LIKE sfb_file.sfb25,
    l_sfb04         LIKE sfb_file.sfb04,   #FUN-8B0095
    l_snb04         LIKE snb_file.snb04,
    l_snbconf       LIKE snb_file.snbconf, #發出否
    l_str           LIKE type_file.chr50,         #No.FUN-680121 VARCHAR(40)
    l_sfb08         LIKE sfb_file.sfb08,   #MOD-A80072 add
    l_sfb22         LIKE sfb_file.sfb22,   #MOD-A80072 add
    l_sfb221        LIKE sfb_file.sfb221,  #MOD-A80072 add
    l_oeb12         LIKE oeb_file.oeb12    #MOD-A80072 add
DEFINE l_ima561     LIKE ima_file.ima561,  #MOD-740158
       l_ima56      LIKE ima_file.ima56,   #MOD-740158
       l_ima59      LIKE ima_file.ima59,   #MOD-740158
       l_ima60      LIKE ima_file.ima60,   #MOD-740158
       l_ima601     LIKE ima_file.ima601   #FUN-840194
#No.MOD-A90166  --Begin
DEFINE l_sfb39      LIKE sfb_file.sfb39
DEFINE l_sfb93      LIKE sfb_file.sfb93
DEFINE l_sfbud09    LIKE sfb_file.sfbud09
DEFINE l_qty        LIKE sfb_file.sfb08
#No.MOD-A90166  --End
DEFINE l_sfb81      LIKE sfb_file.sfb81    #TQC-B90020 add
DEFINE l_sfu02      LIKE sfu_file.sfu02    #MOD-BC0154
DEFINE li_result    LIKE type_file.num5    #TQC-C50088 add
DEFINE l_pmn20      LIKE pmn_file.pmn20    #MOD-C90216 add
DEFINE l_pmm18      LIKE pmm_file.pmm18    #MOD-C90216 add
DEFINE l_pmn78      LIKE pmn_file.pmn78

   #CHI-B80044 -- begin --
   DEFINE l_oebqty          LIKE type_file.num15_3   #訂單數量
   DEFINE l_availqty        LIKE sfb_file.sfb08      #訂單可轉工單數量
   DEFINE l_allowqty        LIKE sfb_file.sfb08      #允許生產數量
   DEFINE l_calc            LIKE type_file.num5      #計算批量倍數用
   #CHI-B80044 -- end --

   DEFINE l_part          LIKE oeb_file.oeb04       #MOD-BC0267 add
   DEFINE l_oeb05         LIKE oeb_file.oeb05       #MOD-BC0267 add
   DEFINE l_ima55         LIKE ima_file.ima55       #MOD-BC0267 add
   DEFINE l_ima562        LIKE ima_file.ima562      #MOD-BC0267 add
   DEFINE l_factor        LIKE ima_file.ima31_fac   #MOD-BC0267 add
   DEFINE l_sql           STRING

    DISPLAY BY NAME g_snb.snbconf,g_snb.snbuser,g_snb.snbmodu,g_snb.snbdate
                    ,g_snb.snbgrup,g_snb.snboriu,g_snb.snborig                 #TQC-B30079
    DISPLAY BY NAME g_snb.snb99,g_snb.snbmksg            #FUN-920208 add
    IF g_snb.snbconf='Y' THEN CALL cl_err('','asf-224',1) RETURN END IF

    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   #INPUT BY NAME g_snb.snb01,g_snb.snb022,g_snb.snb08a,g_snb.snb13a,g_snb.snb15a,g_snb.snb82a,                          #FUN-A10134 mark
    INPUT BY NAME g_snb.snb01,g_snb.snb022,g_snb.snb08a,g_snb.snb13a,g_snb.snb14a,g_snb.snb15a,g_snb.snb16a,g_snb.snb82a,#FUN-A10134 add
                  g_snb.snbud01,g_snb.snbud02,g_snb.snbud03,g_snb.snbud04,
                  g_snb.snbud05,g_snb.snbud06,g_snb.snbud07,g_snb.snbud08,
                  g_snb.snbud09,g_snb.snbud10,g_snb.snbud11,g_snb.snbud12,
                  g_snb.snbud13,g_snb.snbud14,g_snb.snbud15
    WITHOUT DEFAULTS  # 060404 add g_snb.snb08a,g_snb.snb13a,g_snb.snb15a by ryf

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t803_set_entry(p_cmd)
            CALL t803_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

        AFTER FIELD snb01                   #WO
            IF NOT cl_null(g_snb.snb01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = "u" AND (( g_snb.snb01 != g_snb01_t)
                               OR (g_snb.snb01 != g_snb01_t))) THEN

#檢查輸入之工單若有尚未做發出確認的工單變更單資料
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM snb_file
                   WHERE snb01 = g_snb.snb01
                    #AND snbconf = 'N'                          #MOD-B20135 mark
                     AND (snbconf = 'N' OR                      #MOD-B20135 add
                         (snbconf = 'Y' AND snb99 != '2'))      #MOD-B20135 add
                  IF l_cnt > 0 THEN
#檢查輸入之工單若有尚未做發出確認的工單[單身變更]資料
                     CALL cl_err('','asf-050',0)
                     NEXT FIELD snb01
                  END IF

#檢查輸入之工單若為委外工單/重工委外工單(sfb02='7' OR '8')
#且已有收貨紀錄(rvaconf = 'X'也算)
                  #FUN-C10045---begin mark
                  #LET l_cnt = 0
                  #SELECT COUNT(*) INTO l_cnt FROM sfb_file,rva_file,rvb_file
                  # WHERE sfb01 = g_snb.snb01
                  #   AND sfb39 = '1'         #MOD-880069 add
                  #   AND sfbacti = 'Y'
                  #   AND ( sfb02 = '7' OR sfb02 = '8' )
                  #   AND rvb34 = sfb01
                  #   AND rvb01 = rva01
                  #   AND rvaconf != 'X'    #TQC-C20073 add
                  #IF l_cnt > 0 THEN
                  #   CALL cl_err('','asf-053',0)
                  #   NEXT FIELD snb01
                  #END IF
                  #FUN-C10045---end
#未確認或已作廢的工單不可變更
                  LET l_cnt=0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                     WHERE sfb01 = g_snb.snb01
                       AND sfb87 <>'Y'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-089',0)
                     NEXT FIELD snb01
                  END IF
#TQC-AB0395--add start--------------
#已確認但尚未發出的工單不可變更
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM snb_file
                WHERE snb01 = g_snb.snb01
                  AND snbconf = 'Y'
                  AND snb99 <> '2'
               IF l_cnt > 0 THEN
                  CALL cl_err('','asf-554',0)
                  NEXT FIELD snb01
               END IF
#TQC-AB0395--add end ------------------
                 #MOD-AA0079---add---start---
                 #已結案工單不可變更
                  LET l_cnt=0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                     WHERE sfb01 = g_snb.snb01
                       AND sfb04 = '8'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-070',0)
                     NEXT FIELD snb01
                  END IF
                 #MOD-AA0079---add---end---
              #MOD-BC0154--begin
              #若有完工入庫單則不允許變更
#              LET l_cnt = 0
#              SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfu_file
#                        WHERE sfv11 = g_snb.snb01
#                          AND sfv01 = sfu01
#                          AND sfupost = 'Y'
#              IF l_cnt > 0 THEN
#                 CALL cl_err('','asf-771',0)
#                 NEXT FIELD snb01
#              END IF
               SELECT MIN(sfu02) INTO l_sfu02 FROM sfv_file,sfu_file
                     WHERE sfv11 = g_snb.snb01
                       AND sfv01 = sfu01
            IF g_user<>'tiptop' and g_user<>'20233'  THEN   #171208

               IF l_sfu02<=g_sma.sma53 THEN
                  CALL cl_err('','asf-882',0)
                  NEXT FIELD snb01
               END IF
            END IF
               #MOD-BC0154--end
                #自動帶出工單資訊
                  CALL t803_snb01(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD snb01
                  END IF

                 #str MOD-A70161 mark
                 ##start Add By Rayven
                 #IF p_cmd = 'a' THEN
                 #   SELECT sfb101 INTO g_snb.snb02 FROM sfb_file
                 #   WHERE sfb01 = g_snb.snb01
                 #   IF cl_null(g_snb.snb02) THEN
                 #      LET g_snb.snb02 = 1
                 #   ELSE
                 #      LET g_snb.snb02 = g_snb.snb02 + 1
                 #   END IF
                 #   DISPLAY BY NAME g_snb.snb02
                 #END IF
                 ##end
                 #end MOD-A70161 mark
                 #str MOD-A70161 add
                  IF cl_null(g_snb_t.snb01) OR (g_snb.snb01 != g_snb_t.snb01) THEN
                     SELECT max(snb02) INTO g_snb.snb02
                       FROM snb_file
                      WHERE snb01 = g_snb.snb01
                     IF cl_null(g_snb.snb02) THEN
                        LET g_snb.snb02 = 1
                     ELSE
                        LET g_snb.snb02 = g_snb.snb02 + 1
                     END IF
                  END IF
                  DISPLAY BY NAME g_snb.snb02
                 #end MOD-A70161 add
                  IF g_sfb.sfb02 MATCHES '[7,8]' THEN
                     #-----CHI-B10025---------
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
                       WHERE pmm01 = pmn01
                         AND pmm18 = 'Y'
                         AND pmn41 = g_snb.snb01
                         AND pmn20 > 0
                     IF l_cnt > 0 THEN
                     #-----END CHI-B10025-----
                        LET g_snb.snb82a=NULL
                        DISPLAY BY NAME g_snb.snb82a
                     END IF   #CHI-B10025
                  END IF
               END IF
               CALL t803_set_entry(p_cmd)    #FUN-750003
               CALL t803_set_no_entry(p_cmd) #FUN-750003
            END IF

        BEFORE FIELD snb022
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (( g_snb.snb01 != g_snb01_t)
               OR (g_snb.snb01 != g_snb01_t))) THEN
               #str MOD-A70161 mark
               #SELECT COUNT(*) INTO l_n FROM snb_file
               # WHERE snb01 = g_snb.snb01
               #   AND snb02 = g_snb.snb02
               #   AND snbconf <> 'X'   #TQC-990054
               #IF l_n > 0 THEN     #No.MOD-8C0254 add
               #   SELECT COUNT(*) INTO l_n1 FROM snb_file
               #    WHERE snb01 = g_snb.snb01
               #      AND snb02 = g_snb.snb02
               #      AND snbconf = 'X'
               #   IF l_n1 > 0 THEN
               #      SELECT max(snb02)+1 INTO g_snb.snb02 FROM snb_file
               #       WHERE snb01 = g_snb.snb01
               #   ELSE
               #       CALL cl_err(g_snb.snb01,'mfg4000',0)
               #       LET g_snb.snb01 = g_snb01_t
               #       LET g_snb.snb02 = g_snb02_t
               #       DISPLAY BY NAME g_snb.snb01
               #       DISPLAY BY NAME g_snb.snb02
               #       NEXT FIELD snb01
               #   END IF  #CHI-960054
               #END IF
               #end MOD-A70161 mark

#工單第一次變更時default 1,之后工單每變更一次序號加 1
                IF p_cmd = 'a' THEN
                   DISPLAY BY NAME g_snb.snb02
                   #本欄位預設值為系統日期
                   IF cl_null(g_snb.snb022) THEN
                      LET g_snb.snb022 = g_today
                   END IF
                END IF
            END IF

        AFTER FIELD snb022
           IF NOT cl_null(g_snb.snb022) THEN
#TQC-B90020  begin
             SELECT sfb81 INTO l_sfb81 FROM sfb_file WHERE sfb01 = g_snb.snb01
                IF g_snb.snb022 < l_sfb81 THEN
                   CALL cl_err('','asf-350',0)
                   NEXT FIELD snb022
                END IF
#TQC-B90020  end

             #日期不可大于單據輸入會計年度/期別
              CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0)
                 NEXT FIELD snb022
              END IF

             #日期不可小于成本關帳日期sma53
              SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = g_snb.snb01   #FUN-8B0095
              IF NOT cl_null(g_sma.sma53) AND g_snb.snb022<g_sma.sma53 THEN
                 IF l_sfb04 != '2' AND l_sfb04 !='3' THEN              #FUN-8B0095
                    CALL cl_err('','mfg9998',0)
                    NEXT FIELD snb022
                 END IF                                                #FUN-8B0095
              END IF
           END IF

       AFTER FIELD snb08a
           IF NOT cl_null(g_snb.snb08a) THEN
              IF g_snb.snb08a<g_sfb.sfb09 THEN  #不可小于已入庫數量
                 CALL cl_err('','asf-972',0)
                 NEXT FIELD snb08a
              END IF
              IF g_snb.snb08a<g_sfb.sfb081 THEN  #不可小于已發套數
                 CALL cl_err('','asf-056',0)
                 NEXT FIELD snb08a
              END IF
              SELECT ima561,ima56,ima60,ima601,ima59 INTO l_ima561,l_ima56,l_ima60,l_ima601,l_ima59  #No.FUN-840194
                                        FROM ima_file
                                       WHERE ima01=g_sfb.sfb05
              IF l_ima561 > 0 THEN #生產單位批量&最少生產數量
                 IF g_snb.snb08a<l_ima561 THEN
                    CALL cl_err(l_ima561,'asf-307',0)
                    NEXT FIELD snb08a
                 END IF
              END IF
              IF NOT cl_null(l_ima56) AND l_ima56>0  THEN #生產單位批量
                 IF (g_snb.snb08a MOD l_ima56) > 0 THEN
                    CALL cl_err(l_ima56,'asf-308',0)
                    NEXT FIELD snb08a
                 END IF
              END IF
             #MOD-A80072---add---start---
              SELECT sfb22,sfb221,sfbud09 INTO l_sfb22,l_sfb221,l_sfbud09 FROM sfb_file
               WHERE sfb01=g_snb.snb01
              IF cl_null(l_sfbud09) THEN LET  l_sfbud09=100 END IF

              IF NOT cl_null(l_sfb22) AND NOT cl_null(l_sfb221) THEN
                 SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
                  WHERE sfb22=l_sfb22 AND sfb221=l_sfb221
                    AND sfb87 != 'X'         #MOD-B30473 add
                    AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-D40083
                #-----MOD-BC0267 str -------
                #SELECT oeb12-oeb905 INTO l_oeb12 FROM oeb_file
                # WHERE oeb01=l_sfb22 AND oeb03=l_sfb221

                 SELECT oeb04,oeb12-oeb905,oeb05,ima55,((100+ima562)/100)
                  INTO l_part,l_oeb12,l_oeb05,l_ima55,l_ima562
                  FROM oeb_file LEFT OUTER JOIN ima_file ON oeb04=ima_file.ima01
                  WHERE oeb01=l_sfb22 AND oeb03=l_sfb221 AND oeb70='N'
                 CALL s_umfchk(l_part,l_oeb05,l_ima55) RETURNING g_cnt,l_factor
                 IF g_cnt = 1 THEN LET l_factor=1 END IF
                 IF cl_null(l_ima562) THEN LET l_ima562 = 1 END IF
                 LET l_oeb12=l_oeb12*l_factor*l_ima562
                #-----MOD-BC0267 end -------
                 IF cl_null(l_oeb12) THEN
                    SELECT msb05*ima55_fac INTO l_oeb12
                      FROM msb_file,msa_file,OUTER ima_file
                     WHERE msb01=l_sfb22 AND msb02=l_sfb221
                       AND msb01=msa01 AND msa03 = 'N'
                       AND msb03=ima01
                 END IF
               #CHI-B80044 -- begin --
                 LET l_oebqty = l_oeb12
                 LET l_availqty = l_oeb12 + g_snb.snb08b - g_snb.snb08a
                 IF l_availqty < 0 THEN
                    LET l_availqty = 0
                 END IF
                 IF NOT cl_null(l_ima56) AND l_ima56>0  THEN #生產單位批量
                    LET l_calc = 0
                    LET l_allowqty = l_availqty
                    IF l_oebqty MOD l_ima56 > 0 THEN
                       LET l_calc = l_oeb12/l_ima56 +1
                       LET l_oebqty = l_calc * l_ima56
                    END IF
                    IF l_availqty MOD l_ima56 > 0 THEN
                       LET l_calc = l_availqty/l_ima56 + 1
                       LET l_allowqty = l_calc * l_ima56
                    END IF
                    # 订单数量良率转化 ly180505
             {
                IF (l_sfb08 + g_snb.snb08a - g_snb.snb08b) > (l_oebqty/l_sfbud09*100)  THEN
                       CALL cl_err('','asf-358',1)
                       NEXT FIELD snb08a
                    END IF
              }
                 END IF
                 IF g_user<>'tiptop' THEN
                 IF g_sfb.sfb02 <> '5' THEN
                    IF (l_sfb08 + g_snb.snb08a - g_snb.snb08b) > l_oeb12 THEN
                       IF NOT cl_null(l_ima56) AND l_ima56 > 0 THEN
                          CALL cl_err('','asf-005',0)
                       ELSE
                          CALL cl_err('','asf-005',1)
                          NEXT FIELD snb08a
                       END IF
                    END IF
                 END IF
                 END IF
                #CHI-B80044 -- end --
                #CHI-B80044 -- mark begin --
                #IF g_sfb.sfb02 <> '5' THEN         #MOD-B60227 add
                #   IF (l_sfb08 + g_snb.snb08a-g_snb.snb08b) > l_oeb12 THEN
                #      CALL cl_err('','asf-005',1)
                #      NEXT FIELD snb08a
                #   END IF
                #END IF                             #MOD-B60227 add
                #CHI-B80044 -- mark end --
              END IF
             #MOD-A80072---add---end---
              #No.MOD-A90166  --Begin
              SELECT sfb39,sfb93 INTO l_sfb39,l_sfb93 FROM sfb_file
               WHERE sfb01=g_snb.snb01
              #一般工单时,可以BY发料套数来卡,对于事后扣帐且走工艺的工单,
              #特别卡第一站报工数量不可大于工单生产数量
              IF l_sfb39 = '2' AND l_sfb93 = 'Y' THEN
                 SELECT SUM(shb111+shb112+shb113+shb114+shb17) INTO l_qty
                   FROM shb_file
                  WHERE shb05 = g_snb.snb01
                    AND shbconf = 'Y'   #FUN-A70095
                    AND shb06 = (SELECT MIN(shb06) FROM shb_file
                                  WHERE shb05 = g_snb.snb01  AND shbconf = 'Y')   #FUN-A70095
                 IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                 IF l_qty > g_snb.snb08a THEN
                    CALL cl_err(l_qty,'asf-143',1)
                    NEXT FIELD snb08a
                 END IF
              END IF
              #No.MOD-A90166  --End
              #IF (g_snb_t.snb08a IS NULL OR g_snb_t.snb08a<>g_snb.snb08a) THEN   #TQC-C50088 mark
              IF (g_snb08a_t IS NULL OR g_snb08a_t<>g_snb.snb08a) THEN            #TQC-C50088 add
                 IF cl_null(l_ima59) OR SQLCA.sqlcode THEN
                    LET l_ima59=0
                 END IF
                 IF cl_null(l_ima60) OR SQLCA.sqlcode THEN
                    LET l_ima60=0
                 END IF
                 LET g_snb.snb15a=t803_time('1')                                                                       #MOD-960246 add
                 LET g_snb15a_t = g_snb.snb15a #TQC-C50088 add
                 DISPLAY BY NAME g_snb.snb15a
              END IF
              #MOD-C90216---add---S
              #委外採購單已確認，需控卡生產數量不可小於採購量
               LET l_pmm18 = ' '
               SELECT pmm18 INTO l_pmm18 FROM pmm_file,pmn_file
                WHERE pmm01 =pmn01
                  AND pmn41 = g_sfb.sfb01
                  AND pmn04 = g_sfb.sfb05
               IF l_pmm18 = 'Y' THEN
                  LET l_pmn20 = 0
                  #SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file
                  # WHERE pmn41 = g_sfb.sfb01
                  #   AND pmn04 = g_sfb.sfb05
                  #chg by donghy 按照工艺委外的，取所有工艺里最大的数量
                  LET l_sql = "SELECT pmn78,SUM(pmn20) a FROM pmn_file WHERE pmn41 = '",g_sfb.sfb01,"'",
                            " AND pmn04='",g_sfb.sfb05,"' GROUP BY pmn78 ORDER BY a DESC"
                  PREPARE pmn20_chk_pre FROM l_sql
                  DECLARE pmn20_chk_cs CURSOR FOR pmn20_chk_pre
                  FOREACH pmn20_chk_cs INTO l_pmn78,l_pmn20
                     EXIT FOREACH
                  END FOREACH
                  IF g_snb.snb08a < l_pmn20 THEN
                     CALL cl_err('','asf-283',1)
                     NEXT FIELD snb08a
                  END IF
               END IF
              #MOD-C90216---add---E
           END IF
           LET g_snb08a_t = g_snb.snb08a       #TQC-C50088 add

        AFTER FIELD snb13a
           #IF (NOT cl_null(g_snb.snb13a)) AND (g_snb_t.snb13a IS NULL OR g_snb_t.snb13a<>g_snb.snb13a) THEN   #TQC-C50088 mark
           IF (NOT cl_null(g_snb.snb13a)) AND (g_snb13a_t IS NULL OR g_snb13a_t<>g_snb.snb13a) THEN            #TQC-C50088 add
              #TQC-C50088--add--str--
              LET li_result = 0
              CALL s_daywk(g_snb.snb13a) RETURNING li_result
              IF li_result = 0 THEN      #0:非工作日
                 CALL cl_err(g_snb.snb13a,'mfg3152',1)
              END IF
              IF li_result = 2 THEN      #2:未設定
                 CALL cl_err(g_snb.snb13a,'mfg3153',1)
              END IF
              #TQC-C50088--add--end--
              IF cl_confirm("asf-983") THEN
                 SELECT ima59,ima60 INTO l_ima59,l_ima60
                                    FROM ima_file
                                   WHERE ima01=g_sfb.sfb05
                 IF cl_null(l_ima59) OR SQLCA.sqlcode THEN
                    LET l_ima59=0
                 END IF
                 IF cl_null(l_ima60) OR SQLCA.sqlcode THEN
                    LET l_ima60=0
                 END IF
                 LET g_snb.snb15a=t803_time('1')           #MOD-960246 add
                 LET g_snb15a_t = g_snb.snb15a             #TQC-C50088 add
                 DISPLAY BY NAME g_snb.snb15a
              END IF
           END IF
           #TQC-C50087--add--str--
           IF NOT cl_null(g_snb.snb13a) AND NOT cl_null(g_snb.snb15a) THEN
              IF g_snb.snb13a>g_snb.snb15a THEN
                 CALL cl_err('','asf-378',1)
                 NEXT FIELD snb13a
              END IF
           END IF
           #TQC-C50087--add--end--
           LET g_snb13a_t = g_snb.snb13a #TQC-C50088 add

        AFTER FIELD snb15a
           #TQC-C50087--mark--str--
           #IF (NOT cl_null(g_snb.snb13a)) AND
           #   (NOT cl_null(g_snb.snb15a)) THEN
           #   IF g_snb.snb13a>g_snb.snb15a THEN
           #      CALL cl_err('','asf-378',1)
           #      NEXT FIELD snb15a
           #   END IF
           #END IF
           #TQC-C50087--mark--end--
           #IF (NOT cl_null(g_snb.snb15a)) AND (g_snb_t.snb15a IS NULL OR g_snb_t.snb15a<>g_snb.snb15a) THEN  #TQC-C50088 mark
           IF (NOT cl_null(g_snb.snb15a)) AND (g_snb15a_t IS NULL OR g_snb15a_t<>g_snb.snb15a) THEN           #TQC-C50088 add
              #TQC-C50088--add--str--
              LET li_result = 0
              CALL s_daywk(g_snb.snb15a) RETURNING li_result
              IF li_result = 0 THEN      #0:非工作日
                 CALL cl_err(g_snb.snb15a,'mfg3152',1)
              END IF
              IF li_result = 2 THEN      #2:未設定
                 CALL cl_err(g_snb.snb15a,'mfg3153',1)
              END IF
              #TQC-C50088--add--end--
              IF cl_confirm("asf-379") THEN
                 SELECT ima59,ima60 INTO l_ima59,l_ima60
                                    FROM ima_file
                                   WHERE ima01=g_sfb.sfb05
                 IF cl_null(l_ima59) OR SQLCA.sqlcode THEN
                    LET l_ima59=0
                 END IF
                 IF cl_null(l_ima60) OR SQLCA.sqlcode THEN
                    LET l_ima60=0
                 END IF
                 LET g_snb.snb13a=t803_time('2')           #MOD-960246 add
                 LET g_snb13a_t = g_snb.snb13a             #TQC-C50088 add
                 DISPLAY BY NAME g_snb.snb13a
              END IF
           END IF
           #TQC-C50087--add--str--
           IF NOT cl_null(g_snb.snb15a) AND NOT cl_null(g_snb.snb13a) THEN
              IF g_snb.snb13a>g_snb.snb15a THEN
                 CALL cl_err('','asf-378',1)
                 NEXT FIELD snb15a
              END IF
           END IF
           #TQC-C50087--add--end--
           LET g_snb15a_t = g_snb.snb15a #TQC-C50088 add

        AFTER FIELD snb82a
          IF NOT cl_null(g_snb.snb82a) THEN
             LET l_cnt = 0
            #CHI-B10031---add---start---
             IF g_sfb.sfb02 = '7' OR g_sfb.sfb02 = '8' THEN
                SELECT COUNT(*) INTO l_cnt FROM pmc_file
                 WHERE pmc01 = g_snb.snb82a
                  #AND pmcacti = 'Y' AND pmc30 MATCHES '[23]'  #MOD-C90009 mark
                   AND pmcacti = 'Y' AND pmc30 IN ('2','3')    #MOD-C90009
             ELSE
            #CHI-B10031---add---end---
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                 WHERE gem01 = g_snb.snb82a
                   AND gemacti = 'Y'
             END IF              #CHI-B10031 add
             IF l_cnt = 0 THEN
                CALL cl_err('','mfg3001',0)
                NEXT FIELD snb82a
             END IF
          END IF

        #FUN-A10134---add----str---
        AFTER FIELD snb14a
           IF (NOT cl_null(g_snb.snb14a)) AND
              (g_snb_t.snb14a IS NULL OR g_snb_t.snb14a<>g_snb.snb14a) THEN
                 LET g_h1=g_snb.snb14a[1,2]
                 LET g_m1=g_snb.snb14a[4,5]
                 IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1<'00' OR g_h1>='24' OR g_m1<'00' OR g_m1>='60' THEN
                    #時間數值不在正確區間範圍內 !!
                    CALL cl_err(g_snb.snb14a,'asf-807',1)
                    NEXT FIELD snb14a
                 END IF
             END IF
        AFTER FIELD snb16a
           IF (NOT cl_null(g_snb.snb16a)) AND
              (g_snb_t.snb16a IS NULL OR g_snb_t.snb16a<>g_snb.snb16a) THEN
                 LET g_h1=g_snb.snb16a[1,2]
                 LET g_m1=g_snb.snb16a[4,5]
                 IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1<'00' OR g_h1>='24' OR g_m1<'00' OR g_m1>='60' THEN
                    #時間數值不在正確區間範圍內 !!
                    CALL cl_err(g_snb.snb16a,'asf-807',1)
                    NEXT FIELD snb16a
                 END IF
             END IF
        #FUN-A10134---add----end---

        AFTER FIELD snbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD snbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER INPUT
           LET g_snb.snbuser = s_get_data_owner("snb_file") #FUN-C10039
           LET g_snb.snbgrup = s_get_data_group("snb_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT  END IF
           #TQC-C50087--add--str--
           IF NOT cl_null(g_snb.snb13a) THEN
              IF NOT cl_null(g_snb.snb15a) THEN       #新錄開工日期、完工日期不為空
                 IF g_snb.snb13a>g_snb.snb15a THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb13a
                 END IF
              ELSE                                    #新錄完工日期為空
                 IF g_snb.snb13a>g_snb.snb15b THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb13a
                 END IF
              END IF
           ELSE                                       #新錄開工日期為空
              IF NOT cl_null(g_snb.snb15a) THEN
                 IF g_snb.snb13b>g_snb.snb15a THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb15a
                 END IF
              END IF
           END IF
           #TQC-C50087--add--end--


        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        ON ACTION controlp
           CASE
             WHEN INFIELD(snb01)    #查詢符合條件的單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfb02"
                  LET g_qryparam.construct= "Y"
                  LET g_qryparam.default1 = g_snb.snb01
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_snb.snb01
                  DISPLAY BY NAME g_snb.snb01
                  NEXT FIELD snb01
              WHEN INFIELD(snb82a)
                   CALL cl_init_qry_var()
                   IF g_sfb.sfb02 = '7' OR g_sfb.sfb02 = '8' THEN       #CHI-B10031 add
                      LET g_qryparam.form     = "q_pmc2"                #CHI-B10031 add
                   ELSE                                                 #CHI-B10031 add
                      LET g_qryparam.form     = "q_gem"
                   END IF                                               #CHI-B10031 add
                   LET g_qryparam.default1 = g_snb.snb82a
                   CALL cl_create_qry() RETURNING g_snb.snb82a
                   DISPLAY BY NAME g_snb.snb82a
                   NEXT FIELD snb82a
             OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about         #FUN-6B0048
          CALL cl_about()      #FUN-6B0048

       ON ACTION help          #FUN-6B0048
          CALL cl_show_help()  #FUN-6B0048

       ON ACTION controlg      #FUN-6B0048
          CALL cl_cmdask()     #FUN-6B0048

    END INPUT

END FUNCTION


#str MOD-A30186 add
FUNCTION t803_g_b()    #自動產生單身
   DEFINE l_no       LIKE type_file.num5,
          l_sfa      RECORD LIKE sfa_file.*,
          l_sna      RECORD LIKE sna_file.*,
          l_ima64    LIKE ima_file.ima64,
          l_ima641   LIKE ima_file.ima641,
          l_gfe03    LIKE gfe_file.gfe03,
          l_sfaqty   LIKE sfa_file.sfa05,
          l_subqty   LIKE sfa_file.sfa05,     #主料被替代量
          l_sna06a   LIKE sna_file.sna06a,    #單頭變更時記錄原發數量
          l_double   LIKE type_file.num10

   SELECT COUNT(*) INTO l_no FROM sfa_file WHERE sfa01=g_snb.snb01
   IF l_no>0 THEN
      LET g_forupd_sql = "SELECT * FROM sfa_file ",
                         " WHERE sfa01 = ? ",
                         " AND (sfa11 <> 'S' )"
      PREPARE ct803_prepare FROM g_forupd_sql
      DECLARE ct803_cl CURSOR FOR ct803_prepare

      LET l_no=0
      FOREACH ct803_cl USING g_snb.snb01 INTO l_sfa.*
         LET l_no=l_no+1
         LET l_sna.sna01  =g_snb.snb01
         LET l_sna.sna02  =g_snb.snb02
         LET l_sna.sna022 =g_snb.snb022
         LET l_sna.sna04  =l_no
         LET l_sna.sna10  ='2'
         LET l_sna.sna03b =l_sfa.sfa03
         LET l_sna.sna012b=l_sfa.sfa012  #FUN-A60070
         LET l_sna.sna013b=l_sfa.sfa013  #FUN-A60070
         LET l_sna.sna05b =l_sfa.sfa05
         LET l_sna.sna065b=l_sfa.sfa065  #FUN-C10045
         LET l_sna.sna06b =l_sfa.sfa06
         LET l_sna.sna062b=l_sfa.sfa062
         LET l_sna.sna065b=l_sfa.sfa065
         LET l_sna.sna07b =l_sfa.sfa07
         LET l_sna.sna08b =l_sfa.sfa08
         LET l_sna.sna100b=l_sfa.sfa100
         LET l_sna.sna11b =l_sfa.sfa11
         LET l_sna.sna12b =l_sfa.sfa12
         LET l_sna.sna13b =l_sfa.sfa13
         LET l_sna.sna161b=l_sfa.sfa161
         LET l_sna.sna26b =l_sfa.sfa26
         LET l_sna.sna27b =l_sfa.sfa27
         LET l_sna.sna28b =l_sfa.sfa28
         LET l_sna.sna30b =l_sfa.sfa30
         LET l_sna.sna31b =l_sfa.sfa31
        #LET l_sna.sna05a =g_snb.snb08a*l_sna.sna161b             #MOD-A30062  #MOD-A70165 mark
        #LET l_sna.sna05a =l_sfa.sfa05*g_snb.snb08a/g_snb.snb08b               #MOD-A70165      #CHI-C50052 mark
        #LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)   #FUN-910088--add--            #CHI-C50052 mark
        #MOD-880149-begin-add
        #LET l_sna06a = l_sna.sna05a      #MOD-A70165 mark  #移到後面
         #考慮變更生產數量時,備料的最小發料數量及發料單位批量
         #Inflate With Minimum Issue Qty And Issue Pansize
        #CHI-C50052 srt add-----
         IF l_sfa.sfa26 NOT MATCHES '[SUTsut]' THEN
           LET l_sna.sna05a =l_sfa.sfa05+(g_snb.snb08a-g_snb.snb08b)*l_sfa.sfa161
           IF l_sna.sna05a < l_sfa.sfa06 THEN
              LET l_sna.sna05a = l_sfa.sfa06
           END IF
           LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)
        #CHI-C50052 end add-----
         SELECT ima64,ima641 INTO l_ima64,l_ima641
           FROM ima_file    WHERE ima01=l_sfa.sfa03
         IF l_sna.sna05a != 0 THEN     #No:MOD-960041 add
            IF l_ima641 != 0 AND l_sna.sna05a < l_ima641 THEN
               LET l_sna.sna05a=l_ima641
            END IF
            IF l_ima64!=0 THEN
               LET l_double=(l_sna.sna05a/l_ima64)+ 0.999999
               LET l_sna.sna05a=l_double*l_ima64
            END IF
         END IF        #No:MOD-960041 add

         #-->考慮單位小數取位
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sfa.sfa12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         CALL cl_digcut(l_sna.sna05a,l_gfe03) RETURNING l_sfaqty
         LET l_sna.sna05a =  l_sfaqty

         LET l_sna.sna06a =l_sna.sna05a   #No:MOD-8B0145
         LET l_sna06a = l_sna.sna05a      #MOD-A70165 add
        #CHI-C50052 str mark-----
        ##-->重新計算QPA
        #LET l_subqty=0
        #SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
        # WHERE sfa01 = g_snb.snb01
        #   AND sfa27 = l_sna.sna03b
        #   AND sfa26 IN ('S','U')
        #IF cl_null(l_subqty) THEN
        #   LET l_subqty=0
        #END IF
        #IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
        #   LET l_subqty=l_subqty*g_snb.snb08a/g_snb.snb08b
        #END IF
        #LET l_sna.sna28a=NULL    #MOD-C40167 add
        #IF l_sfa.sfa26 MATCHES '[SUTsut]' THEN #替代料只能變更替代率
        #   LET l_sna.sna161a = 0
        #   LET l_sna.sna28a=l_sna.sna05a/l_sna06a*l_sna.sna28b #考慮單頭變更的狀況
        #   IF l_sna.sna28a = 0 AND l_sna.sna05a = 0 THEN   #MOD-C40167 add
        #     LET l_sna.sna28a=NULL                         #MOD-C40167 add
        #   END IF                                          #MOD-C40167 add
        #ELSE
        #   LET l_sna.sna161a=(l_sna.sna05a+l_subqty)/g_snb.snb08a
        #END IF
        #CHI-C50052 end mark-----
         LET l_sna.sna161a = l_sfa.sfa161   #CHI-C50052 add
         #MOD-880149-end-add
        #CHI-C50052 str add-----
         ELSE
           LET l_sna.sna05a  = l_sfa.sfa05
           LET l_sna.sna06a  = l_sna.sna05a
           LET l_sna.sna161a = l_sna.sna161b
           LET l_sna.sna28b  = l_sfa.sfa28
         END IF
        #CHI-C50052 end add-----
#TQC-A60120 --begin--
         LET l_sna.snaplant = g_plant
         LET l_sna.snalegal = g_legal
#TQC-A60120 --end--
         INSERT INTO sna_file VALUES(l_sna.*)
      END FOREACH

         IF g_snb.snb08a < g_snb.snb08b THEN   #MOD-CA0126 add
            CALL t803_chksna05a()    #CHI-C50052 add
         END IF                                #MOD-CA0126 add
         CALL t803_b_fill(' 1=1')
   END IF
END FUNCTION
#end MOD-A30186 add
#CHI-C50052 str add-----
FUNCTION t803_chksna05a()
   DEFINE l_sfa03     LIKE sfa_file.sfa03
   DEFINE l_sfa05     LIKE sfa_file.sfa05
   DEFINE l_sfa06     LIKE sfa_file.sfa06
   DEFINE l_sfa161    LIKE sfa_file.sfa161
   DEFINE l_sfa27     LIKE sfa_file.sfa27
   DEFINE l_bmd07     LIKE bmd_file.bmd07
   DEFINE l_sna05a    LIKE sna_file.sna05a
   DEFINE l_qty       LIKE type_file.num26_10
   DEFINE l_qty2      LIKE type_file.num26_10

   IF cl_null(g_snb.snb08a) THEN RETURN END IF

   DECLARE t803_c2 CURSOR FOR
   SELECT SUM(sna05a/sfa28),sfa27
    #FROM sna_file,sfa_file,bmd_file,sfb_file      #MOD-C90066 mark
     FROM sna_file,sfa_file                        #MOD-C90066 add
    WHERE sfa01=g_snb.snb01
      AND sfa03=sna03b
      AND sna01=g_snb.snb01
      AND sna02=g_snb.snb02
      AND sna27b=sfa27                          #MOD-C90066 add
     #AND sfa03=bmd04                           #MOD-C90066 mark
     #AND bmd01=sfa27                           #MOD-C90066 mark
     #AND sfb01=g_snb.snb01                     #MOD-C90066 mark
     #AND bmd08=sfb05                           #MOD-C90066 mark
    GROUP BY sfa27

   FOREACH t803_c2 INTO l_sna05a,l_sfa27
      SELECT sna05a INTO l_qty2 FROM sna_file WHERE sna01=g_snb.snb01 AND sna02=g_snb.snb02 AND sna03b=l_sfa27
     #IF l_sna05a+l_qty2  = g_snb.snb08a  THEN CONTINUE FOREACH END IF   #MOD-CA0126 mark

      DECLARE t803_c3 CURSOR FOR
      SELECT sfa03,sfa05,sfa06,sfa28
       #FROM sfa_file,bmd_file,sfb_file         #MOD-C90066 mark
        FROM sfa_file                           #MOD-C90066 add
       WHERE sfa01  = g_snb.snb01
         AND sfa27  = l_sfa27
         AND sfa03 != l_sfa27
       # AND sfa03  = bmd04                     #MOD-C90066 mark
       # AND bmd01  = l_sfa27                   #MOD-C90066 mark
       # AND sfb01=g_snb.snb01                  #MOD-C90066 mark
       # AND bmd08=sfb05                        #MOD-C90066 mark

      SELECT sfa161 INTO l_sfa161 FROM sfa_file WHERE sfa01=g_snb.snb01 AND sfa03 = l_sfa27
     #LET l_qty = l_sna05a + l_qty2 - g_snb.snb08a*l_sfa161   #MOD-CA0126 mark
     #l_qty:剩餘需要扣掉的數量
      LET l_qty = l_sna05a - g_snb.snb08a*l_sfa161            #MOD-CA0126

      FOREACH t803_c3 INTO l_sfa03,l_sfa05,l_sfa06,l_bmd07
        IF l_qty = 0 THEN EXIT FOREACH END IF      #MOD-CA0126 add
        LET l_sna05a = l_sfa05 - l_qty*l_bmd07
        IF l_sna05a < l_sfa06 THEN
           LET l_sna05a = l_sfa06
           LET l_qty = l_qty - (l_sfa05 - l_sfa06 )/l_bmd07
        ELSE
           LET l_qty = l_qty - (l_sfa05 - l_sna05a)/l_bmd07
        END IF
        UPDATE sna_file SET sna05a=l_sna05a
         WHERE sna01  = g_snb.snb01
           AND sna02  = g_snb.snb02
           AND sna03b = l_sfa03
      END FOREACH

   END FOREACH

END FUNCTION

FUNCTION t803_sna05_1(l_sna03b)
DEFINE l_sna03b LIKE sna_file.sna03b
DEFINE l_sna05a LIKE sna_file.sna05a
DEFINE l_sfa161 LIKE sfa_file.sfa161
DEFINE l_sna27b LIKE sna_file.sna27b
DEFINE l_sna28a LIKE sna_file.sna28a
DEFINE l_sna28b LIKE sna_file.sna28b
DEFINE l_other  LIKE sfa_file.sfa05

      SELECT sna27b INTO l_sna27b FROM sna_file WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02 AND sna03b = l_sna03b
      SELECT sfa161 INTO l_sfa161 FROM sfa_file WHERE sfa01=g_snb.snb01 AND sfa03 = l_sna27b AND sfa161 !=0

      DECLARE t803_sna05_1 CURSOR FOR
       SELECT sna05a,sna28b,sna28a
         FROM sna_file
        WHERE sna01 = g_snb.snb01
          AND sna02 = g_snb.snb02
          AND sna03b != l_sna03b
          AND sna27b = l_sna27b

      LET l_other = 0
      FOREACH t803_sna05_1 INTO l_sna05a,l_sna28b,l_sna28a
        IF l_sna28a IS NULL THEN
           LET l_other = l_other + l_sna05a/l_sna28b
        ELSE
           LET l_other = l_other + l_sna05a/l_sna28a
        END IF
      END FOREACH

      RETURN l_other,l_sfa161

END FUNCTION
#CHI-C50052 end add-----

#Query 查詢
FUNCTION t803_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
   #MESSAGE ""                        #FUN-A10013 mark
    CALL cl_msg("")                   #FUN-A10013 add
    CLEAR FORM
    CALL g_sna.clear()
    CALL t803_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
       LET INT_FLAG = 0
       LET g_snb.snb01=NULL #FUN-6B0048
       LET g_snb.snb02=NULL #FUN-6B0048
       RETURN
    END IF
    OPEN t803_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_snb.snb01 TO NULL
    ELSE
        CALL t803_fetch('F')            #讀出TEMP第一筆并顯示
        OPEN t803_count
        FETCH t803_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION t803_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER

   #MESSAGE ""                                           #FUN-A10013 mark
    CALL cl_msg("")                                      #FUN-A10013 add
    CASE p_flag
        WHEN 'N' FETCH NEXT     t803_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'P' FETCH PREVIOUS t803_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'F' FETCH FIRST    t803_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'L' FETCH LAST     t803_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt mod
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()

                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t803_b_cs INTO g_snb.snb01,g_snb.snb02
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        INITIALIZE g_snb.snb01 TO NULL            #No.FUN-6B0079 add
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
    SELECT * INTO g_snb.* FROM snb_file
     WHERE snb01 = g_snb.snb01
       AND snb02 = g_snb.snb02

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err3("sel","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_snb.* TO NULL
    ELSE
       LET g_data_owner = g_snb.snbuser      #FUN-4C0035
       LET g_data_group = g_snb.snbgrup      #FUN-4C0035
       CALL t803_show()
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION t803_show()

    LET g_snb_t.* = g_snb.*
    #TQC-C50088--add--str--
    LET g_snb08a_t = g_snb.snb08a
    LET g_snb13a_t = g_snb.snb13a
    LET g_snb15a_t = g_snb.snb15a
    #TQC-C50088--add--end--
    DISPLAY BY NAME
            g_snb.snb01,g_snb.snb02,g_snb.snb022,g_snb.snbconf,
            g_snb.snbuser,g_snb.snbgrup,g_snb.snbmodu,g_snb.snbdate,
            g_snb.snbsendu,g_snb.snbsendd,g_snb.snbsendt,         #FUN-CC90044
           #g_snb.snb08b,g_snb.snb13b,g_snb.snb15b,g_snb.snb82b,                          #FUN-A10134 mark
           #g_snb.snb08a,g_snb.snb13a,g_snb.snb15a,g_snb.snb82a,                          #FUN-A10134 mark
            g_snb.snb08b,g_snb.snb13b,g_snb.snb14b,g_snb.snb15b,g_snb.snb16b,g_snb.snb82b,#FUN-A10134 add
            g_snb.snb08a,g_snb.snb13a,g_snb.snb14a,g_snb.snb15a,g_snb.snb16a,g_snb.snb82a,#FUN-A10134 add
            g_snb.snbud01,g_snb.snbud02,g_snb.snbud03,g_snb.snbud04,
            g_snb.snbud05,g_snb.snbud06,g_snb.snbud07,g_snb.snbud08,
            g_snb.snbud09,g_snb.snbud10,g_snb.snbud11,g_snb.snbud12,
            g_snb.snbud13,g_snb.snbud14,g_snb.snbud15,
            g_snb.snb99,g_snb.snbmksg            #FUN-920208 add

    CALL t803_snb01('d')
    CALL t803_b_fill(' 1=1')         #單身

    CALL t803_pic()
END FUNCTION

FUNCTION t803_snb01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,            #No.FUN-680121 VARCHAR(1)
    l_sfb02_d       LIKE type_file.chr6,            #No.FUN-680121 VARCHAR(6)
    l_sfb04_d       LIKE type_file.chr6,            #No.FUN-680121 VARCHAR(6)
    l_ima02         LIKE ima_file.ima02,
    l_imaacti       LIKE ima_file.imaacti,
    l_sfb    RECORD LIKE sfb_file.*

    LET g_errno = ''
    INITIALIZE g_sfb.* TO NULL  #FUN-750003
    SELECT *  INTO g_sfb.* FROM sfb_file
     WHERE sfb01 = g_snb.snb01

    IF p_cmd<>'d' THEN #FUN-750003
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-312'
                                      LET g_sfb.sfb05 = NULL
                                      LET g_sfb.sfbacti = NULL
            WHEN g_sfb.sfbacti='N'    LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE

       IF cl_null(g_errno) AND NOT cl_null(g_sfb.sfb05) THEN
          SELECT imaacti INTO l_imaacti FROM ima_file
           WHERE ima01 = g_sfb.sfb05
          CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                         LET l_ima02 = NULL
                                         LET l_imaacti = NULL
               WHEN l_imaacti='N' LET g_errno = '9028'
               WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038' #No.FUN-690022 add
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
       END IF
       LET g_snb.snbmksg = g_sfb.sfbmksg      #FUN-920208 add
    END IF
    LET l_sfb02_d='' #FUN-750003
    LET l_sfb02_d=t803_sfb02(g_sfb.sfb02)
    IF p_cmd = 'a' OR cl_null(g_errno) OR p_cmd='d' THEN #FUN-750003
        DISPLAY BY NAME g_snb.snb02
        DISPLAY g_sfb.sfb05  TO FORMONLY.sfb05
        DISPLAY g_sfb.sfb02  TO FORMONLY.sfb02
        DISPLAY BY NAME g_snb.snbmksg          #FUN-920208 add
        DISPLAY g_sfb.sfb09  TO FORMONLY.sfb09
        DISPLAY l_sfb02_d    TO FORMONLY.sfb02_d
    END IF
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       LET g_snb.snb08b = g_sfb.sfb08
       LET g_snb.snb13b = g_sfb.sfb13
       LET g_snb.snb14b = g_sfb.sfb14 #FUN-A10134 add
       LET g_snb.snb15b = g_sfb.sfb15
       LET g_snb.snb16b = g_sfb.sfb16 #FUN-A10134 add
       LET g_snb.snb82b = g_sfb.sfb82
      #DISPLAY BY NAME g_snb.snb08b,g_snb.snb13b,g_snb.snb15b,g_snb.snb82b                           #FUN-A10134 mark
       DISPLAY BY NAME g_snb.snb08b,g_snb.snb13b,g_snb.snb14b,g_snb.snb15b,g_snb.snb16b,g_snb.snb82b #FUN-A10134 add
    END IF
END FUNCTION

FUNCTION t803_sfb02(p_sfb02)
    DEFINE p_sfb02	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_str        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(10)
    DEFINE l_ze01       LIKE ze_file.ze01            #No.FUN-680121 VARCHAR(7)
     CASE WHEN p_sfb02 = 1 LET l_ze01="asf-841"
          WHEN p_sfb02 = 5 LET l_ze01="asf-842"
          WHEN p_sfb02 = 7 LET l_ze01="asf-843"
          WHEN p_sfb02 = 8 LET l_ze01="asf-856"
          WHEN p_sfb02 =11 LET l_ze01="asf-853"
          WHEN p_sfb02 =13 LET l_ze01="asf-844"
          WHEN p_sfb02 =15 LET l_ze01="asf-855"
          OTHERWISE RETURN NULL  #FUN-750003
     END CASE
       SELECT ze03 INTO l_zemsg FROM ze_file
          WHERE ze01 = l_ze01 AND ze02 = g_lang
       LET l_str = l_zemsg CLIPPED
    RETURN l_str
END FUNCTION

FUNCTION t803_sfb04(p_sfb04)
    DEFINE p_sfb04	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_str        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(10)
    DEFINE l_ze01       LIKE ze_file.ze01            #No.FUN-680121 VARCHAR(7)

     CASE WHEN p_sfb04 ='1' LET l_ze01="asf-845"
          WHEN p_sfb04 ='2' LET l_ze01="asf-846"
          WHEN p_sfb04 ='3' LET l_ze01="asf-847"
          WHEN p_sfb04 ='4' LET l_ze01="asf-848"
          WHEN p_sfb04 ='5' LET l_ze01="asf-849"
          WHEN p_sfb04 ='6' LET l_ze01="asf-850"
          WHEN p_sfb04 ='7' LET l_ze01="asf-851"
          WHEN p_sfb04 ='8' LET l_ze01="asf-852"
     END CASE
       SELECT ze03 INTO l_zemsg FROM ze_file
          WHERE ze01 = l_ze01 AND ze02 = g_lang
       LET l_str = l_zemsg CLIPPED
    RETURN l_str
END FUNCTION

FUNCTION t803_r()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN
    END IF
    #----> 如為'已發出',不可取消
#TQC-B80235 --mark
#   IF g_snb.snbconf = 'Y' THEN
#      CALL cl_err('','asf-589',0)   #CHI-960054
#      RETURN
#   END IF
#TQC-B80235  --end
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_snb.snbconf = 'Y' THEN
     # CALL cl_err('','asf-592',0)  #CHI-960054   #TQC-AB0395
       CALL cl_err('','axr-101',0)  #TQC-AB0395
       RETURN
    END IF

    #送簽中單據不可刪除
    IF g_snb.snb99 = 'S' THEN
       CALL cl_err('','aws-200',0)
       RETURN
    END IF

    BEGIN WORK

    OPEN t803_cl USING g_snb.snb01,g_snb.snb02
    IF STATUS THEN
       CALL cl_err("OPEN t803_cl:", STATUS, 1)
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t803_cl INTO g_snb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t803_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "snb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "snb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_snb.snb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_snb.snb02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM snb_file WHERE snb01 = g_snb.snb01
                              AND snb02 = g_snb.snb02
         DELETE FROM sna_file WHERE sna01 = g_snb.snb01
                              AND sna02 = g_snb.snb02
         DELETE FROM snc_file WHERE snc01 = g_snb.snb01
                              AND snc02 = g_snb.snb02
         #平行加工變更資料刪除
         IF g_sma.sma901 = 'Y' THEN
             DELETE FROM vlk_file
              WHERE vlk01 = g_snb.snb01
                AND vlk02 = g_snb.snb02
         END IF
         INITIALIZE g_snb.* TO NULL
         CLEAR FORM
         CALL g_sna.clear()
         CALL g_sna.clear()
         CALL g_sfa29.clear()
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
         VALUES ('asft803',g_user,g_today,g_msg,g_snb.snb01,'delete',g_plant,g_legal) #FUN-980008 add
         OPEN t803_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t803_cl
            CLOSE t803_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t803_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t803_cl
            CLOSE t803_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t803_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t803_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t803_fetch('/')
         END IF
    END IF
    COMMIT WORK
    LET g_snb.snb04 = '2'
    SELECT ze03 INTO l_zemsg FROM ze_file
        WHERE ze01 = 'asf-832' AND ze02 = g_lang
    DISPLAY l_zemsg CLIPPED TO FORMONLY.desc1
END FUNCTION

#單身
FUNCTION t803_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_i             LIKE type_file.num5,                #No.FUN-680121 SMALLINT
    l_ratio         LIKE sna_file.sna05b,
    l_code          LIKE type_file.num5,                #No.FUN-680121 SMALLINT
    l_sfa16         LIKE sfa_file.sfa16,
    l_sna04         LIKE sna_file.sna04,
    l_sna07a        LIKE sna_file.sna07a,
    l_sna161a       LIKE sna_file.sna161a,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否       #No.FUN-680121 SMALLINT
    l_sfb08         LIKE sfb_file.sfb08,
    l_sna05a        LIKE sna_file.sna05a,
    l_subqty        LIKE sfa_file.sfa05,   #主料被替代量
    l_other         LIKE sfa_file.sfa05,   #CHI-C50052 add
    l_sfa161        LIKE sfa_file.sfa161,  #CHI-C50052 add
    l_sna06a        LIKE sna_file.sna06a,  #單頭變更時記錄原發數量
    l_sfa06         LIKE sfa_file.sfa06    #FUN-6B0048
  DEFINE  l_ima64         LIKE ima_file.ima64,
          l_ima641        LIKE ima_file.ima641,
          l_gfe03         LIKE gfe_file.gfe03,
          l_sfaqty        LIKE sfa_file.sfa05,
          l_num_y         LIKE sfa_file.sfa05,          #No.MOD-930248 add
          l_num_z         LIKE type_file.num20,         #No.MOD-930248 add
          l_ima01         LIKE ima_file.ima01,          #No.MOD-930248 add
          l_double        LIKE type_file.num10
  DEFINE  l_sfa07         LIKE sfa_file.sfa07  #MOD-920167 add
  DEFINE  l_snb99         LIKE snb_file.snb99  #FUN-920208 add
  DEFINE  l_sna03a        LIKE sna_file.sna03a  #No.MOD-930226 add
  DEFINE  l_sna11a        LIKE sna_file.sna11a  #CHI-BA0015 add
  DEFINE  l_sna11a_err    LIKE sna_file.sna11a  #CHI-BA0015 add
  DEFINE  l_sna12a        LIKE sna_file.sna12a  #No.MOD-930226 add
  DEFINE  p_sfb01         LIKE sfb_file.sfb01  #FUN-940008 add
  DEFINE  l_sna27b        LIKE sna_file.sna27b #FUN-940008 add
  DEFINE  l_cnt           LIKE type_file.num10  #FUN-940008 add
  DEFINE  l_msg           LIKE type_file.chr1000   #CHI-990024
 #DEFINE  l_cnt1          LIKE type_file.num5      #CHI-970059    #MOD-AA0160 mark
  DEFINE  l_sfb05         LIKE sfb_file.sfb05   #FUN-A60070
  DEFINE  l_sfb06         LIKE sfb_file.sfb06   #FUN-A60070
  DEFINE  l_bmb16         LIKE bmb_file.bmb16      #MOD-AB0228 add
  DEFINE  l_flag          LIKE type_file.num5    #TQC-AC0374 add
  DEFINE  l_case          STRING                #FUN-910088--add--
  DEFINE  l_pmn20         LIKE pmn_file.pmn20   #FUN-C30147
#FUN-D60056 ---------Begin----------
  DEFINE  l_sql           STRING
  DEFINE  m_sna02         LIKE sna_file.sna02
  DEFINE  m_sna04         LIKE sna_file.sna04
  DEFINE  m_sna03a        LIKE sna_file.sna03a
  DEFINE  m_sna05a        LIKE sna_file.sna05a
  DEFINE  m_sna065a       LIKE sna_file.sna065a
  DEFINE  m_sna161a       LIKE sna_file.sna161a
  DEFINE  m_sna26a        LIKE sna_file.sna26a
  DEFINE  m_sna12a        LIKE sna_file.sna12a
  DEFINE  m_sna13a        LIKE sna_file.sna13a
  DEFINE  m_sna11a        LIKE sna_file.sna11a
  DEFINE  m_sna08a        LIKE sna_file.sna08a
  DEFINE  m_sna012a       LIKE sna_file.sna012a
  DEFINE  m_sna013a       LIKE sna_file.sna013a
  DEFINE  m_sna50         LIKE sna_file.sna50
#FUN-D60056 ---------End------------
    LET g_action_choice = ""
    LET l_snb99 = g_snb.snb99       #FUN-920208 add
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN RETURN END IF
    IF g_snb.snb04='1' THEN CALL cl_err('','asf-062',1) RETURN END IF
    IF g_snb.snbconf ='X' THEN    #檢查資料是否為無效
       CALL cl_err(g_snb.snb01,'aom-000',0) RETURN
    END IF
    IF g_snb.snbconf = 'Y' THEN
     # CALL cl_err('','asf-592',0) RETURN  #CHI-960054    #TQC-AB0395
       CALL cl_err('','axr-101',0) RETURN  #TQC-AB0395
    END IF

    #送簽中單據不可修改
    IF g_snb.snb99 = 'S' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF

    CALL cl_opmsg('b')


    LET g_forupd_sql = "SELECT * FROM sna_file",
                       " WHERE sna01 = ? AND sna02 = ? AND sna04 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t803_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01=g_snb.snb01 #sui
    IF NOT cl_null(g_snb.snb08a) THEN
        LET l_sfb08=g_snb.snb08a
    END IF
    IF g_rec_b=0 THEN CALL g_sna.clear() END IF

    INPUT ARRAY g_sna WITHOUT DEFAULTS FROM s_sna.*

          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)


        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

#FUN-A60070 --begin--
            LET g_sfb05 = NULL
            LET g_sfb06 = NULL
            SELECT sfb05,sfb06 INTO g_sfb05,g_sfb06
              FROM sfb_file
             WHERE sfb01 = g_snb.snb01
#FUN-A60070 --end--

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET l_sna06a=0
            BEGIN WORK

            OPEN t803_cl USING g_snb.snb01,g_snb.snb02
            IF STATUS THEN
               CALL cl_err("OPEN t803_cl:", STATUS, 1)
               CLOSE t803_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t803_cl INTO g_snb.*     #鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0) # 資料被他人LOCK
                  CLOSE t803_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sna_t.* = g_sna[l_ac].*  #BACKUP
               LET g_sna12a_t = g_sna[l_ac].sna12a       #FUN-910088--add--
               OPEN t803_bcl USING g_snb.snb01,g_snb.snb02,g_sna_t.sna04
               IF STATUS THEN
                  CALL cl_err("OPEN t803_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t803_bcl INTO b_sna.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sna_t.sna04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_sna[l_ac].ima02b = t803_sna03(p_cmd,g_sna[l_ac].sna03b)
                     LET g_sna[l_ac].ima02a = t803_sna03(p_cmd,g_sna[l_ac].sna03a)
                     LET g_sna[l_ac].ima021b = t803_sna03_1(p_cmd,g_sna[l_ac].sna03b)    #CHI-C20053
                     LET g_sna[l_ac].ima021a = t803_sna03_1(p_cmd,g_sna[l_ac].sna03a)    #CHI-C20053
                  END IF
                  IF cl_null(g_sna[l_ac].sna08b) THEN LET g_sna[l_ac].sna08b = ' ' END IF
                 #IF cl_null(g_sna[l_ac].sna08a) THEN LET g_sna[l_ac].sna08a = ' ' END IF   #No:TQC-B60183 mark
               END IF
               SELECT * INTO g_sfa.* FROM sfa_file
                WHERE sfa01=g_snb.snb01
                  AND sfa03=g_sna[l_ac].sna03b
                  AND sfa08=g_sna[l_ac].sna08b
                  AND sfa12=g_sna[l_ac].sna12b
                  AND sfa27=b_sna.sna27b        #No.FUN-870051
                  AND sfa012 = g_sna[l_ac].sna012b   #FUN-A60070
                  AND sfa013 = g_sna[l_ac].sna013b   #FUN-A60070
               CALL t803_set_entry_b(p_cmd)       #No.MOD-7B0170 add
               CALL t803_set_no_entry_b(p_cmd)    #No.MOD-7B0170 add
            END IF
            CALL t803_set_no_required()                 #TQC-AB0395
            CALL t803_set_required(g_sna[l_ac].safter)  #TQC-AB0395
            CALL cl_set_comp_entry("sna11a",g_sfb.sfb39<>'2') #倒扣料不可修改棋標
           #CHI-C90030 start mark-----
           ##FUN-C10045---begin
           #LET l_cnt = 0
           #SELECT COUNT(*) INTO l_cnt FROM sfb_file,pmm_file,pmn_file
           # WHERE sfb01 = g_snb.snb01
           #AND sfb39 = '1'
           #AND sfbacti = 'Y'
           #AND ( sfb02 = '7' OR sfb02 = '8' )
           #AND pmn41 = sfb01
           #AND pmn01 = pmm01
           #AND pmm18 != 'X'
           #IF l_cnt > 0 THEN
           #  #CALL cl_set_comp_entry("sna605a",TRUE)   #MOD-C90114 mark
           #   CALL cl_set_comp_entry("sna065a",TRUE)   #MOD-C90114
           #   CALL cl_set_comp_entry("sna012a,sna013a,sna03a,sna05a,sna161a,sna26a,sna28a,sna29a,sna12a,sna13a,sna11a,sna08a,sna50",FALSE)
           #   ELSE
           #  #CALL cl_set_comp_entry("sna605a",FALSE)  #MOD-C90114 mark
           #   CALL cl_set_comp_entry("sna065a",FALSE)  #MOD-C90114
           #   CALL cl_set_comp_entry("sna012a,sna013a,sna03a,sna05a,sna161a,sna26a,sna28a,sna29a,sna12a,sna13a,sna08a,sna50",TRUE)
           #   CALL cl_set_comp_entry("sna11a",g_sfb.sfb39<>'2')
           #END IF
           ##FUN-C10045---end
           #CHI-C90030 end mark-----
           CALL t803_chk_sna065a(g_sna[l_ac].sna03b)   #CHI-C90030 add
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_sna[l_ac].* TO NULL      #900423
            LET g_sna_t.* = g_sna[l_ac].*         #新輸入資料
            LET g_sna[l_ac].sna08b = ' '  #No.MOD-980140   #No:TQC-B60183 modify
            LET g_sna[l_ac].sbefore=0
            LET g_sna[l_ac].safter=1
            LET l_subqty=0
            LET g_sna12a_t = NULL      #FUN-910088--add--
            CALL t803_pop_sna04() #FUN-6B0048
            IF NOT cl_null(g_multi_sna03b) THEN   #MOD-DC0038
               RETURN     #FUN-D60056
            END IF                                #MOD-DC0038
            CALL t803_chk_sna065a(g_sna[l_ac].sna03b)        #CHI-C90030 add
            NEXT FIELD sna04

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_sna[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_sna[l_ac].* TO s_sna.*
              CALL g_sna.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF

            #WHEN無輸入任何變更資料
            IF cl_null(g_sna[l_ac].sna03a) AND
               cl_null(g_sna[l_ac].sna05a) AND
               cl_null(g_sna[l_ac].sna065a) AND  #FUN-C10045
               cl_null(g_sna[l_ac].sna161a) AND
               cl_null(g_sna[l_ac].sna26a) AND  #FUN-990059
               cl_null(g_sna[l_ac].sna12a) AND
               cl_null(g_sna[l_ac].sna13a) AND
               cl_null(g_sna[l_ac].sna11a) AND
              #cl_null(g_sna[l_ac].sna08a) AND    #MOD-B30063 mark
               g_sna[l_ac].sna08a IS NULL AND     #MOD-B30063 add
#TQC-A60120 --begin--
               cl_null(g_sna[l_ac].sna012a) AND
               cl_null(g_sna[l_ac].sna013a) AND
#TQC-A60120 --end--
               cl_null(g_sna[l_ac].sna50) THEN
               CALL cl_err('','asf-092',1)
               NEXT FIELD sna03a
            END IF
            IF cl_null(g_sna[l_ac].sna08b) THEN LET g_sna[l_ac].sna08b = ' ' END IF
           #IF cl_null(g_sna[l_ac].sna08a) THEN LET g_sna[l_ac].sna08a = ' ' END IF   #No:TQC-B60183 mark
#TQC-A60120 --mark--
##FUN-A60070 --begin--
#            IF cl_null(g_sna[l_ac].sna012a) THEN LET g_sna[l_ac].sna012a = ' ' END IF
#            IF cl_null(g_sna[l_ac].sna013a) THEN LET g_sna[l_ac].sna013a = 0   END IF
##FUN-A60070 --end--
##TQC-A60120 --mark--
            IF NOT cl_null(g_sna[l_ac].sna05a) THEN
               IF g_sna[l_ac].sna11a = 'X'
                  OR (g_sna[l_ac].sna11b = 'X' AND g_sna[l_ac].sna11a IS NULL) THEN
                  LET g_sna[l_ac].sna05a = 0
                  DISPLAY BY NAME g_sna[l_ac].sna05a
               END IF
            END IF
           #str MOD-BB0218 add
           #單身新增時,先以key值檢查資料是否已存在工單備料檔,若已存在則不允許存檔
            IF g_sna[l_ac].safter=2 THEN   #新增
               IF cl_null(g_sna[l_ac].sna08a) THEN LET g_sna[l_ac].sna08a = ' ' END IF
               IF cl_null(g_sna[l_ac].sna012a) THEN LET g_sna[l_ac].sna012a = ' ' END IF
               IF cl_null(g_sna[l_ac].sna013a) THEN LET g_sna[l_ac].sna013a = 0   END IF
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM sfa_file
                WHERE sfa01 = g_snb.snb01
                  AND sfa03 = g_sna[l_ac].sna03a
                  AND sfa08 = g_sna[l_ac].sna08a
                  AND sfa12 = g_sna[l_ac].sna12a
                  AND sfa27 = g_sna[l_ac].sna03a
                  AND sfa012= g_sna[l_ac].sna012a
                  AND sfa013= g_sna[l_ac].sna013a
               IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
               IF l_cnt > 0 THEN   #表示這筆資料若回寫回sfa_file會出現資料重覆的問題,應提示訊息不允許新增此資料
                  CALL cl_err('','asf-200',1)
                  NEXT FIELD sna03a
               END IF
            END IF
           #end MOD-BB0218 add
            INSERT INTO sna_file(sna01,sna02,sna04,sna03b,sna05b,sna065b,sna161b,sna26b,sna12b,sna13b, #FUN-990059  #FUN-C10045 sna065b
                                    sna11b,sna08b,sna03a,sna05a,sna065a,sna161a,sna26a,sna12a,		   #FUN-990059  #FUN-C10045 sna065a
                                    sna13a,sna11a,sna08a,sna50,sna28b,sna28a, #No.MOD-8A0179 add sna28b,sna28a
                                    snaplant,snalegal,sna012b,sna013b,sna012a,sna013a,sna29a,sna27a)    #FUN-980008 add #FUN-B20056 add sna29a
                                          #FUN-A60070 add sna012b,sna013b,sna012a,sna013a    #TQC-C20403 add ,sna27a
               VALUES(g_snb.snb01,g_snb.snb02,g_sna[l_ac].sna04,g_sna[l_ac].sna03b,
                      g_sna[l_ac].sna05b,g_sna[l_ac].sna065b,g_sna[l_ac].sna161b,g_sna[l_ac].sna26b,g_sna[l_ac].sna12b,g_sna[l_ac].sna13b, #FUN-990059  #FUN-C10045  g_sna[l_ac].sna065b
                      g_sna[l_ac].sna11b,g_sna[l_ac].sna08b,g_sna[l_ac].sna03a,g_sna[l_ac].sna05a,g_sna[l_ac].sna065a,  #FUN-C10045  g_sna[l_ac].sna065a
                      g_sna[l_ac].sna161a,g_sna[l_ac].sna26a,g_sna[l_ac].sna12a,g_sna[l_ac].sna13a,g_sna[l_ac].sna11a, #FUN-990059
                      g_sna[l_ac].sna08a,g_sna[l_ac].sna50,g_sna[l_ac].sna28b,g_sna[l_ac].sna28a, #No.MOD-8A0179 add sna28b,sna28a
                      g_plant,g_legal,g_sna[l_ac].sna012b,g_sna[l_ac].sna013b,g_sna[l_ac].sna012a,g_sna[l_ac].sna013a,    #FUN-980008 add
                      g_sna[l_ac].sna29a,g_sna27b) #FUN-B20056 add sna29a
                                       #FUN-A60070 add sna012b,sna013b,sna012a,sna013a   #TQC-C20403 add  ,g_sna27b
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sna_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_snb99 = '0'     #FUN-920208 add
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE FIELD sna04
            IF p_cmd = 'a' AND cl_null(g_sna[l_ac].sna04) THEN
               SELECT MAX(sna04)+1 INTO g_sna[l_ac].sna04 FROM sna_file
                WHERE sna01=g_snb.snb01
                  AND sna02=g_snb.snb02
               IF cl_null(g_sna[l_ac].sna04) THEN
                  LET g_sna[l_ac].sna04 = 1
               END IF
            END IF

        AFTER FIELD sna04
            IF NOT cl_null(g_sna[l_ac].sna04)  THEN   # 重要欄位不可空白
               #-->是否有重復輸入項次
               IF p_cmd = "a" OR                     # 若輸入或更改且改KEY  #FUN-D60056
                 (p_cmd = "u" AND g_sna[l_ac].sna04 != g_sna_t.sna04) THEN
                  SELECT COUNT(*) INTO l_n FROM sna_file
                   WHERE sna01 = g_snb.snb01
                     AND sna02 = g_snb.snb02
                     AND sna04 = g_sna[l_ac].sna04
              #    IF l_n > 0 THEN                   # Duplicated
              #        CALL cl_err(g_sna[l_ac].sna04,-239,0)
              #        LET g_sna[l_ac].sna04 = g_sna_t.sna04
              #        NEXT FIELD sna04
              #    END IF
               END IF

               #檢查該項次是否存在子工單
               SELECT *  FROM sfb_file
                WHERE sfb86 = g_snb.snb01 AND sfb05=g_sna[l_ac].sna03b
                  AND sfbacti = 'Y'
               IF SQLCA.sqlcode=0 THEN
                  IF NOT cl_confirm('asf-051') THEN
                     INITIALIZE g_sna[l_ac].* TO NULL
                     LET g_sna[l_ac].sna04=l_ac
                    #DISPLAY g_sna[l_ac].sna04 TO s_sna.sna04       #MOD-930138 mark
                     DISPLAY BY NAME g_sna[l_ac].sna04              #MOD-930138 add
                     NEXT FIELD sna04
                  END IF
               END IF
           #CHI-C90030 start mark-----
           ##FUN-C10045---begin
           #LET l_cnt = 0
           #SELECT COUNT(*) INTO l_cnt FROM sfb_file,pmm_file,pmn_file
           # WHERE sfb01 = g_snb.snb01
           #AND sfb39 = '1'
           #AND sfbacti = 'Y'
           #AND ( sfb02 = '7' OR sfb02 = '8' )
           #AND pmn41 = sfb01
           #AND pmn01 = pmm01
           #AND pmm18 != 'X'
           #IF l_cnt > 0 THEN
           #   CALL cl_set_comp_entry("sna161a",FALSE)
           #ELSE
           #   CALL cl_set_comp_entry("sna065a",FALSE)
           ##FUN-C10045---end
           #CHI-C90030 end mark-----
               IF g_sna[l_ac].sna161b=0 THEN
                  CALL cl_set_comp_entry("sna161a",FALSE)
               ELSE
                      CALL cl_set_comp_entry("sna161a",TRUE)
               END IF
               CALL t803_chk_sna065a(g_sna[l_ac].sna03b)   #CHI-C90030 add
           #END IF #FUN-C10045  #CHI-C90030 mark
               IF NOT cl_null(g_sna[l_ac].sna03b) THEN
                  LET l_subqty=0
                  SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
                           WHERE sfa01 = g_snb.snb01
                               AND sfa27 = g_sna[l_ac].sna03b
                               AND sfa26 IN ('S','U','Z')   #FUN-A20037 add Z
                  IF cl_null(l_subqty) THEN
                    LET l_subqty=0
                  END IF
                  IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
                     LET l_subqty=l_subqty*g_snb.snb08a/g_snb.snb08b
                  END IF
               END IF
            ELSE
               NEXT FIELD sna04
            END IF
#FUN-C30147---begin
        AFTER FIELD sna065a
           IF NOT cl_null(g_sna[l_ac].sna065a) THEN
              LET l_pmn20 = 0
              SELECT SUM(pmn20) INTO l_pmn20
                FROM pmm_file,pmn_file
               WHERE pmn41 = g_snb.snb01
                 AND pmn01 = pmm01
                 AND pmm18 = 'Y'
                 AND pmn04 = g_sna[l_ac].sna03b
              IF g_sna[l_ac].sna065a < l_pmn20 THEN
                 CALL cl_err(g_msg,'asf-280',1)
                 NEXT FIELD sna065a
              END IF
           END IF
#FUN-C30147---end
        AFTER FIELD sna08a
         #IF g_sna[l_ac].sna08a IS NULL THEN LET g_sna[l_ac].sna08a = ' ' END IF  #No:TQC-B60183 mark
         #IF p_cmd = 'a' OR p_cmd = 'u' AND    #MOD-B40140 mark
          IF p_cmd = 'u' AND                   #MOD-B40140 add
             g_sna[l_ac].sna08a <> g_sna_t.sna08a THEN
             CALL t803_check_duplicate_2(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_msg,g_errno,1)
                NEXT FIELD sna08a
             END IF
          END IF
         #IF NOT cl_null(g_sna[l_ac].sna08a) THEN        #MOD-B30063 mark
          IF g_sna[l_ac].sna08a IS NOT NULL AND g_sna[l_ac].sna08a != ' ' THEN    #MOD-B30063 add
             SELECT COUNT(*) INTO l_cnt FROM ecd_file
              WHERE ecd01 = g_sna[l_ac].sna08a
                AND ecdacti = 'Y'
             IF l_cnt = 0 THEN
                CALL cl_err('','axm-233',0)
                NEXT FIELD sna08a
             END IF
          END IF
         #MOD-CC0043---add---S
          IF NOT cl_null(g_sna[l_ac].sna08a) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM ecm_file
              WHERE ecm01 = g_snb.snb01
                AND ecm04 = g_sna[l_ac].sna08a

             IF l_cnt = 0 THEN
                CALL cl_err(g_snb.snb01,'aec-997',0)
                NEXT FIELD sna08a
             END IF
          END IF
         #MOD-CC0043---add---E

#FUN-A60070 --begin--
        AFTER FIELD sna012a
#TQC-A60120 --begin--
#            IF cl_null(g_sna[l_ac].sna012a) THEN
#               LET g_sna[l_ac].sna012a = ' '
#            END IF
#TQC-A60120 --end--
            IF g_sna[l_ac].sna012a IS NOT NULL THEN
               CALL t803_sna012a()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD CURRENT
               END IF
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM bra_file
                WHERE bra01  = g_sfb05
                  AND bra011 = g_sfb06
                  AND bra012 = g_sna[l_ac].sna012a
               IF l_cnt = 0 THEN
                  IF g_sma.sma887[1]='Y' THEN
                     CALL cl_err('sel bom:','asf-136',1)
                     NEXT FIELD CURRENT
                  END IF
                  IF g_sma.sma887[1]='W' THEN
                     IF NOT cl_confirm('asf-137') THEN
                        NEXT FIELD CURRENT
                     END IF
                  END IF
               END IF
            END IF

        AFTER FIELD sna013a
#TQC-A60120 --begin--
#            IF cl_null(g_sna[l_ac].sna013a) THEN
#               LET g_sna[l_ac].sna013a = 0
#            END IF
#TQC-A60120 --end--
           IF NOT cl_null(g_sna[l_ac].sna013a) AND NOT cl_null(g_sna[l_ac].sna012a) THEN    #TQC-A60120
            LET l_cnt = 0

           #FUN-B10056 ------------mod start---------------------------
           #CALL s_schdat_sel_ima571(g_snb.snb01) RETURNING l_flag,l_sfb05    #TQC-AC0374 add
           #SELECT COUNT(*) INTO l_cnt FROM ecu_file,ecb_file
           # WHERE ecu01=ecb01
           #   AND ecu02=ecb02
           #   AND ecu012 = ecb012
           #   AND ecu10 = 'Y'
           #   AND ecuacti = 'Y'
           #   #AND ecb01 = g_sfb05        #TQC-AC0374  mark
           #   AND ecb01 = l_sfb05         #TQC-AC0374  add
           #   AND ecb02 = g_sfb06
           #   AND ecb012 = g_sna[l_ac].sna012a
           #   AND ecb03  = g_sna[l_ac].sna013a
           #   IF l_cnt = 0 THEN
           #      CALL cl_err('','abm-215',0)
           #      NEXT FIELD CURRENT
           #   END IF
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm01 = g_snb.snb01
               AND ecm03 = g_sna[l_ac].sna013a
               AND ecm012  = g_sna[l_ac].sna012a
            IF l_cnt = 0 THEN
               CALL cl_err('','abm-215',0)
               NEXT FIELD CURRENT
            END IF
           #FUN-B10056 ------------mod end------------------------------------

               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM bra_file
                WHERE bra01  = g_sfb05
                  AND bra011 = g_sfb06
                  AND bra012 = g_sna[l_ac].sna012a
                  AND bra013 = g_sna[l_ac].sna013a
               IF l_cnt = 0 THEN
                  IF g_sma.sma887[1]='Y' THEN
                     CALL cl_err('sel bom:','asf-136',1)
                     NEXT FIELD CURRENT
                  END IF
                  IF g_sma.sma887[1]='W' THEN
                     IF NOT cl_confirm('asf-137') THEN
                        NEXT FIELD CURRENT
                     END IF
                  END IF
               END IF
             END IF     #TQC-A60120 add
#FUN-A60070 --end--

        BEFORE FIELD sna03a
             IF  cl_null(g_sna[l_ac].sna03b)  THEN
                 LET g_sna[l_ac].safter=2
                #DISPLAY g_sna[l_ac].safter TO s_sna[l_ac].safter       #MOD-930138 mark
                 DISPLAY BY NAME g_sna[l_ac].safter                     #MOD-930138 add
                 CALL t803_set_required(g_sna[l_ac].safter)  #TQC-AB0395
             ELSE
                 LET g_sna[l_ac].safter=1
                #DISPLAY g_sna[l_ac].safter TO s_sna[l_ac].safter       #MOD-930138 mark
                 DISPLAY BY NAME g_sna[l_ac].safter                     #MOD-930138 add
                 CALL t803_set_no_required()  #TQC-AB0395
             END IF
             INITIALIZE g_sfa.* TO NULL
             SELECT * INTO g_sfa.*
               FROM sfa_file
              WHERE sfa01=g_snb.snb01
                AND sfa03=g_sna[l_ac].sna03b
                AND sfa08=g_sna[l_ac].sna08b
                AND sfa12=g_sna[l_ac].sna12b
                AND sfa27=b_sna.sna27b #No.FUN-870051
                AND sfa012 = g_sna[l_ac].sna012b    #FUN-A60070
                AND sfa013 = g_sna[l_ac].sna013b    #FUN-A60070
             CALL t803_set_entry_b(p_cmd)       #No.MOD-7B0170 add
             CALL t803_set_no_entry_b(p_cmd)    #No.MOD-7B0170 add

        AFTER FIELD sna03a
             LET l_case = "" #FUN-910088 add
             IF NOT cl_null(g_sna[l_ac].sna03a) THEN
#FUN-AA0059 ---------------------start----------------------------
                 IF NOT s_chk_item_no(g_sna[l_ac].sna03a,"") THEN
                    CALL cl_err('',g_errno,1)
                    LET g_sna[l_ac].sna03a= g_sna_t.sna03a
                    NEXT FIELD sna03a
                 END IF
#FUN-AA0059 ---------------------end-------------------------------

                 #MOD-AA0160---mark---start---
                 #LET l_cnt1 = 0
                 #   SELECT COUNT(*) INTO l_cnt1 FROM sfa_file
                 #    WHERE sfa01 = g_snb.snb01
                 #      AND sfa03 = g_sna[l_ac].sna03a
                 #IF l_cnt1 > 0 THEN
                 #   CALL cl_err(g_sna[l_ac].sna03a,'asf-595',1)
                 #   NEXT FIELD sna03a
                 #END IF
                 #MOD-AA0160---mark---end---
                  CALL t803_sna03('',g_sna[l_ac].sna03a) RETURNING  g_sna[l_ac].ima02a
                  CALL t803_sna03_1('',g_sna[l_ac].sna03a) RETURNING  g_sna[l_ac].ima021a    #CHI-C20053
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_sna[l_ac].sna03a,g_errno,0)
                     NEXT FIELD sna03a
                  END IF
                  CALL t803_check_sna03b()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_sna[l_ac].sna03b,g_errno,1)
                     NEXT FIELD sna03a
                  END IF
                 #IF p_cmd = 'a' OR p_cmd = 'u' AND    #MOD-B40140 mark
                  IF p_cmd = 'u' AND                   #MOD-B40140 add
                     g_sna[l_ac].sna03a <> g_sna_t.sna03a THEN
                     CALL t803_check_duplicate_2(p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_msg,g_errno,1)
                        NEXT FIELD sna03a
                     END IF
                  END IF
                  LET g_sna[l_ac].sna12a=g_ima.ima63
                  LET g_sna[l_ac].sna13a=g_ima.ima63_fac
                  LET g_sna[l_ac].sna28a = 1
                  LET g_sna[l_ac].sna161a = 1
                #FUN-910088--add--start--
                  CALL t803_sna05a_check(l_subqty,l_sfb08) RETURNING l_case,l_subqty
                  LET g_sna12a_t = g_sna[l_ac].sna12a
                #FUN-910088--add--end--
                  IF g_ima.ima70='Y' OR g_sfb.sfb39 = '2' THEN   #MOD-990150
                    LET g_sna[l_ac].sna11a='E'
                  ELSE
                  	LET g_sna[l_ac].sna11a='N'
                  END IF
                  IF g_sfa.sfa06 > 0 THEN
                     CALL cl_err(g_sna[l_ac].sna03a,'asf-973',0)
                     LET g_sna[l_ac].sna03a = NULL
                  END IF
                  IF NOT t803_chk_bom(g_sna[l_ac].sna03a) THEN
                     NEXT FIELD sna03a
                  END IF
                 #MOD-AB0228---add---start---
                  IF g_sna[l_ac].safter = 2 THEN
                     LET l_bmb16 = NULL
                     SELECT bmb16 INTO l_bmb16 FROM bmb_file
                      WHERE bmb01 = g_sfb.sfb05
                        AND bmb29 = g_sfb.sfb95
                        AND bmb03 = g_sna[l_ac].sna03a
                        AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
                        AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
                     LET g_sna[l_ac].sna26a = l_bmb16
                  END IF
                 #MOD-AB0228---add---end---
             END IF
             IF g_sna[l_ac].safter=2 AND cl_null(g_sna[l_ac].sna03a) THEN
                 NEXT FIELD sna03a
             END IF
         #FUN-910088--add--start--
             CASE l_case
                WHEN "sna05a"
                   NEXT FIELD sna05a
                WHEN "sna28a"
                   NEXT FIELD san28a
                WHEN "sna161a"
                   NEXT FIELD sna161a
                OTHERWISE EXIT CASE
             END CASE
        #FUN-910088--add--end--

        AFTER FIELD sna11a

            IF NOT cl_null(g_sna[l_ac].sna11a) THEN
               IF g_sna[l_ac].sna11a NOT MATCHES '[NEVURXCS]' THEN  #CHI-980013 add X #FUN-A30093  #FUN-C10049 S
                  NEXT FIELD sna11a
               END IF
              #CHI-BA0015 str add-----
               CALL t803_chk_sna11a(l_ac) RETURNING l_sna11a_err
               IF l_sna11a_err = '1' THEN
                  NEXT FIELD sna11a
               END IF
              #CHI-BA0015 end add-----
            END IF

        #FUN-B20056 --START--
        AFTER FIELD sna29a
           IF NOT cl_null(g_sna[l_ac].sna29a) THEN
              IF NOT s_chk_item_no(g_sna[l_ac].sna29a,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_sna[l_ac].sna29a= g_sna_t.sna29a
                 NEXT FIELD sna29a
              END IF
           END IF
        #FUN-B20056 --END--

        #--->單位需存在于單位檔中
        AFTER FIELD sna12a
            #采購單位,須存在
             IF NOT cl_null(g_sna[l_ac].sna12a) THEN
                CALL t803_unit(g_sna[l_ac].sna12a)   #是否存在于單位檔中
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_sna[l_ac].sna12a,g_errno,0)
                   LET g_sna[l_ac].sna12a = g_sna_t.sna12a
                   DISPLAY BY NAME g_sna[l_ac].sna12a
                   NEXT FIELD sna12a
                END IF
               #IF p_cmd = 'a' OR p_cmd = 'u' AND   #MOD-B40140 mark
                IF p_cmd = 'u' AND                  #MOD-B40140 add
                   g_sna[l_ac].sna12a <> g_sna_t.sna12a THEN
                   CALL t803_check_duplicate_2(p_cmd)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_msg,g_errno,1)
                      NEXT FIELD sna12a
                   END IF
                END IF
                #檢查單身資料是否重覆
                SELECT count(*) INTO l_n FROM sna_file
                 WHERE sna01=g_snb.snb01
                   AND sna03a=g_sna[l_ac].sna03a
                   AND sna08a=g_sna[l_ac].sna08a
                   AND sna12a=g_sna[l_ac].sna12a
                   AND sna04 !=g_sna[l_ac].sna04
                   AND sna02 =g_snb.snb02
                   AND sna012a=g_sna[l_ac].sna012a   #FUN-A60070
                   AND sna013a=g_sna[l_ac].sna013a   #FUN-A60070
                IF l_n > 1 THEN
                   CALL cl_err('',-239,1) NEXT FIELD sna04
                END IF
                #變更發料單位與庫存單位的轉化率
                IF cl_null(g_sna[l_ac].sna03a) THEN
                   CALL s_umfchk(g_sna[l_ac].sna03b,g_sna[l_ac].sna12a,
                                 g_ima.ima25)
                                 RETURNING l_n,g_sna[l_ac].sna13a
                ELSE
                   CALL s_umfchk(g_sna[l_ac].sna03a,g_sna[l_ac].sna12a,
                                 g_ima.ima25)
                                 RETURNING l_n,g_sna[l_ac].sna13a
                END IF
                IF l_n = 1 THEN
                   CALL cl_err('','mfg3075',0) NEXT FIELD sna12a
                END IF
             #FUN-910088--add--start--
                CALL t803_sna05a_check(l_subqty,l_sfb08) RETURNING l_case,l_subqty
                LET g_sna12a_t = g_sna[l_ac].sna12a
                CASE l_case
                   WHEN "sna05a"
                      NEXT FIELD sna05a
                   WHEN "sna28a"
                      NEXT FIELD san28a
                   WHEN "sna161a"
                      NEXT FIELD sna161a
                   OTHERWISE EXIT CASE
                END CASE
             #FUN-910088--add--end--
             END IF


        AFTER FIELD sna05a  #應發數量
          #FUN-910088--add--start--
            CALL t803_sna05a_check(l_subqty,l_sfb08) RETURNING l_case,l_subqty
            CASE l_case
               WHEN "sna05a"
                  NEXT FIELD sna05a
               WHEN "sna28a"
                  NEXT FIELD sna28a
               WHEN "sna161a"
                  NEXT FIELD sna161a
               OTHERWISE EXIT CASE
            END CASE
          #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #    #變更後應發與QPA要同時有值或同時無值
       #    IF NOT (cl_null(g_sna[l_ac].sna05a) AND
       #            cl_null(g_sna[l_ac].sna161a)) THEN
       #       IF cl_null(g_sna[l_ac].sna05a) THEN
       #          NEXT FIELD sna05a
       #       END IF
       #    END IF
       #    IF NOT cl_null(g_sna[l_ac].sna05a) THEN
       #       IF g_sfb.sfb02 NOT MATCHES '[58]' THEN
       #          CALL t803_sna05a()
       #	  IF NOT cl_null(g_errno) THEN
       #             LET l_msg = cl_getmsg(g_errno,g_lang)
       #             LET l_msg = l_msg,',',cl_getmsg('lib-005',g_lang)
       #             IF NOT cl_confirm(l_msg) THEN
       #                NEXT FIELD sna05a
       #             END IF
       #	  END IF
       #       END IF
       #      #str MOD-A70165 add
       #       LET l_sna04=g_sna[l_ac].sna04
       #       LET l_sna06a=0
       #       SELECT sna06a INTO l_sna06a FROM sna_file
       #        WHERE sna01=g_snb.snb01
       #          AND sna02=g_snb.snb02 AND sna04=l_sna04
       #      #end MOD-A70165 add
       #       IF g_sfa.sfa26 MATCHES '[SUsuZz]' THEN   #替代料只能變更替代率  #MOD-890289  #FUN-A20037 add Zz
       #         #str MOD-A70165 mark  #移到IF前面
       #         #LET l_sna04=g_sna[l_ac].sna04
       #         #SELECT sna06a INTO l_sna06a FROM sna_file
       #         # WHERE sna01=g_snb.snb01
       #         #   AND sna02=g_snb.snb02 AND sna04=l_sna04
       #         #end MOD-A70165 mark
       #          IF NOT cl_null(l_sna06a) AND l_sna06a!=0 THEN
       #             LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/l_sna06a*g_sna[l_ac].sna28b #考慮單頭變更的狀況
       #          ELSE
       #             LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/g_sna[l_ac].sna05b*g_sna[l_ac].sna28b
       #          END IF
       #         #DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a         #MOD-930138 mark
       #         #DISPLAY g_sna[l_ac].sna28a TO s_sna[l_ac].sna28a         #MOD-930138 mark
       #          DISPLAY BY NAME g_sna[l_ac].sna05a                       #MOD-930138 add
       #          DISPLAY BY NAME g_sna[l_ac].sna28a                       #MOD-930138 add
       #          NEXT FIELD sna28a
       #       ELSE
       #         #str MOD-A70165 add
       #          LET l_subqty=0
       #          IF NOT cl_null(g_sna[l_ac].sna03b) THEN
       #             SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
       #              WHERE sfa01 = g_snb.snb01
       #                AND sfa27 = g_sna[l_ac].sna03b
       #               #AND sfa26 IN ('S','U')       #MOD-BA0105 mark
       #                AND sfa26 NOT IN ('S','U')   #MOD-BA0105
       #             IF cl_null(l_subqty) THEN
       #               LET l_subqty=0
       #             END IF
       #             IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
       #                LET l_subqty=l_subqty*g_snb.snb08a/g_snb.snb08b
       #             END IF
       #          END IF
       #         #end MOD-A70165 add
       #          IF NOT cl_null(l_sna06a) AND l_sna06a!=0 THEN
       #            #LET g_sna[l_ac].sna161a=(l_sna06a+l_subqty)/l_sfb08         #MOD-BA0105 mark
       #             LET g_sna[l_ac].sna161a = g_sna[l_ac].sna05a/g_snb.snb08a   #MOD-BA0105
       #          ELSE
       #             IF NOT cl_null(g_sna[l_ac].sna03a) THEN
       #                SELECT COUNT(*) INTO l_cnt FROM sfa_file
       #                 WHERE sfa01 = g_snb.snb01
       #                   AND sfa27 = g_sna[l_ac].sna03a
       #             ELSE
       #                SELECT COUNT(*) INTO l_cnt FROM sfa_file
       #                WHERE sfa01 = g_snb.snb01
       #                  AND sfa27 = g_sna[l_ac].sna03b
       #             END IF
       #             IF l_cnt > 0 THEN
       #               #LET g_sna[l_ac].sna161a=(g_sna[l_ac].sna05a+l_subqty)/l_sfb08   #MOD-BA0105 mark
       #                LET g_sna[l_ac].sna161a = g_sna[l_ac].sna05a/l_sfb08            #MOD-BA0105
       #             ELSE
       #                LET g_sna[l_ac].sna161a=g_sna[l_ac].sna161b
       #             END IF
       #          END IF
       #
       #         #DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a         #MOD-930138 mark
       #         #DISPLAY g_sna[l_ac].sna161a TO s_sna[l_ac].sna161a       #MOD-930138 mark
       #          DISPLAY BY NAME g_sna[l_ac].sna05a                       #MOD-930138 add
       #          DISPLAY BY NAME g_sna[l_ac].sna161a                      #MOD-930138 add
       #          NEXT FIELD sna161a
       #       END IF
       #    END IF
       #FUN-910088--mark--end--
       BEFORE FIELD sna161a
           IF g_sna[l_ac].sna161b=0 THEN
              CALL cl_set_comp_entry("sna161a",FALSE)
           ELSE
              CALL cl_set_comp_entry("sna161a",TRUE)
           END IF
           CALL t803_chk_sna065a(g_sna[l_ac].sna03b)   #CHI-C90030 add

       AFTER FIELD sna161a  #單位用量
            #變更後應發與QPA要同時有值或同時無值
            IF NOT (cl_null(g_sna[l_ac].sna05a) AND
                    cl_null(g_sna[l_ac].sna161a)) THEN
               IF cl_null(g_sna[l_ac].sna161a) THEN
                  NEXT FIELD sna161a
               END IF
            END IF
            IF NOT cl_null(g_sna[l_ac].sna161a) THEN
               #主料應發=QPA*生產套數-主料被替代數量之和
               IF cl_null(g_sfa.sfa26) OR g_sfa.sfa26 MATCHES '[012457]' THEN    #No.MOD-930248 add  #FUN-A20037 add 7  #CHI-C50052 add 4
                 #str MOD-A70165 add
                  LET l_subqty=0
                  IF NOT cl_null(g_sna[l_ac].sna03b) THEN
                     SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
                      WHERE sfa01 = g_snb.snb01
                        AND sfa27 = g_sna[l_ac].sna03b
                        AND sfa26 IN ('S','U')
                     IF cl_null(l_subqty) THEN
                       LET l_subqty=0
                     END IF
                    #CHI-C50052 str mark-----
                    #IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
                    #   LET l_subqty=l_subqty*g_snb.snb08a/g_snb.snb08b
                    #END IF
                    #CHI-C50052 end mark-----
                  END IF
                 #end MOD-A70165 add
                 #CHI-C50052 str add-----
                  CALL t803_sna05_1(g_sna[l_ac].sna03b) RETURNING l_other,l_sfa161
                  IF g_snb.snb08a IS NOT NULL THEN
                     LET g_sna[l_ac].sna05a=l_sfb08*g_sna[l_ac].sna161a-l_other
                  ELSE
                 #CHI-C50052 end add-----
                     LET g_sna[l_ac].sna05a=l_sfb08*g_sna[l_ac].sna161a-l_subqty
                  END IF                                                                #CHI-C50052 add
                  LET l_sna05a=g_sna[l_ac].sna05a
                  IF NOT cl_null(g_sna[l_ac].sna03a) THEN
                     LET l_ima01 = g_sna[l_ac].sna03a
                  ELSE
                     LET l_ima01 = g_sna[l_ac].sna03b
                  END IF
                  IF cl_null(g_sna[l_ac].sna12a) THEN
                     LET l_sna12a = g_sna[l_ac].sna12b
                  ELSE
                     LET l_sna12a = g_sna[l_ac].sna12a
                  END IF
                  SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
                   WHERE ima01=l_ima01
                  IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
                  #check最少發料數量
                  #若發料數不為0,才check最小發料數量
                 #IF l_ima641 <>  0 AND l_sna05a < l_ima641 THEN                    #MOD-A40088 mark
                  IF (l_ima641 <>  0 AND l_sna05a < l_ima641) AND l_sna05a >0 THEN  #MOD-A40088
                     LET l_sna05a = l_ima641
                  END IF
                  LET l_num_z=l_sna05a/l_ima64
                  LET l_num_y=l_sna05a-l_num_z*l_ima64
                  IF l_ima64 <> 0 AND (l_num_y) != 0 THEN
                     LET l_double=(l_sna05a/l_ima64)+ 0.999999
                     LET l_sna05a=l_double*l_ima64
                  END IF
                  IF l_sna05a <> g_sna[l_ac].sna05a THEN
                  # QPA=(主料新的應發+主料被替代數量之和)/生產套數
                     LET g_sna[l_ac].sna161a=(l_sna05a+l_subqty)/l_sfb08
                     LET g_sna[l_ac].sna05a = l_sna05a
                  END IF
                  SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sna12a
                  IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                  CALL cl_digcut(g_sna[l_ac].sna05a,l_gfe03) RETURNING g_sna[l_ac].sna05a
               END IF
              #DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a           #MOD-930138 mark
              #DISPLAY g_sna[l_ac].sna161a TO s_sna[l_ac].sna161a         #MOD-930138 mark
               DISPLAY BY NAME g_sna[l_ac].sna05a                         #MOD-930138 add
               DISPLAY BY NAME g_sna[l_ac].sna161a                        #MOD-930138 add
            END IF
            IF NOT t803_chk_short(g_snb.snb01) THEN
               IF cl_null(g_sna[l_ac].sna161a) THEN
                  NEXT FIELD sna05a
               ELSE
                  NEXT FIELD sna161a
               END IF
            END IF
           #CHI-BA0015 str add-----
            LET l_sna11a = null
            IF g_sna[l_ac].sna05a < 0 THEN
               LET l_sna11a = g_sna[l_ac].sna11a
               LET g_sna[l_ac].sna11a = 'S'
               CALL t803_chk_sna11a(l_ac) RETURNING l_sna11a_err
               IF l_sna11a_err = '1' THEN
                  LET g_sna[l_ac].sna11a =l_sna11a
                  NEXT FIELD sna161a
               END IF
            END IF
            IF g_sna[l_ac].sna05a >0 AND g_sna[l_ac].sna11b = 'S' THEN
               LET l_sna11a = g_sna[l_ac].sna11a
               LET g_sna[l_ac].sna11a = null
               CALL t803_chk_sna11a(l_ac) RETURNING l_sna11a_err
               IF l_sna11a_err = '1' THEN
                  LET g_sna[l_ac].sna11a =l_sna11a
                  NEXT FIELD sna161a
               END IF
            END IF
            DISPLAY BY NAME g_sna[l_ac].sna11a
           #CHI-BA0015 end add-----
       BEFORE FIELD sna28a
           IF g_sna[l_ac].sna161b=0 THEN
              CALL cl_set_comp_entry("sna161a",FALSE)
           ELSE
           	  CALL cl_set_comp_entry("sna161a",TRUE)
           END IF
       AFTER FIELD sna28a  #替代率
            IF NOT cl_null(g_sna[l_ac].sna28a) THEN
               IF g_sna[l_ac].safter !='2' THEN    #No.MOD-830205 add
                  IF g_sna[l_ac].sna28a<=0 THEN
                     LET g_sna[l_ac].sna28a=NULL
                     CALL cl_err('','afa-949',0)
                     NEXT FIELD sna28a
                  END IF
                 #str MOD-A70165 add
                  LET l_sna04=g_sna[l_ac].sna04
                  SELECT sna06a INTO l_sna06a FROM sna_file
                   WHERE sna01=g_snb.snb01
                     AND sna02=g_snb.snb02 AND sna04=l_sna04
                 #end MOD-A70165 add
                 #CHI-C50052 str mark-----
                 #IF NOT cl_null(l_sna06a) AND l_sna06a!=0 THEN
                 #   LET g_sna[l_ac].sna05a=l_sna06a*(g_sna[l_ac].sna28a/g_sna[l_ac].sna28b)
                 #ELSE
                 #   LET g_sna[l_ac].sna05a=g_sna[l_ac].sna05b*(g_sna[l_ac].sna28a/g_sna[l_ac].sna28b)
                 #END IF
                 #CHI-C50052 end mark-----
                 #CHI-C50052 str add-----
                  IF g_snb.snb08a IS NOT NULL THEN
                     CALL t803_sna05_1(g_sna[l_ac].sna03b) RETURNING l_other,l_sfa161
                     LET g_sna[l_ac].sna05a=g_sna[l_ac].sna28a*(g_snb.snb08a*l_sfa161-l_other)
                  ELSE
                     LET g_sna[l_ac].sna05a=g_sna[l_ac].sna28a*(g_sna[l_ac].sna05b/g_sna[l_ac].sna28b)
                  END IF
                 #CHI-C50052 end add-----
                   #考慮變更生產數量時,備料的最小發料數量及發料單位批量

                   IF cl_null(g_sna[l_ac].sna03a) THEN
                      LET l_sna03a = g_sna[l_ac].sna03b
                   ELSE
                      LET l_sna03a = g_sna[l_ac].sna03a
                   END IF

                   IF cl_null(g_sna[l_ac].sna12a) THEN
                      LET l_sna12a = g_sna[l_ac].sna12b
                   ELSE
                      LET l_sna12a = g_sna[l_ac].sna12a
                   END IF

                     SELECT ima64,ima641 INTO l_ima64,l_ima641
                       FROM ima_file    WHERE ima01=l_sna03a
                     IF l_ima641 != 0 AND g_sna[l_ac].sna05a < l_ima641 THEN
                         LET g_sna[l_ac].sna05a=l_ima641
                     END IF
                     IF l_ima64!=0 THEN
                        LET l_double=(g_sna[l_ac].sna05a/l_ima64)+ 0.999999
                        LET g_sna[l_ac].sna05a=l_double*l_ima64
                     END IF

                   #-->考慮單位小數取位
                    SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sna12a
                    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
                    CALL cl_digcut(g_sna[l_ac].sna05a,l_gfe03) RETURNING l_sfaqty
                    LET g_sna[l_ac].sna05a =  l_sfaqty
                  LET l_sna05a=g_sna[l_ac].sna05a
                  IF l_sna05a!=g_sna[l_ac].sna05a THEN
                     LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/g_sna[l_ac].sna05b*g_sna[l_ac].sna28b
                  END IF
                 #DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a              #MOD-930138 mark
                 #DISPLAY g_sna[l_ac].sna28a TO s_sna[l_ac].sna28a              #MOD-930138 mark
                  DISPLAY BY NAME g_sna[l_ac].sna05a                            #MOD-930138 add
                  DISPLAY BY NAME g_sna[l_ac].sna28a                            #MOD-930138 add
                  #此處的變更尚未更新到sfa_file,故需做特別處理,改以變更後的sfa05做欠料量計算
                  CALL s_shortqty_asft803_open(g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
                                               g_sna[l_ac].sna12b,g_sna[l_ac].sna05a,NULL)
                  CALL s_shortqty(p_sfb01,g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
                                  g_sna[l_ac].sna12b,l_sna27b,
                                  g_sna[l_ac].sna012b,g_sna[l_ac].sna013b      #TQC-A60087 ad
                                  ) RETURNING l_sfa07
                  CALL s_shortqty_asft803_close()  #open後必須close,這樣才能將sub的模組變數設為FALSE
                  IF l_sfa07<0 THEN
                     CALL cl_err('','asf-094',1)
                     IF cl_null(g_sna[l_ac].sna28a) THEN
                        NEXT FIELD sna05a
                     ELSE
                        NEXT FIELD sna28a
                     END IF
                  END IF
                END IF         #No.MOD-830205 add
            END IF

#        AFTER FIELD sna50        #FUN-A60070 mark

        BEFORE DELETE                            #是否取消單身
            IF g_sna_t.sna04 > 0 AND
               g_sna_t.sna04 IS NOT NULL THEN
                #若 變更後數量(snb08a)<>變更前數量(snb08b) 單身資料應不可刪除,若刪除,變更發出後,工單備料檔QPA會不正確
                IF (g_sna[l_ac].safter='1') AND (
                   (NOT cl_null(g_snb.snb08a)) AND (g_snb.snb08a<>g_snb.snb08b)
                  ) THEN
                   CALL cl_err('','asf-093',1)
                   CANCEL DELETE
                END IF
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM sna_file
                 WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                   AND sna04 = g_sna_t.sna04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sna_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET l_snb99 = '0'    #FUN-920208 add
                CALL t803_check_duplicate_2('d')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_msg,g_errno,1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sna[l_ac].* = g_sna_t.*
               CLOSE t803_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sna[l_ac].sna04,-263,1)
               LET g_sna[l_ac].* = g_sna_t.*
            ELSE
            	  CALL t803_tmp_move()
                UPDATE sna_file SET * = b_sna.*
                 WHERE sna01 = g_snb.snb01
                   AND sna02 = g_snb.snb02
                   AND sna04 = g_sna[l_ac].sna04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","sna_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_sna[l_ac].* = g_sna_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
                   LET l_snb99 = '0'    #FUN-920208 add
                   COMMIT WORK
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sna[l_ac].* = g_sna_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sna.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               LET l_snb99 = g_snb.snb99  #FUN-C30293
               CLOSE t803_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_snb99 = '0'  #FUN-C30293
            IF NOT cl_null(g_sna[l_ac].sna05a) THEN
               IF g_sna[l_ac].sna11a = 'X'
                  OR (g_sna[l_ac].sna11b = 'X' AND g_sna[l_ac].sna11a IS NULL) THEN
                  LET g_sna[l_ac].sna05a = 0
                  DISPLAY BY NAME g_sna[l_ac].sna05a
               END IF
            END IF
            #TQC-C20403 str add-----
            LET g_cnt = ARR_CURR()
            IF g_sna[g_cnt].safter=2 THEN
                UPDATE sna_file SET sna27b = g_sna[g_cnt].sna03a
                 WHERE sna01 = g_snb.snb01
                   AND sna02 = g_snb.snb02
                   AND sna04 = g_sna[g_cnt].sna04
            ELSE
                UPDATE sna_file SET sna27b = g_sna27b
                 WHERE sna01 = g_snb.snb01
                   AND sna02 = g_snb.snb02
                   AND sna04 = g_sna[g_cnt].sna04
                   AND sna27b IS NULL
            END IF
            #TQC-C20403 end add-----
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t803_bcl
            COMMIT WORK
           #CALL g_sna.deleteElement(g_rec_b+1)   #FUN-D40030 Mark

        ON ACTION controlp
           CASE                        #查詢符合條件的料號
             WHEN INFIELD(sna04)
                  IF p_cmd = 'a'  THEN
                     CALL t803_pop_sna04() #FUN-6B0048
                     IF NOT cl_null(g_multi_sna03b) THEN   #MOD-DC0038
                        RETURN        #FUN-D60056
                     END IF                                #MOD-DC0038
                     NEXT FIELD sna04
                  END IF
             WHEN INFIELD(sna08a)
                  CALL q_ecd( FALSE, TRUE,g_sna[l_ac].sna08a) RETURNING g_sna[l_ac].sna08a
                  NEXT FIELD sna08a
             WHEN INFIELD(sna12a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_sna[l_ac].sna12a
                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna12a
                  NEXT FIELD sna12a
             WHEN INFIELD(sna03a)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form     = "q_ima"
#                  LET g_qryparam.default1 = g_sna[l_ac].sna03a
#                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna03a
                   CALL q_sel_ima(FALSE, "q_ima","",g_sna[l_ac].sna03a,"","","","","",'' )
                   RETURNING  g_sna[l_ac].sna03a
#FUN-AA0059---------mod------------end-----------------
#FUN-A60070 --begin--
             WHEN INFIELD(sna012a)
                # SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file        #FUN-B10056 mark
                #  WHERE sfb01 = g_snb.snb01                                   #FUN-B10056 mark
                  CALL cl_init_qry_var()
                # LET g_qryparam.form     = "q_sna012"    #FUN-B10056 mark
                  LET g_qryparam.form     = "q_sgx012_2"  #FUN-B10056
                # LET g_qryparam.arg1     = l_sfb05       #FUN-B10056 mark
                # LET g_qryparam.arg2     = l_sfb06       #FUN-B10056 mark
                  LET g_qryparam.arg1     = g_snb.snb01   #FUN-B10056
                  LET g_qryparam.default1 = g_sna[l_ac].sna012a
                  LET g_qryparam.default2 = g_sna[l_ac].sna013a
                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna012a,
                                                 g_sna[l_ac].sna013a
                  DISPLAY BY NAME g_sna[l_ac].sna012a,g_sna[l_ac].sna013a
                  NEXT FIELD sna012a
#FUN-A60070 --end--
             #FUN-B20056 --START--
             WHEN INFIELD(sna29a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ima"
                  LET g_qryparam.default1 = g_sna[l_ac].sna29a
                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna29a
             #FUN-B20056 --END--
             OTHERWISE EXIT CASE
           END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about         #FUN-6B0048
          CALL cl_about()      #FUN-6B0048

       ON ACTION help          #FUN-6B0048
          CALL cl_show_help()  #FUN-6B0048

       ON ACTION controlg      #FUN-6B0048
          CALL cl_cmdask()     #FUN-6B0048

       ON ACTION CONTROLS
          CALL cl_set_head_visible("","AUTO")

       #FUN-D60056 ---------Begin---------
       AFTER INPUT
          LET l_sql = "SELECT sna02,sna04,sna03a,sna05a,sna065a,sna161a,sna26a,sna12a,sna13a,sna11a,sna08a,sna012a,sna013a,sna50 ",
                      "  FROM sna_file",
                      " WHERE sna01 = '",g_snb.snb01,"'"
          CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
          PREPARE sel_sna_pre01 FROM l_sql
          DECLARE sel_sna_del CURSOR FOR sel_sna_pre01
          FOREACH sel_sna_del INTO
                  m_sna02,m_sna04,m_sna03a,m_sna05a,m_sna065a,m_sna161a,m_sna26a,m_sna12a,
                  m_sna13a,m_sna11a,m_sna08a,m_sna012a,m_sna013a,m_sna50
             IF cl_null(m_sna03a) AND
                cl_null(m_sna05a) AND
                cl_null(m_sna065a) AND
                cl_null(m_sna161a) AND
                cl_null(m_sna26a) AND
                cl_null(m_sna12a) AND
                cl_null(m_sna13a) AND
                cl_null(m_sna11a) AND
                m_sna08a IS NULL AND
                cl_null(m_sna012a) AND
                cl_null(m_sna50) THEN
                DELETE FROM sna_file WHERE sna01 = g_snb.snb01
                                       AND sna02 = m_sna02
                                       AND sna04 = m_sna04
            END IF
         END FOREACH
       #FUN-D60056 ---------End-----------

    END INPUT
    UPDATE snb_file SET snbmodu=g_user,snbdate=g_today,
                        snb99 = l_snb99     #FUN-920208 add
     WHERE snb01=g_snb.snb01
       AND snb02=g_snb.snb02   #FUN-920208 漏掉版本條件會影響全部版本的資料
    LET g_snb.snb99 = l_snb99  #FUN-920208 add
    DISPLAY BY NAME g_snb.snb99,g_snb.snbmodu,g_snb.snbdate  #FUN-920208 add
    CLOSE t803_bcl
    COMMIT WORK

    CALL t803_delall()

    CALL t803_b_fill(' 1=1')
    CALL t803_show()     #FUN-920208 add
END FUNCTION

FUNCTION t803_delall() 			# 未輸入單身資料, 是否取消單頭資料
   DEFINE l_cnt    LIKE type_file.num5  #FUN-870092 add

    IF cl_null(g_snb.snb08a) AND cl_null(g_snb.snb13a) AND cl_null(g_snb.snb15a) AND      #MOD-B70082 add
       cl_null(g_snb.snb82a) AND cl_null(g_snb.snb14a) AND cl_null(g_snb.snb16a) THEN     #MOD-B70082 add
       SELECT COUNT(*) INTO g_cnt FROM sna_file
           WHERE sna01 = g_snb.snb01
             AND sna02 = g_snb.snb02
       IF g_sma.sma901 = 'Y' THEN #有串APS
           SELECT COUNT(*) INTO l_cnt
             FROM vlk_file
            WHERE vlk01 = g_snb.snb01  #工單編號
              AND vlk02 = g_snb.snb02  #變更序號
              AND vlk04 = g_sma.sma917 #資源型態
       ELSE
           LET l_cnt = 0
       END IF
       IF g_cnt = 0 AND l_cnt = 0 THEN #FUN-870092 mod
          IF cl_confirm('asf-059') THEN
             DELETE FROM snb_file WHERE snb01 = g_snb.snb01 AND snb02 = g_snb.snb02
             DELETE FROM sna_file WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
             DELETE FROM snc_file WHERE snc01 = g_snb.snb01 AND snc02 = g_snb.snb02
             CLEAR FORM
             INITIALIZE g_snb.* TO NULL  #TQC-B40099
             DISPLAY BY NAME g_snb.*     #TQC-B40099
             DISPLAY ' ' TO sfb02_d      #TQC-B40099
             CALL g_sna.clear()
             CALL g_sna.clear()
             CALL g_sfa29.clear()
          END IF
       END IF
    END IF    #MOD-B70082 add
END FUNCTION

#FUN-A60070 --begin--
FUNCTION t803_sna012a()
DEFINE l_ecu10     LIKE ecu_file.ecu10
DEFINE l_ecuacti   LIKE ecu_file.ecuacti
DEFINE l_flag      LIKE type_file.num5    #TQC-AC0374 add
DEFINE l_sfb05     LIKE sfb_file.sfb05    #TQC-AC0374 add
     LET g_errno = ' '                    #MOD-B30442
#FUN-B10056 ----------mod start------------
# CALL s_schdat_sel_ima571(g_snb.snb01) RETURNING l_flag,l_sfb05   #TQC-AC0374 add
#
##TQC-AC0374-------begin-------
## SELECT ecu10,ecuacti INTO l_ecu10,l_ecuacti FROM ecu_file
##  WHERE ecu01 = g_sfb05
##    AND ecu02 = g_sfb06
##    AND ecu012= g_sna[l_ac].sna012a
#
#  SELECT ecu10,ecuacti INTO l_ecu10,l_ecuacti FROM ecu_file
#   WHERE ecu01 = l_sfb05
#     AND ecu02 = g_sfb06
#     AND ecu012= g_sna[l_ac].sna012a
##TQC-AC0374--------end---------
#
# CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
#                                LET l_ecu10 = NULL
#                                LET l_ecuacti = NULL
#      WHEN l_ecuacti='N'        LET g_errno = '9028'
#                                LET l_ecu10 = NULL
#                                LET l_ecuacti = NULL
#      WHEN l_ecu10  = 'N'       LET g_errno = 'aap-717'
#                                LET l_ecu10 = NULL
#                                LET l_ecuacti = NULL
#      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
# END CASE

  IF NOT s_schdat_ecm012(g_snb.snb01,g_sna[l_ac].sna012a) THEN
     LET g_errno = 'abm-214'
  END IF
#FUN-B10056 --------------mod end-----------------
END FUNCTION
#FUN-A60070 --end--

FUNCTION t803_sna05a()
   DEFINE l_ima64       LIKE ima_file.ima64,
          l_ima641      LIKE ima_file.ima641,
          l_num_y       LIKE sfa_file.sfa05,     #MOD-890125
          l_num_z       LIKE type_file.num20,    #MOD-890125
          l_gfe03       LIKE gfe_file.gfe03

   LET g_errno = ' '
   IF cl_null(g_sna[l_ac].sna03b) THEN
     SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
      WHERE ima01=g_sna[l_ac].sna03a
     SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sna[l_ac].sna12a
   ELSE
     SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
      WHERE ima01=g_sna[l_ac].sna03b
     SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sna[l_ac].sna12b
   END IF
   IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
   #check最少發料數量
   IF l_ima641 <>  0 AND g_sna[l_ac].sna05a < l_ima641 THEN
      LET g_errno = 'asf-100'
   END IF
   IF cl_null(l_ima64) THEN  LET l_ima64=0 END IF
  IF l_ima64!=0 THEN
   LET l_num_z=g_sna[l_ac].sna05a/l_ima64
   LET l_num_y=g_sna[l_ac].sna05a-l_num_z*l_ima64
  #IF l_ima64 <> 0 AND (l_num_y) > 0 THEN
   IF l_ima64 <> 0 AND (l_num_y) <> 0 THEN  #TQC-B40221 未考慮四捨五入情況
      LET g_errno = 'asf-101'
   END IF
   END IF
   IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
   CALL cl_digcut(g_sna[l_ac].sna05a,l_gfe03) RETURNING g_sna[l_ac].sna05a
END FUNCTION


FUNCTION t803_check_sna03b()

  #已扣帳發/退料單據存在
  SELECT COUNT(*) INTO g_cnt FROM sfe_file
   WHERE sfe01=g_snb.snb01
     AND sfe07=g_sna[l_ac].sna03b    #MOD-910072 add
  IF g_cnt > 0  THEN LET g_errno='asf-412' RETURN END IF

  #已開立/確認,發/退料單據存在
  SELECT COUNT(*) INTO g_cnt FROM sfs_file ,sfp_file
   WHERE sfs03=g_snb.snb01
     AND sfs01=sfp01                 #MOD-910072 modify
     AND sfs04=g_sna[l_ac].sna03b    #MOD-910072 add
     AND sfpconf <> 'X'
  IF g_cnt > 0  THEN LET g_errno='asf-069' RETURN END IF

END FUNCTION

FUNCTION t803_sna03(p_cmd,p_no)
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima39   LIKE ima_file.ima39,
           l_ima140  LIKE ima_file.ima140,
           l_imaacti LIKE ima_file.imaacti,
           p_no      LIKE ima_file.ima01,
           p_cmd     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)

  LET g_errno = ''

  IF cl_null(p_no) THEN RETURN NULL END IF   #MOD-C10067 add

  SELECT * INTO g_ima.* FROM ima_file
         WHERE ima01 = p_no

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno     = 'mfg0002'
                                 LET g_ima.ima02 = NULL
                                 LET g_ima.imaacti=NULL
       WHEN g_ima.imaacti = 'N'  LET g_errno = '9028'
       #WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #NO.FUN-690022 add #CHI-C20053
       WHEN g_ima.imaacti MATCHES '[PH]'  LET g_errno = '9038'  #CHI-C20053
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  RETURN g_ima.ima02
END FUNCTION

#CHI-C20053---begin
FUNCTION t803_sna03_1(p_cmd,p_no)
    DEFINE p_no      LIKE ima_file.ima01,
           p_cmd     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)

  LET g_errno = ''

  IF cl_null(p_no) THEN RETURN NULL END IF   #MOD-C10067 add

  SELECT * INTO g_ima.* FROM ima_file
         WHERE ima01 = p_no

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno     = 'mfg0002'
                                 LET g_ima.ima02 = NULL
                                 LET g_ima.ima021 = NULL
                                 LET g_ima.imaacti=NULL
       WHEN g_ima.imaacti = 'N'  LET g_errno = '9028'
       WHEN g_ima.imaacti MATCHES '[PH]'  LET g_errno = '9038'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  RETURN g_ima.ima021
END FUNCTION
#CHI-C20053---end

#FUNCTION t803_sna27(p_sfa03,p_sfa08,p_sfa12,p_sfa27,p_sfa012,p_sfa013) #No.FUN-870051 add p_sfa27  #FUN-A60070 add sfa012,sfa013
FUNCTION t803_sna27(p_sna) #FUN-D60056
  DEFINE l_sfa     RECORD LIKE sfa_file.*
#FUN-D60056 -------Begin---------
 #       p_sfa03   LIKE sfa_file.sfa03,
 #       p_sfa08   LIKE sfa_file.sfa08,
 #       p_sfa12   LIKE sfa_file.sfa12,
 #       p_sfa27   LIKE sfa_file.sfa27  #No.FUN-870051
 #DEFINE p_sfa012  LIKE sfa_file.sfa012  #FUN-A60070
 #DEFINE p_sfa013  LIKE sfa_file.sfa013  #FUN-A60070

# IF cl_null(p_sfa03) THEN RETURN END IF
  DEFINE p_sna     RECORD LIKE sna_file.*
  IF cl_null(p_sna.sna03b) THEN RETURN END IF
#FUN-D60056 -------End-----------
  LET g_errno = ''
  SELECT * INTO l_sfa.* FROM sfa_file
   WHERE sfa01 = g_snb.snb01
 #FUN-D60056 -------Begin-------
    #AND sfa03 = p_sfa03
    #AND sfa08 = p_sfa08
    #AND sfa12 = p_sfa12
    #AND sfa27 = p_sfa27  #No.FUN-870051
    #AND sfa012= p_sfa012   #FUN-A60070
    #AND sfa013= p_sfa013   #FUN-A60070
     AND sfa03 = p_sna.sna03b
     AND sfa08 = p_sna.sna08b
     AND sfa12 = p_sna.sna12b
     AND sfa27 = p_sna.sna27b
     AND sfa012 = p_sna.sna012b
     AND sfa013 = p_sna.sna013b
 #FUN-D60056 -------End---------
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 INITIALIZE l_sfa.* TO NULL
       WHEN l_sfa.sfaacti='N'    LET g_errno = '9028'
       WHEN l_sfa.sfaacti='X'    LET g_errno = '9024'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE

  IF cl_null(g_errno) THEN
#FUN-D60056 ----------Begin----------
      # LET g_sfa29[l_ac]      = l_sfa.sfa29
      # LET g_sna[l_ac].sna03b = l_sfa.sfa03
      # LET g_sna[l_ac].ima02b = t803_sna03('',g_sna[l_ac].sna03b)
      # LET g_sna[l_ac].ima021b = t803_sna03_1('',g_sna[l_ac].sna03b)  #CHI-C20053
      # LET g_sna[l_ac].sna08b = l_sfa.sfa08
      # LET g_sna[l_ac].sna11b = l_sfa.sfa11
      # LET g_sna[l_ac].sna12b = l_sfa.sfa12
      # LET g_sna[l_ac].sna13b = l_sfa.sfa13
      # LET g_sna[l_ac].sna28b = l_sfa.sfa28
      # LET g_sna[l_ac].sna161b= l_sfa.sfa161
      # LET g_sna[l_ac].sna26b=  l_sfa.sfa26  #FUN-990059
      # LET g_sna[l_ac].sna05b = l_sfa.sfa05
      # LET g_sna[l_ac].sna065b = l_sfa.sfa065 #FUN-C10045
      # LET g_sna[l_ac].sna012b= l_sfa.sfa012  #FUN-A60070
      # LET g_sna[l_ac].sna013b= l_sfa.sfa013  #FUN-A60070
        LET g_sfa29[l_ac]      = l_sfa.sfa29
        LET p_sna.sna03b = l_sfa.sfa03
        LET p_sna.sna08b = l_sfa.sfa08
        LET p_sna.sna11b = l_sfa.sfa11
        LET p_sna.sna12b = l_sfa.sfa12
        LET p_sna.sna13b = l_sfa.sfa13
        LET p_sna.sna28b = l_sfa.sfa28
        LET p_sna.sna161b= l_sfa.sfa161
        LET p_sna.sna26b=  l_sfa.sfa26
        LET p_sna.sna05b = l_sfa.sfa05
        LET p_sna.sna065b = l_sfa.sfa065
        LET p_sna.sna012b= l_sfa.sfa012
        LET p_sna.sna013b= l_sfa.sfa013
#FUN-D60056 ----------End-------------
  END IF
  RETURN p_sna.*   #FUN-D60056
END FUNCTION

#--->單位檔
FUNCTION t803_unit(p_key)
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


FUNCTION t803_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)

    LET g_sql =
        "SELECT sna04,0,sna012b,sna013b,sna03b,'','',sna05b,sna065b,sna161b,sna26b,sna28b,sna12b,sna13b,sna11b,sna08b,sna29b,", #FUN-990059  #CHI-C20053 add ''  #FUN-C10045 sna065b
                                   #FUN-A60070 add sna012b,sna013b #FUN-B20056 add sna29b
        "  1,sna012a,sna013a,sna03a,'','',sna05a,sna065a,sna161a,sna26a,sna28a,sna12a,sna13a,sna11a,sna08a,sna29a,sna50 ",      #FUN-990059  #CHI-C20053 add ''  #FUN-C10045 sna065a
                                   #FUN-A60070 add sna012a,sna013a #FUN-B20056 add sna29a
        "  FROM sna_file ",
        " WHERE sna01 = '",g_snb.snb01, "'",
        "   AND sna02 = ",g_snb.snb02," AND ",p_wc CLIPPED
    PREPARE t803_prepare2 FROM g_sql    #預備一下
    DECLARE t803_sna_cs CURSOR FOR t803_prepare2

    CALL g_sna.clear()

    LET g_rec_b = 0
    LET g_cnt = 1

    FOREACH t803_sna_cs INTO g_sna[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_sna[g_cnt].ima02b = t803_sna03('d',g_sna[g_cnt].sna03b)
      LET g_sna[g_cnt].ima02a = t803_sna03('d',g_sna[g_cnt].sna03a)
      LET g_sna[g_cnt].ima021b = t803_sna03_1('d',g_sna[g_cnt].sna03b)   #CHI-C20053
      LET g_sna[g_cnt].ima021a = t803_sna03_1('d',g_sna[g_cnt].sna03a)   #CHI-C20053
      IF  cl_null(g_sna[g_cnt].sna03b) THEN
          LET g_sna[g_cnt].safter=2
      END IF
#TQC-A60120 --begin--
      IF g_sna[g_cnt].sna013a = 0 THEN
         LET g_sna[g_cnt].sna013a = NULL
      END IF
#TQC-A60120 --end--
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF

    END FOREACH
    CALL g_sna.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION t803_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sna TO s_sna.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         IF NOT cl_null(g_argv1) THEN
           #CALL cl_set_act_visible("insert,modify,change_release,delete,detail,rep_sub",FALSE)   #MOD-BB0176 mark
           #CALL cl_set_act_visible("insert,modify,delete,detail,rep_sub",FALSE)                  #MOD-BB0176              #MOD-C10093
#TQC-C10106 --begin--
            IF cl_null(g_row_count) OR g_row_count = 0 THEN
              CALL cl_set_act_visible("delete,rep_sub",FALSE)
            ELSE
#TQC-C10106 --end--
              CALL cl_set_act_visible("insert,delete,rep_sub",FALSE)                                #MOD-C10093
            END IF                #TQC-C10106
         END IF
         IF g_sma.sma901 != 'Y' THEN
            #CALL cl_set_act_visible("change_aps_processing",FALSE) #FUN-960104 mark
             CALL cl_set_act_visible("aps_ch_locked_machine",FALSE) #FUN-960104 mod
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL t803_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF

      ON ACTION previous
         CALL t803_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF

      ON ACTION jump
         CALL t803_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF


      ON ACTION next
         CALL t803_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF


      ON ACTION last
         CALL t803_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      ON ACTION modify
          LET g_action_choice="modify"
          EXIT DISPLAY

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
         CALL t803_aps_ui_default() #FUN-A10134 add

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 變更發出

     #FUN-960104 MARK --STR-------------------------
     ##平行加工變更
     #ON ACTION change_aps_processing
     #   LET g_action_choice="change_aps_processing"
     #   EXIT DISPLAY
     #FUN-960104 MARK --END-------------------------

     #FUN-960104 ADD --STR--------------------------
      #APS鎖定設備變更
      ON ACTION aps_ch_locked_machine
         LET g_action_choice="aps_ch_locked_machine"
         EXIT DISPLAY
     #FUN-960104 ADD --END--------------------------

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY

      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end

      ON ACTION change_release
         LET g_action_choice="change_release"
         EXIT DISPLAY
#@    ON ACTION 備注
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

    #@ON "EF送簽"
      ON ACTION easyflow_approval
         LET g_action_choice = 'easyflow_approval'
         EXIT DISPLAY

    #@ON "簽核狀況"
      ON ACTION approval_status
         LET g_action_choice = 'approval_status'
         EXIT DISPLAY

    #@ON "准"
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

    #@ON "不准"
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

    #@ON "加簽"
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

    #@ON "抽單"
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

    #@ON "撤簽"
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

    #@ON "簽核意見"
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t803_bp_refresh()
   DISPLAY ARRAY g_sna TO s_sna.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

   END DISPLAY
END FUNCTION

#FUN-A10013 add str ---
#將原確認段t803_confirm()拆解為check段和update段
#check段
FUNCTION t803_y_chk()
DEFINE l_sna   RECORD LIKE sna_file.*  #Add No.FUN-AB0054
DEFINE l_flag       LIKE type_file.num5   #TQC-AB0379
DEFINE l_cnt        LIKE type_file.num5   #MOD-B40140 add
DEFINE l_sna03a     LIKE sna_file.sna03a  #MOD-B40140 add
DEFINE l_sna08a     LIKE sna_file.sna08a  #MOD-B40140 add
DEFINE l_sna12a     LIKE sna_file.sna12a  #MOD-B40140 add
DEFINE l_sfu02      LIKE sfu_file.sfu02   #MOD-C20061 add
DEFINE l_sfs05      LIKE sfs_file.sfs05   #FUN-C10045
DEFINE l_sfe16      LIKE sfe_file.sfe16   #FUN-C10045
DEFINE l_rvb07      LIKE rvb_file.rvb07   #FUN-C10045
DEFINE l_sfe16a     LIKE sfe_file.sfe16   #MOD-C90171 add
DEFINE l_sfa06      LIKE sfa_file.sfa06   #MOD-CC0043 add

  LET g_success = 'Y'

  IF s_shut(0) THEN
     LET g_success = 'N'
     RETURN
  END IF
#CHI-C30107 --------- add --------- begin
  IF g_action_choice CLIPPED = "confirm" OR          #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN RETURN END IF
  END IF
  SELECT * INTO g_snb.* FROM snb_file WHERE snb01 = g_snb.snb01
                                        AND snb02 = g_snb.snb02
  CALL t803_show()
#CHI-C30107 --------- add --------- end
  IF g_snb.snb02 IS NULL THEN
     CALL cl_err('',-400,0)
     LET g_success = 'N'
     RETURN
  END IF

  IF g_snb.snbconf = 'Y' THEN           #當確認碼為'Y'時,RETURN
     CALL cl_err('','9023',0)
     LET g_success = 'N'          #MOD-AB0099 add
     RETURN
  END IF

  IF g_snb.snbconf = 'X' THEN           #當確認碼為'X'作廢時,RETURN
     CALL cl_err('','9024',0)
     LET g_success = 'N'
     RETURN
  END IF

 #MOD-AB0099---add---start---
  IF g_snb.snb99 = '2' THEN           #當簽核狀況為'2'發出時,RETURN
     CALL cl_err('','asf-061',0)
     LET g_success = 'N'
     RETURN
  END IF
 #MOD-AB0099---add---end---

  #Add No.FUN-AB0054 单身检查
  DECLARE t803_y_chk_c CURSOR FOR SELECT * FROM sna_file
                               WHERE sna01=g_snb.snb01
                                 AND sna02=g_snb.snb02
  FOREACH t803_y_chk_c INTO l_sna.*
     #FUN-C10045---begin
     IF NOT cl_null(l_sna.sna065a) THEN

       SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file,sfp_file
        WHERE sfs01 = sfp01
          AND sfs03 = g_snb.snb01
          AND sfs04 = l_sna.sna03b
          AND sfpconf <> 'X'
          AND sfp15 <> '9'
          AND sfp04 <> 'Y'
          AND sfp06 IN ('1','3')  #MOD-C90171 add

       SELECT SUM(sfe16) INTO l_sfe16 FROM sfe_file,sfp_file
        WHERE sfe02 = sfp01
          AND sfe01 = g_snb.snb01
          AND sfe07 = l_sna.sna03b
          AND sfpconf <> 'X'
          AND sfp15 = '1'
          AND sfp04 = 'Y'
          AND sfp06 IN ('1','3')  #MOD-C90171 add

       #MOD-C90171 add---S---
        LET l_sfe16a = 0
        SELECT SUM(sfe16) INTO l_sfe16a FROM sfe_file,sfp_file
         WHERE sfe02 = sfp01
           AND sfe01 = g_snb.snb01
           AND sfe07 = l_sna.sna03b
           AND sfpconf <> 'X'
           AND sfp15 = '1'
           AND sfp04 = 'Y'
           AND sfp06 IN ('6','8')

        IF cl_null(l_sfe16a) THEN
           LET l_sfe16a = 0
        END IF
       #MOD-C90171 add---E---

        IF cl_null(l_sfs05) THEN
           LET l_sfs05 = 0
        END IF
        IF cl_null(l_sfe16) THEN
           LET l_sfe16 = 0
        END IF
       #LET l_sfs05 = l_sfs05 + l_sfe16              #MOD-C90171 mark
        LET l_sfs05 = l_sfs05 + l_sfe16 - l_sfe16a   #MOD-C90171

       #IF l_sna.sna065a > l_sna.sna05b - l_sfs05 THEN                                      #CHI-C90030 mark
        IF (l_sna.sna065a > l_sna.sna05b - l_sfs05  AND cl_null(l_sna.sna05b)) OR           #CHI-C90030 add
           (l_sna.sna065a > l_sna.sna05a - l_sfs05  AND NOT cl_null(l_sna.sna05b)) THEN     #CHI-C90030 add
           CALL cl_err('','asf1027',1) #變更後數量不可大於 應發量 - 發料單已發量
           LET g_success = 'N'
        END IF
        SELECT SUM(rvb07) INTO l_rvb07 FROM sfb_file,rva_file,rvb_file
         WHERE sfb01 = g_snb.snb01
           AND sfb39 = '1'
           AND sfbacti = 'Y'
           AND ( sfb02 = '7' OR sfb02 = '8' )
           AND rvb34 = sfb01
           AND rvb01 = rva01
           AND rvaconf <> 'X'
           AND rvb05 = l_sna.sna03b
        IF l_sna.sna065a < l_rvb07 THEN
           CALL cl_err('','asf1028',1) #變更後數量不可小於 已收貨數量
           LET g_success = 'N'
        END IF
     END IF
     #FUN-C10045---end
     #Add No.No.FUN-AB0054
     IF NOT s_chk_ware(l_sna.sna30a) THEN  #检查仓库是否属于当前门店
        LET g_success='N'
        EXIT FOREACH
     END IF

    #MOD-CC0043---add---S
    #發料後再進行作業變號前應先做退料，使其發料量為0才可以變更
     LET l_sfa06=0
     SELECT SUM(sfa06) INTO l_sfa06 FROM sfa_file
      WHERE sfa01 = g_snb.snb01
        AND sfa03 = l_sna.sna03b
     IF l_sfa06 > 0 AND NOT cl_null(l_sna.sna08a) THEN
        CALL cl_err(g_snb.snb01,'asf1036',0)
        LET g_success='N'
     END IF
    #MOD-CC0043---add---E
    #darcy:2022/09/27 s---
    if l_sna.sna28a = 0 then
      call cl_err(g_snb.snb01,'aps-100',0)
      let g_success = 'N'
    end if
    #darcy:2022/09/27 e---
  END FOREACH
  IF g_success = 'N' THEN RETURN END IF
  #End Add No.FUN-AB0054

  #TQC-AB0379 ----------add start--------
  LET l_flag = '0'
  DECLARE t803_chk_sna05a CURSOR FOR
     SELECT * FROM sna_file WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
  FOREACH t803_chk_sna05a INTO l_sna.*
    #CALL t803_check_sna05a(l_sna.sna05a,l_sna.sna01,l_sna.sna03b,l_sna.sna08b,l_sna.sna12b,l_sna.sna012b,l_sna.sna013b)              #CHI-BA0015 mark
     CALL t803_check_sna05a(l_sna.sna05a,l_sna.sna01,l_sna.sna03b,l_sna.sna08b,l_sna.sna12b,l_sna.sna012b,l_sna.sna013b,l_sna.sna11a) #CHI-BA0015 add
          RETURNING l_flag
     IF l_flag = '1' THEN
        EXIT FOREACH
     END IF
  END FOREACH
  IF l_flag = '1' THEN
     IF l_sna.sna11a = 'S' THEN      #CHI-BA0015 add
       CALL cl_err('','asf-555',0)   #CHI-BA0015 add
     ELSE                            #CHI-BA0015 add
       CALL cl_err('','asf-552',0)
     END IF                          #CHI-BA0015 add
     LET g_success = 'N'
     RETURN
  END IF
  #TQC-AB0379 --------add end-------------
  #MOD-B40140---add---start---
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM sna_file
   WHERE sna01 = g_snb.snb01
     AND sna02 = g_snb.snb02      #MOD-B50059 add
     AND sna03b IS NULL
  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
  IF l_cnt  > 0 THEN
    DECLARE t803_chk_sfa CURSOR FOR
    SELECT sna03a,sna08a,sna12a FROM sna_file
     WHERE sna01=g_snb.snb01 AND sna03b IS NULL
           AND sna02 = g_snb.snb02               #MOD-BB0311 add
    FOREACH t803_chk_sfa INTO l_sna03a,l_sna08a,l_sna12a
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM sfa_file
       WHERE sfa01=g_snb.snb01 AND sfa03=l_sna03a
         AND sfa08=l_sna08a AND sfa12=l_sna12a
         AND sfa27=l_sna03a
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         CALL cl_err(l_sna03a,'asf-272',1)
         LET g_success = 'N'
         RETURN
      END IF
    END FOREACH
  END IF
  #MOD-B40140---add---end---

  #MOD-C20061 srt add ----
  #若有工單的最早入庫日小于當前系統的關帳日期則不允許確認
  SELECT MIN(sfu02) INTO l_sfu02 FROM sfv_file,sfu_file
        WHERE sfv11 = g_snb.snb01
          AND sfv01 = sfu01
IF g_user<>'tiptop' AND  g_user<>'20233'  THEN   #171208

  IF l_sfu02<=g_sma.sma53 THEN
     CALL cl_err('','asf-882',0)
     LET g_success = 'N'
     RETURN
  END IF
END IF
  #MOD-C20061 end add ----

END FUNCTION

#update段 -- #FUN-A10013
FUNCTION t803_y_upd()

  LET g_success = 'Y'

  IF g_action_choice CLIPPED = "confirm" OR          #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
    IF g_snb.snbmksg='Y' THEN                        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
       IF g_snb.snb99 != '1' THEN
          CALL cl_err('','aws-078',1)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能 #CHI-C30107 mark
  END IF

  BEGIN WORK

  OPEN t803_cl USING g_snb.snb01,g_snb.snb02
  IF STATUS THEN
     CALL cl_err("OPEN t803_cl:", STATUS, 1)
     CLOSE t803_cl
     ROLLBACK WORK
     LET g_success = 'N'
     RETURN
  END IF

  FETCH t803_cl INTO g_snb.*                        # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t803_cl
      ROLLBACK WORK
      LET g_success = 'N'
      RETURN
  END IF

  UPDATE snb_file SET snbconf = 'Y',snb99 = '1'     #更新單頭確認碼、狀況馬
   WHERE snb01 = g_snb.snb01
     AND snb02 = g_snb.snb02
  IF SQLCA.SQLERRD[3] = 0 THEN
     LET g_success = 'N'
     CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
  END IF

  IF g_success = 'Y' THEN
      IF g_snb.snbmksg = 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
          WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET g_snb.snbconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
          WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET g_snb.snbconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
        END CASE
      END IF

      IF g_success = 'Y' THEN
        LET g_snb.snbconf = 'Y'
        LET g_snb.snb99 = '1'
        DISPLAY BY NAME g_snb.snbconf,g_snb.snb99
        COMMIT WORK
      ELSE

      END IF
  ELSE
     LET g_snb.snbconf = 'N'
     LET g_success = 'N'
     ROLLBACK WORK
  END IF

  IF g_snb.snbconf='X' THEN
     LET g_chr='Y'
  ELSE
     LET g_chr='N'
  END IF

  IF g_snb.snb99  ='1' OR g_snb.snb99  ='3' THEN
    LET g_chr2='Y'
  ELSE
    LET g_chr2='N'
  END IF

  CALL cl_set_field_pic(g_snb.snbconf,g_chr2,"","",g_chr,"")

  CLOSE t803_cl
END FUNCTION
#FUN-A10013 add end ---


#FUN-A10013 mark str -----
#FUNCTION t803_confirm()
#  IF s_shut(0) THEN RETURN END IF
#  IF g_snb.snb02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#  IF g_snb.snbconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
#  IF g_snb.snbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
#  IF g_snb.snbmksg = 'Y' THEN
#     IF g_snb.snb99 != '1' THEN
#        CALL cl_err('','aws-078',1)
#        RETURN
#     END IF
#  END IF
#  IF NOT cl_confirm('aap-222') THEN RETURN END IF
#  LET g_success = 'Y'
#  BEGIN WORK
#  OPEN t803_cl USING g_snb.snb01,g_snb.snb02
#  IF STATUS THEN
#     CALL cl_err("OPEN t803_cl:", STATUS, 1)
#     CLOSE t803_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#  FETCH t803_cl INTO g_snb.*            # 鎖住將被更改或取消的資料
#  IF SQLCA.sqlcode THEN
#      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
#      CLOSE t803_cl
#      ROLLBACK WORK
#      RETURN
#  END IF
#  UPDATE snb_file SET snbconf = 'Y'
#   WHERE snb01 = g_snb.snb01
#     AND snb02 = g_snb.snb02
#  IF SQLCA.SQLERRD[3] = 0 THEN
#     LET g_success = 'N'
#     CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
#  ELSE
#     IF g_snb.snbmksg = 'N' THEN
#        UPDATE snb_file SET snb99 = '1'
#         WHERE snb01 = g_snb.snb01
#           AND snb02 = g_snb.snb02
#        IF SQLCA.SQLERRD[3] = 0 THEN
#           LET g_success = 'N'
#           CALL cl_err('(asft803:ckp#1.1)','mfg9328',1)
#        ELSE
#           LET g_snb.snb99 = '1'
#        END IF
#     END IF
#  END IF
#  IF g_success = 'Y' THEN
#      IF g_snb.snbmksg = 'Y' THEN #簽核模式
#      CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
#          WHEN 0  #呼叫 EasyFlow 簽核失敗
#               LET g_snb.snbconf="N"
#               LET g_success = "N"
#               ROLLBACK WORK
#               RETURN
#          WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
#               LET g_snb.snbconf="N"
#               ROLLBACK WORK
#               RETURN
#      END CASE
#      END IF
#      LET g_snb.snbconf = 'Y'
#      DISPLAY BY NAME g_snb.snbconf,g_snb.snb99
#      COMMIT WORK
#  ELSE
#     ROLLBACK WORK
#  END IF
#  IF g_snb.snbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#  IF g_snb.snb99  ='1' OR
#     g_snb.snb99  ='3' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#  CALL cl_set_field_pic(g_snb.snbconf,g_chr2,"","",g_chr,"")
#  CLOSE t803_cl
#END FUNCTION
#FUN-A10013 mark end -----

FUNCTION t803_unconfirm()
  DEFINE l_snb99  LIKE snb_file.snb99      #FUN-A10013 add

   IF s_shut(0) THEN RETURN END IF
   IF g_snb.snb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_snb.snb99 = 'S' THEN
      CALL cl_err(g_snb.snb99,'apm-030',1)
      RETURN
   END IF
   IF g_snb.snbconf MATCHES '[XN]' THEN RETURN END IF
   IF g_snb.snb99='2' THEN
      CALL cl_err(g_snb.snb01,'axm-015',0)
      RETURN
   END IF
#  IF NOT cl_confirm('axm-109') THEN RETURN END IF     #MOD-B50239 mark

   LET l_snb99 = g_snb.snb99                #FUN-A10013 add
   LET g_success = 'Y'

   BEGIN WORK

   OPEN t803_cl USING g_snb.snb01,g_snb.snb02
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t803_cl INTO g_snb.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
   END IF

   #MOD-B50239 --- modify --- start ---
   IF NOT cl_confirm('axm-109') THEN
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
   END IF
   #MOD-B50239 --- modify --   end  ---

   UPDATE snb_file SET snbconf = 'N'
                      ,snb99 = '0'                   #更新狀況碼為:開立 #FUN-A10013 add
    WHERE snb01 = g_snb.snb01
      AND snb02 = g_snb.snb02
   IF SQLCA.SQLERRD[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
  #FUN-A10013 mark str ------
  #ELSE
  #   IF g_snb.snbmksg = 'N' THEN
  #      UPDATE snb_file SET snb99 = '0'
  #       WHERE snb01 = g_snb.snb01
  #         AND snb02 = g_snb.snb02
  #      IF SQLCA.SQLERRD[3] = 0 THEN
  #         LET g_success = 'N'
  #         CALL cl_err('(asft803:ckp#1.1)','mfg9328',1)
  #      ELSE
  #         LET g_snb.snb99 = '0'
  #      END IF
  #   END IF
  #FUN-A10013 mark end -----
   END IF

   IF g_success = 'Y' THEN
      LET g_snb.snbconf = 'N'
      LET g_snb.snb99 = '0'                      #FUN-A10013 add
      DISPLAY BY NAME g_snb.snbconf,g_snb.snb99
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   IF g_snb.snbconf='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF

   IF g_snb.snb99  ='1' OR g_snb.snb99  ='3' THEN
      LET g_chr2='Y'
   ELSE
      LET g_chr2='N'
   END IF

   CALL cl_set_field_pic(g_snb.snbconf,g_chr2,"","",g_chr,"")
END FUNCTION

#FUNCTION t803_x()  #CHI-D20010
FUNCTION t803_x(p_type) #CHI-D20010
DEFINE l_chr   LIKE type_file.chr1
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010

  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0) RETURN END IF
  IF g_snb.snb99 = '2' THEN
     CALL cl_err('','axm-015',0)
     RETURN
  END IF
  IF g_snb.snb99 matches '[Ss1]' THEN
     CALL cl_err("","mfg3557",0)
     RETURN
  END IF
  IF g_snb.snbconf = 'Y' THEN
     CALL cl_err('',9023,0)
     RETURN
  END IF
  IF g_snb.snbconf = 'X' THEN
       LET g_cnt = 0
       SELECT count(*) INTO g_cnt FROM snb_file
        WHERE snb01 = g_snb.snb01
          AND snbconf IN ('N','n')
       IF g_cnt > 0 THEN
           CALL cl_err('','asf-593',1)
           RETURN
       END IF
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_snb.snbconf ='X' THEN RETURN END IF
   ELSE
      IF g_snb.snbconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK

   OPEN t803_cl USING g_snb.snb01,g_snb.snb02
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t803_cl INTO g_snb.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
   END IF

   IF g_snb.snbconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010

  #IF cl_void(0,0,g_snb.snbconf)   THEN   #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN          #CHI-D20010
      LET l_chr = g_snb.snbconf
     #IF g_snb.snbconf = 'N' THEN   #CHI-D20010
      IF p_type = 1 THEN            #CHI-D20010
         LET g_snb.snbconf = 'X'
      ELSE
         LET g_snb.snbconf = 'N'
      END IF
      LET g_snb.snbmodu = g_user
      LET g_snb.snbdate = g_today
      UPDATE snb_file SET snbconf = g_snb.snbconf,
                          snbmodu = g_user,
                          snbdate = g_today
       WHERE snb01 = g_snb.snb01
         AND snb02 = g_snb.snb02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_snb.snbconf,SQLCA.sqlcode,0)
         LET g_snb.snbconf = l_chr
         ROLLBACK WORK
      END IF
      DISPLAY BY NAME g_snb.snbconf,g_snb.snbmodu,g_snb.snbdate
   END IF
   CLOSE t803_cl
   COMMIT WORK
   IF g_snb.snbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_snb.snb99  ='1' OR
      g_snb.snb99  ='3' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_snb.snbconf,g_chr2,"","",g_chr,"")
END FUNCTION

FUNCTION t803_g()
DEFINE l_cnt     LIKE type_file.num5        #No.FUN-870092 add
DEFINE
   l_sfb04         LIKE sfb_file.sfb04,     #FUN-8B0095
   i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   l_msg      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
   l_msg_1    STRING,                       #FUN-970114
   l_sfa06    LIKE sfa_file.sfa06,
   l_sfa065   LIKE sfa_file.sfa065,         #No.MOD-920180 add
   l_sna      RECORD LIKE sna_file.*,       #No.MOD-920180 add
   l_flag     LIKE type_file.num5,          #No.MOD-920180 add
   l_sna10    LIKE sna_file.sna10,
   l_sfa      RECORD LIKE sfa_file.*
DEFINE l_sfa03  LIKE sfa_file.sfa03         #CHI-950047
DEFINE l_sfa26  LIKE sfa_file.sfa26         #CHI-950047
DEFINE l_sfa27  LIKE sfa_file.sfa27         #CHI-950047
DEFINE l_n      LIKE type_file.num5         #CHI-950047
DEFINE l_sql    STRING                      #CHI-950047
DEFINE l_sfs05  LIKE sfs_file.sfs05         #FUN-C10045
DEFINE l_rvb07  LIKE rvb_file.rvb07         #FUN-C10045
DEFINE l_sfe16  LIKE sfe_file.sfe16         #FUN-C10045
DEFINE l_sfe16a     LIKE sfe_file.sfe16   #MOD-C90171 add
#MOD-C90216 add---S
DEFINE l_snb  RECORD LIKE snb_file.*
DEFINE l_pmm18    LIKE pmm_file.pmm18
DEFINE l_pmn20    LIKE pmn_file.pmn20
#MOD-C90216 add---E
DEFINE l_time     LIKE snb_file.snbsendt   #TQC-D10103
#MOD-D40062 --begin--
DEFINE l_sfp    RECORD LIKE sfp_file.*
DEFINE l_sfe01         LIKE sfe_file.sfe01
DEFINE l_sfe07         LIKE sfe_file.sfe07
DEFINE l_sfe14         LIKE sfe_file.sfe14
DEFINE l_sfe012        LIKE sfe_file.sfe012
DEFINE l_sfe013        LIKE sfe_file.sfe013
DEFINE l_sfb    RECORD LIKE sfb_file.*
DEFINE l_pmn78         LIKE pmn_file.pmn78
#MOD-D40062 --end--

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0)   RETURN END IF

   BEGIN WORK
   LET g_success = 'Y'  #MOD-960267

    OPEN t803_cl USING g_snb.snb01,g_snb.snb02
    IF STATUS THEN
       CALL cl_err("OPEN t803_cl:", STATUS, 1)
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t803_cl INTO g_snb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t803_show()

   #發出否snbconf='N'，才可執行
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    IF g_snb.snbconf != 'Y'  THEN   #CHI-960054
       CALL cl_err('','aap-717',0)  #CHI-960054
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

   IF g_snb.snb99 != '1' THEN CALL cl_err('snb99 != 1','apm-299',0) RETURN END IF #CHI-960054

  # 如單據需簽核，在未核准前不可做發出動作
    IF g_snb.snbmksg = 'Y' THEN
      IF g_snb.snb99 <> '1' THEN  #已核准
        CALL cl_err('','axm-175',0)
        ROLLBACK WORK
        CLOSE t803_cl
        RETURN
      END IF
    END IF

    SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = g_snb.snb01   #FUN-8B0095
   #需檢查變更日期不可大于會計年度/期別，和小于系統關帳日期
    IF NOT cl_null(g_sma.sma53) AND g_snb.snb022 <= g_sma.sma53 THEN
     IF l_sfb04 != '2' AND l_sfb04 !='3' THEN              #FUN-8B0095
       CALL cl_err('','mfg9999',0)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
     END IF                                                #FUN-8B0095
    END IF
    CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
    IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
       CALL cl_err(g_yy,'mfg6090',0)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_snb.snb01

    IF SQLCA.sqlcode THEN
       CALL s_errmsg('sfb01',g_snb.snb01,'g_sel_sfb',SQLCA.sqlcode,1)              #NO.FUN-710026
       ROLLBACK WORK
       CLOSE t803_cl
       CALL s_showmsg()   #No.MOD-8A0099
       RETURN
    END IF
    IF g_snb.snb08a<g_sfb.sfb09 THEN  #不可小于已入庫數量
       CALL cl_err('','asf-972',1)
       ROLLBACK WORK
       CLOSE t803_cl
       CALL s_showmsg()
       RETURN
    END IF
    IF g_snb.snb08a<g_sfb.sfb081 THEN  #不可小于已發套數
       CALL cl_err('','asf-056',1)
       ROLLBACK WORK
       CLOSE t803_cl
       CALL s_showmsg()
       RETURN
    END IF
    #檢查系統關帳日前是否存在入庫
    SELECT MIN(sfu02) INTO g_sfb.sfb18 FROM sfu_file,sfv_file WHERE sfu01=sfv01 AND sfv11=g_snb.snb01  #MOD-8C0077
    IF g_sfb.sfb18<=g_sma.sma53  AND g_user<>'20233' AND g_user<>'tiptop' THEN
       CALL s_errmsg('sfv11',g_snb.snb01,g_sfb.sfb18,'asf-042',1)   #MOD-8C0077
       ROLLBACK WORK
       CLOSE t803_cl
       CALL s_showmsg()   #No.MOD-8A0099
       RETURN
    END IF
    IF g_sfb.sfb87 != 'Y' THEN
       CALL cl_err(g_sfb.sfb01,'9029',0)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF
    IF g_sfb.sfb04 = '8'  THEN
       CALL cl_err(g_sfb.sfb01,'asf-070',0)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    IF g_success = 'N' THEN
       CALL cl_err(l_msg,g_errno,1)
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    IF NOT cl_sure(15,22) THEN
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    LET g_success = 'Y'

    #1 存在未過賬的發料，退料單，不可以發出變更
    #2.變更后已發量大于應發量，要給user提示
    SELECT COUNT(*) INTO g_cnt FROM sfs_file,sfp_file
     WHERE sfs03=g_snb.snb01
       AND sfs01=sfp01
       AND sfpconf != 'X'
       AND sfp04 != 'Y'   #未過賬
    IF g_cnt > 0 THEN
       CALL s_showmsg_init()
       DECLARE t803_chk_0 CURSOR FOR
        SELECT UNIQUE sfs01 FROM sfs_file,sfp_file
        WHERE sfs03=g_snb.snb01
          AND sfs01=sfp01
          AND sfpconf != 'X'
          AND sfp04 != 'Y'
       LET l_msg = ''
       LET l_msg_1 =''
       FOREACH t803_chk_0 INTO l_msg
          LET l_msg_1=g_snb.snb01,"/",l_msg
          CALL s_errmsg('sfs03,sfs01',l_msg_1,'','asf-243',1)
       END FOREACH
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
    DECLARE t803_chk_1 CURSOR FOR
     SELECT * FROM sna_file WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
    LET l_flag = '0'
    FOREACH t803_chk_1 INTO l_sna.*
       #如果替代料(或主料)由"消耗性料件"變更為"一般料件"或由"一般料件"變更為"消耗性料件"時，
       #請檢查此工單之備料若存在其主料(或替代料) 則主料和替代料的來源特性需一致
       IF cl_null(l_sna.sna03a) THEN
          IF (l_sna.sna11b = 'N' AND l_sna.sna11a = 'E') OR
             (l_sna.sna11b = 'E' AND l_sna.sna11a = 'N') THEN
              SELECT sfa26,sfa27 INTO l_sfa26,l_sfa27 FROM sfa_file
               WHERE sfa01 = l_sna.sna01
                 AND sfa03 = l_sna.sna03b
                 AND sfa08 = l_sna.sna08b
                 AND sfa12 = l_sna.sna12b
                 AND sfa27 = l_sna.sna27b
                 AND sfa012= l_sna.sna012b    #FUN-A60070
                 AND sfa013= l_sna.sna013b    #FUN-A60070
              IF l_sfa26 MATCHES '[STUZ]'THEN    #FUN-A20037 add Z
                 LET l_sql = " SELECT sfa03 FROM sfa_file ",
                             "  WHERE sfa01 = '",l_sna.sna01,"'",
                             "    AND sfa03 = '",l_sfa27,"'",
                             "    AND sfa26 IN ('1','2','3','4','5','6','7','8')"  #FUN-A20037 add '7,8'
              ELSE
                 LET l_sql = " SELECT sfa03 FROM sfa_file ",
                             "  WHERE sfa01 = '",l_sna.sna01,"'",
                             "    AND sfa27 = '",l_sna.sna03b,"'",
                             "    AND sfa26 IN ('S','T','U','Z')"   #FUN-A20037 add 'Z'
              END IF
              PREPARE i803_sfa03_pre FROM l_sql
              DECLARE i803_sfa03_c CURSOR FOR i803_sfa03_pre
              FOREACH i803_sfa03_c INTO l_sfa03
                 LET l_n = 0
                 IF cl_null(l_sfa03) THEN CONTINUE FOREACH END IF
                 SELECT COUNT(*) INTO l_n FROM  sna_file
                  WHERE sna01 = l_sna.sna01
                    AND sna02 = l_sna.sna02
                    AND sna03b = l_sfa03
                    AND sna11a = l_sna.sna11a
                    AND sna03a IS NULL
                 IF l_n = 0 THEN
                    SELECT COUNT(*) INTO l_n FROM sna_file,snb_file
                     WHERE sna01 = l_sna.sna01
                       AND sna03b = l_sfa03
                       AND sna11a = l_sna.sna11a
                       AND snbconf = 'Y'
                       AND sna01 = snb01
                       AND sna02 = snb02
                       AND sna03a IS NULL
                    IF l_n = 0 THEN
                       CALL cl_err(l_sna.sna01,'asf-118',1)
                       ROLLBACK WORK
                       RETURN
                    END IF
                 END IF
              END FOREACH
        END IF
       END IF
       IF cl_null(l_sna.sna03b) OR cl_null(l_sna.sna05a) THEN
          CONTINUE FOREACH   #新增或者數量沒有變化,不需要判斷
       END IF
#TQC-AB0379 -----------------mod start-------------------------------
#      SELECT sfa06,sfa065 INTO l_sfa06,l_sfa065 FROM sfa_file  #已發數量
#       WHERE sfa01 = l_sna.sna01  AND sfa03 = l_sna.sna03b
#         AND sfa08 = l_sna.sna08b AND sfa12 = l_sna.sna12b
#         AND sfa012= l_sna.sna012b AND sfa013=l_sna.sna013b    #FUN-A60070 add
#      IF l_sna.sna05a-l_sfa06-l_sfa065 < 0 THEN
#         LET l_flag = '1'
#      END IF
      #CALL t803_check_sna05a(l_sna.sna05a,l_sna.sna01,l_sna.sna03b,l_sna.sna08b,l_sna.sna12b,l_sna.sna012b,l_sna.sna013b)              #CHI-BA0015 mark
       CALL t803_check_sna05a(l_sna.sna05a,l_sna.sna01,l_sna.sna03b,l_sna.sna08b,l_sna.sna12b,l_sna.sna012b,l_sna.sna013b,l_sna.sna11a) #CHI-BA0015 add
          RETURNING l_flag
       IF l_flag = '1' THEN
          EXIT FOREACH
       END IF
#TQC-AB0379 ------------------mod end----------------------------------
    END FOREACH
    IF l_flag = '1' THEN
     # IF NOT cl_confirm('asf-244') THEN       #TQC-AB0379
       CALL cl_err('','asf-551',1)             #TQC-AB0379
       ROLLBACK WORK
       RETURN
     # END IF                                  #TQC-AB0379
    END IF

     #FUN-C10045---begin
     CLOSE t803_chk_1
     INITIALIZE l_sna.* TO NULL
     FOREACH t803_chk_1 INTO l_sna.*
        IF NOT cl_null(l_sna.sna065a) THEN

          SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file,sfp_file
           WHERE sfs01 = sfp01
             AND sfs03 = g_snb.snb01
             AND sfs04 = l_sna.sna03b
             AND sfpconf <> 'X'
             AND sfp15 <> '9'
             AND sfp04 <> 'Y'
             AND sfp06 IN ('1','3')  #MOD-C90171 add

          SELECT SUM(sfe16) INTO l_sfe16 FROM sfe_file,sfp_file
           WHERE sfe02 = sfp01
             AND sfe01 = g_snb.snb01
             AND sfe07 = l_sna.sna03b
             AND sfpconf <> 'X'
             AND sfp15 = '1'
             AND sfp04 = 'Y'
             AND sfp06 IN ('1','3')  #MOD-C90171 add

         #MOD-C90171 add---S---
          LET l_sfe16a = 0
          SELECT SUM(sfe16) INTO l_sfe16a FROM sfe_file,sfp_file
           WHERE sfe02 = sfp01
             AND sfe01 = g_snb.snb01
             AND sfe07 = l_sna.sna03b
             AND sfpconf <> 'X'
             AND sfp15 = '1'
             AND sfp04 = 'Y'
             AND sfp06 IN ('6','8')

          IF cl_null(l_sfe16a) THEN
             LET l_sfe16a = 0
          END IF
         #MOD-C90171 add---E---

           IF cl_null(l_sfs05) THEN
              LET l_sfs05 = 0
           END IF
           IF cl_null(l_sfe16) THEN
              LET l_sfe16 = 0
           END IF
          #LET l_sfs05 = l_sfs05 + l_sfe16              #MOD-C90171 mark
           LET l_sfs05 = l_sfs05 + l_sfe16 - l_sfe16a   #MOD-C90171

          #IF l_sna.sna065a > l_sna.sna05b - l_sfs05 THEN                                      #CHI-C90030 mark
           IF (l_sna.sna065a > l_sna.sna05b - l_sfs05  AND cl_null(l_sna.sna05b)) OR           #CHI-C90030 add
              (l_sna.sna065a > l_sna.sna05a - l_sfs05  AND NOT cl_null(l_sna.sna05b)) THEN     #CHI-C90030 add
              CALL cl_err('','asf1027',1) #變更後數量不可大於 應發量 - 發料單已發量
              ROLLBACK WORK
              CLOSE t803_chk_1
              RETURN
           END IF
           SELECT SUM(rvb07) INTO l_rvb07 FROM sfb_file,rva_file,rvb_file
            WHERE sfb01 = g_snb.snb01
              AND sfb39 = '1'
              AND sfbacti = 'Y'
              AND ( sfb02 = '7' OR sfb02 = '8' )
              AND rvb34 = sfb01
              AND rvb01 = rva01
              AND rvaconf <> 'X'
              AND rvb05 = l_sna.sna03b
           IF l_sna.sna065a < l_rvb07 THEN
              CALL cl_err('','asf1028',1) #變更後數量不可小於 已收貨數量
              ROLLBACK WORK
              CLOSE t803_chk_1
              RETURN
           END IF
           UPDATE sfa_file SET sfa065 = l_sna.sna065a
            WHERE sfa01 = l_sna.sna01
              AND sfa03 = l_sna.sna03b
              AND sfa08 = l_sna.sna08b
              AND sfa12 = l_sna.sna12b
              AND sfa27 = l_sna.sna27b
              AND sfa012= l_sna.sna012b
              AND sfa013= l_sna.sna013b

           UPDATE pmn_file SET pmn20 = l_sna.sna065a,
                               pmn82 = l_sna.sna065a,
                               pmn87 = l_sna.sna065a,  #MOD-D30053
                               pmn88 = l_sna.sna065a * pmn31,  #MOD-D30053
                               pmn88t= l_sna.sna065a * pmn31t  #MOD-D30053
            WHERE pmn41 = l_sna.sna01
              AND pmn04 = l_sna.sna03b
              AND EXISTS (SELECT 1
                             FROM sfb_file, sfa_file
                             WHERE sfb01 = sfa01
                             AND sfb39 = '1'
                             AND sfbacti = 'Y'
                             AND ( sfb02 = '7' OR sfb02 = '8' )
                             AND sfb01 = l_sna.sna01)
        END IF
     END FOREACH
     #FUN-C10045---end

     #MOD-C90216---add---S
     #委外採購單未確認時直接回寫,已確認需控卡生產數量不可小於採購量
      LET l_pmm18 = ' '
      SELECT pmm18 INTO l_pmm18 FROM pmm_file,pmn_file
       WHERE pmm01 =pmn01
         AND pmn41 = g_sfb.sfb01
         AND pmn04 = g_sfb.sfb05
      IF l_pmm18 = 'Y' THEN
         LET l_pmn20 = 0
         #SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file
         # WHERE pmn41 = g_sfb.sfb01
         #   AND pmn04 = g_sfb.sfb05
          LET l_sql = "SELECT pmn78,SUM(pmn20) a FROM pmn_file WHERE pmn41 = '",g_sfb.sfb01,"'",
                            " AND pmn04='",g_sfb.sfb05,"' GROUP BY pmn78 ORDER BY a DESC"
                  PREPARE pmn20_chk_pre2 FROM l_sql
                  DECLARE pmn20_chk_cs2 CURSOR FOR pmn20_chk_pre2
                  FOREACH pmn20_chk_cs2 INTO l_pmn78,l_pmn20
                     EXIT FOREACH
                  END FOREACH
         IF g_snb.snb08a < l_pmn20 THEN
            CALL cl_err('','asf-283',1)
            RETURN
         ELSE
            UPDATE pmn_file SET pmn20 = g_snb.snb08a,
                                pmn82 = g_snb.snb08a,
                                pmn87 = g_snb.snb08a,  #MOD-D30053
                                pmn88 = g_snb.snb08a * pmn31,  #MOD-D30053
                                pmn88t= g_snb.snb08a * pmn31t  #MOD-D30053
             WHERE pmn41 = l_sna.sna01
               AND pmn04 = g_sfb.sfb05
               AND EXISTS (SELECT 1
                              FROM sfb_file, sfa_file
                              WHERE sfb01 = sfa01
                              AND sfb39 = '1'
                              AND sfbacti = 'Y'
                              AND ( sfb02 = '7' OR sfb02 = '8' )
                              AND sfb01 = l_sna.sna01)
         END IF
      ELSE
         IF NOT cl_null(g_snb.snb08a) THEN
            UPDATE pmn_file SET pmn20 = g_snb.snb08a,
                                pmn82 = g_snb.snb08a,
                                pmn87 = g_snb.snb08a,  #MOD-D30053
                                pmn88 = g_snb.snb08a * pmn31,  #MOD-D30053
                                pmn88t= g_snb.snb08a * pmn31t  #MOD-D30053
             WHERE pmn41 = l_sna.sna01
               AND pmn04 = g_sfb.sfb05
               AND EXISTS (SELECT 1
                              FROM sfb_file, sfa_file
                              WHERE sfb01 = sfa01
                              AND sfb39 = '1'
                              AND sfbacti = 'Y'
                              AND ( sfb02 = '7' OR sfb02 = '8' )
                              AND sfb01 = l_sna.sna01)
         END IF
      END IF
     #MOD-C90216---add---E

    CALL s_showmsg_init()      #MOD-BB0218 add
    CALL t803_g1() #單身
    CALL s_showmsg()           #MOD-850278 add
    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

    CALL t803_g2() #單頭
    CALL s_showmsg()           #MOD-850278 add
    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF

#MOD-D40062 add begin-------------------------
    IF cl_null(g_snb.snb08a) THEN
       DECLARE t803_sfp_c CURSOR FOR
        SELECT sfp_file.* FROM sfp_file,sfq_file
         WHERE sfp01 = sfq01
           AND sfq02 = g_snb.snb01
       FOREACH t803_sfp_c INTO l_sfp.*
         IF l_sfp.sfp06  NOT MATCHES '[49]' THEN
            DECLARE t803_sfe_c CURSOR FOR
              SELECT sfe01,sfe07,sfe14,sfe012,sfe013,sfb_file.* FROM sfe_file,sfb_file
               WHERE sfe02=l_sfp.sfp01
                 AND sfe01=sfb01
                 AND sfb93='Y'
            FOREACH t803_sfe_c INTO l_sfe01,l_sfe07,l_sfe14, l_sfe012, l_sfe013, l_sfb.*
               CALL i501sub_upd_ecm301('s',l_sfe01,l_sfe07,l_sfe14,l_sfb.*,l_sfe012,l_sfe013)
                    RETURNING l_flag
               IF NOT l_flag THEN
                  CALL s_errmsg('snb01,sna03b','','upd_ecm',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END FOREACH
         END IF
       END FOREACH
    END IF
#MOD-D40062 add end---------------------------

#重新計算欠超領量
    CALL i802_short(g_snb.snb01)
    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t803_cl
       RETURN
    END IF
    #平行加工變更
    IF g_sma.sma901 = 'Y' THEN #有串APS
        SELECT COUNT(*) INTO l_cnt
          FROM vlk_file
         WHERE vlk01 = g_snb.snb01  #工單編號
           AND vlk02 = g_snb.snb02  #變更序號
           AND vlk04 = g_sma.sma917 #資源型態
        IF l_cnt >= 1 THEN
            #FUN-960104 MOD --STR-------------------
            #平行加工變更發出
            #IF NOT t803_change_aps_pro_g() THEN
            #鎖定設備變更發出
            IF NOT t803_change_apslocked_mach_g() THEN
            #FUN-960104 MOD --END-------------------
                LET g_success = 'N'
                ROLLBACK WORK
                CLOSE t803_cl
                RETURN
            END IF
            #更新預計開工日,預計完工日
            #IF NOT t803_update_ecm() THEN  #FUN-960104 MARK
            IF NOT t803_update_ecm2() THEN  #FUN-960104 ADD
                LET g_success = 'N'
                ROLLBACK WORK
                CLOSE t803_cl
                RETURN
            END IF
        END IF
    END IF

   #UPDATE snb_file 確認碼為='Y'.............................
   #UPDATE snb_file 簽核狀況為'1：已核准'           #FUN-920208 add
   #UPDATE snb_file SET snbconf = 'Y',snb99 = '1'   #FUN-920208 add snb99 #CHI-960054 mark
    UPDATE snb_file SET snb99 = '2'   #FUN-920208 add snb99  #CHI-960054 mod
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    IF SQLCA.sqlcode THEN
       LET g_showmsg=g_snb.snb01,"/",g_snb.snb02                                            #NO.FUN-710026
       CALL s_errmsg('snb01,snb02',g_showmsg,'up snb_file',SQLCA.sqlcode,1)                 #NO.FUN-710026
       LET g_success = 'N'
    END IF

   #UPDATE sfb_file變更序號(sfb101)..........................
    UPDATE sfb_file SET sfb101 = g_snb.snb02
     WHERE sfb01 = g_snb.snb01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('sfb01',g_snb.snb01,'up sfb_file',SQLCA.sqlcode,1)            #NO.FUN-710026
       LET g_success = 'N'
    END IF
#FUN-CC0094--add--str--
    LET l_time = TIME
    UPDATE snb_file SET snbsendu = g_user,
                        snbsendd = g_today,
                        snbsendt = l_time
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    IF SQLCA.sqlcode THEN
       LET g_showmsg=g_snb.snb01,"/",g_snb.snb02
       CALL s_errmsg('snb01,snb02',g_showmsg,'up snb_file',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    SELECT snbsendu,snbsendd,snbsendt INTO g_snb.snbsendu,g_snb.snbsendd,g_snb.snbsendt FROM snb_file   #FUN-920208 add
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    DISPLAY BY NAME g_snb.snbsendu
    DISPLAY BY NAME g_snb.snbsendd
    DISPLAY BY NAME g_snb.snbsendt
#FUN-CC0094--add--end--
    CALL s_showmsg()           #NO.FUN-710026

   #FUN-9A0095-----start
    IF g_aza.aza90 MATCHES "[Yy]" THEN
       # CALL aws_mescli()
       # 傳入參數: (1)程式代號
       #           (2)功能選項：insert(新增),update(修改),delete(刪除)
       #           (3)Key
       # 更新工單資料
       IF g_sfb.sfb02 = '1' OR g_sfb.sfb02 = '5' OR g_sfb.sfb02 = '13' THEN  #FUN-CC0122 add
          CASE aws_mescli('asft803','',g_snb.snb01)
             WHEN 1  #呼叫 MES 成功
                  MESSAGE 'UPDATA O.K, UPDATA MES O.K'
             WHEN 2  #呼叫 MES 失敗
                  LET g_success = 'N'
             OTHERWISE  #其他異常
                  LET g_success = 'N'
          END CASE
       END IF                           #FUN-CC0122 add
    END IF
   #FUN-9A0095-------end

    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
    SELECT snbconf,snb99 INTO g_snb.snbconf,g_snb.snb99 FROM snb_file   #FUN-920208 add
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    DISPLAY BY NAME g_snb.snbconf
    DISPLAY BY NAME g_snb.snb99        #FUN-920208 add
    CLOSE t803_cl

END FUNCTION

FUNCTION t803_g1()
  DEFINE l_sfa    RECORD LIKE sfa_file.*
  DEFINE i        LIKE type_file.num5           #No.FUN-680121 SMALLINT
  DEFINE l_sfai   RECORD LIKE sfai_file.*       #No.FUN-7B0018
  DEFINE l_sna27b       LIKE sna_file.sna27b    #No.FUN-870051
#MOD-D40062 mark begin-----------
##MOD-C10051 --begin--
#  DEFINE l_sfp    RECORD LIKE sfp_file.*
#  DEFINE l_sfe01         LIKE sfe_file.sfe01
#  DEFINE l_sfe07         LIKE sfe_file.sfe07
#  DEFINE l_sfe14         LIKE sfe_file.sfe14
#  DEFINE l_sfe012        LIKE sfe_file.sfe012
#  DEFINE l_sfe013        LIKE sfe_file.sfe013
#  DEFINE l_sfb    RECORD LIKE sfb_file.*
#  DEFINE l_flag          LIKE type_file.num5
##MOD-C10051 --end--
#MOD-D40062 mark end-------------

    FOR i = 1 TO g_sna.getLength()
     #FUN-910088--add--start--
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna05a) THEN
          LET g_sna[i].sna05a = s_digqty(g_sna[i].sna05b,g_sna[i].sna12a)
       END IF
     #FUN-910088--add--end--
       IF cl_null(g_sna[i].sna04) THEN EXIT FOR END IF
      #2.修改/3.取替代....................................
      SELECT sna27b INTO l_sna27b FROM sna_file
       WHERE sna01 = g_snb.snb01
         AND sna02 = g_snb.snb02
         AND sna04 = g_sna[i].sna04
     #TQC-C20403 str mark-----
     #SELECT sfa27  INTO l_sna27b FROM sfa_file
     # WHERE sfa01 = g_snb.snb01
     #   AND sfa03 = g_sna[i].sna03b
     #   AND sfa08 = g_sna[i].sna08b
     #   AND sfa12 = g_sna[i].sna12b
     #   AND sfa012= g_sna[i].sna012b   #FUN-A60070
     #   AND sfa013= g_sna[i].sna013b   #FUN-A60070
     #TQC-C20403 end mark-----
      IF cl_null(l_sna27b) THEN
        #LET l_sna27b=g_sna[l_ac].sna03b      #MOD-AA0100 mark
         LET l_sna27b=g_sna[i].sna03b         #MOD-AA0100 add
      END IF
         #tianry add 170206
         IF cl_null(g_sna[i].sna012b) THEN LET g_sna[i].sna012b=' ' END IF
          #tianry add end
          SELECT * INTO l_sfa.* FROM sfa_file
           WHERE sfa01 = g_snb.snb01
             AND sfa03 = g_sna[i].sna03b
             AND sfa08 = g_sna[i].sna08b
             AND sfa12 = g_sna[i].sna12b
             AND sfa27 = l_sna27b   #No.FUN-870051
             AND sfa012= g_sna[i].sna012b   #FUN-A60070
             AND sfa013= g_sna[i].sna013b   #FUN-A60070
          IF SQLCA.sqlcode=100 THEN
              CALL t803_g1_buf(i) RETURNING l_sfa.*
              IF cl_null(l_sfa.sfa012) THEN LET l_sfa.sfa012=' ' END IF  #TQC-AB0395
              IF cl_null(l_sfa.sfa013) THEN LET l_sfa.sfa013=0   END IF  #TQC-AB0395
              IF cl_null(l_sfa.sfa32) THEN LET l_sfa.sfa32='N'   END IF  #TQC-BA0086
              INSERT INTO sfa_file VALUES (l_sfa.*)
              IF SQLCA.sqlcode THEN
                #LET g_showmsg=g_snb.snb01,"/",g_sna[i].sna03b,"/",g_sna[i].sna08b,"/",g_sna[i].sna12b,"/",l_sna27b  #NO.FUN-710026  #No.FUN-870051  #MOD-BB0218 mark
                 LET g_showmsg=g_snb.snb01,"/",l_sfa.sfa03,"/",l_sfa.sfa08,"/",l_sfa.sfa12,"/",l_sfa.sfa27  #NO.FUN-710026  #No.FUN-870051           #MOD-BB0218
                 CALL s_errmsg('sfa01,sfa03,sfa08,sfa12,sfa27',g_showmsg,'ins_sfa_1',SQLCA.sqlcode,1)         #NO.FUN-710026  #No.FUN-870051
                 LET g_success = 'N'
              ELSE
                 IF NOT s_industry('std') THEN
                    INITIALIZE l_sfai.* TO NULL
                    LET l_sfai.sfai01 = l_sfa.sfa01
                    LET l_sfai.sfai03 = l_sfa.sfa03
                    LET l_sfai.sfai08 = l_sfa.sfa08
                    LET l_sfai.sfai12 = l_sfa.sfa12
                    LET l_sfai.sfai27 = l_sfa.sfa27 #No.FUN-870051
                    LET l_sfai.sfai012 = l_sfa.sfa012  #FUN-A60070
                    LET l_sfai.sfai013 = l_sfa.sfa013  #FUN-A60070
                    IF NOT s_ins_sfai(l_sfai.*,'') THEN
                       LET g_success = 'N'
                    END IF
                 END IF
              END IF

          ELSE
             IF NOT cl_null(g_sna[i].sna05a) THEN
                LET l_sfa.sfa05  = g_sna[i].sna05a
             END IF

             IF NOT cl_null(g_sna[i].sna03a) THEN
                LET l_sfa.sfa03  = g_sna[i].sna03a
                IF l_sfa.sfa26 NOT MATCHES '[SsTtUuZz]' THEN   #FUN-A20037 add Zz
                   LET l_sfa.sfa27 = g_sna[i].sna03a
                END IF
             END IF

            #IF NOT cl_null(g_sna[i].sna08a) THEN         #MOD-B30063 mark
             IF g_sna[i].sna08a IS NOT NULL THEN          #MOD-B30063 add
              # LET l_sfa.sfa08  = g_sna[i].sna08b        #No:TQC-B60183 modify#TQC-B80242 mark
                LET l_sfa.sfa08  = g_sna[i].sna08a        #No:TQC-B80242 modify
             END IF
             IF NOT cl_null(g_sna[i].sna11a) THEN
                LET l_sfa.sfa11  = g_sna[i].sna11a
             END IF
             IF NOT cl_null(g_sna[i].sna12a) THEN
                LET l_sfa.sfa12  = g_sna[i].sna12a
             END IF
             IF NOT cl_null(g_sna[i].sna13a) THEN
                LET l_sfa.sfa13  = g_sna[i].sna13a
             END IF
             IF NOT cl_null(g_sna[i].sna161a) THEN
                LET l_sfa.sfa161 = g_sna[i].sna161a
             END IF
             IF NOT cl_null(g_sna[i].sna26a) THEN
                LET l_sfa.sfa26 = g_sna[i].sna26a
             END IF
             IF NOT cl_null(g_sna[i].sna28a) THEN
                LET l_sfa.sfa28 = g_sna[i].sna28a
             END IF
#FUN-A60070 --begin--
             IF NOT cl_null(g_sna[i].sna012a) THEN
                LET l_sfa.sfa012 = g_sna[i].sna012a
             END IF
             IF NOT cl_null(g_sna[i].sna013a) THEN
                LET l_sfa.sfa013 = g_sna[i].sna013a
             END IF
#FUN-A60070 --end--
             UPDATE sfa_file SET * = l_sfa.*
              WHERE sfa01 = l_sfa.sfa01
                AND sfa03 = g_sna[i].sna03b #TQC-7C0012
                AND sfa08 = g_sna[i].sna08b #TQC-7C0012
                AND sfa12 = g_sna[i].sna12b #TQC-7C0012
                AND sfa27 = l_sna27b #No.FUN-870051
                AND sfa012= g_sna[i].sna012b  #FUN-A60070
                AND sfa013= g_sna[i].sna013b  #FUN-A60070
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_showmsg=l_sfa.sfa01,"/",l_sfa.sfa03,"/",l_sfa.sfa08,"/",l_sfa.sfa12,"/",l_sfa.sfa27  #No.FUN-870051  #NO.FUN-710026
                                          ,"/",l_sfa.sfa012,"/",l_sfa.sfa013    #FUN-A60070 add
                 CALL s_errmsg('sfa01,sfa03,sfa08,sfa12,sfa27',g_showmsg,'upd_sfa',SQLCA.sqlcode,1) #No.FUN-870051 #NO.FUN-710026
                 LET g_success = 'N'
             #----------------No:MOD-A20057 add
              ELSE
                 IF NOT s_industry('std') THEN
                    CALL t803_ind_icd_set_sfaiicd(l_sfa.*,g_sna[i].sna03b,g_sna[i].sna08b,
                                                  g_sna[i].sna12b,l_sna27b)
                 END IF
             #----------------No:MOD-A20057 end
              END IF
          END IF
    END FOR
#MOD-D40062 mark begin-----------
#    IF cl_null(g_snb.snb08a) THEN   #MOD-D10252
##MOD-C10051 --begin--
#       DECLARE t803_sfp_c CURSOR FOR
#        SELECT sfp_file.* FROM sfp_file,sfq_file
#         WHERE sfp01 = sfq01
#           AND sfq02 = g_snb.snb01
#       FOREACH t803_sfp_c INTO l_sfp.*
#         IF l_sfp.sfp06  NOT MATCHES '[49]' THEN
#            DECLARE t803_sfe_c CURSOR FOR
#              SELECT sfe01,sfe07,sfe14,sfe012,sfe013,sfb_file.* FROM sfe_file,sfb_file
#               WHERE sfe02=l_sfp.sfp01
#                 AND sfe01=sfb01
#                 AND sfb93='Y'
#            FOREACH t803_sfe_c INTO l_sfe01,l_sfe07,l_sfe14, l_sfe012, l_sfe013, l_sfb.*
#               CALL i501sub_upd_ecm301('s',l_sfe01,l_sfe07,l_sfe14,l_sfb.*,l_sfe012,l_sfe013)
#                    RETURNING l_flag
#               IF NOT l_flag THEN
#                  CALL s_errmsg('snb01,sna03b','','upd_ecm',SQLCA.sqlcode,1)
#                  LET g_success = 'N'
#               END IF
#            END FOREACH
#         END IF
#       END FOREACH
##MOD-C10051 --end--
#    END IF  #MOD-D10252
#MOD-D40062 mark end-------------
END FUNCTION

#MOD-C10051 --begin--
  FUNCTION i501sub_upd_ecm301(p_code,l_sfs03,l_sfs04,l_sfs10,l_sfb,l_sfs012,l_sfs013)
     DEFINE p_code        LIKE type_file.chr1
     DEFINE l_sfb RECORD  LIKE sfb_file.*
     DEFINE l_ima153      LIKE ima_file.ima153
     DEFINE l_ecm58_gfe03 LIKE gfe_file.gfe03
     DEFINE l_ecm62       LIKE ecm_file.ecm62
     DEFINE l_ecm63       LIKE ecm_file.ecm63
     DEFINE l_ecm58       LIKE ecm_file.ecm58
     DEFINE l_cnt         LIKE type_file.num5
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
     DEFINE l_shb111      LIKE shb_file.shb111
     DEFINE l_sfs012      LIKE sfs_file.sfs012
     DEFINE l_sfs013      LIKE sfs_file.sfs013
     DEFINE l_sfa012      LIKE sfa_file.sfa012
     DEFINE l_sfa013      LIKE sfa_file.sfa013
     DEFINE l_flag1       LIKE type_file.num5
     DEFINE l_sfb05       LIKE sfb_file.sfb05

     IF g_sma.sma541 = 'Y' AND cl_null(l_sfs012) THEN
        IF cl_null(l_sfs10) THEN
           CALL s_schdat_min_ecm03(l_sfb.sfb01)
           RETURNING l_sfa012,l_sfa013
           LET l_sfs012=l_sfa012
        ELSE
           DECLARE i501_upd_ecm_c1 CURSOR FOR
              SELECT ecm012 FROM ecm_file
               WHERE ecm01=l_sfb.sfb01
                 AND ecm04=l_sfs10
               ORDER BY ecm012
           FOREACH i501_upd_ecm_c1 INTO l_sfa012
              LET l_sfs012=l_sfa012
              EXIT FOREACH
           END FOREACH
         END IF
     END IF

     LET l_ecm03=0
     SELECT MIN(ecm03) INTO l_ecm03
       FROM ecm_file
      WHERE ecm01=l_sfb.sfb01
        AND ecm012 = l_sfs012
     IF STATUS THEN LET l_ecm03=0 END IF

     IF cl_null(l_ecm03) OR l_ecm03 = 0 THEN
        CALL cl_err('','sdf-349',1)
        RETURN FALSE
     END IF

     IF g_sma.sma542='Y' THEN
        CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag1,l_sfb05
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM ecu_file
         WHERE ecu01=l_sfb05
           AND ecu02=l_sfb.sfb06
           AND ecu015=l_sfs012
           AND ecuacti = 'Y'  #CHI-C90006
        IF l_cnt > 0 THEN
           RETURN TRUE
        END IF
        IF l_ecm03 <> l_sfs013 THEN
           RETURN TRUE
        END IF
     END IF

     SELECT ecm04 INTO l_ecm04
      FROM ecm_file
           WHERE ecm01 = l_sfb.sfb01
         AND ecm03 = l_ecm03
         AND ecm012 = l_sfs012
     IF l_ecm04 IS NULL THEN
        LET l_ecm04 = ' '
     END IF

     IF (l_ecm04 = l_sfs10) OR (l_sfs10=' ') THEN
        LET g_min_set=0
        CALL s_get_ima153(l_sfs04) RETURNING l_ima153
        CALL cs_minp_routing(l_sfs03,g_sma.sma73,l_ima153,l_sfs10,l_sfs012,l_sfs013)
        RETURNING l_flag,g_min_set
        IF l_flag !=0  THEN
#          CALL cl_err(l_sfs03,'asf-549',1)
           CALL s_errmsg('g_min_set',l_sfs03,'',"asf-549",1)
           RETURN FALSE
        END IF

        SELECT ima55,ima56 INTO l_ima55,l_ima56 FROM ima_file
        WHERE ima01=l_sfb.sfb05
        IF STATUS THEN LET l_ima55=' ' END IF

        SELECT ecm58,ecm62,ecm63,gfe03 INTO l_ecm58,l_ecm62,l_ecm63,l_ecm58_gfe03
         FROM ecm_file LEFT OUTER JOIN gfe_file ON (ecm_file.ecm58 = gfe_file.gfe01)
        WHERE ecm01=l_sfb.sfb01
          AND ecm03=l_ecm03
          AND ecm012 = l_sfs012
       IF STATUS THEN LET l_ecm58=' ' END IF
        IF l_ecm58_gfe03 IS NULL THEN
           LET l_ecm58_gfe03 = 0
        END IF
        IF cl_null(l_ecm62) THEN
           LET l_ecm62 = 1
        END IF
        IF cl_null(l_ecm63) THEN
           LET l_ecm63 = 1
        END IF

        LET l_ecm301 = g_min_set*l_ecm62/l_ecm63
        LET l_ecm301 = cl_digcut(l_ecm301,l_ecm58_gfe03)

        SELECT SUM(shb111) INTO l_shb111
          FROM shb_file
         WHERE shb05=l_sfb.sfb01
           AND shb06=l_ecm03
           AND shb012=l_sfs012
           AND shbconf = 'Y'
        IF SQLCA.sqlcode OR l_shb111 IS NULL THEN
            LET l_shb111 = 0
        END IF

       # IF l_ecm301 < l_shb111 THEN
       IF g_user<>'tiptop' AND    l_ecm301 < l_shb111 THEN

          LET g_showmsg = l_sfs03,"/",l_sfs04,"/",l_sfs10
          CALL s_errmsg('sfs04,sfs04,sfs10',g_showmsg,'','asf-135',1)
          RETURN FALSE
        END IF

        UPDATE ecm_file SET ecm301=l_ecm301
         WHERE ecm01=l_sfb.sfb01
           AND ecm03=l_ecm03
           AND ecm012=l_sfs012
        IF SQLCA.sqlerrd[3]=0 THEN
#          CALL cl_err3("upd","ecm_file",l_sfb.sfb01,l_ecm03,STATUS,"","upd ecm301",1)
           CALL s_errmsg('upd ecm_file',l_ecm03,'',"upd ecm301",1)
           RETURN FALSE
        END IF
     END IF
     RETURN TRUE
  END FUNCTION
#MOD-C10051 --end--


#----------------------------------No:MOD-A20057 add------------------------------------------------
FUNCTION t803_ind_icd_set_sfaiicd(p_sfa,p_sna03b,p_sna08b,p_sna12b,p_sna27b)
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01,
         l_imaicd01  LIKE imaicd_file.imaicd01,
         l_imaicd04  LIKE imaicd_file.imaicd04,
        #l_icb05     LIKE icb_file.icb05,    #FUN-B30192
         l_imaicd14  LIKE imaicd_file.imaicd14,   #FUN-B30192
         l_sfb09     LIKE sfb_file.sfb09,
         l_sfb86     LIKE sfb_file.sfb86,
         l_sfbiicd09 LIKE sfbi_file.sfbiicd09,
         l_cnt       SMALLINT
  DEFINE p_sfa       RECORD LIKE sfa_file.*
  DEFINE p_sna03b    LIKE sna_file.sna27b
  DEFINE p_sna08b    LIKE sna_file.sna27b
  DEFINE p_sna12b    LIKE sna_file.sna27b
  DEFINE p_sna27b    LIKE sna_file.sna27b
  DEFINE l_sfai      RECORD LIKE sfai_file.*

     SELECT * INTO l_sfai.* FROM sfai_file
      WHERE sfai01=p_sfa.sfa01
        AND sfai03= p_sna03b
        AND sfai08= p_sna08b
        AND sfai12= p_sna12b
        AND sfai27= p_sna27b

      SELECT sfbiicd09 INTO l_sfbiicd09 FROM sfbi_file WHERE sfbi01 = p_sfa.sfa01
      SELECT sfb86 INTO l_sfb86 FROM sfb_file WHERE sfb01 = p_sfa.sfa01

      IF l_sfai.sfaiicd01 =0 OR  l_sfai.sfaiicd01 is NULL  THEN
         SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01 = l_sfbiicd09

         CASE
            WHEN l_ecdicd01 = '2'
                 #參考單位應發數量(sfaiicd01)=投片數(sfa05) * Gross die(icb05)
                 #Gross Die(icb05) = 若發料狀(imaicd04)=0-1,則發料料號(sfa03)
                 #                       對應ima_file帶出母體料號(imaicd01),
                 #                       再由imaicd01串icb_file帶出(icb05)
            SELECT imaicd01,imaicd04 INTO l_imaicd01,l_imaicd04 FROM imaicd_file
             WHERE imaicd00 = p_sfa.sfa03
            IF l_imaicd04 MATCHES '[01234]' THEN
          #FUN-B30192--begin
          #     SELECT icb05 INTO l_icb05 FROM icb_file
          #      WHERE icb01 = l_imaicd01
          #     IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF
          #     LET l_sfai.sfaiicd01 = p_sfa.sfa05 * l_icb05
               CALL s_icdfun_imaicd14(p_sfa.sfa03)   RETURNING l_imaicd14
               IF cl_null(l_imaicd14) THEN LET l_imaicd14= 0 END IF
               LET l_sfai.sfaiicd01 = p_sfa.sfa05 *l_imaicd14
          #FUN-B30192--end
            END IF

            WHEN l_ecdicd01 = '3' OR l_ecdicd01 = '4'
                 #若母工單號<>空白,則查詢母工單號之入庫數量是否等於發料數,若相等,則
                 #參考單位應發數量(sfaiicd01)=投片數之pass bin數量(rvv85)入庫參考量
                 #若不相等,比照母工單號=空白的做法
                 IF NOT cl_null(g_sfb.sfb86) THEN
                    SELECT sfb09 INTO l_sfb09 FROM sfb_file WHERE sfb01 = l_sfb86
                    IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
                    IF l_sfb09 = p_sfa.sfa05 THEN
                       DECLARE rvv85_cs2 CURSOR FOR
                        SELECT SUM(rvv85) FROM rvu_file,rvv_file
                         WHERE rvu01 = rvv01 AND rvu00 = '1' AND rvuconf = 'Y'
                           AND rvv36=l_sfb86

                       OPEN rvv85_cs2
                       IF SQLCA.sqlcode THEN
                          CALL cl_err("OPEN rvv85_cs2:", SQLCA.sqlcode, 1)
                          RETURN
                       END IF
                       FETCH rvv85_cs2 INTO l_sfai.sfaiicd01
                       IF SQLCA.sqlcode THEN
                          CALL cl_err("fetch rvv85_cs2:", SQLCA.sqlcode, 1)
                          RETURN
                       END IF
                    ELSE
                    #若母工單號 = 空白,則
                    #參考單位應發數量(sfaiicd01) =
                    #                應發數量(sfa05) * Gross Die(icb05)
                    #Gross Die(icb05) = 若發料狀(imaicd04)=2,則發料料號(sfa03)
                    #                       對應ima_file帶出母體料號(imaicd01),
                       SELECT imaicd01,imaicd04 INTO l_imaicd01,l_imaicd04
                         FROM imaicd_file WHERE imaicd00 = p_sfa.sfa03
                       IF l_imaicd04 = '2' THEN
                   #FUN-B30192--begin
                   #       SELECT icb05 INTO l_icb05 FROM icb_file
                   #        WHERE icb01 = l_imaicd01
                   #       IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF
                   #       LET l_sfai.sfaiicd01 = p_sfa.sfa05 * l_icb05
                          CALL s_icdfun_imaicd14(p_sfa.sfa03)   RETURNING l_imaicd14
                          IF cl_null(l_imaicd14) THEN LET l_imaicd14= 0 END IF
                          LET l_sfai.sfaiicd01 = p_sfa.sfa05 *l_imaicd14
                   #FUN-B30192--end
                       END IF
                    END IF
                 ELSE
                 #若母工單號 = 空白,則
                 #參考單位應發數量(sfaiicd01)=應發數量(sfa05) * Gross Die(icb05)
                 #Gross Die(icb05) = 若發料狀(imaicd04)=2,則發料料號(sfa03)
                 #                       對應ima_file帶出母體料號(imaicd01),
                    SELECT imaicd01,imaicd04 INTO l_imaicd01,l_imaicd04
                      FROM imaicd_file WHERE imaicd00 = p_sfa.sfa03
                    IF l_imaicd04 = '2' THEN
                  #FUN-B30192--begin
                  #     SELECT icb05 INTO l_icb05 FROM icb_file
                  #      WHERE icb01 = l_imaicd01
                  #     IF cl_null(l_icb05) THEN LET l_icb05 = 0 END IF
                  #     LET l_sfai.sfaiicd01 = p_sfa.sfa05 * l_icb05
                       CALL s_icdfun_imaicd14(p_sfa.sfa03)   RETURNING l_imaicd14
                       IF cl_null(l_imaicd14) THEN LET l_imaicd14= 0 END IF
                       LET l_sfai.sfaiicd01 = p_sfa.sfa05 *l_imaicd14
                   #FUN-B30192--end
                    END IF
                 END IF
            OTHERWISE
                 #其它:應發參考數量(sfaiicd01)=應發數量(sfa05)
                 LET l_sfai.sfaiicd01 = p_sfa.sfa05
         END CASE
         #應發數量單位(sfaiicd02)=ima907
      END IF
      IF  l_sfai.sfaiicd02 IS NULL THEN
       SELECT ima907 INTO l_sfai.sfaiicd02 FROM ima_file
        WHERE ima01 = p_sfa.sfa03
      END IF
      LET l_sfai.sfaiicd01 = s_digqty(l_sfai.sfaiicd01,l_sfai.sfaiicd02)   #No.FUN-BB0086

      LET l_sfai.sfai01 = p_sfa.sfa01
      LET l_sfai.sfai03 = p_sfa.sfa03
      LET l_sfai.sfai08 = p_sfa.sfa08
      LET l_sfai.sfai12 = p_sfa.sfa12
      LET l_sfai.sfai27 = p_sfa.sfa27

      UPDATE sfai_file SET * = l_sfai.*
       WHERE sfai01=p_sfa.sfa01
         AND sfai03= p_sna03b
         AND sfai08= p_sna08b
         AND sfai12= p_sna12b
         AND sfai27= p_sna27b
      IF SQLCA.sqlcode  OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","sfai_file",p_sfa.sfa03,"",SQLCA.sqlcode,"","upd sfai",1)
         LET g_success = 'N'
      END IF
END FUNCTION
#----------------------------------No:MOD-A20057 add------------------------------------------------
FUNCTION t803_g2() #單頭變更
  DEFINE l_sfb    RECORD LIKE sfb_file.*
  DEFINE l_sfb08x LIKE sfb_file.sfb08     #MOD-850128 add
  DEFINE l_ecm03  LIKE ecm_file.ecm03     #MOD-850128 add
  #FUN-B20087--begin--add------
  DEFINE l_sfd03     LIKE sfd_file.sfd03
  DEFINE l_sfd05_a   LIKE sfd_file.sfd05
  DEFINE l_sfd05_b   LIKE sfd_file.sfd05
  DEFINE l_snb08b    LIKE snb_file.snb08b
  DEFINE l_snb08a    LIKE snb_file.snb08a
  DEFINE l_sfa161    LIKE sfa_file.sfa161
  DEFINE l_sfa05     LIKE sfa_file.sfa05
  DEFINE l_subqty    LIKE sfa_file.sfa05
  DEFINE l_sfa       RECORD LIKE sfa_file.*
  DEFINE l_cnt       LIKE type_file.num5
  DEFINE l_sql       STRING
  DEFINE l_sfb13     LIKE sfb_file.sfb13
  DEFINE l_sfb15     LIKE sfb_file.sfb15
  DEFINE l_sfb82     LIKE sfb_file.sfb82
  DEFINE l_flag      LIKE type_file.num5
  #FUN-B20087--end--add--------
#MOD-D10252 --begin--
  DEFINE l_sfp    RECORD LIKE sfp_file.*
  DEFINE l_sfe01         LIKE sfe_file.sfe01
  DEFINE l_sfe07         LIKE sfe_file.sfe07
  DEFINE l_sfe14         LIKE sfe_file.sfe14
  DEFINE l_sfe012        LIKE sfe_file.sfe012
  DEFINE l_sfe013        LIKE sfe_file.sfe013
  DEFINE l_sfb1   RECORD LIKE sfb_file.*
#MOD-D10252 --end--

      #2.修改/3.取替代....................................
          SELECT * INTO l_sfb.* FROM sfb_file
           WHERE sfb01 = g_snb.snb01

          IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","sfb_file",g_snb.snb01,"",SQLCA.sqlcode,"","ins_sfb_1",1)  #No.FUN-660128
                 LET g_success = 'N'
          ELSE
             IF NOT cl_null(g_snb.snb08a) THEN
                #已發料的製程工單才有ecm_file
               #FUN-B20087--begin--mod-----
                CALL t803_upd_ecm(l_sfb.sfb01,g_snb.snb08b,g_snb.snb08a)
               #IF l_sfb.sfb93 = 'Y'  AND l_sfb.sfb04 MATCHES '[234567]' THEN
               #   IF NOT cl_null(g_snb.snb08b) THEN
               #      LET l_sfb08x = l_sfb.sfb08 - g_snb.snb08a
               #   END IF
               #   SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
               #    WHERE ecm01=l_sfb.sfb01
               #   UPDATE ecm_file SET ecm301=ecm301-l_sfb08x
               #    WHERE ecm01=l_sfb.sfb01
               #      AND ecm03=l_ecm03
               #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               #      CALL cl_err3("upd","ecm_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","upd_ecm",1)
               #      LET g_success = 'N'
               #   END IF
               #END IF
               #FUN-B20087--end--mod----
                LET l_sfb.sfb08  = g_snb.snb08a
             END IF

             IF NOT cl_null(g_snb.snb13a) THEN
                LET l_sfb.sfb13  = g_snb.snb13a
             END IF
             IF NOT cl_null(g_snb.snb15a) THEN
                LET l_sfb.sfb15  = g_snb.snb15a
             END IF
             #FUN-A10134---add---str---
             IF NOT cl_null(g_snb.snb14a) THEN
                LET l_sfb.sfb14  = g_snb.snb14a
             END IF
             IF NOT cl_null(g_snb.snb16a) THEN
                LET l_sfb.sfb16  = g_snb.snb16a
             END IF
             #FUN-A10134---add---end---
             IF NOT cl_null(g_snb.snb82a) THEN
                LET l_sfb.sfb82  = g_snb.snb82a
             END IF

             UPDATE sfb_file SET * = l_sfb.*
              WHERE sfb01 = l_sfb.sfb01

              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","upd_sfb",1)  #No.FUN-660128
                 LET g_success = 'N'
              END IF
             #MOD-D10252---begin
             IF NOT cl_null(g_snb.snb08a) THEN
                DECLARE t803_sfp_c1 CURSOR FOR
                 SELECT sfp_file.* FROM sfp_file,sfq_file
                  WHERE sfp01 = sfq01
                    AND sfq02 = g_snb.snb01
                FOREACH t803_sfp_c1 INTO l_sfp.*
                   IF l_sfp.sfp06  NOT MATCHES '[49]' THEN
                      DECLARE t803_sfe_c1 CURSOR FOR
                       SELECT sfe01,sfe07,sfe14,sfe012,sfe013,sfb_file.* FROM sfe_file,sfb_file
                        WHERE sfe02=l_sfp.sfp01
                          AND sfe01=sfb01
                          AND sfb93='Y'
                      FOREACH t803_sfe_c1 INTO l_sfe01,l_sfe07,l_sfe14, l_sfe012, l_sfe013, l_sfb1.*
                         CALL i501sub_upd_ecm301('s',l_sfe01,l_sfe07,l_sfe14,l_sfb1.*,l_sfe012,l_sfe013)
                         RETURNING l_flag
                         IF NOT l_flag THEN
                            CALL s_errmsg('snb01,sna03b','','upd_ecm',SQLCA.sqlcode,1)
                            LET g_success = 'N'
                         END IF
                      END FOREACH
                   END IF
                END FOREACH
             END IF
             #MOD-D10252---end
              #FUN-B20087--begin--add----
              IF g_success = 'Y' AND NOT cl_null(l_sfb.sfb85) AND NOT cl_null(g_snb.snb08a) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=g_snb.snb01 AND (sfd07 IS NOT NULL AND sfd07<>' ')
                 IF l_cnt > 0 THEN
                    DECLARE t803_sfd CURSOR FOR
                      SELECT DISTINCT sfd03 FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03 <> g_snb.snb01
                    LET l_flag = 1
                    FOREACH t803_sfd INTO l_sfd03
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM snb_file WHERE snb01=l_sfd03 AND snb99 <> '2' AND snbconf <> 'X'
                       IF l_cnt > 0 THEN
                          CALL cl_err(l_sfd03,'asf-540',1) LET g_success = 'N' RETURN
                       ELSE
                          SELECT sfd05 INTO l_sfd05_a FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=l_sfd03
                          SELECT sfd05 INTO l_sfd05_b FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=g_snb.snb01
                          SELECT sfb08,sfb13,sfb15,sfb82 INTO l_snb08b,l_sfb13,l_sfb15,l_sfb82 FROM sfb_file WHERE sfb01=l_sfd03
                          IF NOT cl_null(g_snb.snb13a) THEN LET l_sfb13  = g_snb.snb13a END IF
                          IF NOT cl_null(g_snb.snb15a) THEN LET l_sfb15  = g_snb.snb15a END IF
                          IF NOT cl_null(g_snb.snb82a) THEN LET l_sfb82  = g_snb.snb82a END IF
                          LET l_snb08a = g_snb.snb08a / l_sfd05_b * l_sfd05_a
                          IF l_snb08b = l_snb08a THEN CONTINUE FOREACH END IF
                          LET l_cnt = 0
                          SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01=l_sfd03
                          IF l_cnt>0 THEN
                             IF l_flag=1 THEN
                                IF NOT cl_confirm('asf-156') THEN LET g_success='N' RETURN END IF
                                LET l_flag = l_flag + 1
                             END IF
                             UPDATE sfb_file SET sfb08=l_snb08a,sfb13=l_sfb13,sfb15=l_sfb15,sfb82=l_sfb82 WHERE sfb01=l_sfd03
                             LET l_sql = "SELECT * FROM sfa_file ",
                                         " WHERE sfa01 = ? ",
                                         " AND (sfa11 <> 'S' )"
                             PREPARE ct803_prepare1 FROM l_sql
                             DECLARE ct803_cl1 CURSOR FOR ct803_prepare1
                             FOREACH ct803_cl1 USING l_sfd03 INTO l_sfa.*
                               LET l_sfa05 =l_sfa.sfa05*l_snb08a/l_snb08b
                               LET l_subqty=0
                               LET l_sfa05 = s_digqty(l_sfa05,l_sfa.sfa12)    #FUN-BB0085
                               SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
                                WHERE sfa01 = l_sfd03
                                  AND sfa27 = l_sfa.sfa03
                                  AND sfa26 IN ('S','U')
                               IF cl_null(l_subqty) THEN
                                  LET l_subqty=0
                               END IF
                               IF NOT cl_null(l_snb08a) THEN #考慮單頭變更的狀況
                                  LET l_subqty=l_subqty*l_snb08a/l_snb08b
                               END IF
                               IF l_sfa.sfa26 MATCHES '[SUTsut]' THEN #替代料只能變更替代率
                                  LET l_sfa161 = 0
                               ELSE
                                  LET l_sfa161=(l_sfa05+l_subqty)/l_snb08a
                               END IF
                               UPDATE sfa_file SET sfa05=l_sfa05,sfa161=l_sfa161
                                WHERE sfa01=l_sfa.sfa01 AND sfa03=l_sfa.sfa03
                                  AND sfa08=l_sfa.sfa08 AND sfa12=l_sfa.sfa12
                                  AND sfa27=l_sfa.sfa27
                                  AND sfa012=l_sfa.sfa012 AND sfa013=l_sfa.sfa013
                             END FOREACH
                             CALL t803_upd_ecm(l_sfd03,l_snb08b,l_snb08a)
                          END IF
                       END IF
                    END FOREACH
                 END IF
              END IF
              #FUN-B20087--end--add------
          END IF

END FUNCTION

#FUN-B20087--begin--add----
FUNCTION t803_upd_ecm(p_sfb01,p_snb08b,p_snb08a)
DEFINE p_sfb01    LIKE sfb_file.sfb01
DEFINE p_snb08b   LIKE snb_file.snb08b
DEFINE p_snb08a   LIKE snb_file.snb08a
DEFINE l_sfb      RECORD LIKE sfb_file.*
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sfb08x   LIKE sfb_file.sfb08
DEFINE l_ecm012   LIKE ecm_file.ecm012
DEFINE l_ecm03    LIKE ecm_file.ecm03

 SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=p_sfb01
 IF l_sfb.sfb93='Y' AND l_sfb.sfb04 MATCHES '[234567]' THEN
    IF NOT cl_null(p_snb08b) THEN
       LET l_sfb08x = p_snb08b - p_snb08a
    END IF
    #MOD-D30093---begin
    IF NOT cl_null(p_snb08a) AND p_snb08b <> 0 THEN
       UPDATE ecm_file SET ecm14=ecm14*(p_snb08a/p_snb08b),
                           ecm16=ecm16*(p_snb08a/p_snb08b)
                     WHERE ecm01=l_sfb.sfb01
    END IF
    #MOD-D30093---end
    IF (g_sma.sma541='Y' AND l_sfb.sfb93='Y' ) OR
      (l_sfb.sfb93='Y' AND l_sfb.sfb39 = '2') THEN   #倒扣料時更新首站的ecm301
      DECLARE t803_upd_ecm301_c1 CURSOR FOR
              SELECT DISTINCT ecm012 FROM ecm_file
               WHERE ecm01=p_sfb01
      FOREACH t803_upd_ecm301_c1 INTO l_ecm012
         #若走平行工藝,須判斷如果本製程段無上製程段,
         #且為最小製程序,並且不須發料，才需回寫 ecm301,否則由asft700回寫.
         LET l_cnt = 0
         IF (g_sma.sma542='Y') AND (l_sfb.sfb39 ='1')  THEN
            SELECT COUNT(*) INTO l_cnt FROM ecm_file
             WHERE ecm01=l_sfb.sfb01
               AND ecm015=l_ecm012
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF
         LET l_ecm03=NULL
         SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
          WHERE ecm01=l_sfb.sfb01
            AND ecm012=l_ecm012
         IF l_ecm03 IS NOT NULL THEN
            LET l_cnt = 0
            IF l_sfb.sfb39 <> '2' THEN
               IF g_sma.sma542 = 'Y' THEN
                  SELECT COUNT(*) INTO l_cnt FROM sfa_file
                   WHERE sfa01=l_sfb.sfb01
                     AND sfa012=l_ecm012
                     AND sfa013=l_ecm03
               ELSE
                  LET l_cnt = 1
               END IF
            END IF
            IF l_cnt = 0 THEN #首製程無備料，表示不需發料 OR 倒扣料
               UPDATE ecm_file SET ecm301=ecm301-l_sfb08x
                             WHERE ecm01=l_sfb.sfb01
                               AND ecm012=l_ecm012
                               AND ecm03=l_ecm03
            END IF
         END IF
      END FOREACH
    END IF
 END IF
 IF g_sma.sma541='Y' AND l_sfb.sfb93='Y' THEN
    SELECT DISTINCT ecm012 INTO l_ecm012 FROM ecm_file
     WHERE ecm01=p_sfb01
       AND (ecm015 IS NULL OR ecm015=' ')
    CALL s_schdat_output(l_ecm012,p_snb08a,p_sfb01)
 ELSE
    CALL s_schdat_output(' ',p_snb08a,p_sfb01)
 END IF
END FUNCTION
#FUN-B20087--end--add---------

FUNCTION t803_g1_buf(p_i)
  DEFINE  p_i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sfa    RECORD LIKE sfa_file.*

  INITIALIZE l_sfa.* TO NULL

  LET l_sfa.sfa01  = g_snb.snb01
 #LET l_sfa.sfa02  = g_snb.snb02          #MOD-AC0134 mark
  LET l_sfa.sfa02  = g_sfb.sfb02          #MOD-AC0134 add
  LET l_sfa.sfa03  = g_sna[p_i].sna03a
  LET l_sfa.sfa012 = g_sna[p_i].sna012a   #FUN-A60070 add
  LET l_sfa.sfa013 = g_sna[p_i].sna013a   #FUN-A60070 add
  LET l_sfa.sfa04  = g_sna[p_i].sna05a
  LET l_sfa.sfa05  = g_sna[p_i].sna05a
  LET l_sfa.sfa065 = g_sna[p_i].sna065a   #FUN-C10045
  LET l_sfa.sfa061 = 0
  LET l_sfa.sfa063 = 0
  LET l_sfa.sfa064 = 0
  LET l_sfa.sfa066 = 0
 #-----------------No:TQC-B60183 modify
 #LET l_sfa.sfa08  = g_sna[p_i].sna08a
  IF g_sna[p_i].sna08a IS NOT NULL THEN
   # LET l_sfa.sfa08  = g_sna[p_i].sna08b     #TQC-B90004  --mark
     LET l_sfa.sfa08  = g_sna[p_i].sna08a    #TQC-B90004  --modify
  END IF
 #--------------------No:TQC-B60183 end
  LET l_sfa.sfa11  = g_sna[p_i].sna11a
  LET l_sfa.sfa12  = g_sna[p_i].sna12a
  LET l_sfa.sfa13  = g_sna[p_i].sna13a

  LET l_sfa.sfaplant = g_plant #FUN-980008 add
  LET l_sfa.sfalegal = g_legal #FUN-980008 add

#FUN-A60070 --begin--
 IF g_sma.sma542 = 'Y' AND g_sfb.sfb93 = 'Y' THEN
    SELECT (brb06/brb07)*(1+brb08/100) INTO l_sfa.sfa16 FROM brb_file
     WHERE brb01 = g_sfb.sfb05
       AND brb03 = l_sfa.sfa27
       AND brb011= g_sfb.sfb06
       AND brb012= g_sna[p_i].sna012a
       AND brb013= g_sna[p_i].sna013a
       AND (brb04<=g_sfb.sfb071 OR brb04 IS NULL)
       AND (g_sfb.sfb071<brb05 OR brb05 IS NULL)
 ELSE
#FUN-A60070 --end--
     SELECT (bmb06/bmb07)*(1+bmb08/100) INTO l_sfa.sfa16 FROM bmb_file
      WHERE bmb01=g_sfb.sfb05
        AND bmb03=l_sfa.sfa27
        AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
        AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
  END IF  #FUN-A60070
  #mark by lixwz201210 s---
  #IF cl_null(l_sfa.sfa16) THEN LET l_sfa.sfa16 = 1 END IF
  #LET l_sfa.sfa04  = g_sfb.sfb08 * l_sfa.sfa16
  #mark by lixwz201210 e---
  #add by lixwz201210 s---
  #cxcp900 计算的时候会根据sfa16是否等于0判断是否是BOM中料件.
  #默认需要是0,因为asfi301新增非BOM料件,默认也是0
  IF cl_null(l_sfa.sfa16) THEN
   LET l_sfa.sfa04 = g_sfb.sfb08
   LET l_sfa.sfa16 =0
  ELSE
   LET l_sfa.sfa04  = g_sfb.sfb08 * l_sfa.sfa16
  END IF
  #add by lixwz201210 e---

  LET l_sfa.sfa161 = g_sna[p_i].sna161a
  LET l_sfa.sfa26 = g_sna[p_i].sna26a   #FUN-990059
  LET l_sfa.sfa25  = 0
  #LET l_sfa.sfa29  = g_sfa29[p_i]        #FUN-B20056 mark
  LET l_sfa.sfa29  = g_sna[p_i].sna29a    #FUN-B20056
  LET l_sfa.sfaacti= 'Y'
  IF cl_null(l_sfa.sfa012) THEN LET l_sfa.sfa012 = '' END IF   #FUN-A60070
  IF cl_null(l_sfa.sfa013) THEN LET l_sfa.sfa013 = 0  END IF   #FUN-A60070
  IF cl_null(l_sfa.sfa04)  THEN LET l_sfa.sfa04  = 0 END IF
  IF cl_null(l_sfa.sfa05)  THEN LET l_sfa.sfa05  = 0 END IF
  IF cl_null(l_sfa.sfa06)  THEN LET l_sfa.sfa06  = 0 END IF
  IF cl_null(l_sfa.sfa061) THEN LET l_sfa.sfa061 = 0 END IF
  IF cl_null(l_sfa.sfa062) THEN LET l_sfa.sfa062 = 0 END IF
  IF cl_null(l_sfa.sfa063) THEN LET l_sfa.sfa063 = 0 END IF
  IF cl_null(l_sfa.sfa064) THEN LET l_sfa.sfa064 = 0 END IF
  IF cl_null(l_sfa.sfa065) THEN LET l_sfa.sfa065 = 0 END IF
  IF cl_null(l_sfa.sfa066) THEN LET l_sfa.sfa066 = 0 END IF
  IF cl_null(l_sfa.sfa07) THEN LET l_sfa.sfa07 = 0 END IF
  IF cl_null(l_sfa.sfa09) THEN LET l_sfa.sfa09 = 0 END IF
  IF cl_null(l_sfa.sfa10) THEN LET l_sfa.sfa10 = ' ' END IF
  IF cl_null(l_sfa.sfa14) THEN LET l_sfa.sfa14 = l_sfa.sfa12 END IF
  IF cl_null(l_sfa.sfa15) THEN LET l_sfa.sfa15 = l_sfa.sfa13 END IF
  IF cl_null(l_sfa.sfa25)  THEN LET l_sfa.sfa25 = 0  END IF
  IF cl_null(l_sfa.sfa26)  THEN LET l_sfa.sfa26 = 0  END IF
  IF cl_null(l_sfa.sfa27)  THEN LET l_sfa.sfa27 = l_sfa.sfa03  END IF
  IF cl_null(l_sfa.sfa28)  THEN LET l_sfa.sfa28 = 1  END IF
  IF cl_null(l_sfa.sfa08)  THEN LET l_sfa.sfa08 = ' '  END IF
  IF cl_null(l_sfa.sfa100)  THEN LET l_sfa.sfa100 = 0  END IF

  RETURN l_sfa.*

END FUNCTION

FUNCTION t803_z()
   IF s_shut(0) THEN RETURN END IF
   #未確認OR已發出
   SELECT * INTO g_snb.* FROM snb_file
    WHERE snb01=g_snb.snb01
      AND snb02=g_snb.snb02
   IF g_snb.snbconf = 'N' OR g_snb.snbconf = 'Y' THEN  RETURN END IF
   IF g_snb.snbconf = 'X'    THEN CALL cl_err('','9024',0) RETURN END IF
   IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0)   RETURN END IF
#  IF NOT cl_confirm('axm-109') THEN RETURN END IF     #MOD-B50239 mark

   BEGIN WORK

   LET g_success = 'Y'

   OPEN t803_cl USING g_snb.snb01,g_snb.snb02
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t803_cl INTO g_snb.*                        # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF

   #MOD-B50239 --- modify --- start ---
   IF NOT cl_confirm('axm-109') THEN
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
   END IF
   #MOD-B50239 --- modify --   end  ---

   UPDATE snb_file SET snbconf = 'N'
    WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","up snb_file",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT snbconf INTO g_snb.snbconf FROM snb_file
    WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
   DISPLAY BY NAME g_snb.snbconf
END FUNCTION

FUNCTION t803_memo()
   DEFINE p1		LIKE snb_file.snb01
   DEFINE p2		LIKE snb_file.snb02
   DEFINE i,j,n         LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_rec_b       LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_snc         DYNAMIC ARRAY OF RECORD
                        snc05        LIKE snc_file.snc05,
                        snc06        LIKE snc_file.snc06
                        END RECORD
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否        #No.FUN-680121 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT

   IF cl_null(g_snb.snb01) THEN RETURN END IF

   OPEN WINDOW asf_w_m WITH FORM "asf/42f/asft801m"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("asft801m")

   DECLARE asf_memo CURSOR FOR
           SELECT snc05,snc06 FROM snc_file
            WHERE snc01 = g_snb.snb01
              AND snc02 = g_snb.snb02
            ORDER BY snc05

   CALL l_snc.clear()

   LET i = 1
   LET l_rec_b = 0

   FOREACH asf_memo INTO l_snc[i].snc05,l_snc[i].snc06
      IF STATUS THEN CALL cl_err('foreach snc',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
   END FOREACH

   LET l_rec_b = i - 1

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY l_snc WITHOUT DEFAULTS FROM s_snc.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)

     BEFORE ROW
        LET i=ARR_CURR()

     AFTER DELETE
        LET n=ARR_COUNT()
        INITIALIZE l_snc[n+1].* TO NULL

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT

   CLOSE WINDOW asf_w_m

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   DELETE FROM snc_file
    WHERE snc01 = g_snb.snb01
      AND snc02 = g_snb.snb02
   FOR i = 1 TO l_snc.getLength()
       IF cl_null(l_snc[i].snc06) THEN CONTINUE FOR END IF
       INSERT INTO snc_file (snc01,snc02,snc03,snc08,snc12,snc05,snc06,sncplant,snclegal) #FUN-980008 add
                      VALUES(g_snb.snb01,g_snb.snb02,'','','',
                             l_snc[i].snc05,l_snc[i].snc06,g_plant,g_legal)  #FUN-980008 add
       IF STATUS THEN
        CALL cl_err3("ins","snc_file",g_snb.snb01,g_snb.snb02,STATUS,"","ins snc",1)   #No.FUN-660128
       END IF
   END FOR

END FUNCTION


#項次重排
#重排的優先序  1.取替代為同一組的排在一起  2.變異方式一樣的排在一起
FUNCTION t803_re_order()
 DEFINE l_sna04  LIKE sna_file.sna04
 DEFINE l_sna27b LIKE sna_file.sna27a
 DEFINE l_sna    RECORD LIKE sna_file.*
 DEFINE i        LIKE type_file.num5          #No.FUN-680121 SMALLINT

   DROP TABLE x;
   SELECT * FROM sna_file
    WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
     INTO TEMP x

   DECLARE sna27_cs CURSOR FOR
    SELECT sna04,sna27b FROM x
     WHERE (sna27a IS NULL OR sna27a = ' ')

   FOREACH sna27_cs INTO l_sna04,l_sna27b
      UPDATE x SET sna27a = l_sna27b               #方便后面排序用
       WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
         AND sna04 = l_sna04
   END FOREACH

   DELETE FROM sna_file
    WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02

   LET i = 1
   DECLARE order_cs CURSOR FOR
    SELECT * FROM x ORDER BY sna27a,sna26b

   FOREACH order_cs INTO l_sna.*
        IF cl_null(l_sna.sna03a) THEN LET l_sna.sna27a = '' END IF
        LET l_sna.sna04 = i
        LET l_sna.snaplant = g_plant #FUN-980008 add
        LET l_sna.snalegal = g_legal #FUN-980008 add
#TQC-A60120 --mark--
##FUN-A60070 --begin--
#        IF cl_null(l_sna.sna012a) THEN LET l_sna.sna012a = ' ' END IF
#        IF cl_null(l_sna.sna012b) THEN LET l_sna.sna012b = ' ' END IF
#        IF cl_null(l_sna.sna013a) THEN LET l_sna.sna013a = 0   END IF
#        IF cl_null(l_sna.sna013b) THEN LET l_sna.sna013b = 0   END IF
##FUN-A60070 --end--
##TQC-A60120 --mark--
#TQC-A60120 --begin--
         IF cl_null(l_sna.snaplant) THEN
            LET l_sna.snaplant = g_plant
         END IF
         IF cl_null(l_sna.snalegal) THEN
            LET l_sna.snalegal = g_legal
         END IF
#TQC-A60120 --end--
        INSERT INTO sna_file VALUES (l_sna.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err3("ins","sna_file",l_sna.sna01,l_sna.sna02,STATUS,"","order fail:",1)  #No.FUN-660128
           LET g_success ='N' EXIT FOREACH
        END IF
        LET i = i + 1
  END FOREACH

END FUNCTION

FUNCTION create_sub_temp()

DROP TABLE sub_temp;
CREATE TEMP TABLE sub_temp(
  new_part	 LIKE type_file.chr20,
  new_rate	 LIKE sna_file.sna28b,
  new_yes 	 LIKE type_file.chr1,
  new_qty 	 LIKE type_file.num10,
  new_qty3	 LIKE type_file.num10,
# ima262         LIKE ima_file.ima262,      #NO.FUN-A20044
  avl_stk        LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
  new_qty4	 LIKE type_file.num10,
  new_qty5	 LIKE type_file.num10,
  new_qty6	 LIKE type_file.num10,
  new_qty7	 LIKE type_file.num10,
  new_qty8	 LIKE type_file.num10);
END FUNCTION

FUNCTION t803_sub_chk(p_wo)
   DEFINE p_wo	        LIKE sfb_file.sfb01          #No.FUN-680121 VARCHAR(10) # TQC-6A0079
   DEFINE l_sfb08	LIKE sfb_file.sfb08          #No.FUN-680121 DEC(15,3)
   DEFINE l_bomqty	LIKE sfb_file.sfb08          #No.FUN-680121 DEC(15,3)
   DEFINE l_aloqty	LIKE sfb_file.sfb08          #No.FUN-680121 DEC(15,3)
   DEFINE l_difqty	LIKE sfb_file.sfb08          #No.FUN-680121 DEC(15,3)
   DEFINE chk           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE l_ze_sna27    LIKE ze_file.ze03
   DEFINE l_ze_bomqty   LIKE ze_file.ze03
   DEFINE l_ze_aloqty   LIKE ze_file.ze03
   DEFINE l_ze_difqty   LIKE ze_file.ze03
   DEFINE l_sna161      LIKE sna_file.sna161a
   DEFINE l_sna012      LIKE sna_file.sna012a  #FUN-A60070
   DEFINE l_sna013      LIKE sna_file.sna013b  #FUN-A60070
   DEFINE l_sna27       LIKE sna_file.sna27a
   DEFINE l_sna12       LIKE sna_file.sna12a
   DEFINE l_sna08       LIKE sna_file.sna08a
   DEFINE l_sna05       LIKE sna_file.sna05a
   DEFINE l_sna04       LIKE sna_file.sna04
   DEFINE l_sna28       LIKE sna_file.sna28a
   DEFINE t_sna05a      LIKE sna_file.sna05a
   DEFINE t_sna28a      LIKE sna_file.sna28a
   DEFINE l_sna		RECORD LIKE sna_file.*

   SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01=p_wo
   DECLARE t803_sub_chk_c CURSOR FOR
      SELECT * FROM sna_file
       WHERE sna01=g_snb.snb01  AND sna02 = g_snb.snb02
         AND (sna26a IN ('3','4','T') OR
              ((sna26a IS NULL OR sna26a = ' ') AND sna26b IN ('3','4','T')))

   FOREACH t803_sub_chk_c INTO l_sna.*
       LET l_aloqty = 0
       IF NOT cl_null(l_sna.sna27a) THEN
          LET l_sna27 = l_sna.sna27a
       ELSE
          LET l_sna27 = l_sna.sna27b
       END IF
#FUN-A60070 --begin--
       IF NOT cl_null(l_sna.sna012a) THEN
          LET l_sna012 = l_sna.sna012a
       ELSE
          LET l_sna012 = l_sna.sna012b
       END IF

       IF NOT cl_null(l_sna.sna013a) THEN
          LET l_sna013 = l_sna.sna013a
       ELSE
          LET l_sna013 = l_sna.sna013b
       END IF
#FUN-A60070 --end--
       IF NOT cl_null(l_sna.sna08a) THEN
          LET l_sna08 = l_sna.sna08a
       ELSE
          LET l_sna08 = l_sna.sna08b
       END IF
       IF NOT cl_null(l_sna.sna12a) THEN
          LET l_sna12 = l_sna.sna12a
       ELSE
          LET l_sna12 = l_sna.sna12b
       END IF
       DECLARE t803_sub_chk2_c CURSOR FOR
          SELECT '1',sna05a,sna28a,sna04 FROM sna_file
           WHERE sna01 = g_snb.snb01   AND sna02 = g_snb.snb02
             AND sna27a= l_sna27       AND sna08a= l_sna08
             AND sna12a= l_sna12
           UNION
          SELECT '2',sna05b,sna28b,sna04 FROM sna_file
           WHERE sna01 = g_snb.snb01   AND sna02 = g_snb.snb02
             AND sna27b= l_sna27       AND sna08b= l_sna08
             AND sna12b= l_sna12
        FOREACH t803_sub_chk2_c INTO chk,l_sna05,l_sna28,l_sna04
           IF chk='2' THEN
              SELECT sna05a,sna28a INTO t_sna05a,t_sna28a FROM sna_file
               WHERE sna01 = g_snb.snb01  AND sna02  = g_snb.snb02
                 AND sna04 = l_sna04
              IF NOT cl_null(t_sna05a) THEN LET l_sna05 = t_sna05a END IF
              IF NOT cl_null(t_sna28a) THEN LET l_sna28 = t_sna28a END IF
           END IF
           LET l_aloqty = l_aloqty + (l_sna05/l_sna28)
        END FOREACH
        IF l_aloqty IS NULL THEN LET l_aloqty = 0 END IF
        IF NOT cl_null(l_sna.sna161a) THEN
           LET l_sna161 = l_sna.sna161a
        ELSE
           LET l_sna161 = l_sna.sna161b
        END IF
        LET l_bomqty=l_sfb08*l_sna161
        LET l_difqty=l_bomqty-l_aloqty
        IF NOT cl_null(l_sna.sna27a) THEN
           LET l_sna27 = l_sna.sna27a
        ELSE
           LET l_sna27 =l_sna.sna27b
        END IF
        IF l_aloqty<>l_bomqty THEN
           SELECT ze03 INTO l_ze_sna27 FROM ze_file
             WHERE ze01 = 'asf-847' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_bomqty FROM ze_file
             WHERE ze01 = 'asf-848' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_aloqty FROM ze_file
             WHERE ze01 = 'asf-849' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_difqty FROM ze_file
             WHERE ze01 = 'asf-850' AND ze02 = g_lang
           PROMPT l_ze_sna27 CLIPPED,l_sna27,
                  l_ze_bomqty CLIPPED,l_bomqty,
                  l_ze_aloqty CLIPPED,l_aloqty,
                  l_ze_difqty CLIPPED,l_difqty,
                  ":" FOR CHAR g_chr
        END IF
   END FOREACH
END FUNCTION

FUNCTION t803_sizechk(p_item,p_qty,g_lang)
DEFINE
    p_item     LIKE ima_file.ima01,
    p_qty      LIKE pml_file.pml20,
    g_lang     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ima64    LIKE ima_file.ima64,
    l_ima641    LIKE ima_file.ima641,
    g_msg      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
    l_qty      LIKE ima_file.ima64,          #No.FUN-680121 DECIMAL(11,3)
    l_test     LIKE ima_file.ima64,          #No.FUN-680121 DECIMAL(11,3)
    l_no       LIKE type_file.num10          #No.FUN-680121 INTEGER

    WHENEVER ERROR CALL cl_err_msg_log
    LET g_chr = ' '
    SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
                  WHERE ima01 = p_item
    IF SQLCA.sqlcode!=0  THEN
       CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","cannot select ima_file",1)  #No.FUN-660128
    END IF
    IF l_ima64 IS NULL OR l_ima64 = ' ' OR l_ima641 IS NULL OR l_ima641 = ' '
      THEN  CALL cl_err(l_ima64,'mfg0045',1)
			RETURN p_qty
    END IF
    IF p_qty < l_ima641 THEN
       LET g_msg='(',l_ima641,')',':'
        IF cl_confirm2('mfg0047',g_msg) THEN  #MOD-4A0154
          LET l_qty = l_ima641
       ELSE
          LET l_qty = p_qty
       END IF
    ELSE
         IF l_ima64 = 0 THEN
              LET l_no = 0
         ELSE
           LET l_no = (p_qty*1000) MOD (l_ima64*1000)
         END IF
         IF l_no != 0 THEN
             LET l_no = p_qty / l_ima64
             LET l_qty = ( l_no + 1 ) * l_ima64
             LET g_msg='(',l_qty,')',':'
              IF NOT cl_confirm2('mfg0047',g_msg) THEN  #MOD-4A0154
                LET l_qty = p_qty
             END IF
         ELSE LET l_qty = p_qty
         END IF
    END IF
   RETURN l_qty
END FUNCTION


FUNCTION i802_short(p_sfb01)
  DEFINE p_sfb01 LIKE sfb_file.sfb01
  DEFINE l_gfe03        LIKE gfe_file.gfe03
  DEFINE qty1,qty2,l_issue_set LIKE sfa_file.sfa05  #No.FUN-680121 DEC(15,3)
  DEFINE l_sfa06 LIKE sfa_file.sfa06                #No.MOD-930054 add
  DEFINE l_sfa05 LIKE sfa_file.sfa05 #齊料數量
  DEFINE l_sql          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(500)
  DEFINE  l_ima64         LIKE ima_file.ima64,
          l_ima641        LIKE ima_file.ima641,
          l_sfaqty        LIKE sfa_file.sfa05,
          l_double        LIKE type_file.num10
  DEFINE  l_cnt           LIKE type_file.num5       #No.FUN-940008 add
  IF g_sma.sma129 ='N' THEN
     SELECT sfb081 INTO l_issue_set
                   FROM sfb_file
                  WHERE sfb01=p_sfb01
     IF l_issue_set IS NULL THEN
        LET l_issue_set = 0
     END IF
  ELSE

  MESSAGE 'short process ...'
  LET qty1 = 0
  LET qty2 = 0

#計算單身備料成套已發料總數量
    DECLARE i501_cs6 CURSOR FOR
     SELECT SUM(sfq03) FROM sfp_file,sfq_file
      WHERE sfp06 IN('1','D')       #FUN-C70014  add D
        AND sfp01=sfq01
        AND sfq02=p_sfb01
        AND sfp04='Y'
      GROUP BY sfq04
      ORDER BY 1 DESC
    FOREACH i501_cs6 INTO qty1
            IF STATUS THEN LET qty1=0 END IF
            EXIT FOREACH
    END FOREACH
#計算單身備料成套退料總數量
    DECLARE i501_cs7 CURSOR FOR
     SELECT SUM(sfq03) FROM sfp_file,sfq_file   #發料套數合計
      WHERE sfp06='6'           #6:成套退料
        AND sfp01=sfq01
        AND sfq02=p_sfb01
        AND sfp04='Y'
      GROUP BY sfq04
      ORDER BY 1 DESC
    FOREACH i501_cs7 INTO qty2
            IF STATUS THEN LET qty2=0 END IF
            EXIT FOREACH
    END FOREACH
    IF qty1 IS NULL THEN LET qty1=0 END IF
    IF qty2 IS NULL THEN LET qty2=0 END IF

    LET l_issue_set=qty1-qty2     #實際已發套數
  END IF   #No.FUN-940008 add
    LET l_sql="SELECT sfa_file.* FROM sfa_file ",
               " WHERE sfa01='",p_sfb01,"'",
               "   AND sfa05 >= 0 ",
               " ORDER BY sfa27,sfa26" #按工單來算欠料,且主料先算

    PREPARE i501_short_pre FROM l_sql
    DECLARE i501_short_c CURSOR FOR i501_short_pre
    LET l_cnt =0  #No.FUN-940008 add
    FOREACH i501_short_c INTO g_sfa.*
      IF STATUS THEN
         CALL s_errmsg('','','f sfa',STATUS,1)
         LET g_success='N' RETURN END IF

       CALL s_shortqty(g_sfa.sfa01,g_sfa.sfa03,g_sfa.sfa08,g_sfa.sfa12,g_sfa.sfa27,
                       g_sfa.sfa012,g_sfa.sfa013)       ##TQC-A60087 add
            RETURNING g_sfa.sfa07
       IF g_sfa.sfa07<0 THEN
          CALL s_errmsg('','','asf-094',STATUS,1)
          LET g_success='N'
       END IF
       LET l_cnt=l_cnt + 1
  END FOREACH

  IF l_cnt = 0 THEN
     CALL s_errmsg('','','f sfa',STATUS,1)
     LET g_success='N'
     RETURN
  END IF
END FUNCTION

#FUN-BB0085-mark--------------------start--------------------------------此FUNCTION在整支程式中沒有調用
#FUNCTION t803_sna05(p_sfa03,p_sfa08,p_sfa12,p_sfa27)   #No.FUN-870051
#  DEFINE l_sfa     RECORD LIKE sfa_file.*,
#         p_sfa03   LIKE sfa_file.sfa03,
#         p_sfa08   LIKE sfa_file.sfa08,
#         p_sfa12   LIKE sfa_file.sfa12,
#         p_sfa27   LIKE sfa_file.sfa27   #No.FUN-870051
#
##本函數用來計算主料的已被替代量
#
#  IF cl_null(p_sfa03) THEN RETURN END IF
#  LET g_errno = ''
#  SELECT SUM(sfa05*sfa28) INTO l_sfa.* FROM sfa_file
#   WHERE sfa01 = g_snb.snb01
#     AND sfa27 = p_sfa03
#     AND sfa08 = p_sfa08
#     AND sfa12 = p_sfa12
#     AND sfa27 = p_sfa27    #No.FUN-870051
#     AND sfa26 IN ('S','U','Z')  #FUN-A20037 add Z
#     AND sfa012 = p_sfa012   #FUN-A60070
#     AND sfa013 = p_sfa013   #FUN-A60070
#
#  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
#                                 INITIALIZE l_sfa.* TO NULL
#       WHEN l_sfa.sfaacti='N'    LET g_errno = '9028'
#       WHEN l_sfa.sfaacti='X'    LET g_errno = '9024'
#       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
#  END CASE
#
#  IF cl_null(g_errno) THEN
#        LET g_sfa29[l_ac]      = l_sfa.sfa29
#        LET g_sna[l_ac].sna03b = l_sfa.sfa03
#        LET g_sna[l_ac].ima02b = t803_sna03('',g_sna[l_ac].sna03b)
#        LET g_sna[l_ac].sna08b = l_sfa.sfa08
#        LET g_sna[l_ac].sna11b = l_sfa.sfa11
#        LET g_sna[l_ac].sna12b = l_sfa.sfa12
#        LET g_sna[l_ac].sna13b = l_sfa.sfa13
#        LET g_sna[l_ac].sna28b = l_sfa.sfa28
#        LET g_sna[l_ac].sna161b= l_sfa.sfa161
#        LET g_sna[l_ac].sna26b= l_sfa.sfa26   #FUN-990059
#        LET g_sna[l_ac].sna05b = l_sfa.sfa05
#  END IF
#END FUNCTION
#FUN-BB0085-mark----------------------end----------------------------------

FUNCTION t803_tmp_move()
    LET b_sna.sna01    = g_snb.snb01
    LET b_sna.sna02    = g_snb.snb02
    LET b_sna.sna022   = g_snb.snb022
    LET b_sna.sna04    = g_sna[l_ac].sna04
    LET b_sna.sna03b   = g_sna[l_ac].sna03b
    LET b_sna.sna08b   = g_sna[l_ac].sna08b
    LET b_sna.sna11b   = g_sna[l_ac].sna11b
    LET b_sna.sna12b   = g_sna[l_ac].sna12b
    LET b_sna.sna13b   = g_sna[l_ac].sna13b
    LET b_sna.sna28b   = g_sna[l_ac].sna28b
    LET b_sna.sna161b  = g_sna[l_ac].sna161b
    LET b_sna.sna26b   = g_sna[l_ac].sna26b   #FUN-990059
    LET b_sna.sna05b   = g_sna[l_ac].sna05b
    LET b_sna.sna065b  = g_sna[l_ac].sna065b  #FUN-C10045
#FUN-A60070 --begin--
    LET b_sna.sna012b  = g_sna[l_ac].sna012b
    LET b_sna.sna013b  = g_sna[l_ac].sna013b
    LET b_sna.sna012a  = g_sna[l_ac].sna012a
    LET b_sna.sna013a  = g_sna[l_ac].sna013a
#FUN-A60070 --end--
    LET b_sna.sna03a   = g_sna[l_ac].sna03a
    LET b_sna.sna08a   = g_sna[l_ac].sna08a
    LET b_sna.sna11a   = g_sna[l_ac].sna11a
    LET b_sna.sna12a   = g_sna[l_ac].sna12a
    LET b_sna.sna13a   = g_sna[l_ac].sna13a
    LET b_sna.sna26a  = g_sna[l_ac].sna26a    #FUN-990059
    LET b_sna.sna28a   = g_sna[l_ac].sna28a
    LET b_sna.sna161a  = g_sna[l_ac].sna161a
    LET b_sna.sna05a   = g_sna[l_ac].sna05a
    LET b_sna.sna065a   = g_sna[l_ac].sna065a #FUN-C10045
    LET b_sna.sna50    = g_sna[l_ac].sna50
    LET b_sna.sna29a    = g_sna[l_ac].sna29a #FUN-B20056
    LET b_sna.sna29b    = g_sna[l_ac].sna29b #FUN-B20056

END FUNCTION

FUNCTION t803_pop_sna04()
   DEFINE l_cnt LIKE type_file.num10
   DEFINE l_sna03b LIKE sna_file.sna03b
   DEFINE l_sna08b LIKE sna_file.sna08b
   DEFINE l_sna12b LIKE sna_file.sna12b
   DEFINE l_sna27b LIKE sna_file.sna27b    #No.FUN-870051
   DEFINE li_where STRING                  #No.FUN-940008 add
   DEFINE l_sfa01  LIKE sfa_file.sfa01     #No.MOD-980140
   DEFINE l_sna012b LIKE sna_file.sna012b   #FUN-A60070
   DEFINE l_sna013b LIKE sna_file.sna013b   #FUN-A60070
   DEFINE l_sfa29   LIKE sfa_file.sfa29     #FUN-B20056
   DEFINE l_sfa26   LIKE sfa_file.sfa26     #FUN-C70015

   LET l_sna03b = g_sna[l_ac].sna03b
   LET l_sna08b = g_sna[l_ac].sna08b
   LET l_sna12b = g_sna[l_ac].sna12b
   LET l_sna012b=g_sna[l_ac].sna012b  #FUN-A60070
   LET l_sna013b=g_sna[l_ac].sna013b  #FUN-A60070

   LET li_where = " AND sfa01 = '",g_snb.snb01,"'"
                 #" AND (sfa11 <> 'S' )"               #FUN-9C0040      #CHI-BA0015 mark
#FUN-D60056 --------------Begin-------------
   CALL short_qty2(1,TRUE,g_sna[l_ac].sna04,g_sna[l_ac].sna03b,li_where,'4')
        RETURNING g_multi_sna03b,g_multi_sna08b,g_multi_sna27b
   IF NOT cl_null(g_multi_sna03b) THEN
      CALL t803_multi_sna03b()
      CALL t803_b_fill(' 1=1')         #單身
      CALL t803_bp_refresh()
      CALL t803_b()
   END IF
#FUN-D60056 --------------End---------------
#FUN-D60056 ------Begin-----Mark------
#  CALL q_short_qty(FALSE,TRUE,g_sna[l_ac].sna04,g_sna[l_ac].sna03b,li_where,'4')
#       RETURNING l_sfa01,    g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,  #No.MOD-980140
#                 g_sna[l_ac].sna12b,l_sna27b
#                ,g_sna[l_ac].sna012b,g_sna[l_ac].sna013b   #FUN-A60070 add

#  LET g_sna27b = l_sna27b    #TQC-C20403 add

#  #FUN-B20056 --START--
#  IF NOT cl_null(l_sfa01) AND NOT cl_null(g_sna[l_ac].sna03b) THEN
#     IF cl_null(g_sna[l_ac].sna08b) THEN LET g_sna[l_ac].sna08b = ' ' END IF
#     IF cl_null(g_sna[l_ac].sna012b) THEN LET g_sna[l_ac].sna012b = ' ' END IF
#     LET l_sfa29 = ''
#     LET l_sfa26 = ''  ##FUN-C70015
#     #SELECT sfa29 INTO l_sfa29 FROM sfa_file  #FUN-C70015
#     SELECT sfa29,sfa26 INTO l_sfa29,l_sfa26 FROM sfa_file  #FUN-C70015
#      WHERE sfa01 = l_sfa01 AND sfa03 = g_sna[l_ac].sna03b
#       AND sfa08 = g_sna[l_ac].sna08b AND sfa12 = g_sna[l_ac].sna12b
#       AND sfa27 = l_sna27b AND sfa012 = g_sna[l_ac].sna012b
#       AND sfa013 = g_sna[l_ac].sna013b
#     #FUN-C70015---begin
#     IF l_sfa26 = 'U' OR l_sfa26 = 'S' OR l_sfa26 = 'T' OR l_sfa26 = 'Z' THEN
#        CALL cl_err('','asf-279',1)
#        LET g_sna[l_ac].sna03b = l_sna03b
#        LET g_sna[l_ac].sna08b = l_sna08b
#        LET g_sna[l_ac].sna12b = l_sna12b
#        LET g_sna[l_ac].sna012b= l_sna012b
#        LET g_sna[l_ac].sna013b= l_sna013b
#        RETURN
#     ELSE
#     #FUN-C70015---end
#        IF NOT cl_null(l_sfa29) THEN
#           LET g_sna[l_ac].sna29b = l_sfa29
#        END IF
#     END IF #FUN-C70015
#  #ELSE     #FUN-C70015
#
#  END IF
#  #FUN-B20056 --END--
#  IF g_sna[l_ac].sna08b IS NULL THEN
#    LET g_sna[l_ac].sna08b = ' '
#  END IF
#  IF cl_null(g_sna[l_ac].sna03b) THEN #開窗按取消
#     RETURN
#  END IF

#FUN-A60070 --begin--
# IF cl_null(g_sna[l_ac].sna012b) THEN
#    LET g_sna[l_ac].sna012b = ' '
# END IF
# IF cl_null(g_sna[l_ac].sna013b) THEN
#    LET g_sna[l_ac].sna013b = 0
# END IF
#FUN-A60070 --end--

#  #變更前料號不可重複
#  SELECT COUNT(*) INTO l_cnt FROM sna_file
#                            WHERE sna01=g_snb.snb01
#                              AND sna02=g_snb.snb02
#                              AND sna03b=g_sna[l_ac].sna03b
#                              AND sna08b=g_sna[l_ac].sna08b        #MOD-B20064 add
#  IF l_cnt>0 THEN
#     CALL cl_err('','asf-090',1)
#     LET g_sna[l_ac].sna03b = l_sna03b
#     LET g_sna[l_ac].sna08b = l_sna08b
#     LET g_sna[l_ac].sna12b = l_sna12b
#     LET g_sna[l_ac].sna012b= l_sna012b   #FUN-A60070
#     LET g_sna[l_ac].sna013b= l_sna013b   #FUN-A60070
#  END IF
#FUN-D60056 --------End----Mark------
  #TQC-C20403 str mark-----
  #SELECT sna27b INTO l_sna27b FROM sna_file
  # WHERE sna01 = g_snb.snb01
  #   AND sna02 = g_snb.snb02
  #   AND sna04 = g_sna[l_ac].sna04
  #SELECT sfa27  INTO l_sna27b FROM sfa_file
  # WHERE sfa01 = g_snb.snb01
  #   AND sfa03 = g_sna[l_ac].sna03b
  #   AND sfa08 = g_sna[l_ac].sna08b
  #   AND sfa12 = g_sna[l_ac].sna12b
  #   AND sfa012= g_sna[l_ac].sna012b   #FUN-A60070
  #   AND sfa013= g_sna[l_ac].sna013b   #FUN-A60070
  #TQC-C20403 end mark-----
#FUN-D60056 ------Begin----Mark-------
#  IF cl_null(l_sna27b) THEN
#     LET l_sna27b=g_sna[l_ac].sna03b
#  END IF
#  CALL t803_sna27(g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
#                  g_sna[l_ac].sna12b,l_sna27b,g_sna[l_ac].sna012b,g_sna[l_ac].sna013b)    #No.FUN-870051
#                               #FUN-A60070 add sna012b,sna013b
#  IF NOT cl_null(g_errno) THEN
#     CALL cl_err('',g_errno,1)
#  END IF
#FUN-D60056 ------End-------Mark------
END FUNCTION

#FUN-D60056 ------------Begin--------------
FUNCTION t803_multi_sna03b()
DEFINE   tok         base.StringTokenizer
DEFINE   tok1         base.StringTokenizer
DEFINE   tok2         base.StringTokenizer #darcy:2022/06/15 
DEFINE   l_sql       STRING
DEFINE   i           LIKE type_file.num10
DEFINE   l_plant     LIKE azw_file.azw01
DEFINE   l_cnt       LIKE type_file.num5
DEFINE   l_sna       RECORD LIKE sna_file.*
DEFINE   l_sfa26     LIKE sfa_file.sfa26
DEFINE   l_sfa29     LIKE sfa_file.sfa29
   LET l_plant = g_plant
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_sna03b,"|")
   LET tok1 = base.StringTokenizer.create(g_multi_sna08b,"|")
   LET tok2 = base.StringTokenizer.create(g_multi_sna27b,"|")
   LET i=1

   WHILE tok.hasMoreTokens()
      LET l_sna.sna01 = g_snb.snb01
      LET l_sna.sna02 = g_snb.snb02
      LET l_sna.sna03b = tok.nextToken()
      LET l_sna.sna08b = tok1.nextToken()
      LET l_sna.sna27b = tok2.nextToken() #darcy:2022/06/15 
      LET l_sql="SELECT max(sna04)+1 FROM ",cl_get_target_table(l_plant,'sna_file'),
                " WHERE sna01 = '",l_sna.sna01,"'",
                "   AND sna02 = '",l_sna.sna02,"'"

      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE sel_sna_pre FROM l_sql
      EXECUTE sel_sna_pre INTO l_sna.sna04
      IF cl_null(l_sna.sna04) THEN
         LET l_sna.sna04 = 1
      END IF
      LET l_sql = "SELECT sfa08,sfa12,sfa27,sfa012,sfa013",
                "  FROM sfb_file,sfa_file",
                " WHERE sfa01 = sfb01 ",
                "   AND sfa01 = '",g_snb.snb01,"'",
                "   AND sfa03 = '",l_sna.sna03b,"'",
                "   AND sfa08 = '",l_sna.sna08b,"'",
                "   AND sfa27 = '",l_sna.sna27b,"'",#darcy:2022/06/15
                " ORDER BY sfb01 "
   PREPARE t803_presna03b FROM l_sql
   EXECUTE t803_presna03b INTO l_sna.sna08b,l_sna.sna12b,l_sna.sna27b,l_sna.sna012b,l_sna.sna013b
   IF NOT cl_null(l_sna.sna01) AND NOT cl_null(l_sna.sna03b) THEN
      IF cl_null(l_sna.sna08b) THEN LET l_sna.sna08b = ' ' END IF
      IF cl_null(l_sna.sna012b) THEN LET l_sna.sna012b = ' ' END IF
      LET l_sfa29 = ''
      LET l_sfa26 = ''
      SELECT sfa29,sfa26 INTO l_sfa29,l_sfa26 FROM sfa_file
       WHERE sfa01 = l_sna.sna01 AND sfa03 = l_sna.sna03b
        AND sfa08 = l_sna.sna08b AND sfa12 = l_sna.sna12b
        AND sfa27 = l_sna.sna27b AND sfa012 = l_sna.sna012b
        AND sfa013 = l_sna.sna013b

      IF l_sfa26 = 'U' OR l_sfa26 = 'S' OR l_sfa26 = 'T' OR l_sfa26 = 'Z' THEN
         CALL s_errmsg('sfa26',l_sfa26,'INS sna_file','asf-279',1)
         CONTINUE WHILE
      ELSE

         IF NOT cl_null(l_sfa29) THEN
            LET l_sna.sna29b = l_sfa29
         END IF
      END IF


   END IF

   IF l_sna.sna08b IS NULL THEN
     LET l_sna.sna08b = ' '
   END IF
   IF cl_null(l_sna.sna03b) THEN
   #  RETURN
      CONTINUE WHILE
   END IF


   IF cl_null(l_sna.sna012b) THEN
     LET l_sna.sna012b = ' '
   END IF
   IF cl_null(l_sna.sna013b) THEN
      LET l_sna.sna013b = 0
   END IF


  SELECT COUNT(*) INTO l_cnt FROM sna_file
                            WHERE sna01=g_snb.snb01
                              AND sna02=g_snb.snb02
                              AND sna03b=l_sna.sna03b
                              AND sna08b=l_sna.sna08b
   IF l_cnt>0 THEN
      CALL s_errmsg('sna01',l_sfa26,'INS sna_file','asf-090',1)
      CONTINUE WHILE
   END IF
   IF cl_null(l_sna.sna27b) THEN
      LET l_sna.sna27b=l_sna.sna03b
   END IF
   CALL t803_sna27(l_sna.*) RETURNING l_sna.*

   IF NOT cl_null(g_errno) THEN
      CALL s_errmsg('sna01',l_sfa26,'INS sna_file',g_errno,1)
      CONTINUE WHILE
   END IF
   LET l_sna.snalegal = g_legal
   LET l_sna.snaplant = g_plant
   INSERT INTO sna_file VALUES (l_sna.*)
   LET i = i+1
   END WHILE
   CALL s_showmsg()
END FUNCTION
#FUN-D60056 ------------End----------------

FUNCTION t803_chk_bom(p_item) #copy from asfi301 check sfa27
   DEFINE p_item    LIKE sfa_file.sfa27
   DEFINE l_bmb     RECORD LIKE bmb_file.*
   DEFINE g_brb     RECORD LIKE brb_file.*   #FUN-A60070
   DEFINE l_bmb16   LIKE bmb_file.bmb16      #FUN-A60070
   DEFINE l_res LIKE type_file.num5
   DEFINE l_cnt LIKE type_file.num10

   LET l_res=TRUE

   INITIALIZE l_bmb.* TO NULL
#FUN-A60070 --begin--
IF g_sma.sma542 = 'Y'  AND g_sfb.sfb93 = 'Y' THEN
    DECLARE t803_brb_c CURSOR FOR
    SELECT brb01,brb02,brb03,brb04,brb05,brb06,brb07,brb08,brb09,brb10,
           brb10_fac,brb10_fac2,brb11,brb13,brb14,brb15,brb16,brb17,brb18,
           brb19,brb20,brb21,brb22,brb23,brb24,brb25,brb26,brb27,brb28,
           brbmodu,brbdate,brbcomm,brb29,brb30,brb31,brb33,'','','','',
           '','','','','','','','','','','',brb081,brb082
     FROM brb_file
    WHERE brb01=g_sfb.sfb05
      AND brb29=g_sfb.sfb95
      AND brb03=p_item
      AND brb011=g_sfb.sfb06
      AND brb012=g_sna[l_ac].sna012a
      AND brb013=g_sna[l_ac].sna013a
      AND (brb04<=g_sfb.sfb071 OR brb04 IS NULL)
      AND (g_sfb.sfb071<brb05 OR brb05 IS NULL)

     FOREACH t803_brb_c INTO l_bmb.*
        IF STATUS THEN
           CALL cl_err('for brb:',STATUS,1)
           EXIT FOREACH
        END IF
        EXIT FOREACH
     END FOREACH

     DECLARE t803_bmb16_c CURSOR FOR
      SELECT bmb16 FROM bmb_file
       WHERE bmb01=g_sfb.sfb05
         AND bmb29=g_sfb.sfb95
         AND bmb03=p_item
         AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
         AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)

      FOREACH t803_bmb16_c INTO l_bmb.bmb16
         IF STATUS THEN
            CALL cl_err('sel bmb16:',STATUS,1)
            EXIT FOREACH
         END IF
         LET l_bmb16 = l_bmb.bmb16
         EXIT FOREACH
      END FOREACH
ELSE
#FUN-A60070 --end--
   DECLARE t803_bmb_c CURSOR FOR
      SELECT * FROM bmb_file
          WHERE bmb01=g_sfb.sfb05
            AND bmb29=g_sfb.sfb95
            AND bmb03=p_item
            AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
            AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)

   FOREACH t803_bmb_c INTO l_bmb.*
      IF STATUS THEN
         CALL cl_err('for bmb:',STATUS,1)
         EXIT FOREACH
      END IF
      EXIT FOREACH  # 僅讀取第一筆
   END FOREACH

END IF   #FUN-A60070

   #檢查是否存在BOM中
   IF (cl_null(l_bmb.bmb03)) AND (g_sfb.sfb02 NOT MATCHES '[58]') THEN
      IF g_sfb.sfb02=15 THEN
         CALL s_ebomchk(g_sfb.sfb05,p_item,g_sfb.sfb07)
            RETURNING l_bmb.*,g_errno
      ELSE
  #FUN-A60070--begin--
        IF g_sma.sma542 = 'Y' AND g_sfb.sfb93 = 'Y' THEN
           CALL s_check_muti_bom_brb(g_sfb.sfb05,p_item,g_sfb.sfb071,
                                          g_sfb.sfb95,g_sfb.sfb06,g_sna[l_ac].sna012a,g_sna[l_ac].sna013a)
           RETURNING g_brb.*,g_errno
            LET l_bmb.bmb01 = g_brb.brb01  LET l_bmb.bmb03=g_brb.brb03
            LET l_bmb.bmb06 = g_brb.brb06  LET l_bmb.bmb07=g_brb.brb07
            LET l_bmb.bmb08 = g_brb.brb08  LET l_bmb.bmb10=g_brb.brb10
            LET l_bmb.bmb10_fac = g_brb.brb10_fac  LET l_bmb.bmb15 = g_brb.brb15
            LET l_bmb.bmb28 = g_brb.brb28  LET l_bmb.bmb16 = l_bmb16
         ELSE
 #FUN-A60070--end--
            CALL i301_bom_check(g_sfb.sfb05,p_item,
                             g_sfb.sfb071)
              RETURNING l_bmb.*,g_errno
         END IF   #FUN-A60070
      END IF
   ELSE
      LET g_errno = ''
   END IF

   LET l_cnt=0
   IF g_sfb.sfb22 IS NOT NULL THEN
      SELECT COUNT(*) INTO l_cnt FROM oeo_file
        WHERE oeo01=g_sfb.sfb22 AND oeo03=g_sfb.sfb221
          AND oeo04=p_item
          AND oeo08='1'
   END IF
   IF g_sfb.sfb02<>5 AND g_sfb.sfb02<>11 AND g_sfb.sfb02<>8
      AND l_bmb.bmb01 IS NULL AND l_cnt=0 THEN
      IF g_sma.sma887[1]='Y' THEN
         CALL cl_err('sel bmb:','mfg2631',1)
         LET l_res=FALSE
      END IF
      IF g_sma.sma887[1]='W' THEN
         IF NOT cl_confirm('mfg2632') THEN
            LET l_res=FALSE
         END IF
      END IF
   END IF
   RETURN l_res
END FUNCTION

#RETURN FALSE -> 有超領的清況發生
FUNCTION t803_chk_short(p_sfb01)
  DEFINE p_sfb01 LIKE sfb_file.sfb01
  DEFINE l_gfe03        LIKE gfe_file.gfe03
  DEFINE qty1,qty2,l_issue_set LIKE sfa_file.sfa05  #No.FUN-680121 DEC(15,3)
  DEFINE l_sfa05 LIKE sfa_file.sfa05 #齊料數量
  DEFINE l_sql          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(500)
  DEFINE l_sfa161       LIKE sfa_file.sfa161
  DEFINE l_sna27b       LIKE sna_file.sna27b    #No.FUN-870051

  IF g_sma.sma129 ='N' THEN
     SELECT sfb081 INTO l_issue_set
                   FROM sfb_file
                  WHERE sfb01=p_sfb01
     IF l_issue_set IS NULL THEN
        LET l_issue_set = 0
     END IF
  ELSE
     LET qty1 = 0
     LET qty2 = 0

#計算單身備料成套已發料總數量
    DECLARE i501_cs8 CURSOR FOR
     SELECT SUM(sfq03) FROM sfp_file,sfq_file
      WHERE sfp06 IN('1','D')    #FUN-C70014 add D
        AND sfp01=sfq01
        AND sfq02=p_sfb01
        AND sfp04='Y'
      GROUP BY sfq04
      ORDER BY 1 DESC
    FOREACH i501_cs8 INTO qty1
            IF STATUS THEN LET qty1=0 END IF
            EXIT FOREACH
    END FOREACH
#計算單身備料成套退料總數量
    DECLARE i501_cs9 CURSOR FOR
     SELECT SUM(sfq03) FROM sfp_file,sfq_file   #發料套數合計
      WHERE sfp06='6'           #6:成套退料
        AND sfp01=sfq01
        AND sfq02=p_sfb01
        AND sfp04='Y'
      GROUP BY sfq04
      ORDER BY 1 DESC
    FOREACH i501_cs9 INTO qty2
            IF STATUS THEN LET qty2=0 END IF
            EXIT FOREACH
    END FOREACH
    IF qty1 IS NULL THEN LET qty1=0 END IF
    IF qty2 IS NULL THEN LET qty2=0 END IF

    LET l_issue_set=qty1-qty2     #實際已發套數
  END IF  #No.FUN-940008 add

    SELECT sna27b INTO l_sna27b FROM sna_file
     WHERE sna01 = g_snb.snb01
       AND sna02 = g_snb.snb02
       AND sna04 = g_sna[l_ac].sna04
    LET l_sql="SELECT sfa_file.* FROM sfa_file ",
               " WHERE sfa01='",p_sfb01,"'",
               "   AND sfa05 >= 0 ",
               "   AND sfa03='",g_sna[l_ac].sna03b,"'",
               "   AND sfa08='",g_sna[l_ac].sna08b,"'",
               "   AND sfa12='",g_sna[l_ac].sna12b,"'",
               "   AND sfa27='",l_sna27b,"'",   #No.FUN-870051
               "   AND sfa012='",g_sna[l_ac].sna012b,"'",  #FUN-A60070
               "   AND sfa013='",g_sna[l_ac].sna013b,"'",  #FUN-A60070
               " ORDER BY sfa27,sfa26" #按工單來算欠料,且主料先算

    PREPARE i501_short_pre2 FROM l_sql
    DECLARE i501_short_c2 CURSOR FOR i501_short_pre2

    FOREACH i501_short_c2 INTO g_sfa.*
      IF STATUS THEN CALL cl_err('f sfa',STATUS,1)LET g_success='N' RETURN END IF
      IF cl_null(g_sna[l_ac].sna161a) THEN
         LET l_sfa161=g_sna[l_ac].sna161b
      ELSE
         LET l_sfa161=g_sna[l_ac].sna161a
      END IF
      IF cl_null(g_sna[l_ac].sna05a) THEN
         LET g_sfa.sfa05=g_sna[l_ac].sna05b
      ELSE
         LET g_sfa.sfa05=g_sna[l_ac].sna05a
      END IF
      #FUN-C10045---begin
      IF cl_null(g_sna[l_ac].sna065a) THEN
         LET g_sfa.sfa065=g_sna[l_ac].sna065b
      ELSE
         LET g_sfa.sfa065=g_sna[l_ac].sna065a
      END IF
      #FUN-C10045---end
      #此處的變更尚未更新到sfa_file,故需做特別處理,改以變更後的sfa161做欠料量計算
      CALL s_shortqty_asft803_open(g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
                                   g_sna[l_ac].sna12b,g_sfa.sfa05, l_sfa161)
      CALL s_shortqty(p_sfb01,g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
                      g_sna[l_ac].sna12b,l_sna27b,
                      g_sna[l_ac].sna012b,g_sna[l_ac].sna013b   #TQC-A60087 add
                      ) RETURNING g_sfa.sfa07
      CALL s_shortqty_asft803_close()  #open後必須close,這樣才能將sub的模組變數設為FALSE

      IF g_sfa.sfa07<0 THEN
         CALL cl_err('','asf-094',1)
         RETURN FALSE
      END IF
    END FOREACH
    RETURN TRUE
END FUNCTION

FUNCTION t803_u()
    DEFINE l_no   LIKE type_file.num5     #MOD-A30186 add

    IF g_snb.snb01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_snb.* FROM snb_file
     WHERE snb01=g_snb.snb01
       AND snb02=g_snb.snb02

    IF g_snb.snbconf = 'Y' THEN
     # CALL cl_err('','asf-592',0)  #CHI-960054     #TQC-AB0395
       CALL cl_err('','axr-101',0)  #TQC-AB0395
       RETURN
    END IF

   #MOD-C50079---S---
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
   #MOD-C50079---E---

   #送簽中單據不可修改
     IF g_snb.snb99 = 'S' THEN
        CALL cl_err('','apm-030',0)
        RETURN
     END IF

   #MESSAGE ""                   #FUN-A10013 mark
    CALL cl_msg("")              #FUN-A10013 add

    CALL cl_opmsg('u')
    LET g_snb01_t = g_snb.snb01
    LET g_snb02_t = g_snb.snb02
    BEGIN WORK

    OPEN t803_cl USING g_snb01_t,g_snb02_t
    IF STATUS THEN
       CALL cl_err("OPEN t803_cl:", STATUS, 1)
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t803_cl INTO g_snb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb01_t,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_snb.snbmodu=g_user                  #修改者
    LET g_snb.snbdate = g_today               #修改日期
    CALL t803_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t803_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_snb.*=g_snb_t.*
            CALL t803_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_snb.snb99 = '0'                     #簽核狀態回復為〝0:開立〞#FUN-920208
        UPDATE snb_file SET snb_file.* = g_snb.*    # 更新DB
            WHERE snb01 = g_snb.snb01 AND snb02 = g_snb.snb02   #FUN-920208 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
       #str MOD-A30186 add
       #判斷snb08a欄位是否有改變,若有改變
       #(1)單身筆數為0時自動產生單身
       #(2)單身已有資料詢問是否重新產生,選是則刪除舊資料後重新產生
        IF NOT cl_null(g_snb.snb08a) AND
           (g_snb_t.snb08a IS NULL OR g_snb_t.snb08a<>g_snb.snb08a) THEN
           LET l_no = 0
           SELECT COUNT(*) INTO l_no FROM sna_file
            WHERE sna01=g_snb.snb01 AND sna02=g_snb.snb02
           IF cl_null(l_no) THEN LET l_no=0 END IF
           CASE
              WHEN l_no=0
                 CALL t803_g_b()   #自動產生單身
              WHEN l_no>0
                 IF cl_confirm('asf-919') THEN
                    DELETE FROM sna_file
                     WHERE sna01=g_snb.snb01 AND sna02=g_snb.snb02
                    CALL t803_g_b()   #自動產生單身
                 END IF
           END CASE
        END IF
       #end MOD-A30186 add
        EXIT WHILE
    END WHILE
    CALL t803_show()               #FUN-920208 add
    DISPLAY BY NAME g_snb.snb99    #FUN-920208 add
    CLOSE t803_cl
    COMMIT WORK
END FUNCTION

FUNCTION t803_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)

     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("snb01,snb02",TRUE)   #No:MOD-A10184 modify
     END IF

END FUNCTION

FUNCTION t803_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE   l_cnt     LIKE type_file.num5   #CHI-B10025

    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("snb01,snb02",FALSE)    #No:MOD-A10184 modify
    END IF
    #-----CHI-B10025---------
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
      WHERE pmm01 = pmn01
        AND pmm18 = 'Y'
        AND pmn41 = g_snb.snb01
        AND pmn20 > 0
    #-----END CHI-B10025-----
    #IF g_sfb.sfb02 MATCHES '[7,8]' THEN   #CHI-B10025
    IF g_sfb.sfb02 MATCHES '[7,8]' AND l_cnt > 0 THEN   #CHI-B10025
       CALL cl_set_comp_entry("snb82a",FALSE)
    ELSE
       CALL cl_set_comp_entry("snb82a",TRUE)
    END IF
END FUNCTION
FUNCTION t803_set_entry_b(p_cmd)
   DEFINE    p_cmd  LIKE type_file.chr1

    IF g_sfa.sfa26 MATCHES '[SUTsutZz]' THEN   #FUN-A20037 add Zz
       CALL cl_set_comp_entry("sna28a",TRUE)
    END IF
    CALL cl_set_comp_entry("sna12a",TRUE)  #No:MOD-A90168 add
    CALL cl_set_comp_entry("sna29a",TRUE)  #FUN-B20056

END FUNCTION

FUNCTION t803_set_no_entry_b(p_cmd)
   DEFINE    p_cmd  LIKE type_file.chr1

    IF g_sfa.sfa26 NOT MATCHES '[SUTsutZz]' THEN   #FUN-A20037 add Zz
       CALL cl_set_comp_entry("sna28a",FALSE)
    END IF
   #----------------No:MOD-A90168 add
    IF g_sfa.sfa06 <> 0 THEN
       CALL cl_set_comp_entry("sna12a",FALSE)
    END IF
   #----------------No:MOD-A90168 end

   #FUN-B20056 --START--
    IF NOT cl_null(g_sna[l_ac].sna03b) THEN
       CALL cl_set_comp_entry("sna29a",FALSE)
    END IF
    #FUN-B20056 --END--

END FUNCTION

#FUN-960104 MARK --STR--------------------------------------------------
##平行加工變更維護
#FUNCTION t803_change_aps_pro()

#   IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0) RETURN END IF
#   IF cl_null(g_sfb.sfb24) OR g_sfb.sfb24 = 'N' THEN
#        #製程追縱資料尚未產生.
#        CALL cl_err(g_snb.snb01,'mfg5074',1)
#        RETURN
#   END IF
#   LET g_cmd = "apst900 '",g_snb.snb01,"' ",g_snb.snb02," ",g_sma.sma917
#   CALL cl_cmdrun_wait(g_cmd)

#END FUNCTION

##平行加工變更發出
#FUNCTION t803_change_aps_pro_g()
#  DEFINE l_cnt     LIKE type_file.num5
#  DEFINE l_ecm     RECORD LIKE ecm_file.*
#  DEFINE l_vlk     RECORD LIKE vlk_file.*
#  DEFINE l_vlj     RECORD LIKE vlj_file.*
#  DEFINE l_vne     RECORD LIKE vne_file.* #TQC-8A0013 add
#  DEFINE l_upd_aps LIKE type_file.num5
#  DEFINE l_vlj06   LIKE vlj_file.vlj06

#   DECLARE t803_vlk CURSOR FOR
#    SELECT * FROM vlk_file
#     WHERE vlk01 = g_snb.snb01  #工單編號
#       AND vlk02 = g_snb.snb02  #變更序號
#       AND vlk04 = g_sma.sma917 #資源型態

#   LET l_upd_aps = TRUE
#   INITIALIZE l_vlk.* TO NULL
#   FOREACH t803_vlk INTO l_vlk.*
#     IF STATUS THEN
#         CALL cl_err('foreach t803_vlk:',SQLCA.sqlcode,1)
#         LET l_upd_aps = FALSE
#     END IF
#     INITIALIZE l_ecm.* TO NULL
#     SELECT * INTO l_ecm.*
#       FROM ecm_file
#      WHERE ecm01 = l_vlk.vlk01  #工單編號
#        AND ecm03 = l_vlk.vlk03  #製程序號
#     IF l_vlk.vlk07 = '1' THEN #新增
#           IF l_vlk.vlk05 = 1 THEN
#               #==>INSERT vlj_file項次0的資料
#               SELECT COUNT(*) INTO l_cnt
#                 FROM vlj_file
#                WHERE vlj01 = l_vlk.vlk01
#                  AND vlj02 = l_vlk.vlk04
#                  AND vlj03 = l_vlk.vlk03
#                  AND vlj05 = 0
#                IF l_cnt = 0 THEN
#                    LET l_vlj06 = NULL
#                    IF g_sma.sma917 = 0 THEN
#                        LET l_vlj06 = l_ecm.ecm06 #工作站
#                    ELSE
#                        LET l_vlj06 = l_ecm.ecm05 #機器編號
#                    END IF
#                    INSERT INTO vlj_file(vlj01,vlj02,vlj03,vlj05,vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51,
#                                         vlj301,vlj302,vlj303,vlj311,vlj312,vlj313,vlj314,vlj315,vlj316,vljoriu,vljorig)
#                                   VALUES(l_vlk.vlk01,#工單編號
#                                          l_vlk.vlk04,#資源型態
#                                          l_vlk.vlk03,#製程序號
#                                          0          ,#項次
#                                          l_vlj06    ,#資源編號
#                                          l_ecm.ecm13,l_ecm.ecm14,
#                                          l_ecm.ecm15,l_ecm.ecm16,
#                                          l_ecm.ecm49,l_ecm.ecm50,
#                                          l_ecm.ecm51,
#                                          0,0,0,0,0,0,0,0,0, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#                    IF SQLCA.sqlcode THEN
#                        CALL cl_err3("ins","vlj_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
#                        LET l_upd_aps = FALSE
#                    ELSE
#                        MESSAGE 'INSERT vlj_file O.K'
#                    END IF
#                    #==>更新平行加工否 = 'Y'
#                    UPDATE ecm_file
#                       SET ecm61 = 'Y'
#                     WHERE ecm01 = l_vlk.vlk01  #工單編號
#                       AND ecm03 = l_vlk.vlk03  #製程序號
#                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                        CALL cl_err3("upd","ecm_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
#                        LET l_upd_aps = FALSE
#                    ELSE
#                        MESSAGE 'upd ecm61 O.K'
#                    END IF
#                    #(1)APS鎖定使用設備亦要同時新增
#                    LET l_vne.vne01 = l_vlk.vlk01
#                    LET l_vne.vne02 = l_vlk.vlk01
#                    LET l_vne.vne03 = l_vlk.vlk03
#                    LET l_vne.vne04 = l_ecm.ecm04
#                    LET l_vne.vne05 = l_vlj06
#                    LET l_vne.vne06 = 0
#                    LET l_vne.vne07 = 0
#                    INSERT INTO vne_file VALUES(l_vne.*)
#                    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#                        CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
#                        LET l_upd_aps = FALSE
#                    ELSE
#                        MESSAGE 'INSERT vne_file O.K'
#                    END IF
#                    #(2)重新計算vne06
#                    CALL s_upd_vne06(l_vne.vne01,l_vne.vne02,l_vne.vne03,l_vne.vne04,g_sfb.sfb08)
#                END IF
#           END IF
#           INSERT INTO vlj_file(vlj01,vlj02,vlj03,vlj05,vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51,
#                                vlj301,vlj302,vlj303,vlj311,vlj312,vlj313,vlj314,vlj315,vlj316,vljoriu,vljorig)
#                          VALUES(l_vlk.vlk01,#工單編號
#                                 l_vlk.vlk04,#資源型態
#                                 l_vlk.vlk03,#製程序號
#                                 l_vlk.vlk05,#項次
#                                 l_vlk.vlk06,
#                                 l_vlk.vlk13a,l_vlk.vlk14a,l_vlk.vlk15a,l_vlk.vlk16a,
#                                 l_vlk.vlk49a,l_vlk.vlk50a,l_vlk.vlk51a,
#                                 0,0,0,0,0,0,0,0,0, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#           IF SQLCA.sqlcode THEN
#               CALL cl_err3("ins","vlj_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
#               LET l_upd_aps = FALSE
#           ELSE
#               MESSAGE 'INSERT vlj_file O.K'
#           END IF
#           #(1)APS鎖定使用設備亦要同時新增
#           LET l_vne.vne01 = l_vlk.vlk01
#           LET l_vne.vne02 = l_vlk.vlk01
#           LET l_vne.vne03 = l_vlk.vlk03
#           LET l_vne.vne04 = l_ecm.ecm04
#           LET l_vne.vne05 = l_vlk.vlk06
#           LET l_vne.vne06 = 0
#           LET l_vne.vne07 = 0
#           INSERT INTO vne_file VALUES(l_vne.*)
#           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
#               LET l_upd_aps = FALSE
#           ELSE
#               MESSAGE 'INSERT vne_file O.K'
#           END IF
#           #(2)重新計算vne06
#           CALL s_upd_vne06(l_vne.vne01,l_vne.vne02,l_vne.vne03,l_vne.vne04,g_sfb.sfb08)
#     END IF
#     IF l_vlk.vlk07 = '2' THEN #刪除
#         DELETE FROM vlj_file
#          WHERE vlj01 = l_vlk.vlk01
#            AND vlj02 = l_vlk.vlk04
#            AND vlj03 = l_vlk.vlk03
#            AND vlj05 = l_vlk.vlk05
#         IF SQLCA.sqlcode THEN
#             CALL cl_err3("del","vlj_file",l_vlk.vlk01,l_vlk.vlk04,SQLCA.sqlcode,"","",1)
#             LET l_upd_aps = FALSE
#         ELSE
#             MESSAGE 'DELETE vlj_file O.K'
#         END IF
#         #(1)APS鎖定使用設備亦要同時刪除
#         DELETE FROM vne_file
#          WHERE vne01 = l_vlk.vlk01
#            AND vne02 = l_vlk.vlk01
#            AND vne03 = l_vlk.vlk03
#            AND vne05 = l_vlk.vlk06
#         IF SQLCA.sqlcode THEN
#             CALL cl_err3("delete","vne_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
#         END IF
#         #(2)重新計算vne06
#         CALL s_upd_vne06(l_vlk.vlk01,l_vlk.vlk01,l_vlk.vlk03,l_ecm.ecm04,g_sfb.sfb08)
#     END IF
#     IF l_vlk.vlk07 = '3' THEN #修改
#         INITIALIZE l_vlj.* TO NULL
#         LET l_vlj.vlj13 = l_vlk.vlk13b
#         IF NOT cl_null(l_vlk.vlk13a) THEN LET l_vlj.vlj13 = l_vlk.vlk13a END IF
#         LET l_vlj.vlj14 = l_vlk.vlk14b
#         IF NOT cl_null(l_vlk.vlk14a) THEN LET l_vlj.vlj14 = l_vlk.vlk14a END IF
#         LET l_vlj.vlj15 = l_vlk.vlk15b
#         IF NOT cl_null(l_vlk.vlk15a) THEN LET l_vlj.vlj15 = l_vlk.vlk15a END IF
#         LET l_vlj.vlj16 = l_vlk.vlk16b
#         IF NOT cl_null(l_vlk.vlk16a) THEN LET l_vlj.vlj16 = l_vlk.vlk16a END IF
#         LET l_vlj.vlj49 = l_vlk.vlk49b
#         IF NOT cl_null(l_vlk.vlk49a) THEN LET l_vlj.vlj49 = l_vlk.vlk49a END IF
#         LET l_vlj.vlj50 = l_vlk.vlk50b
#         IF NOT cl_null(l_vlk.vlk50a) THEN LET l_vlj.vlj50 = l_vlk.vlk50a END IF
#         LET l_vlj.vlj51 = l_vlk.vlk51b
#         IF NOT cl_null(l_vlk.vlk51a) THEN LET l_vlj.vlj51 = l_vlk.vlk51a END IF
#         SELECT count(*) INTO l_cnt
#           FROM vlj_file
#          WHERE vlj01 = l_vlk.vlk01
#            AND vlj02 = l_vlk.vlk04
#            AND vlj03 = l_vlk.vlk03
#            AND vlj05 = l_vlk.vlk05
#         IF l_cnt > 0 THEN
#             UPDATE vlj_file
#                SET vlj13=l_vlj.vlj13,
#                    vlj14=l_vlj.vlj14,
#                    vlj15=l_vlj.vlj15,
#                    vlj16=l_vlj.vlj16,
#                    vlj49=l_vlj.vlj49,
#                    vlj50=l_vlj.vlj50,
#                    vlj51=l_vlj.vlj51
#              WHERE vlj01 = l_vlk.vlk01
#                AND vlj02 = l_vlk.vlk04
#                AND vlj03 = l_vlk.vlk03
#                AND vlj05 = l_vlk.vlk05
#             IF SQLCA.sqlcode THEN
#                 CALL cl_err3("upd","vlj_file",l_vlk.vlk01,l_vlk.vlk04,SQLCA.sqlcode,"","",1)
#                 LET l_upd_aps = FALSE
#             ELSE
#                 MESSAGE 'UPDATE vlj_file O.K'
#             END IF
#         ELSE
#             IF l_vlk.vlk05 = 0 THEN
#                 UPDATE ecm_file
#                   SET ecm50 = l_vlj.vlj50,
#                       ecm51 = l_vlj.vlj51
#                 WHERE ecm01 = l_vlk.vlk01
#                   AND ecm03 = l_vlk.vlk03
#                 IF SQLCA.sqlcode THEN
#                     CALL cl_err3("upd","ecm_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
#                     LET l_upd_aps = FALSE
#                 ELSE
#                     MESSAGE 'UPDATE ecm_file O.K'
#                 END IF
#             END IF
#         END IF
#     END IF
#   END FOREACH
#   RETURN l_upd_aps

#END FUNCTION

#FUNCTION t803_update_ecm()
#  DEFINE l_cnt        LIKE type_file.num5    #TQC-890064 add
#  DEFINE l_min_vlj50  LIKE vlj_file.vlj50    #最小的開工日
#  DEFINE l_max_vlj51  LIKE vlj_file.vlj51    #最大的完成日
#  DEFINE l_vlj        RECORD LIKE vlj_file.*
#  DEFINE l_upd_ecm    LIKE type_file.num5

#   DECLARE t803_vlj CURSOR FOR
#    SELECT * FROM vlj_file
#     WHERE vlj01 = g_snb.snb01  #工單編號
#       AND vlj02 = g_sma.sma917 #資源型態
#     ORDER BY vlj03

#   LET l_upd_ecm = TRUE
#   INITIALIZE l_vlj.* TO NULL
#   FOREACH t803_vlj INTO l_vlj.*
#     IF STATUS THEN
#         CALL cl_err('foreach t803_vlj:',SQLCA.sqlcode,1)
#         LET l_upd_ecm = FALSE
#     END IF
#     #==>更新ecm50,ecm51
#     SELECT MIN(vlj50),MAX(vlj51) INTO l_min_vlj50,l_max_vlj51
#       FROM vlj_file
#      WHERE vlj01 = l_vlj.vlj01
#        AND vlj02 = l_vlj.vlj02
#        AND vlj03 = l_vlj.vlj03
#     UPDATE ecm_file
#        SET ecm50 = l_min_vlj50,
#            ecm51 = l_max_vlj51
#      WHERE ecm01 = l_vlj.vlj01
#        AND ecm03 = l_vlj.vlj03
#     IF SQLCA.sqlcode THEN
#         CALL cl_err3("update","ecm_file",l_vlj.vlj01,l_vlj.vlj03,SQLCA.sqlcode,"","",1)
#         LET l_upd_ecm = FALSE
#     END IF
#     IF l_vlj.vlj05 = 0 THEN
#         SELECT COUNT(*) INTO l_cnt
#           FROM vlj_file
#          WHERE vlj01 = l_vlj.vlj01
#            AND vlj02 = l_vlj.vlj02
#            AND vlj03 = l_vlj.vlj03
#            AND vlj05 <> 0
#         IF l_cnt = 0 THEN
#             SELECT COUNT(*) INTO l_cnt
#               FROM vlj_file
#              WHERE vlj01 = l_vlj.vlj01
#                AND vlj02 = l_vlj.vlj02
#                AND vlj03 = l_vlj.vlj03
#                AND vlj05 = 0
#             IF l_cnt > 0 THEN
#                 DELETE FROM vlj_file
#                  WHERE vlj01 = l_vlj.vlj01
#                    AND vlj02 = l_vlj.vlj02
#                    AND vlj03 = l_vlj.vlj03
#                    AND vlj05 = 0
#                 IF SQLCA.sqlcode THEN
#                     CALL cl_err3("delete","vlj_file",l_vlj.vlj01,l_vlj.vlj03,SQLCA.sqlcode,"","",1)
#                     LET l_upd_ecm = FALSE
#                 END IF
#             END IF
#             UPDATE ecm_file
#                SET ecm61 = 'N'
#              WHERE ecm01 = l_vlj.vlj01
#                AND ecm03 = l_vlj.vlj03
#             IF SQLCA.sqlcode THEN
#                 CALL cl_err3("update","ecm_file",l_vlj.vlj01,l_vlj.vlj03,SQLCA.sqlcode,"","",1)
#                 LET l_upd_ecm = FALSE
#             END IF
#         END IF
#     END IF
#   END FOREACH
#   RETURN l_upd_ecm
#END FUNCTION
#FUN-960104 MARK --END-----------------------------------------------------

FUNCTION t803_ef()
    #CALL t803_y_chk(g_snb.snb01,g_snb.snb02)    #CALL 原確認段的 check 段後在執行送簽 #FUN-A10013 mark
     CALL t803_y_chk()                           #FUN-A10013 add

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

   IF aws_efcli2(base.TypeInfo.create(g_snb),base.TypeInfo.create(g_sna),'','','','')
   THEN
       LET g_success='Y'
       LET g_snb.snb99='S'
       DISPLAY BY NAME g_snb.snb99
   ELSE
       LET g_success='N'
   END IF
END FUNCTION

FUNCTION t803_pic()
   IF g_snb.snb99='1'  THEN
       LET g_approve='Y' ELSE LET g_approve='N'
   END IF
   CASE g_snb.snbconf
        WHEN 'Y'   LET g_confirm = 'Y'
                   LET g_void = ''
        WHEN 'N'   LET g_confirm = 'N'
                   LET g_void = ''
        WHEN 'X'   LET g_confirm = ''
                   LET g_void = 'Y'
     OTHERWISE     LET g_confirm = ''
                   LET g_void = ''
   END CASE
   CALL cl_set_field_pic(g_confirm,g_approve,'','',g_void,'')
END FUNCTION

FUNCTION t803_check_duplicate_1()

   #step 1:建立臨時表 & unique index
   DROP TABLE t803_duptmp;
   CREATE TEMP TABLE t803_duptmp(
          sfa03     LIKE sfa_file.sfa03,
          sfa08     LIKE sfa_file.sfa08,
          sfa12     LIKE sfa_file.sfa12,
          sfa27     LIKE sfa_file.sfa27,
          sfa012    LIKE sfa_file.sfa012,          #FUN-A60070 add
          sfa013    LIKE sfa_file.sfa013);         #FUN-A60070 add
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode USING '-------'
      RETURN
   END IF

   CREATE unique index t803_1 ON t803_duptmp(sfa03,sfa08,sfa12,sfa27,sfa012,sfa013);  #FUN-A60070 add sfa012,sfa013
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode USING '-------'
      RETURN
   END IF

END FUNCTION

FUNCTION t803_check_duplicate_2(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_sfa27a  LIKE sfa_file.sfa27  #被替代料號
   DEFINE l_sfa27b  LIKE sfa_file.sfa27
   DEFINE l_sna     RECORD LIKE sna_file.*
   DEFINE l_msg1    STRING
   DEFINE l_msg2    STRING
   DEFINE l_msg3    STRING

   IF g_sna[l_ac].sna03a IS NULL OR g_sna[l_ac].sna12a IS NULL OR
      g_sna[l_ac].sna012a IS NULL OR g_sna[l_ac].sna013a IS NULL OR #FUN-A60070 add
      g_sna[l_ac].sna08a IS NULL THEN
      RETURN
   END IF

   LET g_errno = ''

   CALL cl_getmsg('asf-270',g_lang) RETURNING l_msg1  #項次:
   CALL cl_getmsg('asf-271',g_lang) RETURNING l_msg2  #料件:

   #step 1:清空臨時表
   DELETE FROM t803_duptmp;

   #step 2:將WO上的key值插入臨時表
   INSERT INTO t803_duptmp SELECT sfa03,sfa08,sfa12,sfa27,sfa012,sfa013    #FUN-A60070 add sfa012,sfa013
                             FROM sfa_file
                            WHERE sfa01 = g_snb.snb01
   IF SQLCA.sqlcode THEN
      LET g_msg = 'Insert W/O sfa_file'
      LET g_errno = 'asf-272'
      RETURN
   END IF

   #step 3:按單前sna單身做臨時表更新
   LET l_cnt = g_rec_b
   IF p_cmd = 'a' THEN LET l_cnt = l_cnt + 1 END IF
   FOR l_i = 1 TO l_cnt
       IF l_i = l_ac AND p_cmd = 'd' THEN
          CONTINUE FOR
       END IF
       LET l_sfa27b = NULL
       LET l_sfa27a = NULL
       IF l_i <> l_ac THEN   #當前筆時,不去后台table找
          SELECT * INTO l_sna.* FROM sna_file
           WHERE sna01 = g_snb.snb01
             AND sna02 = g_snb.snb02
             AND sna04 = g_sna[l_i].sna04
          IF SQLCA.sqlcode THEN
             LET g_msg = 'Select sna_file ',l_msg1 CLIPPED,g_sna[l_i].sna04 USING "<<<"
             LET g_errno = 'asf-272'
             RETURN
          END IF
          LET l_sfa27b = l_sna.sna27b
          LET l_sfa27a = l_sna.sna27a
       END IF

       IF cl_null(l_sfa27b) THEN  #變更前被替代料件
          SELECT sfa27 INTO l_sfa27b FROM sfa_file
           WHERE sfa01 = g_snb.snb01
             AND sfa03 = g_sna[l_i].sna03b
             AND sfa08 = g_sna[l_i].sna08b
             AND sfa12 = g_sna[l_i].sna12b
             AND sfa012= g_sna[l_i].sna012b   #FUN-A60070
             AND sfa013= g_sna[l_i].sna013b   #FUN-A60070

          IF cl_null(l_sfa27b) THEN
             LET l_sfa27b=g_sna[l_i].sna03b
          END IF
       END IF

       IF cl_null(l_sfa27a) THEN  #變更前被替代料件
          IF g_sna[l_i].sna03b = g_sna[l_i].sna03a THEN
             LET l_sfa27a = l_sfa27b
          ELSE
             LET l_sfa27a = g_sna[l_i].sna03a
          END IF
       END IF

       IF g_sna[l_i].safter = '1' THEN #變更
          DELETE FROM t803_duptmp
           WHERE sfa03 = g_sna[l_i].sna03b
             AND sfa08 = g_sna[l_i].sna08b
             AND sfa12 = g_sna[l_i].sna12b
             AND sfa27 = l_sfa27b
             AND sfa012= g_sna[l_i].sna012b   #FUN-A60070 add
             AND sfa013= g_sna[l_i].sna013b   #FUN-A60070 add
          IF SQLCA.sqlcode THEN
             LET g_msg = 'sna_file ',l_msg1 CLIPPED,g_sna[l_i].sna04 USING "<<<",
                                     l_msg2 CLIPPED,g_sna[l_i].sna03b
             LET g_errno = 'asf-272'
             RETURN
          END IF
       END IF

       INSERT INTO t803_duptmp VALUES(g_sna[l_i].sna03a,
              g_sna[l_i].sna08a,g_sna[l_i].sna12a,l_sfa27a,
              g_sna[l_i].sna012a,g_sna[l_i].sna013a)           #FUN-A60070 add
       IF SQLCA.sqlcode THEN
         #MOD-AB0169---add---start---
          IF NOT (cl_null(g_sna[l_i].sna03a) AND cl_null(g_sna[l_i].sna08a) AND
                  cl_null(g_sna[l_i].sna12a) AND cl_null (l_sfa27a) AND
                  cl_sql_dup_value(SQLCA.SQLCODE)) THEN
         #MOD-AB0169---add---end---
             LET g_msg = 'sna_file ',l_msg1 CLIPPED,g_sna[l_i].sna04 USING "<<<",
                                     l_msg2 CLIPPED,g_sna[l_i].sna03a
             LET g_errno = 'asf-272'
             RETURN
          END IF     #MOD-AB0169 add
       END IF
   END FOR

END FUNCTION

FUNCTION t803_check_duplicate_3()
   #step 1:drop 臨時表
   DROP TABLE t803_duptmp;
END FUNCTION

FUNCTION t803_time(p_cmd)

DEFINE p_cmd      LIKE type_file.chr1  #'1'代表推算預計完工日
                                       #'2'代表推算預計開工日
DEFINE l_ima59    LIKE ima_file.ima59
DEFINE l_ima60    LIKE ima_file.ima60
DEFINE l_ima601   LIKE ima_file.ima601
DEFINE l_ima61    LIKE ima_file.ima61
DEFINE l_time     LIKE sfb_file.sfb13
DEFINE l_sfb15     LIKE sfb_file.sfb15
DEFINE li_result  LIKE type_file.num5
DEFINE l_day      LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE l_ima56    LIKE ima_file.ima56


   SELECT ima59,ima60,ima601,ima61,ima56 INTO l_ima59,l_ima60,l_ima601,l_ima61,l_ima56
      FROM ima_file WHERE ima01=g_sfb.sfb05

   IF p_cmd = '1' THEN
      #TQC-C50088--modify--str--
      #LET l_time = g_sfb.sfb13
      IF NOT cl_null(g_snb.snb13a) THEN
         LET l_time = g_snb.snb13a
      ELSE
         LET l_time = g_sfb.sfb13
      END IF
      #TQC-C50088--modify--end--
      LET l_day = (l_ima59+l_ima60/l_ima601*g_snb.snb08a+l_ima61)
      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE
           WHEN li_result = 1  #1:工作日
             EXIT WHILE
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE
      END WHILE
      LET l_sfb15 = l_time
      CALL s_aday(l_sfb15,1,l_day) RETURNING l_sfb15
      RETURN l_sfb15
   ELSE
      #TQC-C50088--modify--str--
      #LET l_time = g_sfb.sfb15
      IF NOT cl_null(g_snb.snb15a) THEN
         LET l_time = g_snb.snb15a
      ELSE
         LET l_time = g_sfb.sfb15
      END IF
      #TQC-C50088--modify--end--
      LET l_day = (l_ima59+l_ima60/l_ima601*g_sfb.sfb08+l_ima61)

      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE
           WHEN li_result = 1  #1:工作日
             EXIT WHILE
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE
      END WHILE
      LET l_sfb15 = l_time
      CALL s_aday(l_sfb15,-1,l_day) RETURNING l_sfb15
      RETURN l_sfb15
   END IF

END FUNCTION

#TQC-AB0379 ----------add start-------------
#FUNCTION t803_check_sna05a(l_sna05a,l_sna01,l_sna03b,l_sna08b,l_sna12b,l_sna012b,l_sna013b)         #CHI-BA0015 mark
FUNCTION t803_check_sna05a(l_sna05a,l_sna01,l_sna03b,l_sna08b,l_sna12b,l_sna012b,l_sna013b,l_sna11a) #CHI-BA0015 add
   DEFINE l_sna05a   LIKE sna_file.sna05a
   DEFINE l_sfa05    LIKE sfa_file.sfa05      #CHI-BA0015 add
   DEFINE l_sna11a   LIKE sna_file.sna11a     #CHI-BA0015 add
   DEFINE l_sna01    LIKE sna_file.sna01
   DEFINE l_sna03b   LIKE sna_file.sna03b
   DEFINE l_sna08b   LIKE sna_file.sna08b
   DEFINE l_sna12b   LIKE sna_file.sna12b
   DEFINE l_sna012b  LIKE sna_file.sna012b
   DEFINE l_sna013b  LIKE sna_file.sna013b,
          l_sfa06    LIKE sfa_file.sfa06,
          l_sfa065   LIKE sfa_file.sfa065

  #SELECT sfa06,sfa065 INTO l_sfa06,l_sfa065 FROM sfa_file  #已發數量       #CHI-BA0015 mark
   SELECT sfa05,sfa06,sfa065 INTO l_sfa05,l_sfa06,l_sfa065 FROM sfa_file    #CHI-BA0015 add
    WHERE sfa01 = l_sna01    AND sfa03 = l_sna03b
      AND sfa08 = l_sna08b   AND sfa12 = l_sna12b
      AND sfa012= l_sna012b  AND sfa013=l_sna013b
  #CHI-BA0015 str-----
  #IF l_sna05a-l_sfa06-l_sfa065 < 0 THEN
   IF ((l_sna05a-l_sfa06-l_sfa065 < 0 OR l_sna05a < 0 )AND (l_sna11a != 'S' OR l_sna11a IS NULL ))
      OR ((l_sna05a > 0 OR cl_null(l_sna05a))  AND l_sna11a = 'S' ) THEN
  #CHI-BA0015 end-----
      RETURN '1'
   ELSE
      RETURN '0'
   END IF

END FUNCTION
#TQC-AB0379 ----------add end-----------------

#CHI-BA0015 str add-----
FUNCTION t803_chk_sna11a(l_ac)
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num5

         IF g_sna[l_ac].sna11b = 'S' THEN
            SELECT COUNT(*) INTO l_cnt
              FROM sfe_file,sfp_file
             WHERE sfe01=g_snb.snb01
               AND sfe07=g_sna[l_ac].sna03b
               AND sfp01=sfe02
               AND sfp06 IN ('8','9')

            IF l_cnt>0 AND (g_sna[l_ac].sna11a != 'S' OR g_sna[l_ac].sna11a IS NULL) THEN
               CALL cl_err('','asf-557',0)
               RETURN '1'
            END IF
         ELSE
            SELECT COUNT(*) INTO l_cnt
              FROM sfe_file,sfp_file
             WHERE sfe01=g_snb.snb01
               AND sfe07=g_sna[l_ac].sna03b
               AND sfp01=sfe02
               AND sfp06 IN ('1','2','3')

            IF l_cnt>0 AND g_sna[l_ac].sna11a = 'S' THEN
               CALL cl_err('','asf-556',0)
              RETURN '1'
            END IF
         END IF

         RETURN '0'
END FUNCTION
#CHI-BA0015 end add-----

#TQC-AB0395--begin--add---------
FUNCTION t803_set_required(p_safter)
DEFINE p_safter  LIKE type_file.chr1
DEFINE l_sfb93   LIKE sfb_file.sfb93

         SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_snb.snb01
         IF g_sma.sma541 = 'Y' AND p_safter = '2' AND l_sfb93 = 'Y' THEN
            CALL cl_set_comp_required("sna012a,sna013a",TRUE)
         END IF
END FUNCTION

FUNCTION t803_set_no_required()
       CALL cl_set_comp_required("sna012a,sna013a",FALSE)
END FUNCTION
#TQC-AB0395--end--add-----------

#FUN-960104 ADD --STR-----------------------------------

#鎖定設備變更維護
FUNCTION t803_change_apslocked_mach()

    IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF cl_null(g_sfb.sfb24) OR g_sfb.sfb24 = 'N' THEN
         #製程追縱資料尚未產生.
         CALL cl_err(g_snb.snb01,'mfg5074',1)
         RETURN
    END IF
    LET g_cmd = "apst900 '",g_snb.snb01,"' ",g_snb.snb02," ",g_sma.sma917
    CALL cl_cmdrun_wait(g_cmd)

END FUNCTION

#鎖定設備變更發出
FUNCTION t803_change_apslocked_mach_g()
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_ecm     RECORD LIKE ecm_file.*
   DEFINE l_vlk     RECORD LIKE vlk_file.*
   DEFINE l_vne     RECORD LIKE vne_file.*
   DEFINE l_upd_aps LIKE type_file.num5
   DEFINE l_vne05   LIKE vne_file.vne05
   DEFINE l_vnd     RECORD LIKE vnd_file.*
   #FUN-980080---add----str---
   DEFINE l_vlk61b  DATETIME YEAR TO MINUTE
   DEFINE l_vlk61a  DATETIME YEAR TO MINUTE
   DEFINE l_vlk62b  DATETIME YEAR TO MINUTE
   DEFINE l_vlk62a  DATETIME YEAR TO MINUTE
   DEFINE l_vnd07   DATETIME YEAR TO MINUTE
   DEFINE l_vnd08   DATETIME YEAR TO MINUTE
   DEFINE l_ecm61   LIKE ecm_file.ecm61
   #FUN-980080---add----end---

    DECLARE t803_vlk CURSOR FOR
    #FUN-980080---mod---str---
     SELECT vlk01 , vlk02 , vlk03 , vlk04 , vlk05 ,
            vlk06 , vlk07 , vlk13a, vlk13b, vlk14a,
            vlk14b, vlk15a, vlk15b, vlk16a, vlk16b,
            vlk49a, vlk49b, vlk50a, vlk50b, vlk51a,
            vlk51b, vlk60a, vlk60b, vlk61a, vlk61b,
            vlk62a, vlk62b
    #FUN-980080---mod---end---
       FROM vlk_file
      WHERE vlk01 = g_snb.snb01  #工單編號
        AND vlk02 = g_snb.snb02  #變更序號
        AND vlk04 = g_sma.sma917 #資源型態

    LET l_upd_aps = TRUE
    #FUN-980080---mod---str---
    INITIALIZE l_vlk.* TO NULL
    LET l_vlk61a = NULL
    LET l_vlk61b = NULL
    LET l_vlk62a = NULL
    LET l_vlk62b = NULL
    FOREACH t803_vlk INTO l_vlk.vlk01     ,l_vlk.vlk02 ,l_vlk.vlk03 ,l_vlk.vlk04     ,l_vlk.vlk05 ,
                          l_vlk.vlk06     ,l_vlk.vlk07 ,l_vlk.vlk13a,l_vlk.vlk13b    ,l_vlk.vlk14a,
                          l_vlk.vlk14b    ,l_vlk.vlk15a,l_vlk.vlk15b,l_vlk.vlk16a    ,l_vlk.vlk16b,
                          l_vlk.vlk49a    ,l_vlk.vlk49b,l_vlk.vlk50a,l_vlk.vlk50b    ,l_vlk.vlk51a,
                          l_vlk.vlk51b    ,l_vlk.vlk60a,l_vlk.vlk60b,l_vlk61a,l_vlk61b,
                          l_vlk62a,l_vlk62b
    #FUN-980080---mod---end---
      IF STATUS THEN
          CALL cl_err('foreach t803_vlk:',SQLCA.sqlcode,1)
          LET l_upd_aps = FALSE
      END IF
      INITIALIZE l_ecm.* TO NULL
      SELECT * INTO l_ecm.*
        FROM ecm_file
       WHERE ecm01 = l_vlk.vlk01  #工單編號
         AND ecm03 = l_vlk.vlk03  #製程序號
      IF l_vlk.vlk07 = '1' THEN #新增
         #(1)APS鎖定使用設備新增
         LET l_vne.vne01 = l_vlk.vlk01
         LET l_vne.vne02 = l_vlk.vlk01
         LET l_vne.vne03 = l_vlk.vlk03
         LET l_vne.vne04 = l_ecm.ecm04
         LET l_vne.vne05 = l_vlk.vlk06
         LET l_vne.vne06 = 0
         LET l_vne.vne07 = 0
         LET l_vne.vne50 = l_vlk.vlk50a
         LET l_vne.vne51 = l_vlk.vlk51a
         #FUN-B50046---add----str--
         LET l_vne.vneplant = g_plant
         LET l_vne.vnelegal = g_legal
         LET l_vne.vne012 = l_ecm.ecm012
         #FUN-B50046---add----end--
         INSERT INTO vne_file(vne01,vne02,vne03,vne04,vne05,vne06,vne07,vne311,vne312,vne313,vne314,vne315,vne316,vne50,vne51,vneacti,vnedate,vnegrup,vneuser,vnelegal,vneplant,vne012)                         #FUN-B50046 add vnelegal,vneplant,vne012
           VALUES(l_vne.vne01,l_vne.vne02,l_vne.vne03,l_vne.vne04,l_vne.vne05,l_vne.vne06,l_vne.vne07,0,0,0,0,0,0,l_vne.vne50,l_vne.vne51,'Y',g_today,g_grup,g_user,l_vne.vnelegal,l_vne.vneplant,l_vne.vne012) #FUN-B50046 add vnelegal,vneplant,vne012
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
             LET l_upd_aps = FALSE
         ELSE
             MESSAGE 'INSERT vne_file O.K'
         END IF

         LET l_ecm61 = NULL
         SELECT ecm61 INTO l_ecm61
           FROM ecm_file
          WHERE ecm01 = l_vne.vne01
            AND ecm03 = l_vne.vne03
            AND ecm012 = l_vne.vne012 #FUN-B50046 add
         IF l_upd_aps = TRUE AND l_ecm61 = 'N' THEN
              DELETE FROM vnd_file
               WHERE vnd01 = l_vne.vne01
                 AND vnd03 = l_vne.vne03
                 AND vnd012 = l_vne.vne012 #FUN-B50046 add
             #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN #FUN-B50046 mark
              IF SQLCA.sqlcode THEN                         #FUN-B50046 add 因為是新增,所以鎖定製程時間應是沒有資料的
                  CALL cl_err3("del","vnd_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
                  LET l_upd_aps = FALSE
              END IF
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM vnd_file
          WHERE vnd01 = l_vne.vne01
            AND vnd02 = l_vne.vne02
            AND vnd03 = l_vne.vne03
            AND vnd04 = l_vne.vne04
            AND vnd05 = l_vne.vne05
            AND vnd012 = l_vne.vne012 #FUN-B50046 add
         IF l_upd_aps = TRUE AND l_cnt = 0 THEN
            LET l_vnd.vnd01 = l_vne.vne01
            LET l_vnd.vnd02 = l_vne.vne02
            LET l_vnd.vnd03 = l_vne.vne03
            LET l_vnd.vnd04 = l_vne.vne04
            LET l_vnd.vnd05 = l_vne.vne05
            LET l_vnd.vnd012 = l_vne.vne012 #FUN-B50046 add
            IF NOT cl_null(l_vlk.vlk60a) THEN
               LET l_vnd.vnd06 = l_vlk.vlk60a
            ELSE
               LET l_vnd.vnd06 = 0
            END IF
           #FUN-980080---mod---str---
           #IF NOT cl_null(l_vlk.vlk61a) THEN
           #   LET l_vnd.vnd07 = l_vlk.vlk61a
           #ELSE
           #   LET l_vnd.vnd07 = NULL
           #END IF
           #IF NOT cl_null(l_vlk.vlk62a) THEN
           #   LET l_vnd.vnd08 = l_vlk.vlk62a
           #ELSE
           #   LET l_vnd.vnd08 = NULL
           #END IF
            IF NOT cl_null(l_vlk61a) THEN
               LET l_vnd07 = l_vlk61a
            ELSE
               LET l_vnd07 = NULL
            END IF
            IF NOT cl_null(l_vlk62a) THEN
               LET l_vnd08 = l_vlk62a
            ELSE
               LET l_vnd08 = NULL
            END IF
           #FUN-980080---mod---end---
            LET l_vnd.vnd09 = 0
            LET l_vnd.vnd10 = 0
            LET l_vnd.vnd11 = 0
            LET l_vnd.vndplant = g_plant #FUN-B50046 add
            LET l_vnd.vndlegal= g_legal #FUN-B50046 add
            INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,vndlegal,vndplant,vnd012) #FUN-B50046 add vndlegal,vndplant,vnd012
             VALUES(l_vnd.vnd01,l_vnd.vnd02,l_vnd.vnd03,l_vnd.vnd04,l_vnd.vnd05,
                   #l_vnd.vnd06,l_vnd.vnd07,l_vnd.vnd08,l_vnd.vnd09,l_vnd.vnd10,l_vnd.vnd11) #FUN-980080 mark
                    l_vnd.vnd06,l_vnd07    ,l_vnd08   ,l_vnd.vnd09,l_vnd.vnd10,l_vnd.vnd11,l_vnd.vndlegal,l_vnd.vndplant,l_vnd.vnd012) #FUN-980080 mod #FUN-B50046 add vndlegal,vndplant,vnd012
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
               LET l_upd_aps = FALSE
            ELSE
               MESSAGE 'INSERT vne_file O.K'
            END IF
         END IF
         #==>更新鎖定設備否 = 'Y'
         IF l_upd_aps = TRUE THEN
            UPDATE ecm_file
               SET ecm61 = 'Y'
             WHERE ecm01 = l_vlk.vlk01  #工單編號
               AND ecm03 = l_vlk.vlk03  #製程序號
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","ecm_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
               LET l_upd_aps = FALSE
            ELSE
               MESSAGE 'upd ecm61 O.K'
            END IF
         END IF
         #(2)重新計算vne06
         IF l_upd_aps = TRUE THEN
            CALL s_upd_vne06(l_vne.vne01,l_vne.vne02,l_vne.vne03,l_vne.vne04,g_sfb.sfb08)
         END IF
      END IF

      IF l_vlk.vlk07 = '2' THEN #刪除
         #(1)APS鎖定使用設備刪除
         DELETE FROM vne_file
          WHERE vne01 = l_vlk.vlk01
            AND vne02 = l_vlk.vlk01
            AND vne03 = l_vlk.vlk03
            AND vne05 = l_vlk.vlk06
         IF SQLCA.sqlcode THEN
            CALL cl_err3("delete","vne_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
            LET l_upd_aps = FALSE
         ELSE
            MESSAGE 'DELETE vne_file O.K'
         END IF

         #APS鎖定時間刪除
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM vnd_file
          WHERE vnd01 = l_vlk.vlk01
            AND vnd02 = l_vlk.vlk01
            AND vnd03 = l_vlk.vlk03
            AND vnd05 = l_vlk.vlk06
         IF l_cnt > 0 AND l_upd_aps=TRUE THEN
            DELETE FROM vnd_file
             WHERE vnd01 = l_vlk.vlk01
               AND vnd02 = l_vlk.vlk01
               AND vnd03 = l_vlk.vlk03
               AND vnd05 = l_vlk.vlk06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("delete","vnd_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
               LET l_upd_aps = FALSE
            ELSE
               MESSAGE 'DELETE vnd_file O.K'
            END IF
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM vne_file
          WHERE vne01 = l_vlk.vlk01
            AND vne02 = l_vlk.vlk01
            AND vne03 = l_vlk.vlk03
         IF l_cnt = 0 OR cl_null(l_cnt) AND l_upd_aps = TRUE THEN
            #==>更新鎖定設備否 = 'N'
            UPDATE ecm_file
               SET ecm61 = 'N'
             WHERE ecm01 = l_vlk.vlk01  #工單編號
               AND ecm03 = l_vlk.vlk03  #製程序號
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","ecm_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
               LET l_upd_aps = FALSE
            ELSE
               MESSAGE 'upd ecm61 O.K'
            END IF
         END IF

         #(2)重新計算vne06
         IF l_upd_aps = TRUE THEN
            CALL s_upd_vne06(l_vlk.vlk01,l_vlk.vlk01,l_vlk.vlk03,l_ecm.ecm04,g_sfb.sfb08)
         END IF
      END IF

      IF l_vlk.vlk07 = '3' THEN #修改
          INITIALIZE l_vne.* TO NULL
          IF NOT cl_null(l_vlk.vlk50a) THEN
              LET l_vne.vne50 = l_vlk.vlk50a
          ELSE
              LET l_vne.vne50 = l_vlk.vlk50b
          END IF
          IF NOT cl_null(l_vlk.vlk51a) THEN
              LET l_vne.vne51 = l_vlk.vlk51a
          ELSE
              LET l_vne.vne51 = l_vlk.vlk51b
          END IF
          SELECT count(*) INTO l_cnt
            FROM vne_file
           WHERE vne01 = l_vlk.vlk01
             AND vne02 = l_vlk.vlk01
             AND vne03 = l_vlk.vlk03
             AND vne05 = l_vlk.vlk06
          IF l_cnt > 0 THEN
              UPDATE vne_file
                 SET vne50=l_vne.vne50,
                     vne51=l_vne.vne51
               WHERE vne01 = l_vlk.vlk01
                 AND vne02 = l_vlk.vlk01
                 AND vne03 = l_vlk.vlk03
                 AND vne05 = l_vlk.vlk06
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","vne_file",l_vlk.vlk01,l_vlk.vlk04,SQLCA.sqlcode,"","",1)
                  LET l_upd_aps = FALSE
              ELSE
                  MESSAGE 'UPDATE vne_file O.K'
              END IF
              #FUN-980080---mod---str----
              IF l_upd_aps = TRUE THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt
                    FROM vnd_file
                   WHERE vnd01 = l_vlk.vlk01
                     AND vnd02 = l_vlk.vlk01
                     AND vnd03 = l_vlk.vlk03
                     AND vnd05 = l_vlk.vlk06
                  IF l_cnt = 0 THEN
                     #新增
                      IF NOT cl_null(l_vlk.vlk60a) THEN
                          LET l_vnd.vnd01 = l_vlk.vlk01
                          LET l_vnd.vnd02 = l_vlk.vlk01
                          LET l_vnd.vnd03 = l_vlk.vlk03
                          LET l_vnd.vnd04 = l_ecm.ecm04
                          LET l_vnd.vnd05 = l_vlk.vlk06
                          LET l_vnd.vnd012 = l_ecm.ecm012 #FUN-B50046 add
                          IF NOT cl_null(l_vlk.vlk60a) THEN
                             LET l_vnd.vnd06 = l_vlk.vlk60a
                          ELSE
                             LET l_vnd.vnd06 = 0
                          END IF
                          IF NOT cl_null(l_vlk61a) THEN
                             LET l_vnd07 = l_vlk61a
                          ELSE
                             LET l_vnd07 = NULL
                          END IF
                          IF NOT cl_null(l_vlk62a) THEN
                             LET l_vnd08 = l_vlk62a
                          ELSE
                             LET l_vnd08 = NULL
                          END IF
                          LET l_vnd.vnd09 = 0
                          LET l_vnd.vnd10 = 0
                          LET l_vnd.vnd11 = 0
                          LET l_vnd.vndlegal = g_legal #FUN-B50046 add
                          LET l_vnd.vndplant = g_plant #FUN-B50046 add
                          INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,vndlegal,vndplant,vnd012) #FUN-B50046 add vndlegal,vndplant,vnd012
                           VALUES(l_vnd.vnd01,l_vnd.vnd02,l_vnd.vnd03,l_vnd.vnd04,l_vnd.vnd05,
                                  l_vnd.vnd06,l_vnd07    ,l_vnd08   ,l_vnd.vnd09,l_vnd.vnd10,l_vnd.vnd11,l_vnd.vndlegal,l_vnd.vndplant,l_vnd.vnd012)#FUN-B50046 add vndlegal,vndplant,vnd012
                          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                             CALL cl_err3("ins","vne_file",l_vne.vne01,l_vne.vne02,SQLCA.sqlcode,"","",1)
                             LET l_upd_aps = FALSE
                          ELSE
                             MESSAGE 'INSERT vne_file O.K'
                          END IF
                      END IF
                  ELSE
                     #修改
                     IF NOT cl_null(l_vlk.vlk60a) THEN
                        LET l_vnd.vnd06 = l_vlk.vlk60a
                     ELSE
                        LET l_vnd.vnd06 = l_vlk.vlk60b
                     END IF
                     IF NOT cl_null(l_vlk61a) THEN
                        LET l_vnd07 = l_vlk61a
                     ELSE
                        LET l_vnd07 = l_vlk61b
                     END IF
                     IF NOT cl_null(l_vlk62a) THEN
                        LET l_vnd08 = l_vlk62a
                     ELSE
                        LET l_vnd08 = l_vlk62b
                     END IF
                     UPDATE vnd_file
                        SET vnd06 = l_vnd.vnd06,
                            vnd07 = l_vnd07,
                            vnd08 = l_vnd08,
                            vnd09 = '0',
                            vnd10 = '1'
                     WHERE vnd01 = l_vlk.vlk01
                       AND vnd02 = l_vlk.vlk01
                       AND vnd03 = l_vlk.vlk03
                       AND vnd05 = l_vlk.vlk06
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","vnd_file",l_vlk.vlk01,l_vlk.vlk04,SQLCA.sqlcode,"","",1)
                        LET l_upd_aps = FALSE
                    ELSE
                        MESSAGE 'UPDATE vnd_file O.K'
                    END IF
                  END IF
              END IF
              #FUN-980080---mod---end---
          ELSE
             UPDATE ecm_file
             SET ecm50 = l_vne.vne50,
                 ecm51 = l_vne.vne51

             WHERE ecm01 = l_vlk.vlk01
               AND ecm03 = l_vlk.vlk03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ecm_file",l_vlk.vlk01,l_vlk.vlk03,SQLCA.sqlcode,"","",1)
                LET l_upd_aps = FALSE
             ELSE
                MESSAGE 'UPDATE ecm_file O.K'
             END IF
          END IF
      END IF
      #FUN-980080---add---str---
      INITIALIZE l_vlk.* TO NULL
      LET l_vlk61a = NULL
      LET l_vlk61b = NULL
      LET l_vlk62a = NULL
      LET l_vlk62b = NULL
      #FUN-980080---add---end---
    END FOREACH
    RETURN l_upd_aps

END FUNCTION

FUNCTION t803_update_ecm2()
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_min_vne50  LIKE vne_file.vne50    #最小的開工日
   DEFINE l_max_vne51  LIKE vne_file.vne51    #最大的完成日
   DEFINE l_vne        RECORD LIKE vne_file.*
   DEFINE l_upd_ecm    LIKE type_file.num5

    DECLARE t803_vne CURSOR FOR
     SELECT * FROM vne_file
      WHERE vne01 = g_snb.snb01  #工單編號
      ORDER BY vne03

    LET l_upd_ecm = TRUE
    INITIALIZE l_vne.* TO NULL
    FOREACH t803_vne INTO l_vne.*
      IF STATUS THEN
          CALL cl_err('foreach t803_vne:',SQLCA.sqlcode,1)
          LET l_upd_ecm = FALSE
      END IF
      #==>更新ecm50,ecm51
      SELECT MIN(vne50),MAX(vne51) INTO l_min_vne50,l_max_vne51
        FROM vne_file
       WHERE vne01 = l_vne.vne01
         AND vne02 = l_vne.vne01
         AND vne03 = l_vne.vne03
      UPDATE ecm_file
         SET ecm50 = l_min_vne50,
             ecm51 = l_max_vne51
       WHERE ecm01 = l_vne.vne01
         AND ecm03 = l_vne.vne03
      IF SQLCA.sqlcode THEN
          CALL cl_err3("update","ecm_file",l_vne.vne01,l_vne.vne03,SQLCA.sqlcode,"","",1)
          LET l_upd_ecm = FALSE
      END IF
    END FOREACH

    IF cl_null(l_vne.vne01) THEN
       UPDATE ecm_file
          SET ecm61 = 'N'
        WHERE ecm01 = l_vne.vne01
          AND ecm03 = l_vne.vne03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("update","ecm_file",l_vne.vne01,l_vne.vne03,SQLCA.sqlcode,"","",1)
          LET l_upd_ecm = FALSE
       END IF
    END IF
    RETURN l_upd_ecm
END FUNCTION

#FUN-960104 ADD --END------------------------------------

#CHI-C90030 str add-----
FUNCTION t803_chk_sna065a(p_sna03b)

DEFINE l_cnt        LIKE type_file.num5
DEFINE l_cnt2       LIKE type_file.num5
DEFINE p_sna03b     LIKE sna_file.sna03b

   LET l_cnt  = 0
   LET l_cnt2 = 0
   SELECT COUNT(*) INTO l_cnt FROM sfb_file,pmm_file,pmn_file
    WHERE sfb01 = g_snb.snb01
   AND sfb39 = '1'
   AND sfbacti = 'Y'
   AND ( sfb02 = '7' OR sfb02 = '8' )
   AND pmn41 = sfb01
   AND pmn01 = pmm01
   AND pmm18 != 'X'

   SELECT sfa065 INTO l_cnt2 FROM sfa_file
    WHERE sfa01 = g_snb.snb01
      AND sfa03 = p_sna03b
   IF l_cnt2 IS NULL THEN LET l_cnt2 = 0 END IF

   IF l_cnt > 0 AND l_cnt2>0 THEN
      CALL cl_set_comp_entry("sna065a",TRUE)
      CALL cl_set_comp_entry("sna012a,sna013a,sna03a,sna05a,sna161a,sna26a,sna28a,sna29a,sna12a,sna13a,sna11a,sna08a,sna50",FALSE)
   ELSE
      IF l_cnt >0 AND l_cnt2=0 THEN
         CALL cl_set_comp_entry("sna065a",FALSE)
         CALL cl_set_comp_entry("sna012a,sna013a,sna03a,sna26a,sna28a,sna29a,sna12a,sna13a,sna11a,sna08a,sna50",FALSE)
         CALL cl_set_comp_entry("sna05a,sna161a",TRUE)
      ELSE
         CALL cl_set_comp_entry("sna065a",TRUE)
         CALL cl_set_comp_entry("sna012a,sna013a,sna03a,sna05a,sna161a,sna26a,sna28a,sna29a,sna12a,sna13a,sna08a,sna50",TRUE)
         CALL cl_set_comp_entry("sna11a",g_sfb.sfb39<>'2')
      END IF
   END IF
END FUNCTION
#CHI-C90030 end add-----

#FUN-A10134----add----str----
FUNCTION t803_aps_ui_default()
   #不串APS時,欄位隱藏
   IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
       CALL cl_set_comp_visible("snb14a,snb14b,snb16a,snb16b",FALSE)
   ELSE
       CALL cl_set_comp_visible("snb14a,snb14b,snb16a,snb16b",TRUE)
   END IF
END FUNCTION
#FUN-A10134----add----end----

#No.FUN-9C0072 精簡程式碼
#FUN-B50046

#FUN-910088--add--start--
FUNCTION t803_sna05a_check(p_subqty,p_sfb08)
   DEFINE  l_msg           LIKE type_file.chr1000,
           l_cnt           LIKE type_file.num5
   DEFINE  p_subqty        LIKE sfa_file.sfa05,
           l_sna04         LIKE sna_file.sna04,
           l_sna06a        LIKE sna_file.sna06a,
           p_sfb08         LIKE sfb_file.sfb08
  DEFINE   l_sna11a        LIKE sna_file.sna11a  #CHI-BA0015 add
  DEFINE   l_sna11a_err    LIKE sna_file.sna11a  #CHI-BA0015 add
 #CHI-C50052 str add-----
  DEFINE   l_subqty        LIKE sfa_file.sfa05,
           l_other         LIKE sfa_file.sfa05,
           l_sfb08         LIKE sfb_file.sfb08,
           l_sfa161        LIKE sfa_file.sfa161
 #CHI-C50052 end add-----

   IF NOT cl_null(g_sna[l_ac].sna05a) THEN
      IF NOT cl_null(g_sna[l_ac].sna12a) THEN
         LET g_sna[l_ac].sna05a = s_digqty(g_sna[l_ac].sna05a,g_sna[l_ac].sna12a)
      ELSE
         LET g_sna[l_ac].sna05a = s_digqty(g_sna[l_ac].sna05a,g_sna[l_ac].sna12b)
      END IF
      DISPLAY BY NAME g_sna[l_ac].sna05a
   END IF
   IF NOT (cl_null(g_sna[l_ac].sna05a) AND
           cl_null(g_sna[l_ac].sna161a)) THEN
      IF cl_null(g_sna[l_ac].sna05a) THEN
         RETURN "sna05a",p_subqty
      END IF
   END IF
   IF NOT cl_null(g_sna[l_ac].sna05a) THEN
      IF g_sfb.sfb02 NOT MATCHES '[58]' THEN
         CALL t803_sna05a()
         IF NOT cl_null(g_errno) THEN
            LET l_msg = cl_getmsg(g_errno,g_lang)
            LET l_msg = l_msg,',',cl_getmsg('lib-005',g_lang)
            IF NOT cl_confirm(l_msg) THEN
               RETURN "sna05a",p_subqty
            END IF
         END IF
      END IF
      LET l_sna04=g_sna[l_ac].sna04
      LET l_sna06a=0
      SELECT sna06a INTO l_sna06a FROM sna_file
       WHERE sna01=g_snb.snb01
         AND sna02=g_snb.snb02 AND sna04=l_sna04
      IF g_sfa.sfa26 MATCHES '[SUsuZz]' THEN
         IF NOT cl_null(l_sna06a) AND l_sna06a!=0 THEN
           #LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/l_sna06a*g_sna[l_ac].sna28b #考慮單頭變更的狀況 #CHI-C50052 mark
           #CHI-C50052 str add-----
            IF g_snb.snb08a IS NOT NULL THEN
               CALL t803_sna05_1(g_sna[l_ac].sna03b) RETURNING l_other,l_sfa161
               LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/(g_snb.snb08a*l_sfa161-l_other)
            ELSE
               LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/(g_sna[l_ac].sna05b/g_sna[l_ac].sna28b)
            END IF
           #CHI-C50052 end add-----
         ELSE
            LET g_sna[l_ac].sna28a=g_sna[l_ac].sna05a/g_sna[l_ac].sna05b*g_sna[l_ac].sna28b
         END IF
         DISPLAY BY NAME g_sna[l_ac].sna05a
         DISPLAY BY NAME g_sna[l_ac].sna28a
         #RETURN "sna28a",p_subqty  #MOD-D10064
      ELSE
         LET p_subqty=0
         IF NOT cl_null(g_sna[l_ac].sna03b) THEN
            SELECT SUM(sfa05/sfa28) INTO p_subqty FROM sfa_file
             WHERE sfa01 = g_snb.snb01
               AND sfa27 = g_sna[l_ac].sna03b
              #AND sfa26 NOT IN ('S','U')   #CHI-C50052 mark
               AND sfa26 IN ('S','U')       #CHI-C50052 add
            IF cl_null(p_subqty) THEN
              LET p_subqty=0
            END IF
           #CHI-C50052 str mark-----
           #IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
           #   LET p_subqty=p_subqty*g_snb.snb08a/g_snb.snb08b
           #END IF
           #CHI-C50052 end mark-----
         END IF
         IF NOT cl_null(l_sna06a) AND l_sna06a!=0 THEN
           #LET g_sna[l_ac].sna161a = g_sna[l_ac].sna05a/g_snb.snb08a                      #CHI-C50052 mark
            CALL t803_sna05_1(g_sna[l_ac].sna03b) RETURNING l_other,l_sfa161               #CHI-C50052 add
            LET g_sna[l_ac].sna161a = (g_sna[l_ac].sna05a+l_other)/g_snb.snb08a            #CHI-C50052 add
         ELSE
            IF NOT cl_null(g_sna[l_ac].sna03a) THEN
               SELECT COUNT(*) INTO l_cnt FROM sfa_file
                WHERE sfa01 = g_snb.snb01
                  AND sfa27 = g_sna[l_ac].sna03a
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM sfa_file
               WHERE sfa01 = g_snb.snb01
                 AND sfa27 = g_sna[l_ac].sna03b
            END IF
            IF l_cnt > 0 THEN
              #LET g_sna[l_ac].sna161a = g_sna[l_ac].sna05a/p_sfb08           #CHI-C50052 mark
              #CHI-C50052 str add-----
               IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
                  CALL t803_sna05_1(g_sna[l_ac].sna03b) RETURNING l_other,l_sfa161
                  LET g_sna[l_ac].sna161a=(g_sna[l_ac].sna05a+l_other)/g_snb.snb08a
               ELSE
                  LET g_sna[l_ac].sna161a=(g_sna[l_ac].sna05a+p_subqty)/p_sfb08
               END IF
              #CHI-C50052 end add-----
            ELSE
               #MOD-D30168---bgin
               #LET g_sna[l_ac].sna161a=g_sna[l_ac].sna161b
               IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
                  LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_snb.snb08a
               ELSE
                  LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_snb.snb08b
               END IF
               #MOD-D30168---end
            END IF
         END IF
         #------MOD-BC0240 str add------
         IF g_sna[l_ac].safter=2 THEN
         # QPA=元件數量/生產套數
            IF NOT cl_null(g_snb.snb08a) THEN #考慮單頭變更的狀況
              LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_snb.snb08a
            ELSE
              LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_snb.snb08b
            END IF
         END IF
         #------MOD-BC0240 end add------
        #CHI-BA0015 str add-----
         LET l_sna11a = null
         IF g_sna[l_ac].sna05a < 0 THEN
            LET l_sna11a = g_sna[l_ac].sna11a
            LET g_sna[l_ac].sna11a = 'S'
            CALL t803_chk_sna11a(l_ac) RETURNING l_sna11a_err
            IF l_sna11a_err = '1' THEN
               LET g_sna[l_ac].sna11a =l_sna11a
               RETURN "sna05a",p_subqty
            END IF
         END IF
         IF g_sna[l_ac].sna05a >0 AND g_sna[l_ac].sna11b = 'S' THEN
            LET l_sna11a = g_sna[l_ac].sna11a
            LET g_sna[l_ac].sna11a = null
            CALL t803_chk_sna11a(l_ac) RETURNING l_sna11a_err
            IF l_sna11a_err = '1' THEN
               LET g_sna[l_ac].sna11a =l_sna11a
               RETURN "sna05a",p_subqty
            END IF
         END IF
         DISPLAY BY NAME g_sna[l_ac].sna11a
        #CHI-BA0015 end add-----
         DISPLAY BY NAME g_sna[l_ac].sna05a
         DISPLAY BY NAME g_sna[l_ac].sna161a
         #RETURN "sna161a",p_subqty  #MOD-D10064
      END IF
   END IF
   RETURN "",p_subqty
END FUNCTION
#FUN-910088--add--end--
