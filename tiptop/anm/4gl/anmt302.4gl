# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt302.4gl
# Descriptions...: 銀行存款轉帳作業(多行式)
# Date & Author..: 95/09/13 By Danny
# Modify.........: 97/05/13 By Danny 1.確認時, 若單別須拋轉總帳, 檢查分錄底稿
#                                    2.傳票號碼非空白者, 不可再產生分錄底稿
#                                    3.產生分錄底稿時, 傳票日期=NULL
# Modify.........: 97/05/27 By Lynn  1.新增時,詢問是否產生分錄底稿
#                                    2.取消確認,若已拋轉總帳,show警告訊息
#                                    3.取消時, 刪除分錄底稿
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8421 03/10/06 By Kitty 換銀行時匯率要重抓
# Modify.........: No.7365 03/10/06 By Kitty 1.npk03增加3,4
#                                            2.確認取消確認可作銀行空白之狀況
# Modify.........: No.8158 03/10/15 By Kitty nmg20='21'or'22'時單身幣別要相同
# Modify.........: No.9711 04/07/13 By ching 暫收時,確認將已沖金額update為原幣
# Modify.........: No.MOD-490143 04/09/09 By Yuna nmg02應為no use在程式中不應使用到
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0252 04/10/27 By Smapmin 增加查詢時之開窗功能
# Modify.........: No.MOD-4A0350 04/11/01 By Mandy t302_set_entry_b/t302_set_no_entry_b有誤
# Modify.........: No.MOD-4A0349 04/11/08 By Mandy q_m_aag傳錯參數
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.MOD-510087 05/01/12 By Smapmin win 開始立即去按 確認  or  取消確認時 程式會當掉
# Modify.........: No.MOD-530050 05/03/08 By Kitty 入帳類別選21或22, 單身新增完第二筆資料後,無法存入
# Modify.........: No.MOD-510071 05/03/09 By Kitty 如果一開始時採用[3.借方科目][4.貸方科目],[1.存入][2.提出]
#                       一定要輸入異動碼,除了要加 entry/no entry  設訂外在ON ROW CHANGE/AFTER INSERT增加判斷
# Modify.........: No.MOD-530676 05/03/29 By Smapmin 1.帳款類別為21,22且要拋轉暫收款時,
#                                                      應判斷單頭的暫收科目及單身的對方科目相同.
#                                                    2.當入帳類別為21,22,單身輸入多筆時,且,不為轉暫收者,
#                                                      不允許銀行科目不同.
#                                                    3.部門沒有檢查, 是否為會計部門.
#                                                    4.列印時, 要可以選擇 簡表 或收支憑証.
# Modify.........: No.FUN-550037 05/05/13 By saki    欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-560130 06/06/27 By Yuna   修改時,入帳類別若由0改為21,應檢查客戶編號是否有輸入
# Modify.........: No.MOD-570291 05/07/28 By Smapmin nmg12改為 no use, 請移除相關的程式段
# Modify.........: No.MOD-580033 05/08/05 By Smapmin 入帳類別為21.22且為暫收時,客戶/廠商編號(簡稱)修改後又恢復原值
# Modify.........: No.MOD-590002 05/09/05 By vivien 部分欄位加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0124 05/10/20 By elva 刪除帳款資料時刪除oov_file
# Modify.........: No.FUN-590085 05/10/24 By Smapmin 簡表列印時,應依QBE條件產生相關資料
# Modify.........: No.MOD-5B0091 05/11/07 By Smapmin 單身匯率無法點開視窗維護匯率
# Modify.........: No.MOD-5B0207 05/11/21 By Smapmin 單身的匯率欄位，沒有做小數位數的控管
# Modify.........: No.MOD-5B0217 05/11/23 By Smapmin 銀行編號有輸入時,幣別要為noentry
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-610029 06/01/06 By Smapmin 單身原幣金額取位
# Modify.........: No.FUN-630020 06/03/08 By pengu 流程訊息通知功能
# Modify.........: No.MOD-630080 06/03/28 By Smapmin 確認後修改客戶/廠商代號,連同nme_file要一併修改
# Modify.........: No.TQC-630153 06/03/30 By Smapmin 若存提項目(npk02)之存提別為1、2 則銀行編號(npk04)一定要輸入
# Modify.........: No.MOD-640037 06/04/10 By Smapmin 存提異動碼應依異動別開窗
# Modify.........: NO.MOD-640323 06/04/10 By Smapmin 已確認的單子不可再產生分錄或確認
# Modify.........: NO.MOD-640360 06/04/13 By Alexstar 修正收狀單號為空白且入帳類別不等於"押匯入帳"則預設收狀單號為日期的功能
# Modify.........: No.MOD-640528 06/04/20 By Smapmin 於確認時,重新抓取單別設定
# Modify.........: No.MOD-640039 06/04/28 By Smapmin 單身對方科目未自動帶出單頭暫收科目
# Modify.........: No.FUN-5C0014 06/05/29 By Rainy   新增欄位oma67存放INVOICE NO.
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670025 06/07/06 By Smapmin 當nmg20='22'時,在確認段更新olc11=nmg25,olc12=nmg01
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.MOD-670043 06/07/11 By Smapmin 修改SELECT 條件
# Modify.........: No.FUN-670060 06/08/01 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680034 06/08/22 By Jackho 兩套帳修改
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION t302()_q 一開始應清空g_nmg.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改  
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0060 06/11/28 By Smapmin 查詢狀態時,開窗查詢廠商資料預設為q_occ
# Modify.........: No.TQC-6B0155 06/12/05 By chenl   修正"預設上筆資料"無法保存的bug
# Modify.........: No.MOD-690124 06/12/06 By Smapmin 異動別為1.2時,存提款異動碼
# Modify.........: No.MOD-6C0147 06/12/26 By rainy 廠商/客戶代碼清掉後，簡稱沒清掉
# Modify.........: No.MOD-710170 07/01/26 By Smapmin 列印時製表日期為空
# Modify.........: No.FUN-710024 07/02/07 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-730013 07/03/05 By Smapmin 輸入存提款異動碼,未帶出對方科目編號
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-730126 07/03/27 By Smapmin 以原幣入帳金額回寫押匯金額
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.MOD-740398 07/04/23 By Ray  調用s_aapact時參數順序錯誤
# Modify.........: No.MOD-740395 07/05/08 By Judy 新增處理多帳期
# Modify.........: No.MOD-750072 07/05/16 By Smapmin 增加單身對方科目與單頭暫收科目的檢核點
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750246 07/05/30 By rainy 寫入 axrt300 ,收款客戶,名稱 未寫入 沖帳資料未寫入 oma51f,oma51!
# Modify.........: No.MOD-770024 07/07/06 By Smapmin 銀行未改變時,匯率不需重算
# Modify.........: No.MOD-770089 07/07/18 By Smapmin 調整寫入銀行存款異動檔的現金變動碼
# Modify.........: No.MOD-770133 07/07/27 By Smapmin 重新抓取單據設定檔資料
# Modify.........: No.TQC-790178 07/10/09 By chenl   若為拋磚憑証情況下，分錄底稿不平則不可審核！
# Modify.........: No;MOD-7B0093 07/11/12 By Smapmin 修改異動碼檢核
# Modify.........: No.MOD-7B0165 07/11/20 By Smapmin 作廢時判斷收款沖帳資料是否存在,應排除已作廢單據
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-850002 08/05/02 By Carol 修改異動別後應做合理性檢查
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.CHI-790008 08/07/04 By xiaofeizhu 更改nmg21的標題以及開窗，回寫axrt210時的key值改成olc01
# Modify.........: No.CHI-860029 08/07/07 By sherry 當anmt302 單頭nmg20 = '22'(押匯入帳)，確認時侯回寫axrt210 (olc20)
# Modify.........: No.CHI-810012 08/07/17 By sherry 做押匯(入帳類別:22)，金額確認時，應回寫axrt200 ola10(已押匯金額)
# Modify.........: No.TQC-870028 08/07/17 By chenyu 異動別為存入或提出的，存提款異動碼為必輸
# Modify.........: No.MOD-870274 08/07/25 By Sarah 延續MOD-530676調整，單身對方科目預設值僅對異動別為存入(npk03='1')時控管
# Modify.........: No.MOD-880019 08/08/05 By Sarah t302_i()段的AFTER INPUT,判斷anm-918訊息段前面應增加IF g_nmg.nmg20='22' AND NOT cl_null(g_nmg.nmg21) THEN判斷
# Modify.........: No.MOD-890286 08/10/01 By Sarah 整批確認時,當單別都設定為自動拋轉傳票,只有第一張單據會拋轉傳票,其他單據只有確認
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-8C0107 09/01/05 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD 
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-910197 09/01/22 By Sarah INSERT azo_file前增加LET g_msg=TIME,寫進azo05的值改為nmg00
# Modify.........: No.CHI-8C0043 09/02/17 By Sarah 整批確認時,無單身的錯誤訊息arm-034,前面增加顯示單號(nmg00)
# Modify.........: No.MOD-930003 09/03/02 By chenl 增加錄入完成后,自動產生分錄底稿的功能.
# Modify.........: No.TQC-940030 09/04/07 By chenl oma13科目類型的值，賦值修正為應收參數設定作業的應收賬款缺省科目類型，而不應該直接給‘1’。
# Modify.........: No.MOD-940280 09/04/21 By lilingyu 增加抓取occ45來當oma32的預設值
# Modify.........: No.TQC-940135 09/04/23 By chenl 若單別不拋轉憑証時，應給予提示。
# Modify.........: No.FUN-920126 09/04/27 By ve007 回寫押匯金額考慮手續費 
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.CHI-920056 09/05/13 By jan s_errmsg的訊息欄位錯誤
# Modify.........: No.TQC-950085 09/05/13 By wujie AFTER FIELD nmg18的欄位控管有寫錯
# Modify.........: No.MOD-960053 09/06/04 By baofei 增加npk04不可為空的控管
# Modify.........: No.MOD-960319 09/06/25 By Sarah t302_out()段,執行"收支憑證列印"時會改變g_wc的值(會加上\),改成用l_wc
# Modify.........: No.TQC-950140 09/07/02 By liuxqa 取消審核后，更改時，invoice no 會變更為日期格式。
# Modify.........: No.MOD-970126 09/07/15 By mike CALL t302_y1()改成先判斷g_success='Y'才做
# Modify.........: No.FUN-970072 09/07/27 By hongmei 差異功能處理
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.MOD-980198 09/10/14 By sabrina  單頭輸入日期後及確認時判斷該單別是否拋轉，若要拋轉，判斷單頭日期是否<=關帳日期  
# Modify.........: No:MOD-9A0190 09/10/29 By Sarah 單身異動別為3/4時,npk02與npk04是不可輸入的,故也不需卡Not Null
# Modify.........: No:MOD-9C0358 09/12/22 By sabrina 客戶匯款暫收,單身輸入之暫收科目與單頭相同,不應提示
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No:MOD-A10128 10/01/21 By wujie   审核时检查单身科目不可为效
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30106 10/03/30 by wujie  增加凭证联查功能
# Modify.........: No:TQC-A60131 10/06/29 By wujie  s_get_bookno1传入的应该是plant，不是db
# Modify.........: No.FUN-A60056 10/07/07 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A70019 10/07/16 By Summer 取消 nmg17
# Modify.........: No.FUN-A50102 10/07/19 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A70115 10/07/23 by xiaofeizhu cmdrun處傳參格式需要調整
# Modify.........: No:MOD-A80067 10/08/10 By wujie  cl_set_comp_visible的写法和p_per有冲突
# Modify.........: No.CHI-A80036 10/08/30 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No.MOD-AA0108 10/10/19 By Dido 取消確認應檢核是否存在axrt400待抵帳款中 
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No.MOD-AC0293 11/01/05 By Summer 將AFTER FIELD npk03改為ON CHANGE npk03
# Modify.........: No.TQC-B10069 11/01/14 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.MOD-B10242 11/01/28 By wujie 整批取消审核时，需要考虑每一个收支单的参数等情况
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No.FUN-B30166 11/03/22 By lutingting nme_file add nme27 
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60086 11/06/16 By zhangweib CONSTURCT時加上資料建立者和資料建立部門
# Modify.........: No.FUN-B30049 11/06/22 by belle 走暫收流程(單別選擇要拋轉票者) 確認後開放可以修改客戶代號 
# Modify.........: No.MOD-B70096 11/07/12 by suncx 單據勾選上'拋轉憑證'時，才需要判讀對方科目，進行差異處理
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No:FUN-B30213 11/07/19 By lixia 刪除或更改單號時更新nmu14
# Modify.........: No:MOD-B80144 11/08/15 By lixia 增加nma21檢查
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No.FUN-B90075 11/09/15 By zhangll 單號控管改善
# Modify.........: No.MOD-BC0021 11/12/05 By yinhy axrt410衝過的不管什麼類型都不得取消審核
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30081 12/03/09 By Polly 增加控卡，入帳類不可提出
# Modify.........: No:MOD-C30070 12/03/10 By Polly 增加新舊值的判斷
# Modify.........: No.MOD-C30632 12/03/13 By minpp 在 FUNCTION t302_nmc()中，移除將npk071清空的段落 
# Modify.........: No.MOD-C60037 12/06/15 By Polly 開立和存入幣別不同時，需考慮幣別UPDATE ola_file及olc_fil
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C60230 21/06/28 By lujh 取消審核的時候要還原axrt200中ola10和axrt210中olc11的值
# Modify.........: No.TQC-C60236 12/06/28 By lujh 押匯入賬總金額應不可以大于【信用狀金額ola09】，事實銀行不會超限額付款。
# Modify.........: No.MOD-C70038 12/07/04 By Polly 更改客戶/廠商代號需控卡是否收支單是否有存在axrt400中
# Modify.........: No.FUN-C30085 12/07/05 By lixiang 改CR報表串GR報表
# Modify.........: No.FUN-C50136 12/07/10 By chenjing 增加審核時信用管控
# Modify.........: No.TQC-C70136 12/07/24 By lujh 使用右側按鈕【客戶/廠商編號更改】修改nmg18后，判斷存在於axrt300中，，才需要做UPDATE動作 
# Modify.........: No.FUN-C80031 12/08/09 By minpp 1.大陸版本，單身增加部門欄位，2.如果為暫收，單身部門不可維護                                                
# Modify.........: No.MOD-C80082 12/08/13 By Polly 部門欄位改抓單頭的nmg11值
# Modify.........: No:MOD-C50178 12/08/23 By wangwei 單身更改時報錯但可以保存
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-C80101 12/08/14 By yinhy 廠商退款應選擇21類型，將21類型改為客戶\廠商匯款入帳
# Modify.........: No.MOD-CA0036 12/10/04 By Polly 匯率為1時，增加檢查本幣與原幣金額不同，提示錯誤
# Modify.........: No.MOD-C90029 12/10/11 By Elise 取消 t_azi07
# Modify.........: No.MOD-C90076 12/10/12 By yinhy 錄入時，客戶/廠商編號客戶錄入查詢條件
# Modify.........: No.FUN-C90127 12/09/27 By zhangweib 1.单头增加字段nmg31 varchar2(20) 当入账类型选择1：厂商汇款出账时必须录入且是大陆版(aza26 = 2)
#                                                        开窗选择aapt330 apf01 where   apf03=nmg18 apf12=nmg19且单身付款
#                                                        类型有aph03 = 'E'转杂项应付(且aph23 aapt120有未付金额)AFTER FIELED检查一并加上
#                                                      2.单身银行增加管控.币种税率需等同于单头aph的币种税率；单身的金额要增加判断,不可大于aapt120未付金額

#                                                      3.anmt302 分录为 借：应付帐款(取aapt120 贷方科目apa54)
#                                                                      贷：银行科目(npk07)
#                                                      4.审核加判断。若入账类型为1,则必须有分录底稿；
#                                                        更新aapt120的已收金额
# Modify.........: No.MOD-C90197 12/10/22 By wujie 更改时报单号错死循环
# Modify.........: No.MOD-C90198 12/10/22 By wujie 单头入账类型为21时，单身不能有“提出”的异动别
# Modify.........: No.MOD-CA0176 12/10/24 By wujie 单头客户厂商编号若在客户档选不到，要在厂商档做查询
#                                                  单身异动码和存提异动码不符时，直接按确定应该不允许保存退出
# Modify.........: No.MOD-CA0231 12/11/01 By Polly 確認增加銀行編號回寫到axrt210的押匯銀行
# Modify.........: No.MOD-CB0049 12/11/08 By Polly 調整押匯金額計算
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.MOD-CC0193 12/12/22 By Polly 增加更新npq21、npq22的值
# Modify.........: No.MOD-CC0170 12/12/22 By Polly 1.增加判斷來決定是否要給nmc02、npk071預設值
#                                                  2.當單身為3.借方科目與4.貸方科目時不應用存提異動碼去撈資料
# Modify.........: No:FUN-CB0117 13/01/08 By wangrr 9主機追單到30
# Modify.........: No:FUN-CB0080 13/01/09 By wangrr 9主機追單到30,新增資料清單頁簽
# Modify.........: No.MOD-D10154 13/01/16 By yinhy 增加oma64和oma70的賦值
# Modify.........: NO.FUN-BC0044 13/01/30 BY Lori 增加複製功能
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gnmg302
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D20019 13/02/25 By yinhy MOD-CA0176修改錯誤，增加條件npk02不為空
# Modify.........: No.MOD-CC0027 13/04/03 By apo 抓取客戶檔應排除性質為2送貨的
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D60105 13/06/13 By yinhy 有OPEN t302_cl，但是結束時未CLOSE t302_cl
# Modify.........: No:TQC-D40062 13/08/14 By dongsz 改善nmg18、nmg19的控管問題
# Modify.........: No.MOD-D80005 13/08/01 By apo AFTER ROW時刪除單身實際筆數+1才能確保進入AFTER INSERT段
# Modify.........: No:MOD-D80116 13/08/19 By yinhy 增加單身開窗
# Modify.........: No:FUN-D80072 13/08/19 By wangrr anmt302,當收款客戶慣用幣別與本位幣不同時,先帶客戶的默認科目分類碼(occ67-->ool23)，如果沒有再帶票据里面的默認暫收款科目
# Modify.........: No:MOD-D80177 13/08/27 By yinhy 大陸版廠商匯款出賬時為考慮更新付款單apc_file
# Modify.........: No:MOD-DA0064 13/10/11 By yinhy AFTER FIELD npk02修改管控
# Modify.........: No:181121     18/11/21 By lixwz 录入时不允许超过剩余的金额
# Modify.........: NO:FUN-E80012 18/11/25 By pulf 修改付款日期之後,tic現金流量明細重複
DATABASE ds

 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nme   RECORD LIKE nme_file.*,
    g_oma   RECORD LIKE oma_file.*,
    g_nme_o RECORD LIKE nme_file.*,
    g_nmg   RECORD LIKE nmg_file.*,
    g_nmg_o RECORD LIKE nmg_file.*,
    g_nmg_t RECORD LIKE nmg_file.*,
    m_npk   RECORD LIKE npk_file.*,                 #INSERT ime_file 用
    b_npk   RECORD LIKE npk_file.*,
    g_npk   DYNAMIC ARRAY OF RECORD
            npk01    LIKE npk_file.npk01,
            npk03    LIKE npk_file.npk03,
            npk02    LIKE npk_file.npk02,
            nmc02    LIKE nmc_file.nmc02,
            npk04    LIKE npk_file.npk04,           #TQC-630153
            npk05    LIKE npk_file.npk05,
            npk06    LIKE npk_file.npk06,
            npk08    LIKE npk_file.npk08,
            npk09    LIKE npk_file.npk09,
            npk07    LIKE npk_file.npk07,
            npk071   LIKE npk_file.npk071,
            npk072   LIKE npk_file.npk072,          #NO.FUN-680034
            npk073   LIKE npk_file.npk073,          #NO.FUN-680034  
            npk16    LIKE npk_file.npk16,           #FUN-C80031
            gem02_1  LIKE gem_file.gem02,           #FUN-C80031
            npk10    LIKE npk_file.npk10,
            npkud01  LIKE npk_file.npkud01,
            npkud02  LIKE npk_file.npkud02,
            npkud03  LIKE npk_file.npkud03,
            npkud04  LIKE npk_file.npkud04,
            npkud05  LIKE npk_file.npkud05,
            npkud06  LIKE npk_file.npkud06,
            npkud07  LIKE npk_file.npkud07,
            npkud08  LIKE npk_file.npkud08,
            npkud09  LIKE npk_file.npkud09,
            npkud10  LIKE npk_file.npkud10,
            npkud11  LIKE npk_file.npkud11,
            npkud12  LIKE npk_file.npkud12,
            npkud13  LIKE npk_file.npkud13,
            npkud14  LIKE npk_file.npkud14,
            npkud15  LIKE npk_file.npkud15
           END RECORD,
    g_npk_t RECORD
            npk01    LIKE npk_file.npk01,
            npk03    LIKE npk_file.npk03,
            npk02    LIKE npk_file.npk02,
            nmc02    LIKE nmc_file.nmc02,
            npk04    LIKE npk_file.npk04,           #TQC-630153
            npk05    LIKE npk_file.npk05,
            npk06    LIKE npk_file.npk06,
            npk08    LIKE npk_file.npk08,
            npk09    LIKE npk_file.npk09,
            npk07    LIKE npk_file.npk07,
            npk071   LIKE npk_file.npk071,
            npk072   LIKE npk_file.npk072,          #NO.FUN-680034
            npk073   LIKE npk_file.npk073,          #NO.FUN-680034
            npk16    LIKE npk_file.npk16,           #FUN-C80031
            gem02_1  LIKE gem_file.gem02,           #FUN-C80031
            npk10    LIKE npk_file.npk10,
            npkud01  LIKE npk_file.npkud01,
            npkud02  LIKE npk_file.npkud02,
            npkud03  LIKE npk_file.npkud03,
            npkud04  LIKE npk_file.npkud04,
            npkud05  LIKE npk_file.npkud05,
            npkud06  LIKE npk_file.npkud06,
            npkud07  LIKE npk_file.npkud07,
            npkud08  LIKE npk_file.npkud08,
            npkud09  LIKE npk_file.npkud09,
            npkud10  LIKE npk_file.npkud10,
            npkud11  LIKE npk_file.npkud11,
            npkud12  LIKE npk_file.npkud12,
            npkud13  LIKE npk_file.npkud13,
            npkud14  LIKE npk_file.npkud14,
            npkud15  LIKE npk_file.npkud15
           END RECORD,
    g_dbs_gl        LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl      LIKE type_file.chr10,  #No.FUN-980020
    g_nms           RECORD LIKE nms_file.*,
    g_dept          LIKE nmg_file.nmg11,   #No.FUN-680107 VARCHAR(6)
    m_chr           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
   g_wc,g_wc1,g_sql STRING,                #TQC-630166
    g_t1            LIKE nmy_file.nmyslip, #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
    g_nmydmy1       LIKE nmy_file.nmydmy1, #No.FUN-680107 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_ac1           LIKE type_file.num5,  #No.FUN-CB0080
    g_argv1         LIKE nmg_file.nmg00    #No.FUN-680107 VARCHAR(16) #No.FUN-630020 modify
 
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_argv2      STRING                 #No.FUN-630020 add
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_str        STRING                 #No.FUN-670060 
DEFINE g_wc_gl      STRING                 #No.FUN-670060
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_void       LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_net        LIKE oox_file.oox10    #MOD-740395
DEFINE diff_flag    LIKE type_file.chr1    #差異處理方式#FUN-970072
DEFINE l_aaa07      LIKE aaa_file.aaa07    #MOD-980198 add
#DEFINE g_oaz96          LIKE oaz_file.oaz96    #No.FUN-C50136
#No.FUN-CB0080 ---start--- Add
DEFINE g_nmg_1      DYNAMIC ARRAY OF RECORD
          nmg00     LIKE nmg_file.nmg00,
          nmg01     LIKE nmg_file.nmg01,
          nmg20     LIKE nmg_file.nmg20,
          nmg18     LIKE nmg_file.nmg18,
          nmg19     LIKE nmg_file.nmg19,
          nmg31     LIKE nmg_file.nmg31,
          nmg29     LIKE nmg_file.nmg29,
          nmg30     LIKE nmg_file.nmg30,
          aag02     LIKE aag_file.aag02,
          nmg13     LIKE nmg_file.nmg13,
          nmg23     LIKE nmg_file.nmg23,
          nmg25     LIKE nmg_file.nmg25,
          nmg05     LIKE nmg_file.nmg05,
          nmg06     LIKE nmg_file.nmg06,
          nmgconf   LIKE nmg_file.nmgconf
                    END RECORD
DEFINE g_bp_flag    LIKE type_file.chr10
DEFINE g_rec_b1     LIKE type_file.num10
#No.FUN-CB0080 ---end  --- Add
 
MAIN
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)          #No.FUN-630020 add
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
#  SELECT oaz96 INTO g_oaz96 FROM oaz_file WHERE oaz00 = '0'     #FUN-C50136
 
   LET g_forupd_sql = "SELECT * FROM nmg_file WHERE nmg00 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET g_wc1=" 1=1"
   LET g_plant_gl = g_nmz.nmz02p                         #FUN-980020
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW t302_w AT p_row,p_col
     WITH FORM "anm/42f/anmt302"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#No.MOD-A80067 --begin
#  CALL cl_set_comp_visible("nmg301",g_aza.aza63='Y')                              
#  CALL cl_set_comp_visible("aag021",g_aza.aza63='Y')                              
#  CALL cl_set_comp_visible("npk072",g_aza.aza63='Y')
#  CALL cl_set_comp_visible("npk073",g_aza.aza63='Y')
   IF g_aza.aza63 ='N' THEN
      CALL cl_set_comp_visible("nmg301",FALSE)                              
      CALL cl_set_comp_visible("aag021",FALSE)                              
      CALL cl_set_comp_visible("npk072",FALSE)
      CALL cl_set_comp_visible("npk073",FALSE)
   END IF
