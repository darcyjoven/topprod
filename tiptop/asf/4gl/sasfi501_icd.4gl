# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: asfi501.4gl
# Descriptions...: 工單發/退料作業
# Date & Author..: 97/06/12 By Roger
#                  相關修改: 請執行 i501.sql 內容如下:
#                            alter sfe_file.sfe28->smallint
#                            update sfe28=0
#                            alter sfs_file add sfs22,23,24,25,26,27,28
#                            alter sfs_file's index
#                            alter sfq_file add afq04,sfq06
#                            update sfq04=' '
#                            alter sfq_file's index
# Modify.........: 97/07/24 By Sophia CHECK sma894 是否庫存可扣至負數
# Modify.........: 97/08/08 By Sophia 多傳一參數-發料單號
# Modify.........: 97/10/17 By Sophia 扣帳碼由0,1改為Y,N
# Modify.........: 01-05-07 BY ANN CHEN No.B496 單頭成套發料考量作業編號
# Modify.........: No:7730 03/08/06 Carol 扣帳時判斷扣帳日期不得小於工單開立日期
# Modify.........: No:7741 03/08/07 Carol 條件式加 AND sfp04<>'X' 作廢單據不應計算進來
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:7792,7867 03/08/20 Carol 工單成套發料 ,套數輸入的地方若未輸入亦可以
#                                              輸入單身資料,這樣會照成成本計算錯誤
#                                           -->判斷 asfi511(成套發料) 套數不可<=0
# Modify.........: No:7155 03/08/21 Carol 成套發料(asfi511): 利用G.產生調撥單
#                                         若該筆資料於撥入之庫存還有庫存量
#                                         則不會產生調撥單->顯示訊息告訴user
# Modify.........: No:7864 03/08/29 Carol oracle 成套發料 ,未回寫欠料量
#                                         -> i501sub_short() SQL 中 MATCHES '[xxxx]' 未轉換為 IN ('x','x'..)
#                                            modify sasfi501.ora
# Modify.........: No:8247 03/11/10 Melody 在撿量不可將已作廢發料單納入考慮
# Modify.........: No:9297 04/03/04 Melody after input sfp06不可空白 --> genero modify per:sfp06 設 not null, required
# Modify.........: No:9351 04/03/17 Melody 此段 IF.... END IF 內容應予以刪除，原意應為判斷應為消耗性料件,但卻與工單單身比較，使得取替代料時會造成問題。
# Modify.........: No:9390 04/03/31 Melody 在工單委外代買發料時選1.依料件主要倉庫/儲位發退料時,會將委外代買料件一併發料造成負庫存及負發料數!!請將i501_g_b1()的bug no:2551之下,行數1652的mark
#                                          ##"  AND (sfa05-sfa065)>0" #應發-委外代買量>0,此行復元即可!
# Modify.........: No:B038,B039 04/04/12 Melody 1."1.成套發料"==不允在單身打套數中沒有的工單
#                                               2."1.成套發料"==在過帳時,須檢查發料套數/qpa是否與套數欄的工單套數一致,(以防有工單單頭記錄發料10套,單身料件卻全部發完的情況)
# Modify.........: No:9485 04/04/23 Melody 已扣帳的資料會被刪除掉,且tlf_file資料還留
# Modify.........: No:8561 04/06/03 Melody 超領出現負值
# Modify.........: No:9743 04/07/09 Carol 當發料單位和庫存單位相同時,應將轉換率(l_factor)指定為1,否則當系統在判斷發料量是否大於庫存量時(after field sfs05),會檢查不出。
# Modify.........: No:9738 04/07/09 Carol 將此發料單的套數資料完整呈現後再由user去調整資料即可避免條件下在套數的地方
#                                         查詢出來將此張工單用F2刪除後，會連原本沒刪除的另一張工單也不見的問題
#                                         -->因i501_d_i()的寫法非標準的雙檔架構
# Modify.........: No:9724 04/07/20 Carol AFTER FIELD sfs04若為事後性扣帳g_argv2='4'or ='9'時
#                                         要判斷下階料件是否為消耗性料件，應seleect工單單身之sfa11，
#                                         非料件主檔之ima70
#                                         -->因sfa_file key(sfa01,sfa03,sfa08,sfa12)
#                                          sfs_file對應欄位(sfs03,sfs04,sfs06,sfs10)
#                                          so 改在 sfs10 做檢查問題檢查
# Modify.........: MOD-470508(9794) 04/07/23 Carol 檢查『異動類別』不可空白
#                                          --> per sfp06 設 not null required
# Modify.........: MOD-490204 04/09/10 By Smapmin 將挪料的CHECKBOX於新增時預設為"N"
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.FUN-4A0076 04/10/12 By Carol 1.工單單號開窗只開出有欠料的工單
#                                                  2.下階料號開窗應只開出該工單有欠料的料號
# Modify.........: No.FUN-4A0077 04/10/12 By Carol 1.選擇套數及單身時於工單單號應選出領料套數未完之工單
#                                                  2.單身之下階料號應只開出該工單之下階料,並show出應發及已發量或未發
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0145 04/10/18 By Mandy 重新產生單身時,輸入的倉/儲/批無重新給NULL
# Modify.........: No.MOD-4A0262 04/10/19 By Smapmin 修正新增時,單身的作業編號開窗
# Modify.........: No.MOD-4A0307 04/10/25 By Mandy AFTER INSERT IF INT_FLAG THEN ......�面用CANCEL INSERT END IF
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4B0040 04/11/10 By Carol 1.押右邊"庫存不足查詢"放棄就不能過帳
#                                                  2.庫存足夠,查詢庫存不足有出現資料出來
# Modify.........: No.MOD-4B0145 04/11/17 By Carol 如備料有做取替代料時,如以庫存量發料時(4)時,主料備料如欠料則單身會產生欠料資料,但如果是取替代料,欠料的話卻不會產生欠料資料
#                                                  ->因issue_qty被改變了,造成後續數量計算會有問題
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-4B0288 04/11/30 By Carol Bug No:7226 段若img09 抓不到時，l_unit帶空字串會產生有問題之調撥單。
#                                                  ->應該在抓不到 img09 的判斷中，再抓料件主檔之發料單位(ima63)
# Modify.........: No.MOD-4C0010 04/12/02 By Mandy DEFINE smydesc欄位用LIKE方式
# Modify.........: No.MOD-4C0058 04/12/13 By Carol 已結案的工單，其欠料補料單應不可再還原
# Modify.........: No.MOD-4C0126 04/12/21 By Carol 超領單不控制 --so '2' 要拿掉不check sfa06 > sfa05的狀況
# Modify.........: No.MOD-4C0133 04/12/29 By ching q_sfa8 不必sfa062>0
# Modify.........: No.MOD-510163 05/01/25 By Melody _out()段的 LET g_prog=....應該remark起來,否則影響過帳段 s_upimg的判斷
# Modify.........: No.MOD-520059 05/02/17 By ching asf-524 cl_err 參數3給 1
# Modify.........: No.MOD-520061 05/02/22 By ching 套數輸入修改
# Modify.........: No.FUN-510029 05/02/22 By Mandy 報表轉XML
# Modify.........: No.MOD-530024 05/03/11 By ching fix 尾階取替代錯誤
# Modify.........: No.MOD-530381 05/03/28 By pengu  套數單身輸入時，作業編號欄位應可進行查詢
# Modify.........: No.FUN-550052 05/05/25 By Trisy 單據編號加大
# Modify.........: No.FUN-550011 05/05/31 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550073 05/06/01 By day   單據性質傳錯
# Modify.........: No.FUN-560016 05/06/08 By Elva  新增雙單位內容
# Modify.........: No.FUN-560194 05/06/22 By Elva  判斷庫存數量imgg10是否超出
# Modify.........: No.FUN-560153 05/06/24 By Carol 1.顯示欠料兩個字
# Modify.........: No.FUN-560153 05/06/24 By Carol 2.無法進行正常之取替代
# Modify.........: No.FUN-560153 05/06/24 By Carol 4.perlang 字串相反：U:取代； S: 替代
# Modify.........: No.MOD-560218 05/07/14 By pengu  i501_s2函式回應錯誤訊息CALLcl_err(b_sfs.sfs07,'asf-724',0)
                                          #         將其設為強制開窗，避免使用者看不到訊息
# Modify.........: No.MOD-570241 05/07/21 By pengu  1.若使用倒扣料方式,先入庫再發料,此時若將發料單刪除時,狀態碼會變成'2',應該為'7'
                                              #     2.在本作業套數鍵入完成後彈出的單身自動產生條件詢問視窗時!若選3.依工單倉儲產生
                                              #       完全依造該工單備料檔中的倉庫default
                                              #     3.存入tlf024,tlf034的值不正確
                                              #     4.只要是全數取替代就無法退料
# Modify.........: No.MOD-540074 05/08/04 By Carol  委外工單已收貨入庫不可做發料還原
# Modify.........: No.MOD-580252 05/08/23 By kim 1.發料單號編碼放大 2.外部呼叫的邏輯修正
# Modify.........: No.FUN-580132 05/08/25 By Carrier SMT產生調撥時加入多單位內容
# Modify.........: No.MOD-580001 05/09/07 By kim 料倉儲批的DEFINE全部改用LIKE
# Modify.........: No.MOD-590028 05/09/07 By kim i501()供外部呼叫,當asfp510呼叫時,不執行 501_q()
# Modify.........: No.MOD-590120 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-590347 05/09/16 By Carrier mark du_default()
# Modify.........: No.MOD-580337 05/09/06 By Claire 以on change 觸發，原用after field處理
# Modify.........: No.FUN-560047 05/09/06 By Claire 在成套發及補料單(sfp06=1 or 3)同一張備料單，單身也要考慮同一張工單的發料是否有於應發量
# Modify.........: No.MOD-550052 05/09/12 By Claire 在超領單過帳還原時欠料量計算錯誤
# Modify.........: No.MOD-550045 05/09/21 By Claire 第二次發取替代料時,當已發>應,發料量會寫至超領,而非做取替代應發量的增加
# Modify.........: No.MOD-5A0010 05/10/24 By pengu  EXIT INPUT不應該mark，否則按「放棄」永遠跳不出INPUT段
# Modify.........: No.MOD-590408 05/10/24 By pengu 第5707行 MATCHES '[xxxx]' 未轉換為 IN ('x','x'..)
# Modify.........: No.MOD-530747 05/10/24 By pengu  工單退料需卡已入庫之齊料套數不可退超過已入庫之約當數
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.TQC-5B0198 05/12/09 By kim 修正 FUN-510029 (報表轉XML)的錯誤
# Modify.........: No.MOD-5C0048 05/12/09 By kim 退料至指定倉庫時,卻退至主要倉庫
# Modify.........: No.MOD-5B0323 05/12/13 By kim 退料時,有新舊料取代關係時,先退新料再退舊料
# Modify.........: No.FUN-5B0127 05/12/13 By kim 成套發料單取消過帳時，應該檢查一下超領單,退料單,FQC單,入庫,生產日報等有沒有未扣帳資料
# Modify.........: No.MOD-5C0041 05/12/08 By Claire 委外工單未確認,欲可輸入發料單,造成工單無法回頭確認,且無任何錯誤訊息.
# Modify.........: No.FUN-5C0055 05/12/19 By kim 更新工單狀態為'4'時,不應該考慮sfs_file是否存在
# Modify.........: No.MOD-5C0030 05/12/23 By Pengu 同張發料單同一筆料分入兩次發料的情況管控不嚴,照成允許多發料情形
# Modify.........: No.MOD-5B0289 05/12/23 By Pengu 單身件取替代備料時若用鍵盤按'enter' 有控管替代碼的正確性
#                                                  但若直接用滑鼠點選確定時卻沒有進行控管
# Modify.........: No.FUN-5B0037 05/12/27 By Sarah 單頭沒有需填入工單資料,應該不用再SHOW出i501-g-b-w之畫面
# Modify.........: No.TQC-610022 06/01/06 By Claire 修改 MOD-5B0289問題
# Modify.........: No.FUN-5C0114 06/01/16 By kim GP3.0重複性生產ASR-發料,領料,退料功能
# Modify.........: No.FUN-610090 06/02/06 By Nicola 拆併箱功能修改
# Modify.........: No.FUN-610042 06/02/22 By Sarah "庫存不足查詢"時,以ARR_CURR依多單位參數 add action "多單位庫存查詢"(du_detail)
# Modify.........: No.TQC-620157 06/02/06 By kim 該程式利用查尋功能選擇工單欄位查詢 , 結果卻開料件主檔窗
# Modify.........: No.FUN-630001 06/03/02 By kim GP3.0重複性生產 發/領/退料列印功能
# Modify.........: No.TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: NO.TQC-620156 06/03/09 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO.MOD-630064 06/03/17 By kim ASR的料號開窗要過濾只出現ASR料
# Modify.........: NO.FUN-610029 06/03/22 BY yiting 增加套數查詢
# Modify.........: No.TQC-5C0135 06/03/24 By pengu 當有set取替代時，進入單身會一直卡在替代碼(sfs26)欄位
# Modify.........: NO:EXT-610018 06/03/24 By PENGU 1.call i501()時,所用的單據後面多加'S',迼成在CALL i501()時單據傳入時
                                  #                  執行到i501sub_s()時讀取不到sfp_file的資料
# Modify.........: NO:EXT-610018 06/03/28 By PENGU call i501()時,所用的單據後面多加'S',迼成在CALL i501()時單據傳入時執行到
                                  #                  i501sub_s()時讀取不到sfp_file的資料
# Modify.........: NO.FUN-630084 06/03/30 By kim ASR 發/領/退料,單頭加入理由碼
# Modify.........: No.MOD-630129 06/04/04 By Claire asf-462訊息卡取替代發料
# Modify.........: No.FUN-640049 06/04/09 By kim 下階料號單身,游標在新增的項次,若存檔離開時,項次會殘留在畫面
# Modify.........: No.FUN-640069 06/04/09 By kim 進入到發料單單身,旁邊查詢工單下階料的action,建議不要出現,因為沒有工單
# Modify.........: No.MOD-640364 06/04/11 By kim 發料單單身產生時應考慮單位小數點取位
# Modify.........: No.MOD-640402 06/04/11 By pengu 階料號單身資料全部刪除,離開單身時, 系統show 確認框(9042)-->
                                    #               未輸入單身資料,是否取消單頭資料,若刪除應將入庫單之領料單號清除
# Modify.........: No.MOD-640419 06/04/13 By kim 成套退料,輸入工單自動帶套數,應為己發套數-入庫數,目前預設入發料套數但filed check 檢查己發套數-入庫數
# Modify.........: No.MOD-630127 06/04/18 By pengu 在AFTER FIELD sfs04 中有一段給sfs06,sfs10 值的處理,各別加上DISSPLAY的處理
# Modify.........: No.TQC-640169 06/04/21 By pengu 當使用多單位時發料量單位轉換算率有誤
# Modify.........: No.MOD-640545 06/04/28 By Claire 超領單在單身的工單欄位開窗時要排除有欠料的工單
# Modify.........: No.MOD-640548 06/05/05 By Claire 取消判斷asf-040
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650053 06/05/12 By kim 按列印無反應
# Modify.........: No.TQC-650084 06/05/29 By Pengu 當工單單身備料的發料單位與庫存單位不一樣時，在開立發料單
                              #                    時在發料單身會出現sel sfa的錯誤訊息
# Modify.........: No.FUN-650178 06/06/09 By kim 刪除領料單時,一併將工單報工的領料單號清除
# Modify.........: No.FUN-660106 06/06/15 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.TQC-660083 06/06/21 By Pengu 判斷sma73是否為"Y"，為"Y"時則控管當有完工入庫時不允許做扣帳還原動作。
# Modify.........: No.FUN-660137 06/06/21 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660110 06/06/23 By Sarah 輸入sfq02,sfs03工單號碼時需檢查是否為15.試產工單,若是需警告並要求重新輸入
# Modify.........: No.FUN-660166 06/06/26 By saki 流程訊息功能
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-650119 06/06/30 By Sarah 當sfp06(發料類別)=1時,檢查每一個sfq02(工單號碼)是否已有欠料補料,若有則警告並Return
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.MOD-660064 06/07/05 By Pengu 當工單備料檔的應發數量打負數時，無法對該料做超領料。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-660084 06/07/18 By Joe 修正庫存過帳後,已發量未更新之情況
# Modify.........: No.FUN-670103 06/07/28 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680034 06/08/14 By pengu CALL s_check_no()少傳一個參數
# Modify.........: No.FUN-680033 06/08/16 By kim 其他程式呼叫asfi526時,必需額外加其他參數來區別與asfp510的不同
# Modify.........: No.TQC-670083 06/08/23 By kim 工單超領(asfi512)時,允許應發大於已發
# Modify.........: No.FUN-680121 06/09/19 By huchenghao 類型轉換
# Modify.........: No.FUN-690064 06/10/16 By Sarah 單身下階料件開窗，只要開工單備料檔的資料即可
# Modify.........: No.FUN-690065 06/10/16 By Sarah 單身下階料件開窗，只要開工單備料檔的資料即可
# Modify.........: No.CHI-680019 06/10/23 By rainy sfp07也要檢查廠商
# Modify.........: No.MOD-6A0034 06/10/29 By Ray 第二個單身中不可以輸入第一個單身中不存在的工單
# Modify.........: No.TQC-690084 06/10/31 By Ray 成套退料在過帳時應加入控管控制退料套數<=應發數量-入庫套數
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-6B0049 06/11/20 By kim 多單位環境:asfi512超領3個,但在asfi527超領退卻可以退超過3個
# Modify.........: No.MOD-6B0098 06/11/21 By claire 單身新增時需連按二次放棄才能離開該筆單身
# Modify.........: No.TQC-6A0001 06/12/07 By Claire 以 g_prog 帶入 asfr204
# Modify.........: No.MOD-6C0036 06/12/07 By kim 挪料扣帳未成成
# Modify.........: No.MOD-6C0050 06/12/08 By kim 工單超領-單身輸入工單號碼後應發量及已發量都沒有顯示，都為空白
# Modify.........: No.TQC-6C0143 06/12/26 By ray 報表問題修改
# Modify.........: No.TQC-6C0122 06/12/28 By pengu 重工工單備料檔應發數量為負數,但目前退料單無法退料
# Modify.........: No.FUN-6C0083 07/01/09 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-720021 07/02/08 By pengu 工單備料單身有兩顆相同的料號但作業編號不一樣時，在作發料單單身維護時
#                                                  會出現"asf-351"的錯誤訊息
# Modify.........: No.MOD-710182 07/02/08 By pengu 取消FUN-5B0127所新增對還原過帳的控管
# Modify.........: No.TQC-720049 07/03/02 By pengu 發料單列印時未依照倉管員做跳頁列印
# Modify.........: No.MOD-6C0155 07/03/05 By pengu 修改FUN-660106調整的sql語法
# Modify.........: No.MOD-710034 07/03/06 By pengu  操作方式為輸入單據別後直接按確認跳至單身,單據日期不會
#                                                   Check現行年月及會計期間的合理性檢測
# Modify.........: No.MOD-730018 07/03/07 By pengu 發料單單身清除不應回寫工單狀態碼為 2."發放"
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.CHI-740016 07/04/18 By kim Construct 時,套數的開窗會錯
# Modify.........: No.TQC-740143 07/04/21 By pengu 工單單身備料檔有作取替代料時，在asfi511作發料單身維護會出現"asf-462"的錯誤訊息
# Modify.........: No.TQC-740257 07/04/25 By chenl 增加對“作業編號”欄位控制
# Modify.........: No.TQC-740331 07/04/26 By Ray 畫面asfi501d的"班別",“生產料號”欄位開窗，挑選后，值帶不入欄位
# Modify.........: No.FUN-740187 07/04/27 By kim 過帳段移到_sub.4gl
# Modify.........: No.TQC-740341 07/04/28 By johnray "發料量"為負數沒有管控,做超領時對任何工單都沒有管控
# Modify.........: No.FUN-740232 07/05/02 By kim 工單發料套數輸入數量後還是會被清為0，如果不可以改請改為不可修改欄位
# Modify.........: No.TQC-740154 07/05/04 By kim ima108='Y'(工單發料前調撥否),時才可執行"生成調撥單",增加提示
# Modify.........: No.TQC-750029 07/05/09 By Rayven 測試走FQC的工單，將完工入庫單取消過賬作廢后，可以將發料單，工單刪除，此時FQC單存在，未做任何控管
# Modify.........: No.MOD-750044 07/05/11 By claire 無法印出asfr204
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750225 07/05/29 By arman  點擊過帳還原按鈕,系統提示的信息為"是否進行審核還原",應該改為"是否確定對此單據進行過帳還原"
# Modify.........: No.TQC-750232 07/05/29 By chenl  增加成套退料和超領退料的限制.
# Modify.........:                                 成套退料量<=已發量-完工入庫量*實際用量QPA-未過賬數量。
# Modify.........:                                 超領退料量<=超領量-未過賬量
# Modify.........:                                 修正發料量不可小于零的程序錯誤。
# Modify.........: No.MOD-760010 07/06/04 By peng 該程式利用查尋功能選擇工單欄位查詢,結果卻開料件主檔窗
# Modify.........: No.CHI-6C0005 07/06/08 By jamie 修改套數應詢問是否重新產生單身資料
# Modify.........: No.TQC-760124 07/06/15 By rainy 產生調撥單時，檢驗碼未給值
# Modify.........: No.TQC-760151 07/06/18 By chenl 修改“作業編號”欄位的控制。
# Modify.........: No.MOD-760088 07/06/22 By pengu 在AFTER INSERT斷的SELECT img09 SQL錯誤
# Modify.........: No.MOD-760108 07/07/18 By pengu 若工單是事後到扣料時若對領料單作廢則入庫單單頭應該被清為NULL
# Modify.........: No.MOD-770117 07/07/24 By pengu 做成套發料時不會控管發料套數要小於等於生產套數
# Modify.........: No.FUN-770113 07/07/31 By kim 因為pk不可null,set sfq05=g_today when sfq05 is null
# Modify.........: No.MOD-780024 07/08/06 By pengu 在判斷是否有未過帳單據時應排除作廢單據
# Modify.........: No.MOD-780002 07/08/06 By pengu 成套退單身"下階料號"開窗查詢應只開出該工單之下階料
# Modify.........: No.MOD-760050 07/08/09 By pengu 可退數量應排除已有FQC單未入庫數
# Modify.........: No.MOD-780208 07/08/20 By pengu 使用多單位之參考單位並不會新增imgg
# Modify.........: No.TQC-780029 07/09/12 By rainy 工單領料作廢時應判斷是否存在對應的完工入庫單，如存在完工入庫單，則不可作廢
# Modify.........: No.MOD-790004 07/09/17 By Pengu 使用多單位時庫存量不應以母單位為基準
# Modify.........: No.MOD-790113 07/09/21 By Pengu 維護欠料補料單時單身應發量未帶出
# Modify.........: No.MOD-790112 07/09/21 By Pengu 使用多單位無法過帳還原
# Modify.........: No.MOD-7A0012 07/10/04 By Pengu 發料時,若以母單位數量發料會出現-asf348的異常
# Modify.........: No.MOD-790174 07/10/17 By Pengu 成套發料時單身領料量為負數
# Modify.........: No.MOD-790175 07/10/17 By Pengu FUNCTION i501_totsfs05中的SQL應該加入單位與作業編號條件
# Modify.........: No.MOD-7A0133 07/10/23 By Carol 重工工單單身料件數量負數要做可做一般退料
# Modify.........: No.CHI-7A0034 07/10/25 By Carol 當工單為事後扣帳用asfi514領料時應可超領
# Modify.........: No.MOD-780034 07/11/05 By pengu 產生調撥單時報表資料為英文
# Modify.........: No.TQC-7B0065 07/11/15 By Judy 多單位方式為"參考方式"時，自動生成單身參考數量為0
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.MOD-7C0011 07/12/05 By Pengu 產生調撥時在AFTER INPUT時應判斷批號是否為null若違null則塞' '
# Modify.........: No.FUN-810016 08/01/08 By hongmei 服飾版相關開發修改 sasfi501.4gl->sasfi501.src.4gl
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810038 08/02/15 By kim GP5.1 ICD
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-830061 08/03/18 By mike  ICD庫存過帳程式修改
# Modify.........: No.MOD-820109 08/03/21 By claire 查詢時輸入單身的替代碼會有-217的錯誤
# Modify.........: No.MOD-830099 08/03/22 By Pengu 在asf-507錯誤訊息加入料號資料
# Modify.........: No.MOD-820083 08/03/23 By Pengu 還原TQC-750029的調整
# Modify.........: No.MOD-810230 08/03/24 By Pengu 輸入工單號碼後應自動帶出未發料套數
# Modify.........: No.MOD-810188 08/03/24 By Pengu 發料時單身選項選5庫存扣已檢量時，計算已檢量未排除發料單為做廢的資料
# Modify.........: No.MOD-7C0166 08/03/25 By Pengu 一般退料時應要一起考慮替代料
# Modify.........: No.FUN-830132 08/03/27 By hellen 修改CALL i501_ind_icd_chk_icdqty()的方式
# Modify.........: No.FUN-840042 08/04/15 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-840123 08/04/19 By Pengu i501_cs中有join sfs_file 但已過帳就無sfs了
# Modify.........: No.MOD-840094 08/04/19 By Pengu 多單位寫tlf時其數量
# Modify.........: No.MOD-840301 08/04/21 By kim 刪除後不應該出現-400的訊息
# Modify.........: No.MOD-840550 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.CHI-860032 08/06/24 By Nicola 批/序號修改
# Modify.........: No.FUN-870041 08/07/08 By Nicola 重覆性生產加入特性代碼                                                          
# Modify.........: No.FUN-860014 08/07/08 By sherry 過帳不可先判斷日期,輸完再檢查                                                   
# Modify.........: No.FUN-870106 08/07/22 By Nicola 退料時，只可退該工單所發的批/序號資料                                           
# Modify.........: No.FUN-870097 08/07/24 By sherry 增加可修改 特性代碼(sre051) 
# Modify.........: No.FUN-870117 08/08/08 by ve007 倉管員拆分法料單功能，增加發料方式按制單批號生成
# Modify.........: No.FUN-870101 08/08/29 by jamie MES整合
# Modify.........: No.MOD-890023 08/09/04 by chenyu ICD功能修改
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.TQC-890051 08/09/24 By sherry 當g_sfp.sfp06 MATCHES '[ABC]'  時  sfq07 才可開啟  
# Modify.........: No.MOD-890268 08/09/26 By claire i501_t() 欄位定義應放大含小數位
# Modify.........: No.MOD-890271 08/09/26 By claire 刪除時,rvbs批序號傳入參數有錯
# Modify.........: No.FUN-840012 08/09/30 By kim 確認段移到_sub
# Modify.........: No.MOD-870053 08/10/02 By claire 以扣帳日期check成本關帳日
# Modify.........: No.MOD-870089 08/10/02 By claire 委外收貨入庫後不可還原發料單庫存過帳
#                                                   MARK CHI-850017 併入CHI-870030 處理
# Modify.........: No.MOD-870187 08/10/02 By claire 不論有無使用雙單位都要控卡倉儲批的有效否
# Modify.........: No.MOD-870247 08/10/02 By claire 單據日及過帳日都要控卡倉儲批的有效否
# Modify.........: No.MOD-870288 08/10/02 By claire 單據設定自動確認時應call確認段而非過帳段
# Modify.........: No.MOD-890107 08/10/02 By claire asf-724 加上料號提示
# Modify.........: No.MOD-890110 08/10/02 By claire asfi529 退料量輸入時,要檢查已發量(sfa06)+超領量(sfa062)
# Modify.........: No.CHI-870030 08/10/02 By claire 於確認段時加入若為"退料單"時, 更新i501sub_u_sfa資料後, 再判斷是否符合完工套數的控管
# Modify.........: No.TQC-8A0008 08/10/02 By jamie MES原先於確認段串出，改由庫存過帳時才串
# Modify.........: No.MOD-8A0041 08/10/07 By claire 語法調整
# Modify.........: No.MOD-8A0150 08/10/16 By claire 過帳還原時,會將取替代料sfs27,sfs28清空
# Modify.........: No.MOD-8A0190 08/10/22 By sherry 如果發料量>0,應發量為0或為空則不讓過     
# Modify.........: No.MOD-8A0163 08/10/23 By chenl  若有替代料時，成套退料的判斷應換算成主料量進行判斷。
# Modify.........: No.MOD-8A0244 08/10/28 By chenyu 成套發料過賬還原時，要考慮超領單的情況
# Modify.........: No.MOD-8A0258 08/10/29 By claire 排除作廢單據
# Modify.........: No.FUN-8A0145 08/10/31 By hongmei 欄位類型修改
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.MOD-8B0086 08/11/12 By chenyu 工單沒有取替代時，讓sfs27=sfs04，保証sfs27不為空
# Modify.........: No.MOD-8A0047 08/11/15 By Pengu 若是全數代買料在做成套退料時應不可做退料
# Modify.........: No.MOD-8B0230 08/11/21 By claire 一般退料應考慮誤差率
# Modify.........: No.FUN-8A0140 08/12/04 By jan 單身維護時 ,增加 action "查詢多倉儲資料"
# Modify.........: No.MOD-8C0115 08/12/11 By claire單身加入key sfa27
# Modify.........: No.MOD-8C0222 08/12/23 By claire FUN-560016 語法調整
# Modify.........: No.MOD-8C0239 08/12/24 By claire 消耗性的領料單自行輸入會有asf-081
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-8C0266 08/12/29 By chenyu 成套退料的時候，要考慮消耗性料件
# Modify.........: No.MOD-910022 09/01/05 By sherry 使用雙單位的情況下，AFTER數量欄位（sfs32,sfs35）沒有考慮asf-707的錯誤
# Modify.........: No.MOD-910026 09/01/06 By chenl  修正chk_img()函數中對庫存量的計算及判斷。
# Modify.........: No.MOD-910167 09/01/15 By jan 修正單身料號更改后,造成扣帳時會出現:
# ..............................................:"sel sfa05 無此筆資料,或任何上下筆資料,或其他相關主檔資料 !"的錯誤!
# Modify.........: No.MOD-910166 09/01/19 By claire (1)imd_file需檢核imd11='Y'
#                                                   (2)bmd_file需加上bmdacti ='Y'
# Modify.........: No.MOD-910229 09/01/21 By jan 修正單身刪除重錄后，sfs27不變的錯誤
# Modify.........: No.MOD-920072 09/02/05 By chenl   調整b_fill段內sql
# Modify.........: No.FUN-920175 09/02/24 By kim 取消確認/作廢段程式拆解到_sub.4gl中，以便後續程序呼叫
# Modify.........: No.MOD-920345 09/02/27 By Pengu 使用參考單位時重新查詢時參考數量會被重新計算
# Modify.........: No.FUN-930106 09/03/20 By destiny sfp11增加管控
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.MOD-940136 09/04/10 By Dido AFTER FIELD sfs04 若 sfs09 為 null 請給予 ' ' 
# Modify.........: No.TQC-940138 09/05/19 By sherry 未檢查作業編號是否存在于工單單身，導致無法過賬
# Modify.........: No.MOD-940387 09/05/19 By Pengu 倉庫可用否應考慮是否為發料狀態
# Modify.........: No.MOD-950106 09/05/19 By Pengu 再發料單做取替代時，會出現未建取替代資料的訊息
# Modify.........: No.MOD-950039 09/05/19 By Pengu 在on row時判斷b_sfs.sfs27是否為NULL，若是則重取l_sfa27_a的值
# Modify.........: No.MOD-950017 09/05/19 By Pengu 在BEFORE INSERT時對b_sfs.*做初始化
# Modify.........: No.MOD-940302 09/05/19 By Pengu 自動展單身時若選擇依庫存量時會異常
# Modify.........: No.MOD-940164 09/05/19 By Pengu 超領退無法正常退料
# Modify.........: No.FUN-940039 09/05/25 By dongbg GP5.2發料改善
#                                修改內容 1:若參數設定不控管套數,則第一單身的套數可輸入0,即為補料,
#                                           否則不可等于0,補料時對于欠料量的計算不可直接抓工單單身字段,需推算,
#                                           邏輯與工單單身推算邏輯一致  
# Modify.........: No.FUN-940008 09/05/27 By hongmei 發料改善
# Modify.........: No.FUN-950021 09/05/31 By Carrier 組合拆解
# Modify.........: No.MOD-950232 09/06/01 By mike 調整MOD-910166修改的程式段有用imd11判斷是否為可用倉的程式段，均須還原不做控管 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.TQC-960373 09/06/25 By sherry 作業編號開窗的時候需要根據工單編號過濾
# Modify.........: No.FUN-950088 09/07/01 By hongmei add sfa36,mse02
# Modify.........: No.MOD-930195 09/03/18 By chenyu 發料時，單身選擇取替代，料件編號開窗應該帶出在abmi600中維護好的取替代料號
# Modify.........: No.MOD-930181 09/07/28 By sherry 如果使用工單＋作業編號發料，那麼第一次成套發料是可以的，第二次就找不到工單號，如果手工輸入又可以
# Modify.........: No.TQC-940078 09/07/28 By sherry 修改發料數量，點確定，在檢量沒有更新
# Modify.........: No.MOD-940404 09/07/28 By sherry 刪除時，會出現工單單頭已發套數大于0，狀態卻是2.發放的情況 
# Modify.........: No.TQC-980097 09/08/14 By sherry 應根據作業編號發料  
# Modify.........: No.FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.......... No.FUN-930062 09/08/20 By lutingting單據刪除時要更新rvu16為NULL
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980038 09/09/10 By chenmoyan sfp06的值由smy72代出
# Modify.........: No.TQC-990060 09/09/15 By lilingyu 委外工單未生成委外采購單之前,不可以進行委外工單發料
# Modify.........: No.MOD-860012 09/09/15 By wujie 工單號碼和發料套數兩個欄位的檢查中，變量的使用有誤
# Modify.........: No.MOD-990122 09/10/08 By Smapmin 調撥單功能要依不同行業別執行不同的程式
# Modify.........: No.MOD-990148 09/10/08 By Smapmin 於AFTER ROW時重新顯示應發/已發數
# Modify.........: No.TQC-990094 09/10/10 By lilingyu 判斷g_flag_sfq03時,l_sfq03_t可能出現NULL值,導致無法出現 asf-919的提示
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.TQC-9A0130 09/10/26 By liuxqa 修改ROWID.
# Modify.........: No.MOD-9A0123 09/10/30 By lilingyu 錄入一筆替代資料后,確定,再次進入單身,料號欄位報錯:替代料和被替代料相同
# Modify.........: No.TQC-9A0194 09/10/30 By kim GP5.2發料改善
# Modify.........: No.CHI-980013 09/11/02 By jan 發料/退料/補料 時 除了消耗性料件，X:資訊參考 也不可以
# Modify.........: No:CHI-990049 09/11/03 By Smapmin "單身全部刪除再重新產生"時,若選擇"不自動產生"也要將單身資料刪掉 
# Modify.........: No:CHI-9B0005 09/11/05 BY liuxqa substr 修改。
# Modify.........: No:MOD-980241 09/11/12 By sabrina 刪除套數單身時應檢查刪除工單是否存在發料單身中
# Modify.........: No:MOD-980243 09/11/12 By sabrina 調整MOD-910167的修改
# Modify.........: No:MOD-990020 09/11/12 By sabrina 領料單刪除時不應update工單狀態
# Modify.........: No:CHI-980026 09/11/13 By jan 修改sfq02的開窗
# Modify.........: No:TQC-9B0049 09/11/13 By kim GP5.2發料改善
# Modify.........: No:FUN-970079 09/11/16 By jan 修改SQL語句
# Modify.........: No:TQC-9B0134 09/11/18 By sherry 如果已自動生成單身，點確定時不需再自動產生
# Modify.........: No:TQC-9B0061 09/11/17 By sherry 發料套數沒有控管單位生產數量
# Modify.........: No:MOD-9B0129 09/11/24 By sabrina 控管委外工單須先開委外採購單後才能發料，但未考慮一對多情況
# Modify.........: No:MOD-9B0078 09/11/24 By sabrina QPA為0的料件不可進行超領
# Modify.........: No:MOD-980003 09/11/25 By sabrina 庫存不足查詢未考慮發料單位與庫存單位換算率
# Modify.........: No:MOD-970298 09/11/25 By sabrina 誤差率設100時會無法退料
# Modify.........: No:FUN-9B0149 09/11/27 By kim 增加sfs27相關處理
# Modify.........: No:FUN-9B0144 09/11/27 By jan 修改sfp01的開窗資料
# Modify.........: No:MOD-940347 09/11/27 By sabrina 修正MOD-8B0230的調整
# Modify.........: No:FUN-9B0145 09/11/30 By jan GP5.2 單檔程式右上角 X 無法關閉程式
# Modify.........: No:TQC-9C0035 09/12/04 By sherry 修正TQC-980097的問題
# Modify.........: No:TQC-9C0048 09/11/30 By jan 進入第二單身時，按"全部刪除再重新產生"的action產生資料后，光標應跳回單身中
# Modify.........: No:TQC-9C0050 09/12/08 By Carrier 拿掉mfg6201等判断
# Modify.........: No:MOD-9C0234 09/12/19 By sherry 修改sql條件
# Modify.........: No:MOD-9C0180 09/12/19 By chenmoyan 單別開窗加上類型的條件
# Modify.........: No:MOD-9C0240 09/12/19 By kim GP5.2發料改善
# Modify.........: No:MOD-9C0195 09/12/21 By hongmei 1.issue_type='4/5'时，倉管員也要可以QBE;
#                                                    2.在帶單身資料時要加上考慮如果有打倉管員時，img要串ima的倉管員來過濾
# Modify.........: No:MOD-9C0009 09/12/12 By Pengu 判斷倉儲批若為null時則須給' '值
# Modify.........: No:TQC-9C0174 09/12/28 By sherry 在asfi510 asfi520里面維護的批序號內容,在asfi511 asfi526等作業里面查不到
# Modify.........: No:FUN-9C0073 10/01/04 By chenls 程序精簡
# Modify.........: No:CHI-A10016 10/01/18 By Dido 調整 s_lotout transcation 架構 
# Modify.........: No:FUN-9C0040 10/01/29 By jan 工單發料/領料/超領，要排除掉來源特性="S:回收料"的料件,工單退料要可以打來源特性="S:回收料"的料件
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30070 10/03/12 By lilingyu 一張工單,按非作業編號(編號為空)全部發料,然后按作業編號全部退料,
# ...................................................然后再去按作業編號或非作業編號,發料套數顯示不正確
# Modify.........: No:MOD-A30065 10/03/11 By Sarah 新增時,不在i501_d_i()詢問是否重新產生單身
# Modify.........: No:FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:CHI-9A0022 10/03/17 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No:TQC-A30108 10/03/22 By lilingyu 成套發料時(工單有2筆備料,其中一個備料已發料完畢,另一筆未發)
# ...................................................  開窗選擇"工單單號"有資料,直接錄入單號后帶出的發料套數為0，check發現sql
# ................................................... 未選出資料,其實應該有一筆資料
# Modify.........: No:TQC-A30112 10/03/23 By lilingyu 錄入時,單身欄位"sfs03"開窗時,應該排除已經結案的工單 
# Modify.........: No:FUN-A20048 10/03/25 By liuxqa 增加工单备置。
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A30120 10/04/09 By liingyu 工單領退料維護作業,錄入時,增加默認帶出倉庫和庫位;退料量sfs05控管不可以為0
# Modify.........: No:FUN-A40023 10/04/13 By dxfwo 過單
# Modify.........: No:TQC-A40085 10/04/19 By lilingyu AFTER FIELD sfs05段判斷asf-081訊息有誤
# Modify.........: No:MOD-A30031 10/04/20 By Sarah 1.sfp01調整開窗可看到單別(判斷l_smy72是否有值才組條件)
#                                                  2.sfp06給預設值smy72
# Modify.........: No.FUN-A40053 10/04/21 By liuxqa 工单备置-改善
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu sfs26替代碼增加規格替代的內容
# Modify.........: No:MOD-A50001 10/05/03 By Sarah 在判斷庫存量是否足夠時須考慮轉換率
# Modify.........: No:FUN-A40055 10/05/05 By destiny 单身显示及construct改dialog写法息 
# Modify.........: No:TQC-A50033 10/05/13 By destiny 修改部门栏位无资料时报错信息 
# Modify.........: No:MOD-A50110 10/05/17 By Sarah 增加g_wc5,記錄g_wc3轉換成sfe_file欄位的條件
# Modify.........: No:TQC-A50063 10/05/19 By destiny 当系统参数未勾选库存不足可以发料时，noqty,short_data就不应该预设为Y
# Modify.........: No:TQC-A50101 10/05/21 By lilingyu 計算t_short_qty時,出現NULL值
# Modify.........: No:TQC-A50071 10/05/21 By lilingyu 欠料補料單的單身二的資料不可以由單身一自動帶出
# Modify.........: No:MOD-A50158 10/05/24 By Sarah 輸入單身發料量時,應取位
# Modify.........: No:MOD-A40144 10/05/25 By liuxqa modify sql
# Modify.........: No:MOD-A50139 10/06/01 By Sarah 當沒有img_file資料時,再檢查該倉庫是否為VMI結算倉儲,若不是才顯示錯誤訊息
# Modify.........: No:FUN-A60028 10/06/09 By lilingyu 平行工藝
# Modify.........: No:MOD-A60062 10/06/09 By Sarah 續FUN-560047,輸入多單位數量時也應檢查同一張工單的發料是否大於應發量
# Modify.........: No:MOD-A70046 10/07/06 By Sarah 成套發料依不同作業編號發料,要發第二個作業編號時會卡住
# Modify.........: No:FUN-A60095 10/07/21 By kim 可發/可退量要考慮盤盈虧量
# Modify.........: No:FUN-A70034 10/07/23 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:CHI-A70060 10/08/03 By Summer ICD段調整,判斷sfp06='1'的改成sfp06 MATCHES '[1234]',
#                                                   sfp06='6'的改成sfp06 MATCHES '[6789]',
#                                                   sfp06 MATCHES '[16]'的改成sfp06 MATCHES '[12346789]'
# Modify.........: No:MOD-A20007 10/08/03 By Pengu 產生調撥單後系統產生出沒有內容的報表資料
# Modify.........: No:MOD-A20001 10/08/03 By Pengu 控管發料套數的地方，未排除作廢的單據
# Modify.........: No:TQC-A70090 10/08/12 By yinhy 右邊的功能鈕呈現btn_01等形式。
# Modify.........: No:MOD-A80031 10/08/31 By sabrina 第二單身「在檢量」，應該不能包含自己現行的單據 
# Modify.........: No.FUN-A90035 10/09/20 By vealxu sfp08的開窗和欄位檢查，加上sfd.確認碼='Y'
# Modify.........: No:FUN-A30093 10/09/30 By jan 程式還原
# Modify.........: No:MOD-A90193 10/10/01 By sabrina 退料時不需考慮倉庫庫存量 
# Modify.........: No:FUN-AA0007 10/10/12 By jan 若輸入的批號之idc17='Y',則控卡不可輸入
# Modify.........: No:MOD-AA0123 10/10/21 By sabrina 成套發/退料，套數不可輸入0套
# Modify.........: No.FUN-A40022 10/10/25 By jan 退料入庫的批號只能與發料單相同的批號,且數量不可大于該批號于發料單發出的批號
# Modify.........: No:MOD-AA0142 10/10/25 By sabrina (1)若發退料方式選擇(2)時則需判斷該倉庫庫存量是否足夠發料，
#                                                       當noqty='N'且庫存量不足時，則單身不產生資料 
#                                                       當noqty='Y'且庫存量不足時，則該倉庫顯示"欠料" 
# Modify.........: No.FUN-AA0059 10/10/29 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-AB0009 10/11/02 By destiny checkno时缺少条件 
# Modify.........: No.FUN-AB0018 10/11/03 By zhangll 仓库营运中心控管
# Modify.........: No.MOD-AB0047 10/11/04 By lilingyu l_per長度定義過短,導致後續計算出錯
# Modify.........: No.FUN-AB0021 10/11/05 By shiwuying s_chk_item_no时缺少条件
# Modify.........: No.MOD-AB0071 10/11/09 By zhangll 修正会重复录入生产套数问题
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-AB0082 10/11/25 By Summer SQL中不能用MATCHES
# Modify.........: No.TQC-AB0183 10/11/28 By jan sfa012,sfa013給預設值
# Modify.........: No.TQC-AB0172 10/11/29 By chenying 查詢完結果只有一筆資料時,"上下一筆"的action還亮著
# Modify.........: No.TQC-AB0178 10/12/02 By jan sma129='N' AND sfa03=0 時,做欠料補料
# Modify.........: No.TQC-AB0223 10/12/02 By huangtao 發料前調撥作業生成的調撥單生成的imm12欄位未賦值或為清空
# Modify.........: No:TQC-AC0125 10/12/10 By zhangll 修改slk作業錄入死循環問題
# Modify.........: No:TQC-AC0151 10/12/14 By chenying 單身輸入倉庫時,流通業才控管倉庫是否屬於當前門店
# Modify.........: No:TQC-AB0098 10/12/15 By destiny 当前仓库不存在当前料件且不为vmi仓时报错不准确 
# Modify.........: No:TQC-AC0197 10/12/16 By lixh1   增加"倉庫批修改"ACTION
# Modify.........: No:MOD-AC0336 10/12/28 By jan 重抓製程料號
# Modify.........: No:MOD-B10201 11/01/25 By sabrina 若發料料號有取替代，被取代料號剛好是另一個備料料號時，會出現-284錯誤訊息
# Modify.........: No.FUN-B10056 11/02/14 By vealxu 修改制程段號的管控
# Modify.........: No:MOD-B20062 11/02/15 By sabrina 退料時判斷數量應連同取替代料的數量一起算
# Modify.........: No.TQC-B30021 11/03/03 By destiny q_short_qry缺少接收参数
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:MOD-B30148 11/03/11 By lixh1 調整為所有類型的發退料單都要可以執行"修改倉儲批" 
# Modify.........: No:MOD-B30702 11/03/31 By destiny 退料单时发料料号如果有回收料则先抓回收料    
# Modify.........: No:FUN-B20079 11/04/02 By shenyang 修改製成序，製成段號，作業編號邏輯
# Modify.........: No:FUN-B20009 11/04/07 By lixh1 增加對sfs012,sfs013的賦值   
# Modify.........: No:FUN-AC0074 11/04/12 By lixh1 移除發料單自動產生單身的開窗選項"備置發料選項"及超領時asfi501a_1開窗
# Modify.........: No:FUN-AC0074 11/04/13 By destiny 當備料檔中既有按作業編號生產料件，也有不按作業編號生產的料件，則發料時發料套數的計算會多算一次
# Modify.........: No:MOD-B30647 11/03/22 By sabrina 退料時，退料套數超過應退量，但按放棄後卻將輸入的數值寫入資料庫
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B50059 11/05/12 By kim 還原FUN-A60095中,和sfa064有關的所有調整
# Modify.........: No.TQC-B50089 11/05/18 By jan 發料單取替代功能修改
# Modify.........: No.FUN-B50106 11/05/18 By lixh1  for ICD:發料單刪除後,要檢查工單是否還有發料單,沒有的話要還原成開立狀態,否則工單無法刪除
# Modify.........: No.CHI-B40058 11/05/18 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-9A0095 11/05/18 By abby MES追版
# Modify.........: No.FUN-B40082 11/05/24 By jason  sfp14不為空時不可過帳還原
# Modify.........: No.FUN-AB0001 11/05/23 By Lilan 新增EF(EaayFlow)整合功能
# Modify.........: No.FUN-B50064 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60034 11/06/08 By lixia 申請人欄位直接保存時沒有進行控管
# Modify.........: No.TQC-B50140 11/06/09 By zhangll 使用了取替代，且替代資料等於工單單身的另一筆資料时，當替代料發完，欠料補料另一筆資料時異常
# Modify.........: No.MOD-B60079 11/06/09 By zhangll 當未選中資料時，不做批/序號查詢
# Modify.........: No:MOD-B60107 11/06/13 By Smapmin 變數key錯
# Modify.........: No:TQC-B60036 11/06/14 By lixia 發料量增加管控
# Modify.........: No:TQC-B60091 11/06/15 By jan 調整發料單取替代時,無法輸入的問題
# Modify.........: No:TQC-B60136 11/06/17 By jan 取替代料的退料 退料數量檢查錯誤
# Modify.........: No:FUN-B20095 11/06/28 By lixh1 成套發料的第一單身加上製程段號(sfq012)
# Modify.........: No:TQC-B60349 11/07/04 By guoch 換算套數時的bug
# Modify.........: No:FUN-B20095 11/07/12 By destiny 检查第二数量时没考虑单位换算率
# Modify.........: No:TQC-B70170 11/07/22 By guoch 錄入“實際套數”時沒有提前控管
# Modify.........: No.FUN-B70061 11/07/26 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No.FUN-B70061 ch 11/07/28 By xianghui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-B80040 11/08/03 By jason for 修正筆誤sfa_file => sfb_file
# Modify.........: No.TQC-B80091 11/08/11 By houlia  審核時chk申請人
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-B80143 11/09/19 By jason 當sfp06=超退時，工單編號、發料料號、被替代料號 的開窗和欄位檢查，都要加過濾條件=> sfa.超領量>0
# Modify.........: No:CHI-B90038 11/10/08 By johung 發料時若指定工單倉庫或指定倉庫為VMI結算倉，則不控卡庫存量
# Modify.........: No:MOD-BA0017 11/10/09 By johung 成套退時退料套數不可為0加上提示訊息
# Modify.........: No:FUN-BA0050 11/10/10 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No:MOD-BA0078 11/10/12 By johung 成套退時退料套數應可以是 已發料-入庫量+誤差
# Modify.........: No:MOD-BA0193 11/10/28 By destiny 回收料退料时应单独考虑期可入库数量     
# Modify.........: No:FUN-B80093 11/10/31 By pauline 增加VMI判斷
# Modify.........: No:TQC-B90236 11/11/03 By yuhuabao 1.原執行s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                     2.原於_r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上,但第三個參數(項次)傳""
#                                                     3.原執行s_lotout程式段，改為s_mod_lot，傳入參數不變
#                                                     4.FUNCTION i501_ins_rvbs的rvbs09:IF sfp06='6,7,8,9,B' rvbs09 = 1 ELSE rvbs09 = -1 END IF
#                                                     5.單身處理:替代碼(sfs26)：增加選項"9.主料可做配方替代、B.副料,(配方替代料件)、C.副料,(配方回扣料件)
#                                                     6.單身新增Action"配方替代"
# Modify.........: No.MOD-BB0307 11/11/28 By ck2yuan 替代時，帶出應發量sfa05與已發量sfa06
# Modify.........: No.FUN-BA0058 11/11/28 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0084 11/12/09 By lixh1 增加數量欄位小數欄位取位(imn_file & sfs_file) 
# Modify.........: No.MOD-B80013 11/12/21 By Vampire 若 sfp06='4' and sfa='E' 時則不控卡asf-462
# Modify.........: No:MOD-B80138 11/12/21 By Vampire 退料量不應計算為在撿量，在501_chk_img()的sum(sfs05)where條件加上sfp06 IN ('1','2','3','4','A','C')
# Modify.........: No.MOD-B80111 11/12/21 By Vampire 工單備料檔無先對料件做取替代，在發料時無法做料件取替代。
# Modify.........: No.FUN-BC0060 11/12/29 By zhangll 修改當參數設置發料套數控管時，有按作業編號發料，發料套數異常的問題
# Modify.........: No:MOD-C10021 12/01/04 By ck2yuan AFTER FIELD sfs10 sqltqry參數修改
# Modify.........: No:MOD-C10081 12/01/10 By ck2yuan 修改g_c[35]計算,控卡tm.wo_w需為WIP倉
# Modify.........: No:MOD-C10100 12/01/11 By lilingyu 因正式區sma32未增加好，暫MARK FUN-B80093，待後續還原 
# Modify.........: No:TQC-C10033 12/01/11 By lilingyu 還原MOD-C10100 MARK的部分
# Modify.........: No.CHI-BC0040 12/01/12 By ck2yuan 畫面單身新增替代率,被替代料料號拉到發料料號前面
# Modify.........: No:MOD-B80306 12/01/30 By Vampire MOD-B20062在sql應排除作廢的單據(sfpconf!='X')
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-BC0130 12/02/02 By destiny 成套退料时可退数量应该考虑其他退料单中未过帐的数量
# Modify.........: No:FUN-C20027 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:TQC-C20098 12/02/09 by destiny 修改i501_ind_icd_chk_icdqty 检查方式
# Modify.........: No.FUN-BC0109 12/02/09 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No.TQC-BB0231 12/02/13 By Carrier construct时加入oriu/orig
# Modify.........: No.TQC-C20443 12/02/24 By yuhuabao 打完第一單身，開窗後，無法自動產生第二單身資料元件的替代碼是9
# Modify.........: No:MOD-C20203 12/02/24 By ck2yuan 退料時不應控卡是否有取替代(bmd_file)
# Modify.........: No:TQC-C20158 12/02/27 By destiny asfi5199画面栏位调拨单号应设为必输栏位
# Modify.........: NO.TQC-C20473 12/02/27 By xianghui 在撈取其他退料单中未过帐的数量時加上不等於當前退料單這一條件
# Modify.........: NO.TQC-C20575 12/03/01 By yuhuabao 配方替代后直接填充單身
# Modify.........: NO.TQC-C30028 12/03/01 By yuhuabao 配方替代單身於替代率前加顯示"底數"(bmd10)，應發量sqty改為發料量*替代率/底數
# Modify.........: NO.TQC-C30067 12/03/03 By wuxj 退料單時配方替代按鈕也可視
# Modify.........: NO.TQC-C30124 12/03/07 By destiny b_fill条件错误
# Modify.........: No.TQC-C30268 12/03/20 By destiny 被替代料栏位下条件查询报错
# Modify.........: No:MOD-C30910 12/04/02 By ck2yuan sfs04 開窗應只可選擇原本工單備料的料號
# Modify.........: No:MOD-C30886 12/04/02 By ck2yuan 領料退料,重工工單不應控卡 退料量不可大於領料+超領
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No:MOD-C40028 12/04/09 By ck2yuan sfs27 新增時,開窗不須將sfs4當成條件
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.TQC-C40150 12/04/18 By lixh1 處理資料已經刪除畫面檔卻顯示問題
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/20 By bart 修改 s_icdin和s_icdout 回傳值
# Modify.........: No:CHI-C30040 12/05/08 By bart 工單單號(sfs03)開窗應該要有控卡是消耗性料件(sfa11=E)
# Modify.........: No:CHI-C30089 12/05/14 By bart 原q_bmd1加條件and bmd01='argv3' 加傳入被替代料號
# Modify.........: No:MOD-C50095 12/05/15 By ck2yuan 退料時,修改第一單身時數量不用帶出來(帶出錯的數量) 修改數量後詢問是否重新產生單身
# Modify.........: No:CHI-C40013 12/05/17 By ck2yuan 未發料不可執行超領
# Modify.........: No:MOD-C50150 12/05/21 By suncx 成套發料時，手動錄入消耗性料件卻成功
# Modify.........: No:MOD-C50190 12/05/24 By suncx vmi發料檢查可用庫存量
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No:TQC-C60020 12/06/18 By bart 退料時datecode可維護
# Modify.........: No:MOD-B60143 12/06/18 By ck2yuan 檢核工單變更單時應是用snb99來判斷而不是用snbconf
# Modify.........: No:MOD-B70244 12/06/18 By ck2yuan 成套退料應考慮替代率
# Modify.........: No:MOD-B50240 12/06/19 By Elise 當工單的倉儲為null時應給' '
# Modify.........: No:MOD-B70204 12/06/19 By ck2yuan 重工工單退料無法正常運行
# Modify.........: No.MOD-BA0197 12/06/19 By ck2yuan 在計算此料的筆數時應多判斷工單單號。以防不同工單，但卻是發同一顆料
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-C70014 12/07/11 By suncx 新增Run Card發料
# Modify.........: No:MOD-C70219 12/08/09 By ck2yuan 當新增倉庫失敗,若sfs07為空 則next field sfs07
# Modify.........: No:MOD-C70247 12/08/09 By ck2yuan sql語法有錯,加上group by
# Modify.........: No:FUN-C80030 12/08/10 By fengrui 添加批序號依參數sma95隱藏
# Modify.........: No:TQC-C50227 12/08/16 By SunLM  組合拆解工單發料單可以查詢,但不可取消審核和取消過帳
# Modify.........: No:FUN-C80107 12/09/19 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No.TQC-C90082 12/09/24 By chenjing 修改調撥完成后asfr204.02r報表名稱顯示英文問題
# Modify.........: No.TQC-CA0014 12/10/09 By chenjing 修改有替代料發料時已發數量和應發數量不正確問題
# Modify.........: No.CHI-C90017 12/10/11 By Elise 成套退料時，數量無條件捨去
# Modify.........: No.TQC-CA0035 12/10/15 By suncx RunCard發料QC測試BUG處理
# Modify.........: No:MOD-C80256 12/10/25 By Elise 還原TQC-BC0130之修改
# Modify.........: No.MOD-CA0045 12/10/26 By Elise 修正MOD-C40028修改
# Modify.........: No.TQC-CA0025 12/10/29 By Elise 建議拿掉呼叫cl_used(1)及cl_used(2)
# Modify.........: No.MOD-CA0099 12/10/29 By Elise 同時正副料都有超領並想退時,計算退料量再判斷發料料號
# Modify.........: No.FUN-CB0014 12/11/08 By xujing 增加資料清單
# Modify.........: No.MOD-CB0154 12/11/23 By Elise 修正參數傳遞
# Modify.........: No.MOD-CB0046 12/11/23 By Elise 修正因系統無考慮單位換算率，導致倉庫欄位帶欠料
# Modify.........: No.FUN-CB0043 12/11/26 By bart sfe_file增加自定義欄位
# Modify.........: No.TQC-CB0084 12/11/26 By fengrui 調用s_shortqty時，若sfs012、sfs013為空則預設為空格
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善,qiull imn_file
# Modify.........: No:MOD-D10040 13/01/08 By bart 修改asfi501a視窗問題
# Modify.........: No.CHI-CB0063 13/01/11 By Elise asfi512/asfi514/asfi529增加欄位sfp14
# Modify.........: No.MOD-CA0183 13/01/11 By Elise 修正因issue_type不同而使ware_no/loc_no/lot_no沒有將值寫入
# Modify.........: No:MOD-D10104 13/01/25 By bart g_sfp.sfp06='6'時 ，條件不用有img10>0
# Modify.........: No:CHI-BA0016 13/01/25 By Alberti 取代替時，abmi6042主件為ALL的資料也要撈出來
# Modify.........: No:MOD-BA0137 13/01/28 By Alberti 參考單位不控卡數量
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No.TQC-D20042 13/02/25 By fengrui 修正倉庫單據理由碼改善测试问题
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/22 By minpp 設限倉庫控卡
# Modify.........: No:MOD-D30037 13/03/06 By bart 1.修改單身沒輸入替代碼時，發料料號會等於被替代料號2.若輸入替代碼時，作業編號必輸，但不走製程
# Modify.........: No:CHI-C50011 13/03/08 By Alberti 當替代碼為空時,被替代料應不可輸入,在輸入sfs04時自動預設帶出被替代料
#                                                    一併修改 TQC-C70050 
# Modify.........: No:MOD-C80213 13/03/08 By Alberti 判斷sfs012,sfs013是否給預設值前,應先給sfa012,sfa013再做判斷 
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:MOD-D30121 13/03/15 By Alberti 有輸入作業編號時，應以此作業編號之最小發料套數為已發數量
# Modify.........: No.MOD-D30125 13/03/15 By Alberti 1.已發數量應去發料檔中看此作業變號最小發料套數 2. 除了第一站外，其餘不回寫工單單頭套數
# Modify.........: No.DEV-D30026 13/03/19 By Nina GP5.3 追版:DEV-D10021、DEV-D30019為GP5.25 的單號
# Modify.........: No:MOD-D30207 13/03/25 By ck2yuan 產生調撥時，會更新發料單的儲批序，但批號會清掉        
# Modify.........: No:CHI-D30038 13/03/25 By bart sfp06 MATCHES '[2479C]'隱藏刪除單身全部資料按鈕
# Modify.........: No:TQC-D40001 13/04/01 By fengrui 滿足負庫存條件,新倉儲批寫入img_file
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:DEV-D40011 13/04/11 By Nina 將Action條碼欠料調整(barcode_qty_allot)隱藏
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数
# Modify.........: No:MOD-D40218 13/04/29 By bart 於mod計算前，將二邊數值*1000
# Modify.........: No:TQC-D40077 13/04/24 By dongsz 解決查詢情況下點擊退出會報錯問題
# Modify.........: No:FUN-D50017 13/05/08 By fengrui sfe_file新增理由碼sfe37
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D40123 13/05/10 By lixiang 作業編號欄位不為空是，進行檢查管控
# Modify.........: No:TQC-D50070 13/05/13 By lixiang “生成調撥單”打印的報表增加倉管員名稱和料件規格
# Modify.........: No:MOD-D50151 13/05/20 By bart 單身一增加控管，不可存在相同之工單+作業編號+計畫日期
# Modify.........: No:MOD-D50173 13/05/21 By bart 所有"asf-012"判斷的地方，增加退料部份不判斷
# Modify.........: No:MOD-D50178 13/05/22 By bart 一般退料誤差率控卡問題
# Modify.........: No.DEV-D50009 13/05/23 By Nina 修正判斷CALL批序號變數的預設值
# Modify.........: No.CHI-D50037 13/05/24 By bart 修改無單身刪除單頭
# Modify.........: No.MOD-D50233 13/05/28 By bart 重工工單asf-898只顯示提示不強制控卡
# Modify.........: No:TQC-D50124 13/05/28 By lixh1 拿掉儲位有效性檢查
# Modify.........: No:CHI-D50047 13/05/29 By bart 儲位控卡時跳到倉庫儲位
# Modify.........: No:FUN-D60005 13/06/03 By wangrr 開放【列印】
# Modify.........: No:MOD-D60027 13/06/04 By Alberti 退料量之修改
# Modify.........: No:MOD-D60040 13/06/05 By suncx 管控倉庫不可錄入發票倉
# Modify.........: No:MOD-D60042 13/06/06 By suncx 修改asf-526的報錯，讓報錯跟準確，欠料補料和成套退料時，未錄入套數時參照成套發料時的方式處理
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 修改欄位跳轉問題
# Modify.........: No.MOD-C90143 13/06/07 By Alberti 若l_sfaiicd03為NULL給予預設值一個空白
# Modify.........: No.FUN-D60039 13/06/07 By fengrui 小數取位統一為進一制
# Modify.........: No.FUN-D20008 13/06/07 By bart 抓不到ima136,ima137改抓sma75,sma76
# Modify.........: No.CHI-D60012 13/06/11 By Alberti 修改理由碼(sfs37)之開窗
# Modify.........: No.FUN-D10073 13/06/13 By bart asfi510a增加"依倉庫優先順序進行先進先出"
# Modify.........: No.MOD-D60165 13/06/19 By suncx 刪除自動產生的第二單身資料後，手動錄入不走BEFORE INSERT
# Modify.........: No.MOD-D60164 13/06/20 By Alberti 產生調撥單之過帳日期(imm17)回寫錯誤
# Modify.........: No.MOD-D60168 13/06/20 By Alberti 欠補料之問題
# Modify.........: No.FUN-D60094 13/06/24 By zhuhao 產生發料單身時，若選擇4.依庫存量發料，單身庫存量欄位應去除同單據中已用庫存量
# Modify.........: No.MOD-D60189 13/06/27 By yuhuabao asfi511 第二單身 發料量應該允許輸入0.
# Modify.........: No.MOD-D60001 13/06/27 By fengmy 查询多仓库资料,增加传参
# Modify.........: No.MOD-D60244 13/07/01 By yuhuabao asfi511 修改点击更改仓库批时候，进入单身，可进行右侧的单身全部删除动作
# Modify.........: No.TQC-D70055 13/07/22 By yangtt 在AFTER FIELLD sfs03里增加sfa11='E'的控管
# Modify.........: No.MOD-D80178 13/08/28 By Alberti 領料時如果單身超過2筆資料，回傳會有錯誤
# Modify.........: No.MOD-D90093 13/09/18 By suncx 在刪除資料時，應該在DELETE sfp_file前調用s_lot_del()函数，否则如果是在asfi510中刪除資料，
#                                                  後續s_lot_del()函数中將無法抓取sfp06判斷g_rvbs00的值
# Modify.........: No.TQC-DB0051 13/11/21 By wangrr 修改點擊[套數]后的提示語句

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi501.global"
 
DEFINE g_ima918     LIKE ima_file.ima918       #No.FUN-810036
DEFINE g_ima921     LIKE ima_file.ima921       #No.FUN-810036
DEFINE g_ima930     LIKE ima_file.ima930       #DEV-D30040 add
DEFINE l_r          LIKE type_file.chr1        #No.FUN-860045
DEFINE l_fac        LIKE img_file.img34        #No.FUN-860045
DEFINE li_where     LIKE type_file.chr1000     #No.FUN-940039
DEFINE g_sfs27      LIKE sfs_file.sfs27        #MOD-9A0123
DEFINE g_sfs012     LIKE sfs_file.sfs012       #FUN-A50066
DEFINE g_sfs013     LIKE sfs_file.sfs013       #FUN-A50066
DEFINE g_ima23      LIKE ima_file.ima23        #TQC-9C0195 add
DEFINE g_sfq02      LIKE sfq_file.sfq02        #TQC-A30108  
DEFINE g_wm         LIKE type_file.chr1        #TQC-AC0197
DEFINE g_laststage  LIKE type_file.chr1        #FUN-AB0001 add
DEFINE g_chr2       LIKE type_file.chr1        #FUN-AB0001 add
#FUN-B30170 add begin--------------------------
DEFINE g_rvbs DYNAMIC ARRAY OF RECORD          #批序號明細單身變量
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
#FUN-CB0014---add---str---
DEFINE g_sfp_l DYNAMIC ARRAY OF RECORD
                  sfp01   LIKE sfp_file.sfp01,
                  smydesc LIKE smy_file.smydesc,
                  sfp02   LIKE sfp_file.sfp02,
                  sfp03   LIKE sfp_file.sfp03,
                  sfp06   LIKE sfp_file.sfp06,
                  sfp07   LIKE sfp_file.sfp07,
                  gem02   LIKE gem_file.gem02,
                  sfp08   LIKE sfp_file.sfp08,
                  sfp16   LIKE sfp_file.sfp16,
                  gen02   LIKE gen_file.gen02,
                  sfpconf LIKE sfp_file.sfpconf,
                  sfpmksg LIKE sfp_file.sfpmksg,
                  sfp04   LIKE sfp_file.sfp04,
                  sfp05   LIKE sfp_file.sfp05,
                  sfp09   LIKE sfp_file.sfp09,
                  sfp10   LIKE sfp_file.sfp10,
                  sfp15   LIKE sfp_file.sfp15
               END RECORD
DEFINE l_ac2    LIKE type_file.num5
DEFINE g_rec_b2 LIKE type_file.num5  
DEFINE g_action_flag   STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#FUN-CB0014---add---end---
DEFINE g_rec_b1     LIKE type_file.num5,          #單身二筆數 ##FUN-B30170
       l_ac1        LIKE type_file.num5           #目前處理的ARRAY CNT  #FUN-B30170
DEFINE g_sfs06_t    LIKE sfs_file.sfs06           #FUN-BB0084
DEFINE g_sfs30_t    LIKE sfs_file.sfs30           #FUN-BB0084
DEFINE g_sfs33_t    LIKE sfs_file.sfs33           #FUN-BB0084 
#FUN-B30170 add -end---------------------------
#FUN-C70014 add begin--------------------
DEFINE g_multi_sfq014 DYNAMIC ARRAY OF RECORD
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         shm05    LIKE shm_file.shm05
         END RECORD
#FUN-C70014 add end ---------------------
#DEFINE g_sma894     LIKE type_file.chr1           #FUN-C80107 #FUN-D30024 mark
DEFINE g_imd23      LIKE type_file.chr1           #FUN-D30024 add 
         
FUNCTION i501(p_argv1, p_argv2, p_argv3, p_argv4)
   DEFINE p_argv1       LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)# 1.發料 2.退料
   DEFINE p_argv2       LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)# 1.發料 2.退料
   DEFINE p_argv3       LIKE sfp_file.sfp01         # 發料單號 #MOD-580252
   DEFINE p_argv4       STRING                      # 功能 FUN-660166
   DEFINE l_i           LIKE type_file.num5         #FUN-510029  #No.FUN-680121 SMALLINT
 
    WHENEVER ERROR CONTINUE                         #忽略一切錯誤
    CALL cl_set_toolbaritem_visible('output',TRUE)  #FUN-D60005

    CALL i501_mu_ui()
 
    IF p_argv2 MATCHES '[ABC]' THEN
       CALL cl_set_comp_visible("sfp08,sfp09,sfp10,sfb05,sfa05,sfa06,sfs10",FALSE)
       CALL cl_getmsg('asr-006',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfq02",g_msg CLIPPED)
       CALL cl_set_comp_att_text("sfs03",g_msg CLIPPED)
       CALL cl_getmsg('asr-007',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfq04",g_msg CLIPPED)
       CALL cl_set_comp_required("sfq04",TRUE)
       CALL cl_set_comp_entry("sfq05,sfq03",TRUE)
       CALL cl_set_act_visible("gen_transfer_note,qry_issue_item",FALSE)
       CALL cl_set_comp_visible("sfs27",FALSE) #FUN-940039 add 
       CALL cl_set_comp_visible("sfq08",FALSE) #FUN-940008 add
    ELSE
       CALL cl_set_comp_visible("sfp11,azf03,sfq05",FALSE) #FUN-630084 add sfp11,azf03
       CALL cl_set_comp_visible("sfs27",TRUE) #FUN-940039 add 
       CALL cl_set_comp_visible("sfq08",TRUE) #FUN-940008 add 
    END IF
    IF g_aza.aza115 ='Y' THEN                  #FUN-CB0087 add 
       CALL cl_set_comp_required('sfs37',TRUE) #FUN-CB0087 add
    END IF 
    IF p_argv2 MATCHES '[C]' THEN
       CALL cl_set_comp_required("sfq05",FALSE)
       CALL cl_set_act_visible("regen_detail",FALSE)
    END IF
    #CHI-D30038---begin
    IF p_argv2 MATCHES '[2479]' THEN
       CALL cl_set_act_visible("regen_detail",FALSE)
    END IF
    #CHI-D30038---end
#FUN-B20095 -----------------Begin---------------------    
    IF g_sma.sma541 = 'Y'  THEN
       CALL cl_set_comp_visible("sfq012,ecm014",TRUE)  
    ELSE
       CALL cl_set_comp_visible("sfq012,ecm014",FALSE)   
    END IF 
#FUN-B20095 -----------------End-----------------------    
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("sfp07",TRUE)
       IF (NOT p_argv2 MATCHES '[ABC]') OR (cl_null(p_argv2)) THEN
          CALL cl_set_comp_entry("sfs930",FALSE)
       END IF
    END IF
    CALL cl_set_comp_visible("sfs930,gem02c",g_aaz.aaz90='Y')

    IF NOT cl_null(p_argv2) THEN 
       IF NOT (g_sma.sma118 = 'Y' AND p_argv2 MATCHES '[ABC]' )THEN  
          CALL cl_set_comp_visible('sfq07',FALSE) 
       END IF
    ELSE
       CALL cl_set_comp_visible('sfq07',FALSE)    
    END IF
    
    IF g_sma.sma129='N' THEN
       CALL cl_set_comp_visible("sfq08",TRUE)
    ELSE 
       CALL cl_set_comp_visible("sfq08",FALSE)
    END IF 
    	     
#FUN-A60028 --begin--
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("sfs012,sfs013,ecu014",TRUE)
    ELSE
       CALL cl_set_comp_visible("sfs012,sfs013,ecu014",FALSE)   
    END IF 
#FUN-A60028 --end--
#FUN-C70014 add begin--------------
    IF p_argv2 <> 'D' THEN 
       CALL cl_set_comp_visible("sfs014,sfq014",FALSE)
    ELSE
       CALL cl_set_comp_visible("sfs014,sfq014",TRUE)
    END IF
#FUN-C70014 add end----------------    
#MOD-B30148 --------------------Begin--------------------------
#TQC-AC0197 --------------------Begin--------------------------
#   IF g_sma.sma129 = 'N' THEN
#      IF p_argv2  MATCHES '[1368]' THEN
#         CALL cl_set_act_visible("warahouse_modify",TRUE)
#      ELSE
#         CALL cl_set_act_visible("warahouse_modify",FALSE)
#      END IF
#   ELSE
#      IF p_argv2  MATCHES '[38]' THEN 
#         CALL cl_set_act_visible("warahouse_modify",TRUE)
#      ELSE
#         CALL cl_set_act_visible("warahouse_modify",FALSE) 
#      END IF
#   END IF
#TQC-AC0197 --------------------End----------------------------
#MOD-B30148 --------------------End----------------------------
    CALL cl_set_act_visible("qry_lot,modi_lot",g_sma.sma95="Y")  #FUN-C80030 add
    CALL cl_set_comp_visible("Page2",g_sma.sma95="Y")            #FUN-C80030 add

   #CHI-CB0063---add---S
    IF g_prog ='asfi512' OR g_prog ='asfi514' OR g_prog ='asfi529' THEN
       CALL cl_set_comp_visible("sfp14",TRUE)
    ELSE
       CALL cl_set_comp_visible("sfp14",FALSE)
    END IF
   #CHI-CB0063---add---E
    	     
    LET g_wc2 =' 1=1'
    LET g_wc3 =' 1=1'
    LET g_wc5 =' 1=1'      #MOD-A50110 add
 
    LET g_forupd_sql = "SELECT * FROM sfp_file WHERE sfp01 = ? FOR UPDATE"           #09/10/21 xiaofeizhu Add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4       #No.FUN-660166
    LET g_sfs27 = NULL          #MOD-9A0123
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
 
    LET g_ask_post='Y'
 
    #FUN-AB0001--add--str---
    IF fgl_getenv('EASYFLOW') = "1" THEN    #判斷是否為簽核模式
       LET g_argv3 = aws_efapp_wsk(1)       #取得單號
    END IF
    CALL aws_efapp_toolbar()                #建立簽核模式時的 toolbar icon
    #FUN-AB0001--add--end---

    IF NOT cl_null(g_argv3) THEN
       CASE g_argv4
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i501_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i501_a()
             END IF
          #FUN-AB0001--add---str---
          WHEN "efconfirm"
             LET g_action_choice = "efconfirm"
             CALL i501_q()
             CALL i501sub_y_chk(g_sfp.sfp01,g_action_choice)           #CALL 原確認的 check 段 #TQC-C60079
             IF g_success = 'Y' THEN
                 CALL i501sub_y_upd(g_sfp.sfp01,g_action_choice,FALSE) #CALL 原確認的 update 段
                      RETURNING g_sfp.*
             END IF
            #CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD  #TQC-CA0025 mark
             EXIT PROGRAM
          #FUN-AB0001--add---end---
          OTHERWISE
             CALL i501_q()
       END CASE
    END IF

    #FUN-AB0001---add---str---
    ##傳入簽核模式時不應執行的 action 清單
    CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void,undo_void,     #CHI-D20010 add--undo_void                               confirm, undo_confirm, stock_post, undo_post, easyflow_approval,                                sets, gen_transfer_note, reproduce, regen_detail, s_icdout, exporttoexcel, modi_lot, warahouse_modify, barcode_qty_allot")    #DEV-D30026 add barcode_qty_allot
          RETURNING g_laststage
    #FUN-AB0001---add---end---
 
    IF g_ask_post='Y' THEN
       CALL i501_menu()
    END IF
 
END FUNCTION
 
FUNCTION i501_cs()
DEFINE l_buf   LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
DEFINE l_length,l_i LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE l_buf_rpl    STRING    #FUN-B70061        
 
  IF cl_null(g_argv3) THEN
    CLEAR FORM                             #清除畫面
    CALL g_sfq.clear()
    CALL g_sfs.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfp.* TO NULL    #No.FUN-750051
   #No.FUN-A40055--begin
#    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
#        sfp01,sfp02,sfp03,sfp06,sfp07,sfp08,sfp05,sfpconf, #FUN-660106
#        sfp04,sfp09,sfp10,sfp11, #FUN-630084 add sfp11
#        sfpuser,sfpgrup,sfpmodu,sfpdate 
#        ,sfpud01,sfpud02,sfpud03,sfpud04,sfpud05,
#        sfpud06,sfpud07,sfpud08,sfpud09,sfpud10,
#        sfpud11,sfpud12,sfpud13,sfpud14,sfpud15
# 
#               BEFORE CONSTRUCT
#                  CALL cl_qbe_init()
#        ON ACTION controlp
#          CASE WHEN INFIELD(sfp01) #查詢單据
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form   = "q_sfp"
#                    LET g_qryparam.arg1   = g_argv2  #FUN-4A0076,FUN-4A0077 add
#                    ##組合拆解的工單發料不顯示出來!
#                    LET g_qryparam.where = " substr(sfp01,1,",g_doc_len,") NOT IN (SELECT smy70 FROM smy_file WHERE smy70 IS NOT NULL) "
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO sfp01
#                    NEXT FIELD sfp01
#               WHEN INFIELD(sfp07)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form   ="q_gem"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO sfp07
#                    NEXT FIELD sfp07
#               WHEN INFIELD(sfp08)   #料表批號
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form ="q_sfc"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO sfp08
#                    NEXT FIELD sfp08
#               WHEN INFIELD(sfp11)
#                    IF g_sma.sma79='Y' THEN
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_azf"
#                       LET g_qryparam.default1 = g_sfp.sfp11,'A'
#                       LET g_qryparam.arg1 = "A"
#                       LET g_qryparam.state = "c"
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    ELSE
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_azf01a"                      #No.FUN-930106
#                       LET g_qryparam.default1 = g_sfp.sfp11,'2'
#                       IF g_argv1='1' THEN 
#                          LET g_qryparam.arg1 = "C"
#                       ELSE
#                          LET g_qryparam.arg1 = "E"
#                       END IF 
#                       LET g_qryparam.state = "c"
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    END IF
#                    DISPLAY g_qryparam.multiret TO sfp11
#                    NEXT FIELD sfp11
#            END CASE
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#                 ON ACTION qbe_select
#		   CALL cl_qbe_list() RETURNING lc_qbe_sn
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#    END CONSTRUCT
# 
#    IF INT_FLAG THEN RETURN END IF
# 
#    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfpuser', 'sfpgrup')
# 
# 
#    IF g_argv1='1' THEN
#       LET g_wc = g_wc clipped," AND sfp06 IN ('1','2','3','4','A','C')" #FUN-5C0114 add AC
#    ELSE
#       LET g_wc = g_wc clipped," AND sfp06 IN ('6','7','8','9','B')" #FUN-5C0114 add B
#    END IF
# 
#    IF g_argv2 <> ' ' THEN
#       LET g_wc = g_wc clipped," AND sfp06 MATCHES '",g_argv2,"'"
#    END IF
# 
#    ##組合拆解的工單發料不顯示出來!
#    LET g_wc = g_wc CLIPPED,
#               " AND sfp01[1,",g_doc_len,"] NOT IN (SELECT smy70 FROM smy_file WHERE smy70 IS NOT NULL) "   #CHI-9B0005 mod
# 
#    CONSTRUCT g_wc2 ON sfq02,sfq04,sfq05,sfq07,sfq08,sfq03  #FUN-870097 add sfq07 #FUN-5C0114 add sfq05 #FUN-940008 add sfq08
#              ,sfqud01,sfqud02,sfqud03,sfqud04,sfqud05,
#              sfqud06,sfqud07,sfqud08,sfqud09,sfqud10,
#              sfqud11,sfqud12,sfqud13,sfqud14,sfqud15
#         FROM s_sfq[1].sfq02,s_sfq[1].sfq04,s_sfq[1].sfq05,s_sfq[1].sfq07,s_sfq[1].sfq08,s_sfq[1].sfq03 #FUN-870097 add sfq07 #FUN-5C0114 add sfq05 #FUN-940008 add sfq08
#              ,s_sfq[1].sfqud01,s_sfq[1].sfqud02,s_sfq[1].sfqud03,s_sfq[1].sfqud04,s_sfq[1].sfqud05,
#              s_sfq[1].sfqud06,s_sfq[1].sfqud07,s_sfq[1].sfqud08,s_sfq[1].sfqud09,s_sfq[1].sfqud10,
#              s_sfq[1].sfqud11,s_sfq[1].sfqud12,s_sfq[1].sfqud13,s_sfq[1].sfqud14,s_sfq[1].sfqud15
# 
#		BEFORE CONSTRUCT
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#      ON ACTION controlp
#         IF NOT g_argv2 MATCHES '[ABC]' THEN #FUN-5C0114 #TQC-620157 #CHI-740016
#            CASE WHEN INFIELD(sfq02)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form = "q_sfb03"
#                      LET g_qryparam.arg1 = g_argv2
#                      ##組合拆解的工單不顯示出來!
#                      LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO sfq02
#                      NEXT FIELD sfq02
#            END CASE
#         ELSE
#            CASE WHEN INFIELD(sfq02)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_ima17" #MOD-630064
#                      LET g_qryparam.state    = "c"
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO sfq02
#                      NEXT FIELD sfq02
#                 WHEN INFIELD(sfq04)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_eci"
#                      LET g_qryparam.state = "c"
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO sfq04
#                      NEXT FIELD sfq04
#                 WHEN INFIELD(sfq07)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_bma7"
#                      LET g_qryparam.state = "c"
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO  sfq07
#                      NEXT FIELD sfq07
#            END CASE
#         END IF         
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#    END CONSTRUCT
# 
#    IF INT_FLAG THEN RETURN END IF
# 
#    CONSTRUCT g_wc3 ON sfs02,sfs26,sfs03,sfs04,sfs27,sfs06,sfs10,     ##FUN-940039 add sfs27
#                       sfs07,sfs08,sfs09,sfs05,sfs21,sfs33,sfs34,
#                       sfs35,sfs30,sfs31,sfs32,sfs930,sfs36  #FUN-670103  #FUN-950088 add sfs36
#                       ,sfsud01,sfsud02,sfsud03,sfsud04,sfsud05,
#                       sfsud06,sfsud07,sfsud08,sfsud09,sfsud10,
#                       sfsud11,sfsud12,sfsud13,sfsud14,sfsud15
#                  FROM s_sfs[1].sfs02,s_sfs[1].sfs26,s_sfs[1].sfs03,
#                       s_sfs[1].sfs04,s_sfs[1].sfs27,s_sfs[1].sfs06,s_sfs[1].sfs10,   #FUN-940039 add sfs27
#                       s_sfs[1].sfs07,s_sfs[1].sfs08,s_sfs[1].sfs09,
#                       s_sfs[1].sfs05,s_sfs[1].sfs21,s_sfs[1].sfs33,
#                       s_sfs[1].sfs34,s_sfs[1].sfs35,s_sfs[1].sfs30,
#                       s_sfs[1].sfs31,s_sfs[1].sfs32,s_sfs[1].sfs930,  #FUN-670103
#                       s_sfs[1].sfs36  #FUN-950088 add
#                       ,s_sfs[1].sfsud01,s_sfs[1].sfsud02,s_sfs[1].sfsud03,s_sfs[1].sfsud04,s_sfs[1].sfsud05,
#                       s_sfs[1].sfsud06,s_sfs[1].sfsud07,s_sfs[1].sfsud08,s_sfs[1].sfsud09,s_sfs[1].sfsud10,
#                       s_sfs[1].sfsud11,s_sfs[1].sfsud12,s_sfs[1].sfsud13,s_sfs[1].sfsud14,s_sfs[1].sfsud15
#		BEFORE CONSTRUCT
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#        ON ACTION controlp
#           CASE WHEN INFIELD(sfs04)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state  = "c"
#                     LET g_qryparam.form ="q_ima"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO sfs04
#                     NEXT FIELD sfs04
#                WHEN INFIELD(sfs27)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state  = "c"
#                     LET g_qryparam.form ="q_ima"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO sfs27
#                     NEXT FIELD sfs27
#                WHEN INFIELD(sfs03)
#                     IF NOT g_argv2 MATCHES '[ABC]' THEN     #TQC-620157 #TQC-650053
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state  = "c"
#                        LET g_qryparam.form ="q_sfb02"
#                        LET g_qryparam.arg1 = 2345678
#                        ##組合拆解的工單不顯示出來!
#                        LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     ELSE
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.state  = "c"
#                       LET g_qryparam.form ="q_ima17" #MOD-630064
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     END IF
#                     DISPLAY g_qryparam.multiret TO sfs03
#                     NEXT FIELD sfs03
#                WHEN INFIELD(sfs07)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form     = "q_imd"
#                     LET g_qryparam.state    = "c"
#                     LET g_qryparam.arg1     = "SW"   #FUN-4A0077
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO sfs07
#                     NEXT FIELD sfs07
#                WHEN INFIELD(sfs08)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form     = "q_ime"
#                     LET g_qryparam.state    = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO sfs08
#                     NEXT FIELD sfs08
#                WHEN INFIELD(sfs06)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state  = "c"
#                     LET g_qryparam.form ="q_gfe"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO sfs06
#                     NEXT FIELD sfs06
#               WHEN INFIELD(sfs33)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_gfe"
#                  LET g_qryparam.default1 = g_sfs[1].sfs33
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO sfs33
#                  NEXT FIELD sfs33
#               WHEN INFIELD(sfs30)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_gfe"
#                  LET g_qryparam.default1 = g_sfs[1].sfs30
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO sfs30
#                  NEXT FIELD sfs30
#               WHEN INFIELD(sfs10)
#                  CALL q_ecd(TRUE,TRUE,g_sfs[1].sfs10)
#                       RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO sfs10
#                  NEXT FIELD sfs10
#               WHEN INFIELD(sfs930)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form  = "q_gem4"
#                  LET g_qryparam.state = "c"   #多選
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO sfs930
#                  NEXT FIELD sfs930
#               WHEN INFIELD(sfs36)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_mse"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO sfs36
#                  NEXT FIELD sfs36
#           END CASE
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#                    ON ACTION qbe_save
#		       CALL cl_qbe_save()
#    END CONSTRUCT
####
    DIALOG ATTRIBUTES(UNBUFFERED)
    CONSTRUCT BY NAME g_wc ON                                 # 螢幕上取單頭條件
       #sfp01,sfp02,sfp03,sfp06,sfp07,sfp08,sfp05,sfpconf,    #FUN-660106  #FUN-AB0001 mark 
        sfp01,sfp02,sfp03,sfp06,sfp07,sfp08,sfp16,sfp05,sfpconf,sfpmksg,   #FUN-AB0001 add
        sfp04,sfp09,sfp10,sfp11,sfp14,sfp15,                  #FUN-630084 add sfp11  #FUN-AB0001 add:sfp15  #CHI-CB0063 add sfp14
        sfpuser,sfpgrup,sfporiu,sfporig,sfpmodu,sfpdate       #No.TQC-BB0231
        ,sfpud01,sfpud02,sfpud03,sfpud04,sfpud05,
        sfpud06,sfpud07,sfpud08,sfpud09,sfpud10,
        sfpud11,sfpud12,sfpud13,sfpud14,sfpud15
 
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
    END CONSTRUCT

    ##組合拆解的工單發料不顯示出來! 
    CONSTRUCT g_wc2 ON sfq014,sfq02,sfq012,sfq04,sfq05,sfq07,sfq08,sfq03  #FUN-870097 add sfq07 #FUN-5C0114 add sfq05 #FUN-940008 add sfq08   #FUN-B20095 add sfq012  #FUN-C70014 add sfq014
              ,sfqud01,sfqud02,sfqud03,sfqud04,sfqud05,
              sfqud06,sfqud07,sfqud08,sfqud09,sfqud10,
              sfqud11,sfqud12,sfqud13,sfqud14,sfqud15
         FROM s_sfq[1].sfq014,s_sfq[1].sfq02,s_sfq[1].sfq012,s_sfq[1].sfq04,s_sfq[1].sfq05,s_sfq[1].sfq07,s_sfq[1].sfq08,s_sfq[1].sfq03 #FUN-870097 add sfq07 #FUN-5C0114 add sfq05 #FUN-940008 add sfq08   #FUN-B20095 add sfq012 #FUN-C70014 add sfq014
              ,s_sfq[1].sfqud01,s_sfq[1].sfqud02,s_sfq[1].sfqud03,s_sfq[1].sfqud04,s_sfq[1].sfqud05,
              s_sfq[1].sfqud06,s_sfq[1].sfqud07,s_sfq[1].sfqud08,s_sfq[1].sfqud09,s_sfq[1].sfqud10,
              s_sfq[1].sfqud11,s_sfq[1].sfqud12,s_sfq[1].sfqud13,s_sfq[1].sfqud14,s_sfq[1].sfqud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		   
    END CONSTRUCT
    CONSTRUCT g_wc3 ON sfs02,sfs26,sfs014,sfs03,sfs27,sfs04,sfs012,sfs013,sfs06,sfs10,  ##FUN-940039 add sfs27  #FUN-A60028 add sfs012,sfs013  #CHI-BC0040 sfs27與sfs04前後交換   #FUN-C70014 add sfs014
                       sfs07,sfs08,sfs09,sfs05,sfs21,sfs33,sfs34,
                       sfs35,sfs30,sfs31,sfs32,sfs930,sfs36,sfs37  #FUN-670103  #FUN-950088 add sfs36 #FUN-CB0087 add sfs37
                       ,sfsud01,sfsud02,sfsud03,sfsud04,sfsud05,
                       sfsud06,sfsud07,sfsud08,sfsud09,sfsud10,
                       sfsud11,sfsud12,sfsud13,sfsud14,sfsud15
                       ,sfsiicd028,sfsiicd029   #FUN-B70061
                  FROM s_sfs[1].sfs02,s_sfs[1].sfs26,s_sfs[1].sfs014,s_sfs[1].sfs03,    #FUN-C70014 add sfs014
                       s_sfs[1].sfs27,s_sfs[1].sfs04,s_sfs[1].sfs012,s_sfs[1].sfs013,s_sfs[1].sfs06,s_sfs[1].sfs10, #CHI-BC0040 sfs27與sfs04前後交換 
                                               #FUN-940039 add sfs27        #FUN-A60028 add sfs012,sfs013
                       s_sfs[1].sfs07,s_sfs[1].sfs08,s_sfs[1].sfs09,
                       s_sfs[1].sfs05,s_sfs[1].sfs21,s_sfs[1].sfs33,
                       s_sfs[1].sfs34,s_sfs[1].sfs35,s_sfs[1].sfs30,
                       s_sfs[1].sfs31,s_sfs[1].sfs32,s_sfs[1].sfs930,  #FUN-670103
                       s_sfs[1].sfs36,s_sfs[1].sfs37  #FUN-950088 add sfs36  #FUN-CB0087 add sfs37
                       ,s_sfs[1].sfsud01,s_sfs[1].sfsud02,s_sfs[1].sfsud03,s_sfs[1].sfsud04,s_sfs[1].sfsud05,
                       s_sfs[1].sfsud06,s_sfs[1].sfsud07,s_sfs[1].sfsud08,s_sfs[1].sfsud09,s_sfs[1].sfsud10,
                       s_sfs[1].sfsud11,s_sfs[1].sfsud12,s_sfs[1].sfsud13,s_sfs[1].sfsud14,s_sfs[1].sfsud15
                       ,s_sfs[1].sfsiicd028,s_sfs[1].sfsiicd029   #FUN-B70061
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
     
        ON ACTION controlp
          CASE WHEN INFIELD(sfp01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "q_sfp"
                    LET g_qryparam.arg1   = g_argv2  #FUN-4A0076,FUN-4A0077 add
                    ##組合拆解的工單發料不顯示出來!
                   #LET g_qryparam.where = " substr(sfp01,1,",g_doc_len,") NOT IN (SELECT smy70 FROM smy_file WHERE smy70 IS NOT NULL) "
                    #LET g_qryparam.where = " sfp01[1,",g_doc_len,"] NOT IN (SELECT smy70 FROM smy_file WHERE smy70 IS NOT NULL) "  #FUN-B40029 #TQC-C50227
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfp01
                    NEXT FIELD sfp01
               WHEN INFIELD(sfp07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfp07
                    NEXT FIELD sfp07
               WHEN INFIELD(sfp08)   #料表批號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form ="q_sfc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfp08
                    NEXT FIELD sfp08
               WHEN INFIELD(sfp11)
                    IF g_sma.sma79='Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf"
                       LET g_qryparam.default1 = g_sfp.sfp11,'A'
                       LET g_qryparam.arg1 = "A"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf01a"                      #No.FUN-930106
                       LET g_qryparam.default1 = g_sfp.sfp11,'2'
                       IF g_argv1='1' THEN 
                          LET g_qryparam.arg1 = "C"
                       ELSE
                          LET g_qryparam.arg1 = "E"
                       END IF 
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    END IF
                    DISPLAY g_qryparam.multiret TO sfp11
                    NEXT FIELD sfp11
            END CASE        
           IF NOT g_argv2 MATCHES '[ABC]' THEN #FUN-5C0114 #TQC-620157 #CHI-740016
              CASE WHEN INFIELD(sfq02)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form = "q_sfb03"
                        LET g_qryparam.arg1 = g_argv2
                        ##組合拆解的工單不顯示出來!
                       #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                       # LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "  #FUN-B40029 #TQC-C50227
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfq02
                        NEXT FIELD sfq02
          #FUN-B20095 ---------------Begin-------------------
                   WHEN INFIELD(sfq012)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state  = "c"
                        LET g_qryparam.form = "q_sfq012" 
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfq012 
                        NEXT FIELD sfq012
          #FUN-B20095 ---------------End---------------------                          
              END CASE
           ELSE
              CASE WHEN INFIELD(sfq02)
#FUN-AA0059---------mod------------str----------------- 
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_ima17" #MOD-630064
#                       LET g_qryparam.state    = "c"
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima(TRUE, "q_ima17","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
                        DISPLAY g_qryparam.multiret TO sfq02
                        NEXT FIELD sfq02
                   WHEN INFIELD(sfq04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_eci"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfq04
                        NEXT FIELD sfq04
                   WHEN INFIELD(sfq07)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bma7"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO  sfq07
                        NEXT FIELD sfq07
              END CASE
           END IF                  
           CASE WHEN INFIELD(sfs04)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form ="q_ima"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------

                     DISPLAY g_qryparam.multiret TO sfs04
                     NEXT FIELD sfs04
#FUN-A60028 --begin--
                WHEN INFIELD(sfs012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_sfs012"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfs012
                     NEXT FIELD sfs012
                     
                WHEN INFIELD(sfs013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_sfs013"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfs013
                     NEXT FIELD sfs013                
#FUN-A60028 --end--                     
                WHEN INFIELD(sfs27)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form ="q_ima"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------

                     DISPLAY g_qryparam.multiret TO sfs27
                     NEXT FIELD sfs27
                #FUN-CB0087--add--str--
                WHEN INFIELD(sfs37)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                    #LET g_qryparam.form ="q_azf41"         #CHI-D60012 mark
                     LET g_qryparam.form ="q_azf01a"        #CHI-D60012 add
                    #CHI-D60012-Start 
                     IF g_argv1='1' THEN
                        LET g_qryparam.arg1 = "C"
                     ELSE
                        LET g_qryparam.arg1 = "E"
                     END IF
                    #CHI-D60012-End
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfs37
                     NEXT FIELD sfs37
                #FUN-CB0087--add--end--
                WHEN INFIELD(sfs03)
                     IF NOT g_argv2 MATCHES '[ABC]' THEN     #TQC-620157 #TQC-650053
                        CALL cl_init_qry_var()
                        LET g_qryparam.state  = "c"
                        LET g_qryparam.form ="q_sfb02"
                        LET g_qryparam.arg1 = 2345678
                        ##組合拆解的工單不顯示出來!
                       #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                       # LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69  IS NOT NULL) " #FUN-B40029 #TQC-C50227
                        #CHI-C30040---begin
                        IF g_prog = 'asfi514' OR g_prog = 'asfi529' THEN
                           LET g_qryparam.where = g_qryparam.where CLIPPED, " AND EXISTS (SELECT 1 FROM sfa_file WHERE sfa01 = sfb01 AND sfa11 = 'E') "  
                        END IF 
                        #CHI-C30040---end if
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                     ELSE
#FUN-AA0059---------mod------------str-----------------
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state  = "c"
#                      LET g_qryparam.form ="q_ima17" #MOD-630064
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima(TRUE, "q_ima17","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
                     END IF
                     DISPLAY g_qryparam.multiret TO sfs03
                     NEXT FIELD sfs03
                WHEN INFIELD(sfs07)
                    #Mod No.FUN-AB0018
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imd"
                    #LET g_qryparam.state    = "c"
                    #LET g_qryparam.arg1     = "SW"   #FUN-4A0077
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AB0018
                     DISPLAY g_qryparam.multiret TO sfs07
                     NEXT FIELD sfs07
                WHEN INFIELD(sfs08)
                    #Mod No.FUN-AB0018
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_ime"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AB0018
                     DISPLAY g_qryparam.multiret TO sfs08
                     NEXT FIELD sfs08
                WHEN INFIELD(sfs06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfs06
                     NEXT FIELD sfs06
               WHEN INFIELD(sfs33)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_sfs[1].sfs33
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfs33
                  NEXT FIELD sfs33
               WHEN INFIELD(sfs30)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_sfs[1].sfs30
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfs30
                  NEXT FIELD sfs30
               WHEN INFIELD(sfs10)
                  CALL q_ecd(TRUE,TRUE,g_sfs[1].sfs10)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfs10
                  NEXT FIELD sfs10
               WHEN INFIELD(sfs930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfs930
                  NEXT FIELD sfs930
               WHEN INFIELD(sfs36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_mse"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfs36
                  NEXT FIELD sfs36
              #FUN-AB0001 add str ----
               WHEN INFIELD(sfp16) #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfp16
                  NEXT FIELD sfp16
              #FUN-AB0001 add end ---
              #FUN-B70061 --START--
               WHEN INFIELD(sfsiicd029)
                  CALL q_slot(TRUE,TRUE,g_sfs[1].sfsiicd029,'','')                         
                      RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfsiicd029
                  NEXT FIELD sfsiicd029
               #FUN-B70061 --END--
              #FUN-C70014 add begin----------------
              WHEN INFIELD(sfq014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm4"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfq014
                 NEXT FIELD sfq014
                
              WHEN INFIELD(sfs014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm4"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfs014
                 NEXT FIELD sfs014
              #FUN-C70014 add end------------------ 
           END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DIALOG
           
           ON ACTION qbe_select
		          CALL cl_qbe_list() RETURNING lc_qbe_sn
		          CALL cl_qbe_display_condition(lc_qbe_sn)
		           
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION accept
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG 
          
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG      		          
    END DIALOG 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfpuser', 'sfpgrup') 
    #LET g_wc = g_wc CLIPPED,
    #       " AND sfp01[1,",g_doc_len,"] NOT IN (SELECT smy70 FROM smy_file WHERE smy70 IS NOT NULL) "   #CHI-9B0005 mod #TQC-C50227
    IF g_argv1='1' THEN
       LET g_wc = g_wc clipped," AND sfp06 IN ('1','2','3','4','A','C','D')" #FUN-5C0114 add AC  #FUN-C70014 add 'D'
    ELSE
       LET g_wc = g_wc clipped," AND sfp06 IN ('6','7','8','9','B')" #FUN-5C0114 add B
    END IF 
    IF g_argv2 <> ' ' THEN
      #LET g_wc = g_wc clipped," AND sfp06 MATCHES '",g_argv2,"'" #TQC-AB0082 mark
       LET g_wc = g_wc clipped," AND sfp06 = '",g_argv2,"'" #TQC-AB0082
    END IF    
#No.FUN-A40055--end        
   #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF      #TQC-D40077 mark
    IF INT_FLAG THEN RETURN END IF                     #TQC-D40077 add  
 
    LET l_buf = g_wc3 CLIPPED
    LET l_length = LENGTH(g_wc3)
    FOR l_i = 1 TO l_length
      CASE g_wc3.substring(l_i,l_i+4) #MOD-580252 
        WHEN 'sfs01'  LET l_buf[l_i,l_i+4] ='sfe02' #FUN-A60028  #FUN-CB0043
       # WHEN 'sfs01'  LET l_buf[l_i,l_i+4] ='sfe01' #FUN-A60028 #FUN-CB0043
        WHEN 'sfs02'  LET l_buf[l_i,l_i+4] = 'sfe28'
        WHEN 'sfs03'  LET l_buf[l_i,l_i+4] = 'sfe01'
        WHEN 'sfs04'  LET l_buf[l_i,l_i+4] = 'sfe07'
        WHEN 'sfs06'  LET l_buf[l_i,l_i+4] = 'sfe17'
        WHEN 'sfs10'  LET l_buf[l_i,l_i+4] = 'sfe14'
        WHEN 'sfs07'  LET l_buf[l_i,l_i+4] = 'sfe08'
        WHEN 'sfs08'  LET l_buf[l_i,l_i+4] = 'sfe09'
        WHEN 'sfs09'  LET l_buf[l_i,l_i+4] = 'sfe10'
        WHEN 'sfs05'  LET l_buf[l_i,l_i+4] = 'sfe16'
        WHEN 'sfs21'  LET l_buf[l_i,l_i+4] = 'sfe11'
        WHEN 'sfs26'  LET l_buf[l_i,l_i+4] = 'sfe26'    #No.MOD-840123 add
        WHEN 'sfs30'  LET l_buf[l_i,l_i+4] = 'sfe30'
        WHEN 'sfs31'  LET l_buf[l_i,l_i+4] = 'sfe31'
        WHEN 'sfs32'  LET l_buf[l_i,l_i+4] = 'sfe32'
        WHEN 'sfs33'  LET l_buf[l_i,l_i+4] = 'sfe33'
        WHEN 'sfs34'  LET l_buf[l_i,l_i+4] = 'sfe34'
        WHEN 'sfs35'  LET l_buf[l_i,l_i+4] = 'sfe35'   #MOD-8C0222
        WHEN 'sfs930'  LET l_buf[l_i,l_i+4] = 'sfe930' #FUN-670103
        WHEN 'sfs36'   LET l_buf[l_i,l_i+4] = 'sfe36'  #FUN-950088 add   
        WHEN 'sfs37'   LET l_buf[l_i,l_i+4] = 'sfe37'  #FUN-CB0087 add  #FUN-D50017 sfe26->sfe37
        WHEN 'sfs27'   LET l_buf[l_i,l_i+4] = 'sfe27'  #TQC-C30268 
        WHEN 'sfs012'  LET l_buf[l_i,l_i+4] ='sfe012'  #TQC-C30268   
        WHEN 'sfs013'  LET l_buf[l_i,l_i+4] ='sfe013'  #TQC-C30268  
        #FUN-CB0043---begin
        WHEN 'sfs014'  LET l_buf[l_i,l_i+4] ='sfe014'
        WHEN 'sfsud01'  LET l_buf[l_i,l_i+4] = 'sfeud01'
        WHEN 'sfsud02'  LET l_buf[l_i,l_i+4] = 'sfeud02'
        WHEN 'sfsud03'  LET l_buf[l_i,l_i+4] = 'sfeud03'
        WHEN 'sfsud04'  LET l_buf[l_i,l_i+4] = 'sfeud04'
        WHEN 'sfsud05'  LET l_buf[l_i,l_i+4] = 'sfeud05'
        WHEN 'sfsud06'  LET l_buf[l_i,l_i+4] = 'sfeud06'
        WHEN 'sfsud07'  LET l_buf[l_i,l_i+4] = 'sfeud07'
        WHEN 'sfsud08'  LET l_buf[l_i,l_i+4] = 'sfeud08'
        WHEN 'sfsud09'  LET l_buf[l_i,l_i+4] = 'sfeud09'
        WHEN 'sfsud10'  LET l_buf[l_i,l_i+4] = 'sfeud10'
        WHEN 'sfsud11'  LET l_buf[l_i,l_i+4] = 'sfeud11'
        WHEN 'sfsud12'  LET l_buf[l_i,l_i+4] = 'sfeud12'
        WHEN 'sfsud13'  LET l_buf[l_i,l_i+4] = 'sfeud13'
        WHEN 'sfsud14'  LET l_buf[l_i,l_i+4] = 'sfeud14'
        WHEN 'sfsud15'  LET l_buf[l_i,l_i+4] = 'sfeud15'
        #FUN-CB0043---end
       EXIT CASE
      END CASE
    END FOR
    LET l_buf = l_buf CLIPPED
    LET g_wc5 = l_buf CLIPPED   #MOD-A50110 add
  ELSE
    LET g_wc = " sfp01 = '",g_argv3,"'"
    LET g_wc2 = " 1=1"
    LET g_wc3 = " 1=1"
    LET g_wc5 = " 1=1"   #MOD-A50110 add
  END IF
  CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT sfp01 FROM sfp_file",                        #09/10/21 xiaofeizhu
                          " WHERE ", g_wc CLIPPED,
                          " ORDER BY sfp01"
         WHEN g_wc2 <> " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT UNIQUE sfp01 ",                              #09/10/21 xiaofeizhu Add
                          "  FROM sfp_file, sfq_file",
                          " WHERE sfp01 = sfq01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                          " ORDER BY sfp01"
         WHEN g_wc2 = " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE sfp01 ",                              #09/10/21 xiaofeizhu Add
                          "  FROM sfp_file, sfs_file",
                          " WHERE sfp01 = sfs01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " UNION " ,
                          " SELECT UNIQUE sfp01 ",                              #09/10/21 xiaofeizhu Add
                          " FROM sfp_file,sfe_file ",
                          " WHERE sfp01 = sfe02 ",
                          " AND sfp04 ='Y' ",
                          " AND ",g_wc CLIPPED, " AND ",l_buf CLIPPED,
                          " ORDER BY sfp01 "
                          #--
              #FUN-B70061 --START--
              IF g_wc3.getindexof('sfsi',1)>0 THEN                 
                 CALL cl_replace_str(l_buf, "sfsiicd", "sfeiicd") 
                  RETURNING l_buf_rpl
                 LET g_sql = "SELECT UNIQUE sfp01 ",                             
                             "  FROM sfp_file, sfs_file, sfsi_file",
                             " WHERE sfp01 = sfs01",
                             "   AND sfs01 = sfsi01 AND sfs02 = sfsi02",
                             "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                             " UNION " ,
                             " SELECT UNIQUE sfp01 ",                             
                             " FROM sfp_file,sfe_file,sfei_file ",
                             " WHERE sfp01 = sfe02 ",
                             " AND sfe02 = sfei02 AND sfe28 = sfei28 ",
                             " AND sfp04 ='Y' ",
                             " AND ",g_wc CLIPPED, " AND ",l_buf_rpl CLIPPED,
                             " ORDER BY sfp01 "
              END IF 
              #FUN-B70061 --END--
         WHEN g_wc2 <> " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE sfp01 ",                              #09/10/21 xiaofeizhu Add
                          "  FROM sfp_file, sfs_file, sfq_file",
                          " WHERE sfp01 = sfs01 AND sfp01=sfq01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                          " UNION",
                          " SELECT UNIQUE sfp01 ",                              #09/10/21 xiaofeizhu Add
                          " FROM sfp_file,sfe_file,sfq_file ",
                          " WHERE sfp01 = sfe02 AND sfp01 = sfq01 ",
                          " AND sfp04 ='Y' ",
                          " AND ",g_wc CLIPPED,
                          " AND ",g_wc2 CLIPPED," AND ",l_buf CLIPPED,
                          " ORDER BY sfp01 "
                          #--
              #FUN-B70061 --START--
              IF g_wc3.getindexof('sfsi',1)>0 THEN
                 CALL cl_replace_str(l_buf, "sfsiicd", "sfeiicd") 
                  RETURNING l_buf_rpl
                 LET g_sql = "SELECT UNIQUE sfp01 ",                              
                             "  FROM sfp_file, sfs_file, sfq_file, sfsi_file",
                             " WHERE sfp01 = sfs01 AND sfp01=sfq01",
                             "   AND sfs01 = sfsi01 AND sfs02 = sfsi02",
                             "   AND ", g_wc CLIPPED,
                             "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                             " UNION",
                             " SELECT UNIQUE sfp01 ",                              
                             " FROM sfp_file,sfe_file,sfq_file,sfei_file ",
                             " WHERE sfp01 = sfe02 AND sfp01 = sfq01 ",
                             " AND sfe02 = sfei02 AND sfe28 = sfei28 ",
                             " AND sfp04 ='Y' ",
                             " AND ",g_wc CLIPPED,
                             " AND ",g_wc2 CLIPPED," AND ",l_buf_rpl CLIPPED,
                             " ORDER BY sfp01 "
              END IF 
              #FUN-B70061 --END--
    END CASE
    PREPARE i501_prepare FROM g_sql
    DECLARE i501_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i501_prepare
    DECLARE i501_fill_cs CURSOR FOR i501_prepare    #FUN-CB0014 add
    DISPLAY "g_sql",g_sql
    CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE sfp01 FROM sfp_file WHERE ",g_wc CLIPPED
         WHEN g_wc2 != " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE sfp01 FROM sfp_file,sfq_file WHERE ",
                        "sfq01=sfp01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         WHEN g_wc2 = " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE sfp01 ",
                          "  FROM sfp_file, sfs_file",
                          " WHERE sfp01 = sfs01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " UNION " ,
                          " SELECT UNIQUE sfp01 ",
                          " FROM sfp_file,sfe_file ",  #NO:6908
                          " WHERE sfp01 = sfe02 ",
                          " AND sfp04 ='Y' ",
                          " AND ",g_wc CLIPPED, " AND ",l_buf CLIPPED
                          #--
              #FUN-B70061 --START--
              IF g_wc3.getindexof('sfsi',1)>0 THEN
                 CALL cl_replace_str(l_buf, "sfsiicd", "sfeiicd") 
                  RETURNING l_buf_rpl
                 LET g_sql = "SELECT UNIQUE sfp01 ",
                             "  FROM sfp_file, sfs_file, sfsi_file",
                             " WHERE sfp01 = sfs01",
                             "   AND sfs01 = sfsi01 AND sfs02 = sfsi02",
                             "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                             " UNION " ,
                             " SELECT UNIQUE sfp01 ",
                             " FROM sfp_file,sfe_file,sfei_file ",  
                             " WHERE sfp01 = sfe02 ",
                             " AND sfe02 = sfei02 AND sfe28 = sfei28 ",
                             " AND sfp04 ='Y' ",
                             " AND ",g_wc CLIPPED, " AND ",l_buf_rpl CLIPPED
              END IF 
              #FUN-B70061 --END--
         WHEN g_wc2 != " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE sfp01 ",
                          "  FROM sfp_file, sfs_file, sfq_file ",
                          " WHERE sfp01 = sfs01 AND sfp01=sfq01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                          " UNION",
                          " SELECT UNIQUE sfp01 " ,
                          " FROM sfp_file,sfe_file,sfq_file ", #NO:6908
                          " WHERE sfp01 = sfe02 AND sfp01 = sfq01 ",
                          " AND sfp04 ='Y' ",
                          " AND ",g_wc CLIPPED,
                          " AND ",g_wc2 CLIPPED," AND ",l_buf CLIPPED
                          #--
              #FUN-B70061 --START--
              IF g_wc3.getindexof('sfsi',1)>0 THEN
                 CALL cl_replace_str(l_buf, "sfsiicd", "sfeiicd") 
                  RETURNING l_buf_rpl
                 LET g_sql = "SELECT UNIQUE sfp01 ",
                             "  FROM sfp_file, sfs_file, sfq_file, sfsi_file ",
                             " WHERE sfp01 = sfs01 AND sfp01=sfq01",
                             "   AND sfs01 = sfsi01 AND sfs02 = sfsi02",
                             "   AND ", g_wc CLIPPED,
                             "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                             " UNION",
                             " SELECT UNIQUE sfp01 " ,
                             " FROM sfp_file,sfe_file,sfq_file,sfei_file ", 
                             " WHERE sfp01 = sfe02 AND sfp01 = sfq01 ",
                             " AND sfe02 = sfei02 AND sfe28 = sfei28 ",
                             " AND sfp04 ='Y' ",
                             " AND ",g_wc CLIPPED,
                             " AND ",g_wc2 CLIPPED," AND ",l_buf_rpl CLIPPED
              END IF 
              #FUN-B70061 --END--
        OTHERWISE
              LET g_sql="SELECT UNIQUE sfp01 FROM sfp_file WHERE ",g_wc CLIPPED
        EXIT CASE
    END CASE
    PREPARE i501_precount FROM g_sql
    DECLARE i501_count CURSOR FOR i501_precount
END FUNCTION
 
FUNCTION i501_menu()
   DEFINE l_sfs   RECORD LIKE sfs_file.*   #FUN-810038
   DEFINE l_dies  LIKE sfs_file.sfs05   #FUN-810038
   DEFINE l_sfbiicd14 LIKE sfbi_file.sfbiicd14   #FUN-810038
   DEFINE l_r     LIKE type_file.chr1  #FUN-C30302
   DEFINE l_qty   LIKE type_file.num15_3  #FUN-C30302
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_fac   LIKE ima_file.ima31_fac  #TQC-7B0065
   DEFINE l_creator    LIKE type_file.chr1      #FUN-AB0001 add
   DEFINE l_flowuser   LIKE type_file.chr1      #FUN-AB0001 add
   DEFINE l_cnt        LIKE type_file.num5      #FUN-B40082
   DEFINE l_att        LIKE rvbs_file.rvbs09    #No.TQC-B90236 add
   DEFINE l_sfp01_doc  LIKE sfp_file.sfp01      #TQC-C50227
   DEFINE l_ima931     LIKE ima_file.ima931     #DEV-D30026 add
   DEFINE l_ima930     LIKE ima_file.ima930     #DEV-D30026 add
   DEFINE l_mod_flag   LIKE type_file.chr1      #DEV-D30026 add

   LET l_flowuser = "N"                         #FUN-AB0001 add

   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL i501_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL i501_list_fill()
         CALL i501_bp3("G")           
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT sfp_file.* INTO g_sfp.*
              FROM sfp_file
             WHERE sfp01=g_sfp_l[l_ac2].sfp01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL i501_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info,userdefined_field", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("info,userdefined_field", TRUE)
          END IF               
      END IF  
      #FUN-CB0014---add---str--
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i501_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i501_q()
            END IF
         WHEN "delete"   #NO:6908
            IF cl_chk_act_auth() THEN
               CALL i501_r()
            END IF
         WHEN "modify"   #NO:6908
            IF cl_chk_act_auth() THEN
               CALL i501_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i501_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i501_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "sets"   #NO:6908
            IF cl_chk_act_auth() THEN
               #FUN-AB0001  add str ---
               IF g_sfp.sfp15 matches '[Ss]' THEN
                   CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
               ELSE
               #FUN-AB0001  add end ---
                  CALL i501_d()
                  IF g_success='Y' THEN #TQC-DB0051 
                     CALL i501_b()
                  END IF #TQC-DB0051
               END IF    #FUN-AB0001  add  
            END IF
         WHEN "qry_short_inventory"
            CALL i501_t()
         #No.FUN-A40055--begin                  
         #WHEN "qry_sets"
         #   IF cl_chk_act_auth() THEN
         #      CALL i501_bp2('G')
         #   ELSE
         #      LET g_action_choice = NULL
         #   END IF
          #No.FUN-A40055--end
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i501_y_chk()
               IF g_success = "Y" THEN
                  CALL i501_y_upd()
                  IF g_sfp.sfpconf='X' THEN  #FUN-840012
                     LET g_chr='Y' 
                  ELSE 
                     LET g_chr='N' 
                  END IF  
                  DISPLAY BY NAME g_sfp.sfpconf
                  CALL i501_pic() #圖形顯示
                  #FUN-AB0001---add----str--
                  CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*
                  CALL i501_show()
                  #FUN-AB0001---add----end--
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               #TQC-C50227 add begin---- 拆解組合工單不能取消審核
               LET l_cnt=0
               LET l_sfp01_doc = g_sfp.sfp01[1,g_doc_len]
               SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy70 = l_sfp01_doc
               IF l_cnt > 0 THEN 
                  CALL cl_err('','asf-599',1)
               ELSE    
                  #TQC-C50227 add  end------            
                 #CALL i501_w() #FUN-920175
                  CALL i501sub_w(g_sfp.sfp01,g_action_choice,TRUE)   #FUN-920175
                  CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*  #FUN-920175
                  CALL i501_show()  #FUN-920175
               END IF ##TQC-C50227
            END IF
         WHEN "stock_post"
            IF cl_chk_act_auth() THEN
              #DEV-D30026 add str--------------
              LET l_ima930 = ''   #DEV-D50009 add
              LET l_ima931 = ''   #DEV-D50009 add
              SELECT ima931,ima930 INTO l_ima931,l_ima930
                FROM ima_file
              WHERE ima01 = g_sfs[1].sfs04 
             #DEV-D50009 add str--------
              IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF
              IF cl_null(l_ima931) THEN LET l_ima931 = 'N' END IF
             #DEV-D50009 add end--------
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt   #是否有條碼資料
                    FROM tlfb_file
                   WHERE tlfb11 in ('abat021','wmbt021','abat123','wmbt123') AND
                         tlfb07 = g_sfp.sfp01

              #若料號為條碼料件且無條碼掃描資料,則控管不可過帳
              IF l_ima931 <> 'Y' AND l_ima930 = 'Y' AND l_cnt = 0 THEN    
                  CALL cl_err('','asf1044',1)
               ELSE
              #DEV-D30026 add end--------------
                  CALL i501sub_s(g_argv1,g_sfp.sfp01,FALSE,'Y') #FUN-740187
                  IF g_success='Y' THEN
                     CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*
                     CALL i501_show()
                    #FUN-9A0095 mark str---------------------------------------- 
                    #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
                    #   # CALL aws_mescli()
                    #   # 傳入參數: (1)程式代號
                    #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
                    #   #           (3)Key
                    #   IF g_argv2= '1' OR g_argv2='4' THEN 
                    #      CASE aws_mescli('asfi511','insert',g_sfp.sfp01)
                    #         WHEN 0  #無與 MES 整合
                    #              MESSAGE 'INSERT O.K'
                    #         WHEN 1  #呼叫 MES 成功
                    #              MESSAGE 'INSERT O.K, INSERT MES O.K'
                    #         WHEN 2  #呼叫 MES 失敗
                    #      END CASE
                    #   END IF
                    # END IF #TQC-8B0011  ADD
                    #FUN-9A0095 mark end----------------------------------------
                  END IF
               END IF              #DEV-D30026 add
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               #TQC-C50227 add begin---- 拆解組合工單不能取消審核
               LET l_cnt=0
               LET l_sfp01_doc = g_sfp.sfp01[1,g_doc_len]
               SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy70 = l_sfp01_doc
               IF l_cnt > 0 THEN 
                  CALL cl_err('','asf-598',1)
               ELSE
               	  LET l_cnt=0    
               #TQC-C50227 add  end------             
                  #FUN-B40082 --START--
                  IF NOT cl_null(g_sfp.sfp14) THEN
                     SELECT COUNT(*) INTO l_cnt FROM pie_file 
                        WHERE pie01 = g_sfp.sfp14
                     IF l_cnt > 0 THEN                              
                        CALL cl_err('','aim-164' ,1)
                        LET g_action_choice = ''
                        CONTINUE WHILE
                     END IF
                  END IF                                                        
                  #FUN-B40082 --END--
                  CALL i501sub_z(g_argv1,g_sfp.sfp01,g_action_choice,TRUE)   #FUN-920175
                  CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*  #FUN-920175
                  CALL i501_show()  #FUN-920175 mark
               END IF #TQC-C50227   

              #CHI-CB0063---add---S
               IF NOT cl_null(g_sfp.sfp14) THEN
                  SELECT COUNT(*) INTO l_cnt FROM pie_file
                   WHERE pie01 = g_sfp.sfp14
                  IF l_cnt>0 THEN
                    CALL cl_err('','aim-164' ,1)
                    LET g_action_choice = ''
                    CONTINUE WHILE
                 END IF
               END IF
              #CHI-CB0063---add---E
            END IF

         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i501sub_x(g_sfp.sfp01,g_action_choice,TRUE)   #FUN-920175       #CHI-D20010
               CALL i501sub_x(g_sfp.sfp01,g_action_choice,TRUE,1)                   #CHI-D20010
               CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*  #FUN-920175
               CALL i501_show()  #FUN-920175
            END IF
         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL i501sub_x(g_sfp.sfp01,g_action_choice,TRUE)   #FUN-920175       #CHI-D20010
               CALL i501sub_x(g_sfp.sfp01,g_action_choice,TRUE,2)                   #CHI-D20010
               CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*  #FUN-920175
               CALL i501_show()  #FUN-920175
            END IF
         #CHI-D20010--add--end
         WHEN "gen_transfer_note"
            CALL i501_gen()
        #DEV-D30026 add str--------------
        #條碼欠料調整(發料條碼數量分配)
         WHEN "barcode_qty_allot"
            IF g_sfp.sfpconf = 'Y' AND g_sfp.sfp04<>'Y' THEN
               IF s_chkibj(g_sfp.sfp01) THEN
                 #DEV-D30026 add str------------
                  IF cl_confirm('asf1048') THEN
                     LET l_mod_flag = 'Y'
                  ELSE
                     LET l_mod_flag = 'N'
                  END IF
                 #DEV-D30026 add end------------
                  CALL i5101(g_sfp.sfp01,l_mod_flag)  #DEV-D30026 add l_mod_flag
                # CALL i5101(g_sfp.sfp01)
               ELSE
                  CALL cl_err('','asf1043',1)     #無欠料條碼資訊
               END IF
            END IF
        #DEV-D30026 add end--------------
       #@WHEN "單據刻號BIN查詢作業"
         WHEN "aic_s_icdqry"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_sfp.sfp01) THEN
                  CASE 
                    #WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
                     WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                        CALL s_icdqry(-1,g_sfp.sfp01,'',g_sfp.sfp04,'')
                    #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                     WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                        CALL s_icdqry(1,g_sfp.sfp01,'',g_sfp.sfp04,'')
                  END CASE 
               END IF
            END IF
 
       #@WHEN 刻號/BIN號出庫明細
         WHEN "s_icdout"
            IF cl_chk_act_auth() THEN
               #FUN-AB0001  add str ---
               IF g_sfp.sfp15 matches '[Ss]' THEN
                   CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
               ELSE
               #FUN-AB0001  add end ---
                  IF g_rec_b > 0 AND l_ac = 0 THEN LET l_ac = 1 END IF  #FUN-B50106
                  IF (NOT cl_null(g_sfp.sfp01)) AND g_sfp.sfp04 = 'N' AND  #FUN-B50106
                     (NOT cl_null(l_ac)) AND (l_ac > 0) THEN  #FUN-B50106
                     #避免畫面資料是舊的，所以重撈
                     INITIALIZE l_sfs.* TO NULL
                     SELECT * INTO l_sfs.* FROM sfs_file
                      WHERE sfs01 = g_sfp.sfp01 
                        AND sfs02 = g_sfs[l_ac].sfs02
                     LET l_dies = 0 
                    #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
                     CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                               CALL s_icdout(l_sfs.sfs04, l_sfs.sfs07,
                                             l_sfs.sfs08, l_sfs.sfs09,
                                             l_sfs.sfs06, l_sfs.sfs05,
                                             g_sfp.sfp01, l_sfs.sfs02,
                                             g_sfp.sfp02,'N','','','','')
                                    RETURNING l_dies,l_r,l_qty   #FUN-C30302
                                    #FUN-C30302---begin
                                    IF l_r = 'Y' THEN
                                       LET l_qty = s_digqty(l_qty,l_sfs.sfs06) 
                                       LET g_sfs[l_ac].sfs05 = l_qty
                                       LET g_sfs[l_ac].sfs32 = l_qty
                                       UPDATE sfs_file set sfs05 = g_sfs[l_ac].sfs05,
                                                           sfs32 = g_sfs[l_ac].sfs32
                                        WHERE sfs01=g_sfp.sfp01 AND sfs02=g_sfs[l_ac].sfs02
                                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                          LET g_sfs[l_ac].sfs05 =  b_sfs.sfs05
                                          LET g_sfs[l_ac].sfs32 =  b_sfs.sfs32
                                          LET g_success = 'N' 
                                       ELSE 
                                          LET b_sfs.sfs05 = g_sfs[l_ac].sfs05
                                          LET b_sfs.sfs32 = g_sfs[l_ac].sfs32
                                       END IF
                                       DISPLAY BY NAME g_sfs[l_ac].sfs05, g_sfs[l_ac].sfs32
                                    END IF 
                                    #FUN-C30302---end
                               CALL i501_ind_icd_upd_dies(l_dies)
                         #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                          WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                               LET l_sfbiicd14 = ''
                               #取工單上的母體料號
                               SELECT sfbiicd14 INTO l_sfbiicd14 FROM sfbi_file
                                WHERE sfbi01 = l_sfs.sfs03
                  
                               CALL s_icdin(1,l_sfs.sfs04, l_sfs.sfs07,
                                              l_sfs.sfs08, l_sfs.sfs09,
                                              l_sfs.sfs06, l_sfs.sfs05,
                                              g_sfp.sfp01, l_sfs.sfs02,
                                              g_sfp.sfp02, '',
                                              l_sfbiicd14, l_sfs.sfs03, '0')
                                    RETURNING l_dies,l_r,l_qty   #FUN-C30302
                                    #FUN-C30302---begin
                                    IF l_r = 'Y' THEN
                                       LET l_qty = s_digqty(l_qty,l_sfs.sfs06) 
                                       LET g_sfs[l_ac].sfs05 = l_qty
                                       LET g_sfs[l_ac].sfs32 = l_qty
                                       UPDATE sfs_file set sfs05 = g_sfs[l_ac].sfs05,
                                                           sfs32 = g_sfs[l_ac].sfs32
                                        WHERE sfs01=g_sfp.sfp01 AND sfs02=g_sfs[l_ac].sfs02
                                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                          LET g_sfs[l_ac].sfs05 =  b_sfs.sfs05
                                          LET g_sfs[l_ac].sfs32 =  b_sfs.sfs32
                                          LET g_success = 'N' 
                                       ELSE 
                                          LET b_sfs.sfs05 = g_sfs[l_ac].sfs05
                                          LET b_sfs.sfs32 = g_sfs[l_ac].sfs32
                                       END IF
                                       DISPLAY BY NAME g_sfs[l_ac].sfs05, g_sfs[l_ac].sfs32
                                    END IF 
                                    #FUN-C30302---end
                               CALL i501_ind_icd_upd_dies(l_dies)
                     END CASE
                  END IF
               END IF    #FUN-AB0001 add
            END IF
 
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfq),base.TypeInfo.create(g_sfs),'')
               END IF
            #FUN-CB0014---add---str---
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfp_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---
##
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sfp.sfp01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfp01"
                 LET g_doc.value1 = g_sfp.sfp01
                 CALL cl_doc()
               END IF
         END IF
                           
        WHEN "qry_lot"
           #MOD-B60079 add
           IF cl_null(l_ac) OR l_ac=0 THEN
              CALL cl_err('','apm-140',0)
           ELSE
           #MOD-B60079 add--end
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_sfs[l_ac].sfs04
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 LET g_success = 'Y'              #CHI-A10016
                 BEGIN WORK                       #CHI-A10016
                 SELECT img09 INTO g_img09
                   FROM img_file
                  WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                    AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
                 CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09) 
                      RETURNING l_i,l_fac
                 IF l_i = 1 THEN LET l_fac = 1 END IF
#No.TQC-B90236----------------add---------begin
                 IF g_sfp.sfp06 MATCHES '[6789B]' THEN
                    LET l_att = 1
                 ELSE
                    LET l_att = -1
                 END IF
#No.TQC-B90236----------------add---------end
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
                  CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,   #No.TQC-B90236 modify s_lotout->s_mod_lot
                                g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                g_sfs[l_ac].sfs06,g_img09,l_fac,
                                g_sfs[l_ac].sfs05,'','QRY',l_att)#CHI-9A0022 add '' #No.TQC-B90236 add l_att 
                         RETURNING l_r,g_qty 
 #MOD-C10100 --end--
#TQC-C10033 --unmark
                #-CHI-A10016-add-
                 IF g_success = "Y" THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK    
                 END IF
                #-CHI-A10016-end-
              #MOD-B60079 add
              ELSE
                 CALL cl_err(g_sfs[l_ac].sfs04,'aim1106',0)
              #MOD-B60079 add--end
              END IF
           END IF #MOD-B60079 add

#TQC-AC0197 --------------------------------Begin----------------------------------
         WHEN "warahouse_modify"
            IF cl_chk_act_auth() THEN
               CALL i501_wm_b()
            END IF
#TQC-AC0197 --------------------------------End------------------------------------
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfq),base.TypeInfo.create(g_sfs),'')
            END IF

         #FUN-AB0001---add----str---
         WHEN "approval_status"               #簽核狀況
           IF cl_chk_act_auth() THEN          #DISPLAY ONLY
              IF aws_condition2() THEN
                 CALL aws_efstat2()
              END IF
           END IF

         WHEN "easyflow_approval"             #EasyFlow送簽
           IF cl_chk_act_auth() THEN
             #FUN-C20027 add str---
              SELECT * INTO g_sfp.* FROM sfp_file
               WHERE sfp01 = g_sfp.sfp01
              CALL i501_show()
              CALL i501_b_fill(' 1=1')
             #FUN-C20027 add end---
              CALL i501_ef()
              CALL i501_show()  #FUN-C20027 add
           END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL i501sub_y_upd(g_sfp.sfp01,g_action_choice,FALSE) #CALL 原確認的 update 段
                      RETURNING g_sfp.*
                 CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*
                 CALL i501_show()
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN #執行 EF 簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN    #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                       IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                             CALL i501_q()
                             #傳入簽核模式時不應執行的 action 清單
                             CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,    #CHI-D20010 add--undo_void                                                        confirm, undo_confirm, stock_post, undo_post, easyflow_approval,                                                         sets, gen_transfer_note, reproduce, regen_detail, s_icdout, exporttoexcel, modi_lot, warahouse_modify, barcode_qty_allot")  #DEV-D30026 add barcode_qty_allot   
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
                IF aws_efapp_formapproval() THEN   #執行 EF 簽核
                   IF l_creator = "Y" THEN         #當退回填表人時
                      LET g_sfp.sfp15 = 'R'        #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_sfp.sfp15
                   END IF
                   IF cl_confirm('aws-081') THEN #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN   #取得下一筆簽核單號
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                          IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                                CALL i501_q()
                                #傳入簽核模式時不應執行的 action 清單
                                CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,    #CHI-D20010--ADD--undo_void                                                           confirm, undo_confirm, stock_post, undo_post, easyflow_approval,                                                            sets, gen_transfer_note, reproduce, regen_detail, s_icdout, exporttoexcel, modi_lot, warahouse_modify, barcode_qty_allot")  #DEV-D30026 add barcode_qty_allot  
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
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
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
         #FUN-AB0001---add----end---
      END CASE
 
 END WHILE
 CLOSE i501_cs
 
END FUNCTION

#TQC-AC0197 ---------------------------Begin------------------------------------------
FUNCTION i501_wm_b()
   DEFINE l_n   LIKE type_file.num5
   DEFINE l_sfp04      LIKE sfp_file.sfp04        #MOD-B30148
   DEFINE l_sfpconf    LIKE sfp_file.sfpconf      #MOD-B30148
   IF cl_null(g_sfp.sfp01) THEN
      RETURN
   END IF
#MOD-B30148 -----------------------Begin--------------------
#  IF g_sfp.sfp06 NOT MATCHES '[1368]' THEN
#     RETURN
#  END IF
#MOD-B30148 -----------------------End-----------------------
   IF g_sfp.sfpconf = 'N' THEN
      CALL cl_err(g_sfp.sfp01,'asf-309',0)
      RETURN
   END IF
   IF g_sfp.sfp04 = 'Y' THEN
      CALL cl_err(g_sfp.sfp01,'asf-313',0) 
      RETURN
   END IF
   SELECT sfp04,sfpconf INTO l_sfp04,l_sfpconf FROM sfp_file
    WHERE sfp01 = g_sfp.sfp01
   IF (l_sfp04 = 'N' AND l_sfpconf = 'Y') THEN
      CALL i501_b()
   ELSE
      CALL cl_err(g_sfp.sfp01,'asf-315',0)
      RETURN
   END IF      
#MOD-B30148 ------------------Begin------------------
#  IF g_sfp.sfp06 = '8' OR g_sfp.sfp06 = '3' THEN
#     CALL i501_b()
#  END IF
#   IF g_sfp.sfp06 = '1' OR g_sfp.sfp06 = '6' THEN
#      IF g_sma.sma129 <> 'N' THEN
#         CALL cl_err(g_sfp.sfp01,'asf-314',0)
#         RETURN
#      END IF
#      SELECT COUNT(*) INTO l_n FROM sfq_file
#       WHERE sfq01 = g_sfp.sfp01
#         AND sfq03 = 0
#      IF l_n = 0 THEN 
#         CALL cl_err(g_sfp.sfp01,'asf-315',0)
#         RETURN
#      END IF
#      CALL i501_b()
#   END IF
#  IF g_sma.sma129 <> 'N' THEN
#     CALL cl_err(g_sfp.sfp01,'asf-314',0)
#     RETURN
#  END IF
#  SELECT sfp04,sfpconf INTO l_sfp04,l_sfpconf FROM sfp_file
#   WHERE sfp01 = g_sfp.sfp01
#  IF (l_sfp04 = 'N' AND l_sfpconf = 'Y') THEN
#     CALL i501_b()
#  ELSE
#     CALL cl_err(g_sfp.sfp01,'asf-315',0)
#     RETURN
#  END IF      
#MOD-B30148 -----------------------End------------------------
END FUNCTION
#TQC-AC0197 ---------------------------End-------------------------------------------- 


FUNCTION i501_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550052  #No.FUN-680121 SMALLINT
    DEFINE l_cnt1      LIKE type_file.num5   #TQC-9B0134 add
    IF s_shut(0) THEN RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_sfq.clear()
    CALL g_sfs.clear()
    INITIALIZE g_sfp.* TO NULL
#Mark No:TQC-AC0125
#&ifdef SLK    
#    LET l_ecm.ecm04 = ''    #No.FUN-870117
#&endif
#End Mark TQC-AC0125
    LET g_sfp_o.* = g_sfp.*
    LET g_sfp_t.* = g_sfp.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sfp.sfp02  =g_today
        LET g_sfp.sfp03  =g_today   #No.B182 010502 add
        LET g_sfp.sfp04  ='N'
        LET g_sfp.sfpconf='N' #FUN-660106
        LET g_sfp.sfp05  ='N'
        LET g_sfp.sfp09  ='N'
        LET g_sfp.sfpuser=g_user  #NO:6908
        LET g_sfp.sfporiu = g_user #FUN-980030
        LET g_sfp.sfporig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sfp.sfpgrup=g_grup  #NO:6908
        LET g_sfp.sfpdate=g_today #NO:6908
        LET g_sfp.sfp07  =g_grup  #FUN-670103
       #FUN-AB0001--add---str--
        LET g_sfp.sfp15 = '0'     #開立  
        LET g_sfp.sfpmksg = "N"
        LET g_sfp.sfp16 = g_user
        CALL i501_sfp16('d')
       #FUN-AB0001--add---end-- 
        LET g_sfp.sfpplant = g_plant #FUN-980008 add
        LET g_sfp.sfplegal = g_legal #FUN-980008 add
 
        IF g_argv2<>' ' THEN LET g_sfp.sfp06 = g_argv2  END IF
        CALL i501_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_sfp.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_sfp.sfp01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK     #No:7829
      CALL s_auto_assign_no("asf",g_sfp.sfp01,g_sfp.sfp02,"","sfp_file","sfp01","","","")
        RETURNING li_result,g_sfp.sfp01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sfp.sfp01,g_sfp.sfp07 #FUN-670103
 
 
        IF cl_null(g_sfp.sfp03) THEN
           LET g_sfp.sfp03  =g_today   #No.B182 010502 add
           DISPLAY BY NAME g_sfp.sfp03
        END IF
      #20110518過單時，正式區尚未有此欄位，故先mark
      #FUN-AC0074 -----------Begin------------
      #  IF cl_null(g_sfp.sfp15) THEN
      #     LET g_sfp.sfp15 = '0'
      #  END IF
      #  IF cl_null(g_sfp.sfpmksg) THEN
      #     LET g_sfp.sfpmksg = 'N'
      #  END IF
      #FUN-AC0074 -----------End--------------
        INSERT INTO sfp_file VALUES (g_sfp.*)
        IF STATUS THEN
           CALL cl_err3("ins","sfp_file",g_sfp.sfp01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_sfp.sfp01,'I')
 
        LET g_sfp_t.* = g_sfp.*
        LET g_rec_d = 0
        CALL g_sfq.clear()
        CALL i501_d()                   #輸入單身-sfq
 
        IF g_success = "N" THEN
           EXIT WHILE
        END IF
 
        LET g_rec_b =0
        CALL g_sfs.clear()
        SELECT COUNT(*) INTO l_cnt1 FROM sfs_file
         WHERE sfs01 = g_sfp.sfp01
        IF g_sfp.sfp06 MATCHES '[136ABD]' AND l_cnt1 = 0 THEN CALL i501_g_b() END IF   #FUN-5B0037 #FUN-5C0114 add 'AB'  #FUN-C70014 add 'D'
        CALL i501_b_fill(" 1=1")
   #FUN-A20048 --begin #其他發料時，按以下處理
        IF g_sfp.sfp06 MATCHES '[24]' AND l_cnt1 = 0 THEN 
           CALL i501_g_b_1()
        ELSE 
           CALL i501_b()  #輸入單身-sfs
        END IF 
   #FUN-A20048  --end 
        IF g_cnt>0 AND g_smy.smyprint='Y' THEN CALL i501_out() END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i501_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sfp.sfp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfp.* FROM sfp_file WHERE sfp01=g_sfp.sfp01
    IF g_sfp.sfpconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF #FUN-660106
    IF g_sfp.sfp04 = 'Y' THEN CALL cl_err('','mfg0175',1) RETURN END IF
    IF g_sfp.sfpconf = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF #FUN-660106
    #FUN-AB0001  add str ---
    IF g_sfp.sfp15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_sfp.sfpconf='Y' AND g_sfp.sfp15 = "1" AND g_sfp.sfpmksg = "Y"  THEN
       CALL cl_err('','mfg3168',0)   #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-AB0001  add end ---

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sfp_o.* = g_sfp.*
 
    BEGIN WORK
 
    OPEN i501_cl USING g_sfp.sfp01                 #09/10/21 xiaofeizhu Add
    IF STATUS THEN
       CALL cl_err("OPEN i501_cl:", STATUS, 1)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i501_cl INTO g_sfp.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i501_cl ROLLBACK WORK RETURN
    END IF
    CALL i501_show()
    WHILE TRUE
        LET g_sfp.sfpmodu=g_user              #NO:6908
        LET g_sfp.sfpdate=g_today             #NO:6908
        CALL i501_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sfp.*=g_sfp_t.*
            CALL i501_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_sfp.sfp15 = '0'                 #FUN-AB0001 add

        UPDATE sfp_file SET * = g_sfp.* WHERE sfp01 = g_sfp_o.sfp01      #09/10/21 xiaofeizhu Add #No.TQC-9A0130 mod
        IF STATUS THEN 
           CALL cl_err3("upd","sfp_file",g_sfp_t.sfp01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE END IF
        IF g_sfp.sfp01 != g_sfp_t.sfp01 THEN CALL i501_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i501_cl
    COMMIT WORK
    CALL i501_show()                          #顯示最新資料   #FUN-AB0001 add
    CALL cl_flow_notify(g_sfp.sfp01,'U')
 
END FUNCTION
 
FUNCTION i501_chkkey()
    UPDATE sfs_file SET sfs01=g_sfp.sfp01 WHERE sfs01=g_sfp_t.sfp01
    IF STATUS THEN
       CALL cl_err3("upd","sfs_file",g_sfp_t.sfp01,"",STATUS,"","upd sfs01",1)  #No.FUN-660128
       LET g_sfp.*=g_sfp_t.* CALL i501_show() ROLLBACK WORK RETURN
    END IF
   #FUN-B70061 --START--   
   UPDATE sfsi_file SET sfsi01=g_sfp.sfp01 WHERE sfsi01=g_sfp_t.sfp01
   IF STATUS THEN
      CALL cl_err3("upd","sfsi_file",g_sfp_t.sfp01,"",STATUS,"","upd sfsi01",1) 
      LET g_sfp.*=g_sfp_t.* CALL i501_show() ROLLBACK WORK RETURN      
   END IF 
   #FUN-B70061 --END--
    UPDATE sfq_file SET sfq01=g_sfp.sfp01 WHERE sfq01=g_sfp_t.sfp01
    IF STATUS THEN
       CALL cl_err3("upd","sfq_file",g_sfp_t.sfp01,"",STATUS,"","upd sfq01",1)  #No.FUN-660128
       LET g_sfp.*=g_sfp_t.* CALL i501_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION i501_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5                #No.FUN-550052  #No.FUN-680121 SMALLINT
  DEFINE l_azf03         LIKE azf_file.azf03   #FUN-630084
  DEFINE l_azfacti       LIKE azf_file.azfacti #FUN-630084
  DEFINE l_n             LIKE type_file.num5   #No.FUN-870117
  DEFINE l_azf09         LIKE azf_file.azf09   #No.FUN-930106
  DEFINE l_slip          LIKE smy_file.smyslip #No.FUN-980038
  DEFINE l_sfp06         LIKE sfp_file.sfp06   #No.FUN-980038
  DEFINE l_smy72         LIKE smy_file.smy72   #No.MOD-9C0180
  DEFINE l_count         LIKE type_file.num5   #No.FUN-A90035 
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_sfp.sfporiu,g_sfp.sfporig,
        g_sfp.sfp01,g_sfp.sfp02,g_sfp.sfp03,g_sfp.sfp06,g_sfp.sfp07,
        g_sfp.sfp08,
        g_sfp.sfp16,                        #FUN-AB0001 add
#Mark No:TQC-AC0125
#&ifdef SLK
#        l_ecm.ecm04,                       #No.FUN-870117
#&endif
#End Mark No:TQC-AC0125
        g_sfp.sfp05,g_sfp.sfpconf,          #FUN-660106 add g_sfp.sfpconf
        g_sfp.sfpmksg,                      #FUN-AB0001 add
        g_sfp.sfp04,g_sfp.sfp09, 
        g_sfp.sfp11,                        #MOD-490204  ##FUN-630084 add sfp11
        g_sfp.sfp15,                        #FUN-AB0001 add    
        g_sfp.sfpuser,g_sfp.sfpgrup,    #NO:6908
        g_sfp.sfpmodu,g_sfp.sfpdate                 #NO:6908
        ,g_sfp.sfpud01,g_sfp.sfpud02,g_sfp.sfpud03,g_sfp.sfpud04,
        g_sfp.sfpud05,g_sfp.sfpud06,g_sfp.sfpud07,g_sfp.sfpud08,
        g_sfp.sfpud09,g_sfp.sfpud10,g_sfp.sfpud11,g_sfp.sfpud12,
        g_sfp.sfpud13,g_sfp.sfpud14,g_sfp.sfpud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i501_set_entry(p_cmd)
            CALL i501_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("sfp01")
 
        AFTER FIELD sfp01
            IF NOT cl_null(g_sfp.sfp01) THEN
               CASE WHEN g_argv1 = "1" LET g_chr='3'
                    WHEN g_argv1 = "2" LET g_chr='4'
               END CASE
               IF g_sfp.sfp01 != g_sfp_t.sfp01 OR g_sfp_t.sfp01 IS NULL THEN
            CALL s_check_no("asf",g_sfp.sfp01,g_sfp_t.sfp01,g_chr,"sfp_file","sfp01","")
            RETURNING li_result,g_sfp.sfp01
            DISPLAY BY NAME g_sfp.sfp01
            IF (NOT li_result) THEN
               LET g_sfp.sfp01=g_sfp_o.sfp01
               NEXT FIELD sfp01
            END IF
            #FUN-AB0001 add str ---
            IF g_sfp_t.sfp01 IS NULL OR
               (g_sfp.sfp01 != g_sfp_t.sfp01 ) THEN
               LET g_sfp.sfpmksg = g_smy.smyapr
               LET g_sfp.sfp15 = '0'
               DISPLAY BY NAME g_sfp.sfpmksg   #簽核否
               DISPLAY BY NAME g_sfp.sfp15     #簽核狀況
            END IF
            #FUN-AB0001 add end ---
            CALL i501_sfp01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfp.sfp01,g_errno,0)
               LET g_sfp.sfp01 = g_sfp_t.sfp01
               DISPLAY BY NAME g_sfp.sfp01
               NEXT FIELD sfp01
            END IF
               END IF
               #FUN-CB0087--add--str--
               IF NOT i501_sfs37_chkall() THEN
                  LET g_sfp.sfp01 = g_sfp_t.sfp01
                  NEXT FIELD sfp01
               END IF
               #FUN-CB0087--add--end--
            END IF
            IF cl_null(g_sfp_t.sfp01) THEN
               CALL s_get_doc_no(g_sfp.sfp01) RETURNING l_slip                                                                 
                    SELECT smy72 INTO l_sfp06 FROM smy_file                                                                     
                     WHERE smyslip = l_slip                                                                                         
               IF cl_null(l_sfp06) THEN
                  LET l_sfp06 = ' '
               END IF
               IF l_sfp06 <> g_sfp.sfp06 THEN
                  CALL cl_err('','asm-145',1)
                  NEXT FIELD sfp01
               END IF
            END IF
 
        AFTER FIELD sfp02
            IF NOT cl_null(g_sfp.sfp02) THEN
              #日期的控管由扣帳日期處理
	       IF g_sfp.sfp03 IS NULL THEN
                  LET g_sfp.sfp03 = g_sfp.sfp02
                  DISPLAY By NAME g_sfp.sfp03
               END IF
            END IF
 
        AFTER FIELD sfp03
            IF NOT cl_null(g_sfp.sfp03) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_sfp.sfp03 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
	       END IF
               CALL s_yp(g_sfp.sfp03) RETURNING g_yy,g_mm
               IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
               END IF
            END IF
 
        AFTER FIELD sfp06
            IF NOT cl_null(g_sfp.sfp06) THEN
              #IF g_argv1='1' AND g_sfp.sfp06 NOT MATCHES '[1234AC]' THEN #FUN-5C0114 add AC
               IF g_argv1='1' AND g_sfp.sfp06 NOT MATCHES '[1234ACD]' THEN #FUN-C70014 add D
                  NEXT FIELD sfp06
               END IF
               IF g_argv1='2' AND g_sfp.sfp06 NOT MATCHES '[6789B]' THEN #FUN-5C0114 add B
                  NEXT FIELD sfp06
               END IF
               
            END IF
 
        AFTER FIELD sfp07
            IF NOT cl_null(g_sfp.sfp07) THEN
               LET g_buf=''
               SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfp.sfp07
                  AND gemacti='Y'   #NO:6950
               IF STATUS THEN
                  SELECT pmc03 INTO g_buf FROM pmc_file 
                   WHERE pmc01= g_sfp.sfp07 AND pmcacti='Y'
                 IF STATUS THEN
                 #CALL cl_err3("sel","pmc_file",g_sfp.sfp07,"",STATUS,"","select pmc",1)  #CHI-680019           #No.TQC-A50033
                  CALL cl_err(g_sfp.sfp07,'asf-683',1)  #No.TQC-A50033
                  LET g_sfp.sfp07=g_sfp_t.sfp07         #No.TQC-A50033 
                  NEXT FIELD sfp07
                 END IF #CHI-680019
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT i501_sfs37_chkall() THEN 
                  LET g_sfp.sfp07 = g_sfp_t.sfp07
                  NEXT FIELD sfp07 
               END IF  
               #FUN-CB0087--add--end--
               DISPLAY g_buf TO gem02  #MOD-480346
            END IF
#Mark No:TQC-AC0125
#&ifdef SLK        
#                       
#       AFTER FIELD ecm04
#            IF NOT cl_null(l_ecm.ecm04) THEN
#               SELECT count(*) INTO l_n FROM sfa_file,sfb_file 
#                WHERE sfb01=sfa01
#                  AND sfa08 = l_ecm.ecm04
#                  AND sfb85 = g_sfp.sfp08                      
#               IF l_n=0 THEN
#                  CALL cl_err(l_ecm.ecm04,'asf-402',0)  
#                  NEXT FIELD ecm04
#               END IF
#            END IF
#       #No.FUN-870117  --end--
#&endif       
#End Mark No:TQC-AC0125
        AFTER FIELD sfp08
            IF NOT cl_null(g_sfp.sfp08) THEN
              #FUN-A90035 -----------------add start----------------
               SELECT count(*) INTO l_count FROM sfd_file WHERE sfd01 = g_sfp.sfp08 AND sfdconf = 'Y' 
               IF cl_null(l_count) OR l_count = 0  THEN
                  CALL cl_err('','asf-772',0)
                  NEXT FIELD sfp08
               END IF  
              #FUN-A90035 ----------------add end------------------
               SELECT sfc02 INTO g_buf FROM sfc_file WHERE sfc01=g_sfp.sfp08
               IF STATUS THEN
                  CALL cl_err3("sel","sfc_file",g_sfp.sfp08,"",STATUS,"","select sfc",1)  #No.FUN-660128
                  NEXT FIELD sfp08
               END IF
            END IF

        #FUN-AB0001 add str ------
        AFTER FIELD sfp16  #申請人
            IF NOT cl_null(g_sfp.sfp16) THEN
               CALL i501_sfp16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sfp.sfp16,g_errno,0)
                  LET g_sfp.sfp16 = g_sfp_t.sfp16
                  DISPLAY BY NAME g_sfp.sfp16
                  NEXT FIELD sfp16
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT i501_sfs37_chkall() THEN 
                  LET g_sfp.sfp16 = g_sfp_t.sfp16
                  NEXT FIELD sfp16
               END IF  
               #FUN-CB0087--add--end--
            END IF
            LET g_sfp_o.sfp16 = g_sfp.sfp16
        #FUN-AB0001 add end ---
 
        AFTER INPUT 
           LET g_sfp.sfpuser = s_get_data_owner("sfp_file") #FUN-C10039
           LET g_sfp.sfpgrup = s_get_data_group("sfp_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT      
         END IF
          #日期的控管由扣帳日期處理
           
           IF NOT cl_null(g_sfp.sfp03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfp.sfp03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
              END IF
              CALL s_yp(g_sfp.sfp03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
              END IF
           END IF
           #TQC-B60034--add--add--  
           #申請人
           IF NOT cl_null(g_sfp.sfp16) THEN
               CALL i501_sfp16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sfp.sfp16,g_errno,0)
                  NEXT FIELD sfp16
               END IF
            END IF
            #TQC-B60034--add--end--

       AFTER FIELD sfp11
          LET l_azf03=''
          IF NOT cl_null(g_sfp.sfp11) THEN
             IF g_sma.sma79='Y' THEN       #使用保稅系統
                SELECT azf03 INTO l_azf03 FROM azf_file
                    WHERE azf01=g_sfp.sfp11 AND azf02='A'
                 IF STATUS THEN
                   CALL cl_err3("sel","azf_file",g_sfp.sfp11,"",STATUS,"","select azf",1)  #No.FUN-660128
                   NEXT FIELD sfp11
                 END IF
             ELSE
                 SELECT azf03 INTO l_azf03 FROM azf_file
                    WHERE azf01=g_sfp.sfp11 AND azf02='2'
                 IF STATUS THEN
                    CALL cl_err3("sel","azf_file",g_sfp.sfp11,"",STATUS,"","select azf",1)  #No.FUN-660128
                    NEXT FIELD sfp11
                 END IF
                 IF g_argv1='1' THEN                                                                                                    
                    SELECT azf09 INTO l_azf09 FROM azf_file                                                                             
                     WHERE azf01 = g_sfp.sfp11                                                                                          
                       AND azf02 ='2'                                                                                                   
                    IF l_azf09 !='C' THEN                                                                                               
                       CALL cl_err('','aoo-411',1)                                                                                      
                       NEXT FIELD sfp11                                                                                                 
                    END IF                                                                                                              
                 ELSE                                                                                                                   
                    SELECT azf09 INTO l_azf09 FROM azf_file                                                                             
                     WHERE azf01 = g_sfp.sfp11                                                                                          
                       AND azf02 ='2'                                                                                                   
                    IF l_azf09 !='E' THEN                                                                                               
                       CALL cl_err('','aoo-413',1)                                                                                      
                       NEXT FIELD sfp11                                                                                                 
                    END IF                                                                                                              
                 END IF                                                                                                                 
             END IF
             SELECT azfacti INTO l_azfacti FROM azf_file 
                 WHERE azf01 = g_sfp.sfp11
                   AND azf02 ='2'                         #No.FUN-930106
             IF l_azfacti <> 'Y' THEN
#                CALL cl_err('','apy-541',1)     #CHI-B40058
                CALL cl_err('','aim-163',1)      #CHI-B40058
                NEXT FIELD sfp11
             END IF
          END IF
          DISPLAY l_azf03 TO FORMONLY.azf03
        AFTER FIELD sfpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840042     ----end----
 
        ON ACTION controlp
          CASE WHEN INFIELD(sfp01) #查詢單据
                    LET g_t1=s_get_doc_no(g_sfp.sfp01)     #No.FUN-550052
		    CASE WHEN g_argv1 = "1" LET g_chr='3'
                            CASE WHEN g_argv2 = "1" LET l_smy72='1'
                                 WHEN g_argv2 = "2" LET l_smy72='2'
                                 WHEN g_argv2 = "3" LET l_smy72='3'
                                 WHEN g_argv2 = "4" LET l_smy72='4'
                                 WHEN g_argv2 = "A" LET l_smy72='A'
                                 WHEN g_argv2 = "C" LET l_smy72='C'
                                 WHEN g_argv2 = "D" LET l_smy72='D'  #FUN-C70014
                            END CASE
		         WHEN g_argv1 = "2" LET g_chr='4'
                            CASE WHEN g_argv2 = "6" LET l_smy72='6'
                                 WHEN g_argv2 = "7" LET l_smy72='7'
                                 WHEN g_argv2 = "8" LET l_smy72='8'
                                 WHEN g_argv2 = "9" LET l_smy72='9'
                                 WHEN g_argv2 = "B" LET l_smy72='B'
                            END CASE
		    END CASE
                    LET g_sfp.sfp06 = l_smy72      #MOD-A30031 add
                    DISPLAY BY NAME g_sfp.sfp06    #MOD-A30031 add
                    LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"   #FUN-9B0144
                    IF NOT cl_null(l_smy72) THEN   #MOD-A30031 add
                       LET g_sql = g_sql," AND smy72='",l_smy72,"'"  #MOD-9C0180
                    END IF                         #MOD-A30031 add
                    CALL smy_qry_set_par_where(g_sql)
                    CALL q_smy( FALSE, TRUE,g_t1,'ASF',g_chr) RETURNING g_t1  #TQC-670008
                    LET g_sfp.sfp01 = g_t1                 #No.FUN-550052
                    DISPLAY BY NAME g_sfp.sfp01
                    NEXT FIELD sfp01
               WHEN INFIELD(sfp07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_sfp.sfp07
                    CALL cl_create_qry() RETURNING g_sfp.sfp07
                    DISPLAY BY NAME g_sfp.sfp07
                    NEXT FIELD sfp07
#Mark No:TQC-AC0125
#&ifdef SLK                    
#                WHEN INFIELD(ecm04)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ecm04"
#                    LET g_qryparam.default1 = l_ecm.ecm04
#                    LET g_qryparam.arg1 = g_sfp.sfp08 
#                    CALL cl_create_qry() RETURNING l_ecm.ecm04
#                    DISPLAY BY NAME l_ecm.ecm04
#                    NEXT FIELD ecm04 
#&endif                  
#End Mark No:TQC-AC0125
               WHEN INFIELD(sfp08)   #料表批號
                    CALL cl_init_qry_var()
                  # LET g_qryparam.form ="q_sfc"    #FUN-A90035 mark
                    LET g_qryparam.form ="q_sfd"    #FUN-A90035
                    LET g_qryparam.default1 = g_sfp.sfp08
                    CALL cl_create_qry() RETURNING g_sfp.sfp08
                    DISPLAY BY NAME g_sfp.sfp08
                    NEXT FIELD sfp08
               WHEN INFIELD(sfp11)  #理由
                    IF g_sma.sma79='Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf"
                       LET g_qryparam.default1 = g_sfp.sfp11
                       LET g_qryparam.arg1 = "A"
                       CALL cl_create_qry() RETURNING g_sfp.sfp11
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf01a"                #No.FUN-930106
                       LET g_qryparam.default1 = g_sfp.sfp11
                       IF g_argv1='1' THEN   
                          LET g_qryparam.arg1 = "C"  
                       ELSE            
                          LET g_qryparam.arg1 = "E"  
                       END IF         
                       CALL cl_create_qry() RETURNING g_sfp.sfp11
                    END IF
                     DISPLAY BY NAME g_sfp.sfp11
                    NEXT FIELD sfp11

               #FUN-AB0001 add str ----
               WHEN INFIELD(sfp16) #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_sfp.sfp16
                  DISPLAY BY NAME g_sfp.sfp16
                  NEXT FIELD sfp16
               #FUN-AB0001 add end ----
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION i501_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfp01",TRUE)
    END IF
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfp06",TRUE)
    END IF
END FUNCTION
 
FUNCTION i501_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("sfp01",FALSE)
    END IF
 
    IF INFIELD(sfp06) OR (NOT g_before_input_done) THEN
       IF g_argv2<>' ' OR p_cmd = 'u' THEN
          CALL cl_set_comp_entry("sfp06",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i501_q()
  DEFINE  l_sfp01     LIKE sfp_file.sfp01


    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfp.* to NULL              #No.FUN-6A0166
   #MESSAGE ""                              #FUN-AB0001 mark
    CALL cl_msg("")                         #FUN-AB0001 add

    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    INITIALIZE g_sfp.* to NULL              #No:9485
    CALL i501_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sfp.* TO NULL RETURN
    END IF
    
   #MESSAGE " SEARCHING ! "                 #FUN-AB0001 mark
    CALL cl_msg(" SEARCHING ! ")            #FUN-AB0001 add

    OPEN i501_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sfp.* TO NULL
    ELSE
        LET g_row_count=0
        FOREACH i501_count INTO l_sfp01
            LET g_row_count=g_row_count +1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
 
        CALL i501_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE " SEARCHING ! "                  #FUN-AB0001 mark
    CALL cl_msg(" SEARCHING ! ")             #FUN-AB0001 add
END FUNCTION
 
FUNCTION i501_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i501_cs INTO g_sfp.sfp01                 #09/10/21 xiaofeizhu Add 
        WHEN 'P' FETCH PREVIOUS i501_cs INTO g_sfp.sfp01                 #09/10/21 xiaofeizhu Add
        WHEN 'F' FETCH FIRST    i501_cs INTO g_sfp.sfp01                 #09/10/21 xiaofeizhu Add
        WHEN 'L' FETCH LAST     i501_cs INTO g_sfp.sfp01                 #09/10/21 xiaofeizhu Add
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i501_cs INTO g_sfp.sfp01               #09/10/21 xiaofeizhu Add
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_sfp.* TO NULL
        CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_sfp.* FROM sfp_file WHERE sfp01 = g_sfp.sfp01           #09/10/21 xiaofeizhu Add

    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfp_file",g_sfp.sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_sfp.* TO NULL
    ELSE
       LET g_data_owner = g_sfp.sfpuser      #FUN-4C0035
       LET g_data_group = g_sfp.sfpgrup      #FUN-4C0035
       LET g_data_plant = g_sfp.sfpplant #FUN-980030
       CALL i501_show()
    END IF
 
END FUNCTION
 
FUNCTION i501_show()
    DEFINE l_gem02 LIKE gem_file.gem02
    DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
    DEFINE l_azf03 LIKE azf_file.azf03 #FUN-630084
 
    LET g_sfp_t.* = g_sfp.*                #保存單頭舊值
    DISPLAY BY NAME g_sfp.sfporiu,g_sfp.sfporig,
        g_sfp.sfp01,g_sfp.sfp02,
        g_sfp.sfp03,g_sfp.sfp05,g_sfp.sfp06,
        g_sfp.sfp07,g_sfp.sfp08,
        g_sfp.sfp16,                                       #FUN-AB0001 add:sfp16
        g_sfp.sfpconf,                                     #FUN-660106 add g_sfp.sfpconf
        g_sfp.sfpmksg,                                     #FUN-AB0001 add:sfpmksg
        g_sfp.sfp04,                                       
        g_sfp.sfp09,g_sfp.sfp10,g_sfp.sfp11,               #FUN-630084 add sfp11
        g_sfp.sfp14,g_sfp.sfp15,                           #FUN-AB0001 add:sfp15  #CHI-CB0063 add sfp14
        g_sfp.sfpuser,g_sfp.sfpgrup,                       #NO:6908
        g_sfp.sfpmodu,g_sfp.sfpdate                        #NO:6908
        ,g_sfp.sfpud01,g_sfp.sfpud02,g_sfp.sfpud03,g_sfp.sfpud04,
        g_sfp.sfpud05,g_sfp.sfpud06,g_sfp.sfpud07,g_sfp.sfpud08,
        g_sfp.sfpud09,g_sfp.sfpud10,g_sfp.sfpud11,g_sfp.sfpud12,
        g_sfp.sfpud13,g_sfp.sfpud14,g_sfp.sfpud15 

    CALL i501_sfp16('d')                      #FUN-AB0001 add
 
    LET g_buf = s_get_doc_no(g_sfp.sfp01)     #No.FUN-550052
    SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_sfp.sfp07
    DISPLAY l_gem02 TO FORMONLY.gem02
    DISPLAY l_smydesc TO smydesc LET g_buf = NULL #MOD-4C0010
    IF g_argv2 MATCHES '[ABC]' THEN
       IF g_sma.sma79='Y' THEN 
          SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_sfp.sfp11 AND azf02='A'
          IF SQLCA.sqlcode THEN
             LET l_azf03=NULL
          END IF
       ELSE 
          SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_sfp.sfp11 AND azf02='2'
          IF SQLCA.sqlcode THEN
             LET l_azf03=NULL
          END IF
       END IF 
       DISPLAY l_azf03 TO FORMONLY.azf03
    END IF
    CALL i501_pic() #圖形顯示
    CALL i501_d_fill(g_wc2)
 
   #str MOD-A50110 mod
   #CALL i501_b_fill(g_wc3)
    IF g_sfp.sfp04='N' THEN
       CALL i501_b_fill(g_wc3)
    ELSE
       CALL i501_b_fill(g_wc5)
    END IF
   #end MOD-A50110 mod
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i501_r()
  DEFINE l_chr,l_sure LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         l_sfs        RECORD LIKE sfs_file.*
  DEFINE l_imm03  LIKE imm_file.imm03
  DEFINE l_sfp01  LIKE sfp_file.sfp01,
         l_cnt    LIKE type_file.num10        #No.FUN-680121 INTEGER #FUN-5C0114
  DEFINE l_flag   LIKE type_file.num5         #FUN-810038
  DEFINE l_sfb87  LIKE sfb_file.sfb87         #FUN-B50106
  DEFINE l_i      LIKE type_file.num5         #no.CHI-860008
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sfp.sfp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfp.* FROM sfp_file WHERE sfp01=g_sfp.sfp01
    IF g_sfp.sfpconf = 'Y'   THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660106
    IF g_sfp.sfp04 = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfp.sfpconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660106
    #FUN-AB0001 add str ---
    IF g_sfp.sfp15 matches '[Ss]' THEN
       CALL cl_err('','aws-200',0)            #送簽中,不可刪除資料
       RETURN
    END IF
    #FUN-AB0001 add end ---

 
    BEGIN WORK
 
    OPEN i501_cl USING g_sfp.sfp01                     #09/10/21 xiaofeizhu Add
    IF STATUS THEN
       CALL cl_err("OPEN i501_cl:", STATUS, 1)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i501_cl INTO g_sfp.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i501_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfp01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfp.sfp01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete sfp,sfs!"
    #若已有idb/ida詢問且一併刪
    LET g_cnt = 0 
   #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
    CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
              SELECT COUNT(*) INTO g_cnt FROM idb_file
               WHERE idb07 = g_sfp.sfp01
        #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
         WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
              SELECT COUNT(*) INTO g_cnt FROM ida_file
               WHERE ida07 = g_sfp.sfp01
    END CASE
    IF g_cnt > 0 THEN
       #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作?
       IF NOT cl_confirm('aic-112') THEN
          CLOSE i501_cl
          ROLLBACK WORK
          RETURN
       ELSE
         #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
          CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
               CALL s_icdinout_del(-1,g_sfp.sfp01,'','')   #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
              #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
               WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
               CALL s_icdinout_del(1,g_sfp.sfp01,'','')   #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
          END CASE 
          IF l_flag = 0 THEN 
             CLOSE i501_cl 
             ROLLBACK WORK 
             RETURN 
          END IF
       END IF
    END IF

#MOD-D90093 add begin---------------------------
        FOR l_i = 1 TO g_rec_b
           IF NOT s_lot_del(g_prog,g_sfp.sfp01,'',0,g_sfs[l_i].sfs04,'DEL')  THEN
              ROLLBACK WORK
              RETURN
           END IF
        END FOR
#MOD-D90093 add end-----------------------------

        DELETE FROM sfp_file WHERE sfp01 = g_sfp.sfp01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","sfp_file",g_sfp.sfp01,"",SQLCA.SQLCODE,"","No sfp deleted",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
 
        DELETE FROM sfq_file WHERE sfq01 = g_sfp.sfp01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","sfq_file",g_sfp.sfp01,"",STATUS,"","del sfq",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
 
# 當有耗材產生時,應將asft620之耗材單號清為NULL
        IF g_sfp.sfp06 = '4' THEN
           SELECT COUNT(*) INTO g_cnt FROM sfu_file
            WHERE sfu09 = g_sfp.sfp01
           IF g_cnt > 0 THEN
              UPDATE sfu_file SET sfu09 = NULL
               WHERE sfu09 = g_sfp.sfp01
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","sfu_file",g_sfp.sfp01,"",STATUS,"","upd sfu",1)  #No.FUN-660128
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           # 當有耗材產生時,應將apmt730之耗材單號清為NULL                                                     
           SELECT COUNT(*) INTO g_cnt FROM rvu_file                                                                                 
            WHERE rvu16 = g_sfp.sfp01                                                                                               
           IF g_cnt > 0 THEN                                                                                                        
              UPDATE rvu_file SET rvu16 = NULL                                                                                      
               WHERE rvu16 = g_sfp.sfp01                                                                                            
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                  
                 CALL cl_err3("upd","rvu_file",g_sfp.sfp01,"",STATUS,"","upd rvu",1)                                                
                 ROLLBACK WORK                                                                                                      
                 RETURN                                                                                                             
              END IF                                                                                                                
           END IF                                                                                                                   
           SELECT COUNT(*) INTO g_cnt FROM srf_file
            WHERE srf06 = g_sfp.sfp01
           IF g_cnt > 0 THEN
              UPDATE srf_file SET srf06 = NULL
               WHERE srf06 = g_sfp.sfp01
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","srf_file",g_sfp.sfp01,"",STATUS,"","upd srf",1)  #No.FUN-660128
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
        END IF
        IF g_sfp.sfp06='C' THEN #由asrt300產生
           UPDATE srf_file set srf06=null WHERE srf06=g_sfp.sfp01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","srf_file",g_sfp.sfp01,"",STATUS,"","upd srf",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
        END IF
        IF g_sfp.sfp06 MATCHES '[BC]' THEN #由asrt340產生
           UPDATE sro_file set sro13=null,sro14=null WHERE sro13=g_sfp.sfp01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","sro_file",g_sfp.sfp01,"",STATUS,"","upd sro",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
           DELETE FROM srp_file WHERE srp13=g_sfp.sfp01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","srp_file",g_sfp.sfp01,"",STATUS,"","upd srp",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
        END IF
        IF (g_sfp.sfp06 MATCHES '[1234567]') AND (g_sfp.sfp06 <> '8') THEN         #No.MOD-570241 add sfp06的判斷  #FUN-5C0114
           DECLARE i501_upd_sfb CURSOR FOR
             SELECT * FROM sfs_file WHERE sfs01 = g_sfp.sfp01
           FOREACH i501_upd_sfb INTO l_sfs.*
             IF STATUS THEN CALL cl_err('foreach sfs',STATUS,0) EXIT FOREACH END IF
             SELECT COUNT(*) INTO g_cnt FROM sfa_file
              WHERE sfa01 = l_sfs.sfs03
                AND sfa06 > 0
             IF g_cnt > 0 THEN CONTINUE FOREACH END IF
             SELECT COUNT(*) INTO g_cnt FROM sfb_file                                                                               
              WHERE sfb01 = l_sfs.sfs03                                                                                             
                AND sfb081> 0                                                                                                       
             IF g_cnt > 0 THEN CONTINUE FOREACH END IF                                                                              
             SELECT COUNT(*) INTO g_cnt FROM sfu_file,sfv_file
               WHERE sfv11 = l_sfs.sfs03
                 AND sfv01 = sfu01
                 AND sfupost = 'Y'

             IF g_cnt > 0 THEN CONTINUE FOREACH END IF
             #FUN-B50106(S)
             SELECT sfb87 INTO l_sfb87 FROM sfb_file   #TQC-B80040 Modify 
              WHERE sfb01 = l_sfs.sfs03                #TQC-B80040 Modify 
             IF l_sfb87='Y' THEN        
                UPDATE sfb_file SET sfb04 = '2' WHERE sfb01 = l_sfs.sfs03  
             ELSE
                UPDATE sfb_file SET sfb04 = '1' WHERE sfb01 = l_sfs.sfs03  
             END IF
             #FUN-B50106(S)
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfb_file",l_sfs.sfs03,"",STATUS,"","upd sfb",1)  #No.FUN-660128
                ROLLBACK WORK
                RETURN
             END IF
           END FOREACH
        END IF             #No.MOD-570241
        DELETE FROM sfs_file WHERE sfs01 = g_sfp.sfp01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","sfs_file",g_sfp.sfp01,"",STATUS,"","del sfs",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
        #FUN-B70061 --START--
        IF NOT s_del_sfsi(g_sfp.sfp01,'','') THEN
           #不作處理        
        END IF
        #FUN-B70061 --END--
 
        LET l_imm03=''
        SELECT imm03 INTO l_imm03 FROM imm_file
         WHERE imm01 = g_sfp.sfp08 AND imm09=g_sfp.sfp01
           AND immconf != 'X' #FUN-660029
        IF SQLCA.SQLCODE = 0  THEN
           IF l_imm03='N' THEN
             DELETE FROM imm_file WHERE imm01=g_sfp.sfp08
                                    AND imm09=g_sfp.sfp01
             IF STATUS THEN
                CALL cl_err3("del","imm_file",g_sfp.sfp01,g_sfp.sfp08,STATUS,"","del imm",1)  #No.FUN-660128
                ROLLBACK WORK RETURN
             END IF
             DELETE FROM imn_file WHERE imn01=g_sfp.sfp08
             IF STATUS THEN
                CALL cl_err3("del","imn_file",g_sfp.sfp08,"",STATUS,"","del imm",1)  #No.FUN-660128
                ROLLBACK WORK RETURN
             END IF
           END IF
       END IF
 
       #delete時
       #因挪料作業產生的發/退料單sfp10 IS NOT NULL
       #發料單=> UPDATE sfm09 = NULL
       #退料單=> UPDATE sfm07 = NULL
        IF NOT cl_null(g_sfp.sfp10) THEN
            IF g_sfp.sfp06 = '6' OR g_sfp.sfp06 = '8' THEN #退料
                UPDATE sfm_file
                   SET sfm07 = NULL
                 WHERE sfm00 = g_sfp.sfp10
            END IF
            IF g_sfp.sfp06 = '1' OR g_sfp.sfp06 = '3' THEN #發料
                UPDATE sfm_file
                   SET sfm09 = NULL
                 WHERE sfm00 = g_sfp.sfp10
            END IF
            IF STATUS THEN
               CALL cl_err3("upd","sfm_file",g_sfp.sfp10,"",STATUS,"","UPDATE sfm",1)  #No.FUN-660128
               ROLLBACK WORK RETURN
            END IF
        END IF
 
#MOD-D90093 mark begin-----------------------
##TQC-C10033 --unmark
#  #MOD-C10100 --begin--
#          FOR l_i = 1 TO g_rec_b 
#  #            IF NOT s_del_rvbs("1",g_sfp.sfp01,g_sfs[l_i].sfs02,0)  THEN        #FUN-880129  #MOD-890271 modify 2->1 #No.TQC-B90236 mark
#              IF NOT s_lot_del(g_prog,g_sfp.sfp01,'',0,g_sfs[l_i].sfs04,'DEL')  THEN #No.TQC-B90236 add
#                 ROLLBACK WORK
#                 RETURN
#              END IF
#          END FOR
#  #MOD-C10100 --end--
##TQC-C10033 --unmark
#MOD-D90093 mark end-------------------------
 
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
           VALUES (g_prog,g_user,g_today,g_msg,g_sfp.sfp01,'delete',g_plant,g_legal) #FUN-980008 add
 
        CLEAR FORM
        CALL g_sfq.clear()
        CALL g_sfs.clear()
 
    	INITIALIZE g_sfp.* TO NULL
        MESSAGE ""
        LET g_row_count=0
        FOREACH i501_count INTO l_sfp01
            LET g_row_count=g_row_count +1
        END FOREACH
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i501_cs
           CLOSE i501_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        OPEN i501_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i501_fetch('L')
        ELSE
           IF g_curs_index>0 THEN #MOD-840301
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i501_fetch('/')
           ELSE
              CALL cl_err('','asf-079',0) #MOD-840301
           END IF
        END IF
 
    END IF
 
    CLOSE i501_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sfp.sfp01,'D')
 
END FUNCTION
 
FUNCTION i501_d()
 DEFINE l_cnt,l_cnt_1  LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
   IF  cl_null(g_sfp.sfp01) THEN RETURN END IF   #No:9485
   LET g_success = 'Y'  #No:7792,7867
  #IF g_sfp.sfp06 NOT MATCHES '[136ABC]' THEN RETURN END IF #FUN-5C0114 add ABC  #FUN-C70014 mark
   IF g_sfp.sfp06 NOT MATCHES '[136ABCD]' THEN   #FUN-C70014 add D
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF
   IF g_sfp.sfpconf = 'Y' THEN 
      CALL cl_err('','9023',1)
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF #FUN-660106
   IF g_sfp.sfp04 = 'Y' THEN 
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF
   IF g_sfp.sfpconf = 'X' THEN 
      CALL cl_err('','9024',1) 
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF #FUN-660106
 
   #FUN-AB0001  add str ---
   IF g_sfp.sfp15 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
      LET g_success = 'N' #TQC-DB0051
      RETURN
   END IF
   IF g_sfp.sfpconf='Y' AND g_sfp.sfp15 = "1" AND g_sfp.sfpmksg = "Y"  THEN
      CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
      LET g_success = 'N' #TQC-DB0051
      RETURN
   END IF
   #FUN-AB0001  add end ---

   WHILE TRUE
      CALL i501_d_i()
      CALL i501_d_fill(' 1=1')
      
      LET l_cnt = 0
      LET l_cnt_1 = 0
      SELECT COUNT(*) INTO l_cnt FROM sfq_file
       WHERE sfq01 = g_sfp.sfp01
      SELECT COUNT(*) INTO l_cnt_1 FROM sfs_file
       WHERE sfs01 = g_sfp.sfp01
      IF g_argv2 = '1' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-362') THEN
            #未輸入單身資料,則取消單頭資料
            CALL i501_delHeader()  #CHI-D50037
            #CHI-D50037---begin
            #IF g_argv2 = '1' AND l_cnt=0 AND l_cnt_1 = 0 THEN
            #   IF cl_confirm('9042') THEN
            #      DELETE FROM sfp_file WHERE sfp01 = g_sfp.sfp01
            #      LET g_cnt=0
            #      CLEAR FORM
            #      CALL g_sfq.clear()
            #      CALL g_sfs.clear()
            #      INITIALIZE g_sfp.* TO NULL    #TQC-C40150
            #      LET g_success = 'N'
            #   END IF
            #END IF
            #CHI-D50037---end
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF
#MOD-D60042 add begin---------------------------
      IF g_argv2 = '3' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-687') THEN
            CALL i501_delHeader()
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF 
      IF g_argv2 = '6' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-688') THEN
            CALL i501_delHeader()
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF 
#MOD-D60042 add end-----------------------------
      EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION i501_d_i()
   DEFINE i,j           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE qty1,qty2	LIKE sfq_file.sfq03    #No.FUN-680121 DEC(15,3)
   DEFINE unissue_qty	LIKE sfb_file.sfb08,   #No.FUN-680121 DEC(15,3),
          l_qty         LIKE sre_file.sre07,   #No.FUN-680121 DEC(15,3),
          l_tot         LIKE img_file.img10    #No.FUN-680121 DEC(15,3)
   DEFINE l_sfb08 	LIKE sfb_file.sfb08    #No.FUN-680121 DEC(15,3)
   DEFINE l_sfb23 	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_sfb04	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_sfb02	LIKE sfb_file.sfb02
   DEFINE l_sfb06	LIKE sfb_file.sfb06,
          l_sfb09       LIKE sfb_file.sfb09,
          l_sfb81       LIKE sfb_file.sfb81,
          l_sfq03       LIKE sfq_file.sfq03,
          l_sfq02_t     LIKE sfq_file.sfq02,
          l_sfq03_t     LIKE sfq_file.sfq03,
          l_sfq03_o     LIKE sfq_file.sfq03,   #No.MOD-860012 
          l_sfq03_r     LIKE sfq_file.sfq03,
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
   DEFINE l_str         STRING #FUN-5C0114
   DEFINE l_sfa062      LIKE sfa_file.sfa062 #TQC-670083
   DEFINE l_sfbiicd04   LIKE sfbi_file.sfbiicd04,     #預計生產量
          l_ecdicd01    LIKE ecd_file.ecdicd01       #作業群組
   DEFINE l_sfa03       LIKE sfa_file.sfa03
   DEFINE l_sfa08       LIKE sfa_file.sfa08
   DEFINE l_sfa12       LIKE sfa_file.sfa12
   DEFINE l_sfa27       LIKE sfa_file.sfa27
   DEFINE l_sfa05       LIKE sfa_file.sfa05   #TQC-980097 add
   DEFINE l_pmm01       LIKE pmm_file.pmm01    #TQC-990060
   DEFINE l_ima56       LIKE ima_file.ima56   #TQC-9B0061
   DEFINE l_faqty       LIKE ima_file.ima56   #TQC-9B0061
#  DEFINE l_per         LIKE type_file.num5   #TQC-9B0061         #MOD-AB0047
#  DEFINE l_per         LIKE sfq_file.sfq03   #MOD-B70193         #MOD-AB0047
   DEFINE l_per         LIKE type_file.num10  #MOD-B70193
   DEFINE l_qty1        LIKE sfq_file.sfq03   #TQC-9C0035
   DEFINE l_qty2        LIKE sfq_file.sfq03   #TQC-9C0035
   DEFINE l_sfb081 	    LIKE sfb_file.sfb081  #MOD-9C0240
   DEFINE l_sfa012       LIKE sfa_file.sfa012  #TQC-B30021
   DEFINE l_sfa013       LIKE sfa_file.sfa013  #TQC-B30021
   DEFINE l_sfq03_flag   LIKE type_file.chr1   #FUN-B20095
   #MOD-BA0078 -- begin --
   DEFINE l_ima153      LIKE ima_file.ima153
   DEFINE l_allowqty    LIKE sfq_file.sfq03
   #MOD-BA0078 -- end --
  #DEFINE a_qty1        LIKE sfq_file.sfq03 #TQC-BC0130   #MOD-C80256 mark 
  #DEFINE a_qty2        LIKE sfq_file.sfq03 #TQC-BC0130   #MOD-C80256 mark
   DEFINE l_row         LIKE type_file.num10 #FUN-C70014  #总行数
   DEFINE l_shm08 	    LIKE shm_file.shm08
   DEFINE l_cmd         LIKE type_file.chr1   #FUN-C70014
   DEFINE l_count       LIKE type_file.num5   #FUN-C70014
   DEFINE l_n           LIKE type_file.num5   #FUN-C70014
   DEFINE l_sfq014_t    LIKE sfq_file.sfq014  #FUN-C70014
   DEFINE l_i           LIKE type_file.num5   #MOD-D50151
   
   LET g_flag_sfq03=0     #CHI-6C0005 add
 
   SELECT COUNT(*) INTO i FROM sfq_file WHERE sfq01=g_sfp.sfp01
   IF NOT cl_null(g_sfp.sfp08) THEN
      IF i=0 THEN
         DECLARE i501_s_sfq_c CURSOR FOR         
           SELECT sfd03,'',sfb05,'','','',sfb95,0,0,sfb08,sfb081   #FUN-870097 add sfb95 #FUN-5C0114 add sfq05    #FUN-A70095 add 0
            ,sfbiicd04,ecdicd01  #FUN-810038
              FROM sfd_file,sfb_file 
                  ,sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09 = ecd01                     #09/10/21 xiaofeizhu Add
             WHERE sfd01=g_sfp.sfp08 AND sfd03=sfb01
               AND sfbi01=sfb01                                                                #09/10/21 xiaofeizhu Add
              AND sfb87 = 'Y'           #No.FUN-870117
         CALL g_sfq.clear()
         LET i=1
        FOREACH i501_s_sfq_c INTO g_sfq[i].sfq02,
                                  g_sfq[i].sfq04,
                                  g_sfq[i].sfb05,
                                  g_sfq[i].ima02_a,
                                  g_sfq[i].ima021_a,
                                  g_sfq[i].sfq05,
                                  g_sfq[i].sfq07,   #No.FUN-870097
                                  g_sfq[i].sfq08,   #NO.FUN-940008 add
                                  g_sfq[i].sfq03,
                                  qty1, qty2
                                  ,l_sfbiicd04,l_ecdicd01  #FUN-810038
           IF STATUS THEN
             CALL cl_err('fore sfd:',STATUS,1)  
              EXIT FOREACH
           END IF
           SELECT ima02,ima021 INTO g_sfq[i].ima02_a, g_sfq[i].ima021_a
             FROM ima_file WHERE ima01=g_sfq[i].sfb05
           #    成套發料：
           #    1若工單作業群組=3.DS或4.ASS
           #     1.1若預計生產數量(sfbiicd04) <> 0, 則用預計生產數量控卡發料數
           #     1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
           #        則用生產數量控卡發料數
           #    2.其他: 比照標準作法 
          #IF g_sfp.sfp06 = '1' AND l_ecdicd01 MATCHES '[34]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[1234]' AND l_ecdicd01 MATCHES '[34]' THEN #CHI-A70060
              IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                 LET qty1 = l_sfbiicd04
              END IF
           END IF
           IF g_sfp.sfp06 = '1' THEN LET g_sfq[i].sfq03=qty1-qty2 END IF
           IF g_sfp.sfp06 = '6' THEN LET g_sfq[i].sfq03=qty2      END IF
           IF g_sfq[i].sfq03<0 THEN LET g_sfq[i].sfq03=0 END IF
           LET i=i+1
         END FOREACH
         CALL g_sfq.deleteElement(i)
         LET i = i - 1
      END IF
   END IF

   IF (i=0) AND (g_argv2 MATCHES '[ABC]') THEN
      CALL i501_planissue()
   END IF
 
   BEGIN WORK
 
   OPEN i501_cl USING g_sfp.sfp01                     #09/10/21 xiaofeizhu Add
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i501_cl INTO g_sfp.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i501_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_sfp.sfpmodu=g_user              #NO:6908
   LET g_sfp.sfpdate=g_today             #NO:6908
   DISPLAY BY NAME g_sfp.sfpmodu         #NO:6908
   DISPLAY BY NAME g_sfp.sfpdate         #NO:6908
 
 
   LET g_success='Y'
   LET l_sfq02_t = NULL
   LET l_sfq03_t = NULL
   LET l_sfq03_o = NULL      #No.MOD-860012 
 
   DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=i,UNBUFFERED)
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
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_count = g_sfq.getLength()     #FUN-C70014
   INPUT ARRAY g_sfq WITHOUT DEFAULTS FROM s_sfq.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         CALL i501_set_entry_d('a')
         CALL i501_set_no_entry_d('a')
 
      BEFORE ROW
         LET i = ARR_CURR()
         LET l_sfq03_t = g_sfq[i].sfq03
         LET l_sfq03_o = g_sfq[i].sfq03   #No.MOD-860012 
         LET l_sfq02_t = g_sfq[i].sfq02   #FUN-940039 add
         LET l_sfq03_flag = 'N'           #FUN-B20095
         #FUN-C70014 add begin-----------
         LET l_sfq014_t = g_sfq[i].sfq014
         IF i > l_count THEN 
             LET l_cmd = 'a'
         ELSE 
             LET l_cmd = 'u'
         END IF 
         IF g_sfp.sfp06 = 'D' THEN 
            NEXT FIELD sfq014
         ELSE
         #FUN-C70014 add end-------------
            NEXT FIELD sfq02
         END IF   #FUN-C70014 add
 
      BEFORE DELETE
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM sfs_file  
               WHERE sfs01 = g_sfp.sfp01
                 AND sfs03 = g_sfq[i].sfq02
 
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt > 0 THEN
          CALL cl_err (g_sfq[i].sfq02,'asf-795',1)
          CANCEL DELETE
          NEXT FIELD sfq02
       END IF

      #FUN-C70014 add begin-------------
      AFTER FIELD sfq014
         IF NOT cl_null(g_sfq[i].sfq014) THEN
            SELECT COUNT(*) INTO l_cnt FROM shm_file
             WHERE shm01 = g_sfq[i].sfq014
               AND shm28 = 'N'
            IF l_cnt = 0 THEN
               CALL cl_err('','asf-910',1)
               LET g_sfq[i].sfq014 = l_sfq014_t
               NEXT FIELD sfq014
            END IF
          
            SELECT shm012 INTO g_sfq[i].sfq02 FROM shm_file
             WHERE shm01 = g_sfq[i].sfq014 
               AND shm28 = 'N'
            DISPLAY BY NAME g_sfq[i].sfq02 
         END IF
         IF g_sfp.sfp06 = 'D' THEN #FUN-C70014 add
            IF NOT i501_chk_sfq(i,'1') THEN NEXT FIELD sfq014 END IF  #FUN-C70014 add
         END IF #FUN-C70014 add
      #FUN-C70014 add end --------------
      AFTER FIELD sfq02
         LET g_sfq02 = g_sfq[i].sfq02      #TQC-A30108
#MOD-D50151---begin
         IF cl_null(g_sfq[i].sfq05) THEN 
            LET g_sfq[i].sfq05 = g_sfp.sfp02
         END IF 
         IF NOT cl_null(g_sfq[i].sfq02) AND (NOT cl_null(g_sfq[i].sfq04) OR g_sfq[i].sfq04 = ' ') AND NOT cl_null(g_sfq[i].sfq05) THEN 
              FOR l_i = 1 TO g_sfq.getLength()
                 IF l_i <> i AND g_sfq[i].sfq02 = g_sfq[l_i].sfq02 AND g_sfq[i].sfq04 = g_sfq[l_i].sfq04 AND g_sfq[i].sfq05 = g_sfq[l_i].sfq05 THEN 
                    CALL cl_err ('','asf-245',1)
                    NEXT FIELD sfq02
                 END IF 
              END FOR 
         END IF 
#MOD-D50151---end
#FUN-AA0059 ---------------------start----------------------------
         #IF NOT cl_null(g_sfq[i].sfq02) THEN                                #No.TQC-AB0009
         IF NOT cl_null(g_sfq[i].sfq02) AND g_argv2 MATCHES '[ABC]' THEN     #No.TQC-AB0009
            IF NOT s_chk_item_no(g_sfq[i].sfq02,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD sfq02
            END IF
         END IF
#FUN-AA0059 ---------------------end-------------------------------
         #TQC-CA0044 add begin-------------
         IF g_sfp.sfp06 = 'D' AND NOT cl_null(g_sfq[i].sfq014) AND 
            NOT cl_null(g_sfq[i].sfq02) THEN
            SELECT COUNT(*) INTO l_cnt FROM shm_file
             WHERE shm01 = g_sfq[i].sfq014
               AND shm012 = g_sfq[i].sfq02
               AND shm28 = 'N'
            IF l_cnt = 0 THEN
               CALL cl_err('','asf1033',1)
               LET g_sfq[i].sfq02 = l_sfq02_t
               NEXT FIELD sfq02
            END IF
         END IF 
         #TQC-CA0044 add end --------------
         IF (NOT cl_null(g_sfq[i].sfq02)) AND (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
            CALL i501_sfb01(g_sfq[i].sfq02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfq[i].sfq02,g_errno,0)
               NEXT FIELD sfq02
            END IF
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01=g_sfq[i].sfq02
            IF l_sfb02 = '15' THEN
               CALL cl_err(g_sfq[i].sfq02,'asr-047',1)   #所輸入之工單型態
               NEXT FIELD sfq02
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM snb_file
             WHERE snb01 = g_sfq[i].sfq02
              #AND snbconf = 'N'    #MOD-B60143 mark
               AND snbconf != 'X'   #MOD-B60143 add
               AND snb99 != '2'     #MOD-B60143 add
            IF l_cnt > 0 THEN
               CALL cl_err('sel-snb','asf-068',0)
               NEXT FIELD sfq02
            END IF
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01 = g_sfq[i].sfq02
            IF l_sfb02 = '7' OR l_sfb02 = '8' THEN 

               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
                WHERE pmm01 = pmn01
                  AND pmn41 = g_sfq[i].sfq02
                  AND pmm18 = 'Y'
                  AND (pmm25 != '6' OR pmm25 != '9')
               IF cl_null(l_cnt)  OR l_cnt = 0 THEN 
                  CALL cl_err('','asf-117',0)
                  NEXT FIELD sfq02
               END IF    
            END IF 
            IF g_sfp.sfp06 = '3' THEN   #補料單
               SELECT COUNT(*) INTO g_cnt FROM sfp_file,sfq_file
                WHERE sfp06 = '1'
                  AND sfp01 = sfq01
                  AND sfq02 = g_sfq[i].sfq02
                  AND sfp04 = 'Y'     #未扣帳不可刷補料單
               IF g_cnt = 0 THEN
                  CALL cl_err(g_sfq[i].sfq02,'asf-526',0)
                  NEXT FIELD sfq02
               END IF
 
               SELECT COUNT(*) INTO g_cnt FROM sfb_file
                WHERE sfb01 = g_sfq[i].sfq02
                  AND sfb04 = '8'   #已結案工單不可KEYIN
               IF g_cnt > 0 THEN
                 #CALL cl_err(g_sfq[i].sfq02,'asf-526',0) #MOD-D60042 mark
                  CALL cl_err(g_sfq[i].sfq02,'asf-686',0) #MOD-D60042 add
                  NEXT FIELD sfq02
               END IF
 
               SELECT COUNT(*) INTO g_cnt FROM sfp_file,sfq_file
                WHERE sfp06 = '3'
                  AND sfp04 = 'N'
                  AND sfp01 = sfq01
                  AND sfq02 = g_sfq[i].sfq02
                  AND sfq01 != g_sfp.sfp01
                  AND sfpconf != 'X'          #No.MOD-780024 add
               IF g_cnt > 0 THEN
                  #CALL cl_err(g_sfq[i].sfq02,'asf-703',0) #FUN-660106
                  CALL cl_err(g_sfq[i].sfq02,'asf-701',0) #FUN-660106
                  NEXT FIELD sfq02
               END IF
 
            END IF
 
            SELECT sfb05,sfb04,sfb23,sfb08,sfb06,sfb81,sfb02
                  ,sfbiicd04,ecdicd01  #FUN-810038
              INTO g_sfq[i].sfb05, l_sfb04, l_sfb23, l_sfb08,
                   l_sfb06,l_sfb81,l_sfb02
                  ,l_sfbiicd04,l_ecdicd01  #FUN-810038
              FROM sfb_file
              ,sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09 = ecd01                     #09/10/21 xiaofeizhu Add
             WHERE sfb01 = g_sfq[i].sfq02
               AND sfb87 ='Y'
              AND sfbi01=sfb01                                                                #09/10/21 xiaofeizhu Add
 
            IF STATUS THEN
               CALL cl_err3("sel","sfb_file",g_sfq[i].sfq02,"",STATUS,"","sel sfb",1)  #No.FUN-660128
               NEXT FIELD sfq02
            END IF
 
            IF l_sfb04='1' THEN
               CALL cl_err('sfb04=1','asf-381',0) NEXT FIELD sfq02
            END IF
 
            IF l_sfb04='8' THEN
               CALL cl_err('sfb04=8','asf-345',0) NEXT FIELD sfq02
            END IF
 
            IF l_sfb81 > g_sfp.sfp02 THEN      #-->NO:0813
               CALL cl_err(g_sfq[i].sfq02,'asf-819',0) NEXT FIELD sfq02
            END IF                             #----------
 
            IF l_sfb02=13 THEN  #bugno:4863
               CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD sfq02
            END IF
 
            SELECT ima02,ima021 INTO g_sfq[i].ima02_a, g_sfq[i].ima021_a
              FROM ima_file
             WHERE ima01=g_sfq[i].sfb05

            IF g_sfp.sfp06 = '1' THEN   #成套發料
               LET l_sfq03 = 0
               LET l_sfq03_r = 0
               DECLARE i501_cs1 CURSOR FOR
                SELECT SUM(sfq03) FROM sfp_file,sfq_file
                 WHERE sfp06='1'
                   AND sfp01=sfq01
                #  AND sfq02=g_sfq[i].sfq02                      #TQC-A30108
                   AND (sfq02=g_sfq02 AND g_sfq02 IS NOT NULL)   #TQC-A30108
                   AND sfpconf !='X'           #No:7741  #FUN-660106
                   AND sfp04 = 'Y'             #No.FUN-870117
                 GROUP BY sfq04
                 ORDER BY sfq03 DESC
 
               FOREACH i501_cs1 INTO l_sfq03
                 IF STATUS THEN LET l_sfq03=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sfq03) THEN LET l_sfq03 = 0 END IF   #成套發料數
 
               DECLARE i501_cs0 CURSOR FOR
                SELECT SUM(sfq03) FROM sfp_file,sfq_file
                 WHERE sfp06='6' AND sfp01=sfq01
                #  AND sfq02=g_sfq[i].sfq02                      #TQC-A30108
                   AND (sfq02=g_sfq02 AND g_sfq02 IS NOT NULL)   #TQC-A30108 
                   AND sfpconf !='X'  #FUN-660106
                 GROUP BY sfq04
                 ORDER BY sfq03 DESC
 
               FOREACH i501_cs0 INTO l_sfq03_r
                 IF STATUS THEN LET l_sfq03_r=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sfq03_r) THEN LET l_sfq03_r = 0 END IF #成套退料數
               LET l_sfq03 = l_sfq03 - l_sfq03_r    #成套發料-成套退料
 
               IF l_sfq03 > l_sfb08 THEN
                  CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                  NEXT FIELD sfq02
               END IF
               #  成套發料：
               #  1若工單作業群組=3.DS或4.ASS
               #   1.1若預計生產數量(sfbiicd04) <> 0, 則用預計生產數量控卡發料數
               #   1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
               #      則用生產數量控卡發料數
               #  2.其他: 比照標準作法 
               IF l_ecdicd01 MATCHES '[34]' THEN
                  IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                     IF l_sfq03 > l_sfbiicd04 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                        NEXT FIELD sfq02
                     END IF
                  ELSE
                     IF l_sfq03 > l_sfb08 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                        NEXT FIELD sfq02
                     END IF
                  END IF
               ELSE
                  IF l_sfq03 > l_sfb08 THEN
                     CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                     NEXT FIELD sfq02
                  END IF
               END IF
            END IF
         END IF
 
         IF (NOT cl_null(g_sfq[i].sfq02)) AND (g_sfp.sfp06 MATCHES '[ABC]') THEN
            LET l_cnt=0
            SELECT ima02,ima021 INTO g_sfq[i].ima02_a,g_sfq[i].ima021_a
               FROM ima_file WHERE ima01 = g_sfq[i].sfq02
                               AND imaacti = 'Y'
                               AND ima911='Y' #MOD-630064
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","ima_file",g_sfq[i].sfq02,"",100,"","",1)  #No.FUN-660128
               LET g_sfq[i].ima02_a=''
               LET g_sfq[i].ima021_a=''
               NEXT FIELD sfq02
            ELSE
               DISPLAY BY NAME g_sfq[i].ima02_a
               DISPLAY BY NAME g_sfq[i].ima021_a
            END IF
         END IF
         IF g_sfp.sfp06 = 'D' THEN #FUN-C70014 add
            IF NOT i501_chk_sfq(i,'1') THEN NEXT FIELD sfq02 END IF  #FUN-C70014 add
         END IF 

#FUN-B20095 ---------------------Begin-------------------------
      AFTER FIELD sfq012 
         IF cl_null(g_sfq[i].sfq012) THEN
            LET g_sfq[i].sfq012 = ' '
         ELSE 
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfa_file
             WHERE sfa01 = g_sfq[i].sfq02 
               AND sfa012 = g_sfq[i].sfq012
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt < 1 THEN
               LET g_sfq[i].sfq012 = ' '
               NEXT FIELD sfq012
            END IF
            CALL s_schdat_ecm014(g_sfq[i].sfq02,g_sfq[i].sfq012)  
               RETURNING g_sfq[i].ecm014   
            DISPLAY BY NAME g_sfq[i].ecm014       

           #IF g_sfp.sfp06 MATCHES '[1]' THEN
            IF g_sfp.sfp06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'
               #FUN-C70014 add begin-----------
               IF g_sfp.sfp06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = g_sfq[i].sfq014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               #IF g_sma.sma129='N' THEN  #FUN-C70014 mark
               IF g_sma.sma129='N' AND g_sfp.sfp06 <> 'D' THEN #FUN-C70014 g_sfp.sfp06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=g_sfq[i].sfq02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET qty1=l_sfb081
                  LET qty2=0
                  LET unissue_qty = l_sfb08 - l_sfb081 
               ELSE
                  LET qty1 = 0
                  LET qty2 = 0
                 #CALL i501_sfq03_chk1(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012) #只选过账的,用于预设值
                  CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'1')  #FUN-BC0060 mod   #FUN-C70014 add sfq014
                       RETURNING qty1,qty2
                  IF qty1 IS NULL THEN LET qty1=0 END IF
                  IF qty2 IS NULL THEN LET qty2=0 END IF
                  
                  LET unissue_qty = l_sfb08-(qty1-qty2)
                  IF g_sfp.sfp06 = 'D' THEN LET unissue_qty = l_shm08-(qty1-qty2) END IF #FUN-C70014 add
               END IF
               IF (g_sfq[i].sfq03 IS NULL OR
                  (l_sfq02_t IS NULL OR l_sfq02_t != g_sfq[i].sfq02)) AND 
                  l_sfq03_flag = 'N' THEN   #FUN-B20095 add l_sfq03_flag
                  IF g_argv1='1' THEN
                     LET g_sfq[i].sfq03 = unissue_qty
                  ELSE
                     LET g_sfq[i].sfq03 = qty1-qty2
                  END IF
               END IF
               IF g_sfq[i].sfq03 = 0 THEN
                  IF g_argv1='1' THEN 
                     IF g_sma.sma129 = 'Y' THEN
                        LET g_sfq[i].sfq03 = unissue_qty
                     END IF
                  ELSE
                     LET g_sfq[i].sfq03 = qty1-qty2 
                  END IF
               END IF 
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = g_sfq[i].sfq02
               LET l_sfq03 = 0
               LET l_sfq03_r = 0
               IF cl_null(g_sfq[i].sfq04) THEN
                  LET g_sfq[i].sfq04 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i501_sfq03_chk()處理 
              #CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod #FUN-C70014 add sfq014
               LET l_sfq03 = l_qty1 - l_qty2
              #IF g_sma.sma129='N' THEN
               IF g_sma.sma129='N' AND g_sfp.sfp06 <> 'D' THEN   #FUN-C70014 add g_sfp.sfp06 <> 'D' 
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081
                                      FROM sfb_file
                                     WHERE sfb01=g_sfq[i].sfq02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_sfq03 = l_sfb081
               END IF
               IF cl_null(l_sfq03_o) THEN
                  LET l_sfq03_o =0
               END IF
               IF l_sfq03+g_sfq[i].sfq03-l_sfq03_o > l_sfb08 OR 
                  (g_sfp.sfp06 = 'D' AND l_sfq03+g_sfq[i].sfq03-l_sfq03_o > l_shm08) THEN  #FUN-C70014 add  
                  CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                  NEXT FIELD sfq03       
               END IF
               
            END IF
            IF g_sfp.sfp06='6' THEN
               SELECT sfb081,sfb09 INTO qty1,qty2 FROM sfb_file
                  WHERE sfb01 = g_sfq[i].sfq02
               IF SQLCA.sqlcode THEN
                  LET g_sfq[i].sfq03 = 0
               ELSE
                  LET g_sfq[i].sfq03 = qty1 - qty2
                  IF g_sfq[i].sfq03 < 0 THEN
                     LET g_sfq[i].sfq03 = 0
                  END IF
               END IF
               DISPLAY BY NAME g_sfq[i].sfq03
            END IF
           #IF (g_sfp.sfp06 NOT MATCHES '[16ABC]') THEN    #TQC-CA0035 mark
            IF (g_sfp.sfp06 NOT MATCHES '[16ABCD]') THEN   #TQC-CA0035 add D
               LET g_sfq[i].sfq03=0
            END IF
 
            LET g_sfq[i].sfq08=g_sfq[i].sfq03
            DISPLAY g_sfq[i].sfq08 TO sfq08
            IF g_sfp.sfp06 ='1' THEN 
               IF g_sfq[i].sfq03 <=0 THEN
                  CALL cl_err(g_sfq[i].sfq03,'asf-706',0)
                  NEXT FIELD sfq03 
               END IF
            END IF
         END IF   
         IF g_sfp.sfp06 = 'D' THEN #FUN-C70014 add
            IF NOT i501_chk_sfq(i,'1') THEN NEXT FIELD sfq012 END IF  #FUN-C70014 add 
         END IF 
#FUN-B20095 ---------------------End---------------------------         
      AFTER FIELD sfq04
 
         IF cl_null(g_sfq[i].sfq04) THEN
            LET g_sfq[i].sfq04 = ' '
         ELSE                                      
            CALL i501_sfq04(g_sfq[i].sfq04) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfq[i].sfq04,g_errno,1)
               NEXT FIELD sfq04
            END IF
         END IF
#MOD-D50151---begin
         IF cl_null(g_sfq[i].sfq05) THEN 
            LET g_sfq[i].sfq05 = g_sfp.sfp02
         END IF 
         IF NOT cl_null(g_sfq[i].sfq02) AND (NOT cl_null(g_sfq[i].sfq04) OR g_sfq[i].sfq04 = ' ') AND NOT cl_null(g_sfq[i].sfq05) THEN 
              FOR l_i = 1 TO g_sfq.getLength()
                 IF l_i <> i AND g_sfq[i].sfq02 = g_sfq[l_i].sfq02 AND g_sfq[i].sfq04 = g_sfq[l_i].sfq04 AND g_sfq[i].sfq05 = g_sfq[l_i].sfq05 THEN 
                    CALL cl_err ('','asf-245',0)
                    NEXT FIELD sfq04
                 END IF 
              END FOR 
         END IF 
#MOD-D50151---end
         #IF g_sfp.sfp06 MATCHES '[1]' THEN #MOD-640419 '[16]' -> '[1]'
         IF g_sfp.sfp06 MATCHES '[1D]' THEN #FUN-C70014 add 'D'
            #FUN-C70014 add begin-----------
            IF g_sfp.sfp06 = 'D' THEN
                #取得Run Card生產數量 
                SELECT shm08 INTO l_shm08 FROM shm_file 
                 WHERE shm01 = g_sfq[i].sfq014 
                IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
            END IF 
            #FUN-C70014 add end-------------
            IF g_sma.sma129='N' AND g_sfp.sfp06 <> 'D' THEN #FUN-C70014 add g_sfp.sfp06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                   FROM sfb_file 
                                  WHERE sfb01=g_sfq[i].sfq02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET qty1=l_sfb081
               LET qty2=0
               LET unissue_qty = l_sfb08 - l_sfb081
            ELSE
               LET qty1 = 0
               LET qty2 = 0

            #將撈取qty1,qty2的部分整理到函數 i501_sfq03_chk1()處理
             # CALL i501_sfq03_chk1(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012)  #FUN-A70095  #只选过账的,用于预设值
               CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'1')  #FUN-A70095  #FUN-BC0060 mod  #FUN-C70014 add sfq014
                    RETURNING qty1,qty2        #FUN-A70095
         #此段功能由i501_sfq03_chk1()代替
         #FUN-A70095 ---------------Begin----------------------
         #     IF g_sfq[i].sfq04 != ' ' THEN             #MOD-A30070               
         #       SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
         #        WHERE sfq02=g_sfq[i].sfq02 
         #       #  AND sfq04=g_sfq[i].sfq04                   #MOD-A30070
         #          AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')  #MOD-A30070  #FUN-AC0074 #TQC-B60349 restore
         #          AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
         #       #  AND sfq04=g_sfq[i].sfq04   #FUN-AC0074 TQC-B60349 mark
         #       
         #       SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
         #        WHERE sfq02=g_sfq[i].sfq02 
         #       #  AND sfq04=g_sfq[i].sfq04                   #MOD-A30070
         #          AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')  #MOD-A30070 #FUN-AC0074  #TQC-B60349 restore
         #          AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
         #       #  AND sfq04=g_sfq[i].sfq04   #FUN-AC0074  #TQC-B60349 mark
         #     #MOD-A30070 --BEGIN--
         #     ELSE
         #       SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
         #        WHERE sfq02=g_sfq[i].sfq02 
         #          AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
         #        # AND sfq04=' ' #FUN-AC0074 #TQC-B60349  mark
         #     
         #       SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
         #        WHERE sfq02=g_sfq[i].sfq02 
         #          AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y' 
         #      #   AND sfq04=' ' #FUN-AC0074  #TQC-B60349 mark
         #     END IF  
         #     #MOD-A30070 --END
         #FUN-A70095 ---------------End-----------------------
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)
               IF g_sfp.sfp06 = 'D' THEN LET unissue_qty = l_shm08-(qty1-qty2) END IF #FUN-C70014 add
            END IF
            #    成套發料：
            #    1.若工單作業群組=3.DS或4.ASS
            #      1.1若預計生產數量(sfbiicd04) <> 0, 則用預計生產數量控卡發料數
            #      1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
            #         則用生產數量控卡發料數
            #    2.其他: 比照標準作法 
            IF l_ecdicd01 MATCHES '[34]' THEN
               IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                  LET unissue_qty = l_sfbiicd04-(qty1-qty2)
               ELSE
                  LET unissue_qty = l_sfb08-(qty1-qty2)
               END IF
            ELSE
               LET unissue_qty = l_sfb08-(qty1-qty2)
            END IF
 
            IF (g_sfq[i].sfq03 IS NULL OR
               (l_sfq02_t IS NULL OR l_sfq02_t != g_sfq[i].sfq02)) AND
               l_sfq03_flag = 'N' THEN   #FUN-B20095 add l_sfq03_flag
               IF g_argv1='1' THEN
                  LET g_sfq[i].sfq03 = unissue_qty
               ELSE
                  LET g_sfq[i].sfq03 = qty1-qty2
               END IF
            END IF
            IF g_sfq[i].sfq03 = 0 THEN
               IF g_argv1='1' THEN 
                  IF g_sma.sma129 = 'Y' THEN
                     LET g_sfq[i].sfq03 = unissue_qty
                  END IF
               ELSE
                  LET g_sfq[i].sfq03 = qty1-qty2 
               END IF
            END IF   
            #---Add No.MOD-AB0071  将AFTER FIELD sfq03的逻辑复制过来
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = g_sfq[i].sfq02
            LET l_sfq03 = 0
            LET l_sfq03_r = 0
            IF cl_null(g_sfq[i].sfq04) THEN
               LET g_sfq[i].sfq04 = ' '
            END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i501_sfq03_chk()處理        #FUN-B20095
              #CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012)  RETURNING l_qty1,l_qty2    #FUN-B20095 #只要有效存在於發料當中的,用于控管
               CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'2')  RETURNING l_qty1,l_qty2    #FUN-B20095  #FUN-BC0060 mod #FUN-C70014 add sfq014
#FUN-B20095 ---------------------------Begin-----------------------
        #   IF g_sfq[i].sfq04 != ' ' THEN
        #      SELECT SUM(sfq03) INTO l_qty1 FROM sfq_file, sfp_file
        #       WHERE sfq02=g_sfq[i].sfq02
        #         AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')        #FUN-AC0074  #TQC-B60349 restore
        #         AND sfq01=sfp01 AND sfp06='1' AND sfpconf !='X'
        #       #  AND sfq04=g_sfq[i].sfq04   #FUN-AC0074 #TQC-B60349 mark
        #      SELECT SUM(sfq03) INTO l_qty2 FROM sfq_file, sfp_file
        #       WHERE sfq02=g_sfq[i].sfq02
        #         AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')        #FUN-AC0074 #TQC-B60349 restore
        #         AND sfq01=sfp01 AND sfp06='6' AND sfpconf !='X'
        #      #   AND sfq04=g_sfq[i].sfq04   #FUN-AC0074 #TQC-B60349 mark
        #   ELSE
        #      SELECT SUM(sfq03) INTO l_qty1 FROM sfq_file, sfp_file
        #       WHERE sfq02=g_sfq[i].sfq02
        #         AND sfq01=sfp01 AND sfp06='1' AND sfpconf !='X'
        #      #   AND sfq04=' ' #FUN-AC0074 #TQC-B60349 mark
        #      SELECT SUM(sfq03) INTO l_qty2 FROM sfq_file, sfp_file
        #       WHERE sfq02=g_sfq[i].sfq02
        #         AND sfq01=sfp01 AND sfp06='6' AND sfpconf !='X'
        #       #  AND sfq04=' ' #FUN-AC0074  #TQC-B60349 mark
        #   END IF
        #   IF l_qty1 IS NULL THEN LET l_qty1=0 END IF
        #   IF l_qty2 IS NULL THEN LET l_qty2=0 END IF
#FUN-B20095 ---------------------------End--------------------------
            LET l_sfq03 = l_qty1 - l_qty2
           #IF g_sma.sma129='N' THEN    #FUN-C70014 mark
            IF g_sma.sma129='N' AND g_sfp.sfp06 <> 'D' THEN   #FUN-C70014 add g_sfp.sfp06 <> 'D' 
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081
                                   FROM sfb_file
                                  WHERE sfb01=g_sfq[i].sfq02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET l_sfq03 = l_sfb081
            END IF
            IF cl_null(l_sfq03_o) THEN
               LET l_sfq03_o =0
            END IF
            IF l_sfq03+g_sfq[i].sfq03-l_sfq03_o > l_sfb08 OR     #No.MOD-860012
              (g_sfp.sfp06 = 'D' AND l_sfq03+g_sfq[i].sfq03-l_sfq03_o > l_shm08) THEN  #FUN-C70014 add  
               CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
               NEXT FIELD sfq03                          #No.MOD-860012
            END IF
            #End Add No.MOD-AB0071

         END IF
          
         IF g_sfp.sfp06='6' THEN
           #IF cl_null(g_sfq[i].sfq012) THEN LET g_sfq[i].sfq012=' ' END IF #TQC-BC0130  #MOD-C80256 mark 
           #CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'2') RETURNING a_qty1,a_qty2 #TQC-BC0130  #FUN-C70014 add sfq014  #MOD-C80256 mark
            SELECT sfb081,sfb09 INTO qty1,qty2 FROM sfb_file
               WHERE sfb01 = g_sfq[i].sfq02
            IF SQLCA.sqlcode THEN
               LET g_sfq[i].sfq03 = 0
            ELSE
               IF cl_null(g_sfq[i].sfq03) THEN   #MOD-C50095 add
                #LET qty2=qty2+a_qty2 #TQC-BC0130  #MOD-C80256 mark
                 #MOD-D30121---begin
                 IF NOT cl_null(g_sfq[i].sfq04) AND g_sfq[i].sfq04 <> ' ' AND g_sma.sma73 = 'Y' THEN
                    IF cl_null(g_sfq[i].sfq012) THEN LET g_sfq[i].sfq012 = ' ' END IF 
                    SELECT MIN(sfa013) INTO l_sfa013
                      FROM sfa_file
                     WHERE sfa01 = g_sfq[i].sfq02
                       AND sfa08 = g_sfq[i].sfq04
                       AND sfa012 = g_sfq[i].sfq012
                    IF cl_null(l_sfa013) THEN LET l_sfa013 = 0 END IF 
                    LET l_cnt=0  
                    CALL s_minp_routing(g_sfq[i].sfq02,g_sma.sma73,0,g_sfq[i].sfq04,g_sfq[i].sfq012,l_sfa013)
                         RETURNING l_cnt,qty1

                    SELECT ecm311+ecm312+ecm313+ecm314+ecm316+ecm321-ecm322 INTO qty2
                      FROM ecm_file
                     WHERE ecm01 = g_sfq[i].sfq02
                       AND ecm04 = g_sfq[i].sfq04
                       AND ecm012 = g_sfq[i].sfq012
                 END IF  
                 #MOD-D30121---end
                 LET g_sfq[i].sfq03 = qty1 - qty2
                 IF g_sfq[i].sfq03 < 0 THEN
                    LET g_sfq[i].sfq03 = 0
                 END IF
               END IF                            #MOD-C50095 add
            END IF
            DISPLAY BY NAME g_sfq[i].sfq03
         END IF
 
        #IF (g_sfp.sfp06 NOT MATCHES '[16ABC]') THEN  #FUN-5C0114 add ABC #TQC-CA0035 mark
         IF (g_sfp.sfp06 NOT MATCHES '[16ABCD]') THEN   #TQC-CA0035 add D
            LET g_sfq[i].sfq03=0
         END IF
 
         IF (NOT cl_null(g_sfq[i].sfq04)) AND (g_sfp.sfp06 MATCHES '[ABC]') THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM eci_file WHERE eci01=g_sfq[i].sfq04
                                                       AND eciacti='Y'
            IF l_cnt=0 THEN
               CALL cl_err('',100,1)
               LET g_sfq[i].sfq04=''
               DISPLAY g_sfq[i].sfq04 TO sfq04
               NEXT FIELD sfq04
            END IF
         END IF
         LET g_sfq[i].sfq08=g_sfq[i].sfq03
         DISPLAY g_sfq[i].sfq08 TO sfq08
        #MOD-AA0123---add---start---
         IF g_sfp.sfp06 ='1' THEN 
            IF g_sfq[i].sfq03 <=0 THEN
               CALL cl_err(g_sfq[i].sfq03,'asf-706',0)
               NEXT FIELD sfq03 
            END IF
         END IF
        #MOD-AA0123---add---end---
         IF g_sfp.sfp06 = 'D' THEN #FUN-C70014 add
            IF NOT i501_chk_sfq(i,'1') THEN NEXT FIELD sfq04 END IF  #FUN-C70014 add
         END IF 
 
      AFTER FIELD sfq05
#MOD-D50151---begin
         IF NOT cl_null(g_sfq[i].sfq02) AND (NOT cl_null(g_sfq[i].sfq04) OR g_sfq[i].sfq04 = ' ') AND NOT cl_null(g_sfq[i].sfq05) THEN 
              FOR l_i = 1 TO g_sfq.getLength()
                 IF l_i <> i AND g_sfq[i].sfq02 = g_sfq[l_i].sfq02 AND g_sfq[i].sfq04 = g_sfq[l_i].sfq04 AND g_sfq[i].sfq05 = g_sfq[l_i].sfq05 THEN 
                    CALL cl_err ('','asf-245',0)
                    NEXT FIELD sfq05
                 END IF 
              END FOR 
         END IF 
#MOD-D50151---end
         IF (NOT g_sfq[i].sfq05 IS NULL) AND (g_sfp.sfp06 MATCHES '[ABC]') THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM sre_file
                                              WHERE sre03=g_sfq[i].sfq04
                                                AND sre04=g_sfq[i].sfq02
                                                AND sre06=g_sfq[i].sfq05
            IF l_cnt=0 THEN
               CALL cl_err('chk sre',100,1)
               LET g_sfq[i].sfq05=''
               DISPLAY g_sfq[i].sfq05 TO sfq05
               NEXT FIELD sfq05
            END IF
            SELECT sre051 INTO g_sfq[i].sfq07 FROM sre_file
             WHERE sre01 =  YEAR(g_sfq[i].sfq05)
               AND sre02 =  MONTH(g_sfq[i].sfq05)
               AND sre03 =  g_sfq[i].sfq04
               AND sre04 =  g_sfq[i].sfq02
               AND sre06 =  g_sfq[i].sfq05 
            IF SQLCA.sqlcode THEN
               LET g_sfq[i].sfq07 = ' '
            END IF
            DISPLAY BY NAME g_sfq[i].sfq07      
         END IF
         IF g_sfp.sfp06 = 'D' THEN #FUN-C70014 add
            IF NOT i501_chk_sfq(i,'1') THEN NEXT FIELD sfq05 END IF  #FUN-C70014 add
         END IF 
      
      AFTER FIELD sfq07
        IF NOT cl_null(g_sfq[i].sfq07) THEN
           SELECT COUNT(*) INTO g_cnt FROM bma_file
            WHERE bma06 = g_sfq[i].sfq07
              AND bma01 = g_sfq[i].sfq02
           IF g_cnt = 0 THEN
              CALL cl_err(g_sfq[i].sfq07,"abm-618",0)
              NEXT FIELD sfq07
           END IF
        END IF
                       
 
      BEFORE FIELD sfq03
        #IF g_sfp.sfp06 MATCHES '[1]' THEN 
         IF g_sfp.sfp06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D' 
            LET qty1 = 0
            LET qty2 = 0
            IF cl_null(g_sfq[i].sfq04) THEN
               LET g_sfq[i].sfq04 = ' '
            END IF
        #FUN-A70095 --------Begin----------   
            IF cl_null(g_sfq[i].sfq012) THEN
               LET g_sfq[i].sfq012 = ' ' 
            END IF
        #FUN-A70095 --------End------------
            #FUN-C70014 add begin-----------
            IF g_sfp.sfp06 = 'D' THEN
               #取得Run Card生產數量 
               SELECT shm08 INTO l_shm08 FROM shm_file 
                WHERE shm01 = g_sfq[i].sfq014 
               IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
            END IF 
            #FUN-C70014 add end-------------
           #IF g_sma.sma129='N' THEN
            IF g_sma.sma129='N' AND g_sfp.sfp06 <> 'D' THEN #FUN-C70014 g_sfp.sfp06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                   FROM sfb_file 
                                  WHERE sfb01=g_sfq[i].sfq02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET qty1=l_sfb081
               LET qty2=0
               LET unissue_qty = l_sfb08 - l_sfb081
            ELSE
            #將撈取qty1,qty2的部分整理到函數 i501_sfq03_chk1()處理  
              #CALL i501_sfq03_chk1(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012)  #FUN-A70095  #只选过账的,用于预设值
               CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'1')  #FUN-A70095  #FUN-BC0060 mod  #FUN-C70014 add sfq014
                    RETURNING qty1,qty2        #FUN-A70095              
         #此段功能由i501_sfq03_chk1()代替
         #FUN-A70095 ----------------Begin----------------------   
         #    IF g_sfq[i].sfq04 != ' ' THEN  #MOD-A30070
         #     SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
         #      WHERE sfq02=g_sfq[i].sfq02 
         #    #   AND sfq04=g_sfq[i].sfq04                   #MOD-A30070
         #        AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')  #MOD-A30070  #FUN-AC0074  #TQC-B60349 restore
         #        AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
         #    #    AND sfq04=g_sfq[i].sfq04   #FUN-AC0074  #TQC-B60349 mark
         #     SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
         #      WHERE sfq02=g_sfq[i].sfq02 
         #    #   AND sfq04=g_sfq[i].sfq04                   #MOD-A30070
         #        AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')  #MOD-A30070  #FUN-AC0074 #TQC-B60349 restore
         #        AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
         #     #   AND sfq04=g_sfq[i].sfq04   #FUN-AC0074   #TQC-B60349 mark
#MOD-A30070 --BEGIN--
         #   ELSE
         #     SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
         #      WHERE sfq02=g_sfq[i].sfq02
         #        AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
         #    #    AND sfq04=' ' #FUN-AC0074  #TQC-B60349 mark

         #     SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
         #      WHERE sfq02=g_sfq[i].sfq02
         #        AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
         #    #    AND sfq04=' ' #FUN-AC0074  #TQC-B60349 mark
         #   END IF 
#MOD-A30070 --END--
         #FUN-A70095 ----------------End----------------------
               
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)
               IF g_sfp.sfp06 = 'D' THEN LET unissue_qty = l_shm08-(qty1-qty2) END IF  #FUN-C70014 add 
            END IF
            IF (g_sfq[i].sfq03 IS NULL OR
               (l_sfq02_t IS NULL OR l_sfq02_t != g_sfq[i].sfq02)) AND 
               l_sfq03_flag = 'N' THEN    #FUN-B20095 add l_sfq03_flag
               IF g_argv1='1' THEN  
                  LET g_sfq[i].sfq03 = unissue_qty
               ELSE
                  LET g_sfq[i].sfq03 = qty1-qty2
               END IF
            END IF
            IF g_sfq[i].sfq03 = 0 THEN
               IF g_argv1='1' THEN
                  IF g_sma.sma129 = 'Y' THEN
                     LET g_sfq[i].sfq03 = unissue_qty
                  END IF   
               ELSE  
                  LET g_sfq[i].sfq03 = qty1-qty2
               END IF
            END IF
         END IF
         #MOD-BA0017 -- begin --
         IF g_sfp.sfp06 = '6' THEN
            LET l_sfq03_t = g_sfq[i].sfq03
         END IF
         #MOD-BA0017 -- end --
         IF cl_null(l_sfq03_o) THEN     
            LET l_sfq03_o =0
         ELSE           #TQC-B70170 
            LET l_sfq03_o = l_sfq03_t   #TQC-B70170
         END IF
 
 
      AFTER FIELD sfq03
         IF NOT cl_null(g_sfq[i].sfq03) THEN
            IF g_sfp.sfp06 MATCHES '[ABC]' THEN
               LET l_qty=0
               IF NOT cl_null(g_sfq[i].sfq05) THEN
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=g_sfq[i].sfq04
                                                 AND sre04=g_sfq[i].sfq02
                                                 AND sre06=g_sfq[i].sfq05
                                                 AND sre07 IS NOT NULL
               ELSE
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=g_sfq[i].sfq04
                                                 AND sre04=g_sfq[i].sfq02
                                                 AND sre07 IS NOT NULL
               END IF
               IF g_sfq[i].sfq03>l_qty THEN
                  LET l_str="tot:",l_qty
                  CALL cl_err(l_str,"asr-008",1)
               END IF
            END IF
 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = g_sfq[i].sfb05
            #MOD-D50233---begin
            SELECT sfb02 INTO l_sfb02
              FROM sfb_file
              WHERE sfb01=g_sfq[i].sfq02
            #MOD-D50233---end
            IF l_ima56 <> 1 THEN
               #MOD-D40218---begin
               #LET l_faqty = g_sfq[i].sfq03 MOD l_ima56
               LET l_qty1 = g_sfq[i].sfq03 * 1000
               LET l_qty2 = l_ima56 * 1000
               LET l_faqty = l_qty1 MOD l_qty2
               #MOD-D40218---end
               IF  l_faqty <> 0 THEN
                   CALL CL_err(g_sfq[i].sfq03,'asf-898',0)
                   IF l_sfb02 <> 5 AND l_sfb02 <> 8 THEN   #MOD-D50233
                      NEXT FIELD sfq03
                   END IF  #MOD-D50233
               END IF
            ELSE
               LET l_per = g_sfq[i].sfq03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> g_sfq[i].sfq03 THEN
                  CALL CL_err(g_sfq[i].sfq03,'asf-898',0)
                  IF l_sfb02 <> 5 AND l_sfb02 <> 8 THEN   #MOD-D50233
                     NEXT FIELD sfq03
                  END IF  #MOD-D50233
               END IF
            END IF
  
            IF g_sfp.sfp06 ='1' AND g_sfq[i].sfq03 > unissue_qty THEN
               CALL cl_err('sfq03>un_issue:','asf-351',0) NEXT FIELD sfq03
            END IF
    
           #str MOD-A30065 add
           #新增時不在此段自動產生單身
            IF g_action_choice="insert" THEN
               LET g_flag_sfq03 = 0
            ELSE
           #end MOD-A30065 add
               IF cl_null(g_sfq[i].sfq03) THEN LET g_sfq[i].sfq03 = 0 END IF #TQC-990094
               IF cl_null(l_sfq03_t) THEN LET l_sfq03_t = 0 END IF           #TQC-990094           
              #IF g_sfp.sfp06 ='1' AND g_sfq[i].sfq03 <> l_sfq03_t THEN                #MOD-C50095 mark
              #IF g_sfp.sfp06 MATCHES '[16]' AND g_sfq[i].sfq03 <> l_sfq03_t THEN      #MOD-C50095 add   
               IF g_sfp.sfp06 MATCHES '[16D]' AND g_sfq[i].sfq03 <> l_sfq03_t THEN      #MOD-C50095 add   #TQC-CA0045 add
                  LET g_flag_sfq03 = 1 
               END IF
            END IF   #MOD-A30065 add
 
           #IF g_sfp.sfp06 ='6' AND g_sfq[i].sfq03 > (qty1-qty2) THEN    #MOD-BA0078 mark
            #MOD-BA0078 -- begin --
            LET l_ima153 = 0
            LET l_sfb08 = 0
            CALL s_get_ima153(g_sfq[i].sfb05) RETURNING l_ima153
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = g_sfq[i].sfq02
            LET l_allowqty = (qty1-qty2) + l_sfb08 * (l_ima153/100)
            IF g_sfp.sfp06 ='6' AND g_sfq[i].sfq03 > l_allowqty THEN
            #MOD-BA0078 -- end --
              #CALL cl_err('sfq03>issued:','asf-086',0) NEXT FIELD sfq03 #MOD-640419
              #MOD-B30647---modify---start---
              #CALL cl_err('sfq03>issued:','asf-086',0) NEXT FIELD sfq03 #MOD-640419
               CALL cl_err('sfq03>issued:','asf-086',0)
               LET g_sfq[i].sfq03 = l_sfq03_t
               NEXT FIELD sfq03
              #MOD-B30647---modify---end---
            END IF
 
            IF g_sfp.sfp06='3' THEN
               LET g_sfq[i].sfq03=0
            END IF
 
            IF g_sfp.sfp06 = '6' THEN    #成套退料
              #IF g_sfq[i].sfq03 <= 0 THEN NEXT FIELD sfq03 END IF   #MOD-BA0017 mark
#MOD-BA0017 -- begin --
               IF g_sfq[i].sfq03 <= 0 THEN
                  CALL cl_err(g_sfq[i].sfq03,'asf-685',0)
                  LET g_sfq[i].sfq03 = l_sfq03_t
                  NEXT FIELD sfq03
               END IF
#MOD-BA0017 -- end --
              #MOD-BA0078 -- mark begin 上面註記處已有判斷 --
              #SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
              # WHERE sfb01 = g_sfq[i].sfq02
              #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              #IF g_sfq[i].sfq03 > l_qty THEN
              #   CALL cl_err(g_sfq[i].sfq03,'asf-705',0)
              #   NEXT FIELD sfq03
              #END IF
              #MOD-BA0078 -- mark end --
            END IF
 
           #IF g_sfp.sfp06 = '1' THEN    #成套發料
            IF g_sfp.sfp06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'  新增Run Card成套發料
               #FUN-C70014 add begin-----------
               IF g_sfp.sfp06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = g_sfq[i].sfq014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               SELECT sfb08,sfbiicd04,ecdicd01 
                 INTO l_sfb08,l_sfbiicd04,l_ecdicd01 
                 FROM sfb_file
                      ,sfbi_file LEFT OUTER JOIN ecd_file ON sfbiicd09 = ecd01          #09/10/21 xiaofeizhu Add
                WHERE sfb01 = g_sfq[i].sfq02
                  AND sfbi01=sfb01
               LET l_sfq03 = 0
               LET l_sfq03_r = 0
 
              #str MOD-A70046 mod
              #DECLARE i501_cs2 CURSOR FOR
              #    SELECT SUM(sfq03) FROM sfp_file,sfq_file
              #     WHERE sfp06='1'
              #       AND sfp01=sfq01
              #       AND sfq02=g_sfq[i].sfq02
              #       AND sfpconf !='X'     #No:7741 #FUN-660106
              #     GROUP BY sfq04
              #     ORDER BY sfq03 DESC
              # 
              #FOREACH i501_cs2 INTO l_sfq03
              #   IF STATUS THEN LET l_sfq03=0 END IF
              #   EXIT FOREACH
              #END FOREACH
              # 
              #IF cl_null(l_sfq03) THEN
              #   LET l_sfq03 = 0
              #END IF
              # 
              #DECLARE i501_cs13 CURSOR FOR
              # SELECT SUM(sfq03) FROM sfp_file,sfq_file
              #  WHERE sfp06='6' AND sfp01=sfq01
              #    AND sfq02= g_sfq[i].sfq02
              #    AND sfpconf !='X'     #No:7741 #FUN-660106
              #  GROUP BY sfq04
              #  ORDER BY sfq03 DESC
              # 
              #FOREACH i501_cs13 INTO l_sfq03_r
              #   IF STATUS THEN LET l_sfq03_r=0 END IF
              #   EXIT FOREACH
              #END FOREACH
              # 
              #IF cl_null(l_sfq03_r) THEN LET l_sfq03_r = 0 END IF
              #LET l_sfq03 = l_sfq03 - l_sfq03_r          #成套發料-成套退料
               IF cl_null(g_sfq[i].sfq04) THEN 
                  LET g_sfq[i].sfq04 = ' ' 
               END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(g_sfq[i].sfq012) THEN
                  LET g_sfq[i].sfq012 = ' '
               END IF 
           #將撈取l_qty1,l_qty2的部分整理到函數 i501_sfq03_chk()處理
              #CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012)  RETURNING l_qty1,l_qty2    #只要有效存在於發料當中的,用于控管
               CALL i501_sfq03_chk(g_sfq[i].sfq02,g_sfq[i].sfq04,g_sfq[i].sfq012,g_sfq[i].sfq014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add sfq014
           #FUN-B20095 --------End--------------
    #此段功能由i501_sfq03_chk()代替
    #FUN-B20095 ------------------Begin---------------------
           #   IF g_sfq[i].sfq04 != ' ' THEN
           #      SELECT SUM(sfq03) INTO l_qty1 FROM sfq_file, sfp_file
           #       WHERE sfq02=g_sfq[i].sfq02 
           #         AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')     #FUN-AC0074 #TQC-B60349 restore
           #         AND sfq01=sfp01 AND sfp06='1' AND sfpconf !='X'
           #       #  AND sfq04=g_sfq[i].sfq04   #FUN-AC0074 TQC-B60349 mark

           #      SELECT SUM(sfq03) INTO l_qty2 FROM sfq_file, sfp_file  
           #       WHERE sfq02=g_sfq[i].sfq02 
           #         AND (sfq04=g_sfq[i].sfq04 OR sfq04 = ' ')     #FUN-AC0074  #TQC-B60349 restore
           #         AND sfq01=sfp01 AND sfp06='6' AND sfpconf !='X'
           #        # AND sfq04=g_sfq[i].sfq04   #FUN-AC0074 #TQC-B60349 mark
           #   ELSE
           #      SELECT SUM(sfq03) INTO l_qty1 FROM sfq_file, sfp_file
           #       WHERE sfq02=g_sfq[i].sfq02 
           #         AND sfq01=sfp01 AND sfp06='1' AND sfpconf !='X'  
           #    #     AND sfq04=' ' #FUN-AC0074  # TQC-B60349 mark

           #      SELECT SUM(sfq03) INTO l_qty2 FROM sfq_file, sfp_file  
           #       WHERE sfq02=g_sfq[i].sfq02 
           #         AND sfq01=sfp01 AND sfp06='6' AND sfpconf !='X' 
           #     #    AND sfq04=' ' #FUN-AC0074    #TQC-B60349 mark
           #   END IF
           #   IF l_qty1 IS NULL THEN LET l_qty1=0 END IF
           #   IF l_qty2 IS NULL THEN LET l_qty2=0 END IF 
    #FUN-B20095 ------------------End------------------------        
               LET l_sfq03 = l_qty1 - l_qty2   
              #end MOD-A70046 mod
 
               #    成套發料：
               #    1若工單作業群組=3.DS或4.ASS
               #     1.1若預計生產數量(sfbiicd04)<>0, 則用預計生產數量控卡發料數 
               #     1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
               #        則用生產數量控卡發料數
               #    2.其他: 比照標準作法 
               IF l_ecdicd01 MATCHES '[34]' THEN
                  IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                     IF g_sfq[i].sfq03 > l_sfbiicd04 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                     END IF
                  ELSE
                     IF g_sfq[i].sfq03 > l_sfb08 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                     END IF
                  END IF 
               ELSE
                  IF g_sfq[i].sfq03 > l_sfb08 THEN
                     CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                  END IF
               END IF
 
               IF g_sma.sma129 = 'N' THEN    #發料不控管套數
                  IF g_sfq[i].sfq03 < 0 THEN
                     CALL cl_err(g_sfq[i].sfq03,'asf-387',0)
                     NEXT FIELD sfq03
                  END IF
               ELSE                          #發料控管套數
                  IF g_sfq[i].sfq03 <=0 THEN
                     CALL cl_err(g_sfq[i].sfq03,'asf-706',0)
                     NEXT FIELD sfq03
                  END IF
               END IF                        #FUN-940039 add
            END IF
 
            LET g_sfq[i].sfq08 = g_sfq[i].sfq03   #FUN-940008 add
            #若sfq03有值且该值合理，则返回sfq012/sfq04/sfq03时不须重给该栏位的预设值
            LET l_sfq03_flag = 'Y'     #FUN-B20095
         END IF
      AFTER FIELD sfqud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD sfqud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CANCEL INSERT
            CALL g_sfq.deleteElement(i)
            EXIT INPUT
         END IF
      AFTER ROW    #FUN-C70014 add
         LET l_count = g_sfq.getLength()    #FUN-C70014  add
 
      AFTER INPUT
         LET l_sfq02_t = g_sfq[i].sfq02
         #FUN-C70014 add begin-------------------
         IF g_sfp.sfp06 = 'D' THEN 
            LET g_success = 'Y'
            CALL s_showmsg_init()
            FOR l_n = 1 TO g_sfq.getLength()
               IF NOT i501_chk_sfq(l_n,'2') THEN 
                  LET g_success = 'N' 
               END IF   
            END FOR 
            IF g_success = 'N' THEN 
               CALL s_showmsg()
               NEXT FIELD sfq014
            END IF 
         END IF 
         #FUN-C70014 add end---------------------
         IF INT_FLAG THEN
            LET INT_FLAG=0
            ROLLBACK WORK           #MOD-B30647 取消mark
            EXIT INPUT              #No.MOD-5A0010
         END IF
 
         IF (g_sfq[i].sfq02 IS NOT NULL) AND (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
           #IF g_sfp.sfp06 = '1' THEN   #成套發料    #MOD-BA0017 mark
            IF g_sfp.sfp06 MATCHES '[16D]' THEN       #MOD-BA0017  #FUN-C70014 add 'D'
               IF g_sma.sma129 = 'Y' THEN
                  IF g_sfq[i].sfq03 = 0 THEN
                     IF g_sfp.sfp06 = '1' OR g_sfp.sfp06 ='D' THEN   #MOD-BA0017 add  #TQC-CA0035 add OR g_sfp.sfp06 ='D'
                        CALL cl_err(g_sfq[i].sfq03,'asf-706',0)
                     #MOD-BA0017 -- begin --
                     ELSE
                        CALL cl_err(g_sfq[i].sfq03,'asf-685',0)
                        LET g_sfq[i].sfq03 = l_sfq03_t
                     END IF
                     #MOD-BA0017 -- end --
                     NEXT FIELD sfq03
                  END IF
               END IF
            END IF
        
            IF g_sfp.sfp06 MATCHES '[16D]' THEN   #FUN-C70014 add 'D'
               SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
                 WHERE sfq02=g_sfq[i].sfq02 AND sfq04=g_sfq[i].sfq04
                   AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
 
                SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
                 WHERE sfq02=g_sfq[i].sfq02 AND sfq04=g_sfq[i].sfq04
                   AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
 
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
 
               LET unissue_qty = l_sfb08-(qty1-qty2)
               #    成套發料：
               #    1若工單作業群組=3.DS或4.ASS
               #     1.1若預計生產數量(sfbiicd04)<>0, 則用預計生產數量控卡發料數
               #     1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
               #        則用生產數量控卡發料數
               #    2.其他: 比照標準作法 
               IF l_ecdicd01 MATCHES '[34]' THEN
                  IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                     LET unissue_qty = l_sfbiicd04-(qty1-qty2)
                  ELSE
                     LET unissue_qty = l_sfb08-(qty1-qty2)
                  END IF 
               ELSE
                  LET unissue_qty = l_sfb08-(qty1-qty2)
               END IF
               IF g_sfq[i].sfq03 IS NULL THEN
                  IF g_argv1='1' THEN
                     LET g_sfq[i].sfq03 = unissue_qty
                  ELSE LET g_sfq[i].sfq03 = qty1-qty2
                  END IF
               END IF
               IF g_sfq[i].sfq03 = 0 THEN
                  IF g_argv1 ='1' THEN
                     IF g_sma.sma129 = 'Y' THEN	
                        LET g_sfq[i].sfq03 = unissue_qty
                     END IF 
                  ELSE
                     LET g_sfq[i].sfq03 = qty1-qty2
                  END IF 
               END IF
            END IF
 
            IF g_sfp.sfp06 NOT MATCHES '[16D]' THEN  #FUN-C70014 add 'D'
               LET g_sfq[i].sfq03=0
            END IF
 
            IF g_sfp.sfp06 = '1' THEN   #成套發料
               LET l_sfq03 = 0
               DECLARE i501_cs3 CURSOR FOR
                SELECT SUM(sfq03) FROM sfp_file,sfq_file
                 WHERE sfp06='1'
                   AND sfp01=sfq01
                   AND sfq02=g_sfq[i].sfq02
                   AND sfpconf !='X' #FUN-660106
                 GROUP BY sfq04
                 ORDER BY sfq03 DESC
 
               FOREACH i501_cs3 INTO l_sfq03
                 IF STATUS THEN LET l_sfq03=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_sfq03) THEN LET l_sfq03 = 0 END IF
               #    成套發料：
               #    1若工單作業群組=3.DS或4.ASS
               #     1.1若預計生產數量(sfbiicd04)<>0, 則用預計生產數量控卡發料數
               #     1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0, 
               #        則用生產數量控卡發料數
               #    2.其他: 比照標準Pkg作法 
               IF l_ecdicd01 MATCHES '[34]' THEN
                  IF NOT cl_null(l_sfbiicd04) AND l_sfbiicd04 <> 0 THEN
                     IF g_sfq[i].sfq03 > l_sfbiicd04 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                        IF FGL_LASTKEY() = 2016 THEN    #ESC
                           LET g_sfq[i].sfq03 = null
                        END IF
                        NEXT FIELD sfq02
                     END IF
                  ELSE
                     IF g_sfq[i].sfq03 > l_sfb08 THEN
                        CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                        IF FGL_LASTKEY() = 2016 THEN    #ESC
                           LET g_sfq[i].sfq03 = null
                        END IF
                        NEXT FIELD sfq02
                     END IF
                  END IF
               ELSE
                  IF g_sfq[i].sfq03 > l_sfb08 THEN
                     CALL cl_err(g_sfq[i].sfq02,'asf-704',0)
                     IF FGL_LASTKEY() = 2016 THEN    #ESC
                        LET g_sfq[i].sfq03 = null
                     END IF
                     NEXT FIELD sfq02
                  END IF
               END IF
            END IF
 
            IF g_sfp.sfp06 = '6' THEN    #成套退料
             #MOD-D30125---begin
               IF NOT cl_null(g_sfq[i].sfq04) AND g_sfq[i].sfq04 <> ' ' AND g_sma.sma73 = 'Y' THEN
                  IF cl_null(g_sfq[i].sfq012) THEN LET g_sfq[i].sfq012 = ' ' END IF 
                  SELECT MIN(sfa013) INTO l_sfa013
                    FROM sfa_file
                   WHERE sfa01 = g_sfq[i].sfq02
                     AND sfa08 = g_sfq[i].sfq04
                     AND sfa012 = g_sfq[i].sfq012
                  IF cl_null(l_sfa013) THEN LET l_sfa013 = 0 END IF 
                  LET l_cnt=0  
                  CALL s_minp_routing(g_sfq[i].sfq02,g_sma.sma73,0,g_sfq[i].sfq04,g_sfq[i].sfq012,l_sfa013)
                       RETURNING l_cnt,l_qty1

                  SELECT ecm311+ecm312+ecm313+ecm314+ecm316+ecm321-ecm322 INTO l_qty2
                    FROM ecm_file
                   WHERE ecm01 = g_sfq[i].sfq02
                     AND ecm04 = g_sfq[i].sfq04
                     AND ecm012 = l_sfq012
                  IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF 
                  LET l_qty = l_qty1 - l_qty2
               ELSE  
               #MOD-D30125---end  
                  SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
                  WHERE sfb01 = g_sfq[i].sfq02
               END IF  #MOD-D30125
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               IF g_sfq[i].sfq03 > l_qty THEN
                  CALL cl_err(g_sfq[i].sfq03,'asf-705',0)
                  NEXT FIELD sfq03
               END IF
 
            END IF
         END IF
 
      ON ACTION controlp
         CASE WHEN INFIELD(sfq02)
                  #g_argv2   1:成套發料 2:超領   3:欠/補料   4.領料
                  #          6.工單成套退料單維護作業
                  #          7.工單超領退料單維護作業
                  #          8.工單一般退料單維護作業
                  #          9.工單領退料維護作業
	           IF g_argv2 MATCHES '[13D]' THEN    #FUN-C70014 add 'D'
                     #IF g_argv2 = 1 THEN              #FUN-940039 add   #FUN-C70014 mark
                      IF g_argv2 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'
                         CALL cl_init_qry_var()
                                LET g_qryparam.where =' 1=1 '  #TQC-CA0045 add
                                LET g_qryparam.form = "q_sfb02_icd"   #CHI-980026
                                LET g_qryparam.arg1 = 234567
                                LET g_qryparam.default1 = g_sfq[i].sfq02
                               #LET g_qryparam.where = "(sfb08 > sfb081 OR ",                         #TQC-CA0045 mark
                                LET g_qryparam.where = g_qryparam.where," AND (sfb08 > sfb081 OR ",   #TQC-CA0045 add
                                                       "  sfbiicd04 > sfb081)"
                         ##組合拆解的工單不顯示出來!
                        #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                         #LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy6 IS NOT NULL) "    #FUN-B40029   #MOD-B60107
                         #LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "    #FUN-B40029   #MOD-B60107 #TQC-C50227
                         #FUN-C70014 add begin------------
                         IF g_argv2 = 'D' AND NOT cl_null(g_sfq[i].sfq014) THEN 
                            LET g_qryparam.where = g_qryparam.where," AND sfb01 IN (SELECT shm012 FROM shm_file WHERE shm01='",g_sfq[i].sfq014,"')"
                         END IF 
                         #FUN-C70014 add end -------------
                         CALL cl_create_qry() RETURNING g_sfq[i].sfq02
                         DISPLAY BY NAME g_sfq[i].sfq02   #No.MOD-490371
                         NEXT FIELD sfq02
                     ELSE
                       LET li_where = " AND sfb87!='X' AND sfb04 IN ('2','3','4','5','6','7') "
                       ##組合拆解的工單不顯示出來!
                       #LET li_where = li_where CLIPPED," AND substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                       #LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0006 mod #TQC-C50227
                       CALL q_short_qty(FALSE,TRUE,g_sfq[i].sfq02,'',li_where,'1') 
                           #RETURNING g_sfq[i].sfq02,l_sfa03,l_sfa08,l_sfa12,l_sfa27                     #TQC-B30021
                            RETURNING g_sfq[i].sfq02,l_sfa03,l_sfa08,l_sfa12,l_sfa27,l_sfa012,l_sfa013   #TQC-B30021
                       DISPLAY g_sfq[i].sfq02 TO sfq02
                       NEXT FIELD sfq02
                     END IF
                 ELSE
                   IF g_sfp.sfp06 MATCHES '[ABC]' THEN
#FUN-AA0059---------mod------------str-----------------
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_ima17" #MOD-630064
#                     LET g_qryparam.default1 = g_sfq[i].sfq02
#                     CALL cl_create_qry() RETURNING g_sfq[i].sfq02
                      CALL q_sel_ima(FALSE, "q_ima17","",g_sfq[i].sfq02,"","","","","",'' ) 
                        RETURNING g_sfq[i].sfq02  
#FUN-AA0059---------mod------------end-----------------
                      DISPLAY BY NAME g_sfq[i].sfq02
                      NEXT FIELD sfq02
                   ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sfb02"
                      LET g_qryparam.arg1 = 234567
                      LET g_qryparam.default1 = g_sfq[i].sfq02
                      CALL cl_create_qry() RETURNING g_sfq[i].sfq02
                      DISPLAY BY NAME g_sfq[i].sfq02
                      NEXT FIELD sfq02
                   END IF
                 END IF
          #FUN-B20095 ---------------Begin-------------------
             WHEN INFIELD(sfq012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfq012" 
                   LET g_qryparam.where = " sfa01 = '",g_sfq[i].sfq02,"'"  
                   LET g_qryparam.default1 = g_sfq[i].sfq012
                   CALL cl_create_qry() RETURNING g_sfq[i].sfq012
                   DISPLAY BY NAME g_sfq[i].sfq012 
                   NEXT FIELD sfq012                      
          #FUN-B20095 ---------------End---------------------             
             WHEN INFIELD(sfq04)
                   IF g_sfp.sfp06 MATCHES '[ABC]' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_eci"
                     LET g_qryparam.default1 = g_sfq[i].sfq04
                     CALL cl_create_qry() RETURNING g_sfq[i].sfq04
                     DISPLAY BY NAME g_sfq[i].sfq04
                   ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfa15"   
                     LET g_qryparam.arg1= g_sfq[i].sfq02  
                     LET g_qryparam.default1 = g_sfq[i].sfq04
                     CALL cl_create_qry() RETURNING g_sfq[i].sfq04
                      DISPLAY BY NAME g_sfq[i].sfq04    #No.MOD-490371
                     NEXT FIELD sfq04
                   END IF
            WHEN INFIELD(sfq07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bma7"
                   LET g_qryparam.default1 = g_sfq[i].sfq07
                   LET g_qryparam.arg1 = g_sfq[i].sfq02
                   CALL cl_create_qry() RETURNING g_sfq[i].sfq07
                   DISPLAY  BY NAME g_sfq[i].sfq07
                   NEXT FIELD sfq07
            #FUN-C70014 add begin-------------------
            WHEN INFIELD(sfq014)
                 IF l_cmd = 'a' THEN
                    CALL g_multi_sfq014.clear()
                    CALL q_shm4(TRUE,TRUE,NULL,g_multi_sfq014[1].*) RETURNING g_multi_sfq014
                    IF g_multi_sfq014.getLength() > 0 AND NOT cl_null(g_multi_sfq014[1].shm01) THEN 
                       CALL i501_multi_sfq014(i)
                       LET l_count = g_sfq.getLength()    #FUN-C70014  add
                       #FUN-C70014 add begin-----------
                       IF i > l_count THEN 
                          LET l_cmd = 'a'
                       ELSE 
                          LET l_cmd = 'u'
                       END IF 
                       #FUN-C70014 add end-------------
                    ELSE 
                       NEXT FIELD sfq014
                    END IF 
                 ELSE 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_shm4"
                    IF NOT cl_null(g_sfq[i].sfq02) THEN 
                       LET g_qryparam.where = " shm012 = '",g_sfq[i].sfq02,"'"
                    END IF 
                    LET g_qryparam.default1 = g_sfq[i].sfq014
                    LET g_qryparam.default2 = g_sfq[i].sfq02
                    LET g_qryparam.default3 = g_sfq[i].sfq04
                    CALL cl_create_qry() RETURNING g_sfq[i].sfq014,g_sfq[i].sfq02,g_sfq[i].sfq04
                    DISPLAY BY NAME g_sfq[i].sfq014
                    DISPLAY BY NAME g_sfq[i].sfq02
                    DISPLAY BY NAME g_sfq[i].sfq04
                    NEXT FIELD sfq014
                 END IF
            #FUN-C70014 add end --------------------
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION CONTROLG     #TQC-CA0045
         CALL cl_cmdask()    #TQC-CA0045
   END INPUT
 
    LET g_sfp.sfpmodu = g_user
    LET g_sfp.sfpdate = g_today
    UPDATE sfp_file SET sfpmodu = g_sfp.sfpmodu,sfpdate = g_sfp.sfpdate
     WHERE sfp01 = g_sfp.sfp01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","sfp_file",g_sfp.sfp01,"",SQLCA.SQLCODE,"","upd sfp",1)  #No.FUN-660128
    END IF
    DISPLAY BY NAME g_sfp.sfpmodu,g_sfp.sfpdate
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
 
   UPDATE sfp_file SET sfpmodu=g_sfp.sfpmodu,
                       sfpdate=g_sfp.sfpdate
    WHERE sfp01=g_sfp.sfp01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","sfp_file",g_sfp.sfp01,"",SQLCA.sqlcode,"","upd sfpmodu",1)  #No.FUN-660128
       LET g_sfp.sfpmodu=g_sfp_t.sfpmodu
       LET g_sfp.sfpdate=g_sfp_t.sfpdate
       DISPLAY BY NAME g_sfp.sfpmodu
       DISPLAY BY NAME g_sfp.sfpdate
       ROLLBACK WORK
   END IF
 
   DELETE FROM sfq_file WHERE sfq01 = g_sfp.sfp01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","sfq_file",g_sfp.sfp01,"",SQLCA.sqlcode,"","del sfq",1)  #No.FUN-660128
      ROLLBACK WORK
      RETURN
   END IF
 
   FOR i = 1 TO g_sfq.getLength()
       IF g_sfq[i].sfq02 IS NULL THEN CONTINUE FOR END IF
       IF g_sfq[i].sfq04 IS NULL THEN LET g_sfq[i].sfq04=' ' END IF
       CALL i501_b_i_move_back(i) #FUN-730075  
       IF g_sma.sma118 = 'N' THEN LET b_sfq.sfq07 = ' ' END IF  #No.FUN-870097      
       IF b_sfq.sfq014 IS NULL THEN LET b_sfq.sfq014=' ' END IF  #FUN-C70014 add 
       INSERT INTO sfq_file VALUES (b_sfq.*)
       IF STATUS THEN
          CALL cl_err3("ins","sfq_file",g_sfp.sfp01,g_sfq[i].sfq02,STATUS,"","ins sfq",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
   END FOR
 
    IF g_flag_sfq03=1 THEN
       IF cl_confirm('asf-919') THEN
          CALL i501_g_b()
          CALL i501_b_fill(" 1=1")
       END IF 
    END IF 
   COMMIT WORK
 
END FUNCTION

#FUN-BC0060 mark
##FUN-B20095 -------------------Begin---------------------
#FUNCTION i501_sfq03_chk(p_sfq02,p_sfq04,p_sfq012)
#DEFINE p_sfq02       LIKE sfq_file.sfq02
#DEFINE p_sfq04       LIKE sfq_file.sfq04
#DEFINE p_sfq012      LIKE sfq_file.sfq012  
#DEFINE l_qty1        LIKE sfq_file.sfq03  
#DEFINE l_qty2        LIKE sfq_file.sfq03 
#DEFINE l_sql1        STRING
#DEFINE l_sql2        STRING 
#DEFINE l_sql         STRING 
#   
#   IF cl_null(p_sfq04) THEN
#      LET p_sfq04 = ' '
#   END IF 
#   IF cl_null(p_sfq012) THEN
#      LET p_sfq012 = ' '
#   END IF
#
#   LET l_sql = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
#               "  WHERE sfq02 = '",p_sfq02,"'",
#               "    AND sfq01 = sfp01 ",
#               "    AND sfpconf !='X'"
#
#   IF NOT cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq04 = '",p_sfq04,"'"," OR (sfq04 = ' ' ", " AND sfq012 = ' ')",
#                                "    OR (sfq04 = ' ' "," AND sfq012 IN (SELECT sfa012 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa08='",p_sfq04,"')))",
#                                "   AND (sfq012= '",p_sfq012,"'"," OR (sfq012 = ' ' ", " AND sfq04 = ' ')",
#                                "    OR (sfq012 = ' ' "," AND sfq04 IN (SELECT sfa08 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa012='",p_sfq012,"')))"
#   END IF
#
#   IF NOT cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq04 = '",p_sfq04,"'"," OR (sfq04 = ' ' ", " AND sfq012 = ' ')",
#                                "    OR (sfq04 = ' ' "," AND sfq012 IN (SELECT sfa012 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa08='",p_sfq04,"')))"
#   END IF
#
#   IF cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq012= '",p_sfq012,"'"," OR (sfq012 = ' ' ", " AND sfq04 = ' ')",
#                                "    OR (sfq012 = ' ' "," AND sfq04 IN (SELECT sfa08 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa012='",p_sfq012,"')))"
#   END IF
#
#   LET l_sql1 = l_sql CLIPPED," AND sfp06 = '1'"
#   PREPARE i501_sfq03_pre FROM l_sql1
#   EXECUTE i501_sfq03_pre INTO l_qty1
#
#   LET l_sql2 = l_sql CLIPPED," AND sfp06 = '6'"
#   PREPARE i501_sfq03_pre1 FROM l_sql2
#   EXECUTE i501_sfq03_pre1 INTO l_qty2
#
#   IF l_qty1 IS NULL THEN LET l_qty1=0 END IF
#   IF l_qty2 IS NULL THEN LET l_qty2=0 END IF
#
#   RETURN l_qty1,l_qty2
#
#END FUNCTION
#
#FUNCTION i501_sfq03_chk1(p_sfq02,p_sfq04,p_sfq012)
#DEFINE p_sfq02       LIKE sfq_file.sfq02
#DEFINE p_sfq04       LIKE sfq_file.sfq04
#DEFINE p_sfq012      LIKE sfq_file.sfq012
#DEFINE l_qty1        LIKE sfq_file.sfq03
#DEFINE l_qty2        LIKE sfq_file.sfq03
#DEFINE l_sql1        STRING 
#DEFINE l_sql2        STRING  
#DEFINE l_sql         STRING    
#
#   IF cl_null(p_sfq04) THEN
#      LET p_sfq04 = ' '
#   END IF
#   IF cl_null(p_sfq012) THEN
#      LET p_sfq012 = ' '
#   END IF
#
#   LET l_sql = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
#               "  WHERE sfq02 = '",p_sfq02,"'",
#               "    AND sfq01 = sfp01 ",
#               "    AND sfp04 ='Y'"
#
#   IF NOT cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq04 = '",p_sfq04,"'"," OR (sfq04 = ' ' ", " AND sfq012 = ' ')",
#                                "    OR (sfq04 = ' ' "," AND sfq012 IN (SELECT sfa012 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa08='",p_sfq04,"')))",
#                                "   AND (sfq012= '",p_sfq012,"'"," OR (sfq012 = ' ' ", " AND sfq04 = ' ')",
#                                "    OR (sfq012 = ' ' "," AND sfq04 IN (SELECT sfa08 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa012='",p_sfq012,"')))"
#   END IF
#
#   IF NOT cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq04 = '",p_sfq04,"'"," OR (sfq04 = ' ' ", " AND sfq012 = ' ')",
#                                "    OR (sfq04 = ' ' "," AND sfq012 IN (SELECT sfa012 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa08='",p_sfq04,"')))"
#   END IF
#
#   IF cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
#      LET l_sql = l_sql CLIPPED,"   AND (sfq012= '",p_sfq012,"'"," OR (sfq012 = ' ' ", " AND sfq04 = ' ')",
#                                "    OR (sfq012 = ' ' "," AND sfq04 IN (SELECT sfa08 FROM sfa_file ",
#                                " WHERE sfa01 = '",p_sfq02,"'"," AND sfa012='",p_sfq012,"')))"
#   END IF
#
#   LET l_sql1 = l_sql CLIPPED,"  AND sfp06 = '1' "
#   PREPARE i501_sfq03_pre2 FROM l_sql1
#   EXECUTE i501_sfq03_pre2 INTO l_qty1
#
#   LET l_sql2 = l_sql CLIPPED,"  AND sfp06 = '6' "
#   PREPARE i501_sfq03_pre3 FROM l_sql2
#   EXECUTE i501_sfq03_pre3 INTO l_qty2
#
#   IF l_qty1 IS NULL THEN LET l_qty1=0 END IF
#   IF l_qty2 IS NULL THEN LET l_qty2=0 END IF
#   RETURN l_qty1,l_qty2
#
#END FUNCTION
##FUN-B20095 -------------------End-----------------------
#FUN-BC0060 mark--end

#FUN-BC0060 add
#FUNCTION i501_sfq03_chk(p_sfq02,p_sfq04,p_sfq012,p_flag)
FUNCTION i501_sfq03_chk(p_sfq02,p_sfq04,p_sfq012,p_sfq014,p_flag)   #FUN-C70014 add p_sfq014
DEFINE p_sfq02       LIKE sfq_file.sfq02
DEFINE p_sfq04       LIKE sfq_file.sfq04
DEFINE p_sfq012      LIKE sfq_file.sfq012
DEFINE p_sfq014      LIKE sfq_file.sfq014      #FUN-C70014 add
DEFINE p_flag        LIKE type_file.chr1                 #抓取的數據來源
DEFINE l_qty1        LIKE sfq_file.sfq03
DEFINE l_qty2        LIKE sfq_file.sfq03
DEFINE l_sql                  STRING
DEFINE l_sql_1,l_sql_2        STRING
DEFINE l_sql_3,l_sql_4        STRING
DEFINE l_sql1                   STRING
DEFINE l_sql1_1,l_sql1_2        STRING
DEFINE l_sql1_3,l_sql1_4        STRING
DEFINE l_sql2                   STRING
DEFINE l_sql2_1,l_sql2_2        STRING
DEFINE l_sql2_3,l_sql2_4        STRING
DEFINE qty1_1,qty1_2  LIKE sfq_file.sfq03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty1_3,qty1_4  LIKE sfq_file.sfq03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_1,qty2_2  LIKE sfq_file.sfq03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_3,qty2_4  LIKE sfq_file.sfq03   #已退按作業編號的套數和已發不按作業編號的套數

   IF cl_null(p_sfq04) THEN
      LET p_sfq04 = ' '
   END IF
   IF cl_null(p_sfq012) THEN
      LET p_sfq012 = ' '
   END IF
   LET l_sql = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
               "  WHERE sfq02 = '",p_sfq02,"'",
               "    AND sfq01 = sfp01 "
   CASE p_flag
       WHEN '1'              #只計算已過帳的
          LET l_sql = l_sql CLIPPED,
                      "    AND sfp04 ='Y'"
       WHEN '2'   #只要有效存在於發料當中的都計算進去
          LET l_sql = l_sql CLIPPED,
                      "    AND sfpconf !='X'"
       OTHERWISE   #只要有效存在於發料當中的都計算進去
          LET l_sql = l_sql CLIPPED,
                      "    AND sfpconf !='X'"
   END CASE

   #FUN-C70014 add begin------Run Card發料時，計算已發和未發套數需要根據Run Card單號查詢
   IF g_argv2 = 'D' AND NOT cl_null(p_sfq014) THEN 
      LET l_sql = l_sql CLIPPED," AND sfq014 = '",p_sfq014,"'"
   END IF 
   #FUN-C70014 add end--------
   
   #工藝段與作業編號都有輸入
   IF NOT cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = l_sql CLIPPED," AND sfq04 = '",p_sfq04,"' ",
                                  " AND sfq012= '",p_sfq012,"'"
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND sfq04 = '",p_sfq04,"' ",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
      #按作業編號空格+工藝段值
      LET l_sql_3 = l_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND sfq012= '",p_sfq012,"'"
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #只輸入了作業編號——可以不考慮工藝段了
   IF NOT cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND sfq04 = '",p_sfq04,"' "
      #按作業編號空格+工藝段值
      LET l_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF
   #只輸入了工藝段——可以不考慮作業編號了
   IF cl_null(p_sfq04) AND NOT cl_null(p_sfq012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段值
      LET l_sql_3 = l_sql CLIPPED," AND sfq012= '",p_sfq012,"'"
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #作業編號和工藝段均未輸入——以作業編號為依據來計算（以工藝段為依據也可以，此處以作業編號）
   IF cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND sfq04 IS NOT NULL AND sfq04 != ' ' "
      #按作業編號空格+工藝段值
      LET l_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF

   ##-------------計算已發-------------##begin
   LET qty1_1 = 0
   LET qty1_2 = 0
   LET qty1_3 = 0
   LET qty1_4 = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(l_sql_1) THEN
     #LET l_sql1_1 = l_sql_1 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_1 = l_sql_1 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i501_sfq03_pre1_1 FROM l_sql1_1
      DECLARE i501_sfq03_curs1_1 CURSOR FOR i501_sfq03_pre1_1
      FOREACH i501_sfq03_curs1_1 INTO qty1_1
           IF STATUS THEN LET qty1_1=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
     #LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      IF cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
         LET l_sql1_2 = l_sql1_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i501_sfq03_pre1_2 FROM l_sql1_2
      DECLARE i501_sfq03_curs1_2 CURSOR FOR i501_sfq03_pre1_2
      FOREACH i501_sfq03_curs1_2 INTO qty1_2
           IF STATUS THEN LET qty1_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(l_sql_3) THEN
     #LET l_sql1_3 = l_sql_3 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_3 = l_sql_3 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i501_sfq03_pre1_3 FROM l_sql1_3
      DECLARE i501_sfq03_curs1_3 CURSOR FOR i501_sfq03_pre1_3
      FOREACH i501_sfq03_curs1_3 INTO qty1_3
           IF STATUS THEN LET qty1_3=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
     #LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 = '1'"
      LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i501_sfq03_pre1_4 FROM l_sql1_4
      DECLARE i501_sfq03_curs1_4 CURSOR FOR i501_sfq03_pre1_4
      FOREACH i501_sfq03_curs1_4 INTO qty1_4
           IF STATUS THEN LET qty1_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty1_1) THEN LET qty1_1=0 END IF
   IF cl_null(qty1_2) THEN LET qty1_2=0 END IF
   IF cl_null(qty1_3) THEN LET qty1_3=0 END IF
   IF cl_null(qty1_4) THEN LET qty1_4=0 END IF
   LET l_qty1 = qty1_1 + qty1_2 + qty1_3 + qty1_4
   ##-------------計算已發-------------##end

   ##-------------計算已退-------------##begin
   LET qty2_1 = 0
   LET qty2_2 = 0
   LET qty2_3 = 0
   LET qty2_4 = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(l_sql_1) THEN
      LET l_sql2_1 = l_sql_1 CLIPPED," AND sfp06 = '6'"
      PREPARE i501_sfq03_pre2_1 FROM l_sql2_1
      DECLARE i501_sfq03_curs2_1 CURSOR FOR i501_sfq03_pre2_1
      FOREACH i501_sfq03_curs2_1 INTO qty2_1
           IF STATUS THEN LET qty2_1=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
      LET l_sql2_2 = l_sql_2 CLIPPED," AND sfp06 = '6' AND sfp01 <> '",g_sfp.sfp01,"' "      #TQC-C20473  AND sfp01 <> '",g_sfp.sfp01,"'
      IF cl_null(p_sfq04) AND cl_null(p_sfq012) THEN
         LET l_sql2_2 = l_sql2_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i501_sfq03_pre2_2 FROM l_sql2_2
      DECLARE i501_sfq03_curs2_2 CURSOR FOR i501_sfq03_pre2_2
      FOREACH i501_sfq03_curs2_2 INTO qty2_2
           IF STATUS THEN LET qty2_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(l_sql_3) THEN
      LET l_sql2_3 = l_sql_3 CLIPPED," AND sfp06 = '6'"
      PREPARE i501_sfq03_pre2_3 FROM l_sql2_3
      DECLARE i501_sfq03_curs2_3 CURSOR FOR i501_sfq03_pre2_3
      FOREACH i501_sfq03_curs2_3 INTO qty2_3
           IF STATUS THEN LET qty2_3=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
      LET l_sql2_4 = l_sql_4 CLIPPED," AND sfp06 = '6' AND sfp01 <> '",g_sfp.sfp01,"' "    #TQC-C20473 AND sfp01 <> '",g_sfp.sfp01,"'
      PREPARE i501_sfq03_pre2_4 FROM l_sql2_4
      DECLARE i501_sfq03_curs2_4 CURSOR FOR i501_sfq03_pre2_4
      FOREACH i501_sfq03_curs2_4 INTO qty2_4
           IF STATUS THEN LET qty2_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty2_1) THEN LET qty2_1=0 END IF
   IF cl_null(qty2_2) THEN LET qty2_2=0 END IF
   IF cl_null(qty2_3) THEN LET qty2_3=0 END IF
   IF cl_null(qty2_4) THEN LET qty2_4=0 END IF
   LET l_qty2 = qty2_1 + qty2_2 + qty2_3 + qty2_4
   ##-------------計算已退-------------##end

   RETURN l_qty1,l_qty2

END FUNCTION
#FUN-BC0060 add--end
 
FUNCTION i501_set_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("sfq03",TRUE)
    END IF
END FUNCTION
 
FUNCTION i501_set_no_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF g_sfp.sfp06 NOT MATCHES '[16ABD]' THEN #FUN-5C0114 add AB #FUN-740232 將3拿掉 #FUN-C70014 add 'D'
       CALL cl_set_comp_entry("sfq03",FALSE)
    END IF
END FUNCTION


#CHI-C50011 str add-----
FUNCTION i501_chk_entry_sfs27()
    IF cl_null(g_sfs[l_ac].sfs26) OR g_sma.sma107='N' THEN  #TQC-C70050 add sma107
       CALL cl_set_comp_entry("sfs27",FALSE)
    ELSE
       CALL cl_set_comp_entry("sfs27",TRUE)
    END IF
END FUNCTION
#CHI-C50011 end add-----

#FUN-A20048  --begin
FUNCTION i501_g_b_1()

  IF g_sfp.sfp06 MATCHES '[1]' THEN RETURN END IF 
#FUN-AC0074 -----------------Begin------------------------  
# OPEN WINDOW i501_g_b_j WITH FORM "asf/42f/asfi501a_1"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED)
# CALL cl_ui_locale("asfi501a_1") 
# INPUT BY NAME sel_all
#              WITHOUT DEFAULTS
#                               
#    AFTER FIELD sel_all
#      IF sel_all NOT MATCHES '[12]' THEN 
#          NEXT FIELD sel_all
#      END IF                             

#    AFTER INPUT
#       IF INT_FLAG THEN
#          EXIT INPUT 
#       END IF
#
#    ON IDLE g_idle_seconds
#       CALL cl_on_idle()
#       CONTINUE INPUT 
#
# END INPUT
# IF INT_FLAG THEN
#    LET INT_FLAG=0
#    CLOSE WINDOW i501_g_b_j
#    CALL i501_b_fill(' 1=1')
#    RETURN
# END IF
# CLOSE WINDOW i501_g_b_j
#FUN-AC0074 -----------------End---------------------
                                 
    IF g_prog = 'asfi510' THEN
      IF g_sfp.sfp06 = '1' THEN LET g_prog = 'asfi511' END IF
      IF g_sfp.sfp06 = '2' THEN LET g_prog = 'asfi512' END IF
      IF g_sfp.sfp06 = '3' THEN LET g_prog = 'asfi513' END IF
      IF g_sfp.sfp06 = '4' THEN LET g_prog = 'asfi514' END IF
   END IF
   IF g_prog = 'asfi520' THEN
      IF g_sfp.sfp06 = '6' THEN LET g_prog = 'asfi526' END IF
      IF g_sfp.sfp06 = '7' THEN LET g_prog = 'asfi527' END IF
      IF g_sfp.sfp06 = '8' THEN LET g_prog = 'asfi528' END IF
      IF g_sfp.sfp06 = '9' THEN LET g_prog = 'asfi529' END IF
   END IF
#  IF sel_all = '1' THEN      #FUN-AC0074
      CALL i501_b()           #FUN-AC0074 
#FUN-AC0074 ---------Begin-----------
#  ELSE                     
#    CALL i501_b_fill_1() 
#    CALL i501_q1()
#    CALL i501_b_fill(' 1=1')
#    call I501_b()     
#  END IF
#FUN-AC0074 ---------End-------------
      
END FUNCTION 
#FUN-A20048 --end 

#FUN-A20048 --begin
#FUN-AC0074 mark(S)
#FUNCTION i501_q1()
# DEFINE i  LIKE type_file.num5 
#  
#       LET g_action_choice = " "
# 
#      INPUT ARRAY g_sib_1 WITHOUT DEFAULTS FROM s_sib_1.*  #顯示並進行選擇
#        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
#                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
#         BEFORE ROW
#              LET l_ac1 = ARR_CURR()
#               IF l_ac1 = 0 THEN
#                  LET l_ac1 = 1
#               END IF
#             CALL fgl_set_arr_curr(l_ac1)
#             CALL cl_show_fld_cont()
#             LET g_sib_t.* = g_sib_1[l_ac1].*
# 
# 
#         AFTER INPUT
#            IF INT_FLAG THEN
#               EXIT INPUT 
#            END IF
#
#         ON CHANGE chk
#            IF cl_null(g_sib_1[l_ac1].chk) THEN 
#               LET g_sib_1[l_ac1].chk = 'Y'
#            END IF
# 
#         ON ACTION ACCEPT  
#            FOR i=1 TO g_rec_b1
#               IF g_sib_1[i].chk = 'Y' THEN 
#                  CALL  i501_g_b01(g_sib_1[i].sib02,'')
#               END IF 
#            END FOR 
#            EXIT INPUT
#  
#            
#         ON ACTION help
#            CALL cl_show_help()
#            EXIT INPUT
# 
#         ON ACTION controlg
#            CALL cl_cmdask()
# 
#         ON ACTION locale
#            CALL cl_dynamic_locale()
#            CALL cl_show_fld_cont()
# 
#         ON ACTION exit
#            LET g_action_choice="exit"
#            EXIT INPUT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#         ON ACTION about
#            CALL cl_about()
# 
#      END INPUT 
#  IF INT_FLAG THEN
#     LET INT_FLAG=0
#     CLOSE WINDOW i501_g_b_q
#     CALL i501_b_fill(' 1=1')
#     RETURN
#  END IF    
#
#  CALL i501_sort_by_partno()
#  LET g_rec_b = g_i
# 
#  CLOSE WINDOW i501_g_b_q
#  DISPLAY ARRAY g_sfs TO s_sfs.*
#    BEFORE DISPLAY 
#      EXIT DISPLAY
#    ON IDLE g_idle_seconds
#      CALL cl_on_idle()
#      CONTINUE DISPLAY
#
#  END DISPLAY 
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION  
#FUN-AC0074 mark(E)
#FUN-A20048 --end 

 
FUNCTION i501_g_b()
  DEFINE l_gen02         LIKE gen_file.gen02    #No.FUN-940039 add
  DEFINE qty1,qty2	 LIKE sfq_file.sfq03    #No.FUN-680121 DEC(15,3)
 #DEFINE l_qty           LIKE sfq_file.sfq03    #NO.FUN-A20048  #FUN-AC0074 mark
  DEFINE l_n             LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE l_cnt           LIKE type_file.num5    #No.MOD-640402  #No.FUN-680121 SMALLINT
  DEFINE l_sfq02         LIKE sfq_file.sfq02
  DEFINE l_i             LIKE type_file.num5    #add FUN-A20048 add
  DEFINE l_sql           STRING #FUN-5C0114
  DEFINE l_date          LIKE type_file.dat     #No.FUN-680121 DATE   #FUN-5C0114 有效日
  DEFINE l_bmb RECORD
                 bmb03   LIKE bmb_file.bmb03,
                 bmb06   LIKE bmb_file.bmb06,
                 bmb07   LIKE bmb_file.bmb07,
                 bmb08   LIKE bmb_file.bmb08,
                 bmb16   LIKE bmb_file.bmb16
               END RECORD
  DEFINE l_sfs930        LIKE sfs_file.sfs930 #FUN-670103
  DEFINE l_sre051    LIKE sre_file.sre051   #No.FUN-870041
  DEFINE l_sfa36     LIKE sfa_file.sfa36    #FUN-950088 add 
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01     #FUN-810038
  DEFINE l_sfbiicd09 LIKE sfbi_file.sfbiicd09   #FUN-810038
  DEFINE l_sfbiicd04 LIKE sfbi_file.sfbiicd04   #FUN-810038
  #DEFINE l_sma894    STRING                     #No.TQC-A50063  #FUN-D30024
  #No.FUN-A70034  --Begin
  DEFINE l_bmb081    LIKE bmb_file.bmb081
  DEFINE l_bmb082    LIKE bmb_file.bmb082
  DEFINE l_total     LIKE sfa_file.sfa05     #总用量
  DEFINE l_QPA       LIKE bmb_file.bmb06     #标准QPA
  DEFINE l_ActualQPA LIKE bmb_file.bmb06     #实际QPA
  #No.FUN-A70034  --End  
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02                   #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03                 #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03
  #FUN-AC0074 (E)
  IF g_sfp.sfp06 MATCHES '[2479C]' THEN RETURN END IF #FUN-5C0114 add C
  IF g_sfp.sfpconf = 'Y'   THEN CALL cl_err('','9023',0) RETURN END IF   #MOD-D60244 add
  LET noqty = 'Y'
  LET short_data = 'N'
  LET part_type = ' '
  LET issue_type = '1'

  #成套發退料時預設為3.由工單指定倉儲批帶出
 #IF g_sfp.sfp06 MATCHES '[16]' THEN LET issue_type = '3' END IF #CHI-A70060 mark
  IF g_sfp.sfp06 MATCHES '[12346789]' THEN LET issue_type = '3' END IF #CHI-A70060
  LET b_part = '0'
  LET e_part = 'Z'
  LET ware_no = NULL #MOD-4A0145
  LET loc_no = NULL  #MOD-4A0145
  LET lot_no = NULL  #MOD-4A0145
  LET gen_no = NULL  #MOD-9C0195 add
  LET gen_all = 'Y'  #FUN-A20048 add
 
  IF g_sfp.sfp06 MATCHES '[ABC]' THEN  #FUN-5C0114
     OPEN WINDOW i501_g_b_w WITH FORM "asr/42f/asri210a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
     CALL cl_ui_locale("asri210a")
  ELSE
     OPEN WINDOW i501_g_b_w WITH FORM "asf/42f/asfi501a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     CALL cl_ui_locale("asfi501a")
  END IF
  #1)當發/退料方式選擇1:依料件主要倉庫/儲位/倉管員發退料時,
  #  指定倉庫,指定儲位,指定倉管員字段變為QBE方式
  #  對應table字段:ima35,ima36,ima23
  #2)當發/退料方式選擇2:依下列指定倉庫/儲位/批號/倉管員發退料時,
  #  則不篩選,指定倉庫,指定儲位字段與原來一致,邏輯也不變,
  #  代表所有備料的發料都指定此倉儲批
  #3)當發/退料方式選擇3:依工單指定倉庫/儲位/倉管員發退料時,
  #  指定倉庫,指定儲位,指定倉管員字段變為QBE方式
  #  對應table字段:sfa30,sfa31,ima23
 
  
  CALL cl_set_comp_entry("lot_no",TRUE)  
  CALL cl_set_comp_entry("noqty,short_data",FALSE)  #MOD-D10040
  #FUN-D30024--mark--str--
  #No.TQC-A50063  
  #LET l_sma894=g_sma.sma894               
  #LET l_sma894=l_sma894.substring(1,1)    
  #IF l_sma894='N' THEN 
  #   LET noqty='N'
  #   LET short_data='N'
  #END IF 
  #No.TQC-A50063  
  #FUN-D30024--mark--end--
  
  INPUT BY NAME b_part,e_part,part_type,issue_type,noqty,
           #    short_data,gen_all                   #No.FUN-A20048 add gen_all   #FUN-AC0074
                short_data        #FUN-AC0074         
                WITHOUT DEFAULTS

     AFTER FIELD b_part
        IF b_part IS NULL THEN LET b_part = '0' DISPLAY BY NAME b_part END IF
     AFTER FIELD e_part
        IF e_part IS NULL THEN LET e_part = 'Z' DISPLAY BY NAME e_part END IF
 
     BEFORE FIELD issue_type
        CALL i501_set_entry_gb()
        IF g_argv1='2' THEN
           LET issue_type = '1'
           DISPLAY BY NAME issue_type
        END IF
        IF part_type = 'Y' THEN
           LET issue_type = '2'
           DISPLAY BY NAME issue_type
        END IF
        #成套發退料時預設為3.由工單指定倉儲批帶出
       #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
        IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
           LET issue_type = '3'
           DISPLAY BY NAME issue_type
        END IF
        CALL i501_set_no_entry_gb()  #MOD-D10040
      ON CHANGE issue_type   #MOD-580337
 
        IF NOT cl_null(issue_type) THEN
           IF issue_type NOT MATCHES '[0123456]' THEN  #FUN-D10073 add 6
              NEXT FIELD issue_type
           END IF
           IF issue_type ='0' THEN EXIT INPUT END IF
           IF issue_type NOT MATCHES '[23]' THEN
              #LET noqty = ' '  #MOD-D10040
              LET noqty = 'N'  #MOD-D10040
           ELSE
              #FUN-D30024--mark--str--
              #IF l_sma894='Y' THEN    #No.TQC-A50063
              #   LET noqty = 'Y'
              #END IF                  #No.TQC-A50063
              #FUN-D30024--mark--end--
           END IF
           IF issue_type NOT MATCHES '[456]' THEN  #FUN-D10073
              #LET short_data = ' '  #MOD-D10040
              LET short_data = 'N'  #MOD-D10040
           ELSE
            #FUN-D30024--mark--str--
            #IF l_sma894='Y' THEN    #No.TQC-A50063
            #  LET short_data = 'Y'
            #END IF                  #No.TQC-A50063
            #FUN-D30024--mark--end--
           END IF
           CALL i501_set_no_entry_gb()
           DISPLAY BY NAME noqty,short_data
        END IF
   
     AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT 
        END IF
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
 
  END INPUT
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW i501_g_b_w
     CALL i501_b_fill(' 1=1')
     RETURN
  END IF
  IF g_prog = 'asfi510' THEN
      IF g_sfp.sfp06 = '1' THEN LET g_prog = 'asfi511' END IF
      IF g_sfp.sfp06 = '2' THEN LET g_prog = 'asfi512' END IF
      IF g_sfp.sfp06 = '3' THEN LET g_prog = 'asfi513' END IF
      IF g_sfp.sfp06 = '4' THEN LET g_prog = 'asfi514' END IF
      IF g_sfp.sfp06 = 'D' THEN LET g_prog = 'asfi519' END IF  #TQC-CA0035 add
   END IF
   IF g_prog = 'asfi520' THEN
      IF g_sfp.sfp06 = '6' THEN LET g_prog = 'asfi526' END IF
      IF g_sfp.sfp06 = '7' THEN LET g_prog = 'asfi527' END IF
      IF g_sfp.sfp06 = '8' THEN LET g_prog = 'asfi528' END IF
      IF g_sfp.sfp06 = '9' THEN LET g_prog = 'asfi529' END IF
   END IF
  IF issue_type='0' THEN
     DELETE FROM sfs_file WHERE sfs01=g_sfp.sfp01
     IF NOT s_del_sfsi(g_sfp.sfp01,'','') THEN END IF   #FUN-B70061         
     DELETE FROM rvbs_file
      WHERE rvbs00 = g_prog
        AND rvbs01 = g_sfp.sfp01
     LET g_rec_b = 0
     CLOSE WINDOW i501_g_b_w
     RETURN
  END IF
 
 
     IF (issue_type = '2' ) OR (g_sfp.sfp06 MATCHES '[ABC]') THEN  #MOD-9C0195 add
        INPUT BY NAME ware_no,loc_no,lot_no,gen_no WITHOUT DEFAULTS
       
        BEFORE INPUT
           IF issue_type = '2' THEN   #MOD-9C0195 add
              CALL cl_set_comp_entry("gen_no",FALSE)
           ELSE
              CALL cl_set_comp_entry("gen_no",TRUE)
           END IF
 
        AFTER FIELD ware_no
           IF NOT cl_null(ware_no) THEN
             #SELECT imd02,imd11 INTO g_buf,l_imd11 FROM imd_file  #MOD-910166 add imd11 #MOD-950232
              SELECT imd02 INTO g_buf FROM imd_file #MOD-950232  
               WHERE imd01=ware_no
                  AND imdacti = 'Y' #MOD-4B0169
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",ware_no,"",STATUS,"","sel imd",1)  #No.FUN-660128
                 NEXT FIELD ware_no
              END IF
              #Add No.FUN-AB0018
              IF NOT s_chk_ware(ware_no) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD ware_no
              END IF
              #End Add No.FUN-AB0018
              DISPLAY g_buf TO imd02
           END IF
        
        AFTER FIELD gen_no 
           IF NOT cl_null(gen_no) THEN
              SELECT gen02 INTO l_gen02 FROM gen_file
               WHERE gen01 = gen_no
                 AND genacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gen_file",gen_no,"",STATUS,"","sel gen",1)
                 NEXT FIELD gen_no
              END IF
              DISPLAY l_gen02 TO gen02
           END IF
          
 
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT 
           END IF
           IF issue_type ='2' AND cl_null(ware_no) THEN NEXT FIELD ware_no END IF
           IF ware_no IS NULL THEN LET ware_no =' ' END IF
           IF loc_no IS NULL THEN LET loc_no =' ' END IF
           IF lot_no IS NULL THEN LET lot_no =' ' END IF
           IF gen_no IS NULL THEN LET gen_no =' ' END IF   #MOD-9C0195 add
           
        ON ACTION controlp
           CASE WHEN INFIELD(ware_no)
                    #Mod No.FUN-AB0018
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = ware_no
                    #LET g_qryparam.arg1    = 'SW'        #倉庫類別 #MOD-4A0213
                    #CALL cl_create_qry() RETURNING ware_no
                     CALL q_imd_1(FALSE,TRUE,ware_no,"",g_plant,"","")  #只能开当前门店的
                          RETURNING ware_no
                    #End Mod No.FUN-AB0018
                     DISPLAY BY NAME ware_no
                     NEXT FIELD ware_no
                WHEN INFIELD(loc_no)
                    #Mod No.FUN-AB0018
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = loc_no
                    #LET g_qryparam.arg1    = ware_no     #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2    = 'SW'        #倉庫類別 #MOD-4A0063
                    #CALL cl_create_qry() RETURNING loc_no
                     CALL q_ime_1(FALSE,TRUE,loc_no,ware_no,"",g_plant,"","","")
                          RETURNING loc_no
                    #End Mod No.FUN-AB0018
                     DISPLAY BY NAME loc_no
                     NEXT FIELD loc_no
                WHEN INFIELD(gen_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen4"
                     LET g_qryparam.default1 = gen_no
                     CALL cl_create_qry() RETURNING gen_no
                     DISPLAY BY NAME gen_no
                     NEXT FIELD gen_no
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
     END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i501_g_b_w
         CALL i501_b_fill(' 1=1')
         RETURN
      END IF
  END IF      #FUN-940039 add
 
 
   LET g_wc4 = ' 1=1'
   IF (issue_type MATCHES '[13456]') AND (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN  #MOD-9C0195 add #FUN-D10073 add 6
     CONSTRUCT BY NAME  g_wc4 ON ware_no,loc_no,gen_no
     
     BEFORE CONSTRUCT
       CALL cl_qbe_init()
       CALL cl_set_comp_entry("lot_no",FALSE)  

      #MOD-CA0183---add---S
       AFTER FIELD ware_no
          LET ware_no = GET_FLDBUF(ware_no)
       AFTER FIELD loc_no
          LET loc_no = GET_FLDBUF(loc_no)
       AFTER FIELD gen_no
          LET gen_no = GET_FLDBUF(gen_no)
      #MOD-CA0183---add---E
      
       ON ACTION controlp
          CASE WHEN INFIELD(ware_no)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_imd"
                   #LET g_qryparam.state= "c"
                   #LET g_qryparam.arg1    = 'SW'        #倉庫類別 #MOD-4A0213
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                         RETURNING g_qryparam.multiret
                   #End Mod No.FUN-AB0018
                    DISPLAY g_qryparam.multiret TO ware_no
                    NEXT FIELD ware_no
               WHEN INFIELD(loc_no)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_ime"
                   #LET g_qryparam.state= "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                   #End Mod No.FUN-AB0018
                    DISPLAY g_qryparam.multiret TO loc_no
                    NEXT FIELD loc_no
               WHEN INFIELD(gen_no)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen4"
                    LET g_qryparam.state= "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO gen_no
                    NEXT FIELD gen_no
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i501_g_b_w
         CALL i501_b_fill(' 1=1')
         RETURN
      END IF
 
   END IF
 
   IF cl_null(g_wc4) THEN
      LET g_wc4 = ' 1=1'
   END IF
   IF issue_type = '1' OR issue_type = '4' OR issue_type = '5' OR issue_type = '6' THEN   #MOD-9C0195 add #FUN-D10073 add 6
      CALL cl_replace_str(g_wc4,"ware_no","ima35") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"loc_no","ima36") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"gen_no","ima23") RETURNING g_wc4
   END IF
   IF issue_type ='3' THEN
      CALL cl_replace_str(g_wc4,"ware_no","sfa30") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"loc_no", "sfa31") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"gen_no", "ima23") RETURNING g_wc4
   END IF
    #FUN-A20048 add --begin 
   IF issue_type = '1' AND gen_all ='Y' THEN
      CALL cl_replace_str(g_wc4,"ware_no","ima35") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"loc_no","ima36") RETURNING g_wc4
      CALL cl_replace_str(g_wc4,"gen_no","ima23") RETURNING g_wc4
   END IF
    #FUN-A20048 add --end
 
  
  IF NOT cl_sure(0,0) THEN
     LET g_rec_b = 0
     CLOSE WINDOW i501_g_b_w
     RETURN
  END IF
 
  INITIALIZE b_sfs.* TO NULL
  LET b_sfs.sfs02=0
  DELETE FROM sfs_file WHERE sfs01=g_sfp.sfp01
  IF NOT s_del_sfsi(g_sfp.sfp01,'','') THEN END IF   #FUN-B70061         
  DELETE FROM rvbs_file
   WHERE rvbs00 = g_prog
     AND rvbs01 = g_sfp.sfp01
  
  IF NOT (g_sfp.sfp06 MATCHES '[ABC]') THEN  #FUN-5C0114
      DECLARE i501_g_b_c CURSOR FOR
         SELECT * FROM sfq_file WHERE sfq01=g_sfp.sfp01
      FOREACH i501_g_b_c INTO b_sfq.*
        SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=b_sfq.sfq02
        SELECT sfbiicd04,sfbiicd09,ecdicd01
          INTO l_sfbiicd04,l_sfbiicd09,l_ecdicd01
          FROM sfbi_file LEFT OUTER JOIN ecd_file ON ecd01=sfbiicd09
         WHERE sfbi01=g_sfb.sfb01
        IF STATUS THEN 
           CALL cl_err3("sel","sfb_file",b_sfq.sfq02,"",STATUS,"","sel sfb:",1)  #No.FUN-660128
           RETURN
        END IF
       #Mod FUN-BC0060
       #IF cl_null(b_sfq.sfq04) THEN
       #   SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
       #    WHERE sfq02=b_sfq.sfq02 #AND sfq04=b_sfq.sfq04
       #      AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
       #   SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
       #    WHERE sfq02=b_sfq.sfq02 #AND sfq04=b_sfq.sfq04
       #      AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
       #ELSE
       #   SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
       #    WHERE sfq02=b_sfq.sfq02 AND sfq04=b_sfq.sfq04
       #      AND sfq01=sfp01 AND sfp06='1' AND sfp04='Y'
       #   SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
       #    WHERE sfq02=b_sfq.sfq02 AND sfq04=b_sfq.sfq04
       #      AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
       #END IF
        CALL i501_sfq03_chk(b_sfq.sfq02,b_sfq.sfq04,'',b_sfq.sfq014,'1')  #FUN-A70095  #FUN-BC0060 mod 只选过账的 #FUN-C70014 add sfq014
                    RETURNING qty1,qty2
       #Mod FUN-BC0060--end
 
        IF qty1 IS NULL THEN LET qty1=0 END IF
        IF qty2 IS NULL THEN LET qty2=0 END IF

   #FUN-A20048 --begin 
     #LET l_qty = 0           #FUN-AC0074 mark
      IF g_sfp.sfp06 = '1' THEN 
        LET l_i =l_i + 1
       #FUN-AC0074 mark(S)
       #IF NOT cl_null(g_sfq[l_i].sfq02) THEN 
       #   SELECT SUM(sie11) INTO l_qty FROM sie_file 
       #        WHERE sie05 = g_sfq[l_i].sfq02 
       #END IF 
       #IF cl_null(l_qty) THEN 
       #  LET l_qty = 0 
       #END IF  
       #FUN-AC0074 mark(E)
      END IF       
   #FUN-A20048 --end         
        CASE 
           WHEN g_sfp.sfp06='1' OR g_sfp.sfp06='D'  #FUN-C70014 add  g_sfp.sfp06='D'
              #    成套發料：
              #    1若工單作業群組=3.DS或4.ASS
              #     1.1若預計生產數量(sfbiicd04) <> 0, 
              #        則用預計生產數量控卡發料數
              #     1.2若生產數量(sfb08) <>0 且 預計生產數量(sfbiicd04) = 0,
              #        則用生產數量控卡發料數
              #    2.其他: 比照標準作法
              IF g_sma.sma129='N' AND b_sfq.sfq03 = 0 THEN #TQC-AB0178
                 CALL i501_g_b3()                          #TQC-AB0178
              ELSE                                         #TQC-AB0178
                 IF l_ecdicd01 MATCHES '[34]' THEN
                    IF NOT cl_null(l_sfbiicd04) AND 
                       l_sfbiicd04 <> 0 THEN
                       IF l_sfbiicd04<=(qty1-qty2+b_sfq.sfq03) THEN
                          CALL i501_g_b0()  #全數發料
                       ELSE
                          CALL i501_g_b1()  #依套數
                       END IF
                    ELSE
                       IF g_sfb.sfb08<=(qty1-qty2+b_sfq.sfq03) THEN
                          CALL i501_g_b0()  #全數發料
                       ELSE
                          CALL i501_g_b1()  #依套數
                       END IF
                    END IF
                 ELSE
                    IF g_sfb.sfb08<=(qty1-qty2+b_sfq.sfq03) THEN
                       CALL i501_g_b0()  #全數發料
                    ELSE
                       CALL i501_g_b1()  #依套數
                    END IF
                 END IF
              END IF  #TQC-AB0178
             WHEN g_sfp.sfp06='3' 
                CALL i501_g_b3()
             WHEN g_sfp.sfp06='6' 
                IF (qty1-qty2-b_sfq.sfq03)<=0 THEN
                   CALL i501_g_b5()  #全數退料
                ELSE
                   CALL i501_g_b1()  #依套數
                END IF
             WHEN g_sfp.sfp06='7' 
                CALL i501_g_b7()
        END CASE
 
      END FOREACH
  ELSE
      LET l_sfs930=s_costcenter(g_sfp.sfp07) #FUN-670103
      DECLARE i501_g_b_c1 CURSOR FOR
         SELECT sfq01,sfq02,SUM(sfq03),sfq04,sfq05,0,sfq07,sfq08 FROM sfq_file     #No.FUN-870097 add sfq07 #No.FUN-870041 #FUN-940008 add sfq08
            WHERE sfq01=g_sfp.sfp01 group by sfq01,sfq02,sfq04,sfq05,sfq07,sfq08  #No.FUN-870097 add sfq07  #No.FUN-870041  #TQC-9C0048
      FOREACH i501_g_b_c1 INTO b_sfq.sfq01,b_sfq.sfq02,b_sfq.sfq03
                              ,b_sfq.sfq04,b_sfq.sfq05,b_sfq.sfq06
                              ,b_sfq.sfq07,b_sfq.sfq08  #No.FUN-870097 add sfq07 #FUN-940008 add sfq08
                              
        SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
         WHERE sfq02=b_sfq.sfq02 AND sfq04=b_sfq.sfq04
           AND sfq01=sfp01 AND sfp06='A' AND sfp04='Y'
        SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
         WHERE sfq02=b_sfq.sfq02 AND sfq04=b_sfq.sfq04
           AND sfq01=sfp01 AND sfp06='B' AND sfp04='Y'
 
        IF qty1 IS NULL THEN LET qty1=0 END IF
        IF qty2 IS NULL THEN LET qty2=0 END IF
 
        IF cl_null(b_sfq.sfq05) THEN
           LET l_date=g_sfp.sfp03
        ELSE
           LET l_date=b_sfq.sfq05
        END IF
 
        CASE g_sfp.sfp06
           WHEN 'A'
              SELECT sre051 INTO l_sre051 FROM sre_file
               WHERE sre01=YEAR(b_sfq.sfq05)
                 AND sre02=MONTH(b_sfq.sfq05)
                 AND sre03=b_sfq.sfq04
                 AND sre04=b_sfq.sfq02
                 AND sre06=b_sfq.sfq05
              #No.FUN-A70034  --Begin
              #LET l_sql = "SELECT bmb03,bmb06,bmb07,bmb08,bmb16,ima108 FROM bmb_file, ima_file",
              LET l_sql = "SELECT bmb03,bmb06,bmb07,bmb08,bmb16,ima108,",
                          "       bmb081,bmb082 ",
                          "  FROM bmb_file, ima_file",
              #No.FUN-A70034  --End  
                          " WHERE ima01=bmb03 AND bmb01='",b_sfq.sfq02,"'",
                          "   AND bmb29='",l_sre051,"'",   #No.FUN-870041
                          "   AND (bmb04 <='",l_date,"' OR bmb04 IS NULL )",
                          "   AND (bmb05 > '",l_date,"' OR bmb05 IS NULL )",
                          "   AND ima70='N'"
 
              PREPARE i501_g_b_c2_pre FROM l_sql
              DECLARE i501_g_b_c2 CURSOR FOR i501_g_b_c2_pre
 
              #No.FUN-A70034  --Begin
              #FOREACH i501_g_b_c2 INTO l_bmb.*,g_ima108
              FOREACH i501_g_b_c2 INTO l_bmb.*,g_ima108,l_bmb081,l_bmb082
              #No.FUN-A70034  --End
                IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
                   CONTINUE FOREACH
                END IF
 
                IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
                   CONTINUE FOREACH
                END IF
 
                #No.FUN-A70034  --Begin
                #LET issue_qty1=b_sfq.sfq03*(l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
                CALL cralc_rate(b_sfq.sfq02,l_bmb.bmb03,b_sfq.sfq03,l_bmb081,l_bmb.bmb08,l_bmb082,
                                l_bmb.bmb06/l_bmb.bmb07,0)
                     RETURNING l_total,l_QPA,l_ActualQPA
                LET issue_qty1=l_total
                #No.FUN-A70034  --End  
                CALL i500_chk_ima64(l_bmb.bmb03, issue_qty1) RETURNING issue_qty1
 
                #發料單位
                LET g_sfa2.sfa12=' '
                 SELECT ima55 INTO g_sfa2.sfa12 FROM ima_file
                    WHERE ima01=l_bmb.bmb03
                IF cl_null(g_sfa2.sfa12) THEN
                   SELECT ima25 INTO g_sfa2.sfa12 FROM ima_file
                      WHERE ima01=l_bmb.bmb03
                END IF
                #作業編號
                LET g_sfa2.sfa08=' '
                #取替代特性
                LET g_sfa2.sfa26=l_bmb.bmb16
                LET g_sfa2.sfa27=l_bmb.bmb03
                LET g_sfa2.sfa28=1
                #發料料號
                LET g_sfa2.sfa03=l_bmb.bmb03
                #FUN-AC0074 (S)
                 SELECT ima35,ima36,ima136,ima137
                   INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file           #FUN-B80086  main改成mai
                  WHERE ima01=g_sfa2.sfa03
                #FUN-AC0074 (E)
                #FUN-D20008---begin
                IF cl_null(l_wip_ware) AND cl_null(l_wip_loc) THEN
                   LET l_wip_ware = g_sma.sma75
                   LET l_wip_loc = g_sma.sma76
                END IF 
                #FUN-D20008--end
                CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
 
              END FOREACH
 
           WHEN 'B'
              LET l_sql = "SELECT bmb03,bmb06,bmb07,bmb08,bmb16,ima108 FROM bmb_file, ima_file",
                          " WHERE ima01=bmb03 AND bmb01='",b_sfq.sfq02,"'",
                          "   AND (bmb04 <='",l_date,"' OR bmb04 IS NULL )",
                          "   AND (bmb05 > '",l_date,"' OR bmb05 IS NULL )",
                          "   AND ima70='N'"
                          ,"  AND bmb29 = '",b_sfq.sfq07,"'"  #FUN-870097
                          
              PREPARE i501_g_b_c3_pre FROM l_sql
              DECLARE i501_g_b_c3 CURSOR FOR i501_g_b_c3_pre
 
              FOREACH i501_g_b_c3 INTO l_bmb.*,g_ima108
                IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
                   CONTINUE FOREACH
                END IF
                IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
                   CONTINUE FOREACH
                END IF
 
                LET b_sfs.sfs01=g_sfp.sfp01
                LET b_sfs.sfs02=b_sfs.sfs02+1
                LET b_sfs.sfs03=b_sfq.sfq02
                LET b_sfs.sfs04=l_bmb.bmb03
                LET b_sfs.sfs05=qty1-qty2
 
                SELECT ima55,ima35,ima36 INTO b_sfs.sfs06,b_sfs.sfs07,b_sfs.sfs08 FROM ima_file
                 WHERE ima01 = b_sfs.sfs04
 
                IF cl_null(b_sfs.sfs06) THEN
                   SELECT ima25 INTO b_sfs.sfs06 FROM ima_file
                      WHERE ima01 = b_sfs.sfs04
                END IF
               ##Add No.FUN-AB0018  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
               #IF NOT cl_null(b_sfs.sfs07) THEN
               #  IF NOT s_chk_ware(b_sfs.sfs07) THEN  #检查仓库是否属于当前门店
               #     LET b_sfs.sfs07 = ' '
               #  END IF
               #END IF
               ##End Add No.FUN-AB0018
                IF (issue_type=2) AND (NOT cl_null(ware_no)) THEN
                  LET b_sfs.sfs07=ware_no
                  LET b_sfs.sfs08=loc_no
                  LET b_sfs.sfs09=lot_no
                END IF
 
                IF g_sfp.sfp06 MATCHES '[B]' THEN
                   IF g_sfa2.sfa05 <0 THEN
                      LET b_sfs.sfs05=0
                   END IF
                END IF
 
                LET b_sfs.sfs10=' '
                IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
                IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
                IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
#FUN-A60028 --begin--
                IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
                IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#FUN-A60028 --end--                
                IF g_sma.sma115 = 'Y' THEN
                   CALL i501_set_du_by_origin()
                END IF
                LET b_sfs.sfs930=l_sfs930 #FUN-670103
                IF cl_null(b_sfs.sfs27) THEN
                   LET b_sfs.sfs27=b_sfs.sfs04
                END IF
 
                IF cl_null(b_sfs.sfs27) THEN
                   LET b_sfs.sfs27 = ' '
                END IF

                LET b_sfs.sfsplant = g_plant #FUN-980008 add
                LET b_sfs.sfslegal = g_legal #FUN-980008 add
 
                IF b_sfs.sfs014 IS NULL THEN LET b_sfs.sfs014=' ' END IF  #FUN-C70014 add
                #FUN-CB0087--add--str--
                IF g_aza.aza115 ='Y' THEN
                   LET b_sfs.sfs37=s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07)
                END IF
                #FUN-CB0087--add--str-- 

                INSERT INTO sfs_file VALUES(b_sfs.*)
                IF STATUS THEN 
                   CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
                   END IF
                #FUN-B70061 --START--
                LET b_sfsi.sfsi01 = b_sfs.sfs01
                LET b_sfsi.sfsi02 = b_sfs.sfs02
                IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
                   
                END IF
                #FUN-B70061 --END--
                CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
                
              END FOREACH
 
        END CASE
 
      END FOREACH
  END IF
  CALL i501_sort_by_partno()
  LET g_rec_b = g_i
 
  CLOSE WINDOW i501_g_b_w
 
  DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i501_set_entry_gb()
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    CALL cl_set_comp_entry("noqty,short_data",TRUE)
 
END FUNCTION
 
FUNCTION i501_set_no_entry_gb()
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF INFIELD(issue_type) THEN
       CALL cl_set_comp_entry("noqty,short_data",TRUE) #MOD-580337
       CASE issue_type
            WHEN  '1'         CALL cl_set_comp_entry("noqty,short_data",FALSE)
            WHEN  '2'         CALL cl_set_comp_entry("short_data",FALSE)
            WHEN  '3'         CALL cl_set_comp_entry("short_data",FALSE)
            WHEN  '4'         CALL cl_set_comp_entry("noqty",FALSE)
            WHEN  '5'         CALL cl_set_comp_entry("noqty",FALSE)
            WHEN  '6'         CALL cl_set_comp_entry("noqty",FALSE)  #FUN-D10073
            OTHERWISE EXIT CASE
       END CASE
 
    END IF
 
END FUNCTION

#FUN-AC0074 mark(S)
#FUN-A20048 --begin
#FUNCTION i501_g_b01(l_sfq02,l_sfq04) 		# 依备置發料(When sfp06=1/6)
#  DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(1000) 
#  DEFINE l_sfq02 LIKE sfq_file.sfq02
#  DEFINE l_sfq04 LIKE sfq_file.sfq04 
#  DEFINE l_sie    RECORD LIKE sie_file.*
#  DEFINE l_gfe03 LIKE gfe_file.gfe03
#  DEFINE l_qty1  LIKE sfq_file.sfq03
#  DEFINE l_issue_qty1  LIKE sfq_file.sfq03   #FUN-A40053 add 
#
#   IF cl_null(g_wc4) THEN
#      LET g_wc4 = ' 1=1'
#   END IF
# 
# 
#   #LET l_sql = "SELECT sie_file.*,ima108 FROM sie_file,ima_file ",  #FUN-AC0074
#    LET l_sql = "SELECT sfa_file.*,sie_file.*,ima108 FROM ima_file,sfa_file ", #FUN-AC0074
#                "  LEFT OUTER JOIN sie_file ON sfa01=sie05 AND sfa27=sie01 AND (sie02 IS NOT NULL AND sie02 <> ' ')",
#                " WHERE sfa01 = '",l_sfq02,"'", #FUN-AC0074
#                " AND sfa27 = ima01", #FUN-AC0074
#                " AND ",g_wc4 CLIPPED     
#    
#    
#  IF NOT cl_null(l_sfq04) THEN 
#     LET l_sql = l_sql CLIPPED, " AND sie06 = '",l_sfq04,"'" #FUN-AC0074 sic06==>sie06
#  END IF 
#  LET l_sql = l_sql CLIPPED, " ORDER BY sie01"
# 
#  PREPARE i501_g_b01_pre FROM l_sql
#  DECLARE i501_g_b01_c CURSOR FOR i501_g_b01_pre
# 
#  FOREACH i501_g_b01_c INTO g_sfa2.*,l_sie.*,g_ima108   #FUN-AC0074 
#                                             
#    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
#       CONTINUE FOREACH
#    END IF
# 
#    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
#       CONTINUE FOREACH
#    END IF
#    #FUN-A40053 add --begin
#    #  FUN-AC0074--mark--begin---
#    #SELECT sfa05,sfa065,sfa06,sfa161 INTO g_sfa.sfa05,g_sfa.sfa065,g_sfa.sfa06,g_sfa.sfa161   #FUN-B50059
#    #  FROM sfa_file 
#    #   AND sfa03 = l_sie.sie01 
#    #   AND sfa08 = l_sie.sie06 
#    #   AND sfa12 = l_sie.sie07 
#    #   AND sfa27 = l_sie.sie08 
#####FUN-A60028 --begin--
#    #   AND sfa012= l_sie.sie012
#    #   AND sfa013= l_sie.sie013
#####FUN-A60028 --end--    
#    #FUN-AC0074--mark--end--   
#     IF g_sfa2.sfa05 IS NULL THEN  #FUN-AC0074
#        LET g_sfa2.sfa05 = 0       #FUN-AC0074
#     END IF 
#     IF g_sfa2.sfa06 IS NULL THEN  #FUN-AC0074
#        LET g_sfa2.sfa06 = 0
#     END IF 
#     IF g_sfa2.sfa065 IS NULL THEN #FUN-AC0074
#        LET g_sfa2.sfa065 = 0      #FUN-AC0074
#     END IF 
#     #FUN-A60095(S)
#     IF g_sfa2.sfa064 IS NULL THEN #FUN-AC0074
#        LET g_sfa2.sfa064 = 0      #FUN-AC0074
#     END IF
#     
#     LET l_qty1 = g_sfa2.sfa05 - g_sfa2.sfa06 - g_sfa2.sfa065   #FUN-B50059 #FUN-AC0074
#     IF NOT cl_null(l_sie.sie01) THEN  #FUN-AC0074
#        IF l_sie.sie11 > l_qty1 THEN 
#           LET l_issue_qty1 = l_qty1
#        ELSE  
#           LET l_issue_qty1 = l_sie.sie11
#        END IF 
#        IF l_sie.sie11 < l_qty1 AND gen_all = 'Y' THEN 
#           LET g_flag_sie01 = 'Y'
#           #FUN-AC0074--mark-(s)
#           #SELECT * INTO g_sfa2.* FROM sfa_file 
#           # WHERE sfa01 = l_sie.sie05
#           #   AND sfa03 = l_sie.sie01 AND sfa08 = l_sie.sie06 
#           #   AND sfa12 = l_sie.sie07 AND sfa27 = l_sie.sie08  
#           #   AND sfa012= l_sie.sie012 AND sfa013= l_sie.sie013  #FUN-A60028 
#           #FUN-AC0074--mark-(e)
#          LET issue_qty1 = l_qty1 - l_sie.sie11
#          CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
# 
#          CALL i501_chk_img()	# 依 issue_qty1 尋找 img_file可用資料
#          IF g_flag_sie01 = 'N' THEN 
#             LET l_issue_qty1 = l_qty1
#          END IF 
#        END IF 
#        
#        CALL i500_chk_ima64(l_sie.sie05, l_issue_qty1) RETURNING l_issue_qty1          
#        #FUN-A40053 add --end 
#        SELECT gfe03 INTO l_gfe03 FROM gfe_file
#         WHERE gfe01=l_sie.sie07
#        IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
#           LET l_gfe03=0
#        END IF
#    
#        LET b_sfs.sfs01=g_sfp.sfp01
#        LET b_sfs.sfs02=b_sfs.sfs02+1
#        LET b_sfs.sfs03=l_sfq02
#        LET b_sfs.sfs04=l_sie.sie01
#        LET b_sfs.sfs05=l_issue_qty1
#        LET b_sfs.sfs05=cl_digcut(b_sfs.sfs05,l_gfe03) #MOD-640364
#        LET b_sfs.sfs06=l_sie.sie07
#        LET b_sfs.sfs07=l_sie.sie02
#        #Add No.FUN-AB0018
#       IF NOT cl_null(b_sfs.sfs07) THEN
#          IF NOT s_chk_ware(b_sfs.sfs07) THEN  #检查仓库是否属于当前门店
#             LET b_sfs.sfs07 = ' '
#          END IF
#       END IF
#       #End Add No.FUN-AB0018
#       LET b_sfs.sfs012=l_sie.sie012   #FUN-B20009
#       LET b_sfs.sfs013=l_sie.sie013   #FUN-B20009
#       LET b_sfs.sfs08=l_sie.sie03
#       LET b_sfs.sfs09=l_sie.sie04
#       LET b_sfs.sfs10=l_sie.sie06
#       LET b_sfs.sfs26=NULL
#       LET b_sfs.sfs27=l_sie.sie08
#       LET b_sfs.sfs28=NULL
#       LET b_sfs.sfs36=''   
#       IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
#       IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
#       IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
#       #FUN-A60028 --begin--
#       IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
#       IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#       #FUN-A60028 --end--      
#       IF g_sma.sma115 = 'Y' THEN
#          CALL i501_set_du_by_origin()
#       END IF
#       LET b_sfs.sfs930=i501_get_sfs930(b_sfs.sfs03) #FUN-670103
#       IF cl_null(b_sfs.sfs27) THEN
#          LET b_sfs.sfs27=b_sfs.sfs04
#       END IF
#       IF cl_null(b_sfs.sfs27) THEN
#          LET b_sfs.sfs27 = ' '
#       END IF
#       IF cl_null(b_sfs.sfs28) THEN
#          SELECT sfa28 INTO b_sfs.sfs28
    #  FROM sfa_file 
#           WHERE sfa01 = b_sfs.sfs03 
#             AND sfa03 = b_sfs.sfs04
#             AND sfa08 = b_sfs.sfs10
#             AND sfa12 = b_sfs.sfs06
#             AND sfa27 = b_sfs.sfs27
#             AND sfa012= b_sfs.sfs012    #FUN-A60028 
#             AND sfa013= b_sfs.sfs013    #FUN-A60028
#       END IF
# 
#       LET b_sfs.sfsplant = g_plant #FUN-980008 add
#       LET b_sfs.sfslegal = g_legal #FUN-980008 add
# 
#       INSERT INTO sfs_file VALUES(b_sfs.*)
#       IF STATUS THEN 
#          CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
#       END IF
#       CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
#     ELSE
#       CALL i500_chk_ima64(g_sfa2.sfa03, l_qty1) RETURNING issue_qty1 #FUN-AC0074
#       CALL i501_chk_img() #FUN-AC0074
#     END IF  #FUN-AC0074
#    
#    LET l_issue_qty1 = 0
# 
#  END FOREACH
#END FUNCTION
##FUN-A20048 ---end 
#FUN-AC0074 mark(E)
 
FUNCTION i501_g_b0() 		# 全數發料 (除了消耗料件&代買料件)
  DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02              #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03            #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03
  #FUN-AC0074 (E)

  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND sfa05>sfa06", #FUN-B50059
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X','S') OR sfa11 IS NULL)", #CHI-980013 #FUN-9C0040 
              "   AND (sfa05-sfa065)>0" ,  #應發-委外代買量>0
              "   AND ",g_wc4 CLIPPED      #FUN-940039 add 
 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
#FUN-B20095 -----------------Begin--------------------
  IF NOT cl_null(b_sfq.sfq012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_sfq.sfq012,"'"
  END IF 
#FUN-B20095 -----------------End----------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i501_g_b0_pre FROM l_sql
  DECLARE i501_g_b0_c CURSOR FOR i501_g_b0_pre
 
  FOREACH i501_g_b0_c INTO g_sfa2.*,g_ima108
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
 
    LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
    #FUN-AC0074(S)
    CALL i501_issue_sie()
    IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
    #FUN-AC0074(E) 
    IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
    IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
    CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
    #FUN-AC0074 (S)
     SELECT ima35,ima36,ima136,ima137
       INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file            #FUN-B80086  main改成mai
      WHERE ima01=g_sfa2.sfa03
    #FUN-AC0074 (E)
    #FUN-D20008---begin
    IF cl_null(l_wip_ware) AND cl_null(l_wip_loc) THEN
       LET l_wip_ware = g_sma.sma75
       LET l_wip_loc = g_sma.sma76
    END IF 
    #FUN-D20008--end
    CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai 
 
  END FOREACH
 
END FUNCTION
 
FUNCTION i501_g_b1() 		# 依套數發料/退料(When sfp06=1/6)
  DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(1000)
  DEFINE s_u_flag	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02       #FUN-B80086  main改成mai
  DEFINE l_mai_loc	LIKE img_file.img03       #FUN-B80086  main改成mai
  DEFINE l_wip_ware	LIKE img_file.img02
  DEFINE l_wip_loc	LIKE img_file.img03
  #FUN-AC0074 (E)
  DEFINE l_bmd07        LIKE bmd_file.bmd07     #TQC-C30067 add
  DEFINE l_bmd10        LIKE bmd_file.bmd10     #TQC-C30067 add
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND sfa26 IN ('0','1','2','3','4','5','T','7','8','9','A')",    #bugno:7111 add '5T'  #FUN-A20037 add '7,8' #TQC-C20443 add ,'9' 'A'
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
              "   AND (sfa05-sfa065)>=0",    #應發-委外代買量>0   #No:9390   #No.MOD-570241 modify
              "   AND ",g_wc4 CLIPPED      #FUN-940039 add 
  IF g_sfp.sfp06 = '1' THEN   #FUN-9C0040
     LET l_sql = l_sql CLIPPED," AND sfa11 <> 'S' " #FUN-9C0040
  END IF   #FUN-9C0040
    
 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
#FUN-B20095 ---------------------Begin-------------------------- 
  IF NOT cl_null(b_sfq.sfq012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_sfq.sfq012,"'"
  END IF
#FUN-B20095 ---------------------END----------------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa03"
  PREPARE i501_g_b1_pre FROM l_sql
  DECLARE i501_g_b1_c CURSOR FOR i501_g_b1_pre
 
  FOREACH i501_g_b1_c INTO g_sfa.*,g_ima108	#原始料件(g_sfa)
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    LET g_sfa.sfa05=g_sfa.sfa05-g_sfa.sfa065   #扣除委外代買量
 
    IF STATUS THEN CALL cl_err('fore sfa',STATUS,1) RETURN END IF
 
 
    LET issue_qty  =b_sfq.sfq03*g_sfa.sfa161		#原始料件應發/退數量
#TQC-C30067   ---add---
#   除了成套退料和發料外，其餘都不可自動產生
    IF g_sfp.sfp06 NOT MATCHES '[16]' AND g_sfa.sfa26 MATCHES '[9ABC]' THEN
       CONTINUE FOREACH
    END IF 
#TQC-C30067   ---end--
 
    IF g_sfa.sfa26 MATCHES '[01257]' THEN   #FUN-A20037 add '7'
       #若是全數代買時則不允許做退料
       IF g_sfa.sfa05 = 0 THEN 
          CONTINUE FOREACH
       END IF
       IF g_argv1='1' AND issue_qty>(g_sfa.sfa05-g_sfa.sfa06) THEN  #FUN-B50059
          LET issue_qty=(g_sfa.sfa05-g_sfa.sfa06)   #FUN-B50059
       END IF
 
       IF g_argv1='2' AND issue_qty>g_sfa.sfa06 THEN  #FUN-B50059
          LET issue_qty=g_sfa.sfa06   #FUN-B50059
       END IF

       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 
       LET g_sfa2.* = g_sfa.*
 
       LET issue_qty1=issue_qty
 
       #FUN-AC0074(S)
       CALL i501_issue_sie()
       IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
       #FUN-AC0074 (E)

       CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
 
       #FUN-AC0074 (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file           #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 (E)
       #FUN-D20008---begin
       IF cl_null(l_wip_ware) AND cl_null(l_wip_loc) THEN
          LET l_wip_ware = g_sma.sma75
          LET l_wip_loc = g_sma.sma76
       END IF 
       #FUN-D20008--end
       CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
 
       CONTINUE FOREACH
 
    END IF
 
    # 當有替代狀況時, 須作以下處理:
    LET l_sql="SELECT * FROM sfa_file",
              " WHERE sfa01='",g_sfa.sfa01,"' AND sfa27='",g_sfa.sfa03,"'",
              "   AND sfa08='",g_sfa.sfa08,"' AND sfa12='",g_sfa.sfa12,"'",
              "   AND sfa012= '",g_sfa.sfa012,"' AND sfa013 = ",g_sfa.sfa013   #FUN-A60028 add
    IF g_sfp.sfp06='6' THEN
       LET l_sql = l_sql CLIPPED," AND sfa05 > 0 AND sfa06 > 0  "  CLIPPED   #TQC-C30067  ADD sfa06>0
    END IF
 
    SELECT MAX(sfa26) INTO s_u_flag FROM sfa_file	# 到底是 S 或 U ?
                WHERE sfa01=g_sfa.sfa01 AND sfa27=g_sfa.sfa03
                  AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
                  AND sfa012=g_sfa.sfa012 AND sfa013=g_sfa.sfa013   #FUN-A60028 add
    # U:先發取代件,再發原料件 S:先發原料件,再發替代件
    IF s_u_flag='U' OR s_u_flag = 'T' THEN     #bungo:711l add 'T'
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26 DESC, sfa03"
    ELSE
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26     , sfa03"
    END IF
    PREPARE g_b1_p2 FROM l_sql
    DECLARE g_b1_c2 CURSOR FOR g_b1_p2
    FOREACH g_b1_c2 INTO g_sfa2.*	             #應發(含替代)料件(g_sfa2
       LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
       IF STATUS THEN CALL cl_err('f sfa2',STATUS,1) RETURN END IF
       LET issue_qty=issue_qty*g_sfa2.sfa28
       #FUN-AC0074 (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file         #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 (E)
       #FUN-D20008---begin
       IF cl_null(l_wip_ware) AND cl_null(l_wip_loc) THEN
          LET l_wip_ware = g_sma.sma75
          LET l_wip_loc = g_sma.sma76
       END IF 
       #FUN-D20008--end
       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 # issue_qty的計算應以sfq03* sfa161來計算才不會被改變,影響後續欠料數量的計算
       IF g_argv1='1' THEN	# 發料時
         IF g_sfa2.sfa05<=g_sfa2.sfa06 THEN CONTINUE FOREACH END IF #FUN-B50059
         IF issue_qty<=(g_sfa2.sfa05-g_sfa2.sfa06) THEN  #FUN-B50059
            LET issue_qty1=issue_qty
            #FUN-AC0074(S)
            CALL i501_issue_sie()
            IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
            #FUN-AC0074 (E)
            CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
            CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
            EXIT FOREACH
         ELSE
            LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
            CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
            CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
         END IF
       END IF
       IF g_argv1='2' THEN	# 退料時
#TQC-C30067  ---begin---add
         IF g_sfa2.sfa26 MATCHES '[BC]' THEN
            SELECT bmd07,bmd10 INTO l_bmd07,l_bmd10 FROM bmd_file WHERE bmd01= g_sfa2.sfa27 AND bmd04=g_sfa2.sfa03
            LET issue_qty1=b_sfq.sfq03*l_bmd07/l_bmd10
            CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
            CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE) 
         ELSE
#QC-C30067  ---END---         
         IF issue_qty<=g_sfa2.sfa06 THEN  #FUN-B50059
            LET issue_qty1=issue_qty
            CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
            CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai 
            EXIT FOREACH
          ELSE
            LET issue_qty1=g_sfa2.sfa06  #FUN-B50059
            CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
            CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai
 
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
         END IF  
         END IF  #TQC-C30067 add
       END IF
    END FOREACH
  END FOREACH
END FUNCTION
 
#FUN-AC0074 (S)
FUNCTION i501_issue_sie()
  DEFINE l_sie         RECORD LIKE sie_file.*
  DEFINE l_issue_qty1  LIKE sfq_file.sfq03
  DEFINE l_sql,l_where         STRING

    IF g_sfp.sfp06 NOT MATCHES '[13]' THEN RETURN END IF
    LET l_where =''
    IF issue_type = '2' THEN
       IF NOT cl_null(ware_no) THEN LET l_where=l_where," AND sie02 ='",ware_no,"'" END IF
       IF NOT cl_null(loc_no) THEN LET l_where=l_where," AND sie03 ='",loc_no,"'" END IF
       IF NOT cl_null(lot_no) THEN LET l_where=l_where," AND sie04 ='",lot_no,"'" END IF
    END IF    
    LET l_sql = "SELECT sie_file.* FROM ima_file, sfa_file, sie_file ",
                " WHERE sfa01 =  '",g_sfa2.sfa01 ,"'",
                "   AND sfa03 =  '",g_sfa2.sfa03 ,"'",
                "   AND sfa08 =  '",g_sfa2.sfa08 ,"'",
                "   AND sfa12 =  '",g_sfa2.sfa12 ,"'",
                "   AND sfa27 =  '",g_sfa2.sfa27 ,"'",
                "   AND sfa012=  '",g_sfa2.sfa012,"'",
                "   AND sfa013=  '",g_sfa2.sfa013,"'",
                "   AND ima01 = sfa03  AND sfa01=sie05 AND sfa27=sie01 ",
                "   AND sfa03 = sie08  AND sfa08=sie06 AND sfa12=sie07 ",
                "   AND sfa012= sie012 AND sfa013=sie013 ",
                "   AND sie11 > 0 AND (sie02 IS NOT NULL AND sie02 <> ' ')",l_where
    IF issue_type MATCHES '[1345]' THEN
       LET l_sql = l_sql , "   AND ",g_wc4 CLIPPED 
    END IF
    PREPARE i501_g_b0_pre1 FROM l_sql
    DECLARE i501_g_b0_c1 CURSOR FOR i501_g_b0_pre1
    FOREACH i501_g_b0_c1 INTO l_sie.*
      IF issue_qty1 <=0 THEN EXIT FOREACH END IF
       LET l_issue_qty1 = issue_qty1
       IF l_sie.sie11 > issue_qty1 THEN 
          LET issue_qty1 = issue_qty1
       ELSE  
          LET issue_qty1 = l_sie.sie11
       END IF 
       CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
       CALL i501_chk_img(l_sie.sie02,l_sie.sie03,l_sie.sie02,l_sie.sie03,l_sie.sie04,TRUE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 
       LET issue_qty1 = l_issue_qty1 - issue_qty2
       IF issue_qty1 < 0 THEN LET issue_qty1 = 0 END IF

    END FOREACH
END FUNCTION
#FUN-AC0074 (E)

FUNCTION i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,l_lot_no,l_sie_flag)	# 依 issue_qty1 尋找 img_file可用資料  #FUN-AC0074     #FUN-B80086  main改成mai
    DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
    DEFINE l_img10              LIKE img_file.img10    #No.MOD-910026
    DEFINE l_factor             LIKE img_file.img21    #No.MOD-940302 add
    DEFINE l_cnt                LIKE type_file.num5    #No.MOD-940302 add
    DEFINE l_n                  LIKE type_file.num5    #CHI-B90038 add
    DEFINE l_sfaiicd03 LIKE sfai_file.sfaiicd03  #FUN-810038
    define l_mai_ware	LIKE img_file.img02        #FUN-B80086  main改成mai
    define l_mai_loc	LIKE img_file.img03        #FUN-B80086  main改成mai
    define l_wip_ware	LIKE img_file.img02
    define l_wip_loc	LIKE img_file.img03
    DEFINE l_lot_no LIKE img_file.img04  #FUN-AC0074
    DEFINE l_sie_flag LIKE type_file.num5  #TRUE->依備置單產生  FALSE->不依備置產生
    DEFINE l_flag       LIKE type_file.chr1   #MOD-CB0046 add
    DEFINE l_img09      LIKE img_file.img09   #MOD-CB0046 add
    DEFINE l_sfs05      LIKE sfs_file.sfs05   #FUN-D10073
    
    #FUN-AC0074 mark (S)
    #SELECT ima35,ima36,ima136,ima137
    #  INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file      #FUN-B80086  main改成mai
    # WHERE ima01=g_sfa2.sfa03
    #FUN-AC0074 mark (E)
    #Add No.FUN-AB0018
    IF NOT cl_null(l_mai_ware) THEN       #FUN-B80086  main改成mai
       IF NOT s_chk_ware(l_mai_ware) THEN  #检查仓库是否属于当前门店     #FUN-B80086  main改成mai
          LET l_mai_ware = ' '                                           #FUN-B80086  main改成mai
       END IF
    END IF
    IF NOT cl_null(l_wip_ware) THEN
       IF NOT s_chk_ware(l_wip_ware) THEN  #检查仓库是否属于当前门店
          LET l_wip_ware = ' '
       END IF
    END IF
    #End Add No.FUN-AB0018
    IF g_ima108 = 'Y' THEN
       LET l_mai_ware = l_wip_ware      #FUN-B80086  main改成mai
       LET l_mai_loc  = l_wip_loc       #FUN-B80086  main改成mai
    END IF
    IF cl_null(l_mai_ware) THEN LET l_mai_ware=ware_no END IF       #FUN-B80086  main改成mai
    IF cl_null(l_mai_loc ) THEN LET l_mai_loc =loc_no  END IF       #FUN-B80086  main改成mai
    IF issue_type='1' THEN
       LET g_img.img01=g_sfa2.sfa03
       LET g_img.img02=l_mai_ware            #FUN-B80086  main改成mai
       LET g_img.img03=l_mai_loc             #FUN-B80086  main改成mai
       LET g_img.img04=l_lot_no  #FUN-AC0074
       LET issue_qty2=issue_qty1
       CALL i501_ins_sfs()
       LET img_qty = issue_qty1 #No.+238
       RETURN
    END IF
 
     IF issue_type MATCHES '[2]' THEN      #No.MOD-570241 modify
       LET g_img.img01=g_sfa2.sfa03
       LET g_img.img02=ware_no
       LET g_img.img03=loc_no
       LET g_img.img04=l_lot_no  #FUN-AC0074
       LET issue_qty2=issue_qty1
       IF issue_qty2 <= 0 AND noqty = 'N' THEN RETURN END IF
      #MOD-AA0142---modify---start---
      #CALL i501_ins_sfs()
       #CHI-B90038 -- begin --
       SELECT COUNT(*) INTO l_n FROM pmc_file
        WHERE pmc917 = g_img.img02   #VMI結算倉庫
          AND pmc918 = g_img.img03   #VMI結算儲位
       IF l_n = 0 THEN
       #CHI-B90038 -- end --
          LET l_img10 = 0  
          LET l_img09 = ''   #MOD-CB0046
          SELECT img10,img09 INTO l_img10,l_img09 FROM img_file  #MOD-CB0046 add img09
           WHERE img01=g_img.img01 AND img02=g_img.img02
             AND img03=g_img.img03 AND img04=g_img.img04
          IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
         #MOD-CB0046---S 
          LET l_factor=0 
          CALL s_umfchk(g_img.img01,l_img09,g_sfa2.sfa12) RETURNING l_flag,l_factor
          IF l_flag=1 THEN CALL cl_err(g_img.img01,'mfg2719',1) RETURN END IF
          LET l_img10 = l_img10*l_factor
         #MOD-CB0046---E
          IF issue_qty2 <= l_img10 THEN
             CALL i501_ins_sfs()
          ELSE
             IF noqty = 'Y' THEN
                IF g_argv2 NOT MATCHES '[6789]' THEN   #MOD-D50173
                   LET g_img.img02 = cl_getmsg('asf-012',g_lang)  
                END IF   #MOD-D50173 
                CALL i501_ins_sfs()
             ELSE
                RETURN
             END IF
          END IF
       #CHI-B90038 -- begin --
       ELSE
          CALL i501_ins_sfs()
       END IF
       #CHI-B90038 -- end --
      #MOD-AA0142---modify---end---
       LET img_qty = issue_qty1 #No.+238
       RETURN
    END IF
 
     IF issue_type MATCHES '[3]' THEN
         LET g_img.img01=g_sfa2.sfa03
         LET g_img.img02=g_sfa2.sfa30
         LET g_img.img03=g_sfa2.sfa31
         LET g_img.img04=' '
         SELECT sfaiicd03 INTO l_sfaiicd03
           FROM sfai_file
          WHERE sfai01 = g_sfa2.sfa01
            AND sfai03 = g_sfa2.sfa03 
            AND sfai08 = g_sfa2.sfa08
            AND sfai12 = g_sfa2.sfa12
            AND sfai012= g_sfa2.sfa012   #FUN-A60028 
            AND sfai013= g_sfa2.sfa013   #FUN-A60028 
         IF cl_null(l_sfaiicd03) THEN LET l_sfaiicd03 = ' ' END IF   #MOD-C90143 add
         LET g_img.img04=l_sfaiicd03
         LET issue_qty2=issue_qty1
         IF issue_qty2 <= 0 AND noqty = 'N' THEN RETURN END IF
        #MOD-AA0142---modify---start---
        #CALL i501_ins_sfs()
         #CHI-B90038 -- begin --
         SELECT COUNT(*) INTO l_n FROM pmc_file
          WHERE pmc917 = g_img.img02   #VMI結算倉庫
            AND pmc918 = g_img.img03   #VMI結算儲位
         IF l_n = 0 THEN
         #CHI-B90038 -- end --
            LET l_img10 = 0  
            LET l_img09 = ''   #MOD-CB0046
            SELECT img10,img09 INTO l_img10,l_img09 FROM img_file   #MOD-CB0046 add img09
             WHERE img01=g_img.img01 AND img02=g_img.img02
               AND img03=g_img.img03 AND img04=g_img.img04
            IF cl_null(l_img10) THEN LET l_img10 = 0 END IF 
           #MOD-CB0046---S
            LET l_factor=0
            CALL s_umfchk(g_img.img01,l_img09,g_sfa2.sfa12) RETURNING l_flag,l_factor
            IF l_flag=1 THEN CALL cl_err(g_img.img01,'mfg2719',1) RETURN END IF
            LET l_img10 = l_img10*l_factor
           #MOD-CB0046---E
            IF issue_qty2 <= l_img10 THEN
               CALL i501_ins_sfs()
            ELSE
               IF noqty = 'Y' THEN
                  IF g_argv2 NOT MATCHES '[6789]' THEN   #MOD-D50173
                     LET g_img.img02 = cl_getmsg('asf-012',g_lang)  
                  END IF  #MOD-D50173
                  CALL i501_ins_sfs()
               ELSE
                  RETURN
               END IF
            END IF
         #CHI-B90038 -- begin --
         ELSE
            CALL i501_ins_sfs()
         END IF
         #CHI-B90038 -- end --
        #MOD-AA0142---modify---end---
         LET img_qty = issue_qty1 #No.+238
         RETURN
     END IF
 
 
    IF issue_type MATCHES '[456]' AND ware_no IS NOT NULL THEN #FUN-D10073 add 6
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img02 = ware_no
    END IF
 
    IF issue_type MATCHES '[456]' AND loc_no IS NOT NULL THEN #FUN-D10073 add 6
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img03 = loc_no
    END IF
 
    IF issue_type MATCHES '[456]' AND lot_no IS NOT NULL THEN #FUN-D10073 add 6
       LET g_img.img01 = g_sfa2.sfa03
       LET g_img.img04 = lot_no
    END IF
    
    LET l_img10 = (g_sfa2.sfa05-g_sfa2.sfa06) * g_sfa2.sfa13  #No.MOD-910026 #FUN-B50059
    LET img_qty=0   #No.+238

    #FUN-D10073---begin
    IF g_sfp.sfp06 = '6' AND issue_type = '6' THEN
       LET l_sql= "SELECT img_file.*,sfe16 from img_file,sfe_file,sfp_file ",
                  " WHERE img01='",g_sfa2.sfa03,"'",
                  "   AND sfe01 = '",g_sfa2.sfa01 ,"'",
                  "   AND sfe07 = img01 ",
                  "   AND sfe08 = img02 ",
                  "   AND sfe09 = img03 ",
                  "   AND sfe10 = img04 ",
                  "   AND sfe02 = sfp01 ",
                  "   AND sfp06 IN ('1','2','3','4') ",
                  "   ORDER BY sfp03 DESC "
    ELSE  
    #FUN-D10073---end
    LET l_sql="SELECT img_file.*,'' FROM img_file",  #FUN-D10073
              " WHERE img01='",g_sfa2.sfa03,"'"	#料號
              #"   AND img10>0 AND img23='Y'"		#可用  #MOD-D10104
    #MOD-D10104---begin
    IF g_sfp.sfp06='6' THEN
       LET l_sql=l_sql CLIPPED," AND img23='Y' "
    ELSE
       LET l_sql=l_sql CLIPPED," AND img10>0 AND img23='Y' "
    END IF
    #MOD-D10104---end
    IF NOT cl_null(l_mai_ware) AND issue_type = '1' THEN          #FUN-B80086  main改成mai
       LET l_sql=l_sql CLIPPED," AND img02='",l_mai_ware,"'"      #FUN-B80086  main改成mai
    END IF
    IF NOT cl_null(l_mai_loc) AND issue_type = '1' THEN           #FUN-B80086  main改成mai
       LET l_sql=l_sql CLIPPED," AND img03='",l_mai_loc,"'"       #FUN-B80086  main改成mai
    END IF
    IF NOT cl_null(l_lot_no) AND issue_type = '1'  THEN  #FUN-AC0074
       LET l_sql=l_sql CLIPPED," AND img04='",l_lot_no,"'"  #FUN-AC0074
    END IF
    IF NOT cl_null(ware_no) AND issue_type MATCHES '[2456]' THEN #FUN-D10073 add 6
       LET l_sql=l_sql CLIPPED," AND img02='",ware_no,"'"
    END IF
    IF NOT cl_null(loc_no) AND issue_type MATCHES '[2456]' THEN #FUN-D10073 add 6
       LET l_sql=l_sql CLIPPED," AND img03='",loc_no,"'"
    END IF
    IF NOT cl_null(lot_no) AND issue_type MATCHES '[2456]'  THEN  #FUN-AC0074 #FUN-D10073 add 6
       LET l_sql=l_sql CLIPPED," AND img04='",lot_no,"'"   #FUN-AC0074
    END IF
    LET l_sql=l_sql CLIPPED," ORDER BY img27"		#發料順序
    #FUN-D10073---begin
    IF issue_type = '6' THEN
       LET l_sql=l_sql CLIPPED," ,img18 desc"
    END IF 
    #FUN-D10073---end
    END IF  #FUN-D10073
    PREPARE g_b1_p3 FROM l_sql
    DECLARE g_b1_c3 CURSOR FOR g_b1_p3
    FOREACH g_b1_c3 INTO g_img.*,l_sfs05  #FUN-D10073
       #FUN-AC0074(S)
       IF l_sie_flag THEN
          IF NOT cl_null(l_mai_ware) THEN LET g_img.img02 = l_mai_ware END IF        #FUN-B80086  main改成mai
          IF NOT cl_null(l_mai_loc)  THEN LET g_img.img03 = l_mai_loc  END IF        #FUN-B80086  main改成mai
          IF NOT cl_null(l_lot_no)    THEN LET g_img.img04 = l_lot_no    END IF       
       END IF
       #FUN-AC0074(E)
       IF STATUS THEN CALL cl_err('fore img',STATUS,1) EXIT FOREACH END IF
       IF g_sfa2.sfa12 = g_img.img09 THEN
          LET l_factor = 1
       ELSE
          CALL s_umfchk(g_img.img01,g_img.img09,g_sfa2.sfa12)
             RETURNING l_cnt,l_factor
          IF l_cnt = 1 THEN
             LET l_factor = 1
          END IF
       END IF
       LET g_img.img10 = g_img.img10 * l_factor
       IF issue_type='5' THEN		# 扣除已撿量
          SELECT SUM(sfs05) INTO qty_alo FROM sfs_file,sfp_file   #No.MOD-810188 add sfp_file
                WHERE sfs04=g_img.img01 AND sfs07=g_img.img02
                  AND sfs08=g_img.img03 AND sfs09=g_img.img04
                  AND sfp01=sfs01 AND sfpconf != 'X'              #No.MOD-810188 add
                  AND sfp06 IN ('1','2','3','4','A','C')          #MOD-B80138 add
          IF qty_alo IS NULL THEN LET qty_alo = 0 END IF
          LET g_img.img10=g_img.img10-qty_alo
          IF g_img.img10<=0 THEN CONTINUE FOREACH END IF
       END IF
       IF g_argv1='1' THEN  #發料
             #           庫存量
          IF issue_qty1<=g_img.img10 THEN    #No.MOD-910026 mark   #No.MOD-940302 remark
             LET issue_qty2=issue_qty1
             CALL i501_ins_sfs()
             LET issue_qty1=issue_qty1-issue_qty2
             LET img_qty = img_qty+issue_qty2 #No.+238
             EXIT FOREACH
          ELSE
             LET issue_qty2=g_img.img10
             CALL i501_ins_sfs()
             LET issue_qty1=issue_qty1-issue_qty2
             LET img_qty = img_qty+issue_qty2 #No.+238
          END IF
      #MOD-A90193---add---start---
       ELSE
             #FUN-D10073---begin
             IF issue_type = '6' THEN
                IF issue_qty1<=l_sfs05 THEN
                   LET issue_qty2=issue_qty1
                ELSE 
                   LET issue_qty2=l_sfs05
                END IF 
             ELSE  
             #FUN-D10073---end
                LET issue_qty2=issue_qty1
             END IF  #FUN-D10073-
             CALL i501_ins_sfs()
             LET issue_qty1=issue_qty1-issue_qty2
             LET img_qty = img_qty+issue_qty2 
             IF issue_type <> '6' OR issue_qty1 = 0 THEN #FUN-D10073
                EXIT FOREACH
             END IF #FUN-D10073
      #MOD-A90193---add---end---
       END IF
    END FOREACH
 
    IF short_data='Y' AND issue_qty1>0 THEN	#產生一筆 Shortage 項次以供警告
       LET issue_qty2=issue_qty1
       LET g_img.img01=g_sfa2.sfa03
 
       IF g_argv2 NOT MATCHES '[6789]' THEN   #MOD-D50173
          LET g_img.img02 = cl_getmsg('asf-012',g_lang)  #BUG-4B0145 add #FUN-560153-1  #MOD-540074
       END IF  #MOD-D50173
       LET g_img.img03=' '
       LET g_img.img04=' '
       CALL i501_ins_sfs()
 
    END IF
END FUNCTION
 
FUNCTION i501_ins_sfs()	# 依 issue_qty2 Insert sfs_file
DEFINE l_gfe03 LIKE gfe_file.gfe03 #MOD-640364
DEFINE l_tot   LIKE sfs_file.sfs05 #No.TQC-750232    #記錄未過賬退料數量
DEFINE l_count LIKE type_file.num5   #NO.FUN-A40053 add 
 
    SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01=g_sfa2.sfa12
    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
       LET l_gfe03=0
    END IF
    #FUN-A40053 -add --begin
    IF gen_all ='Y' AND g_flag_sie01 = 'Y' THEN  
       SELECT COUNT(*) INTO l_count FROM sie_file WHERE sie01 = g_img.img01 
               AND sie02 = g_img.img02 AND sie03 = g_img.img03 
               AND sie04 = g_img.img04 AND sie05 = b_sfq.sfq02 
       IF l_count > 0 THEN 
          LET g_flag_sie01 = 'N'
          RETURN 
       END IF 
     END IF 
    #FUN-A40053 --add --end 
    LET b_sfs.sfs01=g_sfp.sfp01
    LET b_sfs.sfs02=b_sfs.sfs02+1
    LET b_sfs.sfs03=b_sfq.sfq02
    LET b_sfs.sfs04=g_img.img01
    LET b_sfs.sfs05=issue_qty2 #MOD-640364
    #LET b_sfs.sfs05=cl_digcut(issue_qty2,l_gfe03)     #MOD-640364 #FUN-D60039 mark
    LET b_sfs.sfs06=g_sfa2.sfa12
    LET b_sfs.sfs05=s_digqty(issue_qty2,b_sfs.sfs06)  #FUN-D60039 add 
    LET b_sfs.sfs07=g_img.img02
    LET b_sfs.sfs08=g_img.img03
    LET b_sfs.sfs09=g_img.img04
    LET b_sfs.sfs10=g_sfa2.sfa08
    LET b_sfs.sfs26=NULL
    LET b_sfs.sfs27=NULL
    LET b_sfs.sfs28=NULL
    LET b_sfs.sfs36=g_sfa2.sfa36   #FUN-950088 add
    IF g_sfa2.sfa26 MATCHES '[SUTZ9BC]' THEN  #FUN-A20037 add 'Z' #TQC-C20443 add '9'
       LET b_sfs.sfs26=g_sfa2.sfa26
       LET b_sfs.sfs27=g_sfa2.sfa27
       LET b_sfs.sfs28=g_sfa2.sfa28
    END IF
    IF g_sfa2.sfa26 = 'A' THEN LET  b_sfs.sfs26 = '9' END IF  #TQC-C20443 add
    IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
    IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
    IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
    
#FUN-A60028 --begin--
    LET b_sfs.sfs012 = g_sfa2.sfa012
    LET b_sfs.sfs013 = g_sfa2.sfa013
#FUN-A60028 --end--    

#FUN-A60028 --begin--
    IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
    IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#FUN-A60028 --end--  

#FUN-C70014 add begin--------------   
    LET b_sfs.sfs014 = b_sfq.sfq014  
    IF cl_null(b_sfs.sfs014) THEN LET b_sfs.sfs014 = ' ' END IF
#FUN-C70014 add end ---------------
    IF g_sma.sma115 = 'Y' THEN
       CALL i501_set_du_by_origin()
    END IF
    LET b_sfs.sfs930=i501_get_sfs930(b_sfs.sfs03) #FUN-670103
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27=b_sfs.sfs04
    END IF
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27 = ' '
    END IF
    IF cl_null(b_sfs.sfs28) THEN
       SELECT sfa28 INTO b_sfs.sfs28
         FROM sfa_file
        WHERE sfa01 = b_sfs.sfs03 
          AND sfa03 = b_sfs.sfs04
          AND sfa08 = b_sfs.sfs10
          AND sfa12 = b_sfs.sfs06
          AND sfa27 = b_sfs.sfs27
          AND sfa012= b_sfs.sfs012   #FUN-A60028
          AND sfa013= b_sfs.sfs013   #FUN-A60028 
    END IF
 
    LET b_sfs.sfsplant = g_plant #FUN-980008 add
    LET b_sfs.sfslegal = g_legal #FUN-980008 add
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN    
       LET b_sfs.sfs37=s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07) 
    END IF
    #FUN-CB0087--add--str--

    INSERT INTO sfs_file VALUES(b_sfs.*)
    IF STATUS THEN 
       CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
    END IF
    #FUN-B70061 --START--
    LET b_sfsi.sfsi01 = b_sfs.sfs01
    LET b_sfsi.sfsi02 = b_sfs.sfs02
    IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
               
    END IF
    #FUN-B70061 --END--
    
    CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
    
END FUNCTION
 
FUNCTION i501_g_b3() 		# 欠料補料
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
  DEFINE l_short_qty LIKE sfa_file.sfa07 #FUN-940039 add
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02                 #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03               #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03
  #FUN-AC0074 (E)
 
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
             #"   AND sfa03=ima01 AND (sfa11<>'E' OR sfa11 IS NULL)",                 #CHI-980013 
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
              "   AND sfa05-sfa065>0" ,     #應發-委外代買量>0
              "   AND sfa05 - sfa06 > 0 ",  #FUN-B50059
           #  "   AND sfa07 > 0 "           #FUN-940039 mark   
              "   AND ",g_wc4 CLIPPED      #FUN-940039 add 
 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
#FUN-B20095 -----------------Begin--------------------
  IF NOT cl_null(b_sfq.sfq012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_sfq.sfq012,"'"
  END IF
#FUN-B20095 -----------------End----------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i501_g_b3_pre FROM l_sql
  DECLARE i501_g_b3_c CURSOR FOR i501_g_b3_pre
 
  FOREACH i501_g_b3_c INTO g_sfa2.*,g_ima108
       IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
          CONTINUE FOREACH
       END IF
       IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
          CONTINUE FOREACH
       END IF
       #計算欠料量
        IF cl_null(g_sfa2.sfa012) THEN LET g_sfa2.sfa012=' ' END IF #TQC-CB0084 add 
        IF cl_null(g_sfa2.sfa013) THEN LET g_sfa2.sfa013= 0  END IF #TQC-CB0084 add 
        CALL s_shortqty(g_sfa2.sfa01,g_sfa2.sfa03,g_sfa2.sfa08,
                        g_sfa2.sfa12,g_sfa2.sfa27,   #TQC-A50071 sfa06->sfa12
                        g_sfa2.sfa012,g_sfa2.sfa013)   #FUN-A50066 add
             RETURNING l_short_qty
        IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
        IF l_short_qty <=0 THEN CONTINUE FOREACH END IF
 
       LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量  #FUN-B50059
 
 
       LET issue_qty1=l_short_qty     #FUN-940039 add

       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 
       CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1
       #FUN-AC0074 mark (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file       #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 mark (E)
       #FUN-D20008---begin
       IF cl_null(l_wip_ware) AND cl_null(l_wip_loc) THEN
          LET l_wip_ware = g_sma.sma75
          LET l_wip_loc = g_sma.sma76
       END IF 
       #FUN-D20008--end
       CALL i501_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai
 
  END FOREACH
END FUNCTION
 
FUNCTION i501_g_b7() 		# 超領退料
  DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
 
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
              "   AND sfa03=ima01 ",
              "   AND sfa062>0",
              "   AND ",g_wc4 CLIPPED      #FUN-940039 add 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
#FUN-B20095 -----------------Begin--------------------
  IF NOT cl_null(b_sfq.sfq012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_sfq.sfq012,"'"
  END IF
#FUN-B20095 -----------------End----------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i501_g_b7_pre FROM l_sql
  DECLARE i501_g_b7_c CURSOR FOR i501_g_b7_pre
 
  FOREACH i501_g_b7_c INTO g_sfa2.*,g_ima108
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
    IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 
    LET b_sfs.sfs01=g_sfp.sfp01
    LET b_sfs.sfs02=b_sfs.sfs02+1
    LET b_sfs.sfs03=b_sfq.sfq02
    LET b_sfs.sfs04=g_sfa2.sfa03
    LET b_sfs.sfs05=g_sfa2.sfa062
    LET b_sfs.sfs06=g_sfa2.sfa12
    LET b_sfs.sfs27=g_sfa2.sfa27   #MOD-910167             #MOD-980243 modify NULL->g_sfa2.sfa27
 
    SELECT ima35,ima36 INTO b_sfs.sfs07,b_sfs.sfs08 FROM ima_file
     WHERE ima01 = b_sfs.sfs04
 
   ##Add No.FUN-AB0018  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #IF NOT cl_null(b_sfs.sfs07) THEN
   #   IF NOT s_chk_ware(b_sfs.sfs07) THEN  #检查仓库是否属于当前门店
   #      LET b_sfs.sfs07 = ' '
   #   END IF
   #END IF
   ##End Add No.FUN-AB0018
    LET b_sfs.sfs10=g_sfa2.sfa08
    IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
    IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
    IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
    LET b_sfs.sfs012 = g_sfa2.sfa012    #MOD-C80213 add
    LET b_sfs.sfs013 = g_sfa2.sfa013    #MOD-C80213 add
#FUN-A60028 --begin--
    IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
    IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#FUN-A60028 --end--     
    IF g_sma.sma115 = 'Y' THEN
       CALL i501_set_du_by_origin()
    END IF
    LET b_sfs.sfs930=i501_get_sfs930(b_sfs.sfs03) #FUN-670103
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27=b_sfs.sfs04
    END IF
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27 = ' '
    END IF

    LET b_sfs.sfsplant = g_plant #FUN-980008 add
    LET b_sfs.sfslegal = g_legal #FUN-980008 add
    IF b_sfs.sfs014 IS NULL THEN LET b_sfs.sfs014=' ' END IF  #FUN-C70014 add
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN    
       LET b_sfs.sfs37=s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07) 
    END IF
    #FUN-CB0087--add--str--

    INSERT INTO sfs_file VALUES(b_sfs.*)
    #FUN-B70061 --START--
    LET b_sfsi.sfsi01 = b_sfs.sfs01
    LET b_sfsi.sfsi02 = b_sfs.sfs02
    IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
   
    END IF
    #FUN-B70061 --END--
 
    IF STATUS THEN 
       CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
       END IF
    
    CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
    
  END FOREACH
END FUNCTION
 
FUNCTION i501_g_b5() 		# 全部退料
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(300)
 
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_sfq.sfq02,"'",
              "   AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013 
              "   AND sfa03=ima01 ",
              "   AND sfa06>0 ",           #TQC-C30067 add
              "   AND ",g_wc4 CLIPPED      #FUN-940039 add 
  IF NOT cl_null(b_sfq.sfq04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_sfq.sfq04,"'"
  END IF
#FUN-B20095 -----------------Begin--------------------
  IF NOT cl_null(b_sfq.sfq012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_sfq.sfq012,"'"
  END IF
#FUN-B20095 -----------------End----------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i501_g_b5_pre FROM l_sql
  DECLARE i501_g_b5_c CURSOR FOR i501_g_b5_pre
 
  FOREACH i501_g_b5_c INTO g_sfa2.*,g_ima108
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF

    IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
    IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add

    LET b_sfs.sfs01=g_sfp.sfp01
    LET b_sfs.sfs02=b_sfs.sfs02+1
    LET b_sfs.sfs03=b_sfq.sfq02
    LET b_sfs.sfs04=g_sfa2.sfa03
    LET b_sfs.sfs05=g_sfa2.sfa06  #FUN-B50059
    #FUN-A60095(S)
    IF b_sfs.sfs05 < 0 THEN LET b_sfs.sfs05 = 0 END IF    
    #FUN-A60095(E)
    LET b_sfs.sfs06=g_sfa2.sfa12
    LET b_sfs.sfs27=g_sfa2.sfa27    #MOD-910167       #MOD-980243 modify NULL -> g_sfa2.sfa27
 
#TQC-C30067  ---add--begin
    IF g_sfa2.sfa26 MATCHES '[B,C]' THEN
       LET b_sfs.sfs26 = g_sfa2.sfa26
    END IF 
#TQC-C30067  ---add--end
    SELECT ima35,ima36 INTO b_sfs.sfs07,b_sfs.sfs08 FROM ima_file
     WHERE ima01 = b_sfs.sfs04
   ##Add No.FUN-AB0018  #Mark No.FUN-AB0054 此处不做判断，交予单据审核时控管
   #IF NOT cl_null(b_sfs.sfs07) THEN
   #   IF NOT s_chk_ware(b_sfs.sfs07) THEN  #检查仓库是否属于当前门店
   #      LET b_sfs.sfs07 = ' '
   #   END IF
   #END IF
   ##End Add No.FUN-AB0018
    #若為成套發料且由工單帶出,則default工單的料倉儲批
   #IF g_sfp.sfp06 = '6' AND issue_type = '3' THEN #CHI-A70060 mark
    IF g_sfp.sfp06 MATCHES '[6789]' AND issue_type = '3' THEN #CHI-A70060
       SELECT sfa30,sfa31,sfaiicd03 
         INTO b_sfs.sfs07,b_sfs.sfs08,b_sfs.sfs09
         FROM sfa_file,sfbi_file
        WHERE sfa01  = g_sfa2.sfa01
          AND sfa03  = g_sfa2.sfa03
          AND sfa08  = g_sfa2.sfa08
          AND sfa12  = g_sfa2.sfa12
          AND sfa27  = g_sfa2.sfa27  #FUN-9B0149
          AND sfa012 = g_sfa2.sfa012  #FUN-A60028 
          AND sfa013 = g_sfa2.sfa013  #FUN-A60028
          AND sfai01 = sfa01
          AND sfai03 = sfa03
          AND sfai08 = sfa08
          AND sfai12 = sfa12          
          AND sfai27 = sfa27  #FUN-9B0149
          AND sfai012= sfa012   #FUN-A60028
          AND sfai013= sfa013   #FUN-A60028
    END IF
    IF (issue_type=2) AND (NOT cl_null(ware_no)) THEN
      LET b_sfs.sfs07=ware_no
      LET b_sfs.sfs08=loc_no
      LET b_sfs.sfs09=lot_no
    END IF
 
    IF g_sfp.sfp06 MATCHES '[6789]' THEN  #NO:7075
       IF g_sfa2.sfa05 <0 THEN
          LET b_sfs.sfs05=g_sfa2.sfa05*(-1)
       END IF
    END IF
 
    LET b_sfs.sfs10=g_sfa2.sfa08
    IF b_sfs.sfs07 IS NULL THEN LET b_sfs.sfs07 = ' ' END IF
    IF b_sfs.sfs08 IS NULL THEN LET b_sfs.sfs08 = ' ' END IF
    IF b_sfs.sfs09 IS NULL THEN LET b_sfs.sfs09 = ' ' END IF
    LET b_sfs.sfs012 = g_sfa2.sfa012    #MOD-C80213 add
    LET b_sfs.sfs013 = g_sfa2.sfa013    #MOD-C80213 add
#FUN-A60028 --begin--
    IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
    IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
#FUN-A60028 --end--     
    IF g_sma.sma115 = 'Y' THEN
       CALL i501_set_du_by_origin()
    END IF
    LET b_sfs.sfs930=i501_get_sfs930(b_sfs.sfs03) #FUN-670103
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27=b_sfs.sfs04
    END IF
    IF cl_null(b_sfs.sfs27) THEN
       LET b_sfs.sfs27 = ' '
    END IF

 
    LET b_sfs.sfsplant = g_plant #FUN-980008 add
    LET b_sfs.sfslegal = g_legal #FUN-980008 add
    IF b_sfs.sfs014 IS NULL THEN LET b_sfs.sfs014=' ' END IF #FUN-C70014 add
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN
       LET b_sfs.sfs37=s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,g_sfp.sfp16,g_sfp.sfp07)
    END IF
    #FUN-CB0087--add--str-- 

    INSERT INTO sfs_file VALUES(b_sfs.*)
    IF STATUS THEN 
       CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,STATUS,"","ins sfs:",1)  #No.FUN-660128
       END IF
    #FUN-B70061 --START--
    LET b_sfsi.sfsi01 = b_sfs.sfs01
    LET b_sfsi.sfsi02 = b_sfs.sfs02
    IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
    
    END IF
    #FUN-B70061 --END--
    CALL i501_ins_rvbs(b_sfs.sfs02,b_sfs.sfs03,b_sfs.sfs04)   #No.FUN-870106
    
  END FOREACH
 
END FUNCTION
 
FUNCTION i500_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   #No.FUN-680121 DEC(15,3)
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   #No.FUN-680121 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
     IF g_sfp.sfp06 ='6' THEN    #CHI-C90017 add
        LET i=p_qty / l_ima64
     ELSE                        #CHI-C90017 add
        LET i=p_qty / l_ima64 + 0.999999
     END IF                      #CHI-C90017 add
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION
 
FUNCTION i501_sort_by_partno() 		#
  DEFINE l_sfs	RECORD LIKE sfs_file.*
 
  SELECT COUNT(*) INTO g_i FROM sfq_file WHERE sfq01=g_sfp.sfp01
  IF g_i<=1 THEN RETURN END IF
 
  UPDATE sfs_file SET sfs02=sfs02+1000 WHERE sfs01=g_sfp.sfp01
 
  DECLARE i501_sort_c CURSOR FOR
    SELECT * FROM sfs_file
     WHERE sfs01=g_sfp.sfp01
     ORDER BY sfs04,sfs03
 
  LET g_i=0
  FOREACH i501_sort_c INTO l_sfs.*
     LET g_i=g_i+1
     UPDATE sfs_file SET sfs02=g_i
      WHERE sfs01=l_sfs.sfs01
        AND sfs02=l_sfs.sfs02
  END FOREACH
 
END FUNCTION
 
FUNCTION i501_b()
DEFINE
    l_ac_t              LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_row,l_col         LIKE type_file.num5,                #No.FUN-680121 SMALLINT,	           #分段輸入之行,列數
    l_n,l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw           LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd               LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_b2      		LIKE type_file.chr50,   #No.FUN-680121 VARCHAR(30),
    l_b3      		LIKE sfa_file.sfa08,
    l_b4                LIKE sfa_file.sfa012,   #FUN-B20079
    l_b5                LIKE sfa_file.sfa013,   #FUN-B20079
    l_sfa06             LIKE sfa_file.sfa06,
    l_sfa062            LIKE sfa_file.sfa062,   #No.MOD-940164 add
    l_sfa05             LIKE sfa_file.sfa05,    #No.TQC-6C0122 add
    l_sfb08             LIKE sfb_file.sfb08,    #MOD-8B0230 add
    l_sfa100            LIKE sfa_file.sfa100,   #MOD-8B0230 add
    l_sfa100_t          LIKE sfa_file.sfa100,   #MOD-8B0230 add
    l_sfa161            LIKE sfa_file.sfa161,
    l_sfb09             LIKE sfb_file.sfb09,
    l_sfb11             LIKE sfb_file.sfb11,    #No.MOD-760050 add
    l_ima35	            LIKE ima_file.ima35, #MOD-580001
    l_ima36	            LIKE ima_file.ima36, #MOD-580001
    l_sfq               RECORD LIKE sfq_file.*,
    l_qty		            LIKE sfa_file.sfa06,  #No.FUN-680121 DECIMAL(15,3),
    l_sub_qty		        LIKE sfa_file.sfa06,  #No.MOD-7C0166 add
    l_sub_qty1          LIKE sfa_file.sfa06,  #No.MOD-7C0166 add
    t_sfa05             LIKE sfa_file.sfa05,
    t_sfa06             LIKE sfa_file.sfa06,
    t_short_qty         LIKE sfa_file.sfa07,  #FUN-940039 add
    s_sfa05             LIKE sfa_file.sfa05,
    s_sfa06             LIKE sfa_file.sfa06,
    l_ima108            LIKE ima_file.ima108,
    l_ima70             LIKE ima_file.ima70,
    l_sfa11             LIKE sfa_file.sfa11,    #No:9724
    l_sfs05x            LIKE sfs_file.sfs05,    #FUN-560047
    l_sfs32x            LIKE sfs_file.sfs32,    #MOD-A60062 add
    l_sfs35x            LIKE sfs_file.sfs35,    #MOD-A60062 add
    l_msg               LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(72) #FUN-560047
    no1		        LIKE type_file.num10,   #No.FUN-680121 INTEGER
    l_factor            LIKE ima_file.ima31_fac,#No.FUN-680121 DECIMAL(16,8)
    l_flag              LIKE type_file.num10,   #No.FUN-830132 add
    l_allow_insert      LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_sfa06_t           LIKE sfa_file.sfa06,
    l_sfa161_t          LIKE sfa_file.sfa161,
    l_sfa26             LIKE sfa_file.sfa26,
    l_sfa27             LIKE sfa_file.sfa27,
    l_sfa28             LIKE sfa_file.sfa28,
    l_sfa28_t           LIKE sfa_file.sfa28,
    l_sfs05             LIKE sfs_file.sfs05,
    l_allow_delete      LIKE type_file.num5,                #可刪除否  #No.FUN-680121 SMALLINT
    l_sfb02             LIKE sfb_file.sfb02    #FUN-660110 add
DEFINE l_i     LIKE type_file.num5
DEFINE l_fac   LIKE ima_file.ima31_fac  #TQC-7B0065
 
DEFINE l_sfa29          LIKE sfa_file.sfa29
DEFINE l_totsfs05       LIKE sfs_file.sfs05   #No.TQC-750232
DEFINE l_sfa27_a        LIKE sfa_file.sfa27   #MOD-910167
    #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08 #FUN-810038 #FUN-BA0058 mark
    DEFINE l_sfbiicd14  LIKE sfbi_file.sfbiicd14  #FUN-810038
#   DEFINE l_imaicd13   LIKE imaicd_file.imaicd13 #FUN-A40022  #FUN-BA0050
DEFINE   l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
DEFINE l_ima159         LIKE ima_file.ima159  #FUN-BA0050
DEFINE l_cn             LIKE type_file.num5   #TQC-940138 add
DEFINE l_sfa08_tmp         LIKE sfa_file.sfa08
DEFINE l_sfa12_tmp         LIKE sfa_file.sfa12
DEFINE l_sfa27_tmp         LIKE sfa_file.sfa27
DEFINE l_sfa36          LIKE sfa_file.sfa36   #FUN-950088 add
DEFINE l_sfb05          LIKE sfb_file.sfb05   #No.MOD-930195 add
DEFINE l_bno            LIKE rvbs_file.rvbs08 #CHI-9A0022
DEFINE l_sie            RECORD LIKE sie_file.* #FUNA-A20048 add 
DEFINE l_sfb06          LIKE sfb_file.sfb06   #FUN-A60028 
DEFINE l_flag1          LIKE type_file.num5   #MOD-AC0336
DEFINE b_sfa06          LIKE sfa_file.sfa06   #MOD-B20062 add
DEFINE b_sfa05          LIKE sfa_file.sfa06   #MOD-B20062 add
DEFINE b_sfs05          LIKE sfs_file.sfs05   #MOD-B20062 add
DEFINE sum_sfs05        LIKE sfs_file.sfs05   #MOD-B20062 add
DEFINE b_sfa27          LIKE sfa_file.sfa27   #MOD-B20062 add
DEFINE b_sfa28          LIKE sfa_file.sfa28   #MOD-B20062 add
#TQC-B60036--add--str--
DEFINE l_ima64          LIKE ima_file.ima64
DEFINE l_ima641         LIKE ima_file.ima641
DEFINE l_num_y          LIKE sfs_file.sfs05
DEFINE l_num_z          LIKE type_file.num20
#TQC-B60036--add--end--
DEFINE l_sfs35          LIKE sfs_file.sfs35  #FUN-B20095
DEFINE l_ima906         LIKE ima_file.ima906 #FUN-B20095
DEFINE l_sum_sfs05      LIKE sfs_file.sfs05  #NO.TQC-B90236 add
DEFINE l_base_sfa05     LIKE sfa_file.sfa05  #CHI-BC0040 add
DEFINE l_replace        LIKE type_file.chr1  #TQC-C30028 add
DEFINE l_c              LIKE type_file.num5  #CHI-C30106---add 
DEFINE l_flag2          LIKE type_file.chr1  #FUN-CB0087 add       
DEFINE l_where          STRING               #FUN-CB0087 add  
DEFINE l_imd10          LIKE imd_file.imd10  #MOD-D60040 add 
DEFINE l_gfe03          LIKE gfe_file.gfe03  #MOD-D60168 add
DEFINE l_sfq03          LIKE sfq_file.sfq03  #2013090084 add
 
#NO.TQC-B90236 ------add----begin  只有成套發料(asfi511)才可顯示與執行
    #IF g_prog = 'asfi511' THEN                          #TQC-C30067  mark 
     IF g_prog = 'asfi511' OR g_prog = 'asfi526' THEN    #TQC-C30067  add
        CALL cl_set_act_visible("formula_alternative",TRUE)
     ELSE
        CALL cl_set_act_visible("formula_alternative",FALSE)
     END IF 
   
#NO.TQC-B90236 ------add----end

    #TQC-AC0197 Begin------------------------------
     IF g_action_choice = "warahouse_modify" THEN
        LET g_wm = 'Y'
     ELSE
       LET g_wm = 'N'
     END IF
    #TQC-AC0197 End--------------------------------

    LET g_action_choice = ""
    IF g_wm != 'Y' THEN      #TQC-AC0197
       IF g_sfp.sfp01 IS NULL THEN RETURN END IF
       SELECT * INTO g_sfp.* FROM sfp_file WHERE sfp01=g_sfp.sfp01
       IF g_sfp.sfp04 = 'Y' THEN CALL cl_err('','mfg0175',1) RETURN END IF
       IF g_sfp.sfpconf = 'X' THEN CALL cl_err('','9024',1) RETURN END IF #FUN-660106
       IF g_sfp.sfpconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF #FUN-660106
    END IF                   #TQC-AC0197

    #FUN-AB0001  add str ---
    IF g_sfp.sfp15 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
       RETURN
    END IF
    IF g_sfp.sfpconf='Y' AND g_sfp.sfp15 = "1" AND g_sfp.sfpmksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-AB0001  add end ---

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM sfs_file ",
                       " WHERE sfs01= ? AND sfs02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_bcl CURSOR FROM g_forupd_sql
 
    #FUN-B70061 --START--
    LET g_forupd_sql = " SELECT * FROM sfsi_file ",
                          " WHERE sfsi01= ? AND sfsi02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_bcl_ind CURSOR FROM g_forupd_sql
    #FUN-B70061 --END--
 
   #TQC-AC0197 Begin-------------------------
    IF g_wm = 'Y' THEN            
       LET l_allow_insert = FALSE  
       LET l_allow_delete = FALSE 
    ELSE
   #TQC-AC0197 End---------------------------
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
    END IF          #TQC-AC0197        
 
    IF g_rec_b=0 THEN CALL g_sfs.clear() END IF
    IF g_rec_b > 0  THEN LET l_ac = 1  END IF
 
    INPUT ARRAY g_sfs WITHOUT DEFAULTS FROM s_sfs.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF NOT (g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
              CALL cl_set_docno_format("sfs03")
           END IF
           IF g_wm = 'N'THEN    #TQC-AC0197
              IF g_rec_b!=0 THEN
                 CALL fgl_set_arr_curr(l_ac)
                 CALL i501_set_entry_b('u')
                 CALL i501_set_no_entry_b('u')
              ELSE
                 CALL i501_set_entry_b('a')
                 CALL i501_set_no_entry_b('a')
              END IF              
#TQC-AC0197 ---------------------------Begin--------------------------
           ELSE
              CALL cl_set_comp_entry("sfs02,sfs26,sfs03,sfs04,sfs27,sfs06,sfs012,sfs013,sfs10,sfs05,sfs21,sfs36 ",FALSE)    
           END IF               
#TQC-AC0197 ---------------------------End---------------------------
           IF g_wm = 'N'THEN     #TQC-AC0197
#FUN-A60028 --begin--
           IF g_sma.sma541 = 'Y' THEN 
          #   CALL cl_set_comp_entry("sfs10",FALSE)   #FUN-B20079 mark
          #ELSE                                       #FUN-B20079 mark
              CALL cl_set_comp_entry("sfs10",TRUE)
           END IF     #TQC-AC0197	
#FUN-A60028 --end--            
           END IF  
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
	    BEGIN WORK
            DISPLAY "begin work"
            OPEN i501_cl USING g_sfp.sfp01                     #09/10/21 xiaofeizhu Add
            IF STATUS THEN
               CALL cl_err("OPEN i501_cl:", STATUS, 1)
               CLOSE i501_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i501_cl INTO g_sfp.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE i501_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sfs_t.* = g_sfs[l_ac].*  #BACKUP
         #FUN-BB0084 -----------Begin------------
               LET g_sfs06_t = g_sfs[l_ac].sfs06
               LET g_sfs30_t = g_sfs[l_ac].sfs30
               LET g_sfs33_t = g_sfs[l_ac].sfs33
         #FUN-BB0084 -----------End--------------
               LET g_sfp.sfpmodu=g_user              #NO:6908
               LET g_sfp.sfpdate=g_today             #NO:6908
               DISPLAY BY NAME g_sfp.sfpmodu         #NO:6908
               DISPLAY BY NAME g_sfp.sfpdate         #NO:6908
#FUN-BA0050 -------------------Begin-----------------
               CALL i501_set_no_required_sfs09()
               CALL i501_set_required_sfs09()
               CALL i501_set_entry_sfs09()
               CALL i501_set_no_entry_sfs09()
#FUN-BA0050 -------------------End-------------------
#No.TQC-B90236-------add-----------begin
               IF g_wm = 'N' THEN
                  CALL cl_set_comp_entry("sfs26,sfs04,sfs27,sfs05",TRUE) #無條件開啟
                  IF g_sma.sma107 = 'N' THEN                     #不可做發料替代
                     CALL cl_set_comp_entry("sfs26",FALSE)
                  END IF
                  IF g_sfs[l_ac].sfs26 MATCHES '[BC]' THEN
                     CALL cl_set_comp_entry("sfs26,sfs04,sfs27,sfs05",FALSE)
                  END IF
               END IF
#No.TQC-B90236-------add-----------end

 
               OPEN i501_bcl USING g_sfp.sfp01,g_sfs_t.sfs02
               IF STATUS THEN
                  CALL cl_err("OPEN i501_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i501_bcl INTO b_sfs.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock sfs',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     #FUN-B70061 --START--
                     OPEN i501_bcl_ind USING g_sfp.sfp01,g_sfs_t.sfs02
                     IF STATUS THEN
                        CALL cl_err("OPEN i501_bcl_ind:", STATUS, 1)
                        LET l_lock_sw = "Y"
                     ELSE 
                        FETCH i501_bcl_ind INTO b_sfsi.*
                        IF SQLCA.sqlcode THEN
                           CALL cl_err('lock sfsi',SQLCA.sqlcode,1)
                           LET l_lock_sw = "Y"
                        END IF 
                     END IF
                     #FUN-B70061 --END--
                     CALL i501_b_move_to()
                     CALL i501_azf03_desc()  #TQC-D20042 add
                     IF g_wm != 'Y' THEN         #TQC-AC0197
                        CALL i501_set_entry_b(p_cmd)
                        CALL i501_set_no_entry_b(p_cmd)
                     END IF                      #TQC-AC0197
                     LET g_sfs[l_ac].gem02c=s_costcenter_desc(g_sfs[l_ac].sfs930) #FUN-670103
                     SELECT mse02 INTO g_sfs[l_ac].mse02
                       FROM mse_file WHERE mse01=g_sfs[l_ac].sfs36
                     DISPLAY g_sfs[l_ac].mse02 TO FORMONLY.mse02
                  END IF
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(b_sfs.sfs04) THEN
                     SELECT ima55,ima31 INTO g_ima55,g_ima31
                       FROM ima_file WHERE ima01=b_sfs.sfs04
 
                     CALL s_chk_va_setting(b_sfs.sfs04)
                          RETURNING g_flag,g_ima906,g_ima907
                  END IF
                  IF g_wm != 'Y' THEN            #TQC-AC0197 
                     CALL i501_set_entry_b('u')
                     CALL i501_set_no_entry_b('u')
                     CALL i501_set_no_required()
                     CALL i501_set_required()    
                     #FUN-B70061 --START--                     
                     CALL i501_set_no_required_sfsiicd028()   
                     CALL i501_set_required_sfsiicd028(p_cmd)
                     CALL i501_set_no_required_sfsiicd029()   
                     CALL i501_set_required_sfsiicd029(p_cmd)  
                     #FUN-B70061 --END--

                  ELSE                           #TQC-AC0197
                     NEXT FIELD sfs07            #TQC-AC0197
                  END IF                         #TQC-AC0197
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            INITIALIZE g_sfs_t.* TO NULL
            INITIALIZE b_sfs.* TO NULL     #No.MOD-950017 add
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sfs[l_ac].* TO NULL      #900423
        #FUN-BB0084 ----------Begin---------
            LET g_sfs06_t = NULL
            LET g_sfs30_t = NULL
            LET g_sfs33_t = NULL
        #FUN-BB0084 ----------End-----------
            LET b_sfs.sfs01=g_sfp.sfp01
            LET g_sfs[l_ac].sfs05=0
            LET g_sfs[l_ac].sfs10=' '
            LET g_sfs[l_ac].sfs28=1               #CHI-BC0040 add
            IF g_sma.sma541 = 'N' THEN  #FUN-B20079 jan
               LET g_sfs[l_ac].sfs012=' '  #TQC-AB0183
               LET g_sfs[l_ac].sfs013=0    #TQC-AB0183
            END IF  #FUN-B20079 jan
            LET g_sfs[l_ac].sfs930=s_costcenter(g_sfp.sfp07) #FUN-670103
            LET g_sfs[l_ac].gem02c=s_costcenter_desc(g_sfs[l_ac].sfs930) #FUN-670103
            CALL i501_set_entry_b(p_cmd)
            CALL i501_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sfs02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               ROLLBACK WORK #MOD-640419 解除mark
                CANCEL INSERT #MOD-4A0307
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_sfs[l_ac].sfs04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD sfs04
               END IF
 
               CALL i501_du_data_to_correct()
 
 
               IF cl_null(g_sfs[l_ac].sfs08) THEN LET g_sfs[l_ac].sfs08 = ' ' END IF
               IF cl_null(g_sfs[l_ac].sfs09) THEN LET g_sfs[l_ac].sfs09 = ' ' END IF
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=g_sfs[l_ac].sfs04
                  AND img02=g_sfs[l_ac].sfs07
                  AND img03=g_sfs[l_ac].sfs08
                  AND img04=g_sfs[l_ac].sfs09
               IF cl_null(g_img09) THEN
                  CALL cl_err(g_sfs[l_ac].sfs04,'mfg6069',0)
                  NEXT FIELD sfs04
               END IF
 
               CALL i501_set_origin_field()
               IF NOT (g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
                  #計算sfs05的值,檢查入庫數量的合理性
                  CALL i501_check_inventory_qty()
                      RETURNING g_flag
                  IF g_flag = '1' THEN
                     IF g_ima906 = '2' OR g_ima906 = '3' THEN
                        NEXT FIELD sfs35
                     ELSE
                        NEXT FIELD sfs32
                     END IF
                  END IF
                  IF g_flag = '2' THEN
                     IF g_ima906 = '2' OR g_ima906 = '3' THEN
                        NEXT FIELD sfs33
                     ELSE
                        NEXT FIELD sfs30
                     END IF
                  END IF
               END IF
            END IF
 
            CALL i501_b_move_back()
            CALL i501_b_else()
            IF g_sfs[l_ac].sfs04 IS NULL AND g_sfs[l_ac].sfs05 = 0 THEN
               DISPLAY 'import field is null OR blank '
               INITIALIZE g_sfs[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_sfs[l_ac].* TO s_sfs[l_ac].*
               CANCEL INSERT
            END IF
            #   料號為參考單位,單一單位,且狀態不為wafer(imaicd04<>0,1,2)時,
            #    將單位一的資料給單位二
            CALL i501_ind_icd_set_value()
           #IF NOT cl_null(l_sfa27_a) THEN LET b_sfs.sfs27=l_sfa27_a END IF #MOD-910229  #TQC-B50140 Mark
            IF cl_null(b_sfs.sfs27) THEN
               LET b_sfs.sfs27=b_sfs.sfs04
            END IF
            IF cl_null(b_sfs.sfs27) THEN
               LET b_sfs.sfs27 = ' '
            END IF
            IF cl_null(b_sfs.sfs28) THEN
               SELECT sfa28 INTO b_sfs.sfs28
                 FROM sfa_file
                WHERE sfa01 = b_sfs.sfs03 
                  AND sfa03 = b_sfs.sfs04
                  AND sfa08 = b_sfs.sfs10
                  AND sfa12 = b_sfs.sfs06
                  AND sfa27 = b_sfs.sfs27
                  AND sfa012= b_sfs.sfs012   #FUN-A60028 
                  AND sfa013= b_sfs.sfs013   #FUN-A60028
            END IF
            #FUN-A60028 --begin--
            IF cl_null(b_sfs.sfs012) THEN LET b_sfs.sfs012 = ' ' END IF 
            IF cl_null(b_sfs.sfs013) THEN LET b_sfs.sfs013 = 0   END IF  
            #FUN-A60028 --end--     
            IF b_sfs.sfs014 IS NULL THEN LET b_sfs.sfs014=' ' END IF  #FUN-C70014 add
            INSERT INTO sfs_file VALUES(b_sfs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,SQLCA.sqlcode,"","ins sfs",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               #FUN-B70061 --START--
               LET b_sfsi.sfsi01 = b_sfs.sfs01
               LET b_sfsi.sfsi02 = b_sfs.sfs02
               IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
                  CANCEL INSERT
               END IF
               #FUN-B70061 --END--
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
        BEFORE FIELD sfs02                            #default 序號
            IF g_sfs[l_ac].sfs02 IS NULL OR g_sfs[l_ac].sfs02 = 0 THEN
                SELECT MAX(sfs02)+1 INTO g_sfs[l_ac].sfs02
                   FROM sfs_file WHERE sfs01 = g_sfp.sfp01
                IF g_sfs[l_ac].sfs02 IS NULL THEN LET g_sfs[l_ac].sfs02=1 END IF
            END IF
 
        AFTER FIELD sfs02                        #check 序號是否重複
            #若已有idb存在不可修改
           #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
            IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
               IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs02) THEN
                  IF g_sfs_t.sfs02 <> g_sfs[l_ac].sfs02 THEN
                     CALL i501_ind_icd_chk_icd()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_sfs[l_ac].sfs02 = g_sfs_t.sfs02
                        NEXT FIELD sfs02
                     END IF
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_sfs[l_ac].sfs02) THEN
               IF g_sfs[l_ac].sfs02 != g_sfs_t.sfs02 OR
                  g_sfs_t.sfs02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM sfs_file
                       WHERE sfs01 = g_sfp.sfp01
                         AND sfs02 = g_sfs[l_ac].sfs02
                   IF l_n > 0 THEN
                       LET g_sfs[l_ac].sfs02 = g_sfs_t.sfs02
                       CALL cl_err('',-239,0) NEXT FIELD sfs02
                   END IF
               END IF
            END IF

 
        AFTER FIELD sfs26
           IF NOT cl_null(g_sfs[l_ac].sfs26) THEN
             #IF g_sfs[l_ac].sfs26 NOT MATCHES '[SU]' THEN   #No.TQC-5C0135 mark
              IF g_sfs[l_ac].sfs26 NOT MATCHES '[SUTZ]' THEN  #No.TQC-5C0135 add   #FUN-A40058 add 'Z'
                 NEXT FIELD sfs26
              END IF
           END IF
           CALL i501_chk_entry_sfs27()  #TQC-C70050 add
           
          ON CHANGE sfs26
#NO.TQC-B90236------add----begin 不能手動選擇9BC選項
              IF p_cmd = 'a' OR
                (p_cmd ='u' AND g_sfs_t.sfs26 != g_sfs[l_ac].sfs26) 
                OR (p_cmd = 'u' AND (g_sfs_t.sfs26 IS NULL)) THEN
                IF g_sfs[l_ac].sfs26 MATCHES '[9BC]' THEN
                  LET g_sfs[l_ac].sfs26 = g_sfs_t.sfs26
                  DISPLAY BY NAME g_sfs[l_ac].sfs26
                  NEXT FIELD sfs26
                END IF
             END IF
#NO.TQC-B90236------add----end
          IF (cl_null(g_sfs[l_ac].sfs03)) AND (NOT (g_sfp.sfp06 MATCHES '[ABC]')) THEN #FUN-5C0114
             NEXT FIELD sfs03
          ELSE
           #CHI-C50011 str add-----
             CALL i501_chk_entry_sfs27()
               LET g_sfs[l_ac].sfs27 = ''
               DISPLAY BY NAME g_sfs[l_ac].sfs27 
            #CHI-C50011 end add-----
             #NEXT FIELD sfs04 #MOD-D30037
             NEXT FIELD sfs03  #MOD-D30037
          END IF

#FUN-BA0050 ---------------Begin-----------------
        BEFORE FIELD sfs03
           CALL i501_set_no_required_sfs09()
           CALL i501_set_entry_sfs09()
#FUN-#A0050 ---------------End-------------------
 
#-----CHI-BC0040 str add--------
        BEFORE FIELD sfs28
          SELECT COUNT(*) INTO l_flag1 FROM sfa_file WHERE sfa01=g_sfs[l_ac].sfs03 AND sfa03=g_sfs[l_ac].sfs04
          IF g_sfs[l_ac].sfs26 MATCHES '[SU]' AND l_flag1=0 THEN
             CALL cl_set_comp_entry("sfs28",TRUE)
          ELSE
             CALL cl_set_comp_entry("sfs28",FALSE)
          END IF

         AFTER FIELD sfs28
           IF g_sfs[l_ac].sfs26 MATCHES '[SU]' AND cl_null(g_sfs[l_ac].sfs28) THEN
                CALL cl_err('','aps-100',1)
                NEXT FIELD sfs28
           END IF
           CALL cl_set_comp_entry("sfs28",TRUE)

#-----CHI-BC0040 end add--------

        #FUN-C70014 add begin-------------
        AFTER FIELD sfs014
           IF NOT cl_null(g_sfs[l_ac].sfs014) THEN 
              SELECT COUNT(*) INTO l_n FROM shm_file
               WHERE shm01 = g_sfs[l_ac].sfs014
                 AND shm28 = 'N'
              IF l_n = 0 THEN 
                 CALL cl_err('','asf-910',1)
                 LET g_sfs[l_ac].sfs014 = g_sfs_t.sfs014
                 NEXT FIELD sfs014
              END IF 
              
              SELECT shm012 INTO g_sfs[l_ac].sfs03 FROM shm_file
               WHERE shm01 = g_sfs[l_ac].sfs014
                 AND shm28 = 'N'
              DISPLAY BY NAME g_sfs[l_ac].sfs03
           END IF 
        #FUN-C70014 add end --------------

        AFTER FIELD sfs03
           CALL i501_set_required_sfs09()    #FUN-BA0050
           CALL i501_set_no_entry_sfs09()    #FUN-BA0050
#FUN-AA0059 ---------------------start----------------------------
          #IF NOT cl_null(g_sfs[l_ac].sfs03) THEN                             #No.FUN-AB0021
           IF NOT cl_null(g_sfs[l_ac].sfs03) AND g_argv2 MATCHES '[ABC]' THEN #No.FUN-AB0021
              IF NOT s_chk_item_no(g_sfs[l_ac].sfs03,"") THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD sfs03
              END IF
           END IF
#FUN-AA0059 ---------------------end-------------------------------
           #TQC-D70055---begin
           IF g_prog = 'asfi514' OR g_prog = 'asfi529' THEN
             #SELECT sfa01 FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03 AND sfa11 = 'E'           #MOD-D80178 mark
              SELECT DISTINCT sfa01 FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03 AND sfa11 = 'E'  #MOD-D80178 add
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 NEXT FIELD sfs03
              END IF
           END IF
           #TQC-D70055---end 
           IF (NOT cl_null(g_sfs[l_ac].sfs03)) AND (NOT (g_sfp.sfp06 MATCHES '[ABC]')) THEN #FUN-5C0114
              CALL i501_sfb01(g_sfs[l_ac].sfs03)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfs[l_ac].sfs03,g_errno,0)
                 NEXT FIELD sfs03
              END IF
              SELECT sfb02 INTO l_sfb02 FROM sfb_file
               WHERE sfb01=g_sfs[l_ac].sfs03
              IF l_sfb02 = '15' THEN
                 CALL cl_err(g_sfs[l_ac].sfs03,'asr-047',1)   #所輸入之工單型態
                 NEXT FIELD sfs03
              END IF
 
              IF g_sfp.sfp06 NOT MATCHES '[24789]' THEN
                 SELECT COUNT(*) INTO l_n FROM sfq_file
                  WHERE sfq01 = g_sfp.sfp01
                    AND sfq02 = g_sfs[l_ac].sfs03
                 IF l_n = 0 THEN
                    CALL cl_err(g_sfs[l_ac].sfs03,'asf-999',1)
                    NEXT FIELD sfs03
                 END IF
              END IF
              #TQC-CA0044 add begin-------------
              IF g_sfp.sfp06 = 'D' AND NOT cl_null(g_sfs[l_ac].sfs014) AND 
                 NOT cl_null(g_sfs[l_ac].sfs03) THEN
                 SELECT COUNT(*) INTO l_cnt FROM shm_file
                  WHERE shm01 = g_sfs[l_ac].sfs014
                    AND shm012 = g_sfs[l_ac].sfs03
                    AND shm28 = 'N'
                 IF l_cnt = 0 THEN
                    CALL cl_err('','asf1033',1)
                    NEXT FIELD sfs03
                 END IF
              END IF 
              #TQC-CA0044 add end --------------
              SELECT * INTO g_sfb.* FROM sfb_file
               WHERE sfb01=g_sfs[l_ac].sfs03 AND sfbacti='Y' AND sfb87!='X'
              IF STATUS THEN
                 CALL cl_err3("sel","sfb_file",g_sfs[l_ac].sfs03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
                 NEXT FIELD sfs03  
              END IF

              IF g_sfb.sfb81 > g_sfp.sfp02 THEN
                 CALL cl_err(g_sfs[l_ac].sfs03,'asf-819',0) NEXT FIELD sfs03
              END IF
              IF g_sfb.sfb04='1' THEN
                 CALL cl_err('sfb04=1','asf-381',0) NEXT FIELD sfs03
              END IF
              IF g_sfb.sfb04='8' THEN
                 CALL cl_err('sfb04=8','asf-345',0) NEXT FIELD sfs03
              END IF
              IF g_sfb.sfb04 < 4 AND g_argv2 = 2 THEN                 #CHI-C40013 add
                   CALL cl_err('','asf-383',0) NEXT FIELD sfs03       #CHI-C40013 add
              END IF                                                  #CHI-C40013 add
              IF g_sfb.sfb02=13 THEN   #bugno:4863
                 CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD sfs03
              END IF
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM snb_file
               WHERE snb01 = g_sfs[l_ac].sfs03
                #AND snbconf = 'N'    #MOD-B60143 mark
                 AND snbconf != 'X'   #MOD-B60143 add
                 AND snb99 != '2'     #MOD-B60143 add
              IF l_cnt > 0 THEN
                 CALL cl_err('check sfs','asf-068',0)
                 NEXT FIELD sfs03
              END IF
              LET g_sfs[l_ac].sfs930=s_costcenter(g_sfb.sfb98) #FUN-670103
              LET g_sfs[l_ac].gem02c=s_costcenter_desc(g_sfs[l_ac].sfs930) #FUN-670103
           END IF
 
           IF (NOT cl_null(g_sfs[l_ac].sfs03)) AND (g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
               WHERE ima01 = g_sfs[l_ac].sfs03
                 AND imaacti = 'Y'
                 AND ima911='Y' #MOD-630064
              IF l_cnt = 0 THEN
                 CALL cl_err('chk ima:','100',0)
                 NEXT FIELD sfs03
              END IF
              #FUN-B20079 jan (S)
              CALL i501_chk_sfs()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD sfs03
              END IF
              #FUN-B20079 jan (E)
           END IF
 
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_sfs[l_ac].sfs27) AND 
              NOT cl_null(g_sfs[l_ac].sfs03) THEN     #FUN-B80143              
              #NOT cl_null(g_sfs[l_ac].sfs04) AND      #FUN-B80143 mark 
              #g_sfs[l_ac].sfs012 IS NOT NULL AND      #FUN-A60028  ADD #FUN-B80143 mark
              #NOT cl_null(g_sfs[l_ac].sfs013) THEN    #FUN-A60028 ADD #FUN-B80143 mark
              
             #FUN-B80143 --START mark--
             # SELECT COUNT(*) INTO l_n FROM sfa_file
             #  WHERE sfa01 = g_sfs[l_ac].sfs03
             #    #AND sfa03 = g_sfs[l_ac].sfs04  #TQC-B50089
             #    #AND sfa27 = g_sfs[l_ac].sfs27  #TQC-B50089
             #    AND sfa03 = g_sfs[l_ac].sfs27  #TQC-B50089
             #    AND sfa012= g_sfs[l_ac].sfs012    #FUN-A60028 #TQC-AB0183
             #    AND sfa013= g_sfs[l_ac].sfs013    #FUN-A60028 #TQC-AB0183
             #FUN-B80143 --END mark--
              
              #FUN-B80143 --START--
              IF cl_null(g_sfs[l_ac].sfs012) THEN
                 LET g_sfs[l_ac].sfs012 = ' '
              END IF
              IF cl_null(g_sfs[l_ac].sfs013) THEN
                 LET g_sfs[l_ac].sfs013 = 0
              END IF      
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_sfs[l_ac].sfs03, "'",
                          "   AND sfa03 ='", g_sfs[l_ac].sfs27, "'",
                          "   AND sfa012 ='", g_sfs[l_ac].sfs012, "'",
                          "   AND sfa013 ='", g_sfs[l_ac].sfs013, "'"                          
              IF g_sfp.sfp06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i501_b_p1 FROM g_sql
              DECLARE i501_b_c1 CURSOR FOR i501_b_p1
              OPEN i501_b_c1
              FETCH i501_b_c1 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i501_b_c1
                 NEXT FIELD sfs03 
              END IF 
              CLOSE i501_b_c1
              #FUN-B80143 --END--
                 
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD sfs03
#FUN-A60028 --begin--
              ELSE
            	  #SELECT sfb06 INTO l_sfb06 FROM sfb_file  #MOD-AC0336    #FUN-B20079 jan
            	  # WHERE sfb01 = g_sfs[l_ac].sfs03                        #FUN-B20079 jan
                  #CALL s_schdat_sel_ima571(g_sfs[l_ac].sfs03) RETURNING l_flag1,l_sfb05 #MOD-AC0336 #FUN-B20079 jan
                  #FUN-B10056 ----------mod start---------------
            	  #SELECT ecu014 INTO g_sfs[l_ac].ecu014 FROM ecu_file
            	  # WHERE ecu01  = l_sfb05
            	  #   AND ecu02  = l_sfb06
            	  #   AND ecu012 = g_sfs[l_ac].sfs012
                   CALL s_schdat_ecm014(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs012) RETURNING g_sfs[l_ac].ecu014
                  #FUN-B10056 ---------mod end-----------------   
            	   DISPLAY BY NAME g_sfs[l_ac].ecu014   
   
#FUN-A60028 --end--                 
              END IF 
           END IF 

#FUN-A60028 --begin--
        BEFORE FIELD sfs012
           IF cl_null(g_sfs[l_ac].sfs03) THEN 
              NEXT FIELD sfs03 
           END IF   
           IF cl_null(g_sfs[l_ac].sfs04) THEN 
              NEXT FIELD sfs04 
           END IF                              
        
        AFTER FIELD sfs012
          #IF cl_null(g_sfs[l_ac].sfs012) THEN 
          #   LET g_sfs[l_ac].sfs012 = ' '
          #END IF  
          IF NOT cl_null(g_sfs[l_ac].sfs012) THEN #FUN-B20079 jan
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM sfa_file
              WHERE sfa01 =g_sfs[l_ac].sfs03 
                AND sfa03 =g_sfs[l_ac].sfs04
               #AND sfa08 =g_sfs[l_ac].sfs10 #FUN-B20079
               #AND sfa12 =g_sfs[l_ac].sfs06 #FUN-B20079 jan
                AND sfa27 =g_sfs[l_ac].sfs27 
                AND sfa012=g_sfs[l_ac].sfs012
             IF l_cnt = 0 THEN 
                CALL cl_err('','aic-036',0)
                NEXT FIELD sfs012
             END IF    
            #SELECT sfb06 INTO l_sfb06 FROM sfb_file  #MOD-AC0336   #FUN-B20079 jan
            # WHERE sfb01 = g_sfs[l_ac].sfs03                      #FUN-B20079 jan
            #CALL s_schdat_sel_ima571(g_sfs[l_ac].sfs03) RETURNING l_flag1,l_sfb05 #MOD-AC0336 #FUN-B20079 jan
            #FUN-B10056 ---------mod start----------  
            #SELECT ecu014 INTO g_sfs[l_ac].ecu014 FROM ecu_file
            # WHERE ecu01  = l_sfb05
            #   AND ecu02  = l_sfb06
            #   AND ecu012 = g_sfs[l_ac].sfs012
            CALL s_schdat_ecm014(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs012) RETURNING g_sfs[l_ac].ecu014 
            #FUN-B10056 --------mod end------------  
             DISPLAY BY NAME g_sfs[l_ac].ecu014   
             #FUN-B20079  jan--add--begin
             CALL i501_chk_sfs()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel sfa:',g_errno,0)
                 NEXT FIELD sfs012
             END IF
             #FUN-B20079 jan--add--end            
          END IF  #FUN-B20079 jan

        BEFORE FIELD sfs013
          IF cl_null(g_sfs[l_ac].sfs03) THEN 
             NEXT FIELD sfs03
          END IF 
           IF cl_null(g_sfs[l_ac].sfs04) THEN 
              NEXT FIELD sfs04 
           END IF                    
          IF g_sfs[l_ac].sfs012 IS NULL THEN 
             NEXT FIELD sfs012
          END IF 
          
        AFTER FIELD sfs013
         IF g_sma.sma541 = 'Y' THEN 
             IF cl_null(g_sfs[l_ac].sfs013) THEN 
                NEXT FIELD sfs013
             END IF  
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM sfa_file
              WHERE sfa01 =g_sfs[l_ac].sfs03 
                AND sfa03 =g_sfs[l_ac].sfs04
               #AND sfa08 =g_sfs[l_ac].sfs10  #FUN-B20079 jan
               #AND sfa12 =g_sfs[l_ac].sfs06  #FUN-B20079 jan
                AND sfa27 =g_sfs[l_ac].sfs27 
                AND sfa012=g_sfs[l_ac].sfs012
                AND sfa013=g_sfs[l_ac].sfs013
             IF l_cnt = 0 THEN 
                CALL cl_err('','aic-036',0)
                NEXT FIELD sfs013
             END IF       
             #FUN-B20079 jan--add--begin
             CALL i501_chk_sfs()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel sfa:',g_errno,0)
                 NEXT FIELD sfs013
             END IF
             #FUN-B20079 jan--add--edd----
          END IF       
#FUN-A60028 --end--
 
        BEFORE FIELD sfs04
           CALL i501_set_entry_b('u')
           CALL i501_set_no_required()
#FUN-BA0050 -----------------Begin---------------
           CALL i501_set_no_required_sfs09()
           CALL i501_set_entry_sfs09()
#FUN-BA0050 -----------------End-----------------
 
        AFTER FIELD sfs04
#FUN-BA0050 -----------------Begin---------------
           CALL i501_set_required_sfs09()
           CALL i501_set_no_entry_sfs09()
#FUN-BA0050 -----------------End-----------------
           #若已有idb存在不可修改
          #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
              IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs04) THEN
                 IF g_sfs_t.sfs04 <> g_sfs[l_ac].sfs04 THEN
                    CALL i501_ind_icd_chk_icd()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_sfs[l_ac].sfs04 = g_sfs_t.sfs04
                       NEXT FIELD sfs04
                    END IF
                 END IF
              END IF
           END IF
           #FUN-AA0007--begin--add-------
           IF NOT s_icdout_holdlot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                   g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09) THEN
              NEXT FIELD sfs04
           END IF
           #FUN-AA0007--end--add---------
           IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_sfs[l_ac].sfs04,"") THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD sfs04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              # 新增時 Default倉庫,儲位
              IF p_cmd = 'a' AND g_sfp.sfp06 MATCHES '[2789]' THEN            #TQC-A30120 add 9
                 SELECT ima35,ima36 INTO g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08
                   FROM ima_file
                  WHERE ima01 = g_sfs[l_ac].sfs04
                 IF cl_null(g_sfs[l_ac].sfs09) THEN 
                    LET g_sfs[l_ac].sfs09 = ' ' 
                 END IF  
                 #Add No.FUN-AB0018
                 IF NOT cl_null(g_sfs[l_ac].sfs07) THEN
                    IF NOT s_chk_ware(g_sfs[l_ac].sfs07) THEN  #检查仓库是否属于当前门店
                       LET g_sfs[l_ac].sfs07 = ' '
                    END IF
                 END IF
                 #End Add No.FUN-AB0018
 
                  DISPLAY BY NAME g_sfs[l_ac].sfs07
                  DISPLAY BY NAME g_sfs[l_ac].sfs08
              END IF
              #GP5.15發料改善:重復性生產時,sfs27=sfs04
              IF g_argv2 MATCHES '[ABC]' THEN 
                 LET g_sfs[l_ac].sfs27 = g_sfs[l_ac].sfs04
              END IF
              #MOD-D30037---begin
              SELECT COUNT(*) INTO l_cnt
                FROM sfa_file 
               WHERE sfa01=g_sfs[l_ac].sfs03
                 AND sfa27=g_sfs[l_ac].sfs27 
                 AND sfa03=g_sfs[l_ac].sfs04
              IF l_cnt = 0 THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfa_file 
                  WHERE sfa01=g_sfs[l_ac].sfs03 
                    AND sfa03=g_sfs[l_ac].sfs04
                 IF l_cnt = 1 THEN
                    SELECT sfa26,sfa27 INTO l_sfa26,l_sfa27
                      FROM sfa_file 
                     WHERE sfa01=g_sfs[l_ac].sfs03 
                       AND sfa03=g_sfs[l_ac].sfs04
                    IF l_sfa26 NOT  MATCHES '[9BCUSTZ]' THEN  
                       LET g_sfs[l_ac].sfs26 = ''
                    END IF 
                    IF g_sfs[l_ac].sfs26 <> l_sfa26 OR g_sfs[l_ac].sfs27 <> l_sfa27 OR cl_null(g_sfs[l_ac].sfs26) OR cl_null(g_sfs[l_ac].sfs27) THEN
                       IF cl_confirm("asf-450") THEN
                          LET g_sfs[l_ac].sfs26 = l_sfa26
                          LET g_sfs[l_ac].sfs27 = l_sfa27
                       END IF 
                    END IF 
                 END IF 
                 IF l_cnt > 1 THEN
                    CALL i501_sfs27_cho()
                    DISPLAY BY NAME g_sfs[l_ac].sfs26
                    DISPLAY BY NAME g_sfs[l_ac].sfs27
                    DISPLAY BY NAME g_sfs[l_ac].sfs04
                 END IF 
              END IF 
              IF cl_null(g_sfs[l_ac].sfs26) THEN
                 LET g_sfs[l_ac].sfs27 = g_sfs[l_ac].sfs04
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfa_file 
                  WHERE sfa01=g_sfs[l_ac].sfs03 
                    AND sfa27=g_sfs[l_ac].sfs27 
                    AND sfa03=g_sfs[l_ac].sfs04
                 IF l_cnt = 0 THEN
                    CALL cl_err('sfs04=sfs27','aem-015',0)
                    NEXT FIELD sfs04
                 END IF 
              END IF 
              #MOD-D30037---end
              IF g_sfs[l_ac].sfs26 MATCHES '[SUZ]' AND             #FUN-A40058 add 'Z'
                 g_sfp.sfp06 MATCHES '[12346789]' THEN             #MOD-B20062 add 6789
                  IF g_sfs[l_ac].sfs04=g_sfs27 THEN        #MOD-9A0123
                    CALL cl_err('sfs04=sfs27','mfg2626',0)
                    NEXT FIELD sfs04
                 END IF
                #GP5.15發料改善修改:b_sfs.sfs27 原由i501_sfs27()開出的
                #畫面手工輸入,現此欄位當g_argv2 NOT MATCHES '[ABC]'
                #(重復性生成模組不顯示)時,在畫面上都顯示出來,故直接
                LET b_sfs.sfs27 = g_sfs[l_ac].sfs27 
                LET g_sfs27 = b_sfs.sfs27   #MOD-9A0123
 
                #因被替代料可以手key,故此處檢查必須sfs27有值 
                IF NOT cl_null(g_sfs[l_ac].sfs03) AND NOT cl_null(b_sfs.sfs27) THEN
                 IF g_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
                    LET l_sfa29=g_sfs[l_ac].sfs03
                 ELSE
                    LET l_sfa29=NULL
                    SELECT MAX(sfa29) INTO l_sfa29 FROM sfa_file
                     WHERE sfa01=g_sfs[l_ac].sfs03
                       AND sfa27=b_sfs.sfs27
                 END IF
                 IF g_sfp.sfp06 NOT MATCHES '[6789B]' THEN      #MOD-C20203 add
                   SELECT COUNT(*) INTO l_n FROM bmd_file	#檢查是否存在取替代檔
                      WHERE bmd01 = b_sfs.sfs27
                         AND (bmd08=l_sfa29     OR bmd08='ALL') #MOD-530024
                        AND bmd04 = g_sfs[l_ac].sfs04
                        AND bmdacti = 'Y'  #MOD-910166 add
                     IF l_n=0 THEN
                        IF g_sma.sma887[1]='Y' THEN
                           CALL cl_err('sel bmd:','mfg2636',0) NEXT FIELD sfs04
                        END IF
                        IF g_sma.sma887[1]='W' THEN
                           IF NOT cl_confirm('mfg2637') THEN NEXT FIELD sfs04 END IF
                        END IF
                     END IF
                 END IF                                          #MOD-C20203 add
                END IF
              END IF    #FUN-940039 add
              #FUN-940039 end
              SELECT COUNT(*) INTO g_cnt FROM sfs_file
               WHERE sfs01=g_sfp.sfp01
                 AND sfs02<>g_sfs[l_ac].sfs02
                 AND sfs04=g_sfs[l_ac].sfs04
                 AND sfs03=g_sfs[l_ac].sfs03     #MOD-BA0197 add
                 AND sfs014=g_sfs[l_ac].sfs014   #TQC-CA0045 add
                 AND sfs07=g_sfs[l_ac].sfs07     #MOD-D60001 add
                 AND sfs08=g_sfs[l_ac].sfs08     #MOD-D60001 add
                 AND sfs09=g_sfs[l_ac].sfs09     #MOD-D60001 add
              IF g_cnt>0 THEN CALL cl_err('','aim-401',0) END IF
 
              SELECT ima25 INTO l_b2
                FROM ima_file WHERE ima01=g_sfs[l_ac].sfs04 AND imaacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_sfs[l_ac].sfs04,"",STATUS,"","sel ima",1)  #No.FUN-660128
                 NEXT FIELD sfs04
              END IF
 
              IF g_sfp.sfp06 MATCHES '[ABC]' THEN
                 LET g_sfs[l_ac].sfs06=''
                 SELECT ima55 INTO g_sfs[l_ac].sfs06 FROM ima_file
                    WHERE ima01=g_sfs[l_ac].sfs04
                 IF cl_null(g_sfs[l_ac].sfs06) THEN
                    SELECT ima25 INTO g_sfs[l_ac].sfs06 FROM ima_file
                       WHERE ima01=g_sfs[l_ac].sfs04
                 END IF
                 LET g_sfs[l_ac].sfs10=' '
                 LET g_sfs[l_ac].sfs012 = ' '      #FUN-B20079
                 LET g_sfs[l_ac].sfs013 = 0        #FUN-B20079
              ELSE
              #  SELECT COUNT(*),MIN(sfa12),MIN(sfa08)  #FUN-B20079  mark
              #    INTO l_n, l_b2, l_b3                 #FUN-B20079  mark
                 SELECT COUNT(*),MIN(sfa12),MIN(sfa08),MIN(sfa012),MIN(sfa013)  #FUN-B20079
                   INTO l_n, l_b2, l_b3,l_b4,l_b5                               #FUN-B20079
                   FROM sfa_file
                  WHERE sfa01=g_sfs[l_ac].sfs03
                    AND (sfa03=g_sfs[l_ac].sfs04 OR sfa03=b_sfs.sfs27)
                 IF l_n=0 THEN
                    CALL cl_err('sel sfa',100,0) NEXT FIELD sfs03
                 END IF
                 IF cl_null(l_b2) THEN LET l_b2 = ' ' END IF
                 IF cl_null(l_b3) THEN LET l_b3 = ' ' END IF
                 IF cl_null(l_b4) THEN LET l_b4 = ' ' END IF                     #FUN-B20079
                 IF cl_null(l_b5) THEN LET l_b5 = 0   END IF                     #FUN-B20079
                 IF cl_null(g_sfs[l_ac].sfs06) THEN
                    LET g_sfs[l_ac].sfs06=l_b2
                 END IF
                 IF cl_null(g_sfs[l_ac].sfs10) THEN
                    LET g_sfs[l_ac].sfs10=l_b3
                 END IF
             #FUN-B20079--add--begin
                 IF cl_null(g_sfs[l_ac].sfs012) THEN
                    LET g_sfs[l_ac].sfs012 = l_b4
                 END IF
                 IF cl_null(g_sfs[l_ac].sfs013) THEN
                    LET g_sfs[l_ac].sfs013 = l_b5
                 END IF
              DISPLAY BY NAME g_sfs[l_ac].sfs012
              DISPLAY BY NAME g_sfs[l_ac].sfs013
             #FUN-B20079--add--end
              DISPLAY BY NAME g_sfs[l_ac].sfs06
              DISPLAY BY NAME g_sfs[l_ac].sfs10
              END IF
              SELECT ima02,ima021 INTO g_sfs[l_ac].ima02, g_sfs[l_ac].ima021
                FROM ima_file
               WHERE ima01=g_sfs[l_ac].sfs04
              DISPLAY g_sfs[l_ac].ima02 TO FORMONLY.ima02
              DISPLAY g_sfs[l_ac].ima021 TO FORMONLY.ima021
             #FUN-940039修改GP5.15發料改善:被替代料可以手key,此處檢查必須sfs27有值
              IF (NOT cl_null(g_sfs[l_ac].sfs27)) AND #FUN-940039  #TQC-9C0048
                 (NOT cl_null(g_sfs[l_ac].sfs06)) THEN  #TQC-9C0048
                 IF  cl_null(g_sfs[l_ac].sfs10) THEN  LET g_sfs[l_ac].sfs10=' ' END IF   #TQC-9C0048
                 IF  cl_null(g_sfs[l_ac].sfs012) THEN  LET g_sfs[l_ac].sfs012=' ' END IF   #FUN-A60028
                 IF  cl_null(g_sfs[l_ac].sfs013) THEN  LET g_sfs[l_ac].sfs013=0 END IF     #FUN-A60028                 
                 IF (g_sfs[l_ac].sfs26 MATCHES '[SUZ]') AND (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN  #FUN-A40058 add 'Z' 
                    SELECT sfa26 INTO g_sfa26 FROM sfa_file
                     WHERE sfa01=g_sfs[l_ac].sfs03
                      #AND sfa03=g_sfs[l_ac].sfs04  #TQC-9C0048 #TQC-B50089
                      #AND sfa27=g_sfs[l_ac].sfs27  #TQC-9C0048 #TQC-B50089
                       AND sfa03=g_sfs[l_ac].sfs27  #TQC-B50089
                       AND sfa12=g_sfs[l_ac].sfs06
                       AND sfa08=g_sfs[l_ac].sfs10
                       AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028
                       AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
                    IF STATUS THEN
                       CALL cl_err3("sel","sfa_file",g_sfs[l_ac].sfs03,b_sfs.sfs27,STATUS,"","sel o.sfa",1)  #No.FUN-660128
                       NEXT FIELD sfs26
                    END IF
                    LET l_sfa29=NULL
                    LET l_sfa11=''     #FUN-9C0040
                    SELECT sfa29,sfa11 INTO l_sfa29,l_sfa11 FROM sfa_file  #TQC-9C0048 #FUN-9C0040
                     WHERE sfa01=g_sfs[l_ac].sfs03
                       AND sfa03=g_sfs[l_ac].sfs04  #TQC-9C0048
                       AND sfa27=g_sfs[l_ac].sfs27  #TQC-9C0048
                       AND sfa12=g_sfs[l_ac].sfs06  #TQC-9C0048
                       AND sfa08=g_sfs[l_ac].sfs10  #TQC-9C0048
                       AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028
                       AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
                       
                    #SELECT bmd07 FROM sfb_file,bmd_file   #MOD-A40144 mark
                    SELECT SUM(bmd07) FROM sfb_file,bmd_file  #MOD-A40144 mod
                     WHERE sfb01=g_sfs[l_ac].sfs03
                       AND bmd01=g_sfs[l_ac].sfs27  #MOD-9C0234
                       AND (bmd08='ALL' OR bmd08=l_sfa29)
                       AND bmd04=g_sfs[l_ac].sfs04
                       AND bmdacti = 'Y'  #MOD-910166 add
                    IF STATUS THEN
                       CALL cl_err3("sel","sfb_file,bmd_file",g_sfs[l_ac].sfs03,b_sfs.sfs27,STATUS,"","sel bmd",1)  #No.FUN-660128
                       IF g_sma.sma887[1]='Y' THEN
                          NEXT FIELD sfs26
                       END IF
                    END IF
                    #FUN-9C0040--begin--add----------------- 
                    IF g_argv1='1' OR g_sfp.sfp06 = '9' THEN 
                       IF l_sfa11 IS NOT NULL THEN
                          IF g_sfp.sfp06='4' AND l_sfa11<>'E' THEN
                             CALL cl_err('','mfg-051',0)
                             NEXT FIELD sfs04
                          END IF
                          IF (g_argv1='1' OR g_sfp.sfp06 = '9') AND l_sfa11 = 'S' THEN
                             CALL cl_err('','asf-601',0)
                             NEXT FIELD sfs04
                          END IF
                          IF g_sfp.sfp06='1' AND l_sfa11 = 'E' THEN
                             CALL cl_err('','asf-602',0)
                             NEXT FIELD sfs04
                          END IF
                       END IF
                    END IF
                    #FUN-9C0040--end--add----------------------
                 END IF    
                 #MOD-C50150 add begin-----------------------------------
                 LET l_sfa11=''
                 SELECT sfa29,sfa11 INTO l_sfa29,l_sfa11 FROM sfa_file
                  WHERE sfa01=g_sfs[l_ac].sfs03
                    AND sfa03=g_sfs[l_ac].sfs04  
                    AND sfa27=g_sfs[l_ac].sfs27  
                    AND sfa12=g_sfs[l_ac].sfs06  
                    AND sfa08=g_sfs[l_ac].sfs10  
                    AND sfa012= g_sfs[l_ac].sfs012  
                    AND sfa013= g_sfs[l_ac].sfs013 
                 IF g_argv1='1' OR g_sfp.sfp06 = '9' THEN
                    IF g_sfp.sfp06='1' AND l_sfa11 = 'E' THEN
                       CALL cl_err('','asf-602',0)
                       NEXT FIELD sfs04
                    END IF
                 END IF
                 #MOD-C50150 add end-------------------------------------       
              END IF  #FUN-940039 add
 
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
                 CALL s_chk_va_setting(g_sfs[l_ac].sfs04)
                     RETURNING g_flag,g_ima906,g_ima907
                 SELECT ima55 INTO g_ima55
                   FROM ima_file WHERE ima01=g_sfs[l_ac].sfs04
                 IF g_flag=1 THEN
                    NEXT FIELD sfs04
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_sfs[l_ac].sfs33=g_ima907
                    DISPLAY BY NAME g_sfs[l_ac].sfs33
                 END IF
              END IF
              CALL i501_set_no_entry_b('u')
              CALL i501_set_required()
           END IF
          IF  (p_cmd='a') OR (g_sfs_t.sfs04 <> g_sfs[l_ac].sfs04) THEN
             SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
              WHERE sfa01=g_sfs[l_ac].sfs03
                AND sfa03=g_sfs[l_ac].sfs04
                AND sfa12=g_sfs[l_ac].sfs06
                AND sfa08=g_sfs[l_ac].sfs10
                AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028
                AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                
            #MOD-B30702--begin
            IF g_argv2 = '8' THEN
             SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
              WHERE sfa01=g_sfs[l_ac].sfs03
                AND sfa03=g_sfs[l_ac].sfs04
                AND sfa12=g_sfs[l_ac].sfs06
                AND sfa08=g_sfs[l_ac].sfs10
                AND sfa012= g_sfs[l_ac].sfs012   
                AND sfa013= g_sfs[l_ac].sfs013                  
                AND sfa11 = 'S'
            END IF 
            #MOD-B30702--end                 
          END IF
           #當替代碼為空的時候,發料料號應該=被替代料號
           IF cl_null(g_sfs[l_ac].sfs26) THEN
              IF NOT cl_null(g_sfs[l_ac].sfs04) AND 
                 NOT cl_null(g_sfs[l_ac].sfs27) THEN 
                 IF g_sfs[l_ac].sfs04 <> g_sfs[l_ac].sfs27 THEN 
                    CALL cl_err('','asf-475',1) 
                    NEXT FIELD sfs04
                 END IF
              END IF 
           END IF 
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_sfs[l_ac].sfs27) AND 
              NOT cl_null(g_sfs[l_ac].sfs03) AND 
              NOT cl_null(g_sfs[l_ac].sfs04) THEN  
             #g_sfs[l_ac].sfs012 IS NOT NULL AND    #FUN-A60028 add sfs012 #FUN-B20079 jan
             #NOT cl_null(g_sfs[l_ac].sfs013) THEN  #FUN-A60028 ADD sfs013 #FUN-B20079 jan
             
             #FUN-B80143 --START mark--
             # SELECT COUNT(*) INTO l_n FROM sfa_file
             #  WHERE sfa01 = g_sfs[l_ac].sfs03
             #   #AND sfa03 = g_sfs[l_ac].sfs04  #TQC-B50089
             #   #AND sfa27 = g_sfs[l_ac].sfs27  #TQC-B50089
             #    AND sfa03 = g_sfs[l_ac].sfs27  #TQC-B50089
             #   #AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028  #FUN-B20079 jan
             #   #AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028  #FUN-B20079 jan
             #FUN-B80143 --END mark--

              #FUN-B80143 --START--
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_sfs[l_ac].sfs03, "'",
                          "   AND sfa03 ='", g_sfs[l_ac].sfs27, "'"                                                   
              IF g_sfp.sfp06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i501_b_p2 FROM g_sql
              DECLARE i501_b_c2 CURSOR FOR i501_b_p2
              OPEN i501_b_c2
              FETCH i501_b_c2 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i501_b_c2
                 NEXT FIELD sfs04 
              END IF 
              CLOSE i501_b_c2
              #FUN-B80143 --END--
              
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD sfs04
              END IF 
           END IF 
           #FUN-B20079 jan (S)
           CALL i501_chk_sfs()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD sfs04
           END IF
           #FUN-B20079 jan (E)
           #FUN-B70061 --START--                     
           CALL i501_set_no_required_sfsiicd028()   
           CALL i501_set_required_sfsiicd028(p_cmd)
           CALL i501_set_no_required_sfsiicd029()   
           CALL i501_set_required_sfsiicd029(p_cmd) 
           #FUN-B70061 --END--
           #TQC-C60020---begin
           IF NOT cl_null(g_sfs[l_ac].sfs04) AND g_argv1 = '2' THEN 
              SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
               WHERE imaicd00 = g_sfs[l_ac].sfs04
              IF l_imaicd09 = 'Y' THEN
                 CALL cl_set_comp_entry('sfsiicd028',TRUE)
              ELSE
                 CALL cl_set_comp_entry('sfsiicd028',FALSE)
              END IF 
           END IF 
           #TQC-C60020---end
        #CHI-C50011 str add------
           CALL i501_chk_entry_sfs27()
           IF cl_null(g_sfs[l_ac].sfs26) THEN
             LET g_sfs[l_ac].sfs27 = g_sfs[l_ac].sfs04
             DISPLAY BY NAME g_sfs[l_ac].sfs27
           END IF 


         BEFORE FIELD sfs27          
           CALL i501_chk_entry_sfs27()
        #CHI-C50011 end add------
         AFTER FIELD sfs27
           #當"工單單號+發料料號"依序判斷其中有一個位空時候,則NEXT FIELD到空的欄位
           IF cl_null(g_sfs[l_ac].sfs03) THEN
              NEXT FIELD sfs03
           END IF
          #CHI-C40013 str add-----
           SELECT sfb04 INTO g_sfb.sfb04 FROM sfb_file
            WHERE sfb01=g_sfs[l_ac].sfs03 AND sfbacti='Y' AND sfb87!='X'
           IF STATUS THEN
              CALL cl_err3("sel","sfb_file",g_sfs[l_ac].sfs03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
              NEXT FIELD sfs03
           END IF
           IF g_sfb.sfb04 < 4 AND g_argv2 = 2 THEN
                CALL cl_err('','asf-383',0) NEXT FIELD sfs27
           END IF
          #CHI-C40013 end add-----
           IF cl_null(g_sfs[l_ac].sfs04) THEN
             #CHI-BC0040 str add-----
             #NEXT FIELD sfs04
             #當替代碼為空,發料料號如果也為空,則預設發料料號為被替代料號
             IF cl_null(g_sfs[l_ac].sfs26) THEN
                LET g_sfs[l_ac].sfs04 = g_sfs[l_ac].sfs27
                DISPLAY BY NAME g_sfs[l_ac].sfs04
             ELSE
                NEXT FIELD sfs04
             END IF
             #CHI-BC0040 end add-----
           END IF
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_sfs[l_ac].sfs27) THEN
             #g_sfs[l_ac].sfs012 IS NOT NULL AND           #FUN-A60028  #FUN-B20079 jan
             #NOT cl_null(g_sfs[l_ac].sfs013) THEN         #FUN-A60028  #FUN-B20079 jan

             #FUN-B80143 --START mark--
             # SELECT COUNT(*) INTO l_n FROM sfa_file
             #  WHERE sfa01 = g_sfs[l_ac].sfs03
             #   #AND sfa03 = g_sfs[l_ac].sfs04  #TQC-B50089
             #   #AND sfa27 = g_sfs[l_ac].sfs27  #TQC-B50089
             #    AND sfa03 = g_sfs[l_ac].sfs27  #TQC-B50089
             #   #AND sfa012= g_sfs[l_ac].sfs012    #FUN-A60028  #FUN-B20079 jan
             #   #AND sfa013= g_sfs[l_ac].sfs013    #FUN-A60028  #FUN-B20079 jan
             #FUN-B80143 --END mark--

             #FUN-B80143 --START--
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_sfs[l_ac].sfs03, "'",
                          "   AND sfa03 ='", g_sfs[l_ac].sfs27, "'"                                                   
              IF g_sfp.sfp06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i501_b_p3 FROM g_sql
              DECLARE i501_b_c3 CURSOR FOR i501_b_p3
              OPEN i501_b_c3
              FETCH i501_b_c3 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i501_b_c3
                 NEXT FIELD sfs27
              END IF 
              CLOSE i501_b_c3
              #FUN-B80143 --END--
             
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD sfs27
              END IF 
              #FUN-B20079 jan (S)
              CALL i501_chk_sfs()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD sfs27
              END IF
              #FUN-B20079 jan (E)
           END IF 
           #當替代碼為空的時候,發料料號應該=被替代料號
           IF cl_null(g_sfs[l_ac].sfs26) THEN
              IF g_sfs[l_ac].sfs04 <> g_sfs[l_ac].sfs27 THEN 
                 CALL cl_err('','asf-475',1) 
                 NEXT FIELD sfs27
              END IF
           END IF 
          SELECT sfa36 INTO l_sfa36 FROM sfa_file
           WHERE sfa01=g_sfs[l_ac].sfs03
             AND sfa03=g_sfs[l_ac].sfs04
             AND sfa12=g_sfs[l_ac].sfs06
             AND sfa08=g_sfs[l_ac].sfs10
             AND sfa27=g_sfs[l_ac].sfs27  #g_sfs[l_ac].sfs27
             AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
             AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028 
          SELECT mse02 INTO g_sfs[l_ac].mse02
            FROM mse_file WHERE mse01=g_sfs[l_ac].sfs36
          LET g_sfs[l_ac].sfs36 = l_sfa36
          DISPLAY BY NAME g_sfs[l_ac].sfs08
          DISPLAY g_sfs[l_ac].mse02 TO FORMONLY.mse02
          
         AFTER FIELD sfs06
           #若已有idb存在不可修改
          #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
              IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs06) THEN
                 IF g_sfs_t.sfs06 <> g_sfs[l_ac].sfs06 THEN
                    CALL i501_ind_icd_chk_icd()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_sfs[l_ac].sfs06 = g_sfs_t.sfs06
                       NEXT FIELD sfs06
                    END IF
                 END IF
              END IF
           END IF
            IF NOT cl_null(g_sfs[l_ac].sfs06) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_sfs[l_ac].sfs06
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",g_sfs[l_ac].sfs06,"",STATUS,"","gfe:",1)  #No.FUN-660128
                  NEXT FIELD sfs06
               END IF
               IF NOT g_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-5C0114
                  SELECT COUNT(*) INTO l_n FROM sfa_file
                   WHERE sfa01=g_sfs[l_ac].sfs03
                     AND (sfa03=g_sfs[l_ac].sfs04 OR sfa27=b_sfs.sfs27)
                     AND sfa12=g_sfs[l_ac].sfs06
                     AND sfa012=g_sfs[l_ac].sfs012       #FUN-A60028 
                     AND sfa013=g_sfs[l_ac].sfs013       #FUN-A60028
                  IF l_n=0 THEN
                     CALL cl_err('sel sfa',100,0) NEXT FIELD sfs06
                  END IF
               END IF
            END IF
        #FUN-BB0084 ----------------Begin------------------
            IF NOT cl_null(g_sfs[l_ac].sfs06) AND NOT cl_null(g_sfs[l_ac].sfs05) THEN
               IF cl_null(g_sfs06_t) OR cl_null(g_sfs_t.sfs05) OR g_sfs06_t!=g_sfs[l_ac].sfs06
                  OR g_sfs_t.sfs05!=g_sfs[l_ac].sfs05 THEN
                  LET g_sfs[l_ac].sfs05 = s_digqty(g_sfs[l_ac].sfs05,g_sfs[l_ac].sfs06)
               END IF
            END IF 
        #FUN-BB0084 ----------------End--------------------
 
        AFTER FIELD sfs10
           IF cl_null(g_sfs[l_ac].sfs10) THEN 
              LET g_sfs[l_ac].sfs10=' ' 
           ELSE 
              CALL i501_sfs10(g_sfs[l_ac].sfs10) RETURNING g_errno
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfs[l_ac].sfs10,g_errno,1)
                NEXT FIELD sfs10
              END IF 
           END IF
           IF (g_sfs[l_ac].sfs26 MATCHES '[SUZ]') AND   #FUN-A40058 add 'Z' 
               (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN
               IF cl_null(g_sfs[l_ac].sfs27) THEN #FUN-9B0149      
                  #LET l_sfa27 = g_sfs[l_ac].sfs03  #MOD-D30037
                  LET l_sfa27 = g_sfs[l_ac].sfs04  #MOD-D30037
               ELSE
                  LET l_sfa27 = g_sfs[l_ac].sfs27 #FUN-9B0149
               END IF
               LET l_cn = 0 
               SELECT COUNT(*) INTO l_cn FROM sfa_file
                WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa27 = l_sfa27
                  AND sfa08 = g_sfs[l_ac].sfs10
            ELSE
               LET l_cn = 0 
               SELECT COUNT(*) INTO l_cn FROM sfa_file
                WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa03 = g_sfs[l_ac].sfs04
                  AND sfa08 = g_sfs[l_ac].sfs10
            END IF     
           
            IF l_cn = 0 THEN
               CALL cl_err(g_sfs[l_ac].sfs10,'asf-905',0)
               NEXT FIELD sfs10
            END IF      
            
            IF NOT cl_null(g_sfs[l_ac].sfs10) THEN    #TQC-D40123 add
               IF  g_argv2='4' OR  g_argv2='9' THEN   #NO:6908
                   LET l_sfa11=''   #MOD-B80013 add
                   SELECT sfa11 INTO l_sfa11 FROM sfa_file
                    WHERE sfa01=g_sfs[l_ac].sfs03
                      #AND sfa03=g_sfs[l_ac].sfs04    #MOD-B80111 mark
                      AND sfa12=g_sfs[l_ac].sfs06
                      AND sfa08=g_sfs[l_ac].sfs10
                      #AND sfa27=g_sfs[l_ac].sfs27  #FUN-9B0149 #MOD-B80111 mark
                      AND sfa012=g_sfs[l_ac].sfs012    #FUN-A60028 
                      AND sfa013=g_sfs[l_ac].sfs013    #FUN-A60028 
                      AND sfa03=g_sfs[l_ac].sfs27      #MOD-B80111 add
                   IF cl_null(l_sfa11) THEN LET l_sfa11='' END IF #MOD-B80013 add
                   IF l_sfa11 MATCHES '[NX]' THEN #CHI-980013
                      CALL cl_err(g_sfs[l_ac].sfs10,'asf-932',0)
                      NEXT FIELD sfs10
                   END IF
               END IF
           END IF   #TQC-D40123 add
#作業編號
           IF NOT cl_null(g_sfs[l_ac].sfs10) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file
               WHERE ecd01=g_sfs[l_ac].sfs10
              IF g_cnt=0 THEN
                 CALL cl_err('sel ecd_file',100,0)
                 NEXT FIELD sfs10
              END IF
           END IF
 
           # 領料時只能針對事後扣帳的料
           IF g_sfp.sfp06='4' THEN
              SELECT sfa11 FROM sfa_file
               WHERE sfa01=g_sfs[l_ac].sfs03
                 #AND sfa03=g_sfs[l_ac].sfs04   #No.3351  #MOD-B80111 mark
                 AND sfa12=g_sfs[l_ac].sfs06
                 AND sfa08=g_sfs[l_ac].sfs10
                 #AND sfa27=g_sfs[l_ac].sfs27  #FUN-9B0149 #MOD-B80111 mark
                 AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                 AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028
                 AND sfa03=g_sfs[l_ac].sfs27      #MOD-B80111 add
              IF l_sfa11<>'E' THEN #FUN-9B0149
                  CALL cl_err('','mfg-051',0)   #No.FUN-660128  #FUN-9B0149 解除mark
                  NEXT FIELD sfs10
               END IF
           END IF
 
           IF (g_sfs[l_ac].sfs26 MATCHES '[SUZ]') AND (NOT g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114   #FUN-A40058 add 'Z'
              SELECT sfa26 INTO g_sfa26 FROM sfa_file
               WHERE sfa01=g_sfs[l_ac].sfs03
                 #AND sfa03=g_sfs[l_ac].sfs04   #MOD-B80111 mark
                 AND sfa12=g_sfs[l_ac].sfs06
                 AND sfa08=g_sfs[l_ac].sfs10
                 #AND sfa27=g_sfs[l_ac].sfs27    #MOD-B80111 mark
                 AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                 AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028             
                 AND sfa03=g_sfs[l_ac].sfs27      #MOD-B80111 add
              IF STATUS THEN
                 CALL cl_err3("sel","sfa_file",g_sfs[l_ac].sfs03,b_sfs.sfs27,STATUS,"","sel o.sfa",1)  #No.FUN-660128
                 NEXT FIELD sfs26
              END IF
 
             LET l_sfa29=NULL
             SELECT sfa29 INTO l_sfa29 FROM sfa_file  #TQC-9C0048
              WHERE sfa01=g_sfs[l_ac].sfs03  #TQC-9C0048
                #AND sfa03=g_sfs[l_ac].sfs04  #TQC-9C0048 #MOD-B80111 mark
                AND sfa12=g_sfs[l_ac].sfs06  #TQC-9C0048
                AND sfa08=g_sfs[l_ac].sfs10  #TQC-9C0048
                #AND sfa27=g_sfs[l_ac].sfs27  #TQC-9C0048 #MOD-B80111 mark
                AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028 
                AND sfa03=g_sfs[l_ac].sfs27      #MOD-B80111 add
 
              #SELECT bmd07 FROM sfb_file,bmd_file    #MOD-A40144 mark
              SELECT SUM(bmd07) FROM sfb_file,bmd_file    #MOD-A40144 mod
               WHERE sfb01=g_sfs[l_ac].sfs03
                 AND bmd01=g_sfs[l_ac].sfs27 #MOD-9C0234
                  AND (bmd08='ALL' OR bmd08=l_sfa29)  #MOD-530024
                 AND bmd04=g_sfs[l_ac].sfs04
                 AND bmdacti = 'Y'  #MOD-910166 add
              IF STATUS THEN
                 CALL cl_err3("sel","sfb_file,bmd_file",g_sfs[l_ac].sfs03,b_sfs.sfs27,STATUS,"","sel bmd",1)  #No.FUN-660128
                 IF g_sma.sma887[1]='Y' THEN
                    NEXT FIELD sfs26
                 END IF
              END IF
           END IF
           # 有可能二次取替代所以改以下判斷方式
           IF (g_sfp.sfp06 = '1') OR (g_sfp.sfp06 = '2') OR (g_sfp.sfp06 = '4' ) THEN #MOD-6C0050 #帶應發已發欠料的資料,超領和成套發一樣 #MOD-8C0239 modify 
              IF cl_null(g_sfs[l_ac].sfs26) THEN
                  LET l_sfa11=''   #MOD-B80013 add
                  SELECT (sfa05-sfa065),sfa06,sfa11  # 扣除代買部分        #FUN-940039 add   #FUN-B50059 #MOD-B80013 add sfa11
                    INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06,l_sfa11         #FUN-940039 add #MOD-B80013 add l_sfa11
                    FROM sfa_file
                   WHERE sfa01=g_sfs[l_ac].sfs03
                     #AND sfa03=g_sfs[l_ac].sfs04   #MOD-B80111 mark
                     AND sfa12=g_sfs[l_ac].sfs06
                     AND sfa08=g_sfs[l_ac].sfs10
                     #AND sfa27=g_sfs[l_ac].sfs27    #FUN-940039 add #MOD-B80111 mark
                     AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                     
                     AND sfa03=g_sfs[l_ac].sfs27     #MOD-B80111 add
                     AND sfa27 = g_sfs[l_ac].sfs04    #TQC-CA0014 add
                  IF SQLCA.SQLCODE THEN
                     LET s_sfa05 = 0 LET s_sfa06 = 0
                  END IF
                 #計算欠料量g_short_qty(原g_sfa07) 
                  IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
                  IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
                  CALL s_shortqty(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs10,
                                  g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                                 #g_sfs012,g_sfs013)   #FUN-A50066 add     #MOD-CB0154 mark
                                  g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)   #MOD-CB0154
                       RETURNING g_short_qty
                  IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              ELSE
                  LET l_sfa11=''   #MOD-B80013 add
                  SELECT SUM(sfa05-sfa065),SUM(sfa06),sfa11  # 扣除代買部分                #FUN-940039 add #FUN-B50059 #MOD-B80013 add sfa11
                    INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06,l_sfa11                         #FUN-940039 add #MOD-B80013 add l_sfa11
                    FROM sfa_file
                   WHERE sfa01=g_sfs[l_ac].sfs03
                     #AND sfa03=g_sfs[l_ac].sfs04  #MOD-630129  #MOD-B80111 mark 
                     AND sfa12=g_sfs[l_ac].sfs06
                     AND sfa08=g_sfs[l_ac].sfs10
                     #AND sfa27=g_sfs[l_ac].sfs27 #FUN-940039 add #MOD-B80111 mark
                     AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                     
                     AND sfa03=g_sfs[l_ac].sfs27     #MOD-B80111 add
                     AND sfa27 = g_sfs[l_ac].sfs04    #TQC-CA0014 add
                     GROUP BY sfa11                  #MOD-C70247 add
                  IF SQLCA.SQLCODE THEN
                     LET s_sfa05 = 0 LET s_sfa06 = 0 
                  END IF
                 #計算欠料量g_short_qty(原g_sfa07)
                  IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
                  IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
                  CALL s_shortqty(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs10,
                                  g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                                 #g_sfs012,g_sfs013)   #FUN-A50066 add   #MOD-CB0154 mark
                                  g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)   #MOD-CB0154
                       RETURNING g_short_qty
                  IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              END IF
              DISPLAY BY NAME g_sfs[l_ac].sfa05
              DISPLAY BY NAME g_sfs[l_ac].sfa06
           END IF
           IF g_sfp.sfp06 = '3' THEN
              LET l_n = 0
              LET l_sfa11=''   #MOD-B80013 add
              SELECT (sfa05-sfa065),sfa06,sfa11        # 扣除代買部分  #FUN-B50059 #MOD-B80013 add sfa11
                INTO s_sfa05,s_sfa06,l_sfa11           #MOD-B80013 add l_sfa11
                FROM sfa_file
               WHERE sfa01=g_sfs[l_ac].sfs03
                 #AND sfa03=g_sfs[l_ac].sfs04    #MOD-B80111 mark
                #AND sfa27=g_sfs[l_ac].sfs04     #MOD-B10201 add  #MOD-C10021 mark
                 AND sfa27=g_sfs[l_ac].sfs27     #MOD-C10021 add 
                 AND sfa12=g_sfs[l_ac].sfs06
                 AND sfa08=g_sfs[l_ac].sfs10
                 #AND sfa27=g_sfs[l_ac].sfs27     #FUN-940039 add #MOD-B80111 mark
                 AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                 AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                 
                #AND sfa03=g_sfs[l_ac].sfs27     #MOD-B80111 add  #MOD-C10021 mark
                 AND sfa03=g_sfs[l_ac].sfs04     #MOD-C10021 add
              IF SQLCA.SQLCODE THEN
                 LET s_sfa05 = 0 LET s_sfa06 = 0                  #FUN-940039 add
              ELSE
                 LET l_n = l_n + 1
              END IF
             #計算欠料量g_short_qty(原g_sfa07)
              IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
              IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
              CALL s_shortqty(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs10,
                              g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                             #g_sfs012,g_sfs013)   #FUN-A50066 add    #MOD-CB0154 mark
                              g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)  #MOD-CB0154
                   RETURNING g_short_qty
              IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              IF cl_null(s_sfa05) THEN LET s_sfa05 = 0 END IF
              IF cl_null(s_sfa06) THEN LET s_sfa06 = 0 END IF
              IF g_sfs[l_ac].sfs26 MATCHES '[SUZ]' THEN                  #FUN-A40058 add 'Z'
                 LET l_sfa11=''   #MOD-B80013 add
                 SELECT SUM(sfa05-sfa065),SUM(sfa06),sfa11  # 扣除代買部分 #FUN-940039 add  #FUN-B50059 #MOD-B80013 l_sfa11 add
                   INTO t_sfa05,t_sfa06,l_sfa11           #FUN-940039 add #MOD-B80013 l_sfa11 add
                   FROM sfa_file
                  WHERE sfa01=g_sfs[l_ac].sfs03
                    AND sfa03=b_sfs.sfs27
                    AND sfa12=g_sfs[l_ac].sfs06
                    AND sfa08=g_sfs[l_ac].sfs10
                    AND sfa27=g_sfs[l_ac].sfs27   #FUN-940039 add
                    AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                    AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                    
                    GROUP BY sfa11                  #MOD-C70247 add
                 IF SQLCA.sqlcode THEN
                    LET t_sfa05=0 LET t_sfa06=0                 #FUN-940039 add
                 ELSE
                    LET l_n = l_n + 1
                 END IF
                 #計算欠料量t_short_qty(原t_sfa07)
                  IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
                  IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
                  CALL s_shortqty(g_sfs[l_ac].sfs03,b_sfs.sfs27,g_sfs[l_ac].sfs10,
                                  g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                                 #g_sfs012,g_sfs013)   #FUN-A50066 add    #MOD-CB0154 mark
                                  g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)  #MOD-CB0154
                       RETURNING t_short_qty
#                 IF cl_null(t_short_qty) THEN LET t_short_qty = 0 END IF  #TQC-A50101 
              END IF
              IF cl_null(t_sfa05) THEN LET t_sfa05 = 0 END IF
              IF cl_null(t_sfa06) THEN LET t_sfa06 = 0 END IF
              LET g_sfs[l_ac].sfa05 = s_sfa05 + t_sfa05
              LET g_sfs[l_ac].sfa06 = s_sfa06 + t_sfa06
              IF cl_null(t_short_qty) THEN LET t_short_qty = 0 END IF    #TQC-A50101 
              LET g_short_qty = g_short_qty + t_short_qty    #FUN-940039 add
              IF l_n = 0 THEN
                 CALL cl_err('sel sfa',SQLCA.SQLCODE,0)
                 NEXT FIELD sfs10
              END IF
           END IF
 #超領單不控制  --so '2' 要拿掉
           IF g_sfp.sfp06 MATCHES '[134]' AND     #NO:7075,補2,4
              #g_sfs[l_ac].sfa05<=g_sfs[l_ac].sfa06 THEN        #MOD-B80013 mark
              g_sfs[l_ac].sfa05<=g_sfs[l_ac].sfa06 AND          #MOD-B80013 add
              g_sfp.sfp06 != '4' AND l_sfa11 = 'E' THEN         #MOD-B80013 add
              CALL cl_err('sfa05<=sfa06','asf-462',0) NEXT FIELD sfs10
           END IF
           IF g_sfp.sfp06 MATCHES '[6789]' THEN    #NO:7075
              SELECT sfa05,sfa06   #FUN-B50059
                INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06  #FUN-940039 add
                FROM sfa_file
               WHERE sfa01=g_sfs[l_ac].sfs03
                 AND sfa03=g_sfs[l_ac].sfs04    #MOD-B80111 mark  #MOD-D60027
                 AND sfa12=g_sfs[l_ac].sfs06
                 AND sfa08=g_sfs[l_ac].sfs10
                 AND sfa27=g_sfs[l_ac].sfs27    #FUN-940039 add #MOD-B80111 mark  #MOD-D60027
                 AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                 AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                 
              IF g_sfs[l_ac].sfa05<0 AND p_cmd='a' THEN
                 LET g_sfs[l_ac].sfs05=g_sfs[l_ac].sfa05*(-1)
              END IF
              IF g_sfs[l_ac].sfa05<0  THEN
                 LET g_sfs[l_ac].sfa05=g_sfs[l_ac].sfa05*(-1)
              END IF
              IF SQLCA.SQLCODE THEN
                 LET s_sfa05 = 0 LET s_sfa06 = 0                    #FUN-940039 add   {FUN-AC0074}
              END IF
             #計算欠料量g_short_qty(原g_sfa07)
              IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
              IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
              CALL s_shortqty(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs10,
                              g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                             #g_sfs012,g_sfs013)   #FUN-A50066 add    #MOD-CB0154 mark
                              g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)  #MOD-CB0154
                   RETURNING g_short_qty
              IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              CALL i501_ins_rvbs(g_sfs[l_ac].sfs02,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04)   #No.FUN-870106
           END IF
 
           IF g_sfp.sfp06='3' THEN
              LET g_sfs[l_ac].sfa05=g_short_qty  #FUN-940039 add
              LET g_sfs[l_ac].sfa06=0
           END IF
          LET g_sfs[l_ac].short_qty = g_short_qty #FUN-940039 add
           DISPLAY BY NAME g_sfs[l_ac].sfa05
           DISPLAY BY NAME g_sfs[l_ac].sfa06
           DISPLAY BY NAME g_sfs[l_ac].short_qty       #FUN-940039 add
 
 
        AFTER FIELD sfs07
           #若已有idb存在不可修改
          #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
              IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs07) THEN
                 IF g_sfs_t.sfs07 <> g_sfs[l_ac].sfs07 THEN
                    CALL i501_ind_icd_chk_icd()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_sfs[l_ac].sfs07 = g_sfs_t.sfs07
                       NEXT FIELD sfs07
                    END IF
                 END IF
              END IF
           END IF
           #FUN-AA0007--begin--add-------
           IF NOT s_icdout_holdlot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                   g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09) THEN
              NEXT FIELD sfs07
           END IF
           #FUN-AA0007--end--add---------
           IF NOT cl_null(g_sfs[l_ac].sfs07) THEN
              #FUN-D20060--add--str---
               IF NOT s_chksmz(g_sfs[l_ac].sfs04, g_sfp.sfp01,
                               g_sfs[l_ac].sfs07, g_sfs[l_ac].sfs08) THEN
                  NEXT FIELD sfs07 
               END IF
               #FUN-D20060--add--end---
 
             #SELECT imd02 INTO g_buf FROM imd_file #MOD-950232    
              SELECT imd02,imd10 INTO g_buf,l_imd10 FROM imd_file #MOD-950232    #MOD-D60040 add imd10
               WHERE imd01=g_sfs[l_ac].sfs07
                  AND imdacti = 'Y' #MOD-4B0169
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",g_sfs[l_ac].sfs07,"",STATUS,"","sel imd",1)  #No.FUN-660128
                 NEXT FIELD sfs07
              END IF
              IF l_imd10 = 'I' THEN CALL cl_err('','axm-693',1) NEXT FIELD sfs07 END IF     #MOD-D60040 add
              SELECT ima108 INTO l_ima108 FROM ima_file
               WHERE ima01=g_sfs[l_ac].sfs04
              IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
                 SELECT COUNT(*) INTO l_n FROM imd_file
                  WHERE imd01=g_sfs[l_ac].sfs07 AND imd10='W'
                     AND imdacti = 'Y' #MOD-4B0169
                  LET g_msg = g_sfs[l_ac].sfs04," ",g_sfs[l_ac].sfs07  #MOD-890107 add
                 IF l_n = 0 THEN
                   #CALL cl_err(g_sfs[l_ac].sfs07,'asf-724',0) NEXT FIELD sfs07   #MOD-890107 mark
                    CALL cl_err(g_msg,'asf-724',0) NEXT FIELD sfs07               #MOD-890107      
                 END IF
              END IF
              #Add No.FUN-AB0018
              IF g_azw.azw04 = '2' THEN       #TQC-AC0151 add
                 IF NOT s_chk_ware(g_sfs[l_ac].sfs07) THEN  #检查仓库是否属于当前门店
                    NEXT FIELD sfs07
                 END IF
              END IF                      #TQC-AC0151 add
              #End Add No.FUN-AB0018
         #TQC-D50124 -------Begin-------
          ##FUN-D40103 ------Begin------
          #   IF NOT s_imechk(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN
          #      NEXT FIELD sfs08
          #   END IF
          ##FUN-D40103 ------End--------
         #TQC-D50124 -------End---------
           END IF
        AFTER FIELD sfs08
           #BugNo:5626 控管是否為全型空白
           IF g_sfs[l_ac].sfs08 = '　' THEN #全型空白
               LET g_sfs[l_ac].sfs08 = ' '
           END IF
           IF g_sfs[l_ac].sfs08 IS NULL THEN LET g_sfs[l_ac].sfs08 =' ' END IF
           #若已有idb存在不可修改
          #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
              IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs08) THEN
                 IF g_sfs_t.sfs08 <> g_sfs[l_ac].sfs08 THEN
                    CALL i501_ind_icd_chk_icd()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_sfs[l_ac].sfs08 = g_sfs_t.sfs08
                       NEXT FIELD sfs08
                    END IF
                 END IF
              END IF
           END IF
           #FUN-AA0007--begin--add-------
           IF NOT s_icdout_holdlot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                   g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09) THEN
              NEXT FIELD sfs08
           END IF
           #FUN-AA0007--end--add---------
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_sfs[l_ac].sfs07) THEN              #FUN-D20060
              IF NOT s_chksmz(g_sfs[l_ac].sfs04, g_sfp.sfp01,
                              g_sfs[l_ac].sfs07, g_sfs[l_ac].sfs08) THEN
                 NEXT FIELD sfs07
              END IF
           END IF                                              #FUN-D20060
           #------------------------------------------------------ 970715 roger
#FUN-BA0050 ----------------Begin----------------
           IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_sfs[l_ac].sfs04              
              IF l_ima159 = '2' THEN
                 CASE i501_b_sfs09_inschk(p_cmd)
                    WHEN "sfs07" NEXT FIELD sfs07
                    WHEN "sfs09" NEXT FIELD sfs07
                 END CASE
              END IF
           END IF  
#FUN-BA0050 ----------------End------------------

      #TQC-D50124 -------Begin-------
        ##FUN-D40103 ------Begin------
        #  IF NOT s_imechk(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN
        #     NEXT FIELD sfs08 
        #  END IF
      #FUN-D40103 ------End----------

      #TQC-D50124 -------End----------
 
        AFTER FIELD sfs09

   #FUN-BA0050 -----------Begin------------
           CASE i501_b_sfs09_inschk(p_cmd) 
              WHEN "sfs07" NEXT FIELD sfs07
              WHEN "sfs09" NEXT FIELD sfs09
           END CASE   
   #FUN-BA0050 -----------End--------------
     #TQC-D50124 -------Begin-----
        ##FUN-D40103 ------Begin------
        #  IF NOT s_imechk(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN
        #     NEXT FIELD sfs08
        #  END IF
        ##FUN-D40103 ------End--------
     #TQC-D50124 -------End-------
#FUN-BA0050 ------------------Begin--------------
#            #BugNo:5626 控管是否為全型空白
#            IF g_sfs[l_ac].sfs09 = '　' THEN #全型空白
#                LET g_sfs[l_ac].sfs09 = ' '
#            END IF
#            IF g_sfs[l_ac].sfs09 IS NULL THEN LET g_sfs[l_ac].sfs09 =' ' END IF
#&ifdef ICD 
#            #FUN-A40022--begin--add------
#            IF cl_null(g_sfs[l_ac].sfs09) AND NOT cl_null(g_sfs[l_ac].sfs04)
#            THEN
#               LET l_imaicd13 = ''
#               SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
#                WHERE imaicd00= g_sfs[l_ac].sfs04 
#               IF l_imaicd13 = 'Y' THEN
#                  CALL cl_err(g_sfs[l_ac].sfs04,'aim-034',1)
#                  NEXT FIELD CURRENT
#               END IF
#            END IF
#&ifdef ICD  
#            IF g_argv1='2' AND NOT cl_null(g_sfs[l_ac].sfs04) THEN
#               LET l_cnt = 0
#               SELECT COUNT(*) INTO l_cnt
#                 FROM sfe_file,sfp_file
#                WHERE sfe02 = sfp01
# 	         AND sfp06 IN ('1','2','3','4','A')
# 	         AND sfp04 = 'Y'
#                  AND sfe01 = g_sfs[l_ac].sfs03
#                  AND sfe07 = g_sfs[l_ac].sfs04
#               IF l_cnt >0 AND g_sfs[l_ac].sfs09 <> 'X' THEN
#                  LET l_cnt = 0
#                  SELECT COUNT(*) INTO l_cnt
#                    FROM sfe_file,sfp_file
#                   WHERE sfe02 = sfp01
# 	            AND sfp06 IN ('1','2','3','4','A')
# 	            AND sfp04 = 'Y'
#                     AND sfe01 = g_sfs[l_ac].sfs03
#                     AND sfe07 = g_sfs[l_ac].sfs04
# 	            AND sfe10 = g_sfs[l_ac].sfs09
#                  IF cl_null(l_cnt) OR l_cnt = 0 THEN
#                     CALL cl_err(g_sfs[l_ac].sfs04,'aim-036',1)
#                     NEXT FIELD CURRENT
#                  END IF
#               END IF
#            END IF
#            #FUN-A40022--end--add------------------
#    #FUN-810038................begin
#            #若已有idb存在不可修改
#           #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
#            IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
#               IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs09) THEN
#                  IF g_sfs_t.sfs09 <> g_sfs[l_ac].sfs09 THEN
#                     CALL i501_ind_icd_chk_icd()
#                     IF NOT cl_null(g_errno) THEN
#                        CALL cl_err('',g_errno,0)
#                        LET g_sfs[l_ac].sfs09 = g_sfs_t.sfs09
#                        NEXT FIELD sfs09
#                     END IF
#                  END IF
#               END IF
#            END IF
#            #FUN-AA0007--begin--add-------
#            IF NOT s_icdout_holdlot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
#                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09) THEN
#               NEXT FIELD sfs09
#            END IF
#            #FUN-AA0007--end--add---------
#&endif
#            SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
#              FROM img_file
#             WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
#               AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
#           #str MOD-A50139 mod
#           #IF g_argv1=1 AND STATUS THEN
#           #   CALL cl_err('sel img:',STATUS,0) 
#           #   NEXT FIELD sfs07 #TQC-620156 sfs09->sfs07
#           #END IF
#            IF g_argv1=1 AND STATUS THEN
#               #再檢查該倉庫是否為VMI結算倉儲,若不是顯示錯誤訊息
#               SELECT COUNT(*) INTO l_n FROM pmc_file
#                WHERE pmc917=g_sfs[l_ac].sfs07   #VMI結算倉庫
#                  AND pmc918=g_sfs[l_ac].sfs08   #VMI結算儲位
#               IF l_n = 0 THEN
#                 #CALL cl_err('sel img:',STATUS,0) #TQC-AB0098
#                  CALL cl_err('','asf-390',0)      #TQC-AB0098  
#                  NEXT FIELD sfs07
#               END IF
#            END IF
#           #end MOD-A50139 mod
#            IF g_argv1=2 AND STATUS=100 THEN
#               IF g_sma.sma892[3,3] = 'Y' THEN
#                  IF NOT cl_confirm('mfg1401') THEN NEXT FIELD sfs09 END IF
#               END IF
#               CALL s_add_img(g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
#                              g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
#                              g_sfp.sfp01,       g_sfs[l_ac].sfs02,
#                              g_sfp.sfp02)
#               IF g_errno='N' THEN NEXT FIELD sfs09 END IF
#               SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
#                    FROM img_file
#                   WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
#                     AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
#            END IF
#            IF g_sma.sma115 = 'N' THEN
#               IF g_sfs[l_ac].sfs06<>g_img09 THEN
#                  CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09)
#                       RETURNING l_flag,l_factor
#                  IF l_flag THEN
#                     CALL cl_err('sfs06<>img09:','asf-400',0) NEXT FIELD sfs09
#                  END IF
#               ELSE
#                  LET l_factor = 1
#               END IF
#            END IF
#  
#            SELECT SUM(sfs05) INTO g_sfs[l_ac].img10_alo FROM sfs_file,sfp_file #No:8247
#             WHERE sfs04=g_sfs[l_ac].sfs04
#               AND sfs07=g_sfs[l_ac].sfs07
#               AND sfs08=g_sfs[l_ac].sfs08
#               AND sfs09=g_sfs[l_ac].sfs09
#               AND sfp01=sfs01 AND sfpconf!='X'  #No:8247 #FUN-660106
#               AND sfs01 != g_sfp.sfp01     #MOD-A80031 add
#               DISPLAY BY NAME g_sfs[l_ac].img10_alo
#               DISPLAY BY NAME g_sfs[l_ac].img10
#               SELECT COUNT(*) INTO g_cnt FROM img_file
#                WHERE img01 = g_sfs[l_ac].sfs04   #料號
#                  AND img02 = g_sfs[l_ac].sfs07   #倉庫
#                  AND img03 = g_sfs[l_ac].sfs08   #儲位
#                  AND img04 = g_sfs[l_ac].sfs09   #批號
#                  AND img18 < g_sfp.sfp03         #過帳日   #MOD-870247 
#               IF g_cnt > 0 THEN    #大於有效日期
#                  call cl_err('','aim-400',0)   #須修改
#                  NEXT FIELD sfs07
#               END IF
#            IF g_sma.sma115 = 'Y' THEN     #MOD-870187 
#               CALL i501_du_default(p_cmd)
#            END IF
# &ifdef ICD
#            CALL i501_def_sfsiicd029() #FUN-B70061
# &endif
#FUN-BA0050 ------------------End-------------------

        AFTER FIELD sfs05                                                                                                                                            
#FUN-BB0084 ---------------Begin--------------------
           IF NOT cl_null(g_sfs[l_ac].sfs05) AND NOT cl_null(g_sfs[l_ac].sfs06) THEN
              IF cl_null(g_sfs06_t) OR cl_null(g_sfs_t.sfs05) OR g_sfs06_t! = g_sfs[l_ac].sfs06
                 OR g_sfs_t.sfs05! = g_sfs[l_ac].sfs05  THEN
                 LET g_sfs[l_ac].sfs05 = s_digqty(g_sfs[l_ac].sfs05,g_sfs[l_ac].sfs06)
                 DISPLAY BY NAME g_sfs[l_ac].sfs05
              END IF
           END IF 
#FUN-BB0084 ---------------End----------------------
           IF NOT cl_null(g_sfp.sfp06) THEN                                                                                                                                            
             IF NOT cl_null(g_sfs[l_ac].sfs05) THEN
                IF cl_null(g_sfs[l_ac].sfs04) OR cl_null(g_sfs[l_ac].sfs27) THEN
                   CALL cl_err('','asf-878',1)
                   NEXT FIELD CURRENT
                END IF
             END IF
             IF g_sfs[l_ac].sfs05 >0 THEN                                                                                         
                IF (g_sfs[l_ac].sfa05 = 0 OR cl_null(g_sfs[l_ac].sfa05)) AND (g_sfs[l_ac].sfs26 NOT MATCHES '[SUZ]') THEN  #No.MOD-8B0086 mark   #FUN-A40058 add 'Z' 
                   CALL cl_err('','asf-081',0)                                                                                        
                   NEXT FIELD sfs10                                                                                                   
                END IF                                                                                                                
               #MOD-B20062---add---start---
                SELECT sfa27 INTO b_sfa27 FROM sfa_file
                 WHERE sfa01 = g_sfs[l_ac].sfs03
                   AND sfa03 = g_sfs[l_ac].sfs04
               #MOD-B20062---add---end---
               
   
               
#MOD-D60189 mark by yuhuabao 13/06/27 -------允许发料量为0
#TQC-A40085 --begin--
#            ELSE
#               IF g_sfs[l_ac].sfs05 = 0 THEN
#                  CALL cl_err('','asf-153',0)
#                  NEXT FIELD sfs05
#               END IF 
#TQC-A40085 --end--
#MOD-D60189 mark by yuhuabao 13/06/27 -------允许发料量为0
             END IF        
             
            #MOD-D60168-Start-Add
             SELECT gfe03 INTO l_gfe03
               FROM gfe_file LEFT OUTER JOIN ima_file ON ima55 = gfe01
              WHERE ima01 = g_sfs[l_ac].sfs27
              
             IF cl_null(l_gfe03) THEN
                LET l_gfe03 = 0
             END IF 
             IF g_sfp.sfp06 MATCHES '[3]' THEN
                LET g_sfs[l_ac].sfs05 = cl_digcut(g_sfs[l_ac].sfs05,l_gfe03)
             END IF    

             DISPLAY BY NAME g_sfs[l_ac].sfs05 
            #MOD-D60168-End-Add  
#TQC-A40085
##TQC-A30120 --begin--
#              IF g_sfs[l_ac].sfa05 = 0 OR cl_null(g_sfs[l_ac].sfa05) THEN  
#                   CALL cl_err('','asf-081',0)                                                                                        
#                   NEXT FIELD sfs05                                                                                                   
#               END IF                                                                                                                
##TQC-A30120 --end--
#TQC-A40085 
            #IF g_sfp.sfp06 MATCHES '[13]' THEN        #TQC-CA0035 mark                                                                                                                          
             IF g_sfp.sfp06 MATCHES '[13D]' THEN       #TQC-CA0035 add D                                                                                                                          
                IF g_sfs[l_ac].sfs05 <0 THEN                                                                                                                                                          
                   CALL cl_err(g_sfs[l_ac].sfs05,"asf-037",1)                                                                                                               
                   NEXT FIELD sfs05                                                                                                                            
                END IF                                                                                                                                                        
                # 同一張備料單也考慮單身有數筆同一張工單的備料量計算                                                    
                LET l_sfs05x = 0                                                                                                                                                                                
                SELECT SUM(sfs05) INTO l_sfs05x FROM sfs_file,sfp_file                                                                                                                  
                 WHERE sfs03=g_sfs[l_ac].sfs03                                                                                                                                          
                   AND sfs04=g_sfs[l_ac].sfs04                                                                                                                                                
                   AND sfs27=g_sfs[l_ac].sfs27   #FUN-9B0149
                   AND sfs06=g_sfs[l_ac].sfs06                                                                                                                                         
                   AND sfs10=g_sfs[l_ac].sfs10                                                                                                                                               
                   AND sfs012=g_sfs[l_ac].sfs012  #FUN-B20079 jan
                   AND sfs013=g_sfs[l_ac].sfs013  #FUN-B20079 jan   
                   AND sfs01 = g_sfp.sfp01                                                                                                                                                  
                   AND sfs02 != g_sfs[l_ac].sfs02                                                                                                                                              
                   AND sfp01=sfs01 AND sfpconf !='X'  #FUN-660106
                                                                                                                                                                                
                IF STATUS OR cl_null(l_sfs05x) THEN                                                                                                                          
                   LET l_sfs05x = 0                                                                                                                             
                END IF                                                                                                                                                          
                
        #TQC-CA0035 add begin------------------------------------------
                IF g_sfp.sfp06 = 'D' THEN 
                   SELECT SUM(sfs05) INTO l_sfs05x FROM sfs_file,sfp_file
                    WHERE sfs03=g_sfs[l_ac].sfs03
                      AND sfs04=g_sfs[l_ac].sfs04
                      AND sfs27=g_sfs[l_ac].sfs27   
                      AND sfs06=g_sfs[l_ac].sfs06
                      AND sfs10=g_sfs[l_ac].sfs10
                      AND sfs012=g_sfs[l_ac].sfs012 
                      AND sfs013=g_sfs[l_ac].sfs013
                      AND sfs01 = g_sfp.sfp01
                      AND sfs02 != g_sfs[l_ac].sfs02
                      AND sfs014 = g_sfs[l_ac].sfs014
                      AND sfp01=sfs01 AND sfpconf !='X'
                   IF STATUS OR cl_null(l_sfs05x) THEN
                      LET l_sfs05x = 0
                   END IF
                END IF 
        #TQC-CA0035 add end--------------------------------------------
                
                IF g_sfs[l_ac].sfs05>(g_sfs[l_ac].sfa05-g_sfs[l_ac].sfa06-l_sfs05x) THEN                                                                                                                   
                   LET l_msg=g_sfs[l_ac].sfs04 CLIPPED,' sfs05<>sfa05:'                                                                                                                                               
                   CALL cl_err(l_msg CLIPPED ,'asf-351',0) NEXT FIELD sfs05                                                                                      
                END IF                                                                                                                                                
 
                #2013090084 add begin----------------------------------
                IF g_sfp.sfp06 = '1' THEN
                   LET l_sfa161 = 0
                   SELECT sfa161 INTO l_sfa161 FROM sfa_file
                    WHERE sfa01 = g_sfs[l_ac].sfs03
                      AND sfa03 = g_sfs[l_ac].sfs04
                      AND sfa08 = g_sfs[l_ac].sfs10
                      AND sfa12 = g_sfs[l_ac].sfs06
                      AND sfa27 = g_sfs[l_ac].sfs27
                      AND sfa012= g_sfs[l_ac].sfs012
                      AND sfa013= g_sfs[l_ac].sfs013

                   SELECT SUM(sfq03) INTO l_sfq03 FROM sfq_file
                    WHERE sfq01 = g_sfp.sfp01
                      AND sfq02 = g_sfs[l_ac].sfs03
                      AND sfq04 = g_sfs[l_ac].sfs10

                   IF (g_sfs[l_ac].sfs05/l_sfa161) > l_sfq03 THEN
                      CALL cl_err(g_sfs[l_ac].sfs05,'asf-958',0)
                      NEXT FIELD sfs05
                   END IF
                END IF
                #2013090084 add end------------------------------------
             END IF
             
             #TQC-B60036--add--str--
             IF g_sfp.sfp06 = '1' THEN 
                SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
                 WHERE ima01 = g_sfs[l_ac].sfs04 
                IF STATUS THEN 
                   LET l_ima64 = 0 
                   LET l_ima641 = 0 
                END IF
                #check最少發料數量
                IF l_ima641 <>  0 AND g_sfs[l_ac].sfs05 < l_ima641 THEN
                   CALL cl_err(g_sfs[l_ac].sfs05,'asf-100',0) 
                   NEXT FIELD sfs05 
                END IF
                LET l_num_z = g_sfs[l_ac].sfs05/l_ima64
                LET l_num_y = g_sfs[l_ac].sfs05-l_num_z*l_ima64
  
                IF l_ima64 <> 0 AND (l_num_y) <> 0 THEN
                   CALL cl_err(g_sfs[l_ac].sfs05,'asf-101',0) 
                   NEXT FIELD sfs05  
                 END IF
             END IF
             #TQC-B60036--add--end--

             IF g_sfp.sfp06 = '2' THEN                                                                                                                                          
               IF NOT cl_null(g_sfs[l_ac].sfs05) THEN                                                                                                                                          
                  IF g_sfs[l_ac].sfs05 <0 THEN                                                                                                                                         
                     CALL cl_err(g_sfs[l_ac].sfs05,"asf-037",1)                                                                                                                                         
                     NEXT FIELD sfs05                                                                                                                                         
                  END IF                                                                                                                                         
                  LET l_sfa161 = 0 
                  SELECT sfa161,sfa26 INTO  l_sfa161,l_sfa26                                                                                                                      
                    FROM sfa_file
                   WHERE sfa01 = g_sfs[l_ac].sfs03
                     AND sfa03 = g_sfs[l_ac].sfs04
                     AND sfa08 = g_sfs[l_ac].sfs10
                     AND sfa12 = g_sfs[l_ac].sfs06
                     AND sfa27 = g_sfs[l_ac].sfs27  #FUN-9B0149
                     AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                     
                  IF l_sfa161 = 0 AND l_sfa26 NOT MATCHES '[USTZ]' THEN   #FUN-A20037 add 'Z'
                     CALL cl_err('','asf-780',1)                                                                                                                                         
                     LET g_sfs[l_ac].sfs05 = 0                                                                                                                                         
                     NEXT FIELD sfs05                                                                                                                                         
                  END IF
               END IF                                                                                                                                          
             END IF                                                                                                                                          
             IF g_sfp.sfp06 MATCHES '[1234]' THEN
                #BUGNO:3264 sfs05發料量 * l_factor > img10庫存量 01/08/10mandy
               #IF (g_sfs[l_ac].sfs05 * l_factor) > g_sfs[l_ac].img10 THEN     #MOD-C50190 mark
                IF (g_sfs[l_ac].sfs05 * l_factor) > g_sfs[l_ac].img10 AND NOT i501_isVMI(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN #MOD-C50190 add i501_isVMI 
                  #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
                  #FUN-D30024--modify--str--
                  #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894      #FUN-C80107
                  #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                  INITIALIZE g_imd23 TO NULL
                  CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                  IF g_imd23 = 'N' THEN
                  #FUN-D30024--modify--end--
                      CALL cl_err(g_sfs[l_ac].sfs05,'mfg1303',0)
                      NEXT FIELD sfs05
                   END IF
                END IF
             END IF
             IF g_sfp.sfp06 MATCHES '[6789]' THEN   #NO:7075                                                                                                
                IF g_sfs[l_ac].sfs05 < 0  THEN
                   CALL cl_err('','asf-952',1)
                   NEXT FIELD sfs05
                END IF
                LET l_sfa11 = ''                        #FUN-9C0040
                SELECT sfa11 INTO l_sfa11 FROM sfa_file #FUN-9C0040
                 WHERE sfa01=g_sfs[l_ac].sfs03          #FUN-9C0040
                   AND sfa03=g_sfs[l_ac].sfs04          #FUN-9C0040
                   AND sfa08=g_sfs[l_ac].sfs10          #FUN-9C0040
                   AND sfa12=g_sfs[l_ac].sfs06          #FUN-9C0040
                   AND sfa27=g_sfs[l_ac].sfs27          #FUN-9C0040
                   AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                   AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028                   
                IF cl_null(l_sfa11) THEN LET l_sfa11='' END IF #MOD-B80013 add
                IF (g_sfp.sfp06 = '7') AND (l_sfa11 <> 'S') THEN    #超領退料  #FUN-9C0040                                                                                              
                   SELECT sfa062 INTO g_sfs[l_ac].sfa06                                                                                                                       
                     FROM sfa_file
                    WHERE sfa01 = g_sfs[l_ac].sfs03
                      AND sfa03 = g_sfs[l_ac].sfs04
                      AND sfa08 = g_sfs[l_ac].sfs10
                      AND sfa12 = g_sfs[l_ac].sfs06
                      AND sfa27 = g_sfs[l_ac].sfs27   #FUN-9B0149
                      AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                      AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                      
                   IF g_sfs[l_ac].sfa06 = 0 THEN
                      CALL cl_err(g_sfs[l_ac].sfa06,"asf-036",1)
                      NEXT FIELD sfs05 
                   ELSE
                      CALL i501_totsfs05(g_sfp.sfp01,g_sfp.sfp06,g_sfs[l_ac].sfs02,
                                         g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs10,
                                         g_sfs[l_ac].sfs27  #FUN-9B0149
                                          ) RETURNING l_totsfs05   #No.MOD-790175 modify                            
                      IF g_sfs[l_ac].sfs05 > g_sfs[l_ac].sfa06-l_totsfs05 THEN                                                                                  
                         CALL cl_getmsg('asf-034',g_lang) RETURNING l_msg                                                                                                                                                                                                            
                         MESSAGE l_msg                                                                                                                                                                                 
                         CALL cl_err(g_sfs[l_ac].sfs05,"abm-010",1)                                                                                                                                               
                         NEXT FIELD sfs05                                                                                                                                      
                      END IF                                                                                                                                                                                
                   END IF                                                                                                                                                         
                END IF                                                                                                                                             
                                                                                                                                                                                 
                IF (g_sfp.sfp06 = '6') AND (l_sfa11 <> 'S') THEN    #成套退料                                                                                                   
                   SELECT sfb09 INTO l_sfb09 FROM sfb_file  #已發-完工                                                                                                                    
                    WHERE sfb01 = g_sfs[l_ac].sfs03   #工單                                                                                                                                               
                  LET l_sfa27=NULL                 #MOD-B70244 add
                  SELECT sfa06,sfa26,sfa27,sfa28   #FUN-B50059
                    INTO l_sfa06,l_sfa26,l_sfa27,l_sfa28 FROM sfa_file
                   WHERE sfa01 = g_sfs[l_ac].sfs03
                     AND sfa03 = g_sfs[l_ac].sfs04
                     AND sfa08 = g_sfs[l_ac].sfs10
                     AND sfa12 = g_sfs[l_ac].sfs06
                     AND sfa27 = g_sfs[l_ac].sfs27   #FUN-9B0149
                     AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                     
                  IF SQLCA.sqlcode THEN 
                     CALL cl_err(g_sfs[l_ac].sfs03,SQLCA.sqlcode,1)
                     NEXT FIELD sfs05
                  END IF 
                  IF g_sfs[l_ac].sfs05 >l_sfa06 THEN
                     CALL cl_err(g_sfs[l_ac].sfs05,"abm-010",1)        
                     NEXT FIELD sfs05
                  END IF
                 #SELECT SUM(sfa06*sfa28),SUM(sfa161) INTO l_sfa06,l_sfa161 FROM sfa_file  #FUN-B50059 #MOD-B70244 mark
                  SELECT SUM(sfa06/sfa28),SUM(sfa161) INTO l_sfa06,l_sfa161 FROM sfa_file  #MOD-B70244 add
                   WHERE sfa01 = g_sfs[l_ac].sfs03                       
                    #AND sfa03 = g_sfs[l_ac].sfs04 #FUN-9C0040 #TQC-B60136
                     AND sfa27 = g_sfs[l_ac].sfs27 #FUN-9C0040 
                     AND sfa08 = g_sfs[l_ac].sfs10
                    #AND sfa12 = g_sfs[l_ac].sfs06 #FUN-9C0040 #TQC-B60136
                     AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                     
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF          
                  IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF     
                  IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF
                 #MOD-B20062---add---start---
                  LET l_sfs05 = 0
                  SELECT sfs05 INTO l_sfs05 FROM sfs_file,sfa_file
                   WHERE sfa01=sfs03 AND sfa03=sfs04
                     AND sfa01=g_sfs[l_ac].sfs03
                     AND sfa27=l_sfa27
                     AND sfs01=g_sfp.sfp01
                     AND sfs02 != g_sfs[l_ac].sfs02
                  IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
                 #MOD-B20062---add---end---
                 #LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05         #MOD-B20062 add l_sfs05 #MOD-B70244 mark
                  LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161)            #MOD-B70244 add
                  CALL i501_totsfs05(g_sfp.sfp01,g_sfp.sfp06,g_sfs[l_ac].sfs02,
                                     g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,
                                     g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs10,
                                     g_sfs[l_ac].sfs27)  #FUN-9B0149 
                       RETURNING l_totsfs05    #No.MOD-790175 modify
                 #IF g_sfs[l_ac].sfs05*l_sfa28 > l_qty - l_totsfs05*l_sfa28 THEN    #MOD-B70244 mark
                  IF g_sfs[l_ac].sfs05/l_sfa28 > l_qty - l_totsfs05 THEN            #MOD-B70244 add
                      CALL cl_getmsg('asf-035',g_lang) RETURNING l_msg                                                                                                                                                                                                            
                      MESSAGE l_msg                                                                                                                                                                       
                      CALL cl_err(g_sfs[l_ac].sfs05,"abm-010",1)                                                                                                                                               
                      NEXT FIELD sfs05                                                                                                                                      
                   END IF                                                                                                                                                                                
                END IF                                                                                                                                                 
                #可退料量 <= 已發量 + 超領量
                IF (g_sfp.sfp06 = '9') AND (l_sfa11 <> 'S') THEN    #領料退料      #FUN-9C0040
                  #SELECT (sfa062+sfa06) INTO l_sfa062     #No.MOD-940164 add  #FUN-B50059 #MOD-C30886 mark
                   SELECT (sfa062+sfa06),sfa05 INTO l_sfa062,l_sfa05                       #MOD-C30886 add
                     FROM sfa_file                                                                                                                                                             
                    WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                                                             
                      AND sfa03 = g_sfs[l_ac].sfs04                                                                                                                        
                      AND sfa08 = g_sfs[l_ac].sfs10                                                                                                                                         
                      AND sfa12 = g_sfs[l_ac].sfs06                                                                                                                                         
                      AND sfa27 = g_sfs[l_ac].sfs27   #FUN-9B0149
                      AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                      AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028                      

                   SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = g_sfs[l_ac].sfs03         #MOD-C30886 add

                   IF cl_null(l_sfa062) THEN LET l_sfa062=0 END IF                      #No.MOD-940164 add 
                   CALL i501_totsfs05(g_sfp.sfp01,g_sfp.sfp06,g_sfs[l_ac].sfs02,
                                      g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs10,
                                      g_sfs[l_ac].sfs27  #FUN-9B0149
                                      ) RETURNING l_totsfs05                             
                   IF l_sfb02 != '5' AND l_sfa05 > 0 THEN              #MOD-C30886 add
                      IF g_sfs[l_ac].sfs05 > l_sfa062+l_totsfs05 THEN             #No.MOD-940164 add                                                                                
                         CALL cl_getmsg('asf-039',g_lang) RETURNING l_msg                                                                                                                                                                                                            
                         MESSAGE l_msg                                                                                                                                                                                 
                         CALL cl_err(g_sfs[l_ac].sfs05,"abm-010",1)                                                                                                                                               
                         NEXT FIELD sfs05                                                                                                                                      
                      END IF
                   END IF                                              #MOD-C30886 add                                                                                                                                                                                
                END IF                                                                                                                                             
                IF (g_sfp.sfp06 = '8') AND (l_sfa11 <> 'S') THEN    #一般退料      #FUN-9C0040
                   SELECT sfb08,sfb09,sfb11 INTO l_sfb08,l_sfb09,l_sfb11 FROM sfb_file  #已發-完工   #No.MOD-760050 add sfb11 #MOD-940347 add sfb08,l_sfb08
                   WHERE sfb01 = g_sfs[l_ac].sfs03   #工單  
                   SELECT sfa05,sfa06,sfa062,sfa161,sfa26,sfa27,sfa28,sfa100     #No.TQC-6C0122 add sfa05  #MOD-8B0230 add sfa100  #FUN-B50059  #MOD-B20062 add sfa062
                   INTO l_sfa05,l_sfa06,l_sfa062,l_sfa161,l_sfa26,          #No.TQC-6C0122 add sfa05    #MOD-B20062 add l_sfa062
                        l_sfa27,l_sfa28,l_sfa100 FROM sfa_file            #MOD-8B0230 add l_sfa100                                                                                                                                                                 
                   WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                                                                                                  
                     AND sfa03 = g_sfs[l_ac].sfs04                                                                                                                                              
                     AND sfa08 = g_sfs[l_ac].sfs10                                                                                                                                            
                     AND sfa12 = g_sfs[l_ac].sfs06  #FUN-9B0149
                     AND sfa27 = g_sfs[l_ac].sfs27  #FUN-9B0149
                     AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028
                     AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
                  #MOD-B20062---add---start---
                   LET b_sfs05 = 0
                   SELECT SUM(sfs05) INTO b_sfs05 FROM sfs_file,sfp_file
                    WHERE sfs01=sfp01
                      AND sfs03 = g_sfs[l_ac].sfs03
                      AND sfs04 = g_sfs[l_ac].sfs04
                      AND (sfp01 != g_sfp.sfp01 OR 
                           (sfp01 = g_sfp.sfp01 AND sfs02 != g_sfs[l_ac].sfs02))
                      AND sfp06 = '8'
                      AND sfpconf != 'X'                #MOD-B80306 add  
                   IF cl_null(b_sfs05) THEN LET b_sfs05 = 0 END IF
                   IF g_sfs[l_ac].sfs05 > ((l_sfa06 + l_sfa062)-b_sfs05) AND l_sfa05 > 0 THEN    #No:MOD-B70204 add sfa05 > 0
                         CALL cl_err(g_sfs[l_ac].sfs05,'asf-708',1)
                         NEXT FIELD sfs05      
                   END IF
                   LET l_sfa05 = 0
                   LET l_sfa06 = 0
                   DECLARE sfa_curs CURSOR FOR
                   SELECT (sfa05/sfa28),(sfa06/sfa28)
                     FROM sfa_file
                   WHERE sfa01 = g_sfs[l_ac].sfs03
                   AND sfa27 = b_sfa27               #110215
                   AND sfa08=g_sfs[l_ac].sfs10
                   FOREACH sfa_curs INTO b_sfa05,b_sfa06
                       LET l_sfa05 = l_sfa05 + b_sfa05
                       LET l_sfa06 = l_sfa06 + b_sfa06
                   END FOREACH
                  #MOD-B20062---add---end---
                  #MOD-B20062---modify---start---
                  #SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file                                                                                                                         
                  #WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs[l_ac].sfs03
                  #AND sfs04=g_sfs[l_ac].sfs04 AND sfs10=g_sfs[l_ac].sfs10                                                                                                                            
                  #AND sfs02!=g_sfs[l_ac].sfs02                                                                                                                                                               
                   LET b_sfs05 = 0
                   LET b_sfa28 = 0
                   LET l_sfs05 = 0
                   DECLARE sfs05_curs CURSOR FOR
                   SELECT sfs05,sfa28 FROM sfs_file,sfa_file     
                   WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs[l_ac].sfs03
                   AND sfa27 = b_sfa27 AND sfs10 = g_sfs[l_ac].sfs10         
                   AND sfa01 = sfs03 AND sfa03 = sfs04                       
                   AND sfs02!=g_sfs[l_ac].sfs02                              
                   FOREACH sfs05_curs INTO b_sfs05,b_sfa28
                      LET sum_sfs05 = b_sfs05/b_sfa28
                      LET l_sfs05 = l_sfs05 + sum_sfs05
                   END FOREACH
                  #MOD-B20062---modify---end---
                                                                                                                                                                                                                    
                   IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF                                                                                                                       
                   IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF   #No.TQC-6C0122 add
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF                                                                                                                                           
                   IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF                                                                                                                                                            
                   IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF                                                                                                                                 
                   IF cl_null(l_sfa28) THEN LET l_sfa28 = 0 END IF                                                                                                                                       
                   IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
                   IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF       #MOD-940347 add
                   IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 END IF
                  
                  #一般退料考慮誤差率sfa100
                  IF cl_null(l_sfa100) THEN LET l_sfa100 = 0 END IF
                  IF g_sma.sma899 = 'Y' THEN 
                     #已發/應發*生產套數*誤差率
                     IF l_sfa100 = 100 THEN
                        LET l_qty = l_sfa06 - g_sfs[l_ac].sfs05-l_sfs05 
                     ELSE
                       #LET l_qty = (((l_sfa06-g_sfs[l_ac].sfs05-l_sfs05)/l_sfa05) * l_sfb08 * (1+l_sfa100/100))             #MOD-B20062 mark
                        #LET l_qty = (((l_sfa06-(g_sfs[l_ac].sfs05/l_sfa28)-l_sfs05)/l_sfa05) * l_sfb08 * (1+l_sfa100/100))   #MOD-B20062 add #MOD-D50178
                        LET l_qty = (((l_sfa06-(g_sfs[l_ac].sfs05/l_sfa28)-l_sfs05)/l_sfa05) * l_sfb08 * (100+l_sfa100/100)) #MOD-D50178
                        #已發料(扣除退料數) - 入庫數(含FQC)
                        LET l_qty = l_qty - (l_sfb09+l_sfb11)
                     END IF       #No:MOD-970298 add
                     IF l_qty < 0 THEN                                                                                                                                   
                        CALL cl_err(g_sfs[l_ac].sfs04,'asf-705',1)  #No.MOD-830099 modify
                        NEXT FIELD sfs05                                                                                                                                                     
                     END IF                                                                                                                                                                
                  ELSE
                     LET l_qty = l_sfa06 - ((l_sfb09 + l_sfb11) * l_sfa161) - l_sfs05
                  END IF  #MOD-8B0230
                  #MOD-B20062---mark---start---
                  #在退料時應只控管數量是否有超過已發量和最小套數，不應在分主副料或取替代料
                  #IF l_sfa26 MATCHES '[3]' THEN                                                                                                                                                         
 
                  #   LET l_sub_qty = 0
                  #   SELECT SUM(sfa06/(sfa28*l_sfa161))   #FUN-B50059
                  #     INTO l_sub_qty                                                                                                                                       
                  #     FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                          
                  #     AND sfa27 = g_sfs[l_ac].sfs04 AND sfa26 ='U'                                                                                                                   
                  #   IF cl_null(l_sub_qty) THEN LET l_sub_qty = 0 END IF                                                                                                                                  
                  #   LET l_qty = 0                                                                                                                                                                             
                  #   LET l_qty = l_sfb09 - l_sub_qty                                                                                                                                  
                  #   IF l_qty < 0 THEN                                                                                                                                   
                  #      LET l_qty = 0                                                                                                                                                                               
                  #   END IF                                                                                                                                                  
                  #   LET l_qty = l_sfa06 - (l_qty * l_sfa161) - l_sfs05                                                                                                     
                  #END IF                                                                                                                                          
                  #IF l_sfa26 MATCHES '[Uu]' THEN                                                                                                                                                              
                  #    SELECT sfa161 INTO l_sfa161_t FROM sfa_file                                                                                              
                  #     WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                                                 
                  #       AND sfa03 = l_sfa27                                                                                                                                                            
                  #    IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF                                                                                                                  
                  #    LET l_qty = 0                                                                                                                                                
 
                  #    LET l_sub_qty = 0
                  #    SELECT SUM(sfs05/(sfa28*l_sfa161_t)) INTO l_sub_qty 
                  #      FROM sfs_file,sfa_file
                  #      WHERE sfs01 = g_sfp.sfp01  
                  #        AND sfs03 = g_sfs[l_ac].sfs03                                                                                                                                               
                  #        AND sfs04 != g_sfs[l_ac].sfs04
                  #        AND sfa01 = sfs03
                  #        AND sfa27 = l_sfa27
                  #        AND sfa03 = sfs04
                  #        AND (sfa26 = 'U' OR sfa26 = 'u')
                  #    IF cl_null(l_sub_qty) THEN LET l_sub_qty = 0 END IF                                                                                                                                    
 
                  #    LET l_sub_qty1 = 0
                  #    SELECT SUM(sfa06/(sfa28*l_sfa161_t)) INTO l_sub_qty1  #FUN-B50059
                  #      FROM sfa_file
                  #      WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                                                               
                  #        AND sfa03 != g_sfs[l_ac].sfs04
                  #        AND sfa27 = l_sfa27
                  #        AND (sfa26 = 'U' OR sfa26 = 'u')
                  #    IF cl_null(l_sub_qty1) THEN LET l_sub_qty = 0 END IF                                                                                                                                    
                  #    LET l_qty = l_sfb09 - (l_sub_qty1 - l_sub_qty)
                  #    IF l_qty < 0 THEN                                                                                                                                   
                  #       LET l_qty = 0                                                                                                                                                                               
                  #    END IF                                                                                                                                                  
                  #    LET l_qty =l_sfa06-(l_qty*l_sfa161_t*l_sfa28)-l_sfs05                                                                                                     
                  #END IF                                                                                                                                                                        
                  #IF l_sfa26 MATCHES '[4]' THEN         
                  #    SELECT sfa28                                                                                                                             
                  #      INTO l_sfa28_t                                                                                                                                                
                  #      FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                   
                  #      AND sfa27 = g_sfs[l_ac].sfs04 
                  #      AND sfa26 ='S'                                                                                                        
                  #    IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF                                                                                                                                  
                  #    LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05                                                                                                                                
                  #                                                                                                                                                                                             
                  #END IF                                                                                                                                                                       
                  #IF l_sfa26 MATCHES '[Ss]' THEN                                                                                                                                                                  
                  #   SELECT sfa06,sfa161 INTO l_sfa06_t,l_sfa161_t                                                                                             
                  #    FROM sfa_file                                                                                                                                                    
                  #    WHERE sfa01 = g_sfs[l_ac].sfs03                                                                                                                                                    
                  #      AND sfa03 = l_sfa27                                                                                                                                
                  #                                                                                                                                                                          
                  #   IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF                                                                                                          
                  #   IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
                  #   LET l_qty = 0                                                                                                                                                                             
 
                  #   LET l_sub_qty = 0
                  #   SELECT SUM(sfs05/(sfa28*l_sfa161_t)) INTO l_sub_qty 
                  #     FROM sfs_file,sfa_file
                  #     WHERE sfs01 = g_sfp.sfp01  
                  #       AND sfs03 = g_sfs[l_ac].sfs03                                                                                                                                               
                  #       AND sfs04 != g_sfs[l_ac].sfs04
                  #       AND sfa01 = sfs03
                  #       AND sfa27 = l_sfa27
                  #       AND sfa03 = sfs04
                  #       AND (sfa26 = 'S' OR sfa26 = 's')
                  #   IF cl_null(l_sub_qty) THEN LET l_sub_qty = 0 END IF                                                                                                                                    
                  #   LET l_qty=l_sfb09-l_sub_qty-(l_sfa06_t/l_sfa161_t)
                  #   IF l_qty < 0 THEN                                                                                                                                   
                  #      LET l_qty = 0                                                                                                                                                                               
                  #   END IF                                                                                                                                                  
                  #   LET l_qty=l_sfa06-(l_qty*l_sfa161_t*l_sfa28)-l_sfs05                                                                                                                                 
                  #END IF                                                                                                                                                         
                  #MOD-B20062---mark---end---
#FUN-A20037 --begin--
                   IF l_sfa26 MATCHES '[8]' THEN
                      SELECT sfa28
                        INTO l_sfa28_t
                        FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03
                        AND sfa27 = g_sfs[l_ac].sfs04
                        AND sfa26 ='Z'
                      IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF
                      LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05
                   END IF
                   IF l_sfa26 MATCHES '[Zz]' THEN
                      SELECT sfa06,sfa161 INTO l_sfa06_t,l_sfa161_t  #FUN-B50059
                       FROM sfa_file
                       WHERE sfa01 = g_sfs[l_ac].sfs03
                         AND sfa03 = l_sfa27

                      IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF
                      IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
                      LET l_qty = 0

                      LET l_sub_qty = 0
                      SELECT SUM(sfs05/(sfa28*l_sfa161_t)) INTO l_sub_qty
                        FROM sfs_file,sfa_file
                        WHERE sfs01 = g_sfp.sfp01
                          AND sfs03 = g_sfs[l_ac].sfs03
                          AND sfs04 != g_sfs[l_ac].sfs04
                          AND sfa01 = sfs03
                          AND sfa27 = l_sfa27
                          AND sfa03 = sfs04
                          AND (sfa26 = 'Z' OR sfa26 = 'z')
                      IF cl_null(l_sub_qty) THEN LET l_sub_qty = 0 END IF
                      LET l_qty=l_sfb09-l_sub_qty-(l_sfa06_t/l_sfa161_t)
                      IF l_qty < 0 THEN
                         LET l_qty = 0
                      END IF
                      LET l_qty=l_sfa06-(l_qty*l_sfa161_t*l_sfa28)-l_sfs05
                   END IF
#FUN-A20037 --end--
                                                                                                                                                                                                                 
                   IF l_sfa05 < 0 THEN
                      LET l_qty = (l_sfa05* -1) - l_sfs05                                                                                                                              
                   END IF                                                                                                                                                    
                                                                                                                                                                
                  #IF g_sfs[l_ac].sfs05 > l_qty AND g_sma.sma899 ='N' THEN   #MOD-8B0230 add sma899  #MOD-B20062 mark                                                                                                                 
                   IF (g_sfs[l_ac].sfs05/l_sfa28) > l_qty AND g_sma.sma899 ='N' THEN                 #MOD-B20062 add                                                                                                                           
                      CALL cl_err(' ','asf-705',1)
                      NEXT FIELD sfs05                                                                                                                                                     
                   END IF                                                                                                                                                                
                END IF
                #FUN-9C0040(S)
                IF l_sfa11='S' THEN
                  SELECT sfa05,sfa06,sfa161,sfa26,sfa27,sfa28,sfa100  #FUN-B50059
                    INTO l_sfa05,l_sfa06,l_sfa161,l_sfa26,
                         l_sfa27,l_sfa28,l_sfa100 FROM sfa_file
                   WHERE sfa01 = g_sfs[l_ac].sfs03
                     AND sfa03 = g_sfs[l_ac].sfs04
                     AND sfa08 = g_sfs[l_ac].sfs10
                     AND sfa12 = g_sfs[l_ac].sfs06
                     AND sfa27 = g_sfs[l_ac].sfs27
                     AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
                     
                  SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file                                                                                                                         
                  WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs[l_ac].sfs03
                  AND sfs04=g_sfs[l_ac].sfs04 AND sfs10=g_sfs[l_ac].sfs10                                                                                                                            
                  AND sfs02!=g_sfs[l_ac].sfs02                                                                                                                                                               
                                                                                                                                                                                                                   
                  IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF                                                                                                                       
                  IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF                                                                                                                                           
                  IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF                                                                                                                                                            
                  IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF                                                                                                                                 
                  IF cl_null(l_sfa28) THEN LET l_sfa28 = 0 END IF                                                                                                                                       
                  IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF
                  IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
                  IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 END IF

                  IF l_sfa06 < 0 THEN LET l_sfa06 = l_sfa06 * (-1) END IF
                 #IF l_sfa161< 0 THEN LET l_sfa06 = l_sfa06 * (-1) END IF
                  IF l_sfa05 < 0 THEN LET l_sfa05 = l_sfa05 * (-1) END IF

                  #一般退料考慮誤差率sfa100
                  IF cl_null(l_sfa100) THEN LET l_sfa100 = 0 END IF
                  IF g_sma.sma899 = 'Y' THEN
                     #已發/應發*生產套數*誤差率
                     #LET l_qty = (l_sfa05 * (1+l_sfa100/100))-l_sfa06-g_sfs[l_ac].sfs05-l_sfs05 #MOD-D50178
                     LET l_qty = (l_sfa05 * (100+l_sfa100/100))-l_sfa06-g_sfs[l_ac].sfs05-l_sfs05 #MOD-D50178
                  ELSE  #FUN-9C0040
                     LET l_qty = l_sfa05 - l_sfa06-g_sfs[l_ac].sfs05-l_sfs05 #FUN-9C0040
                  END IF #FUN-9C0040 
                  IF l_qty < 0 THEN                                                                                                                                   
                     CALL cl_err(g_sfs[l_ac].sfs04,'asf-705',1)
                     NEXT FIELD sfs05                                                                                                                                                     
                  END IF                                                                                                                                                                
                 #ELSE #FUN-9C0040
                 #   LET l_qty = l_sfa06 - ((l_sfb09 + l_sfb11) * l_sfa161) - l_sfs05 #FUN-9C0040
                 #END IF #FUN-9C0040
                END IF
                #FUN-9C0040(E)                                                                                                                                          
              END IF                                                                           
            END IF                                                                                                                                                                    
            LET g_ima918 = ''    #DEV-D50009 add
            LET g_ima921 = ''    #DEV-D50009 add
            LET g_ima930 = ''    #DEV-D50009 add 
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
              FROM ima_file
             WHERE ima01 = g_sfs[l_ac].sfs04
               AND imaacti = "Y"

            IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF  #DEV-D50009 add
            IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF  #DEV-D50009 add            
            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

            IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
               (cl_null(g_sfs_t.sfs05) OR (g_sfs[l_ac].sfs05<>g_sfs_t.sfs05 )) THEN
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
               SELECT img09 INTO g_img09
                 FROM img_file
                WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                  AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
               CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09) 
                    RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
               IF g_sfp.sfp06 MATCHES '[6789B]' THEN
#TQC-C10033 --unmark--
  #MOD-C10100 --begin--
                    IF g_ima930 = 'N' THEN                                        #DEV-D30059
                       CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0, #No.TQC-B90236 modify s_lotout->s_mod_lot
                                     g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                     g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                     g_sfs[l_ac].sfs06,g_img09,l_fac,
                                     g_sfs[l_ac].sfs05,'','SEL',1)  #CHI-9A0022 add '' #No.TQC-B90236 add 1
                             RETURNING l_r,g_qty 
                    END IF                                                        #DEV-D30059
  #MOD-C10100 --end--
#TQC-C10033 --unmark
               ELSE
#No.CHI-9A0022 --Begin
                  LET l_bno = ''
                  SELECT sfb27
                    INTO l_bno
                    FROM sfb_file
                   WHERE sfb01 = g_sfs[l_ac].sfs03
                  IF cl_null(l_bno) THEN
                     LET l_bno = g_sfs[l_ac].sfs03
                  END IF
#No.CHI-9A0022 --End
#TQC-C10033 --unmark
  #MOD-C10100 --begin--
                    IF g_ima930 = 'N' THEN                                        #DEV-D30059
                    CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,   #No.TQC-B90236 modify s_lotout->s_mod_lot
                                  g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                  g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                  g_sfs[l_ac].sfs06,g_img09,l_fac,
                                  g_sfs[l_ac].sfs05,l_bno,'MOD',-1)#CHI-9A0022 add l_bno #No.TQC-B90236 add -1
                          RETURNING l_r,g_qty 
                    END IF                                                        #DEV-D30059
  #MOD-C10100 --end--
#TQC-C10033 --unmark
               END IF
               
               IF l_r = "Y" THEN
                  LET g_sfs[l_ac].sfs05 = g_qty
               END IF
            END IF
            IF p_cmd = 'u' AND NOT cl_null(g_sfs_t.sfs05) AND
               g_sfs_t.sfs05 <> g_sfs[l_ac].sfs05 THEN
               #CALL i501_ind_icd_chk_icdqty()   #TQC-C20098
               CALL i501_ind_icd_chk_icdqty('1')  #TQC-C20098
                    RETURNING l_flag              #No.FUN-830132 add
            END IF
            #FUN-A40022--begin--add-------
            CALL i501_chk_batch_num()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_sfs[l_ac].sfs04,g_errno,1)
               NEXT FIELD CURRENT
            END IF
            #FUN-A40022--end--add---------
#FUN-A20048 --begin     #發料數量不可大於庫存-備置量
#FUN-AC0074--begin--mark-----
#           IF NOT cl_null(g_sfs[l_ac].sfs04) AND NOT cl_null(g_sfs[l_ac].sfs03)  THEN   
#              IF g_sfp.sfp06 MATCHES '[1234AC]' THEN  
#                 SELECT SUM(sie10) INTO l_qty FROM sie_file 
#                 WHERE sie05!=g_sfs[l_ac].sfs03 AND sie01=g_sfs[l_ac].sfs04                 
#                 IF g_sfs[l_ac].sfs05 > g_img10 - l_qty THEN 
#                    CALL cl_err(g_sfs[l_ac].sfs05,'sia-103',1)
#                    NEXT FIELD sfs05
#                 END IF 
#              END IF 
#           END IF                
##FUN-A20048 --end 
##FUN-A20048 --begin
##检查此料是否有备置，如果有备置，须检查发料的仓储批与备料仓储批是否一致
##如不一致，须检查备置数量之和不可大于发料数量，并提示已备其他仓储批，是否考虑退备置。
#          IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
#           LET l_cnt = 0
#           LET l_qty = 0
#           SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie05=g_sfs[l_ac].sfs03   
#           IF l_cnt > 0 THEN                 
#            DECLARE sie_curs CURSOR FOR SELECT * FROM sie_file WHERE sie01=g_sfs[l_ac].sfs04 AND sie11 > 0 
#                 AND sie05=g_sfs[l_ac].sfs03
#            FOREACH sie_curs INTO l_sie.*
#             IF l_sie.sie02 = g_sfs[l_ac].sfs07 AND l_sie.sie03 = g_sfs[l_ac].sfs08 
#               AND l_sie.sie04 = g_sfs[l_ac].sfs09 THEN              
#                CONTINUE FOREACH 
#             ELSE 
#             	 LET l_qty = l_qty + l_sie.sie11
#             END IF 
#            END FOREACH
#            IF l_qty > g_sfs[l_ac].sfs05 THEN 
#               CALL cl_err(l_qty,'sia-104',1)
#               NEXT FIELD sfs05
#            END IF 
#           END IF
#          END IF        
#FUN-AC0074--end--mark----
#FUN-A20048 --end  
 
        BEFORE FIELD sfs33
           IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
              SELECT ima55,ima31 INTO g_ima55,g_ima31
                FROM ima_file WHERE ima01=g_sfs[l_ac].sfs04
           END IF
           CALL i501_set_no_required()
 
        AFTER FIELD sfs33  #第二單位
           IF cl_null(g_sfs[l_ac].sfs04) THEN NEXT FIELD sfs04 END IF
           IF g_sfs[l_ac].sfs07 IS NULL OR g_sfs[l_ac].sfs08 IS NULL OR
              g_sfs[l_ac].sfs09 IS NULL THEN
              NEXT FIELD sfs09
           END IF
           IF NOT cl_null(g_sfs[l_ac].sfs33) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfs[l_ac].sfs33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_sfs[l_ac].sfs33,"",STATUS,"","gfe:",1)  #No.FUN-660128
                 NEXT FIELD sfs33
              END IF
              CALL s_du_umfchk(g_sfs[l_ac].sfs04,'','','',
                               g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfs[l_ac].sfs33,g_errno,0)
                 NEXT FIELD sfs33
              END IF
              LET g_sfs[l_ac].sfs34 = g_factor
              CALL s_chk_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                              g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                              g_sfs[l_ac].sfs33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv1 = '1' THEN  #發料
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel img:',STATUS,0)
                   #NEXT FIELD sfs33
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                       CALL cl_err('sel imgg:',STATUS,0)
                       NEXT FIELD sfs33
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfs33 END IF
                 END IF
                    CALL s_add_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                    g_sfs[l_ac].sfs33,g_sfs[l_ac].sfs34,
                                    g_sfp.sfp01,
                                    g_sfs[l_ac].sfs02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD sfs33
                    END IF
              END IF
           END IF
           IF g_ima906 = '2' AND g_sma.sma115 = 'Y' THEN
              CALL i501_imgg10()
           END IF
           CALL i501_du_data_to_correct()
           CALL i501_set_required()
           CALL cl_show_fld_cont()
 
        BEFORE FIELD sfs34  #第二轉換率
           IF cl_null(g_sfs[l_ac].sfs04) THEN NEXT FIELD sfs04 END IF
           IF g_sfs[l_ac].sfs05 IS NULL OR g_sfs[l_ac].sfs06 IS NULL OR
              g_sfs[l_ac].sfs07 IS NULL THEN
              NEXT FIELD sfs07
           END IF
           IF NOT cl_null(g_sfs[l_ac].sfs33) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                              g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                              g_sfs[l_ac].sfs33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv1 = '1' THEN    #發料
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel img:',STATUS,0)
                   #NEXT FIELD sfs33
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                       CALL cl_err('sel imgg:',STATUS,0)
                       NEXT FIELD sfs33
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfs33 END IF
                 END IF
                    CALL s_add_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                    g_sfs[l_ac].sfs33,g_sfs[l_ac].sfs34,
                                    g_sfp.sfp01,
                                    g_sfs[l_ac].sfs02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD sfs33
                    END IF
              END IF
           END IF
 
        AFTER FIELD sfs34  #第二轉換率
           IF NOT cl_null(g_sfs[l_ac].sfs34) THEN
              IF g_sfs[l_ac].sfs34=0 THEN
                 NEXT FIELD sfs34
              END IF
           END IF
 
        BEFORE FIELD sfs35
           IF NOT cl_null(g_sfs[l_ac].sfs33) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                              g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                              g_sfs[l_ac].sfs33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv1 = '1' THEN    #發料
                   #FUN-C80107 modify begin---------------------------------121024
                   #CALL cl_err('sel img:',STATUS,0)
                   #NEXT FIELD sfs07
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                        CALL cl_err('sel imgg:',STATUS,0)
                        NEXT FIELD sfs07
                    END IF
                   #FUN-C80107 modify end-----------------------------------
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfs07 END IF
                 END IF
                    CALL s_add_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                    g_sfs[l_ac].sfs33,g_sfs[l_ac].sfs34,
                                    g_sfp.sfp01,
                                    g_sfs[l_ac].sfs02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD sfs07
                    END IF
              END IF
           END IF
 
        AFTER FIELD sfs35  #第二數量
           IF NOT cl_null(g_sfs[l_ac].sfs35) THEN
              IF g_sfs[l_ac].sfs35 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD sfs35
              END IF
             #str MOD-A60062 add
              IF g_sfp.sfp06 MATCHES '[13]' THEN                                                                                                                                 
                 IF g_sfs[l_ac].sfs35 <0 THEN
                    CALL cl_err(g_sfs[l_ac].sfs35,"asf-037",1)
                    NEXT FIELD sfs35
                 END IF
                 #同一張備料單也考慮單身有數筆同一張工單的備料量計算
                 LET l_sfs35x = 0
                 SELECT SUM(sfs35) INTO l_sfs35x FROM sfs_file,sfp_file
                  WHERE sfs03=g_sfs[l_ac].sfs03
                    AND sfs04=g_sfs[l_ac].sfs04
                    AND sfs33=g_sfs[l_ac].sfs33
                    AND sfs10=g_sfs[l_ac].sfs10
                    AND sfs012=g_sfs[l_ac].sfs012  # FUN-B20079 jan
                    AND sfs013=g_sfs[l_ac].sfs013  #FUN-B20079 jan   
                    AND sfs27=b_sfs.sfs27     #No:MOD-A70119 add                                                                                                                                              
                    AND sfs01=g_sfp.sfp01
                    AND sfs02!= g_sfs[l_ac].sfs02
                    AND sfp01=sfs01 AND sfpconf !='X'
                 IF STATUS OR cl_null(l_sfs35x) THEN LET l_sfs35x = 0 END IF
                 #FUN-B20095--begin
                 SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = g_sfs[l_ac].sfs04
                 CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs33,g_sfs[l_ac].sfs30)
                      RETURNING g_errno,l_factor
                 IF l_ima906 = '3' THEN
                    LET l_sfs35 = g_sfs[l_ac].sfs35*l_factor
                 END IF
                 #FUN-B20095--end
                 #IF g_sfs[l_ac].sfs35>(g_sfs[l_ac].sfa05-g_sfs[l_ac].sfa06-l_sfs35x) THEN  #FUN-B20095
             #MOD-BA0137 -- mark begin --
             #    IF l_sfs35>(g_sfs[l_ac].sfa05-g_sfs[l_ac].sfa06-l_sfs35x) THEN  #FUN-B20095
             #       LET l_msg=g_sfs[l_ac].sfs04 CLIPPED,' sfs32<>sfa05:'
             #       CALL cl_err(l_msg CLIPPED ,'asf-351',0) NEXT FIELD sfs35
             #    END IF
             #MOD-BA0137 -- mark end --
              END IF
               #end MOD-A60062 add
              IF g_sfp.sfp06 = '2' THEN
              END IF                                                                                                                
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 g_sfs_t.sfs35 <> g_sfs[l_ac].sfs35 THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_sfs[l_ac].sfs35*g_sfs[l_ac].sfs34
                    IF cl_null(g_sfs[l_ac].sfs32) OR g_sfs[l_ac].sfs32=0 THEN #CHI-960022
                       LET g_sfs[l_ac].sfs32=g_tot*g_sfs[l_ac].sfs31
                       DISPLAY BY NAME g_sfs[l_ac].sfs32                      #CHI-960022
                    END IF                                                    #CHI-960022
                 END IF
              END IF
              IF g_ima906 MATCHES '[23]' THEN
                 SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
                  WHERE imgg01=g_sfs[l_ac].sfs04
                    AND imgg02=g_sfs[l_ac].sfs07
                    AND imgg03=g_sfs[l_ac].sfs08
                    AND imgg04=g_sfs[l_ac].sfs09
                    AND imgg09=g_sfs[l_ac].sfs33
              END IF
              IF NOT cl_null(g_sfs[l_ac].sfs33) THEN
                 IF g_sfp.sfp06 MATCHES '[1234]' THEN
                    #IF g_sfs[l_ac].sfs35 > g_imgg10_2 THEN   #MOD-C50190 mark
                    IF g_sfs[l_ac].sfs35 > g_imgg10_2 AND NOT i501_isVMI(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN #MOD-C50190 add i501_isVMI
                      #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
                      #FUN-D30024--modify--str--
                      #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894      #FUN-C80107
                      #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                       INITIALIZE g_imd23 TO NULL
                       CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                       IF g_imd23 = 'N' THEN
                      #FUN-D30024--modify--end--
                          CALL cl_err(g_sfs[l_ac].sfs35,'mfg1303',0)
                          NEXT FIELD sfs35
                       END IF
                    END IF
                 END IF
              END IF
            #此段copy from AFTER FIELD sfs05
            LET g_ima918 = ''   #DEV-D50009 add
            LET g_ima921 = ''   #DEV-D50009 add
            LET g_ima930 = ''   #DEV-D50009 add
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
              FROM ima_file
             WHERE ima01 = g_sfs[l_ac].sfs04
               AND imaacti = "Y"
            
            IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF  #DEV-D50009 add
            IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF  #DEV-D50009 add
            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

            IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
               (cl_null(g_sfs_t.sfs35) OR (g_sfs[l_ac].sfs35<>g_sfs_t.sfs35 )) THEN
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
               SELECT img09 INTO g_img09
                 FROM img_file
                WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                  AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
               CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09) 
                    RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
               IF g_sfp.sfp06 MATCHES '[6789B]' THEN
#TQC-C10033 --unmark
 #MOD-C10100 -begin--
                   IF g_ima930 = 'N' THEN                                        #DEV-D30059
                      CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0, #No.TQC-B90236 modify s_lotout->s_mod_lot
                                    g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                    g_sfs[l_ac].sfs06,g_img09,l_fac,
                                    g_sfs[l_ac].sfs05,'','SEL',1)#CHI-9A0022 add '' #No.TQC-B90236 add 1
                            RETURNING l_r,g_qty 
                   END IF                                                        #DEV-D30059
 #MOD-C10100 --end--
#TQC-C10033 --unmark
               ELSE
#No.CHI-9A0022 --Begin
                  LET l_bno = ''
                  SELECT sfb27
                    INTO l_bno
                    FROM sfb_file
                   WHERE sfb01 = g_sfs[l_ac].sfs03
                  IF cl_null(l_bno) THEN
                     LET l_bno = g_sfs[l_ac].sfs03
                  END IF
#No.CHI-9A0022 --End

#TQC-C10033 --unmark
  #MOD-C10100 --begin--
                   IF g_ima930 = 'N' THEN                                        #DEV-D30059
                      CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0, #No.TQC-B90236 modify s_lotout->s_mod_lot
                                    g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                    g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                    g_sfs[l_ac].sfs06,g_img09,l_fac,
                                    g_sfs[l_ac].sfs05,l_bno,'MOD',-1)#CHI-9A0022 add l_bno #No.TQC-B90236 add -1
                            RETURNING l_r,g_qty 
                   END IF                                                        #DEV-D30059
  #MOD-C10100 --end--
#TQC-C10033 --unmark
               END IF
               IF l_r = "Y" THEN
                  LET g_sfs[l_ac].sfs05 = g_qty
               END IF
            END IF
           END IF
           CALL cl_show_fld_cont()
 
        BEFORE FIELD sfs30
           CALL i501_set_no_required()
 
        AFTER FIELD sfs30  #第一單位
           IF cl_null(g_sfs[l_ac].sfs04) THEN NEXT FIELD sfs04 END IF
           #若已有idb存在不可修改
          #IF g_sfp.sfp06 MATCHES '[16]' THEN #CHI-A70060 mark
           IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
              IF p_cmd = 'u' AND g_sma.sma115 = 'Y' THEN  #修改且多單位
                 IF NOT cl_null(g_sfs[l_ac].sfs30) THEN
                    LET g_ima906 = NULL
                    SELECT ima906 INTO g_ima906 FROM ima_file
                     WHERE ima01 = g_sfs[l_ac].sfs04
                    IF NOT cl_null(g_ima906) AND g_ima906 MATCHES '[13]' THEN
                       IF g_sfs_t.sfs30 <> g_sfs[l_ac].sfs30 THEN
                          CALL i501_ind_icd_chk_icd()
                          IF NOT cl_null(g_errno) THEN
                             CALL cl_err('',g_errno,0)
                             LET g_sfs[l_ac].sfs30  = g_sfs_t.sfs30
                             NEXT FIELD sfs30
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
           END IF
           IF g_sfs[l_ac].sfs07 IS NULL OR g_sfs[l_ac].sfs08 IS NULL OR
              g_sfs[l_ac].sfs09 IS NULL THEN
              NEXT FIELD sfs09
           END IF
           IF NOT cl_null(g_sfs[l_ac].sfs30) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfs[l_ac].sfs30
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_sfs[l_ac].sfs30,"",STATUS,"","gfe",1)  #No.FUN-660128
                 NEXT FIELD sfs30
              END IF
              CALL s_du_umfchk(g_sfs[l_ac].sfs04,'','','',
                               g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfs[l_ac].sfs30,g_errno,0)
                 NEXT FIELD sfs30
              END IF
              LET g_sfs[l_ac].sfs31 = g_factor
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                 g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                 g_sfs[l_ac].sfs30) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_argv1 = '1' THEN    #發料
                      #FUN-C80107 modify begin---------------------------------121024
                      #CALL cl_err('sel img:',STATUS,0)
                      #NEXT FIELD sfs30
                      #FUN-D30024--modify--str--
                      #INITIALIZE g_sma894 TO NULL
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894
                      #IF g_sma894 = 'N' THEN
                       INITIALIZE g_imd23 TO NULL
                       CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                       IF g_imd23 = 'N' THEN
                      #FUN-D30024--modify--end--
                          CALL cl_err('sel imgg:',STATUS,0)
                          NEXT FIELD sfs30
                       END IF
                      #FUN-C80107 modify end-----------------------------------
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD sfs30 END IF
                    END IF
                       CALL s_add_imgg(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                       g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                       g_sfs[l_ac].sfs30,g_sfs[l_ac].sfs31,
                                       g_sfp.sfp01,
                                       g_sfs[l_ac].sfs02,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD sfs30
                       END IF
                 END IF
              END IF
              IF g_ima906 ='2' THEN
                 SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
                  WHERE imgg01=g_sfs[l_ac].sfs04
                    AND imgg02=g_sfs[l_ac].sfs07
                    AND imgg03=g_sfs[l_ac].sfs08
                    AND imgg04=g_sfs[l_ac].sfs09
                    AND imgg09=g_sfs[l_ac].sfs30
              ELSE
                 SELECT img10 INTO g_imgg10_1 FROM img_file
                  WHERE img01=g_sfs[l_ac].sfs04
                    AND img02=g_sfs[l_ac].sfs07
                    AND img03=g_sfs[l_ac].sfs08
                    AND img04=g_sfs[l_ac].sfs09
              END IF
           END IF
           IF g_ima906 = '2' AND g_sma.sma115 = 'Y' THEN
              CALL i501_imgg10()
           END IF
           CALL i501_du_data_to_correct()
           CALL i501_set_required()
           CALL cl_show_fld_cont()
 
        AFTER FIELD sfs31  #第一轉換率
           IF NOT cl_null(g_sfs[l_ac].sfs31) THEN
              IF g_sfs[l_ac].sfs31=0 THEN
                 NEXT FIELD sfs31
              END IF
           END IF
 
        AFTER FIELD sfs32  #第一數量
           IF NOT cl_null(g_sfs[l_ac].sfs32) THEN
              IF g_sfs[l_ac].sfs32 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD sfs32
              END IF
             #str MOD-A60062 add
              IF g_sfp.sfp06 MATCHES '[13]' THEN                                                                                                                                 
                 IF g_sfs[l_ac].sfs32 <0 THEN
                    CALL cl_err(g_sfs[l_ac].sfs32,"asf-037",1)
                    NEXT FIELD sfs32
                 END IF
                 #同一張備料單也考慮單身有數筆同一張工單的備料量計算
                 LET l_sfs32x = 0
                 SELECT SUM(sfs32) INTO l_sfs32x FROM sfs_file,sfp_file
                  WHERE sfs03=g_sfs[l_ac].sfs03
                    AND sfs04=g_sfs[l_ac].sfs04
                    AND sfs30=g_sfs[l_ac].sfs30
                    AND sfs10=g_sfs[l_ac].sfs10
                    AND sfs012=g_sfs[l_ac].sfs012  #FUN-B20079 jan
                    AND sfs013=g_sfs[l_ac].sfs013  #FUN-B20079 jan   
                    AND sfs27=b_sfs.sfs27     #No:MOD-A70119 add                                                                                                                                              
                    AND sfs01=g_sfp.sfp01
                    AND sfs02!= g_sfs[l_ac].sfs02
                    AND sfp01=sfs01 AND sfpconf !='X'
                 IF STATUS OR cl_null(l_sfs32x) THEN LET l_sfs32x = 0 END IF
                 IF g_sfs[l_ac].sfs32>(g_sfs[l_ac].sfa05-g_sfs[l_ac].sfa06-l_sfs32x) THEN
                    LET l_msg=g_sfs[l_ac].sfs04 CLIPPED,' sfs32<>sfa05:'
                    CALL cl_err(l_msg CLIPPED ,'asf-351',0) NEXT FIELD sfs32
                 END IF
              END IF
             #end MOD-A60062 add
              IF NOT cl_null(g_sfs[l_ac].sfs30) THEN
                 IF g_sfp.sfp06 MATCHES '[1234]' THEN
                    IF g_ima906 = '2' THEN
                       #IF g_sfs[l_ac].sfs32 > g_imgg10_1 THEN  #MOD-C50190 mark
                       IF g_sfs[l_ac].sfs32 > g_imgg10_1 AND NOT i501_isVMI(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN #MOD-C50190 add i501_isVMI 
                         #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
                         #FUN-D30024--modify--str--
                         #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894      #FUN-C80107
                         #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                          INITIALIZE g_imd23 TO NULL
                          CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant 
                          IF g_imd23 = 'N' THEN
                         #FUN-D30024--modify--end--
                             CALL cl_err(g_sfs[l_ac].sfs32,'mfg1303',0)
                             NEXT FIELD sfs32
                          END IF
                       END IF
                    ELSE
                      #str MOD-A50001 add
                      #抓取單位一與庫存單位間的轉換率(l_factor)
                       IF g_sfs[l_ac].sfs30<>g_img09 THEN
                          CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs30,g_img09)
                               RETURNING l_flag,l_factor
                       ELSE
                          LET l_factor = 1
                       END IF
                      #end MOD-A50001 add
                      #IF g_sfs[l_ac].sfs31 * g_sfs[l_ac].sfs32 > g_imgg10_1 THEN  #MOD-A50001 mark
                      #IF l_factor * g_sfs[l_ac].sfs32 > g_imgg10_1 THEN           #MOD-A50001 #MOD-C50190 mark
                       IF l_factor * g_sfs[l_ac].sfs32 > g_imgg10_1 AND NOT i501_isVMI(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN #MOD-C50190 add i501_isVMI
                         #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
                         #FUN-D30024--modify--str--
                         #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894      #FUN-C80107
                         #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                          INITIALIZE g_imd23 TO NULL
                          CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                          IF g_imd23 = 'N' THEN
                         #FUN-D30024--modify--end--
                             CALL cl_err(g_sfs[l_ac].sfs32,'mfg1303',0)
                             NEXT FIELD sfs32
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
           END IF
           DISPLAY BY NAME g_sfs[l_ac].sfs32     #No.MOD-530747 add
           CALL cl_show_fld_cont()
           CALL i501_set_origin_field()   #重取一下值
           IF p_cmd = 'u' AND NOT cl_null(g_sfs_t.sfs32) AND
              g_sfs_t.sfs32 <> g_sfs[l_ac].sfs32 THEN
              #修改數量,若料號有展明細(imaicd08) ='Y',
              #則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
              #CALL i501_ind_icd_chk_icdqty() #TQC-C20098
              CALL i501_ind_icd_chk_icdqty('1')  #TQC-C20098
                   RETURNING l_flag       #No.FUN-830132 add
           END IF
           #FUN-A40022--begin--add-------------
           CALL i501_chk_batch_num()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_sfs[l_ac].sfs04,g_errno,1)
              NEXT FIELD CURRENT
           END IF
           #FUN-A40022--end--add--------------
           
        AFTER FIELD sfs930 
           IF NOT s_costcenter_chk(g_sfs[l_ac].sfs930) THEN
              LET g_sfs[l_ac].sfs930=g_sfs_t.sfs930
              LET g_sfs[l_ac].gem02c=g_sfs_t.gem02c
              DISPLAY BY NAME g_sfs[l_ac].sfs930,g_sfs[l_ac].gem02c
              NEXT FIELD sfs930
           ELSE
              LET g_sfs[l_ac].gem02c=s_costcenter_desc(g_sfs[l_ac].sfs930)
              DISPLAY BY NAME g_sfs[l_ac].gem02c
           END IF
        
        AFTER FIELD sfs36
           IF NOT cl_null(g_sfs[l_ac].sfs36) THEN
              SELECT COUNT(*) INTO g_cnt FROM mse_file
               WHERE mse01 = g_sfs[l_ac].sfs36
              IF g_cnt = 0 THEN
                 CALL cl_err(g_sfs[l_ac].sfs36,'mfg2603',0)
                 NEXT FIELD sfs36
              ELSE 
                SELECT mse02 INTO g_sfs[l_ac].mse02
                  FROM mse_file WHERE mse01=g_sfs[l_ac].sfs36
                DISPLAY g_sfs[l_ac].mse02 TO FORMONLY.mse02
              END IF
           END IF

        #FUN-CB0087--add--str--
        BEFORE FIELD sfs37
           IF g_aza.aza115 = 'Y' AND cl_null(g_sfs[l_ac].sfs37) THEN 
              CALL s_reason_code(g_sfp.sfp01,g_sfs[l_ac].sfs03,'',g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING g_sfs[l_ac].sfs37
              DISPLAY BY NAME g_sfs[l_ac].sfs37
           END IF
        AFTER FIELD sfs37
          IF g_aza.aza115 = 'Y' THEN 
             IF i501_sfs37_check() THEN 
                SELECT azf03 INTO g_sfs[l_ac].azf03_1 FROM azf_file WHERE azf01=g_sfs[l_ac].sfs37 AND azf02='2'
                DISPLAY BY NAME g_sfs[l_ac].azf03_1
             END IF 
          END IF 
          CALL i501_azf03_desc()  #TQC-D20042 add
        #FUN-CB0087--add--end--
 
        AFTER FIELD sfsud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfsud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_sfs_t.sfs02 > 0 AND g_sfs_t.sfs02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
#No.TQC-B90236-------add-----------begin
                IF g_sfs[l_ac].sfs26 MATCHES '[BC]' THEN
                   CALL cl_err('','asf1020',0)
                   CANCEL DELETE
                END IF
#No.TQC-B90236-------add-----------end
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_sfs[l_ac].sfs04
                   AND imaacti = "Y"
                
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
 #                   IF NOT s_lotout_del(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,g_sfs[l_ac].sfs04,'DEL') THEN   #No.FUN-860045 #No.TQC-B90236 MARK
                    IF NOT s_lot_del(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,g_sfs[l_ac].sfs04,'DEL') THEN  #No.TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_sfp.sfp01,g_sfs_t.sfs02,
                                     SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF
 #MOD-C10100 --end--
#TQC-C10033 --unmark
 
                #若已有ida/idb存在一併刪
                LET g_cnt = 0 
               #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
                CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                          SELECT COUNT(*) INTO g_cnt FROM idb_file
                           WHERE idb07 = g_sfp.sfp01
                             AND idb08 = g_sfs_t.sfs02
                    #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                     WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                          SELECT COUNT(*) INTO g_cnt FROM ida_file
                           WHERE ida07 = g_sfp.sfp01
                             AND ida08 = g_sfs_t.sfs02
                END CASE
                IF g_cnt > 0 THEN
                   IF NOT cl_confirm('aic-112') THEN
                      CANCEL DELETE
                   ELSE
                     #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
                      CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                           CALL s_icdinout_del(-1,g_sfp.sfp01,g_sfs_t.sfs02,'')  #FUN-B80119--傳入p_plant參數''---
                                RETURNING l_flag
                          #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                           WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                           CALL s_icdinout_del(1,g_sfp.sfp01,g_sfs_t.sfs02,'')   #FUN-B80119--傳入p_plant參數''---
                                RETURNING l_flag
                      END CASE 
                      IF l_flag = 0 THEN ROLLBACK WORK CANCEL DELETE END IF
                   END IF
                END IF
                DELETE FROM sfs_file
                 WHERE sfs01 = g_sfp.sfp01 AND sfs02 = g_sfs_t.sfs02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sfs_file",g_sfp.sfp01,g_sfs_t.sfs02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #FUN-B70061 --START--
                IF NOT s_del_sfsi(g_sfp.sfp01,g_sfs_t.sfs02,'') THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #FUN-B70061 --END--
		COMMIT WORK
                display "commit work before delete"
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sfs[l_ac].* = g_sfs_t.*
               CLOSE i501_bcl
               CLOSE i501_bcl_ind
               DISPLAY "on row change rollback work"
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #若已有ida/idb存在不可修改
            IF cl_null(g_sfs_t.sfs08) THEN LET g_sfs_t.sfs08 = ' ' END IF
            IF cl_null(g_sfs_t.sfs09) THEN LET g_sfs_t.sfs09 = ' ' END IF
            IF cl_null(g_sfs[l_ac].sfs08) THEN
               LET g_sfs[l_ac].sfs08 = ' '
            END IF
            IF cl_null(g_sfs[l_ac].sfs09) THEN
               LET g_sfs[l_ac].sfs09 = ' '
            END IF
            IF g_sfs_t.sfs02 <> g_sfs[l_ac].sfs02 OR
               g_sfs_t.sfs04 <> g_sfs[l_ac].sfs04 OR
               g_sfs_t.sfs06 <> g_sfs[l_ac].sfs06 OR
               g_sfs_t.sfs07 <> g_sfs[l_ac].sfs07 OR
               g_sfs_t.sfs08 <> g_sfs[l_ac].sfs08 OR 
               g_sfs_t.sfs09 <> g_sfs[l_ac].sfs09 THEN
               CALL i501_ind_icd_chk_icd()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD sfs02
               END IF
            END IF 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfs[l_ac].sfs02,-263,1)
               LET g_sfs[l_ac].* = g_sfs_t.*
            ELSE
             LET l_cnt=0
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01 = g_sfs[l_ac].sfs04   #料號
                 AND img02 = g_sfs[l_ac].sfs07   #倉庫
                 AND img03 = g_sfs[l_ac].sfs08   #儲位
                 AND img04 = g_sfs[l_ac].sfs09   #批號
                 AND  img18 < g_sfp.sfp03        #過帳日   #MOD-870247 
              IF g_cnt > 0 THEN    #大於有效日期
                 call cl_err('','aim-400',0)   #須修改
                 NEXT FIELD sfs07
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_sfs[l_ac].sfs04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD sfs04
                 END IF
 
                 CALL i501_du_data_to_correct()
                 CALL i501_set_origin_field()
                 IF NOT (g_sfp.sfp06 MATCHES '[ABC]') THEN #FUN-5C0114
                  #計算sfs05的值,檢查入庫數量的合理性
                    CALL i501_check_inventory_qty()
                        RETURNING g_flag
                    IF g_flag = '1' THEN
                       IF g_ima906 = '2' OR g_ima906 = '3' THEN
                          NEXT FIELD sfs35
                       ELSE
                          NEXT FIELD sfs32
                       END IF
                    END IF
                    IF g_flag = '2' THEN
                       IF g_ima906 = '2' OR g_ima906 = '3' THEN
                          NEXT FIELD sfs33
                       ELSE
                          NEXT FIELD sfs30
                       END IF
                    END IF
                 END IF
              END IF
              IF NOT i501_sfs37_check() THEN NEXT FIELD sfs37 END IF  #FUN-CB0087 add
              
               CALL i501_b_move_back()
               CALL i501_b_else()
               #料號為參考單位,單一單位,且狀態不為wafer(imaicd04<>0,1,2)時,
               #將單位一的資料給單位二
               CALL i501_ind_icd_set_value()
               IF NOT cl_null(l_sfa27_a) THEN
                  SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
                   WHERE sfa01=g_sfs[l_ac].sfs03
                     AND sfa03=g_sfs[l_ac].sfs04
                     AND sfa12=g_sfs[l_ac].sfs06
                     AND sfa08=g_sfs[l_ac].sfs10
                     AND sfa012=g_sfs[l_ac].sfs012   #FUN-A60028 
                     AND sfa013=g_sfs[l_ac].sfs013   #FUN-A60028
                   LET b_sfs.sfs27=l_sfa27_a
               END IF
               IF cl_null(b_sfs.sfs27) THEN LET b_sfs.sfs27=b_sfs.sfs04 END IF  #No.MOD-8B0086 add
              IF cl_null(b_sfs.sfs28) THEN
                 SELECT sfa28 INTO b_sfs.sfs28
                   FROM sfa_file
                  WHERE sfa01 = b_sfs.sfs03 
                    AND sfa03 = b_sfs.sfs04
                    AND sfa08 = b_sfs.sfs10
                    AND sfa12 = b_sfs.sfs06
                    AND sfa27 = b_sfs.sfs27
                    AND sfa012= b_sfs.sfs012  #FUN-A60028 
                    AND sfa013= b_sfs.sfs013  #FUN-A60028                    
              END IF
               UPDATE sfs_file SET * = b_sfs.*
                WHERE sfs01=g_sfp.sfp01 AND sfs02=g_sfs_t.sfs02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sfs_file",g_sfp.sfp01,g_sfs_t.sfs02,SQLCA.sqlcode,"","upd sfs",1)  #No.FUN-660128
                  LET g_sfs[l_ac].* = g_sfs_t.*
                  ROLLBACK WORK
               ELSE
               #FUN-B70061 --START--
                  UPDATE sfsi_file SET * = b_sfsi.*
                   WHERE sfsi01=g_sfp.sfp01 AND sfsi02=g_sfs_t.sfs02
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sfsi_file",g_sfp.sfp01,g_sfs_t.sfs02,SQLCA.sqlcode,"","upd sfsi",1)
                  LET g_sfs[l_ac].* = g_sfs_t.*
                  ROLLBACK WORK  
               ELSE    
               #FUN-B70061 --END--
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
                display "commit work on row change"
               END IF
               SELECT SUM(sfs05) INTO g_sfs[l_ac].img10_alo FROM sfs_file,sfp_file                                                  
                WHERE sfs04=g_sfs[l_ac].sfs04                                                                                       
                  AND sfs07=g_sfs[l_ac].sfs07                                                                                       
                  AND sfs08=g_sfs[l_ac].sfs08                                                                                       
                  AND sfs09=g_sfs[l_ac].sfs09                                                                                       
                  AND sfp01=sfs01 AND sfpconf!='X'                                                                                  
                  AND sfs01 != g_sfp.sfp01    #MOD-A80031 add
               DISPLAY BY NAME g_sfs[l_ac].img10_alo                                                                                
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark    
            DISPLAY "after row int_flag before"
            IF INT_FLAG THEN
               DISPLAY "after row int_flag after"
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              IF p_cmd='a' AND l_ac <= g_sfs.getLength() THEN   #CHI-C30106 add
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_sfs[l_ac].sfs04
                  AND imaacti = "Y"
               
#TQC-C10033 --unmark
  #MOD-C10100 --begin--
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
  #                  IF NOT s_lotout_del(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,g_sfs[l_ac].sfs04,'DEL') THEN   #No.FUN-860045 #No.TQC-B90236 MARK
                    IF NOT s_lot_del(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,g_sfs[l_ac].sfs04,'DEL') THEN  #No.TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_sfp.sfp01,g_sfs_t.sfs02,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
              END IF  #CHI-C30106 add
  #MOD-C10100 --end--
#TQC-C10033 --unmark

               IF p_cmd='u' THEN
                  LET g_sfs[l_ac].* = g_sfs_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sfs.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end-- 
               END IF
               CLOSE i501_bcl
               CLOSE i501_bcl_ind
               DISPLAY "after row rollback work"
               ROLLBACK WORK
               DISPLAY "after row rollback work"
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            IF NOT i501_sfs37_check() THEN NEXT FIELD sfs37 END IF  #FUN-CB0087 add
           #CHI-BC0040 str--------
           #SELECT (sfa05-sfa065),sfa06   #FUN-B50059
           #   INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06
           #   FROM sfs_file #LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs04=sfa03 AND sfs06=sfa12 AND sfs10=sfa08 AND sfs27=sfa27 #09/10/21 xiaofeizhu Add  #MOD-BB0307 Mark
           #                 #                       AND sfs012=sfa012 AND sfs013=sfa013  #FUN-A60095                   #MOD-BB0307 Mark
           #                 LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs06=sfa12 AND sfs10=sfa08 AND sfs012=sfa012  #MOD-BB0307 Add
           #                           AND sfs013=sfa013 AND sfs27=sfa03                                                #MOD-BB0307 Add
           #                 LEFT OUTER JOIN img_file ON sfs04=img01 AND sfs07=img02 AND sfs08=img03 AND sfs09=img04                 #09/10/21 xiaofeizhu Add
           #                 LEFT OUTER JOIN ima_file ON sfs04=ima01                                                                 #09/10/21 xiaofeizhu Add
           #  WHERE sfs01 = g_sfp.sfp01 AND sfs02 = g_sfs[l_ac].sfs02
           LET l_flag1 =0
           SELECT COUNT(*) INTO l_flag1 FROM sfa_file WHERE sfa03=g_sfs[l_ac].sfs04  AND sfa27=g_sfs[l_ac].sfs27
           IF l_flag1>0 THEN
            SELECT (sfa05-sfa065),sfa06   #FUN-B50059
               INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06
               FROM sfs_file
               LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs04=sfa03 AND sfs06=sfa12 AND sfs10=sfa08 AND sfs27=sfa27
                                                       AND sfs012=sfa012 AND sfs013=sfa013
               LEFT OUTER JOIN img_file ON sfs04=img01 AND sfs07=img02 AND sfs08=img03 AND sfs09=img04
               LEFT OUTER JOIN ima_file ON sfs04=ima01
               WHERE sfs01 = g_sfp.sfp01 AND sfs02 = g_sfs[l_ac].sfs02
           ELSE
            SELECT (sfa05-sfa065),sfa06
               INTO g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06
               FROM sfs_file
               LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs06=sfa12 AND sfs10=sfa08 AND sfs012=sfa012
                                                       AND sfs013=sfa013 AND sfs27=sfa03
               LEFT OUTER JOIN img_file ON sfs04=img01 AND sfs07=img02 AND sfs08=img03 AND sfs09=img04
               LEFT OUTER JOIN ima_file ON sfs04=ima01
               WHERE sfs01 = g_sfp.sfp01 AND sfs02 = g_sfs[l_ac].sfs02
           END IF
           #CHI-BC0040 end------------
 
             #計算欠料量g_short_qty(原g_sfa07)
              IF cl_null(g_sfs[l_ac].sfs012) THEN LET g_sfs[l_ac].sfs012=' ' END IF #TQC-CB0084 add 
              IF cl_null(g_sfs[l_ac].sfs013) THEN LET g_sfs[l_ac].sfs013= 0  END IF #TQC-CB0084 add 
              CALL s_shortqty(g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs10,
                              g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs27,
                             #g_sfs012,g_sfs013)   #FUN-A50066 add    #MOD-CB0154 mark
                              g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)  #MOD-CB0154
                   RETURNING g_short_qty
              IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
           
            IF g_sfp.sfp06='3' THEN
               LET g_sfs[l_ac].sfa05=g_short_qty
               LET g_sfs[l_ac].sfa06=0
            END IF
            IF g_sfp.sfp06 MATCHES '[6789]' THEN   
               IF g_sfs[l_ac].sfa05<0  THEN
                  LET g_sfs[l_ac].sfa05=g_sfs[l_ac].sfa05*(-1)
                  LET g_sfs[l_ac].sfa06=g_sfs[l_ac].sfa06*(-1)
               END IF
            END IF
            LET g_sfs[l_ac].short_qty = g_short_qty 
            DISPLAY BY NAME g_sfs[l_ac].sfa05,g_sfs[l_ac].sfa06,g_sfs[l_ac].sfs28,           #CHI-BC0040 add g_sfs[l_ac].sfs28
                            g_sfs[l_ac].short_qty     
            
            CLOSE i501_bcl
            CLOSE i501_bcl_ind
            COMMIT WORK
                display "commit work after row"
 
           #CALL g_sfs.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
            CALL g_sfs.deleteElement(g_rec_b+1)   #MOD-D60165 add 

         ON ACTION aic_s_icdqry #"單據刻號BIN查詢作業"
            IF NOT cl_null(g_sfs[l_ac].sfs02) THEN
              #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark
               CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                         CALL s_icdqry(-1,g_sfp.sfp01,g_sfs[l_ac].sfs02,
                                       g_sfp.sfp04,g_sfs[l_ac].sfs04)
                   #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                    WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                         CALL s_icdqry(1,g_sfp.sfp01,g_sfs[l_ac].sfs02,
                                       g_sfp.sfp04,g_sfs[l_ac].sfs04)
               END CASE
            END IF
 
       #CHI-C30106---add---S---
        AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM sfs_file WHERE sfs01=g_sfp.sfp01
          FOR l_c=1 TO g_cnt
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_sfs[l_c].sfs04
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             UPDATE rvbs_file SET rvbs021=g_sfs[l_c].sfs04
              WHERE rvbs00=g_prog
                AND rvbs01=g_sfp.sfp01
                AND rvbs02=g_sfs[l_c].sfs02
             END IF
          END FOR
       #CHI-C30106---add---E--- 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sfs02) AND l_ac > 1 THEN
                LET g_sfs[l_ac].sfs03=g_sfs[l_ac-1].sfs03
                LET g_sfs[l_ac].sfs04=g_sfs[l_ac-1].sfs04
                LET g_sfs[l_ac].sfs06=g_sfs[l_ac-1].sfs06
                LET g_sfs[l_ac].sfs07=g_sfs[l_ac-1].sfs07
                LET g_sfs[l_ac].sfs08=g_sfs[l_ac-1].sfs08
                LET g_sfs[l_ac].sfs09=g_sfs[l_ac-1].sfs09
                LET g_sfs[l_ac].sfs10=g_sfs[l_ac-1].sfs10
                NEXT FIELD sfs02
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(sfs04)
                    #g_argv2   1:成套發料 2:超領   3:欠/補料   4.領料
                    #          6.工單成套退料單維護作業
                    #          7.工單超領退料單維護作業
                    #          8.工單一般退料單維護作業
                    #          9.工單領退料維護作業
                    #---------No.MOD-780002 modify
                #單身選擇取替代時，料號開窗出來的應該是在abmi600中維護好的料號
                 IF NOT cl_null(g_sfs[l_ac].sfs03) AND g_sfs[l_ac].sfs26 MATCHES '[US]' THEN   
                    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_sfs[l_ac].sfs03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_bmd1"
                   # LET g_qryparam.arg1 = l_sfb05              #CHI-BA0016 mark
                    LET g_qryparam.arg1 = g_sfs[l_ac].sfs03     #CHI-BA0016 add
                    IF g_sfs[l_ac].sfs26 = 'U' THEN   #取代
                       LET g_qryparam.arg2 = '1'
                    END IF
                    IF g_sfs[l_ac].sfs26 = 'S' THEN   #替代
                       LET g_qryparam.arg2 = '2'
                    END IF
                    LET g_qryparam.arg3 = g_sfs[l_ac].sfs27  #CHI-C30089
                    CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04
                    DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                    NEXT FIELD sfs04
#FUN-A40058 --begin--
                 ELSE IF NOT cl_null(g_sfs[l_ac].sfs03) AND g_sfs[l_ac].sfs26 MATCHES '[Z]' THEN   
                    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_sfs[l_ac].sfs03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_bon09"
                    LET g_qryparam.arg1 = l_sfb05
                    CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04
                    DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                    NEXT FIELD sfs04
#FUN-A40058 --end--
                 ELSE
	             CASE WHEN g_argv2 MATCHES '[136]'
                               LET li_where = " AND sfa01 IN (SELECT sfq02 FROM sfq_file WHERE sfq01 = '",g_sfp.sfp01,"') "
                               IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                               #  LET li_where = " AND sfa26 = '",g_sfs[l_ac].sfs26,"' " #FUN-A40058  
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_sfs[l_ac].sfs26,"' " #FUN-A40058  
                               ELSE
                               #  LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'  #FUN-A40058 
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'  #FUN-A40058 
                               END IF
                               IF g_argv2 = 3 THEN
                                  CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'1') 
                                       RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,l_sfa27_tmp
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 add
                               ELSE
                                  CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'4') 
                                       RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,l_sfa27_tmp
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 add                                       
                               END IF
              #FUN-A60028 --begin--     
                               LET g_sfs[l_ac].sfs10 = l_sfa08_tmp               
                               LET g_sfs[l_ac].sfs06 = l_sfa12_tmp                                      
                               LET g_sfs[l_ac].sfs27 = l_sfa27_tmp                            
                               IF cl_null(g_sfs[l_ac].sfs012) THEN 
                                  LET g_sfs[l_ac].sfs012 = ' '
                               END IF 
                               IF cl_null(g_sfs[l_ac].sfs013) THEN 
                                  LET g_sfs[l_ac].sfs013 = 0
                               END IF 
                               DISPLAY g_sfs[l_ac].sfs012 TO sfs012
                               DISPLAY g_sfs[l_ac].sfs013 TO sfs013
                               DISPLAY g_sfs[l_ac].sfs27 TO sfs27
                               DISPLAY g_sfs[l_ac].sfs06 TO sfs06                               
                               DISPLAY g_sfs[l_ac].sfs10 TO sfs10                                   
              #FUN-A60028 --end--
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                               NEXT FIELD sfs04
                          WHEN g_argv2 MATCHES '[24789]'           #MOD-C30910 add 9
                               CALL cl_init_qry_var()
                               LET g_qryparam.form ="q_sfa1"
                               LET g_qryparam.arg1 =g_sfs[l_ac].sfs03
                               LET g_qryparam.default2 = g_sfs[l_ac].sfs27
                               LET g_qryparam.default3 = b_sfs.sfs28
                               IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                                  LET g_qryparam.where = " sfa26 = '",g_sfs[l_ac].sfs26,"' " 
                               ELSE
                                  LET g_qryparam.where = " sfa26 IN ('0','1','2','3','4','5','6','7','8','S','U','T','Z') "   #FUN-A20037 add '7,8'  #MOD-C40028 add,'S','U','T','Z'
                               END IF
                               #FUN-B80143 --START--
                               IF g_sfp.sfp06 = '7' THEN
                                  LET g_qryparam.where = g_qryparam.where CLIPPED, " AND sfa062 > 0 "
                               END IF 
                               #FUN-B80143 --END--
                               LET g_qryparam.default1 = g_sfs[l_ac].sfs04
                              #CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs27,b_sfs.sfs28  #FUN-940039 add   #MOD-C40028 mark
                               CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs27,b_sfs.sfs28,g_sfs[l_ac].sfs26  #MOD-C40028 add
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                               DISPLAY g_sfs[l_ac].sfs27 TO sfs27   #FUN-940039 add
                               IF g_sfs[l_ac].sfs26 MATCHES '[USTZ]' THEN      #MOD-C40028 add
                                 DISPLAY g_sfs[l_ac].sfs26 TO sfs26            #MOD-C40028 add
                               ELSE                                            #MOD-CA0045 add
                                 LET g_sfs[l_ac].sfs26 = ''                    #MOD-CA0045 add
                               END IF                                          #MOD-C40028 add
                          WHEN g_argv2 MATCHES '[ABC]'
                               CALL cl_init_qry_var()
                               LET g_qryparam.form ="q_bmb303"
                               LET g_qryparam.arg1 = g_sfs[l_ac].sfs03
                               LET g_qryparam.arg2 = g_sfp.sfp03
                               CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                               NEXT FIELD sfs04
                     OTHERWISE
#FUN-AA0059---------mod------------str-----------------
#                              CALL cl_init_qry_var()
#                              LET g_qryparam.form ="q_ima"
#                              LET g_qryparam.default1 = g_sfs[l_ac].sfs04
#                              CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04
                               CALL q_sel_ima(FALSE, "q_ima","",g_sfs[l_ac].sfs04,"","","","","",'' ) 
                                  RETURNING g_sfs[l_ac].sfs04  
#FUN-AA0059---------mod------------end-----------------
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                               NEXT FIELD sfs04
                     END CASE
                END IF        #No.MOD-930195 add     
          END IF           #FUN-A40058
                WHEN INFIELD(sfs03)
	             #CASE WHEN g_argv2 MATCHES '[13]'
                  CASE WHEN g_argv2 MATCHES '[13D]'   #TQC-CA0045 add D
                               LET li_where = " AND sfa01 IN (SELECT sfq02 FROM sfq_file WHERE sfq01 = '",g_sfp.sfp01,"') "
                               ##組合拆解的工單不顯示出來!
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                              #   LET li_where = " AND sfa26 = '",g_sfs[l_ac].sfs26,"' "                    #FUN-A40058 mark
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_sfs[l_ac].sfs26,"' "   #FUN-A40058 
                               ELSE
                              #   LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A20037 add '7,8'   #FUN-A40058
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A40058
                               END IF
                               #TQC-CA0045 add begin--------------------
                               IF g_argv2 = 'D' AND NOT cl_null(g_sfs[l_ac].sfs014) THEN 
                                  LET li_where = li_where CLIPPED," AND sfb01 IN (SELECT shm012 FROM shm_file WHERE shm01='",g_sfs[l_ac].sfs014,"') "
                               END IF 
                               #TQC-CA0045 add end----------------------
                               IF g_argv2 = '3' THEN
                                  CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'1') 
                                       RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,g_sfs[l_ac].sfs27
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 ADD
                               ELSE
                                  CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'4') 
                                       RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,g_sfs[l_ac].sfs27
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 ADD                                       
                               END IF 
 
                               DISPLAY g_sfs[l_ac].sfs27 TO sfs27
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04
#FUN-A60028 --begin--                               
                               IF cl_null(g_sfs[l_ac].sfs012) THEN 
                                  LET g_sfs[l_ac].sfs012 = ' '
                               END IF 
                               IF cl_null(g_sfs[l_ac].sfs013) THEN 
                                  LET g_sfs[l_ac].sfs012 = 0
                               END IF                                
                               DISPLAY g_sfs[l_ac].sfs012 TO sfs012   
                               DISPLAY g_sfs[l_ac].sfs013 TO sfs013   
#FUN-A60028 --end--
                               NEXT FIELD sfs03
	                  WHEN g_argv2 MATCHES '[2]'
                               LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') "
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                              #   LET li_where = " AND sfa26 = '",g_sfs[l_ac].sfs26,"' "                                        #TQC-A30112
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_sfs[l_ac].sfs26,"' "                       #TQC-A30112
                               ELSE
                              #   LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A20037 add '7,8'  #TQC-A30112
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "        #TQC-A30112
                               END IF
                               CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'4') 
                                    RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,g_sfs[l_ac].sfs27
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 ADD                                    
                               DISPLAY g_sfs[l_ac].sfs27 TO sfs27
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04

#FUN-A60028 --begin--                               
                               IF cl_null(g_sfs[l_ac].sfs012) THEN 
                                  LET g_sfs[l_ac].sfs012 = ' '
                               END IF 
                               IF cl_null(g_sfs[l_ac].sfs013) THEN 
                                  LET g_sfs[l_ac].sfs012 = 0
                               END IF                                
                               DISPLAY g_sfs[l_ac].sfs012 TO sfs012   
                               DISPLAY g_sfs[l_ac].sfs013 TO sfs013   
#FUN-A60028 --end--
                               NEXT FIELD sfs03
                          WHEN g_argv2 MATCHES '[ABC]'
#FUN-AA0059---------mod------------str----------------- 
#                              CALL cl_init_qry_var()
#                              LET g_qryparam.form ="q_ima17" #MOD-630064 
#                              LET g_qryparam.default1 = g_sfs[l_ac].sfs03
#                              CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs03
                               CALL q_sel_ima(FALSE, "q_ima17","",g_sfs[l_ac].sfs03,"","","","","",'' ) 
                                     RETURNING g_sfs[l_ac].sfs03  
#FUN-AA0059---------mod------------end-----------------
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               NEXT FIELD sfs03
                     OTHERWISE
                               LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') "
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               #CHI-C30040---begin
                               IF g_sfp.sfp06 = '4' OR g_sfp.sfp06 = '9' THEN
                                  LET li_where = li_where CLIPPED, " AND sfa11 = 'E' "    
                               END IF 
                               #CHI-C30040---end
                               IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                             #    LET li_where = " AND sfa26 = '",g_sfs[l_ac].sfs26,"' "   #FUN-A40058 
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_sfs[l_ac].sfs26,"' "  #FUN-A40058
                               ELSE
                             #    LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'    #FUN-A40058 MARK
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A40058
                               END IF
                               #FUN-B80143 --START--
                               IF g_sfp.sfp06 = '7' THEN
                                  LET li_where = li_where CLIPPED, " AND sfa062 > 0 "
                               END IF 
                               #FUN-B80143 --END--
                               CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'4') 
                                    RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,g_sfs[l_ac].sfs27
                                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 ADD                                    
                               DISPLAY g_sfs[l_ac].sfs27 TO sfs27
                               DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                               DISPLAY g_sfs[l_ac].sfs04 TO sfs04

#FUN-A60028 --begin--                               
                               IF cl_null(g_sfs[l_ac].sfs012) THEN 
                                  LET g_sfs[l_ac].sfs012 = ' '
                               END IF 
                               IF cl_null(g_sfs[l_ac].sfs013) THEN 
                                  LET g_sfs[l_ac].sfs012 = 0
                               END IF                                
                               DISPLAY g_sfs[l_ac].sfs012 TO sfs012   
                               DISPLAY g_sfs[l_ac].sfs013 TO sfs013   
#FUN-A60028 --end--
                               NEXT FIELD sfs03
                     END CASE
#FUN-A60028 --begin--
                WHEN INFIELD(sfs012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfs012_1"
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs012
                     LET g_qryparam.default2 = g_sfs[l_ac].sfs013
                     LET g_qryparam.arg1     = g_sfs[l_ac].sfs03
                     LET g_qryparam.arg2     = g_sfs[l_ac].sfs04
                     LET g_qryparam.arg3     = g_sfs[l_ac].sfs10     #l_sfa08_tmp
                     LET g_qryparam.arg4     = g_sfs[l_ac].sfs06     # l_sfa12_tmp
                     LET g_qryparam.arg5     = g_sfs[l_ac].sfs27                                                          
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013
                     IF cl_null(g_sfs[l_ac].sfs012) THEN 
                        LET g_sfs[l_ac].sfs012 = ' '
                     END IF 
                     IF cl_null(g_sfs[l_ac].sfs013) THEN 
                        LET g_sfs[l_ac].sfs012 = 0
                     END IF                            
                     DISPLAY BY NAME g_sfs[l_ac].sfs012 
                     DISPLAY BY NAME g_sfs[l_ac].sfs013 
                     NEXT FIELD sfs012                    
                
                WHEN INFIELD(sfs013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfs012_1"
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs012
                     LET g_qryparam.default2 = g_sfs[l_ac].sfs013
                     LET g_qryparam.arg1     = g_sfs[l_ac].sfs03
                     LET g_qryparam.arg2     = g_sfs[l_ac].sfs04
                     LET g_qryparam.arg3     = g_sfs[l_ac].sfs10     #l_sfa08_tmp
                     LET g_qryparam.arg4     = g_sfs[l_ac].sfs06     # l_sfa12_tmp
                     LET g_qryparam.arg5     = g_sfs[l_ac].sfs27                                                                
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013
                     IF cl_null(g_sfs[l_ac].sfs012) THEN 
                        LET g_sfs[l_ac].sfs012 = ' '
                     END IF 
                     IF cl_null(g_sfs[l_ac].sfs013) THEN 
                        LET g_sfs[l_ac].sfs012 = 0
                     END IF                              
                     DISPLAY BY NAME g_sfs[l_ac].sfs012
                     DISPLAY BY NAME g_sfs[l_ac].sfs013 
                     NEXT FIELD sfs013              
#FUN-A60028 --end--                     
                WHEN INFIELD(sfs07) OR INFIELD(sfs08) OR INFIELD(sfs09)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_sfs[l_ac].sfs04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09)
                                  RETURNING g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,'A') #MOD-470509 modify  ##NO.FUN-660085
                       RETURNING g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08,
                                 g_sfs[l_ac].sfs09
                   END IF #FUN-C30300
                     DISPLAY g_sfs[l_ac].sfs07 TO sfs07
                     DISPLAY g_sfs[l_ac].sfs08 TO sfs08
                     DISPLAY g_sfs[l_ac].sfs09 TO sfs09
                     CALL i501_def_sfsiicd029() #FUN-B70061
                     IF INFIELD(sfs07) THEN NEXT FIELD sfs07 END IF
                     IF INFIELD(sfs08) THEN NEXT FIELD sfs08 END IF
                     IF INFIELD(sfs09) THEN NEXT FIELD sfs09 END IF
                WHEN INFIELD(sfs06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs06
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs06
                     DISPLAY g_sfs[l_ac].sfs06 TO sfs06   #MOD-8A0041
                     NEXT FIELD sfs06
                WHEN INFIELD(sfs30) #第一單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs30
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs30
                     DISPLAY BY NAME g_sfs[l_ac].sfs30
                     NEXT FIELD sfs30
 
                WHEN INFIELD(sfs33) #第二單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs33
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs33
                     DISPLAY BY NAME g_sfs[l_ac].sfs33
                     NEXT FIELD sfs33
                WHEN INFIELD(sfs10)
                     CALL cl_init_qry_var()
                     # LET g_qryparam.form ="q_ecd3"  #MOD-4A0262 #TQC-960373 mark
                     LET g_qryparam.form ="q_sfa15"   #TQC-960373 add
                     LET g_qryparam.arg1= g_sfs[l_ac].sfs03  #TQC-960373 add
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs10
                     CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs10
                     DISPLAY "g_sfs[l_ac].sfs10=",g_sfs[l_ac].sfs10
                     DISPLAY g_sfs[l_ac].sfs10 TO sfs10
                     NEXT FIELD sfs10
               WHEN INFIELD(sfs930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs930
                  DISPLAY BY NAME g_sfs[l_ac].sfs930
                  NEXT FIELD sfs930
               WHEN INFIELD(sfs36) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_mse"
                    LET g_qryparam.default1 = g_sfs[l_ac].sfs36
                    CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs36
                    DISPLAY BY NAME g_sfs[l_ac].sfs36
                    NEXT FIELD sfs36  
               #FUN-CB0087--add--str-- 
               WHEN INFIELD(sfs37)      
                  CALL s_get_where(g_sfp.sfp01,g_sfs[l_ac].sfs03,'',g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING l_flag2,l_where
                  IF l_flag2 AND g_aza.aza115 = 'Y' THEN 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs37
                  ELSE
                     CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_azf41"         #CHI-D60012 mark
                     LET g_qryparam.form ="q_azf01a"        #CHI-D60012 add
                    #CHI-D60012-Start 
                     IF g_argv1='1' THEN
                        LET g_qryparam.arg1 = "C"
                     ELSE
                        LET g_qryparam.arg1 = "E"
                     END IF
                    #CHI-D60012-End            
                     LET g_qryparam.default1 = g_sfs[l_ac].sfs37               
                  END IF
                  CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs37 
                  DISPLAY BY NAME g_sfs[l_ac].sfs37 
                  CALL i501_azf03_desc()  #TQC-D20042 add
                  NEXT FIELD sfs37
               #FUN-CB0087--add--end--
               WHEN INFIELD(sfs27)
                 #LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') AND sfa01 = '",g_sfs[l_ac].sfs03,"' AND sfa03 = '",g_sfs[l_ac].sfs04,"' "  #MOD-C40028 mark
                  LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') "  #MOD-C40028 add
                 #MOD-C40028 -- add start -- 
                  IF NOT cl_null(g_sfs[l_ac].sfs03) THEN
                     LET li_where = li_where CLIPPED, " AND sfa01 = '",g_sfs[l_ac].sfs03,"'"
                  END IF                       
                 #MOD-C40028 -- add end --  
                  #FUN-B80143 --START--
                  IF g_sfp.sfp06 = '7' THEN
                     LET li_where = li_where CLIPPED, " AND sfa062 > 0 "
                  END IF 
                  #FUN-B80143 --END--
                  IF NOT cl_null(g_sfs[l_ac].sfs26) THEN 
                 #   LET li_where = " AND sfa26 = '",g_sfs[l_ac].sfs26,"' "                    #FUN-A40058 mark
                     LET li_where = li_where CLIPPED," AND sfa26 = '",g_sfs[l_ac].sfs26,"' "   #FUN-A40058 
                  ELSE
                 #   LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'                   #FUN-A40058
                     LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "     #FUN-A40058 
                  END IF
                  CALL q_short_qty(FALSE,TRUE,g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,li_where,'4') 
                       RETURNING g_sfs[l_ac].sfs03,g_sfs[l_ac].sfs04,l_sfa08_tmp,l_sfa12_tmp,g_sfs[l_ac].sfs27
                                ,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013   #FUN-A60028 add                       
#FUN-A60028 --begin--
                  IF cl_null(g_sfs[l_ac].sfs012) THEN 
                     LET g_sfs[l_ac].sfs012 = ' ' 
                  END IF 
                  IF cl_null(g_sfs[l_ac].sfs013) THEN 
                     LET g_sfs[l_ac].sfs013 = 0
                  END IF 
                  DISPLAY BY NAME g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013
#FUN-A60028 --end--                                
                  DISPLAY g_sfs[l_ac].sfs03 TO sfs03
                  DISPLAY g_sfs[l_ac].sfs04 TO sfs04
                  DISPLAY g_sfs[l_ac].sfs27 TO sfs27
                  #FUN-B70061 --START--
                  WHEN INFIELD(sfsiicd029)
                     CALL q_slot(FALSE,TRUE,g_sfs[l_ac].sfsiicd029,'','')
                         RETURNING g_sfs[l_ac].sfsiicd029
                     DISPLAY BY NAME g_sfs[l_ac].sfsiicd029
                     NEXT FIELD sfsiicd029
                  #FUN-B70061 --END--

#FUN-C70014 add begin----------------------------
              WHEN INFIELD(sfs014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_shm4"
                 IF p_cmd = 'a' THEN
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #CALL i501_multi_ima01()
                    CALL i501_b_fill(' 1=1')
                 ELSE 
                    LET g_qryparam.default1 = g_sfs[l_ac].sfs014
                    CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs014
                    DISPLAY BY NAME g_sfs[l_ac].sfs014
                 END IF 
#FUN-C70014 add end -----------------------------
           END CASE
 
        ON ACTION qry_warehouse
          #Mod No.FUN-AB0018
          #CALL cl_init_qry_var()
          #LET g_qryparam.form ="q_imd"
          #LET g_qryparam.default1 = g_sfs[l_ac].sfs07
          #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
          #CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs07
           CALL q_imd_1(FALSE,TRUE,g_sfs[l_ac].sfs07,"",g_plant,"","")  #只能开当前门店的
                RETURNING g_sfs[l_ac].sfs07
          #End Mod No.FUN-AB0018
           NEXT FIELD sfs07
 
        ON ACTION qry_location
          #Mod No.FUN-AB0018
          #CALL cl_init_qry_var()
          #LET g_qryparam.form ="q_ime"
          #LET g_qryparam.default1 = g_sfs[l_ac].sfs08
          #LET g_qryparam.arg1     = g_sfs[l_ac].sfs07 #倉庫編號 #MOD-4A0063
          #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
          #CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs08
           CALL q_ime_1(FALSE,TRUE,g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs07,"",g_plant,"","","")
                RETURNING g_sfs[l_ac].sfs08
          #End Mod No.FUN-AB0018
           NEXT FIELD sfs08
 
        ON ACTION qry_issue_item
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_sfa1"
           LET g_qryparam.default1 = g_sfs[l_ac].sfs04
           LET g_qryparam.default2 = g_sfs[l_ac].sfs27
           LET g_qryparam.default3 = b_sfs.sfs28
           LET g_qryparam.arg1 = g_sfs[l_ac].sfs03
           CALL cl_create_qry() RETURNING g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs27,b_sfs.sfs28  #FUN-940039 add
           NEXT FIELD sfs04
        ON ACTION qry_more_WH                                                                                                       
           CALL q_img6a(TRUE,TRUE,'','','',g_sfp.sfp01,g_sfp.sfp06,g_sfs[l_ac].sfs02,g_sfs[l_ac].sfs03,
                        g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs10,
                        g_sfs[l_ac].sfs26,g_sfs[l_ac].sfa05,
                        g_sfs[l_ac].sfs27,g_sfs[l_ac].sfs28,g_sfs[l_ac].sfs012,g_sfs[l_ac].sfs013)            #MOD-D60001 add sfs27,sfs28
           CALL i501_b_fill(" 1=1") 
 
        ON ACTION qry_short_item
           CALL i501_t()
           NEXT FIELD sfs04
 
        ON ACTION regen_detail
           #若已有ida/idb詢問且一併刪
           LET g_cnt = 0 
          #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark 
           CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                     SELECT COUNT(*) INTO g_cnt FROM idb_file
                      WHERE idb07 = g_sfp.sfp01
               #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                     SELECT COUNT(*) INTO g_cnt FROM ida_file
                      WHERE ida07 = g_sfp.sfp01
           END CASE
           IF g_cnt > 0 THEN
              #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作?
              IF cl_confirm('aic-112') THEN
                #CASE WHEN g_sfp.sfp06 = '1' #CHI-A70060 mark 
                 CASE WHEN g_sfp.sfp06 MATCHES '[1234]' #CHI-A70060 
                           CALL s_icdinout_del(-1,g_sfp.sfp01,'','')  #FUN-B80119--傳入p_plant參數''---
                                RETURNING l_flag
                     #WHEN g_sfp.sfp06 = '6' #CHI-A70060 mark
                      WHEN g_sfp.sfp06 MATCHES '[6789]' #CHI-A70060 
                           CALL s_icdinout_del(1,g_sfp.sfp01,'','')   #FUN-B80119--傳入p_plant參數''---
                                RETURNING l_flag
                 END CASE
                 IF l_flag = 1 THEN 
                    CALL i501_g_b()
                    CALL i501_b_fill(" 1=1")
                    CALL i501_b()   #TQC-9C0048
                    COMMIT WORK
                    LET g_errno='genb'
                    EXIT INPUT
                 END IF
              END IF
           ELSE
              CALL i501_g_b()
              CALL i501_b_fill(" 1=1")
              CALL i501_b()   #TQC-9C0048
              COMMIT WORK
              LET g_errno='genb'
              EXIT INPUT
           END IF
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfs[l_ac].sfs04
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
               IF cl_null(g_sfs[l_ac].sfs08) THEN
                  LET g_sfs[l_ac].sfs08 = ' '
               END IF
              SELECT img09 INTO g_img09
                FROM img_file
               WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                 AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
              CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09) 
                   RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
              IF g_sfp.sfp06 MATCHES '[6789B]' THEN
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
                  CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0,  #No.TQC-B90236 Modify s_lotout->s_mod_lot
                                g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                                g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                                g_sfs[l_ac].sfs06,g_img09,l_fac,
                                g_sfs[l_ac].sfs05,'','SEL',1)#CHI-9A0022 add '' #No.TQC-B90236 add 1
                        RETURNING l_r,g_qty 
 #MOD-C10100 --end--
#TQC-C10033 --unmark
              ELSE
#No.CHI-9A0022 --Begin
                 LET l_bno = ''
                 SELECT sfb27
                   INTO l_bno
                   FROM sfb_file
                  WHERE sfb01 = g_sfs[l_ac].sfs03
                 IF cl_null(l_bno) THEN
                    LET l_bno = g_sfs[l_ac].sfs03
                 END IF
#No.CHI-9A0022 --End
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
                 CALL s_mod_lot(g_prog,g_sfp.sfp01,g_sfs[l_ac].sfs02,0, #No.TQC-B90236 Modify s_lotout->s_mod_lot
                               g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                               g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09,
                               g_sfs[l_ac].sfs06,g_img09,l_fac,
                               g_sfs[l_ac].sfs05,l_bno,'MOD',-1)#CHI-9A0022 add l_bno #No.TQC-B90236 add -1
                       RETURNING l_r,g_qty 
 #MOD-C10100 --end--
#TQC-C10033 --unmark
              END IF
              IF l_r = "Y" THEN
                 LET g_sfs[l_ac].sfs05 = g_qty
              END IF
           END IF
#No.TQC-B90236--------------add----begin 配方替代
        ON ACTION formula_alternative 
           SELECT COUNT(*) INTO l_n FROM bmd_file WHERE bmd01 = g_sfs[l_ac].sfs27 AND bmd02 = '3'
           LET l_replace = 'N'  #TQC-C30028 add
           IF l_n > 0 THEN
              SELECT SUM(sfs05) INTO l_sum_sfs05 FROM sfs_file
               WHERE sfs01 = g_sfp.sfp01
                 AND sfs03 = g_sfs[l_ac].sfs03
                 AND sfs27 = g_sfs[l_ac].sfs27
                 AND sfs10 = g_sfs[l_ac].sfs10
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
              CALL i501_replace_item_no(g_sfs[l_ac].sfs27,g_sfs[l_ac].sfs03,
                                        g_sfs[l_ac].sfs10,l_sum_sfs05,g_sfs[l_ac].sfs06)
              LET l_replace = 'Y'   #TQC-C20575 add  #TQC-C30028 modify
              EXIT INPUT            #TQC-C30028 add
 #MOD-C10100 --end--
#TQC-C10033 --unmark
           END IF 
#No.TQC-B90236--------------add----end  配方替代
 
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
 
    END INPUT
 
    LET g_sfp.sfp15 = '0'                       #FUN-AB0001 add
    UPDATE sfp_file SET sfpmodu=g_sfp.sfpmodu,  #NO:6908
                        sfpdate=g_sfp.sfpdate
                       ,sfp15=g_sfp.sfp15       #FUN-AB0001 add
     WHERE sfp01=g_sfp.sfp01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","sfp_file",g_sfp.sfp01,"",SQLCA.sqlcode,"","upd sfpmodu",1)  #No.FUN-660128
       LET g_sfp.sfpmodu=g_sfp_t.sfpmodu
       LET g_sfp.sfpdate=g_sfp_t.sfpdate
       DISPLAY BY NAME g_sfp.sfpmodu
       DISPLAY BY NAME g_sfp.sfpdate
    END IF
    DISPLAY BY NAME g_sfp.sfpmodu,g_sfp.sfpdate,g_sfp.sfp15    #FUN-AB0001 add 

    CALL i501_delHeader()  #CHI-D50037
    #CHI-D50037---begin
    #SELECT COUNT(*) INTO g_cnt FROM sfs_file WHERE sfs01=g_sfp.sfp01
    #IF g_cnt=0 THEN 			# 未輸入單身資料, 則取消單頭資料 
    #   IF cl_confirm('9042') THEN
    #      DELETE FROM sfp_file WHERE sfp01 = g_sfp.sfp01
    #      DELETE FROM sfq_file WHERE sfq01 = g_sfp.sfp01
    #      IF g_sfp.sfp06 = '4' THEN
    #         LET l_cnt=0
    #         SELECT COUNT(*) INTO l_cnt FROM sfu_file
    #          WHERE sfu09 = g_sfp.sfp01
    #         IF l_cnt > 0 THEN
    #            UPDATE sfu_file SET sfu09 = NULL
    #             WHERE sfu09 = g_sfp.sfp01
    #            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
    #               CALL cl_err3("upd","sfu_file",g_sfp.sfp01,"",STATUS,"","upd sfu",1)  #No.FUN-660128
    #            END IF
    #         END IF
    #         # 當有耗材產生時,應將apmt730之耗材單號清為NULL                                                     
    #         LET l_cnt = 0                                                                                                            
    #         SELECT COUNT(*) INTO l_cnt FROM rvu_file                                                                                 
    #          WHERE rvu16 = g_sfp.sfp01                                                                                               
    #         IF l_cnt > 0 THEN                                                                                                        
    #            UPDATE rvu_file SET rvu16 = NULL                                                                                      
    #             WHERE rvu16 = g_sfp.sfp01                                                                                            
    #            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                  
    #               CALL cl_err3("upd","rvu_file",g_sfp.sfp01,"",STATUS,"","upd rvu",1)                                                
    #            END IF                                                                                                                
    #         END IF                                                                                                                   
    #      END IF
    #      LET g_cnt=0
    #      CLEAR FORM
    #      CALL g_sfq.clear()
    #      CALL g_sfs.clear()
    #      INITIALIZE g_sfp.* TO NULL    #TQC-C40150
    #   END IF
    #END IF
    #CHI-D50037---end
 
   #IF g_cnt>0 AND g_smy.smydmy4='Y' THEN                         #FUN-AB0001 mark         
   #FUN-AB0001 add str-------------------
    IF g_cnt>0 AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y'THEN  #單據需自動確認且不需簽核
       LET g_action_choice = "insert"
   #FUN-AB0001 add end-------------------
       CALL i501sub_y_chk(g_sfp.sfp01,g_action_choice)  #TQC-C60079
       IF g_success = "Y" THEN
          CALL i501sub_y_upd(g_sfp.sfp01,g_action_choice,FALSE)   
            RETURNING g_sfp.*
          DISPLAY BY NAME g_sfp.sfpconf  
          IF g_sfp.sfpconf='X' THEN
             LET g_chr='Y' 
          ELSE 
             LET g_chr='N' 
          END IF  
          CALL i501_pic() #圖形顯示  
       END IF
    END IF
 
    IF g_cnt>0 THEN
       IF g_sfs.getlength()>g_cnt THEN
          WHILE g_sfs.getlength()>g_cnt
             CALL g_sfs.deleteElement(g_sfs.getlength())
          END WHILE
       END IF
    END IF
    CALL i501_show() #FUN-AB0001 add
#TQC-C30028 ----- add ----- begin
    IF l_replace = 'Y' THEN
       CALL i501_b()
    END IF
#TQC-C30028 ----- add ----- end
END FUNCTION

#FUN-B20079 jan (S)
FUNCTION i501_chk_sfs()
DEFINE l_cnt   LIKE type_file.num5

   LET g_errno=''
   LET l_cnt= 0
   IF g_sma.sma541 = 'N' THEN 
      LET g_sfs[l_ac].sfs012=' '
      LET g_sfs[l_ac].sfs013=0
   END IF
   IF NOT cl_null(g_sfs[l_ac].sfs03) AND    #TQC-B60091
      NOT cl_null(g_sfs[l_ac].sfs10) AND NOT cl_null(g_sfs[l_ac].sfs06) AND 
      NOT cl_null(g_sfs[l_ac].sfs27) AND g_sfs[l_ac].sfs012 IS NOT NULL AND
      NOT cl_null(g_sfs[l_ac].sfs013) THEN
      SELECT COUNT(*) INTO l_cnt FROM sfa_file
       WHERE sfa01 =g_sfs[l_ac].sfs03
        #AND sfa03 =g_sfs[l_ac].sfs04  #TQC-B60091
         AND sfa08 =g_sfs[l_ac].sfs10 
         AND sfa12 =g_sfs[l_ac].sfs06
        #AND sfa27 =g_sfs[l_ac].sfs27  #TQC-B60091
         AND sfa03 =g_sfs[l_ac].sfs27  #TQC-B60091
         AND sfa012=g_sfs[l_ac].sfs012
         AND sfa013=g_sfs[l_ac].sfs013
      IF l_cnt = 0 THEN
         LET g_errno='aic-036'
      END IF
   END IF
END FUNCTION
#FUN-B20079 jan (E)
 
FUNCTION i501_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' OR p_cmd = 'u' THEN
      CALL cl_set_comp_entry("sfs26,sfs27",TRUE)     #TQC-C70050 add sfs27
   END IF
 
   CALL cl_set_comp_entry("sfs31,sfs33,sfs34,sfs35",TRUE)  #No.FUN-560016
   #FUN-B70061 --START--
   IF NOT  g_argv1 MATCHES '[1]' THEN   #出庫
      CALL cl_set_comp_entry("sfsiicd028,sfsiicd029",TRUE)   
   END IF 
   #FUN-B70061 --END--   
 
END FUNCTION
 
FUNCTION i501_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061 #FUN-BA0058 mark
 
   IF g_sma.sma107='N' THEN
      CALL cl_set_comp_entry("sfs26,sfs27",FALSE)     #TQC-C70050 add sfs27
   ELSE 
      #TQC-C70050--add--str--
      IF g_rec_b <> 0 THEN     
         IF cl_null(g_sfs[l_ac].sfs26)  THEN
            CALL cl_set_comp_entry("sfs27",FALSE)
         END IF
      END IF
      #TQC-C70050--add--end--
   END IF
 
   IF g_ima906 = '1' THEN
    CALL cl_set_comp_entry("sfs33,sfs34,sfs35",FALSE)
   END IF
 
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("sfs31,sfs34",FALSE)
   END IF
 
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("sfs33",FALSE)
   END IF
 
   #FUN-B70061 --START--
   IF g_argv1 MATCHES '[1]' THEN   #出庫
      CALL cl_set_comp_entry("sfsiicd028,sfsiicd029",FALSE)
   ELSE 
      IF l_ac > 0 THEN
         #FUN-BA058 --START--  
         #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
         #             WHERE imaicd00 = g_sfs[l_ac].sfs04
         #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
         #FUN-BA058 --END--
         IF s_icdbin(g_sfs[l_ac].sfs04) THEN   #FUN-BA0058
            CALL cl_set_comp_entry("sfsiicd028,sfsiicd029",FALSE)
         END IF
         #TQC-C60020---begin
         IF NOT cl_null(g_sfs[l_ac].sfs04) AND g_argv1 = '2' THEN 
            SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
             WHERE imaicd00 = g_sfs[l_ac].sfs04
            IF l_imaicd09 = 'Y' THEN
               CALL cl_set_comp_entry('sfsiicd028',TRUE)
            ELSE
               CALL cl_set_comp_entry('sfsiicd028',FALSE)
            END IF 
         END IF 
         #TQC-C60020---end
      END IF
   END IF     
   #FUN-B70061 --END--
END FUNCTION


FUNCTION i501_b_move_to()
   LET g_sfs[l_ac].sfs02 = b_sfs.sfs02
   LET g_sfs[l_ac].sfs03 = b_sfs.sfs03
   LET g_sfs[l_ac].sfs04 = b_sfs.sfs04
   LET g_sfs[l_ac].sfs27 = b_sfs.sfs27   #FUN-940039 add
   LET g_sfs[l_ac].sfs05 = b_sfs.sfs05
   LET g_sfs[l_ac].sfs06 = b_sfs.sfs06
   LET g_sfs[l_ac].sfs07 = b_sfs.sfs07
   LET g_sfs[l_ac].sfs08 = b_sfs.sfs08
   LET g_sfs[l_ac].sfs09 = b_sfs.sfs09
   LET g_sfs[l_ac].sfs10 = b_sfs.sfs10
   LET g_sfs[l_ac].sfs21 = b_sfs.sfs21
   LET g_sfs[l_ac].sfs26 = b_sfs.sfs26
   LET g_sfs[l_ac].sfs30 = b_sfs.sfs30
   LET g_sfs[l_ac].sfs31 = b_sfs.sfs31
   LET g_sfs[l_ac].sfs32 = b_sfs.sfs32
   LET g_sfs[l_ac].sfs33 = b_sfs.sfs33
   LET g_sfs[l_ac].sfs34 = b_sfs.sfs34
   LET g_sfs[l_ac].sfs35 = b_sfs.sfs35
   LET g_sfs[l_ac].sfs930 = b_sfs.sfs930 #FUN-670103
   LET g_sfs[l_ac].sfs36  = b_sfs.sfs36  #FUN-950088 add
   LET g_sfs[l_ac].sfs37  = b_sfs.sfs37  #FUN-CB0087 add
   LET g_sfs[l_ac].sfsud01 = b_sfs.sfsud01
   LET g_sfs[l_ac].sfsud02 = b_sfs.sfsud02
   LET g_sfs[l_ac].sfsud03 = b_sfs.sfsud03
   LET g_sfs[l_ac].sfsud04 = b_sfs.sfsud04
   LET g_sfs[l_ac].sfsud05 = b_sfs.sfsud05
   LET g_sfs[l_ac].sfsud06 = b_sfs.sfsud06
   LET g_sfs[l_ac].sfsud07 = b_sfs.sfsud07
   LET g_sfs[l_ac].sfsud08 = b_sfs.sfsud08
   LET g_sfs[l_ac].sfsud09 = b_sfs.sfsud09
   LET g_sfs[l_ac].sfsud10 = b_sfs.sfsud10
   LET g_sfs[l_ac].sfsud11 = b_sfs.sfsud11
   LET g_sfs[l_ac].sfsud12 = b_sfs.sfsud12
   LET g_sfs[l_ac].sfsud13 = b_sfs.sfsud13
   LET g_sfs[l_ac].sfsud14 = b_sfs.sfsud14
   LET g_sfs[l_ac].sfsud15 = b_sfs.sfsud15
   LET g_sfs[l_ac].sfsiicd028 = b_sfsi.sfsiicd028 #FUN-B70061
   LET g_sfs[l_ac].sfsiicd029 = b_sfsi.sfsiicd029 #FUN-B70061
END FUNCTION
 
FUNCTION i501_b_move_back()
   LET b_sfs.sfs02 = g_sfs[l_ac].sfs02
   LET b_sfs.sfs03 = g_sfs[l_ac].sfs03
   LET b_sfs.sfs04 = g_sfs[l_ac].sfs04
   LET b_sfs.sfs27 = g_sfs[l_ac].sfs27    #FUN-940039 add
   LET b_sfs.sfs05 = g_sfs[l_ac].sfs05
   LET b_sfs.sfs06 = g_sfs[l_ac].sfs06
   LET b_sfs.sfs07 = g_sfs[l_ac].sfs07
   LET b_sfs.sfs08 = g_sfs[l_ac].sfs08
   LET b_sfs.sfs09 = g_sfs[l_ac].sfs09
   LET b_sfs.sfs10 = g_sfs[l_ac].sfs10
   LET b_sfs.sfs21 = g_sfs[l_ac].sfs21
   LET b_sfs.sfs26 = g_sfs[l_ac].sfs26
   LET b_sfs.sfs28 = g_sfs[l_ac].sfs28    #CHI-BC0040 add
   LET b_sfs.sfs30 = g_sfs[l_ac].sfs30
   LET b_sfs.sfs31 = g_sfs[l_ac].sfs31
   LET b_sfs.sfs32 = g_sfs[l_ac].sfs32
   LET b_sfs.sfs33 = g_sfs[l_ac].sfs33
   LET b_sfs.sfs34 = g_sfs[l_ac].sfs34
   LET b_sfs.sfs35 = g_sfs[l_ac].sfs35
   LET b_sfs.sfs930 = g_sfs[l_ac].sfs930 #FUN-670103
   LET b_sfs.sfs36  = g_sfs[l_ac].sfs36  #FUN-950088 add
   LET b_sfs.sfs37  = g_sfs[l_ac].sfs37  #FUN-CB0087 add
   LET b_sfs.sfsud01 = g_sfs[l_ac].sfsud01
   LET b_sfs.sfsud02 = g_sfs[l_ac].sfsud02
   LET b_sfs.sfsud03 = g_sfs[l_ac].sfsud03
   LET b_sfs.sfsud04 = g_sfs[l_ac].sfsud04
   LET b_sfs.sfsud05 = g_sfs[l_ac].sfsud05
   LET b_sfs.sfsud06 = g_sfs[l_ac].sfsud06
   LET b_sfs.sfsud07 = g_sfs[l_ac].sfsud07
   LET b_sfs.sfsud08 = g_sfs[l_ac].sfsud08
   LET b_sfs.sfsud09 = g_sfs[l_ac].sfsud09
   LET b_sfs.sfsud10 = g_sfs[l_ac].sfsud10
   LET b_sfs.sfsud11 = g_sfs[l_ac].sfsud11
   LET b_sfs.sfsud12 = g_sfs[l_ac].sfsud12
   LET b_sfs.sfsud13 = g_sfs[l_ac].sfsud13
   LET b_sfs.sfsud14 = g_sfs[l_ac].sfsud14
   LET b_sfs.sfsud15 = g_sfs[l_ac].sfsud15
   LET b_sfs.sfsplant = g_plant #FUN-980008 add
   LET b_sfs.sfslegal = g_legal #FUN-980008 add
   LET b_sfsi.sfsiicd028 = g_sfs[l_ac].sfsiicd028 #FUN-B70061
   LET b_sfsi.sfsiicd029 = g_sfs[l_ac].sfsiicd029 #FUN-B70061
END FUNCTION
 

FUNCTION i501_b_else()
   IF g_sfs[l_ac].sfs07 IS NULL THEN LET g_sfs[l_ac].sfs07 =' ' END IF
   IF g_sfs[l_ac].sfs08 IS NULL THEN LET g_sfs[l_ac].sfs08 =' ' END IF
   IF g_sfs[l_ac].sfs09 IS NULL THEN LET g_sfs[l_ac].sfs09 =' ' END IF
#FUN-A60028 --begin--   
   IF g_sfs[l_ac].sfs012 IS NULL THEN LET g_sfs[l_ac].sfs012 =' ' END IF
   IF g_sfs[l_ac].sfs013 IS NULL THEN LET g_sfs[l_ac].sfs013 =0 END IF      
   LET b_sfs.sfs012= g_sfs[l_ac].sfs012
   LET b_sfs.sfs013= g_sfs[l_ac].sfs013
#FUN-A60028 --end--   
   LET b_sfs.sfs07 = g_sfs[l_ac].sfs07    #No:MOD-9C0009 add
   LET b_sfs.sfs08 = g_sfs[l_ac].sfs08    #No:MOD-9C0009 add
   LET b_sfs.sfs09 = g_sfs[l_ac].sfs09    #No:MOD-9C0009 add
END FUNCTION

 
FUNCTION i501_b_askkey()
    DEFINE l_wc2        LIKE type_file.chr1000 
 
    CONSTRUCT l_wc2 ON sfs02,sfs26,sfs03,sfs04,sfs06,sfs10,sfs05
                  FROM s_sfs[1].sfs02, s_sfs[1].sfs26, s_sfs[1].sfs03,
                       s_sfs[1].sfs04, s_sfs[1].sfs06, s_sfs[1].sfs10,
                       s_sfs[1].sfs05

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()

                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL i501_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i501_d_fill(p_wc2)              #BODY FILL UP
 DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(800)
 DEFINE l_ima01 LIKE ima_file.ima01
 
    IF g_sfp.sfp06 MATCHES '[ABC]' THEN
       LET g_sql =
           "SELECT sfq014,sfq02,sfq012,'',sfq04,'','','',sfq05,sfq07,sfq08,sfq03", #No.FUN-870097 add sfq07 #FUN-940008 add sfq08  #FUN-B20095 add sfq012,''  #FUN-C70014 add sfq014
           ",sfqud01,sfqud02,sfqud03,sfqud04,sfqud05,",
           "sfqud06,sfqud07,sfqud08,sfqud09,sfqud10,",
           "sfqud11,sfqud12,sfqud13,sfqud14,sfqud15", 
           " FROM sfq_file WHERE sfq01 ='",g_sfp.sfp01,"' ",
           " ORDER BY sfq02"
    ELSE
       LET g_sql =
           "SELECT sfq014,sfq02,sfq012,'',sfq04,sfb05,'','',sfq05,sfq07,sfq08,sfq03", #No.FUN-870097 add sfq07 #FUN-5C0114 add sfq05 #FUN-940008 add sfq08  #FUN-B20095 add sfq012,'' #FUN-C70014 add sfq014
           ",sfqud01,sfqud02,sfqud03,sfqud04,sfqud05,",
           "sfqud06,sfqud07,sfqud08,sfqud09,sfqud10,",
           "sfqud11,sfqud12,sfqud13,sfqud14,sfqud15", 
           " FROM sfq_file LEFT OUTER JOIN sfb_file ON sfq02 = sfb01 ",                     #09/10/21 xiaofeizhu Add
           " WHERE sfq01 ='",g_sfp.sfp01,"' ",
           " ORDER BY sfq02"                                                                #09/10/21 xiaofeizhu Add
    END IF
    
    PREPARE i501_pd FROM g_sql
    DECLARE sfq_curs CURSOR FOR i501_pd
 
    CALL g_sfq.clear()
 
    LET g_cnt = 1
    LET g_rec_d = 0
 
    FOREACH sfq_curs INTO g_sfq[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF g_sfp.sfp06 MATCHES '[ABC]' THEN
          LET l_ima01=g_sfq[g_cnt].sfq02
       ELSE
          LET l_ima01=g_sfq[g_cnt].sfb05
       END IF
       SELECT ima02,ima021 INTO g_sfq[g_cnt].ima02_a, g_sfq[g_cnt].ima021_a
         FROM ima_file
        WHERE ima01=l_ima01
       CALL s_schdat_ecm014(g_sfq[g_cnt].sfq02,g_sfq[g_cnt].sfq012)    #FUN-B20095
          RETURNING g_sfq[g_cnt].ecm014                                #FUN-B20095
       LET g_cnt = g_cnt + 1
    END FOREACH
 
    IF STATUS THEN CALL cl_err('fore sfq:',STATUS,1) END IF
    CALL g_sfq.deleteElement(g_cnt)
 
    LET g_rec_d = g_cnt - 1
 
    DISPLAY g_rec_d TO FORMONLY.cn3
 
    DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
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
 
END FUNCTION

#FUN-A20048 --begin
FUNCTION i501_b_fill_1() 
    DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(800)
    DEFINE l_factor        LIKE ima_file.ima31_fac  #TQC-7B0065
    DEFINE l_cnt           LIKE type_file.num5  #TQC-7B0065 
    
   	  OPEN WINDOW i501_g_b_q WITH FORM "asf/42f/asfi501a_2"
   	            ATTRIBUTE(STYLE = g_win_style CLIPPED )
   	  CALL cl_ui_locale("asfi501a_2") 
  
    LET g_sql="SELECT UNIQUE 'N',sie05 FROM sie_file WHERE sie11 >0 " 
    PREPARE i501_pb_1 FROM g_sql
    DECLARE sib_curs_1 CURSOR FOR i501_pb_1 
    CALL g_sib_1.clear()
 
    LET g_cnt = 1
 
    FOREACH sib_curs_1 INTO g_sib_1[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore sib:',STATUS,1) END IF
    CALL g_sib_1.deleteElement(g_cnt)
    
    LET g_rec_b1=g_cnt - 1
 
    DISPLAY g_rec_b1 TO FORMONLY.cnt2
    LET g_cnt = 0
    DISPLAY ARRAY g_sib_1 TO s_sib_1.* ATTRIBUTE(COUNT=g_rec_b1)
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
 
END FUNCTION
#FUN-A20048 --end 
 
FUNCTION i501_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(800)
    DEFINE l_factor        LIKE ima_file.ima31_fac  #TQC-7B0065
    DEFINE l_cnt           LIKE type_file.num5  #TQC-7B0065
    DEFINE l_sfb05         LIKE sfb_file.sfb05  #FUN-A60028
    DEFINE l_sfb06         LIKE sfb_file.sfb06   #FUN-A60028
    DEFINE l_flag          LIKE type_file.num5   #MOD-AC0336
    DEFINE l_flag1         LIKE type_file.chr1   #FUN-B20095
    DEFINE i               LIKE type_file.num5   #FUN-B20095
    DEFINE l_sfa05_r       LIKE sfa_file.sfa05   #TQC-CA0035 add

    #FUN-B70061 --START--
    IF g_sfp.sfp04='N' THEN 
       LET g_sql =
        "SELECT sfs02,sfs26,sfs28,sfs014,sfs03,sfs27,sfs04,",  
        "       ima02,ima021,sfs012,'',sfs013,sfs06,sfs10,(sfa05-sfa065),sfa06,'',",    #CHI-BC0040 add sfs28   ,  sfs27與sfs04交換 #FUN-C70014 add sfs014
        "       sfs07,sfs08,sfs09,sfs05,sfs33,sfs34,sfs35,sfs30,sfs31,sfs32,",
        "       sfs21,img10,0,sfs930,'',sfs36,'',sfs37,azf03 ",        #FUN-CB0087 add sfs37,azf03
        "       ,sfsud01,sfsud02,sfsud03,sfsud04,sfsud05,",
        "       sfsud06,sfsud07,sfsud08,sfsud09,sfsud10,",
        "       sfsud11,sfsud12,sfsud13,sfsud14,sfsud15",
        "       ,sfsiicd028,sfsiicd029", 
        ",sfa07",  
        " FROM sfs_file LEFT OUTER JOIN sfa_file ON sfs03=sfa01 AND sfs04=sfa03 AND sfs06=sfa12 AND sfs10=sfa08 AND sfs27=sfa27",   
        "  AND sfs012 = sfa012 AND sfs013 = sfa013 ",
        " LEFT OUTER JOIN sfsi_file ON sfs01 = sfsi01 AND sfs02 = sfsi02 ", 
        " LEFT OUTER JOIN img_file ON sfs04=img01 AND sfs07=img02 AND sfs08=img03 AND sfs09=img04",                                 
        " LEFT OUTER JOIN ima_file ON sfs04=ima01 ",           
        " LEFT OUTER JOIN azf_file ON sfs37=azf01 AND azf02 = '2' ",   #FUN-CB0087 add     
        " WHERE sfs01 ='",g_sfp.sfp01,"'", 
        "   AND ",p_wc2 CLIPPED,             
        " ORDER BY sfs02 "     
    ELSE
       LET g_sql =
        "SELECT sfe28,sfe26,sfa28,sfe014,sfe01,sfe27,sfe07,",
        "       ima02,ima021,sfe012,'',sfe013,sfe17,sfe14,(sfa05-sfa065),sfa06,'',",      #CHI-BC0040 add sfa28  ,  sfe27與sfe07交換  #FUN-C70014 add sfe014
        "       sfe08,sfe09,sfe10,sfe16,sfe33,sfe34,sfe35,sfe30,sfe31,sfe32,",
        "       sfe11,img10,'',sfe930,'',sfe36,'',sfe37,azf03 ",       #FUN-CB0087 #FUN-D50017 sfe37 
        #"       ,'','','','','',", #FUN-CB0043
        #"       '','','','','',",  #FUN-CB0043
        #"       '','','','','' ",  #FUN-CB0043
        "       ,sfeud01,sfeud02,sfeud03,sfeud04,sfeud05,", #FUN-CB0043
        "       sfeud06,sfeud07,sfeud08,sfeud09,sfeud10,",  #FUN-CB0043
        "       sfeud11,sfeud12,sfeud13,sfeud14,sfeud15",   #FUN-CB0043
        "       ,sfeiicd028,sfeiicd029", 
        ",''",                                   
        " FROM sfe_file LEFT OUTER JOIN sfa_file ON sfe01=sfa01 AND sfe07=sfa03 AND sfe17=sfa12 AND sfe14=sfa08 AND sfe27=sfa27",   
        "  AND sfe012 = sfa012 AND sfe013 = sfa013 ",
        " LEFT OUTER JOIN sfei_file ON sfe02 = sfei02 AND sfe28 = sfei28 ", 
        " LEFT OUTER JOIN img_file ON sfe07=img01 AND sfe08=img02 AND sfe09=img03 AND sfe10=img04 ",                                
        " LEFT OUTER JOIN ima_file ON sfe07=ima01 ",  
        " LEFT OUTER JOIN azf_file ON sfe37=azf01 AND azf02 = '2' ",   #FUN-CB0087 add #FUN-D50017 sfe37   
        " WHERE sfe02 ='",g_sfp.sfp01,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY sfe28"             
    END IF
    #FUN-B70061 --END
    PREPARE i501_pb FROM g_sql
    DECLARE sfs_curs CURSOR FOR i501_pb
 
    CALL g_sfs.clear()
 
    LET g_cnt = 1
 
    FOREACH sfs_curs INTO g_sfs[g_cnt].*, g_short_qty #單身 ARRAY 填充#FUN-940039 add 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        #計算欠料量g_short_qty(原g_sfa07)
         IF cl_null(g_sfs[g_cnt].sfs012) THEN LET g_sfs[g_cnt].sfs012=' ' END IF #TQC-CB0084 add 
         IF cl_null(g_sfs[g_cnt].sfs013) THEN LET g_sfs[g_cnt].sfs013= 0  END IF #TQC-CB0084 add 
         CALL s_shortqty(g_sfs[g_cnt].sfs03,g_sfs[g_cnt].sfs04,g_sfs[g_cnt].sfs10,
                         g_sfs[g_cnt].sfs06,g_sfs[g_cnt].sfs27,
                        #g_sfs012,g_sfs013)   #FUN-A50066 add      #MOD-CB0154 mark  
                         g_sfs[g_cnt].sfs012,g_sfs[g_cnt].sfs013)  #MOD-CB0154
              RETURNING g_short_qty
         IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
         LET g_sfs[g_cnt].short_qty = g_short_qty

        IF g_sfp.sfp04='N' THEN
           SELECT SUM(sfs05) INTO g_sfs[g_cnt].img10_alo FROM sfs_file,sfp_file #No:8247
            WHERE sfs04=g_sfs[g_cnt].sfs04
              AND sfs07=g_sfs[g_cnt].sfs07
              AND sfs08=g_sfs[g_cnt].sfs08
              AND sfs09=g_sfs[g_cnt].sfs09
              AND sfp01=sfs01 AND sfpconf!='X'  #No:8247  #FUN-660106
              AND sfs01 != g_sfp.sfp01    #MOD-A80031 add
           IF g_sfp.sfp06='3' THEN
              LET g_sfs[g_cnt].sfa05=g_short_qty   #FUN-940039 add
              LET g_sfs[g_cnt].sfa06=0
           END IF
        END IF
        IF g_sfp.sfp06 MATCHES '[6789]' THEN   #NO:7075
           IF g_sfs[g_cnt].sfa05<0  THEN
              LET g_sfs[g_cnt].sfa05=g_sfs[g_cnt].sfa05*(-1)
              LET g_sfs[g_cnt].sfa06=g_sfs[g_cnt].sfa06*(-1)
           END IF
        END IF
        #TQC-CA0035 add begin------------------------------------------
        #Run Card發料應發數量計算
        IF g_sfp.sfp06 = 'D' THEN
           SELECT shm08*sfa16 INTO l_sfa05_r FROM shm_file,sfa_file
            WHERE shm012 = sfa01 AND shm01 = g_sfs[g_cnt].sfs014
              AND sfa01 = g_sfs[g_cnt].sfs03
              AND sfa03 = g_sfs[g_cnt].sfs04 AND sfa08 = g_sfs[g_cnt].sfs10
              AND sfa012 = g_sfs[g_cnt].sfs012 AND sfa013 = g_sfs[g_cnt].sfs013 
              AND sfa12 = g_sfs[g_cnt].sfs06 AND sfa27 = g_sfs[g_cnt].sfs27
           IF l_sfa05_r < g_sfs[g_cnt].sfa05 THEN
              LET g_sfs[g_cnt].sfa05 = l_sfa05_r
           END IF
        END IF
        #TQC-CA0035 add end--------------------------------------------
 
        IF g_sma.sma115 = 'Y' THEN
           SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
            WHERE ima01 = g_sfs[g_cnt].sfs04
           IF g_ima906 = '2' THEN
              SELECT imgg10 INTO g_sfs[g_cnt].img10
                FROM imgg_file
               WHERE imgg01=g_sfs[g_cnt].sfs04
                 AND imgg02=g_sfs[g_cnt].sfs07
                 AND imgg03=g_sfs[g_cnt].sfs08
                 AND imgg04=g_sfs[g_cnt].sfs09
                 AND imgg09=g_sfs[g_cnt].sfs33
           END IF
        END IF
        LET g_sfs[g_cnt].gem02c=s_costcenter_desc(g_sfs[g_cnt].sfs930) #FUN-670103
       
        SELECT mse02 INTO g_sfs[g_cnt].mse02
          FROM mse_file WHERE mse01=g_sfs[g_cnt].sfs36
          
#FUN-B10056 ----------mod start-------
##FUN-A60028 --begin--
#        SELECT sfb06 INTO l_sfb06 FROM sfb_file  #MOD-AC0336
#         WHERE sfb01 = g_sfs[g_cnt].sfs03 
#        CALL s_schdat_sel_ima571(g_sfs[g_cnt].sfs03) RETURNING l_flag,l_sfb05 #MOD-AC0336 
#    	   SELECT ecu014 INTO g_sfs[g_cnt].ecu014 FROM ecu_file
#    	    WHERE ecu01  = l_sfb05
#    	      AND ecu02  = l_sfb06
#    	      AND ecu012 = g_sfs[g_cnt].sfs012 
##FUN-A60028 --end--   
        CALL s_schdat_ecm014(g_sfs[g_cnt].sfs03,g_sfs[g_cnt].sfs012) RETURNING g_sfs[g_cnt].ecu014       
#FUN-B10056 ------------mod end---------     
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore sfs:',STATUS,1) END IF
    CALL g_sfs.deleteElement(g_cnt)
    
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b)
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
    
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_sfp.sfp01,"'"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre
    
    CALL g_rvbs.clear()
    
    LET g_cnt = 1
    FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
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
 
FUNCTION i501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   #No.FUN-A40055--begin 
#   DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
#     BEFORE DISPLAY
#        EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#         ON IDLE g_idle_seconds
#                 CALL cl_on_idle()
#                 CONTINUE DISPLAY
#         
#         ON ACTION about         
#            CALL cl_about()      
#         
#         ON ACTION controlg      
#            CALL cl_cmdask()     
#         
#         ON ACTION help          
#            CALL cl_show_help()  
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
# 
#   IF g_errno='genb' THEN CALL i501_b_fill(' 1=1') LET g_errno='' END IF
# 
#   DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
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
# 
#      ON ACTION first
#         CALL i501_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL i501_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION jump
#         CALL i501_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION next
#         CALL i501_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION last
#         CALL i501_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL i501_mu_ui()   #TQC-710032
#         CALL i501_pic() #圖形顯示
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
##@    ON ACTION 套數
#      ON ACTION sets
#         LET g_action_choice="sets"
#         EXIT DISPLAY
##@    ON ACTION 庫存不足查詢
#      ON ACTION qry_short_inventory
#         LET g_action_choice="qry_short_inventory"
#         EXIT DISPLAY
#      ON ACTION qry_sets #套數查詢
#         LET g_action_choice="qry_sets"
#         EXIT DISPLAY
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
##@    ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
##@    ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
##@    ON ACTION 產生調撥單
#      ON ACTION gen_transfer_note
#         LET g_action_choice="gen_transfer_note"
#         EXIT DISPLAY
#ICD
#    #@ON ACTION 單據刻號BIN查詢作業
#      ON ACTION aic_s_icdqry
#         LET g_action_choice = "aic_s_icdqry"
#         EXIT DISPLAY
#                                                                                
#    #@ON ACTION 單據刻號BIN明細維護作業
#      ON ACTION s_icdout
#         LET g_action_choice = "s_icdout" 
#         EXIT DISPLAY
#ICD END
#SLK
#      ON ACTION auto_body
#         LET g_action_choice = "auto_body"
#         EXIT DISPLAY
#SLK END
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
#         
#      
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#      ON ACTION related_document                #No.FUN-6A0166  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
#
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=g_rec_d)
#     BEFORE DISPLAY
#        EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
      #TQC-AB0172------add---------------str-------------
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      #TQC-AB0172-----add-----------------end-------------          
   END DISPLAY
  
   DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b)
     
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   END DISPLAY
   
   #FUN-B30170 add begin-------------------------
   DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()

      AFTER DISPLAY
         CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY
   #FUN-B30170 add -end---------------------------
   
      #No.TQC-A70090  --start--
      BEFORE DIALOG                     
         CALL cl_show_fld_cont()
      #No.TQC-A70090  --end--
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
         CALL i501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
       	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i501_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i501_mu_ui()   #TQC-710032
         CALL i501_pic() #圖形顯示
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
#@    ON ACTION 套數
      ON ACTION sets
         LET g_action_choice="sets"
         EXIT DIALOG
#@    ON ACTION 庫存不足查詢
      ON ACTION qry_short_inventory
         LET g_action_choice="qry_short_inventory"
         EXIT DIALOG
      #No.FUN-A40055--begin
      # ON ACTION qry_sets #套數查詢
      #   LET g_action_choice="qry_sets"
      #   EXIT DIALOG
      #No.FUN-A40055--end
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#CHI-D20010---add--str
#@    ON ACTION 取消作废
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG     
#CHI-D20010---add--end
 
#@    ON ACTION 產生調撥單
      ON ACTION gen_transfer_note
         LET g_action_choice="gen_transfer_note"
         EXIT DIALOG
     #DEV-D30026 add str------------------------
#@    ON ACTION 條碼欠料調整(發料條碼數量分配)
      ON ACTION barcode_qty_allot
         LET g_action_choice="barcode_qty_allot"
         EXIT DIALOG      
     #DEV-D30026 add end------------------------
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DIALOG
                                                                                
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION s_icdout
         LET g_action_choice = "s_icdout" 
         EXIT DIALOG
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
         
      
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
 
#TQC-AC0197 ---------------------------Begin-------------------------------
      ON ACTION warahouse_modify
         LET g_action_choice="warahouse_modify"
         EXIT DIALOG
#TQC-AC0197 ---------------------------End---------------------------------

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 

      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      

      #FUN-AB0001---add----str---
      ON ACTION approval_status #簽核狀況
         LET g_action_choice="approval_status"
         EXIT DIALOG

      ON ACTION easyflow_approval #easyflow送簽
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG

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
      #FUN-AB0001---add----end---
 
      &include "qry_string.4gl"

   END DIALOG   
   
   IF g_errno='genb' THEN CALL i501_b_fill(' 1=1') LET g_errno='' END IF
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #No.FUN-A40055--end
END FUNCTION
 


FUNCTION i501_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION i501_out()
    DEFINE l_no		LIKE type_file.chr50   
    DEFINE l_wc2	LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
    DEFINE l_prtway	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    DEFINE l_prog	LIKE ima_file.ima34    #No.FUN-680121 VARCHAR(10)
 
    IF g_sfp.sfp01 IS NULL THEN RETURN END IF
 
    IF g_sfp.sfp06 MATCHES '[ABC]' THEN #FUN-630001 #TQC-650053
       IF g_argv1='1' THEN
         #LET l_prog='asrr210' #FUN-D60005 mark
          LET l_prog='asrg210' #FUN-D60005
       ELSE
         #LET l_prog='asrr220' #FUN-D60005 mark
          LET l_prog='asrg220' #FUN-D60005
       END IF
    ELSE
       IF g_argv1='1' THEN
          #LET l_prog='asfr501' #FUN-C30085 mark
          LET l_prog='asfg501' #FUN-C30085 add
       ELSE
          #LET l_prog='asfr502' #FUN-C30085 mark
          LET l_prog='asfg502' #FUN-C30085 add
       END IF
    END IF
 
    LET l_no = 'sfp01 = "',g_sfp.sfp01,'"'   #TQC-630013


   MENU ""
      ON ACTION transaction_doc_print
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
          WHERE zz01 = l_prog
         IF cl_null(l_wc2) THEN LET l_wc2 = " 'Y' '1'" END IF
         LET g_msg= l_prog,
                " '",g_today,"' '",g_user,"' '",g_lang,"' ",
                " 'Y' ' ' '1' ",
                " '",g_sfp.sfp01 CLIPPED,"' ",l_wc2     #No.TQC-6C0143
         CALL cl_cmdrun_wait(g_msg)
 
      ON ACTION exit
         EXIT MENU
 
      ON ACTION cancel
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
 
       -- for Windows close event trapped
      ON ACTION close    #COMMAND KEY(INTERRUPT)  #FUN-9B0145      
            LET INT_FLAG=FALSE 		#MOD-570244	mars
         EXIT MENU
 
   END MENU
 
 
    SELECT sfp05 INTO g_sfp.sfp05 FROM sfp_file WHERE sfp01=g_sfp.sfp01
    DISPLAY BY NAME g_sfp.sfp05
 
END FUNCTION
 
FUNCTION i501_t()
   DEFINE i,j,l_i   LIKE type_file.num10       #No.FUN-680121 INTEGER
   DEFINE l_sfs     DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    sfs04     LIKE sfs_file.sfs04,
                    sfs07     LIKE sfs_file.sfs07,
                    sfs08     LIKE sfs_file.sfs08,
                    sfs09     LIKE sfs_file.sfs09,
                    img09     LIKE img_file.img09,    #No:MOD-980003 add
                    img10     LIKE img_file.img10,
                    sfs06     LIKE sfs_file.sfs06,    #No:MOD-980003 add
                    sfs05     LIKE sfs_file.sfs05
                    END RECORD
   DEFINE l_t       LIKE type_file.num10   #No.FUN-680121 INTEGER     #FUN-610042
   DEFINE l_cnt     LIKE type_file.num10   #No.MOD-980003 add
   DEFINE l_factor  LIKE sfa_file.sfa13    #No.MOD-980003 add
 
   OPEN WINDOW i501_t_w AT 4,3 WITH FORM "asf/42f/asfi501c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfi501c")
   CALL cl_load_act_list(NULL)   #FUN-610042
 
   DECLARE i501_t_c CURSOR FOR
          SELECT sfs04,sfs07,sfs08,sfs09,img09,img10,sfs06,SUM(sfs05)   #No:MOD-980003 modify
            FROM sfs_file, OUTER img_file
           WHERE sfs01=g_sfp.sfp01
             AND sfs04=img01 AND sfs07=img02 AND sfs08=img03 AND sfs09=img04
           GROUP BY sfs04,sfs07,sfs08,sfs09,img09,img10,sfs06    ##No:MOD-980003 modify 
   LET i=1
   FOREACH i501_t_c INTO l_sfs[i].*
      IF cl_null(l_sfs[i].sfs05) THEN
         INITIALIZE l_sfs[i].* TO NULL
         CONTINUE FOREACH
      END IF
      CALL s_umfchk(l_sfs[i].sfs04,l_sfs[i].sfs06,l_sfs[i].img09)
           RETURNING l_cnt,l_factor
      
      IF l_cnt THEN
         LET l_factor = 1
      END IF
 
      IF l_sfs[i].img10 >= l_sfs[i].sfs05 * l_factor THEN   #No:MOD-980003 modify
          INITIALIZE l_sfs[i].* TO NULL   #MOD-490167
         CONTINUE FOREACH
      END IF
      LET i=i+1
   END FOREACH
   LET l_i = i - 1
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   DISPLAY ARRAY l_sfs TO s_sfs.* ATTRIBUTE(COUNT=l_i)
      BEFORE DISPLAY
         IF g_sma.sma115 = 'N' THEN
            CALL cl_set_act_visible("du_detail",FALSE)
         ELSE
            CALL cl_set_act_visible("du_detail",TRUE)
         END IF
 
      ON ACTION du_detail
         LET l_t = ARR_CURR()
         LET g_cmd = "aimq410 '",l_sfs[l_t].sfs04,"'"
         CALL cl_cmdrun(g_cmd CLIPPED)
         CONTINUE DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   CLOSE WINDOW i501_t_w
END FUNCTION
 
FUNCTION i501_gen()
   DEFINE l_cnt             LIKE type_file.num5,  
          li_result         LIKE type_file.num5
   DEFINE l_imm03           LIKE imm_file.imm03    #過帳否
   DEFINE l_sfs01           LIKE sfs_file.sfs01    #09/10/21 xiaofeizhu Add 
   DEFINE l_sfs02           LIKE sfs_file.sfs02    #09/10/21 xiaofeizhu Add
   DEFINE l_imd10           LIKE imd_file.imd10    #MOD-C10081 add
   
   

    IF g_sfp.sfp01 IS NULL THEN CALL cl_err('',-400,1) RETURN END IF
    IF g_sfp.sfp04 = 'Y' THEN CALL cl_err('','mfg0175',1) RETURN END IF
    IF g_sfp.sfpconf='Y' THEN CALL cl_err('','9023',1) RETURN END IF #FUN-660106
    IF g_sfp.sfpconf='X' THEN CALL cl_err('','9024',1) RETURN END IF #FUN-660106
    #FUN-AB0001  add str ---
    IF g_sfp.sfp15 matches '[Ss]' THEN
         CALL cl_err('','apy-561',0) #送簽中
         RETURN
    END IF
    #FUN-AB0001  add end ---
    LET l_cnt=0
 
    SELECT COUNT(*) INTO l_cnt FROM sfs_file,ima_file
     WHERE sfs01=g_sfp.sfp01 AND sfs04=ima01 AND ima108 = 'Y' AND sfs05<>0
    IF l_cnt=0 OR l_cnt IS NULL THEN
       CALL cl_err('','asf-033',1) #TQC-740154
       RETURN
    END IF
 
    # 判斷是否有產生調撥單, 若存在則詢問
    LET l_imm03=''
    SELECT imm03 INTO l_imm03 FROM imm_file
     WHERE imm01 = g_sfp.sfp08 AND imm09=g_sfp.sfp01
       AND immconf != 'X' #FUN-660029
 
    IF SQLCA.SQLCODE = 0  THEN
       IF l_imm03='Y' THEN
          CALL cl_err3("sel","imm_file",g_sfp.sfp08,g_sfp.sfp01,'mfg-052',"","",1)  #No.FUN-660128
          RETURN
       ELSE
          IF NOT cl_confirm('mfg-053') THEN
             RETURN
          ELSE
             DELETE FROM imm_file WHERE imm01=g_sfp.sfp08
                                    AND imm09=g_sfp.sfp01
             DELETE FROM imn_file WHERE imn01=g_sfp.sfp08
          END IF
       END IF
    END IF
 
    LET tm.tr_date = TODAY
    
 
    OPEN WINDOW i510g_w WITH FORM "asf/42f/asfi5199"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asfi5199")
 
        LET tm.tr_no = NULL            #MOD-C10081 add
        DISPLAY tm.tr_no TO tr.no      #MOD-C10081 add

    INPUT BY NAME tm.* WITHOUT DEFAULTS
 
      AFTER FIELD from_w
        #Mod No.FUN-AB0018
        #IF tm.from_w IS NULL THEN NEXT FIELD from_w END IF
         IF cl_null(tm.from_w) THEN NEXT FIELD from_w END IF
         #此处不使用s_chk_ware1(仓库变量,门店编号),使用s_chk_ware(仓库变量)即可.因为,immplant赋值为g_plant
         IF NOT s_chk_ware(tm.from_w) THEN  #检查仓库是否属于当前门店
            NEXT FIELD from_w
         END IF
        #End Mod No.FUN-AB0018
      #FUN-D40103 ------Begin------
         IF NOT s_imechk(tm.from_w,tm.from_loc) THEN
           #NEXT FIELD from_w     #TQC-D50126 mark
            NEXT FIELD from_loc   #TQC-D50126
         END IF
      #FUN-D40103 ------End--------
 
      AFTER FIELD from_loc
         IF tm.from_loc IS NULL THEN
            LET tm.from_loc=' '
         END IF
      #FUN-D40103 ------Begin-------
        #SELECT COUNT(*) INTO g_cnt
        #  FROM ime_file
        # WHERE ime01 = tm.from_w
        #   AND ime02 = tm.from_loc
        #IF g_cnt = 0 THEN CALL cl_err('','mfg1101',0)
        #   LET tm.from_loc=' '
        #   DISPLAY tm.from_loc TO from_loc
        #   NEXT FIELD from_w
        #END IF
         IF NOT s_imechk(tm.from_w,tm.from_loc) THEN
            LET tm.from_loc=' '
            DISPLAY tm.from_loc TO from_loc
            NEXT FIELD from_loc 
         END IF
      #FUN-D40103 ------End---------
 
      AFTER FIELD from_lot
         IF tm.from_lot IS NULL THEN
            LET tm.from_lot=' '
         END IF
 
      AFTER FIELD to_w
        #Mod No.FUN-AB0018
        #IF tm.to_w IS NULL THEN NEXT FIELD to_w END IF
         IF cl_null(tm.to_w) THEN NEXT FIELD to_w END IF
         #此处不使用s_chk_ware1(仓库变量,门店编号),使用s_chk_ware(仓库变量)即可.因为,immplant赋值为g_plant
         IF NOT s_chk_ware(tm.to_w) THEN  #检查仓库是否属于当前门店
            NEXT FIELD to_w
         END IF
        #End Mod No.FUN-AB0018

        #MOD-C10081 str add
         SELECT imd10 INTO l_imd10 FROM imd_file WHERE imd01 = tm.to_w
         IF l_imd10 != 'W' THEN
           CALL cl_err(tm.to_w,'asf-724',0)
           NEXT FIELD to_w
         END IF
        #MOD-C10081 end add
      #FUN-D40103 ------Begin------
         IF NOT s_imechk(tm.to_w,tm.to_loc) THEN
            NEXT FIELD to_loc
         END IF
      #FUN-D40103 ------End--------
 
      AFTER FIELD to_loc
         IF tm.to_loc IS NULL THEN
            LET tm.to_loc=' '
         END IF
      #FUN-D40103 ------Begin------
        #SELECT COUNT(*) INTO g_cnt
        #  FROM ime_file
        # WHERE ime01 = tm.to_w
        #   AND ime02 = tm.to_loc
        #IF g_cnt=0 THEN CALL cl_err('','mfg1101',0)
        #   LET tm.to_loc=' '
        #   DISPLAY tm.to_loc TO to_loc
        #   NEXT FIELD to_w
        #END IF
         IF NOT s_imechk(tm.to_w,tm.to_loc) THEN
            LET tm.to_loc=' '
            DISPLAY tm.to_loc TO to_loc
            NEXT FIELD to_loc
         END IF
      #FUN-D40103 ------End--------
 
      AFTER FIELD to_lot
         IF tm.to_lot IS NULL THEN
            LET tm.to_lot=' '
         END IF
 
      AFTER FIELD tr_no
         IF cl_null(tm.tr_no) THEN NEXT FIELD tr_no END IF   #TQC-C20158
         IF tm.tr_no IS NOT NULL THEN
            LET g_t1=tm.tr_no[1,g_doc_len]
            CALL s_check_no("aim",g_t1,"","4","","","")
            RETURNING li_result,tm.tr_no
            LET tm.tr_no = s_get_doc_no(tm.tr_no)
            DISPLAY BY NAME tm.tr_no
            IF (NOT li_result) THEN
               NEXT FIELD tr_no
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.from_loc IS NULL THEN
            LET tm.from_loc=' '
         END IF
         IF tm.to_loc IS NULL THEN
            LET tm.to_loc=' '
         END IF
         IF tm.from_lot IS NULL THEN
            LET tm.from_lot=' '
         END IF
         IF tm.to_lot IS NULL THEN
            LET tm.to_lot=' '
         END IF
         IF cl_null(tm.from_w) THEN
            NEXT FIELD from_w
         END IF
         IF cl_null(tm.to_w) THEN
            NEXT FIELD to_w
         END IF
 
        ON ACTION controlp
          CASE WHEN INFIELD(tr_no) #查詢單据
                    LET g_t1=s_get_doc_no(tm.tr_no)     #No.FUN-550052
                    CALL q_smy( FALSE, TRUE,g_t1,'AIM','4') RETURNING g_t1   #TQC-670008
                    LET tm.tr_no = g_t1                 #No.FUN-550052
                    DISPLAY BY NAME tm.tr_no
                    NEXT FIELD tr_no
               WHEN INFIELD(from_w)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_imd"
                   #LET g_qryparam.default1 = tm.from_w
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   #CALL cl_create_qry() RETURNING tm.from_w
                    CALL q_imd_1(FALSE,TRUE,tm.from_w,"",g_plant,"","")  #只能开当前门店的
                         RETURNING tm.from_w
                   #End Mod No.FUN-AB0018
                    NEXT FIELD from_w
               WHEN INFIELD(from_loc)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_ime"
                   #LET g_qryparam.default1 = tm.from_loc
                   #LET g_qryparam.arg1     = tm.from_w         #倉庫編號 #MOD-4A0063
                   #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                   #CALL cl_create_qry() RETURNING tm.from_loc
                    CALL q_ime_1(FALSE,TRUE,tm.from_loc,tm.from_w,"",g_plant,"","","")
                         RETURNING tm.from_loc
                   #End Mod No.FUN-AB0018
                    NEXT FIELD from_loc
               WHEN INFIELD(to_w)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_imd"
                   #LET g_qryparam.default1 = tm.to_w
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   #CALL cl_create_qry() RETURNING tm.to_w
                    CALL q_imd_1(FALSE,TRUE,tm.to_w,"W",g_plant,"","")  #只能开当前门店的 #MOD-C10081 第四個參數傳W
                         RETURNING tm.to_w
                   #End Mod No.FUN-AB0018
                    NEXT FIELD to_w
               WHEN INFIELD(to_loc)
                   #Mod No.FUN-AB0018
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form ="q_ime"
                   #LET g_qryparam.default1 = tm.to_loc
                   #LET g_qryparam.arg1     = tm.to_w         #倉庫編號 #MOD-4A0063
                   #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                   #CALL cl_create_qry() RETURNING tm.to_loc
                    CALL q_ime_1(FALSE,TRUE,tm.to_loc,tm.to_w,"W",g_plant,"","","")   #MOD-C10081 第五個參數傳W
                         RETURNING tm.to_loc
                   #End Mod No.FUN-AB0018
                    NEXT FIELD to_loc
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i510g_w
      RETURN
   END IF
 
   IF NOT cl_sure(0,0) THEN
      CLOSE WINDOW i510g_w
      RETURN
   ELSE
      CALL cl_wait()
 
      DECLARE sfs_upd CURSOR FOR                                             
       SELECT sfs01,sfs02 FROM sfs_file,ima_file                              #09/10/21 xiaofeizhu
        WHERE sfs01=g_sfp.sfp01 AND sfs04=ima01 AND ima108 = 'Y'  

      FOREACH sfs_upd INTO l_sfs01,l_sfs02                                    #09/10/21 xiaofeizhu Add   
         IF STATUS <> 0 THEN EXIT FOREACH END IF 
           #UPDATE sfs_file SET sfs07=tm.to_w, sfs08=tm.to_loc, sfs09=' '           #MOD-D30207 mark
            UPDATE sfs_file SET sfs07=tm.to_w, sfs08=tm.to_loc, sfs09=tm.to_lot     #MOD-D30207 add
             WHERE sfs01=l_sfs01 AND sfs02 = l_sfs02                          #09/10/21 xiaofeizhu Add                                             
      END FOREACH
      CALL i501_b_fill(" 1=1")  #MOD-840550 add
 
      IF NOT cl_null(tm.tr_no) THEN
         CALL r501g()
      END IF
 
      CLOSE WINDOW i510g_w
 
      DISPLAY BY NAME g_sfp.sfp08
      ERROR ""
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION r501g()
   DEFINE l_i            LIKE type_file.num5      #FUN-510029  #No.FUN-680121 SMALLINT
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680121 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-680121 VARCHAR(600)
          l_n       LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_chr     LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
          li_result LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_cmd     LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(80)
          l_sfb	    RECORD LIKE sfb_file.*,
          l_order    ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(16), #MOD-580001 VARCHAR(10)->CHAR(16)
          sr            RECORD
                               ima23	LIKE ima_file.ima23,
                               sfa03	LIKE sfa_file.sfa03,
                               sfa26	LIKE sfa_file.sfa26,
                               ima02	LIKE ima_file.ima02,
                               ima64	LIKE ima_file.ima64,
                               ima641	LIKE ima_file.ima641,
                               sfa12	LIKE sfa_file.sfa12,
                               sfa05	LIKE sfa_file.sfa05,
                               sfs930 LIKE sfs_file.sfs930 #FUN-670103
                        END RECORD
                 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     
     LET g_prog='asfr204' 
     CALL cl_outnam(g_prog) RETURNING l_name
    
    #TQC-CA0045 modify begin---------------
    #LET g_prog='asfi511' 
     IF g_sfp.sfp06 = 'D' THEN 
        LET g_prog='asfi519'
     ELSE
        LET g_prog='asfi511'
     END IF 
    #TQC-CA0045 modify end-----------------
     
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr204'
 
     BEGIN WORK
     OPEN i501_cl USING g_sfp.sfp01                                #09/10/21 xiaofeizhu Add
     IF STATUS THEN
        CALL cl_err("OPEN i501_cl:", STATUS, 1)  
        CLOSE i501_cl
        ROLLBACK WORK
        RETURN
     END IF
     FETCH i501_cl INTO g_sfp.*         # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfp.sfp01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i501_cl ROLLBACK WORK RETURN
     END IF
 
     LET g_success='Y'
     START REPORT r501g_rep TO l_name
     CALL s_auto_assign_no("aim",tm.tr_no,tm.tr_date,"4","","","","","")
     RETURNING li_result,tm.tr_no
     IF (NOT li_result) THEN
        LET g_success='N'
     END IF
     DISPLAY BY NAME tm.tr_no
 
     DECLARE r510g_sfa_c CURSOR FOR
      SELECT ima23,sfs04,'',ima02,ima64,ima641,sfs06,sfs05,sfs930  #FUN-670103
        FROM sfs_file,ima_file
       WHERE sfs01=g_sfp.sfp01 AND sfs04=ima01 AND ima108 = 'Y' AND sfs05 > 0
       ORDER BY ima23, sfs04
 
     LET g_pno = 0
     FOREACH r510g_sfa_c INTO sr.*
       OUTPUT TO REPORT r501g_rep(sr.*)
     END FOREACH
 
     UPDATE sfp_file SET sfp08=tm.tr_no WHERE sfp01=g_sfp.sfp01
 
     FINISH REPORT r501g_rep
     LET l_n=0   #No.+245 010621 add
     SELECT COUNT(*) INTO l_n FROM imn_file WHERE imn01=tm.tr_no
     IF STATUS <> 0 OR l_n IS NULL OR l_n=0 THEN
        LET g_success='N'
     END IF
     IF g_success='Y' THEN
        LET g_sfp.sfp08=tm.tr_no
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     IF tm.tr_no IS NOT NULL AND g_success='Y' THEN
           LET g_msg="aimt324_icd '",tm.tr_no,"'"
        CALL cl_cmdrun_wait(g_msg)   #FUN-660216 add
     END IF
       CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #MOD-750044 add
END FUNCTION
 
REPORT r501g_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
          l_sfb		RECORD LIKE sfb_file.*,
          l_imm		RECORD LIKE imm_file.*,
          li_result LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_imn		RECORD LIKE imn_file.*,
          l_ima02	LIKE ima_file.ima02,
          l_bmd02	LIKE bmd_file.bmd02,
          l_bmd04	LIKE bmd_file.bmd04,
          l_bmd07	LIKE bmd_file.bmd07,
          l_bmd08	LIKE bmd_file.bmd08,
          i,j,k		LIKE type_file.num10,          #No.FUN-680121 INTEGER,
#         to_qty,from_qty	LIKE ima_file.ima262,  #No.FUN-680121 DEC(15,3),
#         l_qty,l_ima262	LIKE ima_file.ima262,  #No.FUN-680121 DEC(15,3),
          to_qty,from_qty	LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044 #NO.FUN-A40023
          l_qty,l_avl_stk	LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044 #NO.FUN-A40023
          l_unit                LIKE ima_file.ima25, #MOD-580001
          l_factor        LIKE ima_file.ima31_fac,   #No.FUN-680121 DECIMAL(16,8),
          l_flag          LIKE type_file.num5,       #No.FUN-680121 SMALLINT,
          l_bml		RECORD LIKE bml_file.*,
          sr            RECORD
                               ima23	LIKE ima_file.ima23,
                               sfa03	LIKE sfa_file.sfa03,
                               sfa26	LIKE sfa_file.sfa26,
                               ima02	LIKE ima_file.ima02,
                               ima64	LIKE ima_file.ima64,
                               ima641	LIKE ima_file.ima641,
                               sfa12	LIKE sfa_file.sfa12,
                               sfa05	LIKE sfa_file.sfa05,
                               sfs930 LIKE sfs_file.sfs930 #FUN-670103
          		END RECORD
DEFINE  l_ima25      LIKE ima_file.ima25
DEFINE  l_img09      LIKE img_file.img09
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_cnt        LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE  l_imni       RECORD LIKE imni_file.*   #FUN-B70061 ch
DEFINE  l_store      STRING                    #FUN-CB0087
DEFINE  l_gen02      LIKE gen_file.gen02       #TQC-D50070 add
DEFINE  l_ima021     LIKE ima_file.ima021      #TQC-D50070 add

 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.ima23, sr.sfa03
  FORMAT
   PAGE HEADER
   #  LET g_x[1]="Unuual Store Transfer Not Enough Report"     #TQC-C90082
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT ''                                                 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
      IF cl_null(g_towhom)
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash
      PRINT  g_x[31],g_x[36],g_x[32],g_x[33],g_x[37],g_x[34],g_x[35]  #TQC-D50070 add 36,37      
      PRINT g_dash1
 
      LET g_pno = g_pno + 1
      IF NOT cl_null(tm.tr_no) AND g_pno=1 THEN
     CALL s_auto_assign_no("aim",tm.tr_no,tm.tr_date,"4","","","","","")
     RETURNING li_result,tm.tr_no
     IF (NOT li_result) THEN
        LET g_success='N'
     END IF
         DISPLAY BY NAME tm.tr_no
         LET l_imm.imm01=tm.tr_no
         LET l_imm.imm02=tm.tr_date
         LET l_imm.imm03='N'
         LET l_imm.imm04='N'
         LET l_imm.immconf='N' #FUN-660029
         LET l_imm.imm07=0
         LET l_imm.imm09=g_sfp.sfp01
         LET l_imm.imm10='1'
         LET l_imm.immacti='Y'
         LET l_imm.immuser=g_user
         LET l_imm.immgrup=g_grup
         LET l_imm.imm14=g_sfp.sfp07 #FUN-670103
         LET l_imm.immplant = g_plant #FUN-980008 add
         LET l_imm.immlegal = g_legal #FUN-980008 add
         
 
         INITIALIZE l_imn.* TO NULL
         LET l_imn.imn02=0
         LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
         LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
         LET l_imm.imm12=''                                    #TQC-AB0223 add
         #FUN-A60034--add---str---
         #FUN-A70104--mod---str---
         LET l_imm.immmksg = g_smy.smyapr #是否簽核
         LET l_imm.imm15 = '0'            #簽核狀況
         LET l_imm.imm16 = g_user         #申請人
         LET l_imm.imm17 = g_today        #過帳日期        #MOD-D60164 add
         #FUN-A70104--mod---end---
         #FUN-A60034--add---end---
         INSERT INTO imm_file VALUES(l_imm.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("ins","imm_file",l_imm.imm01,"",STATUS,"","ins imm:",1)  #No.FUN-660128
            LET g_success='N'
         END IF
      END IF
 
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.sfa03
      LET to_qty = 0   LET l_unit = ' '   #No.7226
      LET l_qty=GROUP SUM(sr.sfa05)
      SELECT img10,img09 INTO to_qty,l_unit FROM img_file
             WHERE img01=sr.sfa03 AND img02=tm.to_w AND img03=tm.to_loc AND img04=tm.to_lot
      IF SQLCA.sqlcode THEN
         LET to_qty = 0
 #有問題時,則讀取該料件的預設發料單位試試
         SELECT ima63 INTO l_unit FROM ima_file
          WHERE ima01 = sr.sfa03
         IF cl_null(l_unit) THEN
            LET l_unit = ' '
         END IF
      END IF
      IF cl_null(to_qty)  THEN LET to_qty=0 END IF
 
      CALL s_umfchk(sr.sfa03,sr.sfa12,l_unit) RETURNING l_flag,l_factor
      IF l_flag THEN
         CALL cl_err('sfa12<>img09:','asf-400',1)
         LET l_factor=1
      ELSE
         LET l_qty=l_qty*l_factor
      END IF
 
      IF l_qty>to_qty THEN   #若WIP 庫存不足才發料
         LET l_qty = l_qty - to_qty
         IF sr.ima64 != 0
         THEN		# 發料倍量
            LET k = (l_qty / sr.ima64) + 0.999
            LET l_qty = sr.ima64 * k
         END IF
         IF l_qty < sr.ima641
         THEN		# 最小發料量
            LET l_qty = sr.ima641
         END IF
 
         IF tm.tr_no IS NOT NULL THEN
            LET l_imn.imn01=tm.tr_no
            LET l_imn.imn02=l_imn.imn02+1
            LET l_imn.imn03=sr.sfa03
            LET l_imn.imn04=tm.from_w
            LET l_imn.imn05=tm.from_loc
           #LET l_imn.imn06=' '            #MOD-D30207 mark
            LET l_imn.imn06=tm.from_lot    #MOD-D30207 add 
            LET l_imn.imn09=l_unit
            LET l_imn.imn10=l_qty
            LET l_imn.imn10=s_digqty(l_imn.imn10,l_imn.imn09)    #FUN-BB0084
            LET l_imn.imn15=tm.to_w
            LET l_imn.imn16=tm.to_loc
            LET l_imn.imn17=tm.to_lot
            LET l_imn.imn20=l_imn.imn09
            LET l_imn.imn21=1
            LET l_imn.imn22=l_imn.imn10*l_imn.imn21
            LET l_imn.imn22=s_digqty(l_imn.imn22,l_imn.imn20)    #FUN-BB0084
            IF g_sma.sma115 = 'Y' THEN
               SELECT ima25,ima906,ima907
                 INTO l_ima25,l_ima906,l_ima907
                 FROM ima_file WHERE ima01=l_imn.imn03
               LET l_img09=NULL
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01=l_imn.imn03
                  AND img02=l_imn.imn04
                  AND img03=l_imn.imn05
                  AND img04=l_imn.imn06
               IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
               LET l_imn.imn30=l_imn.imn09
               LET l_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_img09)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1
               END IF
               LET l_imn.imn31=l_factor
               LET l_imn.imn32=l_imn.imn10
               LET l_imn.imn33=l_ima907
               LET l_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_img09)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1
               END IF
               LET l_imn.imn34=l_factor
               LET l_imn.imn35=0
               IF l_ima906 = '3' THEN
                  LET l_factor = 1
                  CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn33)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1
                  END IF
                  LET l_imn.imn35=l_imn.imn32*l_factor
                  LET l_imn.imn35=s_digqty(l_imn.imn35,l_imn.imn33)    #FUN-BB0084    
               END IF
               IF l_ima906='1' THEN
                  LET l_imn.imn33=NULL
                  LET l_imn.imn34=NULL
                  LET l_imn.imn35=NULL
               END IF
               LET l_img09=NULL
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01=l_imn.imn03
                  AND img02=l_imn.imn15
                  AND img03=l_imn.imn16
                  AND img03=l_imn.imn17
               IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
               LET l_imn.imn40=l_imn.imn20
               LET l_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn40,l_img09)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1
               END IF
               LET l_imn.imn41=l_factor
               LET l_imn.imn42=l_imn.imn22
               LET l_imn.imn43=l_ima907
               LET l_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn43,l_img09)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1
               END IF
               LET l_imn.imn44=l_factor
               LET l_imn.imn45=0
               IF l_ima906 = '3' THEN
                  LET l_factor = 1
                  CALL s_umfchk(l_imn.imn03,l_imn.imn40,l_imn.imn43)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1
                  END IF
                  LET l_imn.imn45=l_imn.imn42*l_factor
                  LET l_imn.imn45=s_digqty(l_imn.imn45,l_imn.imn43)   #FUN-BB0084
               END IF
               IF l_ima906='1' THEN
                  LET l_imn.imn43=NULL
                  LET l_imn.imn44=NULL
                  LET l_imn.imn45=NULL
               END IF
            END IF
            LET l_imn.imn9301=sr.sfs930 #FUN-670103
            LET l_imn.imn9302=sr.sfs930 #FUN-670103
            LET l_imn.imn29 = 'N'     #TQC-760124
 
            LET l_imn.imnplant = g_plant #FUN-980008 add
            LET l_imn.imnlegal = g_legal #FUN-980008 add
            #FUN-CB0087---qiull---add---str---
            IF g_aza.aza115 = 'Y' THEN
               LET l_store = ''
               IF NOT cl_null(l_imn.imn04) THEN
                  LET l_store = l_store,l_imn.imn04
               END IF
               IF NOT cl_null(l_imn.imn15) THEN
                  IF NOT cl_null(l_store) THEN
                     LET l_store = l_store,"','",l_imn.imn15
                  ELSE
                     LET l_store = l_store,l_imn.imn15
                  END IF
               END IF
               CALL s_reason_code(l_imn.imn01,'','',l_imn.imn03,l_store,l_imm.imm16,l_imm.imm14) RETURNING l_imn.imn28
               IF cl_null(l_imn.imn28) THEN
                  CALL cl_err('','aim-425',1)
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-CB0087---qiull---add---end---
            INSERT INTO imn_file VALUES(l_imn.*)
            IF STATUS THEN
                 CALL cl_err3("ins","imn_file",l_imn.imn01,l_imn.imn02,STATUS,"","ins imn:",1)  #No.FUN-660128
                 LET g_success='N'
            #FUN-B70061 ch-add-str--
            ELSE
               INITIALIZE l_imni.* TO NULL
               LET l_imni.imni01 = l_imn.imn01
               LET l_imni.imni02 = l_imn.imn02
               IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
                  LET g_success = 'N'
               END IF
            #FUN-B70061 ch-add-end--
            END IF
            SELECT img10,img09 INTO from_qty,l_unit FROM img_file
             WHERE img01=sr.sfa03
               AND img02=tm.from_w
               AND img03=tm.from_loc
               AND img04=tm.from_lot
            CALL s_umfchk(sr.sfa03,sr.sfa12,l_unit) RETURNING l_flag,l_factor
            IF l_flag THEN
               CALL cl_err('sfa12<>img09:','asf-400',1)
               LET l_factor=1
            ELSE
               LET l_qty=l_qty*l_factor
            END IF
            IF cl_null(from_qty) THEN LET from_qty= 0 END IF   #MOD-750044 add
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.ima23 AND genacti = 'Y'  #TQC-D50070 add
            SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = sr.sfa03  #TQC-D50070 add
           #IF (l_qty-from_qty) > 0 THEN   #No:MOD-A20007 mark
              PRINT COLUMN g_c[31],sr.ima23[1,6],
                    COLUMN g_c[36],l_gen02,     #TQC-D50070 add
                    COLUMN g_c[32],sr.sfa03, 
                    COLUMN g_c[33],sr.ima02,
                    COLUMN g_c[37],l_ima021,   #TQC-D50070 add
                    COLUMN g_c[34],l_qty  USING '---,---,--&' ,
                   #COLUMN g_c[35],(l_qty-from_qty)  USING '---,---,--&'  #MOD-C10081 mark
                    COLUMN g_c[35],(from_qty-l_qty)  USING '---,---,--&'  #MOD-C10081 add 
           #END IF    #No:MOD-A20007 mark
         END IF
      ELSE
         CALL cl_err(sr.sfa03,'asf-364',1)
      END IF
 
   ON LAST ROW
      PRINT g_dash                #MOD-750044
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
      THEN
          #PRINT g_dash_1[1,g_len]    #MOD-750044 mark
          PRINT g_dash                #MOD-750044
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
 
END REPORT
 
FUNCTION i501_set_required()
 
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("sfs33,sfs35,sfs30,sfs32",TRUE)
  END IF
  IF NOT cl_null(g_sfs[l_ac].sfs33) THEN
     CALL cl_set_comp_required("sfs35",TRUE)
  END IF
  IF NOT cl_null(g_sfs[l_ac].sfs30) THEN
     CALL cl_set_comp_required("sfs32",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i501_set_no_required()
 
  CALL cl_set_comp_required("sfs33,sfs34,sfs35,sfs30,sfs31,sfs32",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION i501_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima55  LIKE ima_file.ima55,     #ima單位
            l_ima63  LIKE ima_file.ima63,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE sfs_file.sfs34,     #第二轉換率
            l_qty2   LIKE sfs_file.sfs35,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE sfs_file.sfs31,     #第一轉換率
            l_qty1   LIKE sfs_file.sfs32,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_sfs[l_ac].sfs04
    LET l_ware = g_sfs[l_ac].sfs07
    LET l_loc  = g_sfs[l_ac].sfs08
    LET l_lot  = g_sfs[l_ac].sfs09
 
    SELECT ima63,ima906,ima907 INTO l_ima63,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima63,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = l_ima63
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' THEN
       LET g_sfs[l_ac].sfs33=l_unit2
       LET g_sfs[l_ac].sfs34=l_fac2
       LET g_sfs[l_ac].sfs35=l_qty2
       LET g_sfs[l_ac].sfs30=l_unit1
       LET g_sfs[l_ac].sfs31=l_fac1
       LET g_sfs[l_ac].sfs32=l_qty1
       LET b_sfs.sfs30 = g_sfs[l_ac].sfs30
       LET b_sfs.sfs31 = g_sfs[l_ac].sfs31
       LET b_sfs.sfs32 = g_sfs[l_ac].sfs32
       LET b_sfs.sfs33 = g_sfs[l_ac].sfs33
       LET b_sfs.sfs34 = g_sfs[l_ac].sfs34
       LET b_sfs.sfs35 = g_sfs[l_ac].sfs35
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION i501_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE sfs_file.sfs34,
            l_qty2   LIKE sfs_file.sfs35,
            l_fac1   LIKE sfs_file.sfs31,
            l_qty1   LIKE sfs_file.sfs32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
   DEFINE   l_ima63  LIKE ima_file.ima63
 
    SELECT ima63 INTO l_ima63
      FROM ima_file WHERE ima01=g_sfs[l_ac].sfs04
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_sfs[l_ac].sfs34
    LET l_qty2=g_sfs[l_ac].sfs35
    LET l_fac1=g_sfs[l_ac].sfs31
    LET l_qty1=g_sfs[l_ac].sfs32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_sfs[l_ac].sfs06=g_sfs[l_ac].sfs30
                   LET g_sfs[l_ac].sfs05=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_sfs[l_ac].sfs06=l_ima63
                   LET g_sfs[l_ac].sfs05=l_tot
          WHEN '3' LET g_sfs[l_ac].sfs06=g_sfs[l_ac].sfs30
                   LET g_sfs[l_ac].sfs05=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_sfs[l_ac].sfs34=l_qty1/l_qty2
                   ELSE
                      LET g_sfs[l_ac].sfs34=0
                   END IF
       END CASE
    END IF
    LET b_sfs.sfs05 = g_sfs[l_ac].sfs05
    LET b_sfs.sfs06 = g_sfs[l_ac].sfs06
 
END FUNCTION
 
FUNCTION i501_set_du_by_origin()
  DEFINE l_ima55    LIKE ima_file.ima55,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_factor   LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
      SELECT ima55,ima906,ima907,ima908
        INTO l_ima55,l_ima906,l_ima907,l_ima908
        FROM ima_file WHERE ima01 = b_sfs.sfs04
 
       LET b_sfs.sfs30 = b_sfs.sfs06
      #應該是與工單備料檔中的備料單位轉換
       CALL s_umfchk(b_sfs.sfs04,b_sfs.sfs06,g_sfa2.sfa12)
            RETURNING g_errno,l_factor
       LET b_sfs.sfs31 = l_factor
       LET b_sfs.sfs32 = b_sfs.sfs05 / l_factor
 
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET b_sfs.sfs33 = NULL
          LET b_sfs.sfs34 = NULL
          LET b_sfs.sfs35 = NULL
       ELSE
          LET b_sfs.sfs33 = l_ima907
      #應該是與工單備料檔中的備料單位轉換
          CALL s_umfchk(b_sfs.sfs04,b_sfs.sfs33,g_sfa2.sfa12)
               RETURNING g_errno,l_factor
          LET b_sfs.sfs34 = l_factor
          IF l_ima906 = '3' THEN 
             LET b_sfs.sfs35 = b_sfs.sfs32 / l_factor
          ELSE
             LET b_sfs.sfs35 = 0
          END IF      #No.MOD-920345 add
 
       END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION i501_du_data_to_correct()
 
   IF cl_null(g_sfs[l_ac].sfs30) THEN
      LET g_sfs[l_ac].sfs31 = NULL
      LET g_sfs[l_ac].sfs32 = NULL
      LET b_sfs.sfs31 = NULL
      LET b_sfs.sfs32 = NULL
   END IF
 
   IF cl_null(g_sfs[l_ac].sfs33) THEN
      LET g_sfs[l_ac].sfs34 = NULL
      LET g_sfs[l_ac].sfs35 = NULL
      LET b_sfs.sfs34 = NULL
      LET b_sfs.sfs35 = NULL
   END IF
   DISPLAY BY NAME g_sfs[l_ac].sfs31
   DISPLAY BY NAME g_sfs[l_ac].sfs32
   DISPLAY BY NAME g_sfs[l_ac].sfs34
   DISPLAY BY NAME g_sfs[l_ac].sfs35
 
END FUNCTION
 
#計算庫存總量是否滿足所輸入數量
FUNCTION i501_check_inventory_qty()
DEFINE l_n                 LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
       l_factor            LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),
       l_sfa05             LIKE sfa_file.sfa05,      #MOD-7A0133 add
       l_sfa06             LIKE sfa_file.sfa06,
       l_sfa161            LIKE sfa_file.sfa161,
       l_sfa100            LIKE sfa_file.sfa100,     #MOD-8B0230 add
       l_sfa100_t          LIKE sfa_file.sfa100,     #MOD-8B0230 add
       l_sfa06_t           LIKE sfa_file.sfa06,
       l_sfa161_t          LIKE sfa_file.sfa161,
       l_sfa26             LIKE sfa_file.sfa26,
       l_sfa27             LIKE sfa_file.sfa27,
       l_sfa28             LIKE sfa_file.sfa28,
       l_sfa28_t           LIKE sfa_file.sfa28,
       l_sfs05             LIKE sfs_file.sfs05,
       l_sfb09             LIKE sfb_file.sfb09,
       l_sfb08             LIKE sfb_file.sfb08,      #MOD-8B0230
       l_sfb11             LIKE sfb_file.sfb11,      #MOD-8B0230
       l_sfa11             LIKE sfa_file.sfa11,      #MOD-BA0193
       l_qty	           LIKE sfb_file.sfb09  #No.FUN-680121 DECIMAL(15,3)
 
   IF NOT cl_null(g_sfp.sfp06) THEN
      IF g_sfp.sfp06 MATCHES '[13]' THEN
         IF g_sfs[l_ac].sfs05>(g_sfs[l_ac].sfa05-g_sfs[l_ac].sfa06) THEN
            CALL cl_err('sfs05<>sfa05:','asf-351',0)
            RETURN 1
         END IF
      END IF
      IF g_sfp.sfp06 MATCHES '[1234]' THEN
        #BUGNO:3264 sfs05發料量 * l_factor > img10庫存量 01/08/10mandy
        #IF (g_sfs[l_ac].sfs05 * l_factor) > g_sfs[l_ac].img10 THEN     #MOD-C50190 mark
         IF (g_sfs[l_ac].sfs05 * l_factor) > g_sfs[l_ac].img10 AND NOT i501_isVMI(g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08) THEN #MOD-C50190 add i501_isVMI 
           #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
           #FUN-D30024--modify--str--
           #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
           #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894      #FUN-C80107
           #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
            IF g_imd23 = 'N' THEN
           #FUN-D30024--modify--end--
               CALL cl_err(g_sfs[l_ac].sfs05,'mfg1303',0)
               RETURN 1
            END IF
         END IF
      END IF
      IF g_sfp.sfp06 MATCHES '[6789]' THEN   #NO:7075
         IF g_sfs[l_ac].sfs05 < 0  THEN
            CALL cl_err('','asf-952',1)
            RETURN 1
         END IF
         IF g_sfp.sfp06 = '7' THEN    #超領退料
            SELECT sfa062 INTO g_sfs[l_ac].sfa06
              FROM sfa_file
             WHERE sfa01 = g_sfs[l_ac].sfs03
               AND sfa03 = g_sfs[l_ac].sfs04
               AND sfa08 = g_sfs[l_ac].sfs10
               AND sfa12 = g_sfs[l_ac].sfs06
               AND sfa27 = g_sfs[l_ac].sfs27  #FUN-9B0149
               AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028
               AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
            IF g_sfs[l_ac].sfs05>g_sfs[l_ac].sfa06 THEN
               CALL cl_err(g_sfs[l_ac].sfs05,'asf-474',1)
               RETURN 1
            END IF
         END IF
 
         IF g_sfp.sfp06 = '6' THEN    #成套退料
            SELECT sfb08,sfb09 INTO l_sfb08,l_sfb09 FROM sfb_file  #已發-完工      #MOD-940347 add sfb08,l_sfb08
             WHERE sfb01 = g_sfs[l_ac].sfs03   #工單
            SELECT sfa06,sfa161 INTO l_sfa06,l_sfa161 FROM sfa_file   #FUN-B50059
             WHERE sfa01 = g_sfs[l_ac].sfs03
               AND sfa03 = g_sfs[l_ac].sfs04
               AND sfa08 = g_sfs[l_ac].sfs10    #FUN-A60095
               AND sfa12 = g_sfs[l_ac].sfs06    #FUN-A60095
               AND sfa27 = g_sfs[l_ac].sfs27    #FUN-A60095
               AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60095
               AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60095
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF
            IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF
            IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF
            LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161)
         END IF
 
         IF g_sfp.sfp06 = '8' THEN    #一般退料
            SELECT sfb09,sfb11,sfb08 INTO l_sfb09,l_sfb11,l_sfb08 FROM sfb_file  #已發-完工   #MOD-8B0230 add sfb11,sfb08
            WHERE sfb01 = g_sfs[l_ac].sfs03   #工單
 
            SELECT sfa06,sfa161,sfa26,sfa27,sfa28,sfa05,sfa100,sfa11  #MOD-BA0193 add sfa11 #MOD-8B0230 add sfa100  #FUN-B50059
            INTO l_sfa06,l_sfa161,l_sfa26,l_sfa27,l_sfa28,l_sfa05,l_sfa100,l_sfa11 FROM sfa_file #MOD-BA0193 add sfa11 #MOD-8B0230 add l_sfa100
            WHERE sfa01 = g_sfs[l_ac].sfs03
              AND sfa03 = g_sfs[l_ac].sfs04
              AND sfa08 = g_sfs[l_ac].sfs10
              AND sfa27 = g_sfs[l_ac].sfs27    #FUN-A60095
              AND sfa012= g_sfs[l_ac].sfs012   #FUN-A60028 
              AND sfa013= g_sfs[l_ac].sfs013   #FUN-A60028
            
            SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file
            WHERE sfs01=g_sfp.sfp01 AND sfs03=g_sfs[l_ac].sfs03
            AND sfs04=g_sfs[l_ac].sfs04 AND sfs10=g_sfs[l_ac].sfs10
            AND sfs02!=g_sfs[l_ac].sfs02
 
            IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF
            IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF
            IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF
            IF cl_null(l_sfa28) THEN LET l_sfa28 = 0 END IF
            IF cl_null(l_sfa05) THEN LET l_sfa05 = 0 END IF  #MOD-7A0133 add
            IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 END IF  #MOD-8B0230 add
            IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF  #MOD-940347 add
 
            #一般退料考慮誤差率sfa100
            IF cl_null(l_sfa100) THEN LET l_sfa100 = 0 END IF
            IF g_sma.sma899 = 'Y' THEN 
               #已發/應發*生產套數*誤差率
               IF l_sfa100 = 100 THEN
                  LET l_qty = l_sfa06 - g_sfs[l_ac].sfs05-l_sfs05 
               ELSE
                  #LET l_qty = (((l_sfa06-g_sfs[l_ac].sfs05-l_sfs05)/l_sfa05) * l_sfb08 * (1+l_sfa100/100))     #MOD-940347 add #MOD-D50178
                  LET l_qty = (((l_sfa06-g_sfs[l_ac].sfs05-l_sfs05)/l_sfa05) * l_sfb08 * (100+l_sfa100/100))  #MOD-D50178
                  #已發料(扣除退料數) - 入庫數(含FQC)
                  LET l_qty = l_qty - (l_sfb09+l_sfb11)
               END IF        #No:MOD-970298 add
               #MOD-BA0193 --begin
               IF l_sfa11='S' THEN 
                  IF l_qty> 0 THEN      
                     CALL cl_err(g_sfs[l_ac].sfs04,'asf-615',1)  
                    RETURN 1
                  END IF
               ELSE
               #MOD-BA0193--end 
                  IF l_qty < 0 THEN                                                                                                                                   
                     CALL cl_err(g_sfs[l_ac].sfs04,'asf-705',1)  #No.MOD-830099 modify
                     RETURN 1
                  END IF    
               END IF #MOD-BA0193                                                                                                                                                            
            ELSE
               LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05
            END IF #MOD-8B0230 add
            IF l_sfa26 MATCHES '[3]' THEN
               SELECT sfa06,sfa28,sfa100              #MOD-8B0230 add sfa100  #FUN-B50059
                 INTO l_sfa06_t,l_sfa28_t,l_sfa100_t  #MOD-8B0230 add l_sfa100_t
                 FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03
                 AND sfa27 = g_sfs[l_ac].sfs04 AND sfa26 ='U'
               IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF
               IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF
               LET l_qty = 0
               LET l_qty = l_sfb09 - (l_sfa06_t/(l_sfa161 * l_sfa28_t))
               IF l_qty < 0 THEN
                  LET l_qty = 0
               END IF
               LET l_qty = l_sfa06 - (l_qty * l_sfa161) - l_sfs05
            END IF
            IF l_sfa26 MATCHES '[Uu]' THEN
                SELECT sfa161 INTO l_sfa161_t FROM sfa_file
                 WHERE sfa01 = g_sfs[l_ac].sfs03
                   AND sfa03 = l_sfa27
                IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
                LET l_qty = 0
                LET l_qty = l_sfa06 -
                            (l_sfb09 * l_sfa161_t*l_sfa28) - l_sfs05
 
               #--找出同一張退料單是否有其對應的被替代料也做退料動作
                SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file
                  WHERE sfs01=g_sfp.sfp01 AND sfs03=l_sfa27
                IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
               #---控管時必須考慮對應替代料的退料量
                LET l_qty = l_qty - (l_sfs05 * l_sfa161_t*l_sfa28)
            END IF
            IF l_sfa26 MATCHES '[4]' THEN
                SELECT sfa28
                  INTO l_sfa28_t
                  FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa27 = g_sfs[l_ac].sfs04 AND sfa26 ='S'
                IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF
                LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05
 
               #--找出同一張退料單是否有其對應的被替代料也做退料動作
                SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file
                  WHERE sfs01=g_sfp.sfp01 AND sfs03=l_sfa27
                IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
               #---控管時必須考慮對應替代料的退料量
                LET l_qty = l_qty - (l_sfs05 / (l_sfa161 * l_sfa28_t))
            END IF
            IF l_sfa26 MATCHES '[Ss]' THEN
               SELECT sfa06,sfa161 INTO l_sfa06_t,l_sfa161_t  #FUN-B50059
                FROM sfa_file
                WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa03 = l_sfa27
 
               IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF
               IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
               LET l_qty = 0
               LET l_qty = l_sfb09 - (l_sfa06_t * l_sfa161_t )
               IF l_qty < 0 THEN
                  LET l_qty = 0
               END IF
               LET l_qty = l_sfa06 -
                           (l_qty * l_sfa161_t * l_sfa28) - l_sfs05
            END IF
#FUN-A20037 --begin--
             IF l_sfa26 MATCHES '[8]' THEN
                SELECT sfa28
                  INTO l_sfa28_t
                  FROM sfa_file WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa27 = g_sfs[l_ac].sfs04 AND sfa26 ='Z'
                IF cl_null(l_sfa28_t) THEN LET l_sfa28_t = 0 END IF
                LET l_qty = l_sfa06 - (l_sfb09 * l_sfa161) - l_sfs05

               #--找出同一張退料單是否有其對應的被替代料也做退料動作
                SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file
                  WHERE sfs01=g_sfp.sfp01 AND sfs03=l_sfa27
                IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
               #---控管時必須考慮對應替代料的退料量
                LET l_qty = l_qty - (l_sfs05 / (l_sfa161 * l_sfa28_t))
            END IF
            IF l_sfa26 MATCHES '[Zz]' THEN
               SELECT sfa06,sfa161 INTO l_sfa06_t,l_sfa161_t   #FUN-B50059
                FROM sfa_file
                WHERE sfa01 = g_sfs[l_ac].sfs03
                  AND sfa03 = l_sfa27

               IF cl_null(l_sfa06_t) THEN LET l_sfa06_t = 0 END IF
               IF cl_null(l_sfa161_t) THEN LET l_sfa161_t = 0 END IF
               LET l_qty = 0
               LET l_qty = l_sfb09 - (l_sfa06_t * l_sfa161_t )
               IF l_qty < 0 THEN
                  LET l_qty = 0
               END IF
               LET l_qty = l_sfa06 -
                           (l_qty * l_sfa161_t * l_sfa28) - l_sfs05
            END IF
#FUN-A20037 --end--
 
#l_sfa05 < 0 表示工單備料輸入負數-->要退料
            IF l_sfa05 < 0 THEN
               LET l_qty = (l_sfa05* -1) - l_sfs05                                                                                                                              
            END IF                                                                                                                                                    
 
            IF g_sfs[l_ac].sfs05 > l_qty AND g_sma.sma899 ='N' THEN   #MOD-8B0230 add sma899                                                                                                                                
               CALL cl_err(' ','asf-705',1)
               RETURN 1
            END IF
        END IF
 
      END IF
   END IF
   IF NOT cl_null(g_sfs[l_ac].sfs06) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_sfs[l_ac].sfs06
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_sfs[l_ac].sfs06,"",STATUS,"","gfe:",1)  #No.FUN-660128
         RETURN 2
      END IF
      SELECT COUNT(*) INTO l_n FROM sfa_file
       WHERE sfa01=g_sfs[l_ac].sfs03
         AND (sfa03=g_sfs[l_ac].sfs04 OR sfa27=b_sfs.sfs27)
         AND sfa12=g_sfs[l_ac].sfs06
      IF l_n=0 THEN
         CALL cl_err('sel sfa',100,0)
         RETURN 2
      END IF
   END IF
   RETURN 0
END FUNCTION
 
FUNCTION i501_imgg10()
DEFINE   l_imgg10_1  LIKE imgg_file.imgg10,
         l_imgg10_2  LIKE imgg_file.imgg10,
         l_factor_2  LIKE sfs_file.sfs34,
         l_factor_1  LIKE sfs_file.sfs31
    SELECT imgg10 INTO l_imgg10_2
      FROM imgg_file
     WHERE imgg01=g_sfs[l_ac].sfs04
       AND imgg02=g_sfs[l_ac].sfs07
       AND imgg03=g_sfs[l_ac].sfs08
       AND imgg04=g_sfs[l_ac].sfs09
       AND imgg09=g_sfs[l_ac].sfs33
    CALL s_du_umfchk(g_sfs[l_ac].sfs04,'','','',
                     g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs33,g_ima906)
         RETURNING g_errno,l_factor_2
    IF g_sfs[l_ac].sfs33 <> g_sfs[l_ac].sfs30 THEN
       SELECT imgg10 INTO l_imgg10_1
         FROM imgg_file
        WHERE imgg01=g_sfs[l_ac].sfs04
          AND imgg02=g_sfs[l_ac].sfs07
          AND imgg03=g_sfs[l_ac].sfs08
          AND imgg04=g_sfs[l_ac].sfs09
          AND imgg09=g_sfs[l_ac].sfs30
       CALL s_du_umfchk(g_sfs[l_ac].sfs04,'','','',
                        g_sfs[l_ac].sfs06,g_sfs[l_ac].sfs30,g_ima906)
            RETURNING g_errno,l_factor_1
       LET g_sfs[l_ac].img10 = l_imgg10_1 * l_factor_1 + l_imgg10_2 * l_factor_2
    ELSE
       LET g_sfs[l_ac].img10 = l_imgg10_2 * l_factor_2
    END IF
END FUNCTION
 
FUNCTION i501_planissue()
DEFINE l_sre RECORD
                sre03 LIKE sre_file.sre03,
                sre04 LIKE sre_file.sre04,
                sre06 LIKE sre_file.sre06,
                sre07 LIKE sre_file.sre07,
                sre051 LIKE sre_file.sre051 #FUN-870097 add sre051
             END RECORD
DEFINE l_sfq RECORD LIKE sfq_file.*
DEFINE l_wc1,l_wc2 STRING
DEFINE l_eci06 LIKE eci_file.eci06,
       l_ecg02 LIKE ecg_file.ecg02,
       sre06b,sre06e LIKE sre_file.sre06,
       sre03 LIKE sre_file.sre03,
       sre05 LIKE sre_file.sre05,
       sre04 LIKE sre_file.sre04
 
   OPEN WINDOW i501_plan AT 2,2 WITH FORM "asf/42f/asfi501d"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("asfi501d")
 
   LET sre06b=TODAY
   LET sre06e=TODAY
   DISPLAY sre06b,sre06e
   INPUT BY NAME sre06b,sre06e,sre03
 
       AFTER FIELD sre03
          IF NOT cl_null(sre03) THEN
             CALL i100_sre03(sre03)
             IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET sre03=''
               LET l_eci06=''
               DISPLAY sre03
               DISPLAY l_eci06 TO FORMONLY.eci06
               NEXT FIELD sre03
             END IF
             LET l_eci06=''
             SELECT eci06 INTO l_eci06 FROM eci_file
               WHERE eci01=sre03
             DISPLAY l_eci06 TO FORMONLY.eci06
          ELSE
             DISPLAY '' TO FORMONLY.eci06
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sre03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eci"
                CALL cl_create_qry() RETURNING sre03
                DISPLAY sre03
                NEXT FIELD sre03
             OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i501_plan
      RETURN
   END IF
 
   LET l_wc1=''
   IF NOT sre06b IS NULL THEN
      LET sre06b=sre06b USING 'YYYY-MM-DD'
      LET l_wc1=l_wc1 CLIPPED," AND sre06>='",sre06b,"'"
   END IF
 
   IF NOT sre06e IS NULL THEN
      LET sre06b=sre06e USING 'YYYY-MM-DD'
      LET l_wc1=l_wc1 CLIPPED," AND sre06<='",sre06e,"'"
   END IF
 
   IF NOT cl_null(sre03) THEN
      LET l_wc1=l_wc1 CLIPPED," AND sre03='",sre03,"'"
   END IF
 
   CONSTRUCT BY NAME l_wc2 ON sre05,sre04
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
         CASE
              WHEN INFIELD(sre05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecg"
                 LET g_qryparam.default1 = sre05
                 CALL cl_create_qry() RETURNING sre05
                 DISPLAY sre05 TO sre05      #No.TQC-740331
                 NEXT FIELD sre05
              WHEN INFIELD(sre04)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima17"
#                LET g_qryparam.default1 = sre04
#                CALL cl_create_qry() RETURNING sre04
                 CALL q_sel_ima(FALSE, "q_ima17","",sre04,"","","","","",'' ) 
                  RETURNING sre04  
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY sre04 TO sre04      #No.TQC-740331
                 NEXT FIELD sre04
             OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i501_plan
      RETURN
   END IF
 
   IF cl_null(l_wc2) THEN
      LET l_wc2=" 1=1"
   END IF
 
   LET l_wc1=l_wc1 CLIPPED," AND ",l_wc2 CLIPPED
 
   LET l_wc1="SELECT sre03,sre04,sre06,SUM(sre07),sre051 FROM sre_file WHERE 1=1",l_wc1 CLIPPED, #FUN-870097 add sre051
             " AND sre07<>0 AND sre07 IS NOT NULL",
             " GROUP BY sre03,sre04,sre06,sre051"   #FUN-870097 add sre051
 
   PREPARE i501_plan_c_pre FROM l_wc1
   DECLARE i501_plan_c CURSOR FOR i501_plan_c_pre
 
   LET g_success='N'
   BEGIN WORK
   FOREACH i501_plan_c INTO l_sre.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('',STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_sfq.sfq01=g_sfp.sfp01
      LET l_sfq.sfq02=l_sre.sre04
      LET l_sfq.sfq03=l_sre.sre07
      LET l_sfq.sfq04=l_sre.sre03
      LET l_sfq.sfq05=l_sre.sre06
      IF g_sma.sma118 = 'Y' AND g_sfp.sfp06 MATCHES '[ABC]' THEN  #No.TQC-890051
         LET l_sfq.sfq07=l_sre.sre051 
      ELSE
      	 LET l_sfq.sfq07=' '
      END IF
      IF cl_null(l_sfq.sfq05) OR (l_sfq.sfq05=0) THEN
         LET l_sfq.sfq05=g_sfp.sfp02
      END IF

    #FUN-B20095 -------Begin---------
      IF cl_null(l_sfq.sfq012) THEN
         LET l_sfq.sfq012 = ' '
      END IF 
    #FUN-B20095 -------End-----------
 
      LET l_sfq.sfqplant = g_plant #FUN-980008 add
      LET l_sfq.sfqlegal = g_legal #FUN-980008 add

      IF l_sfq.sfq014 IS NULL THEN LET l_sfq.sfq014=' ' END IF #FUN-C70014 add 
      INSERT INTO sfq_file VALUES (l_sfq.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","sfq_file",l_sfq.sfq01,l_sfq.sfq02,STATUS,"","",1)  #No.FUN-660128
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET g_success='Y'
   END FOREACH
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW i501_plan
   CALL i501_d_fill(' 1=1')
END FUNCTION
 
FUNCTION i100_sre03(p_sre03) #FUN-5C0114 add
  DEFINE p_sre03     LIKE sre_file.sre03,
         l_eciacti   LIKE eci_file.eciacti
 
  LET g_errno = ' '
  SELECT eciacti INTO l_eciacti
     FROM eci_file WHERE eci01 = p_sre03
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_eciacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
#圖形顯示
FUNCTION i501_pic()
   IF g_sfp.sfpconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF

  #CALL cl_set_field_pic(g_sfp.sfpconf,"",g_sfp.sfp04,"",g_void,"") #FUN-AB0001 mark
  #FUN-AB0001 add str -------
   IF g_sfp.sfp15 = '1' THEN
       LET g_chr2 = 'Y'
   ELSE
       LET g_chr2 = 'N'
   END IF
   CALL cl_set_field_pic(g_sfp.sfpconf,g_chr2,g_sfp.sfp04,"",g_void,"")
  #FUN-AB0001 add end -------
END FUNCTION
 

FUNCTION i501_get_sfs930(p_sfs03)
DEFINE p_sfs03 LIKE sfs_file.sfs03
DEFINE l_sfb98 LIKE sfb_file.sfb98 
   CASE 
      WHEN g_sfp.sfp06 MATCHES '[ABC]'  #For ASR
         RETURN s_costcenter(g_sfp.sfp07)
      OTHERWISE  #For ASF
         SELECT sfb98 INTO l_sfb98 FROM sfb_file
                                  WHERE sfb01=p_sfs03
         IF SQLCA.sqlcode THEN
            LET l_sfb98=NULL
         END IF
         RETURN s_costcenter(l_sfb98)
   END CASE
END FUNCTION
 
FUNCTION i501_mu_ui()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("sfs30,sfs32,sfs33,sfs35",FALSE)
       CALL cl_set_comp_visible("sfs05,sfs06",TRUE)
    ELSE
       CALL cl_set_comp_visible("sfs30,sfs32,sfs33,sfs35",TRUE)
       CALL cl_set_comp_visible("sfs05,sfs06",FALSE)
    END IF
    CALL cl_set_comp_visible("sfs31,sfs34",FALSE)
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs35",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs30",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("sfs32",g_msg CLIPPED)
    END IF
   #DEV-D30026 add str---------------------
    IF g_aza.aza131 = 'Y' THEN
       CALL cl_set_comp_visible("barcode_qty_allot", TRUE)
       CALL cl_set_act_visible("barcode_qty_allot", TRUE)
    ELSE
       CALL cl_set_comp_visible("barcode_qty_allot", FALSE)
       CALL cl_set_act_visible("barcode_qty_allot", FALSE)
    END IF
   #DEV-D30026 add end----------------------

   #DEV-D40011 add str----------------------
   #將此按鈕隱藏,待後續流程完成
    CALL cl_set_comp_visible("barcode_qty_allot", FALSE)
    CALL cl_set_act_visible("barcode_qty_allot", FALSE)
   #DEV-D40011 add end----------------------
END FUNCTION
 
FUNCTION i501_b_i_move_back(l_i)
   DEFINE l_i LIKE type_file.num10
   LET b_sfq.sfq01  = g_sfp.sfp01
   LET b_sfq.sfq02  = g_sfq[l_i].sfq02   
   LET b_sfq.sfq04  = g_sfq[l_i].sfq04   
   LET b_sfq.sfq05  = g_sfq[l_i].sfq05 
   LET b_sfq.sfq07  = g_sfq[l_i].sfq07     #No.FUN-870097  
   LET b_sfq.sfq08  = g_sfq[l_i].sfq08     #No.FUN-940008 add
   LET b_sfq.sfq03  = g_sfq[l_i].sfq03 
   IF cl_null(b_sfq.sfq05) OR (b_sfq.sfq05=0) THEN
      LET b_sfq.sfq05=g_sfp.sfp02
   END IF
#FUN-B20095 ------------Begin------------- 
   LET b_sfq.sfq012 = g_sfq[l_i].sfq012
   IF cl_null(b_sfq.sfq012) THEN
      LET b_sfq.sfq012 = ' '
   END IF
#FUN-B20095 ------------End---------------
#FUN-C70014 ---------begin---------------
   LET b_sfq.sfq014 = g_sfq[l_i].sfq014
   IF cl_null(b_sfq.sfq014) THEN
      LET b_sfq.sfq014 = ' '
   END IF
#FUN-C70014 ---------end-----------------
   LET b_sfq.sfqud01 = g_sfq[l_i].sfqud01
   LET b_sfq.sfqud02 = g_sfq[l_i].sfqud02
   LET b_sfq.sfqud03 = g_sfq[l_i].sfqud03
   LET b_sfq.sfqud04 = g_sfq[l_i].sfqud04
   LET b_sfq.sfqud05 = g_sfq[l_i].sfqud05
   LET b_sfq.sfqud06 = g_sfq[l_i].sfqud06
   LET b_sfq.sfqud07 = g_sfq[l_i].sfqud07
   LET b_sfq.sfqud08 = g_sfq[l_i].sfqud08
   LET b_sfq.sfqud09 = g_sfq[l_i].sfqud09
   LET b_sfq.sfqud10 = g_sfq[l_i].sfqud10
   LET b_sfq.sfqud11 = g_sfq[l_i].sfqud11
   LET b_sfq.sfqud12 = g_sfq[l_i].sfqud12
   LET b_sfq.sfqud13 = g_sfq[l_i].sfqud13
   LET b_sfq.sfqud14 = g_sfq[l_i].sfqud14
   LET b_sfq.sfqud15 = g_sfq[l_i].sfqud15
 
   LET b_sfq.sfqplant = g_plant #FUN-980008 add
   LET b_sfq.sfqlegal = g_legal #FUN-980008 add
END FUNCTION
 
FUNCTION i501_sfq04(p_sfq04)
DEFINE p_sfq04    LIKE sfq_file.sfq04
DEFINE l_eciacti  LIKE eci_file.eciacti
DEFINE l_ecdacti  LIKE ecd_file.ecdacti
DEFINE l_errno    LIKE type_file.chr10
    
    LET l_errno = ''
    IF g_sfp.sfp06 MATCHES '[ABC]' THEN
       SELECT eciacti INTO l_eciacti FROM eci_file
        WHERE eci01=p_sfq04 
    ELSE
       SELECT ecdacti INTO l_ecdacti FROM ecd_file
        WHERE ecd01 = p_sfq04
    END IF
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_eciacti     = 'N'  LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION
 
FUNCTION i501_sfs10(p_sfs10)
DEFINE p_sfs10     LIKE sfs_file.sfs10
DEFINE l_ecdacti   LIKE ecd_file.ecdacti
DEFINE l_errno     LIKE type_file.chr10
      
    LET l_errno =''
    SELECT ecdacti INTO l_ecdacti FROM ecd_file 
     WHERE ecd01 = p_sfs10
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_ecdacti = 'N'      LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION 
 
#此函數用于計算退料未過賬量,若有需要可直接擴展為未過賬量計算。
FUNCTION i501_totsfs05(p_sfp01,p_sfp06,p_sfs02,p_sfs03,p_sfs04,p_sfs06,p_sfs10,p_sfs27)  #No.MOD-790175 modify#FUN-9B0149
DEFINE   l_tot        LIKE sfs_file.sfs05    
DEFINE   p_sfp01      LIKE sfp_file.sfp01
DEFINE   p_sfs02      LIKE sfs_file.sfs02
DEFINE   p_sfs03      LIKE sfs_file.sfs03
DEFINE   p_sfs04      LIKE sfs_file.sfs04
DEFINE   p_sfs06      LIKE sfs_file.sfs06    #No.MOD-790175 add
DEFINE   p_sfs10      LIKE sfs_file.sfs10    #No.MOD-790175 add
DEFINE   p_sfp06      LIKE sfp_file.sfp06
DEFINE   p_sfs27      LIKE sfs_file.sfs27   #FUN-9B0149
 
 
    LET l_tot = 0
   #MOD-B70244---modify---start--- 
   #SELECT SUM(sfs05) INTO l_tot  FROM sfs_file,sfp_file
   # WHERE sfs01  = sfp01
   #   AND sfp04 != 'Y'
   #   AND sfp06  = p_sfp06
   #   AND ((sfs01 != p_sfp01) 
   #     OR (sfs01 = p_sfp01 AND sfs02 != p_sfs02))
   #   AND sfs03  = p_sfs03
   #   AND sfs04  = p_sfs04
   #   AND sfs06  = p_sfs06   #No.MOD-790175 add 
   #   AND sfs10  = p_sfs10   #No.MOD-790175 add
   #   AND sfs27  = p_sfs27   #FUN-9B0149
   #   AND sfpconf != 'X'     #MOD-8A0258 add
    IF g_sfp.sfp06 MATCHES '[68]' THEN
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
    ELSE
   #MOD-CA0099---mark---start---
      #SELECT SUM(sfs05) INTO l_tot  FROM sfs_file,sfp_file
      # WHERE sfs01  = sfp01
      #   AND sfp04 != 'Y'
      #   AND sfp06  = p_sfp06
      #   AND ((sfs01 != p_sfp01)
      #    OR (sfs01 = p_sfp01 AND sfs02 != p_sfs02))
      #   AND sfs03  = p_sfs03
      #   AND sfs27  = p_sfs27
      #   AND sfs04  = p_sfs04
      #   AND sfs06  = p_sfs06
      #   AND sfs10  = p_sfs10
      #   AND sfpconf != 'X'
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
   #MOD-CA0099---mark---end---
    END IF
   #MOD-B70244---modify----end----
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfs_file",g_sfs[l_ac].sfs05,"",SQLCA.sqlcode,"","sel sum(sfs05)",1)
       LET l_tot = 0
    END IF
    IF cl_null(l_tot) THEN
       LET l_tot=0
    END IF
 
    RETURN l_tot
     
 
END FUNCTION
 
#數量 : 挑選完數量後, 回寫參考異動數量
#       1 異動數量(sfs32) : 本次發料之數量
#       2 參考數量 (sfs35): 本次發料之參考數量
#         2.1料件狀態(imaicd04) <> '1.未測Wafer'和 0.BODY
#            料件狀態(imaicd04) <> '2.已測Wafer'
#            -->與異動數量同
FUNCTION i501_ind_icd_set_value()
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04 LIKE imaicd_file.imaicd04
 
   #IF g_sfp.sfp06 NOT MATCHES '[16]' THEN RETURN END IF   #只針對成套發退料 #CHI-A70060 mark
 
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04
        FROM imaicd_file,ima_file          #CHI-940010 add ima_file by hellen
       WHERE imaicd00 = g_sfs[l_ac].sfs04
         AND ima01 = imaicd00              #CHI-940010 add by hellen
     #若料號為單一單位, 如IC料號, 出入庫不回寫單位二級單位二數量
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
         IF l_imaicd04 NOT MATCHES '[012]' THEN
            LET g_sfs[l_ac].sfs33 = g_sfs[l_ac].sfs30 #單位
            LET g_sfs[l_ac].sfs35 = g_sfs[l_ac].sfs32 #數量
            LET g_sfs[l_ac].sfs34 = g_sfs[l_ac].sfs32/g_sfs[l_ac].sfs35
 
            LET b_sfs.sfs33 = g_sfs[l_ac].sfs33
            LET b_sfs.sfs35 = g_sfs[l_ac].sfs35
            LET b_sfs.sfs34 = g_sfs[l_ac].sfs34
            DISPLAY BY NAME g_sfs[l_ac].sfs33,
                            g_sfs[l_ac].sfs34,
                            g_sfs[l_ac].sfs35
         END IF
      END IF
   END IF
END FUNCTION
 
#更新die數
#當料號為wafer段時imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
#當料號為wafer段時imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量。
FUNCTION i501_ind_icd_upd_dies(l_dies)
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04 LIKE imaicd_file.imaicd04
         #,l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061 #FUN-BA0058 mark    
   DEFINE l_dies     LIKE sfs_file.sfs05   #FUN-810038
 
   #IF g_sfp.sfp06 NOT MATCHES '[16]' THEN RETURN END IF   #只針對成套發退料 #CHI-A70060 mark
 
   BEGIN WORK            #FUN-B70061
   LET g_success = 'Y'   #FUN-B70061
   
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04   #FUN-B70061 add imaicd08 #FUN-BA0058 mark imaicd08
       FROM imaicd_file
       WHERE imaicd00 = g_sfs[l_ac].sfs04
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04
        FROM imaicd_file,ima_file          #CHI-940010 add ima_file by hellen
       WHERE imaicd00 = g_sfs[l_ac].sfs04
         AND ima01 = imaicd00              #CHI-940010 add by hellen
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[13]' THEN
         IF l_imaicd04 MATCHES '[012]' THEN
            LET g_sfs[l_ac].sfs35 = l_dies             #數量
            LET g_sfs[l_ac].sfs34 = g_sfs[l_ac].sfs32/g_sfs[l_ac].sfs35
            #BEGIN WORK   #FUN-B70061 mark
            UPDATE sfs_file set sfs34 = g_sfs[l_ac].sfs34,
                                sfs35 = g_sfs[l_ac].sfs35
             WHERE sfs01=g_sfp.sfp01 AND sfs02=g_sfs[l_ac].sfs02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_sfs[l_ac].sfs35 =  b_sfs.sfs35
               LET g_sfs[l_ac].sfs34 =  b_sfs.sfs34
               #ROLLBACK WORK        #FUN-B70061 mark
               LET g_success = 'N'   #FUN-B70061 
            ELSE 
               LET b_sfs.sfs35 = g_sfs[l_ac].sfs35
               LET b_sfs.sfs34 = g_sfs[l_ac].sfs34
               #COMMIT WORK   #FUN-B70061 mark
            END IF
            DISPLAY BY NAME g_sfs[l_ac].sfs34, g_sfs[l_ac].sfs35
         END IF
      END IF
   END IF
   #FUN-B70061 --START--
   #FUN-BA0058 --START mark--
   #IF cl_null(l_imaicd08) THEN
   #    SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file 
   #     WHERE imaicd00 = g_sfs[l_ac].sfs04
   #END IF
   #
   #IF l_imaicd08 = 'Y' THEN
   #FUN-BA0058 --END mark--
   IF s_icdbin(g_sfs[l_ac].sfs04) THEN   #FUN-BA0058
      CASE
         WHEN g_argv1 MATCHES '[2]' #入庫
            LET g_sql = "SELECT ida15 FROM ida_file",   #FUN-BC0109 del ida16
                           " WHERE ida07 = '", g_sfp.sfp01, "'",
                           " AND ida08 =", g_sfs[l_ac].sfs02                           
         WHEN g_argv1 MATCHES '[1]'   #出庫
            LET g_sql = "SELECT idb14 FROM idb_file",   #FUN-BC0109 del idb15
                           " WHERE idb07 = '", g_sfp.sfp01, "'",
                           " AND idb08 =", g_sfs[l_ac].sfs02            
      END CASE   
      DECLARE i501_upd_dia_c CURSOR FROM g_sql            
      OPEN i501_upd_dia_c                                       
      FETCH i501_upd_dia_c INTO g_sfs[l_ac].sfsiicd029   #FUN-BC0109 del ,g_sfs[l_ac].sfsiicd028
      
      #串接Date Code值
      CALL s_icdfun_datecode(g_argv1,g_sfp.sfp01,g_sfs[l_ac].sfs02) 
                               RETURNING g_sfs[l_ac].sfsiicd028   #FUN-BC0109
                               
      UPDATE sfsi_file set sfsiicd029 = g_sfs[l_ac].sfsiicd029,
       sfsiicd028 = g_sfs[l_ac].sfsiicd028
       WHERE sfsi01=g_sfp.sfp01 AND sfsi02=g_sfs[l_ac].sfs02 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_sfs[l_ac].sfsiicd029 = b_sfsi.sfsiicd029
         LET g_sfs[l_ac].sfsiicd028 = b_sfsi.sfsiicd028
         LET g_success  = 'N'
      ELSE
         LET b_sfsi.sfsiicd029 = g_sfs[l_ac].sfsiicd029
         LET b_sfsi.sfsiicd028 = g_sfs[l_ac].sfsiicd028
         LET g_success  = 'Y'
      END IF 
      DISPLAY BY NAME g_sfs[l_ac].sfsiicd029, g_sfs[l_ac].sfsiicd028       
   END IF
   
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   #FUN-B70061 --END--
END FUNCTION
 
FUNCTION i501_ind_icd_chk_icd()
    LET g_cnt = 0
    LET g_errno = ' '
   #CASE WHEN g_sfp.sfp06 = '1'   #發料 #CHI-A70060 mark
    CASE WHEN g_sfp.sfp06 MATCHES '[1234]'   #發料 #CHI-A70060
              SELECT COUNT(*) INTO g_cnt FROM idb_file
                 WHERE idb07 = g_sfp.sfp01
                   AND idb08 = g_sfs_t.sfs02
        #WHEN g_sfp.sfp06 = '6'   #退料 #CHI-A70060 mark
         WHEN g_sfp.sfp06 MATCHES '[6789]'   #退料 #CHI-A70060
              SELECT COUNT(*) INTO g_cnt FROM ida_file
                 WHERE ida07 = g_sfp.sfp01
                   AND ida08 = g_sfs_t.sfs02
    END CASE
    IF g_cnt > 0 THEN
       LET g_errno = 'aic-113'
    ELSE
       LET g_errno = SQLCA.SQLCODE USING '-------'
    END IF
END FUNCTION

#TQC-C20098--begin
#修改數量,若料號有展明細(imaicd08) ='Y',
#則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息
#TQC-C20098--begin
#FUNCTION i501_ind_icd_chk_icdqty()
#   #DEFINE l_imaicd04   LIKE imaicd_file.imaicd04,   #FUN-BA0058 mark
#   #       l_imaicd08   LIKE imaicd_file.imaicd08    #FUN-BA0058 mark
#   DEFINE l_type       LIKE type_file.num10
#   DEFINE l_flag       LIKE type_file.num10 
# 
#   LET l_flag = TRUE    #No.MOD-890023 add
# 
#   #CHI-A70060 mark --start--
#   #IF g_sfp.sfp06 NOT MATCHES '[16]' THEN #只針對成套發退料
#   #   RETURN TRUE #No.FUN-830132 add
#   #END IF
#   #CHI-A70060 mark --end--
#   #FUN-BA0058 --START mark--
#   #SELECT imaicd08,imaicd04 INTO l_imaicd08,l_imaicd04
#   #   FROM imaicd_file
#   #  WHERE imaicd00 = g_sfs[l_ac].sfs04
#   # 
#   #IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN
#   #FUN-BA0058 --END mark--
#   IF s_icdbin(g_sfs[l_ac].sfs04) THEN   #FUN-BA0058
#     #IF g_sfp.sfp06 = '1' THEN #CHI-A70060 mark
#      IF g_sfp.sfp06 MATCHES '[1234]' THEN #CHI-A70060
#         LET l_type = -1   #發料出庫
#      ELSE
#         LET l_type = 1    #退料入庫
#      END IF
#      CALL s_icdchk(l_type, g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
#                             g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
#                             g_sfs[l_ac].sfs05, g_sfp.sfp01,
#                             g_sfs[l_ac].sfs02, g_sfp.sfp02,'')  #FUN-B80119--傳入p_plant參數''---
#           RETURNING l_flag
#   END IF
#   RETURN l_flag     #No.FUN-830132 add
#END FUNCTION

#p_flag='1' 对当前行检察, p_flag='2' 对单身所有资料做检察 
FUNCTION i501_ind_icd_chk_icdqty(p_flag)
   DEFINE l_type       LIKE type_file.num10
   DEFINE l_flag       LIKE type_file.num10 
   DEFINE p_flag       LIKE type_file.chr1 
   DEFINE l_sfs        RECORD LIKE sfs_file.* 
   
   LET l_flag = TRUE    
   IF cl_null(p_flag) THEN 
      LET p_flag='2' 
   END IF 
   IF p_flag='1' THEN
      IF l_ac=0 OR cl_null(l_ac) THEN 
         RETURN FALSE 
      END IF  
      IF s_icdbin(g_sfs[l_ac].sfs04) THEN   
         IF g_sfp.sfp06 MATCHES '[1234]' THEN 
           LET l_type = -1   #發料出庫
         ELSE
           LET l_type = 1    #退料入庫
         END IF
         CALL s_icdchk(l_type, g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
                               g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
                               g_sfs[l_ac].sfs05, g_sfp.sfp01,
                               g_sfs[l_ac].sfs02, g_sfp.sfp02,
                               '')  
             RETURNING l_flag
      END IF
      RETURN l_flag
   END IF     
   
   IF p_flag='2' THEN 
      DECLARE i501_icdchk_cl CURSOR FOR SELECT * FROM sfs_file WHERE sfs01=g_sfp.sfp01
      FOREACH i501_icdchk_cl INTO l_sfs.*
         IF s_icdbin(l_sfs.sfs04) THEN   
            IF g_sfp.sfp06 MATCHES '[1234]' THEN 
               LET l_type = -1   #發料出庫
            ELSE
               LET l_type = 1    #退料入庫
            END IF
            CALL s_icdchk(l_type,l_sfs.sfs04,l_sfs.sfs07,
                               l_sfs.sfs08, l_sfs.sfs09,
                               l_sfs.sfs05, g_sfp.sfp01,
                               l_sfs.sfs02, g_sfp.sfp02,
                               '')  
            RETURNING l_flag
            IF NOT l_flag THEN 
               RETURN FALSE 
            END IF 
         END IF
      END FOREACH 
      
      RETURN TRUE 
   END IF 
   
END FUNCTION
 
#TQC-C20098--end
 
FUNCTION i501_ins_rvbs(l_sfs02,l_sfs03,l_sfs04)
   DEFINE l_rvbs     RECORD LIKE rvbs_file.*
   DEFINE l_c        LIKE type_file.num5
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022
   DEFINE l_sfe02    LIKE sfe_file.sfe02
   DEFINE l_sfs02    LIKE sfs_file.sfs02
   DEFINE l_sfs03    LIKE sfs_file.sfs03
   DEFINE l_sfs04    LIKE sfs_file.sfs04
 
   IF g_sfp.sfp06 NOT MATCHES '[6789B]' THEN
      RETURN
   END IF
   IF g_prog = 'asfi520' THEN
      IF g_sfp.sfp06 = '6' THEN LET g_prog = 'asfi526' END IF
      IF g_sfp.sfp06 = '7' THEN LET g_prog = 'asfi527' END IF
      IF g_sfp.sfp06 = '8' THEN LET g_prog = 'asfi528' END IF
      IF g_sfp.sfp06 = '9' THEN LET g_prog = 'asfi529' END IF
   END IF
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = l_sfs04
      AND imaacti = "Y"
   
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      DECLARE i501_g_sfs CURSOR FOR SELECT sfe02 FROM sfe_file
                                     WHERE sfe01 = l_sfs03
                                       AND sfe07 = l_sfs04
                                       AND sfe06 IN ('1','2','3','4','A','C')
      
      LET l_rvbs022 = 0
 
      FOREACH i501_g_sfs INTO l_sfe02
         IF STATUS THEN
            CALL cl_err('sfs',STATUS,1)
         END IF
      
         DECLARE i501_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                        WHERE rvbs01 = l_sfe02
                                          AND rvbs021 = l_sfs04
         
         FOREACH i501_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
         
            LET l_rvbs.rvbs00 = g_prog       #程式代號
            LET l_rvbs.rvbs01 = g_sfp.sfp01
            LET l_rvbs.rvbs02 = l_sfs02
         
            IF cl_null(l_rvbs.rvbs10) THEN
               LET l_rvbs.rvbs10 = 0
            END IF
         
            LET l_rvbs.rvbs10 = l_rvbs.rvbs10 + l_rvbs.rvbs06
         
            LET l_rvbs.rvbs06 = 0
         
#TQC-B90236----add--begin----
            IF g_sfp.sfp06 MATCHES '[6789B]' THEN
               LET l_rvbs.rvbs09 = 1
            END IF
#TQC-B90236----add--end-----
            UPDATE rvbs_file SET rvbs10 = l_rvbs.rvbs10
             WHERE rvbs00 = l_rvbs.rvbs00
               AND rvbs01 = l_rvbs.rvbs01
               AND rvbs02 = l_rvbs.rvbs02
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs04 = l_rvbs.rvbs04
               AND rvbs08 = l_rvbs.rvbs08
              #AND rvbs09 = -1
               AND rvbs09 = l_rvbs.rvbs09 # 
               AND rvbs13 = 0
         
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("upd","rvbs_file","","",SQLCA.sqlcode,"","upd rvbs",1)  #No.FUN-670008
               LET g_success='N'
            END IF
         
            IF SQLCA.SQLERRD[3]=0 THEN
               LET l_rvbs022 = l_rvbs022 + 1
               LET l_rvbs.rvbs022 = l_rvbs022
               LET l_rvbs.rvbsplant = g_plant #FUN-980008 add
               LET l_rvbs.rvbslegal = g_legal #FUN-980008 add
               INSERT INTO rvbs_file VALUES(l_rvbs.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  #No.FUN-670008
                  LET g_success='N'
               END IF
            END IF
         
         END FOREACH
      END FOREACH
   END IF
 
END FUNCTION
 
FUNCTION i501_y_chk()

  #TQC-B80091  --begin houlia
   IF NOT cl_null(g_sfp.sfp16) THEN
      CALL i501_sfp16('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_sfp.sfp16,g_errno,0)
         LET  g_success = 'N'
         RETURN
      END IF
   END IF
   #TQC-B80091  --end  houlia
 
   #FUN-AB0001  add str ---
   IF g_sfp.sfp15 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
      RETURN
   END IF
   #FUN-AB0001  add end ---

   CALL i501sub_y_chk(g_sfp.sfp01,g_action_choice)  #TQC-C60079
 
   IF g_success='N' THEN
      RETURN   
   END IF
 
      #修改數量,若料號有展明細(imaicd08) ='Y',                                                                                            
      #則需檢查發料量與所維護之數量是否一致,如果不一致,出錯誤訊息                                                                         
      #IF NOT i501_ind_icd_chk_icdqty() THEN  #TQC-C20098
      IF NOT i501_ind_icd_chk_icdqty('2') THEN  #TQC-C20098
         LET g_success='N'
         RETURN
      END IF
END FUNCTION
 
FUNCTION i501_y_upd()  
 
   CALL i501sub_y_upd(g_sfp.sfp01,g_action_choice,FALSE)  #FUN-840012  
     RETURNING g_sfp.*
 
   IF g_success='N' THEN
      RETURN  
   END IF
 
END FUNCTION
 
FUNCTION i501_sfp01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy72   LIKE smy_file.smy72    #MOD-A30031 add
   DEFINE l_smy73   LIKE smy_file.smy73    #FUN-9B0144
 
   LET g_errno = ' '
   IF cl_null(g_sfp.sfp01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_sfp.sfp01)
 
   SELECT smy72,smy73 INTO l_smy72,l_smy73 FROM smy_file  #MOD-A30031 add smy72
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-874'
   END IF
  #str MOD-A30031 add
   IF cl_null(g_sfp.sfp06) THEN
      LET g_sfp.sfp06 = l_smy72
      DISPLAY BY NAME g_sfp.sfp06
   END IF
  #end MOD-A30031 add
 
END FUNCTION
 
FUNCTION i501_sfb01(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(p_sfb01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(p_sfb01)
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy69 = l_slip
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-875'    #不可使用组合拆解对应工单单别
   END IF

END FUNCTION
#FUN-A30093
#No.FUN-9C0073    -----By chenls 10/01/04   

#FUN-A40022--begin--add--------------------------
FUNCTION i501_chk_batch_num()
    DEFINE l_sfe16a LIKE sfe_file.sfe16 
    DEFINE l_sfe16b LIKE sfe_file.sfe16 
    DEFINE l_sfe16c LIKE sfe_file.sfe16 

    LET g_errno = ''
    IF g_argv1 = '2' AND
       NOT cl_null(g_sfs[l_ac].sfs09) AND 
       NOT cl_null(g_sfs[l_ac].sfs04) 
    THEN
      #此批號已發數量
       LET l_sfe16a = 0
       SELECT SUM(sfe16) INTO l_sfe16a  
         FROM sfe_file,sfp_file
        WHERE sfe01 = g_sfs[l_ac].sfs03
          AND sfe07 = g_sfs[l_ac].sfs04
          AND sfe10 = g_sfs[l_ac].sfs09
          AND sfe02 = sfp01
          AND sfp06 IN ('1','2','3','4','A')
       IF cl_null(l_sfe16a) THEN LET l_sfe16a = 0 END IF

      #此批號已退數量
       LET l_sfe16b = 0
       SELECT SUM(sfe16) INTO l_sfe16b  
         FROM sfe_file,sfp_file
        WHERE sfe01 = g_sfs[l_ac].sfs03
          AND sfe07 = g_sfs[l_ac].sfs04
          AND sfe10 = g_sfs[l_ac].sfs09
          AND sfe02 = sfp01
          AND sfp06 IN ('6','7','8','9','B')
       IF cl_null(l_sfe16b) THEN LET l_sfe16b = 0 END IF

       LET l_sfe16c = 0
       SELECT SUM(sfs05) INTO l_sfe16c  
         FROM sfs_file
        WHERE sfs03 = g_sfs[l_ac].sfs03
          AND sfs04 = g_sfs[l_ac].sfs04
          AND sfs09 = g_sfs[l_ac].sfs09
          AND sfs01 = g_sfp.sfp01
       IF cl_null(l_sfe16c) THEN LET l_sfe16c = 0 END IF
       
       IF NOT cl_null(g_sfs_t.sfs05) THEN
          LET l_sfe16c = l_sfe16c-g_sfs_t.sfs05
       END IF
       LET l_sfe16a = l_sfe16a-l_sfe16b-l_sfe16c-g_sfs[l_ac].sfs05
       IF l_sfe16a < 0 AND g_sfs[l_ac].sfs09 <> 'X' THEN 
          #數量不可大于該批號于發料單發出批號的數量
          LET g_errno = 'aim-037'
       END IF
    END IF

END FUNCTION
#FUN-A40022--end--addd-----------------

#FUN-AB0001---add----str---
FUNCTION i501_ef()

    CALL i501sub_y_chk(g_sfp.sfp01,NULL)     #CALL 原確認的 check 段 #TQC-C60079
    IF g_success = "N" THEN
       RETURN
    END IF

    CALL aws_condition() #判斷送簽資料
    IF g_success = 'N' THEN
       RETURN
    END IF

    ##########
    # CALL aws_efcli2()
    # 傳入參數: (1)單頭資料, (2-6)單身資料
    # 回傳值  : 0 開單失敗; 1 開單成功
    ##########

    IF aws_efcli2(base.TypeInfo.create(g_sfp),base.TypeInfo.create(g_sfq),base.TypeInfo.create(g_sfs),'','','')
    THEN
       LET g_success='Y'
       LET g_sfp.sfp15='S'
       DISPLAY BY NAME g_sfp.sfp15
    ELSE
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i501_sfp16(p_cmd)  #申請人編號
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '

    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_sfp.sfp16
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
#FUN-AB0001 add end -----

#FUN-BA0050 ------------------Begin---------------------
FUNCTION i501_b_sfs09_inschk(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1                
   DEFINE l_flag          LIKE type_file.chr1               
   DEFINE l_n             LIKE type_file.num5  
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_count         LIKE type_file.num5 
   DEFINE l_factor        LIKE img_file.img21
   DEFINE l_ima159        LIKE ima_file.ima159
   DEFINE l_img10         LIKE img_file.img10      #FUN-D60094
   #BugNo:5626 控管是否為全型空白
   IF g_sfs[l_ac].sfs09 = '　' THEN #全型空白
       LET g_sfs[l_ac].sfs09 = ' '
   END IF
   IF g_sfs[l_ac].sfs09 IS NULL THEN LET g_sfs[l_ac].sfs09 =' ' END IF
   IF cl_null(g_sfs[l_ac].sfs09) AND NOT cl_null(g_sfs[l_ac].sfs04) THEN
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_sfs[l_ac].sfs04
      IF l_ima159 = '1' THEN
         CALL cl_err(g_sfs[l_ac].sfs04,'aim-034',1)
         #RETURN "sfs09"  #CHI-D50047
         RETURN "sfs07"  #CHI-D50047
      END IF
   END IF
   IF g_argv1='2' AND NOT cl_null(g_sfs[l_ac].sfs04) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM sfe_file,sfp_file
       WHERE sfe02 = sfp01
         AND sfp06 IN ('1','2','3','4','A')
         AND sfp04 = 'Y'
         AND sfe01 = g_sfs[l_ac].sfs03
         AND sfe07 = g_sfs[l_ac].sfs04
      IF l_cnt >0 AND g_sfs[l_ac].sfs09 <> 'X' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM sfe_file,sfp_file
          WHERE sfe02 = sfp01
            AND sfp06 IN ('1','2','3','4','A')
            AND sfp04 = 'Y'
            AND sfe01 = g_sfs[l_ac].sfs03
            AND sfe07 = g_sfs[l_ac].sfs04
            AND sfe10 = g_sfs[l_ac].sfs09
         IF cl_null(l_cnt) OR l_cnt = 0 THEN
            CALL cl_err(g_sfs[l_ac].sfs04,'aim-036',1)
            RETURN "sfs09" 
         END IF
      END IF
   END IF
   #若已有idb存在不可修改
   IF g_sfp.sfp06 MATCHES '[12346789]' THEN #CHI-A70060
      IF p_cmd = 'u' AND NOT cl_null(g_sfs[l_ac].sfs09) THEN
         IF g_sfs_t.sfs09 <> g_sfs[l_ac].sfs09 THEN
            CALL i501_ind_icd_chk_icd()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_sfs[l_ac].sfs09 = g_sfs_t.sfs09
               RETURN "sfs09"
            END IF
         END IF
      END IF
   END IF
   IF NOT s_icdout_holdlot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,
                           g_sfs[l_ac].sfs08,g_sfs[l_ac].sfs09) THEN
      RETURN "sfs09"
   END IF
   SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
     FROM img_file
    WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
      AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
   IF g_argv1=1 AND STATUS THEN
     IF g_sma.sma93="Y" THEN        #FUN-B80093 add         #MOD-C10100         #TQC-C10033 unmark
         #再檢查該倉庫是否為VMI結算倉儲,若不是顯示錯誤訊息
         SELECT COUNT(*) INTO l_n FROM pmc_file
           WHERE pmc917=g_sfs[l_ac].sfs07   #VMI結算倉庫
           AND pmc918=g_sfs[l_ac].sfs08   #VMI結算儲位
         IF l_n = 0 THEN
            #FUN-C80107 modfiy begin----------------------------------121024
            #CALL cl_err('','asf-390',0)
            #RETURN "sfs07"
           #FUN-D30024--modify--str--
           #INITIALIZE g_sma894 TO NULL
           #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[l_ac].sfs07) RETURNING g_sma894
           #IF g_sma894 = 'N' THEN
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
            IF g_imd23 = 'N' THEN
           #FUN-D30024--modify--end--
               CALL cl_err('','asf-390',0)
               RETURN "sfs07"
            ELSE
               IF g_sma.sma892[3,3] = 'Y' THEN
                  IF NOT cl_confirm('mfg1401') THEN  RETURN "sfs07" END IF
               END IF
               CALL s_add_img(g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
                              g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
                              g_sfp.sfp01,       g_sfs[l_ac].sfs02,
                              g_sfp.sfp02)
               IF g_errno='N' THEN RETURN "sfs07" END IF
               SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
                 FROM img_file
                WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                  AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
            END IF
            #FUN-C80107 modfiy end-------------------------------------
         END IF
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
       ELSE                              #FUN-B80093 add
          #TQC-D40001--add--str--
          INITIALIZE g_imd23 TO NULL
          CALL s_inv_shrt_by_warehouse(g_sfs[l_ac].sfs07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
          IF g_imd23 = 'N' THEN
             CALL cl_err('','asf-390',0)
             RETURN "sfs07"
          ELSE
             IF g_sma.sma892[3,3] = 'Y' THEN
                IF NOT cl_confirm('mfg1401') THEN  RETURN "sfs07" END IF
             END IF
             CALL s_add_img(g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
                            g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
                            g_sfp.sfp01,       g_sfs[l_ac].sfs02,
                            g_sfp.sfp02)
             IF g_errno='N' THEN RETURN "sfs07" END IF
             SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
               FROM img_file
              WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
                AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
          END IF
          #TQC-D40001--add--end--
          #CALL cl_err('','asf-390',0)    #FUN-B80093 add  #TQC-D40001 mark
          #RETURN "sfs07"                 #FUN-B80093 add  #TQC-D40001 mark
       END IF                            #FUN-B80093 add
 #MOD-C10100 --end--
#TQC-C10033 --unmark
   END IF
   IF g_argv1=2 AND STATUS=100 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF cl_null(g_sfs[l_ac].sfs07) THEN RETURN "sfs07" END IF   #MOD-C70219 add
         IF NOT cl_confirm('mfg1401') THEN  RETURN "sfs09" END IF
      END IF
      CALL s_add_img(g_sfs[l_ac].sfs04, g_sfs[l_ac].sfs07,
                     g_sfs[l_ac].sfs08, g_sfs[l_ac].sfs09,
                     g_sfp.sfp01,       g_sfs[l_ac].sfs02,
                     g_sfp.sfp02)
     #IF g_errno='N' THEN RETURN "sfs09" END IF   #MOD-C70219 mark
     #MOD-C70219 str add-----
      IF g_errno='N' THEN
         IF cl_null(g_sfs[l_ac].sfs07) THEN
            RETURN "sfs07"
         ELSE
            return "sfs09"
         END IF
      END IF
     #MOD-C70219 end add-----
      SELECT img09,img10 INTO g_img09,g_sfs[l_ac].img10
           FROM img_file
          WHERE img01=g_sfs[l_ac].sfs04 AND img02=g_sfs[l_ac].sfs07
            AND img03=g_sfs[l_ac].sfs08 AND img04=g_sfs[l_ac].sfs09
   END IF
   IF g_sma.sma115 = 'N' THEN
      IF g_sfs[l_ac].sfs06<>g_img09 THEN
         CALL s_umfchk(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs06,g_img09)
              RETURNING l_flag,l_factor
         IF l_flag THEN
            CALL cl_err('sfs06<>img09:','asf-400',0)
            RETURN "sfs09"
         END IF
      ELSE
         LET l_factor = 1
      END IF
   END IF
#FUN-D60094 ---------- add ------------- begin -----------------
   IF issue_type = '4' THEN
      LET l_img10 = 0
      SELECT SUM(sfs05) INTO l_img10 FROM sfs_file
       WHERE sfs04 = g_sfs[l_ac].sfs04
         AND sfs07 = g_sfs[l_ac].sfs07
         AND sfs08 = g_sfs[l_ac].sfs08
         AND sfs09 = g_sfs[l_ac].sfs09
         AND sfs01 = g_sfp.sfp01
         AND sfs02 != g_sfs[l_ac].sfs02
      IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
      LET g_sfs[l_ac].img10 = g_sfs[l_ac].img10 - l_img10
   END IF
#FUN-D60094 ---------- add ------------- end -------------------
   SELECT SUM(sfs05) INTO g_sfs[l_ac].img10_alo FROM sfs_file,sfp_file #No:8247
    WHERE sfs04=g_sfs[l_ac].sfs04
      AND sfs07=g_sfs[l_ac].sfs07
      AND sfs08=g_sfs[l_ac].sfs08
      AND sfs09=g_sfs[l_ac].sfs09
      AND sfp01=sfs01 AND sfpconf!='X'
      AND sfs01 != g_sfp.sfp01   
      DISPLAY BY NAME g_sfs[l_ac].img10_alo
      DISPLAY BY NAME g_sfs[l_ac].img10
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01 = g_sfs[l_ac].sfs04   #料號
         AND img02 = g_sfs[l_ac].sfs07   #倉庫
         AND img03 = g_sfs[l_ac].sfs08   #儲位
         AND img04 = g_sfs[l_ac].sfs09   #批號
         AND img18 < g_sfp.sfp03         #過帳日  
      IF g_cnt > 0 THEN    #大於有效日期
         call cl_err('','aim-400',0)   #須修改
          RETURN "sfs07"
      END IF
   IF g_sma.sma115 = 'Y' THEN   
      CALL i501_du_default(p_cmd)
   END IF
   CALL i501_def_sfsiicd029()
   RETURN NULL
END FUNCTION

FUNCTION i501_set_required_sfs09()
DEFINE l_ima159   LIKE ima_file.ima159    
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(sfs04) THEN
      IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_sfs[l_ac].sfs04
         IF l_ima159 = '1' THEN
            CALL cl_set_comp_required("sfs09",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i501_set_no_required_sfs09()
   CALL cl_set_comp_required("sfs09",FALSE)
END FUNCTION

FUNCTION i501_set_no_entry_sfs09()
DEFINE l_ima159   LIKE ima_file.ima159
   IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = g_sfs[l_ac].sfs04
      IF l_ima159 = '2' THEN
         CALL cl_set_comp_entry("sfs09",FALSE)
      ELSE 
         CALL cl_set_comp_entry("sfs09",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION i501_set_entry_sfs09()
   CALL cl_set_comp_entry("sfs09",TRUE)
END FUNCTION
#FUN-BA0050 ------------------End----------------------

#FUN-B70061 --START--
FUNCTION i501_set_required_sfsiicd028(p_cmd)
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(sfs04) THEN
      IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
         SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
          WHERE imaicd00 = g_sfs[l_ac].sfs04
         IF l_imaicd09 = 'Y' THEN            
            CALL cl_set_comp_required("sfsiicd028",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i501_set_no_required_sfsiicd028()
     CALL cl_set_comp_required("sfsiicd028",FALSE)
END FUNCTION

FUNCTION i501_set_required_sfsiicd029(p_cmd)
DEFINE l_imaicd13 LIKE imaicd_file.imaicd13
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(sfs04) THEN
      IF NOT cl_null(g_sfs[l_ac].sfs04) THEN
         SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
          WHERE imaicd00 = g_sfs[l_ac].sfs04
         IF l_imaicd13 = 'Y' THEN            
            CALL cl_set_comp_required("sfsiicd029",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i501_set_no_required_sfsiicd029()
     CALL cl_set_comp_required("sfsiicd029",FALSE)
END FUNCTION

FUNCTION i501_def_sfsiicd029()
DEFINE l_idc10    LIKE idc_file.idc10,
       l_idc11    LIKE idc_file.idc11
DEFINE l_flag     LIKE type_file.num10

   CALL s_icdfun_def_slot(g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfs[l_ac].sfs08,
                          g_sfs[l_ac].sfs09) RETURNING l_flag,l_idc10,l_idc11   
   IF l_flag = 1 THEN 
      LET g_sfs[l_ac].sfsiicd029 = l_idc10
      LET g_sfs[l_ac].sfsiicd028 = l_idc11      
      DISPLAY BY NAME g_sfs[l_ac].sfsiicd029,g_sfs[l_ac].sfsiicd028
   END IF 
END FUNCTION 
#FUN-B70061 --END--

#MOD-C50190 add begin-----------
#判斷是否是VMI
FUNCTION i501_isVMI(p_sfs07,p_sfs08)
DEFINE p_sfs07 LIKE sfs_file.sfs07,  #倉庫
       p_sfs08 LIKE sfs_file.sfs07   #庫位
DEFINE l_cnt   LIKE type_file.num5,
       l_ime12 LIKE ime_file.ime12   #庫位VMI特性

   IF g_sma.sma93 = 'Y' THEN 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM pmc_file
       WHERE pmc917 = p_sfs07
         AND pmc918 = p_sfs08
      
      SELECT ime12 INTO l_ime12
        FROM ime_file
       WHERE ime01 = p_sfs07
         AND ime02 = p_sfs08
         AND imeacti = 'Y'   #FUN-D40103
      IF l_cnt > 0 AND l_ime12='2' THEN 
         RETURN TRUE 
      ELSE 
         RETURN FALSE 
      END IF
   ELSE
      RETURN FALSE 
   END IF 
END FUNCTION 
#MOD-C50190 add end ------------
#FUN-C70014 add begin--------------
FUNCTION i501_multi_sfq014(p_n)
DEFINE tok          base.StringTokenizer
DEFINE l_sql        STRING
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_n,l_i      INTEGER 
DEFINE p_n          INTEGER   
DEFINE unissue_qty	LIKE sfb_file.sfb08
DEFINE l_success    STRING 

   CALL s_showmsg_init()
   LET l_plant = g_plant
   LET l_n = p_n
   LET g_success='Y'
   LET l_success='Y'
   FOR l_i=1 TO g_multi_sfq014.getLength()
      LET g_sfq[l_n].sfq014 = g_multi_sfq014[l_i].shm01
      LET g_sfq[l_n].sfq02 = g_multi_sfq014[l_i].shm012
      LET g_sfq[l_n].sfq04 = g_multi_sfq014[l_i].sgm04
      LET g_sfq[l_n].sfb05 = g_multi_sfq014[l_i].shm05
      SELECT ima02,ima021 INTO g_sfq[l_n].ima02_a,g_sfq[l_n].ima021_a
        FROM ima_file 
       WHERE ima01 = g_sfq[l_n].sfb05
      
      IF g_sfp.sfp06 MATCHES '[D]' THEN
         IF cl_null(g_sfq[l_n].sfq04) THEN
            LET g_sfq[l_n].sfq04 = ' '
         END IF 
         IF cl_null(g_sfq[l_n].sfq012) THEN
            LET g_sfq[l_n].sfq012 = ' ' 
         END IF 
         #抓去發料套數自動帶出
         CALL i501_sfq03_519(g_sfq[l_n].sfq014,g_sfq[l_n].sfq02,g_sfq[l_n].sfq04)
             RETURNING unissue_qty
         IF cl_null(unissue_qty) THEN LET unissue_qty = 0 END IF 
         LET g_sfq[l_n].sfq03 = unissue_qty
         IF cl_null(g_sfq[l_n].sfq03) OR g_sfq[l_n].sfq03<0 THEN 
            LET g_sfq[l_n].sfq03 = 0
         END IF 
      END IF
      IF NOT i501_chk_sfq(l_n,'2') THEN 
         LET l_success = 'N'
         CONTINUE FOR 
      END IF 
      LET l_n = l_n + 1
   END FOR 
   CALL g_sfq.deleteElement(l_n)
   LET l_n = l_n - 1
   IF l_success = 'N' THEN LET g_success = 'N' END IF 
   CALL s_showmsg()
   DISPLAY ARRAY g_sfq TO s_sfq.* ATTRIBUTE(COUNT=l_n,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
END FUNCTION 

#Run Card 成套發料套數計算函數
FUNCTION i501_sfq03_519(p_sfq014,p_sfq02,p_sfq04)
DEFINE p_sfq014     LIKE sfq_file.sfq014,  #Run Card單號
       p_sfq02      LIKE sfq_file.sfq02,   #工單編號 
       p_sfq04      LIKE sfq_file.sfq04
DEFINE qty1,qty2	LIKE sfq_file.sfq03    
DEFINE unissue_qty	LIKE sfb_file.sfb08
DEFINE l_shm08 	    LIKE shm_file.shm08
       
   LET unissue_qty = 0
   LET qty1 = 0
   LET qty2 = 0
   IF cl_null(p_sfq02) OR cl_null(p_sfq014) THEN 
      RETURN unissue_qty
   END IF 
   LET l_shm08 = NULL    
   #取得Run Card生產數量 
   SELECT shm08 INTO l_shm08 FROM shm_file 
    WHERE shm01 = p_sfq014

   IF l_shm08  IS NULL THEN LET l_shm08  = 0 END IF
   #將撈取qty1,qty2的部分整理到函數 i501_sfq03_chk1()處理  
   CALL i501_sfq03_chk(p_sfq02,p_sfq04,'',p_sfq014,'1')  #FUN-C70014 add sfq014
           RETURNING qty1,qty2                   
   IF qty1 IS NULL THEN LET qty1=0 END IF
   IF qty2 IS NULL THEN LET qty2=0 END IF
   LET unissue_qty = l_shm08-(qty1-qty2)

   RETURN unissue_qty
END FUNCTION 

#檢查runcard資料
FUNCTION i501_chk_runcard(p_shm01,p_shm012)
DEFINE p_shm01   LIKE shm_file.shm01,    #Run Card編號
       p_shm012  LIKE shm_file.shm012    #工單編號
DEFINE l_shmacti LIKE shm_file.shmacti,
       l_shm28   LIKE shm_file.shm28
       
   LET g_errno=''
   SELECT shmacti,shm28 INTO l_shmacti,l_shm28 FROM shm_file 
    WHERE shm01 = p_shm01 AND shm012 = p_shm012
   CASE 
      WHEN sqlca.sqlcode <> 0 
         LET g_errno=sqlca.sqlcode
      OTHERWISE 
         IF l_shmacti = 'N' THEN LET g_errno='asf-910' END IF 
         IF l_shm28 = 'Y' THEN LET g_errno='asf-910' END IF 
   END CASE    
END FUNCTION 

#檢查輸入套數單身資料是否重複
FUNCTION i501_chk_sfq(p_n,p_type)
DEFINE p_n           LIKE type_file.num5
DEFINE p_type        LIKE type_file.chr1
DEFINE l_length,l_i  LIKE type_file.num5
DEFINE l_err         STRING 

   IF p_n <=0 THEN RETURN TRUE END IF 
   LET l_length = g_sfq.getLength()
   FOR l_i = 1 TO l_length
      IF p_n = l_i THEN CONTINUE FOR END IF 
      IF g_sfq[l_i].sfq02 = g_sfq[p_n].sfq02 AND 
         g_sfq[l_i].sfq04 = g_sfq[p_n].sfq04 AND
         g_sfq[l_i].sfq012 = g_sfq[p_n].sfq012 AND
         g_sfq[l_i].sfq014 = g_sfq[p_n].sfq014 THEN 
         LET l_err = p_n,'/',g_sfq[l_i].sfq02,'/',g_sfq[l_i].sfq04,'/',
                     g_sfq[l_i].sfq012,'/',g_sfq[l_i].sfq014
         IF p_type = '1' THEN 
            CALL cl_err(l_err,'asf-188',1)
         ELSE 
            LET g_success = 'N'
            CALL s_errmsg('sfq02,sfq04,sfq012,sfq014',l_err,'','asf-188',1)
         END IF 
         RETURN FALSE 
      END IF 
   END FOR 
   RETURN TRUE
END FUNCTION 
#FUN-C70014 add end ---------------

#FUN-CB0014---add---str---
FUNCTION i501_list_fill()
  DEFINE l_sfp01         LIKE sfp_file.sfp01
  DEFINE l_i             LIKE type_file.num10

    CALL g_sfp_l.clear()
    LET l_i = 1
    FOREACH i501_fill_cs INTO l_sfp01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT sfp01,'',sfp02,sfp03,sfp06,sfp07,gem02,sfp08,sfp16,gen02,
              sfpconf,sfpmksg,sfp04,sfp05,sfp09,sfp10,sfp15
         INTO g_sfp_l[l_i].*
         FROM sfp_file
              LEFT OUTER JOIN gen_file ON sfp16 = gen01
              LEFT OUTER JOIN gem_file ON sfp07 = gem01
        WHERE sfp01=l_sfp01
       LET g_buf = s_get_doc_no(l_sfp01)
       SELECT smydesc INTO g_sfp_l[l_i].smydesc FROM smy_file WHERE smyslip=g_buf
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_buf = NULL
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_sfp_l TO s_sfp_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION i501_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfp_l TO s_sfp_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
         CALL fgl_set_arr_curr(g_curs_index) 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
  
       BEFORE ROW
         LET l_ac2 = ARR_CURR()
         LET g_curs_index = l_ac2
         CALL cl_show_fld_cont()
     ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         IF g_rec_b2 > 0 THEN
             CALL i501_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL i501_fetch('/')
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
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
         CALL i501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
       	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#TQC-D10084---mark---str---
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i501_mu_ui()   #TQC-710032
         CALL i501_pic() #圖形顯示
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 套數
      ON ACTION sets
         LET g_action_choice="sets"
         EXIT DISPLAY
#@    ON ACTION 庫存不足查詢
      ON ACTION qry_short_inventory
         LET g_action_choice="qry_short_inventory"
         EXIT DISPLAY
      #No.FUN-A40055--begin
      # ON ACTION qry_sets #套數查詢
      #   LET g_action_choice="qry_sets"
      #   EXIT DISPLAY
      #No.FUN-A40055--end
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#@    ON ACTION 產生調撥單
      ON ACTION gen_transfer_note
         LET g_action_choice="gen_transfer_note"
         EXIT DISPLAY
     #DEV-D30026 add str------------------------
#@    ON ACTION 條碼欠料調整(發料條碼數量分配)
      ON ACTION barcode_qty_allot
         LET g_action_choice="barcode_qty_allot"
         EXIT DISPLAY
     #DEV-D30026 add end------------------------
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DISPLAY
                                                                                
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION s_icdout
         LET g_action_choice = "s_icdout" 
         EXIT DISPLAY
      
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
 
#TQC-AC0197 ---------------------------Begin-------------------------------
      ON ACTION warahouse_modify
         LET g_action_choice="warahouse_modify"
         EXIT DISPLAY
#TQC-AC0197 ---------------------------End---------------------------------

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      

      #FUN-AB0001---add----str---
      ON ACTION approval_status #簽核狀況
         LET g_action_choice="approval_status"
         EXIT DISPLAY

      ON ACTION easyflow_approval #easyflow送簽
         LET g_action_choice = "easyflow_approval"
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
      #FUN-AB0001---add----end---
 
      &include "qry_string.4gl"

   END DISPLAY   
   
   IF g_errno='genb' THEN CALL i501_b_fill(' 1=1') LET g_errno='' END IF
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #No.FUN-A40055--end
END FUNCTION

#FUN-CB0014---add---end---

#FUN-CB0087--add--str--
FUNCTION i501_sfs37_check()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5

   LET l_flag = FALSE 
   IF cl_null(g_sfs[l_ac].sfs37) THEN RETURN TRUE END IF
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(g_sfp.sfp01,g_sfs[l_ac].sfs03,'',g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_sfs[l_ac].sfs37,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_sfs[l_ac].sfs37,'aim-425',0) #TQC-D20042
         RETURN FALSE 
      END IF
   ELSE
    #CHI-D60012-Modify-Start 
    #SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_sfs[l_ac].sfs37 AND azf02='2'
      LET l_n = 0
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_sfs[l_ac].sfs37 AND azf02='2' AND azf09 = 'C'
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_sfs[l_ac].sfs37 AND azf02='2' AND azf09 = 'E'
      END IF    
    #CHI-D60012-Modify-End 
      IF l_n < 1 THEN
         CALL cl_err(g_sfs[l_ac].sfs37,'aim-425',0) #TQC-D20042
         RETURN FALSE
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 

FUNCTION i501_sfs37_chkall()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5

   IF g_sfs.getlength() = 0  THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      FOR l_cnt = 1 TO  g_sfs.getlength()
         CALL s_get_where(g_sfp.sfp01,g_sfs[l_cnt].sfs03,'',g_sfs[l_cnt].sfs04,g_sfs[l_cnt].sfs07,g_sfp.sfp16,g_sfp.sfp07) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0 
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_sfs[l_cnt].sfs37,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE 
            END IF
         END IF 
      END FOR
   END IF    
   RETURN TRUE 
END FUNCTION 
#FUN-CB0087--add--end--
#TQC-D20042---add---str---
FUNCTION i501_azf03_desc() 
   LET g_sfs[l_ac].azf03_1 = ''
   IF NOT cl_null(g_sfs[l_ac].sfs37) THEN  
      SELECT azf03 INTO g_sfs[l_ac].azf03_1 FROM azf_file WHERE azf01=g_sfs[l_ac].sfs37 AND azf02='2'
   END IF
   DISPLAY BY NAME  g_sfs[l_ac].azf03_1
END FUNCTION
#MOD-D30037---begin
FUNCTION i501_sfs27_cho() 
    DEFINE l_sfa  DYNAMIC ARRAY OF RECORD
                   sfa26   LIKE sfa_file.sfa26,
                   sfa27   LIKE sfa_file.sfa27,
                   sfa03   LIKE sfa_file.sfa03,
                   sfa05   LIKE sfa_file.sfa05,
                   sfa06   LIKE sfa_file.sfa06
               END RECORD
    DEFINE l_cnt           LIKE type_file.num5
    DEFINE l_rec_b         LIKE type_file.num5

               
    OPEN WINDOW i501_sfs27_w WITH FORM "asf/42f/asfi501f"
   	          ATTRIBUTE(STYLE = g_win_style CLIPPED )
    CALL cl_ui_locale("asfi501f") 
  
    LET g_sql="SELECT sfa26,sfa27,sfa03,sfa05,sfa06 FROM sfa_file WHERE sfa01= '",g_sfs[l_ac].sfs03,"'" 
    PREPARE i501_sfs27_pb FROM g_sql
    DECLARE sfs27_curs CURSOR FOR i501_sfs27_pb 
    CALL l_sfa.clear()
 
    LET l_cnt = 1
 
    FOREACH sfs27_curs INTO l_sfa[l_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET l_cnt = l_cnt + 1
 
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore sfs27:',STATUS,1) END IF
    CALL l_sfa.deleteElement(l_cnt)
    
    LET l_rec_b=l_cnt - 1

    LET l_cnt = 0
    DISPLAY ARRAY l_sfa TO s_sfs27.* ATTRIBUTE(COUNT=l_rec_b)

         BEFORE ROW
            LET l_cnt = ARR_CURR()
            CALL cl_show_fld_cont()
         
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
            
         ON ACTION ACCEPT
            LET l_cnt = ARR_CURR()
            IF l_sfa[l_cnt].sfa26 MATCHES '[9BCUSTZ]' THEN  
               LET g_sfs[l_ac].sfs26 = l_sfa[l_cnt].sfa26
            ELSE
               LET g_sfs[l_ac].sfs26 = ''
            END IF 
            LET g_sfs[l_ac].sfs27 = l_sfa[l_cnt].sfa27
            LET g_sfs[l_ac].sfs04 = l_sfa[l_cnt].sfa03
            EXIT DISPLAY

         ON ACTION EXIT
            EXIT DISPLAY
            
    END DISPLAY
    CLOSE WINDOW i501_sfs27_w
 
END FUNCTION
#MOD-D30037---end 

#CHI-D50037---begin
FUNCTION i501_delHeader()
   DEFINE l_action_choice    STRING              
   DEFINE l_cho              LIKE type_file.num5 
   DEFINE l_num              LIKE type_file.num5  
   DEFINE l_slip             LIKE type_file.chr5  
   DEFINE l_sql              STRING               
   DEFINE l_cnt              LIKE type_file.num5  
   
   SELECT COUNT(*) INTO g_cnt FROM sfs_file WHERE sfs01=g_sfp.sfp01

   IF g_cnt = 0 THEN
      CALL s_get_doc_no(g_sfp.sfp01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sfp_file ",
                  "  WHERE sfp01 LIKE '",l_slip,"%' ",
                  "    AND sfp01 > '",g_sfp.sfp01,"'"
      PREPARE i501_pb1 FROM l_sql 
      EXECUTE i501_pb1 INTO l_cnt      
      
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
         CALL i501sub_x(g_sfp.sfp01,g_action_choice,TRUE,1)
         CALL i501sub_refresh(g_sfp.sfp01) RETURNING g_sfp.*
         CALL i501_show()
      END IF 
      
      IF l_cho = 3 THEN     
         DELETE FROM sfp_file WHERE sfp01 = g_sfp.sfp01
         DELETE FROM sfq_file WHERE sfq01 = g_sfp.sfp01
         IF g_sfp.sfp06 = '4' THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM sfu_file
             WHERE sfu09 = g_sfp.sfp01
            IF l_cnt > 0 THEN
               UPDATE sfu_file SET sfu09 = NULL
                WHERE sfu09 = g_sfp.sfp01
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","sfu_file",g_sfp.sfp01,"",STATUS,"","upd sfu",1) 
               END IF
            END IF
            # 當有耗材產生時,應將apmt730之耗材單號清為NULL                                                     
            LET l_cnt = 0                                                                                                            
            SELECT COUNT(*) INTO l_cnt FROM rvu_file                                                                                 
             WHERE rvu16 = g_sfp.sfp01                                                                                               
            IF l_cnt > 0 THEN                                                                                                        
               UPDATE rvu_file SET rvu16 = NULL                                                                                      
                WHERE rvu16 = g_sfp.sfp01                                                                                            
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                  
                  CALL cl_err3("upd","rvu_file",g_sfp.sfp01,"",STATUS,"","upd rvu",1)                                                
               END IF                                                                                                                
            END IF                                                                                                                   
         END IF
         CALL g_sfq.clear()
         INITIALIZE g_sfp.* TO NULL
         CLEAR FORM         
      END IF
   END IF
END FUNCTION
#CHI-D50037---end
