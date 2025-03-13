# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp500.4gl
# Descriptions...: 請購單轉入採購單作業
# Date & Author..: 91/09/25 By Lin
# Modify.........: 99/03/19 By Carol 修改p500_s()--取替代料 tmp_file
#                                    p500_process()取替代料insert pmn_file 修正
# Modify.........: 00/08/07 By Carol 修改p500_available_qty()中參數p_qty計算
#                                    p_qty=pmn20/pmn62*pmn121(採購量/替代率*採購
#                                    -請購單位轉換因子)
# Modify.........: No:7713 03/08/06 By Mandy pmm44的預設值應為'1'
# Modify.........: No:8841 03/12/04 By Kitty pml12,pmn122 不可為null否則轉ap會有問題
# Modify.........: No:9564 04/05/19 By Melody 應改為 LET g_pmm.pmmuser=g_user
# Modify.........: No:9641 04/06/07 By Carrier default采購量為訂購量-已轉采購量
# Modify.........: No.MOD-480278 04/08/20 By Wiky 將q_pmk2改q_pmk6
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-490051 04/09/13 By Smapmin將pmn20的值default為0
# Modify.........: No.MOD-490284 04/09/16 By Smapmin以彈跳視窗顯示警告訊息
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0126 04/10/11 By Mandy 單位不可空白or null, 轉換率應by單位帶出, 若找不到轉換率應default 1
# Modify.........: No.MOD-4A0289 04/10/21 By Mandy 產生單身後,修正pmn07,pmn20,pmn68,pmn69,pmn31,pmn34,然後游標隨便上下移動,結果剛才所修正的欄位又變成修正之前的值
# Modify.........: No.MOD-4A0290 04/10/21 By Mandy default采購量為訂購量-已轉采購量
# Modify.........: No.MOD-4A0356 04/11/02 By Nicola p_ze有C開頭的錯誤碼
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.MOD-530306 05/03/25 By Mandy 採購人員沒 default 部門
# Modify.........: No.MOD-540043 05/04/08 By Echo  增加判斷設定是否與 EasyFlow 簽核
# Modify.........: No.FUN-550019 05/04/19 By Danny 採購含稅單價
#                                                  BUG處理,若pml31有值,則不CALL s_defprice
# Modify.........: No.FUN-540027 05/05/27 By Elva  新增雙單位內容 , By Will 單據編號放大
# Modify.........: No.FUN-560020 05/06/07 By Elva  雙單位內容修改
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560016 05/06/07 By Elva  雙單位內容修改
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.MOD-580135 05/08/31 By kim 按確定後,如果出現錯誤訊息,不要直接離開程式
# Modify.........: No.MOD-580276 05/09/02 By Nicola 轉入後的採購單，假設該單頭的供應廠商在apmi254的單身，仍為 1.核准中，那麼user應不能按下[確認]才合理
# Modify.........: No.MOD-580207 05/09/12 By Nicola 抓取pmh07的資料給pmn123
# Modify.........: No.MOD-5A0338 05/10/31 By Sarah 當修改了稅別,寫入採購單時要寫入修改後的稅別,而非請購單的原稅別
# Modify.........: No.MOD-5A0139 05/11/23 By Mandy 1.若採購量大於請購量時 ,會出現未轉量為 負數
# Modify.........: No.TQC-5C0014 05/12/05 By Carrier set_required時去除單位換算率
# Modify.........: No.TQC-5B0132 05/12/06 By alex 移除2727行處與規格不符部份
# Modify.........: No.FUN-610018 06/01/17 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610067 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-5B0120 06/02/22 By Sarah 單價(pmn31,pmn31t)應增加sma84處理段
# Modify.........: No.FUN-630006 06/03/06 By Nicola 預設pmm909="2"
# Modify.........: No.FUN-630040 06/03/23 By Nicola 若單身項次為統購料,則不可拋採購單
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640119 06/04/09 By Mandy 無法併入原有的採購單
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.MOD-640515 06/04/20 By Claire pmn31 比照sapmt540做檢查 
# Modify.........: No.MOD-650056 06/05/12 By Sarah 將p500_pmm()裡g_pmm.pmmdate預設值改為g_today
# Modify ........: NO.MOD-650060 06/05/12 By pengu  由apmp500請購轉採購時，轉致採購單時資料所有部門
                                                    #     應是執行apmp500 的user所屬部門，而不是default pmkgrup
# Modify ........: NO.TQC-650108 06/05/24 By Ray 料件多屬性
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-650165 06/07/03 By kim 採購日不可小於請購日
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.MOD-670089 06/07/20 By Claire pmn88,pmn88t比照sapmt540計算方式
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6A0092 06/11/15 By Claire 單身金額要以計價單位計算
# Modify.........: No.TQC-690109 06/11/15 By Claire 稅率不可修改,由稅別default並確保寫回DB
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modfiy.........: No.CHI-690043 06/11/22 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modfiy.........: No.CHI-680014 06/12/04 By rainy INSERT INTO pmn_file時要處理pmn88/pmn88t
# Modify.........: No.TQC-690102 06/12/08 By pengu 考慮幣別小數位數取位時，不應該取本幣位數
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.MOD-6C0065 06/12/14 By Sarah 修改廠商編號後應重新顯示稅別,帶稅率,及單價含稅否的欄位,也應照修改後的值來產生採購單
# Modify.........: No.MOD-6C0170 06/12/27 By Mandy (1)pmm40,pmm40t 考慮幣別小數位數取位時,應抓azi05(小計,總計小數位數)
# Modify.........:                                 (2) 順便調整因CHI-6A0004 己將g_azixx改成t_azixx漏改部份
# Modify.........: No.FUN-710030 07/01/18 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-710156 07/02/02 By Mandy pmn31,pmn31t 單價應重新抓取,不應以請購單的為主
# Modify.........: No.MOD-710159 07/02/13 By pengu PMN06為廠商編號,pml06為備註,不可如此直接存入,應要重捉廠商料號pmh04資料
# Modify.........: No.MOD-730046 07/03/14 By claire 計算pmm40,pmm40t直接sum(pmn88) sum(pmn88t)
# Modify.........: No.TQC-730062 07/03/16 By claire pmn88,pmn88t不加入單身
# Modify.........: No.FUN-710060 07/08/08 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.TQC-710080 07/08/11 By pengu  當不使用計價單位時,若去修改請購單位時隱藏的計價單位不會跟著變動
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.TQC-790088 07/09/18 By claire 需考慮不使用計價單位時變更採購單位時單價的取價
# Modify.........: No.MOD-7A0101 07/10/18 By claire 輸入的廠商修件控卡同於q_pmc1
# Modify.........: No.MOD-7A0130 07/10/23 By claire 因使用多單位時,判斷式使用數量(pmn20)應改用計價數量(pmn87)
# Modify.........: No.MOD-7B0140 07/11/14 By claire 若轉採購單幣別與原請購單不同時要以採購單幣別為主
# Modify.........: No.MOD-7B0189 07/11/21 By claire 單身若沒有新增項次時,未稅金額為0 此時按確認會有mfg3525出現
# Modify.........: No.FUN-810017 08/01/25 By jan 新增服飾作業
# Modify.........: No.FUN-810045 08/02/13 By rainy 項目管理，將項目相關欄位帶入採購單
# Modify.........: No.FUN-7B0018 08/03/03 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830135 08/03/18 By Dido 增加採購型態條件
# Modify.........: No.MOD-820084 08/03/19 By claire 調整未轉量的計算
# Modify.........: No.CHI-820014 08/03/19 By claire 單價超限率(sma84)的設定應以原始取出單價與目前交易單價比較
# Modify.........: No.FUN-830086 08/03/21 By jan 修改服飾作業
# Modify.........: No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pml66,pmn66,pmm06,pmk06
# Modify.........: No.MOD-840625 07/04/24 By claire 當不使用計價單位及雙單位時,單身修改時若已存在單位一(pmn80)則單位一數量(pmn82)會不隱藏
# Modify.........: No.MOD-850281 08/05/28 By Smapmin 修改欄位名稱
# Modify.........: No.MOD-860116 08/06/14 By Smapmin 預設採購所屬會計年度/期別
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.FUN-860106 08/08/06 By xiaofeizhu 使用多單位時，單身確認時，會多show一次訊息
# Modify.........: No.CHI-880016 08/09/01 By Smapmin 拋轉採購單的數量必須扣除已由apmp570產生底稿的數量
# Modify.........: No.MOD-890171 08/09/18 By Smapmin 變數定義錯誤
# Modify.........: No.CHI-890026 08/10/06 By Smapmin 依照稅別含稅否重新計算含稅/未稅金額
# Modify.........: No.MOD-8B0138 08/11/13 By sherry  采購單不為多角貿易代采購時，將pmm906賦為空 
# Modify.........: No.MOD-8B0196 08/11/21 By chenyu l_sum會出現為空的情況
# Modify.........: No.MOD-8B0273 08/11/27 By chenyu 1.采購單單頭單價含稅時，單身未稅單價=未稅金額/數量
# Modify.........: No.CHI-8C0053 08/12/29 By Smapmin 於產生採購單時,又再次判斷是否可拋轉採購單
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-920096 09/03/05 By jan ICD業請購轉采購時，開啟apmt540_icd
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.TQC-940002 09/04/01 By hongmei p500_b_cl中增加''
# Modify.........: No.MOD-930295 09/04/01 By chenyu 預計交貨日期如果小于單頭的采購日期，把采購日期給交貨日期
# Modify.........: No.TQC-850026 09/04/07 By chenyu 5.0版本追單
# Modify.........: No.MOD-940133 09/04/14 By Smapmin 請/採數量勾稽時,改以庫存單位為基礎來做比較
# Modify.........: No.MOD-940131 09/04/15 By Smapmin 以核價檔取價,且使用分量計價的方式,修改數量後單價要重取
# Modify.........: No.MOD-940366 09/04/28 By lutingting產生采購單時,采購版本號應default為0
# Modify.........: No.FUN-940083 09/05/06 By zhaijie新增VIM管理否欄位判斷
# Modify.........: No.MOD-950218 09/05/27 By Smapmin 加嚴控管單價不可為零
# Modify.........: No.MOD-950292 09/05/29 By Dido 採購相關日期依請購單到廠日期是否相符為依據
# Modify.........: No.MOD-960100 09/07/07 By Smapmin 使用雙單位,料件為單一單位,修改單位一後單位一的數量沒有default
# Modify.........: No.MOD-970265 09/07/29 By sherry 轉采購單時，單身的采購性質應該抓采購單單頭的性質      
# Modify.........: No.MOD-980062 09/08/12 By mike 刪除冗余代碼
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.MOD-990162 09/10/15 By Smapmin 修改變數定義與欄位的mapping
# Modify.........: No.FUN-9A0068 09/10/29 By destiny 修正VMI管理否的抓值设定
# Modify.........: No.FUN-9A0065 09/11/03 By baofei 請購單轉採購時，需排除"電子採購否(pml92)"='Y'的資料 
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No.TQC-9B0029 09/11/06 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9B0183 09/11/23 By lilingyu "采購稅前單價""采購含稅單價"輸入負數沒有控管
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:MOD-9B0197 09/12/04 By Smapmin 增加ima152的控管.單身Blanket PO是否可輸入取決於單頭採購單號
# Modify.........: No:FUN-9C0083 09/12/16 By mike 修改数量单价必须重取
# Modify.........: No:MOD-9C0378 09/12/24 By Smapmin 自動產生單身資料時,計價數量沒有重新計算
# Modify.........: No:FUN-A10034 10/01/08 By chenmoyan 修改單身中pml92='N'時，可以拋轉，反之，不拋轉
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:MOD-A20027 10/02/04 By Smapmin 產生採購單前,再次確認請購單的狀態
# Modify.........: No:MOD-A20078 10/02/10 By Smapmin 採購單單頭的專案代號未產生
# Modify.........: No:MOD-A20115 10/02/26 By Smapmin pmn52/pmn54若NULL給一個空白
# Modify.........: No:MOD-A50046 10/05/07 By Smapmin pmn011為空
# Modify.........: No:MOD-A60086 10/06/12 By Carrier 单身多笔时抛转不成功
# Modify.........: No:MOD-A50136 10/06/15 By Smapmin 有做重新取價的動作時,才需要重給取出單價
# Modify.........: No:TQC-A70004 10/07/02 By yinhy pmn012若NULL給一個空白
# Modify.........: No:MOD-A70082 10/07/11 By Smapmin 替代畫面單身的品名/單位,應要帶替代料的資料
# Modify.........: No.TQC-A70103 10/07/21 By chenmoyan 產生單身的SQL不規範
# Modify.........: No.FUN-A80001 10/08/02 By destiny 增加截止日期判断逻辑
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-A80150 10/09/07 By sabrina 單身新增"計畫批號"(pmn919)欄位
# Modify.........: No:TQC-960221 10/11/05 By sabrina (1)BEFORE FIELDpmn68的select smy_file中的where條件下錯了，沒有smy01這個欄位
#                                                    (2)tmp09型態有誤 
# Modify.........: No.TQC-AB0038 10/11/09 By vealxu sybase err
# Modify.........: No.TQC-AB0070 10/11/23 By houlia 拋轉採購單時，急料資料抓取錯誤
# Modify.........: No:MOD-AB0222 10/11/24 By Smapmin MISC料件也要重新抓ima_file的設定
# Modify.........: No:TQC-AB0345 10/11/30 By suncx 過採購人員欄位後，會自動帶出默認的部門，即使沒有改變人員也會自動帶，這樣會覆蓋掉之前修改過的部門信息
# Modify.........: No:TQC-AC0224 10/12/17 By suncx 採購類型為自訂貨才能由程序轉採購單
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-B10025 11/01/05 By Summer pmm40t取位用azi04
# Modify.........: No:TQC-B10031 11/01/10 By destiny 插入采购单的资料不对   
# Modify.........: No:TQC-B10137 11/01/14 By huangtao 根據請購單單身的經營方式拋採購單
# Modify.........: No:MOD-B10129 11/01/19 By Summer 分apmp500_icd出來
# Modify.........: No:TQC-B10089 11/01/21 By lilingyu 判斷採購日期和截止日期出錯
# Modify.........: No:MOD-B30417 11/03/15 By Summer 在BEFORE ROW的地方,若是資料被lock住,就EXIT WHILE回到單頭重打 
# Modify.........: No:FUN-B40098 11/04/29 By shiwuying 扣率代銷時，倉庫取arti200中設置的非成本rtz08
# Modify.........: No:MOD-B50018 11/05/19 By Summer 調整取位方式 
# Modify.........: No:MOD-B60069 11/06/08 By zhangll sql增加唯一属性
# Modify.........: No:FUN-B60150 11/07/04 By shiwuying 成本代銷時，倉庫取arti200中設置的成本rtz07
# Modify.........: No:MOD-B70120 11/07/17 By JoHung AFTER FIELD pmn07給pmn20值時,判斷pmn07新舊值,再決定pmn20是否重新給值
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B70039 11/08/18 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:FUN-B90103 11/10/27 By xjll   增加服飾二維功能
# Modify.........: No:FUN-BB0086 12/01/17 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-910088 12/01/18 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/01 By bart 作業編號pmn78帶預設值
# Modify.........: No.FUN-C20048 12/02/10 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-B90259 12/02/15 By Summer 輸入完廠商編號就直接按下確認,會沒有檢查到稅別
# Modify.........: No:TQC-BB0250 12/02/16 By SunLM 修改替代料號為空可以過去的bug,以及死循環的問題,mark,修改per檔此欄位必輸即可
# Modify.........: No:TQC-BC0073 12/02/16 By SunLM 解決請購單管制供應商,報錯的問題
# Modify.........: No:TQC-BC0108 12/02/16 By SunLM 對請購轉採購,進行價格條件判斷,對此欄位(pmn31 or pmn31t)進行是否允許修改管控
# Modify.........: No:TQC-BC0145 12/02/16 By SunLM 修正請轉採,無法替代,以及當有替代時,單身pmn87,pmn88,pmn88t數值錯誤的問題
# Modify.........: No:TQC-C20349 12/02/21 By xjll   修改bug 插入到採購單單身失敗
# Modify.........: No:MOD-C30173 12/03/10 By xjll  服飾業請購轉採購 添加報錯信息
# Modify.........: No:TQC-C40148 12/04/18 By xjll  Bug修改 參數設置為請購與採購互相稽核=‘Y'，非多屬性料件沒有做處理,大于請購數量仍可轉採購
# Modify.........: No:FUN-C40089 12/04/30 By bart 原先以參數sma112來判斷採購單價可否為0的程式,全部改成判斷採購價格條件(apmi110)的pnz08
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No:MOD-C50127 12/05/17 By Elise 採購單位和計價單位都相同,但是因為程式計算的問題,造成小數進位差異
# Modify.........: No:FUN-C50076 12/05/18 By bart 更改錯誤訊息代碼mfg3525->axm-627
# Modify.........: No:CHI-C30126 12/06/08 By bart 改了供應商，拋到apmt540時，產生的採購單供應商(pmm09)帶的是新供應商，但付款條件(pmm20)卻是請購單上舊的供應商
# Modify.........: No:MOD-C30797 12/06/11 By Vampire CALL q_pom2,增加傳參數判斷稅別
# Modify.........: No:MOD-C50001 12/06/15 By Vampire 改用TempTable方式去記錄單身,刪除單身資料時則刪除TempTable資料後重新讀取
# Modify.........: No:FUN-C60100 12/06/27 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No:MOD-C80196 12/08/27 By pauline 採購數量未正常回寫
# Modify.........: No:MOD-C80255 12/08/31 By Vampire pmm15不預帶pmk15
# Modify.........: No:MOD-C90132 12/09/28 By Vampire 將l_ac修正為g_cnt
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:MOD-CB0181 13/01/29 By Elise 調整FUNCTION p500_pmn()中抓pmn06前給預設值
# Modify.........: No:MOD-D10194 13/02/26 By Elise 拋轉的採購單性質應先參考asmi300,若抓不到則給原本請購單性質
# Modify.........: No:MOD-D20150 13/03/08 By Elise 游標未經過採購日期欄位,g_pmm.pmm31則會保持0
# Modify.........: No:CHI-C10037 13/03/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 請購單轉採購時，請購單備註pml06帶入採購單備註pmn100
# Modify.........: No:MOD-D60057 13/06/06 By SunLM 錄入第二筆資料的時候清空供應商名稱


DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/s_slk.global"   #FUN-B90103--add
 
DEFINE
    g_forupd_sql    STRING,                #SELECT ... FOR UPDATE SQL
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
    g_exit          LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
    g_add_po        LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01) #判斷是否為新增之採購單
    g_pmn86_o       LIKE pmn_file.pmn86,   #計價單位舊值  #MOD-730044
    g_pmn07_o       LIKE pmn_file.pmn07,   #單位舊值      #TQC-790088     #NO.FUN-9B0016
    g_pom           RECORD LIKE pom_file.*,#Blanket PO單頭
    g_pon           RECORD LIKE pon_file.*,#Blanket PO單身
    g_pmp           RECORD LIKE pmp_file.*,#重要備註檔
    g_pmo           RECORD LIKE pmo_file.*,#特殊說明檔
    g_pmk           RECORD LIKE pmk_file.*,#請購單頭檔
    g_pml2          RECORD LIKE pml_file.*,#請購單身檔
    g_pmm           RECORD LIKE pmm_file.*,#採購單頭檔
    g_pmn           RECORD LIKE pmn_file.*,#採購單身檔
    l_tmp           RECORD
         tmp01      LIKE type_file.num5,   #No.FUN-680136 SMALLINT    #l_ac
         tmp02      LIKE ima_file.ima01,   #new-part #FUN-650165
         tmp03      LIKE ima_file.ima02,   #品名規格 #FUN-650165
         tmp04      LIKE gfe_file.gfe01,   #No.FUN-680136 VARCHAR(4) #new-part之單位
         tmp05      LIKE pmn_file.pmn62,   #No.FUN-680136 DECIMAL(12,3) #替代率
         tmp06      LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1) #是否替代(Y/N)
         tmp07      LIKE pmn_file.pmn20,   #No.FUN-680136 DECIMAL(11,3) #替代量(人工key-in)   #MOD-990162 pmn52-->pmn20
         tmp08      LIKE oeb_file.oeb13,   #No.FUN-680136 DECIMAL(20,6) #單價 #FUN-4C0011
         tmp08t     LIKE oeb_file.oeb13,   #No.FUN-680136 DECIMAL(20,6) #含稅單價  No.FUN-550019
         tmp10      LIKE pmn_file.pmn90,   #CHI-820014 add #取出單價  
        #tmp09      LIKE pmn_file.pmn52    #No.FUN-680136 DDECIMAL(11,3) #折合量(替代量/替代率) #TQC-960221 mark
         tmp09      LIKE pmn_file.pmn20    #No.FUN-680136 DDECIMAL(11,3) #折合量(替代量/替代率) #TQC-960221 add
                    END RECORD,
    tm              RECORD
        pmk01       LIKE pmk_file.pmk01,    #請購單號
        pmk12       LIKE pmk_file.pmk12,    #請購人員
        pmk02       LIKE pmk_file.pmk02,
        desc        LIKE ze_file.ze03,      #No.FUN-680136 VARCHAR(10)
        pmm01       LIKE pmm_file.pmm01,    #採購單號
        pmk09       LIKE pmk_file.pmk09,    #廠商編號
        pmm04       LIKE pmm_file.pmm04,    #採購日期
        pmm22       LIKE pmm_file.pmm22,    #採購幣別
        pmm12       LIKE pmm_file.pmm12,    #採購人員
        pmm13       LIKE pmm_file.pmm13,    #採購部門
        pmm21       LIKE pmm_file.pmm21,    #採購稅別   No.FUN-550019
        pmm43       LIKE pmm_file.pmm43     #採購稅率   No.FUN-550019
                    END RECORD,
    g_pml           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pml42       LIKE pml_file.pml42,    #替代特性
        pml02       LIKE pml_file.pml02,    #項次
        pmlislk01   LIKE pmli_file.pmlislk01,#制單號     #No.FUN-810017
        pml04       LIKE pml_file.pml04,    #料件編號
        att00       LIKE imx_file.imx00,
        att01       LIKE imx_file.imx01,    #No.FUN-680136 VARCHAR(10)
        att01_c     LIKE imx_file.imx01,    #No.FUN-680136 VARCHAR(10)
        att02       LIKE imx_file.imx02,    #No.FUN-680136 VARCHAR(10)
        att02_c     LIKE imx_file.imx02,    #No.FUN-680136 VARCHAR(10)
        att03       LIKE imx_file.imx03,    #No.FUN-680136 VARCHAR(10)
        att03_c     LIKE imx_file.imx03,    #No.FUN-680136 VARCHAR(10)
        att04       LIKE imx_file.imx04,    #No.FUN-680136 VARCHAR(10)
        att04_c     LIKE imx_file.imx04,    #No.FUN-680136 VARCHAR(10)
        att05       LIKE imx_file.imx05,    #No.FUN-680136 VARCHAR(10)
        att05_c     LIKE imx_file.imx05,    #No.FUN-680136 VARCHAR(10)
        att06       LIKE imx_file.imx06,    #No.FUN-680136 VARCHAR(10)
        att06_c     LIKE imx_file.imx06,    #No.FUN-680136 VARCHAR(10)
        att07       LIKE imx_file.imx07,    #No.FUN-680136 VARCHAR(10)
        att07_c     LIKE imx_file.imx07,    #No.FUN-680136 VARCHAR(10)
        att08       LIKE imx_file.imx08,    #No.FUN-680136 VARCHAR(10)
        att08_c     LIKE imx_file.imx08,    #No.FUN-680136 VARCHAR(10)
        att09       LIKE imx_file.imx09,    #No.FUN-680136 VARCHAR(10)
        att09_c     LIKE imx_file.imx09,    #No.FUN-680136 VARCHAR(10)
        att10       LIKE imx_file.imx10,    #No.FUN-680136 VARCHAR(10)
        att10_c     LIKE imx_file.imx10,    #No.FUN-680136 VARCHAR(10)
        pml041      LIKE pml_file.pml041,   #品名規格
        ima021      LIKE ima_file.ima021,   #規格
        pml20       LIKE pml_file.pml20,    #請購量
        pml07       LIKE pml_file.pml07,    #請購單位
        pml21       LIKE pml_file.pml21,    #未轉量
        pmn07       LIKE pmn_file.pmn07,    #採購單位
        fac         LIKE pmn_file.pmn09,    #轉換率
        pmn20       LIKE pmn_file.pmn20,    #採購數量
        pmn83       LIKE pmn_file.pmn83,
        pmn84       LIKE pmn_file.pmn84,
        pmn85       LIKE pmn_file.pmn85,
        pmn80       LIKE pmn_file.pmn80,
        pmn81       LIKE pmn_file.pmn81,
        pmn82       LIKE pmn_file.pmn82,
        pmn86       LIKE pmn_file.pmn86,
        pmn87       LIKE pmn_file.pmn87,
        pmn68       LIKE pmn_file.pmn68,    #Blanket PO 單號
        pmn69       LIKE pmn_file.pmn69,    #Blanket PO 項次
        pmn31       LIKE pmn_file.pmn31,    #採購單價(未稅) #BugNo.7259
        pmn31t      LIKE pmn_file.pmn31t,   #採購單價(含稅) #No.FUN-550019
        pmn90       LIKE pmn_file.pmn90,    #取出單價   #CHI-820014 add
        pmn34       LIKE pmn_file.pmn34     #到廠日期
       #pmn919      LIKE pmn_file.pmn919    #計畫批號    #FUN-A80150 add
                    END RECORD,
    g_pml_t         RECORD                 #程式變數 (舊值)
        pml42       LIKE pml_file.pml42,    #替代特性
        pml02       LIKE pml_file.pml02,    #項次
        pmlislk01   LIKE pmli_file.pmlislk01,#制單號     #No.FUN-810017
        pml04       LIKE pml_file.pml04,    #料件編號
        att00       LIKE imx_file.imx00, 
        att01       LIKE imx_file.imx01,    #No.FUN-680136 VARCHAR(10)
        att01_c     LIKE imx_file.imx01,    #No.FUN-680136 VARCHAR(10)
        att02       LIKE imx_file.imx02,    #No.FUN-680136 VARCHAR(10)
        att02_c     LIKE imx_file.imx02,    #No.FUN-680136 VARCHAR(10)
        att03       LIKE imx_file.imx03,    #No.FUN-680136 VARCHAR(10)
        att03_c     LIKE imx_file.imx03,    #No.FUN-680136 VARCHAR(10)
        att04       LIKE imx_file.imx04,    #No.FUN-680136 VARCHAR(10)
        att04_c     LIKE imx_file.imx04,    #No.FUN-680136 VARCHAR(10)
        att05       LIKE imx_file.imx05,    #No.FUN-680136 VARCHAR(10)
        att05_c     LIKE imx_file.imx05,    #No.FUN-680136 VARCHAR(10)
        att06       LIKE imx_file.imx06,    #No.FUN-680136 VARCHAR(10)
        att06_c     LIKE imx_file.imx06,    #No.FUN-680136 VARCHAR(10)
        att07       LIKE imx_file.imx07,    #No.FUN-680136 VARCHAR(10)
        att07_c     LIKE imx_file.imx07,    #No.FUN-680136 VARCHAR(10)
        att08       LIKE imx_file.imx08,    #No.FUN-680136 VARCHAR(10)
        att08_c     LIKE imx_file.imx08,    #No.FUN-680136 VARCHAR(10)
        att09       LIKE imx_file.imx09,    #No.FUN-680136 VARCHAR(10)
        att09_c     LIKE imx_file.imx08,    #No.FUN-680136 VARCHAR(10)
        att10       LIKE imx_file.imx10,    #No.FUN-680136 VARCHAR(10)
        att10_c     LIKE imx_file.imx10,    #No.FUN-680136 VARCHAR(10)
        pml041      LIKE pml_file.pml041,   #品名規格
        ima021      LIKE ima_file.ima021,   #規格
        pml20       LIKE pml_file.pml20,    #請購量
        pml07       LIKE pml_file.pml07,    #請購單位
        pml21       LIKE pml_file.pml21,    #未轉量
        pmn07       LIKE pmn_file.pmn07,    #採購單位
        fac         LIKE pmn_file.pmn09,    #轉換率
        pmn20       LIKE pmn_file.pmn20,    #採購數量
        pmn83       LIKE pmn_file.pmn83,
        pmn84       LIKE pmn_file.pmn84,
        pmn85       LIKE pmn_file.pmn85,
        pmn80       LIKE pmn_file.pmn80,
        pmn81       LIKE pmn_file.pmn81,
        pmn82       LIKE pmn_file.pmn82,
        pmn86       LIKE pmn_file.pmn86,
        pmn87       LIKE pmn_file.pmn87,
        pmn68       LIKE pmn_file.pmn68,    #Blanket PO 單號
        pmn69       LIKE pmn_file.pmn69,    #Blanket PO 項次
        pmn31       LIKE pmn_file.pmn31,    #採購單價(未稅) #BugNo.7259
        pmn31t      LIKE pmn_file.pmn31t,   #採購單價(含稅) #No.FUN-550019
        pmn90       LIKE pmn_file.pmn90,    #取出單價   #CHI-820014 add
        pmn34       LIKE pmn_file.pmn34     #到廠日期
       #pmn919      LIKE pmn_file.pmn919    #計畫批號    #FUN-A80150 add
                    END RECORD,
    g_img09         LIKE img_file.img09,
    g_ima25         LIKE ima_file.ima25,
    g_ima31         LIKE ima_file.ima31,
    g_ima44         LIKE ima_file.ima44,
    g_ima906        LIKE ima_file.ima906,
    g_ima907        LIKE ima_file.ima907,
    g_ima908        LIKE ima_file.ima908,
    g_factor        LIKE pmn_file.pmn09,
    g_qty           LIKE img_file.img10,
    g_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    g_t1            LIKE oay_file.oayslip,  #No.FUN-680136 VARCHAR(05)
    g_buf           LIKE gfe_file.gfe02,
    l_exit          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)  #目前處理的ARRAY CNT
    l_smyslip       LIKE oay_file.oayslip,  #No.FUN-680136 VARCHAR(05)   #No.FUN-540027
    l_smyapr        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)              
    l_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_flag1         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_sql           LIKE type_file.chr1000, #No.FUN-560020  #No.FUN-680136 VARCHAR(400)
    l_pmm25         LIKE pmm_file.pmm25,   
    l_sfb82         LIKE sfb_file.sfb82,   
    l_pmmacti       LIKE pmm_file.pmmacti, 
    g_pmc03         LIKE pmc_file.pmc03,   
    g_tot           LIKE pmm_file.pmm40,   
    g_tott          LIKE pmm_file.pmm40t,  #No.FUN-610018
    g_gec07         LIKE gec_file.gec07,   #No.FUN-550019
    l_k1            LIKE pmn_file.pmn51,   #No.FUN-680136 DECIMAL(11,3)
    l_ac,l_k        LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_nn            LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680136 SMALLINT  #目前處理的SCREEN LINE