#No.MOD-A80067 --end
  
   #FUN-C80031---ADD--STR
   IF g_aza.aza26='2' THEN 
      CALL cl_set_comp_visible("npk16,gem02_1",TRUE)
      CALL cl_set_comp_visible("nmg31",TRUE)        #No.FUN-C90127 Add
   ELSE
      CALL cl_set_comp_visible("npk16,gem02_1",FALSE)
      CALL cl_set_comp_visible("nmg31",FALSE)       #No.FUN-C90127 Add
   END IF
   #FUN-C80031-- ADD--END

   # 先以g_argv2判斷直接執行哪種功能，
   # 執行I時，g_argv1是單號
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t302_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t302_a()
            END IF
         OTHERWISE
                CALL t302_q()
      END CASE
   END IF
   CALL t302_menu()
   CLOSE WINDOW t302_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t302_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_npk.clear()
   IF NOT cl_null(g_argv1) THEN         #No.FUN-630020 add
      LET g_wc=" nmg00='",g_argv1,"'"
      LET g_wc1=" 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' THEN
      CALL cl_set_comp_visible("nmg31",TRUE)
   END IF
  #No.FUN-C90127   ---edn  --- Add
   INITIALIZE g_nmg.* TO NULL    #No.FUN-750051
     #CONSTRUCT BY NAME g_wc ON nmg00,nmg01,nmg11,nmg17,nmg20,nmg18,nmg19,nmg21, #CHI-A70019 mark
      CONSTRUCT BY NAME g_wc ON nmg00,nmg01,nmg11,nmg20,nmg18,nmg19,nmg21,       #CHI-A70019
                                nmgconf,nmg31,nmg29,nmg30,nmg301,nmg13,nmg14,nmg23,nmg05,nmg24, #No.FUN-680034 add nmg301 #No.FUN-C90127 Add nmg31
                                nmguser,nmggrup,nmgmodu,nmgdate,nmgacti,
                                nmgud01,nmgud02,nmgud03,nmgud04,nmgud05,
                                nmgud06,nmgud07,nmgud08,nmgud09,nmgud10,
                                nmgud11,nmgud12,nmgud13,nmgud14,nmgud15
                               ,nmgoriu,nmgorig             #TQC-B60086   Add
 #查詢時開窗功能
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nmg00)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_nmg1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmg00
                 NEXT FIELD nmg00
              WHEN INFIELD(nmg11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmg11
                 NEXT FIELD nmg11
             #CHI-A70019 mark --start--
             #WHEN INFIELD(nmg17) #變動碼
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.state = "c"
             #   LET g_qryparam.form = "q_nml"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
             #   DISPLAY g_qryparam.multiret TO nmg17
             #   NEXT FIELD nmg17
             #CHI-A70019 mark --end--
              WHEN INFIELD(nmg18)
                 #No.MOD-C80101  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.state = "c"
                 #LET g_qryparam.form="q_occ"   #FUN-6B0060
                 #LET g_qryparam.default1=g_nmg.nmg18
                 #CALL cl_create_qry() RETURNING g_nmg.nmg18
                 #DISPLAY BY NAME g_nmg.nmg18
                 #NEXT FIELD nmg18
                 CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nmg18
                 NEXT FIELD nmg18
                 #No.MOD-C80101  --End
              WHEN INFIELD(nmg21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_olc2"                                     #CHI-790008 q_ola->q_olc2     
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmg21
                    NEXT FIELD nmg21
              WHEN INFIELD(nmg30)
                  CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmg.nmg30,'23',g_bookno1) #No.FUN-980025 
                 RETURNING g_nmg.nmg30
                 DISPLAY BY NAME g_nmg.nmg30 NEXT FIELD nmg30
              WHEN INFIELD(nmg301)
                  CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmg.nmg301,'23',g_bookno2) RETURNING g_nmg.nmg301      #No.FUN-980025
                 DISPLAY BY NAME g_nmg.nmg301 NEXT FIELD nmg301
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmguser', 'nmggrup')
 
      CONSTRUCT g_wc1 ON npk01,npk03,npk02,npk04,npk05,npk06,npk08,npk09,npk07,npk071,npk072,npk073,npk16,npk10     #No.FUN-680034 add npk071,npk072  #FUN-C80031 add-npk16
                         ,npkud01,npkud02,npkud03,npkud04,npkud05
                         ,npkud06,npkud07,npkud08,npkud09,npkud10
                         ,npkud11,npkud12,npkud13,npkud14,npkud15
                    FROM s_npk[1].npk01,s_npk[1].npk03,s_npk[1].npk02,
                         s_npk[1].npk04,s_npk[1].npk05,s_npk[1].npk06,
                         s_npk[1].npk08,s_npk[1].npk09,s_npk[1].npk07,
                         s_npk[1].npk071,s_npk[1].npk072,s_npk[1].npk073,            #No.FUN-680034 add s_npk[1].npk071,s_npk[1].npk072
                         s_npk[1].npk16,s_npk[1].npk10                               #FUN-C80031 add-npk16
                         ,s_npk[1].npkud01,s_npk[1].npkud02,s_npk[1].npkud03
                         ,s_npk[1].npkud04,s_npk[1].npkud05,s_npk[1].npkud06
                         ,s_npk[1].npkud07,s_npk[1].npkud08,s_npk[1].npkud09
                         ,s_npk[1].npkud10,s_npk[1].npkud11,s_npk[1].npkud12
                         ,s_npk[1].npkud13,s_npk[1].npkud14,s_npk[1].npkud15
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
      #No.MOD-D80116  --Begin       
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(npk04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nma"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING  g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO npk04    
                NEXT FIELD npk04
             WHEN INFIELD(npk05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO npk05 
                NEXT FIELD npk05 
             WHEN INFIELD(npk07)
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npk[l_ac].npk07,'23',g_aza.aza81) 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk07
                 NEXT FIELD npk07
             WHEN INFIELD(npk072)                                                                                                    
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npk[l_ac].npk072,'23',g_aza.aza81) 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk072                                                                                                                                                      
                 NEXT FIELD npk072
             WHEN INFIELD(npk071)
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npk[l_ac].npk071,'23',g_aza.aza81) 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk071
                 NEXT FIELD npk071
             WHEN INFIELD(npk073)                                                                                                   
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npk[l_ac].npk073,'23',g_aza.aza81) 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk073                                                            
                 NEXT FIELD npk073
             WHEN INFIELD(npk02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_nmc01" 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk02 
                NEXT FIELD npk02

              WHEN INFIELD(npk16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npk16
                 NEXT FIELD npk16 
           END CASE
           #No.MOD-D80116  --End
       
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN
      LET g_sql="SELECT nmg00 FROM nmg_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY nmg00"
   ELSE
      LET g_sql="SELECT UNIQUE nmg_file.nmg00 ",
                "  FROM nmg_file,npk_file ", # 組合出 SQL 指令
                " WHERE nmg00=npk00 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY nmg00"
   END IF
   PREPARE t302_pr FROM g_sql           # RUNTIME 編譯
   DECLARE t302_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t302_pr
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
      LET g_sql="SELECT COUNT(*) FROM nmg_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nmg00) FROM nmg_file,npk_file ",
                " WHERE nmg00=npk00 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF
   PREPARE t302_precount FROM g_sql                           # row的個數
   DECLARE t302_count CURSOR FOR t302_precount
   #No.FUN-CB0080 ---start--- Add
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN
      LET g_sql="SELECT nmg00,nmg01,nmg20,nmg18,nmg19,nmg31,nmg29,nmg30,'',",
                "       nmg13,nmg23,nmg25,nmg05,nmg06,nmgconf  ",
                "  FROM nmg_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY nmg00"
   ELSE
      LET g_sql="SELECT nmg00,nmg01,nmg20,nmg18,nmg19,nmg31,nmg29,nmg30,'',",
                "       nmg13,nmg23,nmg25,nmg05,nmg06,nmgconf  ",
                "  FROM nmg_file,npk_file ", # 組合出 SQL 指令
                " WHERE nmg00=npk00 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY nmg00"
   END IF

   PREPARE anmt302_prepare FROM g_sql
   DECLARE anmt302_list_cur CURSOR FOR anmt302_prepare
   
  #No.FUN-CB0080 ---end  --- Add
END FUNCTION
 
FUNCTION t302_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
   WHILE TRUE
      CALL t302_bp("G")
      CASE g_action_choice
         #No.FUN-CB0080 ---start--- Add
         WHEN "item_list"
            IF cl_chk_act_auth() THEN
               CALL t302_b_menu()
            END IF
        #No.FUN-CB0080 ---end  --- Add
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t302_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t302_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t302_r()
               CALL t302_show()   #No.FUN-B90062 
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t302_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t302_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t302_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "modify_customer_no_vender_n"
            IF cl_chk_act_auth() THEN
               CALL t302_c()
            END IF
#---FUN-BC0044 start--
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t302_copy()
            END IF
#---FUN-BC0044 end-----
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()       #TQC-B10069
               CALL t302_firm1()
               CALL t302_b_fill_1()        #No.FUN-CB0080   Add
               CALL s_showmsg()            #TQC-B10069
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t302_firm2()
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()        #No.FUN-CB0080   Add
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t302_x()                    #FUN-D20035
               CALL t302_x(1)                   #FUN-D20035
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()        #No.FUN-CB0080   Add
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF

         #FUN-D20035---add--str
          WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t302_x(2)               
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()        #No.FUN-CB0080   Add
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
         #FUN-D20035---add---end
         WHEN "qry_transaction"
            LET l_cmd = "anmt300 '",g_nmg.nmg00,"'"
            CALL cl_cmdrun_wait(l_cmd CLIPPED)  #FUN-660216 add
         WHEN "query_suspense_credit"
            IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
               LET l_cmd = "axrt300 '",g_nmg.nmg00,"' '' '24' "    #No.FUN-630020 modify
               CALL cl_cmdrun_wait(l_cmd CLIPPED)  #FUN-660216 add
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               CALL t302_v(1)
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               #系統別、類別、單號、票面金額
               CALL s_fsgl('NM',3,g_nmg.nmg00,0,g_nmz.nmz02b,1,g_nmg.nmgconf,'0',g_nmz.nmz02p)
               CALL t302_npp02('0')
            END IF
 
         WHEN "entry_sheet1"
            IF cl_chk_act_auth() THEN
               #系統別、類別、單號、票面金額
               CALL s_fsgl('NM',3,g_nmg.nmg00,0,g_nmz.nmz02c,1,g_nmg.nmgconf,'1',g_nmz.nmz02p)
               CALL t302_npp02('1')
            END IF
 
         WHEN "carry_voucher"  
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmgconf = 'Y' THEN                                                                                            
                  CALL t302_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF 
            END IF 
         WHEN "undo_carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmgconf = 'Y' THEN
                  CALL t302_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF  
            END IF 
 
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npk),'','')
            END IF
         
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmg00 IS NOT NULL THEN
                 LET g_doc.column1 = "nmg00"
                 LET g_doc.value1 = g_nmg.nmg00
                 CALL cl_doc()
               END IF
           END IF
#No.FUN-A30106 --begin                                                          
         WHEN "drill_down"                                                      
            IF cl_chk_act_auth() THEN                                           
               CALL t302_drill_down()                                           
            END IF                                                              
#No.FUN-A30106 --end
      END CASE
   END WHILE
   CLOSE t302_cs
END FUNCTION
 
FUNCTION t302_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nmg.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t302_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t302_count
   FETCH t302_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t302_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      INITIALIZE g_nmg.* TO NULL
   ELSE
      CALL t302_fetch('F')                  # 讀出TEMP第一筆並顯示
      CALL t302_b_fill_1()                  #No.FUN-CB0080   Add
      LET g_bp_flag = 'list'                #No.FUN-CB0080   Add
   END IF
END FUNCTION
 
FUNCTION t302_fetch(p_flnmg)
   DEFINE
       p_flnmg LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso  LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnmg
      WHEN 'N' FETCH NEXT     t302_cs INTO g_nmg.nmg00
      WHEN 'P' FETCH PREVIOUS t302_cs INTO g_nmg.nmg00
      WHEN 'F' FETCH FIRST    t302_cs INTO g_nmg.nmg00
      WHEN 'L' FETCH LAST     t302_cs INTO g_nmg.nmg00
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
            FETCH ABSOLUTE g_jump t302_cs INTO g_nmg.nmg00
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      INITIALIZE g_nmg.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnmg
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_nmg.* FROM nmg_file            # 重讀DB,因TEMP有不被更新特性
    WHERE nmg00 = g_nmg.nmg00
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nmg_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_nmg.nmguser     #No.FUN-4C0063
      LET g_data_group = g_nmg.nmggrup     #No.FUN-4C0063
      CALL t302_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t302_show()
   DEFINE a,b         LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
   DEFINE l_gem02     LIKE gem_file.gem02
  #DEFINE l_nml02     LIKE nml_file.nml02 #CHI-A70019 mark
   DEFINE l_aag02     LIKE aag_file.aag02
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   LET l_gem02=''
  #LET l_nml02='' #CHI-A70019 mark
   LET l_aag02=''
   CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
   END IF
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_nmg.nmg11
   IF SQLCA.sqlcode THEN
      LET l_gem02 = ' '
   END IF
  #CHI-A70019 mark --start--
  #SELECT nml02 INTO l_nml02 FROM nml_file WHERE nml01 = g_nmg.nmg17
  #IF SQLCA.sqlcode THEN
  #   LET l_nml02 = ' '
  #END IF
  #CHI-A70019 mark --end--
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_nmg.nmg30
                                             AND aag00 = g_bookno1           #No.FUN-730032
   IF SQLCA.sqlcode THEN
      LET l_aag02 = ' '
   END IF
  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      CALL cl_set_comp_visible("nmg31",TRUE)
   ELSE
      CALL cl_set_comp_visible("nmg31",FALSE)
   END IF
  #No.FUN-C90127   ---edn  --- Add
  #DISPLAY BY NAME g_nmg.nmg00,g_nmg.nmg01,g_nmg.nmg11,g_nmg.nmg17,g_nmg.nmg20, g_nmg.nmgoriu,g_nmg.nmgorig, #CHI-A70019 mark
   DISPLAY BY NAME g_nmg.nmg00,g_nmg.nmg01,g_nmg.nmg11,g_nmg.nmg20, g_nmg.nmgoriu,g_nmg.nmgorig, #CHI-A70019
                   g_nmg.nmg18,g_nmg.nmg19,g_nmg.nmg21,g_nmg.nmg23,g_nmg.nmg13,
                   g_nmg.nmg14,g_nmg.nmg25,g_nmg.nmg06,g_nmg.nmg05,g_nmg.nmg29,
                   g_nmg.nmg30,g_nmg.nmg31,g_nmg.nmg301,g_nmg.nmgconf,g_nmg.nmg24,g_nmg.nmguser, #No.FUN-680034 add g_nmg.nmg301 #No.FUN-C90127 Add nmg31
                   g_nmg.nmggrup,g_nmg.nmgmodu,g_nmg.nmgdate,g_nmg.nmgacti,
                   g_nmg.nmgud01,g_nmg.nmgud02,g_nmg.nmgud03,g_nmg.nmgud04,
                   g_nmg.nmgud05,g_nmg.nmgud06,g_nmg.nmgud07,g_nmg.nmgud08,
                   g_nmg.nmgud09,g_nmg.nmgud10,g_nmg.nmgud11,g_nmg.nmgud12,
                   g_nmg.nmgud13,g_nmg.nmgud14,g_nmg.nmgud15 
 
    LET g_t1=g_nmg.nmg00[1,g_doc_len]
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1   #MOD-770133
   IF g_nmz.nmz11 = 'Y' THEN
      LET g_dept = g_nmg.nmg11
   ELSE
      LET g_dept = ' '
   END IF
   SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
 
  #DISPLAY l_gem02,l_nml02,l_aag02 TO gem02,nml02,aag02 #CHI-A70019 mark
   DISPLAY l_gem02,l_aag02 TO gem02,aag02               #CHI-A70019
   IF  g_aza.aza63='Y' THEN
     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_nmg.nmg301                                                                
                                               AND aag00 = g_bookno2       #No.FUN-730032
     IF SQLCA.sqlcode THEN                                                                                                            
        LET l_aag02 = ' '                                                                                                             
     END IF
     DISPLAY l_aag02 TO aag021
   END IF
   CALL t302_b_fill(g_wc1)
   IF g_nmg.nmgconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
    CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t302_a()           #輸入
   DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
   MESSAGE ""
   CLEAR FORM                                # 清螢墓欄位內容
   CALL g_npk.clear()
   INITIALIZE g_nmg.* TO NULL
   LET g_nmg_t.* = g_nmg.*
   LET g_nmg.nmgconf='N'
   LET g_nmg.nmg01 = g_today
   LET g_nmg.nmgacti ='Y'                   #No:7365
   LET g_nmg.nmguser = g_user
   LET g_nmg.nmgoriu = g_user #FUN-980030
   LET g_nmg.nmgorig = g_grup #FUN-980030
   LET g_nmg.nmggrup = g_grup               #使用者所屬群
   LET g_nmg.nmgdate = g_today
   LET g_nmg.nmg03=''
   LET g_nmg.nmg04=0
   LET g_nmg.nmg05=0
   LET g_nmg.nmg06=0
   LET g_nmg.nmg24=0
   LET g_nmg.nmg25=0
   LET g_nmg.nmg07=''
   LET g_nmg.nmg08=''
   LET g_nmg.nmg09=0
   LET g_nmg.nmg20='0'
   CALL cl_opmsg('a')
  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      CALL cl_set_comp_visible("nmg31",TRUE)
   ELSE
      CALL cl_set_comp_visible("nmg31",FALSE)
   END IF
  #No.FUN-C90127   ---end  --- Add
   WHILE TRUE
      CALL t302_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_nmg.* TO NULL
         EXIT WHILE
      END IF
      IF cl_null(g_nmg.nmg00) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
        CALL s_auto_assign_no("anm",g_nmg.nmg00,g_nmg.nmg01,"3","nmg_file","nmg00","","","")
             RETURNING li_result,g_nmg.nmg00
        DISPLAY g_nmg.nmg00
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nmg.nmg00
      CALL t302_ins_nmg()
      IF SQLCA.sqlcode THEN
         CALL cl_err('t302_ins_nmg:',SQLCA.sqlcode,1)
         ROLLBACK WORK
         LET g_success = 'N'
         EXIT WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_nmg.nmg00,'I')
      END IF
      CALL g_npk.clear()
      SELECT nmg00 INTO g_nmg.nmg00 FROM nmg_file WHERE nmg00 = g_nmg.nmg00
      LET g_nmg_t.* = g_nmg.*
      LET g_rec_b=0
      CALL t302_b()
      MESSAGE " Wait ...."
      CALL s_showmsg_init()  #TQC-B10069
      IF g_nmy.nmydmy1 = 'Y' THEN
         CALL t302_firm1()  
      END IF
      CALL s_showmsg()       #TQC-B10069
      MESSAGE ""
      EXIT WHILE
   END WHILE
   LET g_wc=' '
END FUNCTION
 
FUNCTION t302_i(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_n       LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE l_tot     LIKE type_file.num20_6 #No.FUN-4C0010  #No.FUN-680107 DECIMAL(20,6)
    DEFINE g_dept    LIKE gem_file.gem01
    DEFINE l_nma02   LIKE nma_file.nma02
    DEFINE l_aag02   LIKE aag_file.aag02
    DEFINE l_nma21   LIKE nma_file.nma21
    DEFINE l_nmaacti LIKE nma_file.nmaacti
    DEFINE l_flag    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_msg     LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(30)
    DEFINE g_t1      LIKE nmy_file.nmyslip  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    DEFINE li_result LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
    DEFINE l_nu      LIKE type_file.num5    #No.CHI-790008
    DEFINE l_aag05   LIKE aag_file.aag05    #FUN-8C0107 add
    DEFINE l_aag05_1 LIKE aag_file.aag05    #FUN-8C0107 add
    DEFINE l_nmg19   LIKE nmg_file.nmg19    #MOD-C80101
    DEFINE l_unpay1  LIKE apa_file.apa35    #No.FUN-C90127 Add
    DEFINE l_unpay2  LIKE apa_file.apa35    #No.FUN-C90127 Add
    DEFINE l_npk08   LIKE npk_file.npk08    #No.FUN-C90127 Add
    DEFINE l_occ42   LIKE occ_file.occ42    #FUN-D80072
    DEFINE l_occ67   LIKE occ_file.occ67    #FUN-D80072
    DEFINE l_ool23   LIKE ool_file.ool23    #FUN-D80072
    DEFINE l_ool231  LIKE ool_file.ool231   #FUN-D80072

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   #INPUT BY NAME g_nmg.nmg00,g_nmg.nmg01,g_nmg.nmg11,g_nmg.nmg17,g_nmg.nmg20, g_nmg.nmgoriu,g_nmg.nmgorig, #CHI-A70019 mark
    INPUT BY NAME g_nmg.nmg00,g_nmg.nmg01,g_nmg.nmg11,g_nmg.nmg20, g_nmg.nmgoriu,g_nmg.nmgorig, #CHI-A70019
                  g_nmg.nmg18,g_nmg.nmg19,g_nmg.nmg21,g_nmg.nmgconf,g_nmg.nmg31, #NO.FUN-C90127 Add
                  g_nmg.nmg30,g_nmg.nmg301,g_nmg.nmg13,g_nmg.nmg14,g_nmg.nmg23,g_nmg.nmg05,          #No.FUN-680034 add g_nmg.nmg301
                  g_nmg.nmg24,g_nmg.nmguser,g_nmg.nmggrup,g_nmg.nmgmodu,g_nmg.nmgdate,g_nmg.nmgacti,
                  g_nmg.nmgud01,g_nmg.nmgud02,g_nmg.nmgud03,g_nmg.nmgud04,
                  g_nmg.nmgud05,g_nmg.nmgud06,g_nmg.nmgud07,g_nmg.nmgud08,
                  g_nmg.nmgud09,g_nmg.nmgud10,g_nmg.nmgud11,g_nmg.nmgud12,
                  g_nmg.nmgud13,g_nmg.nmgud14,g_nmg.nmgud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t302_set_entry(p_cmd)
         CALL t302_set_no_entry(p_cmd)
         CALL t302_set_no_required(p_cmd)
         CALL t302_set_required(p_cmd)
         LET g_before_input_done = TRUE
 
         CALL cl_set_docno_format("nmg00")
         CALL cl_set_docno_format("nmg21")
 
        AFTER FIELD nmg00
           #FUN-B90075 add 修改状态也应控管
         IF NOT cl_null(g_nmg.nmg00) AND (p_cmd = 'a' OR p_cmd = 'u' AND g_nmg.nmg00 <> g_nmg_t.nmg00) THEN   #No.MOD-C90197
           CALL s_check_no("anm",g_nmg.nmg00,g_nmg_t.nmg00,"3",""," ","")
              RETURNING li_result,g_nmg.nmg00
           DISPLAY BY NAME g_nmg.nmg00
           IF (NOT li_result) THEN
              NEXT FIELD nmg00
           END IF
         END IF    #No.MOD-C90197
           #FUN-B90075 add--end
            IF p_cmd = 'a' THEN   #MOD-580033
              #FUN-B90075 mark 修改状态也应控管
              #CALL s_check_no("anm",g_nmg.nmg00,g_nmg_t.nmg00,"3",""," ","")
              #  RETURNING li_result,g_nmg.nmg00
              #DISPLAY BY NAME g_nmg.nmg00
              #FUN-B90075 mark--end
               CALL s_get_doc_no(g_nmg.nmg00) RETURNING g_nmg.nmg00
              #FUN-B90075 mark 修改状态也应控管
              #IF (NOT li_result) THEN
              #   NEXT FIELD nmg00
              #END IF
              #FUN-B90075 mark--end
            END IF
 
        AFTER FIELD nmg01
           IF NOT cl_null(g_nmg.nmg01) THEN
              IF g_nmg.nmg01 <= g_nmz.nmz10 THEN  #no.5261
                 CALL cl_err('','aap-176',1) NEXT FIELD nmg01
              END IF
              IF g_nmy.nmydmy3 = 'Y'THEN
                 CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
                 SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno1
                 IF g_nmg.nmg01 <= l_aaa07 THEN
                    CALL cl_err('','aap-176',1)
                    NEXT FIELD nmg01
                 END IF
                 IF g_aza.aza63 = 'Y' THEN
                    SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno2
                    IF g_nmg.nmg01 <= l_aaa07 THEN
                       CALL cl_err('','aap-176',1)
                       NEXT FIELD nmg01
                    END IF
                 END IF
              END IF
              DECLARE t302_date CURSOR FOR              # LOCK CURSOR
                  SELECT nma21 FROM nma_file,npk_file
                   WHERE nma01 = npk04 AND npk00 = g_nmg.nmg00
              FOREACH t302_date INTO l_nma21
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('sel t302_date',SQLCA.sqlcode,0)   
                    EXIT FOREACH
                 END IF
                 IF g_nmg.nmg01 <= l_nma21 THEN
                    CALL cl_err(g_nmg.nmg01,'anm-077',0)
                    NEXT FIELD nmg01
                 END IF
              END FOREACH
           END IF
 
        AFTER FIELD nmg11                                       # Dept
 
           IF NOT cl_null(g_nmg.nmg11) THEN
              CALL t302_nmg11('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nmg.nmg11,g_errno,0)
                 NEXT FIELD nmg11
              END IF
 
              IF p_cmd = 'u' OR g_nmg.nmg11 != g_nmg_t.nmg11 THEN
                #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_nmg.nmg30
                    AND aag00 = g_bookno1    
                
                 LET g_errno = ' '   
                 IF l_aag05 = 'Y' AND NOT cl_null(g_nmg.nmg30) THEN 
                    IF g_aaz.aaz90 !='Y' THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       CALL s_chkdept(g_aaz.aaz72,g_nmg.nmg30,g_nmg.nmg11,g_bookno1)  
                                     RETURNING g_errno
                    END IF 
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD nmg11
                    END IF
                 END IF
 
                #會計科目二
                 IF g_aza.aza63='Y' THEN
                    LET l_aag05_1=''
                    SELECT aag05 INTO l_aag05_1 FROM aag_file
                     WHERE aag01 = g_nmg.nmg301
                       AND aag00 = g_bookno2    
                    
                    LET g_errno = ' '   
                    IF l_aag05_1 = 'Y' AND NOT cl_null(g_nmg.nmg301) THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          CALL s_chkdept(g_aaz.aaz72,g_nmg.nmg301,g_nmg.nmg11,g_bookno2) 
                                        RETURNING g_errno
                       END IF
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD nmg11
                       END IF
                    END IF
                 END IF
              END IF
 
           END IF
 
           IF g_nmz.nmz11 = 'Y' THEN
              LET g_dept = g_nmg.nmg11
           ELSE
              LET g_dept = ' '
           END IF
           SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
 
        BEFORE FIELD nmg20
           CALL t302_set_entry(p_cmd)
           CALL t302_set_no_required(p_cmd)

       #No.FUN-C90127   ---start--- Add
        ON CHANGE nmg20 
           IF g_nmg.nmg20 = '1' AND g_aza.aza26 = '2' THEN
              CALL cl_set_comp_visible("nmg31",TRUE) 
           ELSE        
              CALL cl_set_comp_visible("nmg31",FALSE)
           END IF                       
       #No.FUN-C90127   ---end  --- Add

        AFTER FIELD nmg20
           IF NOT cl_null(g_nmg.nmg20) THEN
              IF g_nmg.nmg20 != '21' AND g_nmg.nmg20 !='22' AND
                 g_nmg.nmg20 != '0'  AND g_nmg.nmg20 != '1' THEN
                 NEXT FIELD nmg20
              END IF
              IF g_nmg.nmg20[1,1] NOT MATCHES "[012]" THEN
                 NEXT FIELD nmg20
              END IF
#No.MOD-C90198 --begin
              IF g_nmg.nmg20 = '21' THEN 
              	 LET l_n = 0 
              	 SELECT COUNT(*) INTO l_n FROM npk_file WHERE npk00 = g_nmg.nmg00 AND npk03 ='2' 
              	 IF l_n >0 THEN 
              	 	  CALL cl_err('','anm-318',1)
              	 	  NEXT FIELD nmg20
                 END IF 
              END IF 
#No.MOD-C90198 --end
              IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND g_nmy.nmydmy3='Y' THEN
                 LET g_nmg.nmg29='Y'
                 #FUN-D80072--mark--str--
                 #IF cl_null(g_nmg.nmg30) THEN
                 #   LET g_nmg.nmg30=g_nms.nms28
                 #END IF
                 #IF cl_null(g_nmg.nmg301) AND g_aza.aza63='Y' THEN
                 #   LET g_nmg.nmg301=g_nms.nms28
                 #END IF
                 #FUN-D80072--mark--end
              ELSE
                 LET g_nmg.nmg29='N'
                 LET g_nmg.nmg30=NULL
                 LET g_nmg.nmg301=NULL                                 #No.FUN-680034
              END IF
              DISPLAY BY NAME g_nmg.nmg29,g_nmg.nmg30,g_nmg.nmg301     #No.FUN-680034 add g_nmg.nmg301
              CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN
                 CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
              END IF
              LET l_aag02=''
              SELECT aag02 INTO l_aag02 FROM aag_file
               WHERE aag01=g_nmg.nmg30
                 AND aag00 = g_bookno1       #No.FUN-730032
              DISPLAY l_aag02 TO aag02
     IF  g_aza.aza63='Y' THEN                                                                                                         
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = g_nmg.nmg301                                                             
                                                   AND aag00 = g_bookno2       #No.FUN-730032
         IF SQLCA.sqlcode THEN                                                                                                          
            LET l_aag02 = ''                                                                                                           
         END IF                                                                                                                         
         DISPLAY l_aag02 TO aag021                                                                                                      
     END IF                                                                                                                           
           END IF
           CALL t302_set_no_entry(p_cmd)
           CALL t302_set_required(p_cmd)
          #No.FUN-C90127   ---start--- Add
           IF g_nmg.nmg20 = '1' AND g_aza.aza26 = '2' THEN
              SELECT COUNT(*) INTO l_n FROM npk_file WHERE npk00 = g_nmg.nmg00 AND npk03 != '2'
              IF l_n > 0 THEN
                 CALL cl_err('','anm-328','1')
                 NEXT FIELD nmg20
              END IF
              CALL cl_set_comp_visible("nmg31",TRUE)
           ELSE
              CALL cl_set_comp_visible("nmg31",FALSE)
              LET g_nmg.nmg31 = Null
           END IF
          #No.FUN-C90127   ---end  --- Add
 
        AFTER FIELD nmg30
           IF NOT cl_null(g_nmg.nmg30) THEN
              CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN
                 CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
              END IF
              
              CALL s_aapact('2',g_bookno1,g_nmg.nmg30) RETURNING g_msg      #No.MOD-740398
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('s_aapact:',g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmg.nmg30,'23',g_bookno1)
                    RETURNING g_nmg.nmg30
                 DISPLAY BY NAME g_nmg.nmg30 
#FUN-B20073 --end--                 
                 NEXT FIELD nmg30
              END IF
              LET l_aag02=''
              LET l_aag05=''    #FUN-8C0107 add
              SELECT aag02,aag05 INTO l_aag02,l_aag05 FROM aag_file  #FUN-8C0107 add aag05,l_aag05
               WHERE aag01=g_nmg.nmg30
                 AND aag00 = g_bookno1       #No.FUN-730032
              DISPLAY l_aag02 TO aag02
             #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
              LET g_errno = ' '   
              IF l_aag05 = 'Y' AND NOT cl_null(g_nmg.nmg11) THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_nmg.nmg30,g_nmg.nmg11,g_bookno1)  
                                  RETURNING g_errno
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD nmg30
                 END IF
              END IF
 
           END IF
 
        AFTER FIELD nmg301
           IF NOT cl_null(g_nmg.nmg301) THEN
              CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN
                 CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
              END IF
              CALL s_aapact('2',g_bookno2,g_nmg.nmg301) RETURNING g_msg      #No.MOD-740398
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('s_aapact:',g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmg.nmg301,'23',g_bookno2)     
                   RETURNING g_nmg.nmg301
                 DISPLAY BY NAME g_nmg.nmg301 
#FUN-B20073 --end--                 
                 NEXT FIELD nmg301
              END IF
              LET l_aag02=''                                                                                                       
              SELECT aag02,aag05 INTO l_aag02,l_aag05_1 FROM aag_file     #FUN-8C0107 add aag05,l_aag05_1                                                                          
               WHERE aag01=g_nmg.nmg301                                                                                              
                 AND aag00 = g_bookno2       #No.FUN-730032
              DISPLAY l_aag02 TO aag021
 
             #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
              LET g_errno = ' '   
              IF l_aag05 = 'Y' AND NOT cl_null(g_nmg.nmg11) THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_nmg.nmg301,g_nmg.nmg11,g_bookno2)  
                                  RETURNING g_errno
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD nmg301
                 END IF
              END IF
 
           END IF
 
        AFTER FIELD nmg18
           IF g_nmg.nmg20[1,1] MATCHES "[12]" AND cl_null(g_nmg.nmg18) THEN
              CALL cl_err('nmg20=1/2:','axm-117',0)
              NEXT FIELD nmg20
           END IF
           IF cl_null(g_nmg.nmg18) THEN
             LET g_nmg.nmg19 = ''
             DISPLAY BY NAME g_nmg.nmg19
           END IF
           IF g_nmg.nmg20[1,1] = '1' AND g_nmg.nmg18 != 'MISC' THEN
              SELECT pmc03 INTO g_nmg.nmg19 FROM pmc_file
               WHERE pmc01=g_nmg.nmg18 AND pmcacti IN ('Y','y')
               DISPLAY "g_nmg.nmg19=",g_nmg.nmg19
              IF SQLCA.sqlcode THEN   #No.TQC-950085
                 CALL cl_err3("sel","pmc_file",g_nmg.nmg18,"",STATUS,"","sel pmc",1)  #No.FUN-660148
                 NEXT FIELD nmg18
              END IF
              DISPLAY BY NAME g_nmg.nmg19
           END IF
           #IF g_nmg.nmg20[1,1] = '2' AND g_nmg.nmg18 != 'MISC' THEN   #MOD-C80101 mark
           IF g_nmg.nmg20 = '22' AND g_nmg.nmg18 != 'MISC' THEN        #MOD-C80101
              SELECT occ02 INTO g_nmg.nmg19 FROM occ_file
               WHERE occ01=g_nmg.nmg18 AND occacti IN ('Y','y')
                 AND (occ06 = '1' OR occ06 = '3')                      #MOD-CC0027 add
              IF SQLCA.sqlcode THEN   #No.TQC-950085
                 CALL cl_err3("sel","occ_file",g_nmg.nmg18,"",STATUS,"","sel occ",1)  #No.FUN-660148
                 NEXT FIELD nmg18
              END IF
              DISPLAY BY NAME g_nmg.nmg19
           END IF
           #No.MOD-C80101  --Begin
           IF g_nmg.nmg20 = '21' AND g_nmg.nmg18 != 'MISC' THEN 
              LET l_nmg19 = NULL                                          #TQC-D40062 add
                  IF NOT cl_null(g_nmg.nmg18) THEN 
                     SELECT occ02 INTO l_nmg19 FROM occ_file
                  WHERE occ01=g_nmg.nmg18 AND occacti IN ('Y','y')
                    AND (occ06 = '1' OR occ06 = '3')                      #MOD-CC0027 add
