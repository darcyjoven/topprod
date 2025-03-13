# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gglt110.4gl.4gl
# Descriptions...: 一般傳票維護作業
# Date & Author..: 92/02/25 BY MAY
# Modify.........: 92/09/23 By Pin 加二欄位(簽核處理修正)--->s_signm()
# Modify.........: 96/05/07 By Melody(傳票複製改為先輸入日期再輸入單別)
# Modify.........: 96/06/24 By Thomas (check 傳票單別時,未區分帳別aac00)
# Modify.........: 96/07/01 By Melody    aac00 改為 no-use
#                  By Melody   aab_file->gem_file
#                  By Melody   q_aac、q_aee 改為不區分帳別
#                  By Melody   單別性質不為現收/支時,收支科目欄位略過
#                  By Melody   過帳後可更改傳票摘要,修改單身應update modu、date
#                  By Melody   1.異動碼加入 ^Y call agli109
#                              2.過帳後摘要修改按上下鍵有誤
# Modify.........: 97/04/16 By Melody aaa07 改為關帳日期
# Modify.........: 97/05/28 By Melody 1.總號輸入時, check 不可重複
#                                     2.傳票日期輸入改為不 check 現行年月
# Modify.........: 97/08/07 By Melody 來源碼非總帳者, 不可作廢
# Modify.........: 99/04/16 By Carol:t110_z1()加簽核處理
#                                    t110_a()加 CALL signm_count(g_aba.abasign)
# Modify.........: No.7767 03/08/12 By Kammy 原幣不應 update 本幣金額
#                          請注意：1.若主畫面修改本幣金額時，目前原幣處理方式
#                                    並不會由本幣回算原幣，請 user 自己到副畫面
#                                    調整原幣
#                                  2.若是現收、現支傳票所產生項次為 0的那筆資料
#                                    幣別自動default 總帳幣別，原幣=本幣。
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480582 04/08/31 By Nicola 傳票日期預設系統日期
# Modify.........: No.MOD-480457 04/09/15 By Nicola 單身要做預算欄位控制
# Modify.........: No.MOD-440244 04/09/16 By Nicola 部門編號開窗剔除非會計部門
# Modify.........: No.MOD-490312 04/09/16 By Nicola 單身要做部門及專案欄位控制
# Modify.........: No.MOD-490325 04/09/17 By Nicola 異動碼控管錯誤
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490429 04/09/24 By Yuna 將查詢時在傳票號碼開窗的功能拿掉
# Modify.........: No.MOD-4A0027 04/10/04 By Smapmin 輸入完後,系統詢問後是否列印報表,選確認,但是並無列印
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0052 04/10/07 By Nicola 傳票單別性質為現收/現支時,單頭的科目請檢查要為貨幣性科目且不為統制帳戶且不為結轉科目
# Modify.........: No.MOD-4A0085 04/10/07 By Nicola aglt130及aglt170也要做異動碼管制
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4B0072 04/11/26 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-510111 05/01/17 By Kitty 查詢時按開窗再按放棄會down出來
# Modify.........: No.MOD-510168 05/01/28 By Kitty 現收傳票若是現收/現支傳票,請控制收支科目不可空白
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-530015 05/03/15 By Nicola 匯率自由格式設定
# Modify.........: No.MOD-510056 05/03/23 By Nicola 用變數存尾差會太大
# Modify.........: No.MOD-530279 05/03/25 By Smapmin 單身金額取位不對,應該不能call cl_numfor要call cl_digcut
# Modify.........: No.MOD-530419 05/03/26 By saki 預算欄位開起不正確
# Modify.........: No.MOD-530634 05/03/26 BY ice 在列印憑証時，判斷大陸版功能CALL gglr304
# Modify.........: No.MOD-530867 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-540061 05/04/07 by Echo 利用取消確認功能權限,可開放還還原單據之簽核狀況,申請調整後重新送簽.
#                                                 簽核圖示修改、相關文件上傳修改.
# Modify.........: No.MOD-4A0299 05/04/18 by Echo 複製功能，無判斷單別是否簽核，狀態碼修改為combobox。
#                                                 將確認與簽核流程拆開獨立。
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-550022 05/05/12 by ching fix摘要複製問題
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560014 05/06/06 by wujie 單據編號修改
# Modify.........: No.MOD-560100 05/06/29 By Nicola 傳遞參數錯誤
# Modify.........: No.MOD-560256 05/07/07 By Nicola (A18)科目設定應輸入異動碼,且要檢查,但卻可以不輸入
# Modify.........: No.FUN-570024 05/07/29 By Elva 新增審計調整內容
# Modify.........: No.MOD-580070 05/08/11 By Smapmin 組成l_cmd的字串錯誤
# Modify.........: No.FUN-580152 05/08/25 By Dido 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: NO.MOD-560281 05/09/10 By Yiting 傳票維護的複制功能,執行後會產生金額變負數
# Modify.........: No.MOD-590286 05/09/22 By Smapmin 顯示無效圖示.確認功能之調整.
#                                                    單身輸入完會開出s_ef_log_w, 按放棄後會直接down出程式
# Modify.........: No.MOD-5A0055 05/10/04 By Dido 不做部門管理時無須做部門檢核
# Modify.........: No.FUN-5A0100 05/10/20 By Smapmin WHERE條件有誤
# Modify.........: No.MOD-5A0387 05/10/27 By Smapmin 傳票編號開窗
# Modify.........: No.MOD-5A0427 05/10/27 By Smapmin 審計調整作業時異動碼欄位根據科目編號設定控制是否可輸入
# Modify.........: No.MOD-5B0098 05/11/07 By Smapmin AFTER FIELD aba01 判斷錯誤
# Modify.........: No.FUN-5A0072 05/11/10 By ice 函數新增傳遞參數g_argv3傳票編號，方便函數調用
# Modify.........: No.FUN-5C0015 060109 BY GILL (1)新增abb31~37
#                  (2)確認段，處理abg31~36 (3)取消確認，處理abg31~36
# Modify.........: NO.FUN-5C0112 06/01/23 BY yiting 確認後仍可查詢立沖資料(增加 action)鈕
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL 用s_ahe_qry取代q_aee
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.FUN-630029 06/03/14 BY Echo 新增申請人(表單關係人)欄位
# Modify.........: No.TQC-630238 06/03/24 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-630066 06/03/27 BY Ray 新增aba31~38,新增出納審核
# Modify.........: No.TQC-610104 06/03/31 By Smapmin CONTROLO有誤
# Modify.........: No.MOD-630121 06/03/31 By Smapmin 現支或現收傳票,單身借貸方不能變動
# Modify.........: No.TQC-640017 06/04/06 By Smapmin 部門.預算.專案.異動碼是否輸入等控管
# Modify.........: No.MOD-640118 06/04/09 By Sarah 異動碼若設定一定要輸入及檢查卻沒輸入值,需顯示錯誤訊息,不可通過
# Modify.........: No.MOD-640297 06/04/10 By Smapmin 來源碼非總帳,除備註外不可修改
# Modify.........: No.MOD-640486 06/04/17 By Smapmin 使用複製功能時,單號有誤
# Modify.........: No.FUN-640184 06/05/02 By Echo 自動執行確認功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660096 06/06/22 By saki 流程訊息功能
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.TQC-670044 06/07/12 By Smapmin 來源碼為AC/AD也要同GL的處理
# Modify.........: No.MOD-680003 06/08/02 By Smapmin 修正欄位輸入否的判斷
# Modify.........: No.FUN-680098 06/09/17 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.TQC-690116 06/09/27 By Rayven SQL語句where條件增加aba00的判斷
# Modify.........: No.MOD-6A0010 06/10/18 By Smapmin 補充MOD-530634
# Modify.........: No.MOD-690050 06/10/18 By Smapmin 單身的異動碼值也要一併複製
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0006 06/11/01 By Smapmin 執行複製功能時,要先輸入日期再輸入單別
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No.MOD-6B0149 06/11/28 By xufeng 當台灣版、歐美版時，隱藏“附件張數”欄位；大陸版時，若使用國家標准會計核算此欄位必須輸入。 
# Modify.........: No.MOD-6C0007 06/12/04 By Smapmin 修改WHERE 條件
# Modify.........: No.MOD-6B0150 06/12/05 By Smapmin 單身預算編號開窗有誤
# Modify.........: No.CHI-680026 06/12/05 By Smapmin 修改分攤比率的算法
# Modify.........: No.CHI-6C0018 06/12/27 By jamie 列印憑證時，只印畫面上的單張
# Modify.........: No.MOD-6C0177 06/12/28 By Smapmin 修改傳票還原所傳遞的參數
# Modify.........: No.FUN-710023 07/01/25 By yjkhero 錯誤訊息匯整 
# Modify.........: No.TQC-720027 07/02/27 By Smapmin 修改簽核流程
# Modify.........: No.FUN-740020 07/04/06 By bnlent  會計科目加帳套
# Modify.........: No.MOD-740068 07/04/22 By rainy 整合測試:
# Modify.........: No.MOD-740164 07/04/22 By Smapmin 傳票日小於等於關帳日時,不可確認與取消確認
# Modify.........: No.MOD-740256 07/04/23 By Smapmin 傳票單別種類要加以判斷
# Modify.........: No.TQC-740284 07/04/24 By Echo 從ERP簽核時，「出納確認」、「取消出納確認」、「沖帳傳票資料」action 應隱藏
# Modify.........: No.MOD-740297 07/04/26 By Carrier 單身復制時,與科目相關字段合理性處理
# Modify.........: No.MOD-750020 07/05/08 By Smapmin 修正MOD-510056
# Modify.........: No.TQC-750041 07/05/09 By Lynn 申請人報錯信息無中文顯示
# Modify.........: No.TQC-750089 07/05/18 By Rayven 有些單據無法審核
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780003 07/08/01 By Smapmin 修改判斷單別的條件
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 修改是否有出納流程的判斷
# Modify.........: No.TQC-780055 07/08/20 By Smapmin 刪除秀在背景的資料
# Modify.........: No.MOD-780166 07/08/20 By kim b_fill()段OUTER aag_file的where條件有少
# Modify.........: No.MOD-780252 07/08/28 By Smapmin 借貸方不平時不可確認
# Modify.........: No.TQC-790077 07/09/13 By Carrier 營運中心切換 的提示用aom-303,原來直接用英文
# Modify.........: NO.TQC-790093 07/09/20 by yiting Primary Key的-268訊息 程式修改
# Modify.........: No.MOD-7A0043 07/10/09 By Smapmin 錯誤訊息匯總是做在確認/取消確認段,故做完確認/取消確認後就要秀出
# Modify.........: No.FUN-7A0004 07/10/15 By chenl   在確認段增加對異動碼的判斷。
# Modify.........: No.MOD-7A0058 07/10/18 By Smapmin 營運中心切換加入權限控管
#                                                    切換營運中心後,帳別要預設為aaz64
# Modify.........: No.MOD-7A0131 07/10/23 By chenl   1.修正切換帳套后，會計期間取值錯誤。
#                                                    2.修正單身無現金類科目還要出納審核的狀況。
# Modify.........: No.MOD-7B0006 07/11/01 By Smapmin 於畫面顯示aba37/aba38
# Modify.........: No.MOD-7C0098 07/12/17 By Smapmin 原幣金額允許為0
# Modify.........: No.TQC-7C0152 07/12/18 By Smapmin 修改錯誤訊息
# Modify.........: No.MOD-810106 08/01/16 By Smapmin 非GL單別修改時要可以維護附件張數
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-810069 08/03/26 By douzh 取消預算管理的管控/aag21和abb15得管控
# Modify.........: No.MOD-830053 08/03/07 By Smapmin 附件張數不做entry/no entry的控管
# Modify.........: No.FUN-810045 08/03/31 By rainy 專案管理,專案table gja_file->pja_file
# Modify.........: No.FUN-830139 08/04/01 By douzh abb35/36往前移到abb08(專案代號)後，未做專案管理時，此3欄位隱藏
# Modify.........: No.FUN-830139 08/04/11 By hellen項目管理加預算及項目控管
# Modify.........: No.TQC-840044 08/04/18 By Carrier 核算項9/10修改
# Modify.........: No.MOD-840235 08/04/20 By Carrier set_entry_b() 幣種及核算項問題
# Modify.........: No.MOD-840538 08/04/22 By Smapmin 查詢時,傳票編號開窗只能開出所屬帳別的資料
# Modify.........: No.MOD-840019 08/04/03 By Carol call q_afa()加傳參數g_aba.aba00
# Modify.........: No.MOD-840114 08/04/15 By Carol ON ROW CHANGE call t110_abhmod()改call t110_abhmod_h('R',g_aba.aba01)
# Modify.........: No.FUN-850038 08/05/13 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-850201 08/05/26 By Sarah 進入單身後,若出現agl-900檢核訊息,僅需提示即可應可離開單身
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.MOD-850304 08/06/25 By Sarah gglt110.4gl無法在異動碼欄位輸入中文字做查詢,程式會當出 
# Modify.........: No.CHI-850031 08/07/09 By Sarah 修改單身會計科目(abb03)時,先檢核沖帳檔abh_file,若已有資料則不可修改會計科目
# Modify.........: No.FUN-850043 08/07/15 By lala 增加如果取不到日匯率要去取月均匯率檔的功能
# Modify.........: No.MOD-830046 08/03/06 By chenl   將過賬及過賬還原按鈕顯示在界面上，不再做任何限制。
# Modify.........: No.MOD-890219 08/09/23 By Sarah ACTION"切換帳別"增加以cl_chk_act_auth()判斷有沒有切換權限
# Modify.........: NO.MOD-870090 08/07/09 By chenl 將單身科目名稱的查詢去除，科目名稱可以由科目編號開窗查詢。
# Modify.........: No.MOD-8A0037 08/10/03 By clover 修改ON IDEL 次序
# Modify.........: No.FUN-890128 08/10/06 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.........: No.TQC-8A0022 08/10/15 By Vicky 修改EXIT FOREACH位置
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8A0205 08/10/29 By Sarah t110_copy()段的AFTER FIELD aba01增加讀取單據性質(參考_i()段寫法),判斷輸入單別的正確性
# Modify.........: No.MOD-8B0125 08/11/12 By chenl CE類憑証不可過賬還原
# Modify.........: No.MOD-8B0178 08/11/19 By clover 切換營運中心 開窗大小調整
# Modify.........: No.MOD-8C0154 08/12/16 By Sarah 抓取匯率改CALL s_curr3()
# Modify.........: No.MOD-8C0166 08/12/19 By liuxqa 修正FUN-810045,將q_pja2->q_pja
# Modify.........: No.MOD-8B0281 08/12/25 By chenl  在新增情況下，增加憑証缺號的查詢補錄功能。
# Modify.........: No.FUN-8C0107 08/12/29 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD 
# Modify.........: No.MOD-920133 09/02/10 By Sarah CALL s_post()前增加判斷當aaz80='N' AND abaprno=0時,提示訊息
# Modify.........: No.MOD-920177 09/02/13 By liuxqa 過賬還原時，有對aba38更新，但是此時沒有同步更新abapost
# Modify.........: No.FUN-920105 09/02/16 By sabrina (1)aglt130、gglt140與easyflow整合，並在畫面上新增aba00欄位且設定為隱藏不顯示   
#                                                    (2)在Tiptop端簽核時，〝切換帳號、傳票過帳、過帳還原、拋轉來源查詢〞這三個action要隱藏不顯示   
# Modify.........: No.FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post
# Modify.........: No.MOD-920373 09/02/27 By Smapmin 傳票日期必須落在分攤編號的起迄之間
# Modify.........: No.TQC-930002 09/03/02 BY chenl  修正:'出納確認'和'取消出納確認'兩個按鈕,在不滿足顯示的條件下,因轉換語言別而自動顯示的問題.
# Modify.........: No.MOD-930064 09/03/05 By chenl  過賬不成過,不更新過賬人員
# Modify.........: No.FUN-930106 09/03/17 By destiny abb36預算項目字段增加管控
# Modify.........: No.MOD-940051 09/04/06 By Sarah 單身異動碼-9(WBS)欄位開窗改為q_pjb4,輸入時不需檢核該WBS的pjb25值為何
# Modify.........: No.MOD-940409 09/04/30 By chenl  復制時，對審核人員及過賬人員兩個欄位進行清空
# Modify.........: No.CHI-920071 09/05/11 By jan 在確認段增加預算管控
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.TQC-960426 09/06/29 By xiaofeizhu 當資料有效碼(abaacti)='N'時，不可刪除該筆資料
# Modify.........: No.MOD-970238 09/07/24 By liuxqa 復制時，憑証日期不做當前會計期間的限制。
# Modify.........: No.FUN-980003 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980175 09/08/21 By mike FUNCTION t110_bud(),在IF m_aag21 <> 'Y' THEN前,需重抓aag21的值                    
# Modify.........: No.TQC-980250 09/08/25 By xiaofeizhu 刪除時報從(abh_file）刪除失敗的錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990090 09/09/27 By mike gglt110.4gl 確認, 選擇2.依範圍條件 時, 不可確認無單身的傳票                           
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-990175 09/10/09 By mike FUNCTION t110_y1(),顯示agl-004時,改提示是哪一個項次(可參考agl-911訊息的寫法)      
# Modify.........: No.TQC-970225 09/10/10 By baofei 串aglr902打印會報錯   
# Modify.........: No.MOD-9A0081 09/10/12 By mike 1.FUNCTION t110_i()的AFTER INPUT段,需判断aaz81='Y'才编总号                        
#                                                 2.FUNCTION t110_copy()编总号(aba11)那段也需判断g_aaz.aaz81='Y'才做                
# Modify.........: No.FUN-9B0022 09/11/04 By wujie 5.2SQL转标准语法
# Modify.........: No.MOD-9C0175 09/12/18 By sabrina 異動碼可輸入可空白
# Modify.........: No:MOD-9C0256 09/12/21 By baofei abaoriu,abaorig給值
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.MOD-A10073 10/01/13 By Sarah 過帳/過帳還原批次程式裡已經UPDATE過帳碼與過帳人員了,維護程式裡不需再UPDATE
# Modify.........: No.MOD-A10143 10/01/25 By liuxqa 如果单身中的科目有无效或者是统制类科目，不可过帐和过帐还原。
# Modify.........: No.FUN-A20031 10/02/08 By Carrier 画面重整
# Modify.........: NO.CHI-AC0010 10/12/24 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No:CHI-C80041 12/12/05 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:CHI-C80041 13/01/07 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-A20031
 
#模組變數(Module Variables)
DEFINE g_aba01t        LIKE aac_file.aac01,   #單別(temp) #No.FUN-560014 #No.FUN-680098 VARCHAR(5)
       g_bookno        LIKE aaa_file.aaa01,   #帳別
       g_argv1         LIKE aba_file.aba01,   #傳票編號  #FUN-580152
       g_aza48         LIKE aza_file.aza48,   #國家會計標准  #FUN-630066
       g_argv2         LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(01)
       g_argv3         LIKE aba_file.aba01,   #傳票編號  #FUN-5A0072
       g_aba           RECORD LIKE aba_file.*,       #傳票編號 (假單頭)
       s_abb           RECORD LIKE abb_file.*,       #傳票編號 (假單身)
       g_aac           RECORD LIKE aac_file.*,       #單據性質
       g_aba_t         RECORD LIKE aba_file.*,       #傳票編號 (舊值)
       g_aba_o         RECORD LIKE aba_file.*,       #傳票編號 (舊值)
       g_aba01_t       LIKE aba_file.aba01,   #
       g_aba02_t       LIKE aba_file.aba02,   #
       g_aba00_t       LIKE aba_file.aba00,   #
       g_tail          LIKE type_file.num10,  #ROWID為更新項次之用 #No.FUN-680098 INTEGER
       g_digit         LIKE type_file.num5,   #小數位數   #No.FUN-680098 smallint
       g_aaa           RECORD LIKE aaa_file.*,
       m_aag05         LIKE aag_file.aag05,
       m_aag06         LIKE aag_file.aag06,  #借餘或貸餘
       m_aag15         LIKE aag_file.aag15,
       m_aag16         LIKE aag_file.aag16,
       m_aag17         LIKE aag_file.aag17,
       m_aag18         LIKE aag_file.aag18,
       m_aag151        LIKE aag_file.aag151,
       m_aag161        LIKE aag_file.aag161,
       m_aag171        LIKE aag_file.aag171,
       m_aag181        LIKE aag_file.aag181,
 
       m_aag31         LIKE aag_file.aag31,
       m_aag32         LIKE aag_file.aag32,
       m_aag33         LIKE aag_file.aag33,
       m_aag34         LIKE aag_file.aag34,
       m_aag35         LIKE aag_file.aag35,
       m_aag36         LIKE aag_file.aag36,
       m_aag37         LIKE aag_file.aag37,
       m_aag311        LIKE aag_file.aag311,
       m_aag321        LIKE aag_file.aag321,
       m_aag331        LIKE aag_file.aag331,
       m_aag341        LIKE aag_file.aag341,
       m_aag351        LIKE aag_file.aag351,
       m_aag361        LIKE aag_file.aag361,
       m_aag371        LIKE aag_file.aag371,
 
       m_aag21         LIKE aag_file.aag21,
       m_aag23         LIKE aag_file.aag23,
       m_aag222        LIKE aag_file.aag222,
       m_aag20         LIKE aag_file.aag20,   #細項立沖否
       g_abb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          abb02       LIKE abb_file.abb02,   #項次
                          abb03       LIKE abb_file.abb03,   #科目編號
                          aag02       LIKE aag_file.aag02,   #科目名稱
                          abb24       LIKE abb_file.abb24,   #币别
                          abb25       LIKE abb_file.abb25,   #汇率
                          abb07df     LIKE abb_file.abb07f,  #借方原币
                          abb07d      LIKE abb_file.abb07,   #借方本币
                          abb07cf     LIKE abb_file.abb07f,  #贷方原币
                          abb07c      LIKE abb_file.abb07,   #贷方本币
                          abb04       LIKE abb_file.abb04    #摘要
                       END RECORD,
       g_abb_t         RECORD                 #程式變數 (舊值)
                          abb02       LIKE abb_file.abb02,   #項次
                          abb03       LIKE abb_file.abb03,   #科目編號
                          aag02       LIKE aag_file.aag02,   #科目名稱
                          abb24       LIKE abb_file.abb24,   #币别
                          abb25       LIKE abb_file.abb25,   #汇率
                          abb07df     LIKE abb_file.abb07f,  #借方原币
                          abb07d      LIKE abb_file.abb07,   #借方本币
                          abb07cf     LIKE abb_file.abb07f,  #贷方原币
                          abb07c      LIKE abb_file.abb07,   #贷方本币
                          abb04       LIKE abb_file.abb04    #摘要
                       END RECORD,
       g_abb1          DYNAMIC ARRAY OF RECORD                 #程式變數 (舊值)
                          abb05       LIKE abb_file.abb05,   #部門
                          gem02       LIKE gem_file.gem02,   #部門簡稱
                          abb08       LIKE abb_file.abb08,
                          abb11       LIKE abb_file.abb11,
                          abb12       LIKE abb_file.abb12,
                          abb13       LIKE abb_file.abb13,
                          abb14       LIKE abb_file.abb14,
                          abb31       LIKE abb_file.abb31,
                          abb32       LIKE abb_file.abb32,
                          abb33       LIKE abb_file.abb33,
                          abb34       LIKE abb_file.abb34,
                          abb35       LIKE abb_file.abb35,
                          abb36       LIKE abb_file.abb36,
                          abb37       LIKE abb_file.abb37,
                          abbud01     LIKE abb_file.abbud01,
                          abbud02     LIKE abb_file.abbud02,
                          abbud03     LIKE abb_file.abbud03,
                          abbud04     LIKE abb_file.abbud04,
                          abbud05     LIKE abb_file.abbud05,
                          abbud06     LIKE abb_file.abbud06,
                          abbud07     LIKE abb_file.abbud07,
                          abbud08     LIKE abb_file.abbud08,
                          abbud09     LIKE abb_file.abbud09,
                          abbud10     LIKE abb_file.abbud10,
                          abbud11     LIKE abb_file.abbud11,
                          abbud12     LIKE abb_file.abbud12,
                          abbud13     LIKE abb_file.abbud13,
                          abbud14     LIKE abb_file.abbud14,
                          abbud15     LIKE abb_file.abbud15
                       END RECORD,
       g_abb1_t,g_abb2 RECORD                 #程式變數 (舊值)
                          abb05       LIKE abb_file.abb05,   #部門
                          gem02       LIKE gem_file.gem02,   #部門簡稱
                          abb08       LIKE abb_file.abb08,
                          abb11       LIKE abb_file.abb11,
                          abb12       LIKE abb_file.abb12,
                          abb13       LIKE abb_file.abb13,
                          abb14       LIKE abb_file.abb14,
                          abb31       LIKE abb_file.abb31,
                          abb32       LIKE abb_file.abb32,
                          abb33       LIKE abb_file.abb33,
                          abb34       LIKE abb_file.abb34,
                          abb35       LIKE abb_file.abb35,
                          abb36       LIKE abb_file.abb36,
                          abb37       LIKE abb_file.abb37,
                          abbud01     LIKE abb_file.abbud01,
                          abbud02     LIKE abb_file.abbud02,
                          abbud03     LIKE abb_file.abbud03,
                          abbud04     LIKE abb_file.abbud04,
                          abbud05     LIKE abb_file.abbud05,
                          abbud06     LIKE abb_file.abbud06,
                          abbud07     LIKE abb_file.abbud07,
                          abbud08     LIKE abb_file.abbud08,
                          abbud09     LIKE abb_file.abbud09,
                          abbud10     LIKE abb_file.abbud10,
                          abbud11     LIKE abb_file.abbud11,
                          abbud12     LIKE abb_file.abbud12,
                          abbud13     LIKE abb_file.abbud13,
                          abbud14     LIKE abb_file.abbud14,
                          abbud15     LIKE abb_file.abbud15
                       END RECORD,
       m_aba           RECORD LIKE aba_file.*,
       g_abb07f_t1,g_abb07_t1 LIKE abb_file.abb07,
       g_abb07f_t2,g_abb07_t2 LIKE abb_file.abb07,
       g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
       g_wca,g_wcb,g_wcc   string,
       g_t1            LIKE type_file.chr5,        #No.FUN-560014 #No.FUN-680098 VARCHAR(5)
       g_statu         LIKE type_file.chr1,        #No.FUN-680098 VARCHAR(1)
       g_rec_b         LIKE type_file.num5,        #單身筆數    #No.FUN-680098 smallint
       g_cmd           LIKE type_file.chr1000,     #No.FUN-680098 VARCHAR(300)
       l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT  #No.FUN-680098 smallint
       l_ac1           LIKE type_file.num5,        #目前處理的ARRAY CNT  #No.FUN-680098 smallint
       l_str1          LIKE aag_file.aag01,        #No.FUN-680098 VARCHAR(20)
       t_aba00         LIKE aba_file.aba00,
       t_aba01         LIKE aba_file.aba01,
       g_afb07         LIKE afb_file.afb07,
       g_sta           LIKE type_file.chr20,       #No.FUN-680098 VARCHAR(20)
       g_key1          LIKE type_file.chr20,       #No.FUN-680098 VARCHAR(10)
       g_depno         LIKE type_file.chr20,       #No.FUN-680098 VARCHAR(20),
       w_qry           LIKE type_file.chr20        #No.FUN-680098 VARCHAR(20)
DEFINE g_forupd_sql    STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680098  VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680098  INTEGER
DEFINE g_i             LIKE type_file.num5         #count/index for any purpose  #No.FUN-680098 smallint
DEFINE g_msg           LIKE ze_file.ze03           #No.FUN-680098 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680098 SMALLINT
DEFINE g_row_count     LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE g_curs_index    LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE g_jump          LIKE type_file.num10        #No.FUN-680098 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680098 SMALLINT
DEFINE g_chr2          LIKE type_file.chr1         #No.FUN-680098 VARCHAR(1)
DEFINE g_chr3          LIKE type_file.chr1         #FUN-580152    #No.FUN-680098 VARCHAR(1)
DEFINE g_laststage     LIKE type_file.chr1         #FUN-580152    #No.FUN-680098 VARCHAR(1)
DEFINE g_flag1         LIKE type_file.chr1         #No.FUN-830139 add by hellen
DEFINE g_tmp        DYNAMIC ARRAY OF RECORD
         tc_tmp00   LIKE type_file.chr1,
         tc_tmp01   LIKE type_file.num5,
         tc_tmp03   LIKE tmn_file.tmn06,
         tc_tmp02   LIKE tmn_file.tmn02
                    END RECORD
 
FUNCTION t110(p_bookno,p_argv2)
      DEFINE
          l_sql          LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(150)
          p_bookno       LIKE aba_file.aba00,#帳別
          p_argv2        LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)# 狀況碼
   DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-680098 SMALLINT
   
 
   WHENEVER ERROR CALL cl_err_msg_log
   SELECT aza48 INTO g_aza48 FROM aza_file      #FUN-630066
 
   INITIALIZE g_aba_t.* TO NULL
   LET g_bookno = p_bookno
  #FUN-920105---easyflow---add---start---
  #在畫面上新增一個欄位aba0，其值與g_bookno一致，這個欄位設為隱藏，不顯示在畫面上
  #是用於做EF整合時讓EF設定作業抓取第二個KEY和在做簽核結果回傳時抓取的參數
   LET g_aba.aba00 = p_bookno
  #FUN-920105---easyflow---add---end---
 
 
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz.aaz64
      LET g_aba.aba00 = g_aaz.aaz64        #FUN-920105 add
   END IF
 
   LET g_argv1= ARG_VAL(1)           #FUN-640244  #FUN-810046  
 
   LET g_argv3= ARG_VAL(3)           #No.TQC-660096
 
 
   #aglt130、gglt140畫面有〝切換帳號〞action，所以使用者可自行做帳別切換
   #因此可能會與預設帳別不符合，故在做EasyFlow整合時，要多傳第二個key值：帳別
   #而gglt110.4gl使用者無法更改帳別，所以不用多傳第二個key值，以預設的帳別為主
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
      IF p_argv2 = '3' or p_argv2 = '4' THEN
         LET g_bookno = aws_efapp_wsk(2)
         LET g_argv3 = ARG_VAL(3)
      ELSE
         LET g_bookno = g_aaz.aaz64
         LET g_argv3 = ARG_VAL(2)
      END IF
   END IF
 
   LET g_argv2 = p_argv2
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"","agl-095","","",1)  #No.FUN-660123
      RETURN
   END IF
 
   SELECT azi04 INTO g_digit FROM azi_file WHERE azi01 = g_aaa.aaa03
   IF STATUS THEN
      LET g_digit = 0
   END IF
 
   LET g_wc2 = ' 1=1'
 
   CALL t110_lock_cur()
 
   CALL s_dsmark(g_bookno)
 
   IF INT_FLAG THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   LET p_row = 3
   LET p_col = 2
 
   CASE g_argv2
      WHEN '1'
         IF g_bgjob='N' OR cl_null(g_bgjob) THEN
            OPEN WINDOW t110_w AT p_row,p_col   #一般傳票
              WITH FORM "ggl/42f/gglt110.4gl"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         END IF
         LET g_prog='gglt110'
      WHEN '3'
         OPEN WINDOW t110_w AT p_row,p_col   #應計傳票
           WITH FORM "ggl/42f/aglt130"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         LET g_prog='aglt130'
      WHEN '7'
         OPEN WINDOW t110_w AT p_row,p_col   #歷史傳票查詢
           WITH FORM "ggl/42f/aglq170"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
         LET g_prog='aglq170'
      WHEN '4'
         OPEN WINDOW t110_w AT p_row,p_col   #審計傳票
           WITH FORM "ggl/42f/gglt110.4gl"  ATTRIBUTE (STYLE = g_win_style CLIPPED)           #No.FUN-580092 HCN
         LET g_prog='gglt140'
      OTHERWISE
         CALL cl_err('','agl-065',1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
   END CASE
 
   DROP TABLE agl_tmp_file
   CREATE TEMP TABLE agl_tmp_file(
    tc_tmp00     LIKE type_file.chr1 NOT NULL,
    tc_tmp01     LIKE type_file.num5,
    tc_tmp02     LIKE type_file.chr20,
    tc_tmp03     LIKE apz_file.apz02b)
   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) RETURN END IF
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)
   IF STATUS THEN CALL cl_err('create index',STATUS,0) RETURN END IF
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      CALL cl_ui_init()
   END IF
 
   IF g_aza.aza26 <> '2' THEN
      CALL cl_set_comp_visible("aba21",FALSE)
   END IF
 
   SELECT aza48 INTO g_aza48 FROM aza_file 
   IF g_aza48 = "N" THEN
      CALL cl_set_comp_visible("gb6,aba35,aba36",FALSE)   #MOD-7B0006  #carrier
   END IF
#  CALL t110_show_field() #FUN-5C0015 BY GILL
 
   CALL cl_set_comp_visible("aba00",FALSE)      #FUN-920105 add
   #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
   #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
   CALL aws_efapp_toolbar()    #FUN-580152
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv3
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
         WHEN "efconfirm"
            CALL t110_q()
            CALL t110_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t110_y_upd()       #CALL 原確認的 update 段
            END IF
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
            EXIT PROGRAM
         OTHERWISE
            CALL t110_q()
      END CASE
   END IF
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,switch_plant,invalid,invoice,cashier_confirm,undo_cashier_confirm,contra_detail,enter_book_no,voucher_post,undo_post,source_query")  #TQC-740284   #FUN-920105
        RETURNING g_laststage
 
   LET l_str1 = g_depno CLIPPED,'%' CLIPPED
 
   CALL s_shwact(3,2,g_bookno)
 
   CALL t110_menu()
 
   CLOSE WINDOW t110_w                 #結束畫面
 
END FUNCTION
 
FUNCTION t110_lock_cur()
 
   LET g_forupd_sql = " SELECT * FROM aba_file WHERE aba00 = ? AND aba01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
 