DEFINE   g_term     LIKE pmk_file.pmk41    #No.FUN-930148
DEFINE   g_price    LIKE pmk_file.pmk20    #No.FUN-930148    
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE   i               LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD
         imx00      LIKE imx_file.imx00,
         imx        ARRAY[10] OF LIKE imx_file.imx01 
         END RECORD
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE   lg_smy62      LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE   lg_smy621     LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE   lg_group      LIKE smy_file.smy62   #當前單身中采用的組別    
#MOD-B10129 mod --start--
#&ifndef STD 
DEFINE   g_pmm12_t     LIKE pmm_file.pmm12   #採購人員舊值   #TQC-AB0345
DEFINE   g_pml49       LIKE pml_file.pml49        #TQC-B10137 
#FUN-B90103------add---start--
#FUN-B90103------end---------
DEFINE g_pml07_t       LIKE pmn_file.pmn07    #No.FUN-x`
DEFINE g_pml80_t       LIKE pmn_file.pmn80    #No.FUN-BB0086
DEFINE g_pml83_t       LIKE pmn_file.pmn83    #No.FUN-BB0086
DEFINE g_pml86_t       LIKE pmn_file.pmn86    #No.FUN-BB0086
DEFINE g_pnz08         LIKE pnz_file.pnz08    #FUN-C40089

MAIN
    DEFINE  li_result       LIKE type_file.num5          #No.FUN-540027  #No.FUN-680136 SMALLINTw
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#MOD-B10129 add --start--
#MOD-B10129 add --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_success='Y' #MOD-580135
#FUN-B90103-------add--start--
#FUN-B90103-------end---------
 
   OPEN WINDOW p500_w WITH FORM "apm/42f/apmp500"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
#FUN-B90103-----add ###&endif
      CALL cl_set_comp_visible("pmlislk01",FALSE)
 
  #CALL cl_set_comp_visible("pmn919",g_sma.sma1421='Y')    #FUN-A80150 add
   CALL p500_def_form() 
   #初始化界面的樣式(沒有任何默認屬性組)
   LET lg_smy62 = ''
   LET lg_smy621 = ''
   LET lg_group = ''   
   CALL t400_refresh_detail()   
 
   LET l_exit   = 'n'
 
   WHILE TRUE
      IF g_success='Y' THEN #MOD-580135
        CLEAR FORM
        CALL g_pml.clear()
#FUN-B90103----add---
#FUN-B90103----end---
        IF s_shut(0) THEN EXIT WHILE END IF
        LET tm.pmk01=NULL
        LET tm.pmk12=NULL
        LET tm.pmk09=NULL
        LET tm.pmm12=g_user
         LET tm.pmm13=g_grup #MOD-530306
        LET tm.pmm01=NULL
        LET tm.pmm21=NULL      #No.FUN-550019
        LET tm.pmm43=0         #No.FUN-550019
        LET tm.pmm22=NULL
        LET tm.pmm04=g_today
        LET g_add_po='Y'
        DISPLAY tm.pmm04 TO pmm04
        DISPLAY tm.pmm01 TO pmm01
        DISPLAY tm.pmm22 TO pmm22
        DISPLAY tm.pmk01 TO pmk01
        DISPLAY tm.pmk09 TO pmk09
        DISPLAY tm.pmk12 TO pmk12
        DISPLAY tm.pmm12 TO pmm12
        DISPLAY tm.pmm13 TO pmm13
        DISPLAY tm.pmm21 TO pmm21
        DISPLAY tm.pmm43 TO pmm43
      END IF #MOD-580135
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT BY NAME tm.pmk01,tm.pmk12,tm.pmk02,tm.pmm01,tm.pmk09,tm.pmm04,
                   tm.pmm21,tm.pmm43,tm.pmm22,tm.pmm12,tm.pmm13   #No.FUN-550019
       WITHOUT DEFAULTS
 
       AFTER FIELD pmk01
          IF NOT cl_null(tm.pmk01) THEN
             LET g_t1=s_get_doc_no(tm.pmk01)
             #得到該單別對應的屬性群組
             IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
                #讀取smy_file中指定作業對應的默認屬性群組
                SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
                LET g_t1=s_get_doc_no(tm.pmm01)
                IF NOT cl_null(tm.pmm01) THEN
                   SELECT smy62 INTO lg_smy621 FROM smy_file WHERE smyslip = g_t1
                   IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR (cl_null(lg_smy62)AND NOT cl_null(lg_smy621)) OR lg_smy621 <> lg_smy62 THEN
                      CALL cl_err(tm.pmm01,'apm1004',0)
                      NEXT FIELD pmm01
                   END IF 
                END IF
                #刷新界面顯示
                CALL t400_refresh_detail()
             ELSE 
                LET lg_smy62 = ''
             END IF      
             CALL p500_pmk01()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.pmk01,g_errno,0)
                 NEXT FIELD pmk01
             END IF
          ELSE
             IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                LET lg_smy62 = ''
                CALL t400_refresh_detail()
             END IF
          END IF
 
       AFTER FIELD pmm01                      #採購單號
          IF NOT cl_null(tm.pmm01) THEN
             #若要併單,代表輸入的採購單號存在pmm_file
              SELECT *  
                FROM pmm_file
               WHERE pmm01=tm.pmm01
              IF STATUS = 100 THEN
                 #不存在的才要做單別判斷
                 CALL s_check_no("apm",tm.pmm01,"","2","pmm_file","pmm01","")
                   RETURNING li_result,tm.pmm01
                 DISPLAY BY NAME tm.pmm01
                 IF (NOT li_result) THEN
    	            NEXT FIELD pmm01
                 END IF
             END IF  #MOD-640119 add
             LET g_t1=s_get_doc_no(tm.pmm01)
             IF g_sma.sma120 ='Y' AND g_sma.sma907 = 'Y' AND NOT cl_null(tm.pmk01) THEN
                SELECT smy62 INTO lg_smy621 FROM smy_file WHERE smyslip = g_t1
                IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR (cl_null(lg_smy62) AND NOT cl_null(lg_smy621)) OR lg_smy621 <> lg_smy62 THEN
                   CALL cl_err(tm.pmm01,'apm1004',0)
                   NEXT FIELD pmm01
                END IF 
             END IF
             SELECT smyapr INTO l_smyapr FROM smy_file
              WHERE smyslip = l_smyslip
             LET g_cnt=0
             SELECT count(*) INTO g_cnt FROM pmm_file
              WHERE pmm01 = tm.pmm01
             IF g_cnt > 0 THEN   #採購單已存在
                SELECT pmm04,pmm22,pmm25,pmmacti,pmm09,pmm12,pmm13,pmm21,pmm43
                  INTO tm.pmm04,tm.pmm22,l_pmm25,l_pmmacti,tm.pmk09,tm.pmm12,tm.pmm13,
                       tm.pmm21,tm.pmm43
                  FROM pmm_file
                 WHERE pmm01 = tm.pmm01
                IF l_pmm25 >= '1' THEN
                    #此採購單號已經存在,且狀況碼不為'開立',所以請重新輸入
                    CALL cl_err(tm.pmm01,'mfg3110',0)
                    NEXT FIELD pmm01
                END IF
 
                IF l_pmmacti='N'  THEN                         #判斷有效碼
                   #此筆資料無效，不可新增或更改
                   CALL cl_err(tm.pmm01,'mfg3028',1)
                   NEXT FIELD pmm01
                END IF
                IF tm.pmm22 != g_pmk.pmk22 AND NOT cl_null(g_pmk.pmk22) THEN
                   CALL cl_err(tm.pmm22,'mfg3138',1)           #判斷幣別
                   NEXT FIELD pmm01
                END IF
                IF g_pmk.pmk22 != tm.pmm22 THEN           #如請購幣別與採購幣別不同
                   CALL cl_err('','mfg3138',0)
                END IF
                IF g_pmk.pmk09 != tm.pmk09 THEN           #如請購廠商與採購廠商不同
                   CALL cl_err('','mfg3020',0)
                   SELECT pmc03 INTO g_pmc03  #廠商名稱
                     FROM pmc_file
                    WHERE pmc01=tm.pmk09
                    DISPLAY g_pmc03 TO FORMONLY.pmc03
                END IF
                IF NOT cl_null(g_pmk.pmk21) THEN
                   IF g_pmk.pmk21 != tm.pmm21 THEN
                      CALL cl_err('','mfg3136',0)
                   END IF
                END IF
                DISPLAY tm.pmk09 TO pmk09
                DISPLAY tm.pmm04 TO pmm04
                DISPLAY tm.pmm12 TO pmm12
                DISPLAY tm.pmm13 TO pmm13
                DISPLAY tm.pmm22 TO pmm22
                DISPLAY tm.pmm21 TO pmm21        #No.FUN-550019		
                DISPLAY tm.pmm43 TO pmm43        #No.FUN-550019		
                LET g_add_po='N'
                EXIT INPUT                        #如為已存在之採購單後面欄位不輸入
             ELSE
                IF g_smy.smyapr = 'Y'  THEN    #需簽核
                 #當此單據性質設定為需簽核(pmu08='Y')時,必須先讀取
                 #單據性質檔的簽核等級,若此簽核等級為空白時,必須再
                 #透過 CALL s_sign(),去讀取簽核等級單頭檔(aze_file)的資料
                   IF g_smy.smyatsg='Y' THEN            #自動賦予簽核等級
                      CALL s_sign(tm.pmm01,'3','pmm01','pmm_file')
                        RETURNING g_pmm.pmmsign
                      CALL p500_pmmsign()  #取得應簽核順序
                      IF g_pmm.pmmsmax IS NULL THEN
                         LET g_pmm.pmmsmax=0
                      END IF
                   END IF
                ELSE
                   LET g_pmm.pmm25 ='1'
                   LET g_pmn.pmn16 ='1'
                END IF
             END IF
          END IF
 
       AFTER FIELD pmk09                      #供應商
         IF NOT cl_null(tm.pmk09) THEN
            CALL p500_pmk09()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pmk09,g_errno,0)
               NEXT FIELD pmk09
            END IF
            #MOD-B90259 add --start--
            IF NOT cl_null(tm.pmm21) THEN
               CALL p500_pmm21()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm21,g_errno,0)
                  NEXT FIELD pmm21
               END IF
            END IF
            #MOD-B90259 add --end--
         END IF
 
       AFTER FIELD pmm04                      #採購日期
         IF NOT cl_null(tm.pmm04) THEN
            SELECT azn02,azn04 INTO g_pmm.pmm31,g_pmm.pmm32
              FROM azn_file WHERE azn01 = tm.pmm04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azn_file",tm.pmm04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
               NEXT FIELD pmm04
            END IF
            IF NOT cl_null(g_pmk.pmk01) THEN
               IF tm.pmm04<g_pmk.pmk04 THEN
                  CALL cl_err('','apm-052',1)
                  NEXT FIELD pmm04
               END IF    
            END IF 
         END IF
 
       AFTER FIELD pmm21                      #採購稅別
         IF NOT cl_null(tm.pmm21) THEN
            CALL p500_pmm21()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pmm21,g_errno,0)
               NEXT FIELD pmm21
            END IF
         END IF
 
       AFTER FIELD pmm22                      #採購幣別
         IF NOT cl_null(tm.pmm22) THEN
            CALL p500_pmm22()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pmm22,g_errno,0)
               NEXT FIELD pmm22
            END IF
         END IF
 
       AFTER FIELD pmm12                      #採購人員
         IF NOT cl_null(tm.pmm12) THEN
            IF tm.pmm12 <> g_pmm12_t OR
               g_pmm12_t IS NULL THEN         #TQC-AB0345 新增或修改時
               CALL p500_pmm12()
               LET g_pmm12_t = tm.pmm12       #TQC-AB0345
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm12,g_errno,0)
                  NEXT FIELD pmm12
               END IF
            END IF
         END IF
 
       AFTER FIELD pmm13                      #採購部門
         IF NOT cl_null(tm.pmm13) THEN
            CALL p500_pmm13()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pmm13,g_errno,0)
               NEXT FIELD pmm13
            END IF
         END IF
 
       AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(tm.pmm22) THEN
            CALL p500_pmm22()
         END IF
 
       ON ACTION purchase_order
          CASE
             WHEN INFIELD(pmm01) #採購單號
                CALL q_pmm2(FALSE,TRUE,tm.pmm01,'0') RETURNING tm.pmm01  #No:7908 已核准的不允許
                DISPLAY tm.pmm01 TO pmm01
                NEXT FIELD pmm01
             OTHERWISE EXIT CASE
          END CASE
       
#FUN-B90103--add--str--
#FUN-B90103--add--end-- 
       ON ACTION CONTROLP
          CASE
          WHEN INFIELD(pmk01) #請購單號
             CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk6"  #No.MOD-480278
             LET g_qryparam.default1 = tm.pmk01
             CALL cl_create_qry() RETURNING tm.pmk01
             DISPLAY tm.pmk01 TO pmk01
             CALL p500_pmk01()
             NEXT FIELD pmk01
          WHEN INFIELD(pmm01) #採購單號
             LET l_smyslip=s_get_doc_no(tm.pmm01)     #No.FUN-540027
             CALL q_smy(FALSE,FALSE,l_smyslip,'APM','2') RETURNING l_smyslip #TQC-670008
             LET tm.pmm01=l_smyslip                   #No.FUN-540027
             DISPLAY tm.pmm01 TO pmm01
             NEXT FIELD pmm01
          WHEN INFIELD(pmk09) #查詢廠商檔
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmc1"
             LET g_qryparam.default1 = tm.pmk09
             CALL cl_create_qry() RETURNING tm.pmk09
             DISPLAY tm.pmk09 TO pmk09
             CALL p500_pmk09()
             NEXT FIELD pmk09
          WHEN INFIELD(pmm22) #查詢幣別檔
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azi"
             LET g_qryparam.default1 = tm.pmm22
             CALL cl_create_qry() RETURNING tm.pmm22
             DISPLAY tm.pmm22 TO pmm22
             NEXT FIELD pmm22
          WHEN INFIELD(pmm12) #採購員
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen"
             LET g_qryparam.default1 = tm.pmm12
             CALL cl_create_qry() RETURNING tm.pmm12
             DISPLAY BY NAME tm.pmm12
             #CALL p500_pmm12()     #TQC-AB0345 mark
             NEXT FIELD pmm12
          WHEN INFIELD(pmm13) #請購DEPT
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem"
             LET g_qryparam.default1 = tm.pmm13
             CALL cl_create_qry() RETURNING tm.pmm13
             DISPLAY BY NAME tm.pmm13
             CALL p500_pmm13()
             NEXT FIELD pmm13
          WHEN INFIELD(pmm21) #查詢稅別檔
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gec"
             LET g_qryparam.default1 = tm.pmm21
             LET g_qryparam.arg1     = '1'
             CALL cl_create_qry() RETURNING tm.pmm21
             DISPLAY tm.pmm21 TO pmm21
             NEXT FIELD pmm21
          OTHERWISE EXIT CASE
       END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION locale                    #genero
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL p500_def_form()   #FUN-610067
          EXIT INPUT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION exit  #加離開功能genero
          LET INT_FLAG = 1
          EXIT INPUT
 
     END INPUT
 
     IF g_action_choice = "locale" THEN  #genero
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF l_exit = 'n' THEN
#FUN-B90103------add--start--
#FUN-B90103------end--------        
        CALL g_pml.clear()
        LET g_success = 'Y'
        CALL p500_b_fill()              #單身填充
        IF g_success = 'N' THEN
           CONTINUE WHILE
        END IF
#add----FUN-B90103--
#end---FUN-B90103---
        CALL p500_b()                   #修改單身資料
     END IF
  END WHILE
 
  CLOSE WINDOW p500_w                #結束畫面
  CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p500_b_fill()                 #單身填充
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-560020  #No.FUN-680136 VARCHAR(400)
  DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_sum      LIKE pnn_file.pnn09    #CHI-880016
  DEFINE l_pmn88    LIKE pmn_file.pmn88    #No.MOD-8B0273 add
  DEFINE l_pmn88t   LIKE pmn_file.pmn88t   #No.MOD-8B0273 add
  DEFINE l_i        LIKE type_file.num5    #MOD-C50001 add

#FUN-B90103--------add--begin--
#建立一個臨時表存放多属性资料改变后的值
#FUN-B90103--------end---------
 
#MOD-B10129 mod --start--
#&ifndef STD
     LET l_sql = " SELECT pml42,pml02,'',pml04,'','','','','','','','','','','','','','','','','','','','','', ", 
                " pml041,ima021,pml20,pml07,pml20-pml21,",
                " pml07,0,0,pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,",     #CHI-880016
               #"  '','', pml31,pml31t,0,pml34,pml919  ",    #CHI-880016 修正CHI-820014 add 0    #FUN-A80150 add pml919
                "  '','', pml31,pml31t,0,pml34 ",    #CHI-880016 修正CHI-820014 add 0    #FUN-A80150 add pml919
               #" FROM pml_file, OUTER ima_file",    #TQC-AB0038 mark
                " FROM pml_file LEFT OUTER JOIN ima_file ON pml04 = ima01",     #TAC-AB0038
                " WHERE pml01 = '",tm.pmk01,"'",
#               "       AND pml04 = ima01 ",                      #TQC-A70103
#               "       AND pml_file.pml04 = ima_file.ima01 ",    #TQC-A70103  #TAC-AB0038 mark
                "       AND pml16 IN ('1','2')",
                "       AND pml190 = 'N'",   
                "   AND pml92 <> 'Y' ",  #No.FUN-A10034
                "   AND pml50 = '1' ",   #TQC-AC0224 add
                "     ORDER BY pml02 "
    PREPARE p500_prepare FROM l_sql
    MESSAGE " SEARCHING! "
    DECLARE p500_cur CURSOR FOR p500_prepare
 
    LET g_rec_b = 0
    LET l_ac = 1
    #直接輸入請購單號，然后輸入采購單別，點確定，到這邊的時候t_azi03,t_azi04等于0
    SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
     WHERE azi01 = tm.pmm22 AND aziacti = 'Y'
    FOREACH p500_cur INTO g_pml[l_ac].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF

       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN 
          #得到該料件對應的父料件和所有屬性 
          SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                 imx07,imx08,imx09,imx10 INTO
                 g_pml[l_ac].att00,g_pml[l_ac].att01,g_pml[l_ac].att02,
                 g_pml[l_ac].att03,g_pml[l_ac].att04,g_pml[l_ac].att05,
                 g_pml[l_ac].att06,g_pml[l_ac].att07,g_pml[l_ac].att08,
                 g_pml[l_ac].att09,g_pml[l_ac].att10
          FROM imx_file WHERE imx000 = g_pml[l_ac].pml04                                                                          
                                                                                                                                   
          LET g_pml[l_ac].att01_c = g_pml[l_ac].att01                                                                            
          LET g_pml[l_ac].att02_c = g_pml[l_ac].att02                                                                            
          LET g_pml[l_ac].att03_c = g_pml[l_ac].att03                                                                            
          LET g_pml[l_ac].att04_c = g_pml[l_ac].att04                                                                            
          LET g_pml[l_ac].att05_c = g_pml[l_ac].att05                                                                            
          LET g_pml[l_ac].att06_c = g_pml[l_ac].att06                                                                            
          LET g_pml[l_ac].att07_c = g_pml[l_ac].att07                                                                            
          LET g_pml[l_ac].att08_c = g_pml[l_ac].att08                                                                            
          LET g_pml[l_ac].att09_c = g_pml[l_ac].att09                                                                            
          LET g_pml[l_ac].att10_c = g_pml[l_ac].att10                                                                            
                                                                                                                                    
       END IF
 
       IF g_pml[l_ac].pml21<=0 THEN #MOD-5A0139 add
          INITIALIZE g_pml[l_ac].* TO NULL
          CONTINUE FOREACH
       END IF
#FUN-B90103--add------begin-----
#FUN-B90103--end----------------
       #Modi:請購單為MISC,不應作單位換算
       IF g_sma.sma115 ='N' THEN
          IF g_pml[l_ac].pml04[1,4] !='MISC' THEN
             CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,g_pml[l_ac].pml07)
                RETURNING l_flag,g_pml[l_ac].fac                #取換算率
             IF l_flag=1 THEN
                EXIT FOREACH
             END IF
          ELSE
             LET g_pml[l_ac].fac=1
             LET g_pml[l_ac].pmn07 = g_pml[l_ac].pml07
          END IF
       END IF
       LET l_sum = 0 
       SELECT SUM((pnn09/pnn08)*pnn17) INTO l_sum FROM pnn_file
          WHERE pnn01 = g_pmk.pmk01
            AND pnn02 = g_pml[l_ac].pml02
       IF cl_null(l_sum) THEN LET l_sum=0 END IF   #No.MOD-8B0196 add
       LET g_pml[l_ac].pmn20 = g_pml[l_ac].pml21 - l_sum
       #采購數量重新算了一下，計價數量也應該重新算一下
       CALL p500_set_pmn87()                            #TQC-980183 Mark   #MOD-9C0378 取消mark
       DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
          LET g_term = g_pmk.pmk41 
          LET g_price = g_pmk.pmk20
          IF cl_null(g_term) THEN
             SELECT pmc49
              INTO g_term
              FROM pmc_file
              WHERE pmc01 = tm.pmk09
          END IF   
          IF cl_null(g_price) THEN
             SELECT pmc17
              INTO g_price
              FROM pmc_file
              WHERE pmc01 = tm.pmk09
          END IF    
          CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pml21,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''    #TQC-9B0214---add--
                          ,g_term,g_price,g_plant) #NO:7178  #No.FUN-670099#MOD-730044#No.FUN-810017 add '' #No.FUN-930148 add-g_term,g_price  
             RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
                       g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
           END IF
          IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
          CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) RETURNING g_pml[l_ac].pmn31  #No.CHI-6A0004
          CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t  #No.CHI-6A0004
          LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #CHI-820014
       LET l_ac = l_ac + 1
 
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
 
    END FOREACH
    CALL g_pml.deleteElement(l_ac)
    #MOD-C50001 mark start -----
    #LET g_rec_b = l_ac - 1
    #IF g_rec_b = 0 THEN
    #   CALL cl_err('','apm-204',1)
    #   LET g_success = 'N'
    #   RETURN
    #END IF
    #DISPLAY g_rec_b TO FORMONLY.cnt2
 
    #DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE( COUNT = g_rec_b)
    #   BEFORE DISPLAY
    #      EXIT DISPLAY
    #END DISPLAY
    #MOD-C50001 mark end   -----

    #MOD-C50001 add start -----
    DROP TABLE p500_tmp_table
    CREATE TEMP TABLE p500_tmp_table(
       pml42       LIKE pml_file.pml42,
       pml02       LIKE pml_file.pml02,
       pmlislk01   LIKE pmli_file.pmlislk01,
       pml04       LIKE pml_file.pml04,
       att00       LIKE imx_file.imx00,
       att01       LIKE imx_file.imx01,
       att01_c     LIKE imx_file.imx01,
       att02       LIKE imx_file.imx02,
       att02_c     LIKE imx_file.imx02,
       att03       LIKE imx_file.imx03,
       att03_c     LIKE imx_file.imx03,
       att04       LIKE imx_file.imx04,
       att04_c     LIKE imx_file.imx04,
       att05       LIKE imx_file.imx05,
       att05_c     LIKE imx_file.imx05,
       att06       LIKE imx_file.imx06,
       att06_c     LIKE imx_file.imx06,
       att07       LIKE imx_file.imx07,
       att07_c     LIKE imx_file.imx07,
       att08       LIKE imx_file.imx08,
       att08_c     LIKE imx_file.imx08,
       att09       LIKE imx_file.imx09,
       att09_c     LIKE imx_file.imx09,
       att10       LIKE imx_file.imx10,
       att10_c     LIKE imx_file.imx10,
       pml041      LIKE pml_file.pml041,
       ima021      LIKE ima_file.ima021,
       pml20       LIKE pml_file.pml20,
       pml07       LIKE pml_file.pml07,
       pml21       LIKE pml_file.pml21,
       pmn07       LIKE pmn_file.pmn07,
       fac         LIKE pmn_file.pmn09,
       pmn20       LIKE pmn_file.pmn20,
       pmn83       LIKE pmn_file.pmn83,
       pmn84       LIKE pmn_file.pmn84,
       pmn85       LIKE pmn_file.pmn85,
       pmn80       LIKE pmn_file.pmn80,
       pmn81       LIKE pmn_file.pmn81,
       pmn82       LIKE pmn_file.pmn82,
       pmn86       LIKE pmn_file.pmn86,
       pmn87       LIKE pmn_file.pmn87,
       pmn68       LIKE pmn_file.pmn68,
       pmn69       LIKE pmn_file.pmn69,
       pmn31       LIKE pmn_file.pmn31,
       pmn31t      LIKE pmn_file.pmn31t,
       pmn90       LIKE pmn_file.pmn90,
       pmn34       LIKE pmn_file.pmn34)
    IF SQLCA.SQLCODE THEN
       CALL cl_err('create_tmp:',STATUS,1)
       LET g_success = 'N'
       RETURN
    END IF
    DELETE FROM p500_tmp_table

    FOR l_i = 1 TO g_pml.getLength()
       INSERT INTO p500_tmp_table VALUES (g_pml[l_i].*)
       IF SQLCA.SQLCODE THEN
          CALL cl_err('insert_tmp:',STATUS,1)
          LET g_success = 'N'
          RETURN
       END IF
    END FOR
    CALL p500_show()
    IF g_success = 'N' THEN
       RETURN
    END IF
    #MOD-C50001 add end   -----
 