#                IF g_nmg.nmg19 <> l_nmg19 THEN 
                 IF  l_nmg19 IS NULL THEN   #No.MOD-CA0176
                    SELECT pmc03 INTO l_nmg19 FROM pmc_file
                     WHERE pmc01=g_nmg.nmg18 AND pmcacti IN ('Y','y')     
#                   IF g_nmg.nmg19 <> l_nmg19 THEN 
                    IF  l_nmg19 IS NULL THEN   #No.MOD-CA0176
                      CALL cl_err3("sel","occ_file or pmc_file",g_nmg.nmg18,"",STATUS,"","sel occ",1)
                      NEXT FIELD nmg18
                    ELSE 
                         LET g_nmg.nmg19 = l_nmg19
                    END IF
                 ELSE 
                          LET g_nmg.nmg19 = l_nmg19
                 END IF
               END IF     
            DISPLAY BY NAME g_nmg.nmg19  
           END IF
     
           #No.MOD-C80101  --End
           LET g_nmg_o.nmg19 = g_nmg.nmg19
           #FUN-D80072--add--str--
           IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND g_nmy.nmydmy3='Y'
              AND NOT cl_null(g_nmg.nmg18) AND g_nmg.nmg29='Y' THEN
              LET l_occ42=''
              LET l_occ67=''
              SELECT occ42,occ67 INTO l_occ42,l_occ67 FROM occ_file
               WHERE occ01=g_nmg.nmg18
              IF l_occ42=g_aza.aza17 THEN
                 IF cl_null(g_nmg.nmg30) THEN
                    LET g_nmg.nmg30=g_nms.nms28
                 END IF
                 IF cl_null(g_nmg.nmg301) AND g_aza.aza63='Y' THEN
                    LET g_nmg.nmg301=g_nms.nms28
                 END IF
              ELSE
                 LET l_ool23=''
                 LET l_ool231=''
                 SELECT ool23,ool231 INTO l_ool23,l_ool231 FROM ool_file
                  WHERE ool01=l_occ67
                 IF cl_null(g_nmg.nmg30) THEN
                    IF NOT cl_null(l_ool23) THEN
                       LET g_nmg.nmg30=l_ool23
                    ELSE
                       LET g_nmg.nmg30=g_nms.nms28
                    END IF
                 END IF
                 IF cl_null(g_nmg.nmg301) AND g_aza.aza63='Y' THEN
                    IF NOT cl_null(l_ool231) THEN
                       LET g_nmg.nmg301=l_ool231
                    ELSE
                       LET g_nmg.nmg301=g_nms.nms28
                    END IF
                 END IF
              END IF
           END IF
           DISPLAY BY NAME g_nmg.nmg30,g_nmg.nmg301
           CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
           IF g_flag = '1' THEN
              CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
           END IF
           LET l_aag02=''
           SELECT aag02 INTO l_aag02 FROM aag_file
            WHERE aag01=g_nmg.nmg30
              AND aag00 = g_bookno1
           DISPLAY l_aag02 TO aag02
           IF g_aza.aza63='Y' THEN
              SELECT aag02 INTO l_aag02 FROM aag_file
               WHERE aag01 = g_nmg.nmg301
                 AND aag00 = g_bookno2
              IF SQLCA.sqlcode THEN
                 LET l_aag02 = ''
              END IF
              DISPLAY l_aag02 TO aag021
           END IF
           #FUN-D80072--add--end

        BEFORE FIELD nmg19
            IF g_nmg.nmg18 = 'MISC' THEN
               CALL cl_set_comp_entry("nmg19",TRUE)
            ELSE
               CALL cl_set_comp_entry("nmg19",FALSE)
            END IF
 
        AFTER FIELD nmg19
           CALL cl_set_comp_entry("nmg19",TRUE)
 
       #No.FUN-C90127   ---start---   Add
        AFTER FIELD nmg31
           IF NOT cl_null(g_nmg.nmg31) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM aph_file,apa_file
               WHERE aph23 = apa01
                 AND aph01 = g_nmg.nmg31
                #AND aph03 = 'E'  #FUN-CB0117 mark
                 AND aph03 ='H'   #FUN-CB0117
                
              IF l_n < 1 THEN
                 CALL cl_err('','anm-323','1')
                 NEXT FIELD nmg31
              END IF
              LET l_unpay1 = 0
              LET l_unpay1 = 0
              SELECT apa34 - apa35,apa34f - apa35f INTO l_unpay1,l_unpay2
                FROM apa_file,aph_file
               WHERE apa01 = aph23
                 AND aph01 = g_nmg.nmg31
                 AND aph03 ='H'   #FUN-CB0117
              IF l_unpay1 = 0 THEN
                 CALL cl_err('','anm-326','1')
                 NEXT FIELD nmg31
              END IF
              SELECT SUM(npk08) INTO l_npk08 FROM npk_file WHERE npk00 = g_nmg.nmg00
              IF l_npk08 > l_unpay2 THEN
                 CALL cl_err("","anm-329","1")
                 NEXT FIELD nmg31
              END IF
           END IF
       #No.FUN-C90127   ---end  ---   Add

        AFTER FIELD nmg21
           IF g_nmg.nmg20='22' AND cl_null(g_nmg.nmg21) THEN                           #CHI-790008                                  
              CALL cl_err('nmg20=22:','anm-128',0)                                     #CHI-790008 anm-119->anm-128
              NEXT FIELD nmg21
           END IF
           IF g_nmg.nmg20='22' AND NOT cl_null(g_nmg.nmg21) THEN                       #CHI-790008
              SELECT COUNT(*) INTO l_nu FROM olc_file                                                                         
               WHERE olc01 = g_nmg.nmg21
              IF l_nu = 0 THEN
                 CALL cl_err3("sel","olc_file",g_nmg.nmg21,"",STATUS,"","sel olc",1)
                 NEXT FIELD nmg21
              END IF     
           END IF
 
       #CHI-A70019 mark --start--
       #AFTER FIELD nmg17
       #   IF NOT cl_null(g_nmg.nmg17) THEN
       #      CALL t302_nmg17('a')
       #      IF NOT cl_null(g_errno) THEN
       #         CALL cl_err('',g_errno,0)
       #         NEXT FIELD nmg17
       #      END IF
       #   END IF
       #CHI-A70019 mark --end--
 
        AFTER FIELD nmgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_nmg.nmguser = s_get_data_owner("nmg_file") #FUN-C10039
           LET g_nmg.nmggrup = s_get_data_group("nmg_file") #FUN-C10039
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF g_nmg.nmg20[1,1] MATCHES "[12]" AND cl_null(g_nmg.nmg18) THEN
              CALL cl_err('nmg20=1/2:','axm-117',0)
              NEXT FIELD nmg20
           END IF
 
           IF g_nmg.nmg20='22' AND cl_null(g_nmg.nmg21) THEN                                                  
              CALL cl_err('nmg20=22:','anm-128',0)                                                                                  
              NEXT FIELD nmg21                                                                                                      
           END IF   
           IF g_nmg.nmg20='22' AND NOT cl_null(g_nmg.nmg21) THEN   #MOD-880019 add
              SELECT COUNT(*) INTO l_nu FROM olc_file                                                                               
               WHERE olc01 = g_nmg.nmg21                                                                                            
              IF l_nu = 0 THEN                                                                                                      
                 CALL cl_err3("sel","olc_file",g_nmg.nmg21,"",STATUS,"","sel olc",1)                                                                                   
                 NEXT FIELD nmg21                                                                                                   
              END IF                                                                                                                
           END IF   #MOD-880019 add
 
           IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND
               g_nmy.nmydmy3='Y' THEN
              IF cl_null(g_nmg.nmg29) THEN
                 LET g_nmg.nmg29='Y'
              END IF
           ELSE
              IF cl_null(g_nmg.nmg29) THEN
                 LET g_nmg.nmg29='N'
              END IF
           END IF
           DISPLAY BY NAME g_nmg.nmg29
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nmg00)
                 LET g_t1 = s_get_doc_no(g_nmg.nmg00)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'3','ANM') RETURNING g_t1  #TQC-670008
                 LET g_nmg.nmg00 = g_t1     #No.FUN-550057
                 DISPLAY BY NAME g_nmg.nmg00 NEXT FIELD nmg00
              WHEN INFIELD(nmg11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_nmg.nmg11
                 CALL cl_create_qry() RETURNING g_nmg.nmg11
                 DISPLAY BY NAME g_nmg.nmg11 
                 NEXT FIELD nmg11
             #CHI-A70019 mark --start--
             # WHEN INFIELD(nmg17) #變動碼
             #    CALL cl_init_qry_var()
             #    LET g_qryparam.form = "q_nml"
             #    LET g_qryparam.default1 = g_nmg.nmg17
             #    CALL cl_create_qry() RETURNING g_nmg.nmg17
             #    DISPLAY BY NAME g_nmg.nmg17
             #    CALL t302_nmg17('d')
             #    NEXT FIELD nmg17
             #CHI-A70019 mark --end--
              WHEN INFIELD(nmg18)
                 IF g_nmg.nmg20[1,1] = '1' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form="q_pmc"
                    LET g_qryparam.default1=g_nmg.nmg18
                    CALL cl_create_qry() RETURNING g_nmg.nmg18
                    DISPLAY BY NAME g_nmg.nmg18
                    NEXT FIELD nmg18
                 END IF
                 #IF g_nmg.nmg20[1,1] = '2' THEN      #MOD-C80101 mark
                 IF g_nmg.nmg20 = '22' THEN          #MOD-C80101
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = g_nmg.nmg18
                    CALL cl_create_qry() RETURNING g_nmg.nmg18
                    DISPLAY BY NAME g_nmg.nmg18
                    NEXT FIELD nmg18
                 END IF

                 #No.MOD-C80101  --Begin
                 IF g_nmg.nmg20 = '21' THEN 
                    CALL q_occ_pmc(FALSE,TRUE,g_plant) RETURNING g_nmg.nmg18,g_nmg.nmg19 #MOD-C90076
                    DISPLAY BY NAME g_nmg.nmg18
                    DISPLAY BY NAME g_nmg.nmg19
                    NEXT FIELD nmg18
                 END IF
                 #No.MOD-C80101  --End
              WHEN INFIELD(nmg21)
                 DISPLAY "g_nmg.nmg20=",g_nmg.nmg20
                  IF g_nmg.nmg20[1,1] = '2' THEN    #MOD-
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_olc2"                                        #CHI-790008 q_ola->q_olc2    
                    LET g_qryparam.default1 = g_nmg.nmg21
                    CALL cl_create_qry() RETURNING g_nmg.nmg21
                    DISPLAY BY NAME g_nmg.nmg21
                    NEXT FIELD nmg21
                 END IF
              WHEN INFIELD(nmg30)
                  CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                  END IF
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmg.nmg30,'23',g_bookno1) #MOD-4A0349     #No.FUN-980025 
                 RETURNING g_nmg.nmg30
                 DISPLAY BY NAME g_nmg.nmg30 NEXT FIELD nmg30
             WHEN INFIELD(nmg301)
                  CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmg.nmg301,'23',g_bookno2)      #No.FUN-980025
                 RETURNING g_nmg.nmg301
                 DISPLAY BY NAME g_nmg.nmg301 NEXT FIELD nmg301
             #No.FUN-C90127---start---Add
              WHEN INFIELD(nmg31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_aph1"
                 LET g_qryparam.default1=g_nmg.nmg31
                 LET g_qryparam.where = "apf03 = '",g_nmg.nmg18,"' AND apf12 = '",g_nmg.nmg19,"'  AND aph03 = 'H' " #FUN-CB0117 add 'aph03=H'
                 CALL cl_create_qry() RETURNING g_nmg.nmg31
                 DISPLAY BY NAME g_nmg.nmg31
                 NEXT FIELD nmg31
             #No.FUN-C90127---end  ---Add
              OTHERWISE EXIT CASE
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
END FUNCTION
 
FUNCTION t302_nmg11(p_cmd)                  #DEPT代號
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_gem02   LIKE gem_file.gem02,
          l_gemacti LIKE gem_file.gemacti
   DEFINE l_gem05   LIKE gem_file.gem05     #MOD-530676 判斷是否為會計部門
 
   LET g_errno = ' '
   LET l_gem02 = ' '
    SELECT gem02,gemacti,gem05 INTO l_gem02,l_gemacti,l_gem05  #MOD-530676判斷是否為會計部門
     FROM gem_file WHERE gem01 = g_nmg.nmg11
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                           LET l_gem02 = NULL
        WHEN l_gemacti='N' LET g_errno = '9028'
         WHEN l_gem05 <> 'Y' LET g_errno =  'anm-064'  #END MOD-530676
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION

#FUN-C80031---ADD--STR
FUNCTION t302_npk16(p_npk16)                  #DEPT代號
   DEFINE p_npk16   LIKE npk_file.npk16,   
          l_gem02   LIKE gem_file.gem02, 
          l_gemacti LIKE gem_file.gemacti
   DEFINE l_gem05   LIKE gem_file.gem05     
 
   LET g_errno = ' '
   LET l_gem02 = ' '
    SELECT gem02,gemacti,gem05 INTO l_gem02,l_gemacti,l_gem05  
     FROM gem_file WHERE gem01 =p_npk16 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                           LET l_gem02 = NULL
        WHEN l_gemacti='N' LET g_errno = '9028'
         WHEN l_gem05 <> 'Y' LET g_errno =  'anm-064'  
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno)  THEN
      LET g_npk[l_ac].gem02_1 = l_gem02
      DISPLAY BY NAME g_npk[l_ac].gem02_1 
   END IF
END FUNCTION
#FUN-C80031--ADD--END 


#CHI-A70019 mark --start--
#FUNCTION t302_nmg17(p_cmd)
#   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#   DEFINE l_nmlacti LIKE nml_file.nmlacti
#   DEFINE l_nml02   LIKE nml_file.nml02
# 
#   SELECT nmlacti,nml02 INTO l_nmlacti,l_nml02 FROM nml_file
#    WHERE nml01 = g_nmg.nmg17
#   LET g_errno = ' '
#   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
#        WHEN l_nmlacti = 'N'     LET g_errno = '9028'
#        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
#   END CASE
#   DISPLAY l_nml02 TO nml02
#END FUNCTION
#CHI-A70019 mark --end--
 
FUNCTION t302_b()
DEFINE
   l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
   l_row,l_col     LIKE type_file.num5,   #分段輸入之行,列數  #No.FUN-680107 SMALLINT
   l_n,l_cnt       LIKE type_file.num5,   #檢查重複用  #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-680107 VARCHAR(1)
   l_nmaacti       LIKE nma_file.nmaacti,
   l_nma05         LIKE nma_file.nma05,
   l_nma051        LIKE nma_file.nma051,  #No.FUN-680034   
   l_nma21         LIKE nma_file.nma21,
   l_b2            LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(30)
   l_qty           LIKE type_file.num20_6,#No.FUN-680107 DECIMAL(15,3)
   l_flag          LIKE type_file.num10,  #No.FUN-680107 INTEGER
   l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5,   #可刪除否  #No.FUN-680107 SMALLINT
   l_aag05,l_aag05_1  LIKE aag_file.aag05,#FUN-C80031   add
   l_apa13         LIKE apa_file.apa13,   #No.FUN-C90127 Add
   l_apa14         LIKE apa_file.apa14,   #No.FUN-C90127 Add
   i               LIKE type_file.num5,   #No.FUN-C90127 Add
   l_unpay1        LIKE apa_file.apa35,   #No.FUN-C90127 Add
   l_unpay2        LIKE apa_file.apa35,   #No.FUN-C90127 Add
   l_amt           LIKE npk_file.npk08,   #No.FUN-C90127 Add
   l_amt1          LIKE npk_file.npk08    #No.FUN-C90127 Add
 DEFINE l_n2      LIKE aeh_file.aeh11     #add by liyjf170330 
 #No:181121 s---
 DEFINE l_nmp06    LIKE  nmp_file.nmp06
 DEFINE l_nmp09    LIKE  nmp_file.nmp09
 DEFINE l_nmp06_1  LIKE  nmp_file.nmp06
 DEFINE l_nmp09_1  LIKE  nmp_file.nmp09
 DEFINE l_yy       LIKE  type_file.num5
 DEFINE l_mm       LIKE  type_file.num5
 #No:181121 e--- 
 # add by zhangsba190708---s
 DEFINE l_d1       LIKE nme_file.nme04
 DEFINE l_d2       LIKE nme_file.nme08
 DEFINE l_c1       LIKE nme_file.nme04
 DEFINE l_c2       LIKE nme_file.nme08
 # add by zhangsba190708---e
   LET g_action_choice = ""
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
   IF cl_null(g_nmg.nmg00) THEN
      RETURN
   END IF
   IF g_nmg.nmgconf = 'Y' THEN
      CALL cl_err('','anm-105',0)
      RETURN
   END IF
   IF g_nmg.nmgconf='X' THEN
      CALL cl_err(g_nmg.nmg00,'9024',0)
      RETURN
   END IF
   CALL cl_opmsg('b')

  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      SELECT apa13,apa14,apa34 - apa35,apa34f - apa35f INTO l_apa13,l_apa14,l_unpay1,l_unpay2
        FROM apa_file,aph_file
       WHERE apa01 = aph23
         AND aph01 = g_nmg.nmg31
   END IF
  #No.FUN-C90127   ---end  --- Add 

   LET g_forupd_sql = "SELECT * FROM npk_file WHERE npk00=? AND npk01=?",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t302_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_npk WITHOUT DEFAULTS FROM s_npk.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
         IF g_rec_b!=0 THEN
           CALL fgl_set_arr_curr(l_ac)
         END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET p_cmd = 'a'
          LET l_ac = ARR_CURR()
          LET g_success = 'Y'
          LET l_lock_sw = 'N'                   #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN t302_cl USING g_nmg.nmg00
          IF STATUS THEN
             CALL cl_err("OPEN t302_cl:", STATUS, 1)
             CLOSE t302_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t302_cl INTO g_nmg.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
             CLOSE t302_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_npk_t.* = g_npk[l_ac].*  #BACKUP
             OPEN t302_bcl USING g_nmg.nmg00,g_npk_t.npk01
             IF STATUS THEN
                CALL cl_err("OPEN t302_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t302_bcl INTO b_npk.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock npk',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL t302_b_move_to()
                END IF
             END IF
             LET g_before_input_done = FALSE
             CALL t302_set_entry_b(p_cmd)
             CALL t302_set_no_entry_b(p_cmd)
             LET g_before_input_done = TRUE
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_npk[l_ac].* TO NULL
          IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND g_nmy.nmydmy3='Y' THEN
             IF cl_null(g_npk[l_ac].npk071) THEN
                LET g_npk[l_ac].npk071=g_nmg.nmg30
             END IF
             IF cl_null(g_npk[l_ac].npk073) AND g_aza.aza63='Y' THEN
                LET g_npk[l_ac].npk073=g_nmg.nmg301
             END IF
          END IF
          LET b_npk.npk00=g_nmg.nmg00
          IF l_ac > 1 THEN
             LET g_npk[l_ac].npk05=g_npk[l_ac-1].npk05
             LET g_npk[l_ac].npk10=g_npk[l_ac-1].npk10
          END IF
          LET g_before_input_done = FALSE
          CALL t302_set_entry_b(p_cmd)
          LET g_before_input_done = TRUE
          INITIALIZE g_npk_t.* TO NULL
          LET g_npk_t.* = g_npk[l_ac].*          #yinhy130807
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD npk01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
             IF g_npk[l_ac].npk03 = '1' THEN                              #MOD-870274
                IF g_npk[l_ac].npk071 <> g_nmg.nmg30 OR
                   g_npk[l_ac].npk071 IS NULL THEN
                   CALL cl_err(g_npk[l_ac].npk071,'anm-066',1)
                   LET g_npk[l_ac].npk071 = g_nmg.nmg30
                   DISPLAY BY NAME g_npk[l_ac].npk071
                END IF
                IF g_aza.aza63 = 'Y' THEN        #MOD-9C0358 add
                   IF g_npk[l_ac].npk073 <> g_nmg.nmg301 OR
                      g_npk[l_ac].npk073 IS NULL THEN
                      CALL cl_err(g_npk[l_ac].npk073,'anm-066',1)
                      LET g_npk[l_ac].npk073 = g_nmg.nmg301
                      DISPLAY BY NAME g_npk[l_ac].npk073
                   END IF
                END IF                           #MOD-9C0358 add
             END IF
          END IF
          CALL t302_b_move_back()
          INSERT INTO npk_file VALUES(b_npk.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","npk_file",b_npk.npk00,b_npk.npk01,SQLCA.sqlcode,"","ins npk",1)  #No.FUN-660148
             CANCEL INSERT
          ELSE
             CALL t302_bu()
             IF g_success='Y' THEN
                COMMIT WORK
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
             ELSE
                ROLLBACK WORK
                MESSAGE 'ROLLBACK'
             END IF
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       BEFORE FIELD npk01                            #default 序號
          IF cl_null(g_npk[l_ac].npk01) OR g_npk[l_ac].npk01 = 0 THEN
              SELECT max(npk01)+1 INTO g_npk[l_ac].npk01
                 FROM npk_file WHERE npk00 = g_nmg.nmg00
              IF cl_null(g_npk[l_ac].npk01) THEN
                  LET g_npk[l_ac].npk01 = 1
              END IF
          END IF
 
       AFTER FIELD npk01                        #check 序號是否重複
          IF NOT cl_null(g_npk[l_ac].npk01) THEN
             IF g_npk[l_ac].npk01 != g_npk_t.npk01 OR
                cl_null(g_npk_t.npk01) THEN
                 LET l_n=0
                 SELECT count(*) INTO l_n FROM npk_file
                     WHERE npk00 = g_nmg.nmg00 AND npk01 = g_npk[l_ac].npk01
                 IF l_n > 0 THEN
                     LET g_npk[l_ac].npk01 = g_npk_t.npk01
                     CALL cl_err('',-239,0) NEXT FIELD npk01
                 END IF
             END IF
          END IF
 
       BEFORE FIELD npk03
          CALL t302_set_entry_b(p_cmd)
 
      #AFTER FIELD npk03 #MOD-AC0293 mark
       ON CHANGE npk03   #MOD-AC0293
         IF NOT cl_null(g_npk[l_ac].npk03) THEN
            IF g_npk[l_ac].npk03 NOT MATCHES '[1234]' THEN #No.7365
               NEXT FIELD npk03
            END IF
           #NO.FUN-C90127   ---start--- Add
            IF NOT cl_null(g_nmg.nmg31) THEN
               IF g_npk[l_ac].npk03 = '1' THEN
                  CALL cl_err('','anm-359',1)
                  NEXT FIELD npk03
               END IF
            END IF
           #NO.FUN-C90127   ---start--- Add
           #-------------------------MOD-C30081 ----------------------------start
            IF g_nmg.nmg20 = '21' and g_npk[l_ac].npk03 MATCHES '[2]' THEN
               CALL cl_err('','anm-318',0)
               LET g_npk[l_ac].npk03 = ''
               NEXT FIELD npk03
            END IF
           #-------------------------MOD-C30081 ------------------------------end
            IF g_npk[l_ac].npk03 MATCHES '[34]' THEN    #No.MOD-510071
               LET g_npk[l_ac].npk02=''    #TQC-870028
               LET g_npk[l_ac].nmc02=''   #MOD-690124
               LET g_npk[l_ac].npk04=''   #MOD-690124
               DISPLAY BY NAME g_npk[l_ac].npk02,g_npk[l_ac].nmc02,g_npk[l_ac].npk04   #MOD-690124
            END IF
           #IF NOT cl_null(g_npk[l_ac].npk02) THEN                                         #MOD-C30070 mark
            #IF NOT cl_null(g_npk[l_ac].npk02) OR g_npk[l_ac].npk02 <> g_npk_t.npk02  THEN  #MOD-C30070 add
             IF g_npk_t.npk02 IS NULL OR g_npk[l_ac].npk02 <> g_npk_t.npk02 THEN           #MOD-DA0064
              #CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03)                          #MOD-CC0170 mark
               CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03,'A')                      #MOD-CC0170 add
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_npk[l_ac].npk02,g_errno,0)
                  LET g_npk[l_ac].npk02 = g_npk_t.npk02
                  #NEXT FIELD npk03 #MOD-C50178 mark
                  NEXT FIELD npk02    #MOD-C50178
               END IF
               #FUN-C80031---ADD---STR
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npk[l_ac].npk071
                                                         AND aag00=g_bookno1
               IF l_aag05='Y' THEN
                  CALL cl_set_comp_entry("npk16",TRUE)
                  LET g_npk[l_ac].npk16=g_nmg.nmg11
                  CALL t302_npk16(g_npk[l_ac].npk16)
               ELSE
                  LET g_npk[l_ac].npk16  =''
                  LET g_npk[l_ac].gem02_1=''
                  CALL cl_set_comp_entry("npk16",FALSE)
               END IF 
               #FUN-C80031--ADD--END
            ELSE
               LET g_npk[l_ac].nmc02=''
            END IF
            DISPLAY BY NAME g_npk[l_ac].nmc02
         END IF
         CALL t302_set_entry_b(p_cmd) #MOD-AC0293 add
         CALL t302_set_no_entry_b(p_cmd)
         IF g_npk[l_ac].npk03 MATCHES '[34]' THEN
            CALL cl_chg_comp_att("npk02","NOT NULL","0")
         ELSE
            CALL cl_chg_comp_att("npk02","NOT NULL","1")
         END IF
 
#zhouxm150817 add start
       BEFORE FIELD npk02
         IF g_npk[l_ac].npk03 MATCHES '[12]' THEN 
           CALL cl_set_comp_entry("npk02,npk04",TRUE)
         END IF 
         IF g_npk[l_ac].npk03 MATCHES '[34]' THEN 
           CALL cl_set_comp_entry("npk02,npk04",FALSE)
         END IF