END FUNCTION
 
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_aba36         LIKE    gen_file.gen01
DEFINE  l_wc            STRING
   CLEAR FORM                             #清除畫面
   CALL g_abb.clear()
   CALL s_shwact(3,2,g_bookno)
 
   IF NOT cl_null(g_argv1) THEN
            LET g_wc = " aba01 = '",g_argv1 CLIPPED,"'"
   ELSE
      WHILE TRUE
         CALL cl_set_head_visible("","YES")    #No.FUN-6B0029  
         CALL cl_set_comp_visible('abb24,abb25,abb07df,abb07cf',TRUE)
   INITIALIZE g_aba.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME g_wc ON aba01,aba02,aba03,aba04,aba06,aba11,aba19,abapost,aba35,
                                   aba20,abamksg,abasign,aba05,aba24, #FUN-630029
                                   aba18,aba10,aba21,aba07,abaprno,
                                   aba31,aba32,aba33,aba34,abagrup,abamodu, #FUN-630066
                                   abaoriu,abaorig, abadate,abaacti,
                                   abaud01,abaud02,abaud03,abaud04,abaud05,
                                   abaud06,abaud07,abaud08,abaud09,abaud10,
                                   abaud11,abaud12,abaud13,abaud14,abaud15,
                                   abauser,aba36,aba37,aba38
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
             ON ACTION CONTROLP
                CASE
                    WHEN INFIELD(aba01) #傳票編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_aba"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1 = g_bookno   #MOD-840538
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aba01
                       NEXT FIELD aba01
                    WHEN INFIELD(aba10) #收支科目
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_aag"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 IN ('2') "
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aba10
                       NEXT FIELD aba10
 
                    WHEN INFIELD(aba24) #申請人
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gen"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aba24
                       NEXT FIELD aba24
 
                    WHEN INFIELD(aba36) #出納
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gen"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aba36
                       NEXT FIELD aba36
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
            LET INT_FLAG = 0
            RETURN
         END IF
 
         IF g_wc = ' 1=1' THEN
            CALL cl_err('','9046',0)
            CONTINUE WHILE
         END IF
 
         EXIT WHILE
      END WHILE
 
      LET g_wc = t110_subchr(g_wc,'"',"'")    
 
      CONSTRUCT g_wca ON abb02,abb03,abb24,abb25,abb04
                    FROM s_abb[1].abb02,
                         s_abb[1].abb03, s_abb[1].abb24,
                         s_abb[1].abb25,
                         s_abb[1].abb04
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(abb03)      #查詢科目代號不為統制帳戶'1'
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 ,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb03
               WHEN INFIELD(abb04)     #查詢常用摘要
                  CALL q_aad(FALSE,TRUE,g_abb[1].abb04) RETURNING g_abb[1].abb04
                  DISPLAY g_abb[1].abb04 TO abb04
               WHEN INFIELD(abb05)     #查詢部門
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem1"              #No.MOD-440244
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb05
               WHEN INFIELD(abb08)    #查詢專案編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja"    #FUN-810045 #No.MOD-8C0166 modify by liuxqa
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb08
               WHEN INFIELD(abb11)    #查詢異動碼-1
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb11
               WHEN INFIELD(abb12)    #查詢異動碼-2
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 2
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb12
               WHEN INFIELD(abb13)    #查詢異動碼-3
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 3
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb13
               WHEN INFIELD(abb14)    #查詢異動碼-4
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 4
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb14
 
               WHEN INFIELD(abb31)    #查詢異動碼-5
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 5
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb31
               WHEN INFIELD(abb32)    #查詢異動碼-6
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 6
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb32
               WHEN INFIELD(abb33)    #查詢異動碼-7
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 7
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb33
               WHEN INFIELD(abb34)    #查詢異動碼-8
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 8
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb34
               WHEN INFIELD(abb35)    #查詢異動碼-9-WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pjb4"   #MOD-940051 mod #q_pjb9->q_pjb4
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb35
               WHEN INFIELD(abb36)    #查詢異動碼-10-預算項目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azf01a"                #No.FUN-930106  
                  LET g_qryparam.arg1 = '7'                      #No.FUN-950077  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
               WHEN INFIELD(abb37)    #查詢關係人異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.arg1 = g_abb[1].abb03
                  LET g_qryparam.arg2 = 99
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb37
 
               WHEN INFIELD(abb24)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb24
               OTHERWISE
                  EXIT CASE
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

      CONSTRUCT g_wcb ON abb07f,abb07
                    FROM s_abb[1].abb07df,s_abb[1].abb07d
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
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

      CONSTRUCT g_wcc ON abb07f,abb07
                    FROM s_abb[1].abb07cf, s_abb[1].abb07c
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
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

      LET l_wc = ''
      IF g_wcb <> ' 1=1' THEN LET g_wcb = "(",g_wcb CLIPPED," AND abb06 = '1')" END IF
      IF g_wcc <> ' 1=1' THEN LET g_wcc = "(",g_wcc CLIPPED," AND abb06 = '2')" END IF
      IF g_wcb <> ' 1=1' THEN 
         IF g_wcc <> ' 1=1' THEN
            LET l_wc = "(",g_wcb CLIPPED," OR ",g_wcc CLIPPED,")"
         ELSE
            LET l_wc = g_wcb CLIPPED
         END IF
      ELSE
         IF g_wcc <> ' 1=1' THEN
            LET l_wc = g_wcc CLIPPED
         END IF
      END IF
      IF NOT cl_null(l_wc) THEN
         LET g_wc2 = g_wca CLIPPED," AND ",l_wc CLIPPED
      ELSE
         LET g_wc2 = g_wca CLIPPED
      END IF

      LET g_wc2 = t110_subchr(g_wc2,'"',"'")
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
 
   CASE g_argv2
      WHEN '1'
         LET g_wc = g_wc CLIPPED, " AND aba06 != 'AD' "   #FUN-570024
         IF g_aaz.aaz78 = "N" THEN
            LET g_wc = g_wc CLIPPED, " AND abapost = 'N' "
         END IF
      WHEN "3"
         LET g_wc = g_wc CLIPPED, " AND aba06 = 'AC' "
         IF g_aaz.aaz78 = "N" THEN
            LET g_wc = g_wc CLIPPED, " AND abapost = 'N' "
         END IF
      WHEN "7"
         LET g_wc = g_wc CLIPPED," AND abapost = 'Y' AND aba06 != 'AD' " #FUN-570024
      WHEN "4"
         LET g_wc = g_wc CLIPPED, " AND aba06 = 'AD' "
   END CASE
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT aba01,aba00 ",
                  "  FROM aba_file",
                  " WHERE ",g_wc CLIPPED,
                  "   AND aba00 = '",g_bookno,"'",
                  "   AND aba06 != 'RV' "
   ELSE
      LET g_sql = "SELECT UNIQUE aba_file.aba01,aba00 ",
                  "  FROM aba_file,abb_file ",
                  " WHERE aba01 = abb01",
                  "   AND aba00 = '",g_bookno,"'",
                  "   AND aba00 = abb00 ",
                  "   AND abb02 != 0 ",
                  "   AND aba06 != 'RV' ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
 
   LET g_sql = g_sql CLIPPED," ORDER BY aba01 "
 
   PREPARE t110_prepare FROM g_sql
   DECLARE t110_cs SCROLL CURSOR WITH HOLD FOR t110_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM aba_file WHERE ",g_wc CLIPPED,
                "   AND aba00 = '",g_bookno,"'",
                "   AND aba06 !='RV' "
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT aba01) FROM aba_file,abb_file",
                " WHERE abb01=aba01 AND aba00 = abb00 ",
                "   AND aba06 !='RV' ",
                "   AND aba00 = '",g_bookno,
                "'  AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t110_precount FROM g_sql
   DECLARE t110_count CURSOR FOR t110_precount
 
END FUNCTION
 
FUNCTION t110_menu()
   DEFINE   l_cmd        LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(200)
   DEFINE   l_bookno     LIKE aaa_file.aaa01    #帳別
   DEFINE   l_creator    LIKE type_file.chr1    #是否退回填表人      #No.FUN-680098 VARCHAR(1)
   DEFINE   l_flowuser   LIKE type_file.chr1    # 是否有指定加簽人員 #FUN-580011 #No.FUN-680098 VARCHAR(1)
   DEFINE   l_n          LIKE type_file.num10   #No.FUN-680098 INTEGER
   DEFINE   l_cn          LIKE type_file.num10   #No.MOD-A10143 add

   LET l_flowuser = "N"
 
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
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t110_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t110_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t110_b('')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "approval_status"        #MOD-4A0299
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN
                    CALL aws_efstat2()        #MOD-560007
               END IF
            END IF
          WHEN "easyflow_approval"     #MOD-4A0299
            IF cl_chk_act_auth() THEN
                 CALL t110_ef()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t110_out()
            END IF
         WHEN "invoice"
            IF cl_chk_act_auth() THEN
                LET l_cmd =  "amdi100  ","'",g_aba.aba01,"' ",   #BUG-4C0171  #MOD-580070
                                     "'",g_aba.aba02,"' "," '1' " clipped
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "extra_memo"
            IF cl_chk_act_auth() THEN
               IF g_aba.aba01 IS NOT NULL AND g_aba.aba01 != ' '
                  THEN CALL s_agl_memo('a',g_aba.aba00,g_aba.aba01,0)
               END IF
            END IF
         WHEN "switch_plant"
            IF cl_chk_act_auth() THEN   #MOD-7A0058
               CALL t110_chgdbs()
            END IF   #MOD-7A0058
         WHEN "cashier_confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_cashier_conf()
            END IF
 
         WHEN "undo_cashier_confirm"
            IF cl_chk_act_auth() THEN
               CALL t110_un_cashier_conf()
            END IF
 
         WHEN "confirm"
               IF cl_chk_act_auth() THEN
                  CALL t110_y_chk()          #CALL 原確認的 check 段
                  IF g_success = "Y" THEN
                     CALL t110_y_upd()       #CALL 原確認的 update 段
                  END IF
               END IF
         WHEN "undo_confirm"
            IF g_aba.aba19 = "N" THEN        #FUN-630066
               CALL cl_err('','aba-105',0)   #FUN-630066
            ELSE                             #FUN-630066
               IF cl_chk_act_auth() THEN
                  CALL t110_z()
               END IF
            END IF                           #FUN-630066
         WHEN "contra_detail"
            IF cl_chk_act_auth() THEN
               CALL t110_detail()
            END IF
 
 
         #@WHEN "准"
         WHEN "agree"
            IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
               CALL t110_y_chk()
               IF g_success = 'Y' THEN
                  CALL t110_y_upd()      #CALL 原確認的 update 段
               END IF   #TQC-720027
            ELSE
               LET g_success = "Y"
               IF NOT aws_efapp_formapproval() THEN
                  LET g_success = "N"
               END IF
            END IF
            IF g_success = 'Y' THEN
                   IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                     IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                        LET l_flowuser = "N"
                        LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                        IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                          CALL t110_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,switch_plant,invalid,invoice,cashier_confirm,undo_cashier_confirm,contra_detail,enter_book_no,voucher_post,undo_post,source_query")  #TQC-740284     #FUN-920105 
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
            IF ( l_creator := aws_efapp_backflow() ) IS NOT NULL THEN #退回關卡
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_aba.aba20= 'R'
                     DISPLAY BY NAME g_aba.aba20
                  END IF
                  IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽核
                     IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       LET l_flowuser = "N"
                       LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                       IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                          CALL t110_q()
                        #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,switch_plant,invalid,invoice,cashier_confirm,undo_cashier_confirm,contra_detail,enter_book_no,voucher_post,undo_post,source_query")  #TQC-740284    #FUN-920105
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
 
         #@WHEN "簽核狀況"
         WHEN "approval_status"
              IF cl_chk_act_auth() THEN
                 IF aws_condition2() THEN
                     CALL aws_efstat2()
                 END IF
              END IF
 
         WHEN "enter_book_no"
            IF cl_chk_act_auth() THEN   #MOD-890219 add
               CALL s_selact(0,0,g_lang) RETURNING l_bookno
               IF NOT cl_null(l_bookno) THEN
                  LET g_bookno = l_bookno
                  LET g_aba.aba00 = l_bookno       #FUN-920105 add
                  CLEAR FORM
                  CALL g_abb.clear()
                  CLOSE t110_cs
                  CALL s_shwact(3,2,g_bookno)
                  CALL s_dsmark(g_bookno)
                  CALL cl_dsmark(0)
                  SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
                  SELECT azi04 INTO g_digit FROM azi_file WHERE azi01 = g_aaa.aaa03
                  IF STATUS THEN
                     LET g_digit = 0
                  END IF
                  DISPLAY BY NAME g_aba.aba00     #FUN-920105 add
               ELSE
                  DISPLAY g_bookno TO g_bookno
                  DISPLAY g_aba.aba00 TO aba00    #FUN-920105 add
               END IF
            END IF                      #MOD-890219 add
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aba.aba01 IS NOT NULL THEN
                  LET g_doc.column1 = "aba01"
                  LET g_doc.value1 = g_aba.aba01
               #aba_file有兩個key值，若第二個key值沒有設定，那aglt130、gglt140執行EF整合時，會讀取不到相關文件
                  LET g_doc.column2 = "aba00"    
                  LET g_doc.value2 = g_aba.aba00  
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "voucher_post"
            IF g_aba.aba19 ='N' THEN    #檢查資料是否為未確認
               CALL cl_err(g_aba.aba01,'aba-100',0)
            ELSE
               IF g_aba.abapost ='Y' THEN    #檢查資料是否為過帳
                  CALL cl_err(g_aba.aba01,'aap-742',0)
               ELSE
                 IF g_aaz.aaz80='N' AND g_aba.abaprno=0 THEN
                    CALL cl_err(g_aba.aba01,'agl-195',0)
                 ELSE
                 #add MOD-A10143 add ---begin
                  SELECT COUNT(abb03) INTO l_cn FROM abb_file,aag_file
                    WHERE abb00 = aag00 AND aag01 = abb03
                     AND aag00 = g_aba.aba00 AND abb01 = g_aba.aba01
                     AND (aag07 = '1' OR aagacti = 'N')
                  IF l_cn > 0 THEN
                     CALL cl_err(g_aba.aba01,'agl-318',0)
                  ELSE
                 #MOD-A10143 add --end
                    IF cl_chk_act_auth() THEN
                       IF cl_sure(21,21) THEN
                          LET g_success = "Y"
                          BEGIN WORK
                          CALL aglp102_post(g_aba.aba00,g_aba.aba02,g_aba.aba02,g_aba.aba01,g_aba.aba01,'N',' 1=1')#No.FUN-920155
                          IF g_success='Y' THEN
                             COMMIT WORK
                          ELSE
                             ROLLBACK WORK
                          END IF
                         #str MOD-A10073 mod
                         #批次程式裡已經UPDATE過帳碼與過帳人員了,這邊不需再UPDATE
                         #IF g_success='Y' THEN
                         #   SELECT abapost INTO g_aba.abapost
                         #     FROM aba_file
                         #    WHERE aba00=g_aba.aba00
                         #      AND aba01=g_aba.aba01
                         #   IF g_aba.abapost = 'Y' OR g_aba.abapost = 'y' THEN #No.MOD-930064
                         #      LET g_aba.aba38=g_user              #FUN-630066
                         #      UPDATE aba_file SET aba38 = g_aba.aba38
                         #       WHERE aba01 = g_aba.aba01
                         #         AND aba00 = g_aba.aba00  #No.TQC-690116
                         #      DISPLAY g_aba.abapost TO abapost
                         #      DISPLAY g_aba.aba38 TO aba38        #FUN-630066
                         #   END IF  #No.MOD-930064
                         #END IF
                          SELECT abapost,aba38 INTO g_aba.abapost,g_aba.aba38
                            FROM aba_file
                           WHERE aba00=g_aba.aba00
                             AND aba01=g_aba.aba01
                          DISPLAY BY NAME g_aba.abapost,g_aba.aba38
                         #end MOD-A10073 mod
                       END IF
                    END IF
                   END IF     #MOD-A10143 add 
                  END IF   #MOD-920133 add
               END IF
            END IF
 
         WHEN "undo_post"
            IF g_aba.aba06='CE' THEN 
               CALL cl_err(g_aba.aba01,'agl-218',0)
               CONTINUE WHILE
            END IF 
            IF g_aba.abapost ='N' THEN    #檢查資料是否為未過帳
               CALL cl_err(g_aba.aba01,'aba-108',0)        #FUN-630066
            ELSE
           #add MOD-A10143 add ---begin
            SELECT COUNT(abb03) INTO l_cn FROM abb_file,aag_file
               WHERE abb00 = aag00 AND aag01 = abb03
                 AND aag00 = g_aba.aba00 AND abb01 = g_aba.aba01
                 AND (aag07 = '1' OR aagacti = 'N')
            IF l_cn > 0 THEN
               CALL cl_err(g_aba.aba01,'agl-318',0)
            ELSE
           #MOD-A10143 add --end
              IF cl_chk_act_auth() THEN
                 IF cl_sure(21,21) THEN
                    LET g_success='Y'
                    BEGIN WORK
                    LET l_cmd = "aglp109 '",g_aba.aba00,"' '",g_aba.aba02,"' '",g_aba.aba01,"' '' ,'Y'"   #MOD-6C0177
                    CALL cl_cmdrun_wait(l_cmd)
                    IF g_success='Y' THEN
                       COMMIT WORK
                    ELSE
                       ROLLBACK WORK
                    END IF
                   #str MOD-A10073 mod
                   #批次程式裡已經UPDATE過帳碼與過帳人員了,這邊不需再UPDATE
                   #IF g_success='Y' THEN
                   #   SELECT abapost INTO g_aba.abapost
                   #     FROM aba_file
                   #    WHERE aba00=g_aba.aba00
                   #      AND aba01=g_aba.aba01
                   #   LET g_aba.aba38=NULL                #FUN-630066
#                  #   UPDATE aba_file SET aba38 = g_aba.aba38              #No.MOD-920177 mark by liuxqa
                   #   UPDATE aba_file SET aba38 = g_aba.aba38,abapost='N'  #No.MOD-920177 mod by liuxqa
                   #    WHERE aba01 = g_aba.aba01
                   #      AND aba00 = g_aba.aba00  #No.TQC-690116
                   #   DISPLAY g_aba.abapost TO abapost
                   #   DISPLAY g_aba.aba38 TO aba38        #FUN-630066
                   #END IF
                    SELECT abapost,aba38 INTO g_aba.abapost,g_aba.aba38
                      FROM aba_file
                     WHERE aba00=g_aba.aba00
                       AND aba01=g_aba.aba01
                    DISPLAY BY NAME g_aba.abapost,g_aba.aba38
                   #end MOD-A10073 mod
                 END IF
              END IF
             END IF          #MOD-A10143 add
            END IF
 
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abb),'','')
            END IF
 
         WHEN "source_query"
            IF g_aba.aba06<>'GL' AND g_aba.aba06<>'RV' AND g_aba.aba06<>'AC'
                                 AND g_aba.aba06<>'CE' THEN
               LET l_cmd = "aglq200 '",g_bookno,"' '",g_aba.aba01,"' "
               CALL cl_cmdrun(l_cmd)
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t110_v()
               IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
               IF g_aba.aba20='1' OR
                  g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
               CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)  
            END IF
         #CHI-C80041---end 
        END CASE
    END WHILE
END FUNCTION
 
FUNCTION t110_detail()
    IF g_rec_b != 0 THEN
        SELECT aag20 INTO m_aag20 FROM aag_file
         WHERE aag01=g_abb[l_ac].abb03
           AND aag00=g_bookno    #No.FUN-740020
        IF STATUS=0 AND m_aag20='Y' THEN
           CALL s_abh(g_aba.aba00,g_aba.aba01,g_aba.aba02,
           g_abb[l_ac].abb02)
        END IF
    END IF
END FUNCTION
 
