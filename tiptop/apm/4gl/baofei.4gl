# Prog. Version..: '5.30.06-13.03.12(00002)'     #
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
# Modify.........: No:FUN-9A0065 09/12/02 By baofei 增加Action"發佈電子採購需求"
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30434 12/03/19 By zhuhao q_pmm5增加參數
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取

DATABASE ds
 
GLOBALS "../../config/top.global"
#GLOBALS "../4gl/sapmt110.global"
#GLOBALS "../4gl/baofei.global"
DEFINE #FUN-730068
    g_rva           RECORD LIKE rva_file.*,
    g_rvb2          RECORD LIKE rvb_file.*,
    g_rvbi2         RECORD LIKE rvbi_file.*,#No.FUN-7C0017
    b_rvb           RECORD LIKE rvb_file.*,
    b_rvbi          RECORD LIKE rvbi_file.*,#No.FUN-7C0017
    g_rva_t         RECORD LIKE rva_file.*,
    g_rva_o         RECORD LIKE rva_file.*,
    g_rva01_t       LIKE rva_file.rva01,
    g_pmc04         LIKE pmc_file.pmc04,
    g_argv1         LIKE rva_file.rva01,
    g_argv2         LIKE rva_file.rva10,
    g_argv3         LIKE rva_file.rva04,
    g_argv4         STRING,                 #No:FUN-630010
    g_argv5         LIKE type_file.chr1,    #FUN-840012  1:自動確認
    g_argv6         LIKE rva_file.rva00,    #FUN-940083  
    g_buf           LIKE type_file.chr20,   #No.FUN-680136 CHAR(20)
    l_str           LIKE type_file.chr1000, #No.FUN-680136 CHAR(10)
#   g_rva_rowid     LIKE type_file.chr18,   #ROWID  #No.FUN-680136 INT   #No.FUN-960007
    g_t1            LIKE oay_file.oayslip,  #No.FUN-540027  #No.FUN-680136 CHAR(05)
    g_cmd           LIKE type_file.chr1000, #No.FUN-680136 CHAR(100)
    l_n             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_ec_sw         LIKE type_file.chr1,    #No.FUN-680136 CHAR(1)
    g_rvb         DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        rvb02       LIKE rvb_file.rvb02,    #驗收單項次
        rvb22       LIKE rvb_file.rvb22,    #發票/贖單單號
        rvb04       LIKE rvb_file.rvb04,    #採購單號
        rvb03       LIKE rvb_file.rvb03,    #採購項次
        rvb34       LIKE rvb_file.rvb34,    #工單單號
        rvbiicd03   LIKE rvbi_file.rvbiicd03, #No.FUN-7C0017
	      rvb05       LIKE rvb_file.rvb05,    #料件編號
        #TQC-650108
        att00       LIKE imx_file.imx00,
        att01       LIKE imx_file.imx01,    #No.FUN-680136 CHAR(10)
        att01_c     LIKE imx_file.imx01,    #No.FUN-680136 CHAR(10)
        att02       LIKE imx_file.imx02,    #No.FUN-680136 CHAR(10)
        att02_c     LIKE imx_file.imx02,    #No.FUN-680136 CHAR(10)
        att03       LIKE imx_file.imx03,    #No.FUN-680136 CHAR(10)
        att03_c     LIKE imx_file.imx03,    #No.FUN-680136 CHAR(10)
        att04       LIKE imx_file.imx04,    #No.FUN-680136 CHAR(10)
        att04_c     LIKE imx_file.imx04,    #No.FUN-680136 CHAR(10)
        att05       LIKE imx_file.imx05,    #No.FUN-680136 CHAR(10)
        att05_c     LIKE imx_file.imx05,    #No.FUN-680136 CHAR(10)
        att06       LIKE imx_file.imx06,    #No.FUN-680136 CHAR(10)
        att06_c     LIKE imx_file.imx06,    #No.FUN-680136 CHAR(10)
        att07       LIKE imx_file.imx07,    #No.FUN-680136 CHAR(10)
        att07_c     LIKE imx_file.imx07,    #No.FUN-680136 CHAR(10)
        att08       LIKE imx_file.imx08,    #No.FUN-680136 CHAR(10)
        att08_c     LIKE imx_file.imx08,    #No.FUN-680136 CHAR(10)
        att09       LIKE imx_file.imx09,    #No.FUN-680136 CHAR(10)
        att09_c     LIKE imx_file.imx09,    #No.FUN-680136 CHAR(10)
        att10       LIKE imx_file.imx10,    #No.FUN-680136 CHAR(10)
        att10_c     LIKE imx_file.imx10,    #No.FUN-680136 CHAR(10)
        #TQC-650108 --end
#No.FUN-940083--begin
#       pmn041      LIKE pmn_file.pmn041,  #品名
        rvb051      LIKE rvb_file.rvb051,  #品名
#No.FUN-940083--end
        ima021      LIKE ima_file.ima021,  #規格
        #No.FUN-810016---Begin
        rvb05a      LIKE rvb_file.rvb05,
        rvb05b      LIKE type_file.chr1000,
        rvb05c      LIKE type_file.chr1000,
        #No.FUN-810016---End
        rvbiicd14   LIKE rvbi_file.rvbiicd14, #No.FUN-7C0017
        rvbiicd11   LIKE rvbi_file.rvbiicd11, #No.FUN-7C0017
#No.FUN-940083--begin
#       pmn07       LIKE pmn_file.pmn07,   #採購單位
        rvb90       LIKE rvb_file.rvb90,   #收貨單位
#No.FUN-940083--end
        #NO.FUN-960130----start-----
        rvb42       LIKE rvb_file.rvb42,   #NO.FUN-9B0016
        rvb43       LIKE rvb_file.rvb43,
        rvb44       LIKE rvb_file.rvb44,
        rvb45       LIKE rvb_file.rvb45,
        #NO.FUN-960130----end-------
        pmn20       LIKE pmn_file.pmn20,   #訂購量
        pmn50_55    LIKE pmn_file.pmn20,   #未交量
        rvb30       LIKE rvb_file.rvb30,
        rvb29       LIKE rvb_file.rvb29,
        rvb89       LIKE rvb_file.rvb89,   #收貨  #FUN-940083
        rvb35       LIKE rvb_file.rvb35,   #樣品否
        rvbiicd06   LIKE rvbi_file.rvbiicd06,   #不良數
        rvbiicd07   LIKE rvbi_file.rvbiicd07,   #報廢數
        rvb07       LIKE rvb_file.rvb07,   #實收量
        #No.FUN-540027  --begin
        rvb83       LIKE rvb_file.rvb83,
        rvb84       LIKE rvb_file.rvb84,
        rvb85       LIKE rvb_file.rvb85,
        rvb80       LIKE rvb_file.rvb80,
        rvb81       LIKE rvb_file.rvb81,
        rvb82       LIKE rvb_file.rvb82,
        rvb86       LIKE rvb_file.rvb86,
        rvb87       LIKE rvb_file.rvb87,
        #No.FUN-540027  --end
        rvb36       LIKE rvb_file.rvb36,   #倉庫
        rvb37       LIKE rvb_file.rvb37,   #儲位
        rvb38       LIKE rvb_file.rvb38,   #批號
        rvb10       LIKE rvb_file.rvb10,   #單價
        rvb10t      LIKE rvb_file.rvb10t,  #含稅單價   No:FUN-550117
        rvb25       LIKE rvb_file.rvb25,   #手冊編號 A050
        pmm21       LIKE pmm_file.pmm21,   #稅別       No:FUN-550117
        pmm43       LIKE pmm_file.pmm43,   #稅率       No:FUN-550117
       #gec07       LIKE gec_file.gec07    #含稅否     No:FUN-550117 FUN-610018
        rvb930      LIKE rvb_file.rvb930,  #成本中心 #FUN-670051
        gem02a      LIKE gem_file.gem02,   #成本中心名稱 #FUN-670051
        rvb93       LIKE rvb_file.rvb93    #電子交貨序號 #FUN-9A0065
        #FUN-840042 --start---
        ,rvbud01 LIKE rvb_file.rvbud01,
        rvbud02 LIKE rvb_file.rvbud02,
        rvbud03 LIKE rvb_file.rvbud03,
        rvbud04 LIKE rvb_file.rvbud04,
        rvbud05 LIKE rvb_file.rvbud05,
        rvbud06 LIKE rvb_file.rvbud06,
        rvbud07 LIKE rvb_file.rvbud07,
        rvbud08 LIKE rvb_file.rvbud08,
        rvbud09 LIKE rvb_file.rvbud09,
        rvbud10 LIKE rvb_file.rvbud10,
        rvbud11 LIKE rvb_file.rvbud11,
        rvbud12 LIKE rvb_file.rvbud12,
        rvbud13 LIKE rvb_file.rvbud13,
        rvbud14 LIKE rvb_file.rvbud14,
        rvbud15 LIKE rvb_file.rvbud15
        #FUN-840042 --end--
                    END RECORD,
    g_rvb_t         RECORD                 #程式變數 (舊值)
        rvb02       LIKE rvb_file.rvb02,   #驗收單項次
        rvb22       LIKE rvb_file.rvb22,   #發票/贖單單號
        rvb04       LIKE rvb_file.rvb04,   #採購單號
        rvb03       LIKE rvb_file.rvb03,   #採購項次
        rvb34       LIKE rvb_file.rvb34,   #工單單號
        rvbiicd03   LIKE rvbi_file.rvbiicd03, #No.FUN-7C0017
        rvb05       LIKE rvb_file.rvb05,   #料件編號
        #TQC-650108
        att00       LIKE imx_file.imx00,
        att01       LIKE imx_file.imx01,    #No.FUN-680136 CHAR(10)
        att01_c     LIKE imx_file.imx01,    #No.FUN-680136 CHAR(10)
        att02       LIKE imx_file.imx02,    #No.FUN-680136 CHAR(10)
        att02_c     LIKE imx_file.imx02,    #No.FUN-680136 CHAR(10)
        att03       LIKE imx_file.imx03,    #No.FUN-680136 CHAR(10)
        att03_c     LIKE imx_file.imx03,    #No.FUN-680136 CHAR(10)
        att04       LIKE imx_file.imx04,    #No.FUN-680136 CHAR(10)
        att04_c     LIKE imx_file.imx04,    #No.FUN-680136 CHAR(10)
        att05       LIKE imx_file.imx05,    #No.FUN-680136 CHAR(10)
        att05_c     LIKE imx_file.imx05,    #No.FUN-680136 CHAR(10)
        att06       LIKE imx_file.imx06,    #No.FUN-680136 CHAR(10)
        att06_c     LIKE imx_file.imx06,    #No.FUN-680136 CHAR(10)
        att07       LIKE imx_file.imx07,    #No.FUN-680136 CHAR(10)
        att07_c     LIKE imx_file.imx07,    #No.FUN-680136 CHAR(10)
        att08       LIKE imx_file.imx08,    #No.FUN-680136 CHAR(10)
        att08_c     LIKE imx_file.imx08,    #No.FUN-680136 CHAR(10)
        att09       LIKE imx_file.imx09,    #No.FUN-680136 CHAR(10)
        att09_c     LIKE imx_file.imx09,    #No.FUN-680136 CHAR(10)
        att10       LIKE imx_file.imx10,    #No.FUN-680136 CHAR(10)
        att10_c     LIKE imx_file.imx10,    #No.FUN-680136 CHAR(10)
        #TQC-650108 --end
#No.FUN-940083--begin
#       pmn041      LIKE pmn_file.pmn041,  #品名
        rvb051      LIKE rvb_file.rvb051,  #品名
#No.FUN-940083--end
        ima021      LIKE ima_file.ima021,  #規格
        #No.FUN-810016---Begin
        rvb05a      LIKE rvb_file.rvb05,
        rvb05b      LIKE type_file.chr1000,
        rvb05c      LIKE type_file.chr1000,
        #No.FUN-810016---End
        rvbiicd14   LIKE rvbi_file.rvbiicd14, #No.FUN-7C0017
        rvbiicd11   LIKE rvbi_file.rvbiicd11, #No.FUN-7C0017
#No.FUN-940083--begin
#       pmn07       LIKE pmn_file.pmn07,   #採購單位
        rvb90       LIKE rvb_file.rvb90,   #收貨單位
#No.FUN-940083--end
        #NO.FUN-960130----start-----
        rvb42       LIKE rvb_file.rvb42,
        rvb43       LIKE rvb_file.rvb43,
        rvb44       LIKE rvb_file.rvb44,
        rvb45       LIKE rvb_file.rvb45,
        #NO.FUN-960130----end-------
        pmn20       LIKE pmn_file.pmn20,   #訂購量
        pmn50_55    LIKE pmn_file.pmn20,   #未交量
        rvb30       LIKE rvb_file.rvb30,
        rvb29       LIKE rvb_file.rvb29,
        rvb89       LIKE rvb_file.rvb89,   #收貨  #FUN-940083
        rvb35       LIKE rvb_file.rvb35,   #樣品否
        rvbiicd06   LIKE rvbi_file.rvbiicd06,   #不良數
        rvbiicd07   LIKE rvbi_file.rvbiicd07,   #報廢數
        rvb07       LIKE rvb_file.rvb07,   #實收量
        #No.FUN-540027  --begin
        rvb83       LIKE rvb_file.rvb83,
        rvb84       LIKE rvb_file.rvb84,
        rvb85       LIKE rvb_file.rvb85,
        rvb80       LIKE rvb_file.rvb80,
        rvb81       LIKE rvb_file.rvb81,
        rvb82       LIKE rvb_file.rvb82,
        rvb86       LIKE rvb_file.rvb86,
        rvb87       LIKE rvb_file.rvb87,
        #No.FUN-540027  --end
        rvb36       LIKE rvb_file.rvb36,   #倉庫
        rvb37       LIKE rvb_file.rvb37,   #儲位
        rvb38       LIKE rvb_file.rvb38,   #批號
        rvb10       LIKE rvb_file.rvb10,   #單價
        rvb10t      LIKE rvb_file.rvb10t,  #含稅單價   No:FUN-550117
        rvb25       LIKE rvb_file.rvb25,   #手冊編號 A050
        pmm21       LIKE pmm_file.pmm21,   #稅別       No:FUN-550117
        pmm43       LIKE pmm_file.pmm43,   #稅率       No:FUN-550117
        #gec07      LIKE gec_file.gec07    #含稅否     No:FUN-550117 FUN-610018
        rvb930      LIKE rvb_file.rvb930,  #成本中心 #FUN-670051
        gem02a      LIKE gem_file.gem02,   #成本中心名稱 #FUN-670051
        rvb93       LIKE rvb_file.rvb93    #電子交貨序號 #FUN-9A0065
        #FUN-840042 --start---
        ,rvbud01 LIKE rvb_file.rvbud01,
        rvbud02 LIKE rvb_file.rvbud02,
        rvbud03 LIKE rvb_file.rvbud03,
        rvbud04 LIKE rvb_file.rvbud04,
        rvbud05 LIKE rvb_file.rvbud05,
        rvbud06 LIKE rvb_file.rvbud06,
        rvbud07 LIKE rvb_file.rvbud07,
        rvbud08 LIKE rvb_file.rvbud08,
        rvbud09 LIKE rvb_file.rvbud09,
        rvbud10 LIKE rvb_file.rvbud10,
        rvbud11 LIKE rvb_file.rvbud11,
        rvbud12 LIKE rvb_file.rvbud12,
        rvbud13 LIKE rvb_file.rvbud13,
        rvbud14 LIKE rvb_file.rvbud14,
        rvbud15 LIKE rvb_file.rvbud15
        #FUN-840042 --end--
                END RECORD,
    #No.FUN-540027  --begin
    g_rvb05_t       LIKE rvb_file.rvb05,
    g_ima25         LIKE ima_file.ima25,
    g_ima44         LIKE ima_file.ima44,
    g_ima906        LIKE ima_file.ima906,
    g_ima907        LIKE ima_file.ima907,
    g_ima908        LIKE ima_file.ima908,
    g_imgg00        LIKE imgg_file.imgg00,
    g_imgg10        LIKE imgg_file.imgg10,
    g_factor        LIKE pmn_file.pmn09,
    g_tot           LIKE img_file.img10,
    g_qty           LIKE img_file.img10,
    g_flag          LIKE type_file.chr1,    #No.FUN-680136 CHAR(1)
    g_flag2         LIKE type_file.chr1,    #MOD-910053
    #No.FUN-540027  --end
    g_sfb05         LIKE sfb_file.sfb05,
    g_pmn20         LIKE pmn_file.pmn20,
    g_pmn13         LIKE pmn_file.pmn13,
    g_pmn50_55      LIKE pmn_file.pmn50,
    g_pmn14         LIKE pmn_file.pmn14,
    g_pmn011        LIKE pmn_file.pmn011,
    g_pmn41         LIKE pmn_file.pmn41,
    g_pmn44         LIKE pmn_file.pmn44,   # 收料本幣單價
    g_pmn31         LIKE pmn_file.pmn31,
    g_pmn31t        LIKE pmn_file.pmn31t,  #No:FUN-550117
    g_pmm42         LIKE pmm_file.pmm42,
    g_pmn09         LIKE pmn_file.pmn09,   # 採購/料件庫存轉換率
    g_pmm904        LIKE pmm_file.pmm904,
    g_pmm50         LIKE pmm_file.pmm50,
    g_gec07         LIKE gec_file.gec07,   #No:FUN-550117
    g_wc,g_wc2      string,                #No:FUN-580092 HCN
    g_sql           string,                #No:FUN-580092 HCN
    g_sw            LIKE type_file.chr1,   #No.FUN-680136 CHAR(01)
    g_img09_t       LIKE img_file.img09,
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680136 SMALLINT
    g_min_set       LIKE sfb_file.sfb08,
    conf_qty        LIKE sfb_file.sfb08,
    l_sfb39         LIKE sfb_file.sfb39,
    l_sfb05         LIKE sfb_file.sfb05,
    l_sfb93         LIKE sfb_file.sfb93,   #No:FUN-610101 add
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    g_yy,g_mm       LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    g_prt           LIKE type_file.chr1,   #No.FUN-680136 CHAR(01)
    p_row,p_col     LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    g_rvu01_1       LIKE rvu_file.rvu01,   #產生入庫時的單號
    g_rvu01_2       LIKE rvu_file.rvu01    #產生驗退時的單號

DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg                 LIKE ze_file.ze03      #No.FUN-680136 CHAR(72)

DEFINE   g_chr                 LIKE type_file.chr1    #No.FUN-680136 CHAR(1)

DEFINE   g_row_count           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_curs_index          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_jump                LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   mi_no_ask             LIKE type_file.num5    #No.FUN-680136 SMALLINT
#TQC-650108
DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD
         imx00                 LIKE imx_file.imx00,
         imx                   ARRAY[10] OF LIKE imx_file.imx01 
         END RECORD
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE   lg_smy62              LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE   lg_smy621             LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE   lg_group              LIKE smy_file.smy62   #當前單身中采用的組別 
#No:FUN-9A0065---BEGIN
DEFINE   g_wpe    DYNAMIC ARRAY OF RECORD
          sel     LIKE   type_file.chr1,
          wpe01   LIKE   wpe_file.wpe01,
          wpe04   LIKE   wpe_file.wpe04, 
          pmm04   LIKE   pmm_file.pmm04,
          wpe02   LIKE   wpe_file.wpe02,
          wpe05   LIKE   wpe_file.wpe05,
          pmn04   LIKE   pmn_file.pmn04,
          pmn041  LIKE   pmn_file.pmn041,
          wpe06   LIKE   wpe_file.wpe06
                  END RECORD
DEFINE    g_rva1  RECORD LIKE rva_file.*
DEFINE    g_rvb1  RECORD LIKE rvb_file.*  
#No:FUN-9A0065---END      
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE g_in      LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可入庫量
DEFINE g_out     LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可驗退量
DEFINE g_pmc01   LIKE pmc_file.pmc01   #No:FUN-9A0065
DEFINE g_pmc03   LIKE pmc_file.pmc03   #No:FUN-9A0065
 
FUNCTION t110(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6) #No.FUN-630010 #FUN-840012 #No.FUN-940083
   DEFINE l_time     LIKE type_file.chr8,     #No.FUN-680136 VARCHAR(8)
          p_argv1    LIKE rva_file.rva01,     #收貨單號
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
 
   LET g_forupd_sql = "SELECT * FROM rva_file WHERE rva01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
   IF (NOT cl_null(g_argv5)) AND (g_argv5='1') THEN  #FUN-840012 1:執行自動確認
      CALL t110_q()
      CALL t110_y()
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   ELSE
#FUN-940083--begin
      IF (NOT cl_null(g_argv5)) AND (g_argv5='V') THEN
         CALL t110_q()
         CALL t110_z()
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      ELSE
#FUN-940083--end
         LET p_row = 3 LET p_col = 8
         CASE
            WHEN  g_argv2 = 'SUB'
               OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                 WITH FORM "apm/42f/apmt200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
            WHEN g_argv2 = 'TAP'
               OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                 WITH FORM "apm/42f/apmt300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
&ifdef ICD
            #FUN-810038................begin
            WHEN g_argv2 = 'ICD'
               OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                 WITH FORM "aic/42f/aict041"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
            #FUN-810038................end           
&endif
            OTHERWISE
               OPEN WINDOW t110_w AT p_row,p_col           #顯示畫面
                 WITH FORM "apm/42f/apmt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         END CASE
      END IF                                               #FUN-940083
   END IF
   #NO.FUN-960130----START---   #NO.FUN-9B0016
   IF g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("rvacond,rvaconu,rvaconu_desc,rva29,rva30,rva30_desc",TRUE)
      CALL cl_set_comp_visible("rva31,rva31_desc,rvaplant,rvaplant_desc,rvacrat",TRUE)
      CALL cl_set_comp_visible("rvb42,rvb43,rvb44,rvb45",TRUE) 
      CALL cl_set_comp_visible("rvb930,gem02a",FALSE)
   ELSE
      CALL cl_set_comp_visible("rvacond,rvaconu,rvaconu_desc,rva29,rva30,rva30_desc",FALSE)
      CALL cl_set_comp_visible("rva31,rva31_desc,rvaplant,rvaplant_desc,rvacrat",FALSE)
      CALL cl_set_comp_visible("rvb42,rvb43,rvb44,rvb45",FALSE)
   END IF
   #NO.FUN-960130-----END----
 
  #No.TQC-760080--begin--
   IF g_argv2 != 'TAP' THEN
      CALL cl_set_comp_visible("rva99",FALSE)
   END IF
  #No.TQC-760080--end--
 
  #No.FUN-940083--begin
   IF g_argv6 ='2' THEN
      CALL cl_set_comp_visible("rva02",FALSE)
      CALL cl_set_comp_visible("rvb03,rvb04,rvb05a,rvb05b,rvb05c,
                                pmn20,pmn50_55,pmm21,pmm43",FALSE)
   ELSE
      CALL cl_set_comp_visible("Page4",FALSE)
      CALL cl_set_comp_visible("rvb10,rvb10t",FALSE)
   END IF
  #No.FUN-940083--end
   CALL cl_set_comp_visible("rva31,rva31_desc",FALSE) #bnl
 
   CALL cl_ui_init()
 
   #No.FUN-6C0055 --start--
   IF g_aza.aza71 MATCHES '[Yy]' THEN
      CALL aws_gpmcli_toolbar()
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
   #No.FUN-6C0055 --end--
   #FUN-850120 add begin
   IF g_sma.sma90 = 'Y' THEN
      CALL cl_set_act_visible("qry_lot", TRUE)
   ELSE
      CALL cl_set_act_visible("qry_lot", FALSE)
   END IF
   #FUN-850120 add end
   CALL cl_set_comp_entry("rvb86",FALSE)      #No.TQC-740313
 
   #No.FUN-550117  No.FUN-560102
#  IF g_aza.aza26 != '2' THEN
#     CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",FALSE)
#  END IF
   #end No.FUN-550117
 
 
   #-----TQC-710032---------
   CALL t110_mu_ui()
   ##No.FUN-540027  --begin
   #CALL cl_set_comp_visible("rvb84,rvb81,rvb10,rvb10t",FALSE)  #FUN-6A0139 add rvb10,rvb10t
   #IF g_sma.sma115='Y' THEN
   #   CALL cl_set_comp_visible("rvb07",FALSE)
   #ELSE
   #    CALL cl_set_comp_visible("rvb83,rvb84,rvb85",FALSE)
   #    CALL cl_set_comp_visible("rvb80,rvb81,rvb82",FALSE)
   #END IF
   #IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
   #    CALL cl_set_comp_visible("rvb86,rvb87",FALSE)
   #END IF
   # IF g_sma.sma122 ='1' THEN
   #    CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
   # END IF
   # IF g_sma.sma122 ='2' THEN
   #    CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
   #    CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
   # END IF
   ##No.FUN-540027  --end
   #-----END TQC-710032-----
 
    #FUN-670051...............begin
    CALL cl_set_comp_visible("rvb930,gem02a",g_aaz.aaz90='Y')
    #FUN-670051...............end
 
    #TQC-650108
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_smy62 = ''
    LET lg_group = ''
    CALL t110_refresh_detail()
    #TQC-650108 --end
 
   IF NOT cl_null(g_argv1) THEN
      #No.FUN-630010 --start--
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
         OTHERWISE
            CALL t110_q()
           #CALL t110_cs()
           #CALL t110_fetch('F')
      END CASE
      #No.FUN-630010 ---end---
   END IF
 
   CALL t110_menu()
 
   #FUN-680011---start---
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",TRUE)
      CALL cl_set_comp_visible("rvaspc",TRUE)
   END IF
   #FUN-680011---end---
 
   CLOSE WINDOW t110_w                 #結束畫面
 
END FUNCTION
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01   #No.FUN-580031  HCN
DEFINE  l_pmm04         LIKE    pmm_file.pmm04   #No.MOD-4B0275
 
   CLEAR FORM                             #清除畫面
   CALL g_rvb.clear()
 
   IF cl_null(g_argv1) THEN
      INITIALIZE g_rva.* TO NULL      #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
         rva01,rva06,rva02,rva05,rva99,rva04,rva21,rva08,
         rva09,rva10,rvaconf,rvaspc,rva117,          #FUN-680011  #No.FUN-940083    
         rva111,rva112,rva115,rva116,rva113,rva114,  #No.FUN-940083
         rvauser,rvagrup,rvamodu,rvadate,rvaacti,rvacrat,    #NO.FUN-960130--add rvacrat
         rvacond,rvaconu,rva29,rva30,rva31,rvaplant          #NO.FUN-960130---add----
         #FUN-840042   ---start---
         ,rvaud01,rvaud02,rvaud03,rvaud04,rvaud05,
         rvaud06,rvaud07,rvaud08,rvaud09,rvaud10,
         rvaud11,rvaud12,rvaud13,rvaud14,rvaud15
         #FUN-840042    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
          CASE
             #--No.FUN-4A0034----------
             WHEN INFIELD(rva01) #查詢收貨單號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                CASE
                   WHEN g_argv2 = 'SUB'   LET g_qryparam.form = "q_rva05"
                   WHEN g_argv2 = 'TAP'   LET g_qryparam.form = "q_rva07"
&ifdef ICD
                   #FUN-810038................begin
                   WHEN g_argv2 = 'ICD'   LET g_qryparam.form = "q_rva_icd"
                   #FUN-810038................end
&endif
                   OTHERWISE              LET g_qryparam.form = "q_rva06"
                END CASE
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva01
                NEXT FIELD rva01
             #--END---------------------
             WHEN INFIELD(rva02) #查詢採購單號
#               CALL q_pmm6(2,16,g_rva.rva02,g_argv2) RETURNING g_rva.rva02
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
                LET g_qryparam.form ="q_pmm6"
&ifdef ICD
                #FUN-810038................begin
               #MOD-890023 modify --begin
               #   LET g_qryparam.form ="q_pmm6_icd"
                IF g_argv2 = 'ICD' THEN
                   LET g_qryparam.form ="q_pmm6_icd"
                ELSE
                   LET g_qryparam.form ="q_pmm6"
                END IF
               #MOD-890023 modify --end
                #FUN-810038................end
&endif
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva02
                NEXT FIELD rva02
             WHEN INFIELD(rva05) #查詢廠商
#               CALL q_pmc1(0,0,g_rva.rva05) RETURNING g_rva.rva05
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
                LET g_qryparam.form ="q_pmc1"
                LET g_qryparam.default1 = g_rva.rva05
                CALL cl_create_qry() RETURNING g_rva.rva05
                DISPLAY BY NAME g_rva.rva05
                CALL t110_rva05('a')
                NEXT FIELD rva05
             #NO.FUN-960130----start-----
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
              #NO.FUN-960130----end----
#TQC-9A0066 --begin--
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
#TQC-9A0066 --end--
              
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
 
                #No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
#FUN-9A0068--begin
      LET g_wc = g_wc CLIPPED," AND rva00 = '",g_argv6 CLIPPED,"'"
#FUN-9A0068--end
   ELSE
#FUN-9A0068--begin
#     LET g_wc= " rva01= '",g_argv1 CLIPPED,"'"
      LET g_wc= " rva00 = '",g_argv6 CLIPPED,"' AND rva01= '",g_argv1 CLIPPED,"'"
#FUN-9A0068--end
      LET g_wc2 = ' 1=1'
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND rvauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
   #End:FUN-980030
 
 
   CASE WHEN g_argv2='SUB'         #委外
             LET g_wc = g_wc clipped," AND rva10 = 'SUB' "
        WHEN g_argv2='TAP'         #三角代採買
             LET g_wc = g_wc clipped," AND (rva10 = 'TAP' OR rva10='TRI') " #No.7882
&ifdef ICD
        #FUN-810038................begin
        WHEN g_argv2='ICD'         #Wafer採購
             LET g_wc = g_wc clipped," AND (rva10 LIKE 'WB%') "
        #FUN-810038................end
&endif
        OTHERWISE
             LET g_wc = g_wc clipped," AND rva10 != 'SUB' AND rva10 !='TAP' ",
                                     " AND rva10 != 'TRI' "
&ifdef ICD
             #FUN-810038................begin
                LET g_wc = g_wc clipped," AND (NOT rva10 LIKE 'WB%')"
             #FUN-810038................end
&endif
   END CASE
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
   IF cl_null(g_argv1) THEN
       #No.FUN-540027  --begin
       CONSTRUCT g_wc2 ON rvb02,rvb22,rvb04,rvb03,rvb34,
&ifdef ICD
                          rvbiicd03,                 #No.FUN-7C0017
&endif
                          rvb05,
&ifdef ICD
                          rvbiicd14,rvbiicd11,       #No.FUN-7C0017
&endif
                          rvb42,rvb43,rvb44,rvb45,    #NO.FUN-960130--add---
                          rvb30,rvb29,
                          rvb89,                     #No.FUN-940083
                          rvb35,
&ifdef ICD
                          rvbiicd06,rvbiicd07,   #FUN-810038
&endif
                          rvb07,rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,
                          rvb86,rvb87,rvb10,rvb10t,rvb36,rvb37,rvb38,rvb25,  #No.FUN-550117
                          rvb930   #FUN-670051
&ifdef ICD
                         ,rvbiicd08,rvbiicd10,rvbiicd12,rvbiicd15,rvbiicd16  #No.FUN-7C0017
&endif
                         #No.FUN-840042 --start--
                         ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05,
                         rvbud06,rvbud07,rvbud08,rvbud09,rvbud10,
                         rvbud11,rvbud12,rvbud13,rvbud14,rvbud15
                         #No.FUN-840042 ---end---
        FROM s_rvb[1].rvb02,s_rvb[1].rvb22,s_rvb[1].rvb04,s_rvb[1].rvb03,
             s_rvb[1].rvb34,
&ifdef ICD
             s_rvb[1].rvbiicd03,                     #No.FUN-7C0017
&endif
             s_rvb[1].rvb05,
&ifdef ICD
             s_rvb[1].rvbiicd14,s_rvb[1].rvbiicd11,  #No.FUN-7C0017
&endif
             s_rvb[1].rvb42,s_rvb[1].rvb43,s_rvb[1].rvb44,s_rvb[1].rvb45,    #NO.FUN-960130--add---
             s_rvb[1].rvb30,s_rvb[1].rvb29,
             s_rvb[1].rvb89,                         #FUN-940083
             s_rvb[1].rvb35,
&ifdef ICD
             s_rvb[1].rvbiicd06,s_rvb[1].rvbiicd07,  #FUN-810038
&endif
             s_rvb[1].rvb07,s_rvb[1].rvb83,s_rvb[1].rvb84,
             s_rvb[1].rvb85,s_rvb[1].rvb80,s_rvb[1].rvb81,s_rvb[1].rvb82,
             s_rvb[1].rvb86,s_rvb[1].rvb87,s_rvb[1].rvb10,s_rvb[1].rvb10t,   #No.FUN-550117
             s_rvb[1].rvb36,s_rvb[1].rvb37,s_rvb[1].rvb38,s_rvb[1].rvb25,    #No.FUN-550117
             s_rvb[1].rvb930   #FUN-670051
&ifdef ICD
            ,s_rvb[1].rvbiicd08,s_rvb[1].rvbiicd10,s_rvb[1].rvbiicd12,       #No.FUN-7C0017
             s_rvb[1].rvbiicd15,s_rvb[1].rvbiicd16                           #No.FUN-7C0017
&endif
             #No.FUN-840042 --start--
             ,s_rvb[1].rvbud01,s_rvb[1].rvbud02,s_rvb[1].rvbud03,s_rvb[1].rvbud04,s_rvb[1].rvbud05,
             s_rvb[1].rvbud06,s_rvb[1].rvbud07,s_rvb[1].rvbud08,s_rvb[1].rvbud09,s_rvb[1].rvbud10,
             s_rvb[1].rvbud11,s_rvb[1].rvbud12,s_rvb[1].rvbud13,s_rvb[1].rvbud14,s_rvb[1].rvbud15
             #No.FUN-840042 ---end---
       #No.FUN-540027  --end
 
                #No.FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
             CASE  WHEN INFIELD(rvb04)    #
                     CALL cl_init_qry_var()
                     CASE
                        WHEN g_argv2 = 'SUB'   LET g_qryparam.form = "q_pmm9"
                        WHEN g_argv2 = 'TAP'   LET g_qryparam.form = "q_pmm10"
&ifdef ICD
                        #FUN-810038................begin
                        WHEN g_argv2 = 'ICD'   LET g_qryparam.form = "q_pmm11_icd"
                        #FUN-810038................end
&endif
                        OTHERWISE              LET g_qryparam.form = "q_pmm11"
                     END CASE
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb04
                     NEXT FIELD rvb04
                   WHEN INFIELD(rvb05)    #
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb05
                     NEXT FIELD rvb36
                    WHEN INFIELD(rvb36)  #MOD-480604查詢倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imd"
                     LET g_qryparam.state = "c"
                     #LET g_qryparam.arg1  = "A"  #MOD-4A0213
                      LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb36
                     NEXT FIELD rvb36
                    #No.MOD-4B0275
                   WHEN INFIELD(rvb25)
                     SELECT pmm04 INTO l_pmm04 FROM pmm_file
                      WHERE pmm01 = g_rvb[1].rvb04
                     CALL q_coc2(TRUE,TRUE,g_rvb[1].rvb25,'',l_pmm04,'1',
                                 '',g_rvb[1].rvb05)
                     RETURNING g_rvb[1].rvb25
                      DISPLAY BY NAME g_rvb[1].rvb25                #No.MOD-490371
                     NEXT FIELD rvb25
                    #No.MOD-4B0275 end
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
                #No.FUN-540027  --end
                #FUN-670051...............begin
                WHEN INFIELD(rvb930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvb930
                   NEXT FIELD rvb930
                #FUN-670051...............end
&ifdef ICD
                #No.FUN-7C0017...begin
                WHEN INFIELD(rvbiicd03) #rvbiicd03
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_ecd_icd"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvbiicd03
                   NEXT FIELD rvbiicd03
                WHEN INFIELD(rvbiicd12) #rvbiicd12
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_icq"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvbiicd12
                   NEXT FIELD rvbiicd12
                WHEN INFIELD(rvbiicd14) #rvbiicd14
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_imaicd1"
                   LET g_qryparam.state = 'c'
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvbiicd14
                   NEXT FIELD rvbiicd14
                WHEN INFIELD(rvbiicd15) #rvbiicd15
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvbiicd15
                   NEXT FIELD rvbiicd15
                #No.FUN-7C0017...end
&endif
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
 
 
                #No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
                       CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   END IF
&ifdef ICD
   IF g_prog='aict041' THEN #icd-wafer收貨
      LET g_wc=g_wc CLIPPED," AND rva10 LIKE 'WB_'"
   ELSE #icd一般收貨
      LET g_wc=g_wc CLIPPED," AND rva10 NOT LIKE 'WB_'"
   END IF
&endif
   IF g_wc2 = ' 1=1 ' THEN            # 若單身未輸入條件
      LET g_sql = "SELECT  rva01 FROM rva_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"                 #FUN-9A0068
#                 " ORDER BY 2"                 #FUN-9A0068 mark
      #NO.FUN-960130----BEGIN---------
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT  rva01 FROM rva_file ",
                     " WHERE ", g_wc CLIPPED,
                     " AND rvaplant IN ",g_auth,
                     " ORDER BY 1"                   #FUN-9A0068
#                    " ORDER BY 2"                   #FUN-9A0068 mark
      END IF
      #NO.FUN-960130----END------
   ELSE                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                  "  FROM rva_file, rvb_file ",
                  " WHERE rva01 = rvb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"                      #FUN-9A0068 
#                 " ORDER BY 2"                      #FUN-9A0068 mark
&ifndef STD
     #No.FUN-7C0017 -Begin
        IF g_wc2.getindexof('rvbi',1)>0 THEN
           LET g_sql = "SELECT UNIQUE rva_file.rva01 ",
                       "  FROM rva_file, rvb_file,rvbi_file ",
                       " WHERE rva01 = rvb01",
                       "   AND rvb01 = rvbi01 ",
                       "   AND rvb02 = rvbi02 ",
                       "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                       " ORDER BY 1"                 #FUN-9A0068
#                      " ORDER BY 2"                 #FUN-9A0068 mark
        END IF
     #No.FUN-7C0017 -End
&endif
      #NO.FUN-960130----BEGIN-----
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT UNIQUE rva_file.rva01 ", 
                     "  FROM rva_file, rvb_file ", 
                     " WHERE rva01 = rvb01",
                     " AND rvaplant IN ",g_auth,
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY 1"                  #FUN-9A0068
#                    " ORDER BY 2"                  #FUN-9A0068 mark
      END IF
      #NO.FUN-960130-----END----------
   END IF
 
 
   PREPARE t110_prepare FROM g_sql
   DECLARE t110_cs                         #SCROLL CURSOR
    SCROLL CURSOR WITH HOLD FOR t110_prepare
 
   IF g_wc2 = ' 1=1 ' THEN            # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM rva_file WHERE ",g_wc CLIPPED
      #NO.FUN-960130---BEGIN------
      IF g_azw.azw04='2' THEN
         LET g_sql="SELECT COUNT(*) FROM rva_file WHERE ",g_wc CLIPPED," AND rvaplant IN ",g_auth
      END IF
      #NO.FUN-960130
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvb_file WHERE ",
                "rvb01=rva01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
&ifndef STD
      #No.FUN-7C0017 -Begin
         IF g_wc2.getindexof('rvbi',1)>0 THEN
            LET g_sql="SELECT COUNT(DISTINCT rva01) FROM ",
                      " rva_file,rvb_file,rvbi_file WHERE ",
         #             "rvb01=rva01 AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND",g_wc CLIPPED," AND ",g_wc2 CLIPPED    #TQC-970351    
                      "rvb01=rva01 AND rvb01 = rvbi01 AND rvb02 = rvbi02 AND  ",g_wc CLIPPED," AND ",g_wc2 CLIPPED     #TQC-970351  
         END IF     
      #No.FUN-7C0017 -End
&endif
      #NO.FUN-960130---BEGIN------
      IF g_azw.azw04='2' THEN
         LET g_sql="SELECT COUNT(DISTINCT rva01) FROM rva_file,rvb_file WHERE ",
                   "rvb01=rva01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " AND rvaplant IN ",g_auth
      END IF 
      #NO.FUN-960130---END-------
   END IF
   PREPARE t110_precount FROM g_sql
   DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
FUNCTION t110_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
   #No.FUN-6C0055 --start--
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE g_img09      LIKE img_file.img09   #FUN-850120
   DEFINE l_i LIKE type_file.num5,
          l_fac        LIKE ima_file.ima31_fac
   #No.FUN-6C0055 --end--
 
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
         WHEN "add_invoice"
            CALL t110_k()
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t110_x()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               CALL t110_y()
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
            END IF
         WHEN "qry_st_in"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               CASE
&ifdef ICD
                  #CHI-830025................begin
                  WHEN g_argv2='ICD'
                     LET g_cmd = "aict042 ","'",g_rva.rva01 CLIPPED,"' '' '1'"
                  #CHI-830025................end
&endif
                  WHEN g_rva.rva10='SUB'
                    #No.MOD-890023 modify --begin
                    #LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",
                    #            "'1' 'SUB'"  #No.FUN-630010
#CHI-920060--BEGIN--
#                     IF NOT s_industry('icd') THEN
#                        LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",
#                                    "'1' 'SUB'"  #No.FUN-630010
#                     ELSE
#                        LET g_cmd = "apmt730_icd ","'",g_rva.rva01 CLIPPED,"' '' ",
#                                    "'1' 'SUB'"  #No.FUN-630010
#                     END IF
&ifndef ICD
                     LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",
                                  "'1' 'SUB'" 
&else
                        LET g_cmd = "apmt730_icd ","'",g_rva.rva01 CLIPPED,"' '' ", 
                                    "'1' 'SUB'"
&endif
#CHI-920060--END--
                    #No.MOD-890023 modify --begin
                  WHEN g_rva.rva10='TAP' OR g_rva.rva10 = 'TRI'
&ifndef ICD
                     LET g_cmd = "apmt740 ","'",g_rva.rva01 CLIPPED,"' '' '1'"  #No.FUN-630010
&else
                     LET g_cmd = "apmt740_icd ","'",g_rva.rva01 CLIPPED,"' '' '1'" #CHI-920060
&endif
                  OTHERWISE
&ifndef ICD
                     LET g_cmd = "apmt720 ","'",g_rva.rva01 CLIPPED,"' '' '1'"  #No.FUN-630010
&else
                     LET g_cmd = "apmt720_icd ","'",g_rva.rva01 CLIPPED,"' '' '1'"  #CHI-920060
&endif
               END CASE
               #CALL cl_cmdrun(g_cmd)     #FUN-660216 remark
               CALL cl_cmdrun_wait(g_cmd) #FUN-660216 add
            END IF
         WHEN "qry_qc_return"
            IF cl_chk_act_auth() AND NOT cl_null(g_rva.rva01) THEN
               CASE
&ifdef ICD
                  #CHI-830025................begin
                  WHEN g_argv2='ICD'
                     LET g_cmd = "aict043 ","'",g_rva.rva01 CLIPPED,"' '' '2'"
                  #CHI-830025................end
&endif
                  WHEN g_rva.rva10='SUB'
&ifndef ICD
                     LET g_cmd = "apmt731 ","'",g_rva.rva01 CLIPPED,"' '' ",
                                 "'2' 'SUB'"  #No.FUN-630010
&else
                     LET g_cmd = "apmt731_icd ","'",g_rva.rva01 CLIPPED,"' '' ",  #CHI-920060
                                 "'2' 'SUB'"                                      #CHI-920060
&endif
                    
                  WHEN g_rva.rva10='TAP' OR g_rva.rva10 = 'TRI'
&ifndef ICD
                     LET g_cmd = "apmt741 ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #No.FUN-630010
&else
                     LET g_cmd = "apmt741_icd ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #CHI-920060
&endif
                  OTHERWISE
&ifndef ICD
                     LET g_cmd = "apmt721 ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #No.FUN-630010
&else
                     LET g_cmd = "apmt721_icd ","'",g_rva.rva01 CLIPPED,"' '' '2'"  #CHI-920060
&endif
               END CASE
               #CALL cl_cmdrun(g_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF
         WHEN "receiving"
            LET g_cmd = "apmq320 '",g_rva.rva01,"'"
            CALL cl_cmdrun(g_cmd)
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
         WHEN "trans_spc"         #FUN-680011
            IF cl_chk_act_auth() THEN
               CALL t110_spc()
            END IF
 
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rva.rva01 IS NOT NULL THEN
                 LET g_doc.column1 = "rva01"
                 LET g_doc.value1 = g_rva.rva01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
 
         #No.FUN-6C0055 --start--
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
        #No.FUN-6C0055 --end--
 
&ifdef ICD
        #FUN-810038................begin
         #@WHEN "回貨資料查詢"
         WHEN "aic_qry_back"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rva.rva01) AND
                  NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  LET g_cmd = "aicq021 '",g_rva.rva01,"' ",
                                      "'",g_rvb[l_ac].rvb02,"'"
                  CALL cl_cmdrun_wait(g_cmd)
               END IF
            END IF
 
         #@WHEN "單據刻號維護作業"
         WHEN "aic_s_icdin"
            IF cl_chk_act_auth() THEN
                  CALL t110_ind_icd_icin()
            END IF
         #@WHEN "單據刻號BIN查詢作業"
         WHEN "aic_s_icdqry"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rva.rva01) THEN
                  CALL s_icdqry(0,g_rva.rva01,'',g_rva.rvaconf,'')
               END IF
            END IF
         #刻號明細入庫否維護
         WHEN "aic_s_icdin_rec"
            IF cl_chk_act_auth() THEN
               CALL t110_ind_icd_icdin_rec()
            END IF
        #FUN-810038................end
&endif
 
        #-----No.FUN-810036-----
        WHEN "qry_lot"
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
                 CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                              g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,    #No.FUN-940083 pmn07-->rvb90 
                              l_fac,g_rvb[l_ac].rvb07,'QRY')
                     RETURNING l_r,g_qty 
              END IF
           END IF
        #-----No.FUN-810036 END-----
#FUN-9A0065---begin                                                                                                                         
        WHEN "e_proc_require"                                                                                                      
           IF cl_chk_act_auth() THEN                                                                                                  
              CALL t1100_epr()                                                                                                         
           END IF                                                                                                                     
#FUN-9A0065---end  
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t110_a()
   DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_msg("")
   CLEAR FORM
   CALL g_rvb.clear()
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
&ifdef ICD
   #FUN-810038................begin
      IF g_argv2='ICD' THEN
         LET g_rva.rva10 = 'WB0'
      END IF
   #FUN-810038................end
&endif
   #No.FUN-630010 --start--
   IF NOT cl_null(g_argv1) AND (g_argv4 = "insert") THEN
      LET g_rva.rva02 = g_argv1
   END IF
   #No.FUN-630010 ---end---
 
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
      LET g_rva.rvadate=g_today
      LET g_rva.rvaacti='Y'
      #NO.FUN-5A0076 START--
      IF cl_null(g_argv2) THEN
          LET g_rva.rva10 ='REG'
      END IF
      #NO.FUN-5A0076 END ---
      #NO.FUN-960130----START---
      LET g_rva.rva29 = '1'
      IF g_azw.azw04='2' THEN
         LET g_rva.rva30 = g_plant
         LET g_rva.rvacrat= g_today
      END IF
      LET g_rva.rvaplant = g_plant
      LET g_rva.rvalegal = g_legal
      #NO.FUN-960130----END-----
 
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
 
      BEGIN WORK
#No.FUN-540027 --start--
        CALL s_auto_assign_no("apm",g_rva.rva01,g_rva.rva06,"3","rva_file","rva01","","","")
             RETURNING li_result,g_rva.rva01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_rva.rva01
 
#      IF g_smy.smyauno='Y' THEN
#         CALL s_smyauno(g_rva.rva01,g_rva.rva06) RETURNING g_i,g_rva.rva01
#         IF g_i THEN CONTINUE WHILE END IF      #有問題
#         DISPLAY BY NAME g_rva.rva01
#      END IF
#No.FUN-540027 ---end--
 
      LET g_rva.rvaplant = g_plant #NO.FUN-980006 jarlin add
      LET g_rva.rvalegal = g_legal #NO.FUN-980006 jarlin add
     
      INSERT INTO rva_file VALUES (g_rva.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err(g_rva.rva01,SQLCA.sqlcode,1)
         ROLLBACK WORK #No:7857
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
      IF NOT cl_null(g_rva.rva02) THEN
         CALL t110_g_b()
      ELSE
         LET g_rec_b = 0
      END IF
 
      CALL t110_b()                   #輸入單身
 
      LET g_prt='Y'
      IF NOT cl_null(g_rva.rva01) AND g_smy.smyprint='Y' THEN  #是否馬上列印
         IF cl_confirm('mfg9392') THEN
            CALL t110_out()
         END IF
      END IF
 
      IF NOT cl_null(g_rva.rva01) AND g_smy.smydmy4='Y' THEN  #確認
         LET g_flag2 = '1'   #MOD-910053
         CALL t110_y()
         LET g_flag2 = '0'   #MOD-910053
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_k()
   DEFINE l_rvb22      LIKE rvb_file.rvb22    #No.FUN-680136 VARCHAR(20)
   DEFINE l_i          LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_cnt        LIKE type_file.num5    #No.MOD-720103 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   #大陸版, 發票統一在入庫單發票維護作業輸入
   IF g_aza.aza26 = '2' THEN
      CALL cl_err('','apm-978',0) #No.TQC-7C0086
      RETURN
   END IF
 
   IF cl_null(g_rva.rva01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
 
   IF g_rva.rvaconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
 
  #---------------No.MOD-720103 modify
  #LET l_rvb22=目前所指向的單身項次所對應的發票號碼
  #SELECT MAX(rvb22) INTO l_rvb22 FROM rvb_file WHERE rvb01=g_rva.rva01
   LET l_rvb22 = g_rvb[l_ac].rvb22
  #---------------No.MOD-720103 end
   CALL sapmt114(l_rvb22,g_rva.rva01) RETURNING l_rvb22
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
  #--------------------No.MOD-720103 modify
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
         END IF
      END IF
   END IF
 
  #UPDATE滑鼠所指向單身項次所對應的發票號碼
   UPDATE rvb_file
      SET rvb22=l_rvb22
    WHERE rvb01=g_rva.rva01
      AND rvb02 = g_rvb[l_ac].rvb02
 
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      LET g_rvb[l_ac].rvb22 = l_rvb22
   END IF
  #--------------------No.MOD-720103 end
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
&ifdef ICD                                                                                                                          
         UPDATE rvbi_file SET rvbi01=g_rva.rva01 WHERE rvbi01=g_rva01_t    #TQC-970351                                              
&endif  
         IF STATUS THEN
#           CALL cl_err('update rvb',STATUS,1) #No.FUN-660129
            CALL cl_err3("upd","rvb_file",g_rva01_t,"",STATUS,"","update rvb",1) #No.FUN-660129
            ROLLBACK WORK
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rva_file SET * = g_rva.* WHERE rva01 = g_rva.rva01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('update rva',STATUS,0)  #No.FUN-660129
         CALL cl_err3("upd","rva_file","","",STATUS,"","update rva",1) #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE t110_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rva.rva01,'U')
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t110_u2()
 
   INPUT BY NAME g_rva.rva21,g_rva.rva08,g_rva.rva09 WITHOUT DEFAULTS
  
   #TQC-860019-add
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
 
   #TQC-860019-add
 
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
 
   #NO.FUN-960130----start-------
   IF g_azw.azw04='2' THEN
      DISPLAY BY NAME g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,
                      g_rva.rva31,g_rva.rvaplant,g_rva.rvacrat
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
   ##NO.FUN-960130---END-------
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   
   INPUT BY NAME g_rva.rvaoriu,g_rva.rvaorig,
         g_rva.rva01,g_rva.rva06,g_rva.rva02,g_rva.rva05,g_rva.rva99,
         g_rva.rva04,g_rva.rva21,g_rva.rva08,g_rva.rva29,g_rva.rva31, #NO.FUN-960130
         g_rva.rva09,g_rva.rva10,g_rva.rvaconf,g_rva.rvaspc,        #FUN-680011
         #No.FUN-940083 --begin
         g_rva.rva117,g_rva.rva111,g_rva.rva112,
         g_rva.rva115,g_rva.rva116,g_rva.rva113,
         g_rva.rva114,
         #No.FUN-940083 --end
         g_rva.rvauser,g_rva.rvagrup,g_rva.rvamodu,
         g_rva.rvadate,g_rva.rvaacti
         #FUN-840042     ---start---
         , g_rva.rvaud01,g_rva.rvaud02,g_rva.rvaud03,g_rva.rvaud04,
         g_rva.rvaud05,g_rva.rvaud06,g_rva.rvaud07,g_rva.rvaud08,
         g_rva.rvaud09,g_rva.rvaud10,g_rva.rvaud11,g_rva.rvaud12,
         g_rva.rvaud13,g_rva.rvaud14,g_rva.rvaud15 
         #FUN-840042     ----end----
      WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t110_set_entry(p_cmd)
        CALL t110_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-540027 --start--
         CALL cl_set_docno_format("rva01")
        #CALL cl_set_docno_format("rva02")  #No.MOD-640158 mark
         CALL cl_set_docno_format("rvb04")
#No.FUN-540027 ---end---
         CALL t110_set_required()      #NO.FUN-640151
 
      AFTER FIELD rva01
         IF NOT cl_null(g_rva.rva01) THEN
#        IF NOT cl_null(g_rva.rva01) AND (g_rva.rva01!=g_rva_t.rva01) THEN
            #TQC-650108
            LET g_t1=s_get_doc_no(g_rva.rva01)
            #得到該單別對應的屬性群組
            IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
               #讀取smy_file中指定作業對應的默認屬性群組
               SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
               #TQC-650108
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
               #TQC-650108 --end
               #刷新界面顯示
               CALL t110_refresh_detail()
            ELSE
               LET lg_smy62 = ''
            END IF
            #TQC-650108 --end
 
#No.FUN-540027 --start--
           CALL s_check_no("apm",g_rva.rva01,g_rva01_t,"3","rva_file","rva01","")
             RETURNING li_result,g_rva.rva01
           DISPLAY BY NAME g_rva.rva01
           IF (NOT li_result) THEN
             NEXT FIELD rva01
           END IF
#No.FUN-980038 --Begin
           IF cl_null(g_rva01_t) THEN
              CALL s_get_doc_no(g_rva.rva01) RETURNING l_slip                                                                  
              SELECT smy72 INTO l_rva10 FROM smy_file                                                                      
               WHERE smyslip = l_slip                                                                                          
              IF NOT cl_null(l_rva10) THEN
                 LET g_rva.rva10 = l_rva10
                 DISPLAY BY NAME g_rva.rva10
              END IF
           END IF
#No.FUN-980038 --End
#            LET g_t1=g_rva.rva01[1,3]   # 取驗收單號的前三位
#            CALL s_mfgslip(g_t1,'apm','3')#檢查單別(其中'3'代表採購系統的驗收單
#            IF NOT cl_null(g_errno) THEN             #抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0)
#               NEXT FIELD rva01
#            END IF
#            IF g_rva.rva01[1,3] IS NOT NULL AND cl_null(g_rva.rva01[5,10]) THEN     #請使用者自行輸入
#               IF g_smy.smyauno = 'N' THEN  #新增並要不自動編號
#                  NEXT FIELD rva01
#               ELSE #若使用者使用自動編號時則自動跳至下一欄位
#                  NEXT FIELD rva06     #輸入
#               END IF
#            END IF
#            IF g_smy.smyauno = 'N' THEN  #新增並要不自動編號
#               IF NOT cl_chk_data_continue(g_rva.rva01[5,10]) THEN
#                  CALL cl_err('','9056',0)
#                  NEXT FIELD rva01
#               END IF
#            END IF
#            #進行輸入之單號檢查
             CALL s_mfgchno(g_rva.rva01) RETURNING g_i,g_rva.rva01
             DISPLAY BY NAME g_rva.rva01
             IF NOT g_i THEN NEXT FIELD rva01 END IF
#            IF g_rva.rva01 != g_rva01_t OR g_rva01_t IS NULL THEN
#               SELECT count(*) INTO l_n FROM rva_file
#                WHERE rva01 = g_rva.rva01
#              IF l_n > 0 THEN                  # Duplicated
#                 CALL cl_err(g_rva.rva01,-239,0)
#                 LET g_rva.rva01 = g_rva01_t
#                 DISPLAY BY NAME g_rva.rva01
#                 NEXT FIELD rva01
#              END IF
#            END IF
#No.FUN-540027 ---end--
         #TQC-650108
         ELSE
            IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
               LET lg_smy62 = ''
               CALL t110_refresh_detail()
            END IF
         #TQC-650108 --end
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
#NO.FUN-640151 start--
#         IF g_argv2 = 'TAP' THEN
#             IF cl_null(g_rva.rva02) THEN
#                 CALL cl_err('','asf-087',0)
#                 NEXT FIELD rva02
#             END IF
#         END IF
#NO.FUN-640151 end-----
         IF NOT cl_null(g_rva.rva02) THEN
            #MOD-820179-begin-add
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
            #MOD-820179-end-add
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
            #TQC-650108
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
            #TQC-650108 --end
            CALL t110_rva05('d')
         END IF
         LET l_dir = 'D'
         #NO.FUN-960130----start----
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
         #NO.FUN-960130----end----
         CALL t110_set_no_entry(p_cmd)
 
       AFTER FIELD rva05 #廠商編號
          IF NOT cl_null(g_rva.rva05) THEN
             #No.MOD-880189--begin--
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
             #No.MOD-880189---end---
             CALL t110_rva05('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rva.rva05,g_errno,0)
                DISPLAY BY NAME g_rva.rva05
                NEXT FIELD rva05
             END IF
          END IF
 
 
       BEFORE FIELD rva10
          CALL t110_set_entry(p_cmd)
 
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
               #DISPLAY l_str TO FORMONLY.desc
             END IF
          END IF
          CALL t110_set_no_entry(p_cmd)
       #NO.FUN-960130------begin---------------
       AFTER FIELD rva31
          IF g_rva.rva31 IS NOT NULL  THEN
             CALL t110_rva31()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                RETURN
             END IF      
          END IF
       #NO.FUN-960130------end---------------
       BEFORE FIELD rva04
          IF NOT cl_null(g_rva.rva02) THEN            #判斷是否已存在信用狀檔
             SELECT COUNT(*) INTO l_cnt FROM alb_file
              WHERE alb04=g_rva.rva02
             IF l_cnt>0 THEN
                LET g_rva.rva04='Y'
                DISPLAY BY NAME g_rva.rva04
             END IF
          END IF
 
       AFTER FIELD rva04
          IF cl_null(g_rva.rva04) OR g_rva.rva04 NOT MATCHES '[YN]'  THEN
             NEXT FIELD rva04
          END IF
          LET l_dir = 'U'
   
       #FUN-940083--begin
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
         #No.TQC-9B0110  --Begin
        #IF g_rva.rva116 < 0 OR cl_null(g_rva.rva116) THEN
         IF g_rva.rva116 < 0 THEN
         #No.TQC-9B0110  --End  
            CALL cl_err(g_rva.rva116,'apm-087',0)
            DISPLAY BY NAME g_rva.rva116
            NEXT FIELD rva116
         END IF
 
       #FUN-940083--end
 
 
        #FUN-840042     ---start---
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
        #FUN-840042     ----end----
    
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
          #No.8969
          IF cl_null(g_rva.rva10) THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_rva.rva10 ATTRIBUTE(REVERSE)
          END IF
 
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD rva01
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rva01) #查詢單據性質
#                 LET g_t1=g_rva.rva01[1,3]
                 LET g_t1 = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
                #CALL q_smy(FALSE,FALSE,g_t1,'apm','3') RETURNING g_t1  #TQC-670008 remark
                 CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1  #TQC-670008
             #    LET g_rva.rva01[1,3]=g_t1
                 LET g_rva.rva01=g_t1         #No.FUN-540027
                 DISPLAY BY NAME g_rva.rva01
                 NEXT FIELD rva01
#
#               LET g_t1=g_rva.rva01[1,3]
#               CALL q_smy(0,0,g_t1,'apm','3') RETURNING g_t1
#               CALL FGL_DIALOG_SETBUFFER( g_t1 )
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_smy"
#               LET g_qryparam.default1 = g_t1,'apm','3'
#               LET g_qryparam.where = " AND smysys='apm' AND smykind = '3'"
#               CALL cl_create_qry() RETURNING g_t1
#                CALL FGL_DIALOG_SETBUFFER( g_t1 )
#               LET g_rva.rva01[1,3]=g_t1
#               DISPLAY BY NAME g_rva.rva01
#               NEXT FIELD rva01
#
             WHEN INFIELD(rva02) #查詢採購單號
#               CALL q_pmm6(2,16,g_rva.rva02,g_argv2) RETURNING g_rva.rva02
#               CALL FGL_DIALOG_SETBUFFER( g_rva.rva02 )
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_pmm6"   #No.MOD-890023 mark
&ifdef ICD
                #No.MOD-890023 add --begin
                 IF g_argv2 = 'ICD' THEN
                    LET g_qryparam.form ="q_pmm6_icd"
                 ELSE
                    LET g_qryparam.form ="q_pmm6"
                 END IF
                #No.MOD-890023 add --end
&else
                #No.MOD-890023 add --begin
                 LET g_qryparam.form ="q_pmm6"
                #No.MOD-890023 add --end
&endif
                 LET g_qryparam.default1 = g_rva.rva02
                 IF NOT cl_null(g_argv2) THEN
                    LET g_qryparam.where = "pmm02 ='",g_argv2,"' "
&ifdef ICD
                    #FUN-810038................begin
                       IF g_argv2='ICD' THEN
                         #No.MOD-890023 modify --begin
                         #IF NOT cl_null(g_rva.rva10) THEN
                         #   LET g_qryparam.where = " pmm02 LIKE 'WB%' AND pmm02<>'WB3'"
                         #ELSE
                         #   LET g_qryparam.where = " pmm02 ='",g_rva.rva10,"'"
                         #END IF
                          IF NOT cl_null(g_rva.rva10) THEN
                             LET g_qryparam.where = " pmm02 ='",g_rva.rva10,"'"
                          ELSE
                             LET g_qryparam.where = " pmm02 LIKE 'WB%' AND pmm02<>'WB3'"
                          END IF
                         #No.MOD-890023 modify --end
                       ELSE
                         #LET g_qryparam.where = "pmm02 <> 'TAP' AND pmm02 <> 'TRI' AND pmm02 <> 'SUB' AND (NOT pmm02 LIKE 'WB%')"   #No.MOD-890023 mark
                          LET g_qryparam.where = " pmm02 ='",g_argv2,"'"   #No.MOD-890023 add
                       END IF
                    #FUN-810038................end
&else
                       LET g_qryparam.where = " pmm02 ='",g_argv2,"'"   #No.MOD-890023 add
&endif
                 ELSE
                     LET g_qryparam.where = "pmm02 <> 'TAP' AND pmm02 <> 'TRI' AND pmm02 <> 'SUB'" #MOD-4A0146
                 END IF
                 CALL cl_create_qry() RETURNING g_rva.rva02
#                 CALL FGL_DIALOG_SETBUFFER( g_rva.rva02 )
                DISPLAY BY NAME g_rva.rva02
                NEXT FIELD rva02
             WHEN INFIELD(rva05) #查詢廠商
#               CALL q_pmc1(0,0,g_rva.rva05) RETURNING g_rva.rva05
#               CALL FGL_DIALOG_SETBUFFER( g_rva.rva05 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_rva.rva05
                 CALL cl_create_qry() RETURNING g_rva.rva05
#                 CALL FGL_DIALOG_SETBUFFER( g_rva.rva05 )
                DISPLAY BY NAME g_rva.rva05
                CALL t110_rva05('a')
                NEXT FIELD rva05
#FUN-940083--begin
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
#FUN-940083--end
             #NO.FUN-960130-----------------begin--------
             WHEN INFIELD(rva31)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem_1"
                LET g_qryparam.arg1 = g_rva.rvaplant
                LET g_qryparam.default1 = g_rva.rva31
                CALL cl_create_qry() RETURNING g_rva.rva31
                DISPLAY BY NAME g_rva.rva31
                NEXT FIELD rva31
             #NO.FUN-960130-----------------end--------
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
#NO.FUN-960130---BEGIN------
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
#NO.FUN-960130-----END------
FUNCTION t110_po(p_po,p_cmd)   #採購單號
   DEFINE
      p_po      LIKE rva_file.rva02,
      p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      l_pmm02   LIKE pmm_file.pmm02,
      l_pmm09   LIKE pmm_file.pmm09,
      l_pmm25   LIKE pmm_file.pmm25
 
   LET g_errno = " "
   #MOD-820179-begin-add
   IF NOT cl_null(g_rva.rva02) THEN 
      IF g_rva.rva02 <> p_po THEN
         LET g_errno='apm-940'
         RETURN
      END IF 
   END IF 
   #MOD-820179-end-add
 
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
 
&ifdef ICD
   #FUN-810038................begin
      IF cl_null(g_rva.rva10) THEN
         LET g_errno='aic-109'
         RETURN
      END IF
      IF l_pmm02='WB3' THEN
         LET g_errno='aic-110'
         RETURN
      END IF
      IF g_argv2='ICD' THEN
         IF l_pmm02<>g_rva.rva10 THEN
            LET g_errno='aic-111'
            RETURN
         END IF
      END IF
   #FUN-810038................end
&endif
 
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
     #DISPLAY l_str TO FORMONLY.desc
      DISPLAY BY NAME g_rva.rva05
      DISPLAY BY NAME g_rva.rva10
   END IF
 
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
      #FUN-690024------mod-------
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690024------mod-------
      WHEN l_pmc30 = '2'
         LET g_errno = 'mfg3227'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
#FUN-940083--begin
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
#FUN-940083--end
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION
 
#No.FUN-940083--begin
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
#No.FUN-940083--end
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rva.* TO NULL               #No.FUN-6A0162
 
   CALL cl_opmsg('q')
   CALL cl_msg("")
   CLEAR FORM
   CALL g_rvb.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   #No.TQC-660097 --start--
   IF g_sma.sma120 = 'Y'  THEN
      LET lg_smy62 = ''
      LET lg_group = ''
      CALL t110_refresh_detail()
   END IF
   #No.TQC-660097 --end--
 
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
#     CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)  #No.FUN-660129
      CALL cl_err3("sel","rva_file",g_rva.rva01,"",SQLCA.sqlcode,"","",1) #No.FUN-660129
      INITIALIZE g_rva.* TO NULL
      RETURN
   END IF
   #TQC-650108
   #在使用Q查詢的情況下得到當前對應的屬性組smy62
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
      LET l_slip = g_rva.rva01[1,g_doc_len]
      SELECT smy62 INTO lg_smy62 FROM smy_file
         WHERE smyslip = l_slip
   END IF
   #TQC-650108 --end
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
   DISPLAY BY NAME  g_rva.rva01,g_rva.rva05,g_rva.rva06,g_rva.rva02,  g_rva.rvaoriu,g_rva.rvaorig,
                    g_rva.rva99,g_rva.rva10,g_rva.rva04,g_rva.rva21,
                    g_rva.rva08,g_rva.rva09,
#No.FUN-940083--begin
#                   g_rva.rvaconf,g_rva.rvaspc,g_rva.rvauser,g_rva.rvagrup,  #FUN-680011
                    g_rva.rvaconf,g_rva.rvaspc,g_rva.rva117,
                    g_rva.rva111,g_rva.rva112,g_rva.rva115,g_rva.rva116,
                    g_rva.rva113,g_rva.rva114,
                    g_rva.rvauser,g_rva.rvagrup,  
#No.FUN-940083--end
                    g_rva.rvamodu,g_rva.rvadate,g_rva.rvaacti
                    ,g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,    #NO.FUN-960130
                    g_rva.rva31,g_rva.rva31                                  #NO.FUN-960130
                    #FUN-840042     ---start---
                    ,g_rva.rvaud01,g_rva.rvaud02,g_rva.rvaud03,g_rva.rvaud04,
                    g_rva.rvaud05,g_rva.rvaud06,g_rva.rvaud07,g_rva.rvaud08,
                    g_rva.rvaud09,g_rva.rvaud10,g_rva.rvaud11,g_rva.rvaud12,
                    g_rva.rvaud13,g_rva.rvaud14,g_rva.rvaud15 
                    #FUN-840042     ----end----
   #CKP
   IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
  END IF                                  #No.FUN-940083 add by shi
 
   CALL s_prtype(g_rva.rva10) RETURNING l_str
   #NO.FUN-960130----start-------                                                                                                   
   IF g_azw.azw04='2' THEN                                                                                                        
      DISPLAY BY NAME g_rva.rvacond,g_rva.rvaconu,g_rva.rva29,g_rva.rva30,                                                          
                      g_rva.rva31,g_rva.rvaplant,g_rva.rvacrat                                                                                      
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
   ##NO.FUN-960130---END-------
  #DISPLAY l_str TO FORMONLY.desc
   CALL t110_rva05('d')
 
   IF cl_null(g_wc2) THEN
      LET g_wc2=' 1=1 '
   END IF
   CALL t110_b_fill(g_wc2)
 
   #No.FUN-550117
#No.FUN-610018
#  IF g_gec07 = 'Y' THEN                       #No.FUN-560102
#     CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",TRUE)
#  ELSE
#     CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",FALSE)
#  END IF
#  #end No.FUN-550117
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_r()       #刪除
    DEFINE l_chr,l_sure LIKE type_file.chr1,  #No.FUN-680136 VARCHAR(01)
           l_cnt        LIKE type_file.num5,  #No.FUN-680136 SMALLINT
           l_rvb22      LIKE rvb_file.rvb22   #No:7746
    DEFINE li_result    LIKE type_file.num5   #FUN-810038
&ifndef STD
    DEFINE l_flag       LIKE type_file.chr1   #No.FUN-7B0018
&endif
    DEFINE l_i          LIKE type_file.num5   #no.CHI-860008
    DEFINE l_rvb93      LIKE rvb_file.rvb93   #FUN-9A0065
    DEFINE l_ac         LIKE type_file.num5   #FUN-9A0065
 
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
&ifdef ICD
       #FUN-810038................begin
#FUN-9A0065---BEGIN
        LET l_ac = 0
        SELECT COUNT(*) INTO l_ac FROM rvb_file 
         WHERE rvb01 = g_rva.rva01 AND rvb93 IS NOT NULL
        IF l_ac>0  THEN
           IF NOT cl_confirm('單身來源為電子交貨單，是否確定刪除？') THEN
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN           
           END IF
           l_sql = " SELECT rvb93 FROM rvb_file WHERE rvb01 = '",g_rva.rva01,"' AND rvb93 IS NOT NULL"
           PREPARE e_pre FROM g_sql
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
#FUN-9A0065---END       
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM ida_file
           WHERE ida07 = g_rva.rva01
          IF g_cnt > 0 THEN
             #此單號項次已有刻號/BIN明細資料，將一併刪除,是否確定執行此動作?
             IF NOT cl_confirm('aic-112') THEN
                CLOSE t110_cl
                ROLLBACK WORK
                RETURN
             ELSE
                CALL s_icdinout_del(0,g_rva.rva01,'','') RETURNING li_result  
                IF li_result = 0 THEN 
                   CLOSE t110_cl
                   ROLLBACK WORK
                   RETURN
                END IF
             END IF
          END IF
 
          #一併刪除回貨資料
          LET g_cnt = 0 
          SELECT COUNT(*) INTO g_cnt FROM idg_file
             WHERE idg01 = g_rva.rva01
          IF g_cnt > 0 THEN
             DELETE FROM idg_file
                WHERE idg01 = g_rva.rva01
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CLOSE t110_cl
                CALL cl_err('del idg err',SQLCA.SQLCODE,0)
                ROLLBACK WORK
                RETURN
             END IF
          END IF
 
          #FUN-920080 begin --
          LET g_cnt = 0 
          SELECT COUNT(*) INTO g_cnt FROM idd_file
             WHERE idd10 = g_rva.rva01
          IF g_cnt > 0 THEN
             DELETE FROM idd_file
                WHERE idd10 = g_rva.rva01
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CLOSE t110_cl
                CALL cl_err('del idd err',SQLCA.SQLCODE,0)
                ROLLBACK WORK
                RETURN
             END IF
          END IF
         #FUN-920080 end
       #FUN-810038................end
&endif
       CALL cl_msg("Delete rva,rvb!")
       #No:7746 刪除發票資料
       DECLARE rvb22_cur CURSOR FOR
        SELECT UNIQUE rvb22
          FROM rvb_file
         WHERE rvb01 = g_rva.rva01
 
       CALL s_showmsg_init()        #No.FUN-710030
       FOREACH rvb22_cur INTO l_rvb22
#No.FUN-710030 -- begin --
          IF g_success="N" THEN
             LET g_totsuccess="N"
             LET g_success="Y"
          END IF
#No.FUN-710030 -- end --
          SELECT COUNT(*) INTO g_cnt
            FROM rvb_file
           WHERE rvb22 = l_rvb22
             AND rvb01 <> g_rva.rva01
          IF g_cnt = 0 THEN
             DELETE FROM rvw_file
              WHERE rvw01 = l_rvb22
             IF SQLCA.sqlcode THEN
             #  CALL cl_err('DEL rvw_filee err!',SQLCA.SQLCODE,0) #No.FUN-660129
#No.FUN-710030 -- begin --
#                CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.sqlcode,"","DEL rvw_filee err!",1) #No.FUN-660129
#                ROLLBACK WORK
#                RETURN
                LET g_success = 'N'
                IF g_bgerr THEN
                   CALL s_errmsg("rvw01",l_rvb22,"DEL rvw_filee err!",SQLCA.sqlcode,1)
                   CONTINUE FOREACH
                ELSE
                   CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.sqlcode,"","DEL rvw_filee err!",1)
                   EXIT FOREACH
                END IF
#No.FUN-710030 -- end --
             END IF
          END IF
       END FOREACH
#No.FUN-710030 -- begin --
       IF g_totsuccess="N" THEN
          LET g_success="N"
       END IF
#No.FUN-710030 -- end --
 
       DELETE FROM rva_file WHERE rva01 = g_rva.rva01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('No rva deleted',SQLCA.SQLCODE,0)  #No.FUN-660129
#No.FUN-710030 -- begin --
#          CALL cl_err3("del","rva_file",g_rva.rva01,"",SQLCA.SQLCODE,"","No rva deleted",1) #No.FUN-660129
#          ROLLBACK WORK
#          RETURN
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("rva01",g_rva.rva01,"No rva deleted",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("del","rva_file",g_rva.rva01,"",SQLCA.SQLCODE,"","No rva deleted",1)
         END IF
#No.FUN-710030 -- end --
       END IF
 
       DELETE FROM rvb_file WHERE rvb01 = g_rva.rva01
&ifndef STD
       #No.FUN-7B0018 080306 modify --begin
       LET l_flag = s_del_rvbi(g_rva.rva01,'','')
#      #No.FUN-7C0017 --Begin
#         DELETE FROM rvbi_file WHERE rvbi01 = g_rva.rva01
#      #No.FUN-7C0017 --End
       #No.FUN-7B0018 080306 modify --end
&endif
       LET g_msg=TIME
 
#--no.CHI-860008 add----------
        FOR l_i = 1 TO g_rec_b 
#           IF NOT s_del_rvbs("2",g_rva.rva01,g_rvb[l_i].rvb02,'')  THEN          #FUN-880129 Mark
            IF NOT s_del_rvbs("2",g_rva.rva01,g_rvb[l_i].rvb02,0)  THEN           #FUN-880129
              ROLLBACK WORK
              RETURN FALSE
            END IF
        END FOR
#--no.CHI-860008 add----------
 
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #NO.FUN-980006 add azoplant,azolegal
                     VALUES('apmt110',g_user,g_today,g_msg,g_rva.rva01,'delete',g_plant,g_legal) #NO.FUN-980006 add azoplant,azolegal
 
       CLEAR FORM
       CALL g_rvb.clear()
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
#No.FUN-710030 -- begin --
#    COMMIT WORK
    CALL s_showmsg()
    IF g_success= 'N' THEN
       ROLLBACK WORK
       LET g_success = 'Y'
       RETURN
    ELSE
       COMMIT WORK
    END IF
#No.FUN-710030 -- end --
 
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
      l_pmm904        LIKE pmm_file.pmm904,
      l_pmm50         LIKE pmm_file.pmm50,
      l_smy57_5       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(01)
      l_pmm04         LIKE pmm_file.pmm04,
      l_poz011        LIKE poz_file.poz011,
      # Prog. Version..: '5.30.06-13.03.12(01)   #MOD-910227
      l_msg           LIKE type_file.chr50,    #No.FUN-680136 VARCHAR(40)
      l_sfb24         LIKE sfb_file.sfb24,
      l_code          LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_ima491        LIKE ima_file.ima491,
      s_mod,ss        LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      sn1,sn2,l_cnt   LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_num           LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_fac           LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
      #TQC-650108
      li_i            LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_count         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_check_res     LIKE type_file.num5,     #No.FUN-680136 SMALLINT
      l_temp          LIKE ima_file.ima01,
      #TQC-650108 --end
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
      #No.FUN-810016 --begin--      
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
      #No.FUN-810016 --end--
      li_result       LIKE type_file.num5
&ifdef ICD
   DEFINE l_ecm03     LIKE ecm_file.ecm03        #FUN-810038
   DEFINE l_ecm03_max LIKE ecm_file.ecm03        #FUN-810038
   DEFINE l_rvb07_3_tky LIKE rvb_file.rvb07      #FUN-810038
   DEFINE l_imaicd08  LIKE imaicd_file.imaicd08  #FUN-810038
   DEFINE l_pmn07     LIKE pmn_file.pmn07        #FUN-810038
   DEFINE l_ida15     LIKE ida_file.ida15        #FUN-810038   
   DEFINE l_dies      LIKE rvb_file.rvb07        #FUN-810038
   DEFINE l_pmniicd13 LIKE pmni_file.pmniicd13   #FUN-950040
&endif
   DEFINE l_ima153    LIKE ima_file.ima153       #FUN-910053 
   DEFINE l_img09     LIKE img_file.img09        #FUN-940083   
   DEFINE l_smd04     LIKE smd_file.smd04        #FUN-940083   
   DEFINE l_smd06     LIKE smd_file.smd06        #FUN-940083   
   DEFINE l_rvb90_fac LIKE rvb_file.rvb90_fac    #FUN-940083   
   DEFINE l_gem02        LIKE gem_file.gem02    #NO.FUN-960130
   DEFINE l_pmm51        LIKE pmm_file.pmm51    #NO.FUN-960130
   DEFINE l_times        LIKE sma_file.sma134   #NO.FUN-960130
   DEFINE l_pmn14        LIKE pmn_file.pmn14    #NO.FUN-960130
 
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
 
   CALL cl_opmsg('b')
 
   #No.FUN-540027  --begin
  #FUN-730068.................begin
  ##------------------No.TQC-660053 modify
  #LET g_forupd_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,rvb05, ",
  #                   "       '','','','','','','','','','','', ",
  #                   "       '','','','','','','','','','', ",
  #                   "       '','', ",
  ##------------------No.TQC-660053 end
  #                   "       '',0,0,rvb30,rvb29,rvb35,rvb07,rvb83,rvb84,",
  #                   "       rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,rvb10,rvb10t, ",  #No.FUN-550117
  #                   "       rvb36,rvb37,rvb38,rvb25,'',0,rvb930,''  FROM rvb_file ",      #No.FUN-550117 FUN-610018  #FUN-670051
   LET g_forupd_sql = "SELECT * FROM rvb_file ",
  #FUN-730068.................end
                      " WHERE rvb01=? AND rvb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   #No.FUN-540027  --end
&ifndef STD
   #No.FUN-7C0017 -Begin
      LET g_forupd_sql = "SELECT * FROM rvbi_file ",
                         " WHERE rvbi01=? AND rvbi02=? FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE t110_bcl_ind CURSOR FROM g_forupd_sql      # LOCK CURSOR
   #No.FUN-7C0017 -End
&endif
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac = 1       #MOD-530431
 
   INPUT ARRAY g_rvb WITHOUT DEFAULTS FROM s_rvb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
            #FUN-850120 add begin
            IF g_sma.sma90 = 'Y' THEN
               CALL cl_set_act_visible("modi_lot", TRUE)
            ELSE
               CALL cl_set_act_visible("modi_lot", FALSE)
            END IF
            #FUN-850120 add end
 
            LET g_before_input_done = FALSE
            CALL t110_set_entry_b('a')
            CALL t110_set_no_entry_b('a')
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
               OPEN t110_bcl USING g_rva.rva01,g_rvb_t.rvb02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  #FETCH t110_bcl INTO g_rvb[l_ac].* #FUN-730068
                  FETCH t110_bcl INTO g_rvb2.*  #FUN-730068
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_rvb_t.rvb02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
&ifndef STD
                    #No.FUN-7C0017 -begin
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
                    #No.FUN-7C0017 -end
&endif
                     #No.MOD-490173 利用 p_perright 隱藏即可
                    #IF NOT cl_chk_act_auth() THEN
                    #   LET g_rvb[l_ac].rvb10=NULL
                    #END IF
                     CALL t110_b_move_to() #FUN-730068
                     SELECT ima021 INTO g_rvb[l_ac].ima021 FROM ima_file
                       WHERE ima01=g_rvb[l_ac].rvb05
                     CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
                     #No.FUN-540027  --begin
                     LET g_rvb05_t = g_rvb[l_ac].rvb05
                     #No.FUN-540027  --end
                     IF g_argv6 = '1' THEN    #FUN-940083
                        CALL t110_rvb03('d',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
                     END IF                   #FUN-940083
                     LET g_rvb[l_ac].rvb05 = g_rvb05_t                     #No.FUN-810016
                     IF g_rvb[l_ac].rvb05 != g_rvb[l_ac].rvb05a THEN        #NO.MOD-920003
                       SELECT ima02,ima021 INTO  g_rvb[l_ac].rvb051,g_rvb[l_ac].ima021 FROM ima_file  #No.FUN-810016 #FUN-940083 pmn041-->rvb051
                         WHERE ima01 = g_rvb[l_ac].rvb05                                            #No.FUN-810016
                     END IF                                                 #NO.MOD-920003
                     #No.FUN-610018
                     LET g_before_input_done = FALSE
                     CALL t110_set_entry_b(p_cmd)
                     CALL t110_set_no_entry_b(p_cmd)
                     LET g_before_input_done = TRUE
                     #FUN-730068...........begin
                     # #MOD-550195 add
                     #SELECT * INTO g_rvb2.*
                     #  FROM rvb_file
                     # WHERE rvb01=g_rva.rva01
                     #   AND rvb02=g_rvb_t.rvb02
                     # #MOD-550195(end)
                     #FUN-730068...........end
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF g_argv6 ='1' THEN           #FUN-940083--begin
               #No.FUN-810016 --begin--
                 SELECT ima150,ima151 INTO l_ima150,l_ima151 FROM ima_file
                  WHERE ima_file.ima01=g_rvb05_t
                 IF l_ima150!='0' OR  l_ima151 = 'Y' THEN
                    CALL cl_set_comp_entry('rvb05',TRUE)
                 ELSE
                  	 CALL cl_set_comp_entry('rvb05',FALSE)
                 END IF 
               #No.FUN-810016 --end--
            END IF                         #FUN-940083--end 
 
         BEFORE INSERT
            #-----MOD-930320---------
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
            IF g_cnt = g_sma.sma110 THEN
               CALL cl_err('','axm-156',0)
               CANCEL INSERT
            END IF
            #-----END MOD-930320-----
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rvb[l_ac].* TO NULL      #900423
            INITIALIZE arr_detail[l_ac].* TO NULL #TQC-650108
            LET g_rvb[l_ac].rvb04 = g_rva.rva02   #Body default
            LET g_rvb[l_ac].rvb89 = 'N'           #FUN-940083
            LET g_rvb[l_ac].rvb35 = 'N'
            LET g_rvb[l_ac].rvb07 = 0
            #No.FUN-540027  --begin
            LET g_rvb[l_ac].rvb82 = 0
            LET g_rvb[l_ac].rvb85 = 0
            LET g_rvb[l_ac].rvb87 = 0
            #No.FUN-540027  --end
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
            LET g_rvb2.rvb18  = '10'  #收貨狀況
            LET g_rvb2.rvb27  = 0     #NO USE
            LET g_rvb2.rvb28  = 0     #NO USE
            LET g_rvb2.rvb29  = 0     #退補量
            LET g_rvb2.rvb32  = 0     #NO USE
            LET g_rvb2.rvb31  = 0     #
            LET g_rvb2.rvb30  = 0     #入庫量
            LET g_rvb2.rvb33  = 0     #入庫量
            #No.FUN-580115  --begin
            LET g_rvb2.rvb331  = 0    #允收量
            LET g_rvb2.rvb332  = 0    #允收量
            #No.FUN-580115  --end
            LET g_rvb2.rvb35  = 'N'   #樣品否
            LET g_rvb2.rvb40  = ''    #檢驗日期 no.7143
            LET g_rvb2.rvbplant = g_rva.rvaplant   #NO.FUN-960130
            #No.FUN-540027  --begin
            LET g_rvb05_t = NULL
            #No.FUN-540027  --end
&ifdef ICD
            #FUN-810038................begin
               IF g_argv2='SUB' THEN
                  LET g_rvbi2.rvbiicd13 = 'N' #委外TKY非最終站否
               ELSE
                  LET g_rvbi2.rvbiicd13 = ' ' #委外TKY非最終站否
               END IF
               LET g_rvb[l_ac].rvbiicd03 = ' ' # ICD作業編號
               LET g_rvbi2.rvbiicd04 = 'N' # New code
               LET g_rvbi2.rvbiicd05 = 'N' # Low yield
               LET g_rvbi2.rvbiicd06 =  0  # 不良品數
               LET g_rvbi2.rvbiicd07 =  0  # 報廢數量
               LET g_rvbi2.rvbiicd09 = 'N' # 回貨否
            #FUN-810038................end
&endif
            CALL t110_set_entry_b(p_cmd)          #No.FUN-610018
            CALL t110_set_no_entry_b(p_cmd)	  #MOD-980043
            LET g_rvb_t.* = g_rvb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rvb02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-540027  --begin
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
 
            IF cl_null(g_rvb[l_ac].rvb86) THEN
               LET g_rvb[l_ac].rvb86 = g_rvb[l_ac].rvb90    #No.FUN-940083 pmn07-->rvb90 
               LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
            END IF
            #No.FUN-540027  --end
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
 
            #備註:AFTER FIELD rvb22有寫到-------------------------------begin
            #modi in 00/01/18 若為LC收貨，則須檢查數貨不可大於提單數量
            #IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
            #   SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
            #    WHERE als01=g_rvb[l_ac].rvb22
            #   IF SQLCA.sqlcode=100 THEN
#           #      CALL cl_err(g_rvb[l_ac].rvb22,'aap-762',1)  #No.FUN-660129
            #      CALL cl_err3("sel","als_file",g_rvb[l_ac].rvb22,"","aap-762","","",1) #No.FUN-660129
            #      CALL g_rvb.deleteElement(l_ac)
            #      NEXT FIELD rvb22
            #     #CANCEL INSERT       #MOD-680004 mark
            #   END IF
            #   IF l_als05 <> g_rva.rva05 THEN
            #      CALL cl_err('','apm-303',1)
            #      CALL g_rvb.deleteElement(l_ac)
            #      NEXT FIELD rvb22
            #     #CANCEL INSERT       #MOD-680004 mark
            #   END IF
            #備註:AFTER FIELD rvb22有寫到------------------------------end
 
            #備註:AFTER FIELD rvb07有寫到------------------------------begin
            #   IF NOT cl_null(l_als21) THEN
            #      LET g_rva.rva08 = l_als21
            #      DISPLAY BY NAME g_rva.rva08
            #   END IF
            #   SELECT alt06 INTO l_alt06 FROM alt_file
            #    WHERE alt01=g_rvb[l_ac].rvb22
            #      AND alt14=g_rvb[l_ac].rvb04
            #      AND alt15=g_rvb[l_ac].rvb03
            #   IF cl_null(l_alt06) THEN
            #      LET l_alt06 = 0
            #   END IF
            #   SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
            #    WHERE rvb22=g_rvb[l_ac].rvb22
            #      AND rvb04=g_rvb[l_ac].rvb04
            #      AND rvb03=g_rvb[l_ac].rvb03
            #      AND rvb01!=g_rva.rva01 AND rvb35='N'
            #   IF cl_null(t_alt06) THEN
            #      LET t_alt06 = 0
            #   END IF
            #   IF g_rvb[l_ac].rvb07 > (l_alt06-t_alt06) THEN
            #      CALL cl_err('','apm-305',0)
            #      CALL g_rvb.deleteElement(l_ac)
            #      #No.FUN-540027  --begin
            #      IF g_sma.sma115 = 'Y' THEN
            #         IF g_ima906 MATCHES '[23]' THEN
            #            NEXT FIELD rvb85
            #         ELSE
            #            NEXT FIELD rvb82
            #         END IF
            #      ELSE
            #         NEXT FIELD rvb07
            #      END IF
            #     #CANCEL INSERT       #MOD-680004 mark
            #      #No.FUN-540027  --end
            #   END IF
            #END IF
            #備註:AFTER FIELD rvb07有寫到-----------------------------end
 
            #備註:在確認段會卡,所以若料/倉/儲/批不存在不能確認
            #所以不需在此重覆判斷
            #---再判斷一次倉儲批是否存在
            #IF NOT cl_null(g_rvb[l_ac].rvb36) THEN
            #   IF g_rvb[l_ac].rvb37 IS NULL THEN
            #      LET g_rvb[l_ac].rvb37=' '
            #   END IF
            #   IF g_rvb[l_ac].rvb38 IS NULL THEN
            #      LET g_rvb[l_ac].rvb38=' '
            #   END IF
            #   SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
            #     FROM img_file   #採購單位,庫存數量,庫存單位
            #    WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
            #      AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
            #   IF STATUS=100 AND (g_rvb[l_ac].rvb36 IS NOT NULL AND g_rvb[l_ac].rvb36 <> ' ') THEN
            #      IF g_sma.sma892[3,3] ='Y' THEN
            #         IF NOT cl_confirm('mfg1401') THEN
            #            CALL g_rvb.deleteElement(l_ac)
            #            NEXT FIELD rvb38
            #           #CANCEL INSERT       #MOD-680004 mark
            #         END IF
            #      END IF
            #      CALL s_add_img(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
            #                     g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
            #                     g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06)
            #   END IF
            #   SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
            #     FROM img_file
            #    WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
            #      AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
            #END IF
            CALL t110_b_move_back() #FUN-730068
            #CHI-7B0023..............begin #本段移到move_back內
            #LET g_rvb2.rvb01 = g_rva.rva01
            #LET g_rvb2.rvb02 = g_rvb[l_ac].rvb02
            #LET g_rvb2.rvb03 = g_rvb[l_ac].rvb03
            #LET g_rvb2.rvb04 = g_rvb[l_ac].rvb04
            #LET g_rvb2.rvb05 = g_rvb[l_ac].rvb05
            #LET g_rvb2.rvb06 = 0
            #LET g_rvb2.rvb07 = g_rvb[l_ac].rvb07
            ##No.FUN-540027  --begin
            #LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
            #LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
            #LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
            #LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
            #LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
            #LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85
            #LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
            #LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
            ##No.FUN-540027  --end
            #CHI-7B0023..............end
            #No.MOD-490173 一律讓 rvb10 有值，只須依p_perright隱藏
           #IF cl_chk_act_auth() THEN
               IF cl_null(g_rvb[l_ac].rvb10) THEN
                  LET g_rvb[l_ac].rvb10 = 0
               END IF
               LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
           #ELSE
           #   IF cl_null(g_pmn31) THEN LET g_pmn31 = 0 END IF
           #   LET g_rvb2.rvb10 = g_pmn31
           #END IF
            #No.FUN-550117
            IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
            LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
            #end No.FUN-550117
            LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
            LET g_rvb2.rvb26 = NULL
           #LET g_rvb2.rvb31 = g_rvb2.rvb07        #可入庫量  #MOD-880166 mark
            LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
            LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
            LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
            LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
            LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
            LET g_rvb2.rvb930= g_rvb[l_ac].rvb930  #FUN-670051
            LET g_rvb2.rvb051= g_rvb[l_ac].rvb051  #FUN-940083
            LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89   #FUN-940083
            LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90   #FUN-940083
          #----------No.MOD-650095 modify
           #IF cl_null(g_rvb2.rvb08) THEN
            IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN
          #----------No.MOD-650095 end
               LET g_rvb2.rvb08 = g_rvb2.rvb07
            END IF
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
            #FUN-850022 --begin
             #CALL t110_get_rvb39(g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
             CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
                  RETURNING g_rvb2.rvb39 #MOD-530415
            #FUN-850022 --end
            #No.FUN-540027  --begin
            LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
            LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
            #No.FUN-540027  --end
    
            IF g_argv6 ='1' THEN                        #FUN-940083
               #CHI-830033-begin-add
               #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
               SELECT gec07 INTO g_gec07 FROM gec_file,pmm_file
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
               IF g_gec07='Y' THEN
                  LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                  LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
               ELSE
                  LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
               END IF
               #CHI-830033-end-add
            #FUN-940083--begin
            ELSE
               SELECT gec07 INTO g_gec07 FROM gec_file
                WHERE gec01 = g_rva.rva115
               IF SQLCA.SQLCODE = 100 THEN
                  CALL cl_err('','mfg3192',0)
                  NEXT FIELD rvb05
               END IF
               SELECT azi04 INTO t_azi04 
                 FROM azi_file
                WHERE azi01 = g_rva.rva113
               IF g_gec07='Y' THEN
                  LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                  LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
               ELSE
                  LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
                  LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
               END IF
            END IF
            #FUN-940083--end
 
            #MOD-810137-begin-add
            IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
            IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
            IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
            #MOD-810137-end-add
#FUN-940083--begin
            IF l_rvb90_fac IS NULL THEN
               LET g_rvb2.rvb90_fac=1 
            ELSE
               LET g_rvb2.rvb90_fac=l_rvb90_fac
            END IF
#FUN-940083--end
#FUN-9A0068--begin
            CALL t110_chk_rvb36()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rvb2.rvb36,'apm-329',1)
               NEXT FIELD rvb36
            END IF
#FUN-9A0068--end
            #NO.FUN-960130---start-----
            LET g_rvb2.rvbplant=g_rva.rvaplant 
            LET g_rvb2.rvblegal=g_rva.rvalegal 
            IF g_azw.azw04='2' THEN 
               LET g_rvb2.rvb42 =g_rvb[l_ac].rvb42
               LET g_rvb2.rvb43 =g_rvb[l_ac].rvb43
               LET g_rvb2.rvb44 =g_rvb[l_ac].rvb44
               LET g_rvb2.rvb45 =g_rvb[l_ac].rvb45 
            END IF
            IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '1' END IF 
            #FUN-960130---end-------
            LET g_rvb2.rvbplant = g_plant #NO.FUN-980006 jarlin add
            LET g_rvb2.rvblegal = g_legal #NO.FUN-980006 jarlin add
            INSERT INTO rvb_file VALUES (g_rvb2.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_rvb[l_ac].rvb02,SQLCA.sqlcode,0) #No.FUN-660129
               CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
               CANCEL INSERT
               #-----No.FUN-810036-----
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                    IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045
                       CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                  END IF
               END IF
               #-----No.FUN-810036 END-----
            ELSE
&ifndef STD
               #No.FUN-7B0018 080306 modify --begin
               #No.FUN-7C0017 -begin
               LET g_rvbi2.rvbi01 = g_rvb2.rvb01
               LET g_rvbi2.rvbi02 = g_rvb2.rvb02
               IF NOT s_ins_rvbi(g_rvbi2.*,'') THEN
                  CANCEL INSERT
               END IF
#              INSERT INTO rvbi_file VALUES (g_rvbi2.*)
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3("ins","rvbi_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1)
#                 CANCEL INSERT
#              END IF
               #No.FUN-7C0017 -end
               #No.FUN-7B0018 080306 modify --end
&endif
               CALL cl_msg('INSERT O.K')
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
         BEFORE FIELD rvb02                        #default 序號
            IF cl_null(g_rvb[l_ac].rvb02) OR g_rvb[l_ac].rvb02 = 0 THEN
               SELECT max(rvb02)+1
                 INTO g_rvb[l_ac].rvb02
                 FROM rvb_file
                WHERE rvb01 = g_rva.rva01
               IF g_rvb[l_ac].rvb02 IS NULL THEN
                  LET g_rvb[l_ac].rvb02 = 1
               END IF
            END IF
 
         AFTER FIELD rvb02                        #check 序號是否重複
            IF g_rvb[l_ac].rvb02 != g_rvb_t.rvb02 OR g_rvb_t.rvb02 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM rvb_file
                WHERE rvb01 = g_rva.rva01
                  AND rvb02 = g_rvb[l_ac].rvb02
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_rvb[l_ac].rvb02 = g_rvb_t.rvb02
                  NEXT FIELD rvb02
               END IF
&ifdef ICD
               #FUN-810038................begin
                  IF NOT t110_ind_icd_chk_icd() THEN
                     LET g_rvb[l_ac].rvb02=g_rvb_t.rvb02
                     DISPLAY BY NAME g_rvb[l_ac].rvb02
                     NEXT FIELD CURRENT
                  END IF
               #FUN-810038................end
&endif
            END IF
            LET l_direct = 'D'
 
         BEFORE FIELD rvb22
            LET l_rvb22_old = g_rvb[l_ac].rvb22
 
         AFTER FIELD rvb22
            IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
               SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
                WHERE als01=g_rvb[l_ac].rvb22
               IF SQLCA.sqlcode=100 THEN
#                 CALL cl_err(g_rvb[l_ac].rvb22,'aap-762',0)  #No.FUN-660129
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
            #No:7746
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
               g_sma.sma886[3,3] = 'Y' AND
              (g_rva.rva04 ='N' OR g_rva.rva04 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM rvw_file
                WHERE rvw01=g_rvb[l_ac].rvb22
               IF l_n = 0 OR g_rvb[l_ac].rvb22 != g_rvb_t.rvb22 THEN
                  CALL sapmt114(g_rvb[l_ac].rvb22,g_rva.rva01)
                                RETURNING g_rvb[l_ac].rvb22
                 #MOD-810208-begin-modify
                  IF INT_FLAG THEN
                     LET g_rvb[l_ac].rvb22 = ''
                     DISPLAY BY NAME g_rvb[l_ac].rvb22
                  ELSE 
                     DISPLAY g_rvb[l_ac].rvb22 TO rvb22  #No.MOD-480094
                  END IF 
                 #MOD-810208-end-modify
                  LET INT_FLAG=0
 
                 #-----MOD-830210 
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
                        END IF
                     END IF
                 END IF
                 #-----END MOD-830210 
  
               END IF
            END IF
            #-----MOD-760141---------
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
               #No.MOD-840575  --begin--
               IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04) THEN    
                 IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                   SELECT * FROM alt_file
                     WHERE alt01=g_rvb[l_ac].rvb22
                       AND alt14=g_rvb[l_ac].rvb04
                       AND alt15=g_rvb[l_ac].rvb03
                  IF SQLCA.sqlcode=100 THEN
#                    CALL cl_err('','apm-304',0)  #No.FUN-660129
                     CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
#                    NEXT FIELD rvb04                               
                     LET g_rvb[l_ac].rvb22= g_rvb_t.rvb22            
                     NEXT FIELD rvb22                                
                  END IF
                 END IF
              END IF                                           
              #No.FUN-840575   --end--
            END IF
            #-----END MOD-760141-----
 
 
         AFTER FIELD rvb05
&ifdef ICD
            #FUN-810038................begin
               IF p_cmd = 'u' AND NOT cl_null(g_rvb[l_ac].rvb05) THEN
                  IF g_rvb_t.rvb05 <> g_rvb[l_ac].rvb05 THEN
                     IF NOT t110_ind_icd_chk_icd() THEN
                        LET g_rvb[l_ac].rvb05=g_rvb_t.rvb05
                        DISPLAY BY NAME g_rvb[l_ac].rvb05
                        NEXT FIELD CURRENT
                     END IF  
                  END IF
               END IF
            #FUN-810038................end
&endif
           #No.FUN-840178 --begin-- 
                IF NOT cl_null(g_rvb[l_ac].rvb05) THEN    
                   SELECT COUNT(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_rvb[l_ac].rvb05
                       AND imaacti='Y'
                       AND ima151 != 'Y'
                   IF l_n = 0 THEN 
                      CALL cl_err('','apm-452',0)
                      LET g_rvb[l_ac].rvb05 = g_rvb_t.rvb05
                      NEXT FIELD rvb05 
                   END IF 
                END IF    
           #No.FUN-840178--end--
            
             #No.FUN-810016 --begin--
            SELECT ima150,ima151 INTO l_ima150,l_ima151
              FROM ima_file
             WHERE ima01=g_rvb[l_ac].rvb05a
             IF g_rvb[l_ac].rvb05!=g_rvb[l_ac].rvb05a THEN
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
             {  	SELECT COUNT(*) INTO l_n1 FROM imx_file a,imx_file b
               	  WHERE a.imx000 = g_rvb[l_ac].rvb05a 
               	    AND b.imx000 = g_rvb[l_ac].rvb05
               	    AND (a.imx01=b.imx01 OR(a.imx01 is null and b.imx01 is null))
               	    AND (a.imx02=b.imx02 OR(a.imx02 is null and b.imx02 is null))
               	    AND (a.imx03=b.imx03 OR(a.imx03 is null and b.imx03 is null))
               	    AND (a.imx04=b.imx04 OR(a.imx04 is null and b.imx04 is null))
               	    AND (a.imx05=b.imx05 OR(a.imx05 is null and b.imx05 is null))
               	    AND (a.imx06=b.imx06 OR(a.imx06 is null and b.imx06 is null))
               	    AND (a.imx07=b.imx07 OR(a.imx07 is null and b.imx07 is null))
               	    AND (a.imx08=b.imx08 OR(a.imx08 is null and b.imx08 is null))
               	    AND (a.imx09=b.imx09 OR(a.imx09 is null and b.imx09 is null))
               	    AND (a.imx10=b.imx10 OR(a.imx10 is null and b.imx10 is null))}
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
             #No.FUN-810016 --end--
             
            #TQC-650108
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
            #TQC-650108 --end
            IF g_argv6 ='2' OR g_rvb[l_ac].rvb05 != g_rvb[l_ac].rvb05a THEN #MOD-920003 #FUN-940083
               CALL t110_rvb05('d')                  #No.FUN-840178
#FUN-9A0068--begin
               CALL t110_rvb89('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb05,g_errno,0)
                  DISPLAY BY NAME g_rvb[l_ac].rvb89
               END IF
#FUN-9A0068--begin
            END IF                                   #NO.MOD-930003
 
         #FUN-940083--begin 
         BEFORE FIELD rvb051 
            IF g_rvb[l_ac].rvb05[1,4]='MISC'  THEN
               CALL t110_set_entry_b(p_cmd)
               CALL t110_set_no_entry_b(p_cmd)
            END IF
 
         AFTER FIELD rvb89
            IF NOT cl_null(g_rvb[l_ac].rvb89) THEN
               IF g_rvb[l_ac].rvb89 NOT MATCHES '[YN]'THEN
                  NEXT FIELD rvb89
               END IF
            END IF
 
         BEFORE FIELD rvb90
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_no_entry_b(p_cmd)
 
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
               END IF
            END IF
         #FUN-940083--end 
 
         #TQC-650108
         #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
         #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
         #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
         #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
         #其他分支就不需要這么麻煩了
         BEFORE FIELD att00
#           IF g_sma.sma908 <> 'Y' THEN
#              #否則開窗選的是子料件并且要回寫各個明細屬性到各個列中
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima_q"
#               LET g_qryparam.default1 = g_rvb[l_ac].att00
#              LET g_qryparam.arg1 = lg_group
#              CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb05
#               CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].att00 )
#              DISPLAY BY NAME g_rvb[l_ac].att00        #No.MOD-490371
 
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
 
#              NEXT FIELD rvb906
#           END IF
 
         #FUN-640013 Add,以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
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
         #TQC-650108 --end
 
#no.TQC-7C0108 --begin
         BEFORE FIELD rvb04     #採購單號
           CALL t110_set_entry_b('s')  #TQC-7C0131
              #TQC-7C0131 mark
              # IF g_sma.sma120 ="Y" THEN
              #    CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",TRUE)
              # END IF
              #TQC-7C0131 mark
#no.TQC-7C0108 --end
         AFTER FIELD rvb04     #採購單號
            IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
&ifdef ICD
             #FUN-940138--begin--mark-- 
             #FUN-920073--BEGIN--
             #IF NOT cl_null(g_rvb[l_ac].rvb03) THEN
             #  LET l_n2 = 0
             #  SELECT count(*) INTO l_n2 FROM pmn_file
             #   WHERE pmn68 = g_rvb[l_ac].rvb04
             #     AND pmn69 = g_rvb[l_ac].rvb03
             #   IF l_n2 > 0 THEN
             #      CALL cl_err('','aic-318',0)
             #      NEXT FIELD rvb04
             #   END IF
             #END IF
             ##FUN-920073--END--
             #FUN-940138--end--mark--
               #FUN-810038................begin
                  IF p_cmd = 'u' THEN
                     IF g_rvb_t.rvb04 <> g_rvb[l_ac].rvb04 THEN
                        IF NOT t110_ind_icd_chk_icd() THEN
                           LET g_rvb[l_ac].rvb04=g_rvb_t.rvb04
                           #No.FUN-810016---Begin
                           LET g_rvb[l_ac].rvb05 =g_rvb[l_ac].rvb05a 
                           LET g_rvb[l_ac].rvb051=g_rvb[l_ac].rvb05b  #FUN-940083 pmn041-->rvb051
                           LET g_rvb[l_ac].ima021=g_rvb[l_ac].rvb05c
                           #No.FUN-810016---End
                           DISPLAY BY NAME g_rvb[l_ac].rvb04
                           NEXT FIELD CURRENT
                        END IF
                     END IF
                  END IF
               #FUN-810038................end
&endif
               CALL t110_po(g_rvb[l_ac].rvb04,'b')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
                  NEXT FIELD rvb04
               END IF
               #NO.FUN-960130----BEGIN-----
               IF g_azw.azw04='2' THEN
                  SELECT pmm51 INTO l_pmm51 FROM pmm_file 
                       WHERE pmm01 = g_rvb[l_ac].rvb04
                  IF l_pmm51 != g_rva.rva29 THEN
                     CALL cl_err('','apm-925',0)
                     NEXT FIELD rvb04
                  END IF     
               END IF
               #NO.FUN-960130-----END----
                #-----No.MOD-570144-----
                  IF p_cmd = 'a' OR (p_cmd ='u' AND
                                 (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
                                 #MOD-810248-begin-modify
                                  g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) AND
                                  NOT cl_null(g_rvb[l_ac].rvb03)) THEN
                                 #g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) THEN
                                 #MOD-810248-end-modiy
                  IF NOT cl_null(g_rvb[l_ac].rvb03) THEN              #No.FUN-810016     
                     CALL t110_rvb03('a',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
                     #-----MOD-890170---------
                     IF g_rvb[l_ac].rvb07 <=0 THEN
                        #-----MOD-8B0037---------
                        #CALL cl_err('','mfg3348',0)
                        #LET g_rvb[l_ac].rvb04 = g_rvb_t.rvb04
                        #NEXT FIELD rvb04
                        IF NOT cl_confirm('mfg3353') THEN
                           LET g_rvb[l_ac].rvb04 = g_rvb_t.rvb04
                           NEXT FIELD rvb04
                        END IF
                        #-----END MOD-8B0037-----
                     END IF
                     #-----END MOD-890170-----
                  END IF                                              #No.FUN-810016   
                  IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
                  LET g_rvb2.rvb10 = g_pmn31
                  LET g_rvb[l_ac].rvb10 = g_pmn31
                  DISPLAY g_rvb[l_ac].rvb10 TO rvb10
                 #-MOD-970259-add-
                  LET g_rvb2.rvb10t = g_pmn31t
                  LET g_rvb[l_ac].rvb10t = g_pmn31t
                  DISPLAY g_rvb[l_ac].rvb10t TO rvb10t
                 #-MOD-970259-end-
                  IF NOT cl_null(g_errno) THEN
                     IF g_errno = 'mfg0159' THEN
                        NEXT FIELD rvb04
                     ELSE
                        CALL cl_err(g_rvb[l_ac].rvb04,g_errno,0)
                        NEXT FIELD rvb04
                     END IF
                  END IF
&ifdef ICD
                  #FUN-810038................begin
                     CALL t110_ind_icd_def_tky(g_rva.rva01,g_rvb[l_ac].rvb02,
                                       g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04)
                     CALL t110_ind_icd_set_rvb87_tky('b') 
                     #若為委外tky單據,要重新取價
                     CALL t110_ind_icd_def_rvb10()
                  #FUN-810038................end
&endif
                  #不能部份交貨且已有交貨量則不允許通過
                  IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
                     CALL cl_err('','mfg3339',0)
                     NEXT FIELD rvb04
                  END IF
                  #---modi in 99/12/22 若為L/C收貨則輸入之PO及項次必須存在提單檔
                  IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04)  THEN   #No.MOD-840575 
                   IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                     SELECT * FROM alt_file
                      WHERE alt01=g_rvb[l_ac].rvb22
                        AND alt14=g_rvb[l_ac].rvb04
                        AND alt15=g_rvb[l_ac].rvb03
                     IF SQLCA.sqlcode=100 THEN
#                       CALL cl_err('','apm-304',0) #No.FUN-660129
                        CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
 #                    NEXT FIELD rvb04                                #No.MOD-840575 
                     LET g_rvb[l_ac].rvb04= g_rvb_t.rvb04            #No.MOD-840575 
                     NEXT FIELD rvb04                               #No.MOD-840575 
                     END IF
                   END IF
                 END IF  #No.MOD-840575 
                 #NO.FUN-960130---START----
                 IF g_azw.azw04='2' THEN
                    SELECT pmn14 INTO l_pmn14 FROM pmn_file 
                        WHERE pmn01 = g_rvb[l_ac].rvb04
                          AND pmn02 = g_rvb[l_ac].rvb03
                    IF l_pmn14 = 'Y' THEN
                       SELECT COUNT(*) INTO l_n 
                          FROM rvb_file,rva_file 
                         WHERE rvb04 = g_rvb[l_ac].rvb04
                           AND rvb03 = g_rvb[l_ac].rvb03 
                           AND rva01 = rvb01
                           AND rvaconf <> 'X'
                       SELECT sma134 INTO l_times FROM sma_file
                       IF l_times IS NULL THEN LET l_times = 0 END IF
                       #收貨次數是否已經超過參數設定的總次數
                       IF l_n >= l_times THEN
                          CALL cl_err('','apm-932',0)
                          NEXT FIELD rvb04
                       END IF
                    END IF
                    CALL t110_get_price()
                 END IF
                 #NO.FUN-960130----END-----
               END IF
                #-----No.MOD-570144 END-----
               ###### 01/11/18 Tommy 避免三角收貨到一般採購或逆拋三角
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
                     NEXT FIELD rvb04  #No.9525
                  END IF
                  #-----modi 02/01/31 no.4061 必須同一流程代碼 ----
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
                     NEXT FIELD rvb04
                  END IF
                  IF l_pmm50  <> g_pmm50 AND l_num > 0 THEN #no.6113
                     CALL cl_err('','apm-993',0)
                     NEXT FIELD rvb04
                  END IF
                END IF
            END IF   
            CALL t110_set_no_entry_b('s')	#MOD-980043
 
         BEFORE FIELD rvb03     #採購項次
            CALL t110_set_entry_b(p_cmd)
 
         AFTER FIELD rvb03     #採購項次
            IF NOT cl_null(g_rvb[l_ac].rvb03) THEN
&ifdef ICD
             #FUN-940138--begin--mark-- 
             ##FUN-920073--BEGIN--
             #IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
             #  LET l_n2 = 0
             #  SELECT count(*) INTO l_n2 FROM pmn_file
             #   WHERE pmn68 = g_rvb[l_ac].rvb04
             #     AND pmn69 = g_rvb[l_ac].rvb03
             #   IF l_n2 > 0 THEN
             #      CALL cl_err('','aic-318',0)
             #      NEXT FIELD rvb03
             #   END IF
             #END IF
             ##FUN-920073--END--
             #FUN-940138--end--mark--
               #FUN-810038................begin
                  IF p_cmd = 'u' THEN
                     IF g_rvb_t.rvb03 <> g_rvb[l_ac].rvb03 THEN
                        IF NOT t110_ind_icd_chk_icd() THEN
                           LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03
                           DISPLAY BY NAME g_rvb[l_ac].rvb03
                           NEXT FIELD rvb03
                        END IF
                     END IF
                  END IF
               #FUN-810038................end
&endif
 
               #FUN-810038................begin
               #本段改為下面那段==>因為當有單頭無單身,此時按單身,則p_cmd='',則下面判斷式一定不會成立
                #No.MOD-4B0275
               #IF p_cmd = 'a' OR (p_cmd ='u' AND
               #                  (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
               #                   g_rvb[l_ac].rvb03 != g_rvb_t.rvb03)) THEN
               IF (g_rvb_t.rvb03 IS NULL) OR (g_rvb_t.rvb04 IS NULL) OR
                  (g_rvb[l_ac].rvb04 != g_rvb_t.rvb04 OR
                   g_rvb[l_ac].rvb03 != g_rvb_t.rvb03) THEN
               #FUN-810038................end
                  #NO.FUN-960130---BEGIN--------
                  IF g_azw.azw04='2' THEN
                     SELECT pmn14 INTO l_pmn14 FROM pmn_file 
                         WHERE pmn01 = g_rvb[l_ac].rvb04
                           AND pmn02 = g_rvb[l_ac].rvb03
                     IF l_pmn14 = 'Y' THEN
                        SELECT COUNT(*) INTO l_n 
                           FROM rvb_file,rva_file 
                          WHERE rvb04 = g_rvb[l_ac].rvb04
                            AND rvb03 = g_rvb[l_ac].rvb03 
                            AND rva01 = rvb01
                            AND rvaconf <> 'X'
                        SELECT sma134 INTO l_times FROM sma_file
                        #收貨次數是否已經超過參數設定中的次數
                        IF l_n >= l_times THEN
                           CALL cl_err('','apm-932',0)
                           NEXT FIELD rvb03
                        END IF
                     END IF
                  END IF
                  #NO.FUN-960130---end--------
                  IF NOT cl_null(g_rvb[l_ac].rvb03) THEN              #No.FUN-810016                 
                    CALL t110_rvb03('a',g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb03)
                    #-----MOD-890170---------
                    IF g_rvb[l_ac].rvb07 <=0 THEN
                       #-----MOD-8B0037---------
                       #CALL cl_err('','mfg3348',0)
                       #LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03
                       #NEXT FIELD rvb04
                       IF NOT cl_confirm('mfg3353') THEN
                          LET g_rvb[l_ac].rvb03 = g_rvb_t.rvb03
                          NEXT FIELD rvb04
                       END IF
                       #-----END MOD-8B0037-----
                    END IF
                    #-----END MOD-890170-----
                  END IF                                              #No.FUN-810116
                  CALL t110_set_rvb87()     #No.TQC-6C0131 add
                  #MOD-830171-begin-add
                  LET l_pmn20 = 0
                  SELECT pmn20,pmn87 INTO l_pmn20,l_pmn87 FROM pmn_file
                   WHERE pmn01=g_rvb[l_ac].rvb04
                     AND pmn02=g_rvb[l_ac].rvb03
                  #-----MOD-850298---------
                  #IF l_pmn20 = g_rvb[l_ac].rvb07  THEN
                  #   LET g_rvb[l_ac].rvb87 = l_pmn87
                  #END IF
                  LET l_rvb07_s = 0  
                  LET l_rvb87_s = 0
                  SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file
                    WHERE rvb04=g_rvb[l_ac].rvb04
                      AND rvb03=g_rvb[l_ac].rvb03
                      AND (rvb01<>g_rva.rva01 OR
                          (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
                  IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
                  IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
                  IF (l_rvb07_s+g_rvb[l_ac].rvb07) = l_pmn20 THEN
                     LET g_rvb[l_ac].rvb87 = l_pmn87 - l_rvb87_s
                  END IF
                  #-----END MOD-850298-----
                  #MOD-830171-end-add
                  #-------No.CHI-820010 add
                   IF g_sma.sma116 MATCHES '[02]' THEN
                      LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
                   END IF
                  #-------No.CHI-820010 end
&ifdef ICD
                  #FUN-810038................begin
                  #IF s_industry('icd') AND (g_argv2='SUB') THEN
                  IF g_argv2='SUB' THEN    #No.FUN-7C0017
                     IF cl_null(g_errno) THEN
                        CALL t110_b_move_back()
                        CALL t110_ind_icd_def_tky(g_rva.rva01,g_rvb[l_ac].rvb02,
                                                  g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04)
                        CALL t110_ind_icd_set_rvb87_tky('b')
                     END IF
                  END IF
                  #FUN-810038................end
&endif
                  CALL t110_set_no_entry_b(p_cmd)   #No.FUN-610018
                END IF  #No.MOD-4B0275 end
#no.TQC-7C0108 --begin
                #TQC-7C0131.....begin
                CALL t110_set_no_entry_b('s')
               #IF NOT cl_null(g_rvb[l_ac].rvb04) THEN
               #   CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",FALSE)
               #END IF
                #TQC-7C0131.....end
#no.TQC-7C0108 --end
               IF cl_null(g_pmm42) THEN LET g_pmm42=0 END IF
 
               LET g_rvb2.rvb10 = g_pmn31
               LET g_rvb2.rvb10t= g_pmn31t     #No.FUN-550117
               #No.FUN-810016---Begin
                  IF p_cmd='a' OR (p_cmd='u' AND g_rvb[l_ac].rvb05!= g_rvb_t.rvb05) THEN    
                    LET g_rvb[l_ac].rvb05=g_rvb[l_ac].rvb05a       
                    LET g_rvb[l_ac].rvb051=g_rvb[l_ac].rvb05b   #FUN-940083 pmn041-->rvb051
                    LET g_rvb[l_ac].ima021=g_rvb[l_ac].rvb05c      
                  END IF
               #No.FUN-810016---End
               #No.MOD-490173
              #IF cl_chk_act_auth() THEN
                  LET g_rvb[l_ac].rvb10 = g_pmn31
                  LET g_rvb[l_ac].rvb10t= g_pmn31t     #No.FUN-550117
                  #NO.FUN-960130---START----                                                                          
                  IF g_azw.azw04='2'  THEN                                                                           
                     CALL t110_get_price()
                  END IF
                  #NO.FUN-960130----END-----
                   DISPLAY g_rvb[l_ac].rvb10  TO rvb10  #MOD-570294 重show一次避免沒跑ON ROW CHANGE
                   DISPLAY g_rvb[l_ac].rvb10t TO rvb10t #MOD-570294 重show一次避免沒跑ON ROW CHANGE
              #END IF
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
               
&ifdef ICD
               #FUN-810038................begin
               #IF s_industry('icd') AND (g_argv2='SUB') THEN
               IF g_argv2='SUB' THEN
                  #若為委外tky單據,要重新取價
                  CALL t110_ind_icd_def_rvb10()
               END IF
               #FUN-810038................end
&endif
 
               #不能部份交貨且已有交貨量則不允許通過
               IF g_pmn50_55 > 0 AND g_pmn14 = 'N' THEN
                  CALL cl_err('','mfg3339',0)
                  NEXT FIELD rvb03
               END IF
               #---modi in 99/12/22 若為L/C收貨則輸入之PO及項次必須存在提單檔
               IF NOT cl_null(g_rvb[l_ac].rvb03) AND NOT cl_null(g_rvb[l_ac].rvb04) THEN    #No.MOD-840575 
                 IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                   SELECT * FROM alt_file
                     WHERE alt01=g_rvb[l_ac].rvb22
                       AND alt14=g_rvb[l_ac].rvb04
                       AND alt15=g_rvb[l_ac].rvb03
                  IF SQLCA.sqlcode=100 THEN
#                    CALL cl_err('','apm-304',0)  #No.FUN-660129
                     CALL cl_err3("sel","alt_file",g_rvb[l_ac].rvb22,"","apm-304","","",1) #No.FUN-660129
#                    NEXT FIELD rvb04                                #No.MOD-840575 
                     LET g_rvb[l_ac].rvb03= g_rvb_t.rvb03            #No.MOD-840575 
                     NEXT FIELD rvb03                                #No.MOD-840575 
                  END IF
                 END IF
              END IF                                             #No.FUN-840575 
            END IF
            LET l_direct = 'U'
 
        #BEFORE FIELD rvb36            #若 MISC 則不須輸入倉儲批
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
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_rvb[l_ac].rvb36
               DISPLAY BY NAME g_rvb[l_ac].rvb37
               DISPLAY BY NAME g_rvb[l_ac].rvb38
               #------MOD-5A0095 END------------
               CALL cl_err('','mfg-021',0)
            END IF
            #No.FUN-540027  --begin
            LET g_ima906 = NULL
            SELECT ima906 INTO g_ima906 FROM ima_file
             WHERE ima01=g_rvb[l_ac].rvb05
            #No.FUN-540027  --end
            CALL t110_set_no_entry_b(p_cmd)
 
&ifdef ICD
         #FUN-810038................begin
         AFTER FIELD rvbiicd03  #作業編號
            IF s_industry('icd') AND g_argv2='SUB' THEN
               IF NOT cl_null(g_rvb[l_ac].rvbiicd03) THEN
                  IF NOT cl_null(g_rvbi2.rvbiicd17) THEN
                     LET l_ecm03 = '' 
                     SELECT ecm03 INTO l_ecm03 FROM ecm_file
                       WHERE ecm01 = g_rvb[l_ac].rvb34   #工單單號
                         AND ecm04 = g_rvb[l_ac].rvbiicd03
                     IF cl_null(l_ecm03) THEN                
                        CALL cl_err('ecm03',SQLCA.SQLCODE,0)
                        NEXT FIELD rvbiicd03
                     ELSE
                        SELECT MAX(ecm03) INTO l_ecm03_max 
                          FROM ecm_file
                         WHERE ecm01 = g_rvb[l_ac].rvb34
                        #判斷是否為委外tky非最終站(Y:是 N:不是)
                        IF l_ecm03 = l_ecm03_max THEN
                           LET g_rvbi2.rvbiicd13 = 'N'
                        ELSE
                           LET g_rvbi2.rvbiicd13 = 'Y'
                           LET g_rvb[l_ac].rvb36 = 'MISC'
                           LET g_rvb[l_ac].rvb37 = 'MISC'
                  
                           LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
                           LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
                           DISPLAY BY NAME g_rvb[l_ac].rvb36
                           DISPLAY BY NAME g_rvb[l_ac].rvb37
                        END IF  
                  
                        #若是TURNKEY要重算單價
                        CALL t110_ind_icd_def_rvb10()
                  
                        CALL t110_b_move_back()
                        #委外tky單據數量獨立計算
                        CALL t110_ind_icd_def_qty_tky(g_rvb2.*,'b')
                             RETURNING g_rvb2.rvb07,g_rvb2.rvb82,
                                       g_rvb2.rvb85,g_rvb2.rvb87
                        DISPLAY BY NAME g_rvb[l_ac].rvb07
                        DISPLAY BY NAME g_rvb[l_ac].rvb82
                        DISPLAY BY NAME g_rvb[l_ac].rvb85
                        DISPLAY BY NAME g_rvb[l_ac].rvb87
                     END IF
                  END IF
               END IF
               IF NOT cl_null(g_rvbi2.rvbiicd17) AND
                  cl_null(g_rvb[l_ac].rvbiicd03) THEN
                  NEXT FIELD rvbiicd03
               END IF
               LET g_rvbi2.rvbiicd03 = g_rvb[l_ac].rvbiicd03
            END IF
            
        #3.不良品數 rvbiicd06 : 
        #  若作業群組 = '2.CP', 則不允許維護不良品數,
        #  作業群組 = '[3-6]'則允許維護不良品數  not null, >= 0 
        #  (一律default0)(作業群組：rvbiicd03 去串ecd_file的ecdicd01)  
         AFTER FIELD rvbiicd06
            IF NOT cl_null(g_rvb[l_ac].rvbiicd06) THEN
               IF g_rvb[l_ac].rvbiicd06 < 0 THEN
                  #本欄位之值,不可空白或小於零,請重新輸入!
                  CALL cl_err('','asf-745',1)
                  NEXT FIELD rvbiicd06
               END IF
               LET g_rvbi2.rvbiicd06 = g_rvb[l_ac].rvbiicd06
               IF g_rvb[l_ac].rvbiicd06 <> g_rvb_t.rvbiicd06 THEN
                  CALL t110_ind_icd_set_rvb87_tky('b')
               END IF
            END IF
 
        #4.報廢數量 rvbiicd07:  
        #  若作業群組 = '2.CP', 則不允許維護不良品數, 
        #  作業群組 = '[3-6]'則允許維護不良品數  not null, >= 0 
        #  (一律default0)(作業群組：rvbiicd03 去串ecd_file的ecdicd01)
         AFTER FIELD rvbiicd07
            IF NOT cl_null(g_rvb[l_ac].rvbiicd07) THEN
               IF g_rvb[l_ac].rvbiicd07 < 0 THEN
                  #本欄位之值,不可空白或小於零,請重新輸入!
                  CALL cl_err('','asf-745',1)
                  NEXT FIELD rvbiicd07
               END IF
            END IF
 
         #FUN-810038................end
&endif
 
         AFTER FIELD rvb35     #樣品否
            IF NOT cl_null(g_rvb[l_ac].rvb35) THEN
               IF g_rvb[l_ac].rvb35 NOT MATCHES '[YN]'THEN
                  NEXT FIELD rvb35
               END IF
            END IF
 
         # ---- check 最小套數(以防未發料卻可入庫) ----#
         BEFORE FIELD rvb07    #收貨量
            SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93 FROM sfb_file       #No.FUN-610101 add sfb93
             WHERE sfb01 = g_rvb[l_ac].rvb34
            IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
               IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN   # 委外
                  LET g_min_set = 0
                  CALL s_get_ima153(g_rvb[l_ac].rvb05) RETURNING l_ima153  #FUN-910053 
                 #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,g_sma.sma74,'')#FUN-910053
                  CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'')  #FUN-910053
                        RETURNING g_cnt,g_min_set
                  SELECT ima55 INTO l_ima55
                    FROM ima_file
                   WHERE ima01 = g_rvb[l_ac].rvb05
                  CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 
                       RETURNING g_i,l_fac
                  IF g_i = 1 THEN
                     #採購單位無法與料件的生產單位做換算,預設轉換率為1
                     CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1)
                     LET l_fac = 1
                  END IF
                  LET g_min_set = g_min_set / l_fac
 
                  IF g_cnt !=0  THEN
                     CALL cl_err('s_minp()','asf-549',0)
                     NEXT FIELD rvb34
                  END IF
                  # 確認之(收貨-退貨)
                  SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
                   WHERE rvb34 = g_rvb[l_ac].rvb34
                     AND rvb01 = rva01 AND rvaconf<>'X'    #MOD-790062 modify 排除作廢單據
                     AND rvb05 = g_rvb[l_ac].rvb05 AND rvb35='N'
                     AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)  #MOD-790062 排除本張單正在輸入的項次
                     AND rvb04 = g_rvb[l_ac].rvb04   #MOD-850311
                     AND rvb03 = g_rvb[l_ac].rvb03   #MOD-850311
 
                  IF conf_qty IS NULL THEN LET conf_qty=0 END IF
                  LET g_min_set=g_min_set-conf_qty
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
            IF NOT cl_null(g_rvb[l_ac].rvb07) THEN
               IF g_rvb[l_ac].rvb07 <=0 THEN
                  CALL cl_err('','mfg3348',0)   #MOD-890170
                  NEXT FIELD rvb07
               END IF
&ifdef ICD
               #FUN-810038................begin
                  #修改數量,若料號有展明細(ta_ima080) ='Y',
                  #則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
                 #No.MOD-890023 mark --begin
                 #在確認的時候有判斷，現在不需要
                 #IF g_rvb[l_ac].rvb07 <> g_rvb_t.rvb07 THEN
                 #   #CHI-830025..................begin
                 #   #IF NOT t110_ind_icd_chk_icdqty() THEN
                 #   #   NEXT FIELD CURRENT
                 #   #END IF
                 #   LET li_result=t110_ind_icd_chk_icdqty()
                 #   #CHI-830025..................end
                 #END IF
                 #No.MOD-890023 mark --begin
               #FUN-810038................end
&endif
               #-----MOD-940056---------
               #LET g_rvb2.rvb08=g_rvb[l_ac].rvb07
               #IF p_cmd = 'a' THEN  #FUN-550195 add if 判斷 避免在修改狀態時,若原本的rvb08已輸入其它數量了,則又被復原跟rvb07一樣
               #    LET g_rvb2.rvb08=g_rvb[l_ac].rvb07
               #END IF
               IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN
                  LET g_rvb2.rvb08=g_rvb[l_ac].rvb07
               END IF
               #-----END MOD-940056-----
 
               IF cl_null(g_pmn13) THEN   #超交率
                  LET g_pmn13 = 0
               END IF
               IF cl_null(g_pmn50_55) THEN
                  LET g_pmn50_55 = 0
               END IF
               LET g_pmn20 = g_rvb[l_ac].pmn20
 
&ifdef ICD
               #FUN-810038................begin
                  SELECT SUM(rvb07) INTO l_rvb07_3 
                    FROM rvb_file,rva_file,rvbi_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvbi01=rvb01
                     AND rvbi02=rvb02
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
                     #排除委外tky非最終站的收貨數量
                     AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
&else
               #FUN-810038................end
                  SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
&endif
               IF cl_null(l_rvb07_3) THEN
                  LET l_rvb07_3 = 0
               END IF
 
&ifdef ICD
               #FUN-950040.............begin
               #本采購單累積被衝銷量
               SELECT pmniicd13 INTO l_pmniicd13 FROM pmni_file
                WHERE pmni01 = g_rvb[l_ac].rvb04
                  AND pmni02 = g_rvb[l_ac].rvb03
               
               IF cl_null(l_pmniicd13) THEN
                  LET l_pmniicd13 = 0
               END IF
               #FUN-950040.............end
&endif
               #計算已交量
               LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb[l_ac].rvb07
&ifdef ICD
               #FUN-950040.............begin
               LET l_rvb07= l_rvb07 + l_pmniicd13
               #FUN-950040.............end
&endif
               LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
               #LET l_rvb07_2=l_rvb07-l_rvb07_1               #MOD-530021 MARK
                LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100     #MOD-530021 #最少可交貨量
 
&ifdef ICD
               #FUN-810038................begin
                  #委外tky非最終站之收貨數量單獨計算
                  IF g_rvbi2.rvbiicd13 = 'Y' THEN
                     SELECT SUM(rvb07) INTO l_rvb07_3_tky 
                       FROM rvb_file,rva_file,rvbi_file
                      WHERE rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvbi01=rvb01
                        AND rvbi02=rvb02
                        AND rvaconf!='X'   #未作廢
                        AND rva01=rvb01
                        AND rvb35='N'
                        AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
                        #只計算委外tky非最終站的收貨數量
                        AND rvbiicd13='Y'
                        AND rvbiicd03= g_rvb[l_ac].rvbiicd03
                     IF cl_null(l_rvb07_3_tky) THEN
                        LET l_rvb07_3_tky = 0
                     END IF
                     LET l_rvb07 = l_rvb07_3_tky+g_rvb[l_ac].rvb07
                  END IF
               #FUN-810038................end
&endif
 
               #modi in 99/12/22 若為LC收貨，則須檢查數貨不可大於提單數量
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
 
               IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
                  IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
                     #IF l_rvb07_1 > l_rvb07 THEN #短交 #MOD-530021
                      IF l_rvb07_2 > l_rvb07 THEN #短交 #MOD-530021
                        IF g_sma.sma85 MATCHES '[Rr]' THEN
                           CALL cl_err(l_rvb07_2,'mfg3038',0)
                           NEXT FIELD rvb07
                        ELSE
                           CALL cl_err(l_rvb07_2,'mfg9120',1)
                        END IF
                     END IF
                     ###### 01/10/23 Tommy 樣品不檢查
                     IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019委外不檢查超交
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]'  THEN
                               CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                              NEXT FIELD rvb07
                           ELSE
                               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
                           END IF
                        END IF
                     END IF
                     ###### End Tommy
                  END IF
                  IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
                     ###### 01/10/23 Tommy 樣品不檢查
                     IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN #CHI-6B0019委外不檢查超交
                        IF l_rvb07_1 < l_rvb07 THEN #超交
                           IF g_sma.sma85 MATCHES '[Rr]' THEN
                               CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                              NEXT FIELD rvb07
                           ELSE
                               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
                           END IF
                        END IF
                     END IF
                     ###### End Tommy
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
 
               #NO:4669-->確認之(收貨-退貨)
               IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
                 IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN
                  #-----------No.TQC-670091 modify
                   #AND l_sfb93 != 'Y' THEN  #No.FUN-610101 add判斷走製程時不控管最小發料套數
                    IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
#No.MOD-880083 --begin
#                       CALL t110_minp(g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04,
#                                      g_rvb[l_ac].rvb34,g_rvb[l_ac].rvb05) RETURNING l_min_set #FUN-910053 rvb05
#
#                      #--------------No.TQC-730059 add
#                       CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].pmn07,l_ima55)
#                            RETURNING g_i,l_fac
#                       IF g_i = 1 THEN
#                          #採購單位無法與料件的生產單位做換算,預設轉換率為1
#                          CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1)
#                          LET l_fac = 1
#                       END IF
#                       LET l_min_set = l_min_set / l_fac
#                      #--------------No.TQC-730059 end
#
#                       IF g_rvb[l_ac].rvb07 > l_min_set THEN
                       IF g_rvb[l_ac].rvb07 > g_min_set THEN
#No.MOD-880083 --end
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                          NEXT FIELD rvb07
                       END IF
                    ELSE
                       #-----MOD-860054---------
                       IF g_rvb[l_ac].rvb07 > g_rvb[l_ac].pmn20 - conf_qty THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-070',1)
                          NEXT FIELD rvb07
                       END IF
                       #IF g_rvb[l_ac].rvb07>g_min_set THEN
                       #   #委外實收數不可大於發料最小套數!
                       #   CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                       #   NEXT FIELD rvb07
                       #END IF
                       #-----END MOD-860054-----
                    END IF
                  #-----------No.TQC-670091 modify
                 END IF
               END IF
            END IF
       
        #No.MOD-880255--begin-- mark將以下mark段內容搬至ON CHANGE rvb07段內.
        ##No.FUN-540027  --begin
        #   IF cl_null(g_rvb_t.rvb07) AND g_rvb[l_ac].rvb07 IS NOT NULL OR
        #      NOT cl_null(g_rvb_t.rvb07) AND cl_null(g_rvb[l_ac].rvb07) OR
        #      g_rvb_t.rvb07 <> g_rvb[l_ac].rvb07 THEN
        #      CALL t110_set_rvb87()
        #      #-------No.CHI-820010 add
        #       IF g_sma.sma116 MATCHES '[02]' THEN
        #          LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
        #       END IF
        #      #-------No.CHI-820010 end
        #      #MOD-830171-begin-add
        #      LET l_pmn20 = 0
        #      SELECT pmn20,pmn87 INTO l_pmn20,l_pmn87 FROM pmn_file
        #       WHERE pmn01=g_rvb[l_ac].rvb04
        #         AND pmn02=g_rvb[l_ac].rvb03
        #      #-----MOD-850298---------
        #      #IF l_pmn20 = g_rvb[l_ac].rvb07  THEN
        #      #   LET g_rvb[l_ac].rvb87 = l_pmn87
        #      #END IF
        #      LET l_rvb07_s = 0  
        #      LET l_rvb87_s = 0
        #      SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file
        #        WHERE rvb04=g_rvb[l_ac].rvb04
        #          AND rvb03=g_rvb[l_ac].rvb03
        #          AND (rvb01<>g_rva.rva01 OR
        #              (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
        #      IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
        #      IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
        #      IF (l_rvb07_s+g_rvb[l_ac].rvb07) = l_pmn20 THEN
        #         LET g_rvb[l_ac].rvb87 = l_pmn87 - l_rvb87_s
        #      END IF
        #      #-----END MOD-850298-----
        #      #MOD-830171-end-add
&ifdef ICD
        #      CALL t110_ind_icd_set_rvb87_tky('b')  #FUN-810038
&endif
        #   END IF
        #No.MOD-880255---end--- mark
            #-----No.FUN-810036-----
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
                  SELECT img09 INTO g_img09
                    FROM img_file   #庫存單位
                   WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                     AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                  CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)  #No.FUN-940083 pmn07-->rvb90 
                       RETURNING l_i,l_fac
                  IF l_i = 1 THEN LET l_fac = 1 END IF
                  CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                               g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,   #No.FUN-940083 pmn07-->rvb90 
                               l_fac,g_rvb[l_ac].rvb07,'MOD')
                     RETURNING l_r,g_qty 
                  #-----No.FUN-860045-----
                  IF l_r = "Y" THEN
                     LET g_rvb[l_ac].rvb07 = g_qty
                  END IF
                  #-----No.FUN-860045 END-----
               END IF     #FUN-850120
            END IF
            #-----No.FUN-810036 END-----
 
            IF cl_null(g_rvb[l_ac].rvb86) THEN
               LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90                        #No.FUN-940083 pmn07-->rvb90 
               LET g_rvb[l_ac].rvb87=g_rvb[l_ac].rvb07
            END IF
 
         #No.MOD-880255--begin--
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
               SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file
                 WHERE rvb04=g_rvb[l_ac].rvb04
                   AND rvb03=g_rvb[l_ac].rvb03
                   AND (rvb01<>g_rva.rva01 OR
                       (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
               IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
               IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
               IF (l_rvb07_s+g_rvb[l_ac].rvb07) = l_pmn20 THEN
                  LET g_rvb[l_ac].rvb87 = l_pmn87 - l_rvb87_s
               END IF
&ifdef ICD
               CALL t110_ind_icd_set_rvb87_tky('b')  
&endif
         #No.MOD-880255---end---
 
 
         BEFORE FIELD rvb85
            IF cl_null(g_rvb[l_ac].rvb83) THEN
               LET g_rvb[l_ac].rvb85= NULL
            END IF
 
         AFTER FIELD rvb85     #第二數量
            IF NOT cl_null(g_rvb[l_ac].rvb85) THEN
               IF g_rvb[l_ac].rvb85 <0 THEN
                  NEXT FIELD rvb85
               END IF
               IF cl_null(g_rvb[l_ac].rvb83) THEN
                  LET g_rvb[l_ac].rvb85= NULL
               END IF
            END IF
           #IF p_cmd = 'a' OR  p_cmd = 'u' AND #mark by MOD-660155
           #   g_rvb_t.rvb85 <> g_rvb[l_ac].rvb85 THEN #mark by MOD-660155
               IF g_ima906='3' THEN
                  LET g_tot=g_rvb[l_ac].rvb85*g_rvb[l_ac].rvb84
                  IF cl_null(g_rvb[l_ac].rvb82) OR g_rvb[l_ac].rvb82=0 THEN  #CHI-960022
                     LET g_rvb[l_ac].rvb82=g_tot*g_rvb[l_ac].rvb81
                     DISPLAY BY NAME g_rvb[l_ac].rvb82                       #CHI-960022
                  END IF                                                     #CHI-960022
               END IF
           #END IF #mark by MOD-660155
            IF cl_null(g_rvb_t.rvb85) AND g_rvb[l_ac].rvb85 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb85) AND cl_null(g_rvb[l_ac].rvb85) THEN
              #OR g_rvb_t.rvb85 <> g_rvb[l_ac].rvb85 THEN #MOD-660155
               CALL t110_set_rvb87()
&ifdef ICD
               CALL t110_ind_icd_set_rvb87_tky('b')  #FUN-810038
&endif
            END IF
           #FUN-850120 begin
            #copy from AFTER FIELD rvb07
            #-----No.FUN-810036-----
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
                  SELECT img09 INTO g_img09
                    FROM img_file   #庫存單位
                   WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                     AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                  CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)   #No.FUN-940083 pmn07-->rvb90 
                       RETURNING l_i,l_fac
                  IF l_i = 1 THEN LET l_fac = 1 END IF
                  CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                               g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,    #No.FUN-940083 pmn07-->rvb90 
                               l_fac,g_rvb[l_ac].rvb07,'MOD')
                     RETURNING l_r,g_qty 
                  #-----No.FUN-860045-----
                  IF l_r = "Y" THEN
                     LET g_rvb[l_ac].rvb07 = g_qty
                  END IF
                  #-----No.FUN-860045 END-----
               END IF     #FUN-850120
            END IF
            #-----No.FUN-810036 END-----
           #FUN-850120 end
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        #MOD-660155...............begin
        #BEFORE FIELD rvb82
        #   IF cl_null(g_rvb[l_ac].rvb80) THEN
        #      LET g_rvb[l_ac].rvb82= NULL
        #   END IF
        #MOD-660155...............end
 
         AFTER FIELD rvb82     #第一數量
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
            #BEFORE FIELD rvb07    #收貨量
            SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93 FROM sfb_file    #NO.TQC-670091 add sfb93
             WHERE sfb01 = g_rvb[l_ac].rvb34
            IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
               IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN   # 委外
                  LET g_min_set = 0
                  CALL s_get_ima153(g_rvb[l_ac].rvb05) RETURNING l_ima153  #FUN-910053 
                 #CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,g_sma.sma74,'')#FUN-910053
                  CALL s_minp(g_rvb[l_ac].rvb34,g_sma.sma73,l_ima153,'')  #FUN-910053
                        RETURNING g_cnt,g_min_set
                  SELECT ima55 INTO l_ima55
                    FROM ima_file
                   WHERE ima01 = g_rvb[l_ac].rvb05
                  CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 
                       RETURNING g_i,l_fac
                  IF g_i = 1 THEN
                     #採購單位無法與料件的生產單位做換算,預設轉換率為1
                     CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1)
                     LET l_fac = 1
                  END IF
                  LET g_min_set = g_min_set / l_fac
 
                  IF g_cnt !=0  THEN
                     CALL cl_err('s_minp()','asf-549',0)
                     NEXT FIELD rvb34
                  END IF                  
&ifdef ICD
                  # 確認之(收貨-退貨)
                  #FUN-810038................begin
                     SELECT SUM(rvb07-rvb29) INTO conf_qty 
                       FROM rvb_file,rva_file,rvbi_file
                      WHERE rvb34 = g_rvb[l_ac].rvb34
                        AND rvbi01=rvb01
                        AND rvbi02=rvb02
                        AND rvb01 = rva01 AND rvaconf<>'X'
                        AND rvb05 = g_rvb[l_ac].rvb05 AND rvb35='N'
                        AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)
                        #排除委外TYK非最終站的資料
                        AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL 
                             OR rvbiicd13 = ' ')                        
                        AND rvb04 = g_rvb[l_ac].rvb04   #MOD-850311
                        AND rvb03 = g_rvb[l_ac].rvb03   #MOD-850311
                  #FUN-810038................end
&else
                     SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
                      WHERE rvb34 = g_rvb[l_ac].rvb34
                        AND rvb01 = rva01 AND rvaconf<>'X'    #MOD-790062 modify 排除作廢單據
                        AND rvb05 = g_rvb[l_ac].rvb05 AND rvb35='N'
                        AND NOT (rvb02=g_rvb[l_ac].rvb02 AND rvb01=g_rva.rva01)  #MOD-790062 排除本張單正在輸入的項次
                        AND rvb04 = g_rvb[l_ac].rvb04   #MOD-850311
                        AND rvb03 = g_rvb[l_ac].rvb03   #MOD-850311
&endif
                  IF conf_qty IS NULL THEN LET conf_qty=0 END IF
                  LET g_min_set=g_min_set-conf_qty
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
               IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN   #MOD-940056
                  LET g_rvb2.rvb08=g_rvb[l_ac].rvb07
               END IF   #MOD-940056
               IF cl_null(g_pmn13) THEN   #超交率
                  LET g_pmn13 = 0
               END IF
               IF cl_null(g_pmn50_55) THEN
                  LET g_pmn50_55 = 0
               END IF
               LET g_pmn20 = g_rvb[l_ac].pmn20
 
&ifdef ICD
               #FUN-810038................begin
                  SELECT SUM(rvb07) INTO l_rvb07_3 
                    FROM rvb_file,rva_file,rvbi_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvb01=rvbi01
                     AND rvb02=rvbi02
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
                     AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
               #FUN-810038................end
&else
                  SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
                   WHERE rvb04=g_rvb[l_ac].rvb04
                     AND rvb03=g_rvb[l_ac].rvb03
                     AND rvaconf='N'
                     AND rva01=rvb01
                     AND rvb35='N'
                     AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
&endif
               IF cl_null(l_rvb07_3) THEN
                  LET l_rvb07_3 = 0
               END IF
 
               #計算已交量
               LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb[l_ac].rvb07
               LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
               #LET l_rvb07_2=l_rvb07-l_rvb07_1   #MOD-890147
               LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100   #MOD-890147
               
&ifdef ICD
               #FUN-810038................begin
                  IF g_rvbi2.rvbiicd13 = 'Y' THEN
                     #委外tky非最終站的收貨數量獨立計算
                     SELECT SUM(rvb07) INTO l_rvb07_3_tky
                       FROM rvb_file,rva_file,rvbi_file
                      WHERE rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvbi01=rvb01
                        AND rvbi02=rvb02
                        AND rvaconf!='X'   #未作廢
                        AND rva01=rvb01
                        AND rvb35='N'
                        AND NOT (rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02)
                        AND rvbiicd13='Y'
                        AND rvbiicd03= g_rvb[l_ac].rvbiicd03
                     IF cl_null(l_rvb07_3_tky) THEN
                        LET l_rvb07_3_tky = 0
                     END IF
                     LET l_rvb07=l_rvb07_3_tky+g_rvb[l_ac].rvb07
                  END IF
               #FUN-810038................end
&endif
 
               #modi in 99/12/22 若為LC收貨，則須檢查數貨不可大於提單數量
               IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
                  SELECT alt06 INTO l_alt06 FROM alt_file
                   WHERE alt01=g_rvb[l_ac].rvb22
                     AND alt14=g_rvb[l_ac].rvb04
                     AND alt15=g_rvb[l_ac].rvb03
                  IF cl_null(l_alt06) THEN
                     LET l_alt06 = 0
                  END IF
&ifdef ICD
                  #FUN-810038................begin
                     SELECT SUM(rvb07) INTO t_alt06 
                       FROM rvb_file,rvbi_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01=rvbi01
                        AND rvb02=rvbi02
                        AND rvb01!=g_rva.rva01
                        AND rvb35='N'
                        AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
                  #FUN-810038................end
&else
                     SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01!=g_rva.rva01
                        AND rvb35='N'
&endif
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
 
               IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
                  IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
                     #IF l_rvb07_1 > l_rvb07 THEN #短交   #MOD-890147
                     IF l_rvb07_2 > l_rvb07 THEN #短交   #MOD-890147
                        IF g_sma.sma85 MATCHES '[Rr]' THEN
                           CALL cl_err(l_rvb07_2,'mfg3038',0)
                           #-----MOD-890147---------
                           #NEXT FIELD rvb07
                           IF g_ima906 MATCHES '[23]' THEN
                              NEXT FIELD rvb85
                           ELSE
                              NEXT FIELD rvb82
                           END IF
                           #-----END MOD-890147-----
                        ELSE
                           CALL cl_err(l_rvb07_2,'mfg9120',1)
                        END IF
                     END IF
                     ###### 01/10/23 Tommy 樣品不檢查
                     IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019委外不檢查超交
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
                     ###### End Tommy
                  END IF
                  IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
                     ###### 01/10/23 Tommy 樣品不檢查
                     IF g_rvb[l_ac].rvb35 = 'N' AND g_rva.rva10 != 'SUB' THEN  #CHI-6B0019 委外不檢查超交
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
                     ###### End Tommy
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
 
               #NO:4669-->確認之(收貨-退貨)
               IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
                 IF g_argv2 ='SUB' AND g_rvb[l_ac].rvb05=l_sfb05 THEN
                  #-----------No.TQC-670091 modify
                    IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
                       CALL t110_minp(g_rvb[l_ac].rvb03,g_rvb[l_ac].rvb04,
                                      g_rvb[l_ac].rvb34,g_rvb[l_ac].rvb05) RETURNING l_min_set #FUN-910053
 
                      #--------------No.TQC-730059 add
                       CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 
                            RETURNING g_i,l_fac
                       IF g_i = 1 THEN
                          #採購單位無法與料件的生產單位做換算,預設轉換率為1
                          CALL cl_err(g_rvb[l_ac].rvb05,'apm-120',1)
                          LET l_fac = 1
                       END IF
                       LET l_min_set = l_min_set / l_fac
                      #--------------No.TQC-730059 end
 
                       IF g_rvb[l_ac].rvb07 > l_min_set THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                          IF g_ima906 MATCHES '[23]' THEN
                             NEXT FIELD rvb85
                          ELSE
                             NEXT FIELD rvb82
                          END IF
                       END IF
                    ELSE
                       #-----MOD-860054---------
                       IF g_rvb[l_ac].rvb07 > g_rvb[l_ac].pmn20 - conf_qty THEN
                          CALL cl_err(g_rvb[l_ac].rvb07,'apm-070',1)
                          IF g_ima906 MATCHES '[23]' THEN
                             NEXT FIELD rvb85
                          ELSE
                             NEXT FIELD rvb82
                          END IF
                       END IF
                       #IF g_rvb[l_ac].rvb07>g_min_set THEN
                       #   #委外實收數不可大於發料最小套數!
                       #   CALL cl_err(g_rvb[l_ac].rvb07,'apm-307',1)
                       #   IF g_ima906 MATCHES '[23]' THEN
                       #      NEXT FIELD rvb85
                       #   ELSE
                       #      NEXT FIELD rvb82
                       #   END IF
                       #END IF
                       #-----END MOD-860054-----
                    END IF
                  #-----------No.TQC-670091 modify
                 END IF
               END IF
            END IF
            IF cl_null(g_rvb_t.rvb82) AND g_rvb[l_ac].rvb82 IS NOT NULL OR
               NOT cl_null(g_rvb_t.rvb82) AND cl_null(g_rvb[l_ac].rvb82) OR
               g_rvb_t.rvb82 <> g_rvb[l_ac].rvb82 THEN
               CALL t110_du_data_to_correct()
               CALL t110_set_rvb87()
&ifdef ICD
               #FUN-810038................begin
                  CALL t110_ind_icd_set_rvb87_tky('b')  #FUN-810038
                  IF p_cmd = 'u' AND NOT cl_null(g_rvb_t.rvb82) AND
                     g_rvb_t.rvb82 <> g_rvb[l_ac].rvb82 THEN
                     #修改數量,若料號有展明細(imaicd08) ='Y',
                     #則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
                     #CHI-830025..................begin
                     #IF NOT t110_ind_icd_chk_icdqty() THEN
                     #   NEXT FIELD CURRENT
                     #END IF
                     LET li_result=t110_ind_icd_chk_icdqty()
                     #CHI-830025..................end
                  END IF
               #FUN-810038................end
&endif
 
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
&ifdef ICD
               #FUN-810038................begin
                  CALL t110_ind_icd_set_rvb87_tky('b')
               #FUN-810038................end
&endif
            END IF
 
        AFTER FIELD rvb87  #計價數量
           IF NOT cl_null(g_rvb[l_ac].rvb87) THEN
              IF g_rvb[l_ac].rvb87 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD rvb87
              END IF
           END IF
 
         #No.FUN-540027  --end
 
 
#        BEFORE FIELD rvb36            #若 MISC 則不須輸入倉儲批
#           # 當為製程委外時不寫 tlf,不 update ima,img 所以可不key 倉庫
#           LET l_ec_sw = 'N'
#           IF g_argv2 ='SUB' THEN
#              LET l_sfb24=''
#              SELECT sfb24 INTO l_sfb24
#                FROM sfb_file
#               WHERE sfb01 = g_rvb[l_ac].rvb34
#              IF l_sfb24 IS NOT NULL AND l_sfb24='Y' THEN
#                 LET l_ec_sw='Y'
#              END IF
#           END IF
#           IF l_ec_sw='Y' THEN
#              LET g_rvb[l_ac].rvb36=' '
#              LET g_rvb[l_ac].rvb37=' '
#              LET g_rvb[l_ac].rvb38=' '
#              CALL cl_err('','mfg-021',0)
#              #------MOD-5A0095 START----------
#              DISPLAY BY NAME g_rvb[l_ac].rvb36
#              DISPLAY BY NAME g_rvb[l_ac].rvb37
#              DISPLAY BY NAME g_rvb[l_ac].rvb38
#              #------MOD-5A0095 END------------
#           END IF
 
 
#MOD-7A0203-add
         BEFORE FIELD rvb36
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_no_entry_b(p_cmd)
#MOD-7A0203-add-end
 
         AFTER FIELD rvb36
&ifdef ICD
            #FUN-810038................begin
               IF p_cmd = 'u' AND NOT cl_null(g_rvb[l_ac].rvb36) THEN
                  IF g_rvb_t.rvb36 <> g_rvb[l_ac].rvb36 THEN
                     IF NOT t110_ind_icd_chk_icd() THEN
                        LET g_rvb[l_ac].rvb36 = g_rvb_t.rvb36
                        DISPLAY BY NAME g_rvb[l_ac].rvb36
                        NEXT FIELD rvb36
                     ELSE
                        CALL t110_ind_icd_trans_chk('u')
                     END IF
                  END IF
               END IF
            #FUN-810038................end
&endif
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-770082 add
            IF cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' AND g_rvb[l_ac].rvb05[1,4] <> 'MISC' THEN      #No.TQC-740313    #CHI-7A0003 remark   #MOD-7A0132 modify MISC
#           IF cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' AND g_sma.sma886[7,7] = 'Y'  THEN     #CHI-7A0003 mark
               NEXT FIELD rvb36
            END IF
            IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N'  THEN
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
               IF sn1=1 AND g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN
                  LET g_rvb_t.rvb36=g_rvb[l_ac].rvb36
                  CALL cl_err(g_rvb[l_ac].rvb36,'mfg6080',0)
                  NEXT FIELD rvb36
               ELSE
                  IF sn2=2 AND g_rvb[l_ac].rvb36 != g_rvb_t.rvb36 THEN
                     CALL cl_err(g_rvb[l_ac].rvb36,'mfg6085',0)
                     LET g_rvb_t.rvb36=g_rvb[l_ac].rvb36
                     NEXT FIELD rvb36
                  END IF
               END IF
               LET sn1=0 LET sn2=0
               #NO.FUN-960130----BEGIN-------
               #檢查該倉庫的歸屬機構是否為當前機構
               IF g_azw.azw04='2' THEN
                  SELECT imd01 FROM imd_file WHERE imd01 = g_rvb[l_ac].rvb36 
                     AND imd20 = g_rva.rvaplant
                  IF SQLCA.sqlcode = 100 THEN
                     CALL cl_err('','art-426',0)
                     NEXT FIELD rvb36
                  END IF
                  IF g_rva.rva29 = '1' THEN
                     SELECT * FROM jce_file WHERE jce02 = g_rvb[l_ac].rvb36
                     IF SQLCA.SQLCODE != 100 THEN
                        CALL cl_err('','apm-926',0)
                        NEXT FIELD rvb36
                     END IF
                  ELSE
                     SELECT * FROM jce_file WHERE jce02 = g_rvb[l_ac].rvb36
                     IF SQLCA.SQLCODE = 100 THEN                                                                                    
                       #CALL cl_err('','apm-927',0)  #TQC-9B0214 MARK BY COCKROACH                                                                               
                        NEXT FIELD rvb36                                                                                            
                     END IF
                  END IF
               END IF
               #NO.FUN-960130-----END---------
               #MOD-8B0283---Begin                                                                                                  
               IF NOT s_chksmz(g_rvb[l_ac].rvb05, g_rva.rva01,                                                                      
                               g_rvb[l_ac].rvb36, g_rvb[l_ac].rvb37) THEN                                                           
                  NEXT FIELD rvb36                                                                                                  
               END IF                                                                                                               
               #MOD-8B0283---End   
#FUN-9A0068--begin
               CALL t110_chk_rvb36()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb36,'apm-329',1)
                  NEXT FIELD rvb36  
               END IF
#FUN-9A0068--end
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
&ifdef ICD
            #FUN-810038................begin
               IF p_cmd = 'u' AND NOT cl_null(g_rvb[l_ac].rvb37) THEN
                  IF g_rvb_t.rvb37 <> g_rvb[l_ac].rvb37 THEN
                     IF NOT t110_ind_icd_chk_icd() THEN
                        LET g_rvb[l_ac].rvb37 = g_rvb_t.rvb37
                        DISPLAY BY NAME g_rvb[l_ac].rvb37
                        NEXT FIELD rvb37
                     ELSE
                        CALL t110_ind_icd_trans_chk('u')
                     END IF
                  END IF
               END IF
            #FUN-810038................end
&endif
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-910227
            #IF NOT cl_null(g_rvb[l_ac].rvb37) AND l_ec_sw='N' THEN
            IF NOT cl_null(g_rvb[l_ac].rvb36) AND l_ec_sw='N' THEN  #NO.MOD-590530
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
                  IF sn2 = 2 THEN
                     IF g_pmn38 = 'Y' THEN
                        CALL cl_err('','mfg9132',0)
                     END IF
                  ELSE
                     IF g_pmn38 = 'N' THEN
                        CALL cl_err('','mfg9131',0)
                     END IF
                  END IF
                  LET sn1=0 LET sn2=0
               END IF
               IF g_rvb[l_ac].rvb37 IS NULL THEN
                  LET g_rvb[l_ac].rvb37=' '
               END IF
#FUN-9A0068--begin
               CALL t110_chk_rvb36()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvb[l_ac].rvb37,'apm-329',1)
                  NEXT FIELD rvb37
               END IF
#FUN-9A0068--end
               NEXT FIELD rvb38    #NO.CHI-920041
            END IF
 
         BEFORE FIELD rvb38              #批號
           #FUN-810045 remark begin
            #IF NOT cl_null(g_rvb[l_ac].rvb38) THEN
            #   SELECT COUNT(*) INTO l_cnt FROM pmn_file
            #    WHERE pmn01=g_rvb[l_ac].rvb04
            #      AND pmn02=g_rvb[l_ac].rvb03
            #      AND pmn122=g_rvb[l_ac].rvb38
            #   IF l_cnt > 0 THEN NEXT FIELD NEXT END IF
            #END IF
           #FUN-810045 remark end
 
 
         AFTER FIELD rvb38              #批號
            #BugNo:5626 控管是否為全型空白
            IF g_rvb[l_ac].rvb38 = '　' THEN #全型空白
               LET g_rvb[l_ac].rvb38 = ' '
            END IF
            IF g_rvb[l_ac].rvb38 IS NULL THEN
               LET g_rvb[l_ac].rvb38=' '
            END IF
 
&ifdef ICD
            #FUN-810038................begin
               IF p_cmd = 'u' AND NOT cl_null(g_rvb[l_ac].rvb38) THEN
                  IF g_rvb_t.rvb38 <> g_rvb[l_ac].rvb38 THEN
                     IF NOT t110_ind_icd_chk_icd() THEN
                        LET g_rvb[l_ac].rvb38 = g_rvb_t.rvb38
                        DISPLAY BY NAME g_rvb[l_ac].rvb38
                        NEXT FIELD rvb38
                     ELSE
                        CALL t110_ind_icd_trans_chk('u')
                     END IF
                  END IF
               END IF
            #FUN-810038................end
&endif
            CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-910227
            IF NOT cl_null(g_rvb[l_ac].rvb36)  AND l_ec_sw='N' THEN
#              IF g_sma.sma886[7,7] ='Y' THEN      #No.TQC-740313     #CHI-7A0003 mark
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
                     SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
                       FROM img_file
                      WHERE img01 = g_rvb[l_ac].rvb05
                        AND img02 = g_rvb[l_ac].rvb36
                        AND img03 = g_rvb[l_ac].rvb37
                        AND img04 = g_rvb[l_ac].rvb38
                  END IF
                  #No.FUN-540027  --begin
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
                                 NEXT FIELD rvb36
                              END IF
                           END IF
                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                           g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
                                           g_rva.rva01,
                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
                           IF g_flag = 1 THEN
                              NEXT FIELD rvb36
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
                                 NEXT FIELD rvb36
                              END IF
                           END IF
                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                           g_rvb[l_ac].rvb80,g_rvb[l_ac].rvb81,
                                           g_rva.rva01,
                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
                           IF g_flag = 1 THEN
                              NEXT FIELD rvb36
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
                                 NEXT FIELD rvb36
                              END IF
                           END IF
                           CALL s_add_imgg(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                                           g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                                           g_rvb[l_ac].rvb83,g_rvb[l_ac].rvb84,
                                           g_rva.rva01,
                                           g_rvb[l_ac].rvb02,0) RETURNING g_flag
                           IF g_flag = 1 THEN
                              NEXT FIELD rvb36
                           END IF
                        END IF
                     END IF
                  END IF
               #No.FUN-540027  --end
#              END IF      #No.TQC-740313   #CHI-7A0003 mark
            END IF
 
         AFTER FIELD rvb25
            IF NOT cl_null(g_rvb[l_ac].rvb25) THEN
                #No.MOD-4B0275
               SELECT coc10 INTO l_coc10 FROM coc_file
                WHERE coc03 = g_rvb[l_ac].rvb25
               IF STATUS THEN
#                 CALL cl_err(g_rvb[l_ac].rvb25,'aco-062',0) #No.FUN-660129
                  CALL cl_err3("sel","coc_file",g_rvb[l_ac].rvb25,"","aco-062","","",1) #No.FUN-660129
                  NEXT FIELD rvb25
               END IF
               SELECT COUNT(*) INTO l_cnt FROM coc_file,coe_file,coa_file
                WHERE coc01 = coe01
                  AND coe03 = coa03
                  AND coa05 = l_coc10
                  AND coa01 = g_rvb[l_ac].rvb05
                  AND coc03 = g_rvb[l_ac].rvb25
                #No.MOD-4B0275 end
               IF l_cnt = 0 THEN
                  CALL cl_err(g_rvb[l_ac].rvb25,'aco-073',0)
                  NEXT FIELD rvb25
               END IF
            END IF
 
         #No.FUN-550117
         AFTER FIELD rvb10   #採購單價
            IF NOT cl_null(g_rvb[l_ac].rvb10) THEN
               #IF g_rvb[l_ac].rvb10 <= 0 THEN  #NO.TQC-660145 MARK
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
         #end No.FUN-550117
 
        #FUN-670051...............begin
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
 
        #FUN-670051...............end
         BEFORE DELETE                            #是否取消單身
            IF g_rvb_t.rvb02 > 0 AND g_rvb_t.rvb02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
#FUN-9A0065---BEGIN               
           #    IF NOT cl_confirm('資料來源為電子交貨單，是否確定刪除？')
                  CANCEL DELETE 
           #    END IF
#FUN-9A0065---END
               #-----No.FUN-810036-----
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                    IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045
                       CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                     SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
                  END IF
               END IF
               #-----No.FUN-810036 END-----
 
               DELETE FROM rvb_file
                WHERE rvb01 = g_rva.rva01 AND rvb02 = g_rvb_t.rvb02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('del rvb:',SQLCA.sqlcode,0) #No.FUN-660129
                  CALL cl_err3("del","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","del rvb",1) #No.FUN-660129
                  ROLLBACK WORK
                  CANCEL DELETE
&ifndef STD
               #No.FUN-7B0018 080306 add --begin
               ELSE
                  IF NOT s_del_rvbi(g_rva.rva01,g_rvb_t.rvb02,'') THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               #No.FUN-7B0018 080306 add --end
&endif
               END IF
&ifdef ICD
               #FUN-810038................begin
                  #一併刪除刻號/BIN資料
                  LET g_cnt = 0
                  SELECT COUNT(*) INTO g_cnt FROM ida_file
                   WHERE ida07 = g_rva.rva01
                     AND ida08 = g_rvb_t.rvb02
                  IF g_cnt > 0 THEN
                     IF NOT cl_confirm('aic-112') THEN
                        CANCEL DELETE
                     ELSE
                        CALL s_icdinout_del(0,g_rva.rva01,g_rvb_t.rvb02,'')  
                             RETURNING li_result
                        IF li_result = 0 THEN 
                           ROLLBACK WORK 
                           CANCEL DELETE 
                        END IF
                     END IF
                  END IF
 
                  #一併刪除回貨資料
                  LET g_cnt = 0
                  SELECT COUNT(*) INTO g_cnt FROM idg_file
                     WHERE idg01 = g_rva.rva01
                       AND idg02 = g_rvb_t.rvb02
                  IF g_cnt > 0 THEN
                     DELETE FROM idg_file
                        WHERE idg01 = g_rva.rva01
                          AND idg02 = g_rvb_t.rvb02
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                        CALL cl_err('del tc_rvb err',SQLCA.SQLCODE,0)
                        ROLLBACK WORK
                        CANCEL DELETE
                     END IF
                  END IF
               #FUN-810038................end
&endif
               #No.FUN-7B0018 080306 mark --begin
#&ifndef STD
#              #No.FUN-7C0017 -begin
#              DELETE FROM rvbi_file
#                    WHERE rvbi01 = g_rva.rva01 AND rvbi02 = g_rvb_t.rvb02
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err3("del","rvbi_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","del rvbi",1)
#                      ROLLBACK WORK
#                      CANCEL DELETE
#                   END IF
#              #No.FUN-7C0017 -end
#&endif
               #No.FUN-7B0018 080306 mark --end
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
#                    CALL cl_err('del rvw_file err!',SQLCA.sqlcode,0) #No.FUN-660129
                     CALL cl_err3("del","rvw_file",g_rvb[l_ac].rvb22,"",SQLCA.sqlcode,"","del rvw_file err!",1) #No.FUN-660129
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
               END IF
#FUN-9A0065-BEGIN
               UPDATE wpe_file SET wpe07 = 'N' WHERE wpe01 = g_rvb[l_ac].rvb93
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","wpe_file",g_rvb[l_ac].rvb93,"",SQLCA.sqlcode,"","upd wpe_file err!",1) 
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF               
#FUN-9A0065-END               
               IF g_success='Y' THEN
                  COMMIT WORK
               ELSE
                  ROLLBACK WORK
               END IF
            END IF
 
         #No.FUN-840042 --start--
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
         #No.FUN-840042 ---end---
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvb[l_ac].* = g_rvb_t.*
               CLOSE t110_bcl
&ifndef STD
               #No.FUN-7C0017 -Begin
                  CLOSE t110_bcl_ind
               #No.FUN-7C0017 -End
&endif
               ROLLBACK WORK
               EXIT INPUT
            END IF
&ifdef ICD
            #FUN-810038................begin
            #已有刻號/BIN存在又異動關鍵欄位的話
               IF cl_null(g_rvb_t.rvb37) THEN LET g_rvb_t.rvb37 = ' ' END IF
               IF cl_null(g_rvb_t.rvb38) THEN LET g_rvb_t.rvb38 = ' ' END IF
               IF cl_null(g_rvb[l_ac].rvb37) THEN 
                  LET g_rvb[l_ac].rvb37 = ' '
               END IF
               IF cl_null(g_rvb[l_ac].rvb38) THEN 
                  LET g_rvb[l_ac].rvb38 = ' '
               END IF
               IF g_rvb_t.rvb02 <> g_rvb[l_ac].rvb02 OR
                  g_rvb_t.rvb03 <> g_rvb[l_ac].rvb03 OR
                  g_rvb_t.rvb04 <> g_rvb[l_ac].rvb04 OR
                  g_rvb_t.rvb36 <> g_rvb[l_ac].rvb36 OR
                  g_rvb_t.rvb37 <> g_rvb[l_ac].rvb37 OR
                  g_rvb_t.rvb38 <> g_rvb[l_ac].rvb38 THEN
                  IF NOT t110_ind_icd_chk_icd() THEN
                     NEXT FIELD rvb04
                  END IF 
               END IF
            #FUN-810038................end
&endif
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rvb[l_ac].rvb02,-263,1)
               LET g_rvb[l_ac].* = g_rvb_t.*
            ELSE
               #No.FUN-540027  --begin
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
 
               IF cl_null(g_rvb[l_ac].rvb86) THEN
                  LET g_rvb[l_ac].rvb86 = g_rvb[l_ac].rvb90    #No.FUN-940083 pmn07-->rvb90 
                  LET g_rvb[l_ac].rvb87 = g_rvb[l_ac].rvb07
               END IF
               #No.FUN-540027  --end
 
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
#                    CALL cl_err(g_rvb[l_ac].rvb22,'aap-762',0) #No.FUN-660129
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
&ifdef ICD
                  #FUN-810038................begin
                     SELECT SUM(rvb07) INTO t_alt06 
                       FROM rvb_file,rvbi_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01!=g_rva.rva01 AND rvb35='N'
                        AND rvbi01=rvb01
                        AND rvbi02=rvb02
                        AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
                  #FUN-810038................end
&else
                     SELECT SUM(rvb07) INTO t_alt06 FROM rvb_file
                      WHERE rvb22=g_rvb[l_ac].rvb22
                        AND rvb04=g_rvb[l_ac].rvb04
                        AND rvb03=g_rvb[l_ac].rvb03
                        AND rvb01!=g_rva.rva01 AND rvb35='N'
&endif
                  IF cl_null(t_alt06) THEN
                     LET t_alt06 = 0
                  END IF
                  IF g_rvb[l_ac].rvb07 > (l_alt06-t_alt06) THEN
                     CALL cl_err('','apm-305',0)
                     #No.FUN-540027  --begin
                     IF g_sma.sma115 = 'Y' THEN
                        IF g_ima906 MATCHES '[23]' THEN
                           NEXT FIELD rvb85
                        ELSE
                           NEXT FIELD rvb82
                        END IF
                     ELSE
                        NEXT FIELD rvb07
                     END IF
                     #No.FUN-540027  --end
                  END IF
               END IF
               #---再判斷一次倉儲批是否存在
#              IF g_sma.sma886[7,7] ='Y' THEN      #No.TQC-740313   #CHI-7A0003 mark
&ifdef ICD
               #ICD begin
               #FUN-810038................begin
               IF g_rvbi2.rvbiicd13='N' OR cl_null(g_rvbi2.rvbiicd13) #委外非最終站不檢查倉/儲/批及庫存
                  THEN
               #FUN-810038................end
               #ICD end
&endif
                  #IF NOT cl_null(g_rvb[l_ac].rvb36) THEN   #MOD-910227
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
&ifdef ICD
               END IF      #No.FUN-810038
&endif
#              END IF      #No.TQC-740313    #CHI-7A0003 mark
               CALL t110_b_move_back() #FUN-730068
               #CHI-7B0023..............begin #本段移到move_back中
               #LET g_rvb2.rvb01 = g_rva.rva01
               #LET g_rvb2.rvb02 = g_rvb[l_ac].rvb02
               #LET g_rvb2.rvb03 = g_rvb[l_ac].rvb03
               #LET g_rvb2.rvb04 = g_rvb[l_ac].rvb04
               #LET g_rvb2.rvb05 = g_rvb[l_ac].rvb05
               #LET g_rvb2.rvb07 = g_rvb[l_ac].rvb07
               #LET g_rvb2.rvb06 = 0
               #CHI-7B0023..............end
                #No.MOD-490173
              #IF cl_chk_act_auth() THEN
                  IF cl_null(g_rvb[l_ac].rvb10) THEN
                     LET g_rvb[l_ac].rvb10 = 0
                  END IF
                  LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
              #ELSE
              #   IF cl_null(g_pmn31) THEN LET g_pmn31 = 0 END IF
              #   LET g_rvb2.rvb10 = g_pmn31
              #END IF
              #No.FUN-550117
              IF cl_null(g_rvb[l_ac].rvb10t) THEN LET g_rvb[l_ac].rvb10t = 0 END IF
              LET g_rvb2.rvb10t = g_rvb[l_ac].rvb10t
              #end No.FUN-550117
               LET g_rvb2.rvb22 = g_rvb[l_ac].rvb22
               LET g_rvb2.rvb26 = NULL
              #LET g_rvb2.rvb31 = g_rvb2.rvb07        #可入庫量  #MOD-880166 mark
               LET g_rvb2.rvb34 = g_rvb[l_ac].rvb34
               LET g_rvb2.rvb35 = g_rvb[l_ac].rvb35
               LET g_rvb2.rvb36 = g_rvb[l_ac].rvb36
               LET g_rvb2.rvb37 = g_rvb[l_ac].rvb37
               LET g_rvb2.rvb38 = g_rvb[l_ac].rvb38
               #IF cl_null(g_rvb2.rvb08) THEN    #MOD-940056
               IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN   #MOD-940056
                  LET g_rvb2.rvb08 = g_rvb2.rvb07
               END IF
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
               #FUN-850022 --begin
                #CALL t110_get_rvb39(g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
                CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
                  RETURNING g_rvb2.rvb39 #MOD-530415
               #FUN-850022 --end
               #No.FUN-540027  --begin
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
               #No.FUN-540027  --end
 
               IF g_argv6 ='1' THEN                  #FUN-940083
                  #CHI-830033-begin-add
                  #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
                  SELECT gec07 INTO g_gec07 FROM gec_file,pmm_file
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
                  IF g_gec07='Y' THEN
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rvb[l_ac].pmm43/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
#TQC-960445 --BEGIN--
                     IF cl_null(g_rvb2.rvb10t) THEN 
                        LET g_rvb2.rvb10t = 0 
                     END IF 
                     IF cl_null(g_rva.rva116) THEN 
                        LET g_rva.rva116 = 0 
                     END IF    
#TQC-960445 --END--
                     LET g_rvb2.rvb10 = g_rvb2.rvb10t / ( 1 + g_rva.rva116/100)    #FUN-940083
                  ELSE
                     LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rvb[l_ac].pmm43/100)
                     LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
                     LET g_rvb2.rvb10t = g_rvb2.rvb10 * ( 1 + g_rva.rva116/100)    #FUN-940083
                  END IF
                  #CHI-830033-end-add
#FUN-940083--begin
              ELSE
                  #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
                  SELECT gec07 INTO g_gec07 FROM gec_file
                   WHERE gec01 = g_rva.rva115
                  IF SQLCA.SQLCODE = 100 THEN
                     CALL cl_err('','mfg3192',0)
                     NEXT FIELD rvb04
                  END IF
                  SELECT azi04 INTO t_azi04 
                    FROM azi_file
                   WHERE azi01 = g_rva.rva113
                  IF g_gec07='Y' THEN
                     LET g_rvb2.rvb88 = g_rvb2.rvb88t / ( 1 + g_rva.rva116/100)
                     LET g_rvb2.rvb88 = cl_digcut(g_rvb2.rvb88 , t_azi04)  
                  ELSE
                     LET g_rvb2.rvb88t = g_rvb2.rvb88 * ( 1 + g_rva.rva116/100)
                     LET g_rvb2.rvb88t = cl_digcut( g_rvb2.rvb88t , t_azi04)  
                  END IF
              END IF
#FUN-940083--end
&ifdef ICD
               #FUN-810038................begin
                  #料號為參考單位,單一單位,且狀態為其它段生產料號(ta_ima040=3,4)時,
                  #將單位一的資料給單位二
                  CALL t110_ind_icd_set_value()
               #FUN-810038................end
&endif
 
              #FUN-730068.............begin
              #UPDATE rvb_file SET rvb02=g_rvb2.rvb02,
              #                    rvb03=g_rvb2.rvb03,
              #                    rvb04=g_rvb2.rvb04,
              #                    rvb05=g_rvb2.rvb05,
              #                    rvb06=g_rvb2.rvb06,
              #                    rvb07=g_rvb2.rvb07,
              #                    #No.FUN-540027  --begin
              #                    rvb80=g_rvb2.rvb80,
              #                    rvb81=g_rvb2.rvb81,
              #                    rvb82=g_rvb2.rvb82,
              #                    rvb83=g_rvb2.rvb83,
              #                    rvb84=g_rvb2.rvb84,
              #                    rvb85=g_rvb2.rvb85,
              #                    rvb86=g_rvb2.rvb86,
              #                    rvb87=g_rvb2.rvb87,
              #                    rvb88=g_rvb2.rvb88,
              #                    rvb88t=g_rvb2.rvb88t,
              #                    #No.FUN-540027  --end
              #                    rvb10=g_rvb2.rvb10,
              #                    rvb10t=g_rvb2.rvb10t,  #No.FUN-550117
              #                    rvb12=g_rvb2.rvb12,
              #                    rvb22=g_rvb2.rvb22,
              #                    rvb31=g_rvb2.rvb31,
              #                    rvb08=g_rvb2.rvb08,
              #                    rvb11=g_rvb2.rvb11,
              #                    rvb19=g_rvb2.rvb19,
              #                    rvb13=g_rvb2.rvb13,
              #                    rvb17=g_rvb2.rvb17,
              #                    rvb14=g_rvb2.rvb14,
              #                    rvb15=g_rvb2.rvb15,
              #                    rvb16=g_rvb2.rvb16,
              #                    rvb25=g_rvb2.rvb25,
              #                    rvb34=g_rvb2.rvb34,
              #                    rvb35=g_rvb2.rvb35,
              #                    rvb36=g_rvb2.rvb36,
              #                    rvb37=g_rvb2.rvb37,
              #                    rvb38=g_rvb2.rvb38,
              #                    rvb39=g_rvb2.rvb39, #MOD-530415
              #                    rvb930=g_rvb2.rvb930 #FUN-670051
              UPDATE rvb_file SET * = g_rvb2.*
              #FUN-730068.............end
                WHERE rvb01=g_rva.rva01
                  AND rvb02=g_rvb_t.rvb02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#                 CALL cl_err('upd rvb_file',SQLCA.sqlcode,0) #No.FUN-660129
                  CALL cl_err3("upd","rvb_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","upd rvb_file",1) #No.FUN-660129
                  LET g_rvb[l_ac].* = g_rvb_t.*
               ELSE
&ifndef STD
                  #No.FUN-7C0017 -Begin
		                 UPDATE rvbi_file SET * = g_rvbi2.*
			            	     WHERE rvbi01=g_rva.rva01
			            	       AND rvbi02=g_rvb_t.rvb02
		                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
			                  CALL cl_err3("upd","rvbi_file",g_rva.rva01,g_rvb_t.rvb02,SQLCA.sqlcode,"","upd rvbi_file",1)
			                  LET g_rvb[l_ac].* = g_rvb_t.*
		                 END IF
&ifdef ICD
		                 #FUN-810038................begin
		                 #有更改倉/儲/批,更新刻號/BIN 及 回貨資料資訊
                     IF (g_rvb2.rvb36 <> g_rvb_t.rvb36) OR
                        (g_rvb2.rvb37 <> g_rvb_t.rvb37) OR
                        (g_rvb2.rvb38 <> g_rvb_t.rvb38) THEN
                        UPDATE ida_file
                           SET ida02 = g_rvb2.rvb36,
                               ida03 = g_rvb2.rvb37,
                               ida04 = g_rvb2.rvb38
                           WHERE ida07 = g_rva.rva01
                             AND ida08 = g_rvb_t.rvb02
                        UPDATE idg_file
                           SET idg07 = g_rvb2.rvb38        #批號
                          WHERE idg01 = g_rva.rva01
                            AND idg02 = g_rvb_t.rvb02
                     END IF
                     #FUN-810038................end
&endif
&endif
		              #No.FUN-7C0017 -End
		              CALL cl_msg('UPDATE O.K')
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
#CHI-7A0003 mark
#          #MOD-770082-begin-add
#           LET l_ec_sw = 'N'
#           CALL t110_ec_sw() RETURNING l_ec_sw    #MOD-770082 add
#           IF l_ec_sw = 'N' AND g_sma.sma886[7,7]='Y'  THEN
#              IF cl_null(g_rvb[l_ac].rvb36) AND  cl_null(g_rvb[l_ac].rvb34) THEN
#                 CALL cl_err('','aap-099',0)
#                 NEXT FIELD rvb36
#              END IF
#           END IF
#          #MOD-770082-end-add
#CHI-7A0003 mark-end
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #-----No.FUN-810036-----
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_rvb[l_ac].rvb05
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_sma.sma90 = 'Y' THEN   #FUN-850120 add 
                    IF NOT s_lotin_del(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,g_rvb[l_ac].rvb05,'DEL') THEN   #No.FUN-860045
                       CALL cl_err3("del","rvbs_file",g_rva.rva01,g_rvb_t.rvb02,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                  END IF #FUN-850120
               END IF
               #-----No.FUN-810036 END-----
               IF p_cmd = 'u' THEN
                  LET g_rvb[l_ac].* = g_rvb_t.*
               END IF
               CLOSE t110_bcl
&ifndef STD
               #No.FUN-7C0017 -Begin
                  CLOSE t110_bcl_ind
               #No.FUN-7C0017 -End
&endif
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t110_bcl
&ifndef STD
            #No.FUN-7C0017 -Begin
               CLOSE t110_bcl_ind
            #No.FUN-7C0017 -End
&endif
            COMMIT WORK
&ifdef ICD
            #FUN-810038................begin
               IF g_argv2='SUB' THEN
                  BEGIN WORK
                  LET g_success = 'Y'
                  CALL t110_ind_icd_trans_chk('a')
                  IF g_success = 'Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
               IF p_cmd='a' THEN
                  SELECT imaicd08 INTO l_imaicd08
                    FROM imaicd_file
                   WHERE imaicd00=l_rvb.rvb05
                  IF l_imaicd08='Y' THEN
                     CALL s_icdin(0,g_rvb2.rvb05,g_rvb2.rvb36,
                                    g_rvb2.rvb37,g_rvb2.rvb38,
                                    l_pmn07    ,g_rvb2.rvb07,
                                    g_rva.rva01,g_rvb2.rvb02,
                                    g_rva.rva06,l_ida15,
                                    g_rvbi2.rvbiicd14,'','')
                          RETURNING l_dies
                     CALL t110_ind_icd_upd_dies(l_dies)
                  END IF
               END IF
            #FUN-810038................end
&endif
 
 
         ON ACTION qry_warehouse        #MOD-490328
                   #MOD-480604查詢倉庫
                  CALL cl_init_qry_var()
                  #NO.FUN-960130---BEGIN----
                  IF g_azw.azw04 = '2' THEN
                     IF g_rva.rva29 = '1' THEN
                        LET g_qryparam.form = 'q_imd_01'
                     ELSE
                        LET g_qryparam.form = 'q_imd_02'
                     END IF
                     LET g_qryparam.arg1 = g_rva.rvaplant
                  ELSE
                     LET g_qryparam.form     = "q_imd"
                  END IF
                  #LET g_qryparam.form     = "q_imd"
                  #NO.FUN-960130----END----
                  LET g_qryparam.default1 = g_rvb[l_ac].rvb36
                 #LET g_qryparam.arg1     = "A" #BUB-4A0213
                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                  CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb36
#                 CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].rvb36 )
                  DISPLAY BY NAME g_rvb[l_ac].rvb36
                  NEXT FIELD rvb36
 
        ON ACTION qry_loc_warehouse        # 遇不可空白欄位可 cursor up
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ime"
           LET g_qryparam.default1 = g_rvb[l_ac].rvb37
            LET g_qryparam.arg1     = g_rvb[l_ac].rvb36 #倉庫編號 #MOD-4A0063
            LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
           CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb37
#           CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].rvb37 )
           NEXT FIELD rvb37
 
       ON ACTION controlp
          CASE
             #TQC-650108
             #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
             #BEFORE FIELD att00來做開窗了
             #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
             WHEN INFIELD(att00)
                #可以新增子料件,開窗是單純的選取母料件
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_ima_p"
#               LET g_qryparam.default1 = g_rvb[l_ac].att00
                LET g_qryparam.arg1 = lg_group
                CALL cl_create_qry() RETURNING g_rvb[l_ac].att00
#               CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].att00 )
                DISPLAY BY NAME g_rvb[l_ac].att00        #No.MOD-490371
                NEXT FIELD att00
             #TQC-650108 --end
 
             WHEN INFIELD(rvb04) #查詢採購單號
&ifdef ICD
                #FUN-810038................begin
                   CASE g_argv2
                      WHEN "ICD"
                         CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_rva.rva10,g_rva.rva02)    #MOD-C30434 add rva02
                                     RETURNING g_rvb[l_ac].rvb04
                      OTHERWISE
                         CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_argv2,g_rva.rva02)        #MOD-C30434 add rva02
                                     RETURNING g_rvb[l_ac].rvb04
                   END CASE
                #FUN-810038................end
&else
                   CALL q_pmm5(FALSE,TRUE,'',g_rva.rva05,'2',g_argv2,g_rva.rva02)              #MOD-C30434 add rva02
                               RETURNING g_rvb[l_ac].rvb04
&endif
                DISPLAY BY NAME g_rvb[l_ac].rvb04              #No.MOD-490371
                NEXT FIELD rvb04
             #No.FUN-840178 --begin--
             WHEN INFIELD(rvb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.where="ima151!='Y'"
                 LET g_qryparam.default1 = g_rvb[l_ac].rvb05
                 CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb05
                 NEXT FIELD rvb05
             #No.FUn-840178 --end--   
             WHEN INFIELD(rvb03) #P/O項次
                 CALL cl_init_qry_var()
&ifdef ICD
                 #FUN-810038................begin
                    LET g_qryparam.form ="q_pmn1_icd"
                    LET g_qryparam.default1 = g_rvb[l_ac].rvb03
                    LET g_qryparam.arg1 = g_rvb[l_ac].rvb04
                    LET g_qryparam.arg2 = g_rva.rva10
                 #FUN-810038................end
&else
                    LET g_qryparam.form ="q_pmn1"
                    LET g_qryparam.default1 = g_rvb[l_ac].rvb03
                    LET g_qryparam.arg1 = g_rvb[l_ac].rvb04
                    LET g_qryparam.construct='N'
&endif
                 CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb03
                 DISPLAY BY NAME g_rvb[l_ac].rvb03              #No.MOD-490371
                 NEXT FIELD rvb03
             WHEN INFIELD(rvb36) OR INFIELD(rvb37) OR INFIELD(rvb38)
                 CALL cl_init_qry_var()
               ##CALL q_img4(FALSE,FALSE,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36, ##NO.FUN-660085
                 CALL q_img4(FALSE,TRUE,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,  ##NO.FUN-660085
                                  g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,'A')
                 RETURNING g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38
                  #No.MOD-490028
                 DISPLAY g_rvb[l_ac].rvb36 TO rvb36
                 DISPLAY g_rvb[l_ac].rvb37 TO rvb37
                 DISPLAY g_rvb[l_ac].rvb38 TO rvb38
                  #No.MOD-490028(end)
                 IF INFIELD(rvb36) THEN NEXT FIELD rvb36 END IF
                 IF INFIELD(rvb37) THEN NEXT FIELD rvb37 END IF
                 IF INFIELD(rvb38) THEN NEXT FIELD rvb38 END IF
              #No.MOD-4B0275
             WHEN INFIELD(rvb25)
                 SELECT pmm04 INTO l_pmm04 FROM pmm_file
                  WHERE pmm01 = g_rvb[l_ac].rvb04
                 CALL q_coc2(FALSE,FALSE,g_rvb[l_ac].rvb25,'',l_pmm04,'1',
                             '',g_rvb[l_ac].rvb05)
                 RETURNING g_rvb[l_ac].rvb25,l_coc04
#                 CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].rvb25 )
                  DISPLAY BY NAME g_rvb[l_ac].rvb25              #No.MOD-490371
                 NEXT FIELD rvb25
              #No.MOD-4B0275 end
             #FUN-670051...............begin
             WHEN INFIELD(rvb930)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb930
                DISPLAY BY NAME g_rvb[l_ac].rvb930
                NEXT FIELD rvb930
             #FUN-670051...............end
&ifdef ICD
             #FUN-810038................begin
             WHEN INFIELD(rvbiicd03) #rvbiicd03
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_ecd_icd"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvbiicd03
                DISPLAY BY NAME g_rvb[l_ac].rvbiicd03
                NEXT FIELD rvbiicd03
             WHEN INFIELD(rvbiicd12) #rvbiicd12
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_icq"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvbiicd12
                DISPLAY BY NAME g_rvb[l_ac].rvbiicd12
                NEXT FIELD rvbiicd12
             WHEN INFIELD(rvbiicd14) #rvbiicd14
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imaicd1"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvbiicd14
                DISPLAY BY NAME g_rvb[l_ac].rvbiicd14
                NEXT FIELD rvbiicd14
             WHEN INFIELD(rvbiicd15) #rvbiicd15
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvbiicd15
                DISPLAY BY NAME g_rvb[l_ac].rvbiicd15
                NEXT FIELD rvbiicd15
             #FUN-810038................end
&endif
             #FUN-940083--begin
             WHEN INFIELD(rvb90) #rvb90
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb90
                DISPLAY BY NAME g_rvb[l_ac].rvb90
                NEXT FIELD rvb90
             #FUN-940083--end
 
             OTHERWISE EXIT CASE
 
          END CASE
 
&ifdef ICD
        #ICD begin
        #FUN-810038................begin
         #@WHEN "回貨資料查詢"
         ON ACTION aic_qry_back
            IF cl_chk_act_auth() THEN
               IF (NOT cl_null(g_rva.rva01)) AND
                  (NOT cl_null(l_ac)) AND (l_ac <> 0) THEN
                  LET g_cmd = "aicq021 '",g_rva.rva01,"' ",
                              "'",g_rvb[l_ac].rvb02,"'"
                  CALL cl_cmdrun_wait(g_cmd)
               END IF
            END IF
         #@WHEN "單據刻號BIN查詢作業"
         ON ACTION aic_s_icdqry
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rva.rva01) THEN
                  CALL s_icdqry(0,g_rva.rva01,'',g_rva.rvaconf,'')
               END IF
            END IF
        #FUN-810038................end
        #ICD end
&endif
 
        ON ACTION invoice_data
           #大陸版, 發票統一在入庫單發票維護作業輸入
           IF g_aza.aza26 != '2' THEN
              CALL sapmt114(g_rvb[l_ac].rvb22,g_rva.rva01)
                            RETURNING g_rvb[l_ac].rvb22
               DISPLAY g_rvb[l_ac].rvb22 TO rvb22 #No.MOD-480094
              IF INT_FLAG THEN LET INT_FLAG=0 END IF
             #--------------------No.MOD-720103 modify
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
                    END IF
                 END IF
              END IF
 
             #UPDATE滑鼠所指向單身項次所對應的發票號碼
              UPDATE rvb_file
                 SET rvb22=g_rvb[l_ac].rvb22
               WHERE rvb01=g_rva.rva01
                 AND rvb02 = g_rvb[l_ac].rvb02
 
              DISPLAY BY NAME g_rvb[l_ac].rvb22 #No.MOD-480094
             #--------------------No.MOD-720103 end
           END IF
 
        ON ACTION maintain_other_data
           CALL t110_b_more()
 
        ON ACTION maintain_warehouse
           LET l_cmd = 'aimi200 ' CLIPPED
           CALL cl_cmdrun(l_cmd)
 
        ON ACTION maintain_loc_warehouse
           LET l_cmd = "aimi201 '",g_rvb[l_ac].rvb36,"'" #BugNo:6598
           CALL cl_cmdrun(l_cmd)
 
       ON ACTION default_loc_w_h
          CALL cl_init_qry_var()
          LET g_qryparam.form ="q_imf"
          LET g_qryparam.construct="N"
          LET g_qryparam.default1 = g_rvb[l_ac].rvb36
          CALL cl_create_qry() RETURNING g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
#          CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].rvb36 )
#          CALL FGL_DIALOG_SETBUFFER( g_rvb[l_ac].rvb37 )
          NEXT FIELD rvb36
 
        #-----No.FUN-810036-----
        ON ACTION modi_lot
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
                 SELECT img09 INTO g_img09
                   FROM img_file   #庫存單位
                  WHERE img01=g_rvb[l_ac].rvb05 AND img02=g_rvb[l_ac].rvb36
                    AND img03=g_rvb[l_ac].rvb37 AND img04=g_rvb[l_ac].rvb38
                 CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09)    #No.FUN-940083 pmn07-->rvb90 
                      RETURNING l_i,l_fac
                 IF l_i = 1 THEN LET l_fac = 1 END IF
                 CALL s_lotin(g_prog,g_rva.rva01,g_rvb[l_ac].rvb02,0,
                              g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_img09,     #No.FUN-940083 pmn07-->rvb90 
                              l_fac,g_rvb[l_ac].rvb07,'MOD')
                     RETURNING l_r,g_qty 
                 #-----No.FUN-860045-----
                 IF l_r = "Y" THEN
                    LET g_rvb[l_ac].rvb07 = g_qty
                 END IF
                 #-----No.FUN-860045 END-----
              END IF   #FUN-850120
           END IF
        #-----No.FUN-810036 END-----
 
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
   UPDATE rva_file SET rvamodu=g_user,rvadate=g_today
    WHERE rva01=g_rva.rva01
   #-----MOD-930320---------
   #SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
   #IF g_cnt > g_sma.sma110 THEN
   #   CALL cl_err('','axm-156',0)
   #END IF
   #-----END MOD-930320-----
   COMMIT WORK  #NO.9728
 
   #No.FUN-550117
#No.FUN-610018
#  LET g_gec07 = 'N'
#  FOR l_i = 1 TO g_rec_b
#      IF g_rvb[l_i].gec07 = 'Y' THEN LET g_gec07 = 'Y' END IF
#  END FOR
#  IF g_gec07 = 'Y' THEN            #No.FUN-560102
#     CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",TRUE)
#  ELSE
#     CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",FALSE)
#  END IF
   #end No.FUN-550117
END FUNCTION
#NO.FUN-960130---START---
#得到取價類型、價格來源、來源單號、來源項次
FUNCTION t110_get_price()
DEFINE l_sma135 LIKE sma_file.sma135   
DEFINE l_pmm    RECORD LIKE pmm_file.*  
DEFINE l_pmn    RECORD LIKE pmn_file.* 
 
    IF g_rvb[l_ac].rvb04 IS NULL OR g_rvb[l_ac].rvb03 IS NULL THEN
       RETURN
    END IF
    SELECT sma135 INTO l_sma135 FROM sma_file
    IF l_sma135 = 'Y' THEN
       SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.* FROM pmm_file,pmn_file
        WHERE pmm01 = pmn01
          AND pmm01 = g_rvb[l_ac].rvb04
          AND pmn02 = g_rvb[l_ac].rvb03
       #CALL s_defprice_rtl(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm04,l_pmn.pmn07,l_pmm.pmm22,l_pmm.pmm21,
       #                    '1',l_pmm.pmm43,l_pmn.pmn20,l_pmm.pmm51,l_pmm.pmm930)
       #    RETURNING  g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t,g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43
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
END FUNCTION
#NO.FUN-960130----END----
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
&ifndef STD
   DEFINE l_pmni   RECORD LIKE pmni_file.* #FUN-810038
&endif
&ifdef ICD
   DEFINE l_sfbiicd13 LIKE sfbi_file.sfbiicd13       #FUN-810038
&endif
   DEFINE l_pmn18   LIKE pmn_file.pmn18   #CHI-8C0017
   DEFINE l_sfb24   LIKE sfb_file.sfb24   #MOD-910227
   DEFINE l_pmc915  LIKE pmc_file.pmc915  #FUN-940083
   DEFINE l_pmc916  LIKE pmc_file.pmc916  #FUN-940083
   DEFINE l_times   LIKE type_file.num5    #NO.FUN-960130
   DEFINE l_n       LIKE type_file.num5   #NO.FUN-960130
   DEFINE l_rtz07   LIKE rtz_file.rtz07   #NO.FUN-960130
   DEFINE l_rtz08   LIKE rtz_file.rtz08   #NO.FUN-960130
   DEFINE l_sma135  LIKE sma_file.sma135  #FUN-870007
 
 
   LET g_rec_b = 0
   IF g_rva.rva01 IS NULL THEN RETURN END IF
   IF NOT cl_confirm('apm-252') THEN RETURN END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL g_rvb.clear()
#FUN-810038................begin #以下這段改寫
#No.FUN-540027  --begin
##-----------No.TQC-660053 modify
#  LET g_sql = "SELECT '','',pmn01,pmn02,pmn41,pmn04, ",
#              "       '','','','','','','','','','','', ",
#              "       '','','','','','','','','','', ",
#              "       pmn041,'',pmn07,",
##-----------No.TQC-660053 end
#              "       pmn20,(pmn50-pmn55),0,0,'N',(pmn20-pmn50+pmn55), ",
#              "       pmn83,pmn84,pmn85,pmn80,pmn81,pmn82,pmn86,pmn87,",
#             #MOD-690012-begin
#             #"       pmn31,pmn31t,pmn52,pmn54,pmn56,pmn71,'',0,'',pmn930,'',pmn122,pmn65,", #No.FUN-550117 #FUN-670051 #TQC-670089 rvb930->pmn930
#             #"       pmn31,pmn31t,pmn52,pmn54,pmn56,pmn71,'',0,pmn930,'',pmn122,pmn65,", #No.FUN-550117 #FUN-670051 #TQC-670089 rvb930->pmn930  #MOD-7B0097 mark
#             #MOD-690012-end
#             #MOD-7B0097-begin-modify
#              "       pmn31,pmn31t,pmn52,pmn54,pmn56,pmn71,'',0,pmn930,'',pmn122,pmn65,", #No.FUN-550117 #FUN-670051 #TQC-670089 rvb930->pmn930
#              ##MOD-7B0097-begin-add
#              #因行業別加欄位故需對應之後欄位取消了不用改
#              #"       pmn31,pmn31t,pmn52,pmn54,pmn56,pmn71,'',0,pmn930,'',", #No.FUN-550117 #FUN-670051 #TQC-670089 rvb930->pmn930
#              #"       '','','','','','','','','','','','','', ",
#              #"       '','','','','','','','','','','','','', ",
#              #"       '','','','','','','','','','','','','', ",
#              #"       '','','','','','','','','','','','','', ",
#              #"       '','','','','','','','', ",
#              #"       pmn122,pmn65,",
#              ##MOD-7B0097-end-add
#             #MOD-7B0097-end-modify
#              "       pmn88,pmn88t ", #No.FUN-550117
#              "  FROM pmn_file,pmm_file",
#              " WHERE pmn01 = '",g_rva.rva02 CLIPPED,"' AND pmm18 <> 'X' ",
#              "   AND (pmn20-pmn50+pmn55>0)  AND pmm01=pmn01 AND pmn16='2' "
#  #No.FUN-540027  --end
#  PREPARE t110_g_b_p1 FROM g_sql
#  DECLARE t110_g_b_c1 CURSOR WITH HOLD FOR t110_g_b_p1
#  DISPLAY "G_SQL=",g_sql
#  LET l_ac = 1
#  FOREACH t110_g_b_c1 INTO g_rvb[l_ac].*,l_pmn122,l_pmn65,l_pmn88,l_pmn88t #No.FUN-540027
 
   LET g_sql = "SELECT pmm_file.*,pmn_file.* FROM pmm_file,pmn_file ",
               " WHERE pmn01 = '",g_rva.rva02 CLIPPED,"' AND pmm18 <> 'X' ",
#              "   AND (pmn20-pmn50+pmn55>0)  AND pmm01=pmn01 AND pmn16='2' "         #No.FUN-940083
               "   AND (pmn20-pmn50+pmn55+pmn58>0)  AND pmm01=pmn01 AND pmn16='2' "   #No.FUN-940083
 
   PREPARE t110_g_b_p1 FROM g_sql
 
   DECLARE t110_g_b_c1 CURSOR WITH HOLD FOR t110_g_b_p1
 
   LET l_ac = 1
 
   FOREACH t110_g_b_c1 INTO l_pmm.*,l_pmn.*
#FUN-810038................end
      IF SQLCA.SQLCODE THEN CALL cl_err('for pmn',SQLCA.SQLCODE,1) EXIT FOREACH END IF      
      #NO.FUN-960130----BEGIN----
      IF g_azw.azw04='2' THEN
         IF l_pmm.pmm51 != g_rva.rva29 THEN
            CONTINUE FOREACH
         END IF
      END IF
      #NO.FUN-960130---END---
&ifdef ICD
      #FUN-810038................begin
         SELECT * INTO l_pmni.* FROM pmni_file
          WHERE pmni01=l_pmn.pmn01
            AND pmni02=l_pmn.pmn02
      #FUN-810038................end      
&endif
 
      LET g_rvb[l_ac].rvb22=null
      INITIALIZE g_rvb2.* TO NULL
      INITIALIZE g_rvbi2.* TO NULL  #FUN-810038
      #FUN-810038................begin
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
#     LET g_rvb[l_ac].rvb07     = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55               #No.FUN-940083
      LET g_rvb[l_ac].rvb07     = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55+l_pmn.pmn58   #No.FUN-940083
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
#FUN-940083--begin
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
#     LET g_rvb[l_ac].rvb36     = l_pmn.pmn52
#     LET g_rvb[l_ac].rvb37     = l_pmn.pmn54
#FUN-940083--end
      LET g_rvb[l_ac].rvb38     = l_pmn.pmn56
      LET g_rvb[l_ac].rvb25     = l_pmn.pmn71
      LET g_rvb[l_ac].pmm43     = 0
      LET g_rvb[l_ac].rvb930    = l_pmn.pmn930
      
      LET l_pmn122 = l_pmn.pmn122
      LET l_pmn65  = l_pmn.pmn65 
      LET l_pmn88  = l_pmn.pmn88 
      LET l_pmn88t = l_pmn.pmn88t      
      #NO.FUN-960130----BEGIN-------
      IF g_azw.azw04='2' THEN
         SELECT sma135 INTO l_sma135 FROM sma_file
         IF l_sma135 = 'Y' THEN
            #CALL s_defprice_rtl(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm04,l_pmn.pmn07,l_pmm.pmm22,l_pmm.pmm21,
            #                    '1',l_pmm.pmm43,l_pmn.pmn20,l_pmm.pmm51,l_pmm.pmm930)
            #     RETURNING  g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t,g_rvb[l_ac].rvb42,g_rvb[l_ac].rvb43
            LET l_pmn88 = g_rvb[l_ac].rvb10
            LET l_pmn88t = g_rvb[l_ac].rvb10t
            LET g_rvb2.rvb42 = g_rvb[l_ac].rvb42
            LET g_rvb2.rvb43 = g_rvb[l_ac].rvb43
         ELSE
            LET g_rvb2.rvb42 = l_pmn.pmn73
            LET g_rvb2.rvb43 = l_pmn.pmn74
         END IF
         IF g_rva.rva29 = '1' THEN
            #SELECT rtz07 INTO g_rvb[l_ac].rvb36 FROM rtz_file WHERE rtz01 = g_rva.rvaplant     #FUN-C90049 mark
            CALL s_get_coststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING g_rvb[l_ac].rvb36                 #FUN-C90049 add  
         ELSE
            #SELECT rtz08 INTO g_rvb[l_ac].rvb36 FROM rtz_file WHERE rtz01 = g_rva.rvaplant     #FUN-c90049 mark
            CALL s_get_noncoststore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING g_rvb[l_ac].rvb36              #FUN-C90049 add
         END IF
         IF g_rvb[l_ac].rvb36 IS NULL THEN
            CONTINUE FOREACH
         END IF
      ELSE
         LET g_rvb2.rvb42 = '1'
      END IF
      IF g_rvb2.rvb42 IS NULL THEN LET g_rvb2.rvb42 = '1' END IF
      #NO.FUN-960130----END--------
&ifdef ICD
         LET g_rvb[l_ac].rvbiicd03 = l_pmni.pmniicd03
         LET g_rvb[l_ac].rvbiicd14 = l_pmni.pmniicd14
         LET g_rvb[l_ac].rvbiicd10 = l_pmni.pmniicd06
         LET g_rvb[l_ac].rvbiicd12 = l_pmni.pmniicd12
         LET g_rvb[l_ac].rvbiicd15 = l_pmni.pmniicd15
         LET g_rvb[l_ac].rvbiicd16 = l_pmni.pmniicd16
         
         LET g_rvbi2.rvbiicd03 = g_rvb[l_ac].rvbiicd03
         LET g_rvbi2.rvbiicd14 = g_rvb[l_ac].rvbiicd14
         LET g_rvbi2.rvbiicd06 = g_rvb[l_ac].rvbiicd10
         LET g_rvbi2.rvbiicd12 = g_rvb[l_ac].rvbiicd12
         LET g_rvbi2.rvbiicd15 = g_rvb[l_ac].rvbiicd15
         LET g_rvbi2.rvbiicd16 = g_rvb[l_ac].rvbiicd16
&endif
      #FUN-810038................end
      LET l_rvb07s=0
&ifdef ICD
      #FUN-810038................begin
         #給予收貨項次
         SELECT max(rvb02)+1 INTO g_rvb[l_ac].rvb02 
           FROM rvb_file
          WHERE rvb01 = g_rva.rva01
         IF g_rvb[l_ac].rvb02 IS NULL THEN 
            LET g_rvb[l_ac].rvb02 = 1 
         END IF
         
         #計用未收貨的數量rvb07,rvb82,rvb85,rvb87
         CALL t110_ind_icd_def_qty()
      #FUN-810038................end
&else
         SELECT SUM(rvb07)  INTO l_rvb07s FROM rva_file,rvb_file
          WHERE rvb04=g_rvb[l_ac].rvb04 AND rvb03=g_rvb[l_ac].rvb03
            AND rva01=rvb01 AND rvaconf='N' AND rvb35='N'
         IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
         LET g_rvb2.rvb07=g_rvb[l_ac].rvb07-l_rvb07s
&endif
      IF g_rvb2.rvb07 <=0 THEN
         #實收數量為零的資料不用再產生
         CONTINUE FOREACH
      END IF
      LET g_rvb[l_ac].rvb07 = g_rvb2.rvb07   #MOD-970207
 
      #-----MOD-850298---------
      ##MOD-830171-begin-add
      ##若採購量=實收量, 其計價數量應直接帶入採購單資料
      #IF g_rvb2.rvb07 = g_rvb[l_ac].pmn20 THEN
      #   LET l_rvb87_o = g_rvb[l_ac].rvb87 
      #END IF 
      ##MOD-830171-end-add
      LET l_rvb07_s = 0  
      LET l_rvb87_s = 0
      SELECT SUM(rvb07),SUM(rvb87) INTO l_rvb07_s,l_rvb87_s FROM rvb_file
        WHERE rvb04=g_rvb[l_ac].rvb04
          AND rvb03=g_rvb[l_ac].rvb03
          AND (rvb01<>g_rva.rva01 OR
          (rvb01=g_rva.rva01 AND rvb02<>g_rvb[l_ac].rvb02))
      IF cl_null(l_rvb07_s) THEN LET l_rvb07_s = 0 END IF
      IF cl_null(l_rvb87_s) THEN LET l_rvb87_s = 0 END IF
      IF (l_rvb07_s+g_rvb2.rvb07) = g_rvb[l_ac].pmn20 THEN
         LET l_rvb87_o = g_rvb[l_ac].rvb87 - l_rvb87_s
      END IF
      #-----END MOD-850298-----
 
      #-----MOD-970207---------
      ##No.FUN-540027  --begin
      #IF l_rvb07s <> 0 THEN
      #   LET g_rvb[l_ac].rvb85=0
      #   LET g_rvb[l_ac].rvb82=0
      #   LET g_rvb[l_ac].rvb87=0
      #END IF
      ##No.FUN-540027  --end
      #-----END MOD-970207-----
      IF l_ac > g_sma.sma110 THEN
         #xxxx筆==>收貨單身儲存最大筆數,其餘資料請再開一張收貨單
         CALL cl_err(g_sma.sma110,'apm-125',0)
         EXIT FOREACH
      END IF
      SELECT max(rvb02)+1 INTO g_rvb[l_ac].rvb02 FROM rvb_file
       WHERE rvb01 = g_rva.rva01
      IF g_rvb[l_ac].rvb02 IS NULL THEN LET g_rvb[l_ac].rvb02 = 1 END IF
    #FUN-810045 remark  批號不存專案代號
     ##採購單有輸入專案代號則批號用來記錄專案代號之值
     #IF NOT cl_null(l_pmn122) THEN LET g_rvb[l_ac].rvb38=l_pmn122 END IF
    #FUN-810045 remark end
      LET g_rvb2.rvb01=g_rva.rva01
      LET g_rvb2.rvb02=g_rvb[l_ac].rvb02
      LET g_rvb2.rvb03=g_rvb[l_ac].rvb03
      LET g_rvb2.rvb04=g_rvb[l_ac].rvb04
      LET g_rvb2.rvb05=g_rvb[l_ac].rvb05     #料號
      LET g_rvb2.rvb36=g_rvb[l_ac].rvb36     #倉庫
      LET g_rvb2.rvb37=g_rvb[l_ac].rvb37     #儲位
      LET g_rvb2.rvb38=g_rvb[l_ac].rvb38     #批號
      LET l_pmh08 = NULL
      #NO.FUN-960130----BEGIN----
      SELECT COUNT(*) INTO l_n FROM rvb_file,rva_file 
         WHERE rvb04 = g_rvb[l_ac].rvb04 
           AND rvb03 = g_rvb[l_ac].rvb03
           AND rva01 = rvb01
           AND rvaconf <> 'X'
 
      SELECT sma134 INTO l_times FROM sma_file
      IF l_n > l_times THEN
         INITIALIZE g_rvb[l_ac].* TO NULL
         CONTINUE FOREACH
      END IF
      #NO.FUN-960130---END----
      IF cl_null(g_rvb2.rvb36) THEN
         #SELECT pmm22 INTO l_pmm22 FROM pmm_file   #MOD-860146
         SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
          WHERE pmm01=g_rvb[l_ac].rvb04
         #CHI-8C0017--Begin--#          
#        #-----MOD-860146---------
#        IF l_pmm02 = 'SUB' THEN
#           LET l_type = '2' 
#        ELSE
#           LET l_type = '1' 
#        END IF
#        SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
#          WHERE pmn01 = g_rvb[l_ac].rvb04 
#            AND pmn02 = g_rvb[l_ac].rvb03
#        IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
#           LET l_ecm04 = " "
#        ELSE
#           SELECT ecm04 INTO l_ecm04 FROM ecm_file
#            WHERE ecm01 = l_pmn41
#              AND ecm03 = l_pmn43
#        END IF
#        #-----END MOD-860146-----
        SELECT pmn41,pmn43,pmn18 INTO l_pmn41,l_pmn43,l_pmn18 FROM pmn_file
         WHERE pmn01 = g_rvb[l_ac].rvb04 AND pmn02 = g_rvb[l_ac].rvb03          
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           #-----MOD-910172---------
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
           #-----END MOD-910172----- 
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
              END IF
           END IF   #MOD-910172
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF
        #CHI-8C0017--End--#                  
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
            #NO.FUN-960130----START------
            IF g_azw.azw04='2' THEN
               #FUN-C90049 mark beign---
               #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file 
               #    WHERE rtz01 = g_rva.rvaplant
               #FUN-C90049 marke end-----
               CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
               IF g_rva.rva29 = '1' THEN 
                  LET g_rvb[l_ac].rvb36 = l_rtz07
               ELSE
                  LET g_rvb[l_ac].rvb36 = l_rtz08
               END IF
            END IF
            #NO.FUN-960130----END---
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
      IF cl_null(g_rvb2.rvb08) OR g_rvb2.rvb08 = 0 THEN   #MOD-940056
         LET g_rvb2.rvb08=g_rvb2.rvb07
      END IF   #MOD-940056
      #-----MOD-970207---------
      ##No.FUN-540027  --begin
      #IF g_sma.sma115 = 'Y' THEN
      #   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_rvb2.rvb05
      #   IF g_sma.sma115 = 'N' OR cl_null(l_ima906) OR l_ima906 = '1' THEN
      #      LET g_rvb[l_ac].rvb80=g_rvb[l_ac].rvb90       #No.FUN-940083 pmn07-->rvb90 
      #      LET g_rvb[l_ac].rvb82=g_rvb2.rvb07
      #   END IF
      #  #IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      #  #   LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90        #No.FUN-940083 pmn07-->rvb90 
      #  #   LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
      #  #END IF
      #   LET g_rvb2.rvb80 = g_rvb[l_ac].rvb80
      #   LET g_rvb2.rvb81 = g_rvb[l_ac].rvb81
      #   LET g_rvb2.rvb82 = g_rvb[l_ac].rvb82
      #   #No.MOD-6B0162 --begin
      #   SELECT SUM(rvb82),SUM(rvb85) INTO l_rvb82,l_rvb85 FROM rvb_file,rva_file
      #    WHERE rvb04 = g_rvb[l_ac].rvb04
      #      AND rvb03 = g_rvb[l_ac].rvb03
      #      AND rva01 = rvb01
      #      AND rvaconf = 'Y'
      #   IF NOT cl_null(l_rvb82) AND l_rvb82 > 0 THEN
      #      LET g_rvb2.rvb82 =g_rvb[l_ac].rvb82 - l_rvb82
      #      LET g_rvb[l_ac].rvb82 = g_rvb2.rvb82
      #   END IF
      #   #No.MOD-6B0162 --end
      #   LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
      #   LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
      #   LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85   #No.MOD-5A0297 Mark #TQC-5C0012 Unmark 應是筆誤,應要mark rvb87才對
      #   #No.MOD-6B0162 --begin
      #   IF NOT cl_null(l_rvb85) AND l_rvb85 > 0 THEN
      #      LET g_rvb2.rvb85 =g_rvb[l_ac].rvb85 - l_rvb85
      #      LET g_rvb[l_ac].rvb85 = g_rvb2.rvb85
      #   END IF
      #   #No.MOD-6B0162 --end
      #  #LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86   #No.MOD-5A0297 Mark
      #  #LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87   #No.TQC-5C0012 Mark
      #  #LET g_rvb2.rvb88 = l_pmn88             #No.TQC-6B0124 mark
      #  #LET g_rvb2.rvb88t= l_pmn88t            #No.TQC-6B0124 mark
      #END IF
      ##------------------No.TQC-6B0124 modify
      ##若收貨單自動產生單身時，即表示收貨單身的"計價單位"與
      ##"計價數量"是由採購單帶過來，故不應在去判斷是否使用
      ##計價單位，才來決定"計價單位"與"計價數量的值
      ##-----No.MOD-5A0297-----
      ##IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      ##   LET g_rvb[l_ac].rvb86=g_rvb[l_ac].pmn07
      ##   LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
      ##ELSE
      ##   LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
      ##   LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      ##END IF
      ###-----No.MOD-5A0297 END-----
      ##IF cl_null(g_rvb[l_ac].rvb86) THEN
      ##   LET g_rvb[l_ac].rvb86=g_rvb[l_ac].pmn07
      ##   LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
      ##   LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
      ##   LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      ##END IF
      #
      # LET g_rvb[l_ac].rvb07 = g_rvb2.rvb07        #No.TQC-6C0131 add
      # IF cl_null(g_rvb[l_ac].rvb86) THEN
      #    LET g_rvb[l_ac].rvb86=g_rvb[l_ac].rvb90  #No.FUN-940083 pmn07-->rvb90 
      #    LET g_rvb[l_ac].rvb87=g_rvb2.rvb07
      # END IF
      # LET g_rvb2.rvb86 = g_rvb[l_ac].rvb86
      # CALL t110_set_rvb87()     #No.MOD-6B0162
      # #-------No.CHI-820010 add
      #  IF g_sma.sma116 MATCHES '[02]' THEN
      #     LET g_rvb[l_ac].rvb87 = g_rvb2.rvb07
      #  END IF
      # #-------No.CHI-820010 end
      # #MOD-830171-begin-add
      # #若採購量=實收量, 其計價數量應直接帶入採購單資料
      #  IF g_sma.sma116 MATCHES '[13]' THEN
      #     IF NOT cl_null(l_rvb87_o) AND l_rvb87_o <> 0 THEN    #MOD-850298
      #        LET g_rvb[l_ac].rvb87 = l_rvb87_o
      #     END IF   #MOD-850298
      #  END IF
      # #MOD-830171-end-add
      # LET g_rvb2.rvb87 = g_rvb[l_ac].rvb87
      # LET g_rvb2.rvb88 = l_pmn88
      # LET g_rvb2.rvb88t= l_pmn88t
      ##------------------No.TQC-6B0124 end
      ##No.FUN-540027  --end
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
      #-----END MOD-970207-----
      LET g_rvb2.rvb09=0
      LET g_rvb2.rvb10=g_rvb[l_ac].rvb10
      LET g_rvb2.rvb10t=g_rvb[l_ac].rvb10t          #No.FUN-550117
      #-----MOD-970207---------
      LET g_rvb2.rvb88 =g_rvb2.rvb87 * g_rvb2.rvb10
      LET g_rvb2.rvb88t=g_rvb2.rvb87 * g_rvb2.rvb10t
      #-----END MOD-970207-----
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
     #LET g_rvb2.rvb31=g_rvb[l_ac].rvb07   #MOD-880166 mark
      LET g_rvb2.rvb31=0                   #MOD-880166
      LET g_rvb2.rvb32=0
      LET g_rvb2.rvb33=0
      #No.FUN-580115  --begin
      LET g_rvb2.rvb331=0
      LET g_rvb2.rvb332=0
      #No.FUN-580115  --end
      LET g_rvb2.rvb34=g_rvb[l_ac].rvb34
      LET g_rvb2.rvb35='N'
      LET g_rvb2.rvb40= ''  #no.7143
      LET g_rvb2.rvb930=g_rvb[l_ac].rvb930 #FUN-670051
      CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
      IF g_rvb2.rvb36 IS NULL THEN LET g_rvb2.rvb36=' ' END IF
      IF g_rvb2.rvb37 IS NULL THEN LET g_rvb2.rvb37=' ' END IF
      IF g_rvb2.rvb38 IS NULL THEN LET g_rvb2.rvb38=' ' END IF
      #NO.FUN-960130---BEGIN---
      LET g_rvb2.rvb44 = l_pmn.pmn75                                                                                   
      LET g_rvb2.rvb45 = l_pmn.pmn76 
      LET g_rvb2.rvbplant = g_rva.rvaplant                                                                                  
      LET g_rvb2.rvblegal = g_rva.rvalegal                                                                                  
      #NO.FUN-960130----END---
      #FUN-850022 --begin
       #CALL t110_get_rvb39(g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
       CALL t110_get_rvb39(g_rvb2.rvb03,g_rvb2.rvb04,g_rvb2.rvb05,g_rvb2.rvb19,g_rva.rva05,g_sma.sma886)   #MOD-860146
               RETURNING g_rvb2.rvb39 #MOD-530415
      #FUN-850022 --end
      BEGIN WORK
      LET g_success = 'Y'
      #-----MOD-910227---------
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
      #-----END MOD-910227-----
      LET g_rvb2.rvb90 = g_rvb[l_ac].rvb90    #NO.FUN-940083
      LET g_rvb2.rvb89 = g_rvb[l_ac].rvb89    #NO.FUN-940083
 
      LET g_rvb2.rvbplant = g_plant #NO.FUN-980006 jarlin add
      LET g_rvb2.rvblegal = g_legal #NO.FUN-980006 jarlin add
      INSERT INTO rvb_file VALUES(g_rvb2.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_rvb[l_ac].rvb02,SQLCA.sqlcode,1) #No.FUN-660129
         CALL cl_err3("ins","rvb_file",g_rvb2.rvb01,g_rvb2.rvb02,SQLCA.sqlcode,"","",1) #No.FUN-660129
         ROLLBACK WORK
         CONTINUE FOREACH
       #-----No.MOD-570411-----
      ELSE
 
&ifndef STD
         #No.FUN-7C0017 ...begin
         #INITIALIZE g_rvbi2.* TO NULL  #FUN-810038
         LET g_rvbi2.rvbi01 = g_rvb2.rvb01
         LET g_rvbi2.rvbi02 = g_rvb2.rvb02
 
&ifdef ICD
         #FUN-810038................begin
         LET g_rvbi2.rvbiicd04 = 'N'
         LET g_rvbi2.rvbiicd05 = 'N'
         LET g_rvbi2.rvbiicd09 = 'N' # 回貨否
              
         IF g_argv2 = 'SUB' THEN
            #回貨批號(rvb38),
            #以委外採購單號串工單帶出回貨批號= 回貨批號 (sfbiicd13), 
            #若選取不到, 顯示空白
            LET l_sfbiicd13 = ''
            SELECT sfbiicd13 INTO l_sfbiicd13 
              FROM sfbi_file
             WHERE sfbi01 = g_rvb2.rvb34   #工單單號
            IF cl_null(l_sfbiicd13) THEN
               LET l_sfbiicd13 = ' ' 
            END IF
            LET g_rvb2.rvb38 = l_sfbiicd13
            LET g_rvb[l_ac].rvb38 = l_sfbiicd13
          
            #若為委外收貨TKY,要將所對應之製程檔作業編號依序產生至收貨單身
            CALL t110_ind_icd_ecm()
            IF g_success = 'N' THEN
               ROLLBACK WORK 
               CONTINUE FOREACH
            END IF
         END IF
         #Tape Reel
         LET g_sql= "SELECT DISTINCT rvbiicd11 FROM rvb_file,rvbi_file",
                    " WHERE rvb01=rvbi01 AND rvb02=rvbi02 ",
                    "   AND rvb05=? AND rvb36=? AND rvb37=? AND rvb38=? "
         DECLARE icd_g_b_c CURSOR FROM g_sql
         OPEN icd_g_b_c USING g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                              g_rvb2.rvb38
         FETCH icd_g_b_c INTO g_rvbi2.rvbiicd11
         CLOSE icd_g_b_c
         
         LET g_rvbi2.rvbiicd13 = 'N' #N:非委外TKY/委外TKY,最後一站
          
         IF cl_null(g_rvbi2.rvbiicd04) THEN
            LET g_rvbi2.rvbiicd04 = 'N'
         END IF
         IF cl_null(g_rvbi2.rvbiicd10) THEN
            LET g_rvbi2.rvbiicd10 = 'N'
         END IF
            
         IF cl_null(g_rvbi2.rvbiicd05) THEN  #boblee 070101 若無值預設為'N'
            LET g_rvbi2.rvbiicd05 = 'N'
         END IF
         IF cl_null(g_rvbi2.rvbiicd08) THEN
            LET g_rvbi2.rvbiicd08 = ' '
         END IF
         IF cl_null(g_rvbi2.rvbiicd10) THEN
            LET g_rvbi2.rvbiicd10 = 'N'
         END IF
         IF cl_null(g_rvbi2.rvbiicd04) THEN
            LET g_rvbi2.rvbiicd04 = 'N'
         END IF
         #FUN-810038................end
&endif
         #No.FUN-7B0018 080306 modify --begin
         IF NOT s_ins_rvbi(g_rvbi2.*,'') THEN
            ROLLBACK WORK
            CONTINUE FOREACH
         END IF
#        INSERT INTO rvbi_file VALUES(g_rvbi2.*)
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","rvbi_file",g_rvbi2.rvbi01,g_rvbi2.rvbi02,SQLCA.sqlcode,"","",1)
#           ROLLBACK WORK
#           CONTINUE FOREACH
#        END IF
         #No.FUN-7C0017 ...end
         #No.FUN-7B0018 080306 modify --end
&endif
        SELECT COUNT(*) INTO l_n FROM img_file
          WHERE img01 = g_rvb2.rvb05
            AND img02 = g_rvb2.rvb36
            AND img03 = g_rvb2.rvb37
            AND img04 = g_rvb2.rvb38
         IF l_n = 0 AND (g_rvb[l_ac].rvb36 IS NOT NULL
                         #AND g_rvb[l_ac].rvb36 <> ' ') THEN    #MOD-910227
                         AND g_rvb[l_ac].rvb36 <> ' ') AND l_ec_sw = 'N' THEN    #MOD-910227
            #-----MOD-910226---------
            #LET l_msg ="(",g_rvb2.rvb05 CLIPPED,"-",
            #               g_rvb2.rvb36 CLIPPED,'-',
            #               g_rvb2.rvb37 CLIPPED,'-',
            #               g_rvb2.rvb38 CLIPPED,")"
            #IF cl_confirm2('mfg1401',l_msg) THEN
            IF g_sma.sma892[3,3] ='Y' THEN
               IF cl_confirm('mfg1401') THEN
            #-----EMD MOD-910226-----
                  CALL s_add_img(g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                                 g_rvb2.rvb38,g_rva.rva01,g_rvb2.rvb02,
                                 g_rva.rva06)
            #-----MOD-910226---------
               END IF
            ELSE
               CALL s_add_img(g_rvb2.rvb05,g_rvb2.rvb36,g_rvb2.rvb37,
                              g_rvb2.rvb38,g_rva.rva01,g_rvb2.rvb02,
                              g_rva.rva06)
            END IF
            #END IF
            #-----END MOD-910226-----
         END IF
       #-----No.MOD-570411 END-----
      END IF
 
&ifdef ICD
      #FUN-810038................begin
         IF g_argv2 = 'SUB' THEN
            CALL t110_ind_icd_trans_chk('a')
         END IF
      #FUN-810038................end
&endif
 
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
 
   CALL g_rvb.deleteElement(l_ac)
   LET l_ac=l_ac - 1
 
   CALL t110_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t110_b_more()
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
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
      l_rvb25  LIKE rvb_file.rvb25,           #No.MOD-4B0275
      l_alt06,t_alt06 LIKE alt_file.alt06,    #MOD-680004 add
      l_msg    LIKE type_file.chr50,          #No.FUN-680136 VARCHAR(40)
      l_sw,l_sw1  LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
      #No.FUN-540027  --begin
      l_rvb80  LIKE rvb_file.rvb80,
      l_rvb81  LIKE rvb_file.rvb81,
      l_rvb82  LIKE rvb_file.rvb82,
      l_rvb83  LIKE rvb_file.rvb83,
      l_rvb84  LIKE rvb_file.rvb84,
      l_rvb85  LIKE rvb_file.rvb85,
      l_rvb86  LIKE rvb_file.rvb86,
      l_rvb87  LIKE rvb_file.rvb87,
      #No.FUN-810016---Begin
      l_ima150 LIKE ima_file.ima150,
      l_ima151 LIKE ima_file.ima151
#     l_ima37  LIKE ima_file.ima37           #No.FUN-840178
      #No.FUN-810016---End      
      #No.FUN-540027  --end
   DEFINE l_pmm02 LIKE pmm_file.pmm02  #FUN-810038
   DEFINE l_type    LIKE type_file.chr1     #MOD-860146
   DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
   DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
   DEFINE l_rvb85e  LIKE rvb_file.rvb85     #No.MOD-890236 
   DEFINE l_rvb82e  LIKE rvb_file.rvb82     #No.MOD-890236
   DEFINE l_pmn18   LIKE pmn_file.pmn18     #CHI-8C0017 
   DEFINE l_rtz07   LIKE rtz_file.rtz07     #NO.FUN-960130
   DEFINE l_rtz08   LIKE rtz_file.rtz08     #NO.FUN-960130
 
   LET g_errno = " "
   #No.FUN-540027  --begin
#  SELECT pmn04,pmn07,pmn20,(pmn50-pmn55),pmn041,pmn16,pmn13,pmn011,           #FUN-9A0068 mark
   SELECT pmn04,pmn07,pmn20,(pmn50-pmn55-pmn58),pmn041,pmn16,pmn13,pmn011,     #FUN-9A0068
          pmn14,pmn15,pmn34,pmn37,pmn44,pmn09,pmn31,pmn31t,pmm42,pmn41,                 #No.FUN-550117
#         pmn20-pmn50+pmn55,pmn63,pmn52,pmn54,pmn56,pmn122,pmn71,pmn65,        #No.9893 #No.FUN-940083
          pmn20-pmn50+pmn55+pmn58,pmn63,pmn52,pmn54,pmn56,pmn122,pmn71,pmn65,  #No.9893 #No.FUN-940083
          pmn80,pmn81,pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmm21,pmm43,pmm22,gec07,   #No.FUN-550017  FUN-610018
          pmn930  #FUN-670051
     INTO g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_rvb[l_ac].pmn20,                        #No.FUN-940083 pmn07-->rvb90 
          g_rvb[l_ac].pmn50_55,g_rvb[l_ac].rvb051,l_pmn16,g_pmn13,l_pmn011,             #FUN-940083 pmn041-->rvb051
          g_pmn14,l_pmn15,l_pmn34,l_pmn37,g_pmn44,g_pmn09,g_pmn31,g_pmn31t,g_pmm42,     #No.FUN-550117
          g_rvb[l_ac].rvb34,l_rvb07,l_pmn63,l_pmn52,l_pmn54,l_pmn56,l_pmn122,
           l_rvb25,g_rvb2.rvb19,  #No:8114        #No.MOD-4B0275
          l_rvb80,l_rvb81,l_rvb82,l_rvb83,l_rvb84,l_rvb85,l_rvb86,l_rvb87,
          g_rvb[l_ac].pmm21,g_rvb[l_ac].pmm43,l_pmm22,g_gec07,  #No.FUN-550117
          g_rvb[l_ac].rvb930  #FUN-670051
      FROM pmn_file,pmm_file,OUTER gec_file    #No.FUN-550117
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
         #No.FUN-540027  --begin
         LET g_rvb[l_ac].rvb83 = NULL
         LET g_rvb[l_ac].rvb84 = NULL
         LET g_rvb[l_ac].rvb85 = NULL
         LET g_rvb[l_ac].rvb80 = NULL
         LET g_rvb[l_ac].rvb81 = NULL
         LET g_rvb[l_ac].rvb82 = NULL
         LET g_rvb[l_ac].rvb86 = NULL
         LET g_rvb[l_ac].rvb87 = NULL
         #No.FUN-540027  --end
      WHEN l_pmn16 != '2'
         LET g_errno = 'mfg3166'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
&ifdef ICD
    #FUN-810038................begin
       SELECT pmniicd04,pmniicd05,pmniicd11,pmniicd06,   #CHI-920064 remove pmniicd03
              pmniicd12,pmniicd14,pmniicd15,pmniicd16
         INTO g_rvbi2.rvbiicd04,   #CHI-920064 remove rvbiicd03
              g_rvbi2.rvbiicd05,g_rvb[l_ac].rvbiicd08,
              g_rvb[l_ac].rvbiicd10,g_rvb[l_ac].rvbiicd12,
              g_rvb[l_ac].rvbiicd14,g_rvb[l_ac].rvbiicd15,
              g_rvb[l_ac].rvbiicd16
         FROM pmni_file
        WHERE pmni01 = p_po 
          AND pmni02 = p_item
       LET l_pmm02=''
       SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01 = p_po
       CASE 
          WHEN SQLCA.sqlcode <>0 
             LET g_errno=SQLCA.sqlcode
          WHEN g_argv2='ICD' AND l_pmm02<>g_rva.rva10
             LET g_errno='aic-117'
       END CASE
    #FUN-810038................end
&endif
 
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
 
    LET g_rvb2.rvb08 = 0   #MOD-9A0098
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
       #FUN-810038................begin
          LET l_rvb07s=0
          SELECT SUM(rvb07) INTO l_rvb07s FROM rva_file,rvb_file   #未確認也計入
           WHERE rva01=rvb01 AND rvb04=g_rvb[l_ac].rvb04
             AND rvb03=g_rvb[l_ac].rvb03 AND rvaconf='N' AND rvb35='N'
           # AND rva01 != g_rva.rva01   #No.TQC-5B0070
          IF cl_null(l_rvb07s) THEN LET l_rvb07s=0 END IF
          LET g_rvb[l_ac].rvb07=l_rvb07-l_rvb07s
       #FUN-810038................end
       LET g_rvb[l_ac].rvb25 = l_rvb25        #No.MOD-4B0275
      #MOD-680004-begin-add
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
      #MOD-680004-end-add
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
&ifdef ICD
       #FUN-810038................begin
          #以委外採購單號串工單帶出回貨批號= 回貨批號
          #若選取不到, 顯示空白,可輸入
          SELECT sfbiicd13 INTO g_rvb[l_ac].rvb38
            FROM sfbi_file
           WHERE sfbi01 = g_rvb[l_ac].rvb34
          IF cl_null(g_rvb[l_ac].rvb38) THEN
             LET g_rvb[l_ac].rvb38=' '
          END IF
       #FUN-810038................end
&endif
    END IF
    IF l_ec_sw='N' THEN
       IF cl_null(g_rvb[l_ac].rvb36) THEN LET g_rvb[l_ac].rvb36=l_pmn52 END IF
       IF cl_null(g_rvb[l_ac].rvb37) THEN LET g_rvb[l_ac].rvb37=l_pmn54 END IF
    END IF
 
  #FUN-810045 remark begin
    #IF NOT cl_null(l_pmn122) THEN
    #   LET g_rvb[l_ac].rvb38=l_pmn122  #for專案代號->批號欄位
    #ELSE
    #   IF cl_null(g_rvb[l_ac].rvb38) AND l_ec_sw='N' THEN   #No.B454
    #      LET g_rvb[l_ac].rvb38=l_pmn56
    #   END IF
    #END IF
    IF cl_null(g_rvb[l_ac].rvb38) AND l_ec_sw='N' THEN   #No.B454
       LET g_rvb[l_ac].rvb38=l_pmn56
    END IF
  #FUN-810045 remark end
    IF cl_null(g_rvb[l_ac].rvb36) THEN
       #SELECT pmm22 INTO l_pmm22 FROM pmm_file   #MOD-860146
       SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
        WHERE pmm01=g_rvb[l_ac].rvb04
       
         #CHI-8C0017--Begin--# 
#        #-----MOD-860146---------
#        IF l_pmm02 = 'SUB' THEN
#           LET l_type = '2' 
#        ELSE
#           LET l_type = '1' 
#        END IF
#        SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
#          WHERE pmn01 = g_rvb[l_ac].rvb04 
#            AND pmn02 = g_rvb[l_ac].rvb03
#        IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
#           LET l_ecm04 = " "
#        ELSE
#           SELECT ecm04 INTO l_ecm04 FROM ecm_file
#            WHERE ecm01 = l_pmn41
#              AND ecm03 = l_pmn43
#        END IF
#        #-----END MOD-860146-----
        SELECT pmn41,pmn43,pmn18 INTO l_pmn41,l_pmn43,l_pmn18 FROM pmn_file
         WHERE pmn01 = g_rvb[l_ac].rvb04 AND pmn02 = g_rvb[l_ac].rvb03          
        IF l_pmm02='SUB' THEN
           LET l_type='2'
           #-----MOD-910172---------
           IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
           #-----END MOD-910172----- 
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
              END IF
           END IF   #MOD-910172
        ELSE
           LET l_type='1'
           LET l_ecm04=' '
        END IF
        #CHI-8C0017--End--#       
       
       SELECT pmh08 INTO l_pmh08 FROM pmh_file
        WHERE pmh01=g_rvb[l_ac].rvb05 AND pmh02=g_rva.rva05
          AND pmh13=l_pmm22
          AND pmh21= l_ecm04   #MOD-860146
          AND pmh22= l_type    #MOD-860146
          AND pmh23 = ' '      #No.CHI-960033 
          AND pmhacti = 'Y'                                           #CHI-910021
       IF status THEN LET l_pmh08='N' END IF
      #IF l_pmh08='Y' AND g_rvb[l_ac].rvb05[1,4] !='MISC' AND l_ec_sw='N' THEN
        IF g_rvb[l_ac].rvb05[1,4] !='MISC' AND l_ec_sw='N' THEN   #No.MOD-580087
          SELECT ima35,ima36 INTO g_rvb[l_ac].rvb36,g_rvb[l_ac].rvb37
            FROM ima_file
           WHERE ima01=g_rvb[l_ac].rvb05
          #NO.FUN-960130----START------
          IF g_azw.azw04='2' THEN  
             #FUN-C90049 mark begin---
             #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file 
             #   WHERE rtz01 = g_rva.rvaplant 
             #FUN-C90049 mark end-----
             CALL s_get_defstore(g_rva.rvaplant,g_rvb[l_ac].rvb05) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
             IF g_rva.rva29 = '1' THEN 
                LET g_rvb[l_ac].rvb36 = l_rtz07 
             ELSE
                LET g_rvb[l_ac].rvb36 = l_rtz08
             END IF
          END IF
          #NO.FUN-960130----END---
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
    
    LET g_rvb[l_ac].rvb05a = g_rvb[l_ac].rvb05      #FUN-810016
    LET g_rvb[l_ac].rvb05b = g_rvb[l_ac].rvb051     #FUN-810016 #FUN-940083 pmn041-->rvb051
    LET g_rvb[l_ac].rvb05c = g_rvb[l_ac].ima021     #FUN-810016 
     
     #------MOD-5A0095 START----------
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
     #------MOD-5A0095 END------------
     #FUN-670051...............begin
     CALL t110_set_rvb930(g_rvb[l_ac].rvb930) RETURNING g_rvb[l_ac].gem02a #FUN-670051
     LET g_rvb2.rvb930=g_rvb[l_ac].rvb930
     DISPLAY BY NAME g_rvb[l_ac].rvb930,g_rvb[l_ac].gem02a
     #FUN-670051...............end
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
 
  #------------No.TQC-6B0124 modify
   #IF g_sma.sma115 = 'Y' THEN
   #   IF p_cmd = 'a' OR g_rvb_t.rvb05 IS NULL OR
   #      g_rvb_t.rvb05 <> g_rvb[l_ac].rvb05 THEN
   #      LET g_rvb[l_ac].rvb80 = l_rvb80
   #      LET g_rvb[l_ac].rvb81 = l_rvb81
   #      LET g_rvb[l_ac].rvb82 = l_rvb82
   #      LET g_rvb[l_ac].rvb83 = l_rvb83
   #      LET g_rvb[l_ac].rvb84 = l_rvb84
   #      LET g_rvb[l_ac].rvb85 = l_rvb85
   #      LET g_rvb[l_ac].rvb86 = l_rvb86
   #      LET g_rvb[l_ac].rvb87 = l_rvb87
   #      IF l_rvb07s <> 0 THEN
   #         LET g_rvb[l_ac].rvb82=0
   #         LET g_rvb[l_ac].rvb85=0
   #         LET g_rvb[l_ac].rvb87=0
   #      END IF
   #   END IF
   #END IF
 
    IF p_cmd = 'a' OR g_rvb_t.rvb05 IS NULL OR
       g_rvb_t.rvb05 <> g_rvb[l_ac].rvb05 THEN
       LET g_rvb[l_ac].rvb30 = 0  #No.MOD-890236 
       LET g_rvb[l_ac].rvb29 = 0  #No.MOD-890236  
       IF g_sma.sma115 = 'Y' THEN
         #No.MOD-890236--begin--
          LET l_rvb82e = 0
          LET l_rvb85e = 0 
          SELECT SUM(rvb82),SUM(rvb85) INTO l_rvb82e,l_rvb85e FROM rvb_file,rva_file
           WHERE rvb04 = g_rvb[l_ac].rvb04
             AND rvb03 = g_rvb[l_ac].rvb03
             AND rva01 = rvb01
             #AND rvaconf = 'Y'   #MOD-970207
             AND rvaconf <> 'X'   #MOD-970207
             AND rvb35 = 'N'      #MOD-970207
          IF cl_null(l_rvb82e) THEN LET l_rvb82e =  0 END IF
          IF cl_null(l_rvb85e) THEN LET l_rvb85e =  0 END IF
         #No.MOD-890236---end---
          LET g_rvb[l_ac].rvb80 = l_rvb80
          LET g_rvb[l_ac].rvb81 = l_rvb81
          LET g_rvb[l_ac].rvb82 = l_rvb82 - l_rvb82e  #No.MOD-890236 add - l_rvb82e
          LET g_rvb[l_ac].rvb83 = l_rvb83
          LET g_rvb[l_ac].rvb84 = l_rvb84
          LET g_rvb[l_ac].rvb85 = l_rvb85 - l_rvb85e  #No.MOD-890236 add - l_rvb85e
          #-----MOD-970207---------
          #IF l_rvb07s <> 0 THEN
          #   LET g_rvb[l_ac].rvb82=0
          #   LET g_rvb[l_ac].rvb85=0
          #END IF
          #-----END MOD-970207----- 
       END IF
       LET g_rvb[l_ac].rvb86 = l_rvb86
       LET g_rvb[l_ac].rvb87 = l_rvb87
       #-----MOD-970207---------
       CALL t110_set_rvb87()
       #IF l_rvb07s <> 0 THEN
       #   LET g_rvb[l_ac].rvb87=0
       #END IF
       #-----END MOD-970207----- 
      #END IF   #TQC-770117 mark
      #TQC-770117-begin-mark
      # IF g_sma.sma116 MATCHES '[02]' THEN
      #    LET g_rvb[l_ac].rvb86 = NULL
      #    LET g_rvb[l_ac].rvb87 = 0
      # ELSE
      #TQC-770117-end-mark
          #-----MOD-970207---------
          #重複程式段,所以mark
          #LET g_rvb[l_ac].rvb86 = l_rvb86
          #LET g_rvb[l_ac].rvb87 = l_rvb87
          #IF l_rvb07s <> 0 THEN
          #   LET g_rvb[l_ac].rvb87=0
          #END IF
          #-----END MOD-970207-----
      #END IF   #TQC-770117 mark
    END IF
  #------------No.TQC-6B0124 end
 
    #No.FUN-540027  --end
 
&ifdef ICD
    #FUN-810038................begin
       LET g_rvb[l_ac].rvb07=l_rvb07
       IF p_cmd = 'a' OR p_cmd = 'u' THEN
          #計用未收貨的數量rvb07,rvb82,rvb85,rvb87
          CALL t110_ind_icd_def_qty()  
       END IF
    DISPLAY BY NAME g_rvb[l_ac].rvbiicd03,g_rvb[l_ac].rvbiicd08,
                    g_rvb[l_ac].rvbiicd10,g_rvb[l_ac].rvbiicd12,
                    g_rvb[l_ac].rvbiicd14,g_rvb[l_ac].rvbiicd15,
                    g_rvb[l_ac].rvbiicd16
    #FUN-810038................end
&endif
 
    #No.FUN-550117
#No.FUN-610018
#   IF g_rvb[l_ac].gec07 = 'Y' THEN                 #No.FUN-560102
#      CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",TRUE)
#   ELSE
#      CALL cl_set_comp_visible("rvb10t,pmm21,pmm43,gec07",FALSE)
#   END IF
 
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmm22   #No.CHI-6A0004
    #end No.FUN-550117
    
    #No.FUN-810016 --begin--
    SELECT ima150,ima151 INTO l_ima150,l_ima151 FROM ima_file
     WHERE ima_file.ima01=g_rvb[l_ac].rvb05
     IF l_ima150!='0' OR  l_ima151='Y' THEN
       CALL cl_set_comp_entry('rvb05',TRUE)
     ELSE
     	 CALL cl_set_comp_entry('rvb05',FALSE)
     END IF 
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
       #   END IF                                   #No.FUN-840178--mark--
       END IF       
    #No.FUN-810016 --end--    
    
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
   DEFINE l_ima021        LIKE ima_file.ima021   #No.FUN-810016
   DEFINE l_ima02         LIKE ima_file.ima02    #No.FUN-840178
   DEFINE l_pmn07         LIKE pmn_file.pmn07    #No.FUN-940083
   
&ifndef STD
#     IF g_argv6='1' THEN                                                               #FUN-940083
      #No.FUN-7C0017 ...begin
      #No.FUN-540027  --begin
         LET g_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,rvbiicd03,rvb05,",
                     " '','','','','','','','','','','','','','','','','','','','','',",   #TQC-650108
                     " pmn041,ima021,pmn04,'','',rvbiicd14,rvbiicd11,", #MOD-840156                   
                    #" '','',pmn04,pmn041,ima021,rvbiicd14,rvbiicd11,", #No.FUN-810016  #MOD-840156 mark
#                    " pmn07,pmn20,(pmn50-pmn55),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083
#                    " rvb90,rvb42,rvb43,rvb4,rvb45,pmn20,(pmn50-pmn55),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083  #NO.FUN-960130  #FUN-9A0068 mark
                    #" rvb90,rvb42,rvb43,rvb4,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083  #NO.FUN-960130 #FUN-9A0068 #CHI-98O024 mark
                     " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,rvb29,rvb89,rvb35,rvbiicd06,rvbiicd07,rvb07, ", #FUN-810038  #FUN-940083  #NO.FUN-960130 #FUN-9A0068 #CHI-980024 mod
                     " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",
                     " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,rvb930,'',rvb93, ",     #No.FUN-550117  FUN-610018 #FUN-670051 #FUN-9A0065 add rvb93
                     " rvbiicd08,rvbiicd10,rvbiicd12,rvbiicd15,rvbiicd16 ",
                     #No.FUN-840042 --start--
                     " ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05, ",
                     "rvbud06,rvbud07,rvbud08,rvbud09,rvbud10, ",
                     "rvbud11,rvbud12,rvbud13,rvbud14,rvbud15 ", 
                     #No.FUN-840042 ---end---
                     " FROM rvb_file,OUTER pmn_file,OUTER ima_file,OUTER pmm_file,OUTER rvbi_file" ,
                     " WHERE rvb01 ='",g_rva.rva01,"' ",
                     "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
                     "   AND rvb_file.rvb05=ima_file.ima01 AND ",p_wc2 CLIPPED,   #MOD-940245取消mark
                     #"   AND pmn04 = ima01 AND ",p_wc2 CLIPPED,     #No.MOD-920003   #MOD-940127
                     #"   AND pmn04 = ima_file.ima01 AND ",p_wc2 CLIPPED,     #No.MOD-920003   #MOD-940127   #MOD-940245
                     "   AND rvb_file.rvb04 = pmm_file.pmm01 ",            #No.FUN-550117
                     "   AND rvb_file.rvb01 =rvbi_file.rvbi01 ",
                     "   AND rvb_file.rvb02 =rvbi_file.rvbi02 ",
                     " ORDER BY rvb02"   #No.MOD-5A0448
&else
         LET g_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,'',rvb05,",
                     " '','','','','','','','','','','','','','','','','','','','','',",
                    #" '','',pmn04,pmn041,ima021,'','',",        #No.FUN-810016  #MOD-840156 mark
                     " pmn041,ima021,pmn04,'','','','',",        #MOD-840156 
#                    " pmn07,pmn20,(pmn50-pmn55),rvb30,rvb29,rvb89,rvb35,'','',rvb07, ", #FUN-810038 #FUN-940083
#                    " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55),rvb30,rvb29,rvb89,rvb35,'','',rvb07, ", #FUN-810038 #FUN-940083  #NO.FUN-960130  #FUN-9A0068 mark
                     " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,rvb29,rvb89,rvb35,'','',rvb07, ", #FUN-810038 #FUN-940083  #NO.FUN-960130  #FUN-9A0068 
                     " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",
                     " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,rvb930,'',rvb93  ,", #FUN-9A0065 add rvb93
                     " '','','','','' ",
                     #No.FUN-840042 --start--
                     " ,rvbud01,rvbud02,rvbud03,rvbud04,rvbud05, ",
                     "rvbud06,rvbud07,rvbud08,rvbud09,rvbud10, ",
                     "rvbud11,rvbud12,rvbud13,rvbud14,rvbud15 ", 
                     #No.FUN-840042 ---end---
                     " FROM rvb_file,OUTER pmn_file,OUTER ima_file,OUTER pmm_file" ,
                     " WHERE rvb01 ='",g_rva.rva01,"' ",
                     "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
                     "   AND rvb_file.rvb05=ima_file.ima01 AND ",p_wc2 CLIPPED,   #MOD-940245取消mark
                     #"   AND pmn04 = ima01 AND ",p_wc2 CLIPPED,     #No.MOD-920003   #MOD-940127
                     #"   AND pmn04 = ima_file.ima01 AND ",p_wc2 CLIPPED,     #No.MOD-920003   #MOD-940127   #MOD-940245
                     "   AND rvb_file.rvb04 = pmm_file.pmm01 ",
                     " ORDER BY rvb02"
      #No.FUN-540027  --end
      #No.FUN-7C0017 ...end
&endif
#genero mark
#  IF g_argv2 = 'SUB' THEN
#     LET g_sql = g_sql CLIPPED," AND rvb19 = '2'"," ORDER BY 1"
#  ELSE
#     LET g_sql = g_sql CLIPPED," AND rvb19 = '1'"," ORDER BY 1"
#  END IF
   #NO.FUN-960130-----------BEGIN----------
   IF g_azw.azw04='2' THEN
      LET g_sql = "SELECT rvb02,rvb22,rvb04,rvb03,rvb34,'',rvb05,",
                  " '','','','','','','','','','','','','','','','','','','','','',",
                  " rvb051,ima021,'','','','','',",
#                 " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55),rvb30,",       #FUN-9A0068 mark
                  " rvb90,rvb42,rvb43,rvb44,rvb45,pmn20,(pmn50-pmn55-pmn58),rvb30,", #FUN-9A0068    
                  " rvb29,rvb89,rvb35,'','',rvb07,", 
                  " rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",                                                      
                  " rvb36,rvb37,rvb38,rvb10,rvb10t,rvb25,pmm21,pmm43,rvb930,'',rvb93  ,", #FUN-9A0065 add rvb93                                         
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
   #NO.FUN-960130----END----
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
      #TQC-650108
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      # No.FUN-810016--begin
      IF  g_rvb[g_cnt].rvb05a= g_rvb[g_cnt].rvb05 THEN  #No.MOD-920003
        LET g_rvb[g_cnt].rvb05b=g_rvb[g_cnt].rvb051     #FUN-940083 pmn041-->rvb051
        LET g_rvb[g_cnt].rvb05c=g_rvb[g_cnt].ima021 
      ELSE   
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file     #MOD-840221 modify ima02  
#          WHERE ima01=g_rvb[g_cnt].rvb05a
#       LET g_rvb[g_cnt].rvb05b=l_ima02    
#       LET g_rvb[g_cnt].rvb05c=l_ima021 
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file     #MOD-840221 modify ima02  #No.MOD-920003
          WHERE ima01=g_rvb[g_cnt].rvb05           #No.MOD-920003
        LET g_rvb[g_cnt].rvb05b=g_rvb[g_cnt].rvb051 #No.MOD-920003 #FUN-940083 pmn041-->rvb051 
        LET g_rvb[g_cnt].rvb05c=g_rvb[g_cnt].ima021 #No.MOD-920003  
        LET g_rvb[g_cnt].rvb051 = l_ima02           #No.MOD-920003 #FUN-940083 pmn041-->rvb051 
        LET g_rvb[g_cnt].ima021 = l_ima021          #No.MOD-920003
      # No.FUN-810016 --end-- 
      END IF                        #No.MOD-920003
#FUN-940083--begin        
      IF g_argv6='1' THEN
         SELECT pmn07 INTO l_pmn07 FROM pmn_file WHERE pmn04 =  g_rvb[g_cnt].rvb05
         LET g_rvb[g_cnt].rvb90 = l_pmn07
      END IF
#FUN-940083--end        
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
      #TQC-650108 --end
      #No.MOD-490173 mark
     #IF NOT cl_chk_act_auth() THEN LET g_rvb[g_cnt].rvb10=NULL END IF
      #No.FUN-540027  --begin
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
       #No.FUN-540027  --end
      CALL t110_set_rvb930(g_rvb[g_cnt].rvb930) RETURNING g_rvb[g_cnt].gem02a #FUN-670051
#No.FUN-610018      #No.FUN-550117
#     IF NOT cl_null(g_rvb[g_cnt].pmm21) THEN      #No.FUN-560102
#        SELECT gec07 INTO g_rvb[g_cnt].gec07 FROM gec_file
#         WHERE gec01 = g_rvb[g_cnt].pmm21
#        IF g_rvb[g_cnt].gec07 = 'Y' THEN LET g_gec07 = 'Y' END IF
#     END IF
      #end No.FUN-550117
&ifdef ICD
      #FUN-810038................begin
         #委外tky非最終站之收貨數量單獨計算
         IF g_rvbi2.rvbiicd13 = 'Y' THEN
            SELECT SUM(rvb07) INTO g_rvb[g_cnt].pmn50_55
               FROM rvb_file,rva_file,rvbi_file
              WHERE rvb04=g_rvb[g_cnt].rvb04
                AND rvb03=g_rvb[g_cnt].rvb03
                AND rvb01=rvbi01
                AND rvb02=rvbi02
                AND rvaconf='Y'
                AND rva01=rvb01
                AND rvb35='N'
                #只計算委外tky非最終站的收貨數量
                AND rvbiicd13='Y'
                AND rvbiicd03= g_rvb[g_cnt].rvbiicd03
            IF cl_null(g_rvb[g_cnt].pmn50_55) THEN
               LET g_rvb[g_cnt].pmn50_55 = 0
            END IF
         END IF
      #FUN-810038................end
&endif
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_rvb.deleteElement(g_cnt)
 
   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
   
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
   CALL t110_refresh_detail()   #TQC-650108
 
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   #FUN-680011---start---
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("rvaspc",FALSE)
   END IF
   #FUN-680011---end---
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t110_mu_ui()   #TQC-710032
         #No.FUN-6C0055 --start--
         IF g_aza.aza71 MATCHES '[Yy]' THEN
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF
         #No.FUN-6C0055 --end--
         #CKP
         IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
#@    ON ACTION 產生入庫/驗退
      ON ACTION generate_st_in_qc_return
         LET g_action_choice="generate_st_in_qc_return"
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
 
&ifdef ICD
      #ICD begin
      #FUN-810038................begin
#@    ON ACTION 回貨查詢作業                                                    
      ON ACTION aic_qry_back
         LET g_action_choice = "aic_qry_back"
         EXIT DISPLAY
 
#@    ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DISPLAY
 
#@    ON ACTION 刻號BIN維護作業
      ON ACTION aic_s_icdin
         LET g_action_choice = "aic_s_icdin"
         EXIT DISPLAY
 
#@    ON ACTION 刻號BIN入庫否維護作業
      ON ACTION aic_s_icdin_rec
         LET g_action_choice = "aic_s_icdin_rec"
         EXIT DISPLAY
      #FUN-810038................end
      #ICD end
&endif
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680011
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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

#FUN-9A0065---begin
      ON ACTION e_proc_require
         LET g_action_choice = 'e_proc_require'
         EXIT DISPLAY
#FUN-9A0065---end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      #No.FUN-6C0055 --start--
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
 
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
      #No.FUN-6C0055 --end--
 
      #-----No.FUN-810036-----
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
      #-----No.FUN-810036 END-----
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t110_log(p_stdc,p_reason,p_rvb,
                  p_pmn011,p_pmn40,p_ima86,p_pmn122)             #FUN-940083 
#                 p_pmn011,p_pmn07,p_pmn40,p_ima86,p_pmn122)     #FUN-940083
   DEFINE
      p_stdc          LIKE type_file.num5,        #No.FUN-680136 SMALLINT #是否需取得標準成本
      p_reason        LIKE type_file.num5,        #No.FUN-680136 SMALLINT #是否需取得異動原因
      p_code          LIKE type_file.chr4,        #No.FUN-680136 VARCHAR(04)
      p_qty           LIKE img_file.img10,        #No.FUN-680136 DECIMAL(13,3) #異動數量
      p_rvb           RECORD LIKE rvb_file.*,
      p_pmn011        LIKE pmn_file.pmn011,
      p_pmn40         LIKE pmn_file.pmn40,        #會計科目
#     p_pmn07         LIKE pmn_file.pmn07,        #FUN-940083--mark
      p_ima86         LIKE ima_file.ima86,        #成本單位
      p_pmn122        LIKE pmn_file.pmn122,       #專案號碼
      p_ac,l_sta      LIKE type_file.num5,        #No.FUN-680136 SMALLINT
      x_sfb24         LIKE sfb_file.sfb24,        #MOD-790007 add
      l_pmn65         LIKE pmn_file.pmn65         #No:7692
  #----------------No.TQC-750014 add
   DEFINE
        l_img09       LIKE img_file.img01,
        l_pmn09       LIKE pmn_file.pmn09,
        l_cnt         LIKE type_file.num5
  #----------------No.TQC-750014 end
 
  IF g_argv6='1' THEN                            #FUN-940083--add
     IF cl_null(g_pmn09) OR g_pmn09 = 0 THEN
        LET g_pmn09 = 1
     END IF
  END IF                                         #FUN-940083--add
  #----------------No.TQC-750014 add
  #MOD-790007-begin-add
   LET l_ec_sw = 'N'
   IF g_argv2 ='SUB' THEN
      LET x_sfb24=''
      SELECT sfb24 INTO x_sfb24
        FROM sfb_file
       WHERE sfb01 = p_rvb.rvb34
      IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
         LET l_ec_sw='Y'
      END IF
   END IF
#FUN-940083-mark-begin
##CHI-7A0003-modify
## IF NOT cl_null(p_rvb.rvb36)  AND l_ec_sw='N' AND g_sma.sma886[7,7] = 'Y' THEN
#  IF NOT cl_null(p_rvb.rvb36)  AND l_ec_sw='N' THEN
##CHI-7A0003-modify-end
#  #MOD-790007-end-add
 
#   SELECT img09 INTO l_img09 FROM img_file
#         WHERE img01 = p_rvb.rvb05 AND img02 = p_rvb.rvb36
#           AND img03 = p_rvb.rvb37 AND img04 = p_rvb.rvb38
 
#   CALL s_umfchk(p_rvb.rvb05,p_pmn07,l_img09)
#             RETURNING l_cnt,l_pmn09
#   IF l_cnt = 1 THEN
#      CALL cl_err(p_rvb.rvb05,'mfg3075',1)
#      LET l_pmn09 = g_pmn09
#   END IF
# END IF  #MOD-790007 add
#FUN-940083-mark-end
 
  #----------------No.TQC-750014 end
   LET g_tlf.tlf01=p_rvb.rvb05          #異動料件編號
#  CASE p_pmn011                        #FUN-940083
   CASE g_rva.rva10                     #FUN-940083
      WHEN 'REG ' LET g_tlf.tlf02=11    #資料來源
      WHEN 'EXP ' LET g_tlf.tlf02=14
      WHEN 'CAP ' LET g_tlf.tlf02=16
      WHEN 'SUB '
           #No:7692
           SELECT pmn65 INTO l_pmn65
             FROM pmn_file
            WHERE pmn01 = p_rvb.rvb04
              AND pmn02 = p_rvb.rvb03
           IF l_pmn65 = '2' THEN
               LET g_tlf.tlf02=18      #委外代買
           ELSE
               LET g_tlf.tlf02=60
           END IF
           #No:7692(end)
      OTHERWISE LET g_tlf.tlf02 = 10
   END CASE
   LET g_tlf.tlf020=g_plant             #工廠編號
   LET g_tlf.tlf021=''                  #倉庫別
   LET g_tlf.tlf022=''                  #儲位別
   LET g_tlf.tlf023=''
   LET g_tlf.tlf024=''
   LET g_tlf.tlf025=''
   IF g_argv6 ='1' THEN                     #FUN-940083--add
      IF p_pmn011='SUB' THEN
         LET g_tlf.tlf026=p_rvb.rvb34
         LET g_tlf.tlf027=p_rvb.rvb03
         LET g_tlf.tlf03=25                 #F.Q.C.
         LET g_tlf.tlf13='asft6001'            #異動命令代號
      ELSE
         LET g_tlf.tlf026=p_rvb.rvb04        #單據編號(採購單)
         LET g_tlf.tlf027=p_rvb.rvb03        #項次(採購項次)
         LET g_tlf.tlf03 =20                 #資料目的為檢驗區
         LET g_tlf.tlf13='apmt1101'          #異動命令代號
      END IF
#FUN-940083--begin
   ELSE
      LET g_tlf.tlf03 =20                    #資料目的為檢驗區          
      LET g_tlf.tlf13='apmt1101'             #異動命令代號
   END IF
#FUN-940083--end
   LET g_tlf.tlf030=g_plant             #工廠編號
   LET g_tlf.tlf031=p_rvb.rvb36         #倉庫別
   LET g_tlf.tlf032=p_rvb.rvb37         #儲位別
   LET g_tlf.tlf033=p_rvb.rvb38         #入庫批號
   LET g_tlf.tlf034=''                  #庫存數量
   LET g_tlf.tlf035=''                  #異動後庫存單位
   LET g_tlf.tlf036=p_rvb.rvb01         #驗收單單據編號
   LET g_tlf.tlf037=p_rvb.rvb02         #單據項次
   LET g_tlf.tlf04=''                   #工作中心
   LET g_tlf.tlf05=' '                  #作業編號
   LET g_tlf.tlf06=g_rva.rva06          #異動日期=驗收單之收貨日期
   LET g_tlf.tlf07=g_today              #異動數量=驗收單之實收數量
   LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user               #產生人
   LET g_tlf.tlf10=p_rvb.rvb07          #異動數量=驗收單之實收數量
#FUN-940083--begin
#  LET g_tlf.tlf11=p_pmn07              #異動單位=採購單位
# #---------No.TQC-750014 modify
# #LET g_tlf.tlf12=g_pmn09              #收料單位/料件庫存轉換率
#  LET g_tlf.tlf12=l_pmn09              #收料單位/料件庫存轉換率
# #---------No.TQC-750014 end
   LET g_tlf.tlf11=p_rvb.rvb90          #異動單位=收貨單位
   LET g_tlf.tlf12=p_rvb.rvb90_fac      #收料單位/料件庫存轉換率
#FUN-940083--end
   LET g_tlf.tlf14=' '                  #異動原因代碼
   LET g_tlf.tlf17=''                   #非庫存性料件編號
   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlf.tlf18 #異動後總庫存量
   LET g_tlf.tlf19=g_rva.rva05          #廠商編號
#FUN-940083--begin
#  LET g_tlf.tlf20=p_pmn122             #專案號碼
   IF g_argv6 = '1' THEN
      LET g_tlf.tlf20=p_pmn122          #專案號碼
   ELSE
      LET g_tlf.tlf20= ' '              #專案號碼
   END IF
#FUN-940083--end
   LET g_tlf.tlf61=p_ima86              #成本單位
   LET g_tlf.tlf62=p_rvb.rvb04          #單據編號(採購單)
   LET g_tlf.tlf63=p_rvb.rvb03          #項次(採購項次)
   LET g_tlf.tlf64=p_rvb.rvb25          #手冊 no.A050
   LET g_tlf.tlf930=p_rvb.rvb930        #成本中心 #FUN-670051
  #FUN-810045 begin
   IF g_argv6 !='1' THEN                #FUN-940083--add
      SELECT pmn122,pmn96,pmn97,pmn98
        INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
        FROM pmn_file
       WHERE pmn01 = p_rvb.rvb04
         AND pmn02 = p_rvb.rvb03
      IF SQLCA.sqlcode THEN
         LET g_tlf.tlf20 = ' '
         LET g_tlf.tlf41 = ' '
         LET g_tlf.tlf42 = ' '
         LET g_tlf.tlf43 = ' '
      END IF
   END IF                              #FUN-940083--add
  #FUN-810045 end
   CALL s_tlf(p_stdc,p_reason)
 
END FUNCTION
 
FUNCTION t110_x()
   DEFINE  l_rvb22      LIKE rvb_file.rvb22   #No.MOD-580086
   DEFINE  l_flag       LIKE type_file.num5   #FUN-810038
   DEFINE  l_cnt        LIKE type_file.num5   #MOD-8B0059
   DEFINE l_ebocode     VARCHAR(1)               #FUN-880085
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
   IF g_rva.rva01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rva.rvaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
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
      #-----MOD-8B0059---------
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
      #-----END MOD-8B0059-----
   END IF                              #FUN-940083--add 
   IF cl_void(0,0,g_rva.rvaconf) THEN
&ifdef ICD
      #FUN-810038................begin
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM ida_file
           WHERE ida07 = g_rva.rva01
         IF g_cnt > 0 THEN
            IF NOT cl_confirm('aic-112') THEN
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_icdinout_del(0,g_rva.rva01,'','') RETURNING l_flag 
               IF l_flag = 0 THEN
                  CLOSE t110_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
         END IF
      #FUN-810038................end
&endif
      LET g_chr=g_rva.rvaconf
      IF g_rva.rvaconf ='N' THEN
         LET g_rva.rvaconf='X'
      ELSE
         LET g_rva.rvaconf='N'
         #FUN-880085 --start-- 取消作廢時判斷eB-Online底稿區資料是否未確認
        #IF g_aza.aza75 MATCHES '[Yy]' AND g_prog = 'apmt110' THEN
        #   IF g_rva.rva10='REG' OR g_rva.rva10='EXP' OR g_rva.rva10='CAP' THEN
        #      CALL aws_ebocli(g_dbs,g_rva.rva01,'*','*','*','*','EBO-040','M030','query')  #FUN-760028
        #           RETURNING l_ebocode
        #           
        #      IF l_ebocode = "N" THEN
        #         CALL aws_ebocli(g_dbs,g_rva.rva01,'*','*','*','*',        
        #                    'EBO-040','M030','del') RETURNING g_success  #FUN-760028
        #         IF g_success = 'N' THEN
        #         	 CLOSE t110_cl
        #            ROLLBACK WORK                     
        #            RETURN
        #         END IF 
        #      END IF
        #                        
        #      IF l_ebocode = "Y" THEN
        #         CALL cl_err('','aws-515',1) #已經上傳e-B Online 不可取消作廢
        #         RETURN
        #      END IF               
        #   END IF
        #END IF
        ##FUN-880085 --end--
      END IF
      UPDATE rva_file SET rvaconf = g_rva.rvaconf,
                          rvamodu = g_user,
                          rvadate = TODAY
       WHERE rva01 = g_rva.rva01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('upd rvaconf:',STATUS,1)  #No.FUN-660129
         CALL cl_err3("upd","rva_file",g_rva.rva01,"",STATUS,"","upd rvaconf:",1) #No.FUN-660129
         LET g_success='N'
       #-----No.MOD-580086-----
      ELSE
         DECLARE rvb22_curx CURSOR FOR
          SELECT UNIQUE rvb22
            FROM rvb_file
           WHERE rvb01 = g_rva.rva01
 
         CALL s_showmsg_init()        #No.FUN-710030
         FOREACH rvb22_curx INTO l_rvb22
#No.FUN-710030 -- begin --
            IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
            END IF
#No.FUN-710030 -- end --
            SELECT COUNT(*) INTO g_cnt
              FROM rvb_file
             WHERE rvb22 = l_rvb22
               AND rvb01 <> g_rva.rva01
            IF g_cnt = 0 THEN
               DELETE FROM rvw_file
                WHERE rvw01 = l_rvb22
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('DEL rvw_filee err!',SQLCA.SQLCODE,0) #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.SQLCODE,"","DEL rvw_file err!",1) #No.FUN-660129
                  IF g_bgerr THEN
                     CALL s_errmsg("rvw01",l_rvb22,"DEL rvw_filee err!",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("del","rvw_file",l_rvb22,"",SQLCA.SQLCODE,"","DEL rvw_file err!",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success ="N"
               END IF
            END IF
         END FOREACH
#No.FUN-710030 -- begin --
         IF g_totsuccess="N" THEN
            LET g_success="N"
         END IF
#No.FUN-710030 -- end --
 
       #-----No.MOD-580086-----
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
   IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
 
END FUNCTION
 
FUNCTION t110_y()     #確認
   DEFINE l_code   LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_msg    LIKE type_file.chr50     #No.FUN-680136 VARCHAR(12)
   DEFINE l_cnt    LIKE type_file.num5      #No.FUN-680136 SMALLINT
   #No.TQC-7C0086 --start--
   DEFINE #l_sql    LIKE type_file.chr1000
          l_sql        STRING       #NO.FUN-910082  
   DEFINE l_rvb22  LIKE rvb_file.rvb22
   DEFINE l_als05  LIKE als_file.als05
   DEFINE l_als21  LIKE als_file.als21
   #No.TQC-7C0086 --end--
   #No.TQC-880009 --begin--
   DEFINE l_rvb03  LIKE rvb_file.rvb03
   DEFINE l_rvb04  LIKE rvb_file.rvb04
   DEFINE l_rvb07  LIKE rvb_file.rvb07    #MOD-9B0111
   DEFINE l_pmn16  LIKE pmn_file.pmn16
   #No.TQC-880009 --end--
DEFINE l_status LIKE type_file.chr1    #FUN-880016
 
   IF cl_null(g_rva.rva01) THEN RETURN END IF
   SELECT * INTO g_rva.* FROM rva_file WHERE rva01=g_rva.rva01
   IF g_rva.rvaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rva.rvaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 
   SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01=g_rva.rva01
   IF g_cnt > g_sma.sma110 THEN
      CALL cl_err('','axm-156',0)
      RETURN
   END IF
 
   IF g_argv6 ='1' THEN                  #FUN-940083--add
      #No.TQC-880009 --begin--
      DECLARE t110_rvb04 CURSOR FOR
       SELECT rvb03,rvb04,rvb07 FROM rvb_file WHERE rvb01 = g_rva.rva01   #MOD-9B0111 add rvb07
   
      FOREACH t110_rvb04 INTO l_rvb03,l_rvb04,l_rvb07    #MOD-9B0111 add rvb07
         IF STATUS THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            RETURN
         END IF
   
         SELECT pmn16 INTO l_pmn16 FROM pmn_file 
          WHERE pmn01 = l_rvb04
            AND pmn02 = l_rvb03
         IF l_pmn16 != '2' THEN
            CALL cl_err('','mfg3166',1)
            RETURN
         END IF
         #-----MOD-9B0111---------
         IF l_rvb07 <= 0 THEN
            CALL cl_err('','mfg3348',0)   
            RETURN
         END IF
         #-----END MOD-9B0111-----
      END FOREACH
      #No.TQC-880009 --end--
   END IF                                #FUN-940083--add
 
   #---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rvb_file
    WHERE rvb01=g_rva.rva01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #---BUGNO:7379 END---------------
 
 
   IF g_argv5<>'1' THEN  #FUN-840012
      #No.TQC-7C0086 --start--
      IF g_sma.sma41 = 'Y' AND g_rva.rva04='Y' THEN
         LET l_sql = "SELECT rvb22 FROM rvb_file",
                     " WHERE rvb01 = '",g_rva.rva01,"'"
         PREPARE t110_rvb_pre FROM l_sql
         DECLARE t110_rvb_cs CURSOR FOR t110_rvb_pre
         FOREACH t110_rvb_cs INTO l_rvb22
            SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
             WHERE als01=l_rvb22
            IF SQLCA.sqlcode=100 THEN
               CALL cl_err3("sel","als_file",g_rvb[l_ac].rvb22,"","aap-762","","",1)
               RETURN
            END IF
            IF l_als05 <> g_rva.rva05 THEN
               CALL cl_err('','apm-303',0)
               RETURN
            END IF
         END FOREACH
      END IF
      #No.TQC-7C0086 --end--
      IF NOT cl_confirm('axm-108') THEN RETURN END IF
   END IF
   #NO.FUN-960130---BEGIN-------
   IF g_azw.azw04='2' THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM rvb_file WHERE rvb01 = g_rva.rva01 AND (rvb36 IS NULL OR rvb36 = ' ')
      IF g_cnt IS NULL THEN LET g_cnt = 0 END IF
      IF g_cnt != 0 THEN CALL cl_err('','apm-067',0) RETURN END IF
   END IF
   #NO.FUN-960130-----END--------- 
   LET g_success = 'Y'
   LET g_totsuccess = 'Y'    #No.MOD-890074
 
   #------FUN-880016 start-------------
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      LET g_t1 = s_get_doc_no(g_rva.rva01) 
      SELECT * INTO g_smy.* FROM smy_file
       WHERE smyslip=g_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
	    CALL s_showmsg_init()
	    CALL aws_gpmcli_part(g_rva.rva01,g_rva.rva05,'','7')
	         RETURNING l_status
	    IF l_status = '1' THEN   #回傳結果為失敗
               IF g_smy.smy64 = '1' THEN
	          CALL s_showmsg()
               END IF
	       IF g_smy.smy64 = '2' THEN   
                  LET g_success = 'N'
	          CALL s_showmsg()
                  RETURN
	       END IF
	    END IF
         END IF
      END IF
   END IF                    #FUN-8A0054
   #------FUN-880016 end----------------
 
   #-->確認時 check 超短交 & 可否提前交貨
   CALL s_showmsg_init()     #No.MOD-940250 add
   IF g_argv6 ='1' THEN                  #FUN-940083--add
      CALL t110_chk_over()
   END IF                                #FUN-940083--add
  #No.MOD-940250 modify --begin
  #IF g_success = 'N' THEN CALL cl_rbmsg(4) RETURN END IF
   CALL s_showmsg()
   IF g_totsuccess = 'N' THEN CALL cl_rbmsg(4) RETURN END IF
  #No.MOD-940250 modify --end
&ifdef ICD
   #FUN-810038................begin
      #-->確認時 check  若該工單是作業群組(ecdicd01) = '6.TKY', 
      #委外TKY收貨作業站別與委外工單作業製程站別不符,
      #則出現錯誤訊息, 不允許確認 
      CALL t110_ind_icd_chk_tky()
      IF g_success = 'N' THEN CALL cl_rbmsg(4) RETURN END IF
   #FUN-810038................end
&endif
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
 
   #-->更新單頭確認碼
   #NO.FUN-960130----START--
   #UPDATE rva_file SET rvaconf = 'Y' WHERE rva01 = g_rva.rva01
   UPDATE rva_file SET rvaconf = 'Y',rvaconu=g_user,rvacond=g_today
       WHERE rva01 = g_rva.rva01
   #NO.FUN-960130---END--
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   END IF
 
   CALL t110_y1()
   IF g_success ='Y' THEN  #TQC-750097
      IF g_argv6 ='1' THEN                  #FUN-940083--add
         CALL t110_upd_pmn()
      END IF                                #FUN-940083--add
   END IF #TQC-750097
   CALL cl_msg("")
   IF g_success = 'Y' THEN
      LET g_rva.rvaconf='Y'
      LET g_rva.rvaconu = g_user     #NO.FUN-960130
      LET g_rva.rvacond = g_today    #NO.FUN-960130
      COMMIT WORK
      #MOD-740519-begin-mark
      ##No.TQC-740078--begin--
      #LET l_cnt = 0
      #SELECT COUNT(*) INTO l_cnt FROM rvu_file
      # WHERE rvu02 = g_rva.rva01
      #IF l_cnt > 0  THEN
      #   IF g_rva.rva10='SUB' THEN
      #      LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",
      #                  "'1' 'SUB'"
      #   ELSE
      #      LET g_cmd = "apmt720 ","'",g_rva.rva01 CLIPPED,"' '' '1'"
      #   END IF
      #  #CALL cl_cmdrun_wait(g_cmd) #FUN-660216 add
      #   CALL cl_cmdrun(g_cmd)      #TQC-740078
      #END IF
      ##No.TQC-740078--end--
      #MOD-740519-end-mark
      #MOD-740519-begin-add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rvu_file
       WHERE rvu02 = g_rva.rva01
         AND rvuconf != 'X'         #No.MOD-850156 add
    # IF l_cnt > 0  THEN                   #No.FUN-940083 By shiwuying
      IF l_cnt > 0 AND g_argv6 <> '2' THEN #No.FUN-940083 By shiwuying
      IF g_rva.rva10='SUB' THEN
&ifndef ICD
        #LET g_cmd = "apmt730 "," '",g_rva.rva01 CLIPPED,"' '' '5' " #MOD-840263
         LET g_cmd = "apmt730" #MOD-840263
&else
         #MOD-840263..................begin
         IF g_prog='aict041' THEN
            LET g_cmd = "aict042"
         ELSE
            LET g_cmd = "apmt730_icd"
         END IF
         #MOD-840263..................end
&endif
      ELSE
&ifndef ICD
        #LET g_cmd = "apmt720 "," '",g_rva.rva01 CLIPPED,"' '' '5'" #MOD-840263
         LET g_cmd = "apmt720" #MOD-840263
&else
         #MOD-840263..................begin
         IF g_prog='aict041' THEN
            LET g_cmd = "aict042"
         ELSE
            LET g_cmd = "apmt720_icd"
         END IF
         #MOD-840263..................end
&endif
      END IF
      LET g_cmd=g_cmd," "," '",g_rva.rva01 CLIPPED,"' '' '5' "
      CALL cl_cmdrun_wait(g_cmd)
      END IF
      #MOD-740519-end-add
      CALL cl_flow_notify(g_rva.rva01,'Y')
      CALL cl_cmmsg(4)
   ELSE
      LET g_rva.rvaconf='N'
      ROLLBACK WORK
      CALL s_showmsg()       #No.TQC-760055
      CALL cl_rbmsg(4)
   END IF
   DISPLAY BY NAME g_rva.rvaconf
   CALL t110_show()
   #CKP
   IF g_rva.rvaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
 
END FUNCTION
 
FUNCTION t110_y1()
 DEFINE  l_rvb   RECORD LIKE rvb_file.*,
         l_factor1       LIKE ima_file.ima31_fac, #No.FUN-680136 DECIMAL(16,8)
         l_cnt           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_sfa05         LIKE sfa_file.sfa05,
         l_sfa065        LIKE sfa_file.sfa065,
         l_rvb07         LIKE rvb_file.rvb07,
         l_sfb04         LIKE sfb_file.sfb04,    #
         l_sfb24         LIKE sfb_file.sfb24,    #No.B415 add
         l_pmh08         LIKE pmh_file.pmh08,    #
         l_pmn07         LIKE pmn_file.pmn07,    #採購單號
         l_pmn51         LIKE pmn_file.pmn51,
         l_pmn01         LIKE pmn_file.pmn01,    #採購單號
         l_pmn02         LIKE pmn_file.pmn02,    #項次
         l_pmn122        LIKE pmn_file.pmn122,   #專案號碼
         l_pmn09         LIKE pmn_file.pmn09,    #轉換因子
         l_pmn40         LIKE pmn_file.pmn40,    #會計科目
         l_pmn011        LIKE pmn_file.pmn011,   #性質
         l_pmm22         LIKE pmm_file.pmm22 ,   #
         l_ima25         LIKE ima_file.ima25,    #庫存單位
         l_ima86         LIKE ima_file.ima86,    #成本單位
         l_ima906        LIKE ima_file.ima906,   #No.FUN-540027
         l_code          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
         l_qc            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
         l_ins_rvu       LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) #有免驗料,可直接入庫的資料設'Y' NO:7143
         l_fac           LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
         l_ima44         LIKE ima_file.ima44,
         l_ima55         LIKE ima_file.ima55
 DEFINE  l_msg           LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(100)
 DEFINE  l_pmm04         LIKE pmm_file.pmm04     #FUN-610040
 DEFINE  l_ima915        LIKE ima_file.ima915    #FUN-710060 add
 DEFINE  l_flag          LIKE type_file.num10    #FUN-810038
 DEFINE  l_rvbs06        LIKE rvbs_file.rvbs06   #No.FUN-840187
&ifndef STD
 DEFINE  l_rvbi          RECORD LIKE rvbi_file.* #FUN-810038
&endif
 DEFINE l_img09          LIKE img_file.img09  #No.FUN-850100
 DEFINE l_i              LIKE type_file.num5  #No.FUN-850100
 DEFINE l_pmm02   LIKE pmm_file.pmm02     #MOD-860146
 DEFINE l_type    LIKE type_file.chr1     #MOD-860146
 DEFINE l_pmn41   LIKE pmn_file.pmn41     #MOD-860146
 DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
 DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
 DEFINE l_pmn18   LIKE pmn_file.pmn18     #CHI-8C0017
 
   LET l_qc = 'N'
   LET l_ins_rvu='N' #default可直接入庫碼設為'Y'
   DECLARE t110_y CURSOR FOR
     SELECT * FROM rvb_file WHERE rvb01=g_rva.rva01
   DECLARE t110_y_n CURSOR FOR  #NO:7143
     SELECT * FROM rvb_file
      WHERE rvb01=g_rva.rva01
        AND rvb39='N' #檢驗否='N'
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_y INTO l_rvb.*
      IF STATUS THEN
         LET g_success = 'N'  #No.FUN-8A0086
#No.FUN-710030 -- begin --
#         CALL cl_err('foreach:',STATUS,0)
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
#No.FUN-710030 -- end --
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
 
   #-----No.FUN-840187-----
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = l_rvb.rvb05
      AND imaacti = "Y"
   
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      IF g_sma.sma90 = "Y" THEN  #No.FUN-850100
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = l_rvb.rvb01
            AND rvbs02 = l_rvb.rvb02
            AND rvbs13 = 0    #No.FUN-860045
            AND rvbs09 = 1
         
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
         
#FUN-940083--begin
#        #-----No.FUN-850100-----
#        LET l_pmn07 = NULL
#        SELECT pmn07 INTO l_pmn07 
#          FROM pmn_file
#         WHERE pmn01 = l_rvb.rvb04 
#           AND pmn02 = l_rvb.rvb03
#        
#        LET l_img09 = NULL
#        SELECT img09 INTO l_img09
#          FROM img_file   #庫存單位
#         WHERE img01=l_rvb.rvb05 AND img02=l_rvb.rvb36
#           AND img03=l_rvb.rvb37 AND img04=l_rvb.rvb38
#        
#        CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_img09) 
#             RETURNING l_i,l_fac
#        
#        IF (l_rvb.rvb07 * l_fac) <> l_rvbs06 THEN
#        #-----No.FUN-850100 END-----
         IF (l_rvb.rvb07 * l_rvb.rvb90_fac) <> l_rvbs06 THEN
#FUN-940083--end
 
            LET g_success = "N"
            CALL s_errmsg("","",l_rvb.rvb04,"aim-011",1)
            CONTINUE FOREACH
         END IF
      END IF
   END IF
   #-----No.FUN-840187 END-----
 
&ifdef ICD
     #FUN-810038................begin
        SELECT * INTO l_rvbi.*
          FROM rvbi_file
         WHERE rvbi01=l_rvb.rvb01
           AND rvbi02=l_rvb.rvb02
        LET b_rvbi.* = l_rvbi.*  #TQC-940066
        #判斷若為委外收貨單TKY,非最後一站的項次,不做收貨確認
        IF l_rvbi.rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
     #FUN-810038................end
&endif
 
     #start FUN-610040
      LET l_pmm04 =''
      IF NOT cl_null(l_rvb.rvb04) THEN
         SELECT pmm04 INTO l_pmm04 FROM pmm_file   #採購單據日期
          WHERE pmm01 = l_rvb.rvb04
         IF STATUS OR l_pmm04 > g_rva.rva06 THEN
            #收貨日期不可小於採購單據日期
#No.FUN-710030 -- begin --
#            CALL cl_err(l_rvb.rvb04,'apm-413',1)
#            LET g_success = 'N'
#            EXIT FOREACH
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb.rvb04,"apm-413",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","apm-413","",l_rvb.rvb04,1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
      END IF
     #end FUN-610040
 
      #-----委外處理
      IF g_rva.rva10='SUB' THEN
#------------No.MOD-790176 mark
#MOD-7A0090-add
        #--------------No.MOD-930044 remark
         SELECT sfb24 INTO l_sfb24 FROM sfb_file
          WHERE sfb01 = l_rvb.rvb34
        #--------------No.MOD-930044 end
#        IF l_sfb24='N' OR cl_null(l_sfb24) THEN
#           CALL cl_err('','mfg6097',1)
#                 LET g_success='N'
#                 RETURN
#        END IF
#        IF cl_null(l_rvb.rvb34) THEN
#           CALL cl_err('','asf-967',1)
#           LET g_success='N'
#           RETURN
#        END IF
#MOD-7A0090-add-end
#------------No.MOD-790176 end
 
         SELECT COUNT(*) INTO l_cnt
           FROM sfa_file
          WHERE sfa01=l_rvb.rvb34 AND sfa05!=sfa065
&ifndef ICD
         #FUN-810038................begin
         #IF NOT s_industry('icd') THEN  #ICD之委外工單不發料也可收貨確認
         #FUN-810038................end
            IF l_cnt>0 THEN
               SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
                WHERE sfp01 = sfq01
                  AND sfq02 = l_rvb.rvb34
                  AND sfp06 = '1'
                  AND sfp04 = 'Y'
               IF l_cnt = 0 AND g_argv5<>'1' THEN #FUN-840012
                 #--------------------No.MOD-730078 modify
                 #FUN-640123...............begin
                  CALL cl_getmsg('apm-002',g_lang) RETURNING g_msg
                  LET g_msg = l_rvb.rvb34 CLIPPED,g_msg
                  IF NOT cl_prompt(17,5,g_msg) THEN
                     LET g_success='N'
                     RETURN
                  END IF
                 #CALL cl_err(l_rvb.rvb34,'apm-046',1)
                 #LET g_success='N'  #MOD-6A0131
                 #RETURN
                 #FUN-640123...............end
                 #--------------------No.MOD-730078 end
                 #LET g_success='N'  #MOD-6A0131  #MOD-910239
                 #RETURN                          #MOD-910239
                 #FUN-640123...............end
               END IF
            END IF
&endif
         #-----No.MOD-5C0039-----
         SELECT sfb04 INTO l_sfb04 FROM sfb_file   #工單
          WHERE sfb01 = l_rvb.rvb34
         IF l_sfb04 = "8" THEN
#No.FUN-710030 -- begin --
#            CALL cl_err(l_rvb.rvb34,"asf-070",0)
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb.rvb34,"asf-070",1)
            ELSE
               CALL cl_err3("","","","","asf-070","",l_rvb.rvb34,1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
            RETURN
         END IF
         #-----No.MOD-5C0039 END-----
         IF l_sfb24 ='N' OR l_sfb24 IS NULL THEN   #No.B415 add
            SELECT sfb04,sfb05 INTO l_sfb04,g_sfb05 FROM sfb_file   #工單
             WHERE sfb01 = l_rvb.rvb34
            IF l_sfb04 < '6' THEN
               CALL cl_msg("Update sfb_file ...")
               UPDATE sfb_file SET sfb04 = '6'  #工單已完工,進入F.Q.C
                WHERE sfb01 = l_rvb.rvb34
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('1.UPDATE fail sfb_file :',SQLCA.sqlcode,1) #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("upde","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","1.UPDATE fail sfb_file :",1) #No.FUN-660129
                  IF g_bgerr THEN
                     CALL s_errmsg("sfb01",l_rvb.rvb34,"1.UPDATE fail sfb_file :",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","1.UPDATE fail sfb_file :",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
            CALL s_updsfb117(l_rvb.rvb34)
            IF g_success='N' THEN
#No.FUN-710030 -- begin --
#               CALL cl_err('2.UPDATE fail sfb_file :',SQLCA.sqlcode,1)
               IF g_bgerr THEN
                  CALL s_errmsg("","","2.UPDATE fail sfb_file :",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","2.UPDATE fail sfb_file :",1)
               END IF
#No.FUN-710030 -- end --
               RETURN
            END IF
         END IF
      END IF
 
      IF g_argv6='1' THEN                               #FUN-940083--add
         #-->取採購單位(pmn07)與庫存單位(ima25)的轉換,且LOCK 此筆資料
         LET g_forupd_sql = "SELECT pmn09,pmn011,pmn40,pmn07",
                            "  FROM pmn_file",
                            " WHERE pmn01=? AND pmn02=? FOR UPDATE"
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE t110_pmn1 CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
         OPEN t110_pmn1 USING l_rvb.rvb04,l_rvb.rvb03
         IF STATUS THEN
#No.FUN-710030 -- begin --
#             CALL cl_err("OPEN t110_pmn1:", STATUS, 1)
            IF g_bgerr THEN
               CALL s_errmsg("","","OPEN t110_pmn1:",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","OPEN t110_pmn1:",1)
            END IF
#No.FUN-710030 -- end --
            CLOSE t110_pmn1
            #ROLLBACK WORK                                  #CHI-840071
             LET g_success = 'N'                            #CHI-840071
             RETURN
         END IF
         FETCH t110_pmn1 INTO l_pmn09,l_pmn011,l_pmn40,l_pmn07
         IF SQLCA.sqlcode THEN
#No.FUN-710030 -- begin --
#            CALL cl_err('fetch t110_pmn1:',SQLCA.sqlcode,0)
            IF g_bgerr THEN
               CALL s_errmsg("","","fetch t110_pmn1:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch t110_pmn1:",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
            RETURN
         END IF
      END IF                                                 #FUN-940083--add
&ifdef ICD
      #FUN-810038................begin
         IF g_argv2='ICD' OR g_argv2='SUB' THEN
            CALL s_icdpost(0,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                           l_pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                           g_rva.rva06,'Y','','','')  
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
      #FUN-810038................end
&endif
      IF l_rvb.rvb05[1,4] != 'MISC' THEN
         LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file",
                            " WHERE ima01=? FOR UPDATE"
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE t110_ima1  CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
         OPEN t110_ima1 USING l_rvb.rvb05
         IF STATUS THEN
#No.FUN-710030 -- begin --
#            CALL cl_err("OPEN t110_ima1:", STATUS, 1)
         IF g_bgerr THEN
            CALL s_errmsg("","","OPEN t110_ima1:",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","OPEN t110_ima1:",1)
         END IF
#No.FUN-710030 -- end --
            CLOSE t110_ima1
           #ROLLBACK WORK                                  #CHI-840071
            LET g_success = 'N'                            #CHI-840071
            RETURN
         END IF
 
         FETCH t110_ima1 INTO l_ima25,l_ima86  
         IF SQLCA.sqlcode THEN
#No.FUN-710030 -- begin --
#            CALL cl_err('fetch:',SQLCA.sqlcode,0)
            IF g_bgerr THEN
               CALL s_errmsg("","","fetch:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch:",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
            RETURN
         END IF
 
#        CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_ima25) RETURNING l_cnt,l_factor1         #FUN-940083
         CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25) RETURNING l_cnt,l_factor1     #FUN-940083
         IF l_cnt = 1 THEN
#No.FUN-710030 -- begin --
#            CALL cl_err('pmn07/ima25: ','abm-731',1)
            IF g_bgerr THEN
               CALL s_errmsg("","","pmn07/ima25: ","abm-731",1)
            ELSE
               CALL cl_err3("","","","","abm-731","","pmn07/ima25: ",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success ='N'
            RETURN
         END IF
      END IF
 
      IF g_argv6='1' THEN               #FUN-940083--add
        #-->取專案編號
        SELECT pmn122 INTO l_pmn122 FROM pmn_file
         WHERE pmn01 = l_rvb.rvb04
           AND pmn02 = l_rvb.rvb03
      END IF                            #FUN-940083--add 
 
      #-->樣品不更新PO上的數量
      IF l_rvb.rvb35='N' THEN
         #-->(1-2)更新超短交量
         #CALL s_udpmn57(l_rvb.rvb04,l_rvb.rvb03)   #TQC-8A0059移至t110_upd_pmn()
 
         #-->(1-3)產生tlf_file
         IF l_rvb.rvb05[1,4] != 'MISC' THEN
            CALL cl_msg("Insert tlf_file ...")
#FUN-940083--begin
#           CALL t110_log(1,0,l_rvb.*,l_pmn011,l_pmn07,l_pmn40,l_ima86,l_pmn122)
            IF g_argv6='1' THEN
               CALL t110_log(1,0,l_rvb.*,l_pmn011,l_pmn40,l_ima86,l_pmn122)
            ELSE
               CALL t110_log(1,0,l_rvb.*,g_rva.rva10,'',l_ima86,' ')
            END IF
#FUN-940083--end
            #No.FUN-540027  --begin
            SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_rvb.rvb05
            IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
               IF NOT cl_null(l_rvb.rvb83) THEN
                  #IF NOT cl_null(l_rvb.rvb85) AND l_rvb.rvb85 <> 0 THEN   #MOD-890276
                  IF NOT cl_null(l_rvb.rvb85) THEN   #MOD-890276
#FUIN-940083--begin
#                    CALL t110_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2')
                     IF g_argv6='1' THEN
                        CALL t110_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2')
                     ELSE
                        CALL t110_tlff(l_pmn011,l_ima86,' ',l_rvb.*,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2')
                     END IF
#FUIN-940083--end
                  END IF
               END IF
               #No.CHI-770019  --Begin
               IF l_ima906 <> '3' THEN
                  IF NOT cl_null(l_rvb.rvb80) THEN
                     #IF NOT cl_null(l_rvb.rvb82) AND l_rvb.rvb82 <> 0 THEN   #MOD-890276
                     IF NOT cl_null(l_rvb.rvb82) THEN   #MOD-890276
#FUIN-940083--begin
#                       CALL t110_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1')
                        IF g_argv6='1' THEN
                           CALL t110_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1')
                        ELSE
                           CALL t110_tlff(l_pmn011,l_ima86,' ',l_rvb.*,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1')
                        END IF
#FUIN-940083--end
                     END IF
                  END IF
               END IF
               #No.CHI-770019  --End
            END IF
            #No.FUN-540027  --end
         END IF
      END IF
 
      IF g_argv6 ='1' THEN                           #FUN-940083--add
         #FUN-710060---mod---str---
         #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
         #                        #                   2: 不作料件供應商管制
         #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制
          SELECT ima915 INTO l_ima915 FROM ima_file
           WHERE ima01=l_rvb.rvb05
          IF l_ima915='2' OR l_ima915='3' THEN
         #FUN-710060---mod---end---
             #SELECT pmm22 INTO l_pmm22 FROM pmm_file   #MOD-860146
             SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
              WHERE pmm01=l_rvb.rvb04
             
             #CHI-8C0017--Begin--# 
#            #-----MOD-860146---------
#            IF l_pmm02 = 'SUB' THEN
#               LET l_type = '2' 
#            ELSE
#               LET l_type = '1' 
#            END IF
#            SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
#              WHERE pmn01 = l_rvb.rvb04 
#                AND pmn02 = l_rvb.rvb03
#            IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
#               LET l_ecm04 = " "
#            ELSE
#               SELECT ecm04 INTO l_ecm04 FROM ecm_file
#                WHERE ecm01 = l_pmn41
#                  AND ecm03 = l_pmn43
#            END IF
#            #-----END MOD-860146-----
            SELECT pmn41,pmn43,pmn18 INTO l_pmn41,l_pmn43,l_pmn18 FROM pmn_file
             WHERE pmn01 = l_rvb.rvb04 AND pmn02 = l_rvb.rvb03          
            IF l_pmm02='SUB' THEN
               LET l_type='2'
               #-----MOD-910172---------
               IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
                  LET l_ecm04=' '
               ELSE
               #-----END MOD-910172----- 
                  IF NOT cl_null(l_pmn18) THEN
                     SELECT sgm04 INTO l_ecm04 FROM sgm_file
                      WHERE sgm01=l_pmn18
                        AND sgm02=l_pmn41
                        AND sgm03=l_pmn43
                  ELSE
                     SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                      WHERE ecm01=l_pmn41
                        AND ecm03=l_pmn43
                  END IF
               END IF   #MOD-910172
            ELSE
               LET l_type='1'
               LET l_ecm04=' '
            END IF
            #CHI-8C0017--End--#         
             
             SELECT pmh08 INTO l_pmh08 FROM pmh_file
              WHERE pmh01=l_rvb.rvb05
                AND pmh02=g_rva.rva05
                AND pmh13=l_pmm22
                AND pmh21= l_ecm04   #MOD-860146
                AND pmh22= l_type    #MOD-860146
                AND pmh23 = ' '      #No.CHI-960033 
                AND pmhacti = 'Y'                                           #CHI-910021
 
             IF cl_null(l_pmh08) THEN
                LET l_pmh08 = 'N'
             END IF
 
             IF l_rvb.rvb05[1,4] = 'MISC' THEN
                LET l_pmh08='N'
             END IF
          ELSE
             SELECT ima24 INTO l_pmh08 FROM ima_file
              WHERE ima01=l_rvb.rvb05
             IF cl_null(l_pmh08) THEN
                LET l_pmh08 = 'N'
             END IF
 
             IF l_rvb.rvb05[1,4] = 'MISC' THEN
                LET l_pmh08='N'
             END IF
          END IF
#FUN-940083--begin
      ELSE
          LET l_pmm22=' '
          LET l_type ='1'
          LET l_ecm04=' '
      END IF
#FUN-940083--end
 
      IF l_pmh08='N' OR     #免驗料
         (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
         l_rvb.rvb19='2' THEN #委外代買料
         UPDATE rvb_file SET rvb33 = l_rvb.rvb07, #實收數量
                             rvb31 = l_rvb.rvb07, #TQC-880058 add  
                            #No.FUN-580115  --begin
                             rvb331 = l_rvb.rvb82, #實收數量
                             rvb332 = l_rvb.rvb85, #實收數量
                            #No.FUN-580115  --end
                             rvb39 = 'N',         #檢驗否    #No:BUG-490363  #MOD-530415 MARK 改在單身產生時即應將是否檢驗的資料帶入，不需等到確認後再帶出。   #MOD-940078
                             rvb40 = g_today,     #檢驗日期
                             rvb41 = 'OK'         #檢驗結果
          WHERE rvb01 = l_rvb.rvb01
            AND rvb02 = l_rvb.rvb02
         IF SQLCA.sqlcode THEN
#           CALL cl_err('UPDATE rvb_file',SQLCA.sqlcode,0)  #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1) #No.FUN-660129
            IF g_bgerr THEN
               LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02
               CALL s_errmsg("rvb01,rvb02",g_showmsg,"UPDATE rvb_file",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
            RETURN
         END IF
         LET l_ins_rvu='Y' #因為免驗料,所以可直接入庫碼設為'Y'
      #MOD-530415 MARK 改在單身產生時即應將是否檢驗的資料帶入，不需等到確認後再帶出。
     #ELSE
     #   UPDATE rvb_file SET rvb39 = 'Y'
     #    WHERE rvb01 = l_rvb.rvb01
     #      AND rvb02 = l_rvb.rvb02
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err('UPDATE rvb_file',SQLCA.sqlcode,0)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
      END IF
 
      IF g_argv6 = '1' THEN                    #FUN-940083--add
         #check收貨和品管是否要檢查承認文號
         #No:7631 要驗料件才需check
         IF l_pmh08 = 'Y' THEN
            CALL s_chk_apprl(l_rvb.rvb05,g_rva.rva05,l_rvb.rvb04)
            RETURNING l_code,l_msg #No:7625 所傳的參數寫顛倒
            #需依照參數『收貨單無承認文號時0.不處理　1.警告　2.拒絕』的設定處理
            CASE l_code
               WHEN 1      #警告
                  CALL cl_err('',l_msg,1)
               WHEN 2      #拒
                  CALL cl_err('',l_msg,1)
                  LET g_success = 'N'
                  RETURN
               OTHERWISE
                  EXIT CASE
            END CASE
         END IF
      END IF                                   #FUN-940083--add
   
      CLOSE t110_pmn1
      CLOSE t110_ima1
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
   #-->不為 'MISC' 且 為免檢者須check img_file(因免檢可直接入庫)
   IF l_ins_rvu='Y' THEN
      FOREACH t110_y_n INTO l_rvb.*
#No.FUN-710030 -- begin --
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
#No.FUN-710030 -- end --
#CHI-7A0003-modify
#MOD-790167-add
#       IF NOT cl_null(l_rvb.rvb36) AND g_sma.sma886[7,7] = 'Y' THEN
        #IF NOT cl_null(l_rvb.rvb36) THEN   #MOD-9A0176
        IF g_sma.sma886[7,7] = 'Y'  THEN   #MOD-9A0176
#MOD-790167-add -end
#CHI-7A0003-modify-end
         IF l_rvb.rvb05[1,4] <>'MISC' THEN
            SELECT COUNT(*) INTO g_cnt
              FROM img_file
             WHERE img01 = l_rvb.rvb05
               AND img02 = l_rvb.rvb36
               AND img03 = l_rvb.rvb37
               AND img04 = l_rvb.rvb38
            IF g_cnt=0 AND ((g_rva.rva10<>'SUB') OR (g_rva.rva10='SUB' AND l_sfb24='N')) THEN
               LET g_success='N'
#No.FUN-710030 -- begin --
#               CALL cl_err(l_rvb.rvb05,'apm-259',1)
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb.rvb05,"apm-259",1)
               ELSE
                  CALL cl_err3("","","","","apm-259","",l_rvb.rvb05,1)
               END IF
#No.FUN-710030 -- end --
               RETURN
            END IF
         END IF
       END IF                 #MOD-790167-add
      END FOREACH
#No.FUN-710030 -- begin --
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
#No.FUN-710030 -- end --
 
      IF STATUS THEN
         LET g_success='N'
#No.FUN-710030 -- begin --
#         CALL cl_err('foreach:',STATUS,0)
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach:",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach:",1)
         END IF
#No.FUN-710030 -- end --
         RETURN
      END IF
   END IF
 
   #-->免檢驗表示全部可直接入庫
#  IF l_ins_rvu = 'Y' AND g_sma.sma886[7]='Y' THEN   #No.FUN-940083 mark by shi
   IF l_ins_rvu = 'Y' AND g_sma.sma886[7]='Y' AND    #No.FUN-940083
      g_argv6 <> '2' THEN                            #No.FUN-940083
      CALL t110_insrvu()
      IF g_success='N' THEN
         RETURN
      END IF
&ifdef ICD
      #FUN-810038................begin
         CALL t110_ind_icd_upd_rvb87() #更新計價數量
      #FUN-810038................end
&endif
    #No.TQC-740078--begin-- mark
    ##FUN-730068................begin
    ##IF g_rva.rva10='SUB' THEN
    ##   CALL t720('5',g_rva.rva01,'SUB','') #No.FUN-630010
    ##ELSE
    ##   CALL t720('5',g_rva.rva01,' ','') #No.FUN-630010
    ##END IF
    #IF g_rva.rva10='SUB' THEN
    #   LET g_cmd = "apmt730 ","'",g_rva.rva01 CLIPPED,"' '' ",
    #               "'1' 'SUB'"
    #ELSE
    #   LET g_cmd = "apmt720 ","'",g_rva.rva01 CLIPPED,"' '' '1'"
    #END IF
    #CALL cl_cmdrun_wait(g_cmd) #FUN-660216 add
    ##FUN-730068................end
    #No.TQC-740078--end-- mark
   END IF
 
END FUNCTION
 
#FUNCTION t110_ins_rvu()       #No.MOD-8A0112 mark
#增加一個參數來判斷是入庫還是驗退,因為如果同一個料號既有入庫又又驗退就分不清楚了
FUNCTION t110_ins_rvu(p_chr)   #No.MOD-8A0112 add  
   DEFINE g_qcz       RECORD LIKE qcz_file.*
   DEFINE l_rvu       RECORD LIKE rvu_file.*,
          l_smy57     LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01)   #MOD-740033 modify
          l_t         LIKE smy_file.smyslip    #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
 
   LET g_success='Y'
  ##-----No.MOD-860080-----
  #IF b_rvb.rvb33 = 0 THEN
  #   #判斷此驗收單是否已產生驗退單
  #   SELECT COUNT(*) INTO g_i FROM rvv_file,rvu_file   #防止重覆過帳
  #    WHERE rvv04=b_rvb.rvb01 #收貨單號
  #      AND rvv05=b_rvb.rvb02 #收貨項次
  #      AND rvu00='2'         #驗退
  #      AND rvuconf <> 'X'
  #      AND rvu01 = rvv01
  #ELSE
  #   #判斷此驗收單是否已產生入庫單
  #   SELECT COUNT(*) INTO g_i FROM rvv_file,rvu_file   #防止重覆過帳
  #    WHERE rvv04=b_rvb.rvb01 #收貨單號
  #      AND rvv05=b_rvb.rvb02 #收貨項次
  #      AND rvu00='1'         #入庫
  #      AND rvuconf <> 'X'
  #      AND rvu01 = rvv01
  #END IF
 
  #IF g_i>0 THEN
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  ##-----No.MOD-860080 END-----
 
   #----單頭
   INITIALIZE l_rvu.* TO NULL
  #IF b_rvb.rvb33 = 0 THEN  #異動類別   #No.MOD-8A0112 mark
  #用傳入的參數來判斷是驗退還是入庫
   IF p_chr = 'o' THEN      #異動類別   #No.MOD-8A0112 add
      LET l_rvu.rvu00='2'   #驗退
&ifdef ICD
      #FUN-810038................begin
         #委外tky非最終站之收貨項次資料不可產生至驗退單
         IF b_rvbi.rvbiicd13 = 'Y' THEN
            RETURN 
         END IF
      #FUN-810038................end
&endif
   ELSE
      LET l_rvu.rvu00='1'   #入庫
   END IF
   LET l_rvu.rvu02=g_rva.rva01   #驗收單號
   LET l_rvu.rvu03=g_today       #異動日期
 
  #MOD-990083   ---start                                                                                                            
   #若入庫日小於收貨日                                                                                                              
   IF l_rvu.rvu03<g_rva.rva06 THEN                                                                                                  
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)                                                                               
      ELSE                                                                                                                          
         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)                                                                       
      END IF                                                                                                                        
      LET g_success='N'                                                                                                             
      RETURN                                                                                                                        
   END IF                                                                                                                           
  #MOD-990083   ---end  
 
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
#No.FUN-710030 -- begin --
#      CALL cl_err(l_rvu.rvu03,'mfg9999',1)
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_yp(l_rvu.rvu03) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
#No.FUN-710030 -- begin --
#      CALL cl_err(l_rvu.rvu03,'mfg6091',1)
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg6091",1)
      ELSE
         CALL cl_err3("","","","","mfg6091","",l_rvu.rvu03,1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_t = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
  #IF b_rvb.rvb33 = 0 THEN    #No.MOD-8A0112 mark
  #用傳入的參數來判斷
   IF p_chr = 'o' THEN        #No.MOD-8A0112 add
      SELECT smy51,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   ELSE
      SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   END IF
 
   IF l_rvu.rvu01 IS NULL THEN
#No.FUN-710030 -- begin --
#      CALL cl_err('smy52=NULL','apm-272',1)
      IF g_bgerr THEN
         CALL s_errmsg("","","smy52=NULL","apm-272",1)
      ELSE
         CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
      RETURN
   END IF
 
   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) OR
      (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN
      IF l_smy57='Y' THEN
#        LET l_rvu.rvu01[4,10]=g_rva.rva01[4,10]   #入庫/驗收單號
         LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=g_rva.rva01[g_no_sp-1,g_no_ep] #No.FUN-540027
 
         SELECT COUNT(*) INTO g_cnt
           FROM rvu_file
          WHERE rvu01=l_rvu.rvu01
            AND rvuconf !='X'
         IF g_cnt > 0 THEN   # OR MONTH(g_rva.rva08) <> MONTH(g_today)
                             #原有考慮收貨月份不等於入庫月份時應以 g_today產生單號
                             #此狀況改以原收貨月份產生單號)
 
#No.FUN-540027 --start--
            LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
            CALL s_auto_assign_no("apm",l_t,g_rva.rva06,"","","","","","")
                 RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
                LET g_success='N'
            END IF
#           CALL s_smyauno(l_t,g_rva.rva06) RETURNING g_i,l_rvu.rvu01
#           IF g_i THEN LET g_success='N' RETURN END IF
         END IF
      ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
             LET g_success='N'
         END IF
#        CALL s_smyauno(l_t,l_rvu.rvu03) RETURNING g_i,l_rvu.rvu01
#        IF g_i THEN LET g_success='N' RETURN END IF
      END IF
#No.FUN-540027 ---end--
   END IF
 
   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) THEN #入庫
      LET g_rvu01_1 = l_rvu.rvu01
   END IF
 
   IF (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN #驗退
      LET g_rvu01_2 = l_rvu.rvu01
   END IF
 
   IF l_rvu.rvu00 = '1' THEN
      LET l_rvu.rvu01 = g_rvu01_1 #入庫
   ELSE
      LET l_rvu.rvu01 = g_rvu01_2 #驗退
   END IF
 
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rvu_file
    WHERE rvu01 = l_rvu.rvu01
      AND rvuconf !='X'
      AND rvuconf !='Y'         #No.MOD-940325
      AND rvu02 = g_rva.rva01   #No.MOD-940325
 
   IF g_cnt >=1 THEN
      CALL t110_ins_rvv(l_rvu.rvu01,l_rvu.rvu00) #NO:7143單身  #FUN-810038
   ELSE
      LET l_rvu.rvu04=g_rva.rva05   #廠商編號
      SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
       WHERE pmc01=g_rva.rva05
      LET l_rvu.rvu06=g_grup        #部門
      LET l_rvu.rvu07=g_user        #人員
      LET l_rvu.rvu08=g_rva.rva10   #性質
      LET l_rvu.rvu09=NULL
      LET l_rvu.rvu20='N'           #三角貿易拋轉否no.4475
      LET l_rvu.rvuconf='N'         #確認碼
      LET l_rvu.rvuacti='Y'
      LET l_rvu.rvuuser=g_rva.rvauser
      LET l_rvu.rvugrup=g_rva.rvagrup
      LET l_rvu.rvumodu=' '
      LET l_rvu.rvudate=g_today
      #NO.FUN-960130---BEGIN----
      LET l_rvu.rvu21 = g_rva.rva29 
      LET l_rvu.rvuplant = g_rva.rvaplant
      LET l_rvu.rvulegal = g_rva.rvalegal
      LET l_rvu.rvu22 = g_rva.rva30
      LET l_rvu.rvu23 = g_rva.rva31
      LET l_rvu.rvucrat = g_today
      LET l_rvu.rvu900 = '0'
      LET l_rvu.rvumksg = 'N'
      LET l_rvu.rvupos = 'N'
      IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
      #NO.FUN-960130----END----
      LET l_rvu.rvuplant = g_plant #NO.FUN-980006 jarlin add
      LET l_rvu.rvulegal = g_legal #NO.FUN-980006 jarlin add
      INSERT INTO rvu_file VALUES (l_rvu.*)
      IF STATUS THEN
#        CALL cl_err('ins rvu:1',STATUS,1) #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:1",1) #No.FUN-660129
         IF g_bgerr THEN
            CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:1",STATUS,1)
         ELSE
            CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:1",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success='N'
      ELSE
         IF l_rvu.rvu00 = '1' THEN
            #產生的入庫異動單
#TQC-740117 begin
            CALL cl_err(l_rvu.rvu01,'apm-112',1)
##No.FUN-710030 -- begin --
##            CALL cl_err(l_rvu.rvu01,'apm-112',1)
#            IF g_bgerr THEN
#               CALL s_errmsg("","",l_rvu.rvu01,"apm-112",1)
#            ELSE
#               CALL cl_err3("","","","","apm-112","",l_rvu.rvu01,1)
#            END IF
##No.FUN-710030 -- end --
#TQC-740117 end
         ELSE
            #產生的驗退異動單
#TQC-740117 begin
            CALL cl_err(l_rvu.rvu01,'apm-124',1)
##No.FUN-710030 -- begin --
##            CALL cl_err(l_rvu.rvu01,'apm-124',1)
#      IF g_bgerr THEN
#         CALL s_errmsg("","",l_rvu.rvu01,"apm-124",1)
#      ELSE
#         CALL cl_err3("","","","","apm-124","",l_rvu.rvu01,1)
#      END IF
##No.FUN-710030 -- end --
#TQC-740117 end
         END IF
      END IF
      CALL t110_ins_rvv(l_rvu.rvu01,l_rvu.rvu00) #NO:7143單身  #FUN-810038
   END IF
 
END FUNCTION
 
FUNCTION t110_ins_rvv(p_rvv01,p_rvu00)     #FUN-810038
 DEFINE g_qcz     RECORD LIKE qcz_file.*
 DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
 DEFINE l_rvv     RECORD LIKE rvv_file.*,
        l_rvuconf LIKE rvu_file.rvuconf,
        l_smy57   LIKE type_file.chr1,     #MOD-740033 add
        l_t       LIKE smy_file.smyslip,   #MOD-740033 add
        p_rvv01   LIKE rvv_file.rvv01
 DEFINE p_rvu00   LIKE rvu_file.rvu00      #FUN-810038
&ifndef STD
 DEFINE l_rvvi    RECORD LIKE rvvi_file.*  #FUN-810038
 DEFINE l_ida     RECORD LIKE ida_file.*   #MOD-840263
 DEFINE l_idd     RECORD LIKE idd_file.*   #MOD-840263
&endif
 DEFINE l_flag    LIKE type_file.num5      #FUN-810038
 DEFINE l_sql     STRING  #No.FUN-810036
 DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-810036
 DEFINE l_pmm43   LIKE pmm_file.pmm43      #CHI-830033
 DEFINE l_cnt     LIKE type_file.num5      #MOD-840263
 
&ifdef ICD
   #FUN-810038................begin
      #委外TKY非最終站,不需產生至驗退
      IF p_rvu00 = '2' AND b_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF
   #FUN-810038................end
&endif
 
   LET l_rvv.rvv01 = p_rvv01 #NO:7143
 
   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00='0'
 
  #MOD-740033-begin-add
   LET l_t = s_get_doc_no(g_rva.rva01)
 
   SELECT smy57[3,3] INTO l_smy57 FROM smy_file
    WHERE smyslip=l_t
 
  #No.MOD-8A0112 mark --begin
  #上面已經判斷過了，所以這邊不需要再判斷
  #LET g_i = 0   #No.MOD-860330
  #IF l_smy57='N' THEN
  #   #-----No.MOD-860080-----
  #  ##----單身
  #  #SELECT COUNT(*) INTO g_i FROM rvv_file,rvu_file     #防止重覆過帳
  #  # WHERE rvv04=g_rva.rva01  #收貨單號
  #  #   AND rvv05=b_rvb.rvb02  #收貨項次
  #  #   AND rvu01=rvv01
  #  #   AND rvuconf != 'X'                               #排除已作廢之倉退單
  #   IF b_rvb.rvb30 >= b_rvb.rvb33 THEN
  #      LET g_i = 1
  #   END IF
  #   #-----No.MOD-860080 END-----
  #ELSE
  #  #MOD-740033-end-add
  #  #----單身
  #   SELECT COUNT(*) INTO g_i FROM rvv_file
  #   WHERE rvv04=g_rva.rva01  #收貨單號
  #     AND rvv05=b_rvb.rvb02  #收貨項次
  #END IF   #MOD-740033 add
  #
  #IF g_i > 0 THEN
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  #No.MOD-8A0112 mark --end
 
  #IF b_rvb.rvb33=0 THEN    #No.MOD-8A0112 mark
  #用傳入的參數判斷，允收數量不能准確判斷
   IF p_rvu00 = '2' THEN    #No.MOD-8A0112 add
     #No.MOD-8A0112 mark --begin
     #不需要再判斷能否生成驗退單，走到這一步就表示肯定可以
     #SELECT rvuconf INTO l_rvuconf FROM rvu_file
     # WHERE rvu01=l_rvv.rvv01 #入庫單號/退貨單號
     #   AND rvu02=g_rva.rva01 #收貨單號
     #   AND rvu00='2'         #2.驗退
     #   AND rvuconf !='X'
     #
     #IF l_rvuconf = 'Y' THEN
     #   LET g_success = 'N'
     #   RETURN
     #END IF
     #No.MOD-8A0112 mark --end
 
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvv.rvv01
 
      LET l_rvv.rvv03='2'                                  #異動類別
     #LET l_rvv.rvv17=b_rvb.rvb07  #No.MOD-8A0112 mark
     #這邊可以直接用本次可驗退量來賦值給異動數量
      LET l_rvv.rvv17 = g_out      #No.MOD-8A0112 add
 
      #No.FUN-540027  --begin
      IF g_sma.sma115 = 'Y' THEN
         LET l_rvv.rvv80=b_rvb.rvb80
         LET l_rvv.rvv81=b_rvb.rvb81
         LET l_rvv.rvv82=b_rvb.rvb82
         LET l_rvv.rvv83=b_rvb.rvb83
         LET l_rvv.rvv84=b_rvb.rvb84
         LET l_rvv.rvv85=b_rvb.rvb85
      END IF
 
      LET l_rvv.rvv86=b_rvb.rvb86
      LET l_rvv.rvv87=b_rvb.rvb87
      #No.FUN-540027  --end
   ELSE
     #No.MOD-8A0112 mark --begin
     #不需要再判斷能否生成入庫單，走到這一步就表示肯定可以
     #SELECT rvuconf INTO l_rvuconf FROM rvu_file
     # WHERE rvu01 = l_rvv.rvv01 #入庫單號/退貨單號
     #   AND rvu02 = g_rva.rva01 #收貨單號
     #   AND rvu00 = '1'         #1.入庫
     #   AND rvuconf != 'X'
     #
     #IF l_rvuconf = 'Y' THEN
     #   LET g_success = 'N'
     #   RETURN
     #END IF
     #No.MOD-8A0112 mark --end
 
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvv.rvv01
      LET l_rvv.rvv03='1'                                  #異動類別
     #LET l_rvv.rvv17=b_rvb.rvb07     #數量    #No.MOD-8A0112 mark
     #這里可以直接用本次可入庫量來賦值
      LET l_rvv.rvv17 = g_in                   #No.MOD-8A0112 add
 
      #No.FUN-540027  --begin
      IF g_sma.sma115 = 'Y' THEN
         LET l_rvv.rvv80=b_rvb.rvb80
         LET l_rvv.rvv81=b_rvb.rvb81
         LET l_rvv.rvv82=b_rvb.rvb82
         LET l_rvv.rvv83=b_rvb.rvb83
         LET l_rvv.rvv84=b_rvb.rvb84
         LET l_rvv.rvv85=b_rvb.rvb85
      END IF
      LET l_rvv.rvv86=b_rvb.rvb86
      LET l_rvv.rvv87=b_rvb.rvb87
      #No.FUN-540027  --end
    #No.MOD-8A0112 mark --begin
    #不需要這段了，rvv17的數量已經確定
    ##IF NOT cl_null(b_rvb.rvb33) THEN LET l_rvv.rvv17=b_rvb.rvb33 END IF
    # IF NOT cl_null(b_rvb.rvb33) THEN
    #    LET l_rvv.rvv17=b_rvb.rvb33 - b_rvb.rvb30   #No.MOD-860080
    # END IF
    #No.MOD-8A0112 mark --begin
      #No.FUN-580115  --begin
      IF NOT cl_null(b_rvb.rvb331) THEN LET l_rvv.rvv82=b_rvb.rvb331 END IF
      IF NOT cl_null(b_rvb.rvb332) THEN LET l_rvv.rvv85=b_rvb.rvb332 END IF
      #No.FUN-580115  --end
   END IF
 
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
   LET l_rvv.rvv04=g_rva.rva01     #驗收單號
   LET l_rvv.rvv05=b_rvb.rvb02     #驗收項次
   LET l_rvv.rvv06=g_rva.rva05     #廠商
   LET l_rvv.rvv09=g_today         #異動日
   LET l_rvv.rvv18=b_rvb.rvb34     #工單編號
   LET l_rvv.rvv23=0               #已請款匹配數量
   LET l_rvv.rvv88=0               #No.TQC-7B0083
   LET l_rvv.rvv24=NULL
   LET l_rvv.rvv25=b_rvb.rvb35     #樣品
   LET l_rvv.rvv26=NULL
   LET l_rvv.rvv31=b_rvb.rvb05     #料號
 
#FUN-940083--begin
   LET l_rvv.rvv89=b_rvb.rvb89     #FUN-940083 VMI收貨否 --add
 
   IF cl_null(l_rvv.rvv89) THEN
      LET l_rvv.rvv89 = 'N' 
   END IF
#FUN-940083--end
 
 
   #No.FUN-540027  --begin
   SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
   #No.FUN-540027  --end
 
   IF b_rvb.rvb05[1,4]='MISC' THEN      #品名
#FUN-940083--begin
#     SELECT pmn041 INTO l_rvv.rvv031 FROM pmn_file
#      WHERE pmn01=b_rvb.rvb04 AND pmn02=b_rvb.rvb03
      LET l_rvv.rvv031 = b_rvb.rvb051
#FUN-940083--end
   ELSE
      SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
       WHERE ima01=b_rvb.rvb05
   END IF
 
   LET l_rvv.rvv32=b_rvb.rvb36     #倉庫
   LET l_rvv.rvv33=b_rvb.rvb37     #儲位
   LET l_rvv.rvv34=b_rvb.rvb38     #批號
   IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
   IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
   IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
 
#FUN-940083--begin
  #SELECT pmn07,pmn09 INTO l_rvv.rvv35,l_rvv.rvv35_fac
  #  FROM pmn_file                 #單位,轉換率
  # WHERE pmn01 = b_rvb.rvb04
  #   AND pmn02 = b_rvb.rvb03
   LET l_rvv.rvv35 = b_rvb.rvb90
   LET l_rvv.rvv35_fac = b_rvb.rvb90_fac
#FUN-940083--end
 
   #-----MOD-8A0074---------
   IF g_sma.sma115='Y' THEN
      CALL t110_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,
                          l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
           RETURNING l_rvv.rvv87
   ELSE
      CALL t110_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,
                          l_rvv.rvv86,1,l_rvv.rvv35)
           RETURNING l_rvv.rvv87
   END IF
   #-----END MOD-8A0074-----
 
   #FUN-810038................begin
   LET l_flag=TRUE
&ifdef ICD
      LET l_rvvi.rvviicd07 = b_rvbi.rvbiicd13 #委外TKY非最終站否
      IF (l_rvvi.rvviicd07 = 'N' OR l_rvvi.rvviicd07 IS NULL 
          OR l_rvvi.rvviicd07 = ' ') THEN
         LET l_flag=TRUE  #委外TKY最終站
      ELSE
         LET l_flag=FALSE #委外TKY非最終站
      END IF
&else
&endif
   #FUN-810038................end
 
#MOD-790167-modify
#MOD-790167-add sma886[7,7]的check因免驗不直接入庫(sma886[7]='N')時
#不須檢查img_file的合理性
   IF NOT cl_null(l_rvv.rvv32) AND (g_sma.sma886[7,7] = 'Y') AND (l_flag) THEN  #FUN-810038
#MOD-790167-modify-end
      SELECT img09 INTO g_img09_t FROM img_file
       WHERE img01 = l_rvv.rvv31
         AND img02 = l_rvv.rvv32
         AND img03 = l_rvv.rvv33
         AND img04 = l_rvv.rvv34
      CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,g_img09_t)
           RETURNING g_i,l_rvv.rvv35_fac
      IF g_i = 1 THEN
         ### ------單位無法轉換--------####
#No.FUN-710030 -- begin --
#         CALL cl_err('rvv35/img09: ','abm-731',1)
         IF g_bgerr THEN
            CALL s_errmsg("","","rvv35/img09: ","abm-731",1)
         ELSE
            CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success ='N'
         RETURN
      END IF
 
      #No.FUN-540027  --begin
      LET g_ima906 = NULL
      LET g_ima907 = NULL
      SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
       WHERE ima01=l_rvv.rvv31
 
      IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
         IF NOT cl_null(l_rvv.rvv83) THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv83) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83,l_rvv.rvv84,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
               IF g_flag = 1 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
 
            #No.FUN-580115  --begin
            CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,g_ima906)
                 RETURNING g_errno,l_rvv.rvv84
            #No.FUN-580115  --end
 
            IF NOT cl_null(g_errno) THEN
#No.FUN-710030 -- begin --
#               CALL cl_err('rvv83/ima44: ','abm-731',1)
               IF g_bgerr THEN
                  CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)
               ELSE
                  CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)
               END IF
#No.FUN-710030 -- end --
               LET g_success = 'N' RETURN
            END IF
         END IF
 
         IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv80) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80,l_rvv.rvv81,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
               IF g_flag = 1 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
 
            CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                 RETURNING g_i,l_rvv.rvv81
            IF g_i = 1 THEN
#No.FUN-710030 -- begin --
#               CALL cl_err('rvv80/ima44: ','abm-731',1)
               IF g_bgerr THEN
                  CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)
               ELSE
                  CALL cl_err3("","","","","abm-731","","rvv80/ima44: ",1)
               END IF
#No.FUN-710030 -- end --
               LET g_success = 'N' RETURN
            END IF
         END IF
 
         #No.FUN-580115  --begin
         IF g_ima906 = '3' THEN
            IF l_rvv.rvv85 <> 0 THEN
               LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
            ELSE
               LET l_rvv.rvv84=0
            END IF
         END IF
         #No.FUN-580115  --end
      END IF
      #No.FUN-540027  ---end
 
      #No.FUN-580115  --begin
      #IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076  #TQC-770117 mark
         IF g_sma.sma115='Y' THEN
            CALL t110_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,
                                l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
                 RETURNING l_rvv.rvv87
         ELSE
            CALL t110_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,
                                l_rvv.rvv86,1,l_rvv.rvv35)
                 RETURNING l_rvv.rvv87
         END IF
      #END IF      #TQC-770117 mark
      #No.FUN-580115  --end
   END IF
 
   #No.FUN-540027  --begin
   IF cl_null(l_rvv.rvv86) THEN
      LET l_rvv.rvv86 = l_rvv.rvv35
      LET l_rvv.rvv87 = l_rvv.rvv17
   #MOD-840130-begin-add
   ELSE
   #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
   #而在入庫時又重推值
    IF l_rvv.rvv17=b_rvb.rvb07  THEN
       LET l_rvv.rvv87=b_rvb.rvb87
    END IF 
   #MOD-840130-end-add
   END IF
   #No.FUN-540027  --end
 
   LET l_rvv.rvv36=b_rvb.rvb04     #採購單號
   LET l_rvv.rvv37=b_rvb.rvb03     #採購單序號
   LET l_rvv.rvv38=b_rvb.rvb10
   LET l_rvv.rvv38t=b_rvb.rvb10t   #No.FUN-550117
   #No.FUN-540027  --begin
  #LET l_rvv.rvv39=l_rvv.rvv17*l_rvv.rvv38
  #LET l_rvv.rvv39t=l_rvv.rvv17*l_rvv.rvv38t   #No.FUN-540027
   LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
   LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t   #No.FUN-540027
   #No.FUN-540027  --end
   LET l_rvv.rvv41=b_rvb.rvb25     #手冊編號 no.A050
   LET l_rvv.rvv930=b_rvb.rvb930  #成本中心 #FUN-670051
   #NO.FUN-960130---BEGIN------
   LET l_rvv.rvv10 = b_rvb.rvb42
   LET l_rvv.rvv11 = b_rvb.rvb43
   LET l_rvv.rvv12 = b_rvb.rvb44
   LET l_rvv.rvv13 = b_rvb.rvb45
   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
   #NO.FUN-960130----END------
   LET t_azi04=''            #No.CHI-6A0004
 
   IF g_argv6='1' THEN           #FUN-940083--add
      SELECT azi04 INTO t_azi04  #No.CHI-6A0004
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = l_rvv.rvv36 #採購單號
         AND pmm18 <> 'X'
#FUN-940083--begin
   ELSE
      SELECT azi04 INTO t_azi04 
        FROM azi_file
       WHERE azi01=g_rva.rva113
   END IF
#FUN-940083--end
 
   IF cl_null(t_azi04) THEN  #No.CHI-6A0004
      LET t_azi04=0   #No.CHI-6A0004
   END IF
 
   CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   #No.CHI-6A0004
   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t #MOD-860297
 
   IF g_argv6='1' THEN               #FUN-940083
      #CHI-830033-begin-add
      #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
      SELECT gec07,pmm43 INTO g_gec07,l_pmm43 FROM gec_file,pmm_file
       WHERE gec01 = pmm21
         AND pmm01 = l_rvv.rvv36
      IF SQLCA.SQLCODE = 100 THEN
         CALL cl_err('','mfg3192',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_gec07='Y' THEN
         LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
         LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
      END IF
      #CHI-830033-end-add
#FUN-940083--begin
   ELSE
      SELECT gec07 INTO g_gec07 FROM gec_file
       WHERE gec01 = g_rva.rva115
      IF SQLCA.SQLCODE = 100 THEN
         CALL cl_err('','mfg3192',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_gec07='Y' THEN
         LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + g_rva.rva116/100)
         LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + g_rva.rva116/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
      END IF
   END IF
#FUN-940083--end
  
   LET l_rvv.rvv40 = 'N'
   #no.TQC-790003 start---
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
   #no.TQC-790003 end-----
 
&ifdef ICD
   #FUN-810038................begin
      LET l_rvvi.rvviicd07 = b_rvbi.rvbiicd13  #委外TKY非最終站否
      LET l_rvvi.rvviicd03 = b_rvbi.rvbiicd14  #母體料號
      LET l_rvvi.rvviicd05 = b_rvbi.rvbiicd16  #母批
      IF g_argv2 = 'SUB' THEN
         LET l_rvvi.rvviicd01 = b_rvbi.rvbiicd03  #作業編號
         LET l_rvvi.rvviicd02 = b_rvbi.rvbiicd08  #Date Code
         LET l_rvvi.rvviicd04 = b_rvbi.rvbiicd15  #產品型號
         LET l_rvvi.rvviicd06 = b_rvbi.rvbiicd11  #Tape Reel
 
         #判斷
         #若是產生入庫資料,則入庫異動數量必須等於,
         #    該收貨單刻號明細入庫否='Y'的總異動數量
         #若是產生驗退資料,則驗退異動數量必須等於,
         #    該收貨單刻號明細入庫否='N'的總異動數量
         IF l_rvvi.rvviicd07 ='N' OR cl_null(l_rvvi.rvviicd07) THEN #委外TKY,非最終站不檢查
            CALL t110_ind_icd_chk_icdin_yn(l_rvv.*,p_rvu00)
            IF g_success = 'N' THEN
               RETURN
            END IF
         END IF
      END IF
   #FUN-810038................end
&endif
 
   LET l_rvv.rvv88 = 0  #No.TQC-7B0083
   #NO.FUN-960130---BEGIN-----
   IF g_azw.azw04='2' THEN  
      IF g_prog = "apmt110" THEN
         IF g_rva.rva29 = '1' THEN
            LET l_rvv.rvv03 = '1'
         ELSE
            LET l_rvv.rvv03 = '4'
         END IF
      END IF
   END IF
   LET l_rvv.rvvlegal = g_rva.rvalegal
   #NO.FUN-960130-----END---
   LET l_rvv.rvvplant = g_plant #NO.FUN-980006 jarlin add
   LET l_rvv.rvvlegal = g_legal #NO.FUN-980006 jarlin add
   INSERT INTO rvv_file VALUES (l_rvv.*)
   IF STATUS THEN
#     CALL cl_err('i rvv:',STATUS,1)  #No.FUN-660129
#No.FUN-710030 -- begin --
#      CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1) #No.FUN-660129
      IF g_bgerr THEN
         LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
         CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success='N'
&ifndef STD
   #No.FUN-7B0018 080306 modify--begin
   ELSE
   #FUN-810038................begin
      LET l_rvvi.rvvi01=l_rvv.rvv01
      LET l_rvvi.rvvi02=l_rvv.rvv02
      IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
         LET g_success = 'N'
      END IF
&ifdef ICD     
      #MOD-840263.............begin #將收貨單的"刻號/BIN資料已過帳資料"帶入入庫單
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM idd_file 
                                WHERE idd10=l_rvv.rvv04
                                  AND idd11=l_rvv.rvv05
      IF l_cnt>0 THEN
      #mark by FUN-910077 改成CALL FUN
      ##No.TQC-880051--begin---modify
      #  #SELECT * INTO l_idd.* FROM idd_file
      #DECLARE sel_idd_1 CURSOR FOR
      #  SELECT * FROM idd_file WHERE idd10=l_rvv.rvv04
      #                           AND idd11=l_rvv.rvv05
      #FOREACH sel_idd_1 INTO l_idd.* 
      ##No.TQC-880051--end---modify
      #  INITIALIZE l_ida.* TO NULL
      #  LET l_ida.ida01 = l_rvv.rvv31    #料號            
      #  LET l_ida.ida02 = l_rvv.rvv32    #倉庫            
      #  LET l_ida.ida03 = l_rvv.rvv33    #儲位            
      #  LET l_ida.ida04 = l_rvv.rvv34    #批號            
      #  LET l_ida.ida05 = l_idd.idd05    #刻號            
      #  LET l_ida.ida06 = l_idd.idd06    #BIN             
      #  LET l_ida.ida07 = l_rvv.rvv01    #單據編號        
      #  LET l_ida.ida08 = l_rvv.rvv02    #單據項次        
      #  LET l_ida.ida09 = l_idd.idd08    #異動日期        
      #  LET l_ida.ida10 = l_idd.idd13    #實收數量        
      #  LET l_ida.ida11 = l_idd.idd26    #不良數量        
      #  LET l_ida.ida12 = l_idd.idd27    #報廢數量        
      #  LET l_ida.ida13 = l_idd.idd07    #單位            
      #  LET l_ida.ida14 = l_idd.idd15    #母體料號        
      #  LET l_ida.ida15 = l_idd.idd16    #母批            
      #  LET l_ida.ida16 = l_idd.idd17    #DATECODE        
      #  LET l_ida.ida17 = l_idd.idd18    #DIE 數          
      #  LET l_ida.ida18 = l_idd.idd19    #YIELD           
      #  LET l_ida.ida19 = l_idd.idd20    #TEST #          
      #  LET l_ida.ida20 = l_idd.idd21    #DEDUCT          
      #  LET l_ida.ida21 = l_idd.idd22    #PASS BIN        
      #  LET l_ida.ida22 = l_idd.idd23    #接單料號        
      #  LET l_ida.ida27 = l_idd.idd28    #轉入否          
      #  LET l_ida.ida28 = '1'            #異動別(出入庫別)
      #  LET l_ida.ida29 = l_idd.idd25    #備註            
      #  LET l_ida.ida26 = l_idd.idd24    #轉入否            
      #  LET l_ida.ida30 = b_rvb.rvb01    #來源單號
      #  LET l_ida.ida31 = b_rvb.rvb02    #來源項次
 
      #  INSERT INTO ida_file VALUES(l_ida.*) 
      #  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #     CALL cl_err('ins ida',SQLCA.sqlcode,1)
      #     LET g_success = 'N'
      #     RETURN
      #  END IF
      #END FOREACH    #TQC-880051 add
         #FUN-910077 add
         CALL t110_ind_icd_ins_icin(l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv04,
                                    l_rvv.rvv05,p_rvu00)
      END IF
      #MOD-840263.............end
   #FUN-810038................end
   #No.FUN-7B0018 080306 modify--end
&endif
&endif
   END IF
 
   #-----No.FUN-810036-----
   #帶入批/序號資料
   #-----No.FUN-840157-----
   #-----No.MOD-860080-----
  #IF b_rvb.rvb39 = "Y" THEN
  #   LET l_sql = "SELECT * FROM rvbs_file",
  #               " WHERE rvbs00 = 'aqct110'",
  #               "   AND rvbs01 = '",l_rvv.rvv04,"'",
  #               "   AND rvbs02 = ",l_rvv.rvv05,
  #               "   AND rvbs09 = 1"
  #ELSE
   IF g_sma.sma90 = "Y" THEN
      LET l_sql = "SELECT * FROM rvbs_file",
                  " WHERE rvbs00 = '",g_prog,"'",
                  "   AND rvbs01 = '",l_rvv.rvv04,"'",
                  "   AND rvbs02 = ",l_rvv.rvv05,
                  "   AND rvbs09 = 1",
                  "   AND rvbs13 = 0"   #No.FUN-860045
  #END IF
   #-----No.MOD-860080 END-----
   #-----No.FUN-840157 END-----
 
      PREPARE t110_rvbs FROM l_sql
      
      DECLARE rvbs_curs CURSOR FOR t110_rvbs
   
      FOREACH rvbs_curs INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs:',STATUS,1)
            EXIT FOREACH
         END IF
      
         IF g_rva.rva10='SUB' THEN
&ifndef ICD
            LET l_rvbs.rvbs00 = "apmt730"
&else
            LET l_rvbs.rvbs00 = "apmt730_icd"  #CHI-920064                        
&endif
         ELSE
          #-MOD-940365-add
            IF g_rva.rva10='TAP' THEN   
&ifndef ICD
               LET l_rvbs.rvbs00 = "apmt740"
&else
               LET l_rvbs.rvbs00 = "apmt740_icd" 
&endif
            ELSE
&ifndef ICD
               #-----MOD-990077---------
               #LET l_rvbs.rvbs00 = "apmt720"
               IF p_rvu00 = '2' THEN 
                  LET l_rvbs.rvbs00 = "apmt721"
               ELSE
                  LET l_rvbs.rvbs00 = "apmt720"
               END IF
               #-----END MOD-990077-----
&else
               #-----MOD-990077---------
               #LET l_rvbs.rvbs00 = "apmt720_icd"  #CHI-920064
               IF p_rvu00 = '2' THEN 
                  LET l_rvbs.rvbs00 = "apmt721_icd"
               ELSE
                  LET l_rvbs.rvbs00 = "apmt720_icd"
               END IF
               #-----END MOD-990077-----
&endif
            END IF
          #-MOD-940365-end
         END IF
 
         LET l_rvbs.rvbs01 = l_rvv.rvv01
         LET l_rvbs.rvbs02 = l_rvv.rvv02 
      
         #-----No.MOD-860080-----
 
         #-----MOD-990077---------
         IF p_rvu00 = '2' THEN 
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs10 
         ELSE
         #-----END MOD-990077-----
            IF l_rvbs.rvbs10 > 0 THEN
               #異動數量=允收量-入庫量
               LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11  
            END IF
         END IF   #MOD-990077-----
 
         LET l_rvbs.rvbs10 = 0
 
         LET l_rvbs.rvbs11 = 0
 
         LET l_rvbs.rvbs12 = 0
         #-----No.MOD-860080 END-----
 
         LET l_rvbs.rvbs13 = 0   #No.FUN-860045
 
         LET l_rvbs.rvbsplant = g_plant #NO.FUN-980006 jarlin add
         LET l_rvbs.rvbslegal = g_legal #NO.FUN-980006 jarlin add
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      
      END FOREACH
   END IF  #No.FUN-850100
   #-----No.FUN-810036 END-----
 
&ifdef ICD
   #FUN-810038................begin
   #-->若為委外收貨單,產生入庫資料後,重新給予入庫計價數量,單價,金額
   CALL t110_ind_icd_upd_rvvxx(l_rvv.*)
  #mark by FUN-910077 前面已經處理過,這段會造成-239 
  ##-->該收貨單有刻號明細資料時,產生入庫單的同時,一併複製產生給入庫單的刻號
  #IF g_sma.sma886[7,7] = 'Y' THEN    #TQC-880051
  #   CALL t110_ind_icd_ins_icin(l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv04,
  #                              l_rvv.rvv05,p_rvu00)
  #END IF     #TQC-880051
   #FUN-810038................end
&endif
 
END FUNCTION
 
FUNCTION t110_insrvu()
  DEFINE l_rvb   RECORD LIKE rvb_file.*,
         l_rvu   RECORD LIKE rvu_file.*,
         l_rvv   RECORD LIKE rvv_file.*,
         l_smy57 LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(01)
         l_t     LIKE smy_file.smyslip      #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
  DEFINE li_result LIKE type_file.num5      #No.FUN-540027 #No.FUN-680136 SMALLINT
  DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
&ifndef STD
  DEFINE l_rvvi  RECORD LIKE rvvi_file.*    #No.FUN-7B0018
  DEFINE l_idd   RECORD LIKE idd_file.*    #MOD-840263
  DEFINE l_ida   RECORD LIKE ida_file.*    #MOD-840263
&endif
  DEFINE l_sql     STRING  #No.FUN-810036
  DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-810036
  DEFINE l_pmm43   LIKE pmm_file.pmm43     #CHI-830033
  DEFINE l_cnt LIKE type_file.num5         #MOD-840263
  DEFINE l_n       LIKE type_file.num5         #NO.FUN-960130
 
   #-->判斷此驗收單是否已產生入庫
   SELECT COUNT(*) INTO g_i FROM rvu_file WHERE rvu02=g_rva.rva01
      AND rvuconf !='X'
   IF g_i>0 THEN LET g_success = 'N' RETURN END IF
   INITIALIZE l_rvu.* TO NULL
   #NO.FUN-960130---BEGIN------
   IF g_azw.azw04='2' THEN
      IF g_rva.rva29 = '1' THEN
         LET l_rvu.rvu00='1'
      ELSE
         LET l_rvu.rvu00='4'
      END IF
   ELSE
      LET l_rvu.rvu00='1'
   END IF
   #NO.FUN-960130----END------
   LET l_rvu.rvu00='1'                          #異動類別
   LET l_rvu.rvu02=g_rva.rva01                  #驗收單號
   #-----MOD-910053---------
   #LET l_rvu.rvu03=g_today                      #異動日期   
   IF g_flag2 = '1' THEN
      LET l_rvu.rvu03=g_rva.rva06                      #異動日期   
   ELSE
      LET l_rvu.rvu03=g_today                      #異動日期   
   END IF
   #-----END MOD-910053-----
 
  #MOD-990083   ---start                                                                                                            
   #若入庫日小於收貨日                                                                                                              
   IF l_rvu.rvu03<g_rva.rva06 THEN                                                                                                  
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)                                                                               
      ELSE                                                                                                                          
         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)                                                                       
      END IF                                                                                                                        
      LET g_success='N'                                                                                                             
      RETURN                                                                                                                        
   END IF                                                                                                                           
  #MOD-990083   ---end  
  
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
#No.FUN-710030 -- begin --
#      CALL cl_err(l_rvu.rvu03,'mfg9999',1)
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
      END IF
#No.FUN-710030 -- end --
      LET g_success='N'
      RETURN
   END IF
   CALL s_yp(l_rvu.rvu03) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      CALL cl_err(l_rvu.rvu03,'mfg6091',1)
      LET g_success='N'
      RETURN
   END IF
 
   LET l_t = s_get_doc_no(g_rva.rva01)       #No.FUN-540027
   SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57
     FROM smy_file WHERE smyslip=l_t
   IF l_rvu.rvu01 IS NULL THEN
#No.FUN-710030 -- begin --
#      CALL cl_err('smy52=NULL','apm-272',1)
      IF g_bgerr THEN
         CALL s_errmsg("","","smy52=NULL","apm-272",1)
      ELSE
         CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
      RETURN
   END IF
   #NO.FUN-960130----BEGIN--------
   SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip = l_rvu.rvu01
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("smyslip",l_rvu.rvu01,"sel smy_file","apm-068",1)
      ELSE 
         CALL cl_err(l_rvu.rvu01,'apm-068',1)
      END IF
      RETURN
   END IF
   #NO.FUN-960130-----END--------
   IF l_smy57='Y' THEN
#No.FUN-560060--begin
#     LET l_rvu.rvu01[4,10]=g_rva.rva01[4,10]      #入庫單號
      LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=g_rva.rva01[g_no_sp-1,g_no_ep]      #入庫單號
#No.FUN-560060--end
      SELECT COUNT(*) INTO g_cnt FROM rvu_file WHERE rvu01=l_rvu.rvu01
         AND rvuconf != 'X'
      IF g_cnt > 0 THEN
#No.FUN-540027 --start--
        LET l_t = l_rvu.rvu01[1,g_doc_len]         #No.FUN-560060
        CALL s_auto_assign_no("apm",l_t,g_rva.rva06,"","","","","","")
             RETURNING li_result,l_rvu.rvu01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN #TQC-750097
        END IF
#        DISPLAY BY NAME g_rva.rva01
#         CALL s_smyauno(l_t,g_rva.rva06) RETURNING g_i,l_rvu.rvu01
#         IF g_i THEN LET g_success='N' RETURN END IF
      END IF
   ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len]        #No.FUN-560060
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
             LET g_success='N'
             RETURN #TQC-750097
         END IF
#      CALL s_smyauno(l_t,l_rvu.rvu03) RETURNING g_i,l_rvu.rvu01
#      IF g_i THEN LET g_success='N' RETURN END IF
   END IF
#No.FUN-540027 --end-
 
   LET l_rvu.rvu04=g_rva.rva05                  #廠商編號
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
   WHERE pmc01=g_rva.rva05
   LET l_rvu.rvu06=g_grup        #部門
   LET l_rvu.rvu07=g_user        #人員
   LET l_rvu.rvu08=g_rva.rva10   #性質
   LET l_rvu.rvu09=NULL
   LET l_rvu.rvuconf='N'         #確認碼
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvu20='N'           #三角貿易拋轉否 no.4475
   LET l_rvu.rvuuser=g_rva.rvauser
   LET l_rvu.rvugrup=g_rva.rvagrup
   LET l_rvu.rvumodu=' '
   LET l_rvu.rvudate=g_today
   #NO.FUN-960130---BEGIN----
   LET l_rvu.rvu21 = g_rva.rva29  
   LET l_rvu.rvuplant = g_rva.rvaplant
   LET l_rvu.rvulegal = g_rva.rvalegal
   LET l_rvu.rvu22 = g_rva.rva30
   LET l_rvu.rvu23 = g_rva.rva31
   LET l_rvu.rvu900 = '0'
   LET l_rvu.rvumksg = 'N'
   LET l_rvu.rvucrat = g_today
   LET l_rvu.rvupos = 'N'
   IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
   #NO.FUN-960130----END----
   LET l_rvu.rvuplant = g_plant #NO.FUN-980006 jarlin add
   LET l_rvu.rvulegal = g_legal #NO.FUN-980006 jarlin add
   INSERT INTO rvu_file VALUES (l_rvu.*)
   IF STATUS THEN
#     CALL cl_err('ins rvu:2',STATUS,1)  #No.FUN-660129
#No.FUN-710030 -- begin --
#      CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:2",1) #No.FUN-660129
      IF g_bgerr THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:2",STATUS,1)
      ELSE
         CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:2",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success='N'
      RETURN #TQC-750097
   END IF
   #-->單身
   DECLARE t110_y1 CURSOR WITH HOLD FOR
      SELECT * FROM rvb_file
       WHERE rvb01=g_rva.rva01
         AND rvb39='N' #檢驗否為'N' #NO:7143
 
   FOREACH t110_y1 INTO l_rvb.*
&ifdef ICD
      #-----MOD-9B0011---------
      SELECT * INTO b_rvbi.* FROM rvbi_file
       WHERE rvbi01=l_rvb.rvb01  
         AND rvbi02=l_rvb.rvb02  
      #-----END MOD-9B0011-----
&endif

      LET l_rvv.rvv01=l_rvu.rvu01     #單號
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvu.rvu01
      IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
      LET l_rvv.rvv03='1'             #異動類別
      LET l_rvv.rvv04=g_rva.rva01     #驗收單號
      LET l_rvv.rvv05=l_rvb.rvb02     #驗收項次
      LET l_rvv.rvv06=g_rva.rva05     #廠商
      #-----MOD-970023---------
      #LET l_rvv.rvv09=g_today         #異動日  
      IF g_flag2 = '1' THEN
         LET l_rvv.rvv09=g_rva.rva06                      #異動日期   
      ELSE
         LET l_rvv.rvv09=g_today                      #異動日期   
      END IF
      #-----END MOD-970023-----
      LET l_rvv.rvv17=l_rvb.rvb07     #數量
      IF NOT cl_null(l_rvb.rvb33) THEN LET l_rvv.rvv17=l_rvb.rvb33 END IF
      #No.FUN-580115  --begin
      IF NOT cl_null(l_rvb.rvb331) THEN LET l_rvv.rvv82=l_rvb.rvb331 END IF
      IF NOT cl_null(l_rvb.rvb332) THEN LET l_rvv.rvv85=l_rvb.rvb332 END IF
      #No.FUN-580115  --end
      #if rvv33 <> rvv07 ,it will occur errors
      #No.FUN-540027  --begin
      IF g_sma.sma115 = 'Y' THEN
         LET l_rvv.rvv80=l_rvb.rvb80
         LET l_rvv.rvv81=l_rvb.rvb81
         LET l_rvv.rvv82=l_rvb.rvb82
         LET l_rvv.rvv83=l_rvb.rvb83
         LET l_rvv.rvv84=l_rvb.rvb84
         LET l_rvv.rvv85=l_rvb.rvb85
      END IF
      LET l_rvv.rvv86=l_rvb.rvb86
      LET l_rvv.rvv87=l_rvb.rvb87
      #No.FUN-540027  --end
      LET l_rvv.rvv18=l_rvb.rvb34     #工單編號
      LET l_rvv.rvv23=0               #已請款匹配數量
      LET l_rvv.rvv88=0               #No.TQC-7B0083
      LET l_rvv.rvv24=NULL
      LET l_rvv.rvv89=l_rvb.rvb89     #VMI收貨否 #FUN-940083-add
      LET l_rvv.rvv25=l_rvb.rvb35     #樣品
      LET l_rvv.rvv26=NULL
      LET l_rvv.rvv31=l_rvb.rvb05     #料號
      IF l_rvb.rvb05[1,4]='MISC' THEN      #品名
#FUN-940083--begin
#        SELECT pmn041 INTO l_rvv.rvv031 FROM pmn_file
#         WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03
         LET l_rvv.rvv031 = l_rvb.rvb051
#FUN-940083--end
      ELSE
         SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
          WHERE ima01=l_rvb.rvb05
      END IF
      #No.FUN-540027  --begin
      SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
      #No.FUN-540027  --end
      LET l_rvv.rvv32=l_rvb.rvb36     #倉庫
      LET l_rvv.rvv33=l_rvb.rvb37     #儲位
      LET l_rvv.rvv34=l_rvb.rvb38     #批號
      IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
      IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
      IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
 
#FUN-940083--begin
#     # 重取換算
#     SELECT pmn07,pmn09 INTO l_rvv.rvv35,l_rvv.rvv35_fac
#       FROM pmn_file                 #單位,轉換率
#      WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03
      LET l_rvv.rvv35 = l_rvb.rvb90
      LET l_rvv.rvv35_fac = l_rvb.rvb90_fac
#FUN-940083--end
      IF NOT cl_null(l_rvv.rvv32) THEN
         SELECT img09 INTO g_img09_t FROM img_file
          WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
            AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34
 
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,g_img09_t)
              RETURNING g_i,l_rvv.rvv35_fac
 
         IF g_i = 1 THEN
            ### ------單位無法轉換--------####
#No.FUN-710030 -- begin --
#            CALL cl_err('rvv35/img09: ','abm-731',1)
            IF g_bgerr THEN
               CALL s_errmsg("","","rvv35/img09: ","abm-731",1)
            ELSE
               CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success ='N'
            RETURN
         END IF
         #No.FUN-540027  --begin
         LET g_ima906 = NULL
         LET g_ima907 = NULL
 
         SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
          WHERE ima01=l_rvv.rvv31
 
         IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
            IF NOT cl_null(l_rvv.rvv83) THEN
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83) RETURNING g_flag
 
               IF g_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv84,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
               #No.FUN-580115  --begin
               CALL s_du_umfchk(l_rvv.rvv31,'','','',
                                l_ima44,l_rvv.rvv83,g_ima906)
               #No.FUN-580115  --end
                    RETURNING g_errno,l_rvv.rvv84
               IF NOT cl_null(g_errno) THEN
#No.FUN-710030 -- begin --
#                  CALL cl_err('rvv83/ima44: ','abm-731',1)
                  IF g_bgerr THEN
                     CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)
                  ELSE
                     CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
 
            IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80) RETURNING g_flag
               IF g_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv80,l_rvv.rvv81,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
                  IF g_flag = 1 THEN
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                    RETURNING g_i,l_rvv.rvv81
               IF g_i = 1 THEN
#No.FUN-710030 -- begin --
#                  CALL cl_err('rvv80/ima44: ','abm-731',1)
                  IF g_bgerr THEN
                     CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","rvv80/ima44: ",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
 
            #No.FUN-580115  --begin
            IF g_ima906 = '3' THEN
               IF l_rvv.rvv85 <> 0 THEN
                  LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
               ELSE
                  LET l_rvv.rvv84=0
               END IF
            END IF
            #No.FUN-540027  --end
         END IF
 
         #No.FUN-580115  --begin
         #IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076  #TQC-770117 mark
            IF g_sma.sma115='Y' THEN
               CALL t110_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,
                                   l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
                    RETURNING l_rvv.rvv87
            ELSE
               CALL t110_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,
                                   l_rvv.rvv86,1,l_rvv.rvv35)
                    RETURNING l_rvv.rvv87
            END IF
         #END IF      #TQC-770117 mark
         #No.FUN-580115  --end
      END IF
 
      LET l_rvv.rvv36=l_rvb.rvb04     #採購單號
      LET l_rvv.rvv37=l_rvb.rvb03     #採購單序號
      LET l_rvv.rvv38=l_rvb.rvb10
      LET l_rvv.rvv38t=l_rvb.rvb10t   #No.FUN-550117
 
      #No.FUN-540027  --begin
      IF cl_null(l_rvv.rvv86) THEN
         LET l_rvv.rvv86 = l_rvv.rvv35
         LET l_rvv.rvv87 = l_rvv.rvv17
       #MOD-840130-begin-add
      ELSE
       #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
       #而在入庫時又重推值
        IF l_rvv.rvv17=l_rvb.rvb07  THEN
           LET l_rvv.rvv87=l_rvb.rvb87
        END IF 
       #MOD-840130-end-add
      END IF
 
     #LET l_rvv.rvv39=l_rvv.rvv17*l_rvv.rvv38
     #LET l_rvv.rvv39t=l_rvv.rvv17*l_rvv.rvv38t  #No.FUN-540027
      LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
      LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t  #No.FUN-540027
      #No.FUN-540027  --end
      LET l_rvv.rvv41=l_rvb.rvb25     #手冊編號 A050
      LET t_azi04=''   #No.CHI-6A0004
      IF g_argv6='1' THEN           #FUN-940083--add
         SELECT azi04 INTO t_azi04  #No.CHI-6A0004
           FROM pmm_file,azi_file
          WHERE pmm22=azi01
            AND pmm01 = l_rvv.rvv36 #採購單號
            AND pmm18 <> 'X'
#FUN-940083--begin
      ELSE
         SELECT azi04 INTO t_azi04 
           FROM azi_file
          WHERE azi01=g_rva.rva113
      END IF                        
#FUN-940083--end
 
      IF cl_null(t_azi04) THEN  #No.CHI-6A0004
         LET t_azi04=0          #No.CHI-6A0004
      END IF
 
      CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   #No.CHI-6A0004
      CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t #MOD-860297
 
      IF g_argv6='1' THEN           #FUN-940083--add
         #CHI-830033-begin-add
         #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
         SELECT gec07,pmm43 INTO g_gec07,l_pmm43 FROM gec_file,pmm_file
          WHERE gec01 = pmm21
            AND pmm01 = l_rvv.rvv36
         IF SQLCA.SQLCODE = 100 THEN
            CALL cl_err('','mfg3192',0)
            LET g_success = 'N'
            RETURN
         END IF
         IF g_gec07='Y' THEN
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
         ELSE
            LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
            LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
         END IF
         #CHI-830033-end-add
#FUN-940083--begin
      ELSE
         #不使用單價*數量=金額,改以金額回推稅率,以避免小數位差的問題
         SELECT gec07 INTO g_gec07 FROM gec_file
          WHERE gec01 = g_rva.rva115
         IF SQLCA.SQLCODE = 100 THEN
            CALL cl_err('','mfg3192',0)
            LET g_success = 'N'
            RETURN
         END IF
         IF g_gec07 = 'Y' THEN
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + g_rva.rva116/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
         ELSE
            LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + g_rva.rva116/100)
            LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)
         END IF
      END IF
#FUN-940083--end
 
      LET l_rvv.rvv40 = 'N'      #no.5748 (default 為非沖暫估)
      LET l_rvv.rvv930=l_rvb.rvb930  #FUN-670051
      #no.TQC-790003 start---
      IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
      #no.TQC-790003 end-----
      LET l_rvv.rvv88 = 0  #No.TQC-7B0083
      #NO.FUN-960130---BEGIN------
      LET l_rvv.rvv10 = l_rvb.rvb42
      LET l_rvv.rvv11 = l_rvb.rvb43
      LET l_rvv.rvv12 = l_rvb.rvb44
      LET l_rvv.rvv13 = l_rvb.rvb45
      LET l_rvv.rvvplant = g_rva.rvaplant
      LET l_rvv.rvvlegal = g_rva.rvalegal
      IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
      #NO.FUN-960130-----END---
      LET l_rvv.rvvplant = g_plant #NO.FUN-980006 jarlin add
      LET l_rvv.rvvlegal = g_legal #NO.FUN-980006 jarlin add
      INSERT INTO rvv_file VALUES (l_rvv.*)
      IF STATUS THEN
#        CALL cl_err('i rvv:',STATUS,1)  #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1) #No.FUN-660129
         IF g_bgerr THEN
            LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
            CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'
         RETURN #TQC-750097
&ifndef STD
      #No.FUN-7B0018 080306 add--begin
      ELSE
         INITIALIZE l_rvvi.* TO NULL
&ifdef ICD
        #FUN-910077................begin
        LET l_rvvi.rvviicd07 = b_rvbi.rvbiicd13  #委外TKY非最終站否
        LET l_rvvi.rvviicd03 = b_rvbi.rvbiicd14  #母體料號
        LET l_rvvi.rvviicd05 = b_rvbi.rvbiicd16  #母批
        IF g_argv2 = 'SUB' THEN
           LET l_rvvi.rvviicd01 = b_rvbi.rvbiicd03  #作業編號
           LET l_rvvi.rvviicd02 = b_rvbi.rvbiicd08  #Date Code
           LET l_rvvi.rvviicd04 = b_rvbi.rvbiicd15  #產品型號
           LET l_rvvi.rvviicd06 = b_rvbi.rvbiicd11  #Tape Reel
        
           #判斷
           #若是產生入庫資料,則入庫異動數量必須等於,
           #    該收貨單刻號明細入庫否='Y'的總異動數量
           #若是產生驗退資料,則驗退異動數量必須等於,
           #    該收貨單刻號明細入庫否='N'的總異動數量
           IF l_rvvi.rvviicd07 ='N' OR cl_null(l_rvvi.rvviicd07) THEN #委外TKY,非最終站不檢查
              CALL t110_ind_icd_chk_icdin_yn(l_rvv.*,'1')  #免檢料入庫,第二參數皆為'1'
              IF g_success = 'N' THEN
                 RETURN
              END IF
           END IF
        END IF
        #FUN-910077................end
&endif
         LET l_rvvi.rvvi01 = l_rvv.rvv01
         LET l_rvvi.rvvi02 = l_rvv.rvv02
         IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      #No.FUN-7B0018 080306 add--end
&ifdef ICD     
      #MOD-840263.............begin #將收貨單的"刻號/BIN資料已過帳資料"帶入入庫單
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM idd_file 
                                WHERE idd10=l_rvv.rvv04
                                  AND idd11=l_rvv.rvv05
      IF l_cnt>0 THEN
        #SELECT * INTO l_idd.* FROM idd_file  #No.MOD-890023 mark
       DECLARE sel_idd_2 CURSOR FOR           #No.MOD-890023 add
         SELECT * FROM idd_file               #No.MOD-890023 add
                      WHERE idd10=l_rvv.rvv04
                        AND idd11=l_rvv.rvv05
       FOREACH sel_idd_2 INTO l_idd.*         #No.MOD-890023 add
         INITIALIZE l_ida.* TO NULL
         LET l_ida.ida01 = l_rvv.rvv31    #料號            
         LET l_ida.ida02 = l_rvv.rvv32    #倉庫            
         LET l_ida.ida03 = l_rvv.rvv33    #儲位            
         LET l_ida.ida04 = l_rvv.rvv34    #批號            
         LET l_ida.ida05 = l_idd.idd05    #刻號            
         LET l_ida.ida06 = l_idd.idd06    #BIN             
         LET l_ida.ida07 = l_rvv.rvv01    #單據編號        
         LET l_ida.ida08 = l_rvv.rvv02    #單據項次        
         LET l_ida.ida09 = l_idd.idd08    #異動日期        
         LET l_ida.ida10 = l_idd.idd13    #實收數量        
         LET l_ida.ida11 = l_idd.idd26    #不良數量        
         LET l_ida.ida12 = l_idd.idd27    #報廢數量        
         LET l_ida.ida13 = l_idd.idd07    #單位            
         LET l_ida.ida14 = l_idd.idd15    #母體料號        
         LET l_ida.ida15 = l_idd.idd16    #母批            
         LET l_ida.ida16 = l_idd.idd17    #DATECODE        
         LET l_ida.ida17 = l_idd.idd18    #DIE 數          
         LET l_ida.ida18 = l_idd.idd19    #YIELD           
         LET l_ida.ida19 = l_idd.idd20    #TEST #          
         LET l_ida.ida20 = l_idd.idd21    #DEDUCT          
         LET l_ida.ida21 = l_idd.idd22    #PASS BIN        
         LET l_ida.ida22 = l_idd.idd23    #接單料號        
         LET l_ida.ida27 = l_idd.idd28    #轉入否          
         LET l_ida.ida28 = '1'            #異動別(出入庫別)
         LET l_ida.ida29 = l_idd.idd25    #備註            
         LET l_ida.ida26 = l_idd.idd24    #轉入否            
         LET l_ida.ida30 = b_rvb.rvb01    #來源單號
         LET l_ida.ida31 = b_rvb.rvb02    #來源項次
 
         LET l_ida.idaplant = g_plant #NO.FUN-980006 jarlin add
         LET l_ida.idalegal = g_legal #NO.FUN-980006 jarlin add
         INSERT INTO ida_file VALUES(l_ida.*) 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('ins ida',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
       END FOREACH      #No.MOD-890023 add
      END IF
      #MOD-840263.............end
&endif
&endif
      END IF
 
      #-----No.FUN-810036-----
      #帶入批/序號資料
      #-----No.FUN-840157-----
      #-----No.MOD-860080-----
     #IF b_rvb.rvb39 = "Y" THEN
     #   LET l_sql = "SELECT * FROM rvbs_file",
     #               " WHERE rvbs00 = 'aqct110'",
     #               "   AND rvbs01 = '",l_rvv.rvv04,"'",
     #               "   AND rvbs02 = ",l_rvv.rvv05,
     #               "   AND rvbs09 = 1"
     #ELSE
      IF g_sma.sma90 = "Y" THEN
         LET l_sql = "SELECT * FROM rvbs_file",
                     " WHERE rvbs00 = '",g_prog,"'",
                     "   AND rvbs01 = '",l_rvv.rvv04,"'",
                     "   AND rvbs02 = ",l_rvv.rvv05,
                     "   AND rvbs09 = 1",
                     "   AND rvbs13 = 0"   #No.FUN-860045
     #END IF
      #-----No.MOD-860080 END-----
      #-----No.FUN-840157 END-----
 
         PREPARE t110_rvbs2 FROM l_sql
         
         DECLARE rvbs_curs2 CURSOR FOR t110_rvbs2
         
         FOREACH rvbs_curs2 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('foreach rvbs:',STATUS,1)
               EXIT FOREACH
            END IF
         
            IF g_rva.rva10='SUB' THEN
&ifndef ICD
               LET l_rvbs.rvbs00 = "apmt730"
&else
               LET l_rvbs.rvbs00 = "apmt730_icd"  #CHI-920064                        
&endif
            ELSE
          #-MOD-940365-add
              IF g_rva.rva10='TAP' THEN   
&ifndef ICD
                 LET l_rvbs.rvbs00 = "apmt740"
&else
                 LET l_rvbs.rvbs00 = "apmt740_icd" 
&endif
              ELSE
&ifndef ICD
                 LET l_rvbs.rvbs00 = "apmt720"
&else
                 LET l_rvbs.rvbs00 = "apmt720_icd"  #CHI-920064
&endif
              END IF
          #-MOD-940365-end
            END IF
            LET l_rvbs.rvbs01 = l_rvv.rvv01
            LET l_rvbs.rvbs02 = l_rvv.rvv02 
         
            #-----No.MOD-860080-----
            LET l_rvbs.rvbs10 = 0
         
            LET l_rvbs.rvbs11 = 0
         
            LET l_rvbs.rvbs12 = 0
            #-----No.MOD-860080 END-----
         
            LET l_rvbs.rvbs13 = 0   #No.FUN-860045
         
            LET l_rvbs.rvbsplant = g_plant #NO.FUN-980006 jarlin add
            LET l_rvbs.rvbslegal = g_legal #NO.FUN-980006 jarlin add
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
               LET g_success = "N"
               CONTINUE FOREACH
            END IF
         
         END FOREACH
         #-----No.FUN-810036 END-----
      END IF     #No.MOD-860080
 
   END FOREACH
 
END FUNCTION
 
FUNCTION t110_z()     #取消確認
   DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_rvb04  LIKE rvb_file.rvb04
   DEFINE l_poz011 LIKE poz_file.poz011
   DEFINE l_rvb    RECORD LIKE rvb_file.*
   DEFINE l_pmm25  LIKE pmm_file.pmm25
&ifndef STD
   DEFINE l_rvbi   RECORD LIKE rvbi_file.*  #FUN-810038
&endif
   DEFINE l_pmn07  LIKE pmn_file.pmn07  #FUN-810038
   DEFINE l_flag   LIKE type_file.num5  #FUN-810038
 
   IF cl_null(g_rva.rva01) THEN
      RETURN
   END IF
 
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
 
   IF g_argv6 ='1' THEN       #FUN-940083--add
#FUN-5A0090 add--start 已結案的採購單不可取消確認
      LET l_pmm25 = ''
      SELECT pmm25 INTO l_pmm25 FROM pmm_file
       WHERE pmm01 = g_rva.rva02
      IF l_pmm25 = '6' THEN
        CALL cl_err(g_rva.rva02,'apm-056',0)
        RETURN
      END IF
   END IF                     #FUN-940083--add
#FUN-5A0090 add--end
 
#FUN-940083--begin
   #-- 若為VMI發料結算還原時,不可取消確認
   IF NOT cl_null(g_rva.rva117) AND g_argv5 <>'V' THEN
      CALL cl_err(g_rva.rva02,'apm-059',0)
      RETURN
   END IF
#FUN-940083--end
 
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
      CALL cl_err(g_rva.rva01,'apm-248',0)
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
&ifdef ICD
   #FUN-810038................begin
      #若為回貨收貨,提示[回貨轉入的收貨單確定要取消確認]
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt 
        FROM rvb_file,rvbi_file
        WHERE rvb01 = g_rva.rva01
          AND rvbi01= rvb01
          AND rvbiicd09 = 'Y'
 
      IF g_cnt > 0 THEN
         CALL cl_err(g_rva.rva01,'aic-120',0)
      END IF
   #FUN-810038................end
&endif
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
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
      UPDATE rvb_file
         SET rvb33 = 0   ,#允收數量
             #No.FUN-580115  --begin
             rvb331=0,
             rvb332=0,
             #No.FUN-580115  --end
             #rvb39 = NULL,#檢驗否   #MOD-530415
             rvb40 = NULL,#檢驗日期
             rvb41 = NULL #檢驗結果
       WHERE rvb01 = l_rvb.rvb01
         AND rvb02 = l_rvb.rvb02
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('UPDATE rvb_file',SQLCA.sqlcode,0) #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1) #No.FUN-660129
         IF g_bgerr THEN
            LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02
            CALL s_errmsg("rvb01,rvb02",g_showmsg,"UPDATE rvb_file",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'
         ROLLBACK WORK   #MOD-810073 add
         RETURN
      END IF
&ifdef ICD
      #FUN-810038................begin
         SELECT * INTO l_rvbi.*
           FROM rvbi_file
          WHERE rvbi01=l_rvb.rvb01
            AND rvbi02=l_rvb.rvb02
         #判斷若為委外收貨單TKY,非最後一站的項次,不做收貨確認
         IF l_rvbi.rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
         
         IF g_argv2 = 'SUB' OR g_argv2='ICD' THEN
            LET l_pmn07 = NULL
            SELECT pmn07 INTO l_pmn07 
              FROM pmn_file
             WHERE pmn01 = l_rvb.rvb04 
               AND pmn02 = l_rvb.rvb03
            CALL s_icdpost(0,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                           l_pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                           g_rva.rva06,'N','','','')  
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
      #FUN-810038................end
&endif
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
   #-----更新單頭確認碼
   #NO.FUN-960130---BEGIN----
   #UPDATE rva_file SET rvaconf = 'N'
   # WHERE rva01 = g_rva.rva01
   UPDATE rva_file SET rvaconf = 'N',rvaconu = NULL,rvacond = NULL
      WHERE rva01 = g_rva.rva01
   #NO.FUN-960130-----END-----
   IF STATUS THEN LET g_success = 'N' END IF
 
   CALL t110_z1()
 
   CALL cl_msg("")
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      LET g_rva.rvaconf='N'
      LET g_rva.rvacond = ''    #NO.FUN-960130
      LET g_rva.rvaconu = ''    #NO.FUN-960130
      COMMIT WORK
   ELSE
      LET g_rva.rvaconf='Y'
      ROLLBACK WORK
   END IF
 
   DISPLAY BY NAME g_rva.rvaconf
   DISPLAY BY NAME g_rva.rvaconu,g_rva.rvacond    #NO.FUN-960130
   CALL t110_show()
 
   IF g_rva.rvaconf='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
 
   CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")
 
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
&ifndef STD
   DEFINE l_rvbi   RECORD  LIKE rvbi_file.*  #FUN-810038
&endif
 
   DECLARE t110_z CURSOR WITH HOLD FOR
     SELECT * FROM rvb_file WHERE rvb01=g_rva.rva01
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_z INTO l_rvb.*
      IF STATUS THEN
         LET g_success = 'N'  #No.FUN-8A0086
#No.FUN-710030 -- begin --
#         CALL cl_err('foreach:',STATUS,0)
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
#No.FUN-710030 -- end --
         EXIT FOREACH
      END IF
&ifdef ICD
      #FUN-810038................begin
         SELECT * INTO l_rvbi.*
           FROM rvbi_file
          WHERE rvbi01=l_rvb.rvb01
            AND rvbi02=l_rvb.rvb02
         #判斷若為委外收貨單TKY,非最後一站的項次,不做收貨確認
         IF l_rvbi.rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
      #FUN-810038................end
&endif
 
      IF g_argv6='1' THEN               #FUN-940083--add
         #No.TQC-880009 add----begin
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
         #No.TQC-880009 add----end
      END IF              #FUN-940083--add
 
     #-----No.MOD-610034-----
      SELECT sfb04 INTO l_sfb04 FROM sfb_file   #工單
       WHERE sfb01 = l_rvb.rvb34
      IF l_sfb04 = "8" THEN
#No.FUN-710030 -- begin --
#         CALL cl_err(l_rvb.rvb34,"asf-070",1)
         IF g_bgerr THEN
            CALL s_errmsg("","",l_rvb.rvb34,"asf-070",1)
         ELSE
            CALL cl_err3("","","","","asf-070","",l_rvb.rvb34,1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'
         RETURN
      END IF
     #-----No.MOD-610034 END-----
 
 
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
#No.FUN-710030 -- begin --
#           CALL cl_err("OPEN t110_pmn2:", STATUS, 1)
           IF g_bgerr THEN
              CALL s_errmsg("","","OPEN t110_pmn2:",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","OPEN t110_pmn2:",1)
           END IF
#No.FUN-710030 -- end --
           CLOSE t110_pmn2
          #ROLLBACK WORK                                  #CHI-840071
           LET g_success = 'N'                            #CHI-840071
           RETURN
         END IF
         FETCH t110_pmn2 INTO l_pmn09,l_pmn011,l_pmn40,l_pmn07  
#No.TQC-930155-start-
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
#No.TQC-930155--end--
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
#No.FUN-710030 -- begin --
#            CALL cl_err("OPEN t110_ima2:", STATUS, 1)
            IF g_bgerr THEN
               CALL s_errmsg("","","OPEN t110_ima2:",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","OPEN t110_ima2:",1)
            END IF
#No.FUN-710030 -- end --
            CLOSE t110_ima2
           #ROLLBACK WORK                                  #CHI-840071
            LET g_success = 'N'                            #CHI-840071
            RETURN
         END IF
 
         FETCH t110_ima2 INTO l_ima25,l_ima86
         IF SQLCA.sqlcode THEN
#No.FUN-710030 -- begin --
#            CALL cl_err('fetch:',SQLCA.sqlcode,0)
            IF g_bgerr THEN
               CALL s_errmsg("","","fetch:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch:",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
            RETURN
         END IF
 
#        CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_ima25) RETURNING l_cnt,l_factor1        #FUN-940083
         CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25) RETURNING l_cnt,l_factor1    #FUN-940083
 
         IF l_cnt = 1 THEN
#No.FUN-710030 -- begin --
#            CALL cl_err('pmn07/ima25: ','abm-731',1)
            IF g_bgerr THEN
#              CALL s_errmsg("","","pmn07/ima25: ","abm-731",1)    #FUN-940083
               CALL s_errmsg("","","rvb90/ima25: ","abm-731",1)    #FUN-940083
            ELSE   
#              CALL cl_err3("","","","","abm-731","","pmn07/ima25: ",1) #FUN-940083
               CALL cl_err3("","","","","abm-731","","rvb90/ima25: ",1) #FUN-940083
            END IF
#No.FUN-710030 -- end --
            LET g_success ='N'
         END IF
      END IF
 
      IF l_rvb.rvb35 = 'N' THEN
&ifdef ICD
         #FUN-810038................begin
            SELECT SUM(rvb07) INTO l_rvb.rvb07     #計算此採購單已收量
              FROM rva_file,rvb_file,rvbi_file
             WHERE rvb04 = l_rvb.rvb04
               AND rvb03 = l_rvb.rvb03
               AND rva01 = rvb01
               AND rvb35 = 'N'
               AND rvaconf = 'Y'
               AND rvbi01 = rvb01
               AND rvbi02 = rvb02
               #若為委外TKY,要排除非最後一站的數量
               AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
         #FUN-810038................end
&else
            SELECT SUM(rvb07) INTO l_rvb.rvb07     #計算此採購單已收量
              FROM rva_file,rvb_file
             WHERE rvb04 = l_rvb.rvb04
               AND rvb03 = l_rvb.rvb03
               AND rvb35 = 'N'
               AND rvaconf = 'Y'
               AND rva01 = rvb01
&endif
 
         IF cl_null(l_rvb.rvb07) THEN
            LET l_rvb.rvb07 = 0
         END IF
 
         IF g_argv6='1' THEN                                  #FUN-940083--add  
&ifdef ICD
            #FUN-810038................begin
               SELECT SUM(rvb07-rvb29-rvb30) INTO l_pmn51     #計算此採購單已收量
                 FROM rva_file,rvb_file,rvbi_file
                WHERE rvb04 = l_rvb.rvb04
                  AND rvb03 = l_rvb.rvb03
                  AND rvb01 = rvbi01
                  AND rvb02 = rvbi02
                  AND rvb35 = 'N'
                  AND rvaconf = 'Y'
                  AND rva01 = rvb01
            #FUN-810038................end
&else
               SELECT SUM(rvb07-rvb29-rvb30) INTO l_pmn51     #計算此採購單已收量
                 FROM rva_file,rvb_file
                WHERE rvb04 = l_rvb.rvb04
                  AND rvb03 = l_rvb.rvb03
                  AND rvb35 = 'N'
                  AND rvaconf = 'Y'
                  AND rva01 = rvb01
&endif
 
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
#              CALL cl_err('upd pmn:',SQLCA.sqlcode,1) #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","pmn_file",l_rvb.rvb04,l_rvb.rvb03,SQLCA.sqlcode,"","upd pmn",1) #No.FUN-660129
              IF g_bgerr THEN
                 LET g_showmsg = l_rvb.rvb04,l_rvb.rvb03
                 CALL s_errmsg("pmn01,pmn02",g_showmsg,"upd pmn:",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("upd","pmn_file",l_rvb.rvb04,l_rvb.rvb03,SQLCA.sqlcode,"","upd pmn",1)
              END IF
#No.FUN-710030 -- end --
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
               DELETE FROM tlf_file
                WHERE tlf026 = l_rvb.rvb34
                  AND tlf027 = l_rvb.rvb03
                  AND tlf036 = l_rvb.rvb01
                  AND tlf037 = l_rvb.rvb02
                  AND tlf01  = l_rvb.rvb05
 
               #No.FUN-540027  --begin
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                 CALL cl_err('del tlf',STATUS,0) #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("del","tlf_file",l_rvb.rvb34,"",STATUS,"","del tlf",1) #No.FUN-660129
                  IF g_bgerr THEN
                     LET g_showmsg = l_rvb.rvb34,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                     CALL s_errmsg("tlf026,tlf027,tlf036,tlf037,tlf01",g_showmsg,"del tlf",STATUS,1)
                  ELSE
                     CALL cl_err3("del","tlf_file",l_rvb.rvb34,"",STATUS,"","del tlf",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success = 'N'
                  RETURN
               END IF
 
               IF g_sma.sma115 = 'Y' THEN
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_rvb.rvb05
 
#No.TQC-970355--begin--
#                 IF l_ima906 MATCHES '[23]' THEN
#                    DELETE FROM tlff_file WHERE tlff026 = l_rvb.rvb34
#                                            AND tlff027 = l_rvb.rvb03
#                                            AND tlff036 = l_rvb.rvb01
#                                            AND tlff037 = l_rvb.rvb02
#                                            AND tlff01  = l_rvb.rvb05
#                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                       CALL cl_err('del tlff',STATUS,0)  #No.FUN-660129
#No.FUN-710030 -- begin --
#                        CALL cl_err3("del","tlff_file",l_rvb.rvb34,"",STATUS,"","del tlff",1) #No.FUN-660129
#                       IF g_bgerr THEN
#                          LET g_showmsg = l_rvb.rvb34,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
#                          CALL s_errmsg("tlff026,tlff027,tlff036,tlff037,tlff01",g_showmsg,"del tlff",STATUS,1)
#                       ELSE
#                          CALL cl_err3("del","tlff_file",l_rvb.rvb34,"",STATUS,"","del tlff",1)
#                       END IF
#No.FUN-710030 -- end --
#                       LET g_success = 'N'
#                       RETURN
#                    END IF
#                 END IF
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
#No.TQC-970355 --end--
               END IF
               #No.FUN-540027  --end
            ELSE
               IF g_argv6='1' THEN                #FUN-9400083--add
                  DELETE FROM tlf_file
                   WHERE tlf026 = l_rvb.rvb04
                     AND tlf027 = l_rvb.rvb03
                     AND tlf036 = l_rvb.rvb01
                     AND tlf037 = l_rvb.rvb02
                     AND tlf01  = l_rvb.rvb05
#FUN-940083--begin
               ELSE
                  DELETE FROM tlf_file
                   WHERE tlf036 = l_rvb.rvb01
                     AND tlf037 = l_rvb.rvb02
                     AND tlf01  = l_rvb.rvb05
               END IF
#FUN-940083--end
               #No.FUN-540027  --begin
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                 CALL cl_err('del tlf',STATUS,0)  #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("del","tlf_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlf",1) #No.FUN-660129
                  IF g_bgerr THEN
                     LET g_showmsg = l_rvb.rvb04,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                     CALL s_errmsg("tlf026,tlf027,tlf036,tlf037,tlf01",g_showmsg,"del tlf",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("del","tlf_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlf",1)
                  END IF
#No.FUN-710030 -- end --
                  LET g_success = 'N'
                  RETURN
               END IF
 
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
#FUN-940083--begin
                     ELSE
                        DELETE FROM tlff_file
                         WHERE tlff036 = l_rvb.rvb01
                           AND tlff037 = l_rvb.rvb02
                           AND tlff01  = l_rvb.rvb05
                     END IF
#FUN-940083--end
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                       CALL cl_err('del tlff',STATUS,0)  #No.FUN-660129
#No.FUN-710030 -- begin --
#                        CALL cl_err3("del","tlff_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlff",1) #No.FUN-660129
                        IF g_bgerr THEN
                           LET g_showmsg = l_rvb.rvb04,"/",l_rvb.rvb03,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",l_rvb.rvb05
                           CALL s_errmsg("tlff026,tlff027,tlff036,tlff037,tlff01",g_showmsg,"del tlff",STATUS,1)
                        ELSE
                           CALL cl_err3("del","tlff_file",l_rvb.rvb04,l_rvb.rvb03,STATUS,"","del tlff",1)
                        END IF
#No.FUN-710030 -- end --
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
               END IF
               #No.FUN-540027  --end
            END IF
         END IF
 
         #-----No.FUN-810036-----
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
      #   WHERE ima01 = g_rvb[l_ac].rvb05   #No.FUN-940083 mark bu shiwuying
          WHERE ima01 = l_rvb.rvb05         #No.FUN-940083
            AND imaacti = "Y"
         
         #IF g_ima918 = "Y" OR g_ima921 = "Y" THEN   #MOD-8C0181
         IF (g_ima918 = "Y" OR g_ima921 = "Y") AND g_sma.sma90 = 'Y' THEN   #MOD-8C0181
            DELETE FROM tlfs_file
             WHERE tlfs01 = l_rvb.rvb05
               AND tlfs10 = l_rvb.rvb01
               AND tlfs11 = l_rvb.rvb02
               AND tlfs111 = g_rva.rva06 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               IF g_bgerr THEN
                  LET g_showmsg = l_rvb.rvb05,"/",l_rvb.rvb01,"/",l_rvb.rvb02,"/",g_rva.rva06
                  CALL s_errmsg("tlfs01,tlfs10,tlfs11,tlfs111",g_showmsg,"del tlfs",STATUS,1)
               ELSE
                  #No.FUN-840042        ---start----
                  #CALL cl_err3("del","tlfs_file",l_rvb.rvb05,STATUS,"","del tlfs",1)
                  CALL cl_err3("del","tlfs_file",l_rvb.rvb05,"",STATUS,"","del tlfs",1)
                  #No.FUN-840042        ----end----
               END IF
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         #-----No.FUN-810036 END-----
 
         IF g_rva.rva10='SUB' THEN
            CALL cl_msg("Update sfb_file ...")
            #-----MOD-990024---------
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
            #-----END MOD-990024-----
                     #FUN-5C0055..............begin
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
                     #FUN-5C0055..............end
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                        #CALL cl_err('upd sfb04:',SQLCA.sqlcode,1) #No.FUN-660129
                        #No.FUN-710030 -- begin --
                        #CALL cl_err3("upd","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","upd sfb04",1) #No.FUN-660129
                        IF g_bgerr THEN
                           CALL s_errmsg("sfb01",g_showmsg,"upd sfb04:",SQLCA.sqlcode,1)
                        ELSE
                           CALL cl_err3("upd","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","upd sfb04",1)
                        END IF
                        #No.FUN-710030 -- end --
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF   #MOD-990024
               END IF   #MOD-990024
            END IF   #MOD-990024
 
            CALL s_updsfb117(l_rvb.rvb34)
 
            IF g_success='N' THEN
#No.FUN-710030 -- begin --
#               CALL cl_err('upd sfb11:',SQLCA.sqlcode,1)
               IF g_bgerr THEN
                  CALL s_errmsg("","","upd sfb11:",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","upd sfb11:",1)
               END IF
#No.FUN-710030 -- end --
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
 
      CLOSE t110_pmn2
      CLOSE t110_ima2
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
 
END FUNCTION
 
FUNCTION t110_out()
   DEFINE l_cmd       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2  LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(50)
          l_prtway    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   IF g_rva.rvaprsw = 'Y' THEN
      CALL cl_wait()
 
      LET l_wc='rva01="',g_rva.rva01,'"'
 
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'apmr920'
 
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " 'N' '3' '123' "
      END IF
 
      LET l_cmd = "apmr920",
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' "    #,l_wc2     #No.TQC-610085 mark
 
      CALL cl_cmdrun(l_cmd)
   END IF
 
   ERROR ' '
 
END FUNCTION
 
## 確認時 check 超短交 & 可否提前交貨-----------------------------------
FUNCTION t110_chk_over()
   DEFINE  l_pmn34    LIKE pmn_file.pmn34,
           l_pmn37    LIKE pmn_file.pmn37,
           l_date     LIKE type_file.dat,     #No.FUN-680136 DATE
           l_pmn15    LIKE pmn_file.pmn15
 
   IF g_rec_b <= 0 OR cl_null(g_rec_b) THEN
      RETURN
   END IF
 
   #MOD-820073-begin-add
   LET g_cnt = 0 
   SELECT COUNT(*) INTO g_cnt
     FROM rvb_file
    WHERE rvb01=g_rva.rva01
   IF g_cnt > g_rec_b THEN
      LET g_success = 'N' 
      LET g_totsuccess = 'N'   #No.MOD-940250 add
      RETURN
   END IF 
   #MOD-820073-end-add
 
   FOR g_i=1 TO g_rec_b
#     SELECT pmn13,pmn14,pmn15, pmn34,pmn37,pmn20,(pmn50-pmn55)          #FUN-9A0068 mark
      SELECT pmn13,pmn14,pmn15, pmn34,pmn37,pmn20,(pmn50-pmn55-pmn58)    #FUN-9A0068
        INTO g_pmn13,g_pmn14,l_pmn15,l_pmn34,l_pmn37,g_pmn20,g_pmn50_55
        FROM pmn_file,pmm_file
       WHERE pmn01 = g_rvb[g_i].rvb04
         AND pmn02 = g_rvb[g_i].rvb03
         AND pmn01 = pmm01
 
      IF g_rvb[g_i].rvb35 = 'N' THEN
         CALL t110_chk_over_sub(g_i)
      END IF
 
      IF g_success='N' THEN  #MOD-530700
        #No.MOD-940250 modify --begin
        #EXIT FOR     
         IF g_bgerr THEN
            LET g_totsuccess = 'N' 
            LET g_success = 'Y'
         ELSE 
            LET g_totsuccess = 'N' 
            EXIT FOR
         END IF
        #No.MOD-940250 modify --end
      END IF
 
      IF l_pmn15 = 'N'  THEN  #可否提前交貨(Y/N)
         IF cl_null(l_pmn37)  THEN
            LET l_date = l_pmn34
         ELSE
            LET l_date = l_pmn37
         END IF
 
         IF g_rva.rva06 < l_date   THEN
           #No.MOD-940250 add --begin
           #CALL cl_err(g_rvb[g_i].rvb04,'apm-285',1)
           #LET g_success = 'N'
           #EXIT FOR      
            IF g_bgerr THEN             
               CALL s_errmsg("","",g_rvb[g_i].rvb04,'apm-285',1)           
               LET g_totsuccess = 'N' 
               LET g_success = 'Y'
            ELSE                                                
               CALL cl_err3("","","","",g_rvb[g_i].rvb04,"","apm-285",1) 
               LET g_totsuccess = 'N' 
               LET g_success='N'
               EXIT FOR
            END IF
           #No.MOD-940250 add --end
         END IF
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION t110_chk_over_sub(p_i)
DEFINE p_i        LIKE type_file.num5,    #No.FUN-680136 SMALLINT
       l_sfb39    LIKE sfb_file.sfb39,    #MOD-530700
       l_sfb05    LIKE sfb_file.sfb05,    #MOD-530700
       l_sfb93    LIKE sfb_file.sfb93,    #No.FUN-610101 add
       l_min_set  LIKE sfb_file.sfb08,    #No.TQC-670091 add
       l_rvb07_1  LIKE rvb_file.rvb07,
       l_rvb07_2  LIKE rvb_file.rvb07,
       l_rvb07_3  LIKE rvb_file.rvb07,
       l_fac      LIKE ima_file.ima31_fac,#No.TQC-730059 add
       l_i        LIKE type_file.num5,    #No.TQC-730059 add
       l_ima55    LIKE ima_file.ima55,    #No.TQC-730059 add
       l_rvb07    LIKE rvb_file.rvb07
DEFINE l_rvb07_3_tky LIKE rvb_file.rvb03  #FUN-810038
&ifdef ICD
DEFINE l_imaicd04 LIKE imaicd_file.imaicd04  #FUN-810038
DEFINE l_rvbiicd13 LIKE rvbi_file.rvbiicd13  #FUN-810038
DEFINE l_pmniicd13 LIKE pmni_file.pmniicd13  #FUN-950040
&endif
DEFINE l_ima153    LIKE ima_file.ima153   #MOD-980139 
 
   IF cl_null(g_pmn13) THEN  #超交率
      LET g_pmn13 = 0
   END IF
&ifdef ICD
   #FUN-810038................begin
      #當所收的貨為WAFER時不可超交
      SELECT imaicd04 INTO l_imaicd04
        FROM imaicd_file
       WHERE imaicd00 = g_rvb[p_i].rvb05
 
      IF l_imaicd04 MATCHES "[012]" THEN
         LET g_pmn13 = 0
      END IF
   #FUN-810038................end
&endif
   IF cl_null(g_pmn50_55) THEN
      LET g_pmn50_55 = 0
   END IF
 
   #-----MOD-8C0007---------
   SELECT pmn20 INTO g_rvb[p_i].pmn20 FROM pmn_file
    WHERE pmn01=g_rvb[p_i].rvb04
      AND pmn02=g_rvb[p_i].rvb03
   #-----END MOD-8C0007-----
   LET g_pmn20 = g_rvb[p_i].pmn20
 
&ifdef ICD
   #FUN-810038................begin
      SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file,rvbi_file
       WHERE rvb04 = g_rvb[p_i].rvb04
         AND rvb03 = g_rvb[p_i].rvb03
         AND rvbi01=rvb01
         AND rvbi02=rvb02
         AND rvaconf = 'N'
         AND rva01 = rvb01
         AND rvb35 = 'N'
         AND NOT (rvb01 = g_rva.rva01
         AND rvb02 = g_rvb[p_i].rvb02)
         #若為委外TKY,要排除非最後一站的數量
         AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
   #FUN-810038................end
&else
      SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
       WHERE rvb04 = g_rvb[p_i].rvb04
         AND rvb03 = g_rvb[p_i].rvb03
         AND rvaconf = 'N'
         AND rva01 = rvb01
         AND rvb35 = 'N'
         AND NOT (rvb01 = g_rva.rva01
         AND rvb02 = g_rvb[p_i].rvb02)
&endif
 
 
   IF cl_null(l_rvb07_3) THEN
      LET l_rvb07_3 = 0
   END IF
 
&ifdef ICD
   #FUN-950040.............begin
   #本采購單累積被衝銷量
   SELECT pmniicd13 INTO l_pmniicd13 FROM pmni_file
    WHERE pmni01 = g_rvb[p_i].rvb04
      AND pmni02 = g_rvb[p_i].rvb03
 
   IF cl_null(l_pmniicd13) THEN
      LET l_pmniicd13 = 0
   END IF
   #FUN-950040.............end
&endif
   #計算已交量
   LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb[p_i].rvb07
&ifdef ICD
   #FUN-950040.............begin
   LET l_rvb07=l_rvb07+l_pmniicd13
   #FUN-950040.............end
&endif
   LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
  #LET l_rvb07_2=l_rvb07-l_rvb07_1               #MOD-530021 MARK
   LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100     #MOD-530021 #最少可交貨量
&ifdef ICD
   #FUN-810038................begin
      SELECT rvbiicd13 INTO l_rvbiicd13
        FROM rvbi_file
       WHERE rvbi01=g_rva.rva01
         AND rvbi02=g_rvb[p_i].rvb02
      IF l_rvbiicd13 = 'Y' THEN
         SELECT SUM(rvb07) INTO l_rvb07_3_tky
           FROM rvb_file,rva_file,rvbi_file
          WHERE rvb04 = b_rvb.rvb04
            AND rvb03 = b_rvb.rvb03
            AND rvbi01=rvb01
            AND rvbi02=rvb02
            AND rvaconf != 'X'
            AND rva01 = rvb01
            AND rvb35 = 'N'
            AND NOT (rvb01 = g_rva.rva01
            AND rvb02 = g_rvb[p_i].rvb02)
            AND rvbiicd13 = 'Y'
            AND rvbiicd03= g_rvb[p_i].rvbiicd03
         IF cl_null(l_rvb07_3_tky) THEN
            LET l_rvb07_3_tky = 0
         END IF
         #計算已交量
         LET l_rvb07=l_rvb07_3_tky+g_rvb[p_i].rvb07
      END IF
   #FUN-810038................end
&endif
 
   IF g_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
      IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
        #IF l_rvb07_1 > l_rvb07 THEN #短交 #MOD-530021 MARK
         IF l_rvb07_2 > l_rvb07 THEN #短交 #MOD-530021
            IF g_sma.sma85 MATCHES '[Rr]' THEN
              #No.MOD-940250 modify --begin
              #CALL cl_err(l_rvb07_2,'mfg3038',0)
              #LET g_success='N'
              #RETURN
              IF g_bgerr THEN             
                  CALL s_errmsg("","",l_rvb07_2,'mfg3038',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_2,'mfg3038',0)
                  LET g_success='N'
                  RETURN
               END IF
              #No.MOD-940250 modify --end
            ELSE
               CALL cl_err(l_rvb07_2,'mfg9120',1)
            END IF
         END IF
 
         IF l_rvb07_1 < l_rvb07 THEN #超交
            IF g_sma.sma85 MATCHES '[Rr]' THEN
              #No.MOD-940250 modify --begin
              #CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
              #LET g_success='N'
              #RETURN
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb07_1,'mfg3037',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                  LET g_success='N'
                  RETURN
               END IF
              #No.MOD-940250 modify --end
            ELSE
               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
            END IF
         END IF
      END IF
 
      IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
         IF l_rvb07_1 < l_rvb07 THEN #超交
            IF g_sma.sma85 MATCHES '[Rr]' THEN
              #No.MOD-940250 modify --begin
              #CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
              #LET g_success='N'
              #RETURN
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb07_1,'mfg3037',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_1,'mfg3037',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1  #No.TQC-6C0091 0->1
                  LET g_success='N'
                  RETURN
               END IF  
              #No.MOD-940250 modify --end
            ELSE
               CALL cl_err(l_rvb07_1,'mfg9121',1) #MOD-530021 #將show l_rvb07_2,改成l_rvb07_1
            END IF
         END IF
      END IF
   END IF
 
   IF g_pmn13 < 0 THEN    #控制超短交
      IF g_pmn14 = 'N' THEN   #不能部份交貨
         IF l_rvb07 - g_pmn20 < 0 THEN      #須>= 訂購量
           #No.MOD-940250 modify --begin
           #CALL cl_err(l_rvb07,'mfg3335',0)
           #LET g_success='N'
           #RETURN
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb07,'mfg3335',1)
               LET g_success = 'N'
            ELSE
               CALL cl_err(l_rvb07,'mfg3335',0)
               LET g_success='N'
               RETURN
            END IF
           #No.MOD-940250 modify --end
         END IF
      END IF
   END IF
 
   #MOD-530700 ADD
   SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93  #No.FUN-610101 add sfb93
     FROM sfb_file
    WHERE sfb01 = g_rvb[p_i].rvb34
 
   IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
      IF g_argv2 ='SUB' AND g_rvb[p_i].rvb05=l_sfb05 THEN
      #---------No.TQC-670091 modify
       #AND l_sfb93 != 'Y' THEN  #No.FUN-610101 add判斷走製程時不控管最小發料套數
        IF l_sfb93 != 'Y' THEN   #CHI-840066 modify add ! 製程委外不控管最小發料套數
           #-----MOD-980139---------
           #CALL t110_minp(g_rvb[p_i].rvb03,g_rvb[p_i].rvb04,     
           #               g_rvb[p_i].rvb34,g_rvb[p_i].rvb05) RETURNING l_min_set  #FUN-910053 ADD RVB05
           LET l_min_set = 0
           CALL s_get_ima153(g_rvb[p_i].rvb05) RETURNING l_ima153  
           CALL s_minp(g_rvb[p_i].rvb34,g_sma.sma73,l_ima153,'') 
                 RETURNING g_cnt,l_min_set
           IF cl_null(l_min_set) THEN LET l_min_set = 0 END IF
           #-----END MOD-980139-----
 
          #--------------No.TQC-730059 add
           SELECT ima55 INTO l_ima55
             FROM ima_file
            WHERE ima01 = g_rvb[p_i].rvb05                          #MOD-790074 modif l_ac->p_i
           CALL s_umfchk(g_rvb[p_i].rvb05,g_rvb[p_i].rvb90,l_ima55) #MOD-790074 modif l_ac->p_i #No.FUN-940083 pmn07-->rvb90 
                RETURNING l_i,l_fac
           IF l_i = 1 THEN
              #採購單位無法與料件的生產單位做換算,預設轉換率為1
              CALL cl_err(g_rvb[p_i].rvb05,'apm-120',1)   #MOD-790074 modify l_ac->p_i
              LET l_fac = 1
           END IF
           LET l_min_set = l_min_set / l_fac
          #--------------No.TQC-730059 end
 
           #-----MOD-980139---------
           # 確認之(收貨-退貨)
           SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
            WHERE rvb34 = g_rvb[p_i].rvb34
              AND rvb01 = rva01 AND rvaconf<>'X' 
              AND rvb05 = g_rvb[p_i].rvb05 AND rvb35='N'
              AND NOT (rvb02=g_rvb[p_i].rvb02 AND rvb01=g_rva.rva01) 
              AND rvb04 = g_rvb[p_i].rvb04   
              AND rvb03 = g_rvb[p_i].rvb03  
 
           IF conf_qty IS NULL THEN LET conf_qty=0 END IF
           LET l_min_set=l_min_set-conf_qty
           #-----END MOD-980139----- 
 
           IF g_rvb[p_i].rvb07 > l_min_set THEN     #MOD-790074 modify l_ac->p_i
             #No.MOD-940250 modify --begin
             #CALL cl_err(g_rvb[p_i].rvb07,'apm-307',1)  #MOD-790074 modify l_ac->p_i
             #LET g_success = 'N'
             #RETURN
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_rvb[p_i].rvb07,'apm-307',1)
                 LET g_success = 'N'
              ELSE
                 CALL cl_err(g_rvb[p_i].rvb07,'apm-307',1)  #MOD-790074 modify l_ac->p_i
                 LET g_success='N'
                 RETURN
              END IF
             #No.MOD-940250 modify --end
           END IF
         ELSE
           CALL t110_get_min_set(p_i) #取得g_min_set的值
&ifndef ICD
           #TQC-940072 : for ICD Turnkey收貨不需check發料最小套數
           #-----MOD-860054---------
           IF g_rvb[p_i].rvb07 > g_rvb[p_i].pmn20 - conf_qty THEN
             #No.MOD-940250 add --begin
             #CALL cl_err(g_rvb[p_i].rvb07,'apm-070',1)
             #LET g_success='N'
             #RETURN
              IF g_bgerr THEN
                 CALL s_errmsg("","",g_rvb[p_i].rvb07,'apm-070',1)
                 LET g_success = 'N'
              ELSE
                 CALL cl_err(g_rvb[p_i].rvb07,'apm-070',1)  #MOD-790074 modify l_ac->p_i
                 LET g_success='N'
                 RETURN
              END IF
             #No.MOD-940250 add --end
           END IF
&endif
           #IF g_rvb[p_i].rvb07>g_min_set THEN
           #   #委外實收數不可大於發料最小套數!
           #   CALL cl_err(g_rvb[p_i].rvb07,'apm-307',1)
           #   LET g_success='N'
           #   RETURN
           #END IF
           #-----END MOD-860054-----
        END IF
      #---------No.TQC-670091 end
      END IF
   END IF
   #MOD-530700(end)
 
END FUNCTION
 
FUNCTION t110_upd_pmn()
DEFINE l_rvb03    LIKE rvb_file.rvb03,
       l_rvb04    LIKE rvb_file.rvb04,
       l_rvb35    LIKE rvb_file.rvb35,
       l_rvb07    LIKE rvb_file.rvb07,
       l_rvb30    LIKE rvb_file.rvb30,
       l_rvv17    LIKE rvv_file.rvv17,    #
       l_pmn51    LIKE pmn_file.pmn51,
       l_rvb02    LIKE rvb_file.rvb02   #FUN-810038
&ifdef ICD
DEFINE l_rvbiicd13    LIKE rvbi_file.rvbiicd13  #FUN-810038
&endif
 
   #-->計算採購單之已交量/在驗量(已交量-退貨量-入庫量)
   DECLARE t110_upd_pmn CURSOR WITH HOLD FOR
     SELECT rvb03,rvb04,rvb35,rvb02    #FUN-810038
       FROM rvb_file WHERE rvb01 = g_rva.rva01
 
   FOREACH t110_upd_pmn INTO l_rvb03,l_rvb04,l_rvb35,l_rvb02   #FUN-810038
      #-->樣品不更新PO上的數量
      IF l_rvb35 <> 'N' THEN
         CONTINUE FOREACH
      END IF
&ifdef ICD
      #FUN-810038................begin
         SELECT rvbiicd13 INTO l_rvbiicd13
           FROM rvbi_file
          WHERE rvbi01=g_rva.rva01
            AND rvbi02=l_rvb02
         #判斷若為委外收貨單TKY,非最後一站的項次,不更新收貨資料
         IF l_rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
      #FUN-810038................end
&endif
 
&ifdef ICD
      #FUN-810038................begin
         SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
           INTO l_rvb30,l_rvb07,l_pmn51
           FROM rva_file,rvb_file,rvbi_file
          WHERE rvb04 = l_rvb04
            AND rvb03 = l_rvb03
            AND rvb35 = 'N'
            AND rvaconf = 'Y'
            AND rva01 = rvb01
            AND rvbi01= rvb01
            AND rvbi02= rvb02
            AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
      #FUN-810038................end
&else
         SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
           INTO l_rvb30,l_rvb07,l_pmn51
           FROM rva_file,rvb_file
          WHERE rvb04 = l_rvb04
            AND rvb03 = l_rvb03
            AND rvb35 = 'N'
            AND rvaconf = 'Y'
            AND rva01 = rvb01
&endif
 
      IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF
 
&ifdef ICD
      #FUN-810038................begin
         SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
           FROM rvv_file,rvu_file,rvvi_file
          WHERE rvv37 = l_rvb03
            AND rvv36 = l_rvb04
            AND rvv25 = 'N'
            AND rvuconf = 'Y'
            AND rvu01 = rvv01
            AND rvu00 = '3'  #倉退
            AND rvvi01=rvv01
            AND rvvi02=rvv02
            AND (rvviicd07 = 'N' OR rvviicd07 IS NULL OR rvviicd07 = ' ')
      #FUN-810038................end
&else
         SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
           FROM rvv_file,rvu_file
          WHERE rvv37 = l_rvb03
            AND rvv36 = l_rvb04
            AND rvv25 = 'N'
            AND rvuconf = 'Y'
            AND rvu01 = rvv01
            AND rvu00 = '3'  #倉退
&endif
      IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
 
      #-->(1-1)更新採購單已交量/在驗量
      CALL cl_msg("Update pmn_file ...")
      UPDATE pmn_file SET pmn50 = l_rvb07,            #已交量
                          pmn51 = l_pmn51,    #在驗量        #No.B185 010423 by linda mod
                          pmn53 = l_rvb30             #入庫量
       WHERE pmn01 = l_rvb04
         AND pmn02 = l_rvb03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success = 'N'
#        CALL cl_err('upd pmn50:',SQLCA.sqlcode,1)  #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("upd","pmn_file",l_rvb04,l_rvb03,SQLCA.sqlcode,"","upd pmn50:",1) #No.FUN-660129
      IF g_bgerr THEN
         LET g_showmsg = l_rvb04,"/",l_rvb03
         CALL s_errmsg("pmn01,pmn02",g_showmsg,"upd pmn50:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","pmn_file",l_rvb04,l_rvb03,SQLCA.sqlcode,"","upd pmn50:",1)
      END IF
#No.FUN-710030 -- end --
         RETURN
      END IF
      CALL s_udpmn57(l_rvb04,l_rvb03)   #TQC-8A0059
   END FOREACH
 
   IF STATUS THEN
#No.FUN-710030 -- begin --
#      CALL cl_err('foreach ',STATUS,0)
      IF g_bgerr THEN
         CALL s_errmsg("","","foreach",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","foreach",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION t110_g()
   #FUN-5C0022----add
   DEFINE l_rvb33  LIKE rvb_file.rvb33
   DEFINE l_flag   LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE l_factor LIKE qcs_file.qcs31
   DEFINE l_ima906 LIKE ima_file.ima906
   #FUN-5C0022----add
   DEFINE l_g_already LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_smy57     LIKE type_file.chr1,   #MOD-740033 add  #MOD-7B0145 modify
          l_t         LIKE smy_file.smyslip  #MOD-740033 add
   DEFINE l_rvb02  LIKE rvb_file.rvb02  #FUN-810038
   DEFINE l_pmn16     LIKE pmn_file.pmn16    #采購單單身狀況碼   #TQC-880009 add
   #No.MOD-8A0112 add --begin
   DEFINE l_qcs091    LIKE qcs_file.qcs091   #合格量
   DEFINE l_qcs22     LIKE qcs_file.qcs22    #送驗量(判定結果位驗退時為驗退量) 
   #No.MOD-8A0112 add --end
   #No.MOD-8C0080 add --begin
   DEFINE l_in        LIKE rvb_file.rvb07    #全部入庫量，包括未審核
   DEFINE l_out       LIKE rvb_file.rvb07    #全部驗退量，包括未審核
   #No.MOD-8C0080 add --end
 
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
 
   #----NO:2504 若允收數量=0則不產生入庫單，而產生驗退單(modi in 98/10/9)--------#
   #....NO.3196 若IQC單未確認則不可產生驗收入庫資料(modi in 01/08/06).........
  #IF g_rva.rva10  !='SUB' THEN  #委外不檢查QC
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
  #END IF
 
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
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
 
&ifdef ICD
      #FUN-810038................begin
         SELECT * INTO b_rvbi.* FROM rvbi_file
          WHERE rvbi01=b_rvb.rvb01  #CHI-920064
            AND rvbi02=b_rvb.rvb02  #CHI-920064
      #FUN-810038................end
&endif
 
      #No.TQC-880009 add----begin
      SELECT pmn16 INTO l_pmn16 FROM pmn_file  #采購單
       WHERE pmn01 = b_rvb.rvb04
         AND pmn02 = b_rvb.rvb03
      IF l_pmn16 != '2' THEN
         #-----MOD-920067---------
         LET g_msg =  b_rvb.rvb04,"-",b_rvb.rvb03 
         #CALL cl_err('','mfg3166',1)   
         CALL cl_err(g_msg,'mfg3166',1)   
         #RETURN   
         CONTINUE FOREACH  
         #-----END MOD-920067-----
      END IF    
      #No.TQC-880009 add----end
 
      LET l_n = 0
     #MOD-740033-begin-add
      LET l_t = s_get_doc_no(b_rvb.rvb01)
 
      SELECT smy57[3,3] INTO l_smy57 FROM smy_file
       WHERE smyslip=l_t
 
     IF l_smy57='N' THEN
        #-----No.MOD-860080-----
       ##----單身
       #SELECT COUNT(*) INTO l_n FROM rvv_file,rvu_file     #防止重覆過帳
       # WHERE rvv04=b_rvb.rvb01  #收貨單號
       #   AND rvv05=b_rvb.rvb02  #收貨項次
       #   AND rvu01=rvv01
       #   AND rvuconf != 'X'                               #排除已作廢之倉退單
      #No.MOD-8A0112 mark --begin
      #現在算出本次可入庫量和本次可驗退量，不需要判斷重復過賬
      # IF b_rvb.rvb30 >= b_rvb.rvb33 THEN
      #    LET l_n = 1
      # END IF
      #No.MOD-8A0112 mark --end
        #-----No.MOD-860080 END-----
     ELSE
        #MOD-740033-end-add
        #----單身
        SELECT COUNT(*) INTO l_n FROM rvv_file
         WHERE rvv04=b_rvb.rvb01  #收貨單號
           AND rvv05=b_rvb.rvb02  #收貨項次
     END IF   #MOD-740033 add
     
     IF l_n >= 1 THEN
        CONTINUE FOREACH
     END IF
 
&ifdef ICD
     #CHI-920064................begin
     IF (b_rvbi.rvbiicd13 = 'N') OR 
        (b_rvbi.rvbiicd13=' ')   OR   #CHI-920083
        (b_rvbi.rvbiicd13 IS NULL) THEN   #委外非最終站不檢查QC合格量  #CHI-920083
     #CHI-920064................end
&endif
     #No.MOD-8A0112 add --begin
     #No.MOD-8C0080 add --begin
     SELECT SUM(rvv17) INTO l_in FROM rvv_file,rvu_file
      WHERE rvv04=b_rvb.rvb01  #收貨單號
        AND rvv05=b_rvb.rvb02  #收貨項次
        AND rvu01=rvv01
        AND rvu00='1'
        AND rvuconf != 'X'
     SELECT SUM(rvv17) INTO l_out FROM rvv_file,rvu_file
      WHERE rvv04=b_rvb.rvb01  #收貨單號
        AND rvv05=b_rvb.rvb02  #收貨項次
        AND rvu01=rvv01
        AND rvu00='2'
        AND rvuconf != 'X'
     IF cl_null(l_in) THEN LET l_in = 0 END IF
     IF cl_null(l_out) THEN LET l_out = 0 END IF
     IF l_in + l_out = b_rvb.rvb07 THEN    #已經全部入庫或驗退
        CONTINUE FOREACH
     END IF
     #No.MOD-8C0080 add --end
     SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file 
      WHERE qcs01 = b_rvb.rvb01
        AND qcs02 = b_rvb.rvb02
        AND qcs14 = 'Y'           #No.MOD-930262 add
     IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF   #No.MOD-930220 add
    #No.MOD-8C0080 modify --begin
    #LET g_in = l_qcs091 - b_rvb.rvb30   #檢驗合格的量減去已經入庫的量，得到本次可入庫量 
     LET g_in = l_qcs091 - l_in   #檢驗合格的量減去已經入庫的量，得到本次可入庫量
    #No.MOD-8C0080 modify --end
     IF cl_null(g_in) THEN
        LET g_in = 0
     END IF
     #SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file    #MOD-980191
     SELECT SUM(qcs22-qcs091) INTO l_qcs22 FROM qcs_file    #MOD-980191
      WHERE qcs01 = b_rvb.rvb01
        AND qcs02 = b_rvb.rvb02
        #AND qcs09 = '2'   #MOD-980191
        AND qcs14 = 'Y'           #No.MOD-930262 add
     IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF   #No.MOD-930220 add
    #No.MOD-8C0080 modify --begin
    #LET g_out = l_qcs22 - b_rvb.rvb29   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量
     LET g_out = l_qcs22 - l_out   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量
    #No.MOD-8C0080 modify --end
     IF cl_null(g_out) THEN
        LET g_out = 0
     END IF
     IF g_sma.sma886[6,6] = 'N' THEN         #免檢驗直接入庫
       #LET g_in = b_rvb.rvb07               #No.MOD-8C0080 mark
        LET g_in = b_rvb.rvb07-l_in-l_out    #No.MOD-8C0080 add
        LET g_out= 0
     END IF
     #No.MOD-8C0080 add --begin
     IF g_sma.sma886[6,6] = 'Y' AND g_sma.sma886[8,8] = 'N' THEN
        LET g_in  = b_rvb.rvb33
        LET g_out = b_rvb.rvb07-b_rvb.rvb33-l_in-l_out
     END IF
     #No.MOD-8C0080 add --end
     #No.MOD-930220 add --begin
     IF b_rvb.rvb39 = 'N' THEN   #料件免檢驗入庫，不管上面怎麼算，都直接入庫
        LET g_in = b_rvb.rvb07-l_in-l_out
        LET g_out= 0
     END IF
     #No.MOD-930220 add --end
     IF g_in <= 0 AND g_out <= 0 THEN   #本次可入庫量和本次可驗退量都不大于0
        CONTINUE FOREACH
     END IF
    #No.MOD-8A0112 add --end
 
&ifdef ICD
     #CHI-920064................begin
     END IF
     #CHI-920064................end
&endif
 
&ifdef ICD
      #FUN-810038................begin
         #委外tky非最終站收貨項次不需做檢驗(不管檢驗項次為何),
         #在產生單據的同時,允收數量直接等於實收數量
         #所以在執行此功能[產生入庫/驗退單據]時,須跟隨最終站的收貨項次的條件來決定
         #是否可在此時產生入庫單,以免照成最終站尚無可允收數量,非最終站就被產生
         #至入庫單據了
         IF b_rvbi.rvbiicd13 = 'Y' THEN
            #取得該委外TKY採購單的最終站收貨資料
            SELECT rvb02 INTO l_rvb02 
              FROM rvb_file,ecm_file,rvbi_file
               WHERE rvb01 = b_rvb.rvb01           #收貨單
                 AND rvb04 = b_rvb.rvb04           #採購單
                 AND rvb03 = b_rvb.rvb03           #採購項次
                 AND rvbiicd17 = b_rvbi.rvbiicd17  #工單作業編號
                 AND ecm01 = rvb34                 #工單單號
                 AND rvbi01=rvb01
                 AND rvbi02=rvb02
                 AND ecm04 = rvbiicd03             #作業編號
                 AND ecm03 IN (SELECT MAX(ecm03) FROM ecm_file
                                 WHERE ecm01 = b_rvb.rvb34)
            #判斷最終站是否有允收數量可產生入庫,
            #若沒有,則所對應之非最終站收貨資料也不可在此時產生入庫
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM rvb_file
               WHERE rvb01 = b_rvb.rvb01
                 AND rvb02 = l_rvb02
                 AND rvb33 > 0
            IF l_n = 0  THEN
               CONTINUE FOREACH
            END IF
         END IF
      #FUN-810038................end
&endif
 
      LET l_g_already = 'N' #是否所有的收貨資料,早已產生入庫/驗退單完畢
      #FUN-5C0022-----add
      #母子單位時,自動產生入庫時,需check 以下
      #(允收數二+允收數一)經過換算<= IQC合格量才可自動產生
      #(rvb332*l_factor+rvb331)   <= rvb33
       IF g_sma.sma115 = 'Y' THEN #使用雙單位
           SELECT ima906 INTO l_ima906
             FROM ima_file
            WHERE ima01=b_rvb.rvb05
           IF l_ima906 = '2' THEN #母子單位
             #  CALL s_umfchk(b_rvb.rvb05,b_rvb.rvb83,b_rvb.rvb80)
             #        RETURNING l_flag,l_factor
             #  IF l_flag=0 THEN
             #      #==>有換算率
             #      LET l_rvb33  = b_rvb.rvb332 * l_factor + b_rvb.rvb331
             #  ELSE
             #      LET g_msg=b_rvb.rvb05 CLIPPED,'==>',b_rvb.rvb83,' & ',b_rvb.rvb80
             #      CALL cl_err(g_msg,'aqc-500',1) #add aqc-500
             #      LET g_success='N'
             #      EXIT FOREACH
             #  END IF
               # MOD-640530 -----start
               LET l_rvb33  = b_rvb.rvb332 * b_rvb.rvb84 + b_rvb.rvb331 * b_rvb.rvb81
               # MOD-640530 -----end
               IF l_rvb33 > b_rvb.rvb33 THEN
                   LET g_msg=b_rvb.rvb05 CLIPPED,'==>',b_rvb.rvb332,'*',l_factor,'+',b_rvb.rvb331,'>',b_rvb.rvb33
#No.FUN-710030 -- begin --
#                   CALL cl_err(g_msg,'aqc-501',1) #add aqc-501
#                   LET g_success='N'
#                   EXIT FOREACH
                  IF g_bgerr THEN
                     CALL s_errmsg("","",g_msg,"aqc-501",1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("","","","","aqc-501","",g_msg,1)
                     EXIT FOREACH
                  END IF
#No.FUN-710030 -- end --
               END IF
           END IF
       END IF
      #FUN-5C0022-----end
      LET l_flag=TRUE   #FUN-810038
&ifdef ICD
      #FUN-810038................begin
         IF NOT (b_rvbi.rvbiicd13='N' OR  #非委外TKY/委外TKY最終站
                 b_rvbi.rvbiicd13 IS NULL OR 
                 b_rvbi.rvbiicd13 = ' ') THEN
            LET l_flag=FALSE
         END IF
      #FUN-810038................end
&endif
 
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
#No.FUN-710030 -- begin --
#            CALL cl_err(g_msg,'aqc-026',1)
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("","",g_msg,"aqc-026",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","aqc-026","",g_msg,1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
      END IF
 
     #CALL t110_ins_rvu()  #No.MOD-8A0112 marka
     #No.MOD-8A0112 add --begin
     #要根據計算出來的本次可入庫量已經本次可驗退量來判斷
      IF g_in > 0 THEN
         CALL t110_ins_rvu('i')   #本次產生的是入庫單
      END IF
      IF g_out > 0 THEN
         CALL t110_ins_rvu('o')   #本次產生的是驗退單
      END IF
     #No.MOD-8A0112 add --end
 
      IF g_success = 'N' THEN
#No.FUN-710030 -- begin --
#         EXIT FOREACH
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
#No.FUN-710030 -- end --
      END IF
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
 
   IF l_g_already = 'Y' THEN
      #所有的收貨資料,早已產生入庫/驗退單完畢,不可重覆產生!
#No.FUN-710030 -- begin --
#      CALL cl_err(g_rva.rva01,'apm-111',1)
      IF g_bgerr THEN
         CALL s_errmsg("","",g_rva.rva01,"apm-111",1)
      ELSE
         CALL cl_err3("","","","","apm-111","",g_rva.rva01,1)
      END IF
#No.FUN-710030 -- end --
      LET g_success = 'N'
   END IF
   CALL cl_msg("")
 
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
 
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
 
   #No.FUN-540027  --begin
   CALL cl_set_comp_entry("rvb85,rvb87",TRUE)
   #No.FUN-540027  --end
   #TQC-7C0131.....begin
   IF p_cmd ='s' AND g_sma.sma120 ="Y" THEN
      CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",TRUE)
   END IF
   #TQC-7C0131.....end
   #FUN-940083--begin
   IF g_argv6 ='2' THEN
      CALL cl_set_comp_entry("rvb051",TRUE)
      CALL cl_set_comp_entry("rvb89,rvb90",TRUE)
   END IF
   #FUN-940083--begin
 
END FUNCTION
 
FUNCTION t110_set_no_entry_b(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_tmp      LIKE rvb_file.rvb04    # Prog. Version..: '5.30.06-13.03.12(05)  #No.FUN-540027
   DEFINE l_smy57_5  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(01)
   DEFINE l_sfb24    LIKE sfb_file.sfb24    #MOD-740504
 
   IF g_aza.aza26 = '2' AND g_rva.rva04 != "Y" THEN
      CALL cl_set_comp_entry("rvb22",FALSE)
   END IF
 
   #NO.FUN-610018 --start--
   IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
   IF g_gec07 = 'N' THEN
      CALL cl_set_comp_entry("rvb10t",FALSE)
   ELSE
      CALL cl_set_comp_entry("rvb10",FALSE)
   END IF
   #NO.FUN-610018 --end--
   #MOD-810024-begin-modify
   #IF p_cmd ='s' AND g_sma.sma120 ="Y" AND NOT cl_null(g_rvb[l_ac].rvb04) 
   #   AND NOT cl_null(g_rvb[l_ac].rvb03) THEN
   IF p_cmd ='s' AND g_sma.sma120 ="Y" THEN 
      IF  NOT cl_null(g_rvb[l_ac].rvb04) 
      AND NOT cl_null(g_rvb[l_ac].rvb03) THEN
   #MOD-810024-end-modify
      CALL cl_set_comp_entry("att00,att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,att01_c,att02_c,att03_c,att04_c,att05_c,att06_c,att07_c,att08_c,att09_c,att10_c",FALSE)
      END IF
   END IF  #MOD-810024 add
   #TQC-7C0131.....end
 
#MOD-7A0203-mark
#  IF INFIELD(rvb03) OR NOT g_before_input_done THEN  #MOD-7A0132 modify g_before_input_done
##No.FUN-610018      #No.FUN-550117
##     IF g_rvb[l_ac].gec07 = 'Y' THEN                        #No.FUN-560102
##        CALL cl_set_comp_entry("rvb10",FALSE)
##     END IF
#      #end No.FUN-550117
#MOD-7A0203-mark-end
 
#MOD-7A0203-modify
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
#MOD-7A0203-modify-end
   END IF
 
   #No.FUN-540027  --begin
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
   #No.FUN-540027  --end
 
   #MOD-740504...........begin
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
   #MOD-740504...........end
 
&ifdef ICD
   #FUN-810038................begin
   IF cl_null(g_argv2) OR (g_argv2<>'SUB') THEN
      CALL cl_set_comp_entry("rvb34",FALSE)
   END IF
   CALL cl_set_comp_entry("rvbiicd03",FALSE) #CHI-830032
   #FUN-810038................end
&endif
 
   #FUN-940083--begin
   IF g_argv6 !='2' THEN
      CALL cl_set_comp_entry("rvb051",FALSE)
      CALL cl_set_comp_entry("rvb89,rvb90",FALSE)
   END IF
   #FUN-940083--begin
END FUNCTION
 
#NO.FUN-640151 start--
FUNCTION t110_set_required()
    #TQC-810048-begin-mark
     #IF g_argv2='TAP' THEN
     #   CALL cl_set_comp_required("rva02",TRUE)
     #END IF
    #TQC-810048-end-mark
 
     #-----MOD-890253---------
     #將該段移至單身required的判斷
     ##MOD-740504...........begin
     #IF g_argv2<>'SUB' THEN
     #   CALL cl_set_comp_required("rvb36",TRUE)
     #END IF
     ##MOD-740504...........end
     #-----END MOD-890253-----
 
END FUNCTION
#NO.FUN-640151 end---
 
#-----MOD-890253---------
FUNCTION t110_set_required_b()
   IF g_argv2<>'SUB' AND g_rvb[l_ac].rvb05[1,4]<>'MISC' THEN  
      CALL cl_set_comp_required("rvb36",TRUE)
   END IF
END FUNCTION
#-----END MOD-890253-----
 
{
#MOD-530415 add
FUNCTION t110_get_rvb39(p_rvb04,p_rvb05,p_rvb19)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,    #
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915   #FUN-710060 add
 
  #FUN-710060---mod---str---
  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
  #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
 
   IF l_ima915='2' OR l_ima915='3' THEN
  #FUN-710060---mod---end---
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04
 
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=g_rva.rva05
         AND pmh13=l_pmm22
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
 
END FUNCTION
}
 #MOD-530700 ADD
FUNCTION t110_get_min_set(p_ac)
   DEFINE p_ac         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_ima55      LIKE ima_file.ima55,
          l_fac        LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
          l_i          LIKE type_file.num5      #No.FUN-680136 SMALLINT
   DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
 
   LET g_min_set = 0
 
   CALL s_get_ima153(g_rvb[p_ac].rvb05)  RETURNING l_ima153  #FUN-910053
  #CALL s_minp(g_rvb[p_ac].rvb34,g_sma.sma73,g_sma.sma74,'') #FUN-910053
   CALL s_minp(g_rvb[p_ac].rvb34,g_sma.sma73,l_ima153,'')    #FUN-910053
         RETURNING g_cnt,g_min_set
 
   SELECT ima55 INTO l_ima55
     FROM ima_file
    WHERE ima01 = g_rvb[p_ac].rvb05
 
   CALL s_umfchk(g_rvb[p_ac].rvb05,g_rvb[p_ac].rvb90,l_ima55)  #No.FUN-940083 pmn07-->rvb90 
        RETURNING l_i,l_fac
 
   IF l_i = 1 THEN
      #採購單位無法與料件的生產單位做換算,預設轉換率為1
      CALL cl_err(g_rvb[p_ac].rvb05,'apm-120',1)
      LET l_fac = 1
   END IF
 
   LET g_min_set = g_min_set / l_fac
 
   # 確認之(收貨-退貨)
   SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
    WHERE rvb34 = g_rvb[p_ac].rvb34
      AND rvb01 = rva01
      AND rvaconf<>'X'    #MOD-790062 modify 排除作廢單據
      AND rvb05 = g_rvb[p_ac].rvb05  #MOD-830023 modify
      AND rvb35='N'
      AND NOT (rvb02=g_rvb[p_ac].rvb02 AND rvb01=g_rva.rva01)  #MOD-790062 排除本張單正在輸入的項次  #MOD-830023 modify
      AND rvb04 = g_rvb[p_ac].rvb04   #MOD-850311   #MOD-860105 l_ac-->p_ac
      AND rvb03 = g_rvb[p_ac].rvb03   #MOD-850311   #MOD-850105 l_ac-->p_ac
 
   IF conf_qty IS NULL THEN
      LET conf_qty = 0
   END IF
 
   LET g_min_set = g_min_set - conf_qty
 
END FUNCTION
 #MOD-530700(end)
 
#No.FUN-540027  --begin
FUNCTION t110_tlff(p_pmn011,p_ima86,p_pmn122,p_rvb,p_unit,p_fac,p_qty,p_flag)
   DEFINE
      p_rvb           RECORD LIKE rvb_file.*,
      p_unit          LIKE img_file.img09,
      p_fac           LIKE img_file.img21,
      p_qty           LIKE img_file.img10,
      p_pmn011        LIKE pmn_file.pmn011,
      p_ima86         LIKE ima_file.ima86,    #成本單位
      p_pmn122        LIKE pmn_file.pmn122,   #專案號碼
      p_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      p_ac,l_sta      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_pmn65         LIKE pmn_file.pmn65     #No:7692
 
   LET g_tlff.tlff01=p_rvb.rvb05          #異動料件編號
   CASE p_pmn011
      WHEN 'REG ' LET g_tlff.tlff02=11    #資料來源
      WHEN 'EXP ' LET g_tlff.tlff02=14
      WHEN 'CAP ' LET g_tlff.tlff02=16
      WHEN 'SUB '
           #No:7692
           SELECT pmn65 INTO l_pmn65
             FROM pmn_file
            WHERE pmn01 = p_rvb.rvb04
              AND pmn02 = p_rvb.rvb03
           IF l_pmn65 = '2' THEN
               LET g_tlff.tlff02=18      #委外代買
           ELSE
               LET g_tlff.tlff02=60
           END IF
           #No:7692(end)
      OTHERWISE LET g_tlff.tlff02 = 10
   END CASE
   LET g_tlff.tlff020=g_plant             #工廠編號
   LET g_tlff.tlff021=''                  #倉庫別
   LET g_tlff.tlff022=''                  #儲位別
   LET g_tlff.tlff023=''
   LET g_tlff.tlff024=''
   LET g_tlff.tlff025=''
 
   IF p_pmn011='SUB' THEN
      LET g_tlff.tlff026=p_rvb.rvb34
      LET g_tlff.tlff027=p_rvb.rvb03
      LET g_tlff.tlff03=25                 #F.Q.C.
      LET g_tlff.tlff13='asft6001'            #異動命令代號
   ELSE
      LET g_tlff.tlff026=p_rvb.rvb04        #單據編號(採購單)
      LET g_tlff.tlff027=p_rvb.rvb03        #項次(採購項次)
      LET g_tlff.tlff03 =20                  #資料目的為檢驗區
      LET g_tlff.tlff13='apmt1101'           #異動命令代號
   END IF
 
   LET g_tlff.tlff030=g_plant             #工廠編號
   LET g_tlff.tlff031=p_rvb.rvb36         #倉庫別
   LET g_tlff.tlff032=p_rvb.rvb37         #儲位別
   LET g_tlff.tlff033=p_rvb.rvb38         #入庫批號
   LET g_tlff.tlff034=''                  #庫存數量
   LET g_tlff.tlff035=''                  #異動後庫存單位
   LET g_tlff.tlff036=p_rvb.rvb01         #驗收單單據編號
   LET g_tlff.tlff037=p_rvb.rvb02         #單據項次
   LET g_tlff.tlff04=''                   #工作中心
   LET g_tlff.tlff05=' '                  #作業編號
   LET g_tlff.tlff06=g_rva.rva06          #異動日期=驗收單之收貨日期
   LET g_tlff.tlff07=g_today              #異動數量=驗收單之實收數量
   LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user               #產生人
   LET g_tlff.tlff10=p_qty                #異動數量=驗收單之實收數量
   LET g_tlff.tlff11=p_unit               #異動單位=採購單位
   LET g_tlff.tlff12=p_fac                #收料單位/料件庫存轉換率
   LET g_tlff.tlff14=' '                  #異動原因代碼
   LET g_tlff.tlff17=''                   #非庫存性料件編號
 
   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlff.tlff18 #異動後總庫存量
 
   LET g_tlff.tlff19=g_rva.rva05          #廠商編號
   LET g_tlff.tlff20=p_pmn122             #專案號碼
   LET g_tlff.tlff61=p_ima86              #成本單位
   LET g_tlff.tlff62=p_rvb.rvb04          #單據編號(採購單)
   LET g_tlff.tlff63=p_rvb.rvb03          #項次(採購項次)
   LET g_tlff.tlff64=p_rvb.rvb25          #手冊 no.A050
   LET g_tlff.tlff930=p_rvb.rvb930        #成本中心 #FUN-670051
 
   IF cl_null(p_rvb.rvb85) OR p_rvb.rvb85 = 0 THEN
     CALL s_tlff(p_flag,NULL)
   ELSE
     CALL s_tlff(p_flag,p_rvb.rvb83)
   END IF
 
END FUNCTION
 
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
 
   #No.MOD-590119  --begin
   IF g_sma.sma115='N' THEN RETURN END IF
   #No.MOD-590119  --end
 
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
   #No.MOD-590119  --begin
   #ELSE  #不使用雙單位
   #   LET l_tot=l_qty1
   #No.MOD-590119  --end
   END IF
 
   LET g_factor = 1
  #No.MOD-890005 mark --begin
  #CALL s_umfchk(g_rvb[l_ac].rvb05,l_pmn07,l_ima44)
  #      RETURNING g_cnt,g_factor
  #IF g_cnt = 1 THEN
  #   LET g_factor = 1
  #END IF
  #No.MOD-890005 mark --end
   LET g_rvb[l_ac].rvb07 = l_tot * g_factor
   LET g_rvb2.rvb07 = g_rvb[l_ac].rvb07
 
   #TQC-770117-begin-modify
   #IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
      LET g_rvb2.rvb88 = g_rvb[l_ac].rvb10 * g_rvb[l_ac].rvb87
      LET g_rvb2.rvb88t= g_rvb[l_ac].rvb10t* g_rvb[l_ac].rvb87
   #ELSE
   #   LET g_rvb2.rvb88 = g_rvb[l_ac].rvb10 * g_rvb2.rvb07
   #   LET g_rvb2.rvb88t= g_rvb[l_ac].rvb10t* g_rvb2.rvb07
   #END IF
   #TQC-770117-end-modify
 
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
#     CALL s_umfchk(g_rvb[l_ac].rvb04,g_rvb[l_ac].rvb07,l_ima44)     #No.MOD-6B0162
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
  #-MOD-970230-add-
  #CALL s_umfchk(g_rvb[l_ac].rvb05,l_ima44,g_rvb[l_ac].rvb86)
  #      RETURNING g_cnt,l_factor
   IF g_sma.sma115 = 'Y' THEN
      CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_rvb[l_ac].rvb86)
            RETURNING g_cnt,l_factor
   ELSE
      CALL s_umfchk(g_rvb[l_ac].rvb05,l_ima44,g_rvb[l_ac].rvb86)
            RETURNING g_cnt,l_factor
   END IF
  #-MOD-970230-end-
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   LET g_rvb[l_ac].rvb87 = l_tot
END FUNCTION
 
#No.FUN-580115  --begin
FUNCTION t110_set_rvv87(p_item,p_fac2,p_qty2,p_fac1,p_qty1,p_rvv86,p_flag,p_unit)
   DEFINE p_item    LIKE img_file.img01,     #料號
          l_ima25   LIKE ima_file.ima25,     #ima單位
          l_ima44   LIKE ima_file.ima44,     #ima單位
          l_ima906  LIKE ima_file.ima906,
          p_fac2    LIKE img_file.img21,     #第二轉換率
          p_qty2    LIKE img_file.img10,     #第二數量
          p_fac1    LIKE img_file.img21,     #第一轉換率
          p_qty1    LIKE img_file.img10,     #第一數量
          p_rvv86   LIKE ima_file.ima25,     #第一數量
          p_unit    LIKE ima_file.ima25,
          l_tot     LIKE img_file.img10,     #計價數量
          p_flag    LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_factor  LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
 
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=p_item
   IF SQLCA.sqlcode = 100 THEN
      IF p_item MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
 
   IF cl_null(l_ima44) THEN
      LET l_ima44 = l_ima25
   END IF
 
   IF p_flag=1 THEN
      LET l_factor =1
      CALL s_umfchk(p_item,p_unit,l_ima44) RETURNING g_cnt,l_factor
      IF g_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET p_fac1=l_factor
   END IF
 
   IF cl_null(p_fac1) THEN LET p_fac1=1 END IF
   IF cl_null(p_qty1) THEN LET p_qty1=0 END IF
   IF cl_null(p_fac2) THEN LET p_fac2=1 END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
 
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=p_qty1*p_fac1
         WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
         WHEN '3' LET l_tot=p_qty1*p_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=p_qty1*p_fac1
   END IF
 
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   LET l_factor = 1
 
   CALL s_umfchk(p_item,l_ima44,p_rvv86) RETURNING g_cnt,l_factor
 
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   RETURN l_tot
 
END FUNCTION
#No.FUN-580115  --end
#No.FUN-540027  --end
 
#TQC-650108
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
# p_cmd                       STRING   #No.MOD-660090 MARK
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
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t110_set_no_entry_b(p_cmd)
        #FUN-540049  --begin
        CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
        #FUN-540049  --end
 
        RETURN TRUE
     END IF  #注意這里沒有錯，所以返回TRUE
 
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t110_set_no_entry_b(p_cmd)
        #FUN-540049  --begin
        CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
        #FUN-540049  --end
 
         RETURN TRUE
     END IF
 
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
            #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t110_set_no_entry_b(p_cmd)
            #FUN-540049  --begin
            CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
            #FUN-540049  --end
 
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
#          CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)  #No.FUN-660129
           CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1) #No.FUN-660129
           DELETE FROM ima_file WHERE ima01 = ls_value_fld
           #No.FUN-7B0018 080304 add --begin
           IF NOT s_industry('std') THEN
              LET l_flag = s_del_imaicd(ls_value_fld,'')
           END IF
           #No.FUN-7B0018 080304 add --end
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
     CALL t110_set_required_b() #MOD-890253 _set_required()-->_set_required_b()
     LET g_rvb_t.rvb05=g_rvb[l_ac].rvb05
     RETURN TRUE
  ELSE
     IF ( p_field = 'rvb05' )OR( p_field = 'imx00' ) THEN
        CALL t110_set_no_entry_b('a')
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
#TQC-650108 --end
#FUN-670051...............begin
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
#FUN-670051...............end
 
#-------No.TQC-670091 add
FUNCTION t110_minp(p_rvb03,p_rvb04,p_rvb34,p_rvb05) #FUN-910053
   DEFINE l_pmn43      LIKE pmn_file.pmn43
   DEFINE l_ecm04      LIKE ecm_file.ecm04
   DEFINE l_sfa06      LIKE sfa_file.sfa06
   DEFINE l_sfa161     LIKE sfa_file.sfa161
  #-----------No.TQC-6A0057 add
   DEFINE l_sfb08      LIKE sfb_file.sfb05
   DEFINE l_sfa05      LIKE sfa_file.sfa05
   DEFINE l_sfa062     LIKE sfa_file.sfa062
   DEFINE l_sfa063     LIKE sfa_file.sfa063
   DEFINE l_sfa        RECORD LIKE sfa_file.*
  #-----------No.TQC-6A0057 end
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
    SELECT pmn43,pmn18 INTO l_pmn43,l_pmn18 FROM pmn_file #TQC-750166
       WHERE pmn01 = p_rvb04 AND pmn02 = p_rvb03
    IF STATUS THEN
       LET l_pmn43 = NULL
       LET l_pmn18 = NULL #TQC-750166
    END IF
 
   #抓取工單製程作業編號
    IF cl_null(l_pmn18) THEN #TQC-750166 不走runcard
       SELECT ecm04 INTO l_ecm04 FROM ecm_file
          WHERE ecm01 = p_rvb34 AND ecm03 = l_pmn43
       IF STATUS THEN
          LET l_ecm04 = NULL
       END IF
    #TQC-750166...............begin
    ELSE
       SELECT sgm04 INTO l_ecm04 FROM sgm_file
        WHERE sgm01=l_pmn18 AND sgm03=l_pmn43
       IF STATUS THEN
          LET l_ecm04 = NULL
       END IF
    END IF
    #TQC-750166...............end
   #--------------No.TQC-6A0057 modify
   #抓取公工單生產數量
    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = p_rvb34
      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
 
   #LET l_sql = " SELECT sfa06,sfa161 FROM sfa_file ",
   #            " WHERE sfa01 ='",p_rvb34 CLIPPED,"' ",
   #            "   AND sfa08 ='",l_ecm04 CLIPPED,"' "
 
    LET l_sql = " SELECT * FROM sfa_file ",
                " WHERE sfa01 ='",p_rvb34 CLIPPED,"' ",
    #           "   AND (sfa08 ='",l_ecm04 CLIPPED,"' ",    #MOD-860013
    #           "        OR sfa08 = ' ') ",                 #MOD-860013
                "   AND sfa065 = 0 ",          #No.MOD-780060 add
                "   AND sfa11 <> 'E' ",         #No.MOD-730032 add
                "   AND sfa161 > 0 "           #MOD-8C0027
   #--------------No.TQC-6A0057 end
   PREPARE t110_min_p1 FROM l_sql
   DECLARE t110_min_c1 CURSOR WITH HOLD FOR t110_min_p1
   LET l_cnt = 0
   #MOD-910239---Begin                                                                                                              
   LET l_cnt1=0                                                                                                                     
   LET l_cnt2=0                                                                                                                     
   SELECT COUNT(*) INTO l_cnt1 FROM sfa_file                                                                                        
    #WHERE sfa01=p_wono AND sfa26 NOT MATCHES '[SU]'   #MOD-940174                                                                              
     WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SU]'  #MOD-940174  
       AND sfa065=0 AND sfa161>0 AND sfa11<>'E' 
 
   SELECT COUNT(*) INTO l_cnt2 FROM  sfa_file                                                                                       
    WHERE sfa01=p_rvb34 AND sfa26 NOT MATCHES '[SU]'                                                                                
      AND sfa161>0 AND (sfa11='E'OR sfa065 > 0)                                                                                    
   IF l_cnt1 = 0 THEN    
      IF l_cnt2 > 0 THEN                                                                                                            
         LET l_min_set_t = l_sfb08                                                                                                  
         RETURN l_min_set_t                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
   #MOD-910239---End
  #-------------No.TQC-6A0057 modify
  #FOREACH t110_min_c1 INTO l_sfa06,l_sfa161
   FOREACH t110_min_c1 INTO l_sfa.*
     #LET l_cnt = l_cnt + 1      #No.TQC-950039 mark
      IF l_sfa.sfa26 MATCHES '[34]' THEN
         SELECT SUM(sfa06/sfa28),SUM(sfa05/sfa28),SUM(sfa062/sfa28),SUM(sfa063/sfa28)
            INTO l_sfa06,l_sfa05,l_sfa062,l_sfa063 FROM sfa_file
            WHERE sfa01=l_sfa.sfa01
             AND sfa27=l_sfa.sfa03
             AND sfa08=l_sfa.sfa08
             AND sfa12=l_sfa.sfa12
 
     #No.TQC-950039 modify --begin
         #LET l_sfa.sfa06  = l_sfa.sfa06  + l_sfa06
         #LET l_sfa.sfa05  = l_sfa.sfa05  + l_sfa05
         #LET l_sfa.sfa062 = l_sfa.sfa062 + l_sfa062
         #LET l_sfa.sfa063 = l_sfa.sfa063 + l_sfa063
          LET l_sfa.sfa06  = l_sfa06 
          LET l_sfa.sfa05  = l_sfa05 
          LET l_sfa.sfa062 = l_sfa062
          LET l_sfa.sfa063 = l_sfa063
       END IF
      IF l_sfa.sfa26 MATCHES '[US]' THEN
         CONTINUE FOREACH
      END IF
      LET l_cnt = l_cnt + 1 
     #No.TQC-950039 modify --end
 
      IF l_cnt = 1 THEN
        #LET l_min_set = l_sfa06 / l_sfa161
         LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08
         #-----MOD-990085---------
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         #-----END MOD-990085-----
         LET l_min_set_t = l_min_set
      ELSE
        #LET l_min_set = l_sfa06 / l_sfa161
         LET l_min_set=((l_sfa.sfa06-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08
         #-----MOD-990085---------
         IF cl_null(l_sfa.sfa100) THEN LET l_sfa.sfa100 = 0 END If
         IF g_sma.sma899 = 'Y' AND l_sfa.sfa100 <> 100 THEN 
            LET l_min_set = l_min_set * (1+l_sfa.sfa100/100)
         END IF
         #-----END MOD-990085-----
         IF l_min_set < l_min_set_t THEN
            LET l_min_set_t = l_min_set
         END IF
      END IF
   END FOREACH
  #-------------No.TQC-6A0057 end
  #CHI-6B0019--begin
  # sma73 工單完工數量是否檢查發料最小套數
  # sma74 工單完工量容許差異百分比
   LET l_over_qty = 0
   IF g_sma.sma73='Y' THEN  #
      CALL s_get_ima153(p_rvb05) RETURNING l_ima153  #FUN-910053 
     #LET l_over_qty=((l_min_set_t*g_sma.sma74)/100)#FUN-910053
      LET l_over_qty=((l_min_set_t*l_ima153)/100)  #FUN-910053
   ELSE
      LET l_over_qty=0
   END IF
   IF l_over_qty IS NULL THEN LET l_over_qty=0 END IF
   LET l_min_set_t = l_min_set_t + l_over_qty
  #CHI-6B0019--end
   RETURN l_min_set_t
END FUNCTION
#-------No.TQC-670091 end
 
#FUN-680011
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
   LET l_sql  = "SELECT rvb02 FROM rvb_file
        WHERE rvb01 = '",g_rva.rva01,"' AND rvb39='Y' AND rvb19 = '1'"
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
 
   # CALL aws_spccli()
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
#END FUN-680011
 
#-----TQC-710032---------
FUNCTION t110_mu_ui()

#FUN-9A0068--begin
#  CALL cl_set_comp_visible("rvb84,rvb81,rvb10,rvb10t",FALSE)  #FUN-6A0139 add rvb10,rvb10t
   IF g_argv6 ='2' THEN
      CALL cl_set_comp_visible("rvb84,rvb81",FALSE)
   ELSE
      CALL cl_set_comp_visible("rvb84,rvb81,rvb10,rvb10t",FALSE)
   END IF
#FUN-9A0068--end
   IF g_sma.sma115='Y' THEN
      CALL cl_set_comp_visible("rvb07",FALSE)
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
   #FUN-810038................begin
&ifdef ICD
      IF g_argv2='ICD' OR g_argv2='SUB' THEN
         CALL cl_set_act_visible("aic_qry_back,aic_s_icdin,aic_s_icdqry,aic_s_icdin_rec",TRUE)
      ELSE
         CALL cl_set_act_visible("aic_qry_back,aic_s_icdin,aic_s_icdqry,aic_s_icdin_rec",FALSE)
      END IF
&else
      CALL cl_set_act_visible("aic_qry_back,aic_s_icdin,aic_s_icdqry,aic_s_icdin_rec",FALSE)
&endif
   #FUN-810038................end
END FUNCTION
#-----END TQC-710032-----
#FUN-730068............begin
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
&ifdef ICD
   #No.FUN-7C0017...begin
   LET g_rvb[l_ac].rvbiicd03 = g_rvbi2.rvbiicd03
   LET g_rvb[l_ac].rvbiicd14 = g_rvbi2.rvbiicd14
   LET g_rvb[l_ac].rvbiicd11 = g_rvbi2.rvbiicd11
   LET g_rvb[l_ac].rvbiicd08 = g_rvbi2.rvbiicd08
   LET g_rvb[l_ac].rvbiicd10 = g_rvbi2.rvbiicd10
   LET g_rvb[l_ac].rvbiicd12 = g_rvbi2.rvbiicd12
   LET g_rvb[l_ac].rvbiicd15 = g_rvbi2.rvbiicd15
   LET g_rvb[l_ac].rvbiicd16 = g_rvbi2.rvbiicd16
   LET g_rvb[l_ac].rvbiicd06 = g_rvbi2.rvbiicd06
   LET g_rvb[l_ac].rvbiicd07 = g_rvbi2.rvbiicd07
   #No.FUN-7C0017...end
&endif
   #NO.FUN-840042 --start--
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
   #NO.FUN-840042 --end--
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
   IF cl_null(g_rvb2.rvb06) THEN LET g_rvb2.rvb06=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb07) THEN LET g_rvb2.rvb07=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb08) THEN LET g_rvb2.rvb08=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb09) THEN LET g_rvb2.rvb09=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb10) THEN LET g_rvb2.rvb10=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb29) THEN LET g_rvb2.rvb29=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb30) THEN LET g_rvb2.rvb30=0 END IF #CHI-7B0023
   IF cl_null(g_rvb2.rvb31) THEN LET g_rvb2.rvb31=0 END IF #CHI-7B0023
&ifdef ICD
   #No.FUN-7C0017...begin
   LET g_rvbi2.rvbi01 = g_rva.rva01       #TQC-950054
   LET g_rvbi2.rvbi02 = g_rvb[l_ac].rvb02 #TQC-950054
   LET g_rvbi2.rvbiicd03 = g_rvb[l_ac].rvbiicd03
   LET g_rvbi2.rvbiicd14 = g_rvb[l_ac].rvbiicd14
   LET g_rvbi2.rvbiicd11 = g_rvb[l_ac].rvbiicd11
   LET g_rvbi2.rvbiicd08 = g_rvb[l_ac].rvbiicd08
   LET g_rvbi2.rvbiicd10 = g_rvb[l_ac].rvbiicd10
   LET g_rvbi2.rvbiicd12 = g_rvb[l_ac].rvbiicd12
   LET g_rvbi2.rvbiicd15 = g_rvb[l_ac].rvbiicd15
   LET g_rvbi2.rvbiicd16 = g_rvb[l_ac].rvbiicd16
   LET g_rvbi2.rvbiicd06 = g_rvb[l_ac].rvbiicd06
   LET g_rvbi2.rvbiicd07 = g_rvb[l_ac].rvbiicd07
   #No.FUN-7C0017...end
&endif
   #No.FUN-840042 --start--
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
   #NO.FUN-840042 --end--
END FUNCTION
#FUN-730068............end
#MOD-770082-begin-add
#確認是否為製程委外工單
FUNCTION t110_ec_sw()
DEFINE     l_flag       LIKE type_file.chr1,
           x_sfb24        LIKE sfb_file.sfb24
 LET l_flag = 'N'
 IF g_argv2 ='SUB' THEN
    LET x_sfb24=''
    SELECT sfb24 INTO x_sfb24
      FROM sfb_file
     WHERE sfb01 = g_rvb[l_ac].rvb34
    IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
       LET l_flag='Y'
    END IF
 END IF
   RETURN l_flag
END FUNCTION
#MOD-770082-end-add
 
&ifdef ICD
#ICD begin
#FUN-810038................begin
#單據刻號維護作業
FUNCTION t110_ind_icd_icin()
   DEFINE l_dies LIKE rvb_file.rvb08
   DEFINE l_ida15  LIKE ida_file.ida15
   DEFINE l_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE l_imaicd08  LIKE imaicd_file.imaicd08
   DEFINE l_rvb  RECORD LIKE rvb_file.*
   DEFINE l_rvbi RECORD LIKE rvbi_file.*
   DEFINE l_pmn07 LIKE pmn_file.pmn07
 
   IF g_rva.rvaconf <> 'N' THEN
      CALL cl_err('','aic-098',1)
      RETURN
   END IF
 
   IF NOT cl_null(g_rva.rva01) AND g_rva.rvaconf = 'N' AND
      NOT cl_null(l_ac) AND l_ac <> 0 THEN
      #避免畫面資料是舊的，所以重撈
      INITIALIZE l_rvb.* TO NULL
      SELECT * INTO l_rvb.* FROM rvb_file
       WHERE rvb01 = g_rva.rva01 AND rvb02 = g_rvb[l_ac].rvb02
      IF SQLCA.sqlcode THEN #無資料離開
         RETURN
      END IF
 
      SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
        FROM imaicd_file
       WHERE imaicd00=l_rvb.rvb05
      IF SQLCA.sqlcode THEN #無資料離開
         CALL cl_err('','aic-107',1)
         RETURN
      END IF
 
      #刻號/BIN管理否?
      IF l_imaicd08<>'Y' OR cl_null(l_imaicd08) THEN
         CALL cl_err('','aic-108',1)
         RETURN
      END IF
 
      INITIALIZE l_rvbi.* TO NULL
      SELECT * INTO l_rvbi.* FROM rvbi_file
       WHERE rvbi01 = g_rva.rva01 AND rvbi02 = g_rvb[l_ac].rvb02
      IF SQLCA.sqlcode THEN #無資料離開
         RETURN
      END IF
 
      #Turnkey非最終站
      IF l_rvbi.rvbiicd13 = 'Y' THEN
         CALL cl_err('','aic-099',1)
         RETURN
      END IF
 
      #取採購單位
      SELECT pmn07 INTO l_pmn07 FROM pmn_file
       WHERE pmn01 = l_rvb.rvb04 AND pmn02 = l_rvb.rvb03
      LET l_dies = 0
 
      LET l_ida15=''  #傳NULL,改在s_indin中判斷
      CALL s_icdin(0,l_rvb.rvb05,l_rvb.rvb36,
                     l_rvb.rvb37,l_rvb.rvb38,
                     l_pmn07    ,l_rvb.rvb07,
                     g_rva.rva01,l_rvb.rvb02,
                     g_rva.rva06,l_ida15,
                     l_rvbi.rvbiicd14,'','')
           RETURNING l_dies
      CALL t110_ind_icd_upd_dies(l_dies)
   END IF
END FUNCTION
 
#更新die數
#當料號為wafer段時imaicd04=1,用dice數量加總給原將單據的第二單位數量。
#當料號為wafer段時imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量。
FUNCTION t110_ind_icd_upd_dies(p_dies)
   DEFINE p_dies      LIKE rvb_file.rvb08
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04  LIKE imaicd_file.imaicd04
 
   IF (g_sma.sma115 = 'Y') AND (p_dies > 0) THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 
        INTO l_ima906,l_imaicd04 
        FROM ima_file,imaicd_file
       WHERE ima01 = g_rvb[l_ac].rvb05
         AND imaicd00=ima01
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[13]' THEN
         IF l_imaicd04 MATCHES '[012]' THEN
            LET g_rvb[l_ac].rvb85 = p_dies             #數量
            LET g_rvb[l_ac].rvb84 = g_rvb[l_ac].rvb82/g_rvb[l_ac].rvb85
            BEGIN WORK
            UPDATE rvb_file set rvb84 = g_rvb[l_ac].rvb84,
                                rvb85 = g_rvb[l_ac].rvb85
             WHERE rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN       
               LET g_rvb[l_ac].rvb84 = g_rvb2.rvb84
               LET g_rvb[l_ac].rvb85 = g_rvb2.rvb85
               ROLLBACK WORK
            ELSE            
               LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
               LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85
               COMMIT WORK
            END IF
            DISPLAY BY NAME g_rvb[l_ac].rvb84, g_rvb[l_ac].rvb85
         END IF
      END IF   
   END IF      
END FUNCTION
 
#刻號入庫否維護
FUNCTION t110_ind_icd_icdin_rec()
   DEFINE l_cnt   SMALLINT
   DEFINE l_pmn07 LIKE pmn_file.pmn07
   DEFINE l_dies  LIKE rvb_file.rvb07
 
   IF g_rva.rvaconf != 'Y' THEN RETURN END IF
 
   IF cl_null(l_ac) THEN LET l_ac = 1 END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvv_file
     WHERE rvv04 = g_rva.rva01         #收貨單號
       AND rvv05 = g_rvb[l_ac].rvb02   #收貨項次
   IF l_cnt != 0 THEN RETURN END IF
 
   #委外tky非最終站,不可以使用
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvbi_file
     WHERE rvbi01 = g_rva.rva01
       AND rvbi02 = g_rvb[l_ac].rvb02 
       AND rvbiicd13 = 'Y'   #委外tky非最終站否
   IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN RETURN END IF
 
   #取採購單位
   SELECT pmn07 INTO l_pmn07 FROM pmn_file
      WHERE pmn01 = g_rvb[l_ac].rvb04
        AND pmn02 = g_rvb[l_ac].rvb03
 
   CALL s_icdin_rec(0,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                       g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                       g_rva.rva01,g_rvb[l_ac].rvb02,g_rva.rva06,
                       l_pmn07,g_rvb[l_ac].rvb07)
        RETURNING l_dies
END FUNCTION
 
#檢查是否有ida_file存在,若有則不允許更改相關欄位值
FUNCTION t110_ind_icd_chk_icd()
    IF g_rvb_t.rvb02 IS NULL THEN
       RETURN TRUE
    END IF
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM ida_file
       WHERE ida07 = g_rva.rva01
         AND ida08 = g_rvb_t.rvb02
    IF g_cnt > 0 THEN
       CALL cl_err('','aic-113',1)
       RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION
 
FUNCTION t110_ind_icd_trans_chk(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1   #a:新增   u:修改
   DEFINE l_sfa03    LIKE sfa_file.sfa03,
          l_sfa08    LIKE sfa_file.sfa08
   DEFINE l_sfe      RECORD LIKE sfe_file.*
   DEFINE l_idd      RECORD LIKE idd_file.*
   DEFINE l_ida      RECORD LIKE ida_file.*
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_n,l_n2   LIKE type_file.num5
   DEFINE l_sfbi     RECORD LIKE sfbi_file.*
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
   IF p_cmd <> 'u' THEN RETURN END IF
 
   SELECT * INTO l_sfbi.*
     FROM sfbi_file
     WHERE sfbi01 = g_rvb[l_ac].rvb34
 
   IF cl_null(l_sfbi.sfbiicd09) THEN
      RETURN
   END IF
 
   DECLARE sel_sfa CURSOR FOR
      SELECT sfa03,sfa08
        FROM sfa_file
        WHERE sfa01 = g_rvb[l_ac].rvb34    #工單編號
 
   FOREACH sel_sfa INTO l_sfa03,l_sfa08
      #判斷該發料料號料件狀態是否為'2.CP'
      IF l_sfa03 IS NULL THEN CONTINUE FOREACH END IF
      LET l_imaicd04  = ''
      #modify CHI-940010 by hellen -- begin 090408
      SELECT imaicd04  INTO l_imaicd04
#       FROM ima_file
        FROM imaicd_file
#      WHERE ima01 = l_sfa03
       WHERE imaicd00 = l_sfa03
      #modify CHI-940010 by hellen -- end 090408
      IF l_imaicd04  != '2' THEN
         CONTINUE FOREACH
      END IF
 
      IF p_cmd = 'u' THEN
         IF (g_rvb[l_ac].rvb36 <> g_rvb_t.rvb36) OR
            (g_rvb[l_ac].rvb37 <> g_rvb_t.rvb37) OR
            (g_rvb[l_ac].rvb38 <> g_rvb_t.rvb38) THEN
            SELECT COUNT(*) INTO l_n
               FROM ida_file
              WHERE ida07  = g_rva.rva01
                AND ida08  = g_rvb_t.rvb02
            SELECT COUNT(*) INTO l_n2
               FROM idg_file
              WHERE idg01  = g_rva.rva01
                AND idg02  = g_rvb_t.rvb02
            IF l_n > 0 OR l_n2 > 0 THEN
               #該轉料收貨單已有刻號明細/回貨資料,是否確定修改倉/儲/批
               IF NOT cl_confirm('aic-114') THEN
                  LET g_rvb[l_ac].rvb36 = g_rvb_t.rvb36
                  LET g_rvb[l_ac].rvb37 = g_rvb_t.rvb37
                  LET g_rvb[l_ac].rvb38 = g_rvb_t.rvb38
                  DISPLAY BY NAME g_rvb[l_ac].rvb36
                  DISPLAY BY NAME g_rvb[l_ac].rvb37
                  DISPLAY BY NAME g_rvb[l_ac].rvb38
                  RETURN
               END IF
            END IF
         END IF
      ELSE
         CALL t110_ind_icd_trans_copy_ida(l_sfa03,l_sfa08)
         CALL t110_ind_icd_trans_copy_idg()
      END IF
   END FOREACH
END FUNCTION 
 
#1.生產作業編號: 若符合下列條件, 則由發料之刻號及BIN作複製至收貨之刻號及BIN
#1.1入庫料號之狀態 (imaicd04)  = '2.已測Wafer'
#        (發料料號)
# 發料料號   刻號   BIN   Pass Bin   Die
#   A         1     BIN01     Y       2000
#   A         3     BIN02     Y       2100
#
# 生產料號   刻號   BIN   Pass Bin   Die
#   B         1     BIN01     Y       2000
#   B         3     BIN02     Y       2100
FUNCTION t110_ind_icd_trans_copy_ida(p_sfa03,p_sfa08)
   DEFINE l_sfe     RECORD LIKE sfe_file.*
   DEFINE l_idd  RECORD LIKE idd_file.*
   DEFINE l_ida RECORD LIKE ida_file.*
   DEFINE l_imaicd04       LIKE imaicd_file.imaicd04
   DEFINE p_sfa03   LIKE sfa_file.sfa03,
          p_sfa08   LIKE sfa_file.sfa08  
   DEFINE l_sfe16_sum  LIKE sfe_file.sfe16
 
   IF g_success = 'N' THEN RETURN END IF
 
   #取得該工單已發料數量(排除被做過換批的成套發料單)
   LET l_sfe16_sum = 0
   SELECT SUM(sfe16) INTO l_sfe16_sum
      FROM sfp_file,sfq_file,sfe_file
     WHERE (sfp08 IS NULL OR sfp08 = ' ')
       AND sfp06 = '1'              #成套發
       AND sfq02 = g_rvb2.rvb34     #工單單號
       AND sfp01 = sfq01            #單據編號
       AND sfe02 = sfp01            #單據編號
       AND sfe01 = sfq02            #工單單號
       AND sfe07 = p_sfa03          #料
       AND sfe14 = p_sfa08          #作業編號
       AND sfp04 = 'Y'              #過帳
   #檢查該工單發料總數是否與此收貨項次實收數量相等
   #若不相等,則無法做複製的動作
   IF l_sfe16_sum != g_rvb2.rvb07 THEN
      CALL cl_err('','aic-115',1)
      RETURN
   END IF
 
   #取得該工單備料的發料資訊
   DECLARE sel_sfe CURSOR FOR 
      SELECT sfe_file.* 
         FROM sfp_file,sfq_file,sfe_file
        WHERE (sfp08 IS NULL OR sfp08 = ' ')
          AND sfp06 = '1'              #成套發
          AND sfq02 = g_rvb2.rvb34     #工單單號
          AND sfp01 = sfq01            #單據編號
          AND sfe02 = sfp01            #單據編號
          AND sfe01 = sfq02            #工單單號
          AND sfe07 = p_sfa03          #料
          AND sfe14 = p_sfa08          #作業編號
          AND sfp04 = 'Y'              #過帳
 
   FOREACH sel_sfe INTO l_sfe.*
 
      #取得該工單發料之刻號明細資料
      DECLARE sel_idd CURSOR FOR
         SELECT * FROM idd_file
            WHERE idd01  = l_sfe.sfe07   #料
              AND idd02  = l_sfe.sfe08   #倉
              AND idd03  = l_sfe.sfe09   #儲
             #AND idd04  = l_sfe.sfe1    #批    #No.TQC-930136 mark
              AND idd04  = l_sfe.sfe10   #批    #No.TQC-930136 add
              AND idd10  = l_sfe.sfe02   #單號
              AND idd11  = l_sfe.sfe28   #項次
      FOREACH sel_idd INTO l_idd.*
         INITIALIZE l_ida.* TO NULL
         LET l_ida.ida01  = g_rvb2.rvb05           #料號
         LET l_ida.ida02  = g_rvb2.rvb36           #倉庫
         LET l_ida.ida03  = g_rvb2.rvb37           #儲位
         LET l_ida.ida04  = g_rvb2.rvb38           #批號
         LET l_ida.ida05  = l_idd.idd05      #刻號
         LET l_ida.ida06  = l_idd.idd06      #BIN
         LET l_ida.ida07  = g_rvb2.rvb01           #單據編號
         LET l_ida.ida08  = g_rvb2.rvb02           #單據項次
         LET l_ida.ida09  = g_rva.rva06            #異動日期
         LET l_ida.ida10  = l_idd.idd13      #實收數量
         LET l_ida.ida11  = l_idd.idd26      #不良數量
         LET l_ida.ida12  = l_idd.idd27      #報廢數量
         LET l_ida.ida13  = l_idd.idd07      #單位
         LET l_ida.ida14  = l_idd.idd15      #母體料號
         LET l_ida.ida15  = l_idd.idd16      #母批
         LET l_ida.ida16  = l_idd.idd17      #DATECODE
         LET l_ida.ida17  = l_idd.idd18      #DIE 數
         LET l_ida.ida18  = l_idd.idd19      #YIELD
         LET l_ida.ida19  = l_idd.idd20      #TEST #
         LET l_ida.ida20  = l_idd.idd21      #DEDUCT
         LET l_ida.ida21  = l_idd.idd22      #PASS BIN
         LET l_ida.ida21  = l_idd.idd22      #PASS BIN
         LET l_ida.ida22  = l_idd.idd23      #接單料號
 
         LET l_ida.ida27  = 'N'                    #轉入否
         LET l_ida.ida28  = '0'                    #異動別(出入庫別)
         LET l_ida.ida29  = l_idd.idd25      #備註
         LET l_ida.ida26  = 'Y'                    #入庫否
         LET l_ida.ida30  = ''                     #來源單號
         LET l_ida.ida31  = ''                     #來源項次
 
         LET l_ida.idaplant = g_plant #NO.FUN-980006 jarlin add
         LET l_ida.idalegal = g_legal #NO.FUN-980006 jarlin add
         INSERT INTO ida_file VALUES(l_ida.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err('ins ida',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   END FOREACH
END FUNCTION 
 
#2.Copy回貨資料: 
#若工單無記錄該張之入庫單號, 由則不用複製回貨資料, 
#若工單有記錄該張之入庫單號, 由該入庫單號回串收貨單號, 
#若該筆有回貨資料, 則copy回貨資料至該筆收貨單
#2.1 Copy同刻號之相關資料
#2.2 轉檔檔名: 發料料號之收貨單號
FUNCTION t110_ind_icd_trans_copy_idg()
   DEFINE l_rvv04   LIKE rvv_file.rvv04,
          l_rvv05   LIKE rvv_file.rvv05
   DEFINE l_idg  RECORD LIKE idg_file.*,
          l_idg2 RECORD LIKE idg_file.*
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sfbiicd16 LIKE sfbi_file.sfbiicd16
   DEFINE l_sfbiicd17 LIKE sfbi_file.sfbiicd17
 
   IF g_success = 'N' THEN RETURN END IF
 
   SELECT sfbiicd16,sfbiicd17
     INTO l_sfbiicd16,l_sfbiicd17
     FROM sfbi_file
    WHERE sfbi01=g_rvb2.rvb34
 
   #取得該工單之入庫單號項次資料
   LET l_rvv04 = ''
   LET l_rvv05 = ''
   SELECT rvv04,rvv05 INTO l_rvv04,l_rvv05
      FROM rvv_file
     WHERE rvv01 = l_sfbiicd16
       AND rvv02 = l_sfbiicd17
 
   DECLARE sel_idg CURSOR FOR
      SELECT * FROM idg_file
         WHERE idg01  = l_rvv04
           AND idg02  = l_rvv05
 
   FOREACH sel_idg INTO l_idg.*
      LET l_n = 0  
      SELECT COUNT(*) INTO l_n 
         FROM ida_file
        WHERE ida07  = g_rvb2.rvb01
          AND ida08  = g_rvb2.rvb02
          AND ida05  = l_idg.idg20   #刻號 
      IF l_n = 0  THEN
         CONTINUE FOREACH
      END IF
 
      LET l_idg2.* = l_idg.*
 
      LET l_idg2.idg01  = g_rvb2.rvb01        #收貨單號
      LET l_idg2.idg02  = g_rvb2.rvb02        #收貨項次
      LET l_idg2.idg04  = g_rvb2.rvb04        #採購單號
      LET l_idg2.idg05  = g_rvb2.rvb03        #採購項次
      LET l_idg2.idg07  = g_rvb2.rvb38        #批號
      LET l_idg2.idg17  = l_idg.idg01         #轉檔單名
      LET l_idg2.idg44  = g_rvb2.rvb05        #料號
 
      LET l_idg2.idgplant = g_plant #NO.FUN-980006 jarlin add
      LET l_idg2.idglegal = g_legal #NO.FUN-980006 jarlin add
      INSERT INTO idg_file VALUES(l_idg2.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('copy idg err:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION 
 
FUNCTION t110_ind_icd_def_tky(p_rvb01,p_rvb02,p_rvb03,p_rvb04)
   DEFINE l_n           LIKE type_file.num5
   DEFINE p_rvb01       LIKE rvb_file.rvb01,
          p_rvb02       LIKE rvb_file.rvb02,
          p_rvb03       LIKE rvb_file.rvb03,
          p_rvb04       LIKE rvb_file.rvb04
   DEFINE l_ecdicd01    LIKE ecd_file.ecdicd01
   DEFINE l_pmniicd03   LIKE pmni_file.pmniicd03
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
 
   #判斷若為委外收貨單TKY,非最後一站的項次,不更新收貨資料
   LET l_ecdicd01 = ' '
   SELECT pmniicd03,ecdicd01
     INTO l_pmniicd03,l_ecdicd01
     FROM pmni_file,ecd_file     #計算已入庫量
    WHERE pmni01 = p_rvb04
      AND pmni02 = p_rvb03
      AND pmniicd03 = ecd01  #作業編號
      AND pmniicd03 IS NOT NULL 
      AND pmniicd03 != ' '
   IF l_ecdicd01 = '6' THEN
      LET g_rvbi2.rvbiicd03 = ' '
      LET g_rvbi2.rvbiicd17 = l_pmniicd03
   ELSE
      LET g_rvbi2.rvbiicd03 = l_pmniicd03
      LET g_rvbi2.rvbiicd17 = ' '
   END IF
   LET g_rvb[l_ac].rvbiicd03 = g_rvbi2.rvbiicd03
   DISPLAY BY NAME g_rvb[l_ac].rvbiicd03
END FUNCTION
 
FUNCTION t110_ind_icd_set_rvb87_tky(p_cmd)
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_tky LIKE ecd_file.ecdicd01
   DEFINE p_cmd          LIKE type_file.chr1  #p:單身  a:其他
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
 
   IF p_cmd = 'b' THEN
      #委外tky非最終站否(rvbiicd13)='Y',允收數量(rvb33)=實收數量
      IF g_rvbi2.rvbiicd13  = 'Y' THEN 
         LET g_rvb2.rvb33  = g_rvb2.rvb07
         LET g_rvb2.rvb331 = g_rvb2.rvb82 #實收數量
         LET g_rvb2.rvb332 = g_rvb2.rvb85 #實收數量
         LET g_rvb2.rvb40  = g_today      #檢驗日期
         LET g_rvb2.rvb41  = 'OK'         #檢驗結果
      ELSE
         IF g_rvb2.rvb33 = 0 OR cl_null(g_rvb2.rvb33) THEN
            RETURN
         END IF
      END IF      
   END IF
 
   #取得工單作業編號
   LET l_ecdicd01_tky = ''
   SELECT ecdicd01 INTO l_ecdicd01_tky
      FROM pmni_file,ecd_file
     WHERE pmni01 = g_rvb2.rvb04
       AND pmni02 = g_rvb2.rvb03
       AND pmniicd03 IS NOT NULL
       AND pmniicd03 != ' '
       AND pmniicd03 = ecd01
 
   LET l_ecdicd01 = ''
   SELECT ecdicd01 INTO l_ecdicd01
      FROM ecd_file
     WHERE ecd01 = g_rvbi2.rvbiicd13
 
   CASE l_ecdicd01
        WHEN '2'  #CP: 計價數量= 可允收數(rvb33)
             LET g_rvb2.rvb87 = g_rvb2.rvb33
        WHEN '3'  #DS: 計價數量= 可允收數(rvb33)
             LET g_rvb2.rvb87 = g_rvb2.rvb33
        WHEN '4'  #ASS: 計價數量= 可允收數(rvb33)
             LET g_rvb2.rvb87 = g_rvb2.rvb33
        WHEN '5'  # FT: 計價數量= 可允收數(rvb33) + 不良品數(rvbiicd06)
             IF cl_null(g_rvbi2.rvbiicd06) THEN
                LET g_rvbi2.rvbiicd06=0
             END IF
             LET g_rvb2.rvb87 = g_rvb2.rvb33 + g_rvbi2.rvbiicd06
   END CASE
   IF l_ecdicd01 = '4' AND l_ecdicd01_tky = '6' THEN
      #TKY:若作業群組'4.ASS'= 可允收數(rvb33) + 不良品數(rvbiicd06)
      IF cl_null(g_rvbi2.rvbiicd06) THEN
         LET g_rvbi2.rvbiicd06=0
      END IF
      LET g_rvb2.rvb87 = g_rvb2.rvb33 + g_rvbi2.rvbiicd06
   END IF
 
   IF p_cmd = 'b' THEN
      LET g_rvb[l_ac].rvb87 = g_rvb2.rvb87
      DISPLAY BY NAME g_rvb[l_ac].rvb87
   END IF
END FUNCTION
 
FUNCTION t110_ind_icd_def_rvb10()
   DEFINE l_pmm22     LIKE pmm_file.pmm22,
          l_pmm21     LIKE pmm_file.pmm21,
          l_pmm43     LIKE pmm_file.pmm43,
          l_pmn20     LIKE pmn_file.pmn20,
          l_type      LIKE type_file.chr1
   DEFINE l_pmn86     LIKE pmn_file.pmn86
   DEFINE l_pmn87     LIKE pmn_file.pmn87   #No.MOD-8B0273 add
   DEFINE l_gec07     LIKE gec_file.gec07   #No.MOD-8B0273 add
   DEFINE l_pmn88     LIKE pmn_file.pmn88   #No.MOD-8B0273 add
   DEFINE l_pmn88t    LIKE pmn_file.pmn88t  #No.MOD-8B0273 add
   DEFINE l_pmm20     LIKE pmm_file.pmm20   #No.FUN-930148
   DEFINE l_pmm41     LIKE pmm_file.pmm41   #No.FUN-930148
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
   IF cl_null(g_rvbi2.rvbiicd17) THEN
      RETURN
   END IF 
 
   #若是TURNKEY要重算單價
   #call cs_price(最終料號,廠商編號,幣別,有效日期,
   #採購數量,作業編號,稅別,稅率, ICD作業編號)
   SELECT pmm22,pmm21,pmm43,pmn20,pmn86,pmn87,pmm20,pmm41              #No.MOD-8B0273 add pmn87  #NO.FUN-930148 add pmm20,pmm41
     INTO l_pmm22,l_pmm21,l_pmm43,l_pmn20,l_pmn86,l_pmn87,l_pmm20,l_pmm41  #No.MOD-8B0273 add pmn87   #NO.FUN-930148 add pmm20,pmm41
     FROM pmm_file,pmn_file
    WHERE pmm01 = pmn01
      AND pmn01 = g_rvb[l_ac].rvb04
      AND pmn02 = g_rvb[l_ac].rvb03
 
   #CALL s_defprice(g_rvb[l_ac].rvbiicd15,g_rva.rva05,      #TQC-9B0214---mark---
   CALL s_defprice_new(g_rvb[l_ac].rvbiicd15,g_rva.rva05,       #TQC-9B0214---add---
                  #l_pmm22,g_rva.rva06,l_pmn20,g_rvb[l_ac].rvbiicd03,  #No.MOD-8B0273 mark
#                  l_pmm22,g_rva.rva06,l_pmn87,g_rvb[l_ac].rvbiicd03,  #No.MOD-8B0273 add   #TQC-980183 Mark
                   l_pmm22,g_rva.rva06,l_pmn20,g_rvb[l_ac].rvbiicd03,  #No.TQC-980183 Add  
                   l_pmm21,l_pmm43,'2',l_pmn86,'',l_pmm41,l_pmm20,g_plant)   #NO.FUN-930148 add pmm20,pmm41  #TQC-9B0214-add g_plant---
        RETURNING g_rvb[l_ac].rvb10,g_rvb[l_ac].rvb10t #單價
 
   #No.TQC-980183--Mark--Begin--#
   #No.MOD-8B0273 add --begin
#  SELECT gec07 INTO l_gec07 FROM gec_file 
#   WHERE gec01 = l_pmm21 AND gec011 = '1'
#  SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
#   WHERE azi01 = l_pmm22 AND aziacti = 'Y'
#  IF l_gec07 = 'Y' THEN
#     LET l_pmn88t = l_pmn87*g_rvb[l_ac].rvb10t
#     LET l_pmn88t = cl_digcut(l_pmn88t,t_azi04)
#     LET l_pmn88  = l_pmn88t/(1+l_pmm43/100) 
#     LET l_pmn88  = cl_digcut(l_pmn88,t_azi04)
#     IF NOT cl_null(l_pmn87) AND l_pmn87 != 0 THEN
#        LET g_rvb[l_ac].rvb10 = l_pmn88/l_pmn87
#        LET g_rvb[l_ac].rvb10 = cl_digcut(g_rvb[l_ac].rvb10,t_azi03)
#     END IF
#  END IF
   #No.MOD-8B0273 add --end
   #No.TQC-980183--Mark--End--#
 
   LET g_rvb2.rvb10 = g_rvb[l_ac].rvb10
   LET g_rvb2.rvb10t= g_rvb[l_ac].rvb10t
   DISPLAY BY NAME g_rvb[l_ac].rvb10
   DISPLAY BY NAME g_rvb[l_ac].rvb10t
END FUNCTION
 
FUNCTION t110_ind_icd_def_qty_tky(l_rvb,p_cmd)
   DEFINE l_rvb07s_1,l_rvb07s_2 LIKE rvb_file.rvb07
   DEFINE l_rvb82s_1,l_rvb82s_2 LIKE rvb_file.rvb82
   DEFINE l_rvb85s_1,l_rvb85s_2 LIKE rvb_file.rvb85
   DEFINE l_rvb87s_1,l_rvb87s_2 LIKE rvb_file.rvb87
   DEFINE l_rvb07    LIKE rvb_file.rvb07
   DEFINE l_rvb82    LIKE rvb_file.rvb82
   DEFINE l_rvb85    LIKE rvb_file.rvb85
   DEFINE l_rvb87    LIKE rvb_file.rvb87
   DEFINE l_pmn07    LIKE pmn_file.pmn07
   DEFINE l_rvb      RECORD LIKE rvb_file.*
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_rvbi     RECORD LIKE rvbi_file.*
 
   LET l_rvb07s_1 = 0  LET l_rvb07s_2 = 0
   LET l_rvb82s_1 = 0  LET l_rvb82s_2 = 0
   LET l_rvb85s_1 = 0  LET l_rvb85s_2 = 0
   LET l_rvb87s_1 = 0  LET l_rvb87s_2 = 0
 
   IF (l_rvbi.rvbiicd13 = 'N' OR l_rvbi.rvbiicd13 IS NULL OR 
      l_rvbi.rvbiicd13 = ' ') THEN
      RETURN l_rvb.rvb07,l_rvb.rvb82,l_rvb.rvb85,l_rvb.rvb87
   END IF
 
   #實收數量
   SELECT SUM(rvb07)  INTO l_rvb07s_1
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=l_rvb.rvb04
      AND rvb03=l_rvb.rvb03
      AND rvbi01=rvb01
      AND rvbi02=rvb02
      AND rva01=rvb01
      AND rvaconf='N'
      AND rvb35='N'
      AND rvb01 != g_rva.rva01
      AND rvbiicd13 = 'Y' 
      AND rvbiicd03 = l_rvbi.rvbiicd03
 
   SELECT SUM(rvb07)  INTO l_rvb07s_2
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=l_rvb.rvb04
      AND rvb03=l_rvb.rvb03
      AND rvbi01=rvb01
      AND rvbi02=rvb02
      AND rva01=rvb01
      AND rvaconf='N'
      AND rvb35='N'
      AND rvb01 = g_rva.rva01
      AND rvb02!= l_rvb.rvb02
      AND rvbiicd13 = 'Y' 
      AND rvbiicd03 = l_rvbi.rvbiicd03
 
   #單位一數量,單位二數量,計價數量
   SELECT SUM(rvb82),SUM(rvb85),SUM(rvb87)
     INTO l_rvb82s_1,l_rvb85s_1,l_rvb87s_1
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=l_rvb.rvb04
      AND rvb03=l_rvb.rvb03
      AND rvbi01=rvb01
      AND rvbi02=rvb02
      AND rva01=rvb01
      AND rvaconf != 'X'
      AND rvb35='N'
      AND rvb01 != g_rva.rva01
      AND rvbiicd13 = 'Y'
      AND rvbiicd03 = l_rvbi.rvbiicd03
 
   SELECT SUM(rvb82),SUM(rvb85),SUM(rvb87)
     INTO l_rvb82s_2,l_rvb85s_2,l_rvb87s_2
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=l_rvb.rvb04
      AND rvb03=l_rvb.rvb03
      AND rvbi01=rvb01
      AND rvbi02=rvb02
      AND rva01=rvb01
      AND rvaconf != 'X'
      AND rvb35='N'
      AND rvb01 = g_rva.rva01
      AND rvb02!= l_rvb.rvb02
      AND rvbiicd13 = 'Y' 
      AND rvbiicd03 = l_rvbi.rvbiicd03
 
   IF cl_null(l_rvb07s_1) THEN LET l_rvb07s_1 =0 END IF
   IF cl_null(l_rvb82s_1) THEN LET l_rvb82s_1 =0 END IF
   IF cl_null(l_rvb85s_1) THEN LET l_rvb85s_1 =0 END IF
   IF cl_null(l_rvb87s_1) THEN LET l_rvb87s_1 =0 END IF
   IF cl_null(l_rvb07s_2) THEN LET l_rvb07s_2 =0 END IF
   IF cl_null(l_rvb82s_2) THEN LET l_rvb82s_2 =0 END IF
   IF cl_null(l_rvb85s_2) THEN LET l_rvb85s_2 =0 END IF
   IF cl_null(l_rvb87s_2) THEN LET l_rvb87s_2 =0 END IF
 
   #取得採購數量等資訊
   LET l_rvb07 =0 LET l_rvb82 = 0  
   LET l_rvb85 = 0  LET l_rvb87 = 0
   SELECT pmn20,pmn82,pmn85,pmn87,pmn07
     INTO l_rvb07,l_rvb82,l_rvb85,l_rvb87,l_pmn07
     FROM pmn_file
    WHERE pmn01 = l_rvb.rvb04
      AND pmn02 = l_rvb.rvb03
 
   IF cl_null(l_rvb07) THEN LET l_rvb07 =0 END IF
   IF cl_null(l_rvb82) THEN LET l_rvb82 =0 END IF
   IF cl_null(l_rvb85) THEN LET l_rvb85 =0 END IF
   IF cl_null(l_rvb87) THEN LET l_rvb87 =0 END IF
 
   LET l_rvb.rvb07=l_rvb07-l_rvb07s_1-l_rvb07s_2
   LET l_rvb.rvb82=l_rvb82-l_rvb82s_1-l_rvb82s_2
   LET l_rvb.rvb85=l_rvb85-l_rvb85s_1-l_rvb85s_2
   LET l_rvb.rvb87=l_rvb87-l_rvb87s_1-l_rvb87s_2
   
   LET l_rvb.rvb84= l_rvb.rvb82 / l_rvb.rvb85
 
   #--------計價數量---------------------------------
   #  單據單位             計價單位
   IF l_pmn07 != l_rvb.rvb86 THEN
      #單位換算
      LET g_factor = 1
      CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_rvb.rvb86)
           RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
      LET l_rvb.rvb87 = l_rvb.rvb07 * g_factor
   ELSE
      LET l_rvb.rvb87 = l_rvb.rvb07
   END IF
 
   IF p_cmd = 'b' THEN
      LET g_rvb[l_ac].rvb07=l_rvb.rvb07
      LET g_rvb[l_ac].rvb82=l_rvb.rvb82
      LET g_rvb[l_ac].rvb85=l_rvb.rvb85
      LET g_rvb[l_ac].rvb87=l_rvb.rvb87
 
      LET g_rvb[l_ac].rvb84=l_rvb.rvb84
   END IF
 
   RETURN l_rvb.rvb07,l_rvb.rvb82,l_rvb.rvb85,l_rvb.rvb87
END FUNCTION
 
#修改數量,若料號有展明細(ta_ima080) ='Y',
#則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
FUNCTION t110_ind_icd_chk_icdqty()
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04,
          l_imaicd08   LIKE imaicd_file.imaicd08
   DEFINE l_flag       LIKE type_file.num5
 
   IF NOT (g_argv2='ICD' OR g_argv2='SUB') THEN
      RETURN TRUE
   END IF
   IF g_rvbi2.rvbiicd13 = 'Y' THEN RETURN TRUE END IF
 
   SELECT imaicd08,imaicd04 INTO l_imaicd08,l_imaicd04
     FROM imaicd_file
    WHERE imaicd00 = g_rvb[l_ac].rvb05
   IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN
      CALL s_icdchk(0,g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb36,
                       g_rvb[l_ac].rvb37,g_rvb[l_ac].rvb38,
                       g_rvb[l_ac].rvb07,g_rva.rva01,
                       g_rvb[l_ac].rvb02,g_rva.rva06,'') 
           RETURNING l_flag
      RETURN l_flag
   END IF
   RETURN TRUE
END FUNCTION
 
#   料號為參考單位,單一單位,且狀態為其它段生產料號(imaicd04=3,4)時,
#   將單位一的資料給單位二
FUNCTION t110_ind_icd_set_value()
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04  LIKE imaicd_file.imaicd04
 
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 
        INTO l_ima906,l_imaicd04 
        FROM ima_file,imaicd_file
       WHERE ima01 = g_rvb[l_ac].rvb05
         AND ima01=imaicd00
 
      #若料號為單一單位, 如IC料號, 出入庫不回寫單位二級單位二數量
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
         IF l_imaicd04 MATCHES '[34]' THEN
            LET g_rvb[l_ac].rvb83 = g_rvb[l_ac].rvb80 #單位
            LET g_rvb[l_ac].rvb85 = g_rvb[l_ac].rvb82 #數量
            LET g_rvb[l_ac].rvb84 = g_rvb[l_ac].rvb82/g_rvb[l_ac].rvb85
 
            LET g_rvb2.rvb83 = g_rvb[l_ac].rvb83
            LET g_rvb2.rvb84 = g_rvb[l_ac].rvb84
            LET g_rvb2.rvb85 = g_rvb[l_ac].rvb85
 
            DISPLAY BY NAME g_rvb[l_ac].rvb83,
                            g_rvb[l_ac].rvb84,
                            g_rvb[l_ac].rvb85
 
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION t110_ind_icd_def_qty()
   DEFINE l_rvb07s_1,l_rvb07s_2 LIKE rvb_file.rvb07 
   DEFINE l_rvb82s_1,l_rvb82s_2 LIKE rvb_file.rvb82 
   DEFINE l_rvb85s_1,l_rvb85s_2 LIKE rvb_file.rvb85 
   DEFINE l_rvb87s_1,l_rvb87s_2 LIKE rvb_file.rvb87 
 
   LET l_rvb07s_1 = 0  LET l_rvb07s_2 = 0
   LET l_rvb82s_1 = 0  LET l_rvb82s_2 = 0
   LET l_rvb85s_1 = 0  LET l_rvb85s_2 = 0
   LET l_rvb87s_1 = 0  LET l_rvb87s_2 = 0
 
   #實收數量
   SELECT SUM(rvb07)  INTO l_rvb07s_1 
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=g_rvb[l_ac].rvb04 
      AND rvb03=g_rvb[l_ac].rvb03
      AND rvb01=rvbi01
      AND rvb02=rvbi02
      AND rva01=rvb01 
      AND rvaconf='N' 
      AND rvb35='N'
      AND rvb01 != g_rva.rva01
      #若為委外TKY,要排除非最後一站的數量
      AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
 
   SELECT SUM(rvb07)  INTO l_rvb07s_2
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=g_rvb[l_ac].rvb04
      AND rvb03=g_rvb[l_ac].rvb03
      AND rvb01=rvbi01
      AND rvb02=rvbi02
      AND rva01=rvb01
      AND rvaconf='N'
      AND rvb35='N'
      AND rvb01 = g_rva.rva01
      AND rvb02!= g_rvb[l_ac].rvb02 
      #若為委外TKY,要排除非最後一站的數量
      AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
 
   #單位一數量,單位二數量,計價數量
   SELECT SUM(rvb82),SUM(rvb85),SUM(rvb87) 
     INTO l_rvb82s_1,l_rvb85s_1,l_rvb87s_1
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=g_rvb[l_ac].rvb04
      AND rvb03=g_rvb[l_ac].rvb03
      AND rva01=rvb01
      AND rvb01=rvbi01
      AND rvb02=rvbi02
      AND rvaconf != 'X'
      AND rvb35='N'
      AND rvb01 != g_rva.rva01
      #若為委外TKY,要排除非最後一站的數量
      AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
 
   SELECT SUM(rvb82),SUM(rvb85),SUM(rvb87)
     INTO l_rvb82s_2,l_rvb85s_2,l_rvb87s_2
     FROM rva_file,rvb_file,rvbi_file
    WHERE rvb04=g_rvb[l_ac].rvb04
      AND rvb03=g_rvb[l_ac].rvb03
      AND rva01=rvb01
      AND rvb01=rvbi01
      AND rvb02=rvbi02
      AND rvaconf != 'X'
      AND rvb35='N'
      AND rvb01 = g_rva.rva01
      AND rvb02!= g_rvb[l_ac].rvb02
      #若為委外TKY,要排除非最後一站的數量
      AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
 
   IF cl_null(l_rvb07s_1) THEN LET l_rvb07s_1 =0 END IF
   IF cl_null(l_rvb82s_1) THEN LET l_rvb82s_1 =0 END IF
   IF cl_null(l_rvb85s_1) THEN LET l_rvb85s_1 =0 END IF
   IF cl_null(l_rvb87s_1) THEN LET l_rvb87s_1 =0 END IF
   IF cl_null(l_rvb07s_2) THEN LET l_rvb07s_2 =0 END IF
   IF cl_null(l_rvb82s_2) THEN LET l_rvb82s_2 =0 END IF
   IF cl_null(l_rvb85s_2) THEN LET l_rvb85s_2 =0 END IF
   IF cl_null(l_rvb87s_2) THEN LET l_rvb87s_2 =0 END IF
 
   LET g_rvb2.rvb07=g_rvb[l_ac].rvb07-l_rvb07s_1-l_rvb07s_2
   LET g_rvb2.rvb82=g_rvb[l_ac].rvb82-l_rvb82s_1-l_rvb82s_2
   LET g_rvb2.rvb85=g_rvb[l_ac].rvb85-l_rvb85s_1-l_rvb85s_2
   LET g_rvb2.rvb87=g_rvb[l_ac].rvb87-l_rvb87s_1-l_rvb87s_2
 
   LET g_rvb[l_ac].rvb07=g_rvb2.rvb07
   LET g_rvb[l_ac].rvb82=g_rvb2.rvb82
   LET g_rvb[l_ac].rvb85=g_rvb2.rvb85
   LET g_rvb[l_ac].rvb87=g_rvb2.rvb87
 
   LET g_rvb2.rvb84 = g_rvb2.rvb82 / g_rvb2.rvb85
   LET g_rvb[l_ac].rvb84 = g_rvb2.rvb84
 
   
   #--------計價數量---------------------------------
   #  單據單位             計價單位
   IF g_rvb[l_ac].rvb90 != g_rvb[l_ac].rvb86 THEN     #No.FUN-940083 pmn07-->rvb90
      #單位換算
      LET g_factor = 1
      CALL s_umfchk(g_rvb[l_ac].rvb05,g_rvb[l_ac].rvb90,g_rvb[l_ac].rvb86)  #No.FUN-940083 pmn07-->rvb90 
           RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
      LET g_rvb2.rvb87 = g_rvb2.rvb07 * g_factor
   ELSE
      LET g_rvb2.rvb87 = g_rvb2.rvb07
   END IF  
   LET g_rvb[l_ac].rvb87 = g_rvb2.rvb87
END FUNCTION
 
#若為委外收貨TKY,要將所對應之製程檔作業編號依序產生至收貨單身
FUNCTION t110_ind_icd_ecm()
   DEFINE l_rvb RECORD    LIKE rvb_file.*
#  DEFINE l_rvbi RECORD   LIKE rvbi_file.*        #No.FUN-7B0018
   DEFINE l_pmniicd03     LIKE pmni_file.pmniicd03
   DEFINE l_ecdicd01      LIKE ecd_file.ecdicd01
   DEFINE l_ecm04         LIKE ecm_file.ecm04
   DEFINE l_cnt,l_ecm_cnt LIKE type_file.num5
   DEFINE l_pmm20         LIKE pmm_file.pmm20   #No.FUN-930148
   DEFINE l_pmm41         LIKE pmm_file.pmm41   #No.FUN-930148
   DEFINE l_pmm22         LIKE pmm_file.pmm22,    #
          l_pmn20         LIKE pmn_file.pmn20,    #採購數量
          l_pmm21         LIKE pmm_file.pmm21,    #稅別     
          l_pmm43         LIKE pmm_file.pmm43,    #稅率
          l_pmn86         LIKE pmn_file.pmn86
&ifndef STD
   DEFINE l_rvbi          RECORD LIKE rvbi_file.* #No.FUN-7B0018
&endif
 
   LET l_pmniicd03 = ''
   LET l_pmm22 = '' 
   LET l_pmn20 = ''
   LET l_pmm21 = ''
   LET l_pmm43 = ''
   SELECT pmniicd03,pmn20,pmm21,pmm22,pmm43,pmn86,pmm20,pmm41                   #No.FUN-930148  add pmm20,pmm41
     INTO l_pmniicd03,l_pmn20,l_pmm21,l_pmm22,l_pmm43,l_pmn86,l_pmm20,l_pmm41   #No.FUN-930148  add pmm20,pmm41
     FROM pmn_file,pmm_file,pmni_file 
    WHERE pmn01 = g_rvb2.rvb04  #採購單號
      AND pmn02 = g_rvb2.rvb03  #採購項次
      AND pmm01 = pmn01
      AND pmn01 = pmni01
      AND pmn02 = pmni02
 
   IF g_argv2 = 'SUB' AND NOT cl_null(l_pmniicd03) THEN
      LET l_ecdicd01 = ''
      SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
         WHERE ecd01 = l_pmniicd03
 
      IF l_ecdicd01 = '6' THEN   #6.TKY
         #取得該工單製程站總數
         LET l_ecm_cnt = 0
         SELECT COUNT(*) INTO l_ecm_cnt FROM ecm_file
            WHERE ecm01 = g_rvb2.rvb34   #工單單號
 
         DECLARE ecm_dec CURSOR FOR
            SELECT ecm04 FROM ecm_file
               WHERE ecm01 = g_rvb2.rvb34   #工單單號
               ORDER BY ecm03
         LET l_cnt = 1
         LET l_rvb.* = g_rvb2.*
         LET l_rvbi.* = g_rvbi2.*
         FOREACH ecm_dec INTO l_ecm04
           #CHI-920064...............begin
           #IF l_cnt = 1 THEN
           #   LET l_rvb.rvb02 = g_rvb2.rvb02     #項次
           #ELSE
           #   LET l_rvb.rvb02 = l_rvb.rvb02 + 1 #項次
           #END IF
            LET l_rvb.rvb02 = l_rvb.rvb02 + 1 #項次
           #CHI-920064...............end
            LET l_rvbi.rvbiicd03 = l_ecm04         #ICD作業編號          
            LET l_rvb.rvb36 = 'MISC'              #倉庫
            LET l_rvb.rvb37 = 'MISC'              #儲位
            #TQC-9B0214-------start-------
            #CALL s_defprice(l_rvbi.rvbiicd15,g_rva.rva05,l_pmm22,g_rva.rva06,
            #                l_pmn20,l_rvbi.rvbiicd03,l_pmm21,l_pmm43,'2',
            #                l_pmn86,'',l_pmm41,l_pmm20)     #No.FUN-930148  add pmm20,pmm41
            CALL s_defprice_new(l_rvbi.rvbiicd15,g_rva.rva05,l_pmm22,g_rva.rva06,
                            l_pmn20,l_rvbi.rvbiicd03,l_pmm21,l_pmm43,'2',
                            l_pmn86,'',l_pmm41,l_pmm20,g_plant)   
                 RETURNING l_rvb.rvb10,l_rvb.rvb10t        #單價
            #TQC-9B0214-------end------- 
            #含稅單價
            #LET l_rvb.rvb10t = l_rvb.rvb10 * (1.00+ l_pmm43 / 100.0)
 
            LET l_rvbi.rvbiicd17 = l_pmniicd03
 
            IF l_cnt = l_ecm_cnt THEN EXIT FOREACH END IF
 
            LET l_rvbi.rvbiicd13 = 'Y'      #委外TKY,非最後一站
 
            #委外tky非最終站的數量獨立計算
            CALL t110_ind_icd_def_qty_tky(l_rvb.*,'g') 
                 RETURNING l_rvb.rvb07,l_rvb.rvb82,l_rvb.rvb85,l_rvb.rvb87
 
            #委外tky非最終站否(rvbiicd13)='Y',允收數量(rvb33)=實收數量
            LET l_rvb.rvb33 = l_rvb.rvb07 
            LET l_rvb.rvb331= l_rvb.rvb82 #實收數量
            LET l_rvb.rvb332= l_rvb.rvb85 #實收數量
            LET l_rvb.rvb40 = g_today     #檢驗日期
            LET l_rvb.rvb41 = 'OK'        #檢驗結果
            
	          LET l_rvbi.rvbiicd04 = 'N'
            LET l_rvbi.rvbiicd10 = 'N'
 
            LET l_rvb.rvbplant = g_plant #NO.FUN-980006 jarlin add
            LET l_rvb.rvblegal = g_legal #NO.FUN-980006 jarlin add
            INSERT INTO rvb_file VALUES(l_rvb.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('ins rvb(ecm)',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               RETURN
&ifndef STD
            #No.FUN-7B0018 080306 add --begin
            ELSE
&ifdef ICD  
               #CHI-920064
              #INITIALIZE l_rvbi.* TO NULL  #CHI-920064 此處不可初始化,否則先前給的欄位資料都沒了
&endif
               LET l_rvbi.rvbi01 = l_rvb.rvb01
               LET l_rvbi.rvbi02 = l_rvb.rvb02
               IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
                  LET g_success ='N'
                  RETURN
               END IF
            #No.FUN-7B0018 080306 add --end
&endif
            END IF
 
            #No.FUN-7B0018 080306 mark --begin
#           LET l_rvbi.rvbi01=l_rvb.rvb01
#           LET l_rvbi.rvbi02=l_rvb.rvb02
#           INSERT INTO rvbi_file VALUES(l_rvbi.*)
#           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err('ins rvbi(ecm)',SQLCA.SQLCODE,1)
#              LET g_success = 'N'
#              RETURN 
#           END IF
            #No.FUN-7B0018 080306 mark --end
            LET l_cnt = l_cnt + 1
         END FOREACH
         IF l_ecm_cnt = l_cnt THEN
            LET g_rvb2.rvb02 = l_rvb.rvb02          #項次
            LET g_rvb2.rvb10 = l_rvb.rvb10          #單價
            LET g_rvb2.rvb10t= l_rvb.rvb10t         #含稅單價
            LET g_rvbi2.rvbiicd03 = l_rvbi.rvbiicd03  #作業群組
            LET g_rvbi2.rvbiicd17 = l_rvbi.rvbiicd17  #
         END IF
      END IF
   END IF
END FUNCTION 
 
#8.計價數量: 作業編號(rvbiicd03)串作業編號檔,
#  若作業群組(ecdicd01)屬不同類型, 則計價數量如下
#8.1 CP: 計價數量= 可允收數(rvb33)
#8.2 DS: 計價數量= 可允收數(rvb33)
#8.3 ASS: 計價數量= 可允收數(rvb33)
#8.4 FT: 計價數量= 可允收數(rvb33) + 不良品數(rvbiicd06)
#8.5 TKY:
#8.5.1若作業群組'4.ASS': 可允收數(rvb33) + 不良品數(rvbiicd06)
#8.5.2若作業群組'5.FT': 可允收數(rvb33) + 不良品數(rvbiicd06)
FUNCTION t110_ind_icd_upd_rvb87()
   IF g_success = 'N' THEN RETURN END IF
   IF g_argv2 != 'SUB' THEN RETURN END IF
 
   INITIALIZE g_rvb2.* TO NULL
 
   DECLARE upd_rvb87 CURSOR FOR
      SELECT rvb_file.*,rvbi_file.* FROM rvb_file,rvbi_file
        WHERE rvb01 = g_rva.rva01
          AND rvb01 = rvbi01
          AND rvb02 = rvbi02
          AND rvbiicd03 IS NOT NULL
          AND rvbiicd03 != ' '
	        AND rvb87 <> 0 #如果user輸入為零則不重計計價數量
 
   FOREACH upd_rvb87 INTO g_rvb2.*,g_rvbi2.*
      CALL t110_ind_icd_set_rvb87_tky('a')
 
      UPDATE rvb_file SET rvb87 = g_rvb2.rvb87
         WHERE rvb01 = g_rvb2.rvb01
           AND rvb02 = g_rvb2.rvb02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd rvb87',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION 
 
#判斷
#若是產生入庫資料,則入庫異動數量必須等於,
#    該收貨單刻號明細入庫否='Y'的總異動數量
#若是產生驗退資料,則驗退異動數量必須等於,
#    該收貨單刻號明細入庫否='N'的總異動數量
FUNCTION t110_ind_icd_chk_icdin_yn(l_rvv,p_rvu00)
   DEFINE p_rvu00       LIKE rvu_file.rvu00,
          l_idd13       LIKE idd_file.idd13,
          l_idd07       LIKE idd_file.idd07,
          l_imaicd04    LIKE imaicd_file.imaicd04,
          l_imaicd08    LIKE imaicd_file.imaicd08,
          l_rvv17       LIKE rvv_file.rvv17,
          l_fac         LIKE rvv_file.rvv35
   DEFINE l_rvv         RECORD LIKE rvv_file.*
 
   LET l_imaicd04 =  NULL
   LET l_imaicd08 = NULL
   #取得料件狀態,是否展明細資訊
   SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
      FROM imaicd_file
     WHERE imaicd00 = l_rvv.rvv31
   IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN
      IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF  #入庫
      IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF  #驗退
      #若為產生入庫資料,則取得該收貨單刻號明細入庫否='Y'的總異動數量
      #若為產生驗退資料,則取得該收貨單刻號明細入庫否='N'的總異動數量
      SELECT SUM(idd13),idd07 INTO l_idd13,l_idd07
         FROM idd_file
        WHERE idd10 = l_rvv.rvv04  #收貨單號
          AND idd11 = l_rvv.rvv05  #收貨項次
          AND idd24 = 'Y' #收貨時無法決定是否入庫  p_rvu00      #入庫否
        GROUP BY idd07
 
      IF cl_null(l_idd13) THEN LET l_idd13 = 0 END IF
 
      LET l_fac = 0
 
      IF l_rvv.rvv35 != l_idd07 THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_idd07)
              RETURNING g_i,l_fac
         IF g_i = 1 THEN
            ### ------單位無法轉換--------####
            CALL cl_err('rvv35/idd07: ','abm-731',1)
            LET g_success ='N'
            RETURN
         END IF
      END IF
      IF cl_null(l_fac) OR l_fac = 0 THEN LET l_fac = 1 END IF
 
      LET l_rvv17 = l_rvv.rvv17 * l_fac
 
      #判斷
      #若是產生入庫資料,則入庫異動數量必須等於,
      #    該收貨單刻號明細入庫否='Y'的總異動數量
      #若是產生驗退資料,則驗退異動數量必須等於,
      #    該收貨單刻號明細入庫否='N'的總異動數量
      IF l_rvv17 != l_idd13 THEN
         LET g_msg = "[Rec No.",l_rvv.rvv04,"  Line:",
                     l_rvv.rvv05 USING '<<<<<',"]"
         IF p_rvu00 = 'Y' THEN
            CALL cl_err(g_msg,'aic-118',1)
         END IF
         IF p_rvu00 = 'N' THEN
            CALL cl_err(g_msg,'aic-119',1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION t110_ind_icd_upd_rvvxx(l_rvv)
   DEFINE l_rvv       RECORD LIKE rvv_file.*
   DEFINE l_rvb       RECORD LIKE rvb_file.*
   DEFINE l_rvbi      RECORD LIKE rvbi_file.*
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE l_icg27     LIKE icg_file.icg27
 
   #1.計價數量(rvv87)= rvb87 
   #2.金額(rvv39)           
   #2-1.FT金額: 
   #   [可允收數(rvb33) + 不良品數(rvbiicd06)] * 採購單價 + 
   #   [可允收數(rvb33) *  Lead Scan Price(icg27)]
   #   Lead Scan Price: 以最終料號(rvbiicd15)+廠商(rvu04)+
   #                    作業編號(rvbiicd03)帶出 
   #2-2.其他金額: 比照Package
 
   #3.單價(rvv38)
   #3-1.FT單價 = 金額(rvv39)/ 計價數量(rvv87)
   #3-2.其他單價: 比照Package
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
   IF l_rvv.rvv03 != '1' THEN RETURN END IF
   IF g_success = 'N' THEN RETURN END IF
 
   INITIALIZE l_rvb.* TO NULL
   SELECT * INTO l_rvb.* FROM rvb_file
      WHERE rvb01 = l_rvv.rvv04
        AND rvb02 = l_rvv.rvv05
 
   INITIALIZE l_rvbi.* TO NULL
   SELECT * INTO l_rvbi.* FROM rvbi_file
      WHERE rvbi01 = l_rvb.rvb01
        AND rvbi02 = l_rvb.rvb02
 
   LET l_rvv.rvv87 = l_rvb.rvb87       #計價數量
 
   #-->取得作業群組
   
   LET l_ecdicd01 = ''
   SELECT ecdicd01 INTO l_ecdicd01
     FROM ecd_file
    WHERE ecd01 = l_rvbi.rvbiicd03  
 
   IF l_ecdicd01 = '5' THEN
      #-->取得Lead Scan Price
      SELECT icg27 INTO l_icg27
         FROM icg_file
        WHERE icg01 = l_rvbi.rvbiicd15 #最終料號
          AND icg02 = g_rva.rva05     #廠商
          AND icg03 = l_rvbi.rvbiicd03 #作業編號
      IF cl_null(l_icg27) THEN LET l_icg27 = 0 END IF 
 
      LET l_rvv.rvv39 = (l_rvb.rvb33 + l_rvbi.rvbiicd06)*l_rvb.rvb10 +
                        (l_rvb.rvb33 * l_icg27)
                        
      LET l_rvv.rvv38 = l_rvv.rvv39 / l_rvv.rvv87
   END IF
 
   UPDATE rvv_file SET rvv87 = l_rvv.rvv87,
                       rvv38 = l_rvv.rvv38,
                       rvv39 = l_rvv.rvv39
      WHERE rvv01 = l_rvv.rvv01
        AND rvv02 = l_rvv.rvv02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd rvv87',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN 
   END IF
END FUNCTION 
 
FUNCTION t110_ind_icd_ins_icin(p_rvv01,p_rvv02,p_rvv04,p_rvv05,p_rvu00)
   DEFINE p_rvv01       LIKE rvv_file.rvv01
   DEFINE p_rvv02       LIKE rvv_file.rvv02
   DEFINE p_rvv04       LIKE rvv_file.rvv04
   DEFINE p_rvv05       LIKE rvv_file.rvv05
   DEFINE l_ida     RECORD LIKE ida_file.*
   DEFINE l_idd      RECORD LIKE idd_file.*
   DEFINE p_rvu00       LIKE type_file.chr1     #Y:入庫 N:驗退 
 
  IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF
  IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF
 
  DECLARE t110_ins_icin_cs CURSOR FOR
     SELECT * INTO l_idd.* FROM idd_file
       WHERE idd10 = p_rvv04
         AND idd11 = p_rvv05
         AND idd12 = 0
         AND idd24 = 'Y' #p_rvu00  #入庫否  
         AND idd12 = 0        #收貨
  FOREACH t110_ins_icin_cs INTO l_idd.*
     INITIALIZE l_ida.* TO NULL
     LET l_ida.ida01 = l_idd.idd01    #料號
     LET l_ida.ida02 = l_idd.idd02    #倉庫
     LET l_ida.ida03 = l_idd.idd03    #儲位
     LET l_ida.ida04 = l_idd.idd04    #批號
     LET l_ida.ida05 = l_idd.idd05    #刻號
     LET l_ida.ida06 = l_idd.idd06    #BIN
     LET l_ida.ida07 = p_rvv01              #單據編號
     LET l_ida.ida08 = p_rvv02              #單據項次
     LET l_ida.ida09 = l_idd.idd08    #異動日期
     LET l_ida.ida10 = l_idd.idd13    #實收數量
     LET l_ida.ida11 = l_idd.idd26    #不良數量
     LET l_ida.ida12 = l_idd.idd27    #報廢數量
     LET l_ida.ida13 = l_idd.idd07    #單位
     LET l_ida.ida14 = l_idd.idd15    #母體料號
     LET l_ida.ida15 = l_idd.idd16    #母批
     LET l_ida.ida16 = l_idd.idd17    #DATECODE
     LET l_ida.ida17 = l_idd.idd18    #DIES 數
     LET l_ida.ida18 = l_idd.idd19    #YIELD
     LET l_ida.ida19 = l_idd.idd20    #TEST #
     LET l_ida.ida20 = l_idd.idd21    #DEDUCT
     LET l_ida.ida21 = l_idd.idd22    #PASSBIN
     LET l_ida.ida22 = l_idd.idd23    #接單料號
     LET l_ida.ida27 = 'N'                   #轉入否
     IF p_rvu00 = 'Y' THEN LET l_ida.ida28 = 1 END IF
     IF p_rvu00 = 'N' THEN LET l_ida.ida28 = 0 END IF
     LET l_ida.ida29 = l_idd.idd25   #備註
     LET l_ida.ida30 = p_rvv04
     LET l_ida.ida31 = p_rvv05
 
     LET l_ida.idaplant = g_plant #NO.FUN-980006 jarlin add
     LET l_ida.idalegal = g_legal #NO.FUN-980006 jarlin add
     INSERT INTO ida_file VALUES(l_ida.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('ins ida_file for rvv',SQLCA.sqlcode,1)
        LET g_success='N'
        RETURN
     END IF
   END FOREACH
END FUNCTION
 
#-->確認時 check  若該工單是作業群組(ecdicd01) = '6.TKY',
#委外TKY收貨作業站別是否與委外工單作業製程站別是否相等
FUNCTION t110_ind_icd_chk_tky()
   DEFINE l_rvb34  LIKE rvb_file.rvb34,
          l_ecm04  LIKE ecm_file.ecm04
   DEFINE l_n      LIKE type_file.num5
 
   IF g_argv2 != 'SUB' THEN RETURN END IF
 
   DECLARE chk_tky_cur CURSOR FOR
      SELECT DISTINCT rvb34 FROM rvb_file,rvbi_file
         WHERE rvb01 = g_rva.rva01   
           AND rvb01=rvbiicd01  #CHI-920064
           AND rvb02=rvbiicd02  #CHI-920064
           AND rvbiicd17 IS NOT NULL AND rvbiicd17 != ' '
           AND rvb34 IS NOT NULL 
           AND rvbiicd03 IS NOT NULL
           AND rvbiicd03 !=' '
 
   FOREACH chk_tky_cur INTO l_rvb34
      #取得該工單之製程資料
      DECLARE ecm_cur CURSOR FOR
         SELECT ecm04 FROM ecm_file
            WHERE ecm01 = l_rvb34
      FOREACH ecm_cur INTO l_ecm04
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM rvb_file,rvbi_file
            WHERE rvb01 = g_rva.rva01
              AND rvb01=rvbiicd01  #CHI-920064
              AND rvb02=rvbiicd02  #CHI-920064
              AND rvbiicd03 = l_ecm04
              AND rvbiicd17 IS NOT NULL AND rvbiicd17 != ' '
              AND rvb34 IS NOT NULL AND rvbiicd03 IS NOT NULL
              AND rvbiicd03 !=' '
 
         #委外TKY收貨作業站別與委外工單作業製程站別不符或不齊全,請查核!!
         IF l_n = 0 THEN
            CALL cl_err('','aic-121',1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH  
   END FOREACH
 
END FUNCTION 
#FUN-810038................end
#ICD end
&endif
#No.FUN-840178--begin--
FUNCTION t110_rvb05(p_cmd)
DEFINE p_cmd  LIKE  type_file.chr1,
     l_ima02  LIKE  ima_file.ima02,
     l_ima021 LIKE  ima_file.ima021,
     l_ima25  LIKE  ima_file.ima25,                     #FUN-940083
     l_ima35  LIKE  ima_file.ima35,                     #FUN-940083
     l_ima36  LIKE  ima_file.ima36                      #FUN-940083
    
    SELECT ima02 ,ima021,ima25,ima35,ima36              #FUN-940083 add 單位/倉庫/儲位
      INTO l_ima02,l_ima021,l_ima25,l_ima35,l_ima36     #FUN-940083 add 單位/倉庫/儲位
      FROM ima_file
     WHERE ima01 = g_rvb[l_ac].rvb05
     
     CASE WHEN SQLCA.sqlcode =100  LET g_errno ='mfg3008'
                                       LET l_ima02 = ''
                                       LET l_ima021= ''
         OTHERWISE                     LET g_errno =SQLCA.sqlcode USING '------'
     END CASE 
     
     IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET  g_rvb[l_ac].rvb051 = l_ima02    #FUN-940083 pmn041-->rvb051
       LET  g_rvb[l_ac].ima021 = l_ima021
       LET  g_rvb[l_ac].rvb90  = l_ima25    #FUN-940083
       LET  g_rvb[l_ac].rvb36  = l_ima35    #FUN-940083
       LET  g_rvb[l_ac].rvb37  = l_ima36    #FUN-940083
 
     END IF 
END FUNCTION        
#No.FUN-840178 --end--
#Patch....NO.MOD-5A0095 <003,001,002> #
#Patch....NO.TQC-610036 <001> #
 
#FUN-940083--begin
FUNCTION t110_rvb89(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_pmh24   LIKE pmh_file.pmh24 
DEFINE l_pmhacti LIKE pmh_file.pmhacti
DEFINE l_pmc914  LIKE pmc_file.pmc914 
  
  LET g_errno =''
 
  SELECT pmh24,pmhacti INTO l_pmh24,l_pmhacti
    FROM pmh_file WHERE pmh01 = g_rvb[l_ac].rvb05
     AND pmh02 = g_rva.rva05
#FUN-9A0068--begin
     AND pmh13 = g_rva.rva113
     AND pmh21 = ' '
     AND pmh22 = '1'
     AND pmh23 = ' '
#FUN-9A0068--end
  
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
           DISPLAY BY NAME g_rvb[l_ac].rvb36
           DISPLAY BY NAME g_rvb[l_ac].rvb37
           CALL cl_set_comp_entry("rvb36,rvb37",FALSE)     
        END IF
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t110_rvb90(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gfeacti LIKE gfe_file.gfeacti  
 
  LET g_errno =''
 
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01=g_rvb[l_ac].rvb90 
 
  CASE WHEN SQLCA.sqlcode =100  LET g_errno ='mfg3098'
       WHEN l_gfeacti = 'N'     LET g_errno = '9028'
      OTHERWISE                 LET g_errno =SQLCA.sqlcode USING '------'
 
  END CASE 
 
  IF cl_null(g_errno) THEN
     DISPLAY BY NAME g_rvb[l_ac].rvb90
  END IF
 
END FUNCTION
#FUN-940083--end
 
#No.MOD-880189--begin--
FUNCTION t110_chk_rva05(p_rva01,p_rva05)
DEFINE   p_rva01        LIKE rva_file.rva01
DEFINE   p_rva05        LIKE rva_file.rva05
DEFINE   l_pmm09        LIKE pmm_file.pmm09
DEFINE   l_rvb04        LIKE rvb_file.rvb04
 
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
#No.MOD-880189---end---

#FUN-9A0068--begin
FUNCTION t110_chk_rvb36()
DEFINE l_ime12            LIKE ime_file.ime12
 
   LET g_errno = ' '
   IF cl_null(g_rvb[l_ac].rvb36) OR cl_null(g_rvb[l_ac].rvb37) THEN
      RETURN
   END IF
 
   SELECT ime12 INTO l_ime12 FROM ime_file WHERE ime01 = g_rvb[l_ac].rvb36
                                             AND ime02 = g_rvb[l_ac].rvb37
   IF SQLCA.SQLCODE THEN LET g_errno = SQLCA.SQLCODE END IF
   IF g_rvb[l_ac].rvb89 = 'Y' THEN
      IF l_ime12 = '0' THEN
         LET g_errno = 'apm-329'
      END IF
   ELSE
      IF l_ime12 = '1' THEN
         LET g_errno = 'apm-309'
      END IF
   END IF
END FUNCTION
#FUN-9A0068--end

#FUN-9A0065---BEGIN
FUNCTION t110_epr()
 DEFINE   l_cnt   LIKE   type_file.num5
 DEFINE   l_sum   LIKE   type_file.num5
 DEFINE   l_count LIKE   type_file.num5 
 DEFINE   i       LIKE   type_file.num5 
 DEFINE   l_pmc03 LIKE   pmc_file.pmc03
 DEFINE   l_sql   STRING 
 
  OPEN WINDOW p1101_w WITH FORM "apm/42f/apmt110_e"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("apmt110_e")

  WHILE TRUE
    INPUT  g_pmc01  FROM  pmc01     
    
      AFTER FIELD pmc01
        IF NOT cl_null(g_pmc01) THEN
           LET l_count = 0
           SELECT COUNT(*) INTO l_count FROM pmc_file
            WHERE pmc01 = l_pmc01
           IF l_count = 0 THEN
           #   CALL cl_err('','此厂商编号不存在',0)
              NEXT FIELD pmc01
           END IF 
        END IF
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmc01)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="" 
            LET g_qryparam.default1 = g_pmc01
            CALL cl_create_qry() RETURNING g_pmc01
            DISPLAY g_pmc01 TO  pmc01
            LET  g_pmc01 = ''
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
       EXIT WHILE
    END IF    
    LET l_sql = " SELECT 'N',wpe01,wpe04,'',wpe02,wpe05,'','',wpe06 ",
                " FROM wpe_file ",
                " WHERE wpe03 = '",g_pmc01,"'  ",
                " ORDER BY wpe01 " CLIPPED
    PREPARE t110_e FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF

    DECLARE t110_wpe CURSOR FOR t110_e

    CALL g_wpe.clear()
    
    LET l_cnt=1
    LET g_cnt = 0
    FOREACH t110_wpe INTO g_wpe[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('preparE_e:',SQLCA.sqlcode,1) EXIT FOREACH
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
    END INPUT
    
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
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
          ROLLBACK WORK
          CALL cl_err('','無符合之資料產生',1)
       ELSE
          COMMIT WORK
          CALL cl_err('','收货单产生成功',1)
          CALL t110_reshow()   
          EXIT WHILE  
       END IF     
    END IF
  END WHILE 
    CLOSE WINDOW p1101_w            
END FUNCTION

FUNCTION t110_ins_rva()
 DEFINE   li_result   LIKE   type_file.num5
 DEFINE   l_rva01     LIKE   rva_file.rva01
 DEFINE   l_wpa08     LIKE   wpa_file.wpa08

  INITIALIZE g_rva1.* TO NULL
  LET g_rva1.rva00 = '1'
  LET g_rva1.rva02 = ''
  LET g_rva1.rva04 = 'N'
  LET g_rva1.rva05 = g_pmc01
  LET g_rva1.rva06 = g_today
  LET l_wpa08 = ''
  SELECT wpa08 INTO l_wpa08 FROM wpa_file WHERE wpa01 = g_rva1.rva01
  CALL s_auto_assign_no("apm",l_wpa08,g_rva1.rva06,"3","rva_file","rva01","","","")
      RETURNING li_result,l_rva01
  IF (NOT li_result) THEN
     CALL s_errmsg('','','','abm-62',1)                                                                                   
     LET g_success = 'N' 
  END IF
  LET g_rva1.rva01 = l_rva01
  LET g_rva1.rva10 = 'SUB'
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
 DEFINE   l_rvb87   LIKE   rvb_file.rvb87
 DEFINE   l_rvb29   LIKE   rvb_file.rvb29
 DEFINE   l_ima491  LIKE   ima_file.ima491
 DEFINE   l_img09   LIKE   img_file.img09
 DEFINE   l_flag    LIKE   type_file.num5
 DEFINE   l_fac     LIKE   rvb_file.rvb90_fac 
   INITIALIZE g_rvb1.* TO NULL
   INITIALIZE l_pmn.* TO NULL
   SELECT * INTO l_pmn.* FROM pmn_file 
    WHERE pmn01 = g_wpe[p_i].wpe04 
      AND pmn02 = g_wpe[p_i].wpe05 
   LET g_rvb1.rvb01 = g_rva1.rva01
   LET g_rvb1.rvb02 = p_sum
   LET g_rvb1.rvb03 = l_pmn.pmn02
   LET g_rvb1.rvb04 = l_pmn.pmn01
   LET g_rvb1.rvb05 = l_pmn.pmn04
   LET g_rvb1.rvb06 = 0
   LET g_rvb1.rvb90 = l_pmn.pmn07
   LET l_rvb87 = 0
   LET l_rvb29 = 0
   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02
      AND rva01 = rvb01 AND rvaconf = 'N'
       
   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
   
   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file
    WHERE rvb04 = l_pmn.pmn01 AND rvb03 = l_pmn.pmn02  
      AND rva01 = rvb01 AND rvaconf = 'N'

   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF

   LET g_rvb1.rvb07 = l_pmn.pmn20-l_pmn.pmn50+l_pmn.pmn55-l_rvb87+l_rvb29
   IF  g_rvb1.rvb07 > g_wpe[p_i].wpe06 THEN
       LET g_rvb1.rvb07 = g_wpe[p_i].wpe06
   END IF  
   LET g_rvb1.rvb08 = g_rvb1.rvb07
   LET g_rvb1.rvb09 = 0
   LET g_rvb1.rvb10 = l_pmn.pmn31
   LET g_rvb1.rvb10t = l_pmn.pmn31t 
 
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = g_rvb1.rvb05
   IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF  
   
   IF l_ima491 >0 THEN
      CALL s_getdate(g_rva1.rva06,l_ima491) RETURNING g_rvb1.rvb12
   ELSE
      IF cl_null(g_rvb1.rvb12)  THEN
        LET g_rvb1.rvb12 = g_rva1.rva06
      END IF
   END IF
   LET g_rvb1.rvb13 = NULL
   LET g_rvb1.rvb14 = NULL
   LET g_rvb1.rvb15 = 0
   LET g_rvb1.rvb16 = 0
   LET g_rvb1.rvb17 = NULL
   LET g_rvb1.rvb18 = '10'
   LET g_rvb1.rvb19 = l_pmn.pmn65
   LET g_rvb1.rvb20 = NULL
   LET g_rvb1.rvb21 = NULL
   LET g_rvb1.rvb25 = l_pmn.pmn71
   LET g_rvb1.rvb27 = 0
   LET g_rvb1.rvb28 = 0
   LET g_rvb1.rvb29 = 0
   LET g_rvb1.rvb30 = 0
   LET g_rvb1.rvb31 = g_rvb1.rvb07
   LET g_rvb1.rvb32 = 0 
   LET g_rvb1.rvb33 = 0
   LET g_rvb1.rvb331 = 0
   LET g_rvb1.rvb332 = 0
   LET g_rvb1.rvb34 = l_pmn.pmn41
   LET g_rvb1.rvb35 = 'N'
   LET g_rvb1.rvb89 = l_pmn.pmn89
   LET g_rvb1.rvb051 = l_pmn.pmn041
   
   IF g_rvb1.rvb89 = 'Y'  THEN
     SELECT pmc915,pmc916 INTO g_rvb1.rvb36,g_rvb1.rvb37
      FROM pmc_file  WHERE pmc01 = g_rvb1.rvb05
   ELSE
     LET g_rvb1.rvb36 = l_pmn.pmn52
     LET g_rvb1.rvb37 = l_pmn.pmn54
     IF cl_null(g_rvb1.rvb36) AND cl_null(g_rvb1.rvb37)  THEN
        SELECT ima35,ima36 INTO g_rvb1.rvb36,g_rvb1.rvb37
          FROM ima_file WHERE ima01 = g_rvb1.rvb05
     END IF    
   END IF
   
   LET g_rvb1.rvb38 = l_pmn.pmn56
   IF g_rvb1.rvb38 IS NULL THEN
      LET g_rvb1.rvb38 = ' '
   END IF
   IF g_rvb1.rvb37 IS NULL THEN
      LET g_rvb1.rvb37 = ' '
   END IF   
   SELECT img09 INTO l_img09  FROM img_file
    WHERE img01 = g_rvb1.rvb05
      AND img02 = g_rvb1.rvb36
      AND img03 = g_rvb1.rvb37
      AND img04 = g_rvb1.rvb38
   CALL s_umfchk(g_rvb1.rvb05,g_rvb1.rvb90,l_img09) RETURNING l_flag,l_fac   
   IF l_flag THEN
      CALL cl_err(g_rvb1.rvb90,'mfg7003',1)
      LET g_rvb1.rvb90_fac = 1
   ELSE
      LET g_rvb1.rvb90_fac = l_fac   
   END IF
   
   CALL p220_get_rvb39(g_rvb1.rvb04,g_rvb1.rvb05,g_rvb1.rvb19) 
        RETURNING g_rvb1.rvb39
        
   LET g_rvb1.rvb40 = ' '
   LET g_rvb1.rvb80 = l_pmn.pmn80
   LET g_rvb1.rvb81 = l_pmn.pmn81
   LET g_rvb1.rvb82 = l_pmn.pmn82
   LET g_rvb1.rvb83 = l_pmn.pmn83
   LET g_rvb1.rvb84 = l_pmn.pmn84
   LET g_rvb1.rvb85 = l_pmn.pmn85
   LET g_rvb1.rvb86 = l_pmn.pmn86
   LET g_rvb1.rvb87 = g_rvb1.rvb07
   LET g_rvb1.rvb88 = g_rvb1.rvb87*g_rvb1.rvb10
   LET g_rvb1.rvb88t = g_rvb1.rvb87*g_rvb1.rvb10t
   LET g_rvb1.rvb930 = l_pmn.pmn930
   LET g_rvb1.rvbplant = g_plant
   LET g_rvb1.rvblegal = g_legal
   LET g_rvb1.rvb42 = ' '
   LET g_rvb1.rvb93 =  g_wpe[p_i].wpe01   
   INSERT INTO rvb_file VALUES (g_rvb1.*)
   IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
      CALL s_errmsg('','','ins rvb_file',SQLCA.sqlcode,1)                                                                                   
      LET g_success = 'N'   
   END IF   
   UPDATE wpe_file SET wpe07 = 'Y' 
    WHERE wpe01 =  g_wpe[p_i].wpe01
   IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
      CALL s_errmsg('','','upd wpe_file',SQLCA.sqlcode,1)                                                                                   
      LET g_success = 'N'   
   END IF         
END FUNCTION

FUNCTION t110_reshow()
   INITIALIZE g_rva.* TO NULL
   LET g_rva.* = g_rva1.*
   CALL t110_show()
END FUNCTION
#FUN-9A0065---END
#No.TQC-930136 #icd問題