#zhouxm150817 add end
  
       AFTER FIELD npk02
         IF g_npk[l_ac].npk03 MATCHES '[12]' AND cl_null(g_npk[l_ac].npk02) THEN
            NEXT FIELD npk02
         END IF
         IF cl_null(g_npk[l_ac].npk02) AND NOT cl_null(g_npk[l_ac].npk04) THEN
            NEXT FIELD npk02
         END IF
        #IF NOT cl_null(g_npk[l_ac].npk02) THEN                                         #MOD-C30070 mark
         #IF NOT cl_null(g_npk[l_ac].npk02) OR g_npk[l_ac].npk02 <> g_npk_t.npk02  THEN  #MOD-C30070 add
       	 IF g_npk_t.npk02 IS NULL OR g_npk[l_ac].npk02 <> g_npk_t.npk02 THEN            #MOD-DA0064 
           #CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03)                          #MOD-CC0170 mark
            CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03,'A')                      #MOD-CC0170 add
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_npk[l_ac].npk02,g_errno,0)
               LET g_npk[l_ac].npk02 = g_npk_t.npk02
               NEXT FIELD npk02
            END IF
            #FUN-C80031---ADD---STR
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npk[l_ac].npk071
                                                      AND aag00=g_bookno1
            IF l_aag05='Y' THEN
               CALL cl_set_comp_entry("npk16",TRUE)
               LET g_npk[l_ac].npk16=g_nmg.nmg11
               CALL t302_npk16(g_npk[l_ac].npk16)
            ELSE
               LET g_npk[l_ac].npk16  =''
               LET g_npk[l_ac].gem02_1=''
               CALL cl_set_comp_entry("npk16",FALSE)
            END IF
            #FUN-C80031--ADD--END
         ELSE
            LET g_npk[l_ac].nmc02=''
         END IF
         DISPLAY BY NAME g_npk[l_ac].nmc02
         IF g_npk[l_ac].npk03 MATCHES '[12]' AND cl_null(g_npk[l_ac].npk02) AND   #MOD-9A0190 
            cl_null(g_npk[l_ac].npk04) THEN                                       #MOD-9A0190
             NEXT FIELD npk04                                                                                                       
         END IF                                                                                                                     
 
       AFTER FIELD npk04
         LET l_nma05=NULL
         LET l_nma051=NULL                                                       #No.FUN-680034
         IF NOT cl_null(g_npk[l_ac].npk04) THEN
           SELECT nma10,nmaacti,nma05,nma051,nma21 INTO
                  g_npk[l_ac].npk05,l_nmaacti,l_nma05,l_nma051,l_nma21           #No.FUN-680034 add nma051
              FROM nma_file WHERE nma01 =g_npk[l_ac].npk04
           LET g_errno = ' '
           CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                WHEN l_nmaacti='N' LET g_errno = '9028'
                OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
           END CASE
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_npk[l_ac].npk04,g_errno,0)
              NEXT FIELD npk04
           END IF
           DISPLAY BY NAME g_npk[l_ac].npk05
           IF g_npk[l_ac].npk04 <> g_npk_t.npk04 OR g_npk_t.npk04 IS NULL THEN   #MOD-770024 
              #換銀行匯率重抓
              IF g_npk[l_ac].npk03='1' OR cl_null(g_npk[l_ac].npk04) THEN
                 CALL s_curr3(g_npk[l_ac].npk05,g_nmg.nmg01,'B')  #存入
                             RETURNING g_npk[l_ac].npk06
              ELSE
                 CALL s_bankex(g_npk[l_ac].npk04,g_nmg.nmg01)     #提出
                             RETURNING g_npk[l_ac].npk06
              END IF
              DISPLAY BY NAME g_npk[l_ac].npk06
           END IF   #MOD-770024
               #str---- mark by dengsy170607
               #	###add by liyjf170330 str
               #IF g_npk[l_ac].npk03 = '2' AND (g_npk[l_ac].npk04 = '1001' OR g_npk[l_ac].npk04 LIKE '1002%') THEN
               #  SELECT (aeh11-aeh12) INTO l_n2 FROM aeh_file WHERE  aeh00 = g_bookno1  AND aeh01 = g_npk[l_ac].npk04 AND aeh09 = YEAR(g_nmg.nmg01) AND aeh10 = MONTH(g_nmg.nmg01)
               #  IF l_n2 < 0 THEN 
               #   CALL cl_err('','cap-100',0)
               #   NEXT FIELD npk04
               #  END IF 
               #END IF 
              ###add by liyjf170330 end
               #end----- mark by dengsy170607
           IF g_nmg.nmg01 <= l_nma21 THEN
              CALL cl_err(g_nmg.nmg01,'anm-077',0)
              NEXT FIELD npk04
           END IF
           #若nmg20='21','22'則幣別要相同
            IF g_nmg.nmg20='21' OR g_nmg.nmg20='22' THEN
              IF l_ac<>1 THEN
                IF g_npk[l_ac].npk05<>g_npk[l_ac-1].npk05 THEN
                   CALL cl_err(g_npk[l_ac].npk05,'axr-144',0)
                   NEXT FIELD npk04
                END IF
              ELSE
                IF p_cmd='u' AND l_ac < g_rec_b THEN             #No.MOD-530050
                IF g_npk[l_ac].npk05<>g_npk[l_ac+1].npk05 AND g_npk[l_ac].npk05<>g_npk[l_ac+1].npk05 AND g_npk[l_ac].npk05 IS NOT NULL THEN
                   CALL cl_err(g_npk[l_ac].npk05,'axr-144',0)
                   NEXT FIELD npk04
                END IF
               END IF
              END IF
            END IF
           LET g_npk[l_ac].npk07 = l_nma05
          #No.FUN-C90127   ---start--- Add
           IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
              IF g_npk[l_ac].npk05 != l_apa13 OR g_npk[l_ac].npk06 != l_apa14 THEN
                 CALL cl_err('','anm-327','1')
                 NEXT FIELD npk04
              END IF
           END IF
          #No.FUN-C90127   ---end  --- Add
           IF g_aza.aza63='Y' THEN
              LET g_npk[l_ac].npk072=l_nma051
           END IF
         ELSE
            IF g_npk[l_ac].npk03 MATCHES '[12]' AND   #MOD-9A0190 add
               cl_null(g_npk[l_ac].npk02) AND         #MOD-9A0190 add
               cl_null(g_npk[l_ac].npk04) THEN        #MOD-9A0190 add
               CALL cl_err('','anm-003',0)
               NEXT FIELD npk04
            END IF                                    #MOD-9A0190 add
         END IF
         DISPLAY BY NAME g_npk[l_ac].npk07
         IF g_aza.aza63='Y' THEN
            DISPLAY BY NAME g_npk[l_ac].npk072
         END IF
         DISPLAY BY NAME g_npk[l_ac].npk05
       CALL t302_set_entry_b(p_cmd)
       CALL t302_set_no_entry_b(p_cmd)
 
     BEFORE FIELD npk05
       CALL t302_set_entry_b(p_cmd)
       CALL t302_set_no_entry_b(p_cmd)
 
       AFTER FIELD npk05
         IF NOT cl_null(g_npk[l_ac].npk05) THEN
            IF g_npk[l_ac].npk05=0  THEN
               NEXT FIELD npk05
            END IF
            SELECT azi04 INTO t_azi04
              FROM azi_file WHERE azi01=g_npk[l_ac].npk05
             IF STATUS THEN
                CALL cl_err3("sel","azi_file",g_npk[l_ac].npk05,"",STATUS,"","select azi",1)  #No.FUN-660148
                NEXT FIELD npk05
             END IF
          #No.FUN-C90127   ---start--- Add
           IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
              IF NOT cl_null(g_npk[l_ac].npk05) AND NOT cl_null(g_npk[l_ac].npk06) THEN
                 IF g_npk[l_ac].npk05 != l_apa13 OR g_npk[l_ac].npk06 != l_apa14 THEN
                    CALL cl_err('','anm-327','1')
                    NEXT FIELD npk05
                 END IF
              END IF
           END IF
          #No.FUN-C90127   ---end  --- Add
         END IF
 
       BEFORE FIELD npk06 #-->匯率
          IF cl_null(g_npk[l_ac].npk06) THEN
             IF g_npk[l_ac].npk03='1' OR cl_null(g_npk[l_ac].npk04) THEN
                CALL s_curr3(g_npk[l_ac].npk05,g_nmg.nmg01,'B')  #存入
                          RETURNING g_npk[l_ac].npk06
             ELSE
                CALL s_bankex(g_npk[l_ac].npk04,g_nmg.nmg01)     #提出
                          RETURNING g_npk[l_ac].npk06
             END IF
          END IF
	 DISPLAY BY NAME g_npk[l_ac].npk06
         SELECT azi07 INTO t_azi07   #MOD-5B0207
            FROM azi_file WHERE azi01=g_npk[l_ac].npk05
 
       AFTER FIELD npk06
         IF NOT cl_null(g_npk[l_ac].npk06) THEN
            IF g_npk[l_ac].npk06=0  THEN
               NEXT FIELD npk06
            END IF
            IF g_npk[l_ac].npk05 =g_aza.aza17 THEN
               LET g_npk[l_ac].npk06=1
           #MOD-C90029---mark---S
           #ELSE
           #   LET g_npk[l_ac].npk06=cl_digcut(g_npk[l_ac].npk06,t_azi07)
           #MOD-C90029---mark---E
            END IF
            DISPLAY BY NAME g_npk[l_ac].npk06   #MOD-5B0207
           #No.FUN-C90127   ---start--- Add
            IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
               IF NOT cl_null(g_npk[l_ac].npk05) AND NOT cl_null(g_npk[l_ac].npk06) THEN
                  IF g_npk[l_ac].npk05 != l_apa13 OR g_npk[l_ac].npk06 != l_apa14 THEN
                     CALL cl_err('','anm-327','1')
                     NEXT FIELD npk06
                  END IF
               END IF
            END IF
           #No.FUN-C90127   ---end  --- Add
         END IF
 
       AFTER FIELD npk07
         IF NOT cl_null(g_npk[l_ac].npk07) THEN
            CALL t302_chkag(g_npk[l_ac].npk07,l_ac,'0')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npk[l_ac].npk07,'23',g_bookno1)    
                   RETURNING g_npk[l_ac].npk07
                 DISPLAY BY NAME g_npk[l_ac].npk07       
#FUN-B20073 --end--            
               NEXT FIELD npk07
            END IF
         END IF
 #當帳款類別為21,22且不為轉暫收時,不允許銀行科目不同
         IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='N' THEN
            IF l_ac > 1 THEN
               IF g_npk[l_ac].npk07 <> g_npk[l_ac-1].npk07 THEN
                  CALL cl_err(g_npk[l_ac].npk07,'anm-065',1)
                  NEXT FIELD npk07
               END IF
            END IF
         END IF
 
       AFTER FIELD npk072
         IF NOT cl_null(g_npk[l_ac].npk072) THEN
            CALL t302_chkag(g_npk[l_ac].npk072,l_ac,'1')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npk[l_ac].npk072,'23',g_bookno2)   
                   RETURNING g_npk[l_ac].npk072                                                                                         
                DISPLAY BY NAME g_npk[l_ac].npk072   
#FUN-B20073 --end--            
               NEXT FIELD npk072
            END IF
         END IF
#當帳款類別為21,22且不為轉暫收時,不允許銀行科目不同
         IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='N' THEN
            IF l_ac > 1 THEN
               IF g_npk[l_ac].npk072 <> g_npk[l_ac-1].npk072 THEN
                  CALL cl_err(g_npk[l_ac].npk072,'anm-065',1)
                  NEXT FIELD npk072
               END IF
            END IF
         END IF
 
#當帳款類別為21,22且要轉暫收時,單頭暫收科目與單身對方科目必須相同
       BEFORE FIELD npk071                           #FUN-C80031 
          CALL cl_set_comp_entry("npk16",TRUE)       #FUN-C80031
  
 
       AFTER FIELD npk071
      IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
         IF g_npk[l_ac].npk03 = '1' THEN                              #MOD-870274
            IF g_npk[l_ac].npk071 <> g_nmg.nmg30 OR
               g_npk[l_ac].npk071 IS NULL THEN   #MOD-750072
               CALL cl_err(g_npk[l_ac].npk071,'anm-066',1)
               LET g_npk[l_ac].npk071 = g_nmg.nmg30
	       #------MOD-5A0095 START----------
	       DISPLAY BY NAME g_npk[l_ac].npk071
	       #------MOD-5A0095 END------------
            END IF
         END IF
      END IF
         IF NOT cl_null(g_npk[l_ac].npk071) THEN
            CALL t302_chkag(g_npk[l_ac].npk071,l_ac,'0')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npk[l_ac].npk071,'23',g_bookno1)    
                     RETURNING g_npk[l_ac].npk071
                 DISPLAY BY NAME g_npk[l_ac].npk071        
#FUN-B20073 --end--            
               NEXT FIELD npk071
            END IF
            #FUN-C80031---ADD--STR
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npk[l_ac].npk071
                                                      AND aag00=g_bookno1
            IF l_aag05='Y' THEN
               CALL cl_set_comp_entry("npk16",TRUE)
               LET g_npk[l_ac].npk16=g_nmg.nmg11
               CALL t302_npk16(g_npk[l_ac].npk16)
            ELSE
               LET g_npk[l_ac].npk16  =''
               LET g_npk[l_ac].gem02_1=''
               CALL cl_set_comp_entry("npk16",FALSE)
            END IF
         ELSE
            LET g_npk[l_ac].npk16  =''
            LET g_npk[l_ac].gem02_1=''
            #FUN-C80031--ADD--END
         END IF
 
      AFTER FIELD npk073                                                                                                           
#當帳款類別為21,22且要轉暫收時,單頭暫收科目與單身對方科目必須相同
         IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN                                                                      
          IF g_npk[l_ac].npk03 = '1' THEN                              #MOD-870274
             IF g_aza.aza63 = 'Y' THEN             #MOD-9C0358 add
                IF g_npk[l_ac].npk073 <> g_nmg.nmg301 OR                                                                               
                   g_npk[l_ac].npk073 IS NULL THEN   #MOD-750072
                   CALL cl_err(g_npk[l_ac].npk073,'anm-066',1)                                                                          
                   LET g_npk[l_ac].npk073 = g_nmg.nmg301                                                                                 
                   DISPLAY BY NAME g_npk[l_ac].npk073                                                                                   
                END IF                  
             END IF                                #MOD-9C0358 add                                                                 
           END IF                                                                                                                     
         END IF                                                                                                                        
         IF NOT cl_null(g_npk[l_ac].npk073) THEN                                                                                    
            CALL t302_chkag(g_npk[l_ac].npk073,l_ac,'1')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN                                                                                            
#FUN-B20073 --begin--
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npk[l_ac].npk073,'23',g_bookno2)  
                     RETURNING g_npk[l_ac].npk073   
                DISPLAY BY NAME g_npk[l_ac].npk073  
#FUN-B20073 --end-- 
               NEXT FIELD npk073                                                                                                    
            END IF
         END IF
 
      #No.FUN-C90127   ---start--- Add
       BEFORE FIELD npk08
           IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
              IF cl_null(g_npk[l_ac].npk08) THEN
                 LET l_amt = 0
                 LET l_amt1= 0
                 FOR i = 1 TO g_npk.Getlength()
                    IF cl_null(g_npk[i].npk08) THEN LET g_npk[i].npk08 = 0 END IF
                    IF cl_null(g_npk[i].npk09) THEN LET g_npk[i].npk09 = 0 END IF
                    LET l_amt = l_amt + g_npk[i].npk08
                    LET l_amt1= l_amt1+ g_npk[i].npk09
                 END FOR
                 LET g_npk[l_ac].npk09 = l_unpay1 - l_amt1
                 LET g_npk[l_ac].npk08 = l_unpay2 - l_amt
              END IF
           END IF
      #No.FUN-C90127   ---end  --- Add

       AFTER FIELD npk08
         IF NOT cl_null(g_npk[l_ac].npk08) THEN
            # No:181121 s---
            IF g_npk[l_ac].npk03 = '2' THEN 
               LET l_yy = YEAR(g_nmg.nmg01)
               LET l_mm = MONTH(g_nmg.nmg01)
             # add by zhangsba190708---s  
               SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file
                 WHERE nme01 = g_npk[l_ac].npk04 AND nme03 = nmc01 AND nmc03 = '1'
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
               SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = g_npk[l_ac].npk04 AND nme03 = nmc01 AND nmc03 = '2'
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
                   
               IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
               IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
               IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
               IF l_c2 IS NULL THEN LET l_c2 = 0 END IF    
             # add by zhangsba190708---e  
             # mark by zhangsba190708---s  
             #  SELECT  sum(case npk03 when '1' THEN npk08 else -1*npk08 end),sum(case npk03 when '1' THEN npk09 else -1*npk09 end)
             #    INTO l_nmp06_1,l_nmp09_1
             #    FROM npk_file,nmg_file
             #   WHERE npk00 =nmg00 AND nmgconf <>'X' AND YEAR(nmg01)=l_yy and MONTH(nmg01)=l_mm
             #     AND npk04 = g_npk[l_ac].npk04

             #  IF cl_null(l_nmp06_1) THEN LET l_nmp06_1 = 0 END IF 
             #  IF cl_null(l_nmp09_1) THEN LET l_nmp09_1 = 0 END IF
             # mark by zhangsba190708---e
               IF l_mm =1 THEN
                  LET l_mm = 12 
                  LET l_yy =l_yy - 1
               ELSE 
                  LET l_mm = l_mm -1
               END IF  
               select nmp06,nmp09 into l_nmp06,l_nmp09 from nmp_file
                WHERE nmp01 = g_npk[l_ac].npk04
                  AND nmp02 = l_yy
                  AND nmp03 = l_mm
               IF cl_null(l_nmp06) THEN LET l_nmp06 = 0 END IF 
               IF cl_null(l_nmp09) THEN LET l_nmp09 = 0 END IF
             # mark by zhangsba190708---s
             # IF l_nmp06 + l_nmp06_1 - g_npk[l_ac].npk08 < 0 THEN               
             #    CALL cl_err_msg("","cnm-001",g_npk[l_ac].npk08||"|"||l_nmp06+l_nmp06_1,0)
             # mark by zhangsba190708---e
             # add by zhangsba190708---s
               IF l_nmp06 + l_d1 - l_c1 - g_npk[l_ac].npk08 < 0 THEN
                  CALL cl_err_msg("","cnm-001",g_npk[l_ac].npk08||"|"||l_nmp06+l_d1-l_c1,0)
             # add by zhangsba190708---e     
                  NEXT FIELD npk08
               END IF 
            END IF 
            # No:181121 e---
            SELECT azi04 INTO t_azi04   #MOD-610029
              FROM azi_file WHERE azi01=g_npk[l_ac].npk05   #MOD-610029
            CALL cl_digcut(g_npk[l_ac].npk08,t_azi04) RETURNING g_npk[l_ac].npk08
            LET g_npk[l_ac].npk09 = g_npk[l_ac].npk08 * g_npk[l_ac].npk06
            LET g_npk[l_ac].npk09 = cl_digcut(g_npk[l_ac].npk09,g_azi04)
            DISPLAY BY NAME g_npk[l_ac].npk08,g_npk[l_ac].npk09   #MOD-610029
         END IF
        #No.FUN-C90127   ---start--- Add
         IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
            LET l_amt = 0
            FOR i = 1 TO g_npk.Getlength()
               IF cl_null(g_npk[i].npk08) THEN LET g_npk[i].npk08 = 0 END IF
               LET l_amt = l_amt + g_npk[i].npk08
            END FOR
            IF l_amt > l_unpay2  THEN
               CALL cl_err('','aapt003','1')
               NEXT FIELD npk08
            END IF
         END IF
 
       BEFORE FIELD npk09
           IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
              IF cl_null(g_npk[l_ac].npk08) THEN
               # No:181121 s---
               IF g_npk[l_ac].npk03 = '2' THEN 
               LET l_yy = YEAR(g_nmg.nmg01)
               LET l_mm = MONTH(g_nmg.nmg01)
             # add by zhangsba190708---s  
               SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file
                 WHERE nme01 = g_npk[l_ac].npk04 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
               SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = g_npk[l_ac].npk04 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
                   
               IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
               IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
               IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
               IF l_c2 IS NULL THEN LET l_c2 = 0 END IF    
             # add by zhangsba190708---e  
             # mark by zhangsba190708---s  
             #  SELECT  sum(case npk03 when '1' THEN npk08 else -1*npk08 end),sum(case npk03 when '1' THEN npk09 else -1*npk09 end)
             #    INTO l_nmp06_1,l_nmp09_1
             #    FROM npk_file,nmg_file
             #   WHERE npk00 =nmg00 AND nmgconf <>'X' AND YEAR(nmg01)=l_yy and MONTH(nmg01)=l_mm
             #     AND npk04 = g_npk[l_ac].npk04

             #  IF cl_null(l_nmp06_1) THEN LET l_nmp06_1 = 0 END IF 
             #  IF cl_null(l_nmp09_1) THEN LET l_nmp09_1 = 0 END IF
             # mark by zhangsba190708---e 
               IF l_mm =1 THEN
                  LET l_mm = 12 
                  LET l_yy =l_yy - 1
               ELSE 
                  LET l_mm = l_mm -1
               END IF  
               select nmp06,nmp09 into l_nmp06,l_nmp09 from nmp_file
                WHERE nmp01 = g_npk[l_ac].npk04
                  AND nmp02 = l_yy
                  AND nmp03 = l_mm 
               
               IF cl_null(l_nmp06) THEN LET l_nmp06 = 0 END IF 
               IF cl_null(l_nmp09) THEN LET l_nmp09 = 0 END IF
             # mark by zhangsba190708---s
             # IF l_nmp06 + l_nmp06_1 - g_npk[l_ac].npk08 < 0 THEN               
             #    CALL cl_err_msg("","cnm-001",g_npk[l_ac].npk08||"|"||l_nmp06+l_nmp06_1,0)
             # mark by zhangsba190708---e
             # add by zhangsba190708---s
               IF l_nmp06 + l_d1 - l_c1 - g_npk[l_ac].npk08 < 0 THEN
                  CALL cl_err_msg("","cnm-001",g_npk[l_ac].npk08||"|"||l_nmp06+l_d1-l_c1,0)
             # add by zhangsba190708---e
                  NEXT FIELD npk08
               END IF 
            END IF 
            # No:181121 e---
                 LET l_amt = 0
                 LET l_amt1= 0
                 FOR i = 1 TO g_npk.Getlength()
                    IF cl_null(g_npk[i].npk08) THEN LET g_npk[i].npk08 = 0 END IF
                    IF cl_null(g_npk[i].npk09) THEN LET g_npk[i].npk09 = 0 END IF
                    LET l_amt = l_amt + g_npk[i].npk08
                    LET l_amt1= l_amt1+ g_npk[i].npk09
                 END FOR
                 LET g_npk[l_ac].npk09 = l_unpay1 - l_amt1
                 LET g_npk[l_ac].npk08 = l_unpay2 - l_amt
              END IF
           END IF
      #No.FUN-C90127   ---end  --- Add

       AFTER FIELD npk09
           #-------------------------MOD-CA0036-------------------------(S)
            IF g_npk[l_ac].npk06 = 1 THEN
               IF g_npk[l_ac].npk08 <> g_npk[l_ac].npk09 THEN
                  CALL cl_err('','agl-926',1)
                  NEXT FIELD npk09
               END IF
            END IF
           #-------------------------MOD-CA0036-------------------------(E)
            LET g_npk[l_ac].npk09 = cl_digcut(g_npk[l_ac].npk09,g_azi04)
            DISPLAY BY NAME g_npk[l_ac].npk09
          #No.FUN-C90127   ---start--- Add
           IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
              LET l_amt1= 0
              FOR i = 1 TO g_npk.Getlength()
                 IF cl_null(g_npk[i].npk09) THEN LET g_npk[i].npk09 = 0 END IF
                 LET l_amt1 = l_amt1 + g_npk[i].npk09
              END FOR
              IF l_amt1 > l_unpay1  THEN
                 CALL cl_err('','aapt003','1')
                 NEXT FIELD npk09
              END IF
           END IF
          #No.FUN-C90127   ---end  --- Add

       #FUN-C80031----ADD----STR
        BEFORE FIELD npk16
           IF g_nmg.nmg29='Y' THEN
              CALL cl_set_comp_entry("npk16",FALSE)
           ELSE
              CALL cl_set_comp_entry("npk16",TRUE)
           END IF
      

        AFTER FIELD npk16                                      # Dept
           IF NOT cl_null(g_npk[l_ac].npk16) THEN
              CALL t302_npk16(g_npk[l_ac].npk16)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_npk[l_ac].npk16,g_errno,0)
                 NEXT FIELD npk16
              END IF
 
              IF p_cmd = 'u' OR g_npk[l_ac].npk16 != g_npk_t.npk16 THEN
                #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_npk[l_ac].npk07          #借方：科目1
                    AND aag00 = g_bookno1    
                
                 LET g_errno = ' '   
                 IF l_aag05 = 'Y' AND NOT cl_null(g_nmg.nmg30) THEN 
                    IF g_aaz.aaz90 !='Y' THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       CALL s_chkdept(g_aaz.aaz72,g_npk[l_ac].npk07,g_npk[l_ac].npk16,g_bookno1)  
                                     RETURNING g_errno
                    END IF 
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD npk16
                    END IF
                 END IF
 
                #會計科目二
                 IF g_aza.aza63='Y' THEN
                    LET l_aag05_1=''
                    SELECT aag05 INTO l_aag05_1 FROM aag_file
                     WHERE aag01 = g_npk[l_ac].npk072              #借方：科目2
                       AND aag00 = g_bookno2    
                    
                    LET g_errno = ' '   
                    IF l_aag05_1 = 'Y' AND NOT cl_null(g_nmg.nmg301) THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          CALL s_chkdept(g_aaz.aaz72,g_npk[l_ac].npk072,g_npk[l_ac].npk16,g_bookno2) 
                          RETURNING g_errno
                       END IF
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD npk16
                       END IF
                    END IF
                 END IF
              END IF
            ELSE
              LET g_npk[l_ac].gem02_1=''
              DISPLAY BY NAME g_npk[l_ac].gem02_1
            END IF
         #FUN-C80031------ADD-----END
 
       AFTER FIELD npkud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD npkud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_npk_t.npk01 > 0 AND g_npk_t.npk01 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM npk_file
              WHERE npk00 = g_nmg.nmg00 AND npk01 = g_npk_t.npk01
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("del","npk_file",g_nmg.nmg00,g_npk_t.npk01,SQLCA.sqlcode,"","del",1)  #No.FUN-660148
                ROLLBACK WORK
                CANCEL DELETE
             ELSE
                 CALL t302_bu()   #MOD-530676
             END IF
             COMMIT WORK
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_npk[l_ac].* = g_npk_t.*
             CLOSE t302_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_npk[l_ac].npk02,-263,1)
             LET g_npk[l_ac].* = g_npk_t.*
          ELSE
             IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
                IF g_npk[l_ac].npk03 = '1' THEN                              #MOD-870274
                   IF g_npk[l_ac].npk071 <> g_nmg.nmg30 OR
                      g_npk[l_ac].npk071 IS NULL THEN
                      CALL cl_err(g_npk[l_ac].npk071,'anm-066',1)
                      LET g_npk[l_ac].npk071 = g_nmg.nmg30
                      DISPLAY BY NAME g_npk[l_ac].npk071
                   END IF
                   IF g_aza.aza63 = 'Y' THEN           #MOD-9C0358 add
                      IF g_npk[l_ac].npk073 <> g_nmg.nmg301 OR
                         g_npk[l_ac].npk073 IS NULL THEN
                         CALL cl_err(g_npk[l_ac].npk073,'anm-066',1)
                         LET g_npk[l_ac].npk073 = g_nmg.nmg301
                         DISPLAY BY NAME g_npk[l_ac].npk073
                      END IF
                   END IF                              #MOD-9C0358 add
                END IF
             END IF
             LET l_ac = ARR_CURR()   #yinhy130807
             CALL t302_b_move_back()
             UPDATE npk_file SET * = b_npk.*
              WHERE npk00=g_nmg.nmg00 AND npk01=g_npk_t.npk01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","npk_file",g_nmg.nmg00,g_npk_t.npk01,SQLCA.sqlcode,"","upd",1)  #No.FUN-660148
                LET g_npk[l_ac].* = g_npk_t.*
             ELSE        
                CALL t302_bu()
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'UPDATE O.K'
                ELSE
                   ROLLBACK WORK
                   MESSAGE 'ROLLBACK'
                END IF
             END IF
          END IF
 
       AFTER ROW
#No.MOD-CA0176 -- begin
          IF NOT INT_FLAG THEN
            #CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03)         #MOD-CC0170 mark
             IF NOT cl_null(g_npk[l_ac].npk02) THEN                      #MOD-D20019 
               CALL t302_nmc(g_npk[l_ac].npk02,g_npk[l_ac].npk03,'D')     #MOD-CC0170 add
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_npk[l_ac].npk02,g_errno,0)
                  LET g_npk[l_ac].npk02 = g_npk_t.npk02
                  NEXT FIELD npk03  
               END IF
            END IF  #MOD-D20019
          END IF