FUNCTION t110_a()
   DEFINE li_result             LIKE type_file.num5   #No.FUN-560014  #No.FUN-680098  smallint
   DEFINE l_buf1,l_buf2,l_buf3  LIKE type_file.chr1000#No.FUN-680098  VARCHAR(40)
   DEFINE l_azn02               LIKE azn_file.azn02,
          l_azn04               LIKE azn_file.azn04,
          l_azm02               LIKE azm_file.azm02,  #FUN-570024
          l_azmm02              LIKE azmm_file.azmm02,#MOD-7A0131 
          l_aba02               LIKE aba_file.aba02   #FUN-570024
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_abb.clear()
   CALL s_shwact(3,2,g_bookno)
   INITIALIZE g_aba.* LIKE aba_file.*             #DEFAULT 設定
   LET g_aba01_t = NULL
   LET g_aba00_t = NULL
   LET g_aba_o.* = g_aba.*
    LET g_aba.aba02 = today     #No.MOD-480582
   IF cl_null(g_aba.aba02) THEN
      LET g_aba.aba02 = g_today
   END IF
   IF g_argv2 = '4' THEN
      IF g_aza.aza63 = 'Y' THEN
         SELECT azmm02 INTO l_azmm02 FROM azmm_file
          WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
         IF l_azmm02 ='1' THEN
            SELECT azmm122 INTO l_aba02 FROM azmm_file
             WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
         END IF
         IF l_azmm02 ='2' THEN
            SELECT azmm132 INTO l_aba02 FROM azmm_file
             WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
         END IF
      ELSE
         SELECT azm02 INTO l_azm02 FROM azm_file
          WHERE azm01 = YEAR(today)-1
         IF l_azm02 ='1' THEN
            SELECT azm122 INTO l_aba02 FROM azm_file
             WHERE azm01 = YEAR(today)-1
         END IF
         IF l_azm02 ='2' THEN
            SELECT azm132 INTO l_aba02 FROM azm_file
             WHERE azm01 = YEAR(today)-1
         END IF
      END IF  #No.MOD-7A0131
      LET g_aba.aba02 = l_aba02
   END IF
   LET g_aba.aba05 = g_today
 
   CASE g_argv2
      WHEN '1'
         LET g_aba.aba06 = 'GL' #一般
      WHEN '2'
         LET g_aba.aba06 = 'RV' #轉回
      WHEN '3'
         LET g_aba.aba06 = 'AC' #應計
      WHEN '4'
         LET g_aba.aba06 = 'AD' #審計
   END CASE
 
   LET g_aba.aba08 = 0
   LET g_aba.aba09 = 0
   LET g_aba.abasseq = 0
   LET g_aba.aba35 = 'N'
   LET g_aba.abapost = 'N'
   LET g_aba.abaprno = 0
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_aba.aba18  ='0'
      LET g_aba.aba19  ='N'
      LET g_aba.aba35 = 'N'
      LET g_aba.aba20 = 0
      LET g_aba.abauser=g_user
      LET g_aba.abaoriu = g_user #FUN-980030
      LET g_aba.abaorig = g_grup #FUN-980030
      LET g_aba.abagrup=g_grup
      LET g_aba.abadate=g_today
      LET g_aba.abaacti='Y'              #資料有效
      LET g_aba.aba24=g_user                            
      LET g_aba.abalegal=g_legal   #FUN-980003 add
      CALL t110_aba24('d')
      IF NOT cl_null(g_errno) THEN
         LET g_aba.aba24 = ''
      END IF
 
      IF g_aza.aza63 = 'Y' THEN
         SELECT aznn02,aznn04 INTO l_azn02,l_azn04 FROM aznn_file
          WHERE aznn01 = g_aba.aba02 AND aznn00 = g_aba.aba00
      ELSE
         SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
          WHERE azn01 = g_aba.aba02
      END IF   #No.MOD-7A0131 add
      IF SQLCA.sqlcode =0 THEN
         IF g_argv2 != '4' THEN
            LET g_aba.aba03 = l_azn02
            LET g_aba.aba04 = l_azn04
         ELSE
            LET g_aba.aba03 = YEAR(today)
            LET g_aba.aba04 = 0
         END IF
      END IF
 
      CALL t110_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_aba.* LIKE aba_file.*
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_aba.aba01 IS NULL THEN
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK  #No.7875
        IF g_argv2 != '4' THEN
           CALL s_auto_assign_no("agl",g_aba.aba01,g_aba.aba02,"","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094 
           RETURNING li_result,g_aba.aba01
        ELSE
           CALL s_auto_assign_no("agl",g_aba.aba01,g_aba.aba02,"B","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094 
           RETURNING li_result,g_aba.aba01
        END IF
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
           DISPLAY BY NAME g_aba.aba01
 
      INSERT INTO aba_file VALUES(g_aba.*)
      IF SQLCA.sqlcode THEN               #置入資料庫不成功
         CALL cl_err3("ins","aba_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","",1)  #No.FUN-660123     #FUN-B80096  ADD
         ROLLBACK WORK   #No.7875
        # CALL cl_err3("ins","aba_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","",1)  #No.FUN-660123    #FUN-B80096  MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK   #No.7875
      END IF
 
      LET g_aba_t.* = g_aba.*
      SELECT aba00 INTO g_aba.aba00 FROM aba_file
       WHERE aba00 = g_aba.aba00
         AND aba01 = g_aba.aba01
 
      LET g_rec_b = 0
 
      CALL t110_b('a')                   #輸入單身
 
      #-->馬上列印(Y/N)
      CALL cl_confirm('agl-042') RETURNING g_chr
 
      IF g_chr MATCHES '1' THEN
         CALL t110_out2()
       END IF  #No.MOD-4A0027 改為MATCHES '1'
 
      #no.3448 01/10/02 不須簽核是否直接確認
      IF g_aac.aacpass ='Y' AND g_aba.abamksg = 'N' THEN
         LET g_action_choice = "insert"            #FUN-640244
         CALL t110_y_chk()          #CALL 原確認的 check 段
         IF g_success = "Y" THEN
            CALL t110_y_upd()       #CALL 原確認的 update 段
         END IF
      END IF
 
      LET g_msg=''
      LET g_aba01_t = g_aba.aba01        #保留舊值
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t110_w()
 
   OPEN WINDOW t110_w2 AT 2,18
     WITH FORM "agl/42f/gglt110.4gl1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("gglt110.4gl1")
 
   INPUT BY NAME g_aba.aba13,g_aba.aba14,g_aba.aba15 WITHOUT DEFAULTS
 
      AFTER FIELD aba14
         IF NOT cl_null(g_aba.aba14) THEN
            IF g_aba.aba14 = '0' THEN
               LET INT_FLAG = 1
               EXIT INPUT
            END IF
            IF g_aba.aba14 NOT MATCHES "[123]" THEN
               NEXT FIELD aba14
            END IF
         END IF
 
      AFTER FIELD aba15
         IF NOT cl_null(g_aba.aba15) THEN
            SELECT aha01 FROM aha_file
             WHERE aha00 = g_aba.aba00
               AND aha000 = g_aba.aba14
               AND aha01 = g_aba.aba15
               AND ahaacti = 'Y'
               AND g_aba.aba02 BETWEEN aha05 AND aha06   #MOD-920373
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aha_file",g_aba.aba00,g_aba.aba15,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               NEXT FIELD aba15
            END IF
         END IF
 
      ON ACTION CONTROLP
         IF INFIELD(aba15) THEN
            CALL q_aha(FALSE,TRUE,g_aba.aba15,g_bookno,g_aba.aba14)
            RETURNING g_aba.aba15
            DISPLAY BY NAME g_aba.aba15
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t110_w2
      RETURN
   END IF
 
   UPDATE aba_file SET aba_file.* = g_aba.*
    WHERE aba00 = g_aba.aba00
      AND aba01 = g_aba.aba01
 
   DECLARE t110_c5 CURSOR FOR SELECT * FROM ahb_file
                               WHERE ahb00 = g_aba.aba00
                                 AND ahb000 = g_aba.aba14
                                 AND ahb01 = g_aba.aba15
 
   CASE
      WHEN g_aba.aba14 = '1'
         CALL t110_w1()   # 固定金額
      WHEN g_aba.aba14 = '2'
         CALL t110_w2()   # 固定比率
      WHEN g_aba.aba14 = '3'
         CALL t110_w3()   # 變動比率
   END CASE
 
   CLOSE WINDOW t110_w2
 
   DISPLAY BY NAME g_aba.aba08,g_aba.aba09
 
   CALL t110_b_fill('1=1')                 #單身
 
   LET g_action_choice = "detail"
 
   CALL t110_menu()
 
END FUNCTION
 
FUNCTION t110_w1()
   DEFINE l_ahb         RECORD LIKE ahb_file.*
   DEFINE l_amt         LIKE ahb_file.ahb07    #No.FUN-4C0009  #No.FUN-680098 decimal(20,6)
   DEFINE l_tot1,l_tot2 LIKE aba_file.aba13    #No.FUN-4C0009  #No.FUN-680098 decimal(20,6)
   DEFINE l_seq         LIKE type_file.num5    #No.FUN-680098  SMALLINT
   DEFINE l_seq1,l_seq2 LIKE type_file.num5    #No.FUN-680098  SMALLINT
 
   LET l_seq = 0
   LET l_tot1 = 0
   LET l_tot2 = 0
 
   SELECT MAX(abb02) INTO l_seq FROM abb_file
    WHERE abb00 = g_aba.aba00
      AND abb01 = g_aba.aba01
 
   IF cl_null(l_seq) THEN
      LET l_seq = 0
   END IF
 
   LET g_success = 'Y'
 
   BEGIN WORK
 
      FOREACH t110_c5 INTO l_ahb.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('t110_c5',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
 
         LET l_amt = l_ahb.ahb07
         LET l_amt = cl_digcut(l_amt,g_digit)
         LET l_seq = l_seq + 1
 
         MESSAGE " SEQ:",l_seq USING '###', " AMT:",l_amt
 
          INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                              abb06,abb07f,abb07,abb08,abb11,abb12,
                              abb13,abb14,
                              abb31,abb32,abb33,abb34,abb35,abb36,abb37,
 
                              abb24,abb25,abblegal)                           #No.FUN-810069  #FUN-980003 add abblegal
                      VALUES (g_aba.aba00,g_aba.aba01,l_seq,l_ahb.ahb03,
                              l_ahb.ahb04,l_ahb.ahb05,l_ahb.ahb06,l_amt,
                              l_amt,l_ahb.ahb08,l_ahb.ahb11,l_ahb.ahb12,
                              l_ahb.ahb13,l_ahb.ahb14,
                              
                              l_ahb.ahb31,l_ahb.ahb32,
                              l_ahb.ahb33,l_ahb.ahb34,
                              l_ahb.ahb35,l_ahb.ahb36,
                              l_ahb.ahb37,
 
                              g_aaa.aaa03,1,g_legal)                         #No.FUN-810069 #FUN-980003 add g_legal
 
         IF STATUS THEN
            CALL cl_err3("ins","abb_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","t110_w(ckp#4)",1)  #No.FUN-660123
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
 
      IF g_success = 'Y' THEN
         CALL t110_upamt()
      END IF
 
      MESSAGE ''
 
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
         LET g_aba.aba08 = 0
         LET g_aba.aba09 = 0
      END IF
 
END FUNCTION
 
FUNCTION t110_w2()
   DEFINE l_ahb         RECORD LIKE ahb_file.*
   DEFINE l_amt         LIKE ahb_file.ahb07   #No.FUN-4C0009 #No.FUN-680098 decimal(20,6)
   DEFINE l_tot1,l_tot2 LIKE aba_file.aba13   #No.FUN-4C0009 #No.FUN-680098 decimal(20,6)
   DEFINE l_seq         LIKE type_file.num5   #No.FUN-680098 SMALLINT
   DEFINE l_seq1,l_seq2 LIKE type_file.num5   #No.FUN-680098 SMALLINT
   DEFINE l_deb,l_crd   LIKE aba_file.aba13   #CHI-680026
 
   LET l_seq = 0
   SELECT MAX(abb02) INTO l_seq FROM abb_file
    WHERE abb00 = g_aba.aba00
      AND abb01 = g_aba.aba01
 
   IF l_seq IS NULL THEN
      LET l_seq = 0
   END IF
 
   LET l_tot1 = 0
   LET l_tot2 = 0
   LET g_success = 'Y'
 
   BEGIN WORK
 
   FOREACH t110_c5 INTO l_ahb.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t110_c5',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      SELECT SUM(ahb07),COUNT(*) INTO l_deb FROM ahb_file#計算借方比率總合
                        WHERE ahb00 = l_ahb.ahb00 AND
                              ahb000 = l_ahb.ahb000 AND
                              ahb01 = l_ahb.ahb01 AND
                              ahb06 = '1'
      IF SQLCA.sqlcode OR l_deb IS NULL THEN LET l_deb = 0 END IF
      SELECT SUM(ahb07),COUNT(*) INTO l_crd FROM ahb_file#計算貸方比率總合
                        WHERE ahb00 = l_ahb.ahb00 AND
                              ahb000 = l_ahb.ahb000 AND
                              ahb01 = l_ahb.ahb01 AND
                              ahb06 = '2'
      IF SQLCA.sqlcode OR l_crd IS NULL THEN LET l_crd = 0 END IF
      
      IF l_ahb.ahb06 = '1' THEN
         LET l_amt = g_aba.aba13 * l_ahb.ahb07/l_deb
      ELSE
         LET l_amt = g_aba.aba13 * l_ahb.ahb07/l_crd
      END IF
      LET l_amt = cl_digcut(l_amt,g_digit)
      LET l_seq = l_seq + 1
      IF l_ahb.ahb06 = '1' THEN
         LET l_tot1 = l_tot1 + l_amt
         LET l_seq1 = l_seq
      ELSE
         LET l_tot2 = l_tot2 + l_amt
         LET l_seq2 = l_seq
      END IF
 
      MESSAGE " SEQ:",l_seq USING '###'," AMT:",l_amt
 
       INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                           abb06,abb07f,abb07,abb08,abb11,abb12,
                           abb13,abb14,
 
                           abb31,abb32,abb33,abb34,abb35,abb36,abb37,
 
                           abb24,abb25,abblegal)                           #No.FUN-810069 #FUN-980003 add abblegal
                   VALUES (g_aba.aba00,g_aba.aba01,l_seq,l_ahb.ahb03,l_ahb.ahb04,
                           l_ahb.ahb05,l_ahb.ahb06,l_amt,l_amt,l_ahb.ahb08,
                           l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,l_ahb.ahb14,
 
                           l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                           l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
                           g_aaa.aaa03,1,g_legal)                         #No.FUN-810069 #FUN-980003 add g_legal
      
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","abb_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","t110_w(ckp#4)",1)  #No.FUN-660123
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF l_tot1 != g_aba.aba13 AND g_success = 'Y' THEN    # Debit 差異調整
      LET l_amt = g_aba.aba13 - l_tot1
      UPDATE abb_file SET abb07 = abb07 + l_amt,
                          abb07f= abb07 + l_amt         #No.7767
       WHERE abb00 = g_aba.aba00
         AND abb01 = g_aba.aba01
         AND abb02 = l_seq1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","abb_file",g_aba.aba01,l_seq1,SQLCA.sqlcode,"","t110_w(ckp#5)",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
   END IF
 
   IF l_tot2 != g_aba.aba13 AND g_success = 'Y' THEN    # Credit 差異調整
      LET l_amt = g_aba.aba13 - l_tot2
      UPDATE abb_file SET abb07 = abb07 + l_amt,
                          abb07f= abb07 + l_amt         #No.7767
       WHERE abb00 = g_aba.aba00
         AND abb01 = g_aba.aba01
         AND abb02 = l_seq2
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","abb_file",g_aba.aba01,l_seq2,SQLCA.sqlcode,"","t110_w(ckp#6)",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
   END IF
 
   CALL t110_upamt()
 
   MESSAGE ''
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      LET g_aba.aba08 = 0
      LET g_aba.aba09 = 0
   END IF
 
END FUNCTION
 
FUNCTION t110_w3()
   DEFINE l_ahb         RECORD LIKE ahb_file.*
   DEFINE l_amt         LIKE abb_file.abb07   #No.FUN-4C0009 #No.FUN-680098 DECIMAL(20,6)
   DEFINE l_tot1,l_tot2 LIKE aba_file.aba13   #No.FUN-4C0009 #No.FUN-680098 DECIAML(20,6)
   DEFINE l_seq         LIKE type_file.num5    #No.FUN-680098 SMALLINT
   DEFINE l_seq1,l_seq2 LIKE type_file.num5    #No.FUN-680098 SMALLINT
   DEFINE l_amtarr ARRAY[50] OF    LIKE type_file.num20_6 #No.FUN-4C0009 #No.FUN-680098 DECIMAL(20,6)
   DEFINE l_amt_debit,l_amt_credit LIKE type_file.num20_6 #No.FUN-4C0009  #No.FUN-680098 DECIMAL(20,6)
   DEFINE l_rate            LIKE csd_file.csd04  #No.FUN-680098   DECIMAL(15,3)
   DEFINE l_aag04           LIKE aag_file.aag04  #No.FUN-680098  VARCHAR(1)
 
   LET g_success = 'Y'
   BEGIN WORK
   LET l_seq = 0
   SELECT MAX(abb02) INTO l_seq FROM abb_file
    WHERE abb00 = g_aba.aba00
      AND abb01 = g_aba.aba01
 
   IF cl_null(l_seq) THEN
      LET l_seq = 0
   END IF
 
   LET l_amt_debit = 0
   LET l_amt_credit = 0
 
   FOREACH t110_c5 INTO l_ahb.*           # 先得基礎科目餘額
      IF SQLCA.sqlcode THEN
         CALL cl_err('t110_c5',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
 
      SELECT aag04 INTO l_aag04 FROM aag_file
       WHERE aag01 = l_ahb.ahb16
         AND aag00 = g_bookno    #No.FUN-740020
         AND aagacti = 'Y'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","aag_file",l_ahb.ahb16,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123 
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      #No.B598 010529 by linda add 若部門編號存在則讀取部門科目餘額檔
      IF l_ahb.ahb05 IS NOT NULL THEN
         IF l_aag04 = '1' THEN  #資產類
            SELECT SUM(aao05-aao06) INTO l_amt FROM aao_file
             WHERE aao00 = g_bookno
               AND aao01 = l_ahb.ahb16
               AND aao02 = l_ahb.ahb05
               AND aao03 = g_aba.aba03
               AND aao04 <= g_aba.aba04
         ELSE  #損益類
            SELECT SUM(aao05-aao06) INTO l_amt FROM aao_file
             WHERE aao00 = g_bookno
               AND aao01 = l_ahb.ahb16
               AND aao02 = l_ahb.ahb05
               AND aao03 = g_aba.aba03
               AND aao04 = g_aba.aba04
         END IF
      ELSE
         IF l_aag04 = '1' THEN
            SELECT SUM(aah04-aah05) INTO l_amt FROM aah_file
             WHERE aah00 = g_bookno
               AND aah01 = l_ahb.ahb16
               AND aah02 = g_aba.aba03
               AND aah03 <= g_aba.aba04
         END IF
 
         IF l_aag04 = '2' THEN
            SELECT SUM(aah04-aah05) INTO l_amt FROM aah_file
             WHERE aah00 = g_bookno
               AND aah01 = l_ahb.ahb16
               AND aah02 = g_aba.aba03
               AND aah03 = g_aba.aba04
         END IF
      END IF   #No.B598
 
      IF SQLCA.sqlcode OR l_amt IS NULL THEN
         LET l_amt = 0.001
      END IF
 
      LET l_seq = l_seq + 1
      LET l_amtarr[l_seq] = l_amt
 
      IF l_ahb.ahb06 = '1' THEN
         LET l_amt_debit  = l_amt_debit  + l_amt
      ELSE
         LET l_amt_credit = l_amt_credit + l_amt
      END IF
   END FOREACH
 
   LET l_seq = 0
 
   SELECT MAX(abb02) INTO l_seq FROM abb_file
    WHERE abb01 = g_aba.aba01
 
   IF l_seq IS NULL THEN
      LET l_seq = 0
   END IF
 
   LET l_tot1 = 0
   LET l_tot2 = 0
 
   #-->再算分攤比率
   FOREACH t110_c5 INTO l_ahb.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('t110_c5',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
         LET l_seq = l_seq + 1
         IF l_ahb.ahb06 = '1' THEN
             LET l_amt = g_aba.aba13 * l_amtarr[l_seq] / l_amt_debit     #MOD-750020
         ELSE
             LET l_amt = g_aba.aba13 * l_amtarr[l_seq] / l_amt_credit    #MOD-750020
         END IF
         LET l_amt = cl_digcut(l_amt,g_digit)
         IF l_ahb.ahb06 = '1'
            THEN LET l_tot1 = l_tot1 + l_amt
                 LET l_seq1 = l_seq
            ELSE LET l_tot2 = l_tot2 + l_amt
                 LET l_seq2 = l_seq
         END IF
         MESSAGE " SEQ:",l_seq USING '###'," AMT:",l_amt
          INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,  #No.MOD-470041
                              abb06,abb07f,abb07,abb08,abb11,abb12,
                              abb13,abb14,
 
                              abb31,abb32,abb33,abb34,abb35,abb36,abb37,
 
                              abb24,abb25,abblegal)                           #No.FUN-810069   #FUN-980003 add abblegal
              VALUES (g_aba.aba00,g_aba.aba01,l_seq,l_ahb.ahb03,l_ahb.ahb04,
                      l_ahb.ahb05,l_ahb.ahb06,l_amt,l_amt,l_ahb.ahb08,
                      l_ahb.ahb11,l_ahb.ahb12,l_ahb.ahb13,l_ahb.ahb14,
 
                      l_ahb.ahb31,l_ahb.ahb32,l_ahb.ahb33,l_ahb.ahb34,
                      l_ahb.ahb35,l_ahb.ahb36,l_ahb.ahb37,
 
                      l_ahb.ahb15,g_aaa.aaa03,1,g_legal) #FUN-980003 add g_legal
         IF STATUS THEN
            CALL cl_err3("ins","abb_file",g_aba.aba01,l_seq,SQLCA.sqlcode,"","t110_w(ckp#4)",1)  #No.FUN-660123
            LET g_success = 'N'
            EXIT FOREACH
         END IF
   END FOREACH
   IF l_tot1 != g_aba.aba13 AND g_success = 'Y' THEN    # Debit 差異調整
      LET l_amt = g_aba.aba13 - l_tot1
      UPDATE abb_file SET abb07 = abb07 + l_amt,
                          abb07f= abb07 + l_amt  #No.7767
       WHERE abb00 = g_aba.aba00 AND abb01 = g_aba.aba01
         AND abb02 = l_seq1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","abb_file",g_aba.aba01,l_seq1,SQLCA.sqlcode,"","t110_w(ckp#5)",1)  #No.FUN-660123
            LET g_success = 'N'
         END IF
   END IF
   IF l_tot2 != g_aba.aba13 AND g_success = 'Y' THEN    # Debit 差異調整
      LET l_amt = g_aba.aba13 - l_tot2
      UPDATE abb_file SET abb07 = abb07 + l_amt,
                          abb07f= abb07 + l_amt  #No.7767
       WHERE abb00 = g_aba.aba00 AND abb01 = g_aba.aba01
         AND abb02 = l_seq2
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","abb_file",g_aba.aba01,l_seq2,SQLCA.sqlcode,"","t110_w(ckp#5)",1)  #No.FUN-660123
            LET g_success = 'N'
         END IF
   END IF
   CALL t110_upamt()
   MESSAGE ''
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK LET g_aba.aba08 = 0 LET g_aba.aba09 = 0
   END IF
END FUNCTION
 
FUNCTION t110_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aba.aba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00=g_aba.aba00
                                          AND aba01=g_aba.aba01
    IF g_aba.abaacti ='N' THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_aba.abapost ='Y' THEN CALL cl_err('post=Y','agl-010',0) RETURN END IF
    IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_aba.aba19 = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
     IF g_aba.aba20 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    #-->非應計(來源碼)輸入則不可刪除
    IF g_argv2 = '3' THEN
      IF g_aba.aba06 != 'AC'  THEN
         CALL cl_err(g_aba.aba01,'agl-011',0)
         RETURN
       END IF
    END IF
 
    SELECT UNIQUE amd01 FROM amd_file
     WHERE amd01 = g_aba.aba01 AND amd26 IS NOT NULL # 表已申報
    IF STATUS = 0 THEN
       CALL cl_err3("sel","FROM",g_aba.aba01,"","agl-204","","",1)  #No.FUN-660123
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aba01_t = g_aba.aba01
    LET g_aba_o.* = g_aba.*
    BEGIN WORK
    OPEN t110_cl USING g_aba.aba00,g_aba.aba01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_aba.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    CALL t110_show()
    WHILE TRUE
        LET g_aba01_t = g_aba.aba01
        LET g_aba02_t = g_aba.aba02
        LET g_aba.abamodu=g_user
        LET g_aba.abadate=g_today
        CALL t110_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aba.*=g_aba_t.*
            CALL t110_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_aba.aba02 != g_aba02_t THEN            # 更改日期
           UPDATE abg_file SET abg06 = g_aba.aba02
                         WHERE abg00 = g_aba.aba00 AND abg01 = g_aba01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","abg_file",g_aba01_t,g_aba.aba00,SQLCA.sqlcode,"","abg",1)  #No.FUN-660123
                CONTINUE WHILE 
            END IF
           UPDATE abh_file SET abh021 = g_aba.aba02
                         WHERE abh00 = g_aba.aba00 AND abh01 = g_aba01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","abh_file",g_aba.aba00,g_aba01_t,SQLCA.sqlcode,"","abh",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
        END IF
        IF g_aba.aba01 != g_aba01_t THEN            # 更改單號
            UPDATE abb_file SET abb01 = g_aba.aba01
                WHERE abb00 = g_aba.aba00
                  AND abb01 = g_aba01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","abb_file",g_aba.aba00,g_aba01_t,SQLCA.sqlcode,"","abb",1)  #No.FUN-660123
                CONTINUE WHILE 
            END IF
            UPDATE abc_file SET abc01 = g_aba.aba01
                WHERE abc00 = g_aba.aba00
                  AND abc01 = g_aba01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","abc_file", g_aba.aba00,g_aba01_t,SQLCA.sqlcode,"","abc",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
            UPDATE abg_file SET abg01 = g_aba.aba01
                WHERE abg00 = g_aba.aba00
                  AND abg01 = g_aba01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","abg_file",g_aba.aba00,g_aba01_t,SQLCA.sqlcode,"","abg",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
            LET g_errno = TIME
            LET g_msg = 'Chg No:',g_aba.aba01
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal
                 VALUES('gglt110.4gl',g_user,g_today,g_errno,g_aba01_t,g_msg,g_plant,g_legal) #FUN-980003 add g_plant,g_legal
        END IF
         LET g_aba.aba20 = '0'        #MOD-4A0299
        UPDATE aba_file SET aba_file.* = g_aba.*
            WHERE aba00 = g_aba.aba00 AND aba01 = g_aba01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aba_file",g_aba01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        IF g_aac.aac03 MATCHES "[12]" THEN
           UPDATE abb_file SET abb03 = g_aba.aba10
                  WHERE abb00=g_aba.aba00 AND abb01=g_aba.aba01 AND abb02=0
        END IF
         DISPLAY BY NAME g_aba.aba20              #MOD-4A0299
        IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_aba.aba20='1' OR
           g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
 
        EXIT WHILE
    END WHILE
    CLOSE t110_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t110_i(p_cmd)
DEFINE li_result    LIKE type_file.num5     #No.FUN-560014 #No.FUN-680098 SMALLINT
DEFINE
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入#No.FUN-680098 VARCHAR(1)
    l_azn02         LIKE azn_file.azn02,
    l_azn04         LIKE azn_file.azn04,
    l_aag07         LIKE aag_file.aag07,
    l_n             LIKE type_file.num5,     #No.FUN-680098 SMALLINT
    p_cmd           LIKE type_file.chr1,    #No.FUN-680098 VARCHAR(1) #a:輸入 u:更改
    l_aba21         STRING                  #No.MOD-6B0149
DEFINE  l_aba01     LIKE aba_file.aba01     #MOD-8B0281
DEFINE l_yy1        LIKE type_file.num5     #CHI-CB0004
DEFINE l_mm1        LIKE type_file.num5     #CHI-CB0004
 
    #判斷傳票日期不可小於關帳日期
    IF g_argv2!='4' THEN
       IF g_aba.aba02 <= g_aaa.aaa07 THEN
           CALL cl_err('','agl-085',0)
          IF p_cmd='u' THEN RETURN END IF
       END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT UNIQUE amd01 FROM amd_file
        WHERE amd01 = g_aba.aba01 AND amd26 IS NOT NULL # 表已申報
       IF STATUS = 0 THEN
          CALL cl_err3("sel","amd_file",g_aba.aba01,"","agl-204","","",1)  #No.FUN-660123
          RETURN
       END IF
    END IF
    LET g_aba.aba00 = g_bookno
    DISPLAY BY NAME g_aba.aba08,g_aba.aba09,g_aba.abapost,g_aba.abaprno,g_aba.aba35
    DISPLAY BY NAME g_aba.aba03,g_aba.aba04,g_aba.aba18   #No.B467 add
    CALL s_pmksta('pmk',g_aba.aba20,'Y','Y') RETURNING g_sta
    DISPLAY g_sta TO FORMONLY.desc2
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT BY NAME 
        g_aba.aba01,g_aba.aba02,g_aba.aba03,g_aba.aba04,
        g_aba.aba06,g_aba.aba11,g_aba.aba19,g_aba.abapost,
        g_aba.aba35,g_aba.aba20,g_aba.abamksg,g_aba.abasign,
        g_aba.aba05,g_aba.aba24,g_aba.aba18,g_aba.aba10,
        g_aba.aba21,g_aba.aba07,g_aba.abaprno,
        g_aba.aba31,g_aba.aba32,g_aba.aba33,g_aba.aba34,
        g_aba.abagrup,g_aba.abamodu,g_aba.abaoriu,g_aba.abaorig,
        g_aba.abadate,g_aba.abaacti,
        g_aba.abauser,
        g_aba.abaud01,g_aba.abaud02,g_aba.abaud03,g_aba.abaud04,
        g_aba.abaud05,g_aba.abaud06,g_aba.abaud07,g_aba.abaud08,
        g_aba.abaud09,g_aba.abaud10,g_aba.abaud11,g_aba.abaud12,
        g_aba.abaud13,g_aba.abaud14,g_aba.abaud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t110_set_entry(p_cmd)
            CALL t110_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            IF g_aza.aza26 = '2' AND g_aza.aza48 = 'Y' THEN
               CALL cl_set_comp_required("aba21",TRUE)
            END IF
            CALL cl_set_docno_format("aba01")
 
        BEFORE FIELD aba01
           CALL t110_set_entry(p_cmd)
 
        AFTER FIELD aba01
         IF NOT cl_null(g_aba.aba01) AND ((g_aba.aba01 != g_aba_t.aba01) OR 
                                          g_aba_t.aba01 IS NULL) THEN       #MOD-5B0098      #MOD-780003
            CALL s_check_no("agl",g_aba.aba01,g_aba_t.aba01,"*","aba_file", "aba01","")  #FUN-570024
            RETURNING li_result,g_aba.aba01
            DISPLAY BY NAME g_aba.aba01
            IF (NOT li_result) THEN
                LET g_aba.aba01 = g_aba_o.aba01
                NEXT FIELD aba01
            END IF
 
                LET g_t1 = s_get_doc_no(g_aba.aba01)
              CASE g_argv2
                   WHEN '1'
                        SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
                            WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='1'
                   WHEN '3'
                        SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
                            WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='3'
                 ##當p_prog='gglt140'時，g_argv2='4'
                 ##因gglt140也有走簽核流程，所以要讀取單據性質資料以用來判斷單據是否要走簽核
                   WHEN '4'
                        SELECT * INTO g_aac.* FROM aac_file
                         WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='B'
              END CASE
 
#取消mark
              IF SQLCA.sqlcode THEN             #抱歉, 讀不到
                   CALL cl_err(g_t1,"agl-035",0) #無此單別   
                  LET g_aba.aba01 = g_aba_o.aba01
                  DISPLAY BY NAME g_aba.aba01
                  NEXT FIELD aba01
              END IF
               #add 不可使用系統使用之應計調整及結轉單別
               IF g_t1 = g_aaz.aaz65 OR g_t1=g_aaz.aaz68 THEN
                   CALL cl_err(g_t1,"agl-191",0)
                   LET g_aba.aba01 = g_aba_o.aba01
                   DISPLAY BY NAME g_aba.aba01
                   NEXT FIELD aba01
               END IF
               IF g_aba_t.aba01 IS NULL OR
                  (g_aba.aba01 != g_aba_t.aba01 ) THEN
                   LET  g_aba.abamksg = g_aac.aac08
                   LET  g_aba.abasign = g_aac.aacsign
                   #-->若為轉帳性質則不預設收支科目
                   IF g_aac.aac03 = '0' THEN
                      LET g_aba.aba10 = ' '
                   ELSE
                      LET g_aba.aba10   = g_aac.aac04
                   END IF
                   DISPLAY BY NAME g_aba.abamksg
                   DISPLAY BY NAME g_aba.aba10
               END IF
               IF cl_null(g_aac.aac13) THEN LET g_aac.aac13 = 'N' END IF
               DISPLAY g_aac.aac13 TO FORMONLY.aac13
            END IF
            CALL t110_set_no_entry(p_cmd)
            
        AFTER FIELD aba02
           IF NOT cl_null(g_aba.aba02) THEN
               IF g_aza.aza63 = 'Y' THEN
                  SELECT aznn02,aznn04 INTO l_azn02,l_azn04  FROM aznn_file
                       WHERE aznn01 = g_aba.aba02 AND aznn00 = g_aba.aba00
               ELSE
                  SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                       WHERE azn01 = g_aba.aba02
               END IF  #No.MOD-7A0131
               IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL
                THEN 
                 CALL cl_err3("sel","azn_file",g_aba.aba02,"","agl-022","","",1)  #No.FUN-660123
                 NEXT FIELD aba02 
               ELSE LET g_aba.aba03 = l_azn02
                    LET g_aba.aba04 = l_azn04
               END IF
               IF g_aba.aba02 <= g_aaa.aaa07 THEN
                    CALL cl_err('','agl-086',0)
                    NEXT FIELD aba02
               END IF
               DISPLAY BY NAME g_aba.aba03,g_aba.aba04
               LET g_aba_o.aba02 = g_aba.aba02
            END IF
 
        AFTER FIELD aba21
            IF g_aba.aba21 <= 0 THEN
               CALL cl_err(' ', "agl-217",0)
               NEXT FIELD aba21
            END IF 
            LET l_aba21 = g_aba.aba21
            LET l_aba21 = l_aba21.trim()
            FOR g_i=1 TO l_aba21.getLength()
               IF l_aba21.subString(g_i,g_i) NOT MATCHES "[0123456789]" THEN
                  NEXT FIELD aba21
               END IF
            END FOR
 
        AFTER FIELD aba24
            IF NOT cl_null(g_aba.aba24) THEN
               CALL t110_aba24('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_aba.aba24 = g_aba_t.aba24
                  CALL cl_err(g_aba.aba24,'mfg1312',0)                     # No.TQC-750041   #TQC-7C0152
                  DISPLAY BY NAME g_aba.aba24 #
                  NEXT FIELD aba24
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
       
       AFTER FIELD aba11
           IF NOT cl_null(g_aba.aba11) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_aba.aba11!=g_aba_t.aba11) THEN
                 SELECT COUNT(*) INTO l_n FROM aba_file
                   WHERE aba11=g_aba.aba11
                     AND aba00=g_aba.aba00 #no.7277
                 IF l_n>0 THEN
                      CALL cl_err(g_aba.aba11,-239,0)
                      NEXT FIELD aba11
                 END IF
              END IF
           END IF
 
        AFTER FIELD aba10 #收支科目
            IF NOT cl_null(g_aba.aba10) THEN
               CALL t110_aba10(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  #No.FUN-B10050  --Begin
                  #LET g_aba.aba10 = g_aba_o.aba10
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_aba.aba10
                  LET g_qryparam.arg1 = g_bookno
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_aba.aba10 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_aba.aba10
                  #No.FUN-B10050  --End  
                  DISPLAY BY NAME g_aba.aba10
                  NEXT FIELD aba10
               END IF
            END IF
 
        AFTER FIELD abamksg    #簽核否
            IF NOT cl_null(g_aba.abamksg)  THEN
               IF g_aba.abamksg MATCHES'[NnYy]'
                 THEN LET g_aba.abasmax = 0
                      LET g_aba.abasseq = 0
                 ELSE LET g_aba.abamksg = g_aba_o.abamksg
                      DISPLAY BY NAME g_aba.abamksg
                      NEXT FIELD abamksg
               END IF
            END IF
 
        AFTER FIELD abaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aba.abauser = s_get_data_owner("aba_file") #FUN-C10039
           LET g_aba.abagrup = s_get_data_group("aba_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            #判斷傳票日期不可小於關帳日期
            IF g_argv2!='4' THEN
               IF g_aba.aba02 <= g_aaa.aaa07 THEN
                   CALL cl_err('','agl-085',0)
                   NEXT FIELD aba02
               END IF
            END IF
            IF g_aaz.aaz81='Y' THEN #MOD-9A0081    
               IF cl_null(g_aba.aba11) THEN
                  LET l_yy1 = YEAR(g_aba.aba02)    #CHI-CB0004
                  LET l_mm1 = MONTH(g_aba.aba02)   #CHI-CB0004
                  SELECT MAX(aba11)+1 INTO g_aba.aba11 FROM aba_file
                   WHERE aba00 = g_aba.aba00 #no.7727
                     AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
                     AND aba19 <> 'X' #CHI-C80041
                 #CHI-CB0004--(B)
                  IF cl_null(g_aba.aba11) OR g_aba.aba11 = 1 THEN
                     LET g_aba.aba11 = YEAR(g_aba.aba02)*1000000+MONTH(g_aba.aba02)*10000+1
                  END IF
                 #CHI-CB0004--(E)
                 #IF cl_null(g_aba.aba11) THEN LET g_aba.aba11 = 1 END IF  #CHI-CB0004
                  DISPLAY BY NAME g_aba.aba11
               END IF
            END IF #MOD-9A0081       
            IF cl_null(g_aba.aba10) AND g_aac.aac03 != '0' THEN
               CALL t110_aba10(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_aba.aba10 = g_aba_o.aba10
                  DISPLAY BY NAME g_aba.aba10
                  NEXT FIELD aba10
               END IF
            END IF
 
        ON ACTION maintain_account_details
           CASE WHEN INFIELD(aba10) CALL cl_cmdrun('agli102' CLIPPED)
           END CASE
 
       ON ACTION get_missing_voucher_no
          IF cl_null(g_aba.aba01) THEN
             NEXT FIELD aba01
          END IF
          IF cl_null(g_aba.aba02) THEN
             NEXT FIELD aba02
          END IF
          LET l_aba01= NULL 
          DELETE FROM agl_tmp_file
          CALL s_agl_missingno1(g_plant,g_dbs,g_bookno,g_aba.aba01,g_aba.aba02,0)
          CALL t110_agl_missingno_show(g_plant)
          RETURNING l_aba01
          IF NOT cl_null(l_aba01) THEN 
             LET g_aba.aba01 = l_aba01
          END IF 
          DISPLAY BY NAME g_aba.aba01  
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aba01) #單據性質
                  IF g_aaz.aaz70 MATCHES '[yY]' THEN
                     IF g_argv2 != '4' THEN
                        CALL q_aac(FALSE,TRUE,g_aba.aba01,g_argv2,' ',g_user,'AGL')   #TQC-670008
                        RETURNING g_aba.aba01
                     ELSE
                        CALL q_aac(FALSE,TRUE,g_aba.aba01,'B',' ',g_user,'AGL')  #TQC-670008  
                        RETURNING g_aba.aba01
                     END IF
                  ELSE
                     IF g_argv2 != '4' THEN
                        CALL q_aac(FALSE,TRUE,g_aba.aba01,g_argv2,' ',' ','AGL')  #TQC-670008
                        RETURNING g_aba.aba01
                     ELSE
                        CALL q_aac(FALSE,TRUE,g_aba.aba01,'B',' ',' ','AGL')  #TQC-670008    
                        RETURNING g_aba.aba01
                     END IF
                  END IF
                    DISPLAY  BY NAME g_aba.aba01
                    NEXT FIELD aba01
               WHEN INFIELD(aba10) #收支科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_aag"
                    LET g_qryparam.default1 = g_aba.aba10
                    LET g_qryparam.arg1 = g_bookno   #No.FUN-740020
                    LET g_qryparam.where =" aag07 IN ('2','3') AND aag03 IN ('2') "
                    CALL cl_create_qry() RETURNING g_aba.aba10
                    DISPLAY BY NAME g_aba.aba10
                    NEXT FIELD aba10
               WHEN INFIELD(aba24)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_aba.aba24
                    CALL cl_create_qry() RETURNING g_aba.aba24
                    DISPLAY BY NAME g_aba.aba24
                    NEXT FIELD aba24
 
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
 
FUNCTION t110_set_entry(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
    CALL cl_set_comp_entry("aba02,aba24,aba31,aba32,aba33,aba34",TRUE)   #MOD-830053
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aba01",TRUE)
    END IF
    IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("aba11",TRUE)
       CALL cl_set_comp_entry("aba02",TRUE)   #FUN-570024
    END IF
    IF INFIELD(aba01) THEN
       CALL cl_set_comp_entry("aba10",TRUE)
    END IF
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
    IF g_aba.aba06 <> 'GL' AND g_aba.aba06 <> 'AC' AND g_aba.aba06 <> 'AD' THEN   #TQC-670044
       CALL cl_set_comp_entry("aba02,aba24,aba31,aba32,aba33,aba34",FALSE)   #MOD-810106
    END IF
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aba01",FALSE)
    END IF
    IF NOT g_before_input_done THEN
       IF g_aaz.aaz81 = 'N' OR cl_null(g_aaz.aaz81) THEN
          CALL cl_set_comp_entry("aba11",FALSE)
       END IF
    END IF
    IF (g_aba.aba06!= 'GL' AND g_aba.aba06!='VP' AND
       g_aba.aba06!='FC' AND g_aba.aba06 != 'FP' AND
       g_aba.aba06 <> 'AC') THEN
       CALL cl_set_comp_entry("aba11,aba10",FALSE)
    END IF
    IF INFIELD(aba01) THEN
       IF g_aac.aac03 = '0' THEN
          CALL cl_set_comp_entry("aba10",FALSE)
       END IF
    END IF
    IF g_argv2 ='4' THEN
       CALL cl_set_comp_entry("aba02",FALSE)
    END IF
END FUNCTION
 
FUNCTION  t110_aba10(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1)
    l_aac03         LIKE aac_file.aac03,
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aag09         LIKE aag_file.aag09,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aac03 INTO l_aac03 FROM aac_file
     WHERE aac01=g_t1
 
    SELECT aag02,aag03,aag07,aag09,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
      FROM aag_file
     WHERE aag01 = g_aba.aba10
       AND aag00 = g_bookno   #No.FUN-740020
 
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07 = '1'       LET g_errno = 'agl-015'
         OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
 
    IF l_aac03="1" OR l_aac03="2" THEN
       CASE
          WHEN l_aag09="N"
             LET g_errno="agl-214"
          WHEN l_aag03="4"
             LET g_errno="agl-177"
          WHEN l_aag07="1"
             LET g_errno="agl-015"
       END CASE
    END IF
 
    DISPLAY l_aag02 TO aag021
 
END FUNCTION
 
FUNCTION t110_sign()  #簽核等級相關欄位
 
    LET g_chr=' '
    SELECT COUNT(*) INTO g_aba.abasmax
        FROM azc_file
        WHERE azc01=g_aba.abasign
    IF SQLCA.sqlcode OR
       g_aba.abasmax=0 OR
       g_aba.abasmax IS NULL THEN
       LET g_chr='E'
       LET g_aba.abasign=g_aba_t.abasign
    END IF
END FUNCTION
#Query 查詢
 
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_msg("")                          #FUN-640184
 
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_abb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL s_shwact(3,2,g_bookno)
    CALL t110_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL cl_msg(" SEARCHING! ")                       #FUN-640184
 
    OPEN t110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aba.* TO NULL
    ELSE
        OPEN t110_count
        FETCH t110_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640184
 
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t110_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1) #處理方式
    l_n       LIKE type_file.num10,   #No.FUN-680098  INTEGER,
    l_abso    LIKE type_file.num10    #No.FUN-680098  INTEGER #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t110_cs INTO g_aba.aba01,g_aba.aba00
        WHEN 'P' FETCH PREVIOUS t110_cs INTO g_aba.aba01,g_aba.aba00
        WHEN 'F' FETCH FIRST    t110_cs INTO g_aba.aba01,g_aba.aba00
        WHEN 'L' FETCH LAST     t110_cs INTO g_aba.aba01,g_aba.aba00
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
          FETCH ABSOLUTE g_jump t110_cs INTO g_aba.aba01,g_aba.aba00
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)
        INITIALIZE g_aba.* TO NULL               #No.FUN-6B0040
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
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00 = g_aba.aba00 AND aba01 = g_aba.aba01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","aba_file",g_aba.aba01,g_aba.aba02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_aba.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_aba.abauser     #No.FUN-4C0048
       LET g_data_group = g_aba.abagrup     #No.FUN-4C0048
       CALL t110_show()
       SELECT count(*) INTO l_n FROM aag_file                                                                               
        WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file                                                          
                                         WHERE abb01 = g_aba.aba01
                                           AND abb00 = g_bookno) #No.MOD-7A0131
          AND aag00 = g_bookno    #No.FUN-740020
       IF l_n = 0 THEN
          CALL cl_set_comp_visible("aba35,aba36",FALSE)
          CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",FALSE)
       ELSE
          IF g_aza48 = 'Y' THEN
             CALL cl_set_comp_visible("aba35,aba36",TRUE)
             CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",TRUE)
          END IF
       END IF
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t110_show()
    DEFINE l_aag02 LIKE aag_file.aag02
DEFINE l_str        STRING
 
    LET g_aba_t.* = g_aba.*                #保存單頭舊值
    CALL s_shwact(3,2,g_bookno)
    DISPLAY BY NAME g_aba.abaoriu,g_aba.abaorig,                        # 顯示單頭值
        g_aba.aba01,g_aba.aba18,g_aba.aba02,g_aba.aba03,
        g_aba.aba04,g_aba.abauser,g_aba.aba24,g_aba.aba06,g_aba.aba07,g_aba.aba21, #FUN-630029
        g_aba.aba08,g_aba.aba09,g_aba.aba10,g_aba.abamksg,g_aba.abasign,
        g_aba.aba35,g_aba.aba36,                                      #FUN-630066
        g_aba.abapost,g_aba.aba37,g_aba.aba11, g_aba.abaprno,         #FUN-630066
        g_aba.aba19,g_aba.aba38,g_aba.aba20,g_aba.aba05,g_aba.aba31,g_aba.aba32,g_aba.aba33,g_aba.aba34,   #FUN-630066
        g_aba.abagrup,g_aba.abamodu,
        g_aba.abadate,g_aba.abaacti
        ,g_aba.abaud01,g_aba.abaud02,g_aba.abaud03,g_aba.abaud04,
        g_aba.abaud05,g_aba.abaud06,g_aba.abaud07,g_aba.abaud08,
        g_aba.abaud09,g_aba.abaud10,g_aba.abaud11,g_aba.abaud12,
        g_aba.abaud13,g_aba.abaud14,g_aba.abaud15 

    CALL s_pmksta('pmk',g_aba.aba20,'Y','Y') RETURNING g_sta
    DISPLAY g_sta TO FORMONLY.desc2
    LET l_aag02=' '
    SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_aba.aba10
                                              AND aag00=g_bookno  #No.FUN-740020
    DISPLAY l_aag02 TO aag021
 
    LET g_t1 = s_get_doc_no(g_aba.aba01)     #No.FUN-560014
    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
    WHERE aac01=g_t1 AND aacacti = 'Y'

    IF cl_null(g_aac.aac13) THEN LET g_aac.aac13 = 'N' END IF
    DISPLAY g_aac.aac13 TO FORMONLY.aac13
    CALL t110_body_init(g_aac.aac13)
    LET l_str = s_sayc2(g_aba.aba08,50)
    DISPLAY l_str TO FORMONLY.tot

    IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_aba.aba20='1' OR
       g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
    CALL t110_aba24('d')                      #FUN-630029  
    CALL t110_b_fill(g_wc2)                     #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_argv2!='4' THEN
       IF g_aba.aba02 <= g_aaa.aaa07 THEN
           CALL cl_err('','agl-085',0)
           RETURN
       END IF
    END IF
    IF g_aba.aba01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_aba.aba19 ='Y' THEN    #檢查資料是否為確認
       CALL cl_err(g_aba.aba01,'agl-904',0)
       RETURN
    END IF
    IF g_aba.abapost ='Y' THEN    #檢查資料是否為過帳
       CALL cl_err(g_aba.aba01,'agl-010',0)
       RETURN
    END IF
     IF g_aba.aba20 matches '[Ss1]' THEN          #MOD-4A0299
         CALL cl_err("","mfg3557",0)
         RETURN
    END IF
 
    #-->非總帳輸入則不可異動  #no.4868
    IF g_argv2 = '1' THEN
       IF (g_aba.aba06 != 'GL' AND g_aba.aba06!='VP' AND g_aba.aba06!='FC' AND
           g_aba.aba06 != 'FP') THEN
         CALL cl_err(g_aba.aba01,'agl-203',0) RETURN
       END IF
    END IF
    IF g_argv2 != '3' THEN
     #IF g_aba.aba06 MATCHES '[RV/AC]' THEN    #檢查來源碼
      IF (g_aba.aba06 = 'RV' OR g_aba.aba06 ='AC') THEN
         CALL cl_err(g_aba.aba01,'agl-011',0)
         RETURN
       END IF
    END IF
 
    BEGIN WORK
    LET g_success='Y'
 
    OPEN t110_cl USING g_aba.aba00,g_aba.aba01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_aba.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    CALL t110_show()
    IF cl_exp(0,0,g_aba.abaacti) THEN                   #確認一下
        LET g_chr=g_aba.abaacti
        IF g_aba.abaacti='Y' THEN
            LET g_aba.abaacti='N'
            CALL t110_abhmod_h('N',g_aba.aba01)
        ELSE
            LET g_aba.abaacti='Y'
            CALL t110_abhmod_h('Y',g_aba.aba01)
        END IF
        LET g_aba.aba20 = '0'                  #FUN-920105   按〝無效〞時，簽核狀況要變成〝0:開立〞
        UPDATE aba_file                    #更改有效碼
            SET abaacti=g_aba.abaacti, aba20=g_aba.aba20    #FUN-920105 add aba20
            WHERE aba01=g_aba.aba01 AND aba00 = g_aba.aba00
        IF SQLCA.sqlcode OR STATUS = 100 THEN
            CALL cl_err3("upd","aba_file",g_aba.aba01,g_aba.aba00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_success='N'
            LET g_aba.abaacti=g_chr
        END IF
        DISPLAY BY NAME g_aba.abaacti
        DISPLAY BY NAME g_aba.aba20        #FUN-920105
        IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_aba.aba20='1' OR
           g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
 
    END IF
    CLOSE t110_cl
    IF g_success = 'Y' THEN
       DISPLAY BY NAME g_aba.abaacti
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t110_r()
   DEFINE last_no LIKE type_file.chr20,       #No.FUN-560014  #No.FUN-680098 VARCHAR(12)
          l_amt   LIKE abg_file.abg072
 
   IF s_shut(0) THEN RETURN END IF
   IF g_argv2!='4' THEN
      IF g_aba.aba02 <= g_aaa.aaa07 THEN
          CALL cl_err('','agl-085',0) RETURN
      END IF
   END IF
   IF cl_null(g_aba.aba01) THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_aba.abaacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-960426
   IF g_aba.abapost ='Y' THEN CALL cl_err('','agl-010',0) RETURN END IF
   #-->傳票要簽核但狀況為已簽核/送簽不可取消確認
   IF g_aba.abamksg = 'Y' AND  (g_aba.aba20 = '1' OR  g_aba.aba20 = 'S')
   THEN CALL cl_err(g_aba.aba01,'agl-160',0)
        RETURN
   END IF
   #-->非總帳輸入則不可刪除
   IF g_argv2 = '1' THEN
      IF (g_aba.aba06 != 'GL' AND g_aba.aba06!='VP' AND g_aba.aba06!='FC' AND
          g_aba.aba06 != 'FP') THEN
        CALL cl_err(g_aba.aba01,'agl-203',0) RETURN
      END IF
   END IF
   #-->非應計(來源碼)輸入則不可刪除
   IF g_argv2 = '3' THEN
     IF g_aba.aba06 != 'AC'  THEN
        CALL cl_err(g_aba.aba01,'agl-011',0)
        RETURN
      END IF
   END IF
   IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_aba.aba19 = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   #-->已有沖帳資料的立帳不可刪除
   SELECT sum(abg072+abg073) INTO l_amt FROM abg_file
    WHERE abg01 = g_aba.aba01
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
   IF l_amt > 0 THEN
      CALL cl_err(g_aba.aba01,'agl-905',0)
      RETURN
   END IF
   SELECT UNIQUE amd01 FROM amd_file
    WHERE amd01 = g_aba.aba01 AND amd26 IS NOT NULL # 表已申報
   IF STATUS = 0 THEN
      CALL cl_err3("sel","amd_file",g_aba.aba01,"","agl-204","","",1)  #No.FUN-660123
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t110_cl USING g_aba.aba00,g_aba.aba01
 
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_aba.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t110_cl ROLLBACK WORK RETURN
   END IF
   CALL t110_show()
   IF cl_delh1(0,0) THEN                   #確認一下
      DELETE FROM aba_file WHERE aba00 = g_aba.aba00 AND
                                 aba01 = g_aba.aba01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aba_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","gglt110.4gl(ckp#1)",1)  #No.FUN-660123
         LET g_success = 'N' 
      END IF
      DELETE FROM abb_file WHERE abb00 = g_aba.aba00 AND
                                 abb01 = g_aba.aba01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","abb_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","gglt110.4gl(ckp#2)",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
      DELETE FROM abc_file WHERE abc00 = g_aba.aba00 AND
                                 abc01 = g_aba.aba01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","abc_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","gglt110.4gl(ckp#3)",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
      DELETE FROM abg_file WHERE abg00 = g_aba.aba00 AND
                                 abg01 = g_aba.aba01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","abg_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","gglt110.4gl(ckp#5)",1)  #No.FUN-660123
         LET g_success = 'N' 
      END IF

#FUN-B40056  --begin
      DELETE FROM tic_file WHERE tic00 = g_aba.aba00 AND
                                 tic04 = g_aba.aba01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tic_file",g_aba.aba00,g_aba.aba01,SQLCA.sqlcode,"","gglt110.4gl(ckp#2)",1)
         LET g_success = 'N'
      END IF
#FUN-B40056  --end      

      #-------->有預沖金額則要調整回來
      CALL t110_abhmod_h('R',g_aba.aba01)
      DELETE FROM amd_file WHERE amd01 = g_aba.aba01 AND amd021='1'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","amd_file",g_aba.aba01,"",SQLCA.sqlcode,"","gglt110.4gl(ckp#4)",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
      LET g_msg=g_aba.aba01[g_no_sp,g_no_ep]
      LET last_no=g_aba.aba01[g_no_sp,g_no_ep]
      LET g_t1 = s_get_doc_no(g_aba.aba01)
      LET g_msg = TIME
      INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal
           VALUES('gglt110.4gl',g_user,g_today,g_msg,g_aba.aba01,'delete',g_plant,g_legal) #FUN-980003 add g_plant,g_legal
      CLEAR FORM
      CALL g_abb.clear()
      CALL s_shwact(3,2,g_bookno)
   ELSE
      LET g_success = 'N'
   END IF
   CLOSE t110_cl
   IF g_success = 'Y' THEN
      CLEAR FORM
      CALL g_abb.clear()
      CALL s_shwact(3,2,g_bookno)
      COMMIT WORK
      OPEN t110_count
#FUN-B50065------begin---
      IF STATUS THEN
         CLOSE t110_count
         RETURN
      END IF
#FUN-B50065------end------
      FETCH t110_count INTO g_row_count
#FUN-B50065------begin---
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t110_count
         RETURN
      END IF
#FUN-B50065------end------
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
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t110_abhmod_h(p_type,p_aba01)        #--add
   DEFINE p_type      LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(01)
          p_aba01     LIKE aba_file.aba01,
          l_msg       LIKE type_file.chr1000,  #No.FUN-680098 VARCHAR(70)
          l_abg071    LIKE abg_file.abg071,
          l_abh       RECORD LIKE abh_file.*,
          l_abh09_2,l_abh09_3  LIKE abh_file.abh09
 
   DECLARE t110_abhmod_h CURSOR FOR
           SELECT abh_file.* FROM abh_file
                  WHERE abh00 = g_bookno AND abh01 = p_aba01
 
     FOREACH t110_abhmod_h INTO l_abh.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('t110_abh_mod',SQLCA.sqlcode,0)   
           EXIT FOREACH
        END IF
        CASE
          WHEN p_type = 'R'    #刪?               DELETE FROM abh_file WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
               DELETE FROM abh_file WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08       #TQC-980250 Add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("del","abh_file",l_abh.abh01,l_abh.abh02,SQLCA.sqlcode,"","del abh_file",1)  #No.FUN-660123
                  LET g_success = 'N'
               END IF
          WHEN p_type = 'N'    #沖帳資料變無效
               UPDATE abh_file SET abhconf = 'X'
                WHERE abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
                  AND abh01 = p_aba01
                  AND abh00 = g_bookno    #no.7277
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","abh_file",p_aba01,g_bookno,SQLCA.sqlcode,"","upd abh_file",1)  #No.FUN-660123
                  LET g_success = 'N'
               END IF
          WHEN p_type = 'Y'    #沖帳資料變有效
               UPDATE abh_file SET abhconf = 'N'
                WHERE abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
                  AND abh01 = p_aba01
                  AND abh00 = g_bookno     #no.7277
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","abh_file",p_aba01,g_bookno,SQLCA.sqlcode,"","upd abh_file",1)  #No.FUN-660123
                  LET g_success = 'N'
               END IF
          OTHERWISE EXIT CASE
        END CASE
 
        SELECT sum(abh09) INTO l_abh09_2 FROM abh_file
         WHERE abhconf = 'Y' AND abh07 = l_abh.abh07
           AND abh08 = l_abh.abh08
           AND abh00 = g_bookno   #no.7277
        IF cl_null(l_abh09_2) THEN LET l_abh09_2 = 0 END IF
 
        SELECT sum(abh09) INTO l_abh09_3 FROM abh_file
         WHERE abhconf = 'N' AND abh07 = l_abh.abh07
           AND abh08 = l_abh.abh08
           AND abh00 = g_bookno   #no.7277
        IF cl_null(l_abh09_3) THEN LET l_abh09_3 = 0 END IF
 
        SELECT abg071 INTO l_abg071 FROM abg_file
                        WHERE abg00 = g_bookno
                          AND abg01 = l_abh.abh07
                          AND abg02 = l_abh.abh08
        IF SQLCA.sqlcode THEN
           LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '#&' clipped
           CALL cl_err3("sel","l_abg071",l_msg,"","agl-909","","",1)  #No.FUN-660123
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        IF l_abg071 < (l_abh09_2+l_abh09_3) THEN
           LET l_msg = l_abh.abh07,'-',l_abh.abh08 clipped
           CALL cl_err(l_msg,'agl-908',0)
           LET g_success = 'N'
        END IF
        UPDATE abg_file SET abg072 = l_abh09_2,
                            abg073 = l_abh09_3
                        WHERE abg00 = g_bookno
                          AND abg01 = l_abh.abh07
                          AND abg02 = l_abh.abh08
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '##&' clipped
           CALL cl_err3("upd","abg_file",l_msg,"","agl-909","","",1)  #No.FUN-660123
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END FOREACH
END FUNCTION
 
#單身
FUNCTION t110_b(p_key)
DEFINE
    p_key          LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(01),
    l_ac_t         LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n,i          LIKE type_file.num5,      #檢查重複用   #No.FUN-680098  smallint
    l_lock_sw      LIKE type_file.chr1,      #單身鎖住否   #No.FUN-680098 VARCHAR(1)
    p_cmd          LIKE type_file.chr1,      #處理狀態     #No.FUN-680098  VARCHAR(1)
    l_cmd          LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(100)
    l_aba08         LIKE aba_file.aba08,
    l_aba09         LIKE aba_file.aba09,
    l_cnt           LIKE type_file.num5,     #No.FUN-680098  SMALLINT,
    l_cnt1          LIKE type_file.num5,     #No.FUN-680098  SMALLINT,
    l_abb02         LIKE abb_file.abb02,
    l_abb05         LIKE abb_file.abb05,
    l_afb15         LIKE afb_file.afb15,
    l_afb041        LIKE afb_file.afb041,    #FUN-810069
    l_afb042        LIKE afb_file.afb042,    #FUN-810069
    l_check         LIKE abb_file.abb02, #為check AFTER FIELD abb02時對項次的
    l_check_t       LIKE abb_file.abb02,#判斷是否跳過AFTER ROW的處理
    l_aag09         LIKE aag_file.aag09,
    l_afb07         LIKE afb_file.afb07,
    l_amt           LIKE abb_file.abb07,
    l_tol           LIKE abb_file.abb07,
    l_tol1          LIKE abb_file.abb07,
    total_t         LIKE abb_file.abb07,
    l_abhtot        LIKE abb_file.abb07,
    l_aag14         LIKE aag_file.aag14,
    l_abb24         LIKE abb_file.abb24,
    l_abb25         LIKE abb_file.abb25,
    l_abb03         LIKE abb_file.abb03,
    l_abb06         LIKE abb_file.abb06,
    l_abb07         LIKE abb_file.abb07,
    l_date          LIKE smh_file.smh01,    #FUN-850043
    l_ym            LIKE azj_file.azj02,    #FUN-850043
    l_abb04         LIKE abb_file.abb04,    #No.MOD-480467
    l_flag          LIKE type_file.num10,   #No.FUN-680098  INTEGER,
    l_str           LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(100)
    l_msg           LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(78)
    l_buf           LIKE ze_file.ze03,      #No.FUN-680098  VARCHAR(40),
    l_buf1          LIKE ze_file.ze03,      #No.FUN-680098  VARCHAR(40),
    l_exit_sw       LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1),
    l_allow_insert  LIKE type_file.num5,    #No.FUN-680098  SMALLINT  #可新增否
    l_allow_delete  LIKE type_file.num5,   #可刪除否 #No.FUN-680098  smallint
    l_aba20         LIKE aba_file.aba20,
    l_aag20         LIKE aag_file.aag20     #CHI-850031 add
DEFINE l_abb07f     LIKE abb_file.abb07
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aba.aba01) THEN RETURN END IF
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00=g_aba.aba00
                                          AND aba01=g_aba.aba01
     LET l_aba20 = g_aba.aba20          #MOD-4A0299
    #-->判斷關帳期間
    IF g_argv2!='4' THEN
       IF g_aba.aba02 <= g_aaa.aaa07 THEN
           CALL cl_err('','agl-085',0)
           RETURN
       END IF
    END IF
    IF g_aba.abaacti ='N' THEN CALL cl_err('','aom-000',0) RETURN END IF
    LET g_t1 = s_get_doc_no(g_aba.aba01)     #No.FUN-560014
    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=g_t1 AND aacacti = 'Y'
    #-->非應計(來源碼)輸入則不可更改
    IF g_argv2 = '3' THEN
      IF g_aba.aba06 != 'AC'  THEN
         CALL cl_err(g_aba.aba01,'agl-011',0)
         RETURN
       END IF
    END IF
    IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_aba.aba19 = 'Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
     IF g_aba.aba20 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    #### 98/06/01  已過帳,不可改單身資料
    IF g_aba.abapost = 'Y' THEN CALL cl_err('','agl-010',0) RETURN END IF
 
    LET g_action_choice = ""
    SELECT UNIQUE amd01 FROM amd_file
     WHERE amd01 = g_aba.aba01 AND amd26 IS NOT NULL # 表已申報
    IF STATUS = 0 THEN
       CALL cl_err3("sel","amd_file",g_aba.aba01,"","agl-204","","",1)  #No.FUN-660123
       RETURN
    END IF
    CALL cl_opmsg('b')
    IF cl_null(g_aac.aac13) THEN LET g_aac.aac13 = 'N' END IF
    CALL t110_body_init(g_aac.aac13)
 
    LET g_forupd_sql= " SELECT abb02,abb03,' ',abb24,abb25,0,0,0,0,abb04 ", 
                      "   FROM abb_file ",
                      "  WHERE abb00 = ? ",
                      "    AND abb01 = ? ",
                      "    AND abb02 = ? ",
                      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    IF g_argv2 = '1' AND
      (g_aba.aba06 != 'GL' AND g_aba.aba06 != 'VP' AND
       g_aba.aba06 != 'FC' AND g_aba.aba06 != 'FP') THEN
       LET  l_allow_insert = FALSE
       LET  l_allow_delete = FALSE
    END IF
    WHILE TRUE
        LET l_exit_sw = 'y'
        LET l_ac_t = 0
 
        INPUT ARRAY g_abb WITHOUT DEFAULTS  FROM s_abb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN t110_cl USING g_aba.aba00,g_aba.aba01
           IF STATUS THEN
              CALL cl_err("OPEN t110_cl:", STATUS, 1)
              CLOSE t110_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t110_cl INTO g_aba.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t110_cl ROLLBACK WORK RETURN
           END IF
 
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_abb_t.* = g_abb[l_ac].*  #BACKUP
              OPEN t110_bcl USING g_aba.aba00, g_aba.aba01,g_abb_t.abb02
 
              IF STATUS THEN
                 CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t110_bcl INTO g_abb[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_abb_t.abb02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    CALL t110_abb03('d')
                    SELECT abb06,abb07,abb07f INTO l_abb06,l_abb07,l_abb07f FROM abb_file
                     WHERE abb00 = g_aba.aba00
                       AND abb01 = g_aba.aba01
                       AND abb02 = g_abb_t.abb02
                    IF l_abb06 = '1' THEN
                       LET g_abb[l_ac].abb07d = l_abb07
                       LET g_abb[l_ac].abb07df= l_abb07f
                       LET g_abb[l_ac].abb07c = 0
                       LET g_abb[l_ac].abb07cf= 0
                    ELSE
                       LET g_abb[l_ac].abb07d = 0
                       LET g_abb[l_ac].abb07df= 0
                       LET g_abb[l_ac].abb07c = l_abb07
                       LET g_abb[l_ac].abb07cf= l_abb07f
                    END IF
                    SELECT abb05,gem02,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36,abb37
                      INTO g_abb2.*
                      FROM abb_file LEFT OUTER JOIN gem_file ON gem01 = abb05
                     WHERE abb00 = g_aba.aba00
                       AND abb01 = g_aba.aba01
                       AND abb02 = g_abb_t.abb02
                    CALL t110_trans()
                    LET g_before_input_done=FALSE
                    CALL t110_set_entry_b(p_cmd)
                    CALL t110_set_no_entry_b(p_cmd)
                    CALL t110_set_required(p_cmd)
                    CALL t110_set_no_required(p_cmd)
                    LET g_before_input_done=TRUE
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,1)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_abb[l_ac].abb07c > 0 THEN 
              LET l_abb06 = '2'
              LET l_abb07 = g_abb[l_ac].abb07c
              LET l_abb07f= g_abb[l_ac].abb07cf
           ELSE
              LET l_abb06 = '1'
              LET l_abb07 = g_abb[l_ac].abb07d
              LET l_abb07f= g_abb[l_ac].abb07df
           END IF
#          CALL t110_b1(p_cmd)
           CALL t110_trans()
           INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb05,abb06,
                                abb07,abb07f,abb08,abb11,abb12,abb13,abb14,
 
                                abb31,abb32,abb33,abb34,abb35,abb36,abb37,
 
                                abb24,abb25                                   #No.FUN-810069  
                                ,abbud01,abbud02,abbud03,abbud04,abbud05,
                                abbud06,abbud07,abbud08,abbud09,abbud10,
                                abbud11,abbud12,abbud13,abbud14,abbud15,abblegal) #FUN-980003 add abblegal
                VALUES(g_aba.aba00,g_aba.aba01,g_abb[l_ac].abb02,
                       g_abb[l_ac].abb03,g_abb[l_ac].abb04,g_abb2.abb05,
                       l_abb06,l_abb07,l_abb07f,
                       g_abb2.abb08,g_abb2.abb11,g_abb2.abb12,
                       g_abb2.abb13,g_abb2.abb14,
                       g_abb2.abb31,g_abb2.abb32,g_abb2.abb33,
                       g_abb2.abb34,g_abb2.abb35,g_abb2.abb36,
                       g_abb2.abb37,
                       g_abb[l_ac].abb24,g_abb[l_ac].abb25,
                       g_abb2.abbud01,g_abb2.abbud02,
                       g_abb2.abbud03,g_abb2.abbud04,
                       g_abb2.abbud05,g_abb2.abbud06,
                       g_abb2.abbud07,g_abb2.abbud08,
                       g_abb2.abbud09,g_abb2.abbud10,
                       g_abb2.abbud11,g_abb2.abbud12,
                       g_abb2.abbud13,g_abb2.abbud14,
                       g_abb2.abbud15,g_legal) #FUN-980003 add g_legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","abb_file",g_aba.aba01,g_abb[l_ac].abb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
               LET l_aba20 = '0'          #MOD-4A0299
              LET g_rec_b=g_rec_b+1
              IF m_aag20='Y' THEN
                 CALL s_abh(g_aba.aba00,g_aba.aba01,g_aba.aba02,g_abb[l_ac].abb02)
              END IF
              CALL t110_upamt()
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_abb[l_ac].* TO NULL      #900423
           INITIALIZE g_abb2.* TO NULL
           LET g_abb[l_ac].abb07d = 0
           LET g_abb[l_ac].abb07df= 0
           LET g_abb[l_ac].abb07c = 0
           LET g_abb[l_ac].abb07cf= 0
           LET g_abb[l_ac].abb24 = g_aza.aza17
           LET g_abb[l_ac].abb25 = 1
           LET g_abb_t.* = g_abb[l_ac].*         #新輸入資料
           CALL t110_trans()
           LET g_before_input_done = FALSE
           CALL t110_set_entry_b(p_cmd)
           CALL t110_set_no_entry_b(p_cmd)
           CALL t110_set_required(p_cmd)
           CALL t110_set_no_required(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD abb02
 
        BEFORE FIELD abb02                        #default 序號
           IF cl_null(g_abb[l_ac].abb02) OR
              g_abb[l_ac].abb02 = 0 THEN
               SELECT MAX(abb02)+1
                 INTO g_abb[l_ac].abb02
                 FROM abb_file
                WHERE abb01 = g_aba.aba01
                  AND abb00 = g_bookno
               IF g_abb[l_ac].abb02 IS NULL THEN
                   LET g_abb[l_ac].abb02 = 1
               END IF
           END IF
 
        AFTER FIELD abb02                        #check 序號是否重複
           IF NOT cl_null(g_abb[l_ac].abb02) THEN
              IF g_abb[l_ac].abb02 != g_abb_t.abb02 OR
                 g_abb_t.abb02 IS NULL THEN
                 SELECT COUNT(*) INTO l_n
                   FROM abb_file
                  WHERE abb00 = g_aba.aba00
                    AND abb01 = g_aba.aba01
                    AND abb02 = g_abb[l_ac].abb02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_abb[l_ac].abb02 = g_abb_t.abb02
                    NEXT FIELD abb02
                 END IF
              END IF
              IF g_abb[l_ac].abb02 != g_abb_t.abb02 THEN
                 SELECT COUNT(*) INTO l_n FROM abc_file
                  WHERE abc00 = g_aba.aba00
                    AND abc01 = g_aba.aba01
                    AND abc02 = g_abb_t.abb02
                 IF l_n > 0 THEN
                    UPDATE abc_file SET abc02 = g_abb[l_ac].abb02
                     WHERE abc00 = g_aba.aba00 AND abc01 = g_aba.aba01
                      AND abc02 = g_abb_t.abb02
                    IF STATUS THEN 
                       CALL cl_err3("upd","abc_file",g_abb_t.abb02,g_aba.aba01,STATUS,"","update abc",1) #NO.FUN-660123
                    END IF
                 END IF
                    UPDATE abg_file SET abg02 = g_abb[l_ac].abb02
                     WHERE abg00 = g_aba.aba00 AND abg01 = g_aba.aba01
                      AND abg02 = g_abb_t.abb02
                    IF STATUS THEN 
                       CALL cl_err3("upd","abg_file",g_abb_t.abb02,g_aba.aba01,STATUS,"","update abg",1) #NO.FUN-660123
                    END IF
                     UPDATE abh_file SET abh02 = g_abb[l_ac].abb02
                     WHERE abh00 = g_aba.aba00 AND abh01 = g_aba.aba01
                      AND abh02 = g_abb_t.abb02
                    IF STATUS THEN 
                       CALL cl_err3("upd","abh_file",g_abb_t.abb02,g_aba.aba01,STATUS,"","update abh",1) #NO.FUN-660123
                    END IF
              END IF
           END IF
 
        BEFORE FIELD abb03
            LET g_before_input_done = FALSE   #MOD-680003
            CALL t110_set_entry_b(p_cmd)
            CALL t110_set_no_entry_b(p_cmd)   #MOD-630121
            CALL t110_set_no_required(p_cmd)
            LET g_before_input_done = TRUE   #MOD-680003
 
        AFTER FIELD abb03
            IF NOT cl_null(g_abb[l_ac].abb03) THEN
              #修改abb03時,先檢核沖帳檔abh_file,若已有資料則不可修改
               IF g_abb_t.abb03 IS NOT NULL AND g_abb_t.abb03!=g_abb[l_ac].abb03 THEN
                  SELECT aag20 INTO l_aag20 FROM aag_file
                   WHERE aag01=g_abb_t.abb03
                     AND aag00=g_bookno    #No.FUN-740020
                  IF STATUS=0 AND l_aag20='Y' THEN
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt FROM abh_file
                      WHERE abh00=g_aba.aba00
                        AND abh01=g_aba.aba01
                        AND abh02=g_abb[l_ac].abb02
                        AND abh03=g_abb_t.abb03
                     IF l_cnt > 0 THEN
                        CALL cl_err(g_abb_t.abb03,'agl-894',0)
                        #No.FUN-B10050  --Begin
                        #LET g_abb[l_ac].abb03 = g_abb_t.abb03
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_aag"
                        LET g_qryparam.construct = 'N'
                        LET g_qryparam.default1 = g_abb[l_ac].abb03
                        LET g_qryparam.arg1 = g_bookno
                        LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_abb[l_ac].abb03 CLIPPED,"%'"
                        CALL cl_create_qry() RETURNING g_abb[l_ac].abb03
                        #No.FUN-B10050  --End  
                        DISPLAY BY NAME g_abb[l_ac].abb03
                        NEXT FIELD abb03
                     END IF
                  END IF
               END IF
               CALL t110_abb03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_abb[l_ac].abb03,g_errno,0)
                  #No.FUN-B10050  --Begin
                  #LET g_abb[l_ac].abb03 = g_abb_t.abb03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_abb[l_ac].abb03
                  LET g_qryparam.arg1 = g_bookno
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_abb[l_ac].abb03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_abb[l_ac].abb03
                  #No.FUN-B10050  --End  
                  NEXT FIELD abb03
               END IF
               IF cl_null(g_abb_t.abb03) OR g_abb_t.abb03 <> g_abb[l_ac].abb03 THEN
                  CALL t110_init_body_more()
                  CALL t110_b1(p_cmd)
                  CALL t110_trans()
               END IF
            END IF
 
            #IF g_aac.aac03 = '1' THEN
            #   LET g_abb[l_ac].abb06 = '2'
            #END IF
            #IF g_aac.aac03 = '2' THEN
            #   LET g_abb[l_ac].abb06 = '1'
            #END IF
            LET g_before_input_done = FALSE   #MOD-680003
            CALL t110_set_entry_b(p_cmd)      #TQC-640017
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_set_required(p_cmd)
            LET g_before_input_done = TRUE    #MOD-680003
            
            IF m_aag21 = 'Y' THEN
               CALL t110_bud(p_cmd,'0')
               IF NOT cl_null(g_errno) THEN
                  #No.FUN-B10050  --Begin
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_abb[l_ac].abb03
                  LET g_qryparam.arg1 = g_bookno
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_abb[l_ac].abb03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_abb[l_ac].abb03
                  #No.FUN-B10050  --End  
                  NEXT FIELD abb03
               END IF
#           ELSE
#           	 IF m_aag21 = 'N' OR cl_null(m_aag21) THEN
#           	    LET g_abb2.abb36 = ' '          
#           	 END IF   
            END IF   
                              
#           IF m_aag05 = 'N' OR cl_null(m_aag05) THEN
#              LET g_abb2.abb05 = ' '              #No.FUN-830139 add  by hellen
#           END IF
#           IF m_aag23 = 'N' OR cl_null(m_aag23) THEN
#              LET g_abb2.abb08 = ' '              #No.FUN-830139 add  by hellen
#              LET g_abb2.abb35 = ' '              #No.FUN-830139 add  by hellen
#           END IF
 
 
         AFTER FIELD abb04   #摘要
           IF NOT cl_null(g_abb[l_ac].abb04) THEN
              LET g_msg = g_abb[l_ac].abb04
              IF g_msg[1,1] = '.' THEN
                 LET g_msg = g_msg[2,10]
                 SELECT aad02 INTO g_abb[l_ac].abb04 FROM aad_file
                    WHERE aad01 = g_msg AND aadacti = 'Y'
                    DISPLAY BY NAME g_abb[l_ac].abb04
                 NEXT FIELD abb04
              END IF
           END IF
 
#       BEFORE FIELD abb05
#           IF m_aag05 = 'N' THEN
#              LET g_abb2.abb05 = ' '
#              DISPLAY BY NAME g_abb2.abb05
#           END IF
#
#       AFTER FIELD abb05      #部門
#           #科目為需有部門資料者才需建立此欄位
#           IF NOT cl_null(g_abb2.abb05) THEN
#              IF m_aag05='Y' THEN
#                  CALL t110_abb05('u')
#                  IF NOT cl_null(g_errno) THEN
#                     CALL cl_err(g_abb2.abb05,g_errno,1)
#                     LET g_abb2.abb05=g_abb2_t.abb05
#                     DISPLAY BY NAME g_abb2.abb05
#                     NEXT FIELD abb05
#                  END IF
#              END IF
#           END IF
#           CALL t110_bud(p_cmd,'0')
#           IF NOT cl_null(g_errno) THEN
#              NEXT FIELD abb05
#           END IF  
#
#       AFTER FIELD abb06
#           IF NOT cl_null(g_abb[l_ac].abb06) THEN
#              IF g_abb[l_ac].abb06 NOT MATCHES '[12]' THEN
#                 NEXT FIELD abb06
#              END IF
#           END IF
    
       BEFORE FIELD abb07df,abb07d,abb07cf,abb07c
            CALL t110_set_entry_b(p_cmd) 

       AFTER FIELD abb07df,abb07d,abb07cf,abb07c
            IF (g_abb[l_ac].abb07d > 0 OR g_abb[l_ac].abb07df > 0) AND 
               (g_abb[l_ac].abb07c > 0 OR g_abb[l_ac].abb07cf > 0) THEN
               NEXT FIELD CURRENT
            END IF
            IF g_aac.aac12<>"Y" THEN
               IF g_abb[l_ac].abb07d < 0 OR g_abb[l_ac].abb07df < 0  OR  
                  g_abb[l_ac].abb07c < 0 OR g_abb[l_ac].abb07cf < 0  THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
            IF g_aac.aac13 = 'N' THEN
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aaa.aaa03
               LET g_abb[l_ac].abb07d  = cl_digcut(g_abb[l_ac].abb07d,t_azi04)
               LET g_abb[l_ac].abb07c  = cl_digcut(g_abb[l_ac].abb07c,t_azi04)
               LET g_abb[l_ac].abb07df = g_abb[l_ac].abb07d
               LET g_abb[l_ac].abb07cf = g_abb[l_ac].abb07c
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_abb[l_ac].abb24
               LET g_abb[l_ac].abb07df = cl_digcut(g_abb[l_ac].abb07df,t_azi04)
               LET g_abb[l_ac].abb07cf = cl_digcut(g_abb[l_ac].abb07cf,t_azi04)
            ELSE
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_abb[l_ac].abb24
               LET g_abb[l_ac].abb07df = cl_digcut(g_abb[l_ac].abb07df,t_azi04)
               LET g_abb[l_ac].abb07d  = g_abb[l_ac].abb07df* g_abb[l_ac].abb25
               LET g_abb[l_ac].abb07cf = cl_digcut(g_abb[l_ac].abb07cf,t_azi04)
               LET g_abb[l_ac].abb07c  = g_abb[l_ac].abb07cf* g_abb[l_ac].abb25
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aaa.aaa03
               LET g_abb[l_ac].abb07d  = cl_digcut(g_abb[l_ac].abb07d,t_azi04)
               LET g_abb[l_ac].abb07c  = cl_digcut(g_abb[l_ac].abb07c,t_azi04)
            END IF
            CALL t110_set_no_entry_b(p_cmd)
            CALL t110_bud(p_cmd,'0')
 
      BEFORE FIELD abb24
         LET g_before_input_done = FALSE   #MOD-680003
         CALL t110_set_entry_b(p_cmd)
         CALL t110_set_no_entry_b(p_cmd)   #MOD-630121
         LET g_before_input_done = TRUE   #MOD-680003
 
      AFTER FIELD abb24
         IF NOT cl_null(g_abb[l_ac].abb24) THEN
            CALL t110_abb24(g_abb[l_ac].abb24)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_abb[l_ac].abb24,g_errno,0)
               NEXT FIELD abb24
            ELSE
               #匯率抓取應依參數設定aza19(1.月平均 2.每日),
               #再決定要抓取每月或每日匯率                #M:銀行中價匯率
               CALL s_curr3(g_abb[l_ac].abb24,g_aba.aba02,'M')
                    RETURNING g_abb[l_ac].abb25
               DISPLAY BY NAME g_abb[l_ac].abb25
            END IF
            IF g_aza.aza17 = g_abb[l_ac].abb24 THEN
               LET g_abb[l_ac].abb25 = 1
               DISPLAY BY NAME g_abb[l_ac].abb25
            END IF
         END IF
         LET g_before_input_done = FALSE   #MOD-680003
         CALL t110_set_entry_b(p_cmd)   #TQC-640017
         CALL t110_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE   #MOD-680003
 
        AFTER FIELD abb25    #匯率
           IF g_abb[l_ac].abb24 =g_aza.aza17 THEN
              LET g_abb[l_ac].abb25=1
              DISPLAY BY NAME g_abb[l_ac].abb25
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_abb_t.abb02 > 0 AND
               g_abb_t.abb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM abb_file
                    WHERE abb00 = g_bookno AND
                          abb01 = g_aba.aba01 AND
                          abb02 = g_abb_t.abb02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","abb_file",g_aba.aba01,g_abb_t.abb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM abc_file
                    WHERE abc00 = g_bookno AND
                          abc01 = g_aba.aba01 AND
                          abc02 = g_abb_t.abb02
                DELETE FROM abg_file
                    WHERE abg00 = g_bookno AND abg01 = g_aba.aba01
                      AND abg02 = g_abb_t.abb02
       #FUN-B40056 --begin
                DELETE FROM tic_file
                 WHERE tic00 = g_bookno 
                   AND tic04 = g_aba.aba01
       #FUN-B40056 --end                  
    
 
                CALL t110_abhdel_b()
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                 LET l_aba20 = '0'          #MOD-4A0299
                COMMIT WORK
                CALL t110_upamt()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_abb[l_ac].* = g_abb_t.*
               CLOSE t110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
#           CALL t110_b1(p_cmd)
            CALL t110_trans()
            IF m_aag05='Y' THEN
               IF cl_null(g_abb2.abb05) THEN
                  CALL cl_err(g_abb[l_ac].abb03,'mfg0037',0)
                  NEXT FIELD abb03
               END IF
            END IF
            IF m_aag23='Y' THEN
               IF cl_null(g_abb2.abb08) THEN
                  CALL cl_err(g_abb[l_ac].abb03,'mfg0037',0)
                  NEXT FIELD abb03
               END IF
            END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'1',g_abb2.abb11,g_bookno)  #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'2',g_abb2.abb12,g_bookno)  #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'3',g_abb2.abb13,g_bookno)  #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'4',g_abb2.abb14,g_bookno)   #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
 
             CALL s_chk_aee(g_abb[l_ac].abb03,'5',g_abb2.abb31,g_bookno)   #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'6',g_abb2.abb32,g_bookno)    #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'7',g_abb2.abb33,g_bookno)    #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'8',g_abb2.abb34,g_bookno)    #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
             CALL s_chk_aee(g_abb[l_ac].abb03,'99',g_abb2.abb37,g_bookno)    #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD abb03
             END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_abb[l_ac].abb02,-263,1)
               LET g_abb[l_ac].* = g_abb_t.*
            ELSE
               IF g_abb[l_ac].abb07c > 0 THEN 
                  LET l_abb06 = '2'
                  LET l_abb07 = g_abb[l_ac].abb07c
                  LET l_abb07f= g_abb[l_ac].abb07cf
               ELSE
                  LET l_abb06 = '1'
                  LET l_abb07 = g_abb[l_ac].abb07d
                  LET l_abb07f= g_abb[l_ac].abb07df
               END IF
                UPDATE abb_file SET abb02=g_abb[l_ac].abb02,
                                    abb03=g_abb[l_ac].abb03,
                                    abb04=g_abb[l_ac].abb04,
                                    abb05=g_abb2.abb05,
                                    abb06=l_abb06,
                                    abb07=l_abb07,
                                    abb07f=l_abb07f,
                                    abb08=g_abb2.abb08,
                                    abb24=g_abb[l_ac].abb24,
                                    abb25=g_abb[l_ac].abb25,
                                    abb11=g_abb2.abb11,
                                    abb12=g_abb2.abb12,
                                    abb13=g_abb2.abb13,
                                    abb14=g_abb2.abb14,
                                    abb31=g_abb2.abb31,
                                    abb32=g_abb2.abb32,
                                    abb33=g_abb2.abb33,
                                    abb34=g_abb2.abb34,
                                    abb35=g_abb2.abb35,
                                    abb36=g_abb2.abb36,
                                    abb37=g_abb2.abb37,
                                    abbud01 = g_abb2.abbud01,
                                    abbud02 = g_abb2.abbud02,
                                    abbud03 = g_abb2.abbud03,
                                    abbud04 = g_abb2.abbud04,
                                    abbud05 = g_abb2.abbud05,
                                    abbud06 = g_abb2.abbud06,
                                    abbud07 = g_abb2.abbud07,
                                    abbud08 = g_abb2.abbud08,
                                    abbud09 = g_abb2.abbud09,
                                    abbud10 = g_abb2.abbud10,
                                    abbud11 = g_abb2.abbud11,
                                    abbud12 = g_abb2.abbud12,
                                    abbud13 = g_abb2.abbud13,
                                    abbud14 = g_abb2.abbud14,
                                    abbud15 = g_abb2.abbud15
                  WHERE abb00 = g_aba.aba00 AND
                        abb01 = g_aba.aba01 AND
                        abb02 = g_abb_t.abb02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","abb_file",g_aba.aba01,g_abb_t.abb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    LET g_abb[l_ac].* = g_abb_t.*
                    ROLLBACK WORK
                 ELSE
                    IF m_aag20='Y' THEN
                       CALL t110_abhmod_h('R',g_aba.aba01)
                       CALL s_abh(g_aba.aba00,g_aba.aba01,g_aba.aba02,
                                  g_abb[l_ac].abb02)
                    END IF
                    CALL t110_upamt()
                    MESSAGE 'UPDATE O.K'
                     LET l_aba20 = '0'          #MOD-4A0299
                    COMMIT WORK
                 END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac                #FUN-D30032 Mark
 
            IF INT_FLAG THEN                 #900423
 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_abb[l_ac].* = g_abb_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_abb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end-- 
              END IF
              ROLLBACK WORK
              EXIT INPUT
            END IF
            LET l_ac_t = l_ac                #FUN-D30032 Add
            CLOSE t110_bcl
            COMMIT WORK
 
        ON ACTION maintain_acct_tran_code_value
           CALL t110_b1(p_cmd)
           CALL t110_trans()
        ON ACTION contra_detail
           IF g_rec_b != 0 THEN
              SELECT aag20 INTO m_aag20 FROM aag_file
               WHERE aag01=g_abb[l_ac].abb03
                 AND aag00=g_bookno   #No.FUN-740020
              IF STATUS=0 AND m_aag20='Y' THEN
               CALL s_abh(g_aba.aba00,g_aba.aba01,g_aba.aba02,
                          g_abb[l_ac].abb02)
              END IF
           END IF
 
        ON ACTION apportionment_method
           CALL t110_w()  EXIT INPUT
 
        ON ACTION maintain_account_details
            CASE
                WHEN INFIELD(abb03) CALL cl_cmdrun('agli102' CLIPPED)
                OTHERWISE EXIT CASE
            END CASE
 
#       ON ACTION rejected_accepted_dept_setting
#           CASE
#               WHEN INFIELD(abb05) CALL cl_cmdrun('agli104' CLIPPED)
#               OTHERWISE EXIT CASE
#           END CASE
 
        ON ACTION extra_memo
            CASE
                WHEN INFIELD(abb04) CALL s_agl_memo('a',g_aba.aba00,g_aba.aba01,
                                                    g_abb[l_ac].abb02)
                OTHERWISE EXIT CASE
            END CASE
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(abb03)      #查詢科目代號不為統制帳戶'1'
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_abb[l_ac].abb03
                   LET g_qryparam.arg1 = g_bookno   #No.FUN-740020
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_abb[l_ac].abb03
                   DISPLAY BY NAME g_abb[l_ac].abb03       #No.MOD-490344
                   CALL t110_abb03('d')
                   NEXT FIELD abb03
                WHEN INFIELD(abb04)     #查詢常用摘要
                   CALL q_aad(FALSE,TRUE,g_abb[l_ac].abb04) RETURNING l_abb04   #No.MOD-480467
                   LET g_abb[l_ac].abb04=g_abb[l_ac].abb04 CLIPPED,l_abb04   #No.MOD-480467
                   DISPLAY g_abb[l_ac].abb04 TO abb04
                   NEXT FIELD abb04
                WHEN INFIELD(abb24)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_abb[l_ac].abb24
                   CALL cl_create_qry() RETURNING g_abb[l_ac].abb24
                   DISPLAY BY NAME g_abb[l_ac].abb24       #No.MOD-490344
                   NEXT FIELD abb24
                WHEN INFIELD(abb25)
                   CALL s_rate(g_abb[l_ac].abb24,g_abb[l_ac].abb25) RETURNING g_abb[l_ac].abb25
                   DISPLAY BY NAME g_abb[l_ac].abb25
                   NEXT FIELD abb25
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(abb02) AND l_ac > 1 THEN
                LET g_abb[l_ac].* = g_abb[l_ac-1].*
                LET g_abb[l_ac].abb02 = NULL
                SELECT MAX(abb02)+1
                  INTO g_abb[l_ac].abb02
                  FROM abb_file
                 WHERE abb01 = g_aba.aba01
                   AND abb00 = g_bookno
                 DISPLAY BY NAME g_abb[l_ac].*   #TQC-610104
                NEXT FIELD abb03
            END IF
            IF INFIELD(abb04) AND l_ac > 1 THEN
               LET g_abb[l_ac].abb04 = g_abb[l_ac-1].abb04
               DISPLAY g_abb[l_ac].abb04 TO abb04 #MOD-550022
               NEXT FIELD abb04
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       ON ACTION add_1_to_below_all
          SELECT COUNT(*) INTO l_cnt FROM abb_file
                 WHERE abb00 = g_aba.aba00 AND
                       abb01 = g_aba.aba01 AND
                       abb02 >= g_abb[l_ac].abb02
          DECLARE abb_cl CURSOR FOR
             SELECT abb02 FROM abb_file
                 WHERE abb00 = g_aba.aba00
                   AND abb01 = g_aba.aba01
                   AND abb02 >= g_abb[l_ac].abb02
                 ORDER BY  1 DESC
          FOREACH abb_cl INTO l_abb02
             IF SQLCA.sqlcode THEN
                CALL cl_err('abb_cl',SQLCA.sqlcode,0)   
                EXIT FOREACH
             END IF
             UPDATE abb_file SET abb02 = l_abb02 + 1
                     WHERE abb00 = g_aba.aba00
                       AND abb01 = g_aba.aba01
                       AND abb02 = l_abb02
              IF STATUS THEN
                 CALL cl_err3("upd","abb_file",g_aba.aba01,l_abb02,STATUS,"","update abb+1",1) #NO.FUN-660123
              END IF
             UPDATE abg_file SET abg02 = l_abb02+1
              WHERE abg00 = g_aba.aba00 AND abg01 = g_aba.aba01
                AND abg02 = l_abb02
             IF STATUS THEN 
                CALL cl_err3("upd","abg_file",g_aba.aba01,l_abb02,STATUS,"","update abg+1",1) #NO.FUN-660123
             END IF
 
             UPDATE abh_file SET abh02 = l_abb02+1
              WHERE abh00 = g_aba.aba00 AND abh01 = g_aba.aba01
                AND abh02 = l_abb02
             IF STATUS THEN 
                CALL cl_err3("upd","abh_file",g_aba.aba01,l_abb02,STATUS,"","update abh+1",1) #NO.FUN-660123
             END IF
          END FOREACH
          CALL t110_b_fill(g_wc2)                 #單身
          EXIT INPUT
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
        SELECT count(*) INTO l_n FROM aag_file                                                                               
         WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file                                                          
                                          WHERE abb01 = g_aba.aba01
                                            AND abb00 = g_bookno)   #No.MOD-7A0131
           AND aag00 = g_bookno   #No.FUN-740020
        IF l_n = 0 THEN
           CALL cl_set_comp_visible("aba35,aba36",FALSE)
           CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",FALSE)
        ELSE
           IF g_aza48 = 'Y' THEN
              CALL cl_set_comp_visible("aba35,aba36",TRUE)
              CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",TRUE)
           END IF
        END IF
        UPDATE aba_file SET abamodu=g_user,abadate=g_today,aba20=l_aba20
           WHERE aba00=g_bookno AND aba01=g_aba.aba01
        CALL t110_delHeader()     #CHI-C30002 add
        IF cl_null(g_aba.aba01) OR cl_null(g_aba.aba00) THEN RETURN END IF #CHI-C30002 單身無資料時候用戶選擇清空單頭則退出
        LET g_aba.aba20 = l_aba20
        DISPLAY BY NAME g_aba.aba20
        IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_aba.aba20='1' OR
           g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
 
        IF g_aba.aba08 != g_aba.aba09 THEN
           IF g_aaz.aaz71 = '1' THEN
              LET l_exit_sw = 'n'
           END IF
           CALL cl_err('','agl-060',1)
        END IF
        #Genero 修改
        SELECT COUNT(*) INTO g_cnt FROM abb_file,aag_file
         WHERE abb01 = g_aba.aba01 AND abb03 = aag01
           AND aag20 = 'Y'
           AND aag00 = g_bookno   #No.FUN-740020
        IF g_cnt > 0 THEN
          LET l_ac = 1
          DECLARE abb_cs CURSOR FOR
           SELECT abb02,abb03,abb06,abb07,
                  aag20,aag222,aag15,aag16,aag17,aag18,
 
                  aag31,aag32,aag33,aag34,aag35,aag36,aag37
 
             FROM aag_file,abb_file
            WHERE abb01 = g_aba.aba01
              AND aag01 = abb03
              AND aag00 = abb00      #No.FUN-740020
              AND aag00 = g_bookno   #No.FUN-740020
            ORDER BY abb02
          FOREACH abb_cs INTO l_abb02,l_abb03,l_abb06,l_abb07,
                              m_aag20,m_aag222,m_aag15,m_aag16,m_aag17,m_aag18,
 
                              m_aag31,m_aag32,m_aag33,m_aag34,m_aag35,
                              m_aag36,m_aag37
              IF g_abb[l_ac].abb07c <> 0 THEN
                 LET l_abb06 = '2'
              ELSE
                 LET l_abb06 = '1'
              END IF
 
              #---------(add)沖帳金額不平---------------
              IF m_aag20='Y' THEN
              #  IF ((m_aag222='1' AND g_abb[l_ac].abb06='2')  OR
              #     (m_aag222='2' AND g_abb[l_ac].abb06='1')) AND
                 IF ((m_aag222='1' AND l_abb06='2')  OR
                    (m_aag222='2' AND l_abb06='1')) AND
                    ((m_aag15 is not null AND m_aag15 != ' ') OR
                     (m_aag16 is not null AND m_aag16 != ' ') OR
                     (m_aag17 is not null AND m_aag17 != ' ') OR
                     (m_aag18 is not null AND m_aag18 != ' ') OR
 
                     (m_aag31 is not null AND m_aag31 != ' ') OR
                     (m_aag32 is not null AND m_aag32 != ' ') OR
                     (m_aag33 is not null AND m_aag33 != ' ') OR
                     (m_aag34 is not null AND m_aag34 != ' ') OR
                     (m_aag35 is not null AND m_aag35 != ' ') OR
                     (m_aag36 is not null AND m_aag36 != ' ') OR
                     (m_aag37 is not null AND m_aag37 != ' '))
 
                     THEN
                     SELECT sum(abh09) INTO l_abhtot FROM abh_file
                      WHERE abh00 = g_bookno
                        AND abh01 = g_aba.aba01
                        AND abh02 = l_abb02
                     IF cl_null(l_abhtot) THEN LET l_abhtot = 0 END IF
                     IF l_abb07 != l_abhtot THEN
                        CALL cl_err('','agl-900',0)   #MOD-850201 mod 改成僅提示
                        LET l_exit_sw = 'y'           #MOD-850201 mod n->y
                        LET l_ac_t = l_ac
                        EXIT FOREACH
                     END IF
                 END IF
              END IF
              LET l_ac = l_ac + 1
          END FOREACH
        END IF
        #Genero 修改 (end)
        IF l_exit_sw = 'n' THEN
           CONTINUE WHILE
        ELSE
          #自動賦予簽核等級
          IF g_aba.abamksg MATCHES  '[Yy]' AND p_key='a' THEN
             IF g_aac.aacatsg matches'[Yy]'   #自動付予
                THEN
                CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                     RETURNING g_aba.abasign
                IF g_aza.aza23 MATCHES '[Nn]' THEN   #MOD-590286
                   LET g_aba01t = s_get_doc_no(g_aba.aba01)     #No.FUN-560014
                   SELECT aacdays,aacprit INTO g_aba.abadays,g_aba.abaprit FROM
                          aac_file WHERE aac01 = g_aba01t
                   CALL s_signm(8,34,g_lang,'1',g_aba.aba01,4,g_aba.abasign,
                       g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_aba.abasseq)
                          RETURNING g_aba.abasign,       #等級
                                    g_aba.abadays,
                                    g_aba.abaprit,
                                    g_aba.abasmax,       #應簽
                                    g_aba.abasseq,       #已簽
                                    g_statu
                ELSE
                   CALL signm_COUNT(g_aba.abasign) RETURNING g_aba.abasmax
                   LET g_aba.abasseq = 0
                END IF
             ELSE   #固定等級
                LET g_aba01t = s_get_doc_no(g_aba.aba01)     #No.FUN-560014
                SELECT aacsign,aacdays,aacprit INTO
                       g_aba.abasign,g_aba.abadays,g_aba.abaprit
                  FROM aac_file WHERE aac01 = g_aba01t
             END IF
             UPDATE aba_file SET abasign = g_aba.abasign,
                                 abadays = g_aba.abadays,
                                 abaprit = g_aba.abaprit,
                                 abasmax = g_aba.abasmax,
                                 abasseq = g_aba.abasseq 
                           WHERE aba01 = g_aba.aba01
                             AND aba00 = g_bookno
          DISPLAY BY NAME g_aba.abamksg
          DISPLAY BY NAME g_aba.abasign
         END IF
         EXIT WHILE
       END IF
    END WHILE
    CLOSE t110_cl
    CLOSE t110_bcl
    COMMIT WORK
END FUNCTION
 

FUNCTION t110_abhdel_b()                          #--add
   DEFINE l_abh       RECORD LIKE abh_file.*
   DEFINE l_abh09_2,l_abh09_3  LIKE abh_file.abh09
 
     DECLARE t110_abh_del CURSOR FOR
           SELECT abh_file.* FROM abh_file
                  WHERE abh00 = g_bookno AND abh01 = g_aba.aba01
                    AND abh02 = g_abb_t.abb02
     FOREACH t110_abh_del INTO l_abh.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('t110_abh_mod',SQLCA.sqlcode,0)   
           EXIT FOREACH
        END IF
        DELETE FROM abh_file WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
 
        SELECT sum(abh09) INTO l_abh09_2 FROM abh_file
         WHERE abhconf = 'Y' AND abh07 = l_abh.abh07
           AND abh08 = l_abh.abh08
        IF cl_null(l_abh09_2) THEN LET l_abh09_2 = 0 END IF
 
        SELECT sum(abh09) INTO l_abh09_3 FROM abh_file
         WHERE abhconf = 'N' AND abh07 = l_abh.abh07
           AND abh08 = l_abh.abh08
        IF cl_null(l_abh09_3) THEN LET l_abh09_3 = 0 END IF
        UPDATE abg_file SET abg072 = l_abh09_2,
                            abg073 = l_abh09_3
                        WHERE abg00 = g_bookno
                          AND abg01 = l_abh.abh07
                          AND abg02 = l_abh.abh08
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","abg_file",l_abh.abh07,l_abh.abh08,SQLCA.sqlcode,"","upd abg_file",1)  #No.FUN-660123
           LET g_success = 'N'
        END IF
     END FOREACH
END FUNCTION
 
FUNCTION t110_abhmod()
{
   DEFINE l_aba08     LIKE aba_file.aba08
   DEFINE l_aag222_old,l_aag222_new  LIKE aag_file.aag222
   DEFINE l_aag15_old LIKE aag_file.aag15
   DEFINE l_aag16_old LIKE aag_file.aag16
   DEFINE l_aag17_old LIKE aag_file.aag17
   DEFINE l_aag18_old LIKE aag_file.aag18
 
   DEFINE l_aag31_old LIKE aag_file.aag31
   DEFINE l_aag32_old LIKE aag_file.aag32
   DEFINE l_aag33_old LIKE aag_file.aag33
   DEFINE l_aag34_old LIKE aag_file.aag34
   DEFINE l_aag35_old LIKE aag_file.aag35
   DEFINE l_aag36_old LIKE aag_file.aag36
   DEFINE l_aag37_old LIKE aag_file.aag37
 
   DEFINE l_abh       RECORD LIKE abh_file.*
   DEFINE l_abh09_2,l_abh09_3  LIKE abh_file.abh09
 
   #--->原為立沖變為非立沖科目
   IF (g_abb_t.abb03 != g_abb[l_ac].abb03) OR
      (g_abb2_t.abb05 != g_abb2.abb05) OR
      (g_abb_t.abb06 != g_abb[l_ac].abb06) OR
      (g_abb2_t.abb11 != g_abb2.abb11) OR
      (g_abb2_t.abb12 != g_abb2.abb12) OR
      (g_abb2_t.abb13 != g_abb2.abb13) OR
      (g_abb2_t.abb14 != g_abb2.abb14) OR
 
      (g_abb2_t.abb31 != g_abb2.abb31) OR
      (g_abb2_t.abb32 != g_abb2.abb32) OR
      (g_abb2_t.abb33 != g_abb2.abb33) OR
      (g_abb2_t.abb34 != g_abb2.abb34) OR
      (g_abb2_t.abb37 != g_abb2.abb37)
 
   THEN
      SELECT aag222,aag15,aag16,aag17,aag18,
 
             aag31,aag32,aag33,aag34,aag35,aag36,aag37
 
        INTO l_aag222_old,l_aag15_old,l_aag16_old,l_aag17_old,
             l_aag18_old,
 
             l_aag31_old,l_aag32_old,l_aag33_old,l_aag34_old,
             l_aag35_old,l_aag36_old,l_aag37_old
 
        FROM aag_file
                   WHERE aag01 = g_abb_t.abb03
                     AND aag00 = g_bookno   #No.FUN-740020
 
      SELECT aag222 INTO l_aag222_new FROM aag_file
                   WHERE aag01 = g_abb[l_ac].abb03
                     AND aag00 = g_bookno   #No.FUN-740020
      IF ((l_aag222_old = '1' AND g_abb_t.abb06 = '2') OR
          (l_aag222_old = '2' AND g_abb_t.abb06 = '1'))
          AND ((l_aag15_old is not null AND l_aag15_old != ' ') OR
              (l_aag16_old is not null AND l_aag16_old != ' ') OR
              (l_aag17_old is not null AND l_aag17_old != ' ') OR
              (l_aag18_old is not null AND l_aag18_old != ' ') OR
 
              (l_aag31_old is not null AND l_aag31_old != ' ') OR
              (l_aag32_old is not null AND l_aag32_old != ' ') OR
              (l_aag33_old is not null AND l_aag33_old != ' ') OR
              (l_aag34_old is not null AND l_aag34_old != ' ') OR
              (l_aag35_old is not null AND l_aag35_old != ' ') OR
              (l_aag36_old is not null AND l_aag36_old != ' ') OR
              (l_aag37_old is not null AND l_aag37_old != ' '))
 
      THEN
           DECLARE t110_abh_mod CURSOR FOR
                 SELECT abh_file.* FROM abh_file
                        WHERE abh00=g_bookno AND abh01  = g_aba.aba01
                          AND abh02  = g_abb_t.abb02
           FOREACH t110_abh_mod INTO l_abh.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('t110_abh_mod',SQLCA.sqlcode,0)   
                 EXIT FOREACH
              END IF
              DELETE FROM abh_file WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
 
              SELECT sum(abh09) INTO l_abh09_2 FROM abh_file
               WHERE abhconf = 'Y' AND abh07 = l_abh.abh07
                 AND abh08 = l_abh.abh08
              IF cl_null(l_abh09_2) THEN LET l_abh09_2 = 0 END IF
 
              SELECT sum(abh09) INTO l_abh09_3 FROM abh_file
               WHERE abhconf = 'N' AND abh07 = l_abh.abh07
                 AND abh08 = l_abh.abh08
              IF cl_null(l_abh09_3) THEN LET l_abh09_3 = 0 END IF
              UPDATE abg_file SET abg072 = l_abh09_2,
                                  abg073 = l_abh09_3
                              WHERE abg00 = g_bookno
                                AND abg01 = l_abh.abh07
                                AND abg02 = l_abh.abh08
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","abg_file",l_abh.abh07,l_abh.abh08,SQLCA.sqlcode,"","upd abg_file",1)  #No.FUN-660123
                 LET g_success = 'N'
              END IF
           END FOREACH
      END IF
   END IF
}
END FUNCTION
 
FUNCTION t110_upamt()
   DEFINE l_str     STRING
   DEFINE l_aba08   LIKE aba_file.aba08,
          l_aba09   LIKE aba_file.aba09
 
   #-->借方合計
   SELECT SUM(abb07) INTO l_aba08 FROM abb_file,aag_file
    WHERE abb00 = g_aba.aba00
      AND aag00 = abb00   #No.FUN-740020
      AND abb01 = g_aba.aba01
      AND abb06 = '1' AND aag09 = 'Y' AND abb03 = aag01
      IF SQLCA.sqlcode THEN LET l_aba08 = 0 END IF
   #-->貸方合計
   SELECT SUM(abb07) INTO l_aba09 FROM abb_file,aag_file
    WHERE abb00 = g_aba.aba00
      AND aag00 = abb00   #No.FUN-740020
      AND abb01 = g_aba.aba01
      AND abb06 = '2' AND abb03 = aag01 AND aag09 = 'Y'
      IF SQLCA.sqlcode THEN LET l_aba09 = 0 END IF
 
   IF cl_null(l_aba08) THEN LET l_aba08 = 0 END IF
   IF cl_null(l_aba09) THEN LET l_aba09 = 0 END IF
 
   IF g_aac.aac03 = '1' THEN LET l_aba08 = l_aba09 END IF
   IF g_aac.aac03 = '2' THEN LET l_aba09 = l_aba08 END IF
 
   #-->單身有異動時同時要記錄異動日期與異動者
   UPDATE aba_file  SET aba08=l_aba08,
                        aba09=l_aba09,
                        abamodu=g_user,
                        abadate=g_today
    WHERE aba00 = g_aba.aba00
      AND aba01 = g_aba.aba01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aba_file",g_aba.aba00,g_aba.aba01,STATUS,"","update aba_amt",1)  #No.FUN-660123
         LET g_success = 'N'
      END IF
      LET g_aba.aba08 = l_aba08
      LET g_aba.aba09 = l_aba09
   #-->現收產生一筆項次為0
   IF g_aac.aac03 = '1' THEN #借方性質
      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb06,abb07f,abb07,
                           abb24,abb25,abblegal) #FUN-980003 add abblegal
           VALUES(g_aba.aba00,g_aba.aba01,0,g_aba.aba10,'1',g_aba.aba08,
                  g_aba.aba08,g_aaa.aaa03,1,g_legal) #FUN-980003 add g_legal
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
         UPDATE abb_file SET abb03=g_aba.aba10,
                             abb07=g_aba.aba08,
                             abb07f=g_aba.aba08
          WHERE abb00 = g_aba.aba00
            AND abb01 = g_aba.aba01
            AND abb02 = 0
      END IF
   END IF
   #-->現支產生一筆項次為0
   IF g_aac.aac03 = '2' THEN
      INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb06,
                           abb07f,abb07,abb24,abb25,abblegal) #FUN-980003 add abblegal
             VALUES(g_aba.aba00,g_aba.aba01,0,g_aba.aba10,'2',
                    g_aba.aba09,g_aba.aba09,g_aaa.aaa03,1,g_legal) #FUN-980003 add g_legal
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #no.TQC-790093
         UPDATE abb_file SET abb03 = g_aba.aba10,
                             abb07 = g_aba.aba09,
                             abb07f= g_aba.aba09
                       WHERE abb00 = g_aba.aba00 AND
                             abb01 = g_aba.aba01 AND
                             abb02 = 0
      END IF
   END IF
   DISPLAY BY NAME g_aba.aba08,g_aba.aba09
   LET l_str = s_sayc2(g_aba.aba08,50)
   DISPLAY l_str TO FORMONLY.tot
   
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t110_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_aba.aba01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM aba_file ",
                  "  WHERE aba01 LIKE '",l_slip,"%' ",
                  "    AND aba01 > '",g_aba.aba01,"'"
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
         CALL t110_v()
         IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_aba.aba20='1' OR
            g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti) 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM amd_file WHERE amd01 = g_aba.aba01 AND amd021='1'  #CHI-C80041
         DELETE FROM  aba_file WHERE  aba00 = g_bookno AND aba01 = g_aba.aba01
         INITIALIZE g_aba.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t110_delall()
    SELECT COUNT(*) INTO g_cnt FROM abb_file
        WHERE abb00 = g_bookno AND abb01 = g_aba.aba01
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 故取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM aba_file WHERE aba00 = g_bookno AND aba01 = g_aba.aba01
        LET g_msg = TIME
        INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal
          VALUES('gglt110.4gl',g_user,g_today,g_msg,g_aba.aba01,'NoBodyDelete',g_plant,g_legal) #FUN-980003 add g_plant,g_legal
    END IF
END FUNCTION
 
#檢查科目名稱
FUNCTION  t110_abb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti,
           aag05,aag15,aag16,aag17,aag18,aag151,
           aag161,aag171,aag181,aag06,aag21,aag23,aag222,aag20,
 
           aag31,aag32,aag33,aag34,aag35,aag36,aag37,
           aag311,aag321,aag331,aag341,aag351,aag361,aag371
 
        INTO l_aag02,l_aag03,l_aag07,l_aagacti,
             m_aag05,m_aag15,m_aag16,m_aag17,m_aag18,
             m_aag151,m_aag161,m_aag171,m_aag181,
             m_aag06,m_aag21,m_aag23,m_aag222,m_aag20,
 
             m_aag31,m_aag32,m_aag33,m_aag34,m_aag35,m_aag36,m_aag37,
             m_aag311,m_aag321,m_aag331,m_aag341,m_aag351,m_aag361,m_aag371
 
        FROM aag_file
        WHERE aag01 = g_abb[l_ac].abb03
          AND aag00 = g_bookno   #No.FUN-740020
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    LET g_abb[l_ac].aag02=l_aag02
    IF cl_null(m_aag05) THEN
       LET g_abb2.abb05 = NULL
    END IF
    IF cl_null(m_aag151)  THEN
       LET g_abb2.abb11=NULL
    END IF
    IF cl_null(m_aag161)  THEN
       LET g_abb2.abb12=NULL
    END IF
    IF cl_null(m_aag171) THEN
       LET g_abb2.abb13=NULL
    END IF
    IF cl_null(m_aag181) THEN
       LET g_abb2.abb14=NULL
    END IF
 
    IF cl_null(m_aag311) THEN
       LET g_abb2.abb31=NULL
    END IF
    IF cl_null(m_aag321) THEN
       LET g_abb2.abb32=NULL
    END IF
    IF cl_null(m_aag331) THEN
       LET g_abb2.abb33=NULL
    END IF
    IF cl_null(m_aag341) THEN
       LET g_abb2.abb34=NULL
    END IF
    IF cl_null(m_aag371) THEN
       LET g_abb2.abb37=NULL
    END IF
    IF cl_null(m_aag23) THEN
       LET g_abb2.abb08=NULL
       LET g_abb2.abb35=NULL  #No.TQC-840044
    END IF
    IF cl_null(g_errno) OR  p_cmd = 'a' THEN
    END IF
END FUNCTION
 
FUNCTION t110_abb05(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(01)
       l_gem02         LIKE gem_file.gem02,
       l_gem05         LIKE gem_file.gem05,
       l_gemacti       LIKE gem_file.gemacti,
       l_aag05         LIKE aag_file.aag05   #TQC-620028
 
   LET g_errno = ' '
   LET g_abb1[l_ac1].gem02 = NULL       # MOD-530419
   IF p_cmd='u' THEN
      SELECT aag05 INTO l_aag05 FROM aag_file
        WHERE aag01 = g_abb[l_ac].abb03
          AND aag00 = g_bookno   #No.FUN-740020
      IF l_aag05 = 'Y' THEN
         IF g_aaz.aaz90 !='Y' THEN    #FUN-8C0107 add
            CALL s_chkdept(g_aaz.aaz72,g_abb[l_ac].abb03,g_abb1[l_ac1].abb05,g_bookno)  #No.FUN-740020
                  RETURNING g_errno
            IF not cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) RETURN
            END IF
         END IF             #FUN-8C0107 add 
      END IF   #TQC-620028
   END IF
   SELECT gem02,gem05,gemacti
     INTO g_abb1[l_ac1].gem02,l_gem05,l_gemacti FROM gem_file
      WHERE gem01 = g_abb1[l_ac1].abb05
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN l_gem05  = 'N'      LET g_errno = 'agl-202'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
#      DISPLAY g_abb1[l_ac1].gem02 TO gem02
END FUNCTION
 
FUNCTION t110_error(p_code)
 DEFINE p_code   LIKE aag_file.aag15,
        l_str    LIKE ze_file.ze03,   #No.FUN-680098  VARCHAR(20),
        l_ahe02  LIKE ahe_file.ahe02  #FUN-5C0015
 
    SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = p_code #FUN-5C0015
 
    #-->顯示狀況
    IF p_code IS NOT NULL AND p_code != ' ' THEN
       CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
       LET l_str = l_str CLIPPED,l_ahe02,'!' #FUN-5C0015
       ERROR l_str
    END IF
END FUNCTION
 
FUNCTION t110_abb08(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680098 VARCHAR(01)
        l_pja02    LIKE pja_file.pja02,   #FUN-810045 gja->pja
        l_pjaacti  LIKE pja_file.pjaacti  #FUN-810045 gja->pja
       ,l_pjaclose LIKE pja_file.pjaclose #FUN-960038
 
  LET g_errno = ' '
    SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose   #No.FUN-960038 add pjaclose
            FROM pja_file WHERE pja01 = g_abb1[l_ac1].abb08
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-007'
         WHEN l_pjaacti = 'N'     LET g_errno = '9028'    #FUN-810045 gja->pja
         WHEN l_pjaclose = 'Y'    LET g_errno = 'abg-503' #FUN-960038
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION t110_abb35(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1, 
        l_pjb01    LIKE pjb_file.pjb01,  
        l_pjbacti  LIKE pjb_file.pjbacti,  
        l_pjb25    LIKE pjb_file.pjb25
DEFINE  l_pjb09    LIKE pjb_file.pjb09                     #No.FUN-850027 
DEFINE  l_pjb11    LIKE pjb_file.pjb11                     #No.FUN-850027
 
    LET g_errno = ' '
    SELECT pjb01,pjbacti,pjb09,pjb11,pjb25                 #No.FUN-850027
      INTO l_pjb01,l_pjbacti,l_pjb09,l_pjb11,l_pjb25       #No.FUN-850027
      FROM pjb_file
     WHERE pjb02 = g_abb1[l_ac1].abb35
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'apj-060'
         WHEN l_pjbacti = 'N'     LET g_errno = '9028' 
         WHEN l_pjb09 ! = 'Y'     LET g_errno = 'apj-090'  #No.FUN-850027
         WHEN l_pjb11 ! = 'Y'     LET g_errno = 'apj-090'  #No.FUN-850027
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION t110_abb36(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1, 
        l_azf02    LIKE azf_file.azf02,  
        l_azf03    LIKE azf_file.azf03,
        l_azfacti  LIKE azf_file.azfacti   
DEFINE  l_azf09    LIKE azf_file.azf09        #No.FUN-930106
 
    LET g_errno = ' '
    SELECT azf02,azf03,azfacti,azf09 INTO l_azf02,l_azf03,l_azfacti,l_azf09     #No.FUN-930106
            FROM azf_file WHERE azf01 = g_abb1[l_ac1].abb36
             AND azf02 ='2'                                                     #No.FUN-930106
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'mfg3088'
         WHEN l_azfacti = 'N'     LET g_errno = '9028' 
         WHEN l_azf02 ! = '2'     LET g_errno = 'mfg3088' 
         WHEN l_azf09 !='7'       LET g_errno='aoo-406'                            #No.FUN-950077
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION t110_abb11(p_cmd,p_seq,p_key)
 DEFINE p_cmd      LIKE aag_file.aag151,    # 檢查否
        p_seq      LIKE aee_file.aee02,     # 項     #No.FUN-680098 VARCHAR(1)
        p_key      LIKE aee_file.aee03,     # 異動碼 #No.FUN-680098 VARCHAR(20)
        l_aeeacti  LIKE aee_file.aeeacti,
        l_aee04    LIKE aee_file.aee04
 
   LET g_errno = ' '
 
   SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
    WHERE aee01 = g_abb[l_ac].abb03
      AND aee02 = p_seq
      AND aee03 = p_key
 
   CASE p_cmd
        WHEN '2'   #異動碼必須輸入不檢查
           IF p_key IS NULL OR p_key = ' ' THEN
              LET g_errno = 'agl-154'
           END IF
        WHEN '3'   #異動碼必須輸入要檢查
           CASE
              WHEN p_key IS NULL OR p_key = ' '
                   LET g_errno = 'agl-154'
               WHEN l_aeeacti = 'N' LET g_errno = '9027'
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'
               OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'
           END CASE
        OTHERWISE EXIT CASE
    END CASE
 
END FUNCTION
 
FUNCTION t110_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000     #No.FUN-680098       VARCHAR(200)
 
    CLEAR aag02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON abb02,abb03
            FROM s_abb[1].abb02,s_abb[1].abb03
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
                                                 #MOD-8A0037
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
 
    LET l_wc2=t110_subchr(l_wc2,'"',"'")
 
    CALL t110_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000,#No.FUN-680098    VARCHAR(200)
    l_n            LIKE type_file.num10   #No.FUN-680098    INTEGER
 define answer LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
DEFINE l_abb06     LIKE abb_file.abb06
DEFINE l_abb07     LIKE abb_file.abb07
DEFINE l_abb07f    LIKE abb_file.abb07f
 
    LET g_sql =
        " SELECT abb02,abb03,aag02,abb24,abb25,0,0,0,0,abb04",
        "   FROM abb_file LEFT OUTER JOIN aag_file ON abb03 = aag_file.aag01 AND abb00 = aag_file.aag00 ",
        " WHERE abb01 ='",g_aba.aba01,"' AND abb00 ='",g_aba.aba00,"' ", 
        "   AND abb02 != 0  ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY abb02"
    PREPARE t110_pb FROM g_sql
    DECLARE abb_curs                       #SCROLL CURSOR
        CURSOR FOR t110_pb
 
    CALL g_abb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH abb_curs INTO g_abb[g_cnt].*  #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT abb06,abb07,abb07f INTO l_abb06,l_abb07,l_abb07f FROM abb_file
         WHERE abb00 = g_aba.aba00 AND abb01 = g_aba.aba01
           AND abb02 = g_abb[g_cnt].abb02
        IF l_abb06 = '1' THEN
           LET g_abb[g_cnt].abb07d = l_abb07
           LET g_abb[g_cnt].abb07df= l_abb07f
           LET g_abb[g_cnt].abb07c = 0
           LET g_abb[g_cnt].abb07cf= 0
        ELSE
           LET g_abb[g_cnt].abb07d = 0
           LET g_abb[g_cnt].abb07df= 0
           LET g_abb[g_cnt].abb07c = l_abb07
           LET g_abb[g_cnt].abb07cf= l_abb07f
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_abb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t110_bp(p_ud)
   DEFINE   p_ud    LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)
            l_n     LIKE type_file.num10    #No.FUN-680098  INTEGER
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
  #gglt110.4gl、aglt130、gglt140有與EasyFlow整合
  #所以aoos010有勾選"與EasyFlow串聯"時
  #會顯示approval_status,easyflow_approval這兩個action
  #非這三支程式則不顯示這兩個action
  IF (g_prog <> 'gglt110.4gl') AND (g_prog <> 'aglt130') AND (g_prog <> 'gglt140') THEN
      CALL cl_set_act_visible("approval_status,easyflow_approval", FALSE)
  END IF
 
  DISPLAY BY NAME g_aba.aba00
   DISPLAY ARRAY g_abb TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      IF g_argv2 = '7' THEN
         CALL cl_set_act_visible("insert,modify,invalid,delete,detail,
                                  reproduce,confirm,undo_confirm",FALSE)
      END IF
      SELECT aza48 INTO g_aza48 FROM aza_file 
      SELECT count(*) INTO l_n FROM aag_file                                                                               
       WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file                                                          
                                        WHERE abb01 = g_aba.aba01
                                          AND abb00 = g_bookno) #No.MOD-7A0131
         AND aag00 = g_bookno   #No.FUN-740020
      IF g_aza.aza26 = '2' AND g_aza48 = 'Y' AND l_n > 0  THEN 
         CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",TRUE)  
      ELSE
         CALL cl_set_act_visible("cashier_confirm,undo_cashier_confirm",FALSE)
      END IF
      IF cl_null(g_argv1) THEN
         CALL cl_set_act_visible("source_query",FALSE)
      END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac > 0 THEN
            SELECT abb05,gem02,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36,abb37
              INTO g_abb2.*
              FROM abb_file LEFT OUTER JOIN gem_file ON gem01 = abb05
             WHERE abb00 = g_aba.aba00
               AND abb01 = g_aba.aba01
               AND abb02 = g_abb[l_ac].abb02
         END IF
         CALL t110_trans()
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
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
          IF g_aba.aba20='1' OR
             g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
          CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION enter_book_no
         LET g_action_choice="enter_book_no"
         EXIT DISPLAY
 
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION invoice
         LET g_action_choice="invoice"
         EXIT DISPLAY
 
      ON ACTION extra_memo
         LET g_action_choice="extra_memo"
         EXIT DISPLAY
 
      ON ACTION switch_plant
         LET g_action_choice="switch_plant"
         EXIT DISPLAY
 
      ON ACTION easyflow_approval                 #MOD-4A0299
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
      ON ACTION cashier_confirm
         LET g_action_choice = "cashier_confirm"
         EXIT DISPLAY
 
      ON ACTION undo_cashier_confirm
         LET g_action_choice = "undo_cashier_confirm"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION approval_status
         LET g_action_choice="approval_status"
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
 
      ON ACTION voucher_post
         LET g_action_choice="voucher_post"
         EXIT DISPLAY
 
      ON ACTION undo_post
         LET g_action_choice="undo_post"
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION source_query
         LET g_action_choice = 'source_query'
         EXIT DISPLAY
 
      ON ACTION contra_detail
         LET g_action_choice = 'contra_detail'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
  #與EasyFlow整合新增aglt130、gglt140這兩支程式
  #所以判斷要多判斷aglt130、gglt14
   IF (g_prog <> 'gglt110.4gl') AND (g_prog <> 'aglt130') AND (g_prog <> 'gglt140') THEN
       CALL cl_set_act_visible("approval_status,easyflow_approval", TRUE)
   END IF
END FUNCTION
 
 
FUNCTION t110_copy()
DEFINE   li_result  LIKE type_file.num5,   #No.FUN-560014 #No.FUN-680098 smallint
    l_aba        RECORD LIKE aba_file.*,
    l_year,l_month  LIKE type_file.num5,   #No.FUN-680098   SMALLINT
    l_oldno,l_newno LIKE aba_file.aba01,
    l_azn02         LIKE azn_file.azn02,
    l_azn04         LIKE azn_file.azn04 ,
    l_azm02         LIKE azm_file.azm02,  #FUN-570024
    l_azmm02        LIKE azmm_file.azmm02,#No.MOD-7A0131  
    l_aba02         LIKE aba_file.aba02,  #FUN-570024
    l_abamksg       LIKE aba_file.abamksg
DEFINE l_yy1        LIKE type_file.num5          #CHI-CB0004
DEFINE l_mm1        LIKE type_file.num5          #CHI-CB0004
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aba.aba01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_aba.* = g_aba.*
    #-->新的傳票日期改為今天
     LET l_aba.aba02  =g_today
     #FUN-570024  --begin
     IF g_argv2 = '4' THEN
       #No.MOD-7A0131--begin-- add
        IF g_aza.aza63 = 'Y' THEN
           SELECT azmm02 INTO l_azmm02 FROM azmm_file
            WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
           IF l_azmm02 ='1' THEN
              SELECT azmm122 INTO l_aba02 FROM azmm_file
               WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
           END IF
           IF l_azmm02 ='2' THEN
              SELECT azmm132 INTO l_aba02 FROM azmm_file
               WHERE azmm01 = YEAR(today)-1 AND azmm00 = g_aba.aba00
           END IF
        ELSE
       #No.MOD-7A0131---end---
           SELECT azm02 INTO l_azm02 FROM azm_file
            WHERE azm01 = YEAR(today)-1
           IF l_azm02 ='1' THEN
              SELECT azm122 INTO l_aba02 FROM azm_file
               WHERE azm01 = YEAR(today)-1
           END IF
           IF l_azm02 ='2' THEN
              SELECT azm132 INTO l_aba02 FROM azm_file
               WHERE azm01 = YEAR(today)-1
           END IF
        END IF    #No.MOD-7A0131
        LET l_aba.aba02 = l_aba02
     END IF
     CALL s_yp(g_today) RETURNING l_year,l_month
     IF g_argv2 != '4' THEN
        LET l_aba.aba03  =l_year
        LET l_aba.aba04  =l_month
     ELSE
        LET l_aba.aba03 = YEAR(today)
        LET l_aba.aba04 = 0
     END IF
     LET l_aba.aba05  =g_today
    #-->(aba16拋轉帳別)
     LET l_aba.aba16 = NULL
     DISPLAY l_aba.aba02,l_aba.aba03,l_aba.aba04,l_aba.aba05 TO
             aba02,aba03,aba04,aba05
 
     LET g_before_input_done = FALSE       #MOD-5B0098   拿掉原來的mark
     CALL t110_set_entry('a')
     LET g_before_input_done = TRUE        #MOD-5B0098   拿掉原來的mark
     CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT l_aba.aba02,l_newno WITHOUT DEFAULTS FROM aba02,aba01   #FUN-6A0006
 
       AFTER FIELD aba02
           IF g_aza.aza63 = 'Y' THEN
              SELECT aznn02,aznn04 INTO l_azn02,l_azn04  FROM aznn_file
                   WHERE aznn01 = l_aba.aba02 AND aznn00 = g_aba.aba00
           ELSE
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                   WHERE azn01 = l_aba.aba02
           END IF  #No.MOD-7A0131
           IF STATUS = 100 OR l_azn02 = 0 OR l_azn02 IS NULL THEN
               CALL cl_err('','agl-022',0)  
               NEXT FIELD aba02 
           END IF
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","azn_file",l_aba.aba02,"",SQLCA.sqlcode,"","read azn",1)  #No.FUN-660123
              NEXT FIELD aba02
           END IF
           #-->判斷關帳期間
           IF l_aba.aba02 <= g_aaa.aaa07 THEN
                CALL cl_err('','agl-086',0)
                NEXT FIELD aba02
           END IF
 
           LET l_aba.aba03 = l_azn02
           LET l_aba.aba04 = l_azn04
           DISPLAY BY NAME l_aba.aba03,l_aba.aba04
 
       BEFORE INPUT
          CALL cl_set_docno_format("aba01")
          LET g_before_input_done = FALSE
          CALL t110_set_entry('a')
          LET g_before_input_done = TRUE
 
       AFTER FIELD aba01
          CALL s_check_no("agl",l_newno,g_aba_t.aba01,"*","aba_file","aba01","")    #MOD-4A0299 #FUN-570024
               RETURNING li_result,l_newno
          DISPLAY l_newno TO aba01   #MOD-8A0205 add
          IF (NOT li_result) THEN
             LET l_newno = g_aba_o.aba01
             DISPLAY l_newno TO aba01   #MOD-8A0205 add
             NEXT FIELD aba01
          END IF
          LET g_t1 = s_get_doc_no(l_newno)     #MOD-4A0299
          SELECT aac08 INTO l_abamksg FROM aac_file WHERE aac01=g_t1 #MOD-4A0299   #FUN-920105 取消mark複製時要抓取單據是否簽核
          CASE g_argv2   #讀取單據性質資料
             WHEN '1'
                  SELECT * INTO g_aac.* FROM aac_file
                   WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='1'
             WHEN '3'
                  SELECT * INTO g_aac.* FROM aac_file
                   WHERE aac01=g_t1 AND aacacti = 'Y' AND aac11='3'
          END CASE
 
          IF SQLCA.sqlcode THEN             #抱歉, 讀不到
             CALL cl_err(g_t1,"agl-035",0)  #無此單別
             LET l_newno = g_aba_o.aba01
             DISPLAY l_newno TO aba01
             NEXT FIELD aba01
          END IF
          #add 不可使用系統使用之應計調整及結轉單別
          IF g_t1 = g_aaz.aaz65 OR g_t1=g_aaz.aaz68 THEN
             CALL cl_err(g_t1,"agl-191",0)
             LET l_newno = g_aba_o.aba01
             DISPLAY l_newno TO aba01
             NEXT FIELD aba01
          END IF
          IF cl_null(g_aac.aac13) THEN LET g_aac.aac13 = 'N' END IF
          DISPLAY g_aac.aac13 TO FORMONLY.aac13
 
          BEGIN WORK
 
       ON ACTION CONTROLP
          IF INFIELD(aba01) THEN #單據性質
             IF g_aaz.aaz70 MATCHES '[yY]' THEN
                IF g_argv2 != '4' THEN
                   CALL q_aac(FALSE,TRUE,g_aba.aba01,g_argv2,' ',g_user,'AGL')  #TQC-670008  
                   RETURNING l_newno
                ELSE
                   CALL q_aac(FALSE,TRUE,g_aba.aba01,'B',' ',g_user,'AGL')  #TQC-670008
                   RETURNING l_newno
                END IF
             ELSE
                IF g_argv2 != '4' THEN
                   CALL q_aac(FALSE,TRUE,g_aba.aba01,g_argv2,' ',' ','AGL') #TQC-670008      
                   RETURNING l_newno
                ELSE
                   CALL q_aac(FALSE,TRUE,g_aba.aba01,'B',' ',' ','AGL')  #TQC-670008
                   RETURNING l_newno
                END IF
             END IF
             DISPLAY l_newno TO aba01
             NEXT FIELD aba01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_aba.aba01
       ROLLBACK WORK
        RETURN
    END IF
          IF g_argv2 != '4' THEN
             CALL s_auto_assign_no("agl",l_newno,l_aba.aba02,"","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094 
                  RETURNING li_result,l_newno
          ELSE
             CALL s_auto_assign_no("agl",l_newno,l_aba.aba02,"B","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094 
                  RETURNING li_result,l_newno
          END IF
    LET l_aba.aba01  =l_newno   #新的鍵值
    #---no.4380 總號為 max+1 ---
    IF g_aaz.aaz81='Y' THEN #MOD-9A0081    
       LET l_yy1 = YEAR(l_aba.aba02)    #CHI-CB0004
       LET l_mm1 = MONTH(l_aba.aba02)   #CHI-CB0004
       SELECT MAX(aba11)+1
         INTO l_aba.aba11 FROM aba_file
        WHERE aba00 = g_bookno
          AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
          AND aba19 <> 'X' #CHI-C80041
      #CHI-CB0004--(B)
       IF cl_null(l_aba.aba11) OR l_aba.aba11 = 1 THEN
          LET l_aba.aba11 = YEAR(l_aba.aba02)*1000000+MONTH(l_aba.aba02)*10000+1
       END IF
      #CHI-CB0004--(E)
    END IF #MOD-9A0081     
    LET l_aba.aba18  ='0'
    LET l_aba.aba19  ='N'       #確認碼
    LET l_aba.aba20  ='0'       #狀況
    IF g_argv2 = '1' THEN LET l_aba.aba06 = 'GL' END IF
    IF g_argv2 = '3' THEN LET l_aba.aba06 = 'AC' END IF
    IF g_argv2 = '4' THEN LET l_aba.aba06 = 'AD' END IF #FUN-570024
    LET l_aba.abapost='N'       #過帳碼
    LET l_aba.aba35='N'
    LET l_aba.abaprno= 0        #列印次數
    LET l_aba.abauser=g_user    #資料所有者
    LET l_aba.abagrup=g_grup    #資料所有者所屬群
    LET l_aba.abamodu=NULL      #資料修改日期
    LET l_aba.abadate=g_today   #資料建立日期
    LET l_aba.abaacti='Y'       #有效資料
     LET l_aba.abamksg=l_abamksg #簽核否        # MOD-4A0299
    LET l_aba.abaoriu = g_user  #MOD-9C0256
    LET l_aba.abaorig = g_grup  #MOD-9C0256
    LET l_aba.aba37 = NULL
    LET l_aba.aba38 = NULL
    LET l_aba.abalegal = g_legal  #FUN-980003 add
    INSERT INTO aba_file VALUES (l_aba.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","aba_file",l_aba.aba00,l_aba.aba01,SQLCA.sqlcode,"","aba:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM abb_file         #單身複製
        WHERE abb01 = g_aba.aba01 AND
              abb00 = g_bookno
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_aba.aba01,g_bookno,SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x SET abb01=l_newno
    INSERT INTO abb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","abb_file",l_newno,"",SQLCA.sqlcode,"","abb:",1)  #No.FUN-660123
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_aba.aba01
    SELECT aba_file.* INTO g_aba.* FROM aba_file
                        WHERE aba00 = g_aba.aba00
                          AND aba01 = l_newno
    CALL t110_u()
    CALL t110_b('a')
    #FUN-C80046---begin
    #SELECT aba_file.* INTO g_aba.* FROM aba_file
    #                    WHERE aba00 = g_aba.aba00
    #                      AND aba01 = l_oldno
    #CALL t110_show()
    #FUN-C80046---end
END FUNCTION
 
FUNCTION t110_out()             # 查詢後整批列印, 印查詢出的數筆
   DEFINE l_cmd        LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(200),
          l_prog       LIKE type_file.chr50,  #No.FUN-680098   VARCHAR(40),
          l_wc,l_wc2   LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(300),
          i            LIKE type_file.num5,   #No.FUN-680098   SMALLINT,
          l_prtway     LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
 
   IF g_aba.aba01 IS NULL OR g_aba.aba01 = ' ' THEN RETURN END IF
 
   LET l_prog=''
   MENU ""
      ON ACTION voucher_print_132
        #LET l_prog='aglr902'  #FUN-C30085 mark
         LET l_prog='aglg902'  #FUN-C30085 add
         EXIT MENU
 
      ON ACTION voucher_print_80
         IF g_aza.aza26 = '2' THEN
            LET l_prog='gglr304'
         ELSE
           #LET l_prog='aglr903' #FUN-C30085 mark
            LET l_prog='aglg903' #FUN-C30085 add
         END IF
 
         EXIT MENU
 
 
      ON ACTION exit
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
 
   IF l_prog is null THEN RETURN END IF    #Genero add
  #IF l_prog = 'gglr304' OR l_prog='aglr903'OR l_prog = 'aglr902' THEN #CHI-6C0018 add    #TQC-970225  #FUN-C30085
   IF l_prog = 'gglr304' OR l_prog='aglg903'OR l_prog = 'aglg902' THEN #CHI-6C0018 add    #TQC-970225  #FUN-C30085
      LET g_wc = " aba01='",g_aba.aba01,"'"
   END IF
   LET l_wc = g_wc clipped," AND aba06!='RV' "
   #zz21:固定列印條件 zz22:固定列印方式
   LET g_msg = l_prog[1,8]
 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = g_msg
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
     #IF g_msg = "aglr902" THEN #FUN-C30085 mark
      IF g_msg = "aglg902" THEN #FUN-C30085 add
         LET l_wc2 = " '12' ' ' '3' '3' 'N' "
      ELSE
        #IF g_msg = "aglr903" THEN #FUN-C30085 mark
         IF g_msg = "aglg903" THEN #FUN-C30085 add
            LET l_wc2 = " '3' '3' 'N' '3' "
         ELSE
            LET l_wc2 = " '3' '3' '3' 'N' "
         END IF
      END IF
   END IF
  #IF g_msg = 'aglr902' THEN  #FUN-C30085 mark
   IF g_msg = 'aglg902' THEN  #FUN-C30085 add
      LET l_cmd = l_prog CLIPPED,
                   ' "',g_bookno,'"',
                   ' "',g_dbs CLIPPED,'"',
                   ' "',g_today CLIPPED,'"',
                   ' "" ',
                   ' "',g_lang CLIPPED,'"',
                   ' "Y"',
                   ' "',l_prtway,'"',
                   ' "1" ',
                   ' "',l_wc CLIPPED,'"',
                   ' ',l_wc2 CLIPPED,''
   ELSE
     #IF g_msg = 'aglr903' THEN   #MOD-6A0010   #FUN-C30085 mark
      IF g_msg = 'aglg903' THEN   #MOD-6A0010   #FUN-C30085 add
         LET l_cmd = l_prog CLIPPED,
                      ' "',g_bookno,'"',
                      ' "',g_dbs CLIPPED,'"',
                      ' "',g_today CLIPPED,'"',
                      ' "" ',
                      ' "',g_lang CLIPPED,'"',
                      ' "Y"',
                      ' "',l_prtway,'"',
                      ' "1" ',
                      ' "',l_wc CLIPPED,'"',
                      ' ',l_wc2 CLIPPED,''
      ELSE
         LET l_cmd = l_prog CLIPPED,
                      ' "',g_bookno,'"',
                      ' "',g_today CLIPPED,'"',
                      ' "" ',
                      ' "',g_lang CLIPPED,'"',
                      ' "Y"',
                      ' "',l_prtway,'"',
                      ' "1" ',
                      ' "',l_wc CLIPPED,'"',
                      ' ',l_wc2 CLIPPED,''
      END IF
   END IF
   CALL cl_wait()
   CALL cl_cmdrun(l_cmd CLIPPED)
   ERROR ""
END FUNCTION
 
FUNCTION t110_out2()            # 輸入後立即列印, 印輸入的單筆
   DEFINE l_cmd       LIKE type_file.chr1000,#No.FUN-680098 VARCHAR(200)
          l_prog      LIKE type_file.chr50,  #No.FUN-680098 VARCHAR(40)
          l_wc,l_wc2  LIKE type_file.chr1000,#No.FUN-680098 VARCHAR(300)
          l_prtway    LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
 
   IF g_aba.aba01 IS NULL OR g_aba.aba01 = ' ' THEN RETURN END IF
   IF g_aza.aza26 = '2' THEN
      LET l_prog='gglr304'
   ELSE
     #LET l_prog='aglr903'  #FUN-C30085 mark
      LET l_prog='aglg903'  #FUN-C30085 add
   END IF
      LET l_wc=" aba01='",g_aba.aba01,"'"
      LET g_msg = l_prog[1,8]
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = g_msg
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN 
        #IF g_msg = "aglr903" THEN  #FUN-C30085 mark
         IF g_msg = "aglg903" THEN  #FUN-C30085 add
            LET l_wc2 = " '3' '3' 'N' '3' "
         ELSE
            LET l_wc2 = " '3' '3' '3' 'N' "
         END IF
      END IF
 
   IF g_aza.aza26 = '2' THEN
      LET l_cmd = l_prog CLIPPED,
                  ' "',g_bookno,'"',
                  ' "',g_today CLIPPED,'"',
                  ' "" ',
                  ' "',g_lang CLIPPED,'"',
                  ' "Y"',
                  ' "',l_prtway,'"',
                  ' "1" ',
                  ' "',l_wc CLIPPED,'"',
                  ' ',l_wc2 CLIPPED,''
   ELSE
      LET l_cmd = l_prog CLIPPED,
                  ' "',g_bookno,'"',
                  ' "',g_dbs CLIPPED,'"',
                  ' "',g_today CLIPPED,'"',
                  ' "" ',
                  ' "',g_lang CLIPPED,'"',
                  ' "Y"',
                  ' "',l_prtway,'"',
                  ' "1" ',
                  ' "',l_wc CLIPPED,'"',
                  ' ',l_wc2 CLIPPED,''
   END IF
 
   CALL cl_wait()
   CALL cl_cmdrun(l_cmd CLIPPED)
   ERROR ""
END FUNCTION
 
FUNCTION t110_chgdbs()
  DEFINE l_dbs   LIKE type_file.chr21  #No.FUN-680098   VARCHAR(21)
  DEFINE l_cnt   LIKE type_file.num5   #MOD-7A0058
 
   COMMIT WORK
            LET INT_FLAG = 0  ######add for prompt bug
   CALL cl_getmsg('aom-303',g_lang) RETURNING g_msg
   PROMPT g_msg CLIPPED FOR g_plant    #MOD-8B0178
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END PROMPT
   IF g_plant IS NULL THEN RETURN END IF
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM zxy_file
     WHERE zxy01 = g_user AND zxy03 = g_plant
   IF l_cnt = 0 THEN
      CALL cl_err(g_user,'sub-118',1)
      RETURN
   END IF
   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
   CLOSE DATABASE   #MOD-7A0058
   DATABASE l_dbs
   CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
   IF STATUS THEN ERROR 'open database error!' RETURN END IF
   LET g_plant = g_plant
   LET g_dbs   = l_dbs
   SELECT aaz64 INTO g_bookno FROM aaz_file   #MOD-7A0058
   CURRENT WINDOW IS SCREEN
   CALL s_dsmark(g_bookno)
   CALL cl_dsmark(0)
   CURRENT WINDOW IS t110_w
   CLEAR FORM
   CALL g_abb.clear()
    CALL s_shwact(3,2,g_bookno)
   CALL t110_lock_cur()
END FUNCTION
 
FUNCTION t110_y_chk()
   DEFINE l_n   LIKE type_file.num5  #TQC-720027
   DEFINE p_cmd LIKE type_file.chr1  #No.FUN-830139 080415 add by hellen
 
   LET g_success = 'Y'
   IF s_shut(0) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF cl_null(g_aba.aba01) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_aba.aba02 <= g_aaa.aaa07 THEN
       LET g_success = 'N'
       CALL cl_err('','agl-085',0)
       RETURN
   END IF
 
   IF g_action_choice <> 'easyflow_approval' THEN
      SELECT count(*) INTO l_n FROM aag_file
       WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file
                                        WHERE abb01 = g_aba.aba01
                                          AND abb00 = g_bookno) #No.MOD-7A0131
         AND aag00 = g_bookno      #No.FUN-740020
      IF l_n>0 AND g_aza48="Y" THEN
         IF g_aba.aba35 = "N" THEN
            IF g_argv3 != 'efconfirm' OR cl_null(g_argv3) THEN
               IF g_action_choice = "agree" THEN
                  CALL cl_err('','aba-104',0)
               ELSE
                  CALL cl_err('','aba-104',0)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
      END IF
   END IF
 
   SELECT * INTO g_aba.* FROM aba_file
    WHERE aba01 = g_aba.aba01 AND aba00=g_aba.aba00
   IF g_aba.aba19='Y' THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_aba.abapost='Y' THEN
      CALL cl_err('','mfg0175',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_aba.abaacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_action_choice = 'confirm' THEN
      CALL t110_bud('','0')
      IF NOT cl_null(g_errno) THEN
         LET g_success = 'N'
         RETURN
      END IF
    END IF
   SELECT COUNT(*) INTO g_cnt FROM abb_file
    WHERE abb01=g_aba.aba01 AND abb00 = g_aba.aba00
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_aba.aba08 <> g_aba.aba09 THEN
      CALL cl_err('','agl-060',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #增加對單身異動碼的判斷
   CALL s_showmsg_init()
   CALL t110_chk() RETURNING g_success
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t110_y_upd()
   DEFINE only_one             LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
   DEFINE l_cmd                LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(400)
   DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-680098   SMALLINT
   DEFINE l_n                  LIKE type_file.num5   #TQC-720027
 
   LET p_row = 8 LET p_col = 30
   LET g_success = 'Y'
   LET only_one = '1'
   SELECT count(*) INTO l_n FROM aag_file
    WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file
                                     WHERE abb01 = g_aba.aba01
                                       AND abb00 = g_aba.aba00)  #No.MOD-7A0131
      AND aag00 = g_bookno    #No.FUN-740020
   IF l_n>0 AND g_aza48="Y" THEN
      IF g_aba.aba35 = 'N' AND
        (g_argv3='efconfirm' OR g_action_choice = 'agree') THEN
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_aba.aba19="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET g_aba.aba19="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
         LET g_aba.aba20='1'
         DISPLAY BY NAME g_aba.aba20
         RETURN
      END IF
   END IF
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640244
   THEN
       IF g_aba.abamksg='Y' THEN  
             IF g_aba.aba20 != '1' THEN
                   CALL cl_err('','aws-078',1)
                   LET g_success = 'N'
                   RETURN
             END IF
       END IF
 
       OPEN WINDOW t110_w6 AT p_row,p_col WITH FORM "agl/42f/gglt110.4gl_6"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
       CALL cl_ui_locale("gglt110.4gl_6")
 
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
          LET g_success = 'Y'
          CLOSE WINDOW t110_w6
       RETURN END IF
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " aba01 = '",g_aba.aba01,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON aba01,aba02,abauser
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds             #MOD-8A0037
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
         CLOSE WINDOW t110_w6
         RETURN
      END IF
   END IF
 
   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
   OR g_action_choice CLIPPED = "insert"     #FUN-640244
   THEN
     IF NOT cl_confirm('aap-222') THEN
        LET g_success = 'Y'
        CLOSE WINDOW t110_w6
        RETURN
     END IF
#CHI-C30107 -------------- add -------------- begin
      IF only_one = '1' THEN
         SELECT * INTO g_aba.* FROM aba_file WHERE aba01 = g_aba.aba01
                                               AND aba00 = g_aba.aba00
         CALL t110_y_chk()
      END IF
#CHI-C30107 -------------- add -------------- end
   END IF
   CALL cl_msg("WORKING !")
 
   BEGIN WORK
   
   CALL s_showmsg_init()      #MOD-7A0043
   CALL t110_y1()
   CALL s_showmsg()           #MOD-7A0043 
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN               #FUN-640184
      CLOSE WINDOW t110_w6
   END IF
 
   IF g_success = 'Y' THEN
      IF g_aba.abamksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_aba.aba19="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET g_aba.aba19="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_aba.aba20='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET g_aba.aba19='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         LET g_aba.aba37=g_user           #FUN-630066
         DISPLAY BY NAME g_aba.aba19
         DISPLAY BY NAME g_aba.aba20
         DISPLAY BY NAME g_aba.aba37      #FUN-630066
         COMMIT WORK
         CALL cl_flow_notify(g_aba.aba01,'Y')
      ELSE
         LET g_aba.aba19='N'
         LET g_aba.aba37=NULL             #FUN-630066
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_aba.aba19='N'
      LET g_aba.aba37=NULL                #FUN-630066
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_aba.* FROM aba_file WHERE aba01 = g_aba.aba01
                                         AND aba00 = g_aba.aba00  #No.TQC-690116
   DISPLAY BY NAME g_aba.aba18
   CALL s_pmksta('pmk',g_aba.aba20,'Y','Y') RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc2
   DISPLAY BY NAME g_aba.abamksg
   DISPLAY BY NAME g_aba.abasign
   IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_aba.aba20='1' OR
      g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_aba.aba20='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
   CALL cl_set_field_pic(g_aba.aba19,g_chr2,"",g_chr3,g_chr,g_aba.abaacti)
END FUNCTION
 
FUNCTION t110_z()
   DEFINE l_aba01_old LIKE aba_file.aba01
   DEFINE only_on     LIKE type_file.chr1    #No.FUN-680098    VARCHAR(01)
   DEFINE l_amt       LIKE abg_file.abg072
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aba.aba01) THEN RETURN END IF
   IF g_aba.aba20 = 'S' THEN
      CALL cl_err(g_aba.aba20,'apm-030',1)
      RETURN
   END IF
   IF g_aba.aba02 <= g_aaa.aaa07 THEN
       CALL cl_err('','agl-085',0)
       RETURN
   END IF
   SELECT * INTO g_aba.* FROM aba_file WHERE aba01 = g_aba.aba01
                                         AND aba00 = g_aba.aba00  #No.TQC-690116
   IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041                                     
   IF g_aba.aba19='N' THEN RETURN END IF
   IF g_aba.abapost='Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
   #-->已有沖帳資料的立帳不可刪除
    SELECT sum(abg072+abg073) INTO l_amt FROM abg_file
     WHERE abg01 = g_aba.aba01
    IF cl_null(l_amt) THEN LET l_amt = 0 END IF
    IF l_amt > 0 THEN
       CALL cl_err(g_aba.aba01,'agl-905',1)
       RETURN
    END IF
 
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t110_cl USING g_aba.aba00,g_aba.aba01
      IF STATUS THEN
         CALL cl_err("OPEN t110_cl:", STATUS, 1)
         CLOSE t110_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t110_cl INTO g_aba.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_aba.aba01,SQLCA.sqlcode,1)      # 資料被他人LOCK
         CLOSE t110_cl ROLLBACK WORK RETURN
      END IF
      CALL s_showmsg_init()      #MOD-7A0043
      CALL t110_z1()
      CALL s_showmsg()           #MOD-7A0043 
      CLOSE t110_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
         SELECT * INTO g_aba.* FROM aba_file WHERE aba01=g_aba.aba01
                                               AND aba00 = g_aba.aba00  #No.TQC-690116
         DISPLAY BY NAME g_aba.aba18
         DISPLAY BY NAME g_aba.aba19
         DISPLAY BY NAME g_aba.aba37
         DISPLAY BY NAME g_aba.aba20
      END IF
   END IF
   SELECT * INTO g_aba.* FROM aba_file WHERE aba01=g_aba.aba01
                                         AND aba00 = g_aba.aba00  #No.TQC-690116
   DISPLAY BY NAME g_aba.aba18
   DISPLAY BY NAME g_aba.aba19
   DISPLAY BY NAME g_aba.aba37
   DISPLAY BY NAME g_aba.aba20
   IF g_aba.aba19='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_aba.aba20='1' OR
      g_aba.aba20='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aba.aba19,g_chr2,"","",g_chr,g_aba.abaacti)   #MOD-590286
END FUNCTION
 
FUNCTION t110_y1()
   DEFINE l_aag       RECORD LIKE aag_file.*
   DEFINE l_gem       RECORD LIKE gem_file.*
   DEFINE l_aba03     LIKE aba_file.aba03
   DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(400)
   DEFINE l_sql       LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(400)
   DEFINE l_msg       LIKE type_file.chr1000 #No.FUN-680098    VARCHAR(60)
   DEFINE l_flag      LIKE type_file.chr1    #MOD-590286 #No.FUN-680098 VARCHAR(1)
 
   LET g_sql = "SELECT * FROM aba_file",
               " WHERE ", g_wc CLIPPED,
               " AND aba00 = '",g_bookno,"'",
               " AND aba06 !='RV' ",
               " AND aba19 = 'N' AND abapost = 'N' AND abaacti = 'Y'",
               " AND aba19 <> 'X' " #CHI-C80041
   PREPARE t110_yy1_pre FROM g_sql
   IF STATUS THEN
      CALL cl_err('t110_yy1_pre',STATUS,0) LET g_success = 'N' RETURN
   END IF
   DECLARE t110_yy1 CURSOR FOR t110_yy1_pre
 
   OPEN t110_cl USING g_aba.aba00,g_aba.aba01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      LET g_success = 'N'   #FUN-890128
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_aba.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aba.aba01,SQLCA.sqlcode,1)      # 資料被他人LOCK
       CLOSE t110_cl LET g_success='N' RETURN
   END IF
   LET l_flag = 0   #MOD-590286
   FOREACH t110_yy1 INTO m_aba.*
      IF STATUS THEN
        IF g_bgerr THEN       
          CALL s_errmsg(' ',' ','foreah',STATUS,1) LET g_success='N' EXIT FOREACH 
        ELSE
          CALL cl_err('foreah',STATUS,1) LET g_success='N' EXIT FOREACH
        END IF
      ELSE   #MOD-590286
         LET l_flag = 1   #MOD-590286
      END IF
      LET g_cnt = 0                                                                                                                 
      SELECT COUNT(*) INTO g_cnt FROM abb_file                                                                                      
       WHERE abb01=m_aba.aba01 AND abb00 = m_aba.aba00                                                                              
      IF g_cnt = 0 THEN                                                                                                             
         IF g_bgerr THEN                                                                                                            
            CALL s_errmsg('','','','arm-034',1)                                                                                     
         ELSE                                                                                                                       
            CALL cl_err('','arm-034',1)                                                                                             
         END IF                                                                                                                     
         LET g_success = 'N'                                                                                                        
         CONTINUE FOREACH                                                                                                           
      END IF                                                                                                                        
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y' 
      END IF                                                     
   #---A082 end 以下把原來g_aba的變數改為m_aba,不再一一註記
      LET g_t1 = s_get_doc_no(g_aba.aba01)     #No.FUN-560014
       SELECT aac03,aac08,aacsign INTO l_aba03,m_aba.abamksg,m_aba.abasign    #No.MOD-510168 add aac03
        FROM aac_file WHERE aac01=g_t1
      IF l_aba03!='0' THEN
         #-->科目已無效
         SELECT * INTO l_aag.* FROM aag_file WHERE aag01=m_aba.aba10
                                               AND aag00= g_bookno   #No.FUN-740020
         IF STATUS THEN
            IF g_bgerr THEN       
              CALL s_errmsg('aag01',m_aba.aba10,m_aba.aba10,'agl-002',1)             
            ELSE
             CALL cl_err3("sel","aag_file",m_aba.aba10,"","agl-002","","",1)  #No.FUN-660123  
            END IF
            LET g_success = 'N' CONTINUE FOREACH #NO.FUN-710023
         END IF
         IF l_aag.aagacti = 'N' THEN
            IF g_bgerr THEN       
              CALL s_errmsg('aag01',m_aba.aba10,m_aba.aba03,'mfg1004',1)            
            ELSE
               CALL cl_err(m_aba.aba03,'mfg1004',1)
            END IF
            LET g_success = 'N' CONTINUE FOREACH  #NO.FUN-710023
         END IF
      END IF  
      IF m_aba.aba18 IS NULL OR m_aba.aba18 = ' ' THEN
         LET m_aba.aba18='0'
      END IF
      IF m_aba.aba20 IS NULL OR m_aba.aba20 = ' ' THEN
         LET m_aba.aba20='0'
      END IF
      IF m_aba.abamksg='N' AND m_aba.aba20='0' THEN
        LET m_aba.aba20='1'
      END IF
      UPDATE aba_file SET abamksg= m_aba.abamksg,
                          abasign= m_aba.abasign,
                          aba18  = m_aba.aba18,
                          aba19  = 'Y',
                          aba37  = g_user,       #FUN-630066
                          aba20  = m_aba.aba20
       WHERE aba01 = m_aba.aba01 AND aba00 = g_bookno
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            IF g_bgerr THEN       
              LET g_showmsg=m_aba.aba01,"/",g_bookno
              CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba19',STATUS,1)             
            ELSE
              CALL cl_err3("upd","aba_file",m_aba.aba01,g_bookno,STATUS,"","upd aba19",1)  
            END IF
             LET g_success = 'N' CONTINUE FOREACH
         END IF
 
   DELETE FROM abg_file WHERE abg00=m_aba.aba00 AND abg01=m_aba.aba01
 
   LET l_sql = "SELECT abb_file.* FROM abb_file ",
               " WHERE abb00= '",g_bookno,"' AND abb01 = '",m_aba.aba01,"'",
               " ORDER BY abb02 "
   PREPARE t110_y FROM l_sql
   IF STATUS THEN 
     IF g_bgerr THEN       
         LET g_showmsg=g_bookno,"/",m_aba.aba01
         CALL s_errmsg('abb00,abb01',g_showmsg,'t110_y',STATUS,1) LET g_success = 'N'      
     ELSE
         CALL cl_err('t110_y',STATUS,1) LET g_success = 'N' 
     END IF
   END IF  
   DECLARE t110_y_curs CURSOR FOR t110_y
 
   FOREACH t110_y_curs INTO s_abb.*
      IF STATUS THEN
        IF g_bgerr THEN       
           LET g_showmsg=g_bookno,"/",m_aba.aba01
           CALL s_errmsg('abb00,abb01',g_showmsg,'foreach',STATUS,1) EXIT FOREACH    
        ELSE
           CALL cl_err('foreach',STATUS,1)  #EXIT FOREACH  #TQC-8A0022 mark
        END IF
        LET g_success = 'N'   #FUN-890128
        EXIT FOREACH   #TQC-8A0022
      END IF
      #-->科目已無效
      SELECT * INTO l_aag.* FROM aag_file WHERE aag01=s_abb.abb03
                                            AND aag00=g_bookno   #No.FUN-740020
      IF STATUS THEN
         IF g_bgerr THEN       
          CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb01+s_abb.abb03,'aap-262',1)     
         ELSE
          CALL cl_err(s_abb.abb01+s_abb.abb03,'aap-262',1)
         END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF l_aag.aagacti = 'N' THEN
         IF g_bgerr THEN       
            CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'mfg1004',1)
         ELSE
            CALL cl_err(s_abb.abb03,'mfg1004',1)
         END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      #-->科目設定不要異動碼可是傳票有輸入
      IF cl_null(l_aag.aag151) AND not cl_null(s_abb.abb11)
      THEN 
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
           CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
        LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag161) AND not cl_null(s_abb.abb12)
      THEN
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
           CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag171) AND not cl_null(s_abb.abb13)
      THEN 
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
          CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag181) AND not cl_null(s_abb.abb14)
      THEN 
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
           CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
 
      IF cl_null(l_aag.aag311) AND not cl_null(s_abb.abb31)
      THEN
        IF g_bgerr THEN       
          CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
          CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag321) AND not cl_null(s_abb.abb32)
      THEN
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
          CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag331) AND not cl_null(s_abb.abb33)
      THEN
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
           CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
      IF cl_null(l_aag.aag341) AND not cl_null(s_abb.abb34)
      THEN 
        IF g_bgerr THEN       
           CALL s_errmsg('abg01',s_abb.abb03,s_abb.abb03,'agl-911',1)
        ELSE
           CALL cl_err(s_abb.abb03,'agl-911',1)
        END IF
         LET g_success = 'N' EXIT FOREACH 
      END IF
 
     IF l_aag.aag05='Y' THEN
        CALL s_chkdept(g_aaz.aaz72,s_abb.abb03,s_abb.abb05,g_bookno)   #No.FUN-740020
             RETURNING g_errno
        IF not cl_null(g_errno) THEN
           LET l_msg = s_abb.abb03,'+',s_abb.abb05
           IF g_bgerr THEN       
            CALL s_errmsg(' ',' ',l_msg,g_errno,1)
           ELSE
            CALL cl_err(l_msg,g_errno,1)
           END IF
           LET g_success = 'N' EXIT FOREACH  #NO.FUN-710023
        END IF
 
      SELECT * INTO l_gem.* FROM gem_file WHERE gem01=s_abb.abb05
      IF STATUS THEN
         IF g_bgerr THEN       
            CALL s_errmsg('abg02',s_abb.abb02,s_abb.abb02,'agl-004',1) #MOD-990175        
         ELSE
            CALL cl_err(s_abb.abb02,'agl-004',1)   #MOD-990175                             
         END IF
         LET g_success = 'N' EXIT FOREACH
      END IF
      #-->部門已無效
      IF l_gem.gemacti = 'N' THEN
         IF g_bgerr THEN       
            CALL s_errmsg('abg02',s_abb.abb02,s_abb.abb02,'agl-004',1) #MOD-990175   
         ELSE
            CALL cl_err(s_abb.abb02,'agl-004',1) #MOD-990175   
         END IF
         LET g_success = 'N' EXIT FOREACH
      END IF
    END IF
 
     IF l_aag.aag20='Y' THEN
      #-------------(add產生立帳檔)----------
      #異動碼-1(aag15) 不為空白
      IF NOT cl_null(l_aag.aag15) OR NOT cl_null(l_aag.aag16) OR
         NOT cl_null(l_aag.aag17) OR NOT cl_null(l_aag.aag18) OR
 
         NOT cl_null(l_aag.aag31) OR NOT cl_null(l_aag.aag32) OR
         NOT cl_null(l_aag.aag33) OR NOT cl_null(l_aag.aag34) OR
         NOT cl_null(l_aag.aag35) OR NOT cl_null(l_aag.aag36) OR
         NOT cl_null(l_aag.aag37)
 
         THEN
         IF (l_aag.aag222='1' AND s_abb.abb06='1')  OR
            (l_aag.aag222='2' AND s_abb.abb06='2')  THEN
            IF cl_null(s_abb.abb11) THEN LET s_abb.abb11 = ' ' END IF
            IF cl_null(s_abb.abb12) THEN LET s_abb.abb12 = ' ' END IF
            IF cl_null(s_abb.abb13) THEN LET s_abb.abb13 = ' ' END IF
            IF cl_null(s_abb.abb14) THEN LET s_abb.abb14 = ' ' END IF
 
            IF cl_null(s_abb.abb31) THEN LET s_abb.abb31 = ' ' END IF
            IF cl_null(s_abb.abb32) THEN LET s_abb.abb32 = ' ' END IF
            IF cl_null(s_abb.abb33) THEN LET s_abb.abb33 = ' ' END IF
            IF cl_null(s_abb.abb34) THEN LET s_abb.abb34 = ' ' END IF
            IF cl_null(s_abb.abb37) THEN LET s_abb.abb37 = ' ' END IF
 
            CALL cl_msg('add abg_file......')  # ##FUN-640184
 
             INSERT INTO abg_file(abg00,abg01,abg02,abg03,abg04,abg05,  #No.MOD-470041
                                 abg06,abg071,abg072,abg073,abg11,abg12,
                                 abg13,abg14,
 
                                 abg31,abg32,abg33,abg34,abg35,abg36,
 
                                 abg15,abg16,abg17,abglegal) #FUN-980003 add abglegal
                VALUES(m_aba.aba00,m_aba.aba01,s_abb.abb02,s_abb.abb03,
                       s_abb.abb04,s_abb.abb05,m_aba.aba02,s_abb.abb07,0,0,
                       s_abb.abb11,s_abb.abb12,s_abb.abb13,s_abb.abb14,
 
                       s_abb.abb31,s_abb.abb32,s_abb.abb33,s_abb.abb34,
                       s_abb.abb35,s_abb.abb36,
 
                       '1',' ',' ',g_legal) #FUN-980003 add g_legal
            IF STATUS THEN
               IF g_bgerr THEN
                 LET g_showmsg=m_aba.aba00,"/",m_aba.aba01,"/",m_aba.aba02,"/",m_aba.aba03
                 CALL s_errmsg('abg00,abg01,abg02,abg03',g_showmsg,s_abb.abb01+s_abb.abb02,STATUS,1)
               ELSE
                 CALL cl_err3("ins","abg_file",m_aba.aba01,s_abb.abb02,STATUS,"","",1)
               END IF 
               LET g_success = 'N' CONTINUE FOREACH
            END IF
         END IF          
         #-------------(end add)更新立帳檔之己沖金額(+)----------
         CALL t110_abg('+',l_aag.aag222)
      END IF
    END IF
    IF g_success='Y' THEN
         SELECT COUNT(*) INTO g_cnt FROM abb_file
          WHERE abb01 = g_aba.aba01
            AND abb00 = g_aba.aba00
         IF g_cnt = 0 AND g_aba.abamksg = 'Y' THEN
            IF g_bgerr THEN
               LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
               CALL s_errmsg('abg00,abg01,abg02,abg03',g_showmsg,' ','aws-065',1)
            ELSE
               CALL cl_err(' ','aws-065',1)       
            END IF 
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH
   CALL cl_msg(m_aba.aba01)                    ##FUN-640184
 END FOREACH
 IF l_flag = 0 THEN
    IF g_bgerr  THEN
     CALL s_errmsg(' ',' ',' ',100,1) LET g_success = 'N'
     LET g_success='N'
    ELSE
     CALL cl_err('',100,1) LET g_success = 'N'
    END IF
 END IF      
 IF g_totsuccess="N" THEN                                                        
    LET g_success="N"                                                           
 END IF                                                                          