END FUNCTION

#FUN-B90103-----------add---start--
#FUN-B90103-----------end---------- 
FUNCTION p500_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否  #No.FUN-680136 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)         #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_insert        LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(01)    #可新增否
    l_update        LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(01)    #可更改否 (含取消)
    l_jump          LIKE type_file.num5,                #No.FUN-680136 SMALLINT    #判斷是否跳過AFTER ROW的處理
    l_pml41         LIKE pml_file.pml41,
    l_pmn70         LIKE pmn_file.pmn70,
    l_total         LIKE oeb_file.oeb14,                #No.FUN-680136 DECIMAL(13,3)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE l_ima53      LIKE ima_file.ima53    #最近採購單價   #FUN-5B0120
DEFINE li_i         LIKE type_file.num5                 #No.FUN-680136 SMALLINT
DEFINE l_count      LIKE type_file.num5                 #No.FUN-680136 SMALLINT
DEFINE l_temp       LIKE ima_file.ima01   
DEFINE l_check_res  LIKE type_file.num5                 #No.FUN-680136 SMALLINT
DEFINE li_result    LIKE type_file.num5                 #No.CHI-690066 add SMALLINT
DEFINE l_ima915     LIKE ima_file.ima915                #FUN-710060 add
DEFINE l_sum        LIKE pnn_file.pnn09    #CHI-880016
DEFINE l_pmn88      LIKE pmn_file.pmn88    #No.MOD-8B0273 add
DEFINE l_pmn88t     LIKE pmn_file.pmn88t   #No.MOD-8B0273 add
DEFINE l_pmm25      LIKE pmm_file.pmm25     #CHI-8C0053
DEFINE l_fac        LIKE pmn_file.pmn09   #MOD-960100
DEFINE l_pmk18      LIKE pmk_file.pmk18   #MOD-A20027
#FUN-B90103---add--
#FUN-B90103---end-- 
DEFINE l_tf         LIKE type_file.chr1   #No.FUN-BB0086
DEFINE l_case       STRING   #No.FUN-BB0086

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT pml42,pml02,'',pml04,'','','','','','','','','','','','','','','','','','','','','',pml041,' ',pml20,pml07,pml20-pml21,", #TQC-940002 add '' 
        " '',0,pml20-pml21,pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,", #No.FUN-540027
        #" '','',pml31,pml31t,0,pml34,pml919 FROM pml_file ", #MOD-4A0290  #CHI-820014 modify 0   #FUN-A80150 add pml919
         " '','',pml31,pml31t,0,pml34 FROM pml_file ", #MOD-4A0290  #CHI-820014 modify 0   #FUN-A80150 add pml919
        "WHERE pml01= ? AND pml02= ?  FOR UPDATE "   #No.TQC-9B0029
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p500_b_cl CURSOR FROM g_forupd_sql       # LOCK CURSOR
#FUN-B90103-----add---begin--
#FUN-B90103-----end----------
    #-----MOD-A20027---------
    LET g_forupd_sql = "SELECT pmk18 FROM pmk_file WHERE pmk01 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p500_b_cl2 CURSOR FROM g_forupd_sql
    #-----END MOD-A20027-----

#MOD-B10129 mod --start--
#&ifndef STD
 
        DROP TABLE tmp_file
       CREATE TEMP TABLE tmp_file(
          tmp01   LIKE type_file.num5,  
          tmp02   LIKE ima_file.ima01,
          tmp03   LIKE ima_file.ima02,
          tmp04   LIKE gfe_file.gfe01,
          tmp05   LIKE pmn_file.pmn62,
          tmp06   LIKE type_file.chr1,  
          tmp07   LIKE pmn_file.pmn20,   #MOD-990162 pmn52-->pmn20
          tmp08   LIKE oeb_file.oeb13,
          tmp08t  LIKE oeb_file.oeb13,
          tmp10   LIKE pmn_file.pmn90,   #CHI-820014 add #取出單價  
          tmp09   LIKE pmn_file.pmn20)   #TQC-960221 pmn52 modify pmn20

    LET l_ac_t = 0
 
 
    LET l_allow_insert = FALSE   #MOD-7B0189
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_ac = 1
    
    WHILE TRUE   #No.MOD-580276

#FUN-B90103--add--str--
 DIALOG ATTRIBUTES(UNBUFFERED)
#FUN-B90103--end------
#FUN-B90103-------add--begin--
#   INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
#         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)    
    INPUT ARRAY g_pml FROM s_pml.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
             
#FUN-B90103-----end---------- 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL p500_set_entry_b()
            CALL p500_set_no_entry_b()
            #No.FUN-BB0086--add--begin--
            LET g_pml07_t = NULL  
            LET g_pml80_t = NULL  
            LET g_pml83_t = NULL  
            LET g_pml86_t = NULL  
            #No.FUN-BB0086--add--end--
 
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN   #No.FUN-540027
               LET p_cmd = 'u'
               LET g_pml_t.* = g_pml[l_ac].*  #BACKUP
               #No.FUN-BB0086--add--begin--
               LET g_pml07_t = g_pml[l_ac].pmn07
               LET g_pml80_t = g_pml[l_ac].pmn80 
               LET g_pml83_t = g_pml[l_ac].pmn83 
               LET g_pml86_t = g_pml[l_ac].pmn86
               #No.FUN-BB0086--add--end--
               LET g_pmn86_o=g_pml_t.pmn86  #MOD-730044 add
               LET g_pmn07_o=g_pml_t.pmn07  #TQC-790088 add
               BEGIN WORK
               OPEN p500_b_cl USING tm.pmk01,g_pml_t.pml02      #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  EXIT WHILE #MOD-B30417 add
               ELSE
                  FETCH p500_b_cl INTO g_pml[l_ac].*
                  LET g_pml[l_ac].* = g_pml_t.*  #MOD-4A0289
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pml_t.pml02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                     EXIT WHILE #MOD-B30417 add
                  ELSE
#MOD-B10129 mod --start--
#&ifndef STD
                     IF g_sma.sma115 = 'Y' THEN
                        IF g_pml[l_ac].pml04[1,4]<>'MISC' THEN
                           SELECT ima44,ima021
                              INTO g_ima44,g_pml[l_ac].ima021
                              FROM ima_file                                      #取採購單位
                             WHERE ima01=g_pml[l_ac].pml04
 
                            CALL s_chk_va_setting(g_pml[l_ac].pml04)
                                 RETURNING g_flag,g_ima906,g_ima907
 
                            CALL s_chk_va_setting1(g_pml[l_ac].pml04)
                                 RETURNING g_flag,g_ima908
                         #-----MOD-AB0222---------
                         ELSE
                           SELECT ima44,ima021
                              INTO g_ima44,g_pml[l_ac].ima021
                              FROM ima_file                                      #取採購單位
                             WHERE ima01='MISC'
 
                            CALL s_chk_va_setting(g_pml[l_ac].pml04)
                                 RETURNING g_flag,g_ima906,g_ima907
 
                            CALL s_chk_va_setting1(g_pml[l_ac].pml04)
                                 RETURNING g_flag,g_ima908
                         #-----END MOD-AB0222-----   
                         END IF
                      ELSE
                         IF g_pml[l_ac].pml04[1,4]<>'MISC' THEN
                            CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,g_pml[l_ac].pml07)
                                          RETURNING l_flag,g_pml[l_ac].fac                #取換算率
                            IF l_flag=1 THEN
                               CALL cl_err('pmn07/pml07: ','abm-731',1)
                               LET g_pml[l_ac].fac=1
                            END IF
                          ELSE                                         #MOD-4A0126
                             LET g_pml[l_ac].fac=1                     #MOD-4A0126
                             LET g_pml[l_ac].pmn07 = g_pml[l_ac].pml07 #MOD-4A0126
                         END IF
                      END IF
                   END IF
                   CALL p500_set_entry_b()
                   CALL p500_set_no_entry_b()
                   CALL p500_set_no_required()
                   CALL p500_set_required()
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
         IF g_sma.sma115 = 'N' THEN
            NEXT FIELD pmn07     #No.FUN-540027
         END IF
 
       BEFORE FIELD fac
           IF cl_null(g_pml[l_ac].fac) OR g_pml[l_ac].fac=0 THEN
              LET g_pml[l_ac].fac=1
              DISPLAY g_pml[l_ac].fac TO s_pml[l_sl].fac
           END IF
 
       AFTER FIELD pmn20
          IF NOT p500_pmn20_check(l_pml41,l_ima915) THEN NEXT FIELD pmn20  END IF   #No.FUN-BB0086
          #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_pml[l_ac].pmn20) THEN
           #   IF g_pml[l_ac].pmn20 <= 0  THEN  #No.MOD-8B0273 add
           #      LET g_pml[l_ac].pmn20 = 0
           #      DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
           #      NEXT FIELD pmn20
           #   END IF
           #   IF (g_pml[l_ac].pml04[1,4] != 'MISC') THEN
           #     CALL s_sizechk(g_pml[l_ac].pml04,g_pml[l_ac].pmn20,g_lang)
           #     RETURNING g_pml[l_ac].pmn20
           #     DISPLAY g_pml[l_ac].pmn20 TO pml20
           #   END IF
           #
           #   #----與請購互相勾稽 -----------------
           #   IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
           #      SELECT pml08 INTO g_pml2.pml08 FROM pml_file
           #         WHERE pml01=tm.pmk01 AND pml02=g_pml[l_ac].pml02
           #      CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,g_pml2.pml08)
           #         RETURNING l_flag,g_pmn.pmn09
           #      IF l_flag=1 THEN
           #         LET g_pmn.pmn09 = 1
           #      END IF
           #      IF p500_available_qty(g_pml[l_ac].pmn20*g_pmn.pmn09
           #                           ,g_pml[l_ac].pml02,g_pml[l_ac].pml04)
           #         THEN
           #         NEXT FIELD pmn20
           #      END IF
           #   END IF
           #   
           #   IF g_pml[l_ac].pmn20 != g_pml_t.pmn20 THEN 
           #       CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pmn20,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''   #TQC-9B0214---add---
           #                         ,g_term,g_price,g_plant)   #TQC-9B0214---add g_plant
           #            RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
           #                      g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
           #       IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add 
           #   END IF    
           #   
           #   # ------------若為委外請購
           #   IF g_pmk.pmk02 = 'SUB' THEN
           #      # -----必須全數移轉
           #      IF g_pml[l_ac].pmn20*g_pml[l_ac].fac < g_pml[l_ac].pml20   THEN
           #         CALL cl_err('Subcontract P/R:','apm-198',1)
           #         NEXT FIELD pmn20
           #      END IF
           #      # -----須判斷工單對應的廠商
           #      SELECT pml41 INTO l_pml41 FROM pml_file
           #       WHERE pml01=tm.pmk01 AND pml02=g_pml[l_ac].pml02
           #      IF NOT cl_null(l_pml41) THEN
           #         SELECT sfb82 INTO l_sfb82 FROM sfb_file
           #          WHERE sfb01=l_pml41 AND sfb87!='X'
           #         IF NOT cl_null(l_sfb82) THEN
           #            IF l_sfb82 != tm.pmk09 THEN
           #               CALL cl_err(tm.pmk09,'mfg9360',0)
           #          LET g_pml[l_ac].pmn20=0
           #               DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
           #               NEXT FIELD pmn20
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #   #------------料件供應商管制
           #   SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pml[l_ac].pml04 
           #   IF l_ima915='2' OR l_ima915='3' AND g_pml[l_ac].pmn20>0 THEN
           #      CALL p500_pmh(g_pml[l_ac].pml04)
           #      IF NOT cl_null(g_errno) THEN
           #         CALL cl_err(g_pml[l_ac].pml04,g_errno,0)
           #         LET g_pml[l_ac].pmn20=0
           #         DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
           #         NEXT FIELD pmn20
           #      END IF
           #   END IF
           #      CALL p500_set_pmn87()
           #   IF g_pml[l_ac].pml04[1,4]<>'MISC' AND
           #      g_pml[l_ac].pmn20 > 0 THEN
           #      LET g_term = g_pmk.pmk41 
           #      LET g_price = g_pmk.pmk20
           #      IF cl_null(g_term) THEN
           #        SELECT pmc49
           #        INTO g_term
           #        FROM pmc_file
           #        WHERE pmc01 = tm.pmk09
           #      END IF   
           #      IF cl_null(g_price) THEN
           #        SELECT pmc17
           #        INTO g_price
           #        FROM pmc_file
           #        WHERE pmc01 = tm.pmk09
           #      END IF    
           #      IF cl_null(g_pml[l_ac].pmn31) OR g_pml[l_ac].pmn31 = 0 THEN  #No.FUN-550019   #MOD-940131 mark #FUN-9C0083 取消mark
           #         CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pmn20,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''
           #                         ,g_term,g_price,g_plant) 
           #            RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
           #                      g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
           #           IF NOT cl_null(g_errno) THEN
           #              CALL cl_err('',g_errno,1)
           #           END IF
           #         IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
           #         IF NOT cl_null(g_pml[l_ac].pmn68) AND
           #            NOT cl_null(g_pml[l_ac].pmn69) THEN
           #            CALL s_bkprice(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,g_pon.pon31,g_pon.pon31t)
           #               RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t
           #         END IF
           #         LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #MOD-A50136
           #      END IF         #No.FUN-550019
           #      CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) RETURNING g_pml[l_ac].pmn31  #No.CHI-6A0004
           #      #LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #CHI-820014 add   #MOD-A50136
           #      CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t  #No.CHI-6A0004
           #      DISPLAY g_pml[l_ac].pmn31 TO s_pml[l_sl].pmn31
           #      DISPLAY g_pml[l_ac].pmn31t TO s_pml[l_sl].pmn31t
           #      DISPLAY g_pml[l_ac].pmn90 TO s_pml[l_sl].pmn90   #CHI-820014 
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
       AFTER FIELD pmn07                #採購單位
           IF NOT cl_null(g_pml[l_ac].pmn07) THEN
              CALL p500_pmn07(g_pml[l_ac].pmn07)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pml[l_ac].pmn07,g_errno,0)
                 DISPLAY g_pml[l_ac].pmn07 TO s_pml[l_sl].pmn07
                 NEXT FIELD pmn07
               ELSE
                 IF g_pml[l_ac].pml04[1,4] <> 'MISC' THEN
                    CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,
                          g_pml[l_ac].pml07)
                    RETURNING l_flag,g_pml[l_ac].fac                #取換算率
                    DISPLAY g_pml[l_ac].fac TO s_pml[l_sl].fac
                    IF l_flag=1 THEN
                       ##### -----單位換算率抓不到----#####
                       CALL cl_err('pml04/pmn07: ','abm-731',1)
                       NEXT FIELD pmn07
                    END IF
                    IF g_pml_t.pmn07 <> g_pml[l_ac].pmn07 THEN   #MOD-B70120 add
                       LET l_sum = 0 
                       SELECT SUM((pnn09/pnn08)*pnn17) INTO l_sum FROM pnn_file
                          WHERE pnn01 = g_pmk.pmk01
                            AND pnn02 = g_pml[l_ac].pml02
                       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                       LET g_pml[l_ac].pmn20 = (g_pml[l_ac].pml21 - l_sum) / g_pml[l_ac].fac
                       LET g_pml[l_ac].pmn20 = s_digqty(g_pml[l_ac].pmn20,g_pml[l_ac].pmn07)   #No.FUN-BB0086
                       DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
                    END IF                                       #MOD-B70120 add
                    IF g_pml[l_ac].pmn87 = 0 OR
                          (g_pml_t.pmn07 <> g_pml[l_ac].pmn07 OR
                           g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
 
                       IF g_sma.sma116 MATCHES '[02]' THEN
                          LET g_pml[l_ac].pmn86 = g_pml[l_ac].pmn07
                       END IF
 
                       CALL p500_set_pmn87()
                    END IF
                   IF g_pml[l_ac].pmn07 <> g_pmn07_o AND g_sma.sma116 MATCHES '[02]'  THEN
                     LET g_term = g_pmk.pmk41 
                     LET g_price = g_pmk.pmk20
                     IF cl_null(g_term) THEN
                        SELECT pmc49
                        INTO g_term
                        FROM pmc_file
                        WHERE pmc01 = tm.pmk09
                     END IF   
                     IF cl_null(g_price) THEN
                        SELECT pmc17
                        INTO g_price
                        FROM pmc_file
                        WHERE pmc01 = tm.pmk09
                     END IF    
                    CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pml21,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,'',
                                    g_term,g_price,g_plant)
                    RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
                              g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
                    IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add  
                    CALL p500_price_check(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t)#TQC-BC0108
                    LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #CHI-820014
                   END IF 
                    LET g_pmn07_o = g_pml[l_ac].pmn07
                  END IF
                END IF
                #No.FUN-BB0086--add--begin--
                IF NOT p500_pmn20_check(l_pml41,l_ima915) THEN 
                   LET g_pml07_t = g_pml[l_ac].pmn07
                   NEXT FIELD pmn20
                END IF 
                LET g_pml07_t = g_pml[l_ac].pmn07
                #No.FUN-BB0086--add--end--
           END IF
 
        BEFORE FIELD pmn83
           IF NOT cl_null(g_pml[l_ac].pml04) THEN
              SELECT ima44 INTO g_ima44
                FROM ima_file WHERE ima01=g_pml[l_ac].pml04
           END IF
           CALL p500_set_no_required()
 
        AFTER FIELD pmn83  #第二單位
           IF cl_null(g_pml[l_ac].pml04) THEN NEXT FIELD pml04 END IF
           IF NOT cl_null(g_pml[l_ac].pmn83) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pml[l_ac].pmn83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pml[l_ac].pmn83,"",STATUS,"","gfe:",0)  #No.FUN-660129
                 NEXT FIELD pmn83
              END IF
              CALL s_du_umfchk(g_pml[l_ac].pml04,'','','',
                               g_ima44,g_pml[l_ac].pmn83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pml[l_ac].pmn83,g_errno,0)
                 NEXT FIELD pmn83
              END IF
              IF cl_null(g_pml_t.pmn83) OR g_pml_t.pmn83 <> g_pml[l_ac].pmn83 THEN
                 LET g_pml[l_ac].pmn84 = g_factor
              END IF
           END IF
           CALL p500_du_data_to_correct()
           CALL p500_set_required()
           CALL cl_show_fld_cont()
           #No.FUN-BB0086--add--begin--
           IF NOT p500_pmn85_check(p_cmd) THEN 
              LET g_pml83_t = g_pml[l_ac].pmn83
              NEXT FIELD pmn85
           END IF 
           LET g_pml83_t = g_pml[l_ac].pmn83
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD pmn84  #第二轉換率
           IF NOT cl_null(g_pml[l_ac].pmn84) THEN
              IF g_pml[l_ac].pmn84=0 THEN
                 NEXT FIELD pmn84
              END IF
           END IF
 
        AFTER FIELD pmn85  #第二數量
           IF NOT p500_pmn85_check(p_cmd) THEN NEXT FIELD pmn85 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_pml[l_ac].pmn85) THEN
           #   IF g_pml[l_ac].pmn85 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pmn85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_pml_t.pmn85 <> g_pml[l_ac].pmn85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_pml[l_ac].pmn85*g_pml[l_ac].pmn84
           #         IF cl_null(g_pml[l_ac].pmn82) OR g_pml[l_ac].pmn82=0 THEN #CHI-960022
           #            LET g_pml[l_ac].pmn82=g_tot*g_pml[l_ac].pmn81
           #            DISPLAY BY NAME g_pml[l_ac].pmn82                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           #   IF g_pml[l_ac].pmn87 = 0 OR
           #      (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
           #       g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
           #       g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
           #       g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
           #       g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
           #   CALL p500_set_pmn87()
           #END IF
           #CALL cl_show_fld_cont()
           #No.FUN-BB0086--mark--begin--
 
        AFTER FIELD pmn80  #第一單位
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           #No.FUN-BB0086--add--end--
           IF cl_null(g_pml[l_ac].pml04) THEN NEXT FIELD pml04 END IF
           IF NOT cl_null(g_pml[l_ac].pmn80) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pml[l_ac].pmn80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pml[l_ac].pmn80,"",STATUS,"","gfe:",0)  #No.FUN-660129
                 NEXT FIELD pmn80
              END IF
              IF g_pml[l_ac].pml04[1,4] <> 'MISC' THEN
                 IF g_ima906 <> '2' THEN 
                    CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn80,
                          g_pml[l_ac].pml07)
                    RETURNING l_flag,l_fac                #取換算率
                    IF l_flag=1 THEN
                       CALL cl_err('pml04/pmn80: ','abm-731',1)
                       NEXT FIELD pmn80
                    END IF
                    LET l_sum = 0 
                    SELECT SUM((pnn09/pnn08)*pnn17) INTO l_sum FROM pnn_file
                       WHERE pnn01 = g_pmk.pmk01
                         AND pnn02 = g_pml[l_ac].pml02
                    IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                    LET g_pml[l_ac].pmn82 = (g_pml[l_ac].pml21 - l_sum) / l_fac
                 END IF
              END IF
              CALL p500_set_origin_field(l_ac)
              CALL s_du_umfchk(g_pml[l_ac].pml04,'','','',
                               g_pml[l_ac].pmn07,g_pml[l_ac].pmn80,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pml[l_ac].pmn80,g_errno,0)
                 NEXT FIELD pmn80
              END IF
              IF cl_null(g_pml_t.pmn80) OR g_pml_t.pmn80 <> g_pml[l_ac].pmn80 THEN
                 LET g_pml[l_ac].pmn81 = g_factor
              END IF
              #No.FUN-BB0086--add--begin--
              CALL p500_pmn82_check() RETURNING l_tf,l_case
              #No.FUN-BB0086--add--end--
           END IF
           CALL p500_du_data_to_correct()
           CALL p500_set_required()
           CALL cl_show_fld_cont()
           #No.FUN-BB0086--add--begin--
           LET g_pml80_t = g_pml[l_ac].pmn80 
           IF NOT l_tf THEN 
              CASE l_case 
                 WHEN "pmn82" NEXT FIELD pmn82
                 WHEN "pmn85" NEXT FIELD pmn85
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD pmn81  #第一轉換率
           IF NOT cl_null(g_pml[l_ac].pmn81) THEN
              IF g_pml[l_ac].pmn81=0 THEN
                 NEXT FIELD pmn81
              END IF
           END IF
 
        AFTER FIELD pmn82  #第一數量
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           CALL p500_pmn82_check() RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              CASE l_case 
                 WHEN "pmn82" NEXT FIELD pmn82
                 WHEN "pmn85" NEXT FIELD pmn85
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_pml[l_ac].pmn82) THEN
           #   IF g_pml[l_ac].pmn82 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pmn82
           #   END IF
           #END IF
           ##計算pmn20,pmn07的值,檢查數量的合理性
           # CALL p500_set_origin_field(l_ac)
           # CALL p500_check_inventory_qty(l_ac)
           #     RETURNING g_flag
           # IF g_flag = '1' THEN
           #    IF g_ima906 = '3' OR g_ima906 = '2' THEN
           #       NEXT FIELD pmn85
           #    ELSE
           #       NEXT FIELD pmn82
           #    END IF
           # END IF
           # IF g_pml[l_ac].pmn87 = 0 OR (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
           #        g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
           #        g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
           #        g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
           #        g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
           #    CALL p500_set_pmn87()
           # END IF
           # CALL cl_show_fld_cont()
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD pmn86
           IF NOT cl_null(g_pml[l_ac].pml04) THEN
              SELECT ima44 INTO g_ima44
                FROM ima_file WHERE ima01=g_pml[l_ac].pml04
           END IF
           CALL p500_set_no_required()
 
        AFTER FIELD pmn86
           IF cl_null(g_pml[l_ac].pml04) THEN NEXT FIELD pmn04 END IF
           IF NOT cl_null(g_pml[l_ac].pmn86) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pml[l_ac].pmn86
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pml[l_ac].pmn86,"",STATUS,"","gfe:",0)  #No.FUN-660129
                 NEXT FIELD pmn86
              END IF
              CALL s_du_umfchk(g_pml[l_ac].pml04,'','','',
                               g_ima44,g_pml[l_ac].pmn86,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pml[l_ac].pmn86,g_errno,0)
                 NEXT FIELD pmn86
              END IF
            IF g_pml[l_ac].pmn86 <> g_pmn86_o THEN
             #計價單位變化，不需要變更采購數量，只是變更計價數量才對 
              LET g_pml[l_ac].pmn20 = g_pml[l_ac].pml21 / g_pml[l_ac].fac #用未轉量再重計采購量
              LET g_pml[l_ac].pmn20 = s_digqty(g_pml[l_ac].pmn20,g_pml[l_ac].pmn07)  #No.FUN-BB0086 
              DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
             LET g_term = g_pmk.pmk41 
             LET g_price = g_pmk.pmk20
             IF cl_null(g_term) THEN
               SELECT pmc49
                INTO g_term
                FROM pmc_file
                WHERE pmc01 = tm.pmk09
             END IF   
            IF cl_null(g_price) THEN
               SELECT pmc17
                INTO g_price
               FROM pmc_file
               WHERE pmc01 = tm.pmk09
            END IF    
             CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pml21,'',tm.pmm21,tm.pmm43,'1',g_pml[l_ac].pmn86,'',
                             g_term,g_price,g_plant)
             RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
                       g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
             IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add  
             CALL p500_price_check(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t)#TQC-BC0108
             LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #CHI-820014 add
            END IF 
             LET g_pmn86_o = g_pml[l_ac].pmn86
             #No.FUN-BB0086--add--begin--
             CALL p500_pmn87_check()
             LET g_pml86_t = g_pml[l_ac].pmn86
             #No.FUN-BB0086--add--end--
           END IF
           CALL p500_set_required()
 
        BEFORE FIELD pmn87
           IF g_sma.sma115 = 'Y' THEN
              IF g_pml[l_ac].pmn87 = 0 OR
                    (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
                     g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
                     g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
                     g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
                     g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
                 CALL p500_set_pmn87()
              END IF
           ELSE
                 CALL p500_set_pmn87()
           END IF
 
        AFTER FIELD pmn87
           CALL p500_pmn87_check()   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin---
           #IF NOT cl_null(g_pml[l_ac].pmn87) THEN
           #   IF g_pml[l_ac].pmn87 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pmn87
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end---
 
        BEFORE FIELD pmn31                     #單價
            IF cl_null(g_pml[l_ac].pmn31) THEN
               LET g_pml[l_ac].pmn31=0
            END IF
 
        AFTER FIELD pmn31                     #單價
           IF NOT cl_null(g_pml[l_ac].pmn31) THEN
               IF g_pml[l_ac].pmn31 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD pmn31
               END IF
           END IF
            SELECT azi03 INTO t_azi03 FROM azi_file    #No.CHI-6A0004
             WHERE azi01=tm.pmm22
            CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) #No.CHI-6A0004
                 RETURNING g_pml[l_ac].pmn31
                DISPLAY g_pml[l_ac].pmn31  TO pmn31
            IF NOT cl_null(g_pml[l_ac].pmn31) THEN 
                #FUN-C40089---begin
                SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=tm.pmk09
                IF cl_null(g_pnz08) THEN 
                   LET g_pnz08 = 'Y'
                END IF 
                IF g_pnz08 = 'N' THEN 
                #IF g_sma.sma112= 'N' THEN 
                #FUN-C40089---end
                   IF g_pml[l_ac].pmn31 <=0 THEN
                      CALL cl_err('','axm-627',1) NEXT FIELD pmn31  #FUN-C50076
                   END IF
                END IF
            END IF
            #----- check採購單價超過最近採購單價% 96-06-25
            IF g_sma.sma84 != 99.99 AND g_pml[l_ac].pml04[1,4] <>'MISC' THEN
              IF g_pml[l_ac].pmn90 != 0 THEN
                 IF g_pml[l_ac].pmn31 > g_pml[l_ac].pmn90*(1+g_sma.sma84/100) THEN
                    IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                       CALL cl_err(g_pml[l_ac].pml04,'apm-240',1) #No:8752  
                       NEXT FIELD pmn31   #MOD-850281 pmb31a-->pmn31
                    ELSE
                       CALL cl_err('','apm-240',1)
                    END IF
                 END IF
              ELSE 
               SELECT ima53 INTO l_ima53 FROM ima_file
                WHERE ima01=g_pml[l_ac].pml04
               IF l_ima53 != 0 THEN  #有單價才能比較 No:8752
                  IF g_pml[l_ac].pmn31*g_pmk.pmk42 > l_ima53*(1+g_sma.sma84/100) THEN
                     IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                         CALL cl_err(g_pml[l_ac].pml04,'apm-240',0) #No:8752
                         NEXT FIELD pmn31
                     ELSE
                         CALL cl_err('','apm-240',0)
                     END IF
                  END IF
               END IF
              END IF  #CHI-820014 add
            END IF
            LET g_pml[l_ac].pmn31t = g_pml[l_ac].pmn31 * ( 1 + tm.pmm43/100)
            CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t   #No.CHI-6A0004
            DISPLAY g_pml[l_ac].pmn31 TO s_pml[l_sl].pmn31    #No.FUN-610018
            DISPLAY g_pml[l_ac].pmn31t TO s_pml[l_sl].pmn31t  #No.FUN-610018
 
        AFTER FIELD pmn31t   #單價
            IF NOT cl_null(g_pml[l_ac].pmn31t) THEN
               IF g_pml[l_ac].pmn31 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD pmn31
               END IF
               CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t  #No.CHI-6A0004
               #FUN-C40089---begin
               SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=tm.pmk09
               IF cl_null(g_pnz08) THEN 
                  LET g_pnz08 = 'Y'
               END IF 
               IF g_pnz08 = 'N' THEN 
               #IF g_sma.sma112= 'N' THEN 
               #FUN-C40089---end
                  IF g_pml[l_ac].pmn31t <=0 THEN
                     CALL cl_err('','axm-627',1) NEXT FIELD pmn31t  #FUN-C50076
                  END IF
               END IF
               #先計算出未稅單價再判斷"採購單價超過最近採購單價"
                LET g_pml[l_ac].pmn31 =                                                                                             
                    g_pml[l_ac].pmn31t / ( 1 + tm.pmm43 / 100)
 
                CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) RETURNING g_pml[l_ac].pmn31  #No.CHI-6A0004
                DISPLAY g_pml[l_ac].pmn31 TO s_pml[l_sl].pmn31    #No.FUN-610018
                DISPLAY g_pml[l_ac].pmn31t TO s_pml[l_sl].pmn31t  #No.FUN-610018
               #----- check採購單價超過最近採購單價% 96-06-25
               IF g_sma.sma84 != 99.99 AND g_pml[l_ac].pml04[1,4] <>'MISC' THEN
                IF g_pml[l_ac].pmn90 != 0 THEN
                   IF g_pml[l_ac].pmn31 > g_pml[l_ac].pmn90*(1+g_sma.sma84/100) THEN
                      IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                         CALL cl_err(g_pml[l_ac].pml04,'apm-240',1) #No:8752  
                         NEXT FIELD pmn31t   #MOD-850281 pmb31a-->pmn31t
                      ELSE
                         CALL cl_err('','apm-240',1)
                      END IF
                   END IF
                ELSE 
                  SELECT ima53 INTO l_ima53 FROM ima_file
                   WHERE ima01=g_pml[l_ac].pml04
                  IF l_ima53 != 0 THEN  #有單價才能比較 No:8752
                     IF g_pml[l_ac].pmn31*g_pmk.pmk42 > l_ima53*(1+g_sma.sma84/100) THEN
                        IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                            CALL cl_err(g_pml[l_ac].pml04,'apm-240',0) #No:8752
                            NEXT FIELD pmn31t
                        ELSE
                            CALL cl_err('','apm-240',0)
                        END IF
                     END IF
                  END IF
                END IF  #CHI-820014 add
               END IF
            END IF
 
        BEFORE FIELD pmn68