#No.MOD-CA0176 --end
          LET l_ac = ARR_CURR()
       #  LET l_ac_t = l_ac    #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_npk[l_ac].* = g_npk_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_npk.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE t302_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac    #FUN-D30032 add  
          CLOSE t302_bcl
          COMMIT WORK
          INITIALIZE g_npk_t.* TO NULL   #MOD-D70142
          CALL g_npk.deleteElement(g_rec_b+1)   #MOD-D80005
 
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(npk01) AND l_ac > 1 THEN
             LET g_npk[l_ac].* = g_npk[l_ac-1].*
             LET g_npk[l_ac].npk01 = NULL
             DISPLAY BY NAME g_npk[l_ac].*
             DISPLAY BY NAME g_npk[l_ac].npk01 
             NEXT FIELD npk01
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(npk04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nma"
                LET g_qryparam.default1 = g_npk[l_ac].npk04
                CALL cl_create_qry() RETURNING g_npk[l_ac].npk04
                 DISPLAY BY NAME g_npk[l_ac].npk04           #No.MOD-490344
                NEXT FIELD npk04
             WHEN INFIELD(npk05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_npk[l_ac].npk05
                CALL cl_create_qry() RETURNING g_npk[l_ac].npk05
                 DISPLAY BY NAME g_npk[l_ac].npk05           #No.MOD-490344
                NEXT FIELD npk05
 
             WHEN INFIELD(npk06)
                  CALL s_rate(g_npk[l_ac].npk05,g_npk[l_ac].npk06)
                           RETURNING g_npk[l_ac].npk06
                  DISPLAY BY NAME g_npk[l_ac].npk06
                  NEXT FIELD npk06
 
             WHEN INFIELD(npk07)
                CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                IF g_flag = '1' THEN
                   CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npk[l_ac].npk07,'23',g_bookno1)     #No.FUN-980025 
                RETURNING g_npk[l_ac].npk07
                 DISPLAY BY NAME g_npk[l_ac].npk07           #No.MOD-490344
                NEXT FIELD npk07
             WHEN INFIELD(npk072)                                                                                                    
                CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020
                IF g_flag = '1' THEN
                   CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npk[l_ac].npk072,'23',g_bookno2)     #No.FUN-980025 
                RETURNING g_npk[l_ac].npk072                                                                                         
                DISPLAY BY NAME g_npk[l_ac].npk072                                                                    
                NEXT FIELD npk072
             WHEN INFIELD(npk071)
                  CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                  END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npk[l_ac].npk071,'23',g_bookno1)     #No.FUN-980025 
                     RETURNING g_npk[l_ac].npk071
                 DISPLAY BY NAME g_npk[l_ac].npk071          #No.MOD-490344
                NEXT FIELD npk071
             WHEN INFIELD(npk073)                                                                                                   
                CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                IF g_flag = '1' THEN
                   CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
                END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npk[l_ac].npk073,'23',g_bookno2)     #No.FUN-980025 
                     RETURNING g_npk[l_ac].npk073                                                                                   
                DISPLAY BY NAME g_npk[l_ac].npk073                                                             
                NEXT FIELD npk073
             WHEN INFIELD(npk02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_nmc01"   #MOD-640037
                LET g_qryparam.default1 = g_npk[l_ac].npk02
                LET g_qryparam.arg1=g_npk[l_ac].npk03   #MOD-640037
                CALL cl_create_qry() RETURNING g_npk[l_ac].npk02
                 DISPLAY BY NAME g_npk[l_ac].npk02           #No.MOD-490344
                NEXT FIELD npk02

           #FUN-C80031----ADD--STR
              WHEN INFIELD(npk16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_npk[l_ac].npk16
                 CALL cl_create_qry() RETURNING g_npk[l_ac].npk16
                 CALL t302_npk16(g_npk[l_ac].npk16)
                 DISPLAY BY NAME g_npk[l_ac].npk16
                 NEXT FIELD npk16 
           #FUN-C80031----ADD--END     
          END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG CALL cl_cmdask()
 
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
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END INPUT
 
   LET g_nmg.nmgmodu = g_user
   LET g_nmg.nmgdate = g_today
   UPDATE nmg_file SET nmgmodu = g_nmg.nmgmodu,nmgdate = g_nmg.nmgdate
    WHERE nmg00 = g_nmg.nmg00
   DISPLAY BY NAME g_nmg.nmgmodu,g_nmg.nmgdate
   CLOSE t302_cl           #MOD-D60105
   CLOSE t302_bcl
   COMMIT WORK
   CALL t302_delHeader()     #CHI-C30002 add
   IF NOT cl_null(g_nmg.nmg00) THEN  #CHI-C30002 add
      CALL t302_diff()   #FUN-970072
   
     #單身輸入完成后,根據單別設置,自動生成分錄底稿.
      CALL t302_gen_g() #No.MOD-930003
   END IF                      #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t302_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_nmg.nmg00) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM nmg_file ",
                  "  WHERE nmg00 LIKE '",l_slip,"%' ",
                  "    AND nmg00 > '",g_nmg.nmg00,"'"
      PREPARE t302_pb1 FROM l_sql 
      EXECUTE t302_pb1 INTO l_cnt 
      
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
        #CALL t302_x()                   #FUN-D20035
         CALL t302_x(1)                  #FUN-D20035
         IF g_nmg.nmgconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00 = 3
            AND npp01 = g_nmg.nmg00
            AND npp011 = 1
         DELETE FROM npq_file
          WHERE npqsys= 'NM'
            AND npq00=3
            AND npq01 = g_nmg.nmg00
            AND npq011=1
         DELETE FROM tic_file WHERE tic04 = g_nmg.nmg00
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM nmg_file WHERE nmg00 = g_nmg.nmg00
         INITIALIZE g_nmg.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
#FUNCTION t302_nmc(p_nmc01,p_key)             #MOD-CC0170 mark
FUNCTION t302_nmc(p_nmc01,p_key,p_flag)       #MOD-CC0170 add
   DEFINE p_nmc01      LIKE nmc_file.nmc01    #No.FUN-680107 VARCHAR(2)
   DEFINE p_key        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE p_flag       LIKE type_file.chr1    #MOD-CC0170 add
   DEFINE l_nmc02      LIKE nmc_file.nmc02
   DEFINE l_nmc03      LIKE nmc_file.nmc03    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmc04      LIKE nmc_file.nmc04
   DEFINE l_nmc041     LIKE nmc_file.nmc041   #No.FUN-680034
   DEFINE l_acti       LIKE nmc_file.nmcacti  #No.FUN-680107 VARCHAR(1)
 
   LET g_errno = ' '
   IF p_key = '3' OR p_key = '4' THEN RETURN END IF            #MOD-CC0170 add
  #IF p_key = '3' OR p_key = '5' THEN LET p_key = '1' END IF   #MOD-CC0170 mark
  #IF p_key = '4' OR p_key = '6' THEN LET p_key = '2' END IF   #MOD-CC0170 mark
   IF p_key = '5' THEN LET p_key = '1' END IF                  #MOD-CC0170 add
   IF p_key = '6' THEN LET p_key = '2' END IF                  #MOD-CC0170 add
   SELECT nmc02,nmc03,nmc04,nmc041,nmcacti
     INTO l_nmc02,l_nmc03,l_nmc04,l_nmc041,l_acti FROM nmc_file       #No.FUN-680034 add nmc041
    WHERE nmc01 = p_nmc01
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-024' LET l_nmc02 = ' '
        WHEN l_nmc03!=p_key       LET g_errno = 'anm-107'
        WHEN l_acti  ='N'         LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      IF p_flag = 'A' THEN                            #MOD-CC0170 add
         LET g_npk[l_ac].nmc02 = l_nmc02
        #IF cl_null(g_npk[l_ac].npk04) THEN         #MOD-C30070 mark
         LET g_npk[l_ac].npk071=l_nmc04             #No.FUN-680034
      END IF                                          #MOD-CC0170 add
     #MOD-C30632--MARK--STR 
     #IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmy.nmydmy3='Y' THEN   #MOD-730013
     #   LET g_npk[l_ac].npk071=''  
     #END IF 
     #MOD-C30632--MARK--END
      IF g_aza.aza63='Y' THEN
         LET g_npk[l_ac].npk073=l_nmc041
        #MOD-C30632--MARK--STR                                                                                              
        #IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmy.nmydmy3='Y' THEN   #MOD-730013                                                             
        #   LET g_npk[l_ac].npk073=''                                                                                               
        #END IF
        #MOD-C30632--MARK--END
      END IF
     #-------------MOD-C30070------------mark
     #ELSE
     #   IF cl_null(g_npk[l_ac].npk071) THEN
     #      LET g_npk[l_ac].npk071=l_nmc04
     #   END IF
     #   IF cl_null(g_npk[l_ac].npk073) AND g_aza.aza63='Y' THEN
     #      LET g_npk[l_ac].npk073=l_nmc041
     #   END IF
     #END IF
     #-------------MOD-C30070------------mark
   END IF
END FUNCTION
 
FUNCTION t302_chkag(p_aag01,p_i,p_flag)
   DEFINE p_aag01      LIKE aag_file.aag01   #No.FUN-680107 VARCHAR(24)
   DEFINE p_i          LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE p_flag       LIKE type_file.chr1       #No.FUN-730032
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_aag03      LIKE aag_file.aag03
   DEFINE l_aag07      LIKE aag_file.aag07
   DEFINE l_acti       LIKE aag_file.aagacti #No.FUN-680107 VARCHAR(1)
   LET g_errno = ' '
 
   CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
   END IF
   IF p_flag = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   SELECT aag02,aag03,aag07,aagacti INTO l_aag02,l_aag03,l_aag07,l_acti         
     FROM aag_file
    WHERE aag01 = p_aag01
      AND aag00 = g_bookno3       #No.FUN-730032
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
        WHEN l_acti  ='N'         LET g_errno = '9028'
        WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
        WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
END FUNCTION
 
FUNCTION t302_bu()
 DEFINE l_nmg23,l_nmg25 LIKE nmg_file.nmg23
 DEFINE l_nmg05,l_nmg06 LIKE nmg_file.nmg05
 
   SELECT SUM(npk08) INTO l_nmg23 FROM npk_file       #原幣入帳
    WHERE npk00=g_nmg.nmg00
      AND npk03= '1'
      AND npk04 IS NOT NULL
   IF cl_null(l_nmg23) THEN
      LET l_nmg23 = 0
   END IF
   SELECT SUM(npk08) INTO l_nmg05 FROM npk_file       #原幣出帳
    WHERE npk00=g_nmg.nmg00
      AND npk03= '2'
      AND npk04 IS NOT NULL
   IF cl_null(l_nmg05) THEN
      LET l_nmg05 = 0
   END IF
   SELECT SUM(npk09) INTO l_nmg25 FROM npk_file       #本幣入帳
    WHERE npk00=g_nmg.nmg00
      AND npk03= '1'
      AND npk04 IS NOT NULL
   IF cl_null(l_nmg25) THEN
      LET l_nmg25 = 0
   END IF
   SELECT SUM(npk09) INTO l_nmg06 FROM npk_file       #本幣出帳
    WHERE npk00=g_nmg.nmg00
      AND npk03= '2'
      AND npk04 IS NOT NULL
   IF cl_null(l_nmg06) THEN
      LET l_nmg06 = 0
   END IF
   UPDATE nmg_file SET nmg23=l_nmg23,
                       nmg25=l_nmg25,
                       nmg05=l_nmg05,
                       nmg06=l_nmg06
    WHERE nmg00=g_nmg.nmg00
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("upd","nmg_file",g_nmg.nmg00,"",STATUS,"","upd nmg23,06:",1)  #No.FUN-660148
      RETURN
   END IF
   LET g_nmg.nmg23 = l_nmg23
   LET g_nmg.nmg25 = l_nmg25
   LET g_nmg.nmg05 = l_nmg05
   LET g_nmg.nmg06 = l_nmg06
   DISPLAY BY NAME g_nmg.nmg23,g_nmg.nmg25,g_nmg.nmg05,g_nmg.nmg06
END FUNCTION
 
FUNCTION t302_baskey()
DEFINE l_wc2  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT g_wc1 ON npk01,npk03,npk02,npk04,npk05,npk06,npk08,npk09,
                      npk07,npk071,npk072,npk073,npk16,npk10                           #No.FUN-680034 add npk072,npk073  #FUN-C80031  add--npk16
                      ,npkud01,npkud02,npkud03,npkud04,npkud05
                      ,npkud06,npkud07,npkud08,npkud09,npkud10
                      ,npkud11,npkud12,npkud13,npkud14,npkud15
                 FROM s_npk[1].npk01,s_npk[1].npk03,s_npk[1].npk02,
                      s_npk[1].npk04,s_npk[1].npk05,s_npk[1].npk06,
                      s_npk[1].npk08,s_npk[1].npk09,s_npk[1].npk07,
                      s_npk[1].npk071,s_npk[1].npk072,s_npk[1].npk073,           #No.FUN-680034 add s_npk[1].npk072,s_npk[1].npk073
                      s_npk[1].npk16,s_npk[1].npk10                              #FUN-C80031  add--npk16
                      ,s_npk[1].npkud01,s_npk[1].npkud02,s_npk[1].npkud03
                      ,s_npk[1].npkud04,s_npk[1].npkud05,s_npk[1].npkud06
                      ,s_npk[1].npkud07,s_npk[1].npkud08,s_npk[1].npkud09
                      ,s_npk[1].npkud10,s_npk[1].npkud11,s_npk[1].npkud12
                      ,s_npk[1].npkud13,s_npk[1].npkud14,s_npk[1].npkud15
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
      RETURN
   END IF
   CALL t302_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t302_b_fill(p_wc2)          #BODY FILL UP
DEFINE p_wc2  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(300)
 
   LET g_sql = "SELECT npk01,npk03,npk02,nmc02,npk04,npk05,npk06,npk08, ",
               "       npk09,npk07,npk071,npk072,npk073,npk16,'',npk10, ",             #No.FUN-680034 add npk072,npk073   #FUN-C80031 add-npk16,''
               "       npkud01,npkud02,npkud03,npkud04,npkud05,",
               "       npkud06,npkud07,npkud08,npkud09,npkud10,",
               "       npkud11,npkud12,npkud13,npkud14,npkud15 ", 
               " FROM npk_file LEFT JOIN nmc_file ON npk02 = nmc_file.nmc01 ",
               " WHERE npk00 ='",g_nmg.nmg00,"'",        #單頭
               " AND ",p_wc2 CLIPPED,
               " ORDER BY 1"
 
   PREPARE t302_pb FROM g_sql
   DECLARE npk_curs CURSOR FOR t302_pb
 
   CALL g_npk.clear()
   LET g_cnt = 1
   FOREACH npk_curs INTO g_npk[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT gem02 INTO g_npk[g_cnt].gem02_1 FROM gem_file WHERE gem01=g_npk[g_cnt].npk16   #FUN-C80031
      DISPLAY BY NAME g_npk[g_cnt].gem02_1                                                  #FUN-C80031

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_npk.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npk TO s_npk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_set_act_visible("entry_sheet1",g_aza.aza63='Y')     #FUN-680034
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t302_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t302_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t302_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t302_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t302_fetch('L')
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
         IF g_nmg.nmgconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION modify_customer_no_vender_n #客戶/廠商代號修改
         LET g_action_choice="modify_customer_no_vender_n"
         EXIT DISPLAY

#--FUN-BC0044 START--
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
#--FUN-BC0044 END---
 
      ON ACTION confirm      #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
 
      ON ACTION undo_confirm    #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
   
      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end
  
      ON ACTION qry_transaction      #異動查詢
         LET g_action_choice="qry_transaction"
         EXIT DISPLAY
 
      ON ACTION query_suspense_credit    #暫收款查詢
         LET g_action_choice="query_suspense_credit"
         EXIT DISPLAY
 
      ON ACTION gen_entry  #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
 
      ON ACTION entry_sheet1 #分錄底稿二
         LET g_action_choice="entry_sheet1"                                                                                          
         EXIT DISPLAY
 
      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher" 
         EXIT DISPLAY 
                                                                                                                                    
      ON ACTION undo_carry_voucher #傳票拋轉還原  
         LET g_action_choice="undo_carry_voucher" 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
#No.FUN-A30106 --begin                                                          
      ON ACTION drill_down                                                      
         LET g_action_choice="drill_down"                                       
         EXIT DISPLAY                                                           
#No.FUN-A30106 --end

      #No.FUN-CB0080 ---start--- Add
      ON ACTION item_list
        LET g_action_choice="item_list"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY
     #No.FUN-CB0080 ---end  --- Add
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION t302_b_move_to()
   LET g_npk[l_ac].npk01 = b_npk.npk01
   LET g_npk[l_ac].npk02 = b_npk.npk02
   LET g_npk[l_ac].npk03 = b_npk.npk03
   LET g_npk[l_ac].npk04 = b_npk.npk04
   LET g_npk[l_ac].npk05 = b_npk.npk05
   LET g_npk[l_ac].npk06 = b_npk.npk06
   LET g_npk[l_ac].npk07 = b_npk.npk07
   LET g_npk[l_ac].npk072= b_npk.npk072                     #No.FUN-680034
   LET g_npk[l_ac].npk071= b_npk.npk071
   LET g_npk[l_ac].npk073= b_npk.npk073                     #No.FUN-680034
   LET g_npk[l_ac].npk16 = b_npk.npk16                      #FUN-C80031
   SELECT gem02 INTO g_npk[l_ac].gem02_1 FROM gem_file      #FUN-C80031
    WHERE gem01= g_npk[l_ac].npk16                          #FUN-C80031 
   LET g_npk[l_ac].npk08 = b_npk.npk08
   LET g_npk[l_ac].npk09 = b_npk.npk09
   LET g_npk[l_ac].npk10 = b_npk.npk10
   LET g_npk[l_ac].npkud01 = b_npk.npkud01
   LET g_npk[l_ac].npkud02 = b_npk.npkud02
   LET g_npk[l_ac].npkud03 = b_npk.npkud03
   LET g_npk[l_ac].npkud04 = b_npk.npkud04
   LET g_npk[l_ac].npkud05 = b_npk.npkud05
   LET g_npk[l_ac].npkud06 = b_npk.npkud06
   LET g_npk[l_ac].npkud07 = b_npk.npkud07
   LET g_npk[l_ac].npkud08 = b_npk.npkud08
   LET g_npk[l_ac].npkud09 = b_npk.npkud09
   LET g_npk[l_ac].npkud10 = b_npk.npkud10
   LET g_npk[l_ac].npkud11 = b_npk.npkud11
   LET g_npk[l_ac].npkud12 = b_npk.npkud12
   LET g_npk[l_ac].npkud13 = b_npk.npkud13
   LET g_npk[l_ac].npkud14 = b_npk.npkud14
   LET g_npk[l_ac].npkud15 = b_npk.npkud15
END FUNCTION
 
FUNCTION t302_b_move_back()
   LET b_npk.npk01 = g_npk[l_ac].npk01
   LET b_npk.npk02 = g_npk[l_ac].npk02
   LET b_npk.npk03 = g_npk[l_ac].npk03
   LET b_npk.npk04 = g_npk[l_ac].npk04
   LET b_npk.npk05 = g_npk[l_ac].npk05
   LET b_npk.npk06 = g_npk[l_ac].npk06
   LET b_npk.npk07 = g_npk[l_ac].npk07
   LET b_npk.npk072= g_npk[l_ac].npk072                   #No.FUN-680034
   LET b_npk.npk071= g_npk[l_ac].npk071
   LET b_npk.npk073= g_npk[l_ac].npk073                   #No.FUN-680034
   LET b_npk.npk08 = g_npk[l_ac].npk08
   LET b_npk.npk09 = g_npk[l_ac].npk09
   LET b_npk.npk10 = g_npk[l_ac].npk10
   LET b_npk.npk11 = ' '
   LET b_npk.npk12 = ' '
   LET b_npk.npk13 = ' '
   LET b_npk.npk14 = ' '
   LET b_npk.npk15 = ' '
   LET b_npk.npk16 = g_npk[l_ac].npk16                    #FUN-C80031
   LET b_npk.npkud01 = g_npk[l_ac].npkud01
   LET b_npk.npkud02 = g_npk[l_ac].npkud02
   LET b_npk.npkud03 = g_npk[l_ac].npkud03
   LET b_npk.npkud04 = g_npk[l_ac].npkud04
   LET b_npk.npkud05 = g_npk[l_ac].npkud05
   LET b_npk.npkud06 = g_npk[l_ac].npkud06
   LET b_npk.npkud07 = g_npk[l_ac].npkud07
   LET b_npk.npkud08 = g_npk[l_ac].npkud08
   LET b_npk.npkud09 = g_npk[l_ac].npkud09
   LET b_npk.npkud10 = g_npk[l_ac].npkud10
   LET b_npk.npkud11 = g_npk[l_ac].npkud11
   LET b_npk.npkud12 = g_npk[l_ac].npkud12
   LET b_npk.npkud13 = g_npk[l_ac].npkud13
   LET b_npk.npkud14 = g_npk[l_ac].npkud14
   LET b_npk.npkud15 = g_npk[l_ac].npkud15
 
   LET b_npk.npklegal = g_legal 
 
END FUNCTION
 
FUNCTION t302_ins_nmg()
   IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND
       g_nmy.nmydmy3='Y' THEN
      IF cl_null(g_nmg.nmg29) THEN
         LET g_nmg.nmg29='Y'
      END IF
      IF cl_null(g_nmg.nmg30) THEN
         LET g_nmg.nmg30=g_nms.nms28
      END IF
      IF cl_null(g_nmg.nmg301) AND g_aza.aza63='Y' THEN
         LET g_nmg.nmg301=g_nms.nms28
      END IF
   ELSE
      IF cl_null(g_nmg.nmg29) THEN
         LET g_nmg.nmg29='N'
      END IF
   END IF
 
   LET g_nmg.nmglegal = g_legal 
 
   LET g_nmg.nmgoriu = g_user      #No.FUN-980030 10/01/04
   LET g_nmg.nmgorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nmg_file VALUES (g_nmg.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","nmg_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","t302_ins_nmg:",1)  #No.FUN-660148
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t302_u()
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_nmg.nmg00) THEN
      CALL cl_err('',-400,2)
      RETURN
   END IF
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
   IF g_nmg.nmgconf='Y' THEN
      CALL cl_err(g_nmg.nmg00,'anm-105',2)
      RETURN
   END IF
   IF g_nmg.nmgconf='X' THEN
      CALL cl_err(g_nmg.nmg00,'9024',0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nmg_o.* = g_nmg.*
   LET g_nmg_t.* = g_nmg.*
   LET g_nmg.nmgmodu=g_user                     #修改者 no:6185
   LET g_nmg.nmgdate = g_today                  #修改日期
   CALL t302_show()
   IF g_success = 'N' THEN
      LET g_nmg.* = g_nmg_t.*
      CALL t302_show()
      CLOSE t302_cl         #MOD-D60105
      ROLLBACK WORK
      RETURN
   END IF
   CALL t302_i('u')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_nmg.* = g_nmg_t.*
      CALL t302_show()
      CLOSE t302_cl         #MOD-D60105
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE nmg_file SET * = g_nmg.* WHERE nmg00 = g_nmg_t.nmg00
   IF STATUS THEN
      CALL cl_err3("upd","nmg_file",g_nmg_t.nmg00,"",STATUS,"","up nmg",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   IF g_nmg.nmg01 != g_nmg_t.nmg01 THEN            # 更改單號
      UPDATE npp_file SET npp02=g_nmg.nmg01
       WHERE npp01=g_nmg.nmg00
         AND npp00=3
         AND npp011=1
         AND nppsys = 'NM'
      IF STATUS THEN
         CALL cl_err3("upd","npp_file",g_nmg.nmg00,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         CLOSE t302_cl         #MOD-D60105
      END IF
      #FUN-E80012---add---str---
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
      IF g_nmz.nmz70 = '3' THEN
         LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_nmg.nmg01,1)
         LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_nmg.nmg01,3)
         UPDATE tic_file SET tic01=l_tic01,
                             tic02=l_tic02
         WHERE tic04=g_nmg.nmg00
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tic_file",g_nmg.nmg00,"",STATUS,"","upd tic01 tic02",1)
         END IF
      END IF
      #FUN-E80012---add---end---
   END IF

   #FUN-B30213--add--str--   
   IF g_nmg.nmg00 != g_nmg_t.nmg00 AND NOT cl_null(g_nmg_t.nmg00) THEN   
      UPDATE nmu_file SET nmu14 = g_nmg.nmg00
       WHERE nmu14 = g_nmg_t.nmg00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","nmu_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","upd nmu14:",1) 
         LET g_success = 'N'
      END IF
   END IF
   #FUN-B30213--add--end-- 

   CALL t302_show()
   IF g_success = 'Y' THEN
   	  CLOSE t302_cl         #MOD-D60105
      COMMIT WORK
      CALL t302_b_fill_1()          #No.FUN-CB0080   Add
      CALL cl_flow_notify(g_nmg.nmg00,'U')
   ELSE
      CLOSE t302_cl         #MOD-D60105
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t302_npp02(p_npptype)                         #No.FUN-680034 add p_npptype
   DEFINE p_npptype  LIKE npp_file.npptype             #No.FUN-680034 
   DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
   IF g_nmg.nmg13 IS NULL OR g_nmg.nmg13=' ' THEN
      UPDATE npp_file SET npp02=g_nmg.nmg01
       WHERE npp01=g_nmg.nmg00 
         AND npptype=p_npptype                         #No.FUN-680034
         AND npp00=3
         AND npp011=1
         AND nppsys = 'NM'
      IF STATUS THEN
         CALL cl_err3("upd","npp_file",g_nmg.nmg00,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
      END IF
      #FUN-E80012---add---str---
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
      IF g_nmz.nmz70 = '3' THEN
         LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_nmg.nmg01,1)
         LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_nmg.nmg01,3)
         UPDATE tic_file SET tic01=l_tic01,
                             tic02=l_tic02
         WHERE tic04=g_nmg.nmg00
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'   #MOD-F30123 add
            CALL cl_err3("upd","tic_file",g_nmg.nmg00,"",STATUS,"","upd tic01 tic02",1)
         END IF
      END IF
      #FUN-E80012---add---end---
   END IF
END FUNCTION
 
FUNCTION t302_r()
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_nmg.nmg00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
   IF g_nmg.nmgconf='Y' THEN
      CALL cl_err(g_nmg.nmg00,'anm-105',2)
      RETURN
   END IF
   IF g_nmg.nmgconf='X' THEN
      CALL cl_err(g_nmg.nmg00,'9024',0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nmg_o.* = g_nmg.*
   LET g_nmg_t.* = g_nmg.*
   CALL t302_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nmg00"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nmg.nmg00      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM npp_file
       WHERE nppsys= 'NM'
         AND npp00 = 3
         AND npp01 = g_nmg.nmg00
         AND npp011 = 1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","npp_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete npp)",1)  #No.FUN-660148
         LET g_success='N'
      END IF
      DELETE FROM npq_file
       WHERE npqsys= 'NM'
         AND npq00=3
         AND npq01 = g_nmg.nmg00
         AND npq011=1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","npq_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete npq)",1)  #No.FUN-660148
         LET g_success='N'
      END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_nmg.nmg00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tic_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete tic)",1)
         LET g_success='N'
      END IF
      #FUN-B40056--add--end--

      DELETE FROM npk_file WHERE npk00 = g_nmg.nmg00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","npk_file", g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete npk)",1)  #No.FUN-660148
         LET g_success='N'
      END IF
      DELETE FROM nmg_file WHERE nmg00 = g_nmg.nmg00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","nmg_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete nmg)",1)  #No.FUN-660148
         LET g_success='N'
      END IF

      #FUN-B30213--add--str--   
      UPDATE nmu_file SET nmu14 = ''
       WHERE nmu14 = g_nmg.nmg00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","nmu_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:update nmu)",1)
         LET g_success='N'
      END IF
      #FUN-B30213--add--end-- 

      LET g_msg = TIME    #MOD-910197 add
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal 
                   VALUES ('anmt302',g_user,g_today,g_msg,g_nmg.nmg00,'Delete',g_plant,g_legal)  #MOD-910197
      INITIALIZE g_nmg.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET g_nmg_t.* = g_nmg.*
         CALL cl_flow_notify(g_nmg.nmg00,'D')
         OPEN t302_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t302_cs
            CLOSE t302_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         FETCH t302_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t302_cs
            CLOSE t302_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t302_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t302_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t302_fetch('/')
         END IF         
      ELSE
         ROLLBACK WORK
         LET g_nmg.* = g_nmg_t.*
      END IF
   END IF
   CLOSE t302_cl           #MOD-D60105
   CALL t302_show()
   CALL t302_b_fill_1()          #No.FUN-CB0080   Add
END FUNCTION
 