END FUNCTION
 
FUNCTION t110_z1()
 DEFINE l_sql       LIKE type_file.chr1000,#No.FUN-680098    VARCHAR(200)
        l_aag       RECORD LIKE aag_file.*
 
    #-->bug no:2870 簽核否='N',取消確認時要變更狀態碼
    #LET g_aba.aba20 = '0'   #TQC-720027
    LET g_aba.aba18=g_aba.aba18+1
    UPDATE aba_file SET aba18= g_aba.aba18,
                        aba19= 'N',
                        aba37=' '      #FUN-630066
                        #aba20= g_aba.aba20   #TQC-720027
     WHERE aba01 = g_aba.aba01
       AND aba00 = g_bookno
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","aba_file",g_aba.aba01,g_bookno,STATUS,"","upd aba19",1)  #No.FUN-660123
        LET g_success = 'N' RETURN 
     END IF
 
     IF g_aba.aba35 = 'N' OR g_aba.aba35 IS NULL THEN    #MOD-770101
        LET g_aba.aba20 = '0'
        UPDATE aba_file SET aba20 = g_aba.aba20
          WHERE aba01=g_aba.aba01
            AND aba00=g_bookno
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","aba_file",g_aba.aba01,"",STATUS,"","",1) LET g_success = 'N' RETURN
        END IF
     END IF
 
   LET l_sql = "SELECT abb_file.* FROM abb_file ",
            " WHERE abb00= '",g_bookno,"' AND abb01 = '",g_aba.aba01,"'",
            " ORDER BY abb02 "
   PREPARE t110_z FROM l_sql
   IF STATUS THEN CALL cl_err('t110_z',STATUS,1) LET g_success = 'N' END IF
   DECLARE t110_z_curs CURSOR FOR t110_z
   FOREACH t110_z_curs INTO s_abb.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('t110_z_curs',SQLCA.sqlcode,1)
        LET g_success = 'N'        #FUN-8A0086
        EXIT FOREACH
     END IF
         SELECT * INTO l_aag.* FROM aag_file WHERE aag01=s_abb.abb03
                                               AND aag00=g_bookno    #No.FUN-740020
         IF STATUS THEN
            CALL cl_err3("sel","aag_file",s_abb.abb03,"","aap-262","","",1)  #No.FUN-660123
            LET g_success = 'N' RETURN
         END IF
         #異動碼-1(aag15) 不為空白
        IF l_aag.aag20='Y' THEN
         IF NOT cl_null(l_aag.aag15) OR NOT cl_null(l_aag.aag16) OR
            NOT cl_null(l_aag.aag17) OR NOT cl_null(l_aag.aag18) OR
 
            NOT cl_null(l_aag.aag31) OR NOT cl_null(l_aag.aag32) OR
            NOT cl_null(l_aag.aag33) OR NOT cl_null(l_aag.aag34) OR
            NOT cl_null(l_aag.aag35) OR NOT cl_null(l_aag.aag36)
 
            THEN
            IF (l_aag.aag222='1' AND s_abb.abb06='1')  OR
               (l_aag.aag222='2' AND s_abb.abb06='2')  THEN
               MESSAGE 'del abg_file......'
               DELETE FROM abg_file
               WHERE abg00=g_aba.aba00 AND abg01=g_aba.aba01
                 AND abg02=s_abb.abb02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
                  CALL cl_err3("del","abg_file",g_aba.aba01,s_abb.abb02,STATUS,"","",1)  #No.FUN-660123
                  LET g_success = 'N' RETURN
               END IF
            END IF
            #-------------(end add)更新立帳檔之己沖金額(-)----------
            CALL t110_abg('-',l_aag.aag222)
         END IF
        END IF
   END FOREACH
      #取消簽核的處理
      IF g_aba.abamksg MATCHES '[Yy]'  THEN
         LET g_aba.abasseq = 0
         DELETE FROM azd_file WHERE azd01 = g_aba.aba01 AND azd02 = 2
         IF STATUS  THEN  LET g_success = 'N' RETURN
         ELSE
            CALL s_signm(6,34,g_lang,'2',g_aba.aba01,2,g_aba.abasign,
                 g_aba.abadays,g_aba.abaprit,g_aba.abasmax,g_aba.abasseq)
         END IF
      END IF
 
