# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: saqct110.4gl
# Descriptions...: IQC 品質記錄維護作業
# Date & Author..: 99/05/11 By Melody
# Modify.........: No:7189 03/08/01 Carol  FUNCTION t110_defqty 中應先判斷若送
#                                          驗量=1 ，則直接檢驗量為 1
# Modify.........: No:7710 03/08/06 By Mandy 不良數量應 <= 檢驗量。
# Modify.........: No:7706 03/08/06 By Mandy
#                  檢驗項目不合格時，項目判定欄會出現「重工」(ze01=aqc-005) 。
#                  應將 aqc005 改為「驗退」，重工應另使用一個 訊息 (於 FQC 或 PQC 時使用)
# Modify.........: No:8046 03/09/03 By Mandy 特採時，並未將特採量寫入rvb_file，導致入庫量無法輸入
# Modify.........: No:8295 03/10/03 By Melody 單身檢驗項目開窗時沒有SHOW出檢驗方
# Modify ........: No:8689 03/11/12 By Melody 送驗量允許輸入小數位,抓檢驗量時,才
# Modify ........: No:9489 04/04/26 By Melody aqct110作廢時回寫之KEY值有所遺漏，
# Modify ........: No:9554 04/05/13 By Melody call aqcr300 時, 應傳key值 qcs01/q
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify ........: No.MOD-470517 04/07/23 By Mandy 作廢時在判斷該單據是否已被確認不可作廢，應該要補上完整的Key 值
# Modify ........: No.MOD-480059 04/08/26 By Nicola 如果是合格應該就不能做特材了
# Modify ........: No.MOD-480060 04/09/01 By Nicola 應該是單身輸完才到合格量
# Modify ........: No.MOD-4A0121 04/10/08 By Mandy 合格量應不可為 NULL
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0139 04/11/16 By Mandy 1.在輸入量測值時，單身即時show己輸入筆數,以讓使用者知道已經輸入幾筆量測值，以便與檢驗量進行勾稽。
#                                                  2.在輸入量測值時，允許輸入零
# Modify.........: No.MOD-4B0140 04/11/16 By Mandy 資料來源為1收貨單時，料號欄位應不可更改。
# Modify.........: No.MOD-4B0141 04/11/16 By Mandy 給分批檢驗順序預設值
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520016 05/02/16 By Melody 合格量不可大於送驗量
# Modify.........: No.MOD-530471 05/03/29 By Mandy 有二項檢驗項目,第一項需維護測量值,其不良數為1,但到第二項之後,馬上點第一項之不良數量欄位,其值會被改變為0
# Modify.........: No.MOD-530628 05/03/29 By Mandy 若為廠商不需檢驗，則 IQC 時錯誤訊息會判斷成委外代買件。,應該是秀該廠商料件不需檢驗才對
# Modify.........: No.MOD-530720 05/03/31 By Mandy rvb08 應改為 rvb07 (實收數)
# Modify.........: No.FUN-540028 05/05/11 By Elva 雙單位內容修改
# Modify.........: NO.FUN-550029 05/05/31 By jackie 單據編號加大
# Modify.........: No.MOD-550165 05/06/10 By kim 在取消確認時,l_rvb33的值未給
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.MOD-570293 05/08/10 By Nicola 自行輸入 --> 輸入送驗量 ,檢驗量不會自己算
# Modify.........: No.MOD-590083 05/09/20 By Nicola 回寫rvb40用檢驗日期
# Modify.........: No.MOD-590067 05/09/20 By Nicola 送驗量帶錯
# Modify.........: No.MOD-5A0375 05/11/09 By Rosayu 新增時單號開窗查詢無資料
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-5C0022 05/12/05 By Mandy GP2.0版確認時應回寫允收一rvb331,允收二rvb332
# Modify.........: No.FUN-5C0077 05/12/19 By ice 新增倉庫QC(aqct700),OQC(aqct800)品質記錄維護作業
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.MOD-610066 06/01/16 By Nicola 已產生入庫/驗退單，不可特採
# Modify.........: No.FUN-610075 06/01/18 By Nicola QC多單位
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-5C0114 06/02/09 By kim GP3.0重複性生產功能,原aqct110移至saqct110
# Modify.........: No.FUN-620043 06/02/17 By Nicola 多單位要考慮參考單位
# Modify.........: No.TQC-620129 06/03/02 By Nicola 檢驗量帶入修改
# Modify.........: No.TQC-630051 06/03/07 By Nicola 多單位要考慮料件單一單位
# Modify.........: No.TQC-630018 06/03/09 By Elva 來源為G時default單位一
# Modify.........: No.TQC-630028 06/03/20 By 料件檢驗程度若在料件/廠商檢驗資料不存在
                                    #        應搜尋料件基本資料中品管檢驗資料設定
# Modify.........: No.TQC-630089 06/03/21 By當資料來源為"2:自行輸入時"單身檢驗項目的AC/RE的值目前代出 0 / 0            
# Modify.........: No.TQC-630033 06/03/31 By pengu 在AFTER FIELD qct11中應先去撈qcc_file中的上限(qcc061)、
                                   #               下限(qcc062)及是否輸入明細測量值(qcc07)
# Modify.........: No.FUN-630051 06/04/03 By Carrier 增加多單位倉庫QC申請單的來源
# Modify.........: No.FUN-640036 06/04/08 By kim 自行輸入重複性生產檢驗單欄位跳至qcs32 單位一數量時出現aqc-037 錯誤
# Modify.........: No.MOD-640286 06/04/12 By kim IQC不可以改合格量,但PQC及FQC可以改,因此IQC應該可以改較一致.
# Modify.........: No.FUN-640058 06/04/17 By Sarah 資料來源=G時,輸入異動單號後去檢查倉庫檢驗申請單,查無單據應Show Err Msg:無此倉庫檢驗申請單(aqc-987)
# Modify.........: No.FUN-630105 06/04/18 By kim ASR-FQC單轉入庫單,聯產品功能
# Modify.........: No.MOD-640512 06/04/24 By Claire 單據特採/確認/取消要重計入庫
# Modify.........: No.FUN-640100 06/04/27 By Sarah 新增時的出通單/出貨單qcs01開窗,改成q_ogb9(開單身單號,,已經處理過的不用再出現)
# Modify.........: No.MOD-640514 06/05/16 By pengu在特採時應判斷SUM(合格量) > SUM(入庫量)  (同 一收貨單)
# Modify.........: No.TQC-650121 06/05/26 By kim GP3.0 ASR的asrt310FQC單的功能"轉入庫單","聯產品"的按鈕,在aqct800應該被隱藏
# Modify.........: No.MOD-650102 06/06/06 By sam_lin特採作業，若該收貨單+項次已存在驗退單需警告
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-660079 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.MOD-630026 06/06/21 By Mandy t110_defqty()內select qca_file or qch_file會傳回多筆資料
# Modify.........: No.MOD-630124 06/06/21 By Mandy AFTER FIELD qcs02 判斷有問題導致若收貨單第一批入庫後就不可再輸入第二批檢驗資料
# Modify.........: No.TQC-660073 06/06/22 By Pengu 資料來源為F:還料時,須檢驗該還料單類別imr00為'1'才可檢驗
# Modify.........: No.FUN-610097 06/06/23 By Mandy 特採作業，若輸入兩次以上，所回寫apmq110的 "允收數量" 會被累加，應該不能累加(雙單位的也需一併考慮)
# Modify.........: No.TQC-660106 06/06/23 By Smapmin 調整雙單位畫面
# Modify.........: No.TQC-660136 06/06/29 By kim FUNCTION t110_set_qcs22() 參考單位不應該算進去送驗量
# Modify.........: No.MOD-660153 06/07/03 By kim 第二次QC時,參考單位數量未帶出
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.TQC-670064 06/07/19 By kim 因應inaconf和imrconf的增加,檢查qcs01需改變
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680011 06/08/08 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680104 06/09/18 By Czl  類型轉換,改為LIKE
# Modify.........: No.CHI-690047 06/09/29 By Echo aqct700應抓未確認的資料
# Modify.........: No.CHI-6A0006 06/10/03 By Echo 當前端單據(aimt306),有輸入廠商時,則QC單並未自動帶出廠商資料!!!
# Modify.........: No.TQC-6A0005 06/10/11 By pengu FUN-660079的sql語法錯誤
# Modify.........: No.CHI-690068 06/10/20 By Sarah OQC沒有特採這個功能,將Action隱藏(其他QC畫面保留)
# Modify.........: No.CHI-6A0037 06/10/20 By Sarah aqct700中，多單位資料只有新增時會顯示資料，查詢時卻無法正常顯示
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
#                                                  3.date->l_date
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-6A0059 06/11/29 By kim 增加出通單的開窗及檢查
# Modify.........: No.MOD-690138 06/12/07 By Claire 合格量qcs091更改後未更新DB
# Modify.........: No.MOD-6A0106 06/12/13 By pengu 1.單身的檢驗量無法正常產生
#                                                  2.單身「不良數量」應改為「缺點數」
#                                                  3.單身 「不良數量(缺點數)」應可 > 檢驗量
# Modify.........: No.CHI-6C0045 07/01/05 By rainy 送驗量=0時不可確認
# Modify.........: No.MOD-710117 07/01/26 By pengu  1.t110_a()中,沒有BEGIN WORK，但卻有COMMIT WORK /ROLLBACK WORK
#                                                   2.t110_z()中CALL cl_err(g_qcs.qcs01,'aqc-013',0)未接ROLLBACK WORK
#                                                   3.t110_x(作廢段UPDATE失敗也沒有做ROLLCBACK
# Modify.........: No.CHI-6B0075 07/02/08 By rainy 入庫單號開窗選的資料不能被擋
# Modify.........: No.MOD-710190 07/03/06 By pengu 進入t110_u()中,若尚未登打到合格量前即按放棄,但系統卻仍會進入'合格量'待輸入
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-710120 07/03/21 By claire  BEGIN WORK要先default g_success
# Modify.........: No.TQC-740048 07/04/10 By pengu 不應該可以修改合格量，若要修改合格量時應該透過"特採"功能做修改
# Modify.........: No.TQC-740124 07/04/18 By chenl 當qcs00='5'時，oagconf審核條件必須為'N'。
# Modify.........: No.MOD-740273 07/04/23 By kim 選擇自行輸入不應該檢查出貨單號
# Modify.........: No.TQC-740264 07/04/24 By Sarah 直接用KEYIN方式輸入無訂單出貨單號,應檢查單身檢驗碼為Y的才可輸入
# Modify.........: No.FUN-740016 07/05/08 By Nicola 借出管理
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750225 07/05/31 By arman 單頭錄入資料，如不進入檢驗量欄位，確定后進入單身，則檢驗量欄位值未能帶出
# Modify.........: No.TQC-760005 07/06/01 By xufeng 當資料來源是G倉庫檢驗申請時,一個倉庫檢驗申請單可以進行無限次的檢驗,并且送檢量和合格量累計可以大余該申請單
# Modify.........: No.FUN-740116 07/06/07 By pengu 取到調整樣本後,再回對樣本字號時,毋需考慮級數
#                                                  當送驗量(qcf22)為 1 時, defqty() 應 return 1 毋需再比對 105E表
# Modify.........: No.CHI-740037 07/06/07 By pengu 單身判定結果為合格時應將缺點數乘上CR/MA/MI權數
# Modify.........: No.TQC-750209 07/06/07 By pengu 修正zl單CHI-740037的寫法
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.TQC-760050 07/06/15 By rainy 收貨單號無法用複製貼上的方式
# Modify.........: No.MOD-770114 07/07/24 By pengu 雜收QC單在做取消確認時，為考慮雜收單是否已經過帳
# Modify.........: No.MOD-770141 07/07/28 By pengu 必須二度按"刪除"才能真正刪除此資料
# Modify.........: No.MOD-780149 07/08/21 By pengu 若判合格則單頭的合格量應與送驗量一致
# Modify.........: No.MOD-780245 07/09/18 By pengu 工單走runcard沒有作到依料件作業編號設不同檢驗項目
# Modify.........: No.CHI-760018 07/10/23 By Judy 應依照類別,依來源單號抓出數量,送驗量
# Modify.........: No.TQC-7A0073 07/10/22 By xufeng 若為OQC的情況，抓取料件的檢驗程度/水准/級數,先去產品客戶資料(obk_file)中抓，若沒有再去料件資料檔中抓
# Modify.........: No.MOD-7B0125 07/11/13 By xufeng 錄入時,收貨單號應該可以CONSTRUCT查詢
# Modify.........: No.MOD-7B0138 07/11/14 By Pengu 調整查詢時收貨單的開窗程式
# Modify.........: No.MOD-7B0016 07/11/19 By Pengu 調整檢驗程度抓法aqci150 -> aqci140 -> aqci130
# Modify.........: No.TQC-7B0148 07/11/28 By wujie “檢驗時間”欄位敲回車后，程式自動關閉
# Modify.........: No.TQC-7C0071 07/12/07 By xufeng 程序會異常退出
# Modify.........: No.TQC-7C0088 07/12/08 By agatha 增加判斷，當l_ac等于單身最后一項時，跳出單身
# Modify.........: No.MOD-7C0061 07/12/10 By Pengu 在b_fill()中不應該在去呼叫s_newaql()
# Modify.........: No.MOD-7C0145 07/12/21 By Pengu 若單頭送驗量包含小數時會造成單身檢驗量為0
# Modify.........: No.CHI-7B0049 07/12/26 By Nicola 合格資料不能修改送驗量
# Modify.........: No.MOD-7C0226 07/12/28 By Pengu 同一張收貨單有作廢IQC時則在做特彩時允收數量會異常
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820049 08/02/14 By Pengu 檢驗方式為C=0時其推算抽驗量應考慮級數
# Modify.........: No.FUN-830131 08/03/28 By mike 新增ICD架構
# Modify.........: No.MOD-840334 08/04/21 By mike rowid類型更動
# Modify.........: No.FUN-840068 08/04/22 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-840157 08/04/24 By Nicola IQC做批/序號管理
# Modify.........: No.FUN-850120 08/05/21 By rainy 批序號管理傳"SEL"
# Modify.........: No.MOD-850312 08/05/29 By claire 在新增時先輸入送驗量再輸入收貨單時, 會不重計l_rvb07s,造成沒有判斷送驗量的合理性
# Modify.........: No.MOD-860080 08/06/10 By Nicola 分批QC修改
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.FUN-860069 08/06/18 By Sherry 增加輸入日期(sfu14)
# Modify.........: No.CHI-860037 08/06/30 By claire 同時開啟同一張QC單畫面，當依畫面確認後產生單身另一個畫面還同樣可以產生單身造成送驗量重複計算
# Modify.........: No.MOD-860150 08/07/14 By Pengu 同時開啟同一張QC單畫面，當依畫面確認後另一個畫面還可以進單身
# Modify.........: No.CHI-870023 08/07/16 By sherry 出通單抓已確認資料
# Modify.........: No.MOD-870219 08/07/17 By Nicola 分批QC修改
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-870270 08/07/29 By Smapmin OQC的送驗量default應該是收貨數量- SUM(未確認的QC送驗量) -SUM(以確認的QC合格量)
# Modify.........: No.MOD-880118 08/08/14 By lumx  obk_file key值調整 此處需加上obk05的條件
# Modify.........: No.MOD-880068 08/08/08 By claire aqct800同張單不同項次有不需檢驗及需檢驗料需允許檢驗料可輸入
# Modify.........: No.MOD-880166 08/08/21 By claire 取消確認時,回寫rvb31的公式調整,應扣除原來QC合格量        
# Modify.........: No.MOD-890004 08/09/01 By chenyu 取消確認時,不應該判斷是否存在申請單
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.MOD-890098 08/09/10 By claire aqct800查詢時,客戶簡稱應取自客戶主檔
# Modify.........: No.MOD-890152 08/09/17 By Pengu 倉庫QC單不允許修改料號
# Modify.........: No.MOD-890102 08/09/11 By claire 委外採購單與一般採購單要區分pmh22
# Modify.........: No.MOD-890211 08/09/22 By chenl  在審核時，對送驗量再次檢查，防止部分單據由于是取消作廢導致單據未能卡住而是數量加倍的情況。
# Modify.........: No.MOD-890223 08/09/23 By claire s_newaql加傳入pmh21,pmh22
# Modify.........: No.MOD-850116 08/05/12 By chenl  修正審核時資料加鎖機制問題。
# Modify.........: No.MOD-890283 08/09/28 By wujie  取消審核時，MOD-860080的判斷有誤，應該是>，不是>=
# Modify.........: No.MOD-8A0060 08/10/09 By claire 刪除單據時應一併刪除備註
# Modify.........: No.FUN-880074 08/10/15 By jan 修改 異動單號/項次 的開窗
# Modify.........: No.MOD-910138 09/01/13 By claire 檢驗人員雖會檢查合理性,但按放棄輸入仍會將錯誤的欄位值存入
# Modify.........: No.CHI-910054 09/01/20 By claire 加入bmj02條件
# Modify.........: No.MOD-8C0096 09/01/22 By claire AFTER INSERT,ON ROW CHANGE qcd061,qcd062取值參考AFTER FIELD qct11
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.MOD-930031 09/03/04 By shiwuying RETURN 0 改為NEXT FIELD qcs03
# Modify.........: No.MOD-930151 09/03/13 By chenyu FUNCTION t110_qcs03()中，sql語句中的pmh21 = " "應該改成pmh21=g_ecm04
# Modify.........: No.FUN-930108 09/03/31 By zhaijie 增加判斷料件是否做AVL管理的邏輯
# Modify.........: No.MOD-940126 09/04/09 By chenyu 作廢單單子取消作廢，然后在審核，數量會超過應該檢驗的數量
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-930234 09/05/20 By Pengu 抓取pmh_file資料有誤
# Modify.........: No.MOD-940209 09/05/20 By Pengu sql有錯，抓不到l_qcd07的值
# Modify.........: No.MOD-940034 09/05/20 By Pengu 參數設定須輸入測驗值且有缺點數時，若直接按確定判定結果會異常
# Modify.........: No.MOD-950114 09/05/20 By Pengu 驗退確認時會出現"aim-011"的錯誤
# Modify.........: No.MOD-970026 09/07/03 By Carrier 雜收/雜發單時,送檢量依據為申請量inb16 & 取消審核時,即使更新 雜收/雜發單的異動數量 inb09
# Modify.........: No.TQC-970126 09/07/14 By lilingyu aqct1101窗口中不良原因合計數量與aqct110單身中的"不良數量"不等時,系統無控管
# Modify.........: No.MOD-970183 09/07/20 By Carrier 取消審核時,檢查是否已經有驗退單
# Modify.........: No.MOD-970147 09/07/24 By Smapmin 資料來源為Z.其他時,要可以輸入料號
# Modify.........: No.MOD-970271 09/07/30 By mike 在aqct700的廠商編號欄位,每次檢查沒有先把g_errno的欄位清空,造成若第一次key入錯誤的>
#                                                 后續就離不開這個欄位了   
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990050 09/09/11 By lilingyu "送驗量"不可小于0
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-990071 09/09/23 By chenmoyan 增加料件編號為'*'的情況
# Modify.........: No:MOD-980226 09/10/27 By sabrina  再抓取bmj10 SQL中應判斷bmj02是否為' '而是NULL 
# Modify.........: No:MOD-9A0129 09/10/27 By sabrina  使用多單位且母單位數量為輸入值時，送驗量會待不出值
# Modify.........: No:CHI-9A0052 09/11/02 By Smapmin OQC時輸入的料號需跟出通/出貨單輸入的料號相同
# Modify.........: No:FUN-9C0071 10/01/04 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A20100 10/02/25 By Sarah 當資料來源選H銷退時,帶不出ＡＣ�ＲＥ值
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No:MOD-A30058 10/03/29 By Summer 參數設定有連續5批減量則減量轉免驗,但取消確認卻沒將檢驗狀態還原
# Modify.........: No:MOD-A40035 10/04/08 By Sarah 刪除單身時,應同步刪除量測值(qctt_file)
# Modify.........: No:MOD-A40050 10/04/09 By Sarah t110_3_y()裡若有錯要RETURN前應先給LET g_success = 'N'
# Modify.........: No:CHI-A10021 10/04/15 By Summer 取消pmhacti='Y'的條件
# Modify.........: No:MOD-A40146 10/04/26 By Smapmin 若aimi100設定不做供應商管制,檢驗相關欄位則抓pmc_file之後再抓ima_file.
#                                                    若aimi100設定做供應商管制,檢驗相關欄位則抓pmh_file之後再抓pmc_file之後再抓ima_file.
# Modify.........: No.FUN-A60076 10/06/25 By huangtao 製造功能優化-平行製程(批量修改)
# Modify.........: No:CHI-A70047 10/08/16 By Smapmin 修改雜收發批序號功能
# Modify.........: No.FUN-A80063 10/08/18 By wujie   品质管理功能改善修改
# Modify.........: No:MOD-A80165 10/08/23 By sabrina 若qcs02有值，要call t110_check_qc()
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-A30045 10/11/15 By lixh1    新增“取消特采”ACTION
# Modify.........: No:MOD-AB0143 10/11/16 By sabrina 若單身該輸入測驗值而沒有輸入測驗值，則不可以做確認
# Modify.........: No:MOD-AC0025 10/12/06 By sabrina 當qcs00='2'時，不與收貨單的入庫允收量做勾稽 
# Modify.........: No:TQC-AC0166 10/12/14 By Carrier 'G'仓库检验申请时,把'急料'qsa10带入qcs16 
# Modify.........: NO.TQC-AC0294 10/12/20 By liweie sfu01開窗/檢查要排除smy73='Y'的單據
# Modify.........: NO.MOD-AC0373 10/12/28 By lixh1  維護單據批序號 
# Modify.........: NO.TQC-B10019 11/01/05 By zhangll 增加资料来源控管
# Modify.........: No:MOD-B10034 11/01/05 By sabrina 若不輸入測量值，按放棄時應該要可以離開測量值畫面
# Modify.........: No:MOD-B10110 11/01/18 By Summer oga09要加上'A'
# Modify.........: No:MOD-B20010 11/02/08 By sabrina qct03_curs少加兩個條件 
# Modify.........: No:MOD-B20052 11/02/16 By sabrina 修改MOD-AB0143 
# Modify.........: No.FUN-A80128 11/03/09 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-940103 11/05/10 By lixiang 增加規格顯示欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60031 11/06/03 By zhangll 抓取qca時增加關鍵索引條件，否則會發生-284錯誤
# Modify.........: No.TQC-B60106 11/06/16 By zhangweib 在審核時對檢驗員進行檢查
# Modify.........: No:MOD-B70116 11/07/17 By Summer 若pmc906、pmc907為null時，則應往下抓取ima_file
# Modify.........: No:FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:MOD-B80091 11/08/17 By johung 還原MOD-B60031
# Modify.........: No:CHI-B90064 11/09/30 By Smapmin 還原MOD-A40146
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數(項次)傳""
#                                                   s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
#                                                   AFTER FIELD qcs091 開窗詢問"是否整批指定純度"
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-BC0104 11/12/29 By lixh1 增加'QC料件維護’ACTION
# Modify.........: No:MOD-BC0044 11/12/06 by destiny 送检量为0时,应卡住不能过
# Modify.........: No:TQC-BB0119 12/01/13 By Carrier t110_more_b1输入时要CHECK qcd/qcz的条件,与审核段逻辑一致
# Modify.........: No:TQC-C10085 12/01/29 By lilingyu 料件編號為空，資料仍然可以審核
# Modify.........: No:MOD-B80352 12/01/30 By Vampire IF條件需多判斷g_sma.sma886[8,8]='Y'時才做此控卡
# Modify.........: No.FUN-BB0086 12/02/01 By tanxc 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20066 12/02/10 By SunLM qcsoriu,qcsorig可以下查詢條件
# Modify.........: No:TQC-C20071 12/02/10 By 修正錯誤提示
# Modify.........: No:TQC-BC0206 12/02/13 By lilingyu 已經審核的出貨單,aqct800的質量記錄維護可以作廢/取消審核
# Modify.........: No:TQC-C20178 12/02/14 By jan 修正b_fill()的sql錯誤
# Modify.........: No:MOD-BC0060 12/02/16 By ck2yuan 新增輸入單號，檢驗水準要帶出來
# Modify.........: No:TQC-C20213 12/02/16 By bart g_qcs22s數量不應包含本張單送檢量
# Modify.........: No:TQC-C20196 12/02/17 By lixh1 aqct700當qcs00='Z'的時候才可維護QC料件
# Modify.........: No.TQC-C20264 12/02/20 By yuhuabao 修改BUG:新增aqct110時如果單身無資料的狀態下，按下右邊的action不良原因後，會自動關閉程式 
# Modfiy.........: No.TQC-C20504 12/02/27 By xianghui 確認時要檢查QC料件維護的數量要等於QC單的送驗量
# Modfiy.........: No.TQC-C30082 12/03/05 By yuhuabao 如果合格狀態為1 合格時，加上開窗詢問整批修改純度
# Modify.........: No:CHI-BC0018 12/03/07 By ck2yuan ima101、qcs17兩個欄位帶出後面說明欄位
# Modify.........: No.TQC-C30139 12/03/09 By xianghui qck09='N'時給出相應的提示信息
# Modify.........: No.MOD-C30156 12/03/09 By xianghui qcs02輸入錯誤時給原值
# Modify.........: No:TQC-C30125 12/03/12 By lilingyu 修正TQC-BC0206此單調整內容
# Modify.........: NO.MOD-C30571 12/03/12 By fengrui 調整顯示不良原因程式段位置
# Modify.........: No.MOD-C30339 12/03/12 By xianghui 一張收貨單打第二張QC時，預設送驗量應扣去第一筆的送驗量
# Modify.........: No.MOD-C30559 12/03/12 By lixh1 修正qcs05給值問題
# Modify.........: No.MOD-C30557 12/03/13 By xianghui 確認時添加QC料件判定維護合格量的回寫
# MOdify.........: No.MOD-C30428 12/03/13 By xianghui 撈取總IQC驗退量時去掉qcs09的判斷，應為qcs09為1：合格時，驗退量為0，如果
#                                                     通過QC料件判定回寫的合格量時，此時qcs09為1，但可能有驗退的數量。所以去掉這邊qcs09的where條件
# Modify.........: No.MOD-C30560 12/03/14 By xianghui 雜收單的單身QC單號有值就不可再次打雜收單單頭單號的QC單的檢驗，且原單身QC單不可以取消確認
# Modify.........: No.MOD-C30202 13/03/15 By lixh1 取消確認時如果異動數量為0,update異動數量(inb09)=申請數量(inb16)
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:MOD-C30811 12/03/22 By ck2yuan 若走多倉儲出貨,rvbs022重新編號
# Modify.........: No:MOD-C30846 12/03/26 By ck2yuan 入庫量應參考入庫單,包含未確認的
# Modify.........: No:FUN-C30117 12/04/09 By Sakura 查詢段使用dialog包起來 
# Modify.........: No:TQC-C40081 12/04/12 By xianghui 資料來源不是Z時，點QC的ACTION應給我相應的提示信息
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C30152 12/06/08 By bart aqct700加上取消特採的功能
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No:MOD-BA0194 12/07/11 By ck2yuan 驗退時不應控卡數量
# Modify.........: No:CHI-C70004 12/08/20 By ck2yuan 當單頭顯示驗退，則不控卡aqc-038
# Modify.........: No:MOD-C80185 12/08/28 By Elise 資料來源為出貨單時，應用axm-892
# Modify.........: No:CHI-CA0040 12/10/25 By bart 調整倉庫調撥控制條件
# Modify.........: No:MOD-CB0153 12/11/23 By Elise 單身檢驗量不可輸入大於送驗量
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:CHI-CB0019 12/11/30 By Elise 品名規格pmn041->ima02
# Modify.........: No:FUN-C30070 12/12/05 By bart 資料來源="自行輸入"時，收貨單號+項次只能為收貨單的免驗料
# Modify.........: No:FUN-C30149 12/12/11 By pauline 單身新增"產生單身資料" action
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-C30163 12/12/27 By pauline aqct110/aqct700/aqct800 insert時收貨單號開窗增加顯示送驗量欄位
# Modify.........: No:FUN-CC0015 12/12/28 By Lori 特採時,直接開窗維護QC料件判定結果，回寫合格量；合格量不可手動維護
# Modify.........: No:FUN-CC0014 13/01/10 By Lori 驗退時不可做QC料件維護(aqc1011)
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No.FUN-D10063 13/01/17 By Nina UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No:MOD-D10180 13/02/01 By Elise SQL應增加條件 rvu01=rvv01
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D30018 13/03/07 By Vampire (1) 但未考慮到缺點數與拒絕數量皆為0的情況應為合格
#                                                    (2) 缺點數會依照aqcs101的設定計算，l_chkqty 宣告為整數，未考慮到0.xxx的情況
# Modify.........: No:MOD-D20006 13/03/12 By jt_chen 游標由最後一筆往上移會離開單身
# Modify.........: No:FUN-D30065 13/03/22 By lixh1 修正特采的時候update rvb_file不成功的問題
# Modify.........: No.CHI-C80072 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  3.調整確認自動產生barcode
#                  4.調整取消確認自動作廢barcode
# Modify.........: No:MOD-D40046 13/04/09 By Elise 調整級數1916檢驗方式
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40015 13/04/17 By Nina (1)aimi100有勾選使用條碼&條碼產生時機='L'，確認前，
#                                                 (2)將產生條碼段移至確認chk段前，並CALL s_ibb_ins_rvbs寫入rvbs_file
#                                                 (3)若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D40019 13/04/23 By Nina 將DEV-D40015控卡確認或過帳段的程式移至跳出詢問是否確認或過帳前
# Modify.........: No:DEV-D40021 13/04/24 By TSD.sophy 若為條碼料件，不自動產生rvbs_file資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_qcs            RECORD LIKE qcs_file.*,
       g_qcs_t          RECORD LIKE qcs_file.*,
       g_qcs_o          RECORD LIKE qcs_file.*,
       g_qcs22          LIKE qcs_file.qcs22,    #No.FUN-680104 DEC(12,0) #bugno:7196
       g_qcs22s         LIKE qcs_file.qcs22,    #No:8689
       g_qcs01_t        LIKE qcs_file.qcs01,
       g_qcs02_t        LIKE qcs_file.qcs02,
       g_qcs05_t        LIKE qcs_file.qcs05,
       g_qct            DYNAMIC ARRAY OF RECORD
           qct03        LIKE qct_file.qct03,
           qct04        LIKE qct_file.qct04,
           azf03_1      LIKE azf_file.azf03,
           qct05        LIKE qct_file.qct05,
           qct06        LIKE qct_file.qct06,
           qct09        LIKE qct_file.qct09,
           qct10        LIKE qct_file.qct10,
#No.FUN-A80063 --begin  
           qct14        LIKE qct_file.qct14,
           qct15        LIKE qct_file.qct15,         
#No.FUN-A80063 --end
           qct11        LIKE qct_file.qct11,
           qct07        LIKE qct_file.qct07,
           qct08        LIKE qct_file.qct08,
           qct08_desc   LIKE ze_file.ze03,    #No.TQC-610007
           qctud01      LIKE qct_file.qctud01,
           qctud02      LIKE qct_file.qctud02,
           qctud03      LIKE qct_file.qctud03,
           qctud04      LIKE qct_file.qctud04,
           qctud05      LIKE qct_file.qctud05,
           qctud06      LIKE qct_file.qctud06,
           qctud07      LIKE qct_file.qctud07,
           qctud08      LIKE qct_file.qctud08,
           qctud09      LIKE qct_file.qctud09,
           qctud10      LIKE qct_file.qctud10,
           qctud11      LIKE qct_file.qctud11,
           qctud12      LIKE qct_file.qctud12,
           qctud13      LIKE qct_file.qctud13,
           qctud14      LIKE qct_file.qctud14,
           qctud15      LIKE qct_file.qctud15
                        END RECORD,
       g_qct_t          RECORD
          qct03         LIKE qct_file.qct03,
          qct04         LIKE qct_file.qct04,
          azf03_1       LIKE azf_file.azf03,
          qct05         LIKE qct_file.qct05,
          qct06         LIKE qct_file.qct06,
          qct09         LIKE qct_file.qct09,
          qct10         LIKE qct_file.qct10,
#No.FUN-A80063 --begin  
          qct14        LIKE qct_file.qct14,
          qct15        LIKE qct_file.qct15,         
#No.FUN-A80063 --end
          qct11         LIKE qct_file.qct11,
          qct07         LIKE qct_file.qct07,
          qct08         LIKE qct_file.qct08,
          qct08_desc    LIKE ze_file.ze03,   #No.TQC-610007
          qctud01       LIKE qct_file.qctud01,
          qctud02       LIKE qct_file.qctud02,
          qctud03       LIKE qct_file.qctud03,
          qctud04       LIKE qct_file.qctud04,
          qctud05       LIKE qct_file.qctud05,
          qctud06       LIKE qct_file.qctud06,
          qctud07       LIKE qct_file.qctud07,
          qctud08       LIKE qct_file.qctud08,
          qctud09       LIKE qct_file.qctud09,
          qctud10       LIKE qct_file.qctud10,
          qctud11       LIKE qct_file.qctud11,
          qctud12       LIKE qct_file.qctud12,
          qctud13       LIKE qct_file.qctud13,
          qctud14       LIKE qct_file.qctud14,
          qctud15       LIKE qct_file.qctud15
                        END RECORD,
       g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN
       g_rec_b          LIKE type_file.num5,                #單身筆數  #No.FUN-680104 SMALLINT
       g_void           LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
       l_cmd            LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(300)
       l_wc             STRING,
       l_ac             LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-680104 SMALLINT
       g_argv1          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01) #No.FUN-5C0077
       g_qcs03_t        LIKE qcs_file.qcs01    #No.FUN-5C0077
DEFINE m_gen02         LIKE gen_file.gen02,
       m_ima109        LIKE ima_file.ima109,
       qcs21_desc      LIKE ze_file.ze03,   #No.TQC-610007
       ima101_desc      LIKE gae_file.gae04,         #CHI-BC0018
       qcs17_desc       LIKE gae_file.gae04,         #CHI-BC0018
       des1,des2       LIKE ze_file.ze03,   #No.TQC-610007
       g_type           LIKE pmh_file.pmh22,   #MOD-890102
       g_ecm04          LIKE ecm_file.ecm04,   #MOD-890102
       ma_num1,ma_num2,mi_num1,mi_num2 LIKE type_file.num10        #No.FUN-680104 INTEGER
 
DEFINE tm RECORD  #FUN-630105
            slip    LIKE sfu_file.sfu01,
            l_date  LIKE type_file.dat,          #No.FUN-680104 DATE  #No.FUN-6A0160 date->l_date
            wh1     LIKE img_file.img02,
            wh2     LIKE img_file.img03,
            wh3     LIKE img_file.img04
          END RECORD
 
#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(72)
DEFINE g_msg2               LIKE type_file.chr1000  #TQC-660106  #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE l_rvb07s             LIKE rvb_file.rvb07   #No.FUN-610075
DEFINE g_ima906             LIKE ima_file.ima906  #No.FUN-610075
DEFINE g_argv2              LIKE qcs_file.qcs01   #FUN-5C0114
DEFINE g_argv3              LIKE qcs_file.qcs02   #FUN-680011
DEFINE g_argv4              LIKE qcs_file.qcs05   #FUN-680011
DEFINE g_argv5              STRING                #FUN-680011
DEFINE g_argv6              LIKE qcs_file.qcs00   #FUN-680011
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-840157
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-840157
DEFINE g_rvb05   LIKE rvb_file.rvb05   #No.MOD-860080
DEFINE g_rvb36   LIKE rvb_file.rvb36   #No.MOD-860080
DEFINE g_rvb37   LIKE rvb_file.rvb37   #No.MOD-860080
DEFINE g_rvb38   LIKE rvb_file.rvb38   #No.MOD-860080
DEFINE g_rvb90   LIKE rvb_file.rvb90   #CHI-C30064
DEFINE g_pmn07   LIKE pmn_file.pmn07   #No.MOD-860080
DEFINE g_img09   LIKE img_file.img09   #No.MOD-860080
DEFINE l_i       LIKE type_file.num5    #No.MOD-860080
DEFINE l_fac     LIKE ima_file.ima31_fac   #No.MOD-860080
DEFINE g_qty     LIKE qcs_file.qcs091   #No.FUN-860045
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE g_ima101  LIKE ima_file.ima101  #No.FUN-A80063
#FUN-B30170 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
DEFINE g_flag          LIKE type_file.chr1   #FUN-C30149 add  #判斷是否從單身點選action重新新增單身資料
 
FUNCTION t110(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6)
   DEFINE p_argv1 LIKE type_file.chr1         #No.FUN-680104 VARCHAR(01)
   DEFINE p_argv2 LIKE qcs_file.qcs01 #FUN-5C0114
   DEFINE p_argv3 LIKE qcs_file.qcs02 #FUN-680011
   DEFINE p_argv4 LIKE qcs_file.qcs05 #FUN-680011
   DEFINE p_argv5 STRING              #FUN-680011
   DEFINE p_argv6 LIKE qcs_file.qcs00 #FUN-680011
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2              #FUN-5C0114
   LET g_argv3 = p_argv3              #FUN-680011
   LET g_argv4 = p_argv4              #FUN-680011
   LET g_argv5 = p_argv5              #FUN-680011
   LET g_argv6 = p_argv6              #FUN-680011
 
   CASE g_argv1                                                                                                                     
      WHEN "1" LET g_prog = 'aqct110_icd'                                                                                               
      WHEN "2" LET g_prog = 'aqct700_icd'                                                                                               
      WHEN "3" LET g_prog = 'aqct800_icd'                                                                                               
      WHEN "4" LET g_prog = 'asrt310_icd'                                                                                    
      OTHERWISE 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
         EXIT PROGRAM
   END CASE
 
   LET g_forupd_sql = "SELECT * FROM qcs_file WHERE qcs01 = ? AND qcs02 = ? AND qcs05 = ? FOR UPDATE"    #liuxqa 091022
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
   IF g_argv1 != "1" THEN
      CALL t110_form_default()                  #No.FUN-5C0077
   END IF
   CALL t110_def_form()   #TQC-660106
   LET g_type  = '1'       #MOD-890102
   LET g_ecm04 = ' '       #MOD-890102
 
   IF g_prog='aqct800' THEN
      CALL cl_set_act_visible("special_purchase",FALSE)
   END IF
#FUN-A30045 -------------------Begin------------------------
   #IF g_argv1 != "1" THEN  #FUN-C30152
   IF g_argv1 != "1" AND g_argv1 != "2" THEN  #FUN-C30152
      CALL cl_set_act_visible("cancel_special_purchase",FALSE)
   END IF
#FUN-A30045 -------------------End---------------------------
   IF g_prog='aqct800_icd' THEN                                                                                                         
      CALL cl_set_act_visible("special_purchase",FALSE)                                                                             
   END IF      
 
   IF (g_argv1<>'4') OR (cl_null(g_argv1)) THEN #TQC-650121 add OR (cl_null(g_argv1))
      CALL cl_set_comp_visible("qcs20",FALSE) 
      CALL cl_set_act_visible("tran_store,core_item",FALSE)
   ELSE
      IF (g_sma.sma104<>'Y') OR (g_sma.sma105<>'1') THEN
         CALL cl_set_act_visible("core_item",FALSE)
      END IF
   END IF

   #FUN-BC0104--(S)-----
   IF g_argv1 MATCHES '[12]' AND g_qcz.qcz14='Y' THEN
     CALL cl_set_act_visible("qc_item_maintain",TRUE)
   ELSE
     CALL cl_set_act_visible("qc_item_maintain",FALSE)
   END IF
   #FUN-BC0104--(E)-----

   #DEV-D30045--add--begin
   IF g_prog <> 'aqct110' OR g_aza.aza131 = 'N' THEN
      CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
   END IF
   #DEV-D30045--add--end
 
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("qcs33,qcs34,qcs35",FALSE)
      CALL cl_set_comp_visible("qcs30,qcs31,qcs32",FALSE)  #No.FUN-610075
      CALL cl_set_comp_visible("qcs36,qcs37,qcs38",FALSE)  #No.FUN-610075
      CALL cl_set_comp_visible("qcs39,qcs40,qcs41",FALSE)  #No.FUN-610075
   END IF
 
   IF NOT cl_null(g_argv2) THEN
      CASE g_argv5 
         WHEN "SPC"                        #SPC-前端單據自動產生QC單
            CALL t110_a()                 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         WHEN "SPC_ins"                    #SPC-分批檢驗
            CALL t110_a()
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         WHEN "SPC_upd"                    #SPC-更新QC資料
            CALL t110_q()
            CALL t110_spc_upd()            
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         OTHERWISE
            CALL t110_q()
      END CASE
   END IF
 
   IF fgl_getenv('SPC') = "1" THEN
      CALL cl_err(g_prog ,'aws-093',0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF 
 
   CALL t110_menu()
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",TRUE)
      CALL cl_set_comp_visible("qcsspc",TRUE)
   END IF
END FUNCTION
 
FUNCTION t110_menu()
   DEFINE l_rvb04               LIKE rvb_file.rvb04                                                                                   
   DEFINE l_rvb34               LIKE rvb_file.rvb34                                                                                   
   DEFINE l_pmm02               LIKE pmm_file.pmm02                                                                                    
   DEFINE l_qck09               LIKE qck_file.qck09    #FUN-BC0104
   DEFINE l_type                LIKE type_file.chr1    #FUN-BC0104
                       
   WHILE TRUE
      CALL t110_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t110_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t110_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            CALL t110_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "detail_flaw_reason"                                                                                                 
            IF cl_chk_act_auth() THEN                                                                                              
               IF NOT cl_null(g_qcs.qcs01) THEN                                                                                    
                  LET g_msg="aqct111_icd '",g_qcs.qcs01,"' '",g_qcs.qcs02,"' '",g_qcs.qcs05,"' 1  "                                    
                  CALL cl_cmdrun_wait(g_msg)                                                                       
               END IF                                                                                                              
            END IF
           
         WHEN "qry_detail_measure"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcs.qcs01) THEN
                  LET g_msg="aqcq112 '",g_qcs.qcs01,"' '",g_qcs.qcs02,"' '",g_qcs.qcs05,"' 1  "
                  DISPLAY "g_qcs.qcs01=",g_qcs.qcs01
                  DISPLAY "g_qcs.qcs02=",g_qcs.qcs02
                  DISPLAY "g_qcs.qcs03=",g_qcs.qcs05
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t110_m()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t110_y_upd()       #CALL 原確認的 update 段
               END IF
 
               IF g_qcs.qcs14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_z()
               IF g_qcs.qcs14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
            END IF
         WHEN "special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t110_3()
            END IF
#FUN-A30045 ------------Begin---------------
         WHEN  "cancel_special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t110_4()
            END IF         
#FUN-A30045 ------------End-----------------

#FUN-BC0104 --------------Begin-------------
         WHEN "qc_item_maintain"
            IF cl_chk_act_auth() THEN
               #FUN-CC0014 add begin---
               IF g_qcs.qcs09 = '2' THEN
                  CALL cl_err('','aqc1011',1)
               ELSE
               #FUN-CC0014 add end-----

                  IF g_argv1 = '2' AND g_qcs.qcs00 <> 'Z' THEN  #TQC-C40081
                     CALL cl_err(l_type,'aqc-543',0)            #TQC-C40081
                  ELSE                                          #TQC-C40081
                           LET l_qck09='' LET l_type=''
                           SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
                            WHERE qck01=ima109
                              AND ima01=g_qcs.qcs021
                      IF l_qck09='Y' THEN            
                        CASE g_argv1
                            WHEN "1"
                                LET l_type='1'
                            WHEN "2"
                            #   LET l_type='4'   #TQC-C20196
                            #TQC-C20196 -------Begin--------
                                IF g_qcs.qcs00 = 'Z' THEN     
                                   LET l_type='4'
                                ELSE
                                   LET l_type=''
                                END IF
                            #TQC-C20196 -------End----------
                            OTHERWISE
                                LET l_type=''
                        END CASE
                     ELSE                                    #TQC-C30139
                        CALL cl_err(m_ima109,'aqc-537',0)    #TQC-C30139
                     END IF
                     IF NOT cl_null(l_type) THEN
                        LET g_msg = "aqci107 '",g_qcs.qcs01,"' '",g_qcs.qcs02,"' '",g_qcs.qcs05,"' '",l_type,"'"
                        CALL cl_cmdrun_wait(g_msg)
                       #CALL t110_qc_item_show()              #MOD-C30557
                     END IF
                  END IF     #TQC-C40081
               END IF    #FUN-CC0014 add 
            END IF
#FUN-BC0104 --------------End---------------

         #WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t110_x()                    #CHI-D20010
               CALL t110_x(1)                    #CHI-D20010
               IF g_qcs.qcs14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
            END IF
         #CHI-D20010----add--str
          #WHEN "取消作廢"
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #CALL t110_x()                    #CHI-D20010
               CALL t110_x(2)                    #CHI-D20010
               IF g_qcs.qcs14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
            END IF
         #CHI-D20010----add---end  
 
         #WHEN "工單備注" for ICD only
         WHEN "WO_Memo"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcs.qcs01) AND NOT cl_null(g_qcs.qcs02) THEN                                                        
                  LET l_rvb04 = NULL  LET l_rvb34 = NULL                                                                            
                  SELECT rvb04,rvb34 INTO l_rvb04,l_rvb34                                                                           
                    FROM rvb_file                                                                                                   
                   WHERE rvb01 = g_qcs.qcs01                                                                                        
                     AND rvb02 = g_qcs.qcs02                                                                                        
                  IF NOT cl_null(l_rvb04) THEN                                                                                      
                     LET l_pmm02 = NULL                                                                                             
                     SELECT pmm02 INTO l_pmm02 FROM pmm_file                                                                        
                      WHERE pmm01 = l_rvb04                                                                                         
                     IF NOT cl_null(l_pmm02) AND l_pmm02 = 'SUB' THEN                                                               
                        IF NOT cl_null(l_rvb34) THEN                                                                                
                           LET g_msg = "aici014 ","'",l_rvb34 CLIPPED,"'",                                                          
                                                  " '0' ",                                                                          
                                                  "'",g_prog CLIPPED,"'"                                                            
                           CALL cl_cmdrun_wait(g_msg)                                                                               
                        ELSE                                                                                                        
                           CALL cl_err('','aic-210',1)                                                                              
                        END IF                                                                                                      
                     ELSE                                                                                                           
                        CALL cl_err('','aic-211',1)                                                                                 
                     END IF                                                                                                         
                  ELSE                                                                                                              
                     CALL cl_err('','aic-211',1)      
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF     
         WHEN "WO_Issuing" 
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcs.qcs01) AND NOT cl_null(g_qcs.qcs02) THEN                                                        
                  LET l_rvb34 = NULL                                                                                                
                  SELECT rvb34 INTO l_rvb34 FROM rvb_file                                                                           
                   WHERE rvb01 = g_qcs.qcs01                                                                                        
                     AND rvb02 = g_qcs.qcs02                                                                                        
                  IF NOT cl_null(l_rvb34) THEN                                                                                      
                     LET g_msg = "asfi510 ","'1' '",l_rvb34 CLIPPED,"'"                                                             
                     CALL cl_cmdrun_wait(g_msg)                                                                                     
                  ELSE                                                                                                              
                     CALL cl_err('','aic-210',1)                                                                                    
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF                    
         WHEN "RETURN_INFO"
            IF cl_chk_act_auth() THEN 
               IF NOT cl_null(g_qcs.qcs01) AND NOT cl_null(g_qcs.qcs02) THEN                                                        
                  LET g_msg = "aicq021 ","'",g_qcs.qcs01 CLIPPED,"' '",                                                             
                                             g_qcs.qcs02 CLIPPED,"'"                                                                
                  CALL cl_cmdrun_wait(g_msg)                                                                                        
               END IF                                                                                                               
            END IF            
 
         WHEN "tran_store"
            IF cl_chk_act_auth() THEN
               CALL t110_w()
            END IF
         WHEN "core_item"
            IF cl_chk_act_auth() THEN
               CALL t110_v()
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qct),'','')
            END IF
 
         WHEN "trans_spc"         #FUN-680011
            IF cl_chk_act_auth() THEN
               CALL t110_spc()
            END IF
 
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_qcs.qcs01 IS NOT NULL THEN
                LET g_doc.column1 = "qcs01"
                LET g_doc.column2 = "qcs02"
                LET g_doc.column3 = "qcs05"
                LET g_doc.value1 = g_qcs.qcs01
                LET g_doc.value2 = g_qcs.qcs02
                LET g_doc.value3 = g_qcs.qcs05
                CALL cl_doc()
             END IF 
          END IF
        WHEN "qry_lot"
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_qcs.qcs021
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              #IF g_sma.sma90 = "Y" THEN  #No:MOD-860080   #CHI-A70047 
              IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
                 IF g_argv1 <> "4" THEN
                    IF g_qcs.qcs00 NOT MATCHES '[EFG]' THEN
                       CALL t110_get_fac()
                      #CALL s_lotin(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,       #TQC-B90236 mark
                      #             g_qcs.qcs021,g_pmn07,g_img09,l_fac,
                      #             g_qcs.qcs091,'','QRY') #CHI-9A0022 add ''
                       CALL s_mod_lot(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,       #TQC-B90236 add 
                                    g_qcs.qcs021,g_rvb36,g_rvb37,g_rvb38,g_pmn07,g_img09,l_fac,
                                    g_qcs.qcs091,'','QRY',1) #CHI-9A0022 add ''
                           RETURNING l_r,g_qty
                    END IF
                 END IF
              END IF
           END IF

        #DEV-D30045--add--begin
        WHEN "barcode_gen"     #條碼產生
            IF cl_chk_act_auth() THEN
               CALL t110_barcode_gen(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,'Y')
            END IF

        WHEN "barcode_query"   #條碼查詢
            IF cl_chk_act_auth() THEN
               LET g_msg = "abaq100 '",g_qcs.qcs01,"' "
               CALL cl_cmdrun_wait(g_msg)
            END IF

        WHEN "barcode_output"  #條碼列印
            IF cl_chk_act_auth() THEN
               CALL t110_barcode_out()
            END IF
        #DEV-D30045--add--end
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_qct.clear()
 
   IF cl_null(g_argv2) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INITIALIZE g_qcs.* TO NULL    #No.FUN-750051
      DIALOG ATTRIBUTES(UNBUFFERED) #FUN-C30117 add
      CONSTRUCT BY NAME g_wc ON qcs00,qcs01,qcs02,qcs05,qcs021,qcs03,
                                qcs04,qcs041,qcs22,qcs14,qcsspc,qcs15, #FUN-680011  #No.TQC-750064 del qcs06
                                qcs16,qcs10,qcs17,qcs091,qcs09,qcs13,
                                qcsuser,qcsgrup,qcsmodu,qcsdate,qcsacti,qcsoriu,qcsorig, #TQC-C20066 add oriu,orig
                                qcsud01,qcsud02,qcsud03,qcsud04,qcsud05,
                                qcsud06,qcsud07,qcsud08,qcsud09,qcsud10,
                                qcsud11,qcsud12,qcsud13,qcsud14,qcsud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(qcs01) #單號
                    CALL cl_init_qry_var()
                    IF g_argv1 = '1' THEN
                       LET g_qryparam.form = "q_qcs1"
                       LET g_qryparam.where = " qcs00 MATCHES '[12]' " 
                    ELSE
                       LET g_qryparam.form = "q_qcs1"
                       IF g_argv1 = '2' THEN
                          LET g_qryparam.where = " qcs00 MATCHES '[ABCDEFGHZ]' "   #No.FUN-740016
                       ELSE
                          IF g_argv1 = '4' THEN #FUN-5C0114
                            LET g_qryparam.where = " qcs00 = '7' " #FUN-5C0114
                          ELSE
                            LET g_qryparam.where = " qcs00 IN ('5','6') "
                          END IF
                       END IF
                    END IF
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_qcs.qcs01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO qcs01
                    NEXT FIELD qcs01
               WHEN INFIELD(qcs021) #料號
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.state = "c"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO qcs021
                    NEXT FIELD qcs021
               WHEN INFIELD(qcs03) #查詢廠商檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    IF g_argv1 = '3' THEN
                       LET g_qryparam.form = "q_occ"
                    ELSE
                       LET g_qryparam.form = "q_pmc"
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO qcs03
                    NEXT FIELD qcs03
               WHEN INFIELD(qcs13) #員工編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO qcs13
                    NEXT FIELD qcs13
            END CASE
 
      #FUN-C30117---mark---START
      #  ON IDLE g_idle_seconds
      #     CALL cl_on_idle()
      #     CONTINUE CONSTRUCT
 
      #  ON ACTION about         #MOD-4C0121
      #     CALL cl_about()      #MOD-4C0121
 
      #  ON ACTION help          #MOD-4C0121
      #     CALL cl_show_help()  #MOD-4C0121
 
      #  ON ACTION controlg      #MOD-4C0121
      #     CALL cl_cmdask()     #MOD-4C0121
 
      #         ON ACTION qbe_select
      #            CALL cl_qbe_list() RETURNING lc_qbe_sn
      #            CALL cl_qbe_display_condition(lc_qbe_sn)
      #FUN-C30117---mark---END
                   
      END CONSTRUCT
      
#FUN-C30117---mark---START
#     IF INT_FLAG THEN
#        RETURN
#     END IF
#  ELSE
#     LET g_wc="qcs01='",g_argv2,"'" #FUN-5C0114
#     IF NOT cl_null(g_argv3) THEN
#           LET g_wc = g_wc CLIPPED," AND qcs02=",g_argv3
#           IF NOT cl_null(g_argv4) THEN
#              LET g_wc = g_wc CLIPPED," AND qcs05=",g_argv4
#           END IF
#     END IF
#  END IF
#
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')

#  IF cl_null(g_argv2) THEN
#FUN-C30117---mark---END
      CONSTRUCT g_wc2 ON qct03,qct04,qct05,qct14,qct15,qct11,qct07,qct08    # 螢幕上取單身條件   #No.FUN-A80063
                         ,qctud01,qctud02,qctud03,qctud04,qctud05
                         ,qctud06,qctud07,qctud08,qctud09,qctud10
                         ,qctud11,qctud12,qctud13,qctud14,qctud15
                    FROM s_qct[1].qct03,s_qct[1].qct04,s_qct[1].qct05,s_qct[1].qct14,s_qct[1].qct15,   #No.FUN-A80063
                         s_qct[1].qct11,s_qct[1].qct07,s_qct[1].qct08
                         ,s_qct[1].qctud01,s_qct[1].qctud02,s_qct[1].qctud03
                         ,s_qct[1].qctud04,s_qct[1].qctud05,s_qct[1].qctud06
                         ,s_qct[1].qctud07,s_qct[1].qctud08,s_qct[1].qctud09
                         ,s_qct[1].qctud10,s_qct[1].qctud11,s_qct[1].qctud12
                         ,s_qct[1].qctud13,s_qct[1].qctud14,s_qct[1].qctud15
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
 
      #FUN-C30117---mark---START
      #  ON IDLE g_idle_seconds
      #     CALL cl_on_idle()
      #     CONTINUE CONSTRUCT
 
      #  ON ACTION about         #MOD-4C0121
      #     CALL cl_about()      #MOD-4C0121
 
      #  ON ACTION help          #MOD-4C0121
      #     CALL cl_show_help()  #MOD-4C0121
 
      #  ON ACTION controlg      #MOD-4C0121
      #     CALL cl_cmdask()     #MOD-4C0121
 
      #          ON ACTION qbe_save
      #		   CALL cl_qbe_save()
      #FUN-C30117---mark---END

      END CONSTRUCT
#FUN-C30117---add---START
         ON ACTION ACCEPT
             ACCEPT DIALOG
  
         ON ACTION cancel
             LET INT_FLAG = 1
             EXIT DIALOG         

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_save
            CALL cl_qbe_save()
   END DIALOG
#FUN-C30117---add---END
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   ELSE
#FUN-C30117---add---START
      LET g_wc="qcs01='",g_argv2,"'" #FUN-5C0114
      IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc CLIPPED," AND qcs02=",g_argv3
            IF NOT cl_null(g_argv4) THEN
               LET g_wc = g_wc CLIPPED," AND qcs05=",g_argv4
            END IF
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
#FUN-C30117---add---END
      LET g_wc2=" 1=1" #FUN-5C0114
   END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  qcs01,qcs02,qcs05 FROM qcs_file ",   #liuxqa 091022
                  " WHERE ", g_wc CLIPPED
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE qcs01, qcs02,qcs05 ",         #liuxqa 091022
                  "  FROM qcs_file, qct_file ",
                  " WHERE qcs01 = qct01",
                  "   AND qcs02 = qct02",
                  "   AND qcs05 = qct021",
                  "   AND ", g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
 
   CASE g_argv1
      WHEN "1"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('1','2') "        
      WHEN "2"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('A','B','C','D','E','F','G','H','Z') "   #No.FUN-740016
      WHEN "3"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('5','6') "
      WHEN "4" #FUN-5C0114
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('2','7') "  #FUN-5C0114
   END CASE
   LET g_sql = g_sql CLIPPED," ORDER BY qcs01,qcs02,qcs05 "
 
   PREPARE t110_prepare FROM g_sql
   DECLARE t110_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t110_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql = "SELECT COUNT(*) FROM qcs_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT qcs01) FROM qcs_file,qct_file WHERE ",
                  "qct01=qcs01 AND qct02=qcs02 AND qct021=qcs05 AND ",
                   g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   CASE g_argv1
      WHEN "1"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('1','2') "
      WHEN "2"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('A','B','C','D','E','F','G','H','Z') "   #No.FUN-740016
      WHEN "3"
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('5','6') "
      WHEN "4" #FUN-5C0114
         LET g_sql = g_sql CLIPPED," AND qcs00 IN ('2','7') "  #FUN-5C0114
   END CASE
 
   PREPARE t110_precount FROM g_sql
   DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
 
FUNCTION t110_a()
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_qct.clear()
   INITIALIZE g_qcs.* LIKE qcs_file.*             #DEFAULT 設定
 
   LET g_qcs01_t = NULL
   LET g_qcs02_t = NULL
   LET g_qcs05_t = NULL
   #預設值及將數值類變數清成零
   LET g_qcs_t.* = g_qcs.*
   LET g_qcs_o.* = g_qcs.*
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET m_gen02 = ' '
      LET m_ima109 = ' '
      LET qcs21_desc = ' '
      LET ima101_desc = ' '     #CHI-BC0018
      LET qcs17_desc = ' '      #CHI-BC0018
      LET des1 = ' '
      LET des2 = ' '
      LET ma_num1 = 0
      LET ma_num2 = 0
      LET mi_num1 = 0
      LET mi_num2 = 0
 
      CASE g_argv1
         WHEN "1"
            LET g_qcs.qcs00 = '1'
         WHEN "2"
            #FUN-680011
            IF g_argv5 = "SPC" OR g_argv5 = "SPC_ins" THEN
                LET g_qcs.qcs00 = g_argv6
            ELSE
                LET g_qcs.qcs00 = 'A'
            END IF
         WHEN "3"
            IF g_argv5 = "SPC" OR g_argv5 = "SPC_ins" THEN
                LET g_qcs.qcs00 = g_argv6
            ELSE
                LET g_qcs.qcs00 = '5'
            END IF
 
         WHEN "4" #FUN-5C0114
            LET g_qcs.qcs00 = '7'   #FUN-5C0114
      END CASE
 
      LET g_qcs.qcs16 = 'N'
      LET g_qcs.qcsuser = g_user
      LET g_qcs.qcsoriu = g_user #FUN-980030
      LET g_qcs.qcsorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_qcs.qcsgrup = g_grup
      LET g_qcs.qcsdate = g_today
      LET g_qcs.qcsacti = 'Y'              #資料有效
      LET g_qcs.qcs041 = TIME              #資料有效
      LET g_qcs.qcs04 = TODAY              #資料有效
      LET g_qcs.qcs14 = 'N'
      LET g_qcs.qcsspc = '0'               #FUN-680011
      LET g_qcs.qcs15 = ''
      LET g_qcs.qcs091 = 0
      LET g_qcs.qcs13 = g_user
      LET g_qcs_o.qcs13 = g_user          #MOD-910138
 
      IF g_argv5 = "SPC" OR g_argv5 = "SPC_ins" THEN
         BEGIN WORK
         IF NOT t110_spc_def() THEN
            ROLLBACK WORK
            EXIT WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL t110_i("a")                   #輸入單頭
 
         IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_qcs.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
         END IF
         
         IF cl_null(g_qcs.qcs01) OR cl_null(g_qcs.qcs02)
            OR cl_null(g_qcs.qcs05) THEN
            CONTINUE WHILE
         END IF
         #允收數量有double的情況
         #開啟兩個送驗畫面，畫面A，分批順序為1，尚不要展開單身；此時開啟畫面B
         #新增一張同樣的收貨單號、項次，但分批順序為2。在畫面A帶出單身後，B卻也可以帶出單身
         CALL t110_unqc_qty()
         IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_qcs.qcs01,g_errno,1)
             CONTINUE WHILE
         END IF
      END IF
 
      BEGIN WORK     #No.MOD-710117 add
      LET g_success='Y'
      LET g_qcs.qcsplant = g_plant #FUN-980007
      LET g_qcs.qcslegal = g_legal #FUN-980007
      INSERT INTO qcs_file VALUES (g_qcs.*)
      IF SQLCA.sqlcode THEN   		 #置入資料庫不成功
         CALL cl_err3("ins","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
         LET g_success='N'
      END IF
 
      IF (g_qcs.qcs00='7') AND (g_success='Y') THEN
         UPDATE srg_file SET srg12=g_qcs.qcs01 WHERE srg01=g_qcs.qcs01
                                                 AND srg02=g_qcs.qcs02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","srg_file",g_qcs.qcs01,g_qcs.qcs01,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            LET g_success='N'
         END IF
      END IF
 
      IF g_success='Y' THEN
         IF g_argv5 = "SPC_ins" AND fgl_getenv('SPC') = "1" THEN 
            IF NOT t110_spc_upd_process() THEN
                ROLLBACK WORK
                EXIT WHILE
            END IF
            IF g_aza.aza65 = 'Y' THEN
                CALL t110_y_chk()              #CALL 原確認的 check 段
                IF g_success = "Y" THEN
                   CALL t110_y_upd()           #CALL 原確認的 update 段
                END IF
                IF g_success = "N" THEN
                   ROLLBACK WORK
                   EXIT WHILE
                END IF
            END IF
         END IF
         COMMIT WORK
         IF g_argv5 = "SPC" OR g_argv5 = "SPC_ins" THEN
            EXIT WHILE
         END IF
      ELSE
         ROLLBACK WORK
         IF g_argv5 = "SPC" OR g_argv5 = "SPC_ins" THEN
             EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF
 
      LET g_qcs01_t = g_qcs.qcs01        #保留舊值
      LET g_qcs02_t = g_qcs.qcs02        #保留舊值
      LET g_qcs05_t = g_qcs.qcs05        #保留舊值
      LET g_qcs03_t = g_qcs.qcs03        #保留舊值  FUN-5C0077
      LET g_qcs_t.* = g_qcs.*
 
      CALL g_qct.clear()
      LET g_rec_b = 0
 
      CALL t110_g_b()
 
      CALL t110_b()                      #輸入單身
 
      CALL t110_ii('a')                  #No.MOD-480060
      IF INT_FLAG THEN
           LET INT_FLAG = 0
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_qcs.qcs01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcsacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qcs.qcs01,9027,0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'Y' THEN   #No.FUN-5C0077
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'Y' THEN
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_qcs01_t = g_qcs.qcs01
   LET g_qcs02_t = g_qcs.qcs02
   LET g_qcs05_t = g_qcs.qcs05
   LET g_qcs03_t = g_qcs.qcs03        #保留舊值  FUN-5C0077
   LET g_qcs_o.* = g_qcs.*
 
   BEGIN WORK
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t110_show()
 
   WHILE TRUE
      LET g_qcs01_t = g_qcs.qcs01
      LET g_qcs02_t = g_qcs.qcs02
      LET g_qcs05_t = g_qcs.qcs05
      LET g_qcs03_t = g_qcs.qcs03        #保留舊值  FUN-5C0077
      LET g_qcs.qcsmodu = g_user
      LET g_qcs.qcsdate = g_today
 
      CALL t110_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_qcs.* = g_qcs_t.*
         CALL t110_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_qcs.qcs01 != g_qcs01_t OR g_qcs.qcs02 != g_qcs02_t OR
         g_qcs.qcs05 != g_qcs05_t THEN
         UPDATE qct_file SET qct01 = g_qcs.qcs01,
                             qct02 = g_qcs.qcs02,
                             qct021 = g_qcs.qcs05
                        WHERE qct01 = g_qcs01_t
                          AND qct02 = g_qcs02_t
                          AND qct021 = g_qcs05_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","qct_file",g_qcs01_t,g_qcs02_t,SQLCA.sqlcode,"","qct",1)  #No.FUN-660115
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE qcs_file SET qcs_file.* = g_qcs.*
       WHERE qcs01 = g_qcs01_t AND qcs02 = g_qcs02_t AND qcs05 = g_qcs05_t   #liuxqa 091022 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","qcs_file",g_qcs01_t,g_qcs02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660115
         CONTINUE WHILE
      END IF
 
       CALL t110_ii('u')   
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('','9001',0)
           EXIT WHILE
       END IF
 
      EXIT WHILE
   END WHILE
 
 
   #功能: 通知 SPC 端刪除此張單據
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   #           (3)功能選項：insert(新增),update(修改),delete(刪除)
   IF g_qcs.qcsspc = '1' THEN
      IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcs),'update')
      THEN
           LET g_qcs.* = g_qcs_t.*
           CLOSE t110_cl
           ROLLBACK WORK
           RETURN
      END IF
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t110_i(p_cmd)
   DEFINE l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入  #No.FUN-680104 VARCHAR(1)
          l_p             LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
          p_cmd           LIKE type_file.chr1,                #a:輸入 u:更改  #No.FUN-680104 VARCHAR(1)
          l_ima25         LIKE ima_file.ima25,       #No.TQC-630089 add
          l_ima907        LIKE ima_file.ima907,      #No.TQC-630089 add
          l_factor        LIKE qcs_file.qcs31,       #No.TQC-630089 add
          m_pmc03         LIKE pmc_file.pmc03, 
          m_ima02         LIKE ima_file.ima02,
          m_ima021        LIKE ima_file.ima021,      #No.FUN-940103
          m_ima109        LIKE ima_file.ima109,
          m_ima15         LIKE ima_file.ima15,
          m_azf03         LIKE azf_file.azf03,
          m_pmh05         LIKE pmh_file.pmh05,
          m_pmh05_desc    LIKE ze_file.ze03,   #No.TQC-610007
          l_rvb           RECORD LIKE rvb_file.*,
          l_inb           RECORD LIKE inb_file.*,        #No.FUN-5C0077
          l_imn           RECORD LIKE imn_file.*,        #No.FUN-5C0077
          l_imp           RECORD LIKE imp_file.*,        #No.FUN-5C0077
          l_imq           RECORD LIKE imq_file.*,        #No.FUN-5C0077
          l_qsa           RECORD LIKE qsa_file.*,        #No.FUN-5C0077
          l_ogb           RECORD LIKE ogb_file.*,        #No.FUN-5C0077
          l_err           LIKE ze_file.ze01,             #No.FUN-5C0077
          l_srg05         LIKE srg_file.srg05,           #FUN-640036
          l_qcs22         LIKE qcs_file.qcs22,           #FUN-640036
          l_cnt           LIKE type_file.num5,  #FUN-5C0114  #No.FUN-680104 SMALLINT
          l_qsa06_u       LIKE qsa_file.qsa06,           #No.TQC-760005
          l_qcs22_u       LIKE qcs_file.qcs22            #No.TQC-760005
   DEFINE l_ogb04         LIKE ogb_file.ogb04   #CHI-9A0052
   DEFINE l_ogb17         LIKE ogb_file.ogb17   #CHI-9A0052
   DEFINE l_ogc17         LIKE ogc_file.ogc17   #CHI-9A0052
   DEFINE l_flag2         LIKE type_file.chr1   #CHI-9A0052
   DEFINE l_ima44         LIKE ima_file.ima44   #FUN-BB0085
 
 
   LET l_p = 'N'
 
   DISPLAY BY NAME g_qcs.qcs00,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,
                   g_qcs.qcs021,g_qcs.qcs03,g_qcs.qcs04,g_qcs.qcs041,
                   g_qcs.qcs16,g_qcs.qcs21,g_qcs.qcs17,g_qcs.qcs22,
                   g_qcs.qcs09,g_qcs.qcs13,   #No.TQC-750064 del qcs06
                   g_qcs.qcs14,g_qcs.qcsspc,g_qcs.qcs15,g_qcs.qcsuser,g_qcs.qcsgrup, #FUN-680011
                   g_qcs.qcsmodu,g_qcs.qcsdate,g_qcs.qcsacti,g_qcs.qcsoriu,g_qcs.qcsorig #TQC-C20066
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT BY NAME g_qcs.qcs00,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qcs.qcs021, g_qcs.qcsoriu,g_qcs.qcsorig,
                 g_qcs.qcs03,g_qcs.qcs33,g_qcs.qcs34,g_qcs.qcs35,  #No.FUN-610075
                 g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,  #No.FUN-610075
                 g_qcs.qcs04,g_qcs.qcs041,g_qcs.qcs22, #No.TQC-750064 del qcs06
                 g_qcs.qcs14,g_qcs.qcsspc,g_qcs.qcs15,g_qcs.qcs16,g_qcs.qcs10,g_qcs.qcs17, #FUN-680011
                 g_qcs.qcsuser,g_qcs.qcsgrup,g_qcs.qcsmodu,g_qcs.qcsdate,
                 g_qcs.qcsacti,
                 g_qcs.qcsud01,g_qcs.qcsud02,g_qcs.qcsud03,g_qcs.qcsud04,
                 g_qcs.qcsud05,g_qcs.qcsud06,g_qcs.qcsud07,g_qcs.qcsud08,
                 g_qcs.qcsud09,g_qcs.qcsud10,g_qcs.qcsud11,g_qcs.qcsud12,
                 g_qcs.qcsud13,g_qcs.qcsud14,g_qcs.qcsud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t110_set_entry(p_cmd)
         CALL t110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      BEFORE FIELD qcs00                 #MOD-4B0140
         CALL t110_set_entry(p_cmd)      #MOD-4B0140
 
      AFTER FIELD qcs00
         IF NOT cl_null(g_qcs.qcs00) THEN
            CASE g_argv1
               WHEN "1"
                  IF g_qcs.qcs00 NOT MATCHES '[12]' THEN
                     NEXT FIELD qcs00
                  END IF
               WHEN "2"
                  IF g_qcs.qcs00 NOT MATCHES '[ABCDEFGHZ]' THEN   #No.FUN-740016
                     NEXT FIELD qcs00
                  END IF
               WHEN "3"
                  IF g_qcs.qcs00 NOT MATCHES '[56]' THEN
                     NEXT FIELD qcs00
                  END IF
               WHEN "4" #FUN-5C0114
                  IF g_qcs.qcs00 NOT MATCHES '[27]' THEN #FUN-5C0114
                     NEXT FIELD qcs00 #FUN-5C0114
                  END IF #FUN-5C0114
            END CASE
            #Add NO.TQC-B10019
            IF NOT cl_null(g_qcs.qcs01) THEN
               CALL t110_qcs01() RETURNING l_err
               IF NOT cl_null(l_err) THEN
                  CALL cl_err(g_qcs.qcs01,l_err,0)
                  NEXT FIELD qcs00
               END IF
            END IF
            #End Add NO.TQC-B10019
         END IF
         CALL t110_set_no_entry(p_cmd) #MOD-4B0140
 
      AFTER FIELD qcs01
         IF NOT cl_null(g_qcs.qcs01) THEN
           LET g_qcs.qcs05 = NULL
           DISPLAY BY NAME g_qcs.qcs05
 
            CALL t110_qcs01() RETURNING l_err #MOD-740273
            IF NOT cl_null(l_err) THEN
               CALL cl_err(g_qcs.qcs01,l_err,0)
               NEXT FIELD qcs01
            END IF
           #MOD-A80165---add---start---
            IF NOT cl_null(g_qcs.qcs02) THEN
               CALL t110_check_qc() RETURNING l_err
               IF NOT cl_null(l_err) THEN
                  CALL cl_err(g_qcs.qcs01,l_err,0)
                  NEXT FIELD qcs01
               END IF
            END IF
           #MOD-A80165---add---end---
           #MOD-C30560---add---str---
           IF g_argv1 = '2' AND g_qcs.qcs00 = 'B' THEN 
              IF NOT cl_null(g_qcs.qcs02) THEN 
                 IF NOT t110_chk_qc() THEN 
                    CALL cl_err(g_qcs.qcs01,'aqc-541',0)
                    NEXT FIELD qcs01
                 END IF 
              END IF
           END IF
           #MOD-C30560---add---end--
            IF g_argv1 = '2' AND g_qcs.qcs00 = 'G' THEN
               #申請單時檢驗項次值初始default,表示是單張
               LET g_qcs.qcs02 = 0
               SELECT * INTO l_qsa.*
                 FROM qsa_file
                WHERE qsa01 = g_qcs.qcs01
                  AND qsa08 = 'Y'
                  AND qsa06 > 0
               IF STATUS = 100 THEN
                  CALL cl_err3("sel","qsa_file",g_qcs.qcs01,"","mfg3070","","",1)  #No.FUN-660115
                  NEXT FIELD qcs01
               END IF
               DISPLAY g_qcs.qcs02 TO qcs02
               CALL t110_ref()
               CALL cl_set_comp_entry("qcs35",TRUE)
               #No.TQC-AC0166  --Begin                                          
               LET g_qcs.qcs16= l_qsa.qsa10                                     
               DISPLAY BY NAME g_qcs.qcs16                                      
               #No.TQC-AC0166  --End     
               LET l_qcs22 = 0
             IF p_cmd='a' THEN   #No.TQC-760005     
               SELECT SUM(qcs22) 
                 INTO l_qcs22 FROM qcs_file
                WHERE qcs01 =g_qcs.qcs01 
                  AND qcs14 !='X' 
                  AND qcs00 = 'G'
 
               IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
               LET l_qsa.qsa06 = l_qsa.qsa06-l_qcs22
               IF l_qsa.qsa06 <= 0 THEN
                   #此料已全部送驗!  
                   #此收貨單+項次送驗資料皆已登打,請重新輸入!
                   CALL cl_err ('','aqc-114',1)
                   NEXT FIELD qcs01
               END IF
               LET g_qcs.qcs22 = l_qsa.qsa06
               #FUN-BB0085-add-str--
               SELECT ima44 INTO l_ima44 FROM ima_file
                WHERE ima01 = g_qcs.qcs021
               LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)
               #FUN-BB0085-add-end--
               DISPLAY g_qcs.qcs22 TO qcs22
             END IF    #No.TQC-760005
 
               IF l_qsa.qsa14 = '1' THEN
                  LET g_qcs.qcs32 = l_qsa.qsa06
                  IF cl_null(l_qsa.qsa04) THEN LET l_qsa.qsa04 = ' ' END IF
                  IF cl_null(l_qsa.qsa05) THEN LET l_qsa.qsa05 = ' ' END IF
                  SELECT img09 INTO g_qcs.qcs30 
                    FROM img_file
                   WHERE img01 = l_qsa.qsa02
                     AND img02 = l_qsa.qsa03
                     AND img03 = l_qsa.qsa04
                     AND img04 = l_qsa.qsa05
                  LET g_qcs.qcs31 = 1
                  CALL cl_set_comp_entry("qcs35",FALSE)
               ELSE
                  LET g_qcs.qcs30 = l_qsa.qsa30
                  LET g_qcs.qcs31 = l_qsa.qsa31
                  LET g_qcs.qcs32 = l_qsa.qsa32
                  LET g_qcs.qcs33 = l_qsa.qsa33
                  LET g_qcs.qcs34 = l_qsa.qsa34
                  LET g_qcs.qcs35 = l_qsa.qsa35
               END IF
               LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)   #FUN-BB0085
               DISPLAY g_qcs.qcs30 TO qcs30
               DISPLAY g_qcs.qcs31 TO qcs31
               DISPLAY g_qcs.qcs32 TO qcs32
               DISPLAY g_qcs.qcs33 TO qcs33
               DISPLAY g_qcs.qcs34 TO qcs34
               DISPLAY g_qcs.qcs35 TO qcs35
            END IF
            LET g_qcs_o.qcs01 = g_qcs.qcs01
         END IF
 
      BEFORE FIELD qcs02
         CALL t110_set_entry(p_cmd)
 
      AFTER FIELD qcs02
         IF NOT cl_null(g_qcs.qcs02) THEN
            #MOD-C30560---add---str---
            IF g_argv1 = '2' AND g_qcs.qcs00 = 'B' THEN
               IF NOT cl_null(g_qcs.qcs01) THEN
                  IF NOT t110_chk_qc() THEN
                     CALL cl_err(g_qcs.qcs01,'aqc-541',0)
                     NEXT FIELD qcs02
                  END IF
               END IF
            END IF
            #MOD-C30560---add---end--
            IF NOT (g_argv1 = '2' AND g_qcs.qcs00 = 'Z' ) THEN
               CALL t110_check_qc() RETURNING l_err #MOD-740273 
               IF NOT cl_null(l_err) THEN
                  LET g_qcs.qcs02 = g_qcs_t.qcs02    #MOD-C30156
                 #NEXT FIELD qcs01         #MOD-C30156 mark
                  NEXT FIELD qcs02         #MOD-C30156
               END IF
            
               IF p_cmd = 'a' OR p_cmd = 'u' AND (g_qcs.qcs01 <> g_qcs_t.qcs01 
                              OR g_qcs.qcs02 <> g_qcs_t.qcs02) THEN
                  CALL t110_unqc_qty() 
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_qcs.qcs01,g_errno,1)
                      NEXT FIELD qcs01
                  END IF
               END IF   #No.MOD-970026
               CALL t110_ref()
            END IF
            LET g_qcs_o.qcs02 = g_qcs.qcs02
            CALL t110_qcs02(p_cmd)  #No.FUN-5C0077          #MOD-C30339 add p_cmd
            LET g_qcs22 = g_qcs.qcs22                         #NO.TQC=750225
           CALL t110_qcs02_1()
            #MOD-BC0044--begin
            IF g_qcs.qcs22=0 THEN
               CALL cl_err('','aqc-338',1)
               NEXT FIELD qcs02
            END IF
            #MOD-BC0044--end
         END IF
         CALL t110_set_no_entry(p_cmd)
 
      #MOD-4B0141 ADD此段 給分批檢驗順序預設值
      BEFORE FIELD qcs05
         IF p_cmd='a' THEN   #No.TQC-760005
      #     IF cl_null(g_qcs.qcs05) OR g_qcs.qcs05 = 0 THEN   #MOD-C30559 mark
               SELECT MAX(qcs05) + 1 INTO g_qcs.qcs05
                 FROM qcs_file
                WHERE qcs01 = g_qcs.qcs01
                  AND qcs02 = g_qcs.qcs02
               IF cl_null(g_qcs.qcs05) THEN
                  LET g_qcs.qcs05 = 1
               END IF
      #     END IF            #MOD-C30559   mark
         ELSE
            LET g_qcs.qcs05=g_qcs05_t  #No.TQC-760005
         END IF   #No.TQC-760005
 
      AFTER FIELD qcs05
         IF NOT cl_null(g_qcs.qcs05) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND (g_qcs.qcs01 != g_qcs01_t OR
                                 g_qcs.qcs02 != g_qcs02_t OR
                                 g_qcs.qcs05 != g_qcs05_t)) THEN
               SELECT COUNT(*) INTO g_cnt FROM qcs_file
                WHERE qcs01 = g_qcs.qcs01
                  AND qcs02 = g_qcs.qcs02
                  AND qcs05 = g_qcs.qcs05
               IF g_cnt > 0 THEN
                  LET g_msg=g_qcs.qcs01 CLIPPED,'+',g_qcs.qcs02 CLIPPED,'+',
                            g_qcs.qcs05 CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD qcs01
               END IF
            END IF
            CALL t110_qcs05()   #No.FUN-860045
         END IF
 
      BEFORE FIELD qcs021
         IF g_qcs.qcs00 NOT MATCHES '[2Z]' THEN   #No.FUN-5C0077
            CALL t110_qcs10()   #bugno:6831 add
         END IF
 
      AFTER FIELD qcs021
         IF NOT cl_null(g_qcs.qcs021) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_qcs.qcs021,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_qcs.qcs021= g_qcs_t.qcs021
               NEXT FIELD qcs021
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_qcs.qcs00 MATCHES '[56]' THEN
               SELECT ogb04,ogb17 INTO l_ogb04,l_ogb17 FROM ogb_file
                WHERE ogb01=g_qcs.qcs01 AND ogb03=g_qcs.qcs02
               SELECT oaz23 INTO g_oaz.oaz23 FROM oaz_file WHERE oaz00='0'
               IF l_ogb17='Y' AND g_sma.sma115='N' AND g_oaz.oaz23='Y' THEN
                  DECLARE ogc_cur CURSOR FOR
                    SELECT ogc17 FROM ogc_file 
                      WHERE ogc01=g_qcs.qcs01 AND ogc03=g_qcs.qcs02
                  LET l_flag2='0'
                  FOREACH ogc_cur INTO l_ogc17
                    IF g_qcs.qcs021 <> l_ogc17 THEN
                       CONTINUE FOREACH
                    ELSE
                       LET l_flag2='1'
                       EXIT FOREACH
                    END IF
                  END FOREACH 
                  IF l_flag2='0' THEN 
                     CALL cl_err('','aqc-800',0)
                     NEXT FIELD qcs021
                  END IF
               ELSE
                  IF l_ogb04 <> g_qcs.qcs021 THEN
                     CALL cl_err(l_ogb04,'aqc-800',0)
                     NEXT FIELD qcs021
                  END IF
               END IF
            END IF
            SELECT ima02,ima021,ima109,ima15,ima906,ima25,ima907,ima101   #No.FUN-620043  #No.TQC-630089 modify  FUN-A80063 add ma101   #No.FUN-940103 add ima021
              INTO m_ima02,m_ima021,m_ima109,m_ima15,g_ima906,l_ima25,l_ima907,g_ima101   #No.FUN-620043  #No.TQC-630089 modify  FUN-A80063 add ima101  #No.FUN-940103
              FROM ima_file
             WHERE ima01 = g_qcs.qcs021
            IF STATUS=100 THEN
               LET m_ima02 = ' '
               LET m_ima021 = ' '     #No.FUN-940103
               LET m_ima109 = ' '
               LET m_ima15 = ' '
               CALL cl_err3("sel","ima_file",g_qcs.qcs021,"","mfg1201","","",1)  #No.FUN-660115
               NEXT FIELD qcs021
            END IF
         #判斷當資料來源為'自行輸入時'單位與轉換率改抓取料件基本檔
            IF g_qcs.qcs00 = '2' THEN
               LET g_qcs.qcs30 = l_ima25
               LET g_qcs.qcs33 = l_ima907
               LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)     #FUN-BB0085
               LET g_qcs.qcs35 = s_digqty(g_qcs.qcs35,g_qcs.qcs33)     #FUN-BB0085
               DISPLAY g_qcs.qcs32,g_qcs.qcs35 TO qcs32,qcs35          #FUN-BB0085
            END IF
            LET g_qcs.qcs31 = 1
            IF g_ima906 != '1' THEN     #使用多單位
               CALL s_umfchk(g_qcs.qcs021,l_ima907,l_ima25) RETURNING l_flag,l_factor
               IF l_flag=1 THEN
                  LET l_factor=1
               END IF
               LET g_qcs.qcs34=l_factor
               DISPLAY g_qcs.qcs33 TO qcs33
               DISPLAY g_qcs.qcs34 TO qcs34
            END IF
            DISPLAY g_qcs.qcs30 TO qcs30
            DISPLAY g_qcs.qcs31 TO qcs31
            DISPLAY m_ima02 TO FORMONLY.ima02        #CHI-CB0019 mod pmn041->ima02
            DISPLAY m_ima021 TO FORMONLY.ima021      #No.FUN-940103
            DISPLAY m_ima109 TO FORMONLY.ima109
            DISPLAY g_ima101 TO ima101   #No.FUN-A80063
            DISPLAY m_ima15 TO FORMONLY.ima15
            SELECT azf03 INTO m_azf03 FROM azf_file
             WHERE azf01 = m_ima109
               AND azf02 = '8'
            IF STATUS THEN LET m_azf03=' ' END IF
            DISPLAY m_azf03 TO FORMONLY.azf03
#TQC-C10085 --begin--
         ELSE
            NEXT FIELD CURRENT
#TQC-C10085 --end--
         END IF
 
      AFTER FIELD qcs03
         CALL t110_qcs03_def()
         IF NOT cl_null(g_errno) THEN
            NEXT FIELD qcs03 #NO.MOD-930031
         END IF
 
      BEFORE FIELD qcs04
         CALL t110_qcs10()   #bugno:6831 add
 
      AFTER FIELD qcs16
         IF NOT cl_null(g_qcs.qcs16) THEN
            IF g_qcs.qcs16 NOT MATCHES '[YN]' THEN
               NEXT FIELD qcs16
            END IF
         END IF
 
      AFTER FIELD qcs32
         #FUN-BB0085-add-str--
         IF NOT cl_null(g_qcs.qcs32) THEN
            IF g_qcs.qcs32 != g_qcs_t.qcs32 OR cl_null(g_qcs_t.qcs32) THEN
               LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)
               DISPLAY BY NAME g_qcs.qcs32
            END IF
         END IF
         #FUN-BB0085-add-str--
         IF g_qcs.qcs32 >= 0 THEN
            CALL t110_set_qcs22()
            IF g_argv1<>'4' THEN #FUN-640036
               IF g_qcs.qcs22 > l_rvb07s - g_qcs22s THEN
                  CALL cl_err(g_qcs.qcs22,'aqc-037',0)
                  NEXT FIELD qcs32
               END IF
               LET g_qcs22 = g_qcs.qcs22
               DISPLAY BY NAME g_qcs.qcs22
            ELSE
               IF g_qcs.qcs00='7' THEN #需 check 量不可大於報工量,需經過單位換算
                  IF cl_null(g_qcs.qcs01) THEN
                     NEXT FIELD qcs01
                  END IF
                  IF cl_null(g_qcs.qcs02) THEN
                     NEXT FIELD qcs02
                  END IF
                  IF cl_null(g_qcs.qcs05) THEN
                     NEXT FIELD qcs05
                  END IF
                  SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file
                                                 WHERE qcs01=g_qcs.qcs01
                                                   AND qcs02=g_qcs.qcs02
                                                   AND qcs14<>'X'
                                                   AND qcsacti='Y'
                                                   AND qcs05<>g_qcs.qcs05
                  IF SQLCA.sqlcode OR cl_null(l_qcs22) THEN
                     LET l_qcs22=0
                  END IF
                  LET l_qcs22=l_qcs22+g_qcs.qcs22
                  SELECT srg05 INTO l_srg05 FROM srg_file
                     WHERE srg01=g_qcs.qcs01
                       AND srg02=g_qcs.qcs02
                  IF SQLCA.sqlcode OR cl_null(l_srg05) THEN
                     LET l_srg05=0
                  END IF
                  IF l_qcs22 > l_srg05 THEN
                     CALL cl_err(l_qcs22,'asr-039',1)
                     NEXT FIELD qcs32 
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD qcs35
         #FUN-BB0085-add-str--
         IF NOT cl_null(g_qcs.qcs35) THEN
            IF g_qcs.qcs35 != g_qcs_t.qcs35 OR cl_null(g_qcs_t.qcs35) THEN
               LET g_qcs.qcs35 = s_digqty(g_qcs.qcs35,g_qcs.qcs33)
               DISPLAY BY NAME g_qcs.qcs35
            END IF
         END IF
         #FUN-BB0085-add-str--
         IF g_qcs.qcs35 >= 0 THEN
            CALL t110_set_qcs22()
            IF g_argv1<>'4' THEN #FUN-640036
               IF g_qcs.qcs22 > l_rvb07s - g_qcs22s THEN
                  CALL cl_err(g_qcs.qcs22,'aqc-037',0)
                  NEXT FIELD qcs35
               END IF
               LET g_qcs22 = g_qcs.qcs22
               DISPLAY BY NAME g_qcs.qcs22
            END IF
         END IF
 
      AFTER FIELD qcs22
         #FUN-BB0085-add-str--
         SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01 = g_qcs.qcs021
         IF NOT cl_null(g_qcs.qcs22) THEN
            IF cl_null(g_qcs_t.qcs22) OR g_qcs_t.qcs22 != g_qcs.qcs22 THEN 
               LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)
               DISPLAY BY NAME g_qcs.qcs22
            END IF
         END IF 
         #FUN-BB0085-add-end--
         IF NOT cl_null(g_qcs.qcs22) THEN
            IF g_qcs.qcs22 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD qcs22
            END IF 
            IF g_qcs.qcs22=0 THEN
               CALL cl_err('','aqc-028',0)
               NEXT FIELD qcs22
            END IF
            IF g_qcs.qcs22>l_rvb07s-g_qcs22s THEN #No:8689 #MOD-530720
               CALL cl_err(g_qcs.qcs22,'aqc-037',0)
               NEXT FIELD qcs22
            END IF
            IF p_cmd='a' THEN
               IF g_qcs.qcs22>l_qsa.qsa06 THEN
                  CALL cl_err(g_qcs.qcs22,'aqc-020',0)
                  NEXT FIELD qcs22
               END IF
            END IF
            IF p_cmd='u' THEN
               SELECT SUM(qcs22) 
                 INTO l_qcs22_u FROM qcs_file
                WHERE qcs01 =g_qcs.qcs01 
                  AND qcs05 !=g_qcs.qcs05 
                  AND qcs14 !='X' 
                  AND qcs00 = 'G'
               
               IF l_qcs22_u IS NULL THEN
                  LET l_qcs22_u=0 
               END IF
 
               LET l_qsa06_u=l_qsa.qsa06-l_qcs22_u
 
               IF g_qcs.qcs22>l_qsa06_u THEN
                  CALL cl_err(g_qcs.qcs22,'aqc-020',0)
                  NEXT FIELD qcs22
               END IF
            END IF 
            SELECT ima918,ima921 INTO g_ima918,g_ima921 
              FROM ima_file
             WHERE ima01 = g_qcs.qcs021
               AND imaacti = "Y"
            
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
               IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
                  IF g_argv1 <> "4" THEN
                     IF g_qcs.qcs00 NOT MATCHES '[EFG]' THEN
                        CALL t110_get_fac()
                       #CALL s_lotin(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,         #TQC-B90236 mark
                       #             g_qcs.qcs021,g_pmn07,g_img09,l_fac,
                       #             g_qcs.qcs22,'','SEL')  #CHI-9A0022 add ''
                        CALL s_mod_lot(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,         #TQC-B90236 add
                                     g_qcs.qcs021,g_rvb36,g_rvb37,g_rvb38,g_pmn07,g_img09,l_fac,
                                     g_qcs.qcs22,'','SEL',1)  #CHI-9A0022 add ''
                           RETURNING l_r,g_qty
                        IF l_r = "Y" THEN
                           LET g_qcs.qcs22 = g_qty
                           LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)   #FUN-BB0085
                        END IF
                     END IF
                  END IF
               END IF
            END IF
            LET g_qcs22 = g_qcs.qcs22       #bugno:7196
         END IF
 
      AFTER FIELD qcsud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcsud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT
         LET g_qcs.qcsuser = s_get_data_owner("qcs_file") #FUN-C10039
         LET g_qcs.qcsgrup = s_get_data_group("qcs_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_qcs.qcs00 MATCHES '[156]' THEN  #No.FUN-5C0077
            IF cl_null(g_qcs.qcs03) THEN
               NEXT FIELD qcs03
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcs01) AND g_qcs.qcs00 != 'Z' #單號 FUN-5C0077
            IF g_qcs.qcs00 matches '[ABCDEFGH]' THEN 
               CALL q_qcs(FALSE,TRUE,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs00)
                    RETURNING g_qcs.qcs01,g_qcs.qcs02
                    DISPLAY BY NAME g_qcs.qcs01,g_qcs.qcs02
                    NEXT FIELD qcs01
            ELSE
               CALL cl_init_qry_var()
               CASE
                  WHEN g_qcs.qcs00 = '1'
                     CALL q_rvaaqc3(FALSE, TRUE, g_qcs.qcs01)   #No.MOD-7B0125
                        RETURNING g_qcs.qcs01,g_qcs.qcs02
                  WHEN g_qcs.qcs00 = '2'
                     LET g_qryparam.form = "q_rvaaqc"
                  WHEN g_qcs.qcs00 = '5'
                    #LET g_qryparam.form = "q_ogb08"   #CHI-870023   #FUN-C30163 mark
                    #FUN-C30163 add START
                     LET g_qryparam.where = " oga09 IN ('1','5') ",
                                            "  AND ogb01||ogb03 NOT IN (SELECT qcs01||qcs02 FROM qcs_file WHERE qcs14 !='X' AND qcs14 !='Y') "
                     CALL q_ogb6(FALSE,TRUE,g_qryparam.where,g_qcs.qcs01,g_qcs.qcs02,'Y',g_qcs.qcs00,p_cmd,g_qcs_o.qcs05) 
                          RETURNING g_qcs.qcs01,g_qcs.qcs02
                    #FUN-C30163 add
                  WHEN g_qcs.qcs00 = '6' #CHI-6A0059
                    #LET g_qryparam.form = "q_ogb9"   #FUN-640100  #FUN-C30163  mark
                    #FUN-C30163 add START
                     LET g_qryparam.where = " oga09 IN ('2','3','4','6','7','8','A')  " 
                     CALL q_ogb6(FALSE,TRUE,g_qryparam.where,g_qcs.qcs01,g_qcs.qcs02,'Y',g_qcs.qcs00,p_cmd,g_qcs_o.qcs05) 
                          RETURNING g_qcs.qcs01,g_qcs.qcs02
                    #FUN-C30163 add
                  WHEN g_qcs.qcs00 = '7'
                     LET g_qryparam.form = "q_srg"
                     LET g_qryparam.arg1='Y'
                     CALL cl_create_qry() RETURNING g_qcs.qcs01,g_qcs.qcs02
               END CASE
               LET g_qryparam.default1 = g_qcs.qcs01
              #IF g_qcs.qcs00 = '6' THEN LET g_qryparam.where= " oga09 IN ('2','3','4','6','7','8','A')" END IF #MOD-B10110 add A  #FUN-C30163 mark
               IF g_qcs.qcs00 <> '1' AND g_qcs.qcs00 <> '7' THEN #FUN-5C0114  #CHI-6B0075
                  IF g_qcs.qcs00 = '5' OR g_qcs.qcs00 = '6' THEN
                    #CALL cl_create_qry() RETURNING g_qcs.qcs01,g_qcs.qcs02   #FUN-C30163 mark
                  ELSE
                     CALL cl_create_qry() RETURNING g_qcs.qcs01
                  END IF   #FUN-640100 add
               END IF
               DISPLAY BY NAME g_qcs.qcs01
               IF g_qcs.qcs00 = '1' OR g_qcs.qcs00 = '5' OR g_qcs.qcs00 = '6' THEN    #CHI-6B0075
                  DISPLAY BY NAME g_qcs.qcs02
                  CALL t110_qcs02_1()
               END IF   
               LET l_p='Y'
               NEXT FIELD qcs01
            END IF #No.FUN-880074
            WHEN INFIELD(qcs021) #料號
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.default1 = g_qcs.qcs021
#              CALL cl_create_qry() RETURNING g_qcs.qcs021
               CALL q_sel_ima(FALSE, "q_ima","",g_qcs.qcs021,"","","","","",'' ) 
                 RETURNING g_qcs.qcs021  
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_qcs.qcs021
               NEXT FIELD qcs021
            WHEN INFIELD(qcs03) #查詢廠商檔
               CALL cl_init_qry_var()
               IF g_argv1 = '3' THEN
                  LET g_qryparam.form = "q_occ"
               ELSE
                  LET g_qryparam.form = "q_pmc"
               END IF
               LET g_qryparam.default1 = g_qcs.qcs03
               CALL cl_create_qry() RETURNING g_qcs.qcs03
               DISPLAY BY NAME g_qcs.qcs03
               NEXT FIELD qcs03
            WHEN INFIELD(qcs13) #員工編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qcs.qcs13
               DISPLAY BY NAME g_qcs.qcs13
               NEXT FIELD qcs13
         END CASE
 
      ON ACTION qry_mrc_data
         CASE
            WHEN INFIELD(qcs01) #單號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imn2"
               LET g_qryparam.default1 = g_qcs.qcs01
               CALL cl_create_qry() RETURNING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021
               SELECT imn10 INTO g_qcs.qcs22 FROM imn_file,imm_file   #FUN-BB0085 add imm_file
                WHERE immacti = 'Y'
                  AND imm01 = imn01
                  AND imn01 = g_qcs.qcs01
                  AND imn02 = g_qcs.qcs02
               SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01 = g_qcs.qcs021   #FUN-BB0085
               LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)                      #FUN-BB0085
               DISPLAY BY NAME g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qcs.qcs22
               LET l_p = 'N'
               NEXT FIELD qcs01
         END CASE
 
      ON ACTION qry_tr_data
         CASE
            WHEN INFIELD(qcs01) #單號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inb"
               LET g_qryparam.default1 = g_qcs.qcs01
               CALL cl_create_qry() RETURNING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021
               SELECT inb16 INTO g_qcs.qcs22 FROM inb_file,ina_file
                WHERE inaconf <> 'X' #FUN-660079 inapost->inaconf
                  AND inb01 = ina01
                  AND inb01 = g_qcs.qcs01
                  AND inb03 = g_qcs.qcs02
                  AND inb04 = g_qcs.qcs021
               SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01 = g_qcs.qcs021   #FUN-BB0085
               LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)                      #FUN-BB0085
               DISPLAY BY NAME g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qcs.qcs22
               LET l_p='N'
               NEXT FIELD qcs01
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      #-----CHI-A70047---------
      ON ACTION modi_lot
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = g_qcs.qcs021
            AND imaacti = "Y"
         
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   
               IF g_argv1 <> "4" THEN
                  IF g_qcs.qcs00 NOT MATCHES '[EFG]' THEN
                     CALL t110_get_fac()
                    #CALL s_lotin(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,             #TQC-B90236 mark
                    #             g_qcs.qcs021,g_pmn07,g_img09,l_fac,
                    #             g_qcs.qcs091,'','SEL') 
                     CALL s_mod_lot(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,             #TQC-B90236 add
                                  g_qcs.qcs021,g_rvb36,g_rvb37,g_rvb38,g_pmn07,g_img09,l_fac,
                                  g_qcs.qcs091,'','SEL',1)
                        RETURNING l_r,g_qty
                  END IF
               END IF
            END IF
         END IF
      #-----END CHI-A70047----- 
 
   END INPUT
 
END FUNCTION
 
FUNCTION t110_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("qcs00,qcs01,qcs02,qcs05,qcs021,qcs03",TRUE)
      CALL cl_set_comp_entry("qcs16,qcs21,qcs17",TRUE)
      CALL cl_set_comp_entry("qcs22,qcs32,qcs35",TRUE)  #No.FUN-610075
   END IF
 
   IF INFIELD(qcs16) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("qcs03,qcs21",TRUE)
   END IF
 
   IF INFIELD(qcs02) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("qcs03",TRUE)
   END IF
 
   IF INFIELD(qcs00) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("qcs021",TRUE)
   END IF
 
   IF g_qcs.qcs09<>'1' THEN
      CALL cl_set_comp_entry("qcs22",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
   DEFINE l_qsa14 LIKE qsa_file.qsa14  #No.FUN-630051
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN       #No.FUN-570109
      IF g_qcs.qcs00 MATCHES '[1ABCDEFGH]' THEN   #MOD-970147
         CALL cl_set_comp_entry("qcs00,qcs01,qcs02,qcs05,qcs021,qcs03",FALSE)
         CALL cl_set_comp_entry("qcs16,qcs21,qcs17",FALSE)
      ELSE
         CALL cl_set_comp_entry("qcs00,qcs01,qcs02,qcs05",FALSE)
      END IF
   END IF
 
   IF g_qcs.qcs09='1' THEN
      CALL cl_set_comp_entry("qcs22",FALSE)
   END IF
 
   IF INFIELD(qcs00) OR ( NOT g_before_input_done ) THEN
      IF g_qcs.qcs00 MATCHES '[1ABCDEFGH]' THEN   #MOD-970147
         CALL cl_set_comp_entry("qcs16,qcs21,qcs17,qcs021",FALSE) #MOD-4B0140 ADD qcs021
      END IF
   END IF
 
   IF INFIELD(qcs02) OR ( NOT g_before_input_done ) THEN
      IF g_qcs.qcs00='1' THEN
         CALL cl_set_comp_entry("qcs03",FALSE)
      END IF
   END IF
 
   IF g_qcs.qcs00 = "H" THEN
      CALL cl_set_comp_entry("qcs03",FALSE)
   END IF
 
   IF g_qcs.qcs00 = 'G' THEN
      CALL cl_set_comp_entry("qcs02",FALSE)
   END IF
 
   IF g_sma.sma115 = "Y" THEN
      CALL cl_set_comp_entry("qcs22",FALSE)
   ELSE
      CALL cl_set_comp_entry("qcs32,qcs35",FALSE)
   END IF
 
   IF g_qcs.qcs00 = '7' THEN
      CALL cl_set_comp_entry("qcs021",FALSE)
   END IF
END FUNCTION
 
FUNCTION t110_qcs10()  #bugno:6831 add
 DEFINE l_pmn123   LIKE pmn_file.pmn123  #CHI-910054  
 
 #MRP轉入的請購單會有pml123資料應加入條件 
   IF (g_argv1 = '1') AND (g_qcs.qcs00 = '1') THEN
      SELECT pmn123 INTO l_pmn123
        FROM rvb_file,pmn_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
         AND rvb04 = pmn01
         AND rvb03 = pmn02
   END IF 
 
   DECLARE t110_qcs10_d CURSOR FOR SELECT UNIQUE bmj10 FROM bmj_file
                                    WHERE bmj01 = g_qcs.qcs021
                                      AND (bmj02 IS NULL OR  bmj02 = l_pmn123 OR bmj02 = ' ')   #CHI-910054 add  #MOD-980226 add bmj02=''
                                      AND bmj03 = g_qcs.qcs03
                                      AND (bmj10 IS NOT NULL AND bmj10 !=' ' )
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare t110_qcs10_d',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   #系統自動帶出(一對多時抓第一筆,至少要有一筆承認文號)
   LET g_qcs.qcs10 = ''
 
   FOREACH t110_qcs10_d INTO g_qcs.qcs10
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t110_qcs10_d',SQLCA.sqlcode,0)
         RETURN
      END IF
   END FOREACH
 
   DISPLAY BY NAME g_qcs.qcs10
 
END FUNCTION
 
FUNCTION t110_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_qcs.* TO NULL               #No.FUN-6A0160 date->l_date
   CALL cl_opmsg('q')
   CALL cl_msg("")                          #FUN-80011 
   CLEAR FORM
   CALL g_qct.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t110_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL cl_msg(" SEARCHING ! ")             #FUN-80011 
 
   OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_qcs.* TO NULL
   ELSE
      OPEN t110_count
      FETCH t110_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   CALL cl_msg("")                          #FUN-80011
 
END FUNCTION
 
FUNCTION t110_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680104 VARCHAR(1)
          l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680104 INTEGER
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     t110_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
       WHEN 'P' FETCH PREVIOUS t110_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
       WHEN 'F' FETCH FIRST    t110_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
       WHEN 'L' FETCH LAST     t110_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
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
          FETCH ABSOLUTE g_jump t110_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)
      INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_qcs.* FROM qcs_file WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02 AND qcs05 = g_qcs.qcs05  #liuxqa 091022 
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
      INITIALIZE g_qcs.* TO NULL
   ELSE
      LET g_data_owner = g_qcs.qcsuser      #FUN-4C0038
      LET g_data_group = g_qcs.qcsgrup      #FUN-4C0038
      LET g_data_plant = g_qcs.qcsplant #FUN-980030
      CALL t110_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION t110_show()
  #DEFINE m_pmn041        LIKE pmn_file.pmn041,       #No.FUN-680104 VARCHAR(30)  #CHI-CB0019 mark
   DEFINE m_ima15         LIKE type_file.chr1,        #No.FUN-680104 VARCHAR(01)  
          m_ima02         LIKE ima_file.ima02,
          m_ima021        LIKE ima_file.ima021,       #No.FUN-940103
          m_azf03         LIKE azf_file.azf03,        #No.FUN-680104 VARCHAR(30)
          m_pmh05         LIKE type_file.chr1,        #No.FUN-680104 VARCHAR(01)
          m_pmh05_desc    LIKE ze_file.ze03,          #No.TQC-610007
          m_pmc03         LIKE pmc_file.pmc03,        #No.FUN-680104 VARCHAR(10)
          m_rvb03         LIKE type_file.num5,        #No.FUN-680104 SMALLINT
          m_rvb04         LIKE rvb_file.rvb04,
          m_qcs16         LIKE qcs_file.qcs16,        #No.FUN-680104 VARCHAR(01)
          m_qcs091        LIKE qcs_file.qcs091,       #No.FUN-680104 DECIMAL(12,3)
          l_qcs22         LIKE qcs_file.qcs22
 
   LET g_qcs_t.* = g_qcs.*                #保存單頭舊值
 
   DISPLAY BY NAME g_qcs.qcsoriu,g_qcs.qcsorig,                              # 顯示單頭值
       g_qcs.qcs00,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,
       g_qcs.qcs03,g_qcs.qcs04,g_qcs.qcs041,g_qcs.qcs16,g_qcs.qcs22,
       g_qcs.qcs05,g_qcs.qcs21,g_qcs.qcs17,g_qcs.qcs091,              #No.TQC-750064 del qcs06
       g_qcs.qcs09,g_qcs.qcs13,g_qcs.qcs14,g_qcs.qcsspc,g_qcs.qcs15,  #FUN-680011
       g_qcs.qcs10,  #bugno:6831 add
       g_qcs.qcsuser,g_qcs.qcsgrup,g_qcs.qcsmodu,
       g_qcs.qcsdate,g_qcs.qcsacti,
       g_qcs.qcsud01,g_qcs.qcsud02,g_qcs.qcsud03,g_qcs.qcsud04,
       g_qcs.qcsud05,g_qcs.qcsud06,g_qcs.qcsud07,g_qcs.qcsud08,
       g_qcs.qcsud09,g_qcs.qcsud10,g_qcs.qcsud11,g_qcs.qcsud12,
       g_qcs.qcsud13,g_qcs.qcsud14,g_qcs.qcsud15 
 
   CALL t110_get_ecm04()  #MOD-890102
 
   IF g_qcs.qcs00 MATCHES '[56]' THEN
      SELECT occ02 INTO m_pmc03 FROM occ_file
       WHERE occ01 = g_qcs.qcs03
   ELSE
   SELECT pmc03 INTO m_pmc03 FROM pmc_file WHERE pmc01=g_qcs.qcs03
   END IF  #MOD-890098 add
 
   IF STATUS=100 THEN LET m_pmc03=' ' END IF
 
   DISPLAY m_pmc03 TO FORMONLY.pmc03
 
   DISPLAY BY NAME g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32
   DISPLAY BY NAME g_qcs.qcs33,g_qcs.qcs34,g_qcs.qcs35
 
   DISPLAY BY NAME g_qcs.qcs36,g_qcs.qcs37,g_qcs.qcs38   #CHI-6A0037 add
   DISPLAY BY NAME g_qcs.qcs39,g_qcs.qcs40,g_qcs.qcs41   #CHI-6A0037 add
 
   SELECT ima02,ima021,ima109,ima15,ima906,ima101   #No.FUN-620043    #No.FUN-A80063   #No.FUN-940103 add ima021
     INTO m_ima02,m_ima021,m_ima109,m_ima15,g_ima906,g_ima101   #No.FUN-620043   #No.FUN-A80063 #No.FUN-940103
     FROM ima_file
    WHERE ima01=g_qcs.qcs021
 
   IF STATUS = 100 THEN
      LET m_ima02 = ' '
      LET m_ima021 = ' '     #No.FUN-940103
      LET m_ima109 = ' '
      LET m_ima15 = ' '
   END IF
 
   DISPLAY m_ima02 TO FORMONLY.ima02     #CHI-CB0019 mod pmn041->ima02
   DISPLAY m_ima021 TO FORMONLY.ima021   #No.FUN-940103
   DISPLAY m_ima109 TO FORMONLY.ima109
   DISPLAY m_ima15 TO FORMONLY.ima15
   DISPLAY g_ima101 TO ima101   #No.FUN-A80063
   
   SELECT azf03 INTO m_azf03 FROM azf_file
    WHERE azf01 = m_ima109
      AND azf02 = '8'
 
   IF STATUS THEN
      LET m_azf03=' '
   END IF
 
   DISPLAY m_azf03 TO FORMONLY.azf03
 
   DECLARE pmh_cur4 CURSOR FOR SELECT pmh05 FROM pmh_file
                                WHERE pmh01 = g_qcs.qcs021
                                  AND pmh02 = g_qcs.qcs03
                                  AND pmh21 = g_ecm04                        #CHI-860042   #MOD-890102 modify ' '->g_ecm04
                                  AND pmh22 = g_type                         #CHI-860042   #MOD-890102 modify '1'->g_type
                                  AND pmh23 = ' '                            #No.CHI-960033
                                 # AND pmhacti = 'Y'                         #CHI-910021   #No.CHI-A10021 mark
 
   OPEN pmh_cur4
   FETCH pmh_cur4 INTO m_pmh05
 
   IF STATUS=100 THEN
      LET m_pmh05 = ' '
   END IF
 
   CASE m_pmh05
      WHEN '0'
         CALL cl_getmsg('aqc-010',g_lang) RETURNING m_pmh05_desc
      WHEN '1'
         CALL cl_getmsg('aqc-011',g_lang) RETURNING m_pmh05_desc
      WHEN '2'
         CALL cl_getmsg('aqc-012',g_lang) RETURNING m_pmh05_desc
   END CASE
 
   DISPLAY m_pmh05_desc TO FORMONLY.pmh05    #---- 核准狀態
 
   CASE g_qcs.qcs09
      WHEN '1'
         CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
      WHEN '2'
         CALL cl_getmsg('apm-244',g_lang) RETURNING des1 #No:7706 驗退
      WHEN '3'
         CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE
 
   DISPLAY des1 TO FORMONLY.des1
 
   CASE g_qcs.qcs21
      WHEN 'N'
         CALL cl_getmsg('aqc-001',g_lang) RETURNING qcs21_desc
      WHEN 'T'
         CALL cl_getmsg('aqc-002',g_lang) RETURNING qcs21_desc
      WHEN 'R'
         CALL cl_getmsg('aqc-003',g_lang) RETURNING qcs21_desc
   END CASE
 
   DISPLAY qcs21_desc TO FORMONLY.qcs21_desc
 
   #----------CHI-BC0018 str add-----------------
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang

      WHEN '3'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang

      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc


   CASE g_qcs.qcs17
      WHEN '1'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcs17_desc= ' '
   END CASE
   DISPLAY qcs17_desc TO FORMONLY.qcs17_desc
   #----------CHI-BC0018 end add-----------------
 
   SELECT gen02 INTO m_gen02 FROM gen_file
    WHERE gen01 = g_qcs.qcs13
 
   IF SQLCA.sqlcode THEN #FUN-5C0114
      LET m_gen02='' #FUN-5C0114
   END IF
 
   DISPLAY m_gen02 TO FORMONLY.gen02
 
   IF g_qcs.qcs14 = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
 
   CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
   CALL t110_qcs02_1()
   CALL t110_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t110_qcs02_1()
   DEFINE l_pmniicd15      LIKE pmni_file.pmniicd15                                                                               
   DEFINE l_rvbiicd14      LIKE rvbi_file.rvbiicd14                                                                               
   DEFINE l_rvb38          LIKE rvb_file.rvb38                                                                                    
   DEFINE l_pmniicd11      LIKE pmni_file.pmniicd11                                                                               
   DEFINE l_pmniicd15_desc LIKE ima_file.ima021                                                                                   
   DEFINE l_sfbiicd12      LIKE sfbi_file.sfbiicd12                                                                               
   DEFINE l_rvb04          LIKE rvb_file.rvb04
   SELECT rvb04,rvb38 INTO l_rvb04,l_rvb38 FROM rvb_file                                                                        
    WHERE rvb01 = g_qcs.qcs01                                                                                                       
     AND  rvb02 = g_qcs.qcs02                                                                                                       
   SELECT sfbiicd08,sfbiicd07,sfbiicd12                                                                                             
     INTO l_pmniicd15,l_pmniicd11,l_sfbiicd12                                                                        
    FROM sfbi_file                                                                                                                  
    WHERE sfbi01 = l_rvb04                                                                                                          
                                                                                                                                    
   DISPLAY l_pmniicd15 TO FORMONLY.pmniicd15                                                                                                
   DISPLAY l_pmniicd11 TO FORMONLY.pmniicd11                                                                                                
   DISPLAY l_sfbiicd12 TO FORMONLY.sfbiicd12                                                                                                
   DISPLAY l_rvb38     TO FORMONLY.rvb38                                                                                                   
   SELECT rvbiicd14 INTO l_rvbiicd14 FROM rvbi_file                                                                                 
    WHERE rvbi01 = g_qcs.qcs01                                                                                                      
     AND  rvbi02 = g_qcs.qcs02                                                                                                      
   DISPLAY l_rvbiicd14  TO FORMONLY.rvbiicd14                                                                                                    
   SELECT ima021 INTO l_pmniicd15_desc                                                                                         
    FROM ima_file                                                                                                                   
    WHERE ima01=l_pmniicd15  
   DISPLAY l_pmniicd15_desc TO FORMONLY.pmniicd15_desc  
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t110_r()
   DEFINE l_cnt   LIKE type_file.num10  #FUN-BC0104
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_qcs.qcs01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcsacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qcs.qcs01,9027,0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'Y' THEN  #No.FUN-5C0077
      CALL cl_err('','9023',0)
      RETURN
   END IF

#FUN-BC0104 --------------Begin-----------------
   SELECT count(*) INTO l_cnt FROM qco_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
   IF cl_null(l_cnt) THEN
      LET l_cnt = 0
   END IF 
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('aqc-056') THEN   
         RETURN
      END IF
   END IF
#FUN-BC0104 --------------End-------------------
 
   BEGIN WORK
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t110_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "qcs01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "qcs02"         #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "qcs05"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_qcs.qcs01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_qcs.qcs02      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_qcs.qcs05      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND qcs05 = g_qcs.qcs05
 
#FUN-BC0104 -------------Begin---------------
      DELETE FROM qco_file
       WHERE qco01 = g_qcs.qcs01
         AND qco02 = g_qcs.qcs02
         AND qco05 = g_qcs.qcs05
#FUN-BC0104 -------------End-----------------

      DELETE FROM qct_file
       WHERE qct01 = g_qcs.qcs01
         AND qct02 = g_qcs.qcs02
         AND qct021 = g_qcs.qcs05
 
      DELETE FROM qcu_file
       WHERE qcu01 = g_qcs.qcs01
         AND qcu02 = g_qcs.qcs02
         AND qcu021 = g_qcs.qcs05
 
      DELETE FROM qctt_file
       WHERE qctt01 = g_qcs.qcs01
         AND qctt02 = g_qcs.qcs02
         AND qctt021 = g_qcs.qcs05
 
       DELETE FROM qao_file 
        WHERE qao01 = g_qcs.qcs01
          AND qao02 = g_qcs.qcs02         
          AND qao021= g_qcs.qcs05       
 
      IF g_qcs.qcs00='7' THEN
         UPDATE srg_file SET srg12=NULL WHERE srg01=g_qcs.qcs01
                                          AND srg02=g_qcs.qcs02
      END IF
 
  
      DELETE FROM qcv_file 
        WHERE qcv01 = g_qcs.qcs01
          AND qcv02 = g_qcs.qcs02
          AND qcv21 = g_qcs.qcs05
#No.TQC-B90236----------------add begin-------------------------------------------------
#No.TQC-B90236----------------mark--------begin----------------------------------------- 
#     IF NOT s_del_rvbs("2",g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05)  THEN        #FUN-880129 
#       ROLLBACK WORK
#       RETURN
#     END IF
#No.TQC-B90236----------------mark--------end-------------------------------------------
       IF NOT s_lot_del(g_prog,g_qcs.qcs01,'',g_qcs.qcs05,g_qcs.qcs021,'DEL') THEN        #FUN-880129
         ROLLBACK WORK
         RETURN
       END IF
#No.TQC-B90236----------------add end--------------------------------------------------- 
      #功能: 通知 SPC 端刪除此張單據
      # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(
      #           (3)功能選項：insert(新增),update(修改),delete(刪除)
      # 回傳值  : 0 傳送失敗; 1 傳送成功
      IF g_qcs.qcsspc = '1' THEN
         IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcs),'delete')
         THEN
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN
         END IF
 
         #更改前端單據SPC拋轉碼
         CALL t110_updspc()
 
      END IF
      #END FUN-680011  
 
      INITIALIZE g_qcs.* TO NULL
      CLEAR FORM
      CALL g_qct.clear()
 
      OPEN t110_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t110_cs
         CLOSE t110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t110_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t110_cs
         CLOSE t110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN t110_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t110_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t110_fetch('/')
      END IF
 
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t110_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
       l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE type_file.num5,         #No.FUN-680104 SMALLINT #檢查重複用
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680104 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680104 VARCHAR(1)
       l_char          LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
       l_qcd05         LIKE qcd_file.qcd05,
       l_qcd07         LIKE qcd_file.qcd07,
      #將l_qct07改宣告為整數形態，因為當缺點數乘上權數後
      #是以無條件捨去，取整數來作比較
       l_qct07         LIKE qct_file.qct07,   #No.CHI-740037 add
      #l_chkqty        LIKE type_file.num5,    #MOD-D30018 mark
       l_chkqty        LIKE type_file.num15_3, #MOD-D30018 add
       l_qcd061        LIKE qcd_file.qcd061,
       l_qcd062        LIKE qcd_file.qcd062,
       l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
DEFINE l_length        LIKE type_file.num5                 #TQC-7C0088 add
DEFINE l_sql           STRING       #No.FUN-910079 
DEFINE l_ima926        LIKE ima_file.ima926                #FUN-930108 add 
DEFINE l_qcs09         LIKE qcs_file.qcs09                 #CHI-C70004 add
#No.FUN-A80130 --begin
DEFINE l_avg           LIKE qctt_file.qctt04
DEFINE l_qctt04        LIKE qctt_file.qctt04
DEFINE l_sum           LIKE qctt_file.qctt04
DEFINE l_stddev        LIKE qctt_file.qctt04
DEFINE l_k_max         LIKE qctt_file.qctt04
DEFINE l_k_min         LIKE qctt_file.qctt04
DEFINE l_f             LIKE qctt_file.qctt04
DEFINE l_qcd           RECORD LIKE qcd_file.*
DEFINE l_qcd03         LIKE qcd_file.qcd03
DEFINE l_qcd04         LIKE qcd_file.qcd04
DEFINE l_count         LIKE type_file.num5     #FUN-BC0104
#No.FUN-A80130 --end 
   LET g_action_choice = ""

   LET g_flag = 'N'   #FUN-C30149 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_qcs.qcs01) THEN
      RETURN
   END IF

#若單據已存在QC料件維護資料(qco_file)，則不可更改單身(qct_file)
#FUN-BC0104 --------------Begin--------------
   LET l_count=0
   SELECT COUNT(*) INTO l_count FROM qco_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
   IF cl_null(l_count) THEN LET l_count = 0 END IF
   IF l_count > 0 THEN
      CALL cl_err(g_qcs.qcs01,'aqc-402',0)
      RETURN
   END IF
#FUN-BC0104 --------------End----------------
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   CALL t110_qcs10() #bugno:6831 add
 
   UPDATE qcs_file SET * = g_qcs.*
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qcs.qcs01,'aom-000',0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'Y' THEN   #No.FUN-5C0077
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
      "SELECT qct03,qct04,'',qct05,qct06,qct09,qct10,qct14,qct15,qct11,qct07,qct08,'', ",  #No.FUN-A80063
      "       qctud01,qctud02,qctud03,qctud04,qctud05,",
      "       qctud06,qctud07,qctud08,qctud09,qctud10,",
      "       qctud11,qctud12,qctud13,qctud14,qctud15", 
      "  FROM qct_file ",
      " WHERE qct01= ? AND qct02= ? AND qct021= ? AND qct03= ?  FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE    #MOD-480160
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_qct WITHOUT DEFAULTS FROM s_qct.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
         OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
         IF STATUS THEN
            CALL cl_err("OPEN t110_cl:", STATUS, 1)
            CLOSE t110_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH t110_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t110_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_qct_t.* = g_qct[l_ac].*  #BACKUP
            OPEN t110_bcl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,
                                g_qct_t.qct03
            IF STATUS THEN
               CALL cl_err("OPEN t110_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t110_bcl INTO g_qct[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_qct_t.qct03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT azf03 INTO g_qct[l_ac].azf03_1 FROM azf_file
                   WHERE azf01 = g_qct[l_ac].qct04
                     AND azf02 = '6'
                  CASE g_qct[l_ac].qct08
                     WHEN '1'
                        CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qct[l_ac].qct08_desc
                     WHEN '2'
                        CALL cl_getmsg('apm-244',g_lang) RETURNING g_qct[l_ac].qct08_desc #No:7706 #驗退
                  END CASE
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_qct[l_ac].* TO NULL      #900423
         LET g_qct_t.* = g_qct[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD qct03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            EXIT INPUT
         END IF
         IF g_qct[l_ac].qct07 = 0 THEN
            DELETE FROM qcu_file
             WHERE qcu01 = g_qcs.qcs01
               AND qcu02 = g_qcs.qcs02
               AND qcu021 = g_qcs.qcs05
               AND qcu03 = g_qct[l_ac].qct03
         END IF
         #No.TQC-BB0119  --Begin
         CALL t110_get_qcd07(g_qct[l_ac].qct04) RETURNING l_qcd07,l_qcd05,l_qcd061,l_qcd062
         #    LET l_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
         #                "  FROM qcc_file,ecm_file,rvb_file,pmn_file ",
         #                "  WHERE rvb01= ? AND rvb02= ?",
         #                "  AND rvb04=pmn01 AND rvb03=pmn02  ",
         #                "  AND pmn41=ecm01 AND pmn46=ecm03 ",
         #                "  AND qcc01= ? AND qcc011=ecm04 ",
         #                "  AND qcc02= ?",
         #                " AND ecm012=pmn012 "               #FUN-A60076 add
         #    IF  g_argv1 = "1" THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('1','9')" 
         #    END IF     
         #    IF  g_argv1 = "2" THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('5','9')"
         #    END IF      
         #    IF  g_argv1 = "3" THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('4','9')"
         #    END IF     
         #    IF  g_argv1 = "4" THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('2','9')"
         #     END IF   
         #     PREPARE qcc_sel1 FROM l_sql  
         #     EXECUTE qcc_sel1 USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qct[l_ac].qct04
         #       INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                                                    
         #   IF STATUS=100 THEN           
         #      EXECUTE qcc_sel1 USING g_qcs.qcs01,g_qcs.qcs02,'*',g_qct[l_ac].qct04
         #        INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07
         #      IF STATUS=100 THEN
         #      LET l_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
         #                  " FROM qcd_file ",
         #                  " WHERE qcd01=? AND qcd02=? "
         #        IF  g_argv1 = "1" THEN 
         #            LET l_sql = l_sql CLIPPED," AND qcd08 in ('1','9')" 
         #        END IF          
         #        IF  g_argv1 = "2" THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qcd08 in ('5','9')" 
         #        END IF 
         #        IF  g_argv1 = "3" THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qcd08 in ('4','9')"
         #        END IF 
         #        IF  g_argv1 = "4" THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qcd08 in ('2','9')"
         #        END IF          
         #      PREPARE qcd_sel1 FROM l_sql  
         #       EXECUTE qcd_sel1 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #          INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
         #      IF STATUS=100 THEN
         #      LET l_sql = " SELECT qck05,qck061,qck062,qck07  ",
         #                  "   FROM qck_file,ima_file ",
         #                  "   WHERE ima01=? AND qck01=ima109 ",
         #                  "   AND qck02 = ?"
         #                   
         #          IF  g_argv1 = "1"  THEN 
         #              LET l_sql = l_sql CLIPPED," AND qck08 in ('1','9')" 
         #          END IF        
         #          IF  g_argv1 = "2"   THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qck08 in ('5','9')" 
         #          END IF 
         #          IF  g_argv1 = "3"  THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qck08 in ('4','9')"
         #          END IF 
         #          IF  g_argv1 = "4"  THEN 
         #                 LET l_sql = l_sql CLIPPED," AND qck08 in ('2','9')"
         #          END IF   
         #       PREPARE qck_sel1 FROM l_sql  
         #       EXECUTE qck_sel1 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #          INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
         #         IF STATUS=100 THEN
         #            LET l_qcd07 = 'N'
         #            LET l_qcd05 = ''
         #            LET l_qcd061 = ''
         #            LET l_qcd062 = ''
         #         END IF
         #      END IF
         #    END IF                     #No.FUN-990071
         #   END IF
         #No.TQC-BB0119  --End
 
         INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,  #No.MOD-470041
                               qct06,qct07,qct08,qct09,qct10,qct11,
                               qct12,qct131,qct132,
                               qctud01,qctud02,qctud03,qctud04,qctud05,qctud06,
                               qctud07,qctud08,qctud09,qctud10,qctud11,qctud12,
                               qctud13,qctud14,qctud15,
                               qctplant,qctlegal)   #FUN-980007
            VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qct[l_ac].qct03,
                   g_qct[l_ac].qct04,g_qct[l_ac].qct05,g_qct[l_ac].qct06,
                   g_qct[l_ac].qct07,g_qct[l_ac].qct08,g_qct[l_ac].qct09,
                   g_qct[l_ac].qct10,g_qct[l_ac].qct11,l_qcd05,l_qcd061,
                   l_qcd062,
                   g_qct[l_ac].qctud01,g_qct[l_ac].qctud02,
                   g_qct[l_ac].qctud03,g_qct[l_ac].qctud04,
                   g_qct[l_ac].qctud05,g_qct[l_ac].qctud06,
                   g_qct[l_ac].qctud07,g_qct[l_ac].qctud08,
                   g_qct[l_ac].qctud09,g_qct[l_ac].qctud10,
                   g_qct[l_ac].qctud11,g_qct[l_ac].qctud12,
                   g_qct[l_ac].qctud13,g_qct[l_ac].qctud14,
                   g_qct[l_ac].qctud15,
                   g_plant,g_legal)                #FUN-980007
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","qct_file",g_qcs.qcs01,g_qct[l_ac].qct03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD qct03                        #default 序號
         IF g_qct[l_ac].qct03 IS NULL OR
            g_qct[l_ac].qct03 = 0 THEN
            SELECT MAX(qct03)+1 INTO g_qct[l_ac].qct03
              FROM qct_file
             WHERE qct01 = g_qcs.qcs01
               AND qct02 = g_qcs.qcs02
               AND qct021= g_qcs.qcs05
            IF g_qct[l_ac].qct03 IS NULL THEN
               LET g_qct[l_ac].qct03 = 1
            END IF
         END IF
 
      AFTER FIELD qct11
         IF g_qct[l_ac].qct11 IS NULL THEN
            LET g_qct[l_ac].qct11=0
         END IF
         IF g_qct[l_ac].qct11<=0 THEN
            NEXT FIELD qct11
         END IF
         #No.TQC-BB0119  --Begin
         CALL t110_get_qcd07(g_qct[l_ac].qct04) RETURNING l_qcd07,l_qcd05,l_qcd061,l_qcd062
         #    LET l_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
         #               #"  INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07 ",    #No.MOD-940209 mark
         #                "  FROM qcc_file,ecm_file,rvb_file,pmn_file ",
         #                "  WHERE rvb01= ? AND rvb02= ?",
         #                "  AND rvb04=pmn01 AND rvb03=pmn02  ",
         #                "  AND pmn41=ecm01 AND pmn46=ecm03 ",
         #                "  AND qcc01= ? AND qcc011=ecm04 ",
         #                "  AND qcc02= ?",
         #                "  AND ecm012=pmn012 "                     #FUN-A60076 add     
         #    IF  g_argv1 = "1"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('1','9')"
         #    END IF     
         #    IF  g_argv1 = "2"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('5','9')" 
         #    END IF     
         #    IF  g_argv1 = "3"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('4','9')"
         #    END IF     
         #    IF  g_argv1 = "4"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcc08 in ('2','9')"
         #    END IF 
         #     PREPARE qcc_sel2 FROM l_sql  
         #     EXECUTE qcc_sel2 USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qct[l_ac].qct04
         #       INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                                          
         #   IF STATUS=100 THEN
         #      EXECUTE qcc_sel2 USING g_qcs.qcs01,g_qcs.qcs02,'*',g_qct[l_ac].qct04
         #        INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07
         #      IF STATUS=100 THEN
         #      LET l_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
         #                  " FROM qcd_file ",
         #                  " WHERE qcd01=? AND qcd02=? "
         #        IF  g_argv1 = "1"  THEN 
         #            LET l_sql = l_sql CLIPPED," AND qcd08 in ('1','9')"
         #        END IF           
         #        IF  g_argv1 = "2"  THEN 
         #            LET l_sql = l_sql CLIPPED," AND qcd08 in ('5','9')" 
         #        END IF     
         #        IF  g_argv1 = "3"  THEN 
         #            LET l_sql = l_sql CLIPPED," AND qcd08 in ('4','9')"
         #        END IF     
         #        IF  g_argv1 = "4"  THEN 
         #            LET l_sql = l_sql CLIPPED," AND qcd08 in ('2','9')"
         #        END IF
         #      PREPARE qcd_sel2 FROM l_sql  
         #      EXECUTE qcd_sel2 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #          INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
         #      IF STATUS=100 THEN
         #      LET l_sql = " SELECT qck05,qck061,qck062,qck07  ",
         #                  "   FROM qck_file,ima_file ",
         #                  "   WHERE ima01=? AND qck01=ima109 ",
         #                  "   AND qck02 = ?"
         #                   
         #           IF  g_argv1 = "1"   THEN 
         #               LET l_sql = l_sql CLIPPED," AND qck08 in ('1','9')" 
         #           END IF       
         #           IF  g_argv1 = "2"  THEN 
         #               LET l_sql = l_sql CLIPPED," AND qck08 in ('5','9')"
         #           END IF      
         #           IF  g_argv1 = "3"  THEN 
         #               LET l_sql = l_sql CLIPPED," AND qck08 in ('4','9')"
         #           END IF     
         #           IF  g_argv1 = "4"  THEN 
         #               LET l_sql = l_sql CLIPPED," AND qck08 in ('2','9')"
         #           END IF    
         #       PREPARE qck_sel2 FROM l_sql  
         #       EXECUTE qck_sel2 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #          INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
         #         IF STATUS=100 THEN
         #            LET l_qcd07='N'
         #         END IF
         #      END IF
         #     END IF                #No.FUN-990071 
         #   END IF
         #No.TQC-BB0119  --End
 
         IF g_qct[l_ac].qct11>0 AND l_qcd07='Y'AND g_qcz.qcz01='Y' THEN
            CALL t110_more_b1(g_qct[l_ac].qct11,l_qcd05,l_qcd061,l_qcd062,
                              g_qct[l_ac].qct03,g_qct[l_ac].qct04)
            DISPLAY BY NAME g_qct[l_ac].qct07 #MOD-530471
            SELECT COUNT(*) INTO g_cnt FROM qctt_file
             WHERE qctt01 = g_qcs.qcs01
               AND qctt02 = g_qcs.qcs02
               AND qctt021 = g_qcs.qcs05
               AND qctt03 = g_qct[l_ac].qct03
           #CHI-C70004 str add-----
            SELECT qcs09 INTO l_qcs09 FROM qcs_file
             WHERE qcs01 = g_qcs.qcs01
               AND qcs02 = g_qcs.qcs02
               AND qcs05 = g_qcs.qcs05
           #CHI-C70004 end add-----
            IF g_cnt != g_qct[l_ac].qct11 AND l_qcs09 != 2  THEN   #CHI-C70004 add AND l_qcs09 != 2
               LET g_msg = g_cnt,': ',g_qct[l_ac].qct11
               CALL cl_err(g_msg,'aqc-038',0)
               NEXT FIELD qct11
            END IF
            IF g_qct[l_ac].qct07 IS NULL THEN
               LET g_qct[l_ac].qct07 = 0
            END IF
            IF g_qct[l_ac].qct07 > 0 THEN
               NEXT FIELD qct07
            END IF
         END IF
         IF g_qct[l_ac].qct07 IS NULL THEN
            LET g_qct[l_ac].qct07 = 0
         END IF
        #MOD-CB0153---add---S
         IF g_qct[l_ac].qct11 > g_qcs.qcs22 THEN
            CALL cl_err(g_qct[l_ac].qct11,'aqc-888',1)
            NEXT FIELD qct11
         END IF
        #MOD-CB0153---add---E
 
      AFTER FIELD qct07
        #缺點數與檢驗量是兩個獨立不互相影響的數值
        #故不因做下面判斷 
         IF g_qct[l_ac].qct07>0 THEN
             CALL t110_more_b(g_qct[l_ac].qct07)           #TQC-970126
         END IF
         #---- 項目判定
         #No.TQC-BB0119  --Begin
         CALL t110_get_qcd07(g_qct[l_ac].qct04) RETURNING l_qcd.qcd07,l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062

         ##No.FUN-A80063 --begin
         #LET l_sql = " SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062,qcc07, ",
         #            "        qccacti,qccuser,qccgrup,qccmodu,qccdate,qcc08,qccorig,qccoriu ",
         #            "  FROM qcc_file,ecm_file,rvb_file,pmn_file ",
         #            "  WHERE rvb01= ? AND rvb02= ?",
         #            "  AND rvb04=pmn01 AND rvb03=pmn02  ",
         #            "  AND pmn41=ecm01 AND pmn46=ecm03 ",
         #            "  AND qcc01= ? AND qcc011=ecm04 ",
         #            "  AND qcc02= ?",
         #            "  AND ecm012=pmn012 "                     #FUN-A60076 add     
         #IF  g_argv1 = "1"  THEN 
         #    LET l_sql = l_sql CLIPPED," AND qcc08 in ('1','9')"
         #END IF     
         #IF  g_argv1 = "2"  THEN 
         #    LET l_sql = l_sql CLIPPED," AND qcc08 in ('5','9')" 
         #END IF     
         #IF  g_argv1 = "3"  THEN 
         #    LET l_sql = l_sql CLIPPED," AND qcc08 in ('4','9')"
         #END IF     
         #IF  g_argv1 = "4"  THEN 
         #    LET l_sql = l_sql CLIPPED," AND qcc08 in ('2','9')"
         #END IF 
         #PREPARE qcc_sel13 FROM l_sql  
         #EXECUTE qcc_sel13 USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qct[l_ac].qct04
         #   INTO  l_qcd.*                                       
         #IF STATUS=100 THEN
         #  EXECUTE qcc_sel13 USING g_qcs.qcs01,g_qcs.qcs02,'*',g_qct[l_ac].qct04
         #    INTO  l_qcd.* 
         #  IF STATUS=100 THEN
         #    LET l_sql = " SELECT * ",
         #                " FROM qcd_file ",
         #                " WHERE qcd01=? AND qcd02=? "
         #    IF  g_argv1 = "1"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcd08 in ('1','9')"
         #    END IF           
         #    IF  g_argv1 = "2"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcd08 in ('5','9')" 
         #    END IF     
         #    IF  g_argv1 = "3"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcd08 in ('4','9')"
         #    END IF     
         #    IF  g_argv1 = "4"  THEN 
         #        LET l_sql = l_sql CLIPPED," AND qcd08 in ('2','9')"
         #    END IF
         #    PREPARE qcd_sel13 FROM l_sql  
         #    EXECUTE qcd_sel13 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #        INTO  l_qcd.*                
         #    IF STATUS=100 THEN
         #       LET l_sql = " SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062, ",
         #                   "        qccacti,qccuser,qccgrup,qccmodu,qccdate ",
         #                   "   FROM qck_file,ima_file ",
         #                   "   WHERE ima01=? AND qck01=ima109 ",
         #                   "   AND qck02 = ?"
         #               
         #       IF  g_argv1 = "1"   THEN 
         #           LET l_sql = l_sql CLIPPED," AND qck08 in ('1','9')" 
         #       END IF       
         #       IF  g_argv1 = "2"  THEN 
         #           LET l_sql = l_sql CLIPPED," AND qck08 in ('5','9')"
         #       END IF      
         #       IF  g_argv1 = "3"  THEN 
         #           LET l_sql = l_sql CLIPPED," AND qck08 in ('4','9')"
         #       END IF     
         #       IF  g_argv1 = "4"  THEN 
         #           LET l_sql = l_sql CLIPPED," AND qck08 in ('2','9')"
         #       END IF    
         #       PREPARE qck_sel13 FROM l_sql  
         #       EXECUTE qck_sel13 USING g_qcs.qcs021,g_qct[l_ac].qct04
         #       INTO  l_qcd.*                
         #       IF STATUS=100 THEN
         #          LET l_qcd07='N'
         #       END IF
         #    END IF 
         #  END IF
         #END IF  
         #No.TQC-BB0119  --End
         IF l_qcd.qcd05 ='4' THEN 
            SELECT SUM(qctt04) INTO l_qctt04
              FROM qctt_file
             WHERE qctt01 = g_qcs.qcs01
               AND qctt02 = g_qcs.qcs02
               AND qctt021= g_qcs.qcs05
               AND qctt03 = g_qct[l_ac].qct03
            IF cl_null(l_qctt04) THEN 
               LET l_qctt04 = 0
            END IF  
            LET l_avg = l_qctt04 / g_qct[l_ac].qct11
            
            LET l_sum = 0 
            DECLARE qctt_sel CURSOR FOR 
              SELECT qctt04 FROM qctt_file
               WHERE qctt01 = g_qcs.qcs01
                 AND qctt02 = g_qcs.qcs02
                 AND qctt021= g_qcs.qcs05
                 AND qctt03 = g_qct[l_ac].qct03
            FOREACH qctt_sel INTO l_qctt04
              LET l_sum = l_sum + ((l_qctt04 - l_avg)*(l_qctt04 - l_avg))
            END FOREACH 
            LET l_stddev = s_power(l_sum/(g_qct[l_ac].qct11 -1),2)
            LET l_k_max  = (l_qcd.qcd062 - l_avg)/l_stddev
            LET l_k_min  = (l_avg - l_qcd.qcd061)/l_stddev
            LET l_f      = l_stddev/(l_qcd.qcd062 - l_qcd.qcd061)
            IF cl_null(l_qcd.qcd061) OR cl_null(l_qcd.qcd061) THEN 
               IF cl_null(l_qcd.qcd061) THEN 
                  IF l_k_max >= g_qct[l_ac].qct14 THEN 
                     LET g_qct[l_ac].qct08 ='1'
                  ELSE
                  	 LET g_qct[l_ac].qct08 ='2'
                  END IF  
               ELSE 
                  IF l_k_min >= g_qct[l_ac].qct14 THEN 
                     LET g_qct[l_ac].qct08 ='1'
                  ELSE
                  	 LET g_qct[l_ac].qct08 ='2'
                  END IF 
               END IF 
            ELSE 
            	 IF l_k_min >= g_qct[l_ac].qct14 AND l_k_max >= g_qct[l_ac].qct14 AND l_f >= g_qct[l_ac].qct15 THEN 
                  LET g_qct[l_ac].qct08 ='1'
               ELSE 
               	  LET g_qct[l_ac].qct08 ='2'
               END IF 
            END IF 
         ELSE 
#No.FUN-A80063 --end 
            #在判定合格或退貨時，應先將缺點數乘上CR/MA/MI權數
             CASE g_qct[l_ac].qct05
                 WHEN "1"
                       LET l_chkqty = g_qct[l_ac].qct07*g_qcz.qcz02/g_qcz.qcz021  #No.TQC-750209 modify
                 WHEN "2"
                       LET l_chkqty = g_qct[l_ac].qct07*g_qcz.qcz03/g_qcz.qcz031  #No.TQC-750209 modify 
                 WHEN "3" 
                       LET l_chkqty = g_qct[l_ac].qct07*g_qcz.qcz04/g_qcz.qcz041  #No.TQC-750209 modify 
                 OTHERWISE
                       LET l_chkqty = g_qct[l_ac].qct07                           #No.TQC-750209 modify
             END CASE
            #MOD-D30018 add start -----
             IF l_chkqty = 0 THEN
                LET g_qct[l_ac].qct08='1'
             ELSE
            #MOD-D30018 add end   -----
                IF l_chkqty>=g_qct[l_ac].qct10 THEN           #No.TQC-750209 modify
                   LET g_qct[l_ac].qct08='2'
                ELSE
                   LET g_qct[l_ac].qct08='1'
                END IF
             END IF #MOD-D30018 add
         END IF        #No.FUN-A80063 
         CASE g_qct[l_ac].qct08
            WHEN '1'
               CALL cl_getmsg('aqc-004',g_lang)
                     RETURNING g_qct[l_ac].qct08_desc
            WHEN '2'
               CALL cl_getmsg('apm-244',g_lang) #No:7706 驗退
                     RETURNING g_qct[l_ac].qct08_desc
         END CASE
 
        AFTER FIELD qctud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qctud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_qct_t.qct03 > 0 AND g_qct_t.qct03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            LET g_success = 'Y'   #MOD-A40035 add
            DELETE FROM qct_file
             WHERE qct01 = g_qcs.qcs01
               AND qct02 = g_qcs.qcs02
               AND qct021= g_qcs.qcs05
               AND qct03 = g_qct_t.qct03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","qct_file",g_qcs.qcs01,g_qct_t.qct03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               LET g_success = 'N'   #MOD-A40035 add
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               DELETE FROM qcu_file
                WHERE qcu01 = g_qcs.qcs01
                  AND qcu02 = g_qcs.qcs02
                  AND qcu021= g_qcs.qcs05
                  AND qcu03 = g_qct_t.qct03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","qcu_file",g_qcs.qcs01,g_qct_t.qct03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_success = 'N'   #MOD-A40035 add
                  ROLLBACK WORK
                  CANCEL DELETE
              #str MOD-A40035 mark
              #ELSE
              #   LET g_rec_b=g_rec_b-1
              #   DISPLAY g_rec_b TO FORMONLY.cn2
              #   COMMIT WORK
              #end MOD-A40035 mark
               END IF
              #str MOD-A40035 add
               DELETE FROM qctt_file
                WHERE qctt01 = g_qcs.qcs01
                  AND qctt02 = g_qcs.qcs02
                  AND qctt021= g_qcs.qcs05
                  AND qctt03 = g_qct_t.qct03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","qctt_file",g_qcs.qcs01,g_qct_t.qct03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_success = 'N'
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
              #end MOD-A40035 add
            END IF
           #str MOD-A40035 add
            IF g_success = 'Y' THEN
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
           #end MOD-A40035 add
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qct[l_ac].* = g_qct_t.*
            CLOSE t110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_qct[l_ac].qct03,-263,1)
            LET g_qct[l_ac].* = g_qct_t.*
         ELSE
            IF g_qct[l_ac].qct07=0 THEN
               DELETE FROM qcu_file
                WHERE qcu01=g_qcs.qcs01
                  AND qcu02=g_qcs.qcs02
                  AND qcu021=g_qcs.qcs05
                  AND qcu03=g_qct[l_ac].qct03
            END IF
 
            #No.TQC-BB0119  --Begin
            CALL t110_get_qcd07(g_qct[l_ac].qct04) RETURNING l_qcd07,l_qcd05,l_qcd061,l_qcd062
            # LET l_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
            #            #"  INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07 ",  #No.MOD-940209 mark
            #             "  FROM qcc_file,ecm_file,rvb_file,pmn_file ",
            #             "  WHERE rvb01= ? AND rvb02=? ",
            #             "  AND rvb04=pmn01 AND rvb03=pmn02  ",
            #             "  AND pmn41=ecm01 AND pmn46=ecm03 ",
            #             "  AND qcc01= ? AND qcc011=ecm04 ",
            #             "  AND qcc02= ?",
            #             " AND ecm012=pmn012 "              #FUN-A60076 add    
            # IF  g_argv1 = "1"  THEN 
            #     LET l_sql = l_sql CLIPPED," AND qcc08 in ('1','9')"
            # END IF     
            # IF  g_argv1 = "2"  THEN 
            #     LET l_sql = l_sql CLIPPED," AND qcc08 in ('5','9')" 
            # END IF     
            # IF  g_argv1 = "3"  THEN 
            #     LET l_sql = l_sql CLIPPED," AND qcc08 in ('4','9')"
            # END IF     
            # IF  g_argv1 = "4"  THEN 
            #     LET l_sql = l_sql CLIPPED," AND qcc08 in ('2','9')"
            # END IF 
            #  PREPARE qcc_sel3 FROM l_sql  
            #  EXECUTE qcc_sel3 USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,g_qct[l_ac].qct04
            #    INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                                    
            #IF STATUS=100 THEN
            #   EXECUTE qcc_sel3 USING g_qcs.qcs01,g_qcs.qcs02,'*',g_qct[l_ac].qct04
            #     INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07
            #   IF STATUS=100 THEN
            #      LET l_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
            #                  " FROM qcd_file ",
            #                  " WHERE qcd01=? AND qcd02=? "
            #     IF  g_argv1 = "1"  THEN 
            #         LET l_sql = l_sql CLIPPED," AND qcd08 in ('1','9')" 
            #     END IF          
            #     IF  g_argv1 = "2"  THEN 
            #         LET l_sql = l_sql CLIPPED," AND qcd08 in ('5','9')" 
            #     END IF          
            #     IF  g_argv1 = "3"  THEN 
            #         LET l_sql = l_sql CLIPPED," AND qcd08 in ('4','9')"
            #     END IF          
            #     IF  g_argv1 = "4"  THEN 
            #         LET l_sql = l_sql CLIPPED," AND qcd08 in ('2','9')"
            #     END IF  
            #   PREPARE qcd_sel3 FROM l_sql  
            #    EXECUTE qcd_sel3 USING g_qcs.qcs021,g_qct[l_ac].qct04
            #       INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
            #   IF STATUS=100 THEN
            #      LET l_sql = " SELECT qck05,qck061,qck062,qck07  ",
            #                  "   FROM qck_file,ima_file ",
            #                  "   WHERE ima01=? AND qck01=ima109 ",
            #                  "   AND qck02 = ?"
            #                
            #        IF  g_argv1 = "1"  THEN 
            #            LET l_sql = l_sql CLIPPED," AND qck08 in ('1','9')" 
            #        END IF       
            #        IF  g_argv1 = "2"  THEN 
            #            LET l_sql = l_sql CLIPPED," AND qck08 in ('5','9')"
            #        END IF        
            #        IF  g_argv1 = "3" THEN  
            #            LET l_sql = l_sql CLIPPED," AND qck08 in ('4','9')"
            #        END IF     
            #        IF  g_argv1 = "4" THEN  
            #            LET l_sql = l_sql CLIPPED," AND qck08 in ('2','9')"
            #        END IF    
            #    PREPARE qck_sel3 FROM l_sql  
            #    EXECUTE qck_sel3 USING g_qcs.qcs021,g_qct[l_ac].qct04
            #       INTO  l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
            #      IF STATUS=100 THEN
            #         LET l_qcd07='N'
            #         LET l_qcd05 = ''
            #         LET l_qcd061 = ''
            #         LET l_qcd062 = ''
            #      END IF
            #   END IF                #No.FUN-990071    
            #   END IF       
            #END IF                                   
            UPDATE qct_file SET qct03 = g_qct[l_ac].qct03,
                                qct04 = g_qct[l_ac].qct04,
                                qct05 = g_qct[l_ac].qct05,
                                qct06 = g_qct[l_ac].qct06,
                                qct07 = g_qct[l_ac].qct07,
                                qct08 = g_qct[l_ac].qct08,
                                qct09 = g_qct[l_ac].qct09,
                                qct10 = g_qct[l_ac].qct10,
                                qct11 = g_qct[l_ac].qct11,
                                qct12 = l_qcd05,
                               qct131 = l_qcd061,
                               qct132 = l_qcd062,
                              qctud01 = g_qct[l_ac].qctud01,
                              qctud02 = g_qct[l_ac].qctud02,
                              qctud03 = g_qct[l_ac].qctud03,
                              qctud04 = g_qct[l_ac].qctud04,
                              qctud05 = g_qct[l_ac].qctud05,
                              qctud06 = g_qct[l_ac].qctud06,
                              qctud07 = g_qct[l_ac].qctud07,
                              qctud08 = g_qct[l_ac].qctud08,
                              qctud09 = g_qct[l_ac].qctud09,
                              qctud10 = g_qct[l_ac].qctud10,
                              qctud11 = g_qct[l_ac].qctud11,
                              qctud12 = g_qct[l_ac].qctud12,
                              qctud13 = g_qct[l_ac].qctud13,
                              qctud14 = g_qct[l_ac].qctud14,
                              qctud15 = g_qct[l_ac].qctud15
            WHERE qct01 = g_qcs.qcs01
              AND qct02 = g_qcs.qcs02
              AND qct021 = g_qcs.qcs05
              AND qct03 = g_qct_t.qct03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","qct_file",g_qcs.qcs01,g_qct_t.qct03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               LET g_qct[l_ac].* = g_qct_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
      #MOD-D20006 mark start ----- 
      #LET l_length = g_qct.getlength()
      #IF l_ac = l_length THEN 
      #    EXIT INPUT
      #END IF
      #MOD-D20006 mark end   -----
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_qct[l_ac].* = g_qct_t.*
            END IF
            CLOSE t110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t110_bcl
         COMMIT WORK
 
      ON ACTION reason
         IF l_ac > 0 THEN                                    #TQC-C20264 add
            IF g_qct[l_ac].qct07>0 THEN     
               CALL t110_more_b(g_qct[l_ac].qct07)           #TQC-970126
            END IF
         END IF                                              #TQC-C20264 add

     #FUN-C30149 add START
      ON ACTION re_ins_g_b
         IF cl_confirm('aqc-081') THEN
            LET g_flag = 'Y'
            CALL t110_g_b()
            EXIT INPUT
         END IF
     #FUN-C30149 add END
 
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
 
   LET g_qcs.qcsmodu = g_user
   LET g_qcs.qcsdate = g_today
 
   UPDATE qcs_file SET qcsmodu = g_qcs.qcsmodu,
                       qcsdate = g_qcs.qcsdate
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   DISPLAY BY NAME g_qcs.qcsmodu,g_qcs.qcsdate
 
   CLOSE t110_bcl
   COMMIT WORK
 
   #------------------------------------------------- 單身不良總合判定
   LET l_cnt=0 LET l_numcr=0 LET l_numma=0 LET l_nummi=0
 
   SELECT COUNT(*) INTO l_cnt FROM qct_file
    WHERE qct01 = g_qcs.qcs01
      AND qct02 = g_qcs.qcs02
      AND qct021 = g_qcs.qcs05
      AND qct08 = '2'
   SELECT ima918,ima921 INTO g_ima918,g_ima921
     FROM ima_file
    WHERE ima01 = g_qcs.qcs021
      AND imaacti = "Y"
   IF l_cnt > 0 THEN
      LET g_qcs.qcs09='2'
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
#MOD-AC0373 ----------------------Begin------------------------------
            IF g_qcs.qcs00 = 'A' OR g_qcs.qcs00 = 'B' THEN
               UPDATE rvbs_file SET rvbs10 = 0,
                                    rvbs06 = 0
                WHERE rvbs00 = g_prog
                  AND rvbs01 = g_qcs.qcs01
                  AND rvbs02 = g_qcs.qcs02
                  AND rvbs13 = g_qcs.qcs05
                  AND rvbs09 = 1
            ELSE
#MOD-AC0373 ----------------End-------------------------------------
               UPDATE rvbs_file SET rvbs10 = 0
                  WHERE rvbs00 = g_prog
                    AND rvbs01 = g_qcs.qcs01
                    AND rvbs02 = g_qcs.qcs02
                    AND rvbs13 = g_qcs.qcs05
                    AND rvbs09 = 1
            END IF           #MOD-AC0373
         END IF
      END IF
   ELSE
      LET g_qcs.qcs09='1'
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
            UPDATE rvbs_file SET rvbs10 = rvbs06
               WHERE rvbs00 = g_prog
                 AND rvbs01 = g_qcs.qcs01
                 AND rvbs02 = g_qcs.qcs02
                 AND rvbs13 = g_qcs.qcs05
                 AND rvbs09 = 1
         END IF
      END IF
   END IF
 
   #當參數『QC是否卡承認文號(AVL)』='Y',『資料來源』='1'收貨單,
   #且無承認文號時,『判定結果』只能為『特採』
   #在判斷qcz13(QC作AVL控管)的地方增加判斷料件是否做AVL管理，兩者都為Y，才檢查
   SELECT ima926 INTO l_ima926 FROM ima_file 
      WHERE ima01 = g_qcs.qcs021
   IF g_qcs.qcs09 = '1' AND g_qcz.qcz13='Y' AND l_ima926 = 'Y'   #FUN-930108 add ima926='Y'
      AND g_qcs.qcs00 = '1' AND cl_null(g_qcs.qcs10) THEN
      LET g_qcs.qcs09='3'
      CALL cl_err('','aqc-051',1)
   END IF
 
   #--------- CR 不良數
   SELECT SUM(qct07) INTO l_numcr FROM qct_file
    WHERE qct01=g_qcs.qcs01
      AND qct02=g_qcs.qcs02
      AND qct021=g_qcs.qcs05
      AND qct05='1'
   IF l_numcr IS NULL THEN LET l_numcr=0 END IF
 
   SELECT SUM(qct07) INTO l_numma FROM qct_file
    WHERE qct01=g_qcs.qcs01
      AND qct02=g_qcs.qcs02
      AND qct021=g_qcs.qcs05
      AND qct05='2'
   IF l_numma IS NULL THEN LET l_numma=0 END IF
 
   SELECT SUM(qct07) INTO l_nummi FROM qct_file
    WHERE qct01=g_qcs.qcs01
      AND qct02=g_qcs.qcs02
      AND qct021=g_qcs.qcs05
      AND qct05='3'
   IF l_nummi IS NULL THEN LET l_nummi=0 END IF
 
   LET g_qcs.qcs091=g_qcs.qcs22
 
   LET g_qcs.qcs36 = g_qcs.qcs30
   LET g_qcs.qcs37 = g_qcs.qcs31
   LET g_qcs.qcs38 = g_qcs.qcs32
   LET g_qcs.qcs39 = g_qcs.qcs33
   LET g_qcs.qcs40 = g_qcs.qcs34
   LET g_qcs.qcs41 = g_qcs.qcs35
 
   CASE g_qcs.qcs09
      WHEN '1'
         CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
      WHEN '2'
         CALL cl_getmsg('apm-244',g_lang) RETURNING des1 #No:7706
         LET g_qcs.qcs091 = 0 #bugno:4135 :2.退貨->合格量=0
         LET g_qcs.qcs38 = 0  #No.FUN-610075
         LET g_qcs.qcs41 = 0  #No.FUN-610075
      WHEN '3'
         CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE
 
   DISPLAY des1 TO FORMONLY.des1
   DISPLAY BY NAME g_qcs.qcs091,g_qcs.qcs09,g_qcs.qcs13
   DISPLAY BY NAME g_qcs.qcs36,g_qcs.qcs37,g_qcs.qcs38   #No.FUN-610075
   DISPLAY BY NAME g_qcs.qcs39,g_qcs.qcs40,g_qcs.qcs41   #No.FUN-610075
 
   UPDATE qcs_file SET qcs091 = g_qcs.qcs091,
                       qcs09 = g_qcs.qcs09,
                       qcs36 = g_qcs.qcs36,   #No.FUN-610075
                       qcs37 = g_qcs.qcs37,   #No.FUN-610075
                       qcs38 = g_qcs.qcs38,   #No.FUN-610075
                       qcs39 = g_qcs.qcs39,   #No.FUN-610075
                       qcs40 = g_qcs.qcs40,   #No.FUN-610075
                       qcs41 = g_qcs.qcs41    #No.FUN-610075
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05

   #FUN-C30149 add START
    IF g_flag = 'Y' THEN
       LET g_flag = 'N'
       CALL t110_show()
       CALL t110_b()
    END IF
   #FUN-C30149 add END
 
    CALL t110_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t110_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
        #CALL t110_x()            #CHI-D20010
         CALL t110_x(1)            #CHI-D20010
         IF g_qcs.qcs14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM qco_file
          WHERE qco01 = g_qcs.qcs01
            AND qco02 = g_qcs.qcs02
            AND qco05 = g_qcs.qcs05

         DELETE FROM qao_file 
          WHERE qao01 = g_qcs.qcs01
            AND qao02 = g_qcs.qcs02         
            AND qao021= g_qcs.qcs05   
          
         DELETE FROM qcv_file 
          WHERE qcv01 = g_qcs.qcs01
            AND qcv02 = g_qcs.qcs02
            AND qcv21 = g_qcs.qcs05
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM qcs_file WHERE qcs01 = g_qcs.qcs01
                                AND qcs02 = g_qcs.qcs02
                                AND qcs05 = g_qcs.qcs05
         INITIALIZE g_qcs.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t110_b_askkey()
   DEFINE l_wc2   STRING
 
   CONSTRUCT l_wc2 ON qct03,qct04,qct05,qct06,qct09,qct10,qct14,qct15,qct11,qct07,qct08       #No.FUN-A80063
                      ,qctud01,qctud02,qctud03,qctud04,qctud05
                      ,qctud06,qctud07,qctud08,qctud09,qctud10
                      ,qctud11,qctud12,qctud13,qctud14,qctud15
           FROM s_qct[1].qct03,s_qct[1].qct04,s_qct[1].qct05,
                s_qct[1].qct06,s_qct[1].qct09,s_qct[1].qct10,s_qct[1].qct14,s_qct[1].qct15,   #No.FUN-A80063
                s_qct[1].qct11,s_qct[1].qct07,s_qct[1].qct08
                ,s_qct[1].qctud01,s_qct[1].qctud02,s_qct[1].qctud03
                ,s_qct[1].qctud04,s_qct[1].qctud05,s_qct[1].qctud06
                ,s_qct[1].qctud07,s_qct[1].qctud08,s_qct[1].qctud09
                ,s_qct[1].qctud10,s_qct[1].qctud11,s_qct[1].qctud12
                ,s_qct[1].qctud13,s_qct[1].qctud14,s_qct[1].qctud15
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
 
   CALL t110_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)
   DEFINE l_qct12   LIKE qct_file.qct12,
          p_wc2     LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(200)
 
   IF p_wc2 IS NULL THEN
      LET p_wc2=" 1=1 "
   END IF
 
   LET g_sql = "SELECT qct03,qct04,azf03,qct05,qct06,qct09,qct10,qct14,qct15,",       #No.FUN-A80063
               "       qct11,qct07,qct08,' ',",  #qct12, ",  #FUN-840068 mod
               "       qctud01,qctud02,qctud03,qctud04,qctud05,",
               "       qctud06,qctud07,qctud08,qctud09,qctud10,",
               "       qctud11,qctud12,qctud13,qctud14,qctud15,",
               "       qct12 ", 
             # "  FROM qct_file LEFT OUTER JOIN azf_file ON qct_file.qct04 =azf_file.azf01 ",   #liuxqa 091022 #TQC-C20178
               "  FROM qct_file LEFT OUTER JOIN azf_file ON qct_file.qct04 =azf_file.azf01  AND azf02='6'", #TQC-C20178
               " WHERE qct01 ='",g_qcs.qcs01,"'",
               "   AND qct02 ='",g_qcs.qcs02,"'",
               "   AND qct021='",g_qcs.qcs05,"'",
              #"   AND azf02='6' ",      #liuxqa 091022 #TQC-C20178
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY qct03"
 
   PREPARE t110_pb FROM g_sql
   DECLARE qct_curs CURSOR FOR t110_pb
 
   CALL g_qct.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH qct_curs INTO g_qct[g_cnt].*,l_qct12   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #-------- Ac,Re 數量賦予
      IF l_qct12 ='1' THEN    # bugno:5022 --> C=0 不執行s_newqal
 
      END IF
 
      CASE g_qct[g_cnt].qct08
         WHEN '1'
            CALL cl_getmsg('aqc-004',g_lang) RETURNING g_qct[g_cnt].qct08_desc
         WHEN '2'
            CALL cl_getmsg('apm-244',g_lang) RETURNING g_qct[g_cnt].qct08_desc #No:7706 驗退
      END CASE
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_qct.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1               #告訴I.單身筆數
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

   #FUN-B30170 add begin-------------------------
   LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
               "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
               "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_qcs.qcs01,"'",
               "    AND rvbs13 = '",g_qcs.qcs05,"'"
   PREPARE sel_rvbs_pre FROM g_sql
   DECLARE rvbs_curs1 CURSOR FOR sel_rvbs_pre

   CALL g_rvbs.clear()

   LET g_cnt = 1
   FOREACH rvbs_curs1 INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvbs.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   #FUN-B30170 add -end--------------------------
 
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("qcsspc",FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY


      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_qcs.qcs14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
         IF g_argv1 != "1" THEN
            CALL t110_form_default()                  #No.FUN-5C0077
         END IF
         CALL t110_def_form()   #TQC-660106
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
#@    ON ACTION 單身不良原因
      ON ACTION detail_flaw_reason
         LET g_action_choice="detail_flaw_reason"
         EXIT DIALOG
 
#@    ON ACTION 單身測量值查詢
      ON ACTION qry_detail_measure
         LET g_action_choice="qry_detail_measure"
         EXIT DIALOG
 
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DIALOG
 
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
 
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
 
#@    ON ACTION 特採
      ON ACTION special_purchase
         LET g_action_choice="special_purchase"
         EXIT DIALOG
#FUN-A30045 --------------------Begin-------------------
      ON ACTION cancel_special_purchase
         LET g_action_choice="cancel_special_purchase"
         EXIT DIALOG                  
#FUN-A30045 --------------------End---------------------

#FUN-BC0104 -------------Begin-------------
      ON ACTION qc_item_maintain
         LET g_action_choice="qc_item_maintain"
         EXIT DIALOG 
#FUN-BC0104 -------------End---------------

#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#CHI-D20010---add---str
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#CHI-D20010---add---end 
#@    ON ACTION 轉入庫單
      ON ACTION tran_store
         LET g_action_choice="tran_store"
         EXIT DIALOG
 
#@    ON ACTION 聯產品
      ON ACTION core_item
         LET g_action_choice="core_item"
         EXIT DIALOG
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc
         LET g_action_choice="trans_spc"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION WO_Memo
         LET g_action_choice = "WO_Memo"
         EXIT DIALOG 
    
      ON ACTION WO_Issuing
         LET g_action_choice = "WO_Issuing"
         EXIT DIALOG
 
      ON ACTION RETURN_INFO
         LET g_action_choice = "RETURN_INFO"
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0160 date->l_date  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
 
      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DIALOG

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DIALOG

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DIALOG
      #DEV-D30045--add--end
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

      &include "qry_string.4gl" 
   END DIALOG
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark begin--------------------------
#   DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
# 
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL t110_fetch('F')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t110_fetch('P')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION jump
#         CALL t110_fetch('/')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION next
#         CALL t110_fetch('N')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION last
#         CALL t110_fetch('L')
#         CALL cl_navigator_setting(g_curs_index,g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
# 
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         IF g_qcs.qcs14 = 'X' THEN
#            LET g_void = 'Y'
#         ELSE
#            LET g_void = 'N'
#         END IF
#         CALL cl_set_field_pic(g_qcs.qcs14,"","","",g_void,g_qcs.qcsacti)
#         IF g_argv1 != "1" THEN
#            CALL t110_form_default()                  #No.FUN-5C0077
#         END IF
#         CALL t110_def_form()   #TQC-660106
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
##@    ON ACTION 單身不良原因
#      ON ACTION detail_flaw_reason
#         LET g_action_choice="detail_flaw_reason"
#         EXIT DISPLAY
# 
##@    ON ACTION 單身測量值查詢
#      ON ACTION qry_detail_measure
#         LET g_action_choice="qry_detail_measure"
#         EXIT DISPLAY
# 
##@    ON ACTION 備註
#      ON ACTION memo
#         LET g_action_choice="memo"
#         EXIT DISPLAY
# 
##@    ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
# 
##@    ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
# 
##@    ON ACTION 特採
#      ON ACTION special_purchase
#         LET g_action_choice="special_purchase"
#         EXIT DISPLAY
##FUN-A30045 --------------------Begin------------------
#      ON ACTION cancel_special_purchase
#         LET g_action_choice="cancel_special_purchase"
#         EXIT DISPLAY                  
##FUN-A30045 --------------------End--------------------
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
##@    ON ACTION 轉入庫單
#      ON ACTION tran_store
#         LET g_action_choice="tran_store"
#         EXIT DISPLAY
# 
##@    ON ACTION 聯產品
#      ON ACTION core_item
#         LET g_action_choice="core_item"
#         EXIT DISPLAY
# 
##@    ON ACTION 拋轉至SPC
#      ON ACTION trans_spc
#         LET g_action_choice="trans_spc"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#&ifdef ICD
#      ON ACTION WO_Memo
#         LET g_action_choice = "WO_Memo"
#         EXIT DISPLAY 
#    
#      ON ACTION WO_Issuing
#         LET g_action_choice = "WO_Issuing"
#         EXIT DISPLAY
# 
#      ON ACTION RETURN_INFO
#         LET g_action_choice = "RETURN_INFO"
#         EXIT DISPLAY
#&endif
#      ON ACTION cancel
#         LET INT_FLAG=FALSE             #MOD-570244 mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel #FUN-4B0003
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION related_document                #No.FUN-6A0160 date->l_date  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      ON ACTION controls                           #No.FUN-6B0032             
#         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
# 
#      &include "qry_string.4gl" 
# 
#   END DISPLAY
#FUN-B30170 mark -end---------------------------
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
FUNCTION t110_ref()
 
   CASE
      WHEN g_qcs.qcs00 = '1' OR g_qcs.qcs00 = '2'
         SELECT rva05,rvb05
           INTO g_qcs.qcs03,g_qcs.qcs021
           FROM rvb_file ,rva_file
          WHERE rvb01 = g_qcs.qcs01
            AND rvb02 = g_qcs.qcs02
            AND rva01 = rvb01
      WHEN g_qcs.qcs00 = 'A' OR g_qcs.qcs00 = 'B'
         SELECT inb04 INTO g_qcs.qcs021
           FROM inb_file
          WHERE inb01 = g_qcs.qcs01
            AND inb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'C' OR g_qcs.qcs00 = 'D'
         SELECT imn03 INTO g_qcs.qcs021
           FROM imn_file
          WHERE imn01 = g_qcs.qcs01
            AND imn02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'E'
         SELECT imp03,imo03 INTO g_qcs.qcs021,g_qcs.qcs03    #CHI-6A0006 
           FROM imp_file,imo_file
          WHERE imp01 = g_qcs.qcs01
            AND imp02 = g_qcs.qcs02
            AND imo01 = imp01
      WHEN g_qcs.qcs00 = 'F'
         SELECT imq05 INTO g_qcs.qcs021
           FROM imq_file
          WHERE imq01 = g_qcs.qcs01
            AND imq02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'G'
         SELECT qsa12,qsa02
           INTO g_qcs.qcs03,g_qcs.qcs021
           FROM qsa_file
          WHERE qsa01 = g_qcs.qcs01
      WHEN g_qcs.qcs00 = 'H'
         SELECT oha03,ohb04
           INTO g_qcs.qcs03,g_qcs.qcs021
           FROM oha_file,ohb_file
          WHERE oha01 = ohb01
            AND ohb01 = g_qcs.qcs01
            AND ohb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = '5' OR g_qcs.qcs00 = '6'
         SELECT oga03,ogb04
           INTO g_qcs.qcs03,g_qcs.qcs021
           FROM ogb_file ,oga_file
          WHERE ogb01 = g_qcs.qcs01
            AND ogb03 = g_qcs.qcs02
            AND oga01 = ogb01
      WHEN g_qcs.qcs00 = '7'
         SELECT srg014
           INTO g_qcs.qcs021
           FROM srf_file ,srg_file
          WHERE srf01 = g_qcs.qcs01
            AND srg02 = g_qcs.qcs02
            AND srf01 = srg01
   END CASE
 
   IF STATUS=100 THEN
      LET g_qcs.qcs03=' '
      LET g_qcs.qcs021=' '
      LET g_qcs.qcs10=' '
   END IF
#No.FUN-A80063 --begin
   SELECT ima101  
     INTO g_ima101  
     FROM ima_file
    WHERE ima01 = g_qcs.qcs021
#No.FUN-A80063 --end 
   CALL t110_get_ecm04()  #MOD-890102
   CALL t110_qcs03()
 
   CALL t110_qcs10()    #select qcs10 values
 
END FUNCTION
 
FUNCTION t110_defqty(l_def,l_rate,l_level,l_type)       #No.FUN-A80063 add l_level l_type
   DEFINE l_def     LIKE type_file.num5,         #No.FUN-680104 SMALLINT  #00-12-29   1:單頭入 2.單身入
          l_rate    LIKE qcd_file.qcd04,
          l_qcb04   LIKE qcb_file.qcb04
   DEFINE l_pmh09   LIKE pmh_file.pmh09,
          l_pmh15   LIKE pmh_file.pmh15,
          l_pmh16   LIKE pmh_file.pmh16,
          l_qca03   LIKE qca_file.qca03,
          l_qca04   LIKE qca_file.qca04,
          l_qca05   LIKE qca_file.qca05,
          l_qca06   LIKE qca_file.qca06,
          l_sql     STRING #FUN-5C0114
   DEFINE l_qty     LIKE type_file.num10          #No.MOD-7C0145 add
   #DEFINE l_ima915  LIKE ima_file.ima915   #MOD-A40146   #CHI-B90064 mark
#No.FUN-A80063 --begin
   DEFINE l_level   LIKE qcd_file.qcd03
   DEFINE l_type    LIKE qcd_file.qcd05
   DEFINE l_qdg04   LIKE qdg_file.qdg04
   DEFINE l_qcd03   LIKE qcd_file.qcd03
   DEFINE l_qdf02   LIKE qdf_file.qdf02
#No.FUN-A80063 --end
 
   #對送驗量做四捨五入
    LET l_qty = g_qcs22
    LET g_qcs22 = l_qty
    IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
       SELECT obk12,obk13,obk14 INTO l_pmh09,l_pmh15,l_pmh16
         FROM obk_file
        WHERE obk01 = g_qcs.qcs021
          AND obk02 = g_qcs.qcs03
          AND obk05 = (SELECT oga23 FROM oga_file WHERE oga01 = g_qcs.qcs01) #MOD-880118
       IF STATUS THEN
         #str MOD-A20100 add
          SELECT ima100,ima101,ima102 INTO l_pmh09,l_pmh15,l_pmh16
            FROM ima_file
           WHERE ima01=g_qcs.qcs021
          IF STATUS THEN
         #end MOD-A20100 add
             LET l_pmh09=''
             LET l_pmh15=''
             LET l_pmh16=''
          END IF   #MOD-A20100 add
       END IF
    ELSE 
       #LET l_ima915 = ''   #MOD-A40146   #CHI-B90064 mark
       IF g_qcs.qcs00<>'7' THEN
          #-----CHI-B90064---------
          ##-----MOD-A40146---------
          #SELECT ima915 INTO l_ima915 FROM ima_file 
          #  WHERE ima01=g_qcs.qcs021
          #IF cl_null(l_ima915) THEN
          #   LET l_ima915 = '0'
          #END IF
          ##-----END MOD-A40146----- 
          #-----END CHI-B90064-----
          LET l_sql="SELECT pmh09,pmh15,pmh16 FROM pmh_file",
                    " WHERE pmh01 ='", g_qcs.qcs021 ,"'",
                    "   AND pmh02 ='", g_qcs.qcs03  ,"'",
                    "   AND pmh21 ='", g_ecm04      ,"'",      #CHI-860042   #MOD-890102 modify ' '->g_ecm04
                    "   AND pmh22 ='", g_type       ,"'",      #CHI-860042   #MOD-890102 modify '1'->g_type
                    "   AND pmh23 = ' ' "                     #No.CHI-960033 #No.CHI-A10021 mod , 
                   # "   AND pmhacti = 'Y'"                    #CHI-910021   #No.CHI-A10021 mark
       ELSE
          LET l_sql="SELECT ima100,ima101,ima102 FROM ima_file",
                    " WHERE ima01 ='", g_qcs.qcs021 ,"'"
       END IF
       PREPARE pmh_cur2_pre FROM l_sql
       DECLARE pmh_cur2 CURSOR FOR pmh_cur2_pre
       OPEN pmh_cur2
       FETCH pmh_cur2 INTO l_pmh09,l_pmh15,l_pmh16
       IF STATUS THEN   #MOD-A40146   #CHI-B90064 remark
       #IF STATUS OR l_ima915 = '0' THEN   #MOD-A40146   #CHI-B90064 mark
          SELECT pmc906,pmc905,pmc907
            INTO l_pmh09,l_pmh15,l_pmh16
            FROM pmc_file
           WHERE pmc01 = g_qcs.qcs03
          IF STATUS OR cl_null(l_pmh09) OR cl_null(l_pmh15)
             OR cl_null(l_pmh16) THEN   #No.TQC-620129
             SELECT ima100,ima101,ima102
               INTO l_pmh09,l_pmh15,l_pmh16
               FROM ima_file
              WHERE ima01 = g_qcs.qcs021
             IF STATUS THEN
                LET l_pmh09=''
                LET l_pmh15=''
                LET l_pmh16=''
                RETURN 0
             END IF
          END IF
       END IF
    END IF
 
   LET g_qcs.qcs17 = l_pmh16   #No.MOD-570293
   IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF
   IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF
   IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF
 
   IF l_pmh15='1' THEN
      IF l_def=1 THEN
         SELECT qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
          WHERE g_qcs22 BETWEEN qca01 AND qca02        #bugno:7196
            AND qca07 = g_qcs.qcs17
         IF STATUS AND g_qcs22 !=1 THEN
            RETURN 0
         END IF
      ELSE #單身入
         SELECT qcb04
           INTO l_qcb04
           FROM qca_file,qcb_file
          WHERE (g_qcs22 BETWEEN qca01 AND qca02)       #bugno:7196
            AND qcb02 = l_rate
            AND qca03 = qcb03
            AND qca07 = g_qcs.qcs17
            AND qcb01 = g_qcs.qcs21
         IF NOT cl_null(l_qcb04) THEN
             #此SQL目的是依據上面抓到的"調整字號"，
             #對回去qca_file抓取對應的檢驗樣本數，
             #所以不應該與批量有關係
              SELECT UNIQUE qca03,qca04,qca05,qca06
                INTO l_qca03,l_qca04,l_qca05,l_qca06
                FROM qca_file
               WHERE qca03=l_qcb04
#                AND g_qcs22 BETWEEN qca01 AND qca02  #MOD-B60031 add   #MOD-B80091 mark
#                AND qca07=g_qcs.qcs17                #MOD-B60031 add   #MOD-B80091 mark
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
         END IF
      END IF
   END IF
 
   IF l_pmh15 = '2' THEN
      IF l_def = 1 THEN
         SELECT qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
          WHERE g_qcs22 BETWEEN qch01 AND qch02       #bugno:7196
            AND qch07 = g_qcs.qcs17
         IF STATUS AND g_qcs22 != 1 THEN
            RETURN 0
         END IF
      ELSE #單身入
         SELECT qcb04 INTO l_qcb04
           FROM qch_file,qcb_file
          WHERE (g_qcs22 BETWEEN qch01 AND qch02)       #bugno:7196
            AND qcb02 = l_rate
            AND qch03 = qcb03
            AND qch07 = g_qcs.qcs17
            AND qcb01 = g_qcs.qcs21
         IF NOT cl_null(l_qcb04) THEN
              SELECT UNIQUE qch03,qch04,qch05,qch06
                INTO l_qca03,l_qca04,l_qca05,l_qca06
                FROM qch_file
               WHERE qch03=l_qcb04
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
         END IF
      END IF
   END IF
 
   IF g_qcs22 = 1 THEN
      LET l_qca04 = 1
      LET l_qca05 = 1
      LET l_qca06 = 1
   END IF

#No.FUN-A80063 --begin 
#   CASE l_pmh09
#      WHEN 'N'
#         RETURN l_qca04
#      WHEN 'T'
#         RETURN l_qca05
#      WHEN 'R'
#         RETURN l_qca06
#      OTHERWISE
#         RETURN 0
#   END CASE

  IF l_type ='1' OR l_type ='2' THEN 
      CASE l_pmh09
         WHEN 'N'
            RETURN l_qca04
         WHEN 'T'
            RETURN l_qca05
         WHEN 'R'
            RETURN l_qca06
         OTHERWISE
            RETURN 0
      END CASE
  END IF 
  IF l_type ='3' OR l_type ='4' THEN 
      CASE l_pmh09
         WHEN 'N'
            LET l_qcd03 = l_level
         WHEN 'T'
            LET l_qcd03 = l_level+1
            IF l_qcd03 = 8 THEN 
               LET l_qcd03 ='T'
            END IF 
         WHEN 'R'
            LET l_qcd03 = l_level-1
            IF l_qcd03 = 0 THEN 
               LET l_qcd03 ='R'
            END IF 
         OTHERWISE
            RETURN 0
      END CASE  
      SELECT qdf02 INTO l_qdf02
        FROM qdf_file
       WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04) 
         AND qdf01 = l_qcd03
      SELECT qdg04 INTO l_qdg04
        FROM qdg_file
       WHERE qdg01 = g_ima101
         AND qdg02 = l_qcd03
         AND qdg03 = l_qdf02
      IF SQLCA.sqlcode THEN 
         LET l_qdg04 = 0
      END IF    
      RETURN l_qdg04
   END IF 
#No.FUN-A80063 --end 
END FUNCTION
 
FUNCTION t110_check_pmh09()
   DEFINE l_count,m_cnt   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countn        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countt        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countr        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_pass          LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_down          LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_down1         LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_qcs01         LIKE qcs_file.qcs01,         #No.FUN-680104 VARCHAR(16) #No.FUN-550029
          l_qcs09         LIKE qcs_file.qcs09,         #No.FUN-680104 VARCHAR(01)
          l_qcs04         LIKE qcs_file.qcs04,         #No.FUN-680104 DATE
          l_qcs041        LIKE qcs_file.qcs041,        #No.FUN-680104 VARCHAR(08)
          l_qcs21         LIKE qcs_file.qcs21,
          l_pmh09         LIKE pmh_file.pmh09
 
   LET l_count = 0
   LET l_countn= 0
   LET l_countt= 0
   LET l_countr= 0
 
   LET g_sql = "SELECT qcs09,qcs04,qcs01,qcs041,qcs21" ,
               "  FROM qcs_file  ",
               " WHERE qcs03  = '",g_qcs.qcs03,"'",
               "   AND qcs021 = '",g_qcs.qcs021,"'",
               "   AND qcsacti = 'Y' AND qcs14='Y' ",
               " ORDER BY qcs04 DESC,qcs041 DESC "
 
   PREPARE t110_c2 FROM g_sql
 
   DECLARE t110_c2p SCROLL CURSOR WITH HOLD FOR t110_c2
 
   FOREACH t110_c2p INTO l_qcs09,l_qcs04,l_qcs01,l_qcs041,l_qcs21
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      IF l_qcs09 NOT MATCHES '[123]' THEN
         CONTINUE FOREACH
      END IF
 
      IF l_qcs21 NOT MATCHES '[NTR]' THEN
         CONTINUE FOREACH
      END IF
 
      LET l_count = l_count + 1
      CASE l_qcs21
         WHEN 'N' LET l_countn = l_countn + 1
         WHEN 'T' LET l_countt = l_countt + 1
         WHEN 'R' LET l_countr = l_countr + 1
      END CASE
 
      CASE l_qcs09
         WHEN '1'
            LET l_pass = l_pass + 1    #--- 合格
         WHEN '2'
            LET l_down = l_down + 1    #--- 退貨
         WHEN '3'
            LET l_down1 = l_down1 + 1  #--- 特採
      END CASE
 
      LET l_pmh09 = g_qcs.qcs21
 
      CASE g_qcs.qcs21
         WHEN 'N'      #正常檢驗
            CASE
               WHEN l_count = g_qcz.qcz08 AND l_countn = g_qcz.qcz08
                                          AND l_pass = g_qcz.qcz08
                  LET l_pmh09 = 'R'
                  EXIT FOREACH
               WHEN l_count <= g_qcz.qcz06 AND l_countn <= g_qcz.qcz06
                                           AND l_down = g_qcz.qcz061
                  LET l_pmh09 = 'T'
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz08 AND l_count > g_qcz.qcz06
                  EXIT FOREACH
            END CASE
         WHEN 'T'      #加嚴檢驗
            CASE
               WHEN l_count =g_qcz.qcz07  AND l_countt = g_qcz.qcz07
                                         AND l_pass = g_qcz.qcz07
                  LET l_pmh09 = 'N'
                  EXIT FOREACH
              WHEN l_count =g_qcz.qcz11  AND l_countt = g_qcz.qcz11
                                         AND l_down = g_qcz.qcz11
                  LET l_pmh09 = 'T'
                  IF g_qcs.qcs00 NOT MATCHES '[56]' THEN
                     UPDATE pmh_file SET pmh05='1',pmh06='',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
                      WHERE pmh01=g_qcs.qcs021 AND pmh02=g_qcs.qcs03
                        AND pmh21 = g_ecm04                             #CHI-860042   #MOD-890102 modify ' '->g_ecm04
                        AND pmh22 = g_type                              #CHI-860042   #MOD-890102 modify '1'->g_type
                        AND pmh23 = ' '                                 #No.CHI-960033
                  END IF
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz07 AND l_count > g_qcz.qcz11
                  EXIT FOREACH
            END CASE
         WHEN 'R'      #減量檢驗
            CASE
               WHEN l_count = g_qcz.qcz09 AND l_countr = g_qcz.qcz09
                                          AND l_down = g_qcz.qcz09
                  LET l_pmh09 = 'N'
                  EXIT FOREACH
               WHEN l_count = g_qcz.qcz10 AND l_countr = g_qcz.qcz10
                                          AND l_pass = g_qcz.qcz10
                  LET l_pmh09 = 'R'
                  IF g_qcs.qcs00 MATCHES '[56]' THEN
                     UPDATE obk_file SET obk11 = 'N'
                                   WHERE obk01 = g_qcs.qcs021
                                     AND obk02 = g_qcs.qcs03
                  ELSE
                     UPDATE pmh_file SET pmh08='N',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
                        WHERE pmh01=g_qcs.qcs021 AND pmh02=g_qcs.qcs03
                          AND pmh21 = g_ecm04                           #CHI-860042   #MOD-890102 modify ' '->g_ecm04
                          AND pmh22 = g_type                            #CHI-860042   #MOD-890102 modify '1'->g_type
                          AND pmh23 = ' '                               #No.CHI-960033
                  END IF
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz09 AND l_count > g_qcz.qcz10
                  EXIT FOREACH
            END CASE
      END CASE
   END FOREACH
 
   IF cl_null(l_pmh09) THEN
      LET l_pmh09 = 'N'
   END IF
 
   IF g_qcs.qcs00 MATCHES '[56]' THEN
      UPDATE obk_file SET obk12 = l_pmh09
       WHERE obk01 = g_qcs.qcs021
         AND obk02 = g_qcs.qcs03
   ELSE
      UPDATE pmh_file SET pmh09 = l_pmh09,pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
       WHERE pmh01 = g_qcs.qcs021
         AND pmh02 = g_qcs.qcs03
         AND pmh21 = g_ecm04                             #CHI-860042   #MOD-890102 modify ' '->g_ecm04
         AND pmh22 = g_type                              #CHI-860042   #MOD-890102 modify '1'->g_type
         AND pmh23 = ' '                                 #No.CHI-960033
   END IF

   #str MOD-A30058 add
   IF g_qcs.qcs21 = 'R' THEN   #減量檢驗
      IF g_action_choice="undo_confirm" AND l_countr=g_qcz.qcz10-1 THEN
         IF g_qcs.qcs00 MATCHES '[56]' THEN
            UPDATE obk_file SET obk11 = 'Y'
             WHERE obk01 = g_qcs.qcs021
               AND obk02 = g_qcs.qcs03
         ELSE
            UPDATE pmh_file SET pmh08 = 'Y',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
             WHERE pmh01=g_qcs.qcs021 AND pmh02=g_qcs.qcs03
               AND pmh21 = g_ecm04
               AND pmh22 = g_type
               AND pmh23 = ' '
         END IF
      END IF
   END IF
   #end MOD-A30058 add

 
END FUNCTION
 
FUNCTION t110_y_chk()
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_n        LIKE type_file.num5     #TQC-B60106
   DEFINE l_sum      LIKE type_file.num10    #FUN-BC0104
   DEFINE l_sum1     LIKE type_file.num10    #TQC-C20504
   DEFINE l_cnt      LIKE type_file.num5     #DEV-D40015  add
 
   LET g_success = 'Y'
 
#CHI-C30107 -------------- add -------------- begin
   IF g_qcs.qcs14 = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcs.qcs22 = 0 THEN
     CALL cl_err('','aqc-027',0)
     LET g_success = 'N'
     RETURN
   END IF

  #DEV-D40019 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'aqct110' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT qcs021 
                         FROM qcs_file 
                        WHERE qcs01 = g_qcs.qcs01
                          AND qcs02 = g_qcs.qcs02
                          AND qcs05 = g_qcs.qcs05) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
         AND (ima932 <> 'L')                #條碼產生時機點不等於L(IQC) 

     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('confirm','ibj',g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40019 add end--------

   IF g_action_choice CLIPPED = "confirm" THEN
     IF NOT cl_confirm('axm-108') THEN
        LET g_success='N'
        ROLLBACK WORK   #No.MOD-850116
        RETURN
     END IF
   END IF  
#CHI-C30107 -------------- add -------------- end
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcs14 = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_qcs.qcs22 = 0 THEN
     CALL cl_err('','aqc-027',0)
     LET g_success = 'N'
     RETURN
   END IF

#TQC-B60106   ---start   Add
   SELECT COUNT(*) INTO l_n FROM gen_file 
    WHERE gen01 = g_qcs.qcs13
   IF l_n < 1 THEN
      CALL cl_err('','aqc-120',0)
      LET g_success = 'N'
      RETURN
   END IF
#TQC-B60106   ---end     Add
 
   CALL t110_unqc_qty() 
   IF NOT cl_null(g_errno) THEN
       CALL cl_err(g_qcs.qcs01,g_errno,1)
       LET g_success = 'N'
       RETURN
   END IF
 
   IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = g_qcs.qcs021
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = g_qcs.qcs01
               AND rvbs02 = g_qcs.qcs02
               AND rvbs13 = g_qcs.qcs05
               AND rvbs09 = 1
            
            IF cl_null(l_rvbs06) THEN
               LET l_rvbs06 = 0
            END IF
            
            CALL t110_get_fac()
  
            IF g_qcs.qcs09 != '2' THEN        #MOD-BA0194 add 
              #CHI-C30064---Start---add
               SELECT rvb05,rvb36,rvb37,rvb38,rvb90 
                 INTO g_rvb05,g_rvb36,g_rvb37,g_rvb38,g_rvb90
                 FROM rvb_file
                WHERE rvb01 = g_qcs.qcs01
                  AND rvb02 = g_qcs.qcs02
               SELECT img09 INTO g_img09
                 FROM img_file   #庫存單位
               WHERE img01=g_rvb05 AND img02=g_rvb36
                 AND img03=g_rvb37 AND img04=g_rvb38
               CALL s_umfchk(g_rvb05,g_rvb90,g_img09) RETURNING g_cnt,l_fac
               IF g_cnt = '1' THEN LET l_fac = 1 END IF             
              #CHI-C30064---End---add 
               IF (g_qcs.qcs091 * l_fac) <> l_rvbs06 THEN   #CHI-A70047   取消mark
              #IF (g_qcs.qcs22 * l_fac) <> l_rvbs06 THEN   #CHI-A70047   mark
                  LET g_success = "N"
                  CALL cl_err(g_qcs.qcs021,"aim-011",1)
                  RETURN
               END IF
            END IF             #MOD-BA0194 add
         END IF
      END IF
   END IF
 
  IF g_qcs.qcs00 MATCHES '[A]' THEN 
     SELECT COUNT(*) INTO g_cnt
       FROM ina_file,inb_file
       WHERE inb01 = g_qcs.qcs01
         AND inb03 = g_qcs.qcs02
         AND inb01 = ina01
         AND inapost = 'Y'
         AND ina00 MATCHES '[12]'
      IF g_cnt > 0 THEN 
         CALL cl_err(g_qcs.qcs01,'aqc-333',0)
         LET g_success = 'N'
         RETURN
      END IF
  END IF
 
  IF g_qcs.qcs00 MATCHES '[B]' THEN 
     SELECT COUNT(*) INTO g_cnt
       FROM ina_file,inb_file
       WHERE inb01 = g_qcs.qcs01
         AND inb03 = g_qcs.qcs02
         AND inb01 = ina01
         AND inapost = 'Y'
         AND ina00 IN ('3','4')
      IF g_cnt > 0 THEN 
         CALL cl_err(g_qcs.qcs01,'aqc-333',0)
         LET g_success = 'N'
         RETURN
      END IF
  END IF
#FUN-BC0104----add----str----
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
   IF l_n > 0 THEN 
      IF g_qcs.qcs09 ='1' THEN       #MOD-C30557
         SELECT SUM(qco11*qco19) INTO l_sum 
           FROM qco_file,qcl_file
          WHERE qcl01 = qco03
            AND qco01 = g_qcs.qcs01
            AND qco02 = g_qcs.qcs02
            AND qco05 = g_qcs.qcs05
           #AND qcl05 <> '3'         #FUN-CC0013 mark
         IF l_sum != g_qcs.qcs091 THEN
            CALL cl_err(g_qcs.qcs01,'aqc-520',0)
            LET g_success = 'N'
            RETURN
         END IF
      END IF                         #MOD-C30557
      #TQC-C20504----Begin----
      SELECT SUM(qco11*qco19) INTO l_sum1
        FROM qco_file
       WHERE qco01 = g_qcs.qcs01
         AND qco02 = g_qcs.qcs02
         AND qco05 = g_qcs.qcs05
      IF l_sum1 != g_qcs.qcs22 THEN 
         CALL cl_err(g_qcs.qcs01,'aqc-536',0)
         LET g_success ='N'
         RETURN
      END IF
      #TQC-C20504-----End-----
   END IF 
#FUN-BC0104----add----end----

 #DEV-D40019 mark str--------
 ##DEV-D40015 add str--------
 ##若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
 # IF g_aza.aza131 = 'Y' AND g_prog = 'aqct110' THEN
 #   #確認是否有符合條件的料件
 #    LET l_cnt = 0
 #    SELECT COUNT(*) INTO l_cnt
 #      FROM ima_file
 #     WHERE ima01 IN (SELECT qct021 
 #                       FROM qct_file 
 #                      WHERE qct01 = g_qcs.qcs01
 #                        AND qct02 = g_qcs.qcs02
 #                        AND qct021 = g_qcs.qcs05) #料件
 #       AND ima930 = 'Y'                   #條碼使用否
 #       AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
 #       AND (ima932 <> 'L')                #條碼產生時機點不等於L(IQC) 

 #   #確認是否已有掃描紀錄
 #    IF l_cnt > 0 THEN
 #       IF NOT s_chk_barcode_confirm('confirm','ibj',g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05) THEN
 #          LET g_success = 'N'
 #          RETURN
 #       END IF
 #    END IF
 # END IF
 ##DEV-D40015 add end--------
 #DEV-D40019 mark end--------
END FUNCTION
 
FUNCTION t110_y_upd()
   DEFINE l_rvb331  LIKE rvb_file.rvb331
   DEFINE l_rvb332  LIKE rvb_file.rvb332
   DEFINE l_flag    LIKE type_file.num5         #No.FUN-680104 SMALLINT
   DEFINE l_factor  LIKE qcs_file.qcs31
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_rvb33   LIKE rvb_file.rvb33
   DEFINE l_rvb07   LIKE rvb_file.rvb07
   DEFINE l_rvb30   LIKE rvb_file.rvb30  #MOD-640512
   DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-850100
   DEFINE l_rvbs10  LIKE rvbs_file.rvbs10  #No.FUN-850100
   DEFINE l_sql     STRING   #No.FUN-850100
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_qcs091   LIKE qcs_file.qcs091    #FUN-870040
   DEFINE l_qcs38    LIKE qcs_file.qcs38     #FUN-870040
   DEFINE l_qcs41    LIKE qcs_file.qcs41     #FUN-870040
   DEFINE l_qct03    LIKE qct_file.qct03     #MOD-AB0143 add
   DEFINE l_qct04    LIKE qct_file.qct04     #MOD-AB0143 add
   DEFINE l_qct11    LIKE qct_file.qct11     #MOD-AB0143 add
   DEFINE l_qcd07    LIKE qcd_file.qcd07     #MOD-AB0143 add
   DEFINE l_cnt      LIKE type_file.num5     #MOD-AB0143 add
   DEFINE l_rvb90    LIKE rvb_file.rvb90     #FUN-BB0085 add
   #No.TQC-B90119  --Begin
   DEFINE l_qcd05    LIKE qcd_file.qcd05
   DEFINE l_qcd061   LIKE qcd_file.qcd061
   DEFINE l_qcd062   LIKE qcd_file.qcd062
   #No.TQC-B90119  --End
   DEFINE l_rowcount LIKE type_file.num5    #CHI-C70004 add
   DEFINE l_qcs09    LIKE qcs_file.qcs09    #CHI-C70004 add
 
   #若設定與 SPC 整合, 判斷是否已拋轉
   IF g_aza.aza64 NOT matches '[ Nn]' AND 
     ((g_qcs.qcsspc IS NULL ) OR g_qcs.qcsspc NOT matches '[1]'  )
   THEN
     CALL cl_err('','aqc-117',0)
     LET g_success='N'
     RETURN
   END IF
 
   #No.TQC-BB0119  --Begin
   IF g_qcz.qcz01 = 'Y' THEN       #MOD-B20052 add
      ##MOD-AB0143---add---start---
      # LET l_cnt = 0
      # SELECT COUNT(*) INTO l_cnt FROM qcd_file WHERE qcd01 = g_qcs.qcs021
      # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      ##IF l_cnt > 0 AND g_qcz.qcz01 THEN             #MOD-B20052 mark
      # IF l_cnt > 0 AND g_qcz.qcz01 = 'Y' THEN       #MOD-B20052 add
       DECLARE qct03_curs CURSOR FOR 
         SELECT qct03,qct04,qct11 FROM qct_file WHERE qct01 = g_qcs.qcs01
                                                  AND qct02 = g_qcs.qcs02      #MOD-B20010 add 
                                                  AND qct021 = g_qcs.qcs05     #MOD-B20010 add   
       FOREACH qct03_curs INTO l_qct03,l_qct04,l_qct11
           CALL t110_get_qcd07(l_qct04) RETURNING l_qcd07,l_qcd05,l_qcd061,l_qcd062
           #SELECT qcd07 INTO l_qcd07 FROM qcd_file WHERE qcd01 = g_qcs.qcs021 AND qcd02 = l_qct04
           IF l_qcd07 = 'Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM qctt_file
               WHERE qctt01 = g_qcs.qcs01
                 AND qctt02 = g_qcs.qcs02
                 AND qctt021 = g_qcs.qcs05
                 AND qctt03 = l_qct03 
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
             #CHI-C70004 str add-----
              SELECT qcs09 INTO l_qcs09 FROM qcs_file
               WHERE qcs01 = g_qcs.qcs01
                 AND qcs02 = g_qcs.qcs02
                 AND qcs05 = g_qcs.qcs05
             #CHI-C70004 end add-----
              IF l_cnt != l_qct11 AND NOT (l_qcs09 =2 AND l_cnt=0) THEN          #CHI-C70004 add NOT (l_qcs09 =2 AND l_cnt=0)
                 LET g_msg = l_qct04,':',l_cnt,': ',l_qct11
                 CALL cl_err(g_msg,'aqc-038',1)
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF
       END FOREACH
   END IF
   #MOD-AB0143---add---end---
   #No.TQC-BB0119  --End

   #DEV-D40015 add str-------------
   #自動產生barcode
   IF g_success = 'Y' AND g_aza.aza131 = 'Y' THEN
      CALL t110_barcode_gen(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,'N')
   END IF
   #DEV-D40015 add end-------------

 
   IF (g_argv5 <> "SPC_ins" AND g_argv5 <> "SPC_upd") OR g_argv5 IS NULL THEN
      BEGIN WORK
   END IF
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05    #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      LET g_success='N'
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      LET g_success='N'
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
#CHI-C30107 ---------------- mark --------------- begin
#  IF g_action_choice CLIPPED = "confirm" THEN
#    IF NOT cl_confirm('axm-108') THEN
#       LET g_success='N'
#       ROLLBACK WORK   #No.MOD-850116
#       RETURN
#    END IF
#  END IF
#CHI-C30107 ---------------- mark --------------- end
 
   UPDATE qcs_file SET qcs14 = 'Y',
                       qcs15 = g_today
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
   END IF

   IF g_qcs.qcs09 = '2' OR g_qcs.qcs09 = '3' THEN      #MOD-C30557    #FUN-CC0015 add qcs09=3
      CALL t110_qc()                                   #MOD-C30557
   END IF                                              #MOD-C30557
 
   IF (g_qcs.qcs00='7') AND (g_success='Y') THEN
      CALL t110_upd_srg10("+")
   END IF
   IF g_qcz.qcz12 = 'Y' THEN
      CALL t110_check_pmh09()
   END IF
 
   #------ 是否與採購勾稽(modi in 01/06/04) ------
   IF g_sma.sma886[8,8] = 'Y' AND g_qcs.qcs00 = '1' THEN
      UPDATE rvb_file SET rvb40 = g_qcs.qcs04   #No.MOD-590083
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd rvb40",1)  #No.FUN-660115
         LET g_success = 'N'
      END IF
 
      CASE g_qcs.qcs09
         WHEN '1'
            CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2'
            CALL cl_getmsg('apm-244',g_lang) RETURNING des1        #No:7706
         WHEN '3'
            CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
      END CASE
 
      UPDATE rvb_file SET rvb41 = des1 #檢驗結果
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd rvb41",1)  #No.FUN-660115
         LET g_success='N'
      END IF
 
      SELECT rvb33,rvb07,rvb331,rvb332 ,rvb30              #FUN-5C0022 add rvb331  ,rvb332    #MOD-640512 add rvb30
          INTO l_rvb33,l_rvb07,l_rvb331,l_rvb332,l_rvb30   #FUN-5C0022 add rvb331  ,rvb332   #MOD-640512 add rvb30
        FROM rvb_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF cl_null(l_rvb33) THEN
         LET l_rvb33 = 0
      END IF
 
      IF cl_null(l_rvb331) THEN  #FUN-5C0022 add
         LET l_rvb331 = 0
      END IF
 
      IF cl_null(l_rvb332) THEN  #FUN-5C0022 add
         LET l_rvb332 = 0
      END IF
 
      IF cl_null(l_rvb07) THEN
         LET l_rvb07 = 0
      END IF
 
      LET l_rvb33 = l_rvb33 + g_qcs.qcs091
      IF g_sma.sma115 = 'Y' THEN #使用雙單位
         LET l_rvb331 = l_rvb331 + g_qcs.qcs38
         LET l_rvb332 = l_rvb332 + g_qcs.qcs41
      ELSE
         LET l_rvb331 = l_rvb331 + 0
         LET l_rvb332 = l_rvb332 + 0
      END IF
 
      #FUN-BB0085-add-str---
      SELECT rvb90 INTO l_rvb90 FROM rvb_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      LET l_rvb33 = s_digqty(l_rvb33,l_rvb90)   
      #FUN-BB0085-add-end---
      UPDATE rvb_file SET rvb33 = l_rvb33,
             rvb331 = l_rvb331, #FUN-5C0022 add
             rvb332 = l_rvb332, #FUN-5C0022 add
             rvb31 = l_rvb33 - l_rvb30   #MOD-640512
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd rvb33",1)  #No.FUN-660115
         LET g_success='N'
      END IF
   END IF
 
   IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
      IF g_qcs.qcs00 MATCHES '[1BC]' THEN
         LET l_rvbs09 = 1  
      ELSE
         LET l_rvbs09 = -1  
      END IF
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = g_qcs.qcs021
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
                      
            LET l_sql = "SELECT * FROM rvbs_file",
                        " WHERE rvbs01 = '",g_qcs.qcs01,"'",
                        "   AND rvbs02 = ",g_qcs.qcs02,
                        "   AND rvbs13 = 0 ",   #No.FUN-860045
                        "   AND rvbs00 != '",g_prog,"'",
                        "   AND rvbs09 = ",l_rvbs09
            
            PREPARE t110_rvbssel FROM l_sql
            
            DECLARE rvbs_curssel CURSOR FOR t110_rvbssel
            
            FOREACH rvbs_curssel INTO l_rvbs.*
               IF STATUS THEN
                  CALL cl_err('foreach rvbs sel:',STATUS,1)
                  EXIT FOREACH
               END IF
            
               SELECT SUM(rvbs10)
                 INTO l_rvbs10
                 FROM qcs_file,rvbs_file 
                WHERE qcs01 = g_qcs.qcs01
                  AND qcs02 = g_qcs.qcs02
                  AND qcs01 = rvbs01
                  AND qcs02 = rvbs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs00 = g_prog
                  AND rvbs13 = qcs05                        #No.MOD-950114 add
                  AND qcs14 = 'Y'
               
               UPDATE rvbs_file SET rvbs10 = l_rvbs10
                WHERE rvbs01 = g_qcs.qcs01
                  AND rvbs02 = g_qcs.qcs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs13 = 0   #No.FUN-860045
               
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                  LET g_success = 'N'
               END IF
               #-----CHI-A70047---------
               IF g_qcs.qcs00 = 'A' OR  
                  g_qcs.qcs00 = 'B' THEN
                  UPDATE rvbs_file SET rvbs06 = l_rvbs10
                   WHERE rvbs01 = g_qcs.qcs01
                     AND rvbs02 = g_qcs.qcs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs13 = 0   #No:FUN-860045
                  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                     LET g_success = 'N'
                  END IF
               END IF
               #-----END CHI-A70047-----
            END FOREACH
         END IF
      END IF
   END IF
 
   IF g_qcs.qcs00 = 'A' OR  
      g_qcs.qcs00 = 'B' THEN
      SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)
        INTO l_qcs091,l_qcs38,l_qcs41
        FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND (qcs09='1' OR qcs09='3')
         AND qcs14 = 'Y'   #No.MOD-970026
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
      IF cl_null(l_qcs38 ) THEN LET l_qcs38 =0 END IF
      IF cl_null(l_qcs41 ) THEN LET l_qcs41 =0 END IF
      UPDATE inb_file 
         SET inb09 = l_qcs091,
             inb904= l_qcs38 ,
             inb907= l_qcs41 
       WHERE inb01 = g_qcs.qcs01
         AND inb03 = g_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","inb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd inb09",1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qcs.qcs14 = 'Y'
      LET g_qcs.qcs15 = g_today
      IF (g_argv5 <> "SPC_ins" AND g_argv5 <> "SPC_upd")      #FUN-680011
      OR g_argv5 IS NULL 
      THEN
         COMMIT WORK
      END IF
      DISPLAY BY NAME g_qcs.qcs14,g_qcs.qcs15
      CALL t110_qc_item_show()               #MOD-C30557
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF

   #DEV-D40015 add str-------------
   #失敗自動作廢barcode
   IF g_success = 'N' AND g_aza.aza131 = 'Y' THEN
      CALL t110_barcode_z(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,FALSE)
   END IF
   #DEV-D40015 add end-------------

  #DEV-D40015 mark str------
  ##DEV-D30045--add--begin
  ##自動產生barcode
  #IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
  #   CALL t110_barcode_gen(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,'N')
  #END IF
  ##DEV-D30045--add--end
  #DEV-D40015 mark end------

END FUNCTION

#MOD-C30557----add----str----
FUNCTION t110_qc()
DEFINE l_sum_qco11     LIKE type_file.num10,
       l_sum_qco15     LIKE type_file.num10,
       l_sum_qco18     LIKE type_file.num10,
       l_qco13         LIKE qco_file.qco13,
       l_qco15         LIKE qco_file.qco15,
       l_qco16         LIKE qco_file.qco16,
       l_qco18         LIKE qco_file.qco18,
       l_factor        LIKE type_file.num10,
       l_flag          LIKE type_file.chr1,
       l_sql           STRING,
       l_n             LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
   IF l_n = 0 THEN RETURN END IF

   SELECT SUM(qco11*qco19) INTO l_sum_qco11
     FROM qco_file,qcl_file
    WHERE qco01 = g_qcs.qcs01
      AND qco02 = g_qcs.qcs02
      AND qco05 = g_qcs.qcs05
      AND qco03 = qcl01
     #AND qcl05 <> '3'      #FUN-CC0013 mark
   IF cl_null(l_sum_qco11) THEN LET l_sum_qco11 = 0 END IF
   IF l_sum_qco11 = 0 THEN RETURN END IF
   LET l_sql = "SELECT qco13,qco15,qco16,qco18 ",
               "  FROM qco_file,qcl_file       ",
               " WHERE qco03 = qcl01           ",
               "   AND qco01 = '",g_qcs.qcs01,"' ",
               "   AND qco02 = '",g_qcs.qcs02,"' ",
               "   AND qco05 = '",g_qcs.qcs05,"' "     #FUN-CC0013 mark ,
              #"   AND qcl05 <> '3' "                  #FUN-CC0013 mark
   PREPARE qco_pre FROM l_sql
   DECLARE qco_cur CURSOR FOR qco_pre
   FOREACH qco_cur INTO l_qco13,l_qco15,l_qco16,l_qco18
      CALL s_umfchk(g_qcs.qcs021,l_qco13,g_qcs.qcs30) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco15 = l_qco15 * l_factor
      LET l_qco15 = s_digqty(l_qco15,g_qcs.qcs30)

      CALL s_umfchk(g_qcs.qcs021,l_qco16,g_qcs.qcs33) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco18 = l_qco18 * l_factor
      LET l_qco18 = s_digqty(l_qco18,g_qcs.qcs33)

      LET l_sum_qco15 = l_sum_qco15 + l_qco15
      LET l_sum_qco18 = l_sum_qco18 + l_qco18
   END FOREACH

   UPDATE qcs_file
      SET qcs09  = '1',
          qcs091 = l_sum_qco11,
          qcs38  = l_sum_qco15,
          qcs41  = l_sum_qco18
    WHERE qcs01  = g_qcs.qcs01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
   END IF

END FUNCTION
#MOD-C30557----add----end----
 
FUNCTION t110_z()
   DEFINE l_rvb331  LIKE rvb_file.rvb331
   DEFINE l_rvb332  LIKE rvb_file.rvb332
   DEFINE l_flag    LIKE type_file.num5         #No.FUN-680104 SMALLINT
   DEFINE l_factor  LIKE qcs_file.qcs31
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_rvb33   LIKE rvb_file.rvb33
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_rvb30   LIKE rvb_file.rvb30  #MOD-640512
   DEFINE l_qcs091   LIKE qcs_file.qcs091    #No.MOD-970026
   DEFINE l_qcs38    LIKE qcs_file.qcs38     #No.MOD-970026
   DEFINE l_qcs41    LIKE qcs_file.qcs41     #No.MOD-970026
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09    #CHI-A70047
   DEFINE l_sql      STRING                   #CHI-A70047
   DEFINE l_rvbs     RECORD LIKE rvbs_file.*  #CHI-A70047
   DEFINE l_rvbs10   LIKE rvbs_file.rvbs10    #CHI-A70047
   DEFINE l_ogaconf  LIKE oga_file.ogaconf     #TQC-BC0206
   DEFINE l_ogapost  LIKE oga_file.ogapost     #TQC-C30125
#  DEFINE l_inb16    LIKE inb_file.inb16      #MOD-C30202
#  DEFINE l_inb924   LIKE inb_file.inb924     #MOD-C30202
#  DEFINE l_inb927   LIKE inb_file.inb927     #MOD-C30202
   DEFINE l_rvv17    LIKE rvv_file.rvv17      #MOD-C30846 add
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcs14 = 'N' THEN
      RETURN
   END IF
 
   IF g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_qcs.qcs09 = '3' THEN   #BugNo:5046
      CALL cl_err(g_qcs.qcs01,'aqc-410',0)
      RETURN
   END IF

#TQC-C30125 --begin--
##TQC-BC0206 --begin--
#   SELECT ogaconf INTO l_ogaconf FROM oga_file
#    WHERE oga01 = g_qcs.qcs01
#   IF l_ogaconf = 'Y' THEN
#      CALL cl_err('','axm-908',1)
#      RETURN
#   END IF
##TQC-BC0206 --end--

   SELECT ogapost INTO l_ogapost FROM oga_file
    WHERE oga01 = g_qcs.qcs01
   IF l_ogapost = 'Y' THEN
      CALL cl_err('','axm-435',1)
      RETURN
   END IF
#TQC-C30125 --end--
   
   #MOD-C30560----add----str----
   IF g_qcs.qcs00 MATCHES '[2Z]' THEN 
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM inb_file
       WHERE inb44 = g_qcs.qcs01
         AND inb45 = g_qcs.qcs02
         AND inb48 = g_qcs.qcs05
      IF l_cnt > 0 THEN 
         CALL cl_err(g_qcs.qcs01,'aqc-542',0)
         RETURN
      END IF
   END IF
   #MOD-C30560----add----end----


   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05  #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   IF g_qcs.qcs00 MATCHES '[12]' THEN
     #總IQC驗退量不可小于收貨驗退量
      IF g_qcs.qcs09 = '2' THEN
         CALL t110_qc_return() RETURNING l_flag
         IF l_flag = FALSE THEN
            ROLLBACK WORK 
            RETURN
         END IF
      END IF
      #IF g_qcs.qcs00 = '1' THEN        #MOD-AC0025 add           #MOD-B80352 mark
      IF g_qcs.qcs00 = '1' AND g_sma.sma886[8,8]='Y' THEN         #MOD-B80352 add 
         SELECT rvb30,rvb33 INTO l_rvb30,l_rvb33
           FROM rvb_file
          WHERE rvb01 = g_qcs.qcs01
            AND rvb02 = g_qcs.qcs02
        #MOD-C30846 str add------
         SELECT SUM(rvv17) INTO l_rvv17
           FROM rvv_file
           LEFT OUTER JOIN rvu_file ON rvv01 =rvu01
          WHERE rvu02 = g_qcs.qcs01
            AND rvv05 = g_qcs.qcs02
            AND rvv03 = '1'
            AND rvuconf <> 'X'
        #MOD-C30846 end add------
        #IF l_rvb30 > (l_rvb33 - g_qcs.qcs091) THEN   #No.MOD-890283   #MOD-C30846 mark
         IF l_rvv17 > (l_rvb33 - g_qcs.qcs091) THEN                    #MOD-C30846 add
            CALL cl_err(g_qcs.qcs01,'aqc-019',1)
            ROLLBACK WORK 
            RETURN
         END IF
      END IF                #MOD-AC0025 add
   END IF
   IF g_qcs.qcs00 MATCHES '[56]' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM oga_file,ogb_file
       WHERE ogb01 = g_qcs.qcs01
         AND ogb03 = g_qcs.qcs02
         AND oga01 = ogb01
         AND ogapost = 'Y'
      IF g_cnt > 0 THEN
         CALL cl_err(g_qcs.qcs01,'aqc-119',0)
         ROLLBACK WORK    
         RETURN
      END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[A]' THEN 
      SELECT COUNT(*) INTO g_cnt
        FROM ina_file,inb_file
        WHERE inb01 = g_qcs.qcs01
          AND inb03 = g_qcs.qcs02
          AND inb01 = ina01
          AND inapost = 'Y'
          AND ina00 MATCHES '[12]'
       IF g_cnt > 0 THEN 
          CALL cl_err(g_qcs.qcs01,'aqc-072',0)
          ROLLBACK WORK   
          RETURN
       END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[B]' THEN 
      SELECT COUNT(*) INTO g_cnt
        FROM ina_file,inb_file
        WHERE inb01 = g_qcs.qcs01
          AND inb03 = g_qcs.qcs02
          AND inb01 = ina01
          AND inapost = 'Y'
          AND ina00 IN ('3','4')
       IF g_cnt > 0 THEN 
          CALL cl_err(g_qcs.qcs01,'aqc-071',0)
          ROLLBACK WORK   
          RETURN
       END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[CD]' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM imm_file,imn_file
       WHERE imn01 = g_qcs.qcs01
         AND imn02 = g_qcs.qcs02
         AND imn01 = imm01
         AND imm03 = 'Y'
      IF g_cnt > 0 THEN
         CALL cl_err(g_qcs.qcs01,'aqc-013',0)
         ROLLBACK WORK    
         RETURN
      END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[E]' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM imp_file,imo_file
       WHERE imp01 = g_qcs.qcs01
         AND imp02 = g_qcs.qcs02
         AND imo01 = imp01
         AND imopost = 'Y'
      IF g_cnt > 0 THEN
         CALL cl_err(g_qcs.qcs01,'aqc-013',0)
         ROLLBACK WORK    
         RETURN
      END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[F]' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM imr_file,imq_file
       WHERE imq01 = g_qcs.qcs01
         AND imq02 = g_qcs.qcs02
         AND imr01 = imq01
         AND imrpost = 'Y'
      IF g_cnt > 0 THEN
         CALL cl_err(g_qcs.qcs01,'aqc-013',0)
         ROLLBACK WORK    
         RETURN
      END IF
   END IF
   IF g_qcs.qcs00 MATCHES '[H]' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM ohb_file,oha_file
       WHERE ohb01 = g_qcs.qcs01
         AND ohb03 = g_qcs.qcs02
         AND oha01 = ohb01
         AND ohapost = 'Y'
      IF g_cnt > 0 THEN
         CALL cl_err(g_qcs.qcs01,'aqc-013',0)
         ROLLBACK WORK    
         RETURN
      END IF
   END IF
 
   UPDATE qcs_file SET qcs14 = 'N',
                   #    qcs15 = ''       #CHI-C80072
                       qcs15 = g_today   #CHI-C80072
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
   END IF
   IF (g_qcs.qcs00='7') AND (g_success='Y') THEN
      CALL t110_upd_srg10("-")
   END IF
   IF g_qcz.qcz12 = 'Y' THEN
      CALL t110_check_pmh09()
   END IF
 
   #------ 是否與採購勾稽(modi in 01/06/04) ------
   IF g_sma.sma886[8,8] = 'Y' AND g_qcs.qcs00 = '1' THEN
      #bugno:5964 add check........
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND qcs05 != g_qcs.qcs05
         AND qcs14 = 'Y'
 
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
 
      IF l_cnt = 0 THEN
         UPDATE rvb_file SET rvb40 = NULL,
                             rvb41 = NULL
          WHERE rvb01 = g_qcs.qcs01
            AND rvb02 = g_qcs.qcs02
 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd rvb40",1)  #No.FUN-660115
            LET g_success = 'N'
         END IF
      END IF
 
      SELECT rvb33,rvb331,rvb332,rvb30             #FUN-5C0022 add rvb331,rvb332    #MOD-640512 add rvb30
        INTO l_rvb33,l_rvb331,l_rvb332,l_rvb30    #FUN-5C0022 add rvb331,rvb332    #MOD-640512 add rvb30
        FROM rvb_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF cl_null(l_rvb33) THEN
         LET l_rvb33 = 0
      END IF
 
      IF g_sma.sma115 = 'Y' THEN #使用雙單位
         LET l_rvb331 = l_rvb331 - g_qcs.qcs38
         LET l_rvb332 = l_rvb332 - g_qcs.qcs41
      ELSE
         LET l_rvb331 = l_rvb331 - 0
         LET l_rvb332 = l_rvb332 - 0
      END IF
 
      UPDATE rvb_file SET rvb33 = l_rvb33 - g_qcs.qcs091,
                         rvb331 = l_rvb331, #FUN-5C0022 add
                         rvb332 = l_rvb332  #FUN-5C0022 add
                         ,rvb31 = (l_rvb33-g_qcs.qcs091)-l_rvb30   #MOD-640512 #MOD-880166
                        #,rvb31 = l_rvb33-l_rvb30   #MOD-640512  #MOD-880166 mark
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd rvb33",1)  #No.FUN-660115
         LET g_success='N'
      END IF
 
   END IF
   #-----CHI-A70047---------
   IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
      IF g_qcs.qcs00 MATCHES '[1BC]' THEN
         LET l_rvbs09 = 1  
      ELSE
         LET l_rvbs09 = -1  
      END IF
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = g_qcs.qcs021
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN  
                      
            LET l_sql = "SELECT * FROM rvbs_file",
                        " WHERE rvbs01 = '",g_qcs.qcs01,"'",
                        "   AND rvbs02 = ",g_qcs.qcs02,
                        "   AND rvbs13 = 0 ", 
                        "   AND rvbs00 != '",g_prog,"'",
                        "   AND rvbs09 = ",l_rvbs09
            
            PREPARE t110_rvbssel_2 FROM l_sql
            
            DECLARE rvbs_curssel_2 CURSOR FOR t110_rvbssel_2
            
            FOREACH rvbs_curssel_2 INTO l_rvbs.*
               IF STATUS THEN
                  CALL cl_err('foreach rvbs sel:',STATUS,1)
                  EXIT FOREACH
               END IF
            
               SELECT SUM(rvbs10)
                 INTO l_rvbs10
                 FROM qcs_file,rvbs_file 
                WHERE qcs01 = g_qcs.qcs01
                  AND qcs02 = g_qcs.qcs02
                  AND qcs01 = rvbs01
                  AND qcs02 = rvbs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs00 = g_prog
                  AND rvbs13 = qcs05   
                  AND qcs14 = 'Y'

               IF cl_null(l_rvbs10) THEN
                  LET l_rvbs10 = 0 
               END IF
               
               UPDATE rvbs_file SET rvbs10 = l_rvbs10
                WHERE rvbs01 = g_qcs.qcs01
                  AND rvbs02 = g_qcs.qcs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs13 = 0   
               
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                  LET g_success = 'N'
               END IF
               IF g_qcs.qcs00 = 'A' OR  
                  g_qcs.qcs00 = 'B' THEN
                  UPDATE rvbs_file SET rvbs06 = l_rvbs10
                   WHERE rvbs01 = g_qcs.qcs01
                     AND rvbs02 = g_qcs.qcs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs13 = 0   
                  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                     LET g_success = 'N'
                  END IF
                  END IF
            END FOREACH
         END IF
      END IF
   END IF
   #-----END CHI-A70047-----
 
   IF g_qcs.qcs00 = 'A' OR  
      g_qcs.qcs00 = 'B' THEN
      SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)
        INTO l_qcs091,l_qcs38,l_qcs41
        FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND (qcs09='1' OR qcs09='3')
         AND qcs14 = 'Y'
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
      IF cl_null(l_qcs38 ) THEN LET l_qcs38 =0 END IF
      IF cl_null(l_qcs41 ) THEN LET l_qcs41 =0 END IF
#    #MOD-C30202 ----------Begin---------
#      IF l_qcs091 = 0 THEN
#         SELECT inb16,inb924,inb927 INTO l_inb16,l_inb924,l_inb927 FROM inb_file
#          WHERE inb01 = g_qcs.qcs01
#            AND inb03 = g_qcs.qcs02
#         IF cl_null(l_inb16) THEN LET l_inb16 = 0 END IF
#         IF cl_null(l_inb924) THEN LET l_inb924 = 0 END IF
#         IF cl_null(l_inb927) THEN LET l_inb927 = 0 END IF
#         UPDATE inb_file
#            SET inb09 = l_inb16,
#                inb904= l_inb924,
#                inb907= l_inb927
#          WHERE inb01 = g_qcs.qcs01
#            AND inb03 = g_qcs.qcs02
#      ELSE
#    #MOD-C30202 ----------End-----------
      UPDATE inb_file 
         SET inb09 = l_qcs091,
             inb904= l_qcs38 ,
             inb907= l_qcs41 
       WHERE inb01 = g_qcs.qcs01
         AND inb03 = g_qcs.qcs02
#  END IF       #MOD-C30202

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","inb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd inb09",1)
         LET g_success = 'N'
      END IF
   END IF

   #DEV-D40015--add--begin
   #自動作廢barcode
   IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
      CALL t110_barcode_z(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,TRUE)
   END IF
   #DEV-D40015--add--end
 
   IF g_success = 'Y' THEN
      LET g_qcs.qcs14 = 'N'
      #LET g_qcs.qcs15 = ''      #CHI-C80072
      LET g_qcs.qcs15 = g_today  #CHI-C80072
      COMMIT WORK
      DISPLAY BY NAME g_qcs.qcs14,g_qcs.qcs15
   ELSE
      ROLLBACK WORK
   END IF

   #DEV-D40015--mark--begin
   ##DEV-D30045--add--begin
   ##自動作廢barcode
   #IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
   #   CALL t110_barcode_z(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05)
   #END IF
   ##DEV-D30045--add--end
   #DEV-D40015--mark--end
 
END FUNCTION
 
#FUNCTION t110_x()                                    #CHI-D20010
FUNCTION t110_x(p_type)                               #CHI-D20010
   DEFINE l_ogaconf          LIKE oga_file.ogaconf    #TQC-BC0206
   DEFINE l_ogapost          LIKE oga_file.ogapost    #TQC-C30125
   DEFINE p_type    LIKE type_file.chr1               #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1               #CHI-D20010


   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02  #MOD-470517
      AND qcs05 = g_qcs.qcs05
 
   IF cl_null(g_qcs.qcs01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #-->確認不可作廢
   IF g_qcs.qcs14 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
 
   IF g_qcs.qcsspc matches '[1]'                #判斷是否已拋轉
   THEN
     CALL cl_err('','aqc-116',0)
     RETURN
   END IF

#TQC-C30125 --begin--
##TQC-BC0206 --begin--
#   SELECT ogaconf INTO l_ogaconf FROM oga_file
#    WHERE oga01 = g_qcs.qcs01
#   IF l_ogaconf = 'Y' THEN
#      CALL cl_err('','axm-908',1)
#      RETURN
#   END IF
##TQC-BC0206 --end--

   SELECT ogaconf,ogapost INTO l_ogaconf,l_ogapost FROM oga_file
    WHERE oga01 = g_qcs.qcs01
   IF l_ogapost = 'Y' THEN
      CALL cl_err('','axm-435',1)
      RETURN
   END IF
   IF l_ogaconf = 'N' AND g_qcs.qcs14 = 'X' THEN
      CALL cl_err('','axm-436',1)
      RETURN
   END IF
#TQC-C30125 --end--

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_qcs.qcs14='X' THEN RETURN END IF
   ELSE
      IF g_qcs.qcs14<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

 
   BEGIN WORK
 
   LET g_success = 'Y'
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #IF cl_void(0,0,g_qcs.qcs14)   THEN                                 #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
      LET g_chr = g_qcs.qcs14                                          #CHI-D20010
     #IF g_qcs.qcs14 = 'N' THEN         
     IF p_type = 1 THEN                                                #CHI-D20010
         LET g_qcs.qcs14 = 'X'
      ELSE
         LET g_qcs.qcs14 = 'N'
      END IF
 
      UPDATE qcs_file SET qcs14 = g_qcs.qcs14,
                          qcs15 = g_today,
                          qcsmodu = g_user,
                          qcsdate = g_today
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02  #No:9489
         AND qcs05 = g_qcs.qcs05  #No:9489
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
         LET g_qcs.qcs14 = g_chr
         ROLLBACK WORK
         RETURN
      END IF
 
      SELECT qcs14,qcs15
        INTO g_qcs.qcs14,g_qcs.qcs15
        FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND qcs05 = g_qcs.qcs05
      DISPLAY BY NAME g_qcs.qcs14,g_qcs.qcs15
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t110_g_b()
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_yn      LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_qcd     RECORD LIKE qcd_file.*
   DEFINE seq       LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_flag    LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
   DEFINE l_ecm04   LIKE ecm_file.ecm04    #No.FUN-680104 VARCHAR(6)
   DEFINE l_ac_num,l_re_num  LIKE type_file.num5         #No.FUN-680104 SMALLINT
   DEFINE l_qct11   LIKE qct_file.qct11
   DEFINE l_sql     STRING       #No.FUN-910079
   DEFINE l_qcs021  LIKE qcs_file.qcs021   #No.FUN-990071
#No.FUN-A80063 --begin
   DEFINE l_qdf02   LIKE qdf_file.qdf02
   DEFINE l_qct14   LIKE qct_file.qct14
   DEFINE l_qct15   LIKE qct_file.qct15
#No.FUN-A80063 --end 
   LET seq = 1
 
   SELECT COUNT(*) INTO l_cnt FROM qct_file
    WHERE qct01 = g_qcs.qcs01
      AND qct02 = g_qcs.qcs02
      AND qct021 = g_qcs.qcs05

  #FUN-C30149 add START
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
   IF g_flag = 'Y' THEN
      SELECT MAX(qct03) INTO seq FROM qct_file
       WHERE qct01 = g_qcs.qcs01
         AND qct02 = g_qcs.qcs02
         AND qct021 = g_qcs.qcs05
      IF cl_null(seq) OR seq = 0 THEN
         LET seq = 1
      ELSE
         LET seq = seq + 1
      END IF
   END IF
  #FUN-C30149 add END
 
  #若user 單身點選單身資料重新產生,則不論是否存在單身資料,皆要進入重新產生資料,只新增被user刪除的資料
  #IF l_cnt = 0 THEN               #--單身重新產生   #FUN-C30149 mark
   IF l_cnt = 0 OR g_flag = 'Y' THEN               #--單身重新產生   #FUN-C30149 add
      LET l_flag = ' '
      IF g_argv1 = "1" THEN
         SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
           FROM qcc_file,ecm_file,rvb_file,pmn_file
          WHERE rvb01 = g_qcs.qcs01
            AND rvb02 = g_qcs.qcs02
            AND rvb04 = pmn01
            AND rvb03 = pmn02
            AND pmn41 = ecm01
            AND pmn46 = ecm03
            AND qcc01 = g_qcs.qcs021
            AND qcc011 = ecm04
            AND qcc08 IN ('1','9')     #No.FUN-910079
            AND ecm012 = pmn012         #FUN-A60076 add
          GROUP BY ecm04
          IF cl_null(l_yn) OR l_yn<=0 THEN
             SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
               FROM qcc_file,ecm_file,rvb_file,pmn_file
              WHERE rvb01 = g_qcs.qcs01
                AND rvb02 = g_qcs.qcs02
                AND rvb04 = pmn01
                AND rvb03 = pmn02
                AND pmn41 = ecm01
                AND pmn46 = ecm03
                AND qcc01 = '*'
                AND qcc011 = ecm04
                AND qcc08 IN ('1','9')
                AND ecm012 = pmn012         #FUN-A60076 add
              GROUP BY ecm04
              IF cl_null(l_yn) OR l_yn<=0 THEN
             SELECT sgm04,COUNT(*) INTO l_ecm04,l_yn 
               FROM qcc_file,sgm_file,rvb_file,pmn_file
              WHERE rvb01=g_qcs.qcs01 
                AND rvb02=g_qcs.qcs02
                AND rvb04=pmn01 
                AND rvb03=pmn02
                AND pmn41=sgm02 
                AND pmn32=sgm03
                AND sgm012 = pmn012     #FUN-A60076 add by vealxu  
                AND qcc01=g_qcs.qcs021 
                AND qcc011=sgm04 
                AND qcc08 IN ('1','9')     #No.FUN-910079
                GROUP BY sgm04
             END IF
          END IF                               #No.FUN-990071
      ELSE
         LET l_yn = 0
      END IF
 
      IF l_yn > 0 THEN
         LET l_flag = '1'          #--製程委外抓站別檢驗項目
      ELSE
         LET l_sql = " SELECT COUNT(*) FROM qcd_file ",
                     " WHERE qcd01 = ? "
         CASE g_argv1 
            WHEN '1' 
                 LET l_sql = l_sql CLIPPED, " AND qcd08 in ('1','9') " 
            WHEN '2' 
                 LET l_sql = l_sql CLIPPED, " AND qcd08 in ('5','9') "
            WHEN '3' 
                 LET l_sql = l_sql CLIPPED, " AND qcd08 in ('4','9') "
            WHEN '4' 
                 LET l_sql = l_sql CLIPPED, " AND qcd08 in ('2','9') " 
         END CASE                                    
         PREPARE qcd_sel FROM l_sql 
         EXECUTE qcd_sel USING g_qcs.qcs021 INTO l_yn           
         IF l_yn > 0 THEN          #--- 料件檢驗項目
            LET l_flag = '2'
         ELSE
            LET l_flag = '3'       #--- 材料類別檢驗項目
         END IF
      END IF
 
      CASE l_flag
         WHEN '1'
         
            LET l_sql = "  SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062, ",
                        "  qccacti,qccuser,qccgrup,qccmodu,qccdate ",
                        "  FROM qcc_file ",
                        "  WHERE qcc01 = ? ",
                        "  AND qcc011 = ? "
            CASE g_argv1 
              WHEN "1" 
                   LET l_sql = l_sql CLIPPED, "  AND qcc08 IN ('1','9') ",                
                               "   ORDER BY qcc02"
              WHEN "2"
                   LET l_sql = l_sql CLIPPED, "  AND qcc08 IN ('5','9') ",                 
                               "   ORDER BY qcc02"   
              WHEN "3"
                   LET l_sql = l_sql CLIPPED, "  AND qcc08 IN ('4','9') ",                 
                               "   ORDER BY qcc02" 
              WHEN "4"
                   LET l_sql = l_sql CLIPPED, "  AND qcc08 IN ('2','9') ",                 
                               "   ORDER BY qcc02"  
            END CASE                                                                       
            
            PREPARE qcc_cur1 FROM l_sql                     
            DECLARE qcc_cur CURSOR FOR qcc_cur1 
            DECLARE qcc_cur2 SCROLL CURSOR FOR qcc_cur1
            OPEN qcc_cur2 USING g_qcs.qcs021,l_ecm04
            FETCH FIRST qcc_cur2 INTO l_qcd.*
            IF SQLCA.sqlcode = 100 THEN
               LET l_qcs021 = '*'
            ELSE
               LET l_qcs021 = g_qcs.qcs021
            END IF
 
            FOREACH qcc_cur USING l_qcs021,l_ecm04 INTO l_qcd.*       #No.FUN-990071
#No.FUN-A80063 --begin
#               IF l_qcd.qcd05='1' THEN
# 
#                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
#                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
#                          RETURNING l_ac_num,l_re_num
#                  ELSE
#                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)   #MOD-890223 add g_type,g_ecm04
#                          RETURNING l_ac_num,l_re_num
#                  END IF
#                  CALL t110_defqty(2,l_qcd.qcd04) RETURNING l_qct11
#               ELSE
#                  LET l_ac_num = 0
#                  LET l_re_num = 1
#                  SELECT qcj05 INTO l_qct11
#                    FROM qcj_file
#                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
#                     AND qcj03 = l_qcd.qcd04
#                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
#                  IF STATUS THEN
#                     LET l_qct11 = 0
#                  END IF
#                  IF g_qcs22 = 1 THEN
#                     LET l_qct11 = 1
#                  END IF
#               END IF


               CASE l_qcd.qcd05
                 WHEN '1'   #一般 
                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
                          RETURNING l_ac_num,l_re_num
                  ELSE
                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)   #MOD-890223 add g_type,g_ecm04
                          RETURNING l_ac_num,l_re_num
                  END IF
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '2'  #特殊
                  LET l_ac_num = 0
                  LET l_re_num = 1
                  SELECT qcj05 INTO l_qct11
                    FROM qcj_file
                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                     AND qcj03 = l_qcd.qcd04
                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
                  IF STATUS THEN
                     LET l_qct11 = 0
                  END IF
                  IF g_qcs22 = 1 THEN
                     LET l_qct11 = 1
                  END IF
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '3'   #1916 计数
                  LET l_ac_num =0
                  LET l_re_num =1
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '4'   #1916 计量
                  LET l_ac_num =''
                  LET l_re_num =''
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                  SELECT qdf02 INTO l_qdf02
                    FROM qdf_file
                   WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)
                     AND qdf01 = l_qcd.qcd03
                  SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                    FROM qdg_file
                   WHERE qdg01 = g_ima101
                     AND qdg02 = l_qcd.qcd03
                     AND qdg03 = l_qdf02
                  IF SQLCA.sqlcode THEN 
                     LET l_qct14 =0
                     LET l_qct15 =0
                  END IF
               END CASE  
#No.FUN-A80063 --end 
               IF l_qct11 > g_qcs.qcs22 THEN
                  LET l_qct11 = g_qcs.qcs22
               END IF
 
               IF cl_null(l_qct11) THEN
                  LET l_qct11 = 0
               END IF

              #FUN-C30149 add START
               IF g_flag = 'Y' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM qct_file
                     WHERE qct01 = g_qcs.qcs01 AND qct02 = g_qcs.qcs02
                       AND qct021 = g_qcs.qcs05 AND qct04 = l_qcd.qcd02
                  IF l_cnt > 0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF
              #FUN-C30149 add END
 
               INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,  #No.MOD-470041
                                     qct06,qct07,qct08,qct09,qct10,qct11,
                                     qct12,qct131,qct132,qct14,qct15,       #No.FUN-A80063
                                     qctplant,qctlegal)  #FUN-980007
                  VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,
                         l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                         0,'1',l_ac_num,l_re_num,l_qct11,
                         l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,l_qct14,l_qct15,   #No.FUN-A80063
                         g_plant,g_legal)                #FUN-980007
               LET seq = seq + 1
            END FOREACH
         WHEN '2'
            LET l_sql = "  SELECT * FROM qcd_file",
                        "  WHERE qcd01 = ? "
            CASE g_argv1 
              WHEN "1" 
                   LET l_sql = l_sql CLIPPED, "  AND qcd08 IN ('1','9') ",                
                               "   ORDER BY qcd02"
              WHEN "2"
                   LET l_sql = l_sql CLIPPED, "  AND qcd08 IN ('5','9') ",                 
                               "   ORDER BY qcd02"   
              WHEN "3"
                   LET l_sql = l_sql CLIPPED, "  AND qcd08 IN ('4','9') ",                 
                               "   ORDER BY qcd02" 
              WHEN "4"
                   LET l_sql = l_sql CLIPPED, "  AND qcd08 IN ('2','9') ",                 
                               "   ORDER BY qcd02"  
            END CASE                                                                       
            
            PREPARE qcd_cur1 FROM l_sql                     
            DECLARE qcd_cur CURSOR FOR qcd_cur1 
        
            FOREACH qcd_cur USING g_qcs.qcs021 INTO l_qcd.* 
#No.FUN-A80063--begin
#               IF l_qcd.qcd05 = '1' THEN
# 
#                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
#                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
#                          RETURNING l_ac_num,l_re_num
#                  ELSE
#                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)    #MOD-890223 add g_ecm04,g_type 
#                          RETURNING l_ac_num,l_re_num 
#                  END IF
#                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11     #No.FUN-A80130
#               ELSE
#                  LET l_ac_num = 0
#                  LET l_re_num = 1
#                  SELECT qcj05 INTO l_qct11
#                    FROM qcj_file
#                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
#                     AND qcj03 = l_qcd.qcd04
#                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
#                  IF STATUS THEN
#                     LET l_qct11 = 0
#                  END IF
#                  IF g_qcs22 = 1 THEN
#                     LET l_qct11 = 1
#                  END IF
#               END IF


               CASE l_qcd.qcd05
                 WHEN '1'   #一般 
                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
                          RETURNING l_ac_num,l_re_num
                  ELSE
                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)   #MOD-890223 add g_type,g_ecm04
                          RETURNING l_ac_num,l_re_num
                  END IF
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '2'  #特殊
                  LET l_ac_num = 0
                  LET l_re_num = 1
                  SELECT qcj05 INTO l_qct11
                    FROM qcj_file
                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                     AND qcj03 = l_qcd.qcd04
                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
                  IF STATUS THEN
                     LET l_qct11 = 0
                  END IF
                  IF g_qcs22 = 1 THEN
                     LET l_qct11 = 1
                  END IF
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '3'   #1916 计数
                  LET l_ac_num =0
                  LET l_re_num =1
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11  
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '4'   #1916 计量
                  LET l_ac_num =''
                  LET l_re_num =''
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11  
                  SELECT qdf02 INTO l_qdf02
                    FROM qdf_file
                   WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)
                     AND qdf01 = l_qcd.qcd03  
                  SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                    FROM qdg_file
                   WHERE qdg01 = g_ima101
                     AND qdg02 = l_qcd.qcd03  
                     AND qdg03 = l_qdf02
                  IF SQLCA.sqlcode THEN 
                     LET l_qct14 =0
                     LET l_qct15 =0
                  END IF
               END CASE  
#No.FUN-A80063 --end 
               IF l_qct11 > g_qcs.qcs22 THEN
                  LET l_qct11 = g_qcs.qcs22
               END IF
 
               IF cl_null(l_qct11) THEN
                  LET l_qct11 = 0
               END IF
         
              #FUN-C30149 add START
               IF g_flag = 'Y' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM qct_file
                     WHERE qct01 = g_qcs.qcs01 AND qct02 = g_qcs.qcs02
                       AND qct021 = g_qcs.qcs05 AND qct04 = l_qcd.qcd02
                  IF l_cnt > 0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF
              #FUN-C30149 add END

               INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,  #No.MOD-470041
                                     qct06,qct07,qct08,qct09,qct10,qct11,
                                     qct12,qct131,qct132,qct14,qct15,                               #No.FUN-A80063
                                     qctplant,qctlegal)  #FUN-980007
                              VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,
                                     l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                     0,'1',l_ac_num,l_re_num,l_qct11,
                                     l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,l_qct14,l_qct15,         #No.FUN-A80063
                                     g_plant,g_legal)    #FUN-980007
               LET seq = seq + 1
            END FOREACH
         WHEN '3'      #--- 材料類別檢驗項目
         LET l_sql = " SELECT qck_file.* FROM qck_file,ima_file ",
                     "  WHERE qck01 = ima109 AND ima01 = ?"
            CASE g_argv1 
              WHEN "1" 
                   LET l_sql = l_sql CLIPPED, "  AND qck08 IN ('1','9') ",                
                               "   ORDER BY qck02"
              WHEN "2"
                   LET l_sql = l_sql CLIPPED, "  AND qck08 IN ('5','9') ",                 
                               "   ORDER BY qck02"   
              WHEN "3"
                   LET l_sql = l_sql CLIPPED, "  AND qck08 IN ('4','9') ",                 
                               "   ORDER BY qck02" 
              WHEN "4"
                   LET l_sql = l_sql CLIPPED, "  AND qck08 IN ('2','9') ",                 
                               "   ORDER BY qck02"  
            END CASE 
            PREPARE qck_cur1 FROM l_sql                     
            DECLARE qck_cur CURSOR FOR qck_cur1                     
             FOREACH qck_cur USING g_qcs.qcs021 INTO l_qcd.*
#No.FUN-A80063 --begin
#               IF l_qcd.qcd05 = '1' THEN
# 
#                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
#                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
#                          RETURNING l_ac_num,l_re_num 
#                  ELSE
#                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)  #MOD-890223 g_ecm04,g_type
#                          RETURNING l_ac_num,l_re_num
#                  END IF
#                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11     #No.FUN-A80130
#               ELSE
#                  LET l_ac_num=0 LET l_re_num=1
#                  SELECT qcj05 INTO l_qct11
#                    FROM qcj_file
#                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
#                     AND qcj03=l_qcd.qcd04
#                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
#                  IF STATUS THEN LET l_qct11=0 END IF
#                  IF g_qcs22 = 1 THEN
#                     LET l_qct11 = 1
#                  END IF
#               END IF

               CASE l_qcd.qcd05
                 WHEN '1'   #一般 
                  IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
                     CALL s_newaql_1(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22)
                          RETURNING l_ac_num,l_re_num
                  ELSE
                     CALL s_newaql(g_qcs.qcs021,g_qcs03_t,l_qcd.qcd04,g_qcs.qcs22,g_ecm04,g_type)   #MOD-890223 add g_type,g_ecm04
                          RETURNING l_ac_num,l_re_num
                  END IF
                  CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '2'  #特殊
                  LET l_ac_num = 0
                  LET l_re_num = 1
                  SELECT qcj05 INTO l_qct11
                    FROM qcj_file
                   WHERE (g_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                     AND qcj03 = l_qcd.qcd04
                     AND qcj04 = g_qcs.qcs17    #No.MOD-820049 add
                  IF STATUS THEN
                     LET l_qct11 = 0
                  END IF
                  IF g_qcs22 = 1 THEN
                     LET l_qct11 = 1
                  END IF
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '3'   #1916 计数
                  LET l_ac_num =0
                  LET l_re_num =1
                 #CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11  #MOD-D40046 mark 
                  CALL t110_defqty(2,l_qcd.qcd04,g_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11  #MOD-D40046
                  LET l_qct14 =''
                  LET l_qct15 =''

                 WHEN '4'   #1916 计量
                  LET l_ac_num =''
                  LET l_re_num =''
                 #CALL t110_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11  #MOD-D40046 mark
                  CALL t110_defqty(2,l_qcd.qcd04,g_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11  #MOD-D40046
                  SELECT qdf02 INTO l_qdf02
                    FROM qdf_file
                   WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)
                    #AND qdf01 = l_qcd.qcd03  #MOD-D40046 mark
                     AND qdf01 = g_qcs.qcs17  #MOD-D40046 
                  SELECT qdg05,qdg06 INTO l_qct14,l_qct15
                    FROM qdg_file
                   WHERE qdg01 = g_ima101
                    #AND qdg02 = l_qcd.qcd03  #MOD-D40046 mark
                     AND qdg02 = g_qcs.qcs17  #MOD-D40046 
                     AND qdg03 = l_qdf02
                  IF SQLCA.sqlcode THEN 
                     LET l_qct14 =0
                     LET l_qct15 =0
                  END IF
               END CASE  
#No.FUN-A80063 --end
               IF l_qct11 > g_qcs.qcs22 THEN LET l_qct11=g_qcs.qcs22 END IF
               IF cl_null(l_qct11) THEN LET l_qct11=0 END IF

              #FUN-C30149 add START
               IF g_flag = 'Y' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM qct_file
                     WHERE qct01 = g_qcs.qcs01 AND qct02 = g_qcs.qcs02
                       AND qct021 = g_qcs.qcs05 AND qct04 = l_qcd.qcd02
                  IF l_cnt > 0 THEN
                     CONTINUE FOREACH
                  END IF
               END IF
              #FUN-C30149 add END

               INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,  #No.MOD-470041
                                     qct06,qct07,qct08,qct09,qct10,qct11,
                                     qct12,qct131,qct132,qct14,qct15,                               #No.FUN-A80063
                                     qctplant,qctlegal ) #FUN-980007
                              VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,
                                     l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                     0,'1',l_ac_num,l_re_num,l_qct11,
                                     l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,l_qct14,l_qct15,         #No.FUN-A80063
                                     g_plant,g_legal)    #FUN-980007
               LET seq=seq+1
            END FOREACH
      END CASE
      CALL t110_show()
   END IF
 
END FUNCTION
 
FUNCTION t110_ii(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
   DEFINE l_chose        LIKE type_file.num5    #TQC-C30082 add
   DEFINE l_choce        LIKE inj_file.inj04    #TQC-C30082 add
   DEFINE l_rvbs04       LIKE rvbs_file.rvbs04  #TQC-C30082 add
   DEFINE l_rvbs021      LIKE rvbs_file.rvbs021 #TQC-C30082 add
   DEFINE l_upd_success  LIKE type_file.chr1    #TQC-C30082 add
 
   DISPLAY BY NAME g_qcs.qcs091,g_qcs.qcs09,g_qcs.qcs13
 
 
   INPUT BY NAME g_qcs.qcs13 WITHOUT DEFAULTS
 
      AFTER FIELD qcs13
         IF cl_null(g_qcs.qcs13) THEN
            LET g_qcs.qcs13 = g_qcs_o.qcs13     #MOD-910138 
            NEXT FIELD qcs13
         END IF
         SELECT gen02 INTO m_gen02 FROM gen_file
          WHERE gen01 = g_qcs.qcs13
         IF STATUS THEN
            CALL cl_err3("sel","gen_file",g_qcs.qcs13,"","aoo-017","","",1)  #No.FUN-660115
            LET g_qcs.qcs13 = g_qcs_o.qcs13     #MOD-910138 
            SELECT gen02 INTO m_gen02 FROM gen_file  WHERE gen01 = g_qcs.qcs13  #MOD-910138
            NEXT FIELD qcs13
         END IF
         DISPLAY m_gen02 TO FORMONLY.gen02
#No.TQC-C30082---------------add begin-----------------------
         
         IF g_qcs.qcs09 = '1' THEN
            SELECT COUNT(*) INTO l_chose FROM rvbs_file,inj_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = g_qcs.qcs01
               AND rvbs02 = g_qcs.qcs02
               AND rvbs13 = g_qcs.qcs05
               AND rvbs09 = 1
               AND inj01 = rvbs021
               AND inj02 = rvbs04
               AND inj03 = 'purity'
               AND inj06 = 'N'
            IF l_chose>0 THEN
               IF cl_confirm('aqc1006') THEN
                  CALL cl_getmsg('aqc1007',g_lang) RETURNING g_msg     #開窗讓使用者輸入純度
                  LET INT_FLAG = 0
                  PROMPT g_msg CLIPPED,': ' FOR l_choce
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                     ON ACTION about
                        CALL cl_about()
                     ON ACTION help
                        CALL cl_show_help()
                     ON ACTION controlg
                        CALL cl_cmdask()
                     IF INT_FLAG THEN
                        LET INT_FLAG = 0
                        RETURN
                     END IF
                  END PROMPT
                  BEGIN WORK
                  DECLARE rvbs_curs_2 CURSOR FOR
                     SELECT rvbs021,rvbs04
                       FROM rvbs_file
                      WHERE rvbs00 = g_prog
                        AND rvbs01 = g_qcs.qcs01
                        AND rvbs02 = g_qcs.qcs02
                        AND rvbs13 = g_qcs.qcs05
                        AND rvbs09 = 1
                  LET l_upd_success = 'N'
                  FOREACH rvbs_curs_2 INTO l_rvbs021,l_rvbs04
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('foreach:',SQLCA.sqlcode,1)
                        EXIT FOREACH
                     END IF
                     UPDATE inj_file SET inj04 = l_choce
                      WHERE inj01 = l_rvbs021
                        AND inj02 = l_rvbs04
                        AND inj03 = 'purity'
                         AND inj06 = 'N'
                     IF SQLCA.sqlcode THEN
                        LET l_upd_success = 'N'
                        EXIT FOREACH
                     ELSE
                        LET l_upd_success = 'Y'
                     END IF
                  END FOREACH
                  IF l_upd_success = 'Y' THEN
                     CALL cl_err('','aqc1008',0)
                     COMMIT WORK
                  ELSE
                     CALL cl_err3("upd","inj_file",g_prog,g_qcs.qcs01,'aqc1009',"","upd inj04",1)
                     ROLLBACK WORK
                  END IF
                END IF
             END IF
          END IF
#No.TQC-C30082---------------add end-------------------------
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcs13) #員工編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_qcs.qcs13
               CALL cl_create_qry() RETURNING g_qcs.qcs13
               DISPLAY BY NAME g_qcs.qcs13
               NEXT FIELD qcs13
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
   UPDATE qcs_file SET qcs13 = g_qcs.qcs13
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
END FUNCTION
 
 FUNCTION t110_more_b(l_qct07)   #TQC-970126
   DEFINE ls_tmp           STRING
   DEFINE l_qcu            DYNAMIC ARRAY OF RECORD
                              qcu04   LIKE qcu_file.qcu04,
                              qce03   LIKE qce_file.qce03,
                              qcu05   LIKE qcu_file.qcu05,
                              qcuicd01 LIKE qcu_file.qcuicd01,   #No.FUN-830131
                              qcuicd02 LIKE qcu_file.qcuicd02,   #No.FUN-830131
                              icd03    LIKE icd_file.icd03       #No.FUN-830131  
                           END RECORD
   DEFINE l_qcu05_t        LIKE qcu_file.qcu05
   DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
   DEFINE l_icd03          LIKE icd_file.icd03  
   DEFINE l_qct07          LIKE qct_file.qct07           #TQC-970126 
   DEFINE l_chr            LIKE type_file.chr1           #TQC-970126
                     
   OPEN WINDOW t110_mo AT 04,04 WITH FORM "aqc/42f/aqct1101"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aqct1101")
 
   DECLARE t110_mo CURSOR FOR
      SELECT qcu04,qce03,qcu05,qcuicd01,qcuicd02,icd03          #No.FUN-830131 
       FROM qcu_file LEFT OUTER JOIN qce_file ON (qcu_file.qcu04 = qce_file.qce01) LEFT OUTER JOIN icd_file ON (qcu_file.qcuicd02 = icd_file.icd01)    #liuxqa 091022          #No.FUN-830131 
       WHERE qcu01=g_qcs.qcs01   #liuxqa 091022
         AND qcu02=g_qcs.qcs02
         AND qcu021=g_qcs.qcs05
         AND qcu03=g_qct[l_ac].qct03
 
   CALL l_qcu.clear()
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH t110_mo INTO l_qcu[i].*
      IF STATUS THEN
         CALL cl_err3("sel","qcu_file,","","",SQLCA.sqlcode,"","",1)  #No.FUN-660115
         EXIT FOREACH
      END IF
      LET i = i + 1
   END FOREACH
 
   LET l_rec_b= i - 1
   DISPLAY l_rec_b TO cn2
 
   SELECT SUM(qcu05) INTO l_qcu05_t FROM qcu_file
    WHERE qcu01 = g_qcs.qcs01
      AND qcu02 = g_qcs.qcs02
      AND qcu021 = g_qcs.qcs05
      AND qcu03 = g_qct[l_ac].qct03
 
   DISPLAY l_qcu05_t TO qcu05t
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcu WITHOUT DEFAULTS FROM s_qcu.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         CALL fgl_set_arr_curr(1)      #MOD-480543
 
      BEFORE ROW
         LET i=ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      #MOD-C30571--add--str--
      AFTER FIELD qcu04
         SELECT qce03 INTO l_qcu[i].qce03 FROM qce_file
          WHERE qce01 = l_qcu[i].qcu04
      #MOD-C30571--add--end--

      BEFORE FIELD qcu05
         #MOD-C30571--mark--str--
         #SELECT qce03 INTO l_qcu[i].qce03 FROM qce_file
         # WHERE qce01 = l_qcu[i].qcu04
         #MOD-C30571--mark--end--
         IF STATUS THEN
            NEXT FIELD qcu04
         END IF
         LET i = ARR_CURR()
         DISPLAY l_qcu[i].qce03 TO qce03
 
      AFTER FIELD qcu05
         IF l_qcu[i].qcu05 < 0 OR l_qcu[i].qcu05 IS NULL THEN
            LET l_qcu[i].qcu05 = 0
            DISPLAY l_qcu[i].qcu05 TO qcu05
         END IF
 
        AFTER FIELD qcuicd01 
           IF NOT cl_null(l_qcu[i].qcuicd01) THEN                                                                                
              LET l_n = 0                                                                                                           
              SELECT COUNT(DISTINCT ida05) INTO l_n FROM ida_file                                                                   
               WHERE ida30 = g_qcs.qcs01 AND ida31 = g_qcs.qcs02                                                                            
              IF l_n = 0 THEN                                                                                                       
                 CALL cl_err(l_qcu[i].qcuicd01,'aic-212',0)                                                                      
                 NEXT FIELD qcuicd01                                                                                                
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD qcuicd02                                                                                                        
           IF NOT cl_null(l_qcu[i].qcuicd02) THEN                                                                                
              LET l_n = 0                                                                                                           
              SELECT COUNT(icd01) INTO l_n FROM icd_file                                                                            
               WHERE icd02 = 'T'                                                                                                    
              IF l_n = 0 THEN                                                                                                       
                 CALL cl_err(l_qcu[i].qcuicd02,'aic-213',0)                                                                      
                 NEXT FIELD qcuicd02                                                                                                
              END IF                                                                                                                
              SELECT icd03 INTO l_icd03 FROM icd_file                                                                                       
               WHERE icd01 = l_qcu[i].qcuicd02                                                                                        
                 DISPLAY l_icd03 TO icd03                                                                                             
           END IF                            
 
      AFTER ROW
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         LET l_qcu05_t = 0
         LET l_chr = 'Y'  #TQC-970126           
         FOR k = 1 TO l_qcu.getLength()
            IF l_qcu[k].qcu05 IS NOT NULL AND l_qcu[k].qcu05 <> 0 THEN
               LET l_qcu05_t = l_qcu05_t + l_qcu[k].qcu05
            END IF
            IF l_qcu05_t > l_qct07 THEN 
               LET l_chr = 'N'
               EXIT FOR 
            END IF  
         END FOR
         IF l_chr = 'N' THEN 
            CALL cl_err('','aqc-029',0)
            NEXT FIELD qcu05 
         END IF      
         DISPLAY l_qcu05_t TO qcu05t

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcu04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qce"
               LET g_qryparam.default1 = l_qcu[i].qcu04
               CALL cl_create_qry() RETURNING l_qcu[i].qcu04
               DISPLAY l_qcu[i].qcu04 TO qcu04
               NEXT FIELD qcu04
            WHEN INFIELD(qcuicd01)                                                                                                   
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = "q_ida"                                                                                          
             LET g_qryparam.arg1 = g_qcs.qcs01                                                                                          
             LET g_qryparam.arg2 = g_qcs.qcs02                                                                                          
             LET g_qryparam.default1 = l_qcu[i].qcuicd01                                                                         
             CALL cl_create_qry() RETURNING l_qcu[i].qcuicd01
             DISPLAY l_qcu[i].qcuicd01 TO qcuicd01                                                                                   
             NEXT FIELD qcuicd01                                                                                                    
           WHEN INFIELD(qcuicd02)                                                                                                   
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = "q_icd2"                                                                                         
             LET g_qryparam.default1 = l_qcu[i].qcuicd02                                                                         
             CALL cl_create_qry() RETURNING l_qcu[i].qcuicd02 
             DISPLAY l_qcu[i].qcuicd02  TO qcuicd02                                                                                 
             SELECT icd03 INTO l_icd03 FROM icd_file                                                                               
              WHERE icd01 = l_qcu[i].qcuicd02                                                                                      
             DISPLAY l_icd03 TO icd03                                                                                                
             NEXT FIELD qcuicd02                                                                                                    
           OTHERWISE                                                                                                                
             EXIT CASE            
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
 
   CLOSE WINDOW t110_mo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcu_file
    WHERE qcu01 = g_qcs.qcs01
      AND qcu02 = g_qcs.qcs02
      AND qcu021 = g_qcs.qcs05
      AND qcu03 = g_qct[l_ac].qct03
 
   FOR i = 1 TO l_qcu.getLength()
      IF l_qcu[i].qcu05 IS NULL OR l_qcu[i].qcu05=0 THEN
         CONTINUE FOR
      END IF
      INSERT INTO qcu_file (qcu01,qcu02,qcu021,qcu03,qcu04,qcu05,qcuicd01,qcuicd02,
                            qcuplant,qculegal)  #FUN-980007
                     VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,
                            g_qct[l_ac].qct03,l_qcu[i].qcu04,l_qcu[i].qcu05,
                            l_qcu[i].qcuicd01,l_qcu[i].qcuicd02,
                            g_plant,g_legal)    #FUN-980007
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","qcu_file",g_qcs.qcs01,g_qct[l_ac].qct03,SQLCA.sqlcode,"","INS-qcu",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOR
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION t110_more_b1(p_qct11,p_qcd05,p_qcd061,p_qcd062,p_qct03,p_qct04)
   DEFINE l_qctt           DYNAMIC ARRAY OF RECORD
                              qctt04   LIKE qctt_file.qctt04
                           END RECORD
   DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_rowcount       LIKE type_file.num5    #No.FUN-680104 SMALLINT #MOD-4B0139
   DEFINE l_i              LIKE type_file.num5   #MOD-4B0139  #No.FUN-680104 SMALLINT
   DEFINE l_rec_b          LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE p_qct11          LIKE qct_file.qct11
   DEFINE p_qcd05          LIKE qcd_file.qcd05
   DEFINE p_qcd061         LIKE qcd_file.qcd061
   DEFINE p_qcd062         LIKE qcd_file.qcd062
   DEFINE p_qct03          LIKE qct_file.qct03
   DEFINE p_qct04          LIKE qct_file.qct04
   DEFINE l_azf03          LIKE azf_file.azf03
   DEFINE l_flag           LIKE type_file.num5          #MOD-B10034 add
   DEFINE ls_tmp           STRING,
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
   DEFINE l_qcs09          LIKE qcs_file.qcs09    #CHI-C70004 add
 
   OPEN WINDOW t110_mo1 AT 04,04 WITH FORM "aqc/42f/aqct1102"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aqct1102")
 
   DISPLAY p_qct03 TO FORMONLY.qct03
   DISPLAY p_qct04 TO FORMONLY.qct04
   SELECT azf03 INTO l_azf03 FROM azf_file
    WHERE azf01 = p_qct04
      AND azf02 = '6'
   DISPLAY l_azf03 TO FORMONLY.azf03
   DISPLAY p_qct11 TO FORMONLY.qct11
   DISPLAY p_qcd05 TO FORMONLY.qct12
   DISPLAY p_qcd061 TO FORMONLY.qct131
   DISPLAY p_qcd062 TO FORMONLY.qct132
 
   CALL l_qctt.clear()
 
   LET i = 1
   LET k = 1
   LET l_rec_b = 0
   LET l_flag = 0        #MOD-B10034 add 
   DECLARE t110_mo1 CURSOR FOR SELECT qctt04 FROM qctt_file
                                WHERE qctt01 = g_qcs.qcs01
                                  AND qctt02 = g_qcs.qcs02
                                  AND qctt021 = g_qcs.qcs05
                                  AND qctt03 = g_qct[l_ac].qct03
 
   FOREACH t110_mo1 INTO l_qctt[k].*
      IF STATUS THEN
         CALL cl_err3("sel","l_azf03","","",SQLCA.sqlcode,"","",1)  #No.FUN-660115
         EXIT FOREACH
      END IF
      LET k = k + 1
      IF k > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   #填充單身最後一筆為 NULL array, 故要刪掉
   CALL l_qctt.deleteElement(k) #MOD-4B0139
   LET l_rec_b = k - 1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   WHILE TRUE #MOD-4B0139
 
      INPUT ARRAY l_qctt WITHOUT DEFAULTS FROM s_qctt.*
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
 
         BEFORE ROW
            LET i=ARR_CURR()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
            LET l_rowcount = 0
            FOR l_i = 1 TO l_qctt.getLength()
               IF l_qctt[l_i].qctt04 IS NULL THEN
                  CONTINUE FOR
               END IF
               LET l_rowcount = l_rowcount + 1
            END FOR
            DISPLAY l_rowcount TO cn2
 
         AFTER ROW
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_flag = 1      #MOD-B10034 add
               EXIT INPUT
            END IF
            LET l_rowcount = 0
            FOR l_i = 1 TO l_qctt.getLength()
               IF l_qctt[l_i].qctt04 IS NULL THEN
                  CONTINUE FOR
               END IF
               LET l_rowcount = l_rowcount + 1
            END FOR
            DISPLAY l_rowcount TO cn2
 
         AFTER INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         LET l_rowcount = 0
         FOR l_i = 1 TO l_qctt.getLength()
            IF l_qctt[l_i].qctt04 IS NULL THEN
               CONTINUE FOR
            END IF
            LET l_rowcount = l_rowcount + 1
         END FOR
         DISPLAY l_rowcount TO cn2
 
      END INPUT
      IF l_flag = 0 THEN         #MOD-B10034 add
           #CHI-C70004 str add-----
            SELECT qcs09 INTO l_qcs09 FROM qcs_file
             WHERE qcs01 = g_qcs.qcs01
               AND qcs02 = g_qcs.qcs02
               AND qcs05 = g_qcs.qcs05
           #CHI-C70004 end add-----
         IF l_rowcount <> p_qct11 AND NOT (l_qcs09 =2 AND l_rowcount=0) THEN       #CHI-C70004 add AND !(l_qcs09 =2 AND l_rowcount=0)
            LET g_msg = l_rowcount,': ',p_qct11
            CALL cl_err(g_msg,'aqc-038',1)
            CONTINUE WHILE
         END IF
      END IF                #MOD-B10034 add
      EXIT WHILE
   END WHILE #MOD-4B0139
 
   CLOSE WINDOW t110_mo1
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qctt_file
    WHERE qctt01 = g_qcs.qcs01
      AND qctt02 = g_qcs.qcs02
      AND qctt021 = g_qcs.qcs05
      AND qctt03 = g_qct[l_ac].qct03
 
   LET g_qct[l_ac].qct07 = 0
 
   FOR i = 1 TO l_qctt.getLength()
      IF l_qctt[i].qctt04 IS NULL THEN                        #MOD-4B0139允許輸入零
         CONTINUE FOR
      END IF
 
      INSERT INTO qctt_file(qctt01,qctt02,qctt021,qctt03,qctt04,  #No.MOD-470041
                            qcttplant,qcttlegal) #FUN-980007
          VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qct[l_ac].qct03,
                 l_qctt[i].qctt04,
                 g_plant,g_legal)                #FUN-980007
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","qctt_file",g_qcs.qcs01,g_qct[l_ac].qct03,SQLCA.sqlcode,"","INS-qctt",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOR
      ELSE
         IF l_qctt[i].qctt04 < p_qcd061 OR l_qctt[i].qctt04 > p_qcd062 THEN
            LET g_qct[l_ac].qct07 = g_qct[l_ac].qct07 + 1
         END IF
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION t110_out()
   DEFINE l_cmd        LIKE type_file.chr1000,#No:9554  #No.FUN-680104 VARCHAR(300)
          l_wc2        LIKE type_file.chr1000,#No:9554  #No.FUN-680104 VARCHAR(120)
          l_prtway     LIKE type_file.chr1    #No.FUN-680104 VARCHAR(01)
 
   CALL cl_wait()
 
   LET l_wc = 'qcs01="',g_qcs.qcs01,
              '" AND qcs02="',g_qcs.qcs02,
              '" AND qcs05="',g_qcs.qcs05,'"'  #No:9554
 
   CASE g_argv1
      WHEN "1"
         SELECT zz21,zz22 INTO l_wc2,l_prtway
           FROM zz_file
        # WHERE zz01 = 'aqcr300' #FUN-C30085 mark
          WHERE zz01 = 'aqcg300' #FUN-C30085 add
        #LET l_cmd = 'aqcr300'   #FUN-C30085 mark
         LET l_cmd = 'aqcg300'   #FUN-C30085 add
      WHEN "2"
         SELECT zz21,zz22 INTO l_wc2,l_prtway
           FROM zz_file
        # WHERE zz01 = 'aqcr360' #FUN-C30085 mark
          WHERE zz01 = 'aqcg360' #FUN-C30085 add
        #LET l_cmd = 'aqcr360' #FUN-C30085 mark
         LET l_cmd = 'aqcg360' #FUN-C30085 add
      WHEN "3"
         SELECT zz21,zz22 INTO l_wc2,l_prtway
           FROM zz_file
        # WHERE zz01 = 'aqcr370' #FUN-C30085 mark
          WHERE zz01 = 'aqcg370' #FUN-C30085 add
        #LET l_cmd = 'aqcr370'   #FUN-C30085 mark
         LET l_cmd = 'aqcg370'   #FUN-C30085 add
      WHEN "4"
         SELECT zz21,zz22 INTO l_wc2,l_prtway
           FROM zz_file
        # WHERE zz01 = 'aqcr300' #FUN-C30085 mark
          WHERE zz01 = 'aqcg300' #FUN-C30085 add
        #LET l_cmd = 'aqcr300'   #FUN-C30085 mark
         LET l_cmd = 'aqcg300'   #FUN-C30085 add
   END CASE
 
   LET l_cmd = l_cmd CLIPPED ,
               "  ''",
               " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
               " '",l_wc CLIPPED,"' "
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
 
END FUNCTION
 
FUNCTION t110_b_memo()
   DEFINE l_qcv            DYNAMIC ARRAY OF RECORD
          qcv04            LIKE qcv_file.qcv04
                           END RECORD
   DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE l_rec_b          LIKE type_file.num5    #No.FUN-680104 SMALLINT
   DEFINE ls_tmp           STRING,
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t110_b_memo AT 04,04 WITH FORM "aqc/42f/aqct1103"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aqct1103")
 
   DECLARE t110_b_memo CURSOR FOR SELECT qcv04 FROM qcv_file
                                   WHERE qcv01 = g_qcs.qcs01
                                     AND qcv02 = g_qcs.qcs02
                                     AND qcv021 = g_qcs.qcs05
                                     AND qcv03 = g_qct[l_ac].qct03
 
   CALL l_qcv.clear()
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH t110_b_memo INTO l_qcv[i].*
      IF STATUS THEN
         CALL cl_err('foreach qcv',STATUS,0)
         EXIT FOREACH
      END IF
 
      LET i = i + 1
 
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_rec_b = i-1
   DISPLAY l_rec_b TO cn2          #bug no:6494
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcv WITHOUT DEFAULTS FROM s_qcv.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET i = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
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
 
   CLOSE WINDOW t110_b_memo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcv_file
    WHERE qcv01 = g_qcs.qcs01
      AND qcv02 = g_qcs.qcs02
      AND qcv021 = g_qcs.qcs05
      AND qcv03 = g_qct[l_ac].qct03
 
   FOR i = 1 TO l_qcv.getLength()
      IF cl_null(l_qcv[i].qcv04) THEN
         CONTINUE FOR
      END IF
 
      INSERT INTO qcv_file(qcv01,qcv02,qcv021,qcv03,qcv04,  #No.MOD-470041
                           qcvplant,qcvlegal) #FUN-980007
           VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qct[l_ac].qct03,
                  l_qcv[i].qcv04,
                  qcvplant,qcvlega)           #FUN-980007
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","qcv_file",g_qcs.qcs01,g_qct[l_ac].qct03,SQLCA.sqlcode,"","INS-qcv",1)  #No.FUN-660115
         LET g_success = 'N'
         EXIT FOR
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION t110_m()
 
   IF g_qcs.qcs01 IS NULL THEN
      RETURN
   END IF
 
 
   LET g_action_choice = "modify"
 
   IF NOT cl_chk_act_auth() THEN
      LET g_chr = 'd'
   ELSE
      LET g_chr = 'u'
   END IF
 
   DISPLAY " 1=",g_qcs.qcs01
   DISPLAY " 2=",g_qcs.qcs02
   DISPLAY " 3=",g_qcs.qcs05
   DISPLAY " 4=",0
   DISPLAY " 5=",g_chr
 
   CALL s_aqc_memo(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,0,g_chr)
 
END FUNCTION
 
FUNCTION t110_3()
   DEFINE l_qty1,l_qty2 LIKE qcs_file.qcs091    #No.MOD-640514 add
   DEFINE l_str      STRING                     #NO.MOD_650102 add
   DEFINE l_n        LIKE type_file.num5    #No.FUN-840157
   DEFINE l_chose    LIKE type_file.num5    #No.TQC-B90236
   DEFINE l_choce    LIKE inj_file.inj04    #No.TQC-B90236
   DEFINE l_rvbs021  LIKE rvbs_file.rvbs021 #No.TQC-B90236
   DEFINE l_rvbs04   LIKE rvbs_file.rvbs04  #No.TQC-B90236
   DEFINE l_ima44    LIKE ima_file.ima44    #FUN-BB0085
   DEFINE l_qck09               LIKE qck_file.qck09
   DEFINE l_type                LIKE type_file.chr1 
   DEFINE l_sum      LIKE qcs_file.qcs091   #FUN-CC0015 add

   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF g_qcs.qcs09 = '1' THEN   #No.MOD-480059
      RETURN
   END IF
 
   IF cl_null(g_qcs.qcs01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #FUN-CC0015 mark begin---
   #IF g_qcs.qcs14 != 'Y' THEN
   #   CALL cl_err(g_qcs.qcs01,'anm-960',0)
   #   RETURN
   #END IF
   #FUN-CC0015 mark end-----
 
   LET g_cnt =0
   SELECT count(*) INTO g_cnt FROM rvu_file,rvv_file
    WHERE rvu02=g_qcs.qcs01 AND rvu02=rvv04 AND rvv05=g_qcs.qcs02 
          AND rvu00='2' AND  rvuconf != 'X' 
   IF g_cnt >0 THEN
      LET l_str= g_qcs.qcs01,g_qcs.qcs02 
      IF NOT cl_confirm2('aqc-430',l_str) THEN RETURN END IF
   END IF
 
   LET g_qcs_t.* = g_qcs.*
 
   BEGIN WORK
 
   LET g_success = 'Y'
 
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #show特採
   CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   DISPLAY '3',des1 TO qcs09,FORMONLY.des1
 
   #FUN-CC0015 mark begin---
   #INPUT BY NAME g_qcs.qcs41,g_qcs.qcs38,g_qcs.qcs091 WITHOUT DEFAULTS 
 
   #   BEFORE INPUT
   #      IF g_sma.sma115 = "Y" THEN
   #         CALL cl_set_comp_entry("qcs38,qcs41",TRUE)
   #         CALL cl_set_comp_entry("qcs091",FALSE)             
   #      ELSE
   #         CALL cl_set_comp_entry("qcs38,qcs41",FALSE)
   #         CALL cl_set_comp_entry("qcs091",TRUE)             
   #      END IF
 
   #   AFTER FIELD qcs38
   #      #FUN-BB0085-add-str--
   #      IF NOT cl_null(g_qcs.qcs38) THEN
   #         IF g_qcs.qcs38 != g_qcs_t.qcs38 OR cl_null(g_qcs_t.qcs38) THEN
   #            LET g_qcs.qcs38 = s_digqty(g_qcs.qcs38,g_qcs.qcs36)
   #            DISPLAY BY NAME g_qcs.qcs38
   #         END IF
   #      END IF
   #      #FUN-BB0085-add-str--
   #      IF g_qcs.qcs38 >= 0 THEN
   #         IF g_ima906 = "2" THEN
   #            LET g_qcs.qcs091 = g_qcs.qcs41 * g_qcs.qcs40 +
   #                               g_qcs.qcs38 * g_qcs.qcs37
   #         ELSE
   #            LET g_qcs.qcs091 = g_qcs.qcs38 * g_qcs.qcs37
   #         END IF
   #         #FUN-BB0085-add-str--
   #         SELECT ima44 INTO l_ima44 FROM ima_file
   #          WHERE ima01 = g_qcs.qcs021
   #         LET g_qcs.qcs091 = s_digqty(g_qcs.qcs091,l_ima44)
   #         #FUN-BB0085-add-end--
   #         IF g_qcs.qcs091 > g_qcs.qcs22 THEN
   #            CALL cl_err(g_qcs.qcs22,'aqc-037',0)
   #            NEXT FIELD qcs38
   #         END IF
   #         DISPLAY BY NAME g_qcs.qcs091
   #      END IF
 
   #   AFTER FIELD qcs41
   #      #FUN-BB0085-add-str--
   #      IF NOT cl_null(g_qcs.qcs41) THEN 
   #         IF g_qcs.qcs41 != g_qcs_t.qcs41 OR cl_null(g_qcs_t.qcs41) THEN 
   #            LET g_qcs.qcs41 = s_digqty(g_qcs.qcs41,g_qcs.qcs39)
   #            DISPLAY BY NAME g_qcs.qcs41
   #         END IF
   #      END IF
   #      #FUN-BB0085-add-str--
   #      IF g_qcs.qcs41 >= 0 THEN
   #         IF g_ima906 = "2" THEN
   #            LET g_qcs.qcs091 = g_qcs.qcs41 * g_qcs.qcs40 +
   #                               g_qcs.qcs38 * g_qcs.qcs37
   #         ELSE
   #            LET g_qcs.qcs091 = g_qcs.qcs38 * g_qcs.qcs37
   #         END IF
   #         IF g_qcs.qcs091 > g_qcs.qcs22 THEN
   #            CALL cl_err(g_qcs.qcs22,'aqc-037',0)
   #            NEXT FIELD qcs41
   #         END IF
   #         #FUN-BB0085-add-str--
   #         SELECT ima44 INTO l_ima44 FROM ima_file
   #          WHERE ima01 = g_qcs.qcs021
   #         LET g_qcs.qcs091 = s_digqty(g_qcs.qcs091,l_ima44)
   #         #FUN-BB0085-add-end--
   #         DISPLAY BY NAME g_qcs.qcs091
   #      END IF
 
   #   AFTER FIELD qcs091
   #      #FUN-BB0085-add-str--
   #      IF NOT cl_null(g_qcs.qcs091) THEN 
   #         SELECT ima44 INTO l_ima44 FROM ima_file
   #          WHERE ima01 = g_qcs.qcs021
   #         LET g_qcs.qcs091 = s_digqty(g_qcs.qcs091,l_ima44)
   #      END IF
   #      #FUN-BB0085-add-end--
   #      IF g_qcs.qcs091 > g_qcs.qcs22 OR g_qcs.qcs091 < 0 THEN
   #         CALL cl_err('err qcs091','aqc-425',0)  #No.MOD-520016
   #         NEXT FIELD qcs091
   #      END IF
   #      SELECT SUM(qcs091) INTO l_qty1 FROM qcs_file 
   #         WHERE qcs01 = g_qcs.qcs01
   #           AND qcs02 = g_qcs.qcs02
   #           AND qcs05 != g_qcs.qcs05
   #           AND qcs14 = 'Y'
 
   #      SELECT SUM(rvv17) INTO l_qty2 FROM rvv_file,rvu_file 
   #         WHERE rvu02 = g_qcs.qcs01
   #           AND rvu00 = '1'
   #           AND rvuconf != 'X'
   #           AND rvu01 = rvv01
   #           AND rvv05 = g_qcs.qcs02
 
   #      IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
   #      IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF
   #      LET l_qty1 = l_qty1 + g_qcs.qcs091
   #      IF l_qty2 > l_qty1 THEN 
   #         CALL cl_err('err qcs091','aqc-429',0)
   #         NEXT FIELD qcs091
   #      END IF
   #      IF cl_null(g_qcs.qcs091) THEN
   #         IF NOT cl_null(g_qcs_o.qcs091) THEN
   #            LET g_qcs.qcs091 = g_qcs_o.qcs091
   #         ELSE
   #            LET g_qcs.qcs091 = 0
   #         END IF
   #         DISPLAY BY NAME g_qcs.qcs091
   #      END IF
   #      SELECT ima918,ima921 INTO g_ima918,g_ima921 
   #        FROM ima_file
   #       WHERE ima01 = g_qcs.qcs021
   #         AND imaacti = "Y"
   #      
   #      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
   #         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047  
   #         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
   #            IF g_argv1 <> "4" THEN
   #               IF g_qcs.qcs00 NOT MATCHES '[EFG]' THEN
   #                  CALL t110_get_fac()
   #                 #CALL s_lotin(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,                 #TQC-B90236 mark
   #                 #             g_qcs.qcs021,g_pmn07,g_img09,l_fac,
   #                 #            #g_qcs.qcs091,'SEL')    #No.MOD-950114 mark
   #                 #             g_qcs.qcs091,'','IQC')    #No.MOD-950114 add#CHI-9A0022 add ''
   #                  CALL s_mod_lot(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,                 #TQC-B90236 add
   #                               g_qcs.qcs021,g_rvb36,g_rvb37,g_rvb38,g_pmn07,g_img09,l_fac,
   #                               g_qcs.qcs091,'','IQC',1) 
   #                        RETURNING l_r,g_qty
   #                  IF l_r = "Y" THEN
   #                     LET g_qcs.qcs091 = g_qty
   #                     SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01 = g_qcs.qcs021    #FUN-BB0085
   #                     LET g_qcs.qcs091 = s_digqty(g_qcs.qcs091,l_ima44)                     #FUN-BB0085
   #                     DISPLAY BY NAME g_qcs.qcs091                                          #FUN-BB0085
   #                  END IF
   #               END IF
   #            END IF
   #         END IF
   #      END IF
   #      LET g_qcs22 = g_qcs.qcs22       #bugno:7196
   #      LET g_qcs_o.qcs091 = g_qcs.qcs091
   #   #No.TQC-B90236---------------add begin-----------------------
   #      SELECT COUNT(*) INTO l_chose FROM rvbs_file,inj_file
   #       WHERE rvbs00 = g_prog
   #         AND rvbs01 = g_qcs.qcs01
   #         AND rvbs02 = g_qcs.qcs02
   #         AND rvbs13 = g_qcs.qcs05
   #         AND rvbs09 = 1
   #         AND inj01 = rvbs021
   #         AND inj02 = rvbs04
   #         AND inj03 = 'purity'
   #         AND inj06 = 'N'
   #      IF l_chose>0 THEN
   #         IF cl_confirm('aqc1006') THEN
   #            CALL cl_getmsg('aqc1007',g_lang) RETURNING g_msg     #開窗讓使用者輸入純度
   #            LET INT_FLAG = 0  
   #            PROMPT g_msg CLIPPED,': ' FOR l_choce
   #               ON IDLE g_idle_seconds
   #                  CALL cl_on_idle()
   #               ON ACTION about      
   #                  CALL cl_about()  
   #               ON ACTION help     
   #                  CALL cl_show_help()  
   #               ON ACTION controlg    
   #                  CALL cl_cmdask()  
   #               IF INT_FLAG THEN
   #                  LET INT_FLAG = 0
   #                  RETURN
   #               END IF
   #            END PROMPT
   #            DECLARE rvbs_curs_1 CURSOR FOR   #TQC-C30082 add
   #                SELECT rvbs021,rvbs04
   #                  FROM rvbs_file
   #                 WHERE rvbs00 = g_prog
   #                   AND rvbs01 = g_qcs.qcs01
   #                   AND rvbs02 = g_qcs.qcs02
   #                   AND rvbs13 = g_qcs.qcs05
   #                   AND rvbs09 = 1
   #            FOREACH rvbs_curs_1 INTO l_rvbs021,l_rvbs04      #TQC-C30082 add
   #               IF SQLCA.sqlcode THEN                         #TQC-C30082 add         
   #                  CALL cl_err('foreach:',SQLCA.sqlcode,1)    #TQC-C30082 add
   #                  EXIT FOREACH                               #TQC-C30082 add
   #               END IF                                        #TQC-C30082 add
   #               UPDATE inj_file SET inj04 = l_choce
   #                WHERE inj01 = l_rvbs021
   #                  AND inj02 = l_rvbs04
   #                  AND inj03 = 'purity'
   #                  AND inj06 = 'N'
   #               IF SQLCA.sqlcode THEN
   #                  LET g_success = 'N'
   #                  EXIT FOREACH                #TQC-C30082 add
   #               ELSE
   #                  LET g_success = 'Y'
   #               END IF
   #   #TQC-C30082 ------ add ----- begin
   #             END FOREACH
   #             IF g_success =  'Y' THEN
   #                CALL cl_err('','aqc1008',0)
   #             ELSE
   #                CALL cl_err3("upd","inj_file",g_prog,g_qcs.qcs01,'aqc1009',"","upd inj04",1)
   #             END IF
   #   #TQC-C30082 ------ add ----- end
   #          END IF
   #       END IF
   #   #No.TQC-B90236---------------add end-------------------------
 
   #   ON ACTION CONTROLR
   #      CALL cl_show_req_fields()
 
   #   ON ACTION CONTROLG
   #      CALL cl_cmdask()
 
   #   ON IDLE g_idle_seconds
   #      CALL cl_on_idle()
   #      CONTINUE INPUT
 
   #   ON ACTION about         #MOD-4C0121
   #      CALL cl_about()      #MOD-4C0121
 
   #   ON ACTION help          #MOD-4C0121
   #      CALL cl_show_help()  #MOD-4C0121
 
   #END INPUT
   #FUN-CC0015 mark end-----

   #FUN-CC0015 add begin---
   IF g_argv1 = '2' AND g_qcs.qcs00 <> 'Z' THEN  
      CALL cl_err(l_type,'aqc-543',0)            
   ELSE      
         LET l_qck09='' LET l_type=''
         SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
          WHERE qck01=ima109
            AND ima01=g_qcs.qcs021
       IF l_qck09='Y' THEN         
         CASE g_argv1
             WHEN "1"
                 LET l_type='1'
             WHEN "2"
                 IF g_qcs.qcs00 = 'Z' THEN
                    LET l_type='4'
                 ELSE
                    LET l_type=''
                 END IF
             OTHERWISE
                 LET l_type=''
         END CASE
      ELSE                                    
         CALL cl_err(m_ima109,'aqc-537',0)    
      END IF
      IF NOT cl_null(l_type) THEN
         LET g_msg = "aqci107 '",g_qcs.qcs01,"' '",g_qcs.qcs02,"' '",g_qcs.qcs05,"' '",l_type,"'"
         CALL cl_cmdrun_wait(g_msg)
      END IF
   END IF     #TQC-C40081

   SELECT SUM(qco11) INTO l_sum FROM qco_file WHERE qco01 = g_qcs.qcs01 AND qco02 = g_qcs.qcs02 AND qco05 = g_qcs.qcs05
   LET g_qcs.qcs091 = l_sum
   DISPLAY BY NAME g_qcs.qcs091
   #FUN-CC0015 add end-----
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_qcs.* = g_qcs_t.*
      CALL t110_show()
      CALL cl_err('','9001',0)
      RETURN
   END IF
 
   UPDATE qcs_file SET qcs09 = '3', #特採
                       qcs091 = g_qcs.qcs091,
                       qcs38 = g_qcs.qcs38,   #No.FUN-610075
                       qcs41 = g_qcs.qcs41,   #No.FUN-610075
                       qcs15 = g_today,
                       qcsmodu = g_user,
                       qcsdate = g_today
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
      CALL t110_3_y()
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CLOSE t110_cl
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   CALL t110_show()
 
END FUNCTION

#FUN-A30045 ---------------------Begin------------------------------------------
FUNCTION t110_4()
   DEFINE l_qcs091  LIKE  qcs_file.qcs091
   DEFINE l_rvv17   LIKE  rvv_file.rvv17
   #IF g_argv1 <> '1' THEN    #FUN-C30152
   IF g_argv1 <> '1' AND g_argv1 <> '2' THEN  #FUN-C30152  
      RETURN
   END IF  
   IF g_qcs.qcs09 <> '3' THEN
      RETURN
   END IF  
   IF cl_null(g_qcs.qcs01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #FUN-CC0015 mark begin---
   #IF g_qcs.qcs14 != 'Y' THEN
   #   CALL cl_err(g_qcs.qcs01,'anm-960',0)
   #   RETURN
   #END IF
   #FUN-CC0015 mark end----- 
 
   LET l_qcs091 = 0
   LET l_rvv17  = 0
   SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
                 WHERE qcs01 = g_qcs.qcs01
                   AND qcs02 = g_qcs.qcs02
                   AND qcs05 <> g_qcs.qcs05
                   AND qcs14 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      
   END IF   
   SELECT SUM(rvv17)  INTO l_rvv17 FROM rvu_file,rvv_file
                 WHERE rvv04 = g_qcs.qcs01
                   AND rvv04 = rvu02
                   AND rvv05 = g_qcs.qcs02
                   AND rvuconf <> 'X'
                   AND rvu01 = rvv01 #MOD-D10180 add
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      
   END IF    
   IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
   IF cl_null(l_rvv17)  THEN LET l_rvv17 = 0 END IF   
   IF l_qcs091 < l_rvv17 THEN
      CALL cl_err(g_qcs.qcs01 ,'aqc1001',0)   
      RETURN
   END IF
   IF NOT cl_confirm('aqc1002') THEN
      RETURN
   END IF 
   LET g_qcs_t.* = g_qcs.*   
   BEGIN WORK
   LET g_success = 'Y'  

   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t110_cl INTO g_qcs.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF  

   UPDATE qcs_file SET qcs09 ='2',
                       qcs091 = 0,
                       qcs38= 0,
                       qcs41= 0,
                       qcs15 = g_today,
                       qcsmodu = g_user,
                       qcsdate = g_today							
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05

   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      CALL t110_3_y()
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   CLOSE t110_cl
   
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05

   CALL t110_show()
   DISPLAY BY NAME g_qcs.qcs09,g_qcs.qcs38,g_qcs.qcs41

END FUNCTION
#FUN-A30045 ---------------------End--------------------------------------------


 
#特採時也要UPDATE rvb_file的相關欄位,此段同t110_y() update rvb_file的作法
FUNCTION t110_3_y()
   DEFINE l_rvb33   LIKE rvb_file.rvb33
   DEFINE l_rvb07   LIKE rvb_file.rvb07
   DEFINE l_rvb331  LIKE rvb_file.rvb331   #No.FUN-620043
   DEFINE l_rvb332  LIKE rvb_file.rvb332   #No.FUN-620043
   DEFINE l_rvb30   LIKE rvb_file.rvb30        #MOD-640512
   DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-850100
   DEFINE l_rvbs10  LIKE rvbs_file.rvbs10
   DEFINE l_sql     STRING   #No.FUN-850100
   DEFINE l_rvbs09  LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_qcs091  LIKE qcs_file.qcs091    #FUN-870040
   DEFINE l_qcs38   LIKE qcs_file.qcs38     #FUN-870040
   DEFINE l_qcs41   LIKE qcs_file.qcs41     #FUN-870040
   DEFINE l_rvb90   LIKE rvb_file.rvb90     #FUN-BB0085
 
   SELECT * INTO g_qcs.* FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
 
   #------ 是否與採購勾稽(modi in 01/06/04) ------
   IF g_sma.sma886[8,8] = 'Y' AND g_qcs.qcs00 = '1' THEN
      UPDATE rvb_file SET rvb40 = g_qcs.qcs04   #No.MOD-590083
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvb40",1)  #No.FUN-660115
         LET g_success='N'
      END IF
 
      CASE g_qcs.qcs09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING des1        #No:7706
         WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
      END CASE
 
      UPDATE rvb_file SET rvb41 = des1 #檢驗結果
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvb41",1)  #No.FUN-660115
         LET g_success = 'N'
      END IF
 
      SELECT rvb33,rvb07,rvb331,rvb332,rvb30                 #No.FUN-620043   #MOD-640512 add rvb30
        INTO l_rvb33,l_rvb07,l_rvb331,l_rvb332,l_rvb30    #No.FUN-620043    #MOD-640512 add rvb30
        FROM rvb_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
 
      IF cl_null(l_rvb33) THEN
         LET l_rvb33 = 0
      END IF
 
      IF cl_null(l_rvb07) THEN
         LET l_rvb07 = 0
      END IF
 
      SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41) 
        INTO l_rvb33,l_rvb331,l_rvb332 
        FROM qcs_file 
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND qcs14 = 'Y'         #No.MOD-7C0226 add
     
#FUN-D30065 ------Begin---------
     IF cl_null(l_rvb33) THEN LET l_rvb33 = 0 END IF
     IF cl_null(l_rvb331) THEN LET l_rvb331 = 0 END IF
     IF cl_null(l_rvb332) THEN LET l_rvb332 = 0 END IF
#FUN-D30065 ------End-----------

      #FUN-BB0085-add-str--
      SELECT rvb90 INTO l_rvb90 FROM rvb_file 
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      LET l_rvb33 = s_digqty(l_rvb33,l_rvb90)   
      #FUN-BB0085-add-end--
  
      UPDATE rvb_file SET rvb33 = l_rvb33,
                         #rvb331 = l_rvb33 ,              #No.FUN-620043
                          rvb331 = l_rvb331,              #No.FUN-610097 add
                          rvb332 = l_rvb332,              #No.FUN-620043
                          rvb31 = l_rvb33 - l_rvb30       #MOD-640512
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvb33",1)  #No.FUN-660115
         LET g_success = 'N'
      END IF
   END IF 
      
   IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
      IF g_qcs.qcs00 MATCHES '[1BC]' THEN
         LET l_rvbs09 = 1  
      ELSE
         LET l_rvbs09 = -1  
      END IF
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = g_qcs.qcs021
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
                      
            LET l_sql = "SELECT * FROM rvbs_file",
                        " WHERE rvbs01 = '",g_qcs.qcs01,"'",
                        "   AND rvbs02 = ",g_qcs.qcs02,
                        "   AND rvbs00 != '",g_prog,"'",
                        "   AND rvbs09 = ",l_rvbs09
            
            PREPARE t110_rvbssel1 FROM l_sql
            
            DECLARE rvbs_curssel1 CURSOR FOR t110_rvbssel1
            
            FOREACH rvbs_curssel1 INTO l_rvbs.*
               IF STATUS THEN
                  CALL cl_err('foreach rvbs sel:',STATUS,1)
                  EXIT FOREACH
               END IF
            
               SELECT SUM(rvbs10)
                 INTO l_rvbs10
                 FROM qcs_file,rvbs_file 
                WHERE qcs01 = g_qcs.qcs01
                  AND qcs02 = g_qcs.qcs02
                  AND rvbs13 = qcs05        #No.MOD-950114 add
                  AND qcs01 = rvbs01
                  AND qcs02 = rvbs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs00 = g_prog
                  AND qcs14 = 'Y'
               
               UPDATE rvbs_file SET rvbs10 = l_rvbs10
                WHERE rvbs01 = g_qcs.qcs01
                  AND rvbs02 = g_qcs.qcs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs13 = 0   #No.FUN-860045
               
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                  LET g_success = 'N'
               END IF
               #-----CHI-A70047---------
               IF g_qcs.qcs00 = 'A' OR  
                  g_qcs.qcs00 = 'B' THEN
                  UPDATE rvbs_file SET rvbs06 = l_rvbs10
                   WHERE rvbs01 = g_qcs.qcs01
                     AND rvbs02 = g_qcs.qcs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs13 = 0   
                  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvbs_file",g_qcs.qcs01,g_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                     LET g_success = 'N'
                  END IF
               END IF
               #-----END CHI-A70047-----
            END FOREACH
         END IF
      END IF
   END IF
 
   IF g_qcs.qcs00 = 'A' OR  
      g_qcs.qcs00 = 'B' THEN
      SELECT COUNT(*) INTO g_cnt
        FROM ina_file,inb_file
        WHERE inb01 = g_qcs.qcs01
          AND inb03 = g_qcs.qcs02
          AND inb01 = ina01
          AND inapost = 'Y'
      IF g_cnt > 0 THEN
         LET g_success = 'N'  #MOD-A40050 add
         RETURN
      END IF
      SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)
        INTO l_qcs091,l_qcs38,l_qcs41
        FROM qcs_file
       WHERE qcs01 = g_qcs.qcs01
         AND qcs02 = g_qcs.qcs02
         AND (qcs09='1' OR qcs09='3')
         AND qcs14 = 'Y'   #No.MOD-970026
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
      IF cl_null(l_qcs38 ) THEN LET l_qcs38 =0 END IF
      IF cl_null(l_qcs41 ) THEN LET l_qcs41 =0 END IF
      UPDATE inb_file 
         SET inb09 = l_qcs091,
             inb904= l_qcs38 ,
             inb907= l_qcs41 
       WHERE inb01 = g_qcs.qcs01
         AND inb03 = g_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","inb_file",g_qcs.qcs01,g_qcs.qcs02,STATUS,"","upd inb09",1)
         LET g_success = 'N'
      END IF
   END IF
 
END FUNCTION
 
#依據不同傳參Default Form 初值
FUNCTION t110_form_default()
   DEFINE l_items       LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(100)
 
   LET l_items = NULL
 
   IF g_argv1 = "2" THEN
      LET l_items = 'A:',cl_getmsg('aqc-999',g_lang)
      LET l_items = l_items CLIPPED,',B:',cl_getmsg('aqc-998',g_lang)
      LET l_items = l_items CLIPPED,',C:',cl_getmsg('aqc-997',g_lang)
      LET l_items = l_items CLIPPED,',D:',cl_getmsg('aqc-996',g_lang)
      LET l_items = l_items CLIPPED,',E:',cl_getmsg('aqc-995',g_lang)
      LET l_items = l_items CLIPPED,',F:',cl_getmsg('aqc-994',g_lang)
      LET l_items = l_items CLIPPED,',G:',cl_getmsg('aqc-993',g_lang)
      LET l_items = l_items CLIPPED,',H:',cl_getmsg('axm-113',g_lang)   #No.FUN-740016
      LET l_items = l_items CLIPPED,',Z:',cl_getmsg('sub-067',g_lang)
      CALL cl_set_combo_items("qcs00","A,B,C,D,E,F,G,H,Z",l_items CLIPPED)   #No.FUN-740016
      LET l_items = NULL
      LET l_items = cl_getmsg('aqc-989',g_lang)
      CALL cl_set_comp_att_text("qcs01",l_items CLIPPED)
   END IF
 
   IF g_argv1 = "3" THEN
      LET l_items = '5:',cl_getmsg('aqc-992',g_lang)
      LET l_items = l_items CLIPPED,',6:',cl_getmsg('aqc-991',g_lang)
      CALL cl_set_combo_items("qcs00","5,6",l_items CLIPPED)
      LET l_items = NULL
      LET l_items = cl_getmsg('aqc-990',g_lang)
      LET l_items = l_items CLIPPED,',',cl_getmsg('sub-115',g_lang)
      CALL cl_set_comp_att_text("qcs01,qcs03",l_items CLIPPED)
      CALL cl_set_comp_visible("pmh05",FALSE)
   END IF
 
   IF g_argv1 = "4" THEN
      LET l_items = '2:',cl_getmsg('asr-038',g_lang)
      LET l_items = l_items,',7:',cl_getmsg('asr-014',g_lang)
      CALL cl_set_combo_items("qcs00","2,7",l_items CLIPPED)
      LET l_items = NULL
      LET l_items = cl_getmsg('asr-015',g_lang)
      CALL cl_set_comp_att_text("qcs01",l_items CLIPPED)
   END IF
END FUNCTION
 
FUNCTION t110_def_form()   
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-619',g_lang) RETURNING g_msg2
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs33",g_msg CLIPPED)
       CALL cl_getmsg('asm-353',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs34",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs30",g_msg CLIPPED)
       CALL cl_getmsg('asm-354',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs31",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs32",g_msg CLIPPED)
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs39",g_msg CLIPPED)
       CALL cl_getmsg('asm-353',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs40",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs41",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs36",g_msg CLIPPED)
       CALL cl_getmsg('asm-354',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs37",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs38",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-619',g_lang) RETURNING g_msg2
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs33",g_msg CLIPPED)
       CALL cl_getmsg('asm-355',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs34",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs35",g_msg CLIPPED)
       CALL cl_getmsg('asm-620',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs30",g_msg CLIPPED)
       CALL cl_getmsg('asm-621',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs31",g_msg CLIPPED)
       CALL cl_getmsg('asm-622',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("qcs32",g_msg CLIPPED)
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs39",g_msg CLIPPED)
       CALL cl_getmsg('asm-355',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs40",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs41",g_msg CLIPPED)
       CALL cl_getmsg('asm-620',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs36",g_msg CLIPPED)
       CALL cl_getmsg('asm-621',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs37",g_msg CLIPPED)
       CALL cl_getmsg('asm-622',g_lang) RETURNING g_msg
       LET g_msg = g_msg,g_msg2
       CALL cl_set_comp_att_text("qcs38",g_msg CLIPPED)
    END IF
END FUNCTION
FUNCTION t110_qcs01() #MOD-740273
   DEFINE l_err     LIKE ze_file.ze01,
          l_rvaconf LIKE rva_file.rvaconf,
          l_imm03   LIKE imm_file.imm03,
          l_imm10   LIKE imm_file.imm10,
          l_immconf LIKE imm_file.immconf,        #TQC-670064
          l_cnt     LIKE type_file.num5           #TQC-740264 add
 
   LET l_err = NULL
   CASE g_argv1
      WHEN "1"
         IF g_qcs.qcs00='1' THEN #OR p_p = 'Y' THEN #MOD-740273
            SELECT rvaconf INTO l_rvaconf
              FROM rva_file
             WHERE rva01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            ELSE
               IF l_rvaconf !='Y' THEN
                  LET l_err = '9029'
                  EXIT CASE
               END IF
            END IF
            SELECT * FROM rvb_file
             WHERE rvb01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
      WHEN "2"
         IF g_qcs.qcs00 MATCHES '[AB]' THEN
            IF g_qcs.qcs00 = 'A'  THEN
               SELECT inaconf,inapost INTO l_rvaconf,l_imm03 #FUN-660079 #TQC-670064
                 FROM ina_file
                WHERE ina01 = g_qcs.qcs01
                  AND (ina00 = '1' OR ina00 = '2')
            ELSE
               SELECT inaconf,inapost INTO l_rvaconf,l_imm03 #FUN-660079 #TQC-670064
                 FROM ina_file
                WHERE ina01 = g_qcs.qcs01
                  AND (ina00 = '3' OR ina00 = '4')
            END IF
            IF SQLCA.sqlcode THEN
               LET l_err = 'abx-004'
               EXIT CASE
            ELSE
               IF l_rvaconf = 'X' THEN
                  LET l_err = '9024'
                  EXIT CASE
               END IF
               IF l_rvaconf = 'N' THEN
                  LET l_err = 'aap-717'
                  EXIT CASE
               END IF
               IF l_imm03 = 'Y' THEN #TQC-670064
                  LET l_err = 'asf-812'
                  EXIT CASE
               END IF
            END IF
            SELECT * FROM inb_file
             WHERE inb01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
         IF g_qcs.qcs00 MATCHES '[CD]' THEN
            SELECT imm04,imm03,imm10,immconf #TQC-670064
              INTO l_rvaconf,l_imm03,l_imm10,l_immconf #TQC-670064
              FROM imm_file
             WHERE imm01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = 'mfg3384'
               EXIT CASE
            END IF
            IF g_qcs.qcs00 = 'C' THEN
               IF l_imm10 != '1' THEN
                  IF l_rvaconf = 'X' THEN
                     LET l_err = '9024'
                     EXIT CASE
                  END IF
                  #IF l_rvaconf = 'Y' THEN #CHI-CA0040
                  IF l_rvaconf = 'Y' AND l_imm03 = 'Y' THEN  #CHI-CA0040
                     LET l_err = 'asf-812'
                     EXIT CASE
                  END IF
               ELSE
                  IF l_immconf = 'X' THEN #TQC-670064
                     LET l_err = '9024'
                     EXIT CASE
                  END IF
                  IF l_immconf = 'N' THEN #TQC-670064
                     LET l_err = 'aap-717'
                     EXIT CASE
                  END IF
                  IF l_imm03 = 'Y' THEN
                     LET l_err = 'aim-100'
                     EXIT CASE
                  END IF
               END IF
            END IF
            IF g_qcs.qcs00 = 'D' THEN
               IF l_rvaconf = 'Y' THEN   #CHI-690047
                  LET l_err = 'aim-393'
                  EXIT CASE
               END IF
               IF l_imm03 = 'Y' THEN
                  LET l_err = 'aim-100'
                  EXIT CASE
               END IF
            END IF
            SELECT * FROM imn_file
             WHERE imn01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
         IF g_qcs.qcs00 = 'E' THEN
            SELECT imoconf,imopost INTO l_rvaconf,l_imm03
              FROM imo_file
             WHERE imo01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = 'aim-410'
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf = 'N' THEN
               LET l_err = 'aap-717'
               EXIT CASE
            END IF
            IF l_imm03 = 'Y' THEN
               LET l_err = 'asf-812'
               EXIT CASE
            END IF
            SELECT * FROM imp_file
             WHERE imp01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
         IF g_qcs.qcs00 = 'F' THEN
            SELECT imrconf,imrpost INTO l_rvaconf,l_imm03 #TQC-670064
              FROM imr_file
             WHERE imr01 = g_qcs.qcs01
               AND imr00 = '1'         #No.TQC-660073 add
            IF STATUS THEN
               LET l_err = 'aap-091'
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf = 'N' THEN
               LET l_err = 'aap-717'
               EXIT CASE
            END IF
            IF l_imm03 = 'Y' THEN #TQC-670064
               LET l_err = 'asf-812'
               EXIT CASE
            END IF
            SELECT * FROM imq_file
             WHERE imq01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
         IF g_qcs.qcs00 = 'G' THEN
            SELECT qsa08 INTO l_rvaconf
              FROM qsa_file
             WHERE qsa01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = 'aqc-987'   #FUN-640058
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf = 'N' THEN
               LET l_err = 'aap-717'
               EXIT CASE
            END IF
         END IF
         IF g_qcs.qcs00 = 'H' THEN
            SELECT ohaconf INTO l_rvaconf
              FROM oha_file
             WHERE oha01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = 'aqc-987'
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf = 'N' THEN
               LET l_err = 'aap-717'
               EXIT CASE
            END IF
         END IF
      WHEN "3"
         IF g_qcs.qcs00 = '5' THEN
            SELECT ogaconf,ogapost INTO l_rvaconf,l_imm03 #CHI-6A0059
              FROM oga_file
             WHERE oga01 = g_qcs.qcs01
               AND oga09 IN ('1','5')
            IF STATUS THEN
               LET l_err = 'axm-897'
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf != 'Y' THEN        
               LET l_err = '9029' #抓已確認
               EXIT CASE
            END IF
            IF l_imm03 = 'Y' THEN
               LET l_err = 'asf-812'
               EXIT CASE
            END IF
         ELSE
            SELECT ogaconf,ogapost INTO l_rvaconf,l_imm03
              FROM oga_file
             WHERE oga01 = g_qcs.qcs01
               AND oga09 IN ('2','3','4','6','7','8','A')  #No.FUN-610079 #MOD-B10110 add A
            IF STATUS THEN
               LET l_err = 'axm-892' ##TQC-C20071
               EXIT CASE
            END IF
            IF l_rvaconf = 'X' THEN
               LET l_err = '9024'
               EXIT CASE
            END IF
            IF l_rvaconf = 'N' THEN
               LET l_err = 'aap-717'
               EXIT CASE
            END IF
            IF l_imm03 = 'Y' THEN
               LET l_err = 'asf-812'
               EXIT CASE
            END IF
            SELECT * FROM ogb_file
             WHERE ogb01 = g_qcs.qcs01
            IF STATUS = 100 THEN
               LET l_err = 'mfg3070'
               EXIT CASE
            END IF
         END IF
      WHEN "4"
         IF g_qcs.qcs00='2' THEN
            LET l_err=NULL
            EXIT CASE
         END IF
         IF g_qcs.qcs00='7' THEN  #OR p_p = 'Y' THEN #MOD-740273
            SELECT srfconf INTO l_rvaconf
              FROM srf_file
             WHERE srf01 = g_qcs.qcs01
            IF STATUS THEN
               LET l_err = '100'
               EXIT CASE
            ELSE
               IF l_rvaconf !='Y' THEN
                  LET l_err = '9029'
                  EXIT CASE
               END IF
            END IF
            SELECT * FROM srg_file
             WHERE srg01 = g_qcs.qcs01
               AND srg15='Y'
            IF STATUS = 100 THEN
               LET l_err = '100'
               EXIT CASE
            END IF
         END IF
   END CASE
 
   RETURN l_err
 
END FUNCTION
 
FUNCTION t110_qcs02(p_cmd)                #MOD-C30339   增加p_cmd
   DEFINE l_qcs22  LIKE qcs_file.qcs22    #MOD-870270
   DEFINE l_qcs091 LIKE qcs_file.qcs091   #MOD-870270
   DEFINE l_ima44  LIKE ima_file.ima44    #FUN-BB0085
   DEFINE p_cmd    LIKE type_file.chr1    #MOD-C30339
 
   CASE
      WHEN g_qcs.qcs00 = '1' OR g_qcs.qcs00 = '2'
         SELECT rvb80,rvb81,rvb82,rvb83,rvb84,rvb85
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM rvb_file
          WHERE rvb01=g_qcs.qcs01
            AND rvb02=g_qcs.qcs02
          CALL t110_get_ecm04()  #MOD-890102
      WHEN g_qcs.qcs00 = 'A' OR g_qcs.qcs00 = 'B'
         SELECT inb902,inb903,inb904,inb905,inb906,inb907
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM inb_file
          WHERE inb01 = g_qcs.qcs01
            AND inb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'C'
         SELECT imn30,imn31,imn32,imn33,imn34,imn35
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM imn_file
          WHERE imn01 = g_qcs.qcs01
            AND imn02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'D'
         SELECT imn40,imn41,imn42,imn43,imn44,imn45
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM imn_file
          WHERE imn01 = g_qcs.qcs01
            AND imn02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'E'
         SELECT imp20,imp21,imp22,imp23,imp24,imp25
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM imp_file
          WHERE imp01 = g_qcs.qcs01
            AND imp02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'F'
         SELECT imq20,imq21,imq22,imq23,imq24,imq25
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM imq_file
          WHERE imq01 = g_qcs.qcs01
            AND imq02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'H'
         SELECT ohb910,ohb911,ohb912,ohb913,ohb914,ohb915
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM ohb_file
          WHERE ohb01 = g_qcs.qcs01
            AND ohb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = '5' OR g_qcs.qcs00 = '6'
         SELECT ogb910,ogb911,ogb912,ogb913,ogb914,ogb915
           INTO g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32,g_qcs.qcs33,
                g_qcs.qcs34,g_qcs.qcs35
           FROM ogb_file
          WHERE ogb01 = g_qcs.qcs01
            AND ogb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00='7'
          EXIT CASE
   END CASE
 
   IF g_qcs.qcs00 NOT MATCHES '[2Z56]' THEN   #MOD-870270
      # 若判斷qcs22=0 才重計會造成先入驗退量後打收貨單時,不會重計l_rvb07s, 造成送驗量不合理也沒控卡
         CALL t110_qcs22() RETURNING l_rvb07s
         #送驗量允許有小數位
         #MOD-C30339-add-str--
         IF p_cmd = 'a' THEN 
         SELECT SUM(qcs22) INTO g_qcs22s FROM qcs_file
          WHERE qcs01 = g_qcs.qcs01
            AND qcs02 = g_qcs.qcs02
            AND qcs14 != 'X'
            AND qcs00 IN ('1','A','B','C','D','E','F','G','H') 
         ELSE       
         #MOD-C30339-add-end--
         SELECT SUM(qcs22) INTO g_qcs22s FROM qcs_file
          WHERE qcs01 = g_qcs.qcs01
            AND qcs02 = g_qcs.qcs02
            AND qcs14 != 'X'
            AND qcs00 IN ('1','A','B','C','D','E','F','G','H')   #CHI-760018   #MOD-870270
            AND NOT qcs05 = g_qcs_o.qcs05       #TQC-C20213   
         END IF             #MOD-C30339
         IF STATUS OR g_qcs22s IS NULL THEN
            LET g_qcs22s = 0
         END IF
         LET g_qcs22=g_qcs22s #記錄取整數位數的送驗量
         LET g_qcs.qcs22 = l_rvb07s - g_qcs22s
         #FUN-BB0085-add-str--
         SELECT ima44 INTO l_ima44 FROM ima_file
          WHERE ima01 = g_qcs.qcs021
         LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)
         #FUN-BB0085-add-end--
         DISPLAY BY NAME g_qcs.qcs22
   END IF
   IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
         CALL t110_qcs22() RETURNING l_rvb07s
         SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file
          WHERE qcs01 = g_qcs.qcs01
            AND qcs02 = g_qcs.qcs02
            AND qcs14 = 'N'
            AND qcs00 IN ('5','6') 
         IF STATUS OR l_qcs22 IS NULL THEN
            LET l_qcs22 = 0
         END IF
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01 = g_qcs.qcs01
            AND qcs02 = g_qcs.qcs02
            AND qcs14 = 'Y'
            AND qcs00 IN ('5','6') 
         IF STATUS OR l_qcs091 IS NULL THEN
            LET l_qcs091 = 0
         END IF
         LET g_qcs22s = l_qcs22 + l_qcs091
         LET g_qcs22=g_qcs22s 
         LET g_qcs.qcs22 = l_rvb07s - g_qcs22s
         #FUN-BB0085-add-str--
         SELECT ima44 INTO l_ima44 FROM ima_file
          WHERE ima01 = g_qcs.qcs021
         LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)
         #FUN-BB0085-add-end--
         DISPLAY BY NAME g_qcs.qcs22
   END IF
 
   IF g_sma.sma115 = "Y" AND g_qcs22s <> 0 THEN
      IF g_ima906 = "3" THEN
         LET g_qcs.qcs32 = g_qcs.qcs22
         IF g_qcs.qcs34<>0 THEN
            LET g_qcs.qcs35 = g_qcs.qcs22/g_qcs.qcs34
         ELSE
            LET g_qcs.qcs35 = 0
         END IF
      ELSE
         LET g_qcs.qcs32 = g_qcs.qcs22 MOD g_qcs.qcs34
         LET g_qcs.qcs35 = (g_qcs.qcs22 - g_qcs.qcs32) / g_qcs.qcs34
      END IF
   END IF
 
   LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)   #FUN-BB0085
   LET g_qcs.qcs35 = s_digqty(g_qcs.qcs35,g_qcs.qcs33)   #FUN-BB0085
   DISPLAY BY NAME g_qcs.qcs30,g_qcs.qcs31,g_qcs.qcs32
   DISPLAY BY NAME g_qcs.qcs33,g_qcs.qcs34,g_qcs.qcs35
 
END FUNCTION
 
FUNCTION t110_qcs05()
   DEFINE l_rvbs        RECORD LIKE rvbs_file.*  #No.FUN-850100
   DEFINE l_qcs_rvbs06  LIKE rvbs_file.rvbs06  #No.FUN-850100
   DEFINE l_sql     STRING   #No.FUN-850100
   DEFINE l_rvbs09  LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_ogb17   LIKE ogb_file.ogb17         #MOD-C30811 add
   DEFINE i         LIKE type_file.num5         #MOD-C30811 add
   DEFINE l_ima930  LIKE ima_file.ima930   #DEV-D40021 --add
 
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_qcs.qcs021
      AND imaacti = "Y"

   #DEV-D40021 --add--str
   LET l_ima930 = ''
   SELECT ima930 INTO l_ima930 FROM ima_file
    WHERE ima01 = g_qcs.qcs021
   IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF 
   IF l_ima930 = 'Y' THEN RETURN END IF 
   #DEV-D40021 --add--end
   
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
      IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
         IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
            IF g_qcs.qcs00 MATCHES '[1BC]' THEN
               LET l_rvbs09 = 1  
            ELSE
               LET l_rvbs09 = -1  
            END IF
            DECLARE rvbs_qcs CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs01 = g_qcs.qcs01
                                           AND rvbs02 = g_qcs.qcs02
                                          #AND rvbs13 = 0              #MOD-C30811 mark
                                           AND rvbs00 <> g_prog
                                           AND rvbs09 = l_rvbs09 
            
            LET i = 0               #MOD-C30811 add
            FOREACH rvbs_qcs INTO l_rvbs.*
               IF STATUS THEN 
                  CALL cl_err('foreach rvbs qcs:',STATUS,1)
                  EXIT FOREACH
               END IF
            
               IF cl_null(l_rvbs.rvbs06) THEN
                  LET l_rvbs.rvbs06 = 0
               END IF
            
               IF cl_null(g_qcs.qcs05) THEN
                  SELECT SUM(rvbs06)
                    INTO l_qcs_rvbs06 FROM qcs_file,rvbs_file
                   WHERE qcs01 =g_qcs.qcs01 
                     AND qcs02 =g_qcs.qcs02
                     AND rvbs13=qcs05   #No.FUN-860045
                     AND qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs00 = g_prog
                     AND qcs14 !='X' 
                     AND qcs00 = '1'
                     AND rvbs09 = 1
               ELSE
                  SELECT SUM(rvbs06)
                    INTO l_qcs_rvbs06 FROM qcs_file,rvbs_file
                   WHERE qcs01 =g_qcs.qcs01 
                     AND qcs02 =g_qcs.qcs02
                     AND rvbs13=qcs05   #No.FUN-860045
                     AND qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs00 = g_prog
                     AND qcs14 !='X' 
                     AND qcs00 = '1'
                     AND rvbs09 = 1
                     AND qcs05 !=g_qcs.qcs05 
               END IF
            
               IF cl_null(l_qcs_rvbs06) THEN 
                  LET l_qcs_rvbs06 = 0
               END IF
            
              #MOD-C30811 str add-----
               IF g_qcs.qcs00 = 6 THEN
                  LET l_ogb17 = 'N'
                  SELECT ogb17 INTO l_ogb17 FROM ogb_file WHERE ogb01= g_qcs.qcs01 AND ogb03 = g_qcs.qcs02
                  IF l_ogb17 = 'Y' THEN
                     LET l_rvbs.rvbs022 = i
                     LET i = i +  1    
                  END IF
               END IF
              #MOD-C30811 end add-----

               LET l_rvbs.rvbs00 = g_prog
               LET l_rvbs.rvbs01 = g_qcs.qcs01
               LET l_rvbs.rvbs02 = g_qcs.qcs02
               LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_qcs_rvbs06 
               LET l_rvbs.rvbs09 = 1
               LET l_rvbs.rvbs10 = 0
               LET l_rvbs.rvbs11 = 0
               LET l_rvbs.rvbs12 = 0
               LET l_rvbs.rvbs13 = g_qcs.qcs05
               LET l_rvbs.rvbsplant = g_plant #FUN-980007
               LET l_rvbs.rvbslegal = g_legal #FUN-980007 
               INSERT INTO rvbs_file VALUES (l_rvbs.*)
            
            END FOREACH
         END IF
      END IF
   END IF
 
END FUNCTION
 
#供應廠商
FUNCTION t110_qcs03()
   DEFINE m_pmc03      LIKE pmc_file.pmc03,
          m_pmh05      LIKE pmh_file.pmh05,       #No.FUN-680104 VARCHAR(01)
         #m_pmh05_desc VARCHAR(06),
          m_pmh05_desc LIKE ze_file.ze03,   #No.TQC-610007
         #m_pmn041     LIKE pmn_file.pmn041,      #No.FUN-680104 VARCHAR(30)  #CHI-CB0019 mark
          m_qcs16      LIKE qcs_file.qcs16,       #No.FUN-680104 VARCHAR(01)
          p_ima02      LIKE ima_file.ima02,
          m_rvb03      LIKE rvb_file.rvb03,       #No.FUN-680104 SMALLINT
          m_rvb04      LIKE rvb_file.rvb04,
          m_ima15      LIKE ima_file.ima15,       #No.FUN-680104 VARCHAR(01)
          m_ima02      LIKE ima_file.ima02,
          m_ima021     LIKE ima_file.ima021,      #No.FUN-940103
          m_azf03      LIKE azf_file.azf03        #No.FUN-680104 VARCHAR(30)
 
   SELECT ima02,ima021,ima109,ima15,ima906   #No.FUN-620043   #No.FUN-940103 add ima021
     INTO m_ima02,m_ima021,m_ima109,m_ima15,g_ima906   #No.FUN-620043  #No.FUN-940103
     FROM ima_file
    WHERE ima01 = g_qcs.qcs021
   IF STATUS=100 THEN
      LET m_ima02 = ' '
      LET m_ima021= ' '   #No.FUN-940103
      LET m_ima109= ' '
      LET m_ima15 = ' '
   END IF
 
   SELECT azf03 INTO m_azf03 FROM azf_file
    WHERE azf01 = m_ima109
      AND azf02 = '8'
   IF STATUS THEN LET m_azf03=' ' END IF
 
   DISPLAY g_qcs.qcs021 TO qcs021       #---- 料件編號
   DISPLAY g_qcs.qcs03 TO qcs03         #---- 廠商編號
   DISPLAY m_ima15 TO FORMONLY.ima15    #---- 保稅
   DISPLAY m_ima109 TO FORMONLY.ima109  #---- 材料類別
   DISPLAY m_azf03 TO FORMONLY.azf03    #---- 類別說明
   DISPLAY g_ima101 TO ima101           #---- 檢驗水準   MOD-BC0060 add
 
   IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
      SELECT occ02 INTO m_pmc03
        FROM occ_file
       WHERE occ01 = g_qcs.qcs03
      SELECT obk12,obk14 INTO g_qcs.qcs21,g_qcs.qcs17
        FROM obk_file
       WHERE obk01 = g_qcs.qcs021
         AND obk02 = g_qcs.qcs03
     #str MOD-A20100 add
      IF SQLCA.sqlcode THEN
         SELECT ima100,ima102 INTO g_qcs.qcs21,g_qcs.qcs17
           FROM ima_file
          WHERE ima01=g_qcs.qcs021
      END IF
     #end MOD-A20100 add
   ELSE
      SELECT pmc03 INTO m_pmc03
        FROM pmc_file
       WHERE pmc01 = g_qcs.qcs03
      DECLARE pmh_cur1 CURSOR FOR
       SELECT pmh05,pmh09,pmh16
         FROM pmh_file
        WHERE pmh01 = g_qcs.qcs021
          AND pmh02 = g_qcs.qcs03
          AND pmh21 = g_ecm04           #CHI-860042  #MOD-930151 " "-->g_ecm04
          AND pmh22=g_type                                #CHI-860042   #MOD-890102 modify '1'->g_type
          AND pmh23 = ' '                                 #No.CHI-960033
         # AND pmhacti = 'Y'            #CHI-910021  #No.CHI-A10021 mark
 
      OPEN pmh_cur1
 
      FETCH pmh_cur1 INTO m_pmh05,g_qcs.qcs21,g_qcs.qcs17
     #IF STATUS=100 THEN                                                                        #MOD-B70116 mark
      IF STATUS=100 OR cl_null(m_pmh05) OR cl_null(g_qcs.qcs21) OR cl_null(g_qcs.qcs17) THEN    #MOD-B70116 add
         LET m_pmh05=' '
         SELECT pmc906,pmc907 INTO g_qcs.qcs21,g_qcs.qcs17
           FROM pmc_file
            WHERE pmc01 = g_qcs.qcs03
 
           #IF STATUS=100 THEN                                                  #MOD-B70116 mark
            IF STATUS=100 OR cl_null(g_qcs.qcs21) OR cl_null(g_qcs.qcs17) THEN  #MOD-B70116 add
               SELECT ima100,ima102 INTO g_qcs.qcs21,g_qcs.qcs17
                  FROM ima_file WHERE ima01=g_qcs.qcs021
               IF STATUS THEN
                  LET g_qcs.qcs21=' '
                  LET g_qcs.qcs17=' '
               END IF
            END IF
      END IF
 
      CASE m_pmh05
         WHEN '0' CALL cl_getmsg('aqc-010',g_lang) RETURNING m_pmh05_desc
         WHEN '1' CALL cl_getmsg('aqc-011',g_lang) RETURNING m_pmh05_desc
         WHEN '2' CALL cl_getmsg('aqc-012',g_lang) RETURNING m_pmh05_desc
      END CASE
      DISPLAY m_pmh05_desc TO FORMONLY.pmh05    # 核准狀態
   END IF
 
   IF cl_null(m_pmc03) THEN LET m_pmc03 = ' ' END IF
 
   IF cl_null(g_qcs.qcs21) THEN LET g_qcs.qcs21 = ' ' END IF
 
   IF cl_null(g_qcs.qcs17) THEN LET g_qcs.qcs17 = ' ' END IF
 
   CASE g_qcs.qcs21
      WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcs21_desc
      WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcs21_desc
      WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcs21_desc
   END CASE

   #----------CHI-BC0018 str add-----------------                                               
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2' 
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang
               
      WHEN '3'    
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang
      
      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file 
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc

      CASE g_qcs.qcs17
      WHEN '1'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcs17_desc= ' '
   END CASE
   DISPLAY qcs17_desc TO FORMONLY.qcs17_desc
   #----------CHI-BC0018 end add-----------------
 
   DISPLAY m_pmc03 TO FORMONLY.pmc03    #---- 廠商名稱
   DISPLAY g_qcs.qcs17 TO qcs17
   DISPLAY g_qcs.qcs21 TO qcs21
   DISPLAY qcs21_desc TO FORMONLY.qcs21_desc
 
   CASE g_qcs.qcs09
      WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
      WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING des1   #No:7706
      WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE
 
   DISPLAY des1 TO FORMONLY.des1
 
   IF g_qcs.qcs00 MATCHES '[127]' THEN #FUN-5C0114 add 7
      SELECT rvb03,rvb04
        INTO m_rvb03,m_rvb04
        FROM rvb_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
      IF STATUS=100 THEN
         LET m_rvb03=' '
         LET m_rvb04=' '
      END IF

     #CHI-CB0019---mod---S
     #SELECT pmn041,pmn63 INTO m_pmn041,m_qcs16
     # FROM pmn_file
     #WHERE pmn01 = m_rvb04
     #  AND pmn02 = m_rvb03

      SELECT pmn63 INTO m_qcs16
        FROM pmn_file
       WHERE pmn01 = m_rvb04
         AND pmn02 = m_rvb03
     #CHI-CB0019---mod---E

      IF STATUS=100 THEN
        #LET m_pmn041= m_ima02  #CHI-CB0019 mark
         LET m_qcs16 = 'N'
      END IF
   ELSE
     #LET m_pmn041= m_ima02     #CHI-CB0019 mark
      LET m_qcs16 = 'N'
   END IF
 
   DISPLAY m_ima02 TO FORMONLY.ima02    #---- 品名  #CHI-CB0019 mod pmn041->ima02
   DISPLAY m_ima021 TO FORMONLY.ima021  #No.FUN-940103 規格
   LET g_qcs.qcs16 = m_qcs16
   DISPLAY g_qcs.qcs16 TO qcs16
 
   SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01=g_qcs.qcs13
   DISPLAY m_gen02 TO FORMONLY.gen02
 
END FUNCTION
 
FUNCTION t110_qcs22()
   DEFINE l_rvb07         LIKE rvb_file.rvb07,      #No.FUN-680104 DEC(12,0)
          l_rvb07s        LIKE rvb_file.rvb07
 
   CASE
      WHEN g_qcs.qcs00 = '1'
         #收貨量允許有小數位
         SELECT rvb07 INTO l_rvb07s FROM rvb_file
          WHERE rvb01=g_qcs.qcs01 AND rvb02=g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'A' OR g_qcs.qcs00 = 'B'
         SELECT inb16 INTO l_rvb07s #FUN-870040
           FROM inb_file
          WHERE inb01 = g_qcs.qcs01
            AND inb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'C'
         SELECT imn10 INTO l_rvb07s
           FROM imn_file
          WHERE imn01 = g_qcs.qcs01
            AND imn02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'D'
         SELECT imn22 INTO l_rvb07s
           FROM imn_file
          WHERE imn01 = g_qcs.qcs01
            AND imn02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'E'
         SELECT imp04 INTO l_rvb07s
           FROM imp_file
          WHERE imp01 = g_qcs.qcs01
            AND imp02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'F'
         SELECT imq07 INTO l_rvb07s
           FROM imq_file
          WHERE imq01 = g_qcs.qcs01
            AND imq02 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = 'G'
         SELECT qsa06 INTO l_rvb07s
           FROM qsa_file
          WHERE qsa01 = g_qcs.qcs01
      WHEN g_qcs.qcs00 = 'H'
         SELECT ohb12 INTO l_rvb07s
           FROM ohb_file
          WHERE ohb01 = g_qcs.qcs01
            AND ohb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = '5' OR g_qcs.qcs00 = '6'
         SELECT ogb12 INTO l_rvb07s
           FROM ogb_file
          WHERE ogb01 = g_qcs.qcs01
            AND ogb03 = g_qcs.qcs02
      WHEN g_qcs.qcs00 = '7'
         SELECT srg05 INTO l_rvb07s
           FROM srg_file
          WHERE srg01 = g_qcs.qcs01
            AND srg02 = g_qcs.qcs02
   END CASE
 
   IF SQLCA.sqlcode OR l_rvb07s IS NULL THEN
      LET l_rvb07s = 0
   END IF
 
   LET l_rvb07 = l_rvb07s #記錄取整位數量 #No:8689
 
   RETURN l_rvb07
 
END FUNCTION
 
FUNCTION t110_asr_qcs021(p_qcs01,p_qcs02)
DEFINE p_qcs01 LIKE qcs_file.qcs01
DEFINE p_qcs02 LIKE qcs_file.qcs02
DEFINE l_ima907 LIKE ima_file.ima907,
       l_ima02  LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021,       #No.FUN-940103
       l_factor LIKE qcs_file.qcs34,        #No.FUN-680104 DECIMAL(16,8)
       l_flag   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
       l_srg04  LIKE srg_file.srg04,
       l_srg05  LIKE srg_file.srg05,
       l_qcs22  LIKE qcs_file.qcs22 #FUN-640036
 
   IF cl_null(p_qcs01) OR cl_null(p_qcs02) THEN
      LET g_qcs.qcs021=''
      LET g_qcs.qcs30=''
      LET g_qcs.qcs31=''
      LET g_qcs.qcs32=''
      LET g_qcs.qcs33=''
      LET g_qcs.qcs34=''
      LET g_qcs.qcs35=''
      LET l_ima02=''
      LET l_ima021=''    #No.FUN-940103
   ELSE
      SELECT srg14,srg04,srg05 INTO g_qcs.qcs021,l_srg04,l_srg05
                                     FROM srg_file WHERE srg01=p_qcs01
                                                     AND srg02=p_qcs02
 
      SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file
                                     WHERE qcs01=g_qcs.qcs01
                                       AND qcs02=g_qcs.qcs02
                                       AND qcs14<>'X'
                                       AND qcsacti='Y'
      IF SQLCA.sqlcode OR cl_null(l_qcs22) THEN
         LET l_qcs22=0
      END IF
      LET l_srg05=l_srg05-l_qcs22
      IF l_srg05<0 THEN
         LET l_srg05=0
      END IF
      SELECT ima02,ima021,ima906,ima907,ima109     #No.FUN-940103 add ima021
        INTO l_ima02,l_ima021,g_ima906,l_ima907,m_ima109   #No.FUN-940103
        FROM ima_file WHERE ima01=g_qcs.qcs021
 
      CASE
         WHEN g_ima906="1"
               LET g_qcs.qcs30=l_srg04
               LET g_qcs.qcs31=1
               LET g_qcs.qcs32=l_srg05
               LET g_qcs.qcs33=''
               LET g_qcs.qcs34=''
               LET g_qcs.qcs35=''
         WHEN g_ima906 MATCHES '[2,3]'
               LET g_qcs.qcs30=l_srg04
               LET g_qcs.qcs31=1
               LET g_qcs.qcs32=l_srg05
               LET g_qcs.qcs33=l_ima907
               CALL s_umfchk(g_qcs.qcs021,l_ima907,l_srg04) RETURNING l_flag,l_factor
               IF l_flag=1 THEN
                 LET l_factor=1
               END IF
               LET g_qcs.qcs34=l_factor
               LET g_qcs.qcs35=0
      END CASE
   END IF
   LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)   #FUN-BB0085
   LET g_qcs.qcs35 = s_digqty(g_qcs.qcs35,g_qcs.qcs33)   #FUN-BB0085
   DISPLAY BY NAME g_qcs.qcs021,g_qcs.qcs30,g_qcs.qcs31,
                   g_qcs.qcs32,g_qcs.qcs33,g_qcs.qcs34,
                   g_qcs.qcs35
   DISPLAY l_ima02 TO FORMONLY.ima02     #CHI-CB0019 mod pmn041->ima02
   DISPLAY l_ima021 TO FORMONLY.ima021   #No.FUN-940103
END FUNCTION
 
FUNCTION t110_upd_srg10(p_opt)
DEFINE p_opt    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(01)  # "+" OR "-'
DEFINE l_qcs091 LIKE qcs_file.qcs091
DEFINE l_sre10  LIKE sre_file.sre10,
       l_srf03  LIKE srf_file.srf03,
       l_srf04  LIKE srf_file.srf04,
       l_srf05  LIKE srf_file.srf05,
       l_srg03  LIKE srg_file.srg03,
       l_srg18  LIKE srg_file.srg18 #FUN-630105
DEFINE l_msg    STRING              #FUN-680011
 
   SELECT qcs091 INTO l_qcs091 FROM qcs_file WHERE qcs01=g_qcs.qcs01
                                               AND qcs02=g_qcs.qcs02
   IF cl_null(l_qcs091) THEN
      LET l_qcs091=0
   END IF
   SELECT srf03,srf04,srf05,srg03 INTO l_srf03,l_srf04,l_srf05,l_srg03
                               FROM srf_file,srg_file
                                             WHERE srf01=srg01
                                               AND srg01=g_qcs.qcs01
                                               AND srg02=g_qcs.qcs02
   SELECT sre10 INTO l_sre10 FROM sre_file WHERE sre03=l_srf03  #機台
                                             AND sre04=l_srg03  #料號
                                             AND sre05=l_srf04  #班別
                                             AND sre06=l_srf05  #計畫日
   IF cl_null(l_sre10) THEN
      LET l_sre10=0
   END IF
 
   CASE p_opt
      WHEN "+"
         LET l_sre10=l_sre10+l_qcs091
      WHEN "-"
         LET l_sre10=l_sre10-l_qcs091
      OTHERWISE
         RETURN
   END CASE
 
   UPDATE sre_file set sre10=l_sre10 WHERE sre03=l_srf03  #機台
                                       AND sre04=l_srg03  #料號
                                       AND sre05=l_srf04  #班別
                                       AND sre06=l_srf05  #計畫日
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN  #僅提示,繼續下面動作
       LET l_msg = cl_getmsg('9050',g_lang)
       LET l_msg="upd sre10 (sre_file) ",l_msg CLIPPED
       CALL cl_msgany(10,20,l_msg)
   END IF
 
   IF g_qcs.qcs00='7' THEN
      SELECT srg18 INTO l_srg18 FROM srg_file WHERE srg01=g_qcs.qcs01
                                                AND srg02=g_qcs.qcs02
      IF cl_null(l_srg18) THEN
         LET l_srg18=0
      END IF
      CASE p_opt
         WHEN "+"
            LET l_srg18=l_srg18+l_qcs091
         WHEN "-"
            LET l_srg18=l_srg18-l_qcs091
         OTHERWISE
            RETURN
      END CASE
      UPDATE srg_file set srg18=l_srg18 WHERE srg01=g_qcs.qcs01
                                          AND srg02=g_qcs.qcs02
      IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
         CALL cl_err3("upd","srg_file",g_qcs.qcs01,g_qcs.qcs02,"9050","","upd srg18",1)  #No.FUN-660115
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t110_set_qcs22()
DEFINE l_ima44  LIKE ima_file.ima44      #FUN-BB0085

   IF cl_null(g_qcs.qcs31) THEN LET g_qcs.qcs31 = 0 END IF
   IF cl_null(g_qcs.qcs32) THEN LET g_qcs.qcs32 = 0 END IF
   IF cl_null(g_qcs.qcs34) THEN LET g_qcs.qcs34 = 0 END IF
   IF cl_null(g_qcs.qcs35) THEN LET g_qcs.qcs35 = 0 END IF

   IF g_sma.sma115='Y' THEN
      CASE g_ima906 
         WHEN "1"
            LET g_qcs.qcs22 = g_qcs.qcs32 * g_qcs.qcs31
         WHEN "2"
            LET g_qcs.qcs22 = g_qcs.qcs35 * g_qcs.qcs34 +
                              g_qcs.qcs32 * g_qcs.qcs31
         WHEN "3"
            LET g_qcs.qcs22 = g_qcs.qcs32 * g_qcs.qcs31 #TQC-660136
      END CASE
   ELSE
      LET g_qcs.qcs22 = g_qcs.qcs32 * g_qcs.qcs31
   END IF
   #FUN-BB0085-add-str--
   SELECT ima44 INTO l_ima44 FROM ima_file
    WHERE ima01 = g_qcs.qcs021
   LET g_qcs.qcs22 = s_digqty(g_qcs.qcs22,l_ima44)
   #FUN-BB0085-add-end--
   DISPLAY BY NAME g_qcs.qcs22
END FUNCTION
 
FUNCTION t110_w() #same as asrt300
   SELECT * INTO g_qcs.* FROM qcs_file WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02 AND qcs05 = g_qcs.qcs05  #liuxqa 091022 
   IF g_qcs.qcs14 = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_qcs.qcs14 <>'Y' THEN CALL cl_err(' ','9029',0) RETURN END IF
   IF g_qcs.qcs00 <>'7' THEN CALL cl_err(' ','asr-043',0) RETURN END IF
   IF NOT cl_null(g_qcs.qcs20) THEN
      CALL cl_err(' ','asr-042',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   LET g_success='Y'    #MOD-710120 add
   OPEN t110_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05   #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t110_w1()
   CLOSE t110_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT qcs20 INTO g_qcs.qcs20 FROM qcs_file WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02 AND qcs05 = g_qcs.qcs05 #liuxqa 091022 
      DISPLAY g_qcs.qcs20 TO qcs20
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION
 
FUNCTION t110_w1()
DEFINE l_t1         LIKE sfv_file.sfv01,       #No.FUN-680104 VARCHAR(5)
       li_result    LIKE type_file.num5,       #No.FUN-680104 SMALLINT
       l_imd02      LIKE imd_file.imd02,
       l_srg RECORD LIKE srg_file.*,
       l_sfu RECORD LIKE sfu_file.*
DEFINE l_slip       LIKE smy_file.smyslip  #TQC-AC0294
DEFINE l_smy73      LIKE type_file.chr1    #TQC-AC0294
          
   OPEN WINDOW t110_w1_w AT 2,2 WITH FORM "aqc/42f/aqct110a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aqct110a")
   LET tm.l_date=g_today                      #NO.FUN-6A0160 date->l_date
   LET tm.slip=null
 
   WHILE TRUE
     INPUT BY NAME tm.slip,tm.l_date,tm.wh1,tm.wh2,tm.wh3    #NO.FUN-6A0160 date->l_date
                   WITHOUT DEFAULTS
 
       AFTER FIELD slip
          IF NOT cl_null(tm.slip) THEN
             CALL s_check_no("asf",tm.slip,'',"A","sfu_file","sfu01","")
                    RETURNING li_result,tm.slip
             IF (NOT li_result) THEN
                NEXT FIELD slip
             END IF
              #TQC-AC0294------start------
              LET l_slip = s_get_doc_no(tm.slip)
 
              SELECT smy73 INTO l_smy73 FROM smy_file
               WHERE smyslip = l_slip
              
              IF l_smy73 = 'Y' THEN
              CALL cl_err(tm.slip,'asf-876',0)
              NEXT FIELD slip
              END IF
              #TQC-AC0294-------END--------
          END IF
 
       AFTER FIELD wh1
           IF tm.wh1 IS NOT NULL THEN
              SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = tm.wh1
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",tm.wh1,"",STATUS,"","sel imd",1)  #No.FUN-660115
                 NEXT FIELD wh1
              END IF
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(slip)
 	        LET l_t1 = s_get_doc_no(tm.slip)
 	        LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add
                CALL q_smy( FALSE,TRUE,l_t1,'ASF','A') RETURNING l_t1 #TQC-670008
                LET tm.slip=l_t1
                DISPLAY BY NAME tm.slip
                NEXT FIELD slip
             WHEN INFIELD(wh1)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_imd"
                LET g_qryparam.arg1 = 'SW'        #倉庫類別
                CALL cl_create_qry() RETURNING tm.wh1
                DISPLAY BY NAME tm.wh1
                NEXT FIELD wh1
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
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_success='N'
        CLOSE WINDOW t110_w1_w
        RETURN
     END IF
 
     LET g_success='Y'
 
     DECLARE t110_w1_cur CURSOR FOR SELECT * FROM srg_file
                                            WHERE srg01=g_qcs.qcs01
                                              AND srg02=g_qcs.qcs02
     OPEN t110_w1_cur
     FETCH t110_w1_cur INTO l_srg.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        CLOSE WINDOW t110_w1_w
        RETURN
     END IF
 
     IF cl_null(tm.wh2) THEN
        LET tm.wh2=' '
     END IF
     IF cl_null(tm.wh3) THEN
        LET tm.wh3=' '
     END IF
 
     INITIALIZE l_sfu.* TO NULL
     CALL s_auto_assign_no("apm",tm.slip,tm.l_date,"A","sfu_file","sfu01","","","")     #NO.FUN-6A0160 date->l_date 
        RETURNING li_result,tm.slip
     IF (NOT li_result) THEN
        LET g_success='N'
        CALL cl_err('sfp01',"sub-143",1)
     END IF
 
     LET l_sfu.sfu00='3'              #重覆性生產入庫
     LET l_sfu.sfu01=tm.slip
     LET l_sfu.sfu02=tm.l_date        #NO.FUN-6A0160 date->l_date
     LET l_sfu.sfu14=tm.l_date         #FUN-860069
     LET l_sfu.sfu04=g_grup
     LET l_sfu.sfupost='N'
     LET l_sfu.sfuuser=g_user
     LET l_sfu.sfugrup=g_grup
     LET l_sfu.sfumodu=''
     LET l_sfu.sfudate=g_today
     LET l_sfu.sfuplant = g_plant #FUN-980007
     LET l_sfu.sfulegal = g_legal #FUN-980007
     LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
     LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04
     #FUN-A80128---add---str--
     LET l_sfu.sfu15   = '0'
     LET l_sfu.sfu16   = g_user
     LET l_sfu.sfumksg = 'N' 
     #FUN-A80128---add---end--
     INSERT INTO sfu_file VALUES (l_sfu.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","sfu_file",l_sfu.sfu01,"",SQLCA.sqlcode,"","ins sfu",1)  #No.FUN-660115
        LET g_success='N'
     END IF
 
     CALL t110_w2(l_srg.*,1,g_qcs.qcs091)
     UPDATE srg_file set srg11=tm.slip WHERE srg01=l_srg.srg01
                                         AND srg02=l_srg.srg02
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","srg_file",l_srg.srg01,l_srg.srg02,SQLCA.sqlcode,"","upd srg11",1)  #No.FUN-660115
        LET g_success='N'
     END IF
     
     UPDATE qcs_file set qcs20=tm.slip WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02 AND qcs05 = g_qcs.qcs05 #liuxqa 091022 
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","upd qcs20",1)  #No.FUN-660115
        LET g_success='N'
     END IF
 
     MESSAGE ""
     CLOSE WINDOW t110_w1_w
     EXIT WHILE
 
   END WHILE   
END FUNCTION
 
FUNCTION t110_w2(l_srg,l_sfv03,l_sfv09)
DEFINE l_srg        RECORD LIKE srg_file.*,
       l_sfv        RECORD LIKE sfv_file.*,
       l_sfv03      LIKE sfv_file.sfv03,
       l_sfv09      LIKE sfv_file.sfv09,
       l_ima906     LIKE ima_file.ima906,
       l_ima907     LIKE ima_file.ima907,
       l_factor     LIKE qcs_file.qcs34,     #No.FUN-680104 DECIMAL(16,8)
       l_flag       LIKE type_file.num5,     #No.FUN-680104 SMALLINT
       l_sfu04      LIKE sfu_file.sfu04,     #FUN-CB0087 add
       l_sfu16      LIKE sfu_file.sfu16      #FUN-CB0087 add
DEFINE l_sfvi       RECORD LIKE sfvi_file.*  #FUN-B70074 add
 
   LET l_sfv.sfv01=tm.slip
   LET l_sfv.sfv03=l_sfv03
   LET l_sfv.sfv04=l_srg.srg14
   LET l_sfv.sfv05=tm.wh1
   LET l_sfv.sfv06=tm.wh2
   LET l_sfv.sfv07=tm.wh3
   LET l_sfv.sfv08=l_srg.srg04
   LET l_sfv.sfv09=l_sfv09
   LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086
   LET l_sfv.sfv11=l_srg.srg03  #(重覆性生產 此欄是 生產料號)
   LET l_sfv.sfv14=l_srg.srg02  #(重覆性生產 此欄是 報工單項次)
   LET l_sfv.sfv16=l_srg.srg13  #(重覆性生產 此欄是 1.主/2.聯/3.副/4.再生產品)
   LET l_sfv.sfv17=l_srg.srg01  #(重覆性生產 此欄是 報工單單號)
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
                                     WHERE ima01=l_sfv.sfv04
   CASE
      WHEN l_ima906='1'
         LET l_sfv.sfv30=l_srg.srg04
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_srg.srg05
         LET l_sfv.sfv33=''
         LET l_sfv.sfv34=''
         LET l_sfv.sfv35=''
      WHEN l_ima906 MATCHES '[2,3]'
         LET l_sfv.sfv30=l_srg.srg04
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_srg.srg05
         LET l_sfv.sfv33=l_ima907
         CALL s_umfchk(l_sfv.sfv04,l_ima907,l_sfv.sfv08) RETURNING l_flag,l_factor
         IF l_flag=1 THEN
           LET l_factor=1
         END IF
         LET l_sfv.sfv34=l_factor
         LET l_sfv.sfv35=0
   END CASE
   LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
   LET l_sfv.sfv930=s_costcenter(g_grup) #FUN-680006
   LET l_sfv.sfvplant = g_plant #FUN-980007
   LET l_sfv.sfvlegal = g_legal #FUN-980007
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT sfu04,sfu16 INTO l_sfu04,l_sfu16 FROM sfu_file WHERE sfu01 = l_sfv.sfv01
      CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu16,l_sfu04) RETURNING l_sfv.sfv44
      IF cl_null(l_sfv.sfv44) THEN
         CALL cl_err('','aim-425',1)
         LET g_success='N'
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfv_file VALUES (l_sfv.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","sfv_file",l_sfv.sfv01,l_sfv.sfv03,SQLCA.sqlcode,"","ins sfv",1)  #No.FUN-660115
      LET g_success='N'
#FUN-B70074--add--insert--
   ELSE
      INITIALIZE l_sfvi.* TO NULL
      LET l_sfvi.sfvi01 = l_sfv.sfv01
      LET l_sfvi.sfvi03 = l_sfv.sfv03
      IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
         LET g_success='N'
      END IF
#FUN-B70074--add--insert--
   END IF
END FUNCTION
 
FUNCTION t110_v()
DEFINE l_cmd STRING,
       l_ima903 LIKE ima_file.ima903
 
   IF cl_null(g_qcs.qcs01) OR cl_null(g_qcs.qcs02) OR 
      cl_null(g_qcs.qcs05) THEN
      RETURN
   END IF
 
   SELECT * INTO g_qcs.* FROM qcs_file WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02 AND qcs05 = g_qcs.qcs05 #liuxqa 091022 
   IF g_qcs.qcs14 = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_qcs.qcs14 <>'Y' THEN CALL cl_err(' ','9029',0) RETURN END IF
   IF g_qcs.qcs00 <>'7' THEN CALL cl_err(' ','asr-043',0) RETURN END IF
   LET l_ima903 = NULL
   SELECT ima903 INTO l_ima903 FROM ima_file
      WHERE ima01 = g_qcs.qcs021
 
   IF l_ima903<>'Y' THEN
      CALL cl_err('','aqc-404',0)
      RETURN
   END IF
   LET l_cmd="asrt303 '",g_qcs.qcs01 clipped,"' '",g_qcs.qcs02,"' ",g_qcs.qcs05
   CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
END FUNCTION
 
#取得尚未送驗的數量
FUNCTION t110_unqc_qty()
   DEFINE l_unqc_qty    LIKE rvb_file.rvb07
   DEFINE l_rvb07       LIKE rvb_file.rvb07
   DEFINE l_qcs22       LIKE qcs_file.qcs22
   DEFINE l_inb09       LIKE inb_file.inb09,
          l_imn10       LIKE imn_file.imn10,
          l_imp04       LIKE imp_file.imp04,
          l_imq07       LIKE imq_file.imq07,
          l_qsa06       LIKE qsa_file.qsa06,
          l_ohb12       LIKE ohb_file.ohb12
 
   LET g_errno = ''
   IF g_qcs.qcs00='1' THEN
      SELECT rvb07 
        INTO l_rvb07 
        FROM rvb_file
       WHERE rvb01=g_qcs.qcs01 
         AND rvb02=g_qcs.qcs02
      IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = '1'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = '1'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
      LET l_unqc_qty = l_rvb07-l_qcs22
      IF l_unqc_qty <= 0 THEN
         #此料已全部送驗!  
         #此收貨單+項次送驗資料皆已登打,請重新輸入!
         LET g_errno = 'aqc-114'
      END IF
   END IF
 
   IF g_qcs.qcs00='A' THEN
      SELECT inb16 #FUN-870040 
        INTO l_inb09 
        FROM inb_file
       WHERE inb01=g_qcs.qcs01 
         AND inb03=g_qcs.qcs02
      IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'A'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'A'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_inb09-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='B' THEN
      SELECT inb16  #FUN-870040
        INTO l_inb09 
        FROM inb_file
       WHERE inb01=g_qcs.qcs01 
         AND inb03=g_qcs.qcs02
      IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'B'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'B'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_inb09-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='C' THEN
      SELECT imn10 
        INTO l_imn10 
        FROM imn_file
       WHERE imn01=g_qcs.qcs01 
         AND imn02=g_qcs.qcs02
      IF cl_null(l_imn10) THEN LET l_imn10 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'C'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'C'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imn10-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='D' THEN
      SELECT imn10 
        INTO l_imn10 
        FROM imn_file
       WHERE imn01=g_qcs.qcs01 
         AND imn02=g_qcs.qcs02
      IF cl_null(l_imn10) THEN LET l_imn10 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'D'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'D'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imn10-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='E' THEN
      SELECT imp04 
        INTO l_imp04 
        FROM imp_file
       WHERE imp01=g_qcs.qcs01 
         AND imp02=g_qcs.qcs02
      IF cl_null(l_imp04) THEN LET l_imp04 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'E'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'E'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imp04-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='F' THEN
      SELECT imq07 
        INTO l_imq07 
        FROM imq_file
       WHERE imq01=g_qcs.qcs01 
         AND imq02=g_qcs.qcs02
      IF cl_null(l_imq07) THEN LET l_imq07 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'F'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'F'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imq07-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='G' THEN
      SELECT qsa06 
        INTO l_qsa06 
        FROM qsa_file
       WHERE qsa01=g_qcs.qcs01 
      IF cl_null(l_qsa06) THEN LET l_qsa06 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'G'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'G'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_qsa06-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF g_qcs.qcs00='H' THEN
      SELECT ohb12 
        INTO l_ohb12 
        FROM ohb_file
       WHERE ohb01=g_qcs.qcs01 
         AND ohb03=g_qcs.qcs02
      IF cl_null(l_ohb12) THEN LET l_ohb12 = 0 END IF
      IF cl_null(g_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'H'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =g_qcs.qcs01 
             AND qcs02 =g_qcs.qcs02
             AND qcs05 !=g_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'H'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_ohb12-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
   IF NOT cl_null(g_qcs.qcs22) THEN
      IF g_qcs.qcs22 > l_unqc_qty THEN
         #本次檢驗量>剩余檢驗量
         LET g_errno = 'aqc-037'
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_spc()
   LET g_success = 'Y'
 
   CALL t110_y_chk()          #CALL 原確認的 check 段
   IF g_success = "N" THEN
       RETURN
   END IF
 
   #檢查資料是否可拋轉至 SPC
   #CALL aws_spccli_qc_chk('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_qc_chk(g_qcs.qcs01,g_qcs.qcsspc,g_qcs.qcs14,'')
   IF g_success = 'N' THEN
       RETURN
   END IF
   
 
   # CALL aws_spccli()
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(
   #           (3)功能選項：insert(新增),update(修改),delete(刪除)
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(g_prog,base.TypeInfo.create(g_qcs),'insert')
   THEN
         LET g_qcs.qcsspc = '1'
   ELSE
         LET g_qcs.qcsspc = '2'
   END IF
 
   DISPLAY BY NAME g_qcs.qcsspc
 
   #更改前端單據SPC拋轉碼
   CALL t110_updspc()                  
 
END FUNCTION
 
FUNCTION t110_updspc()
DEFINE l_cnt             LIKE type_file.num10,        #No.FUN-680104 INTEGER
       l_qc_cnt          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE l_spc             LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
DEFINE l_tabname         STRING
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
          RETURN
   END IF
   #需要 QC 檢驗的筆數
   IF g_argv1 = '1' THEN
      SELECT COUNT(*) INTO l_qc_cnt FROM rvb_file
          WHERE rvb01 = g_qcs.qcs01 AND rvb39 = 'Y' AND rvb19 = '1'
   END IF
   IF g_argv1 = '2' THEN
     CASE 
       WHEN (g_qcs.qcs00 = "A") OR (g_qcs.qcs00 ="B")
         SELECT COUNT(*) INTO l_qc_cnt FROM inb_file
           WHERE inb01 = g_qcs.qcs01 AND inb10 = 'Y' 
       WHEN (g_qcs.qcs00 ="C") OR (g_qcs.qcs00 ="D")
         SELECT COUNT(*) INTO l_qc_cnt FROM imn_file
           WHERE imn01 = g_qcs.qcs01 AND imn29 = 'Y' 
       WHEN g_qcs.qcs00 ="E"
         SELECT COUNT(*) INTO l_qc_cnt FROM imp_file
           WHERE imp01 = g_qcs.qcs01 AND imp15 = 'Y' 
       WHEN g_qcs.qcs00 ="F"
         SELECT COUNT(*) INTO l_qc_cnt FROM imq_file
           WHERE imq01 = g_qcs.qcs01 AND imq15 = 'Y' 
       WHEN g_qcs.qcs00 ="G"
         SELECT COUNT(*) INTO l_qc_cnt FROM qsa_file
          WHERE qsa01 = g_qcs.qcs01 
       WHEN g_qcs.qcs00 ="H"
         SELECT COUNT(*) INTO l_qc_cnt FROM ohb_file
          WHERE ohb01 = g_qcs.qcs01 AND ohb61='Y'
     END CASE
    END IF
    IF g_argv1 = '3' THEN
       SELECT COUNT(*) INTO l_qc_cnt FROM ogb_file
         WHERE ogb01 = g_qcs.qcs01 AND ogb19='Y'
    END IF
    IF g_argv1 = '4' THEN
       SELECT COUNT(*) INTO l_qc_cnt FROM srg_file
         WHERE srg01 = g_qcs.qcs01 AND srg15='Y'
    END IF
 
 
   # QC 單已拋轉至 SPC 的筆數
   SELECT COUNT(*) INTO l_cnt FROM qcs_file 
      WHERE qcs01 = g_qcs.qcs01 AND qcsspc = '1' 
 
   LET l_spc = ""
   IF l_qc_cnt = l_cnt THEN
      LET l_spc = '1'     
   ELSE
      CASE 
        WHEN l_cnt = 0 
          LET l_spc = '0'     
        WHEN l_cnt > 0 
          LET l_spc = '3'     
      END CASE
   END IF
 
   #將 QC 單的 SPC 拋轉碼的狀況回饋至前端單據
   IF NOT cl_null(l_spc) THEN
      IF g_argv1 = '1' THEN
         LET l_tabname = "rva_file"
         UPDATE rva_file set rvaspc = l_spc WHERE rva01 = g_qcs.qcs01
      END IF
      IF g_argv1 = '2' THEN
        CASE 
          WHEN (g_qcs.qcs00 = "A") OR (g_qcs.qcs00 ="B")
            LET l_tabname = "ina_file"
            UPDATE ina_file set inaspc = l_spc WHERE ina01 = g_qcs.qcs01
          WHEN (g_qcs.qcs00 = "C") OR (g_qcs.qcs00 ="D")
            LET l_tabname = "imm_file"
            UPDATE imm_file set immspc = l_spc WHERE imm01 = g_qcs.qcs01
          WHEN g_qcs.qcs00 = "E"
            LET l_tabname = "imo_file"
            UPDATE imo_file set imospc = l_spc WHERE imo01 = g_qcs.qcs01
          WHEN g_qcs.qcs00 = "F"
            LET l_tabname = "imr_file"
            UPDATE imr_file set imrspc = l_spc WHERE imr01 = g_qcs.qcs01
          WHEN g_qcs.qcs00 = "G"
            LET l_tabname = "qsa_file"
            UPDATE qsa_file set qsaspc = l_spc WHERE qsa01 = g_qcs.qcs01
          WHEN g_qcs.qcs00 = "H"
            LET l_tabname = "oha_file"
            UPDATE oha_file set ohaspc = l_spc WHERE oha01 = g_qcs.qcs01
        END CASE
       END IF
       IF g_argv1 = '3' THEN
          LET l_tabname = "oga_file"
          UPDATE oga_file set ogaspc = l_spc WHERE oga01 = g_qcs.qcs01
       END IF
       IF g_argv1 = '4' THEN
          LET l_tabname = "srf_file"
          UPDATE srf_file set srfspc = l_spc WHERE srf01 = g_qcs.qcs01
       END IF
      
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd",l_tabname,g_qcs.qcs01,g_qcs.qcs01,SQLCA.sqlcode,"","",1)  
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t110_check_qc() #MOD-740273
DEFINE l_err           LIKE ze_file.ze01,             #No.FUN-5C0077
       l_rvb           RECORD LIKE rvb_file.*,
       l_inb           RECORD LIKE inb_file.*,        #No.FUN-5C0077
       l_imn           RECORD LIKE imn_file.*,        #No.FUN-5C0077
       l_imp           RECORD LIKE imp_file.*,        #No.FUN-5C0077
       l_imq           RECORD LIKE imq_file.*,        #No.FUN-5C0077
       l_qsa           RECORD LIKE qsa_file.*,        #No.FUN-5C0077
       l_ogb           RECORD LIKE ogb_file.*,        #No.FUN-5C0077
       l_cnt           LIKE type_file.num5,                        #FUN-5C0114  #No.FUN-680104 SMALLINT
       l_ohb           RECORD LIKE ohb_file.*   #No.FUN-740016
 
 
       LET l_err = NULL
       IF (g_argv1 = '1') AND (g_qcs.qcs00 = '1') THEN  #OR l_p = 'Y') THEN #MOD-740273
          SELECT rvb_file.* INTO l_rvb.* #NO:7143
            FROM rvb_file,rva_file
           WHERE rvb01 = rva01
             AND rvaconf = 'Y'
             AND rvb01 = g_qcs.qcs01
             AND rvb02 = g_qcs.qcs02
 
          IF l_rvb.rvb19 = '2' THEN
             #委外代買料件免驗!
             LET l_err = 'aqc-110'
          END IF
 
          IF l_rvb.rvb39 = 'N' THEN
             #免驗料!
             LET l_err = 'aqc-113'
          END IF
 
          IF STATUS=100 THEN
             LET l_err = 'mfg3070'
          END IF
       END IF

       #FUN-C30070---begin
       IF g_argv1 = '1' AND (g_qcs.qcs00 = '2') THEN
          SELECT COUNT(*) INTO l_cnt
            FROM rvb_file,rva_file
           WHERE rvb01 = rva01
             AND rvaconf = 'Y'
             AND rvb01 = g_qcs.qcs01
             AND rvb02 = g_qcs.qcs02
             AND rvb39 = 'N'
           IF l_cnt = 0 THEN 
              LET l_err = 'aqc-130'
           END IF   
       END IF 
       #FUN-C30070---end
 
       IF g_argv1 = '2' THEN
          CASE g_qcs.qcs00
             WHEN "A"
                SELECT inb_file.* INTO l_inb.*
                  FROM inb_file,ina_file
                 WHERE inb01 = ina01
                   AND inapost = 'N'
                   AND (ina00 = '1' OR ina00 = '2')  
                   AND inb01 = g_qcs.qcs01
                   AND inb03 = g_qcs.qcs02
                   AND inb16 > 0
                IF STATUS=100 THEN
                   LET l_err = 'abx-004'
                END IF
                IF l_inb.inb10 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_inb.inb04
                END IF
             WHEN "B"
                SELECT inb_file.* INTO l_inb.*
                  FROM inb_file,ina_file
                 WHERE inb01 = ina01
                   AND inapost = 'N'
                   AND (ina00 = '3' OR ina00 = '4')
                   AND inb01 = g_qcs.qcs01
                   AND inb03 = g_qcs.qcs02
                   AND inb16 > 0
                IF STATUS=100 THEN
                   LET l_err = 'abx-004'
                END IF
                IF l_inb.inb10 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_inb.inb04
                END IF
             WHEN "C"
                SELECT imn_file.* INTO l_imn.*
                  FROM imn_file,imm_file
                 WHERE imn01 = imm01
                   #AND ((imm04 = 'N'  #CHI-CA0040
                   AND (((imm04 = 'N' OR imm03 = 'N')  #CHI-CA0040
                   AND imm10 != '1')
                    OR (imm03 = 'N'
                   AND imm10 = '1'))
                   AND imn01 = g_qcs.qcs01
                   AND imn02 = g_qcs.qcs02
                   AND imn10 > 0
                IF STATUS=100 THEN
                   LET l_err = 'mfg3384'
                END IF
                IF l_imn.imn29 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_imn.imn03
                END IF
             WHEN "D"
                SELECT imn_file.* INTO l_imn.*
                  FROM imn_file,imm_file
                 WHERE imn01 = imm01
                   AND imm04 = 'N'                #CHI-690047
                   AND imm03 = 'N'
                   AND imn01 = g_qcs.qcs01
                   AND imn02 = g_qcs.qcs02
                   AND imn22 > 0
                IF STATUS=100 THEN
                   LET l_err = 'mfg3384'
                END IF
                IF l_imn.imn29 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_imn.imn03
                END IF
             WHEN "E"
                SELECT imp_file.* INTO l_imp.*
                  FROM imp_file,imo_file
                 WHERE imp01 = imo01
                   AND imoconf = 'Y'
                   AND imopost = 'N'
                   AND imp01 = g_qcs.qcs01
                   AND imp02 = g_qcs.qcs02
                   AND imp04 > 0
                IF STATUS=100 THEN
                   LET l_err = 'aim-410'
                END IF
                IF l_imp.imp15 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_imp.imp03
                END IF
             WHEN "F"
                SELECT imq_file.* INTO l_imq.*
                  FROM imq_file,imr_file
                 WHERE imq01 = imr01
                   AND imr00 = '1'          #No.TQC-660073 add
                   AND imrpost = 'N'
                   AND imq01 = g_qcs.qcs01
                   AND imq02 = g_qcs.qcs02
                   AND imq07 > 0
                IF STATUS=100 THEN
                   LET l_err = 'aap-091'
                END IF
                IF l_imq.imq15 = 'N' THEN
                   LET l_err = 'aqc-113'
                   LET l_rvb.rvb05 = l_imq.imq05
                END IF
             WHEN "G"
                SELECT qsa_file.* INTO l_qsa.*
                  FROM qsa_file
                 WHERE qsa01 = g_qcs.qcs01
                   AND qsa08 = 'Y'
                   AND qsa06 > 0
                IF STATUS=100 THEN
                   LET l_err = 'aqc-987'
                END IF
            WHEN "H"
             SELECT ohb_file.* INTO l_ohb.*
               FROM ohb_file,oha_file
              WHERE ohb01 = oha01
                AND ohb01 = g_qcs.qcs01
                AND ohb03 = g_qcs.qcs02
                AND ohb12 > 0
             IF STATUS=100 THEN
                LET l_err = 'axm-897'
             END IF
          END CASE
       END IF
       IF g_argv1 = '3' THEN
          IF g_qcs.qcs00='5' THEN
             SELECT ogb_file.* INTO l_ogb.*
               FROM ogb_file,oga_file
              WHERE ogb01 = oga01
                AND oga09 IN ('1','5')
                AND ogaconf = 'Y'            #CHI-870023
                AND ogb01 = g_qcs.qcs01
                AND ogb03 = g_qcs.qcs02
                AND ogb12 > 0
             IF STATUS=100 OR l_ogb.ogb19 <> 'Y'  THEN  #MOD-880068 add ogb19
                LET l_err = 'axm-897'
             END IF
          ELSE
             SELECT ogb_file.* INTO l_ogb.*
               FROM ogb_file,oga_file
              WHERE ogb01 = oga01
                AND oga09 IN ('2','3','4','6','7','8','A')  #No.FUN-610079 #MOD-B10110 add A
                AND ogaconf = 'Y'
                AND ogapost = 'N'
                AND ogb01 = g_qcs.qcs01
                AND ogb03 = g_qcs.qcs02
                AND ogb12 > 0
             IF STATUS=100 OR l_ogb.ogb19 <> 'Y'  THEN  #MOD-880068 add ogb19
               #LET l_err = 'axm-897'   #MOD-C80185 mark
                LET l_err = 'axm-892'   #MOD-C80185
             END IF
          END IF
       END IF
       IF NOT cl_null(l_err) THEN
          IF l_err = 'mfg3070' OR l_err = 'abx-004' OR l_err = 'mfg3384'
                               OR l_err = 'aim-410' OR l_err = 'aap-091'
                               OR l_err = 'axm-897' OR l_err = 'aqc-987' 
                               OR l_err = 'axm-892' THEN   #FUN-640058 add aqc-987  #MOD-C80185 add axm-892
             LET g_msg = g_qcs.qcs01 CLIPPED,'+',g_qcs.qcs02
             CALL cl_err(g_msg,l_err,0)
          ELSE
             CALL cl_err(l_rvb.rvb05,l_err,0)
          END IF
       END IF
       IF g_argv1="4" THEN
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM srf_file,srg_file
              WHERE srf01=srg01  AND srfconf='Y'
                AND srg01=g_qcs.qcs01
                AND srg02=g_qcs.qcs02
                AND srg15='Y'    AND srg05>0
          IF l_cnt=0 THEN
             CALL cl_err('chk qcs02',100,1)
             LET l_err = 'chk qcs02'
          END IF
          CALL t110_asr_qcs021(g_qcs.qcs01,g_qcs.qcs02) #FUN-5C0114
       END IF
  RETURN l_err
END FUNCTION
 
FUNCTION t110_spc_upd()
   BEGIN WORK
   IF NOT t110_spc_upd_process() THEN
       ROLLBACK WORK
       RETURN
   END IF
   IF g_aza.aza65 = 'Y' THEN
      CALL t110_y_chk()              #CALL 原確認的 check 段
      IF g_success = "Y" THEN
         CALL t110_y_upd()           #CALL 原確認的 update 段
      END IF
      IF g_success = "N" THEN
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t110_spc_upd_process()
DEFINE l_status    LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE l_qcs091    LIKE qcs_file.qcs091
DEFINE l_qcs22     LIKE qcs_file.qcs22
 
   # CALL aws_spcfld()
   #功能: 修改 QC 張資料
   # 傳入參數: (1) QC 程式代號, (2) TABLE 名稱,
   #           (3) 合格量欄位,  (4) 送驗量欄位
   # 回傳值  : (1)0 更改失敗; 1 更新成功
   #           (2) 合格量數量， (3)送驗量數量
   CALL aws_spcfld(g_prog,'qcs_file','qcs091','qcs22') 
     RETURNING l_status,l_qcs091,l_qcs22
   IF l_status = 0 THEN
       RETURN FALSE
   END IF
 
   LET g_qcs.qcs36 = g_qcs.qcs30
   LET g_qcs.qcs37 = g_qcs.qcs31
   LET g_qcs.qcs38 = l_qcs091 / g_qcs.qcs37
   LET g_qcs.qcs39 = g_qcs.qcs33
   LET g_qcs.qcs40 = g_qcs.qcs34
   IF NOT cl_null(g_qcs.qcs41) THEN 
      LET g_qcs.qcs41 = 0                #母單位數量(合格量) 
   END IF
   IF l_qcs22 <> g_qcs.qcs22 THEN
      IF NOT cl_null(g_qcs.qcs35) THEN 
         LET g_qcs.qcs35 = 0                #母單位數量
      END IF
      LET g_qcs.qcs32 = l_qcs22 / g_qcs.qcs31
   END IF

   LET g_qcs.qcs32 = s_digqty(g_qcs.qcs32,g_qcs.qcs30)    #FUN-BB0085 
   LET g_qcs.qcs35 = s_digqty(g_qcs.qcs35,g_qcs.qcs33)    #FUN-BB0085
   LET g_qcs.qcs38 = s_digqty(g_qcs.qcs38,g_qcs.qcs36)    #FUN-BB0085
   UPDATE qcs_file SET qcs36 = g_qcs.qcs36,   qcs37 = g_qcs.qcs37,   
                       qcs38 = g_qcs.qcs38,   qcs39 = g_qcs.qcs39,
                       qcs40 = g_qcs.qcs40,   qcs41 = g_qcs.qcs41,   
                       qcs35 = g_qcs.qcs35,   qcs32 = g_qcs.qcs32    
    WHERE qcs01 = g_qcs.qcs01 AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","qcs_file",g_qcs.qcs01,g_qcs.qcs01,SQLCA.sqlcode,"","",1)  #No.FUN-660115
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION
 
FUNCTION t110_spc_def()
DEFINE l_err           LIKE ze_file.ze01             
 
   LET g_qcs.qcs01 = g_argv2
   LET g_qcs.qcs02 = g_argv3
   LET g_qcs.qcsspc = '1'
   IF cl_null(g_qcs.qcs00) THEN
      SELECT unique qcs00 INTO g_qcs.qcs00 FROM qcs_file
        WHERE qcs01=g_qcs.qcs01 AND qcs02 = g_qcs.qcs02
   END IF
   CALL t110_qcs01() RETURNING l_err #MOD-740273
   IF NOT cl_null(l_err) THEN
      CALL cl_err(g_qcs.qcs01,l_err,1)
      RETURN 0
   END IF
 
   CALL t110_check_qc() RETURNING l_err  #MOD-740273
   IF NOT cl_null(l_err) THEN
      CALL cl_err(g_qcs.qcs01,l_err,1)
      RETURN 0
   END IF
 
   CALL t110_unqc_qty()
   IF NOT cl_null(g_errno) THEN
       CALL cl_err(g_qcs.qcs01,g_errno,1)
       RETURN 0
   END IF
   CALL t110_ref()        
  #CALL t110_qcs02()        #MOD-C30339  mark
   CALL t110_qcs02('a')     #MOD-C30339
   CALL t110_qcs03_def()
   IF NOT cl_null(g_errno) THEN
      RETURN 0
   END IF
   LET g_qcs.qcs05 = g_argv4
 
   LET g_qcs22 = g_qcs.qcs22
   display "g_qcs.qcs22:",g_qcs.qcs22
   display "g_qcs22:",g_qcs22
   display "g_qcs222:",g_qcs22s
  
   RETURN 1
 
END FUNCTION 
 
FUNCTION t110_qcs03_def()
DEFINE    m_pmc03         LIKE pmc_file.pmc03, 
          m_ima02         LIKE ima_file.ima02,
          m_ima109        LIKE ima_file.ima109,
          m_ima15         LIKE ima_file.ima15,
          m_azf03         LIKE azf_file.azf03,
          m_pmh05         LIKE pmh_file.pmh05,
          m_pmh05_desc    LIKE ze_file.ze03   #No.TQC-610007
   LET g_errno='' #MOD-970271  
   IF NOT cl_null(g_qcs.qcs03) THEN
       IF g_qcs.qcs00 MATCHES '[56H]' THEN   #MOD-A20100 add H
          SELECT occ02 INTO m_pmc03
            FROM occ_file
           WHERE occ01 = g_qcs.qcs03
          IF STATUS THEN
             CALL cl_err3("sel","occ_file",g_qcs.qcs03,"","atm-333","","",1)  #No.FUN-660115
             LET g_errno = "atm-333"
             RETURN 
          END IF
          SELECT obk12,obk14 INTO g_qcs.qcs21,g_qcs.qcs17
            FROM obk_file
           WHERE obk01 = g_qcs.qcs021
             AND obk02 = g_qcs.qcs03
         #str MOD-A20100 add
          IF SQLCA.sqlcode THEN
             SELECT ima100,ima102 INTO g_qcs.qcs21,g_qcs.qcs17
               FROM ima_file
              WHERE ima01=g_qcs.qcs021
          END IF
         #end MOD-A20100 add
       ELSE
          SELECT pmc03 INTO m_pmc03 FROM pmc_file
           WHERE pmc01 = g_qcs.qcs03
          IF STATUS THEN
             CALL cl_err3("sel","pmc_file",g_qcs.qcs03,"","mfg3001","","",1)  #No.FUN-660115
             LET g_errno = "atm-333"
   	  RETURN 
          END IF
          DECLARE pmh_cur3 CURSOR FOR SELECT pmh05,pmh09,pmh16
                                        FROM pmh_file
                                       WHERE pmh01 = g_qcs.qcs021
                                         AND pmh02 = g_qcs.qcs03
                                         AND pmh21 = " "                     #CHI-860042
                                         AND pmh22=g_type                    #CHI-860042   #MOD-890102 modify '1'->g_type
                                         AND pmh23 = ' '                     #No.CHI-960033
                                        # AND pmhacti = 'Y'                  #CHI-910021   #No.CHI-A10021 mark
          OPEN pmh_cur3
          FETCH pmh_cur3 INTO m_pmh05,g_qcs.qcs21,g_qcs.qcs17
         #IF STATUS=100 THEN                                                                        #MOD-B70116 mark
          IF STATUS=100 OR cl_null(m_pmh05) OR cl_null(g_qcs.qcs21) OR cl_null(g_qcs.qcs17) THEN    #MOD-B70116 add
             LET m_pmh05=' '
             SELECT pmc906,pmc907 INTO g_qcs.qcs21,g_qcs.qcs17
               FROM pmc_file
              WHERE pmc01 = g_qcs.qcs03
            #IF STATUS=100 THEN                                                  #MOD-B70116 mark
             IF STATUS=100 OR cl_null(g_qcs.qcs21) OR cl_null(g_qcs.qcs17) THEN  #MOD-B70116 add
                SELECT ima100,ima102 INTO g_qcs.qcs21,g_qcs.qcs17
                   FROM ima_file WHERE ima01=g_qcs.qcs021
                IF STATUS THEN
                   LET g_qcs.qcs21=' '
                   LET g_qcs.qcs17=' '
                END IF
             END IF
          END IF
          CASE m_pmh05
             WHEN '0'
                CALL cl_getmsg('aqc-010',g_lang) RETURNING m_pmh05_desc
             WHEN '1'
                CALL cl_getmsg('aqc-011',g_lang) RETURNING m_pmh05_desc
             WHEN '2'
                CALL cl_getmsg('aqc-012',g_lang) RETURNING m_pmh05_desc
          END CASE
       END IF
   ELSE
         SELECT ima100,ima102 INTO g_qcs.qcs21,g_qcs.qcs17
            FROM ima_file WHERE ima01=g_qcs.qcs021
         IF STATUS THEN
            LET g_qcs.qcs21=' '
            LET g_qcs.qcs17=' '
         END IF
   END IF
   CASE g_qcs.qcs21
      WHEN 'N'
         CALL cl_getmsg('aqc-001',g_lang) RETURNING qcs21_desc
      WHEN 'T'
         CALL cl_getmsg('aqc-002',g_lang) RETURNING qcs21_desc
      WHEN 'R'
         CALL cl_getmsg('aqc-003',g_lang) RETURNING qcs21_desc
   END CASE
   #----------CHI-BC0018 str add-----------------
   CASE g_ima101
      WHEN '1'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_1' AND gae03=g_lang

      WHEN '2'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_2' AND gae03=g_lang

      WHEN '3'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_3' AND gae03=g_lang

      WHEN '4'
         SELECT gae04 INTO ima101_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima101_4' AND gae03=g_lang

      OTHERWISE
         LET ima101_desc=' '
   END CASE
   DISPLAY ima101_desc TO FORMONLY.ima101_desc

   CASE g_qcs.qcs17
      WHEN '1'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcs17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcs17_desc= ' '
   END CASE
   DISPLAY qcs17_desc TO FORMONLY.qcs17_desc
   #----------CHI-BC0018 end add-----------------
   DISPLAY m_pmc03 TO FORMONLY.pmc03
   DISPLAY m_pmh05_desc TO FORMONLY.pmh05
   DISPLAY g_qcs.qcs17 TO qcs17
   DISPLAY g_qcs.qcs21 TO qcs21
   DISPLAY qcs21_desc TO FORMONLY.qcs21_desc
END FUNCTION
 
FUNCTION t110_ins_rvbs()
   DEFINE l_rvbs     RECORD LIKE rvbs_file.*   #No.FUN-840157
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_ima930   LIKE ima_file.ima930   #DEV-D40021 --add
#No.TQC-B90236--------------add begin-------------------------------------------------------
#No.TQC-B90236--------------mark----begin--------------------------------------------------- 
#  IF NOT s_lotin_del(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qcs.qcs021,'DEL') THEN   #No.FUN-860045
#     CALL cl_err3("del","rvbs_file",g_qcs.qcs01,g_qcs.qcs02,
#                   SQLCA.sqlcode,"","",1)
#     RETURN
#  END IF
#N0.TQC-B90236--------------mark----end-----------------------------------------------------
    IF NOT s_lot_del(g_prog,g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_qcs.qcs021,'DEL') THEN
       CALL cl_err3("del","rvbs_file",g_qcs.qcs01,g_qcs.qcs02,
                     SQLCA.sqlcode,"","",1)
       RETURN
    END IF 
#No.TQC-B90236--------------add end---------------------------------------------------------
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_qcs.qcs021
      AND imaacti = "Y"
   
   #DEV-D40021 --add--str
   LET l_ima930 = ''
   SELECT ima930 INTO l_ima930 FROM ima_file
    WHERE ima01 = g_qcs.qcs021
   IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF 
   IF l_ima930 = 'Y' THEN RETURN END IF 
   #DEV-D40021 --add--end
   
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
      IF (g_sma.sma90 = "Y" AND g_argv1='1') OR g_argv1<>'1' THEN   #CHI-A70047 
         IF g_qcs.qcs00 MATCHES '[156ABCDH]' THEN
            IF g_qcs.qcs00 MATCHES '[1BC]' THEN
               LET l_rvbs09 = 1  
            ELSE
               LET l_rvbs09 = -1  
            END IF
            DECLARE rvbs_curs CURSOR FOR SELECT * FROM rvbs_file
                                          WHERE rvbs01 = g_qcs.qcs01
                                            AND rvbs02 = g_qcs.qcs02
                                            AND rvbs13 = 0
                                            AND rvbs09 = l_rvbs09 
            
            FOREACH rvbs_curs INTO l_rvbs.*
               IF STATUS THEN 
                  CALL cl_err('foreach rvbs:',STATUS,1)
                  EXIT FOREACH
               END IF
            
               INSERT INTO rvbs_file(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,
                                     rvbs03,rvbs04,rvbs05,rvbs06,rvbs07,
                                     rvbs08,rvbs09,rvbs10,rvbs11,rvbs12,rvbs13,
                                     rvbsplant,rvbslegal) #FUN-980007
                              VALUES(g_prog,g_qcs.qcs01,g_qcs.qcs02,
                                     l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                     l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                     l_rvbs.rvbs07,l_rvbs.rvbs08,1,0,0,0,g_qcs.qcs05,
                                     g_plant,g_legal)     #FUN-980007
            
            END FOREACH
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_get_fac()
 
   IF (g_argv1 = '1') AND (g_qcs.qcs00 = '1') THEN
      SELECT rvb05,rvb36,rvb37,rvb38,pmn07 
        INTO g_rvb05,g_rvb36,g_rvb37,g_rvb38,g_pmn07
        FROM rvb_file,pmn_file
       WHERE rvb01 = g_qcs.qcs01
         AND rvb02 = g_qcs.qcs02
         AND rvb04 = pmn01
         AND rvb03 = pmn02
 
      SELECT img09 INTO g_img09
        FROM img_file   #庫存單位
       WHERE img01=g_rvb05 AND img02=g_rvb36
         AND img03=g_rvb37 AND img04=g_rvb38
      CALL s_umfchk(g_rvb05,g_pmn07,g_img09) 
           RETURNING l_i,l_fac
      IF l_i = 1 THEN LET l_fac = 1 END IF
   END IF
 
   IF g_argv1 = '2' THEN
      #CASE g_qcs.qcs00   #CHI-A70047
      CASE    #CHI-A70047
         #WHEN "A" OR "B"   #CHI-A70047
         WHEN g_qcs.qcs00='A' OR g_qcs.qcs00='B'   #CHI-A70047
            SELECT inb04,inb05,inb06,inb07,inb08,inb08_fac   #CHI-A70047
              INTO g_rvb05,g_rvb36,g_rvb37,g_rvb38,g_pmn07,l_fac   #CHI-A70047
              FROM inb_file
             WHERE inb01 = g_qcs.qcs01
               #AND inb02 = g_qcs.qcs02   #CHI-A70047
               AND inb03 = g_qcs.qcs02   #CHI-A70047
 
            SELECT img09 INTO g_img09
              FROM img_file   #庫存單位
             WHERE img01=g_rvb05 AND img02=g_rvb36
               AND img03=g_rvb37 AND img04=g_rvb38
         #WHEN "C" OR "D"   #CHI-A70047
         WHEN g_qcs.qcs00='C' OR g_qcs.qcs00='D'   #CHI-A70047
            SELECT imn09 INTO g_img09
              FROM imn_file
             WHERE imn01 = g_qcs.qcs01
               AND imn02 = g_qcs.qcs02
 
            LET l_fac = 1
        #WHEN "H"   #CHI-A70047
        WHEN g_qcs.qcs00='H'   #CHI-A70047
            SELECT ohb15,ohb15_fac INTO g_img09,l_fac
              FROM ohb_file
             WHERE ohb01 = g_qcs.qcs01
               AND ohb03 = g_qcs.qcs02
      END CASE
   END IF
 
   IF g_argv1 = '3' THEN
      SELECT ogb15,ogb15_fac INTO g_img09,l_fac
        FROM ogb_file
       WHERE ogb01 = g_qcs.qcs01
         AND ogb03 = g_qcs.qcs02
   END IF
 
END FUNCTION
 
FUNCTION t110_get_ecm04()
  DEFINE l_rvb04  LIKE rvb_file.rvb04    #MOD-890102
  DEFINE l_rvb03  LIKE rvb_file.rvb03    #MOD-890102
  DEFINE l_pmm02  LIKE pmm_file.pmm02    #MOD-890102
  DEFINE l_pmn41  LIKE pmn_file.pmn41    #MOD-890102
  DEFINE l_pmn43  LIKE pmn_file.pmn43    #MOD-890102
  DEFINE l_pmn012  LIKE pmn_file.pmn012   #FUN-A60076 add
 
   LET g_type  = '1'       #MOD-890102
   LET g_ecm04 = ' '       #MOD-890102
 
   IF g_qcs.qcs00 <> '1' AND  g_qcs.qcs00 <> '2' THEN
       RETURN
   END IF 
 
   SELECT rvb04,rvb03   
     INTO l_rvb04,l_rvb03           #MOD-890102 
     FROM rvb_file
    WHERE rvb01=g_qcs.qcs01
      AND rvb02=g_qcs.qcs02
   SELECT pmm02,pmn41,pmn43,pmn012 INTO l_pmm02,l_pmn41,l_pmn43,l_pmn012   #No.MOD-930234 add
     FROM pmm_file,pmn_file 
    WHERE pmm01 = l_rvb04  AND pmn02=l_rvb03
      AND pmm01 = pmn01
   IF l_pmm02='SUB' THEN 
      LET g_type='2' 
      IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
         LET g_ecm04 = " "
      ELSE
         SELECT ecm04 INTO g_ecm04 FROM ecm_file
          WHERE ecm01 = l_pmn41
            AND ecm03 = l_pmn43
            AND ecm012 =l_pmn012                    #FUN-A60076 add
      END IF
   END IF 
END FUNCTION
 
FUNCTION t110_qc_return() 
   DEFINE l_qty1        LIKE qcs_file.qcs091
   DEFINE l_qty2        LIKE qcs_file.qcs091
   DEFINE l_qty3        LIKE qcs_file.qcs091
   DEFINE l_unit        LIKE rvv_file.rvv35
 
   #收貨單的總驗退量
   SELECT SUM(rvv17) INTO l_qty1 FROM rvu_file,rvv_file
    WHERE rvu01 = rvv01
      AND rvv04 = g_qcs.qcs01
      AND rvv05 = g_qcs.qcs02
      AND rvu00 = '2'   #驗退量
      AND rvuconf <> 'X'
   IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
 
   #總IQC驗退量  
   #特別說明:送驗量與特采量的差值,也算做驗退量
   #但是特采這個button可以多次按,原來程序的邏輯是,可以不care是否已經有驗退量了
   #所以目前此段的改法,遵循原來的邏輯,在特采前,不做控管
   #但差額算成驗退量
   SELECT SUM(qcs22-qcs091) INTO l_qty2 FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
     #AND (qcs09 = '2'   #不合格量          #MOD-C30428
     # OR  qcs09 = '3')  #特采量            #MOD-C30428
      AND qcsacti = 'Y' 
 
   LET l_qty3 = g_qcs.qcs22   #本次不合量
 
   IF l_qty1 > l_qty2 - l_qty3 THEN
      CALL cl_err(g_qcs.qcs01,'aqc-222',1)
      RETURN FALSE
   END IF  
   RETURN TRUE
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#No.TQC-BB0119  --Begin
FUNCTION t110_get_qcd07(p_qct04)
   DEFINE p_qct04       LIKE qct_file.qct04
   DEFINE l_qcd05       LIKE qcd_file.qcd05
   DEFINE l_qcd07       LIKE qcd_file.qcd07
   DEFINE l_qcd061      LIKE qcd_file.qcd061
   DEFINE l_qcd062      LIKE qcd_file.qcd062

   LET l_qcd07  = 'N'
   LET l_qcd05  = ''
   LET l_qcd061 = ''
   LET l_qcd062 = ''
   LET g_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
               "   FROM qcc_file,ecm_file,rvb_file,pmn_file ",
               "  WHERE rvb01= ?    AND rvb02= ?",
               "    AND rvb04=pmn01 AND rvb03=pmn02  ",
               "    AND pmn41=ecm01 AND pmn46=ecm03 ",
               "    AND qcc01= ?    AND qcc011=ecm04 ",
               "    AND qcc02= ?",
               "    AND ecm012=pmn012 "   
   IF g_argv1 = "1" THEN 
      LET g_sql = g_sql CLIPPED," AND qcc08 in ('1','9')"
   END IF     
   IF g_argv1 = "2" THEN 
      LET g_sql = g_sql CLIPPED," AND qcc08 in ('5','9')" 
   END IF     
   IF g_argv1 = "3" THEN 
      LET g_sql = g_sql CLIPPED," AND qcc08 in ('4','9')"
   END IF     
   IF g_argv1 = "4" THEN 
      LET g_sql = g_sql CLIPPED," AND qcc08 in ('2','9')"
   END IF 
   PREPARE qcc_sel2 FROM g_sql  
   EXECUTE qcc_sel2 USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs021,p_qct04
      INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                                          
   IF STATUS=100 THEN
      EXECUTE qcc_sel2 USING g_qcs.qcs01,g_qcs.qcs02,'*',p_qct04
         INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07
      IF STATUS=100 THEN
         LET g_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
                     " FROM qcd_file ",
                     " WHERE qcd01=? AND qcd02=? "
         IF g_argv1 = "1" THEN 
            LET g_sql = g_sql CLIPPED," AND qcd08 in ('1','9')"
         END IF           
         IF g_argv1 = "2" THEN 
            LET g_sql = g_sql CLIPPED," AND qcd08 in ('5','9')" 
         END IF     
         IF g_argv1 = "3" THEN 
            LET g_sql = g_sql CLIPPED," AND qcd08 in ('4','9')"
         END IF     
         IF g_argv1 = "4" THEN 
            LET g_sql = g_sql CLIPPED," AND qcd08 in ('2','9')"
         END IF
         PREPARE qcd_sel2 FROM g_sql  
         EXECUTE qcd_sel2 USING g_qcs.qcs021,p_qct04
            INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
         IF STATUS=100 THEN
            LET g_sql = " SELECT qck05,qck061,qck062,qck07  ",
                        "   FROM qck_file,ima_file ",
                        "  WHERE ima01=? AND qck01=ima109 ",
                        "    AND qck02 = ?"
                   
            IF g_argv1 = "1" THEN 
               LET g_sql = g_sql CLIPPED," AND qck08 in ('1','9')" 
            END IF       
            IF g_argv1 = "2" THEN 
               LET g_sql = g_sql CLIPPED," AND qck08 in ('5','9')"
            END IF      
            IF g_argv1 = "3" THEN 
               LET g_sql = g_sql CLIPPED," AND qck08 in ('4','9')"
            END IF     
            IF g_argv1 = "4" THEN 
               LET g_sql = g_sql CLIPPED," AND qck08 in ('2','9')"
            END IF    
            PREPARE qck_sel2 FROM g_sql  
            EXECUTE qck_sel2 USING g_qcs.qcs021,p_qct04
               INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
            IF STATUS=100 THEN
               LET l_qcd07  = 'N'
               LET l_qcd05  = ''
               LET l_qcd061 = ''
               LET l_qcd062 = ''
            END IF
         END IF
      END IF    
   END IF

   RETURN l_qcd07,l_qcd05,l_qcd061,l_qcd062

END FUNCTION 
#FUN-BC0104--add-str--
FUNCTION t110_qc_item_show()
   SELECT qcs09,qcs091,qcs38,qcs41 
     INTO g_qcs.qcs09,g_qcs.qcs091,g_qcs.qcs38,g_qcs.qcs41
     FROM qcs_file
    WHERE qcs01 = g_qcs.qcs01
      AND qcs02 = g_qcs.qcs02
      AND qcs05 = g_qcs.qcs05
   DISPLAY BY NAME g_qcs.qcs09,g_qcs.qcs091,g_qcs.qcs38,g_qcs.qcs41
   CASE g_qcs.qcs09
      WHEN '1'
         CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
      WHEN '2'
         CALL cl_getmsg('apm-244',g_lang) RETURNING des1 #No:7706 驗退
      WHEN '3'
         CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE

   DISPLAY des1 TO FORMONLY.des1
END FUNCTION
#FUN-BC0104--add-end--

#MOD-C30560----add----str----
FUNCTION t110_chk_qc()
DEFINE l_inb44     LIKE inb_file.inb44
   
   SELECT inb44 INTO l_inb44 FROM inb_file 
    WHERE inb01 = g_qcs.qcs01 
      AND inb03 = g_qcs.qcs02 
   IF NOT cl_null(l_inb44) THEN 
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#MOD-C30560----add----end----

#No.TQC-BB0119  --End  


#DEV-D30045--add--begin
FUNCTION t110_barcode_out()
   DEFINE l_cmd       STRING

   IF g_qcs.qcs01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_msg = ' ibb03="',g_qcs.qcs01 CLIPPED,'"'
   LET l_cmd = "abar100",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1'",
               " '' '' '' '' ",
               " '",g_msg CLIPPED,"' ",
               " ' ' 'L' '",s_gen_barcode_ibd07(),"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION


FUNCTION t110_barcode_gen(p_qcs01,p_qcs02,p_qcs05,p_ask)
   DEFINE p_qcs01   LIKE qcs_file.qcs01
   DEFINE p_qcs02   LIKE qcs_file.qcs02
   DEFINE p_qcs05   LIKE qcs_file.qcs05
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_qcs     RECORD LIKE qcs_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_qcs01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
      RETURN
   END IF

   IF l_qcs.qcsacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN #DEV-D40015 add
   IF l_qcs.qcs14 = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF
   END IF                  #DEV-D40015 add

   IF l_qcs.qcs14 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_qcs.qcs01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK

   OPEN t110_cl USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO l_qcs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_qcs.qcs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'L') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'L') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end
  
  #DEV-D40015 add str-------
   IF g_success = 'Y' THEN
      CALL t110sub_chk_ima(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'I')
   END IF
  #DEV-D40015 add end-------

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION t110_barcode_z(p_qcs01,p_qcs02,p_qcs05,p_inTransaction)  #DEV-D40015--add p_inTransaction
   DEFINE p_qcs01   LIKE qcs_file.qcs01
   DEFINE p_qcs02   LIKE qcs_file.qcs02
   DEFINE p_qcs05   LIKE qcs_file.qcs05
   DEFINE p_inTransaction LIKE type_file.num5                     #DEV-D40015--add
   DEFINE l_qcs     RECORD LIKE qcs_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_qcs01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
      RETURN
   END IF

   IF g_qcs.qcsacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_qcs.qcs01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   LET g_success = 'Y'
   #DEV-D40015--add--begin
   #BEGIN WORK
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
   #DEV-D40015--add--end

   OPEN t110_cl USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t110_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF
   FETCH t110_cl INTO l_qcs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_qcs.qcs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t110_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF

   #DEV-D40015 add str-------
   IF g_success = 'Y' THEN
      #先刪除,再作廢條碼
      CALL t110sub_chk_ima(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'D')
   END IF
   #DEV-D40015 add end-------

   IF g_success='Y' THEN
      CALL s_barcode_x2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   END IF

   IF g_success='Y' THEN
      #DEV-D40015--add--begin
      #COMMIT WORK
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-178')
   ELSE
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN
         ROLLBACK WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end

#DEV-D40015 add str--------
FUNCTION t110sub_chk_ima(p_qcs01,p_qcs02,p_qcs05,p_type)
   DEFINE p_qcs01    LIKE   qcs_file.qcs01
   DEFINE p_qcs02    LIKE   qcs_file.qcs02
   DEFINE p_qcs05    LIKE   qcs_file.qcs05
   DEFINE p_type     LIKE   rva_file.rva01  #I:新增 D:刪除
   DEFINE l_sql      STRING
   DEFINE l_ima01    LIKE   ima_file.ima01

   LET l_sql = " SELECT DISTINCT b.ima01,b.ima930,b.ima932 ",
               "   FROM qcs_file a         ",
               "  INNER JOIN ima_file b ON a.qcs021 = b.ima01 ",
               "                       AND b.ima930= 'Y' ",
               "                       AND b.ima932= 'L'",
               "  WHERE a.qcs01 = '",p_qcs01,"'",
               "    AND a.qcs02 = '",p_qcs02,"'",
               "    AND a.qcs05 = '",p_qcs05,"'"

   PREPARE t110_chkima_pre FROM l_sql
   DECLARE t110_chkima_cur CURSOR FOR t110_chkima_pre

   FOREACH t110_chkima_cur INTO l_ima01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach t110_chkima_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      CASE
         WHEN p_type = 'I'
            CALL s_ibb_ins_rvbs(g_prog,p_qcs01,l_ima01)
         WHEN p_type = 'D'
            CALL s_ibb_del_rvbs(g_prog,p_qcs01,l_ima01)
      END CASE
   END FOREACH
END FUNCTION
#DEV-D40015 add end--------
 