#FUNCTION t302_x()                               #FUN-D20035
FUNCTION t302_x(p_type)                          #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1          #FUN-D20035 
   DEFINE l_flag1    LIKE type_file.chr1          #FUN-D20035 
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_nmg.nmg00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
   IF g_nmg.nmgconf='Y' THEN
      CALL cl_err(g_nmg.nmg00,'anm-105',2)
      RETURN
   END IF
   #已有收款沖帳資料
   SELECT COUNT(*) INTO g_cnt FROM ooa_file,oob_file 
     WHERE ooa01 = oob01 AND oob06 = g_nmg.nmg00 AND ooaconf<>'X'  
   IF g_cnt > 0 THEN
      CALL cl_err('','anm-538',0)
      RETURN
   END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_nmg.nmgconf ='X' THEN RETURN END IF
   ELSE
      IF g_nmg.nmgconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nmg_o.* = g_nmg.*
   LET g_nmg_t.* = g_nmg.*
   CALL t302_show()
  #IF cl_void(0,0,g_nmg.nmgconf) THEN                                  #FUN-D20035
   IF p_type = 1 THEN LET l_flag1 = 'N' ELSE LET l_flag1 = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag1) THEN                                         #FUN-D20035
     #IF g_nmg.nmgconf='N' THEN    #切換為作廢                         #FUN-D20035
      IF p_type = 1 THEN                                               #FUN-D20035
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00=3
            AND npp01 = g_nmg.nmg00
            AND npp011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete npp)",1)  #No.FUN-660148
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'NM'
            AND npq00=3
            AND npq01 = g_nmg.nmg00
            AND npq011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete npq)",1)  #No.FUN-660148
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_nmg.nmg00
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","(t302_r:delete tic)",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--

         LET g_nmg.nmgconf='X'
      ELSE                         #取消作廢
         LET g_nmg.nmgconf='N'
      END IF
      UPDATE nmg_file SET nmgconf=g_nmg.nmgconf
       WHERE nmg00 = g_nmg.nmg00
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","nmg_file",g_nmg.nmg00,"",STATUS,"","",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF
   SELECT nmgconf INTO g_nmg.nmgconf FROM nmg_file
    WHERE nmg00 = g_nmg.nmg00
   DISPLAY BY NAME g_nmg.nmgconf
   CLOSE t302_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL t302_b_fill_1()          #No.FUN-CB0080   Add
      CALL cl_flow_notify(g_nmg.nmg00,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t302_v(p_cmd)
   DEFINE l_wc      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmg     RECORD LIKE nmg_file.*
   DEFINE only_one  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_t1      LIKE nmy_file.nmyslip  #No.FUN-680107 VARCHAR(5)              #No.FUN-550057
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3  #No.FUN-680107 VARCHAR(1)
   DEFINE ls_tmp    STRING
 
  IF g_nmg.nmgconf='Y' THEN
     CALL cl_err('','axr-913',0)
     RETURN
  END IF
   BEGIN WORK
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
   IF p_cmd  = '1' THEN
      LET ls_tmp = g_prog CLIPPED
      LET g_prog = "anmt3029"
      OPEN WINDOW t302_w9 AT 4,10 WITH FORM "anm/42f/anmt3029"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("anmt3029")
      LET only_one = '1'
      INPUT BY NAME only_one WITHOUT DEFAULTS
 
         AFTER FIELD only_one
            IF only_one IS NULL THEN NEXT FIELD only_one END IF
            IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
         CLOSE WINDOW t302_w9
         LET g_prog = ls_tmp
         RETURN
      END IF
      IF only_one = '1' THEN
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
         IF g_nmg.nmgconf = 'X' THEN
            CALL cl_err('','9024',0)
            CLOSE WINDOW t302_w9
            LET g_prog = ls_tmp
            RETURN
         END IF
         LET l_wc = " nmg00 = '",g_nmg.nmg00,"' "
      ELSE
         CONSTRUCT BY NAME l_wc ON nmg00,nmg01
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
            LET INT_FLAG=0
            CLOSE WINDOW t302_w9
            LET g_prog = ls_tmp
            RETURN
         END IF
      END IF
      CLOSE WINDOW t302_w9
      LET g_prog = ls_tmp
   ELSE
      LET l_wc = " nmg00 = '",g_nmg.nmg00,"' "
   END IF
   LET l_nmg.* = g_nmg.*
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM nmg_file WHERE nmgconf <> 'X' AND ",l_wc CLIPPED,
               " ORDER BY nmg00"
   PREPARE t302_v_p FROM g_sql
   DECLARE t302_v_c CURSOR WITH HOLD FOR t302_v_p
   LET g_success='Y'
   BEGIN WORK
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t302_v_c INTO g_nmg.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         LET g_success='N'              #FUN-8A0086 
         EXIT FOREACH
      END IF
      IF g_nmg.nmg01 <= g_nmz.nmz10 THEN   #立帳日期小於關帳日期 no.5261
         CALL s_errmsg('','',g_nmg.nmg00,'aap-176',0)   #No.FUN-710024
         CONTINUE FOREACH
      END IF
      LET l_t1 = s_get_doc_no(g_nmg.nmg00)       #No.FUN-550057
      LET l_nmydmy3 = ''
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('nmyslip',l_t1,'sel nmy:',STATUS,0)   #No.FUN-710024
      END IF
      IF l_nmydmy3 = 'Y' THEN   #是否拋轉傳票
         IF NOT cl_null(g_nmg.nmg13) THEN
            CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
            MESSAGE g_nmg.nmg00,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         IF g_nmg.nmgconf='Y' THEN
            CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
            MESSAGE g_nmg.nmg00,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         CALL s_t302_gl(g_nmg.nmg00,'0')                  #產生第一分錄
         IF g_aza.aza63='Y' AND g_success='Y' THEN
            CALL s_t302_gl(g_nmg.nmg00,'1')               #產生第二分錄
         END IF   
      ELSE 
         CALL cl_err(g_nmg.nmg00,'anm-222',0) 
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   CALL s_showmsg() #No.FUN-710028
   CLOSE t302_cl   #MOD-D60105
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   LET g_nmg.*=l_nmg.*
   MESSAGE " "
END FUNCTION
 
 
FUNCTION t302_firm1()
   DEFINE l_nmg00_old  LIKE nmg_file.nmg00
   DEFINE only_one     LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)
   DEFINE ls_tmp       STRING
   DEFINE l_n          LIKE type_file.num5         #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_t1         LIKE nmy_file.nmyslip       #MOD-640528
   DEFINE l_nmydmy3    LIKE nmy_file.nmydmy3       #MOD-640528
   DEFINE l_olc11_sum  LIKE olc_file.olc11         #CHI-810012
   DEFINE l_olc29      LIKE olc_file.olc29         #CHI-810012
   DEFINE l_cnt        LIKE type_file.num5         #MOD-890286 add
   DEFINE l_i          LIKE type_file.num5         #MOD-890286 add
   DEFINE l_nmg        DYNAMIC ARRAY OF RECORD     #MOD-890286 add
                        nmg00  LIKE nmg_file.nmg00,
                        nmg01  LIKE nmg_file.nmg01
                       END RECORD
   DEFINE l_npk05      LIKE npk_file.npk05      #NO.FUN-920126
   DEFINE l_s_npk08    LIKE npk_file.npk08      #No,FUN-920126                    
   DEFINE l_npk06      LIKE npk_file.npk06      #MOD-C60037 add
   DEFINE l_ola06      LIKE ola_file.ola06      #MOD-C60037 add
   DEFINE l_ola09      LIKE ola_file.ola09      #MOD-C60037 add
   DEFINE l_ola10      LIKE ola_file.ola10      #TQC-C60230   add
   DEFINE l_olc09      LIKE olc_file.olc09      #TQC-C60236   add
#  DEFINE l_oia07      LIKE oia_file.oia07      #FUN-C50136
   DEFINE l_npk08      LIKE npk_file.npk08      #No.FUN-C90127
   DEFINE l_npk09      LIKE npk_file.npk09      #No.FUN-C90127
   DEFINE l_apa01      LIKE apa_file.apa01      #No.FUN-C90127
 
   LET g_success='Y'
   IF cl_null(g_nmg.nmg00) THEN
   #  CALL cl_err('',-400,0)            #TQC-B10069 
      CALL s_errmsg("","","",'-400',1)  #TQC-B10069
      LET g_success='N'                 #TQC-B10069
   #  RETURN                            #TQC-B10069
   END IF
   IF g_nmg.nmgconf='Y' THEN
    # CALL cl_err('','axr-913',0)       #TQC-B10069                             
      CALL s_errmsg("nmg00",g_nmg.nmg00,g_nmg.nmgconf,'axr-913',1)  #TQC-B10069
      LET g_success='N'                 #TQC-B10069 
    # RETURN                            #TQC-B10069 
   END IF
   IF g_nmy.nmydmy3 = 'Y' THEN
      CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
      SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno1
      IF g_nmg.nmg01 <= l_aaa07 THEN
      #  CALL cl_err('','aap-176',1)    #TQC-B10069
         CALL s_errmsg("nmg00",g_nmg.nmg00,g_nmg.nmg01,'aap-176',1)  #TQC-B10069 
         LET g_success='N'              #TQC-B10069  
      #  RETURN                         #TQC-B10069 
      END IF
      IF g_aza.aza63 = 'Y' THEN
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno2
         IF g_nmg.nmg01 <= l_aaa07 THEN
         #  CALL cl_err('','aap-176',1) #TQC-B10069
            CALL s_errmsg("nmg00",g_nmg.nmg00,g_nmg.nmg01,'aap-176',1) #TQC-B10069
            LET g_success='N'           #TQC-B10069 
         #  RETURN                      #TQC-B10069
         END IF
      END IF
   END IF
  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      CALL s_chknpq(g_nmg.nmg00,'NM',1,'0',g_bookno1)
      IF g_aza.aza63 ='Y' AND g_success ='Y' THEN
         CALL s_chknpq(g_nmg.nmg00,'NM',1,'1',g_bookno2)
      END IF
   END IF
  #No.FUN-C90127   ---end  --- Add
   LET ls_tmp = g_prog CLIPPED
   #LET g_prog = "anmt3023"
   LET g_prog = "anmt302"     #yinhy131010
   OPEN WINDOW t302_w3 AT 10,11 WITH FORM "anm/42f/anmt3023"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    #CALL cl_ui_locale("anmt3023")
    CALL cl_ui_locale("anmt3023")   #yinhy131010
 
   LET l_nmg00_old=g_nmg.nmg00    # backup old key value nmg00
   LET only_one = '1'
 
   BEGIN WORK
 
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
   #  CALL cl_err("OPEN t302_cl:", STATUS, 1)          #TQC-B10069
      CALL s_errmsg("","","OPEN t302_cl:",STATUS,1)    #TQC-B10069 
      LET g_success='N'                                #TQC-B10069    
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)               #TQC-B10069
      CALL s_errmsg("nmg00",g_nmg.nmg00,"",SQLCA.sqlcode,1)  #TQC-B10069
      LET g_success='N'                                      #TQC-B10069
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF only_one IS NULL THEN NEXT FIELD only_one END IF
         IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
      CLOSE WINDOW t302_w3
      LET g_prog = ls_tmp
      RETURN
   END IF
   IF only_one = '1' THEN
      SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
      IF g_nmg.nmgconf='Y' THEN
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
         RETURN
      END IF
      IF g_nmg.nmgconf='X' THEN
      #  CALL cl_err('','9024',0)           #TQC-B10069
         CALL s_errmsg("nmg00",g_nmg.nmg00,g_nmg.nmgconf,'9024',1)  #TQC-B10069 
         LET g_success='N'                  #TQC-B10069     
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
      #  RETURN                             #TQC-B10069       
      END IF
      LET g_wc = " nmg00 = '",g_nmg.nmg00,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON nmg00,nmg01
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
         LET INT_FLAG=0
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
         RETURN
      END IF
      IF NOT cl_sure(20,20) THEN
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
         RETURN
      END IF
   END IF
   #資料權限的檢查
 
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM nmg_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND (nmgconf='N' OR (nmgconf='' OR nmgconf is null))"
   PREPARE t302_firm1_p1 FROM g_sql
   IF STATUS THEN
   #  CALL cl_err('t302_firm1_p1',STATUS,1)             #TQC-B10069
      CALL s_errmsg("",'t302_firm1_p1',"",'STATUS',1)   #TQC-B10069 
      LET g_success='N'                                 #TQC-B10069     
   END IF
   DECLARE t302_firm1_curs CURSOR FOR t302_firm1_p1
#  CALL s_showmsg_init()   #No.FUN-710024     #TQC-B10069
   CALL l_nmg.clear()   #MOD-890286 add
   LET l_cnt = 1        #MOD-890286 add
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   FOREACH t302_firm1_curs INTO g_nmg.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         CALL s_errmsg('','','foreach',STATUS,0)   #No.FUN-710024
         LET g_success='N'              #FUN-8A0086 
         EXIT FOREACH
      END IF

#No.CHI-A80036   ---begin---
     IF g_nmy.nmydmy3 = 'Y' THEN
        CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
        SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno1
        IF g_nmg.nmg01 <= l_aaa07 THEN
           CALL s_errmsg('','',g_nmg.nmg00,'aap-176',1)
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF
        IF g_aza.aza63 = 'Y' THEN
           SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno2
           IF g_nmg.nmg01 <= l_aaa07 THEN
              CALL s_errmsg('','',g_nmg.nmg00,'aap-176',1)
              LET g_success = 'N'
              CONTINUE FOREACH 
           END IF
        END IF
     END IF
#No.CHI-A80036   ---end---

      IF g_nmg.nmg01 <= g_nmz.nmz10 THEN           #No.MOD-490143
         CALL s_errmsg('','',g_nmg.nmg00,'aap-176',1)  #No.FUN-710024
         LET g_success='N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      SELECT COUNT(*) INTO g_cnt FROM npk_file
       WHERE npk00 = g_nmg.nmg00
      IF g_cnt = 0 THEN
         CALL s_errmsg('','',g_nmg.nmg00,'arm-034',1)  #No.FUN-710028  #CHI-8C0043 mod
         LET g_success='N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
#No.MOD-A10128 --begin                                                          
#     CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_dbs_gl) RETURNING g_flag,g_bookno1,g_bookno2
      CALL s_get_bookno1(YEAR(g_nmg.nmg01),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2    #No.TQC-A60131
      IF g_flag = '1' THEN                                                      
         CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)                             
         LET g_success='N'               #TQC-B10069
      END IF                                                                    
      LET g_cnt = 0                                                             
      SELECT COUNT(*) INTO g_cnt FROM npk_file,aag_file                         
       WHERE npk00 = g_nmg.nmg00                                                
         AND npk07 = aag01                                                      
         AND aag00 = g_bookno1                                                  
         AND aagacti ='N'                                                       
      IF g_cnt > 0 THEN                                                         
         CALL s_errmsg('','',g_nmg.nmg00,'aim-828',1)  
         LET g_success='N'                                                      
      #  EXIT FOREACH       #TQC-B10069
         CONTINUE FOREACH   #TQC-B10069                                                    
      END IF                                                                    
#No.MOD-A10128 --end 
      LET l_t1 = s_get_doc_no(g_nmg.nmg00)
      LET l_nmydmy3 = ''
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = l_t1  #No.FUN-670060
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('nmyslip',l_t1,'sel nmydmy3:',STATUS,1)              #No.FUN-710024
         LET g_success='N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      CALL s_get_bookno(YEAR(g_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_nmg.nmg01),'aoo-081',1)
         LET g_success = 'N'
      END IF
      IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN     #No.TQC-790178
         CALL s_chknpq(g_nmg.nmg00,'NM',1,'0',g_bookno1)        #No.FUN-730032
         IF g_aza.aza63='Y' and g_success='Y'THEN
            CALL s_chknpq(g_nmg.nmg00,'NM',1, '1',g_bookno2)        #No.FUN-730032
         END IF
      END IF
      IF g_success='Y' THEN #MOD-970126
         CALL t302_y1()
      END IF  #MOD-970126
      IF g_success='N' THEN
         LET g_success = 'N' #No.FUN-710024
         CONTINUE FOREACH    #No.FUN-710024
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
      #  RETURN         #TQC-B10069
      END IF
      IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
         CALL t302_ins_oma()
         CALL t302_ins_omc() #MOD-740395
      END IF
      IF g_success='N' THEN
         LET g_success = 'N' #No.FUN-710024
         CONTINUE FOREACH    #No.FUN-710024
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
      #  RETURN        #TQC-B10069
      END IF
 
      IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN 
         SELECT COUNT(*) INTO l_n FROM npq_file
          WHERE npqsys= 'NM'
            AND npq00=3
            AND npq01 = g_nmg.nmg00
            AND npq011=1
         IF l_n = 0 THEN
            CALL t302_gen_glcr(g_nmg.*,g_nmy.*) 
         END IF  
         IF g_success = 'Y' THEN
            CALL s_chknpq(g_nmg.nmg00,'NM',1,'0',g_bookno1)   
            IF g_aza.aza63='Y' THEN
               CALL s_chknpq(g_nmg.nmg00,'NM',1,'1',g_bookno2)  
            END IF
         END IF
      IF g_success='N' THEN 
         CONTINUE FOREACH  #No.FUN-710024
      END IF
      END IF 
 
      UPDATE nmg_file SET nmgconf = 'Y' WHERE nmg00 = g_nmg.nmg00
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('nmg00',g_nmg.nmg00,'upd nmgconf',STATUS,1)                #No.FUN-710024
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
         LET g_success = 'N' #No.FUN-710024
         CONTINUE FOREACH    #No.FUN-710024
      #  RETURN    #TQC-B10069
      END IF
#     #FUN-C50136--add--start--
#     IF g_oaz96 = 'Y' AND g_success = 'Y' THEN
#        CALL s_ccc_oia07('L',g_nmg.nmg18) RETURNING l_oia07
#        IF NOT cl_null(l_oia07) AND l_oia07 = '0' THEN
#           CALL s_ccc_oia(g_nmg.nmg18,'L',g_nmg.nmg00,0,'')
#        END IF
#     END IF
#     #FUN-C50136--add--end--
      IF g_nmg.nmg20 = '22' THEN
         SELECT UNIQUE npk05 INTO l_npk05 
           FROM npk_file 
          WHERE npk00=g_nmg.nmg00   
            AND npk03= '1'      
            AND npk04 IS NOT NULL
         SELECT SUM(npk08) INTO l_s_npk08
           FROM npk_file
          WHERE npk00=g_nmg.nmg00 
            AND npk03 = '3'  
            AND npk05 = l_npk05
          IF cl_null(l_s_npk08) THEN LET l_s_npk08 = 0 END IF
         #---------------------------MOD-C60037-----------------------(S)
          SELECT ola06,ola09 INTO l_ola06,l_ola09
            FROM ola_file,olc_file,nmg_file
           WHERE ola01 = olc29
             AND olc01 = nmg21
             AND nmg00 = g_nmg.nmg00
          IF cl_null(l_ola06) THEN LET l_ola06 = 0 END IF
          IF cl_null(l_ola09) THEN LET l_ola09 = 0 END IF
          LET l_npk06 = 1
          IF l_ola06 <> l_npk05 THEN
             CALL s_curr3(l_ola06,g_nmg.nmg01,'B') RETURNING l_npk06
             LET l_npk06 = g_npk[l_ac].npk06 / l_npk06
          END IF
          SELECT azi04 INTO t_azi04
            FROM azi_file
           WHERE azi01 = l_npk05
         #LET l_s_npk08 =  g_nmg.nmg23 + l_s_npk08                #MOD-C60037 mark
          LET l_s_npk08 =  (g_nmg.nmg23 + l_s_npk08) * l_npk06
          CALL cl_digcut(l_s_npk08,t_azi04) RETURNING l_s_npk08
         #---------------------------MOD-C60037-----------------------(E)

          #TQC-C60230--add--str--
          #SELECT olc29 INTO l_olc29 FROM olc_file                #TQC-C60236   mark
          SELECT olc29,olc09 INTO l_olc29,l_olc09 FROM olc_file   #TQC-C60236   add
           WHERE olc01 = g_nmg.nmg21
          SELECT SUM(olc11) INTO l_olc11_sum FROM olc_file
           WHERE olc29 = l_olc29
          #TQC-C60230--add--end--
 
         #---------------------------MOD-C60037-----------------------(S)
          IF l_olc11_sum+l_s_npk08 > l_olc09 THEN    
             CALL cl_err(l_s_npk08,'axr-041',0)
             LET g_success='N'
             CONTINUE FOREACH
          ELSE
         #---------------------------MOD-C60037-----------------------(E)
            #UPDATE olc_file SET olc11=l_s_npk08 ,olc12=g_nmg.nmg01,   #MOD-730126       #TQC-C60230  mark
             UPDATE olc_file 
               #SET olc11 = l_olc11_sum + l_s_npk08,            #TQC-C60230 add #MOD-CB0049 mark
                SET olc11 = olc11 + l_s_npk08,                  #MOD-CB0049 add
                    olc12 = g_nmg.nmg01,                        #TQC-C60230  add
                    olc13 = g_npk[l_ac].npk04,                  #MOD-CA0231 add
                    olc20 = g_nmg.nmg01                         #No.CHI-860029
              WHERE olc01 = g_nmg.nmg21                         #No.CHI-790008  
             IF STATUS THEN
                CALL s_errmsg('olc01',g_nmg.nmg21,"upd olc_file",STATUS,1)   #CHI-920056 mod 
                LET g_success = 'N'
             END IF
          END IF                                                             #MOD-C60037 add
        #-------------------MOD-C60037------------------mark
        ##TQC-C60236--add--str--
        #IF l_olc11_sum+l_s_npk08 > l_olc09 THEN
        #   CALL  s_errmsg('','','','axr-041',1)  
        #   LET g_success = 'N'
        #END IF
        ##TQC-C60236--add--end--
        #-------------------MOD-C60037------------------mark
      END IF
     #No.FUN-C90127   ---start--- Add
      IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
         SELECT SUM(npk08),SUM(npk09) INTO l_npk08,l_npk09 FROM npk_file
          WHERE npk03 = '2' AND npk00 = g_nmg.nmg00
         IF cl_null(l_npk08) THEN LET l_npk08 = 0 END IF
         IF cl_null(l_npk09) THEN LET l_npk09 = 0 END IF
         SELECT apa01 INTO l_apa01 FROM apa_file,aph_file WHERE apa01 = aph23 AND aph01 = g_nmg.nmg31
         UPDATE apa_file SET apa35 = apa35 + l_npk09,
                             apa35f= apa35f+ l_npk08
          WHERE apa01 = l_apa01
         IF STATUS THEN
            CALL s_errmsg('apa01',l_apa01,"upd apa_file",STATUS,1)
            LET g_success = 'N'
         END IF
         #No.MOD-D80177  --Begin
         UPDATE apc_file SET apc10 = apc10 +  l_npk09,
                             apc11 = apc11 + l_npk08
          WHERE apc01 = l_apa01
            AND apc02 = '1'          
         IF STATUS THEN
            CALL s_errmsg('apc01',l_apa01,"upd apc_file",STATUS,1)
            LET g_success = 'N'
         END IF
         #No.MOD-D80177  --End
      END IF
     #No.FUN-C90127   ---end  --- Add
      LET l_nmg[l_cnt].nmg00 = g_nmg.nmg00
      LET l_nmg[l_cnt].nmg01 = g_nmg.nmg01
      LET l_cnt = l_cnt + 1
   END FOREACH                     
   CALL l_nmg.deleteElement(l_cnt)
   LET l_cnt = l_cnt - 1         
      SELECT olc29 INTO l_olc29 FROM olc_file
       WHERE olc01 = g_nmg.nmg21 
      SELECT SUM(olc11) INTO l_olc11_sum FROM olc_file
       WHERE olc29 = l_olc29 
     #---------------------------MOD-C60037-----------------------(S)
      IF l_olc11_sum > l_ola09 THEN
         CALL cl_err(l_olc11_sum,'axr-041',0)
         LET g_success='N'
      ELSE
     #---------------------------MOD-C60037-----------------------(E)
         UPDATE ola_file SET ola10 =l_olc11_sum     
          WHERE ola01 = l_olc29
         IF STATUS THEN
            CALL s_errmsg('ola01',g_nmg.nmg21,"upd ola_file",STATUS,1)  #CHI-920056 mod
            LET g_success = 'N'
         END IF
      END IF                          #MOD-C60037 add
      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          
    
     #CALL s_showmsg() #No.FUN-710024    #TQC-B10069
      IF g_success='N' THEN
         ROLLBACK WORK             #TQC-C60236  add
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
         CLOSE WINDOW t302_w3
         LET g_prog = ls_tmp
         #ROLLBACK WORK            #TQC-C60236  mark
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_nmg.nmg00,'Y')
         CALL cl_cmmsg(1) 
      END IF
    
   CLOSE WINDOW t302_w3
   LET g_prog = ls_tmp
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old

   FOR l_i = 1 TO l_cnt
      LET g_nmg.nmg00 = l_nmg[l_i].nmg00
      LET g_nmg.nmg01 = l_nmg[l_i].nmg01
      LET l_t1 = s_get_doc_no(g_nmg.nmg00)
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = l_t1
      IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
         LET g_wc_gl = 'npp01 = "',g_nmg.nmg00,'" AND npp011 = 1'
         LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
                   " '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' ",                                #No.FUN-680034
                   " '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nmg.nmg01,"' 'Y' '1' 'Y'"   #No.FUN-680034 #FUN-860040
         CALL cl_cmdrun_wait(g_str) 
         SELECT nmg13,nmg14 INTO g_nmg.nmg13,g_nmg.nmg14 FROM nmg_file                                                                 
          WHERE nmg00 = g_nmg.nmg00                                                                                                    
         DISPLAY BY NAME g_nmg.nmg13                                                                                                   
         DISPLAY BY NAME g_nmg.nmg14                                                                                                   
      END IF                                                                                                                           
   END FOR     #MOD-890286 add
 
   DISPLAY g_nmg.nmgconf,g_nmg.nmg24 TO nmgconf,nmg24
   CALL cl_set_field_pic(g_nmg.nmgconf,"","","","N","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t302_y1()
 DEFINE l_nma21 LIKE nma_file.nma21
   DECLARE t302_ics2 CURSOR  WITH HOLD FOR
        SELECT * FROM npk_file WHERE npk00 = g_nmg.nmg00 ORDER BY npk01
   MESSAGE g_nmg.nmg00
   FOREACH t302_ics2 INTO m_npk.*
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','','foreach',status,0)  #No.FUN-710024 
         EXIT FOREACH
      END IF
      IF cl_null(m_npk.npk04) THEN
         CONTINUE FOREACH
      END IF
      IF m_npk.npk03 MATCHES '[12]' THEN     #No:7365
          SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = m_npk.npk04
          IF STATUS THEN
             CALL s_errmsg('nma01',m_npk.npk04,'sel nma:',STATUS,1)  #No.FUN-710024
             LET g_success='N'
             EXIT FOREACH    
          END IF
          IF NOT cl_null(l_nma21) THEN
             IF l_nma21 > g_nmg.nmg01  THEN
                CALL s_errmsg('','',m_npk.npk04,'anm-225',1)  #No.FUN-710024  
                LET g_success='N'
                EXIT FOREACH
             END IF
          END IF
          CALL t302_ins_nme()
      END IF
      IF g_success='N' THEN EXIT FOREACH END IF
   END FOREACH
END FUNCTION
 
FUNCTION t302_firm2()
   DEFINE l_nmg00_old LIKE nmg_file.nmg00
   DEFINE only_one    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt       LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_oma57     LIKE oma_file.oma57
   DEFINE ls_tmp      STRING
   DEFINE l_aba19     LIKE aba_file.aba19    #No.FUN-670060
   DEFINE l_dbs       STRING                 #No.FUN-670060
   DEFINE l_sql       STRING                 #No.FUN-670060 
#No.MOD-B10242 --begin
   DEFINE i           LIKE type_file.num5
   DEFINE l_nmg       DYNAMIC ARRAY OF RECORD 
                         nmg13 LIKE nmg_file.nmg13
                      END RECORD 
#No.MOD-B!0242 --end
   #TQC-C60230--add--str--
   DEFINE l_olc11_sum  LIKE olc_file.olc11
   DEFINE l_npk05      LIKE npk_file.npk05     
   DEFINE l_s_npk08    LIKE npk_file.npk08     
   DEFINE l_ola10      LIKE ola_file.ola10
   DEFINE l_olc29      LIKE olc_file.olc29
   #TQC-C60230--add--end--
#  DEFINE l_oia07     LIKE oia_file.oia07     #FUN-C50136
   DEFINE l_npk08      LIKE npk_file.npk08      #No.FUN-C90127
   DEFINE l_npk09      LIKE npk_file.npk09      #No.FUN-C90127
   DEFINE l_apa01      LIKE apa_file.apa01      #No.FUN-C90127

   IF cl_null(g_nmg.nmg00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
   CALL s_get_doc_no(g_nmg.nmg00) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nmg.nmg13) OR NOT cl_null(g_nmg.nmg14) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nmg.nmg00,'axr-370',0) RETURN 
      END IF 
   END IF 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                              
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nmg.nmg13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102	
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nmg.nmg13,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
 
   LET ls_tmp = g_prog CLIPPED
   LET g_prog = "anmt3024"
   OPEN WINDOW t302_w4 AT 10,11 WITH FORM "anm/42f/anmt3024"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt3024")
 
 
   LET l_nmg00_old=g_nmg.nmg00    # backup old key value nmg00
   LET only_one = '1'
   LET g_success='Y'
 
  #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmg.nmg13,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nmg13,nmg14 INTO g_nmg.nmg13,g_nmg.nmg14 FROM nmg_file
       WHERE nmg00 = g_nmg.nmg00
      IF NOT cl_null(g_nmg.nmg13) THEN
         CALL cl_err(g_nmg.nmg13,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nmg.nmg13
      DISPLAY BY NAME g_nmg.nmg14
   END IF
   #CHI-C90052 add end-----
 
   BEGIN WORK
 
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF only_one IS NULL THEN NEXT FIELD only_one END IF
         IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
      CLOSE WINDOW t302_w4
      LET g_prog = ls_tmp
      RETURN
   END IF
   IF only_one = '1' THEN
      SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
      IF g_nmg.nmgconf='N' THEN
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         RETURN
      END IF
      IF g_nmg.nmgconf='X' THEN
         CALL cl_err('','9024',0)
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         RETURN
      END IF
      LET g_wc = " nmg00 = '",g_nmg.nmg00,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON nmg00,nmg01
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
         LET INT_FLAG=0
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         RETURN
      END IF
      IF NOT cl_sure(20,20) THEN
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         RETURN
      END IF
   END IF
   #資料權限的檢查
 
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM nmg_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND nmgconf='Y'"
   PREPARE t302_firm2_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('t302_firm2_p1',STATUS,1)
   END IF
   DECLARE t302_firm2_curs CURSOR FOR t302_firm2_p1
   CALL s_showmsg_init()   #No.FUN-710024
#No.MOD-B10242 --begin
   CALL l_nmg.clear()
   LET i=1
#No.MOD-B10242 --end
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   FOREACH t302_firm2_curs INTO g_nmg.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         CALL s_errmsg('','','foreach',STATUS,0)  #No.FUN-710024
         LET g_success='N'              #FUN-8A0086 
         EXIT FOREACH
      END IF
#No.MOD-B10242 --begin
      #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
      CALL s_get_doc_no(g_nmg.nmg00) RETURNING g_t1
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
      IF NOT cl_null(g_nmg.nmg13) OR NOT cl_null(g_nmg.nmg14) THEN
         IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
            CONTINUE FOREACH 
         END IF 
      END IF 
      IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                              
         LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), 
                     "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                     "    AND aba01 = '",g_nmg.nmg13,"'"
    	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102	
         PREPARE aba_pre2 FROM l_sql
         DECLARE aba_cs2 CURSOR FOR aba_pre2
         OPEN aba_cs2
         FETCH aba_cs2 INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CONTINUE FOREACH                                                                                                                     
         END IF 
         CLOSE aba_cs2                                                                                                                       
      END IF   