END FUNCTION
 
FUNCTION t110_abg(p_type,p_aag222)
 DEFINE p_type     LIKE type_file.chr1    #No.FUN-680098   VARCHAR(01)
 DEFINE p_aag222   LIKE aag_file.aag222
 DEFINE l_msg      LIKE type_file.chr1000#No.FUN-680098  VARCHAR(70)
 DEFINE l_rem      LIKE abh_file.abh09
 DEFINE l_abh09    LIKE abh_file.abh09
 DEFINE l_abh      RECORD LIKE abh_file.*
 
   IF cl_null(p_aag222) THEN LET p_aag222 = ' ' END IF
   IF p_aag222 not matches '[12]' THEN RETURN END IF
   IF (p_aag222='1' AND s_abb.abb06='1')  OR
      (p_aag222='2' AND s_abb.abb06='2')
   THEN RETURN
   END IF
   #--->檢查是否沖銷金額一致
   IF p_type = '+' THEN
      SELECT SUM(abh09) INTO l_abh09 FROM abh_file
                WHERE abh00=s_abb.abb00 AND abh01 = s_abb.abb01
                  AND abh02=s_abb.abb02
      IF cl_null(l_abh09) THEN LET l_abh09 = 0 END IF
      IF s_abb.abb07 != l_abh09 THEN
         LET l_msg = 'Item:',s_abb.abb02 using'###&',' - ',
                     'Acc :',s_abb.abb03 clipped,' - ',
                     'Cost:',l_abh09 using '##########&.&&'
         IF  g_bgerr THEN
            LET g_showmsg=s_abb.abb00,"/",s_abb.abb01,"/",s_abb.abb02
            CALL s_errmsg('abh00,abh01,abh02',g_showmsg,l_msg,'agl-900',1)       
         ELSE
            CALL cl_err(l_msg,'agl-900',0)
         END IF 
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
 
   DECLARE s_post_abh_c CURSOR FOR
         SELECT abh_file.*  FROM abh_file
                WHERE abh00=s_abb.abb00 AND abh01 = s_abb.abb01
                  AND abh02=s_abb.abb02
   FOREACH s_post_abh_c INTO l_abh.*
      IF SQLCA.sqlcode THEN
         IF  g_bgerr THEN
            LET g_showmsg=s_abb.abb00,"/",s_abb.abb01,"/",s_abb.abb02
            CALL s_errmsg('abh00,abh01,abh02',g_showmsg,'s_post_abh_c',SQLCA.sqlcode,1)       
         ELSE
            CALL cl_err('s_post_abh_c',SQLCA.sqlcode,0)
         END IF 
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF p_type = '+' THEN
         #--->update 立帳之已沖金額(多key 防止立帳資料有所變動)
         IF l_abh.abh11 IS NULL THEN LET l_abh.abh11 =' ' END IF
         IF l_abh.abh12 IS NULL THEN LET l_abh.abh12 =' ' END IF
         IF l_abh.abh13 IS NULL THEN LET l_abh.abh13 =' ' END IF
         IF l_abh.abh14 IS NULL THEN LET l_abh.abh14 =' ' END IF
 
         IF l_abh.abh31 IS NULL THEN LET l_abh.abh31 =' ' END IF
         IF l_abh.abh32 IS NULL THEN LET l_abh.abh32 =' ' END IF
         IF l_abh.abh33 IS NULL THEN LET l_abh.abh33 =' ' END IF
         IF l_abh.abh34 IS NULL THEN LET l_abh.abh34 =' ' END IF
         IF l_abh.abh35 IS NULL THEN LET l_abh.abh35 =' ' END IF
         IF l_abh.abh36 IS NULL THEN LET l_abh.abh36 =' ' END IF
 
         UPDATE abg_file SET abg072 = abg072 + l_abh.abh09, #己沖
                             abg073 = abg073 - l_abh.abh09  #預沖
                       WHERE abg00 = l_abh.abh00
                         AND abg01 = l_abh.abh07 AND abg02 = l_abh.abh08
                         AND abg03 = l_abh.abh03 AND (abg05 = l_abh.abh05
                         OR abg05 IS NULL OR abg05=' ')
                         AND (abg11 = l_abh.abh11 OR abg11 IS NULL OR abg11=' ')
                         AND (abg12 = l_abh.abh12 OR abg12 IS NULL OR abg12=' ')
                         AND (abg13 = l_abh.abh13 OR abg13 IS NULL OR abg13=' ')
                         AND (abg14 = l_abh.abh14 OR abg14 IS NULL OR abg14=' ')
                         AND (abg31 = l_abh.abh31 OR abg31 IS NULL OR abg31=' ')
                         AND (abg32 = l_abh.abh32 OR abg32 IS NULL OR abg32=' ')
                         AND (abg33 = l_abh.abh33 OR abg33 IS NULL OR abg33=' ')
                         AND (abg34 = l_abh.abh34 OR abg34 IS NULL OR abg34=' ')
                         AND (abg35 = l_abh.abh35 OR abg35 IS NULL OR abg35=' ')
                         AND (abg36 = l_abh.abh36 OR abg36 IS NULL OR abg36=' ')
 
 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
            LET l_msg = l_abh.abh07,'-',l_abh.abh08 using'#&','-',
                      l_abh.abh03[1,6],'-',s_abb.abb02 using '#&' clipped
            IF  g_bgerr THEN
             LET g_showmsg=l_abh.abh00,"/",l_abh.abh07,"/",l_abh.abh08,"/",l_abh.abh03
             CALL s_errmsg('abg00,abg01,abg02,abg03',g_showmsg,l_msg,'agl-909',1)      
            ELSE
             CALL cl_err3("upd","abg_file",l_abh.abh07,l_abh.abh08,"agl-909","","",1)  
            END IF 
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE abh_file SET abhconf = 'Y' WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF  g_bgerr THEN
              CALL s_errmsg('abh01',l_abh.abh01,'upd abh_file',SQLCA.sqlcode,1)       #No.FUN-9B0022
            ELSE
              CALL cl_err3("upd","abh_file",l_abh.abh01,l_abh.abh02,SQLCA.sqlcode,"","upd abh_file",1)
            END IF 
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         #--->控制沖帳是否有超沖
          SELECT (abg071-abg072-abg073) INTO l_rem FROM abg_file
                       WHERE abg01 = l_abh.abh07
                         AND abg02 = l_abh.abh08
                         AND abg00 = l_abh.abh00
          IF SQLCA.sqlcode THEN
            LET l_msg = s_abb.abb01,'-',s_abb.abb02 using '##&' clipped
            IF  g_bgerr THEN
              LET g_showmsg=l_abh.abh07,"/",l_abh.abh08,"/",l_abh.abh00
              CALL s_errmsg('abg01,abg02,abg00',g_showmsg,l_msg,'agl-909',1)      
            ELSE
              CALL cl_err3("sel","l_rem",l_msg,"","agl-909","","",1)  
            END IF 
            LET g_success = 'N'
            EXIT FOREACH
          END IF
          IF cl_null(l_rem) THEN LET l_rem = -1 END IF
          IF l_rem < 0  THEN
             LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '##&' clipped
             IF  g_bgerr THEN
              LET g_showmsg=l_abh.abh07,"/",l_abh.abh08,"/",l_abh.abh00
              CALL s_errmsg('abg01,abg02,abg00',g_showmsg,l_msg,'agl-908',1)      
             ELSE
              CALL cl_err(l_msg,'agl-908',0)    
             END IF 
             LET g_success = 'N'
             EXIT FOREACH
          END IF
      ELSE
         #--->update 立帳之已沖金額
         UPDATE abg_file SET abg072 = abg072 - l_abh.abh09, #己沖
                             abg073 = abg073 + l_abh.abh09  #預沖
                       WHERE abg01 = l_abh.abh07
                         AND abg02 = l_abh.abh08
                         AND abg00 = l_abh.abh00
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
            IF  g_bgerr THEN
              LET g_showmsg=l_abh.abh07,"/",l_abh.abh08,"/",l_abh.abh00
              CALL s_errmsg('abg01,abg02,abg00',g_showmsg,'upd abg_file',SQLCA.sqlcode,1)      
            ELSE
              CALL cl_err3("upd","abg_file",l_abh.abh07,l_abh.abh08,SQLCA.sqlcode,"",'upd abg_file',1) 
            END IF 
            LET g_success = 'N'
         END IF
         UPDATE abh_file SET abhconf = 'N' WHERE abh00 = l_abh.abh00 AND abh01 = l_abh.abh01 AND abh02 = l_abh.abh02 AND abh06 = l_abh.abh06 AND abh07 = l_abh.abh07 AND abh08 = l_abh.abh08
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF  g_bgerr THEN
              CALL s_errmsg('abh01',l_abh.abh01,'upd abh_file',SQLCA.sqlcode,1)      #No.FUN-9B0022
            ELSE
              CALL cl_err3("upd","abh_file",l_abh.abh01,l_abh.abh02,SQLCA.sqlcode,"","upd abh_file",1)  
            END IF 
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t110_subchr(p_str,p_chr1,p_chr2)
DEFINE p_str          LIKE type_file.chr1000,
       p_chr1,p_chr2  LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(01),
       l_str          LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(700)
