# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt110.4gl
# Descriptions...: 採購收貨作業
# Date & Author..: 91/11/27 By Apple
# Modify ........: 93/01/10 BY David 加入 Subcontract 工單入庫數量UPDATE
# Modify ........: 93/02/04 BY P.C 1.加入收貨狀況資料(pmr_file) 2.flow diagram
# Modify ....... : 93/05/03 即日起本程式不處理委外部份
# Modify ....... : 95/04/26 By Danny (判斷是否使用保稅系統)
# Modify.........:          By Kitty check採購單價為0時show警告訊息,但可通過
# Modify ....... : 99/05/24 By Carol 判斷是否有品檢資料,有的話不可取消確認
# Modify ....... : 00/02/16 By Carol:單身 add 專案代號 field ->批號
# Modify ....... : No:7746 03/08/07 By Mandy 發票檔資料會錯亂
#                  一.KEY單身發票資料時,若符合
#                    (1)原本有發票資料,後來清空發票資料 或
#                    (2)原本有發票資料,後來更新發票資料 或
#                    (3)在該項次按F2 則應刪除rvw_file相關資料
#                  二.刪除整張收貨單時,則應刪除rvw_file相關資料
# Modify.........: No:7758 03/08/08 By Mandy 在BEFORE FIELD rvb22加上地區
#                               為大陸而且不是進口資料.才不得輸入發票號碼.
# Modify.........: No:7692 03/08/18 By Mandy 委外收入資料應納入
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.7882 03/08/22 By Kammy 所有三角貿易單據統一在 apmt300查
# Modify.........: No.6963 03/08/25 By Nicola 從apmp300過來的單子會秀該筆資料
# Modify.........: No.7938 03/08/26 Kammy 1.add rva99 多角序號
#                                         2.多角流程檔案poa_file改成poz_file
# Modify.........: No.8374 03/10/01 Melody 委外代買料不檢驗(同bug#7143)
# Modify.........: No.9524 04/05/07 Melody 應加上 qcs14!='X'
# Modify.........: No.8969 03/12/24 應於after input加判斷該欄位為重要欄位不可空白
# Modify.........: No.8114 03/12/16 Melody rvb19定義應同pmn65
# Modify.........: No.9525 04/05/19 Ching NEXT FIELD rva02要改成NEXT FIELD rvb04!
# Modify.........: No.9728 04/05/07 Wiky 新增收貨單,且單據設定'立即列印'狀況下,列印 apmr920時會當掉
# Modify.........: No.9893 04/07/12 Wiky 進單身項次後應取pmn65 給 rvb19
# Modify.........: No.MOD-490173 Kammy   單價權限控管
# Modify.........: No.MOD-480604 04/09/15 By Smapmin加上倉庫CONTROLP的功能
# Modify.........: No.MOD-480363 04/09/21 By Melody 確認段免驗部份的 rvb39 應直接='N' 不用再重抓 pmh08
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4A0009 04/10/05 By Yuna 查詢時,收貨單號應開出收貨單號而不是單據別
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0146 04/10/11 By Mandy 採購單號的開窗,應該再加<>SUB的條件
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-490328 04/10/26 By Mandy q_imd改用ON ACTION qry_warehouse #查詢倉庫資料
# Modify.........: No.MOD-4B0035 04/11/04 By Mandy 單頭修改後無法存檔,g_success是null
# Modify.........: No.MOD-4B0039 04/11/04 By Mandy 單身無法重show
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0275 04/11/25 By Danny CALL q_coc2
# Modify.........: No.FUN-4C0056 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530415 05/04/01 By Mandy 在單身產生時即應將是否檢驗的資料帶入，不需等到確認後再帶出。
# Modify.........: No.MOD-530700 05/05/05 By Mandy 1.進行收貨確認時，程式應加判斷應入的最小齊料套數
# Modify.........: No.MOD-530700 05/05/05 By Mandy 2.程式中直接寫中文ERROR "最小套數:",g_min_set,改用CALL cl_err(g_min_set,'aqc-426',0)
# Modify.........: No.MOD-530431 05/05/05 By pengu 單頭有輸入採購單號, 由系統自動產生單身 後,游標應出現在第一筆
# Modify.........: No.FUN-540027 05/05/23 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550117 05/05/30 By Danny 採購含稅單價
# Modify.........: NO.FUN-540027 05/05/31 By jackie 單據編號加大
# Modify ........: No.FUN-560060 05/06/14 By wujie 單據編號加大返工
# Modify.........: No.MOD-550195 05/05/27 By Mandy EFORE ROW 時應要將g_rvb2清成NULL並且重新抓取當下那筆的rvb_file的資料
# Modify.........: No.MOD-530021 05/06/10 By Mandy 採購單單身料件不能部份交貨時,短交的判斷有誤.
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.MOD-570144 05/07/13 By Nicola 修改時，單身欄位資料未重新
# Modify.........: No.MOD-570294 05/07/21 By Mandy AFTER FIELD rvb03 ....寫到LET g_rvb[l_ac].rvb10 = g_pmn31 之後nDISPLAY g_rvb[l_ac].rvb10 TO rvb10 #重show一次避免沒跑ON ROW CHANGE
# Modify.........: No.MOD-580087 05/08/10 By Nicola 當倉為空白時,會自動重捉倉儲顯示
# Modify.........: No.MOD-580086 05/08/19 By Nicola 作廢時同時刪掉rvw_file
# Modify.........: No.MOD-570411 05/08/19 By Nicola 自動產生單身時，也要新增img_file的資料
# Modify.........: No.FUN-580115 05/08/24 By Carrier 新增允收多單位rvb331/rvb332
# Modify.........: No.MOD-590119 05/09/09 By Carrier 多單位set_origin_field修改
# Modify.........: No.MOD-5A0297 05/10/19 By Nicola 單身自動產生時，計價單位及數量也要一併帶出
# Modify.........: NO.MOD-590530 05/10/05 BY yiting asmi300作倉庫設限無法用到此處
# Modify.........: NO.MOD-5A0448 05/11/01 BY Nicola 單身依項次排序
# Modify.........: NO.TQC-5B0070 05/11/09 BY Nicola 單身手動輸入時，實收數量修改
# Modify.........: NO.TQC-5C0012 05/12/05 By Mandy MOD-5A0297 Function Mark 筆誤
# Modify.........: NO.MOD-5C0039 05/12/07 BY Nicola 工單已結案，不可確認
# Modify.........: NO.FUN-5C0022 05/12/09 By Mandy 母子單位時,自動產生入庫時,需check 以下
#                                                  (允收數二+允收數一)經過換算<= IQC合格量才可自動產生
#                                                  (rvb332*l_factor+rvb331)   <= rvb33
# Modify.........: No.FUN-5C0078 05/12/20 By day 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-5C0055 05/12/19 By kim 先判斷是否已存在確認發料單(sfe_file),若是,才更新 sfb04 = '4',否則,應更新sfb04='2'
# Modify.........: NO.FUN-5A0076 06/01/10 BY yiting 建議單頭單據性質可以預設REG
# Modify.........: NO.FUN-610040 06/01/12 By Sarah 確認段增加判斷"收貨日期不可小於採購單據日期"
# Modify.........: No.FUN-610018 06/01/17 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-610034 06/01/24 By pengu 取消確認時,亦應判斷工單是否已結案
# Modify.........: No.FUN-610101 06/02/14 By pengu 委外製程收貨不應該要檔最小發料套數
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能及apmt720...等參數順序調換
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640158 06/04/11 By pengu 輸入單頭時 ,先輸入採購單號 ,然後再將採購單號清除 ,就過不去了會卡在採購單號上
# Modify.........: No.FUN-640123 06/04/12 By kim 修改委外工單確認時之錯誤訊息
# Modify.........: NO.FUN-640151 06/04/18 BY yiting 多角貿易收貨單單頭採購單號不可為空白
# Modify.........: NO.MOD-640530 06/04/20 BY Joe 修正當產生入庫單時,母子單位與交易單位換算錯誤
# Modify.........: No.MOD-650095 06/05/23 By Pengu 程式1674行應加上IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08=0判斷
# Modify.........: No.TQC-650108 06/05/24 By Ray 料件多屬性
# Modify.........: No.TQC-660053 06/06/12 By Pengu 新增時,打完單頭會問是否自動產生單身,若按'Y',則會產生-391的錯誤訊息
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660129 06/06/20 By wujie  cl_err -> cl_err3
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.MOD-660090 06/06/22 By Rayven 料件多屬性補充修改，check_料號()內應再加傳p_cmd的參數
# Modify.........: No.MOD-660155 06/06/30 By kim 當修改單身時,當新值<>舊值時,改了單位二不會異動單位一
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: NO.TQC-660145 06/07/04 BY yiting 單價的控管,單價要可以為零,不可以小於零
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.TQC-670089 06/07/25 By kim GP3.5 利潤中心
# Modify.........: No.TQC-670091 06/08/07 By Pengu 委外製程收貨應該要判斷該站製程發料量來控管委外收貨數量
# Modify.........: No.FUN-5A0090 06/08/08 By rainy 已結案的採購單不可取消確認
# Modify.........: No.FUN-680011 06/08/08 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680136 06/09/08 By Jackho 欄位類型修改
# Modify.........: No.FUN-690024 06/10/05 By jamie 判斷pmcacti
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加
#                                                           g_rec_b初始化命令
#                                                          "LET g_rec_b =0"
# Modify.........: No.MOD-6A0131 06/10/27 By 委外工單確認時,的檢查程序有誤
# Modify.........: No.CHI-6A0004 06/11/08 By bnlent 本幣原幣取位修改
# Modify.........: No.FUN-6B0032 06/11/10 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: NO.MOD-680004 06/11/23 BY Claire AFTER INSERT 段使用NEXT FIELD 就不需使用cancel insert
# Modify.........: NO.MOD-690012 06/11/23 BY Claire gec07已mark故不需給值
# Modify.........: No.MOD-6B0162 06/11/30 By ray 自動產生單身時計價數量應該是實收量-已交量
# Modify.........: No.TQC-6A0057 06/12/13 By pengu 委外製程時無法收貨
# Modify.........: No.TQC-6C0091 06/12/18 By Rayven mfg3037報錯信息未彈出導致報錯信息有誤，現改為報錯彈出
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.FUN-6A0139 06/12/29 By rainy 未稅/含稅單價不顯示在畫面上
# Modify.........: No.CHI-6A0040 07/01/03 By jamie action"qc_status(驗收狀況)"原串apmq110 ->apmt110_x
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.CHI-6B0019 07/01/30 By rainy 委外不鎖超交問題
# Modify.........: No.FUN-710030 07/02/07 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720103 07/03/07 By pengu 補登發票action輸入完後增加提示詢問是否更新所有項次的發票號碼
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730032 07/03/15 By pengu 當工單備料檔有"消耗性料件"時會照成製程委外無法收貨入庫
# Modify.........: No.MOD-730078 07/03/21 By pengu 將FUN-640123的調整還原
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.TQC-730059 07/04/03 By pengu 委外製程在判斷足套數時應該考慮生產單位與採購單位轉換率
# Modify.........: No.TQC-6C0131 06/04/11 By pengu 未考慮計價數量的沖銷的情形
# Modify.........: No.MOD-740033 07/04/11 By claire 排除作廢單據
# Modify.........: No.TQC-740078 07/04/13 By chenl  修正非檢驗收貨單審核后，彈出的入庫單無資料。
# Modify.........: No.TQC-740117 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.TQC-740313 07/04/25 By Ray 1.未直接產生入庫單 ,不必check img_file
#                                                2.參數設定 (sma886_7='N')  免檢不直接入庫 ,倉庫欄位可空白
#                                                3.限制不可更改計價單位
# Modify.........: No.MOD-740504 07/05/02 By kim 輸完單身採購項次,會出現-284的錯誤訊息
# Modify.........: No.MOD-740519 07/05/10 By claire 傳入入庫單的參數錯誤
# Modify.........: No.TQC-750097 07/05/18 By elva insrvu()時若插入異常則return
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750166 07/05/24 By kim 走runcard時,最小套數的檢查錯誤(作業編號抓錯)
# Modify.........: No.TQC-760055 07/06/06 By rainy 收貨單:003-07060001, 按確認, 僅出現..更新不成功, 應提示正確資訊以利user更改後再次確認
# Modify.........: No.TQC-760080 07/06/18 By chenl 多角貿易流程序好rva99欄位僅在apmt300中出現。
# Modify.........: No.MOD-760141 07/07/03 By Smapmin 不同廠商不可開同一發票
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.FUN-710060 07/08/07 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-770082 07/08/09 By claire 製程委外時確認時仍會不允許倉儲批空白(mfg-021訊息顯示可空白)
# Modify.........: No.TQC-750014 07/08/15 By pengu 庫存轉換率異常
# Modify.........: No.TQC-770117 07/08/29 By claire 完全不使用計價單位時,自動產生入庫單時,計價數量仍維持原收貨量,應需call set_rvv87()
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.MOD-790007 07/09/04 By claire 使用免驗收貨時不自動產生入庫單(sma886[7,7]不應再確認img_file
# Modify.........: No.MOD-790074 07/09/13 By claire 變數應將l_ac 改為p_i 才不致誤判訊息造成無法過帳
# Modify.........: No.MOD-790062 07/09/14 By claire 委外工單收貨除加入已確認單據,應再加入未確認及非本項次的數量
# Modify.........: No.MOD-790167 07/09/28 By Carol 使用免驗收貨時不自動產生入庫單(sma886[7,7]不應再確認img_file
# Modify.........: No.MOD-7A0030 07/10/05 By Claire 調整MOD-740504,否則會造成單身資料帶不出來
# Modify.........: No.CHI-7A0003 07/10/12 By Carol 還原TQC-740313的處理
# Modify.........: No.MOD-780060 07/10/17 By pengu 在計算最小套數時應排除委外代採買料
# Modify.........: No.MOD-7A0132 07/10/23 By claire MISC料的倉庫不可輸入,但移到下筆新增放棄後再回到上一筆MISC料,倉庫可以輸入,需控卡
# Modify.........: No.MOD-790176 07/10/30 By Pengu 調整MOD-7A0090
# Modify.........: No.MOD-7A0203 07/10/31 By Carol for MOD-7A0132調整單身set_no_entry_b()的邏輯
# Modify.........: No.MOD-7B0097 07/11/09 By claire 自動帶出單身時 rvb19不會有值
# Modify.........: No.MOD-7B0145 07/11/14 By claire l_smy57定義應為文字
# Modify.........: No.CHI-7B0023 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-7B0083 07/11/22 By Carier rvv88賦初值0
# Modify.........: No.TQC-7C0086 07/12/08 By Rayven 不能進入“發票號碼”欄位，錄入發票號
#                                                   外購收貨未檢查提單資料亦能審核
# Modify.........: No.TQC-7C0108 07/12/08 By wujie  收貨單號，采購單號都綁定屬性群組，單身手動輸入項次時，料號無法帶出
#                                                   通過采購單帶出的單身資料,不可修改料件子屬性
# Modify.........: No.TQC-7C0131 07/12/10 By Judy  收貨單號，采購單號都綁定屬性群組，單身手動輸入項次時，料號無法帶出加入到cl_set_entry_b()
# Modify.........: No.FUN-7C0017 07/12/27 By bnlent 增加行業別規範化修改 sapmt110.4gl->sapmt110.src.4gl
# Modify.........: No.MOD-810024 08/01/03 By claire 單身自行輸入時, 不會自動帶入採購單資訊
# Modify.........: No.MOD-810073 08/01/09 By claire 還原失敗時,要rollback
# Modify.........: No.TQC-810048 08/01/15 By claire (1)多角待採正拋會有一張收貨單多張採購單狀況, 故單頭採購單應允許可以空白
#                                                   (2)合併收貨時,非MISC料rvb38批號若為null時,應給空字元
# Modify.........: No.MOD-810137 08/01/18 By claire 在寫入單身前,判斷倉儲批的值不塞null
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810038 08/01/25 By kim GP5.1 ICD
# Modify.........: No.FUN-810016 08/02/16 By ve007 單身增加收貨時可做替代的邏輯
# Modify.........: No.FUN-810045 08/03/02 By rainy 項目管理:專案相關欄位代入tl
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810036 08/03/16 By Nicola 序號管理
# Modify.........: No.MOD-810208 08/03/19 By claire 以單身修改發票資料時,若選擇不回寫rvw_file,則rvb22也因不回寫
# Modify.........: No.MOD-810248 08/03/19 By claire 單身修改時,若採購項次為空白,則鍵入採購單號後無法跳至下一欄問題
# Modify.........: No.MOD-820073 08/03/19 By claire 委外收貨單確認時,單身若使用QBE查詢時不會列出所有單身筆數,造成chk_over()僅檢查列出資料
# Modify.........: No.CHI-820010 08/03/19 By claire 不使用計價單位,計價數量=實數數,rvb87()計算時避免小數位差問題
# Modify.........: No.MOD-820179 08/03/19 By claire 單身採購單修改與單頭單號不同時沒有控卡
# Modify.........: No.MOD-830023 08/03/19 By claire g_rvb[l_ac]--> g_rvb[p_ac] 調整
# Modify.........: No.CHI-830025 08/03/19 By kim GP5.1 整合測試修改
# Modify.........: No.MOD-830171 08/03/21 By claire 使用計價單位時,於採購單已修改計價數量應以採購單計價數量為主不需重推收貨單的計價數量
# Modify.........: No.MOD-830210 08/03/26 By Dido 單身輸入發票後也需要詢問更新單身動作
# Modify.........: No.CHI-830032 08/03/27 By kim GP5.1 整合測試修改 
# Modify.........: No.FUN-840178 08/03/27 By ve007  debug 810016
# Modify.........: No.FUN-840042 08/04/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-840130 08/04/16 By claire 免驗料自動入庫時,計價數量直來自收貨單的計價數量,不再重推
# Modify.........: No.CHI-830033 08/04/18 By claire 未(含)稅金額=未(含)稅單價*計價數量的方式調整為:
#                                                   (1)單價含稅時,以含稅金額/(1+稅率)/100 = 未稅金額 
#                                                   (1)單價未稅時,以未稅金額*(1+稅率)/100 = 含稅金額 
# Modify.........: No.MOD-840156 08/04/20 By claire (1)單身自動產生時,MISC料品名不會帶出
#                                                   (2)單身自動產生時,misc料的倉庫為控卡為必輸入欄位
# Modify.........: No.MOD-840221 08/04/20 By claire 自動帶出單身時,採購料件品名,採購料件規格寫入錯誤
# Modify.........: No.MOD-840513 08/04/22 By claire 自行輸入單身時,會帶不出採購單資料
# Modify.........: No.MOD-840263 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.MOD-840575 08/04/23 By ve007 GP5.1顧問測試修改
# Modify.........: No.FUN-840187 08/04/24 By Nicola 從採購單產生單身時，開窗讓使用者輸入批/序號資料
# Modify.........: No.FUN-840157 08/04/24 By Nicola IQC做批/序號管理
# Modify.........: No.CHI-840071 08/05/06 By Dido 調整 Transation 架構語法
# Modify.........: No.CHI-840066 08/05/06 By claire 委外製程時,不確認最小發料套數
# Modify.........: No.MOD-850093 08/05/09 By claire 最終供應商值為NULL時應給空值,才不會誤判
# Modify.........: No.FUN-850120 08/05/21 By rainy 批序號新增參數 sma90 判斷
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: No.MOD-850298 08/05/30 By Smapmin 調整MOD-830171
# Modify.........: No.MOD-850311 08/05/30 By Smapmin 委外收貨作業在抓取收貨-退貨數量時,應加入採購單號的條件
# Modify.........: No.MOD-860054 08/06/09 By Smapmin 將製程委外控管最小發料套數的部份,改為判斷實收數量不能大於未收數量
# Modify.........: No.MOD-860080 08/06/09 By Nicola 自動產生入庫/銷退單時，判斷smy57為"Y"則只能產生一次，如為"N"則用允收量-已入庫量
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-860105 08/06/11 By Smapmin 修正MOD-850311
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.MOD-860172 08/06/16 By Smapmin 實收量預設值若小於0,則default 0 
# Modify.........: No.MOD-860297 08/06/25 By Smapmin rvv39t未做幣別取位
# Modify.........: No.FUN-850022 08/06/26 By Kevin 將Function t110_get_rvb39()獨立成共用程式
# Modify.........: No.MOD-860330 08/06/30 By Nicola 把g_i的值清空
# Modify.........: No.MOD-860146 08/07/14 By Smapmin pmh_file多加pmh21/pmh22的key值
# Modify.........: No.MOD-850156 08/07/14 By Pengu 1.確認段在判斷是否有入庫單據時不應排除作廢的入庫單
#                                                  2.產生入庫/驗退action段在判斷是否有入庫/驗退單據時不應排除作廢的單據
# Modify.........: No.MOD-860013 08/08/05 By lumx  調整抓取最小發料套數的關于sfa08的判斷，避免不走制程但是單身有作業編號時候無法收貨
# Modify.........: No.TQC-880009 08/08/07 By chenyu 審核,取消審核和生成入庫單時需要判斷采購單的狀態，必須是'2.發出采購單'才可以
# Modify.........: No.MOD-880083 08/08/14 By wujie  不走委外制程時，最小發料套數取錯
# Modify.........: No.TQC-880051 08/08/26 By chenyu icd版的時候，審核時會報錯
# Modify.........: NO.FUN-880016 08/08/21 BY yiting 增加GPM控管
# Modify.........: No.MOD-880166 08/09/03 By claire 可入庫量(rvb31),若為檢驗料件應以IQC允收數推算,不應直接帶入收貨數(rvb07)
# Modify.........: No.TQC-880058 08/09/03 By claire 可入庫量(rvb31),免驗檢驗料件應直接帶入收貨量(rvb07)
# Modify.........: No.MOD-890005 08/09/03 By chenyu 使用多單位的時候，庫存數量會有減半的情況發生
# Modify.........: No.MOD-890023 08/09/03 By chenyu ICD功能修改
# Modify.........: No.FUN-870117 08/09/03 BY ve007  收貨替代功能修改
# Modify.........: No.MOD-880255 08/09/05 By chenl  修正實收數量變回舊值時，無法更新計價數量的問題。
# Modify.........: No.MOD-890074 08/09/10 By chenyu 給g_totsuccess一個初始值，不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.MOD-890147 08/09/16 By Smapmin 使用多單位時,超短交的卡關有誤
# Modify.........: No.MOD-890170 08/09/18 By Smapmin 實收數量不可為0
# Modify.........: No.MOD-890236 08/09/24 By chenl  修正多單位條件下，直接通過單身輸入采購單時，帶出多單位數量不正確的情況。
# Modify.........: No.MOD-890253 08/09/25 By Smapmin 修改倉庫required的控管
# Modify.........: No.MOD-880189 08/08/25 By chenl   更改單頭供應商時，應稽核單身采購單是否存在不屬于該供應商的單據，若有，則不可修改供應商資料。
# Modify.........: No.MOD-890276 08/10/01 By Smapmin 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-840012 08/04/28 By kim 提供自動確認的功能
# Modify.........: No.MOD-8A0074 08/10/08 By Smapmin 若有做QC產生允收數量時,所產生的入庫單因為計價數量未重計導致入庫單的金額有誤
# Modify.........: No.FUN-8A0054 08/10/13 By sabrina 若沒有勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.MOD-8A0112 08/10/14 By chenyu 生成入庫/驗退邏輯的修改
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.TQC-8A0059 08/10/24 By Smapmin 回寫pmn57的數量有誤
# Modify.........: No.MOD-8B0059 08/11/07 By Smapmin 取消作廢時,採購單狀況必須為已發出
# Modify.........: No.MOD-8B0037 08/11/10 By Smapmin 修正MOD-890170
# Modify.........: No.MOD-8B0283 08/11/28 By sherry 在倉庫的地方也作判斷是否收至該倉庫
# Modify.........: No.MOD-8C0007 08/12/02 By Smapmin 為避免畫面沒關閉殘留舊值,故針對採購單的數量重新抓取
# Modify.........: No.MOD-8B0273 08/12/03 By chenyu icd版本重新取單價時重新計算
# Modify.........: No.MOD-8C0027 08/12/09 By clover 調整t110_min_c1 CURSOR的SQL條件，加入sfa161>0 的條件
# Modify.........: No.MOD-8C0080 08/12/09 By chenyu 完善MOD-8A0112的處理
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-8C0181 08/12/24 By Smapmin 取消確認時,應判斷收貨單是否做批序號管理來決定是否刪除tlfs_file
# Modify.........: No.FUN-880085 09/01/02 By kevin 取消作廢時判斷eB-Online底稿區資料是否未確認
# Modify.........: No.MOD-910053 09/01/14 By Smapmin 自動確認後產生的入庫單,入庫日期應default收貨日期
# Modify.........: No.MOD-910172 09/01/15 By Smpamin 抓取作業編號時,委外還要區分製程與非製程
# Modify.........: No.MOD-910226 09/01/21 By Smapmin 由採購單自動產生收料單時,也要考慮是否開窗詢問新增庫存明細表
# Modify.........: No.MOD-910227 09/01/21 By Smapmin 製程委外時,不需新增img_file
# Modify.........: No.MOD-910239 09/01/21 By sherry  1、修改消耗材料及代買料的發料套數 
#                                                    2、追21區MOD-7B0203
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920003 09/02/02 BY ve007 收貨品名與采購品名一致
# Modify.........: No.FUN-910077 09/02/03 BY kim 確認時產生icd入庫單的資料有漏
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920067 09/02/05 By Smapmin 調整TQC-880009
# Modify.........: No.FUN-920073 09/02/10 By jan aict041當此采購單+項次 若存在於 pmn68+pmn69  則不可輸入 
# Modify.........: No.FUN-920080 09/02/10 By jan 修改程式
# Modify.........: No.CHI-920041 09/02/11 BY ve007 強制使用者一定要輸入倉儲批才可離開
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153 
# Modify.........: No.CHI-920060 09/02/18 By jan 行業別程式調用改寫
# Modify.........: No.CHI-920064 09/02/19 BY kim 修正icd行業數項問題
# Modify.........: No.CHI-920083 09/02/25 BY kim 修正icd行業數項問題
# Modify.........: No.MOD-930044 09/03/05 By Pengu 製程委外在收貨時會將供單狀態UPDATE為6.FQC
# Moidfy.........: No.MOD-930220 09/03/18 By chenyu 免檢驗料件，沒有勾選面檢驗料件直接入庫的時候點"生成入庫/驗退"無法入庫
# Modify.........: No.TQC-930136 09/03/23 By chenyu t110_ind_icd_trans_copy_ida()中，sql語句寫錯
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-930320 09/04/02 By Smapmin 單身輸入針對sma110的控管,提前於BEFORE INSERT控管
# Modify.........: No.MOD-930262 09/04/08 By chenyu 轉aqct110里面檢驗量的時候，要審核過的檢驗單才可以
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.MOD-940174 09/04/13 By lutingting p_wono未定義
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun Fetch時增加報錯
# Modify.........: No.TQC-940066 09/04/14 By kim 由收貨單確認自動產生的入庫單的rvvi_file資料未帶入
# Modify.........: No.MOD-940127 09/04/14 by Smapmin 料號不存在時,單身無法顯示
# Modify.........: No.MOD-940056 09/04/14 By Smapmin 當rvb08為0或是null時,才default為rvb07.
# Modify.........: No.MOD-940078 09/04/14 By Smapmin pmh08於登打收貨單後又更改,於確認段時要再次更新rvb39
# Modify.........: No.TQC-940072 09/04/15 By kim for ICD Turnkey流程且有製程編號時，確認時不應檢查發料數量
# Modify.........: No.MOD-940245 09/04/21 By Smapmin 被OUTER的欄位不可再OUTER其他欄位
# Modify.........: No.MOD-940250 09/04/23 By chenyu 確認時，將超交的報錯信息在一起顯示出來
# Modify.........: No.MOD-940325 09/04/24 By chenyu 生產入庫單的時候，sql語句判斷有漏洞
# Modify.........: No.MOD-940365 09/04/30 By Dido 批序號管理產生入庫時應包含 TAP 多角採購類別
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950039 09/05/08 By chenyu 同步TQC-810094到5.1以上版本
# Modify.........: No.FUN-940083 09/05/19 By douzh 新增VIM管理
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-950040 09/06/11 By jan 收貨單開立時，輸入收貨數量后，需作量的檢查控卡
# Modify.........: No.TQC-960445 09/07/01 By lilingyu 非空字段rvb10出現NULL的情況,導致insert into rvb_file報-391的錯
# Modify.........: No.MOD-970023 09/07/06 By Smapmin 收貨單自動確認產生的入庫單，異動日期單頭單身不一致.
# Modify.........: No.TQC-950054 09/07/10 By jan updat行業別檔時，KEY值一并update 
# Modify.........: No.FUN-940138 09/07/10 By jan mark 掉FUN-920073的內容
# Modify.........: No.FUN-960130 09/07/16 By Sunyanchun 超市移植
# Modify.........: No.MOD-970230 09/07/27 By Dido 使用多單位且料件為單一單位時,單位一的轉換率有錯誤
# Modify.........: No.MOD-970207 09/07/30 By Smapmin 使用多單位,料號為單一單位時,單位一的數量有誤
# Modify.........: No.MOD-970259 09/07/31 By Dido 採購單調整時重計 rvb10t 
# Modify.........: No.TQC-970355 09/07/29 By dxfwo  1.采購收貨料件不同的替代，使用一般料號替代原則時，假設同料同起始截止位置能被二個不同數據替代，
#                                                     會出錯! 應該是程序在AFTER FEILD rvb05的  FOR l_i=1 TO l_tpmu00 到 END FOR的範圍錯了，END FOR應該要包含如果有一筆的l_cnt >0 就正確
#                                                   2.確認時產生tlff_file的判斷比取消確認時刪除tlff_file多了，兩邊應該一致
# Modify.........: No.MOD-980043 09/08/13 By Dido rvb22 新增時大陸版應不可輸入
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: NO.FUN-980006 09/08/28 By TSD.jarlin	修改註解請統一放 "GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990024 09/09/02 By Smapmin 修改取消確認時,更新工單狀態的邏輯
# Modify.........: No.MOD-990083 09/09/09 By mike 6807行與7370行,都增加判斷若入庫日小於收貨日(rvu03<rva06),則顯示錯誤訊息/LET g_succ
# Modify.........: No.FUN-980038 09/09/10 By chenmoyan rva10的值由smy72代出
# Modify.........: No.MOD-990085 09/09/11 By Smapmin t110_minp()計算最小發料數時,也要考慮sfa100的誤差率
# Modify.........: No.TQC-970351 09/07/30 By baofei修改ICD 1._cs()段，g_sql 組處理錯誤                                              
#                                                          2.單頭修改時，修改rvbi_file  
# Modify.........: No.MOD-980139 09/10/06 By Smapmin 確認時最小發料套數的檢核應與實收數量輸入時的檢核一致.
# Modify.........: No.MOD-980191 09/10/06 By Smapmin 特採無法自動產生驗退單
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.TQC-9A0066 09/10/15 By lilingyu "付款方式 付款條件 稅種 幣種"等欄位無法開窗查詢資料
# Modify.........: No.MOD-990077 09/10/15 By Smapmin 收貨單做批序號管理,收貨單產生入庫驗退時,驗退單沒有rvbs_file的資料也一併修改
# Modify.........: No.MOD-9A0098 09/10/15 By Smapmin 收貨數量重新default
# Modify.........: No.FUN-9A0068 09/10/28 By douzh VMI测试结果反馈及相关调整
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:MOD-9A0176 09/11/09 By Smapmin 免檢驗料件直接入庫時,要check img_file
# Modify.........: No:MOD-9B0011 09/11/09 By Smapmin 免檢驗料件直接入庫產生rvvi_file時,參考的rvbi_file未依項次重新抓取
# Modify.........: No:CHI-980024 09/11/17 By jan 修改b_fill()段的sql錯誤
# Modify.........: No:MOD-9B0111 09/11/18 By Smapmin 實收數小於等於0時不可確認
# Modify.........: No:TQC-9B0110 09/11/19 By Carrier 税率非空时,才判断是否大于0等
# Modify.........: No:TQC-9B0203 09/11/25 By douzh 单身输入税前单价，含税单价未自动计算出
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:MOD-9C0016 09/12/03 By mike 原有的零售管控非成本仓拿掉
# Modify.........: No:TQC-9B0191 09/12/03 By jan 修改aict041 異動單號開窗
# Modify.........: No:TQC-9B0226 09/12/03 By jan 產生的入庫單時，給rvuoriu和rvuorig這兩個欄位賦值
# Modify.........: No:TQC-9C0053 09/12/08 By jan 在修改輸入單身時，VMI收貨否rvb89要給個默認值‘N'
# Modify.........: No:FUN-9C0046 09/12/09 BY wuxj 單身新增欄位rvb93，新增action電子採購收貨，刪除單身及整張收貨單前的判斷
#                  No:FUN-A10034 10/01/07 By wuxj
# Modify.........: No:FUN-9C0074 09/12/15 BY bnlent 零售业rvv03赋值取消判断经营方式 
# Modify.........: No:FUN-9C0082 09/12/16 BY cockroach   只過單，未修改
# Modify.........: No:FUN-9C0075 09/12/17 By cockroach rvb42默認值改為4
# Modify.........: No:MOD-9C0302 09/12/29 By jan 把免驗料自動產生入庫單的g_argv6 <> '2' THEN控管拿掉
# Modify.........: No:FUN-A10001 10/01/9 by dxfwo  VMI bug 新增廠商時，VMI否="Y"時，倉庫儲位不能修改
# Modify.........: No:MOD-9C0391 09/12/24 By sherry 過採購單項次的時候就應該把rvb07的值給rvb08
# Modify.........: No:FUN-9C0071 10/01/18 By huangrh 精簡程式
# Modify.........: No:MOD-A10104 10/01/20 By Smapmin 無法自動產生單身
# Modify.........: No:MOD-A10105 10/01/20 By Smapmin 檢核確認前是否存在採購變更單
# Modify.........: No:MOD-A10113 10/01/20 By Smapmin 當sfa100=100時,表示不發料,最小發料套數等於生產數量
# Modify.........: No:TQC-A10160 10/01/26 By lilingyu 輸入完單頭,彈出提示"是否自動帶出此采購單的未收資料",點擊是,系統報錯-391
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotin加一個參數:歸屬單號
# Modify.........: No.FUN-A30063 10/03/22 By Cockroach add rvacont
# Modify.........: No:FUN-9C0076 10/03/30 By Lilan EasyFlow整合功能
# Modify.........: No:FUN-A40014 10/04/09 By liuxqa 增加快速收货功能
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A40112 10/04/20 By Smapmin 修正錯誤訊息顯示時機
# Modify.........: No:TQC-A40099 10/04/21 By liuxqa after row 后面判断数量时，需减去已有收货单，但是未审核的收货数量。
# Modify.........: No:FUN-A10130 10/05/05 By jan 拆分出確認功能
# Modify.........: No:CHI-A50012 10/05/25 By Summer 寫入rvu_file時,給予rvu101/rvu102/rvu100預設值
# Modify.........: No.FUN-A50071 10/05/26 By lixia 程序增加POS單號字段 并增加管控
# Modify.........: No:CHI-A40068 10/05/26 By Summer 變更"串查button真正對應的程式
# Modify.........: No.FUN-A50054 10/05/31 By chenmoyan 增加服饰版二维功能 
# Modify.........: No.TQC-A60021 10/06/17 By houlia 錄入時賦值rvacrat
# Modify.........: No:FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/25 By huangtao  製造功能優化-平行製程(批量修改)
# Modify.........: No.FUN-A60035 10/07/06 By chenls 服飾狀態下單身顯示問題
# Modify.........: No:MOD-A70160 10/07/23 By Smapmin 驗退單的多單位數量不正確
# Modify.........: No.FUN-A60035 10/07/27 By chenls 服飾二維功能mark
# Modify.........: No:MOD-A60162 10/07/30 By Smapmin 作廢時,單身的發票號碼要清空
# Modify.........: No:MOD-A50122 10/07/30 By Smapmin 輸入採購項次後未default rvb89
# Modify.........: No:CHI-A70031 10/08/03 By Smapmin 維護完入庫單後要重新顯示收貨單單身的入庫量
# Modify.........: No:MOD-A80052 10/08/09 By Dido 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:MOD-A80037 10/08/12 By Smapmin 收貨單產生入庫/驗退時,若入庫/驗退單別為自動確認,則必須將入庫/驗退單做確認
# Modify.........: No:MOD-A80109 10/08/13 By Smapmin 補登發票加上權限控管
# Modify.........: No:CHI-A80024 10/08/16 By Smapmin 以庫存的角度來看批序號，於製程間委外自然是不需做批/序號管控的
# Modify.........: No:FUN-A80026 10/08/17 By Carrier 产生入库单后,自动产生AP资料
# Modify.........: No:FUN-A80112 10/08/20 By houlia 加Action"產生QC單"
# Modify.........: No:FUN-A90022 10/09/07 By houlia aza95="N", Action"電子採購收貨"不可視
# Modify.........: No:FUN-A80150 10/09/08 By sabrina 單身新增"計畫批號"(rvb919)欄位 
# Modify.........: No:CHI-A80037 10/09/29 By Summer 單身採購單號開窗,應只能顯示單頭採購性質的採購單
# Modify.........: No:MOD-AA0074 10/10/14 By sabrina 若單身筆數為0，則不走CHI-860008所加的程式段
# Modify.........: No:FUN-A20017 10/10/22 by jan 新增 委外聯產品 的處理
# Modify.........: No:MOD-A90197 10/10/22 By Smapmin 產生入庫單要檢查入庫單號是否重複時,要考慮作廢的入庫單
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-A40022 10/10/25 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AA0010 10/10/25 By jan如果料件設定為無聯產品(ima903='N'),但有設收貨替代,此時無法指定料件,應該要可以指定
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0025 10/11/12 By vealxu AFTER FIELD pmn04 不需CALL sub控卡
# Modify.........: No:MOD-AB0145 10/11/16 By Smapmin ICD分批收貨,計價數量有錯
# Modify.........: No:MOD-AB0076 10/11/16 By Smapmin 將批序號數量回寫單據數量時,金額要重算
# Modify.........: No:MOD-AA0188 10/11/17 By Smapmin 修正MOD-A10105
# Modify.........: No:MOD-A90112 10/11/17 By Smapmin 當單頭採購性質修改時,應判斷單身若有採購單號,則單頭採購性質不能修改.
# Modify.........: No:MOD-A90065 10/11/17 By Smapmin 修正錯誤訊息顯示
# Modify.........: No:MOD-A80180 10/11/17 By Smapmin 輸入完發票號碼後,應該都要帶起發票資料維護作業
# Modify.........: No:MOD-AB0176 10/11/18 By Smapmin 未輸入單身資料,按補登發票後程式就當掉
# Modify.........: No:FUN-AB0066 10/11/18 By lilingyu 增加倉庫權限的控管
# Modify.........: No:MOD-AB0204 10/11/23 By lilingyu rvb40未賦值,導致插入採購入庫資料時,報錯:apm-264
# Modify.........: No:TQC-AB0376 10/12/01 By lixh1    調整CONSTRUCT順序,"資料建立者"開放查詢
# Modify.........: No:MOD-AB0244 10/11/29 By Smapmin 修正MOD-940325,MOD-A80037
# Modify.........: No:TQC-AB0224 10/12/01 By jan 產生入庫單時，含稅單價沒有帶出資料
# Modify.........: No.TQC-AB0165 10/12/04 By vealxu apmt200產生入庫單後發現，rvv35_fac(轉換率)無資料
# Modify.........: No:FUN-A50030 10/12/09 By Lilan ICD行業別加入EF簽核功能
# Modify.........: No.TQC-AC0273 10/12/21 By vealxu 銷售單位有設，但委外收貨時，由採購單帶入卻說沒設
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# ModifY.........: NO:MOD-AC0260 10/12/24 By Smapmin 增加提示同一收貨單單身的採購單幣別不同.
# Modify.........: No:MOD-AB0227 10/12/24 By Smapmin 非ICD產業,實收量會控管不可大於最小發料套數(apm-307)
#                                                    若是ICD產業,應控管不良+報廢+實收不可大於最小發料套數.
# Modify.........; No:MOD-AC0114 10/12/24 By Smapmin 修正MOD-AB0227
# Modify.........: No:MOD-AC0306 10/12/17 By chenying 修改報錯信息
# Modify.........: No:MOD-AC0024 11/01/06 By sabrina 未稅金額與採購單不同
# Modify.........: No:MOD-AC0306 11/01/07 By chenying 還原修改報錯信息
# Modify.........: No:TQC-B10202 11/01/20 By lilingyu  調用aict041畫面時,增加g_prog控管
# Modify.........: No:TQC-B10220 11/01/21 By lilingyu  還原TQC-B10202修改內容
# Modify.........: NO:MOD-B10208 11/01/26 By Summer 修正錯誤訊息apm-248
# Modify.........: NO:TQC-B20024 11/02/15 By lilingyu 新增一筆收貨單,自動產生單身資料,當更改了實收數量後,後台rvb10會變為含稅單價,導致入庫單中取出的稅前單價也是含稅單價
# Modify.........: NO:TQC-B20099 11/02/18 By lilingyu asms250中設置參數"收料時同時錄入發票資料"選項為N,但是在apmt110作業時仍然可以錄入,沒有進行控管
# Modify.........: NO:TQC-B20115 11/02/21 By 自動產生單身時rvb919/rvb90 沒值
# Modify.........: NO:TQC-B30010 11/03/02 By wuxj   电子采购收货action时，取消画面清空问题
# Modify.........: NO:FUN-A60009 11/03/08 By Lilan EF整合apmt720相關調整
# Modify.........: NO:MOD-B30433 11/03/15 By chenying Action "產生入庫/ 驗退",實際上卻沒有產生,報訊息已產生，不可重複產生-->還原MOD-AB0204
# Modify.........: NO:MOD-B30598 11/03/17 By Summer 總部業態共用所以程式判別預設倉庫,應先判對rtz07是否為Null或空白,則不複蓋以原取出倉庫為主 
# Modify.........: NO:MOD-B30513 11/03/17 By wujie  apmt111抛入库单时漏了交易页签的资料
# Modify.........: NO:MOD-B30584 11/03/17 By chenying 收貨單[產生入庫單]報錯誤訊息--->多角在產生rvb_file時,都沒有處理rvb90的欄位
# Modify.........: NO:TQC-B30180 11/03/28 By lilingyu 錄完單頭,自動帶出採購單之未收資料時,控管可收貨次數有誤
# Modify.........: No:MOD-B30090 11/03/29 By Summer 若去單身項次2調整為項次1資料，再改回項次2時，若不next row則會出現料號仍為上一筆項次的情形發生
# Modify.........: No.FUN-B30161 11/03/30 By xianghui 原smy74的判斷改為sma91,CALL t720_gen_ap之前加判斷，g_rva.rva10='REG'才可執行
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: NO:MOD-B40006 11/04/06 By Summer 修正MOD-AA0074
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:TQC-B40081 11/04/12 By lilingyu 過單;暫MARK FUN-B30161 添加字段sma91
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B40126 11/04/15 By zhangll sma134相关控管逻辑错误修正
# Modify.........: No:MOD-B40185 11/04/20 By lilingyu 點擊"產生入庫/驗退"按鈕,出現"apm-111此收貨單早已生成入庫/驗退資料"錯誤信息
# Modify.........: No:TQC-B40213 11/04/26 By lilingyu 查詢時,去掉g_auth這個變量的條件限制
# Modify.........: No:FUN-B40085 11/04/26 Byxianghui 加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40098 11/04/29 By shiwuying 扣率代銷時，倉庫取arti200中設置的非成本倉rtz08
# Modify.........: No:CHI-AC0016 11/05/30 By Smapmin 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:TQC-B60003 11/06/01 By jan apmt200_icd 批號 輸入後檢查不過
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40083 11/06/08 By guoch 收貨、入庫時沒有廠牌的顯示欄位，對收貨入庫而言不方便
# Modify.........: No.TQC-B60096 11/06/16 By lixiang 修正進行修改操作時，會更改實收量的問題
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:TQC-B60218 11/06/21 By lixiang  查詢時由廠商編號帶出簡稱
# Modify.........: No:TQC-B60252 11/06/21 By xjll   還原FUN-B30161和TQC-B40081 mark 和unmark的部分程序  
# Modify.........: No:TQC-B60304 11/06/22 By wuxj   還原TQC-B20099的修改
# Modify.........: No:FUN-B60127 11/06/29 By baogc 新增整批收貨功能
# Modify.........: No.FUN-B30187 11/06/30 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No.FUN-B60150 11/07/05 By baogc 成本代銷時，倉庫取arti200中設置的成本rtz07
# Modify.........: No.CHI-B70016 11/07/13 By xianghui 程式處理單身新增多筆資料時，一並處理行業別table
# Modify.........: No:FUN-B70061 11/07/20 By jason 維護刻號/BIN回寫母批DATECODE
# Modify.........: No:TQC-B80005 11/08/02 By jason 修正不使用計價單位時修改單身,ima908有值會無窮迴圈 
# Modify.........: No:MOD-B80064 11/08/05 By johung 修改預設收貨數量異常
# Modify.........: No:MOD-B80084 11/08/08 By johung 還原TQC-B60096修改
#                                                   修正AFTER FIELD rvb03，實收量rvb07會被改掉
# Modify.........: No:MOD-B80088 11/08/09 By johung 自動列印前先做t100sub_y_chk
# Modify.........: No:MOD-B80156 11/08/16 By johung 存檔前若rvb87為NULL則CALL t110_set_rvb87()
# Modify.........: No:TQC-B80155 11/08/22 By guoch rvb10,rvb10t在on row change时未能截取，进行bug修改
# Modify.........: No.MOD-B80298 11/09/02 By suncx 收貨單單頭未錄入採購單單號的單據，單身計算含稅未稅單價的稅率應已單身採購單號抓取對應匯率
# Modify.........: No:CHI-B80038 11/09/02 By johung 修正稅別含稅時單身應只可打含稅單價
#                                                   rva=00時，判斷需重新取價
# Modify.........: No:MOD-B80272 11/09/02 By johung 修正icd行業時樣品否沒有預設值的問題
#                                                   修正收貨數量計算問題
# Modify.........: No.TQC-B90034 11/09/14 By lilingyu 進入[倉庫別]欄位時，提示報錯訊息，無法退出或更改欄位
# Modify.........: No.FUN-B50096 11/09/19 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.CHI-B90021 11/09/20 By lixh1  拿掉AFTER ROW 之後判斷批號不可為空的程式
# Modify.........: NO:FUN-B90012 11/09/23 By fengrui 修改g_argv2值為'TAP'的處理
# Modify.........: No:MOD-BA0030 11/10/11 By Smapmin修正錯誤訊息顯示
# Modify.........: No:MOD-BA0069 11/10/12 By suncx apmt111單身收貨數量無法錄入
# Modify.........: No.FUN-B90101 11/10/26 By lixiang 服飾改用二維處理方式
# Modify.........: No.FUN-BB0084 11/11/25 By lixh1 增加數量欄位小數取位
# Modify.........: NO:MOD-B90224 11/12/12 By Summer 控卡收貨單項次不能為0 
# Modify.........: NO:MOD-B90256 11/12/12 By Summer 條件須加上單號 
# Modify.........: No:MOD-BC0068 11/12/12 By Summer JIT收貨不控卡apm-133 
# Modify.........: NO:CHI-B60084 11/12/12 By Summer 控卡apm-307時,加串聯產品bmm_file
# Modify.........: NO:MOD-B90100 11/12/12 By Summer 判斷最小發料套數時需排除委外tky非最終站的收貨數量
# Modify.........: No.FUN-B80093 12/01/05 By pauline 控管VIM相關欄位
# Modify.........: No.FUN-BC0104 12/01/06 By xianghui 增加"QC 結果判定產生入庫單"功能
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao 原執行s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   原於_r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數(項次)傳""
#                                                   原執行s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.FUN-BB0001 12/01/18 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.FUN-BB0086 12/01/30 By tanxc 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20002 12/02/03 By fanbj 券產品倉庫調整
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾二維BUG修改(對多屬性料件的判斷，製造業開啟的畫面等)
# Modify.........: No.FUN-C20047 12/02/08 By xianghui 修改FUN-BC0104的一些問題
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:TQC-C20117 12/02/10 By xjll 修改服飾業業態='2' 所開啟的畫面
# Modify.........: No.FUN-BA0051 12/02/13 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BC0109 12/02/13 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No:TQC-BB0248 12/02/13 By Carrier show()时增加付款方式/价格条件说明的显示
# Modify.........: No:FUN-C20076 12/02/14 By lixh1 将函数t110_ins_rvu()独立至sapmt110_sub.4gl
# Modify.........: No:MOD-BA0178 12/02/16 By bart 修改單身項次時,要先判斷若有rvbs_file的資料時,要先update rvbs_file的項次
# Modify.........: No:TQC-C20196 12/02/17 By lixh1 修改t110sub_ins_rvu()傳參問題
# Modify.........: No:TQC-C20232 12/02/17 By xjll   如果採購單有值時則抓取採購單的倉儲批
# Modify.........: No:TQC-BB0195 12/02/17 By SunLM  查詢VMI發料單q_rva117
# Modify.........: No:TQC-C20183 12/02/20 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20339 12/02/21 By lixiang BUG修改
# Modify.........: No:TQC-C20348 12/02/22 By lixiang  服飾流通業母料件的開窗
# Modify.........: No:MOD-BB0278 12/02/24 By Vampire 單身資料都是misc的料件時，apmt720時沒辦法顯示rvv031的資料
# Modify.........: No:MOD-BB0343 12/02/24 By Vampire 原本條件抓單號+料號,改抓單號+項次
# Modify.........: No:MOD-BC0039 12/02/24 By bart 修正收貨料號與採購料號品名規格呈現
# Modify.........: No:TQC-C10074 12/02/27 By suncx 單身從採購單中挑選功能BUG修正
# Modify.........: No:MOD-BB0141 12/02/27 By Vampire apmt110已經會依項次update發票號碼,故請mark掉sapmt114.4gl的621行~625行
# Modify.........: No:TQC-C20521 12/02/28 By lixh1 調用aqcp107產生入庫單前給出相應的提示
# Modify.........: No:TQC-C30005 12/03/01 By lixiang rvbslk42為null時，給' '空值
# Modify.........: No:MOD-C30133 12/03/09 By zhuhao 收貨單未確認，不可產生QC單
# Modify.........: No:TQC-C30193 12/03/10 by jason FOR ICD tk流程修改
# Modify.........: No:MOD-C30256 12/03/10 By zhuhao 單身新增時，rvb29,rvb30預設為0
# Modify.........: No:MOD-C30217 12/03/10 By lixiang  控管數量欄位數量不可小於零
# Modify.........: No:MOD-C30362 12/03/12 By zhuhao apmt111寫入時rvb19=‘1’
# Modify.........: No:MOD-C30248 12/03/12 By zhuhao 進單身前，加判斷，滿足條件，則call t110_g_b
# Modify.........: No:MOD-C30349 12/03/13 By lixh1 依QC結果判定產生入庫單的時候不需要考慮已作廢的QC單據
# Modify.........: No:MOD-C30434 12/03/13 By zhuhao 點選快速收貨時 應根據單頭的採購單號 進行刪選
# Modify.........: No:TQC-C30195 12/03/14 By lixh1 收貨單單身有多筆料件資料時,應產生一筆入庫單資料集即可,所以料號就不需要傳入
# Modify.........: No:MOD-C30364 12/03/14 By dongsz 實收量不可大於 採購量*（1+超交率）
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)送簽中,應不可執行ACTION[補登發票]
#                                                  (2)圖示錯誤,N:未確認,1:已核准 未show"核"
# Modify.........: No:TQC-C30288 12/03/23 By destiny  icd行业,aic-120报错改为询问方式             
# Modify.........: No.FUN-C30063 12/03/28 By Sakura 於產生QC單下方增加"查詢QC單"Action，自動執行aqct110，帶出該收貨單資料
# Modify.........: No:FUN-C30293 12/03/29 By Abby  執行[單身],按"確定",狀況碼才能變成0.開立
# Modify.........: No:FUN-C30279 12/04/02 By bart 要可以入"MRP可用='N'"的採購單
# Modify.........: No:FUN-C30281 12/04/02 By bart 單身母批預設發料單的第一筆母批
# Modify.........: No.MOD-C30793 12/04/04 By Vampire AFTER INSER再判斷一次倉儲批是否存在
# Modify.........: No.TQC-C40005 12/04/05 By suncx 大陸版時，隱藏補登發票功能按鈕
# Modify.........: No:CHI-C30118 12/04/09 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No:TQC-C40027 12/04/09 By zhuhao QC質檢后加成功確認的信息
# Modify.........: No:FUN-C40015 12/04/09 By lixh1 執行'QC結果判定產生單據'ACTION 之後給出提示信息
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.TQC-C30225 12/04/12 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No.TQC-C40060 12/04/16 By zhuhao QC質檢后加成功確認的信息修改
# Modify.........: No:FUN-C30302 12/04/20 By bart 修改 s_icdin 回傳值
# Modify.........: No.TQC-C40254 12/04/26 By tanxc 查詢QC單時，增加行業別判斷
# Modify.........: No.MOD-C40192 12/04/29 By Elise sma134為零售業使用,增加零售業的判斷
# Modify.........: No.TQC-C40197 12/05/02 By qiaozy 用鼠標點擊下一行新增時報錯
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C50122 12/05/28 By bart 1.CP數量驗證時須把數量乘上(單位轉換分子/單位轉換分母)
#                                                 2.抓不到上一站時，CP從工單備料抓已發數，其他抓採購單pmn82做驗證
#                                                 3.回寫回收貨單單身的不良品數與報廢數欄位
# Modify.........: No.MOD-C60005 12/06/01 By SunLM 雙單位時候隱藏rvb90收貨單位
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:TQC-C60023 12/06/05 By bart Wafer採購收貨的刻號/BIN,若收25片,則需自動產生刻號001~025的刻號,BIN00的資料
# Modify.........: No.FUN-C30166 12/06/12 By bart 檢查最小發料套數
# Modify.........: No:TQC-C60020 12/06/14 By bart datecode可維護
# Modify.........: No.MOD-C40188 12/06/15 By Vampire 查詢時的開窗,建議增加pmm02採購性質條件
# Modify.........: No.MOD-C50224 12/06/15 By Vampire 單身的rvb90_fac都是1，不會跟著轉換率而改變
# Modify.........: No.TQC-C60192 12/06/25 By bart 當收貨數量修改後,應default帶到計價數量
# Modify.........: No.FUN-C60088 12/06/25 By qiaozy 服飾流通隱藏收穫入庫和單身切換action
# Modify.........: No.FUN-C60100 12/06/26 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No.FUN-C60071 12/06/27 By suncx 樣品改善，rvb35改為N:非樣品、Y:樣品不付款、P:樣品需付款
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No.MOD-C50208 12/07/03 By Vampire 沒有經過 rva04 欄位直接按確定,則rva04會給不到值
# Modify.........: No.TQC-C70103 12/07/17 By yangtt 在rva02,rvb04的開窗條件中添加超交量判斷
# Modify.........: No.TQC-C70118 12/07/19 By bart AFTER FIELD rvbslk37 加上排除委外收貨單
# Modify.........: No:MOD-C70237 12/08/07 By Vampire 需增加判斷採購單
# Modify.........: No:FUN-C80030 12/08/10 By fengrui 添加批序號依參數sma95隱藏
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No.CHI-C80009 12/08/22 By Sakura ICD單身修改時需顯示"刻號/BIN入庫(aic_s_icdin)"
# Modify.........: No.FUN-C30248 12/09/10 By pauline 在做委外收貨時，依照產品編號的收貨數量，再利用該料件的QPA計算收貨數量
# Modify.........: No.FUN-C90077 12/09/18 By lixh1 自動產生單身時不需要彈出apm1078的提示
# Modify.........: No:MOD-C20091 12/09/26 by jt_chen 若參數設定可直接新增倉儲時，應警告但不卡住較為合理。
# Modify.........: No:MOD-C80049 12/09/27 By Vampire 收貨單自動入庫的則不直接CALL t720sub_ecm串報工單，整個Transaction結束之後再串
# Modify.........: No:TQC-C80120 12/09/27 By Vampire 只判斷入庫單是否存在,導致一般採購收貨入庫會去串報工單
# Modify.........: No:MOD-C90138 12/09/27 By jt_chen 一般收貨才顯示單身從採購單挑選、快速收貨,JIT收貨則隱藏
# Modify.........: No:TQC-C90128 12/09/28 By dongsz 傳參時傳入入庫單和驗退單單號，以便點擊查詢入庫/查詢驗退能及時顯示出異動資料
# Modify.........: No:TQC-CA0043 12/10/16 By hongmei 傳參時傳入入庫單和驗退單單號，以便點擊查詢入庫/查詢驗退能及時顯示出異動資料
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No.FUN-CB0014 12/11/13 By xujing 增加資料清單
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-C30039 12/12/12 By pauline 單身收貨替代料時,收貨料號開窗查詢應預先查詢帶出apmi303的替代料資料
# Modify.........: No:FUN-CC0011 12/12/24 By Lori 將原產生入庫單與QC結果判定產生入庫單合為同一action，系統自動判斷是否走qc判定
# Modify.........: No:MOD-CC0047 13/01/11 By Elise 入庫單且為重工工單，不控卡axm-396
# Modify.........: No.FUN-D10055 13/01/11 By xianghui action的權限檢查應該檢查action：generate_st_in_qc_return的權限
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕 
# Modify.........: No:MOD-CA0124 13/02/01 By Elise 委外一般採購料不檢查超交,而是判斷完工誤差率,但委外代買料比照一般採購需檢查超交
# Modify.........: No:MOD-CB0079 13/02/01 By jt_chen 修正:因欄位變更後沒有離開欄位,直接按Action不會觸發AFTER FIELD;導致未檢核的資料異常
# Modify.........: No:MOD-CA0095 13/02/04 By Elise 增加判斷g_rvb[l_ac].rvb05不為null才進入s_icdbin()
# Modify.........: No:MOD-CA0161 13/02/04 By Elise 增加排除作廢單據rvaconf<>'X'與樣品rvb35='N'
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10128 13/02/26 By SunLM 若為農業發票(gec05='A')時,未稅單價邏輯調整
# Modify.........: No.TQC-D30011 13/03/07 By Elise 修改因FUN-C30248導致刪除rvb_file未刪除rvbi_file,無法重複寫入rvbi_file的問題
# Modify.........: No:MOD-C80019 13/03/07 By jt_chen 請改依畫面單身筆數更新
# Modify.........: No:MOD-D30079 13/03/08 By Elise 條件增加判斷新值不為空
# Modify.........: No.MOD-CC0096 13/03/12 By jt_chen 收貨單變更項次數量控卡調整,排除正在維護的項次,多單位數量需一併調整
# Modify.........: No:MOD-CB0099 13/03/12 By jt_chen aimi103採購收貨替代原則(ima150)因新增時資料庫預設值為空白,原本判斷不等於0會抓到空白的情況,改為判斷等於1或2
# Modify.........: No:MOD-D30148 13/03/18 By Vampire Page4需增加判斷收貨類別(g_argv6)決定顯示或隱藏
# Modify.........: No:CHI-C80019 13/03/25 By Vampire 在AFTER FIELD rvb36的地方增加判斷需檢驗料或參數未勾選【採購收貨免檢驗料件直接入庫】則不卡倉庫必輸
# Modify.........: No:CHI-C80072 13/03/27 By xumm 取消审核赋值审核异动日期和审核异动人员
# Modify.........: No:MOD-D20137 13/03/28 By Vampire 判斷當收貨單單身不需檢驗，則不控卡
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  4.調整確認自動產生barcode
#                  5.調整取消確認自動作廢barcode
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.MOD-D30263 13/04/02 By Vampire 調整驗退需納入考量,總已收量+本次實收量-驗退量 不可大於 最小發料套數
# Modify.........: No.DEV-D40013 13/04/12 By Nina 當料件使用條碼時不一定批序號會有資料
# Modify.........: No.MOD-D40093 13/04/15 By Vampire 清空舊值 l_rvu01，否則會帶錯入庫單資料。
# Modify.........: No.DEV-D40015 13/04/16 By Nina aimi100有勾選使用條碼&條碼產生時機='E'，確認前，
#                                                 將產生條碼段移至確認chk段前，並CALL s_ibb_ins_rvbs寫入rvbs_file
# Modify.........: No:TQC-D40025 13/04/21 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D60063 13/06/06 By suncx 修改因CHI-B60084改錯造成的委外收货作业代采买类型收货时，若物料启用参考单位，则提示换算率抓不到

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt110.global"
GLOBALS "../../axm/4gl/s_slk.global"   #No.FUN-B90101
  
DEFINE g_ima918     LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921     LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930     LIKE ima_file.ima930  #DEV-D30040 add
DEFINE l_r          LIKE type_file.chr1   #No.FUN-860045
DEFINE g_in         LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可入庫量
DEFINE g_in1        LIKE rvv_file.rvv82   #MOD-A70160
DEFINE g_in2        LIKE rvv_file.rvv85   #MOD-A70160
DEFINE g_out        LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可驗退量
DEFINE g_out1       LIKE rvv_file.rvv82   #MOD-A70160
DEFINE g_out2       LIKE rvv_file.rvv85   #MOD-A70160                        #TQC-B40081
DEFINE g_chr1       LIKE type_file.chr1   #TQC-9B0101
DEFINE g_pmc01      LIKE pmc_file.pmc01   #No:FUN-9C0046
DEFINE g_pmc03      LIKE pmc_file.pmc03   #No:FUN-9C0046
DEFINE g_rva1    RECORD LIKE rva_file.*  #No:FUN-9C0046
DEFINE g_wpe     DYNAMIC ARRAY OF RECORD #No:FUN-9C0046   ---begin
        sel         LIKE type_file.chr1,
        wpe01       LIKE wpe_file.wpe01,
        wpe04       LIKE wpe_file.wpe04,
        pmm04       LIKE pmm_file.pmm04,
        wpe02       LIKE wpe_file.wpe02,
        wpe05       LIKE wpe_file.wpe05,
        pmn04       LIKE pmn_file.pmn04,
        pmn041      LIKE pmn_file.pmn041,
        wpe06       LIKE wpe_file.wpe06
                 END RECORD              #No:FUN-9C0046   ---end
DEFINE  g_sel_from_procure   LIKE type_file.chr1  #FUN-B60127 ADD  #是否從採購單挑選 Y-是 N-否
#FUN-B90101--add--begin--
DEFINE g_rvbslk  DYNAMIC ARRAY OF RECORD
        rvbslk02    LIKE rvbslk_file.rvbslk02,
        rvbslk04    LIKE rvbslk_file.rvbslk04,  
        rvbslk03    LIKE rvbslk_file.rvbslk03,
        rvbslk05    LIKE rvbslk_file.rvbslk05,
        rvbslk051   LIKE rvbslk_file.rvbslk051,
        ima021a     LIKE ima_file.ima021,
        rvbslk07    LIKE rvbslk_file.rvbslk07,
        rvbslk10    LIKE rvbslk_file.rvbslk10,
        rvbslk10t   LIKE rvbslk_file.rvbslk10t,
        rvbslk29    LIKE rvbslk_file.rvbslk29,
        rvbslk30    LIKE rvbslk_file.rvbslk30,
        rvbslk36    LIKE rvbslk_file.rvbslk36,
        rvbslk37    LIKE rvbslk_file.rvbslk37,
        rvbslk38    LIKE rvbslk_file.rvbslk38,
        rvbslk88    LIKE rvbslk_file.rvbslk88,
        rvbslk88t   LIKE rvbslk_file.rvbslk88t,
        rvbslk930   LIKE rvbslk_file.rvbslk930,
        gem02       LIKE gem_file.gem02,
        rvbslk90    LIKE rvbslk_file.rvbslk90,
        rvbslk42    LIKE rvbslk_file.rvbslk42,
        rvbslk43    LIKE rvbslk_file.rvbslk43
                 END RECORD,
      g_rvbslk_t RECORD
        rvbslk02    LIKE rvbslk_file.rvbslk02,
        rvbslk04    LIKE rvbslk_file.rvbslk04,
        rvbslk03    LIKE rvbslk_file.rvbslk03,
        rvbslk05    LIKE rvbslk_file.rvbslk05,
        rvbslk051   LIKE rvbslk_file.rvbslk051,
        ima021a     LIKE ima_file.ima021,
        rvbslk07    LIKE rvbslk_file.rvbslk07,
        rvbslk10    LIKE rvbslk_file.rvbslk10,
        rvbslk10t   LIKE rvbslk_file.rvbslk10t,
        rvbslk29    LIKE rvbslk_file.rvbslk29,
        rvbslk30    LIKE rvbslk_file.rvbslk30,
        rvbslk36    LIKE rvbslk_file.rvbslk36,
        rvbslk37    LIKE rvbslk_file.rvbslk37,
        rvbslk38    LIKE rvbslk_file.rvbslk38,
        rvbslk88    LIKE rvbslk_file.rvbslk88,
        rvbslk88t   LIKE rvbslk_file.rvbslk88t,
        rvbslk930   LIKE rvbslk_file.rvbslk930,
        gem02       LIKE gem_file.gem02,
        rvbslk90    LIKE rvbslk_file.rvbslk90,
        rvbslk42    LIKE rvbslk_file.rvbslk42,
        rvbslk43    LIKE rvbslk_file.rvbslk43
                 END RECORD
DEFINE g_rvbslk2 RECORD LIKE rvbslk_file.*,       
       g_rvbi    RECORD LIKE rvbi_file.*
DEFINE g_wc3     STRING,
       g_rec_b2     LIKE type_file.num5,
       l_ac2        LIKE type_file.num5,
       l_ac2_t       LIKE type_file.num5, 
       g_rec_b3     LIKE type_file.num5,
       l_ac3        LIKE type_file.num5,
       p_cmd3       LIKE type_file.chr1,
       g_rvb44      LIKE rvb_file.rvb44,
       g_rvb45      LIKE rvb_file.rvb45,
       g_pmm43      LIKE pmm_file.pmm43,
       g_rvbslk05_t LIKE rvbslk_file.rvbslk05,
       g_rvu01      LIKE rvu_file.rvu01, 
       g_rvu00      LIKE rvu_file.rvu00
#FUN-B90101--add--end--
#FUN-CB0014---add---str---
DEFINE g_rva_l DYNAMIC ARRAY OF RECORD
               rva01         LIKE rva_file.rva01,
               rva06         LIKE rva_file.rva06,
               rva02         LIKE rva_file.rva02,
               rva05         LIKE rva_file.rva05,
               pmc03         LIKE pmc_file.pmc03,
               rva04         LIKE rva_file.rva04,
               rva21         LIKE rva_file.rva21,
               rva08         LIKE rva_file.rva08,
               rva09         LIKE rva_file.rva09,
               rva10         LIKE rva_file.rva10,
               rvaconf       LIKE rva_file.rvaconf,
               rvacond       LIKE rva_file.rvacond,
               rvaconu       LIKE rva_file.rvaconu,
               rvaconu_desc  LIKE gen_file.gen02,
               rva29         LIKE rva_file.rva29,
               rva33         LIKE rva_file.rva33,
               gen02         LIKE gen_file.gen02,
               rvamksg       LIKE rva_file.rvamksg,
               rva32         LIKE rva_file.rva32
               END RECORD,
        l_ac4    LIKE type_file.num5,
        g_rec_b4 LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#FUN-CB0014---add---end---
DEFINE g_upnull    LIKE type_file.chr1         #MOD-BB0141 add
DEFINE g_flag2     LIKE type_file.chr1         #FUN-C30248 add   #判斷依實收量自動帶出代買採購單資料及數量
DEFINE g_pmn41     LIKE pmn_file.pmn41         #FUN-C30248 add
DEFINE g_rvb07     LIKE rvb_file.rvb07         #FUN-C30248 add
DEFINE g_rvb04     LIKE rvb_file.rvb04         #FUN-C30248 add
DEFINE   g_b_flag       LIKE type_file.chr1    #TQC-D40025

FUNCTION t110(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6) #No.FUN-630010 #FUN-840012 #No.FUN-940083
   DEFINE p_argv1    LIKE rva_file.rva01,     #收貨單號
          p_argv2    LIKE rva_file.rva10,     #採購類別
          p_argv3    LIKE rva_file.rva04,     #L/C收貨
          p_argv4    STRING,                  #No.FUN-630010 執行功能
          p_argv5    LIKE type_file.chr1,     #FUN-840012  1:執行確認
          p_argv6    LIKE rva_file.rva00      #FUN-940083  #收貨類別
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_argv1=p_argv1
   LET g_argv2=p_argv2
   LET g_argv3=p_argv3
   LET g_argv4=p_argv4     #No.FUN-630010
   LET g_argv5=p_argv5     #FUN-840012
   LET g_argv6=p_argv6     #FUN-940083

  #FUN-9C0076 str ---
   IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)       #取得單號
   END IF
  #FUN-9C0076 end ---   
 
   LET g_sel_from_procure = 'N'  #FUN-B60127 ADD

   LET g_forupd_sql = "SELECT * FROM rva_file WHERE rva01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B40028
   IF (NOT cl_null(g_argv5)) AND (g_argv5='1') THEN  #FUN-840012 1:執行自動確認
      CALL t110_q()
     #CALL t110_y()                              #FUN-9C0076 mark

     #FUN-9C0076 add str ---
      #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6)     #CALL 原確認的 check 段 #FUN-A10130
      CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6) #CHI-C30118 add
      IF g_success = "Y" THEN
        CALL t110sub_y_upd(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)    #CALL 原確認的 update 段#FUN-A10130
        CALL t110_refresh() RETURNING g_rva.*
        CALL t110_show()
      END IF
     #FUN-9C0076 add end ---
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
      EXIT PROGRAM
   ELSE
      IF (NOT cl_null(g_argv5)) AND (g_argv5='V') THEN
         CALL t110_q()
         CALL t110_z()
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40085
         EXIT PROGRAM
      ELSE
         IF g_bgjob='N' OR cl_null(g_bgjob) THEN     #FUN-9C0076 add
           LET p_row = 3 LET p_col = 8
           CASE
              WHEN  g_argv2 = 'SUB'
                 OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                   WITH FORM "apm/42f/apmt200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
              WHEN g_argv2 = 'TAP'
                 OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                   WITH FORM "apm/42f/apmt300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
              OTHERWISE
#FUN-B90101--add--begin--
                 IF g_azw.azw04='2' THEN             #TQC-C20117--add
                    OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                       WITH FORM "apm/42f/apmt110_slk"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
                 #TQC-C20117--add-------begin----
                 ELSE
                    OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                      WITH FORM "apm/42f/apmt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                 END IF
                 #TQC-C20117--add------end-------
#No.FUN-B90101 add &endif
           END CASE 
         END IF                                     #FUN-9C0076 add
      END IF                                        #FUN-940083 add
   END IF

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN          #FUN-9C0076 add
     IF g_azw.azw04= '2' THEN             
        CALL cl_set_comp_visible("rvacont,rvacond,rvaconu,rvaconu_desc,rva29,rva30,rva30_desc",TRUE)  #FUN-A30063 ADD rvacont
        CALL cl_set_comp_visible("rva31,rva31_desc,rvaplant,rvaplant_desc,rvacrat",TRUE)
        CALL cl_set_comp_visible("rvb42,rvb43,rvb44,rvb45",TRUE) 
        CALL cl_set_comp_visible("rvb930,gem02a",FALSE)
     ELSE
        CALL cl_set_comp_visible("rvacont,rvacond,rvaconu,rvaconu_desc,rva29,rva30,rva30_desc",FALSE)  #FUN-A30063 ADD rvacont
        CALL cl_set_comp_visible("rva31,rva31_desc,rvaplant,rvaplant_desc,rvacrat",FALSE)
        CALL cl_set_comp_visible("rvb42,rvb43,rvb44,rvb45",FALSE)
     END IF
     
     CALL cl_set_comp_visible("rvbiicd11",FALSE)  #FUN-C30300

     IF g_argv2 != 'TAP' THEN
        CALL cl_set_comp_visible("rva99",FALSE)
     END IF
 
     IF g_argv6 ='2' THEN
        CALL cl_set_comp_visible("rva02,rva02_l",FALSE)
        CALL cl_set_comp_visible("rvb03,rvb04,rvb05a,rvb05b,rvb05c,                                  pmn20,pmn50_55,pmm21,pmm43",FALSE)
#FUN-B90101--add--begin--
        IF g_azw.azw04='2' THEN             #TQC-C20117--add
           CALL cl_set_comp_visible("rvbslk10",TRUE) 
        END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
     ELSE
        CALL cl_set_comp_visible("Page4",FALSE)
        CALL cl_set_comp_visible("rvb10,rvb10t",FALSE)
#FUN-B90101--add--begin--
        IF g_azw.azw04='2' THEN             #TQC-C20117--add
           CALL cl_set_comp_visible("rvbslk10",FALSE)
        END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
     END IF

#FUN-B90101--add--begin--
     IF g_azw.azw04='2' THEN             #TQC-C20117--add
        IF g_argv6 ='3' THEN
           CALL cl_set_comp_visible("rvbslk10t",TRUE) 
        ELSE
           CALL cl_set_comp_visible("rvbslk10t",FALSE)
        END IF
     END IF                              #TQC-C20117--add
#FUN-B90101--add--end--

     CALL cl_set_comp_visible("rva31,rva31_desc",FALSE) #bnl
 
     CALL cl_ui_init()
     CALL cl_set_comp_visible("rvb919",g_sma.sma1421='Y')    #FUN-A80150 add
#FUN-C60088---ADD----STR----
     IF g_azw.azw04='2' THEN
        CALL cl_set_act_visible("controlb,generate_st_in_qc_return",FALSE)
     ELSE
        CALL cl_set_act_visible("controlb,generate_st_in_qc_return",TRUE)
     END IF
#FUN-C60088---ADD----END-----
      #CHI-A40068 add --start--
      CASE
         WHEN g_argv2 = 'SUB'  #apmt200
         WHEN g_argv2 = 'TAP'  #apmt300
            CASE g_sma.sma124
               WHEN 'std'
                  CALL cl_reset_qry_btn("rva02,rvb04","apmt540,apmt540")
               WHEN 'icd' 
      		  CALL cl_reset_qry_btn("rva02,rvb04","apmt540_icd,apmt540_icd")
               WHEN 'slk'
                  CALL cl_reset_qry_btn("rva02,rvb04","apmt540_slk,apmt540_slk")
            END CASE
         WHEN g_argv2 = 'ICD'  #aict041
         OTHERWISE             #apmt110
            CASE g_sma.sma124
               WHEN 'std'
                  CALL cl_reset_qry_btn("rva02,rvb04","apmt540,apmt540")
               WHEN 'icd' 
                  CALL cl_reset_qry_btn("rva02,rvb04","apmt540_icd,apmt540_icd")
               WHEN 'slk'
                  CALL cl_reset_qry_btn("rva02,rvb04","apmt540_slk,apmt540_slk")
            END CASE
      END CASE
      #CHI-A40068 add --end--

     IF g_aza.aza71 MATCHES '[Yy]' THEN
        CALL aws_gpmcli_toolbar()
        CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
     ELSE
        CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
     END IF
     IF g_sma.sma90 = 'Y' THEN
        CALL cl_set_act_visible("qry_lot,modi_lot", TRUE)   #FUN-C80030 add "modi_lot"
        CALL cl_set_comp_visible("Page2", TRUE)             #FUN-C80030 add
     ELSE
        CALL cl_set_act_visible("qry_lot,modi_lot", FALSE)  #FUN-C80030 add "modi_lot"
        CALL cl_set_comp_visible("Page2", FALSE)            #FUN-C80030 add
     END IF

     #FUN-BC0104-add-str--
     SELECT qcz14 INTO g_qcz.qcz14 FROM qcz_file
   # CALL cl_set_act_visible("qc_item_tran_store",g_qcz.qcz14)    #FUN-C20047 mark
     #FUN-CC0011 mark begin---
     ##FUN-C20047-add-str-
     #IF g_qcz.qcz14 = 'Y' THEN 
     #   CALL cl_set_act_visible("qc_item_tran_store",TRUE)
     #ELSE 
     #   CALL cl_set_act_visible("qc_item_tran_store",FALSE)
     #END IF
     ##FUN-C20047-add-end-
     #FUN-CC0011 mark end------
     #FUN-BC0104-add-end--

# FUN-B80093 add START
     IF g_sma.sma93="Y" THEN
        CALL cl_set_comp_visible("rva117", TRUE)
        CALL cl_set_comp_visible("rvb89", TRUE)
     ELSE
        CALL cl_set_comp_visible("rva117", FALSE)
        CALL cl_set_comp_visible("rvb89", FALSE)
     END IF
# FUN-B80093 add END

#FUN-A90022 --add
     IF g_aza.aza95 = 'N' THEN
        CALL cl_set_act_visible("e_proc_require",FALSE)
     END IF
#FUN-A90022 --end
     #FUN-9C0076 add str ---
     #ICD不開放EasyFlow相關欄位與ACTION

#FUN-B90101--add--begin--
#FUN-C60100---ADD &IFDEF
     CALL cl_set_act_visible("controlb",FALSE)
#FUN-C60100---ADD &ENDIF
#FUN-B90101--add--end--
     #FUN-9C0076 add end ---
     CALL cl_set_comp_entry("rvb86",FALSE)       #No.TQC-740313
     CALL cl_set_act_visible("add_invoice",g_aza.aza26<>'2')   #TQC-C40005
   END IF                                        #FUN-9C0076 add

   #DEV-D30045--add--begin
   IF g_prog <> 'apmt110' OR g_aza.aza131 = 'N' THEN
      CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
   END IF
   #DEV-D30045--add--end

   CALL t110_mu_ui()
   CALL cl_set_comp_visible("rvb930,gem02a",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("rva34",g_aza.aza88 = 'Y')                           #No.FUN-A50071

  #初始化界面的樣式(沒有任何默認屬性組)
   LET lg_smy62 = ''
   LET lg_group = ''
   CALL t110_refresh_detail()
 
   CALL aws_efapp_toolbar()    #建立簽核模式時的 toolbar icon  #FUN-9C0076 add

   IF NOT cl_null(g_argv1) THEN
      CASE g_argv4
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t110_a()
            END IF
        #FUN-9C0076 add str ---
         WHEN "efconfirm"
            LET g_action_choice = "efconfirm"
            CALL t110_q()
            #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6)    #CALL 原確認的 check 段 #FUN-740034 #FUN-A10130 #CHI-C30118 mark
            CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6) #CHI-C30118 add
            IF g_success = "Y" THEN
               CALL t110sub_y_upd(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)   #CALL 原確認的 update 段#FUN-A10130
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40085
            EXIT PROGRAM
        #FUN-9C0076 add end ---
         OTHERWISE
            CALL t110_q()
      END CASE
   END IF
 
  #FUN-9C0076 add str ---
  #傳入簽核模式時不應執行的 action 清單
#FUN-A50030 mod str ----
   #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc")#FUN-D20025 mark
   #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc")#FUN-D20025 add ##DEV-D30045 mark
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc,barcode_gen,barcode_query,barcode_output")##DEV-D30045 add
#FUN-A50030 mod end ----
         RETURNING g_laststage
  #FUN-9C0076 add end ---

   CALL t110_menu()
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      Call cl_set_act_visible("trans_spc",TRUE)
      CALL cl_set_comp_visible("rvaspc",TRUE)
   END IF
 
   CLOSE WINDOW t110_w                 #結束畫面
 
END FUNCTION
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   #No.FUN-580031  HCN
DEFINE  l_pmm04         LIKE    pmm_file.pmm04   #No.MOD-4B0275
DEFINE  l_rva10         LIKE    rva_file.rva10   #CHI-A80037 add
 
   CLEAR FORM                             #清除畫面
   CALL g_rvb.clear()
 
#No.FUN-B90101--add--
   IF g_azw.azw04='2' THEN             #TQC-C20117--add
      CALL g_rvbslk.clear()
      CALL g_imx.clear()
   END IF                              #TQC-C20117--add
#No.FUN-B90101--end--

   IF cl_null(g_argv1) THEN
      INITIALIZE g_rva.* TO NULL      #No.FUN-750051
#TQC-AB0376 --------------------------Begin--------------------------------
#      CONSTRUCT BY NAME g_wc ON
#         rva01,rva06,rva02,rva05,rva99,rva04,rva21,rva08,
#         rva09,rva34,rva10,rvaconf,rvaspc,rva117,  #FUN-A50071add rva34 #FUN-680011  #No.FUN-940083    
#         rva111,rva112,rva115,rva116,rva113,rva114,          #No.FUN-940083
#         rvauser,rvagrup,rvamodu,rvadate,rvaacti,rvacrat,    #NO.FUN-960130--add rvacrat
#         rvaoriu.rvaorig,rvacont,                            #TQC-A30041 ADD  #FUN-A30063 ADD CONT
#         rvacond,rvaconu,rva29,rva30,rva31,rvaplant          #NO.FUN-960130---add----
#        ,rva33,rvamksg,rva32                                 #FUN-9C0076 add
#        ,rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,
#         rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,
#         rvaud11,rvaud12,rvaud13,rvaud14,rvaud15
       DIALOG ATTRIBUTES(UNBUFFERED)         #No.FUN-B90101 add       
       CONSTRUCT BY NAME g_wc ON
          rva01,rva06,rva02,rva05,rva99,rva04,rva21,rva08,
          rva09,rva34,rva10,rvaconf,rvacond,rvacont,rvaconu,rvaspc,
          rva117,rva29,rva30,rva31,rvaplant,rva33,rvamksg,rva32,
          rva111,rva112,rva115,rva116,rva113,rva114, 
          rvauser,rvagrup,rvaoriu,rvaorig,rvamodu,rvadate,
          rvaacti,rvacrat,
          rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,
          rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,
          rvaud11,rvaud12,rvaud13,rvaud14,rvaud15 
          
#TQC-AB0376 --------------------------End-----------------------------------
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
       #CHI-A80037 add --start--
       AFTER CONSTRUCT
           CALL GET_FLDBUF(rva10) RETURNING l_rva10
       #CHI-A80037 add --end--
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rva01) #查詢收貨單號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                CASE
                   WHEN g_argv2 = 'SUB'   LET g_qryparam.form = "q_rva05"
                   WHEN g_argv2 = 'TAP'   LET g_qryparam.form = "q_rva07"
                   OTHERWISE              LET g_qryparam.form = "q_rva06"
                END CASE
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva01
                NEXT FIELD rva01
             WHEN INFIELD(rva02) #查詢採購單號
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
#               LET g_qryparam.form ="q_pmm6"        #TQC-C70103 mark
                LET g_qryparam.form ="q_pmm6_1"      #TQC-C70103 add
                #MOD-C40188 add start -----
                IF NOT cl_null(g_argv2) THEN
                   LET g_qryparam.where = "pmm02 ='",g_argv2,"' "
                      LET g_qryparam.where = " pmm02 ='",g_argv2,"'"
                ELSE
                    LET g_qryparam.where = "pmm02 <> 'TAP' AND pmm02 <> 'TRI' AND pmm02 <> 'SUB'"
                END IF
                #MOD-C40188 add start -----
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva02
                NEXT FIELD rva02
             WHEN INFIELD(rva05) #查詢廠商
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
                LET g_qryparam.form ="q_pmc1"
                LET g_qryparam.default1 = g_rva.rva05
                CALL cl_create_qry() RETURNING g_rva.rva05
                DISPLAY BY NAME g_rva.rva05
                CALL t110_rva05('d')           #FUN-B40083 
                NEXT FIELD rva05
              WHEN INFIELD(rvaconu)                                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rvaconu"                                                                                  
                LET g_qryparam.default1 = g_rva.rvaconu                                                                             
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rvaconu                                                                              
                NEXT FIELD rvaconu  
             WHEN INFIELD(rva31)
                CALL cl_init_qry_var()    
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_rva31"
                LET g_qryparam.default1 = g_rva.rva31
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva31
                NEXT FIELD rva31        
             WHEN INFIELD(rvaplant)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rva930"                                                                                   
                LET g_qryparam.default1 = g_rva.rvaplant                                                                              
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rvaplant                                                                               
                NEXT FIELD rvaplant
             WHEN INFIELD(rva111)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rva111"                                                                                   
                LET g_qryparam.default1 = g_rva.rva111                                                                              
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rva111                                                                               
                NEXT FIELD rva111
             WHEN INFIELD(rva112)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rva112"                                                                                   
                LET g_qryparam.default1 = g_rva.rva112                                                                              
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rva112                                                                               
                NEXT FIELD rva112
             WHEN INFIELD(rva113)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rva113"                                                                                   
                LET g_qryparam.default1 = g_rva.rva113                                                                              
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rva113                                                                               
                NEXT FIELD rva113 
             WHEN INFIELD(rva115)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.state = "c"                                                                                          
                LET g_qryparam.form  = "q_rva115"                                                                                   
                LET g_qryparam.default1 = g_rva.rva115                                                                              
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                  
                DISPLAY g_qryparam.multiret TO rva115                                                                               
                NEXT FIELD rva115                                               
            #FUN-9C0076 add str ----
             WHEN INFIELD(rva33) #申請人員
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva33
                NEXT FIELD rva33
            #FUN-9C0076 add end ----              
            #TQC-BB0195 add str ----
             WHEN INFIELD(rva117) #VMI发料单号
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rva117"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva117
                NEXT FIELD rva117
            #TQC-BB0195 add end ----
            END CASE
      END CONSTRUCT     #FUN-B90101 add
#FUN-B90101--mark--begin-- 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#                ON ACTION qbe_select
#                  CALL cl_qbe_list() RETURNING lc_qbe_sn
#                  CALL cl_qbe_display_condition(lc_qbe_sn)
#     END CONSTRUCT
#
#     IF INT_FLAG THEN
#        RETURN
#     END IF
#
#     LET g_wc = g_wc CLIPPED," AND rva00 = '",g_argv6 CLIPPED,"'"
#  ELSE
#     LET g_wc= " rva00 = '",g_argv6 CLIPPED,"' AND rva01= '",g_argv1 CLIPPED,"'"
#     LET g_wc2 = ' 1=1'
#  END IF
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
#
#  CASE WHEN g_argv2='SUB'         #委外
#            LET g_wc = g_wc clipped," AND rva10 = 'SUB' "
#       WHEN g_argv2='TAP'         #三角代採買
#            LET g_wc = g_wc clipped," AND (rva10 = 'TAP' OR rva10='TRI') " #No.7882
#&ifdef ICD
#       WHEN g_argv2='ICD'         #Wafer採購
#            LET g_wc = g_wc clipped," AND (rva10 LIKE 'WB%') "
#&endif
#       OTHERWISE
#            LET g_wc = g_wc clipped," AND rva10 != 'SUB' AND rva10 !='TAP' ",
#                                    " AND rva10 != 'TRI' "
#&ifdef ICD
#               LET g_wc = g_wc clipped," AND (NOT rva10 LIKE 'WB%')"
#&endif
#  END CASE
#  CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
#FUN-B90101--mark--end--
#FUN-B90101-add-begin-- 
       CONSTRUCT g_wc3 ON rvbslk02,rvbslk04,rvbslk03,rvbslk05,rvbslk051,rvbslk07,rvbslk10,rvbslk10t,
                          rvbslk29,rvbslk30,rvbslk36,rvbslk37,rvbslk38,rvbslk88,rvbslk88t,rvbslk930,
                          rvbslk90,rvbslk42,rvbslk43
        FROM s_rvbslk[1].rvbslk02,s_rvbslk[1].rvbslk04,s_rvbslk[1].rvbslk03,s_rvbslk[1].rvbslk05,
             s_rvbslk[1].rvbslk051,s_rvbslk[1].rvbslk07,s_rvbslk[1].rvbslk10,s_rvbslk[1].rvbslk10t,
             s_rvbslk[1].rvbslk29,s_rvbslk[1].rvbslk30,s_rvbslk[1].rvbslk36,s_rvbslk[1].rvbslk37,
             s_rvbslk[1].rvbslk38,s_rvbslk[1].rvbslk88,s_rvbslk[1].rvbslk88t,s_rvbslk[1].rvbslk930,
             s_rvbslk[1].rvbslk90,s_rvbslk[1].rvbslk42,s_rvbslk[1].rvbslk43
           BEFORE CONSTRUCT
              CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
             CASE WHEN INFIELD(rvbslk04)    
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmm17"
                     LET g_qryparam.arg1 = ""
                     IF NOT cl_null(l_rva10) THEN
                        LET g_qryparam.arg1 = " AND pmm02 = '",l_rva10 ,"'"
                     END IF
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvbslk04
                     NEXT FIELD rvbslk04 
                  WHEN INFIELD(rvbslk05)    
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')
                     RETURNING  g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvbslk05
                     NEXT FIELD rvbslk05
                  WHEN INFIELD(rvbslk36)  #MOD-480604查詢倉庫
                     CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvbslk36
                     NEXT FIELD rvbslk36
                  WHEN INFIELD(rvbslk930)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gem4"
                     LET g_qryparam.state = "c"   #多選
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvbslk930
                     NEXT FIELD rvbslk930
             END CASE
       END CONSTRUCT
#FUN-B90101-add-end-- 
 # IF cl_null(g_argv1) THEN   #FUN-B90101 add
       CONSTRUCT g_wc2 ON rvb02,rvb22,rvb04,rvb03,rvb34,
                          rvb05,rvb919,             #FUN-A80150 add rvb919
                          rvb42,rvb43,rvb44,rvb45,    #NO.FUN-960130--add---
                          rvb30,rvb29,
                          rvb89,                     #No.FUN-940083
                          rvb35,
                          rvb07,rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,
                          rvb86,rvb87,rvb10,rvb10t,rvb36,rvb37,rvb38,rvb25,  #No.FUN-550117
                          rvb930,rvb93   #FUN-670051    #No.FUN-9C0046 ----  ADD rvb93
                         ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,
                         rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,
                         rvbud11,rvbud12,rvbud13,rvbud14,rvbud15
        FROM s_rvb[1].rvb02,s_rvb[1].rvb22,s_rvb[1].rvb04,s_rvb[1].rvb03,
             s_rvb[1].rvb34,
             s_rvb[1].rvb05,s_rvb[1].rvb919,         #FUN-A80150 add rvb919
             s_rvb[1].rvb42,s_rvb[1].rvb43,s_rvb[1].rvb44,s_rvb[1].rvb45,    #NO.FUN-960130--add---
             s_rvb[1].rvb30,s_rvb[1].rvb29,
             s_rvb[1].rvb89,                         #FUN-940083
             s_rvb[1].rvb35,
             s_rvb[1].rvb07,s_rvb[1].rvb83,s_rvb[1].rvb84,
             s_rvb[1].rvb85,s_rvb[1].rvb80,s_rvb[1].rvb81,s_rvb[1].rvb82,
             s_rvb[1].rvb86,s_rvb[1].rvb87,s_rvb[1].rvb10,s_rvb[1].rvb10t,   #No.FUN-550117
             s_rvb[1].rvb36,s_rvb[1].rvb37,s_rvb[1].rvb38,s_rvb[1].rvb25,    #No.FUN-550117
             s_rvb[1].rvb930,s_rvb[1].rvb93   #FUN-670051    #NO.FUN-9C0046  ---ADD rvb93---
             ,s_rvb[1].rvbud01,s_rvb[1].rvbud02,s_rvb[1].rvbud03,s_rvb[1].rvbud04,s_rvb[1].rvbud05,
             s_rvb[1].rvbud06,s_rvb[1].rvbud07,s_rvb[1].rvbud08,s_rvb[1].rvbud09,s_rvb[1].rvbud10,
             s_rvb[1].rvbud11,s_rvb[1].rvbud12,s_rvb[1].rvbud13,s_rvb[1].rvbud14,s_rvb[1].rvbud15
 
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
             CASE  WHEN INFIELD(rvb04)    #
                     CALL cl_init_qry_var()
#CHI-A80037 mark --start--
#                     CASE
#                        WHEN g_argv2 = 'SUB'   LET g_qryparam.form = "q_pmm9"
#                        WHEN g_argv2 = 'TAP'   LET g_qryparam.form = "q_pmm10"
#&ifdef ICD
#                        WHEN g_argv2 = 'ICD'   LET g_qryparam.form = "q_pmm11_icd"
#&endif
#                        OTHERWISE              LET g_qryparam.form = "q_pmm11"
#                     END CASE
#CHI-A80037 mark --end--
                     #CHI-A80037 add --start--
                     LET g_qryparam.form = "q_pmm17"
                     LET g_qryparam.arg1 = "" 
                     IF NOT cl_null(l_rva10) THEN
                        LET g_qryparam.arg1 = " AND pmm02 = '",l_rva10 ,"'"
                     END IF
                     #CHI-A80037 add --end--
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb04
                     NEXT FIELD rvb04
                   WHEN INFIELD(rvb05)    #
#FUN-AA0059---------mod------------str-----------------                   
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_ima"
#                     LET g_qryparam.state = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret

                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  
                     RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO rvb05
                     NEXT FIELD rvb36
                    WHEN INFIELD(rvb36)  #MOD-480604查詢倉庫
                     #No.FUN-AA0049--begin
                     #CALL cl_init_qry_var()
                     #LET g_qryparam.form = "q_imd"
                     #LET g_qryparam.state = "c"
                     #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                     #No.FUN-AA0049--end
                     DISPLAY g_qryparam.multiret TO rvb36
                     NEXT FIELD rvb36
                   WHEN INFIELD(rvb25)
                     SELECT pmm04 INTO l_pmm04 FROM pmm_file
                      WHERE pmm01 = g_rvb[1].rvb04
                     CALL q_coc2(TRUE,TRUE,g_rvb[1].rvb25,'',l_pmm04,'1',
                                 '',g_rvb[1].rvb05)
                     RETURNING g_rvb[1].rvb25
                      DISPLAY BY NAME g_rvb[1].rvb25                #No.MOD-490371
                     NEXT FIELD rvb25
                #No.FUN-540027  --begin
                WHEN INFIELD(rvb83)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb83
                     NEXT FIELD rvb83
 
                WHEN INFIELD(rvb80)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb80
                     NEXT FIELD rvb80
 
                WHEN INFIELD(rvb86)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb86
                     NEXT FIELD rvb86
                WHEN INFIELD(rvb930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvb930
                   NEXT FIELD rvb930
             END CASE
      END CONSTRUCT   #FUN-B90101 add
#FUN-B90101--mark--begin--
#       ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#                   ON ACTION qbe_save
#                      CALL cl_qbe_save()
#     END CONSTRUCT
#       
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        RETURN
#     END IF
#  END IF 
#FUN-B90101--mark--end--
#FUN-B90101--add--begin--

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
      END DIALOG
      IF INT_FLAG THEN
       # LET INT_FLAG = 0   #FUN-C20006
         RETURN
      END IF    
      LET g_wc = g_wc CLIPPED," AND rva00 = '",g_argv6 CLIPPED,"'"
   ELSE
      LET g_wc= " rva00 = '",g_argv6 CLIPPED,"' AND rva01= '",g_argv1 CLIPPED,"'"
      LET g_wc2 = ' 1=1'
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')

   CASE WHEN g_argv2='SUB'         #委外
             LET g_wc = g_wc clipped," AND rva10 = 'SUB' "
        WHEN g_argv2='TAP'         #三角代採買
             LET g_wc = g_wc clipped," AND (rva10 = 'TAP' OR rva10='TRI') " #No.7882
        OTHERWISE
             LET g_wc = g_wc clipped," AND rva10 != 'SUB' AND rva10 !='TAP' ",
                                     " AND rva10 != 'TRI' "
   END CASE
   CALL cl_set_head_visible("","YES")


#FUN-B90101--add--begin--
   IF cl_null(g_wc) THEN
      LET g_wc = ' 1=1'
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2 = ' 1=1'
   END IF 
   IF g_azw.azw04='2' THEN             #TQC-C20117--add
      IF cl_null(g_wc3) THEN
         LET g_wc3 = ' 1=1'
      END IF
   END IF                              #TQC-C20117--add
#FUN-B90101--add--end--

   IF g_wc2 = ' 1=1' THEN            # 若單身未輸入條件
      LET g_sql = "SELECT  rva01 FROM rva_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1" 
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT  rva01 FROM rva_file ",
                     " WHERE ", g_wc CLIPPED,
#                     " AND rvaplant IN ",g_auth,        #TQC-B40213 
                     " ORDER BY 1"                   #FUN-9A0068
      END IF
#FUN-B90101--add--begin--
   IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add
      IF g_wc3 != ' 1=1' THEN          # 若母單身未輸入條件
         LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                     "  FROM rva_file, rvbslk_file ",
                     " WHERE rva01 = rvbslk01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                     " ORDER BY 1"
      END IF
   END IF                                                       #TQC-C20117--add
#FUN-B90101--add--end--
   ELSE                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                  "  FROM rva_file, rvb_file ",
                  " WHERE rva01 = rvb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"                      #FUN-9A0068 
        IF g_wc2.getindexof('rvbi',1)>0 THEN
           LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                       "  FROM rva_file, rvb_file,rvbi_file ",
                       " WHERE rva01 = rvb01",
                       "   AND rvb01 = rvbi01 ",
                       "   AND rvb02 = rvbi02 ",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                       " ORDER BY 1"                 #FUN-9A0068
        END IF
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT UNIQUE rva_file.rva01 ", 
                     "  FROM rva_file, rvb_file ", 
                     " WHERE rva01 = rvb01",
#                     " AND rvaplant IN ",g_auth,            #TQC-B40213 
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY 1"                  #FUN-9A0068
      END IF
#FUN-B90101--add--begin--
     IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add
        IF g_wc3 != ' 1=1' THEN          # 若母單身未輸入條件
           LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                       "  FROM rva_file, rvb_file,rvbi_file,rvbslk_file ",
                       " WHERE rva01 = rvbslk01",
                       "   AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND rvbslk01 = rvbi01 ",
                       "   AND rvbslk02 = rvbislk02 ",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED,
                       " ORDER BY 1"
        END IF
     END IF                                                       #TQC-C20117--add
#FUN-B90101--add--end--
   END IF
 
 
   PREPARE t110_prepare FROM g_sql
   DECLARE t110_cs                         #SCROLL CURSOR
    SCROLL CURSOR WITH HOLD FOR t110_prepare
   DECLARE t110_fill_cs CURSOR FOR t110_prepare   #FUN-CB0014 add
 
   IF g_wc2 = ' 1=1' THEN            # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM rva_file WHERE ",g_wc CLIPPED
      IF g_azw.azw04='2' THEN
         LET g_sql="SELECT COUNT(*) FROM rva_file WHERE ",g_wc CLIPPED  #," AND rvaplant IN ",g_auth   #TQC-B40213
      END IF
#FUN-B90101--add--begin--
      IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add
         IF g_wc3 != ' 1=1' THEN   
            LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvbslk_file WHERE ",
                      "rvbslk01=rva01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
         END IF
      END IF                                                       #TQC-C20117--add
#FUN-B90101--add--end--
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvb_file WHERE ",
                "rvb01=rva01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         IF g_wc2.getindexof('rvbi',1)>0 THEN
            LET g_sql="SELECT COUNT(DISTINCT rva01) FROM ",
                      " rva_file,rvb_file,rvbi_file WHERE ",
                      "rvb01=rva01 AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND  ",g_wc CLIPPED," AND ",g_wc2 CLIPPED     #TQC-970351  
         END IF     
      IF g_azw.azw04='2' THEN
         LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvb_file WHERE ",
                   "rvb01=rva01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED   #,   #TQC-B40213
#                   " AND rvaplant IN ",g_auth                                  #TQC-B40213 
      END IF 
#FUN-B90101--add--begin--
      IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add
         IF g_wc3 != ' 1=1' THEN         
            LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvb_file,rvbi_file,rvbslk_file WHERE ",
                      "rvbslk01=rva01 AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND rvbslk01 = rvbi01 ",
                      " AND rvbslk02 = rvbislk02 ",
                      " AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED
         END IF
      END IF                                                       #TQC-C20117--add
#FUN-B90101--add--end--
   END IF
   PREPARE t110_precount FROM g_sql
   DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
FUNCTION t110_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10     #GPM傳回值
   DEFINE g_img09      LIKE img_file.img09      #FUN-850120
   DEFINE l_i          LIKE type_file.num5,
          l_fac        LIKE ima_file.ima31_fac
   DEFINE l_creator    LIKE type_file.chr1      #「不准」時是否退回填表人  #FUN-9C0076 add
   DEFINE l_flowuser   LIKE type_file.chr1      # 是否有指定加簽人員       #FUN-9C0076 add 
   DEFINE l_msg        STRING                   #FUN-A80112 add 
   DEFINE l_cnt        LIKE type_file.num5  #MOD-B40006 add
   DEFINE l_rvu01      LIKE rvu_file.rvu01      #TQC-C90128 add

   LET l_flowuser = "N"                         #FUN-9C0076 add

   WHILE TRUE
     IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
#TQC-C20117----modify---------begin--------------
     IF g_azw.azw04='2' THEN
        CALL t110_bp_slk("G")
     ELSE
        CALL t110_bp("G")
     END IF
#TQC-C20117----modify-------end-------------------
  #FUN-CB0014---add---str---
  ELSE                           
         CALL t110_list_fill()
         CALL t110_bp2("G")           
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT rva_file.* INTO g_rva.*
              FROM rva_file
             WHERE rva01=g_rva_l[l_ac4].rva01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t110_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info,Page4,userdefined_field", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
           #CALL cl_set_comp_visible("info,Page4,userdefined_field", TRUE) #MOD-D30148 mark
           #MOD-D30148 add start -----
            CALL cl_set_comp_visible("info,userdefined_field", TRUE)
            IF g_argv6 ='2' THEN
              CALL cl_set_comp_visible("Page4", TRUE)
            END IF
           #MOD-D30148 add end   -----
          END IF               
      END IF  
      #FUN-CB0014---add---end--
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
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               CALL t110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t110_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-A80112 --add
         WHEN "qc"
              IF g_rva.rva32 matches '[Ss]' THEN             #FUN-A50030 add
                CALL cl_err('','apm-030',0)                  #FUN-A50030 add
              ELSE                                           #FUN-A50030 add
                IF cl_null(g_rva.rva01) THEN
                   CALL cl_err('','aqc-334',1)
                ELSE 
                   IF g_rva.rvaconf <> 'Y' THEN              #MOD-C30133 add
                      CALL cl_err('','apm1072',1)            #MOD-C30133 add
                   ELSE                                      #MOD-C30133 add
                      LET l_msg = "aqcp001  '",g_rva.rva01,"' "
                      IF cl_chk_act_auth() THEN
                         CALL cl_cmdrun_wait(l_msg)
                      END IF                                 #MOD-C30133 add
                   END IF
                END IF
              END IF                                         #FUN-A50030 add
#FUN-A80112 --end
         WHEN "add_invoice"
            IF cl_chk_act_auth() THEN   #MOD-A80109
               CALL t110_k()
            END IF   #MOD-A80109
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t110_x() #FUN-D20025 mark
               CALL t110_x(1) #FUN-D20025 add
            END IF
         #FUN-D20025 add
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t110_x(2)
            END IF 
         #FUN-D20025 add   
         WHEN "confirm"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
              #CALL t110_y()                               #FUN-9C0076 mark
              #FUN-9C0076 add str ---
               #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6)   #CALL 原確認的 check 段#FUN-A10130 #CHI-C30118 mark
               CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6) #CHI-C30118 add 
               IF g_success = "Y" THEN
                  CALL t110sub_y_upd(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)     #CALL 原確認的 update 段#FUN-A10130
                  CALL t110_refresh() RETURNING g_rva.*
                  CALL t110_show()
               END IF
              #FUN-9C0076 add end ---
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               CALL t110_z()
            END IF
         WHEN "qc_status"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               LET l_cmd = "apmt110_x '",g_rva.rva01,"'"   #CHI-6A0040 mod
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "generate_st_in_qc_return"
            IF cl_chk_act_auth() THEN
               CALL t110_g()
#FUN-B90101--add--begin--
               IF g_azw.azw04='2' THEN                     #TQC-C20117--add
                  IF g_success = 'Y' THEN  
                     CALL t110_ins_rvvslk()
                  END IF
               END IF                                      #TQC-C20117--add
#FUN-B90101--add--end--
            END IF
         WHEN "qry_st_in"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               LET l_rvu01 = '' #MOD-D40093 add
               SELECT rvu01 INTO l_rvu01 FROM rvu_file WHERE rvu00 = '1' AND rvu02 = g_rva.rva01  #TQC-CA0043 add
               CASE
                  WHEN g_rva.rva10='SUB'
                    #LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",             #FUN-A60009 mark
                    #             "'1' 'SUB'"                                            #FUN-A60009 mark
                    #LET g_cmd = "apmt730 ","'' '' '",g_rva.rva01 CLIPPED,"' '1' 'SUB'"  #FUN-A60009 add #TQC-CA0043 mark
                     LET g_cmd = "apmt730 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '1' 'SUB'"  #TQC-CA0043 add 
                  WHEN g_rva.rva10='TAP' OR g_rva.rva10 = 'TRI'
                    #LET g_cmd = "apmt740 ","'",g_rva.rva01 CLIPPED,"' '' '1'"       #No.FUN-630010 #FUN-A60009 mark
                    #LET g_cmd = "apmt740 ","'' '' '",g_rva.rva01 CLIPPED,"' '1'"    #FUN-A60009 add #TQC-CA0043 mark
                     LET g_cmd = "apmt740 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '1'" #TQC-CA0043 add 
                  OTHERWISE

                  #  SELECT rvu01 INTO l_rvu01 FROM rvu_file WHERE rvu00 = '1' AND rvu02 = g_rva.rva01    #TQC-C90128 add #TQC-CA0043 mark
#FUN-B90101--add--begin--
                     IF g_azw.azw04='2' THEN             #TQC-C20117--add
                       #LET g_cmd = "apmt720_slk ","'' '' '",g_rva.rva01 CLIPPED,"' '1'"                   #TQC-C90128 mark
                        LET g_cmd = "apmt720_slk ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '1'"         #TQC-C90128 add
#TQC-C20117--add---------------begin----------------------------------------
                     ELSE
                      # LET g_cmd = "apmt720 ","'' '' '",g_rva.rva01 CLIPPED,"' '1'"                       #TQC-C90128 mark
                        LET g_cmd = "apmt720 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '1'"         #TQC-C90128 add
                     END IF
#TQC-C20117--add---------------end-------------------------------------------
#FUN-B90101--add--end--
#FUN-B90101--mark--begin--
#&ifndef ICD
#                   #LET g_cmd = "apmt720 ","'",g_rva.rva01 CLIPPED,"' '' '1'"         #No.FUN-630010 #FUN-A60009 mark
#                    LET g_cmd = "apmt720 ","'' '' '",g_rva.rva01 CLIPPED,"' '1'"      #FUN-A60009 add
#&else
#                   #LET g_cmd = "apmt720_icd ","'",g_rva.rva01 CLIPPED,"' '' '1'"     #CHI-920060 #FUN-A60009 mark
#                    LET g_cmd = "apmt720_icd ","'' '' '",g_rva.rva01 CLIPPED,"' '1'"  #FUN-A60009 add
#&endif
#FUN-B90101--mark--end--
               END CASE
               CALL cl_cmdrun_wait(g_cmd) #FUN-660216 add
               CALL t110_show()           #CHI-A70031
            END IF
         WHEN "qry_qc_return"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               LET l_rvu01 = '' #MOD-D40093 add
               SELECT rvu01 INTO l_rvu01 FROM rvu_file WHERE rvu00 = '2' AND rvu02 = g_rva.rva01    #TQC-CA0043 add
               CASE
                  WHEN g_rva.rva10='SUB'
                    #LET g_cmd = "apmt731 ","'",g_rva.rva01 CLIPPED,"' '' ",      #FUN-A60009 mark
                    #            "'2' 'SUB'"  #No.FUN-630010                      #FUN-A60009 mark
                    #LET g_cmd = "apmt731 ","'' '' '",g_rva.rva01 CLIPPED,"' '2' 'SUB'"  #FUN-A60009 add #TQC-CA0043 mark
                     LET g_cmd = "apmt731 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '2' 'SUB'"  #TQC-CA0043 add
                    
                  WHEN g_rva.rva10='TAP' OR g_rva.rva10 = 'TRI'
                    #LET g_cmd = "apmt741 ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #No.FUN-630010 #FUN-A60009 mark
                    #LET g_cmd = "apmt741 ","'' '' '",g_rva.rva01 CLIPPED,"' '2'"  #FUN-A60009 add #TQC-CA0043 mark
                     LET g_cmd = "apmt741 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '2'"  #TQC-CA0043 add
                  OTHERWISE
                    #SELECT rvu01 INTO l_rvu01 FROM rvu_file WHERE rvu00 = '2' AND rvu02 = g_rva.rva01    #TQC-C90128 add
                    #LET g_cmd = "apmt721 ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #No.FUN-630010 #FUN-A60009 mark
                    #LET g_cmd = "apmt721 ","'' '' '",g_rva.rva01 CLIPPED,"' '2'"  #FUN-A60009 add          #TQC-C90128 mark
                     LET g_cmd = "apmt721 ","'",l_rvu01 CLIPPED,"' '' '",g_rva.rva01 CLIPPED,"' '2'"         #TQC-C90128 add
               END CASE
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
               CALL t110_show()   #CHI-A70031
            END IF

          #FUN-BC0104----------add------------str---------------------
          WHEN "qc_item_tran_store"
            LET g_action_choice ="generate_st_in_qc_return"     #FUN-D10055 add
            IF cl_chk_act_auth() THEN
               CALL t110_qc_item()
            END IF 
          #FUN-BC0104----------add------------end---------------------

         WHEN "receiving"
            LET g_cmd = "apmq320 '",g_rva.rva01,"'"
            CALL cl_cmdrun(g_cmd)

         #FUN-9C0076 add str ---
          WHEN "approval_status"               #簽核狀況
            IF cl_chk_act_auth() THEN          #DISPLAY ONLY
               IF aws_condition2() THEN
                  CALL aws_efstat2()
               END IF
            END IF

          WHEN "easyflow_approval"             #EasyFlow送簽
            IF cl_chk_act_auth() THEN
              #FUN-C20026 add str---
               SELECT * INTO g_rva.* FROM rva_file
                WHERE rva01 = g_rva.rva01
               CALL t110_show()
               CALL t110_b_fill(' 1=1',' 1=1')
              #FUN-C20026 add end---
               CALL t110_ef()
               CALL t110_show()  #FUN-C20026 add
            END IF
         #FUN-9C0076 add end ---

         WHEN "exporttoexcel"     #FUN-4B0025
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
#                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')    #FUN-CB0014 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvb),'','')                          #FUN-CB0014 add
               END IF
            #FUN-CB0014---add---str---
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_rva_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---   
         WHEN "trans_spc"         #FUN-680011
            IF cl_chk_act_auth() THEN
               CALL t110_spc()
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rva.rva01 IS NOT NULL THEN
                 LET g_doc.column1 = "rva01"
                 LET g_doc.value1 = g_rva.rva01
                 CALL cl_doc()
               END IF
         END IF
 
         #@WHEN GPM規範顯示
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_rvb[l_ac].rvb05 END IF
              LET l_supplierid = g_rva.rva05
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_rvb[l_ac].rvb05 END IF
              LET l_supplierid = g_rva.rva05
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
 
        WHEN "qry_lot"
           LET l_cnt  = ARR_COUNT()    #MOD-AA0074 add #MOD-B40006 mod l_ac->l_cnt 
           IF l_cnt > 0 THEN           #MOD-AA0074 add #MOD-B40006 mod l_ac->l_cnt  
              CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
              IF l_ec_sw = 'N' THEN      #CHI-A80024
#FUN-B90101--add--begin--
                 IF g_azw.azw04='2' THEN             #TQC-C20117--add 
                    SELECT ima918,ima921 INTO g_ima918,g_ima921
                       FROM ima_file
                      WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                        AND imaacti = "Y"

                     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                        IF g_sma.sma90 = "Y" THEN  #No.MOD-860080
                          IF cl_null(g_rvbslk[l_ac2].rvbslk37) THEN
                             LET g_rvbslk[l_ac2].rvbslk37 = ' '
                          END IF
                          IF cl_null(g_rvbslk[l_ac2].rvbslk38) THEN
                             LET g_rvbslk[l_ac2].rvbslk38 = ' '
                          END IF
                          SELECT img09 INTO g_img09
                            FROM img_file   #庫存單位
                           WHERE img01=g_rvbslk[l_ac2].rvbslk05 AND img02=g_rvbslk[l_ac2].rvbslk36
                             AND img03=g_rvbslk[l_ac2].rvbslk37 AND img04=g_rvbslk[l_ac2].rvbslk38
                           CALL s_umfchk(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,g_img09)   #No.FUN-940083 pmn07-->rvb9
                              RETURNING l_i,l_fac
                           IF l_i = 1 THEN LET l_fac = 1 END IF
                           CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236----mark--begin----
#                          CALL s_lotin(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,
#                                   g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,g_img09,    #No.FUN-940083 pmn07-->rvb9
#                                   l_fac,g_rvbslk[l_ac2].rvbslk07,'','QRY')#CHI-9A0022 add ''
#TQC-B90236----mark--end------
#TQC-B90236----add---begin----
                           CALL s_mod_lot(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,
                                      g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,
                                      g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk38,
                                      g_rvbslk[l_ac2].rvbslk90,g_img09,l_fac,g_rvbslk[l_ac2].rvbslk07,'','QRY',1)
#TQC-B90236----add---end------
                           RETURNING l_r,g_qty
                        END IF
                     END IF
#TQC-C20117----add--------------begin-------------
                 ELSE
                    SELECT ima918,ima921 INTO g_ima918,g_ima921
                      FROM ima_file
                     WHERE ima01 = g_rvb[l_ac].rvb05
                       AND imaacti = "Y"

                    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                       IF g_sma.sma90 = "Y" THEN  #No.MOD-860080
                          IF cl_null(g_rvb[l_ac].rvb37) THEN
                             LET g_rvb[l_ac].rvb37 = ' '
                          END IF
                          IF cl_null(g_rvb[l_ac].rvb38) THEN
                             LET g_rvb[l_ac].rvb38 = ' '
                          END IF
                          SELECT img09 INTO g_img09
                            FROM img_file   #庫存單位
                            WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                             AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                            CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)   #No.FUN-940083 pmn07-->rvb90
                                RETURNING l_i,l_fac
                          IF l_i = 1 THEN LET l_fac = 1 END IF
                             CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236----mark--begin----
#                            CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
#                                        g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,    #No.FUN-940083 pmn07-->rvb90
#                                        l_fac,g_rvb[l_ac].rvb07,'','QRY')#CHI-9A0022 add ''
#TQC-B90236----mark--end------
#TQC-B90236----add---begin----
                             CALL s_mod_lot(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                                          g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                          g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                          g_rvb[l_ac].rvb90,g_img09,l_fac,g_rvb[l_ac].rvb07,'','QRY',1)
#TQC-B90236----add---end------
                                   RETURNING l_r,g_qty
                           END IF
                      END IF
                  END IF  
#TQC-C20117---add---------------end--------------------
                
#FUN-B90101 add &endif
              END IF   #CHI-A80024
           END IF       #MOD-AA0074 add

        #DEV-D30045--add--begin
         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                CALL t110sub_barcode_gen(g_rva.rva01,'Y')
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
                LET g_msg = "abaq100 '",g_rva.rva01,"' "
                CALL cl_cmdrun_wait(g_msg)
             END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                CALL t110_barcode_out()
             END IF
        #DEV-D30045--add--end

        WHEN "e_proc_require"        
           IF cl_chk_act_auth() THEN                                                                                                  
              CALL t110_epr()                                                                                                         
           END IF                                                                                                                     

       #FUN-9C0076 add str ------------------------------------
       #@WHEN "准"
        WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN       #最後一關並且沒有加簽人員
                 CALL t110sub_y_upd(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)     #CALL 原確認的 update 段 #FUN-A10130
                 CALL t110_refresh() RETURNING g_rva.*
                 CALL t110_show()
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN #執行 EF 簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN           #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN  #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                       IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                          CALL t110_q()
                         #傳入簽核模式時不應執行的 action 清單
#FUN-A50030 mod str ----
                          #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc") #FUN-D20025 mark 
                          #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc")#FUN-D20025 add #DEV-D30045 mark
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc,barcode_gen,barcode_query,barcode_output")##DEV-D30045 add
#FUN-A50030 mod end ----
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

       #@WHEN "不准"
        WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN #退回關卡
                IF aws_efapp_formapproval() THEN                     #執行 EF 簽核
                   IF l_creator = "Y" THEN                           #當退回填表人時
                      LET g_rva.rva32 = 'R'                          #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_rva.rva32
                   END IF

                   IF cl_confirm('aws-081') THEN                     #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN            #取得下一筆簽核單號
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)              #取得單號
                         IF NOT cl_null(g_argv1) THEN                #自動 query 帶出資料
                            CALL t110_q()
                           #傳入簽核模式時不應執行的 action 清單
#FUN-A50030 mod str ----
                            #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc")#FUN-D20025 mark
                            #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc")#FUN-D20025 add  #DEV-D30045mark
                            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, generate_st_in_qc_return, qc_status, add_invoice, easyflow_approval, e_proc_require, qc,barcode_gen,barcode_query,barcode_output")##DEV-D30045 add
#FUN-A50030 mod end ----
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

       #@WHEN "加簽"
        WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN      #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF

       #@WHEN "撤簽"
        WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF

       #@WHEN "抽單"
        WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF

       #@WHEN "簽核意見"
        WHEN "phrase"
              CALL aws_efapp_phrase()
       #FUN-9C0076 add end --------------------------------------------- 
#FUN-A60035 ---MARK BEGIN
##FUN-A50054---Begin add 
#         WHEN "style_detail"
#         IF l_ac>0 THEN
#            CALL s_detail(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,g_rvb[l_ac].rvb05,'Y')
#               RETURNING g_rvb[l_ac].rvb07
#         END IF
#FUN-A50054 ---end        
#FUN-A60035 ---MARK END       
#FUN-C30063---add---START
         WHEN "qry_qc" #查詢QC單
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               #LET l_cmd = "aqct110 ","'",g_rva.rva01 ,"' '' '' '' ''"   #TQC-C40254 mark
               #TQC-C40254--add--begin--
                  LET l_cmd = "aqct110 ","'",g_rva.rva01 ,"' '' '' '' ''"
               #TQC-C40254--add--end--
               CALL cl_cmdrun_wait(l_cmd)
            END IF 
#FUN-C30063---add---END       
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t110_a()
   DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_msg("")
   CLEAR FORM
   CALL g_rvb.clear()
#FUN-B90101--add--begin--
    IF g_azw.azw04='2' THEN             #TQC-C20117--add
       CALL g_rvbslk.clear()
       CALL g_imx.clear()
       LET g_rec_b3 = 0
    END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
   INITIALIZE g_rva.* TO NULL             #DEFAULT 設定
   LET g_rva01_t = NULL
   #預設值及將數值類變數清成零
   LET g_rva_o.* = g_rva.*
   LET g_rva.rva06 = g_today
   LET g_rva.rvaprsw = 'Y'
   LET g_rva.rvaprno = 0
   LET g_rva.rva00 = g_argv6               #FUN-940083
 
   IF NOT cl_null(g_argv2) THEN
      LET g_rva.rva10 = g_argv2
   END IF
   IF NOT cl_null(g_argv1) AND (g_argv4 = "insert") THEN
      LET g_rva.rva02 = g_argv1
   END IF

  #FUN-9C0076 str-------
   LET g_rva.rva32 = '0'         #開立
   LET g_rva.rvamksg = "N"

   LET g_rva.rva33 = g_user
   CALL t110_rva33('d')
  #FUN-9C0076 end-------
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      IF g_argv2='TAP' THEN
         LET g_rva.rva10 = 'TAP'
      END IF
 
      LET g_rva.rva04 = 'N'
      LET g_rva.rvaconf = 'N'
      LET g_rva.rvaspc = '0'                               #FUN-680011
      LET g_rva.rvauser=g_user
      LET g_rva.rvaoriu = g_user #FUN-980030
      LET g_rva.rvaorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_rva.rvagrup=g_grup
   #  LET g_rva.rvadate=g_today  #TQC-A60021 -mark
      LET g_rva.rvacrat=g_today  #TQC-A60021 -add 
      LET g_rva.rvaacti='Y'
      IF cl_null(g_argv2) THEN
          LET g_rva.rva10 ='REG'
      END IF
      LET g_rva.rva29 = '1'
      IF g_azw.azw04='2' THEN
         LET g_rva.rva30 = g_plant
         LET g_rva.rvacrat= g_today
      END IF
      LET g_rva.rvaplant = g_plant
      LET g_rva.rvalegal = g_legal
 
      CALL t110_i("a")                #輸入單頭
 
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
         INITIALIZE g_rva.* TO NULL
         EXIT WHILE
      END IF
 
      IF cl_null(g_rva.rva01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF

#TQC-B20024 --BEGIN--
      IF NOT cl_null(g_rva.rva02) AND cl_null(g_rva.rva116) THEN
          SELECT pmm43 INTO g_rva.rva116 FROM pmm_file
           WHERE pmm01 = g_rva.rva02
      END IF 
#TQC-B20024 --END--
 
      BEGIN WORK
        IF g_prog = 'aict041' THEN LET g_chr1='B' ELSE LET g_chr1='3' END IF   #TQC-9B0191
        CALL s_auto_assign_no("apm",g_rva.rva01,g_rva.rva06,g_chr1,"rva_file","rva01","","","") #TQC-9B0191
             RETURNING li_result,g_rva.rva01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_rva.rva01
 
      LET g_rva.rvaplant = g_plant #NO.FUN-980006 jarlin add
      LET g_rva.rvalegal = g_legal #NO.FUN-980006 jarlin add
     
      INSERT INTO rva_file VALUES (g_rva.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_rva.rva01,SQLCA.sqlcode,1)   #MOD-A40112
         ROLLBACK WORK #No:7857
         #CALL cl_err(g_rva.rva01,SQLCA.sqlcode,1)   #MOD-A40112
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No:7857
         CALL cl_flow_notify(g_rva.rva01,'I')
         SELECT rva01 INTO g_rva.rva01 FROM rva_file
          WHERE rva01 = g_rva.rva01
         LET g_rva01_t = g_rva.rva01        #保留舊值
      END IF
 
      LET g_rva_t.* = g_rva.*
      LET g_sw = 'Y'
      LET g_rec_b =0                        #NO.FUN-680064
#FUN-B90101--add--begin
      IF g_azw.azw04='2' THEN             #TQC-C20117--add
         LET g_rec_b2 =0
         LET g_rec_b3 =0
      END IF                              #TQC-C20117--add
#FUN-B90101--add--end-- 

      IF NOT cl_null(g_rva.rva02) THEN
         CALL t110_g_b()
         IF g_azw.azw04='2' THEN             #TQC-C20117--add
            CALL t110_g_bslk()    #FUN-B90101 Add
         END IF                              #TQC-C20117--add
      ELSE
         LET g_rec_b = 0
      END IF
      CALL t110_b()                   #輸入單身
 
      LET g_prt='Y'
      IF NOT cl_null(g_rva.rva01) AND g_smy.smyprint='Y' THEN  #是否馬上列印
#MOD-B80088 -- begin --
         #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6) #CHI-C30118 mark
         CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)  #CHI-C30118 add
         IF g_success = "Y" THEN
#MOD-B80088 -- end --
            IF cl_confirm('mfg9392') THEN
               CALL t110_out()
            END IF
#MOD-B80088 -- begin --
         ELSE
            EXIT WHILE
         END IF
#MOD-B80088 -- end --
      END IF
 
     #IF NOT cl_null(g_rva.rva01) AND g_smy.smydmy4='Y' THEN                           #確認 #FUN-9C0076 mark
      IF NOT cl_null(g_rva.rva01) AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN   #FUN-9C0076 add
         LET g_action_choice = "insert"               #FUN-9C0076 add
         LET g_rvu03_flag = '1'                       #MOD-910053 #FUN-A10130

        #CALL t110_y()                                #FUN-9C0076 mark
        #FUN-9C0076 str ---
         #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6)    #CALL 原確認的 check 段#FUN-A10130 #CHI-C30118 mark
         CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)  #CHI-C30118 add
         IF g_success = "Y" THEN
            CALL t110sub_y_upd(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)   #CALL 原確認的 update 段 #FUN-A10130
            CALL t110_refresh() RETURNING g_rva.*
            CALL t110_show()
         END IF
        #FUN-9C0076 end ---

         LET g_rvu03_flag = '0'                        #MOD-910053 #FUN-A10130
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_k()
   DEFINE l_rvb22      LIKE rvb_file.rvb22    #No.FUN-680136 VARCHAR(20)
   DEFINE l_i          LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_cnt        LIKE type_file.num5    #No.MOD-720103 add
   DEFINE l_cnt2       LIKE type_file.num5    #FUN-BB0001 add 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   #-----MOD-AB0176---------
   IF l_ac = 0 OR cl_null(l_ac) THEN
      CALL cl_err('','amr-304',0) 
      RETURN
   END IF 
   #-----END MOD-AB0176-----

   #大陸版, 發票統一在入庫單發票維護作業輸入
   IF g_aza.aza26 = '2' THEN
      CALL cl_err('','apm-978',0) #No.TQC-7C0086
      RETURN
   END IF
 
   IF cl_null(g_rva.rva01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#TQC-B60304 ---begin---mark--- 
#TQC-B20099 --begin--        
#  IF g_sma.sma886[3,3] = 'N' THEN                  
#     CALL cl_err('','apm-199',0)
#     RETURN 
#  END IF   
#TQC-B20099 --end--  
#TQC-B60304 ---end---

   SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
 
   IF g_rva.rvaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   #FUN-C30140--add----str---
   IF g_rva.rva32 matches '[Ss]' THEN   
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   #FUN-C30140--add----end---
 
  #LET l_rvb22=目前所指向的單身項次所對應的發票號碼
   LET l_rvb22 = g_rvb[l_ac].rvb22
   CALL sapmt114(l_rvb22,g_rva.rva01) RETURNING l_rvb22
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
  #判斷單身是否有發票號碼為空白的，
  #若有則詢問是否一起UPDATE成相同的發票號碼
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvb_file
                   WHERE rvb01 = g_rva.rva01
                     AND rvb02 != g_rvb[l_ac].rvb02
                     AND (rvb22 = ' ' OR rvb22 IS NULL)
 
  #發現單身發票欄位有空白的資料，詢問是否一起UPDATE
   IF l_cnt > 0 THEN
      IF cl_confirm('aap-267') THEN
         UPDATE rvb_file
            SET rvb22=l_rvb22
          WHERE rvb01=g_rva.rva01
            AND (rvb22 = ' ' OR rvb22 IS NULL)
 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","rvb_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1) #No.FUN-660129
         ELSE
             FOR l_i = 1 TO g_rec_b
                 IF cl_null(g_rvb[l_i].rvb22) THEN
                    LET g_rvb[l_i].rvb22 = l_rvb22
                 END IF
             END FOR
   #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
   #FUN-BB0001 add START
            LET l_cnt2 = 0
            SELECT COUNT(*) INTO l_cnt2 FROM rvv_file WHERE rvv04 = g_rva.rva01
            IF l_cnt2 >= 1 THEN
               UPDATE rvv_file
                  SET rvv22 = l_rvb22
                 WHERE rvv04 = g_rva.rva01
                  AND (rvv22 = ' ' OR rvv22 IS NULL)

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rvv_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)
               END IF
               LET g_upnull = '1'   #MOD-BB0141 add
            END IF
   #FUN-BB0001 add END
         END IF
      END IF
   END IF
 
  #UPDATE滑鼠所指向單身項次所對應的發票號碼
   UPDATE rvb_file
      SET rvb22=l_rvb22
    WHERE rvb01=g_rva.rva01
      AND rvb02 = g_rvb[l_ac].rvb02
#流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
#FUN-BB0001 add START
   LET l_cnt2 = 0
   SELECT COUNT(*) INTO l_cnt2 FROM rvv_file WHERE rvv04 = g_rva.rva01 AND rvv05 = g_rvb[l_ac].rvb02
   IF l_cnt2 >= 1 THEN
      UPDATE rvv_file
         SET rvv22=l_rvb22
       WHERE rvv04=g_rva.rva01
         AND rvv05 = g_rvb[l_ac].rvb02
   END IF
#FUN-BB0001 add END 
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      LET g_rvb[l_ac].rvb22 = l_rvb22
   END IF
END FUNCTION
 
FUNCTION t110_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rva.rva01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rva.* FROM rva_file
    WHERE rva01=g_rva.rva01
 
   IF g_rva.rvaconf = 'Y' THEN
      CALL t110_u2() RETURN
   END IF
 
   IF g_rva.rvaconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
 
  #FUN-9C0076 add str ---
   IF g_rva.rva32 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-9C0076 add end ---

   CALL cl_msg("")
   CALL cl_opmsg('u')
   LET g_rva01_t = g_rva.rva01
   LET g_rva_o.* = g_rva.*
    LET g_success = 'Y' #MOD-4B0035
   BEGIN WORK
 
   OPEN t110_cl USING g_rva.rva01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_rva.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t110_show()
   WHILE TRUE
      LET g_rva.rvamodu=g_user
      LET g_rva.rvadate=g_today
 
      CALL t110_i("u")                             #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rva.*=g_rva_t.*
         CALL t110_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rva.rva01 != g_rva01_t THEN
         UPDATE rvb_file SET rvb01=g_rva.rva01 WHERE rvb01=g_rva01_t
         IF STATUS THEN
            CALL cl_err3("upd","rvb_file",g_rva01_t,"",STATUS,"","update rvb",1) #No.FUN-660129
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_rva.rva32 = '0'             #修改後需重新送簽  #FUN-9C0076 add

      UPDATE rva_file SET * = g_rva.* WHERE rva01 = g_rva.rva01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rva_file","","",STATUS,"","update rva",1) #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE t110_cl
   DISPLAY BY NAME g_rva.rva32         #FUN-9C0076 add
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rva.rva01,'U')
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t110_u2()
 
   INPUT BY NAME g_rva.rva21,g_rva.rva08,g_rva.rva09 WITHOUT DEFAULTS
  
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
  
    ON ACTION about      
       CALL cl_about()     
 
    ON ACTION controlg      
       CALL cl_cmdask()    
 
    ON ACTION help         
       CALL cl_show_help()
 
    END INPUT
 
 
   IF INT_FLAG THEN
      SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
      DISPLAY BY NAME g_rva.rva21,g_rva.rva08,g_rva.rva09
   END IF
 
   UPDATE rva_file SET rva21=g_rva.rva21,
                       rva08=g_rva.rva08,
                       rva09=g_rva.rva09
    WHERE rva01=g_rva.rva01
 
END FUNCTION
 
FUNCTION t110_i(p_cmd)
   DEFINE
      l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-680136 VARCHAR(1)
      l_direct        LIKE type_file.chr1,                 #No.FUN-680136 VARCHAR(01)
      l_dir           LIKE type_file.chr1,                 #No.FUN-680136 VARCHAR(01)
      l_pmc04         LIKE pmc_file.pmc04,
      l_poz011        LIKE poz_file.poz011,
      l_cnt           LIKE type_file.num5,                 #No.FUN-680136 SMALLINT
      p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
   DEFINE
      li_result       LIKE type_file.num5                  #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE l_gen02     LIKE gen_file.gen02                  #NO.FUN-960130
   DEFINE l_azp02     LIKE azp_file.azp02                  #NO.FUN-960130
   DEFINE l_gem02     LIKE gem_file.gem02                  #NO.FUN-960130
   DEFINE l_slip      LIKE smy_file.smyslip                #No.FUN-980038
   DEFINE l_rva10     LIKE rva_file.rva10                  #No.FUN-980038
#CHI-B80038 -- begin --
   DEFINE l_rvb01     LIKE rvb_file.rvb01
   DEFINE l_rvb02     LIKE rvb_file.rvb02
   DEFINE l_rvb05     LIKE rvb_file.rvb05
   DEFINE l_rvb10     LIKE rvb_file.rvb10
   DEFINE l_rvb10t    LIKE rvb_file.rvb10t
   DEFINE l_rvb42     LIKE rvb_file.rvb42
   DEFINE l_rvb43     LIKE rvb_file.rvb43
   DEFINE l_rvb87     LIKE rvb_file.rvb87
   DEFINE l_rvb88     LIKE rvb_file.rvb88
   DEFINE l_rvb88t    LIKE rvb_file.rvb88t
   DEFINE l_rvb90     LIKE rvb_file.rvb90
#CHI-B80038 -- end --
 
   IF g_azw.azw04='2' THEN
      DISPLAY BY NAME g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,
                      g_rva.rva31,g_rva.rvaplant,g_rva.rvacrat,g_rva.rvacont   #FUN-A30063 ADD
                     ,g_rva.rvaoriu,g_rva.rvaorig                              #TQC-A30041 ADD
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rva.rvaconu
      DISPLAY l_gen02 TO FORMONLY.rvaconu_desc
      
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva30
      DISPLAY l_azp02 TO FORMONLY.rva30_desc
 
      LET l_azp02 = ''
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva31
      DISPLAY l_azp02 TO FORMONLY.rva31_desc
 
      LET l_azp02 = ''
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rvaplant
      DISPLAY l_azp02 TO FORMONLY.rvaplant_desc
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   
   INPUT BY NAME g_rva.rvaoriu,g_rva.rvaorig,
         g_rva.rva01,g_rva.rva06,g_rva.rva02,g_rva.rva05,g_rva.rva99,
         g_rva.rva04,g_rva.rva21,g_rva.rva08,g_rva.rva29,g_rva.rva31, #NO.FUN-960130
         g_rva.rva09,g_rva.rva34,g_rva.rva10,g_rva.rvaconf,g_rva.rvaspc,#FUN-A50071  #FUN-680011
         g_rva.rva117,
         g_rva.rva33,g_rva.rvamksg,g_rva.rva32,                       #FUN-9C0076 add
         g_rva.rva111,g_rva.rva112,
         g_rva.rva115,g_rva.rva116,g_rva.rva113,
         g_rva.rva114,
         g_rva.rvauser,g_rva.rvagrup,g_rva.rvamodu,
         g_rva.rvadate,g_rva.rvaacti
         ,g_rva.rvaud01,g_rva.rvaud02,g_rva.rvaud03,g_rva.rvaud04,
         g_rva.rvaud05,g_rva.rvaud06,g_rva.rvaud07,g_rva.rvaud08,
         g_rva.rvaud09,g_rva.rvaud10,g_rva.rvaud11,g_rva.rvaud12,
         g_rva.rvaud13,g_rva.rvaud14,g_rva.rvaud15 
      WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t110_set_entry(p_cmd)
        CALL t110_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rva01")
         CALL cl_set_docno_format("rvb04")
         CALL t110_set_required()      #NO.FUN-640151
 
      AFTER FIELD rva01
         IF NOT cl_null(g_rva.rva01) THEN
            LET g_t1=s_get_doc_no(g_rva.rva01)
            #得到該單別對應的屬性群組
            IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
               #讀取smy_file中指定作業對應的默認屬性群組
               SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
               LET g_t1=s_get_doc_no(g_rva.rva02)
               IF NOT cl_null(g_rva.rva02) THEN
                  SELECT smy62 INTO lg_smy621 FROM smy_file WHERE smyslip = g_t1
                  IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR (cl_null(lg_smy62)AND NOT cl_null(lg_smy621)) OR lg_smy621 <> lg_smy62 THEN
                     CALL cl_err(g_rva.rva02,'apm1005',0)
                     LET g_rva.rva01 = NULL
                     DISPLAY BY NAME g_rva.rva01
                     NEXT FIELD rva01
                  END IF
               END IF
               #刷新界面顯示
               CALL t110_refresh_detail()
            ELSE
               LET lg_smy62 = ''
            END IF
 
           IF g_prog = 'aict041' THEN LET g_chr1='B' ELSE LET g_chr1='3' END IF   #TQC-9B0191
           CALL s_check_no("apm",g_rva.rva01,g_rva01_t,g_chr1,"rva_file","rva01","") #TQC-9B0191
             RETURNING li_result,g_rva.rva01
           DISPLAY BY NAME g_rva.rva01
           IF (NOT li_result) THEN
             NEXT FIELD rva01
           END IF
           IF cl_null(g_rva01_t) THEN
              CALL s_get_doc_no(g_rva.rva01) RETURNING l_slip                                                                  
              SELECT smy72 INTO l_rva10 FROM smy_file                                                                      
               WHERE smyslip = l_slip                                                                                          
              IF NOT cl_null(l_rva10) THEN
                 LET g_rva.rva10 = l_rva10
                 DISPLAY BY NAME g_rva.rva10
              END IF
           END IF
           CALL s_mfgchno(g_rva.rva01) RETURNING g_i,g_rva.rva01
           DISPLAY BY NAME g_rva.rva01
           IF NOT g_i THEN NEXT FIELD rva01 END IF

          #FUN-9C0076 add str ---
           IF g_rva_t.rva01 IS NULL OR (g_rva.rva01 != g_rva_t.rva01 ) THEN
              LET g_rva.rvamksg = g_smy.smyapr
              LET g_rva.rva32 = '0'
              DISPLAY BY NAME g_rva.rvamksg   #簽核否
              DISPLAY BY NAME g_rva.rva32     #簽核狀況
           END IF
          #FUN-9C0076 add end ---
         ELSE
            IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
               LET lg_smy62 = ''
               CALL t110_refresh_detail()
            END IF
         END IF
 
      AFTER FIELD rva06 #收貨日期
         IF NOT cl_null(g_rva.rva06) THEN
            IF NOT cl_null(g_sma.sma53) AND g_rva.rva06 <= g_sma.sma53 THEN
               CALL cl_err('','mfg9999',0)
               NEXT FIELD rva06
            END IF
         END IF
 
 
      BEFORE FIELD rva02 #採購單號
         CALL t110_set_entry(p_cmd)
 
      AFTER FIELD rva02 #採購單號
         IF NOT cl_null(g_rva.rva02) THEN
             LET g_cnt = 0
             SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
             IF g_cnt > 0 THEN
                LET g_cnt=0
                SELECT COUNT(*) INTO g_cnt FROM rvb_file
                 WHERE rvb01=g_rva.rva01 
                   AND rvb04 <> g_rva.rva02               
                IF g_cnt > 0 THEN
                   CALL cl_err(g_rva.rva02,'apm-940',1)
                   NEXT FIELD rva02
                END IF 
             END IF 
            ###### 01/11/18 Tommy 避免三角收貨到一般採購或逆拋三角
            IF g_argv2 = 'TAP' THEN
               SELECT poz011 INTO l_poz011
                 FROM pmm_file,poz_file
                WHERE pmm904 = poz01
                  AND pmm01 = g_rva.rva02
                  AND pmm901 = 'Y'         #三角貿易否
                  AND pmm905 = 'Y'         #已拋轉
                  AND pmm02  = 'TAP'       #代採買性質
                  AND pmm906 = 'Y'         #來源單據
               IF SQLCA.sqlcode THEN LET l_poz011 = '' END IF
               IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
                  CALL cl_err(g_rva.rva02,'apm-014',0)
                  NEXT FIELD rva02
               END IF
            END IF
            CALL t110_po(g_rva.rva02,'a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rva.rva02,g_errno,0)
               DISPLAY BY NAME g_rva.rva02
               NEXT FIELD rva02
            END IF
            LET g_t1=s_get_doc_no(g_rva.rva02)
            IF g_sma.sma120 ='Y' AND g_sma.sma907 = 'Y' AND NOT cl_null(g_rva.rva01) THEN
               SELECT smy62 INTO lg_smy621 FROM smy_file WHERE smyslip = g_t1
               IF (cl_null(lg_smy621) AND NOT cl_null(lg_smy62)) OR (cl_null(lg_smy62)AND NOT cl_null(lg_smy621)) OR lg_smy621 <> lg_smy62 THEN
                  CALL cl_err(g_rva.rva02,'apm1005',0)
                  LET g_rva.rva01 = NULL
                  DISPLAY BY NAME g_rva.rva01
                  NEXT FIELD rva01
               END IF
            END IF
            CALL t110_rva05('d')
         END IF
         LET l_dir = 'D'
         IF g_azw.azw04='2' THEN
            IF cl_null(g_rva.rva02) THEN
               CALL cl_set_comp_entry("rva29",TRUE)
            ELSE
               LET g_rva.rva29 = ''
               LET l_azp02 = ''
               LET l_gem02 = ''
               SELECT pmm51,pmm52,pmm53 INTO g_rva.rva29,g_rva.rva30,g_rva.rva31
                  FROM pmm_file WHERE pmm01 = g_rva.rva02
               DISPLAY BY NAME g_rva.rva29,g_rva.rva30,g_rva.rva31
               SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva30
               DISPLAY l_azp02 TO FORMONLY.rva30_desc
               SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_rva.rva31
               DISPLAY l_gem02 TO FORMONLY.rva31_desc
               CALL cl_set_comp_entry("rva29",FALSE)
            END IF
         END IF 
         CALL t110_set_no_entry(p_cmd)
 
       AFTER FIELD rva05 #廠商編號
          IF NOT cl_null(g_rva.rva05) THEN
              IF g_rva.rva05 <> g_rva_t.rva05 AND NOT cl_null(g_rva_t.rva05) THEN
                 SELECT COUNT(*) INTO l_cnt FROM rvb_file 
                  WHERE rvb01=g_rva.rva01
                 IF l_cnt > 0 THEN 
                    IF NOT t110_chk_rva05(g_rva.rva01,g_rva.rva05) THEN
                       CALL cl_err(g_rva.rva05,'apm-133',0)
                       LET g_rva.rva05 = g_rva_t.rva05
                       NEXT FIELD rva05
                    END IF
                 END IF 
              END IF
             CALL t110_rva05('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva05,g_errno,0)
                DISPLAY BY NAME g_rva.rva05
                NEXT FIELD rva05
             END IF
          END IF
 
 
       BEFORE FIELD rva10
          CALL t110_set_entry(p_cmd)

       #-----MOD-A90112---------
       ON CHANGE rva10
          LET l_cnt = 0 
          SELECT COUNT(*) INTO l_cnt FROM rvb_file
            WHERE rvb01 = g_rva.rva01 
              AND rvb04 IS NOT NULL
          IF l_cnt > 0 THEN
             CALL cl_err('','apm-349',0)
             LET g_rva.rva10 = g_rva_t.rva10
             NEXT FIELD CURRENT      
          END IF
       #-----END MOD-A90112-----
 
       AFTER FIELD rva10
          IF NOT g_argv2='ICD' THEN #FUN-810038
             IF NOT cl_null(g_rva.rva10) THEN
                IF g_rva.rva10 != 'REG' AND g_rva.rva10 != 'EXP' AND
                   g_rva.rva10 != 'CAP' AND g_rva.rva10 != 'SUB' AND
                   g_rva.rva10 != 'TAP' THEN
                   DISPLAY BY NAME g_rva.rva10
                   NEXT FIELD rva10
                END IF
                IF cl_null(g_argv2) AND g_rva.rva10='SUB' THEN
                   NEXT FIELD rva10
                END IF
                CALL s_prtype(g_rva.rva10) RETURNING l_str
             END IF
          END IF
          CALL t110_set_no_entry(p_cmd)
       AFTER FIELD rva31
          IF g_rva.rva31 IS NOT NULL  THEN
             CALL t110_rva31()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                RETURN
             END IF      
          END IF
       #MOD-C50208 mark start -----
       #BEFORE FIELD rva04
       #   IF NOT cl_null(g_rva.rva02) THEN            #判斷是否已存在信用狀檔
       #      SELECT COUNT(*) INTO l_cnt FROM alb_file
       #       WHERE alb04=g_rva.rva02
       #      IF l_cnt>0 THEN
       #         LET g_rva.rva04='Y'
       #         DISPLAY BY NAME g_rva.rva04
       #      END IF
       #   END IF
       #MOD-C50208 mark start -----
 
       AFTER FIELD rva04
          IF cl_null(g_rva.rva04) OR g_rva.rva04 NOT MATCHES '[YN]'  THEN
             NEXT FIELD rva04
          END IF
          LET l_dir = 'U'
   
      #FUN-9C0076 add str ------
       AFTER FIELD rva33      #申請人
          IF NOT cl_null(g_rva.rva33) THEN
             CALL t110_rva33('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva33,g_errno,0)
                LET g_rva.rva33 = g_rva_t.rva33
                DISPLAY BY NAME g_rva.rva33
                NEXT FIELD rva33
             END IF
          END IF
          LET g_rva_o.rva33 = g_rva.rva33

       AFTER FIELD rvamksg    #簽核否
          IF NOT cl_null(g_rva.rvamksg) THEN
             IF g_rva.rvamksg NOT MATCHES'[yYnN]' THEN
                NEXT FIELD rvamksg
             END IF
             IF g_rva.rvamksg MATCHES '[Yy]' THEN
                LET g_rva.rva32 = "0"
                DISPLAY BY NAME g_rva.rva32
             END IF
             IF g_rva.rvamksg MATCHES '[Nn]' THEN
                LET g_rva.rva32 = "0"
                DISPLAY BY NAME g_rva.rva32
             END IF
          END IF
      #FUN-9C0076 add end ---

       AFTER FIELD rva111
         IF NOT cl_null(g_rva.rva111) THEN
             CALL t110_rva111('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva111,g_errno,0)
                DISPLAY BY NAME g_rva.rva111
                NEXT FIELD rva111
             END IF
         END IF
 
       AFTER FIELD rva112
         IF NOT cl_null(g_rva.rva112) THEN
             CALL t110_rva112('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva112,g_errno,0)
                DISPLAY BY NAME g_rva.rva112
                NEXT FIELD rva112
             END IF
         END IF
 
       AFTER FIELD rva113
         IF NOT cl_null(g_rva.rva113) THEN
             CALL t110_rva113('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva113,g_errno,0)
                DISPLAY BY NAME g_rva.rva113
                NEXT FIELD rva113
             END IF
         END IF
 
       AFTER FIELD rva114
         IF NOT cl_null(g_rva.rva114) THEN
            IF g_rva.rva114 <= 0 THEN
               CALL cl_err(g_rva.rva114,'mfg9243',0)
               DISPLAY BY NAME g_rva.rva114
               NEXT FIELD rva114
            ELSE
               IF g_aza.aza17 = g_rva.rva113 THEN
                  LET g_rva.rva114 = 1
               END IF
            END IF
            DISPLAY BY NAME g_rva.rva114
         END IF 
 
       AFTER FIELD rva115
         IF NOT cl_null(g_rva.rva115) THEN
             CALL t110_rva115('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva115,g_errno,0)
                DISPLAY BY NAME g_rva.rva115
                NEXT FIELD rva115
             END IF
         END IF
 
       AFTER FIELD rva116
         IF g_rva.rva116 < 0 THEN
            CALL cl_err(g_rva.rva116,'apm-087',0)
            DISPLAY BY NAME g_rva.rva116
            NEXT FIELD rva116
         END IF
 
        AFTER FIELD rvaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rvaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_rva.rvauser = s_get_data_owner("rva_file") #FUN-C10039
           LET g_rva.rvagrup = s_get_data_group("rva_file") #FUN-C10039
          LET l_flag='N'
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF cl_null(g_rva.rva05) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rva.rva05
          END IF
          IF cl_null(g_rva.rva04) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rva.rva04
          END IF
          IF cl_null(g_rva.rva10) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rva.rva10 ATTRIBUTE(REVERSE)
          END IF
 
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD rva01
          END IF

#CHI-B80038 -- begin --
          IF g_argv6 = '2' THEN
             IF g_rva.rva05 != g_rva_t.rva05 OR g_rva.rva113 != g_rva_t.rva113 OR g_rva.rva06 != g_rva_t.rva06 OR
                g_rva.rva115 != g_rva_t.rva115 OR g_rva.rva116 != g_rva_t.rva116 THEN
                SELECT COUNT(*) INTO g_cnt FROM rvb_file
                WHERE rvb01=g_rva.rva01
                IF g_cnt > 0 THEN
                   IF cl_confirm('apm-543') THEN  #是否重新取價
                      SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file
                         WHERE gec01 = g_rva.rva115
                      DECLARE upd_rvb_cs CURSOR FOR
                      SELECT rvb01,rvb02,rvb05,rvb10,rvb10t,rvb42,rvb43,rvb87,rvb90,rvb88,rvb88t
                         FROM rvb_file
                         WHERE rvb01 = g_rva.rva01
                      FOREACH upd_rvb_cs INTO l_rvb01,l_rvb02,l_rvb05,l_rvb10,l_rvb10t,l_rvb42,l_rvb43,
                                              l_rvb87,l_rvb90,l_rvb88,l_rvb88t
                         CALL s_defprice_new(l_rvb05,g_rva.rva05,
                                             g_rva.rva113,g_rva.rva06,l_rvb87,'',
                                             g_rva.rva115,g_rva.rva116,'1',l_rvb90,
                                             '',g_rva.rva112,g_rva.rva111,g_plant)
                                   RETURNING l_rvb10,l_rvb10t,
                                             l_rvb42,l_rvb43
                         LET l_rvb88 = l_rvb10 * l_rvb87
                         LET l_rvb88t = l_rvb10t * l_rvb87
                         SELECT azi04 INTO t_azi04 FROM azi_file
                            WHERE azi01 = g_rva.rva113 AND aziacti = 'Y'
                         CALL cl_digcut(l_rvb88,t_azi04) RETURNING l_rvb88
                         CALL cl_digcut(l_rvb88t,t_azi04) RETURNING l_rvb88t
                         IF g_gec07 = 'N' THEN
                            LET l_rvb88t = l_rvb88*(1+g_rva.rva116/100)
                            LET l_rvb88t = cl_digcut(l_rvb88t,t_azi04)
                         ELSE
                            #IF g_gec05 = 'T' THEN
                            IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                               LET l_rvb10  = l_rvb10t*( 1 - g_rva.rva116/100) #TQC-C30225 add
                               LET l_rvb10  = cl_digcut(l_rvb10,t_azi03)        #TQC-C30225 add
                               LET l_rvb88  = l_rvb88t*( 1 - g_rva.rva116/100)
                               LET l_rvb88  = cl_digcut(l_rvb88,t_azi04)
                            ELSE
                               LET l_rvb88  = l_rvb88t/( 1 + g_rva.rva116/100)
                               LET l_rvb88  = cl_digcut(l_rvb88,t_azi04)
                            END IF
                         END IF
                         UPDATE rvb_file set rvb10  = l_rvb10,
                                             rvb10t = l_rvb10t,
                                             rvb88  = l_rvb88,
                                             rvb88t = l_rvb88t
                            WHERE rvb01 = l_rvb01 AND rvb02 = l_rvb02
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                            CALL cl_err3("upd","rvb_file",l_rvb01,l_rvb02,STATUS,"","upd rvb:",1)
                            EXIT FOREACH
                         END IF
                      END FOREACH
                      CALL t110_b_fill('1=1',' 1=1')  #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
                   END IF
                END IF
             END IF
          END IF
#CHI-B80038 -- end --
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rva01) #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
                 IF g_prog = 'aict041' THEN LET g_chr1='B' ELSE LET g_chr1='3' END IF   #TQC-9B0191
                 CALL q_smy(FALSE,FALSE,g_t1,'APM',g_chr1) RETURNING g_t1  #TQC-670008  #TQC-9B0191
                 LET g_rva.rva01=g_t1         #No.FUN-540027
                 DISPLAY BY NAME g_rva.rva01
                 NEXT FIELD rva01
             WHEN INFIELD(rva02) #查詢採購單號
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_pmm6"     #TQC-C70103 mark
                 LET g_qryparam.form ="q_pmm6_1"   #TQC-C70103 add
                 LET g_qryparam.default1 = g_rva.rva02
                 IF NOT cl_null(g_argv2) THEN
                    LET g_qryparam.where = "pmm02 ='",g_argv2,"' "
                       LET g_qryparam.where = " pmm02 ='",g_argv2,"'"   #No.MOD-890023 add
                 ELSE
                     LET g_qryparam.where = "pmm02 <> 'TAP' AND pmm02 <> 'TRI' AND pmm02 <> 'SUB'" #MOD-4A0146
                 END IF
                 LET g_qryparam.where = g_qryparam.where," AND pmn20 > (pmn50 - pmn55 - pmn58 - (pmn20*pmn13/100))"  #TQC-C70103 add
                 CALL cl_create_qry() RETURNING g_rva.rva02
                DISPLAY BY NAME g_rva.rva02
                NEXT FIELD rva02
             WHEN INFIELD(rva05) #查詢廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_rva.rva05
                 CALL cl_create_qry() RETURNING g_rva.rva05
                DISPLAY BY NAME g_rva.rva05
                CALL t110_rva05('a')
                NEXT FIELD rva05
             WHEN INFIELD(rva111) #付款條件
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pma1"
                 LET g_qryparam.default1 = g_rva.rva111
                 CALL cl_create_qry() RETURNING g_rva.rva111
                 DISPLAY BY NAME g_rva.rva111
                 CALL t110_rva111('a')
                 NEXT FIELD rva111
             WHEN INFIELD(rva112) #價格條件
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pnz1"
                 LET g_qryparam.default1 = g_rva.rva112
                 CALL cl_create_qry() RETURNING g_rva.rva112
                 DISPLAY BY NAME g_rva.rva112
                 CALL t110_rva112('a')
                 NEXT FIELD rva112
             WHEN INFIELD(rva113) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_rva.rva113
                 CALL cl_create_qry() RETURNING g_rva.rva113
                 DISPLAY BY NAME g_rva.rva113
                 CALL t110_rva113('a')
                 NEXT FIELD rva113
             WHEN INFIELD(rva115) #稅別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gec01"
                 LET g_qryparam.default1 = g_rva.rva115
                 CALL cl_create_qry() RETURNING g_rva.rva115
                 DISPLAY BY NAME g_rva.rva115
                 CALL t110_rva115('a')
                 NEXT FIELD rva115
             WHEN INFIELD(rva31)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem_1"
                LET g_qryparam.arg1 = g_rva.rvaplant
                LET g_qryparam.default1 = g_rva.rva31
                CALL cl_create_qry() RETURNING g_rva.rva31
                DISPLAY BY NAME g_rva.rva31
                NEXT FIELD rva31
            #FUN-9C0076 add str ------
             WHEN INFIELD(rva33)  #申請人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_rva.rva33
                 CALL cl_create_qry() RETURNING g_rva.rva33
                 DISPLAY BY NAME g_rva.rva33
                 CALL t110_rva33('a')
                 NEXT FIELD rva33
            #FUN-9C0076 add end -----
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
 
 
    END INPUT
 
END FUNCTION
FUNCTION t110_rva31()
DEFINE l_gem02   LIKE gem_file.gem02
DEFINE l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ''
    SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
       WHERE gem01 = g_rva.rva31 AND gem11 = g_rva.rvaplant
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apm-924'
                                   LET l_gem02 = ''
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                            DISPLAY l_gem02 TO rva31_desc
    END CASE  
   
END FUNCTION
FUNCTION t110_po(p_po,p_cmd)   #採購單號
   DEFINE
      p_po      LIKE rva_file.rva02,
      p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      l_pmm02   LIKE pmm_file.pmm02,
      l_pmm09   LIKE pmm_file.pmm09,
      l_pmm25   LIKE pmm_file.pmm25,
      l_cnt     LIKE type_file.num5,    #MOD-A10105
      l_pmm22_1 LIKE pmm_file.pmm22,    #MOD-AC0260
      l_pmm22_2 LIKE pmm_file.pmm22,    #MOD-AC0260
      l_rvb04   LIKE rvb_file.rvb04     #MOD-AC0260
 
   LET g_errno = " "
   IF NOT cl_null(g_rva.rva02) THEN 
      IF g_rva.rva02 <> p_po THEN
         LET g_errno='apm-940'
         RETURN
      END IF 
   END IF 
 
   SELECT pmm02,pmm09,pmm25,pmm904,pmm50
     INTO l_pmm02,l_pmm09,l_pmm25,g_pmm904,g_pmm50
     FROM pmm_file WHERE pmm01 = p_po
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3332'
         LET l_pmm25 = NULL
      WHEN l_pmm25 !='2'
         LET g_errno = 'mfg3333'
      WHEN p_cmd='b' AND l_pmm09 != g_rva.rva05
         LET g_errno = 'mfg3020'
      WHEN p_cmd='b' AND l_pmm02 != g_rva.rva10
         LET g_errno = 'mfg3332'
      WHEN p_cmd='a' AND g_argv2='SUB' AND l_pmm02 != 'SUB'
         LET g_errno = 'mfg3332'
      WHEN p_cmd='a' AND cl_null(g_argv2) AND l_pmm02 = 'SUB'
         LET g_errno = 'mfg3332'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
 
 
   IF cl_null(g_pmm50) THEN
      LET g_pmm50=' '
   END IF
 
   IF l_pmm02 = 'SUB' THEN
      LET g_rva.rva04='N'
   END IF
 
   IF g_argv2 != 'TAP' THEN
      IF l_pmm02 = 'TAP' THEN
         LET g_errno='apm-016'
      END IF
   END IF
 
   IF g_argv2 != 'TRI' THEN
      IF l_pmm02 = 'TRI' THEN
         LET g_errno='apm-016'
      END IF
   END IF
 
   IF p_cmd = 'a' THEN
      LET g_rva.rva05 = l_pmm09
      LET g_rva.rva10 = l_pmm02
      CALL s_prtype(g_rva.rva10) RETURNING l_str
      DISPLAY BY NAME g_rva.rva05
      DISPLAY BY NAME g_rva.rva10
      #MOD-C50208 add start ------
      IF NOT cl_null(g_rva.rva02) THEN
         SELECT COUNT(*) INTO l_cnt FROM alb_file
          WHERE alb04=g_rva.rva02
         IF l_cnt>0 THEN
            LET g_rva.rva04='Y'
            DISPLAY BY NAME g_rva.rva04
         END IF
      END IF
      #MOD-C50208 add end   ------
   END IF

   #-----MOD-A10105---------
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM pna_file
     WHERE pna01 = p_po 
       AND pna05 = 'N'
   IF l_cnt > 0 THEN
      LET g_errno = 'apm-453'
      RETURN
   END IF
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM pna_file
     WHERE pna01 = p_po
       AND pnaconf = 'N'
       AND pna05 = 'Y'   #MOD-AA0188
   IF l_cnt > 0 THEN
      LET g_errno = 'apm-454'
      RETURN
   END IF
   #-----END MOD-A10105-----

   #-----MOD-AC0260---------
   SELECT pmm22 INTO l_pmm22_1 FROM pmm_file
     WHERE pmm01 = p_po
#FUN-B90101--add--begin--
##&ifdef SLK       #TQC-C20117--mark
   IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add 
      DECLARE rvb04_cur1 CURSOR FOR                             #TQC-C20117--modify
        SELECT rvbslk04 FROM rvbslk_file WHERE rvbslk01 = g_rva.rva01
   ELSE                                                         #TQC-C20117--add
##&else                                                         #TQC-C20117--mark        
#FUN-B90101--add--end--
      DECLARE rvb04_cur CURSOR FOR
        SELECT rvb04 FROM rvb_file WHERE rvb01 = g_rva.rva01
##&endif                                                        #TQC-C20117--mark
##FUN-B90101 add &end
   END IF                                                       #TQC-C20117--add
#TQC-C20117--add--------------begin------------------
   IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN        
      FOREACH rvb04_cur1 INTO l_rvb04
        SELECT pmm22 INTO l_pmm22_2 FROM pmm_file
          WHERE pmm01 = l_rvb04
        IF l_pmm22_1 <> l_pmm22_2 THEN
           CALL cl_err('','apm1053',1)
           EXIT FOREACH
        END IF
      END FOREACH
   ELSE
   #TQC-C20117--add---end----------------------
      FOREACH rvb04_cur INTO l_rvb04
        SELECT pmm22 INTO l_pmm22_2 FROM pmm_file
          WHERE pmm01 = l_rvb04
        IF l_pmm22_1 <> l_pmm22_2 THEN
           CALL cl_err('','apm1053',1)
           EXIT FOREACH
        END IF
      END FOREACH
   END IF         #TQC-C20117--add
   #-----END MOD-AC0260-----
 
END FUNCTION
 
FUNCTION t110_rva05(p_cmd)   #廠商編號
   DEFINE
      p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      l_pmc03   LIKE pmc_file.pmc03,
      l_pmc30   LIKE pmc_file.pmc30,
      l_pmc17   LIKE pmc_file.pmc17,    #FUN-940083
      l_pmc22   LIKE pmc_file.pmc22,    #FUN-940083
      l_pmc47   LIKE pmc_file.pmc47,    #FUN-940083
      l_pmc49   LIKE pmc_file.pmc49,    #FUN-940083
      l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_errno = " "
   SELECT pmc04,pmc03,pmc30,pmcacti,
          pmc17,pmc49,pmc22,pmc47         #FUN-040083 add
     INTO g_pmc04,l_pmc03,l_pmc30,l_pmcacti,
          l_pmc17,l_pmc49,l_pmc22,l_pmc47 #FUN-940083 add
     FROM pmc_file WHERE pmc01 = g_rva.rva05
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3001' LET l_pmc03 = NULL
      WHEN l_pmcacti='N'
         LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
      WHEN l_pmc30 = '2'
         LET g_errno = 'mfg3227'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) AND p_cmd = 'a' THEN                #FUN-B40083   
      IF g_argv6 = '2' THEN
         LET g_rva.rva111 = l_pmc17
         LET g_rva.rva112 = l_pmc49
         LET g_rva.rva113 = l_pmc22
         LET g_rva.rva115 = l_pmc47
         DISPLAY BY NAME g_rva.rva111
         DISPLAY BY NAME g_rva.rva112
         DISPLAY BY NAME g_rva.rva113
         CALL t110_rva113('d') 
         DISPLAY BY NAME g_rva.rva115
         CALL t110_rva115('d') 
      END IF
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
   DISPLAY l_pmc03 TO FORMONLY.pmc03     #No.TQC-B60218
 
END FUNCTION
 
FUNCTION t110_rva111(p_cmd)   #付款條件
   DEFINE
      p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      l_pma02   LIKE pma_file.pma02,    #No.FUN-940083
      l_pmaacti LIKE pma_file.pmaacti
 
   LET g_errno = " "
   SELECT pma02,pmaacti
     INTO l_pma02,l_pmaacti
     FROM pma_file WHERE pma01 = g_rva.rva111
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3099' LET l_pma02 = NULL
      WHEN l_pmaacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pma02 TO FORMONLY.pma02
   END IF
 
END FUNCTION
 
FUNCTION t110_rva112(p_cmd)   #價格條件
   DEFINE
      p_cmd     LIKE type_file.chr1, 
      l_pnz02   LIKE pnz_file.pnz02  
 
   LET g_errno = " "
   SELECT pnz02 
     INTO l_pnz02 
     FROM pnz_file WHERE pnz01 = g_rva.rva112
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg4101' LET l_pnz02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pnz02 TO FORMONLY.pnz02
   END IF
 
END FUNCTION
 
FUNCTION t110_rva113(p_cmd)   #幣別
   DEFINE
      p_cmd     LIKE type_file.chr1, 
      l_rate    LIKE rva_file.rva114,  #匯率
      l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT aziacti
     INTO l_aziacti
     FROM azi_file WHERE azi01 = g_rva.rva113
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3008' LET g_rva.rva114 = NULL
      WHEN l_aziacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF g_rva.rva113 = g_aza.aza17 THEN
         LET g_rva.rva114 = 1
      ELSE
         CALL s_curr3(g_rva.rva113,g_today,g_sma.sma904) RETURNING l_rate
         LET g_rva.rva114 = l_rate
      END IF
      DISPLAY BY NAME g_rva.rva113
      DISPLAY BY NAME g_rva.rva114
   END IF
 
END FUNCTION
 
FUNCTION t110_rva115(p_cmd)   #稅別
   DEFINE
      p_cmd     LIKE type_file.chr1, 
      l_gec04   LIKE gec_file.gec04,
      l_gec011  LIKE gec_file.gec011,
      l_gecacti LIKE gec_file.gecacti
 
   LET g_errno = ""
 
   SELECT gec04,gec011,gecacti INTO l_gec04,l_gec011,l_gecacti 
     FROM gec_file WHERE gec01 = g_rva.rva115 AND gec011 = '1'
     
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3044' LET l_gec04 = NULL
      WHEN l_gecacti='N'
         LET g_errno = '9028'
         LET l_gec04  = NULL
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rva.rva116 = l_gec04
      DISPLAY BY NAME g_rva.rva115
      DISPLAY BY NAME g_rva.rva116
   END IF
 
END FUNCTION
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rva.* TO NULL               #No.FUN-6A0162
 
   CALL cl_opmsg('q')
   CALL cl_msg("")
   CLEAR FORM
   CALL g_rvb.clear()
#FUN-B90101--add--begin--
    IF g_azw.azw04='2' THEN             #TQC-C20117--add
       CALL g_rvbslk.clear()
       CALL g_imx.clear()
    END IF                              #TQC-C20117--add
#FUN-B90101--add--end--

   DISPLAY '   ' TO FORMONLY.cnt
 
   IF g_sma.sma120 = 'Y'  THEN
      LET lg_smy62 = ''
      LET lg_group = ''
      CALL t110_refresh_detail()
   END IF
 
   CALL t110_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rva.* TO NULL
      RETURN
   END IF
 
   CALL cl_msg(" SEARCHING ! ")
 
   OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rva.* TO NULL
   ELSE
      OPEN t110_count
      FETCH t110_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")
 
END FUNCTION
 
FUNCTION t110_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1               #處理方式  #No.FUN-680136 VARCHAR(1)
   DEFINE l_slip   LIKE smy_file.smyslip             #No.FUN-680136 VARCHAR(10)  #TQC-650108
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t110_cs INTO g_rva.rva01
      WHEN 'P' FETCH PREVIOUS t110_cs INTO g_rva.rva01
      WHEN 'F' FETCH FIRST    t110_cs INTO g_rva.rva01
      WHEN 'L' FETCH LAST     t110_cs INTO g_rva.rva01
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
            FETCH ABSOLUTE g_jump t110_cs INTO g_rva.rva01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
      INITIALIZE g_rva.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01 = g_rva.rva01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rva_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1) #No.FUN-660129
      INITIALIZE g_rva.* TO NULL
      RETURN
   END IF
   #在使用Q查詢的情況下得到當前對應的屬性組smy62
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
      LET l_slip = g_rva.rva01[1,g_doc_len]
      SELECT smy62 INTO lg_smy62 FROM smy_file
         WHERE smyslip = l_slip
   END IF
   LET g_data_owner = g_rva.rvauser      #FUN-4C0056 add
   LET g_data_group = g_rva.rvagrup      #FUN-4C0056 add
   LET g_data_plant = g_rva.rvaplant #FUN-980030
   CALL t110_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t110_show()
DEFINE l_gen02     LIKE gen_file.gen02                  #NO.FUN-960130                                                           
DEFINE l_azp02     LIKE azp_file.azp02                  #NO.FUN-960130
DEFINE l_gem02     LIKE gem_file.gem02                  #NO.FUN-960130
 
   LET g_rva_t.* = g_rva.*                #保存單頭舊值
  IF NOT g_argv5 MATCHES '[1V]' THEN      #No.FUN-940083 add by shi
   DISPLAY BY NAME  g_rva.rva01,g_rva.rva05,g_rva.rva06,g_rva.rva02,  
                    g_rva.rvaoriu,g_rva.rvaorig,
                    g_rva.rva99,g_rva.rva10,g_rva.rva04,g_rva.rva21,
                    g_rva.rva08,g_rva.rva09,g_rva.rva34,                    #fun-A50071 add rva34
                    g_rva.rvaconf,g_rva.rvaspc,g_rva.rva117,
                    g_rva.rva33,g_rva.rvamksg,g_rva.rva32,                   #FUN-9C0076 add
                    g_rva.rva111,g_rva.rva112,g_rva.rva115,g_rva.rva116,
                    g_rva.rva113,g_rva.rva114,
                    g_rva.rvauser,g_rva.rvagrup,g_rva.rvacont,               #FUN-A30063 ADD  
                    g_rva.rvamodu,g_rva.rvadate,g_rva.rvaacti
                    ,g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,    #NO.FUN-960130
                    g_rva.rva31,g_rva.rva31                                  #NO.FUN-960130
                    ,g_rva.rvaud01,g_rva.rvaud02,g_rva.rvaud03,g_rva.rvaud04,
                    g_rva.rvaud05,g_rva.rvaud06,g_rva.rvaud07,g_rva.rvaud08,
                    g_rva.rvaud09,g_rva.rvaud10,g_rva.rvaud11,g_rva.rvaud12,
                    g_rva.rvaud13,g_rva.rvaud14,g_rva.rvaud15 
   #CKP
  #FUN-C30140--mod---str---
  #IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
   CALL t110_pic()
  #FUN-C30140--mod---end---
  END IF                                  #No.FUN-940083 add by shi
 
   CALL s_prtype(g_rva.rva10) RETURNING l_str
   IF g_azw.azw04='2' THEN                                                                                                        
      DISPLAY BY NAME g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,                                                          
                      g_rva.rva31,g_rva.rvaplant,g_rva.rvacrat,g_rva.rvacont    #FUN-A30063 ADD                                                                                      
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rva.rvaconu                                                           
      DISPLAY l_gen02 TO FORMONLY.rvaconu_desc                                                                                      
                                                                                                                                    
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva30                                                             
      DISPLAY l_azp02 TO FORMONLY.rva30_desc                                                                                        
                                                                                                                                    
      LET l_azp02 = ''                                                                                                              
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva31                                                             
      DISPLAY l_azp02 TO FORMONLY.rva31_desc                                                                                        
 
      LET l_azp02 = ''                                                                                                              
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rva29                                                             
      DISPLAY l_azp02 TO FORMONLY.rva29_desc                                                                                        
                                                                                                                                    
      LET l_azp02 = ''                                                                                                              
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rva.rvaplant                                                           
      DISPLAY l_azp02 TO FORMONLY.rvaplant_desc  
      SELECT gem02 INTO l_gem02 FROM gem_file  
         WHERE gem01 = g_rva.rva31 
      DISPLAY l_gem02 TO rva31_desc
   END IF                                                                                                                           

   CALL t110_rva05('d')
   CALL t110_rva33('d')                       #FUN-9C0076 add 
   #No.TQC-BB0248  --Begin
   CALL t110_rva111('d')
   CALL t110_rva112('d')
   #No.TQC-BB0248  --End

   IF cl_null(g_wc2) THEN
      LET g_wc2=' 1=1 '
   END IF
 # CALL t110_b_fill(g_wc2)      #FUN-B90101

#FUN-B90101--add--begin
   IF g_azw.azw04='2' THEN             #TQC-C20117--add
      CALL t110_b_fill2(g_wc3,g_wc2)
      CALL t110_b_fill(g_wc2,g_wc3)
#TQC-C20117--add--begin----------------
   ELSE
      CALL t110_b_fill(g_wc2,' 1=1')
   END IF
#TQC-C20117--add--end------------------    
#FUN-B90101--add--end--
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_r()       #刪除
    DEFINE l_chr,l_sure LIKE type_file.chr1,  #No.FUN-680136 VARCHAR(01)
           l_cnt        LIKE type_file.num5,  #No.FUN-680136 SMALLINT
           l_rvb22      LIKE rvb_file.rvb22   #No:7746
    DEFINE li_result    LIKE type_file.num5   #FUN-810038
    DEFINE l_flag       LIKE type_file.chr1   #No.FUN-7B0018
    DEFINE l_i          LIKE type_file.num5   #no.CHI-860008
    DEFINE l_rvb93      LIKE rvb_file.rvb93   #FUN-9C0046
    DEFINE l_ac         LIKE type_file.num5   #FUN-9C0046
    DEFINE l_sql        STRING                #FUN-9C0046
#    DEFINE l_ata03      LIKE ata_file.ata03   #No.FUN-A50054   #FUN-A60035 ---MARK

    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_rva.rva01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
 
    IF g_rva.rvaconf = 'Y' THEN
       CALL cl_err('','apm-242',0)
       RETURN
    END IF
 
    IF g_rva.rvaconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF

   #FUN-9C0076 add str ---
    IF g_rva.rva32 matches '[Ss1]' THEN
       CALL cl_err("","mfg3557",0)
       RETURN
    END IF
   #FUN-9C0076 add end ---
 
    #-->已有入庫單則不可刪除
    SELECT count(*) INTO l_cnt FROM rvu_file
     WHERE rvu02 = g_rva.rva01
       AND rvuconf !='X'
 
    IF l_cnt > 0  THEN
       CALL cl_err(' ','apm-290',0)
       RETURN
    END IF
 
    #-->已有品管單則不可刪除
    SELECT count(*) INTO l_cnt FROM qcs_file
     WHERE qcs01 = g_rva.rva01 AND qcs14!='X'  #No:9524
       AND qcs00<'5'   #No.FUN-5C0078
    IF l_cnt > 0 THEN
       CALL cl_err(' ','apm-291',0)
       RETURN
    END IF
 
    BEGIN WORK
    LET g_success = 'Y'      #No.MOD-890074 add
    LET g_totsuccess = 'Y'   #No.MOD-890074 add
 
    OPEN t110_cl USING g_rva.rva01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t110_cl INTO g_rva.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t110_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rva01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rva.rva01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       LET l_ac = 0
       SELECT COUNT(*) INTO l_ac FROM rvb_file 
        WHERE rvb01 = g_rva.rva01 AND rvb93 IS NOT NULL
       IF l_ac>0  THEN
          IF NOT cl_confirm('apm1026') THEN
             CLOSE t110_cl
             ROLLBACK WORK
             RETURN           
          END IF
          LET l_sql = " SELECT rvb93 FROM rvb_file WHERE rvb01 = '",g_rva.rva01,"' AND rvb93 IS NOT NULL"
          PREPARE e_pre FROM l_sql
          DECLARE e_rvb CURSOR FOR e_pre
          
          FOREACH e_rvb INTO l_rvb93
             IF SQLCA.sqlcode != 0 THEN                                                                                               
                CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                               
                EXIT FOREACH                                                                                                          
             END IF      
             UPDATE wpe_file SET wpe07 = 'N' 
              WHERE wpe01 = l_rvb93
                   
          END FOREACH
       END IF   

       CALL cl_msg("Delete rva,rvb!")
       # 刪除發票資料
       DECLARE rvb22_cur CURSOR FOR
        SELECT UNIQUE rvb22
          FROM rvb_file
         WHERE rvb01 = g_rva.rva01
 
       CALL s_showmsg_init()        #No.FUN-710030
       FOREACH rvb22_cur INTO l_rvb22
          IF g_success="N" THEN
             LET g_totsuccess="N"
             LET g_success="Y"
          END IF
          SELECT COUNT(*) INTO g_cnt
            FROM rvb_file
           WHERE rvb22 = l_rvb22
             AND rvb01 <> g_rva.rva01
          IF g_cnt = 0 THEN
             DELETE FROM rvw_file
              WHERE rvw01 = l_rvb22
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                IF g_bgerr THEN
                   CALL s_errmsg("rvw01",l_rvb22,"DEL rvw_filee err!",SQLCA.sqlcode,1)
                   CONTINUE FOREACH
                ELSE
                   CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.sqlcode,"","DEL rvw_filee err!",1)
                   EXIT FOREACH
                END IF
             END IF
          END IF
       END FOREACH
       IF g_totsuccess="N" THEN
          LET g_success="N"
       END IF
 
       DELETE FROM rva_file WHERE rva01 = g_rva.rva01
       IF SQLCA.SQLERRD[3]=0 THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("rva01",g_rva.rva01,"No rva deleted",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","rva_file",g_rva.rva01,"",SQLCA.SQLCODE,"","No rva deleted",1)
         END IF
       END IF
#FUN-B90101--add--begin--
       IF g_azw.azw04='2' THEN             #TQC-C20117--add
          DELETE FROM rvbslk_file WHERE rvbslk01 = g_rva.rva01
          DELETE FROM rvbi_file WHERE rvbi01 = g_rva.rva01
       END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
 
       DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01
#FUN-A60035 ---MARK BEGIN
#      #FUN-A50054 --Begin
#      IF s_industry('slk') THEN
#         DELETE FROM ata_file WHERE ata00=g_prog AND ata01=g_rva.rva01  #FUN-A50054
#      END IF 
#      #FUN-A50054---end 
#FUN-A60035 ---MARK END
        LET l_flag = s_del_rvbi(g_rva.rva01,'','')
       LET g_msg=TIME
#FUN-A60035 ---MARK BEGIN
#     #No.FUN-A50054 -BEGIN-----
#      IF s_industry('slk') THEN
#         DECLARE t720_ata2 CURSOR FOR
#          SELECT ata03 FROM ata_file
#           WHERE ata00 = g_prog
#             AND ata01 = g_rva.rva01
#         FOREACH t720_ata2 INTO l_ata03
#            IF NOT s_del_rvbs("2",g_rva.rva01,l_ata03,0)  THEN           #FUN-880129
#               ROLLBACK WORK
#               RETURN FALSE
#            END IF
#         END FOREACH
#      ELSE
#     #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
        LET l_cnt  = ARR_COUNT()   #MOD-AA0074 add #MOD-B40006 mod l_ac->l_cnt  
        IF l_cnt > 0 THEN          #MOD-AA0074 add #MOD-B40006 mod l_ac->l_cnt     
           CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
           IF l_ec_sw = 'N' THEN      #CHI-A80024
              FOR l_i = 1 TO g_rec_b 
                 #IF NOT s_del_rvbs("2",g_rva.rva01,g_rvb[l_i].rvb02,0)  THEN      #FUN-880129   #TQC-B90236 mark
                  IF NOT s_lot_del(g_prog,g_rva.rva01,'',0,g_rvb[l_i].rvb05,'DEL') THEN #TQC-B90236 add
                    ROLLBACK WORK
                    RETURN FALSE
                  END IF
              END FOR
           END IF   #CHI-A80024
        END IF    #MOD-AA0074 add
#       END IF #No.FUN-A50054   #FUN-A60035 ---MARK
 
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #NO.FUN-980006 add azoplant,azolegal
                     VALUES('apmt110',g_user,g_today,g_msg,g_rva.rva01,'delete',g_plant,g_legal) #NO.FUN-980006 add azoplant,azolegal
 
       CLEAR FORM
#FUN-B90101--add--begin--
       IF g_azw.azw04='2' THEN             #TQC-C20117--add
          CALL g_rvbslk.clear()
          CALL g_imx.clear()
          LET g_rec_b2 = 0
          LET g_rec_b3 = 0
       END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
       CALL g_rvb.clear()
       LET g_rec_b = 0       #FUN-B90101
       INITIALIZE g_rva.* TO NULL
       CALL cl_msg("")
       OPEN t110_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t110_cs
          CLOSE t110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t110_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t110_cs
          CLOSE t110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
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
    CALL s_showmsg()
    IF g_success= 'N' THEN
       ROLLBACK WORK
       LET g_success = 'Y'
       RETURN
    ELSE
       COMMIT WORK
    END IF
 
    CALL cl_flow_notify(g_rva.rva01,'D')
 
END FUNCTION
 
FUNCTION t110_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
      l_n,l_n1,l_n2   LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
      l_i,l_t         LIKE type_file.num5,                #No.FUN-680136 SMALLINT
      l_cmd           LIKE type_file.chr50,               #字串  #No.FUN-680136 VARCHAR(30)
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
      p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
      l_chr           LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
      l_direct        LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(01)
      l_uflag         LIKE type_file.num5,                #No.FUN-680136 SMALLINT
      l_sfa           RECORD LIKE sfa_file.*,
      l_alb04         LIKE alb_file.alb04,
      l_alb05         LIKE alb_file.alb05,
      l_alb11         LIKE alb_file.alb11,
      l_ale06         LIKE ale_file.ale06,
      l_ale08         LIKE ale_file.ale08,
      l_rvb           RECORD LIKE rvb_file.*,
      l_rvb07         LIKE rvb_file.rvb07,
      l_rvb07_1       LIKE rvb_file.rvb07,
      l_rvb07_2       LIKE rvb_file.rvb07,
      l_rvb07_3       LIKE rvb_file.rvb07,
      l_als05         LIKE als_file.als05,
      l_als21         LIKE als_file.als21,
      l_alt06,t_alt06 LIKE alt_file.alt06,
      l_pmh08         LIKE pmh_file.pmh08,
      g_pmn38         LIKE pmn_file.pmn38,
      g_img07         LIKE img_file.img07,
      g_img10         LIKE img_file.img10,
      g_img09         LIKE img_file.img09,
      g_imf04         LIKE imf_file.imf04,
      g_imf05         LIKE imf_file.imf05,
      l_pmn41         LIKE pmn_file.pmn41,
      l_pmn43         LIKE pmn_file.pmn43,
      l_pmn20         LIKE pmn_file.pmn20,     #No.MOD-830171 
      l_pmn87         LIKE pmn_file.pmn87,     #No.MOD-830171 
     #l_pmm904        LIKE pmm_file.pmm904,    #MOD-CB0079 mark
     #l_pmm50         LIKE pmm_file.pmm50,     #MOD-CB0079 mark
      l_smy57_5       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
      l_pmm04         LIKE pmm_file.pmm04,
     #l_poz011        LIKE poz_file.poz011,    #MOD-CB0079 mark
      l_msg           LIKE type_file.chr50,    #No.FUN-680136 VARCHAR(40)
      l_sfb24         LIKE sfb_file.sfb24,
      l_code          LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_ima491        LIKE ima_file.ima491,
      s_mod,ss        LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      sn1,sn2,l_cnt   LIKE type_file.num5,     #No.FUN-680136 SMALLINT
     #l_num           LIKE type_file.num5,     #No.FUN-680136 SMALLINT   #MOD-CB0079 mark
      l_fac           LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
      li_i            LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_count         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_check_res     LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_temp          LIKE ima_file.ima01,
      l_ima55         LIKE ima_file.ima55,
      l_imaag         LIKE ima_file.imaag,
      l_coc10         LIKE coc_file.coc10,     #No.MOD-4B0275
      l_coc04         LIKE coc_file.coc04,     #No.MOD-4B0275
      l_rvb22_old     LIKE rvb_file.rvb22,
      l_min_set       LIKE sfb_file.sfb08,     #No.TQC-670091 add
      l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-680136 SMALLINT
      l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-680136 SMALLINT
      l_rvb07_s       LIKE rvb_file.rvb07,     #MOD-850298
      l_rvb87_s       LIKE rvb_file.rvb87,     #MOD-850298
      l_agb03a        LIKE agb_file.agb03,    
      l_agb03b        LIKE agb_file.agb03,  
      l_agb03c        LIKE agb_file.agb03,  
      l_imx01         LIKE imx_file.imx01,   
      l_imx02         LIKE imx_file.imx02,  
      l_imx03         LIKE imx_file.imx03,
      l_imx00         LIKE imx_file.imx00,
      l_imx01a        LIKE imx_file.imx01,
      l_imx01b        LIKE imx_file.imx01,
      l_imx02a        LIKE imx_file.imx02,
      l_imx02b        LIKE imx_file.imx02,
      l_imx03a        LIKE imx_file.imx03,
      l_imx03b        LIKE imx_file.imx03,
      l_tpmu00        LIKE type_file.num5,
      l_tpmu03        LIKE pmu_file.pmu03,
      l_tpmu04        LIKE pmu_file.pmu04,
      l_rvb05_cut     LIKE pmu_file.pmu06,
      l_ima150        LIKE ima_file.ima150,
      l_ima151        LIKE ima_file.ima151,
      l_pmu           RECORD LIKE pmu_file.*,
      l_pmu03         LIKE pmu_file.pmu03,
      li_result       LIKE type_file.num5
   DEFINE l_ima159    LIKE ima_file.ima159       #FUN-B50096
   DEFINE l_ima153    LIKE ima_file.ima153       #FUN-910053 
   DEFINE l_pmc915    LIKE pmc_file.pmc915       #FUN-A10001
   DEFINE l_pmc916    LIKE pmc_file.pmc916       #FUN-A10001
   DEFINE l_img09     LIKE img_file.img09        #FUN-940083   
   DEFINE l_smd04     LIKE smd_file.smd04        #FUN-940083   
   DEFINE l_smd06     LIKE smd_file.smd06        #FUN-940083   
   DEFINE l_rvb90_fac LIKE rvb_file.rvb90_fac    #FUN-940083   
   DEFINE l_gem02     LIKE gem_file.gem02        #NO.FUN-960130
   DEFINE l_pmm51     LIKE pmm_file.pmm51        #NO.FUN-960130
   DEFINE l_times     LIKE sma_file.sma134       #NO.FUN-960130
   DEFINE l_pmn14     LIKE pmn_file.pmn14        #NO.FUN-960130
   DEFINE l_bno       LIKE rvbs_file.rvbs08      #CHI-9A0022
   DEFINE l_rva32     LIKE rva_file.rva32        #FUN-9C0076 add
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_ata02     LIKE ata_file.ata02        #No.FUN-A50054
#  DEFINE l_ata03     LIKE ata_file.ata03        #No.FUN-A50054
#  DEFINE l_ata04     LIKE ata_file.ata04        #No.FUN-A50054 
#  DEFINE l_ata05     LIKE ata_file.ata05        #No.FUN-A50054
#  DEFINE l_ata08     LIKE ata_file.ata08        #No.FUN-A50054
#  DEFINE l_ata RECORD LIKE ata_file.*           #No.FUN-A50054
#  DEFINE l_prog      LIKE type_file.chr20       #No.FUN-A50054
#FUN-A60035 ---MARK END
   DEFINE l_ima01     LIKE ima_file.ima01        #FUN-A20017
   DEFINE l_ima903    LIKE ima_file.ima903       #FUN-A20017
   DEFINE l_rvb03_o   LIKE rvb_file.rvb03        #MOD-B30090 add
   DEFINE l_rtz08     LIKE rtz_file.rtz08        #FUN-B40098
   DEFINE l_rtz07     LIKE rtz_file.rtz07        #FUN-B60150 ADD
   DEFINE l_pmn123    LIKE pmn_file.pmn123       #FUN-B40083
   DEFINE l_cnt2      LIKE type_file.num5        #FUN-BB0001 add
#FUN-B90101--add--begin--
  DEFINE l_index      LIKE type_file.num5,
         li_a         LIKE type_file.chr1,
         l_rvbslk03_o LIKE rvbslk_file.rvbslk03,
         l_rvbslk07_s LIKE rvbslk_file.rvbslk07,
         l_rvbslk07_1 LIKE rvbslk_file.rvbslk07,
         l_rvbslk07_2 LIKE rvbslk_file.rvbslk07,
         l_rvbslk07_3 LIKE rvbslk_file.rvbslk07,
         l_rvbslk07   LIKE rvbslk_file.rvbslk07
   DEFINE l_rvb80     LIKE rvb_file.rvb80,
          l_rvb81     LIKE rvb_file.rvb81,
          l_rvb82     LIKE rvb_file.rvb82,
          l_rvb83     LIKE rvb_file.rvb83,
          l_rvb84     LIKE rvb_file.rvb84,
          l_rvb85     LIKE rvb_file.rvb85,
          l_error     LIKE type_file.chr10   #TQC-C20348 add 
#FUN-B90101--add--end--   
  #FUN-C20002--start add---------------------
  DEFINE l_ima154     LIKE ima_file.ima154
  DEFINE l_rcj03      LIKE rcj_file.rcj03
  #FUN-C20002--end add----------------------- 
  DEFINE l_rvb90      LIKE rvb_file.rvb90   #No.FUN-B0086
  DEFINE l_ida        RECORD LIKE ida_file.*  #TQC-C60023
  DEFINE l_sfb05      LIKE sfb_file.sfb05   #FUN-C30166
  DEFINE l_pmn65     LIKE pmn_file.pmn65   #FUN-C30166
  DEFINE l_flag      LIKE type_file.chr1     #MOD-C50224 add
  DEFINE l_fac2      LIKE rvb_file.rvb90_fac #MOD-C50224 add
  DEFINE l_ima25     LIKE ima_file.ima25     #MOD-C50224 add
  DEFINE l_rvb39     LIKE rvb_file.rvb39     #CHI-C80019 add
  DEFINE l_rvv17_sum LIKE rvv_file.rvv17     #MOD-D30263 add

   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rva.rva01) THEN
      RETURN
   END IF
 
   SELECT * INTO g_rva.* FROM rva_file
    WHERE rva01=g_rva.rva01

   LET l_rva32 = g_rva.rva32     #FUN-9C0076 add 

   IF g_rva.rvaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_rva.rva01,'aom-000',0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF

  #FUN-9C0076  add str ---
   IF g_rva.rva32 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
   END IF
   IF g_rva.rvaconf='Y' AND g_rva.rva32 = "1" AND g_rva.rvamksg = "Y"  THEN
      CALL cl_err('','mfg3168',0)
      RETURN
   END IF
  #FUN-9C0076  add end ---
  #MOD-C30248 -- add -- begin
   IF (NOT cl_null(g_rva.rva02)) AND (g_rec_b = 0) THEN
      CALL t110_g_b()
   END IF
  #MOD-C30248 -- add -- end
 
   CALL cl_opmsg('b')

#CHI-B80038 -- begin --
   SELECT gec07 INTO g_gec07 FROM gec_file
      WHERE gec01 = g_rva.rva115
#CHI-B80038 -- end --
 
   LET g_forupd_sql = "SELECT * FROM rvb_file ",
                      " WHERE rvb01=? AND rvb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#FUN-B90101--add--begin--
   LET g_forupd_sql = "SELECT * FROM rvbslk_file ",
                      " WHERE rvbslk01=? AND rvbslk02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_bcl_slk CURSOR FROM g_forupd_sql
#FUN-B90101--add--end--

      LET g_forupd_sql = "SELECT * FROM rvbi_file ",
                         " WHERE rvbi01=? AND rvbi02=? FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE t110_bcl_ind CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac = 1       #MOD-530431
    LET l_ac2 = 1    #FUN-B90101 add
 
#FUN-B90101--add--begin--
IF g_azw.azw04='2' AND g_prog='apmt110_slk' THEN             #TQC-C20117--add
##  DIALOG ATTRIBUTES(UNBUFFERED)                            #TQC-C20117--mark 
  IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF   #TQC-D40025 add
  IF g_rec_b3 > 0 THEN LET l_ac3 = 1 END IF   #TQC-D40025 add
  DIALOG ATTRIBUTES(UNBUFFERED)                              #TQC-C20117--add
   INPUT ARRAY g_rvbslk FROM s_rvbslk.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            LET li_a=FALSE                 #FUN-C60100 add
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET g_b_flag = '1'   #TQC-D40025
 
            #FUN-C80030--mark--str--
            #IF g_sma.sma90 = 'Y' THEN
            #   CALL cl_set_act_visible("modi_lot", TRUE)
            #ELSE
            #   CALL cl_set_act_visible("modi_lot", FALSE)
            #END IF
            #FUN-C80030--mark--end--
 
            #MOD-C90138 -- add start --
            IF g_argv6 = '2' THEN
               CALL cl_set_act_visible("sel_from_procure,fast_receiving", FALSE)
            ELSE
               CALL cl_set_act_visible("sel_from_procure,fast_receiving", TRUE)
            END IF
            #MOD-C90138 -- add end --

            LET g_before_input_done = FALSE
            CALL t110_set_entry_b('a')
     #      CALL t110_set_no_entry_b('a')      #TQC-C20117--mark
            CALL t110_set_no_entry_bslk('a')   #TQC-C20117--add
            LET g_before_input_done = TRUE
 
         BEFORE ROW
            
            INITIALIZE g_rvbslk2.* TO NULL #MOD-550195
            LET p_cmd = ''
            LET l_ac2 = ARR_CURR()
            LET l_n  = ARR_COUNT()
            CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
            CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
                               g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
            LET g_rec_b3 = g_imx.getLength()
            LET l_lock_sw = 'N'            #DEFAULT
 
           #BEGIN WORK
           #LET g_success = 'Y'
           #OPEN t110_cl USING g_rva.rva01
           #IF STATUS THEN
           #   CALL cl_err("OPEN t110_cl:", STATUS, 1)
           #   CLOSE t110_cl
           #   ROLLBACK WORK
           #   RETURN
           #END IF
           #FETCH t110_cl INTO g_rva.*  #鎖住將被更改或取消的資料
           #IF SQLCA.sqlcode THEN
           #   CALL cl_err("fetch t110_cl_b",SQLCA.sqlcode,0)      #資料被他人LOCK
           #   CLOSE t110_cl
           #   ROLLBACK WORK
           #   RETURN
           #END IF
            IF g_rec_b2 >= l_ac2 THEN
               LET p_cmd='u'
               LET g_rvbslk_t.* = g_rvbslk[l_ac2].*  #BACKUP

               BEGIN WORK
               LET g_success = 'Y'
               OPEN t110_cl USING g_rva.rva01
               IF STATUS THEN
                  CALL cl_err("OPEN t110_cl:", STATUS, 1)
                  CLOSE t110_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t110_cl INTO g_rva.*  #鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err("fetch t110_cl_b",SQLCA.sqlcode,0)      #資料被他人LOCK
                  CLOSE t110_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               OPEN t110_bcl_slk USING g_rva.rva01,g_rvbslk_t.rvbslk02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_bcl_slk:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t110_bcl_slk INTO g_rvbslk2.* 
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_rvbslk_t.rvbslk02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
         #           CALL t110_b_move_to()           #TQC-C20117--mark 
                     CALL t110_b_move_toslk()        #TQC-C20117--add
                     SELECT ima02,ima021 INTO  g_rvbslk[l_ac2].rvbslk051,g_rvbslk[l_ac2].ima021a FROM ima_file  
                         WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     CALL t110_set_rvb930(g_rvbslk[l_ac2].rvbslk930) RETURNING g_rvbslk[l_ac2].gem02 
                    #LET g_rvbslk05_t = g_rvbslk[l_ac2].rvbslk05
                    #IF g_argv6 = '1' THEN    
                    #   CALL t110_rvbslk03('d',g_rvbslk[l_ac2].rvbslk04,g_rvbslk[l_ac2].rvbslk03)
                    #END IF                   
                    #LET g_rvbslk[l_ac2].rvbslk05 = g_rvbslk05_t                     
                     SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     IF l_ima151 = 'Y' THEN
                        CALL cl_set_comp_entry("rvbslk07",FALSE)
                     ELSE
                        CALL cl_set_comp_entry("rvbslk07",TRUE)
                     END IF
                     IF g_argv2 = 'SUB' AND NOT cl_null(g_rvbslk[l_ac2].rvbslk05) 
                        AND NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN  
                        SELECT pmn04,ima903 INTO l_ima01,l_ima903
                          FROM ima_file,pmn_file
                         WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
                           AND pmn02 = g_rvbslk[l_ac2].rvbslk03
                           AND ima01 = pmn04
                        IF g_rvbslk[l_ac2].rvbslk05 <> l_ima01 THEN
                           SELECT ima02,ima021 INTO  g_rvbslk[l_ac2].rvbslk051,g_rvbslk[l_ac2].ima021a FROM ima_file  #No.FUN-810016
                            WHERE ima01 = g_rvbslk[l_ac2].rvbslk05                                            #No.FUN-810016
                        END IF
                     END IF
                     LET g_before_input_done = FALSE
                     CALL t110_set_entry_b(p_cmd)
#                    CALL t110_set_no_entry_b(p_cmd)     #TQC-C20117--mark
                     CALL t110_set_no_entry_bslk(p_cmd)  #TQC-C20117--add
                     CALL t110_set_no_required_1()   
                     CALL t110_set_required_1(p_cmd) 
                     CALL t110_set_entry_rvb38()   
                     CALL t110_set_no_entry_rvb38() 
                     LET g_before_input_done = TRUE
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
         BEFORE INSERT
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM rvbslk_file WHERE rvbslk01=g_rva.rva01
            IF g_cnt = g_sma.sma110 THEN
               CALL cl_err('','axm-156',0)
               CANCEL INSERT
            END IF
            LET l_n = ARR_COUNT()
            LET p_cmd='a'

            BEGIN WORK
            LET g_success = 'Y'
            OPEN t110_cl USING g_rva.rva01
            IF STATUS THEN
               CALL cl_err("OPEN t110_cl:", STATUS, 1)
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t110_cl INTO g_rva.*  #鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err("fetch t110_cl_b",SQLCA.sqlcode,0)      #資料被他人LOCK
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            END IF
            INITIALIZE g_rvbslk[l_ac2].* TO NULL     
            LET g_rvbslk[l_ac2].rvbslk04 = g_rva.rva02   #Body default
            LET g_rvbslk[l_ac2].rvbslk07  = 0
            LET g_rvbslk[l_ac2].rvbslk29  = 0     #退補量
            LET g_rvbslk[l_ac2].rvbslk30  = 0     #入庫量
            LET g_rvbslk[l_ac2].rvbslk42  = '4'
            LET g_rvbslk2.rvbslkplant = g_rva.rvaplant  
            LET g_rvbslk2.rvbslklegal = g_rva.rvalegal 
            LET g_rvbslk05_t = NULL
            CALL t110_set_entry_b(p_cmd)     
#           CALL t110_set_no_entry_b(p_cmd)	#TQC-C20117--mark
            CALL t110_set_no_entry_bslk(p_cmd)  #TQC-C20117--add 
            CALL t110_set_entry_rvb38()   
            CALL t110_set_no_entry_rvb38()
            LET g_rvbslk_t.* = g_rvbslk[l_ac2].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD rvbslk02 
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_rvbslk[l_ac2].rvbslk05)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD rvbslk05
               END IF
 
               CALL s_chk_va_setting1(g_rvbslk[l_ac2].rvbslk05)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD rvbslk05
               END IF
 
             # CALL t110_set_origin_field()
            END IF
         #  # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
         #  LET l_ec_sw = 'N'
         #  IF g_argv2 ='SUB' THEN
         #     LET l_sfb24=''
         #     SELECT sfb24 INTO l_sfb24
         #      FROM sfb_file
         #      WHERE sfb01 = g_rvbslk[l_ac2].rvbslk34
         #     IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
         #        LET l_ec_sw='Y'
         #     END IF
         #     IF l_ec_sw='Y' THEN
         #        LET g_rvbslk[l_ac2].rvbslk36=' '
         #        LET g_rvbslk[l_ac2].rvbslk37=' '
         #        LET g_rvbslk[l_ac2].rvbslk38=' '
         #     END IF
         #  END IF
           #CALL t110_b_move_back()       #TQC-C20117--mark
            CALL t110_b_move_backslk()    #TQC-C20117--add
            IF cl_null(g_rvbslk[l_ac2].rvbslk10) THEN
               LET g_rvbslk[l_ac2].rvbslk10 = 0
            END IF
            LET g_rvbslk2.rvbslk10 = g_rvbslk[l_ac2].rvbslk10
            IF cl_null(g_rvbslk[l_ac2].rvbslk10t) THEN LET g_rvbslk[l_ac2].rvbslk10t = 0 END IF
            LET g_rvbslk2.rvbslk10t = g_rvbslk[l_ac2].rvbslk10t
            LET g_rvbslk2.rvbslk36 = g_rvbslk[l_ac2].rvbslk36
            LET g_rvbslk2.rvbslk37 = g_rvbslk[l_ac2].rvbslk37
            LET g_rvbslk2.rvbslk38 = g_rvbslk[l_ac2].rvbslk38
            LET g_rvbslk2.rvbslk930= g_rvbslk[l_ac2].rvbslk930  
            LET g_rvbslk2.rvbslk051= g_rvbslk[l_ac2].rvbslk051  
            LET g_rvbslk2.rvbslk90 = g_rvbslk[l_ac2].rvbslk90   
            SELECT ima491 INTO l_ima491 FROM ima_file
             WHERE ima01 = g_rvbslk2.rvbslk05
            IF cl_null(l_ima491) THEN
               LET l_ima491 = 0
            END IF
            IF l_ima491 > 0 THEN
               CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb_slk.rvb12
            END IF
   
            LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)        #MOD-AC0024
            LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04) 
 
            IF g_rvbslk2.rvbslk36 IS NULL THEN LET g_rvbslk2.rvbslk36=' ' END IF
            IF g_rvbslk2.rvbslk37 IS NULL THEN LET g_rvbslk2.rvbslk37=' ' END IF
            IF g_rvbslk2.rvbslk38 IS NULL THEN LET g_rvbslk2.rvbslk38=' ' END IF
           #CALL t110_chk_rvb36()   #MOD-C20091 mark
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rvbslk2.rvbslk36,g_errno,1)   #MOD-BA0030
               NEXT FIELD rvbslk36
            END IF
            LET g_rvbslk2.rvbslkplant=g_rva.rvaplant 
            LET g_rvbslk2.rvbslklegal=g_rva.rvalegal 
            LET g_rvbslk2.rvbslkplant = g_plant 
            LET g_rvbslk2.rvbslklegal = g_legal 
            INSERT INTO rvbslk_file VALUES (g_rvbslk2.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvbslk_file",g_rvbslk2.rvbslk01,g_rvbslk2.rvbslk02,SQLCA.sqlcode,"","",1) #No.FUN-660129
               CANCEL INSERT
               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF l_ec_sw = 'N' THEN      #CHI-A80024
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                      #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add
                          CALL cl_err3("del","rvbslks_file",g_rva.rva01,g_rvbslk_t.rvbslk02,
                                        SQLCA.sqlcode,"","",1)
                       END IF
                     END IF
                  END IF
               END IF   
            ELSE
               IF cl_null(g_rvbslk[l_ac2].rvbslk04) AND cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
                  SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                  IF l_ima151 = 'N' THEN        #非子、母料件
                     LET g_rvb_slk.rvb01 = g_rva.rva01
                     SELECT MAX(rvb02) INTO l_n FROM rvb_file WHERE rvb01 = g_rva.rva01
                     IF cl_null(l_n) THEN
                        LET l_n = 0
                     END IF
                     LET g_rvb_slk.rvb02 = l_n + 1
                     LET g_rvb_slk.rvb05 = g_rvbslk[l_ac2].rvbslk05
                     LET g_rvb_slk.rvb051= g_rvbslk[l_ac2].rvbslk051
                     CALL t110_rvbslk_move()
                     INSERT INTO rvb_file VALUES(g_rvb_slk.*)
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("ins","rvb_file",g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                     ELSE
                        LET g_rvbi.rvbi01 = g_rva.rva01
                        LET g_rvbi.rvbi02 = g_rvb_slk.rvb02
                        LET g_rvbi.rvbislk01 = g_rvbslk[l_ac2].rvbslk05
                        LET g_rvbi.rvbislk02 = g_rvbslk[l_ac2].rvbslk02
                        LET g_rvbi.rvbiplant = g_plant
                        LET g_rvbi.rvbilegal = g_legal
                        INSERT INTO rvbi_file VALUES(g_rvbi.*)
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("ins","rvbi_file",g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,SQLCA.sqlcode,"","",1)
                           CANCEL INSERT
                        END IF
                     END IF
                  END IF
               END IF   
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn2

               IF g_sma.sma115 = 'Y' THEN
                  LET l_rvb80 = g_rvbslk[l_ac2].rvbslk90
                  LET l_rvb82 = g_rvbslk[l_ac2].rvbslk07
                  LET l_rvb83 = g_rvbslk[l_ac2].rvbslk90
                  LET l_rvb85 = g_rvbslk[l_ac2].rvbslk07
               ELSE
                  LET l_rvb80 = NULL
                  LET l_rvb81 = NULL
                  LET l_rvb82 = NULL
                  LET l_rvb83 = NULL
                  LET l_rvb84 = NULL
                  LET l_rvb85 = NULL
               END IF
               SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
               IF l_ima151 = 'N' THEN        #非子、母料件
                  UPDATE rvb_file SET rvb07 = g_rvbslk[l_ac2].rvbslk07,
                                      rvb36 = g_rvbslk[l_ac2].rvbslk36,
                                      rvb37 = g_rvbslk[l_ac2].rvbslk37,
                                      rvb38 = g_rvbslk[l_ac2].rvbslk38,
                                      rvb80 = l_rvb80,
                                      rvb81 = l_rvb81,
                                      rvb82 = l_rvb82,
                                      rvb83 = l_rvb83,
                                      rvb84 = l_rvb84,
                                      rvb85 = l_rvb85,
                                      rvb87 = g_rvbslk[l_ac2].rvbslk07,
                                      rvb86 = g_rvbslk[l_ac2].rvbslk90,
                                      rvb930= g_rvbslk[l_ac2].rvbslk930,
                                      rvb90 = g_rvbslk[l_ac2].rvbslk90,
                                      rvb42 = g_rvbslk[l_ac2].rvbslk42,
                                      rvb43 = g_rvbslk[l_ac2].rvbslk43
                        WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                            AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                           WHERE rvb01 = rvbi01
                                                             AND rvb02 = rvbi02
                                                             AND rvbi01= g_rva.rva01
                                                             AND rvbislk02=g_rvbslk[l_ac2].rvbslk02 )
               ELSE
                  UPDATE rvb_file SET rvb36 = g_rvbslk[l_ac2].rvbslk36, 
                                      rvb37 = g_rvbslk[l_ac2].rvbslk37,
                                      rvb38 = g_rvbslk[l_ac2].rvbslk38,
                                      rvb80 = l_rvb80,
                                      rvb83 = l_rvb83,
                                      rvb86 = g_rvbslk[l_ac2].rvbslk90,
                                      rvb930= g_rvbslk[l_ac2].rvbslk930,
                                      rvb90 = g_rvbslk[l_ac2].rvbslk90,
                                      rvb42 = g_rvbslk[l_ac2].rvbslk42,
                                      rvb43 = g_rvbslk[l_ac2].rvbslk43
                        WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                            AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                           WHERE rvb01 = rvbi01
                                                             AND rvb02 = rvbi02
                                                             AND rvbi01= g_rva.rva01
                                                             AND rvbislk02=g_rvbslk[l_ac2].rvbslk02 )
               END IF
            END IF
            
         BEFORE FIELD rvbslk02                        #default 序號
            IF cl_null(g_rvbslk[l_ac2].rvbslk02) OR g_rvbslk[l_ac2].rvbslk02 = 0 THEN
               SELECT max(rvbslk02)+1
                 INTO g_rvbslk[l_ac2].rvbslk02
                 FROM rvbslk_file
                WHERE rvbslk01 = g_rva.rva01
               IF g_rvbslk[l_ac2].rvbslk02 IS NULL THEN
                  LET g_rvbslk[l_ac2].rvbslk02 = 1
               END IF
            END IF
 
         AFTER FIELD rvbslk02                        #check 序號是否重複
            IF g_rvbslk[l_ac2].rvbslk02 != g_rvbslk_t.rvbslk02 OR g_rvbslk_t.rvbslk02 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM rvbslk_file
                WHERE rvbslk01 = g_rva.rva01
                  AND rvbslk02 = g_rvbslk[l_ac2].rvbslk02
               IF g_cnt > 0 THEN     
                  CALL cl_err('',-239,0)
                  LET g_rvbslk[l_ac2].rvbslk02 = g_rvbslk_t.rvbslk02
                  NEXT FIELD rvbslk02
               END IF
            END IF
            LET l_direct = 'D'
            NEXT FIELD rvbslk04  #TQC-C40197---ADD---
 
         AFTER FIELD rvbslk05
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
               IF NOT s_chk_item_no(g_rvbslk[l_ac2].rvbslk05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rvbslk[l_ac2].rvbslk05= g_rvbslk_t.rvbslk05
                  NEXT FIELD rvbslk05
               END IF
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
               IF l_ima151 = 'Y' THEN
                  CALL cl_set_comp_entry("rvbslk07",FALSE)
               ELSE
                  CALL cl_set_comp_entry("rvbslk07",TRUE)       
               END IF
            END IF
            SELECT pmn04,ima903 INTO l_ima01,l_ima903
              FROM ima_file,pmn_file
             WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
               AND pmn02 = g_rvbslk[l_ac2].rvbslk03
               AND ima01 = pmn04
            IF g_argv2 = 'SUB' AND NOT cl_null(g_rvbslk[l_ac2].rvbslk05) 
               AND NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN  
               IF g_rvbslk[l_ac2].rvbslk05 <> l_ima01 THEN
                  IF l_ima903 = 'N' OR cl_null(l_ima903) THEN
                     NEXT FIELD rvbslk05
                  ELSE
                     LET g_cnt = 0
                     SELECT COUNT(*) INTO g_cnt FROM bmm_file
                      WHERE bmm01 = l_ima01 AND bmm03 = g_rvbslk[l_ac2].rvbslk05
                        AND bmm05 = 'Y'
                     IF g_cnt = 0 OR cl_null(g_cnt) THEN
                        CALL cl_err('','abm-625',0)
                        NEXT FIELD rvbslk05
                     ELSE
                        SELECT ima02,ima021 INTO g_rvbslk[l_ac2].rvbslk051,g_rvbslk[l_ac2].ima021a FROM ima_file
                         WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     END IF
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN    
               LET l_n = 0  
              #FUN-C20006 mark 
              #SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rvbslk[l_ac2].rvbslk05
              #                                          AND imaacti='Y'
              #                                          AND ( ima151 != 'N' OR imaag <> '@CHILD' )   
              #IF l_n = 0 THEN 
              #   CALL cl_err('','-0811',0)
              #   LET g_rvbslk[l_ac2].rvbslk05 = g_rvbslk_t.rvbslk05
              #   NEXT FIELD rvbslk05 
              #END IF 
              #FUN-C20006 mark
              #FUN-C20006--add--begin--
               SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rvbslk[l_ac2].rvbslk05
                                                        AND ima1010='1' and imaacti='Y'
               IF l_n=0 THEN
                  CALL cl_err('','100',0)
                  LET g_rvbslk[l_ac2].rvbslk05=g_rvbslk_t.rvbslk05
                  NEXT FIELD rvbslk05
               END IF
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file
                WHERE ima01=g_rvbslk[l_ac2].rvbslk05 AND imaacti='Y'
               IF l_ima151='N' AND l_imaag='@CHILD' THEN
                  CALL cl_err('','axm1104',0)
                  NEXT FIELD rvbslk05
               END IF
              #FUN-C20006--add--end--
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM ima_file
                 WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                   AND imaacti='Y'  
               IF l_n = 0 THEN 
                  CALL cl_err('','axm-890',0)
                  LET g_rvbslk[l_ac2].rvbslk05 = g_rvbslk_t.rvbslk05
                  NEXT FIELD rvbslk05 
               END IF
               IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM pmnslk_file WHERE pmnslk01 = g_rvbslk[l_ac2].rvbslk04
                                                              AND pmnslk04 = g_rvbslk[l_ac2].rvbslk05
                  IF l_n = 0 THEN
                     CALL cl_err(g_rvbslk[l_ac2].rvbslk05,'mfg-116',0)
                     NEXT FIELD rvbslk05
                  END IF     
               END IF   
               SELECT ima02,ima021 INTO g_rvbslk[l_ac2].rvbslk051,g_rvbslk[l_ac2].ima021a FROM ima_file
                         WHERE ima01 = g_rvbslk[l_ac2].rvbslk05     
               CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
               CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
                                   g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
               LET g_rec_b3 = g_imx.getLength()
            END IF    
            
         BEFORE FIELD rvbslk051 
            IF g_rvbslk[l_ac2].rvbslk05[1,4]='MISC'  THEN
               CALL t110_set_entry_b(p_cmd)
 #             CALL t110_set_no_entry_b(p_cmd)     #TQC-C20117--mark
               CALL t110_set_no_entry_bslk(p_cmd)  #TQC-C20117--add
               CALL t110_set_entry_rvb38()      #FUN-B50096
               CALL t110_set_no_entry_rvb38()   #FUN-B50096
            END IF
 
         BEFORE FIELD rvbslk90
            CALL t110_set_entry_b(p_cmd)
#           CALL t110_set_no_entry_b(p_cmd)     #TQC-C20117--mark
            CALL t110_set_no_entry_bslk(p_cmd)  #TQC-C20117--add
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
 
         AFTER FIELD rvbslk90
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk90) THEN
               CALL t110_rvb90('d')  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvbslk[l_ac2].rvbslk90,g_errno,0)
                  DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk90
                  NEXT FIELD rvbslk90
               END IF
            END IF
  
         BEFORE FIELD rvbslk04     #採購單號
           CALL t110_set_entry_b('s')  #TQC-7C0131
           CALL t110_set_entry_rvb38()      #FUN-B50096
           CALL t110_set_no_entry_rvb38()   #FUN-B50096
         AFTER FIELD rvbslk04     #採購單號
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
               IF cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
                  CALL cl_err('','-1124',0)
                  NEXT FIELD rvbslk04
               END IF
            END IF 
           #MOD-CB0079 -- mark start #程式段搬移為獨立function(t110_chk_rvbslk04)--
           #IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
           #   IF g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR g_rvbslk_t.rvbslk04 IS NULL THEN     
           #      CALL t110_po(g_rvbslk[l_ac2].rvbslk04,'b')
           #      IF NOT cl_null(g_errno) THEN
           #         CALL cl_err(g_rvbslk[l_ac2].rvbslk04,g_errno,0)
           #         LET g_rvbslk[l_ac2].rvbslk04 = g_rvbslk_t.rvbslk04   #MOD-C30434 -- add
           #         NEXT FIELD rvbslk04
           #      END IF
           #      IF g_azw.azw04='2' THEN
           #         SELECT pmm51 INTO l_pmm51 FROM pmm_file 
           #              WHERE pmm01 = g_rvbslk[l_ac2].rvbslk04
           #         IF l_pmm51 != g_rva.rva29 THEN
           #            CALL cl_err('','apm-925',0)
           #            NEXT FIELD rvbslk04
           #         END IF     
           #      END IF
           #   END IF   
           #   IF p_cmd = 'a' OR (p_cmd ='u' AND
           #                  (g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR
           #                   g_rvbslk[l_ac2].rvbslk03 != g_rvbslk_t.rvbslk03) AND
           #             NOT cl_null(g_rvbslk[l_ac2].rvbslk03)) THEN
           #      IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN              #No.FUN-810016     
           #         SELECT COUNT(*) INTO l_n1  #非本收货单上数量
           #          FROM rvbslk_file,rva_file
           #         WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
           #           AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
           #           AND rva01 = rvbslk01
           #           AND rva01 != g_rva.rva01
           #           AND rvaconf <> 'X'
           #         SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
           #            FROM rvbslk_file,rva_file
           #           WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
           #             AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
           #             AND rva01 = rvbslk01
           #             AND rva01 = g_rva.rva01
           #             AND rvbslk02 != g_rvbslk[l_ac2].rvbslk02
           #             AND rvaconf <> 'X'
           #         LET l_n = l_n1 + l_n2

           #         SELECT sma134 INTO l_times FROM sma_file
           #         IF l_n >= l_times THEN
           #            CALL cl_err('','apm-932',0)
           #            NEXT FIELD rvbslk04
           #         END IF
           #         CALL t110_rvbslk03('a',g_rvbslk[l_ac2].rvbslk04,g_rvbslk[l_ac2].rvbslk03)    #TQC-C20117--add
           #         IF g_rvbslk[l_ac2].rvbslk07 < 0 THEN
           #            IF NOT cl_confirm('mfg3353') THEN
           #               LET g_rvbslk[l_ac2].rvbslk04 = g_rvbslk_t.rvbslk04
           #               NEXT FIELD rvbslk04
           #            END IF
           #         END IF
           #         CALL t110_ins_rvb_b()
           #         IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
           #            SELECT ima021 INTO g_rvbslk[l_ac2].ima021a FROM ima_file
           #               WHERE ima01 = g_rvbslk[l_ac2].rvbslk05     
           #            CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
           #            CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
           #                               g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
           #            LET g_rec_b3 = g_imx.getLength()
           #            SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
           #            IF l_ima151 = 'Y' THEN
           #               CALL cl_set_comp_entry("rvbslk07",FALSE)
           #            ELSE
           #               CALL cl_set_comp_entry("rvbslk07",TRUE)
           #            END IF
           #            SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
           #            DISPLAY l_count TO FORMONLY.qty
           #         END IF
           #      END IF                                              #No.FUN-810016   
           #     #IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
           #     #LET g_rvbslk2.rvbslk10 = g_pmn31
           #     #LET g_rvbslk[l_ac2].rvbslk10 = g_pmn31
           #     #DISPLAY g_rvbslk[l_ac2].rvbslk10 TO rvbslk10
           #     #LET g_rvbslk2.rvbslk10t = g_pmn31t
           #     #LET g_rvbslk[l_ac2].rvbslk10t = g_pmn31t
           #     #DISPLAY g_rvbslk[l_ac2].rvbslk10t TO rvbslk10t
           #     #IF NOT cl_null(g_errno) THEN
           #     #   IF g_errno = 'mfg0159' THEN
           #     #      NEXT FIELD rvbslk04
           #     #   ELSE
           #     #      CALL cl_err(g_rvbslk[l_ac2].rvbslk04,g_errno,0)
           #     #      NEXT FIELD rvbslk04
           #     #   END IF
           #     #END IF
           #      #不能部份交貨且已有交貨量則不允許通過
           #      IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
           #         CALL cl_err('','mfg3339',0)
           #         NEXT FIELD rvbslk04
           #      END IF
           #    # #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
           #    # IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) AND NOT cl_null(g_rvbslk[l_ac2].rvbslk04)  THEN   #No.MOD-840575 
           #    #  IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
           #    #    SELECT * FROM alt_file
           #    #     WHERE alt01=g_rvbslk[l_ac2].rvbslk22
           #    #       AND alt14=g_rvbslk[l_ac2].rvbslk04
           #    #       AND alt15=g_rvbslk[l_ac2].rvbslk03
           #    #    IF SQLCA.sqlcode=100 THEN
           #    #       CALL cl_err3("sel","alt_file",g_rvbslk[l_ac2].rvbslk22,"","apm-304","","",1) #No.FUN-660129
           #    #       LET g_rvbslk[l_ac2].rvbslk04= g_rvbslk_t.rvbslk04            #No.MOD-840575 
           #    #       NEXT FIELD rvbslk04                               #No.MOD-840575 
           #    #     END IF
           #    #  END IF
           #    # END IF  #No.MOD-840575 
           #    #IF g_azw.azw04='2' THEN
           #    #   SELECT pmn14 INTO l_pmn14 FROM pmn_file 
           #    #       WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
           #    #         AND pmn02 = g_rvbslk[l_ac2].rvbslk03
           #    #   IF l_pmn14 = 'Y' THEN
           #    #      SELECT COUNT(*) INTO l_n1  #非本收货单上数量
           #    #         FROM rvbslk_file,rva_file 
           #    #        WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
           #    #          AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03 
           #    #          AND rva01 = rvbslk01
           #    #          AND rva01 != g_rva.rva01
           #    #          AND rvaconf <> 'X'
           #    #      SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
           #    #         FROM rvbslk_file,rva_file 
           #    #        WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
           #    #          AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03 
           #    #          AND rva01 = rvbslk01
           #    #          AND rva01 = g_rva.rva01
           #    #          AND rvbslk02 != g_rvbslk[l_ac2].rvbslk02
           #    #          AND rvaconf <> 'X'
           #    #      LET l_n = l_n1 + l_n2
           #    #      SELECT sma134 INTO l_times FROM sma_file
           #    #      IF l_times IS NULL THEN LET l_times = 0 END IF
           #    #      #收貨次數是否已經超過參數設定的總次數
           #    #      IF l_n >= l_times THEN
           #    #         CALL cl_err('','apm-932',0)
           #    #         NEXT FIELD rvbslk04
           #    #      END IF
           #    #   END IF
           #    #   CALL t110_get_price()
           #    # END IF
           #   END IF
           #   ###### 避免三角收貨到一般採購或逆拋三角
           #   IF g_argv2 = 'TAP' THEN
           #      SELECT poz011 INTO l_poz011
           #        FROM pmm_file,poz_file
           #       WHERE pmm904 = poz01
           #         AND pmm01 = g_rvbslk[l_ac2].rvbslk04
           #         AND pmm901 = 'Y'         #三角貿易否
           #         AND pmm905 = 'Y'         #已拋轉
           #         AND pmm02  = 'TAP'       #代採買性質
           #         AND pmm906 = 'Y'         #來源單據
           #      IF SQLCA.sqlcode THEN
           #         LET l_poz011 = ''
           #      END IF
           #      IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
           #         CALL cl_err(g_rva.rva02,'apm-014',0)
           #         NEXT FIELD rvbslk04  #No.9525
           #      END IF
           #      #----- 必須同一流程代碼 ----
           #      LET l_num =0
           #      DECLARE t110_chk2 CURSOR FOR
           #          SELECT pmm904 , pmm50
           #            FROM rvbslk_file,pmm_file
           #           WHERE rvbslk04 = pmm01
           #             AND rvbslk01 = g_rva.rva01
           #      FOREACH t110_chk2 INTO l_pmm904,l_pmm50
           #         IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
           #         LET l_num = l_num+1
           #         IF NOT cl_null(l_pmm904) THEN
           #            EXIT FOREACH
           #         END IF
           #      END FOREACH
           #      IF cl_null(l_pmm50) THEN LET l_pmm50=' ' END IF  #MOD-850093 add
           #      IF l_pmm904 <> g_pmm904 AND l_num > 0 THEN
           #         CALL cl_err('','axm-501',0)
           #         NEXT FIELD rvbslk04
           #      END IF
           #      IF l_pmm50  <> g_pmm50 AND l_num > 0 THEN #no.6113
           #         CALL cl_err('','apm-993',0)
           #         NEXT FIELD rvbslk04
           #      END IF
           #    END IF
           #END IF   
           #MOD-CB0079 -- mark end --
           #MOD-CB0079 -- add start --
            IF NOT t110_chk_rvbslk04(p_cmd) THEN
               NEXT FIELD rvbslk04
            END IF
           #MOD-CB0079 -- add end --
         #   CALL t110_set_no_entry_b('s')	#MOD-980043    #TQC-C20117--mark
             CALL t110_set_no_entry_bslk('s')                  #TQC-C20117--add
            CALL t110_set_entry_rvb38()         #FUN-B50096
            CALL t110_set_no_entry_rvb38()      #FUN-B50096
 
         BEFORE FIELD rvbslk03     #採購項次
            LET l_rvbslk03_o = g_rvbslk[l_ac2].rvbslk03   #MOD-B80084 add
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
 
         AFTER FIELD rvbslk03     #採購項次
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
               IF cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
                  CALL cl_err('','-1124',0)
                  NEXT FIELD rvbslk03
               END IF
            END IF
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
               #本段改為下面那段==>因為當有單頭無單身,此時按單身,則p_cmd='',則下面判斷式一定不會成立
               #IF p_cmd = 'a' OR (p_cmd ='u' AND
               #                  (g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR
               #                   g_rvbslk[l_ac2].rvbslk03 != g_rvbslk_t.rvbslk03)) THEN
               IF (g_rvbslk_t.rvbslk03 IS NULL) OR (g_rvbslk_t.rvbslk04 IS NULL) OR
                  (g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR
                   g_rvbslk[l_ac2].rvbslk03 != g_rvbslk_t.rvbslk03) OR #MOD-B30090 THEN->OR
                   l_rvbslk03_o != g_rvbslk_t.rvbslk03 THEN #MOD-B30090 add
                 #IF g_azw.azw04='2' THEN
                 #   SELECT pmn14 INTO l_pmn14 FROM pmn_file 
                 #       WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
                 #         AND pmn02 = g_rvbslk[l_ac2].rvbslk03
                 #   IF l_pmn14 = 'Y' THEN
                        SELECT COUNT(*) INTO l_n1  #非本收货单上数量
                           FROM rvbslk_file,rva_file
                          WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
                            AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
                            AND rva01 = rvbslk01
                            AND rva01 != g_rva.rva01
                            AND rvaconf <> 'X'
                        SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
                           FROM rvbslk_file,rva_file
                          WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
                            AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
                            AND rva01 = rvbslk01
                            AND rva01 = g_rva.rva01
                            AND rvbslk02 != g_rvbslk[l_ac2].rvbslk02
                            AND rvaconf <> 'X'
                        LET l_n = l_n1 + l_n2
                        SELECT sma134 INTO l_times FROM sma_file
                        #收貨次數是否已經超過參數設定中的次數
                        IF l_n >= l_times THEN
                           CALL cl_err('','apm-932',0)
                           NEXT FIELD rvbslk03
                        END IF
                #    END IF
                # END IF
                  IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN                          #No.FUN-810016
                     CALL t110_rvbslk03('a',g_rvbslk[l_ac2].rvbslk04,g_rvbslk[l_ac2].rvbslk03)  #TQC-C20117--add
                    IF g_rvbslk[l_ac2].rvbslk07 < 0 THEN
                       IF NOT cl_confirm('mfg3353') THEN
                          LET g_rvbslk[l_ac2].rvbslk03 = g_rvbslk_t.rvbslk03
                          NEXT FIELD rvbslk04
                       END IF
                    END IF
                    CALL t110_ins_rvb_b()
                    IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
                        SELECT ima021 INTO g_rvbslk[l_ac2].ima021a FROM ima_file
                           WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                        CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
                        CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
                                           g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
                        LET g_rec_b3 = g_imx.getLength()
                        SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                        IF l_ima151 = 'Y' THEN
                           CALL cl_set_comp_entry("rvbslk07",FALSE)
                        ELSE
                           CALL cl_set_comp_entry("rvbslk07",TRUE)
                        END IF
                        SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
                        DISPLAY l_count TO FORMONLY.qty
                     END IF
                  END IF                                              #No.FUN-810116
                 #LET l_pmn20 = 0
                 #SELECT pmn20,pmn87,pmn123 INTO l_pmn20,l_pmn87,l_pmn123 FROM pmn_file
                 # WHERE pmn01=g_rvbslk[l_ac2].rvbslk04
                 #   AND pmn02=g_rvbslk[l_ac2].rvbslk03
                  LET l_rvbslk07_s = 0  
                  SELECT SUM(rvbslk07) INTO l_rvbslk07_s FROM rvbslk_file
                    WHERE rvbslk04=g_rvbslk[l_ac2].rvbslk04
                      AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
                      AND (rvbslk01<>g_rva.rva01 OR
                          (rvbslk01=g_rva.rva01 AND rvbslk02<>g_rvbslk[l_ac2].rvbslk02))
                  IF cl_null(l_rvbslk07_s) THEN LET l_rvbslk07_s = 0 END IF      
#                 CALL t110_set_no_entry_b(p_cmd)   #No.FUN-610018  #TQC-C20117--mark
                  CALL t110_set_no_entry_bslk(p_cmd)                #TQC-C20117--add
                  CALL t110_set_entry_rvb38()      #FUN-B50096
                  CALL t110_set_no_entry_rvb38()   #FUN-B50096
                END IF  #No.MOD-4B0275 end
#               CALL t110_set_no_entry_b('s')    #TQC-C20117--mark
                CALL t110_set_no_entry_bslk('s') #TQC-C20117--add
             
                CALL t110_set_entry_rvb38()      #FUN-B50096
                CALL t110_set_no_entry_rvb38()   #FUN-B50096
               IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
 
              #LET g_rvbslk2.rvbslk10 = g_pmn31
              #LET g_rvbslk2.rvbslk10t= g_pmn31t     #No.FUN-550117
              #LET g_rvbslk[l_ac2].rvbslk10 = g_pmn31
              #LET g_rvbslk[l_ac2].rvbslk10t= g_pmn31t     #No.FUN-550117
              #IF g_azw.azw04='2'  THEN                                                                           
              #   CALL t110_get_price()
              #END IF
              #DISPLAY g_rvbslk[l_ac2].rvbslk10  TO rvbslk10  #MOD-570294 重show一次避免沒跑ON ROW CHANGE
              #DISPLAY g_rvbslk[l_ac2].rvbslk10t TO rvbslk10t #MOD-570294 重show一次避免沒跑ON ROW CHANGE
               IF NOT cl_null(g_errno) THEN
                  IF g_errno = 'mfg0159' THEN
                     LET g_rvbslk[l_ac2].rvbslk03 = g_rvbslk_t.rvbslk03  #No.MOD-FUN-840575
                     LET g_errno =''                        #No.MOD-FUN-840575
                     NEXT FIELD rvbslk03 
                  ELSE
                     CALL cl_err(g_rvbslk[l_ac2].rvbslk03,g_errno,0)
                     LET g_rvbslk[l_ac2].rvbslk03 = g_rvbslk_t.rvbslk03  #No.MOD-FUN-840575 
                     LET g_errno =''                        #No.MOD-FUN-840575
                     NEXT FIELD rvbslk03
                  END IF
               END IF
                
               #不能部份交貨且已有交貨量則不允許通過
               IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
                  CALL cl_err('','mfg3339',0)
                  NEXT FIELD rvbslk03
               END IF
               #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
             # IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) AND NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN    #No.MOD-840575 
             #   IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
             #     SELECT * FROM alt_file
             #       WHERE alt01=g_rvbslk[l_ac2].rvbslk22
             #         AND alt14=g_rvbslk[l_ac2].rvbslk04
             #         AND alt15=g_rvbslk[l_ac2].rvbslk03
             #    IF SQLCA.sqlcode=100 THEN
             #       CALL cl_err3("sel","alt_file",g_rvbslk[l_ac2].rvbslk22,"","apm-304","","",1) #No.FUN-660129
             #       LET g_rvbslk[l_ac2].rvbslk03= g_rvbslk_t.rvbslk03            #No.MOD-840575 
             #       NEXT FIELD rvbslk03                                #No.MOD-840575 
             #    END IF
             #   END IF
             #END IF                                             #No.FUN-840575 
            END IF
            LET l_direct = 'U'
            LET l_rvbslk03_o= g_rvbslk[l_ac2].rvbslk03 #MOD-B30090 add
 
            # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
           #LET l_ec_sw = 'N'
           #IF g_argv2 ='SUB' THEN
           #   LET l_sfb24=''
           #   SELECT sfb24 INTO l_sfb24
           #     FROM sfb_file
           #    WHERE sfb01 = g_rvbslk[l_ac2].rvbslk34
           #   IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
           #      LET l_ec_sw='Y'
           #   END IF
           #END IF
           #IF l_ec_sw='Y' THEN
           #   LET g_rvbslk[l_ac2].rvbslk36=' '
           #   LET g_rvbslk[l_ac2].rvbslk37=' '
           #   LET g_rvbslk[l_ac2].rvbslk38=' '
           #   DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk36
           #   DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk37
           #   DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
           #   CALL cl_err('','mfg-021',0)
           #END IF
            LET g_ima906 = NULL
            SELECT ima906 INTO g_ima906 FROM ima_file
             WHERE ima01=g_rvbslk[l_ac2].rvbslk05
         #  CALL t110_set_no_entry_b(p_cmd)        #TQC-C20117--mark
            CALL t110_set_no_entry_bslk(p_cmd)     #TQC-C20117--add
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096 
 
         AFTER FIELD rvbslk07     #實收數量
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk07) THEN
               IF g_rvbslk[l_ac2].rvbslk07 < 0 THEN
                  CALL cl_err('','mfg3348',0)   #MOD-890170
                  NEXT FIELD rvbslk07
            #MOD-C30217--add--begin--
               ELSE
                  IF NOT t110_check_rvb07(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk07) THEN
                     LET g_rvbslk[l_ac2].rvbslk07 = g_rvbslk_t.rvbslk07
                     NEXT FIELD rvbslk07
                  END IF 
            #MOD-C30217--add--end--
               END IF 
            #MOD-C30217--mark--begin--
            #  IF cl_null(g_pmn13) THEN   #超交率
            #     LET g_pmn13 = 0
            #  END IF
            #  IF cl_null(g_pmn50_55) THEN
            #     LET g_pmn50_55 = 0
            #  END IF
            #  #  SELECT SUM(rvbslk07) INTO l_rvbslk07_3 FROM rvbslk_file,rva_file
            #  #   WHERE rvbslk04=g_rvbslk[l_ac2].rvbslk04
            #  #     AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
            #  #     AND rvaconf='N'
            #  #     AND rva01=rvbslk01
            #  #     AND rvbslk35='N'
            #  #     AND NOT (rvbslk01=g_rva.rva01 AND rvbslk02=g_rvbslk[l_ac2].rvbslk02)
            #  IF cl_null(l_rvbslk07_3) THEN
            #     LET l_rvbslk07_3 = 0
            #  END IF
 
            #  #計算已交量
            #  LET l_rvbslk07=g_pmn50_55+l_rvbslk07_3+g_rvbslk[l_ac2].rvbslk07
            #  LET l_rvbslk07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
            #   LET l_rvbslk07_2=(g_pmn20*(100-g_pmn13))/100     #MOD-530021 #最少可交貨量
 
            #  IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
            #     IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
            #         IF l_rvbslk07_2 > l_rvbslk07 THEN #短交 #MOD-530021
            #           IF g_sma.sma85 MATCHES '[Rr]' THEN
            #              CALL cl_err(l_rvbslk07_2,'mfg3038',0)
            #              NEXT FIELD rvbslk07
            #           ELSE
            #              CALL cl_err(l_rvbslk07_2,'mfg9120',1)
            #           END IF
            #        END IF
            #        ######  樣品不檢查
            #       #IF g_rvbslk[l_ac2].rvbslk35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019委外不檢查超交
            #       #   IF l_rvbslk07_1 < l_rvbslk07 THEN #超交
            #       #      IF g_sma.sma85 MATCHES '[Rr]'  THEN
            #       #          CALL cl_err(l_rvbslk07_1,'mfg3037',1) #MOD-530021 #將show l_rvbslk07_2,改成l_rvbslk07_1  #No.TQC-6C0091 0->1
            #       #         NEXT FIELD rvbslk07
            #       #      ELSE
            #       #          CALL cl_err(l_rvbslk07_1,'mfg9121',1) #MOD-530021 #將show l_rvbslk07_2,改成l_rvbslk07_1
            #       #      END IF
            #       #   END IF
            #       #END IF
            #     END IF
            #     IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
            #        ######  樣品不檢查
            #       #IF g_rvbslk[l_ac2].rvbslk35 = 'N' AND g_rva.rva10 != 'SUB' THEN #CHI-6B0019委外不檢查超交
            #       #   IF l_rvbslk07_1 < l_rvbslk07 THEN #超交
            #       #      IF g_sma.sma85 MATCHES '[Rr]' THEN
            #       #          CALL cl_err(l_rvbslk07_1,'mfg3037',1) #MOD-530021 #將show l_rvbslk07_2,改成l_rvbslk07_1  #No.TQC-6C0091 0->1
            #       #         NEXT FIELD rvbslk07
            #       #      ELSE
            #       #          CALL cl_err(l_rvbslk07_1,'mfg9121',1) #MOD-530021 #將show l_rvbslk07_2,改成l_rvbslk07_1
            #       #      END IF
            #       #   END IF
            #       #END IF
            #     END IF
            #  END IF
 
            #  IF g_pmn13 < 0 THEN    #控制超短交
            #     IF g_pmn14 = 'N' THEN   #不能部份交貨
            #        IF l_rvbslk07 - g_pmn20 < 0 THEN      #須>= 訂購量
            #           CALL cl_err(l_rvbslk07,'mfg3335',0)
            #           NEXT FIELD rvbslk07
            #        END IF
            #     END IF
            #  END IF
 
            #  #-->確認之(收貨-退貨)
            #  IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
            #    IF g_argv2 ='SUB' AND g_rvbslk[l_ac2].rvbslk05=l_sfb05 THEN
            #       IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
            #          IF g_rvbslk[l_ac2].rvbslk07 > g_min_set THEN
            #             CALL cl_err(g_rvbslk[l_ac2].rvbslk07,'apm-307',1)
            #             NEXT FIELD rvbslk07
            #          END IF
            #       ELSE
            #          IF g_rvbslk[l_ac2].rvbslk07 > g_pmn20 - conf_qty THEN
            #             CALL cl_err(g_rvbslk[l_ac2].rvbslk07,'apm-070',1)
            #             NEXT FIELD rvbslk07
            #          END IF
            #       END IF
            #    END IF
            #  END IF
            #  IF g_argv6 = '2' THEN
            #     IF g_rvbslk[l_ac2].rvbslk07 != g_rvbslk_t.rvbslk07 OR cl_null(g_rvbslk_t.rvbslk07) THEN
            #        CALL s_defprice_new(g_rvbslk[l_ac2].rvbslk05,g_rva.rva05,
            #                            g_rva.rva113,g_rva.rva06,g_rvbslk[l_ac2].rvbslk87,'',
            #                            g_rva.rva115,g_rva.rva116,'1',g_rvbslk[l_ac2].rvbslk90,
            #                            '',g_rva.rva112,g_rva.rva111,g_plant)
            #             RETURNING g_rvbslk[l_ac2].rvbslk10,g_rvbslk[l_ac2].rvbslk10t,
            #                       g_rvbslk[l_ac2].rvbslk42,g_rvbslk[l_ac2].rvbslk43
            #     END IF
            #  END IF
            #MOD-C30217--mark--end--
            END IF
       
            CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
            IF l_ec_sw = 'N' THEN      #CHI-A80024
               SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                 FROM ima_file
                WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                  AND imaacti = "Y"
               
               IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                     IF cl_null(g_rvbslk[l_ac2].rvbslk37) THEN
                        LET g_rvbslk[l_ac2].rvbslk37 = ' '
                     END IF
                     IF cl_null(g_rvbslk[l_ac2].rvbslk38) THEN
                        LET g_rvbslk[l_ac2].rvbslk38 = ' '
                     END IF
                     SELECT img09 INTO g_img09
                       FROM img_file   #庫存單位
                      WHERE img01=g_rvbslk[l_ac2].rvbslk05 AND img02=g_rvbslk[l_ac2].rvbslk36
                        AND img03=g_rvbslk[l_ac2].rvbslk37 AND img04=g_rvbslk[l_ac2].rvbslk38
                     CALL s_umfchk(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,g_img09)  #No.FUN-940083 pmn07-->rvbslk90 
                          RETURNING l_i,l_fac
                     IF l_i = 1 THEN LET l_fac = 1 END IF
                     #CHI-9A0022 --Begin
                     LET l_bno = ''
                     SELECT pmn122 INTO l_bno
                       FROM pmn_file
                      WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
                        AND pmn02 = g_rvbslk[l_ac2].rvbslk03
                     IF cl_null(l_bno) THEN
                        LET l_bno = ''
                     END IF
                     #CHI-9A0022 --End
                     CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236----mark---begin---
#                    CALL s_lotin(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,
#                                 g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,g_img09,   #No.FUN-940083 pmn07-->rvbslk90 
#                                 l_fac,g_rvbslk[l_ac2].rvbslk07,l_bno,'MOD')#CHI-9A0022 add ''
#TQC-B90236----mark---end-----
#TQC-B90236----add----begin---
                     IF g_ima930 = 'N' THEN                                        #DEV-D30059
                        CALL s_mod_lot(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,
                                       g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,
                                       g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk38,
                                       g_rvbslk[l_ac2].rvbslk90,g_img09,l_fac,g_rvbslk[l_ac2].rvbslk07,l_bno,'MOD',1)
#TQC-B90236----add----end-----
                           RETURNING l_r,g_qty 
                     END IF                                                        #DEV-D30059
                     IF l_r = "Y" THEN
                        LET g_rvbslk[l_ac2].rvbslk07 = g_qty
                        DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk07 
                     END IF
                  END IF     #FUN-850120
               END IF
            END IF   #CHI-A80024 
  
         BEFORE FIELD rvbslk36
            CALL t110_set_entry_b(p_cmd)
         #  CALL t110_set_no_entry_b(p_cmd)        #TQC-C20117--mark
            CALL t110_set_no_entry_bslk(p_cmd)     #TQC-C20117--add
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
            IF g_azw.azw04 = '2' THEN
               IF cl_null(g_rvbslk[l_ac2].rvbslk36) THEN
                  #FUN-C90049 mark begin---
                  #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
                  # WHERE rtz01 = g_rva.rvaplant
                  #FUN-C90049 mark end-----
                  CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN0C90049 add

                  IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2') THEN
                     IF NOT cl_null(l_rtz08) THEN
                        LET g_rvbslk[l_ac2].rvbslk36 = l_rtz08
                        LET g_rvbslk[l_ac2].rvbslk37 = ' '
                        LET g_rvbslk[l_ac2].rvbslk38 = ' '
                     END IF
                  END IF
                  IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
                     IF NOT cl_null(l_rtz07) THEN
                        LET g_rvbslk[l_ac2].rvbslk36 = l_rtz07
                        LET g_rvbslk[l_ac2].rvbslk37 = ' '
                        LET g_rvbslk[l_ac2].rvbslk38 = ' '
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD rvbslk36
            IF g_azw.azw04='2' AND NOT cl_null(g_rvbslk[l_ac2].rvbslk36) THEN
               IF (g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')) THEN  #FUN-B60150 ADD
                  LET g_cnt = 0
                  SELECT count(*) INTO g_cnt FROM imd_file
                   WHERE imd01 = g_rvbslk[l_ac2].rvbslk36
                     AND imd01 IN (SELECT jce02 FROM jce_file)
                  IF g_cnt = 0 THEN
                     IF g_rva.rva29 = '3' THEN                          #FUN-B60150 ADD
                        CALL cl_err(g_rvbslk[l_ac2].rvbslk36,'apm-147',1)
                     ELSE                                               #FUN-B60150 ADD
                        CALL cl_err(g_rvbslk[l_ac2].rvbslk36,'apm-153',1)      #FUN-B60150 ADD
                     END IF                                             #FUN-B60150 ADD
                     NEXT FIELD rvbslk36
                  END IF
               END IF                                                   #FUN-B60150 ADD
               IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
                  LET g_cnt = 0
                  SELECT count(*) INTO g_cnt FROM imd_file
                   WHERE imd01 = g_rvbslk[l_ac2].rvbslk36
                     AND imd01 NOT IN (SELECT jce02 FROM jce_file)
                  IF g_cnt = 0 THEN
                    CALL cl_err(g_rvbslk[l_ac2].rvbslk36,'apm-154',1)
                    NEXT FIELD rvbslk36
                  END IF
               END IF
            END IF
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-770082 add
            IF cl_null(g_rvbslk[l_ac2].rvbslk36) AND l_ec_sw='N' AND g_rvbslk[l_ac2].rvbslk05[1,4] <> 'MISC' THEN      #No.TQC-740313    #CHI-7A0003 remark   #MOD-7A0132 modify MISC
               NEXT FIELD rvbslk36
            END IF
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk36) AND l_ec_sw='N'  THEN
               #------>check-1  檢查該料是否可收至該倉
               IF NOT s_imfchk1(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36) THEN
                  CALL cl_err('s_imfchk1:','mfg9036',0)
                  NEXT FIELD rvbslk36
               END IF
               #------>check-2  檢查倉庫須存在否
               CALL s_stkchk(g_rvbslk[l_ac2].rvbslk36,'A') RETURNING l_code
               IF NOT l_code THEN
                  CALL cl_err('s_stkchk:','mfg1100',0)
                  NEXT FIELD rvbslk36
               END IF
               #------>check-3  檢查是否為可用倉
               CALL s_swyn(g_rvbslk[l_ac2].rvbslk36) RETURNING sn1,sn2
               IF sn1=1 AND g_rvbslk[l_ac2].rvbslk36 != g_rvbslk_t.rvbslk36 THEN
                  LET g_rvbslk_t.rvbslk36=g_rvbslk[l_ac2].rvbslk36
                  CALL cl_err(g_rvbslk[l_ac2].rvbslk36,'mfg6080',0)
                  NEXT FIELD rvbslk36
               ELSE
                  IF sn2=2 AND g_rvbslk[l_ac2].rvbslk36 != g_rvbslk_t.rvbslk36 THEN
                     CALL cl_err(g_rvbslk[l_ac2].rvbslk36,'mfg6085',0)
                     LET g_rvbslk_t.rvbslk36=g_rvbslk[l_ac2].rvbslk36
                     NEXT FIELD rvbslk36
                  END IF
               END IF
               LET sn1=0 LET sn2=0
              #IF NOT s_chk_ware(g_rvbslk[l_ac2].rvbslk36) THEN
              #   IF  g_rvbslk[l_ac2].rvbslk89 = 'Y' THEN
              #      EXIT INPUT
              #   ELSE
              #      NEXT FIELD rvbslk36
              #   END IF                         #TQC-B90034
              #END IF 
               IF NOT s_chksmz(g_rvbslk[l_ac2].rvbslk05, g_rva.rva01,                                                                      
                               g_rvbslk[l_ac2].rvbslk36, g_rvbslk[l_ac2].rvbslk37) THEN                                                           
                  NEXT FIELD rvbslk36                                                                                                  
               END IF                                                                                                               
              #CALL t110_chk_rvb36()   #MOD-C20091 mark
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rvbslk[l_ac2].rvbslk36,g_errno,1)   #MOD-BA0030
                  NEXT FIELD rvbslk36  
               END IF
               NEXT FIELD rvbslk37    #NO.CHI-920041
            END IF
 
         AFTER FIELD rvbslk37              #儲位
            IF g_rvbslk[l_ac2].rvbslk37 = '　' THEN #全型空白
                LET g_rvbslk[l_ac2].rvbslk37 = ' '
            END IF
            IF g_rvbslk[l_ac2].rvbslk37 IS NULL THEN
               LET g_rvbslk[l_ac2].rvbslk37=' '
            END IF
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-910227
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk36) AND l_ec_sw='N' THEN  #NO.MOD-590530
               #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
               IF NOT s_chksmz(g_rvbslk[l_ac2].rvbslk05, g_rva.rva01,
                               g_rvbslk[l_ac2].rvbslk36, g_rvbslk[l_ac2].rvbslk37) THEN
                  NEXT FIELD rvbslk36
               END IF
               #------>check-1  檢查該料是否可收至該倉/儲位
               IF NOT s_imfchk(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,
                               g_rvbslk[l_ac2].rvbslk37) THEN
                  CALL cl_err(g_rvbslk[l_ac2].rvbslk37,'mfg6095',0)
                  NEXT FIELD rvbslk37
               END IF
               #------>check-2  檢查該倉庫/儲位是否存在
               IF g_rvbslk[l_ac2].rvbslk37 IS NOT NULL THEN
                  CALL s_hqty(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,
                              g_rvbslk[l_ac2].rvbslk37)
                       RETURNING g_cnt,g_imf04,g_imf05
                  IF g_imf04 IS NULL THEN
                     LET g_imf04 = 0
                  END IF
                  CALL s_lwyn(g_rvbslk[l_ac2].rvbslk36,g_rvbslk[l_ac2].rvbslk37)
                       RETURNING sn1,sn2    #可用否
                  SELECT pmn38 INTO g_pmn38 FROM pmn_file
                   WHERE pmn01=g_rvbslk[l_ac2].rvbslk04
                     AND pmn02=g_rvbslk[l_ac2].rvbslk03
                  IF g_argv2<>'SUB' THEN #TQC-C70118
                     IF sn2 = 2 THEN
                        IF g_pmn38 = 'Y' THEN
                           CALL cl_err('','mfg9132',0)
                        END IF
                     ELSE
                        IF g_pmn38 = 'N' THEN
                           CALL cl_err('','mfg9131',0)
                        END IF
                     END IF
                  END IF #TQC-C70118
                  LET sn1=0 LET sn2=0
               END IF
               IF g_rvbslk[l_ac2].rvbslk37 IS NULL THEN
                  LET g_rvbslk[l_ac2].rvbslk37=' '
               END IF
              #CALL t110_chk_rvb36()   #MOD-C20091 mark
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvbslk[l_ac2].rvbslk37,g_errno,1)   #MOD-BA0030
                  NEXT FIELD rvbslk37
               END IF
               NEXT FIELD rvbslk38    #NO.CHI-920041
            END IF
           IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
              IF l_ima159 = '2' THEN
              #  CASE  t110_b_rvb38_inschk()        #TQC-C20117--mark 
                 CASE  t110_b_rvbslk38_inschk()     #TQC-C20117--add
                    WHEN "rvbslk36" NEXT FIELD rvbslk36
                    WHEN "rvbslk38" NEXT FIELD rvbslk37
                 END CASE
              END IF
          END IF 
 
         AFTER FIELD rvbslk38              #批號
        #   CASE  t110_b_rvb38_inschk()        #TQC-C20117--mark
            CASE  t110_b_rvbslk38_inschk()         #TQC-C20117--add
               WHEN "rvbslk36" NEXT FIELD rvbslk36
               WHEN "rvbslk38" NEXT FIELD rvbslk38
            END CASE
  
         AFTER FIELD rvbslk10   #採購單價
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk10) THEN
               IF g_rvbslk[l_ac2].rvbslk10 < 0 THEN
                  LET g_rvbslk[l_ac2].rvbslk10 = g_rvbslk_t.rvbslk10
                  NEXT FIELD rvbslk10
               END IF
               LET g_rvbslk[l_ac2].rvbslk10 = cl_digcut(g_rvbslk[l_ac2].rvbslk10,t_azi03)  #No.CHI-6A0004
               IF g_argv6 = '2' THEN                                         #TQC-9B0203
                  LET g_rvbslk[l_ac2].rvbslk10t =                                   #TQC-9B0203
                      g_rvbslk[l_ac2].rvbslk10 * ( 1 + g_rva.rva116 /100)           #TQC-9B0203
               ELSE                                                          #TQC-9B0203
                  SELECT pmm43 INTO g_pmm43 FROM pmm_file WHERE pmm01 = g_rvbslk[l_ac2].rvbslk04 #TQC-C20339
                  LET g_rvbslk[l_ac2].rvbslk10t =
                      g_rvbslk[l_ac2].rvbslk10 * ( 1 + g_pmm43 /100)
               END IF                                                        #TQC-9B0203
               LET g_rvbslk[l_ac2].rvbslk10t = cl_digcut(g_rvbslk[l_ac2].rvbslk10t,t_azi03)  #No.CHI-6A0004
               IF cl_null(g_rvbslk[l_ac2].rvbslk10t) THEN
                  LET g_rvbslk[l_ac2].rvbslk10t = 0
               END IF 
               DISPLAY g_rvbslk[l_ac2].rvbslk10  TO rvbslk10  # FUN-610018
               DISPLAY g_rvbslk[l_ac2].rvbslk10t TO rvbslk10t # FUN-610018
            END IF
 
         AFTER FIELD rvbslk10t   #含稅單價
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk10t) THEN
               LET g_rvbslk[l_ac2].rvbslk10t = cl_digcut(g_rvbslk[l_ac2].rvbslk10t,t_azi03)  #No.CHI-6A0004
               IF g_argv6 = '2' THEN                                         #TQC-9B0203
                  LET g_rvbslk[l_ac2].rvbslk10 =                                    #TQC-9B0203
                      g_rvbslk[l_ac2].rvbslk10t / ( 1 + g_rva.rva116 /100)          #TQC-9B0203
               ELSE                                                          #TQC-9B0203
                  SELECT pmm43 INTO g_pmm43 FROM pmm_file WHERE pmm01 = g_rvbslk[l_ac2].rvbslk04 #TQC-C20339
                  LET g_rvbslk[l_ac2].rvbslk10 =
                      g_rvbslk[l_ac2].rvbslk10t / ( 1 + g_pmm43 / 100)
               END IF                                                        #TQC-9B0203
               LET g_rvbslk[l_ac2].rvbslk10 = cl_digcut(g_rvbslk[l_ac2].rvbslk10,t_azi03)  #No.CHI-6A0004
               IF cl_null(g_rvbslk[l_ac2].rvbslk10) THEN
                  LET g_rvbslk[l_ac2].rvbslk10 = 0
               END IF   
               DISPLAY g_rvbslk[l_ac2].rvbslk10  TO rvbslk10  # FUN-610018
               DISPLAY g_rvbslk[l_ac2].rvbslk10t TO rvbslk10t # FUN-610018
            END IF
 
        AFTER FIELD rvbslk930
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk930) THEN
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                                          WHERE gem01=g_rvbslk[l_ac2].rvbslk930
                                            AND gem09 IN ('1','2')
                                            AND gemacti='Y'
                IF l_cnt=0 THEN
                   CALL cl_err3("sel","gem_file",g_rvbslk[l_ac2].rvbslk930,"",100,"","",1)
                   LET g_rvbslk[l_ac2].rvbslk930=g_rvbslk_t.rvbslk930
                   LET g_rvbslk[l_ac2].gem02=g_rvbslk_t.gem02
                   DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk930,g_rvbslk[l_ac2].gem02
                   NEXT FIELD rvbslk930
                END IF
                CALL t110_set_rvb930(g_rvbslk[l_ac2].rvbslk930) RETURNING g_rvbslk[l_ac2].gem02
                DISPLAY BY NAME g_rvbslk[l_ac2].gem02
            ELSE
                LET g_rvbslk[l_ac2].gem02=NULL
                DISPLAY BY NAME g_rvbslk[l_ac2].gem02
            END IF
            LET g_rvbslk2.rvbslk930  = g_rvbslk[l_ac2].rvbslk930
 
         BEFORE DELETE                            #是否取消單身
            IF g_rvbslk_t.rvbslk02 > 0 AND g_rvbslk_t.rvbslk02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF l_ec_sw = 'N' THEN      #CHI-A80024
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                      #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add
                          CALL cl_err3("del","rvbslks_file",g_rva.rva01,g_rvbslk_t.rvbslk02,
                                        SQLCA.sqlcode,"","",1)
                           ROLLBACK WORK
                           CANCEL DELETE
                       END IF
                     END IF
                  END IF
               END IF   #CHI-A80024

               DELETE FROM rvbslk_file
                WHERE rvbslk01 = g_rva.rva01 AND rvbslk02 = g_rvbslk_t.rvbslk02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rvbslk_file",g_rva.rva01,g_rvbslk_t.rvbslk02,SQLCA.sqlcode,"","del rvbslk",1) #No.FUN-660129
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                         AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                        WHERE rvb01 = rvbi01
                                                          AND rvb02 = rvbi02
                                                          AND rvbi01= g_rva.rva01
                                                          AND rvbislk02=g_rvbslk_t.rvbslk02 )
                  IF SQLCA.sqlcode THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
                  DELETE FROM rvbi_file WHERE rvbi01 = g_rva.rva01
                                          AND rvbislk02 = g_rvbslk_t.rvbslk02       
                  IF SQLCA.sqlcode THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn2
               SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
               DISPLAY l_count TO FORMONLY.qty
            END IF
            IF p_cmd = 'a' THEN
               ROLLBACK WORK
            END IF
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvbslk[l_ac2].* = g_rvbslk_t.*
               CLOSE t110_bcl_slk
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rvbslk[l_ac2].rvbslk02,-263,1)
               LET g_rvbslk[l_ac2].* = g_rvbslk_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_rvbslk[l_ac2].rvbslk05)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD rvbslk05
                  END IF
 
                  CALL s_chk_va_setting1(g_rvbslk[l_ac2].rvbslk05)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     #NEXT FIELD rvbslk05 #TQC-B80005 mark 
                     NEXT FIELD rvbslk82  #TQC-B80005  
                  END IF
 
               #  CALL t110_set_origin_field()
                  LET l_rvb80 = g_rvbslk[l_ac2].rvbslk90
                  LET l_rvb82 = g_rvbslk[l_ac2].rvbslk07
                  LET l_rvb83 = g_rvbslk[l_ac2].rvbslk90
                  LET l_rvb85 = g_rvbslk[l_ac2].rvbslk07
               ELSE
                  LET l_rvb80 = NULL 
                  LET l_rvb81 = NULL
                  LET l_rvb82 = NULL
                  LET l_rvb83 = NULL
                  LET l_rvb84 = NULL
                  LET l_rvb85 = NULL
               END IF
 
               IF NOT cl_null(g_rvbslk[l_ac2].rvbslk36) AND l_ec_sw = 'N' THEN   #MOD-910227
                  IF g_rvbslk[l_ac2].rvbslk37 IS NULL THEN
                     LET g_rvbslk[l_ac2].rvbslk37=' '
                  END IF
                  IF g_rvbslk[l_ac2].rvbslk38 IS NULL THEN
                     LET g_rvbslk[l_ac2].rvbslk38=' '
                  END IF
                  SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                  IF l_ima151 = 'N' THEN        #非子、母料件 
                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                       FROM img_file   #採購單位,庫存數量,庫存單位
                      WHERE img01=g_rvbslk[l_ac2].rvbslk05 AND img02=g_rvbslk[l_ac2].rvbslk36
                        AND img03=g_rvbslk[l_ac2].rvbslk37 AND img04=g_rvbslk[l_ac2].rvbslk38
                     IF STATUS=100 AND (g_rvbslk[l_ac2].rvbslk36 IS NOT NULL AND g_rvbslk[l_ac2].rvbslk36 <> ' ') THEN
                        IF g_sma.sma892[3,3] ='Y' THEN
                           IF NOT cl_confirm('mfg1401') THEN
                              NEXT FIELD rvbslk38
                           END IF
                        END IF
                        CALL s_add_img(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,
                                       g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk38,
                                       g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,g_rva.rva06)
                     END IF
                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                       FROM img_file
                      WHERE img01=g_rvbslk[l_ac2].rvbslk05 AND img02=g_rvbslk[l_ac2].rvbslk36
                        AND img03=g_rvbslk[l_ac2].rvbslk37 AND img04=g_rvbslk[l_ac2].rvbslk38
                  END IF
               END IF
            #  CALL t110_b_move_back() #FUN-730068  #TQC-C20117--mark
               CALL t110_b_move_backslk()  #TQC-C20117--add
               IF cl_null(g_rvbslk[l_ac2].rvbslk10) THEN
                  LET g_rvbslk[l_ac2].rvbslk10 = 0
               END IF
               LET g_rvbslk2.rvbslk10 = g_rvbslk[l_ac2].rvbslk10
               IF cl_null(g_rvbslk[l_ac2].rvbslk10t) THEN LET g_rvbslk[l_ac2].rvbslk10t = 0 END IF
               LET g_rvbslk2.rvbslk10t = g_rvbslk[l_ac2].rvbslk10t
               LET g_rvbslk2.rvbslk36 = g_rvbslk[l_ac2].rvbslk36
               LET g_rvbslk2.rvbslk37 = g_rvbslk[l_ac2].rvbslk37
               LET g_rvbslk2.rvbslk38 = g_rvbslk[l_ac2].rvbslk38
               LET g_rvbslk2.rvbslk88 = g_rvbslk2.rvbslk07*g_rvbslk2.rvbslk10
               LET g_rvbslk2.rvbslk88t= g_rvbslk2.rvbslk07*g_rvbslk2.rvbslk10t
               LET g_rvbslk2.rvbslk930= g_rvbslk[l_ac2].rvbslk930 #FUN-670051
 
              #IF g_argv6 ='1' THEN                  #FUN-940083
              #   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
              #   SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
              #    WHERE gec01 = pmm21
              #      AND pmm01 = g_rvbslk2.rvbslk04
              #   IF SQLCA.SQLCODE = 100 THEN
              #      CALL cl_err('','mfg3192',0)
              #      NEXT FIELD rvbslk04
              #   END IF
              #   SELECT azi04 INTO t_azi04 
              #     FROM pmm_file,azi_file
              #    WHERE pmm22=azi01
              #      AND pmm01=g_rvbslk2.rvbslk04
              #   LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)        #MOD-AC0024
              #   LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04)     #MOD-AC0024
              #   IF g_gec07='Y' THEN
              #      IF g_gec05 = 'T' THEN 
              #         LET g_rvbslk2.rvbslk88 = g_rvbslk2.rvbslk88t * ( 1 - g_pmm43/100)
              #         LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)  
              #      ELSE
              #         LET g_rvbslk2.rvbslk88 = g_rvbslk2.rvbslk88t / ( 1 + g_pmm43/100)
              #         LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)  
              #      END IF
              #      #-----END CHI-AC0016-----
              #      IF cl_null(g_rvbslk2.rvbslk10t) THEN 
              #         LET g_rvbslk2.rvbslk10t = 0 
              #      END IF 
              #      IF cl_null(g_rva.rva116) THEN 
              #         LET g_rva.rva116 = 0 
              #      END IF    
              #      IF g_argv6 = '2' THEN   #MOD-B80298
              #         LET g_rvbslk2.rvbslk10 = g_rvbslk2.rvbslk10t / ( 1 + g_rva.rva116/100)    #FUN-940083
              #      ELSE
              #         LET g_rvbslk2.rvbslk10 = g_rvbslk2.rvbslk10t / ( 1 + g_pmm43/100)
              #      END IF
              #   ELSE
              #      LET g_rvbslk2.rvbslk88t = g_rvbslk2.rvbslk88 * ( 1 + g_pmm43/100)
              #      LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04)  
              #      IF g_argv6 = '2' THEN   #TQC-AB0224
              #         LET g_rvbslk2.rvbslk10t = g_rvbslk2.rvbslk10 * ( 1 + g_rva.rva116/100)    #FUN-940083
              #      ELSE  #TQC-AB0224
              #         LET g_rvbslk2.rvbslk10t = g_rvbslk2.rvbslk10 * ( 1 + g_pmm43 /100)  #TQC-AB0224
              #      END IF  #TQC-AB0224
              #   END IF
              #ELSE
              #   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
              #   SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file   #CHI-AC0016 add gec05
              #    WHERE gec01 = g_rva.rva115
              #   IF SQLCA.SQLCODE = 100 THEN
              #      CALL cl_err('','mfg3192',0)
              #      NEXT FIELD rvbslk04
              #   END IF
              #   SELECT azi04 INTO t_azi04 
              #     FROM azi_file
              #    WHERE azi01 = g_rva.rva113
              #   LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)        #MOD-AC0024
              #   LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04)     #MOD-AC0024
              #   IF g_gec07='Y' THEN
              #      IF g_gec05 = 'T' THEN 
              #         LET g_rvbslk2.rvbslk88 = g_rvbslk2.rvbslk88t * ( 1 - g_rva.rva116/100)
              #         LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)  
              #      ELSE
              #         LET g_rvbslk2.rvbslk88 = g_rvbslk2.rvbslk88t / ( 1 + g_rva.rva116/100)
              #         LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)  
              #      END IF
              #      #-----END CHI-AC0016-----
              #   ELSE
              #      LET g_rvbslk2.rvbslk88t = g_rvbslk2.rvbslk88 * ( 1 + g_rva.rva116/100)
              #      LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04)  
              #   END IF
              #END IF
              LET g_rvbslk2.rvbslk88 = cl_digcut(g_rvbslk2.rvbslk88 , t_azi04)   
              LET g_rvbslk2.rvbslk88t = cl_digcut( g_rvbslk2.rvbslk88t , t_azi04)
              LET g_rvbslk2.rvbslk10 = cl_digcut(g_rvbslk2.rvbslk10,t_azi03)
              LET g_rvbslk2.rvbslk10t = cl_digcut(g_rvbslk2.rvbslk10t,t_azi03)
              IF cl_null(g_rvbslk2.rvbslk10) THEN
                 LET g_rvbslk2.rvbslk10 = 0
              END IF
              IF cl_null(g_rvbslk2.rvbslk10t) THEN
                 LET g_rvbslk2.rvbslk10t = 0
              END IF
              IF cl_null(g_rvbslk2.rvbslk88) THEN
                 LET g_rvbslk2.rvbslk88 = 0
              END IF
              IF cl_null(g_rvbslk2.rvbslk88t) THEN
                 LET g_rvbslk2.rvbslk88t = 0
              END IF
              LET g_rvbslk[l_ac2].rvbslk88 = g_rvbslk2.rvbslk88
              LET g_rvbslk[l_ac2].rvbslk88t= g_rvbslk2.rvbslk88t
              UPDATE rvbslk_file SET * = g_rvbslk2.*
                WHERE rvbslk01=g_rva.rva01
                  AND rvbslk02=g_rvbslk_t.rvbslk02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                  CALL cl_err3("upd","rvbslk_file",g_rva.rva01,g_rvbslk_t.rvbslk02,SQLCA.sqlcode,"","upd rvbslk_file",1) #No.FUN-660129
                  LET g_rvbslk[l_ac2].* = g_rvbslk_t.*
               ELSE
                  IF (g_rvbslk[l_ac2].rvbslk04 = g_rvbslk_t.rvbslk04 AND g_rvbslk[l_ac2].rvbslk03 = g_rvbslk_t.rvbslk03) AND
                     NOT cl_null(g_rvbslk[l_ac2].rvbslk03) AND NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
                     SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk_t.rvbslk05
                     IF l_ima151 = 'N' THEN        #非子、母料件
                        SELECT ima491 INTO l_ima491 FROM ima_file
                         WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                        IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
                        IF l_ima491 > 0 THEN
                           CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb_slk.rvb12
                        ELSE
                           IF cl_null(g_rvb_slk.rvb12) THEN
                              LET g_rvb_slk.rvb12 = g_rva.rva06
                           END IF
                        END IF
                        CALL t110_get_rvb39(g_rvbslk[l_ac2].rvbslk03,g_rvbslk[l_ac2].rvbslk04,
                                                g_rvbslk[l_ac2].rvbslk05,g_rvb_slk.rvb19,g_rva.rva05,g_sma.sma886)
                             RETURNING g_rvb_slk.rvb39
                        UPDATE rvb_file SET rvb05 = g_rvbslk[l_ac2].rvbslk05,
                                            rvb07 = g_rvbslk[l_ac2].rvbslk07,
                                            rvb08 = g_rvbslk[l_ac2].rvbslk07,
                                            rvb10 = g_rvbslk[l_ac2].rvbslk10,
                                            rvb10t= g_rvbslk[l_ac2].rvbslk10t,
                                            rvb12 = g_rvb_slk.rvb12,
                                            rvb29 = g_rvbslk[l_ac2].rvbslk29,
                                            rvb30 = g_rvbslk[l_ac2].rvbslk30,
                                            rvb31 = g_rvbslk[l_ac2].rvbslk07,
                                            rvb36 = g_rvbslk[l_ac2].rvbslk36,
                                            rvb37 = g_rvbslk[l_ac2].rvbslk37,
                                            rvb38 = g_rvbslk[l_ac2].rvbslk38,
                                            rvb39 = g_rvb_slk.rvb39,
                                            rvb80 = l_rvb80,
                                            rvb81 = l_rvb81,
                                            rvb82 = l_rvb82,
                                            rvb83 = l_rvb83,
                                            rvb84 = l_rvb84,
                                            rvb85 = l_rvb85,
                                            rvb86 = g_rvbslk[l_ac2].rvbslk90,
                                            rvb87 = g_rvbslk[l_ac2].rvbslk07,
                                            rvb88 = g_rvbslk[l_ac2].rvbslk88,
                                            rvb88t= g_rvbslk[l_ac2].rvbslk88t,
                                            rvb930= g_rvbslk[l_ac2].rvbslk930,
                                            rvb90 = g_rvbslk[l_ac2].rvbslk90,
                                            rvb42 = g_rvbslk[l_ac2].rvbslk42,
                                            rvb43 = g_rvbslk[l_ac2].rvbslk43
                        WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                            AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                           WHERE rvb01 = rvbi01
                                                             AND rvb02 = rvbi02
                                                             AND rvbi01= g_rva.rva01
                                                             AND rvbislk01=g_rvbslk_t.rvbslk05
                                                             AND rvbislk02=g_rvbslk_t.rvbslk02 )

                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                          CALL cl_err3("upd","rvb_file",g_rva.rva01,g_rvbslk_t.rvbslk02,SQLCA.sqlcode,"","upd rvbslki_file",1)
                          LET g_rvbslk[l_ac2].* = g_rvbslk_t.*
                       END IF   
                    ELSE             
                       UPDATE rvb_file SET rvb10 = g_rvbslk[l_ac2].rvbslk10,
                                           rvb10t= g_rvbslk[l_ac2].rvbslk10t,
                                           rvb12 = g_rvb_slk.rvb12,
                                           rvb29 = g_rvbslk[l_ac2].rvbslk29,
                                           rvb30 = g_rvbslk[l_ac2].rvbslk30,
                                           rvb36 = g_rvbslk[l_ac2].rvbslk36,
                                           rvb37 = g_rvbslk[l_ac2].rvbslk37,
                                           rvb38 = g_rvbslk[l_ac2].rvbslk38,
                                           rvb39 = g_rvb_slk.rvb39,
                                           rvb80 = l_rvb80,
                                           rvb81 = l_rvb81,
                                           rvb83 = l_rvb83,
                                           rvb84 = l_rvb84,
                                           rvb86 = g_rvbslk[l_ac2].rvbslk90,
                                           rvb88 = ROUND(g_rvbslk[l_ac2].rvbslk07*g_rvbslk[l_ac2].rvbslk10,t_azi04),
                                           rvb88t= ROUND(g_rvbslk[l_ac2].rvbslk07*g_rvbslk[l_ac2].rvbslk10t,t_azi04), 
                                           rvb930= g_rvbslk[l_ac2].rvbslk930,
                                           rvb90 = g_rvbslk[l_ac2].rvbslk90,
                                           rvb42 = g_rvbslk[l_ac2].rvbslk42,
                                           rvb43 = g_rvbslk[l_ac2].rvbslk43
                                       WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                         AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                        WHERE rvb01 = rvbi01
                                                          AND rvb02 = rvbi02
                                                          AND rvbi01= g_rva.rva01
                                                          AND rvbislk02=g_rvbslk_t.rvbslk02 )
                    END IF
                 ELSE
                    DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                                         AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                                        WHERE rvb01 = rvbi01
                                                          AND rvb02 = rvbi02
                                                          AND rvbi01= g_rva.rva01
                                                          AND rvbislk02=g_rvbslk_t.rvbslk02 )
                    IF SQLCA.sqlcode THEN
                       ROLLBACK WORK
                    END IF
                    DELETE FROM rvbi_file WHERE rvbi01 = g_rva.rva01
                                            AND rvbislk02 = g_rvbslk_t.rvbslk02
                    IF SQLCA.sqlcode THEN
                       ROLLBACK WORK
                    END IF
                    IF cl_null(g_rvbslk[l_ac2].rvbslk04) AND cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
                       SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                       IF l_ima151 = 'N' THEN        #非子、母料件
                          LET g_rvb_slk.rvb01 = g_rva.rva01
                          SELECT MAX(rvb02) INTO l_n FROM rvb_file WHERE rvb01 = g_rva.rva01
                          IF cl_null(l_n) THEN
                             LET l_n = 0
                          END IF
                          LET g_rvb_slk.rvb02 = l_n + 1
                          LET g_rvb_slk.rvb05 = g_rvbslk[l_ac2].rvbslk05
                          LET g_rvb_slk.rvb051= g_rvbslk[l_ac2].rvbslk051
                          CALL t110_rvbslk_move()
                          INSERT INTO rvb_file VALUES(g_rvb_slk.*)
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("ins","rvb_file",g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,SQLCA.sqlcode,"","",1)
                          ELSE
                             LET g_rvbi.rvbi01 = g_rva.rva01
                             LET g_rvbi.rvbi02 = g_rvb_slk.rvb02
                             LET g_rvbi.rvbislk01 = g_rvbslk[l_ac2].rvbslk05
                             LET g_rvbi.rvbislk02 = g_rvbslk[l_ac2].rvbslk02
                             LET g_rvbi.rvbiplant = g_plant
                             LET g_rvbi.rvbilegal = g_legal
                             INSERT INTO rvbi_file VALUES(g_rvbi.*)
                             IF SQLCA.sqlcode THEN
                                CALL cl_err3("ins","rvbi_file",g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,SQLCA.sqlcode,"","",1)
                             END IF
                          END IF
                       END IF
                    END IF 
                 END IF

                 #FUN-810038................begin
                 #有更改倉/儲/批,更新刻號/BIN 及 回貨資料資訊
                  IF (g_rvbslk2.rvbslk36 <> g_rvbslk_t.rvbslk36) OR
                     (g_rvbslk2.rvbslk37 <> g_rvbslk_t.rvbslk37) OR
                     (g_rvbslk2.rvbslk38 <> g_rvbslk_t.rvbslk38) THEN
                      UPDATE ida_file
                         SET ida02 = g_rvbslk2.rvbslk36,
                             ida03 = g_rvbslk2.rvbslk37,
                             ida04 = g_rvbslk2.rvbslk38
                        WHERE ida07 = g_rva.rva01
                          AND ida08 = g_rvbslk_t.rvbslk02
                      UPDATE idg_file
                         SET idg07 = g_rvbslk2.rvbslk38        #批號
                       WHERE idg01 = g_rva.rva01
                         AND idg02 = g_rvbslk_t.rvbslk02
                  END IF
                  CALL cl_msg('UPDATE O.K')

                  LET l_rva32 = '0'          #FUN-9C0076 add
               END IF
            END IF
 
         AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac2_t = l_ac2

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF l_ec_sw = 'N' THEN      #CHI-A80024
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                      #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,0,g_rvbslk[l_ac2].rvbslk05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                          CALL cl_err3("del","rvbslks_file",g_rva.rva01,g_rvbslk_t.rvbslk02,
                                        SQLCA.sqlcode,"","",1)
                       END IF
                     END IF #FUN-850120
                  END IF
               END IF   #CHI-A80024
               IF p_cmd = 'u' THEN
                  LET g_rvbslk[l_ac2].* = g_rvbslk_t.*
               END IF
               LET l_rva32 = g_rva.rva32  #FUN-C30293
               CLOSE t110_bcl_slk
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_rva32 = '0'  #FUN-C30293
            CLOSE t110_bcl_slk
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF 

         ON ACTION qry_warehouse        #MOD-490328
                  #MOD-CB0079 -- add start --
                   IF NOT t110_chk_rvbslk04(p_cmd) THEN
                      NEXT FIELD rvbslk04
                   END IF
                  #MOD-CB0079 -- add end --
                  CALL cl_init_qry_var()
                  IF g_azw.azw04 = '2' THEN
                     IF g_rva.rva29 = '1' THEN
                        LET g_qryparam.form = 'q_imd_01'
                     ELSE
                        LET g_qryparam.form = 'q_imd_02'
                     END IF
                     LET g_qryparam.arg1 = g_rva.rvaplant
                     LET g_qryparam.default1 = g_rvbslk[l_ac2].rvbslk36
                     CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk36
                  ELSE 
                     CALL q_imd_1(FALSE,TRUE,g_rvbslk[l_ac2].rvbslk36,"","","","") RETURNING g_rvbslk[l_ac2].rvbslk36
                  END IF 
                  DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk36
                  NEXT FIELD rvbslk36
 
        ON ACTION qry_loc_warehouse        # 遇不可空白欄位可 cursor up
           #MOD-CB0079 -- add start --
            IF NOT t110_chk_rvbslk04(p_cmd) THEN
               NEXT FIELD rvbslk04
            END IF
           #MOD-CB0079 -- add end --
           CALL q_ime_1(FALSE,TRUE,g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk36,'SW',g_plant,"","","") RETURNING g_rvbslk[l_ac2].rvbslk37
           NEXT FIELD rvbslk37
 
       ON ACTION controlp
          CASE 
             WHEN INFIELD(rvbslk04) #查詢採購單號
                CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_rva.rva10,g_rva.rva02)   #MOD-C30434  add rva02   
                     RETURNING g_rvbslk[l_ac2].rvbslk04
                DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk04              #No.MOD-490371
                NEXT FIELD rvbslk04
             WHEN INFIELD(rvbslk05)
                  CALL q_sel_ima(FALSE, "q_ima01_slk","",g_rvbslk[l_ac2].rvbslk05,"","","","","",'' )  #TQC-C20348 add 
                    RETURNING g_rvbslk[l_ac2].rvbslk05                                                  #TQC-C20348 add    
                # CALL cl_init_qry_var()                                  #TQC-C20348 mark
                # LET g_qryparam.form ="q_ima01"                          #TQC-C20348 mark
                # LET g_qryparam.default1 = g_rvbslk[l_ac2].rvbslk05      #TQC-C20348 mark
                # CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk05 #TQC-C20348 mark
                  DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk05 
                  NEXT FIELD rvbslk05 
             WHEN INFIELD(rvbslk03) #P/O項次
                 CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pmn1"
                    LET g_qryparam.default1 = g_rvbslk[l_ac2].rvbslk03
                    LET g_qryparam.arg1 = g_rvbslk[l_ac2].rvbslk04
                    LET g_qryparam.construct='N'
                 CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk03
                 DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk03              #No.MOD-490371
                 NEXT FIELD rvbslk03
             WHEN INFIELD(rvbslk36) OR INFIELD(rvbslk37) OR INFIELD(rvbslk38)
                 CALL cl_init_qry_var()
                 CALL q_img4(FALSE,TRUE,g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk36,  ##NO.FUN-660085
                                  g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk38,'A')
                 RETURNING g_rvbslk[l_ac2].rvbslk36,g_rvbslk[l_ac2].rvbslk37,g_rvbslk[l_ac2].rvbslk38
                 DISPLAY g_rvbslk[l_ac2].rvbslk36 TO rvbslk36
                 DISPLAY g_rvbslk[l_ac2].rvbslk37 TO rvbslk37
                 DISPLAY g_rvbslk[l_ac2].rvbslk38 TO rvbslk38
                 IF INFIELD(rvbslk36) THEN NEXT FIELD rvbslk36 END IF
                 IF INFIELD(rvbslk37) THEN NEXT FIELD rvbslk37 END IF
                 IF INFIELD(rvbslk38) THEN NEXT FIELD rvbslk38 END IF
             WHEN INFIELD(rvbslk930)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk930
                DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk930
                NEXT FIELD rvbslk930
             WHEN INFIELD(rvbslk90) #rvbslk90
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk90
                DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk90
                NEXT FIELD rvbslk90
 
             OTHERWISE EXIT CASE
 
          END CASE
          
        ON ACTION maintain_loc_warehouse
           LET l_cmd = "aimi201 '",g_rvbslk[l_ac2].rvbslk36,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)
 
       ON ACTION default_loc_w_h
          #MOD-CB0079 -- add start --
          IF NOT t110_chk_rvbslk04(p_cmd) THEN
             NEXT FIELD rvbslk04
          END IF
          #MOD-CB0079 -- add end --
          CALL cl_init_qry_var()
          LET g_qryparam.form ="q_imf"
          LET g_qryparam.construct="N"
          LET g_qryparam.default1 = g_rvbslk[l_ac2].rvbslk36
          CALL cl_create_qry() RETURNING g_rvbslk[l_ac2].rvbslk36,g_rvbslk[l_ac2].rvbslk37
          NEXT FIELD rvbslk36
 
        ON ACTION modi_lot
           CALL t110_ec_sw() RETURNING l_ec_sw   
           IF l_ec_sw = 'N' THEN     
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF g_sma.sma90 = 'Y' THEN  
                    IF cl_null(g_rvbslk[l_ac2].rvbslk37) THEN
                       LET g_rvbslk[l_ac2].rvbslk37 = ' '
                    END IF
                    IF cl_null(g_rvbslk[l_ac2].rvbslk38) THEN
                       LET g_rvbslk[l_ac2].rvbslk38 = ' '
                    END IF
                    SELECT img09 INTO g_img09
                      FROM img_file   #庫存單位
                     WHERE img01=g_rvbslk[l_ac2].rvbslk05 AND img02=g_rvbslk[l_ac2].rvbslk36
                       AND img03=g_rvbslk[l_ac2].rvbslk37 AND img04=g_rvbslk[l_ac2].rvbslk38
                    CALL s_umfchk(g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,g_img09)   
                         RETURNING l_i,l_fac
                    IF l_i = 1 THEN LET l_fac = 1 END IF
                     LET l_bno = ''
                     SELECT pmn122 INTO l_bno
                       FROM pmn_file
                      WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
                        AND pmn02 = g_rvbslk[l_ac2].rvbslk03
                     IF cl_null(l_bno) THEN
                        LET l_bno = ''
                     END IF
                 END IF   
              END IF
           END IF   
   END INPUT

   INPUT ARRAY g_imx FROM s_imx.*
             ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
          BEFORE INPUT
              LET li_a=TRUE                 #FUN-C60100 add
              IF g_rec_b3 != 0 THEN 
                 CALL fgl_set_arr_curr(l_ac3)
              END IF
              CALL cl_set_comp_required('color',TRUE)
              LET g_b_flag = '2'   #TQC-D40025

          BEFORE ROW 
             LET p_cmd3 = ''
             LET l_ac3 = ARR_CURR()
             INITIALIZE g_imx_t.* TO NULL

             BEGIN WORK
 
             OPEN t110_cl USING g_rva.rva01
             IF STATUS THEN
                CALL cl_err("OPEN t110_cl:", STATUS, 1)
                CLOSE t110_cl
                ROLLBACK WORK
                RETURN
             END IF
             FETCH t110_cl INTO g_rva.*               # 對DB鎖定
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
                CLOSE t110_cl
                ROLLBACK WORK
                RETURN
             END IF

             IF g_rec_b3 >= l_ac3 THEN
                LET p_cmd3='u'
                LET g_imx_t.* = g_imx[l_ac3].*  
                LET l_lock_sw = 'N'           
             #MOD-C30217----add----------------------
                IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) AND NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
                   CALL cl_set_comp_entry("color",FALSE)
                ELSE
                   CALL cl_set_comp_entry("color",TRUE)
                END IF
             #MOD-C30217----end----------------------
             END IF
           
           BEFORE INSERT
             LET p_cmd3='a'
             LET l_ac3 = ARR_CURR()
             CALL cl_set_comp_entry("color",TRUE)    #MOD-C30217--add
             INITIALIZE g_imx_t.* TO NULL

           AFTER FIELD color          
              IF NOT cl_null(g_imx[l_ac3].color) THEN
                 IF NOT t110_check_color() THEN
                    LET g_imx[l_ac3].color=g_imx_t.color
                    NEXT FIELD color
                 END IF                 
             #TQC-C20348--add--begin--
                 IF p_cmd3 ='a' OR (g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL) THEN
#MOD-C30217------add---------begin-----------
                    IF NOT t110_chk_color_detail(l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].color = g_imx_t.color
                       NEXT FIELD color
                    END IF
#MOD-C30217----end---------------------------
                    IF NOT s_chk_color_strategy(l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].color = g_imx_t.color
                       NEXT FIELD color
                    END IF
                 END IF
              #TQC-C20348--add--end-- 
                 IF g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL THEN
                    CALL s_updcolor_slk(l_ac3,g_rvbslk[l_ac2].rvbslk05,
                                     g_rva.rva01,g_rvbslk[l_ac2].rvbslk02) 
                 END IF
              END IF             
 
           AFTER FIELD imx01
              IF NOT cl_null(g_imx[l_ac3].imx01) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx01 !=g_imx_t.imx01 AND g_imx_t.imx01 IS NOT NULL) THEN
                    IF NOT t110_check_imx(1,g_imx[l_ac3].imx01,g_imx_t.imx01) THEN
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01 
                       NEXT FIELD imx01
                    END IF
                    IF NOT t110_check_ima(1,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                       NEXT FIELD imx01 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,1,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx01) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                       NEXT FIELD imx01
                    END IF
                 #TQC-C20348--add--end-- 
                 END IF
              END IF
           AFTER FIELD imx02
              IF NOT cl_null(g_imx[l_ac3].imx02) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx02 !=g_imx_t.imx02 AND g_imx_t.imx02 IS NOT NULL) THEN
                    IF NOT t110_check_imx(2,g_imx[l_ac3].imx02,g_imx_t.imx02) THEN
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                    IF NOT t110_check_ima(2,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,2,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx02) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx03
              IF NOT cl_null(g_imx[l_ac3].imx03) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx03 !=g_imx_t.imx03 AND g_imx_t.imx03 IS NOT NULL) THEN
                    IF NOT t110_check_imx(3,g_imx[l_ac3].imx03,g_imx_t.imx03) THEN
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03  
                       NEXT FIELD imx03
                    END IF
                    IF NOT t110_check_ima(3,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                       NEXT FIELD imx03 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,3,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx03) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                       NEXT FIELD imx03
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF 
           AFTER FIELD imx04
              IF NOT cl_null(g_imx[l_ac3].imx04) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx04 !=g_imx_t.imx04 AND g_imx_t.imx04 IS NOT NULL) THEN
                     IF NOT t110_check_imx(4,g_imx[l_ac3].imx04,g_imx_t.imx04) THEN
                        LET g_imx[l_ac3].imx04 = g_imx_t.imx04 
                        NEXT FIELD imx04
                     END IF
                    IF NOT t110_check_ima(4,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                       NEXT FIELD imx04 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,4,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx04) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                       NEXT FIELD imx04
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF  
           AFTER FIELD imx05
              IF NOT cl_null(g_imx[l_ac3].imx05) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx05 !=g_imx_t.imx05 AND g_imx_t.imx05 IS NOT NULL) THEN
                    IF NOT t110_check_imx(5,g_imx[l_ac3].imx05,g_imx_t.imx05) THEN
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                    IF NOT t110_check_ima(5,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,5,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx05) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF   
           AFTER FIELD imx06
              IF NOT cl_null(g_imx[l_ac3].imx06) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx06 !=g_imx_t.imx06 AND g_imx_t.imx06 IS NOT NULL) THEN
                    IF NOT t110_check_imx(6,g_imx[l_ac3].imx06,g_imx_t.imx06) THEN
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                    IF NOT t110_check_ima(6,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,6,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx06) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF  
           AFTER FIELD imx07
              IF NOT cl_null(g_imx[l_ac3].imx07) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx07 !=g_imx_t.imx07 AND g_imx_t.imx07 IS NOT NULL) THEN
                    IF NOT t110_check_imx(7,g_imx[l_ac3].imx07,g_imx_t.imx07) THEN
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                    IF NOT t110_check_ima(7,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,7,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx07) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                 #TQC-C20348--add--end--
                 END IF 
              END IF
           AFTER FIELD imx08
              IF NOT cl_null(g_imx[l_ac3].imx08) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx08 !=g_imx_t.imx08 AND g_imx_t.imx08 IS NOT NULL) THEN
                    IF NOT t110_check_imx(8,g_imx[l_ac3].imx08,g_imx_t.imx08) THEN
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                    IF NOT t110_check_ima(8,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,8,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx08) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF 
           AFTER FIELD imx09
              IF NOT cl_null(g_imx[l_ac3].imx09) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx09 !=g_imx_t.imx09 AND g_imx_t.imx09 IS NOT NULL) THEN
                    IF NOT t110_check_imx(9,g_imx[l_ac3].imx09,g_imx_t.imx09) THEN
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09 
                       NEXT FIELD imx09
                    END IF
                    IF NOT t110_check_ima(9,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                       NEXT FIELD imx09 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,9,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx09) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                       NEXT FIELD imx09
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF   
           AFTER FIELD imx10
              IF NOT cl_null(g_imx[l_ac3].imx10) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx10 !=g_imx_t.imx10 AND g_imx_t.imx10 IS NOT NULL) THEN
                    IF NOT t110_check_imx(10,g_imx[l_ac3].imx10,g_imx_t.imx10) THEN
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10 
                       NEXT FIELD imx10
                    END IF
                    IF NOT t110_check_ima(10,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                       NEXT FIELD imx10 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,10,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx10) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                       NEXT FIELD imx10
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF       
           AFTER FIELD imx11
              IF NOT cl_null(g_imx[l_ac3].imx11) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx11 !=g_imx_t.imx11 AND g_imx_t.imx11 IS NOT NULL) THEN
                    IF NOT t110_check_imx(11,g_imx[l_ac3].imx11,g_imx_t.imx11) THEN
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                    IF NOT t110_check_ima(11,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,11,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx11) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx12
              IF NOT cl_null(g_imx[l_ac3].imx12) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx12 !=g_imx_t.imx12 AND g_imx_t.imx12 IS NOT NULL) THEN
                    IF NOT t110_check_imx(12,g_imx[l_ac3].imx12,g_imx_t.imx12) THEN
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                    IF NOT t110_check_ima(12,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,12,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx12) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF
           AFTER FIELD imx13
              IF NOT cl_null(g_imx[l_ac3].imx13) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx13 !=g_imx_t.imx13 AND g_imx_t.imx13 IS NOT NULL) THEN
                    IF NOT t110_check_imx(13,g_imx[l_ac3].imx13,g_imx_t.imx13) THEN
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13 
                       NEXT FIELD imx13
                    END IF
                    IF NOT t110_check_ima(13,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                       NEXT FIELD imx13 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,13,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx13) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                       NEXT FIELD imx13
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF 
           AFTER FIELD imx14
              IF NOT cl_null(g_imx[l_ac3].imx14) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx14 !=g_imx_t.imx14 AND g_imx_t.imx14 IS NOT NULL) THEN
                    IF NOT t110_check_imx(14,g_imx[l_ac3].imx14,g_imx_t.imx14) THEN
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14 
                       NEXT FIELD imx14
                    END IF
                    IF NOT t110_check_ima(14,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                       NEXT FIELD imx14 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,14,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx14) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                       NEXT FIELD imx14
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF  
           AFTER FIELD imx15
              IF NOT cl_null(g_imx[l_ac3].imx15) THEN
                 IF p_cmd3='a' OR (g_imx[l_ac3].imx15 !=g_imx_t.imx15 AND g_imx_t.imx15 IS NOT NULL) THEN
                    IF NOT t110_check_imx(15,g_imx[l_ac3].imx15,g_imx_t.imx15) THEN
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                    IF NOT t110_check_ima(15,l_ac3,g_rvbslk[l_ac2].rvbslk05) THEN
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15 
                    END IF
                 #TQC-C20348--add--begin--
                    CALL s_chk_prod_strategy(l_ac3,15,g_rvbslk[l_ac2].rvbslk05,g_imx[l_ac3].imx15) RETURNING l_error,l_ima01
                    IF NOT cl_null(l_error) THEN   #檢查商品策略
                       CALL cl_err(l_ima01,l_error,0)
                       LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                 #TQC-C20348--add--end--
                 END IF
              END IF   

           BEFORE DELETE 
             IF NOT cl_null(g_imx_t.color) THEN    #TQC-C20348 add  
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                CALL s_ins_slk('r',l_ac3,g_rvbslk[l_ac2].rvbslk05,
                               g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)  
                LET g_rec_b3=g_rec_b3-1
                CALL t110_update_rvbslk()
                IF g_success = 'Y' THEN
                    COMMIT WORK
                ELSE
                    ROLLBACK WORK
                END IF
                DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                   BEFORE DISPLAY
                     EXIT DISPLAY
                END DISPLAY
             END IF    #TQC-C20348 add
     
           AFTER INSERT 
#MOD-C30217------add---begin-----------------
             IF (g_imx[l_ac3].imx01 IS NULL OR g_imx[l_ac3].imx01 = 0) AND
                (g_imx[l_ac3].imx02 IS NULL OR g_imx[l_ac3].imx02 = 0) AND
                (g_imx[l_ac3].imx03 IS NULL OR g_imx[l_ac3].imx03 = 0) AND
                (g_imx[l_ac3].imx04 IS NULL OR g_imx[l_ac3].imx04 = 0) AND
                (g_imx[l_ac3].imx05 IS NULL OR g_imx[l_ac3].imx05 = 0) AND
                (g_imx[l_ac3].imx06 IS NULL OR g_imx[l_ac3].imx06 = 0) AND
                (g_imx[l_ac3].imx07 IS NULL OR g_imx[l_ac3].imx07 = 0) AND
                (g_imx[l_ac3].imx08 IS NULL OR g_imx[l_ac3].imx08 = 0) AND
                (g_imx[l_ac3].imx09 IS NULL OR g_imx[l_ac3].imx09 = 0) AND
                (g_imx[l_ac3].imx10 IS NULL OR g_imx[l_ac3].imx10 = 0) AND
                (g_imx[l_ac3].imx11 IS NULL OR g_imx[l_ac3].imx11 = 0) AND
                (g_imx[l_ac3].imx12 IS NULL OR g_imx[l_ac3].imx12 = 0) AND
                (g_imx[l_ac3].imx13 IS NULL OR g_imx[l_ac3].imx13 = 0) AND
                (g_imx[l_ac3].imx14 IS NULL OR g_imx[l_ac3].imx14 = 0) AND
                (g_imx[l_ac3].imx15 IS NULL OR g_imx[l_ac3].imx15 = 0)
             THEN
                 CANCEL INSERT
             END IF
#MOD-C30217------end-------------------------
              CALL t110_rvbslk_move()      
              CALL s_ins_slk('a',l_ac3,g_rvbslk[l_ac2].rvbslk05,
                             g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
              LET g_rec_b3=g_rec_b3+1
              CALL t110_update_rvbslk()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
              DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 BEFORE DISPLAY
                   EXIT DISPLAY
              END DISPLAY 

           ON ROW CHANGE
              CALL t110_rvbslk_move() 
              CALL s_ins_slk('u',l_ac3,g_rvbslk[l_ac2].rvbslk05,
                             g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
              CALL t110_update_rvbslk()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF 
              DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 BEFORE DISPLAY
                   EXIT DISPLAY
              END DISPLAY

           AFTER ROW
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
   	         ROLLBACK WORK 
              END IF
              CLOSE t110_cl

           AFTER INPUT 
              IF INT_FLAG THEN                         # 若按了DEL鍵
                 LET INT_FLAG = 0
                 EXIT DIALOG
              END IF

   END INPUT   

   #TQC-D40025--add--str--
         BEFORE DIALOG
         CASE g_b_flag
            WHEN '1' NEXT FIELD rvbslk02
            WHEN '2' NEXT FIELD color
         END CASE
   #TQC-D40025--add--end--
#TQC-C20117--add----begin-------------------------------
      ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
         SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
         IF l_ima151 = 'Y' THEN
            IF li_a THEN            
#               LET li_a = FALSE      #FUN-C60100----MARK---
               NEXT FIELD rvbslk02
            ELSE
#               LET li_a = TRUE       #FUN-C60100----MARK---
               NEXT FIELD color
            END IF
         END IF

      ON ACTION maintain_other_data
         CALL t110_b_more()

      ON ACTION maintain_warehouse
         LET l_cmd = 'aimi200 ' CLIPPED
         CALL cl_cmdrun(l_cmd)

      ON ACTION sel_from_procure
         CALL t110_sel_from_procure()
         EXIT DIALOG

      ON ACTION fast_receiving
         CALL t110_cre_tmp()
         CALL t110_rec()
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controls                                #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")

      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
    #TQC-D40025--add--str--
         IF g_b_flag = '1' THEN
            IF p_cmd = 'a' THEN
               CALL g_rvbslk.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac2 = l_ac2_t
               END IF
            END IF
         END IF
         IF g_b_flag = '2' THEN
            IF p_cmd3 = 'a' THEN
               CALL g_imx.deleteElement(l_ac3)
               IF g_rec_b3 != 0 THEN
                  LET g_action_choice = "detail"
               END IF
            END IF
         END IF
    #TQC-D40025--add--end--
         ROLLBACK WORK
         EXIT DIALOG
#TQC-C20117--add------end------------
  END DIALOG                                            #TQC-C20117--add  
###&else                                                #TQC-C20117--mark
#TQC-C20117--add ##&endif
ELSE                                                    #TQC-C20117--add  
##TQC-C20117--mark-----begin--------------------------
#  INPUT ARRAY g_rvb FROM s_rvb.*
#        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
#                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#                  APPEND ROW=l_allow_insert)
#TQC-C20117--mark-----end------------------------------
#TQC-C20117--remark----begin--------------------------
#FUN-B90101--add--end--
#FUN-B90101--mark--
   INPUT ARRAY g_rvb WITHOUT DEFAULTS FROM s_rvb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
#FUN-B90101--mark--
#TQC-C20117--remark----end----------------------------
 
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
            #FUN-C80030--mark--str--
            #IF g_sma.sma90 = 'Y' THEN
            #   CALL cl_set_act_visible("modi_lot", TRUE)
            #ELSE
            #   CALL cl_set_act_visible("modi_lot", FALSE)
            #END IF
            #FUN-C80030--mark--end--
 
            #MOD-C90138 -- add start --
            IF g_argv6 = '2' THEN
               CALL cl_set_act_visible("sel_from_procure,fast_receiving", FALSE)
            ELSE
               CALL cl_set_act_visible("sel_from_procure,fast_receiving", TRUE)
            END IF
            #MOD-C90138 -- add end --

            LET g_before_input_done = FALSE
            #CALL t110_set_entry_b('a')    #TQC-C30193 mark
            #CALL t110_set_no_entry_b('a') #TQC-C30193 mark
            LET g_before_input_done = TRUE
 
         BEFORE ROW
            INITIALIZE g_rvb2.* TO NULL #MOD-550195
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'            #DEFAULT
            LET g_success = 'Y'
 
            BEGIN WORK
            OPEN t110_cl USING g_rva.rva01
            IF STATUS THEN
               CALL cl_err("OPEN t110_cl:", STATUS, 1)
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t110_cl INTO g_rva.*  #鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err("fetch t110_cl_b",SQLCA.sqlcode,0)      #資料被他人LOCK
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_rvb_t.* = g_rvb[l_ac].*  #BACKUP
               LET g_rvb_o.* = g_rvb[l_ac].*  #MOD-BA0178 add
#              IF NOT s_industry('slk') THEN   #No.FUN-A50054    #FUN-A60035 ---MARK
               OPEN t110_bcl USING g_rva.rva01,g_rvb_t.rvb02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t110_bcl INTO g_rvb2.*  #FUN-730068
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_rvb_t.rvb02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                       OPEN t110_bcl_ind USING g_rva.rva01,g_rvb_t.rvb02
                       IF STATUS THEN
                          CALL cl_err("OPEN t110_bcl_ind:", STATUS, 1)
                          LET l_lock_sw = "Y"
                       END IF
                       FETCH t110_bcl_ind INTO g_rvbi2.*
                       IF SQLCA.sqlcode THEN
                           CALL cl_err(g_rvb_t.rvb02,SQLCA.sqlcode,1)
                           LET l_lock_sw = "Y"
                       END IF
                     CALL t110_b_move_to() #FUN-730068
                     SELECT ima021 INTO g_rvb[l_ac].ima021 FROM ima_file
                       WHERE ima01=g_rvb[l_ac].rvb05
                     CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
                     LET g_rvb05_t = g_rvb[l_ac].rvb05
                     IF g_argv6 = '1' THEN    #FUN-940083
                        CALL t110_rvb03('d',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
                     END IF                   #FUN-940083
                     LET g_rvb[l_ac].rvb05 = g_rvb05_t                     #No.FUN-810016
                     IF g_rvb[l_ac].rvb05 != g_rvb[l_ac].rvb05a THEN        #NO.MOD-920003
                       SELECT ima02,ima021 INTO  g_rvb[l_ac].rvb051,g_rvb[l_ac].ima021 FROM ima_file  #No.FUN-810016 #FUN-940083 pmn041-->rvb051
                         WHERE ima01 = g_rvb[l_ac].rvb05                                            #No.FUN-810016
                     END IF                                                 #NO.MOD-920003
                     #FUN-A20017--begin--add----
                     IF g_argv2 = 'SUB' AND NOT cl_null(g_rvb[l_ac].rvb05) 
                        AND NOT cl_null(g_rvb[l_ac].rvb03) THEN  
                        SELECT pmn04,ima903 INTO l_ima01,l_ima903
                          FROM ima_file,pmn_file
                         WHERE pmn01 = g_rvb[l_ac].rvb04
                           AND pmn02 = g_rvb[l_ac].rvb03
                           AND ima01 = pmn04
                        IF g_rvb[l_ac].rvb05 <> l_ima01 THEN
                           SELECT ima02,ima021 INTO  g_rvb[l_ac].rvb051,g_rvb[l_ac].ima021 FROM ima_file  #No.FUN-810016
                            WHERE ima01 = g_rvb[l_ac].rvb05                                            #No.FUN-810016
                        END IF
                     END IF
                     #FUN-A20017--end--add------
                     LET g_before_input_done = FALSE
                     CALL t110_set_entry_b(p_cmd)
                     CALL t110_set_no_entry_b(p_cmd)
#&ifdef ICD   #FUN-B50096
                     CALL t110_set_no_required_1()   #FUN-A40022
                     CALL t110_set_required_1(p_cmd) #FUN-A40022
                     CALL t110_set_entry_rvb38()     #FUN-B50096 
                     CALL t110_set_no_entry_rvb38()  #FUN-B50096
                     LET g_before_input_done = TRUE
                  END IF
                 END IF
#FUN-A60035 ---MARK BEGIN
#               #No.FUN-A50054 -BEGIN-----
#                ELSE
#                   DECLARE t110_ata3 CURSOR FOR
#                    SELECT ata02,ata03,ata05 FROM ata_file
#                     WHERE ata00 = g_prog
#                       AND ata01 = g_rva.rva01
#                       AND ata02 = g_rvb_t.rvb02 
#                   FOREACH t110_ata3 INTO l_ata02,l_ata03,l_ata05
#                      IF STATUS THEN EXIT FOREACH END IF
#                      OPEN t110_bcl USING g_rva.rva01,l_ata03
#                      IF STATUS THEN
#                         CALL cl_err("OPEN t110_bcl:", STATUS, 1)
#                         LET l_lock_sw = "Y"
#                      ELSE
#                         FETCH t110_bcl INTO g_rvb2.*
#                         IF SQLCA.sqlcode THEN
#                             CALL cl_err(g_rvb_t.rvb02,SQLCA.sqlcode,1)
#                             LET l_lock_sw = "Y"
#                         ELSE
#                            LET g_rvb2.rvb02 = l_ata02
#                            LET g_rvb2.rvb03 = l_ata02
#                            LET g_rvb2.rvb05 = l_ata05
#                            CALL t110_b_move_to()
#                            SELECT ima021 INTO g_rvb[l_ac].ima021 FROM ima_file
#                              WHERE ima01=g_rvb[l_ac].rvb05
#                            CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a 
#                            LET g_rvb05_t = g_rvb[l_ac].rvb05
#                            IF g_argv6 = '1' THEN 
#                               CALL t110_rvb03('d',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
#                            END IF
#                            LET g_rvb[l_ac].rvb05 = g_rvb05_t
#                            IF g_rvb[l_ac].rvb05 != g_rvb[l_ac].rvb05a THEN
#                              SELECT ima02,ima021 INTO  g_rvb[l_ac].rvb051,g_rvb[l_ac].ima021 FROM ima_file
#                                WHERE ima01 = g_rvb[l_ac].rvb05
#                            END IF
#                            LET g_before_input_done = FALSE
#                            CALL t110_set_entry_b(p_cmd)
#                            CALL t110_set_no_entry_b(p_cmd)
#                            LET g_before_input_done = TRUE
#                         END IF
#                      END IF
#                   END FOREACH
#                   SELECT SUM(ata08) INTO g_rvb[l_ac].rvb07 FROM ata_file
#                    WHERE ata00 = g_prog AND ata01 = g_rva.rva01
#                      AND ata02 = g_rvb_t.rvb02
#                   DISPLAY BY NAME g_rvb[l_ac].rvb07
#                   #FUN-A60035 ---add begin #顯示的採購量也應該是和,採購料件也該是母料件
#                   LET g_rvb[l_ac].pmn20 = g_rvb[l_ac].rvb07
#                   LET g_rvb[l_ac].rvb05a = g_rvb[l_ac].rvb05
#                   #FUN-A60035 ---add end
#                END IF
#               #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF g_argv6 ='1' THEN           #FUN-940083--begin
                 SELECT ima150,ima151 INTO l_ima150,l_ima151 FROM ima_file
                  WHERE ima_file.ima01=g_rvb05_t
                #IF l_ima150!='0' OR  l_ima151 = 'Y' THEN   #MOD-CB0099 mark
                 IF l_ima150 MATCHES '[12]' OR  l_ima151 = 'Y' THEN #MOD-CB0099 add
                    CALL cl_set_comp_entry('rvb05',TRUE)
                 ELSE
                  	 CALL cl_set_comp_entry('rvb05',FALSE)
                 END IF 
            END IF                         #FUN-940083--end 
 
         BEFORE INSERT
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
            IF g_cnt = g_sma.sma110 THEN
               CALL cl_err('','axm-156',0)
               CANCEL INSERT
            END IF
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rvb[l_ac].* TO NULL      #900423
            INITIALIZE arr_detail[l_ac].* TO NULL #TQC-650108
            LET g_rvb[l_ac].rvb04 = g_rva.rva02   #Body default
            LET g_rvb[l_ac].rvb89 = 'N'           #FUN-940083
            LET g_rvb[l_ac].rvb35 = 'N'
            LET g_rvb[l_ac].rvb07 = 0
            LET g_rvb[l_ac].rvb82 = 0
            LET g_rvb[l_ac].rvb85 = 0
            LET g_rvb[l_ac].rvb87 = 0
            LET g_rvb[l_ac].rvb30 = 0             #MOD-C30256 add
            LET g_rvb[l_ac].rvb29 = 0             #MOD-C30256 add
            IF l_ac > 1  THEN
               LET g_rvb[l_ac].rvb22 = g_rvb[l_ac-1].rvb22
            END IF
            LET g_rvb2.rvb06  = 0     #已請數量
            LET g_rvb2.rvb07  = 0
            LET g_rvb2.rvb08  = 0     #收貨量
            LET g_rvb2.rvb09  = 0     #允請數量
            LET g_rvb2.rvb10  = 0     #
            LET g_rvb2.rvb10t = 0     #No.FUN-550117
            IF cl_null(g_rvb2.rvb15) THEN
               LET g_rvb2.rvb15  = 0     #容器數量
            END IF
            IF cl_null(g_rvb2.rvb16) THEN
               LET g_rvb2.rvb16  = 0     #容器數目
            END IF
           #MOD-C30362 -- add -- begin
            IF  g_argv6='2' THEN
               LET g_rvb2.rvb19 = '1'
            END IF
           #MOD-C30362 -- add -- end
            LET g_rvb2.rvb18  = '10'  #收貨狀況
            LET g_rvb2.rvb27  = 0     #NO USE
            LET g_rvb2.rvb28  = 0     #NO USE
            LET g_rvb2.rvb29  = 0     #退補量
            LET g_rvb2.rvb32  = 0     #NO USE
            LET g_rvb2.rvb31  = 0     #
            LET g_rvb2.rvb30  = 0     #入庫量
            LET g_rvb2.rvb33  = 0     #入庫量
            LET g_rvb2.rvb331  = 0    #允收量
            LET g_rvb2.rvb332  = 0    #允收量
            LET g_rvb2.rvb35  = 'N'   #樣品否
            LET g_rvb2.rvb40  = ''    #檢驗日期 no.7143
            LET g_rvb2.rvbplant = g_rva.rvaplant   #NO.FUN-960130
            LET g_rvb05_t = NULL
            CALL t110_set_entry_b(p_cmd)          #No.FUN-610018
            CALL t110_set_no_entry_b(p_cmd)	  #MOD-980043
            CALL t110_set_entry_rvb38()           #FUN-B50096
            CALL t110_set_no_entry_rvb38()        #FUN-B50096
            LET g_rvb_t.* = g_rvb[l_ac].*         #新輸入資料
            LET g_rvb_o.* = g_rvb[l_ac].*         #新輸入資料   #MOD-BC0039
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rvb02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_rvb[l_ac].rvb05)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD rvb05
               END IF
 
               CALL s_chk_va_setting1(g_rvb[l_ac].rvb05)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD rvb05
               END IF
 
               CALL t110_du_data_to_correct()
 
               CALL t110_set_origin_field()
            END IF

            #MOD-C30793 ----- add start -----
               CALL t110_ec_sw() RETURNING l_ec_sw
               IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw = 'N' THEN
                  IF g_rvb[l_ac].rvb37 IS NULL THEN
                     LET g_rvb[l_ac].rvb37=' '
                  END IF
                  IF g_rvb[l_ac].rvb38 IS NULL THEN
                     LET g_rvb[l_ac].rvb38=' '
                  END IF
                  SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                    FROM img_file   #採購單位,庫存數量,庫存單位
                   WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                     AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                  IF STATUS=100 AND (g_rvb[l_ac].rvb36 IS NOT NULL AND g_rvb[l_ac].rvb36 <> ' ') THEN
                     IF g_sma.sma892[3,3] ='Y' THEN
                        IF NOT cl_confirm('mfg1401') THEN
                           NEXT FIELD rvb38
                        END IF
                     END IF
                     CALL s_add_img(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                    g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                    g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06)
                     IF g_errno='N' THEN
                        NEXT FIELD rvb38
                     END IF
                  END IF
                  SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                    FROM img_file
                   WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                     AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
               END IF
            #MOD-C30793 ----- add end -----
 
            IF cl_null(g_rvb[l_ac].rvb86) THEN
               LET g_rvb[l_ac].rvb86 = g_rvb[l_ac].rvb90    #No.FUN-940083 pmn07-->rvb90 
               LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
            END IF
#MOD-B80156 -- begin --
            IF cl_null(g_rvb[l_ac].rvb87) THEN
               CALL t110_set_rvb87()
            END IF
#MOD-B80156 -- end --
            # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
            LET l_ec_sw = 'N'
            IF g_argv2 ='SUB' THEN
               LET l_sfb24=''
               SELECT sfb24 INTO l_sfb24
                FROM sfb_file
                WHERE sfb01 = g_rvb[l_ac].rvb34
               IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
                  LET l_ec_sw='Y'
               END IF
               IF l_ec_sw='Y' THEN
                  LET g_rvb[l_ac].rvb36=' '
                  LET g_rvb[l_ac].rvb37=' '
                  LET g_rvb[l_ac].rvb38=' '
               END IF
            END IF

#           IF NOT s_industry('slk') THEN  #No.FUN-A50054 Add   #FUN-A60035 ---MARK
            CALL t110_b_move_back() #FUN-730068
            IF cl_null(g_rvb[l_ac].rvb10) THEN
               LET g_rvb[l_ac].rvb10 = 0
            END IF
            LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
            IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
            LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
            LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
            LET g_rvb2.rvb26 = NULL
            LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
            LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
            LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
            LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
            LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
            LET g_rvb2.rvb930= g_rvb[l_ac].rvb930  #FUN-670051
            LET g_rvb2.rvb051= g_rvb[l_ac].rvb051  #FUN-940083
            LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89   #FUN-940083
            LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90   #FUN-940083
            LET g_rvb2.rvb11 = 0
            LET g_rvb2.rvb25 = g_rvb[l_ac].rvb25
            SELECT ima491 INTO l_ima491 FROM ima_file
             WHERE ima01 = g_rvb2.rvb05
            IF cl_null(l_ima491) THEN
               LET l_ima491 = 0
            END IF
            IF l_ima491 > 0 THEN
               CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
            ELSE
               IF cl_null(g_rvb2.rvb12) THEN
                  LET g_rvb2.rvb12 = g_rva.rva06
               END IF
            END IF
             CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
                  RETURNING g_rvb2.rvb39 #MOD-530415
            LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
            LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
    
            IF g_argv6 ='1' THEN                        #FUN-940083
               #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
               SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
                WHERE gec01 = pmm21
                  AND pmm01 = g_rvb2.rvb04
               IF SQLCA.SQLCODE = 100 THEN
                  CALL cl_err('','mfg3192',0)
                  NEXT FIELD rvb04
               END IF
               SELECT azi04 INTO t_azi04 
                 FROM pmm_file,azi_file
                WHERE pmm22=azi01
                  AND pmm01=g_rvb2.rvb04
               LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)        #MOD-AC0024
               LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     #MOD-AC0024
               IF g_gec07='Y' THEN
                  #-----CHI-AC0016---------
                  #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                  #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  #IF g_gec05 = 'T' THEN
                  IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                     LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rvb[l_ac].pmm43/100) #TQC-C30225 add
                     LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)            #TQC-C30225 add
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rvb[l_ac].pmm43/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  ELSE
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  END IF
                  #-----END CHI-AC0016-----
               ELSE
                  LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
               END IF
            ELSE
               SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file   #CHI-AC0016 add gec05
                WHERE gec01 = g_rva.rva115
               IF SQLCA.SQLCODE = 100 THEN
                  CALL cl_err('','mfg3192',0)
                  NEXT FIELD rvb05
               END IF
               SELECT azi04 INTO t_azi04 
                 FROM azi_file
                WHERE azi01 = g_rva.rva113
                LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)        #MOD-AC0024
                LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     #MOD-AC0024
               IF g_gec07='Y' THEN
                  #-----CHI-AC0016---------
                  #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                  #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  #IF g_gec05 = 'T' THEN
                  IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                     LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rva.rva116/100) #TQC-C30225 add
                     LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)       #TQC-C30225 add
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rva.rva116/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  ELSE
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  END IF
                  #-----END CHI-AC0016----- 
               ELSE
                  LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
               END IF
            END IF
 
            IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
            IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
            IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
            #MOD-C50224 add start -----
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_rvb2.rvb05
            CALL s_umfchk(g_rvb2.rvb05,g_rvb2.rvb90,l_ima25) RETURNING l_flag,l_fac2
            IF l_flag THEN
               CALL cl_err(g_rvb2.rvb90,'mfg7003',1)
               LET g_rvb2.rvb90_fac = 1
            ELSE
               LET g_rvb2.rvb90_fac = l_fac2
            END IF
            #MOD-C50224 add end   -----
            #MOD-C50224 mark start -----
            #IF l_rvb90_fac IS NULL THEN
            #   LET g_rvb2.rvb90_fac=1 
            #ELSE
            #   LET g_rvb2.rvb90_fac=l_RVb90_fac
            #END IF
            #MOD-C50224 mark end   -----
           #CALL t110_chk_rvb36()   #MOD-C20091 mark
            IF NOT cl_null(g_errno) THEN
               #CALL cl_err(g_rvb2.rvb36,'apm-329',1)   #MOD-BA0030
               CALL cl_err(g_rvb2.rvb36,g_errno,1)   #MOD-BA0030
               NEXT FIELD rvb36
            END IF
            LET g_rvb2.rvbplant=g_rva.rvaplant 
            LET g_rvb2.rvblegal=g_rva.rvalegal 
            IF g_azw.azw04='2' THEN 
               LET g_rvb2.rvb42 =g_rvb[l_ac].rvb42
               LET g_rvb2.rvb43 =g_rvb[l_ac].rvb43
               LET g_rvb2.rvb44 =g_rvb[l_ac].rvb44
               LET g_rvb2.rvb45 =g_rvb[l_ac].rvb45 
            END IF
            IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '4' END IF  #FUN-9C0075 ADD 
            LET g_rvb2.rvbplant = g_plant #NO.FUN-980006 jarlin add
            LET g_rvb2.rvblegal = g_legal #NO.FUN-980006 jarlin add
#MOD-B30433-----mark----str-----------------
#MOD-AB0204 --begin--
#           IF cl_null(g_rvb2.rvb40) THEN 
#              LET g_rvb2.rvb40 = g_today
#           END IF 
#MOD-AB0204 --end--         
#MOD-B30433-----mark----end----------------
            INSERT INTO rvb_file VALUES (g_rvb2.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
               CANCEL INSERT
               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF l_ec_sw = 'N' THEN      #CHI-A80024
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvb[l_ac].rvb05
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                      #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add
                          CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                        SQLCA.sqlcode,"","",1)
                       END IF
                     END IF
                  END IF
               END IF   #CHI-A80024
            ELSE
               LET g_rvbi2.rvbi01 = g_rvb2.rvb01
               LET g_rvbi2.rvbi02 = g_rvb2.rvb02
               IF NOT s_ins_rvbi(g_rvbi2.*,'') THEN
                  CANCEL INSERT
               END IF
               CALL cl_msg('INSERT O.K')
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
#FUN-A60035 ---MARK BEGIN
#          #No.FUN-A50054 -BEGIN-----
#           ELSE
#              DECLARE t110_ata4 CURSOR FOR
#               SELECT ata03,ata04,ata08 FROM ata_file
#                WHERE ata00 = g_prog
#                  AND ata01 = g_rva.rva01
#                  AND ata02 = g_rvb[l_ac].rvb02 
#              FOREACH t110_ata4 INTO l_ata03,l_ata04,l_ata08
#                 CALL t110_b_move_back()
#                 LET g_rvb2.rvb05 = l_ata04
#                 LET g_rvb2.rvb02 = l_ata03
#                 LET g_rvb2.rvb03 = l_ata03
#                 LET g_rvb2.rvb07 = l_ata08
#                 LET g_rvb2.rvb10  = g_rvb[l_ac].rvb10
#                 IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
#                 LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
#                 LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
#                 LET g_rvb2.rvb26 = NULL
#                 LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
#                 LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
#                 LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
#                 LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
#                 LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
#                 LET g_rvb2.rvb930= g_rvb[l_ac].rvb930  #FUN-670051
#                 LET g_rvb2.rvb051= g_rvb[l_ac].rvb051  #FUN-940083
#                 LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89   #FUN-940083
#                 LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90   #FUN-940083
#                 LET g_rvb2.rvb11 = 0
#                 LET g_rvb2.rvb25 = g_rvb[l_ac].rvb25
#                 SELECT ima491 INTO l_ima491 FROM ima_file
#                  WHERE ima01 = g_rvb2.rvb05
#                 IF cl_null(l_ima491) THEN
#                    LET l_ima491 = 0
#                 END IF
#                 IF l_ima491 > 0 THEN
#                    CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
#                 ELSE
#                    IF cl_null(g_rvb2.rvb12) THEN
#                       LET g_rvb2.rvb12 = g_rva.rva06
#                    END IF
#                 END IF
#                  CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
#                       RETURNING g_rvb2.rvb39 #MOD-530415
#                 LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
#                 LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
#   
#                 IF g_argv6 ='1' THEN                        #FUN-940083
#                    #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
#                    SELECT gec07 INTO g_gec07 FROM gec_file,pmm_file
#                     WHERE gec01 = pmm21
#                       AND pmm01 = g_rvb2.rvb04
#                    IF SQLCA.SQLCODE = 100 THEN
#                       CALL cl_err('','mfg3192',0)
#                       NEXT FIELD rvb04
#                    END IF
#                    SELECT azi04 INTO t_azi04 
#                      FROM pmm_file,azi_file
#                     WHERE pmm22=azi01
#                       AND pmm01=g_rvb2.rvb04
#                    IF g_gec07='Y' THEN
#                       LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
#                      LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
#                    ELSE
#                       LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
#                       LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
#                    END IF
#                 ELSE
#                    SELECT gec07 INTO g_gec07 FROM gec_file
#                     WHERE gec01 = g_rva.rva115
#                    IF SQLCA.SQLCODE = 100 THEN
#                       CALL cl_err('','mfg3192',0)
#                       NEXT FIELD rvb05
#                    END IF
#                    SELECT azi04 INTO t_azi04 
#                      FROM azi_file
#                     WHERE azi01 = g_rva.rva113
#                    IF g_gec07='Y' THEN
#                       LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
#                       LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
#                    ELSE
#                       LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
#                       LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
#                    END IF
#                END IF
#
#                 IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
#                 IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
#                 IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
#                 IF l_rvb90_fac IS NULL THEN
#                    LET g_rvb2.rvb90_fac=1 
#                 ELSE
#                    LET g_rvb2.rvb90_fac=l_rvb90_fac
#                 END IF
#                 CALL t110_chk_rvb36()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err(g_rvb2.rvb36,'apm-329',1)
#                    NEXT FIELD rvb36
#                 END IF
#                 LET g_rvb2.rvbplant=g_rva.rvaplant 
#                 LET g_rvb2.rvblegal=g_rva.rvalegal 
#                 IF g_azw.azw04='2' THEN 
#                    LET g_rvb2.rvb42 =g_rvb[l_ac].rvb42
#                    LET g_rvb2.rvb43 =g_rvb[l_ac].rvb43
#                    LET g_rvb2.rvb44 =g_rvb[l_ac].rvb44
#                    LET g_rvb2.rvb45 =g_rvb[l_ac].rvb45 
#                 END IF
#                 IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '4' END IF  #FUN-9C0075 ADD 
#                 LET g_rvb2.rvbplant = g_plant #NO.FUN-980006 jarlin add
#                 LET g_rvb2.rvblegal = g_legal #NO.FUN-980006 jarlin add
#                 INSERT INTO rvb_file VALUES (g_rvb2.*)
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
#                    CANCEL INSERT
#                    SELECT ima918,ima921 INTO g_ima918,g_ima921 
#                      FROM ima_file
#                     WHERE ima01 = g_rvb[l_ac].rvb05
#                       AND imaacti = "Y"
#              
#                    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
#                       IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
#                         IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045
#                            CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
#                                    SQLCA.sqlcode,"","",1)
#                         END IF
#                       END IF
#                    END IF
#                 END IF
#              END FOREACH
#              CALL cl_msg('INSERT O.K')
#              LET g_rec_b=g_rec_b+1
#              DISPLAY g_rec_b TO FORMONLY.cn2
#              IF g_success='Y' THEN
#                 COMMIT WORK
#              ELSE
#                 ROLLBACK WORK
#              END IF
#           END IF
#          #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
             
           
         BEFORE FIELD rvb02                        #default 序號
            IF cl_null(g_rvb[l_ac].rvb02) OR g_rvb[l_ac].rvb02 = 0 THEN
#              IF NOT s_industry('slk') THEN  #No.FUN-A50054 Add  #FUN-A60035 ---MARK
               SELECT max(rvb02)+1
                 INTO g_rvb[l_ac].rvb02
                 FROM rvb_file
                WHERE rvb01 = g_rva.rva01
#FUN-A60035 ---MARK BEGIN
#            #No.FUN-A50054 -BEGIN-----
#             ELSE
#              	 SELECT max(ata02)+1
#                  INTO g_rvb[l_ac].rvb02
#                  FROM ata_file
#                 WHERE ata01 = g_rva.rva01
#                   AND ata00 = g_prog
#             END IF
#            #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
               IF g_rvb[l_ac].rvb02 IS NULL THEN
                  LET g_rvb[l_ac].rvb02 = 1
               END IF
            END IF
 
         AFTER FIELD rvb02                        #check 序號是否重複
            #MOD-B90224 add --start--
            IF g_rvb[l_ac].rvb02=0 THEN
                CALL cl_err('','apm-422',1)
                LET g_rvb[l_ac].rvb02 = g_rvb_t.rvb02
                NEXT FIELD rvb02
             END IF
            #MOD-B90224 add --end--
            IF g_rvb[l_ac].rvb02 != g_rvb_t.rvb02 OR g_rvb_t.rvb02 IS NULL THEN
#              IF NOT s_industry('slk') THEN  #No.FUN-A50054 Add   #FUN-A60035 ---MARK BEGIN
               SELECT COUNT(*) INTO g_cnt FROM rvb_file
                WHERE rvb01 = g_rva.rva01
                  AND rvb02 = g_rvb[l_ac].rvb02
#FUN-A60035 ---MARK BEGIN
#            #No.FUN-A50054 -BEGIN-----
#             ELSE
#              	 SELECT COUNT(*) INTO g_cnt
#                  FROM ata_file
#                 WHERE ata01 = g_rva.rva01
#                   AND ata00 = g_prog
#                   AND ata02 = g_rvb[l_ac].rvb02
#             END IF
#            #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
               IF g_cnt > 0 THEN     
                  CALL cl_err('',-239,0)
                  LET g_rvb[l_ac].rvb02 = g_rvb_t.rvb02
                  NEXT FIELD rvb02
               END IF
            END IF
            LET l_direct = 'D'
            
            #MOD-BA0178 ----- start -----
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               IF g_sma.sma90 = 'Y' THEN 
                  IF g_rvb[l_ac].rvb02 != g_rvb_o.rvb02 THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM rvbs_file 
                      WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02
                     IF l_cnt > 0 THEN
                        UPDATE rvbs_file SET rvbs02 =  g_rvb[l_ac].rvb02 
                         WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02 
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","rvbs_file",g_rvb[l_ac].rvb02,"",SQLCA.sqlcode,"","",1)
                        ELSE
                           LET g_rvb_o.rvb02 = g_rvb[l_ac].rvb02
                        END IF 
                     END IF
                  END IF
               END IF
            END IF
            #MOD-BA0178 -----  end  -----
            
         BEFORE FIELD rvb22
            LET l_rvb22_old = g_rvb[l_ac].rvb22
 
         AFTER FIELD rvb22
            IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
               SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
                WHERE als01=g_rvb[l_ac].rvb22
               IF SQLCA.sqlcode=100 THEN
                  CALL cl_err3("sel","als_file",g_rvb[l_ac].rvb22,"","aap-762","","",1) #No.FUN-660129
                  NEXT FIELD rvb22
               END IF
               IF l_als05 <> g_rva.rva05 THEN
                  CALL cl_err('','apm-303',0)
                  NEXT FIELD rvb22
               END IF
               IF NOT cl_null(l_als21) THEN
                  LET g_rva.rva08 = l_als21
                  DISPLAY BY NAME g_rva.rva08
               END IF
            END IF
            #(1)原本有發票資料,後來清空發票資料,
            #(2)原本有發票資料,後來更新發票資料,
            # 符合以上,則要將rvw_file中原有的發票資料刪除
            IF NOT cl_null(l_rvb22_old) THEN
               IF cl_null(g_rvb[l_ac].rvb22) OR
                  (l_rvb22_old <> g_rvb[l_ac].rvb22) THEN
                  IF g_aza.aza26 = '2' THEN #大陸版
                     DELETE FROM rvw_file
                      WHERE rvw01 = l_rvb22_old
                        AND rvw08 = g_rva.rva01
                        AND rvw09 = g_rvb[l_ac].rvb02
                  ELSE
                     #避免刪到別張資料
                     SELECT COUNT(*) INTO g_cnt
                       FROM rvb_file
                      WHERE rvb22 = l_rvb22_old
                        AND (rvb01 <> g_rva.rva01 OR
                             rvb02 <> g_rvb[l_ac].rvb02)
                     IF g_cnt = 0 THEN
                        DELETE FROM rvw_file
                         WHERE rvw01 = l_rvb22_old
                     END IF
                  END IF
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('DEL rvw_filee err!',SQLCA.SQLCODE,0)
                     NEXT FIELD rvb22
                  END IF
               END IF
            END IF
            #大陸版, 發票統一在入庫單發票維護作業輸入
            IF NOT cl_null(g_rvb[l_ac].rvb22) AND g_aza.aza26 != '2' AND
               #g_sma.sma886[3,3] = 'Y' AND   #MOD-A80180
              (g_rva.rva04 ='N' OR g_rva.rva04 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM rvw_file
                WHERE rvw01=g_rvb[l_ac].rvb22
               IF l_n = 0 OR g_rvb[l_ac].rvb22 != g_rvb_t.rvb22 THEN
                  CALL sapmt114(g_rvb[l_ac].rvb22,g_rva.rva01)
                                RETURNING g_rvb[l_ac].rvb22
                  IF INT_FLAG THEN
                     LET g_rvb[l_ac].rvb22 = ''
                     DISPLAY BY NAME g_rvb[l_ac].rvb22
                  ELSE 
                     DISPLAY g_rvb[l_ac].rvb22 TO rvb22  #No.MOD-480094
                  END IF 
                  LET INT_FLAG=0
 
                 #判斷單身是否有發票號碼為空白的，
                 #若有則詢問是否一起UPDATE成相同的發票號碼
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM rvb_file 
                                  WHERE rvb01 = g_rva.rva01
                                    AND rvb02 != g_rvb[l_ac].rvb02
                                    AND (rvb22 = ' ' OR rvb22 IS NULL)  
        
                 #發現單身發票欄位有空白的資料，詢問是否一起UPDATE
                  IF l_cnt > 0 THEN
                     IF cl_confirm('aap-267') THEN
                        UPDATE rvb_file
                           SET rvb22=g_rvb[l_ac].rvb22
                         WHERE rvb01=g_rva.rva01
                           AND (rvb22 = ' ' OR rvb22 IS NULL)
        
                        IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","rvb_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1) #No.FUN-660129
                        ELSE
                            FOR l_i = 1 TO g_rec_b
                                IF cl_null(g_rvb[l_i].rvb22) THEN 
                                   LET g_rvb[l_i].rvb22 = g_rvb[l_ac].rvb22
                                END IF
                            END FOR
                      #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
                      #FUN-BB0001 add START
                            LET l_cnt2 = 0
                            SELECT COUNT(*) INTO l_cnt2 FROM rvv_file WHERE rvv04 = g_rva.rva01
                            IF l_cnt2 >= 1 THEN
                               UPDATE rvv_file
                                  SET rvv22 = g_rvb[l_ac].rvb22
                                  WHERE rvv04 = g_rva.rva01
                                  AND (rvv22 = ' ' OR rvv22 IS NULL)
                               IF SQLCA.sqlcode THEN
                                  CALL cl_err3("upd","rvv_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)
                               END IF
                            END IF
                      #FUN-BB0001 add END
                            LET l_rva32 = '0'          #FUN-9C0076 add
                        END IF
                     END IF
                 END IF
  
               END IF
            END IF
            IF NOT cl_null(g_rvb[l_ac].rvb22) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM rvw_file,rva_file,rvb_file
                  WHERE rvw01 = g_rvb[l_ac].rvb22 AND
                        rvb22 = rvw01 AND
                        rvb01 = rva01 AND
                        rva05 <> g_rva.rva05
               IF l_cnt > 0 THEN
                  CALL cl_err(g_rvb[l_ac].rvb22,'apm-435',0)
                  NEXT FIELD rvb22
               END IF
               IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04) THEN    
                 IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                   SELECT * FROM alt_file
                     WHERE alt01=g_rvb[l_ac].rvb22
                       AND alt14=g_rvb[l_ac].rvb04
                       AND alt15=g_rvb[l_ac].rvb03
                  IF SQLCA.sqlcode=100 THEN
                     CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
                     LET g_rvb[l_ac].rvb22= g_rvb_t.rvb22            
                     NEXT FIELD rvb22                                
                  END IF
                 END IF
              END IF                                           
              #MOD-BB0141 ----- modify start -----
              IF g_rvb[l_ac].rvb22 <> g_rvb_o.rvb22 THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM rvb_file
                                 WHERE rvb01 = g_rva.rva01
                                   AND rvb22 = g_rvb[l_ac].rvb22
                 IF l_cnt > 0 AND cl_null(g_upnull) THEN
                    IF cl_confirm('apm1066') THEN
                       DELETE FROM rvw_file WHERE rvw01=g_rvb_o.rvb22
                       #MOD-C80019 mark start -----
                       #UPDATE rvb_file SET rvb22=g_rvb[l_ac].rvb22
                       # WHERE rvb01=g_rva.rva01

                       #SELECT COUNT(*) INTO l_cnt FROM rvb_file WHERE rvb01 = g_rva.rva01
                       #FOR l_i = 1 TO l_cnt
                       #MOD-C80019 mark end   -----
                       #MOD-C80019 add start -----
                       FOR l_i = 1 TO g_rvb.getLength()
                           UPDATE rvb_file SET rvb22=g_rvb[l_ac].rvb22
                            WHERE rvb01=g_rva.rva01 AND rvb02=g_rvb[l_i].rvb02
                       #MOD-C80019 add end   -----
                           LET g_rvb[l_i].rvb22 = g_rvb[l_ac].rvb22
                       END FOR
                    END IF
                 END IF
              END IF
              #MOD-BB0141 -----  modify end  -----
            END IF
            LET g_upnull = NULL #MOD-BB0141 add
 
         AFTER FIELD rvb05
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
               IF NOT s_chk_item_no(g_rvb[l_ac].rvb05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rvb[l_ac].rvb05= g_rvb_t.rvb05
                  NEXT FIELD rvb05
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            #FUN-A20017--begin--add----
            SELECT pmn04,ima903 INTO l_ima01,l_ima903
              FROM ima_file,pmn_file
             WHERE pmn01 = g_rvb[l_ac].rvb04
               AND pmn02 = g_rvb[l_ac].rvb03
               AND ima01 = pmn04
            IF g_argv2 = 'SUB' AND NOT cl_null(g_rvb[l_ac].rvb05) 
               AND NOT cl_null(g_rvb[l_ac].rvb03) THEN  
               IF g_rvb[l_ac].rvb05 <> l_ima01 THEN
                  IF l_ima903 = 'N' OR cl_null(l_ima903) THEN
                     NEXT FIELD rvb05
                  ELSE
                     LET g_cnt = 0
                     SELECT COUNT(*) INTO g_cnt FROM bmm_file
                      WHERE bmm01 = l_ima01 AND bmm03 = g_rvb[l_ac].rvb05
                        AND bmm05 = 'Y'
                     IF g_cnt = 0 OR cl_null(g_cnt) THEN
                        CALL cl_err('','abm-625',0)
                        NEXT FIELD rvb05
                     ELSE
                        SELECT ima02,ima021 INTO g_rvb[l_ac].rvb051,g_rvb[l_ac].ima021 FROM ima_file
                         WHERE ima01 = g_rvb[l_ac].rvb05
                     END IF
                  END IF
               END IF
            END IF
           #FUN-A20017--end--add------ 
           #  IF NOT s_industry('slk') THEN  #No.FUN-A50054 Add   #FUN-A60035 ---MARK
                IF NOT cl_null(g_rvb[l_ac].rvb05) THEN    
                   LET l_n = 0   #MOD-A90065
                   SELECT COUNT(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_rvb[l_ac].rvb05
                       #AND imaacti='Y'   #MOD-A90065
                       AND ima151 != 'Y'
                   IF l_n = 0 THEN 
                      CALL cl_err('','apm-452',0)
                      LET g_rvb[l_ac].rvb05 = g_rvb_t.rvb05
                      NEXT FIELD rvb05 
                   END IF 
                   #-----MOD-A90065---------
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_rvb[l_ac].rvb05
                       AND imaacti='Y'   
                   IF l_n = 0 THEN 
                      CALL cl_err('','axm-890',0)
                      LET g_rvb[l_ac].rvb05 = g_rvb_t.rvb05
                      NEXT FIELD rvb05 
                   END IF 
                   #-----END MOD-A90065-----
                END IF    
          #   END IF  #No.FUN-A50054   #FUN-A60035 ---MARK
            
            SELECT ima150,ima151 INTO l_ima150,l_ima151
              FROM ima_file
             WHERE ima01=g_rvb[l_ac].rvb05a
             IF (g_rvb[l_ac].rvb05!=g_rvb[l_ac].rvb05a) AND (g_argv2 <> 'SUB') THEN #FUN-AA0010
                  #收貨料號!=采購料號 
               IF l_ima151='Y' THEN       #采購料號為母料號
                 IF l_ima150='1' THEN     #依替代原則 
                  SELECT * FROM ima_file WHERE ima_file.ima01=g_rvb[l_ac].rvb05
                  AND ima_file.ima01 IN(
                   SELECT imx000 FROM imx_file
                   WHERE imx_file.imx00=g_rvb[l_ac].rvb05a)
                  AND ima_file.imaacti='Y'   #必須是相同母料號的明細料號
              IF SQLCA.sqlcode =0 THEN
                 SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=g_rvb[l_ac].rvb05a
                  AND pmv_file.pmv06='Y'
                  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)     
                IF l_n=0 THEN
                  SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag=agb_file.agb01
                   AND agb02='1'
                  SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag=agb_file.agb01
                   AND agb02='2'
                  SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag=agb_file.agb01
                   AND agb02='3'
                  SELECT imx01,imx02,imx03 INTO l_imx01,l_imx02,l_imx03
                   FROM imx_file WHERE imx000=g_rvb[l_ac].rvb05    
                  SELECT COUNT(*) INTO l_n
                   FROM pmv_file WHERE pmv_file.pmv01=g_rvb[l_ac].rvb05a
                   AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                   AND pmv_file.pmv09<=g_rva.rva06
                   AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                 IF l_n=0 THEN
                    CALL cl_err('','apm-350',1)
                    LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                    NEXT FIELD rvb05
                 ELSE
                 	IF  l_agb03a IS NOT NULL AND l_agb03a!=' ' THEN
                 	  SELECT COUNT(*) INTO l_n 
                 	  FROM pmv_file 
                 	  WHERE pmv_file.pmv01=g_rvb[l_ac].rvb05a 
                 	  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                 	  AND pmv_file.pmv09<=g_rva.rva06 
                 	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10=' ')
                 	 #AND pmv_file.pmv03=l_agb03a AND (pmv_file.pmv04=' ' OR 	pmv04 IS NULL)
                 	  AND pmv_file.pmv03=l_agb03a AND pmv_file.pmv04='*'   #No.FUn-870117
                          AND (pmv_file.pmv05=l_imx01 OR pmv_file.pmv05='*')
                    IF l_n=0 THEN
                 	   CALL cl_err_msg('','apm-351',l_agb03a CLIPPED,0) 
                 	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                 	   NEXT FIELD rvb05   
                  ELSE 
                  	 IF l_agb03b IS NOT NULL AND l_agb03b!=' '  THEN
                 	  SELECT COUNT(*) INTO l_n 
                 	  FROM pmv_file 
                 	  WHERE pmv_file.pmv01=g_rvb[l_ac].rvb05a 
                 	  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                 	  AND pmv_file.pmv09<=g_rva.rva06 
                 	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                 	 #AND pmv_file.pmv03=l_agb03b AND (pmv_file.pmv04=' ' OR 	pmv04 IS NULL)
                 	  AND pmv_file.pmv03=l_agb03b AND pmv_file.pmv04='*'   #NO.FUN-870117 
                          AND (pmv_file.pmv05=l_imx02 OR pmv_file.pmv05='*') 
                    IF l_n=0 THEN
                 	   CALL cl_err_msg('','apm-352',l_agb03b CLIPPED,0) 
                 	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                    NEXT FIELD rvb05  
                  ELSE
                  	  IF l_agb03c IS NOT NULL AND l_agb03c!=' ' THEN
                 	  SELECT COUNT(*) INTO l_n 
                 	  FROM pmv_file 
                 	  WHERE pmv_file.pmv01=g_rvb[l_ac].rvb05a 
                 	  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                 	  AND pmv_file.pmv09<=g_rva.rva06 
                 	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                 	# AND pmv_file.pmv03=l_agb03c AND (pmv_file.pmv04=' ' OR 	pmv04 IS NULL)
                          AND pmv_file.pmv03=l_agb03c AND pmv_file.pmv04='*'       #No.FUN-870117
                          AND (pmv_file.pmv05=l_imx03 OR pmv_file.pmv05='*') 
                  IF l_n=0 THEN
                 	   CALL cl_err_msg('','apm-353',l_agb03c CLIPPED,0) 
                 	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                      NEXT FIELD rvb05
                  END IF
                  END IF 
                  END IF
                  END IF
                  END IF
                  END IF
                  END IF 
                  END IF   
                 ELSE 
                 	CALL cl_err('','apm-354',1)
                 	LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                   NEXT FIELD rvb05
                 END IF
                 
               ELSE  
               	IF l_ima150='2' THEN   #依替代群組
               	  SELECT COUNT(*) INTO l_n FROM pnc_file
               	  WHERE pnc_file.pnc01=g_rvb[l_ac].rvb05a
               	  AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_rva.rva05)
               	  AND pnc_file.pnc03=g_rvb[l_ac].rvb05 
               	  AND pnc_file.pnc04<=g_rva.rva06 AND (pnc_file.pnc05>g_rva.rva06
               	  OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
               	  IF l_n=0 THEN
               	   CALL cl_err('','apm-356',1)
               	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                    NEXT FIELD rvb05 
               	  END IF
                ELSE 
               	 CALL cl_err('','apm-356',1)	
               	 NEXT FIELD rvb05  
                END IF
              END IF    
            ELSE 
           #表示是多屬性明細料號 	   
               	SELECT COUNT(*)INTO l_n FROM imx_file
               	  WHERE imx_file.imx000=g_rvb[l_ac].rvb05a
               	IF l_n>0  THEN
               	  IF l_ima150='1' THEN
               	    SELECT * FROM imx_file,ima_file
               	     WHERE ima_file.ima01=g_rvb[l_ac].rvb05
               	     AND imx_file.imx000=ima_file.ima01
               	     AND imx_file.imx00 IN(
               	     SELECT imx00 FROM imx_file WHERE imx_file.imx000=g_rvb[l_ac].rvb05a)
               	     AND ima_file.imaacti='Y'
               	  IF SQLCA.sqlcode=0 THEN
               	    SELECT a.imx00 INTO l_imx00
               	      FROM imx_file a, imx_file b
               	      WHERE a.imx000=g_rvb[l_ac].rvb05
               	      AND b.imx000=g_rvb[l_ac].rvb05a
               	      AND a.imx00=b.imx00
               SELECT COUNT(*) INTO l_n FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                  AND pmv_file.pmv06='Y'
                  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)     
                IF l_n=0 THEN
                  SELECT agb03 INTO l_agb03a FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag1=agb_file.agb01
                   AND agb02='1'
                  SELECT agb03 INTO l_agb03b FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag1=agb_file.agb01
                   AND agb02='2'
                  SELECT agb03 INTO l_agb03c FROM agb_file,ima_file
                   WHERE ima01=g_rvb[l_ac].rvb05a AND imaag1=agb_file.agb01
                   AND agb02='3'
                  SELECT imx01,imx02,imx03 INTO l_imx01a,l_imx02a,l_imx03a
                   FROM imx_file WHERE imx000=g_rvb[l_ac].rvb05a
                  SELECT imx01,imx02,imx03 INTO l_imx01b,l_imx02b,l_imx03b
                   FROM imx_file WHERE imx000=g_rvb[l_ac].rvb05     
                  SELECT COUNT(*) INTO l_n
                   FROM pmv_file WHERE pmv_file.pmv01=l_imx00
                   AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                   AND pmv_file.pmv09<=g_rva.rva06
                   AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                  IF l_n=0 THEN
                    CALL cl_err('','apm-350',1)
                    LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                    NEXT FIELD rvb05 
                  ELSE
                 	IF l_agb03a IS NOT NULL   THEN
                 	  IF l_imx01b = l_imx01a  THEN 
                 	     LET l_n=1 
                 	  ELSE    
                 	  SELECT COUNT(*) INTO l_n 
                 	  FROM pmv_file 
                 	  WHERE pmv_file.pmv01=l_imx00 
                 	  AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                 	  AND pmv_file.pmv09<=g_rva.rva06 
                 	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                 	  AND pmv_file.pmv03=l_agb03a AND (pmv_file.pmv04= l_imx01a OR  pmv_file.pmv04='*')
                 	  AND (pmv_file.pmv05=l_imx01b OR pmv_file.pmv05='*')
                 	  END IF 
                  IF l_n=0 THEN
                 	   CALL cl_err_msg('','apm-351',l_agb03a CLIPPED,0) 
                 	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                      NEXT FIELD rvb05 
                  ELSE 
                  	 IF l_agb03b IS NOT NULL   THEN
                  	    IF l_imx02b = l_imx02a  THEN 
                 	        LET l_n=1  
                     	  ELSE
                    	  SELECT COUNT(*) INTO l_n 
                 	       FROM pmv_file 
                    	  WHERE pmv_file.pmv01=l_imx00 
                      	  AND (pmv_file.pmv02='*'  OR pmv_file.pmv02=g_rva.rva05)
                 	        AND pmv_file.pmv09<=g_rva.rva06 
                      	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                 	        AND pmv_file.pmv03=l_agb03b AND (pmv_file.pmv04= l_imx02a OR  pmv_file.pmv04='*')
                 	        AND (pmv_file.pmv05=l_imx02b OR pmv_file.pmv05='*')
                 	      END IF    
                      IF l_n=0 THEN
                 	       CALL cl_err_msg('','apm-352',l_agb03b CLIPPED,0) 
                 	       LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                         NEXT FIELD rvb05 
                     ELSE
                  	  IF l_agb03c IS NOT NULL   THEN
                  	   IF l_imx03b = l_imx03a  THEN 
                 	        LET l_n=1 
                     	 ELSE
                 	     SELECT COUNT(*) INTO l_n 
                 	      FROM pmv_file 
                    	  WHERE pmv_file.pmv01=l_imx00
                 	        AND (pmv_file.pmv02='*' OR pmv_file.pmv02=g_rva.rva05)
                      	  AND pmv_file.pmv09<=g_rva.rva06 
                      	  AND (pmv_file.pmv10>g_rva.rva06 OR pmv_file.pmv10 IS NULL OR pmv_file.pmv10='')
                      	  AND pmv_file.pmv03=l_agb03c AND (pmv_file.pmv04= l_imx03a OR  pmv_file.pmv04='*')
                 	        AND (pmv_file.pmv05=l_imx03b OR pmv_file.pmv05='*') 
                 	     END IF    
                       IF l_n=0 THEN
                 	       CALL cl_err_msg('','apm-353',l_agb03c CLIPPED,0) 
                    	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                         NEXT FIELD rvb05
                       END IF 
                     END IF
                    END IF
                   END IF
                  END IF
                  END IF 
                  END IF 
                  END IF   
                 ELSE 
                 	CALL cl_err('','apm-354',1)
                 	LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                   NEXT FIELD rvb05
                 END IF
                 
                 ELSE   
               	  IF l_ima150='2' THEN
               	  SELECT COUNT(*) INTO l_n FROM pnc_file
               	  WHERE pnc_file.pnc01=g_rvb[l_ac].rvb05a
               	  AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_rva.rva05)
               	  AND pnc_file.pnc03=g_rvb[l_ac].rvb05 
               	  AND pnc_file.pnc04<=g_rva.rva06 AND (pnc_file.pnc05>g_rva.rva06
               	  OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
               	  IF l_n=0 THEN
               	   CALL cl_err_msg('','apm-357',l_agb03c CLIPPED,0) 
               	   LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                    NEXT FIELD rvb05 
               	  END IF
                 END IF
                END IF   
               ELSE  #為其他一般料號
               	IF l_ima150='1' THEN 
               	  DROP TABLE tpmu_file
               	  CREATE TEMP TABLE tpmu_file(
               	  tpmu00      DECIMAL(5,0)   NOT NULL,   #替代序號
               	  tpmu01      VARCHAR(40)       NOT NULL,   #料號
               	  tpmu02      VARCHAR(10)       NOT NULL,   #供應商，*號代表不區分供應商
               	  tpmu03      DECIMAL(5,0)   NOT NULL,   #起始碼
               	  tpmu04      DECIMAL(5,0)   NOT NULL,   #截至碼 
               	  tpmu05      VARCHAR(20)       NOT NULL,   #原值 
               	  tpmu06      VARCHAR(20)       NOT NULL    #替代值
               	  );
               	  DECLARE t110_pmu_cl CURSOR WITH HOLD FOR
               	     SELECT * FROM pmu_file
               	      WHERE pmu_file.pmu01=g_rvb[l_ac].rvb05a
               	      AND (pmu_file.pmu02='*' OR pmu_file.pmu02=g_rva.rva05)
               	      AND pmu_file.pmu07<=g_rva.rva06
               	      AND (pmu_file.pmu08>g_rva.rva06 OR pmu_file.pmu08 IS NULL OR pmu_file.pmu08='')
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
                     LET l_rvb05_cut=g_rvb[l_ac].rvb05[l_tpmu03,l_tpmu04]
                     SELECT COUNT(*) INTO l_n
                     FROM tpmu_file
                     WHERE tpmu_file.tpmu00=l_i 
                     AND tpmu_file.tpmu06=l_rvb05_cut
                     IF  l_n > 0 THEN              #No.TQC-970355  
                       EXIT FOR                    #No.TQC-970355
                     END IF                        #No.TQC-970355                       
                   END FOR 
                     IF l_n=0 THEN
                      CALL cl_err('','apm-355',1)
                      LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                      NEXT FIELD rvb05
                     END IF
                   
                 ELSE      
                  	 IF l_ima150='2' THEN
                  	    SELECT COUNT(*) INTO l_n FROM pnc_file
               	       WHERE pnc_file.pnc01=g_rvb[l_ac].rvb05a
               	       AND (pnc_file.pnc02='*' OR pnc_file.pnc02=g_rva.rva05)
               	       AND pnc_file.pnc03=g_rvb[l_ac].rvb05 
               	       AND pnc_file.pnc04<=g_rva.rva06 AND (pnc_file.pnc05>g_rva.rva06
               	       OR pnc_file.pnc05 IS NULL OR pnc_file.pnc05='')
               	   IF l_n=0 THEN
               	     CALL cl_err_msg('','apm-357',l_agb03c CLIPPED,0) 
               	     LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a
                     NEXT FIELD rvb05 
               	   END IF
                   END IF 
                 END IF     
                END IF
               END IF
             END IF         	                    	            	   	 	   	             
             
            #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
            CALL t110_check_rvb05('rvb05',l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
            IF NOT l_check_res THEN NEXT FIELD rvb05 END IF
            SELECT imaag INTO l_imaag FROM ima_file
             WHERE ima01 = g_rvb[l_ac].rvb05
            IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
               DISPLAY BY NAME g_rvb[l_ac].*
               CALL cl_err(g_rvb[l_ac].rvb05,'aim1004',0)
               NEXT FIELD rvb05
            END IF
            IF g_argv6 ='2' OR g_rvb[l_ac].rvb05 != g_rvb[l_ac].rvb05a THEN #MOD-920003 #FUN-940083
               CALL t110_rvb05('d')                  #No.FUN-840178
               CALL t110_rvb89('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb05,g_errno,0)
                  DISPLAY BY NAME g_rvb[l_ac].rvb89
               END IF
               IF cl_null(g_rvb[l_ac].rvb89) THEN LET g_rvb[l_ac].rvb89 = 'N' END IF   #TQC-9C0053
            END IF                                   #NO.MOD-930003
#&ifdef ICD   #FUN-B50096
            CALL t110_set_no_required_1()   #FUN-A40022
            CALL t110_set_required_1(p_cmd) #FUN-A40022
            CALL t110_set_entry_rvb38()     #FUN-B50096
            CALL t110_set_no_entry_rvb38()  #FUN-B50096
            LET g_rvb_o.rvb05 = g_rvb[l_ac].rvb05   #MOD-BC0039
            
         BEFORE FIELD rvb051 
            IF g_rvb[l_ac].rvb05[1,4]='MISC'  THEN
               CALL t110_set_entry_b(p_cmd)
               CALL t110_set_no_entry_b(p_cmd)
               CALL t110_set_entry_rvb38()      #FUN-B50096
               CALL t110_set_no_entry_rvb38()   #FUN-B50096
            END IF
 
         AFTER FIELD rvb89
            IF NOT cl_null(g_rvb[l_ac].rvb89) THEN
               IF g_rvb[l_ac].rvb89 NOT MATCHES '[YN]'THEN
                  NEXT FIELD rvb89
               END IF
             IF  g_rvb[l_ac].rvb89 = 'Y' THEN 
               CALL cl_set_comp_entry("rvb36,rvb37",FALSE )
             END IF                   
            END IF
 
         BEFORE FIELD rvb90
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
 
         AFTER FIELD rvb90
            IF NOT cl_null(g_rvb[l_ac].rvb90) THEN
               CALL t110_rvb90('d')  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb90,g_errno,0)
                  DISPLAY BY NAME g_rvb[l_ac].rvb90
                  NEXT FIELD rvb90
               END IF
               IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
                  SELECT img09 INTO l_img09 FROM img_file
                   WHERE img01 = g_rvb[l_ac].rvb05
                     AND img02 = g_rvb[l_ac].rvb36
                     AND img03 = g_rvb[l_ac].rvb37
                     AND img04 = g_rvb[l_ac].rvb38
                  IF SQLCA.SQLCODE THEN
                  ELSE
                     SELECT smd04,smd06 INTO l_smd04,l_smd06 
                       FROM smd_file WHERE smd01 = g_rvb[l_ac].rvb05
                        AND smd02 = l_img09 AND smd03 = g_rvb[l_ac].rvb90
                     IF SQLCA.SQLCODE THEN 
                        LET l_rvb90_fac =1 
                     ELSE
                        LET l_rvb90_fac = l_smd04/l_smd06
                     END IF
                  END IF  
#CHI-B80038 -- begin --
                  IF g_argv6 = '2' THEN
                     IF g_rvb[l_ac].rvb90 != g_rvb_t.rvb90 OR cl_null(g_rvb_t.rvb90) THEN
                        CALL s_defprice_new(g_rvb[l_ac].rvb05,g_rva.rva05,
                                            g_rva.rva113,g_rva.rva06,g_rvb[l_ac].rvb87,'',
                                            g_rva.rva115,g_rva.rva116,'1',g_rvb[l_ac].rvb90,
                                            '',g_rva.rva112,g_rva.rva111,g_plant)
                             RETURNING g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t,
                                       g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43
                     END IF
                  END IF
#CHI-B80038 -- end --
               END IF
               #No.FUN-BB0086--add--begin--
               #No.TQC-C20183--mark--begin--
               # SELECT rvb90 INTO l_rvb90 FROM rvb_file 
               # WHERE rvb01 = g_rva.rva01
               #   AND rvb02 = g_rvb[l_ac].rvb02
               #No.TQC-C20183--mark--end--
               LET g_rvb[l_ac].rvb07 = s_digqty(g_rvb[l_ac].rvb07,g_rvb[l_ac].rvb90)  
               #LET g_rvb2.rvb08 = s_digqty(g_rvb2.rvb08,g_rvb[l_ac].rvb90)                #TQC-C20183 
               DISPLAY BY NAME g_rvb[l_ac].rvb07,g_rvb2.rvb08
               #No.FUN-BB0086--add--end--
            END IF
 
         #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
         #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
         #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
         #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
         #其他分支就不需要這么麻煩了
         BEFORE FIELD att00
 
               #根據子料件找到母料件及各個屬性
               SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                      imx06,imx07,imx08,imx09,imx10
               INTO g_rvb[l_ac].att00, g_rvb[l_ac].att01, g_rvb[l_ac].att02,
                    g_rvb[l_ac].att03, g_rvb[l_ac].att04, g_rvb[l_ac].att05,
                    g_rvb[l_ac].att06, g_rvb[l_ac].att07, g_rvb[l_ac].att08,
                    g_rvb[l_ac].att09, g_rvb[l_ac].att10
               FROM imx_file
               WHERE imx000 = g_rvb[l_ac].rvb05
               #賦值所有屬性
               LET g_rvb[l_ac].att01_c = g_rvb[l_ac].att01
               LET g_rvb[l_ac].att02_c = g_rvb[l_ac].att02
               LET g_rvb[l_ac].att03_c = g_rvb[l_ac].att03
               LET g_rvb[l_ac].att04_c = g_rvb[l_ac].att04
               LET g_rvb[l_ac].att05_c = g_rvb[l_ac].att05
               LET g_rvb[l_ac].att06_c = g_rvb[l_ac].att06
               LET g_rvb[l_ac].att07_c = g_rvb[l_ac].att07
               LET g_rvb[l_ac].att08_c = g_rvb[l_ac].att08
               LET g_rvb[l_ac].att09_c = g_rvb[l_ac].att09
               LET g_rvb[l_ac].att10_c = g_rvb[l_ac].att10
               #顯示所有屬性
               DISPLAY BY NAME
                 g_rvb[l_ac].att01, g_rvb[l_ac].att01_c,
                 g_rvb[l_ac].att02, g_rvb[l_ac].att02_c,
                 g_rvb[l_ac].att03, g_rvb[l_ac].att03_c,
                 g_rvb[l_ac].att04, g_rvb[l_ac].att04_c,
                 g_rvb[l_ac].att05, g_rvb[l_ac].att05_c,
                 g_rvb[l_ac].att06, g_rvb[l_ac].att06_c,
                 g_rvb[l_ac].att07, g_rvb[l_ac].att07_c,
                 g_rvb[l_ac].att08, g_rvb[l_ac].att08_c,
                 g_rvb[l_ac].att09, g_rvb[l_ac].att09_c,
                 g_rvb[l_ac].att10, g_rvb[l_ac].att10_c
 
         #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
         #下面是十個輸入型屬性欄位的判斷語句
         AFTER FIELD att00
             #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
             SELECT COUNT(ima01) INTO l_count FROM ima_file
               WHERE ima01 = g_rvb[l_ac].att00 AND imaag = lg_smy62
             IF l_count = 0 THEN
                CALL cl_err_msg('','aim-909',lg_smy62,0)
                NEXT FIELD att00
             END IF
 
             #如果設置為不允許新增
             IF g_sma.sma908 <> 'Y' THEN
                CALL t110_check_rvb05('imx00',l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
                IF NOT l_check_res THEN NEXT FIELD att00 END IF
             END IF
 
         AFTER FIELD att01
             CALL t110_check_att0x(g_rvb[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att01 END IF
         AFTER FIELD att02
             CALL t110_check_att0x(g_rvb[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att02 END IF
         AFTER FIELD att03
             CALL t110_check_att0x(g_rvb[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att03 END IF
         AFTER FIELD att04
             CALL t110_check_att0x(g_rvb[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att04 END IF
         AFTER FIELD att05
             CALL t110_check_att0x(g_rvb[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att05 END IF
         AFTER FIELD att06
             CALL t110_check_att0x(g_rvb[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att06 END IF
         AFTER FIELD att07
             CALL t110_check_att0x(g_rvb[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att07 END IF
         AFTER FIELD att08
             CALL t110_check_att0x(g_rvb[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att08 END IF
         AFTER FIELD att09
             CALL t110_check_att0x(g_rvb[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att09 END IF
         AFTER FIELD att10
             CALL t110_check_att0x(g_rvb[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att10 END IF
         #下面是十個輸入型屬性欄位的判斷語句
         AFTER FIELD att01_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att01_c,1,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att01_c END IF
         AFTER FIELD att02_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att02_c END IF
         AFTER FIELD att03_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att03_c,3,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att03_c END IF
         AFTER FIELD att04_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att04_c,4,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att04_c END IF
         AFTER FIELD att05_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att05_c,5,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att05_c END IF
         AFTER FIELD att06_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att06_c,6,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att06_c END IF
         AFTER FIELD att07_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att07_c,7,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att07_c END IF
         AFTER FIELD att08_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att08_c,8,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att08_c END IF
         AFTER FIELD att09_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att09_c,9,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att09_c END IF
         AFTER FIELD att10_c
             CALL t110_check_att0x_c(g_rvb[l_ac].att10_c,10,l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res
             IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
         BEFORE FIELD rvb04     #採購單號
           CALL t110_set_entry_b('s')  #TQC-7C0131
           CALL t110_set_entry_rvb38()      #FUN-B50096
           CALL t110_set_no_entry_rvb38()   #FUN-B50096
         AFTER FIELD rvb04     #採購單號
#MOD-CB0079 -- mark start #程式段搬移為獨立function(t110_chk_rvb04)--
#            IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
#&ifdef ICD
#                  IF p_cmd = 'u' THEN
#                     IF g_rvb_t.rvb04 <> g_rvb[l_ac].rvb04 THEN
#                        IF NOT t110_ind_icd_chk_icd() THEN
#                           LET g_rvb[l_ac].rvb04=g_rvb_t.rvb04
#                           LET g_rvb[l_ac].rvb05 =g_rvb[l_ac].rvb05a 
#                           LET g_rvb[l_ac].rvb051=g_rvb[l_ac].rvb05b  #FUN-940083 pmn041-->rvb051
#                           LET g_rvb[l_ac].ima021=g_rvb[l_ac].rvb05c
#                           DISPLAY BY NAME g_rvb[l_ac].rvb04
#                           NEXT FIELD CURRENT
#                        END IF
#                     END IF
#                  END IF
#&endif
#               CALL t110_po(g_rvb[l_ac].rvb04,'b')
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
#                  LET g_rvb[l_ac].rvb04 = g_rvb_t.rvb04   #MOD-C30434 -- add 
#                  NEXT FIELD rvb04
#               END IF
#               IF g_azw.azw04='2' THEN
#                  SELECT pmm51 INTO l_pmm51 FROM pmm_file 
#                       WHERE pmm01 = g_rvb[l_ac].rvb04
#                  IF l_pmm51 != g_rva.rva29 THEN
#                     CALL cl_err('','apm-925',0)
#                     NEXT FIELD rvb04
#                  END IF     
#               END IF
#                  IF p_cmd = 'a' OR (p_cmd ='u' AND
#                                 (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
#                                  g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) AND
#                                  NOT cl_null(g_rvb[l_ac].rvb03)) THEN
#                  IF NOT cl_null(g_rvb[l_ac].rvb03) THEN              #No.FUN-810016     
#                     CALL t110_rvb03('a',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
#                     IF g_rvb[l_ac].rvb07 <=0 THEN
#                        IF NOT cl_confirm('mfg3353') THEN
#                           LET g_rvb[l_ac].rvb04 = g_rvb_t.rvb04
#                           NEXT FIELD rvb04
#                        END IF
#                     END IF
#                  END IF                                              #No.FUN-810016   
#                  IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
#                  LET g_rvb2.rvb10 = g_pmn31
#                  LET g_rvb[l_ac].rvb10 = g_pmn31
#                  DISPLAY g_rvb[l_ac].rvb10 TO rvb10
#                  LET g_rvb2.rvb10t = g_pmn31t
#                  LET g_rvb[l_ac].rvb10t = g_pmn31t
#                  DISPLAY g_rvb[l_ac].rvb10t TO rvb10t
#                  IF NOT cl_null(g_errno) THEN
#                     IF g_errno = 'mfg0159' THEN
#                        NEXT FIELD rvb04
#                     ELSE
#                        CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
#                        NEXT FIELD rvb04
#                     END IF
#                  END IF
#&ifdef ICD
#                     CALL t110_ind_icd_def_tky(g_rva.rva01,g_rvb[l_ac].rvb02,
#                                       g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04)
#                     CALL t110sub_ind_icd_set_rvb87_tky('b',g_rvb2.*,g_rvbi2.*,g_argv2) #FUN-A10130
#                     RETURNING g_rvb2.*,g_rvbi2.*,g_rvb[l_ac].rvb87  #FUN-9A0130
#                     #TQC-C60192---begin
#                     IF cl_null(g_rvb[l_ac].rvb87) THEN 
#                        LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb82
#                        DISPLAY BY NAME g_rvb[l_ac].rvb87
#                     END IF 
#                     #TQC-C60192---end 
#                     #若為委外tky單據,要重新取價
#                     CALL t110_ind_icd_def_rvb10()
#&endif
#                  #不能部份交貨且已有交貨量則不允許通過
#                  IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
#                     CALL cl_err('','mfg3339',0)
#                     NEXT FIELD rvb04
#                  END IF
#                  #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
#                  IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04)  THEN   #No.MOD-840575 
#                   IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
#                     SELECT * FROM alt_file
#                      WHERE alt01=g_rvb[l_ac].rvb22
#                        AND alt14=g_rvb[l_ac].rvb04
#                        AND alt15=g_rvb[l_ac].rvb03
#                     IF SQLCA.sqlcode=100 THEN
#                        CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
#                     LET g_rvb[l_ac].rvb04= g_rvb_t.rvb04            #No.MOD-840575 
#                     NEXT FIELD rvb04                               #No.MOD-840575 
#                     END IF
#                   END IF
#                 END IF  #No.MOD-840575 
#                 IF g_azw.azw04='2' THEN
#                    SELECT pmn14 INTO l_pmn14 FROM pmn_file 
#                        WHERE pmn01 = g_rvb[l_ac].rvb04
#                          AND pmn02 = g_rvb[l_ac].rvb03
#                    IF l_pmn14 = 'Y' THEN
#                      #TQC-B40126 Mod
#                      #SELECT COUNT(*) INTO l_n
#                      #   FROM rvb_file,rva_file 
#                      #  WHERE rvb04 = g_rvb[l_ac].rvb04
#                      #    AND rvb03 = g_rvb[l_ac].rvb03 
#                      #    AND rva01 = rvb01
#                      #    AND rva01 != g_rva.rva01
#                      #    AND rvaconf <> 'X'
#                       SELECT COUNT(*) INTO l_n1  #非本收货单上数量
#                          FROM rvb_file,rva_file 
#                         WHERE rvb04 = g_rvb[l_ac].rvb04
#                           AND rvb03 = g_rvb[l_ac].rvb03 
#                           AND rva01 = rvb01
#                           AND rva01 != g_rva.rva01
#                           AND rvaconf <> 'X'
#                       SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
#                          FROM rvb_file,rva_file 
#                         WHERE rvb04 = g_rvb[l_ac].rvb04
#                           AND rvb03 = g_rvb[l_ac].rvb03 
#                           AND rva01 = rvb01
#                           AND rva01 = g_rva.rva01
#                           AND rvb02 != g_rvb[l_ac].rvb02
#                           AND rvaconf <> 'X'
#                       LET l_n = l_n1 + l_n2
#                      #TQC-B40126 Mod--end
#                       SELECT sma134 INTO l_times FROM sma_file
#                       IF l_times IS NULL THEN LET l_times = 0 END IF
#                       #收貨次數是否已經超過參數設定的總次數
#                       IF l_n >= l_times THEN
#                          CALL cl_err('','apm-932',0)
#                          NEXT FIELD rvb04
#                       END IF
#                    END IF
#                    CALL t110_get_price()
#                 END IF
#               END IF
#               ###### 避免三角收貨到一般採購或逆拋三角
#               IF g_argv2 = 'TAP' THEN
#                  SELECT poz011 INTO l_poz011
#                    FROM pmm_file,poz_file
#                   WHERE pmm904 = poz01
#                     AND pmm01 = g_rvb[l_ac].rvb04
#                     AND pmm901 = 'Y'         #三角貿易否
#                     AND pmm905 = 'Y'         #已拋轉
#                     AND pmm02  = 'TAP'       #代採買性質
#                     AND pmm906 = 'Y'         #來源單據
#                  IF SQLCA.sqlcode THEN
#                     LET l_poz011 = ''
#                  END IF
#                  IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
#                     CALL cl_err(g_rva.rva02,'apm-014',0)
#                     NEXT FIELD rvb04  #No.9525
#                  END IF
#                  #----- 必須同一流程代碼 ----
#                  LET l_num =0
#                  DECLARE t110_chk1 CURSOR FOR
#                      SELECT pmm904 , pmm50
#                        FROM rvb_file,pmm_file
#                       WHERE rvb04 = pmm01
#                         AND rvb01 = g_rva.rva01
#                  FOREACH t110_chk1 INTO l_pmm904,l_pmm50
#                     IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
#                     LET l_num = l_num+1
#                     IF NOT cl_null(l_pmm904) THEN
#                        EXIT FOREACH
#                     END IF
#                  END FOREACH
#                  IF cl_null(l_pmm50) THEN LET l_pmm50=' ' END IF  #MOD-850093 add
#                  IF l_pmm904 <> g_pmm904 AND l_num > 0 THEN
#                     CALL cl_err('','axm-501',0)
#                     NEXT FIELD rvb04
#                  END IF
#                  IF l_pmm50  <> g_pmm50 AND l_num > 0 THEN #no.6113
#                     CALL cl_err('','apm-993',0)
#                     NEXT FIELD rvb04
#                  END IF
#                END IF
#            END IF   
#MOD-CB0079 -- mark end --
            #MOD-CB0079 -- add start --
            IF NOT t110_chk_rvb04(p_cmd) THEN
               NEXT FIELD rvb04
            END IF
            #MOD-CB0079 -- add end -- 

            CALL t110_set_no_entry_b('s')	#MOD-980043
            CALL t110_set_entry_rvb38()         #FUN-B50096
            CALL t110_set_no_entry_rvb38()      #FUN-B50096
 
         BEFORE FIELD rvb03     #採購項次
            LET l_rvb03_o = g_rvb[l_ac].rvb03   #MOD-B80084 add
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
 
         AFTER FIELD rvb03     #採購項次
            IF NOT cl_null(g_rvb[l_ac].rvb03) THEN
 
               #本段改為下面那段==>因為當有單頭無單身,此時按單身,則p_cmd='',則下面判斷式一定不會成立
               #IF p_cmd = 'a' OR (p_cmd ='u' AND
               #                  (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
               #                   g_rvb[l_ac].rvb03 != g_rvb_t.rvb03)) THEN
               IF (g_rvb_t.rvb03 IS NULL) OR (g_rvb_t.rvb04 IS NULL) OR
                  (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
                   g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) OR #MOD-B30090 THEN->OR
                   l_rvb03_o != g_rvb_t.rvb03 THEN #MOD-B30090 add
                  IF g_azw.azw04='2' THEN
                     SELECT pmn14 INTO l_pmn14 FROM pmn_file 
                         WHERE pmn01 = g_rvb[l_ac].rvb04
                           AND pmn02 = g_rvb[l_ac].rvb03
                     IF l_pmn14 = 'Y' THEN
                       #TQC-B40126 Mod
                       #SELECT COUNT(*) INTO l_n 
                       #   FROM rvb_file,rva_file 
                       #  WHERE rvb04 = g_rvb[l_ac].rvb04
                       #    AND rvb03 = g_rvb[l_ac].rvb03 
                       #    AND rva01 = rvb01
                       #    AND rvaconf <> 'X'
                        SELECT COUNT(*) INTO l_n1  #非本收货单上数量
                           FROM rvb_file,rva_file
                          WHERE rvb04 = g_rvb[l_ac].rvb04
                            AND rvb03 = g_rvb[l_ac].rvb03
                            AND rva01 = rvb01
                            AND rva01 != g_rva.rva01
                            AND rvaconf <> 'X'
                        SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
                           FROM rvb_file,rva_file
                          WHERE rvb04 = g_rvb[l_ac].rvb04
                            AND rvb03 = g_rvb[l_ac].rvb03
                            AND rva01 = rvb01
                            AND rva01 = g_rva.rva01
                            AND rvb02 != g_rvb[l_ac].rvb02
                            AND rvaconf <> 'X'
                        LET l_n = l_n1 + l_n2
                       #TQC-B40126 Mod--end
                        SELECT sma134 INTO l_times FROM sma_file
                        #收貨次數是否已經超過參數設定中的次數
                        IF l_n >= l_times THEN
                           CALL cl_err('','apm-932',0)
                           NEXT FIELD rvb03
                        END IF
                     END IF
                  END IF
                  IF NOT cl_null(g_rvb[l_ac].rvb03) THEN                          #No.FUN-810016
                    CALL t110_rvb03('a',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
#MOD-B80084 -- begin --
#                   #No.TQC-B60096--add--
#                   IF g_rvb[l_ac].rvb03 = g_rvb_t.rvb03 THEN
#                      LET g_rvb[l_ac].rvb07 = g_rvb_t.rvb07
#                   END IF
#                   #No.TQC-B60096--end--
#MOD-B80084 -- end --
                    IF g_rvb[l_ac].rvb07 <=0 THEN
                       IF NOT cl_confirm('mfg3353') THEN
                          LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03
                          NEXT FIELD rvb04
                       END IF
                    END IF
                  END IF                                              #No.FUN-810116
                  CALL t110_set_rvb87()     #No.TQC-6C0131 add
                  LET l_pmn20 = 0
                  SELECT pmn20,pmn87,pmn123 INTO l_pmn20,l_pmn87,l_pmn123 FROM pmn_file
                   WHERE pmn01=g_rvb[l_ac].rvb04
                     AND pmn02=g_rvb[l_ac].rvb03
                  #No.FUN-B40083  --begin
                  IF NOT cl_null(l_pmn123) THEN
                     LET g_rvb[l_ac].pmn123 = l_pmn123
                     SELECT mse02 INTO g_rvb[l_ac].mse02
                       FROM mse_file WHERE mse01= l_pmn123
                  ELSE
                     LET g_rvb[l_ac].pmn123 = ' '
                     LET g_rvb[l_ac].mse02 = ' '
                  END IF
                  #No.FUN-B40083  --end
                  LET l_rvb07_s = 0  
                  LET l_rvb87_s = 0
                 #SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file           #MOD-CA0161 mark
                  SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file,rva_file  #MOD-CA0161 add
                    WHERE rvb04=g_rvb[l_ac].rvb04
                      AND rvb03=g_rvb[l_ac].rvb03
                      AND (rvb01<>g_rva.rva01 OR
                          (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
                      AND rvb01 = rva01 AND rvaconf <> 'X' AND rvb35 = 'N'                      #MOD-CA0161 add
                  IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
                  IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
                  #FUN-C30166---begin
                  SELECT pmn65 INTO l_pmn65 FROM pmn_file
                   WHERE pmn01 = g_rvb[l_ac].rvb04
                     AND pmn02 = g_rvb[l_ac].rvb03
                  IF g_argv2 ='SUB' AND NOT cl_null(g_rvb[l_ac].rvb34) AND l_pmn65 <> '2' THEN 
                     SELECT sfb05 INTO l_sfb05 FROM sfb_file
                      WHERE sfb01 = g_rvb[l_ac].rvb34
                     CALL s_get_ima153(l_sfb05) RETURNING l_ima153
                    #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','')               #FUN-C70037 mark
                     CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)   #FUN-C70037
                          RETURNING g_cnt,g_min_set
                    #MOD-D30263 add start -----
                     SELECT SUM(rvv17) INTO l_rvv17_sum FROM rvu_file,rvv_file
                      WHERE rvu01 = rvv01 AND rvv03 = '3'
                        AND rvv36 = g_rvb[l_ac].rvb04 AND rvv37 = g_rvb[l_ac].rvb03
                    #MOD-D30263 add end   -----
                     #總已收量(不含本收貨單之其他同採購單號項次之收貨單數量)+本次實收量  不可大於  最小發料套數(使用s_minp計算)
                    #IF l_rvb07_s+g_rvb[l_ac].rvb07 > g_min_set THEN #MOD-D30263 mark
                     IF l_rvb07_s+g_rvb[l_ac].rvb07-l_rvv17_sum > g_min_set THEN #MOD-D30263 add
                        CALL cl_err('','apm1078',1)
                        LET g_rvb[l_ac].rvb07 = g_min_set - l_rvb07_s
                        IF g_rvb[l_ac].rvb07 < 0 THEN LET g_rvb[l_ac].rvb07 = 0 END IF 
                     END IF 
                  END IF 
                  #FUN-C30166---end
                  IF (l_rvb07_s+g_rvb[l_ac].rvb07) = l_pmn20 THEN
                     LET g_rvb[l_ac].rvb87 = l_pmn87 - l_rvb87_s
                  END IF
                   IF g_sma.sma116 MATCHES '[02]' THEN
                      LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
                   END IF
                  CALL t110_set_no_entry_b(p_cmd)   #No.FUN-610018
                  CALL t110_set_entry_rvb38()      #FUN-B50096
                  CALL t110_set_no_entry_rvb38()   #FUN-B50096
                END IF  #No.MOD-4B0275 end
                CALL t110_set_no_entry_b('s')
                CALL t110_set_entry_rvb38()      #FUN-B50096
                CALL t110_set_no_entry_rvb38()   #FUN-B50096
               IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
 
               LET g_rvb2.rvb10 = g_pmn31
               LET g_rvb2.rvb10t= g_pmn31t     #No.FUN-550117
                  IF p_cmd='a' OR (p_cmd='u' AND g_rvb[l_ac].rvb05!= g_rvb_t.rvb05) THEN    
                    LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a       
                    LET g_rvb[l_ac].rvb051=g_rvb[l_ac].rvb05b   #FUN-940083 pmn041-->rvb051
                    LET g_rvb[l_ac].ima021=g_rvb[l_ac].rvb05c      
                  END IF
                  LET g_rvb[l_ac].rvb10 = g_pmn31
                  LET g_rvb[l_ac].rvb10t= g_pmn31t     #No.FUN-550117
                  IF g_azw.azw04='2'  THEN                                                                           
                     CALL t110_get_price()
                  END IF
                   DISPLAY g_rvb[l_ac].rvb10  TO rvb10  #MOD-570294 重show一次避免沒跑ON ROW CHANGE
                   DISPLAY g_rvb[l_ac].rvb10t TO rvb10t #MOD-570294 重show一次避免沒跑ON ROW CHANGE
               IF NOT cl_null(g_errno) THEN
                  IF g_errno = 'mfg0159' THEN
                     LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03  #No.MOD-FUN-840575
                     LET g_errno =''                        #No.MOD-FUN-840575
                     NEXT FIELD rvb03 
                  ELSE
                     CALL cl_err(g_rvb[l_ac].rvb03,g_errno,0)
                     LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03  #No.MOD-FUN-840575 
                     LET g_errno =''                        #No.MOD-FUN-840575
                     NEXT FIELD rvb03
                  END IF
               END IF
               
 
               #不能部份交貨且已有交貨量則不允許通過
               IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
                  CALL cl_err('','mfg3339',0)
                  NEXT FIELD rvb03
               END IF
               #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
               IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04) THEN    #No.MOD-840575 
                 IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                   SELECT * FROM alt_file
                     WHERE alt01=g_rvb[l_ac].rvb22
                       AND alt14=g_rvb[l_ac].rvb04
                       AND alt15=g_rvb[l_ac].rvb03
                  IF SQLCA.sqlcode=100 THEN
                     CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
                     LET g_rvb[l_ac].rvb03= g_rvb_t.rvb03            #No.MOD-840575 
                     NEXT FIELD rvb03                                #No.MOD-840575 
                  END IF
                 END IF
              END IF                                             #No.FUN-840575 
            END IF
            LET l_direct = 'U'
            LET l_rvb03_o= g_rvb[l_ac].rvb03 #MOD-B30090 add
 
            # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
            LET l_ec_sw = 'N'
            IF g_argv2 ='SUB' THEN
               LET l_sfb24=''
               SELECT sfb24 INTO l_sfb24
                 FROM sfb_file
                WHERE sfb01 = g_rvb[l_ac].rvb34
               IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
                  LET l_ec_sw='Y'
               END IF
            END IF
            IF l_ec_sw='Y' THEN
               LET g_rvb[l_ac].rvb36=' '
               LET g_rvb[l_ac].rvb37=' '
               LET g_rvb[l_ac].rvb38=' '
               DISPLAY BY NAME g_rvb[l_ac].rvb36
               DISPLAY BY NAME g_rvb[l_ac].rvb37
               DISPLAY BY NAME g_rvb[l_ac].rvb38
               CALL cl_err('','mfg-021',0)
            END IF
            LET g_ima906 = NULL
            SELECT ima906 INTO g_ima906 FROM ima_file
             WHERE ima01=g_rvb[l_ac].rvb05
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096 
#FUN-A60035 ---MARK BEGIN
#         #No.FUN-A50054 -BEGIN-----
#          IF s_industry('slk') THEN
#         #NO.FUN-A60035--Begin
#             SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01= g_rvb[l_ac].rvb04
#             IF g_sma.sma120='Y' AND l_ima151='Y' THEN
#         #NO.FUN-A60035--End
#             IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04) THEN
#                IF p_cmd='a' OR (p_cmd='u' AND g_rvb_t.rvb03 <> g_rvb[l_ac].rvb03) THEN
#                   DELETE FROM ata_file 
#                    WHERE ata01 = g_rva.rva01
#                      AND ata02 = g_rvb[l_ac].rvb02
#                      AND ata00 = g_prog
#                   IF g_argv2 = 'SUB' THEN
#                      LET l_prog = 'apmt590_slk'
#                   ELSE   
#                      IF g_argv2 = 'TAP' THEN
#                         LET l_prog = 'apmt540_slk'
#                      ELSE 
#                         LET l_prog = 'apmt540_slk'
#                      END IF
#                   END IF
#                   DECLARE t110_ata5 CURSOR FOR
#                    SELECT * FROM ata_file
#                     WHERE ata00 = l_prog
#                       AND ata01 = g_rvb[l_ac].rvb04
#                    #   AND ata02 = g_rvb[l_ac].rvb02   #FUN-A60035 mark 改用採購單的項次
#                       AND ata02 = g_rvb[l_ac].rvb03    #FUN-A60035
#                   FOREACH t110_ata5  INTO l_ata.*
#                      IF STATUS THEN EXIT FOREACH END IF
#                      LET l_ata.ata00 = g_prog 
#                      LET l_ata.ata01 = g_rva.rva01
#                      LET l_ata.ata02 = g_rvb[l_ac].rvb02
#                      #FUN-A60035 ---mark begin 
#                      #SELECT MAX(ata03)+1 INTO l_ata.ata03 FROM ata_file
#                      # WHERE ata00 = g_prog
#                      #   AND ata01 = g_rva.rva01
#                      #IF cl_null(l_ata.ata03) OR l_ata.ata03 = 0 THEN
#                      #   LET l_ata.ata03 = 1
#                      #END IF
#                      #FUN-A60035 ---mark end
#                      INSERT INTO ata_file VALUES(l_ata.*)
#                   END FOREACH
#                END IF
#                CALL s_detail(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,g_rvb[l_ac].rvb05,'N')
#                   RETURNING g_rvb[l_ac].rvb07
#                DISPLAY BY NAME g_rvb[l_ac].rvb07
#                DISPLAY BY NAME g_rvb[l_ac].rvb05
#             END IF
#             END IF
#          END IF
#         #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
 
 
         AFTER FIELD rvb35     #樣品否
            IF NOT cl_null(g_rvb[l_ac].rvb35) THEN
              #IF g_rvb[l_ac].rvb35 NOT MATCHES '[YN]'THEN   #FUN-C60071 mark
               IF g_rvb[l_ac].rvb35 NOT MATCHES '[YNP]'THEN  #FUN-C60071 add
                  NEXT FIELD rvb35
               END IF
            END IF
 
         # ---- check 最小套數(以防未發料卻可入庫) ----#
         BEFORE FIELD rvb07    #收貨量
            SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93 FROM sfb_file       #No.FUN-610101 add sfb93
             WHERE sfb01 = g_rvb[l_ac].rvb34
            #MOD-D60063 add --start--
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM sfa_file
             WHERE sfa01 = g_rvb[l_ac].rvb34
               AND sfa03 = g_rvb[l_ac].rvb05
            #MOD-D60063 add --end--
            IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
              #IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN   # 委外 #CHI-B60084 mark
              #IF g_argv2 ='SUB' THEN   # 委外                               #CHI-B60084 #MOD-D60063 mark
               IF g_argv2 ='SUB' AND (g_rvb[l_ac].rvb05=l_sfb05 OR l_cnt=0 ) THEN   # 委外 #MOD-D60063 add 
                  LET g_min_set = 0
                 #CALL s_get_ima153(g_rvb[l_ac].rvb05) RETURNING l_ima153  #FUN-910053 #CHI-B60084 mark 
                  CALL s_get_ima153(l_sfb05) RETURNING l_ima153                        #CHI-B60084
                 #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','')  #FUN-910053  #FUN-A60027 #FUN-C70037 mark
                  CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)   #FUN-C70037 
                        RETURNING g_cnt,g_min_set
                  SELECT ima55 INTO l_ima55
                    FROM ima_file
                  #WHERE ima01 = g_rvb[l_ac].rvb05 #CHI-B60084 mark
                   WHERE ima01 = l_sfb05           #CHI-B60084
                 #CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 #CHI-B60084 mark 
                  CALL s_umfchk(l_sfb05,g_rvb[l_ac].rvb90,l_ima55)           #CHI-B60084
                       RETURNING g_i,l_fac
                  IF g_i = 1 THEN
                     #採購單位無法與料件的生產單位做換算,預設轉換率為1
                    #CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1) #CHI-B60084 mark
                     CALL cl_err(l_sfb05,'apm-120',1)           #CHI-B60084
                     LET l_fac = 1
                  END IF
                  LET g_min_set = g_min_set / l_fac
 
                  IF g_cnt !=0  THEN
                     CALL cl_err('s_minp()','asf-549',0)
                     NEXT FIELD rvb34
                  END IF
                  # 確認之(收貨-退貨)
#MOD-B90100 add --start--
#MOD-B90100 add --end--
                  #主料    
                  SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
                   WHERE rvb34 = g_rvb[l_ac].rvb34
                     AND rvb01 = rva01 AND rvaconf<>'X'    #MOD-790062 modify 排除作廢單據
                    #AND rvb05 = g_rvb[l_ac].rvb05 AND rvb35='N' #CHI-B60084 mark
                     AND rvb05 = l_sfb05 AND rvb35='N'           #CHI-B60084
                     AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)  #MOD-790062 排除本張單正在輸入的項次
                     AND rvb04 = g_rvb[l_ac].rvb04   #MOD-850311
                     AND rvb03 = g_rvb[l_ac].rvb03   #MOD-850311

                  #CHI-B60084 add --start--
                  #聯產品                
                  SELECT SUM(rvb07-rvb29) INTO conf_qty1 FROM rvb_file,rva_file,bmm_file
                   WHERE rvb34 = g_rvb[l_ac].rvb34
                     AND rvb01 = rva01 AND rvaconf<>'X'
                     AND bmm01 = l_sfb05
                     AND rvb05 = bmm03 AND rvb35='N'
                     AND bmm05='Y'
                     AND bmm01 <> bmm03 
                     AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01) 
                     AND rvb04 = g_rvb[l_ac].rvb04   
                     AND rvb03 = g_rvb[l_ac].rvb03   
                  #CHI-B60084 add --end--
#MOD-B90100 add --start--
#MOD-B90100 add --end--
 
                  IF conf_qty IS NULL THEN LET conf_qty=0 END IF
                  IF conf_qty1 IS NULL THEN LET conf_qty1=0 END IF #CHI-B60084 add
                 #LET g_min_set=g_min_set-conf_qty                 #CHI-B60084 mark
                  LET g_min_set=g_min_set-conf_qty-conf_qty1       #CHI-B60084
#-----MOD-AB0227---------
#-----END MOD-AB0227-----
                  #ERROR "最小套數:",g_min_set        #MOD-530700
                   CALL cl_err(g_min_set,'aqc-426',0) #MOD-530700
               END IF
 
               ## 委外採購若有部分交貨應以QPA計算實收數量
               IF g_argv2 = 'SUB' AND g_pmn14 = 'Y' THEN
                  IF NOT cl_null(g_rvb[l_ac].rvb34) THEN  #委外工單
                     INITIALIZE l_sfa.* TO NULL
                     SELECT sfa_file.* INTO l_sfa.* FROM sfa_file,pmn_file
                      WHERE pmn01 = g_rvb[l_ac].rvb04
                        AND pmn02 = g_rvb[l_ac].rvb03
                        AND sfa01 = g_rvb[l_ac].rvb34
                        AND sfa03 = g_rvb[l_ac].rvb05
                        AND pmn65 = '2'  #代買
                  END IF
               END IF
            END IF
 
         AFTER FIELD rvb07     #實收數量
            #No.FUN-BB0086--add--begin--
            LET g_rvb[l_ac].rvb07 = s_digqty(g_rvb[l_ac].rvb07,g_rvb[l_ac].rvb90)  
            DISPLAY BY NAME g_rvb[l_ac].rvb07
            #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_rvb[l_ac].rvb07) THEN
               IF g_rvb[l_ac].rvb07 <=0 THEN
                  CALL cl_err('','mfg3348',0)   #MOD-890170
                  NEXT FIELD rvb07
               END IF
               IF cl_null(g_pmn13) THEN   #超交率
                  LET g_pmn13 = 0
               END IF
               IF cl_null(g_pmn50_55) THEN
                  LET g_pmn50_55 = 0
               END IF
               LET g_pmn20 = g_rvb[l_ac].pmn20    #MOD-C30364  add 
 
                  SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb_t.rvb02)     #MOD-CC0096 add
                    #AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02) #MOD-CC0096 mark
               IF cl_null(l_rvb07_3) THEN
                  LET l_rvb07_3 = 0
               END IF
 
               #計算已交量
               LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb[l_ac].rvb07
               LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
                LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100     #MOD-530021 #最少可交貨量
 
 
               # 若為LC收貨，則須檢查數貨不可大於提單數量
               IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                  SELECT alt06 INTO l_alt06 FROM alt_file
                   WHERE alt01=g_rvb[l_ac].rvb22
                     AND alt14=g_rvb[l_ac].rvb04
                     AND alt15=g_rvb[l_ac].rvb03
                  IF cl_null(l_alt06) THEN
                     LET l_alt06 = 0
                  END IF
                  SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
                   WHERE rvb22=g_rvb[l_ac].rvb22
                     AND rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvb01!=g_rva.rva01
                     AND rvb35='N'
                  IF cl_null(t_alt06) THEN
                     LET t_alt06 = 0
                  END IF
                  IF g_rvb[l_ac].rvb07 > (l_alt06-t_alt06) THEN
                     CALL cl_err('','apm-305',0)
                     NEXT FIELD rvb07
                  END IF
               END IF

               #MOD-CA0124 add start -----
               SELECT pmn65 INTO l_pmn65 FROM pmn_file
                WHERE pmn01 = g_rvb[l_ac].rvb04
                  AND pmn02 = g_rvb[l_ac].rvb03
               #MOD-CA0124 add end   -----
 
               IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
                  IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
                      IF l_rvb07_2 > l_rvb07 THEN #短交 #MOD-530021
                        IF g_sma.sma85 MATCHES '[Rr]' THEN
                           CALL cl_err(l_rvb07_2,'mfg3038',0)
                           NEXT FIELD rvb07
                        ELSE
                           CALL cl_err(l_rvb07_2,'mfg9120',1)
                        END IF
                     END IF
                     ######  樣品不檢查
                    #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019委外不檢查超交             #MOD-CA0124 mark
                     IF g_rvb[l_ac].rvb35 = 'N' AND (l_pmn65 = '2' OR (g_rva.rva10 != 'SUB' AND l_pmn65 = '1')) THEN #MOD-CA0124 add
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]'  THEN
                               CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                              NEXT FIELD rvb07
                           ELSE
                               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
                           END IF
                        END IF
                     END IF
                  END IF
                  IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
                     ######  樣品不檢查
                    #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN #CHI-6B0019委外不檢查超交              #MOD-CA0124 mark  
                     IF g_rvb[l_ac].rvb35 = 'N' AND (l_pmn65 = '2' OR (g_rva.rva10 != 'SUB' AND l_pmn65 = '1')) THEN #MOD-CA0124 add
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]' THEN
                               CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                              NEXT FIELD rvb07
                           ELSE
                               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
 
               IF g_pmn13 < 0 THEN    #控制超短交
                  IF g_pmn14 = 'N' THEN   #不能部份交貨
                     IF l_rvb07 - g_pmn20 < 0 THEN      #須>= 訂購量
                        CALL cl_err(l_rvb07,'mfg3335',0)
                        NEXT FIELD rvb07
                     END IF
                  END IF
               END IF
 
               #-->確認之(收貨-退貨)
               #MOD-D60063 add --start--
               LET l_cnt = 0
               SELECT count(*) INTO l_cnt FROM sfa_file
                WHERE sfa01 = g_rvb[l_ac].rvb34
                  AND sfa03 = g_rvb[l_ac].rvb05
               #MOD-D60063 add --end--
               IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
                #IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN #CHI-B60084 mark
                #IF g_argv2 ='SUB' THEN                               #CHI-B60084 #MOD-D60063 mark
                 IF g_argv2 ='SUB' AND (g_rvb[l_ac].rvb05=l_sfb05 OR l_cnt=0 ) THEN #MOD-D60063 add
                    IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
                       IF g_rvb[l_ac].rvb07 > g_min_set THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                          NEXT FIELD rvb07
                       END IF
                    ELSE
                       IF g_rvb[l_ac].rvb07 > g_rvb[l_ac].pmn20 - conf_qty THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-070',1)
                          NEXT FIELD rvb07
                       END IF
                    END IF
                 END IF
               END IF
#CHI-B80038 -- begin --
               IF g_argv6 = '2' THEN
                  IF g_rvb[l_ac].rvb07 != g_rvb_t.rvb07 OR cl_null(g_rvb_t.rvb07) THEN
                     CALL s_defprice_new(g_rvb[l_ac].rvb05,g_rva.rva05,
                                         g_rva.rva113,g_rva.rva06,g_rvb[l_ac].rvb87,'',
                                         g_rva.rva115,g_rva.rva116,'1',g_rvb[l_ac].rvb90,
                                         '',g_rva.rva112,g_rva.rva111,g_plant)
                          RETURNING g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t,
                                    g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43
                  END IF
               END IF
#CHI-B80038 -- end --
           #FUN-C30248 add START
           #當委外採購單的所對應到的代買類別為一般採購時詢問是否依實收量自動帶出代買採購單資料及數量
            IF p_cmd = 'a'
              OR (g_rvb[l_ac].rvb07 <> g_rvb_t.rvb07 AND p_cmd = 'u') THEN
               LET g_rvb07 = g_rvb[l_ac].rvb07     
               LET g_rvb04 = g_rvb[l_ac].rvb04 
               LET g_pmn41 = ''
               LET l_pmn65 = ''
               SELECT pmn41,pmn65 INTO g_pmn41,l_pmn65 FROM pmn_file
                   WHERE pmn01 = g_rvb[l_ac].rvb04
                     AND pmn02 = g_rvb[l_ac].rvb03 
               IF l_pmn65 = '1' AND NOT cl_null(g_pmn41) THEN   
                  IF cl_confirm('apm-819') THEN
                     LET g_flag2 = 'Y'
                     LET g_rvb_t.* = g_rvb[l_ac].*  
                    #先刪除相同採購單號,相同工單單號的資料
                     LET l_n = 0 
                     SELECT COUNT(*) INTO l_n FROM rvb_file   #先計算總刪除的筆數
                         WHERE rvb01 = g_rva.rva01
                           AND rvb04 = g_rvb[l_ac].rvb04
                           AND rvb03 IN (SELECT pmn02 FROM pmn_file
                                           WHERE pmn01 = g_rvb[l_ac].rvb04 
                                             AND pmn41 = g_pmn41 )
                     DELETE FROM rvb_file 
                      WHERE rvb01 = g_rva.rva01 
                        AND rvb04 = g_rvb[l_ac].rvb04  
                        AND rvb03 IN (SELECT pmn02 FROM pmn_file 
                                        WHERE pmn01 = g_rvb[l_ac].rvb04 
                                          AND pmn41 = g_pmn41 ) 
                    #TQC-D30011---add---S
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","del rvb",1)
                        ROLLBACK WORK
                        RETURN      
                     ELSE
                        IF NOT s_del_rvbi(g_rva.rva01,g_rvb_t.rvb02,'') THEN
                           ROLLBACK WORK
                           RETURN 
                        END IF
                     END IF
                    #TQC-D30011---add---E

                      LET g_rec_b = g_rec_b - l_n    
                      IF g_rec_b < 0 THEN
                         LET g_rec_b = 0 
                      END IF
                      CALL t110_g_b() 
                      EXIT INPUT     #跑完批次後直接Exit input
                  END IF
               END IF
            END IF 
           #FUN-C30248 add END 
            END IF
       
            CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
            IF l_ec_sw = 'N' THEN      #CHI-A80024
               SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05
                  AND imaacti = "Y"
               
               IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                     IF cl_null(g_rvb[l_ac].rvb37) THEN
                        LET g_rvb[l_ac].rvb37 = ' '
                     END IF
                     IF cl_null(g_rvb[l_ac].rvb38) THEN
                        LET g_rvb[l_ac].rvb38 = ' '
                     END IF
                     SELECT img09 INTO g_img09
                       FROM img_file   #庫存單位
                      WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                        AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                     CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)  #No.FUN-940083 pmn07-->rvb90 
                          RETURNING l_i,l_fac
                     IF l_i = 1 THEN LET l_fac = 1 END IF
                     #CHI-9A0022 --Begin
                     LET l_bno = ''
                     SELECT pmn122 INTO l_bno
                       FROM pmn_file
                      WHERE pmn01 = g_rvb[l_ac].rvb04
                        AND pmn02 = g_rvb[l_ac].rvb03
                     IF cl_null(l_bno) THEN
                        LET l_bno = ''
                     END IF
                     #CHI-9A0022 --End
                     CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236---mark---begin
#                    CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
#                                 g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,   #No.FUN-940083 pmn07-->rvb90 
#                                 l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD')#CHI-9A0022 add ''
#TQC-B90236---mark---end
#TQC-B90236---add----begin
                     IF g_ima930 = 'N' THEN                                        #DEV-D30059
                        CALL s_mod_lot(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                                       g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                       g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                       g_rvb[l_ac].rvb90,g_img09,l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD',1)
#TQC-B90236---add----end
                           RETURNING l_r,g_qty 
                     END IF                                                        #DEV-D30059
                     IF l_r = "Y" THEN
                        LET g_rvb[l_ac].rvb07 = g_qty
                        #-----MOD-AB0076---------
                        DISPLAY BY NAME g_rvb[l_ac].rvb07 
                        CALL t110_set_rvb87()
                        IF g_sma.sma116 MATCHES '[02]' THEN
                           LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
                        END IF
                        #-----END MOD-AB0076-----
                     END IF
                  END IF     #FUN-850120
               END IF
            END IF   #CHI-A80024 
            IF cl_null(g_rvb[l_ac].rvb86) THEN
               LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90                        #No.FUN-940083 pmn07-->rvb90 
               LET g_rvb[l_ac].rvb87=g_rvb[l_ac].rvb07
            END IF
 
          ON CHANGE rvb07
               CALL t110_set_rvb87()
               IF g_sma.sma116 MATCHES '[02]' THEN
                  LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
               END IF
               LET l_pmn20 = 0
               SELECT pmn20,pmn87 INTO l_pmn20,l_pmn87 FROM pmn_file
                WHERE pmn01=g_rvb[l_ac].rvb04
                  AND pmn02=g_rvb[l_ac].rvb03
               LET l_rvb07_s = 0  
               LET l_rvb87_s = 0
              #SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file           #MOD-CA0161 mark 
               SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file,rva_file  #MOD-CA0161 add
                 WHERE rvb04=g_rvb[l_ac].rvb04
                   AND rvb03=g_rvb[l_ac].rvb03
                   AND (rvb01<>g_rva.rva01 OR
                       (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
                   AND rvb01 = rva01 AND rvaconf <> 'X' AND rvb35 = 'N'                      #MOD-CA0161 add
               IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
               IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
               #FUN-C30166---begin
               SELECT pmn65 INTO l_pmn65 FROM pmn_file
                WHERE pmn01 = g_rvb[l_ac].rvb04
                  AND pmn02 = g_rvb[l_ac].rvb03
               IF g_argv2 ='SUB' AND NOT cl_null(g_rvb[l_ac].rvb34) AND l_pmn65 <> '2' THEN 
                  SELECT sfb05 INTO l_sfb05 FROM sfb_file
                   WHERE sfb01 = g_rvb[l_ac].rvb34
                  CALL s_get_ima153(l_sfb05) RETURNING l_ima153
                 #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','')                #FUN-C70037 mark
                  CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)    #FUN-C70037
                       RETURNING g_cnt,g_min_set
                 #MOD-D30263 add start -----
                  SELECT SUM(rvv17) INTO l_rvv17_sum FROM rvu_file,rvv_file
                   WHERE rvu01 = rvv01 AND rvv03 = '3'
                     AND rvv36 = g_rvb[l_ac].rvb04 AND rvv37 = g_rvb[l_ac].rvb03
                 #MOD-D30263 add end   -----
                  #總已收量(不含本收貨單之其他同採購單號項次之收貨單數量)+本次實收量  不可大於  最小發料套數(使用s_minp計算)
                 #IF l_rvb07_s+g_rvb[l_ac].rvb07 > g_min_set THEN #MOD-D30263 mark
                  IF l_rvb07_s+g_rvb[l_ac].rvb07-l_rvv17_sum > g_min_set THEN #MOD-D30263 add
                     CALL cl_err('','apm1078',1)
                     LET g_rvb[l_ac].rvb07 = g_min_set - l_rvb07_s
                     IF g_rvb[l_ac].rvb07 < 0 THEN LET g_rvb[l_ac].rvb07 = 0 END IF 
                  END IF 
               END IF 
               #FUN-C30166---end
               IF (l_rvb07_s+g_rvb[l_ac].rvb07) = l_pmn20 THEN
                  LET g_rvb[l_ac].rvb87 = l_pmn87 - l_rvb87_s
               END IF
 
         BEFORE FIELD rvb85
            IF cl_null(g_rvb[l_ac].rvb83) THEN
               LET g_rvb[l_ac].rvb85= NULL
            END IF
 
         AFTER FIELD rvb85     #第二數量
            #No.FUN-BB0086--add--begin--
            LET g_rvb[l_ac].rvb85 = s_digqty(g_rvb[l_ac].rvb85,g_rvb[l_ac].rvb83)  
            DISPLAY BY NAME g_rvb[l_ac].rvb85
            #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_rvb[l_ac].rvb85) THEN
               IF g_rvb[l_ac].rvb85 <0 THEN
                  NEXT FIELD rvb85
               END IF
               IF cl_null(g_rvb[l_ac].rvb83) THEN
                  LET g_rvb[l_ac].rvb85= NULL
               END IF
            END IF
               IF g_ima906='3' THEN
                  LET g_tot=g_rvb[l_ac].rvb85*g_rvb[l_ac].rvb84
                  IF cl_null(g_rvb[l_ac].rvb82) OR g_rvb[l_ac].rvb82=0 THEN  #CHI-960022
                     LET g_rvb[l_ac].rvb82=g_tot*g_rvb[l_ac].rvb81
                     DISPLAY BY NAME g_rvb[l_ac].rvb82                       #CHI-960022
                  END IF                                                     #CHI-960022
               END IF
            IF cl_null(g_rvb_t.rvb85) AND g_rvb[l_ac].rvb85 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb85) AND cl_null(g_rvb[l_ac].rvb85) THEN
               CALL t110_set_rvb87()
            END IF
            CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
            IF l_ec_sw = 'N' THEN      #CHI-A80024
               SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05
                  AND imaacti = "Y"
               
               IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                     IF cl_null(g_rvb[l_ac].rvb37) THEN
                        LET g_rvb[l_ac].rvb37 = ' '
                     END IF
                     IF cl_null(g_rvb[l_ac].rvb38) THEN
                        LET g_rvb[l_ac].rvb38 = ' '
                     END IF
                     SELECT img09 INTO g_img09
                       FROM img_file   #庫存單位
                      WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                        AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                     CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)   #No.FUN-940083 pmn07-->rvb90 
                          RETURNING l_i,l_fac
                     IF l_i = 1 THEN LET l_fac = 1 END IF
                     #CHI-9A0022 --Begin
                     LET l_bno = ''
                     SELECT pmn122 INTO l_bno
                       FROM pmn_file
                      WHERE pmn01 = g_rvb[l_ac].rvb04
                        AND pmn02 = g_rvb[l_ac].rvb03
                     IF cl_null(l_bno) THEN
                        LET l_bno = ''
                     END IF
                     #CHI-9A0022 --End
                     CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236---mark---begin
#                    CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
#                                 g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,    #No.FUN-940083 pmn07-->rvb90 
#                                 l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark---end
#TQC-B90236---add----begin
                     IF g_ima930 = 'N' THEN                                        #DEV-D30059
                        CALL s_mod_lot(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                                       g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                       g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                       g_rvb[l_ac].rvb90,g_img09,l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD',1)
#TQC_B90236---add----end
                           RETURNING l_r,g_qty 
                     END IF                                                        #DEV-D30059
                     IF l_r = "Y" THEN
                        LET g_rvb[l_ac].rvb07 = g_qty
                        #-----MOD-AB0076---------
                        DISPLAY BY NAME g_rvb[l_ac].rvb07 
                        CALL t110_set_rvb87()
                        IF g_sma.sma116 MATCHES '[02]' THEN
                           LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
                        END IF
                        #-----END MOD-AB0076-----
                     END IF
                  END IF     #FUN-850120
               END IF
            END IF   #CHI-A80024
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         AFTER FIELD rvb82     #第一數量
            #No.FUN-BB0086--add--begin--
            LET g_rvb[l_ac].rvb82 = s_digqty(g_rvb[l_ac].rvb82,g_rvb[l_ac].rvb80)  
            DISPLAY BY NAME g_rvb[l_ac].rvb82
            #No.FUN-BB0086--add--end--
            IF NOT cl_null(g_rvb[l_ac].rvb82) THEN
               IF g_rvb[l_ac].rvb82 <0 THEN
                  NEXT FIELD rvb82
               END IF
               IF cl_null(g_rvb[l_ac].rvb80) THEN
                  LET g_rvb[l_ac].rvb82= NULL
               END IF
            END IF
            IF cl_null(g_rvb[l_ac].rvb85) AND cl_null(g_rvb[l_ac].rvb82) THEN
               NEXT FIELD rvb82
            END IF
            IF g_rvb[l_ac].rvb85=0 AND g_rvb[l_ac].rvb82=0 THEN
               IF g_ima906 MATCHES '[23]' THEN
                  NEXT FIELD rvb85
               ELSE
                  NEXT FIELD rvb82
               END IF
            END IF
            CALL t110_set_origin_field()
            # ---- check 最小套數(以防未發料卻可入庫) ----#
            SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93 FROM sfb_file    #NO.TQC-670091 add sfb93
             WHERE sfb01 = g_rvb[l_ac].rvb34
            #MOD-D60063 add --start--
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM sfa_file
             WHERE sfa01 = g_rvb[l_ac].rvb34
               AND sfa03 = g_rvb[l_ac].rvb05
            #MOD-D60063 add --end--
            IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
              #IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN   # 委外 #CHI-B60084 mark
              #IF g_argv2 ='SUB' THEN   # 委外                               #CHI-B60084 #MOD-D60063 mark
               IF g_argv2 ='SUB' AND (g_rvb[l_ac].rvb05=l_sfb05 OR l_cnt=0 ) THEN   # 委外 #MOD-D60063 add 
                  LET g_min_set = 0
                 #CALL s_get_ima153(g_rvb[l_ac].rvb05) RETURNING l_ima153  #FUN-910053 #CHI-B60084 mark
                  CALL s_get_ima153(l_sfb05) RETURNING l_ima153                        #CHI-B60084
                 #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','')  #FUN-910053  #FUN-A60027 #FUN-C70037 mark
                  CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)   #FUN-C70037 
                        RETURNING g_cnt,g_min_set
                  SELECT ima55 INTO l_ima55
                    FROM ima_file
                  #WHERE ima01 = g_rvb[l_ac].rvb05 #CHI-B60084 mark
                   WHERE ima01 = l_sfb05          #CHI-B60084
                 #CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 #CHI-B60084 mark 
                  CALL s_umfchk(l_sfb05,g_rvb[l_ac].rvb90,l_ima55)           #CHI-B60084
                       RETURNING g_i,l_fac
                  IF g_i = 1 THEN
                     #採購單位無法與料件的生產單位做換算,預設轉換率為1
                    #CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1) #CHI-B60084 mark
                     CALL cl_err(l_sfb05,'apm-120',1)           #CHI-B60084
                     LET l_fac = 1
                  END IF
                  LET g_min_set = g_min_set / l_fac
 
                  IF g_cnt !=0  THEN
                     CALL cl_err('s_minp()','asf-549',0)
                     NEXT FIELD rvb34
                  END IF                  
                     SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
                      WHERE rvb34 = g_rvb[l_ac].rvb34
                        AND rvb01 = rva01 AND rvaconf<>'X'    #MOD-790062 modify 排除作廢單據
                       #AND rvb05 = g_rvb[l_ac].rvb05 AND rvb35='N' #CHI-B60084 mark
                        AND rvb05 = l_sfb05 AND rvb35='N'           #CHI-B60084
                        AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)  #MOD-790062 排除本張單正在輸入的項次
                        AND rvb04 = g_rvb[l_ac].rvb04   #MOD-850311
                        AND rvb03 = g_rvb[l_ac].rvb03   #MOD-850311

                     #CHI-B60084 add --start--
                     #聯產品
                     SELECT SUM(rvb07-rvb29) INTO conf_qty1 FROM rvb_file,rva_file,bmm_file
                      WHERE rvb34 = g_rvb[l_ac].rvb34
                        AND rvb01 = rva01 AND rvaconf<>'X'
                        AND bmm01 = l_sfb05
                        AND rvb05 = bmm03 AND rvb35='N'
                        AND bmm05='Y'
                        AND bmm01 <> bmm03                                        #MOD-B80190 add
                        AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)
                        AND rvb04 = g_rvb[l_ac].rvb04
                        AND rvb03 = g_rvb[l_ac].rvb03
                     #CHI-B60084 add --end--
                  IF conf_qty IS NULL THEN LET conf_qty=0 END IF
                  IF conf_qty1 IS NULL THEN LET conf_qty1=0 END IF #CHI-B60084 add
                 #LET g_min_set=g_min_set-conf_qty                 #CHI-B60084 mark
                  LET g_min_set=g_min_set-conf_qty-conf_qty1       #CHI-B60084
#-----MOD-AC0114---------
#-----END MOD-AC0114-----
                  #ERROR "最小套數:",g_min_set        #MOD-530700
                   CALL cl_err(g_min_set,'aqc-426',0) #MOD-530700
               END IF
 
               ## 委外採購若有部分交貨應以QPA計算實收數量
               IF g_argv2 = 'SUB' AND g_pmn14 = 'Y' THEN
                  IF NOT cl_null(g_rvb[l_ac].rvb34) THEN  #委外工單
                     INITIALIZE l_sfa.* TO NULL
                     SELECT sfa_file.* INTO l_sfa.* FROM sfa_file,pmn_file
                      WHERE pmn01 = g_rvb[l_ac].rvb04
                        AND pmn02 = g_rvb[l_ac].rvb03
                        AND sfa01 = g_rvb[l_ac].rvb34
                        AND sfa03 = g_rvb[l_ac].rvb05
                        AND pmn65 = '2'  #代買
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_rvb[l_ac].rvb07) THEN
               IF g_rvb[l_ac].rvb07 <=0 THEN
                  IF g_ima906 MATCHES '[23]' THEN
                     NEXT FIELD rvb85
                  ELSE
                     NEXT FIELD rvb82
                  END IF
               END IF
               IF cl_null(g_pmn13) THEN   #超交率
                  LET g_pmn13 = 0
               END IF
               IF cl_null(g_pmn50_55) THEN
                  LET g_pmn50_55 = 0
               END IF
               LET g_pmn20 = g_rvb[l_ac].pmn20
 
                  SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
               IF cl_null(l_rvb07_3) THEN
                  LET l_rvb07_3 = 0
               END IF
 
               #計算已交量
               LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb[l_ac].rvb07
               LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
               LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100   #MOD-890147
               
 
               # 若為LC收貨，則須檢查數貨不可大於提單數量
               IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                  SELECT alt06 INTO l_alt06 FROM alt_file
                   WHERE alt01=g_rvb[l_ac].rvb22
                     AND alt14=g_rvb[l_ac].rvb04
                     AND alt15=g_rvb[l_ac].rvb03
                  IF cl_null(l_alt06) THEN
                     LET l_alt06 = 0
                  END IF
                     SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01!=g_rva.rva01
                        AND rvb35='N'
                  IF cl_null(t_alt06) THEN
                     LET t_alt06 = 0
                  END IF
                  IF g_rvb[l_ac].rvb07 > (l_alt06-t_alt06) THEN
                     CALL cl_err('','apm-305',0)
                     IF g_ima906 MATCHES '[23]' THEN
                        NEXT FIELD rvb85
                     ELSE
                        NEXT FIELD rvb82
                     END IF
                  END IF
               END IF

               #MOD-CA0124 add start -----
               SELECT pmn65 INTO l_pmn65 FROM pmn_file
                WHERE pmn01 = g_rvb[l_ac].rvb04
                  AND pmn02 = g_rvb[l_ac].rvb03
               #MOD-CA0124 add end   -----
 
               IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
                  IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
                     IF l_rvb07_2 > l_rvb07 THEN #短交   #MOD-890147
                        IF g_sma.sma85 MATCHES '[Rr]' THEN
                           CALL cl_err(l_rvb07_2,'mfg3038',0)
                           IF g_ima906 MATCHES '[23]' THEN
                              NEXT FIELD rvb85
                           ELSE
                              NEXT FIELD rvb82
                           END IF
                        ELSE
                           CALL cl_err(l_rvb07_2,'mfg9120',1)
                        END IF
                     END IF
                     ###### Tommy 樣品不檢查
                    #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019委外不檢查超交             #MOD-CA0124 mark
                     IF g_rvb[l_ac].rvb35 = 'N' AND (l_pmn65 = '2' OR (g_rva.rva10 != 'SUB' AND l_pmn65 = '1')) THEN #MOD-CA0124 add
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]' THEN
                              CALL cl_err(l_rvb07_1,'mfg3037',1)  #No.TQC-6C0091 0->1   #MOD-890147 l_rvb07_2->l_rvb07_1
                              IF g_ima906 MATCHES '[23]' THEN
                                 NEXT FIELD rvb85
                              ELSE
                                 NEXT FIELD rvb82
                              END IF
                           ELSE
                              CALL cl_err(l_rvb07_1,'mfg9121',1)   #MOD-890147 l_rvb07_2->l_rvb07_1
                           END IF
                        END IF
                     END IF
                  END IF
                  IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
                     ######  Tommy 樣品不檢查
                    #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019 委外不檢查超交            #MOD-CA0124 mark 
                     IF g_rvb[l_ac].rvb35 = 'N' AND (l_pmn65 = '2' OR (g_rva.rva10 != 'SUB' AND l_pmn65 = '1')) THEN #MOD-CA0124 add
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]' THEN
                              CALL cl_err(l_rvb07_1,'mfg3037',1)  #No.TQC-6C0091 0->1   #MOD-890147 l_rvb07_2->l_rvb07_1
                              IF g_ima906 MATCHES '[23]' THEN
                                 NEXT FIELD rvb85
                              ELSE
                                 NEXT FIELD rvb82
                              END IF
                           ELSE
                              CALL cl_err(l_rvb07_1,'mfg9121',1)   #MOD-890147 l_rvb07_2->l_rvb07_1
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
 
               IF g_pmn13 < 0 THEN    #控制超短交
                  IF g_pmn14 = 'N' THEN   #不能部份交貨
                     IF l_rvb07 - g_pmn20 < 0 THEN      #須>= 訂購量
                        CALL cl_err(l_rvb07,'mfg3335',0)
                        IF g_ima906 MATCHES '[23]' THEN
                           NEXT FIELD rvb85
                        ELSE
                           NEXT FIELD rvb82
                        END IF
                     END IF
                  END IF
               END IF
 
               #-->確認之(收貨-退貨)
               IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
                 IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN
                    IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
                       CALL t110_minp(g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04,
                                      g_rvb[l_ac].rvb34,g_rvb[l_ac].rvb05) RETURNING l_min_set #FUN-910053
 
                       CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 
                            RETURNING g_i,l_fac
                       IF g_i = 1 THEN
                          #採購單位無法與料件的生產單位做換算,預設轉換率為1
                          CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1)
                          LET l_fac = 1
                       END IF
                       LET l_min_set = l_min_set / l_fac
                       #IF g_rvb[l_ac].rvb07 > l_min_set THEN     #MOD-AC0114
                       IF g_rvb[l_ac].rvb07 > g_min_set THEN     #MOD-AC0114
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                          IF g_ima906 MATCHES '[23]' THEN
                             NEXT FIELD rvb85
                          ELSE
                             NEXT FIELD rvb82
                          END IF
                       END IF
                    ELSE
                       IF g_rvb[l_ac].rvb07 > g_rvb[l_ac].pmn20 - conf_qty THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-070',1)
                          IF g_ima906 MATCHES '[23]' THEN
                             NEXT FIELD rvb85
                          ELSE
                             NEXT FIELD rvb82
                          END IF
                       END IF
                    END IF
                 END IF
               END IF
            END IF
            IF cl_null(g_rvb_t.rvb82) AND g_rvb[l_ac].rvb82 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb82) AND cl_null(g_rvb[l_ac].rvb82) OR
               g_rvb_t.rvb82 <> g_rvb[l_ac].rvb82 THEN
               CALL t110_du_data_to_correct()
               CALL t110_set_rvb87()
 
            END IF
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           
         BEFORE FIELD rvb87
            IF cl_null(g_rvb_t.rvb85) AND g_rvb[l_ac].rvb85 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb85) AND cl_null(g_rvb[l_ac].rvb85) OR
               g_rvb_t.rvb85 <> g_rvb[l_ac].rvb85 OR
               cl_null(g_rvb_t.rvb82) AND g_rvb[l_ac].rvb82 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb82) AND cl_null(g_rvb[l_ac].rvb82) OR
               g_rvb_t.rvb82 <> g_rvb[l_ac].rvb82 THEN
               CALL t110_du_data_to_correct()
               CALL t110_set_rvb87()
            END IF
 
        AFTER FIELD rvb87  #計價數量
            #No.FUN-BB0086--add--begin--
            LET g_rvb[l_ac].rvb87 = s_digqty(g_rvb[l_ac].rvb87,g_rvb[l_ac].rvb86)  
            DISPLAY BY NAME g_rvb[l_ac].rvb87
            #No.FUN-BB0086--add--end--
           IF NOT cl_null(g_rvb[l_ac].rvb87) THEN
              IF g_rvb[l_ac].rvb87 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD rvb87
              END IF
#CHI-B80038 -- begin --
              IF g_argv6 = '2' THEN
                 IF g_rvb[l_ac].rvb87 != g_rvb_t.rvb87 OR cl_null(g_rvb_t.rvb87) THEN
                    CALL s_defprice_new(g_rvb[l_ac].rvb05,g_rva.rva05,
                                        g_rva.rva113,g_rva.rva06,g_rvb[l_ac].rvb87,'',
                                        g_rva.rva115,g_rva.rva116,'1',g_rvb[l_ac].rvb90,
                                        '',g_rva.rva112,g_rva.rva111,g_plant)
                         RETURNING g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t,
                                   g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43
                 END IF
              END IF
#CHI-B80038 -- end --
           END IF
 
         BEFORE FIELD rvb36
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
            IF  g_rvb[l_ac].rvb89 = 'Y' THEN 
               CALL cl_set_comp_entry("rvb36,rvb37",FALSE )
               SELECT pmc915,pmc916 INTO l_pmc915,l_pmc916 
                 FROM pmc_file 
                WHERE pmc01 = g_rva.rva05
#FUN-AB0066 --begin--               
#               #No.FUN-AA0049--begin
#               IF NOT s_chk_ware(l_pmc915) THEN
#                  LET l_pmc915=' '
#                  LET l_pmc916=' '
#               END IF 
#               #No.FUN-AA0049--end                  
#FUN-AB0066 --end--               
               LET g_rvb[l_ac].rvb36 = l_pmc915
               LET g_rvb[l_ac].rvb37 = l_pmc916
               DISPLAY BY NAME g_rvb[l_ac].rvb36
               DISPLAY BY NAME g_rvb[l_ac].rvb37
            END IF  
          #FUN-B60150 ADD&MARK BEGIN ----------------------------
          ##FUN-B40098 Begin---
          # IF g_azw.azw04 = '2' AND g_rva.rva29 = '3' THEN
          #    IF cl_null(g_rvb[l_ac].rvb36) THEN
          #       SELECT rtz08 INTO l_rtz08 FROM rtz_file
          #        WHERE rtz01 = g_rva.rvaplant
          #       IF NOT cl_null(l_rtz08) THEN
          #          LET g_rvb[l_ac].rvb36 = l_rtz08
          #          LET g_rvb[l_ac].rvb37 = ' '
          #          LET g_rvb[l_ac].rvb38 = ' '
          #       END IF
          #    END IF
          # END IF
          ##FUN-B40098 End-----

            IF g_azw.azw04 = '2' THEN
               IF cl_null(g_rvb[l_ac].rvb36) THEN
                  #FUN-C90049 mark begin----
                  #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
                  # WHERE rtz01 = g_rva.rvaplant
                  #FUN-C90049 mark end-----
                  CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
                  IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2') THEN
                     IF NOT cl_null(l_rtz08) THEN
                        LET g_rvb[l_ac].rvb36 = l_rtz08
                        LET g_rvb[l_ac].rvb37 = ' '
                        LET g_rvb[l_ac].rvb38 = ' '
                     END IF
                  END IF
                  IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
                     IF NOT cl_null(l_rtz07) THEN
                        LET g_rvb[l_ac].rvb36 = l_rtz07
                        LET g_rvb[l_ac].rvb37 = ' '
                        LET g_rvb[l_ac].rvb38 = ' '
                     END IF
                  END IF
               END IF
            END IF
          #FUN-B60150 ADD&MARK   END ----------------------------
 
         AFTER FIELD rvb36
           #FUN-B40098 Begin---
           #IF g_azw.azw04='2' AND g_rva.rva29 = '3' AND NOT cl_null(g_rvb[l_ac].rvb36) THEN   #FUN-B60150 MARK
            IF g_azw.azw04='2' AND NOT cl_null(g_rvb[l_ac].rvb36) THEN
               #FUN-C20002--start add-----------------------------------
               SELECT ima154 INTO l_ima154
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05

               IF l_ima154 = 'Y' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN
                  SELECT rcj03 INTO l_rcj03
                    FROM rcj_file
                   WHERE rcj00 = '0'

                  #FUN-C90049 mark begin---
                  #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                  #  FROM rtz_file
                  # WHERE rtz01 = g_rva.rvaplant
                  #FUN-C90049 mark end-----
                  CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add

                  IF l_rcj03 = '1' THEN 
                     IF g_rvb[l_ac].rvb36 <> l_rtz07 THEN
                        CALL cl_err('','aim1142',0)
                        LET g_rvb[l_ac].rvb36 = g_rvb_t.rvb36
                        NEXT FIELD rvb36
                     END IF
                  ELSE
                     IF g_rvb[l_ac].rvb36 <> l_rtz08 THEN
                        CALL cl_err('','aim1142',0)
                        LET g_rvb[l_ac].rvb36 = g_rvb_t.rvb36
                        NEXT FIELD rvb36
                     END IF
                  END IF
               END IF
               #FUN-C20002--end add------------------------------------- 
               IF (g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')) THEN  #FUN-B60150 ADD
                  LET g_cnt = 0
                  SELECT count(*) INTO g_cnt FROM imd_file
                   WHERE imd01 = g_rvb[l_ac].rvb36
                     AND imd01 IN (SELECT jce02 FROM jce_file)
                  IF g_cnt = 0 THEN
                     IF g_rva.rva29 = '3' THEN                          #FUN-B60150 ADD
                        CALL cl_err(g_rvb[l_ac].rvb36,'apm-147',1)
                     ELSE                                               #FUN-B60150 ADD
                        CALL cl_err(g_rvb[l_ac].rvb36,'apm-153',1)      #FUN-B60150 ADD
                     END IF                                             #FUN-B60150 ADD
                     NEXT FIELD rvb36
                  END IF
               END IF                                                   #FUN-B60150 ADD
               #FUN-B60150 ADD - BEGIN ----------------------------------
               IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
                  LET g_cnt = 0
                  SELECT count(*) INTO g_cnt FROM imd_file
                   WHERE imd01 = g_rvb[l_ac].rvb36
                     AND imd01 NOT IN (SELECT jce02 FROM jce_file)
                  IF g_cnt = 0 THEN
                    CALL cl_err(g_rvb[l_ac].rvb36,'apm-154',1)
                    NEXT FIELD rvb36
                  END IF
               END IF
               #FUN-B60150 ADD - END ------------------------------------
            END IF
           #FUN-B40098 End-----
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-770082 add
            IF  g_rvb[l_ac].rvb89 != 'Y' THEN #CHI-C80019 add
               IF cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN      #No.TQC-740313    #CHI-7A0003 remark   #MOD-7A0132 modify MISC
                  #CHI-C80019 add start -----
                  SELECT rvb39 INTO l_rvb39 FROM rvb_file WHERE rvb01 = g_rva.rva01 AND rvb02 = g_rvb[l_ac].rvb02
                  IF g_sma.sma886[7,7] = 'N' OR l_rvb39 = 'Y' THEN
                     CALL cl_err('','asf-770',1)
                  #CHI-C80019 add end   -----
                     NEXT FIELD rvb36
                  END IF #CHI-C80019 add
               END IF
            END IF #CHI-C80019 add
            IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' AND g_rvb[l_ac].rvb36 <> 'MISC'  THEN   #TQC-C30193 add <> MISC
               #------>check-1  檢查該料是否可收至該倉
               IF NOT s_imfchk1(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36) THEN
                  CALL cl_err('s_imfchk1:','mfg9036',0)
                  NEXT FIELD rvb36
               END IF
               #------>check-2  檢查倉庫須存在否
               CALL s_stkchk(g_rvb[l_ac].rvb36,'A') RETURNING l_code
               IF NOT l_code THEN
                  CALL cl_err('s_stkchk:','mfg1100',0)
                  NEXT FIELD rvb36
               END IF
               #------>check-3  檢查是否為可用倉
               CALL s_swyn(g_rvb[l_ac].rvb36) RETURNING sn1,sn2
              #IF sn1=1 AND g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN  #MOD-D30079 mark
               IF sn1=1 THEN   #MOD-D30079 add
                  IF NOT cl_null(g_rvb[l_ac].rvb36) OR g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN  #MOD-D30079 add
                     LET g_rvb_t.rvb36=g_rvb[l_ac].rvb36
                     CALL cl_err(g_rvb[l_ac].rvb36,'mfg6080',0)
                     NEXT FIELD rvb36
                  END IF       #MOD-D30079 add
               ELSE
                 #IF sn2=2 AND g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN #MOD-D30079 mark
                  IF sn2=2 THEN  #MOD-D30079 add
                     IF NOT cl_null(g_rvb[l_ac].rvb36) OR g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN  #MOD-D30079 add
                        CALL cl_err(g_rvb[l_ac].rvb36,'mfg6085',0)
                        LET g_rvb_t.rvb36=g_rvb[l_ac].rvb36
                        NEXT FIELD rvb36
                     END IF      #MOD-D30079 add
                  END IF
               END IF
               LET sn1=0 LET sn2=0
               #檢查該倉庫的歸屬機構是否為當前機構
               #No.FUN-AA0049--begin--mark
               #IF g_azw.azw04='2' THEN
               #   SELECT imd01 FROM imd_file WHERE imd01 = g_rvb[l_ac].rvb36 
               #      AND imd20 = g_rva.rvaplant
               #   IF SQLCA.sqlcode = 100 THEN
               #      CALL cl_err('','art-426',0)
               #      NEXT FIELD rvb36
               #   END IF
               #END IF
               IF NOT s_chk_ware(g_rvb[l_ac].rvb36) THEN
#TQC-B90034 --BEGIN--
                  IF  g_rvb[l_ac].rvb89 = 'Y' THEN
                  #   EXIT DIALOG                  #TQC-C20117--mark
                      EXIT INPUT                   #TQC-C20117--ADD
                  ELSE
#TQC-B90034 --END--
                     NEXT FIELD rvb36
                  END IF                         #TQC-B90034
               END IF 
               #No.FUN-AA0049--end               
               IF NOT s_chksmz(g_rvb[l_ac].rvb05, g_rva.rva01,                                                                      
                               g_rvb[l_ac].rvb36, g_rvb[l_ac].rvb37) THEN                                                           
                  NEXT FIELD rvb36                                                                                                  
               END IF                                                                                                               
              #CALL t110_chk_rvb36()   #MOD-C20091 mark
               IF NOT cl_null(g_errno) THEN
                   #CALL cl_err(g_rvb[l_ac].rvb36,'apm-329',1)   #MOD-BA0030
                   CALL cl_err(g_rvb[l_ac].rvb36,g_errno,1)   #MOD-BA0030
                  NEXT FIELD rvb36  
               END IF
               NEXT FIELD rvb37    #NO.CHI-920041
            END IF
 
         AFTER FIELD rvb37              #儲位
            #BugNo:5626 控管是否為全型空白
            IF g_rvb[l_ac].rvb37 = '　' THEN #全型空白
                LET g_rvb[l_ac].rvb37 = ' '
            END IF
            IF g_rvb[l_ac].rvb37 IS NULL THEN
               LET g_rvb[l_ac].rvb37=' '
            END IF
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-910227
            IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' AND g_rvb[l_ac].rvb36 <> 'MISC'  THEN   #NO.MOD-590530 #TQC-C30193 add <> MISC 
               #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
               IF NOT s_chksmz(g_rvb[l_ac].rvb05, g_rva.rva01,
                               g_rvb[l_ac].rvb36, g_rvb[l_ac].rvb37) THEN
                  NEXT FIELD rvb36
               END IF
               #------>check-1  檢查該料是否可收至該倉/儲位
               IF NOT s_imfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                               g_rvb[l_ac].rvb37) THEN
                  CALL cl_err(g_rvb[l_ac].rvb37,'mfg6095',0)
                  NEXT FIELD rvb37
               END IF
               #------>check-2  檢查該倉庫/儲位是否存在
               IF g_rvb[l_ac].rvb37 IS NOT NULL THEN
                  CALL s_hqty(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                              g_rvb[l_ac].rvb37)
                       RETURNING g_cnt,g_imf04,g_imf05
                  IF g_imf04 IS NULL THEN
                     LET g_imf04 = 0
                  END IF
                  CALL s_lwyn(g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37)
                       RETURNING sn1,sn2    #可用否
                  SELECT pmn38 INTO g_pmn38 FROM pmn_file
                   WHERE pmn01=g_rvb[l_ac].rvb04
                     AND pmn02=g_rvb[l_ac].rvb03
                  IF g_argv2<>'SUB' THEN  #FUN-C30279
                     IF sn2 = 2 THEN
                        IF g_pmn38 = 'Y' THEN
                           CALL cl_err('','mfg9132',0)
                        END IF
                     ELSE
                        IF g_pmn38 = 'N' THEN
                           CALL cl_err('','mfg9131',0)
                        END IF
                     END IF
                  END IF     #FUN-C30279
                  LET sn1=0 LET sn2=0
               END IF
               IF g_rvb[l_ac].rvb37 IS NULL THEN
                  LET g_rvb[l_ac].rvb37=' '
               END IF
              #CALL t110_chk_rvb36()   #MOD-C20091 mark
               IF NOT cl_null(g_errno) THEN
                  #CALL cl_err(g_rvb[l_ac].rvb37,'apm-329',1)   #MOD-BA0030
                  CALL cl_err(g_rvb[l_ac].rvb37,g_errno,1)   #MOD-BA0030
                  NEXT FIELD rvb37
               END IF
               NEXT FIELD rvb38    #NO.CHI-920041
            END IF
          #FUN-B50096 -----------Begin------------
           IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_rvb[l_ac].rvb05
              IF l_ima159 = '2' THEN
                 CASE  t110_b_rvb38_inschk()
                    WHEN "rvb36" NEXT FIELD rvb36
                    WHEN "rvb38" NEXT FIELD rvb37
                 END CASE
              END IF
          END IF 
          #FUN-B50096 -----------End--------------
 
         BEFORE FIELD rvb38              #批號
 
 
         AFTER FIELD rvb38              #批號

#FUN-B50096 -------------Begin---------------------
            CASE  t110_b_rvb38_inschk()
               WHEN "rvb36" NEXT FIELD rvb36
               WHEN "rvb38" NEXT FIELD rvb38
            END CASE
#FUN-B50096 -------------End-----------------------

#FUN-B50096 --------------------Begin----------------
#            # 控管是否為全型空白
#            IF g_rvb[l_ac].rvb38 = '　' THEN #全型空白
#               LET g_rvb[l_ac].rvb38 = ' '
#            END IF
#            IF g_rvb[l_ac].rvb38 IS NULL THEN
#               LET g_rvb[l_ac].rvb38=' '
#            END IF
#            DISPLAY BY NAME g_rvb[l_ac].rvb38   #MOD-B80272 add
# 
#&ifdef ICD
#            #FUN-A40022----begin--add---------------
#            IF NOT cl_null(g_rvb[l_ac].rvb05) THEN  
#               LET l_imaicd13=''                                                                                
#               SELECT imaicd13 INTO l_imaicd13                                                                                      
#                 FROM imaicd_file                                                                                                   
#                WHERE imaicd00 = g_rvb[l_ac].rvb05                                                                                  
#               IF l_imaicd13 = 'Y' AND cl_null(g_rvb[l_ac].rvb38) THEN                                                              
#                  CALL cl_err(g_rvb[l_ac].rvb05,'aim-034',1)                                                                        
#                  DISPLAY BY NAME g_rvb[l_ac].rvb38            #MOD-B80272 add
#                  NEXT FIELD rvb38                                                                                                  
#               END IF                                                                                                               
#            END IF
#            #FUN-A40022--end--add------------------
#               IF p_cmd = 'u' AND NOT cl_null(g_rvb[l_ac].rvb38) THEN
#                  IF g_rvb_t.rvb38 <> g_rvb[l_ac].rvb38 THEN
#                     IF NOT t110_ind_icd_chk_icd() THEN
#                        LET g_rvb[l_ac].rvb38 = g_rvb_t.rvb38
#                        DISPLAY BY NAME g_rvb[l_ac].rvb38
#                        NEXT FIELD rvb38
#                     ELSE
#                        CALL t110_ind_icd_trans_chk('u')
#                     END IF
#                  END IF
#               END IF
#&endif
#            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-910227
#            IF NOT cl_null(g_rvb[l_ac].rvb36)  AND l_ec_sw='N' THEN
#                  SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
#                    FROM img_file   #採購單位,庫存數量,庫存單位
#                   WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
#                     AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
#                  IF STATUS=100 AND (g_rvb[l_ac].rvb36 IS NOT NULL AND g_rvb[l_ac].rvb36 <> ' ') THEN
#                     IF g_sma.sma892[3,3] ='Y' THEN
#                        IF NOT cl_confirm('mfg1401') THEN
#                           NEXT FIELD rvb38
#                        END IF
#                     END IF
#                     CALL s_add_img(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                    g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                    g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06)
#                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
#                       FROM img_file
#                      WHERE img01 = g_rvb[l_ac].rvb05
#                        AND img02 = g_rvb[l_ac].rvb36
#                        AND img03 = g_rvb[l_ac].rvb37
#                        AND img04 = g_rvb[l_ac].rvb38
#                  END IF
#                  SELECT ima906 INTO g_ima906 FROM ima_file
#                   WHERE ima01=g_rvb[l_ac].rvb05
#                  IF g_ima906 = '2' THEN
#                     IF NOT cl_null(g_rvb[l_ac].rvb83) THEN
#                        CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                        g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                        g_rvb[l_ac].rvb83) RETURNING g_flag
#                        IF g_flag = 1 THEN
#                           IF g_sma.sma892[3,3] ='Y' THEN
#                              IF NOT cl_confirm('aim-995') THEN
#                                 NEXT FIELD rvb36
#                              END IF
#                           END IF
#                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                           g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
#                                           g_rva.rva01,
#                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
#                           IF g_flag = 1 THEN
#                              NEXT FIELD rvb36
#                           END IF
#                        END IF
#                     END IF
#                     IF NOT cl_null(g_rvb[l_ac].rvb80) THEN
#                        CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                        g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                        g_rvb[l_ac].rvb80) RETURNING g_flag
#                        IF g_flag = 1 THEN
#                           IF g_sma.sma892[3,3] ='Y' THEN
#                              IF NOT cl_confirm('aim-995') THEN
#                                 NEXT FIELD rvb36
#                              END IF
#                           END IF
#                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                           g_rvb[l_ac].rvb80,g_rvb[l_ac].rvb81,
#                                           g_rva.rva01,
#                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
#                           IF g_flag = 1 THEN
#                              NEXT FIELD rvb36
#                           END IF
#                        END IF
#                     END IF
#                  END IF
#                  IF g_ima906 = '3' THEN
#                     IF NOT cl_null(g_rvb[l_ac].rvb83) THEN
#                        CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                        g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                        g_rvb[l_ac].rvb83) RETURNING g_flag
#                        IF g_flag = 1 THEN
#                           IF g_sma.sma892[3,3] ='Y' THEN
#                              IF NOT cl_confirm('aim-995') THEN
#                                 NEXT FIELD rvb36
#                              END IF
#                           END IF
#                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
#                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
#                                           g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
#                                           g_rva.rva01,
#                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
#                           IF g_flag = 1 THEN
#                              NEXT FIELD rvb36
#                           END IF
#                        END IF
#                     END IF
#                  END IF
#            END IF
#FUN-B50096 -------------------End---------------------
 
         AFTER FIELD rvb25
            IF NOT cl_null(g_rvb[l_ac].rvb25) THEN
               SELECT coc10 INTO l_coc10 FROM coc_file
                WHERE coc03 = g_rvb[l_ac].rvb25
               IF STATUS THEN
                  CALL cl_err3("sel","coc_file",g_rvb[l_ac].rvb25,"","aco-062","","",1) #No.FUN-660129
                  NEXT FIELD rvb25
               END IF
               SELECT COUNT(*) INTO l_cnt FROM coc_file,coe_file,coa_file
                WHERE coc01 = coe01
                  AND coe03 = coa03
                  AND coa05 = l_coc10
                  AND coa01 = g_rvb[l_ac].rvb05
                  AND coc03 = g_rvb[l_ac].rvb25
               IF l_cnt = 0 THEN
                  CALL cl_err(g_rvb[l_ac].rvb25,'aco-073',0)
                  NEXT FIELD rvb25
               END IF
            END IF
 
         AFTER FIELD rvb10   #採購單價
            IF NOT cl_null(g_rvb[l_ac].rvb10) THEN
               IF g_rvb[l_ac].rvb10 < 0 THEN
                  LET g_rvb[l_ac].rvb10 = g_rvb_t.rvb10
                  NEXT FIELD rvb10
               END IF
               LET g_rvb[l_ac].rvb10 = cl_digcut(g_rvb[l_ac].rvb10,t_azi03)  #No.CHI-6A0004
               IF g_argv6 = '2' THEN                                         #TQC-9B0203
                  LET g_rvb[l_ac].rvb10t =                                   #TQC-9B0203
                      g_rvb[l_ac].rvb10 * ( 1 + g_rva.rva116 /100)           #TQC-9B0203
               ELSE                                                          #TQC-9B0203
                  LET g_rvb[l_ac].rvb10t =
                      g_rvb[l_ac].rvb10 * ( 1 + g_rvb[l_ac].pmm43 /100)
               END IF                                                        #TQC-9B0203
               LET g_rvb[l_ac].rvb10t = cl_digcut(g_rvb[l_ac].rvb10t,t_azi03)  #No.CHI-6A0004
               DISPLAY g_rvb[l_ac].rvb10  TO rvb10  # FUN-610018
               DISPLAY g_rvb[l_ac].rvb10t TO rvb10t # FUN-610018
            END IF
 
         AFTER FIELD rvb10t   #含稅單價
            IF NOT cl_null(g_rvb[l_ac].rvb10t) THEN
               LET g_rvb[l_ac].rvb10t = cl_digcut(g_rvb[l_ac].rvb10t,t_azi03)  #No.CHI-6A0004
               IF g_argv6 = '2' THEN                                         #TQC-9B0203
                  LET g_rvb[l_ac].rvb10 =                                    #TQC-9B0203
                      g_rvb[l_ac].rvb10t / ( 1 + g_rva.rva116 /100)          #TQC-9B0203
               ELSE                                                          #TQC-9B0203
                  LET g_rvb[l_ac].rvb10 =
                      g_rvb[l_ac].rvb10t / ( 1 + g_rvb[l_ac].pmm43 / 100)
               END IF                                                        #TQC-9B0203
               LET g_rvb[l_ac].rvb10 = cl_digcut(g_rvb[l_ac].rvb10,t_azi03)  #No.CHI-6A0004
               DISPLAY g_rvb[l_ac].rvb10  TO rvb10  # FUN-610018
               DISPLAY g_rvb[l_ac].rvb10t TO rvb10t # FUN-610018
            END IF
 
        AFTER FIELD rvb930
            IF NOT cl_null(g_rvb[l_ac].rvb930) THEN
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                                          WHERE gem01=g_rvb[l_ac].rvb930
                                            AND gem09 IN ('1','2')
                                            AND gemacti='Y'
                IF l_cnt=0 THEN
                   CALL cl_err3("sel","gem_file",g_rvb[l_ac].rvb930,"",100,"","",1)
                   LET g_rvb[l_ac].rvb930=g_rvb_t.rvb930
                   LET g_rvb[l_ac].gem02a=g_rvb_t.gem02a
                   DISPLAY BY NAME g_rvb[l_ac].rvb930,g_rvb[l_ac].gem02a
                   NEXT FIELD rvb930
                END IF
                CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a
                DISPLAY BY NAME g_rvb[l_ac].gem02a
            ELSE
                LET g_rvb[l_ac].gem02a=NULL
                DISPLAY BY NAME g_rvb[l_ac].gem02a
            END IF
            LET g_rvb2.rvb930  = g_rvb[l_ac].rvb930
 
         BEFORE DELETE                            #是否取消單身
            IF g_rvb_t.rvb02 > 0 AND g_rvb_t.rvb02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               IF g_rvb_t.rvb93 IS NOT NULL THEN
                  IF NOT cl_confirm('apm1026') THEN
                     CANCEL DELETE
                  END IF
               END IF

               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF l_ec_sw = 'N' THEN      #CHI-A80024
                  SELECT ima918,ima921 INTO g_ima918,g_ima921 
                    FROM ima_file
                   WHERE ima01 = g_rvb[l_ac].rvb05
                     AND imaacti = "Y"
                  
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                      #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                          CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                        SQLCA.sqlcode,"","",1)
                           ROLLBACK WORK
                           CANCEL DELETE
                       END IF
                     END IF
                  END IF
               END IF   #CHI-A80024

#FUN-A60035 ---MARK BEGIN
#             #No.FUN-A50054 -BEGIN-----
#              IF s_industry('slk') THEN
#                 DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01
#                    AND rvb02 IN (SELECT ata03 FROM ata_file WHERE ata00 = g_prog
#                                     AND ata01 = g_rva.rva01 AND ata02 = g_rvb_t.rvb02)
#                 DELETE FROM ata_file WHERE ata00 = g_prog
#                    AND ata01 = g_rva.rva01 AND ata02 = g_rvb_t.rvb02
#              END IF
#             #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
               DELETE FROM rvb_file
                WHERE rvb01 = g_rva.rva01 AND rvb02 = g_rvb_t.rvb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","del rvb",1) #No.FUN-660129
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  IF NOT s_del_rvbi(g_rva.rva01,g_rvb_t.rvb02,'') THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               SELECT COUNT(*) INTO g_cnt
                 FROM rvb_file
                WHERE rvb22 = g_rvb[l_ac].rvb22
                  AND (rvb01 <> g_rva.rva01 OR rvb02 <> g_rvb[l_ac].rvb02)
               IF g_cnt = 0 THEN
                  DELETE FROM rvw_file
                   WHERE rvw01 = g_rvb[l_ac].rvb22
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rvw_file",g_rvb[l_ac].rvb22,"",SQLCA.sqlcode,"","del rvw_file err!",1) #No.FUN-660129
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF

               UPDATE wpe_file SET wpe07 = 'N' WHERE wpe01 = g_rvb[l_ac].rvb93
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","wpe_file",g_rvb[l_ac].rvb93,"",SQLCA.sqlcode,"","upd wpe_file err!",1) 
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF               

               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
 
         AFTER FIELD rvbud01
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud02
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud03
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud04
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud05
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud06
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud07
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud08
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud09
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud10
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud11
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud12
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud13
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud14
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD rvbud15
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvb[l_ac].* = g_rvb_t.*
               CLOSE t110_bcl
                  CLOSE t110_bcl_ind
               ROLLBACK WORK
             #  EXIT DIALOG      #TQC-C20117-mark
                EXIT INPUT       #TQC-C20117-add 
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rvb[l_ac].rvb02,-263,1)
               LET g_rvb[l_ac].* = g_rvb_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_rvb[l_ac].rvb05)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD rvb05
                  END IF
 
                  CALL s_chk_va_setting1(g_rvb[l_ac].rvb05)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     #NEXT FIELD rvb05 #TQC-B80005 mark 
                     NEXT FIELD rvb82  #TQC-B80005  
                  END IF
                  CALL t110_du_data_to_correct()
 
                  CALL t110_set_origin_field()
               END IF
 
               IF cl_null(g_rvb[l_ac].rvb86) THEN
                  LET g_rvb[l_ac].rvb86 = g_rvb[l_ac].rvb90    #No.FUN-940083 pmn07-->rvb90 
                  LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
               END IF
#MOD-B80156 -- begin --
               IF cl_null(g_rvb[l_ac].rvb87) THEN
                  CALL t110_set_rvb87()
               END IF
#MOD-B80156 -- end --
 
               # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
               LET l_ec_sw = 'N'
               IF g_argv2 ='SUB' THEN
                  LET l_sfb24=''
                  SELECT sfb24 INTO l_sfb24
                   FROM sfb_file
                   WHERE sfb01 = g_rvb[l_ac].rvb34
                  IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
                     LET l_ec_sw='Y'
                  END IF
                  IF l_ec_sw='Y' THEN
                     LET g_rvb[l_ac].rvb36=' '
                     LET g_rvb[l_ac].rvb37=' '
                     LET g_rvb[l_ac].rvb38=' '
                  END IF
               END IF
               #modi in 00/01/18 若為LC收貨，則須檢查數貨不可大於提單數量
               IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                  SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
                   WHERE als01=g_rvb[l_ac].rvb22
                  IF SQLCA.sqlcode=100 THEN
                     CALL cl_err3("sel","als_file",g_rvb[l_ac].rvb22,"","aap-762","","",1) #No.FUN-660129
                     NEXT FIELD rvb22
                  END IF
                  IF l_als05 <> g_rva.rva05 THEN
                     CALL cl_err('','apm-303',0)
                     NEXT FIELD rvb22
                  END IF
                  IF NOT cl_null(l_als21) THEN
                     LET g_rva.rva08 = l_als21
                     DISPLAY BY NAME g_rva.rva08
                  END IF
                  SELECT alt06 INTO l_alt06 FROM alt_file
                   WHERE alt01=g_rvb[l_ac].rvb22
                     AND alt14=g_rvb[l_ac].rvb04
                     AND alt15=g_rvb[l_ac].rvb03
                  IF cl_null(l_alt06) THEN
                     LET l_alt06 = 0
                  END IF
                     SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01!=g_rva.rva01 AND rvb35='N'
                  IF cl_null(t_alt06) THEN
                     LET t_alt06 = 0
                  END IF
                  IF g_rvb[l_ac].rvb07 > (l_alt06-t_alt06) THEN
                     CALL cl_err('','apm-305',0)
                     IF g_sma.sma115 = 'Y' THEN
                        IF g_ima906 MATCHES '[23]' THEN
                           NEXT FIELD rvb85
                        ELSE
                           NEXT FIELD rvb82
                        END IF
                     ELSE
                        NEXT FIELD rvb07
                     END IF
                  END IF
               END IF
               #---再判斷一次倉儲批是否存在
                  IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw = 'N' THEN   #MOD-910227
                     IF g_rvb[l_ac].rvb37 IS NULL THEN
                        LET g_rvb[l_ac].rvb37=' '
                     END IF
                     IF g_rvb[l_ac].rvb38 IS NULL THEN
                        LET g_rvb[l_ac].rvb38=' '
                     END IF
                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                       FROM img_file   #採購單位,庫存數量,庫存單位
                      WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                        AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                     IF STATUS=100 AND (g_rvb[l_ac].rvb36 IS NOT NULL AND g_rvb[l_ac].rvb36 <> ' ') THEN
                        IF g_sma.sma892[3,3] ='Y' THEN
                           IF NOT cl_confirm('mfg1401') THEN
                              NEXT FIELD rvb38
                           END IF
                        END IF
                        CALL s_add_img(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                       g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                       g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06)
                     END IF
                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                       FROM img_file
                      WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                        AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                  END IF
            #   IF NOT s_industry('slk') THEN #No.FUN-A50054    #FUN-A60035 ---MARK
               CALL t110_b_move_back() #FUN-730068
                  IF cl_null(g_rvb[l_ac].rvb10) THEN
                     LET g_rvb[l_ac].rvb10 = 0
                  END IF
                  LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
              IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
              LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
               LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
               LET g_rvb2.rvb26 = NULL
               LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
               LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
               LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
               LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
               LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
               LET g_rvb2.rvb11 = 0
               LET g_rvb2.rvb25 = g_rvb[l_ac].rvb25
               SELECT ima491 INTO l_ima491 FROM ima_file
                WHERE ima01 = g_rvb2.rvb05
               IF cl_null(l_ima491) THEN
                  LET l_ima491 = 0
               END IF
               IF l_ima491 > 0 THEN
                  CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
               ELSE
                  IF cl_null(g_rvb2.rvb12) THEN
                     LET g_rvb2.rvb12 = g_rva.rva06
                  END IF
               END IF
                CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
                  RETURNING g_rvb2.rvb39 #MOD-530415
               LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
               LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
               LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
               LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
               LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
               LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85
               LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
               LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
               LET g_rvb2.rvb88 = g_rvb2.rvb87*g_rvb2.rvb10
               LET g_rvb2.rvb88t= g_rvb2.rvb87*g_rvb2.rvb10t
               LET g_rvb2.rvb930= g_rvb[l_ac].rvb930 #FUN-670051
 
               IF g_argv6 ='1' THEN                  #FUN-940083
                  #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
                  SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
                   WHERE gec01 = pmm21
                     AND pmm01 = g_rvb2.rvb04
                  IF SQLCA.SQLCODE = 100 THEN
                     CALL cl_err('','mfg3192',0)
                     NEXT FIELD rvb04
                  END IF
                  SELECT azi04 INTO t_azi04 
                    FROM pmm_file,azi_file
                   WHERE pmm22=azi01
                     AND pmm01=g_rvb2.rvb04
                  LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)        #MOD-AC0024
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     #MOD-AC0024
                  IF g_gec07='Y' THEN
                     #-----CHI-AC0016---------
                     #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                     #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     #IF g_gec05 = 'T' THEN 
                     IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                        LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rvb[l_ac].pmm43/100) #TQC-C30225 add
                        LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)            #TQC-C30225 add
                        LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rvb[l_ac].pmm43/100)
                        LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     ELSE
                        LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                        LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     END IF
                     #-----END CHI-AC0016-----
                     IF cl_null(g_rvb2.rvb10t) THEN 
                        LET g_rvb2.rvb10t = 0 
                     END IF 
                     IF cl_null(g_rva.rva116) THEN 
                        LET g_rva.rva116 = 0 
                     END IF    
                     IF g_argv6 = '2' THEN   #MOD-B80298
                        LET g_rvb2.rvb10 = g_rvb2.rvb10t / ( 1 + g_rva.rva116/100)    #FUN-940083
                     #MOD-B80298 add begin-------------
                     ELSE
                        LET g_rvb2.rvb10 = g_rvb2.rvb10t / ( 1 + g_rvb[l_ac].pmm43/100)
                     END IF
                     #MOD-B80298 add end---------------
                  ELSE
                     LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
                     LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
                     IF g_argv6 = '2' THEN   #TQC-AB0224
                        LET g_rvb2.rvb10t = g_rvb2.rvb10 * ( 1 + g_rva.rva116/100)    #FUN-940083
                     ELSE  #TQC-AB0224
                        LET g_rvb2.rvb10t = g_rvb2.rvb10 * ( 1 + g_rvb[l_ac].pmm43 /100)  #TQC-AB0224
                     END IF  #TQC-AB0224
                  END IF
              ELSE
                  #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
                  SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file   #CHI-AC0016 add gec05
                   WHERE gec01 = g_rva.rva115
                  IF SQLCA.SQLCODE = 100 THEN
                     CALL cl_err('','mfg3192',0)
                     NEXT FIELD rvb04
                  END IF
                  SELECT azi04 INTO t_azi04 
                    FROM azi_file
                   WHERE azi01 = g_rva.rva113
                  LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)        #MOD-AC0024
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     #MOD-AC0024
                  IF g_gec07='Y' THEN
                     #-----CHI-AC0016---------
                     #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                     #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     #IF g_gec05 = 'T' THEN 
                     IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
                        LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rva.rva116/100)      #TQC-C30225 add
                        LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)            #TQC-C30225 add
                        LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rva.rva116/100)
                        LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     ELSE
                        LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                        LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                     END IF
                     #-----END CHI-AC0016-----
                  ELSE
                     LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
                     LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
                  END IF
              END IF
            #TQC-B80155 --begin
              LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10,t_azi03)
              LET g_rvb2.rvb10t = cl_digcut(g_rvb2.rvb10t,t_azi03)
            #TQC-B80155 --end
              IF cl_null(g_rvb2.rvb89) THEN LET g_rvb2.rvb89 = 'N' END IF   #TQC-9C0053
              UPDATE rvb_file SET * = g_rvb2.*
                WHERE rvb01=g_rva.rva01
                  AND rvb02=g_rvb_t.rvb02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                  CALL cl_err3("upd","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","upd rvb_file",1) #No.FUN-660129
                  LET g_rvb[l_ac].* = g_rvb_t.*
               ELSE
	          UPDATE rvbi_file SET * = g_rvbi2.*
	           WHERE rvbi01=g_rva.rva01
       	             AND rvbi02=g_rvb_t.rvb02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                    CALL cl_err3("upd","rvbi_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","upd rvbi_file",1)
                    LET g_rvb[l_ac].* = g_rvb_t.*
                 END IF
                 #No.FUN-7C0017 -End
                  CALL cl_msg('UPDATE O.K')

                  LET l_rva32 = '0'          #FUN-9C0076 add

                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
#FUN-A60035 ---MARK BEGIN
#             #No.FUN-A50054 -BEGIN-----
#              ELSE
#                 DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01
#                    AND rvb02 NOT IN (SELECT ata03 FROM ata_file WHERE ata00 = g_prog
#                    AND ata01 = g_rva.rva01)
#                 DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01
#                    AND rvb02 IN (SELECT ata03 FROM ata_file WHERE ata00 = g_prog
#                    AND ata01 = g_rva.rva01 AND ata02 = g_rvb[l_ac].rvb02)
#                  DECLARE t110_ata6 CURSOR FOR
#                   SELECT ata03,ata04,ata08 FROM ata_file
#                    WHERE ata00 = g_prog
#                      AND ata01 = g_rva.rva01
#                      AND ata02 = g_rvb[l_ac].rvb02
#                 FOREACH t110_ata6 INTO l_ata03,l_ata04,l_ata08
#                    CALL t110_b_move_back() 
#                    LET g_rvb2.rvb03 = l_ata03
#                    LET g_rvb2.rvb02 = l_ata03
#                    LET g_rvb2.rvb07 = l_ata08
#                    LET g_rvb2.rvb05 = l_ata04
#                 IF cl_null(g_rvb[l_ac].rvb10) THEN
#                    LET g_rvb[l_ac].rvb10 = 0
#                 END IF
#                 LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
#             IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
#             LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
#              LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
#              LET g_rvb2.rvb26 = NULL
#              LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
#              LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
#              LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
#              LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
#              LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
#              LET g_rvb2.rvb11 = 0
#              LET g_rvb2.rvb25 = g_rvb[l_ac].rvb25
#              SELECT ima491 INTO l_ima491 FROM ima_file
#               WHERE ima01 = g_rvb2.rvb05
#              IF cl_null(l_ima491) THEN
#                 LET l_ima491 = 0
#              END IF
#              IF l_ima491 > 0 THEN
#                 CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
#              ELSE
#                 IF cl_null(g_rvb2.rvb12) THEN
#                    LET g_rvb2.rvb12 = g_rva.rva06
#                 END IF
#              END IF
#               CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
#                 RETURNING g_rvb2.rvb39 #MOD-530415
#              LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
#              LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
#              LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
#              LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
#              LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
#              LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85
#              LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
#              LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
#              LET g_rvb2.rvb88 = g_rvb2.rvb87*g_rvb2.rvb10
#              LET g_rvb2.rvb88t= g_rvb2.rvb87*g_rvb2.rvb10t
#              LET g_rvb2.rvb930= g_rvb[l_ac].rvb930 #FUN-670051
#
#              IF g_argv6 ='1' THEN                  #FUN-940083
#                 #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
#                 SELECT gec07 INTO g_gec07 FROM gec_file,pmm_file
#                  WHERE gec01 = pmm21
#                    AND pmm01 = g_rvb2.rvb04
#                 IF SQLCA.SQLCODE = 100 THEN
#                    CALL cl_err('','mfg3192',0)
#                    NEXT FIELD rvb04
#                 END IF
#                 SELECT azi04 INTO t_azi04 
#                   FROM pmm_file,azi_file
#                  WHERE pmm22=azi01
#                    AND pmm01=g_rvb2.rvb04
#                 IF g_gec07='Y' THEN
#                    LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
#                    LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
#                    IF cl_null(g_rvb2.rvb10t) THEN 
#                       LET g_rvb2.rvb10t = 0 
#                    END IF 
#                    IF cl_null(g_rva.rva116) THEN 
#                       LET g_rva.rva116 = 0 
#                    END IF    
#                    LET g_rvb2.rvb10 = g_rvb2.rvb10t / ( 1 + g_rva.rva116/100)    #FUN-940083
#                 ELSE
#                    LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
#                    LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
#                    LET g_rvb2.rvb10t = g_rvb2.rvb10 * ( 1 + g_rva.rva116/100)    #FUN-940083
#                 END IF
#             ELSE
#                 #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
#                 SELECT gec07 INTO g_gec07 FROM gec_file
#                  WHERE gec01 = g_rva.rva115
#                 IF SQLCA.SQLCODE = 100 THEN
#                    CALL cl_err('','mfg3192',0)
#                    NEXT FIELD rvb04
#                 END IF
#                 SELECT azi04 INTO t_azi04 
#                   FROM azi_file
#                  WHERE azi01 = g_rva.rva113
#                 IF g_gec07='Y' THEN
#                    LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
#                    LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
#                 ELSE
#                    LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
#                    LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
#                 END IF
#             END IF
#             IF cl_null(g_rvb2.rvb89) THEN LET g_rvb2.rvb89 = 'N' END IF   #TQC-9C0053
#            #UPDATE rvb_file SET * = g_rvb2.*
#            #  WHERE rvb01=g_rva.rva01
#            #    AND rvb02=g_rvb_t.rvb02
#             INSERT INTO rvb_file values(g_rvb2.*)
#                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#                       CALL cl_err3("upd","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","upd rvb_file",1) #No.FUN-660129
#                       LET g_rvb[l_ac].* = g_rvb_t.*
#                       EXIT FOREACH
#                 END IF
#                 END FOREACH
#                 CALL cl_msg('UPDATE O.K')
#                 LET l_rva32 = '0' 
#                 IF g_success='Y' THEN
#                    COMMIT WORK
#                 ELSE
#                    ROLLBACK WORK
#                 END IF
#              END IF
#             #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
         #  LET l_ac_t = l_ac    #TQC-D40025

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
               IF p_cmd = 'a' AND l_ac <= g_rvb.getLength() THEN #CHI-C30118 add
                  IF l_ec_sw = 'N' THEN      #CHI-A80024
                     SELECT ima918,ima921 INTO g_ima918,g_ima921 
                       FROM ima_file
                      WHERE ima01 = g_rvb[l_ac].rvb05
                        AND imaacti = "Y"
                     
                     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                        IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                          #MOD-BA0178 ----- start -----
                          IF g_rvb_t.rvb02 != g_rvb_o.rvb02 THEN
                             LET l_cnt = 0
                             SELECT COUNT(*) INTO l_cnt FROM rvbs_file 
                              WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02
                            IF l_cnt > 0 THEN
                               UPDATE rvbs_file SET rvbs02 =  g_rvb_t.rvb02 
                                WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02 
                               IF SQLCA.sqlcode THEN
                                  CALL cl_err3("upd","rvbs_file",g_rvb_t.rvb02,"",SQLCA.sqlcode,"","",1)
                               ELSE
                                  LET g_rvb_o.rvb02 = g_rvb_t.rvb02
                               END IF 
                            END IF
                         END IF
                         #MOD-BA0178 -----  end  -----
                        #IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                         IF NOT s_lot_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                            CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                          SQLCA.sqlcode,"","",1)
                         END IF
                       END IF #FUN-850120
                    END IF
                  END IF   #CHI-A80024
               END IF #CHI-C30118 add
               IF p_cmd = 'u' THEN
                  LET g_rvb[l_ac].* = g_rvb_t.*
          #TQC-D40025--add--str--
               ELSE
                  CALL g_rvb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
          #TQC-D40025--add--end--
               END IF
               CLOSE t110_bcl
                  CLOSE t110_bcl_ind
               ROLLBACK WORK
            #   EXIT DIALOG     #TQC-C20117-mark
                EXIT INPUT      #TQC-C20117-add
            END IF
            LET l_ac_t = l_ac    #TQC-D40025
            LET l_rva32 = '0'  #FUN-C30293
            CLOSE t110_bcl
               CLOSE t110_bcl_ind
            COMMIT WORK
 
         #CHI-C30118---add---START 回寫批序料號資料
         AFTER INPUT
             SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
             FOR l_ac = 1 TO g_cnt
                 LET g_ima918 = ' '
                 LET g_ima921 = ' '
                 SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                  WHERE ima01 = g_rvb[l_ac].rvb05
                    AND imaacti = "Y"

                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    UPDATE rvbs_file SET rvbs021 = g_rvb[l_ac].rvb05
                      WHERE rvbs00 = g_prog
                        AND rvbs01 = g_rva.rva01
                        AND rvbs02 = g_rvb[l_ac].rvb02
                 END IF
         END FOR         
        #CHI-C30118---add---END
 
 
         ON ACTION qry_warehouse        #MOD-490328
                  
                  #MOD-CB0079 -- add start --
                  IF NOT t110_chk_rvb04(p_cmd) THEN
                     NEXT FIELD rvb04
                  END IF
                  #MOD-CB0079 -- add end --

                  CALL cl_init_qry_var()
                  IF g_azw.azw04 = '2' THEN
                     IF g_rva.rva29 = '1' THEN
                        LET g_qryparam.form = 'q_imd_01'
                     ELSE
                        LET g_qryparam.form = 'q_imd_02'
                     END IF
                     LET g_qryparam.arg1 = g_rva.rvaplant
                  #No.FUN-AA0049--begin   
                  #ELSE
                  #   LET g_qryparam.form     = "q_imd"
                  #END IF
                     LET g_qryparam.default1 = g_rvb[l_ac].rvb36
                     #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213  No.FUN-AA0049
                     CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb36
                  ELSE 
                     CALL q_imd_1(FALSE,TRUE,g_rvb[l_ac].rvb36,"","","","") RETURNING g_rvb[l_ac].rvb36
                  END IF 
                  #No.FUN-AA0049--end                  
                  DISPLAY BY NAME g_rvb[l_ac].rvb36
                  NEXT FIELD rvb36
 
        ON ACTION qry_loc_warehouse        # 遇不可空白欄位可 cursor up
 
           #MOD-CB0079 -- add start --
            IF NOT t110_chk_rvb04(p_cmd) THEN
               NEXT FIELD rvb04
            END IF
           #MOD-CB0079 -- add end --

           #No.FUN-AA0049--begin
           #CALL cl_init_qry_var()
           #LET g_qryparam.form ="q_ime"
           #LET g_qryparam.default1 = g_rvb[l_ac].rvb37
           # LET g_qryparam.arg1     = g_rvb[l_ac].rvb36 #倉庫編號 #MOD-4A0063
           # LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
           #CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb37
           CALL q_ime_1(FALSE,TRUE,g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb36,'SW',g_plant,"","","") RETURNING g_rvb[l_ac].rvb37
           #No.FUN-AA0049--end
           NEXT FIELD rvb37
 
       ON ACTION controlp
          CASE
             #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
             #BEFORE FIELD att00來做開窗了
             #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
             WHEN INFIELD(att00)
                #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------                
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_ima_p"
#                LET g_qryparam.arg1 = lg_group
#                CALL cl_create_qry() RETURNING g_rvb[l_ac].att00
                CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                RETURNING g_rvb[l_ac].att00
#FUN-AA0059---------mod------------end-----------------
                DISPLAY BY NAME g_rvb[l_ac].att00        #No.MOD-490371
                NEXT FIELD att00
 
             WHEN INFIELD(rvb04) #查詢採購單號
#CHI-A80037 mark --start--
#&ifdef ICD
#                   CASE g_argv2
#                      WHEN "ICD"
#                         CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_rva.rva10)
#                                     RETURNING g_rvb[l_ac].rvb04
#                      OTHERWISE
#                         CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_argv2)
#                                     RETURNING g_rvb[l_ac].rvb04
#                   END CASE
#&else
#                   CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_argv2)
#                               RETURNING g_rvb[l_ac].rvb04
#&endif
#CHI-A80037 mark --end--
                #CHI-A80037 add --start--
                CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_rva.rva10,g_rva.rva02)    #MOD-C30434  add rva02    
                     RETURNING g_rvb[l_ac].rvb04
                #CHI-A80037 add --end--
                DISPLAY BY NAME g_rvb[l_ac].rvb04              #No.MOD-490371
                NEXT FIELD rvb04
             WHEN INFIELD(rvb05)
                 #FUN-A20017--begin--add-----
                 SELECT pmn04,ima903 INTO l_ima01,l_ima903
                   FROM ima_file,pmn_file
                  WHERE pmn01 = g_rvb[l_ac].rvb04
                    AND pmn02 = g_rvb[l_ac].rvb03
                    AND ima01 = pmn04
                 IF g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
                 #FUN-A20017--end--add----
#FUN-AA0059---------mod------------str-----------------                 
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ima"
#                    LET g_qryparam.where="ima151!='Y'"
#                    LET g_qryparam.default1 = g_rvb[l_ac].rvb05
#                    CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb05
                    IF s_industry('slk') THEN         #FUN-C30039 add
                       CALL q_sel_ima(FALSE, "q_ima","ima151!='Y'",g_rvb[l_ac].rvb05,"","","","","",'' ) 
                       RETURNING g_rvb[l_ac].rvb05
                   #FUN-C30039 add START
                    ELSE
                       CALL q_sel_ima(FALSE, "q_pnc04","ima151!='Y'",g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb05a,g_rva.rva05,g_today,"","",'' )
                       RETURNING g_rvb[l_ac].rvb05
                    END IF
                   #FUN-C30039 add END
#FUN-AA0059---------mod------------end-----------------
                 #FUN-A20017--begin--add---
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_bmm3"
                    LET g_qryparam.default1 = g_rvb[l_ac].rvb05
                    LET g_qryparam.arg1 = l_ima01
                    CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb05
                 END IF
                 #FUN-A20017--end--add------
                 NEXT FIELD rvb05
             WHEN INFIELD(rvb03) #P/O項次
                 CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pmn1"
                    LET g_qryparam.default1 = g_rvb[l_ac].rvb03
                    LET g_qryparam.arg1 = g_rvb[l_ac].rvb04
                    LET g_qryparam.construct='N'
                 CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb03
                 DISPLAY BY NAME g_rvb[l_ac].rvb03              #No.MOD-490371
                 NEXT FIELD rvb03
             WHEN INFIELD(rvb36) OR INFIELD(rvb37) OR INFIELD(rvb38)
                 CALL cl_init_qry_var()
                 #FUN-C30300---begin
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_rvb[l_ac].rvb05
                 #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38)
                    RETURNING g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38
                 ELSE
                 #FUN-C30300---end
                    CALL q_img4(FALSE,TRUE,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,  ##NO.FUN-660085
                                     g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,'A')
                    RETURNING g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38
                 END IF #FUN-C30300
                 DISPLAY g_rvb[l_ac].rvb36 TO rvb36
                 DISPLAY g_rvb[l_ac].rvb37 TO rvb37
                 DISPLAY g_rvb[l_ac].rvb38 TO rvb38
                 IF INFIELD(rvb36) THEN NEXT FIELD rvb36 END IF
                 IF INFIELD(rvb37) THEN NEXT FIELD rvb37 END IF
                 IF INFIELD(rvb38) THEN NEXT FIELD rvb38 END IF
             WHEN INFIELD(rvb25)
                 SELECT pmm04 INTO l_pmm04 FROM pmm_file
                  WHERE pmm01 = g_rvb[l_ac].rvb04
                 CALL q_coc2(FALSE,FALSE,g_rvb[l_ac].rvb25,'',l_pmm04,'1',
                             '',g_rvb[l_ac].rvb05)
                 RETURNING g_rvb[l_ac].rvb25,l_coc04
                  DISPLAY BY NAME g_rvb[l_ac].rvb25              #No.MOD-490371
                 NEXT FIELD rvb25
             WHEN INFIELD(rvb930)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb930
                DISPLAY BY NAME g_rvb[l_ac].rvb930
                NEXT FIELD rvb930
             WHEN INFIELD(rvb90) #rvb90
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb90
                DISPLAY BY NAME g_rvb[l_ac].rvb90
                NEXT FIELD rvb90
 
             OTHERWISE EXIT CASE
 
          END CASE
 
 
        ON ACTION invoice_data
#TQC-B60304 ---begin---mark
#TQC-B20099 --begin--        
#       IF g_sma.sma886[3,3] = 'N' THEN                  
#          CALL cl_err('','apm-199',1)
#       ELSE 
#TQC-B20099 --end--        	   
#TQC-B60304 ---end--
           #大陸版, 發票統一在入庫單發票維護作業輸入
           IF g_aza.aza26 != '2' THEN
              CALL sapmt114(g_rvb[l_ac].rvb22,g_rva.rva01)
                            RETURNING g_rvb[l_ac].rvb22
               DISPLAY g_rvb[l_ac].rvb22 TO rvb22 #No.MOD-480094
              IF INT_FLAG THEN LET INT_FLAG=0 END IF
             #判斷單身是否有發票號碼為空白的，
             #若有則詢問是否一起UPDATE成相同的發票號碼
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM rvb_file
                              WHERE rvb01 = g_rva.rva01
                                AND rvb02 != g_rvb[l_ac].rvb02
                                AND (rvb22 = ' ' OR rvb22 IS NULL)
 
             #發現單身發票欄位有空白的資料，詢問是否一起UPDATE
              IF l_cnt > 0 THEN
                 IF cl_confirm('aap-267') THEN
                    UPDATE rvb_file
                       SET rvb22=g_rvb[l_ac].rvb22
                     WHERE rvb01=g_rva.rva01
                       AND (rvb22 = ' ' OR rvb22 IS NULL)
 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                    ELSE
                        FOR l_i = 1 TO g_rec_b
                            IF cl_null(g_rvb[l_i].rvb22) THEN
                               LET g_rvb[l_i].rvb22 = g_rvb[l_ac].rvb22
                            END IF
                        END FOR
                 #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
                 #FUN-BB0001 add START
                        LET l_cnt2 = 0
                        SELECT COUNT(*) INTO l_cnt2 FROM rvv_file WHERE rvv04 = g_rva.rva01
                        IF l_cnt2 >= 1 THEN
                           UPDATE rvv_file
                              SET rvv22 = g_rvb[l_ac].rvb22
                             WHERE rvv04= g_rva.rva01
                               AND (rvv22 = ' ' OR rvv22 IS NULL)

                           IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","rvv_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)
                           END IF
                        END IF
                 #FUN-BB0001 add END
                    END IF
                 END IF
              END IF
 
             #UPDATE滑鼠所指向單身項次所對應的發票號碼
              UPDATE rvb_file
                 SET rvb22=g_rvb[l_ac].rvb22
               WHERE rvb01=g_rva.rva01
                 AND rvb02 = g_rvb[l_ac].rvb02
         #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
         #FUN-BB0001 add START
              LET l_cnt2 = 0
              SELECT COUNT(*) INTO l_cnt2 FROM rvv_file WHERE rvv04 = g_rva.rva01 AND rvv05 = g_rvb[l_ac].rvb02
              IF l_cnt2 >= 1 THEN
                 UPDATE rvv_file
                    SET rvv22 = g_rvb[l_ac].rvb22
                   WHERE rvv04= g_rva.rva01
                     AND rvv05 = g_rvb[l_ac].rvb02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","rvv_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1)
                 END IF
              END IF
          #FUN-BB0001 add END 
              DISPLAY BY NAME g_rvb[l_ac].rvb22 #No.MOD-480094
           END IF
#      END IF             #TQC-B20099 #TQC-B60304 mark 
#TQC-C20117--remark---begin-------------       
#FUN-B90101--mark--begin--
        ON ACTION maintain_other_data
           CALL t110_b_more()
 
        ON ACTION maintain_warehouse
           LET l_cmd = 'aimi200 ' CLIPPED
          CALL cl_cmdrun(l_cmd)
#FUN-B90101--mark--end--
#TQC-C20117--remark--end-----

        ON ACTION maintain_loc_warehouse
           LET l_cmd = "aimi201 '",g_rvb[l_ac].rvb36,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)
 
       ON ACTION default_loc_w_h
         #MOD-CB0079 -- add start --
          IF NOT t110_chk_rvb04(p_cmd) THEN
             NEXT FIELD rvb04
          END IF
         #MOD-CB0079 -- add end --
          CALL cl_init_qry_var()
          LET g_qryparam.form ="q_imf"
          LET g_qryparam.construct="N"
          LET g_qryparam.default1 = g_rvb[l_ac].rvb36
          CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
          NEXT FIELD rvb36
 
        ON ACTION modi_lot
           CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
           IF l_ec_sw = 'N' THEN      #CHI-A80024
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_rvb[l_ac].rvb05
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                    IF cl_null(g_rvb[l_ac].rvb37) THEN
                       LET g_rvb[l_ac].rvb37 = ' '
                    END IF
                    IF cl_null(g_rvb[l_ac].rvb38) THEN
                       LET g_rvb[l_ac].rvb38 = ' '
                    END IF
                    #MOD-BA0178 ----- start -----
                    IF g_rvb[l_ac].rvb02 != g_rvb_o.rvb02 THEN
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM rvbs_file 
                        WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02
                       IF l_cnt > 0 THEN
                          UPDATE rvbs_file SET rvbs02 =  g_rvb[l_ac].rvb02 
                           WHERE rvbs01 = g_rva.rva01 AND rvbs02 = g_rvb_o.rvb02 
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","rvbs_file",g_rvb[l_ac].rvb02,"",SQLCA.sqlcode,"","",1)
                          ELSE
                             LET g_rvb_o.rvb02 = g_rvb[l_ac].rvb02
                          END IF 
                       END IF
                    END IF
                    #MOD-BA0178 -----  end  -----
                    SELECT img09 INTO g_img09
                      FROM img_file   #庫存單位
                     WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                       AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                    CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)    #No.FUN-940083 pmn07-->rvb90 
                         RETURNING l_i,l_fac
                    IF l_i = 1 THEN LET l_fac = 1 END IF
                     #CHI-9A0022 --Begin
                     LET l_bno = ''
                     SELECT pmn122 INTO l_bno
                       FROM pmn_file
                      WHERE pmn01 = g_rvb[l_ac].rvb04
                        AND pmn02 = g_rvb[l_ac].rvb03
                     IF cl_null(l_bno) THEN
                        LET l_bno = ''
                     END IF
                     #CHI-9A0022 --End
                    CALL s_wo_record(g_rvb[l_ac].rvb34,'Y')   #MOD-CC0047 add
#TQC-B90236---mark---begin
#                   CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
#                                g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,     #No.FUN-940083 pmn07-->rvb90 
#                                l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD')#CHI-9A0022 add l_bno
#TQC-B90236---mark---end
#TQC-B90236---add----begin
                    CALL s_mod_lot(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                                   g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                   g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                   g_rvb[l_ac].rvb90,g_img09,l_fac,g_rvb[l_ac].rvb07,l_bno,'MOD',1)
#TQC-B90236---add----end
                        RETURNING l_r,g_qty 
                    IF l_r = "Y" THEN
                       LET g_rvb[l_ac].rvb07 = g_qty
                        #-----MOD-AB0076---------
                        DISPLAY BY NAME g_rvb[l_ac].rvb07 
                        CALL t110_set_rvb87()
                        IF g_sma.sma116 MATCHES '[02]' THEN
                           LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
                        END IF
                        #-----END MOD-AB0076-----
                    END IF
                 END IF   #FUN-850120
              END IF
           END IF   #CHI-A80024

#TQC-C20117---remark------begin----------------------
#FUN-B90101--mark--begin--
##-FUN-B60127- ADD - BEGIN ---------------------------------------------------------------
#       # - << 增加從採購單挑選功能 >> - #
        ON ACTION sel_from_procure
            CALL t110_sel_from_procure()
            EXIT INPUT
##-FUN-B60127- ADD -  END  ---------------------------------------------------------------

##FUN-A40014 --begin  --增加快速收货功能
        ON ACTION fast_receiving
            CALL t110_cre_tmp()
            CALL t110_rec()
            EXIT INPUT 
##FUN-A40014 --end    --           
  
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
  
       ON ACTION controls                                #No.FUN-6B0032
          CALL cl_set_head_visible("","AUTO")            #No.FUN-6B0032
#FUN-B90101--mark--end--
#TQC-C20117--remark---end-------------------------
   END INPUT
##&endif          #TQC-C20117--mark
#FUN-B90101 add &endif
#FUN-B90101--add--str--
END IF            #TQC-C20117--add
#TQC-C20117--mark---begin-----
#&ifdef SLK
#     ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
#        SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
#        IF l_ima151 = 'Y' THEN
#           IF li_a THEN
#              LET li_a = FALSE
#              NEXT FIELD rvbslk02
#           ELSE
#              LET li_a = TRUE
#              NEXT FIELD color
#           END IF
#        END IF
#&endif
#     ON ACTION maintain_other_data
#        CALL t110_b_more()

#     ON ACTION maintain_warehouse
#        LET l_cmd = 'aimi200 ' CLIPPED
#        CALL cl_cmdrun(l_cmd) 

#     ON ACTION sel_from_procure
#        CALL t110_sel_from_procure()
#        EXIT DIALOG 

#     ON ACTION fast_receiving
#        CALL t110_cre_tmp()
#        CALL t110_rec()
#        EXIT DIALOG 

#     ON ACTION CONTROLR
#        CALL cl_show_req_fields()

#     ON ACTION CONTROLG
#        CALL cl_cmdask()

#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DIALOG

#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121

#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121

#     ON ACTION controls                                #No.FUN-6B0032
#        CALL cl_set_head_visible("","AUTO")

#     ON ACTION ACCEPT
#        ACCEPT DIALOG

#     ON ACTION CANCEL
#        ROLLBACK WORK            
#        EXIT DIALOG

#   END DIALOG 
#FUN-B90101--add--end--
#TQC-C20117--mark---end----------------------

   UPDATE rva_file SET rvamodu=g_user,rvadate=g_today
                      ,rva32 = l_rva32                  #FUN-9C0076 add
    WHERE rva01=g_rva.rva01
   LET g_rva.rva32 = l_rva32  #FUN-C30293
   DISPLAY BY NAME g_rva.rva32                          #FUN-9C0076 add
   CALL t110_b_fill('1=1',' 1=1')    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
   COMMIT WORK  #NO.9728
   CALL t110_delHeader()     #CHI-C30002 add
  #FUN-C30248 add START
   IF g_flag2 = 'Y' THEN
      LET g_flag2 = 'N'
      CALL t110_b()
   END IF
  #FUN-C30248 add END

END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t110_delHeader()
DEFINE l_n LIKE type_file.num5
DEFINE l_action_choice    STRING               #CHI-C80041
DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
DEFINE l_num              LIKE type_file.num5  #CHI-C80041
DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
DEFINE l_sql              STRING               #CHI-C80041
DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   SELECT COUNT(*) INTO l_n FROM rvb_file WHERE rvb01 = g_rva.rva01
   IF l_n = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rva.rva01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rva_file ",
                  "  WHERE rva01 LIKE '",l_slip,"%' ",
                  "    AND rva01 > '",g_rva.rva01,"'"
      PREPARE t110_pb1 FROM l_sql 
      EXECUTE t110_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
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
         #CALL t110_x() #FUN-D20025 mark
         CALL t110_x(1) #FUN-D20025 add
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rva_file WHERE rva01=g_rva.rva01
         INITIALIZE g_rva.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#TQC-C20117--begin將部份程式從  t110_b_rvb38_inschk()  抽出来
FUNCTION t110_b_rvbslk38_inschk()
DEFINE      l_ima159        LIKE ima_file.ima159
DEFINE      g_img07         LIKE img_file.img07
DEFINE      g_img10         LIKE img_file.img10
DEFINE      g_img09         LIKE img_file.img09
DEFINE      p_cmd           LIKE type_file.chr1
   IF g_rvbslk[l_ac2].rvbslk38 = '　' THEN #全型空白
      LET g_rvbslk[l_ac2].rvbslk38 = ' '
   END IF
   IF g_rvbslk[l_ac2].rvbslk38 IS NULL THEN
      LET g_rvbslk[l_ac2].rvbslk38=' '
   END IF
   DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
   IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF l_ima159 = '1' AND cl_null(g_rvbslk[l_ac2].rvbslk38)
         AND g_rvbslk[l_ac2].rvbslk05[1,4]<>'MISC' AND l_ec_sw='N'  THEN
         CALL cl_err(g_rvbslk[l_ac2].rvbslk05,'aim-034',1)
         DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
         RETURN "rvb38"
      END IF
   END IF
   RETURN NULL
END FUNCTION
#TQC-C20117---end---------------------------------
#FUN-B50096 -----------------Begin------------------
FUNCTION t110_b_rvb38_inschk()
DEFINE      l_ima159        LIKE ima_file.ima159
DEFINE      g_img07         LIKE img_file.img07
DEFINE      g_img10         LIKE img_file.img10
DEFINE      g_img09         LIKE img_file.img09
DEFINE      p_cmd           LIKE type_file.chr1
#TQC-C20117---mark------------begin-----
#FUN-B90101--add--begin--
#&ifdef SLK
#  IF g_rvbslk[l_ac2].rvbslk38 = '　' THEN #全型空白
#     LET g_rvbslk[l_ac2].rvbslk38 = ' '
#  END IF
#  IF g_rvbslk[l_ac2].rvbslk38 IS NULL THEN
#     LET g_rvbslk[l_ac2].rvbslk38=' '
#  END IF
#  DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
#  IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
#     LET l_ima159 = ''
#     SELECT ima159 INTO l_ima159 FROM ima_file
#      WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
#     CALL t110_ec_sw() RETURNING l_ec_sw
#     IF l_ima159 = '1' AND cl_null(g_rvbslk[l_ac2].rvbslk38)
#        AND g_rvbslk[l_ac2].rvbslk05[1,4]<>'MISC' AND l_ec_sw='N'  THEN
#        CALL cl_err(g_rvbslk[l_ac2].rvbslk05,'aim-034',1)
#        DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
#        RETURN "rvb38"
#     END IF
#  END IF
#else
#FUN-B90101--add--end--   
#TQC-C20117---mark---end----
   IF g_rvb[l_ac].rvb38 = '　' THEN #全型空白
      LET g_rvb[l_ac].rvb38 = ' '
   END IF
   IF g_rvb[l_ac].rvb38 IS NULL THEN
      LET g_rvb[l_ac].rvb38=' '
   END IF
   DISPLAY BY NAME g_rvb[l_ac].rvb38
   IF g_rvb[l_ac].rvb36 = 'MISC' THEN RETURN NULL END IF   #TQC-C30193 
   IF NOT cl_null(g_rvb[l_ac].rvb05) THEN  
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_rvb[l_ac].rvb05 
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF l_ima159 = '1' AND cl_null(g_rvb[l_ac].rvb38)
         AND g_rvb[l_ac].rvb05[1,4]<>'MISC' AND l_ec_sw='N'  THEN
         CALL cl_err(g_rvb[l_ac].rvb05,'aim-034',1)   
         DISPLAY BY NAME g_rvb[l_ac].rvb38 
         RETURN "rvb38"                                                                                                  
      END IF                                                                                                               
   END IF
   #MOD-B90030 add begin--------------------------------
   IF g_rvb[l_ac].rvb05[1,4] = 'MISC' AND g_prog = 'apmt111' THEN
      DISPLAY BY NAME g_rvb[l_ac].rvb38
      RETURN NULL
   END IF
   #MOD-B90030 add end----------------------------------
   CALL t110_ec_sw() RETURNING l_ec_sw 
   IF NOT cl_null(g_rvb[l_ac].rvb36)  AND l_ec_sw='N' THEN
         SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
           FROM img_file   #採購單位,庫存數量,庫存單位
          WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
            AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
         IF STATUS=100 AND (g_rvb[l_ac].rvb36 IS NOT NULL AND g_rvb[l_ac].rvb36 <> ' ') THEN
            IF g_sma.sma892[3,3] ='Y' THEN
               IF NOT cl_confirm('mfg1401') THEN
                  RETURN "rvb38"
               END IF
            END IF

            CALL s_add_img(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                           g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06)
            IF g_errno='N' THEN   #MOD-C20091 add
               RETURN "rvb38"     #MOD-C20091 add
            END IF                #MOD-C20091 add
            SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
              FROM img_file
             WHERE img01 = g_rvb[l_ac].rvb05
               AND img02 = g_rvb[l_ac].rvb36
               AND img03 = g_rvb[l_ac].rvb37
               AND img04 = g_rvb[l_ac].rvb38
         END IF
         SELECT ima906 INTO g_ima906 FROM ima_file
          WHERE ima01=g_rvb[l_ac].rvb05
         IF g_ima906 = '2' THEN
            IF NOT cl_null(g_rvb[l_ac].rvb83) THEN
               CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                               g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                               g_rvb[l_ac].rvb83) RETURNING g_flag
               IF g_flag = 1 THEN
                  IF g_sma.sma892[3,3] ='Y' THEN
                     IF NOT cl_confirm('aim-995') THEN
                        RETURN "rvb36"
                     END IF
                  END IF
                  CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                  g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                  g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
                                  g_rva.rva01,
                                  g_rvb[l_ac].rvb02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                     RETURN "rvb36"
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_rvb[l_ac].rvb80) THEN
               CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                               g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                               g_rvb[l_ac].rvb80) RETURNING g_flag
               IF g_flag = 1 THEN
                  IF g_sma.sma892[3,3] ='Y' THEN
                     IF NOT cl_confirm('aim-995') THEN
                        RETURN "rvb36"
                     END IF
                  END IF
                  CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                  g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                  g_rvb[l_ac].rvb80,g_rvb[l_ac].rvb81,
                                  g_rva.rva01,
                                  g_rvb[l_ac].rvb02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                      RETURN "rvb36"
                  END IF
               END IF
            END IF
         END IF
         IF g_ima906 = '3' THEN
            IF NOT cl_null(g_rvb[l_ac].rvb83) THEN
               CALL s_chk_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                               g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                               g_rvb[l_ac].rvb83) RETURNING g_flag
               IF g_flag = 1 THEN
                  IF g_sma.sma892[3,3] ='Y' THEN
                     IF NOT cl_confirm('aim-995') THEN
                        RETURN "rvb36"
                     END IF
                  END IF
                  CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                  g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                  g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
                                  g_rva.rva01,
                                  g_rvb[l_ac].rvb02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                     RETURN "rvb36"
                  END IF
               END IF
            END IF
         END IF
   END IF
#&endif       #TQC-C20117--mark
#FUN-B90101 add &endif
   RETURN NULL
END FUNCTION
#FUN-B50096 -----------------End--------------------

#-FUN-B60127- ADD - BEGIN ---------------------------------------------------------------
FUNCTION t110_sel_from_procure()
DEFINE  l_temp  DYNAMIC ARRAY OF RECORD
        sel     LIKE type_file.chr1,
        pmm01   LIKE pmm_file.pmm01,
        pmm04   LIKE pmm_file.pmm04,
        pmn02   LIKE pmn_file.pmn02,
        pmn04   LIKE pmn_file.pmn04,
        pmn041  LIKE pmn_file.pmn041,
        pmn07   LIKE pmn_file.pmn07,
        pmn20   LIKE pmn_file.pmn20,
        pmn50   LIKE pmn_file.pmn50,
        pmn55   LIKE pmn_file.pmn55,
        dif     LIKE pmn_file.pmn20,
        pmn33   LIKE pmn_file.pmn33,
        pmn34   LIKE pmn_file.pmn34,
        pmn35   LIKE pmn_file.pmn35
                END RECORD
DEFINE  l_temp_t  RECORD
        sel     LIKE type_file.chr1,
        pmm01   LIKE pmm_file.pmm01,
        pmm04   LIKE pmm_file.pmm04,
        pmn02   LIKE pmn_file.pmn02,
        pmn04   LIKE pmn_file.pmn04,
        pmn041  LIKE pmn_file.pmn041,
        pmn07   LIKE pmn_file.pmn07,
        pmn20   LIKE pmn_file.pmn20,
        pmn50   LIKE pmn_file.pmn50,
        pmn55   LIKE pmn_file.pmn55,
        dif     LIKE pmn_file.pmn20,
        pmn33   LIKE pmn_file.pmn33,
        pmn34   LIKE pmn_file.pmn34,
        pmn35   LIKE pmn_file.pmn35
                END RECORD
DEFINE  l_sel_n LIKE type_file.num5
DEFINE  l_wc    STRING
DEFINE  p_row,p_col    LIKE type_file.num5
DEFINE  l_pmc03        LIKE pmc_file.pmc03
DEFINE  l_pmn58        LIKE pmn_file.pmn58
DEFINE  l_temp_rvb07   LIKE rvb_file.rvb07

   DROP TABLE apmt110_sel_pmm
   CREATE TEMP TABLE apmt110_sel_pmm(
                  sel     LIKE type_file.chr1,
                  pmm01   LIKE pmm_file.pmm01,
                  pmm04   LIKE pmm_file.pmm04,
                  pmn02   LIKE pmn_file.pmn02,
                  pmn04   LIKE pmn_file.pmn04,
                  pmn041  LIKE pmn_file.pmn041,
                  pmn07   LIKE pmn_file.pmn07,
                  pmn20   LIKE pmn_file.pmn20,
                  pmn50   LIKE pmn_file.pmn50,
                  pmn55   LIKE pmn_file.pmn55,
                  dif     LIKE pmn_file.pmn20,
                  pmn33   LIKE pmn_file.pmn33,
                  pmn34   LIKE pmn_file.pmn34,
                  pmn35   LIKE pmn_file.pmn35)
   DELETE FROM apmt110_sel_pmm

   OPEN WINDOW t110_w_p AT p_row,p_col WITH FORM "apm/42f/apmt110_p"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale('apmt110_p')
   CALL l_temp.clear()

   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_rva.rva05
   DISPLAY g_rva.rva05 TO FORMONLY.pmm09
   DISPLAY l_pmc03 TO FORMONLY.pmc03

   CONSTRUCT l_wc ON pmm01,pmm04,pmn02,pmn04,pmn041,pmn07,pmn20,pmn50,pmn55,pmn33,pmn34,pmn35
        FROM s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmn02,s_pmm[1].pmn04,
             s_pmm[1].pmn041,s_pmm[1].pmn07,s_pmm[1].pmn20,s_pmm[1].pmn50,
             s_pmm[1].pmn55,s_pmm[1].pmn33,s_pmm[1].pmn34,s_pmm[1].pmn35

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

         ON ACTION controlp
            CASE
              WHEN INFIELD(pmm01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmm_sel"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1 = g_rva.rva10
                   LET g_qryparam.arg2 = g_rva.rva05
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm01
                   NEXT FIELD pmm01
              WHEN INFIELD(pmn04)
                   CALL q_sel_ima(TRUE, "q_ima03","","","","","","","",'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmn04
                   NEXT FIELD pmn04
              WHEN INFIELD(pmn07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmn07
                   NEXT FIELD pmn07
            END CASE
                  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT 
                  
         ON ACTION about      
            CALL cl_about()
                     
         ON ACTION help           
            CALL cl_show_help()
                  
         ON ACTION controlg
            CALL cl_cmdask()      
                  
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT 
               
         ON ACTION qbe_select
            CALL cl_qbe_select()

   END CONSTRUCT
                 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW t110_w_p
      RETURN
   END IF     
                   
   LET g_sql = "SELECT 'N',pmm01,pmm04,pmn02,pmn04,pmn041,pmn07,pmn20,pmn50,pmn55,'',pmn33,pmn34,pmn35,pmn58",
               "  FROM pmm_file,pmn_file",
               " WHERE pmm01 = pmn01", 
               "   AND pmm09 = '",g_rva.rva05,"' ",
               "   AND pmm51 = '",g_rva.rva29,"' ",
               "   AND (pmn20-pmn50+pmn55+pmn58 > 0)",
               "   AND ",l_wc,
               "   AND pmm18 <> 'X' AND pmn16 = '2'",
               "   AND pmm02 = '",g_rva.rva10,"' "
   IF NOT cl_null(g_rva.rva02) THEN
      LET g_sql = g_sql," AND pmm01 = '",g_rva.rva02,"' "
   END IF     
   LET g_sql = g_sql," ORDER BY pmm01,pmn02"
                   
   LET g_cnt = 1
   
   PREPARE sel_pmm_pre FROM g_sql
   DECLARE sel_pmm_cs CURSOR FOR sel_pmm_pre
   
   FOREACH sel_pmm_cs INTO l_temp[g_cnt].*,l_pmn58
      IF SQLCA.sqlcode THEN
         CALL cl_err('','',0)
         EXIT FOREACH
      END IF
      
      SELECT SUM(rvb07) INTO l_temp_rvb07 FROM rva_file,rvb_file
       WHERE rvb04 = l_temp[g_cnt].pmm01 AND rvb03 = l_temp[g_cnt].pmn02
         AND rva01 = rvb01 AND rvaconf = 'N' AND rvb35 = 'N' 
      IF cl_null(l_temp_rvb07) THEN LET l_temp_rvb07 = 0 END IF
      
      LET l_temp[g_cnt].dif = l_temp[g_cnt].pmn20 - l_temp[g_cnt].pmn50 + l_temp[g_cnt].pmn55 + l_pmn58 - l_temp_rvb07
      IF cl_null(l_temp[g_cnt].dif) THEN
         LET l_temp[g_cnt].dif = 0
      END IF
      
      IF l_temp[g_cnt].dif > 0 THEN
         INSERT INTO apmt110_sel_pmm VALUES (l_temp[g_cnt].*)
         LET g_cnt = g_cnt + 1
      END IF
      IF g_cnt > g_max_rec THEN 
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
   
   CALL l_temp.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
   
   DISPLAY ARRAY l_temp TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY
   
   LET l_ac = 1
   
   INPUT ARRAY l_temp WITHOUT DEFAULTS FROM s_pmm.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)

       BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_temp_t.*=l_temp[l_ac].*

       ON ROW CHANGE
          UPDATE apmt110_sel_pmm SET sel = l_temp[l_ac].sel
           WHERE pmm01 = l_temp[l_ac].pmm01
             AND pmn02 = l_temp[l_ac].pmn02

       ON ACTION CONTROLG
           CALL cl_cmdask()

       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

       ON ACTION about
           CALL cl_about()

       ON ACTION help
           CALL cl_show_help()


   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t110_w_p
      RETURN
   END IF

   CLOSE WINDOW t110_w_p
   LET g_rec_b = 0 #TQC-C10074
   LET l_sel_n = 0
   SELECT COUNT(*) INTO l_sel_n FROM apmt110_sel_pmm WHERE sel = 'Y'
   IF l_sel_n > 0 THEN
      LET g_sel_from_procure = 'Y'
      CALL t110_g_b()
      IF g_azw.azw04='2' THEN             #TQC-C20117--add
         CALL t110_g_bslk()    #FUN-B90101 Add
      END IF                              #TQC-C20117--add
   END IF
   LET g_sel_from_procure = 'N'
END FUNCTION
#-FUN-B60127- ADD -  END  ---------------------------------------------------------------

#FUN-A40014--begin--
FUNCTION t110_cre_tmp()
    DROP TABLE t110_tmp;                                                     
    CREATE TEMP TABLE t110_tmp(                                              
       sel_all      LIKE type_file.chr1,                                        
       pmn01        LIKE pmn_file.pmn01,                                        
       pmn02        LIKE pmn_file.pmn02,
       pmm04        LIKE pmm_file.pmm04,
       pmn33        LIKE pmn_file.pmn33,
       pmn50_55     LIKE pmn_file.pmn20,
       pmn04        LIKE pmn_file.pmn04) 
       
    DROP TABLE t110_tmp1;
    CREATE TEMP TABLE t110_tmp1(
       pmn04        LIKE pmn_file.pmn04,
       pmn041       LIKE pmn_file.pmn041,
       pmn50_55     LIKE pmn_file.pmn20)
                                                                                                                     
END FUNCTION 
  
                         
FUNCTION t110_rec()

LET tm.order = '1'
LET tm.type  = '2'
DELETE FROM t110_tmp

  OPEN WINDOW apmt110_a WITH FORM "apm/42f/apmt110_a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apmt110_a")
    INPUT BY NAME tm.order,tm.type 
               WITHOUT DEFAULTS
                                
     AFTER FIELD order 
       IF tm.order NOT MATCHES '[12]' THEN 
           NEXT FIELD order
       END IF                             

     AFTER FIELD type
       IF tm.type NOT MATCHES '[12]'  THEN 
           NEXT FIELD type
       END IF                             

     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT 
        END IF
    
       IF tm.order NOT MATCHES '[12]' THEN 
           NEXT FIELD order 
       END IF                             

       IF tm.type NOT MATCHES '[12]' THEN 
           NEXT FIELD type
       END IF                             
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
 
  END INPUT

  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW apmt110_a
     RETURN
  END IF
  CALL t110_rec_b()
  CLOSE WINDOW apmt110_a
  CALL t110_b_fill('1=1',' 1=1')  #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
END FUNCTION 

FUNCTION t110_rec_b()
 DEFINE
      l_ac_t          LIKE type_file.num5, 
      l_ac1           LIKE type_file.num5,     
      l_n,l_n1,i      LIKE type_file.num5, 
      l_jump          LIKE type_file.num5,         
      l_i,l_t         LIKE type_file.num5,   
      l_cmd           LIKE type_file.chr50,        
      l_lock_sw       LIKE type_file.chr1,             
      p_cmd           LIKE type_file.chr1,       
      l_chr           LIKE type_file.chr1,   
      l_direct        LIKE type_file.chr1,     
      l_uflag         LIKE type_file.num5,
      l_allow_insert  LIKE type_file.num5,     #可新增否  
      l_allow_delete  LIKE type_file.num5,     #可刪除否 
      l_pmn50_55      LIKE pmn_file.pmn20,
      l_flag          LIKE type_file.chr1,
      l_rvb07         LIKE rvb_file.rvb07,
      l_flag1         LIKE type_file.chr1
 DEFINE l_where       STRING        #MOD-C30434 add

   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rva.rva01) THEN
      RETURN
   END IF
 
   SELECT * INTO g_rva.* FROM rva_file
    WHERE rva01=g_rva.rva01


   IF g_rva.rvaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_rva.rva01,'aom-000',0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF

  #FUN-9C0076  add str ---
   IF g_rva.rva32 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
   END IF
   IF g_rva.rvaconf='Y' AND g_rva.rva32 = "1" AND g_rva.rvamksg = "Y"  THEN
      CALL cl_err('','mfg3168',0)
      RETURN
   END IF
  #FUN-9C0076  add end ---
 
   CALL cl_opmsg('b')
   DELETE FROM t110_tmp1 
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_ac1 = 1  
   LET l_ac_t = 0  
   LET l_flag1 = 'Y'    
   CALL g_pmn1.clear() 
 
   INPUT ARRAY g_pmn1 WITHOUT DEFAULTS FROM s_pmn1.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
         BEFORE ROW
            LET p_cmd=''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_pmn1_t.* = g_pmn1[l_ac1].*  #BACKUP

#         AFTER INSERT
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0) 
#               CANCEL INSERT
#            END IF
#            INSERT INTO t110_tmp1 VALUES(g_pmn1[l_ac1].*)
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("ins","t110_tmp1",g_pmn1[l_ac1].pmn04,g_pmn1[l_ac1].pmn041,SQLCA.sqlcode,"","ins t110",1)
#               CANCEL INSERT
#            ELSE
#               MESSAGE 'INSERT O.K'
#            END IF            
            
               
         AFTER FIELD pmn04
            LET l_n1 = 0
            IF NOT cl_null(g_pmn1[l_ac1].pmn04) THEN
#FUN-AB0025 --------mark start------------
#              #FUN-AA0059 ---------------------start----------------------------
#              IF NOT s_chk_item_no(g_pmn1[l_ac1].pmn04,"") THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_pmn1[l_ac1].pmn04= g_pmn1_t.pmn04
#                 NEXT FIELD pmn04
#              END IF
#              #FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 -------mark end------------
               #CALL cl_err('','aim-927',0) 
               #NEXT FIELD pmn04
            #ELSE 
            	 SELECT COUNT(*) INTO l_n1 FROM t110_tmp1 WHERE pmn04 = g_pmn1[l_ac1].pmn04
            	 IF l_n1 > 0 THEN 
            	   CALL cl_err(g_pmn1[l_ac].pmn04,'-239',1)
            	   NEXT FIELD pmn04 
            	 END IF 
            	 SELECT ima02 INTO g_pmn1[l_ac1].pmn041 FROM ima_file WHERE ima01=g_pmn1[l_ac1].pmn04
            	 DISPLAY g_pmn1[l_ac1].pmn041 TO pmn041
              #MOD-C30434 -- add -- begin
               LET l_n1 = 0
               IF cl_null(g_rva.rva02) THEN
                  SELECT COUNT(ima01) INTO l_n1 FROM ima_file,pmn_file
                   WHERE ima01 = pmn04 
                     AND pmn04 = g_pmn1[l_ac1].pmn04
                     AND imaacti = 'Y'
                     AND (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ')
               ELSE
                  SELECT COUNT(ima01) INTO l_n1 FROM ima_file,pmn_file
                   WHERE ima01 = pmn04
                     AND pmn01 = g_rva.rva02
                     AND pmn04 = g_pmn1[l_ac1].pmn04
                     AND imaacti = 'Y'
                     AND (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ')
               END IF
               IF l_n1 = 0 THEN
                  CALL cl_err('','axm1022',0)
                  NEXT FIELD pmn04
               END IF
              #MOD-C30434 -- add -- end
            END IF 
         AFTER FIELD pmn50_55  #数量不可大于未交数量
            IF NOT cl_null(g_pmn1[l_ac1].pmn50_55) AND g_pmn1[l_ac1].pmn50_55 > 0  THEN 
               IF NOT cl_null(g_pmn1[l_ac1].pmn04) THEN                   
                  IF cl_null(g_rva.rva02) THEN #MOD-C70237 add
                     SELECT SUM(pmn20-pmn50+pmn55) INTO l_pmn50_55 FROM pmn_file,pmm_file 
                       WHERE pmn04 = g_pmn1[l_ac1].pmn04 AND pmn16 ='2' AND pmm01=pmn01 
                         AND pmm09 = g_rva.rva05
                     #No.TQC-A40099 --begin  
                     SELECT SUM(rvb07) INTO l_rvb07 FROM rva_file,rvb_file WHERE 
                            rvb05 = g_pmn1[l_ac1].pmn04 AND rva01=rvb01 
                            AND rvaconf='N' and rvb35 = 'N'
                  #MOD-C70237 add start -----
                  ELSE
                     SELECT SUM(pmn20-pmn50+pmn55) INTO l_pmn50_55 FROM pmn_file,pmm_file
                       WHERE pmn04 = g_pmn1[l_ac1].pmn04 AND pmn16 ='2' AND pmm01=pmn01
                         AND pmm09 = g_rva.rva05 AND pmn01 = g_rva.rva02
                     SELECT SUM(rvb07) INTO l_rvb07 FROM rva_file,rvb_file WHERE
                            rvb05 = g_pmn1[l_ac1].pmn04 AND rva01=rvb01
                            AND rvaconf='N' and rvb35 = 'N'
                            AND rvb04 = g_rva.rva02
                  END IF
                  #MOD-C70237 add end   -----
                  IF  cl_null(l_rvb07) THEN
                     LET l_rvb07 = 0
                  END IF 
                  LET l_pmn50_55 = l_pmn50_55 - l_rvb07
                  #No.TQC-A40099 --end 
                  IF g_pmn1[l_ac1].pmn50_55 > l_pmn50_55 THEN 
                     CALL cl_err(g_pmn1[l_ac1].pmn50_55,'apm1038',1)
                     NEXT FIELD pmn50_55
                  END IF 
               ELSE 
                  CALL cl_err('','aim-927',0) 
               	  NEXT FIELD pmn04
               END IF     
            ELSE
                 CALL cl_err('','mfg3331',0)
            	 NEXT FIELD pmn50_55
            END IF   
        BEFORE DELETE                            #是否取消單身
            IF g_pmn1_t.pmn04 IS NOT NULL THEN
               LET g_rec_b=g_rec_b-1
            END IF
 
        AFTER DELETE
          LET l_n = ARR_COUNT()
          INITIALIZE g_pmn1[l_n+1].* TO NULL

 
        AFTER ROW
            DISPLAY g_pmn1[l_ac1].* TO s_pmn1.*
            IF INT_FLAG THEN                 
             DISPLAY g_pmn1[l_ac1].* TO s_pmn1.*
             EXIT INPUT
            END IF
            #IF NOT cl_null(g_pmn1[l_ac1].pmn04) AND g_pmn1[l_ac1].pmn50_55 > 0 then
            #   CALL t110_rec_insert(g_pmn1[l_ac1].pmn04)
            #END IF 
        ON ACTION select_by_win
           IF l_ac1 > 0 AND NOT cl_null(g_pmn1[l_ac1].pmn04) AND g_pmn1[l_ac1].pmn50_55 > 0 THEN           
              SELECT COUNT(*) INTO l_n FROM t110_tmp WHERE pmn04 = g_pmn1[l_ac1].pmn04
              IF l_n > 0 THEN 
                CALL t110_rec_b_fill(g_pmn1[l_ac1].pmn04)
              ELSE 
              	CALL t110_rec_insert(g_pmn1[l_ac1].pmn04)
              	CALL t110_rec_b_fill(g_pmn1[l_ac1].pmn04)
              END IF
           ELSE 
           	 CALL cl_err(l_ac1,'apm1031',1)
           	 NEXT FIELD pmn04 
           END IF     
           CONTINUE INPUT 
  
        ON ACTION cancel
           LET l_flag1 = 'N' 
           EXIT INPUT 

        ON ACTION help                                                                                               
            LET g_action_choice="help"                                                                              
            CALL cl_show_help()                                                                                      
            CONTINUE INPUT                          
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmn04) #料件編號 
#FUN-AA0059---------mod------------str-----------------                                   
#                    CALL cl_init_qry_var()                                      
#                    LET g_qryparam.form = "q_ima"                               
#                    LET g_qryparam.default1 = g_pmn1[l_ac1].pmn04                                 
#                    CALL cl_create_qry() RETURNING g_pmn1[l_ac1].pmn04
                   #MOD-C30434 -- add -- begin
                    IF cl_null(g_rva.rva02) THEN
                       LET l_where = ''
                    ELSE
                       LET l_where = "(ima01 IN (SELECT pmn04 FROM                                                pmn_file WHERE pmn01 = '",g_rva.rva02,"'))"
                    END IF
                   #MOD-C30434 -- add -- end
                    CALL q_sel_ima(FALSE, "q_ima",l_where,   #MOD-C30434 add l_where
                                   g_pmn1[l_ac1].pmn04,"","","","","",'' ) 
                       RETURNING g_pmn1[l_ac1].pmn04
#FUN-AA0059---------mod------------end-----------------          
                    DISPLAY g_pmn1[l_ac1].pmn04 TO pmn04                        
                    NEXT FIELD pmn04      
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        
 
    END INPUT
   
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW apmt110_a
     RETURN
  END IF

    LET l_flag ='N'
    FOR i=1 TO g_pmn1.getLength() 
      IF g_pmn1[i].pmn04 IS NOT NULL AND g_pmn1[i].pmn50_55 > 0 THEN
         LET l_flag = 'Y'
         EXIT FOR
      END IF 
    END FOR

    FOR i =1 TO g_pmn1.getLength()
      IF g_pmn1[i].pmn04 IS NOT NULL AND g_pmn1[i].pmn50_55 > 0 THEN
       INSERT INTO t110_tmp1 VALUES (g_pmn1[i].*)
      END IF
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM t110_tmp WHERE pmn04 = g_pmn1[i].pmn04
      IF l_n <= 0 THEN 
         CALL t110_rec_insert(g_pmn1[i].pmn04)
      END IF 
    END FOR 

    IF l_flag ='Y' AND l_flag1 ='Y'  THEN 
        CALL t110_gen_b()  #产生单身
        CALL s_showmsg()
        CALL ui.Interface.refresh()
    END IF 
           
END FUNCTION 

FUNCTION t110_gen_b()
DEFINE l_sql  LIKE type_file.chr1000
DEFINE l_sql1 LIKE type_file.chr1000
DEFINE l_n    LIKE type_file.num5
DEFINE l_cnt  LIKE type_file.num5
DEFINE l_sum  LIKE pmn_file.pmn20
DEFINE l_sum1  LIKE pmn_file.pmn20
DEFINE l_pmn50_55 LIKE pmn_file.pmn20 
DEFINE l_pmn1         RECORD 
                pmn04    LIKE pmn_file.pmn04,
                pmn041   LIKE pmn_file.pmn041,
                pmn50_55 LIKE pmn_file.pmn20
                      END RECORD,
       l_pmn2         RECORD
           sel_all   LIKE type_file.chr1,
           pmn01     LIKE pmn_file.pmn01,
           pmn02     LIKE pmn_file.pmn02,
           pmm04     LIKE pmm_file.pmm04,
           pmn33     LIKE pmn_file.pmn33,
           pmn50_55  LIKE pmn_file.pmn20,
           pmn04     LIKE pmn_file.pmn04
            END RECORD

                  

  INITIALIZE l_pmn1.* TO NULL 
  INITIALIZE l_pmn2.* TO NULL

  LET g_success = 'Y'                     
  BEGIN WORK 
  DECLARE t110_gen_curs CURSOR FOR SELECT * FROM t110_tmp1 
  SELECT COUNT(*) INTO l_n FROM rvb_file WHERE rvb01 = g_rva.rva01
  IF l_n > 0 THEN 
    LET l_n = l_n + 1
  ELSE 
    LET l_n = 1
  END IF 
  FOREACH t110_gen_curs INTO l_pmn1.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('prepare_e:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
    LET l_sql  = "SELECT * FROM t110_tmp WHERE  sel_all='Y' ",
                " AND pmn04 = '",l_pmn1.pmn04,"'"
                
    LET l_sql1 = "SELECT * FROM t110_tmp WHERE  sel_all!='Y' ",
                " AND pmn04 = '",l_pmn1.pmn04,"'"
    IF tm.order = '1' THEN
       IF tm.type = '1' THEN
          let l_sql  = l_sql ," order by pmm04 "
          LET l_sql1 = l_sql1 ," order by pmm04 "
       ELSE 
          LET l_sql  = l_sql ," order by pmn33 "
          LET l_sql1 = l_sql1 ," order by pmn33 "
       END IF 
    ELSE
       IF tm.type = '1' THEN
          let l_sql  = l_sql ," order by pmm04 DESC "
          LET l_sql1 = l_sql1 ," order by pmm04 DESC "
       ELSE 
          LET l_sql  = l_sql ," order by pmn33 DESC "
          LET l_sql1 = l_sql1 ," order by pmn33 DESC "
       END IF 
    END IF   

     PREPARE t110_gen_c1 FROM l_sql
     IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
     END IF 
     DECLARE t110_gen_curs1 CURSOR FOR t110_gen_c1
     LET l_sum = 0 
     FOREACH t110_gen_curs1 INTO l_pmn2.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('prepare_e:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
       LET l_sum1 = l_sum
       LET l_sum = l_sum + l_pmn2.pmn50_55 
       IF l_sum < l_pmn1.pmn50_55 THEN 
         CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55 )
       ELSE 
       	 IF l_sum = l_pmn1.pmn50_55 THEN 
       	   CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55)
       	   EXIT FOREACH 
       	 ELSE 
       	 	 LET l_pmn2.pmn50_55 = l_pmn1.pmn50_55 - l_sum1
       	 	 CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55)
       	 	 EXIT FOREACH 
       	 END IF 
       END IF    
       LET l_n = l_n + 1 
     END FOREACH 
     
     PREPARE t110_gen_c2 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE t110_gen_curs2 CURSOR FOR t110_gen_c2
     INITIALIZE l_pmn2.* TO null   
     IF cl_null(l_pmn1.pmn50_55) THEN
        LET l_pmn1.pmn50_55 = 0
     END IF  
     IF l_sum < l_pmn1.pmn50_55 THEN  
      FOREACH t110_gen_curs2 INTO l_pmn2.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare_e:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
       LET l_sum1 = l_sum
       LET l_sum = l_sum + l_pmn2.pmn50_55 
       IF l_sum < l_pmn1.pmn50_55 THEN 
         CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55 )
       ELSE 
       	 IF l_sum = l_pmn1.pmn50_55 THEN 
       	   CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55)
       	   EXIT FOREACH 
       	 ELSE 
       	 	 LET l_pmn2.pmn50_55 = l_pmn1.pmn50_55 - l_sum1
       	 	 CALL t110_ins_rvb1(l_pmn2.pmn01,l_pmn2.pmn02,l_n,l_pmn2.pmn50_55)
       	 	 EXIT FOREACH 
       	 END IF 
       END IF    
       LET l_n = l_n + 1        
      END FOREACH 
     END IF 
    LET l_n = l_n + 1
 END FOREACH 
 IF g_success = 'Y' THEN
    COMMIT WORK 
 ELSE
    ROLLBACK WORK
    CALL s_showmsg()
 END IF 
 
END FUNCTION 

FUNCTION t110_ins_rvb1(p_pmn01,p_pmn02,p_sum,p_pmn50_55)
 DEFINE   p_pmn01   LIKE   pmn_file.pmn01
 DEFINE   p_pmn02   LIKE   pmn_file.pmn02
 DEFINE   p_pmn50_55 LIKE  pmn_file.pmn20
 DEFINE   p_sum     LIKE   type_file.num5
 DEFINE   l_pmn     RECORD LIKE pmn_file.*
 DEFINE   l_rvb1    RECORD LIKE rvb_file.*
 DEFINE   l_rvb87   LIKE   rvb_file.rvb87
 DEFINE   l_rvb29   LIKE   rvb_file.rvb29
 DEFINE   l_ima491  LIKE   ima_file.ima491
 DEFINE   l_img09   LIKE   img_file.img09
 DEFINE   l_flag    LIKE   type_file.num5
 DEFINE   l_fac     LIKE   rvb_file.rvb90_fac
 DEFINE   l_rtz08   LIKE rtz_file.rtz08         #FUN-B40098 ADD
 DEFINE   l_rtz07   LIKE   rtz_file.rtz07       #FUN-B60150 ADD
 DEFINE   l_rvbi1     RECORD LIKE rvbi_file.*    #CHI-B70016

   INITIALIZE l_rvb1.* TO NULL
   INITIALIZE l_pmn.* TO NULL
   SELECT * INTO l_pmn.* FROM pmn_file 
    WHERE pmn01 = p_pmn01 
      AND pmn02 = p_pmn02 
   LET l_rvb1.rvb01 = g_rva.rva01
   LET l_rvb1.rvb02 = p_sum
   LET l_rvb1.rvb03 = l_pmn.pmn02
   LET l_rvb1.rvb04 = l_pmn.pmn01
   LET l_rvb1.rvb05 = l_pmn.pmn04
   LET l_rvb1.rvb06 = 0
   LET l_rvb1.rvb90 = l_pmn.pmn07
   LET l_rvb87 = 0
   LET l_rvb29 = 0
   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02
      AND rva01 = rvb01 AND rvaconf = 'N' AND rvb01 = g_rva1.rva01
       
   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
   
   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02  
      AND rva01 = rvb01 AND rvaconf = 'N' AND rvb01 = g_rva1.rva01

   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
   
   IF cl_null(l_pmn.pmn20) THEN LET l_pmn.pmn20 = 0 END IF 
   IF cl_null(l_pmn.pmn50) THEN LET l_pmn.pmn50 = 0 END IF
   IF cl_null(l_pmn.pmn55) THEN LET l_pmn.pmn55 = 0 END IF  
   IF cl_null(l_pmn.pmn31) THEN LET l_pmn.pmn31 = 0 END IF

   LET l_rvb1.rvb07 = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55-l_rvb87+l_rvb29
   IF  l_rvb1.rvb07 > p_pmn50_55 THEN
       LET l_rvb1.rvb07 = p_pmn50_55
   END IF  
   LET l_rvb1.rvb08 = l_rvb1.rvb07
   LET l_rvb1.rvb09 = 0
   LET l_rvb1.rvb10 = l_pmn.pmn31
   LET l_rvb1.rvb10t = l_pmn.pmn31t 
 
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = l_rvb1.rvb05
   IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF  
   
   IF l_ima491 >0 THEN
      CALL s_getdate(g_rva1.rva06,l_ima491) RETURNING l_rvb1.rvb12
   ELSE
      IF cl_null(l_rvb1.rvb12)  THEN
        LET l_rvb1.rvb12 = g_rva1.rva06
      END IF
   END IF
   LET l_rvb1.rvb13 = NULL
   LET l_rvb1.rvb14 = NULL
   LET l_rvb1.rvb15 = 0
   LET l_rvb1.rvb16 = 0
   LET l_rvb1.rvb17 = NULL
   LET l_rvb1.rvb18 = '10'
   LET l_rvb1.rvb19 = l_pmn.pmn65
   LET l_rvb1.rvb20 = NULL
   LET l_rvb1.rvb21 = NULL
   LET l_rvb1.rvb25 = l_pmn.pmn71
   LET l_rvb1.rvb27 = 0
   LET l_rvb1.rvb28 = 0
   LET l_rvb1.rvb29 = 0
   LET l_rvb1.rvb30 = 0
   LET l_rvb1.rvb31 = l_rvb1.rvb07
   LET l_rvb1.rvb32 = 0 
   LET l_rvb1.rvb33 = 0
   LET l_rvb1.rvb331 = 0
   LET l_rvb1.rvb332 = 0
   LET l_rvb1.rvb34 = l_pmn.pmn41
   LET l_rvb1.rvb35 = 'N'
   LET l_rvb1.rvb89 = l_pmn.pmn89
   LET l_rvb1.rvb051 = l_pmn.pmn041
   LET l_rvb1.rvb90 = l_pmn.pmn07
   LET l_rvb1.rvb31 = s_digqty(l_rvb1.rvb31,l_rvb1.rvb90)   #No.FUN-BB0086
   
   IF l_rvb1.rvb89 = 'Y'  THEN
     SELECT pmc915,pmc916 INTO l_rvb1.rvb36,l_rvb1.rvb37
      FROM pmc_file  WHERE pmc01 = l_rvb1.rvb05 
   ELSE
     LET l_rvb1.rvb36 = l_pmn.pmn52
     LET l_rvb1.rvb37 = l_pmn.pmn54
     IF cl_null(l_rvb1.rvb36) AND cl_null(l_rvb1.rvb37)  THEN
        SELECT ima35,ima36 INTO l_rvb1.rvb36,l_rvb1.rvb37
          FROM ima_file WHERE ima01 = l_rvb1.rvb05
      #FUN-B60150 ADD&MARK BEGIN ----------------------------
      ##FUN-B40098 Begin---
      # IF g_azw.azw04 = '2' AND g_rva.rva29 = '3' THEN
      #    SELECT rtz08 INTO l_rtz08 FROM rtz_file
      #     WHERE rtz01 = g_rva.rvaplant
      #    IF NOT cl_null(l_rtz08) THEN
      #       LET l_rvb1.rvb36 = l_rtz08
      #       LET l_rvb1.rvb37 = ' '
      #       LET l_rvb1.rvb38 = ' '
      #    END IF
      # END IF
      ##FUN-B40098 End-----

        IF g_azw.azw04 = '2' THEN
           #FUN-C90049 mark begin---
           #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
           # WHERE rtz01 = g_rva.rvaplant
           #FUN-C90049 mark end-----
           CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
           IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2') THEN
              IF NOT cl_null(l_rtz08) THEN
                 LET l_rvb1.rvb36 = l_rtz08
                 LET l_rvb1.rvb37 = ' '
                 LET l_rvb1.rvb38 = ' '
              END IF
           END IF
           IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
              IF NOT cl_null(l_rtz07) THEN
                 LET l_rvb1.rvb36 = l_rtz07
                 LET l_rvb1.rvb37 = ' '
                 LET l_rvb1.rvb38 = ' '
              END IF
           END IF
        END IF
      #FUN-B60150 ADD&MARK   END ----------------------------
     END IF    
   END IF
#FUN-AB0066 --begin--   
#   #No.FUN-AA0049--begin
#   IF NOT s_chk_ware(l_rvb1.rvb36) THEN
#      LET l_rvb1.rvb36=' '
#      LET l_rvb1.rvb37=' '
#   END IF 
#   #No.FUN-AA0049--end        
#FUN-AB0066 --end--   
   LET l_rvb1.rvb38 = l_pmn.pmn56
   IF l_rvb1.rvb38 IS NULL THEN
      LET l_rvb1.rvb38 = ' '
   END IF
   IF l_rvb1.rvb37 IS NULL THEN
      LET l_rvb1.rvb37 = ' '
   END IF   
   
   CALL t110_get_rvb39(l_rvb1.rvb03,l_rvb1.rvb04,l_rvb1.rvb05,l_rvb1.rvb19,g_rva.rva05,g_sma.sma886) 
        RETURNING l_rvb1.rvb39
        
   LET l_rvb1.rvb40 = ' '
   LET l_rvb1.rvb80 = l_pmn.pmn80
   LET l_rvb1.rvb81 = l_pmn.pmn81
   LET l_rvb1.rvb82 = l_pmn.pmn82
   LET l_rvb1.rvb83 = l_pmn.pmn83
   LET l_rvb1.rvb84 = l_pmn.pmn84
   LET l_rvb1.rvb85 = l_pmn.pmn85
   LET l_rvb1.rvb86 = l_pmn.pmn86
   LET l_rvb1.rvb87 = l_rvb1.rvb07
   LET l_rvb1.rvb88 = l_rvb1.rvb87*l_rvb1.rvb10
   LET l_rvb1.rvb88t = l_rvb1.rvb87*l_rvb1.rvb10t
   LET l_rvb1.rvb930 = l_pmn.pmn930
   LET l_rvb1.rvbplant = g_plant
   LET l_rvb1.rvblegal = g_legal
   LET l_rvb1.rvb42 = ' '
   LET l_rvb1.rvb93 = ''   
   INSERT INTO rvb_file VALUES (l_rvb1.*)
   IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
      CALL s_errmsg('','','ins rvb_file',SQLCA.sqlcode,1)
      LET g_success = 'N'            
   ELSE 
#CHI-B70016-add-str--
      LET l_rvbi1.rvbi01 = l_rvb1.rvb01
      LET l_rvbi1.rvbi02 = l_rvb1.rvb02
      IF NOT s_ins_rvbi(l_rvbi1.*,'') THEN
         LET g_success = 'N'
      END IF
#CHI-B70016-add-end--
      LET g_fast_rec = 'Y'                                                                          
   END IF
END FUNCTION

FUNCTION t110_rec_insert(p_pmn04)
DEFINE p_pmn04 LIKE pmn_file.pmn04
DEFINE l_sql   STRING
DEFINE l_rvb07 LIKE rvb_file.rvb07 
DEFINE l_pmn2  RECORD 
           sel_all   LIKE type_file.chr1,
           pmn01     LIKE pmn_file.pmn01,
           pmn02     LIKE pmn_file.pmn02,
           pmm04     LIKE pmm_file.pmm04,
           pmn33     LIKE pmn_file.pmn33,
           pmn50_55  LIKE pmn_file.pmn20,
           pmn04     LIKE pmn_file.pmn04
             END RECORD 
             
  IF cl_null(g_rva.rva02) THEN #MOD-C70237 add
     LET l_sql = "SELECT 'N',pmn01,pmn02,pmm04,pmn33,(pmn20-(pmn50-pmn55)),pmn04 FROM pmn_file,pmm_file ", 
                  " WHERE pmn01=pmm01 and pmn16='2'",
                  " AND pmn04 ='",p_pmn04,"'",
                  " AND pmm09 ='",g_rva.rva05,"'"
  #MOD-C70237 add start -----
  ELSE
     LET l_sql = "SELECT 'N',pmn01,pmn02,pmm04,pmn33,(pmn20-(pmn50-pmn55)),pmn04 FROM pmn_file,pmm_file ",
                  " WHERE pmn01=pmm01 and pmn16='2'",
                  " AND pmn04 ='",p_pmn04,"'",
                  " AND pmm09 ='",g_rva.rva05,"' AND pmn01 ='",g_rva.rva02,"'"
  END IF
  #MOD-C70237 add end   -----

#MOD-C30434  --add--begin  
  IF NOT cl_null(g_rva.rva02) THEN 
     LET l_sql = l_sql CLIPPED," AND pmn01='",g_rva.rva02,"'"
  END IF 
#MOD-C30434  --add--end              
  PREPARE t110_pmn3 FROM l_sql
  DECLARE t110_pmn3_curs CURSOR FOR t110_pmn3
  FOREACH t110_pmn3_curs INTO l_pmn2.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT SUM(rvb07) INTO l_rvb07 FROM rvb_file,rva_file 
           WHERE rvb04 = l_pmn2.pmn01 AND rvb03 = l_pmn2.pmn02 AND rvaconf='N'
           AND rva01 = rvb01 AND rvb35 ='N'
       IF cl_null(l_rvb07) THEN
          LET l_rvb07 = 0
       END IF 
       LET l_pmn2.pmn50_55 = l_pmn2.pmn50_55 - l_rvb07
       IF l_pmn2.pmn50_55 <= 0 THEN
         CONTINUE FOREACH
       END IF  
       INSERT INTO t110_tmp VALUES (l_pmn2.*)
  END FOREACH 
END FUNCTION 

FUNCTION t110_rec_b_fill(p_pmn04)
DEFINE l_sql   STRING 
DEFINE p_pmn04 LIKE pmn_file.pmn04

   OPEN WINDOW t110_b WITH FORM "apm/42f/apmt110_b"
   	            ATTRIBUTE(STYLE = g_win_style CLIPPED )
   CALL cl_ui_locale("apmt110_b")
              
   LET l_sql = "select 'N',pmn01,pmn02,pmm04,pmn33,pmn50_55 FROM t110_tmp ",
               " WHERE pmn04 = '",p_pmn04,"'"

    IF tm.order = '1' THEN
       IF tm.type = '1' THEN
          let l_sql  = l_sql ," order by pmm04 "
       ELSE 
          LET l_sql  = l_sql ," order by pmn33 "
       END IF 
    ELSE
       IF tm.type = '1' THEN
          let l_sql  = l_sql ," order by pmm04 DESC "
       ELSE 
          LET l_sql  = l_sql ," order by pmn33 DESC "
       END IF 
    END IF   
   PREPARE t110_pmn22 FROM l_sql
   CALL ui.Interface.refresh()
   CALL g_pmn2.clear() 
   DECLARE t110_pmn22_curs CURSOR FOR t110_pmn22
   LET g_cnt = 1
   FOREACH t110_pmn22_curs INTO g_pmn2[g_cnt].*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH 
   CALL g_pmn2.deleteElement(g_cnt)
 
   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
   
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
   DISPLAY ARRAY g_pmn2 TO s_pmn2.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
 
   CALL t110_rec_detail(p_pmn04)              
                    
END FUNCTION 

FUNCTION t110_rec_detail(p_pmn04)
 DEFINE p_pmn04 LIKE pmn_file.pmn04 
 DEFINE i       LIKE type_file.num5 
 DEFINE l_ac1   LIKE type_file.num5
 DEFINE l_rec_b LIKE type_file.num5

  
       LET g_action_choice = " "
 
      INPUT ARRAY g_pmn2 WITHOUT DEFAULTS FROM s_pmn2.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
         BEFORE ROW
              LET l_ac1 = ARR_CURR()
              LET l_rec_b = ARR_COUNT()
               IF l_ac1 = 0 THEN
                LET l_ac1 = 1
               END IF
             CALL fgl_set_arr_curr(l_ac1)
             CALL cl_show_fld_cont()
             LET g_pmn2_t.* = g_pmn2[l_ac1].*
 
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT 
            END IF

         ON CHANGE sel_all
            IF cl_null(g_pmn2[l_ac1].sel_all) THEN 
               LET g_pmn2[l_ac1].sel_all = 'Y'
            END IF
 
         ON ACTION selectall
            #FOR i = 1 TO g_pmn2.getLength()
            FOR i = 1 TO l_rec_b
              LET g_pmn2[i].sel_all = "Y"
            END FOR

         ON ACTION select_none
            #FOR i = 1 TO g_pmn2.getLength()
            FOR i = 1 TO l_rec_b 
               LET g_pmn2[i].sel_all = "N"
            END FOR

         ON ACTION ACCEPT 
            DELETE FROM t110_tmp WHERE pmn04 = p_pmn04 
            FOR i=1 TO g_pmn2.getLength()                               
                INSERT INTO t110_tmp VALUES (g_pmn2[i].*,p_pmn04)                                  
            END FOR 
            EXIT INPUT
  
            
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
      END INPUT 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW t110_b
     RETURN
  END IF    
 
  CLOSE WINDOW t110_b
  DISPLAY ARRAY g_pmn1 TO s_pmn1.*
    BEFORE DISPLAY 
      EXIT DISPLAY
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY

  END DISPLAY 
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
  
#FUN-A40014--end--   

#得到取價類型、價格來源、來源單號、來源項次
FUNCTION t110_get_price()
DEFINE l_sma135 LIKE sma_file.sma135   
DEFINE l_pmm    RECORD LIKE pmm_file.*  
DEFINE l_pmn    RECORD LIKE pmn_file.* 

#FUN-B90101--add--begin-- 
    IF g_azw.azw04='2' THEN                    #TQC-C20117--add
       IF g_rvbslk[l_ac2].rvbslk04 IS NULL OR g_rvbslk[l_ac2].rvbslk03 IS NULL THEN
          RETURN
       END IF
       SELECT sma135 INTO l_sma135 FROM sma_file
       IF l_sma135 = 'Y' THEN
          SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.* FROM pmm_file,pmn_file
            WHERE pmm01 = pmn01
              AND pmm01 = g_rvbslk[l_ac2].rvbslk04
              AND pmn02 = g_rvbslk[l_ac2].rvbslk03
       ELSE
          SELECT pmn73,pmn74,pmn75,pmn76
            INTO g_rvbslk[l_ac2].rvbslk42,g_rvbslk[l_ac2].rvbslk43,
                 g_rvb44,g_rvb45
             FROM pmn_file WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
              AND pmn02 = g_rvbslk[l_ac2].rvbslk03
       END IF
       DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk42,g_rvbslk[l_ac2].rvbslk43
#TQC-C20117---add----begin--------------------------------
    ELSE
       IF g_rvb[l_ac].rvb04 IS NULL OR g_rvb[l_ac].rvb03 IS NULL THEN
          RETURN
       END IF
       SELECT sma135 INTO l_sma135 FROM sma_file
       IF l_sma135 = 'Y' THEN
          SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.* FROM pmm_file,pmn_file
            WHERE pmm01 = pmn01
              AND pmm01 = g_rvb[l_ac].rvb04
              AND pmn02 = g_rvb[l_ac].rvb03
          LET g_rvb[l_ac].rvb44 = l_pmn.pmn75
          LET g_rvb[l_ac].rvb45 = l_pmn.pmn76
       ELSE
          SELECT pmn73,pmn74,pmn75,pmn76
             INTO g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43,
                 g_rvb[l_ac].rvb44,g_rvb[l_ac].rvb45
            FROM pmn_file WHERE pmn01 = g_rvb[l_ac].rvb04
              AND pmn02 = g_rvb[l_ac].rvb03
       END IF
         DISPLAY BY NAME g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43,
                    g_rvb[l_ac].rvb44,g_rvb[l_ac].rvb45
    END IF
#TQC-C20117---add----end----------------------------------     
#FUN-B90101 add &endif
END FUNCTION


FUNCTION t110_g_b()        #自動由採購單產生收料單
   DEFINE l_pmh08  LIKE pmh_file.pmh08
   DEFINE l_pmm22  LIKE pmm_file.pmm22
   DEFINE l_rvb07s LIKE rvb_file.rvb07
   DEFINE l_ima491 LIKE ima_file.ima491
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_sfb39  LIKE sfb_file.sfb39
   DEFINE l_pmn122 LIKE pmn_file.pmn122
   DEFINE l_ima906 LIKE ima_file.ima906   #No.FUN-540027
   DEFINE l_pmn88  LIKE pmn_file.pmn88    #No.FUN-540027
   DEFINE l_pmn88t LIKE pmn_file.pmn88t   #No.FUN-540027
   DEFINE l_rvb82  LIKE rvb_file.rvb82    #No.MOD-6B0162
   DEFINE l_rvb85  LIKE rvb_file.rvb85    #No.MOD-6B0162
   DEFINE i        LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_pmn65  LIKE pmn_file.pmn65
   DEFINE l_msg    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)    #No.MOD-570411
   DEFINE l_pmm    RECORD LIKE pmm_file.* #FUN-810038
   DEFINE l_pmn    RECORD LIKE pmn_file.* #FUN-810038
   DEFINE l_rvb87_o LIKE rvb_file.rvb87   #No.MOD-830171
   DEFINE l_rvb07_s LIKE rvb_file.rvb07     #MOD-850298
   DEFINE l_rvb87_s LIKE rvb_file.rvb87     #MOD-850298
   DEFINE l_pmm02   LIKE pmm_file.pmm02     #MOD-860146
   DEFINE l_type    LIKE type_file.chr1     #MOD-860146
   DEFINE l_pmn41   LIKE pmn_file.pmn41     #MOD-860146
   DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
   DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
   DEFINE l_pmni   RECORD LIKE pmni_file.* #FUN-810038
   DEFINE l_pmn18   LIKE pmn_file.pmn18   #CHI-8C0017
   DEFINE l_pmn012   LIKE pmn_file.pmn012 #FUN-A60076 add 
   DEFINE l_sfb24   LIKE sfb_file.sfb24   #MOD-910227
   DEFINE l_pmc915  LIKE pmc_file.pmc915  #FUN-940083
   DEFINE l_pmc916  LIKE pmc_file.pmc916  #FUN-940083
   DEFINE l_times   LIKE type_file.num5    #NO.FUN-960130
   DEFINE l_n       LIKE type_file.num5   #NO.FUN-960130
   DEFINE l_n1,l_n2 LIKE type_file.num5   #NO.FUN-960130  #TQC-B40126 add
   DEFINE l_rtz07   LIKE rtz_file.rtz07   #NO.FUN-960130
   DEFINE l_rtz08   LIKE rtz_file.rtz08   #FUN-B60150 ADD
   DEFINE l_sma135  LIKE sma_file.sma135  #FUN-870007
   DEFINE l_cnt     LIKE type_file.num5   #FUN-C30281
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_cnt     LIKE type_file.num5   #No.FUN-A50054
#  DEFINE l_ata05   LIKE ata_file.ata05   #No.FUN-A5054
#  DEFINE l_ata RECORD LIKE ata_file.*    #No.FUN-A50054
#  DEFINE l_prog    LIKE type_file.chr20  #No.FUN-A50054
#FUN-A60035 ---MARK END
#TQC-AB0165--begin--add-----
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_fac     LIKE rvb_file.rvb90_fac
#TQC-AB0165-end--add--------
   DEFINE l_sfa161  LIKE sfa_file.sfa161    #FUN-C30248 add
   DEFINE l_qty     LIKE rvb_file.rvb07     #FUN-C30248 add 

   #FUN-C20002--start add----------------------------------
   DEFINE l_ima154  LIKE ima_file.ima154
   DEFINE l_rcj03   LIKE rcj_file.rcj03
   #FUN-C20002--end add------------------------------------
   DEFINE l_ima153  LIKE ima_file.ima153  #FUN-C30166
   DEFINE l_rvv17_sum LIKE rvv_file.rvv17 #MOD-D30263 add
  
  #LET g_rec_b = 0   #FUN-C30248 mark
  #FUN-C30248 add START
  #若來源為"依實收量自動帶出代買採購單資料及數量"時不將單身筆數預設為0
   IF g_flag2 <> 'Y' OR cl_null(g_flag2) THEN
      LET g_rec_b = 0
   END IF
  #FUN-C30248 add END

   IF g_rva.rva01 IS NULL THEN RETURN END IF
  #IF g_sel_from_procure <> 'Y' THEN   #FUN-B60127 ADD    #FUN-C30248 mark 
   IF g_sel_from_procure <> 'Y' AND (g_flag2 <> 'Y' OR cl_null(g_flag2)) THEN   #FUN-C30248 add
      IF NOT cl_confirm('apm-252') THEN RETURN END IF
   END IF                              #FUN-B60127 ADD
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL g_rvb.clear()

   LET g_sql = "SELECT pmm_file.*,pmn_file.* FROM pmm_file,pmn_file ",
               " WHERE pmn01 = '",g_rva.rva02 CLIPPED,"' AND pmm18 <> 'X' ",
               "   AND (pmn20-pmn50+pmn55+pmn58>0)  AND pmm01=pmn01 AND pmn16='2' ",   #No.FUN-940083
               "   ORDER BY pmn02 "                                                    #No.FUN-B90101
 
#-FUN-B60127- ADD - BEGIN ---------------------------------------------------------------
   # - < 從採購單挑選 > - #
   IF g_sel_from_procure = 'Y' THEN
      LET g_sql = "SELECT pmm_file.*,pmn_file.* FROM pmm_file,pmn_file,apmt110_sel_pmm",
                  " WHERE pmm_file.pmm01 = pmn_file.pmn01",
                  "   AND pmm_file.pmm01 = apmt110_sel_pmm.pmm01",
                  "   AND pmn_file.pmn02 = apmt110_sel_pmm.pmn02",
                  "   AND apmt110_sel_pmm.sel = 'Y' ",
                  " ORDER BY pmm_file.pmm01,pmn_file.pmn02"
   END IF
#-FUN-B60127- ADD -  END  ---------------------------------------------------------------

  #FUN-C30248 add START
   #若來源為依實收量自動帶出代買採購單資料及數量
   IF g_flag2 = 'Y' AND NOT cl_null(g_pmn41) AND NOT cl_null(l_ac) AND l_ac > 0  THEN
      LET g_sql = "SELECT pmm_file.*,pmn_file.* FROM pmm_file,pmn_file ",
                  " WHERE pmn01 = '",g_rvb04,"' AND pmm18 <> 'X' ",
                  "   AND (pmn20-pmn50+pmn55+pmn58>0)  AND pmm01=pmn01 AND pmn16='2' ",   
                  "   AND pmn41 = '",g_pmn41,"' ",
                  "   ORDER BY pmn02 "  
   END IF
  #FUN-C30248 add END

   PREPARE t110_g_b_p1 FROM g_sql
 
   DECLARE t110_g_b_c1 CURSOR WITH HOLD FOR t110_g_b_p1

   IF g_rec_b = 0 AND (g_flag = 'N' OR cl_null(g_flag2) )THEN   #FUN-C30248 add 
      LET l_ac = 1
  #FUN-C30248 add START 
   ELSE
      LET l_ac = g_rec_b + 1 
   END IF
  #FUN-C30248 add END

   FOREACH t110_g_b_c1 INTO l_pmm.*,l_pmn.*
      IF SQLCA.SQLCODE THEN CALL cl_err('for pmn',SQLCA.SQLCODE,1) EXIT FOREACH END IF      
      IF g_azw.azw04='2' THEN
         IF l_pmm.pmm51 != g_rva.rva29 THEN
            CONTINUE FOREACH
         END IF
      END IF
#FUN-A60035 ---MARK BEGIN
#     #No.FUN-A50054 -BEGIN-----
#      IF s_industry('slk') THEN
#         LET l_cnt = 0
#         SELECT COUNT(*) INTO l_cnt FROM ata_file
#          WHERE ata00 = g_prog
#            AND ata01 = g_rva.rva01
#            AND ata04 = l_pmn.pmn04
#         IF l_cnt = 0 THEN
#            IF g_argv2 = 'SUB' THEN
#               LET l_prog = 'apmt590_slk'
#            ELSE
#               IF g_argv2 = 'TAP' THEN
#                  LET l_prog = 'apmt540_slk'
#               ELSE 
#                  LET l_prog = 'apmt540_slk'
#               END IF
#             END IF
##FUN-A60035 ---mark begin
##            DECLARE t720_rvbata SCROLL CURSOR FOR
##             SELECT * FROM ata_file
##              WHERE ata00=l_prog
##                AND ata01=l_pmn.pmn01
##                AND ata02=l_pmn.pmn02
##            FOREACH t720_rvbata INTO l_ata.*
##               LET l_ata.ata00 = g_prog
##               LET l_ata.ata01 = g_rva.rva01
##               INSERT INTO ata_file VALUES (l_ata.*)
##            END FOREACH
##FUN-A60035 ---mark end
##FUN-A60035 ---add begin
#            SELECT * INTO l_ata.* FROM ata_file
#             WHERE ata00=l_prog
#               AND ata01=l_pmn.pmn01
#               AND ata04 = l_pmn.pmn04
#            LET l_ata.ata00 = g_prog
#            LET l_ata.ata01 = g_rva.rva01
#            INSERT INTO ata_file VALUES (l_ata.*)
##FUN-A60035 ---add end
#         END IF
#      END IF
#     #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
 
      LET g_rvb[l_ac].rvb22=null
      INITIALIZE g_rvb2.* TO NULL
      INITIALIZE g_rvbi2.* TO NULL  #FUN-810038
      LET g_rvb[l_ac].rvb04     = l_pmn.pmn01
      LET g_rvb[l_ac].rvb03     = l_pmn.pmn02
      LET g_rvb[l_ac].rvb34     = l_pmn.pmn41
      LET g_rvb[l_ac].rvb05     = l_pmn.pmn04
      LET g_rvb[l_ac].rvb051    = l_pmn.pmn041      #FUN-940083 pmn041-->rvb051
      LET g_rvb[l_ac].rvb05a    = l_pmn.pmn04       #No.FUN-810016
      LET g_rvb[l_ac].rvb05b    = l_pmn.pmn041      #No.FUN-810016
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07       #No.FUN-940083 pmn07-->rvb90     
      LET g_rvb[l_ac].pmn20     = l_pmn.pmn20
      LET g_rvb[l_ac].pmn50_55  = l_pmn.pmn50-l_pmn.pmn55
      LET g_rvb[l_ac].rvb30     = 0
      LET g_rvb[l_ac].rvb29     = 0
      LET g_rvb[l_ac].rvb89     = l_pmn.pmn89       #No.FUN-940083
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07       #No.FUN-940083
      LET g_rvb[l_ac].rvb35     = 'N'
      LET g_rvb[l_ac].rvb07     = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55+l_pmn.pmn58   #No.FUN-940083
     #FUN-C30248 add START
      IF g_flag2 = 'Y' AND NOT cl_null(g_pmn41) THEN
         IF l_pmn.pmn65 = '1' THEN
            LET g_rvb[l_ac].rvb07 = g_rvb07
         ELSE
            SELECT sfa161 INTO l_sfa161 FROM sfa_file 
               WHERE sfa01 = g_pmn41 AND sfa03 = l_pmn.pmn04
            IF cl_null(l_sfa161) THEN LET l_sfa161 = 1 END IF
            LET l_qty = g_rvb07 * l_sfa161
            IF l_qty <  g_rvb[l_ac].rvb07 OR l_qty =  g_rvb[l_ac].rvb07 THEN
               LET g_rvb[l_ac].rvb07 = l_qty 
            END IF 
         END IF
      END IF
     #FUN-C30248 add END
      LET g_rvb[l_ac].rvb83     = l_pmn.pmn83
      LET g_rvb[l_ac].rvb84     = l_pmn.pmn84
      LET g_rvb[l_ac].rvb85     = l_pmn.pmn85
      LET g_rvb[l_ac].rvb80     = l_pmn.pmn80
      LET g_rvb[l_ac].rvb81     = l_pmn.pmn81
      LET g_rvb[l_ac].rvb82     = l_pmn.pmn82
      LET g_rvb[l_ac].rvb86     = l_pmn.pmn86
      LET g_rvb[l_ac].rvb87     = l_pmn.pmn87
      LET g_rvb[l_ac].rvb10     = l_pmn.pmn31
      LET g_rvb[l_ac].rvb10t    = l_pmn.pmn31t
      LET g_rvb[l_ac].rvb919    = l_pmn.pmn919   #TQC-B20115
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07    #TQC-B20115
      IF g_rvb[l_ac].rvb89 ='Y' THEN
         SELECT pmc915,pmc916 INTO l_pmc915,l_pmc916
           FROM pmc_file
          WHERE pmc01 = g_rva.rva05
         #LET g_rvb[l_ac].rvb36     = l_pmc915       #FUN-C20002 mark
         #FUN-C20002--start add--------------------------
         IF g_azw.azw04 = '2' THEN
         SELECT ima154 INTO l_ima154
           FROM ima_file
          WHERE ima01 = g_rvb[l_ac].rvb05

         IF l_ima154 = 'Y' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN
            SELECT rcj03 INTO l_rcj03
              FROM rcj_file
             WHERE rcj00 = '0'

            #FUN-C90049 mark begin---
            #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
            #  FROM rtz_file
            # WHERE rtz01 = g_plant
            #FUN-C90049 mark end------
            CALL s_get_defstore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add

            IF l_rcj03 = '1' THEN
               LET g_rvb[l_ac].rvb36 = l_rtz07
            ELSE
               LET g_rvb[l_ac].rvb36 = l_rtz08
            END IF
         END IF
      ELSE
         LET g_rvb[l_ac].rvb36     = l_pmc915
      END IF 
      #FUN-C20002--end add----------------------------
         LET g_rvb[l_ac].rvb37     = l_pmc916
      ELSE
         #FUN-C20002--start add--------------------------
         IF g_azw.azw04 = '2' THEN
         SELECT ima154 INTO l_ima154
           FROM ima_file
          WHERE ima01 = g_rvb[l_ac].rvb05

         IF l_ima154 = 'Y' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN
            SELECT rcj03 INTO l_rcj03
              FROM rcj_file
             WHERE rcj00 = '0'

            #FUN-C90049 mark begin----
            #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
            #  FROM rtz_file
            # WHERE rtz01 = g_plant
            #FUN-C90049 mark end------
            CALL s_get_defstore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
            IF l_rcj03 = '1' THEN
               LET g_rvb[l_ac].rvb36 = l_rtz07
            ELSE
               LET g_rvb[l_ac].rvb36 = l_rtz08
            END IF
         END IF
      ELSE
         LET g_rvb[l_ac].rvb36     = l_pmn.pmn52   
      END IF
      #FUN-C20002--end add---------------------------- 
         #LET g_rvb[l_ac].rvb36     = l_pmn.pmn52     #FUN-C20002 mark
         LET g_rvb[l_ac].rvb37     = l_pmn.pmn54
      END IF
#FUN-AB0066 --begin--      
#      #No.FUN-AA0049--begin
#      IF NOT s_chk_ware(g_rvb[l_ac].rvb36) THEN
#         LET g_rvb[l_ac].rvb36=' '
#         LET g_rvb[l_ac].rvb37=' '
#      END IF 
#      #No.FUN-AA0049--end        
#FUN-AB0066 --end--      
      LET g_rvb[l_ac].rvb38     = l_pmn.pmn56
      LET g_rvb[l_ac].rvb25     = l_pmn.pmn71
     #-----MOD-AC0024---------
     #LET g_rvb[l_ac].pmm43     = 0
      SELECT pmm43 INTO g_rvb[l_ac].pmm43 FROM pmm_file 
        WHERE pmm01 = g_rva.rva02
     #-----END MOD-AC0024-----
      LET g_rvb[l_ac].rvb930    = l_pmn.pmn930
      
      LET l_pmn122 = l_pmn.pmn122
      LET l_pmn65  = l_pmn.pmn65 
      LET l_pmn88  = l_pmn.pmn88 
      LET l_pmn88t = l_pmn.pmn88t      
      IF g_azw.azw04='2' THEN
         SELECT sma135 INTO l_sma135 FROM sma_file
         IF l_sma135 = 'Y' THEN
            LET l_pmn88 = g_rvb[l_ac].rvb10
            LET l_pmn88t = g_rvb[l_ac].rvb10t
            LET g_rvb2.rvb42 = g_rvb[l_ac].rvb42
            LET g_rvb2.rvb43 = g_rvb[l_ac].rvb43
         ELSE
            LET g_rvb2.rvb42 = l_pmn.pmn73
            LET g_rvb2.rvb43 = l_pmn.pmn74
         END IF
        #SELECT rtz07 INTO g_rvb[l_ac].rvb36 FROM rtz_file WHERE rtz01 = g_rva.rvaplant   #MOD-B30598 mark
        #SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = g_rva.rvaplant             #MOD-B30598   #FUN-C90049 mark
        CALL s_get_coststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07          #FUN-C90049 add

        #FUN-B40098 Begin---
        #IF g_azw.azw04 = '2' AND g_rva.rva29 = '3' THEN          #FUN-B60150 MARK
         IF g_azw.azw04 = '2' AND (g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')) THEN  #FUN-B60150 ADD
            #FUN-C90049 mark begin---
            #SELECT rtz08 INTO l_rtz07 FROM rtz_file
            # WHERE rtz01 = g_rva.rvaplant
            #FUN-C90049 mark end------
            CALL s_get_noncoststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07          #FUN-C90049 add

            IF NOT cl_null(l_rtz07) THEN
               LET g_rvb2.rvb36 = l_rtz07
               LET g_rvb2.rvb37 = ' '
               LET g_rvb2.rvb38 = ' '
            END IF
         END IF
        #FUN-B40098 End-----
         #MOD-B30598 add --start--
         IF NOT cl_null(l_rtz07) THEN 
            LET g_rvb[l_ac].rvb36 = l_rtz07 
         END IF 
         #MOD-B30598 add --end--
#TQC-C20232---add--------------begin------------------------
    IF g_azw.azw04='2' THEN
       IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
          LET  g_rvb[l_ac].rvb36=l_pmn.pmn52 
          LET  g_rvb[l_ac].rvb37=l_pmn.pmn54
          LET  g_rvb[l_ac].rvb38=l_pmn.pmn56
          IF cl_null(g_rvb[l_ac].rvb37) THEN
             LET g_rvb[l_ac].rvb37=' '
          END IF
          IF cl_null(g_rvb[l_ac].rvb38) THEN
             LET g_rvb[l_ac].rvb38=' '
          END IF  
       END IF
    END IF
#TQC-C20232---end-------------------------------------------
         IF g_rvb[l_ac].rvb36 IS NULL THEN
            CONTINUE FOREACH
         END IF
      ELSE
         LET g_rvb2.rvb42 = '4'    #FUN-9C0075 ADD
      END IF
      IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '4' END IF   #FUN-9C0075 ADD
      LET l_rvb07s=0
         SELECT SUM(rvb07)  INTO l_rvb07s FROM rva_file,rvb_file
          WHERE rvb04=g_rvb[l_ac].rvb04 AND rvb03=g_rvb[l_ac].rvb03
            AND rva01=rvb01 AND rvaconf='N' AND rvb35='N'
         IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
         LET g_rvb2.rvb07=g_rvb[l_ac].rvb07-l_rvb07s

      IF g_rvb2.rvb07 <=0 THEN
         #實收數量為零的資料不用再產生
         CONTINUE FOREACH
      END IF
      LET g_rvb[l_ac].rvb07 = g_rvb2.rvb07   #MOD-970207
 
      LET l_rvb07_s = 0  
      LET l_rvb87_s = 0
     #SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file           #MOD-CA0161 mark
      SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file,rva_file  #MOD-CA0161 add
        WHERE rvb04=g_rvb[l_ac].rvb04
          AND rvb03=g_rvb[l_ac].rvb03
          AND (rvb01<>g_rva.rva01 OR
          (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
          AND rvb01 = rva01 AND rvaconf <> 'X' AND rvb35 = 'N'                      #MOD-CA0161 add
      IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
      IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
      #FUN-C30166---begin
      SELECT pmn65 INTO l_pmn65 FROM pmn_file
       WHERE pmn01 = g_rvb[l_ac].rvb04
         AND pmn02 = g_rvb[l_ac].rvb03
      IF g_argv2 ='SUB' AND NOT cl_null(g_rvb[l_ac].rvb34) AND l_pmn65 <> '2' THEN 
         SELECT sfb05 INTO l_sfb05 FROM sfb_file
          WHERE sfb01 = g_rvb[l_ac].rvb34
         CALL s_get_ima153(l_sfb05) RETURNING l_ima153
        #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','')                #FUN-C70037 mark
         CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)    #FUN-C70037
              RETURNING g_cnt,g_min_set
        #MOD-D30263 add start -----
         SELECT SUM(rvv17) INTO l_rvv17_sum FROM rvu_file,rvv_file
          WHERE rvu01 = rvv01 AND rvv03 = '3'
            AND rvv36 = g_rvb[l_ac].rvb04 AND rvv37 = g_rvb[l_ac].rvb03
        #MOD-D30263 add end   -----
         #總已收量(不含本收貨單之其他同採購單號項次之收貨單數量)+本次實收量  不可大於  最小發料套數(使用s_minp計算)
        #IF l_rvb07_s+g_rvb2.rvb07+l_rvb07s > g_min_set THEN #MOD-D30263 mark
         IF l_rvb07_s+g_rvb2.rvb07+l_rvb07s-l_rvv17_sum > g_min_set THEN #MOD-D30263 add
         #  CALL cl_err('','apm1078',1)       #FUN-C90077 mark
            LET g_rvb2.rvb07 = g_min_set - l_rvb07_s - l_rvb07s
            IF g_rvb2.rvb07 < 0 THEN LET g_rvb2.rvb07 = 0 END IF
            LET g_rvb[l_ac].rvb07 = g_rvb2.rvb07
         END IF 
      END IF 
      #FUN-C30166---end
      IF (l_rvb07_s+g_rvb2.rvb07) = g_rvb[l_ac].pmn20 THEN
         #LET l_rvb87_o = g_rvb[l_ac].rvb87 - l_rvb87_s   #MOD-AB0145
         LET l_rvb87_o = l_pmn.pmn87 - l_rvb87_s   #MOD-AB0145
      END IF
 
      IF l_ac > g_sma.sma110 THEN
         #xxxx筆==>收貨單身儲存最大筆數,其餘資料請再開一張收貨單
         CALL cl_err(g_sma.sma110,'apm-125',0)
         EXIT FOREACH
      END IF
      SELECT max(rvb02)+1 INTO g_rvb[l_ac].rvb02 FROM rvb_file
       WHERE rvb01 = g_rva.rva01
      IF g_rvb[l_ac].rvb02 IS NULL THEN LET g_rvb[l_ac].rvb02 = 1 END IF
     ##採購單有輸入專案代號則批號用來記錄專案代號之值
      LET g_rvb2.rvb01=g_rva.rva01
      LET g_rvb2.rvb02=g_rvb[l_ac].rvb02
      LET g_rvb2.rvb03=g_rvb[l_ac].rvb03
      LET g_rvb2.rvb04=g_rvb[l_ac].rvb04
      LET g_rvb2.rvb05=g_rvb[l_ac].rvb05     #料號
      LET g_rvb2.rvb36=g_rvb[l_ac].rvb36     #倉庫
      LET g_rvb2.rvb37=g_rvb[l_ac].rvb37     #儲位
      LET g_rvb2.rvb38=g_rvb[l_ac].rvb38     #批號
      LET g_rvb2.rvb90=g_rvb[l_ac].rvb90     #MOD-B30584 add
      LET l_pmh08 = NULL
     #TQC-B40126 Mod
     #SELECT COUNT(*) INTO l_n FROM rvb_file,rva_file 
     #   WHERE rvb04 = g_rvb[l_ac].rvb04 
     #     AND rvb03 = g_rvb[l_ac].rvb03
     #     AND rva01 = rvb01
     #     AND rvaconf <> 'X'
      SELECT COUNT(*) INTO l_n1  #非本收货单上数量
         FROM rvb_file,rva_file
        WHERE rvb04 = g_rvb[l_ac].rvb04
          AND rvb03 = g_rvb[l_ac].rvb03
          AND rva01 = rvb01
          AND rva01 != g_rva.rva01
          AND rvaconf <> 'X'
      SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
         FROM rvb_file,rva_file
        WHERE rvb04 = g_rvb[l_ac].rvb04
          AND rvb03 = g_rvb[l_ac].rvb03
          AND rva01 = rvb01
          AND rva01 = g_rva.rva01
          AND rvb02 != g_rvb[l_ac].rvb02
          AND rvaconf <> 'X'
      LET l_n = l_n1 + l_n2
     #TQC-B40126 Mod--end

      IF g_azw.azw04= '2' THEN  #MOD-C40192 add 
         SELECT sma134 INTO l_times FROM sma_file
#     IF l_n > l_times THEN                        #TQC-B30180
         IF l_n >= l_times THEN                       #TQC-B30180
            INITIALIZE g_rvb[l_ac].* TO NULL
            CONTINUE FOREACH
         END IF
      END IF  #MOD-C40192 add
      IF cl_null(g_rvb2.rvb36) THEN
         SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
          WHERE pmm01=g_rvb[l_ac].rvb04
        SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file  #FUN-A60076 add by huangtao
         WHERE pmn01 = g_rvb[l_ac].rvb04 AND pmn02 = g_rvb[l_ac].rvb03          
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
                    AND sgm012 = l_pmn012              #FUN-A60076 add by vealxu 
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
                    AND ecm012=l_pmn012                #FUN-A60076 add by huangtao
              END IF
           END IF   #MOD-910172
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF
         SELECT pmh08 INTO l_pmh08 FROM pmh_file            #判斷是否可直接入庫
          WHERE pmh01=g_rvb[l_ac].rvb05 AND pmh02=g_rva.rva05
            AND pmh13=l_pmm22
            AND pmh21= l_ecm04   #MOD-860146
            AND pmh22= l_type    #MOD-860146
            AND pmh23 = ' '      #No.CHI-960033 
            AND pmhacti = 'Y'                                           #CHI-910021
         IF STATUS THEN LET l_pmh08=NULL END IF     #00/0828modify
         IF l_pmh08 IS NOT NULL AND g_rvb2.rvb05[1,4]!='MISC' THEN
            SELECT ima35,ima36 INTO g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
            FROM ima_file
            WHERE ima01=g_rvb[l_ac].rvb05
            IF g_azw.azw04='2' THEN
               #FUN-C90049 mark begin----
               #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08
               #    WHERE rtz01 = g_rva.rvaplant
               #FUN-C90049 mark end-----
               CALL s_get_coststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07    #FUN-C90049 add

            #FUN-B60150 ADD - BEGIN ------------------------
               IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2') THEN
                  #FUN-C90049 begin---
                  #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                  # WHERE rtz01 = g_rva.rvaplant
                  #FUN-C90049 end-----
                  CALL s_get_noncoststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07    #FUN-C90049 add
               END IF
            #FUN-B60150 ADD -  END  ------------------------
               IF NOT cl_null(l_rtz07) THEN  #MOD-B30598 add
                  LET g_rvb[l_ac].rvb36 = l_rtz07
               END IF  #MOD-B30598 add
            END IF
#FUN-AB0066 --begin--
#            #No.FUN-AA0049--begin
#            IF NOT s_chk_ware(g_rvb[l_ac].rvb36) THEN
#               LET g_rvb[l_ac].rvb36=' '
#               LET g_rvb[l_ac].rvb37=' '
#            END IF 
#            #No.FUN-AA0049--end                 
#FUN-AB0066 --end--
            LET g_rvb2.rvb36=g_rvb[l_ac].rvb36
            LET g_rvb2.rvb37=g_rvb[l_ac].rvb37
         END IF
      END IF
      IF g_rvb2.rvb05[1,4]='MISC' THEN
         LET g_rvb2.rvb35=NULL LET g_rvb[l_ac].rvb35=NULL
         LET g_rvb2.rvb36=NULL LET g_rvb[l_ac].rvb36=NULL
         LET g_rvb2.rvb37=NULL LET g_rvb[l_ac].rvb37=NULL
      END IF
      LET g_rvb2.rvb06=0
      #-----MOD-A10104---------
      IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN  
         LET g_rvb2.rvb08=g_rvb2.rvb07
      END IF   #MOD-940056
      #-----END MOD-A10104-----
      IF g_sma.sma115 = 'Y' THEN
         LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
         LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
         LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
         LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
         LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
         LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85  
         SELECT SUM(rvb82),SUM(rvb85) INTO l_rvb82,l_rvb85 FROM rvb_file,rva_file
          WHERE rvb04 = g_rvb[l_ac].rvb04
            AND rvb03 = g_rvb[l_ac].rvb03
            AND rva01 = rvb01
            AND rvaconf <> 'X'   
            AND rvb35 = 'N'   
         IF NOT cl_null(l_rvb82) AND l_rvb82 > 0 THEN
            LET g_rvb2.rvb82 =g_rvb[l_ac].rvb82 - l_rvb82
            LET g_rvb[l_ac].rvb82 = g_rvb2.rvb82
         END IF
         IF NOT cl_null(l_rvb85) AND l_rvb85 > 0 THEN
            LET g_rvb2.rvb85 =g_rvb[l_ac].rvb85 - l_rvb85
            LET g_rvb[l_ac].rvb85 = g_rvb2.rvb85
         END IF
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_rvb2.rvb05
         IF cl_null(l_ima906) OR l_ima906 = '1' THEN
            LET g_rvb2.rvb80=g_rvb[l_ac].rvb90
            LET g_rvb2.rvb82=g_rvb2.rvb07
            LET g_rvb[l_ac].rvb80 = g_rvb2.rvb80
            LET g_rvb[l_ac].rvb82 = g_rvb2.rvb82
         END IF
      END IF
      IF cl_null(g_rvb[l_ac].rvb86) THEN
         LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90
         LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
         LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
         LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      END IF
      CALL t110_set_rvb87()    
      IF g_sma.sma116 MATCHES '[02]' THEN
         LET g_rvb[l_ac].rvb87 = g_rvb2.rvb07
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN
         IF NOT cl_null(l_rvb87_o) AND l_rvb87_o <> 0 THEN   
            LET g_rvb[l_ac].rvb87 = l_rvb87_o
         END IF    
      END IF
      LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
      LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      LET g_rvb2.rvb09=0
      LET g_rvb2.rvb10=g_rvb[l_ac].rvb10
      LET g_rvb2.rvb10t=g_rvb[l_ac].rvb10t          #No.FUN-550117
      LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
      LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
     #-----MOD-AC0024---------
      SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
       WHERE gec01 = pmm21
         AND pmm01 = g_rvb2.rvb04
      SELECT azi04 INTO t_azi04 
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01=g_rvb2.rvb04
      LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)    
      LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     
      IF g_gec07='Y' THEN
         #-----CHI-AC0016---------
         #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
         #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
         #IF g_gec05 = 'T' THEN
         IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
            LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rvb[l_ac].pmm43/100) #TQC-C30225 add
            LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)            #TQC-C30225 add
            LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rvb[l_ac].pmm43/100)
            LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
         ELSE
            LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
            LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
         END IF
         #-----END CHI-AC0016-----
      ELSE
         LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
         LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
      END IF
     #-----END MOD-AC0024-----
      LET g_rvb2.rvb11=0
      SELECT ima491 INTO l_ima491 FROM ima_file
       WHERE ima01 = g_rvb2.rvb05
      IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
      IF l_ima491 > 0 THEN
         CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
      ELSE
         IF cl_null(g_rvb2.rvb12) THEN
            LET g_rvb2.rvb12 = g_rva.rva06
         END IF
      END IF
      LET g_rvb2.rvb13=NULL
      LET g_rvb2.rvb14=NULL
      LET g_rvb2.rvb15=0
      LET g_rvb2.rvb16=0
      LET g_rvb2.rvb17=NULL
      LET g_rvb2.rvb18='10'
      LET g_rvb2.rvb19=l_pmn65  #No:8114
      LET g_rvb2.rvb20=NULL
      LET g_rvb2.rvb21=NULL
      LET g_rvb2.rvb22=g_rvb[l_ac].rvb22
      LET g_rvb2.rvb25=g_rvb[l_ac].rvb25
      LET g_rvb2.rvb26=NULL
      LET g_rvb2.rvb27=0
      LET g_rvb2.rvb28=0
      LET g_rvb2.rvb29=0
      LET g_rvb2.rvb30=0
      LET g_rvb2.rvb31=0                   #MOD-880166
      LET g_rvb2.rvb32=0
      LET g_rvb2.rvb33=0
      LET g_rvb2.rvb331=0
      LET g_rvb2.rvb332=0
      LET g_rvb2.rvb34=g_rvb[l_ac].rvb34
      LET g_rvb2.rvb35='N'
      LET g_rvb2.rvb40= ''  #no.7143
      LET g_rvb2.rvb930=g_rvb[l_ac].rvb930 #FUN-670051
      CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
      IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
      IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
      IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
      LET g_rvb2.rvb44 = l_pmn.pmn75                                                                                   
      LET g_rvb2.rvb45 = l_pmn.pmn76 
      LET g_rvb2.rvb90 = l_pmn.pmn07      #TQC-AC0273  
      LET g_rvb2.rvbplant = g_rva.rvaplant                                                                                  
      LET g_rvb2.rvblegal = g_rva.rvalegal                                                                                  
       CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
               RETURNING g_rvb2.rvb39 #MOD-530415
      BEGIN WORK
      LET g_success = 'Y'
      LET l_ec_sw = 'N'
      IF g_argv2 ='SUB' THEN
         LET l_sfb24=''
         SELECT sfb24 INTO l_sfb24
          FROM sfb_file
          WHERE sfb01 = g_rvb2.rvb34
         IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
            LET l_ec_sw='Y'
         END IF
         IF l_ec_sw='Y' THEN
            LET g_rvb2.rvb36=' '
            LET g_rvb2.rvb37=' '
            LET g_rvb2.rvb38=' '
         END IF
      END IF
      #TQC-AB0165--begin--add-----
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_rvb2.rvb05
      CALL s_umfchk(g_rvb2.rvb05,g_rvb2.rvb90,l_ima25)
           RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL cl_err(g_rvb2.rvb90,'mfg7003',1)
         LET g_rvb2.rvb90_fac = 1
      ELSE
         LET g_rvb2.rvb90_fac = l_fac
      END IF
      #TQC-AB0165--end--add--------
      LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90    #NO.FUN-940083
      LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89    #NO.FUN-940083
 
      LET g_rvb2.rvbplant = g_plant #NO.FUN-980006 jarlin add
      LET g_rvb2.rvblegal = g_legal #NO.FUN-980006 jarlin add
      IF cl_null(g_rvb2.rvb08) THEN LET g_rvb2.rvb08 = 0 END IF   #TQC-A10160
#MOD-B30433-----mark----str-----------------
#MOD-AB0204 --begin--
#     IF cl_null(g_rvb2.rvb40) THEN  
#        LET g_rvb2.rvb40 = g_today
#     END IF 
#MOD-AB0204 --end--   
#MOD-B30433-----mark----end----------------
      LET g_rvb2.rvb919 = g_rvb[l_ac].rvb919  #TQC-B20115
      LET g_rvb2.rvb90  = g_rvb[l_ac].rvb90   #TQC-B20115
      LET g_rvb2.rvb051 = g_rvb[l_ac].rvb051  #MOD-BB0278 add
      INSERT INTO rvb_file VALUES(g_rvb2.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
         ROLLBACK WORK
         CONTINUE FOREACH
      ELSE
 
         LET g_rvbi2.rvbi01 = g_rvb2.rvb01
         LET g_rvbi2.rvbi02 = g_rvb2.rvb02
 
         IF NOT s_ins_rvbi(g_rvbi2.*,'') THEN
            ROLLBACK WORK
            CONTINUE FOREACH
         END IF
        SELECT COUNT(*) INTO l_n FROM img_file
          WHERE img01 = g_rvb2.rvb05
            AND img02 = g_rvb2.rvb36
            AND img03 = g_rvb2.rvb37
            AND img04 = g_rvb2.rvb38
         IF l_n = 0 AND (g_rvb[l_ac].rvb36 IS NOT NULL
                         AND g_rvb[l_ac].rvb36 <> ' ') AND l_ec_sw = 'N' THEN    #MOD-910227
            IF g_sma.sma892[3,3] ='Y' THEN
               IF cl_confirm('mfg1401') THEN
                  CALL s_add_img(g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                                 g_rvb2.rvb38,g_rva.rva01,g_rvb2.rvb02,
                                 g_rva.rva06)
               END IF
            ELSE
               CALL s_add_img(g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                              g_rvb2.rvb38,g_rva.rva01,g_rvb2.rvb02,
                              g_rva.rva06)
            END IF
         END IF
      END IF
 
 
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
 
   CALL g_rvb.deleteElement(l_ac)
   LET l_ac=l_ac - 1
 
   CALL t110_b_fill(' 1=1',' 1=1')   #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
 
END FUNCTION
 
FUNCTION t110_b_more()
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE  l_rvb90  LIKE rvb_file.rvb90    #No.FUN-BB0086
 
   LET p_row = 7 LET p_col = 22
   OPEN WINDOW t110y_w AT p_row,p_col WITH FORM "apm/42f/apmt110_y"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt110_y")
 
 
   SELECT rvb08,rvb12,rvb13,rvb17,rvb14,rvb16,rvb15
    INTO g_rvb2.rvb08,g_rvb2.rvb12,g_rvb2.rvb13,g_rvb2.rvb17,g_rvb2.rvb14,
         g_rvb2.rvb16,g_rvb2.rvb15
     FROM rvb_file
    WHERE rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02
   IF status=100 THEN LET g_rvb2.rvb08=0   LET g_rvb2.rvb12=NULL
                      LET g_rvb2.rvb13=' ' LET g_rvb2.rvb17=NULL
                      LET g_rvb2.rvb14=' ' LET g_rvb2.rvb16=0
                      LET g_rvb2.rvb15=0
   END IF
   INPUT BY NAME g_rvb2.rvb08,g_rvb2.rvb12,g_rvb2.rvb13,g_rvb2.rvb17,
                 g_rvb2.rvb14,g_rvb2.rvb16,g_rvb2.rvb15
                 WITHOUT DEFAULTS
 
      AFTER FIELD rvb08                      #會計科目
         #No.FUN-BB0086--add--begin--
         SELECT rvb90 INTO l_rvb90 FROM rvb_file 
          WHERE rvb01 = g_rva.rva01
            AND rvb02 = g_rvb[l_ac].rvb02
         LET g_rvb2.rvb08 = s_digqty(g_rvb2.rvb08,l_rvb90)  
         DISPLAY BY NAME g_rvb2.rvb08
         #No.FUN-BB0086--add--end--
         IF cl_null(g_rvb2.rvb08) THEN
            NEXT FIELD rvb08
         END IF
 
      AFTER FIELD rvb12       #應完成日
         IF cl_null(g_rvb2.rvb12) THEN
            NEXT FIELD rvb12
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
         IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         LET l_flag = 'N'
         IF cl_null(g_rvb2.rvb08) THEN
            LET l_flag = 'Y'
            DISPLAY BY NAME g_rvb2.rvb08
         END IF
         IF cl_null(g_rvb2.rvb12) THEN
            LET l_flag = 'Y'
            DISPLAY BY NAME g_rvb2.rvb12
         END IF
         IF l_flag = 'Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD pmn40
         END IF
      ON IDLE g_idle_seconds
         CONTINUE INPUT
 
   END INPUT
 
   UPDATE rvb_file
      SET rvb08 = g_rvb2.rvb08,
          rvb12 = g_rvb2.rvb12,
          rvb13 = g_rvb2.rvb13,
          rvb14 = g_rvb2.rvb14,
          rvb15 = g_rvb2.rvb15,
          rvb16 = g_rvb2.rvb16,
          rvb17 = g_rvb2.rvb17 
    WHERE rvb01 = g_rva.rva01
      AND rvb02 = g_rvb[l_ac].rvb02
 
   CLOSE WINDOW t110y_w                 #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
END FUNCTION

#TQC-C20117---add---begin------------将t110_rvb03(p_cmd,p_po,p_item) 抽出來單獨處理
FUNCTION t110_rvbslk03(p_cmd,p_po,p_item)
   DEFINE
      p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      p_po     LIKE pmn_file.pmn01,
      l_pmn04  LIKE pmn_file.pmn04,
      l_no     LIKE ade_file.ade04,    #No.FUN-680136 VARCHAR(04)
      l_cnt    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      p_item   LIKE pmn_file.pmn02,
      l_pmn122 LIKE pmn_file.pmn122,
      l_pmn16  LIKE pmn_file.pmn16,
      l_pmn15  LIKE pmn_file.pmn15,
      l_pmn34  LIKE pmn_file.pmn34,
      l_pmn37  LIKE pmn_file.pmn37,
      l_pmn58  LIKE pmn_file.pmn58,
      l_pmn41  LIKE pmn_file.pmn41,
      l_pmn011 LIKE pmn_file.pmn011,
      l_pmn63  LIKE pmn_file.pmn63,
      l_pmh08  LIKE pmh_file.pmh08,
      l_sfb24  LIKE sfb_file.sfb24,
      l_date   LIKE pmn_file.pmn37,
      l_rvb07  LIKE rvb_file.rvb07,
      l_rvb07s LIKE rvb_file.rvb07,
      l_pmn52  LIKE pmn_file.pmn52,
      l_pmn54  LIKE pmn_file.pmn54,
      l_pmn56  LIKE pmn_file.pmn56,
      l_pmm22  LIKE pmm_file.pmm22,
      l_pmn012 LIKE pmn_file.pmn012,          #FUN-A60076  add by huangtao
      l_rvb25  LIKE rvb_file.rvb25,           #No.MOD-4B0275
      l_alt06,t_alt06 LIKE alt_file.alt06,    #MOD-680004 add
      l_msg    LIKE type_file.chr50,          #No.FUN-680136 VARCHAR(40)
      l_sw,l_sw1  LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
      l_rvb80  LIKE rvb_file.rvb80,
      l_rvb81  LIKE rvb_file.rvb81,
      l_rvb82  LIKE rvb_file.rvb82,
      l_rvb83  LIKE rvb_file.rvb83,
      l_rvb84  LIKE rvb_file.rvb84,
      l_rvb85  LIKE rvb_file.rvb85,
      l_rvb86  LIKE rvb_file.rvb86,
      l_rvb87  LIKE rvb_file.rvb87,
      l_ima150 LIKE ima_file.ima150,
      l_ima151 LIKE ima_file.ima151
   DEFINE l_pmm02 LIKE pmm_file.pmm02  #FUN-810038
   DEFINE l_type    LIKE type_file.chr1     #MOD-860146
   DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
   DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
   DEFINE l_rvb85e  LIKE rvb_file.rvb85     #No.MOD-890236
   DEFINE l_rvb82e  LIKE rvb_file.rvb82     #No.MOD-890236
   DEFINE l_pmn18   LIKE pmn_file.pmn18     #CHI-8C0017
   DEFINE l_rtz07   LIKE rtz_file.rtz07     #NO.FUN-960130
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_prog    LIKE type_file.chr20    #FUN-A60035
#  DEFINE l_item    LIKE ata_file.ata03     #FUN-A60035
#  DEFINE l_item_old  LIKE ata_file.ata03     #FUN-A60035
#  DEFINE l_ata05   LIKE ata_file.ata05     #FUN-A60035
#FUN-A60035 ---MARK END
   DEFINE l_ima903  LIKE ima_file.ima903    #FUN-A20017
   #FUN-C20002--start add----------------------------------
   DEFINE l_rtz08   LIKE rtz_file.rtz08
   DEFINE l_ima154  LIKE ima_file.ima154
   DEFINE l_rcj03   LIKE rcj_file.rcj03
   #FUN-C20002--end add------------------------------------

#FUN-B90101--add--begin--
   DEFINE l_rvbslk07  LIKE rvbslk_file.rvbslk07,
          l_rvbslk07s LIKE rvbslk_file.rvbslk07,
          l_pmm43     LIKE pmm_file.pmm43,
          l_pmm21     LIKE pmm_file.pmm21
#FUN-B90101--add--end--

   LET g_errno = " "

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  IF s_industry('slk') THEN
#  IF g_argv2 = 'SUB' THEN
#     LET l_prog = 'apmt590_slk'
#  ELSE
#     IF g_argv2 = 'TAP' THEN
#        LET l_prog = 'apmt540_slk'
#     ELSE
#        LET l_prog = 'apmt540_slk'
#     END IF
#  END IF
#  DECLARE t110_sel_ata CURSOR FOR
#   SELECT ata03,ata05 FROM ata_file
#    WHERE ata00 = l_prog
#      AND ata01 = p_po
#      AND ata02 = p_item
#  FOREACH t110_sel_ata INTO l_item,l_ata05
#     EXIT FOREACH
#  END FOREACH
#  LET l_item_old = p_item
#  LET p_item = l_item
#  END IF
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
#FUN-B90101--add--begin--
   SELECT pmnslk04,pmnslk07,pmnslk041,
          pmnslk34,pmnslk44,pmnslk31,pmnslk31t,
          pmnslk52,pmnslk54,pmnslk56,
          pmm21,pmm43,pmm22,gec07,pmnslk73,pmnslk74,pmnslk88,pmnslk88t
     INTO g_rvbslk[l_ac2].rvbslk05,g_rvbslk[l_ac2].rvbslk90,
          g_rvbslk[l_ac2].rvbslk051,
          l_pmn34,g_pmn44,g_rvbslk[l_ac2].rvbslk10,g_rvbslk[l_ac2].rvbslk10t,
          l_pmn52,l_pmn54,l_pmn56,
          l_pmm21,l_pmm43,l_pmm22,g_gec07,g_rvbslk[l_ac2].rvbslk42,g_rvbslk[l_ac2].rvbslk43,
          g_rvbslk[l_ac2].rvbslk88,g_rvbslk[l_ac2].rvbslk88t
      FROM pmnslk_file,pmm_file,gec_file
     WHERE pmnslk01 = p_po
       AND pmnslk02 = p_item
       AND pmnslk01=pmm01
       AND pmm18 <> 'X'
       AND pmm_file.pmm21 = gec_file.gec01       #No.FUN-550117
       AND gec011='1'   #MOD-740504

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3192'
         LET g_rvbslk[l_ac2].rvbslk90 = NULL   #No.FUN-940083 pmn07-->rvbslk90
         LET g_rvbslk[l_ac2].rvbslk051= NULL   #FUN-940083 pmn041-->rvbslk051
      WHEN l_pmn16 != '2'
         LET g_errno = 'mfg3166'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   SELECT SUM(pmn20-pmn50+pmn55+pmn58) INTO l_rvbslk07 FROM pmn_file,pmni_file
                                         WHERE pmn01 = pmni01
                                           AND pmn02 = pmni02
                                           AND pmni01 = p_po
                                           AND pmnislk03 = p_item
    IF l_pmn011!=g_rva.rva10 THEN
       LET g_errno='apm-251'
       RETURN
    END IF

    IF l_pmn011='SUB' AND g_rva.rva04='Y' THEN
       LET g_errno='apm-249'
       RETURN
    END IF

    LET l_pmn04 =  g_rvbslk[l_ac2].rvbslk05
    IF l_pmn15 = 'N' THEN
       IF cl_null(l_pmn37) THEN
          LET l_date = l_pmn34
       ELSE LET l_date = l_pmn37
       END IF
       IF g_rva.rva06 < l_date THEN LET g_errno = 'mfg3039' RETURN  END IF
    END IF
    IF p_cmd = 'a' THEN
       LET l_rvbslk07s=0
       SELECT SUM(rvbslk07) INTO l_rvbslk07s FROM rva_file,rvbslk_file   #未確認也計入
        WHERE rva01=rvbslk01 AND rvbslk04=g_rvbslk[l_ac2].rvbslk04
          AND rvbslk03=g_rvbslk[l_ac2].rvbslk03 AND rvaconf='N'
       IF cl_null(l_rvbslk07s) THEN LET l_rvbslk07s=0 END IF
       LET g_rvbslk[l_ac2].rvbslk07=l_rvbslk07-l_rvbslk07s
       #若為LC收貨，則須檢查數貨不可大於提單數量
     # IF g_rva.rva04='Y' AND NOT cl_null(g_rvbslk[l_ac2].rvbslk22) THEN
     #    SELECT alt06 INTO l_alt06 FROM alt_file
     #     WHERE alt01=g_rvbslk[l_ac2].rvbslk22
     #       AND alt14=g_rvbslk[l_ac2].rvbslk04
     #       AND alt15=g_rvbslk[l_ac2].rvbslk03
     #    IF cl_null(l_alt06) THEN
     #       LET l_alt06 = 0
     #    END IF
     #    SELECT SUM(rvbslk07) INTO t_alt06 FROM rvbslk_file
     #     WHERE rvbslk22=g_rvbslk[l_ac2].rvbslk22
     #       AND rvbslk04=g_rvbslk[l_ac2].rvbslk04
     #       AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
     #       AND rvbslk01!=g_rva.rva01
     #       AND rvbslk35='N'
     #    IF cl_null(t_alt06) THEN
     #       LET t_alt06 = 0
     #    END IF
     #    LET g_rvbslk[l_ac2].rvbslk07 = (l_alt06-t_alt06)
     # END IF
    END IF
    IF g_rvbslk[l_ac2].rvbslk07 < 0 THEN LET g_rvbslk[l_ac2].rvbslk07 = 0 END IF  #MOD-860172

    IF l_pmn63='Y' THEN              #急料
       CALL cl_getmsg('apm-253',g_lang) RETURNING g_msg
       CALL cl_msg(g_msg)
    END IF

    # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
    LET l_ec_sw = 'N'
   #IF g_argv2 ='SUB' THEN
   #   LET l_sfb24=''
   #   SELECT sfb24 INTO l_sfb24
   #     FROM sfb_file
   #    WHERE sfb01 = g_rvbslk[l_ac2].rvbslk34
   #   IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
   #      LET l_ec_sw='Y'
   #   END IF
   #END IF
    IF l_ec_sw='N' THEN
       IF g_rvbslk[l_ac2].rvbslk36 IS NULL THEN LET g_rvbslk[l_ac2].rvbslk36=l_pmn52 END IF  #TQC-B60003
       IF g_rvbslk[l_ac2].rvbslk37 IS NULL THEN LET g_rvbslk[l_ac2].rvbslk37=l_pmn54 END IF  #TQC-B60003
    END IF
    IF g_rvbslk[l_ac2].rvbslk36 IS NULL THEN LET g_rvbslk[l_ac2].rvbslk36=' ' END IF  #TQC-B60003
    IF g_rvbslk[l_ac2].rvbslk37 IS NULL THEN LET g_rvbslk[l_ac2].rvbslk37=' ' END IF  #TQC-B60003
    IF cl_null(g_rvbslk[l_ac2].rvbslk38) THEN LET g_rvbslk[l_ac2].rvbslk38 = ' ' END IF   #MOD-B80272 add

    IF cl_null(g_rvbslk[l_ac2].rvbslk38) AND l_ec_sw='N' THEN   #No.B454
       LET g_rvbslk[l_ac2].rvbslk38=l_pmn56
    END IF
    IF cl_null(g_rvbslk[l_ac2].rvbslk36) THEN
       SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
        WHERE pmm01=g_rvbslk[l_ac2].rvbslk04

        SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file
         WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04 AND pmn02 = g_rvbslk[l_ac2].rvbslk03
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
              LET l_ecm04=' '
           ELSE
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
                    AND sgm012 = l_pmn012                #FUN-A60076 add by vealxu
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
                    AND ecm012=l_pmn012                  #FUN-A60076  add by huangtao
              END IF
           END IF   #MOD-910172
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF

       SELECT pmh08 INTO l_pmh08 FROM pmh_file
        WHERE pmh01=g_rvbslk[l_ac2].rvbslk05 AND pmh02=g_rva.rva05
          AND pmh13=l_pmm22
          AND pmh21= l_ecm04   #MOD-860146
          AND pmh22= l_type    #MOD-860146
          AND pmh23 = ' '      #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021
       IF status THEN LET l_pmh08='N' END IF
        IF g_rvbslk[l_ac2].rvbslk05[1,4] !='MISC' AND l_ec_sw='N' THEN   #No.MOD-580087
          SELECT ima35,ima36 INTO g_rvbslk[l_ac2].rvbslk36,g_rvbslk[l_ac2].rvbslk37
            FROM ima_file
           WHERE ima01=g_rvbslk[l_ac2].rvbslk05
          IF g_azw.azw04='2' THEN
             #FUN-C90049 mark beign----
             #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08
             # WHERE rtz01 = g_rva.rvaplant
             #FUN-C90049 mark end-----
             CALL s_get_coststore(g_rva.rvaplant,g_rvbslk[l_ac2].rvbslk05) RETURNING l_rtz07    #FUN-C90049 add

             IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')THEN #FUN-B60150 ADD
                #FUN-C90049 mark begin---
                #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                # WHERE rtz01 = g_rva.rvaplant
                #FUN-C90049 mark end-----
                CALL s_get_noncoststore(g_rva.rvaplant,g_rvbslk[l_ac2].rvbslk05) RETURNING l_rtz07    #FUN-C90049 add
             END IF
             IF NOT cl_null(l_rtz07) THEN #MOD-B30598 add
                LET g_rvbslk[l_ac2].rvbslk36 = l_rtz07
             END IF  #MOD-B30598 add
          END IF
          IF cl_null(g_rvbslk[l_ac2].rvbslk38) THEN LET g_rvbslk[l_ac2].rvbslk38=' ' END IF  #TQC-810048 add
       END IF
    END IF
    IF g_rvbslk[l_ac2].rvbslk05[1,4]='MISC' OR l_ec_sw='Y' THEN
       LET g_rvbslk2.rvbslk36=NULL LET g_rvbslk[l_ac2].rvbslk36=NULL
       LET g_rvbslk2.rvbslk37=NULL LET g_rvbslk[l_ac2].rvbslk37=NULL
       LET g_rvbslk2.rvbslk38=NULL LET g_rvbslk[l_ac2].rvbslk38=NULL
    END IF

    SELECT ima021 INTO g_rvbslk[l_ac2].ima021a FROM ima_file
     WHERE ima01=g_rvbslk[l_ac2].rvbslk05

     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk05
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk90              #No.FUN-940083 pmn07-->rvbslk90
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk051             #FUN-940083 pmn041-->rvbslk051
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk07
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk36
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk37
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk38
     DISPLAY BY NAME g_rvbslk[l_ac2].ima021a
     CALL t110_set_rvb930(g_rvbslk[l_ac2].rvbslk930) RETURNING g_rvbslk[l_ac2].gem02
     LET g_rvbslk2.rvbslk930=g_rvbslk[l_ac2].rvbslk930
     DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk930,g_rvbslk[l_ac2].gem02

    IF p_cmd = 'a' OR g_rvbslk_t.rvbslk05 IS NULL OR
       g_rvbslk_t.rvbslk05 <> g_rvbslk[l_ac2].rvbslk05 THEN
       LET g_rvbslk[l_ac2].rvbslk30 = 0  #No.MOD-890236
       LET g_rvbslk[l_ac2].rvbslk29 = 0  #No.MOD-890236
    END IF

    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmm22   #No.CHI-6A0004

    SELECT ima150,ima151 INTO l_ima150,l_ima151 FROM ima_file
     WHERE ima_file.ima01=g_rvbslk[l_ac2].rvbslk05
     IF l_ima150!='0' THEN
       CALL cl_set_comp_entry('rvbslk05',TRUE)
     ELSE
         CALL cl_set_comp_entry('rvbslk05',FALSE)
     END IF
     IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
        SELECT ima903 INTO l_ima903
          FROM ima_file,pmn_file
         WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
           AND pmn02 = g_rvbslk[l_ac2].rvbslk03
           AND ima01 = pmn04
        IF g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
           CALL cl_set_comp_entry("rvbslk05",FALSE)
        ELSE
           CALL cl_set_comp_entry('rvbslk05',TRUE)
        END IF
     END IF
     #FUN-A20017--end--add----
     #若為制衣業,則輸入完采購單號,項次后,判斷rvbslk05a
     #采購料號對應的補貨策略是否是6-訂單式采購,
     #若是，則將采購單身的制單號帶入到收貨單身的批號中
       IF s_industry('slk') THEN
            SELECT pmnislk01 INTO g_rvbslk[l_ac2].rvbslk38
            FROM pmni_file
            WHERE pmni_file.pmni01=g_rvbslk[l_ac2].rvbslk04
            AND pmni_file.pmni02=g_rvbslk[l_ac2].rvbslk03
       END IF
#FUN-B90101 add &endif
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  IF s_industry('slk') THEN #No.FUN-A50054
#     LET g_rvb[l_ac].rvb05 = l_ata05
#     LET g_rvb[l_ac].rvb05a = l_ata05
#     SELECT SUM(pmn20) INTO g_rvb[l_ac].pmn20
#       FROM pmn_file,pmm_file
#      WHERE pmn01 = p_po
#        AND pmn02 IN (SELECT ata03 FROM ata_file WHERE ata01 = p_po AND ata02 =  l_item_old)
#        AND pmn01=pmm01 AND pmm18 <> 'X'
#  END IF
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
END FUNCTION
#TQC-C20117--end---------------------- 

FUNCTION t110_rvb03(p_cmd,p_po,p_item)
   DEFINE
      p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      p_po     LIKE pmn_file.pmn01,
      l_pmn04  LIKE pmn_file.pmn04,
      l_no     LIKE ade_file.ade04,    #No.FUN-680136 VARCHAR(04)
      l_cnt    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      p_item   LIKE pmn_file.pmn02,
      l_pmn122 LIKE pmn_file.pmn122,
      l_pmn16  LIKE pmn_file.pmn16,
      l_pmn15  LIKE pmn_file.pmn15,
      l_pmn34  LIKE pmn_file.pmn34,
      l_pmn37  LIKE pmn_file.pmn37,
      l_pmn58  LIKE pmn_file.pmn58,
      l_pmn41  LIKE pmn_file.pmn41,
      l_pmn011 LIKE pmn_file.pmn011,
      l_pmn63  LIKE pmn_file.pmn63,
      l_pmh08  LIKE pmh_file.pmh08,
      l_sfb24  LIKE sfb_file.sfb24,
      l_date   LIKE pmn_file.pmn37,
      l_rvb07  LIKE rvb_file.rvb07,
      l_rvb07s LIKE rvb_file.rvb07,
      l_pmn52  LIKE pmn_file.pmn52,
      l_pmn54  LIKE pmn_file.pmn54,
      l_pmn56  LIKE pmn_file.pmn56,
      l_pmm22  LIKE pmm_file.pmm22,
      l_pmn012 LIKE pmn_file.pmn012,          #FUN-A60076  add by huangtao
      l_rvb25  LIKE rvb_file.rvb25,           #No.MOD-4B0275
      l_alt06,t_alt06 LIKE alt_file.alt06,    #MOD-680004 add
      l_msg    LIKE type_file.chr50,          #No.FUN-680136 VARCHAR(40)
      l_sw,l_sw1  LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
      l_rvb80  LIKE rvb_file.rvb80,
      l_rvb81  LIKE rvb_file.rvb81,
      l_rvb82  LIKE rvb_file.rvb82,
      l_rvb83  LIKE rvb_file.rvb83,
      l_rvb84  LIKE rvb_file.rvb84,
      l_rvb85  LIKE rvb_file.rvb85,
      l_rvb86  LIKE rvb_file.rvb86,
      l_rvb87  LIKE rvb_file.rvb87,
      l_ima150 LIKE ima_file.ima150,
      l_ima151 LIKE ima_file.ima151
   DEFINE l_pmm02 LIKE pmm_file.pmm02  #FUN-810038
   DEFINE l_type    LIKE type_file.chr1     #MOD-860146
   DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
   DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
   DEFINE l_rvb85e  LIKE rvb_file.rvb85     #No.MOD-890236 
   DEFINE l_rvb82e  LIKE rvb_file.rvb82     #No.MOD-890236
   DEFINE l_pmn18   LIKE pmn_file.pmn18     #CHI-8C0017 
   DEFINE l_rtz07   LIKE rtz_file.rtz07     #NO.FUN-960130
#FUN-A60035 ---MARK BEGIN
#  DEFINE l_prog    LIKE type_file.chr20    #FUN-A60035 
#  DEFINE l_item    LIKE ata_file.ata03     #FUN-A60035
#  DEFINE l_item_old  LIKE ata_file.ata03     #FUN-A60035
#  DEFINE l_ata05   LIKE ata_file.ata05     #FUN-A60035
#FUN-A60035 ---MARK END
   DEFINE l_ima903  LIKE ima_file.ima903    #FUN-A20017
   #FUN-C20002--start add----------------------------------
   DEFINE l_rtz08   LIKE rtz_file.rtz08
   DEFINE l_ima154  LIKE ima_file.ima154
   DEFINE l_rcj03   LIKE rcj_file.rcj03
   #FUN-C20002--end add------------------------------------

   LET g_errno = " "

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  IF s_industry('slk') THEN
#  IF g_argv2 = 'SUB' THEN
#     LET l_prog = 'apmt590_slk'
#  ELSE
#     IF g_argv2 = 'TAP' THEN
#        LET l_prog = 'apmt540_slk'
#     ELSE
#        LET l_prog = 'apmt540_slk'
#     END IF
#  END IF
#  DECLARE t110_sel_ata CURSOR FOR
#   SELECT ata03,ata05 FROM ata_file
#    WHERE ata00 = l_prog
#      AND ata01 = p_po
#      AND ata02 = p_item
#  FOREACH t110_sel_ata INTO l_item,l_ata05
#     EXIT FOREACH
#  END FOREACH
#  LET l_item_old = p_item
#  LET p_item = l_item
#  END IF
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
   SELECT pmn04,pmn07,pmn20,(pmn50-pmn55-pmn58),pmn041,pmn16,pmn13,pmn011,     #FUN-9A0068
          pmn14,pmn15,pmn34,pmn37,pmn44,pmn09,pmn31,pmn31t,pmm42,pmn41,                 #No.FUN-550117
          pmn20-pmn50+pmn55+pmn58,pmn63,pmn52,pmn54,pmn56,pmn122,pmn71,pmn65,  #No.9893 #No.FUN-940083
          pmn80,pmn81,pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmm21,pmm43,pmm22,gec07,   #No.FUN-550017  FUN-610018
          pmn930,pmn89,pmn919  #FUN-670051   #MOD-A50122 add pmn89   #FUN-A80150 add pmn919 
     INTO g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_rvb[l_ac].pmn20,                        #No.FUN-940083 pmn07-->rvb90 
          g_rvb[l_ac].pmn50_55,g_rvb[l_ac].rvb051,l_pmn16,g_pmn13,l_pmn011,             #FUN-940083 pmn041-->rvb051
          g_pmn14,l_pmn15,l_pmn34,l_pmn37,g_pmn44,g_pmn09,g_pmn31,g_pmn31t,g_pmm42,     #No.FUN-550117
          g_rvb[l_ac].rvb34,l_rvb07,l_pmn63,l_pmn52,l_pmn54,l_pmn56,l_pmn122,
           l_rvb25,g_rvb2.rvb19,  #No:8114        #No.MOD-4B0275
          l_rvb80,l_rvb81,l_rvb82,l_rvb83,l_rvb84,l_rvb85,l_rvb86,l_rvb87,
          g_rvb[l_ac].pmm21,g_rvb[l_ac].pmm43,l_pmm22,g_gec07,  #No.FUN-550117
          g_rvb[l_ac].rvb930,g_rvb[l_ac].rvb89,g_rvb[l_ac].rvb919  #FUN-670051   #MOD-A50122 add rvb89  #FUN-A80150 add rvb919
      FROM pmn_file,pmm_file,gec_file    #No.FUN-550117
     WHERE pmn01 = p_po
       AND pmn02 = p_item
       AND pmn01=pmm01
       AND pmm18 <> 'X'
       AND pmm_file.pmm21 = gec_file.gec01       #No.FUN-550117
       AND gec011='1'   #MOD-740504
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3192'
         LET g_rvb[l_ac].rvb90 = NULL   #No.FUN-940083 pmn07-->rvb90 
         LET g_rvb[l_ac].pmn20 = NULL
         LET g_rvb[l_ac].pmn50_55 = NULL
         LET g_rvb[l_ac].rvb051= NULL   #FUN-940083 pmn041-->rvb051
         LET g_rvb[l_ac].rvb83 = NULL
         LET g_rvb[l_ac].rvb84 = NULL
         LET g_rvb[l_ac].rvb85 = NULL
         LET g_rvb[l_ac].rvb80 = NULL
         LET g_rvb[l_ac].rvb81 = NULL
         LET g_rvb[l_ac].rvb82 = NULL
         LET g_rvb[l_ac].rvb86 = NULL
         LET g_rvb[l_ac].rvb87 = NULL
      WHEN l_pmn16 != '2'
         LET g_errno = 'mfg3166'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

#FUN-A60035 ---MARK BEGIN
#   IF s_industry('slk') THEN #No.FUN-A50054
#    SELECT SUM(pmn50-pmn55-pmn58),SUM(pmn20-pmn50+pmn55+pmn58)
#      INTO g_rvb[l_ac].pmn50_55,l_rvb07
#      FROM pmn_file,pmm_file
#     WHERE pmn01 = p_po
#       AND pmn02 IN (SELECT ata03 FROM ata_file WHERE ata01 = p_po AND ata02 = l_item_old)
#       AND pmn01=pmm01
#       AND pmm18 <> 'X'
#   END IF
#FUN-A60035 ---MARK END
 
 
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
       SELECT imx00,imx01,imx02,imx03,imx04,imx05,
              imx06,imx07,imx08,imx09,imx10
        INTO g_rvb[l_ac].att00, g_rvb[l_ac].att01, g_rvb[l_ac].att02,
             g_rvb[l_ac].att03, g_rvb[l_ac].att04, g_rvb[l_ac].att05,
             g_rvb[l_ac].att06, g_rvb[l_ac].att07, g_rvb[l_ac].att08,
             g_rvb[l_ac].att09, g_rvb[l_ac].att10
        FROM imx_file
         WHERE imx000 = g_rvb[l_ac].rvb05
       #賦值所有屬性
       LET g_rvb[l_ac].att01_c = g_rvb[l_ac].att01
       LET g_rvb[l_ac].att02_c = g_rvb[l_ac].att02
       LET g_rvb[l_ac].att03_c = g_rvb[l_ac].att03
       LET g_rvb[l_ac].att04_c = g_rvb[l_ac].att04
       LET g_rvb[l_ac].att05_c = g_rvb[l_ac].att05
       LET g_rvb[l_ac].att06_c = g_rvb[l_ac].att06
       LET g_rvb[l_ac].att07_c = g_rvb[l_ac].att07
       LET g_rvb[l_ac].att08_c = g_rvb[l_ac].att08
       LET g_rvb[l_ac].att09_c = g_rvb[l_ac].att09
       LET g_rvb[l_ac].att10_c = g_rvb[l_ac].att10
    END IF
    IF l_pmn011!=g_rva.rva10 THEN
       LET g_errno='apm-251'
       RETURN
    END IF
 
    IF l_pmn011='SUB' AND g_rva.rva04='Y' THEN
       LET g_errno='apm-249'
       RETURN
    END IF
 
    LET g_pmn50_55=g_rvb[l_ac].pmn50_55
    LET l_pmn04 =  g_rvb[l_ac].rvb05
    IF l_pmn15 = 'N' THEN
       IF cl_null(l_pmn37) THEN
          LET l_date = l_pmn34
       ELSE LET l_date = l_pmn37
       END IF
       IF g_rva.rva06 < l_date THEN LET g_errno = 'mfg3039' RETURN  END IF
    END IF
    IF p_cmd = 'a' THEN
       LET g_pmn20 = g_rvb[l_ac].pmn20
          LET l_rvb07s=0
         #MOD-CC0096 mark start -----
         #SELECT SUM(rvb07) INTO l_rvb07s FROM rva_file,rvb_file   #未確認也計入
         # WHERE rva01=rvb01 AND rvb04=g_rvb[l_ac].rvb04
         #   AND rvb03=g_rvb[l_ac].rvb03 AND rvaconf='N' AND rvb35='N'
         #MOD-CC0096 mark end   -----
         #MOD-CC0096 add start -----
          LET g_sql = "SELECT SUM(rvb07) FROM rva_file,rvb_file ",
                      " WHERE rva01=rvb01 AND rvb04=? AND rvb03=? ",
                      "   AND rvaconf='N' AND rvb35='N' "

          IF NOT cl_null(g_rvb_t.rvb02) THEN
             LET g_sql = g_sql ," AND NOT (rvb01='", g_rva.rva01 ,"' AND rvb02='", g_rvb_t.rvb02 ,"') "
          END IF

          DECLARE t110_rvb07  CURSOR FROM g_sql
          OPEN t110_rvb07 USING g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03
          FETCH t110_rvb07 INTO l_rvb07s
          CLOSE t110_rvb07
         #MOD-CC0096 add end   -----
          IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
          LET g_rvb[l_ac].rvb07=l_rvb07-l_rvb07s
       LET g_rvb[l_ac].rvb25 = l_rvb25        #No.MOD-4B0275
       #若為LC收貨，則須檢查數貨不可大於提單數量
       IF g_rva.rva04='Y' AND NOT cl_null(g_rvb[l_ac].rvb22) THEN
          SELECT alt06 INTO l_alt06 FROM alt_file
           WHERE alt01=g_rvb[l_ac].rvb22
             AND alt14=g_rvb[l_ac].rvb04
             AND alt15=g_rvb[l_ac].rvb03
          IF cl_null(l_alt06) THEN
             LET l_alt06 = 0
          END IF
          SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
           WHERE rvb22=g_rvb[l_ac].rvb22
             AND rvb04=g_rvb[l_ac].rvb04
             AND rvb03=g_rvb[l_ac].rvb03
             AND rvb01!=g_rva.rva01
             AND rvb35='N'
          IF cl_null(t_alt06) THEN
             LET t_alt06 = 0
          END IF
          LET g_rvb[l_ac].rvb07 = (l_alt06-t_alt06)
       END IF
    END IF
    IF g_rvb[l_ac].rvb07 < 0 THEN LET g_rvb[l_ac].rvb07 = 0 END IF  #MOD-860172
 
    IF l_pmn63='Y' THEN              #急料
       CALL cl_getmsg('apm-253',g_lang) RETURNING g_msg
       CALL cl_msg(g_msg)
    END IF
 
    # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
    LET l_ec_sw = 'N'
    IF g_argv2 ='SUB' THEN
       LET l_sfb24=''
       SELECT sfb24 INTO l_sfb24
         FROM sfb_file
        WHERE sfb01 = g_rvb[l_ac].rvb34
       IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
          LET l_ec_sw='Y'
       END IF
    END IF
    IF l_ec_sw='N' THEN
      #IF cl_null(g_rvb[l_ac].rvb36) THEN LET g_rvb[l_ac].rvb36=l_pmn52 END IF #TQC-B60003
      #IF cl_null(g_rvb[l_ac].rvb37) THEN LET g_rvb[l_ac].rvb37=l_pmn54 END IF #TQC-B60003
      # IF g_rvb[l_ac].rvb36 IS NULL THEN LET g_rvb[l_ac].rvb36=l_pmn52 END IF  #TQC-B60003     #FUN-C20002 mark
      #FUN-C20002--start add--------------------------------------------------------
      IF g_azw.azw04 = '2' THEN
         SELECT ima154 INTO l_ima154 
           FROM ima_file 
          WHERE ima01 = g_rvb[l_ac].rvb05

         IF l_ima154 = 'Y' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN
            SELECT rcj03 INTO l_rcj03
              FROM rcj_file
             WHERE rcj00 = '0' 
         
            #FUN-C90049 mark begin---
            #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
            #  FROM rtz_file
            # WHERE rtz01 = g_plant
            #FUN-C90049 mark end-----
            CALL s_get_defstore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08  #FUN-C90049 add
           
            IF l_rcj03 = '1' THEN
               LET g_rvb[l_ac].rvb36 = l_rtz07
            ELSE
               LET g_rvb[l_ac].rvb36 = l_rtz08
            END IF   
         END IF
      ELSE
         IF g_rvb[l_ac].rvb36 IS NULL THEN LET g_rvb[l_ac].rvb36=l_pmn52 END IF  
      END IF   
      #FUN-C20002--end add-------------------------------------------------- 
       IF g_rvb[l_ac].rvb37 IS NULL THEN LET g_rvb[l_ac].rvb37=l_pmn54 END IF  #TQC-B60003
    END IF
    IF g_rvb[l_ac].rvb36 IS NULL THEN LET g_rvb[l_ac].rvb36=' ' END IF  #TQC-B60003
    IF g_rvb[l_ac].rvb37 IS NULL THEN LET g_rvb[l_ac].rvb37=' ' END IF  #TQC-B60003
    IF cl_null(g_rvb[l_ac].rvb38) THEN LET g_rvb[l_ac].rvb38 = ' ' END IF   #MOD-B80272 add
 
    IF cl_null(g_rvb[l_ac].rvb38) AND l_ec_sw='N' THEN   #No.B454 
       LET g_rvb[l_ac].rvb38=l_pmn56
    END IF
    IF cl_null(g_rvb[l_ac].rvb36) THEN
       SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
        WHERE pmm01=g_rvb[l_ac].rvb04
       
        SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file
         WHERE pmn01 = g_rvb[l_ac].rvb04 AND pmn02 = g_rvb[l_ac].rvb03          
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
                    AND sgm012 = l_pmn012                #FUN-A60076 add by vealxu  
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
                    AND ecm012=l_pmn012                  #FUN-A60076  add by huangtao
              END IF
           END IF   #MOD-910172
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF
       
       SELECT pmh08 INTO l_pmh08 FROM pmh_file
        WHERE pmh01=g_rvb[l_ac].rvb05 AND pmh02=g_rva.rva05
          AND pmh13=l_pmm22
          AND pmh21= l_ecm04   #MOD-860146
          AND pmh22= l_type    #MOD-860146
          AND pmh23 = ' '      #No.CHI-960033 
          AND pmhacti = 'Y'                                           #CHI-910021
       IF status THEN LET l_pmh08='N' END IF
        IF g_rvb[l_ac].rvb05[1,4] !='MISC' AND l_ec_sw='N' THEN   #No.MOD-580087
          SELECT ima35,ima36 INTO g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
            FROM ima_file
           WHERE ima01=g_rvb[l_ac].rvb05
          IF g_azw.azw04='2' THEN 
             #FUN-C20002--start add---------------------------------------
             SELECT ima154 INTO l_ima154
               FROM ima_file
              WHERE ima01 = g_rvb[l_ac].rvb05
             
             IF l_ima154 = 'Y' THEN
                SELECT rcj03 INTO l_rcj03 
                  FROM rcj_file
                 WHERE rcj00 = '0'
                
                #FUN-C90049 mark begin--- 
                #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                #  FROM rtz_file
                # WHERE rtz01 = g_plant
                #FUN-C90049 mark end-----
                CALL s_get_defstore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08  #FUN-C90049 add
               
                IF l_rcj03 = '1' THEN
                   LET g_rvb[l_ac].rvb36 = l_rtz07 
                ELSE
                   LET g_rvb[l_ac].rvb36 = l_rtz08
                END IF  
             ELSE
             #FUN-C20002--end add----------------------------------------- 
                #FUN-C90049 mark begin-----
                #SELECT rtz07 INTO l_rtz07 FROM rtz_file #MOD-9C0016 del rtz08 
                # WHERE rtz01 = g_rva.rvaplant 
                #FUN-C90049 mark end-------
                CALL s_get_coststore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07   #FUN-C90049 add
               #FUN-B40098 Begin---
               #IF g_rva.rva29 = '3' THEN   #FUN-B60150 MARK
                IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')THEN #FUN-B60150 ADD
                   #FUN-C90049 mark begin---
                   #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                   # WHERE rtz01 = g_rva.rvaplant
                   #FUN-C90049 mark end----
                   CALL s_get_noncoststore(g_plant,g_rvb[l_ac].rvb05) RETURNING l_rtz07   #FUN-C90049 add
                END IF
               #FUN-B40098 End-----
                IF NOT cl_null(l_rtz07) THEN #MOD-B30598 add
                   LET g_rvb[l_ac].rvb36 = l_rtz07 
                END IF  #MOD-B30598 add
             END IF                        #FUN-C20002   add  
          END IF
#FUN-AB0066 --begin--
#          #No.FUN-AA0049--begin
#          IF NOT s_chk_ware(g_rvb[l_ac].rvb36) THEN
#             LET g_rvb[l_ac].rvb36=' '
#             LET g_rvb[l_ac].rvb37=' '
#          END IF 
#          #No.FUN-AA0049--end            
#FUN-AB0066 --end--          
          IF cl_null(g_rvb[l_ac].rvb38) THEN LET g_rvb[l_ac].rvb38=' ' END IF  #TQC-810048 add
       END IF
    END IF
    IF g_rvb[l_ac].rvb05[1,4]='MISC' OR l_ec_sw='Y' THEN
       LET g_rvb2.rvb36=NULL LET g_rvb[l_ac].rvb36=NULL
       LET g_rvb2.rvb37=NULL LET g_rvb[l_ac].rvb37=NULL
       LET g_rvb2.rvb38=NULL LET g_rvb[l_ac].rvb38=NULL
    END IF
 
    SELECT ima021 INTO g_rvb[l_ac].ima021 FROM ima_file
     WHERE ima01=g_rvb[l_ac].rvb05
   #FUN-A80150---add---start---
    IF p_cmd <> 'a' AND NOT cl_null(g_rvb2.rvb919) THEN
       LET g_rvb[l_ac].rvb919 = g_rvb2.rvb919
    END IF
   #FUN-A80150---add---end---
    
    LET g_rvb[l_ac].rvb05a = g_rvb[l_ac].rvb05      #FUN-810016
    LET g_rvb[l_ac].rvb05b = g_rvb[l_ac].rvb051     #FUN-810016 #FUN-940083 pmn041-->rvb051
    LET g_rvb[l_ac].rvb05c = g_rvb[l_ac].ima021     #FUN-810016 
     
     DISPLAY BY NAME g_rvb[l_ac].rvb05      
     DISPLAY BY NAME g_rvb[l_ac].rvb90              #No.FUN-940083 pmn07-->rvb90 
     DISPLAY BY NAME g_rvb[l_ac].pmn20
     DISPLAY BY NAME g_rvb[l_ac].pmn50_55
     DISPLAY BY NAME g_rvb[l_ac].rvb051             #FUN-940083 pmn041-->rvb051
     DISPLAY BY NAME g_rvb[l_ac].rvb34
     DISPLAY BY NAME g_rvb[l_ac].rvb07
     DISPLAY BY NAME g_rvb[l_ac].rvb25
     DISPLAY BY NAME g_rvb[l_ac].rvb36
     DISPLAY BY NAME g_rvb[l_ac].rvb37
     DISPLAY BY NAME g_rvb[l_ac].rvb38
     DISPLAY BY NAME g_rvb[l_ac].ima021  
     DISPLAY BY NAME g_rvb[l_ac].rvb919     #FUN-A80150 add
     CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
     LET g_rvb2.rvb930=g_rvb[l_ac].rvb930
     DISPLAY BY NAME g_rvb[l_ac].rvb930,g_rvb[l_ac].gem02a
     DISPLAY BY NAME
       g_rvb[l_ac].att01, g_rvb[l_ac].att01_c,
       g_rvb[l_ac].att02, g_rvb[l_ac].att02_c,
       g_rvb[l_ac].att03, g_rvb[l_ac].att03_c,
       g_rvb[l_ac].att04, g_rvb[l_ac].att04_c,
       g_rvb[l_ac].att05, g_rvb[l_ac].att05_c,
       g_rvb[l_ac].att06, g_rvb[l_ac].att06_c,
       g_rvb[l_ac].att07, g_rvb[l_ac].att07_c,
       g_rvb[l_ac].att08, g_rvb[l_ac].att08_c,
       g_rvb[l_ac].att09, g_rvb[l_ac].att09_c,
       g_rvb[l_ac].att10, g_rvb[l_ac].att10_c
 
    IF p_cmd = 'a' OR g_rvb_t.rvb05 IS NULL OR
       g_rvb_t.rvb05 <> g_rvb[l_ac].rvb05 THEN
       LET g_rvb[l_ac].rvb30 = 0  #No.MOD-890236 
       LET g_rvb[l_ac].rvb29 = 0  #No.MOD-890236  
       IF g_sma.sma115 = 'Y' THEN
          LET l_rvb82e = 0
          LET l_rvb85e = 0 
         #MOD-CC0096 mark start -----
         #SELECT SUM(rvb82),SUM(rvb85) INTO l_rvb82e,l_rvb85e FROM rvb_file,rva_file
         # WHERE rvb04 = g_rvb[l_ac].rvb04
         #   AND rvb03 = g_rvb[l_ac].rvb03
         #   AND rva01 = rvb01
         #   AND rvaconf <> 'X'   #MOD-970207
         #   AND rvb35 = 'N'      #MOD-970207
         #MOD-CC0096 mark end    -----
         #MOD-CC0096 add start -----
          LET g_sql = "SELECT SUM(rvb82),SUM(rvb85) FROM rvb_file,rva_file ",
                      " WHERE rva01=rvb01 AND rvb04=? AND rvb03=? ",
                      "   AND rvaconf<>'X' AND rvb35='N' "

          IF NOT cl_null(g_rvb_t.rvb02) THEN
             LET g_sql = g_sql ," AND NOT (rvb01='", g_rva.rva01 ,"' AND rvb02='", g_rvb_t.rvb02 ,"') "
          END IF

          DECLARE t110_rvb82 CURSOR FROM g_sql
          OPEN t110_rvb82 USING g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03
          FETCH t110_rvb82 INTO l_rvb82e,l_rvb85e
          CLOSE t110_rvb82
         #MOD-CC0096 add end   -----
          IF cl_null(l_rvb82e) THEN LET l_rvb82e =  0 END IF
          IF cl_null(l_rvb85e) THEN LET l_rvb85e =  0 END IF
          LET g_rvb[l_ac].rvb80 = l_rvb80
          LET g_rvb[l_ac].rvb81 = l_rvb81
          LET g_rvb[l_ac].rvb82 = l_rvb82 - l_rvb82e  #No.MOD-890236 add - l_rvb82e
          LET g_rvb[l_ac].rvb83 = l_rvb83
          LET g_rvb[l_ac].rvb84 = l_rvb84
          LET g_rvb[l_ac].rvb85 = l_rvb85 - l_rvb85e  #No.MOD-890236 add - l_rvb85e
       END IF
       LET g_rvb[l_ac].rvb86 = l_rvb86
       LET g_rvb[l_ac].rvb87 = l_rvb87
       CALL t110_set_rvb87()
    END IF
 
    IF  p_cmd <> 'd' THEN
        LET g_rvb2.rvb08 = g_rvb[l_ac].rvb07
    END IF
 
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmm22   #No.CHI-6A0004
    
    SELECT ima150,ima151 INTO l_ima150,l_ima151 FROM ima_file
     WHERE ima_file.ima01=g_rvb[l_ac].rvb05
    #IF l_ima150!='0' OR  l_ima151='Y' THEN   #MOD-CB0099 mark
     IF l_ima150 MATCHES '[12]' OR  l_ima151 = 'Y' THEN #MOD-CB0099 add
       CALL cl_set_comp_entry('rvb05',TRUE)
     ELSE
     	 CALL cl_set_comp_entry('rvb05',FALSE)
     END IF 
     #FUN-A20017--begin--add----
     IF NOT cl_null(g_rvb[l_ac].rvb03) THEN
        SELECT ima903 INTO l_ima903
          FROM ima_file,pmn_file
         WHERE pmn01 = g_rvb[l_ac].rvb04
           AND pmn02 = g_rvb[l_ac].rvb03
           AND ima01 = pmn04
        IF g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
           CALL cl_set_comp_entry("rvb05",FALSE) 
        ELSE
           CALL cl_set_comp_entry('rvb05',TRUE)
        END IF
     END IF
     #FUN-A20017--end--add----
     #若為制衣業,則輸入完采購單號,項次后,判斷rvb05a
     #采購料號對應的補貨策略是否是6-訂單式采購,
     #若是，則將采購單身的制單號帶入到收貨單身的批號中 
       IF s_industry('slk') THEN
         { SELECT  ima37 INTO l_ima37 FROM ima_file 
          WHERE ima_file.ima01=g_rvb[l_ac].rvb05a
          IF l_ima37='6' THEN}                      #No.FUN-840178--mark--
            SELECT pmnislk01 INTO g_rvb[l_ac].rvb38 
            FROM pmni_file
            WHERE pmni_file.pmni01=g_rvb[l_ac].rvb04
            AND pmni_file.pmni02=g_rvb[l_ac].rvb03
       END IF      
#FUN-A60035 ---MARK BEGIN 
##FUN-A60035 ---add begin
#  IF s_industry('slk') THEN #No.FUN-A50054
#     LET g_rvb[l_ac].rvb05 = l_ata05
#     LET g_rvb[l_ac].rvb05a = l_ata05
#     SELECT SUM(pmn20) INTO g_rvb[l_ac].pmn20
#       FROM pmn_file,pmm_file
#      WHERE pmn01 = p_po
#        AND pmn02 IN (SELECT ata03 FROM ata_file WHERE ata01 = p_po AND ata02 =  l_item_old)
#        AND pmn01=pmm01 AND pmm18 <> 'X'
#  END IF
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2,p_wc3)              #BODY FILL UP   #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
   DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
   DEFINE l_ima021        LIKE ima_file.ima021   #No.FUN-810016
   DEFINE l_ima02         LIKE ima_file.ima02    #No.FUN-840178
   DEFINE l_pmn07         LIKE pmn_file.pmn07    #No.FUN-940083
   DEFINE l_ima903        LIKE ima_file.ima903   #FUN-A20017
   DEFINE l_ima01         LIKE ima_file.ima01    #FUN-A20017
   DEFINE l_pmn123        LIKE pmn_file.pmn123   #FUN-B40083
   DEFINE p_wc3           STRING                 #FUN-B90101
   
#FUN-A60035 ---MARK BEGIN
##FUN-A60035 ---add begin
#  DEFINE l_rvb02  DYNAMIC ARRAY OF RECORD
#         rvb02    LIKE rvb_file.rvb02
#         END RECORD
#  DEFINE l_i      LIKE type_file.num5
#  DEFINE l_go     LIKE type_file.chr1
#  DEFINE l_prog   LIKE type_file.chr20
##FUN-A60035 ---add end
#FUN-A60035 ---MARK END
   
         LET g_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,rvbiicd03,rvb05,",
                     " '','','','','','','','','','','','','','','','','','','','','',",   #TQC-650108
                     #" pmn041,ima021,pmn04,'','',rvb919,rvbiicd14,rvbiicd11,", #MOD-840156      #FUN-A80150 add rvb919   #MOD-BC0039
                     " rvb051,ima021,pmn04,pmn041,'',rvb919,rvbiicd14,rvbiicd11,", #MOD-840156      #FUN-A80150 add rvb919                #MOD-BC0039
                     " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083  #NO.FUN-960130 #FUN-9A0068 #CHI-980024 mod
                     " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",
                     " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,pmn123,'',rvb930,'',rvb93, ",     #No.FUN-550117  FUN-610018 #FUN-670051  #FUN-9C0046 add rvb93  #FUN-B40083 add pmn123
                     " rvbiicd08,rvbiicd10,rvbiicd12,rvbiicd15,rvbiicd16 ",
                     " ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05, ",
                     "rvbud06,rvbud07,rvbud08,rvbud09,rvbud10, ",
                     "rvbud11,rvbud12,rvbud13,rvbud14,rvbud15 ", 
                     " FROM rvb_file,OUTER pmn_file,OUTER ima_file,OUTER pmm_file,OUTER rvbi_file" ,
                     " WHERE rvb01 ='",g_rva.rva01,"' ",
                     "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
                     "   AND rvb_file.rvb05=ima_file.ima01 AND ",p_wc2 CLIPPED,   #MOD-940245取消mark
                     "   AND rvb_file.rvb04 = pmm_file.pmm01 ",            #No.FUN-550117
                     "   AND rvb_file.rvb01 =rvbi_file.rvbi01 ",
                     "   AND rvb_file.rvb02 =rvbi_file.rvbi02 ",
                     " ORDER BY rvb02"   #No.MOD-5A0448
   IF g_azw.azw04='2' THEN
      LET g_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,'',rvb05,",
                  " '','','','','','','','','','','','','','','','','','','','','',",
                  #" rvb051,ima021,'','','',rvb919,'','',",    #FUN-A80150 add rvb919   #MOD-BC0039
                  " rvb051,ima021,pmn04,pmn041,'',rvb919,'','',",    #FUN-A80150 add rvb919   #MOD-BC0039
                  " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,", #FUN-9A0068    
                  " rvb29,rvb89,rvb35,'','',rvb07,", 
                  " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",                                                      
                  " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,pmn123,'',rvb930,'',rvb93, ",   #FUN-9C0046 add rvb93  #FUN-B40083 add pmn123                                    
                  " '','','','','' ",
                  " ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05, ",                                                            
                  "rvbud06,rvbud07,rvbud08,rvbud09,rvbud10, ",                                                              
                  "rvbud11,rvbud12,rvbud13,rvbud14,rvbud15 ",
                   " FROM rvb_file,OUTER pmn_file,OUTER ima_file,OUTER pmm_file" ,           
                  " WHERE rvb01 ='",g_rva.rva01,"' ",                                                                       
                  "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",                                              
                  "   AND rvb_file.rvb05=ima_file.ima01 AND ",p_wc2 CLIPPED,                                                         
                  "   AND rvb_file.rvb04 = pmm_file.pmm01 ",                                                                         
                  " ORDER BY rvb02"  
   END IF

#FUN-B90101--add--begin--
   IF g_azw.azw04='2' THEN             #TQC-C20117--add     
      IF cl_null(p_wc3) THEN
         LET p_wc3 = " 1=1"
      END IF
      LET g_sql = "SELECT DISTINCT rvb02,rvb22,rvb04,rvb03,rvb34,rvbiicd03,rvb05,",
                  " '','','','','','','','','','','','','','','','','','','','','',",   #TQC-650108            
                  #" pmn041,ima021,pmn04,'','',rvb919,rvbiicd14,rvbiicd11,", #MOD-840156      #FUN-A80150 add rvb919   #MOD-BC0039
                  " rvb051,ima021,pmn04,pmn041,'',rvb919,rvbiicd14,rvbiicd11,", #MOD-840156      #FUN-A80150 add rvb919 
                  " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083  #NO.FUN-960130 #FUN-9A0068 #CHI-980024 mod
                  " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",
                  " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,pmn123,'',rvb930,'',rvb93, ",     #No.FUN-550117  FUN-610018 #FUN-670051  #FUN-9C0046 add rvb93  #FUN-B40083 add pmn123
                  " rvbiicd08,rvbiicd10,rvbiicd12,rvbiicd15,rvbiicd16 ",
                  " ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05, ",
                  "rvbud06,rvbud07,rvbud08,rvbud09,rvbud10, ",
                  "rvbud11,rvbud12,rvbud13,rvbud14,rvbud15 ", 
                  " FROM rvb_file,pmn_file,ima_file,pmm_file,rvbi_file,rvbslk_file" ,
                  " WHERE rvb01 ='",g_rva.rva01,"' ",
                  "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
                  "   AND rvb_file.rvb05=ima_file.ima01 AND ",p_wc2 CLIPPED,   #MOD-940245取消mark
                  "   AND rvb_file.rvb04 = pmm_file.pmm01 ",            #No.FUN-550117
                  "   AND rvb_file.rvb01 =rvbi_file.rvbi01 ",
                  "   AND rvb_file.rvb02 =rvbi_file.rvbi02 ",
                  "   AND rvbslk_file.rvbslk01 = rvbi_file.rvbi01 ",
                  "   AND rvbslk_file.rvbslk02 = rvbi_file.rvbislk02 AND ",p_wc3 CLIPPED,
                  " ORDER BY rvb02"   #No.MOD-5A0448
   END IF                           #TQC-C20117--end
#FUN-B90101--add--end--
   PREPARE t110_pb FROM g_sql
   DISPLAY "G_SQL=",g_sql
    
   IF STATUS THEN CALL cl_err('prep:',STATUS,1) RETURN END IF
   DECLARE rvb_curs  CURSOR FOR t110_pb
    
   CALL g_rvb.clear() #MOD-4B0039
 
   LET g_cnt = 1
   LET g_rec_b = 0
   LET g_gec07 = 'N'       #No.FUN-550117
   FOREACH rvb_curs INTO g_rvb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #-----MOD-BC0039---------
      ##如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      #IF  g_rvb[g_cnt].rvb05a= g_rvb[g_cnt].rvb05 THEN  #No.MOD-920003
      #  LET g_rvb[g_cnt].rvb05b=g_rvb[g_cnt].rvb051     #FUN-940083 pmn041-->rvb051
      #  LET g_rvb[g_cnt].rvb05c=g_rvb[g_cnt].ima021 
      #ELSE   
      # SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file     #MOD-840221 modify ima02  #No.MOD-920003
      #    WHERE ima01=g_rvb[g_cnt].rvb05           #No.MOD-920003
      #  LET g_rvb[g_cnt].rvb05b=g_rvb[g_cnt].rvb051 #No.MOD-920003 #FUN-940083 pmn041-->rvb051 
      #  LET g_rvb[g_cnt].rvb05c=g_rvb[g_cnt].ima021 #No.MOD-920003  
      #  LET g_rvb[g_cnt].rvb051 = l_ima02           #No.MOD-920003 #FUN-940083 pmn041-->rvb051 
      #  LET g_rvb[g_cnt].ima021 = l_ima021          #No.MOD-920003
      #END IF                        #No.MOD-920003
      SELECT ima021 INTO  g_rvb[g_cnt].rvb05c FROM ima_file
       WHERE ima01 = g_rvb[g_cnt].rvb05a
      #-----END MOD-BC0039-----
      #FUN-B40083 --begin
      IF NOT cl_null(g_rvb[g_cnt].pmn123) THEN
         SELECT mse02 INTO g_rvb[g_cnt].mse02
           FROM mse_file WHERE mse01= g_rvb[g_cnt].pmn123
      ELSE
         LET g_rvb[g_cnt].pmn123 = ' '
         LET g_rvb[g_cnt].mse02 = ' '
      END IF
      #FUN-B40083 --end
      IF g_argv6='1' THEN
        #MOD-B90256 mod --start--
        #SELECT pmn07 INTO l_pmn07 FROM pmn_file WHERE pmn04 =  g_rvb[g_cnt].rvb05
         SELECT pmn07 INTO l_pmn07 FROM pmn_file 
          WHERE pmn01 = g_rvb[g_cnt].rvb04
            #AND pmn04 = g_rvb[g_cnt].rvb05 #MOD-BB0343 mark
            AND pmn02 = g_rvb[g_cnt].rvb03  #MOD-BB0343 add
        #MOD-B90256 mod --end--
         LET g_rvb[g_cnt].rvb90 = l_pmn07
      END IF
      #FUN-A20017--begin--add-------
      IF g_argv2 = 'SUB' AND NOT cl_null(g_rvb[g_cnt].rvb05) 
         AND NOT cl_null(g_rvb[g_cnt].rvb03) THEN  
         SELECT pmn04,ima903 INTO l_ima01,l_ima903
           FROM ima_file,pmn_file
          WHERE pmn01 = g_rvb[g_cnt].rvb04
            AND pmn02 = g_rvb[g_cnt].rvb03
            AND ima01 = pmn04
         IF g_rvb[g_cnt].rvb05 <> l_ima01 THEN
            SELECT ima02,ima021 INTO  g_rvb[g_cnt].rvb051,g_rvb[g_cnt].ima021 FROM ima_file 
             WHERE ima01 = g_rvb[g_cnt].rvb05 
         END IF
      END IF
      #FUN-A20017--end--add-----
#FUN-A60035 ---MARK BEGIN
#      #No.FUN-A50054 -BEGIN----- 
#       #FUN-A60035 ---add begin
#       IF g_argv2 = 'SUB' THEN
#          LET l_prog = 'apmt590_slk'
#       ELSE
#          IF g_argv2 = 'TAP' THEN
#             LET l_prog = 'apmt540_slk'
#          ELSE
#             LET l_prog = 'apmt540_slk'
#          END IF
#       END IF
#       SELECT ata02 INTO g_rvb[g_cnt].rvb03 FROM ata_file
#        WHERE ata00 = l_prog
#          AND ata01 = g_rvb[g_cnt].rvb04
#          AND ata03 = g_rvb[g_cnt].rvb02
#       #FUN-A60035 ---add end
#       IF s_industry('slk') THEN
#          SELECT ata02,ata05 INTO g_rvb[g_cnt].rvb02,g_rvb[g_cnt].rvb05
#            FROM ata_file
#           WHERE ata00 = g_prog
#             AND ata01 = g_rva.rva01
#             AND ata03 = g_rvb[g_cnt].rvb02
#          LET l_rvb02[l_rvb02.getLength() + 1] = g_rvb[g_cnt].rvb02   #FUN-A60035 add
#          IF g_cnt > 1 THEN
#             #FUN-A60035 ---mark begin
#             #IF g_rvb[g_cnt].rvb02 = g_rvb[g_cnt-1].rvb02 THEN
#             #   CONTINUE FOREACH
#             #END IF
#             #FUN-A60035 ---mark end
#             #FUN-A60035 ---add begin
#                LET l_go = 'N'
#                FOR l_i = 1 TO l_rvb02.getLength()-1
#                    IF g_rvb[g_cnt].rvb02 = l_rvb02[l_i].rvb02 THEN
#                       LET l_go = 'Y'
#                       EXIT FOR
#                    END IF
#                END FOR
#                IF l_go = 'Y' THEN
#                   CONTINUE FOREACH
#                END IF
#             #FUN-A60035 ---add end
#          END IF
#          SELECT SUM(ata08) INTO g_rvb[g_cnt].rvb07 from ata_file
#           WHERE ata00 = g_prog
#             AND ata01 = g_rva.rva01
#             AND ata02 = g_rvb[g_cnt].rvb02
#          #FUN-A60035 ---add begin #顯示的採購量也應該是和,採購料件也該是母料件
#          LET g_rvb[g_cnt].pmn20 = g_rvb[g_cnt].rvb07
#          LET g_rvb[g_cnt].rvb05a = g_rvb[g_cnt].rvb05
#          SELECT SUM(pmn50-pmn55-pmn58)
#            INTO g_rvb[g_cnt].pmn50_55
#            FROM pmn_file,pmm_file
#           WHERE pmn01 = g_rvb[g_cnt].rvb04
#             AND pmn02 IN (SELECT ata03 FROM ata_file WHERE ata01 = g_rvb[g_cnt].rvb04 AND ata02 = g_rvb[g_cnt].rvb03)
#             AND pmn01=pmm01
#            AND pmm18 <> 'X'
#          SELECT SUM(rvb30) INTO g_rvb[g_cnt].rvb30
#            FROM rvb_file 
#           WHERE rvb01 = g_rva.rva01
#             AND rvb02 IN (SELECT ata03 FROM ata_file
#                            WHERE ata00 = g_prog
#                              AND ata01 = g_rva.rva01
#                              AND ata02 = g_rvb[g_cnt].rvb02)
#          #FUN-A60035 ---add end
#       ELSE
#      #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_rvb[g_cnt].att00,g_rvb[g_cnt].att01,g_rvb[g_cnt].att02,
                g_rvb[g_cnt].att03,g_rvb[g_cnt].att04,g_rvb[g_cnt].att05,
                g_rvb[g_cnt].att06,g_rvb[g_cnt].att07,g_rvb[g_cnt].att08,
                g_rvb[g_cnt].att09,g_rvb[g_cnt].att10
         FROM imx_file WHERE imx000 = g_rvb[g_cnt].rvb05
 
         LET g_rvb[g_cnt].att01_c = g_rvb[g_cnt].att01
         LET g_rvb[g_cnt].att02_c = g_rvb[g_cnt].att02
         LET g_rvb[g_cnt].att03_c = g_rvb[g_cnt].att03
         LET g_rvb[g_cnt].att04_c = g_rvb[g_cnt].att04
         LET g_rvb[g_cnt].att05_c = g_rvb[g_cnt].att05
         LET g_rvb[g_cnt].att06_c = g_rvb[g_cnt].att06
         LET g_rvb[g_cnt].att07_c = g_rvb[g_cnt].att07
         LET g_rvb[g_cnt].att08_c = g_rvb[g_cnt].att08
         LET g_rvb[g_cnt].att09_c = g_rvb[g_cnt].att09
         LET g_rvb[g_cnt].att10_c = g_rvb[g_cnt].att10
 
      END IF
#      END IF #No.FUN-A50054    #FUN-A60035 ---MARK
      IF cl_null(g_rvb[g_cnt].rvb83) THEN
         LET g_rvb[g_cnt].rvb84=NULL
         LET g_rvb[g_cnt].rvb85=NULL
      END IF
      IF cl_null(g_rvb[g_cnt].rvb80) THEN
         LET g_rvb[g_cnt].rvb81=NULL
         LET g_rvb[g_cnt].rvb82=NULL
      END IF
       IF cl_null(g_rvb[g_cnt].rvb86) THEN
         LET g_rvb[g_cnt].rvb87=NULL
      END IF
      CALL t110_set_rvb930(g_rvb[g_cnt].rvb930) RETURNING g_rvb[g_cnt].gem02a #FUN-670051
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_rvb.deleteElement(g_cnt)
 
   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
   
   LET g_rec_b=g_cnt-1
#FUN-B90101 add &ifndef SLK
#&ifndef SLK    #TQC-C20117--mark
 IF g_prog <> 'apmt110_slk' THEN    #TQC-C20117--add
    DISPLAY g_rec_b TO FORMONLY.cn2
 END IF                             #TQC-C20117--add
#&endif         #TQC-C20117--mark
#FUN-B90101 add &endif
   LET g_cnt = 0
 
   CALL t110_refresh_detail()   #TQC-650108

   #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs10,rvbs11,rvbs12,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_rva.rva01,"'"
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

#FUN-B90101--add--begin--
FUNCTION t110_b_fill2(p_wc3,p_wc2)
   DEFINE p_wc3    STRING,
          p_wc2    STRING,
          l_cnt    LIKE type_file.num5,
          l_count  LIKE rvb_file.rvb07

   IF cl_null(p_wc3) THEN
      LET p_wc3 = " 1=1"
   END IF
   IF cl_null(p_wc2) OR p_wc2 = " 1=1" THEN
      LET g_sql="SELECT DISTINCT rvbslk02,rvbslk04,rvbslk03,rvbslk05,rvbslk051,' ',",
                "       rvbslk07,rvbslk10,rvbslk10t,rvbslk29,rvbslk30,rvbslk36,",
                "       rvbslk37,rvbslk38,rvbslk88,rvbslk88t,rvbslk930,' ',",
                "       rvbslk90,rvbslk42,rvbslk43 ",
                "  FROM rvbslk_file WHERE rvbslk01='",g_rva.rva01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY rvbslk02 " 
   ELSE
      LET g_sql="SELECT DISTINCT rvbslk02,rvbslk04,rvbslk03,rvbslk05,rvbslk051,' ',",
                "       rvbslk07,rvbslk10,rvbslk10t,rvbslk29,rvbslk30,rvbslk36,",
                "       rvbslk37,rvbslk38,rvbslk88,rvbslk88t,rvbslk930,' ',",
                "       rvbslk90,rvbslk42,rvbslk43 ",
                "  FROM rvbslk_file,rvb_file,rvbi_file WHERE rvbslk01='",g_rva.rva01,"'",
                "   AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND rvbslk01 = rvbi01 ",
                "   AND rvbslk02 = rvbislk02 ",
                "   AND ",p_wc3 CLIPPED," AND ",p_wc2 CLIPPED,
                " ORDER BY rvbslk02 " 
   END IF
   
   PREPARE t110_pp2 FROM g_sql
   DECLARE t110_cs3 CURSOR FOR t110_pp2

   CALL g_rvbslk.clear()
   LET l_cnt=1
   FOREACH t110_cs3 INTO g_rvbslk[l_cnt].*

      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      SELECT ima021 INTO g_rvbslk[l_cnt].ima021a FROM ima_file
                         WHERE ima01 = g_rvbslk[l_cnt].rvbslk05
      CALL t110_set_rvb930(g_rvbslk[l_cnt].rvbslk930) RETURNING g_rvbslk[l_cnt].gem02 
      LET l_cnt=l_cnt+1
      IF l_cnt > g_max_rec THEN     
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvbslk.deleteElement(l_cnt)
   LET g_rec_b2=l_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
   DISPLAY l_count TO FORMONLY.qty
END FUNCTION

FUNCTION t110_check_imx(p_index,p_qty,p_qty_t)
   DEFINE p_index     LIKE type_file.num5,
          p_qty       LIKE rvb_file.rvb07,
          p_qty_t     LIKE rvb_file.rvb07
   DEFINE l_ima01     LIKE ima_file.ima01  #MOD-C30217 add
   DEFINE l_n         LIKE type_file.num5  #MOD-C30217 add

    LET g_errno = ''
    IF cl_null(g_rvbslk[l_ac2].rvbslk05)  THEN
       RETURN FALSE
    END IF
#MOD-C30217---add------------------
    IF p_qty < 0 THEN
       CALL cl_err('','art-040',0)
       RETURN FALSE
    END IF
    IF (NOT cl_null(g_rvbslk[l_ac2].rvbslk03)) AND (NOT cl_null(g_rvbslk[l_ac2].rvbslk04)) THEN
       SELECT imx000 INTO l_ima01 FROM imx_file WHERE imx00=g_rvbslk[l_ac2].rvbslk05
                                                  AND imx01=g_imx[l_ac3].color
                                                  AND imx02=g_imxtext[1].detail[p_index].size  
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM pmn_file,pmni_file,imx_file
          WHERE pmn01=pmni01 AND pmn02=pmni02 AND pmn04=imx000 
            AND pmn01=g_rvbslk[l_ac2].rvbslk04
            AND pmnislk02=g_rvbslk[l_ac2].rvbslk05 
            AND pmnislk03=g_rvbslk[l_ac2].rvbslk03
            AND imx000=l_ima01
       IF l_n = 0 OR cl_null(l_n) THEN
          CALL cl_err('','mfg-313',0)
          RETURN FALSE
       END IF
       IF NOT t110_check_rvb07(l_ima01,p_qty) THEN
          RETURN FALSE
       END IF 
    END IF
#MOD-C30217---end------------------

    RETURN TRUE
END FUNCTION

FUNCTION t110_check_color()
  DEFINE i          LIKE type_file.num5
  DEFINE l_flag     LIKE type_file.chr1

    FOR i=1 TO g_imx.getLength()
      IF g_imx[i].color=g_imx[l_ac3].color AND i<>l_ac3 THEN
         LET l_flag='N'
         EXIT FOR
      END IF
    END FOR
    IF l_flag='N' THEN
       CALL cl_err('',1120,0)
       RETURN FALSE
    END IF
    RETURN TRUE

END FUNCTION

FUNCTION t110_check_ima(p_index,p_ac3,p_ima01)
   DEFINE p_index     LIKE type_file.num5,
          p_ac3       LIKE type_file.num5,
          p_ima01     LIKE ima_file.ima01,
          l_ima01     LIKE ima_file.ima01,
          l_ps        LIKE sma_file.sma46,
          l_n         LIKE type_file.num5

   IF cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
      RETURN
   END IF
   
   LET g_errno = ' '
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_ac3].color,l_ps,
                 g_imxtext[p_ac3].detail[p_index].size

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM pmn_file WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
                                            AND pmn04 = l_ima01
                                            AND pmn02 IN (SELECT pmn02 FROM pmn_file,pmni_file
                                                           WHERE pmn01=pmni01
                                                             AND pmn02=pmni02
                                                             AND pmni01=g_rvbslk[l_ac2].rvbslk04
                                                             AND pmnislk03=g_rvbslk[l_ac2].rvbslk03)   
    IF l_n = 0 THEN
       CALL cl_err(l_ima01,'mfg-114',0)
       RETURN FALSE
   END IF
   RETURN TRUE

END FUNCTION

#MOD-C30217---add---begin-------------------
FUNCTION t110_chk_color_detail(p_ac,p_item)
DEFINE p_ac    LIKE type_file.num5
DEFINE p_item  LIKE ima_file.ima01
DEFINE i       LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_qty   LIKE type_file.num5

  IF cl_null(g_rvbslk[l_ac2].rvbslk04) AND cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
     RETURN TRUE
  END IF
  IF (g_imx[l_ac3].imx01 IS NULL OR g_imx[l_ac3].imx01 = 0) AND (g_imx[l_ac3].imx02 IS NULL OR g_imx[l_ac3].imx02 = 0) AND
     (g_imx[l_ac3].imx03 IS NULL OR g_imx[l_ac3].imx03 = 0) AND (g_imx[l_ac3].imx04 IS NULL OR g_imx[l_ac3].imx04 = 0) AND
     (g_imx[l_ac3].imx05 IS NULL OR g_imx[l_ac3].imx05 = 0) AND (g_imx[l_ac3].imx06 IS NULL OR g_imx[l_ac3].imx06 = 0) AND
     (g_imx[l_ac3].imx07 IS NULL OR g_imx[l_ac3].imx07 = 0) AND (g_imx[l_ac3].imx08 IS NULL OR g_imx[l_ac3].imx08 = 0) AND
     (g_imx[l_ac3].imx09 IS NULL OR g_imx[l_ac3].imx09 = 0) AND (g_imx[l_ac3].imx10 IS NULL OR g_imx[l_ac3].imx10 = 0) AND
     (g_imx[l_ac3].imx11 IS NULL OR g_imx[l_ac3].imx11 = 0) AND (g_imx[l_ac3].imx12 IS NULL OR g_imx[l_ac3].imx12 = 0) AND
     (g_imx[l_ac3].imx13 IS NULL OR g_imx[l_ac3].imx13 = 0) AND (g_imx[l_ac3].imx14 IS NULL OR g_imx[l_ac3].imx14 = 0) AND
     (g_imx[l_ac3].imx15 IS NULL OR g_imx[l_ac3].imx15 = 0)  THEN
      RETURN TRUE
  END IF

  LET l_n=0
  SELECT COUNT(*) INTO l_n FROM pmn_file,pmni_file,imx_file
   WHERE pmn01=g_rvbslk[l_ac2].rvbslk04
     AND pmn01=pmni01
     AND pmn02=pmni02
     AND pmnislk03=g_rvbslk[l_ac2].rvbslk03
     AND imx000=pmn04
     AND imx00=p_item
     AND imx01=g_imx[p_ac].color

  IF l_n=0 OR cl_null(l_n) THEN
     CALL cl_err('','mfg-995',0)
     RETURN FALSE
  END IF
  FOR i=1 TO 15
      IF i=1 THEN LET l_qty=g_imx[l_ac3].imx01 END IF
      IF i=2 THEN LET l_qty=g_imx[l_ac3].imx02 END IF
      IF i=3 THEN LET l_qty=g_imx[l_ac3].imx03 END IF
      IF i=4 THEN LET l_qty=g_imx[l_ac3].imx04 END IF
      IF i=5 THEN LET l_qty=g_imx[l_ac3].imx05 END IF
      IF i=6 THEN LET l_qty=g_imx[l_ac3].imx06 END IF
      IF i=7 THEN LET l_qty=g_imx[l_ac3].imx07 END IF
      IF i=8 THEN LET l_qty=g_imx[l_ac3].imx08 END IF
      IF i=9 THEN LET l_qty=g_imx[l_ac3].imx09 END IF
      IF i=10 THEN LET l_qty=g_imx[l_ac3].imx10 END IF
      IF i=11 THEN LET l_qty=g_imx[l_ac3].imx11 END IF
      IF i=12 THEN LET l_qty=g_imx[l_ac3].imx12 END IF
      IF i=13 THEN LET l_qty=g_imx[l_ac3].imx13 END IF
      IF i=14 THEN LET l_qty=g_imx[l_ac3].imx14 END IF
      IF i=15 THEN LET l_qty=g_imx[l_ac3].imx15 END IF
      IF l_qty >0 THEN
         IF NOT t110_check_imx(i,l_qty,g_imx_t.imx01) THEN
            RETURN FALSE
         END IF
      END IF
  END FOR

  RETURN TRUE
END FUNCTION

FUNCTION t110_check_rvb07(l_ima01,p_qty)
   DEFINE l_ima01    LIKE ima_file.ima01,
          p_qty      LIKE rvb_file.rvb07,
          l_rvb07    LIKE rvb_file.rvb07,
          l_rvb07_1  LIKE rvb_file.rvb07,
          l_rvb07_2  LIKE rvb_file.rvb07,
          l_rvb07_3  LIKE rvb_file.rvb07,
          l_alt06    LIKE alt_file.alt06,
          t_alt06    LIKE rvb_file.rvb07,
          l_pmn20    LIKE pmn_file.pmn20,
          l_pmn13    LIKE pmn_file.pmn13,
          l_pmn50_55 LIKE pmn_file.pmn50,
          l_pmn14    LIKE pmn_file.pmn14,
          l_pmn20_50 LIKE pmn_file.pmn20

      IF NOT cl_null(p_qty) AND p_qty > 0 THEN
         SELECT pmn13,(pmn50-pmn55-pmn58),pmn20,(pmn20-pmn50+pmn55),pmn14 INTO 
                l_pmn13,l_pmn50_55,l_pmn20,l_pmn20_50,l_pmn14 
            FROM pmn_file,pmni_file,pmnslk_file
            WHERE pmn01=pmni01 AND pmn02=pmni02 AND pmn01=pmnslk01
              AND pmni01=pmnslk01 AND pmnislk03=pmnslk02
              AND pmnslk01=g_rvbslk[l_ac2].rvbslk04 
              AND pmnslk02=g_rvbslk[l_ac2].rvbslk03
              AND pmnslk04=g_rvbslk[l_ac2].rvbslk05
              AND pmn04=l_ima01
       # IF p_qty > l_pmn20_50 THEN
       #    CALL cl_err(p_qty,'mfg-314',0)
       #    RETURN FALSE  
       # END IF
         IF cl_null(l_pmn13) THEN   #超交率
            LET l_pmn13 = 0
         END IF
         IF cl_null(l_pmn50_55) THEN
            LET l_pmn50_55 = 0
         END IF
         SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file,rvbi_file
          WHERE rvb01=rvbi01 AND rvb02=rvbi02 
            AND rvbi01=rvbslk01 AND rvbislk02=rvbslk02
            AND rvbslk04=g_rvbslk[l_ac2].rvbslk04
            AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
            AND rvbislk02=g_rvbslk[l_ac2].rvbslk02
            AND rvbslk05=g_rvbslk[l_ac2].rvbslk05
            AND rvb05=l_ima01
            AND rvaconf='N'
            AND rva01=rvb01
            AND rvb35='N'
            AND NOT (rvb01=g_rva.rva01 AND rvbslk02=g_rvbslk[l_ac2].rvbslk02)
         IF cl_null(l_rvb07_3) THEN
            LET l_rvb07_3 = 0
         END IF
 
         #計算已交量
         LET l_rvb07=l_pmn50_55+l_rvb07_3+p_qty
         LET l_rvb07_1=(l_pmn20*(100+l_pmn13))/100   #可交貨量
         LET l_rvb07_2=(l_pmn20*(100-l_pmn13))/100   #最少可交貨量
 
 
         # 若為LC收貨，則須檢查數貨不可大於提單數量
         IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
            SELECT alt06 INTO l_alt06 FROM alt_file,rvb_file,rvbi_file,rvbslk_file
             WHERE alt01=rvb22
               AND alt14=rvb04
               AND alt15=rvb03
               AND rvb01=rvbslk01 AND rvb01=rvbi01 AND rvb02=rvbi02
               AND rvbi01=rvbslk01 AND rvbislk02=rvbslk02
               AND rvbslk04=g_rvbslk[l_ac2].rvbslk04
               AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
               AND rvbslk05=g_rvbslk[l_ac2].rvbslk05
               AND rvb05=l_ima01
            IF cl_null(l_alt06) THEN
               LET l_alt06 = 0
            END IF
            SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file,rvbi_file,rvbslk_file
             WHERE rvb01=rvbslk01 AND rvb01=rvbi01 AND rvb02=rvbi02
               AND rvbi01=rvbslk01 AND rvbislk02=rvbslk02
               AND rvbslk04=g_rvbslk[l_ac2].rvbslk04
               AND rvbslk03=g_rvbslk[l_ac2].rvbslk03
               AND rvbslk05=g_rvbslk[l_ac2].rvbslk05
               AND rvb05=l_ima01
               AND rvb01!=g_rva.rva01
               AND rvb35='N'
            IF cl_null(t_alt06) THEN
               LET t_alt06 = 0
            END IF
            IF p_qty > (l_alt06-t_alt06) THEN
               CALL cl_err('','apm-305',0)
               RETURN FALSE
            END IF
         END IF
 
         IF l_pmn13 >= 0 THEN    #超短交控制
            IF l_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
                IF l_rvb07_2 > l_rvb07 THEN #短交 
                  IF g_sma.sma85 MATCHES '[Rr]' THEN
                     CALL cl_err(l_rvb07_2,'mfg3038',0)
                     RETURN FALSE
                  ELSE
                     CALL cl_err(l_rvb07_2,'mfg9120',1)
                  END IF
               END IF
              ######  樣品不檢查
              #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #委外不檢查超交
               IF g_rva.rva10 != 'SUB' THEN  
                  IF l_rvb07_1 < l_rvb07 THEN #超交
                     IF g_sma.sma85 MATCHES '[Rr]'  THEN
                        CALL cl_err(l_rvb07_1,'mfg3037',1)
                        RETURN FALSE
                     ELSE
                         CALL cl_err(l_rvb07_1,'mfg9121',1) 
                     END IF
                  END IF
               END IF
            END IF
            IF l_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
              ######  樣品不檢查
              #IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN #委外不檢查超交
              IF g_rva.rva10 != 'SUB' THEN #委外不檢查超交
                  IF l_rvb07_1 < l_rvb07 THEN #超交
                     IF g_sma.sma85 MATCHES '[Rr]' THEN
                         CALL cl_err(l_rvb07_1,'mfg3037',1) 
                        RETURN FALSE
                     ELSE
                         CALL cl_err(l_rvb07_1,'mfg9121',1) 
                     END IF
                  END IF
               END IF
            END IF
         END IF
 
         IF l_pmn13 < 0 THEN    #控制超短交
            IF l_pmn14 = 'N' THEN   #不能部份交貨
               IF l_rvb07 - l_pmn20 < 0 THEN      #須>= 訂購量
                  CALL cl_err(l_rvb07,'mfg3335',0)
                  RETURN FALSE
               END IF
            END IF
         END IF
      END IF
      RETURN TRUE
END FUNCTION
#MOD-C30217---end---------------------------

FUNCTION t110_update_rvbslk()
   DEFINE l_sum_rvb07      LIKE rvb_file.rvb07,
          l_sum_rvb88      LIKE rvb_file.rvb88,
          l_sum_rvb88t     LIKE rvb_file.rvb88t,
          l_count          LIKE rvb_file.rvb07

   SELECT SUM(rvb07),SUM(rvb88),SUM(rvb88t)
   INTO l_sum_rvb07,l_sum_rvb88,l_sum_rvb88t
   FROM rvb_file
    WHERE rvb01 = g_rva.rva01
      AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                     WHERE rvb01=rvbi01 AND rvb02=rvbi02
                       AND rvbi01=g_rva.rva01
                       AND rvbislk01=g_rvbslk[l_ac2].rvbslk05
                       AND rvbislk02=g_rvbslk[l_ac2].rvbslk02)
     AND rvbplant=g_rva.rvaplant
   IF SQLCA.sqlcode OR cl_null(l_sum_rvb07) THEN
      LET l_sum_rvb07 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_sum_rvb88) THEN
      LET l_sum_rvb88 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_sum_rvb88t) THEN
      LET l_sum_rvb88t = 0
   END IF
   LET l_sum_rvb88 = cl_digcut(l_sum_rvb88 , t_azi04)
   LET l_sum_rvb88t = cl_digcut(l_sum_rvb88t , t_azi04) 
   UPDATE rvbslk_file SET rvbslk07 = l_sum_rvb07,
                          rvbslk88 = l_sum_rvb88,
                          rvbslk88t= l_sum_rvb88t
    WHERE rvbslk02 = g_rvbslk[l_ac2].rvbslk02 AND rvbslkplant=g_rva.rvaplant
      AND rvbslk01 = g_rva.rva01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rvbslk_file",g_rva.rva01,g_rvbslk[l_ac2].rvbslk02,STATUS,"","x_upd rvbslk",1)
      LET g_success = 'N'
   END IF
   LET g_rvbslk[l_ac2].rvbslk07 = l_sum_rvb07
   LET g_rvbslk[l_ac2].rvbslk88 = l_sum_rvb88
   LET g_rvbslk[l_ac2].rvbslk88t= l_sum_rvb88t
   SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
   DISPLAY l_count TO FORMONLY.qty
END FUNCTION

FUNCTION t110_rvbslk_move()
DEFINE   l_ima491    LIKE ima_file.ima491

   LET g_rvb_slk.rvb03 = g_rvbslk[l_ac2].rvbslk03
   LET g_rvb_slk.rvb04 = g_rvbslk[l_ac2].rvbslk04
   LET g_rvb_slk.rvb06 = 0
   LET g_rvb_slk.rvb07 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb08 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb09 = 0
   LET g_rvb_slk.rvb10 = g_rvbslk[l_ac2].rvbslk10
   LET g_rvb_slk.rvb10t= g_rvbslk[l_ac2].rvbslk10t
   LET g_rvb_slk.rvb11 = 0
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
   IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
   IF l_ima491 > 0 THEN					
      CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb_slk.rvb12					
   ELSE					
      IF cl_null(g_rvb_slk.rvb12) THEN					
         LET g_rvb_slk.rvb12 = g_rva.rva06					
      END IF					
   END IF					
   LET g_rvb_slk.rvb18 = '10'
   LET g_rvb_slk.rvb19 = '1'
   LET g_rvb_slk.rvb29 = g_rvbslk[l_ac2].rvbslk29
   LET g_rvb_slk.rvb30 = g_rvbslk[l_ac2].rvbslk30
   LET g_rvb_slk.rvb31 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb32 = 0
   LET g_rvb_slk.rvb33 = 0 
   LET g_rvb_slk.rvb35 = 'N'
   LET g_rvb_slk.rvb36 = g_rvbslk[l_ac2].rvbslk36
   LET g_rvb_slk.rvb37 = g_rvbslk[l_ac2].rvbslk37
   LET g_rvb_slk.rvb38 = g_rvbslk[l_ac2].rvbslk38
   CALL t110_get_rvb39(g_rvbslk[l_ac2].rvbslk03,g_rvbslk[l_ac2].rvbslk04,
       g_rvbslk[l_ac2].rvbslk05,g_rvb_slk.rvb19,g_rva.rva05,g_sma.sma886)
        RETURNING g_rvb_slk.rvb39
   LET g_rvb_slk.rvb80 = g_rvbslk[l_ac2].rvbslk90
   LET g_rvb_slk.rvb81 = 1
   LET g_rvb_slk.rvb82 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb83 = g_rvbslk[l_ac2].rvbslk90
   LET g_rvb_slk.rvb84 = 1
   LET g_rvb_slk.rvb85 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb86 = g_rvbslk[l_ac2].rvbslk90
   LET g_rvb_slk.rvb87 = g_rvbslk[l_ac2].rvbslk07
   LET g_rvb_slk.rvb88 = g_rvbslk[l_ac2].rvbslk88
   LET g_rvb_slk.rvb88t= g_rvbslk[l_ac2].rvbslk88t
   LET g_rvb_slk.rvb89 = 'N'
   LET g_rvb_slk.rvb90_fac = '1'
   LET g_rvb_slk.rvb930= g_rvbslk[l_ac2].rvbslk930
   LET g_rvb_slk.rvb90 = g_rvbslk[l_ac2].rvbslk90
   LET g_rvb_slk.rvb42 = g_rvbslk[l_ac2].rvbslk42
   LET g_rvb_slk.rvb43 = g_rvbslk[l_ac2].rvbslk43
   LET g_rvb_slk.rvb44 = g_rvb44
   LET g_rvb_slk.rvb45 = g_rvb45
   LET g_rvb_slk.rvbplant  = g_plant
   LET g_rvb_slk.rvblegal  = g_legal

   LET g_rvbi_slk.rvbiplant= g_plant
   LET g_rvbi_slk.rvbilegal= g_legal
END FUNCTION

FUNCTION t110_ins_rvb_b()        #自動由採購單產生收料單
   DEFINE l_pmh08  LIKE pmh_file.pmh08
   DEFINE l_pmm22  LIKE pmm_file.pmm22
   DEFINE l_rvb07s LIKE rvb_file.rvb07
   DEFINE l_ima491 LIKE ima_file.ima491
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_sfb39  LIKE sfb_file.sfb39
   DEFINE l_pmn122 LIKE pmn_file.pmn122
   DEFINE l_ima906 LIKE ima_file.ima906   
   DEFINE l_pmn88  LIKE pmn_file.pmn88    
   DEFINE l_pmn88t LIKE pmn_file.pmn88t   
   DEFINE l_rvb82  LIKE rvb_file.rvb82    
   DEFINE l_rvb85  LIKE rvb_file.rvb85    
   DEFINE i        LIKE type_file.num5    
   DEFINE l_pmn65  LIKE pmn_file.pmn65
   DEFINE l_msg    LIKE type_file.chr1000 
   DEFINE l_pmm    RECORD LIKE pmm_file.* 
   DEFINE l_pmn    RECORD LIKE pmn_file.* 
   DEFINE l_rvb87_o LIKE rvb_file.rvb87   
   DEFINE l_rvb07_s LIKE rvb_file.rvb07   
   DEFINE l_rvb87_s LIKE rvb_file.rvb87   
   DEFINE l_pmm02   LIKE pmm_file.pmm02   
   DEFINE l_type    LIKE type_file.chr1   
   DEFINE l_pmn41   LIKE pmn_file.pmn41   
   DEFINE l_pmn43   LIKE pmn_file.pmn43   
   DEFINE l_ecm04   LIKE ecm_file.ecm04   
   DEFINE l_pmni   RECORD LIKE pmni_file.*

   DEFINE l_pmn18   LIKE pmn_file.pmn18   
   DEFINE l_pmn012   LIKE pmn_file.pmn012 
   DEFINE l_sfb24   LIKE sfb_file.sfb24   
   DEFINE l_pmc915  LIKE pmc_file.pmc915  
   DEFINE l_pmc916  LIKE pmc_file.pmc916  
   DEFINE l_times   LIKE type_file.num5   
   DEFINE l_n       LIKE type_file.num5   
   DEFINE l_n1,l_n2 LIKE type_file.num5   
   DEFINE l_rtz07   LIKE rtz_file.rtz07   
   DEFINE l_rtz08   LIKE rtz_file.rtz08   
   DEFINE l_sma135  LIKE sma_file.sma135  
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_fac     LIKE rvb_file.rvb90_fac

   IF (g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR g_rvbslk_t.rvbslk04 IS NULL) OR
      (g_rvbslk[l_ac2].rvbslk03 != g_rvbslk_t.rvbslk03 OR g_rvbslk_t.rvbslk03 IS NULL) THEN
      DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01 AND rvbplant = g_plant
                        AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                                       WHERE rvb01 = rvbi01
                                         AND rvb02 = rvbi02
                                         AND rvbi01= g_rva.rva01
                                         AND rvbislk02=g_rvbslk[l_ac2].rvbslk02 )
      IF SQLCA.sqlcode THEN
         ROLLBACK WORK
         LET g_success = 'N'
      END IF
      DELETE FROM rvbi_file WHERE rvbi01 = g_rva.rva01
                              AND rvbislk02 = g_rvbslk[l_ac2].rvbslk02
      IF SQLCA.sqlcode THEN
         ROLLBACK WORK
         LET g_success = 'N'
      END IF
   END IF
   LET g_rec_b = 0
   IF g_rva.rva01 IS NULL THEN RETURN END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   LET g_sql = "SELECT pmn_file.* FROM pmn_file,pmni_file ",
               " WHERE pmn01 = pmni01 AND pmn02 = pmni02 ",
               "   AND pmn01 = '",g_rvbslk[l_ac2].rvbslk04,"'",
               "   AND pmnislk03 = '",g_rvbslk[l_ac2].rvbslk03,"'"  
   PREPARE t110_rvb_b_p1 FROM g_sql
   DECLARE t110_rvb_b_c1 CURSOR WITH HOLD FOR t110_rvb_b_p1
 
   LET l_ac = 1
 
   FOREACH t110_rvb_b_c1 INTO l_pmn.*
      IF SQLCA.SQLCODE THEN CALL cl_err('for pmn',SQLCA.SQLCODE,1) EXIT FOREACH END IF      
      IF g_azw.azw04='2' THEN
         IF l_pmm.pmm51 != g_rva.rva29 THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      LET g_rvb[l_ac].rvb22=null
      INITIALIZE g_rvb2.* TO NULL
      INITIALIZE g_rvbi2.* TO NULL  
      LET g_rvb[l_ac].rvb04     = l_pmn.pmn01
      LET g_rvb[l_ac].rvb03     = l_pmn.pmn02
      LET g_rvb[l_ac].rvb34     = l_pmn.pmn41
      LET g_rvb[l_ac].rvb05     = l_pmn.pmn04
      LET g_rvb[l_ac].rvb051    = l_pmn.pmn041     
      LET g_rvb[l_ac].rvb05a    = l_pmn.pmn04      
      LET g_rvb[l_ac].rvb05b    = l_pmn.pmn041      
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07          
      LET g_rvb[l_ac].pmn20     = l_pmn.pmn20
      LET g_rvb[l_ac].pmn50_55  = l_pmn.pmn50-l_pmn.pmn55
      LET g_rvb[l_ac].rvb30     = 0
      LET g_rvb[l_ac].rvb29     = 0
      LET g_rvb[l_ac].rvb89     = l_pmn.pmn89       
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07      
      LET g_rvb[l_ac].rvb35     = 'N'
      LET g_rvb[l_ac].rvb07     = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55+l_pmn.pmn58   
      LET g_rvb[l_ac].rvb83     = l_pmn.pmn83
      LET g_rvb[l_ac].rvb84     = l_pmn.pmn84
      LET g_rvb[l_ac].rvb85     = l_pmn.pmn85
      LET g_rvb[l_ac].rvb80     = l_pmn.pmn80
      LET g_rvb[l_ac].rvb81     = l_pmn.pmn81
      LET g_rvb[l_ac].rvb82     = l_pmn.pmn82
      LET g_rvb[l_ac].rvb86     = l_pmn.pmn86
      LET g_rvb[l_ac].rvb87     = l_pmn.pmn87
      LET g_rvb[l_ac].rvb10     = l_pmn.pmn31
      LET g_rvb[l_ac].rvb10t    = l_pmn.pmn31t
      LET g_rvb[l_ac].rvb919    = l_pmn.pmn919   
      LET g_rvb[l_ac].rvb90     = l_pmn.pmn07    
      IF g_rvb[l_ac].rvb89 ='Y' THEN
         SELECT pmc915,pmc916 INTO l_pmc915,l_pmc916
           FROM pmc_file
          WHERE pmc01 = g_rva.rva05
         LET g_rvb[l_ac].rvb36     = l_pmc915
         LET g_rvb[l_ac].rvb37     = l_pmc916
      ELSE
         LET g_rvb[l_ac].rvb36     = l_pmn.pmn52
         LET g_rvb[l_ac].rvb37     = l_pmn.pmn54
      END IF
      LET g_rvb[l_ac].rvb38     = l_pmn.pmn56
      LET g_rvb[l_ac].rvb25     = l_pmn.pmn71
      SELECT pmm43 INTO g_rvb[l_ac].pmm43 FROM pmm_file 
        WHERE pmm01 = g_rva.rva02
      LET g_rvb[l_ac].rvb930    = l_pmn.pmn930
      
      LET l_pmn122 = l_pmn.pmn122
      LET l_pmn65  = l_pmn.pmn65 
      LET l_pmn88  = l_pmn.pmn88 
      LET l_pmn88t = l_pmn.pmn88t      
      IF g_azw.azw04='2' THEN
         SELECT sma135 INTO l_sma135 FROM sma_file
         IF l_sma135 = 'Y' THEN
            LET l_pmn88 = g_rvb[l_ac].rvb10
            LET l_pmn88t = g_rvb[l_ac].rvb10t
            LET g_rvb2.rvb42 = g_rvb[l_ac].rvb42
            LET g_rvb2.rvb43 = g_rvb[l_ac].rvb43
         ELSE
            LET g_rvb2.rvb42 = l_pmn.pmn73
            LET g_rvb2.rvb43 = l_pmn.pmn74
         END IF
         #SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = g_rva.rvaplant #MOD-B30598  #FUN-C90049 mark
         CALL s_get_coststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07 #FUN-C90049 add

         IF g_azw.azw04 = '2' AND (g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')) THEN  #FUN-B60150 ADD
            #FUN-C90049 mark begin---
            #SELECT rtz08 INTO l_rtz07 FROM rtz_file
            # WHERE rtz01 = g_rva.rvaplant
            #FUN-C90049 mark end-----
            CALL s_get_noncoststore(g_rva.rvaplant,'') RETURNING l_rtz07 #FUN-C90049 add

            IF NOT cl_null(l_rtz07) THEN
               LET g_rvb2.rvb36 = l_rtz07
               LET g_rvb2.rvb37 = ' '
               LET g_rvb2.rvb38 = ' '
            END IF
         END IF
         IF NOT cl_null(l_rtz07) THEN 
            LET g_rvb[l_ac].rvb36 = l_rtz07 
         END IF 
         IF g_rvb[l_ac].rvb36 IS NULL THEN
            CONTINUE FOREACH
         END IF
      ELSE
         LET g_rvb2.rvb42 = '4'    #FUN-9C0075 ADD
      END IF
      IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '4' END IF   #FUN-9C0075 ADD
      LET l_rvb07s=0

         SELECT SUM(rvb07)  INTO l_rvb07s FROM rva_file,rvb_file
          WHERE rvb04=g_rvb[l_ac].rvb04 AND rvb03=g_rvb[l_ac].rvb03
            AND rvb05 = g_rvb[l_ac].rvb05  
            AND rva01=rvb01 AND rvaconf='N' AND rvb35='N'
         IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
         LET g_rvb2.rvb07=g_rvb[l_ac].rvb07-l_rvb07s
      IF g_rvb2.rvb07 <=0 THEN
         #實收數量為零的資料不用再產生
         CONTINUE FOREACH
      END IF
      LET g_rvb[l_ac].rvb07 = g_rvb2.rvb07   #MOD-970207
 
      LET l_rvb07_s = 0  
      LET l_rvb87_s = 0
      SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file
        WHERE rvb04=g_rvb[l_ac].rvb04
          AND rvb03=g_rvb[l_ac].rvb03
          AND rvb05 = g_rvb[l_ac].rvb05
          AND (rvb01<>g_rva.rva01 OR
          (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
      IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
      IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
      IF (l_rvb07_s+g_rvb2.rvb07) = g_rvb[l_ac].pmn20 THEN
         LET l_rvb87_o = l_pmn.pmn87 - l_rvb87_s   #MOD-AB0145
      END IF
 
      IF l_ac > g_sma.sma110 THEN
         #xxxx筆==>收貨單身儲存最大筆數,其餘資料請再開一張收貨單
         CALL cl_err(g_sma.sma110,'apm-125',0)
         EXIT FOREACH
      END IF
      SELECT max(rvb02)+1 INTO g_rvb[l_ac].rvb02 FROM rvb_file
       WHERE rvb01 = g_rva.rva01
      IF g_rvb[l_ac].rvb02 IS NULL THEN LET g_rvb[l_ac].rvb02 = 1 END IF
     ##採購單有輸入專案代號則批號用來記錄專案代號之值
      LET g_rvb2.rvb01=g_rva.rva01
      LET g_rvb2.rvb02=g_rvb[l_ac].rvb02
      LET g_rvb2.rvb03=g_rvb[l_ac].rvb03
      LET g_rvb2.rvb04=g_rvb[l_ac].rvb04
      LET g_rvb2.rvb05=g_rvb[l_ac].rvb05     #料號
      LET g_rvb2.rvb051=g_rvb[l_ac].rvb051
      LET g_rvb2.rvb36=g_rvb[l_ac].rvb36     #倉庫
      LET g_rvb2.rvb37=g_rvb[l_ac].rvb37     #儲位
      LET g_rvb2.rvb38=g_rvb[l_ac].rvb38     #批號
      LET g_rvb2.rvb90=g_rvb[l_ac].rvb90    
      LET l_pmh08 = NULL
      SELECT COUNT(*) INTO l_n1  #非本收货单上数量
         FROM rvb_file,rva_file
        WHERE rvb04 = g_rvb[l_ac].rvb04
          AND rvb03 = g_rvb[l_ac].rvb03
          AND rva01 = rvb01
          AND rva01 != g_rva.rva01
          AND rvaconf <> 'X'
      SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
         FROM rvb_file,rva_file
        WHERE rvb04 = g_rvb[l_ac].rvb04
          AND rvb03 = g_rvb[l_ac].rvb03
          AND rva01 = rvb01
          AND rva01 = g_rva.rva01
          AND rvb02 != g_rvb[l_ac].rvb02
          AND rvaconf <> 'X'
      LET l_n = l_n1 + l_n2
 
      SELECT sma134 INTO l_times FROM sma_file
      IF l_n >= l_times THEN                       
         INITIALIZE g_rvb[l_ac].* TO NULL
         CONTINUE FOREACH
      END IF
      IF cl_null(g_rvb2.rvb36) THEN
         SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   
          WHERE pmm01=g_rvb[l_ac].rvb04
        SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file  
         WHERE pmn01 = g_rvb[l_ac].rvb04 AND pmn02 = g_rvb[l_ac].rvb03          
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
                    AND sgm012 = l_pmn012              
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
                    AND ecm012=l_pmn012                
              END IF
           END IF  
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF
         SELECT pmh08 INTO l_pmh08 FROM pmh_file            #判斷是否可直接入庫
          WHERE pmh01=g_rvb[l_ac].rvb05 AND pmh02=g_rva.rva05
            AND pmh13=l_pmm22
            AND pmh21= l_ecm04   
            AND pmh22= l_type    
            AND pmh23 = ' '      
            AND pmhacti = 'Y'                                          
         IF STATUS THEN LET l_pmh08=NULL END IF    
         IF l_pmh08 IS NOT NULL AND g_rvb2.rvb05[1,4]!='MISC' THEN
            SELECT ima35,ima36 INTO g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
            FROM ima_file
            WHERE ima01=g_rvb[l_ac].rvb05
            IF g_azw.azw04='2' THEN
               #FUN-C90049 mark begin---
               #SELECT rtz07 INTO l_rtz07 FROM rtz_file 
               #    WHERE rtz01 = g_rva.rvaplant
               #FUN-C90049 mark end---
               CALL s_get_coststore( g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07    #FUN-C90049 add
               IF g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2') THEN
                  #FUN-C90049 mark begin--- 
                  #SELECT rtz08 INTO l_rtz07 FROM rtz_file
                  # WHERE rtz01 = g_rva.rvaplant
                  #FUN-C90049 mark end-----
                   CALL s_get_noncoststore( g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07    #FUN-C90049 add
               END IF
               IF NOT cl_null(l_rtz07) THEN
                  LET g_rvb[l_ac].rvb36 = l_rtz07
               END IF 
            END IF
            LET g_rvb2.rvb36=g_rvb[l_ac].rvb36
            LET g_rvb2.rvb37=g_rvb[l_ac].rvb37
         END IF
      END IF
      IF g_rvb2.rvb05[1,4]='MISC' THEN
         LET g_rvb2.rvb35=NULL LET g_rvb[l_ac].rvb35=NULL
         LET g_rvb2.rvb36=NULL LET g_rvb[l_ac].rvb36=NULL
         LET g_rvb2.rvb37=NULL LET g_rvb[l_ac].rvb37=NULL
      END IF
      LET g_rvb2.rvb06=0
      IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN  
         LET g_rvb2.rvb08=g_rvb2.rvb07
      END IF   
      IF g_sma.sma115 = 'Y' THEN
         LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
         LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
         LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
         LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
         LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
         LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85  
         SELECT SUM(rvb82),SUM(rvb85) INTO l_rvb82,l_rvb85 FROM rvb_file,rva_file
          WHERE rvb04 = g_rvb[l_ac].rvb04
            AND rvb03 = g_rvb[l_ac].rvb03
            AND rva01 = rvb01
            AND rvaconf <> 'X'   
            AND rvb35 = 'N'   
         IF NOT cl_null(l_rvb82) AND l_rvb82 > 0 THEN
            LET g_rvb2.rvb82 =g_rvb[l_ac].rvb82 - l_rvb82
            LET g_rvb[l_ac].rvb82 = g_rvb2.rvb82
         END IF
         IF NOT cl_null(l_rvb85) AND l_rvb85 > 0 THEN
            LET g_rvb2.rvb85 =g_rvb[l_ac].rvb85 - l_rvb85
            LET g_rvb[l_ac].rvb85 = g_rvb2.rvb85
         END IF
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_rvb2.rvb05
         IF cl_null(l_ima906) OR l_ima906 = '1' THEN
            LET g_rvb2.rvb80=g_rvb[l_ac].rvb90
            LET g_rvb2.rvb82=g_rvb2.rvb07
            LET g_rvb[l_ac].rvb80 = g_rvb2.rvb80
            LET g_rvb[l_ac].rvb82 = g_rvb2.rvb82
         END IF
      END IF
      IF cl_null(g_rvb[l_ac].rvb86) THEN
         LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90
         LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
         LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
         LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      END IF
      CALL t110_set_rvb87()    
      IF g_sma.sma116 MATCHES '[02]' THEN
         LET g_rvb[l_ac].rvb87 = g_rvb2.rvb07
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN
         IF NOT cl_null(l_rvb87_o) AND l_rvb87_o <> 0 THEN   
            LET g_rvb[l_ac].rvb87 = l_rvb87_o
         END IF    
      END IF
      LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
      LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      LET g_rvb2.rvb09=0
      LET g_rvb2.rvb10=g_rvb[l_ac].rvb10
      LET g_rvb2.rvb10t=g_rvb[l_ac].rvb10t          
      LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
      LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
      SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   
       WHERE gec01 = pmm21
         AND pmm01 = g_rvb2.rvb04
      SELECT azi04 INTO t_azi04 
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01=g_rvb2.rvb04
      LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)    
      LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)     
     #IF g_gec07='Y' THEN
     #   IF g_gec05 = 'T' THEN
     #      LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rvb[l_ac].pmm43/100)
     #      LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
     #   ELSE
     #      LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
     #      LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
     #   END IF
     #ELSE
     #   LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
     #   LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
     #END IF
      LET g_rvb2.rvb11=0
      SELECT ima491 INTO l_ima491 FROM ima_file
       WHERE ima01 = g_rvb2.rvb05
      IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
      IF l_ima491 > 0 THEN
         CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb2.rvb12
      ELSE
         IF cl_null(g_rvb2.rvb12) THEN
            LET g_rvb2.rvb12 = g_rva.rva06
         END IF
      END IF
      LET g_rvb2.rvb13=NULL
      LET g_rvb2.rvb14=NULL
      LET g_rvb2.rvb15=0
      LET g_rvb2.rvb16=0
      LET g_rvb2.rvb17=NULL
      LET g_rvb2.rvb18='10'
      LET g_rvb2.rvb19=l_pmn65  
      LET g_rvb2.rvb20=NULL
      LET g_rvb2.rvb21=NULL
      LET g_rvb2.rvb22=g_rvb[l_ac].rvb22
      LET g_rvb2.rvb25=g_rvb[l_ac].rvb25
      LET g_rvb2.rvb26=NULL
      LET g_rvb2.rvb27=0
      LET g_rvb2.rvb28=0
      LET g_rvb2.rvb29=0
      LET g_rvb2.rvb30=0
      LET g_rvb2.rvb31=0                 
      LET g_rvb2.rvb32=0
      LET g_rvb2.rvb33=0
      LET g_rvb2.rvb331=0
      LET g_rvb2.rvb332=0
      LET g_rvb2.rvb34=g_rvb[l_ac].rvb34
      LET g_rvb2.rvb35='N'
      LET g_rvb2.rvb40= ''  
      LET g_rvb2.rvb930=g_rvb[l_ac].rvb930
      CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a 
      IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
      IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
      IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
      LET g_rvb2.rvb44 = l_pmn.pmn75                                                                                   
      LET g_rvb2.rvb45 = l_pmn.pmn76 
      LET g_rvb2.rvb90 = l_pmn.pmn07      
      LET g_rvb2.rvbplant = g_rva.rvaplant                                                                                  
      LET g_rvb2.rvblegal = g_rva.rvalegal                                                                                  
       CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)  
               RETURNING g_rvb2.rvb39 
      LET l_ec_sw = 'N'
      IF g_argv2 ='SUB' THEN
         LET l_sfb24=''
         SELECT sfb24 INTO l_sfb24
          FROM sfb_file
          WHERE sfb01 = g_rvb2.rvb34
         IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
            LET l_ec_sw='Y'
         END IF
         IF l_ec_sw='Y' THEN
            LET g_rvb2.rvb36=' '
            LET g_rvb2.rvb37=' '
            LET g_rvb2.rvb38=' '
         END IF
      END IF
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_rvb2.rvb05
      CALL s_umfchk(g_rvb2.rvb05,g_rvb2.rvb90,l_ima25)
           RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL cl_err(g_rvb2.rvb90,'mfg7003',1)
         LET g_rvb2.rvb90_fac = 1
      ELSE
         LET g_rvb2.rvb90_fac = l_fac
      END IF
      LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90    
      LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89   
 
      LET g_rvb2.rvbplant = g_plant 
      LET g_rvb2.rvblegal = g_legal 
      IF cl_null(g_rvb2.rvb08) THEN LET g_rvb2.rvb08 = 0 END IF   
      LET g_rvb2.rvb919 = g_rvb[l_ac].rvb919
      LET g_rvb2.rvb90  = g_rvb[l_ac].rvb90 
      INSERT INTO rvb_file VALUES(g_rvb2.*)
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK
         LET g_success = 'N'
         EXIT FOREACH
      ELSE
         LET g_rvbi2.rvbi01 = g_rvb2.rvb01
         LET g_rvbi2.rvbi02 = g_rvb2.rvb02
         LET g_rvbi2.rvbislk01 = g_rvbslk[l_ac2].rvbslk05
         LET g_rvbi2.rvbislk02 = g_rvbslk[l_ac2].rvbslk02
         LET g_rvbi2.rvbiplant = g_rva.rvaplant                                                                                  
         LET g_rvbi2.rvbilegal = g_rva.rvalegal
         INSERT INTO rvbi_file VALUES(g_rvbi2.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbi_file",g_rvbi2.rvbi01,g_rvbi2.rvbi02,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         SELECT COUNT(*) INTO l_n FROM img_file
          WHERE img01 = g_rvb2.rvb05
            AND img02 = g_rvb2.rvb36
            AND img03 = g_rvb2.rvb37
            AND img04 = g_rvb2.rvb38
         IF l_n = 0 AND (g_rvb[l_ac].rvb36 IS NOT NULL
                         AND g_rvb[l_ac].rvb36 <> ' ') AND l_ec_sw = 'N' THEN   
               CALL s_add_img(g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                                 g_rvb2.rvb38,g_rva.rva01,g_rvb2.rvb02,
                                 g_rva.rva06)
         END IF
      END IF
      SELECT SUM(rvb07),SUM(rvb88),SUM(rvb88t)
        INTO g_rvbslk[l_ac2].rvbslk07,g_rvbslk[l_ac2].rvbslk88,g_rvbslk[l_ac2].rvbslk88t
        FROM rvb_file
         WHERE rvb01 = g_rva.rva01
           AND rvb02 IN (SELECT rvb02 FROM rvb_file,rvbi_file
                          WHERE rvb01=rvbi01 AND rvb02=rvbi02
                            AND rvbi01=g_rva.rva01
                            AND rvbislk02=g_rvbslk[l_ac2].rvbslk02)
          AND rvbplant=g_rva.rvaplant 
      LET g_rvbslk[l_ac2].rvbslk88 = cl_digcut(g_rvbslk[l_ac2].rvbslk88 , t_azi04)
      LET g_rvbslk[l_ac2].rvbslk88t = cl_digcut(g_rvbslk[l_ac2].rvbslk88t , t_azi04)
      LET l_ac = l_ac + 1
   END FOREACH
 
   CALL g_rvb.deleteElement(l_ac)
   LET l_ac=l_ac - 1
 
   CALL t110_b_fill(' 1=1',' 1=1')   #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
 
END FUNCTION

FUNCTION t110_g_bslk()   #自動產生款號單身
  DEFINE l_rvbslk  RECORD  LIKE rvbslk_file.*
  DEFINE l_rvb02           LIKE rvb_file.rvb02
  DEFINE l_rvb04           LIKE rvb_file.rvb04
  DEFINE l_pmnslk  RECORD  LIKE pmnslk_file.*

   CALL g_rvbslk.clear()
   CALL g_imx.clear()  
  
   DECLARE t110_g_rvbslk CURSOR FOR SELECT * FROM pmnslk_file WHERE pmnslk01 = g_rva.rva02 ORDER BY pmnslk02
   FOREACH t110_g_rvbslk INTO l_pmnslk.*
      LET l_rvbslk.rvbslk01=g_rva.rva01
      SELECT MAX(rvbslk02)+1 INTO l_rvbslk.rvbslk02 FROM rvbslk_file WHERE rvbslk01=g_rva.rva01
      IF cl_null(l_rvbslk.rvbslk02) THEN
         LET l_rvbslk.rvbslk02=1
      END IF
      
      SELECT SUM(rvb07),SUM(rvb29),SUM(rvb30),SUM(rvb88),SUM(rvb88t) INTO l_rvbslk.rvbslk07,
          l_rvbslk.rvbslk29,l_rvbslk.rvbslk30,l_rvbslk.rvbslk88,l_rvbslk.rvbslk88t FROM rvb_file
        WHERE rvb01 = l_rvbslk.rvbslk01 AND rvb04 = l_pmnslk.pmnslk01
          AND rvb03 IN ( SELECT pmn02 FROM pmn_file,pmni_file WHERE pmn01 = pmni01
                                                                AND pmn02 = pmni02
                                                                AND pmn01 = l_pmnslk.pmnslk01
                                                                AND pmnislk03 = l_pmnslk.pmnslk02)

      IF cl_null(l_rvbslk.rvbslk07) THEN
         CONTINUE FOREACH
      END IF
      IF cl_null(l_rvbslk.rvbslk88) THEN
         LET l_rvbslk.rvbslk88 = 0
      END IF
      IF cl_null(l_rvbslk.rvbslk88t) THEN
         LET l_rvbslk.rvbslk88t = 0
      END IF
      LET l_rvbslk.rvbslk88 = cl_digcut(l_rvbslk.rvbslk88 , t_azi04)       
      LET l_rvbslk.rvbslk88t = cl_digcut(l_rvbslk.rvbslk88t , t_azi04) 
      LET l_rvbslk.rvbslk03 = l_pmnslk.pmnslk02
      LET l_rvbslk.rvbslk04 = l_pmnslk.pmnslk01
      LET l_rvbslk.rvbslk05 = l_pmnslk.pmnslk04
      LET l_rvbslk.rvbslk051= l_pmnslk.pmnslk041
      LET l_rvbslk.rvbslk10 = l_pmnslk.pmnslk31
      LET l_rvbslk.rvbslk10t= l_pmnslk.pmnslk31t
      LET l_rvbslk.rvbslk36 = l_pmnslk.pmnslk52
      LET l_rvbslk.rvbslk37 = l_pmnslk.pmnslk54
      LET l_rvbslk.rvbslk38 = l_pmnslk.pmnslk56
      LET l_rvbslk.rvbslk90 = l_pmnslk.pmnslk07
      LET l_rvbslk.rvbslk42 = l_pmnslk.pmnslk73
      LET l_rvbslk.rvbslk43 = l_pmnslk.pmnslk74
      LET l_rvbslk.rvbslkplant = g_rva.rvaplant
      LET l_rvbslk.rvbslklegal = g_rva.rvalegal 
     INSERT INTO rvbslk_file VALUES(l_rvbslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","rvbslk_file","","",SQLCA.sqlcode,"","ins rvbslk",1)
         EXIT FOREACH
      ELSE
         UPDATE rvbi_file SET rvbislk01=l_rvbslk.rvbslk05,
                              rvbislk02=l_rvbslk.rvbslk02
           WHERE rvbi01=g_rva.rva01
             AND rvbi02 IN (SELECT rvb02 FROM rvb_file
                             WHERE rvb01=g_rva.rva01
                               AND rvb04=l_rvbslk.rvbslk04
                               AND rvb03 IN ( SELECT pmn02 FROM pmn_file,pmni_file WHERE pmn01 = pmni01
                                                                AND pmn02 = pmni02
                                                                AND pmn01 = l_pmnslk.pmnslk01
                                                                AND pmnislk03 = l_pmnslk.pmnslk02))
         IF STATUS THEN
            CALL cl_err3("upd","rvb_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
   CALL t110_b_fill2(' 1=1',' 1=1')

END FUNCTION
#FUN-B90101--add--end--
#TQC-C20117--add---begin--------------- 將服飾業g_azw.azw04='2' 专门给抽出來
FUNCTION t110_bp_slk(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE l_i        LIKE type_file.num5,
         l_index    LIKE type_file.num5,
         li_a       LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("rvaspc",FALSE)
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_rvbslk TO s_rvbslk.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL g_imx.clear()
            CALL t110_b_fill2(g_wc3,g_wc2)
            LET g_action_choice=""
            LET g_b_flag = '1'       #TQC-D40025

         BEFORE ROW
            CALL cl_set_comp_visible("color",FALSE)
            FOR l_i = 1 TO 15
                LET l_index = l_i USING '&&'
                CALL cl_set_comp_visible("imx" || l_index,FALSE)
            END FOR
            LET l_ac2 = DIALOG.getCurrentRow("s_rvbslk")
            IF l_ac2 != 0 THEN
               CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
               CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
                                   g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
               LET g_rec_b3 = g_imx.getLength()
            END IF
      END DISPLAY

      DISPLAY ARRAY g_imx TO s_imx.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_action_choice=""
            LET g_b_flag = '2'       #TQC-D40025

         BEFORE ROW
            LET l_ac3 = DIALOG.getCurrentRow("s_imx")
            CALL cl_show_fld_cont()
      END DISPLAY

      DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

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

      #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
      #FUN-CB0014---add---end---
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
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST

      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
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

      ON ACTION qc
         LET g_action_choice="qc"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t110_mu_ui()   #TQC-710032
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         #CKP
        #FUN-C30140--mod---str---
        #IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
         CALL t110_pic()
        #FUN-C30140--mod---end---

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

#@    ON ACTION 補登發票
      ON ACTION add_invoice
         LET g_action_choice="add_invoice"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#FUN-D20025 add
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#FUN-D20025 add           
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 檢驗狀況
      ON ACTION qc_status
         LET g_action_choice="qc_status"
         EXIT DIALOG
#FUN-CC0011 mark begin---
##FUN-BC0104 ------add----str---------------
##@    ON ACTION QC料件判定產生入庫單
#      ON ACTION qc_item_tran_store
#         LET g_action_choice="qc_item_tran_store"
#         EXIT DIALOG
##FUN-BC0104 ------add----end---------------
#FUN-CC0011 mark end---
#@    ON ACTION 產生入庫/驗退
      ON ACTION generate_st_in_qc_return
         IF t110_qc_ck() THEN                                #FUN-CC0011 add
            LET g_action_choice="qc_item_tran_store"         #FUN-CC0011 add
         ELSE                                                #FUN-CC0011 add
            LET g_action_choice="generate_st_in_qc_return"
         END IF                                              #FUN-CC0011 add
         EXIT DIALOG
#@    ON ACTION 查詢入庫
      ON ACTION qry_st_in
         LET g_action_choice="qry_st_in"
         EXIT DIALOG
#@    ON ACTION 查詢驗退
      ON ACTION qry_qc_return
         LET g_action_choice="qry_qc_return"
         EXIT DIALOG
#@    ON ACTION 驗收狀況
      ON ACTION receiving
         LET g_action_choice="receiving"
         EXIT DIALOG

    #FUN-9C0076 add str ---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG
    #FUN-9C0076 add end ---


#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680011
         LET g_action_choice="trans_spc"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION e_proc_require
         LET g_action_choice = 'e_proc_require'
         EXIT DIALOG

     #FUN-9C0076 add str ---
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG
     #FUN-9C0076 add end ---

      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DIALOG

      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DIALOG

      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
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

      ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
         IF li_a THEN
            LET li_a = FALSE
            NEXT FIELD rvbslk05
         ELSE
            LET li_a = TRUE
            NEXT FIELD color
         END IF

      &include "qry_string.4gl"
   END DIALOG
CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#TQC-C20117----end-----------------------------------------------------

FUNCTION t110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
#FUN-B90101--add--begin--
  DEFINE l_i        LIKE type_file.num5,
         l_index    LIKE type_file.num5,
         li_a       LIKE type_file.chr1
#FUN-B90101--add--end-- 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("rvaspc",FALSE)
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
#TQC-C20117--mark-------------begin----------------
#FUN-B90101---Add---Str--
#&ifdef SLK
#     DISPLAY ARRAY g_rvbslk TO s_rvbslk.*
#        BEFORE DISPLAY
#           CALL cl_navigator_setting( g_curs_index, g_row_count )
#           CALL g_imx.clear()
#           CALL t110_b_fill2(g_wc3,g_wc2)
#           LET g_action_choice=""

#        BEFORE ROW
#           CALL cl_set_comp_visible("color",FALSE)
#           FOR l_i = 1 TO 15
#               LET l_index = l_i USING '&&'
#               CALL cl_set_comp_visible("imx" || l_index,FALSE)
#           END FOR
#           LET l_ac2 = DIALOG.getCurrentRow("s_rvbslk")
#           IF l_ac2 != 0 THEN
#              CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
#              CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
#                                  g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
#              LET g_rec_b3 = g_imx.getLength()   
#           END IF
#     END DISPLAY

#     DISPLAY ARRAY g_imx TO s_imx.*
#        BEFORE DISPLAY
#           CALL cl_navigator_setting( g_curs_index, g_row_count )
#           LET g_action_choice=""

#        BEFORE ROW
#           LET l_ac3 = DIALOG.getCurrentRow("s_imx")
#           CALL cl_show_fld_cont()
#     END DISPLAY
#&endif
#TQC-C20117----mark---end-----------------------
#FUN-B90101---Add---End--   
    
      DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont() 

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

      #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
      #FUN-CB0014---add---end---
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
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
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
 
#FUN-A80112 --add
      ON ACTION qc
         LET g_action_choice="qc"
         EXIT DIALOG
#FUN-A80112 --end
#FUN-C30063---add---START
      ON ACTION qry_qc #查詢QC單 
         LET g_action_choice="qry_qc"
         EXIT DIALOG
#FUN-C30063---add---END
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t110_mu_ui()   #TQC-710032
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         #CKP
        #FUN-C30140--mod---str---
        #IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
         CALL t110_pic()
        #FUN-C30140--mod---end---
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

#@    ON ACTION 補登發票
      ON ACTION add_invoice
         LET g_action_choice="add_invoice"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#FUN-D20025 add
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
#FUN-D20025 add           
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 檢驗狀況
      ON ACTION qc_status
         LET g_action_choice="qc_status"
         EXIT DIALOG
#FUN-CC0011 mark begin---
##FUN-BC0104 ------add----str---------------
##@    ON ACTION QC料件判定產生入庫單
#      ON ACTION qc_item_tran_store
#         LET g_action_choice="qc_item_tran_store"
#         EXIT DIALOG
##FUN-BC0104 ------add----end---------------
#FUN-CC0011 mark end-----
#@    ON ACTION 產生入庫/驗退
      ON ACTION generate_st_in_qc_return
         
         IF t110_qc_ck() THEN                                     #FUN-CC0011 add
            LET g_action_choice="qc_item_tran_store"              #FUN-CC0011 add
         ELSE                                                     #FUN-CC0011 add
            LET g_action_choice="generate_st_in_qc_return"
         END IF                                                   #FUN-CC0011 add
         EXIT DIALOG
#@    ON ACTION 查詢入庫
      ON ACTION qry_st_in
         LET g_action_choice="qry_st_in"
         EXIT DIALOG
#@    ON ACTION 查詢驗退
      ON ACTION qry_qc_return
         LET g_action_choice="qry_qc_return"
         EXIT DIALOG
#@    ON ACTION 驗收狀況
      ON ACTION receiving
         LET g_action_choice="receiving"
         EXIT DIALOG

    #FUN-9C0076 add str ---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG
    #FUN-9C0076 add end ---
 
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680011
         LET g_action_choice="trans_spc"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION e_proc_require
         LET g_action_choice = 'e_proc_require'
         EXIT DIALOG

     #FUN-9C0076 add str ---
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG
     #FUN-9C0076 add end ---
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DIALOG
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
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

#TQC-C20117--mark-----begin--------------------------
#FUN-B90101--add--str--
#&ifdef SLK
#     ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
#        IF li_a THEN
#           LET li_a = FALSE
#           NEXT FIELD rvbslk05
#        ELSE
#           LET li_a = TRUE
#           NEXT FIELD color
#        END IF
#&endif 
#FUN-B90101--add--end--
#TQC-C20117--mark----end-----------------------------
      
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark begin-----------------------------
#   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
##FUN-A60035 ---MARK BEGIN
##       #No.FUN-A50054 -BEGIN-----
##        IF NOT s_industry('slk') THEN 
##           CALL cl_set_act_visible("style_detail",FALSE)
##        END IF
##       #No.FUN-A50054 -END-------
##FUN-A60035 ---MARK END
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t110_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#         IF g_rec_b != 0 THEN
#            CALL fgl_set_arr_curr(1)  ######add in 040505
#         END IF
#         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t110_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t110_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t110_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t110_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
##FUN-A80112 --add
#      ON ACTION qc
#         LET g_action_choice="qc"
#         EXIT DISPLAY
##FUN-A80112 --end
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL t110_mu_ui()   #TQC-710032
#         IF g_aza.aza71 MATCHES '[Yy]' THEN
#            CALL aws_gpmcli_toolbar()
#            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
#         ELSE
#            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
#         END IF
#         #CKP
#         IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#         CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
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
##FUN-A60035 ---MARK BEGIN
##   #No.FUN-A50054 -BEGIN-----
##     ON ACTION style_detail
##        LET g_action_choice="style_detail"
##        EXIT DISPLAY
##   #No.FUN-A50054 -END-------
##FUN-A60035 ---MARK END
##@    ON ACTION 補登發票
#      ON ACTION add_invoice
#         LET g_action_choice="add_invoice"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
##@    ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
##@    ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
##@    ON ACTION 檢驗狀況
#      ON ACTION qc_status
#         LET g_action_choice="qc_status"
#         EXIT DISPLAY
##@    ON ACTION 產生入庫/驗退
#      ON ACTION generate_st_in_qc_return
#         LET g_action_choice="generate_st_in_qc_return"
#         EXIT DISPLAY
##@    ON ACTION 查詢入庫
#      ON ACTION qry_st_in
#         LET g_action_choice="qry_st_in"
#         EXIT DISPLAY
##@    ON ACTION 查詢驗退
#      ON ACTION qry_qc_return
#         LET g_action_choice="qry_qc_return"
#         EXIT DISPLAY
##@    ON ACTION 驗收狀況
#      ON ACTION receiving
#         LET g_action_choice="receiving"
#         EXIT DISPLAY
#
#    #FUN-9C0076 add str ---
#    #@ON ACTION 簽核狀況
#      ON ACTION approval_status
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
#
#    #@ON ACTION easyflow送簽
#      ON ACTION easyflow_approval
#         LET g_action_choice = "easyflow_approval"
#         EXIT DISPLAY
#    #FUN-9C0076 add end ---
# 
#&ifdef ICD
##@    ON ACTION 回貨查詢作業                                                    
#      ON ACTION aic_qry_back
#         LET g_action_choice = "aic_qry_back"
#         EXIT DISPLAY
# 
##@    ON ACTION 單據刻號BIN查詢作業
#      ON ACTION aic_s_icdqry
#         LET g_action_choice = "aic_s_icdqry"
#         EXIT DISPLAY
# 
##@    ON ACTION 刻號BIN維護作業
#      ON ACTION aic_s_icdin
#         LET g_action_choice = "aic_s_icdin"
#         EXIT DISPLAY
# 
##@    ON ACTION 刻號BIN入庫否維護作業
#      ON ACTION aic_s_icdin_rec
#         LET g_action_choice = "aic_s_icdin_rec"
#         EXIT DISPLAY
#&endif
# 
##@    ON ACTION 拋轉至SPC
#      ON ACTION trans_spc                      #FUN-680011
#         LET g_action_choice="trans_spc"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#             LET INT_FLAG=FALSE                 #MOD-570244     mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
# 
#      ON ACTION exporttoexcel       #FUN-4B0025
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON ACTION e_proc_require
#         LET g_action_choice = 'e_proc_require'
#         EXIT DISPLAY
#
#     #FUN-9C0076 add str ---
#      ON ACTION agree
#         LET g_action_choice = 'agree'
#         EXIT DISPLAY
#
#      ON ACTION deny
#         LET g_action_choice = 'deny'
#         EXIT DISPLAY
#
#      ON ACTION modify_flow
#         LET g_action_choice = 'modify_flow'
#         EXIT DISPLAY
#
#      ON ACTION withdraw
#         LET g_action_choice = 'withdraw'
#         EXIT DISPLAY
#
#      ON ACTION org_withdraw
#         LET g_action_choice = 'org_withdraw'
#         EXIT DISPLAY
#
#      ON ACTION phrase
#         LET g_action_choice = 'phrase'
#         EXIT DISPLAY
#     #FUN-9C0076 add end ---
#      
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      ON ACTION controls                           #No.FUN-6B0032
#         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
# 
#      ON ACTION related_document                #No.FUN-6A0162  相關文件
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
# 
#      ON ACTION gpm_show
#         LET g_action_choice="gpm_show"
#         EXIT DISPLAY
# 
#      ON ACTION gpm_query
#         LET g_action_choice="gpm_query"
#         EXIT DISPLAY
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      
#      &include "qry_string.4gl"
# 
#   END DISPLAY
#FUN-B30170 mark -end-----------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#FUNCTION t110_x() #FUN-D20025 mark
FUNCTION t110_x(p_type) #FUN-D20025 add
   DEFINE  l_rvb22      LIKE rvb_file.rvb22      #No.MOD-580086
   DEFINE  l_flag       LIKE type_file.num5      #FUN-810038
   DEFINE  l_cnt        LIKE type_file.num5      #MOD-8B0059
   DEFINE l_ebocode     VARCHAR(1)               #FUN-880085
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
   IF g_rva.rva01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rva.rvaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rva.rva32 NOT MATCHES '[0RW9]' THEN RETURN END IF #非開立&作廢    #FUN-9C0076 add
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_rva.rvaconf='X' THEN RETURN END IF
   ELSE
      IF g_rva.rvaconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end 
   BEGIN WORK

   LET g_success='Y'
   LET g_totsuccess = 'Y'    #No.MOD-890074
   OPEN t110_cl USING g_rva.rva01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_rva.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_argv6 ='1' THEN                #FUN-940083--add
      IF g_rva.rvaconf = 'X' THEN 
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM pmm_file
          WHERE pmm01 IN (SELECT rvb04 FROM rvb_file WHERE rvb01 = g_rva.rva01)
            AND pmm25 <> '2' 
         IF l_cnt > 0 THEN
            CALL cl_err('','aap-198',1)
            CLOSE t110_cl
            ROLLBACK WORK
            RETURN 
         END IF
      END IF
   END IF                              #FUN-940083--add 
   IF cl_void(0,0,g_rva.rvaconf) THEN
      LET g_chr=g_rva.rvaconf
      IF g_rva.rvaconf ='N' THEN
         LET g_rva.rvaconf='X'
         LET g_rva.rva32 = '9'   #FUN-9C0076 add
      ELSE
         LET g_rva.rvaconf='N'
         LET g_rva.rva32 = '0'   #FUN-9C0076 add
      END IF
      UPDATE rva_file SET rvaconf = g_rva.rvaconf,
                          rva32 = g_rva.rva32,         #FUN-9C0076 add
                          rvamodu = g_user,
                          rvadate = TODAY
       WHERE rva01 = g_rva.rva01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rva_file",g_rva.rva01,"",STATUS,"","upd rvaconf:",1) #No.FUN-660129
         LET g_success='N'
      ELSE
         DECLARE rvb22_curx CURSOR FOR
          SELECT UNIQUE rvb22
            FROM rvb_file
           WHERE rvb01 = g_rva.rva01
 
         CALL s_showmsg_init()        #No.FUN-710030
         FOREACH rvb22_curx INTO l_rvb22
            IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM rvb_file
             WHERE rvb22 = l_rvb22
               AND rvb01 <> g_rva.rva01
            IF g_cnt = 0 THEN
               DELETE FROM rvw_file
                WHERE rvw01 = l_rvb22
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("rvw01",l_rvb22,"DEL rvw_filee err!",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.SQLCODE,"","DEL rvw_file err!",1)
                  END IF
                  LET g_success ="N"
               END IF
            END IF
         END FOREACH
         #-----MOD-A60162---------
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM rvb_file
           WHERE rvb01 = g_rva.rva01
         IF l_cnt > 0 THEN 
            UPDATE rvb_file SET rvb22 = NULL
              WHERE rvb01 = g_rva.rva01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg("rvb01",g_rva.rva01,"UPDATE rvb_file",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","rva_file",g_rva.rva01,"",STATUS,"","upd rvb22:",1) 
               END IF
               LET g_success='N'
            END IF
         END IF
         #-----END MOD-A60162----- 
         IF g_totsuccess="N" THEN
            LET g_success="N"
         END IF
 
      END IF
   END IF
   CLOSE t110_cl
   CALL s_showmsg()       #No.FUN-710030
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rva.rva01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT rvaconf INTO g_rva.rvaconf FROM rva_file WHERE rva01 = g_rva.rva01
   DISPLAY BY NAME g_rva.rvaconf
   #CKP
  #FUN-C30140--mod---str---
  #IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
  #FUN-C30140--mod---str---
   CALL t110_show()    #MOD-A60162
END FUNCTION
 
#FUN-9C0076 mark str ---------------------------------------------
#FUNCTION t110_y()     #確認
#  DEFINE l_code   LIKE type_file.num5,     #No.FUN-680136 SMALLINT
#         l_msg    LIKE type_file.chr50     #No.FUN-680136 VARCHAR(12)
#  DEFINE l_cnt    LIKE type_file.num5      #No.FUN-680136 SMALLINT
#  DEFINE #l_sql    LIKE type_file.chr1000
#         l_sql        STRING       #NO.FUN-910082  
#  DEFINE l_rvb22  LIKE rvb_file.rvb22
#  DEFINE l_als05  LIKE als_file.als05
#  DEFINE l_als21  LIKE als_file.als21
#  DEFINE l_rvb03  LIKE rvb_file.rvb03
#  DEFINE l_rvb04  LIKE rvb_file.rvb04
#  DEFINE l_rvb07  LIKE rvb_file.rvb07    #MOD-9B0111
#  DEFINE l_pmn16  LIKE pmn_file.pmn16
#  DEFINE l_status LIKE type_file.chr1    #FUN-880016
#
#  IF cl_null(g_rva.rva01) THEN RETURN END IF
#  SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
#  IF g_rva.rvaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#  IF g_rva.rvaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
#
#  SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
#  IF g_cnt > g_sma.sma110 THEN
#     CALL cl_err('','axm-156',0)
#     RETURN
#  END IF
#
#  IF g_argv6 ='1' THEN                  #FUN-940083--add
#     DECLARE t110_rvb04 CURSOR FOR
#      SELECT rvb03,rvb04,rvb07 FROM rvb_file WHERE rvb01 = g_rva.rva01   #MOD-9B0111 add rvb07
#  
#     FOREACH t110_rvb04 INTO l_rvb03,l_rvb04,l_rvb07    #MOD-9B0111 add rvb07
#        IF STATUS THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,0)
#           RETURN
#        END IF
#  
#        SELECT pmn16 INTO l_pmn16 FROM pmn_file 
#         WHERE pmn01 = l_rvb04
#           AND pmn02 = l_rvb03
#        IF l_pmn16 != '2' THEN
#           CALL cl_err('','mfg3166',1)
#           RETURN
#        END IF
#        IF l_rvb07 <= 0 THEN
#           CALL cl_err('','mfg3348',0)   
#           RETURN
#        END IF
#     END FOREACH
#  END IF                                #FUN-940083--add
#
#  LET l_cnt=0
#  SELECT COUNT(*) INTO l_cnt
#    FROM rvb_file
#   WHERE rvb01=g_rva.rva01
#  IF l_cnt=0 OR l_cnt IS NULL THEN
#     CALL cl_err('','mfg-009',0)
#     RETURN
#  END IF
#
#
#  IF g_argv5<>'1' THEN  #FUN-840012
#     IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
#        LET l_sql = "SELECT rvb22 FROM rvb_file",
#                    " WHERE rvb01 = '",g_rva.rva01,"'"
#        PREPARE t110_rvb_pre FROM l_sql
#        DECLARE t110_rvb_cs CURSOR FOR t110_rvb_pre
#        FOREACH t110_rvb_cs INTO l_rvb22
#           SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
#            WHERE als01=l_rvb22
#           IF SQLCA.sqlcode=100 THEN
#              CALL cl_err3("sel","als_file",g_rvb[l_ac].rvb22,"","aap-762","","",1)
#              RETURN
#           END IF
#           IF l_als05 <> g_rva.rva05 THEN
#              CALL cl_err('','apm-303',0)
#              RETURN
#           END IF
#        END FOREACH
#     END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF
#  END IF
#  IF g_azw.azw04='2' THEN
#     LET g_cnt = 0
#     SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01 = g_rva.rva01 AND (rvb36 IS NULL OR rvb36 = ' ')
#     IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
#     IF g_cnt != 0 THEN CALL cl_err('','apm-067',0) RETURN END IF
#  END IF
#  LET g_success = 'Y'
#  LET g_totsuccess = 'Y'    #No.MOD-890074
#
#  IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
#     LET g_t1 = s_get_doc_no(g_rva.rva01) 
#     SELECT * INTO g_smy.* FROM smy_file
#      WHERE smyslip=g_t1
#     IF NOT cl_null(g_smy.smy64) THEN                                                                                   
#        IF g_smy.smy64 != '0' THEN    #要控管GPM
#           CALL s_showmsg_init()
#           CALL aws_gpmcli_part(g_rva.rva01,g_rva.rva05,'','7')
#                RETURNING l_status
#           IF l_status = '1' THEN   #回傳結果為失敗
#              IF g_smy.smy64 = '1' THEN
#                 CALL s_showmsg()
#              END IF
#              IF g_smy.smy64 = '2' THEN   
#                 LET g_success = 'N'
#                 CALL s_showmsg()
#                 RETURN
#              END IF
#           END IF
#        END IF
#     END IF
#  END IF                    #FUN-8A0054
#
#  #-->確認時 check 超短交 & 可否提前交貨
#  CALL s_showmsg_init()     #No.MOD-940250 add
#  IF g_argv6 ='1' THEN                  #FUN-940083--add
#     CALL t110_chk_over()
#  END IF                                #FUN-940083--add
#  CALL s_showmsg()
#  IF g_totsuccess = 'N' THEN CALL cl_rbmsg(4) RETURN END IF
#&ifdef ICD
#     #-->確認時 check  若該工單是作業群組(ecdicd01) = '6.TKY', 
#     #委外TKY收貨作業站別與委外工單作業製程站別不符,
#     #則出現錯誤訊息, 不允許確認 
#     CALL t110_ind_icd_chk_tky()
#     IF g_success = 'N' THEN CALL cl_rbmsg(4) RETURN END IF
#&endif
#  BEGIN WORK
#
#  OPEN t110_cl USING g_rva.rva01
#  IF STATUS THEN
#     CALL cl_err("OPEN t110_cl:", STATUS, 1)
#     CLOSE t110_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#  FETCH t110_cl INTO g_rva.*          #鎖住將被更改或取消的資料
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)      #資料被他人LOCK
#     CLOSE t110_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#   
#  #-->更新單頭確認碼
#  LET g_time = TIME                                #FUN-A30063 ADD
#  UPDATE rva_file SET rvaconf = 'Y',rvaconu=g_user,rvacond=g_today,rvacont=g_time
#      WHERE rva01 = g_rva.rva01
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     LET g_success = 'N'
#  END IF
#
#  CALL t110_y1()
#  IF g_success ='Y' THEN  #TQC-750097
#     IF g_argv6 ='1' THEN                  #FUN-940083--add
#        CALL t110_upd_pmn()
#     END IF                                #FUN-940083--add
#  END IF #TQC-750097
#  CALL cl_msg("")
#  IF g_success = 'Y' THEN
#     LET g_rva.rvaconf='Y'
#     LET g_rva.rvaconu = g_user     #NO.FUN-960130
#     LET g_rva.rvacond = g_today    #NO.FUN-960130
#     LET g_rva.rvacont = g_time     #FUN-A30063 ADD
#     COMMIT WORK
#     LET l_cnt = 0
#     SELECT COUNT(*) INTO l_cnt FROM rvu_file
#      WHERE rvu02 = g_rva.rva01
#        AND rvuconf != 'X'         #No.MOD-850156 add
#     IF l_cnt > 0 AND g_argv6 <> '2' THEN #No.FUN-940083 By shiwuying
#     IF g_rva.rva10='SUB' THEN
#&ifndef ICD
#        LET g_cmd = "apmt730" #MOD-840263
#&else
#        IF g_prog='aict041' THEN
#           LET g_cmd = "aict042"
#        ELSE
#           LET g_cmd = "apmt730_icd"
#        END IF
#&endif
#     ELSE
#&ifndef ICD
#        LET g_cmd = "apmt720" #MOD-840263
#&else
#        IF g_prog='aict041' THEN
#           LET g_cmd = "aict042"
#        ELSE
#           LET g_cmd = "apmt720_icd"
#        END IF
#&endif
#     END IF
#     LET g_cmd=g_cmd," "," '",g_rva.rva01 CLIPPED,"' '' '5' "
#     CALL cl_cmdrun_wait(g_cmd)
#     END IF
#     CALL cl_flow_notify(g_rva.rva01,'Y')
#     CALL cl_cmmsg(4)
#  ELSE
#     LET g_rva.rvaconf='N'
#     ROLLBACK WORK
#     CALL s_showmsg()       #No.TQC-760055
#     CALL cl_rbmsg(4)
#  END IF
#  DISPLAY BY NAME g_rva.rvaconf
#  CALL t110_show()
#  #CKP
#  IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#  CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
#END FUNCTION
#FUN-9C0076 mark end -----------------------------------------
 
#將t110_ins_rvu()獨立至t110sub_ins_rvu()
#FUN-C20076 ---------------------Begin---------------------------
#增加一個參數來判斷是入庫還是驗退,因為如果同一個料號既有入庫又又驗退就分不清楚了
#FUNCTION t110_ins_rvu(p_chr)   #No.MOD-8A0112 add  
#   DEFINE g_qcz       RECORD LIKE qcz_file.*
#   DEFINE l_rvu       RECORD LIKE rvu_file.*,
#          l_smy57     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)   #MOD-740033 modify
#          l_t         LIKE smy_file.smyslip    #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
#   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
#   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
#   DEFINE l_smydmy4   LIKE smy_file.smydmy4    #MOD-A80037
#   DEFINE l_smyapr    LIKE smy_file.smyapr     #FUN-A60009 add 
#
#   LET g_success='Y'
# 
#   #----單頭
#   INITIALIZE l_rvu.* TO NULL
#  #IF b_rvb.rvb33 = 0 THEN  #異動類別   #No.MOD-8A0112 mark
#  #用傳入的參數來判斷是驗退還是入庫
#   IF p_chr = 'o' THEN      #異動類別   #No.MOD-8A0112 add
#      LET l_rvu.rvu00='2'   #驗退
#&ifdef ICD
#         #委外tky非最終站之收貨項次資料不可產生至驗退單
#         IF b_rvbi.rvbiicd13 = 'Y' THEN
#            RETURN 
#         END IF
#&endif
#   ELSE
#      LET l_rvu.rvu00='1'   #入庫
#   END IF
#   LET l_rvu.rvu02=g_rva.rva01   #驗收單號
#   LET l_rvu.rvu03=g_today       #異動日期
# 
#   #若入庫日小於收貨日                                                                                                              
#   IF l_rvu.rvu03<g_rva.rva06 THEN                                                                                                  
#      IF g_bgerr THEN                                                                                                               
#         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)                                                                               
#      ELSE                                                                                                                          
#         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)                                                                       
#      END IF                                                                                                                        
#      LET g_success='N'                                                                                                             
#      RETURN                                                                                                                        
#   END IF                                                                                                                           
# 
#   #日期<=關帳日期
#   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
#      IF g_bgerr THEN
#         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
#      ELSE
#         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
#      END IF
#      LET g_success = 'N'
#      RETURN
#   END IF
# 
#   CALL s_yp(l_rvu.rvu03) RETURNING g_yy,g_mm
#   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
#      IF g_bgerr THEN
#         CALL s_errmsg("","",l_rvu.rvu03,"mfg6091",1)
#      ELSE
#         CALL cl_err3("","","","","mfg6091","",l_rvu.rvu03,1)
#      END IF
#      LET g_success = 'N'
#      RETURN
#   END IF
# 
#   LET l_t = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
#  #用傳入的參數來判斷
#   IF p_chr = 'o' THEN        #No.MOD-8A0112 add
#      SELECT smy51,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
#       WHERE smyslip=l_t
#   ELSE
#      SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
#       WHERE smyslip=l_t
#   END IF
# 
#   IF l_rvu.rvu01 IS NULL THEN
#      IF g_bgerr THEN
#         CALL s_errmsg("","","smy52=NULL","apm-272",1)
#      ELSE
#         CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
#      END IF
#      LET g_success = 'N'
#      RETURN
#   END IF
# 
#   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) OR
#      (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN
#      IF l_smy57='Y' THEN
#         LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=g_rva.rva01[g_no_sp-1,g_no_ep] #No.FUN-540027
# 
#         SELECT COUNT(*) INTO g_cnt
#           FROM rvu_file
#          WHERE rvu01=l_rvu.rvu01
#            #AND rvuconf !='X'   MOD-A90197
#         IF g_cnt > 0 THEN   # OR MONTH(g_rva.rva08) <> MONTH(g_today)
#                             #原有考慮收貨月份不等於入庫月份時應以 g_today產生單號
#                             #此狀況改以原收貨月份產生單號)
# 
#            LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
#            CALL s_auto_assign_no("apm",l_t,g_rva.rva06,"","","","","","")
#                 RETURNING li_result,l_rvu.rvu01
#            IF (NOT li_result) THEN
#                LET g_success='N'
#            END IF
#         END IF
#      ELSE
#         LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
#         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
#              RETURNING li_result,l_rvu.rvu01
#         IF (NOT li_result) THEN
#             LET g_success='N'
#         END IF
#      END IF
#   END IF
# 
#   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) THEN #入庫
#      LET g_rvu01_1 = l_rvu.rvu01
#   END IF
# 
#   IF (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN #驗退
#      LET g_rvu01_2 = l_rvu.rvu01
#   END IF
# 
#   IF l_rvu.rvu00 = '1' THEN
#      LET l_rvu.rvu01 = g_rvu01_1 #入庫
#   ELSE
#      LET l_rvu.rvu01 = g_rvu01_2 #驗退
#   END IF
# 
#   LET g_cnt = 0
#   SELECT COUNT(*) INTO g_cnt FROM rvu_file
#    WHERE rvu01 = l_rvu.rvu01
#      AND rvuconf !='X'
#      #AND rvuconf !='Y'         #No.MOD-940325   #MOD-AB0244
#      AND rvu02 = g_rva.rva01   #No.MOD-940325
# 
#   IF g_cnt >=1 THEN
#      CALL t110_ins_rvv(l_rvu.rvu01,l_rvu.rvu00) #NO:7143單身  #FUN-810038
##FUN-B90101--add--begin--
#&ifdef SLK
#     IF g_azw.azw04='2' THEN             #TQC-C20117--add
#        LET g_rvu01 = l_rvu.rvu01
#        LET g_rvu00 = l_rvu.rvu00 
#     END IF                              #TQC-C20117--add
#&endif
##FUN-B90101--add--end--
#   ELSE
#      LET l_rvu.rvu04=g_rva.rva05   #廠商編號
#      SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
#       WHERE pmc01=g_rva.rva05
#      LET l_rvu.rvu06=g_grup        #部門
#      LET l_rvu.rvu07=g_user        #人員
#      LET l_rvu.rvu08=g_rva.rva10   #性質
#      LET l_rvu.rvu09=NULL
#      LET l_rvu.rvu20='N'           #三角貿易拋轉否no.4475
#      LET l_rvu.rvuconf='N'         #確認碼
#      LET l_rvu.rvuacti='Y'
#      LET l_rvu.rvuuser=g_rva.rvauser
#      LET l_rvu.rvugrup=g_rva.rvagrup
#      LET l_rvu.rvumodu=' '
##     LET l_rvu.rvudate=g_today  #TQC-A60021 -mark
#      LET l_rvu.rvucrat=g_today  #TQC-A60021 -add
#      LET l_rvu.rvu21 = g_rva.rva29 
#      LET l_rvu.rvuplant = g_rva.rvaplant
#      LET l_rvu.rvulegal = g_rva.rvalegal
#      LET l_rvu.rvu22 = g_rva.rva30
#      LET l_rvu.rvu23 = g_rva.rva31
#      LET l_rvu.rvucrat = g_today
#      LET l_rvu.rvu900 = '0'
#      LET l_rvu.rvumksg = 'N'
#      LET l_rvu.rvupos = 'N'
#      IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
#      LET l_rvu.rvuplant = g_plant #NO.FUN-980006 jarlin add
#      LET l_rvu.rvulegal = g_legal #NO.FUN-980006 jarlin add
#      LET l_rvu.rvuoriu = g_user #TQC-9B0226
#      LET l_rvu.rvuorig = g_grup #TQC-9B0226
#      LET l_rvu.rvu101=g_rva.rva08   #CHI-A50012 add 
#      LET l_rvu.rvu102=g_rva.rva21   #CHI-A50012 add 
#      LET l_rvu.rvu100=g_rva.rva100  #CHI-A50012 add 
#     #FUN-A60009 add str --------
#      LET l_rvu.rvu17='0'
#      LET l_t = l_rvu.rvu01[1,g_doc_len]
#      SELECT smyapr INTO l_smyapr
#        FROM smy_file
#       WHERE smyslip = l_t
#      LET l_rvu.rvumksg = l_smyapr
#     #FUN-A60009 add end --------
##No.MOD-B30513 --begin
#      LET l_rvu.rvu111 = g_rva.rva111
#      LET l_rvu.rvu112 = g_rva.rva112
#      LET l_rvu.rvu115 = g_rva.rva115
#      LET l_rvu.rvu12  = g_rva.rva116
#      LET l_rvu.rvu113 = g_rva.rva113
#      LET l_rvu.rvu114 = g_rva.rva114
##No.MOD-B30513 --end
#      LET l_rvu.rvu27 = '1'  #TQC-B60065
#      INSERT INTO rvu_file VALUES (l_rvu.*)
#      IF STATUS THEN
#         IF g_bgerr THEN
#            CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:1",STATUS,1)
#         ELSE
#            CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:1",1)
#         END IF
#         LET g_success='N'
#      ELSE
#         IF l_rvu.rvu00 = '1' THEN
#            #產生的入庫異動單
#            CALL cl_err(l_rvu.rvu01,'apm-112',1)
#         ELSE
#            #產生的驗退異動單
#            CALL cl_err(l_rvu.rvu01,'apm-124',1)
#         END IF
#      END IF
#      CALL t110_ins_rvv(l_rvu.rvu01,l_rvu.rvu00) #NO:7143單身  #FUN-810038
##FUN-B90101--add--begin--
#&ifdef SLK
#      IF g_azw.azw04='2' THEN             #TQC-C20117--add
#         LET g_rvu01 = l_rvu.rvu01
#         LET g_rvu00 = l_rvu.rvu00 
#      END IF                              #TQC-C20117--add
#&endif
##FUN-B90101--add--end--
#   END IF
#   #-----MOD-AB0244---------
#   ##-----MOD-A80037---------
#   #LET l_smydmy4 = ''
#   #LET l_t = l_rvu.rvu01[1,g_doc_len]      
#   #SELECT smydmy4 INTO l_smydmy4 FROM smy_file
#   # WHERE smyslip = l_t
#   #IF l_smydmy4 = 'Y' THEN
#   #   IF p_chr = 'i' THEN 
#   #      CALL t720sub_y(l_rvu.rvu01,'6',l_rvu.rvu01,g_argv2,'7',TRUE,'N')
#   #   ELSE
#   #      CALL t720sub_y(l_rvu.rvu01,'6',l_rvu.rvu01,g_argv2,'4',TRUE,'N')
#   #   END IF
#   #END IF
#   ##-----END MOD-A80037-----
#   #-----END MOD-AB0244-----
# 
#END FUNCTION
 
#FUNCTION t110_ins_rvv(p_rvv01,p_rvu00)     #FUN-810038
# DEFINE g_qcz     RECORD LIKE qcz_file.*
# DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
# DEFINE l_rvv     RECORD LIKE rvv_file.*,
#        l_rvuconf LIKE rvu_file.rvuconf,
#        l_smy57   LIKE type_file.chr1,     #MOD-740033 add
#        l_t       LIKE smy_file.smyslip,   #MOD-740033 add
#        p_rvv01   LIKE rvv_file.rvv01
# DEFINE p_rvu00   LIKE rvu_file.rvu00      #FUN-810038
#&ifndef STD
# DEFINE l_rvvi    RECORD LIKE rvvi_file.*  #FUN-810038
# DEFINE l_ida     RECORD LIKE ida_file.*   #MOD-840263
# DEFINE l_idd     RECORD LIKE idd_file.*   #MOD-840263
#&endif
# DEFINE l_flag    LIKE type_file.num5      #FUN-810038
# DEFINE l_sql     STRING  #No.FUN-810036
# DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-810036
# DEFINE l_pmm43   LIKE pmm_file.pmm43      #CHI-830033
# DEFINE l_cnt     LIKE type_file.num5      #MOD-840263
# DEFINE l_gec05   LIKE gec_file.gec05      #MOD-A80052
# DEFINE l_rvw06f  LIKE rvw_file.rvw06f     #MOD-A80052
##FUN-A60035 ---MARK BEGIN
## DEFINE l_ata RECORD LIKE ata_file.*       #No.FUN-A50054
##FUN-A60035 ---MARK END 
#
#&ifdef ICD
#      #委外TKY非最終站,不需產生至驗退
#      IF p_rvu00 = '2' AND b_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF
#&endif
# 
#   LET l_rvv.rvv01 = p_rvv01 #NO:7143
# 
#   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00='0'
# 
#   LET l_t = s_get_doc_no(g_rva.rva01)
# 
#   SELECT smy57[3,3] INTO l_smy57 FROM smy_file
#    WHERE smyslip=l_t
# 
#  #用傳入的參數判斷，允收數量不能准確判斷
#   IF p_rvu00 = '2' THEN    #No.MOD-8A0112 add
# 
#      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
#       WHERE rvv01=l_rvv.rvv01
# 
#      LET l_rvv.rvv03='2'                                  #異動類別
#     #這邊可以直接用本次可驗退量來賦值給異動數量
#      LET l_rvv.rvv17 = g_out      #No.MOD-8A0112 add
# 
#      IF g_sma.sma115 = 'Y' THEN
#         LET l_rvv.rvv80=b_rvb.rvb80
#         LET l_rvv.rvv81=b_rvb.rvb81
#         #LET l_rvv.rvv82=b_rvb.rvb82   #MOD-A70160
#         LET l_rvv.rvv82=g_out1         #MOD-A70160
#         LET l_rvv.rvv83=b_rvb.rvb83
#         LET l_rvv.rvv84=b_rvb.rvb84
#         #LET l_rvv.rvv85=b_rvb.rvb85   #MOD-A70160
#         LET l_rvv.rvv85=g_out2         #MOD-A70160
#      END IF
# 
#      LET l_rvv.rvv86=b_rvb.rvb86
#      LET l_rvv.rvv87=b_rvb.rvb87
#   ELSE
# 
#      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
#       WHERE rvv01=l_rvv.rvv01
#      LET l_rvv.rvv03='1'                                  #異動類別
#     #這里可以直接用本次可入庫量來賦值
#      LET l_rvv.rvv17 = g_in                   #No.MOD-8A0112 add
# 
#      IF g_sma.sma115 = 'Y' THEN
#         LET l_rvv.rvv80=b_rvb.rvb80
#         LET l_rvv.rvv81=b_rvb.rvb81
#         #LET l_rvv.rvv82=b_rvb.rvb82   #MOD-A70160
#         LET l_rvv.rvv82=g_in1          #MOD-A70160
#         LET l_rvv.rvv83=b_rvb.rvb83
#         LET l_rvv.rvv84=b_rvb.rvb84
#         #LET l_rvv.rvv85=b_rvb.rvb85   #MOD-A70160
#         LET l_rvv.rvv85=g_in2          #MOD-A70160
#      END IF
#      LET l_rvv.rvv86=b_rvb.rvb86
#      LET l_rvv.rvv87=b_rvb.rvb87
#      #IF NOT cl_null(b_rvb.rvb331) THEN LET l_rvv.rvv82=b_rvb.rvb331 END IF   #MOD-A70160
#      #IF NOT cl_null(b_rvb.rvb332) THEN LET l_rvv.rvv85=b_rvb.rvb332 END IF   #MOD-A70160
#   END IF
#   LET l_rvv.rvv82 = s_digqty(l_rvv.rvv82,l_rvv.rvv80)   #FUN-BB0084 
#   LET l_rvv.rvv85 = s_digqty(l_rvv.rvv85,l_rvv.rvv83)   #FUN-BB0084
# 
#   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
#   LET l_rvv.rvv04=g_rva.rva01     #驗收單號
#   LET l_rvv.rvv05=b_rvb.rvb02     #驗收項次
#   LET l_rvv.rvv06=g_rva.rva05     #廠商
#   LET l_rvv.rvv09=g_today         #異動日
#   LET l_rvv.rvv18=b_rvb.rvb34     #工單編號
#   LET l_rvv.rvv23=0               #已請款匹配數量
#   LET l_rvv.rvv88=0               #No.TQC-7B0083
#   LET l_rvv.rvv24=NULL
#   LET l_rvv.rvv25=b_rvb.rvb35     #樣品
#   LET l_rvv.rvv26=NULL
#   LET l_rvv.rvv31=b_rvb.rvb05     #料號
# 
#   LET l_rvv.rvv89=b_rvb.rvb89     #FUN-940083 VMI收貨否 --add
# 
#   IF cl_null(l_rvv.rvv89) THEN
#      LET l_rvv.rvv89 = 'N' 
#   END IF
# 
#   SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
# 
#   IF b_rvb.rvb05[1,4]='MISC' THEN      #品名
#      LET l_rvv.rvv031 = b_rvb.rvb051
#   ELSE
#      SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
#       WHERE ima01=b_rvb.rvb05
#   END IF
# 
#   LET l_rvv.rvv32=b_rvb.rvb36     #倉庫
#   LET l_rvv.rvv33=b_rvb.rvb37     #儲位
#   LET l_rvv.rvv34=b_rvb.rvb38     #批號
#   IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
#   IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
#   IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
# 
#   LET l_rvv.rvv35 = b_rvb.rvb90
#   LET l_rvv.rvv35_fac = b_rvb.rvb90_fac
#   LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)  #FUN-BB0084  
#   IF g_sma.sma115='Y' THEN
#      CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
#                          l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
#           RETURNING l_rvv.rvv87
#   ELSE
#      CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17, #FUN-A10130
#                          l_rvv.rvv86,1,l_rvv.rvv35)
#           RETURNING l_rvv.rvv87
#   END IF
# 
#   LET l_flag=TRUE
#&ifdef ICD
#      LET l_rvvi.rvviicd07 = b_rvbi.rvbiicd13 #委外TKY非最終站否
#      IF (l_rvvi.rvviicd07 = 'N' OR l_rvvi.rvviicd07 IS NULL 
#          OR l_rvvi.rvviicd07 = ' ') THEN
#         LET l_flag=TRUE  #委外TKY最終站
#      ELSE
#         LET l_flag=FALSE #委外TKY非最終站
#      END IF
#&else
#&endif
# 
##不須檢查img_file的合理性
#   IF NOT cl_null(l_rvv.rvv32) AND (g_sma.sma886[7,7] = 'Y') AND (l_flag) THEN  #FUN-810038
#      SELECT img09 INTO g_img09_t FROM img_file
#       WHERE img01 = l_rvv.rvv31
#         AND img02 = l_rvv.rvv32
#         AND img03 = l_rvv.rvv33
#         AND img04 = l_rvv.rvv34
#      CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,g_img09_t)
#           RETURNING g_i,l_rvv.rvv35_fac
#      IF g_i = 1 THEN
#         ### ------單位無法轉換--------####
#         IF g_bgerr THEN
#            CALL s_errmsg("","","rvv35/img09: ","abm-731",1)
#         ELSE
#            CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)
#         END IF
#         LET g_success ='N'
#         RETURN
#      END IF
# 
#      LET g_ima906 = NULL
#      LET g_ima907 = NULL
#      SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
#       WHERE ima01=l_rvv.rvv31
# 
#      IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
#         IF NOT cl_null(l_rvv.rvv83) THEN
#            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                            l_rvv.rvv83) RETURNING g_flag
#            IF g_flag = 1 THEN
#               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
#                               l_rvv.rvv33,l_rvv.rvv34,
#                               l_rvv.rvv83,l_rvv.rvv84,
#                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
#               IF g_flag = 1 THEN
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#            END IF
# 
#            CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,g_ima906)
#                 RETURNING g_errno,l_rvv.rvv84
# 
#            IF NOT cl_null(g_errno) THEN
#               IF g_bgerr THEN
#                  CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)
#               ELSE
#                  CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)
#               END IF
#               LET g_success = 'N' RETURN
#            END IF
#         END IF
# 
#         IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
#            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                            l_rvv.rvv80) RETURNING g_flag
#            IF g_flag = 1 THEN
#               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
#                               l_rvv.rvv33,l_rvv.rvv34,
#                               l_rvv.rvv80,l_rvv.rvv81,
#                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
#               IF g_flag = 1 THEN
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#            END IF
# 
#            CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
#                 RETURNING g_i,l_rvv.rvv81
#            IF g_i = 1 THEN
#               IF g_bgerr THEN
#                  CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)
#               ELSE
#                  CALL cl_err3("","","","","abm-731","","rvv80/ima44: ",1)
#               END IF
#               LET g_success = 'N' RETURN
#            END IF
#         END IF
# 
#         IF g_ima906 = '3' THEN
#            IF l_rvv.rvv85 <> 0 THEN
#               LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
#            ELSE
#               LET l_rvv.rvv84=0
#            END IF
#         END IF
#      END IF
# 
#         IF g_sma.sma115='Y' THEN
#            CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
#                                l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
#                 RETURNING l_rvv.rvv87
#         ELSE
#            CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,  #FUN-A10130
#                                l_rvv.rvv86,1,l_rvv.rvv35)
#                 RETURNING l_rvv.rvv87
#         END IF
#   END IF
# 
#   IF cl_null(l_rvv.rvv86) THEN
#      LET l_rvv.rvv86 = l_rvv.rvv35
#      LET l_rvv.rvv87 = l_rvv.rvv17
#   ELSE
#   #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
#   #而在入庫時又重推值
#    IF l_rvv.rvv17=b_rvb.rvb07  THEN
#       LET l_rvv.rvv87=b_rvb.rvb87
#    END IF 
#   END IF
# 
#   LET l_rvv.rvv36=b_rvb.rvb04     #採購單號
#   LET l_rvv.rvv37=b_rvb.rvb03     #採購單序號
#   LET l_rvv.rvv38=b_rvb.rvb10
#   LET l_rvv.rvv38t=b_rvb.rvb10t   #No.FUN-550117
#   LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
#   LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t   #No.FUN-540027
#   LET l_rvv.rvv41=b_rvb.rvb25     #手冊編號 no.A050
#   LET l_rvv.rvv930=b_rvb.rvb930  #成本中心 #FUN-670051
#   LET l_rvv.rvv10 = b_rvb.rvb42
#   LET l_rvv.rvv11 = b_rvb.rvb43
#   LET l_rvv.rvv12 = b_rvb.rvb44
#   LET l_rvv.rvv13 = b_rvb.rvb45
#   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
#   LET t_azi04=''            #No.CHI-6A0004
# 
#   IF g_argv6='1' THEN           #FUN-940083--add
#      SELECT azi04 INTO t_azi04  #No.CHI-6A0004
#        FROM pmm_file,azi_file
#       WHERE pmm22=azi01
#         AND pmm01 = l_rvv.rvv36 #採購單號
#         AND pmm18 <> 'X'
#   ELSE
#      SELECT azi04 INTO t_azi04 
#        FROM azi_file
#       WHERE azi01=g_rva.rva113
#   END IF
# 
#   IF cl_null(t_azi04) THEN  #No.CHI-6A0004
#      LET t_azi04=0   #No.CHI-6A0004
#   END IF
# 
#   CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   #No.CHI-6A0004
#   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t #MOD-860297
# 
#   IF g_argv6='1' THEN               #FUN-940083
#      #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
#     #SELECT gec07,pmm43 INTO g_gec07,l_pmm43 FROM gec_file,pmm_file                     #MOD-A80052 mark
#      SELECT gec05,gec07,pmm43 INTO l_gec05,g_gec07,l_pmm43 FROM gec_file,pmm_file       #MOD-A80052
#       WHERE gec01 = pmm21
#         AND pmm01 = l_rvv.rvv36
#      IF SQLCA.SQLCODE = 100 THEN
#         CALL cl_err('','mfg3192',0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      IF g_gec07='Y' THEN
#        #LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)     #MOD-A80052 mark
#        #LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)      #MOD-A80052 mark
#        #-MOD-A80052-add-
#        IF l_gec05 = 'T' THEN
#           LET l_rvw06f = l_rvv.rvv39t * (l_pmm43/100)
#           LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
#           LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
#           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
#        ELSE
#           LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
#           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
#        END IF 
#        #-MOD-A80052-end-
#      ELSE
#         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
#         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
#      END IF
#   ELSE
#      SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file   #CHI-AC0016 add gec05
#       WHERE gec01 = g_rva.rva115
#      IF SQLCA.SQLCODE = 100 THEN
#         CALL cl_err('','mfg3192',0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      IF g_gec07='Y' THEN
#         #-----CHI-AC0016--------- 
#         #LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + g_rva.rva116/100)
#         #LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
#         IF l_gec05 = 'T' THEN
#            LET l_rvw06f = l_rvv.rvv39t * (g_rva.rva116/100)
#            LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
#            LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
#            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
#         ELSE
#            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + g_rva.rva116/100)
#            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
#         END IF 
#         #-----END CHI-AC0016-----
#      ELSE
#         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + g_rva.rva116/100)
#         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
#      END IF
#   END IF
#  
#   LET l_rvv.rvv40 = 'N'
#   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
# 
#&ifdef ICD
#      LET l_rvvi.rvviicd07 = b_rvbi.rvbiicd13  #委外TKY非最終站否
#      LET l_rvvi.rvviicd03 = b_rvbi.rvbiicd14  #母體料號
#      LET l_rvvi.rvviicd05 = b_rvbi.rvbiicd16  #母批
#      IF g_argv2 = 'SUB' THEN
#         LET l_rvvi.rvviicd01 = b_rvbi.rvbiicd03  #作業編號
#         LET l_rvvi.rvviicd02 = b_rvbi.rvbiicd08  #Date Code
#         LET l_rvvi.rvviicd04 = b_rvbi.rvbiicd15  #產品型號
#         LET l_rvvi.rvviicd06 = b_rvbi.rvbiicd11  #Tape Reel
# 
#         #判斷
#         #若是產生入庫資料,則入庫異動數量必須等於,
#         #    該收貨單刻號明細入庫否='Y'的總異動數量
#         #若是產生驗退資料,則驗退異動數量必須等於,
#         #    該收貨單刻號明細入庫否='N'的總異動數量
#         IF l_rvvi.rvviicd07 ='N' OR cl_null(l_rvvi.rvviicd07) THEN #委外TKY,非最終站不檢查
#            CALL t110sub_ind_icd_chk_icdin_yn(l_rvv.*,p_rvu00) #FUN-A10130
#            IF g_success = 'N' THEN
#               RETURN
#            END IF
#         END IF
#      END IF
#&endif
# 
#   LET l_rvv.rvv88 = 0  #No.TQC-7B0083
#   LET l_rvv.rvvlegal = g_rva.rvalegal
#   LET l_rvv.rvvplant = g_plant #NO.FUN-980006 jarlin add
#   LET l_rvv.rvvlegal = g_legal #NO.FUN-980006 jarlin add
#   LET l_rvv.rvv919 = b_rvb.rvb919            #FUN-A80150 add
#   LET l_rvv.rvv22 = g_rvb[l_ac].rvb22    #FUN-BB0001 add
#   INSERT INTO rvv_file VALUES (l_rvv.*)
#   IF STATUS THEN
#      IF g_bgerr THEN
#         LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
#         CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
#      ELSE
#         CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
#      END IF
#      LET g_success='N'
#&ifndef STD
#   ELSE
#      LET l_rvvi.rvvi01=l_rvv.rvv01
#      LET l_rvvi.rvvi02=l_rvv.rvv02
#     #IF NOT s_ins_rvvi(l_rvvi.*,'') THEN #No.FUN-A50054
#      IF NOT s_ins_rvvi(l_rvvi.*,g_plant) THEN #No.FUN-A50054
#         LET g_success = 'N'
#      END IF
#&ifdef ICD     
#      ##將收貨單的"刻號/BIN資料已過帳資料"帶入入庫單
#      LET l_cnt=0
#      SELECT COUNT(*) INTO l_cnt FROM idd_file 
#                                WHERE idd10=l_rvv.rvv04
#                                  AND idd11=l_rvv.rvv05
#      IF l_cnt>0 THEN
#         CALL t110_ind_icd_ins_icin(l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv04,
#                                    l_rvv.rvv05,p_rvu00)
#      END IF
#&endif
#&endif
#   END IF
#
##FUN-A60035 ---MARK BEGIN
## #No.FUN-A50054 -BEGIN-----
##  IF s_industry('slk') THEN
##     CASE
##        WHEN g_rva.rva10 = 'SUB' AND p_rvu00 = '1'
##           LET l_prog = 'apmt730'
##        WHEN g_rva.rva10 = 'SUB' AND p_rvu00 = '2'
##           LET l_prog = 'apmt731'
##        WHEN g_rva.rva10 = 'TAP' AND p_rvu00 = '1' 
##           LET l_prog = 'apmt740'
##        WHEN g_rva.rva10 = 'TAP' AND p_rvu00 = '2'
##           LET l_prog = 'apmt741'
##        WHEN p_rvu00 = '1'
##           LET l_prog = 'apmt720'
##        WHEN p_rvu00 = '2'
##           LET l_prog = 'apmt721'
##     END CASE
##     SELECT * INTO l_ata.* FROM ata_file
##      WHERE ata00 = g_prog
##        AND ata01 = g_rva.rva01
##        AND ata03 = b_rvb.rvb02
##     LET l_ata.ata00 = l_prog
##     LET l_ata.ata01 = l_rvv.rvv01
##     INSERT INTO ata_file VALUES(l_ata.*)
##     IF STATUS THEN
##        IF g_bgerr THEN
##           LET g_showmsg = l_ata.ata01,"/",l_ata.ata02
##           CALL s_errmsg("ata01,ata02",g_showmsg,"i ata:",SQLCA.sqlcode,1)
##        ELSE
##           CALL cl_err3("ins","ata_file",l_ata.ata01,l_ata.ata02,STATUS,"","i ata:",1)
##        END IF 
##        LET g_success='N'
##     END IF
##  END IF
## #No.FUN-A50054 -END-------
##FUN-A60035 ---MARK END
# 
#   IF g_sma.sma90 = "Y" THEN
#      LET l_sql = "SELECT * FROM rvbs_file",
#                  " WHERE rvbs00 = '",g_prog,"'",
#                  "   AND rvbs01 = '",l_rvv.rvv04,"'",
#                  "   AND rvbs02 = ",l_rvv.rvv05,
#                  "   AND rvbs09 = 1",
#                  "   AND rvbs13 = 0"   #No.FUN-860045
# 
#      PREPARE t110_rvbs FROM l_sql
#      
#      DECLARE rvbs_curs CURSOR FOR t110_rvbs
#   
#      FOREACH rvbs_curs INTO l_rvbs.*
#         IF STATUS THEN
#            CALL cl_err('foreach rvbs:',STATUS,1)
#            EXIT FOREACH
#         END IF
#      
#         IF g_rva.rva10='SUB' THEN
#&ifndef ICD
#            LET l_rvbs.rvbs00 = "apmt730"
#&else
#            LET l_rvbs.rvbs00 = "apmt730_icd"  #CHI-920064                        
#&endif
#         ELSE
#            IF g_rva.rva10='TAP' THEN   
#&ifndef ICD
#               LET l_rvbs.rvbs00 = "apmt740"
#&else
#               LET l_rvbs.rvbs00 = "apmt740_icd" 
#&endif
#            ELSE
##FUN-B90101--add--begin--
#&ifdef STD
#               IF p_rvu00 = '2' THEN
#                  LET l_rvbs.rvbs00 = "apmt721"
#               ELSE
#                  LET l_rvbs.rvbs00 = "apmt720"
#               END IF
#&endif
#&ifdef SLK
#
#               IF p_rvu00 = '2' THEN
#                  LET l_rvbs.rvbs00 = "apmt721"
#               ELSE
#                  IF g_azw.azw04='2' THEN              #TQC-C20117--add
#                     LET l_rvbs.rvbs00 = "apmt720_slk" 
#                  ELSE                                 #TQC-C20117--add
#                     LET l_rvbs.rvbs00 = "apmt720"     #TQC-C20117--add
#                  END IF                               #TQC-C20117--add
#               END IF
#&endif
#&ifdef ICD
#               IF p_rvu00 = '2' THEN
#                  LET l_rvbs.rvbs00 = "apmt721_icd"
#               ELSE
#                  LET l_rvbs.rvbs00 = "apmt720_icd"
#               END IF
#&endif
##FUN-B90101--add--end--
##FUN-B90101--mark--begin--
##&ifndef ICD
##              IF p_rvu00 = '2' THEN 
##                 LET l_rvbs.rvbs00 = "apmt721"
##              ELSE
##                 LET l_rvbs.rvbs00 = "apmt720"
##              END IF
##&else
##              IF p_rvu00 = '2' THEN 
##                 LET l_rvbs.rvbs00 = "apmt721_icd"
##              ELSE
##                 LET l_rvbs.rvbs00 = "apmt720_icd"
##              END IF
##&endif
##FUN-B90101--mark--end--
#            END IF
#         END IF
# 
#         LET l_rvbs.rvbs01 = l_rvv.rvv01
#         LET l_rvbs.rvbs02 = l_rvv.rvv02 
#      
#         IF p_rvu00 = '2' THEN 
#            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs10 
#         ELSE
#            IF l_rvbs.rvbs10 > 0 THEN
#               #異動數量=允收量-入庫量
#               LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11  
#            END IF
#         END IF   #MOD-990077-----
# 
#         LET l_rvbs.rvbs10 = 0
# 
#         LET l_rvbs.rvbs11 = 0
# 
#         LET l_rvbs.rvbs12 = 0
# 
#         LET l_rvbs.rvbs13 = 0   #No.FUN-860045
# 
#         LET l_rvbs.rvbsplant = g_plant #NO.FUN-980006 jarlin add
#         LET l_rvbs.rvbslegal = g_legal #NO.FUN-980006 jarlin add
#         INSERT INTO rvbs_file VALUES(l_rvbs.*)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
#            LET g_success = "N"
#            CONTINUE FOREACH
#         END IF
#      
#      END FOREACH
#   END IF  #No.FUN-850100
# 
#&ifdef ICD
#   #-->若為委外收貨單,產生入庫資料後,重新給予入庫計價數量,單價,金額
#   CALL t110_ind_icd_upd_rvvxx(l_rvv.*)
#&endif
# 
#END FUNCTION
#FUN-C20076 -------------------End----------------------------- 

#FUN-B90101--add--begin--
#TQC-C20117---add-----------begin-------------------
FUNCTION t110_set_no_entry_bslk(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_tmp      LIKE rvb_file.rvb04    #No.FUN-680136 VARCHAR(05)  #No.FUN-540027
   DEFINE l_smy57_5  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
   DEFINE l_sfb24    LIKE sfb_file.sfb24    #MOD-740504
   DEFINE l_ima903   LIKE ima_file.ima903   #FUN-A20017
   DEFINE l_ima150   LIKE ima_file.ima150   #FUN-A20017
   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061

   CALL cl_set_comp_entry("rvbslk02,rvbslk88,rvbslk88t",FALSE)
   IF INFIELD(rvbslk02) OR INFIELD(rvbslk03) OR INFIELD(rvbslk04) OR INFIELD(rvbslk36)
      OR ( NOT g_before_input_done AND g_rec_b2 > 0) THEN  #MOD-840156 add not g_bef_input done  #MOD-840513 g_rec_b
       IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
          CALL t110_ec_sw()  RETURNING l_ec_sw
          IF g_rvbslk[l_ac2].rvbslk05[1,4]='MISC' OR l_ec_sw='Y' THEN
             CALL cl_set_comp_entry("rvbslk36,rvbslk37,rvbslk38",FALSE)
          END IF
       END IF
   END IF

   IF g_argv6 !='2' THEN
      CALL cl_set_comp_entry("rvbslk051,rvbslk90",FALSE)
   END IF
   IF g_rec_b2 > 0 THEN
      IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
         SELECT ima903,ima150 INTO l_ima903,l_ima150  #FUN-AA0010
           FROM ima_file,pmn_file
          WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
            AND pmn02 = g_rvbslk[l_ac2].rvbslk03
            AND ima01 = pmn04
         CASE
            WHEN g_argv2 <> 'SUB' AND l_ima150 MATCHES '[12]'  #非委外時,只要有設收貨替代可以輸入收貨料件
               EXIT CASE
            WHEN g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903)  #委外時,如果設聯產品才能輸入收貨料件(因為:委外時,設
              CALL cl_set_comp_entry("rvbslk05",FALSE)
         END CASE
      END IF
   END IF
END FUNCTION

FUNCTION t110_ins_rvvslk()    
 DEFINE l_rvvslk     RECORD LIKE rvvslk_file.*,
        l_n          LIKE type_file.num5    
 
   LET l_rvvslk.rvvslk01 = g_rvu01
   LET l_rvvslk.rvvslk03 = g_rvu00
 
   DECLARE t110_g_rvvslk CURSOR FOR SELECT DISTINCT rvbslk01,rvbslk02,rvbslk05,rvbslk36,rvbslk37,rvbslk38,
                                           rvbslk90,1,rvbslk04,rvbslk03,rvbslk930,rvbslk42,
                                           rvbslk43,rvbslk10,rvbslk10t
                                      FROM rvbslk_file
                                      WHERE rvbslk01=g_rva.rva01
                                      ORDER BY rvbslk02 

   FOREACH t110_g_rvvslk INTO l_rvvslk.rvvslk04,l_rvvslk.rvvslk05,l_rvvslk.rvvslk31,
                              l_rvvslk.rvvslk32,l_rvvslk.rvvslk33,l_rvvslk.rvvslk34,
                              l_rvvslk.rvvslk35,l_rvvslk.rvvslk35_fac,l_rvvslk.rvvslk36,
                              l_rvvslk.rvvslk37,l_rvvslk.rvvslk930,l_rvvslk.rvvslk10,
                              l_rvvslk.rvvslk11,l_rvvslk.rvvslk38,l_rvvslk.rvvslk38t
  
      SELECT MAX(rvvslk02)+1 INTO l_rvvslk.rvvslk02 FROM rvvslk_file WHERE rvvslk01=l_rvvslk.rvvslk01
      IF cl_null(l_rvvslk.rvvslk02) THEN
         LET l_rvvslk.rvvslk02=1
      END IF
      SELECT ima02 INTO l_rvvslk.rvvslk031 FROM ima_file WHERE ima01=l_rvvslk.rvvslk31
      SELECT SUM(rvv17),SUM(rvv39),SUM(rvv39t)
        INTO l_rvvslk.rvvslk17,l_rvvslk.rvvslk39,l_rvvslk.rvvslk39t
        FROM rvv_file,rvvi_file,rvb_file,rvbi_file
       WHERE rvv01=rvvi01
         AND rvv02=rvvi02
         AND rvb01=rvbi01
         AND rvb02=rvbi02
         AND rvv04=rvb01
         AND rvv05=rvb02
         AND rvv01=l_rvvslk.rvvslk01
         AND rvv04=l_rvvslk.rvvslk04
         AND rvbislk02=l_rvvslk.rvvslk05

      IF cl_null(l_rvvslk.rvvslk17) THEN
         CONTINUE FOREACH
      END IF
      LET l_rvvslk.rvvslk39 = cl_digcut(l_rvvslk.rvvslk39,t_azi04)
      LET l_rvvslk.rvvslk39t= cl_digcut(l_rvvslk.rvvslk39t,t_azi04) 
      LET l_rvvslk.rvvslkplant=g_plant
      LET l_rvvslk.rvvslklegal=g_legal
      INSERT INTO rvvslk_file VALUES(l_rvvslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","rvvslk_file","","",SQLCA.sqlcode,"","ins rvvslk",1)
         EXIT FOREACH
      ELSE
         UPDATE rvvi_file SET rvvislk01=l_rvvslk.rvvslk31,rvvislk02=l_rvvslk.rvvslk02
           WHERE rvvi01=l_rvvslk.rvvslk01
             AND rvvi02 IN (SELECT rvv02 FROM rvv_file,rvb_file,rvbi_file
                             WHERE rvv01=l_rvvslk.rvvslk01
                               AND rvv04=rvb01
                               AND rvv05=rvb02
                               AND rvb01=rvbi01
                               AND rvb02=rvbi02
                               AND rvb01=l_rvvslk.rvvslk04
                               AND rvbislk02=l_rvvslk.rvvslk05)

         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rvvi_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

   END FOREACH    
END FUNCTION
#FUN-B90101--add--end--

FUNCTION t110_z()     #取消確認
   DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_rvb04  LIKE rvb_file.rvb04
   DEFINE l_poz011 LIKE poz_file.poz011
   DEFINE l_rvb    RECORD LIKE rvb_file.*
   DEFINE l_pmm25  LIKE pmm_file.pmm25
   DEFINE l_rvbi   RECORD LIKE rvbi_file.*  #FUN-810038
   DEFINE l_pmn07  LIKE pmn_file.pmn07    #FUN-810038
   DEFINE l_flag   LIKE type_file.num5    #FUN-810038
   DEFINE l_rva32  LIKE rva_file.rva32    #FUN-9C0076 add
   DEFINE l_rvacont    LIKE rva_file.rvacont   #CHI-C80072 Add

   IF cl_null(g_rva.rva01) THEN
      RETURN
   END IF   
   #No.FUN-A50071 -----start---------    
   #-->POS單號不為空時不可取消確認
   IF NOT cl_null(g_rva.rva34) THEN
      CALL cl_err(' ','axm-743',0)
      RETURN
   END IF 
   #No.FUN-A50071 -----end---------
 
   SELECT * INTO g_rva.* FROM rva_file
    WHERE rva01=g_rva.rva01
 
   IF g_rva.rvaconf = 'N' THEN
      CALl cl_err('',9002,0)
      RETURN
   END IF
 
   IF g_rva.rvaconf = 'X' THEN
      CALl cl_err('',9024,0)
      RETURN
   END IF

  #FUN-9C0076  add str ---
   LET l_rva32 = g_rva.rva32

   IF g_rva.rva32 = 'S' THEN
      CALL cl_err(g_rva.rva25,'apm-030',1)
      RETURN
   END IF
  #FUN-9C0076  add end ---
 
   IF g_argv6 ='1' THEN       #FUN-940083--add
   #已結案的採購單不可取消確認
      LET l_pmm25 = ''
      SELECT pmm25 INTO l_pmm25 FROM pmm_file
       WHERE pmm01 = g_rva.rva02
      IF l_pmm25 = '6' THEN
        CALL cl_err(g_rva.rva02,'apm-056',0)
        RETURN
      END IF
   END IF                     #FUN-940083--add
 
   #-- 若為VMI發料結算還原時,不可取消確認
   IF NOT cl_null(g_rva.rva117) AND g_argv5 <>'V' THEN
      CALL cl_err(g_rva.rva02,'apm-059',0)
      RETURN
   END IF
 
   #-- 若為三角貿易單據則非來源單據不可取消確認  no.4061
   IF g_rva.rva10 ='TAP' THEN
      DECLARE rvb04_cs CURSOR FOR SELECT UNIQUE(rvb04)
                                    FROM rvb_file
                                   WHERE rvb01 = g_rva.rva01
 
      FOREACH rvb04_cs INTO l_rvb04
         IF NOT cl_null(l_rvb04) THEN
            EXIT FOREACH
         END IF
      END FOREACH
 
      SELECT poz011 INTO l_poz011
        FROM pmm_file,poz_file
       WHERE pmm904 = poz01
         AND pmm01 = l_rvb04
         AND pmm901 = 'Y'         #三角貿易否
         AND pmm905 = 'Y'         #已拋轉
         AND pmm02  = 'TAP'       #代採買性質
         AND pmm906 = 'Y'         #來源單據
 
      IF SQLCA.sqlcode THEN
         LET l_poz011 = ''
      END IF
 
      IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
         CALL cl_err('','apm-015',1)
         RETURN
      END IF
   END IF
 
   IF g_rva.rva10 = 'TRI' THEN
      CALL cl_err('','apm-015',1)
      RETURN
   END IF
 
   IF g_argv5 <>'V' THEN           #FUN-940083--add
      IF NOT cl_confirm('axm-109') THEN
         RETURN
      END IF
   END IF                          #FUN-940083--add
 
   #-----判斷是否有已確認之入庫資料
   SELECT COUNT(*) INTO l_cnt FROM rvu_file
    WHERE rvu02 = g_rva.rva01
      AND rvuconf != 'X'
 
   IF l_cnt > 0 THEN
      CALL cl_err(g_rva.rva01,'apm-108',0) #MOD-B10208 mod apm-248->apm-108
      RETURN
   END IF
 
   #-----若為委外,須判斷是否為生產系統產生之單據
   IF g_rva.rva10 = 'SUB' THEN
      SELECT COUNT(*) INTO l_cnt FROM sfu_file
       WHERE sfu01 = g_rva.rva01
      IF l_cnt > 0 THEN
         CALL cl_err(g_rva.rva01,'apm-263',0)
         RETURN
      END IF
   END IF
 
   #..品管檢驗已輸入單據(qcs_file),則不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_rva.rva01
      AND qcs14! = 'X'  #No:9524
      AND qcs00<'5'   #No.FUN-5C0078
   IF l_cnt>0 THEN
      CALL cl_err(g_rva.rva01,'apm-913',0)
      RETURN
   END IF

   BEGIN WORK

   LET g_success = 'Y'
   LET g_totsuccess = 'Y'    #No.MOD-890074
 
   OPEN t110_cl USING g_rva.rva01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t110_cl INTO g_rva.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t110_za CURSOR FOR
     SELECT * FROM rvb_file WHERE rvb01=g_rva.rva01
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_za INTO l_rvb.*
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
      UPDATE rvb_file
         SET rvb33 = 0   ,#允收數量
             rvb331=0,
             rvb332=0,
             rvb40 = NULL,#檢驗日期
             rvb41 = NULL #檢驗結果
       WHERE rvb01 = l_rvb.rvb01
         AND rvb02 = l_rvb.rvb02
 
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02
            CALL s_errmsg("rvb01,rvb02",g_showmsg,"UPDATE rvb_file",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1)
         END IF
         LET g_success = 'N'
         ROLLBACK WORK   #MOD-810073 add
         RETURN
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   LET l_rvacont = TIME   #CHI-C80072 Add 
   #-----更新單頭確認碼
  #UPDATE rva_file SET rvaconf = 'N',rvaconu = NULL,rvacond = NULL,rvacont = NULL  #FUN-A30063 ADD   #CHI-C80072 Mark
   UPDATE rva_file SET rvaconf = 'N',rvaconu = g_user,         #CHI-C80072 Add
                       rvacond = g_today,rvacont = l_rvacont   #CHI-C80072 Add
                      ,rva32 ='0'                              #更新狀況碼為:開立  #FUN-9C0076 add
    WHERE rva01 = g_rva.rva01
   IF STATUS THEN LET g_success = 'N' END IF
 
   CALL t110_z1()

   #DEV-D40015--add--begin
   #自動作廢barcode
   IF g_success='Y' AND g_prog = 'apmt110' AND g_aza.aza131 = 'Y' THEN
      CALL t110sub_barcode_z(g_rva.rva01,TRUE)
   END IF
   #DEV-D40015--add--end
 
   CALL cl_msg("")
   CALL s_showmsg()              #No.FUN-710030
   IF g_success = 'Y' THEN
      LET g_rva.rvaconf='N'
     #CHI-C80072 Mark&Add Str
     #LET g_rva.rvacond = ''     #NO.FUN-960130
     #LET g_rva.rvacont = ''     #NO.FUN-A30063 ADD
     #LET g_rva.rvaconu = ''     #NO.FUN-960130
      LET g_rva.rvacond = g_today
      LET g_rva.rvacont = l_rvacont
      LET g_rva.rvaconu = g_user
     #CHI-C80072 Mark&Add End
      LET g_rva.rva32 = '0'      #FUN-9C0076 add
      COMMIT WORK
   ELSE
      LET g_rva.rvaconf='Y'
      LET g_rva.rva32 = l_rva32  #舊值   #FUN-9C0076 add
      ROLLBACK WORK
   END IF
 
   DISPLAY BY NAME g_rva.rvaconf
   DISPLAY BY NAME g_rva.rvaconu,g_rva.rvacond,g_rva.rvacont    #FUN-A30063    #NO.FUN-960130
   DISPLAY BY NAME g_rva.rva32                                  #FUN-9C0076 add

   CALL t110_show()
 
  #FUN-C30140--mod---str---
  #IF g_rva.rvaconf='X' THEN
  #   LET g_chr='Y'
  #ELSE
  #   LET g_chr='N'
  #END IF
 
  #CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
   CALL t110_pic()
  #FUN-C30140--mod---end---
 
   #DEV-D40015--mark--begin
   ##DEV-D30045--add--begin
   ##自動作廢barcode
   #IF g_success='Y' AND g_prog = 'apmt110' AND g_aza.aza131 = 'Y' THEN
   #   CALL t110sub_barcode_z(g_rva.rva01)
   #END IF
   ##DEV-D30045--add--end
   #DEV-D40015--mark--end

END FUNCTION
 
FUNCTION t110_z1()
   DEFINE l_rvb   RECORD  LIKE rvb_file.*,
          l_factor1       LIKE ima_file.ima31_fac,#No.FUN-680136 DECIMAL(16,8)
          l_cnt           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_rvv17         LIKE rvv_file.rvv17,    #
          l_rvb07         LIKE rvb_file.rvb07,    #實收舊值
          l_sfb04         LIKE sfb_file.sfb04,    #No.MOD-610034 add
          l_pmn07         LIKE pmn_file.pmn07,    #採購單號
          l_pmn51         LIKE pmn_file.pmn51,
          l_pmn01         LIKE pmn_file.pmn01,    #採購單號
          l_pmn02         LIKE pmn_file.pmn02,    #項次
          l_pmn122        LIKE pmn_file.pmn122,   #專案號碼
          l_pmn09         LIKE pmn_file.pmn09,    #轉換因子
          l_pmn40         LIKE pmn_file.pmn40,    #會計科目
          l_pmn011        LIKE pmn_file.pmn011,   #性質
          l_ima25         LIKE ima_file.ima25,    #庫存單位
          l_ima906        LIKE ima_file.ima906,   #No.FUN-540027
          l_ima86         LIKE ima_file.ima86     #成本單位
   DEFINE l_pmn16         LIKE pmn_file.pmn16     #采購單單身狀況碼   #TQC-880009 add
   DEFINE l_rvbi   RECORD  LIKE rvbi_file.*  #FUN-810038
   DEFINE la_tlf   DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
   DEFINE l_sql    STRING                                    #NO.FUN-8C0131 
   DEFINE l_i      LIKE type_file.num5                       #NO.FUN-8C0131
 
   DECLARE t110_z CURSOR WITH HOLD FOR
     SELECT * FROM rvb_file WHERE rvb01=g_rva.rva01
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_z INTO l_rvb.*
      IF STATUS THEN
         LET g_success = 'N'  #No.FUN-8A0086
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
         EXIT FOREACH
      END IF
 
      IF g_argv6='1' THEN               #FUN-940083--add
         SELECT pmn16 INTO l_pmn16 FROM pmn_file  #采購單
          WHERE pmn01 = l_rvb.rvb04
            AND pmn02 = l_rvb.rvb03
         IF l_pmn16 != '2' THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb.rvb04,"mfg3166",1)
            ELSE
               CALL cl_err3("","","","","mfg3166","",l_rvb.rvb04,1)
            END IF
            LET g_success = 'N'
            RETURN
         END IF    
      END IF              #FUN-940083--add
 
      SELECT sfb04 INTO l_sfb04 FROM sfb_file   #工單
       WHERE sfb01 = l_rvb.rvb34
      IF l_sfb04 = "8" THEN
         IF g_bgerr THEN
            CALL s_errmsg("","",l_rvb.rvb34,"asf-070",1)
         ELSE
            CALL cl_err3("","","","","asf-070","",l_rvb.rvb34,1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
 
 
      LET l_rvb07=l_rvb.rvb07 # backup old value
 
      IF g_argv6='1' THEN                     #FUN-940083
         #捉出採購/庫存轉換因子,在途量，且LOCK 此筆資料
   
         LET g_forupd_sql = "SELECT pmn09,pmn011,pmn40,pmn07",
                            "  FROM pmn_file",
                            " WHERE pmn01=? AND pmn02=? FOR UPDATE"
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE t110_pmn2  CURSOR FROM g_forupd_sql              # LOCK CURSOR
   
         OPEN t110_pmn2 USING l_rvb.rvb04,l_rvb.rvb03
         IF STATUS THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","OPEN t110_pmn2:",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","OPEN t110_pmn2:",1)
           END IF
           CLOSE t110_pmn2
           LET g_success = 'N'                            #CHI-840071
           RETURN
         END IF
         FETCH t110_pmn2 INTO l_pmn09,l_pmn011,l_pmn40,l_pmn07  
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","Fetch t110_pmn2:",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","Fetch t110_pmn2:",1)
            END IF
            CLOSE t110_pmn2
            LET g_success = 'N'
            RETURN
         END IF
         SELECT pmn122 INTO l_pmn122 FROM pmn_file  #讀取專案代號
          WHERE pmn01 = l_rvb.rvb04
            AND pmn02 = l_rvb.rvb03
      END IF                                        #FUN-940083--add
 
      #捉出料件主檔中的 在外量/在途量，且LOCK 此筆資料
      IF l_rvb.rvb05[1,4] != 'MISC' THEN
         LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file",
                            " WHERE ima01=? FOR UPDATE"
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE t110_ima2  CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
 
         OPEN t110_ima2 USING l_rvb.rvb05
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","OPEN t110_ima2:",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","OPEN t110_ima2:",1)
            END IF
            CLOSE t110_ima2
            LET g_success = 'N'                            #CHI-840071
            RETURN
         END IF
 
         FETCH t110_ima2 INTO l_ima25,l_ima86
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","fetch:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch:",1)
            END IF
            LET g_success = 'N'
            RETURN
         END IF
 
         CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25) RETURNING l_cnt,l_factor1    #FUN-940083
 
         IF l_cnt = 1 THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","rvb90/ima25: ","abm-731",1)    #FUN-940083
            ELSE   
               CALL cl_err3("","","","","abm-731","","rvb90/ima25: ",1) #FUN-940083
            END IF
            LET g_success ='N'
         END IF
      END IF
 
      IF l_rvb.rvb35 = 'N' THEN
            SELECT SUM(rvb07) INTO l_rvb.rvb07     #計算此採購單已收量
              FROM rva_file,rvb_file
             WHERE rvb04 = l_rvb.rvb04
               AND rvb03 = l_rvb.rvb03
               AND rvb35 = 'N'
               AND rvaconf = 'Y'
               AND rva01 = rvb01
 
         IF cl_null(l_rvb.rvb07) THEN
            LET l_rvb.rvb07 = 0
         END IF
 
         IF g_argv6='1' THEN                                  #FUN-940083--add  
               SELECT SUM(rvb07-rvb29-rvb30) INTO l_pmn51     #計算此採購單已收量
                 FROM rva_file,rvb_file
                WHERE rvb04 = l_rvb.rvb04
                  AND rvb03 = l_rvb.rvb03
                  AND rvb35 = 'N'
                  AND rvaconf = 'Y'
                  AND rva01 = rvb01
 
            IF cl_null(l_pmn51) THEN
               LET l_pmn51 = 0
            END IF
 
            SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
              FROM rvv_file,rvu_file
             WHERE rvv37 = l_rvb.rvb03
               AND rvv36 = l_rvb.rvb04
               AND rvv25 = 'N'
               AND rvuconf = 'Y'
               AND rvu01 = rvv01
               AND rvu00 = '3'  #倉退
 
            IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
            CALL cl_msg("Update pmn_file ...")
 
            UPDATE pmn_file SET pmn50 = l_rvb.rvb07,  #收貨量
                                pmn51 = l_pmn51       #IQC #No.B185 010423 mod by lina
             WHERE pmn01 = l_rvb.rvb04
               AND pmn02 = l_rvb.rvb03
 
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success = 'N'
              IF g_bgerr THEN
                 LET g_showmsg = l_rvb.rvb04,l_rvb.rvb03
                 CALL s_errmsg("pmn01,pmn02",g_showmsg,"upd pmn:",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("upd","pmn_file",l_rvb.rvb04,l_rvb.rvb03,SQLCA.sqlcode,"","upd pmn",1)
              END IF
               RETURN
            END IF
 
            SELECT pmn01,pmn02 INTO l_pmn01,l_pmn02 FROM pmn_file
             WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03
 
            CALL s_udpmn57(l_pmn01,l_pmn02)  #更新超短交量 = 收貨量 - 訂購量
         END IF                              #FUN-940083--add
 
         #----刪除 tlf_file 之雜收部份
         IF l_rvb.rvb05[1,4] != 'MISC' THEN
            CALL cl_msg("Delete tlf_file ...")
            IF g_rva.rva10='SUB' THEN
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",l_rvb.rvb05,"' ",
                         "    AND  tlf026='",l_rvb.rvb34,"' AND tlf027=",l_rvb.rvb03," ",
                         "    AND  tlf036='",l_rvb.rvb01,"' AND tlf037=",l_rvb.rvb02," "
            DECLARE t110_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t110_u_tlf_c INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
               DELETE FROM tlf_file
                WHERE tlf026 = l_rvb.rvb34
                  AND tlf027 = l_rvb.rvb03
                  AND tlf036 = l_rvb.rvb01
                  AND tlf037 = l_rvb.rvb02
                  AND tlf01  = l_rvb.rvb05
 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  IF g_bgerr THEN
                     LET g_showmsg = l_rvb.rvb34,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                     CALL s_errmsg("tlf026,tlf027,tlf036,tlf037,tlf01",g_showmsg,"del tlf",STATUS,1)
                  ELSE
                     CALL cl_err3("del","tlf_file",l_rvb.rvb34,"",STATUS,"","del tlf",1)
                  END IF
                  LET g_success = 'N'
                  RETURN
               END IF
    ##NO.FUN-8C0131   add--begin
               FOR l_i = 1 TO la_tlf.getlength()
                  LET g_tlf.* = la_tlf[l_i].*
                  IF NOT s_untlf1('') THEN 
                     LET g_success='N' RETURN
                  END IF 
               END FOR       
  ##NO.FUN-8C0131   add--end 
 
               IF g_sma.sma115 = 'Y' THEN
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_rvb.rvb05
 
            IF  l_ima906 MATCHES '[23]' THEN
               IF NOT cl_null(l_rvb.rvb83) THEN
                  IF NOT cl_null(l_rvb.rvb85) THEN   
                     DELETE FROM tlff_file WHERE tlff026 = l_rvb.rvb34
                                             AND tlff027 = l_rvb.rvb03
                                             AND tlff036 = l_rvb.rvb01
                                             AND tlff037 = l_rvb.rvb02
                                             AND tlff01  = l_rvb.rvb05
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        IF g_bgerr THEN
                           LET g_showmsg = l_rvb.rvb34,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                           CALL s_errmsg("tlff026,tlff027,tlff036,tlff037,tlff01",g_showmsg,"del tlff",STATUS,1)
                        ELSE
                           CALL cl_err3("del","tlff_file",l_rvb.rvb34,"",STATUS,"","del tlff",1)
                        END IF
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
               END IF
               IF l_ima906 <> '3' THEN
                  IF NOT cl_null(l_rvb.rvb80) THEN
                     IF NOT cl_null(l_rvb.rvb82) THEN  
                     DELETE FROM tlff_file WHERE tlff026 = l_rvb.rvb34
                                             AND tlff027 = l_rvb.rvb03
                                             AND tlff036 = l_rvb.rvb01
                                             AND tlff037 = l_rvb.rvb02
                                             AND tlff01  = l_rvb.rvb05
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        IF g_bgerr THEN
                           LET g_showmsg = l_rvb.rvb34,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                           CALL s_errmsg("tlff026,tlff027,tlff036,tlff037,tlff01",g_showmsg,"del tlff",STATUS,1)
                        ELSE
                           CALL cl_err3("del","tlff_file",l_rvb.rvb34,"",STATUS,"","del tlff",1)
                        END IF
                        LET g_success = 'N'
                        RETURN
                     END IF
                     END IF
                  END IF
               END IF
            END IF
               END IF
            ELSE
               IF g_argv6='1' THEN                #FUN-9400083--add
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",l_rvb.rvb05,"' ",
                         "    AND  tlf026='",l_rvb.rvb04,"' AND tlf027=",l_rvb.rvb03," ",
                         "    AND  tlf036='",l_rvb.rvb01,"' AND tlf037=",l_rvb.rvb02," "
            DECLARE t110_u_tlf_c1 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t110_u_tlf_c1 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
                  DELETE FROM tlf_file
                   WHERE tlf026 = l_rvb.rvb04
                     AND tlf027 = l_rvb.rvb03
                     AND tlf036 = l_rvb.rvb01
                     AND tlf037 = l_rvb.rvb02
                     AND tlf01  = l_rvb.rvb05
               ELSE
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",l_rvb.rvb05,"' ",
                         "    AND  tlf036='",l_rvb.rvb01,"' AND tlf037=",l_rvb.rvb02," "
            DECLARE t110_u_tlf_c2 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t110_u_tlf_c2 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
                  DELETE FROM tlf_file
                   WHERE tlf036 = l_rvb.rvb01
                     AND tlf037 = l_rvb.rvb02
                     AND tlf01  = l_rvb.rvb05
               END IF
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  IF g_bgerr THEN
                     LET g_showmsg = l_rvb.rvb04,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                     CALL s_errmsg("tlf026,tlf027,tlf036,tlf037,tlf01",g_showmsg,"del tlf",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("del","tlf_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlf",1)
                  END IF
                  LET g_success = 'N'
                  RETURN
               END IF
    ##NO.FUN-8C0131   add--begin
               FOR l_i = 1 TO la_tlf.getlength()
                  LET g_tlf.* = la_tlf[l_i].*
                  IF NOT s_untlf1('') THEN 
                     LET g_success='N' RETURN
                  END IF 
               END FOR       
  ##NO.FUN-8C0131   add--end 
 
               IF g_sma.sma115 = 'Y' THEN
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_rvb.rvb05
 
                  IF l_ima906 MATCHES '[23]' THEN
                     IF g_argv6 ='1' THEN               #FUN-940083--add
                        DELETE FROM tlff_file
                         WHERE tlff026 = l_rvb.rvb04
                           AND tlff027 = l_rvb.rvb03
                           AND tlff036 = l_rvb.rvb01
                           AND tlff037 = l_rvb.rvb02
                           AND tlff01  = l_rvb.rvb05
                     ELSE
                        DELETE FROM tlff_file
                         WHERE tlff036 = l_rvb.rvb01
                           AND tlff037 = l_rvb.rvb02
                           AND tlff01  = l_rvb.rvb05
                     END IF
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                        IF g_bgerr THEN
                           LET g_showmsg = l_rvb.rvb04,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                           CALL s_errmsg("tlff026,tlff027,tlff036,tlff037,tlff01",g_showmsg,"del tlff",STATUS,1)
                        ELSE
                           CALL cl_err3("del","tlff_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlff",1)
                        END IF
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
               END IF
            END IF
         END IF
 
         CALL t110_ec_sw() RETURNING l_ec_sw   #CHI-A80024
         IF l_ec_sw = 'N' THEN      #CHI-A80024
            SELECT ima918,ima921 INTO g_ima918,g_ima921 
              FROM ima_file
             WHERE ima01 = l_rvb.rvb05         #No.FUN-940083
               AND imaacti = "Y"
            
            IF (g_ima918 = "Y" OR g_ima921 = "Y") AND g_sma.sma90 = 'Y' THEN   #MOD-8C0181
               DELETE FROM tlfs_file
                WHERE tlfs01 = l_rvb.rvb05
                  AND tlfs10 = l_rvb.rvb01
                  AND tlfs11 = l_rvb.rvb02
                  AND tlfs111 = g_rva.rva06 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN   
                  IF g_aza.aza131 <> 'Y' THEN   #DEV-D40013 add  #條碼整合
                     IF g_bgerr THEN
                        LET g_showmsg = l_rvb.rvb05,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",g_rva.rva06
                        CALL s_errmsg("tlfs01,tlfs10,tlfs11,tlfs111",g_showmsg,"del tlfs",STATUS,1)
                     ELSE
                        CALL cl_err3("del","tlfs_file",l_rvb.rvb05,"",STATUS,"","del tlfs",1)
                     END IF
                     LET g_success = 'N'
                     RETURN
                  END IF                        #DEV-D40013 add  #條碼整合
               END IF
            END IF
         END IF   #CHI-A80024 
         IF g_rva.rva10='SUB' THEN
            CALL cl_msg("Update sfb_file ...")
            SELECT sfb04 INTO l_sfb04 FROM sfb_file 
             WHERE sfb01 = l_rvb.rvb34
            IF l_sfb04 <> '7' THEN 
               IF l_sfb04 = '6' THEN 
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM rva_file,rvb_file
                    WHERE rva01 = rvb01 
                      AND rvaconf = 'Y' 
                      AND rvb01 <> l_rvb.rvb01 
                      AND rvb34 = l_rvb.rvb34
                  IF l_cnt = 0 THEN 
                     LET l_cnt=0
                     SELECT COUNT(DISTINCT sfp01) INTO l_cnt
                       FROM sfp_file,sfe_file
                      WHERE sfe01 = l_rvb.rvb34
                        AND sfp01 = sfe02
                        AND sfpconf !='X'  #FUN-660106
                     IF l_cnt>0 THEN
                        UPDATE sfb_file SET sfb04='4'
                          WHERE sfb01 = l_rvb.rvb34
                     ELSE
                        UPDATE sfb_file SET sfb04='2'
                          WHERE sfb01 = l_rvb.rvb34
                     END IF
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                        IF g_bgerr THEN
                           CALL s_errmsg("sfb01",g_showmsg,"upd sfb04:",SQLCA.sqlcode,1)
                        ELSE
                           CALL cl_err3("upd","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","upd sfb04",1)
                        END IF
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF   #MOD-990024
               END IF   #MOD-990024
            END IF   #MOD-990024
 
            CALL s_updsfb117(l_rvb.rvb34)
 
            IF g_success='N' THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd sfb11:",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd sfb11:",1)
               END IF
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
 
      CLOSE t110_pmn2
      CLOSE t110_ima2
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
 
END FUNCTION
 
FUNCTION t110_out()
   DEFINE l_cmd       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2  LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(50)
          l_prtway    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   IF g_rva.rvaprsw = 'Y' THEN
      CALL cl_wait()
 
      LET l_wc='rva01="',g_rva.rva01,'"'
 
     #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'apmr920'  #FUN-C30085 mark
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'apmg920'  #FUN-C30085 add
 
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " 'N' '3' '123' "
      END IF
 
     #LET l_cmd = "apmr920",   #FUN-C30085 mark
      LET l_cmd = "apmg920",   #FUN-C30085 add
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' "    #,l_wc2     #No.TQC-610085 mark
 
      CALL cl_cmdrun(l_cmd)
   END IF
 
   ERROR ' '
 
END FUNCTION
 
FUNCTION t110_g()
   DEFINE l_rvb33  LIKE rvb_file.rvb33
   DEFINE l_flag   LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE l_factor LIKE qcs_file.qcs31
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_g_already LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_smy57     LIKE type_file.chr1,   #MOD-740033 add  #MOD-7B0145 modify
          l_t         LIKE smy_file.smyslip  #MOD-740033 add
   DEFINE l_rvb02  LIKE rvb_file.rvb02  #FUN-810038
   DEFINE l_pmn16     LIKE pmn_file.pmn16    #采購單單身狀況碼   #TQC-880009 add
   DEFINE l_qcs091    LIKE qcs_file.qcs091   #合格量
   DEFINE l_qcs38     LIKE qcs_file.qcs38    #合格量   #MOD-A70160
   DEFINE l_qcs41     LIKE qcs_file.qcs41    #合格量   #MOD-A70160
   DEFINE l_qcs22     LIKE qcs_file.qcs22    #送驗量(判定結果位驗退時為驗退量) 
   DEFINE l_qcs32     LIKE qcs_file.qcs32    #送驗量(判定結果位驗退時為驗退量)    #MOD-A70160
   DEFINE l_qcs35     LIKE qcs_file.qcs35    #送驗量(判定結果位驗退時為驗退量)    #MOD-A70160
   DEFINE l_in        LIKE rvb_file.rvb07    #全部入庫量，包括未審核
   DEFINE l_in1       LIKE rvb_file.rvb82    #全部入庫量，包括未審核   #MOD-A70160
   DEFINE l_in2       LIKE rvb_file.rvb85    #全部入庫量，包括未審核   #MOD-A70160
   DEFINE l_out       LIKE rvb_file.rvb07    #全部驗退量，包括未審核
   DEFINE l_out1      LIKE rvb_file.rvb82    #全部驗退量，包括未審核   #MOD-A70160
   DEFINE l_out2      LIKE rvb_file.rvb85    #全部驗退量，包括未審核   #MOD-A70160
   DEFINE l_smy74     LIKE smy_file.smy74    #FUN-A80026   ##FUN-B30161 mark   #TQC-B40081 unmark
#  DEFINE l_sma91     LIKE sma_file.sma91    #FUN-B30161   #TQC-B40081 unmark  #TQC-B60252 mark
   DEFINE l_smyslip   LIKE smy_file.smyslip  #FUN-A80026
   DEFINE l_smydmy4   LIKE smy_file.smydmy4    #MOD-AB0244
   DEFINE l_smyapr    LIKE smy_file.smyapr     #FUN-A60009 add 
   DEFINE l_action_choice  STRING            #MOD-B80272 add
   DEFINE l_qco       RECORD LIKE qco_file.* #TQC-C20196
   DEFINE l_msg       STRING   #FUN-C40015
   DEFINE l_msg1      STRING   #FUN-C40015
   DEFINE l_pmm02     LIKE pmm_file.pmm02    #TQC-C80120 add

   IF g_rva.rvaconf !='Y' THEN  
      CALL cl_err('','aap-717',0)
      RETURN
   END IF
 
   IF cl_null(g_rva.rva01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF NOT cl_confirm('apm-113') THEN
      RETURN
   END IF
 
      IF g_sma.sma886[6,6]='Y' THEN
         SELECT COUNT(*) INTO g_cnt
           FROM rvb_file
          WHERE rvb01 = g_rva.rva01
            AND rvb39 = 'Y'
            AND (rvb40 IS NULL OR rvb40 = '') #No:7607
         IF g_cnt >=1 THEN
            #(asms250)須檢驗收料需由品管確認才可入庫,但是本收貨單尚有料件未經品管確認
            CALL cl_err('','apm-126',1)
            RETURN
         END IF
      END IF
 
   BEGIN WORK
   LET g_success = 'Y'    #No.MOD-890074
   LET g_totsuccess = 'Y' #No.MOD-890074
 
   DECLARE t110_irvu CURSOR FOR SELECT * FROM rvb_file
                                 WHERE rvb01=g_rva.rva01
                                 ORDER BY rvb02
 
   LET l_g_already = 'Y'
   LET g_rvu01_1 = NULL
   LET g_rvu01_2 = NULL
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_irvu INTO b_rvb.*
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
 
 
      SELECT pmn16 INTO l_pmn16 FROM pmn_file  #采購單
       WHERE pmn01 = b_rvb.rvb04
         AND pmn02 = b_rvb.rvb03

      IF l_pmn16 != '2' THEN
         LET g_msg =  b_rvb.rvb04,"-",b_rvb.rvb03 
         CALL cl_err(g_msg,'mfg3166',1)   
         CONTINUE FOREACH  
      END IF    
 
      LET l_n = 0
      LET l_t = s_get_doc_no(b_rvb.rvb01)
 
      SELECT smy57[3,3] INTO l_smy57 FROM smy_file
       WHERE smyslip=l_t
 
     IF l_smy57='N' THEN
     ELSE
#MOD-B40185 --begin--
#        #----單身
#        SELECT COUNT(*) INTO l_n FROM rvv_file
#         WHERE rvv04=b_rvb.rvb01  #收貨單號
#           AND rvv05=b_rvb.rvb02  #收貨項次
         SELECT COUNT(*) INTO l_n FROM rvv_file,rvu_file
          WHERE rvv04 = b_rvb.rvb01
            AND rvv05 = b_rvb.rvb02
            AND rvv01 = rvu01
            AND rvuconf != 'X' 
#MOD-B40185 --end--
     END IF   #MOD-740033 add
     
     IF l_n >= 1 THEN
        CONTINUE FOREACH
     END IF
 
     #SELECT SUM(rvv17) INTO l_in FROM rvv_file,rvu_file   #MOD-A70160
     SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85)              #MOD-A70160
       INTO l_in,l_in1,l_in2 FROM rvv_file,rvu_file       #MOD-A70160
      WHERE rvv04=b_rvb.rvb01  #收貨單號
        AND rvv05=b_rvb.rvb02  #收貨項次
        AND rvu01=rvv01
        AND rvu00='1'
        AND rvuconf != 'X'
     #SELECT SUM(rvv17) INTO l_out FROM rvv_file,rvu_file   #MOD-A70160
     SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85)                #MOD-A70160
       INTO l_out,l_out1,l_out2 FROM rvv_file,rvu_file      #MOD-A70160
      WHERE rvv04=b_rvb.rvb01  #收貨單號
        AND rvv05=b_rvb.rvb02  #收貨項次
        AND rvu01=rvv01
        AND rvu00='2'
        AND rvuconf != 'X'
     IF cl_null(l_in) THEN LET l_in = 0 END IF
     IF cl_null(l_in1) THEN LET l_in1 = 0 END IF   #MOD-A70160
     IF cl_null(l_in2) THEN LET l_in2 = 0 END IF   #MOD-A70160
     IF cl_null(l_out) THEN LET l_out = 0 END IF
     IF cl_null(l_out1) THEN LET l_out1 = 0 END IF   #MOD-A70160
     IF cl_null(l_out2) THEN LET l_out2 = 0 END IF   #MOD-A70160
     IF l_in + l_out = b_rvb.rvb07 THEN    #已經全部入庫或驗退
        CONTINUE FOREACH
     END IF
     #SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file    #MOD-A70160
     SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)           #MOD-A70160
       INTO l_qcs091,l_qcs38,l_qcs41 FROM qcs_file      #MOD-A70160
      WHERE qcs01 = b_rvb.rvb01
        AND qcs02 = b_rvb.rvb02
        AND qcs14 = 'Y'           #No.MOD-930262 add
     IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF   #No.MOD-930220 add
     IF cl_null(l_qcs38) THEN LET l_qcs38 = 0 END IF   #MOD-A70160
     IF cl_null(l_qcs41) THEN LET l_qcs41 = 0 END IF   #MOD-A70160 
     LET g_in = l_qcs091 - l_in   #檢驗合格的量減去已經入庫的量，得到本次可入庫量
     LET g_in1 = l_qcs38 - l_in1   #檢驗合格的量減去已經入庫的量，得到本次可入庫量   #MOD-A70160
     LET g_in2 = l_qcs41 - l_in2   #檢驗合格的量減去已經入庫的量，得到本次可入庫量   #MOD-A70160
     IF cl_null(g_in) THEN
        LET g_in = 0
     END IF
     IF cl_null(g_in1) THEN LET g_in1 = 0 END IF   #MOD-A70160
     IF cl_null(g_in2) THEN LET g_in2 = 0 END IF   #MOD-A70160
     #SELECT SUM(qcs22-qcs091) INTO l_qcs22 FROM qcs_file    #MOD-980191   #MOD-A70160
     SELECT SUM(qcs22-qcs091),SUM(qcs32-qcs38),SUM(qcs35-qcs41)            #MOD-A70160
        INTO l_qcs22,l_qcs32,l_qcs35 FROM qcs_file                         #MOD-A70160
      WHERE qcs01 = b_rvb.rvb01
        AND qcs02 = b_rvb.rvb02
        AND qcs14 = 'Y'           #No.MOD-930262 add
     IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF   #No.MOD-930220 add
     IF cl_null(l_qcs32) THEN LET l_qcs32 = 0 END IF   #MOD-A70160
     IF cl_null(l_qcs35) THEN LET l_qcs35 = 0 END IF   #MOD-A70160
     LET g_out = l_qcs22 - l_out   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量
     LET g_out1 = l_qcs32 - l_out1   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量   #MOD-A70160
     LET g_out2 = l_qcs35 - l_out2   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量   #MOD-A70160
     IF cl_null(g_out) THEN
        LET g_out = 0
     END IF
     IF cl_null(g_out1) THEN LET g_out1 = 0 END IF   #MOD-A70160
     IF cl_null(g_out2) THEN LET g_out2 = 0 END IF   #MOD-A70160
     IF g_sma.sma886[6,6] = 'N' THEN         #免檢驗直接入庫
        LET g_in = b_rvb.rvb07-l_in-l_out    #No.MOD-8C0080 add
        LET g_in1 = b_rvb.rvb82-l_in1-l_out1    #MOD-A70160
        LET g_in2 = b_rvb.rvb85-l_in2-l_out2    #MOD-A70160
        LET g_out= 0
        LET g_out1= 0   #MOD-A70160
        LET g_out2= 0   #MOD-A70160
     END IF
     IF g_sma.sma886[6,6] = 'Y' AND g_sma.sma886[8,8] = 'N' THEN
        LET g_in  = b_rvb.rvb33
        LET g_in1 = b_rvb.rvb331   #MOD-A70160
        LET g_in2 = b_rvb.rvb332   #MOD-A70160
        LET g_out = b_rvb.rvb07-b_rvb.rvb33-l_in-l_out
        LET g_out1= b_rvb.rvb82-b_rvb.rvb331-l_in1-l_out1   #MOD-A70160
        LET g_out2= b_rvb.rvb85-b_rvb.rvb332-l_in2-l_out2   #MOD-A70160
     END IF
     IF b_rvb.rvb39 = 'N' THEN   #料件免檢驗入庫，不管上面怎麼算，都直接入庫
        LET g_in = b_rvb.rvb07-l_in-l_out
        LET g_in1 = b_rvb.rvb82-l_in1-l_out1     #MOD-A70160
        LET g_in2 = b_rvb.rvb85-l_in2-l_out2     #MOD-A70160
        LET g_out= 0
        LET g_out1= 0    #MOD-A70160
        LET g_out2= 0    #MOD-A70160
     END IF
     IF g_in <= 0 AND g_out <= 0 THEN   #本次可入庫量和本次可驗退量都不大于0
        CONTINUE FOREACH
     END IF
 
 
 
      LET l_g_already = 'N' #是否所有的收貨資料,早已產生入庫/驗退單完畢
      #母子單位時,自動產生入庫時,需check 以下
      #(允收數二+允收數一)經過換算<= IQC合格量才可自動產生
      #(rvb332*l_factor+rvb331)   <= rvb33
       IF g_sma.sma115 = 'Y' THEN #使用雙單位
           SELECT ima906 INTO l_ima906
             FROM ima_file
            WHERE ima01=b_rvb.rvb05
           IF l_ima906 = '2' THEN #母子單位
               LET l_rvb33  = b_rvb.rvb332 * b_rvb.rvb84 + b_rvb.rvb331 * b_rvb.rvb81
               IF l_rvb33 > b_rvb.rvb33 THEN
                   LET g_msg=b_rvb.rvb05 CLIPPED,'==>',b_rvb.rvb332,'*',l_factor,'+',b_rvb.rvb331,'>',b_rvb.rvb33
                  IF g_bgerr THEN
                     CALL s_errmsg("","",g_msg,"aqc-501",1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("","","","","aqc-501","",g_msg,1)
                     EXIT FOREACH
                  END IF
               END IF
           END IF
       END IF
      LET l_flag=TRUE   #FUN-810038
 
      #若IQC單未審核則不可生成驗收入庫信息
      IF b_rvb.rvb39 = 'Y'   AND  #檢驗否='Y'
         g_sma.sma886[8]='Y' AND  #採購收貨允收數量是否與IQC量勾稽='Y'
         b_rvb.rvb35='N'     AND  #不是樣品
         l_flag              AND  #FUN-810038
         b_rvb.rvb19 !='2'   THEN #不為委外代買
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM qcs_file
          WHERE qcs01=b_rvb.rvb01
            AND qcs02=b_rvb.rvb02
            AND qcs14='Y'
            AND qcs00<'5'   #No.FUN-5C0078
         IF l_n = 0 THEN
            LET g_success='N'
            LET g_msg=b_rvb.rvb01,'+',b_rvb.rvb02 USING '&&' CLIPPED
            #此收貨單之IQC品質記錄資料未確認,不可產生入庫單 !!
            IF g_bgerr THEN
               CALL s_errmsg("","",g_msg,"aqc-026",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","aqc-026","",g_msg,1)
               EXIT FOREACH
            END IF
         END IF
      END IF
 
     #要根據計算出來的本次可入庫量已經本次可驗退量來判斷
      IF g_in > 0 THEN
      #  CALL t110_ins_rvu('i')   #本次產生的是入庫單   #FUN-C20076
         CALL t110sub_ins_rvu('i','N','',FALSE,g_rva.*,b_rvb.*,b_rvbi.*,l_qco.*,g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,g_argv2,g_argv6,g_rvu01_1,g_rvu01_2,l_msg,l_msg1)   #FUN-C20076    #FUN-C40015 add l_msg,l_msg1 
         #    RETURNING g_rvu01_1,g_rvu01_2                #FUN-C20076   #FUN-C40015 mark
              RETURNING g_rvu01_1,g_rvu01_2,l_msg,l_msg1   #FUN-C40015   
      END IF
      IF g_out > 0 THEN
      #  CALL t110_ins_rvu('o')   #本次產生的是驗退單   #FUN-C20076
      #  CALL t110sub_ins_rvu('o','N','','N',g_rva.*,b_rvb.*,b_rvbi.*,' ',g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,g_argv2,g_argv6,g_rvu01_1,g_rvu01_2)   #FUN-C20076  #TQC-C20196  
         CALL t110sub_ins_rvu('o','N','',FALSE,g_rva.*,b_rvb.*,b_rvbi.*,l_qco.*,g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,g_argv2,g_argv6,g_rvu01_1,g_rvu01_2,l_msg,l_msg1)   #TQC-C20196    #FUN-C40015 add l_msg,l_msg1
         #    RETURNING g_rvu01_1,g_rvu01_2                #FUN-C20076   #FUN-C40015 mark
              RETURNING g_rvu01_1,g_rvu01_2,l_msg,l_msg1   #FUN-C40015
      END IF
 
      IF g_success = 'N' THEN
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
      END IF
   END FOREACH

   #-----MOD-AB0244---------
   IF NOT cl_null(g_rvu01_1) THEN 
      LET l_smydmy4 = ''
      LET l_t = g_rvu01_1[1,g_doc_len]   
     #FUN-A60009 mod str --------------------   
     #SELECT smydmy4 INTO l_smydmy4 FROM smy_file
     # WHERE smyslip = l_t
     #IF l_smydmy4 = 'Y' THEN
     #   CALL t720sub_y(g_rvu01_1,'6',g_rvu01_1,g_argv2,'7',TRUE,'N')
     #END IF
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
            CALL t720sub_y_chk(g_rvu01_1,'6',g_rvu01_1,g_argv2,'7','N')
            IF g_success = "Y" THEN
               #CALL t720sub_y_upd(g_rvu01_1,'6',g_rvu01_1,g_argv2,'7',TRUE,'N')    #MOD-C80049 mark
               CALL t720sub_y_upd(g_rvu01_1,'6',g_rvu01_1,g_argv2,'7',TRUE,'N','N') #MOD-C80049 add
            END IF
      END IF
     #FUN-A60009 mod end ---------------------
   END IF
   IF NOT cl_null(g_rvu01_2) THEN 
      LET l_smydmy4 = ''
      LET l_t = g_rvu01_2[1,g_doc_len]   
     #FUN-A60009 mod str --------------------   
     #SELECT smydmy4 INTO l_smydmy4 FROM smy_file
     # WHERE smyslip = l_t
     #IF l_smydmy4 = 'Y' THEN
     #   CALL t720sub_y(g_rvu01_2,'6',g_rvu01_2,g_argv2,'4',TRUE,'N')
     #END IF
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
            CALL t720sub_y_chk(g_rvu01_2,'6',g_rvu01_2,g_argv2,'4','N')
            IF g_success = "Y" THEN
               #CALL t720sub_y_upd(g_rvu01_2,'6',g_rvu01_2,g_argv2,'4',TRUE,'N')    #MOD-C80049 mark
               CALL t720sub_y_upd(g_rvu01_2,'6',g_rvu01_2,g_argv2,'4',TRUE,'N','N') #MOD-C80049 add
            END IF
      END IF
     #FUN-A60009 mod end ---------------------
   END IF
   #-----END MOD-AB0244-----
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   IF l_g_already = 'Y' THEN
      #所有的收貨資料,早已產生入庫/驗退單完畢,不可重覆產生!
      IF g_bgerr THEN
         CALL s_errmsg("","",g_rva.rva01,"apm-111",1)    
     #   CALL s_errmsg("","",g_rva.rva01,"mfg1607",1)    #MOD-AC0306 add   #MOD-AC0306 mark
      ELSE
         CALL cl_err3("","","","","apm-111","",g_rva.rva01,1)  
      #  CALL cl_err3("","","","","mfg1607","",g_rva.rva01,1)  #MOD-AC0306 add #MOD-AC0306 mark
      END IF
      LET g_success = 'N'
   END IF
   CALL cl_msg("")
 
#FUN-C40015 ------------Begin-----------
   IF g_success = 'Y' THEN
      IF NOT cl_null(l_msg) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',l_msg,"","mfg-085",2)
         ELSE
            CALL cl_err(l_msg CLIPPED,"mfg-085",0)
         END IF
      END IF
      IF NOT cl_null(l_msg1) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',l_msg1,"","mfg-086",2)
         ELSE
            CALL cl_err(l_msg1 CLIPPED,"mfg-086",0)
         END IF
      END IF
   END IF   
#FUN-C40015 ------------End-------------

   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF

   #MOD-C80049 add start -----
   IF NOT cl_null(g_rvu01_1) THEN
      #TQC-C80120 add start -----
      SELECT COUNT(*) INTO g_cnt FROM rvu_file WHERE rvu01 = g_rvu01_1 AND rvuconf = 'Y'
      IF g_cnt > 0 AND g_rva.rva00 = '1' THEN
         SELECT UNIQUE pmm02 INTO l_pmm02 FROM pmm_file
          WHERE pmm01 IN (SELECT rvv36 FROM rvv_file
                           WHERE rvv01 = g_rvu01_1)
         IF l_pmm02 = 'SUB' AND g_sma.sma131 = 'Y' AND (g_sma.sma1431='N' OR cl_null(g_sma.sma1431)) THEN
            SELECT sfb93 INTO l_sfb93 FROM rvv_file,sfb_file WHERE sfb01=rvv18 AND rvv01 = g_rvu01_1 ORDER BY rvv02
      #TQC-C80120 add end   -----
            #IF g_cnt > 0 THEN    #TQC-C80120 mark
            IF l_sfb93 = 'Y' THEN #TQC-C80120 add
               CALL t720sub_ecm(g_rvu01_1)
            END IF
         END IF #TQC-C80120 add
      END IF    #TQC-C80120 add
   END IF
   #MOD-C80049 add end   -----

   #No.FUN-A80026  --Begin

#TQC-B40081 --unmark --begin--
   #FUN-B30161-mark-start--
   #g_rvu01_1 为产生的入库单

   LET l_smyslip = s_get_doc_no(g_rvu01_1)
# TQC-B60252 --mark --begin--
#   SELECT smy74 INTO l_smy74 FROM smy_file WHERE smyslip = l_smyslip
#
#   IF cl_null(l_smy74) THEN LET l_smy74 = 'N' END IF
# 
#   IF NOT cl_null(g_rvu01_1) AND l_smy74 = 'Y' AND g_success = 'Y' THEN
#TQC-B40081 --unmark --end--
   #FUN-B60252-mark-end--
#TQC-B40081 --unmark --begin--

#TQC-B40081 --unmark --begin--
#TQC-B60252 --un mark -- begin--
#   SELECT sma91 INTO l_sma91 FROM sma_file                                                    #FUN-B30161 add    #TQC-B60252 add
   IF cl_null(g_sma.sma91) THEN LET g_sma.sma91 = 'N' END IF                                       #FUN-B30161 add #TQC-B60252 add
#  IF NOT cl_null(g_rvu01_1) AND g_sma.sma91 = 'Y' AND g_success = 'Y'AND g_rva.rva10='REG' THEN     #FUN-B30161 add  #TQC-B60252 add   #MOD-B80272 mark
   IF NOT cl_null(g_rvu01_1) AND (g_sma.sma91 = 'Y' OR g_sma.sma92 = 'Y') AND                      #MOD-B80272
      g_success = 'Y' THEN                                                                         #MOD-B80272
#TQC-B40081 --unmark --end--
#MOD-B80272 -- begin --
      #當作是做入庫單確認後直接串產生應付帳款功能,先改變g_action_choice的值,因為後面會用來判斷
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'confirm'
#MOD-B80272 -- end --
      CALL t720_gen_ap(g_rvu01_1)
      LET g_action_choice = l_action_choice   #MOD-B80272 add
   END IF 
   #No.FUN-A80026  --End  
 #TQC-B60252 --un mark --end--
END FUNCTION
 
FUNCTION t110_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rva01",TRUE)
   END IF
 
   IF INFIELD(rva02) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rva05,rva10",TRUE)
   END IF
 
   IF INFIELD(rva10) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rva04",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("rva01",FALSE)
   END IF
 
   IF INFIELD(rva02) OR  ( NOT g_before_input_done ) THEN
      IF NOT cl_null(g_rva.rva02) THEN
         CALL cl_set_comp_entry("rva05,rva10",FALSE)
      END IF
   END IF
 
   IF INFIELD(rva10)  OR  (NOT g_before_input_done ) THEN
      IF g_rva.rva10='SUB' THEN
         CALL cl_set_comp_entry("rva04",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   CALL cl_set_comp_entry("rvb22,rvb10,rvb10t",TRUE)   #No.FUN-550117
 
   CALL cl_set_comp_entry("rvb36,rvb37,rvb38",TRUE)
 
   CALL cl_set_comp_entry("rvb25",TRUE)
 
   CALL cl_set_comp_entry("rvb85,rvb87",TRUE)
   IF p_cmd ='s' AND g_sma.sma120 ="Y" THEN
      CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",TRUE)
   END IF
   IF g_argv6 ='2' THEN
      CALL cl_set_comp_entry("rvb051",TRUE)
      CALL cl_set_comp_entry("rvb89,rvb90",TRUE)
   END IF
   CALL cl_set_comp_entry("rvb05",TRUE)   #FUN-A20017



#FUN-B90101--add--begin--
   IF g_azw.azw04='2' THEN             #TQC-C20117--add
      CALL cl_set_comp_entry("rvbslk36,rvbslk37,rvbslk38",TRUE)
      CALL cl_set_comp_entry("rvbslk05",TRUE) 
   END IF                              #TQC-C20117--add
#FUN-B90101--add--end--

#TQC-B60304 ---begin---mark
#TQC-B20099 --begin--
#  IF g_sma.sma886[3,3] = 'Y' THEN 
#     CALL cl_set_comp_entry("rvb22",true)
#  END IF 
#TQC-B20099 --end-- 
#TQC-B60304 ---end---
END FUNCTION
 
FUNCTION t110_set_no_entry_b(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_tmp      LIKE rvb_file.rvb04    #No.FUN-680136 VARCHAR(05)  #No.FUN-540027
   DEFINE l_smy57_5  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
   DEFINE l_sfb24    LIKE sfb_file.sfb24    #MOD-740504
   DEFINE l_ima903   LIKE ima_file.ima903   #FUN-A20017
   DEFINE l_ima150   LIKE ima_file.ima150   #FUN-A20017
   DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061 #FUN-BA0051 mark
#TQC-C20117--mark------begin--------------------
#FUN-B90101--add--begin--
#&ifdef SLK
#  CALL cl_set_comp_entry("rvbslk02,rvbslk88,rvbslk88t",FALSE)
#  IF INFIELD(rvbslk02) OR INFIELD(rvbslk03) OR INFIELD(rvbslk04) OR INFIELD(rvbslk36)
#     OR ( NOT g_before_input_done AND g_rec_b2 > 0) THEN  #MOD-840156 add not g_bef_input done  #MOD-840513 g_rec_b
#      IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
#         CALL t110_ec_sw()  RETURNING l_ec_sw
#         IF g_rvbslk[l_ac2].rvbslk05[1,4]='MISC' OR l_ec_sw='Y' THEN
#            CALL cl_set_comp_entry("rvbslk36,rvbslk37,rvbslk38",FALSE)
#         END IF
#      END IF
#  END IF

#  IF g_argv6 !='2' THEN
#     CALL cl_set_comp_entry("rvbslk051,rvbslk90",FALSE)
#  END IF
#  IF g_rec_b2 > 0 THEN
#     IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN
#        SELECT ima903,ima150 INTO l_ima903,l_ima150  #FUN-AA0010
#          FROM ima_file,pmn_file
#         WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
#           AND pmn02 = g_rvbslk[l_ac2].rvbslk03
#           AND ima01 = pmn04
#        CASE
#           WHEN g_argv2 <> 'SUB' AND l_ima150 MATCHES '[12]'  #非委外時,只要有設收貨替代可以輸入收貨料件
#              EXIT CASE
#           WHEN g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903)  #委外時,如果設聯產品才能輸入收貨料件(因為:委外時,設
#             CALL cl_set_comp_entry("rvbslk05",FALSE)
#        END CASE
#     END IF
#  END IF
#&else
#FUN-B90101--add--end-- 
#TQC-C20117---mark----end---------------------   
   IF g_aza.aza26 = '2' AND g_rva.rva04 != "Y" THEN
      CALL cl_set_comp_entry("rvb22",FALSE)
   END IF
 
   IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
   IF g_gec07 = 'N' THEN
      CALL cl_set_comp_entry("rvb10t",FALSE)
   ELSE
      CALL cl_set_comp_entry("rvb10",FALSE)
   END IF
   IF p_cmd ='s' AND g_sma.sma120 ="Y" THEN 
      IF  NOT cl_null(g_rvb[l_ac].rvb04) 
      AND NOT cl_null(g_rvb[l_ac].rvb03) THEN
      CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",FALSE)
      END IF
   END IF  #MOD-810024 add
 
    IF INFIELD(rvb02) OR INFIELD(rvb03) OR INFIELD(rvb04) OR INFIELD(rvb36) 
      OR ( NOT g_before_input_done AND g_rec_b > 0) THEN  #MOD-840156 add not g_bef_input done  #MOD-840513 g_rec_b
       IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
          CALL t110_ec_sw()  RETURNING l_ec_sw
          IF g_rvb[l_ac].rvb05[1,4]='MISC' OR l_ec_sw='Y' THEN
             CALL cl_set_comp_entry("rvb36,rvb37,rvb38",FALSE)
          END IF
       END IF
    END IF
 
   IF INFIELD(rvb04) THEN
      IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
         LET l_tmp=g_rvb[l_ac].rvb04
         SELECT smy57[5,5] INTO l_smy57_5 FROM smy_file WHERE smyslip=l_tmp
         IF g_aza.aza27 != 'Y' OR l_smy57_5 != 'Y' THEN
            CALL cl_set_comp_entry("rvb25",FALSE)
         END IF
      END IF
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("rvb83,rvb84,rvb85",FALSE)
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("rvb81,rvb84",FALSE)
   END IF
 
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("rvb83",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("rvb87",FALSE)
   END IF
 
   IF g_argv2='SUB' AND g_rec_b > 0 THEN   #MOD-7A0030 modify g_rec_b
      IF NOT cl_null(g_rvb[l_ac].rvb34) THEN
         LET l_sfb24=''
         SELECT sfb24 INTO l_sfb24
           FROM sfb_file
          WHERE sfb01 = g_rvb[l_ac].rvb34
         IF l_sfb24='Y' THEN
            CALL cl_set_comp_entry("rvb36,rvb37,rvb38",FALSE)
         END IF
      END IF
   END IF
 
 
   IF g_argv6 !='2' THEN
      CALL cl_set_comp_entry("rvb051",FALSE)
      CALL cl_set_comp_entry("rvb89,rvb90",FALSE)
   END IF
   #FUN-A20017--begin--add----
   IF g_rec_b > 0 THEN
      IF NOT cl_null(g_rvb[l_ac].rvb03) THEN
         SELECT ima903,ima150 INTO l_ima903,l_ima150  #FUN-AA0010
           FROM ima_file,pmn_file
          WHERE pmn01 = g_rvb[l_ac].rvb04
            AND pmn02 = g_rvb[l_ac].rvb03
            AND ima01 = pmn04
        #FUN-AA0010(S)   
        #IF g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903) THEN
        #   CALL cl_set_comp_entry("rvb05",FALSE)
        #END IF
        CASE 
           WHEN g_argv2 <> 'SUB' AND l_ima150 MATCHES '[12]'  #非委外時,只要有設收貨替代可以輸入收貨料件
              EXIT CASE
           WHEN g_argv2 <> 'SUB' OR l_ima903 = 'N' OR cl_null(l_ima903)  #委外時,如果設聯產品才能輸入收貨料件(因為:委外時,設收貨替代,但不設聯產品時,成本計算會出錯)
            CALL cl_set_comp_entry("rvb05",FALSE)
        END CASE
        #FUN-AA0010(E)   
      END IF
   END IF
   #FUN-A20017--end--add------
##&endif        #TQC-C20117--mark
#FUN-B90101 add &endif

#TQC-B60304 ---begin---mark
#TQC-B20099 --begin--
#  IF g_sma.sma886[3,3] = 'N' THEN 
#     CALL cl_set_comp_entry("rvb22",FALSE)
#  END IF 
#TQC-B20099 --end-- 
#TQC-B60304 ---end---   
END FUNCTION
 
FUNCTION t110_set_required()
 
END FUNCTION
 
FUNCTION t110_set_required_b()
   IF g_argv2<>'SUB' AND g_rvb[l_ac].rvb05[1,4]<>'MISC' THEN  
      CALL cl_set_comp_required("rvb36",TRUE)
   END IF
END FUNCTION

#&ifdef ICD   #FUN-B50096
#FUN-A40022--begin--add---- 
FUNCTION t110_set_required_1(p_cmd) 
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13 #FUN-B50096
DEFINE l_ima159   LIKE ima_file.ima159       #FUN-B50096
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(rvb05) THEN
      IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
#FUN-B50096 -------------------Begin---------------------
      #  SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file 
      #   WHERE imaicd00 = g_rvb[l_ac].rvb05
      #  IF l_imaicd13 = 'Y' THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_rvb[l_ac].rvb05
         IF l_ima159 = '1' AND cl_null(g_rvb[l_ac].rvb38) THEN
#FUN-B50096 -------------------End-----------------------
            CALL cl_set_comp_required("rvb38",TRUE)
         END IF
      END IF
   END IF
#FUN-B90101--add--begin--
 IF g_azw.azw04='2' THEN             #TQC-C20117--add
   IF p_cmd='u' OR INFIELD(rvbslk05) THEN
      IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
         IF l_ima159 = '1' AND cl_null(g_rvbslk[l_ac2].rvbslk38) THEN
            CALL cl_set_comp_required("rvbslk38",TRUE)
         END IF
      END IF
   END IF  
 END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
END FUNCTION 

FUNCTION t110_set_no_required_1() 
#FUN-B90101--add--begin--
     IF g_azw.azw04='2' THEN             #TQC-C20117--add
        CALL cl_set_comp_required("rvbslk38",FALSE)
     END IF                              #TQC-C20117--add
#FUN-B90101--add--end--
     CALL cl_set_comp_required("rvb38",FALSE)
END FUNCTION

#FN-B50096 ---------------Begin----------------
FUNCTION t110_set_no_entry_rvb38()
DEFINE l_ima159  LIKE ima_file.ima159

#FUN-B90101--add--begin--
 IF g_azw.azw04='2' THEN             #TQC-C20117--add
   IF l_ac2 > 0 THEN
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF g_rvbslk[l_ac2].rvbslk05[1,4]<>'MISC' AND l_ec_sw='N' THEN
         IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
            SELECT ima159 INTO l_ima159 FROM ima_file
             WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
            IF l_ima159 = '2' THEN
               CALL cl_set_comp_entry("rvbslk38",FALSE)
               LET g_rvbslk[l_ac2].rvbslk38 = NULL
            END IF
         END IF
      END IF
   END IF
#TQC-C20117--add------begin-------
 ELSE
   IF l_ac > 0 THEN
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF g_rvb[l_ac].rvb05[1,4]<>'MISC' AND l_ec_sw='N' THEN
         IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
            SELECT ima159 INTO l_ima159 FROM ima_file
             WHERE ima01 = g_rvb[l_ac].rvb05
            IF l_ima159 = '2' THEN
               CALL cl_set_comp_entry("rvb38",FALSE)
               LET g_rvb[l_ac].rvb38 = NULL
            END IF
         END IF
      END IF
   END IF
 END IF
#TQC-C20117--add------end-------
#FUN-B90101 add &endif
END FUNCTION

FUNCTION t110_set_entry_rvb38()
#FUN-B90101--add--begin--
  IF g_azw.azw04='2' THEN             #TQC-C20117--add
   IF l_ac2 > 0 THEN
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF g_rvbslk[l_ac2].rvbslk05[1,4]<>'MISC' AND l_ec_sw='N' THEN
         CALL cl_set_comp_entry("rvbslk38",TRUE)
      END IF
   END IF
#TQC-C20117--add-----begin------------------
  ELSE
    IF l_ac > 0 THEN
      CALL t110_ec_sw() RETURNING l_ec_sw
      IF g_rvb[l_ac].rvb05[1,4]<>'MISC' AND l_ec_sw='N' THEN
         CALL cl_set_comp_entry("rvb38",TRUE)
      END IF
  END IF
 END IF
#TQC-C20117--add-----end-------------------
#FUN-B90101 add &endif
END FUNCTION
#FN-B50096 ---------------End------------------

#CHI-B90021 --------------Begin-------------
#FUNCTION t110_chk_rvb() 
#DEFINE l_n  LIKE type_file.num5
#
#  LET l_n = 0
#  SELECT COUNT(*) INTO l_n FROM rvb_file
#   WHERE rvb01 = g_rva.rva01
#  IF l_n = 0 AND INT_FLAG THEN RETURN 1 ELSE RETURN 0 END IF
#END FUNCTION
#CHI-B90021 --------------End---------------
#FUN-A40022--end--add------------
#&endif    #FUN-B50096
#對原來數量/換算率/單位的賦值
FUNCTION t110_set_origin_field()
 DEFINE    l_ima906 LIKE ima_file.ima906,
           l_ima907 LIKE ima_file.ima907,
           l_img09  LIKE img_file.img09,     #img單位
           l_tot    LIKE img_file.img10,
           l_fac2   LIKE rvb_file.rvb84,
           l_qty2   LIKE rvb_file.rvb85,
           l_fac1   LIKE rvb_file.rvb81,
           l_qty1   LIKE rvb_file.rvb82,
           l_factor LIKE ima_file.ima31_fac, #No.FUN-680136 DECIMAL(16,8)
           l_ima25  LIKE ima_file.ima25,
           l_ima44  LIKE ima_file.ima44,
           l_pmn07  LIKE pmn_file.pmn07,
           l_pmn31  LIKE pmn_file.pmn31,
           l_pmn31t LIKE pmn_file.pmn31t
 
   IF g_sma.sma115='N' THEN RETURN END IF
 
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file
    WHERE ima01=g_rvb[l_ac].rvb05
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvb[l_ac].rvb05 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file
          WHERE ima01='MISC'
      END IF
   END IF
 
   IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
   SELECT pmn07,pmn31,pmn31t INTO l_pmn07,l_pmn31,l_pmn31t FROM pmn_file
    WHERE pmn01=g_rvb[l_ac].rvb04
      AND pmn02=g_rvb[l_ac].rvb03
 
   IF cl_null(l_pmn07) THEN LET l_pmn07 = l_ima44 END IF
   IF cl_null(l_pmn31) THEN LET l_pmn07 = 0 END IF
 
   LET l_fac2=g_rvb[l_ac].rvb84
   LET l_qty2=g_rvb[l_ac].rvb85
   LET l_fac1=g_rvb[l_ac].rvb81
   LET l_qty1=g_rvb[l_ac].rvb82
 
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1
         WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
         WHEN '3' LET l_tot=l_qty1
                  IF l_qty2 <> 0 THEN
                     LET g_rvb[l_ac].rvb84=l_qty1/l_qty2
                  ELSE
                     LET g_rvb[l_ac].rvb84=0
                  END IF
      END CASE
   END IF
 
   LET g_factor = 1
   LET g_rvb[l_ac].rvb07 = l_tot * g_factor
   LET g_rvb2.rvb07 = g_rvb[l_ac].rvb07
 
   LET g_rvb2.rvb88 = g_rvb[l_ac].rvb10 * g_rvb[l_ac].rvb87
   LET g_rvb2.rvb88t= g_rvb[l_ac].rvb10t* g_rvb[l_ac].rvb87
  #-----MOD-AC0024---------
   SELECT gec07,gec05 INTO g_gec07,g_gec05 FROM gec_file,pmm_file   #CHI-AC0016 add gec05
    WHERE gec01 = pmm21
      AND pmm01 = g_rvb[l_ac].rvb04
   SELECT azi04 INTO t_azi04 
     FROM pmm_file,azi_file
    WHERE pmm22=azi01
      AND pmm01=g_rvb[l_ac].rvb04
   LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
   LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)    
   IF g_gec07='Y' THEN
      #-----CHI-AC0016--------- 
      #LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
      #LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
      #IF g_gec05 = 'T' THEN
      IF g_gec05 MATCHES '[AT]' THEN  #FUN-D10128
         LET g_rvb2.rvb10 = g_rvb2.rvb10t * ( 1 - g_rvb[l_ac].pmm43/100) #TQC-C30225 add
         LET g_rvb2.rvb10 = cl_digcut(g_rvb2.rvb10 , t_azi03)            #TQC-C30225 add
         LET g_rvb2.rvb88 = g_rvb2.rvb88t * ( 1 - g_rvb[l_ac].pmm43/100)
         LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
      ELSE
         LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
         LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
      END IF
      #-----END CHI-AC0016-----
   ELSE
      LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
      LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
   END IF
  #-----END MOD-AC0024-----
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t110_du_data_to_correct()
 
  IF cl_null(g_rvb[l_ac].rvb80) THEN
     LET g_rvb[l_ac].rvb81 = NULL
     LET g_rvb[l_ac].rvb82 = NULL
     LET g_rvb2.rvb80 = NULL
     LET g_rvb2.rvb81 = NULL
     LET g_rvb2.rvb82 = NULL
  END IF
 
  IF cl_null(g_rvb[l_ac].rvb83) THEN
     LET g_rvb[l_ac].rvb84 = NULL
     LET g_rvb[l_ac].rvb85 = NULL
     LET g_rvb2.rvb83 = NULL
     LET g_rvb2.rvb84 = NULL
     LET g_rvb2.rvb85 = NULL
  END IF
 
  IF cl_null(g_rvb[l_ac].rvb86) THEN
     LET g_rvb[l_ac].rvb87 = NULL
     LET g_rvb2.rvb86 = NULL
     LET g_rvb2.rvb87 = NULL
  END IF
 
  DISPLAY BY NAME g_rvb[l_ac].rvb81
  DISPLAY BY NAME g_rvb[l_ac].rvb82
  DISPLAY BY NAME g_rvb[l_ac].rvb84
  DISPLAY BY NAME g_rvb[l_ac].rvb85
  DISPLAY BY NAME g_rvb[l_ac].rvb86
  DISPLAY BY NAME g_rvb[l_ac].rvb87
 
END FUNCTION
FUNCTION t110_set_rvb87()
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
     FROM ima_file WHERE ima01=g_rvb[l_ac].rvb05
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvb[l_ac].rvb05 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
   LET l_fac2=g_rvb[l_ac].rvb84
   LET l_qty2=g_rvb[l_ac].rvb85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=g_rvb[l_ac].rvb81
      LET l_qty1=g_rvb[l_ac].rvb82
   ELSE
      LET l_fac1=1
      LET l_qty1=g_rvb[l_ac].rvb07
      CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima44)     #No.MOD-6B0162 #No.FUN-940083 pmn07-->rvb90 
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
      CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_rvb[l_ac].rvb86)
            RETURNING g_cnt,l_factor
   ELSE
      CALL s_umfchk(g_rvb[l_ac].rvb05,l_ima44,g_rvb[l_ac].rvb86)
            RETURNING g_cnt,l_factor
   END IF
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   LET g_rvb[l_ac].rvb87 = l_tot
END FUNCTION
 
FUNCTION t110_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62
  DEFINE li_col_count       LIKE type_file.num5      #No.FUN-680136 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5      #No.FUN-680136 SMALLINT
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
     IF g_rvb.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_rvb.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_rvb[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_rvb[li_i].att00
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
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替rvb05子料件編號來顯示
     #得到當前語言別下rvb05的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = g_prog AND gae02 = 'rvb05' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
 
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'rvb05,rvb051'  #FUN-940083 pmn041-->rvb051
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'rvb05,rvb051'  #FUN-940083 pmn041-->rvb051
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
 
             CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
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
             CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOENTRY|SCROLL","1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
       END CASE
     END FOR
 
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'rvb05'
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
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把rvb05的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_rvb[l_ac]都被改成g_rvb[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t110_check_rvb05(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t110_check_rvb05(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,     #No.FUN-680136 SMALLINT  #g_rvb數組中的當前記錄下標
 
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
  l_misc                      LIKE type_file.chr4,     #No.FUN-680136 VARCHAR(04)
  l_multi                     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
  l_n                         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,  #No.FUN-680136 INTEGER
  p_cmd                       LIKE type_file.chr1   #No.MOD-660090  #No.FUN-680136 VARCHAR(1)
 
DEFINE l_flag                 LIKE type_file.chr1   #No.FUN-7B0018
 
  #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
  #新的子料件編號并把值填入到已經隱藏起來的rvb05中（如果imxXX能夠顯示，rvb05一定是隱藏的）
  #下面就可以直接沿用rvb05的檢核邏輯了
  #如果不是，則看看是不是rvb05自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
  IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
     ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
     ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
     ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN
 
     #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
     #全部被輸入完成了才進行后續的操作
     LET ls_pid = g_rvb[p_ac].att00   # ls_pid 父料件編號
     LET ls_value = g_rvb[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN
        CALL t110_set_no_entry_b(p_cmd)
        CALL t110_set_entry_rvb38()      #FUN-B50096
        CALL t110_set_no_entry_rvb38()   #FUN-B50096
        CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
 
        RETURN TRUE
     END IF  #注意這里沒有錯，所以返回TRUE
 
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        CALL t110_set_no_entry_b(p_cmd)
        CALL t110_set_entry_rvb38()      #FUN-B50096
        CALL t110_set_no_entry_rvb38()   #FUN-B50096
        CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
 
         RETURN TRUE
     END IF
 
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_set_entry_rvb38()      #FUN-B50096
            CALL t110_set_no_entry_rvb38()   #FUN-B50096
            CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
 
            RETURN TRUE
         END IF
     END FOR
 
     #得到系統定義的標准分隔符sma46
     SELECT sma46 INTO l_ps FROM sma_file
 
     #合成子料件的名稱
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname  # ls_spec 子料件名稱
     #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
     #替換初始名稱，如果找不到則就用原來的名稱
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
        #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
        #記錄的完全同步
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1) #No.FUN-660129
           DELETE FROM ima_file WHERE ima01 = ls_value_fld
           IF NOT s_industry('std') THEN
              LET l_flag = s_del_imaicd(ls_value_fld,'')
           END IF
           RETURN FALSE
        END IF
     END IF
     #把生成的子料件賦給rvb05，否則下面的檢查就沒有意義了
     LET g_rvb[p_ac].rvb05 = ls_value
  ELSE
    IF ( p_field <> 'rvb05' )AND( p_field <> 'imx00' ) THEN
       RETURN FALSE
    END IF
  END IF
 
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照rvb05進行判斷了
 
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD rvb05段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
  IF NOT cl_null(g_rvb[l_ac].rvb05) THEN
     IF g_sma.sma120 = 'Y' THEN
        LET l_multi = '4'
        CALL cl_itemno_multi_att("rvb05",g_rvb[l_ac].rvb05,"","1","a") RETURNING l_multi,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb051  #FUN-940083 pmn041-->rvb051
        DISPLAY g_rvb[l_ac].rvb05 TO rvb05
        DISPLAY g_rvb[l_ac].rvb051 TO rvb051   #FUN-940083 pmn041-->rvb051
     END IF
     CALL t110_set_no_entry_b('a')
     CALL t110_set_entry_rvb38()      #FUN-B50096
     CALL t110_set_no_entry_rvb38()   #FUN-B50096
     CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
     LET g_rvb_t.rvb05=g_rvb[l_ac].rvb05
     RETURN TRUE
  ELSE
     IF ( p_field = 'rvb05' )OR( p_field = 'imx00' ) THEN
        CALL t110_set_no_entry_b('a')
        CALL t110_set_entry_rvb38()      #FUN-B50096
        CALL t110_set_no_entry_rvb38()   #FUN-B50096
        CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
        RETURN TRUE
     ELSE
        RETURN FALSE
     END IF
  END IF
 
END FUNCTION
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t110_check_rvb05相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t110_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        LIKE type_file.chr1,    #No.MOD-660090 #No.FUN-680136 VARCHAR(1)
  l_check_res  LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2         LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(30)
  l_imaacti    LIKE ima_file.imaacti,
  l_ima130     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
  l_ima131     LIKE ima_file.ima131,   #No.FUN-680136 VARCHAR(10)
  l_ima25      LIKE ima_file.ima25
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成rvb05料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t110_refresh_detail()函數在較早的時候填充
 
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
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t110_check_rvb05('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res
    RETURN l_check_res
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t110_check_rvb05相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t110_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value        LIKE imx_file.imx01,
  p_index        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  p_row          LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_index        STRING,
  p_cmd          LIKE type_file.chr1,    #No.MOD-660090 #No.FUN-680136 VARCHAR(1)
  l_check_res    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
  l_b2           LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(30)
  l_imaacti      LIKE ima_file.imaacti,
  l_ima130       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
  l_ima131       LIKE ima_file.ima131,   #No.FUN-680136 VARCHAR(10)
  l_ima25        LIKE ima_file.ima25
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成rvb05料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t110_check_rvb05('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res
  RETURN l_check_res
END FUNCTION
FUNCTION t110_set_rvb930(p_rvb930)
DEFINE p_rvb930 LIKE rvb_file.rvb930
DEFINE l_gem02  LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=p_rvb930
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION
 
FUNCTION t110_minp(p_rvb03,p_rvb04,p_rvb34,p_rvb05) #FUN-910053
   DEFINE l_pmn43      LIKE pmn_file.pmn43
   DEFINE l_ecm04      LIKE ecm_file.ecm04
   DEFINE l_sfa06      LIKE sfa_file.sfa06
   DEFINE l_sfa161     LIKE sfa_file.sfa161
   DEFINE l_sfb08      LIKE sfb_file.sfb05
   DEFINE l_sfa05      LIKE sfa_file.sfa05
   DEFINE l_sfa062     LIKE sfa_file.sfa062
   DEFINE l_sfa063     LIKE sfa_file.sfa063
   DEFINE l_sfa        RECORD LIKE sfa_file.*
   DEFINE l_min_set    LIKE sfb_file.sfb08,
          l_min_set_t  LIKE sfb_file.sfb08
   DEFINE p_rvb03      LIKE rvb_file.rvb03,
          p_rvb04      LIKE rvb_file.rvb04,
          p_rvb34      LIKE rvb_file.rvb34,
          p_rvb05      LIKE rvb_file.rvb05,  #FUN-910053
          l_sql        LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(1000)
          l_cnt        LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_over_qty   LIKE sfb_file.sfb08
   DEFINE l_pmn18      LIKE pmn_file.pmn18 #TQC-750166
   DEFINE l_pmn012     LIKE pmn_file.pmn012    #FUN-A60076  add by huangtao
   DEFINE l_cnt1       LIKE type_file.num5  #MOD-910239 add 
   DEFINE l_cnt2       LIKE type_file.num5  #MOD-910239 add 
   DEFINE l_ima153     LIKE ima_file.ima153 #FUN-910053
 
   LET l_pmn43 = NULL
   LET l_ecm04 = NULL
   LET l_sfa06 = 0
   LET l_sfa161= 0
   LET l_min_set = 0
   LET l_min_set_t=0
 
   #抓取採購單上的製程序號
    SELECT pmn43,pmn18,pmn012 INTO l_pmn43,l_pmn18,l_pmn012 FROM pmn_file #TQC-750166
       WHERE pmn01 = p_rvb04 AND pmn02 = p_rvb03
    IF STATUS THEN
       LET l_pmn43 = NULL
       LET l_pmn18 = NULL #TQC-750166
    END IF
 
   #抓取工單製程作業編號
    IF cl_null(l_pmn18) THEN #TQC-750166 不走runcard
       SELECT ecm04 INTO l_ecm04 FROM ecm_file
          WHERE ecm01 = p_rvb34 AND ecm03 = l_pmn43 AND ecm012 = l_pmn012         #FUN-A60076 add by huangtao
       IF STATUS THEN
          LET l_ecm04 = NULL
       END IF
    ELSE
       SELECT sgm04 INTO l_ecm04 FROM sgm_file
        WHERE sgm01=l_pmn18 AND sgm03=l_pmn43
          AND sgm012 = l_pmn012                      #FUN-A60076 add by vealxu
       IF STATUS THEN
          LET l_ecm04 = NULL
       END IF
    END IF
   #抓取公工單生產數量
    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = p_rvb34
      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
 
    LET l_sql = " SELECT * FROM sfa_file ",
                " WHERE sfa01 ='",p_rvb34 CLIPPED,"' ",
                "   AND sfa065 = 0 ",          #No.MOD-780060 add
                "   AND sfa11 <> 'E' ",         #No.MOD-730032 add
                "   AND sfa161 > 0 "           #MOD-8C0027
   PREPARE t110_min_p1 FROM l_sql
   DECLARE t110_min_c1 CURSOR WITH HOLD FOR t110_min_p1
   LET l_cnt = 0
   LET l_cnt1=0                                                                                                                     
   LET l_cnt2=0                                                                                                                     
   SELECT COUNT(*) INTO l_cnt1 FROM sfa_file                                                                                        
 #   WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SU]'  #MOD-940174   #FUN-A20037 
     WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SUZ]'  #FUN-A20037
       AND sfa065=0 AND sfa161>0 AND sfa11<>'E' 
 
   SELECT COUNT(*) INTO l_cnt2 FROM  sfa_file                                                                                       
  # WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SU]'   #FUN-A20037                                                                               
    WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SUZ]'  #FUN-A20037                                                                               
      AND sfa161>0 AND (sfa11='E'OR sfa065 > 0)                                                                                    
   IF l_cnt1 = 0 THEN    
      IF l_cnt2 > 0 THEN                                                                                                            
         LET l_min_set_t = l_sfb08                                                                                                  
         RETURN l_min_set_t                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
   FOREACH t110_min_c1 INTO l_sfa.*
     #IF l_sfa.sfa26 MATCHES '[34]' THEN  #FUN-A20037
      IF l_sfa.sfa26 MATCHES '[348]' THEN #FUN-A20037
         SELECT SUM(sfa06/sfa28),SUM(sfa05/sfa28),SUM(sfa062/sfa28),SUM(sfa063/sfa28)
            INTO l_sfa06,l_sfa05,l_sfa062,l_sfa063 FROM sfa_file
            WHERE sfa01=l_sfa.sfa01
             AND sfa27=l_sfa.sfa03
             AND sfa08=l_sfa.sfa08
             AND sfa12=l_sfa.sfa12
 
          LET l_sfa.sfa06  = l_sfa06 
          LET l_sfa.sfa05  = l_sfa05 
          LET l_sfa.sfa062 = l_sfa062
          LET l_sfa.sfa063 = l_sfa063
       END IF
   #  IF l_sfa.sfa26 MATCHES '[US]' THEN    #FUN-A20037
      IF l_sfa.sfa26 MATCHES '[USZ]' THEN   #FUN-A20037
         CONTINUE FOREACH
      END IF
      LET l_cnt = l_cnt + 1 
 
      IF l_cnt = 1 THEN
         LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         #-----MOD-A10113---------
         IF l_sfa.sfa100 = 100 THEN
            SELECT sfb08 INTO l_min_set FROM sfb_file 
              WHERE sfb01 = l_sfa.sfa01
         END IF
         #-----END MOD-A10113-----
         LET l_min_set_t = l_min_set
      ELSE
         LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         #-----MOD-A10113---------
         IF l_sfa.sfa100 = 100 THEN
            SELECT sfb08 INTO l_min_set FROM sfb_file 
              WHERE sfb01 = l_sfa.sfa01
         END IF
         #-----END MOD-A10113-----
         IF l_min_set < l_min_set_t THEN
            LET l_min_set_t = l_min_set
         END IF
      END IF
   END FOREACH
  # sma73 工單完工數量是否檢查發料最小套數
  # sma74 工單完工量容許差異百分比
   LET l_over_qty = 0
   IF g_sma.sma73='Y' THEN  #
      CALL s_get_ima153(p_rvb05) RETURNING l_ima153  #FUN-910053 
      LET l_over_qty=((l_min_set_t*l_ima153)/100)  #FUN-910053
   ELSE
      LET l_over_qty=0
   END IF
   IF l_over_qty IS NULL THEN LET l_over_qty=0 END IF
   LET l_min_set_t = l_min_set_t + l_over_qty
   RETURN l_min_set_t
END FUNCTION
 
FUNCTION t110_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE l_rvb02        LIKE rvb_file.rvb02
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01       #No.FUN-680136 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_rva.rva01,g_rva.rvaspc,g_rva.rvaconf,'')
   IF g_success = 'N' THEN
       RETURN
   END IF
 
   LET l_qc_prog = "aqct110"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_rva.rva01
   IF l_cnt > 0 THEN
     CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
     CALL cl_err_msg(g_rva.rva01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
     LET g_success='N'
     RETURN
   END IF
 
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM rvb_file
       WHERE rvb01 = g_rva.rva01 AND rvb39 = 'Y' AND rvb19 = '1'
   IF l_qc_cnt = 0 THEN
      SELECT COUNT(*) INTO l_cnt FROM rvb_file
      WHERE rvb01 = g_rva.rva01 AND rvb19 = '2'
      IF l_cnt > 0 THEN
         #委外代買料件免驗!
         LET l_err = 'aqc-110'
      ELSE
         #免驗料!
         LET l_err = 'aqc-113'
      END IF
      CALL cl_err(g_rva.rva01,l_err,0)
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT rvb02 FROM rvb_file ",
                " WHERE rvb01 = '",g_rva.rva01,"' AND rvb39='Y' AND rvb19 = '1'"
   PREPARE t110_rvb_p FROM l_sql
   DECLARE t110_rvb_c CURSOR WITH HOLD FOR t110_rvb_p
   FOREACH t110_rvb_c INTO l_rvb02
       LET l_cmd = l_qc_prog CLIPPED," '",g_rva.rva01,"' '",l_rvb02,"' '1' 'SPC'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_rva.rva01
   IF l_cnt <> l_qc_cnt THEN
     CALL t110_qcs_del()
     LET g_success='N'
     RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_rva.rva01,"'"
   PREPARE t110_qc_p FROM l_sql
   DECLARE t110_qc_c CURSOR WITH HOLD FOR t110_qc_p
   LET l_cnt = 1
   FOREACH t110_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert")
   THEN
         LET g_rva.rvaspc = '1'
   ELSE
         LET g_rva.rvaspc = '2'
         CALL t110_qcs_del()
   END IF
 
   UPDATE rva_file set rvaspc = g_rva.rvaspc WHERE rva01 = g_rva.rva01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rva_file",g_rva.rva01,"",STATUS,"","upd rvaspc",1)
      IF g_rva.rvaspc = '1' THEN
          CALL t110_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_rva.rvaspc
 
END FUNCTION
 
FUNCTION t110_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_rva.rva01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_rva.rva01,"",SQLCA.sqlcode,"","DEL qcs_filee err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_rva.rva01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_rva.rva01,"",SQLCA.sqlcode,"","DEL qct_filee err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_rva.rva01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_rva.rva01,"",SQLCA.sqlcode,"","DEL qcu_filee err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_rva.rva01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_rva.rva01,"",SQLCA.sqlcode,"","DEL qcstt_filee err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_rva.rva01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_rva.rva01,"",SQLCA.sqlcode,"","DEL qcv_filee err!",0)
      END IF
 
END FUNCTION
 
FUNCTION t110_mu_ui()

   IF g_argv6 ='2' THEN
      CALL cl_set_comp_visible("rvb84,rvb81",FALSE)
   ELSE
      CALL cl_set_comp_visible("rvb84,rvb81,rvb10,rvb10t",FALSE)
   END IF
   IF g_sma.sma115='Y' THEN
      CALL cl_set_comp_visible("rvb07,rvb90",FALSE)  ##MOD-C60005 add rvb90
   ELSE
       CALL cl_set_comp_visible("rvb83,rvb84,rvb85",FALSE)
       CALL cl_set_comp_visible("rvb80,rvb81,rvb82",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("rvb86,rvb87",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
      CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
      CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
   END IF
      CALL cl_set_act_visible("aic_qry_back,aic_s_icdin,aic_s_icdqry,aic_s_icdin_rec",FALSE)
END FUNCTION
#TQC-C20117-----add------------begin---
FUNCTION t110_b_move_toslk()
   LET g_rvbslk[l_ac2].rvbslk02  = g_rvbslk2.rvbslk02
   LET g_rvbslk[l_ac2].rvbslk04  = g_rvbslk2.rvbslk04
   LET g_rvbslk[l_ac2].rvbslk03  = g_rvbslk2.rvbslk03
   LET g_rvbslk[l_ac2].rvbslk05  = g_rvbslk2.rvbslk05
   LET g_rvbslk[l_ac2].rvbslk051 = g_rvbslk2.rvbslk051
   LET g_rvbslk[l_ac2].rvbslk07  = g_rvbslk2.rvbslk07
   LET g_rvbslk[l_ac2].rvbslk10  = g_rvbslk2.rvbslk10
   LET g_rvbslk[l_ac2].rvbslk10t = g_rvbslk2.rvbslk10t
   LET g_rvbslk[l_ac2].rvbslk29  = g_rvbslk2.rvbslk29
   LET g_rvbslk[l_ac2].rvbslk30  = g_rvbslk2.rvbslk30
   LET g_rvbslk[l_ac2].rvbslk36  = g_rvbslk2.rvbslk36
   LET g_rvbslk[l_ac2].rvbslk37  = g_rvbslk2.rvbslk37
   LET g_rvbslk[l_ac2].rvbslk38  = g_rvbslk2.rvbslk38
   LET g_rvbslk[l_ac2].rvbslk88  = g_rvbslk2.rvbslk88
   LET g_rvbslk[l_ac2].rvbslk88t = g_rvbslk2.rvbslk88t
   LET g_rvbslk[l_ac2].rvbslk930 = g_rvbslk2.rvbslk930
   LET g_rvbslk[l_ac2].rvbslk90  = g_rvbslk2.rvbslk90
   LET g_rvbslk[l_ac2].rvbslk42  = g_rvbslk2.rvbslk42
   LET g_rvbslk[l_ac2].rvbslk43  = g_rvbslk2.rvbslk43
END FUNCTION

FUNCTION t110_b_move_backslk()
   LET g_rvbslk2.rvbslk01  = g_rva.rva01
   LET g_rvbslk2.rvbslk02  = g_rvbslk[l_ac2].rvbslk02
   LET g_rvbslk2.rvbslk04  = g_rvbslk[l_ac2].rvbslk04
   LET g_rvbslk2.rvbslk03  = g_rvbslk[l_ac2].rvbslk03
   LET g_rvbslk2.rvbslk05  = g_rvbslk[l_ac2].rvbslk05
   LET g_rvbslk2.rvbslk051 = g_rvbslk[l_ac2].rvbslk051
   LET g_rvbslk2.rvbslk07  = g_rvbslk[l_ac2].rvbslk07
   LET g_rvbslk2.rvbslk10  = g_rvbslk[l_ac2].rvbslk10
   LET g_rvbslk2.rvbslk10t = g_rvbslk[l_ac2].rvbslk10t
   LET g_rvbslk2.rvbslk29  = g_rvbslk[l_ac2].rvbslk29
   LET g_rvbslk2.rvbslk30  = g_rvbslk[l_ac2].rvbslk30
   LET g_rvbslk2.rvbslk36  = g_rvbslk[l_ac2].rvbslk36
   LET g_rvbslk2.rvbslk37  = g_rvbslk[l_ac2].rvbslk37
   LET g_rvbslk2.rvbslk38  = g_rvbslk[l_ac2].rvbslk38
   LET g_rvbslk2.rvbslk88  = g_rvbslk[l_ac2].rvbslk88
   LET g_rvbslk2.rvbslk88t = g_rvbslk[l_ac2].rvbslk88t
   LET g_rvbslk2.rvbslk930 = g_rvbslk[l_ac2].rvbslk930
   LET g_rvbslk2.rvbslk90  = g_rvbslk[l_ac2].rvbslk90
   LET g_rvbslk2.rvbslk42  = g_rvbslk[l_ac2].rvbslk42
   LET g_rvbslk2.rvbslk43  = g_rvbslk[l_ac2].rvbslk43

   IF cl_null(g_rvbslk2.rvbslk07)  THEN LET g_rvbslk2.rvbslk07 =0 END IF
   IF cl_null(g_rvbslk2.rvbslk10)  THEN LET g_rvbslk2.rvbslk10 =0 END IF
   IF cl_null(g_rvbslk2.rvbslk10t) THEN LET g_rvbslk2.rvbslk10t=0 END IF
   IF cl_null(g_rvbslk2.rvbslk29)  THEN LET g_rvbslk2.rvbslk29 =0 END IF
   IF cl_null(g_rvbslk2.rvbslk30)  THEN LET g_rvbslk2.rvbslk30 =0 END IF
   IF cl_null(g_rvbslk2.rvbslk42)  THEN LET g_rvbslk2.rvbslk42 = ' ' END IF  #TQC-C30005 add
END FUNCTION
#TQC-C20117-----add------------end-----
FUNCTION t110_b_move_to()
   LET g_rvb[l_ac].rvb02  = g_rvb2.rvb02
   LET g_rvb[l_ac].rvb22  = g_rvb2.rvb22
   LET g_rvb[l_ac].rvb04  = g_rvb2.rvb04
   LET g_rvb[l_ac].rvb03  = g_rvb2.rvb03
   LET g_rvb[l_ac].rvb34  = g_rvb2.rvb34
   LET g_rvb[l_ac].rvb05  = g_rvb2.rvb05
   LET g_rvb[l_ac].rvb051 = g_rvb2.rvb051   #FUN-940083
   LET g_rvb[l_ac].rvb30  = g_rvb2.rvb30
   LET g_rvb[l_ac].rvb29  = g_rvb2.rvb29
   LET g_rvb[l_ac].rvb35  = g_rvb2.rvb35
   LET g_rvb[l_ac].rvb07  = g_rvb2.rvb07
   LET g_rvb[l_ac].rvb83  = g_rvb2.rvb83
   LET g_rvb[l_ac].rvb84  = g_rvb2.rvb84
   LET g_rvb[l_ac].rvb85  = g_rvb2.rvb85
   LET g_rvb[l_ac].rvb80  = g_rvb2.rvb80
   LET g_rvb[l_ac].rvb81  = g_rvb2.rvb81
   LET g_rvb[l_ac].rvb82  = g_rvb2.rvb82
   LET g_rvb[l_ac].rvb86  = g_rvb2.rvb86
   LET g_rvb[l_ac].rvb87  = g_rvb2.rvb87
   LET g_rvb[l_ac].rvb89  = g_rvb2.rvb89    #FUN-940083
   LET g_rvb[l_ac].rvb90  = g_rvb2.rvb90    #FUN-940083
   LET g_rvb[l_ac].rvb10  = g_rvb2.rvb10
   LET g_rvb[l_ac].rvb10t = g_rvb2.rvb10t
   LET g_rvb[l_ac].rvb36  = g_rvb2.rvb36
   LET g_rvb[l_ac].rvb37  = g_rvb2.rvb37
   LET g_rvb[l_ac].rvb38  = g_rvb2.rvb38
   LET g_rvb[l_ac].rvb25  = g_rvb2.rvb25
   LET g_rvb[l_ac].rvb930 = g_rvb2.rvb930
   LET g_rvb[l_ac].rvb919 = g_rvb2.rvb919    #FUN-A80150 add
   LET g_rvb[l_ac].rvbud01 = g_rvb2.rvbud01
   LET g_rvb[l_ac].rvbud02 = g_rvb2.rvbud02
   LET g_rvb[l_ac].rvbud03 = g_rvb2.rvbud03
   LET g_rvb[l_ac].rvbud04 = g_rvb2.rvbud04
   LET g_rvb[l_ac].rvbud05 = g_rvb2.rvbud05
   LET g_rvb[l_ac].rvbud06 = g_rvb2.rvbud06
   LET g_rvb[l_ac].rvbud07 = g_rvb2.rvbud07
   LET g_rvb[l_ac].rvbud08 = g_rvb2.rvbud08
   LET g_rvb[l_ac].rvbud09 = g_rvb2.rvbud09
   LET g_rvb[l_ac].rvbud10 = g_rvb2.rvbud10
   LET g_rvb[l_ac].rvbud11 = g_rvb2.rvbud11
   LET g_rvb[l_ac].rvbud12 = g_rvb2.rvbud12
   LET g_rvb[l_ac].rvbud13 = g_rvb2.rvbud13
   LET g_rvb[l_ac].rvbud14 = g_rvb2.rvbud14
   LET g_rvb[l_ac].rvbud15 = g_rvb2.rvbud15
END FUNCTION
 
FUNCTION t110_b_move_back()
   LET g_rvb2.rvb01  = g_rva.rva01
   LET g_rvb2.rvb02  = g_rvb[l_ac].rvb02
   LET g_rvb2.rvb22  = g_rvb[l_ac].rvb22
   LET g_rvb2.rvb04  = g_rvb[l_ac].rvb04
   LET g_rvb2.rvb03  = g_rvb[l_ac].rvb03
   LET g_rvb2.rvb34  = g_rvb[l_ac].rvb34
   LET g_rvb2.rvb05  = g_rvb[l_ac].rvb05
   LET g_rvb2.rvb051 = g_rvb[l_ac].rvb051      #FUN-940083
   LET g_rvb2.rvb89  = g_rvb[l_ac].rvb89       #FUN-940083
   LET g_rvb2.rvb90  = g_rvb[l_ac].rvb90       #FUN-940083
   LET g_rvb2.rvb30  = g_rvb[l_ac].rvb30
   LET g_rvb2.rvb29  = g_rvb[l_ac].rvb29
   LET g_rvb2.rvb35  = g_rvb[l_ac].rvb35
   LET g_rvb2.rvb07  = g_rvb[l_ac].rvb07
   LET g_rvb2.rvb83  = g_rvb[l_ac].rvb83
   LET g_rvb2.rvb84  = g_rvb[l_ac].rvb84
   LET g_rvb2.rvb85  = g_rvb[l_ac].rvb85
   LET g_rvb2.rvb80  = g_rvb[l_ac].rvb80
   LET g_rvb2.rvb81  = g_rvb[l_ac].rvb81
   LET g_rvb2.rvb82  = g_rvb[l_ac].rvb82
   LET g_rvb2.rvb86  = g_rvb[l_ac].rvb86
   LET g_rvb2.rvb87  = g_rvb[l_ac].rvb87
   LET g_rvb2.rvb10  = g_rvb[l_ac].rvb10
   LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
   LET g_rvb2.rvb36  = g_rvb[l_ac].rvb36
   LET g_rvb2.rvb37  = g_rvb[l_ac].rvb37
   LET g_rvb2.rvb38  = g_rvb[l_ac].rvb38
   LET g_rvb2.rvb25  = g_rvb[l_ac].rvb25
   LET g_rvb2.rvb930 = g_rvb[l_ac].rvb930
   LET g_rvb2.rvb919= g_rvb[l_ac].rvb919     #FUN-A80150 add
   IF cl_null(g_rvb2.rvb06) THEN LET g_rvb2.rvb06=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb07) THEN LET g_rvb2.rvb07=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb08) THEN LET g_rvb2.rvb08=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb09) THEN LET g_rvb2.rvb09=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb10) THEN LET g_rvb2.rvb10=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb29) THEN LET g_rvb2.rvb29=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb30) THEN LET g_rvb2.rvb30=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb31) THEN LET g_rvb2.rvb31=0 END IF #CHI-7B0023
   LET g_rvb2.rvbud01 = g_rvb[l_ac].rvbud01
   LET g_rvb2.rvbud02 = g_rvb[l_ac].rvbud02
   LET g_rvb2.rvbud03 = g_rvb[l_ac].rvbud03
   LET g_rvb2.rvbud04 = g_rvb[l_ac].rvbud04
   LET g_rvb2.rvbud05 = g_rvb[l_ac].rvbud05
   LET g_rvb2.rvbud06 = g_rvb[l_ac].rvbud06
   LET g_rvb2.rvbud07 = g_rvb[l_ac].rvbud07
   LET g_rvb2.rvbud08 = g_rvb[l_ac].rvbud08
   LET g_rvb2.rvbud09 = g_rvb[l_ac].rvbud09
   LET g_rvb2.rvbud10 = g_rvb[l_ac].rvbud10
   LET g_rvb2.rvbud11 = g_rvb[l_ac].rvbud11
   LET g_rvb2.rvbud12 = g_rvb[l_ac].rvbud12
   LET g_rvb2.rvbud13 = g_rvb[l_ac].rvbud13
   LET g_rvb2.rvbud14 = g_rvb[l_ac].rvbud14
   LET g_rvb2.rvbud15 = g_rvb[l_ac].rvbud15
END FUNCTION

#確認是否為製程委外工單
FUNCTION t110_ec_sw()
DEFINE     l_flag       LIKE type_file.chr1,
           x_sfb24        LIKE sfb_file.sfb24
 LET l_flag = 'N'
#FUN-B90101  add &ifndef SLK   #服飾二維中沒有rvb34(rvbslk34)這個欄位，l_flag = 'N'
#&ifndef SLK                   #TQC-C20117--mark
IF g_prog <>'apmt110_slk'  THEN  #TQC-C20117--add
 IF g_argv2 ='SUB' THEN
    LET x_sfb24=''
    SELECT sfb24 INTO x_sfb24
      FROM sfb_file
     WHERE sfb01 = g_rvb[l_ac].rvb34
    IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
       LET l_flag='Y'
    END IF
 END IF
#&endif           #TQC-C20117--mark
END IF            #TQC-C20117--add
#FUN-B90101  add &endif
   RETURN l_flag
END FUNCTION
 

FUNCTION t110_rvb05(p_cmd)
DEFINE p_cmd  LIKE  type_file.chr1,
     l_ima02  LIKE  ima_file.ima02,
     l_ima021 LIKE  ima_file.ima021,
     l_ima25  LIKE  ima_file.ima25,                     #FUN-940083
     l_ima35  LIKE  ima_file.ima35,                     #FUN-940083
     l_ima36  LIKE  ima_file.ima36,                     #FUN-940083
     l_ima907 LIKE  ima_file.ima907                     #MOD-BA0069

    IF g_rvb[l_ac].rvb05 = g_rvb_o.rvb05 THEN RETURN END IF   #MOD-BC0039
    
    SELECT ima02 ,ima021,ima25,ima35,ima36,ima907        #FUN-940083 add 單位/倉庫/儲位   #MOD-BA0069 add ima907 by suncx
      INTO l_ima02,l_ima021,l_ima25,l_ima35,l_ima36,     #FUN-940083 add 單位/倉庫/儲位
           l_ima907   #MOD-BA0069 add
      FROM ima_file
     WHERE ima01 = g_rvb[l_ac].rvb05
     
     CASE WHEN SQLCA.sqlcode =100  LET g_errno ='mfg3008'
                                       LET l_ima02 = ''
                                       LET l_ima021= ''
         OTHERWISE                     LET g_errno =SQLCA.sqlcode USING '------'
     END CASE 
#FUN-AB0066 --begin--     
#     #No.FUN-AA0049--begin
#     IF NOT s_chk_ware(l_ima35) THEN
#        LET l_ima35=' '
#        LET l_ima36=' '
#     END IF 
#     #No.FUN-AA0049--end       
#FUN-AB0066 -end--     
     IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET  g_rvb[l_ac].rvb051 = l_ima02    #FUN-940083 pmn041-->rvb051
       LET  g_rvb[l_ac].ima021 = l_ima021
       LET  g_rvb[l_ac].rvb90  = l_ima25    #FUN-940083
       LET  g_rvb[l_ac].rvb36  = l_ima35    #FUN-940083
       LET  g_rvb[l_ac].rvb37  = l_ima36    #FUN-940083
       #MOD-BA0069 add by suncx begin------------
       IF g_prog = 'apmt111' THEN
          IF cl_null(g_rvb[l_ac].rvb83) THEN
             LET g_rvb[l_ac].rvb83 = l_ima907
          END IF
          IF cl_null(g_rvb[l_ac].rvb80) THEN
             LET g_rvb[l_ac].rvb80 = l_ima25
          END IF
       END IF
       #MOD-BA0069 add by suncx end -------------
 
     END IF 
END FUNCTION        
 
FUNCTION t110_rvb89(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_pmh24   LIKE pmh_file.pmh24 
DEFINE l_pmhacti LIKE pmh_file.pmhacti
DEFINE l_pmc914  LIKE pmc_file.pmc914 
  
  LET g_errno =''
 
  SELECT pmh24,pmhacti INTO l_pmh24,l_pmhacti
    FROM pmh_file WHERE pmh01 = g_rvb[l_ac].rvb05
     AND pmh02 = g_rva.rva05
     AND pmh13 = g_rva.rva113
     AND pmh21 = ' '
     AND pmh22 = '1'
     AND pmh23 = ' '
  
  CASE WHEN SQLCA.sqlcode =100  LET g_errno ='mfg0031'
      OTHERWISE                 LET g_errno =SQLCA.sqlcode USING '------'
 
  END CASE 
 
  IF cl_null(g_errno) THEN
     LET g_rvb[l_ac].rvb89 = l_pmh24
  ELSE
     IF g_errno ='mfg0031' THEN
        SELECT pmc914 INTO l_pmc914 FROM pmc_file
         WHERE pmc01 = g_rva.rva05
           AND pmcacti='Y' 
        IF SQLCA.sqlcode THEN
           LET g_errno =SQLCA.sqlcode USING '------'
        ELSE 
           LET g_errno =''
           LET g_rvb[l_ac].rvb89 = l_pmc914
        END IF
     END IF
  END IF
 
  IF cl_null(g_errno) AND g_rvb[l_ac].rvb89 IS NOT NULL THEN
     IF g_rvb[l_ac].rvb89 = 'Y' THEN
        SELECT pmc915,pmc916 INTO g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37 FROM pmc_file
         WHERE pmc01 = g_rva.rva05
           AND pmcacti='Y' 
           
        IF SQLCA.sqlcode THEN
           LET g_errno =SQLCA.sqlcode USING '------'
           CALL cl_set_comp_entry("rvb36,rvb37",TRUE)     
        ELSE 
#FUN-AB0066 --begin--
#           #No.FUN-AA0049--begin
#           IF NOT s_chk_ware(g_rvb[l_ac].rvb36) THEN
#              LET g_rvb[l_ac].rvb36=' '
#              LET g_rvb[l_ac].rvb37=' '
#           ELSE 
#FUN-AB0066 --end--             	
              DISPLAY BY NAME g_rvb[l_ac].rvb36
              DISPLAY BY NAME g_rvb[l_ac].rvb37
              CALL cl_set_comp_entry("rvb36,rvb37",FALSE) 
#          END IF     #FUN-AB0066
           #No.FUN-AA0049--end                        
        END IF
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t110_rvb90(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gfeacti LIKE gfe_file.gfeacti  
 
  LET g_errno =''

#FUN-B90101--add--begin--
  IF g_azw.azw04='2' THEN             #TQC-C20117--add
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
      WHERE gfe01=g_rvbslk[l_ac2].rvbslk90 
#TQC-C20117--add----------begin----------------
  ELSE
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
      WHERE gfe01=g_rvb[l_ac].rvb90
  END IF
#TQC-C20117--add------------end-----------------
#FUN-B90101 add &endif 

  CASE WHEN SQLCA.sqlcode =100  LET g_errno ='mfg3098'
       WHEN l_gfeacti = 'N'     LET g_errno = '9028'
      OTHERWISE                 LET g_errno =SQLCA.sqlcode USING '------'
 
  END CASE 
 
  IF cl_null(g_errno) THEN
#FUN-B90101--add--begin--
   IF g_azw.azw04='2' THEN             #TQC-C20117--add    
      DISPLAY BY NAME g_rvbslk[l_ac2].rvbslk90
#TQC-C20117--add----------begin----------------
   ELSE
      DISPLAY BY NAME g_rvb[l_ac].rvb90   
   END IF
#TQC-C20117--add------------end-----------------
#FUN-B90101 add &endif
  END IF
 
END FUNCTION
 
FUNCTION t110_chk_rva05(p_rva01,p_rva05)
DEFINE   p_rva01        LIKE rva_file.rva01
DEFINE   p_rva05        LIKE rva_file.rva05
DEFINE   l_pmm09        LIKE pmm_file.pmm09
DEFINE   l_rvb04        LIKE rvb_file.rvb04

   IF g_argv6 ='2' THEN RETURN TRUE END IF #MOD-BC0068 add
 
   DECLARE t110_chk_rva05_cs CURSOR FOR
     SELECT rvb04 FROM rvb_file
      WHERE rvb01 = p_rva01
   FOREACH t110_chk_rva05_cs INTO l_rvb04
     LET l_pmm09 = NULL
     SELECT pmm09 INTO l_pmm09 FROM pmm_file 
      WHERE pmm01 = l_rvb04
     IF l_pmm09 <> p_rva05 OR cl_null(l_pmm09) THEN
        RETURN FALSE
     END IF
   END FOREACH
   RETURN TRUE
END FUNCTION

#MOD-C20091 -- mark start --
#FUNCTION t110_chk_rvb36()
#DEFINE l_ime12            LIKE ime_file.ime12
# 
#   LET g_errno = ' '
##FUN-B90101--add--begin--
#&ifdef SLK
#   IF g_azw.azw04='2' THEN             #TQC-C20117--add
#      IF cl_null(g_rvbslk[l_ac2].rvbslk36) OR cl_null(g_rvbslk[l_ac2].rvbslk37) THEN
#         RETURN
#      END IF
#
#
#      SELECT ime12 INTO l_ime12 FROM ime_file WHERE ime01 = g_rvbslk[l_ac2].rvbslk36
#                                                AND ime02 = g_rvbslk[l_ac2].rvbslk37
##TQC-C20117----add----------end--------------------------
#   ELSE
#      IF cl_null(g_rvb[l_ac].rvb36) OR cl_null(g_rvb[l_ac].rvb37) THEN
#         RETURN
#      END IF
#
#      SELECT ime12 INTO l_ime12 FROM ime_file WHERE ime01 = g_rvb[l_ac].rvb36
#                                             AND ime02 = g_rvb[l_ac].rvb37
#      IF SQLCA.SQLCODE THEN LET g_errno = SQLCA.SQLCODE END IF
#      IF g_rvb[l_ac].rvb89 = 'Y' THEN
#         IF l_ime12 = '0' THEN
#            LET g_errno = 'apm-329'
#         END IF
#      ELSE
#         IF l_ime12 = '1' THEN
#            LET g_errno = 'apm-309'
#         END IF
#      END IF
#   END IF
##TQC-C20117----add-------end--------------------------------
#&else
##FUN-B90101--add--end--
#   IF cl_null(g_rvb[l_ac].rvb36) OR cl_null(g_rvb[l_ac].rvb37) OR g_rvb[l_ac].rvb36 = 'MISC' THEN   #TQC-C30193
#      RETURN
#   END IF
# 
#   SELECT ime12 INTO l_ime12 FROM ime_file WHERE ime01 = g_rvb[l_ac].rvb36
#                                             AND ime02 = g_rvb[l_ac].rvb37
#   IF SQLCA.SQLCODE THEN LET g_errno = SQLCA.SQLCODE END IF
#   IF g_rvb[l_ac].rvb89 = 'Y' THEN
#      IF l_ime12 = '0' THEN
#         LET g_errno = 'apm-329'
#      END IF
#   ELSE
#      IF l_ime12 = '1' THEN
#         LET g_errno = 'apm-309'
#      END IF
#   END IF
#&endif
##FUN-B90101 add &endif
#END FUNCTION
#MOD-C20091 -- mark end --

FUNCTION t110_epr()
 DEFINE   l_cnt   LIKE   type_file.num5
 DEFINE   l_sum   LIKE   type_file.num5
 DEFINE   l_count LIKE   type_file.num5 
 DEFINE   li_m    LIKE   type_file.num5
 DEFINE   li_i    LIKE   type_file.num5
 DEFINE   i       LIKE   type_file.num5 
 DEFINE   l_pmc03 LIKE   pmc_file.pmc03
 DEFINE   l_sql   STRING 

 #FUN-9C0076 add str ---
 #送簽中不可執行[電子採購需求發佈]
  IF g_rva.rva32 matches '[Ss]' THEN
     CALL cl_err('','apm-030',0)
     RETURN
  END IF
 #FUN-9C0076 add end ---
 
  OPEN WINDOW p1101_w WITH FORM "apm/42f/apmt110_e"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apmt110_e")

  WHILE TRUE
    INPUT  g_pmc01  FROM  pmc01     
    
      AFTER FIELD pmc01
        IF NOT cl_null(g_pmc01) THEN
           LET l_count = 0
           SELECT COUNT(*) INTO l_count FROM pmc_file
            WHERE pmc01 = g_pmc01
           IF l_count = 0 THEN
              CALL cl_err('','apm1030',0)
              NEXT FIELD pmc01
           ELSE
              SELECT pmc03 INTO l_pmc03 FROM pmc_file
               WHERE pmc01 = g_pmc01
              DISPLAY l_pmc03 TO  pmc03
           END IF
 
        END IF
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmc01)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_pmc01" 
            LET g_qryparam.default1 = g_pmc01
            CALL cl_create_qry() RETURNING g_pmc01
            DISPLAY g_pmc01 TO  pmc01
            SELECT pmc03 INTO l_pmc03 FROM pmc_file 
             WHERE pmc01 = g_pmc01 
            DISPLAY l_pmc03 TO  pmc03 
            NEXT FIELD pmc01
         END CASE  
          
      ON ACTION cancel
         EXIT INPUT
         
    END INPUT
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       LET g_rva1.* = g_rva.*    #TQC-B30010 add 
       EXIT WHILE
    END IF    
    LET l_sql = " SELECT 'N',wpe01,wpe04,'',wpe02,wpe05,'','',wpe06 ",
                " FROM wpe_file ",
                " WHERE wpe03 = '",g_pmc01,"'  ",
                " ORDER BY wpe01 " CLIPPED
    PREPARE t110_e FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF

    DECLARE t110_wpe CURSOR FOR t110_e

    CALL g_wpe.clear()
    
    LET l_cnt=1
    LET g_cnt = 0
    FOREACH t110_wpe INTO g_wpe[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare_e:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      SELECT pmm04 INTO g_wpe[l_cnt].pmm04 FROM pmm_file
       WHERE pmm01 = g_wpe[l_cnt].wpe04
       
      SELECT pmn04,pmn041 INTO g_wpe[l_cnt].pmn04,g_wpe[l_cnt].pmn041 FROM pmn_file
       WHERE pmn01 = g_wpe[l_cnt].wpe04  AND pmn02 = g_wpe[l_cnt].wpe05    
        
      LET l_cnt = l_cnt+1
    END FOREACH  
    LET g_cnt = l_cnt-1
    CALL g_wpe.deleteElement(l_cnt)
    
    INPUT ARRAY g_wpe  WITHOUT DEFAULTS FROM s_wpe.*
       ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)

      ON ACTION cancel
         EXIT INPUT
  
      ON ACTION accept
         LET li_m = 0 
         FOR li_i =1 TO g_wpe.getLength()
             IF g_wpe[li_i].sel = 'Y' THEN
                LET li_m = li_m + 1
             END IF
         END FOR
         IF li_m = 0 THEN
           CALL cl_err("","apm1037",1)
         ELSE
            IF cl_confirm('apm1034') THEN EXIT INPUT END IF
         END IF
    END INPUT
    
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       LET g_rva1.* = g_rva.*    #TQC-B30010  ADD
       EXIT WHILE
    END IF  
    
    BEGIN WORK
    CALL s_showmsg_init()
    LET g_success = 'Y'
    LET l_sum = 1
    
    CALL t110_ins_rva()
    
    FOR i=1 TO g_cnt 
       IF g_wpe[i].sel = 'Y' THEN
          CALL t110_ins_rvb(i,l_sum)
          LET l_sum=l_sum+1
       END IF
    END FOR   

    IF g_success = 'N' THEN
       ROLLBACK WORK
       CALL s_showmsg()
    ELSE
       IF l_sum = 1 THEN 
          CALL cl_err('','apm1031',1)
          ROLLBACK WORK
       ELSE
          COMMIT WORK
          CALL cl_err('','apm1032',1)
          EXIT WHILE  
       END IF     
    END IF
  END WHILE 
    CLOSE WINDOW p1101_w            
    CALL t110_reshow()        #---NO.FUN-A10034----
END FUNCTION

FUNCTION t110_ins_rva()
 DEFINE   li_result   LIKE   type_file.num5
 DEFINE   l_rva01     LIKE   rva_file.rva01
 DEFINE   l_wpa08     LIKE   wpa_file.wpa08

  INITIALIZE g_rva1.* TO NULL
  LET g_rva1.rva00 = '1'
  LET g_rva1.rva02 = ' '
  LET g_rva1.rva04 = 'N'
  LET g_rva1.rva05 = g_pmc01
  LET g_rva1.rva06 = g_today
  LET l_wpa08 = ''
  SELECT wpa08 INTO l_wpa08 FROM wpa_file WHERE wpa01 = g_rva1.rva05 
  CALL s_auto_assign_no("apm",l_wpa08,g_rva1.rva06,"50","rva_file","rva01","","","")
      RETURNING li_result,l_rva01
  IF (NOT li_result) THEN
     CALL s_errmsg('','','','abm-621',1)                                                                                   
     LET g_success = 'N' 
  END IF
  LET g_rva1.rva01 = l_rva01
  LET g_rva1.rva10 = 'REG'
  LET g_rva1.rva29 = ' '
  LET g_rva1.rvaprsw = 'Y'
  LET g_rva1.rvaconf = 'N'
  LET g_rva1.rvaspc = '0'
  LET g_rva1.rvauser = g_user
  LET g_rva1.rvagrup = g_grup
  LET g_rva1.rvadate = g_today
  LET g_rva1.rvaacti = 'Y'
  LET g_rva1.rvaplant = g_plant
  LET g_rva1.rvalegal = g_legal
  LET g_rva1.rvaoriu = g_user      #No.FUN-980030 10/01/04
  LET g_rva1.rvaorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO rva_file VALUES (g_rva1.*)
  IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
     CALL s_errmsg('','','ins rva_file',SQLCA.sqlcode,1)                                                                                   
     LET g_success = 'N'   
  END IF   
END FUNCTION

FUNCTION t110_ins_rvb(p_i,p_sum)
 DEFINE   p_i       LIKE   type_file.num5
 DEFINE   p_sum     LIKE   type_file.num5
 DEFINE   l_pmn     RECORD LIKE pmn_file.*
 DEFINE   l_rvb1    RECORD LIKE rvb_file.*
 DEFINE   l_rvb87   LIKE   rvb_file.rvb87
 DEFINE   l_rvb29   LIKE   rvb_file.rvb29
 DEFINE   l_ima491  LIKE   ima_file.ima491
 DEFINE   l_img09   LIKE   img_file.img09
 DEFINE   l_flag    LIKE   type_file.num5
 DEFINE   l_fac     LIKE   rvb_file.rvb90_fac 
 DEFINE   l_rtz08   LIKE   rtz_file.rtz08       #FUN-B40098
 DEFINE   l_rtz07   LIKE   rtz_file.rtz07       #FUN-B60150 ADD
 DEFINE   l_rvbi1      RECORD LIKE rvbi_file.*    #CHI-B70016

   INITIALIZE l_rvb1.* TO NULL
   INITIALIZE l_pmn.* TO NULL
   SELECT * INTO l_pmn.* FROM pmn_file 
    WHERE pmn01 = g_wpe[p_i].wpe04 
      AND pmn02 = g_wpe[p_i].wpe05 
   LET l_rvb1.rvb01 = g_rva1.rva01
   LET l_rvb1.rvb02 = p_sum
   LET l_rvb1.rvb03 = l_pmn.pmn02
   LET l_rvb1.rvb04 = l_pmn.pmn01
   LET l_rvb1.rvb05 = l_pmn.pmn04
   LET l_rvb1.rvb06 = 0
   LET l_rvb1.rvb90 = l_pmn.pmn07
   LET l_rvb87 = 0
   LET l_rvb29 = 0
   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02
      AND rva01 = rvb01 AND rvaconf = 'N' AND rvb01 = g_rva1.rva01
       
   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
   
   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02  
      AND rva01 = rvb01 AND rvaconf = 'N' AND rvb01 = g_rva1.rva01

   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
   
   IF cl_null(l_pmn.pmn20) THEN LET l_pmn.pmn20 = 0 END IF 
   IF cl_null(l_pmn.pmn50) THEN LET l_pmn.pmn50 = 0 END IF
   IF cl_null(l_pmn.pmn55) THEN LET l_pmn.pmn55 = 0 END IF  
   IF cl_null(l_pmn.pmn31) THEN LET l_pmn.pmn31 = 0 END IF

   LET l_rvb1.rvb07 = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55-l_rvb87+l_rvb29
   IF  l_rvb1.rvb07 > g_wpe[p_i].wpe06 THEN
       LET l_rvb1.rvb07 = g_wpe[p_i].wpe06
   END IF  
   LET l_rvb1.rvb08 = l_rvb1.rvb07
   LET l_rvb1.rvb09 = 0
   LET l_rvb1.rvb10 = l_pmn.pmn31
   LET l_rvb1.rvb10t = l_pmn.pmn31t 
 
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = l_rvb1.rvb05
   IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF  
   
   IF l_ima491 >0 THEN
      CALL s_getdate(g_rva1.rva06,l_ima491) RETURNING l_rvb1.rvb12
   ELSE
      IF cl_null(l_rvb1.rvb12)  THEN
        LET l_rvb1.rvb12 = g_rva1.rva06
      END IF
   END IF
   LET l_rvb1.rvb13 = NULL
   LET l_rvb1.rvb14 = NULL
   LET l_rvb1.rvb15 = 0
   LET l_rvb1.rvb16 = 0
   LET l_rvb1.rvb17 = NULL
   LET l_rvb1.rvb18 = '10'
   LET l_rvb1.rvb19 = l_pmn.pmn65
   LET l_rvb1.rvb20 = NULL
   LET l_rvb1.rvb21 = NULL
   LET l_rvb1.rvb25 = l_pmn.pmn71
   LET l_rvb1.rvb27 = 0
   LET l_rvb1.rvb28 = 0
   LET l_rvb1.rvb29 = 0
   LET l_rvb1.rvb30 = 0
   LET l_rvb1.rvb31 = l_rvb1.rvb07
   LET l_rvb1.rvb32 = 0 
   LET l_rvb1.rvb33 = 0
   LET l_rvb1.rvb331 = 0
   LET l_rvb1.rvb332 = 0
   LET l_rvb1.rvb34 = l_pmn.pmn41
   LET l_rvb1.rvb35 = 'N'
   LET l_rvb1.rvb89 = l_pmn.pmn89
   LET l_rvb1.rvb051 = l_pmn.pmn041
   LET l_rvb1.rvb90 = l_pmn.pmn07
   LET l_rvb1.rvb31 = s_digqty(l_rvb1.rvb31,l_rvb1.rvb90)   #No.FUN-BB0086
   
   IF l_rvb1.rvb89 = 'Y'  THEN
     SELECT pmc915,pmc916 INTO l_rvb1.rvb36,l_rvb1.rvb37
      FROM pmc_file  WHERE pmc01 = l_rvb1.rvb05
   ELSE
     LET l_rvb1.rvb36 = l_pmn.pmn52
     LET l_rvb1.rvb37 = l_pmn.pmn54
     IF cl_null(l_rvb1.rvb36) AND cl_null(l_rvb1.rvb37)  THEN
        SELECT ima35,ima36 INTO l_rvb1.rvb36,l_rvb1.rvb37
          FROM ima_file WHERE ima01 = l_rvb1.rvb05
     END IF    
   #FUN-B60150 ADD&MARK BEGIN -------------------------------
   ##FUN-B40098 Begin---
   # IF g_azw.azw04 = '2' AND g_rva1.rva29 = '3' THEN
   #    SELECT rtz08 INTO l_rtz08 FROM rtz_file
   #     WHERE rtz01 = g_rva1.rvaplant
   #    IF NOT cl_null(l_rtz08) THEN
   #       LET l_rvb1.rvb36 = l_rtz08
   #       LET l_rvb1.rvb37 = ' '
   #       LET l_rvb1.rvb38 = ' '
   #    END IF
   # END IF
   ##FUN-B40098 End-----
     IF g_azw.azw04 = '2' THEN
        #FUN-C90049 mark beign---
        #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
        # WHERE rtz01 = g_rva1.rvaplant
        #FUN-C90049 mark end-----
        CALL s_get_defstore(g_rva1.rvaplant,l_rvb1.rvb05) RETURNING  l_rtz07,l_rtz08   #FUN-C90049 add
        IF g_rva1.rva29 = '3' OR (g_rva1.rva29 = '2' AND g_sma.sma146 = '2') THEN
           IF NOT cl_null(l_rtz08) THEN
              LET l_rvb1.rvb36 = l_rtz08
              LET l_rvb1.rvb37 = ' '
              LET l_rvb1.rvb38 = ' '
           END IF
        END IF
        IF g_rva1.rva29 = '2' AND g_sma.sma146 = '1' THEN
           IF NOT cl_null(l_rtz07) THEN
              LET l_rvb1.rvb36 = l_rtz07
              LET l_rvb1.rvb37 = ' '
              LET l_rvb1.rvb38 = ' '
           END IF
        END IF
     END IF
   #FUN-B60150 ADD&MARK  END  -------------------------------
   END IF
#FUN-AB0066 --begin--   
#   #No.FUN-AA0049--begin
#   IF NOT s_chk_ware(l_rvb1.rvb36) THEN
#      LET l_rvb1.rvb36=' '
#      LET l_rvb1.rvb37=' '
#   END IF 
#   #No.FUN-AA0049--end     
#FUN-AB0066 --end--   
   LET l_rvb1.rvb38 = l_pmn.pmn56
   IF l_rvb1.rvb38 IS NULL THEN
      LET l_rvb1.rvb38 = ' '
   END IF
   IF l_rvb1.rvb37 IS NULL THEN
      LET l_rvb1.rvb37 = ' '
   END IF   
   
   CALL t110_get_rvb39(l_rvb1.rvb03,l_rvb1.rvb04,l_rvb1.rvb05,l_rvb1.rvb19,g_rva.rva05,g_sma.sma886) 
        RETURNING l_rvb1.rvb39
        
   LET l_rvb1.rvb40 = ' '
   LET l_rvb1.rvb80 = l_pmn.pmn80
   LET l_rvb1.rvb81 = l_pmn.pmn81
   LET l_rvb1.rvb82 = l_pmn.pmn82
   LET l_rvb1.rvb83 = l_pmn.pmn83
   LET l_rvb1.rvb84 = l_pmn.pmn84
   LET l_rvb1.rvb85 = l_pmn.pmn85
   LET l_rvb1.rvb86 = l_pmn.pmn86
   LET l_rvb1.rvb87 = l_rvb1.rvb07
   LET l_rvb1.rvb88 = l_rvb1.rvb87*l_rvb1.rvb10
   LET l_rvb1.rvb88t = l_rvb1.rvb87*l_rvb1.rvb10t
   LET l_rvb1.rvb930 = l_pmn.pmn930
   LET l_rvb1.rvbplant = g_plant
   LET l_rvb1.rvblegal = g_legal
   LET l_rvb1.rvb42 = ' '
   LET l_rvb1.rvb93 =  g_wpe[p_i].wpe01   
   INSERT INTO rvb_file VALUES (l_rvb1.*)
   IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
      CALL s_errmsg('','','ins rvb_file',SQLCA.sqlcode,1)                                                                                   
      LET g_success = 'N'   
   ELSE
#CHI-B70016-add-str--
      LET l_rvbi1.rvbi01 = l_rvb1.rvb01
      LET l_rvbi1.rvbi02 = l_rvb1.rvb02
      IF NOT s_ins_rvbi(l_rvbi1.*,'') THEN
         LET g_success = 'N'
      END IF
#CHI-B70016-add-end--
      UPDATE wpe_file SET wpe07 = 'Y' 
       WHERE wpe01 =  g_wpe[p_i].wpe01
      IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
         CALL s_errmsg('','','upd wpe_file',SQLCA.sqlcode,1)                                                                                   
         LET g_success = 'N'   
      END IF   
   END IF      
END FUNCTION

#FUN-BC0104-add-str---
FUNCTION t110_qc_item()
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sure       LIKE type_file.chr1
DEFINE l_qcs14      LIKE qcs_file.qcs14
DEFINE l_msg        STRING
DEFINE l_qck09      LIKE qck_file.qck09

   IF cl_null(g_rva.rva01) THEN
      CALL cl_err('','aqc-334',1)
      RETURN
   END IF
   SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
    WHERE qck01=ima109
      AND ima01=g_rvb[l_ac].rvb05
   IF l_qck09 = 'N' THEN
      RETURN
   END IF
   IF g_rva.rvaconf !='Y' THEN 
      CALL cl_err('','aap-717',0)
      RETURN
   END IF
  
   LET l_sure = 'Y'
   LET l_n = 0 
   LET l_cnt =  ARR_CURR()
   SELECT COUNT(*) INTO l_n FROM qcs_file
    WHERE qcs01 = g_rva.rva01
   #  AND qcs02 = g_rvb[l_ac].rvb02   #MOD-C30349 mark
   IF l_n < 1 THEN 
      CALL cl_err('','aqc-532',1)
      RETURN    
   END IF

#MOD-C30349 -------------Begin--------------
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_rva.rva01
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF 
   IF l_n < 1 THEN
      CALL cl_err('','aqc-532',1)
      RETURN
   END IF      
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qcs_file,qco_file
    WHERE qcs01 = qco01
      AND qcs02 = qco02
      AND qcs05 = qco05
      AND qco11 > qco20
      AND qcs01 = g_rva.rva01
      AND qcs14 = 'Y'  
   IF cl_null(l_n) THEN LET l_n = 0 END IF
   IF l_n < = 0 THEN
      CALL cl_err('','aqc-100',1)
      RETURN
   END IF 
#MOD-C30349 -------------End----------------

#MOD-C30349 -------------Begin--------------
#  DECLARE qc_item CURSOR FOR
#   SELECT qcs14 FROM qcs_file 
#    WHERE qcs01 = g_rva.rva01
#      AND qcs02 = g_rvb[l_ac].rvb02
#  FOREACH qc_item INTO l_qcs14
#     IF l_qcs14 != 'Y' THEN 
#        LET l_sure = 'N'
#        EXIT FOREACH
#     END IF  
#  END FOREACH
#  IF l_sure = 'N' THEN
#     CALL cl_err('','aqc-534',1)
#     RETURN
#  END IF
#MOD-C30349 -------------End---------------

   IF cl_confirm("aqc-401") THEN   #TQC-C20521 add
   #  LET l_msg = "aqcp107 '1' '' '' '",g_today,"' '' '' '",g_rva.rva01,"' '",g_rvb[l_cnt].rvb05,"' '' 'Y'"  #TQC-C30195 mark
      LET l_msg = "aqcp107 '1' '' '' '",g_today,"' '' '' '",g_rva.rva01,"' '' '' 'Y'"     #TQC-C30195  
      CALL cl_cmdrun(l_msg)
     #MESSAGE ' O.K '      #TQC-C40027 add  #TQC-C40060 mark
   END IF   #TQC-C20521 add 
END FUNCTION 
#FUN-BC0104--add--end----


FUNCTION t110_reshow()
   INITIALIZE g_rva.* TO NULL
   LET g_rva.* = g_rva1.*
   CALL t110_show()
END FUNCTION
#No:FUN-9C0071 -------------------------- 精简程式------------------------

#FUN-9C0076 add str ---
FUNCTION t110_ef()
     #CALL t110sub_y_chk(g_rva.rva01,g_argv5,g_argv2,g_argv6)  #CALL 原確認的 check 段#FUN-A10130 #CHI-C30118 mark
     CALL t110sub_y_chk(g_rva.rva01,FALSE,'Y',g_argv5,g_argv2,g_rvu03_flag,g_argv6)  #CHI-C30118 add

     IF g_success = "N" THEN
         RETURN
     END IF

     CALL aws_condition()                     #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF

  ##########
  # CALL aws_efcli2()
  # 傳入參數: (1)單頭資料, (2-6)單身資料
  # 回傳值  : 0 開單失敗; 1 開單成功
  ##########
   IF aws_efcli2(base.TypeInfo.create(g_rva),base.TypeInfo.create(g_rvb),'','','','')
   THEN
       LET g_success='Y'
       LET g_rva.rva32='S'
       DISPLAY BY NAME g_rva.rva32
   ELSE
       LET g_success='N'
   END IF
END FUNCTION
#FUN-9C0076 add end ---

#FUN-9C0076 add str ---
FUNCTION t110_refresh()
 DEFINE l_rva RECORD LIKE rva_file.*

 SELECT * INTO l_rva.* FROM rva_file WHERE rva01=g_rva.rva01
 RETURN l_rva.*
END FUNCTION
#FUN-9C0076 add end ---

#FUN-9C0076 add str ------
FUNCTION t110_rva33(p_cmd)  #申請人編號
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '

    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_rva.rva33
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='mfg1312'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
#FUN-9C0076 add end -----




FUNCTION t110_pic()
   IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                    #確認碼
   IF g_rva.rva32='1' OR g_rva.rva32='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF #狀況碼
   CALL cl_set_field_pic(g_rva.rvaconf,g_chr2,""  ,""  ,g_chr,""   )
                         #確認碼      ,核准  ,過帳,結案,作廢 ,有效
END FUNCTION

#FUN-CB0014---add---str---
FUNCTION t110_list_fill()
  DEFINE l_rva01         LIKE rva_file.rva01
  DEFINE l_i             LIKE type_file.num10

    CALL g_rva_l.clear()
    LET l_i = 1
    FOREACH t110_fill_cs INTO l_rva01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT rva01,rva06,rva02,rva05,pmc03,rva04,rva21,rva08,
              rva09,rva10,rvaconf,rvacond,rvaconu,'',rva29,
              rva33,'',rvamksg,rva32
         INTO g_rva_l[l_i].*
         FROM rva_file
              LEFT OUTER JOIN pmc_file ON rva05 = pmc01
        WHERE rva01=l_rva01
       SELECT gen02 INTO  g_rva_l[l_i].rvaconu_desc
         FROM gen_file
        WHERE gen01 = g_rva_l[l_i].rvaconu
       SELECT gen02 INTO  g_rva_l[l_i].gen02
         FROM gen_file
        WHERE gen01 = g_rva_l[l_i].rva33
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_rva_l TO s_rva_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t110_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)

  DEFINE l_i        LIKE type_file.num5,
         l_index    LIKE type_file.num5,
         li_a       LIKE type_file.chr1
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("rvaspc",FALSE)
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_rva_l TO s_rva_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index) 
          CALL cl_navigator_setting( g_curs_index, g_row_count )  
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()
          
      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t110_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info,Page4,userdefined_field", FALSE) 
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
        #CALL cl_set_comp_visible("info,Page4,userdefined_field", TRUE) #MOD-D30148 mark
        #MOD-D30148 add start -----
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         IF g_argv6 ='2' THEN
           CALL cl_set_comp_visible("Page4", TRUE)
         END IF
        #MOD-D30148 add end   -----
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t110_fetch('/')
         CALL cl_set_comp_visible("info,Page4,userdefined_field", FALSE) 
        #CALL cl_set_comp_visible("info,Page4,userdefined_field", TRUE)  #MOD-D30148 mark
        #MOD-D30148 add start -----
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         IF g_argv6 ='2' THEN
           CALL cl_set_comp_visible("Page4", TRUE)
         END IF
        #MOD-D30148 add end   -----
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_list", TRUE)    
         EXIT DISPLAY
        

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
      ON ACTION first
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#TQC-D10084---mark---str---- 
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end----
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION qc
         LET g_action_choice="qc"
         EXIT DISPLAY

      ON ACTION qry_qc #查詢QC單 
         LET g_action_choice="qry_qc"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t110_mu_ui()   #TQC-710032
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
        
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

#@    ON ACTION 補登發票
      ON ACTION add_invoice
         LET g_action_choice="add_invoice"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025 add
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025 add         
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 檢驗狀況
      ON ACTION qc_status
         LET g_action_choice="qc_status"
         EXIT DISPLAY
#FUN-CC0011 mark begin---
##FUN-BC0104 ------add----str---------------
##@    ON ACTION QC料件判定產生入庫單
#      ON ACTION qc_item_tran_store
#         LET g_action_choice="qc_item_tran_store"
#         EXIT DISPLAY
##FUN-BC0104 ------add----end---------------
#FUN-CC0011 mark end-----
#@    ON ACTION 產生入庫/驗退
      ON ACTION generate_st_in_qc_return
         IF t110_qc_ck() THEN                                  #FUN-CC0011 add
            LET g_action_choice="qc_item_tran_store"           #FUN-CC0011 add
         ELSE                                                  #FUN-CC0011 add
            LET g_action_choice="generate_st_in_qc_return"
         END IF                                                #FUN-CC0011 add
         EXIT DISPLAY
#@    ON ACTION 查詢入庫
      ON ACTION qry_st_in
         LET g_action_choice="qry_st_in"
         EXIT DISPLAY
#@    ON ACTION 查詢驗退
      ON ACTION qry_qc_return
         LET g_action_choice="qry_qc_return"
         EXIT DISPLAY
#@    ON ACTION 驗收狀況
      ON ACTION receiving
         LET g_action_choice="receiving"
         EXIT DISPLAY

    #FUN-9C0076 add str ---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
    #FUN-9C0076 add end ---
 
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680011
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION e_proc_require
         LET g_action_choice = 'e_proc_require'
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
         
      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DISPLAY

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DISPLAY

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DISPLAY
      #DEV-D30045--add--end

      &include "qry_string.4gl"
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#FUN-CB0014---add---end---

#FUN-CC0011 add begin---
FUNCTION t110_qc_ck()
   DEFINE l_cnt LIKE type_file.num5

   IF g_qcz.qcz14 = 'Y' THEN
     #MOD-D20137 add start -----
      SELECT COUNT(*) INTO l_cnt
        FROM rvb_file
       WHERE rvb01 = g_rva.rva01
         AND rvb39 = 'Y'
         AND (rvb40 IS NULL OR rvb40 = '')
      IF l_cnt = 0 THEN
         RETURN FALSE 
      ELSE
     #MOD-D20137 add end   -----
         RETURN TRUE
      END IF #MOD-D20137 add
   ELSE
      IF cl_null(g_rva.rva01) THEN
         CALL cl_err('','aqc-334',1)
         RETURN
      END IF
     
      SELECT COUNT(*) INTO l_cnt FROM qco_file WHERE qco01 = g_rva.rva01

      IF l_cnt = 0 THEN
         RETURN FALSE
      ELSE
         RETURN TRUE
      END IF

   END IF 
END FUNCTION 
#FUN-CC0011 add end-----

#MOD-CB0079 -- add start #程式段搬移--
FUNCTION t110_chk_rvb04(p_cmd)
DEFINE l_pmm51     LIKE pmm_file.pmm51
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_pmn14     LIKE pmn_file.pmn14
DEFINE l_n1,l_n2   LIKE type_file.num5
DEFINE l_times     LIKE sma_file.sma134
DEFINE l_poz011    LIKE poz_file.poz011
DEFINE l_num       LIKE type_file.num5
DEFINE l_pmm904    LIKE pmm_file.pmm904
DEFINE l_pmm50     LIKE pmm_file.pmm50

   IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
      CALL t110_po(g_rvb[l_ac].rvb04,'b')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
        #NEXT FIELD rvb04      #MOD-CB0079 mark
         RETURN FALSE          #MOD-CB0079 add
      END IF
      IF g_azw.azw04='2' THEN
         SELECT pmm51 INTO l_pmm51 FROM pmm_file
              WHERE pmm01 = g_rvb[l_ac].rvb04
         IF l_pmm51 != g_rva.rva29 THEN
            CALL cl_err('','apm-925',0)
           #NEXT FIELD rvb04      #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
      END IF
      IF p_cmd = 'a' OR (p_cmd ='u' AND
                     (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
                      g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) AND
                      NOT cl_null(g_rvb[l_ac].rvb03)) THEN
         IF NOT cl_null(g_rvb[l_ac].rvb03) THEN              #No.FUN-810016
            CALL t110_rvb03('a',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
            IF g_rvb[l_ac].rvb07 <=0 THEN
               IF NOT cl_confirm('mfg3353') THEN
                  LET g_rvb[l_ac].rvb04 = g_rvb_t.rvb04
                 #NEXT FIELD rvb04      #MOD-CB0079 mark
                  RETURN FALSE          #MOD-CB0079 add
               END IF
            END IF
         END IF                                              #No.FUN-810016
         IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
         LET g_rvb2.rvb10 = g_pmn31
         LET g_rvb[l_ac].rvb10 = g_pmn31
         DISPLAY g_rvb[l_ac].rvb10 TO rvb10
         LET g_rvb2.rvb10t = g_pmn31t
         LET g_rvb[l_ac].rvb10t = g_pmn31t
         DISPLAY g_rvb[l_ac].rvb10t TO rvb10t
         IF NOT cl_null(g_errno) THEN
            IF g_errno = 'mfg0159' THEN
              #NEXT FIELD rvb04      #MOD-CB0079 mark
               RETURN FALSE          #MOD-CB0079 add
            ELSE
               CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
              #NEXT FIELD rvb04      #MOD-CB0079 mark
               RETURN FALSE          #MOD-CB0079 add
            END IF
         END IF
         #不能部份交貨且已有交貨量則不允許通過
         IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
            CALL cl_err('','mfg3339',0)
           #NEXT FIELD rvb04      #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
         IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04)  THEN   #No.MOD-840575
            IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
               SELECT * FROM alt_file
                WHERE alt01=g_rvb[l_ac].rvb22
                  AND alt14=g_rvb[l_ac].rvb04
                  AND alt15=g_rvb[l_ac].rvb03
               IF SQLCA.sqlcode=100 THEN
                  CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
                  LET g_rvb[l_ac].rvb04= g_rvb_t.rvb04            #No.MOD-840575
                 #NEXT FIELD rvb04      #MOD-CB0079 mark
                  RETURN FALSE          #MOD-CB0079 add
               END IF
            END IF
         END IF  #No.MOD-840575
         IF g_azw.azw04='2' THEN
            SELECT pmn14 INTO l_pmn14 FROM pmn_file
                WHERE pmn01 = g_rvb[l_ac].rvb04
                  AND pmn02 = g_rvb[l_ac].rvb03
            IF l_pmn14 = 'Y' THEN
               SELECT COUNT(*) INTO l_n1  #非本收货单上数量
                  FROM rvb_file,rva_file
                 WHERE rvb04 = g_rvb[l_ac].rvb04
                   AND rvb03 = g_rvb[l_ac].rvb03
                   AND rva01 = rvb01
                   AND rva01 != g_rva.rva01
                   AND rvaconf <> 'X'
               SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
                  FROM rvb_file,rva_file
                 WHERE rvb04 = g_rvb[l_ac].rvb04
                   AND rvb03 = g_rvb[l_ac].rvb03
                   AND rva01 = rvb01
                   AND rva01 = g_rva.rva01
                   AND rvb02 != g_rvb[l_ac].rvb02
                   AND rvaconf <> 'X'
               LET l_n = l_n1 + l_n2
               SELECT sma134 INTO l_times FROM sma_file
               IF l_times IS NULL THEN LET l_times = 0 END IF
               #收貨次數是否已經超過參數設定的總次數
               IF l_n >= l_times THEN
                  CALL cl_err('','apm-932',0)
                 #NEXT FIELD rvb04      #MOD-CB0079 mark
                  RETURN FALSE          #MOD-CB0079 add
               END IF
            END IF
            CALL t110_get_price()
         END IF
      END IF
      ###### 避免三角收貨到一般採購或逆拋三角
      IF g_argv2 = 'TAP' THEN
         SELECT poz011 INTO l_poz011
           FROM pmm_file,poz_file
          WHERE pmm904 = poz01
            AND pmm01 = g_rvb[l_ac].rvb04
            AND pmm901 = 'Y'         #三角貿易否
            AND pmm905 = 'Y'         #已拋轉
            AND pmm02  = 'TAP'       #代採買性質
            AND pmm906 = 'Y'         #來源單據
         IF SQLCA.sqlcode THEN
            LET l_poz011 = ''
         END IF
         IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
            CALL cl_err(g_rva.rva02,'apm-014',0)
           #NEXT FIELD rvb04      #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         #----- 必須同一流程代碼 ----
         LET l_num =0
         DECLARE t110_chk1 CURSOR FOR
             SELECT pmm904 , pmm50
               FROM rvb_file,pmm_file
              WHERE rvb04 = pmm01
                AND rvb01 = g_rva.rva01
         FOREACH t110_chk1 INTO l_pmm904,l_pmm50
            IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
            LET l_num = l_num+1
            IF NOT cl_null(l_pmm904) THEN
               EXIT FOREACH
            END IF
         END FOREACH
         IF cl_null(l_pmm50) THEN LET l_pmm50=' ' END IF  #MOD-850093 add
         IF l_pmm904 <> g_pmm904 AND l_num > 0 THEN
            CALL cl_err('','axm-501',0)
           #NEXT FIELD rvb04      #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         IF l_pmm50  <> g_pmm50 AND l_num > 0 THEN #no.6113
            CALL cl_err('','apm-993',0)
           #NEXT FIELD rvb04      #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
      END IF
   END IF

   RETURN TRUE   #MOD-CB0079 add

END FUNCTION

FUNCTION t110_chk_rvbslk04(p_cmd)
DEFINE l_pmm51     LIKE pmm_file.pmm51
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_n1,l_n2   LIKE type_file.num5
DEFINE l_pmm904    LIKE pmm_file.pmm904
DEFINE l_pmm50     LIKE pmm_file.pmm50
DEFINE l_poz011    LIKE poz_file.poz011
DEFINE l_num       LIKE type_file.num5
DEFINE l_times     LIKE sma_file.sma134
DEFINE l_ima151    LIKE ima_file.ima151
DEFINE l_imaag     LIKE ima_file.imaag
DEFINE l_count     LIKE type_file.num5

   IF NOT cl_null(g_rvbslk[l_ac2].rvbslk04) THEN
      IF g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR g_rvbslk_t.rvbslk04 IS NULL THEN     
         CALL t110_po(g_rvbslk[l_ac2].rvbslk04,'b')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_rvbslk[l_ac2].rvbslk04,g_errno,0)
            LET g_rvbslk[l_ac2].rvbslk04 = g_rvbslk_t.rvbslk04   #MOD-C30434 -- add
           #NEXT FIELD rvbslk04   #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         IF g_azw.azw04='2' THEN
            SELECT pmm51 INTO l_pmm51 FROM pmm_file 
                 WHERE pmm01 = g_rvbslk[l_ac2].rvbslk04
            IF l_pmm51 != g_rva.rva29 THEN
               CALL cl_err('','apm-925',0)
              #NEXT FIELD rvbslk04   #MOD-CB0079 mark
               RETURN FALSE          #MOD-CB0079 add
            END IF     
         END IF
      END IF   
      IF p_cmd = 'a' OR (p_cmd ='u' AND
                     (g_rvbslk[l_ac2].rvbslk04 != g_rvbslk_t.rvbslk04 OR
                      g_rvbslk[l_ac2].rvbslk03 != g_rvbslk_t.rvbslk03) AND
                NOT cl_null(g_rvbslk[l_ac2].rvbslk03)) THEN
         IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) THEN              #No.FUN-810016     
            SELECT COUNT(*) INTO l_n1  #非本收货单上数量
             FROM rvbslk_file,rva_file
            WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
              AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
              AND rva01 = rvbslk01
              AND rva01 != g_rva.rva01
              AND rvaconf <> 'X'
            SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
               FROM rvbslk_file,rva_file
              WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
                AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03
                AND rva01 = rvbslk01
                AND rva01 = g_rva.rva01
                AND rvbslk02 != g_rvbslk[l_ac2].rvbslk02
                AND rvaconf <> 'X'
            LET l_n = l_n1 + l_n2

            SELECT sma134 INTO l_times FROM sma_file
            IF l_n >= l_times THEN
               CALL cl_err('','apm-932',0)
              #NEXT FIELD rvbslk04   #MOD-CB0079 mark
               RETURN FALSE          #MOD-CB0079 add
            END IF
            CALL t110_rvbslk03('a',g_rvbslk[l_ac2].rvbslk04,g_rvbslk[l_ac2].rvbslk03)    #TQC-C20117--add
            IF g_rvbslk[l_ac2].rvbslk07 < 0 THEN
               IF NOT cl_confirm('mfg3353') THEN
                  LET g_rvbslk[l_ac2].rvbslk04 = g_rvbslk_t.rvbslk04
                 #NEXT FIELD rvbslk04   #MOD-CB0079 mark
                  RETURN FALSE          #MOD-CB0079 add
               END IF
            END IF
            CALL t110_ins_rvb_b()
            IF NOT cl_null(g_rvbslk[l_ac2].rvbslk05) THEN
               SELECT ima021 INTO g_rvbslk[l_ac2].ima021a FROM ima_file
                  WHERE ima01 = g_rvbslk[l_ac2].rvbslk05     
               CALL s_settext_slk(g_rvbslk[l_ac2].rvbslk05)
               CALL s_fillimx_slk(g_rvbslk[l_ac2].rvbslk05,
                                  g_rva.rva01,g_rvbslk[l_ac2].rvbslk02)
               LET g_rec_b3 = g_imx.getLength()
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01 = g_rvbslk[l_ac2].rvbslk05
               IF l_ima151 = 'Y' THEN
                  CALL cl_set_comp_entry("rvbslk07",FALSE)
               ELSE
                  CALL cl_set_comp_entry("rvbslk07",TRUE)
               END IF
               SELECT SUM(rvb07) INTO l_count FROM rvb_file WHERE rvb01=g_rva.rva01
               DISPLAY l_count TO FORMONLY.qty
            END IF
         END IF                                              #No.FUN-810016   
        #IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
        #LET g_rvbslk2.rvbslk10 = g_pmn31
        #LET g_rvbslk[l_ac2].rvbslk10 = g_pmn31
        #DISPLAY g_rvbslk[l_ac2].rvbslk10 TO rvbslk10
        #LET g_rvbslk2.rvbslk10t = g_pmn31t
        #LET g_rvbslk[l_ac2].rvbslk10t = g_pmn31t
        #DISPLAY g_rvbslk[l_ac2].rvbslk10t TO rvbslk10t
        #IF NOT cl_null(g_errno) THEN
        #   IF g_errno = 'mfg0159' THEN
        #      NEXT FIELD rvbslk04
        #   ELSE
        #      CALL cl_err(g_rvbslk[l_ac2].rvbslk04,g_errno,0)
        #      NEXT FIELD rvbslk04
        #   END IF
        #END IF
         #不能部份交貨且已有交貨量則不允許通過
         IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
            CALL cl_err('','mfg3339',0)
           #NEXT FIELD rvbslk04   #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
       # #--- 若為L/C收貨則輸入之PO及項次必須存在提單檔
       # IF NOT cl_null(g_rvbslk[l_ac2].rvbslk03) AND NOT cl_null(g_rvbslk[l_ac2].rvbslk04)  THEN   #No.MOD-840575 
       #  IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
       #    SELECT * FROM alt_file
       #     WHERE alt01=g_rvbslk[l_ac2].rvbslk22
       #       AND alt14=g_rvbslk[l_ac2].rvbslk04
       #       AND alt15=g_rvbslk[l_ac2].rvbslk03
       #    IF SQLCA.sqlcode=100 THEN
       #       CALL cl_err3("sel","alt_file",g_rvbslk[l_ac2].rvbslk22,"","apm-304","","",1) #No.FUN-660129
       #       LET g_rvbslk[l_ac2].rvbslk04= g_rvbslk_t.rvbslk04            #No.MOD-840575 
       #       NEXT FIELD rvbslk04                               #No.MOD-840575 
       #     END IF
       #  END IF
       # END IF  #No.MOD-840575 
       #IF g_azw.azw04='2' THEN
       #   SELECT pmn14 INTO l_pmn14 FROM pmn_file 
       #       WHERE pmn01 = g_rvbslk[l_ac2].rvbslk04
       #         AND pmn02 = g_rvbslk[l_ac2].rvbslk03
       #   IF l_pmn14 = 'Y' THEN
       #      SELECT COUNT(*) INTO l_n1  #非本收货单上数量
       #         FROM rvbslk_file,rva_file 
       #        WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
       #          AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03 
       #          AND rva01 = rvbslk01
       #          AND rva01 != g_rva.rva01
       #          AND rvaconf <> 'X'
       #      SELECT COUNT(*) INTO l_n2  #本收货单上非本项次数量
       #         FROM rvbslk_file,rva_file 
       #        WHERE rvbslk04 = g_rvbslk[l_ac2].rvbslk04
       #          AND rvbslk03 = g_rvbslk[l_ac2].rvbslk03 
       #          AND rva01 = rvbslk01
       #          AND rva01 = g_rva.rva01
       #          AND rvbslk02 != g_rvbslk[l_ac2].rvbslk02
       #          AND rvaconf <> 'X'
       #      LET l_n = l_n1 + l_n2
       #      SELECT sma134 INTO l_times FROM sma_file
       #      IF l_times IS NULL THEN LET l_times = 0 END IF
       #      #收貨次數是否已經超過參數設定的總次數
       #      IF l_n >= l_times THEN
       #         CALL cl_err('','apm-932',0)
       #         NEXT FIELD rvbslk04
       #      END IF
       #   END IF
       #   CALL t110_get_price()
       # END IF
      END IF
      ###### 避免三角收貨到一般採購或逆拋三角
      IF g_argv2 = 'TAP' THEN
         SELECT poz011 INTO l_poz011
           FROM pmm_file,poz_file
          WHERE pmm904 = poz01
            AND pmm01 = g_rvbslk[l_ac2].rvbslk04
            AND pmm901 = 'Y'         #三角貿易否
            AND pmm905 = 'Y'         #已拋轉
            AND pmm02  = 'TAP'       #代採買性質
            AND pmm906 = 'Y'         #來源單據
         IF SQLCA.sqlcode THEN
            LET l_poz011 = ''
         END IF
         IF cl_null(l_poz011) OR l_poz011 <> '1' THEN
            CALL cl_err(g_rva.rva02,'apm-014',0)
           #NEXT FIELD rvbslk04  #No.9525   #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         #----- 必須同一流程代碼 ----
         LET l_num =0
         DECLARE t110_chk2 CURSOR FOR
             SELECT pmm904 , pmm50
               FROM rvbslk_file,pmm_file
              WHERE rvbslk04 = pmm01
                AND rvbslk01 = g_rva.rva01
         FOREACH t110_chk2 INTO l_pmm904,l_pmm50
            IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
            LET l_num = l_num+1
            IF NOT cl_null(l_pmm904) THEN
               EXIT FOREACH
            END IF
         END FOREACH
         IF cl_null(l_pmm50) THEN LET l_pmm50=' ' END IF  #MOD-850093 add
         IF l_pmm904 <> g_pmm904 AND l_num > 0 THEN
            CALL cl_err('','axm-501',0)
           #NEXT FIELD rvbslk04   #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
         IF l_pmm50  <> g_pmm50 AND l_num > 0 THEN #no.6113
            CALL cl_err('','apm-993',0)
           #NEXT FIELD rvbslk04   #MOD-CB0079 mark
            RETURN FALSE          #MOD-CB0079 add
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#MOD-CB0079 -- add end --

#DEV-D30045--add--begin
FUNCTION t110_barcode_out()
   DEFINE l_cmd       STRING

   IF g_rva.rva01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_msg = ' ibb03="',g_rva.rva01 CLIPPED,'"'
   LET l_cmd = "abar100",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1'",
               " '' '' '' '' ",
               " '",g_msg CLIPPED,"' ",
               " ' ' 'K' '",s_gen_barcode_ibd07(),"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
#DEV-D30045--add--end