#No.MOD-B10242 --end
      
      #TQC-C60230--add--str--
      IF g_nmg.nmg20 = '22' THEN
         SELECT UNIQUE npk05 INTO l_npk05
           FROM npk_file
          WHERE npk00=g_nmg.nmg00
            AND npk03= '1'
            AND npk04 IS NOT NULL
         SELECT SUM(npk08) INTO l_s_npk08
           FROM npk_file
          WHERE npk00=g_nmg.nmg00
            AND npk03 = '3'
            AND npk05 = l_npk05
          IF cl_null(l_s_npk08) THEN LET l_s_npk08 = 0 END IF
          LET l_s_npk08 =  g_nmg.nmg23 + l_s_npk08

          SELECT olc29 INTO l_olc29 FROM olc_file
           WHERE olc01 = g_nmg.nmg21
          SELECT SUM(olc11) INTO l_olc11_sum FROM olc_file
           WHERE olc29 = l_olc29

           UPDATE olc_file 
             #SET olc11 = l_olc11_sum - l_s_npk08 ,    #MOD-CB0049 mark
              SET olc11 = olc11 - l_s_npk08 ,          #MOD-CB0049 add
                  olc12 = g_nmg.nmg01,      
                  olc13 = '',                          #MOD-CA0231 add
                  olc20 = g_nmg.nmg01                  #No.CHI-860029
           WHERE olc01 = g_nmg.nmg21                                                
         IF STATUS THEN
            CALL s_errmsg('olc01',g_nmg.nmg21,"upd olc_file",STATUS,1) 
            LET g_success = 'N'
         END IF
      END IF
      #TQC-C60230--add--end--

      IF g_nmg.nmg01 <= g_nmz.nmz10 THEN
         CALL s_errmsg('','',g_nmg.nmg00,'aap-176',1) #No.FUN-710024
         LET g_success='N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      IF g_nmg.nmg29='Y' THEN
         SELECT oma57 INTO l_oma57 FROM oma_file
          WHERE oma00='24' AND oma01=g_nmg.nmg00
         IF l_oma57 !=0 THEN
            CALL s_errmsg('','',g_nmg.nmg00,'aap-172',1)  #No.FUN-710024
            LET g_success='N'
         END IF
      ELSE
         IF g_nmg.nmg24>0 THEN
            CALL s_errmsg('','',g_nmg.nmg24,'anm-241',1)  #No.FUN-710024
            LET g_success='N'
         END IF
      END IF
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM  oob_file,ooa_file
       WHERE oob06=g_nmg.nmg00
        #AND oob03='1' AND oob04='2'              #MOD-AA0108 mark
        #AND oob03='1' AND oob04 IN ('2','3')     #MOD-AA0108  #MOD-BC0021 
         AND oob03='1'                            #MOD-BC0021
         AND oob01 = ooa01
         AND ooaconf != 'X'  #no.5088
      IF l_cnt > 0 THEN
         CALL s_errmsg('','',g_nmg.nmg00,'mfg-027',1)   #No.FUN-710024
         LET g_success='N'
      END IF
      IF g_success='N'THEN
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         CONTINUE FOREACH      #No.FUN-710024
      END IF
      CALL t302_z1()
      IF g_success='N'THEN
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         CONTINUE FOREACH      #No.FUN-710024
      END IF
      IF g_nmg.nmg29='Y' THEN
         DELETE FROM oma_file WHERE oma00='24' AND oma01=g_nmg.nmg00
         DELETE FROM omc_file WHERE omc01=g_nmg.nmg00  #MOD-740395
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_showmsg = '24',"/",g_nmg.nmg00     #No.FUN-710024
            CALL s_errmsg('oma00,oma01',g_showmsg,'del oma',SQLCA.SQLCODE,1)            #No.FUN-710024
            LET g_success='N'
            CONTINUE FOREACH  #No.FUN-710024
         END IF
         DELETE FROM oov_file WHERE oov01 = g_nmg.nmg00
         IF STATUS THEN
            CALL s_errmsg('oov01',g_nmg.nmg00,'No oov deleted',STATUS,1)   #No.FUN-710024
            LET g_success = 'N'
         END IF
         UPDATE nmg_file SET nmg24=0 WHERE nmg00 = g_nmg.nmg00
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('nmg00',g_nmg.nmg00,'upd nmg24',SQLCA.SQLCODE,1)                #No.FUN-710024
            LET g_success='N'
            CONTINUE FOREACH  #No.FUN-710024
         END IF
      END IF
      UPDATE nmg_file SET nmgconf = 'N' WHERE nmg00 = g_nmg.nmg00
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('nmg00',g_nmg.nmg00,'upd nmgconf',SQLCA.SQLCODE,1)   #No.FUN-710024
         SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
         CLOSE WINDOW t302_w4
         LET g_prog = ls_tmp
         LET g_success = 'N'   #No.FUN-710024
         CONTINUE FOREACH      #No.FUN-710024
      END IF
#    #FUN-C50136--ADD--START--
#     IF g_oaz96 ='Y' AND g_success = 'Y' THEN
#        CALL s_ccc_oia07('L',g_nmg.nmg18) RETURNING l_oia07
#        IF l_oia07 = '0' THEN
#           CALL s_ccc_rback(g_nmg.nmg18,'L',g_nmg.nmg00,0,'')
#        END IF
#     END IF
#    #FUN-C50136--ADD--END--
#N .MOD-B10242 --begin
     #No.FUN-C90127   ---start--- Add
      IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
         SELECT SUM(npk08),SUM(npk09) INTO l_npk08,l_npk09 FROM npk_file
          WHERE npk03 = '2' AND npk00 = g_nmg.nmg00
         IF cl_null(l_npk08) THEN LET l_npk08 = 0 END IF
         IF cl_null(l_npk09) THEN LET l_npk09 = 0 END IF
         SELECT apa01 INTO l_apa01 FROM apa_file,aph_file WHERE apa01 = aph23 AND aph01 = g_nmg.nmg31
         UPDATE apa_file SET apa35 = apa35 - l_npk09,
                             apa35f= apa35f- l_npk08
          WHERE apa01 = l_apa01
         IF STATUS THEN
            CALL s_errmsg('apa01',l_apa01,"upd apa_file",STATUS,1)
            LET g_success = 'N'
         END IF
         #No.MOD-D80177  --Begin
         UPDATE apc_file SET apc10 = apc10 -  l_npk09,
                             apc11 = apc11 - l_npk08
          WHERE apc01 = l_apa01
            AND apc02 = '1'
         IF STATUS THEN
            CALL s_errmsg('apc01',l_apa01,"upd apc_file",STATUS,1)
            LET g_success = 'N'
         END IF
         #No.MOD-D80177  --End
      END IF
     #No.FUN-C90127   ---end  --- Add
      IF NOT cl_null(g_nmg.nmg13) THEN 
         LET l_nmg[i].nmg13 = g_nmg.nmg13
         LET i=i+1
      END IF 
#No.MOD-B10242 --end
   END FOREACH

   #TQC-C60230--add--str--
   SELECT olc29 INTO l_olc29 FROM olc_file
    WHERE olc01 = g_nmg.nmg21
   SELECT SUM(olc11) INTO l_olc11_sum FROM olc_file
    WHERE olc29 = l_olc29

   UPDATE ola_file SET ola10 =l_olc11_sum    
    WHERE ola01 = l_olc29
   IF STATUS THEN
      CALL s_errmsg('ola01',g_nmg.nmg21,"upd ola_file",STATUS,1)  
      LET g_success = 'N'
   END IF
   #TQC-C60230--add--end--

   CALL l_nmg.deleteElement(i)  #No.MOD-B10242
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CALL s_showmsg() #No.FUN-710024
   IF g_success='N' THEN
      SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
      CLOSE WINDOW t302_w4
      LET g_prog = ls_tmp
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF
 
   CLOSE WINDOW t302_w4
   LET g_prog = ls_tmp

   #CHI-C90052 mark begin---
   ##No.MOD-B10242 --begin
   #FOR i =1 TO l_nmg.getlength()
   #    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmg[i].nmg13,"' 'Y'"
   #    CALL cl_cmdrun_wait(g_str) 
   #END FOR 
   ##No.MOD-B10242 --end
   #CHI-C90052 mark end---

   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = l_nmg00_old
#No.MOD-B10242 --begin 
#   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
#      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmg.nmg13,"' 'Y'"
#      CALL cl_cmdrun_wait(g_str) 
#      SELECT nmg13,nmg14 INTO g_nmg.nmg13,g_nmg.nmg14 FROM nmg_file 
#       WHERE nmg00 = g_nmg.nmg00
   DISPLAY BY NAME g_nmg.nmg13
   DISPLAY BY NAME g_nmg.nmg14
#   END IF 
#No.MOD-B10242 --end 
   DISPLAY g_nmg.nmgconf,g_nmg.nmg24 TO nmgconf,nmg24
END FUNCTION
 
FUNCTION t302_z1()
   DEFINE l_npk      RECORD LIKE npk_file.*
   DEFINE l_nma21    LIKE nma_file.nma21
   DEFINE l_yy,l_mm  LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_nme24    LIKE nme_file.nme24   #No.FUN-730032
   #MOD-B80144--add--str--
   DEFINE l_nme01    LIKE nme_file.nme01 
   DEFINE l_nme16    LIKE nme_file.nme16 
   #MOD-B80144--add--end-- 
 
   DECLARE t302_dcs2 CURSOR  WITH HOLD FOR
       SELECT * FROM npk_file WHERE npk00 = g_nmg.nmg00 ORDER BY npk01
   LET l_yy = YEAR(g_nmg.nmg01)
   LET l_mm = MONTH(g_nmg.nmg01)
   FOREACH t302_dcs2 INTO l_npk.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','del nme',status,1)   #No.FUN-710024
         LET g_success='N'
         RETURN
      END IF
      IF l_npk.npk03 MATCHES '[12]' THEN     #No:7365
         #取消確認單據日期不可小於對帳日
         SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_npk.npk04
         IF STATUS THEN
            CALL s_errmsg('nma01',l_npk.npk04,'sel nma:',STATUS,1)  #No.FUN-710024
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF NOT cl_null(l_nma21) THEN
            IF l_nma21 > g_nmg.nmg01  THEN
               CALL s_errmsg('','',l_npk.npk04,'anm-225',1)  #No.FUN-710024
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
         IF g_nmz.nmz20 = 'Y' AND l_npk.npk05 != g_aza.aza17 THEN
            IF (l_yy*12+l_mm) - (g_nmz.nmz21*12+g_nmz.nmz22) = 0 THEN
               CALL s_errmsg('','',l_mm,'axr-407',1)  #No.FUN-710024
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         MESSAGE g_nmg.nmg00
      END IF
   END FOREACH
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme12='",g_nmg.nmg00,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nmg.nmg00,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF

   #MOD-B80144--add--str--
   DECLARE del_nme16 CURSOR FOR
    SELECT nme01,nme16 FROM nme_file
     WHERE nme12 = g_nmg.nmg00
   FOREACH del_nme16 INTO l_nme01,l_nme16
      LET l_nma21 = NULL
      SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_nme01
      IF l_nma21 IS NOT NULL AND l_nma21 >= l_nme16 THEN
         CALL cl_err(l_nme16,'anm-225',1)   
         LET g_success='N'
         RETURN
      END IF
   END FOREACH
   #MOD-B80144--add--end--

   DELETE FROM nme_file WHERE nme12 = g_nmg.nmg00
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nme12',g_nmg.nmg00,'del nme',status,1)   #No.FUN-710024
      LET g_success='N'
      RETURN
   END IF
   #FUN-B40056 --begin
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
      DELETE FROM tic_file WHERE tic04 = g_nmg.nmg00
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tic04',g_nmg.nmg00,'del tic',status,1)   #No.FUN-710024
         LET g_success='N'
         RETURN
      END IF
   END IF
   #FUN-B40056 --end
END FUNCTION
 
FUNCTION t302_ins_oma()
   DEFINE g_nmg23      LIKE nmg_file.nmg23
   DEFINE g_nmg25      LIKE nmg_file.nmg25
 
 
   IF g_nmg.nmg23=0 OR g_nmg.nmg25=0 THEN
      CALL s_errmsg('','','nmg25=0','aap-201',1) #No.FUN-710024
      LET g_success='N'
      RETURN
   END IF
   INITIALIZE g_oma.* TO NULL
 
   LET g_oma.oma01 = g_nmg.nmg00
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      MESSAGE g_oma.oma01
   ELSE
      DISPLAY g_oma.oma01 AT 2,1
   END IF
 
   LET g_oma.oma00 = '24'
   LET g_oma.oma02 = g_nmg.nmg01
   LET g_oma.oma03 = g_nmg.nmg18
   LET g_oma.oma032= g_nmg.nmg19
   LET g_oma.oma04 = g_nmg.nmg18
   SELECT occ11,occ18,occ231,occ37
     INTO g_oma.oma042,g_oma.oma043,g_oma.oma044,g_oma.oma40
     FROM occ_file WHERE occ01=g_oma.oma03 AND occacti = 'Y'
      AND (occ06 = '1' OR occ06 = '3')                      #MOD-CC0027 add
 
   LET g_oma.oma07 = 'N'
   LET g_oma.oma08 = '1'
   SELECT ooz08 INTO g_oma.oma13 FROM ooz_file WHERE ooz00='0'  #No.TQC-940030
   LET g_oma.oma11 = g_oma.oma02
   LET g_oma.oma12 = g_oma.oma02
   LET g_oma.oma14 = g_user
  #SELECT gen03 INTO g_oma.oma15 FROM gen_file WHERE gen01=g_oma.oma14   #MOD-C80082 mark
   LET g_oma.oma15 = g_nmg.nmg11                                         #MOD-C80082 add
   LET g_oma.oma16 = g_nmg.nmg00
   LET g_oma.oma18 = g_nmg.nmg30
   IF g_aza.aza63='Y' THEN
     LET g_oma.oma181 = g_nmg.nmg301
   END IF
   LET g_oma.oma20 = 'N'
   LET g_oma.oma23 = m_npk.npk05
   LET g_oma.oma24 = m_npk.npk06
   LET g_oma.oma50 = 0
   LET g_oma.oma50t= 0
   LET g_oma.oma52 = 0
   LET g_oma.oma53 = 0
   LET g_oma.oma54x= 0
   LET g_oma.oma56x= 0
   LET g_oma.oma55 = 0
   LET g_oma.oma57 = 0
  #FUN-A60056--mod--str--
   LET g_oma.oma66 = g_plant
  #SELECT oga27 INTO g_oma.oma67 FROM oga_file
  # WHERE oga01 = g_oma.oma16
   LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),
               " WHERE oga01 = '",g_oma.oma16,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
   PREPARE sel_oga27 FROM g_sql
   EXECUTE sel_oga27 INTO g_oma.oma67
  #FUN-A60056--mod--end
   SELECT SUM(npk08) INTO g_nmg23 FROM npk_file
          WHERE npk00=g_nmg.nmg00 AND npk071 = g_nmg.nmg30
                AND (npk03='1' OR npk03='3')
   IF cl_null(g_nmg23) THEN
      LET g_nmg23 = 0
   END IF
   LET g_oma.oma54 = g_nmg23
   LET g_oma.oma54t = g_nmg23
   SELECT SUM(npk09) INTO g_nmg25 FROM npk_file
          WHERE npk00=g_nmg.nmg00 AND npk071 = g_nmg.nmg30
                AND (npk03='1' OR npk03='3')
   IF cl_null(g_nmg25) THEN
      LET g_nmg25 = 0
   END IF
   LET g_oma.oma56 = g_nmg25
   LET g_oma.oma56t = g_nmg25
   LET g_oma.oma68  = g_nmg.nmg18
   LET g_oma.oma69  = g_nmg.nmg19
   LET g_oma.oma51f = 0
   LET g_oma.oma51  = 0
   LET g_oma.oma58 = 0
   LET g_oma.oma59 = 0
   LET g_oma.oma59x= 0
   LET g_oma.oma59t= 0
   LET g_oma.oma60 = g_oma.oma24                 #bug no:A060
   LET g_oma.oma61 = g_oma.oma56t - g_oma.oma57  #bug no:A060
   LET g_oma.omaconf='Y'
   LET g_oma.omavoid='N'
   LET g_oma.omauser=g_user
   LET g_oma.omagrup=g_grup
   LET g_oma.omadate=g_today
   LET g_oma.oma65 = '1'   #FUN-5A0124
   LET g_oma.oma64 = '1'   #MOD-D10154
   LET g_oma.oma70 = '1'   #MOD-D10154
   LET g_oma.oma930=s_costcenter(g_oma.oma15) #FUN-680006
   SELECT occ45 INTO g_oma.oma32 FROM occ_file 
    WHERE occ01 = g_oma.oma68
      AND (occ06 = '1' OR occ06 = '3')                      #MOD-CC0027 add
 
   LET g_oma.omalegal = g_legal 
 
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
   IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
   IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
   IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
   INSERT INTO oma_file VALUES(g_oma.*)
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('oma01',g_oma.oma01,'ins oma',SQLCA.SQLCODE,1)   #No.FUN-710024
      LET g_success='N'
      RETURN
   END IF
 
    UPDATE nmg_file SET nmg24=g_nmg.nmg23 WHERE nmg00=g_nmg.nmg00
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('nmg00',g_nmg.nmg00,'upd nmg24',SQLCA.SQLCODE,1)  #No.FUN-710024
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t302_ins_omc()
DEFINE l_omc   RECORD LIKE omc_file.*,
       l_omc08 LIKE omc_file.omc08,
       l_omc09 LIKE omc_file.omc09,
       l_omc02 LIKE omc_file.omc02
 
   CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
 
   IF g_oma.oma00[1,1] = '2' THEN
      LET l_omc.omc01 = g_oma.oma01                                             
      LET l_omc.omc02 = 1                                                       
      LET l_omc.omc03 = g_oma.oma32                                             
      LET l_omc.omc04 = g_oma.oma11                                             
      LET l_omc.omc05 = g_oma.oma12                                             
      LET l_omc.omc06 = g_oma.oma24                                             
      LET l_omc.omc07 = g_oma.oma60                                             
      LET l_omc.omc08 = g_oma.oma54t                                            
      LET l_omc.omc09 = g_oma.oma56t                                            
      LET l_omc.omc10 = 0                                                       
      LET l_omc.omc11 = 0                                                       
      LET l_omc.omc12 = g_oma.oma10                                             
      LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+g_net                           
      LET l_omc.omc14 = 0                                                       
      LET l_omc.omc15 = 0 
 
      CALL cl_digcut(l_omc.omc08,g_azi04) RETURNING l_omc.omc08                 
      CALL cl_digcut(l_omc.omc09,t_azi04) RETURNING l_omc.omc09                 
      CALL cl_digcut(l_omc.omc13,t_azi04) RETURNING l_omc.omc13                 
                                                                                
      LET l_omc.omclegal = g_legal 
 
      INSERT INTO omc_file VALUES(l_omc.*)                                      
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("ins","omc_file","omc01","omc02",SQLCA.sqlcode,"","",1)   
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF 
   END IF
   SELECT SUM(omc08),SUM(omc09),MAX(omc02) INTO l_omc08,l_omc09,l_omc02         
     FROM omc_file                                                              
    WHERE omc01 = g_oma.oma01                                                   
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err3("sel","omc_file",g_oma.oma01,"",SQLCA.sqlcode,"","",1)       
      LET g_success ='N'                                                        
      RETURN                                                                    
   END IF                                                                       
   IF cl_null(l_omc08) THEN                                                     
      LET l_omc08 = 0                                                           
   END IF                                                                       
   IF cl_null(l_omc09) THEN                                                     
      LET l_omc09 = 0                                                           
   END IF                                                                       
   IF l_omc08 <> g_oma.oma54t THEN                                              
      UPDATE omc_file SET omc08 = omc08-(l_omc08-g_oma.oma54t)                  
       WHERE omc01 = g_oma.oma01                                                
         AND omc02 = l_omc02                                                    
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF
   END IF                                                                       
   IF l_omc09 <> g_oma.oma56t THEN                                              
      UPDATE omc_file SET omc09 = omc09-(l_omc09-g_oma.oma56t)                  
       WHERE omc01 = g_oma.oma01                                                
         AND omc02 = l_omc02                                                    
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
   END IF                                                                       
   SELECT MAX(omc04),MAX(omc05) INTO g_oma.oma11,g_oma.oma12 FROM omc_file      
    WHERE omc01 = g_oma.oma01                                                   
   UPDATE oma_file SET oma11 = g_oma.oma11,                                     
                       oma12 = g_oma.oma12                                      
    WHERE oma01 = g_oma.oma01                                                   
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err3("upd","oma_file",g_oma.oma11,g_oma.oma12,SQLCA.sqlcode,"","",1)
   END IF  
END FUNCTION
   
FUNCTION t302_ins_nme()
#FUN-B30166--add--str--
  DEFINE l_year     LIKE type_file.chr4
  DEFINE l_month    LIKE type_file.chr4
  DEFINE l_day      LIKE type_file.chr4
  DEFINE l_dt       LIKE type_file.chr20
  DEFINE l_date1    LIKE type_file.chr20
  DEFINE l_time     LIKE type_file.chr20
#FUN-B30166--add--end

#FUN-B30166--add--str-zhangweib-
  DEFINE l_nme27  LIKE nme_file.nme27