DEFINE l_n  LIKE type_file.num5   #MOD-740068 add
DEFINE buf  base.StringBuffer     #MOD-850304 add
 
   LET buf = base.StringBuffer.create()
   CALL buf.clear()
   CALL buf.append(p_str)
   DISPLAY buf.toString()
   CALL buf.replace(p_chr1,p_chr2,0)
   DISPLAY buf.toString()
   LET l_str = buf.toString()
 
   RETURN l_str
END FUNCTION
 
FUNCTION t110_g()
   DEFINE l_cmd        LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(200)
          l_prog       LIKE type_file.chr20,  #No.FUN-680098   VARCHAR(10)
          l_wc,l_wc2   LIKE type_file.chr50,  #No.FUN-680098   VARCHAR(50)
          l_prtway     LIKE type_file.chr1    #No.FUN-680098   VARCHAR(1)
   DEFINE l_sw         LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
          l_n          LIKE type_file.num5,   #No.FUN-680098   SMALLINT
          l_buf        LIKE type_file.chr6,   #No.FUN-680098   VARCHAR(6)
          l_name       LIKE type_file.chr20   #No.FUN-680098   VARCHAR(20)
   DEFINE l_easycmd    LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(4096)
          l_updsql_0   LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(500)
          l_updsql_1   LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(500)
          l_updsql_2   LIKE type_file.chr1000,#No.FUN-680098   VARCHAR(500)
          l_upload     LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(1000)
 
 
   IF g_aza.aza23 matches '[ Nn]'
     THEN
     CALL cl_err('aza23','mfg3551',0)
     RETURN
   END IF
 
   IF g_aba.aba01 IS NULL OR g_aba.aba01 = ' '
     THEN RETURN
   END IF
 
   IF g_aba.abamksg IS NULL OR g_aba.abamksg matches '[Nn]'
     THEN
     CALL cl_err('','mfg3549',0)
     RETURN
   END IF
 
   IF g_aba.aba19 matches '[Nn]'
     THEN
     CALL cl_err('','mfg3550',0)
     RETURN
   END IF
 
   IF g_aba.aba20 matches '[Ss1]'
     THEN
     CALL cl_err('','mfg3557',0)  #本單據目前已送簽或已核准
     RETURN
   END IF
 