#genero
            LET l_smyslip = s_get_doc_no(tm.pmm01)    #No.FUN-540027
            SELECT * INTO g_smy.* FROM smy_file
            #WHERE smy01 = l_smyslip             #TQC-960221 mark
             WHERE smyslip = l_smyslip           #TQC-960221 add
 
        AFTER FIELD pmn68   #Blanket P/O
            IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
               IF cl_null(g_pml[l_ac].pmn68) THEN
                   CALL cl_err('','apm-907',0)    #No.MOD-4A0356
                  NEXT FIELD pmn68
               END IF
            END IF
            IF NOT cl_null(g_pml[l_ac].pmn68) THEN
               IF NOT cl_null (g_pml[l_ac].pmn69) THEN
                  CALL p500_pml04_chk(g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,g_pml[l_ac].pml04) RETURNING  l_flag
                  IF l_flag ='N' THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD pmn68
                  END IF
               END IF
               CALL p500_pmn68()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pml[l_ac].pmn68,g_errno,0)
                  NEXT FIELD pmn68
               END IF
               IF tm.pmk09 != g_pom.pom09 THEN    #廠商編號不合
                   CALL cl_err(g_pmm.pmm09,'apm-903',0)   #No.MOD-4A0356
                  NEXT FIELD pmn68
               END IF
            END IF
 
        AFTER FIELD pmn69   #Blanket 項次
            IF g_smy.smy57[4,4]='Y' THEN  #單據性質設為使用 Blanket P/O
# genero  script marked                IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
               IF cl_null(g_pml[l_ac].pmn69) THEN
                   CALL cl_err('','apm-907',0)    #No.MOD-4A0356
                  NEXT FIELD pmn69
               END IF
            END IF
            IF NOT cl_null(g_pml[l_ac].pmn68) THEN
               IF cl_null(g_pml[l_ac].pmn69) THEN NEXT FIELD pmn69  END IF
            END IF
#TQC-B10089 --begin--
            SELECT pon19 INTO g_pon.pon19 FROM pon_file
             WHERE pon01 = g_pml[l_ac].pmn68
               AND pon02 = g_pml[l_ac].pmn69
#TQC-B10089 --end--
            #NO.FUN-A80001--begin
               IF tm.pmm04 > g_pon.pon19 THEN
                  CALL cl_err('','apm-815',1)
                  NEXT FIELD pmn69
               END IF
            #NO.FUN-A80001--end            
            IF NOT cl_null(g_pml[l_ac].pmn69) THEN
               IF NOT cl_null (g_pml[l_ac].pmn68) THEN
                  CALL p500_pml04_chk(g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,g_pml[l_ac].pml04) RETURNING  l_flag
                  IF l_flag ='N' THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD pmn69
                  END IF
               END IF
                  SELECT * INTO g_pon.* FROM pon_file
                   WHERE pon01 = g_pml[l_ac].pmn68
                     AND pon02 = g_pml[l_ac].pmn69
                  IF STATUS THEN
                      CALL cl_err3("sel","pon_file",g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,"apm-902","","",0)  #No.FUN-660129
                     NEXT FIELD pmn68
                  END IF
                  #Blanket P/O 之單位轉換因子
                  CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,
                                g_pon.pon07)
                            RETURNING l_flag,l_pmn70
                  IF l_flag THEN
                     CALL cl_err('','abm-731',1)
                     IF g_sma.sma115 = 'N' THEN
                        NEXT FIELD pmn07
                     ElSE
                        NEXT FIELD pmn80  #No.FUN-540027
                     END IF
                  END IF
                  #輸入之數量不合大於Blanket P/O 之
                  #申請數量-已轉數量(pon20-pon21)
                  IF g_pml[l_ac].pmn20*l_pmn70 > g_pon.pon20 - g_pon.pon21 THEN   #MOD-9B0197
                      CALL cl_err('','apm-905',0)     #No.MOD-4A0356
                     IF g_sma.sma115 = 'N' THEN
                        NEXT FIELD pmn20
                     ElSE
                        IF g_ima906 ='2' OR g_ima906 = '3' THEN
                           NEXT FIELD pmn85
                        ELSE
                           NEXT FIELD pmn82  #No.FUN-540027
                        END IF
                     END IF
                  END IF
                  CALL s_bkprice(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,g_pon.pon31,g_pon.pon31t)
                       RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t
                  CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) RETURNING g_pml[l_ac].pmn31  #No.CHI-6A0004
                  CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t  #No.CHI-6A0004
                  DISPLAY g_pml[l_ac].pmn31 TO s_pml[l_sl].pmn31
                  DISPLAY g_pml[l_ac].pmn31t TO s_pml[l_sl].pmn31t
             END IF
 
        AFTER FIELD pmn34
           IF g_pml[l_ac].pmn34 < tm.pmm04 THEN
              CALL cl_err('','apm-080',1)
              LET g_pml[l_ac].pmn34 = tm.pmm04
              NEXT FIELD pmn34
           END IF
           LET li_result = 0
           CALL s_daywk(g_pml[l_ac].pmn34) RETURNING li_result
 
           IF li_result = 0 THEN  #0:非工作日
              CALL cl_err(g_pml[l_ac].pmn34,'mfg3152',1)
           END IF
           IF li_result = 2 THEN  #2:無設定資料 
              CALL cl_err(g_pml[l_ac].pmn34,'mfg3153',1)
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_pml_t.pml02 IS NOT NULL THEN
              DELETE FROM p500_tmp_table WHERE pml02 = g_pml_t.pml02 #MOD-C50001 add
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cnt2   #No:7387
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               IF p_cmd = 'u' THEN
                  LET g_pml[l_ac].* = g_pml_t.*
               END IF
               CLOSE p500_b_cl
#MOD-B10129 mod --start--
#&ifndef STD
               ROLLBACK WORK
             #  EXIT INPUT    #mark by FUN-B90103
                EXIT DIALOG   #add by FUN-B90103
            END IF
            LET g_pml_t.* = g_pml[l_ac].*
            CLOSE p500_b_cl
#MOD-B10129 mod --start--
#&ifndef STD
            #MOD-C80196 add START
            UPDATE p500_tmp_table
               SET pml42     = g_pml_t.pml42
                  ,pml02     = g_pml_t.pml02
                  ,pmlislk01 = g_pml_t.pmlislk01
                  ,pml04     = g_pml_t.pml04
                  ,att00     = g_pml_t.att00
                  ,att01     = g_pml_t.att01
                  ,att01_c   = g_pml_t.att01_c
                  ,att02     = g_pml_t.att02
                  ,att02_c   = g_pml_t.att02_c
                  ,att03     = g_pml_t.att03
                  ,att03_c   = g_pml_t.att03_c
                  ,att04     = g_pml_t.att04
                  ,att04_c   = g_pml_t.att04_c
                  ,att05     = g_pml_t.att05
                  ,att05_c   = g_pml_t.att05_c
                  ,att06     = g_pml_t.att06
                  ,att06_c   = g_pml_t.att06_c
                  ,att07     = g_pml_t.att07
                  ,att07_c   = g_pml_t.att07_c
                  ,att08     = g_pml_t.att08
                  ,att08_c   = g_pml_t.att08_c
                  ,att09     = g_pml_t.att09
                  ,att09_c   = g_pml_t.att09_c
                  ,att10     = g_pml_t.att10
                  ,att10_c   = g_pml_t.att10_c
                  ,pml041    = g_pml_t.pml041
                  ,ima021    = g_pml_t.ima021
                  ,pml20     = g_pml_t.pml20
                  ,pml07     = g_pml_t.pml07
                  ,pml21     = g_pml_t.pml21
                  ,pmn07     = g_pml_t.pmn07
                  ,fac       = g_pml_t.fac
                  ,pmn20     = g_pml_t.pmn20
                  ,pmn83     = g_pml_t.pmn83
                  ,pmn84     = g_pml_t.pmn84
                  ,pmn85     = g_pml_t.pmn85
                  ,pmn80     = g_pml_t.pmn80
                  ,pmn81     = g_pml_t.pmn81
                  ,pmn82     = g_pml_t.pmn82
                  ,pmn86     = g_pml_t.pmn86
                  ,pmn87     = g_pml_t.pmn87
                  ,pmn68     = g_pml_t.pmn68
                  ,pmn69     = g_pml_t.pmn69
                  ,pmn31     = g_pml_t.pmn31
                  ,pmn31t    = g_pml_t.pmn31t
                  ,pmn90     = g_pml_t.pmn90
                  ,pmn34     = g_pml_t.pmn34
             WHERE pml02     = g_pml_t.pml02
            #MOD-C80196 add END
            COMMIT WORK
            CALL p500_tot()
            #MOD-C50001 add start -----
            CALL p500_show()
            IF g_success = 'N' THEN
               RETURN
            END IF
            #MOD-C50001 add end   -----
 
       ON ACTION mntn_sub #採購數量(替代功能)
                IF {g_pml[l_ac].pml42='1' AND} g_pmk.pmk02!='SUB' THEN
                   IF cl_null(g_pml[l_ac].pmn20) OR g_pml[l_ac].pmn20=0 THEN
                      LET g_pml[l_ac].pmn20=g_pml[l_ac].pml21
                   END IF
                   CALL p500_s(l_ac)
                ELSE
                   CALL cl_err('','mfg3529',0)
                END IF
                IF g_sma.sma115 = 'N' THEN
                   NEXT FIELD pmn20
                ELSE
                   NEXT FIELD pmn82  #No.FUN-540027
                END IF
 
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(pmn07) #採購單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_pml[l_ac].pmn07
               CALL cl_create_qry() RETURNING g_pml[l_ac].pmn07
                DISPLAY g_pml[l_ac].pmn07 TO pmn07             #No.MOD-490371
               NEXT FIELD pmn07
            WHEN INFIELD(pmn83) #採購單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_pml[l_ac].pmn83
               CALL cl_create_qry() RETURNING g_pml[l_ac].pmn83
                DISPLAY g_pml[l_ac].pmn83 TO pmn83             #No.MOD-490371
               NEXT FIELD pmn83
            WHEN INFIELD(pmn80) #採購單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_pml[l_ac].pmn80
               CALL cl_create_qry() RETURNING g_pml[l_ac].pmn80
                DISPLAY g_pml[l_ac].pmn80 TO pmn80             #No.MOD-490371
               NEXT FIELD pmn80
            WHEN INFIELD(pmn68) #Blanket P/O
               #CALL q_pom2(FALSE,TRUE,g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,tm.pmk09,tm.pmm22) RETURNING g_pml[l_ac].pmn68,g_pml[l_ac].pmn69         #MOD-C30797 start
               CALL q_pom2(FALSE,TRUE,g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,tm.pmk09,tm.pmm22,tm.pmm21) RETURNING g_pml[l_ac].pmn68,g_pml[l_ac].pmn69 #MOD-C30797 add
                DISPLAY g_pml[l_ac].pmn68 TO pmn68             #No.MOD-490371
                DISPLAY g_pml[l_ac].pmn69 TO pmn69             #No.MOD-490371
               NEXT FIELD pmn68
 
            WHEN INFIELD(pmn69) #Blanket P/O
               #CALL q_pom2(FALSE,TRUE,g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,tm.pmk09,tm.pmm22) RETURNING g_pml[l_ac].pmn68,g_pml[l_ac].pmn69         #MOD-C30797 mark
               CALL q_pom2(FALSE,TRUE,g_pml[l_ac].pmn68,g_pml[l_ac].pmn69,tm.pmk09,tm.pmm22,tm.pmm21) RETURNING g_pml[l_ac].pmn68,g_pml[l_ac].pmn69 #MOD-C30797 add
                DISPLAY g_pml[l_ac].pmn68 TO pmn68             #No.MOD-490371
                DISPLAY g_pml[l_ac].pmn69 TO pmn69             #No.MOD-490371
               NEXT FIELD pmn69
           OTHERWISE EXIT CASE
        END CASE
#mark by FUN-B90103----start-- 
#       ON ACTION CONTROLN
#          LET l_exit_sw = "n"
#          EXIT INPUT
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#
#       ON ACTION CONTROLF
#          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
#  
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
#  
#       ON ACTION controls                           #No.FUN-6B0032             
#          CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
#FUN--B90103--------------end-----------
        END INPUT
#FUN-B90103--add-##&endif
#FUN-B90103-------------add---begin--
        ON ACTION CONTROLN
           LET l_exit_sw = "n"
         # EXIT INPUT    #mark by FUN-B90103
         # EXIT DIALOG   #add by FUN-B90103 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
       #   CONTINUE INPUT       #mark FUN-B90103
           CONTINUE DIALOG      #add  FUN-B90103
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controls                           #No.FUN-6B0032
           CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

        ON ACTION ACCEPT
           ACCEPT DIALOG
 
        ON ACTION CANCEL
           EXIT DIALOG
#FUN-B90103----add-------------
#FUN-B90103--add---end---
       END DIALOG
#FUN-B90103-----------end---------
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           EXIT WHILE   #No.MOD-580276
        END IF
 
        LET l_flag='N'
#FUN-B90103------------add------
#FUN-B90103------------end------
        FOR i=1 TO g_rec_b             #判斷單身是否有輸入
            IF g_pml[i].pmn87>0 AND NOT cl_null(g_pml[i].pml04) THEN   #MOD-7A0130 modify pmn20->pmn87
              LET l_flag='Y'
              SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pml[i].pml04  #TQC-BC0073 g_pml[l_ac].pml04,l_ac --> i
              IF l_ima915='2' OR l_ima915='3' THEN
                 CALL p500_pmh(g_pml[i].pml04)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pml[i].pml04,g_errno,0)
                    CONTINUE WHILE
                 END IF
              END IF
            LET l_pmm25=''
            SELECT pmm25 INTO l_pmm25 FROM pmm_file WHERE pmm01=tm.pmm01
            IF l_pmm25 >= '1' THEN
                #此採購單號已經存在,且狀況碼不為'開立',所以請重新輸入
                CALL cl_err(tm.pmm01,'mfg3110',0)
                EXIT WHILE
            END IF
            #FUN-C40089---begin
            SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=tm.pmk09
            IF cl_null(g_pnz08) THEN 
               LET g_pnz08 = 'Y'
            END IF 
            IF g_pnz08 = 'N' THEN 
            #IF g_sma.sma112= 'N' THEN 
            #FUN-C40089---end
               IF g_pml[i].pmn31 <=0 OR g_pml[i].pmn31t <=0 THEN
                  CALL cl_err('','axm-627',1)  #FUN-C50076
                  CONTINUE WHILE
               END IF
            END IF
            END IF
        END FOR
#FUN-B90103---add ##&endif
        IF l_flag='Y' THEN        #確認
           IF cl_sure(0,0) THEN
              LET g_success='Y'
              BEGIN WORK
              #-----MOD-A20027---------
              OPEN p500_b_cl2 USING tm.pmk01 
              IF STATUS THEN
                 CALL cl_err("OPEN p500_b_cl2:", STATUS, 1)
                 ROLLBACK WORK
                 CONTINUE WHILE
                 #No.FUN-B80088---增加空白行---


              ELSE
                 FETCH p500_b_cl2 INTO l_pmk18
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(tm.pmk01,SQLCA.sqlcode,1)
                    ROLLBACK WORK
                    CONTINUE WHILE
                 ELSE
                    IF l_pmk18 <> 'Y' THEN 
                       CALL cl_err(tm.pmk01,'mfg3550',1)
                       ROLLBACK WORK
                       CLOSE p500_b_cl2
                       CONTINUE WHILE
                    END IF
              #-----END MOD-A20027-----
#FUN-B90103-----------add-----------
#FUN-B90103----------end------------
                    CALL p500_process()   #產生單身
#FUN-B90103--add##&endif
                    CALL s_showmsg()       #No.FUN-710030
                    IF g_success='Y' THEN
                        COMMIT WORK
                        IF cl_confirm('asf-539') THEN
                          IF s_industry('icd') THEN                      #CHI-920096
                             LET g_msg="apmt540_icd ","'",tm.pmm01,"'"   #CHI-920096
                          ELSE                                           #CHI-920096
                             LET g_msg="apmt540 ","\'",tm.pmm01,"\'"
                          END IF                                         #CHI-920096
                           CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add 
                        END IF
                    ELSE
                        ROLLBACK WORK
                    END IF
                 END IF   #MOD-A20027
              END IF   #MOD-A20027
              CLOSE p500_b_cl2   #MOD-A20027 
           END IF
        END IF
         IF g_success='Y' THEN #MOD-580135
           CLEAR FORM
           CALL g_pml.clear()
           #FUN-B90103---add--
           #FUN-B90103---end--
         END IF #MOD-580135
         EXIT WHILE   #No.MOD-580276
     END WHILE   #No.MOD-580276
 
END FUNCTION
 
FUNCTION p500_set_entry_b()
   CALL cl_set_comp_entry("pmn68,pmn69,pmn31,pmn34,pmn31t",TRUE) #No.FUN-550019
 
   CALL cl_set_comp_entry("pmn81,pmn83,pmn84,pmn85,pmn86,pmn87",TRUE)
 
END FUNCTION
 
FUNCTION p500_set_no_entry_b()
   DEFINE l_smyslip   LIKE smy_file.smyslip,   #MOD-9B0197
          l_smy57     LIKE smy_file.smy57      #MOD-9B0197
   DEFINE l_pnz04 LIKE pnz_file.pnz04, #未取到價格可以人工輸入TQC-BC0108
          l_pnz07 LIKE pnz_file.pnz07  #  取到價格可以人工輸入TQC-BC0108
   IF g_pmk.pmk02 = 'SUB' THEN
      CALL cl_set_comp_entry("pmn68,pmn69,pmn31,pmn34,pmn31t",FALSE)  #No.FUN-550019
   END IF
 
   LET l_smyslip = s_get_doc_no(tm.pmm01)   
   SELECT smy57 INTO l_smy57 FROM smy_file
    WHERE smyslip = l_smyslip       
   IF l_smy57[4,4] = 'N' OR cl_null(l_smy57[4,4]) THEN
      CALL cl_set_comp_entry("pmn68,pmn69",FALSE)
   END IF 
#TQC-BC0108 mark begin
#   IF g_gec07 = 'N' THEN          #No.FUN-560102
#      CALL cl_set_comp_entry("pmn31t",FALSE)
#   ELSE
#      CALL cl_set_comp_entry("pmn31",FALSE)
#   END IF
#TQC-BC0108 mark end 
#TQC-BC0108 add start
   IF NOT cl_null(g_pmk.pmk41) THEN  
          SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 
            FROM pnz_file   
           WHERE pnz01 = g_pmk.pmk41           
   END IF
   IF g_gec07 = 'N' THEN          #No.FUN-560102 
      CALL cl_set_comp_entry("pmn31t",FALSE)
      IF l_pnz07 = 'N' THEN 
         CALL cl_set_comp_entry("pmn31",FALSE) 
      END IF       
   ELSE     	
      CALL cl_set_comp_entry("pmn31",FALSE)
      IF l_pnz07 = 'N' THEN 
         CALL cl_set_comp_entry("pmn31t",FALSE) 
      END IF      
   END IF
#TQC-BC0108 add end 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("pmn83,pmn84,pmn85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("pmn83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("pmn84,pmn81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("pmn86,pmn87",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION p500_pmn68()
  SELECT * INTO g_pom.* FROM pom_file
   WHERE pom01 = g_pml[l_ac].pmn68
   CASE WHEN STATUS = 100                    LET g_errno = 'apm-902'   #No.MOD-4A0356
       WHEN g_pom.pom25 MATCHES '[678]'     LET g_errno = 'mfg3258'
       WHEN g_pom.pom25 = '9'               LET g_errno = 'mfg3259'
       WHEN g_pom.pom25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
       WHEN g_pom.pom18 = 'N'               LET g_errno = 'apm-292'
       OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
#----------------#
#   確     認    #
#----------------#
FUNCTION p500_process()
   DEFINE l_pmp,l_pmo   LIKE type_file.num5 #No.FUN-680136 SMALLINT
   DEFINE l_pmh24       LIKE pmh_file.pmh24  #No.FUN-940083
   DEFINE l_pmc914      LIKE pmc_file.pmc914 #No.FUN-940083
   DEFINE l_flag_1      LIKE type_file.num5  #FUN-9A0065                                                                          
   DEFINE l_pml92       LIKE pml_file.pml92  #FUN-9A0065   
   DEFINE l_sql         LIKE type_file.chr1000     #TQC-B10137
   DEFINE l_pml49       LIKE pml_file.pml49        #TQC-B10137  
   DEFINE l_p           LIKE type_file.chr20

#   IF g_add_po='Y' THEN
#     CALL s_auto_assign_no("apm",tm.pmm01,tm.pmm04,"2","pmm_file","pmm01","","","")
#       RETURNING g_cnt,tm.pmm01
#     IF (NOT g_cnt) THEN RETURN END IF
#     DISPLAY tm.pmm01 TO pmm01
#      CALL p500_pmm()            #產生採購單頭資料(新增)
#TQC-B10137 ----------------STA
      LET l_sql = " SELECT DISTINCT pml49 FROM pmk_file,pml_file ",
                  " WHERE pmk01 = pml01 ",
                  " AND pmk01 = '",tm.pmk01,"'"
      PREPARE p500_pre FROM l_sql
      DECLARE p500_curs CURSOR FOR p500_pre
      FOREACH p500_curs INTO g_pml49
         IF g_add_po='Y' THEN
            LET l_p = tm.pmm01[1,g_doc_len]
            CALL s_auto_assign_no("apm",l_p,tm.pmm04,"2","pmm_file","pmm01","","","")
                           RETURNING g_cnt,tm.pmm01
            IF (NOT g_cnt) THEN CONTINUE FOREACH END IF
            CALL p500_pmm()