#FUN-B30166--add--end-zhangweib-
   INITIALIZE g_nme.* TO NULL
   LET g_nme.nme00 = 0
   LET g_nme.nme01 = m_npk.npk04
   LET g_nme.nme02 = g_nmg.nmg01
   LET g_nme.nme03 = m_npk.npk02
   LET g_nme.nme04 = m_npk.npk08
   LET g_nme.nme05 = m_npk.npk10
   LET g_nme.nme06 = m_npk.npk071
   LET g_nme.nme07 = m_npk.npk06
   LET g_nme.nme08 = m_npk.npk09
   LET g_nme.nme12 = g_nmg.nmg00
   LET g_nme.nme13 = g_nmg.nmg19
   LET g_nme.nme14=''
   SELECT nmc05 INTO g_nme.nme14 FROM nmc_file
     WHERE nmc01 = m_npk.npk02
   LET g_nme.nme15 = g_nmg.nmg11
   LET g_nme.nme16 = g_nmg.nmg01
   LET g_nme.nme17 = g_nmg.nmg00
   LET g_nme.nmeacti = 'Y'
   LET g_nme.nmegrup = g_grup
   LET g_nme.nmeuser = g_user
   LET g_nme.nmedate = g_today
   IF g_aza.aza63='Y' THEN
      LET g_nme.nme061 = m_npk.npk073
    END IF
   LET g_nme.nme21 = m_npk.npk01
   LET g_nme.nme22 = '07'
   LET g_nme.nme23 = g_nmg.nmg20
   LET g_nme.nme24 = '9'  #No.TQC-750098
   LET g_nme.nme25 = g_nmg.nmg18  #No.TQC-750098
 
   LET g_nme.nmelegal = g_legal 
 
   LET g_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET g_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-B30166--add--str--
   LET l_date1 = g_today 
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   LET g_nme.nme27 = l_dt
   #FUN-B30166--add--end
   #FUN-B30166--add--str--zhangweib--
   SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file 
    WHERE nme27[1,14] = l_dt
   IF cl_null(g_nme.nme27) THEN
      LET g_nme.nme27 = l_dt,'000001'
   END IF
   #FUN-B30166--add--end--zhangweib--

   INSERT INTO nme_file VALUES(g_nme.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nme02',g_nme.nme02,'t302_ins_nme',SQLCA.sqlcode,1)   #No.FUN-710024
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062     
END FUNCTION
 
FUNCTION t302_out()
DEFINE l_wc   STRING                             #MOD-960319 add
 
   IF g_nmg.nmg00 IS NULL THEN RETURN END IF
   MENU ""
      ON ACTION brief_report_print
         CALL t302_out1()
 
      ON ACTION IE_Document_print
         LET l_wc = 'nmg00 = "',g_nmg.nmg00,'" '  #MOD-960319
        #LET g_msg =  "anmr302 '",g_today CLIPPED,"' '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"' '3'" CLIPPED   #MOD-710170  #MOD-960319   #FUN-C30085
         #FUN-D10098--add--str--
         IF g_aza.aza26 = '2' THEN
            LET g_msg =  "gnmg302 '",g_today CLIPPED,"' '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"' '3'" CLIPPED
         ELSE
         #FUN-D10098--add--end--
            LET g_msg =  "anmg302 '",g_today CLIPPED,"' '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"' '3'" CLIPPED   #MOD-710170  #MOD-960319   #FUN-C30085 
         END IF   #FUN-D10098 add
         CALL cl_cmdrun(g_msg)
      ON ACTION exit
         EXIT MENU
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
END FUNCTION
 
FUNCTION t302_out1()
   DEFINE l_i     LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          l_name  LIKE type_file.chr20,      # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_nmg   RECORD LIKE nmg_file.*,    
          l_npk   RECORD LIKE npk_file.*,    
          l_za05  LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(40)
          l_chr   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
          l_cmd   LIKE type_file.chr1000,    #No.FUN-7C0043 
          l_wc    STRING,                    #MOD-960319 add
          l_wc1   STRING                     #MOD-960319 add
 
    LET l_wc  = g_wc    #MOD-960319 add
    LET l_wc1 = g_wc1   #MOD-960319 add
    IF cl_null(g_wc) AND NOT cl_null(g_nmg.nmg00) THEN                                                                              
       LET g_wc=" nmg00='",g_nmg.nmg00,"'"                                                                                          
    END IF                                                                                                                          
    IF cl_null(g_wc) THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF cl_null(g_wc1) THEN                                                                                                          
       LET g_wc1=" 1=1 "                                                                                                            
    END IF                                                                                                                          
    LET l_cmd = 'p_query "anmt302" "',g_wc CLIPPED,'" "',g_wc1,'"'                                                                  
    CALL cl_cmdrun(l_cmd)                                                                                                           
    LET g_wc  = l_wc    #MOD-960319 add
    LET g_wc1 = l_wc1   #MOD-960319 add
    RETURN
END FUNCTION
 
FUNCTION t302_c()
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_nmg.nmg00) THEN
      CALL cl_err('',-400,2)
      RETURN
   END IF
   SELECT * INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_nmg.nmg00
   IF g_nmg.nmgconf='X' THEN
      CALL cl_err(g_nmg.nmg00,'9024',0)
      RETURN
   END IF
   IF NOT cl_null(g_nmg.nmg13) THEN
      CALL cl_err(g_nmg.nmg00,'anm-230',1)
      RETURN
   END IF
  #FUN-B30049--begin--
  #IF g_nmg.nmg24 > 0 THEN
  #   CALL cl_err('','anm-800',1)
  #   RETURN
  #END IF
  #FUN-B30049---end---
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t302_cl USING g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err("OPEN t302_cl:", STATUS, 1)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t302_cl INTO g_nmg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
      CLOSE t302_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nmg_o.* = g_nmg.*
   LET g_nmg_t.* = g_nmg.*
   LET g_nmg.nmgmodu=g_user                     #修改者  no:6185
   LET g_nmg.nmgdate = g_today                  #修改日期
   CALL t302_show()
   IF g_success = 'N' THEN
      LET g_nmg.* = g_nmg_t.*
      CALL t302_show()
      ROLLBACK WORK
      RETURN
   END IF
   CALL t302_i2()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_nmg.* = g_nmg_t.*
      CALL t302_show()
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE nmg_file SET nmg18 = g_nmg.nmg18,
                       nmg19 = g_nmg.nmg19
    WHERE nmg00 = g_nmg_t.nmg00
   IF STATUS THEN
      CALL cl_err3("upd","nmg_file",g_nmg_t.nmg00,"",STATUS,"","up nmg",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   UPDATE nme_file SET nme13 = g_nmg.nmg19
     WHERE nme12 = g_nmg.nmg00 AND nme17 = g_nmg.nmg00
   IF STATUS THEN
      CALL cl_err3("upd","nme_file",g_nmg.nmg00,"",STATUS,"","up nme",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
  #-------------------------MOD-CC0193-------------------(S)
   UPDATE npq_file
      SET npq21 = g_nmg.nmg18,
          npq22 = g_nmg.nmg19
     WHERE npqsys = 'NM'
       AND npq00 = 3
       AND npq01 = g_nmg.nmg00
       AND npq011 = 1
       AND npq21 IS NOT NULL
   IF STATUS THEN
      CALL cl_err3("upd","npq_file",g_nmg.nmg00,"",STATUS,"","up npq",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
  #-------------------------MOD-CC0193-------------------(E)
   CLOSE t302_cl   #MOD-D60105
   CALL t302_show()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t302_i2()
DEFINE l_n  LIKE type_file.num5    #No.FUN-B30049
   INPUT BY NAME g_nmg.nmg18,g_nmg.nmg19 WITHOUT DEFAULTS
 
      AFTER FIELD nmg18
        #FUN-B30049--begin--
         SELECT count(*) INTO l_n FROM oob_file
        #WHERE oob03 = '1' AND oob04 = '3' AND oob06 = g_nmg.nmg00  #MOD-C70038 mark
         WHERE oob03 = '1'                                          #MOD-C70038 add
           AND oob04 = '2'                                          #MOD-C70038 add
           AND oob06 = g_nmg.nmg00                                  #MOD-C70038 add
         IF l_n > 0 THEN
            CALL cl_err('','anm1035',-1)
            LET g_nmg.nmg18 = g_nmg_t.nmg18
            DISPLAY BY NAME g_nmg.nmg18
            NEXT FIELD nmg18
          END IF
        #FUN-B30049---end---

         IF g_nmg.nmg20[1,1] MATCHES "[12]" AND cl_null(g_nmg.nmg18) THEN
            CALL cl_err('nmg20=1/2:','axm-117',0)
            NEXT FIELD nmg20
         END IF
         IF g_nmg.nmg20[1,1] = '1' AND g_nmg.nmg18 != 'MISC' THEN
            SELECT pmc03 INTO g_nmg.nmg19 FROM pmc_file
             WHERE pmc01=g_nmg.nmg18 AND pmcacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","pmc_file",g_nmg.nmg18,"",STATUS,"","sel pmc",1)  #No.FUN-660148
               NEXT FIELD nmg18
            END IF
            DISPLAY BY NAME g_nmg.nmg19
         END IF
         IF g_nmg.nmg20[1,1] = '2' AND g_nmg.nmg18 != 'MISC' THEN
            SELECT occ02 INTO g_nmg.nmg19 FROM occ_file
                   WHERE occ01=g_nmg.nmg18 AND occacti IN ('Y','y')
               AND (occ06 = '1' OR occ06 = '3')                      #MOD-CC0027 add
            IF STATUS THEN
               CALL cl_err3("sel","occ_file",g_nmg.nmg18,"",STATUS,"","sel occ",1)  #No.FUN-660148
               NEXT FIELD nmg18
            END IF DISPLAY BY NAME g_nmg.nmg19
         END IF
        #FUN-B30049--begin--
        #TQC-C70136--add--str--    
        SELECT COUNT(*) INTO l_n FROM oma_file
         WHERE oma00 = '24' AND oma16 = g_nmg.nmg00
        IF l_n > 0 THEN 
        #TQC-C70136--add--end--
           IF g_nmg.nmg18 != g_nmg_t.nmg18 THEN    #如果舊值與新值不同,就更新oma_f
              UPDATE oma_file
              SET oma03 = g_nmg.nmg18,oma04 = g_nmg.nmg18,oma68 = g_nmg.nmg18
                 ,oma032 = g_nmg.nmg19 ,oma69 = g_nmg.nmg19
              WHERE oma00 = '24' AND oma16 = g_nmg.nmg00
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("upd","oma_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","upd nmg",1)
                  LET g_success = 'N'
              END IF
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
        END IF     #TQC-C70136 add
        #FUN-B30049---end---

      BEFORE FIELD nmg19
         IF g_nmg.nmg18 != 'MISC' THEN
# gneo  script marked               IF cl_ku() THEN NEXT FIELD nmg18 ELSE EXIT INPUT END IF
         END IF
     #TQC-D40062--add--str---
         IF g_nmg.nmg18 = 'MISC' THEN
            CALL cl_set_comp_entry("nmg19",TRUE)
         ELSE
            CALL cl_set_comp_entry("nmg19",FALSE)
         END IF

      AFTER FIELD nmg19
         CALL cl_set_comp_entry("nmg19",TRUE)
     #TQC-D40062--add--end---

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nmg18)
               IF g_nmg.nmg20[1,1] = '1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc"
                  LET g_qryparam.default1 = g_nmg.nmg18
                  CALL cl_create_qry() RETURNING g_nmg.nmg18
                  DISPLAY BY NAME g_nmg.nmg18 NEXT FIELD nmg18
               END IF
               #IF g_nmg.nmg20[1,1] = '2' THEN   #MOD-C80101
               IF g_nmg.nmg20 = '22' THEN        #MOD-C80101
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.default1 = g_nmg.nmg18
                  CALL cl_create_qry() RETURNING g_nmg.nmg18
                  DISPLAY BY NAME g_nmg.nmg18 NEXT FIELD nmg18
               END IF
               #No.MOD-C80101  --Begin
               IF g_nmg.nmg20 = '21' THEN
                  CALL q_occ_pmc(FALSE,TRUE,g_plant) RETURNING g_nmg.nmg18,g_nmg.nmg19
                  DISPLAY BY NAME g_nmg.nmg18
                  DISPLAY BY NAME g_nmg.nmg19
                  NEXT FIELD nmg18
               END IF
               #No.MOD-C80101  --End
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
END FUNCTION
 
FUNCTION t302_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nmg00",TRUE)
    END IF
    IF INFIELD(nmg20) OR  NOT g_before_input_done  THEN
       CALL cl_set_comp_entry("nmg30",TRUE)
       CALL cl_set_comp_entry("nmg301",TRUE)               #No.FUN-680034
    END IF
END FUNCTION
 
FUNCTION t302_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nmg00",FALSE)
    END IF
 
    IF INFIELD(nmg20) THEN
       IF g_nmg.nmg29='N' THEN
          CALL cl_set_comp_entry("nmg30",FALSE)
          CALL cl_set_comp_entry("nmg301",FALSE)            #No.FUN-680034 
       END IF
    END IF
END FUNCTION
 
FUNCTION t302_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF INFIELD(npk03) OR NOT g_before_input_done THEN #MOD-4A0350
       IF g_npk[l_ac].npk03 MATCHES '[12]' THEN #MOD-AC0293 add
          CALL cl_set_comp_entry("npk02,npk04",TRUE)     #MOD-4A0350
       END IF #MOD-AC0293 add
    END IF
    CALL cl_set_comp_entry("npk05",TRUE)   #MOD-5B0217
END FUNCTION
 
FUNCTION t302_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF INFIELD(npk03) OR NOT g_before_input_done THEN
       IF g_npk[l_ac].npk03 MATCHES '[34]' THEN
           CALL cl_set_comp_entry("npk02,npk04",FALSE) #MOD-4A0350
       END IF
    END IF
    IF INFIELD(npk04) OR INFIELD(npk05) THEN
       IF NOT cl_null(g_npk[l_ac].npk04) THEN
          CALL cl_set_comp_entry("npk05",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t302_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
  IF g_nmg.nmg29='Y' THEN
     CALL cl_set_comp_required("nmg30",TRUE)
     IF g_aza.aza63='Y' THEN 
        CALL cl_set_comp_required("nmg301",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION t302_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
  IF NOT g_before_input_done THEN
     CALL cl_set_comp_required("nmg30",FALSE)
     IF g_aza.aza63='Y' THEN 
        CALL cl_set_comp_required("nmg301",FALSE)
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t302_gen_glcr(p_nmg,p_nmy)
  DEFINE p_nmg     RECORD LIKE nmg_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL s_errmsg('','',p_nmg.nmg00,'axr-070',1)  #No.FUN-710024
       LET g_success = 'N'
       RETURN
    END IF       
         CALL s_t302_gl(p_nmg.nmg00,'0')                  #產生第一分錄                                                             
         IF g_aza.aza63='Y' AND g_success='Y' THEN                                                                                  
            CALL s_t302_gl(p_nmg.nmg00,'1')               #產生第二分錄                                                             
         END IF                                                                                                                     
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t302_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1 #No.FUN-680034
  DEFINE li_result    LIKE type_file.num5    #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nmg.nmg13) OR g_nmg.nmg13 IS NOT NULL THEN  
       CALL cl_err(g_nmg.nmg13,'aap-618',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nmg.nmg00) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       LET l_nmygslp1= g_nmy.nmygslp1     #No.FUN-680034
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_nmg.nmg13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102	
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_nmg.nmg13,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
 
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_nmg.nmg00,'axr-070',1)
       RETURN
    END IF
    IF cl_null(l_nmygslp1) AND g_aza.aza63 = 'Y' THEN
       CALL cl_err(g_nmg.nmg01,'axr-070',1)
       RETURN
    END IF

#   LET g_wc_gl = 'npp01 = "',g_nmg.nmg00,'" AND npp011 = 1'                #TQC-A70115 Mark
    LET g_wc_gl = " npp01='",g_nmg.nmg00,"'"                                #TQC-A70115 Add
    LET g_wc_gl = g_wc_gl clipped," AND npp011 = 1 "                        #TQC-A70115 Add
#   LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",  #TQC-860005
#   LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'zzzzzzzzzz' '",g_nmz.nmz02p,"' ",  #TQC-860005                         #TQC-A70115 Mark
#                      " '",g_nmz.nmz02b,"' '",l_nmygslp,"' ",                                #No.FUN-680034
                      #" '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_nmg.nmg01,"' 'Y' '0' 'Y'"   #No.FUN-680034 #FUN-860040 #TQC-A70115 Mark
#                      " '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_nmg.nmg01,"' 'Y' '1' 'Y'"   #No.FUN-680034 #FUN-860040 #TQC-A70115 Mark

    #TQC-A70115--Add--Begin 
      LET g_str = "anmp400" ,
                  ' "',g_wc_gl CLIPPED,'"',
                  ' "0" ',
                  ' "zzzzzzzzzz" ',
                  ' "',g_nmz.nmz02p,'"',   
                  ' "',g_nmz.nmz02b,'"',   
                  ' "',l_nmygslp,'" ',
                  ' "',g_nmz.nmz02c,'" ',
                  ' "',l_nmygslp1,'" ',
                  ' "',g_nmg.nmg01,'" ',
                  ' "Y" ',
                  ' "1" ',
                  ' "Y" '
    #TQC-A70115--Add--End

    CALL cl_cmdrun_wait(g_str)
    SELECT nmg13,nmg14 INTO g_nmg.nmg13,g_nmg.nmg14 FROM nmg_file
     WHERE nmg00 = g_nmg.nmg00
    DISPLAY BY NAME g_nmg.nmg13
    DISPLAY BY NAME g_nmg.nmg14
    
END FUNCTION
 
FUNCTION t302_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF cl_null(g_nmg.nmg13) OR g_nmg.nmg13 IS NULL THEN
       CALL cl_err(g_nmg.nmg13,'aap-619',1)
       RETURN
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nmg.nmg00) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036 
       RETURN
    END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nmg.nmg13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nmg.nmg13,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmg.nmg13,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nmg13,nmg14 INTO g_nmg.nmg13,g_nmg.nmg14 FROM nmg_file
     WHERE nmg00 = g_nmg.nmg00
    DISPLAY BY NAME g_nmg.nmg13
    DISPLAY BY NAME g_nmg.nmg14
END FUNCTION
 
#自動產生分錄底稿
FUNCTION t302_gen_g()
DEFINE   l_nmyslip       LIKE nmy_file.nmyslip
DEFINE   l_nmydmy3       LIKE nmy_file.nmydmy3
DEFINE   l_doc_no        LIKE nmy_file.nmyslip
 
    LET l_doc_no = s_get_doc_no(g_nmg.nmg00)    
    SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_doc_no
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("sel","nmy_file","","",SQLCA.sqlcode,"","sel nmy:",1)
       RETURN
    END IF
    IF l_nmydmy3 = 'Y' THEN 
       CALL s_t302_gl(g_nmg.nmg00,'0') 
       IF g_aza.aza63='Y' THEN
          CALL s_t302_gl(g_nmg.nmg00,'1') 
       END IF
    END IF 
     
END FUNCTION
 
#差異處理
FUNCTION t302_diff()
   DEFINE l_amt13     LIKE npk_file.npk09  #異動別為1.存入+3 借方科目的本幣金額 
   DEFINE l_amt24     LIKE npk_file.npk09  #異動別為2.提出+4 貸方科目的本幣金額
   DEFINE l_t1         LIKE nmy_file.nmyslip     #MOD-B70096     
   DEFINE l_nmydmy3    LIKE nmy_file.nmydmy3     #MOD-B70096     
  
   #MOD-B70096 Add Begin-----------------------------------------
   LET l_t1 = s_get_doc_no(g_nmg.nmg00)
   LET l_nmydmy3 = ''
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nmyslip',l_t1,'sel nmy:',STATUS,0)
   END IF
   IF l_nmydmy3 = 'N' THEN
      RETURN
   END IF
   #MOD-B70096 Add End-------------------------------------------   

  #No.FUN-C90127   ---start--- Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      RETURN
   END IF
  #No.FUN-C90127   ---end  --- Add

   LET l_amt13 = 0
   SELECT SUM(npk09) INTO l_amt13 FROM npk_file
    WHERE npk00 = g_nmg.nmg00
      AND npk03 IN ('1','3')
      AND npk071 IS NULL 
   IF l_amt13 IS NULL THEN LET l_amt13 = 0 END IF
   LET l_amt24 = 0
   SELECT SUM(npk09) INTO l_amt24 FROM npk_file
    WHERE npk00 = g_nmg.nmg00
      AND npk03 IN ('2','4')
      AND npk071 IS NULL 
   IF l_amt24 IS NULL THEN LET l_amt24 = 0 END IF
   IF l_amt13 = l_amt24 THEN
      RETURN
   END IF
   #差異處理INPUT 
   OPEN WINDOW t302_1_w AT 10,27 WITH FORM "anm/42f/anmt302_1"
               ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("anmt302_1")
   LET diff_flag = '1'
   INPUT BY NAME diff_flag WITHOUT DEFAULTS
      AFTER FIELD diff_flag
         IF diff_flag NOT MATCHES "[10E]" THEN
            NEXT FIELD diff_flag
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET diff_flag = '0'
   END IF
   CLOSE WINDOW t302_1_w
   CASE diff_flag
        WHEN '0'  #繼續輸入或調整
             CALL t302_b()
        WHEN '1'  #差異視為匯兌損益
             CALL t302_diff_1(l_amt13,l_amt24)
             CALL t302_b_fill("1=1")
   END CASE
END FUNCTION
 
#差異處理:差異視為匯兌損益
FUNCTION t302_diff_1(p_amt13,p_amt24)
   DEFINE p_amt13     LIKE npk_file.npk09  #更改別為1存入+3借方科目的本幣金額
   DEFINE p_amt24     LIKE npk_file.npk09  #更改別為2提出+4貸方科目的本幣金額
   DEFINE l_npk       RECORD LIKE npk_file.*
 
   BEGIN WORK
   LET g_success = 'Y'
   WHILE TRUE
      OPEN t302_cl USING g_nmg.nmg00
      IF SQLCA.SQLCODE THEN
         CALL cl_err("OPEN t302_cl:", STATUS, 1)
         LET g_success = 'N'
         EXIT WHILE
      END IF
      FETCH t302_cl INTO g_nmg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_nmg.nmg00,SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT WHILE
      END IF
      IF g_nmz.nmz11 = 'Y' THEN
         LET g_dept = g_nmg.nmg11
      ELSE
         LET g_dept = ' '
      END IF
      SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
 
      INITIALIZE l_npk.* TO NULL
      LET l_npk.npk00 = g_nmg.nmg00
      SELECT MAX(npk01)+1 INTO l_npk.npk01 FROM npk_file
       WHERE npk00 = g_nmg.nmg00
      IF l_npk.npk01 IS NULL THEN LET l_npk.npk01 = 1 END IF
      LET l_npk.npk05 = g_aza.aza17
      CALL s_curr3(l_npk.npk05,g_nmg.nmg01,'B') RETURNING l_npk.npk06
      IF p_amt13 > p_amt24 THEN  #更改別1存入+3借方科目> 2提出+4貸方科目
         LET l_npk.npk03 = '4'
         LET l_npk.npk07 = g_nms.nms12
         LET l_npk.npk08 = p_amt13 - p_amt24
      ELSE                       #更改別1存入+3借方科目< 2提出+4貸方科目
         LET l_npk.npk03 = '3'
         LET l_npk.npk07 = g_nms.nms13
         LET l_npk.npk08 = p_amt24 - p_amt13
      END IF
      LET l_npk.npk09 = l_npk.npk08
 
      LET l_npk.npklegal = g_legal 
 
      INSERT INTO npk_file VALUES(l_npk.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("ins","npk_file",l_npk.npk00,l_npk.npk01,SQLCA.sqlcode,"","ins npk",1)
         LET g_success = 'N'
         EXIT WHILE
      END IF
      CALL t302_bu()
      LET g_nmg.nmgmodu = g_user
      LET g_nmg.nmgdate = g_today
      UPDATE nmg_file SET nmgmodu = g_nmg.nmgmodu,
                          nmgdate = g_nmg.nmgdate
       WHERE nmg00 = g_nmg.nmg00
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","nmg_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","upd nmg",1)
         LET g_success = 'N'
         EXIT WHILE
      END IF
      EXIT WHILE
   END WHILE
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_nmg.nmgmodu,g_nmg.nmgdate
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE t302_cl
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#No.FUN-A30106 --begin                                                          
FUNCTION t302_drill_down()                                                      
                                                                                
   IF cl_null(g_nmg.nmg13) THEN RETURN END IF                                   
   LET g_msg = "aglt110 '",g_nmg.nmg13,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    
#No.FUN-A30106 --end 

#--FUN-BC0044 start--
FUNCTION t302_copy()
   DEFINE l_oldno   LIKE nmg_file.nmg00,
          l_newno   LIKE nmg_file.nmg00,
          l_newdate LIKE nmg_file.nmg01
   DEFINE li_result LIKE type_file.num5
   DEFINE l_nma21   LIKE nma_file.nma21
   DEFINE l_nmy     RECORD LIKE nmy_file.*
   DEFINE l_nmg29   LIKE nmg_file.nmg29


   IF s_anmshut(0) THEN RETURN END IF

   IF g_nmg.nmg00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")

   LET l_newdate = g_today
   INPUT l_newno,l_newdate WITHOUT DEFAULTS FROM nmg00,nmg01

   BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL t302_set_entry('a')
       CALL t302_set_no_entry('a')
       CALL cl_set_docno_format("nmg00")
       LET g_before_input_done = TRUE
       DISPLAY '' TO nmg13  #yinhy130619

   AFTER FIELD nmg00
       IF NOT cl_null(l_newno) THEN
          CALL s_check_no("anm",l_newno,g_nmg_t.nmg00,"3",""," ","")
          RETURNING li_result,l_newno
          DISPLAY l_newno TO nmg00
          IF (NOT li_result) THEN
             NEXT FIELD nmg00
          END IF
       END IF

   AFTER FIELD nmg01
       IF NOT cl_null(l_newdate) THEN
          IF l_newdate <= g_nmz.nmz10 THEN
             CALL cl_err('','aap-176',1) NEXT FIELD nmg01
          END IF
          SELECT * INTO l_nmy.* FROM nmy_file WHERE nmyslip=g_t1
          IF l_nmy.nmydmy3 = 'Y' THEN
             CALL s_get_bookno(YEAR(l_newno)) RETURNING g_flag,g_bookno1,g_bookno2
             SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno1
             IF l_newdate <= l_aaa07 THEN
                CALL cl_err('','aap-176',1)
                NEXT FIELD nmg01
             END IF
             IF g_aza.aza63 = 'Y' THEN
                SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = g_bookno2
                IF l_newdate <= l_aaa07 THEN
                   CALL cl_err('','aap-176',1)
                   NEXT FIELD nmg01
                END IF
             END IF
          END IF
          DECLARE t302_copy_date CURSOR FOR              # LOCK CURSOR
              SELECT nma21 FROM nma_file,npk_file
               WHERE nma01 = npk04 AND npk00 = l_newno
          FOREACH t302_copy_date INTO l_nma21
             IF SQLCA.sqlcode THEN
                CALL cl_err('sel t302_copy_date',SQLCA.sqlcode,0)
                EXIT FOREACH
             END IF
             IF l_newdate <= l_nma21 THEN
                CALL cl_err(l_newdate,'anm-077',0)
                NEXT FIELD nmg01
             END IF
          END FOREACH
          IF (g_nmg.nmg20 = '21' OR g_nmg.nmg20 ='22') AND l_nmy.nmydmy3='Y' THEN
             LET l_nmg29='Y'
          ELSE
             LET l_nmg29='N'
          END IF
       END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nmg00)
               LET g_t1 = s_get_doc_no(l_newno)
               CALL q_nmy(FALSE,FALSE,g_t1,'3','ANM') RETURNING g_t1
               LET l_newno = g_t1
               DISPLAY l_newno TO nmg00
               NEXT FIELD nmg00
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END INPUT

   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      CALL t302_show()
      RETURN
   END IF

   BEGIN WORK
     CALL s_auto_assign_no("anm",l_newno,l_newdate,"3","nmg_file","nmg00","","","")
     RETURNING li_result,l_newno
     IF (NOT li_result) THEN
        CALL cl_err('','apm-920',0)
     END IF
     DISPLAY l_newno TO nmg00

   DROP TABLE y

   SELECT * FROM nmg_file WHERE nmg00 = g_nmg.nmg00 INTO TEMP y

   UPDATE y SET nmg00 = l_newno,
                nmg01 = l_newdate,
                nmg21 = '',
                nmgconf = 'N',
                nmg13 = '',
                nmg14 = '',
                nmg29 = l_nmg29,
                nmgacti ='Y',
                nmguser = g_user,
                nmgoriu = g_user,
                nmgorig = g_grup,
                nmggrup = g_grup,
                nmgdate = g_today,
                nmgmodu = NULL,     #資料修改日期
                nmg03 = '',
                nmg04 = 0,
                nmg24 = 0,
                nmg07 = '',
                nmg08 = '',
                nmg09 = 0

   INSERT INTO nmg_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","nmg_file",l_newno,"",SQLCA.sqlcode,"","",1)
     ROLLBACK WORK
     RETURN
   ELSE
     COMMIT WORK
   END IF

   DROP TABLE x
   SELECT * FROM npk_file         #單身複製
    WHERE npk00=g_nmg.nmg00
    INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","npk_file",g_nmg.nmg00,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET npk00 = l_newno
   INSERT INTO npk_file
          SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","npk_file",l_newno,"",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

    LET l_oldno = g_nmg.nmg00
    #SELECT nmg_file.* INTO g_nmg.* FROM nmg_file
    # WHERE nmg00 = l_newno
    #CALL t302_u()
    SELECT nmg_file.* INTO g_nmg.* FROM nmg_file
     WHERE nmg01 = l_oldno
    CALL t302_show()
    DISPLAY BY NAME g_nmg.nmg00
END FUNCTION
#--FUN-BC0044 end---

#No.FUN-CB0080 ---start--- Add
FUNCTION t302_b_menu()
   DEFINE l_priv1    LIKE zy_file.zy03,           # 使用者執行權限
          l_priv2    LIKE zy_file.zy04,           # 使用者資料權限
          l_priv3    LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE l_cmd      LIKE type_file.chr1000
   DEFINE l_flowuser LIKE type_file.chr1
   DEFINE l_creator  LIKE type_file.chr1

   LET l_flowuser = "N"

   WHILE TRUE
      CALL t302_bp_1("G")

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT nmg_file.*
           INTO g_nmg.*
           FROM nmg_file
          WHERE nmg00 = g_nmg_1[l_ac1].nmg00
      END IF
      IF cl_null(g_action_choice) THEN
         CALL cl_set_act_visible("accept,cancel", FALSE)
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t302_fetch('/')
         END IF
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t302_a()
            END IF
            
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t302_q()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t302_r()
               CALL t302_show()  
            END IF
            
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t302_u()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t302_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t302_out()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "modify_customer_no_vender_n"
            IF cl_chk_act_auth() THEN
               CALL t302_c()
            END IF
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()    
               CALL t302_firm1()
               CALL t302_b_fill_1()     
               CALL s_showmsg()         
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
            
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t302_firm2()
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()    
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
            
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t302_x()                    #FUN-D20035
               CALL t302_x(1)                   #FUN-D20035
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()   
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
            

         #FUN-D20035----add---str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t302_x(2)              
               IF g_nmg.nmgconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL t302_b_fill_1()
               CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")
            END IF
         #FUN-D20035----add---end
         WHEN "qry_transaction"
            LET l_cmd = "anmt300 '",g_nmg.nmg00,"'"
            CALL cl_cmdrun_wait(l_cmd CLIPPED) 
            
         WHEN "query_suspense_credit"
            IF g_nmg.nmg20 MATCHES '2[1-2]' AND g_nmg.nmg29='Y' THEN
               LET l_cmd = "axrt300 '",g_nmg.nmg00,"' '' '24' "   
               CALL cl_cmdrun_wait(l_cmd CLIPPED)
            END IF
            
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               CALL t302_v(1)
            END IF
            
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               #系統別、類別、單號、票面金額
               CALL s_fsgl('NM',3,g_nmg.nmg00,0,g_nmz.nmz02b,1,g_nmg.nmgconf,'0',g_nmz.nmz02p)
               CALL t302_npp02('0')
            END IF

         WHEN "entry_sheet1"
            IF cl_chk_act_auth() THEN
               #系統別、類別、單號、票面金額
               CALL s_fsgl('NM',3,g_nmg.nmg00,0,g_nmz.nmz02c,1,g_nmg.nmgconf,'1',g_nmz.nmz02p)
               CALL t302_npp02('1')
            END IF

         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmgconf = 'Y' THEN
                  CALL t302_carry_voucher()
               ELSE
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
            
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmgconf = 'Y' THEN
                  CALL t302_undo_carry_voucher()
               ELSE
                  CALL cl_err('','atm-403',1)
               END IF
            END IF

         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npk),'','')
            END IF

         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_nmg.nmg00 IS NOT NULL THEN
                 LET g_doc.column1 = "nmg00"
                 LET g_doc.value1 = g_nmg.nmg00
                 CALL cl_doc()
               END IF
           END IF

         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL t302_drill_down()
            END IF

         OTHERWISE 
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION t302_bp_1(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmg_1 TO s_nmg.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t302_fetch('/')
         END IF
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL t302_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
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
         CALL t302_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL DIALOG.setCurrentRow("s_oob",1)
         END IF
         CONTINUE DISPLAY

      ON ACTION previous
         CALL t302_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL DIALOG.setCurrentRow("s_oob",1)
         END IF
	 CONTINUE DISPLAY

      ON ACTION jump
         CALL t302_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL DIALOG.setCurrentRow("s_oob",1)
         END IF
	 CONTINUE DISPLAY

      ON ACTION next
         CALL t302_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL DIALOG.setCurrentRow("s_oob",1)
         END IF
   	 CONTINUE DISPLAY

      ON ACTION last
         CALL t302_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL DIALOG.setCurrentRow("s_oob",1)
         END IF
	 CONTINUE DISPLAY

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
          CALL cl_show_fld_cont()        
         IF g_nmg.nmgconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nmg.nmgconf,"","","",g_void,"")

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION modify_customer_no_vender_n #客戶/廠商代號修改
         LET g_action_choice="modify_customer_no_vender_n"
         EXIT DISPLAY

      ON ACTION confirm      #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY


      ON ACTION undo_confirm    #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      ON ACTION qry_transaction      #異動查詢
         LET g_action_choice="qry_transaction"
         EXIT DISPLAY

      ON ACTION query_suspense_credit    #暫收款查詢
         LET g_action_choice="query_suspense_credit"
         EXIT DISPLAY

      ON ACTION gen_entry  #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY

      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY

      ON ACTION entry_sheet1 #分錄底稿二
         LET g_action_choice="entry_sheet1"
         EXIT DISPLAY

      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY

      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about     
         CALL cl_about()   

      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION drill_down
         LET g_action_choice="drill_down"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t302_b_fill_1()
  DEFINE l_i             LIKE type_file.num10

    CALL g_nmg_1.clear()
    LET l_i = 1
    FOREACH anmt302_list_cur INTO g_nmg_1[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT aag02 INTO g_nmg_1[l_i].aag02 FROM aag_file
        WHERE aag01 = g_nmg_1[l_i].nmg30
       LET l_i = l_i + 1
    END FOREACH
    CALL g_nmg_1.deleteElement(l_i)   #取消 Array Element
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_nmg_1 TO s_nmg.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION
#No.FUN-CB0080 ---end  --- Add