#--- 產生本張單據之報表檔
  #LET l_prog='aglr903' #FUN-C30085 mark
   LET l_prog='aglg903' #FUN-C30085 add
 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = l_prog
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN LET l_wc2 = " '3' '3' 'N' '3' " END IF
 
#---- 抓報表檔名  l_name
   CALL cl_outnam(l_prog) RETURNING l_name
   LET l_cmd = l_prog CLIPPED,
               " '",g_bookno,"' '",g_dbs,"'",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '0' '1'",
               " 'aba01 = "",g_aba.aba01,""' ",
               " '3' '3' 'Y' '3'",
               " '",l_name CLIPPED,"'"
    CALL cl_cmdrun(l_cmd)
 
   LET l_updsql_0="UPDATE aba_file SET aba20='S' WHERE aba01='",g_aba.aba01,"'",
                  " AND aba00='",g_bookno,"';"
   LET l_updsql_1="UPDATE aba_file SET aba20='1' WHERE aba01='",g_aba.aba01,"'",
                  " AND aba00='",g_bookno,"';"
   LET l_updsql_2="UPDATE aba_file SET aba20='R' WHERE aba01='",g_aba.aba01,"'",
                  " AND aba00='",g_bookno,"';"
   LET l_easycmd='ef ',
                 '"','TIPTOP_AGL','" ',                 #E-Form單別
                 '"','gglt110.4gl','" ',                    #程式代號
                 '"',g_aba.aba01 CLIPPED,'" ',          #單號
                 '"',g_dbs CLIPPED,'" ',                #資料庫(連線字串)
                 '"',l_updsql_0 CLIPPED,'" ',           #更新狀況碼-送簽中
                 '"',l_updsql_1 CLIPPED,'" ',           #簽核同意
                 '"',l_updsql_2 CLIPPED,'" ',           #簽核不同意
                 '"','1','" ',                          #附件總數
                 '"',l_name CLIPPED,'" ',               #報表檔徑名
                 '"','2','" ',                          #條件欄位總數
                 '"C',g_aba.abasign CLIPPED,'" ',        #條件1: 簽核等級
                 '"N','5000','" '                       #條件2: 總金額
  RUN l_easycmd
END FUNCTION
 
FUNCTION t110_ef()
   IF g_aba.aba35 = 'Y' THEN
      CALL cl_err('','aba-101',1)
      RETURN
   END IF
   CALL t110_y_chk()     #CALL 原確認的 check 段   #FUN-580152
   IF g_success = "N" THEN
       RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
   IF aws_efcli2(base.TypeInfo.create(g_aba),base.TypeInfo.create(g_abb),'','','','') THEN
      LET g_success = 'Y'
      LET g_aba.aba20 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_aba.aba20
   ELSE
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t110_abb24(p_key)
   DEFINE p_key     LIKE azi_file.azi01
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = ''
 
   SELECT aziacti INTO l_aziacti FROM azi_file
    WHERE azi01 = p_key
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3008'
         LET l_aziacti = ''
      WHEN l_aziacti = 'N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
 
FUNCTION t110_chkb()
 
   SELECT SUM(abb07f),SUM(abb07)
     INTO g_abb07f_t1,g_abb07_t1
     FROM abb_file
    WHERE abb00 = g_aba.aba00
      AND abb01 = g_aba.aba01
      AND abb06 = '1'
 
   SELECT SUM(abb07f),SUM(abb07)
     INTO g_abb07f_t2,g_abb07_t2
     FROM abb_file
    WHERE abb00 = g_aba.aba00
      AND abb01 = g_aba.aba01
      AND abb06 = '2'
 
   IF cl_null(g_abb07f_t1) THEN
      LET g_abb07f_t1 = 0
   END IF
 
   IF cl_null(g_abb07_t1) THEN
      LET g_abb07_t1 = 0
   END IF
 
   IF cl_null(g_abb07f_t2) THEN
      LET g_abb07f_t2 = 0
   END IF
 
   IF cl_null(g_abb07_t2) THEN
      LET g_abb07_t2 = 0
   END IF
 
   DISPLAY g_abb07f_t1,g_abb07_t1,g_abb07f_t2,g_abb07_t2
        TO FORMONLY.abb07f_t1,FORMONLY.abb07_t1,
           FORMONLY.abb07f_t2,FORMONLY.abb07_t2
 
END FUNCTION
 
FUNCTION t110_bud(p_cmd,p_flag)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE p_flag     LIKE type_file.chr1
   DEFINE l_msg      LIKE ze_file.ze03
   DEFINE l_tol      LIKE abb_file.abb07
   DEFINE l_tol1     LIKE abb_file.abb07
   DEFINE total_t    LIKE abb_file.abb07 
   DEFINE l_flag     LIKE type_file.num5
   DEFINE l_afb07    LIKE afb_file.afb07
   DEFINE l_amt      LIKE afc_file.afc07
   DEFINE l_abb05    LIKE abb_file.abb05
   DEFINE l_buf      LIKE ze_file.ze03
   DEFINE l_buf1     LIKE ze_file.ze03
   DEFINE l_flag1    LIKE type_file.chr1
   DEFINE l_bookno1  LIKE aaa_file.aaa01
   DEFINE l_bookno2  LIKE aaa_file.aaa01
   DEFINE l_fac      LIKE type_file.num5  #No.TQC-840044
   DEFINE l_abb06    LIKE abb_file.abb06
   DEFINE l_abb07    LIKE abb_file.abb07
   DEFINE t_abb07    LIKE abb_file.abb07
   
   LET g_errno = ''
   SELECT aag21 INTO m_aag21 FROM aag_file  #MOD-980175                                                                             
    WHERE aag01=g_abb[l_ac].abb03 AND aag00=g_bookno #MOD-980175   
   IF m_aag21 <> 'Y' THEN
      RETURN
   END IF
   
   IF g_aza.aza08 = 'N' THEN
      LET g_abb2.abb08 = ' '
      LET g_abb2.abb35 = ' '
   END IF
   
   IF g_aba.aba00 IS NULL OR g_aba.aba03 IS NULL OR
      g_aba.aba04 IS NULL OR g_abb[l_ac].abb03 IS NULL OR
      g_abb2.abb05 IS NULL OR g_abb2.abb08 IS NULL OR
      g_abb2.abb35 IS NULL OR g_abb2.abb36 IS NULL THEN
      RETURN
   END IF
         
   CALL s_get_bookno(g_aba.aba03) RETURNING l_flag1,l_bookno1,l_bookno2
   IF l_flag1 = '1' THEN
      CALL cl_err(g_aba.aba03,'aoo-081',0)
      LET g_errno = 'aoo-081'
      RETURN
   END IF
 
   IF g_aba.aba00 = l_bookno1 THEN
      LET p_flag = '0'
   ELSE
      LET p_flag = '1'
   END IF

   IF g_abb[l_ac].abb07c > 0 THEN
      LET l_abb06 = '2'
      LET l_abb07 = g_abb[l_ac].abb07c
      LET t_abb07 = g_abb_t.abb07c
   ELSE
      LET l_abb06 = '1'
      LET l_abb07 = g_abb[l_ac].abb07d
      LET t_abb07 = g_abb_t.abb07d
   END IF
 
   CALL s_getbug1(g_aba.aba00,g_abb2.abb36,g_abb[l_ac].abb03,
                  g_aba.aba03,g_abb2.abb35,g_abb2.abb05,
                  g_abb2.abb08,g_aba.aba04,p_flag)
        RETURNING l_flag,l_afb07,l_amt
   
   IF l_flag = TRUE THEN
      LET l_msg = g_bookno,'/',g_abb2.abb36,'/',g_abb[l_ac].abb03,'/',
                  g_aba.aba03,'/',g_abb2.abb35,'/',g_abb2.abb05,'/',
                  g_abb2.abb08,'/',g_aba.aba04,'/',p_flag,'/',l_amt
      CALL cl_err(l_msg,g_errno,1)
      RETURN
   ELSE
      IF l_afb07 = '2' AND l_amt < 0 THEN
         LET l_msg = g_bookno,'/',g_abb2.abb36,'/',g_abb[l_ac].abb03,'/',
                     g_aba.aba03,'/',g_abb2.abb35,'/',g_abb2.abb05,'/',
                     g_abb2.abb08,'/',g_aba.aba04,'/',p_flag,'/',l_amt
         LET g_errno =' '
      END IF
   END IF     
   
   LET g_afb07 = l_afb07                        #set_no_entry使用
   #-->不做超限控制
   IF l_afb07  != '1' THEN
      SELECT SUM(abb07) INTO l_tol 
        FROM abb_file,aba_file
       WHERE abb00 = aba00 
         AND aba01 = abb01
         AND aba00 = g_aba.aba00
         AND aba03 = g_aba.aba03
         AND aba04 = g_aba.aba04
         AND abb03 = g_abb[l_ac].abb03
         AND abb08 = g_abb2.abb08
         AND abb35 = g_abb2.abb35
         AND abb36 = g_abb2.abb36
         AND abb05 = g_abb2.abb05
         AND abb06 = '1'                     #借方
         AND aba19 <> 'X' #CHI-C80041
      IF SQLCA.sqlcode OR l_tol IS NULL THEN
         LET l_tol = 0
      END IF
 
      SELECT SUM(abb07) INTO l_tol1 FROM abb_file,aba_file
       WHERE abb00 = aba00 
         AND aba01 = abb01
         AND aba00 = g_aba.aba00
         AND aba03 = g_aba.aba03
         AND aba04 = g_aba.aba04
         AND abb03 = g_abb[l_ac].abb03
         AND abb08 = g_abb2.abb08
         AND abb35 = g_abb2.abb35
         AND abb36 = g_abb2.abb36
         AND abb05 = g_abb2.abb05
         AND abb06 = '2'                     #貸方
         AND aba19 <> 'X' #CHI-C80041
      IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
         LET l_tol1 = 0
      END IF
 
      LET l_fac = 1   #No.TQC-840044
      IF m_aag06 = '1' THEN                     #借餘
         LET total_t = l_tol - l_tol1           #借減貸
         IF l_abb06 = '2' THEN
            LET l_fac = -1
         END IF
      ELSE                                      #貸餘
         LET total_t = l_tol1 - l_tol           #貸減借
         IF l_abb06 = '1' THEN
            LET l_fac = -1
         END IF
      END IF
      
   IF g_action_choice != 'confirm' THEN  #CHI-920071
      IF p_cmd = 'a' THEN                       #若本筆資料為新增則加上本次輸入的值
         LET total_t = total_t + l_abb07 * l_fac  #No.TQC-840044
      ELSE                                      #若為更改則減掉舊值再加上新值
         LET total_t = total_t - t_abb07 * l_fac + l_abb07 * l_fac  #No.TQC-840044
      END IF
   END IF    #CHI-920071
      
      IF total_t > l_amt THEN                   #借餘大於預算金額
         CASE l_afb07
            WHEN '2'
               CALL cl_getmsg('agl-140',0) RETURNING l_buf
               CALL cl_getmsg('agl-141',0) RETURNING l_buf1
               LET g_sql = l_buf CLIPPED,' ',total_t,
                           l_buf1 CLIPPED,' ',l_amt
               LET g_errno = ''
               CALL cl_err(g_sql,'agl-233',1)
            WHEN '3'
               CALL cl_getmsg('agl-142',0) RETURNING l_buf
               CALL cl_getmsg('agl-143',0) RETURNING l_buf1
               LET g_sql = l_buf CLIPPED,' ',total_t,
                           l_buf1 CLIPPED,' ',l_amt
               LET g_errno = 'agl-233'
               CALL cl_err(g_sql,'agl-233',1)
         END CASE
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_cashier_conf()
  DEFINE l_n  LIKE type_file.num5
 
   SELECT aba08,aba09 INTO g_aba.aba08,g_aba.aba09 FROM aba_file
     WHERE aba01=g_aba.aba01 AND aba00=g_aba.aba00
   IF g_aba.aba08 <> g_aba.aba09 THEN
      CALL cl_err('','agl-060',1)
      RETURN
   END IF
  IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041
  IF g_aba.aba35 = "Y" OR g_aba.aba19 = "Y" OR
     g_aba.abapost = "Y" OR g_aba.abaacti = "N" OR
     (g_aba.abamksg = "Y" AND g_aba.aba20 != "1") OR 
      g_aba.aba02 <= g_aaa.aaa07 THEN   #MOD-740164
 
     IF g_aba.aba35 = "Y" THEN
        CALL cl_err('','aba-101',0)
     END IF
     IF g_aba.aba19 = "Y" THEN
        CALL cl_err('','9023',0)
     END IF
     IF g_aba.abapost = "Y" THEN
        CALL cl_err('','mfg0175',1)
     END IF
     IF g_aba.abaacti = "N" THEN
        CALL cl_err('','mfg0301',1)
     END IF
     IF g_aba.abamksg = 'Y' AND g_aba.aba20 != '1' THEN
        CALL cl_err('','aws-078',1)
     END IF
     IF g_aba.aba02 <= g_aaa.aaa07 THEN
         CALL cl_err('','agl-085',0)
     END IF
  ELSE
     IF NOT cl_null(g_aba.aba01) AND NOT s_shut(0) THEN
        SELECT count(*) INTO l_n FROM aag_file
         WHERE aag19 = '1' AND aag01 IN (SELECT abb03 FROM abb_file
                                       WHERE abb01 = g_aba.aba01
                                         AND abb00 = g_bookno)   #No.MOD-7A0131
           AND aag00 = g_bookno   #No.FUN-740020
        IF l_n>0 THEN
           IF cl_sure(21,21) THEN
                 LET g_aba.aba35 = "Y"
                 LET g_aba.aba36 = g_user
                 LET g_aba.aba20 = '1'
                 DISPLAY BY NAME g_aba.aba35
                 DISPLAY BY NAME g_aba.aba36
                 DISPLAY BY NAME g_aba.aba20
                 UPDATE aba_file SET aba35 = g_aba.aba35,
                                     aba36 = g_aba.aba36,
                                     aba20 = g_aba.aba20
                  WHERE aba01 = g_aba.aba01
                    AND aba00 = g_aba.aba00  #No.MOD-6B0086
                 CALL cl_set_field_pic(g_aba.aba19,'Y',"","","",g_aba.abaacti)
           END IF
        END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION t110_un_cashier_conf()
  IF g_aba.aba19 = 'X' THEN RETURN END IF  #CHI-C80041
  IF g_aba.aba19 = "Y" OR 
     g_aba.aba02 <= g_aaa.aaa07 THEN
     IF g_aba.aba19 = 'Y' THEN
        CALL cl_err('','aba-103',0)
     END IF
     IF g_aba.aba02 <= g_aaa.aaa07 THEN
         CALL cl_err('','agl-085',0)
     END IF
  ELSE
     IF NOT cl_null(g_aba.aba01) AND NOT s_shut(0) THEN
        IF g_aba.aba35 = "N" THEN
           CALL cl_err('','aba-102',0)
        ELSE
           IF cl_sure(21,21) THEN
                 LET g_aba.aba35 = "N"
                 LET g_aba.aba36 = NULL
                 UPDATE aba_file SET aba35 = g_aba.aba35,
                                     aba36 = g_aba.aba36
                  WHERE aba01 = g_aba.aba01
                    AND aba00 = g_aba.aba00  #No.MOD-6B0086
                 DISPLAY BY NAME g_aba.aba35,g_aba.aba36
                 LET g_aba.aba20 = '0'
                 UPDATE aba_file SET aba20 = g_aba.aba20
                   WHERE aba01=g_aba.aba01
                     AND aba00=g_aba.aba00
                 IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","aba_file",g_aba.aba01,g_aba.aba00,STATUS,"","",1)  
                    RETURN
                 END IF
                 DISPLAY BY NAME g_aba.aba20
                 CALL cl_set_field_pic(g_aba.aba19,"","","","",g_aba.abaacti)
           END IF
        END IF
     END IF
  END IF