#TQC-B10137 ----------------END
           LET l_flag_1 = 0                                                                                                             
           LET l_pml92 = ' '                                                                                                            
          DECLARE p500_pml CURSOR FOR                                                                                                  
              SELECT pml92  FROM pml_file WHERE pml01 =tm.pmk01 AND pml49 = g_pml49                                                                   
          FOREACH p500_pml INTO l_pml92                                                                                                
            IF STATUS THEN                                                                                                             
               CALL cl_err("foreach:",STATUS,1)                                                                                        
               EXIT FOREACH                                                                                                            
            END IF                                                                                                                     
            IF l_pml92 = 'Y' THEN
               CONTINUE FOREACH
            END IF
            #No.MOD-A60086  --Begin
            #LET g_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
            #LET g_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
            #INSERT INTO pmm_file VALUES (g_pmm.*)
            #IF SQLCA.sqlcode THEN
            #   LET g_success='N'
            #   CALL cl_err3("ins","pmm_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            #   RETURN
            #END IF
            #No.MOD-A60086  --End  
            LET l_flag_1 = l_flag_1 + 1
          END FOREACH
          IF l_flag_1 = 0 THEN
             CALL cl_err(tm.pmk01,'apm-134',1)
             RETURN
          END IF
          #No.MOD-A60086  --Begin
          LET g_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
          LET g_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
          LET g_pmm.pmmcrat = g_today     #TQC-B10031     
          LET g_pmm.pmmdate = NULL        #TQC-B10031     
          INSERT INTO pmm_file VALUES (g_pmm.*)
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             CALL cl_err3("ins","pmm_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
             RETURN
          END IF
          #No.MOD-A60086  --End 
      ELSE
        UPDATE pmm_file SET pmmmodu=g_user,pmmdate=g_today,pmm51 = g_pml49     #TQC-B10137 add pmm51
           WHERE pmm01=tm.pmm01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","upd pmm",1)  #No.FUN-660129
           RETURN
        END IF
      END IF
    #----- insert 重要備註檔(單頭)
  #LET l_sql = "SELECT pmp01,pmp02,pmp03,pmp04,pmp05,pmpplant,pmplegal ", #FUN-980006 add pmpplant,pmplegal
   LET l_sql = "SELECT UNIQUE pmp01,pmp02,pmp03,pmp04,pmp05,pmpplant,pmplegal ", #FUN-980006 add pmpplant,pmplegal #MOD-B60069 mod
     #          " FROM pmp_file ",                                 #TQC-B10137  mark
               " FROM pmp_file,pml_file ",                         #TQC-B10137
               " WHERE pmp01 ='",tm.pmk01,"' ",
               "   AND pmp01 = pml01 ",                            #TQC-B10137
               "   AND pml49 = '",g_pml49,"'",                     #TQC-B10137
               "   AND pmp02='0' ",
               " ORDER BY 1"
   PREPARE p500_pmp FROM l_sql
   DECLARE pmp_cs CURSOR FOR p500_pmp    #CURSOR
   SELECT COUNT(*) INTO l_pmp
      FROM pmp_file WHERE pmp01=tm.pmm01 AND pmp02='1'
   IF l_pmp <= 0 THEN
      CALL s_showmsg_init()        #No.FUN-710030
      FOREACH pmp_cs INTO g_pmp.*
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
         LET g_pmp.pmp01=g_pmm.pmm01
         LET g_pmp.pmp02='1'
         INSERT INTO pmp_file VALUES (g_pmp.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            IF g_bgerr THEN
               LET g_showmsg = g_pmp.pmp01,"/",g_pmp.pmp02,"/",g_pmp.pmp03,"/",g_pmp.pmp04
               CALL s_errmsg("pmp01,pmp02,pmp03,pmp04",g_showmsg,"ins pmp",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","pmp_file",g_pmp.pmp01,g_pmp.pmp02,SQLCA.sqlcode,"","ins pmp",1)
            END IF
            RETURN
         END IF
      END FOREACH
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
      LET l_pmp=1
   END IF
    #----- insert 特殊說明檔(單頭)
  #LET l_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal ", #FUN-980006 add pmoplant,pmolegal
   LET l_sql = "SELECT UNIQUE pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal ", #FUN-980006 add pmoplant,pmolegal #MOD-B60069 mod
    #            " FROM pmo_file ",                                 #TQC-B10137  mark
                " FROM pmo_file,pml_file ",                          #TQC-B10137
                " WHERE pmo01 = '",tm.pmk01,"' ",
                "   AND pmo01 = pml01 ",                            #TQC-B10137
                "   AND pml49 = '",g_pml49,"'",                     #TQC-B10137
                "   AND pmo02='0' AND pmo03=0 ",
                " ORDER BY 1"
   PREPARE p500_pmo FROM l_sql
   DECLARE pmo_cs  CURSOR FOR p500_pmo  #CURSOR
   SELECT COUNT(*) INTO l_pmo FROM pmo_file
      WHERE pmo01=g_pmm.pmm01 AND pmo02='1' AND pmo03='0'
   IF l_pmo <= 0 THEN
      CALL s_showmsg_init()        #No.FUN-710030
      FOREACH pmo_cs INTO g_pmo.*          #單身 ARRAY 填充
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
         LET g_pmo.pmo01=tm.pmm01
         LET g_pmo.pmo02='1'
         LET g_pmo.pmo03=0
         INSERT INTO pmo_file VALUES (g_pmo.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            IF g_bgerr THEN
               LET g_showmsg = g_pmo.pmo01,"/",g_pmo.pmo02,"/",g_pmo.pmo03,"/",g_pmo.pmo04,"/",g_pmo.pmo05
               CALL s_errmsg("pmo01,pmo02,pmo03,pmo04,pmo05",g_showmsg,"ins pmo",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","pmo_file",g_pmo.pmo01,g_pmo.pmo02,SQLCA.sqlcode,"","ins pmo",1)
            END IF
            RETURN
         END IF
      END FOREACH
      LET l_pmo=1
   END IF
    #----- insert 採購單身檔
   LET l_nn=0
   IF g_add_po='Y' THEN        #產生序號
      LET l_nn=0
   ELSE
      SELECT MAX(pmn02) INTO l_nn FROM pmn_file WHERE pmn01=tm.pmm01
      IF cl_null(l_nn) THEN LET l_nn = 0 END IF
   END IF
   FOR g_cnt=1 TO g_rec_b
#TQC-B10137 -----------STA
      SELECT pml49 INTO l_pml49 FROM pml_file 
       WHERE pml01 = tm.pmk01
         AND pml02 = g_pml[g_cnt].pml02
      IF l_pml49 <> g_pml49 THEN
          CONTINUE FOR
      END IF
#TQC-B10137 -----------END
      #---判斷是否有替代
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima44 INTO g_ima44 FROM ima_file              #取採購單位
            WHERE ima01=g_pml[g_cnt].pml04
 
         CALL s_chk_va_setting(g_pml[g_cnt].pml04)
            RETURNING g_flag,g_ima906,g_ima907
 
         CALL s_chk_va_setting1(g_pml[g_cnt].pml04)
            RETURNING g_flag,g_ima908
          #計算pmn20,pmn07的值,檢查數量的合理性
         CALL p500_set_origin_field(g_cnt)
      END IF
      LET l_flag1='Y'
      LET l_k=0
      SELECT COUNT(*) INTO l_k FROM tmp_file
         WHERE tmp01=g_cnt AND tmp06='Y'
      IF l_k>0 THEN                       #表有替代
         LET l_k1=0
         SELECT SUM(tmp09) INTO l_k1 FROM tmp_file
            WHERE tmp01=g_cnt AND tmp06='Y'
         IF g_pml[g_cnt].pmn20-l_k1=0 THEN LET l_flag1='N' END IF
      END IF
      IF g_pml[g_cnt].pmn20>0 AND NOT cl_null(g_pml[g_cnt].pmn20) AND l_flag1='Y' THEN
         #-----產生單身資料
         CALL p500_pmn()
       IF g_pml2.pml92 = 'Y' THEN   #FUN-9A0065                                                                                     
       ELSE                         #FUN-9A0065   
         LET l_nn=l_nn+1
         CALL p500_pmn()
         # check 請購量+容許量
         IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
            IF p500_available_qty(g_pmn.pmn20/g_pmn.pmn62*g_pmn.pmn09,    #MOD-940133
               g_pmn.pmn25,g_pmn.pmn04)
            THEN
               LET g_success='N'
               RETURN
            END IF
         END IF
         IF cl_null(g_pmn.pmn68) THEN
            LET g_pmn.pmn69 = NULL
         END IF
 
         SELECT azi04 INTO t_azi04 FROM azi_file     #No.
            WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  #原幣
         LET g_pmn.pmn88 = g_pmn.pmn31 *g_pmn.pmn87
         LET g_pmn.pmn88t= g_pmn.pmn31t*g_pmn.pmn87 
         #MOD-B50018 add --start--
         LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
         LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
         #MOD-B50018 add --end--
         IF g_gec07 = 'N' THEN 
            LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
            LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  #MOD-B50018 add
         ELSE
            LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
            LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  #MOD-B50018 add 
         END IF
        #MOD-B50018 mark --start--
        #LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
        #LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
        #MOD-B50018 mark --end--
         LET l_pmh24 = NULL
         LET l_pmc914 = NULL
         SELECT pmh24 INTO l_pmh24 FROM pmh_file
            WHERE pmh01 = g_pmn.pmn04
              AND pmh02 = g_pmm.pmm09
              AND pmh13 = g_pmm.pmm22
              AND pmh21 = " " AND pmh22 = '1'
              AND pmh23 = ' '                                             #No.CHI-960033
              AND pmhacti ='Y'
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
         IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF  #TQC-9B0203
         LET g_pmn.pmn73 = ' '   #NO.FUN-960130
         LET g_pmn.pmn012 = ' '   #NO.TQC-A70004
         CALL s_schdat_pmn78(g_pmn.pmn41,g_pmn.pmn012,g_pmn.pmn43,g_pmn.pmn18,   #FUN-C10002
                                         g_pmn.pmn32) RETURNING g_pmn.pmn78      #FUN-C10002
         INSERT INTO pmn_file VALUES (g_pmn.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            IF g_bgerr THEN
               LET g_showmsg = g_pmn.pmn01,"/",g_pmn.pmn02
               CALL s_errmsg("pmn01,pmn02",g_showmsg,"ins pmn #1",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","pmn_file",g_pmn.pmn01,g_pmn.pmn02,SQLCA.sqlcode,"","ins pmn #1",1)
            END IF
            RETURN
         END IF
         #-----特殊說明檔
         CALL p500_pmo()
         #-----採購單總金額
         CALL p500_pmm40()
         #-----請購單身狀況及已轉數量
         CALL p500_pml()
         #-----UPDATE Blanket PO 已轉採購量
         IF NOT cl_null(g_pml[g_cnt].pmn68) THEN
            CALL p500_pon(g_pml[g_cnt].pmn68,g_pml[g_cnt].pmn69)
         END IF
       END IF                         #FUN-9A0065 
      END IF
      #---如有替代insert 單身
      IF l_k >0 THEN
         DECLARE p500_tmp CURSOR FOR SELECT * FROM tmp_file
            WHERE tmp01=g_cnt AND tmp06='Y'
         FOREACH p500_tmp INTO l_tmp.*
            CALL p500_pmn()           #先call原來的單身,再將不同之部份修改
            IF g_pml2.pml92 = 'Y' THEN   #FUN-9A0065                                                                                
               CONTINUE FOREACH          #FUN-9A0065                                                                                
            END IF                       #FUN-9A0065            
            LET l_nn=l_nn+1             #項次+1
            CALL p500_pmn1()          #將不同之部份修改
            # check 請購量+容許量
            IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
               IF p500_available_qty(g_pmn.pmn20/g_pmn.pmn62*g_pmn.pmn09,     #MOD-940133
                  g_pmn.pmn25,g_pmn.pmn04)
               THEN
                  LET g_success='N'
                  RETURN
               END IF
            END IF
            IF cl_null(g_pmn.pmn68) THEN
               LET g_pmn.pmn69 = NULL
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file     #No.
               WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  #原幣
            LET g_pmn.pmn88 = g_pmn.pmn31 *g_pmn.pmn87
            LET g_pmn.pmn88t= g_pmn.pmn31t*g_pmn.pmn87
            #MOD-B50018 add --start--
            LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
            LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
            #MOD-B50018 add --end--
            IF g_gec07 = 'N' THEN 
               LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
               LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  #MOD-B50018 add 
            ELSE
               LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
               LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  #MOD-B50018 add
            END IF
           #MOD-B50018 mark --start--
           #LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
           #LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
           #MOD-B50018 mark --end--
            LET l_pmh24 = NULL
            LET l_pmc914 = NULL
            SELECT pmh24 INTO l_pmh24 FROM pmh_file
               WHERE pmh01 = g_pmn.pmn04
                 AND pmh02 = g_pmm.pmm09
                 AND pmh13 = g_pmm.pmm22
                 AND pmh21 = " " AND pmh22 = '1'
                 AND pmh23 = ' '                                             #No.CHI-960033
                 AND pmhacti ='Y'
            IF l_pmh24 = 'Y' THEN
               LET g_pmn.pmn89 = 'Y'
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
            IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF  #TQC-9B0203
            LET g_pmn.pmn73 = ' '   #NO.FUN-960130
            LET g_pmn.pmn012 = ' '   #NO.TQC-A70004
            CALL s_schdat_pmn78(g_pmn.pmn41,g_pmn.pmn012,g_pmn.pmn43,g_pmn.pmn18,   #FUN-C10002
                                            g_pmn.pmn32) RETURNING g_pmn.pmn78      #FUN-C10002
            INSERT INTO pmn_file VALUES (g_pmn.*)
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               IF g_bgerr THEN
                  LET g_showmsg = g_pmn.pmn01,"/",g_pmn.pmn02
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"ins pmn #2",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","pmn_file",g_pmn.pmn01,g_pmn.pmn02,SQLCA.sqlcode,"","ins pmn #1",1)
               END IF
               RETURN
            END IF
            #-----特殊說明檔
            CALL p500_pmo()
            #-----採購單總金額
            CALL p500_pmm40()
            #-----請購單身狀況及已轉數量
            CALL p500_pml()
         END FOREACH
      END IF
   END FOR
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
      LET g_i=g_i
    #----- update 請購單頭狀況碼及狀況異動日期
      UPDATE pmk_file SET pmk25 = '2'
       WHERE pmk01 = tm.pmk01
         AND pmk01 IN (SELECT pml01 FROM pml_file
                        WHERE pml01=tm.pmk01 AND pml16='2')
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","upd pmk25",1)  #No.FUN-660129
         RETURN
      END IF
    END FOREACH                          #TQC-B10137
END FUNCTION
 
FUNCTION  p500_pml()     #update 請購單身之已轉採購數量及狀況碼
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pml07   LIKE pml_file.pml07
 
      LET l_sum=0
      #          數量/替代率*對請購換算率
      SELECT SUM(pmn20/pmn62*pmn121) INTO l_sum FROM pmn_file
       WHERE pmn24=tm.pmk01 AND pmn25=g_pml[g_cnt].pml02
         AND pmn16<>'9' #
      #No.FUN-BB0086--add--begin--
      SELECT pml07 INTO l_pml07 FROM pml_file WHERE pml01=tm.pmk01 AND pml02=g_pml[g_cnt].pml02
      LET l_sum = s_digqty(l_sum,l_pml07)
      #No.FUN-BB0086--add--end--
      IF cl_null(l_sum) THEN LET l_sum=0 END IF  #No.MOD-8B0196 add
      UPDATE pml_file SET pml16='2',pml21=l_sum
       WHERE pml01=tm.pmk01 AND pml02=g_pml[g_cnt].pml02
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         IF g_bgerr THEN
            LET g_showmsg = tm.pmk01,"/",g_pml[g_cnt].pml02
            CALL s_errmsg("pml01,pml02",g_showmsg,"upd pml",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[g_cnt].pml02,SQLCA.sqlcode,"","upd pml",1)
         END IF
         RETURN
      END IF
END FUNCTION

#FUN-B90103----------------add--------------
#FUN-B90103------end----------------------
#update Blanket PO單身之已轉採購數量及狀況碼
FUNCTION p500_pon(p_pmn68,p_pmn69)
  DEFINE p_pmn68   LIKE pmn_file.pmn68
  DEFINE p_pmn69   LIKE pmn_file.pmn69
  DEFINE l_pon20   LIKE pon_file.pon20
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pon07   LIKE pon_file.pon07

      #NO.FUN-A80001--begin
      IF g_pmm.pmm04>g_pon.pon19 THEN 
         IF g_bgerr THEN
            CALL s_errmsg("","","","apm-815",1)
         ELSE
            CALL cl_err3("","","","","","","apm-815",1)
         END IF           
         LET g_success='N'
         RETURN 
      END IF 
      #NO.FUN-A80001--end 
      LET l_sum=0
      #數量/替代率*對請購換算率
      SELECT SUM(pmn20/pmn62*pmn70) INTO l_sum FROM pmn_file
       WHERE pmn68=p_pmn68 AND pmn69=p_pmn69
         AND pmn16<>'9'    #取消(Cancel)
      #FUN-C20048--add--start--
       SELECT pon07 INTO l_pon07 FROM pon_file
        WHERE pon01=p_pmn68 AND pon02=p_pmn69
      #FUN-C20048--add--end--
       LET l_sum = s_digqty(l_sum,l_pon07)    #FUN-910088--add--
      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
      #是否超過未轉量
      SELECT pon20 INTO l_pon20 FROM pon_file
       WHERE pon01 = p_pmn68 AND pon02 = p_pmn69
      IF cl_null(l_pon20) THEN LET l_pon20 = 0 END IF
      IF l_pon20 - l_sum < 0 THEN
         LET g_success='N'
         IF g_bgerr THEN
            CALL s_errmsg("","","","apm-905",1)
         ELSE
            CALL cl_err3("","","","","","","apm-905",1)
         END IF
         RETURN
      END IF
      #UPDATE 單身狀況碼及已轉量
      UPDATE pon_file SET pon16='2',pon21=l_sum
       WHERE pon01=p_pmn68 AND pon02=p_pmn69
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         IF g_bgerr THEN
            LET g_showmsg = p_pmn68,"/",p_pmn69
            CALL s_errmsg("pon01,pon02",g_showmsg,"upd pon",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","pon_file",p_pmn68,p_pmn69,SQLCA.sqlcode,"","upd pon",1)
         END IF
         RETURN
      END IF
      #UPDATE 單頭狀況碼
      UPDATE pom_file SET pom25='2'
        WHERE pom01=p_pmn68 AND pom01 NOT IN
             (SELECT pon01 FROM pon_file WHERE pon01=p_pmn68
                          AND pon16 NOT IN ('2'))
      IF SQLCA.sqlcode THEN
         LET g_success='N'
          IF g_bgerr THEN
             CALL s_errmsg("","","upd pom",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("upd","pom_file",p_pmn68,"",SQLCA.sqlcode,"","upd pom",1)
          END IF
         RETURN
      END IF
END FUNCTION
 
FUNCTION  p500_pmm40()     #update 採購單頭的總金額
   DEFINE l_pmm40  LIKE pmm_file.pmm40,   #MOD-890171
          l_pmm40t LIKE pmm_file.pmm40t
 
  SELECT SUM(pmn88),SUM(pmn88t) #MOD-730046  #TQC-730062
     INTO l_pmm40,l_pmm40t
     FROM pmn_file
    WHERE pmn01 = tm.pmm01
   LET l_pmm40 = cl_digcut(l_pmm40,t_azi04)  #MOD-B10025 mod t_azi05->t_azi04
   LET l_pmm40t= cl_digcut(l_pmm40t,t_azi04) #MOD-B10025 mod t_azi05->t_azi04
   UPDATE pmm_file SET pmm40 = l_pmm40,
                       pmm40t= l_pmm40t
    WHERE pmm01 = tm.pmm01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      IF g_bgerr THEN
         CALL s_errmsg("pmm01",tm.pmm01,"upd pmm40",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","upd pmm40",1)
      END IF
      RETURN
   END IF
END FUNCTION
 
FUNCTION  p500_pmm()       #產生採購單頭資料
  DEFINE l_pmc14 LIKE pmc_file.pmc14,
         l_pmc15 LIKE pmc_file.pmc15,
         l_pmc16 LIKE pmc_file.pmc16,
         l_pmc17 LIKE pmc_file.pmc17,
         l_pmc47 LIKE pmc_file.pmc47,
         l_pmc49 LIKE pmc_file.pmc49,
         l_pmc22 LIKE pmc_file.pmc22,
         g_t1    LIKE oay_file.oayslip,             #No.FUN-540027  #No.FUN-680136 VARCHAR(05) #MOD-D10194 add ,
         l_slip  LIKE smy_file.smyslip,             #MOD-D10194 add
         l_pmm02 LIKE pmm_file.pmm02                #MOD-D10194 add
 
    LET g_pmm.pmm01=tm.pmm01           #單號
    LET g_t1=s_get_doc_no(g_pmm.pmm01) #No.FUN-540027
   #MOD-D10194---add---S
    CALL s_get_doc_no(g_pmm.pmm01) RETURNING l_slip
    SELECT smy72 INTO l_pmm02 FROM smy_file
     WHERE smyslip = l_slip
    IF NOT cl_null(l_pmm02) AND l_pmm02 <> 'SUB' THEN
       LET g_pmm.pmm02=l_pmm02
    ELSE
   #MOD-D10194---add---S
       LET g_pmm.pmm02=g_pmk.pmk02        #單據性質
    END IF                                #MOD-D10194 add
    IF tm.pmk02 = 'TAP' THEN
       LET g_pmm.pmm02  ='TAP'             #單據性質
       LET g_pmm.pmm901 = 'Y'
       LET g_pmm.pmm902 = 'N'
       LET g_pmm.pmm905 = 'N'
       LET g_pmm.pmm906 = 'Y'
    ELSE
       LET g_pmm.pmm901 = 'N'         #非三角貿易代買單據
       LET g_pmm.pmm905 = 'N'         #非三角貿易代買單據
       LET g_pmm.pmm906 = ' '         #MOD-8B0138 add
    END IF
    LET g_pmm.pmm03= 0                #更動序號    #MOD-940366 
    LET g_pmm.pmm04=tm.pmm04          #採購日期
    #LET g_pmm.pmm05=''               #專案號碼-> no use   #MOD-A20078
    LET g_pmm.pmm05=g_pmk.pmk05       #專案號碼            #MOD-A20078
    LET g_pmm.pmm07=g_pmk.pmk07       #單據分類
    LET g_pmm.pmm08=g_pmk.pmk08       #PBI批號
    LET g_pmm.pmm09=tm.pmk09          #供應廠商
    LET g_pmm.pmm10=g_pmk.pmk10       #送貨地址
    LET g_pmm.pmm11=g_pmk.pmk11       #帳單地址
    LET g_pmm.pmm12=tm.pmm12          #採購員
    LET g_pmm.pmm13=tm.pmm13          #採購部門
    LET g_pmm.pmm14=g_pmk.pmk14       #收貨部門
    #LET g_pmm.pmm15=g_pmk.pmk15       #確認人 #MOD-C80255 mark
    LET g_pmm.pmm16=g_pmk.pmk16       #運送方式
    LET g_pmm.pmm17=g_pmk.pmk17       #代理商
    LET g_pmm.pmm18="N"
    LET g_pmm.pmm20=g_pmk.pmk20       #付款方式
    LET g_pmm.pmm21=tm.pmm21          #稅別       #MOD-5A0338
    LET g_pmm.pmm22=tm.pmm22          #幣別
    SELECT smyapr INTO g_pmm.pmmmksg
      FROM smy_file WHERE smyslip=g_t1
    IF STATUS THEN LET g_pmm.pmmmksg='N' END IF
    LET g_pmm.pmm25='0'			#狀況碼
    LET g_pmm.pmm26=NULL              #理由碼
    LET g_pmm.pmm27=g_today           #狀況異動日期
    LET g_pmm.pmm28=g_pmk.pmk28       #會計分類
    LET g_pmm.pmm29=g_pmk.pmk29       #會計科目
    LET g_pmm.pmm30=g_pmk.pmk30       #驗收單列印否
   #IF cl_null(g_pmm.pmm31) THEN                     #MOD-D20150 mark 
    IF cl_null(g_pmm.pmm31) OR g_pmm.pmm31 = 0 THEN  #MOD-D20150 add
       SELECT azn02 INTO g_pmm.pmm31 FROM azn_file    #MOD-860116
        WHERE azn01 = g_pmm.pmm04                     #MOD-860116
    END IF
    IF cl_null(g_pmm.pmm32) THEN
       SELECT azn04 INTO g_pmm.pmm32 FROM azn_file    #MOD-860116
        WHERE azn01 = g_pmm.pmm04                     #MOD-860116
    END IF
    LET g_pmm.pmm40=0                 #總金額
    LET g_pmm.pmm40t=0                #總含稅金額  FUN-610018
    LET g_pmm.pmm401=0                #代買總金額
    LET g_pmm.pmm41=g_pmk.pmk41       #價格條件
    LET g_pmm.pmm42=g_pmk.pmk42       #匯率
    LET g_pmm.pmm43=tm.pmm43          #稅別       #TQC-690109 add
    LET g_pmm.pmm44='1' #No:7713      #稅處理
    LET g_pmm.pmm45=g_pmk.pmk45       #可用/不可用
    LET g_pmm.pmm46=0                 #預付比率
    LET g_pmm.pmm47=0                 #預付金額
    LET g_pmm.pmm48=0                 #已結帳金額
    LET g_pmm.pmm49='N'               #預付發票否
    LET g_pmm.pmm909="2"              #No.FUN-630006
    LET g_pmm.pmmprsw=g_pmk.pmkprsw   #列印抑制
    LET g_pmm.pmmprno=0               #已列印次數
    LET g_pmm.pmmprdt=NULL            #最後列印日期
    LET g_pmm.pmmsseq = 0             #已簽順序
    LET g_pmm.pmmsmax = 0             #應簽順序
    LET g_pmm.pmmacti='Y'             #資料有效碼
    LET g_pmm.pmmuser=g_user          #No:9564
    LET g_pmm.pmmgrup=g_grup          #資料所有部門  #MOD-650060 add
    LET g_pmm.pmmmodu=' '             #資料修改者
    LET g_pmm.pmmdate=g_today         #最近修改日期   #MOD-650056
    LET g_pmm.pmmplant = g_plant  #FUN-980006 add
    LET g_pmm.pmmlegal = g_legal  #FUN-980006 add
#---後續default 判斷
    SELECT pmc14,pmc15,pmc16,pmc17,pmc22,pmc47,pmc49
      INTO l_pmc14,l_pmc15,l_pmc16,l_pmc17,l_pmc22,l_pmc47,l_pmc49
      FROM pmc_file
     WHERE pmc01 = g_pmm.pmm09
    #CHI-C30126---begin
    IF  g_pmm.pmm09 <> g_pmk.pmk09 THEN
       LET g_pmm.pmm41 = l_pmc49
       LET g_pmm.pmm20 = l_pmc17
       SELECT pma06 INTO g_pmm.pmm46 FROM pma_file
                   WHERE pma01 = g_pmm.pmm20
       LET g_pmm.pmm10 = l_pmc15
       LET g_pmm.pmm11 = l_pmc16
    END IF
    #CHI-C30126---end
    IF cl_null(g_pmm.pmm41) THEN
       LET g_pmm.pmm41 = l_pmc49
    END IF
    IF cl_null(g_pmm.pmm20) THEN
       LET g_pmm.pmm20 = l_pmc17
       SELECT pma06 INTO g_pmm.pmm46 FROM pma_file
                   WHERE pma01 = g_pmm.pmm20
    END IF
    IF cl_null(g_pmm.pmm21) THEN
       LET g_pmm.pmm21 = l_pmc47  #慣用稅別
       CALL p500_pmm21()
    END IF
    IF cl_null(g_pmm.pmm22) THEN
       LET g_pmm.pmm22 = l_pmc22
    END IF
    IF g_pmm.pmm10 IS NULL OR g_pmm.pmm10 = ' ' THEN
       LET g_pmm.pmm10 = l_pmc15
    END IF
    IF g_pmm.pmm11 IS NULL OR g_pmm.pmm11 = ' ' THEN
       LET g_pmm.pmm11 = l_pmc16
    END IF
    IF g_aza.aza17 = g_pmm.pmm22 THEN   #本幣
       LET g_pmm.pmm42 = 1
    ELSE
       CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) #FUN-640012
       RETURNING g_pmm.pmm42
    END IF
#    LET g_pmm.pmm51 = ' '      #NO.FUN-960130              #TQC-B10137 mark
    LET g_pmm.pmm51 = g_pml49                               #TQC-B10137
    LET g_pmm.pmmpos = 'N'      #NO.FUN-960130
END FUNCTION
 
FUNCTION p500_pmn()      #產生單身資料
   DEFINE l_pon07    LIKE pon_file.pon07
   DEFINE l_ima491   LIKE ima_file.ima491   #No.TQC-640132
   DEFINE l_ima49    LIKE ima_file.ima49    #No.TQC-640132
   DEFINE l_rtz08    LIKE rtz_file.rtz08    #FUN-B40098
   DEFINE l_rtz07    LIKE rtz_file.rtz07    #FUN-B60150
 
  #---取出請購單身資料
   SELECT * INTO g_pml2.* FROM pml_file
    WHERE pml01=tm.pmk01 AND pml02=g_pml[g_cnt].pml02
  #---產生採購單身資料
   LET g_pmn.pmn63 = g_pml2.pml91           #No.FUN-920183
#MOD-B10129 mod --start--
#&ifndef STD
   LET  g_pmn.pmn01=tm.pmm01              #採購單號
   #LET  g_pmn.pmn011=g_pmm.pmm02          #采購性質  #MOD-970265 add    #MOD-A50046
   SELECT pmm02 INTO g_pmn.pmn011 FROM pmm_file    #MOD-A50046
     WHERE pmm01 = tm.pmm01   #MOD-A50046
#FUN-B90103------add----
#FUN-B90103------end----
   LET  g_pmn.pmn02=l_nn                  #序號
   LET  g_pmn.pmn03=g_pml2.pml03          #詢價單號
   LET  g_pmn.pmn04=g_pml[g_cnt].pml04    #料號
   LET  g_pmn.pmn041=g_pml2.pml041        #品名
   LET  g_pmn.pmn05=g_pml2.pml05          #APS單號
   LET  g_pmn.pmn06 = ' '                 #MOD-CB0181 add
   SELECT  pmh04 INTO g_pmn.pmn06 FROM pmh_file
           WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
             AND pmh13 = g_pmm.pmm22
             AND pmh21 = " "                                             #CHI-860042                                                
             AND pmh22 = '1'                                             #CHI-860042
             AND pmh23 = ' '                                             #No.CHI-960033
             AND pmhacti = 'Y'                                           #CHI-910021
   LET  g_pmn.pmn07=g_pml[g_cnt].pmn07    #採購單位
   LET  g_pmn.pmn930=g_pml2.pml930        #成本中心 #FUN-670051
   LET  g_pmn.pmn83=g_pml[g_cnt].pmn83
   LET  g_pmn.pmn84=g_pml[g_cnt].pmn84
   LET  g_pmn.pmn85=g_pml[g_cnt].pmn85
   LET  g_pmn.pmn80=g_pml[g_cnt].pmn80
   LET  g_pmn.pmn81=g_pml[g_cnt].pmn81
   LET  g_pmn.pmn82=g_pml[g_cnt].pmn82
#FUN-B90103--------add------------
#FUN-B90103--------end-----------
  #IF cl_null(g_pml[g_cnt].pmn86) THEN             #MOD-C50127 mark
   IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN  #MOD-C50127
       #LET g_pml[g_cnt].pmn86 = g_pml[l_ac].pmn07 #MOD-C90132 mark
       #LET g_pml[g_cnt].pmn87 = g_pml[l_ac].pmn20 #MOD-C90132 mark
       LET g_pml[g_cnt].pmn86 = g_pml[g_cnt].pmn07 #MOD-C90132 add
       LET g_pml[g_cnt].pmn87 = g_pml[g_cnt].pmn20 #MOD-C90132 add
   END IF
#FUN-B90103----&endif
   LET  g_pmn.pmn86=g_pml[g_cnt].pmn86
   LET  g_pmn.pmn87=g_pml[g_cnt].pmn87
   LET  g_pmn.pmn88=g_pml[g_cnt].pmn31 * g_pml[g_cnt].pmn87
   LET  g_pmn.pmn88t=g_pml[g_cnt].pmn31t * g_pml[g_cnt].pmn87
   SELECT azi04 INTO t_azi04 FROM azi_file    
      WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  
   #MOD-B50018 add --start--
   LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
   LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
   #MOD-B50018 add --end--
   IF g_gec07 = 'N' THEN 
      LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04) #MOD-B50018 add 
   ELSE
      LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  #MOD-B50018 add
   END IF
  #MOD-B50018 mark --start--
  #LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88 ,t_azi04)  
  #LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,t_azi04)  
  #MOD-B50018 mark --end--
   LET  g_pmn.pmn08=g_pml2.pml08          #庫存單位
   IF g_pml[g_cnt].pml04[1,4] <> 'MISC' THEN
   CALL s_umfchk(g_pml[g_cnt].pml04,g_pml[g_cnt].pmn07,g_pml2.pml08)
        RETURNING l_flag,g_pmn.pmn09      #取換算率(採購對庫存)
#FUN-B90103--------add----
#FUN-B90103--------end----
   IF l_flag=1 THEN
       ####Modify: 98/11/15 ----------單位換算率抓不到 -----####
       CALL cl_err('pmn07/pml08: ','abm-731',1)
       LET g_success ='N'
   END IF
   END IF
   LET  g_pmn.pmn11=g_pml2.pml11          #凍結碼
   CALL s_umfchk(g_pml[g_cnt].pml04,g_pml[g_cnt].pmn07,
         g_pml[g_cnt].pml07)
   RETURNING l_flag,g_pmn.pmn121                #取換算率
   LET  g_pmn.pmn122=g_pml2.pml12         #no use-> 專案代號 00/04/18
   LET g_pmn.pmn96 = g_pml2.pml121
   LET g_pmn.pmn97 = g_pml2.pml122
   LET g_pmn.pmn98 = g_pml2.pml90
   IF cl_null(g_pmn.pmn122) THEN LET g_pmn.pmn122=' ' END IF    #No:8841
   LET  g_pmn.pmn123=g_pml2.pml123        #No use
   LET g_pmn.pmn100 = g_pml2.pml06   #FUN-D40042 備註
 
 
   IF cl_null(g_pmn.pmn123) THEN
      SELECT pmh07 INTO g_pmn.pmn123 FROM pmh_file
       WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
         AND pmh13 = g_pmm.pmm22
         AND pmh21 = " "                                             #CHI-860042                                                    
         AND pmh22 = '1'                                             #CHI-860042
         AND pmh23 = ' '                                             #No.CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021
   END IF
 
   LET  g_pmn.pmn13=g_pml2.pml13          #超短交限率
   LET  g_pmn.pmn14=g_pml2.pml14          #部份交貨否
   LET  g_pmn.pmn15=g_pml2.pml15          #提前交貨否
   LET  g_pmn.pmn16='0'
   IF l_k=0 THEN                          #判斷是否有替代
      LET  g_pmn.pmn20=g_pml[g_cnt].pmn20 #數量
   ELSE
      LET  g_pmn.pmn20=g_pml[g_cnt].pmn20-l_k1
      #采購數量變了，但是采購單位和計價單位沒有變化，計價數量也要變才對
   #TQC-BC0145 add begin
      IF g_pmn.pmn86 = g_pmn.pmn07 THEN 
         LET g_pmn.pmn87 = g_pmn.pmn20
      ELSE 
      #多單位情況
      
      END IF 
   #TQC-BC0145 add end
   END IF
   LET  g_pmn.pmn23=' '                   #送貨地址
   LET  g_pmn.pmn24=tm.pmk01              #請購單號
   LET  g_pmn.pmn25=g_pml[g_cnt].pml02    #序號
   LET  g_pmn.pmn30=g_pml2.pml30          #標準價格
   LET  g_pmn.pmn31=g_pml[g_cnt].pmn31    #單價(未稅) BugNo.7259
   LET  g_pmn.pmn90=g_pml[g_cnt].pmn90    #取出單價(未稅)  #CHI-820014 
 
   IF cl_null(g_pmm.pmm43) THEN
        SELECT pmm43 INTO g_pmm.pmm43 FROM pmm_file
         WHERE pmm01 = g_pmn.pmn01
        IF SQLCA.SQLCODE THEN LET g_pmm.pmm43 = 0.0 END IF
   END IF
   LET  g_pmn.pmn31t=g_pml[g_cnt].pmn31t  #單價(含稅) No.FUN-550019
   IF cl_null(g_pmn.pmn31t) THEN LET g_pmn.pmn31t = 0 END IF  #No.FUN-550019
 
   IF g_pml[g_cnt].pmn34 = g_pml2.pml34 THEN
      LET  g_pmn.pmn33 = g_pml2.pml33
      LET  g_pmn.pmn34 = g_pml2.pml34   
      LET  g_pmn.pmn35 = g_pml2.pml35   
   ELSE
                                             #採購價差
      IF cl_null(g_pml[g_cnt].pmn34) THEN    #到廠日期
         LET  g_pmn.pmn34=g_pml2.pml34
      ELSE
         LET  g_pmn.pmn34=g_pml[g_cnt].pmn34
      END IF
      IF g_pmn.pmn34 < tm.pmm04 THEN
         LET g_pmn.pmn34 = tm.pmm04
      END IF
      SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
      WHERE ima01=g_pmn.pmn04
      CALL s_aday(g_pmn.pmn34,-1,l_ima49) RETURNING g_pmn.pmn33
      CALL s_aday(g_pmn.pmn34,1,l_ima491) RETURNING g_pmn.pmn35
   END IF
 
   LET  g_pmn.pmn36=NULL                  #最近確認交貨日期
   LET  g_pmn.pmn37=NULL                  #最後一次到廠日期
   LET  g_pmn.pmn38=g_pml2.pml38          #可用/不可用
   LET  g_pmn.pmn40=g_pml2.pml40          #會計科目
   LET  g_pmn.pmn401=g_pml2.pml401        #會計科目二
   LET  g_pmn.pmn41=g_pml2.pml41          #工單號碼
   LET  g_pmn.pmn42=g_pml2.pml42          #替代碼
   LET  g_pmn.pmn43=g_pml2.pml43          #作業序號
   LET  g_pmn.pmn431=g_pml2.pml431        #下一站作業序號
   LET  g_pmn.pmn44 = g_pmn.pmn31 * g_pmm.pmm42  #本幣單價
   CALL cl_digcut(g_pmn.pmn44,g_azi03) RETURNING g_pmn.pmn44 #MOD-B50018 add
   LET  g_pmn.pmn45=NULL                  #NO:7190
   LET  g_pmn.pmn50=0                     #交貨量
   LET  g_pmn.pmn51=0                     #在驗量
   LET  g_pmn.pmn53=0                     #入庫量
   SELECT ima35,ima36 INTO g_pmn.pmn52,g_pmn.pmn54 FROM ima_file
    WHERE ima01=g_pmn.pmn04
  #FUN-B60150 Begin---
  ##FUN-B40098 Begin---
  #IF g_azw.azw04 = '2' AND g_pmm.pmm51 = '3' THEN
  #   SELECT rtz08 INTO l_rtz08 FROM rtz_file
  #    WHERE rtz01 = g_pmm.pmmplant
  #   IF NOT cl_null(l_rtz08) THEN
  #      LET g_pmn.pmn52 = l_rtz08
  #      LET g_pmn.pmn54 = ' '
  #      LET g_pmn.pmn56 = ' '
  #   END IF
  #END IF
  ##FUN-B40098 End-----
   IF g_azw.azw04 = '2' THEN
      #FUN-C90049 mark begin---
      #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
      # WHERE rtz01 = g_pmm.pmmplant
      #FUN-C90049 mark end-----
      CALL s_get_defstore(g_pmm.pmmplant,g_pmn.pmn04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add

      IF (g_pmm.pmm51 = '3' OR (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2'))THEN
         IF NOT cl_null(l_rtz08) THEN
            LET g_pmn.pmn52 = l_rtz08
            LET g_pmn.pmn54 = ' '
            LET g_pmn.pmn56 = ' '
         END IF
      END IF
      IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
         IF NOT cl_null(l_rtz07) THEN
            LET g_pmn.pmn52 = l_rtz07
            LET g_pmn.pmn54 = ' '
            LET g_pmn.pmn56 = ' '
         END IF
      END IF
   END IF
  #FUN-B60150 End-----
   IF cl_null(g_pmn.pmn52) THEN LET g_pmn.pmn52 = ' ' END IF   #MOD-A20115
   IF cl_null(g_pmn.pmn54) THEN LET g_pmn.pmn54 = ' ' END IF   #MOD-A20115
   LET  g_pmn.pmn55=0                     #驗退量
   LET  g_pmn.pmn56=' '                   #批號
   LET  g_pmn.pmn57=0                     #超短交量
   LET  g_pmn.pmn58=0                     #無交期性採購單已轉量
   LET  g_pmn.pmn59=' '                   #退貨單號
   LET  g_pmn.pmn60=' '                   #項次
   LET  g_pmn.pmn61=g_pmn.pmn04           #被替代料號
   LET  g_pmn.pmn62=1                     #替代率
  #LET  g_pmn.pmn63='N'                   #急料否    #TQC-AB0070   mark
   LET  g_pmn.pmn67=g_pml2.pml67
   LET  g_pmn.pmnplant = g_plant  #FUN-980006 add
   LET  g_pmn.pmnlegal = g_legal  #FUN-980006 add
   LET g_pmn.pmn88  = g_pmn.pmn31  * g_pmn.pmn87   #未稅金額
   LET g_pmn.pmn88t = g_pmn.pmn31t * g_pmn.pmn87   #含稅金額
  #LET g_pmn.pmn919 = g_pml[g_cnt].pmn919    #計畫批號     #FUN-A80150 add
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file   #No.MOD-8B0273 add
      WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  
   #MOD-B50018 add --start--
   LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
   LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
   #MOD-B50018 add --end--
   IF g_gec07 = 'N' THEN 
      LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  #MOD-B50018 add 
   ELSE
      LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  #MOD-B50018 add 
   END IF
  #MOD-B50018 mark --start--
  #LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88 ,t_azi04)  
  #LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,t_azi04)  
  #MOD-B50018 mark --end--
 
   #因為上面的采購數量可能發生改變，所以如果單價含稅的話，未稅單價要重新算
   #Blanket PO
   IF NOT cl_null(g_pml[g_cnt].pmn68) THEN
      LET  g_pmn.pmn68=g_pml[g_cnt].pmn68
      LET  g_pmn.pmn69=g_pml[g_cnt].pmn69
      SELECT pon07 INTO l_pon07 FROM pon_file
       WHERE pon01 = g_pmn.pmn68 AND pon02 = g_pmn.pmn69
      #採購與Blanket PO單位轉換因子
      CALL s_umfchk(g_pml[g_cnt].pml04,g_pml[g_cnt].pmn07,
                    l_pon07) RETURNING l_flag,g_pmn.pmn70
      IF l_flag THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","","abm-731",1)
         ELSE
            CALL cl_err3("","","","","abm-731","","",1)
         END IF
         LET g_success ='N'
      END IF
   END IF
   SELECT ima15 INTO g_pmn.pmn64 FROM ima_file
    WHERE ima01=g_pml[g_cnt].pml04
   IF cl_null(g_pmn.pmn64) OR g_pmn.pmn64 NOT MATCHES '[YN]' THEN
      LET  g_pmn.pmn64='N'
   END IF
   LET g_pmn.pmn65='1'                   #一般/代買
END FUNCTION
 
FUNCTION p500_pmn1()      #單身資料-替代部份
   LET  g_pmn.pmn02=l_nn                        #序號 #TQC-BC0145 ADD 
   LET g_pmn.pmn04=l_tmp.tmp02                  #料號
   LET g_pmn.pmn041=l_tmp.tmp03                 #品名規格
   SELECT ima25 INTO g_pmn.pmn08                     #庫存單位
     FROM ima_file
    WHERE ima01=l_tmp.tmp02
   LET g_pmn.pmn06=' '
   SELECT pmh04 INTO g_pmn.pmn06 FROM pmh_file  #廠商料號
    WHERE pmh01=l_tmp.tmp02 AND pmh02=tm.pmk09 AND pmh13=tm.pmm22
      AND pmh21 = " "                                             #CHI-860042                                                       
      AND pmh22 = '1'                                             #CHI-860042
      AND pmh23 = ' '                                             #No.CHI-960033
      AND pmhacti = 'Y'                                           #CHI-910021
   LET g_pmn.pmn07=l_tmp.tmp04                  #採購單位
   CALL s_umfchk(l_tmp.tmp02,l_tmp.tmp04,g_pmn.pmn08)
    RETURNING l_flag,g_pmn.pmn09                #取換算率(採購對庫存)
   IF l_flag=1 THEN
      #### ------採購對庫存無法轉換 ------####
      IF g_bgerr THEN
         CALL s_errmsg("","","tmp04/pmn08: ","mfg7002",1)
      ELSE
         CALL cl_err3("","","","","mfg7002","","tmp04/pmn08: ",1)
      END IF
      LET g_success ='N'
   END IF
   CALL s_overate(l_tmp.tmp02) RETURNING g_pmn.pmn13   #超短交限率
   LET g_pmn.pmn20=l_tmp.tmp07                  #數量
   #替代料的計價數量要重新計算，不能直接用原來的計價數量
   #TQC-BC0145 add begin
   IF g_pmn.pmn86 = g_pmn.pmn07 THEN 
      LET g_pmn.pmn87 = g_pmn.pmn20
   ELSE 
   #多單位情況
      
   END IF   
   #TQC-BC0145 add end
   SELECT imb118 INTO g_pmn.pmn30 FROM imb_file
    WHERE imb01=l_tmp.tmp02                     #標準價格
   IF cl_null(g_pmn.pmn30) THEN LET g_pmn.pmn30=0 END IF
 
   LET g_pmn.pmn31=l_tmp.tmp08                  #單價 (未稅) BugNo.7259
   IF cl_null(g_pmm.pmm43) THEN
        SELECT pmm43 INTO g_pmm.pmm43 FROM pmm_file
         WHERE pmm01 = g_pmn.pmn01
        IF SQLCA.SQLCODE THEN LET g_pmm.pmm43 = 0.0 END IF
   END IF
                                                #單價(含稅) BugNo.7259
   LET g_pmn.pmn31t=l_tmp.tmp08t                #含稅單價
   IF cl_null(g_pmn.pmn31t) THEN LET g_pmn.pmn31t = 0 END IF
 
#  LET g_pmn.pmn88  = g_pmn.pmn31  * g_pmn.pmn20   #未稅金額   #CHI-B70039 mark
#  LET g_pmn.pmn88t = g_pmn.pmn31t * g_pmn.pmn20   #含稅金額   #CHI-B70039 mark
   LET g_pmn.pmn88  = g_pmn.pmn87  * g_pmn.pmn31   #CHI-B70039
   LET g_pmn.pmn88t = g_pmn.pmn87  * g_pmn.pmn31t  #CHI-B70039
   SELECT azi04 INTO t_azi04 FROM azi_file    
      WHERE azi01 = g_pmm.pmm22  AND aziacti= 'Y'  
   #MOD-B50018 add --start--
   LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  
   LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  
   #MOD-B50018 add --end--
   IF g_gec07 = 'N' THEN 
      LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88t = cl_digcut( g_pmn.pmn88t,t_azi04)  #MOD-B50018 add 
   ELSE
      LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
      LET g_pmn.pmn88  = cl_digcut( g_pmn.pmn88 ,t_azi04)  #MOD-B50018 add 
   END IF
  #MOD-B50018 mark --start--
  #LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88 ,t_azi04)  
  #LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,t_azi04)  
  #MOD-B50018 mark --end--
 
   LET g_pmn.pmn42='S'                          #替代碼
   LET g_pmn.pmn44=l_tmp.tmp08*g_pmm.pmm42      #本幣單價
   CALL cl_digcut(g_pmn.pmn44,g_azi03) RETURNING g_pmn.pmn44 #MOD-B50018 add
   LET g_pmn.pmn62=l_tmp.tmp05                  #替代率
   SELECT ima15 INTO g_pmn.pmn64 FROM ima_file  #保稅否
    WHERE ima01=l_tmp.tmp02
   IF cl_null(g_pmn.pmn64) OR g_pmn.pmn64 NOT MATCHES '[YN]' THEN
      LET  g_pmn.pmn64='N'
   END IF
   LET g_pmn.pmn90=l_tmp.tmp10           #CHI-820014   
END FUNCTION
 
FUNCTION  p500_pmo()      #請購單號
   LET l_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal ", #FUN-980006 add pmoplant,pmolegal
                " FROM pmo_file ",
                " WHERE pmo01 ='",tm.pmk01,"' ",
                "   AND pmo02='0' AND pmo03=",g_pml[g_cnt].pml02,
                " ORDER BY 1"
   PREPARE p500_pmo2 FROM l_sql
   DECLARE pmo2_cs CURSOR FOR p500_pmo2  #CURSOR
   FOREACH pmo2_cs INTO g_pmo.*          #單身 ARRAY 填充
     LET g_pmo.pmo01=tm.pmm01
     LET g_pmo.pmo02='1'
     LET g_pmo.pmo03=l_nn
     INSERT INTO pmo_file VALUES (g_pmo.*)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        IF g_bgerr THEN
           LET g_showmsg = g_pmo.pmo01,"/",g_pmo.pmo02,"/",g_pmo.pmo03,"/",g_pmo.pmo04,"/",g_pmo.pmo05
           CALL s_errmsg("pmo01,pmo02,pmo03,pmo04,pmo05",g_showmsg,"ins pmo2",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","pmo_file",g_pmo.pmo01,g_pmo.pmo02,SQLCA.sqlcode,"","ins pmo2",1)
        END IF
        RETURN
     END IF
   END FOREACH
END FUNCTION
 
FUNCTION  p500_pmk01()    #請購單號
DEFINE
    l_pml    LIKE type_file.num5,          #No.FUN-680136 SMALLINT
    l_pml01  LIKE pml_file.pml01,
    l_pmc03  LIKE pmc_file.pmc03,
    l_gen02  LIKE gen_file.gen02
 
    LET g_errno=' '
    SELECT pmk_file.* INTO g_pmk.*
        FROM pmk_file
        WHERE pmk01=tm.pmk01 AND pmkacti='Y'
    IF SQLCA.sqlcode THEN
        LET g_errno = 'mfg3137'
        RETURN
    ELSE
        IF g_pmk.pmk18 != 'Y' THEN              #FUN-550038
           LET g_errno='mfg3550'
           RETURN
        END IF
 
        IF g_pmk.pmk25 NOT MATCHES '[12]' THEN
           LET g_errno='apm-293'
           RETURN
        END IF
         IF g_aza.aza23 matches '[ Nn]' THEN                 #No.MOD-540043
          IF g_pmk.pmkmksg MATCHES '[yY]' AND ( g_pmk.pmksmax > g_pmk.pmksseq )
          THEN  LET g_errno='axm-175'
                   RETURN
          END IF
        END IF
 
        IF g_pmk.pmk18 = 'X' THEN LET g_errno = '9021' RETURN END IF
 
        SELECT count(*) INTO g_cnt FROM pml_file
               WHERE pml01=tm.pmk01
        IF g_cnt=0 THEN LET g_errno = 'mfg3111' RETURN END IF
    END IF
 
    IF NOT cl_null(g_pmk.pmk09) THEN
       SELECT pmc03 INTO g_pmc03  #廠商名稱
         FROM pmc_file
        WHERE pmc01=g_pmk.pmk09
       LET tm.pmk09=g_pmk.pmk09
    END IF
    IF NOT cl_null(g_pmk.pmk12) THEN
       SELECT gen02 INTO l_gen02  #員工姓名
         FROM gen_file
        WHERE gen01=g_pmk.pmk12
       LET tm.pmk12=g_pmk.pmk12
    END IF
    LET tm.pmm22=g_pmk.pmk22
    IF NOT cl_null(g_pmk.pmk21) THEN
       LET tm.pmm21=g_pmk.pmk21
       LET tm.pmm43=g_pmk.pmk43
       SELECT gec07 INTO g_gec07 FROM gec_file
        WHERE gec01 = tm.pmm21 AND gec011 = '1'
       DISPLAY BY NAME tm.pmm21,tm.pmm43
       DISPLAY g_gec07 TO FORMONLY.gec07
    END IF
    LET tm.pmk02 = g_pmk.pmk02
    CALL s_prtype(tm.pmk02) RETURNING tm.desc
    DISPLAY tm.pmk02 TO pmk02
    DISPLAY tm.desc TO FORMONLY.desc
    DISPLAY g_pmk.pmk09 TO pmk09
    #MOD-D60057 add beg
    IF NOT cl_null(g_pmk.pmk09) THEN 
       DISPLAY g_pmc03     TO FORMONLY.pmc03
    END IF 
    #MOD-D60057 add end
    DISPLAY BY NAME g_pmk.pmk12
    DISPLAY l_gen02     TO FORMONLY.gen02
    DISPLAY g_pmk.pmk22 TO pmm22
END FUNCTION
 
FUNCTION p500_pmmsign()   #簽核等級相關欄位
   LET g_chr = ' '
   SELECT COUNT(*) INTO g_pmm.pmmsmax        #應簽人數
    FROM azc_file WHERE azc01 = g_pmm.pmmsign
   IF SQLCA.sqlcode OR g_pmm.pmmsmax=0 OR g_pmm.pmmsmax IS NULL THEN
      LET g_chr='E'
   END IF
END FUNCTION
 
FUNCTION p500_pmk09()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05,
          l_pmc22     LIKE pmc_file.pmc22,
          l_pmc30     LIKE pmc_file.pmc30,       #MOD-7A0101 add
          l_pmc47     LIKE pmc_file.pmc47        #No.FUN-550019
 
   LET g_errno=' '
   SELECT pmcacti,pmc05,pmc03,pmc22,pmc47,pmc30              #MOD-7A0101 modify 
     INTO l_pmcacti,l_pmc05,g_pmc03,l_pmc22,l_pmc47,l_pmc30  #MOD-7A0101 modify
     FROM pmc_file
    WHERE pmc01=tm.pmk09
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
                                LET g_pmc03=NULL
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
                                LET g_pmc03=NULL
        WHEN l_pmc05='3'        LET g_errno='aap-033'
                                LET g_pmc03=NULL
        WHEN l_pmc30  ='2' LET g_errno = 'apm-420'      #付款商 #MOD-7A0101 add
   END CASE
   DISPLAY g_pmc03 TO FORMONLY.pmc03
   IF tm.pmm22 IS NULL OR tm.pmm22<>l_pmc22 THEN  #MOD-7B0140 modify
      LET tm.pmm22 = l_pmc22
      DISPLAY BY NAME tm.pmm22
   END IF
      LET tm.pmm21 = l_pmc47
      DISPLAY BY NAME tm.pmm21
      SELECT gec04,gec07 INTO tm.pmm43,g_gec07 FROM gec_file
       WHERE gec01 = tm.pmm21 AND gec011 = '1'
      DISPLAY BY NAME tm.pmm43
      DISPLAY g_gec07 TO FORMONLY.gec07
END FUNCTION
 
FUNCTION p500_pmm21()  #稅別
   DEFINE  l_gec04   LIKE gec_file.gec04,
           l_gecacti LIKE gec_file.gecacti
	
   LET g_errno = " "
   SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07  #No.FUN-550019
     FROM gec_file
    WHERE gec01 = tm.pmm21
      AND gec011='1'  #進項
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                  LET l_gec04 = 0
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(l_gec04) THEN
      LET tm.pmm43 = l_gec04
      DISPLAY BY NAME tm.pmm43
   END IF
   DISPLAY g_gec07 TO FORMONLY.gec07
END FUNCTION
 
FUNCTION p500_pmm22()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT azi03,aziacti,azi04,azi05 INTO t_azi03,l_aziacti,t_azi04,t_azi05 FROM azi_file   #No.FUN-550019   #No.CHI-6A0004 #MOD-6C0170
    WHERE azi01 = tm.pmm22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION p500_pmm12()  #人員
         DEFINE l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti
 
	  LET g_errno = ' '
	  SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
            FROM gen_file WHERE gen01 = tm.pmm12
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gen02 TO FORMONLY.gen02_1
          LET tm.pmm13=l_gen03
          DISPLAY BY NAME tm.pmm13
END FUNCTION
 
FUNCTION p500_pmm13()    #部門
         DEFINE l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti
 
	  LET g_errno = ' '
	  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
				  WHERE gem01 = tm.pmm13
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION
 
FUNCTION p500_pmn07(p_unit)  #單位
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION p500_pmh(l_part)           #料件供應商
   DEFINE  l_pmhacti LIKE pmh_file.pmhacti,
           l_pmh05   LIKE pmh_file.pmh05,   #No.MOD-580276
           l_part    LIKE pml_file.pml04,
           l_chr     LIKE gfe_file.gfe01   #No.FUN-680136 VARCHAR(04)
 
   LET g_errno=' '
   LET l_chr = l_part[1,4]
   IF l_chr[1,4] = 'MISC' THEN RETURN END IF
   SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05 FROM pmh_file   #No.MOD-580276
    WHERE pmh01=l_part AND pmh02=tm.pmk09 AND pmh13=tm.pmm22
      AND pmh21 = " " AND pmh22 = '1'   #MOD-830135
      AND pmh23 = ' '                                             #No.CHI-960033
      AND pmhacti = 'Y'                                           #CHI-910021
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg0031'
         LET l_pmhacti = NULL
      WHEN l_pmhacti='N'
         LET g_errno = '9028'
      WHEN l_pmh05 MATCHES '[12]'   #No.MOD-580276
         LET g_errno = 'mfg3043'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION p500_tot()           #計算金額合計
DEFINE  i     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
        l_tot  LIKE pmm_file.pmm40,
        lt_tot LIKE pmm_file.pmm40t  #No.FUN-610018
 
  LET g_tot=0
  LET g_tott=0
  FOR i=1 TO g_pml.getLength()
    LET l_tot=g_pml[i].pmn31 * g_pml[i].pmn87   
    LET lt_tot=g_pml[i].pmn31t * g_pml[i].pmn87 
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    IF cl_null(lt_tot) THEN LET lt_tot = 0 END IF
    LET g_tot=g_tot+l_tot
    LET g_tott=g_tott+lt_tot
  END FOR
  IF cl_null(g_tot) THEN LET g_tot = 0 END IF
  IF cl_null(g_tott) THEN LET g_tott = 0 END IF
  DISPLAY g_tot TO FORMONLY.tot
  DISPLAY g_tott TO FORMONLY.tott
END FUNCTION
 
#------------------#
#    替      代    #
#------------------#
FUNCTION p500_s(p_ac)
   DEFINE p_ac                  LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          i,j                   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          old_seq               LIKE pml_file.pml02,
          old_part              LIKE pml_file.pml04,
          old_pmn041            LIKE pmn_file.pmn041,
          old_qty               LIKE pmn_file.pmn20,
          old_pmn07             LIKE pmn_file.pmn07,
          l_bmd05,l_bmd06	LIKE type_file.dat,     #No.FUN-680136 DATE
          l_tot                 LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          new DYNAMIC ARRAY OF RECORD
              new_part			LIKE ima_file.ima01,    #No.MOD-490217
              ima02                     LIKE ima_file.ima02,    #FUN-560074
              unit                      LIKE gfe_file.gfe01,    #No.FUN-680136 VARCHAR(4)
              new_rate			LIKE pmn_file.pmn62,    #No.FUN-680136 DECIMAL(6,3)   #MOD-990162 pmn52-->pmn62
              new_yes 			LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
              new_qty 			LIKE pmn_file.pmn20,   #No.FUN-680136 INTEGER   #MOD-990162 num10-->pmn20
              price                     LIKE oeb_file.oeb13,    #No.FUN-680136 DECIMAL(20,6) #FUN-4C0011
              price_t                   LIKE oeb_file.oeb13,    #No.FUN-680136 DECIMAL(20,6) #No.FUN-550019
              price_o                   LIKE pmn_file.pmn90,    #CHI-820014 add   #MOD-990162 pmn10-->pmn90
              new_qty3			LIKE pmn_file.pmn20   #No.FUN-680136 INTEGER   #MOD-990162 num10-->pmn20
          END RECORD
   DEFINE l_ima915               LIKE ima_file.ima915   #FUN-710060 add
 
   OPEN WINDOW p500_sw AT 10,10 WITH FORM "apm/42f/apmp500s"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("apmp500s")
 
   WHILE TRUE
      IF INT_FLAG THEN LET INT_FLAG=0
         CLOSE WINDOW p500_sw
         EXIT WHILE
         RETURN END IF
      LET old_seq=g_pml[p_ac].pml02
      LET old_part=g_pml[p_ac].pml04
      LET old_pmn041=g_pml[p_ac].pml041
      LET old_qty=g_pml[p_ac].pmn20
      LET old_pmn07=g_pml[p_ac].pmn07
      DISPLAY BY NAME old_seq
      DISPLAY BY NAME old_part
      DISPLAY BY NAME old_pmn041
      DISPLAY BY NAME old_qty
      DISPLAY BY NAME old_pmn07
      IF g_pml[p_ac].pmn20<=0 THEN
         CALL cl_err('','mfg3374',0)
         CONTINUE WHILE
      END IF
 
      DECLARE p500_sc CURSOR FOR
              #SELECT bmd04,ima02,ima44,bmd07,tmp06,tmp07,tmp08,tmp08t,tmp10,tmp09,  #No.FUN-550019   #MOD-990162   #MOD-A70082
              SELECT bmd04,'','',bmd07,tmp06,tmp07,tmp08,tmp08t,tmp10,tmp09,  #No.FUN-550019   #MOD-990162   #MOD-A70082
                     bmd03,bmd05,bmd06
                #FROM bmd_file,ima_file, OUTER tmp_file   #MOD-A70082
                FROM bmd_file, OUTER tmp_file   #MOD-A70082
               WHERE bmd01 = g_pml[p_ac].pml04 AND bmd02='2'
                     #AND ima01=g_pml[p_ac].pml04 AND tmp_file.tmp01=p_ac   #MOD-A70082
                     AND tmp_file.tmp01=p_ac   #MOD-A70082
                     AND tmp_file.tmp02=bmd04
                     AND bmdacti = 'Y'                                           #CHI-910021
               ORDER BY bmd03
      FOR i = 1 TO 10 INITIALIZE new[i].* TO NULL END FOR
      LET i = 1
      FOREACH p500_sc INTO new[i].*,j,l_bmd05,l_bmd06
        IF STATUS THEN CALL cl_err('foreach',STATUS,0) CONTINUE WHILE END IF
        #-----MOD-A70082---------
        SELECT ima02,ima44 INTO new[i].ima02,new[i].unit FROM ima_file
         WHERE ima01 = new[i].new_part
        #-----END MOD-A70082-----
        IF new[i].new_rate = 0 THEN LET new[i].new_rate = 1 END IF
        IF tm.pmm04<l_bmd05 THEN CONTINUE FOREACH END IF      #判斷生效日
        IF tm.pmm04>l_bmd06 AND NOT cl_null(l_bmd06) THEN     #判斷失效日
           CONTINUE FOREACH
        END IF
        LET i = i + 1
        IF i > 10 THEN EXIT FOREACH END IF
      END FOREACH
      CALL SET_COUNT(i-1)
      IF i = 0 THEN CALL cl_err('','mfg2624',0) CONTINUE WHILE END IF
      LET l_tot = 0
      FOR g_cnt = 1 TO 10                #計算合計
          IF new[g_cnt].new_part IS NOT NULL AND
             new[g_cnt].new_yes = "Y" AND new[g_cnt].new_qty > 0 THEN
             LET l_tot = l_tot + new[g_cnt].new_qty3
          END IF
      END FOR
      DISPLAY BY NAME l_tot
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
 
         BEFORE INPUT
            CALL p500s_set_entry_b()
            CALL p500s_set_no_entry_b()
 
         BEFORE ROW
            LET i = ARR_CURR()
            LET j = SCR_LINE()
#TQC-BB0250  begin    mark
#         BEFORE FIELD new_part
#            IF NOT cl_null(new[i].new_part) THEN NEXT FIELD NEXT END IF
#TQC-BB0250  end
         AFTER FIELD new_part
            IF new[i].new_part IS NOT NULL THEN
               SELECT ima02,ima44,1
                       INTO new[i].ima02,new[i].unit,new[i].new_rate
                       FROM ima_file
                      WHERE ima01=new[i].new_part
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",new[i].new_part,"",STATUS,"","sel ima:",0)  #No.FUN-660129
               END IF
               DISPLAY new[i].ima02,new[i].unit,new[i].new_rate
                  TO s_new[j].ima02,s_new[j].unit,s_new[j].new_rate
            END IF
 
         BEFORE FIELD new_qty
            IF new[i].new_yes NOT MATCHES '[YN]' THEN
               NEXT FIELD new_yes
            ELSE
               IF new[i].new_yes = 'N' THEN
                  LET new[i].new_qty = 0
                  DISPLAY new[i].new_qty TO s_new[j].new_qty
                  NEXT FIELD new_qty3
               ELSE
                  #如選定料件,判斷料件供應商
                   SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=new[i].new_part
                   IF l_ima915='2' OR l_ima915='3' THEN 
                     CALL p500_pmh(new[i].new_part)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(new[i].new_part,g_errno,0)
                        LET new[i].new_yes='N'
                        DISPLAY new[i].new_yes TO s_new[j].new_yes
                        NEXT FIELD new_yes
                     ELSE
                        # default 單價
                        LET g_term = g_pmk.pmk41 
                        LET g_price = g_pmk.pmk20
                        IF cl_null(g_term) THEN
                         SELECT pmc49
                          INTO g_term
                         FROM pmc_file
                         WHERE pmc01 = tm.pmk09
                        END IF   
                        IF cl_null(g_price) THEN
                          SELECT pmc17
                           INTO g_price
                          FROM pmc_file
                          WHERE pmc01 = tm.pmk09
                        END IF    
                        IF cl_null(new[i].price) OR new[i].price=0 THEN   #MOD-940131 mark #FUN-9C0083 取消mark
                           CALL s_defprice_new(new[i].new_part,tm.pmk09,tm.pmm22,tm.pmm04,new[i].new_qty,'',tm.pmm21,tm.pmm43,"1",new[i].unit,'',
                                           g_term,g_price,g_plant) 
                              RETURNING new[i].price,new[i].price_t,
                                        g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
  
                            IF NOT cl_null(g_errno) THEN
                               CALL cl_err('',g_errno,1)
                            END IF
                           IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
                           CALL cl_digcut(new[i].price,t_azi03)   #No.FUN-550019  #No.CHI-6A0004
                              RETURNING new[i].price
                           CALL cl_digcut(new[i].price_t,t_azi03)  #No.CHI-6A0004
                                RETURNING new[i].price_t
                           DISPLAY new[i].price TO s_new[j].price
                           DISPLAY new[i].price_t TO s_new[j].price_t
                           LET new[i].price_o = new[i].price  #CHI-820014 add
                           DISPLAY new[i].price_o TO s_new[j].price_o  #CHI-820014 add
                        END IF
                     END IF
                  END IF
               END IF
           END IF
 
         AFTER FIELD new_qty             #替代量
            IF new[i].new_qty=0 OR cl_null(new[i].new_qty) THEN
               NEXT FIELD new_qty
            END IF
            LET new[i].new_qty3 = new[i].new_qty / new[i].new_rate
            DISPLAY new[i].new_qty3 TO s_new[j].new_qty3
            LET l_tot = 0
            FOR g_cnt = 1 TO 10                #計算合計
               IF new[g_cnt].new_part IS NOT NULL AND
                  new[g_cnt].new_yes = "Y" AND new[g_cnt].new_qty > 0 THEN
                  LET l_tot = l_tot + new[g_cnt].new_qty3
               END IF
            END FOR
            DISPLAY BY NAME l_tot
            IF l_tot> g_pml[p_ac].pmn20 THEN
               CALL cl_err('','apm-238',1)
               NEXT FIELD new_qty
            END IF
 
         AFTER FIELD price              #單價
            IF cl_null(new[i].price) OR new[i].price=0 THEN
               NEXT FIELD price
            END IF
            CALL cl_digcut(new[i].price,t_azi03) RETURNING new[i].price  #No.CHI-6A0004
            LET new[i].price_t = new[i].price * ( 1 + tm.pmm43/100)
            CALL cl_digcut(new[i].price_t,t_azi03) RETURNING new[i].price_t  #No.CHI-6A0004
            DISPLAY new[i].price TO s_new[j].price      #No.FUN-610018
            DISPLAY new[i].price_t TO s_new[j].price_t  #No.FUN-610018
 
         AFTER FIELD price_t
            IF cl_null(new[i].price_t) OR new[i].price_t=0 THEN
               NEXT FIELD price_t
            END IF
            IF NOT cl_null(new[i].price_t) THEN
               CALL cl_digcut(new[i].price_t,t_azi03) RETURNING new[i].price_t  #No.CHI-6A0004
               LET new[i].price = new[i].price_t / ( 1 + tm.pmm43 / 100)                                                            
               CALL cl_digcut(new[i].price,t_azi03) RETURNING new[i].price
               DISPLAY new[i].price TO s_new[j].price
               DISPLAY new[i].price_t TO s_new[j].price_t  #No.FUN-610018
            END IF
 
         AFTER INPUT                    #按ESC之後判斷
            IF INT_FLAG THEN
               LET INT_FLAG=0
               EXIT INPUT
               END IF
            LET l_tot=0
            FOR i = 1 TO 10                #計算合計
               IF new[i].new_part IS NOT NULL AND
                  new[i].new_yes = "Y" AND new[i].new_qty > 0 THEN
                  LET l_tot = l_tot + new[i].new_qty3
               END IF
            END FOR
            DISPLAY BY NAME l_tot
            IF l_tot> g_pml[p_ac].pmn20 THEN
               CALL cl_err('','mfg6202',1)
               NEXT FIELD new_qty
            END IF
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()        #No.FUN-710030
            FOR i = 1 TO 10
               IF g_success="N" THEN
                  LET g_totsuccess="N"
                  LET g_success="Y"
               END IF
               IF new[i].new_part IS NOT NULL THEN         #存入資料
                  SELECT COUNT(*) INTO g_cnt FROM tmp_file
                   WHERE tmp01=p_ac AND
                         tmp02=new[i].new_part AND
                         tmp04=new[i].unit  AND
                         tmp05=new[i].new_rate AND
                         tmp06=new[i].new_yes AND
                         tmp08=new[i].price
                  IF g_cnt>0 THEN
                     UPDATE tmp_file
                        SET tmp06=new[i].new_yes,
                            tmp07=new[i].new_qty,
                            tmp08=new[i].price,
                            tmp08t=new[i].price_t,      #No.FUN-550019
                            tmp09=new[i].new_qty3
                      WHERE tmp01=p_ac AND
                            tmp02=new[i].new_part AND
                            tmp04=new[i].unit  AND
                            tmp05=new[i].new_rate AND
                            tmp06=new[i].new_yes AND
                            tmp08=new[i].price
                     IF STATUS THEN
                        LET g_success ='N'
                        IF g_bgerr THEN
                           LET g_showmsg = p_ac,"/",new[i].new_part,"/",new[i].unit,"/",new[i].new_rate,
                                           "/",new[i].new_yes,"/",new[i].price
                           CALL s_errmsg("tmp01,tmp02,tmp04,tmp05,tmp06,tmp08",g_showmsg,"upd tmp",SQLCA.sqlcode,1)
                           CONTINUE FOR
                        ELSE
                           CALL cl_err3("upd","tmp_file",p_ac,new[i].new_part,STATUS,"","upd tmp",1)
                           EXIT FOR
                        END IF
                     END IF
                  ELSE
                     INSERT INTO tmp_file VALUES (p_ac,new[i].*)
                     IF STATUS THEN
                        LET g_success ='N'
                        IF g_bgerr THEN
                           CALL s_errmsg("tmp01",p_ac,"ins tmp",STATUS,1)
                           CONTINUE FOR
                        ELSE
                           CALL cl_err3("ins","tmp_file",p_ac,"",STATUS,"","ins tmp",1)
                           EXIT FOR
                        END IF
                     END IF
                  END IF
               END IF
            END FOR
            IF g_totsuccess="N" THEN
               LET g_success="N"
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("grid01","AUTO")       #No.FUN-6B0032
 
      END INPUT
      CLOSE WINDOW p500_sw
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN
               COMMIT WORK
               RETURN
            ELSE
               ROLLBACK WORK
               RETURN
            END IF
   END WHILE
END FUNCTION
 
FUNCTION p500_available_qty(p_qty,p_pmn25,p_item) #數量,請購單號項次,料件編號
DEFINE   p_pmn25  LIKE  pmn_file.pmn25            #(採購-庫存因子*採購數量)
DEFINE   p_item   LIKE  pmn_file.pmn04
DEFINE   p_qty    LIKE  pmn_file.pmn20,
         l_pmn20  LIKE  pmn_file.pmn20,
         l_over   LIKE  pml_file.pml20,   #No.FUN-680136 DECIMAL(13,3)
         l_ima07  LIKE  ima_file.ima07,
         l_pml20  LIKE  pml_file.pml20,
         l_pml09  LIKE  pml_file.pml09,   #MOD-940133
         l_pnn09  LIKE  pnn_file.pnn09,   #MOD-940133
         l_pnn08  LIKE  pnn_file.pnn08,   #MOD-940133
         l_pnn17  LIKE  pnn_file.pnn17    #MOD-940133
  DEFINE l_sum      LIKE pnn_file.pnn09   #CHI-880016
 
   LET l_pmn20 = 0
          #採購量/替代率*(採購單位/請購單位的轉換率)
   SELECT SUM(pmn20/pmn62*pmn09) INTO l_pmn20 FROM pmn_file     #MOD-940133
    WHERE pmn24=tm.pmk01    #請購單
      AND pmn25=p_pmn25     #請購序號
      AND pmn16<>'9'        #取消(Cancel)
   IF STATUS OR cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
 
   LET l_sum = 0
   DECLARE pnn_cur CURSOR FOR
     SELECT pnn09,pnn08,pnn17 FROM pnn_file
       WHERE pnn01 = tm.pmk01
         AND pnn02 = p_pmn25
   FOREACH pnn_cur INTO l_pnn09,l_pnn08,l_pnn17
     SELECT pml09 INTO l_pml09 FROM pml_file
       WHERE pml01 = tm.pmk01 
         AND pml02 = p_pmn25
     LET l_sum = l_sum + ((l_pnn09/l_pnn08*l_pnn17)*l_pml09)
   END FOREACH
 #----------------與請購互相勾稽 -------------------------------------
   SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
    WHERE ima01=p_item
   SELECT pml20,pml09 INTO l_pml20,l_pml09 FROM pml_file  #請購數量      #MOD-940133
    WHERE pml01=tm.pmk01
      AND pml02=p_pmn25
 
   CASE
   WHEN l_ima07='A'  #計算可容許的數量
        LET l_over=l_pml20 * (g_sma.sma341/100)
   WHEN l_ima07='B'
        LET l_over=l_pml20 * (g_sma.sma342/100)
   WHEN l_ima07='C'
        LET l_over=l_pml20 * (g_sma.sma343/100)
   OTHERWISE
        LET l_over=0
   END CASE
 
   LET l_pml20 = l_pml20 * l_pml09   #MOD-940133
   LET l_over = l_over * l_pml09   #MOD-940133
 
   IF p_qty+l_pmn20+l_sum>    #本筆採購量+已轉採購量+已於apmp570產生底稿   #CHI-880016
      (l_pml20+l_over) THEN   #請購量+容許量
#CHI-A70049---mark---start---
     #DISPLAY p_qty
     #DISPLAY l_pmn20
     #DISPLAY l_pml20
     #DISPLAY l_over
#CHI-A70049---mark---end---
       CALL cl_err(p_qty,'mfg3425',1)   #MOD-490284以彈跳視窗顯示警告訊息
      IF g_sma.sma33='R'    #reject
         THEN
         RETURN -1
      END IF
   END IF
   RETURN 0
END FUNCTION
 
FUNCTION p500s_set_entry_b()
 
   CALL cl_set_comp_entry("price,price_t",TRUE)
 
END FUNCTION
 
FUNCTION p500s_set_no_entry_b()
 
   IF g_gec07 = 'N' THEN      #No.FUN-560102
      CALL cl_set_comp_entry("price_t",FALSE)
   ELSE
      CALL cl_set_comp_entry("price",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION p500_set_required()
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_required("pmn83,pmn85,pmn80,pmn82",TRUE)
   END IF
 IF g_sma.sma115='Y' THEN  #MOD-840625   add
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_pml[l_ac].pmn80) THEN
      CALL cl_set_comp_required("pmn82",TRUE)
   END IF
   IF NOT cl_null(g_pml[l_ac].pmn83) THEN
      CALL cl_set_comp_required("pmn85",TRUE)
   END IF
 END IF            #MOD-840625 add
 
END FUNCTION
 
FUNCTION p500_set_no_required()
 
  CALL cl_set_comp_required("pmn83,pmn84,pmn85,pmn80,pmn81,pmn82,pmn86,pmn87",FALSE)
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION p500_du_data_to_correct()
 
   IF cl_null(g_pml[l_ac].pmn80) THEN
      LET g_pml[l_ac].pmn81 = NULL
      LET g_pml[l_ac].pmn82 = NULL
   END IF
 
   IF cl_null(g_pml[l_ac].pmn83) THEN
      LET g_pml[l_ac].pmn84 = NULL
      LET g_pml[l_ac].pmn85 = NULL
   END IF
 
   IF cl_null(g_pml[l_ac].pmn86) THEN
      LET g_pml[l_ac].pmn87 = NULL
   END IF
 
   DISPLAY BY NAME g_pml[l_ac].pmn81
   DISPLAY BY NAME g_pml[l_ac].pmn82
   DISPLAY BY NAME g_pml[l_ac].pmn84
   DISPLAY BY NAME g_pml[l_ac].pmn85
   DISPLAY BY NAME g_pml[l_ac].pmn86
   DISPLAY BY NAME g_pml[l_ac].pmn87
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION p500_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima44  LIKE ima_file.ima44,
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
 
    LET l_item = g_pml[l_ac].pml04
 
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
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
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
       LET g_pml[l_ac].pmn83=l_unit2
       LET g_pml[l_ac].pmn84=l_fac2
       LET g_pml[l_ac].pmn85=l_qty2
       LET g_pml[l_ac].pmn85 = s_digqty(g_pml[l_ac].pmn85,g_pml[l_ac].pmn83)   #No.FUN-BB0086
       LET g_pml[l_ac].pmn80=l_unit1
       LET g_pml[l_ac].pmn81=l_fac1
       LET g_pml[l_ac].pmn82=l_qty1
       LET g_pml[l_ac].pmn82 = s_digqty(g_pml[l_ac].pmn82,g_pml[l_ac].pmn80)   #No.FUN-BB0086
       LET g_pml[l_ac].pmn86=l_unit3
       LET g_pml[l_ac].pmn87=l_qty3
       LET g_pml[l_ac].pmn87 = s_digqty(g_pml[l_ac].pmn87,g_pml[l_ac].pmn86)   #No.FUN-BB0086
END FUNCTION
 
FUNCTION p500_set_pmn87()
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
      FROM ima_file WHERE ima01=g_pml[l_ac].pml04
 
    IF SQLCA.sqlcode =100 THEN
       IF g_pml[l_ac].pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pml[l_ac].pmn84
       LET l_qty2=g_pml[l_ac].pmn85
       LET l_fac1=g_pml[l_ac].pmn81
       LET l_qty1=g_pml[l_ac].pmn82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml[l_ac].pmn20
       CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,l_ima44)
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
    IF g_sma.sma115 = 'Y' THEN
       CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,g_pml[l_ac].pmn86)
             RETURNING g_cnt,l_factor
    ELSE
       CALL s_umfchk(g_pml[l_ac].pml04,l_ima44,g_pml[l_ac].pmn86)
             RETURNING g_cnt,l_factor
    END IF
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_pml[l_ac].pmn87 = l_tot
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION p500_set_origin_field(p_ac)
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,      #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor LIKE ima_file.ima31_fac,  #No.FUN-680136 DECIMAL(16,8)
            p_ac     LIKE type_file.num5,      #No.FUN-680136 SMALLINT
            l_cnt    LIKE type_file.num5,      #No.FUN-680136 SMALLINT
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_pml[p_ac].pml04
    IF SQLCA.sqlcode = 100 THEN
       IF g_pml[p_ac].pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_pml[p_ac].pmn84
    LET l_qty2=g_pml[p_ac].pmn85
    LET l_fac1=g_pml[p_ac].pmn81
    LET l_qty1=g_pml[p_ac].pmn82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_pml[p_ac].pmn07=g_pml[p_ac].pmn80
                   LET g_pml[p_ac].fac=l_fac1
                   LET g_pml[p_ac].pmn20=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_pml[p_ac].pmn07=g_ima44
                   LET g_pml[p_ac].fac=1
                   LET g_pml[p_ac].pmn20=l_tot
          WHEN '3' LET g_pml[p_ac].pmn07=g_pml[p_ac].pmn80
                   LET g_pml[p_ac].fac=l_fac1
                   LET g_pml[p_ac].pmn20=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_pml[l_ac].pmn84=l_qty1/l_qty2
                   ELSE
                      LET g_pml[l_ac].pmn84=0
                   END IF
       END CASE
    ELSE  #不使用雙單位
       LET g_pml[p_ac].pmn07=g_pml[p_ac].pmn80
       LET g_pml[p_ac].fac=l_fac1
       LET g_pml[p_ac].pmn20=l_qty1
    END IF
    LET g_pml[p_ac].pmn20 = s_digqty(g_pml[p_ac].pmn20,g_pml[p_ac].pmn07)   #No.FUN-BB0086
 
   #IF cl_null(g_pml[p_ac].pmn86) THEN               #MOD-C50127 mark
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN   #MOD-C50127
       LET g_pml[p_ac].pmn86 = g_pml[p_ac].pmn07
       LET g_pml[p_ac].pmn87 = g_pml[p_ac].pmn20
    END IF
END FUNCTION
 
FUNCTION p500_check_inventory_qty(p_ac)
DEFINE l_pml41     LIKE pml_file.pml41,
       p_ac        LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE l_flag      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE l_ima915    LIKE ima_file.ima915   #FUN-710060 add
 
   IF NOT cl_null(g_pml[p_ac].pmn07) THEN
      CALL p500_pmn07(g_pml[p_ac].pmn07)
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_pml[p_ac].pmn07,g_errno,0)
         DISPLAY g_pml[p_ac].pmn07 TO s_pml[l_sl].pmn07
         RETURN 1
       ELSE
         IF g_pml[p_ac].pml04[1,4] <> 'MISC' THEN
            CALL s_umfchk(g_pml[p_ac].pml04,g_pml[p_ac].pmn07,
                  g_pml[p_ac].pml07)
            RETURNING l_flag,g_pml[p_ac].fac                #取換算率
            DISPLAY g_pml[p_ac].fac TO s_pml[l_sl].fac
            IF l_flag=1 THEN
               ##### -----單位換算率抓不到----#####
               CALL cl_err('pml04/pmn07: ','abm-731',1)
               RETURN 1
            END IF
          END IF
        END IF
   END IF
 
   IF NOT cl_null(g_pml[p_ac].pmn20) THEN
      IF g_pml[p_ac].pmn20 < 0  THEN
         LET g_pml[p_ac].pmn20 = 0
         RETURN 1
      END IF
      IF (g_pml[p_ac].pml04[1,4] != 'MISC') THEN
        #CALL s_sizechk(g_pml[p_ac].pml04,g_pml[p_ac].pmn20,g_lang) #CHI-C10037 mark
         CALL s_sizechk(g_pml[p_ac].pml04,g_pml[p_ac].pmn20,g_lang,g_pml[p_ac].pml07)  #CHI-C10037 add
         RETURNING g_pml[p_ac].pmn20
         DISPLAY g_pml[p_ac].pmn20 TO pml20
      END IF
 
      #----與請購互相勾稽 -----------------
      IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
         SELECT pml08 INTO g_pml2.pml08 FROM pml_file
            WHERE pml01=tm.pmk01 AND pml02=g_pml[p_ac].pml02
         CALL s_umfchk(g_pml[p_ac].pml04,g_pml[p_ac].pmn07,g_pml2.pml08)
            RETURNING l_flag,g_pmn.pmn09
         IF l_flag=1 THEN
            LET g_pmn.pmn09 = 1
         END IF
         IF p500_available_qty(g_pml[p_ac].pmn20*g_pmn.pmn09
                              ,g_pml[p_ac].pml02,g_pml[p_ac].pml04)
            THEN
            RETURN 1
         END IF
      END IF
 
      # ------------若為委外請購
      IF g_pmk.pmk02 = 'SUB' THEN
         # -----必須全數移轉
         IF g_pml[p_ac].pmn20*g_pml[p_ac].fac < g_pml[p_ac].pml20   THEN
            CALL cl_err('Subcontract P/R:','apm-198',1)
            RETURN 1
         END IF
         # -----須判斷工單對應的廠商
         SELECT pml41 INTO l_pml41 FROM pml_file
          WHERE pml01=tm.pmk01 AND pml02=g_pml[p_ac].pml02
         IF NOT cl_null(l_pml41) THEN
            SELECT sfb82 INTO l_sfb82 FROM sfb_file
             WHERE sfb01=l_pml41 AND sfb87!='X'
            IF NOT cl_null(l_sfb82) THEN
               IF l_sfb82 != tm.pmk09 THEN
                  CALL cl_err(tm.pmk09,'mfg9360',0)
                  LET g_pml[p_ac].pmn20=0
                  RETURN 1
               END IF
            END IF
         END IF
      END IF
      #------------料件供應商管制
       SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pml[p_ac].pml04
       IF l_ima915='2' OR l_ima915='3' AND g_pml[p_ac].pmn20>0 THEN 
         CALL p500_pmh(g_pml[p_ac].pml04)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pml[p_ac].pml04,g_errno,0)
            LET g_pml[p_ac].pmn20=0
            RETURN 1
         END IF
      END IF
      #default單價
      IF g_pml[p_ac].pml04[1,4]<>'MISC' AND
         g_pml[p_ac].pmn20 > 0 THEN
         LET g_term = g_pmk.pmk41 
         LET g_price = g_pmk.pmk20
         IF cl_null(g_term) THEN
            SELECT pmc49
             INTO g_term
             FROM pmc_file
             WHERE pmc01 = tm.pmk09
         END IF   
         IF cl_null(g_price) THEN
            SELECT pmc17
             INTO g_price
             FROM pmc_file
             WHERE pmc01 = tm.pmk09
         END IF    
         IF cl_null(g_pml[p_ac].pmn31) OR g_pml[p_ac].pmn31 = 0 THEN  #No.FUN-550019   #MOD-940131 mark #FUN-9C0083取消mark
            CALL s_defprice_new(g_pml[p_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[p_ac].pmn20,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''
                           ,g_term,g_price,g_plant)
               RETURNING g_pml[p_ac].pmn31,g_pml[p_ac].pmn31t,
                         g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
            IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
            CALL p500_price_check(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t)#TQC-BC0108
            IF NOT cl_null(g_pml[p_ac].pmn68) AND
               NOT cl_null(g_pml[p_ac].pmn69) THEN
               CALL s_bkprice(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,g_pon.pon31,g_pon.pon31t)
                    RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t
            END IF
         END IF         #No.FUN-550019
         CALL cl_digcut(g_pml[p_ac].pmn31,t_azi03) RETURNING g_pml[p_ac].pmn31  #No.CHI-6A0004
         LET g_pml[p_ac].pmn90 = g_pml[p_ac].pmn31 #CHI-820014 
         CALL cl_digcut(g_pml[p_ac].pmn31t,t_azi03) RETURNING g_pml[p_ac].pmn31t  #No.CHI-6A0004
         DISPLAY g_pml[p_ac].pmn90 TO s_pml[l_sl].pmn90   #CHI-820014
         DISPLAY g_pml[p_ac].pmn31 TO s_pml[l_sl].pmn31
         DISPLAY g_pml[p_ac].pmn31t TO s_pml[l_sl].pmn31t
      END IF
   END IF
 
   RETURN 0
END FUNCTION
 
FUNCTION p500_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn83,pmn85,pmn80,pmn82",FALSE)
      CALL cl_set_comp_visible("pmn07,fac,pmn20",TRUE)
   ELSE
      CALL cl_set_comp_visible("pmn07,fac,pmn20",FALSE)
      CALL cl_set_comp_visible("pmn83,pmn85,pmn80,pmn82",TRUE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN 
       CALL cl_set_comp_visible("pmn86,pmn87",FALSE)
   ELSE   
       CALL cl_set_comp_visible("pmn86,pmn87",TRUE)
   END IF
   CALL cl_set_comp_visible("pmn81,pmn84",FALSE)
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
END FUNCTION
 
FUNCTION t400_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_pml.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_pml.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_pml[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pml[li_i].att00
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
         IF lg_group <> lg_smy62 THEN                                                                                               
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替pml04子料件編號來顯示
     #得到當前語言別下pml04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pml04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'pml04'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'pml04'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
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
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
             IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
             ELSE
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
             END IF
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
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
             IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
             ELSE
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOENTRY|SCROLL","1|1")
             END IF
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
             IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
             ELSE
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
             END IF
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'pml04'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
FUNCTION p500_pml04_chk(p_pmn68,p_pmn69,p_pmn04)
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
            IF g_pml[l_ac].pml04!=l_pon04 THEN
              IF l_ima152='0' THEN     #No.FUN-840178
                LET g_errno = 'apm-340'
                LET l_success ='N'
                RETURN l_success
              ELSE
                IF l_ima151='Y' THEN       #采購料號為母料號
                  IF l_ima152='1' THEN     #依替代原則         #No.FUN-840178
                     SELECT * FROM ima_file WHERE ima_file.ima01=g_pml[l_ac].pml04
                       AND ima_file.ima01 IN(
                     SELECT imx000 FROM imx_file
                       WHERE imx_file.imx00=l_pon04)
                         AND ima_file.imaacti='Y'   #必須是相同母料號的明細料號
                     IF SQLCA.sqlcode=0 THEN
                        SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                          AND pmv_file.pmv06='Y'
                          AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
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
                             FROM imx_file WHERE imx000=g_pml[l_ac].pml04
                           SELECT COUNT(*) INTO l_n
                             FROM pmv_file WHERE pmv_file.pmv01=l_pon04
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                              AND pmv_file.pmv09<=tm.pmm04
                              AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                          IF l_n=0 THEN
                             LET g_errno = 'apm-345'
                             LET l_success ='N'
                             RETURN l_success
                          ELSE
                            IF l_agb03a IS NOT NULL AND l_agb03a!=' ' THEN
                               SELECT COUNT(*) INTO l_n
                                 FROM pmv_file
                                WHERE pmv_file.pmv01=l_pon04
                                  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                                  AND pmv_file.pmv09<=tm.pmm04
                                  AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10=' ')
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
                                    AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                                    AND pmv_file.pmv09<=tm.pmm04
                                    AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                                            AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                                            AND pmv_file.pmv09<=tm.pmm04
                                            AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                          AND (pnc_file.pnc02='*' OR pnc_file.pnc02=tm.pmk09)
                          AND pnc_file.pnc03=g_pml[l_ac].pml04
                          AND pnc_file.pnc04<=tm.pmm04 AND (pnc_file.pnc05>tm.pmm04
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
                     WHERE ima_file.ima01=g_pml[l_ac].pml04
                     AND imx_file.imx000=ima_file.ima01
                     AND imx_file.imx00 IN(
                     SELECT imx00 FROM imx_file WHERE imx_file.imx000=l_pon04)
                     AND ima_file.imaacti='Y'
                    IF SQLCA.sqlcode=0 THEN
                      SELECT a.imx00 INTO l_imx00
                        FROM imx_file a, imx_file b
                       WHERE a.imx000=g_pml[l_ac].pml04
                         AND b.imx000=l_pon04
                         AND a.imx00=b.imx00
                      SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                         AND pmv_file.pmv06='Y'
                         AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
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
                          FROM imx_file WHERE imx000=g_pml[l_ac].pml04
                        SELECT COUNT(*) INTO l_n
                          FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                           AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                           AND pmv_file.pmv09<=tm.pmm04
                           AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                              AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                              AND pmv_file.pmv09<=tm.pmm04
                              AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                                AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                                AND pmv_file.pmv09<=tm.pmm04
                                AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                                       AND (pmv_file.pmv02='*' OR pmv_file.pmv02=tm.pmk09)
                                       AND pmv_file.pmv09<=tm.pmm04
                                       AND (pmv_file.pmv10>tm.pmm04 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
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
                    LET g_pml[l_ac].pml04=l_pon04
                    LET l_success ='N'
                    RETURN l_success
                END IF
              ELSE
                IF l_ima152='2' THEN
                  SELECT COUNT(*) INTO l_n FROM pnc_file
                  WHERE pnc_file.pnc01=l_pon04
                  AND (pnc_file.pnc02='*' OR pnc_file.pnc02=tm.pmk09)
                  AND pnc_file.pnc03=g_pml[l_ac].pml04
                  AND pnc_file.pnc04<=tm.pmm04 AND (pnc_file.pnc05>tm.pmm04
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
                      AND (pmu_file.pmu02='*' OR pmu_file.pmu02=tm.pmk09)
                      AND pmu_file.pmu07<=tm.pmm04
                      AND (pmu_file.pmu08>tm.pmm04 OR pmu_file.pmu08 IS NULL OR pmu_file.pmu08='')
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
                    LET l_pmn04_cut=g_pml[l_ac].pml04[l_tpmu03,l_tpmu04]
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
                       AND (pnc_file.pnc02='*' OR pnc_file.pnc02=tm.pmk09)
                       AND pnc_file.pnc03=g_pml[l_ac].pml04
                       AND pnc_file.pnc04<=tm.pmm04 AND (pnc_file.pnc05>tm.pmm04
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

#FUN-B90103-----------add---
#FUN-B90103-----------end---
#No:FUN-9C0071--------精簡程式-----

#No.FUN-BB0086---add---begin---
FUNCTION p500_pmn20_check(l_pml41,l_ima915)
DEFINE l_pml41  LIKE pml_file.pml41
DEFINE l_ima915 LIKE ima_file.ima915
   IF NOT cl_null(g_pml[l_ac].pmn20) AND NOT cl_null(g_pml[l_ac].pmn07) THEN
      IF cl_null(g_pml_t.pmn20) OR cl_null(g_pml07_t) OR g_pml_t.pmn20 != g_pml[l_ac].pmn20 OR g_pml07_t != g_pml[l_ac].pmn07 THEN
         LET g_pml[l_ac].pmn20=s_digqty(g_pml[l_ac].pmn20, g_pml[l_ac].pmn07)
         DISPLAY BY NAME g_pml[l_ac].pmn20
      END IF
   END IF

   IF NOT cl_null(g_pml[l_ac].pmn20) THEN
      IF g_pml[l_ac].pmn20 <= 0  THEN  #No.MOD-8B0273 add
         LET g_pml[l_ac].pmn20 = 0
         DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
         RETURN FALSE
      END IF
      IF (g_pml[l_ac].pml04[1,4] != 'MISC') THEN
        #CALL s_sizechk(g_pml[l_ac].pml04,g_pml[l_ac].pmn20,g_lang) #CHI-C10037 mark
         CALL s_sizechk(g_pml[l_ac].pml04,g_pml[l_ac].pmn20,g_lang,g_pml[l_ac].pml07) #CHI-C10037 add
         RETURNING g_pml[l_ac].pmn20
         DISPLAY g_pml[l_ac].pmn20 TO pml20
      END IF

      #----與請購互相勾稽 -----------------
      IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
         SELECT pml08 INTO g_pml2.pml08 FROM pml_file
            WHERE pml01=tm.pmk01 AND pml02=g_pml[l_ac].pml02
         CALL s_umfchk(g_pml[l_ac].pml04,g_pml[l_ac].pmn07,g_pml2.pml08)
            RETURNING l_flag,g_pmn.pmn09
         IF l_flag=1 THEN
            LET g_pmn.pmn09 = 1
         END IF
         IF p500_available_qty(g_pml[l_ac].pmn20*g_pmn.pmn09
                              ,g_pml[l_ac].pml02,g_pml[l_ac].pml04)
            THEN
            RETURN FALSE
         END IF
      END IF
      
      IF g_pml[l_ac].pmn20 != g_pml_t.pmn20 THEN 
          CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pmn20,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''   #TQC-9B0214---add---
                            ,g_term,g_price,g_plant)   #TQC-9B0214---add g_plant
               RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
                         g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
          IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add 
      END IF    
      
      # ------------若為委外請購
      IF g_pmk.pmk02 = 'SUB' THEN
         # -----必須全數移轉
         IF g_pml[l_ac].pmn20*g_pml[l_ac].fac < g_pml[l_ac].pml20   THEN
            CALL cl_err('Subcontract P/R:','apm-198',1)
            RETURN FALSE
         END IF
         # -----須判斷工單對應的廠商
         SELECT pml41 INTO l_pml41 FROM pml_file
          WHERE pml01=tm.pmk01 AND pml02=g_pml[l_ac].pml02
         IF NOT cl_null(l_pml41) THEN
            SELECT sfb82 INTO l_sfb82 FROM sfb_file
             WHERE sfb01=l_pml41 AND sfb87!='X'
            IF NOT cl_null(l_sfb82) THEN
               IF l_sfb82 != tm.pmk09 THEN
                  CALL cl_err(tm.pmk09,'mfg9360',0)
             LET g_pml[l_ac].pmn20=0
                  DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
                  RETURN FALSE
               END IF
            END IF
         END IF
      END IF
      #------------料件供應商管制
      SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pml[l_ac].pml04 
      IF l_ima915='2' OR l_ima915='3' AND g_pml[l_ac].pmn20>0 THEN
         CALL p500_pmh(g_pml[l_ac].pml04)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pml[l_ac].pml04,g_errno,0)
            LET g_pml[l_ac].pmn20=0
            DISPLAY g_pml[l_ac].pmn20 TO s_pml[l_sl].pmn20
            RETURN FALSE
         END IF
      END IF
         CALL p500_set_pmn87()
      IF g_pml[l_ac].pml04[1,4]<>'MISC' AND
         g_pml[l_ac].pmn20 > 0 THEN
         LET g_term = g_pmk.pmk41 
         LET g_price = g_pmk.pmk20
         IF cl_null(g_term) THEN
           SELECT pmc49
           INTO g_term
           FROM pmc_file
           WHERE pmc01 = tm.pmk09
         END IF   
         IF cl_null(g_price) THEN
           SELECT pmc17
           INTO g_price
           FROM pmc_file
           WHERE pmc01 = tm.pmk09
         END IF    
         IF cl_null(g_pml[l_ac].pmn31) OR g_pml[l_ac].pmn31 = 0 THEN  #No.FUN-550019   #MOD-940131 mark #FUN-9C0083 取消mark
            CALL s_defprice_new(g_pml[l_ac].pml04,tm.pmk09,tm.pmm22,tm.pmm04,g_pml[l_ac].pmn20,'',tm.pmm21,tm.pmm43,"1",g_pml[l_ac].pmn86,''
                            ,g_term,g_price,g_plant) 
               RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,
                         g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
              END IF
            IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
            IF NOT cl_null(g_pml[l_ac].pmn68) AND
               NOT cl_null(g_pml[l_ac].pmn69) THEN
               CALL s_bkprice(g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t,g_pon.pon31,g_pon.pon31t)
                  RETURNING g_pml[l_ac].pmn31,g_pml[l_ac].pmn31t
            END IF
            LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #MOD-A50136
         END IF         #No.FUN-550019
         CALL cl_digcut(g_pml[l_ac].pmn31,t_azi03) RETURNING g_pml[l_ac].pmn31  #No.CHI-6A0004
         #LET g_pml[l_ac].pmn90 = g_pml[l_ac].pmn31  #CHI-820014 add   #MOD-A50136
         CALL cl_digcut(g_pml[l_ac].pmn31t,t_azi03) RETURNING g_pml[l_ac].pmn31t  #No.CHI-6A0004
         DISPLAY g_pml[l_ac].pmn31 TO s_pml[l_sl].pmn31
         DISPLAY g_pml[l_ac].pmn31t TO s_pml[l_sl].pmn31t
         DISPLAY g_pml[l_ac].pmn90 TO s_pml[l_sl].pmn90   #CHI-820014 
      END IF
   END IF
   RETURN TRUE 
END FUNCTION 

FUNCTION p500_pmn82_check()
   IF NOT cl_null(g_pml[l_ac].pmn82) AND NOT cl_null(g_pml[l_ac].pmn80) THEN
      IF cl_null(g_pml_t.pmn82) OR cl_null(g_pml80_t) OR g_pml_t.pmn82 != g_pml[l_ac].pmn82 OR g_pml80_t != g_pml[l_ac].pmn80 THEN
         LET g_pml[l_ac].pmn82=s_digqty(g_pml[l_ac].pmn82, g_pml[l_ac].pmn80)
         DISPLAY BY NAME g_pml[l_ac].pmn82
      END IF
   END IF

   IF NOT cl_null(g_pml[l_ac].pmn82) THEN
      IF g_pml[l_ac].pmn82 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE,'pmn82'
      END IF
   END IF
   #計算pmn20,pmn07的值,檢查數量的合理性
    CALL p500_set_origin_field(l_ac)
    CALL p500_check_inventory_qty(l_ac)
        RETURNING g_flag
    IF g_flag = '1' THEN
       IF g_ima906 = '3' OR g_ima906 = '2' THEN
          RETURN FALSE,'pmn85'
       ELSE
          RETURN FALSE,'pmn82'
       END IF
    END IF
    IF g_pml[l_ac].pmn87 = 0 OR (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
           g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
           g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
           g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
           g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
       CALL p500_set_pmn87()
    END IF
    CALL cl_show_fld_cont()
   RETURN TRUE,'' 
END FUNCTION 

FUNCTION p500_pmn85_check(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_pml[l_ac].pmn85) AND NOT cl_null(g_pml[l_ac].pmn83) THEN
      IF cl_null(g_pml_t.pmn85) OR cl_null(g_pml83_t) OR g_pml_t.pmn85 != g_pml[l_ac].pmn85 OR g_pml83_t != g_pml[l_ac].pmn83 THEN
         LET g_pml[l_ac].pmn85=s_digqty(g_pml[l_ac].pmn85, g_pml[l_ac].pmn83)
         DISPLAY BY NAME g_pml[l_ac].pmn85
      END IF
   END IF

   IF NOT cl_null(g_pml[l_ac].pmn85) THEN
      IF g_pml[l_ac].pmn85 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_pml_t.pmn85 <> g_pml[l_ac].pmn85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_pml[l_ac].pmn85*g_pml[l_ac].pmn84
            IF cl_null(g_pml[l_ac].pmn82) OR g_pml[l_ac].pmn82=0 THEN #CHI-960022
               LET g_pml[l_ac].pmn82=g_tot*g_pml[l_ac].pmn81
               DISPLAY BY NAME g_pml[l_ac].pmn82                      #CHI-960022
            END IF                                                    #CHI-960022
         END IF
      END IF
   END IF
      IF g_pml[l_ac].pmn87 = 0 OR
         (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
          g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
          g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
          g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
          g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
      CALL p500_set_pmn87()
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE 
END FUNCTION 

FUNCTION p500_pmn87_check()
   IF NOT cl_null(g_pml[l_ac].pmn87) AND NOT cl_null(g_pml[l_ac].pmn86) THEN
      IF cl_null(g_pml_t.pmn87) OR cl_null(g_pml86_t) OR g_pml_t.pmn87 != g_pml[l_ac].pmn87 OR g_pml86_t != g_pml[l_ac].pmn86 THEN
         LET g_pml[l_ac].pmn87=s_digqty(g_pml[l_ac].pmn87, g_pml[l_ac].pmn86)
         DISPLAY BY NAME g_pml[l_ac].pmn87
      END IF
   END IF

   IF g_sma.sma115 = 'Y' THEN
      IF g_pml[l_ac].pmn87 = 0 OR
            (g_pml_t.pmn81 <> g_pml[l_ac].pmn81 OR
             g_pml_t.pmn82 <> g_pml[l_ac].pmn82 OR
             g_pml_t.pmn84 <> g_pml[l_ac].pmn84 OR
             g_pml_t.pmn85 <> g_pml[l_ac].pmn85 OR
             g_pml_t.pmn86 <> g_pml[l_ac].pmn86) THEN
         CALL p500_set_pmn87()
      END IF
   ELSE
         CALL p500_set_pmn87()
   END IF
END FUNCTION 
#No.FUN-BB0086---add---end---


#TQC-BC0108  add begin
FUNCTION p500_price_check(p_pmn31,p_pmn31t)
   DEFINE p_pmn31    LIKE   pmn_file.pmn31   #未稅價格
   DEFINE p_pmn31t   LIKE   pmn_file.pmn31t  #含稅價格
   DEFINE l_pmk41    LIKE   pmk_file.pmk41   #價格條件
   DEFINE l_pnz04    LIKE   pnz_file.pnz04   #未取到價格輸入
   DEFINE l_pnz07    LIKE   pnz_file.pnz07   #取到價格修改
   IF cl_null(g_pmk.pmk41) THEN
   	  SELECT pmc49 INTO l_pmk41 FROM pmc_file #慣用價格條件
   	   WHERE pmc01 = tm.pmk09
      IF SQLCA.sqlcode THEN 
      	 CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
      	 RETURN
      END IF
   ELSE 
   	  LET l_pmk41 = g_pmk.pmk41
   END IF

   IF NOT cl_null(l_pmk41) THEN
   	  SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file    
   	   WHERE pnz01 = l_pmk41
      IF SQLCA.sqlcode THEN
      	 CALL cl_err( 'sel pnz04,pnz07' , SQLCA.sqlcode,0)      
      	 RETURN
      END IF
   END IF 

   #FUN-BC0088 ----- add start -----
   IF g_pml[l_ac].pml04[1,4] = 'MISC' THEN
      IF g_gec07 = 'Y' THEN   #含稅
         CALL cl_set_comp_entry("pmn31",FALSE)
         CALL cl_set_comp_entry("pmn31t",TRUE)
      ELSE
         CALL cl_set_comp_entry("pmn31",TRUE)
         CALL cl_set_comp_entry("pmn31t",FALSE)
      END IF
      RETURN
   END IF
   #FUN-BC0088 ----- add end -----

   IF g_gec07 = 'Y' THEN   #含稅
      IF p_pmn31t = 0 OR cl_null(p_pmn31t) THEN
         #未取到含稅單價
         IF l_pnz04 = 'Y' THEN #未取到單價可人工輸入
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",TRUE)
         ELSE 
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         END IF
      ELSE
         #有取到含稅單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         END IF
      END IF
   ELSE                    #不含稅
      IF p_pmn31 = 0 OR cl_null(p_pmn31) THEN 
         #未取到稅前單價
         IF l_pnz04 = 'Y' THEN   #未取到單價可人工輸入
            CALL cl_set_comp_entry("pmn31",TRUE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         END IF
      ELSE
         #有取到稅前單價
         IF l_pnz07 = 'Y' THEN   #取到價格可修改
            CALL cl_set_comp_entry("pmn31",TRUE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pmn31",FALSE)
            CALL cl_set_comp_entry("pmn31t",FALSE)
         END IF
      END IF
   END IF
END FUNCTION 
#TQC-BC0108  add end
#MOD-C50001 add start -----
FUNCTION p500_show()
DEFINE l_t        LIKE type_file.num5

    CALL g_pml.clear()

    LET l_sql = "SELECT * FROM p500_tmp_table"
    PREPARE p500_tmp_prepare FROM l_sql
    MESSAGE " SEARCHING! "
    DECLARE p500_tmp_cur CURSOR FOR p500_tmp_prepare

    LET g_rec_b = 0
    LET l_t = 1
    FOREACH p500_tmp_cur INTO g_pml[l_t].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach_tmp:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET l_t = l_t + 1
    END FOREACH
    CALL g_pml.deleteElement(l_t)
    LET g_rec_b = l_t - 1
    IF g_rec_b = 0 THEN
       CALL cl_err('','apm-204',1)
       LET g_success = 'N'
       RETURN
    END IF
    DISPLAY g_rec_b TO FORMONLY.cnt2

    DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE( COUNT = g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
#MOD-C50001 add end   -----