END FUNCTION
 
 
FUNCTION t110_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1)
 
   CALL cl_set_comp_entry("abb02,abb03,abb24,abb25,abb07d,abb07df,abb07c,abb07cf",TRUE)
 
   IF INFIELD(abb24) OR NOT g_before_input_done THEN
      CALL cl_set_comp_entry("abb25,abb07d,abb07c",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680098 VARCHAR(1)
   DEFINE l_aac13 LIKE aac_file.aac13
  
   IF g_aba.aba06 <> 'GL' AND g_aba.aba06 <> 'AC' AND g_aba.aba06 <> 'AD' THEN   #TQC-670044
      CALL cl_set_comp_entry("abb02,abb03,abb24,abb25,abb07df,abb07d,abb07cf,abb07c",FALSE)
   END IF
   IF INFIELD(abb03) OR NOT g_before_input_done THEN
      CASE g_aac.aac03
          WHEN '1' CALL cl_set_comp_entry("abb07d,abb07df",FALSE)
          WHEN '2' CALL cl_set_comp_entry("abb07c,abb07cf",FALSE)
      END CASE
 
   END IF
 
   IF INFIELD(abb24) OR NOT g_before_input_done THEN
      IF g_abb[l_ac].abb24 = g_aza.aza17 THEN
         LET g_t1 = s_get_doc_no(g_aba.aba01)
         SELECT aac13 INTO l_aac13 FROM aac_file WHERE aac01 = g_t1
         IF cl_null(l_aac13) THEN LET l_aac13 = 'N' END IF
         IF l_aac13 = 'Y' THEN
            CALL cl_set_comp_entry("abb25,abb07d,abb07c",FALSE)
         END IF
         LET g_abb[l_ac].abb25 = 1
      END IF
   END IF
  
   IF INFIELD(abb07d) OR INFIELD(abb07df) OR NOT g_before_input_done THEN
      IF g_abb[l_ac].abb07d <> 0 OR g_abb[l_ac].abb07df <> 0 THEN
         CALL cl_set_comp_entry("abb07c,abb07cf",FALSE)
      END IF
   END IF

   IF INFIELD(abb07c) OR INFIELD(abb07cf) OR NOT g_before_input_done THEN
      IF g_abb[l_ac].abb07c <> 0 OR g_abb[l_ac].abb07cf <> 0 THEN
         CALL cl_set_comp_entry("abb07d,abb07df",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION t110_set_required(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1   #No.FUN-680098 VARCHAR(01)
 
   IF INFIELD(abb07d) OR INFIELD(abb07c) OR NOT g_before_input_done THEN
      IF g_abb[l_ac].abb24=g_aza.aza17 THEN
         IF g_abb[l_ac].abb07d!=g_abb[l_ac].abb07df THEN
            CALL cl_err('','agl-926',1)
            CALL cl_set_comp_required("abb07d",TRUE)
         END IF
         IF g_abb[l_ac].abb07c!=g_abb[l_ac].abb07cf THEN
            CALL cl_err('','agl-926',1)
            CALL cl_set_comp_required("abb07c",TRUE)
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_required(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680098 VARCHAR(01)
 
END FUNCTION
 
FUNCTION  t110_show_field()
#依參數決定異動碼的多寡
 
  DEFINE l_field     STRING
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "abb12,abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "abb33,abb34,abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "abb34,abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "abb35,abb36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "abb36"
# END IF
#FUN-B50105   ---end     Mark
#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field  = "abb11,abb12,abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field  = "abb12,abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 2 THEN
     LET l_field  = "abb12,abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field  = "abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 4 THEN
     LET l_field  = "abb14"
  END IF
  IF NOT cl_null(l_field) THEN LET l_field = l_field,"," END IF
  IF g_aaz.aaz125 = 5 THEN
     LET l_field = l_field,"abb32,abb33,abb34,abb45,abb36"
  END IF
  IF g_aaz.aaz125 = 6 THEN
     LET l_field = l_field,"abb33,abb34,abb45,abb36"
  END IF
  IF g_aaz.aaz125 = 7 THEN
     LET l_field = l_field,"abb34,abb45,abb36"
  END IF
  IF g_aaz.aaz125 = 8 THEN
     LET l_field = l_field,"abb45,abb36"
  END IF
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
  CALL cl_set_comp_visible("abb08,abb35", g_aza.aza08 = 'Y')  #No.FUN-830139  #No.FUN-830161
  CALL cl_set_comp_visible("abb36", TRUE)  #No.FUN-830161
END FUNCTION
 
FUNCTION t110_aba24(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_aba.aba24
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'   #TQC-7C0152
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
 
#該函數作用是，對單身異動碼進行正確性判斷！--此函數目前僅在審核確認時被調用。
FUNCTION t110_chk()
DEFINE   l_success      LIKE type_file.chr1     #VARCHAR(1)   #MOD-850201 mod
DEFINE   l_i            INTEGER
DEFINE   l_sql          STRING
DEFINE   l_abb11        LIKE abb_file.abb11     #異動碼1
DEFINE   l_abb12        LIKE abb_file.abb12     #異動碼2
DEFINE   l_abb13        LIKE abb_file.abb13     #異動碼3
DEFINE   l_abb14        LIKE abb_file.abb14     #異動碼4
DEFINE   l_abb31        LIKE abb_file.abb31     #異動碼5
DEFINE   l_abb32        LIKE abb_file.abb32     #異動碼6
DEFINE   l_abb33        LIKE abb_file.abb33     #異動碼7
DEFINE   l_abb34        LIKE abb_file.abb34     #異動碼8
DEFINE   l_abb35        LIKE abb_file.abb35     #異動碼9
DEFINE   l_abb36        LIKE abb_file.abb36     #異動碼10
DEFINE   l_abb37        LIKE abb_file.abb37     #異動碼
DEFINE   l_abb03        LIKE abb_file.abb03
DEFINE   l_aag151       LIKE aag_file.aag151
DEFINE   l_aag161       LIKE aag_file.aag161
DEFINE   l_aag171       LIKE aag_file.aag171
DEFINE   l_aag181       LIKE aag_file.aag181
DEFINE   l_aag311       LIKE aag_file.aag311
DEFINE   l_aag321       LIKE aag_file.aag321
DEFINE   l_aag331       LIKE aag_file.aag331
DEFINE   l_aag341       LIKE aag_file.aag341
DEFINE   l_aag351       LIKE aag_file.aag351
DEFINE   l_aag361       LIKE aag_file.aag361
DEFINE   l_aag371       LIKE aag_file.aag371
DEFINE   l_abb02        LIKE abb_file.abb02
DEFINE   l_msg          LIKE type_file.chr50   #VARCHAR(50)   #MOD-850201 mod
 
 
    LET l_i = 1
    LET l_success = 'Y'
 
    LET l_sql =
        " SELECT abb11,abb12,abb13,abb14,",  
        "        abb31,abb32,abb33,abb34,abb35,abb36,abb37,abb03, ",
        "        abb02 ",
        "   FROM abb_file ",
        "  WHERE abb01 ='",g_aba.aba01,"' AND abb00 = '",g_aba.aba00,"' ",  
        "    AND abb02 != 0 ",
        " ORDER BY abb02 "
    PREPARE t110_chk_b FROM l_sql
    DECLARE t110_chk_cs CURSOR FOR t110_chk_b
    
    FOREACH t110_chk_cs INTO l_abb11,l_abb12,l_abb13,l_abb14,l_abb31,l_abb32,
                             l_abb33,l_abb34,l_abb35,l_abb36,l_abb37,l_abb03,
                             l_abb02
       
       SELECT aag151,aag161,aag171,aag181,aag311,
              aag321,aag331,aag341,aag351,aag361,aag371
         INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag311,
              l_aag321,l_aag331,l_aag341,l_aag351,l_aag361,
              l_aag371
         FROM aag_file
        WHERE aag01 = l_abb03
          AND aag00 = g_aba.aba00
       
       LET l_msg = l_abb02 CLIPPED,' ',l_abb03 CLIPPED,' '
 
        #異動碼1
       IF NOT cl_null(l_abb11) THEN 
           CALL s_chk_aee(l_abb03,'1',l_abb11,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb11,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag151='2' OR l_aag151='3') AND cl_null(l_abb11) THEN
           CALL s_errmsg('','',l_msg,'agl-432',1)
           LET l_success = 'N'
        END IF 
        #異動碼2
        IF NOT cl_null(l_abb12) THEN
           CALL s_chk_aee(l_abb03,'2',l_abb12,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb12,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag161='2' OR l_aag161='3') AND cl_null(l_abb12) THEN
           CALL s_errmsg('','',l_msg,'agl-433',1)
           LET l_success = 'N'
        END IF 
        #異動碼3
        IF NOT cl_null(l_abb13) THEN
           CALL s_chk_aee(l_abb03,'3',l_abb13,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb13,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag171='2' OR l_aag171='3') AND cl_null(l_abb13) THEN
           CALL s_errmsg('','',l_msg,'agl-434',1)
           LET l_success = 'N'
        END IF 
        #異動碼4
        IF NOT cl_null(l_abb14) THEN
           CALL s_chk_aee(l_abb03,'4',l_abb14,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb14,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag181='2' OR l_aag181='3') AND cl_null(l_abb14) THEN
           CALL s_errmsg('','',l_msg,'agl-435',1)
           LET l_success = 'N'
        END IF 
        #異動碼5
        IF NOT cl_null(l_abb31) THEN
           CALL s_chk_aee(l_abb03,'5',l_abb31,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb31,g_errno,1)
              LET l_success = 'N'
              EXIT FOREACH
           END IF
        END IF
        IF (l_aag311='2' OR l_aag311='3') AND cl_null(l_abb31) THEN
           CALL s_errmsg('','',l_msg,'agl-436',1)
           LET l_success = 'N'
        END IF 
        #異動碼6
        IF NOT cl_null(l_abb32) THEN
           CALL s_chk_aee(l_abb03,'6',l_abb32,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb32,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag321='2' OR l_aag321='3') AND cl_null(l_abb32) THEN
           CALL s_errmsg('','',l_msg,'agl-437',1)
           LET l_success = 'N'
        END IF 
        #異動碼7
        IF NOT cl_null(l_abb33) THEN
           CALL s_chk_aee(l_abb03,'7',l_abb33,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb33,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag331='2' OR l_aag331='3') AND cl_null(l_abb33) THEN
           CALL s_errmsg('','',l_msg,'agl-438',1)
           LET l_success = 'N'
        END IF 
        #異動碼8
        IF NOT cl_null(l_abb34) THEN
           CALL s_chk_aee(l_abb03,'8',l_abb34,g_bookno)  
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb34,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag341='2' OR l_aag341='3') AND cl_null(l_abb34) THEN
           CALL s_errmsg('','',l_msg,'agl-439',1)
           LET l_success = 'N'
        END IF 
        #異動碼11
        IF NOT cl_null(l_abb37) THEN
           CALL s_chk_aee(l_abb03,'99',l_abb37,g_bookno)    #No.FUN-740020
           IF NOT cl_null(g_errno) THEN
              CALL s_errmsg('','',l_abb37,g_errno,1)
              LET l_success = 'N'
           END IF
        END IF
        IF (l_aag371='2' OR l_aag371='3') AND cl_null(l_abb37) THEN
           CALL s_errmsg('','',l_msg,'agl-442',1)
           LET l_success = 'N'
        END IF 
 
    END FOREACH
 
    RETURN l_success
    
END FUNCTION
 
FUNCTION t110_agl_missingno_show(p_plant)
DEFINE      p_plant             LIKE tmn_file.tmn01         # ` b犁 Bゆノ s腹
DEFINE      l_cnt               LIKE type_file.num5         
DEFINE      i,l_j,l_k,l_ac,m    LIKE type_file.num5        
DEFINE      l_flag              LIKE type_file.chr1  
DEFINE      l_apa01             LIKE apa_file.apa01      
          #---------------------- N  腹showˊ e   W-------------------------#
 
          OPEN WINDOW s_agl_missingno_w AT 11,27  WITH FORM "sub/42f/s_agl_missingno"
               ATTRIBUTE (STYLE = g_win_style CLIPPED)
               
          CALL cl_set_comp_visible("tc_tmp00",FALSE)
 
          CALL cl_ui_locale("s_agl_missingno")
 
          LET g_sql = "SELECT tc_tmp00,tc_tmp01,tc_tmp03,tc_tmp02  FROM agl_tmp_file ORDER BY tc_tmp02,tc_tmp03"  #No.FUN-670068
          PREPARE s_missingno_p   FROM  g_sql
          DECLARE s_missingno_cs  CURSOR     FOR   s_missingno_p
 
          LET l_cnt = 1
          CALL g_tmp.clear()
          FOREACH  s_missingno_cs  INTO g_tmp[l_cnt].*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET l_cnt = l_cnt + 1
              IF l_cnt > g_max_rec THEN
                 CALL cl_err( '', 9035, 0 )
                 EXIT FOREACH
              END IF
          END FOREACH
 
          DISPLAY l_cnt TO FORMONLY.cn
 
          DISPLAY ARRAY g_tmp TO s_tmp.*  ATTRIBUTE(COUNT=l_cnt,UNBUFFERED)
 
             BEFORE ROW
 
             ON ACTION accept
                LET i = ARR_CURR()
                LET l_apa01 = g_tmp[i].tc_tmp02
                UPDATE agl_tmp_file
                   SET tc_tmp00='Y'
                 WHERE tc_tmp02=g_tmp[i].tc_tmp02
                   AND tc_tmp03=g_tmp[i].tc_tmp03 
                   
                EXIT DISPLAY 
             ON ACTION cancel 
                LET l_apa01 = ''
                EXIT DISPLAY 
          END DISPLAY
 
         CLOSE WINDOW s_agl_missingno_w
         RETURN l_apa01
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

FUNCTION t110_body_init(p_aac13)
    DEFINE p_aac13     LIKE aac_file.aac13
    CALL cl_set_comp_visible('abb24,abb25,abb07df,abb07cf',TRUE)
    IF p_aac13 = 'N' THEN
       CALL cl_set_comp_visible('abb24,abb25,abb07df,abb07cf',FALSE)
    END IF

END FUNCTION

FUNCTION t110_init_body_more()
    INITIALIZE g_abb2.* TO NULL

END FUNCTION

FUNCTION t110_b1(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1
  DEFINE l_flag    LIKE type_file.chr1
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE l_bz      LIKE type_file.chr1
  DEFINE p_col     LIKE type_file.num5
  DEFINE p_row     LIKE type_file.num5
  DEFINE l_cmd     STRING
 
    IF s_shut(0) THEN RETURN END IF
    LET l_bz = 'Y' 
    LET l_flag = 'Y'
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t110_b1_w AT p_row,p_col WITH FORM "ggl/42f/gglt110_b1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("gglt110_b1")
 
    LET l_ac1 = 1
    LET g_abb1[l_ac1].* = g_abb2.*
    LET g_abb1_t.* = g_abb1[l_ac1].*

    IF g_aba.aba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_aba.* FROM aba_file WHERE aba00=g_aba.aba00
                                          AND aba01=g_aba.aba01
    IF g_aba.abaacti ='N' THEN LET l_flag = 'N' END IF
    IF g_aba.abapost ='Y' THEN LET l_flag = 'N' END IF
    IF g_aba.aba19 = 'Y'  THEN LET l_flag = 'N' END IF
    IF g_aba.aba19 = 'X' THEN LET l_flag = 'N' END IF  #CHI-C80041
    IF g_aba.aba20 matches '[Ss]' THEN LET l_flag = 'N' END IF
 
    #-->非應計(來源碼)輸入則不可刪除
    IF g_argv2 = '3' THEN
       IF g_aba.aba06 != 'AC'  THEN LET l_flag = 'N' END IF
    END IF
 
    SELECT UNIQUE amd01 FROM amd_file
     WHERE amd01 = g_aba.aba01 AND amd26 IS NOT NULL # 表已申報
    IF STATUS = 0 THEN LET l_flag = 'N' END IF

    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_abb1 TO s_abb1.* ATTRIBUTE(COUNT=1,UNBUFFERED)
 
    BEFORE DISPLAY
       IF l_flag = 'Y' THEN
          EXIT DISPLAY
       END IF
 
       ON ACTION help
          LET g_action_choice="help"
          EXIT DISPLAY
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION controlg
          LET g_action_choice="controlg"
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
 
       ON ACTION exporttoexcel   #No.FUN-4B0010
          LET g_action_choice = 'exporttoexcel'
          EXIT DISPLAY
 
       AFTER DISPLAY
          CONTINUE DISPLAY
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
 
       &include "qry_string.4gl"
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    LET g_before_input_done=FALSE
    CALL t110_set_entry_b1(p_cmd)
    CALL t110_set_no_entry_b1(p_cmd)
    CALL t110_set_no_required1(p_cmd)
    CALL t110_set_required1(p_cmd)
    LET g_before_input_done=TRUE

    INPUT ARRAY g_abb1 WITHOUT DEFAULTS FROM s_abb1.*
          ATTRIBUTE(COUNT=1,MAXCOUNT=1,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)
        BEFORE FIELD abb05
            IF m_aag05 = 'N' THEN
               LET g_abb1[l_ac1].abb05 = ' '
               DISPLAY BY NAME g_abb1[l_ac1].abb05
            END IF

        AFTER FIELD abb05      #部門
            #科目為需有部門資料者才需建立此欄位
            IF NOT cl_null(g_abb1[l_ac1].abb05) THEN
               IF m_aag05='Y' THEN
                   CALL t110_abb05('u')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_abb1[l_ac1].abb05,g_errno,1)
                      LET g_abb1[l_ac1].abb05=g_abb1_t.abb05
                      DISPLAY BY NAME g_abb1[l_ac1].abb05
                      NEXT FIELD abb05
                   END IF
               END IF
            END IF
            CALL t110_bud(p_cmd,'0')
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD abb05
            END IF
            #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
            LET g_errno = ' '
            IF m_aag05 = 'Y' AND NOT cl_null(g_abb1[l_ac1].abb05) THEN
              #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  CALL s_chkdept(g_aaz.aaz72,g_abb[l_ac].abb03,g_abb1[l_ac1].abb05,g_bookno)
                                RETURNING g_errno
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD abb03
               END IF
            END IF

        AFTER FIELD abb08
            IF NOT cl_null(g_abb1[l_ac1].abb08) THEN
               CALL t110_abb08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_abb1[l_ac1].abb08 = g_abb1_t.abb08
                  DISPLAY BY NAME g_abb1[l_ac1].abb08
                  NEXT FIELD abb08
               END IF
            END IF
            CALL t110_bud(p_cmd,'0')
            IF NOT cl_null(g_errno) THEN
               NEXT FIELD abb08
            END IF  
 
        BEFORE FIELD abb11  #異動碼一
           IF cl_null(m_aag151) THEN
              LET g_abb1[l_ac1].abb11 = ' '
              DISPLAY BY NAME g_abb1[l_ac1].abb11
           END IF
           CALL t110_error(m_aag15)
 
        AFTER FIELD abb11
           IF NOT cl_null(g_abb1[l_ac1].abb11) THEN
              CALL s_chk_aee(g_abb[l_ac].abb03,'1',g_abb1[l_ac1].abb11,g_bookno)  #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD abb11
              END IF
           ELSE
              #異動碼-1控制方式
              IF m_aag151='2' OR m_aag151='3' THEN
                 CALL cl_err('','mfg0037',0)
                 NEXT FIELD abb11
              END IF
           END IF
           CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb12  #異動碼二
           IF cl_null(m_aag161) THEN
              LET g_abb1[l_ac1].abb12 = ' '
              DISPLAY BY NAME g_abb1[l_ac1].abb12
           END IF
           CALL t110_error(m_aag16)
 
        AFTER FIELD abb12
           IF NOT cl_null(g_abb1[l_ac1].abb12) THEN
              CALL s_chk_aee(g_abb[l_ac].abb03,'2',g_abb1[l_ac1].abb12,g_bookno)  #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD abb12
              END IF
           ELSE
              #異動碼-2控制方式
              IF m_aag161='2' OR m_aag161='3' THEN
                 CALL cl_err('','mfg0037',0)
                 NEXT FIELD abb12
              END IF
           END IF
           CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb13  #  abb12-abb13-abb14
           IF cl_null(m_aag171) THEN
              LET g_abb1[l_ac1].abb13 = ' '
              DISPLAY BY NAME g_abb1[l_ac1].abb13
           END IF
           CALL t110_error(m_aag17)
 
        AFTER FIELD abb13
           IF NOT cl_null(g_abb1[l_ac1].abb13) THEN
              CALL s_chk_aee(g_abb[l_ac].abb03,'3',g_abb1[l_ac1].abb13,g_bookno)  #No.FUN-740020
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD abb13
              END IF
           ELSE
              #異動碼-3控制方式
              IF m_aag171='2' OR m_aag171='3' THEN
                 CALL cl_err('','mfg0037',0)
                 NEXT FIELD abb13
              END IF
           END IF
           CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb14
           IF cl_null(m_aag181) THEN
              LET g_abb1[l_ac1].abb14 = ' '
              DISPLAY BY NAME g_abb1[l_ac1].abb14
           END IF
           CALL t110_error(m_aag18)
 
        AFTER FIELD abb14
            IF NOT cl_null(g_abb1[l_ac1].abb14) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'4',g_abb1[l_ac1].abb14,g_bookno)   #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb14
               END IF
            ELSE
               #異動碼-4控制方式
               IF m_aag181='2' OR m_aag181='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb14
               END IF
            END IF
            CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb31
           IF cl_null(m_aag311) THEN
              LET g_abb1[l_ac1].abb31 = ' '
           END IF
           CALL t110_error(m_aag31)
 
        AFTER FIELD abb31
            IF NOT cl_null(g_abb1[l_ac1].abb31) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'5',g_abb1[l_ac1].abb31,g_bookno)  #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb31
               END IF
            ELSE
               #異動碼-5控制方式
               IF m_aag311='2' OR m_aag311='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb31
               END IF
            END IF
            CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb32
           IF cl_null(m_aag321) THEN
              LET g_abb1[l_ac1].abb32 = ' '
           END IF
           CALL t110_error(m_aag32)
 
        AFTER FIELD abb32
            IF NOT cl_null(g_abb1[l_ac1].abb32) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'6',g_abb1[l_ac1].abb32,g_bookno)  #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb32
               END IF
            ELSE
               #異動碼-6控制方式
               IF m_aag321='2' OR m_aag321='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb32
               END IF
            END IF
            CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb33
           IF cl_null(m_aag331) THEN
              LET g_abb1[l_ac1].abb33 = ' '
           END IF
           CALL t110_error(m_aag33)
 
        AFTER FIELD abb33
            IF NOT cl_null(g_abb1[l_ac1].abb33) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'7',g_abb1[l_ac1].abb33,g_bookno)  #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb33
               END IF
            ELSE
               #異動碼-7控制方式
               IF m_aag331='2' OR m_aag331='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb33
               END IF
            END IF
            CALL t110_set_required1(p_cmd)
 
        BEFORE FIELD abb34
           IF cl_null(m_aag341) THEN
              LET g_abb1[l_ac1].abb34 = ' '
           END IF
           CALL t110_error(m_aag34)
 
        AFTER FIELD abb34
            IF NOT cl_null(g_abb1[l_ac1].abb34) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'8',g_abb1[l_ac1].abb34,g_bookno)  #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb34
               END IF
            ELSE
               #異動碼-8控制方式
               IF m_aag341='2' OR m_aag341='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb34
               END IF
            END IF
            CALL t110_set_required1(p_cmd)
 
        AFTER FIELD abb35
          IF g_abb1[l_ac1].abb35 IS NOT NULL THEN
             CALL t110_abb35(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_abb1[l_ac1].abb35 = g_abb1_t.abb35
                DISPLAY BY NAME g_abb1[l_ac1].abb35
                NEXT FIELD abb35
             END IF
             DISPLAY BY NAME g_abb1[l_ac1].abb35
          END IF
          CALL t110_bud(p_cmd,'0')
          IF NOT cl_null(g_errno) THEN
             NEXT FIELD abb35
          END IF  
 
         
        AFTER FIELD abb36
          IF g_abb1[l_ac1].abb36 IS NOT NULL THEN
             CALL t110_abb36(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_abb1[l_ac1].abb36 = g_abb1_t.abb36
                DISPLAY BY NAME g_abb1[l_ac1].abb36
                NEXT FIELD abb36
             END IF
             DISPLAY BY NAME g_abb1[l_ac1].abb35
          END IF
          CALL t110_bud(p_cmd,'0')
          IF NOT cl_null(g_errno) THEN
             NEXT FIELD abb36
          END IF  
 
        BEFORE FIELD abb37
           IF cl_null(m_aag371) THEN
              LET g_abb1[l_ac1].abb37 = ' '
           END IF
           CALL t110_error(m_aag37)
 
        AFTER FIELD abb37
            IF NOT cl_null(g_abb1[l_ac1].abb37) THEN
               CALL s_chk_aee(g_abb[l_ac].abb03,'99',g_abb1[l_ac1].abb37,g_bookno)  #No.FUN-740020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD abb37
               END IF
            ELSE
               #關係人異動碼控制方式
               IF m_aag371='2' OR m_aag371='3' THEN
                  CALL cl_err('','mfg0037',0)
                  NEXT FIELD abb37
               END IF
            END IF
            CALL t110_set_required1(p_cmd)

        AFTER ROW
            #本科目是否作部門明細管理 (Y/N)
            IF m_aag05='Y' AND g_abb1[l_ac1].abb05 IS NULL THEN
               NEXT FIELD abb05
            END IF
 
            #是否作線上預算控制(Y/N)
            IF m_aag21 = 'Y' AND g_abb1[l_ac1].abb36 IS NULL THEN
               NEXT FIELD abb36
            END IF
 
            #是否作專案管理(Y/N)
            IF m_aag23 = 'Y' AND g_abb1[l_ac1].abb08 IS NULL THEN
               NEXT FIELD abb08
            END IF
            IF m_aag23 = 'Y' AND g_abb1[l_ac1].abb35 IS NULL THEN
               NEXT FIELD abb35
            END IF
 
            #異動碼-1控制方式
            IF (m_aag151='2' OR m_aag151='3') AND g_abb1[l_ac1].abb11 IS NULL THEN    #No.MOD-490325
               NEXT FIELD abb11
            END IF
 
            #異動碼-2控制方式
            IF (m_aag161='2' OR m_aag161='3') AND g_abb1[l_ac1].abb12 IS NULL THEN    #No.MOD-490325
               NEXT FIELD abb12
            END IF
 
            #異動碼-3控制方式
            IF (m_aag171='2' OR m_aag171='3') AND g_abb1[l_ac1].abb13 IS NULL THEN    #No.MOD-490325
               NEXT FIELD abb13
            END IF
 
            #異動碼-4控制方式
            IF (m_aag181='2' OR m_aag181='3') AND g_abb1[l_ac1].abb14 IS NULL THEN    #No.MOD-490325
               NEXT FIELD abb14
            END IF
 
            #異動碼-5控制方式
            IF (m_aag311='2' OR m_aag311='3') AND g_abb1[l_ac1].abb31 IS NULL THEN
               NEXT FIELD abb31
            END IF
            #異動碼-6控制方式
            IF (m_aag321='2' OR m_aag321='3') AND g_abb1[l_ac1].abb32 IS NULL THEN
               NEXT FIELD abb32
            END IF
            #異動碼-7控制方式
            IF (m_aag331='2' OR m_aag331='3') AND g_abb1[l_ac1].abb33 IS NULL THEN
               NEXT FIELD abb33
            END IF
            #異動碼-8控制方式
            IF (m_aag341='2' OR m_aag341='3') AND g_abb1[l_ac1].abb34 IS NULL THEN
               NEXT FIELD abb34
            END IF
            #關係人異動碼控制方式
            IF (m_aag371='2' OR m_aag371='3') AND g_abb1[l_ac1].abb37 IS NULL THEN
               NEXT FIELD abb37
            END IF
 
        AFTER FIELD abbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD abbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        ON ACTION maintain_acct_tran_code_value
            CASE
                WHEN INFIELD(abb11)
                      LET l_cmd = "agli109 '' '1'  '",g_abb[l_ac].abb03,"'"  #MOD-4C0171
                      CALL cl_cmdrun(l_cmd)
                 WHEN INFIELD(abb12) CALL cl_cmdrun("agli109  '' '2' ")   #MOD-4C0171
                 WHEN INFIELD(abb13) CALL cl_cmdrun("agli109  '' '3' ")   #MOD-4C0171
                 WHEN INFIELD(abb14) CALL cl_cmdrun("agli109  '' '4' ")   #MOD-4C0171
 
                 WHEN INFIELD(abb31) CALL cl_cmdrun("agli109  '' '5' ")
                 WHEN INFIELD(abb32) CALL cl_cmdrun("agli109  '' '6' ")
                 WHEN INFIELD(abb33) CALL cl_cmdrun("agli109  '' '7' ")
                 WHEN INFIELD(abb34) CALL cl_cmdrun("agli109  '' '8' ")
                 WHEN INFIELD(abb37) CALL cl_cmdrun("agli109  '' '99' ")
 
                 OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION controlp
           CASE
                WHEN INFIELD(abb05)     #查詢部門
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem1"       #No.MOD-440244
                   LET g_qryparam.default1 = g_abb1[l_ac1].abb05
                   CALL cl_create_qry() RETURNING g_abb1[l_ac1].abb05
                   DISPLAY BY NAME g_abb1[l_ac1].abb05       #No.MOD-490344
                   NEXT FIELD abb05
                WHEN INFIELD(abb08)    #查詢專案編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pja"    #FUN-810045 #No.MOD-8C0166 modify by liuxqa 
                   LET g_qryparam.default1 = g_abb1[l_ac1].abb08
                   CALL cl_create_qry() RETURNING g_abb1[l_ac1].abb08
                   DISPLAY BY NAME g_abb1[l_ac1].abb08       #No.MOD-490344
                   NEXT FIELD abb08
                WHEN INFIELD(abb11)    #查詢異動碼-1
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'1','i',g_abb1[l_ac1].abb11,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb11
                   DISPLAY g_abb1[l_ac1].abb11 TO abb11
                   NEXT FIELD abb11
                WHEN INFIELD(abb12)    #查詢異動碼-2
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'2','i',g_abb1[l_ac1].abb12,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb12
                   DISPLAY g_abb1[l_ac1].abb12 TO abb12
                   NEXT FIELD abb12
                WHEN INFIELD(abb13)    #查詢異動碼-3
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'3','i',g_abb1[l_ac1].abb13,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb13
                   DISPLAY g_abb1[l_ac1].abb13 TO abb13
                   NEXT FIELD abb13
                WHEN INFIELD(abb14)    #查詢異動碼-4
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'4','i',g_abb1[l_ac1].abb14,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb14
                   DISPLAY g_abb1[l_ac1].abb14 TO abb14
                   NEXT FIELD abb14
                WHEN INFIELD(abb31)    #查詢異動碼-5
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'5','i',g_abb1[l_ac1].abb31,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb31
                   DISPLAY g_abb1[l_ac1].abb31 TO abb31
                   NEXT FIELD abb31
                WHEN INFIELD(abb32)    #查詢異動碼-6
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'6','i',g_abb1[l_ac1].abb32,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb32
                   DISPLAY g_abb1[l_ac1].abb32 TO abb32
                   NEXT FIELD abb32
                WHEN INFIELD(abb33)    #查詢異動碼-7
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'7','i',g_abb1[l_ac1].abb33,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb33
                   DISPLAY g_abb1[l_ac1].abb33 TO abb33
                   NEXT FIELD abb33
                WHEN INFIELD(abb34)    #查詢異動碼-8
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'8','i',g_abb1[l_ac1].abb34,g_bookno)     #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb34
                   DISPLAY g_abb1[l_ac1].abb34 TO abb34
                   NEXT FIELD abb34
                WHEN INFIELD(abb35)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pjb4"   #MOD-940051 mod #q_pjb9->q_pjb4
                   LET g_qryparam.arg1 = g_abb1[l_ac1].abb08   #MOD-940051 add
                   LET g_qryparam.default1 = g_abb1[l_ac1].abb35
                   CALL cl_create_qry() RETURNING g_abb1[l_ac1].abb35
                   DISPLAY g_abb1[l_ac1].abb35 TO abb35
                   NEXT FIELD abb35
                WHEN INFIELD(abb36)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"                   #No.FUN-930106
                   LET g_qryparam.arg1 ='7'                          #No.FUN-950077   
                   LET g_qryparam.default1 = g_abb1[l_ac1].abb36
                   CALL cl_create_qry() RETURNING g_abb1[l_ac1].abb36
                   DISPLAY g_abb1[l_ac1].abb36 TO abb36
                   NEXT FIELD abb36
                WHEN INFIELD(abb37)    #查詢關係人異動碼
                   CALL s_ahe_qry(g_abb[l_ac].abb03,'99','i',g_abb1[l_ac1].abb37,g_bookno)    #No.FUN-740020
                        RETURNING g_abb1[l_ac1].abb37
                   DISPLAY g_abb1[l_ac1].abb37 TO abb37
                   NEXT FIELD abb37
            END CASE

        ON ACTION rejected_accepted_dept_setting
            CASE
                WHEN INFIELD(abb05) CALL cl_cmdrun('agli104' CLIPPED)
                OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        AFTER INPUT
           IF INT_FLAG THEN                         # 若按了DEL鍵
              LET INT_FLAG = 0
              LET l_bz = 'N' 
              EXIT INPUT
           END IF
           LET l_flag = 'N'

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
    IF m_aag05 = 'N' OR cl_null(m_aag05) THEN
       LET g_abb1[l_ac1].abb05 = ' '              #No.FUN-830139 add  by hellen
    END IF
    IF m_aag23 = 'N' OR cl_null(m_aag23) THEN
       LET g_abb1[l_ac1].abb08 = ' '              #No.FUN-830139 add  by hellen
       LET g_abb1[l_ac1].abb35 = ' '              #No.FUN-830139 add  by hellen
    END IF

    LET g_abb2.* = g_abb1[l_ac1].*

    IF p_cmd='u' AND l_bz = 'Y' THEN 
       UPDATE abb_file SET 
                           abb05 = g_abb2.abb05,
                           abb08 = g_abb2.abb08,
                           abb11 = g_abb2.abb11,
                           abb12 = g_abb2.abb12,
                           abb13 = g_abb2.abb13,
                           abb14 = g_abb2.abb14,
                           abb31 = g_abb2.abb31,
                           abb32 = g_abb2.abb32,
                           abb33 = g_abb2.abb33,
                           abb34 = g_abb2.abb34,
                           abb35 = g_abb2.abb35,
                           abb36 = g_abb2.abb36,
                           abb37 = g_abb2.abb37,
                           abbud01 = g_abb2.abbud01,
                           abbud02 = g_abb2.abbud02,
                           abbud03 = g_abb2.abbud03,
                           abbud04 = g_abb2.abbud04,
                           abbud05 = g_abb2.abbud05,
                           abbud06 = g_abb2.abbud06,
                           abbud07 = g_abb2.abbud07,
                           abbud08 = g_abb2.abbud08,
                           abbud09 = g_abb2.abbud09,
                           abbud10 = g_abb2.abbud10,
                           abbud11 = g_abb2.abbud11,
                           abbud12 = g_abb2.abbud12,
                           abbud13 = g_abb2.abbud13,
                           abbud14 = g_abb2.abbud14,
                           abbud15 = g_abb2.abbud15
        WHERE abb00 = g_aba.aba00
          AND abb01 = g_aba.aba01
          AND abb02 = g_abb[l_ac].abb02
    END IF
    CLOSE WINDOW t110_b1_w                 #結束畫面
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

END FUNCTION

FUNCTION t110_set_entry_b1(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1)
 
   CALL cl_set_comp_entry("abb05,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36,abb37",TRUE)
   CALL cl_set_comp_visible("abb05,gem02,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb36,abb37",TRUE)
   CALL cl_set_comp_visible("abb08,abb35", g_aza.aza08 = 'Y') 
END FUNCTION
 
FUNCTION t110_set_no_entry_b1(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680098 VARCHAR(1)
 
   CALL cl_set_comp_visible("abb08,abb35", g_aza.aza08 = 'Y')        #No.FUN-830139  #No.FUN-830161
   IF g_aba.aba06 <> 'GL' AND g_aba.aba06 <> 'AC' AND g_aba.aba06 <> 'AD' THEN   #TQC-670044
      CALL cl_set_comp_entry("abb05,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36,abb37",FALSE) 
      CALL cl_set_comp_visible("abb05,gem02,abb08,abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,abb35,abb36,abb37",FALSE) 
   END IF
   IF NOT g_before_input_done THEN
      #本科目是否作部門明細管理 (Y/N)
      IF m_aag05='N' OR cl_null(m_aag05) THEN
         CALL cl_set_comp_entry("abb05",FALSE)
         CALL cl_set_comp_visible("abb05",FALSE)
         CALL cl_set_comp_visible("gem02",FALSE)
      END IF

      #是否作專案管理(Y/N)
      IF m_aag23 = 'N' OR cl_null(m_aag23) THEN
         CALL cl_set_comp_entry("abb08",FALSE)
         CALL cl_set_comp_entry("abb35",FALSE)  #No.TQC-840044
         CALL cl_set_comp_visible("abb08,abb35",FALSE)
      END IF
 
      #是否作預算管理(Y/N)
      IF m_aag21 = 'N' OR cl_null(m_aag21) THEN
         CALL cl_set_comp_entry("abb36",FALSE)
         CALL cl_set_comp_visible("abb36",FALSE)
      END IF
 
      #異動碼-1控制方式
      IF cl_null(m_aag151) THEN
         CALL cl_set_comp_entry("abb11",FALSE)
         CALL cl_set_comp_visible("abb11",FALSE)
      END IF
 
      #異動碼-2控制方式
      IF cl_null(m_aag161) THEN
         CALL cl_set_comp_entry("abb12",FALSE)
         CALL cl_set_comp_visible("abb12",FALSE)
      END IF
 
      #異動碼-3控制方式
      IF cl_null(m_aag171) THEN
         CALL cl_set_comp_entry("abb13",FALSE)
         CALL cl_set_comp_visible("abb13",FALSE)
      END IF
 
      #異動碼-4控制方式
      IF cl_null(m_aag181) THEN
         CALL cl_set_comp_entry("abb14",FALSE)
         CALL cl_set_comp_visible("abb14",FALSE)
      END IF
 
      #異動碼-5控制方式
      IF cl_null(m_aag311) THEN
         CALL cl_set_comp_entry("abb31",FALSE)
         CALL cl_set_comp_visible("abb31",FALSE)
      END IF
 
      #異動碼-6控制方式
      IF cl_null(m_aag321) THEN
         CALL cl_set_comp_entry("abb32",FALSE)
         CALL cl_set_comp_visible("abb32",FALSE)
      END IF
 
      #異動碼-7控制方式
      IF cl_null(m_aag331) THEN
         CALL cl_set_comp_entry("abb33",FALSE)
         CALL cl_set_comp_visible("abb33",FALSE)
      END IF
 
      #異動碼-8控制方式
      IF cl_null(m_aag341) THEN
         CALL cl_set_comp_entry("abb34",FALSE)
         CALL cl_set_comp_visible("abb34",FALSE)
      END IF
 
      #關係人異動碼控制方式
      IF cl_null(m_aag371) THEN
         CALL cl_set_comp_entry("abb37",FALSE)
         CALL cl_set_comp_visible("abb37",FALSE)
      END IF
 
   END IF
 
   IF g_argv2="3" OR g_argv2="7" OR g_argv2="4" THEN  #MOD-5A0427
      #異動碼-1控制方式
      IF cl_null(m_aag151) THEN
         CALL cl_set_comp_entry("abb11",FALSE)
         CALL cl_set_comp_visible("abb11",FALSE)
      END IF
 
      #異動碼-2控制方式
      IF cl_null(m_aag161) THEN
         CALL cl_set_comp_entry("abb12",FALSE)
         CALL cl_set_comp_visible("abb12",FALSE)
      END IF
 
      #異動碼-3控制方式
      IF cl_null(m_aag171) THEN
         CALL cl_set_comp_entry("abb13",FALSE)
         CALL cl_set_comp_visible("abb13",FALSE)
      END IF
 
      #異動碼-4控制方式
      IF cl_null(m_aag181) THEN
         CALL cl_set_comp_entry("abb14",FALSE)
         CALL cl_set_comp_visible("abb14",FALSE)
      END IF
 
      #異動碼-5控制方式
      IF cl_null(m_aag311) THEN
         CALL cl_set_comp_entry("abb31",FALSE)
         CALL cl_set_comp_visible("abb31",FALSE)
      END IF
      #異動碼-6控制方式
      IF cl_null(m_aag321) THEN
         CALL cl_set_comp_entry("abb32",FALSE)
         CALL cl_set_comp_visible("abb32",FALSE)
      END IF
      #異動碼-7控制方式
      IF cl_null(m_aag331) THEN
         CALL cl_set_comp_entry("abb33",FALSE)
         CALL cl_set_comp_visible("abb33",FALSE)
      END IF
      #異動碼-8控制方式
      IF cl_null(m_aag341) THEN
         CALL cl_set_comp_entry("abb34",FALSE)
         CALL cl_set_comp_visible("abb34",FALSE)
      END IF
      #關係人異動碼控制方式
      IF cl_null(m_aag371) THEN
         CALL cl_set_comp_entry("abb37",FALSE)
         CALL cl_set_comp_visible("abb37",FALSE)
      END IF
 
   END IF
 

END FUNCTION
 
FUNCTION t110_set_required1(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1   #No.FUN-680098 VARCHAR(01)
 
   IF NOT g_before_input_done THEN
      #本科目是否作部門明細管理 (Y/N)
      IF m_aag05='Y' THEN
         CALL cl_set_comp_required("abb05",TRUE)
      END IF
 
      #是否作線上預算控制(Y/N)
      IF m_aag21 = 'Y' THEN
         CALL cl_set_comp_required("abb36",TRUE)
      END IF
 
      #是否作專案管理(Y/N)
      IF m_aag23 = 'Y' THEN
         CALL cl_set_comp_required("abb08,abb35",TRUE)  #No.TQC-840044
      END IF
 
     #異動碼-1控制方式
       IF m_aag151='2' OR m_aag151='3' THEN    #No.MOD-490325
         CALL cl_set_comp_required("abb11",TRUE)
      END IF
 
      #異動碼-2控制方式
       IF m_aag161='2' OR m_aag161='3' THEN    #No.MOD-490325
         CALL cl_set_comp_required("abb12",TRUE)
      END IF
 
      #異動碼-3控制方式
       IF m_aag171='2' OR m_aag171='3' THEN    #No.MOD-490325
         CALL cl_set_comp_required("abb13",TRUE)
      END IF
 
      #異動碼-4控制方式
       IF m_aag181='2' OR m_aag181='3' THEN    #No.MOD-490325
         CALL cl_set_comp_required("abb14",TRUE)
      END IF
 
      #異動碼-5控制方式
      IF m_aag311='2' OR m_aag311='3' THEN
         CALL cl_set_comp_required("abb31",TRUE)
      END IF
      #異動碼-6控制方式
       IF m_aag321='2' OR m_aag321='3' THEN
         CALL cl_set_comp_required("abb32",TRUE)
      END IF
      #異動碼-7控制方式
       IF m_aag331='2' OR m_aag331='3' THEN
         CALL cl_set_comp_required("abb33",TRUE)
      END IF
      #異動碼-8控制方式
       IF m_aag341='2' OR m_aag341='3' THEN
         CALL cl_set_comp_required("abb34",TRUE)
      END IF
      #關係人異動碼控制方式
       IF m_aag371='2' OR m_aag371='3' THEN
         CALL cl_set_comp_required("abb37",TRUE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_required1(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680098 VARCHAR(01)
 
   CALL cl_set_comp_required("abb05,abb08,abb11,abb12,abb13,abb14",FALSE)   
 
   CALL cl_set_comp_required("abb31,abb32,abb33,abb34,abb35,abb36,abb37",FALSE)
 
END FUNCTION

FUNCTION t110_trans()
   DEFINE l_str     LIKE type_file.chr10
   DEFINE l_i       LIKE type_file.num5

   CALL cl_set_comp_visible("att1,att2,att3,att4,att5,att6",FALSE)
   CALL cl_set_comp_visible("att7,att8,att9,att10,att11,att12",FALSE)

   LET l_i = 0
   #是否作部門明細管理 (Y/N)
   IF NOT cl_null(g_abb2.abb05) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-225',g_abb2.abb05) 
   END IF

   #是否作專案管理(Y/N)
   IF NOT cl_null(g_abb2.abb08) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-110',g_abb2.abb08) 
   END IF
   IF NOT cl_null(g_abb2.abb35) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-119',g_abb2.abb35) 
   END IF
 
   #是否作預算管理(Y/N)
   IF NOT cl_null(g_abb2.abb36) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-120',g_abb2.abb36) 
   END IF
 
   #異動碼-1控制方式
   IF NOT cl_null(g_abb2.abb11) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-111',g_abb2.abb11) 
   END IF
 
   #異動碼-2控制方式
   IF NOT cl_null(g_abb2.abb12) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-112',g_abb2.abb12) 
   END IF
 
   #異動碼-3控制方式
   IF NOT cl_null(g_abb2.abb13) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-113',g_abb2.abb13) 
   END IF
 
   #異動碼-4控制方式
   IF NOT cl_null(g_abb2.abb14) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-114',g_abb2.abb14) 
   END IF
 
   #異動碼-5控制方式
   IF NOT cl_null(g_abb2.abb31) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-115',g_abb2.abb31) 
   END IF
   #異動碼-6控制方式
   IF NOT cl_null(g_abb2.abb32) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-116',g_abb2.abb32) 
   END IF
   #異動碼-7控制方式
   IF NOT cl_null(g_abb2.abb33) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-117',g_abb2.abb33) 
   END IF
   #異動碼-8控制方式
   IF NOT cl_null(g_abb2.abb34) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-118',g_abb2.abb34) 
   END IF
   #關係人異動碼控制方式
   IF NOT cl_null(g_abb2.abb37) THEN
      LET l_i = l_i + 1
      CALL t110_trans_show(l_i,'ggl-121',g_abb2.abb37) 
   END IF

END FUNCTION

FUNCTION t110_trans_show(p_i,p_ze,p_data)
   DEFINE p_i       LIKE type_file.num5
   DEFINE p_ze      LIKE ze_file.ze01
   DEFINE p_data    LIKE abb_file.abb11
   DEFINE l_str     LIKE type_file.chr10
   DEFINE l_desc    STRING

      LET l_str = "att",p_i USING "<<"
      CALL cl_getmsg(p_ze,g_lang) RETURNING l_desc
      CALL cl_set_comp_att_text(l_str,l_desc CLIPPED)
      CALL cl_set_comp_visible(l_str,TRUE)
      CASE p_i
           WHEN 1   DISPLAY p_data TO FORMONLY.att1
           WHEN 2   DISPLAY p_data TO FORMONLY.att2
           WHEN 3   DISPLAY p_data TO FORMONLY.att3
           WHEN 4   DISPLAY p_data TO FORMONLY.att4
           WHEN 5   DISPLAY p_data TO FORMONLY.att5
           WHEN 6   DISPLAY p_data TO FORMONLY.att6
           WHEN 7   DISPLAY p_data TO FORMONLY.att7
           WHEN 8   DISPLAY p_data TO FORMONLY.att8
           WHEN 9   DISPLAY p_data TO FORMONLY.att9
           WHEN 10  DISPLAY p_data TO FORMONLY.att10
           WHEN 11  DISPLAY p_data TO FORMONLY.att11
           WHEN 12  DISPLAY p_data TO FORMONLY.att12
      END CASE

END FUNCTION
#CHI-AC0010
#CHI-C80041---begin
FUNCTION t110_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_aba.aba01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t110_cl USING g_aba.aba00,g_aba.aba01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_aba.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_aba.aba19 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_aba.aba19)   THEN 
        LET l_chr=g_aba.aba19
        IF g_aba.aba19='N' THEN 
            LET g_aba.aba19='X' 
        ELSE
            LET g_aba.aba19='N'
        END IF
        UPDATE aba_file
            SET aba19=g_aba.aba19,  
                abamodu=g_user,
                abadate=g_today
            WHERE aba00=g_aba.aba00
              AND aba01=g_aba.aba01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","aba_file",g_aba.aba01,"",SQLCA.sqlcode,"","",1)  
            LET g_aba.aba19=l_chr 
        END IF
        DISPLAY BY NAME g_aba.aba19
   END IF
 
   CLOSE t110_cl
   COMMIT WORK
   CALL cl_flow_notify(g_aba.aba01,'V')
 
END FUNCTION
#CHI-C80041---end
