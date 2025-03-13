# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name.... saapt310.4gl
# Descriptions.... 付款沖帳
# Date & Author... 92/12/16 By Roger
#                  輸入付款單沖應付帳款時,須考慮請款單
#                  輸入後,取雜項全名(apl02)前8碼至廠商簡稱
#                  1.判斷幣別azi04有誤
#                  2.溢付單據產生時user,group等欄位未寫入
# Modify.......... 97/04/16 Danny 1.將apc_file改成npp_file,npq_file
#                                 2.將 s_gl 改成 call s_fsgl
#                  97/05/08 Danny 1.判斷付款日期不可小於關帳日期
#                                 2.確認,取消確認時立帳日期不可小於關帳日期
# Modify.......... 98/11/02 Connie 增加多工廠請款沖帳處理
# Modify.......... 98/11/13 Sophia 單身類別增加A.手續費(借方)B.轉帳(貸方)
# Modify.......... 03/08/19 No.7852 Kitty 第二單身的匯率未預設
# Modify.......... 03/08/21 No.7875 Kammy 呼叫自動取單號時應在 Transction中
# Modify.......... 03/11/03 No.8619 Kitty 3258行aph03不用加上0
# Modify.......... 04/07/27 No.9765 ching t310_v產生分錄p_cmd='2'不需 BEGIN WORK
# Modify.......... 04/10/14 MOD-4A0219 ching PROMPT (Y/N) 改用 cl_confirm
# Modify.......... 04/11/23 FUN-4B0054 ching add 匯率開窗 call s_rate
# Modify.......... 04/11/23 MOD-4B0226 alex 修正 set_combo 用法
# Modify.......... 04/11/30 FUN-4B0079 ching 單價,金額改成 DEC(20,6)
# Modify.......... 04/12/08 FUN-4C0047 Nicola 權限控管修改
# Modify.......... 05/01/12 FUN-510010 Kitty 增加當aph03 matches '[6789]' 則aph13不可輸入修改
# Modify.......... 05/01/13 MOD-510094 Kitty 付款單身不在序號欄位時移到下筆序號沒有預設
# Modify.......... 05/01/17 MOD-510077 Kitty 若廠商為MISC則游標點到其他欄位開窗會先開到廠商的窗
# Modify.......... 05/01/17 FUN-510011 Kitty 增加當aph03 matches '[12]' 則aph13不可輸入修改由銀行代號(aph08)帶出
# Modify.......... 05/03/15 FUN-530015 Nicola 匯率自由格式設定
# Modify.......... 05/03/30 MOD-530383 Nicola 類別修改後，要做單號正確性檢查
# Modify.......... 05/04/07 MOD-540041 Nicola 存放位置controlp LET g_qryparam.form = "q_azf" , 無法代出資料
# Modify.......... 05/04/21 FUN-540047 Nicola TIPTOP串EasyFlow
# Modify         . 05/05/05 MOD-4A0299 Echo   將確認與簽核流程拆開獨立。
# Modify.......... No.FUN-550030 05/05/12 By jackie 單據編號加大
# Modify.......... 05/06/02 MOD-560007 Echo   重新定義整合FUN名稱
# Modify.......... No.FUN-560060 05/06/18 By wujie  單據編號加大
# Modify.......... NO.FUN-560095 05/06/18 By ching  2.0功能修改
# Modify.......... No.FUN-580150 05/08/27 By Dido 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.......... No.MOD-580041 05/09/23 By Smapmin aph05f 都沒有依 aph13 做幣別取位
#                                                           原因沒有判斷傳票產生否,造成程式無法處理
#                                                           帳款單身查詢=>無法再回來作業(按確定無效)
# Modify.......... No.MOD-590054 05/10/20 By Smapmin 將銀行異動碼放入ARRAY中.
#                                                    確認功能做部份調整.
#                                                    l_amt3 LIKE apa_file.apa73.
#                                                    應顯示帳款發生時的匯率而非重評價後的匯率.
# Modify.......... No.MOD-5A0400 05/11/02 By Smapmin 取消確認有問題
# Modify.......... No.MOD-590440 05/11/03 By ice 若依月底重評價對AP未付金額調整,未付金額apa73取代apa34-apa35
# Modify.......... No.TQC-5B0114 05/11/12 By Nicola 1.單身類別為6.7.8.9時,匯率要 set noentry.
#                                                   2. 1    時,銀行異動碼要可以不輸入.
#                                                   3. 1.2.3時,銀行要可以輸入.
#                                                   4. 1.2  時,銀行開窗要過濾只能是1.2.
#                                                   5. 2    時,銀行異動碼要可以輸入,且一定要有值.
#                                                   6. 2    時,insert into nme_file時，支票號碼要是null.
# Modify.......... No.FUN-5B0081 05/11/28 By wujie   退貨立暫估相關修改
# Modify.......... No.TQC-5B0021 05/12/19 By Smapmin 科目與銀行代號輸入順序對調.類別1.2.時,會科從銀行基本資料帶出
# Modify.......... No.MOD-5C0115 05/12/23 By Smapmin 修正SQL語法
# Modify.......... No.TQC-5C0108 05/12/28 By Smapmin 檢查單身到期日是否為例假日
# Modify.......... No.MOD-620030 06/02/15 By Smapmin 轉帳時,LET nme17=""
# Modify.......... No.MOD-620055 06/02/21 By Smapmin 付款類別為C.電匯款時,開窗有誤
# Modify.......... No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.......... No.MOD-630011 06/03/03 By Smapmin 查詢時,付款單號開窗有誤
# Modify.......... No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.......... No.TQC-630136 06/03/16 By Smapmin 將apz38,apz39拿掉
# Modify.......... No.TQC-630158 06/03/21 By Smapmin 修正TQC-5B0021的錯誤
# Modify.......... NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.......... No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.......... No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# MOdify.......... No.MOD-640216 06/04/10 By Smapmin 確認時判斷,若付款為T.T的方式,則現金異動碼不可為NULL
# Modify.......... No.MOD-640555 06/04/28 By Smapmin 付款日=到期日且apz52<>'1',會科抓 nma05
# Modify.......... No.FUN-640240 06/05/16 By Echo 自動執行確認功能
# Modify.......... No.FUN-640170 06/05/23 By rainy 一般轉帳帳戶可輸入定存戶資料
# Modify.......... No.MOD-650097 06/05/25 By Smapmin 帳款單身金額相關訊息提示
# Modify.......... No.FUN-660122 06/06/20 By Hellen cl_err --> cl_err3
# Modify.......... No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.......... No.FUN-660192 06/07/04 By Smapmin 付款類別多A,B,C,Z四個選項
# Modify.......... No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.......... No.MOD-670014 06/07/05 By Smampin 修改開窗重查功能
# Modify.......... No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.......... No.FUN-670060 06/07/31 By Ray 新增"直接拋轉總帳"功能
# Modify.......... No.FUN-680029 06/08/17 By Ray 多帳套修改
# Modify.......... No.FUN-680027 06/08/28 By cl  多帳期修改
# Modify.......... No.TQC-690026 06/09/11 By Tracy 預付時,科目與帳款欄位要進行廠商檢查
# Modify.......... No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.......... No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.......... No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti
# Modify.......... No.FUN-690080 06/10/12 By Jackho 零用金功能修改
# Modify.......... No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.......... No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.......... No.MOD-6B0016 06/11/03 By cl     若apg03為空，則對apg03賦值為當前數據庫 
# Modify.......... No.FUN-690090 06/11/03 By cl 新增欄位apf992
# Modify.......... No.TQC-6A0042 06/11/07 By Smapmin 修改q_m_apa查詢程式傳入的參數
# Modify.......... No.MOD-6A0059 06/11/07 By Smapmin 確認時,帳款資料與付款資料不可為空
# Modify.......... No.FUN-690090 06/11/15 By Rayven aapt331不顯示apf992
# Modify.......... No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.......... No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能
# Modify.......... No.FUN-690090 06/11/20 By cl    當apf992(集團代付單號)不為空才可取消審核
# Modify.......... No.MOD-6B0141 06/11/24 By Ray 將l_t1放寬至char(5)
# Modify.......... No.MOD-6B0170 06/12/04 By Smapmin  nme02指定貸方到期日;若無再指定為付款日
# Modify.......... No.TQC-6B0066 06/12/07 By chenl   若帳款的子帳期僅為1筆，即apc_file僅此一筆時，子帳期項次自動賦1，并帶出后面欄位的值。
# Modify.......... No.MOD-690026 06/12/19 By Smapmin 增加"轉帳"時,銀行帳戶類別為1.2.3皆可開窗查詢
# Modify.......... No.MOD-6C0125 06/12/22 By Smapmin 簽核已核准的單據無法確認
# Modify.......... No.TQC-6C0044 06/12/22 By Smapmin 修改回寫待抵已付金額
# Modify.......... No.TQC-720009 07/02/02 By Smapmin 修改執行確認條件
# Modify.......... No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.......... No.FUN-730032 07/03/22 By wujie   網銀功能相關修改，nme新增欄位
# Modify.......... No.MOD-730106 07/04/03 By Smapmin 需產生溢付單據卻沒有溢付單號就不可確認
# Modify.......... No.FUN-730064 07/04/03 By Lynn    會計科目加帳套
# Modify.......... No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.......... No.TQC-740095 07/04/11 By Rayven insert nme表有錯誤
# Modify.......... No.TQC-740142 07/04/19 By Rayven 在審核時，付款單身共有多筆資料但只有一筆是“2.轉帳”的，卻寫了多筆相同的資料進nme_file中
# Modify.......... No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.......... No.MOD-740380 07/04/23 By Ray 請款人員應該從cpf_file中抓
# Modify.......... No.TQC-740281 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# Modify.......... No.MOD-740413 07/04/26 By chenl  帳款單身只能出現同一帳號的一個子帳期，帳號子帳期不能重復。
# Modify.......... No.MOD-740498 07/05/09 By cheunl 付款部份.類別為2.轉帳時應可輸入存款種類為"3.其他"之帳戶資料,一般零用金帳戶會設為3.其他
# Modify.......... No.MOD-740413 07/05/09 By chenl  單身帳款部分，若原幣金額已為剩余金額，則本幣金額也抓取剩余金額，而不再使用原幣*匯率來計算。
# Modify.......... No.FUN-740007 07/05/21 By wujie   網銀相關修改
# Modify.......... No.TQC-750139 07/05/24 By rainy aapt330(付款單) 溢付 產生(待抵溢付) 單頭 apa31,apa31f (未稅) 亦應寫入值 
#                                                  aapt331(零用金付款)應限制不可使用 ""3.轉溢付款""
# Modify.......... No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.......... No.MOD-760053 07/06/14 By Smapmin 修正t310_bu()整個交易邏輯
# Modify.......... No.MOD-770089 07/07/18 By Smapmin 調整寫入銀行存款異動檔的現金變動碼
# Modify.......... No.TQC-780034 07/08/08 By Rayven 在自行錄入的時候，輸入完帳款編號后帶出的匯率不是重評價后的匯率和本幣余額（已經作過重評價）
# Modify.......... No.MOD-780148 07/08/20 By Smapmin 修改幣別取位問題
# Modify.......... No.TQC-780065 07/08/22 By Smapmin 帳款原幣/本幣金額有誤
# Modify.......... No.MOD-770123 07/08/23 By Smapmin 修改付款單身異動碼輸入與否控管
# Modify.......... No.CHI-780046 07/09/10 By sherry  新增時，請款人員帶不到資料，把cpf_file換成gen_file                             
# Modify.......... No.MOD-790061 07/09/13 By Smapmin 依apz27判斷未沖金額抓取方式
# Modify.......... No.TQC-7A0072 07/10/19 By Judy 發生溢付時，收款單無法審核
# Modify.......... No.MOD-7B0096 07/11/09 By xufeng 衝賬日期應該和月底重評價年期轉換之后的日期進行比較
# Modify.......... No.MOD-7B0115 07/11/13 By xufeng 衝賬的時候不應該帶出暫估的帳款
# Modify.......... No.TQC-7B0051 07/11/13 By Smapmin 單別不產生分錄則不需執行傳票拋轉還原動作
# Modify.......... No.FUN-7B0055 07/11/14 By Carrier 取apc未付金額時,用s_g_np1
# Modify.......... No.MOD-7B0159 07/11/20 By Smapmin 拋轉傳票時,user要帶g_apf.apfuser
# Modify.......... No.MOD-7B0219 07/11/26 By Smapmin 修改付款部分預設金額
# Modify.......... No.TQC-7C0007 07/12/04 By Rayven 審核時溢付時從廠商抓取付款方式時增加若為空，報錯
# Modify.......... No.TQC-7C0050 07/12/06 By Smapmin 程式一開始就先預設主帳別/次帳別
# Modify.......... No.TQC-7C0140 07/12/11 By chenl   轉溢收時，增加對第二帳套貸方科目的抓取。
# Modify.......... No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.......... No.TQC-810082 08/01/30 By chenl   1.修改審核檢查，不再判斷帳款單身和付款單身筆數，而是判斷帳款金額+暫付金額=付款金額，且等式左右皆不可為零。
# Modify..........                                   2.根據幣種，取當前幣種賦給apf07
# Modify.......... No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.......... No.MOD-840063 08/04/08 By liuxqa 修改FUN-690080 sql語句錯誤，抓取內容應該是azp03而不是apz03
# Modify.......... No.MOD-840409 08/04/25 By Carrier 修改q_m_apa的傳入參數,帳款開窗時,過濾簡稱的條件
# Modify.......... No.FUN-850038 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.......... No.CHI-850001 08/05/13 By Smapmin 帳款單身開放可空白
# Modify.......... No.CHI-840056 08/05/21 By Smapmin 修改.確認時,回寫付款單身帳款的本幣已沖金額
# Modify.......... No.MOD-850173 08/05/23 By Sarah 針對TQC-5C0108所改部份,修正為僅限aph03='2'or'C'時才需要檢核假日問題
# Modify.......... No.MOD-850254 08/05/28 By Sarah 在AFTER FIELD aph03裡,IF g_aph_o.aph03 IS NULL OR g_aph_o.aph03 != g_aph[l_ac].aph03 THEN判斷式加上ELSE段,帶出上一筆的aph04,aph041
# Modify.......... No.MOD-860075 08/06/10 By Carrier 直接拋轉總帳時，aba07(來源單號)沒有取得值
# Modify.......... No.TQC-860021 08/06/10 By Sarah INPUT,PROMPT段漏了ON IDLE控制
# Modify.......... No.CHI-850023 08/07/04 By Sarah 把所有UPDATE段後面的判斷都改為IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN,而非IF STATUS THEN
# Modify.......... No.MOD-860277 08/07/04 By Sarah 進入付款單身"到期日"欄位點取,無論資料是否修改,選擇確定,再次進入"到期日",程式立即關閉
# Modify.......... No.MOD-870048 08/07/08 By Sarah 刪除資料前都需先COUNT有沒有資料,有的話才做刪除的動作
# Modify.......... No.MOD-870108 08/07/11 By Sarah 修正之前MOD-850254增加的部份,需先判斷l_ac!=1才做Default的動作
# Modify.......... NO.MOD-870152 08/07/16 BY yiting 暫估產生apa00 = '24'時，匯率= apf09/apf09f取azi07
# Modify.......... No.MOD-870154 08/07/22 By Sarah 在帳款有做直接付款,確認回寫已付金額應加上帳款裡的直接付款金額
# Modify.......... No.FUN-860107 08/07/24 By sherry 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.......... No.MOD-870279 08/08/04 By Sarah AFTER FIELD aph13,aph14段,以azi07對aph14取位
# Modify.......... No.MOD-880017 08/08/05 By Sarah 還原MOD-6B0170所改,l_nme.nme02還是帶入m_apf.apf02
# Modify.......... No.CHI-880003 08/08/06 By Sarah 將azr03改成azp01,抓azr_file的地方改抓azp_file
# Modify.......... No.MOD-870337 08/08/08 By Sarah 若原幣付款金額(aph05f)與帳款原幣金額相同時,本幣付款金額(aph05)直接抓取帳款本幣金額
# Modify.......... No.MOD-880079 08/08/10 By wujie 付款單身的原幣金額應該是用apf中的原幣金額計算后得出，不應該是本幣計算后換算
# Modify.......... No.MOD-880223 08/08/28 By Sarah 帳款單身不可輸入同一帳款編號+子帳期項次
# Modify.......... No.MOD-880203 08/08/29 By Sarah 當付款類別(aph03)是'6'待抵時,輸入的帳款不可是apa58='1'的資料
# Modify.......... NO.FUN-870037 08/10/03 BY yiting add apf45
# Modify.......... No.FUN-890128 08/10/06 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.......... No.MOD-8A0118 08/10/16 By Sarah 新增時,若付款類別為'4','5'時,原幣金額預設值為0
# Modify.......... No.MOD-8A0227 08/10/29 By Sarah 預付與待抵不可在同一張付款單處理,於AFTER FIELD apg04段增加檢核aph04是否為此預付待抵帳款,若是則顯示aap-753
# Modify.......... No.MOD-8B0006 08/11/05 By Sarah 將MOD-870154所加程式段拿掉,因為直接付款有寫入apg_file,在計算時已有抓到直接付款金額,不需再另外抓取
# Modify.......... No.FUN-8A0075 08/11/05 By jan S.送簽時，付款單可再執行以下ACTION：
#                                                [帳款單身查詢][產生分錄][分錄底稿維護][拋轉傳票][傳票拋轉還原][確認]
# Modify.......... No.MOD-8B0176 08/11/20 By Sarah 若付款原幣與帳款原幣不同時,最後一筆計算以帳款本幣金額扣去之前已付的本幣金額,避免尾差問題
# Modify.......... No.MOD-8B0228 08/11/21 By Sarah 當apz26='N'時,z6_curs CURSOR的SQL多串azp01=g_plant條件
# Modify.......... No.FUN-8C0106 08/12/22 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD 
# Modify.......... No.MOD-910184 09/01/17 By Sarah 當付款沖帳是沖8.預付時,回寫帳款的已付金額直接回寫付款單身輸入的本幣金額
# Modify.......... No.MOD-910030 09/01/19 By wujie 付款單號開窗應該只能開出apf00='33'的資料
# Modify.......... No.FUN-920104 09/01/16 By sabrina aapt331與EasyFlow整合，當apf42<>'1：已核准'時，不可以執行確認功能
# Modify.......... No.MOD-920251 09/02/23 By Sarah t310_b2()的AFTER FIELD aph05f段,增加判斷當l_sum_aph05f+g_aph[l_ac].aph05f>l_apc08需卡住不過
# Modify.......... No.MOD-920367 09/02/27 By Smapmin AFTER FIELD aph05f的控管,要考慮aph03是否為6789
# Modify.......... No.MOD-930115 09/03/11 By lilingyu 增加判斷當aph05f 為0或NULL時,才做重算動作
# Modify.......... No.FUN-920186 09/03/20 By lala  理由碼apf11必須為付款理由
# Modify.......... No.MOD-930243 09/03/30 By Sarah 修正CHI-840056,當原幣已沖平時,直接將本幣帶入不需重算
# Modify.......... No.MOD-940021 09/04/02 By chenl 若g_wc2為空，則賦值為"1=1".
# Modify.......... No.MOD-940247 09/04/17 By lilingyu 因為單號FUN-850038 加了自訂欄位,sql沒有加,導致欄位沒有對應到
# Modify.......... No.TQC-940123 09/04/21 By chenl 若不存在帳套資料，不應退出程序，而應該報錯，并卡住。
# Modify.......... No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.......... No.MOD-970282 09/07/31 By mike PREPARE s2_aph_pre2前的l_sql,跨營運中心應該用.,再用ora檔將.轉換成.                
# Modify.......... No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.......... No.MOD-970295 09/08/20 By mike 存檔前(AFTER INSERT、ON ROW CHANGE)增加檢核帳款金額(apg05,apg05f)是否超出帳款(aap-
# Modify.......... No.MOD-980182 09/08/21 By mike 在查詢時應該是要能一次查詢多筆的    
# Modify.......... No.FUN-910074 09/09/01 By hongmei SOP_AAP007修改，送簽中只開放指定功能鍵
# Modify.......... No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.......... No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.......... No.FUN-960140 09/09/08 By lutingting apg03改用于錄入機構編號,開放輸入,賬款編號根據機構編號過濾
# Modify.......... No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.......... No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.......... No.MOD-980010 09/08/03 By Sarah 分次沖折讓單,應該自動帶出剩餘的未沖銷金額
# Modify.......... No.MOD-980141 09/08/18 By Sarah 帳款單身自動沖帳功能在組SQL時,若單頭廠商簡稱(apf12)不為Null才加入條件中
# Modify.......... No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/apk32
# Modify.......... No.MOD-990189 09/10/18 By mike 當aph04/aph041不為Null時(已有舊值),不需重抓nma05/nma051                           
# Modify.......... No.MOD-990221 09/10/18 By mike FUNCTION t310_tmp_pay(),增加apa05的預設值                                         
# Midify.......... No.FUN-990031 09/10/27 By lutingting GP5.2財務營運中心調整,因為立帳會丟到dsall所以不需要去不同的營運中心抓取資料
# Modify.........: No:MOD-9A0087 09/10/29 By mike FUNCTION t310_bu()段,计算r_apc16f时,LET r_apc16f= r_apc16f+ cl_digcut(l_apc16*l_ap
# Modify.........: No.FUN-9A0093 09/11/04 By lutingting 審核不成功
# Modify.........: No.TQC-9B0119 09/11/24 By lutingting 1.g_apg變量中拿掉了apg03的內容,但是t310_g_b_c1 中還有select apg03的值,導致兩者不匹配,報錯!
#                                                       2.由于立帳會丟到dsall所以賬款自動生成時t310_g_b1()中不需要去抓營運中心,4fd中也拿掉
# Modify.........: No:MOD-9C0147 09/12/16 By Sarah 檢核aap-294前抓取aph_file的SQL,請加上apf41!='X'條件
# Modify.........: No.FUN-9C0072 09/12/22 By vealxu 精簡程式碼
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:CHI-A10034 10/01/29 By sabrina 單身的幣別資料不回寫單頭
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-970077 10/03/07 By chenmoyan add aph18,aph19
# Modify.........: No:FUN-A20010 10/03/10 By chenmoyan add aph20
# Modify.........: No.TQC-A30078 10/03/16 By Carrier q_apw传帐套
# Modify.........: No.MOD-A30146 10/03/23 By sabrina apa_file增加apa02 <= apf02條件
# Modify.........: No:FUN-A30106 10/03/29 By wujie   增加凭证联查功能
# Modify.........: No:FUN-A40003 10/04/13 By wujie   增加厂商退款功能
# Modify.........: No:FUN-A60024 10/06/08 By wujie   增加转销功能
#                                                    DIALOG改写
# Modify.........: No:CHI-A60034 10/07/12 By Summer FUNCTION t310_firm1_upd 的 BEGIN WORK 改用錯誤訊息彙總方式呈現
# Modify.........: No:MOD-A70102 10/07/14 By Dido 帳款開窗需過濾付款日後的資料 
# Modify.........: No:TQC-A70083 10/07/19 By xiaofeizhu 更新npp_file前檢查是否生成分錄
# Modify.........: No.FUN-A50102 10/07/22 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A80034 10/08/05 By Dido aph14 不可為負數 
# Modify.........: No.MOD-A80076 10/08/11 By Dido 科目預設值調整依據銀行異動時給予 
# Modify.........: No.MOD-A80175 10/08/25 by Dido 匯兌損益幣別應為本國幣別  
# Modify.........: No.FUN-A40037 10/08/27 By vealxu apf12欄位管控的調整
# Modify.........: No.FUN-A80111 10/08/30 By wujie  增加溢退功能
# Modify.........: No:MOD-A40156 10/08/31 By sabrina 當單身選擇的銀行的幣別和aza17相同時，要將匯率改為1 
# Modify.........: No.CHI-A80036 10/09/01 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No.MOD-A90078 10/09/13 By Dido 異動時暫付金額需重新計算更新 
# Modify.........: No.MOD-A90129 10/09/20 By Dido 如為轉帳需設定銀存異動碼 
# Modify.........: No.FUN-A90007 10/09/30 By wujie 增加调帐功能
# Modify.........: No:CHI-AA0003 10/11/05 By Summer 增加單身借貸方金額不平處理
#                                                   (1)修改帳款 (2)修改付款 (3)差異視為溢付款 (4)差異是為溢收帳款 (5)差異視為匯兌損益 (E)先暫時離開 
# Modify.........: No:MOD-AB0197 10/11/23 By Dido 批次確認付款總金額調整 
# Modify.........: No.TQC-AC0292 10/12/22 By chenmoyan 修改s4_aph_cur2
# Modify.........: No:MOD-AC0327 10/12/27 By Dido 批次確認執行時關閉QBE視窗 
# Modify.........: No:MOD-AC0383 10/12/29 By Dido 拋轉 aapp400 參數調整 
# Modify.........: No:TQC-AC0409 11/01/04 By lixh1 對'帳款資料'和'付款單身'二個功能鍵做權限控管
# Modify.........: No:MOD-B10041 11/01/06 By Dido aapp400 增加參數 gl_summary = 'Y' 
# Modify.........: No:TQC-B10075 11/01/11 By shenyang 管控‘差異處理’action
# Modify.........: No:TQC-B10092 11/01/12 By shenyang 管控‘差異處理’action
# Modify.........: No.TQC-B10069 11/01/18 By lixh1 做整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No:MOD-B10116 11/01/18 By Dido 付款與帳款匯差大且溢付時,暫付本幣金額計算調整 
# Modify.........: No:TQC-B10199 11/01/20 By Dido 取消 prompt 提示;取消取消確認段刪除溢付款動作 
# Modify.........: No:MOD-B10147 11/01/20 By Dido g_plant_new 變數有誤 
# Modify.........: No:CHI-B10042 11/02/09 By Summer 將upd()段判斷狀況碼要為1.已核准才可以確認的段落往上搬到chk()段 
# Modify.........: No:TQC-B20092 11/02/17 By elva apa00='32'/'36'时，不需check银存异动码
# Modify.........: No:TQC-B20112 11/02/21 By wujie 退款功能修正
# Modify.........: No:TQC-B20128 11/02/21 By Sarah 整批確認檢查有錯誤要離開確認段時,要先將aapt600_6視窗關閉
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: NO.FUN-B30211 11/03/30 By yangtingting 未加離開前得cl_used(2)
# Modify.........: NO.TQC-B30220 11/04/08 By yinhy 1.人工錄入時，第一單身錄入完后直接轉入第二單身
# Modify.........: NO.                             2.審核時檢查轉入廠商是否為空，如為空給出提示
# Modify.........: NO.TQC-B40038 11/04/08 By yinhy 查詢時，狀態PAGE中資料建立者，資料建立部門無法下查詢條件
# Modify.........: NO.FUN-B40011 11/04/11 By guoch 1.付款類型增加D.收票轉付
#                                                  2.類型為D.收票轉付時，判斷轉付金額不可>已沖金額
#                                                  3.審核時候更新nmh42的金額
# Modify.........: No:MOD-B50038 11/05/09 By Dido 取消確認若已轉出網銀匯款時,則不可取消確認 
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B50029 11/05/16 By yinhy 報錯【轉入入厂商不可為空，請輸入！】
# Modify.........: No:MOD-B50123 11/05/16 By Dido INSERT nme_file 語法調整 
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.TQC-B30175 11/06/10 By Dido 溢付與匯差異常調整 
# Modify.........: No:MOD-B60158 11/06/17 By Sarah 若單據別設定自動拋轉傳票,則取消確認時應該先傳票還原後再做取消確認
# Modify.........: No:MOD-B70011 11/07/04 By Dido 動態給予貸方類別調整 
# Modify.........: No:CHI-B60072 11/07/06 By JoHung 將aap-753控卡改為提示
# Modify.........: No:MOD-B70047 11/07/07 By Dido 未付金額應包含 apc14/apc15
# Modify.........: No:MOD-B70136 11/07/14 By lilingyu 付款沖賬作業,若溢付產生aapq240.若修改aapt330的日期,再刪除此筆資料,aapq240的資料沒有被一起刪除
# Modify.........: No:MOD-B70159 11/07/17 By Polly 調整整批確認時，若條件內有其他筆已確認，也可讓未確認的可以確認，增加 apf41 = 'N' 條件
# Modify.........: No:TQC-B70129 11/07/17 By Dido 暫付金額小於等於 0 則不須新增暫付資料 
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No:TQC-B70152 11/07/19 By guoch 將aph09欄位變為非編輯狀態
# Modify.........: No:TQC-B70147 11/07/19 By guoch 溢付为4的时候，aph04取值出现错误
# Modify.........: No:CHI-B70031 11/07/20 By Dido 差異視窗開啟判斷調整 
# Modify.........: No:TQC-B70160 11/07/21 By guoch aapt332类型选项进行调整
# Modify.........: No:TQC-B80069 11/08/04 By guoch aph041赋值上的bug修正
# Modify.........: No:TQC-B80079 11/08/08 By wujie 溢付和溢退抛转改在审核段做
# Modify.........: No:MOD-B80062 11/08/08 By johung 付款單身檢核幣別應用幣別筆數
# Modify.........: No:MOD-B80144 11/08/15 By lixia 增加nma21檢查
# Modify.........: No:MOD-B90084 11/09/09 By yinhy apc13已經在saapt110.4gl中減掉了apc15，此處不應該再減
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No:MOD-B90204 11/09/23 By yinhy 轉銷部分單身輸入完后金額与賬款部分的金額一致，但是系統會提示：借貸不合，請選擇差异處理方式
# Modify.........: No.TQC-B90205 11/09/27 By yinhy 若使用多帳套，則aph041的科目二抓取有誤,apw03改為apw031
# Modify.........: No.TQC-B90208 11/09/27 By yinhy "aph08銀行”欄位開窗有誤
# Modify.........: No.MOD-BA0189 11/10/30 By Dido 新增輸入段給予帳別改在 BEFORE INPUT
# Modify.........: No.MOD-BB0039 11/11/06 By Dido aapt335 預設類別為apz65,限定選擇apw_file資料 
# Modify.........: No.MOD-BB0091 11/11/07 By wujie aapt335 产生apa的时候预设apa20=0              
# Modify.........: No.MOD-BB0020 11/11/08 By yinhy aapt332,aapt330沖帳時，aapt220已沖金額回寫錯誤
# Modify.........: No.MOD-BB0098 11/11/09 By Polly 調整判斷，apf03是空值或不等於舊值，才重抓apf12
# Modify.........: No.MOD-BB0161 11/11/17 By Polly 增加判斷若apg_file已有資料，則不可異動幣別aap-368
# Modify.........: No.MOD-BB0212 11/11/21 By Dido 帳別預設值調整 
# Modify.........: No.MOD-BB0133 11/11/22 By yinhy apt335 产生apa时，预设apa73=apa34
# Modify.........: No.MOD-BB0276 11/11/26 By Dido aapt331 需有 aapi204 預設值 
# Modify.........: No.MOD-BB0305 11/11/30 By Dido 重新計算帳款與付款金額時,應排除匯差所產生的部分 
# Modify.........: No.MOD-BB0329 11/12/01 By Dido 增加判斷，如果參數:是大陸，則不做aap-804檢核 
# Modify.........: No.MOD-BC0103 11/12/13 By Polly 增加atm-370檢核aph05f不能為零
# Modify.........: No:MOD-BC0181 11/12/16 By Sarah 修正MOD-B60158,將程式段往前移造成g_success沒有預設值,導致IF判斷有誤
# Modify.........: No:MOD-BC0242 11/12/26 By Polly 1.FUNCTION t310_b2中所使用的備份變數為g_aph_t,調整此函式相關使用g_aph_o改為 g_aph_t
#                                                  2.FUNCTION t310_diff增加aph04/aph041預設值的給予
# Modify.........: No:MOD-BC0235 11/12/23 By yinhy 取消審核，刪除apa_file資料時去掉apa02 <= g_apf.apf02條件
# Modify.........: No:TQC-BC0195 11/12/30 By wujie aph23的检查追加apz68的判断
# Modify.........: No:TQC-BC0197 12/01/05 By yinhy UPDATE npp_file报错更改
# Modify.........: No:TQC-BC0197 12/01/05 By yinhy UPDATE npp_file报错更改
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-C20010 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C20058 12/02/08 By Polly 單身付款部份有兩筆以上相同的幣別但匯率不同，需走ELSE段
# Modify.........: No:MOD-C20117 12/02/13 By yinhy 單頭若沒有現金變動碼，審核段若單身對應現金變動碼未維護時才報錯
# Modify.........: No:MOD-C20202 12/02/23 bY Polly aapt330沖剩下的部份金額，apc13需再扣除apc15
# Modify.........: No:CHI-C10043 12/02/24 By Polly 週六週日遇到上班日，需增加詢問是否要移至非假日
# Modify.........: No:MOD-C30618 12/03/03 By Polly 「帳款資料」、「付款單身」動作，結束後需close t310_cl
# Modify.........: No:TQC-C30121 12/03/07 By zhangweib 第二單身付款類型D.收票轉付時，金額不可大于支票面額，而非已衝金額
# Modify.........: No:MOD-C30621 12/03/12 By zhangweib INFIELD(aph16) 開窗由q_nmc修改成q_nmc002
# Modify.........: No:FUN-C30140 12/03/12 By Mandy 送簽中,應不可執行ACTION[產生分錄底稿]
# Modify.........: No:TQC-C30108 12/03/16 By yinhy 立即審核并自動拋磚憑證時增加判斷
# Modify.........: No:MOD-C30818 12/03/23 By Polly 增加控卡，匯率為1,原幣與本幣的金額需相同
# Modify.........: No:TQC-C30293 12/03/26 By zhangll 增加廠商勾稽
# Modify.........: No:TQC-C30294 12/03/26 By zhangll D類型的，aph04，aph041清空
# Modify.........: No:TQC-C40096 12/04/13 By xuxz 付款單身到期日期默認值修改
# Modify.........: No:TQC-C40095 12/04/13 By minpp 确认立刻抛转总账时检查总账单别设置 
# Modify.........: No:TQC-C40194 12/04/10 By minpp 将点击[打印]的对应于打印额外备注的参数改为'Y'
# Modify.........: No:TQC-C50108 12/05/15 By xuxz 付款日期與到期日期關係調整
# Modify.........: No:TQC-C50124 12/05/15 By xuxz 單身金額欄位不可以輸入負值
# Modify.........: No:MOD-C50109 12/05/16 By Polly 當類型為36時，aph05/aph05f不可輸入負數，且apf09/apf09f=0
# Modify.........: No:MOD-C50093 12/05/17 By Polly 呼叫aap400所產生的傳票編號改用匯總訊息顯示
# Modify.........: No:MOD-C50183 12/05/24 By yinhy 增加人員，部門簡稱
# Modify.........: No.MOD-C50243 12/06/01 By Polly 拿除清訊息功能
# Modify.........: No.MOD-C60006 12/06/01 By yinhy 保存單據時應自動產生分錄，不需再去點產生分錄底稿按健
# Modify.........: No.CHI-C30101 12/06/05 By jinjj新增時,apf03=”EMPL”,則廠商簡稱apf12开窗q_gen代出員工姓名
# Modify.........: No.TQC-C60100 12/06/11 By lujh 當廠商簡稱更改后，審核時要提示與分錄底稿中的不一致
# Modify.........: No.MOD-C60117 12/06/14 By Polly 選取anmt302資料，只選擇nmg20類別為21且暫收否為N的資料
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C60196 12/06/25 By lujh 當單頭的付款廠商是MISC時，建議apf12欄位增加開窗功能，開窗選取內容的應是應付立賬中11、12、15類型的付款廠商為MISC的
#                                                 簡稱並且要有未付金額的才會顯示提供開窗選擇。
# Modify.........: No.TQC-C60212 12/06/26 By yuhuabao 調整CHI-C30107的錯誤問題
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.MOD-C70154 12/07/13 By Elise 管控‘差異處理’
# Modify.........: No.TQC-C70090 12/07/13 By lujh 進入退款部分單身後不輸入資料直接按「確定」離開，差異處理選擇「5:差異視為匯兌損益」系統報錯
# Modify.........: No.MOD-C70163 12/07/17 By Elise 修改共用函式
# Modify.........: No.MOD-C60040 12/07/18 By Elise 相關使用到gem_file部分,增加條件 gem05 = 'Y'
# Modify.........: No.MOD-C80043 12/08/07 By Elise FUNCTION t310_apf04中的gem_file改為OUTER JOIN
# Modify.........: No.MOD-C80080 12/08/13 By Polly aapt335產生轉銷部份的帳款資料，產生apa_file時，給予apa75預設值
# Modify.........: No.TQC-BC0062 11/08/23 By wangwei 增加判斷，账款本币金额若为0报错提示
# Modify.........: No:MOD-C90060 12/09/10 By Polly 調整批次產生分錄時，只詢問一次是否產生分錄即可
# Modify.........: No:MOD-C90082 12/09/14 By Polly 退款沖帳單的沖帳金額也需納入計算
# Modify.........: No.FUN-C90027 12/09/25 By xuxz 新增apf47
# Modify.........: No.TQC-C60067 12/10/12 By yinhy nmz71='Y'且nmz70<>'1'時，apf14和单身aph16可同時為空
# Modify.........: No.FUN-C90122 12/10/16 By wangrr aapt330 ahp03欄位add F:已開票據，檔aph03=F時aph04可以開窗抓取anmt100中供應廠商未沖完的票據 
# Modify.........: No.FUN-C90044 12/09/12 By minpp 1.aapt330/aapt332第二單身增加類型E"轉雜項應付",用來處理暫扣款
#................................12/10/09 By minpp 2.当为aapt330,aapt332调用次副程式时，apf09，apf09f无条件隐藏
#................................12/10/19 By minpp 3.aapt330，aapt332，差异选择归入“暂扣款”后，分录底稿及时更新
# Modify.........: No:CHI-CA0054 12/10/25 By SunLM 開放aapt335第二單身廠商簡稱欄位，當廠商為MISC時可以手動錄入廠商簡稱 
# Modify.........: No:TQC-CB0016 12/11/06 By zhangweib 若單身類型有aph03 =E:轉雜項應付 取消審核時判斷是否已有沖帳資料(apf35/apf35f>0).
#                                                      若有沖帳資料,則報錯"已有沖帳資料,不可以取消審核！"
# Modify.........: No:MOD-C90246 12/10/01 By Polly 訊息匯總顯示增加anm-710傳票拋轉成功提示
# Modify.........: No:MOD-CA0072 12/10/11 By Polly 取消匯率依幣別取位動作
# Modify.........: No.FUN-CB0019 12/11/06 By Carrier 新增时,若符合条件的单别只有一个,则自动带出此单别,不做开窗挑选
# Modify.........: No.FUN-CB0066 12/11/15 By wujie 账款单身新增参考单号开窗多选，并自动产生单身的功能
# Modify.........: No.MOD-CC0054 12/12/11 By yinhy aapt335單身二賬款日期默認為單頭沖帳日期
# Modify.........: No.MOD-CC0126 12/12/14 By Polly 查詢時不需重新抓又付款部門
# Modify.........: No.MOD-CC0166 12/12/21 By Polly 調整「維護常用科目」功能條件
# Modify.........: No.FUN-CB0054 12/12/25 By wangrr s_chkpost()傳參增加p_type保存方式0:單獨報錯,1:匯總報錯
# Modify.........: No.FUN-CB0065 12/12/27 By wangrr aapt330中aph03增加G:員工借支,可以調整供應商和員工之間的帳款
# Modify.........: No.FUN-CB0117 13/01/08 By wangrr 9主機追單到30
# Modify.........: No.MOD-CC0286 13/01/02 By Polly 調整aap-110條件控卡
# Modify.........: No.MOD-D10139 13/01/16 By Polly 開窗後選擇放棄時，需還原為舊值
# Modify.........: No.TQC-D10069 13/01/17 By wujie 帐款单身多选时若选择的账款不满足自动产生单身的条件，则不该再次弹出选择自动产生单身的对话框
# Modify.........: No.MOD-D20032 13/02/07 By zhangll 修正D收票轉付時，异常异常報錯"本次轉付金額已超出已衝金額範圍"
# Modify.........: No:FUN-D20035 13/02/20 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10058 13/03/07 By lujh aza70不勾選時，隱藏apf992
# Modify.........: No.FUN-D10057 13/03/07 By wangrr 增加ACTION"雜項應付/待抵查詢"
# Modify.........: No:CHI-CA0044 12/10/18 By Dido aapt332 增加常用科目運用
# Modify.........: No:MOD-D30176 13/03/19 By Polly 調整依範圍確認時離開FOREACH方式
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40083 13/04/22 By lujh 帳款單身有資料時，單頭付款廠商不讓修改
# Modify.........: No:MOD-D60008 13/06/03 By yinhy 退款冲账时增加判斷如果是同參考單號僅沖一次即可
# Modify.........: No:FUN-D60079 13/06/18 By zhangweib 單頭增加溢退單號欄位顯示
# Modify.........: No:MOD-D70039 13/07/08 By yinhy 調整調賬沖帳金額回寫
# Modify.........: No:MOD-D80049 13/08/08 By yinhy 批量審核時增加類型判斷
# Modify.........: No:MOD-D80050 13/08/08 By yinhy 更改時不可更改單據類型欄位
# Modify.........: No:MOD-D60211 13/06/27 By Lori 付款單身刪除後直接新增資料時不會到BEFORE INSERT導致無法新增資料
# Modify.........: No:FUN-D80070 13/08/19 By wangrr aapt330中付款單身"帳款類型"為'6789DG'時"銀行"欄位不可進入
# Modify.........: No:FUN-D80073 13/08/20 By wangrr aapt330單頭增加溢退單號欄位顯示
# Modify.........: No:MOD-D80144 13/08/23 By yinhy 溢退產生雜項付款單未更新付款單身的雜項應付單號
# Modify.........: No:MOD-D80175 13/08/27 By yinhy 付款部份類型為H:代付款時，anmt302中已有付款單號，不可取消審核
# Modify.........: No:MOD-D90019 13/09/03 By yinhy 單據類型為待抵賬款時單身一開窗應該為待抵單號
# Modify.........: NO:FUN-D90016 13/09/05 By yangtt 如果為外幣，更改狀態下，沖帳日期更改時不允許跨月
# Modify.........: No:FUN-DA0054     13/10/15 By yuhuabao “转账” “票据” “收票转付.单据日期不可大于票据关帐日期
# Modify.........: No:FUN-DA0054   13/10/15 By yuhuabao 审核时再次管控“转账” “票据” “收票转付.单据日期不可大于票据关帐日期
# Modify.........: No:FUN-DA0054   13/10/15 By yuhuabao 取消审核时管控 “转账” “票据” “收票转付.单据日期不可大于票据关帐日期
# Modify.........: No:FUN-DA0051 13/10/12 By yuhuabao apa05及apa06的开窗逻辑修改:1>非大陆版 只开窗厂商 2>大陆版按照参数apz74
#                                                     (是否允许客户立账)判断 注:aapt140只开客户,i:apz74= 'Y' 开窗 客户+厂商
#                                                     ii:apz74= 'N' 开窗 厂商
# Modify.........: NO:MOD-DB0017 13/11/04 By yinhy 關帳日期報錯條件修改
# Modify.........: NO:yinhy131203 13/12/03 By yinhy 註釋MOD-D70039
# Modify.........: No:181125     18/11/25  BY pulf   #修正aapt332退款时将之前金额覆盖，只产生当前退款金额回写至aapq230问题
# Modify.........: No:CHI-EC0020 15/01/22 By doris 改採累計方式回寫預收待抵已沖金額


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_apf           RECORD LIKE apf_file.*,       #付款單   (假單頭)
    g_apf_t         RECORD LIKE apf_file.*,       #付款單   (舊值)
    g_apf_o         RECORD LIKE apf_file.*,       #付款單   (舊值)
    g_apf01_t       LIKE apf_file.apf01,   # Pay No.     (舊值)
    g_apg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        apg02            LIKE apg_file.apg02,
        apg04            LIKE apg_file.apg04,
        apg06            LIKE apg_file.apg06,  #No.FUN-680027 add
        apa02            LIKE apa_file.apa02,
        apa13            LIKE apa_file.apa13,
        apa14            LIKE apa_file.apa14,
        apg05f           LIKE apg_file.apg05f,
        apg05            LIKE apg_file.apg05,
        apgud01 LIKE apg_file.apgud01,
        apgud02 LIKE apg_file.apgud02,
        apgud03 LIKE apg_file.apgud03,
        apgud04 LIKE apg_file.apgud04,
        apgud05 LIKE apg_file.apgud05,
        apgud06 LIKE apg_file.apgud06,
        apgud07 LIKE apg_file.apgud07,
        apgud08 LIKE apg_file.apgud08,
        apgud09 LIKE apg_file.apgud09,
        apgud10 LIKE apg_file.apgud10,
        apgud11 LIKE apg_file.apgud11,
        apgud12 LIKE apg_file.apgud12,
        apgud13 LIKE apg_file.apgud13,
        apgud14 LIKE apg_file.apgud14,
        apgud15 LIKE apg_file.apgud15
                    END RECORD,
    g_apg_t         RECORD                 #程式變數 (舊值)
        apg02            LIKE apg_file.apg02,
        apg04            LIKE apg_file.apg04,
        apg06            LIKE apg_file.apg06,   #No.FUN-680027 add
        apa02            LIKE apa_file.apa02,
        apa13            LIKE apa_file.apa13,
        apa14            LIKE apa_file.apa14,
        apg05f           LIKE apg_file.apg05f,
        apg05            LIKE apg_file.apg05,
        apgud01 LIKE apg_file.apgud01,
        apgud02 LIKE apg_file.apgud02,
        apgud03 LIKE apg_file.apgud03,
        apgud04 LIKE apg_file.apgud04,
        apgud05 LIKE apg_file.apgud05,
        apgud06 LIKE apg_file.apgud06,
        apgud07 LIKE apg_file.apgud07,
        apgud08 LIKE apg_file.apgud08,
        apgud09 LIKE apg_file.apgud09,
        apgud10 LIKE apg_file.apgud10,
        apgud11 LIKE apg_file.apgud11,
        apgud12 LIKE apg_file.apgud12,
        apgud13 LIKE apg_file.apgud13,
        apgud14 LIKE apg_file.apgud14,
        apgud15 LIKE apg_file.apgud15
                    END RECORD,
    g_aph           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aph02            LIKE aph_file.aph02,
        aph03            LIKE aph_file.aph03,
        aph26            LIKE aph_file.aph26,  #FUN-CB0065 add
        aph26_desc       LIKE gen_file.gen02,  #FUN-CB0065 add
#No.FUN-A90007 --begin
        aph21            LIKE aph_file.aph21,
        #pmc03            LIKE pmc_file.pmc03,#CHI-CA0054
        aph25            LIKE aph_file.aph25, #CHI-CA0054 add
        aph22            LIKE aph_file.aph22,
        apr02            LIKE apr_file.apr02,
#No.FUN-A90007 --end
        aph08            LIKE aph_file.aph08,   #TQC-5B0021
        aph04            LIKE aph_file.aph04,   #TQC-5B0021
        aph041           LIKE aph_file.aph041,  #No.FUN-680029
        aph17            LIKE aph_file.aph17,   #No.FUN-680027 add
#No.FUN-A90007 --begin
        aph23            LIKE aph_file.aph23,
        aph24            LIKE aph_file.aph24,
#No.FUN-A90007 --end
        aph16            LIKE aph_file.aph16,   #MOD-590054
        nmc02            LIKE nmc_file.nmc02,   #MOD-590054
        aph07            LIKE aph_file.aph07,
        aph09            LIKE aph_file.aph09,
        aph13            LIKE aph_file.aph13,
        aph14            LIKE aph_file.aph14,
        aph05f           LIKE aph_file.aph05f,
        aph05            LIKE aph_file.aph05,
#FUN-A20010 --Begin
        aph18            LIKE aph_file.aph18,
        aph19            LIKE aph_file.aph19,
        aph20            LIKE aph_file.aph20,
#FUN-A20010 --End
        aphud01 LIKE aph_file.aphud01,
        aphud02 LIKE aph_file.aphud02,
        aphud03 LIKE aph_file.aphud03,
        aphud04 LIKE aph_file.aphud04,
        aphud05 LIKE aph_file.aphud05,
        aphud06 LIKE aph_file.aphud06,
        aphud07 LIKE aph_file.aphud07,
        aphud08 LIKE aph_file.aphud08,
        aphud09 LIKE aph_file.aphud09,
        aphud10 LIKE aph_file.aphud10,
        aphud11 LIKE aph_file.aphud11,
        aphud12 LIKE aph_file.aphud12,
        aphud13 LIKE aph_file.aphud13,
        aphud14 LIKE aph_file.aphud14,
        aphud15 LIKE aph_file.aphud15
                    END RECORD,
    g_aph_t         RECORD
        aph02            LIKE aph_file.aph02,
        aph03            LIKE aph_file.aph03,
        aph26            LIKE aph_file.aph26,  #FUN-CB0065 add
        aph26_desc       LIKE gen_file.gen02,  #FUN-CB0065 add
#No.FUN-A90007 --begin
        aph21            LIKE aph_file.aph21,
        #pmc03            LIKE pmc_file.pmc03,#CHI-CA0054
        aph25            LIKE aph_file.aph25, #CHI-CA0054 add
        aph22            LIKE aph_file.aph22,
        apr02            LIKE apr_file.apr02,
#No.FUN-A90007 --end
        aph08            LIKE aph_file.aph08,   #TQC-5B0021
        aph04            LIKE aph_file.aph04,   #TQC-5B0021
        aph041           LIKE aph_file.aph041,  #No.FUN-680029
        aph17            LIKE aph_file.aph17,   #No.FUN-680027 add
#No.FUN-A90007 --begin
        aph23            LIKE aph_file.aph23,
        aph24            LIKE aph_file.aph24,
#No.FUN-A90007 --end
        aph16            LIKE aph_file.aph16,   #MOD-590054
        nmc02            LIKE nmc_file.nmc02,   #MOD-590054
        aph07            LIKE aph_file.aph07,
        aph09            LIKE aph_file.aph09,
        aph13            LIKE aph_file.aph13,
        aph14            LIKE aph_file.aph14,
        aph05f           LIKE aph_file.aph05f,
        aph05            LIKE aph_file.aph05,
#FUN-A20010 --Begin
        aph18            LIKE aph_file.aph18,
        aph19            LIKE aph_file.aph19,
        aph20            LIKE aph_file.aph20,
#FUN-A20010 --End
        aphud01 LIKE aph_file.aphud01,
        aphud02 LIKE aph_file.aphud02,
        aphud03 LIKE aph_file.aphud03,
        aphud04 LIKE aph_file.aphud04,
        aphud05 LIKE aph_file.aphud05,
        aphud06 LIKE aph_file.aphud06,
        aphud07 LIKE aph_file.aphud07,
        aphud08 LIKE aph_file.aphud08,
        aphud09 LIKE aph_file.aphud09,
        aphud10 LIKE aph_file.aphud10,
        aphud11 LIKE aph_file.aphud11,
        aphud12 LIKE aph_file.aphud12,
        aphud13 LIKE aph_file.aphud13,
        aphud14 LIKE aph_file.aphud14,
        aphud15 LIKE aph_file.aphud15
                    END RECORD,
    g_aph_o         RECORD LIKE aph_file.*,
    g_aps           RECORD LIKE aps_file.*,
     g_wc,g_wc2,g_wc3,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
    m_apf           RECORD LIKE apf_file.*,
    m_apg           RECORD LIKE apg_file.*,
    m_aph           RECORD LIKE aph_file.*,
    g_buf           LIKE type_file.chr1000,             #  #No.FUN-690028 VARCHAR(78)
    g_aptype        LIKE apf_file.apf00, #帳款種類 #FUN-660117
    g_dbs_nm        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_qty1,g_qty2,g_qty3,g_qty4,g_qty5  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_statu         LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),              #是否從新賦予等級
    g_note_days     LIKE type_file.num5,        # No.FUN-690028 SMALLINT,              #最大票期
    g_add           LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),               #是否為 Add Mode
    g_t1            LIKE oay_file.oayslip,               #單別     #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
    g_dbs_gl        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),              #工廠編號
    g_argv1         LIKE apf_file.apf01,   #付款單號
    g_argv2         STRING,                #No.FUN-630010 執行功能
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
DEFINE g_add_entry  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_net            LIKE apv_file.apv04    #MOD-590440
DEFINE g_date1      LIKE type_file.dat         #No.MOD-7B0096
 
#主程式開始
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  g_azi01         LIKE azi_file.azi01   #幣別
DEFINE  g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_str           STRING     #No.FUN-670060
DEFINE  g_wc_gl         STRING     #No.FUN-670060
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE  g_nmz10         LIKE nmz_file.nmz10    #No.FUN-DA0054 add
 
DEFINE  g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  g_void         LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)
DEFINE  g_chr2          LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE  g_chr3          LIKE type_file.chr1              #FUN-580150  #No.FUN-690028 VARCHAR(1)
DEFINE  g_laststage    LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)            #FUN-580150
DEFINE g_azp03             LIKE azp_file.azp03    #No.FUN-730064                                                                    
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730064                                                                    
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730064                                                                    
DEFINE g_bookno            LIKE aag_file.aag00    #No.FUN-730064                                                                    
DEFINE g_dbsm              LIKE type_file.chr21   #No.FUN-730064                                                                    
DEFINE g_plantm            LIKE type_file.chr10   #No.FUN-980020
DEFINE g_db_type           LIKE type_file.chr3    #No.FUN-730064                                                                    
DEFINE       g_flag        LIKE type_file.chr1    #No.FUN-730064                                                                    
DEFINE g_db1               LIKE type_file.chr21  #No.FUN-730064
DEFINE g_errmsg            STRING   #No.TQC-940123
DEFINE g_b_flag            STRING   #No.FUN-A60024           
DEFINE diff_flag           LIKE type_file.chr1   #差異處理方式 #CHI-AA0003 add
DEFINE g_multi_apg04 STRING    #No.FUN-CB0066
DEFINE g_multi_wc    STRING    #No.FUN-CB0066
DEFINE l_count1            LIKE type_file.num5 #No.FUN-DA0054
#No:181125 add begin---------
DEFINE  l_unfirm       LIKE type_file.chr1  
DEFINE  ll_amt         LIKE type_file.num20_6
DEFINE  ll_amtf        LIKE type_file.num20_6
DEFINE  ll_sql         STRING  
#No:181125 add end------------

FUNCTION t310(p_aptype,p_plant,p_argv1,p_argv2)  #No.FUN-630010
DEFINE
   p_aptype      LIKE apf_file.apf00,      # No.FUN-690028 VARCHAR(2),
   p_plant       LIKE azp_file.azp01,  #FUN-660117
   l_dbs         LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
   p_argv1       LIKE apf_file.apf01,
   p_argv2       STRING                          #No.FUN-630010
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CALL s_get_bookno('') RETURNING g_flag,g_bookno1,g_bookno2    #TQC-7C0050
 
   #---切換dbs
   IF p_argv1 is null or p_argv1 = ' ' THEN
      SLEEP 0
   ELSE
      LET g_plant=p_plant
      LET g_argv1=p_argv1
      LET g_argv2=p_argv2                        #No.FUN-630010
      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
      IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
      DATABASE l_dbs
      CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
      IF STATUS THEN ERROR 'open database error!' RETURN END IF
      LET g_plant = g_plant
      LET g_dbs   = l_dbs
   END IF
 
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數.key-1
   END IF
 
   LET g_forupd_sql = "SELECT * FROM apf_file WHERE apf01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t310_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET g_aptype = p_aptype
   LET g_add_entry='N'
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #TQC-720009                                                                                       
       IF p_aptype='34' THEN                                                                                                            
             OPEN WINDOW t311_w33 AT 2,2 WITH FORM "aap/42f/aapt331"                                                                    
             ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                    
       ELSE
             IF g_aptype = '33' THEN      #No.FUN-A40003
                OPEN WINDOW t310_w33 AT 2,2 WITH FORM "aap/42f/aapt330"
                ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
             END IF                       #No.FUN-A40003
#No.FUN-A40003 --begin
             IF g_aptype = '32' THEN      
                OPEN WINDOW t310_w33 AT 2,2 WITH FORM "aap/42f/aapt332"
                ATTRIBUTE (STYLE = g_win_style CLIPPED)  
             END IF
#No.FUN-A40003 --end
#No.FUN-A60024 --begin
             IF g_aptype = '36' THEN      
                OPEN WINDOW t310_w33 AT 2,2 WITH FORM "aap/42f/aapt335"
                ATTRIBUTE (STYLE = g_win_style CLIPPED)  
             END IF
#No.FUN-A60024 --end
       END IF
          CALL cl_ui_init()
          #FUN-C90044--ADD--STR
          IF g_aptype = '32' OR g_aptype = '33' THEN
             LET g_msg = cl_getmsg("aap1004",g_lang)
             CALL cl_set_comp_att_text("aph23",g_msg)
             CALL cl_set_comp_visible("apf09,apf09f",FALSE)
          END IF
          #FUN-C90044--ADD--END

          #FUN-D10058--add--str--
          IF g_aza.aza26 = '2' AND g_aza.aza70 = 'N' THEN
             CALL cl_set_comp_visible("apf992",FALSE)
          END IF
          #FUN-D10058--add--end--

          #FUN-CB0065--add--str--
          IF g_aptype <> '33' THEN
             CALL cl_set_comp_visible("aph26,aph26_desc",FALSE)
          END IF
          #FUN-CB0065--add--end
#No.FUN-A90007 --begin
          IF p_aptype <> '36' THEN 
      #      CALL cl_set_comp_visible("aph21,pmc03,aph22,apr02,aph23,aph24",FALSE)#No.FUN-C90027 mark 
             CALL cl_set_comp_visible("aph21,aph25,aph22,apr02,aph24,apf47",FALSE) #No.FUN-C90027 add apf47 #FN-C90044 del-aph23
          END IF  #CHI-CA0054 pmc03---> aph25
#No.FUN-A90007 --end

          #FUN-C90044--add--str
          IF p_aptype = '32' OR p_aptype = '33' THEN
             CALL cl_set_comp_visible("aph22",TRUE)
          END IF
         #FUN-C90044--add--end

          #TQC-B20092 --begin
          IF p_aptype ='32' OR p_aptype = '36' THEN
             CALL cl_set_comp_visible("apf14",FALSE)  
          END IF
          #TQC-B20092 --end

#No.TQC-B10075 --add--begin
          IF p_aptype = '32' THEN
             CALL cl_set_act_visible("handling_differences",FALSE)
          END IF

#str----add by huanglf160826
          IF p_aptype <>'33' THEN
             CALL cl_set_act_visible("first_confirm",TRUE)
          END IF
#str----end by huanglf160826
          #str------ add by dengsy170302
          IF g_prog='aapt330' THEN 
             CALL cl_set_act_visible("first_confirm,weiyue",TRUE)
          ELSE 
             CALL cl_set_act_visible("first_confirm,weiyue",FALSE)
          END IF 
          #end------ add by dengsy170302


#No.TQC-B10075 --add---end
#No.TQC-B10092--add--begin
          IF p_aptype = '36' THEN
             CALL cl_set_act_visible("handling_differences",FALSE)
          END IF
#NO.TQC-B10092--add--end
          CALL cl_set_act_visible("payable_sel",(g_aza.aza26='2' AND p_aptype='36')) #FUN-D10057
          IF p_aptype = '34' THEN
             CALL cl_set_comp_visible("apf992",FALSE)
          END IF
    
          IF g_aza.aza63 ='N' THEN
            CALL cl_set_comp_visible("aph041",FALSE)   
          END IF
   END IF   #TQC-720009
    #FUN-970077---Begin
    IF g_aza.aza73  = 'Y' AND g_aza.aza26  = '0' THEN
#      CALL cl_set_comp_visible("aph18,aph19",TRUE) #FUN-A20010
       CALL cl_set_comp_visible("aph18,aph19,aph20",TRUE) #FUN-A20010
    ELSE
#      CALL cl_set_comp_visible("aph18,aph19",FALSE)#FUN-A20010
       CALL cl_set_comp_visible("aph18,aph19,aph20",FALSE) #FUN-A20010
    END IF
    #FUN-970077---End
   CALL t310_set_comb()
#No.FUN-A80111 --begin
   IF g_aptype ='36' THEN 
      CALL cl_set_comp_required("apf06",FALSE)
   END IF 
#No.FUN-A80111 --end 
  #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
  #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
  CALL aws_efapp_toolbar()    #FUN-580150
 
  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t310_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t310_a()
           END IF
        WHEN "efconfirm"
           CALL t310_q()
           CALL s_showmsg_init()          #TQC-B10069
           LET g_success = "Y"            #TQC-B10069
           CALL t310_firm1_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t310_firm1_upd()       #CALL 原確認的 update 段
           END IF
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
           EXIT PROGRAM
           CALL s_showmsg()               #TQC-B10069
        OTHERWISE
           CALL t310_q()
     END CASE
  END IF
 
  #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
  CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,  #FUN-D20035 add--undo_void
                             confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,
                             gen_entry,entry_sheet,entry_sheet2, carry_voucher, undo_carry_voucher,handling_differences")     #No.FUN-680029 #TQC-740281 #CHI-AA0003 add handling_differences
       RETURNING g_laststage
 
     CALL t310_menu()
   CLOSE WINDOW t310_w33
END FUNCTION
 

#No.FUN-A60024 --begin
#QBE 查詢資料
FUNCTION t310_cs()
DEFINE    l_type          LIKE apa_file.apa00      # No.FUN-690028 VARCHAR(2)
DEFINE    l_dbs      LIKE type_file.chr21   #TQC-6A0042
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
   CLEAR FORM                             #清除畫面
   CALL g_apg.clear()
   CALL g_aph.clear()
 
   IF g_argv1<>' ' THEN
      LET g_wc=" apf01='",g_argv1,"'"
      LET g_wc2=" 1=1 "
      LET g_wc3=" 1=1 "
   ELSE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033          
      INITIALIZE g_apf.* TO NULL      #No.FUN-750051
      DIALOG ATTRIBUTES(UNBUFFERED) 
         CONSTRUCT BY NAME g_wc ON apf01,apf02,apfinpd,apf03,apf12,apf13,apf44,apf992,        #No.FUN-690090 add apf992 #No.FUN-A60024 add apf46 #FUN-A90007 delete apf46
                                   #apf41,apfmksg,apf42,apf06,apf11,apf14,   #No.FUN-540047
                                   apf41,apfmksg,apf42,apf45,apf47,apf06,apf11,apf14,   #No.FUN-540047 #FUN-870037 add apf45#FUN-C90027 add apf47
                                   apf04,apf05,apf08f,apf09f,apf10f,apf08,
                                   apf09,apf10,apfuser,apfgrup,apfmodu,           
                                   apfdate,apfacti,apforiu,apforig,          #No.TQC-B40038 add apforiu,apforig
                                   apfud01,apfud02,apfud03,apfud04,apfud05,
                                   apfud06,apfud07,apfud08,apfud09,apfud10,
                                   apfud11,apfud12,apfud13,apfud14,apfud15
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                     #No.FUN-580031
         END CONSTRUCT  
         
         CONSTRUCT g_wc2 ON apg02,apg04,apg06,apg05f   #FUN-990031 del apg03
                           ,apgud01,apgud02,apgud03,apgud04,apgud05
                           ,apgud06,apgud07,apgud08,apgud09,apgud10
                           ,apgud11,apgud12,apgud13,apgud14,apgud15
              FROM s_apg[1].apg02,s_apg[1].apg04,   #FUN-990031 del apg03
                   s_apg[1].apg06,s_apg[1].apg05f           #no.FUN-680027  add apg06
              ,s_apg[1].apgud01,s_apg[1].apgud02,s_apg[1].apgud03,s_apg[1].apgud04,s_apg[1].apgud05
              ,s_apg[1].apgud06,s_apg[1].apgud07,s_apg[1].apgud08,s_apg[1].apgud09,s_apg[1].apgud10
              ,s_apg[1].apgud11,s_apg[1].apgud12,s_apg[1].apgud13,s_apg[1].apgud14,s_apg[1].apgud15
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT 
         
         CONSTRUCT g_wc3 ON aph02,aph03,aph26,aph21,aph22,aph08,aph04,aph17,aph23,aph24,aph16,aph07,aph09,aph13,   #MOD-590054   #TQC-5B0021 #No.FUN-680027--add aph17  FUN-A90007 add aph21,aph22,aph23,aph24 #FUN-CB0065 add aph26
                            aph14,aph05f,aph05,aph18,aph19,aph20                     #FUN-A20010
                           ,aphud01,aphud02,aphud03,aphud04,aphud05
                           ,aphud06,aphud07,aphud08,aphud09,aphud10
                           ,aphud11,aphud12,aphud13,aphud14,aphud15
               FROM s_aph[1].aph02,s_aph[1].aph03,s_aph[1].aph26,s_aph[1].aph21,s_aph[1].aph22,s_aph[1].aph08,s_aph[1].aph04,s_aph[1].aph17,s_aph[1].aph23,s_aph[1].aph24,  #TQC-5B0021   #No.FUN-680027--add aph17  FUN-A90007 add aph21,aph22,aph23,aph24 #FUN-CB0065 add aph26
                    s_aph[1].aph16,   #MOD-590054
                    s_aph[1].aph07,s_aph[1].aph09,s_aph[1].aph13,s_aph[1].aph14,
                    s_aph[1].aph05f,s_aph[1].aph05,
                    s_aph[1].aph18,s_aph[1].aph19,s_aph[1].aph20  #FUN-A20010
                    ,s_aph[1].aphud01,s_aph[1].aphud02,s_aph[1].aphud03,s_aph[1].aphud04,s_aph[1].aphud05
                    ,s_aph[1].aphud06,s_aph[1].aphud07,s_aph[1].aphud08,s_aph[1].aphud09,s_aph[1].aphud10
                    ,s_aph[1].aphud11,s_aph[1].aphud12,s_aph[1].aphud13,s_aph[1].aphud14,s_aph[1].aphud15
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(apf01) #查詢單据
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf1"
                  LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf01
                  NEXT FIELD apf01
               WHEN INFIELD(apf03) #PAY TO VENDOR
                  #判断如果是大陆版且客户可以立账 开窗可以开厂商+客户
                  #FUN-DA0051 ----- add ----- begin
                  IF (g_aptype = '32' OR g_aptype = '33') AND g_aza.aza26 AND g_apz.apz74 = 'Y' THEN
                     CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                  ELSE
                  #FUN-DA0051 ----- add ----- end
                  IF g_aptype = '31' OR g_aptype = '32' OR g_aptype = '33' OR g_aptype = '36' THEN #No.FUN-A60024 add '36'
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_pmc"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  ELSE #CALL q_gen(0,0,g_apf.apf03) RETURNING g_apf.apf03
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gen"      #No.CHI-780046
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  END IF
                  END IF   #FUN-DA0051 add
                  DISPLAY g_qryparam.multiret TO apf03
                  CALL t310_apf03('d')
               WHEN INFIELD(apf04) # Employee CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"      #No.CHI-780046
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf04
               WHEN INFIELD(apf05) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf05
               WHEN INFIELD(apf06) # CURRENCY
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf06
               WHEN INFIELD(apf11) # reason code
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azf01a" #FUN-920186
                  LET g_qryparam.arg1 = '8'       #FUN-920186
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf11
               WHEN INFIELD(apf14) # 現金變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_nml"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf14
#No.FUN-A90007 --begin
#No.FUN-A60024 --begin
#               WHEN INFIELD(apf46) #PAY TO VENDOR
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_pmc"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO apf46
#No.FUN-A60024 --end
#No.FUN-A90007 --end
               WHEN INFIELD(apg04)
                  IF g_aptype = '34' THEN                                                                                              
                     IF g_apg[1].apg04='13' OR g_apg[1].apg04='16' THEN                                                                
                        SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant #MOD-840063 modify by liuxqa
                        LET g_qryparam.state = 'c' #FUN-980030
                        LET g_qryparam.plant = g_plant #FUN-980030.預設為g_plant
                        CALL q_m_apa(TRUE,TRUE,g_plant,'EMPL','*',  #FUN-990031                                                                  
                              #g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12)  #No.MOD-840409                  #MOD-A70102 mark
                               g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12,g_apf.apf02)  #No.MOD-840409      #MOD-A70102
                        RETURNING g_qryparam.multiret                                                                                  
                        DISPLAY g_qryparam.multiret TO apg04                                                                           
                     END IF                                                                                                            
                  ELSE
                     IF g_aptype ='33' OR g_aptype ='36' THEN    #No.FUN-A40003           #No.FUN-A60024 add '36'
                     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
                     LET g_qryparam.state = 'c' #FUN-980030
                     LET g_qryparam.plant = g_plant #FUN-980030.預設為g_plant
#No.FUN-C90027--BEGIN
                     IF g_apf.apf47 = '2' THEN
                        CALL q_m_apa(TRUE,TRUE,g_plant,g_apf.apf03,'*',   
                                  g_apf.apf06,'2*',g_apg[1].apg04,g_apf.apf12,g_apf.apf02)  
                        RETURNING g_qryparam.multiret 
                     ELSE
                        CALL q_m_apa(TRUE,TRUE,g_plant,g_apf.apf03,'*',  
                                  g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12,g_apf.apf02)  
                        RETURNING g_qryparam.multiret
                     END IF
#No.FUN-C90027--END
#FUN-C90027 --mark--str
#                    CALL q_m_apa(TRUE,TRUE,g_plant,g_apf.apf03,'*',   #FUN-990031 
#                                #g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12)  #No.MOD-840409                  #MOD-A70102 mark
#                                 g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12,g_apf.apf02)  #No.MOD-840409      #MOD-A70102
#                    RETURNING g_qryparam.multiret                                                                                     
#FUN-C90027 --mark--end
                     DISPLAY g_qryparam.multiret TO apg04  
                     END IF                    #No.FUN-A40003
#No.FUN-A40003 --begin
                     IF g_aptype ='32' THEN 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_apg"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO apg04
                     END IF 
#No.FUN-A40003 --end                                                                                               
                  END IF
              WHEN INFIELD(aph03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apw"
                 LET g_qryparam.arg1 = g_aza.aza81   #No.TQC-A30078
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph03
              #FUN-CB0065--add--str--
              WHEN INFIELD(aph26) #員工編號 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aph26"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph26
              #FUN-CB0065--add--
              WHEN INFIELD(aph08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_nma"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph08
              #FUN-970077---Begin
              WHEN INFIELD(aph18)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
#                 LET g_qryparam.form ="q_nnc1" #FUN-A20010
                  LET g_qryparam.form ="q_nnc2" #FUN-A20010
                  LET g_qryparam.arg1 =' '      #FUN-A20010
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aph18
              #FUN-970077---End
               WHEN INFIELD(aph16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                 #LET g_qryparam.form ="q_nmc"      #No.MOD-C30621   Mark
                  LET g_qryparam.form ="q_nmc002"   #No.MOD-C30621   Add
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aph16
              WHEN INFIELD(aph04)
                 IF g_aph[1].aph03 NOT MATCHES "[6789]" THEN
#No.FUN-A40003 --begin
                    IF g_aptype ='32' THEN 
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_aph"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO aph04
                    ELSE 
#No.FUN-A40003 --end
#No.FUN-B40011 --begin
                       IF g_aph[1].aph03 = 'D' THEN 
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_nmh6"
                           LET g_qryparam.state = "c"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO aph04
                       ELSE 
#No.FUN-B40011 --end 
                          CALL q_aapact(TRUE,TRUE,'2',g_aph[1].aph04,g_bookno1)    #No.8727    #No.FUN-730064
                              RETURNING g_aph[1].aph04
                       END IF  #No.FUN-B40011
                    END IF     #No.FUN-A40003
                 ELSE
                    CASE WHEN g_aph[1].aph03 = '6' LET l_type = '21'
                         WHEN g_aph[1].aph03 = '7' LET l_type = '22'
                         WHEN g_aph[1].aph03 = '8' 
                            IF g_aptype = '34' THEN
                               LET l_type = '25'
                            ELSE
                               LET l_type = '23'
                            END IF
                         WHEN g_aph[1].aph03 = '9' LET l_type = '24'
                    END CASE
                    CALL q_m_apa2(TRUE,TRUE,'',g_apf.apf03,'*',   #MOD-670014
                                 g_apf.apf06,l_type,g_aph[1].aph04)
                         RETURNING g_aph[1].aph04   #,g_aph[1].aph17  #No.FUN-680027 add
                 END IF
                 DISPLAY g_aph[1].aph04 TO aph04
              WHEN INFIELD(aph041)
                    CALL q_aapact(TRUE,TRUE,'2',g_aph[1].aph041,g_bookno2)    #No.8727   #No.FUN-730064
                         RETURNING g_aph[1].aph041
                    DISPLAY g_aph[1].aph041 TO aph041
              WHEN INFIELD(aph13) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph13
#No.FUN-A90007 --begin
              WHEN INFIELD(aph23) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apa"
                 LET g_qryparam.arg1 = g_aptype
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph23
                 NEXT FIELD aph23
              WHEN INFIELD(aph21) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph21
                 NEXT FIELD aph21
              WHEN INFIELD(aph22) # Class
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apr"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aph22
                 NEXT FIELD aph22
#No.FUN-A90007 --end
               OTHERWISE EXIT CASE
            END CASE
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION accept
               EXIT DIALOG
         
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG 
          
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG 
      END DIALOG 
             
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2 =' 1=1' 
   END IF  
   IF cl_null(g_wc3) THEN
      LET g_wc3 =' 1=1' 
   END IF  
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
 
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT apf01 FROM apf_file ",
                     " WHERE ", g_wc CLIPPED,
                     "   AND apf00 = '",g_aptype,"'",
                     " ORDER BY 1"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE apf01 ",
                     "  FROM apf_file, apg_file ",
                     " WHERE apf01 = apg01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND apf00 = '",g_aptype,"'",
                     " ORDER BY 1"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT UNIQUE apf01 ",
                     "  FROM apf_file,aph_file ",
                     " WHERE apf01=aph01 AND ", g_wc CLIPPED,
                     "   AND apf00 = '",g_aptype,"'",
                     "   AND ",g_wc3 CLIPPED,
                     " ORDER BY 1"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE apf01 ",
                     "  FROM apf_file, apg_file,aph_file ",
                     " WHERE apf01 = apg01 AND apf01=aph01 ",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND ",g_wc3 CLIPPED,
                     "   AND apf00 = '",g_aptype,"'",
                     " ORDER BY 1"
      END IF
   END IF
 
   PREPARE t310_prepare FROM g_sql
   DECLARE t310_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t310_prepare
 
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(*) FROM apf_file WHERE ",g_wc CLIPPED,
                   "   AND apf00 = '",g_aptype,"'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT apf01) FROM apf_file,apg_file WHERE ",
                   "apg01=apf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "   AND apf00 = '",g_aptype,"'"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(DISTINCT apf01) ",
                   "   FROM apf_file,aph_file  WHERE ",g_wc CLIPPED,
                   "   AND apf01=aph01 AND ",g_wc3 CLIPPED,
                   "   AND apf00 = '",g_aptype,"'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT apf01) ",
                   "  FROM apf_file,apg_file,aph_file  ",
                   "  WHERE apg01=apf01 AND apf01=aph01 ",
                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "    AND ",g_wc3 CLIPPED,
                   "   AND apf00 = '",g_aptype,"'"
      END IF
   END IF
   PREPARE t310_precount FROM g_sql
   DECLARE t310_count CURSOR FOR t310_precount
END FUNCTION
##QBE 查詢資料
#FUNCTION t310_cs()
#DEFINE    l_type          LIKE apa_file.apa00      # No.FUN-690028 VARCHAR(2)
#DEFINE    l_dbs      LIKE type_file.chr21   #TQC-6A0042
#DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
# 
#   CLEAR FORM                             #清除畫面
#   CALL g_apg.clear()
#   CALL g_aph.clear()
# 
#   IF g_argv1<>' ' THEN
#      LET g_wc=" apf01='",g_argv1,"'"
#      LET g_wc2=" 1=1 "
#      LET g_wc3=" 1=1 "
#   ELSE
#      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
# 
#      INITIALIZE g_apf.* TO NULL      #No.FUN-750051
#      CONSTRUCT BY NAME g_wc ON apf01,apf02,apfinpd,apf03,apf12,apf13,apf46,apf44,apf992,        #No.FUN-690090 add apf992 #No.FUN-A60024 add apf46
#                                #apf41,apfmksg,apf42,apf06,apf11,apf14,   #No.FUN-540047
#                                apf41,apfmksg,apf42,apf45,apf06,apf11,apf14,   #No.FUN-540047 #FUN-870037 add apf45
#                                apf04,apf05,apf08f,apf09f,apf10f,apf08,
#                                apf09,apf10,apfuser,apfgrup,apfmodu,           
#                                apfdate,apfacti,
#                                apfud01,apfud02,apfud03,apfud04,apfud05,
#                                apfud06,apfud07,apfud08,apfud09,apfud10,
#                                apfud11,apfud12,apfud13,apfud14,apfud15
#      BEFORE CONSTRUCT
#          CALL cl_qbe_init()                     #No.FUN-580031
# 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(apf01) #查詢單据
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_apf1"
#               LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf01
#               NEXT FIELD apf01
#            WHEN INFIELD(apf03) #PAY TO VENDOR
#               IF g_aptype = '31' OR g_aptype = '32' OR g_aptype = '33' OR g_aptype = '36' THEN        #No.FUN-A60024 add '36'
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_pmc"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#               ELSE #CALL q_gen(0,0,g_apf.apf03) RETURNING g_apf.apf03
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form ="q_gen"      #No.CHI-780046
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#               END IF
#               DISPLAY g_qryparam.multiret TO apf03
#               CALL t310_apf03('d')
#            WHEN INFIELD(apf04) # Employee CODE
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_gen"      #No.CHI-780046
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf04
#            WHEN INFIELD(apf05) # Dept CODE
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_gem"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf05
#            WHEN INFIELD(apf06) # CURRENCY
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_azi"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf06
#            WHEN INFIELD(apf11) # reason code
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_azf01a" #FUN-920186
#               LET g_qryparam.arg1 = '8'       #FUN-920186
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf11
#            WHEN INFIELD(apf14) # 現金變動碼
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_nml"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf14
##No.FUN-A60024 --begin
#            WHEN INFIELD(apf46) #PAY TO VENDOR
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_pmc"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO apf46
##No.FUN-A60024 --end
#            OTHERWISE EXIT CASE
#         END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_list() RETURNING lc_qbe_sn
#         CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      END CONSTRUCT
# 
#      IF INT_FLAG THEN
#         RETURN
#      END IF
# 
#      LET g_wc2 = " 1=1"
#      CONSTRUCT g_wc2 ON apg02,apg04,apg06,apg05f   #FUN-990031 del apg03
#                        ,apgud01,apgud02,apgud03,apgud04,apgud05
#                        ,apgud06,apgud07,apgud08,apgud09,apgud10
#                        ,apgud11,apgud12,apgud13,apgud14,apgud15
#           FROM s_apg[1].apg02,s_apg[1].apg04,   #FUN-990031 del apg03
#                s_apg[1].apg06,s_apg[1].apg05f           #no.FUN-680027  add apg06
#           ,s_apg[1].apgud01,s_apg[1].apgud02,s_apg[1].apgud03,s_apg[1].apgud04,s_apg[1].apgud05
#           ,s_apg[1].apgud06,s_apg[1].apgud07,s_apg[1].apgud08,s_apg[1].apgud09,s_apg[1].apgud10
#           ,s_apg[1].apgud11,s_apg[1].apgud12,s_apg[1].apgud13,s_apg[1].apgud14,s_apg[1].apgud15
# 
#       BEFORE CONSTRUCT
#          CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(apg04)
#               IF g_aptype = '34' THEN                                                                                              
#                  IF g_apg[1].apg04='13' OR g_apg[1].apg04='16' THEN                                                                
#                     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant #MOD-840063 modify by liuxqa
#                     LET g_qryparam.state = 'c' #FUN-980030
#                     LET g_qryparam.plant = g_plant #FUN-980030.預設為g_plant
#                     CALL q_m_apa(TRUE,TRUE,g_plant,'EMPL','*',  #FUN-990031                                                                  
#                            g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12)  #No.MOD-840409
#                     RETURNING g_qryparam.multiret                                                                                  
#                     DISPLAY g_qryparam.multiret TO apg04                                                                           
#                  END IF                                                                                                            
#               ELSE
#                  IF g_aptype ='33' OR g_aptype ='36' THEN    #No.FUN-A40003           #No.FUN-A60024 add '36'
#                  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant
#                  LET g_qryparam.state = 'c' #FUN-980030
#                  LET g_qryparam.plant = g_plant #FUN-980030.預設為g_plant
#                  CALL q_m_apa(TRUE,TRUE,g_plant,g_apf.apf03,'*',   #FUN-990031 
#                               g_apf.apf06,'1*',g_apg[1].apg04,g_apf.apf12)  #No.MOD-840409
#                  RETURNING g_qryparam.multiret                                                                                     
#                  DISPLAY g_qryparam.multiret TO apg04  
#                  END IF                    #No.FUN-A40003
##No.FUN-A40003 --begin
#                  IF g_aptype ='32' THEN 
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_apg"
#                     LET g_qryparam.state = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO apg04
#                  END IF 
##No.FUN-A40003 --end                                                                                               
#               END IF 
#
#            OTHERWISE
#               EXIT CASE
#         END CASE
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#       ON ACTION qbe_select
#          CALL cl_qbe_list() RETURNING lc_qbe_sn
#          CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      END CONSTRUCT
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         RETURN
#      END IF
# 
#      LET g_wc3 = " 1=1"
#      CONSTRUCT g_wc3 ON aph02,aph03,aph08,aph04,aph17,aph16,aph07,aph09,aph13,   #MOD-590054   #TQC-5B0021 #No.FUN-680027--add aph17
#                         aph14,aph05f,aph05,aph18,aph19,aph20                     #FUN-A20010
#                        ,aphud01,aphud02,aphud03,aphud04,aphud05
#                        ,aphud06,aphud07,aphud08,aphud09,aphud10
#                        ,aphud11,aphud12,aphud13,aphud14,aphud15
#            FROM s_aph[1].aph02,s_aph[1].aph03,s_aph[1].aph08,s_aph[1].aph04,s_aph[1].aph17,  #TQC-5B0021   #No.FUN-680027--add aph17
#                 s_aph[1].aph16,   #MOD-590054
#                 s_aph[1].aph07,s_aph[1].aph09,s_aph[1].aph13,s_aph[1].aph14,
#                 s_aph[1].aph05f,s_aph[1].aph05,
#                 s_aph[1].aph18,s_aph[1].aph19,s_aph[1].aph20  #FUN-A20010
#                 ,s_aph[1].aphud01,s_aph[1].aphud02,s_aph[1].aphud03,s_aph[1].aphud04,s_aph[1].aphud05
#                 ,s_aph[1].aphud06,s_aph[1].aphud07,s_aph[1].aphud08,s_aph[1].aphud09,s_aph[1].aphud10
#                 ,s_aph[1].aphud11,s_aph[1].aphud12,s_aph[1].aphud13,s_aph[1].aphud14,s_aph[1].aphud15
# 
#       BEFORE CONSTRUCT
#          CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(aph03)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_apw"
#              LET g_qryparam.arg1 = g_aza.aza81   #No.TQC-A30078
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aph03
#           WHEN INFIELD(aph08)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_nma"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aph08
#           #FUN-970077---Begin
#           WHEN INFIELD(aph18)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
##              LET g_qryparam.form ="q_nnc1" #FUN-A20010
#               LET g_qryparam.form ="q_nnc2" #FUN-A20010
#               LET g_qryparam.arg1 =' '      #FUN-A20010
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aph18
#           #FUN-970077---End
#            WHEN INFIELD(aph16)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_nmc"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aph16
#           WHEN INFIELD(aph04)
#              IF g_aph[1].aph03 NOT MATCHES "[6789]" THEN
##No.FUN-A40003 --begin
#                 IF g_aptype ='32' THEN 
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_aph"
#                    LET g_qryparam.state = "c"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
#                    DISPLAY g_qryparam.multiret TO aph04
#                 ELSE 
##No.FUN-A40003 --end 
#                    CALL q_aapact(TRUE,TRUE,'2',g_aph[1].aph04,g_bookno1)    #No.8727    #No.FUN-730064
#                         RETURNING g_aph[1].aph04
#                 END IF     #No.FUN-A40003
#              ELSE
#                 CASE WHEN g_aph[1].aph03 = '6' LET l_type = '21'
#                      WHEN g_aph[1].aph03 = '7' LET l_type = '22'
#                      WHEN g_aph[1].aph03 = '8' 
#                         IF g_aptype = '34' THEN
#                            LET l_type = '25'
#                         ELSE
#                            LET l_type = '23'
#                         END IF
#                      WHEN g_aph[1].aph03 = '9' LET l_type = '24'
#                 END CASE
#                 CALL q_m_apa2(TRUE,TRUE,'',g_apf.apf03,'*',   #MOD-670014
#                              g_apf.apf06,l_type,g_aph[1].aph04)
#                      RETURNING g_aph[1].aph04   #,g_aph[1].aph17  #No.FUN-680027 add
#              END IF
#              DISPLAY g_aph[1].aph04 TO aph04
#           WHEN INFIELD(aph041)
#                 CALL q_aapact(TRUE,TRUE,'2',g_aph[1].aph041,g_bookno2)    #No.8727   #No.FUN-730064
#                      RETURNING g_aph[1].aph041
#                 DISPLAY g_aph[1].aph041 TO aph041
#           WHEN INFIELD(aph13) # CURRENCY
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_azi"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aph13
#           OTHERWISE
#              EXIT CASE
#        END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
# 
#      END CONSTRUCT
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         RETURN
#      END IF
#   END IF
# 
#   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
# 
#   IF g_wc3=" 1=1" THEN
#      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
#         LET g_sql = "SELECT apf01 FROM apf_file ",
#                     " WHERE ", g_wc CLIPPED,
#                     "   AND apf00 = '",g_aptype,"'",
#                     " ORDER BY 1"
#      ELSE                              # 若單身有輸入條件
#         LET g_sql = "SELECT UNIQUE apf01 ",
#                     "  FROM apf_file, apg_file ",
#                     " WHERE apf01 = apg01",
#                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                     "   AND apf00 = '",g_aptype,"'",
#                     " ORDER BY 1"
#      END IF
#   ELSE
#      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
#         LET g_sql = "SELECT UNIQUE apf01 ",
#                     "  FROM apf_file,aph_file ",
#                     " WHERE apf01=aph01 AND ", g_wc CLIPPED,
#                     "   AND apf00 = '",g_aptype,"'",
#                     "   AND ",g_wc3 CLIPPED,
#                     " ORDER BY 1"
#      ELSE                              # 若單身有輸入條件
#         LET g_sql = "SELECT UNIQUE apf01 ",
#                     "  FROM apf_file, apg_file,aph_file ",
#                     " WHERE apf01 = apg01 AND apf01=aph01 ",
#                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                     "   AND ",g_wc3 CLIPPED,
#                     "   AND apf00 = '",g_aptype,"'",
#                     " ORDER BY 1"
#      END IF
#   END IF
# 
#   PREPARE t310_prepare FROM g_sql
#   DECLARE t310_cs                         #SCROLL CURSOR
#       SCROLL CURSOR WITH HOLD FOR t310_prepare
# 
#   IF g_wc3=" 1=1" THEN
#      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
#         LET g_sql="SELECT COUNT(*) FROM apf_file WHERE ",g_wc CLIPPED,
#                   "   AND apf00 = '",g_aptype,"'"
#      ELSE
#         LET g_sql="SELECT COUNT(DISTINCT apf01) FROM apf_file,apg_file WHERE ",
#                   "apg01=apf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
#                   "   AND apf00 = '",g_aptype,"'"
#      END IF
#   ELSE
#      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
#         LET g_sql="SELECT COUNT(DISTINCT apf01) ",
#                   "   FROM apf_file,aph_file  WHERE ",g_wc CLIPPED,
#                   "   AND apf01=aph01 AND ",g_wc3 CLIPPED,
#                   "   AND apf00 = '",g_aptype,"'"
#      ELSE
#         LET g_sql="SELECT COUNT(DISTINCT apf01) ",
#                   "  FROM apf_file,apg_file,aph_file  ",
#                   "  WHERE apg01=apf01 AND apf01=aph01 ",
#                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
#                   "    AND ",g_wc3 CLIPPED,
#                   "   AND apf00 = '",g_aptype,"'"
#      END IF
#   END IF
#   PREPARE t310_precount FROM g_sql
#   DECLARE t310_count CURSOR FOR t310_precount
#END FUNCTION
#No.FUN-A60024 --end 
FUNCTION t310_menu()
   DEFINE l_creator   LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)  #是否退回填表人
   DEFINe l_flowuser  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)  #是否有指定加簽人員      #FUN-580150
   DEFINE l_apa01     LIKE apa_file.apa01        #No.FUN-D60079   Add
 
   LET l_flowuser = "N"
 
   WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
         WHEN "insert"
            LET g_add = 'Y'
            IF cl_chk_act_auth() THEN
               CALL t310_a()
            END IF
            LET g_add = NULL
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t310_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t310_u()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t310_out('')
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
#No.FUN-A60024 --begin
#TQC-AC0409 ------------Begin----------------
#         WHEN "detail" 
#            CASE g_b_flag
#                WHEN '1' CALL t310_b()
#                WHEN '2' CALL t310_b2()
#            END CASE 
#TQC-AC0409 ------------End------------------
#TQC-AC0409 ------------Begin----------------remark----------
         WHEN "account_detail"
            IF cl_chk_act_auth() THEN
             
                  #str----- add by maoyy20160912
                  #IF g_apf.apfud02<>'Y' THEN  #mark by dengsy170313
                  IF (g_apf.apfud02<>'Y' AND g_prog='aapt330') OR g_prog<>'aapt330' THEN  #add by dengsy170302
                      
                   #end----- add by maoyy20160912
              
                       CALL t310_b()
                   #str----- add by maoyy20160912 
                  ELSE 
                      CALL s_errmsg('','','','192',1)
                       LET g_action_choice = NULL
                  END IF 
                 #end----- add by maoyy20160912
            ELSE
               LET g_action_choice = NULL
            END IF
#TQC-AC0409 ------------End------------------remark----------

         WHEN "qry_account_detail"
            IF cl_chk_act_auth() THEN
                
               CALL t310_bp2('G')
            ELSE
               LET g_action_choice = NULL
            END IF

#TQC-AC0409 ------------Begin----------------remark---------- 
         WHEN "payment_detail"
            IF cl_chk_act_auth() THEN
             
              
               #IF g_apf.apfud02<>'Y' THEN  #add by maoyy20160912  #mark by dengsy160921
               #IF (g_apf.apfud02<>'Y' AND g_prog='aapt330') OR g_prog<>'aapt330' THEN  #add by dnegsy170302
               CALL t310_b2()
                #str----- add by maoyy20160912 
                  {ELSE CALL s_errmsg('','','','192',1)  
                       LET g_action_choice = NULL       
                  END IF    #mark by dengsy160921 }
                 #end----- add by maoyy20160912
            ELSE
               LET g_action_choice = NULL
            END IF
#TQC-AC0409 ------------End------------------remark----------
#No.FUN-A60024 --end 
         #FUN-D10057--add--str--
         WHEN "payable_sel"
            IF cl_chk_act_auth() THEN
               IF g_apf.apf41='Y' THEN
                  IF g_apf.apf47='1' THEN
                     LET g_str=" aapt120 ",g_str
                     CALL cl_cmdrun(g_str)
                  END IF
                  IF g_apf.apf47='2' THEN
                     LET g_str=" aapt220  ",g_str
                     CALL cl_cmdrun(g_str)
                  END IF
               ELSE
                  CALL cl_err('','aap-354',0)
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-D10057--add--end--
         WHEN "gen_entry"
            CALL t310_v('1')
 
         WHEN "entry_sheet"
            CALL s_fsgl('AP',3,g_apf.apf01,0,g_apz.apz02b,1,g_apf.apf41,'0',g_apz.apz02p)     #No.FUN-680029
            CALL t310_npp02('0')     #No.FUN-680029
 
         WHEN "entry_sheet2"
            CALL s_fsgl('AP',3,g_apf.apf01,0,g_apz.apz02c,1,g_apf.apf41,'1',g_apz.apz02p)
            CALL t310_npp02('1')
 
         WHEN "memo"
            IF cl_chk_act_auth() AND g_apf.apf41 <> 'X' THEN
               CALL t310_m()
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069
               LET g_success = "Y"            #TQC-B10069
               LET l_unfirm = 'N'  #No:181125 add  #用于区分是否是审核与审核还原#Y：审核还原#N：审核
               CALL t310_firm1_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN           #MOD-A90129
                  CALL t310_firm1_chk1()         #No.CHI-A80036  ---add---
                  IF g_success = "Y" THEN   
                     CALL t310_firm1_upd()       #CALL 原確認的 update 段
                  ELSE                           #TQC-B20128 add
                     CLOSE WINDOW t310_w6        #TQC-B20128 add
                  END IF
               END IF                            #MOD-A90129
               CALL s_showmsg()                  #TQC-B10069  
               IF g_apf.apf41 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
              #No.FUN-D60079 ---Add--- Start
               SELECT apa01 INTO l_apa01 FROM apa_file WHERE apa08 = g_apf.apf01
               DISPLAY l_apa01 TO apa01
              #No.FUN-D60079 ---Add--- End
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               #FUN-DA0054 --- add --- begin “转账” “票据” “收票转让”转付”单据日期不可大于票据关帐日期
               IF g_aptype = '33' THEN
                  LET l_count1=0 
                  SELECT count(*) INTO l_count1 from aph_file where aph01=g_apf.apf01 and aph03 in ('1','2','D')
                  IF l_count1>0 THEN 
                     LET g_nmz10 = ''
                     SELECT nmz10 INTO g_nmz10 FROM nmz_file
                     #IF g_nmz10 > g_apf.apf02 THEN
                     IF g_nmz10 >= g_apf.apf02 THEN       #MOD-DB0017
                        CALL cl_err('','cxr-073',1)
 		        CONTINUE WHILE
                     END IF
                  END IF
               END IF
               #FUN-DA0054 --- add --- end
               #僅當"集團代付單號"為空時才可取消審核
               IF cl_null(g_apf.apf992) THEN             #No.FUN-690090    
               	  LET l_unfirm = 'Y'  #No:181125  #用于区分是否是审核与审核还原#Y：审核还原   #N：审核
                  CALL t310_firm2()
               ELSE                                      #No.FUN-690090     
                  CALL cl_err(g_apf.apf992,"aap-066",0)  #No.FUN-690090
                  CONTINUE WHILE                         #No.FUN-690090  
               END IF                                    #No.FUN-690090   
               IF g_apf.apf41 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_apf.apf42 = '1' THEN
                        LET g_chr2='Y' ELSE LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
               CALL t310_b2_fill(' 1=1')
            END IF
 
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t310_x()               #FUN-D20035
               CALL t310_x(1)               #FUN-D20035
               IF g_apf.apf41 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_apf.apf42 = '1' THEN
                      LET g_chr2='Y'
               ELSE
                      LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
            END IF
 
         #FUN-D20035----add--str
          #取消作废
          WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t310_x(2)             
               IF g_apf.apf41 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_apf.apf42 = '1' THEN
                      LET g_chr2='Y'
               ELSE
                      LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
            END IF
         #FUN-D20035---add--end
         
         #@WHEN "准"
         WHEN "agree"
            IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加>
               CALL t310_firm1_upd()      #CALL 原確認的 update 段
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
                       CALL t310_q()
                      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,   #FUN-D20035 add--undo_void
                                                  confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,
                                                  gen_entry,entry_sheet,entry_sheet2, carry_voucher, undo_carry_voucher")     #No.FUN-680029 #TQC-740281
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
            LET l_creator = aws_efapp_backflow()
            IF l_creator IS NOT NULL THEN #退回關卡
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_apf.apf42= 'R'
                     DISPLAY BY NAME g_apf.apf42
                  END IF
                  IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽>
                     IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       LET l_flowuser = "N"
                       LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                       IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                          CALL t310_q()
                        #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void,  undo_void,   #FUN-D20035 add--undo_void
                                                     confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,
                                                     gen_entry,entry_sheet,entry_sheet2, carry_voucher, undo_carry_voucher")     #No.FUN-680029 #TQC-740281
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
 
         WHEN "easyflow_approval"           #MOD-4A0299
           IF cl_chk_act_auth() THEN
               #FUN-C20010 add str---
                SELECT * INTO g_apf.* FROM apf_file
                 WHERE apf01 = g_apf.apf01
                CALL t310_show()
                CALL t310_b_fill(' 1=1')
                CALL t310_b2_fill(' 1=1')
               #FUN-C20010 add end---
                CALL t310_ef()
                CALL t310_show()  #FUN-C20010 add
           END IF
 
         WHEN "approval_status"             #MOD-4A0299
           IF cl_chk_act_auth() THEN  #DISPLAY ONLY
              IF aws_condition2() THEN
                  CALL aws_efstat2()                  #MOD-560007
              END IF
           END IF
 
         WHEN "carry_voucher"
           IF cl_chk_act_auth() THEN
              IF g_apf.apf41 = 'Y' THEN
                 CALL t310_carry_voucher()
              ELSE 
                 CALL cl_err('','atm-402',1)
              END IF
           END IF
         WHEN "undo_carry_voucher"
           IF cl_chk_act_auth() THEN
              IF g_apf.apf41 = 'Y' THEN
                 CALL t310_undo_carry_voucher() 
              ELSE 
                 CALL cl_err('','atm-403',1)
              END IF
           END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_apf.apf42 NOT matches '[Ss]' THEN    #FUN-910074 add
                    IF g_apf.apf01 IS NOT NULL THEN
                       LET g_doc.column1 = "apf01"
                       LET g_doc.value1 = g_apf.apf01
                       CALL cl_doc()
                    END IF 
                 END IF    #FUN-910074 add   
              END IF
#No.FUN-A30106 --begin                                                          
         WHEN "drill_down"                                                      
            IF cl_chk_act_auth() THEN                                           
               CALL t310_drill_down()                                           
            END IF                                                              
#No.FUN-A30106 --end
         #CHI-AA0003 add --start--
         WHEN "handling_differences"
            IF cl_chk_act_auth() THEN
               CALL t3101()
            ELSE
               LET g_action_choice = NULL
            END IF
         #CHI-AA0003 add --end--
          WHEN "first_confirm"
            IF cl_chk_act_auth() THEN
              UPDATE apf_file SET apfud02 = 'Y' ,apfud13=g_today  WHERE apf01 = g_apf.apf01
              LET g_apf.apfud02 = 'Y'
              CALL t310_show()
            ELSE
               LET g_action_choice = NULL
            END IF
#str------ add by maoyy20160905
       WHEN "weiyue"                                                        
          IF cl_chk_act_auth() THEN 
             IF NOT cl_null(g_apf.apf01 ) AND  g_apf.apf41<>'Y' THEN    #add by maoyy20160912        
             UPDATE apf_file SET apfud02='N'  WHERE apf01=g_apf.apf01  
             LET g_apf.apfud02='N'
             DISPLAY BY NAME g_apf.apfud02
             END IF 
          END IF  
#end------ add by maoyy20160905
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t310_npp02(p_npptype)     #No.FUN-680029
   DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680029
   DEFINE l_count     LIKE type_file.num5       #TQC-A70083 Add                                                                     
                                                                                                                                    
   #TQC-A70083--Add--Begin                                                                                                          
   LET l_count = 0                                                                                                                  
   SELECT COUNT(*) INTO l_count                                                                                                     
     FROM npp_file                                                                                                                  
    WHERE npp01=g_apf.apf01                                                                                                         
      AND npp011=1                                                                                                                  
      AND nppsys = 'AP'                                                                                                             
      AND npp00=3                                                                                                                   
      AND npptype = p_npptype                                                                                                       
   IF l_count = 0 THEN                                                                                                              
      CALL cl_err('','aap-275',1)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
   #TQC-A70083--Add--End

 
   UPDATE npp_file SET npp02=g_apf.apf02
    WHERE npp01=g_apf.apf01
      AND npp011=1
      AND nppsys = 'AP'
      AND npp00=3
      AND npptype = p_npptype     #No.FUN-680029
   #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023 #TQC-BC0197 mark
   IF SQLCA.sqlcode THEN   #TQC-BC0197
      CALL cl_err3("upd","npp_file",g_apf.apf01,"",STATUS,"","upd npp02.",1)  #No.FUN-660122
   END IF
END FUNCTION
 
FUNCTION t310_a()
   DEFINE   li_result   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_apg.clear()
   CALL g_aph.clear()
   INITIALIZE g_apf.* LIKE apf_file.*             #DEFAULT 設定
   LET g_apf01_t = NULL
   #預設值及將數值類變數清成零
   LET g_apf.apf00=g_aptype
   LET g_apf.apf02=g_today
   LET g_apf.apfinpd=g_today
   LET g_apf.apf06=g_aza.aza17
   LET g_apf.apf08=0
   LET g_apf.apf08f=0
   LET g_apf.apf09=0
   LET g_apf.apf09f=0
   LET g_apf.apf10=0
   LET g_apf.apf10f=0
   LET g_apf.apf41='N'
   LET g_apf.apf42='0'    #FUN-920104 add
   LET g_apf.apf43=g_apf.apf02
   LET g_apf_o.* = g_apf.*
   LET g_apf.apfmksg='N' #No.FUN-540047
   LET g_apf.apf42='0'   #No.FUN-540047
   LET g_apf.apf45 = 'N'  #no.FUN-870037
   LET g_apf.apfud02 = 'N'#str---add by huanglf160826
   #NO.131012 mark------------------------begin
   #No.yinhy130619  --Begin
   #IF cl_null(g_apf_t.apf04) THEN
      LET g_apf.apf04=g_user
   #ELSE
   #   LET g_apf.apf04=g_apf_t.apf04
   #END IF
   #IF cl_null(g_apf_t.apf05) THEN
      SELECT gen03 INTO g_apf.apf05 FROM gen_file
       WHERE gen01=g_apf.apf04
   #ELSE
   #   LET g_apf.apf05=g_apf.apf04
   #END IF
   #No.yinhy130619  --End
   #NO.131012 mark-------------------end
   #FUN-C90027--add--str--xuxz
   IF g_aptype = '36' THEN 
      LET g_apf.apf47 = 1
   ELSE
      LET g_apf.apf47 = 0  
   END IF 
   #FUN-C90027--add--end-xuxz
   LET g_apf.apfprno=0
   LET g_apf.apfuser=g_user
   LET g_apf.apforiu = g_user #FUN-980030
   LET g_apf.apforig = g_grup #FUN-980030
   LET g_apf.apfgrup=g_grup
   LET g_apf.apfdate=g_today
   LET g_apf.apfacti='Y'              #資料有效
   LET g_note_days = 0
   LET g_apf.apflegal= g_legal  #FUN-980001 add
   LET g_apf.apforiu = g_user   #TQC-A10060 add
   LET g_apf.apforig = g_grup   #TQC-A10060 add

   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t310_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_apf.* TO NULL
         EXIT WHILE
      END IF
      IF g_apf.apf01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
         CALL s_auto_assign_no("aap",g_apf.apf01,g_apf.apf02,"33","apf_file","apf01","","","")
           RETURNING li_result,g_apf.apf01
         IF (NOT li_result) THEN
            CONTINUE WHILE
         END IF
      DISPLAY BY NAME g_apf.apf01
      INSERT INTO apf_file VALUES (g_apf.*)
 
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         ROLLBACK WORK  #
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_apf.apf01,'I')
      END IF
      SELECT apf01 INTO g_apf.apf01 FROM apf_file
       WHERE apf01 = g_apf.apf01
      LET g_apf01_t = g_apf.apf01        #保留舊值
      LET g_apf_t.* = g_apf.*
      CALL g_apg.clear()
      LET g_add_entry='Y'
      LET g_rec_b = 0                    #No.FUN-680064
      CALL t310_b()                   #輸入單身-1
      SELECT COUNT(*) INTO g_cnt FROM apg_file WHERE apg01 = g_apf.apf01
      IF g_cnt = 0 THEN RETURN END IF
      CALL g_aph.clear()
      LET g_rec_b2 = 0                    #No.FUN-680064
      CALL t310_b2()                   #輸入單身-2
      LET g_t1=s_get_doc_no(m_apf.apf01)
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      IF NOT cl_null(g_apf01_t) AND g_apy.apyprint='Y' THEN  #是否馬上列印
          IF cl_confirm('mfg3242') THEN CALL t310_out('a') END IF  #MOD-4A0219
      END IF
      IF NOT cl_null(g_apf01_t) AND g_apy.apydmy1='Y'       #確認
      AND g_apy.apyapr <> 'Y'                                      #FUN-640240
      THEN
         LET g_action_choice = "insert"      #FUN-640240
         CALL s_showmsg_init()          #TQC-B10069
         LET g_success = "Y"            #TQC-B10069
         CALL t310_firm1_chk()          #CALL 原確認的 check 段
         IF g_success = "Y" THEN
            CALL t310_firm1_upd()       #CALL 原確認的 update 段
         END IF
         CALL s_showmsg()               #TQC-B10069
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t310_u()
DEFINE l_n1    LIKE type_file.num5  #add by maoyy20160905     
   IF s_aapshut(0) THEN RETURN END IF
   IF g_apf.apf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
 
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_apf.apf42 matches '[Ss]'         #MOD-4A0299
   THEN
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 ############add by maoyy20160905
   IF g_apf.apfud02='Y' THEN
    LET l_n1=''
   { select gem02 into l_n1 from gem_file,gen_file where gem01=gen03 and gen01=g_apf.apfmodu 
    if l_n1 <>  '*财务*' then
     
       CALL cl_err('','cap-123',1)
        RETURN
     end if
    end IF}   #mark by maoyy20160912


     select count(*) into l_n1 from gem_file,gen_file where gem01=gen03  #add by maoyy20160912
     and gen01=g_user and gem02 like '%财务%'

     if l_n1 =0 then
     
       #CALL cl_err('','cap-123',1)  #mark by dengsy160921
       # RETURN   #mark by dengsy160921
     end if
    end if
  ############add by maoyy20160905  
 
   #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF  #FUN-CB0054 mark
   IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF #FUN-CB0054 add
   IF g_apf.apfacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_apf.apf01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_apf01_t = g_apf.apf01
   LET g_apf_o.* = g_apf.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t310_cl USING g_apf.apf01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl.", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_apf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t310_show()
   WHILE TRUE
      LET g_apf01_t = g_apf.apf01
      LET g_apf.apfmodu=g_user
      LET g_apf.apfdate=g_today
      CALL t310_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_apf.*=g_apf_t.*
         CALL t310_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_apf.apf01 != g_apf01_t THEN            # 更改單號
         UPDATE apg_file SET apg01 = g_apf.apf01
          WHERE apg01 = g_apf01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("upd","apg_file",g_apf01_t,"",SQLCA.sqlcode,"","upd apg",1)  #No.FUN-660122
            CONTINUE WHILE
         END IF
      END IF
      LET g_apf.apf42 = '0'      #MOD-4A0299
      UPDATE apf_file SET apf_file.* = g_apf.* WHERE apf01 = g_apf01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
         CALL cl_err3("upd","apf_file",g_apf01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
         DISPLAY BY NAME g_apf.apf42              #MOD-4A0299
        IF g_apf.apf41 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
        IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
 
      IF g_apf_t.apf02 != g_apf.apf02 THEN
         UPDATE npp_file SET npp02=g_apf.apf02
          WHERE npp01=g_apf.apf01
            AND npp011 = 1
            AND npp00 = 3
            AND nppsys = 'AP'
         #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023  #TQC-BC0197 mark
         IF SQLCA.sqlcode THEN   #TQC-BC0197
            CALL cl_err3("upd","npp_file",g_apf.apf01,"",STATUS,"","upd npp02.",1)  #No.FUN-660122
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t310_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_apf.apf01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t310_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a.輸入 u.更改  #No.FUN-690028 VARCHAR(1)
    l_paydate       LIKE type_file.dat,                     #  #No.FUN-690028 DATE
    l_yy,l_mm       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  li_result   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  l_aag05     LIKE aag_file.aag05    #FUN-8C0106   add
DEFINE  l_aag05_1   LIKE aag_file.aag05    #FUN-8C0106   add
DEFINE  l_cnt       LIKE type_file.num5    #MOD-BB0161
#TQC-C50108--add--str
DEFINE l_true       LIKE type_file.num5
DEFINE li_sql       STRING
DEFINE li_aph07     LIKE aph_file.aph07
#TQC-C50108--add--end
DEFINE l_occ02_pmc03 LIKE occ_file.occ02  #FUN-DA0051
 
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
    INPUT BY NAME g_apf.apforiu,g_apf.apforig,
          g_apf.apf01,g_apf.apf02,g_apf.apfinpd,g_apf.apf03,g_apf.apf12,
          g_apf.apf13,g_apf.apf44,g_apf.apf992,g_apf.apf41,g_apf.apf42,g_apf.apfmksg,  #No.FUN-690090 add apf992  #FUN-920104 add apf42 #No.FUN-A60024 add apf46 #FUN-A90007 delete apf46
          g_apf.apf47, #FUN-C90027 add
          g_apf.apf06,g_apf.apf11,g_apf.apf14,g_apf.apf04,g_apf.apf05,
          g_apf.apf08f,g_apf.apf09f,g_apf.apf10f,
          g_apf.apf08,g_apf.apf09,g_apf.apf10,
          g_apf.apfuser,g_apf.apfgrup,g_apf.apfmodu,g_apf.apfdate,g_apf.apfacti,
          g_apf.apfud01,g_apf.apfud02,g_apf.apfud03,g_apf.apfud04,
          g_apf.apfud05,g_apf.apfud06,g_apf.apfud07,g_apf.apfud08,
          g_apf.apfud09,g_apf.apfud10,g_apf.apfud11,g_apf.apfud12,
          g_apf.apfud13,g_apf.apfud14,g_apf.apfud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         IF NOT cl_null(g_apf.apf02) THEN   #MOD-BA0189
            CALL t310_bookno()              #MOD-BA0189 
         END IF                             #MOD-BA0189
         CALL t310_set_entry(p_cmd)
         CALL t310_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("apf01")
 
        #NO.FUN-CB0019  --Begin
        BEFORE FIELD apf01
           IF cl_null(g_apf.apf01) THEN
              CALL s_get_slip('aap','apy_file','apyslip','apykind','apyacti',g_aptype,'')
                   RETURNING g_apf.apf01
              DISPLAY BY NAME g_apf.apf01
           END IF
        #NO.FUN-CB0019  --End

        AFTER FIELD apf01                  #帳款編號
           IF NOT cl_null(g_apf.apf01) THEN   #No.FUN-690080
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_apf.apf01 != g_apf01_t) THEN     #No.FUN-690080
#                  CALL s_check_no(g_sys,g_apf.apf01,g_apf01_t,g_aptype,"apf_file","apf01","") RETURNING li_result,g_apf.apf01
                  CALL s_check_no("AAP",g_apf.apf01,g_apf01_t,g_aptype,"apf_file","apf01","") RETURNING li_result,g_apf.apf01       #No.FUN-A40003
                  DISPLAY BY NAME g_apf.apf01
                  IF (NOT li_result) THEN
                     NEXT FIELD apf01
                  END IF
 
                  LET g_t1=g_apf.apf01[1,g_doc_len]   #No.FUN-560060
              END IF
           END IF   #No.FUN-690080
           SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
           IF p_cmd = 'a' THEN               #MOD-4A0299
              LET g_apf.apfmksg = g_apy.apyapr
              LET g_apf.apf42 = "0"
           END IF
           DISPLAY BY NAME g_apf.apfmksg,g_apf.apf42
 
        AFTER FIELD apf02                  #付款日期不可小於關帳日期
           IF NOT cl_null(g_apf.apf02) THEN
              CALL t310_bookno()       #No.FUN-730064
              IF NOT cl_null(g_errmsg) THEN 
                 CALL cl_err(g_errmsg,'!',1)
                 NEXT FIELD apf02
              END IF 
              IF g_apf.apf02 <= g_apz.apz57 THEN
                 CALL cl_err(g_apf.apf02,'aap-176',0)
              END IF
              #TQC-C50108--add--str
              IF p_cmd = 'u' THEN 
                 LET l_true = 0  
                 LET li_sql = " SELECT aph07 FROM aph_file ",
                              "  WHERE aph03 = 'D' ",
                              "    AND aph01 = '",g_apf.apf01,"'"
                 PREPARE t310_aph07_x FROM li_sql
                 DECLARE aph07_x_cur1 CURSOR FOR t310_aph07_x
                 FOREACH aph07_x_cur1 INTO li_aph07
                    IF li_aph07 < g_apf.apf02 THEN 
                       LET l_true = 1 
                    END IF
                 END FOREACH
                 IF l_true = 1 THEN 
                    CALL cl_err(g_apf.apf02,'aap-209',0)
                    NEXT FIELD apf02
                 END IF
                #FUN-D90016---add--str---
                 IF g_aptype = '33' THEN
                    IF g_apf.apf06 != g_aza.aza17 THEN
                       IF YEAR(g_apf.apf02) = YEAR(g_apf_t.apf02) THEN
                          IF g_apf.apf02 < s_first(g_apf_t.apf02) OR
                             g_apf.apf02 > s_last(g_apf_t.apf02) THEN
                             CALL cl_err(g_apf.apf02,'aap-831',0)
                             NEXT FIELD apf02
                          END IF
                       ELSE
                          CALL cl_err(g_apf.apf02,'aap-832',0)
                          NEXT FIELD apf02
                       END IF
                    END IF
                 END IF
                #FUN-D90016---add--end---
              END IF
              #TQC-C50108--add--end
              IF g_apz.apz27 = 'Y' THEN
                IF g_apz.apz22 = '1' THEN
                   SELECT azmm012 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '2' THEN
                   SELECT azmm022 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '3' THEN
                   SELECT azmm032 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '4' THEN
                   SELECT azmm042 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '5' THEN
                   SELECT azmm052 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '6' THEN
                   SELECT azmm062 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '7' THEN
                   SELECT azmm072 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '8' THEN
                   SELECT azmm082 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '9' THEN
                   SELECT azmm092 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '10' THEN
                   SELECT azmm102 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '11' THEN
                   SELECT azmm112 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '12' THEN
                   SELECT azmm122 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
                IF g_apz.apz22 = '13' THEN
                   SELECT azmm132 INTO g_date1 FROM azmm_file
                    WHERE azmm00 = g_aza.aza81
                      AND azmm01 = g_apz.apz21
                   LET g_apz.apz21 = g_apz.apz21+1
                  IF g_apf.apf02 <=g_date1 THEN
                     CALL cl_err(g_apf.apf02,'axr-405',0)
                     NEXT FIELD apf02
                  END IF
                END IF
             END IF
           END IF
 
        BEFORE FIELD apf03
         CALL t310_set_entry(p_cmd)
 
        AFTER FIELD apf03
         IF g_aptype='34' THEN  
           #IF p_cmd = 'a' OR g_apf.apf03 != g_apf_o.apf03 THEN             #MOD-BB0098 mark
            IF g_apf_o.apf03 IS NULL OR g_apf.apf03 != g_apf_o.apf03 THEN   #MOD-BB0098 add
               CALL t310_apf03('a')                                                                                                  
               IF NOT cl_null(g_errno) THEN                                                                                          
                  CALL cl_err(g_apf.apf03,g_errno,0)                                                                                 
                  LET g_apf.apf03 = g_apf_o.apf03                                                                                    
                  DISPLAY BY NAME g_apf.apf03                                                                                        
                  NEXT FIELD apf03                                                                                                   
               END IF                                                                                                                
            END IF                                                                                                                   
            LET g_apf_o.apf03 = g_apf.apf03
            LET g_apf_o.apf12 = g_apf.apf12   #FUN-D40083 add                                                                                          
            CALL t310_set_no_entry(p_cmd)                                                                                            
        ELSE 
           #IF p_cmd = 'a' OR g_apf.apf03 != g_apf_o.apf03                  #MOD-BB0098 mark
           #  OR g_apf.apf03 != g_apf_o.apf03 THEN                          #MOD-BB0098 mark
            IF g_apf_o.apf03 IS NULL OR g_apf.apf03 != g_apf_o.apf03 THEN   #MOD-BB0098 add
              CALL t310_apf03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_apf.apf03,g_errno,0)
                 LET g_apf.apf03 = g_apf_o.apf03
                 DISPLAY BY NAME g_apf.apf03
                 NEXT FIELD apf03
              END IF
           END IF
           LET g_apf_o.apf03 = g_apf.apf03
           LET g_apf_o.apf12 = g_apf.apf12                      #FUN-D40083 add
           CALL t310_set_no_entry(p_cmd)
        END IF
 
        AFTER FIELD apf12
            IF cl_null(g_apf.apf12) THEN NEXT FIELD apf12 END IF
            IF g_apf.apf12[1,1]='.' THEN
               LET g_msg = g_apf.apf12[2,9]
               SELECT gen02 INTO g_apf.apf12 FROM gen_file WHERE gen01=g_msg
               DISPLAY BY NAME g_apf.apf12
               IF STATUS THEN NEXT FIELD apf12 END IF
            END IF
            #TQC-C60100--add--str--
            IF g_apf_t.apf12 != g_apf.apf12 THEN
               LET g_apf_t.apf12 = g_apf.apf12
               DISPLAY BY NAME g_apf.apf12
               UPDATE apf_file SET apf12 = g_apf.apf12
                 WHERE apf01 = g_apf01_t
               IF cl_confirm('aap-944') THEN  
                  CALL t310_v('1')
               END IF 
            END IF
            #TQC-C60100--add--end--            

 
        AFTER FIELD apf13
         IF NOT cl_null(g_apf.apf13) AND g_apf.apf13 != g_apf_t.apf13 THEN
           CALL t310_input_apl()
         END IF
 
        AFTER FIELD apf04
           IF NOT cl_null(g_apf.apf04) THEN
              IF p_cmd = 'a' OR g_apf.apf04 != g_apf_t.apf04 THEN
                 CALL t310_apf04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_apf.apf04,g_errno,0)
                    NEXT FIELD apf04
                 END IF
              END IF
           END IF
 
        AFTER FIELD apf05
           IF NOT cl_null(g_apf.apf05) THEN
              IF p_cmd = 'a' OR g_apf.apf05 != g_apf_t.apf05 THEN
                 CALL t310_apf05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_apf.apf05,g_errno,0)
                    NEXT FIELD apf05
                 END IF
              END IF
 
              IF p_cmd = 'u' OR g_apf.apf05 != g_apf_t.apf05 THEN
                #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_aph[l_ac].aph04
                    AND aag00 = g_bookno1    
                
                 LET g_errno = ' '   
                 IF l_aag05 = 'Y' AND NOT cl_null(g_aph[l_ac].aph04) 
                    AND g_aph[l_ac].aph03 NOT MATCHES "[6789]" THEN
                    IF g_aaz.aaz90 !='Y' THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       CALL s_chkdept(g_aaz.aaz72,g_aph[l_ac].aph04,g_apf.apf05,g_bookno1)  
                                     RETURNING g_errno
                    END IF 
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD apf05
                    END IF
                 END IF
                
                #會計科目二
                 IF g_aza.aza63='Y' THEN
                    LET l_aag05_1=''
                    SELECT aag05 INTO l_aag05_1 FROM aag_file
                     WHERE aag01 = g_aph[l_ac].aph041
                       AND aag00 = g_bookno2    
                    
                    LET g_errno = ' '   
                    IF l_aag05_1 = 'Y' AND NOT cl_null(g_aph[l_ac].aph041)
                       AND g_aph[l_ac].aph03 NOT MATCHES "[6789]" THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          CALL s_chkdept(g_aaz.aaz72,g_aph[l_ac].aph041,g_apf.apf05,g_bookno2) 
                                        RETURNING g_errno
                       END IF
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD apf05
                       END IF
                    END IF
                 END IF
              END IF
 
           END IF
 
        AFTER FIELD apf06
           IF NOT cl_null(g_apf.apf06) THEN
              IF p_cmd = 'a' OR g_apf.apf06 != g_apf_t.apf06 THEN
                 CALL t310_apf06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_apf.apf06,g_errno,0)
                    NEXT FIELD apf06
                 END IF
                 CALL s_curr3(g_apf.apf06,g_apf.apf02,g_apz.apz33)
                   RETURNING g_apf.apf07
              END IF
           END IF
          #-------------------------------MOD-BB0161-------------------start
           SELECT COUNT(*) INTO l_cnt FROM apg_file WHERE apg01 = g_apf.apf01
           IF l_cnt > 0 AND g_apf.apf06 != g_apf_t.apf06 THEN
              CALL cl_err(g_apf.apf01,'aap-368',0)
              NEXT FIELD apf06
           END IF
          #-------------------------------MOD-BB0161---------------------end
 
        AFTER FIELD apf11
           IF NOT cl_null(g_apf.apf11) THEN
              CALL t310_apf11('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD apf11
              END IF
           END IF
 
        AFTER FIELD apf14
           IF NOT cl_null(g_apf.apf14) THEN
              SELECT COUNT(*) INTO g_cnt FROM nml_file
               WHERE nml01=g_apf.apf14
              IF g_cnt=0 THEN NEXT FIELD apf14 END IF
           END IF
 
        AFTER FIELD apfmksg
           IF NOT cl_null(g_apf.apfmksg) THEN
              IF g_apf.apfmksg NOT MATCHES "[YN]" THEN NEXT FIELD apf23 END IF
           END IF

#No.FUN-A90007 --begin
#No.FUN-A60024 --begin
#        AFTER FIELD apf46
#            IF p_cmd = 'a' OR g_apf.apf46 != g_apf_o.apf46
#              OR g_apf.apf46 != g_apf_o.apf46 THEN
#              CALL t310_apf46('a')
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(g_apf.apf46,g_errno,0)
#                 LET g_apf.apf46 = g_apf_o.apf46
#                 DISPLAY BY NAME g_apf.apf46
#                 NEXT FIELD apf46
#              END IF
#           END IF
#           LET g_apf_o.apf46 = g_apf.apf46
#No.FUN-A60024 --end 
#No.FUN-A90007 --end
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_apf.apfuser = s_get_data_owner("apf_file") #FUN-C10039
           LET g_apf.apfgrup = s_get_data_group("apf_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF g_apf.apf03 IS NULL THEN
              LET l_flag='Y'
              DISPLAY BY NAME g_apf.apf03
           END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD apf01
           END IF
 
        AFTER FIELD apfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(apf01) #查詢單据
                 LET g_t1=s_get_doc_no(g_apf.apf01)  #No.FUN-550030
                 CALL q_apy(FALSE,FALSE,g_t1,g_aptype,'AAP') RETURNING g_t1   #TQC-670008
                 LET g_apf.apf01=g_t1   #No.FUN-550030
                 DISPLAY BY NAME g_apf.apf01
                 NEXT FIELD apf01
              WHEN INFIELD(apf03) #PAY TO VENDOR
                 #判断如果是大陆版且客户可以立账 开窗可以开厂商+客户
                  #FUN-DA0051 ----- add ----- begin
                  IF (g_aptype = '32' OR g_aptype = '33') AND g_aza.aza26 AND g_apz.apz74 = 'Y' THEN
                     CALL q_occ_pmc(FALSE,TRUE,g_plant) RETURNING g_apf.apf03,l_occ02_pmc03
                  ELSE
                  #FUN-DA0051 ----- add ----- end
                 IF g_aptype = '31' OR g_aptype = '32' OR g_aptype = '33' OR g_aptype ='36' THEN     #No.FUN-A60024 add '36'
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pmc"
                    LET g_qryparam.default1 = g_apf.apf03
                    CALL cl_create_qry() RETURNING g_apf.apf03
                 ELSE #CALL q_gen(0,0,g_apf.apf03) RETURNING g_apf.apf03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"      #No.CHI-780046
                    LET g_qryparam.default1 = g_apf.apf03
                    CALL cl_create_qry() RETURNING g_apf.apf03
                 END IF
                 END IF   #FUN-DA0051 add
                 DISPLAY BY NAME g_apf.apf03
                 CALL t310_apf03('d')
              WHEN INFIELD(apf04) # Employee CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"      #No.CHI-780046
                 LET g_qryparam.default1 = g_apf.apf04
                 CALL cl_create_qry() RETURNING g_apf.apf04
                 DISPLAY BY NAME g_apf.apf04
              WHEN INFIELD(apf05) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_apf.apf05
                 CALL cl_create_qry() RETURNING g_apf.apf05
                 DISPLAY BY NAME g_apf.apf05
              WHEN INFIELD(apf06) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_apf.apf06
                 CALL cl_create_qry() RETURNING g_apf.apf06
                 DISPLAY BY NAME g_apf.apf06
              WHEN INFIELD(apf11) # reason code
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a" #FUN-920186
                 LET g_qryparam.arg1 = '8'       #FUN-920186
                 LET g_qryparam.default1 = g_apf.apf11
                 CALL cl_create_qry() RETURNING g_apf.apf11
                 DISPLAY BY NAME g_apf.apf11
              WHEN INFIELD(apf14) # 現金變動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nml"
                 LET g_qryparam.default1 = g_apf.apf14
                 CALL cl_create_qry() RETURNING g_apf.apf14
                 DISPLAY BY NAME g_apf.apf14
#CHI-C30101----str----
              WHEN INFIELD(apf12) 
                 IF g_apf.apf03 = "EMPL" AND g_aptype = '33' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen10"
                    LET g_qryparam.default1 = g_apf.apf12
                    CALL cl_create_qry() RETURNING g_apf.apf12
                    DISPLAY BY NAME g_apf.apf12
                 END IF
#CHI-C30101----end----
                 #TQC-C60196--add--str--
                 IF g_apf.apf03 = "MISC" THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_apa11"
                    LET g_qryparam.default1 = g_apf.apf12
                    CALL cl_create_qry() RETURNING g_apf.apf12
                    DISPLAY BY NAME g_apf.apf12
                 END IF 
                 #TQC-C60196--add--end--
#No.FUN-A90007 --begin
#No.FUN-A60024 --begin
#              WHEN INFIELD(apf46) #PAY TO VENDOR
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_pmc"
#                 LET g_qryparam.default1 = g_apf.apf46
#                 CALL cl_create_qry() RETURNING g_apf.apf46
#                 DISPLAY BY NAME g_apf.apf46
#No.FUN-A60024 --end
#No.FUN-A90007 --end
              OTHERWISE EXIT CASE
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
 
FUNCTION t310_apf03(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   #FUN-DA0051 ----- add ----- begin
   IF (g_aptype = '32' OR g_aptype = '33') AND g_aza.aza26 = '2' AND g_apz.apz74 = 'Y' THEN
       CALL t310_apf03_occ(p_cmd)
       IF g_errno = '100' THEN
          CALL t310_apf03_pmc(p_cmd)
       END IF
   ELSE
   #FUN-DA0051 ----- add ----- end
   IF g_aptype = '31' OR g_aptype = '32' OR g_aptype = '33' OR g_aptype ='36'  THEN      #No.MOD-740380     #No.FUN-A60024
      CALL t310_apf03_pmc(p_cmd)
   ELSE
      CALL t310_apf03_gen(p_cmd)
   END IF
   END IF    #FUN-DA0051 --- add
END FUNCTION
 
FUNCTION t310_apf03_pmc(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_pmc22   LIKE pmc_file.pmc22
   DEFINE l_pmc24   LIKE pmc_file.pmc24
   DEFINE l_pmc03 LIKE pmc_file.pmc03
   DEFINE l_pmc05 LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
   IF g_aptype='34' THEN                                                                                                            
      SELECT pmc22,pmc24,pmc05,pmcacti                                                                                              
         INTO l_pmc22,l_pmc24,l_pmc05,l_pmcacti                                                                                     
         FROM pmc_file                                                                                                              
         WHERE pmc01 = 'EMPL'                                                                                                       
      SELECT gen02 INTO l_pmc03 FROM gen_file WHERE gen01=g_apf.apf03                                                               
   ELSE
      SELECT pmc22,pmc24,pmc03,pmc05,pmcacti
         INTO l_pmc22,l_pmc24,l_pmc03,l_pmc05,l_pmcacti
         FROM pmc_file
         WHERE pmc01 = g_apf.apf03
   END IF
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'   #No.FUN-690024 add
 
        WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'
        WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_apf.apf12 = l_pmc03 
      LET g_apf.apf13 = l_pmc24
      LET g_apf.apf06 = l_pmc22
      DISPLAY BY NAME g_apf.apf12,g_apf.apf13,g_apf.apf06   
   END IF
END FUNCTION
 
#FUN-DA0051 ----- add ----- begin
#判断是否存在于pmc_file和occ_file资料档中
FUNCTION t310_apf03_occ(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   DEFINE l_occacti LIKE occ_file.occacti
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_occ07   LIKE occ_file.occ07
   DEFINE l_occ11   LIKE occ_file.occ11
   DEFINE l_occ1004 LIKE occ_file.occ1004

   LET g_errno = ' '
   LET l_occ02 = ''

   LET g_errno = ' '
   SELECT occ02,occ07,occ1004,occacti
     INTO l_occ02,l_occ07,l_occ11,l_occ1004,l_occacti
     FROM occ_file
    WHERE occ01 = g_apf.apf03

   CASE
      WHEN l_occacti = 'N'            LET g_errno = '9028'
      WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'
      WHEN l_occ1004   = '0'            LET g_errno = 'atm-073'
      WHEN l_occ1004   = '3'            LET g_errno = 'atm-079'
      WHEN STATUS=100 LET g_errno = '100'
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE


   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
   LET g_apf.apf12 = l_occ02
   DISPLAY BY NAME g_apf.apf12
END FUNCTION
#FUN-DA0051 ----- add ----- end

FUNCTION t310_apf03_gen(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gen02   LIKE gen_file.gen02      #No.CHI-780046
   DEFINE l_gen03   LIKE gen_file.gen03      #No.CHI-780046
   DEFINE l_genacti LIKE gen_file.genacti    #No.CHI-780046
 
   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file WHERE gen01 = g_apf.apf03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        #WHEN l_cpfacti = 'N'     LET g_errno = '9028'       #No.CHI-780046
        WHEN l_genacti = 'N'     LET g_errno = '9028'        #No.CHI-780046
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_apf.apf12 = l_gen02
   LET g_apf.apf05 = l_gen03
   DISPLAY BY NAME g_apf.apf12,g_apf.apf05
END FUNCTION
 
FUNCTION t310_apf04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gen02   LIKE gen_file.gen02      #MOD-C50183
   DEFINE l_gem02   LIKE gem_file.gem02      #MOD-C50183
   DEFINE l_gen03   LIKE gen_file.gen03      #No.CHI-780046
   DEFINE l_genacti LIKE gen_file.genacti    #No.CHI-780046

  #MOD-C80043---mod---S 
  #SELECT gen02,gen03,genacti,gem02 INTO l_gen02,l_gen03,l_genacti,l_gem02  #MOD-C50183 add gen02,gem02
  #  FROM gen_file,gem_file WHERE gen03=gem01 AND gen01 = g_apf.apf04 AND gem05='Y'                 #MOD-C50183 add gem_file

   SELECT gen02,gen03,genacti,gem02 INTO l_gen02,l_gen03,l_genacti,l_gem02
     FROM gen_file LEFT OUTER JOIN gem_file ON gem05 = 'Y' AND gen03 = gem01
    WHERE gen01 = g_apf.apf04
  #MOD-C80043---mod---E

   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'          #No.CHI-780046 
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY l_gen02 TO FORMONLY.gen02             #No.MOD-C50183
   DISPLAY l_gem02 TO FORMONLY.gem02             #No.MOD-C50183
   IF p_cmd = 'a' THEN                           #MOD-CC0126 add
      LET g_apf.apf05 = l_gen03                  #No.CHI-780046
   END IF                                        #MOD-CC0126 add
   DISPLAY BY NAME g_apf.apf05
END FUNCTION
 
FUNCTION t310_apf05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_gem02 LIKE gem_file.gem02    #MOD-C50183
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti  #MOD-C50183 add gem02
     FROM gem_file WHERE gem01 = g_apf.apf05
                     AND gem05 = 'Y'    #MOD-C60040 add gem05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY l_gem02 TO FORMONLY.gem02    #MOD-C50183
END FUNCTION
 
FUNCTION t310_apf06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_apf.apf06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t310_aph13(p_aph13)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_aziacti LIKE azi_file.aziacti
   DEFINE p_aph13   LIKE aph_file.aph13
 
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = p_aph13
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t310_apf11(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_azfacti LIKE azf_file.azfacti
   DEFINE l_azf03 LIKE azf_file.azf03
   DEFINE l_azf09 LIKE azf_file.azf09
   
   SELECT azfacti,azf03,azf09 INTO l_azfacti,l_azf03,l_azf09 FROM azf_file    #FUN-920186
    WHERE azf01 = g_apf.apf11 AND azf02 = '2'
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_azfacti = 'N'     LET g_errno = '9028'
        WHEN l_azf09 != '8'      LET g_errno = 'aoo-407'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   DISPLAY l_azf03 TO azf03
END FUNCTION
 
FUNCTION t310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_apf.* TO NULL               #No.FUN-6A0016
 
   CALL cl_msg("")                           #FUN-640240
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_apg.clear()
   CALL g_aph.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t310_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t310_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_apf.* TO NULL
   ELSE
      OPEN t310_count
      FETCH t310_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t310_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t310_cs INTO g_apf.apf01
      WHEN 'P' FETCH PREVIOUS t310_cs INTO g_apf.apf01
      WHEN 'F' FETCH FIRST    t310_cs INTO g_apf.apf01
      WHEN 'L' FETCH LAST     t310_cs INTO g_apf.apf01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,'. ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
 
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
 
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t310_cs INTO g_apf.apf01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)
      INITIALIZE g_apf.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_apf.* FROM apf_file WHERE apf01 = g_apf.apf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
      INITIALIZE g_apf.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_apf.apfuser     #No.FUN-4C0047
      LET g_data_group = g_apf.apfgrup     #No.FUN-4C0047
      CALL t310_bookno()     #No.FUN-730064
      IF NOT cl_null(g_errmsg) THEN 
         CALL cl_err(g_errmsg,'!',0)
      END IF 
      CALL t310_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t310_show()
   DEFINE l_apa01      LIKE apa_file.apa01   #No.FUN-D60079   Add

   LET g_apf_t.* = g_apf.*                #保存單頭舊值
   DISPLAY BY NAME g_apf.apforiu,g_apf.apforig,
          g_apf.apf01,g_apf.apf02,g_apf.apfinpd,g_apf.apf03,g_apf.apf12,
          g_apf.apf13,g_apf.apf44,g_apf.apf992,g_apf.apf41,g_apf.apfmksg,g_apf.apf42,   #No.FUN-540047  #No.FUN-690090 add apf992 #No.FUN-A60024 add apf46  #FUN-A90007 delete apf46
          g_apf.apf06,g_apf.apf11,g_apf.apf14,g_apf.apf04,g_apf.apf05,
          g_apf.apf08f,g_apf.apf09f,g_apf.apf10f,
          g_apf.apf08,g_apf.apf09,g_apf.apf10,
          g_apf.apfuser,g_apf.apfgrup,g_apf.apfmodu,g_apf.apfdate,g_apf.apfacti,
           g_apf.apfud01,g_apf.apfud02,g_apf.apfud03,g_apf.apfud04,
           g_apf.apfud05,g_apf.apfud06,g_apf.apfud07,g_apf.apfud08,
           g_apf.apfud09,g_apf.apfud10,g_apf.apfud11,g_apf.apfud12,
           g_apf.apfud13,g_apf.apfud14,g_apf.apfud15,
           g_apf.apf45,g_apf.apf47    #FUN-870037 add#FUN-C90027 add apf47
   CALL t310_apf03('d')
   CALL t310_apf04('d')   #MOD-C50183
   CALL t310_apf05('d')   #MOD-C50183
#   CALL t310_apf46('d')           #no.FUn-A60024  #No.FUN-A90007 mark
   CALL t310_apf11('d')
   CALL t310_b_fill(g_wc2)                 #單身
   CALL t310_b2_fill(g_wc3)                 #單身
   IF g_apf.apf41 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
 
  #No.FUN-D60079 ---Add--- Start
   #IF g_aptype = '32' THEN #FUN-D80073 mark
   IF g_aptype = '32' OR g_aptype = '33' THEN #FUN-D80073
      SELECT apa01 INTO l_apa01 FROM apa_file WHERE apa08 = g_apf.apf01
      DISPLAY l_apa01 TO apa01
   END IF
  #No.FUN-D60079 ---Add--- End

   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t310_r()
DEFINE l_apa            DYNAMIC ARRAY OF RECORD   #No.FUN-680027 add 
                apa01   LIKE apa_file.apa01       #No.FUN-680027 add
                        END RECORD                #No.FUN-680027 add
DEFINE i                LIKE type_file.num5       #No.FUN-680027 add  #No.FUN-690028 SMALLINT
DEFINE l_cnt            LIKE type_file.num5       #MOD-870048 add
DEFINE l_n1   LIKE gem_file.gem02 #add by maoyy20160905   
   IF s_aapshut(0) THEN RETURN END IF
   IF g_apf.apf01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
   IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_apf.apf42 matches '[Ss1]' THEN    #MOD-4A0299
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
############add by maoyy20160905
   IF g_apf.apfud02='Y' THEN
   LET l_n1=''
    select gem02 into l_n1 from gem_file,gen_file where gem01=gen03 and gen01=g_apf.apfmodu 
    if l_n1 <>  '%财务%' then
     
       CALL cl_err('','cap-123',1)
        RETURN
     end if
end if
  ############add by maoyy20160905  
   #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF #no.7277 #FUN-CB0054 mark
   IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF  #FUN-CB0054 add
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t310_cl USING g_apf.apf01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl.", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_apf.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t310_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "apf01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_apf.apf01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apg_file WHERE apg01 = g_apf.apf01
      IF l_cnt > 0 THEN
         DELETE FROM apg_file WHERE apg01 = g_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","apg_file",g_apf.apf01,"",SQLCA.sqlcode,"","del apg.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM aph_file WHERE aph01 = g_apf.apf01
      IF l_cnt > 0 THEN
         DELETE FROM aph_file WHERE aph01 = g_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","aph_file",g_apf.apf01,"",SQLCA.sqlcode,"","del aph.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apf_file WHERE apf01 = g_apf.apf01
      IF l_cnt > 0 THEN
         DELETE FROM apf_file WHERE apf01 = g_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","del apf.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_apf.apf01
         AND nppsys= 'AP'
         AND npp00 = 3
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_apf.apf01
            AND nppsys= 'AP'
            AND npp00 = 3
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_apf.apf01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_apf.apf01
         AND npqsys= 'AP'
         AND npq00 = 3
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_apf.apf01
            AND npqsys= 'AP'
            AND npq00 = 3
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_apf.apf01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add

      #FUN-B40056--add--str--
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_apf.apf01
      IF l_cnt > 0 THEN
         DELETE FROM tic_file WHERE tic04 = g_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            CALL cl_err3("del","tic_file",g_apf.apf01,"",SQLCA.sqlcode,"","del tic.",1) 
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056--add--end--

      DECLARE t310_r_apc CURSOR FOR                                                                                          
        SELECT apa01 FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'
#                                    AND apa02 <= m_apf.apf02          #MOD-A30146 add    #MOD-B70136
      LET i=1   
      FOREACH t310_r_apc INTO l_apa[i].apa01      
          LET i=i+1         
      END FOREACH          
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apa_file
       WHERE apa08=g_apf.apf01 AND apa00='24'
#        AND apa02 <= g_apf.apf02          #MOD-A30146 add              #MOD-B70136
      IF l_cnt > 0 THEN
         DELETE FROM apa_file
          WHERE apa08=g_apf.apf01 AND apa00='24'
#           AND apa02 <= g_apf.apf02          #MOD-A30146 add          #MOD-B70136
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","apa_file",g_apf.apf01,"",SQLCA.sqlcode,"","del apa.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         ELSE 
            FOR i=1 TO l_apa.getLength() 
               IF cl_null(l_apa[i].apa01) THEN CONTINUE FOR END IF  
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM apc_file
                WHERE apc01=l_apa[i].apa01
               IF l_cnt > 0 THEN
                  DELETE FROM apc_file WHERE apc01=l_apa[i].apa01   
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                     CALL cl_err3("del","apc_file",l_apa[i].apa01,"",SQLCA.sqlcode,"","del apc_file",1)     
                     ROLLBACK WORK
                     RETURN
                  END IF       
               END IF   #MOD-870048 add
            END FOR                                                                                                                 
         END IF
      END IF   #MOD-870048 add
      INITIALIZE g_apf.* TO NULL
      CLEAR FORM
      CALL g_apg.clear()
      CALL g_aph.clear()
      OPEN t310_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t310_cl
         CLOSE t310_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t310_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t310_cl
         CLOSE t310_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t310_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t310_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t310_fetch('/')
      END IF
   END IF
   CLOSE t310_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_apf.apf01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t310_g_b()
   CALL t310_g_b1()
END FUNCTION
 
FUNCTION t310_g_b1()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE body_sw            LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE p05f,p05           LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_apa44         LIKE apa_file.apa44
   DEFINE l_aba19         LIKE aba_file.aba19
   DEFINE g_t1            LIKE oay_file.oayslip   #MOD-580041  #No.FUN-690028 VARCHAR(5)
   DEFINE l_apydmy3       LIKE apy_file.apydmy3   #MOD-580041
 
   IF g_apf.apf01 IS NULL THEN RETURN END IF
   IF cl_null(g_multi_wc) THEN    #No.FUN-CB0066
   OPEN WINDOW t310_g_b_w AT 4,24 WITH FORM "aap/42f/aapt310_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt310_1")
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME body_sw WITHOUT DEFAULTS
      AFTER FIELD body_sw
         IF NOT cl_null(body_sw) THEN
            IF body_sw NOT MATCHES "[12]" THEN
               NEXT FIELD body_sw
            END IF
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
      CLOSE WINDOW t310_g_b_w
      RETURN
   END IF
 
   LET g_dbs_new = NULL
   LET g_plant_new = NULL   #FUN-A50102
   CASE WHEN body_sw = '2'
             CLOSE WINDOW t310_g_b_w
             RETURN
        WHEN body_sw = '1'
 
 
           OPEN WINDOW t310_g_b_w2 AT 10,20 WITH FORM "aap/42f/aapt310_2"
                 ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt310_2")
 
           CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
 
           CONSTRUCT BY NAME g_wc ON apa01,apa02,apa11,apa12,apa21,apa22
 
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
           END CONSTRUCT
           CLOSE WINDOW t310_g_b_w2
 
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CLOSE WINDOW t310_g_b_w
              RETURN
           END IF
   END CASE
   CLOSE WINDOW t310_g_b_w
   END IF            #No.FUN-CB0066
   
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t310_cl USING g_apf.apf01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl.", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_apf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t310_cl
      ROLLBACK WORK RETURN
   END IF
   LET l_ac = 1
#No.FUN-CB0066 --begin
   IF NOT cl_null(g_multi_wc) THEN 
   	  LET g_wc = g_multi_wc
   	  SELECT MAX(apg02) INTO l_ac FROM apg_file WHERE apg01 = g_apf.apf01
   	  IF cl_null(l_ac) THEN LET l_ac = 0 END IF 
   	  LET l_ac = l_ac + 1
   END IF 
#No.FUN-CB0066 --end
      IF g_apz.apz27 = 'N' THEN
         LET g_sql = "SELECT 0,apa01,apc02,apa02,apa13,apa14,",   #TQC-9B0119  
                     "       apc08-apc10-apc16-apc14,apc09-apc11-apc16*apa14-apc15, ", #MOD-B70047 add apc14/apc15
                     "apaud01,apaud02,apaud03,apaud04,apaud05,apaud06,apaud07,apaud08,",
                     "apaud09,apaud10,apaud11,apaud12,apaud13,apaud14,apaud15,", 
                     "       azi01,apa44",
                   # "  FROM ",g_dbs_new CLIPPED,"apa_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"azi_file ON apa_file.apa13 = azi_file.azi01, ",         #FUN-A50102 mark
                   #           g_dbs_new CLIPPED,"apc_file ",                                                                                           #FUN-A50102 mark
                     "  FROM ",cl_get_target_table(g_plant_new,'apa_file')," LEFT OUTER JOIN ",                         #FUN-A50102               
                               cl_get_target_table(g_plant_new,'azi_file')," ON apa_file.apa13 = azi_file.azi01, ",     #FUN-A50102 
                               cl_get_target_table(g_plant_new,'apc_file'),                           #FUN-A50102
                     " WHERE ",g_wc CLIPPED,
                     "   AND apa06 = '",g_apf.apf03 CLIPPED,"'",
                     "   AND apa13 = '",g_apf.apf06 CLIPPED,"'",
                     "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'",         #MOD-A30146 add
                     "   AND apa01=apc01 ",
                     "   AND (apc08>(apc10+apc16+apc14) OR apc09>(apc11+apc16*apa14+apc15)) ",    #MOD-5C0115 #MOD-B70047 add apc14/apc15
#                     "   AND apa00 LIKE '1%'",        #No.FUN-A40003
                     "   AND apa00 <> '16'", #No.MOD-7B0115
                     "   AND apa41 = 'Y' AND apa42 = 'N'",
                     "   AND apa13 = azi_file.azi01"
      ELSE
         LET g_sql = "SELECT 0,apa01,apc02,apa02,apa13,apa14,", #TQC-9B0119    
                    # "       apc08-apc10-apc16-apc14,apc13-apc16*apc07-apc15, ", #MOD-B70047 add apc14/apc15 #MOD-B90084 mark
                     "       apc08-apc10-apc16-apc14,apc13-apc16*apc07, ", #MOD-B90084
                     "apaud01,apaud02,apaud03,apaud04,apaud05,apaud06,apaud07,apaud08,",
                     "apaud09,apaud10,apaud11,apaud12,apaud13,apaud14,apaud15,", 
                     "       azi01,apa44",
                   # "  FROM ",g_dbs_new CLIPPED,"apa_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"azi_file ON apa_file.apa13 = azi_file.azi01, ",       #FUN-A50102 mark
                   #           g_dbs_new CLIPPED,"apc_file ",                                                                                         #FUN-A50102 mark   
                     "  FROM ",cl_get_target_table(g_plant_new,'apa_file')," LEFT OUTER JOIN ",                      #FUN-A50102
                               cl_get_target_table(g_plant_new,'azi_file')," ON apa_file.apa13 = azi_file.azi01, ",  #FUN-A50102
                               cl_get_target_table(g_plant_new,'apc_file'),                         #FUN-A50102
                     " WHERE ",g_wc CLIPPED,
                     "   AND apa06 = '",g_apf.apf03 CLIPPED,"'",
                     "   AND apa13 = '",g_apf.apf06 CLIPPED,"'",
                     "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'",         #MOD-A30146 add
                     "   AND apa01 = apc01 ",
                     #"   AND (apc08 >(apc10+apc16+apc14) OR apc13>(apc16*apc07+apc15))", #MOD-B70047 add apc14/apc15 #MOD-B90084
                     "   AND (apc08 >(apc10+apc16+apc14) OR apc13>(apc16*apc07))", #MOD-B90084
#                     "   AND apa00 LIKE '1%'",         #No.FUN-A40003
                     "   AND apa00 <> '16'", #No.MOD-7B0115
                     "   AND apa41 = 'Y' AND apa42 = 'N'",
                     "   AND apa13 = azi_file.azi01"
      END IF
      IF NOT cl_null(g_apf.apf12) THEN
         LET g_sql = g_sql CLIPPED,
                     "   AND apa07 = '",g_apf.apf12 CLIPPED,"'"
      END IF
#No.FUN-A40003 --begin
      IF g_aptype ='32' THEN
         LET g_sql = g_sql CLIPPED,"   AND apa00 LIKE '2%'" 
      ELSE 
         #FUN-C90027--add--xuxz--str
         IF g_apf.apf47 = '2' THEN 
            LET g_sql = g_sql CLIPPED,"   AND apa00 LIKE '2%' AND apa00 != '26'" 
         ELSE
         #FUN-C90027 add --end xuxz
            LET g_sql = g_sql CLIPPED,"   AND apa00 LIKE '1%' AND apa00 != '16'" #FUN-C90027 add apa00 !='16'
         END IF#FUN-C90027 add 
      END IF 
#No.FUN-A40003 --end
      LET g_sql = g_sql CLIPPED," ORDER BY apa01,apc02"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t310_g_b_p1 FROM g_sql
   DECLARE t310_g_b_c1 CURSOR WITH HOLD FOR t310_g_b_p1
   FOREACH t310_g_b_c1 INTO g_apg[l_ac].*, g_azi01,l_apa44
      IF STATUS THEN CALL cl_err('for apa',STATUS,1) EXIT FOREACH END IF
      LET p05f=0 LET p05 =0
     
      SELECT SUM(apg05f),SUM(apg05) INTO p05f,p05
        FROM apg_file,apf_file,apc_file            #No.FUN-680027 add apc_file
       WHERE apg04 = g_apg[l_ac].apg04 AND apc01=apg04  #No.FUN-680027 add
         AND apg06 = g_apg[l_ac].apg06 AND apg01=apf01 AND apf41='N'
 
      IF p05f IS NULL THEN LET p05f=0 END IF
      IF p05  IS NULL THEN LET p05 =0 END IF
      LET g_apg[l_ac].apg05f=g_apg[l_ac].apg05f-p05f
      LET g_apg[l_ac].apg05 =g_apg[l_ac].apg05 -p05
      IF g_apg[l_ac].apg05f<=0 AND g_apg[l_ac].apg05 <=0 THEN
         CONTINUE FOREACH
      END IF
      IF g_apz.apz06 = 'N' THEN
         LET g_t1 = s_get_doc_no(g_apg[l_ac].apg04)
         SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=g_t1
         IF l_apydmy3 = 'Y' AND cl_null(l_apa44) THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      #no.4642 若不可沖銷傳票未確認之應付帳款，則不自動產生
      IF NOT cl_null(l_apa44) AND g_apz.apz05 = 'N' THEN
         LET g_plant_new = g_apz.apz02p
         CALL s_getdbs()
         LET g_sql = "SELECT aba19 ",
                   # "  FROM ",g_dbs_new,"aba_file",                        #FUN-A50102  mark
                     "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                     "  WHERE aba01 = ? AND aba00 = ? "
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql       #FUN-A50102
         PREPARE t310_p4x FROM g_sql DECLARE t310_c4x CURSOR FOR t310_p4x
         OPEN t310_c4x USING l_apa44,g_apz.apz02b
         FETCH t310_c4x INTO l_aba19
         IF cl_null(l_aba19) THEN LET l_aba19 = 'N' END IF
         IF l_aba19 = 'N' THEN CONTINUE FOREACH END IF
      END IF
      SELECT max(apg02)+1 INTO g_apg[l_ac].apg02
        FROM apg_file
       WHERE apg01 = g_apf.apf01
      IF g_apg[l_ac].apg02 IS NULL THEN LET g_apg[l_ac].apg02 = 1 END IF
      LET g_apg[l_ac].apg05 = cl_digcut(g_apg[l_ac].apg05,g_azi04)   #85-10-28    #No.CHI-6A0004

      MESSAGE '>.',g_apg[l_ac].apg02,' ',
                   g_apg[l_ac].apg04,' ',g_apg[l_ac].apg05f
      INSERT INTO apg_file(apg01,apg02,apg04,apg05f,apg05,apg06,     #FUN-990031 del apg03 
                                  apgud01,apgud02,apgud03,
                                  apgud04,apgud05,apgud06,
                                  apgud07,apgud08,apgud09,
                                  apgud10,apgud11,apgud12,
                                  apgud13,apgud14,apgud15,apglegal) #FUN-980001 add legal
       VALUES(g_apf.apf01,
              g_apg[l_ac].apg02,     #FUN-990031
              g_apg[l_ac].apg04,g_apg[l_ac].apg05f,g_apg[l_ac].apg05,g_apg[l_ac].apg06,  #NO.fun-680027 add apg06
                                  g_apg[l_ac].apgud01,
                                  g_apg[l_ac].apgud02,
                                  g_apg[l_ac].apgud03,
                                  g_apg[l_ac].apgud04,
                                  g_apg[l_ac].apgud05,
                                  g_apg[l_ac].apgud06,
                                  g_apg[l_ac].apgud07,
                                  g_apg[l_ac].apgud08,
                                  g_apg[l_ac].apgud09,
                                  g_apg[l_ac].apgud10,
                                  g_apg[l_ac].apgud11,
                                  g_apg[l_ac].apgud12,
                                  g_apg[l_ac].apgud13,
                                  g_apg[l_ac].apgud14,
                                  g_apg[l_ac].apgud15,g_legal) #FUN-980001 add legal
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","apg_file",g_apf.apf01,g_apg[l_ac].apg02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CALL t310_b_fill(' 1=1')
   CALL t310_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t310_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_apf42         LIKE apf_file.apf42,
       l_cnt           LIKE type_file.num5,     #MOD-650097  #No.FUN-690028 SMALLINT
       l_dbs           LIKE type_file.chr21     #TQC-6A0042
DEFINE l_i             LIKE type_file.num5      #No.TQC-6B0066 
DEFINE lc_i            LIKE type_file.num5      #No.MOD-740413
DEFINE l_qty1,l_qty2,l_qty3,l_qty4,l_qty5  LIKE type_file.num20_6     # No.MOD-740413
DEFINE l_aph           RECORD LIKE aph_file.*   #MOD-8A0227 add
DEFINE l_apa           RECORD LIKE apa_file.*   #FUN-C90027 ADD
DEFINE l_type          STRING                   #No.FUN-CB0066
DEFINE l_apa35_u       LIKE apa_file.apa35     #FUN-D80047
DEFINE l_apa35_uf      LIKE apa_file.apa35     #FUN-D80047

 
   LET g_action_choice = ""
   IF s_aapshut(0) THEN RETURN END IF
   IF g_apf.apf01 IS NULL THEN RETURN END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
    LET l_apf42 = g_apf.apf42          #MOD-4A0299
   IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF #no.7277 #FUN-CB0054 mark
   IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF  #FUN-CB0054 add
   IF g_apf.apfacti ='N' THEN CALL cl_err(g_apf.apf01,'9027',0) RETURN END IF
    IF g_apf.apf42 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
   SELECT COUNT(*) INTO g_rec_b FROM apg_file WHERE apg01=g_apf.apf01
   IF g_rec_b = 0 THEN
      CALL t310_g_b()            # Auto Generate Body
      CALL t310_b_fill(' 1=1')
   END IF
   IF g_apz.apz13 = 'Y' THEN
      SELECT * INTO g_aps.* FROM aps_file WHERE aps01=g_apf.apf05
   ELSE
      SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
   END IF
 
   CALL cl_opmsg('b')
 
  LET g_forupd_sql = "SELECT apg02,apg04,apg06,'','','',apg05f,apg05,",   #FUN-990031 
                      "       apgud01,apgud02,apgud03,apgud04,apgud05,",
                      "       apgud06,apgud07,apgud08,apgud09,apgud10,",
                      "       apgud11,apgud12,apgud13,apgud14,apgud15", 
                      " FROM apg_file",
                      " WHERE apg01=? AND apg02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t310_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_apf.apfmodu=g_user
   LET g_apf.apfdate=g_today
   DISPLAY BY NAME g_apf.apfmodu,g_apf.apfdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   WHILE TRUE
   LET l_exit_sw = 'y'
   INPUT ARRAY g_apg WITHOUT DEFAULTS FROM s_apg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          OPEN t310_cl USING g_apf.apf01
          IF STATUS THEN
             CALL cl_err("OPEN t310_cl.", STATUS, 1)
             CLOSE t310_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t310_cl INTO g_apf.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t310_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             #No.MOD-C60006  --Begin
             LET g_apf_t.apf08 = g_apf.apf08
             LET g_apf_t.apf09 = g_apf.apf09
             LET g_apf_t.apf10 = g_apf.apf10
             #No.MOD-C60006  --End 
             LET g_apg_t.* = g_apg[l_ac].*  #BACKUP
             OPEN t310_b2cl USING g_apf.apf01,g_apg_t.apg02
             IF STATUS THEN
                CALL cl_err("OPEN t310_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t310_b2cl INTO g_apg[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_apg_t.apg02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             LET g_apg[l_ac].apa02 = g_apg_t.apa02
             LET g_apg[l_ac].apa13 = g_apg_t.apa13
             LET g_apg[l_ac].apa14 = g_apg_t.apa14
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          CALL t310_set_entry(p_cmd)
          CALL t310_set_no_entry(p_cmd)
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_apg[l_ac].* TO NULL      #900423
          LET g_apg[l_ac].apg05f= 0
          LET g_apg[l_ac].apg05 = 0
          LET g_apg_t.* = g_apg[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD apg02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          LET g_sql = "SELECT apc08 ,apc10 ,apc16,apc08-apc10-apc14",         #MOD-B70047 add apc14 
                    #  "  FROM ",g_dbs_new,"apc_file  ",                        #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102                                                                         
                       " WHERE apc01 = ?  AND apc02=? "                                                                             
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                              
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql              #FUN-A50102
          PREPARE t310_p4_1 FROM g_sql                                                                                              
          DECLARE t310_c4_1 CURSOR FOR t310_p4_1                                                                                    
          OPEN t310_c4_1 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                                  
          FETCH t310_c4_1 INTO g_qty1,g_qty2,g_qty3,g_qty4                                                                          
         #考慮付款未確認部分                                                                                                        
          LET g_sql = "SELECT SUM(apg05f)",                                                                                         
                    # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",     #FUN-A50102 mark
                      "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",#FUN-A50102
                                cl_get_target_table(g_plant_new,'apf_file'),    #FUN-A50102                                                       
                      " WHERE apg04 = ? AND apg06 = ? ",                                                                            
                      "   AND apg01 <> '",g_apf.apf01,"'",                                                                          
                      "   AND apg01 = apf01 AND apf41='N'"                                                                          
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                              
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql              #FUN-A50102
          PREPARE t310_p5_1 FROM g_sql                                                                                              
          DECLARE t310_c5_1 CURSOR FOR t310_p5_1                                                                                    
          OPEN t310_c5_1 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                                  
          FETCH t310_c5_1 INTO g_qty5                                                                                               
          IF cl_null(g_qty5) THEN LET g_qty5=0 END IF                                                                               
          IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF                                                                                  
          LET g_qty4=g_qty4 - g_qty5                                                                                                
          IF g_apg[l_ac].apg05f > g_qty4 THEN    
              CALL cl_err('','aap-069',1)                                                                                            
             NEXT FIELD apg05f                                                                                                      
             CANCEL INSERT                                                                                                          
          END IF                                                                                                                    
          IF g_apz.apz27 = 'N' THEN                                                                                                 
             LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc09-apc11",                                                              
                       # "  FROI ",g_dbs_new,"apa_file ,",                      #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102  
                         ",",cl_get_target_table(g_plant_new,'apc_file'),       #FUN-A50102
                       #           g_dbs_new,"apc_file  ",                      #FUN-A50102 mark                                                                       
                         " WHERE apa01 = ? AND apc02=?  ",                                                                          
                         "   AND apa01=apc01  ",                                                                                    
                         "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"          #MOD-A30146 add
          ELSE                                                                                                                      
             LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc13",                                                                    
                       # "  FROM ",g_dbs_new,"apa_file ,",                     #FUN-A50102 mark
                       #           g_dbs_new,"apc_file  ",                     #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),#FUN-A50102
                         ",",cl_get_target_table(g_plant_new,'apc_file'),      #FUN-A50102                                                                                                    
                         " WHERE apa01 = ? AND apc02=?  ",                                                                          
                         "   AND apa01=apc01  ",                                                                                    
                         "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"          #MOD-A30146 add
          END IF                                                                                                                    
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                              
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql            #FUN-A50102
          PREPARE t310_p6_1 FROM g_sql                                                                                              
          DECLARE t310_c6_1 CURSOR FOR t310_p6_1                                                                                    
          OPEN t310_c6_1 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                                  
          FETCH t310_c6_1 INTO g_qty1,g_qty2,g_qty3,g_qty4                                                                          
          LET g_sql = "SELECT SUM(apg05)",                                                                                          
                    # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",   #FUN-A50102 mark
                      "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),  #FUN-A50102
                      ",",cl_get_target_table(g_plant_new,'apf_file'),        #FUN-A50102  
                       " WHERE apg04 = ? AND apg06 = ? ",                                                                            
                      "   AND apg01 <> '",g_apf.apf01,"'",                                                                          
                      "   AND apg01 = apf01 AND apf41='N'"                                                                          
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                              
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql           #FUN-A50102
          PREPARE t310_p7_1 FROM g_sql                                                                                              
          DECLARE t310_c7_1 CURSOR FOR t310_p7_1                                                                                    
          OPEN t310_c7_1 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                                  
          FETCH t310_c7_1 INTO g_qty5                                                                                               
          IF cl_null(g_qty5) THEN LET g_qty5=0 END IF                                                                               
          IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF                                                                                  
          LET g_qty4=g_qty4 - g_qty5                                                                                                
          IF g_apg[l_ac].apg05 > g_qty4 THEN                                                                                        
             CALL cl_err('','aap-069',1)                                                                                            
             NEXT FIELD apg05                                                                                                       
             CANCEL INSERT                                                                                                          
          END IF                                                                                                                    
          INSERT INTO apg_file(apg01,apg02,apg04,apg05f,apg05,apg06,   #FUN-990031 
                                  apgud01,apgud02,apgud03,
                                  apgud04,apgud05,apgud06,
                                  apgud07,apgud08,apgud09,
                                  apgud10,apgud11,apgud12,
                                  apgud13,apgud14,apgud15,apglegal) #FUN-980001 add legal
            VALUES(g_apf.apf01,g_apg[l_ac].apg02,   #FUN-990031 
                   g_apg[l_ac].apg04,g_apg[l_ac].apg05f,g_apg[l_ac].apg05,
                   g_apg[l_ac].apg06, #No.FUN-680027 add apg06  
                                  g_apg[l_ac].apgud01,
                                  g_apg[l_ac].apgud02,
                                  g_apg[l_ac].apgud03,
                                  g_apg[l_ac].apgud04,
                                  g_apg[l_ac].apgud05,
                                  g_apg[l_ac].apgud06,
                                  g_apg[l_ac].apgud07,
                                  g_apg[l_ac].apgud08,
                                  g_apg[l_ac].apgud09,
                                  g_apg[l_ac].apgud10,
                                  g_apg[l_ac].apgud11,
                                  g_apg[l_ac].apgud12,
                                  g_apg[l_ac].apgud13,
                                  g_apg[l_ac].apgud14,
                                  g_apg[l_ac].apgud15,g_legal) #FUN-980001 add legal
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","apg_file",g_apf.apf01,g_apg[l_ac].apg02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             IF g_success='Y' THEN
                COMMIT WORK
                 LET l_apf42 = '0'          #MOD-4A0299
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       BEFORE FIELD apg02                        #default 序號
          IF g_apg[l_ac].apg02 IS NULL OR g_apg[l_ac].apg02 = 0 THEN
             SELECT max(apg02)+1
               INTO g_apg[l_ac].apg02
               FROM apg_file
              WHERE apg01 = g_apf.apf01
             IF g_apg[l_ac].apg02 IS NULL THEN
                LET g_apg[l_ac].apg02 = 1
             END IF
          END IF
           CALL t310_set_entry_b(p_cmd) #MOD-4A0171
 
       AFTER FIELD apg02                        #check 序號是否重複
          IF g_apg[l_ac].apg02 IS NULL THEN
             LET g_apg[l_ac].apg02 = g_apg_t.apg02
             NEXT FIELD apg02
          END IF
          IF g_apg[l_ac].apg02 != g_apg_t.apg02 OR
             g_apg_t.apg02 IS NULL THEN
              SELECT count(*)
                  INTO l_n
                  FROM apg_file
                  WHERE apg01 = g_apf.apf01
                    AND apg02 = g_apg[l_ac].apg02
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_apg[l_ac].apg02 = g_apg_t.apg02
                  NEXT FIELD apg02
              END IF
          END IF
           CALL t310_set_no_entry_b(p_cmd)  #MOD-4A0171



       AFTER FIELD apg04
          IF NOT cl_null(g_apg[l_ac].apg04) THEN
            #FUN-D80047--add--str--
            CALL t310_comp_oox(g_apg[l_ac].apg04) RETURNING g_net
            SELECT apa34-apa35,apa34f-apa35f 
              INTO l_apa35_u,l_apa35_uf
              FROM apa_file
             WHERE apa01 = g_apg[l_ac].apg04
               AND apa00 = '15'
            IF l_apa35_u - g_net != 0 AND  l_apa35_uf != 0 THEN 
               CALL cl_err(g_apg[l_ac].apg04,'aap-435',0)
               NEXT FIELD apg04
            END IF 
            #FUN-D80047--add--end--
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM aph_file
             WHERE aph01 = g_apf.apf01 AND aph03 = '8'
            IF l_cnt > 0  THEN   
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM apa_file
                WHERE (apa00 = '23' OR apa00 = '25')
                  AND apa01 IN (SELECT aph04 FROM aph_file
                                 WHERE aph01 = g_apf.apf01
                                   AND aph03 = '8')
                  AND apa08 = g_apg[l_ac].apg04
                  AND apa02 <= g_apf.apf02          #MOD-A30146 add
               IF l_cnt > 0 THEN
#                 CALL cl_err(g_apg[l_ac].apg04,'aap-753',1)   #CHI-B60072 mark
                  CALL cl_err(g_apg[l_ac].apg04,'aap-753',0)   #CHI-B60072
#                 NEXT FIELD apg04                             #CHI-B60072 mark
               END IF
            END IF
            IF (cl_null(g_apg_t.apg04) OR g_apg[l_ac].apg06 != g_apg_t.apg06)
                AND (NOT cl_null(g_apg[l_ac].apg06)) THEN 
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM apf_file,apg_file
                 WHERE apf01 = apg01 AND apg04 = g_apg[l_ac].apg04 AND 
                       apf01 = g_apf.apf01 AND apg06 = g_apg[l_ac].apg06
               IF g_apg_t.apg04 IS NULL OR
                   g_apg[l_ac].apg04 != g_apg_t.apg04 THEN
                   IF l_cnt > 0 THEN
                      CALL cl_err('','aap-112',1)
                      NEXT FIELD apg04
                   END IF
               END IF
            END IF 
            IF cl_null(g_apg_t.apg04) OR g_apg[l_ac].apg04 != g_apg_t.apg04 THEN 
                  SELECT COUNT(*) INTO l_i FROM apc_file WHERE apc01=g_apg[l_ac].apg04
                  IF l_i=1 THEN
                     LET g_apg[l_ac].apg06=1
                     CALL t310_apg04('a')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_apg[l_ac].apg04=g_apg_t.apg04
                        LET g_apg[l_ac].apg06=g_apg_t.apg06
                        NEXT FIELD apg04
                     ELSE 
                        LET l_cnt = 0
                        SELECT COUNT(*) INTO l_cnt FROM apf_file,apg_file
                         WHERE apf01=apg01       AND apg04=g_apg[l_ac].apg04
                           AND apf01=g_apf.apf01 AND apg06=g_apg[l_ac].apg06
                        IF g_apg_t.apg04 IS NULL OR
                           g_apg[l_ac].apg04 != g_apg_t.apg04 THEN
                           IF l_cnt > 0 THEN
                              CALL cl_err('','aap-112',1)
                              NEXT FIELD apg04
                           END IF
                        END IF
                        NEXT FIELD apg05f
                     END IF
                  END IF             
            END IF 
          END IF
      
       AFTER FIELD apg06
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM apf_file,apg_file
             WHERE apf01 = apg01 AND apg04 = g_apg[l_ac].apg04 AND 
                   apf01 = g_apf.apf01 AND apg06 = g_apg[l_ac].apg06
           IF g_apg_t.apg04 IS NULL OR
             (g_apg_t.apg04 IS NOT NULL AND
              g_apg[l_ac].apg04 != g_apg_t.apg04) THEN
               IF l_cnt > 0 THEN
                  CALL cl_err('','aap-112',1)
                  NEXT FIELD apg04
               END IF
           END IF
           IF NOT cl_null(g_apg[l_ac].apg06) THEN
              IF g_apg_t.apg06 IS NULL OR
                  g_apg[l_ac].apg04 != g_apg_t.apg04 OR
                  g_apg[l_ac].apg06 != g_apg_t.apg06 
                  THEN
                    CALL t310_apg04('a')
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_apg[l_ac].apg04=g_apg_t.apg04
                        LET g_apg[l_ac].apg06=g_apg_t.apg06
                        DISPLAY BY NAME g_apg[l_ac].apg04
                        DISPLAY BY NAME g_apg[l_ac].apg06
                        NEXT FIELD apg04
                    END IF
              END IF
           END IF
 
       BEFORE FIELD apg05f
           LET g_sql = "SELECT apc08 ,apc10 ,apc16,apc08-apc10-apc14",      #MOD-B70047 add apc14
                     # "  FROM ",g_dbs_new,"apc_file  ",                      #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_plant_new,'apc_file'), #FUN-A50102
                       " WHERE apc01 = ?  AND apc02=? "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
           PREPARE t310_p4 FROM g_sql
           DECLARE t310_c4 CURSOR FOR t310_p4
           OPEN t310_c4 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06  #No.FUN-680027 add apg06
           FETCH t310_c4 INTO g_qty1,g_qty2,g_qty3,g_qty4
           LET g_sql = "SELECT SUM(apg05f)",
                      # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",        #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",    #FUN-A50102
                                 cl_get_target_table(g_plant_new,'apf_file'),        #FUN-A50102   
                       " WHERE apg04 = ? AND apg06 = ? ",   #No.FUN-680027 add apg06
                       "   AND apg01 <> '",g_apf.apf01,"'",
                       "   AND apg01 = apf01 AND apf41='N'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
           PREPARE t310_p5 FROM g_sql
           DECLARE t310_c5 CURSOR FOR t310_p5
           OPEN t310_c5 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06  #No.FUN-680027 add apg06
           FETCH t310_c5 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('aap-061',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[34,41] = g_qty3 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_apg_t.apg05f = g_apg[l_ac].apg05f
 
       AFTER FIELD apg05f
          IF NOT cl_null(g_apg[l_ac].apg05f) THEN
             #TQC-C50124--add--str
             IF g_apg[l_ac].apg05f < 0 THEN
                CALL cl_err('','aec-992',1)
                LET g_apg[l_ac].apg05f = g_apg_t.apg05f
                NEXT FIELD apg05f
             END IF
             #TQC-C50124--add--end
             IF g_apg[l_ac].apg05f > g_qty4 THEN
                CALL cl_err('','aap-069',1)
                NEXT FIELD apg05f
             END IF
             IF g_apg[l_ac].apg05f = g_apg_t.apg05f THEN ELSE
                IF g_apg[l_ac].apg05f < g_qty4 THEN                           #No.TQC-740279
                   LET g_apg[l_ac].apg05=g_apg[l_ac].apg05f*g_apg[l_ac].apa14
                   CALL cl_digcut(g_apg[l_ac].apg05,g_azi04)  #No.CHI-6A0004
                        RETURNING g_apg[l_ac].apg05
                        DISPLAY BY NAME g_apg[l_ac].apg05
                END IF                                                        #No.TQC-740279
                #若原幣金額即為剩余金額，則本幣金額應抓取本幣剩余金額。
                IF g_apg[l_ac].apg05f = g_qty4 THEN
                   LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc09-apc11", 
                             # "  FROM ",g_dbs_new,"apa_file ,",                            #FUN-A50102 mark            
                             #           g_dbs_new,"apc_file  ",                            #FUN-A50102 mark
                               "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",   #FUN-A50102
                                         cl_get_target_table(g_plant_new,'apc_file'),       #FUN-A50102
                               " WHERE apa01 = ? AND apc02=?  ",             
                               "   AND apa01=apc01  ",                        
                               "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql    #FUN-A50102
                   PREPARE t310_p8 FROM g_sql
                   DECLARE t310_c8 CURSOR FOR t310_p8
                   OPEN t310_c8 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06    
                   FETCH t310_c8 INTO l_qty1,l_qty2,l_qty3,l_qty4
                   LET g_sql = "SELECT SUM(apg05)",
                             # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",        #FUN-A50102 mark
                               "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",   #FUN-A50102
                                         cl_get_target_table(g_plant_new,'apf_file'),       #FUN-A50102
                               " WHERE apg04 = ? AND apg06 = ? ",  
                               "   AND apg01 <> '",g_apf.apf01,"'",
                               "   AND apg01 = apf01 AND apf41='N'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
                   PREPARE t310_p9 FROM g_sql
                   DECLARE t310_c9 CURSOR FOR t310_p9
                   OPEN t310_c9 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06    
                   FETCH t310_c9 INTO l_qty5
                   IF cl_null(l_qty5) THEN LET l_qty5=0 END IF
                   IF l_qty4 < 0 THEN LET l_qty4 = 0 END IF
                   LET l_qty4=l_qty4 - l_qty5
                   CALL cl_getmsg('aap-061',g_lang) RETURNING g_msg
                   LET g_msg[6,13] = g_qty1 USING '--------'
                   LET g_msg[20,27] = g_qty2 USING '--------'
                   LET g_msg[34,41] = g_qty3 USING '--------'
                   LET g_msg[50,57] = g_qty5 USING '--------'
                   ERROR g_msg CLIPPED,g_qty4 USING '--------'
                   LET g_apg[l_ac].apg05 = l_qty4
                   LET g_apg_t.apg05 = g_apg[l_ac].apg05
                   CALL cl_digcut(g_apg[l_ac].apg05,g_azi04) 
                        RETURNING g_apg[l_ac].apg05
                   DISPLAY BY NAME g_apg[l_ac].apg05
                   
                END IF 
             END IF
          END IF
 
       BEFORE FIELD apg05
           IF g_apz.apz27 = 'N' THEN
              LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc09-apc11", 
                        # "  FROM ",g_dbs_new,"apa_file ,",                      #FUN-A50102 mark            
                        #           g_dbs_new,"apc_file  ",                      #FUN-A50102 mark
                          "  FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102
                          ",",cl_get_target_table(g_plant_new,'apc_file'),       #FUN-A50102
                          " WHERE apa01 = ? AND apc02=?  ",             
                          "   AND apa01=apc01  ",                       
                          "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
           ELSE
              LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc13",        
                        # "  FROM ",g_dbs_new,"apa_file ,",                       #FUN-A50102 mark                 
                        #           g_dbs_new,"apc_file  ",                       #FUN-A50102 mark
                          "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                          ",",cl_get_target_table(g_plant_new,'apc_file'),        #FUN-A50102                     
                          " WHERE apa01 = ? AND apc02=?  ",             
                          "   AND apa01=apc01  ",                               
                          "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
           END IF
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
           PREPARE t310_p6 FROM g_sql
           DECLARE t310_c6 CURSOR FOR t310_p6
           OPEN t310_c6 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06    #No.FUN-680027 add apg06
           FETCH t310_c6 INTO g_qty1,g_qty2,g_qty3,g_qty4
           LET g_sql = "SELECT SUM(apg05)",
                     # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",                #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",           #FUN-A50102
                                 cl_get_target_table(g_plant_new,'apf_file'),               #FUN-A50102                
                       " WHERE apg04 = ? AND apg06 = ? ",  #No.FUN-680027 add apg06
                       "   AND apg01 <> '",g_apf.apf01,"'",
                       "   AND apg01 = apf01 AND apf41='N'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
           PREPARE t310_p7 FROM g_sql
           DECLARE t310_c7 CURSOR FOR t310_p7
           OPEN t310_c7 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06    #No.FUN-680027 add apg06
           FETCH t310_c7 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('aap-061',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[34,41] = g_qty3 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_apg_t.apg05 = g_apg[l_ac].apg05
 
 
       AFTER FIELD apg05
          IF NOT cl_null(g_apg[l_ac].apg05) THEN
             IF g_apg[l_ac].apg05 > g_qty4 THEN
                CALL cl_err('','aap-069',1)
                NEXT FIELD apg05
             END IF
             #TQC-C50124--add--str
             IF g_apg[l_ac].apg05 < 0 THEN
                CALL cl_err('','aec-992',1)
                LET g_apg[l_ac].apg05 = g_apg_t.apg05
                NEXT FIELD apg05
             END IF
             #TQC-C50124--add--end
             IF g_apg[l_ac].apg05 != g_apg_t.apg05 THEN
                CALL cl_digcut(g_apg[l_ac].apg05,g_azi04)  #No.CHI-6A0004
                     RETURNING g_apg[l_ac].apg05
                     DISPLAY BY NAME g_apg[l_ac].apg05
             END IF
          END IF   #MOD-650097
 
        AFTER FIELD apgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD apgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_apg_t.apg02 > 0 AND
             g_apg_t.apg02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM apg_file
              WHERE apg01 = g_apf.apf01
                AND apg02 = g_apg_t.apg02
             IF l_cnt > 0 THEN
                DELETE FROM apg_file
                 WHERE apg01 = g_apf.apf01
                   AND apg02 = g_apg_t.apg02
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                   CALL cl_err3("del","apg_file",g_apf.apf01,g_apg_t.apg02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
             END IF   #MOD-870048 add
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             IF g_success='Y' THEN
                CALL t310_b1_tot()
                COMMIT WORK
                 LET l_apf42 = '0'          #MOD-4A0299
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_apg[l_ac].* = g_apg_t.*
             CLOSE t310_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_apg[l_ac].apg02,-263,1)
             LET g_apg[l_ac].* = g_apg_t.*
          ELSE
             LET g_sql = "SELECT apc08 ,apc10 ,apc16,apc08-apc10-apc14",  #MOD-B70047 add apc14 
                       # "  FROM ",g_dbs_new,"apc_file  ",                         #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(g_plant_new,'apc_file'),    #FUN-A50102                                                                           
                         " WHERE apc01 = ?  AND apc02=? "                                                                             
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                           
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql              #FUN-A50102
             PREPARE t310_p4_2 FROM g_sql                                                                                           
             DECLARE t310_c4_2 CURSOR FOR t310_p4_2                                                                                 
             OPEN t310_c4_2 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                               
             FETCH t310_c4_2 INTO g_qty1,g_qty2,g_qty3,g_qty4                                                                       
            #考慮付款未確認部分                                                                                                     
             LET g_sql = "SELECT SUM(apg05f)",                                                                                      
                       # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",     #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",#FUN-A50102
                                   cl_get_target_table(g_plant_new,'apf_file'),    #FUN-A50102                                                     
                         " WHERE apg04 = ? AND apg06 = ? ",                                                                         
                         "   AND apg01 <> '",g_apf.apf01,"'",                                                                       
                         "   AND apg01 = apf01 AND apf41='N'"                                                                       
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                           
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102
             PREPARE t310_p5_2 FROM g_sql                                                                                           
             DECLARE t310_c5_2 CURSOR FOR t310_p5_2                                                                                 
             OPEN t310_c5_2 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                               
             FETCH t310_c5_2 INTO g_qty5                                                                                            
             IF cl_null(g_qty5) THEN LET g_qty5=0 END IF                                                                            
             IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF                                                                               
             LET g_qty4=g_qty4 - g_qty5                                                                                             
             IF g_apg[l_ac].apg05f > g_qty4 THEN        
                CALL cl_err('','aap-069',1)                                                                                         
                NEXT FIELD apg05f                                                                                                   
                LET INT_FLAG = 0                                                                                                    
                ROLLBACK WORK                                                                                                       
                EXIT INPUT                                                                                                          
             END IF                                                                                                                 
             IF g_apz.apz27 = 'N' THEN                                                                                              
                LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc09-apc11",                                                           
                          # "  FROM ",g_dbs_new,"apa_file ,",                           #FUN-A50102 mark                                                                      
                          #           g_dbs_new,"apc_file  ",                           #FUN-A50102 mark                                                          
                            "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",  #FUN-A50102
                                      cl_get_target_table(g_plant_new,'apc_file'),      #FUN-A50102 
                            " WHERE apa01 = ? AND apc02=?  ",                                                                       
                            "   AND apa01=apc01  ",                                                                                  
                            "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
             ELSE                                                                                                                   
                LET g_sql = "SELECT apc09,apc11,apc16*apa14,apc13",                                                                 
                          # "  FROM ",g_dbs_new,"apa_file ,",                      #FUN-A50102 mark                                                                      
                          #           g_dbs_new,"apc_file  ",                      #FUN-A50102 mark
                            "  FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102
                            ",", cl_get_target_table(g_plant_new,'apc_file'),      #FUN-A50102                                                     
                            " WHERE apa01 = ? AND apc02=?  ",                                                                       
                            "   AND apa01=apc01  ",                                                                                  
                            "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
             END IF                                                                                                                 
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                           
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
             PREPARE t310_p6_2 FROM g_sql                                                                                           
             DECLARE t310_c6_2 CURSOR FOR t310_p6_2                                                                                 
             OPEN t310_c6_2 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                               
             FETCH t310_c6_2 INTO g_qty1,g_qty2,g_qty3,g_qty4   
             LET g_sql = "SELECT SUM(apg05)",                                                                                       
                       # "  FROM ",g_dbs_new,"apg_file,",g_dbs_new,"apf_file",          #FUN-A50102 mark
                         "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),",",     #FUN-A50102
                                   cl_get_target_table(g_plant_new,'apf_file'),         #FUN-A50102                                                     
                         " WHERE apg04 = ? AND apg06 = ? ",                                                                         
                         "   AND apg01 <> '",g_apf.apf01,"'",                                                                       
                         "   AND apg01 = apf01 AND apf41='N'"                                                                       
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                                                                           
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        #FUN-A50102
             PREPARE t310_p7_2 FROM g_sql                                                                                           
             DECLARE t310_c7_2 CURSOR FOR t310_p7_2                                                                                 
             OPEN t310_c7_2 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06                                                               
             FETCH t310_c7_2 INTO g_qty5                                                                                            
             IF cl_null(g_qty5) THEN LET g_qty5=0 END IF                                                                            
             IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF                                                                               
             LET g_qty4=g_qty4 - g_qty5                                                                                             
             IF g_apg[l_ac].apg05 > g_qty4 THEN                                                                                     
                CALL cl_err('','aap-069',1)                                                                                         
                NEXT FIELD apg05                                                                                                    
                LET INT_FLAG = 0                                                                                                    
                ROLLBACK WORK                                                                                                       
                EXIT INPUT                                                                                                          
             END IF                                                                                                                 
             UPDATE apg_file SET apg02 = g_apg[l_ac].apg02,
                                 apg04 = g_apg[l_ac].apg04,
                                 apg05f = g_apg[l_ac].apg05f,
                                 apg05 = g_apg[l_ac].apg05,
                                 apg06 = g_apg[l_ac].apg06,    #No.FUN-680027 add                              
                                apgud01 = g_apg[l_ac].apgud01,
                                apgud02 = g_apg[l_ac].apgud02,
                                apgud03 = g_apg[l_ac].apgud03,
                                apgud04 = g_apg[l_ac].apgud04,
                                apgud05 = g_apg[l_ac].apgud05,
                                apgud06 = g_apg[l_ac].apgud06,
                                apgud07 = g_apg[l_ac].apgud07,
                                apgud08 = g_apg[l_ac].apgud08,
                                apgud09 = g_apg[l_ac].apgud09,
                                apgud10 = g_apg[l_ac].apgud10,
                                apgud11 = g_apg[l_ac].apgud11,
                                apgud12 = g_apg[l_ac].apgud12,
                                apgud13 = g_apg[l_ac].apgud13,
                                apgud14 = g_apg[l_ac].apgud14,
                                apgud15 = g_apg[l_ac].apgud15
              WHERE apg01=g_apf.apf01 AND apg02=g_apg_t.apg02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","apg_file",g_apf.apf01,g_apg_t.apg02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_apg[l_ac].* = g_apg_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                    LET l_apf42 = '0'          #MOD-4A0299
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
    
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_apg[l_ac].* = g_apg_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_apg.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "account_detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE t310_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30032 add
          CLOSE t310_b2cl
          COMMIT WORK
          CALL t310_b1_tot()
 
       ON ACTION CONTROLP
          CASE
#No.FUN-CB0066 --begin
#             WHEN INFIELD(apg04)
#                LET g_qryparam.state = 'c' #FUN-980030
#                LET g_qryparam.plant = g_plant #FUN-980030.預設為g_plant
##No.FUN-A40003 --begin
#                IF g_aptype ='32' THEN 
#                   CALL q_m_apa(FALSE,TRUE,g_plant,g_apf.apf03,'*',    #FUN-990031
#                               #g_apf.apf06,'2*',g_apg[l_ac].apg04,g_apf.apf12)   #No.MOD-840409                 #MOD-A70102 mark
#                                g_apf.apf06,'2*',g_apg[l_ac].apg04,g_apf.apf12,g_apf.apf02)  #No.MOD-840409      #MOD-A70102
#                   RETURNING g_apg[l_ac].apg04,g_apg[l_ac].apg06 #No.FUN-680027 add
#                ELSE 
#                   CALL q_m_apa(FALSE,TRUE,g_plant,g_apf.apf03,'*',    #FUN-990031
#                               #g_apf.apf06,'1*',g_apg[l_ac].apg04,g_apf.apf12)   #No.MOD-840409                 #MOD-A70102 mark
#                                g_apf.apf06,'1*',g_apg[l_ac].apg04,g_apf.apf12,g_apf.apf02)  #No.MOD-840409      #MOD-A70102
#                   RETURNING g_apg[l_ac].apg04,g_apg[l_ac].apg06 #No.FUN-680027 add
#                END IF 
##No.FUN-A40003 --end
#                IF cl_null(g_apg[l_ac].apg04) THEN            #No.FUN-680027 add 
#                   LET g_apg[l_ac].apg06 = NULL               #No.FUN-680027 add
#                END IF                                        #No.FUN-680027 add 
#                DISPLAY g_apg[l_ac].apg04 TO apg04
#                DISPLAY g_apg[l_ac].apg06 TO apg06            #No.FUN-680027 add
             WHEN INFIELD(apg04)
                LET g_multi_apg04 = NULL 
                #IF g_aptype ='32' THEN                         #MOD-D90019
                IF g_aptype ='32' OR g_apf.apf47 = '2' THEN     #MOD-D90019
                	 LET l_type = '2*'
                ELSE 
                   LET l_type = '1*'
                END IF 
                CALL q_m_apa(FALSE,TRUE,g_plant,g_apf.apf03,'*',   
                             g_apf.apf06,l_type,g_apg[l_ac].apg04,g_apf.apf12,g_apf.apf02) 
                RETURNING g_multi_apg04

                IF NOT cl_null(g_multi_apg04)  THEN 
                   CALL t310_multi_apg04()      
                   IF g_success = 'N' THEN    
                      NEXT FIELD ohb04    
                   END IF                    
                   CALL t310_b_fill(" 1=1")
                   CALL t310_b() 
                   LET g_multi_wc = NULL              #No.TQC-D10069 
                   LET g_multi_apg04 = NULL           #No.TQC-D10069
                   EXIT INPUT                 
                END IF
#No.FUN-CB0066 --end
             OTHERWISE
                EXIT CASE
       END CASE
 
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(apg02) AND l_ac > 1 THEN
               LET g_apg[l_ac].* = g_apg[l_ac-1].*
               LET g_apg[l_ac].apg02 = NULL   #TQC-620018
               LET g_apg[l_ac].apg06 = NULL   #MOD-740413
               NEXT FIELD apg02
           END IF
 
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
#No.FUN-A60024 --begin
      AFTER INPUT 
        IF g_apf.apf10 != (g_apf.apf08+g_apf.apf09) THEN
           CALL t310_g_b2()
           CALL t310_b2()   #No.TQC-B30220
        END IF 
#No.FUN-A60024 --end
   END INPUT

   UPDATE apf_file SET apfmodu=g_apf.apfmodu,apf42=l_apf42,
                       apfdate=g_apf.apfdate
    WHERE apf01=g_apf.apf01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)
      LET g_success='N'
   END IF
   LET g_apf.apf42 = l_apf42
   DISPLAY BY NAME g_apf.apf42
   IF g_apf.apf41 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
 
   IF g_apf.apf10 != 0 AND g_apf.apf10 != (g_apf.apf08+g_apf.apf09) THEN     
      WHILE TRUE
         IF g_apf.apf10 < g_apf.apf08 THEN                 # 付不足
            CALL cl_getmsg('aap-070',g_lang) RETURNING g_msg 
         END IF
         IF g_apf.apf10 > (g_apf.apf08+g_apf.apf09) AND g_aptype <>'32' THEN   # 付超過  #No.FUN-A80111
            IF g_aptype = '34' THEN   #TQC-750139
              CALL cl_getmsg('aap-087',g_lang) RETURNING g_msg
            ELSE
              CALL cl_getmsg('aap-071',g_lang) RETURNING g_msg
            END IF
         END IF
#No.FUN-A80111 --begin
         IF g_apf.apf10 > g_apf.apf08 AND g_aptype ='32' THEN        # 付超過  
            CALL cl_getmsg('aap-147',g_lang) RETURNING g_msg            
         END IF
#No.FUN-A80111 --end
         WHILE TRUE
            LET g_chr=' '
            LET INT_FLAG = 0  ######add for prompt bug
            IF g_aptype ='36' THEN CALL cl_getmsg('aap-077',g_lang) RETURNING g_msg  END IF    #No.FUN-A60024
            PROMPT g_msg CLIPPED FOR CHAR g_chr
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
 
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
 
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            IF g_apf.apf10 < g_apf.apf08 AND g_chr='3' THEN
               CONTINUE WHILE
            END IF
#No.FUN-A80111 --begin
            IF g_apf.apf10 > g_apf.apf08 AND g_chr='3' THEN
               CALL t310_tmp_apf09()
               LET g_chr ='e'
               EXIT WHILE 
            END IF
#No.FUN-A80111 --end
            IF g_aptype = '34' THEN   #TQC-750139
              IF g_chr MATCHES "[12Ee]" THEN EXIT WHILE END IF
            ELSE
              IF g_chr MATCHES "[123Ee]" THEN EXIT WHILE END IF
            END IF
         END WHILE
         IF g_chr MATCHES '[Ee]' THEN LET l_exit_sw = 'y' EXIT WHILE END IF
         IF g_chr = '2' THEN LET l_exit_sw = 'n' EXIT WHILE END IF
         IF g_chr = '1' THEN
            LET l_n = ARR_COUNT()
            CALL t310_b2()
         END IF
         EXIT WHILE
      END WHILE
   END IF
   IF l_exit_sw = 'y' THEN
      EXIT WHILE
   ELSE
      CONTINUE WHILE
   END IF
   END WHILE
   CALL t310_b1_tot()
   IF g_add_entry<>'Y' THEN
      CALL t310_tmp_apf09()         # 轉溢付
   END IF
   LET g_add_entry='N'
   CLOSE t310_cl                    #MOD-C30618 add
   CLOSE t310_b2cl
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t310_b1_tot()
   DEFINE l_apf10       LIKE apf_file.apf10     #MOD-A90078
   DEFINE l_apf10f      LIKE apf_file.apf10f    #MOD-A90078
   DEFINE l_cnt         LIKE type_file.num5     #FUN-B40011

   SELECT SUM(apg05f),SUM(apg05) INTO g_apf.apf08f,g_apf.apf08 FROM apg_file
    WHERE apg01=g_apf.apf01
   IF g_apf.apf08f IS NULL THEN LET g_apf.apf08f=0 END IF
   IF g_apf.apf08  IS NULL THEN LET g_apf.apf08 =0 END IF
#--Begin-- FUN-B40011  mark
#   DISPLAY BY NAME g_apf.apf08f,g_apf.apf08
#  #-MOD-A90078-add-
#   IF g_aptype <> '36' THEN   #No.FUN-A90007 
#      SELECT apf10f,apf10 INTO l_apf10f,l_apf10
#        FROM apf_file WHERE apf01 = g_apf.apf01
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","sel apf10",1) 
#         LET g_success = 'N'
#      END IF
#      IF cl_null(l_apf10f) THEN LET l_apf10f = 0 END IF
#      IF cl_null(l_apf10)  THEN LET l_apf10  = 0 END IF
#      LET g_apf.apf09f= l_apf10f - g_apf.apf08f 
#      LET g_apf.apf09 = l_apf10 -  g_apf.apf08 
#      DISPLAY BY NAME g_apf.apf09f,g_apf.apf09
#   END IF          #No.FUN-A90007 
#  #-MOD-A90078-end-

#   UPDATE apf_file SET apf08f=g_apf.apf08f,
#                       apf08 =g_apf.apf08,
#                       apf09f=g_apf.apf09f,   #MOD-A90078
#                       apf09 =g_apf.apf09     #MOD-A90078
#    WHERE apf01=g_apf.apf01
#--End-- FUN-B40011     mark
    
#--Begin-- FUN-B40011
   LET l_cnt = 0
   SELECT count(aph13) INTO l_cnt FROM aph_file
    WHERE aph01=g_apf.apf01
      AND aph13 <> g_apf.apf06
      AND aph05f <> 0             #MOD-BB0305
   IF l_cnt > 0 THEN
      DISPLAY BY NAME g_apf.apf08
      IF g_aptype <> '36' THEN
         SELECT apf10 INTO l_apf10
           FROM apf_file WHERE apf01 = g_apf.apf01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","sel apf10",1) 
            LET g_success = 'N'
         END IF
         IF cl_null(l_apf10)  THEN LET l_apf10  = 0 END IF
         LET g_apf.apf09 = l_apf10 -  g_apf.apf08       
        #DISPLAY BY NAME g_apf.apf09                #MOD-C50109 mark
      END IF
     #No.TQC-B80079 --begin
      LET g_apf.apf09f =0
      LET g_apf.apf10f =0 
    #------------------------MOD-C50109---------------mark
    # DISPLAY BY NAME g_apf.apf09f 
    # DISPLAY BY NAME g_apf.apf10f
    ##No.TQC-B80079 --end  
    # UPDATE apf_file SET apf08 =g_apf.apf08,
    #                     apf09 =g_apf.apf09,
    #                    #No.TQC-B80079 --begin
    #                     apf10f = g_apf.apf10f,
    #                     apf09f = g_apf.apf09f
    #                    #No.TQC-B80079 --end  
    #  WHERE apf01=g_apf.apf01
    #------------------------MOD-C50109---------------mark
   ELSE
      DISPLAY BY NAME g_apf.apf08f,g_apf.apf08
      #IF g_aptype <> '36' THEN  #MOD-B90204 mark
         SELECT apf10f,apf10 INTO l_apf10f,l_apf10
           FROM apf_file WHERE apf01 = g_apf.apf01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","sel apf10",1) 
            LET g_success = 'N'
         END IF
         IF cl_null(l_apf10f) THEN LET l_apf10f = 0 END IF
         IF cl_null(l_apf10)  THEN LET l_apf10  = 0 END IF
         LET g_apf.apf09f = l_apf10f - g_apf.apf08f 
         LET g_apf.apf09 = l_apf10 -  g_apf.apf08 
        #------------------------MOD-C50109---------------mark
        #DISPLAY BY NAME g_apf.apf09f,g_apf.apf09
        #UPDATE apf_file SET apf08f=g_apf.apf08f,
        #                    apf08 =g_apf.apf08,
        #                    apf09f=g_apf.apf09f,
        #                    apf09 =g_apf.apf09
        # WHERE apf01=g_apf.apf01
        #------------------------MOD-C50109---------------mark
      END IF
   #END IF  #MOD-B90204 mark
#--End-- FUN-B40011
  #------------------------------------------MOD-C50109-------------------------------(S)
    IF g_aptype = '36' THEN
       LET g_apf.apf09 = 0
       LET g_apf.apf09f = 0
    END IF
    DISPLAY BY NAME g_apf.apf08,g_apf.apf08f
    DISPLAY BY NAME g_apf.apf09,g_apf.apf09f
    DISPLAY BY NAME g_apf.apf10f
    UPDATE apf_file SET apf08 = g_apf.apf08,
                        apf09 = g_apf.apf09,
                        apf08f = g_apf.apf08f,
                        apf09f = g_apf.apf09f,
                        apf10f = g_apf.apf10f
     WHERE apf01 = g_apf.apf01
  #------------------------------------------MOD-C50109-------------------------------(E)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t310_b2_tot()
   DEFINE l_cnt         LIKE type_file.num5       #CHI-A10034 add
   DEFINE l_apf08       LIKE apf_file.apf08       #MOD-A90078
   DEFINE l_apf08f      LIKE apf_file.apf08f      #MOD-A90078
   DEFINE l_aph14       LIKE aph_file.aph14       #MOD-B10116

  #-MOD-A90078-add-
   SELECT apf08f,apf08 INTO l_apf08f,l_apf08
     FROM apf_file WHERE apf01 = g_apf.apf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","sel apf08",1) 
      LET g_success = 'N'
   END IF
   IF cl_null(l_apf08f) THEN LET l_apf08f = 0 END IF
   IF cl_null(l_apf08)  THEN LET l_apf08  = 0 END IF
  #-MOD-A90078-end-

  #CHI-A10034---add---start---
   LET l_cnt = 0
   SELECT count(aph13) INTO l_cnt FROM aph_file
    WHERE aph01=g_apf.apf01
      AND aph13 <> g_apf.apf06
      AND aph05f <> 0             #MOD-BB0305
   IF l_cnt > 0 THEN
      SELECT SUM(aph05) INTO g_apf.apf10 FROM aph_file
       WHERE aph01=g_apf.apf01
      IF g_apf.apf10  IS NULL THEN LET g_apf.apf10 =0 END IF
     #DISPLAY BY NAME g_apf.apf10                       #MOD-C50109 mark
      IF g_aptype <> '36' THEN    #No.FUN-A90007
         LET g_apf.apf09 = g_apf.apf10 -  l_apf08       #MOD-A90078
        #DISPLAY BY NAME g_apf.apf10                       #MOD-C50109 mark
      END IF        #No.FUN-A90007
     #No.TQC-B80079 --begin
      LET g_apf.apf09f =0
      LET g_apf.apf10f =0 
     #------------------------MOD-C50109---------------mark
     #DISPLAY BY NAME g_apf.apf09f 
     #DISPLAY BY NAME g_apf.apf10f 
     #No.TQC-B80079 --end 
     #UPDATE apf_file SET apf10=g_apf.apf10,
     #                    apf09=g_apf.apf09,          #MOD-A90078 
     #                   #No.TQC-B80079 --begin
     #                    apf10f = g_apf.apf10f,
     #                    apf09f = g_apf.apf09f
     #                   #No.TQC-B80079 --end  
     # WHERE apf01=g_apf.apf01
     #------------------------MOD-C50109---------------mark
   ELSE
  #CHI-A10034---add---end---
      SELECT SUM(aph05f),SUM(aph05) INTO g_apf.apf10f,g_apf.apf10 FROM aph_file
       WHERE aph01=g_apf.apf01
      IF g_apf.apf10f IS NULL THEN LET g_apf.apf10f=0 END IF
      IF g_apf.apf10  IS NULL THEN LET g_apf.apf10 =0 END IF
     #DISPLAY BY NAME g_apf.apf10f,g_apf.apf10          #MOD-C50109 mark
      IF g_aptype <> '36' THEN    #No.FUN-A90007
         LET g_apf.apf09f= g_apf.apf10f - l_apf08f      #MOD-A90078 
         LET g_apf.apf09 = g_apf.apf10 -  l_apf08       #No.MOD-B40011
        #-MOD-B10116-add-
        #IF g_apf.apf09f > 0 AND (g_apf.apf10 - l_apf08) < 0 THEN #TQC-B10199 mark 
         IF g_apf.apf09f > 0 THEN                                 #TQC-B10199
            LET g_sql = "SELECT aph14 ",
                        "  FROM aph_file ",
                        " WHERE aph01 = '",g_apf.apf01,"'",
                        "   AND aph13 = '",g_apf.apf06,"'"
            PREPARE t310_aph14tp FROM g_sql
            DECLARE t310_aph14tc SCROLL CURSOR WITH HOLD FOR t310_aph14tp
            OPEN t310_aph14tc    
            FETCH FIRST t310_aph14tc INTO l_aph14
            IF l_aph14 <> 1 THEN     #TQC-B10199 
              LET g_apf.apf09 = g_apf.apf09f * l_aph14
           #-TQC-B10199-add-
            ELSE 
              LET g_apf.apf09 = g_apf.apf10 -  l_apf08      
            END IF
           #-TQC-B10199-end-
            CALL cl_digcut(g_apf.apf09,g_azi04) RETURNING g_apf.apf09 
        #ELSE  #TQC-B10199 mark
        #-MOD-B10116-end-
           LET g_apf.apf09 = g_apf.apf10 -  l_apf08       #MOD-A90078 #TQC-B10199 mark #TQC-B70129 remark
         END IF    #MOD-B10116 
        #DISPLAY BY NAME g_apf.apf09f,g_apf.apf09       #MOD-A90078     #MOD-C50109 mark
      END IF        #No.FUN-A90007
     #-------------------------------MOD-C50109--------------------mark
     #UPDATE apf_file SET apf10f=g_apf.apf10f,
     #                       apf10 =g_apf.apf10,
     #                       apf09f=g_apf.apf09f,       #MOD-A90078
     #                       apf09 =g_apf.apf09         #MOD-A90078
     # WHERE apf01=g_apf.apf01
     #-------------------------------MOD-C50109--------------------mark
   END IF          #CHI-A10034 add
  #----------------------------------MOD-C50109-------------------(S)
   DISPLAY BY NAME g_apf.apf09,g_apf.apf09f
   DISPLAY BY NAME g_apf.apf10,g_apf.apf10f
   UPDATE apf_file SET apf09  = g_apf.apf09,
                       apf09f = g_apf.apf09f,
                       apf10  = g_apf.apf10,
                       apf10f = g_apf.apf10f
    WHERE apf01=g_apf.apf01
  #----------------------------------MOD-C50109-------------------(E)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t310_apg04(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_apa00         LIKE apa_file.apa00
   DEFINE l_apa06         LIKE apa_file.apa06
   DEFINE l_apa07         LIKE apa_file.apa07
   DEFINE l_apa08         LIKE apa_file.apa08
   DEFINE l_apa13         LIKE apa_file.apa13
   DEFINE l_apa14         LIKE apa_file.apa14
   DEFINE l_apa20         LIKE apa_file.apa20
   DEFINE l_apc16         LIKE apc_file.apc16  #No.FUN-680027 add
   DEFINE l_apa21         LIKE apa_file.apa21
   DEFINE l_apa22         LIKE apa_file.apa22
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_apa42         LIKE apa_file.apa42
   DEFINE l_apa34         LIKE apa_file.apa34
   DEFINE l_apa34f        LIKE apa_file.apa34f
   DEFINE l_apc08         LIKE apc_file.apc08  #No.FUN-680027 add
   DEFINE l_apc09         LIKE apc_file.apc09  #No.FUN-680027 add
   DEFINE l_apa35         LIKE apa_file.apa35
   DEFINE l_apa35f        LIKE apa_file.apa35f
   DEFINE l_apc10         LIKE apc_file.apc10  #No.FUN-680027 add
   DEFINE l_apc11         LIKE apc_file.apc11  #No.FUN-680027 add
   DEFINE l_apa73         LIKE apa_file.apa73  #No.MOD-590440
   DEFINE l_apc13         LIKE apc_file.apc13  #No.FUN-680027 add
   DEFINE l_apg05f        LIKE apg_file.apg05f
   DEFINE l_apg05         LIKE apg_file.apg05
   DEFINE l_apa72         LIKE apa_file.apa72
   DEFINE l_aba19         LIKE aba_file.aba19
   DEFINE l_apa44         LIKE apa_file.apa44
   DEFINE g_t1            LIKE oay_file.oayslip   #MOD-580041  #No.FUN-690028 VARCHAR(5)
   DEFINE l_apydmy3       LIKE apy_file.apydmy3   #MOD-580041
   DEFINE l_npp07         LIKE npp_file.npp07     #MOD-CC0286 add
 
   LET g_errno = ' '
   IF g_apz.apz27 = 'N' THEN
      LET g_sql = "SELECT apa02,apa13,apa14,apc08-apc10-apc16-apc14,apc09-apc11-apc16*apa14-apc15,", #MOD-B70047 add apc14/apc15
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",   
                # "  FROM ",g_dbs_new,"apa_file, ",                            #FUN-A50102 mark
                #           g_dbs_new,"apc_file  ",                            #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",   #FUN-A50102
                            cl_get_target_table(g_plant_new,'apc_file'),       #FUN-A50102
                  "  WHERE apa01 = ? AND apc02=? ", 
                  "    AND apa01=apc01 ",
#                  "    AND apa00[1,1] = '1'",                         #No.FUN-A40003
                  "    AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
              
   ELSE
      #LET g_sql = "SELECT apa02,apa13,apa72,apc08-apc10-apc16-apc14,apc13-apc16*apa72-apc15,",  #No.TQC-780034 #MOD-B70047 add apc14/apc15  #MOD-B90084 mark
      LET g_sql = "SELECT apa02,apa13,apa72,apc08-apc10-apc16-apc14,apc13-apc16*apa72,",  #MOD-B90084 
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",  
                # "  FROM ",g_dbs_new,"apa_file, ",                           #FUN-A50102 mark
                #           g_dbs_new,"apc_file  ",                           #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",  #FUN-A50102
                            cl_get_target_table(g_plant_new,'apc_file'),      #FUN-A50102   
                  "  WHERE apa01 = ? AND apc02=? ",
                  "    AND apa01=apc01 ",
#                  "    AND apa00[1,1] = '1'",                         #No.FUN-A40003
                  "    AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
   END IF
 
#No.FUN-A40003 --begin
   IF g_aptype = '32' THEN 
      LET g_sql = g_sql CLIPPED,"   AND apa00[1,1] = '2'"
   ELSE 
      IF g_apf.apf47 = '2' THEN #FUN-C90027 xuxz
         LET g_sql = g_sql CLIPPED,"   AND apa00[1,1] = '2' AND apa00 != '26' "#FUN-C90027 
      ELSE #FUN-C90027 
         LET g_sql = g_sql CLIPPED,"   AND apa00[1,1] = '1' AND apa00 !='16' "#FUN-C90027 add apa00 !='16'
      END IF #FUN-C90027 add
   END IF 
#No.FUN-A40003 --end 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql       #FUN-A50102
   PREPARE t310_p3 FROM g_sql DECLARE t310_c3 CURSOR FOR t310_p3
   OPEN t310_c3 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06      #No.FUN-680027 add
   FETCH t310_c3 INTO g_apg[l_ac].apa02,g_apg[l_ac].apa13,g_apg[l_ac].apa14,
                      l_amtf,l_amt,l_apa06,l_apa07,l_apa21,l_apa22,l_apa13,
                      l_apa00,l_apa41,l_apa42,l_apa08,l_apa44
   DISPLAY BY NAME g_apg[l_ac].apa02
   DISPLAY BY NAME g_apg[l_ac].apa14
   
   
   IF p_cmd = 'd' THEN RETURN END IF
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-072'
      WHEN l_apa41  = 'N'         LET g_errno = 'aap-141'
      WHEN l_apa42  = 'Y'         LET g_errno = 'aap-165'
      WHEN l_apa08  = 'UNAP'      LET g_errno = 'aap-015' #No.+118 010515
      WHEN l_apa06 != g_apf.apf03 LET g_errno = 'aap-040'
      WHEN l_apa07 != g_apf.apf12 LET g_errno = 'aap-155'
      WHEN l_apa13 != g_apf.apf06 LET g_errno = 'aap-041'
      WHEN g_aptype = '31' AND l_apa00 != '14' AND l_apa00 != '15'
                                  LET g_errno = 'aap-065'
      WHEN l_amtf<=0 AND l_amt<=0 LET g_errno = 'aap-076'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_apz.apz06 = 'N' THEN
      LET g_t1 = s_get_doc_no(g_apg[l_ac].apg04)
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=g_t1
      IF l_apydmy3 = 'Y' AND cl_null(l_apa44) THEN
         LET g_errno='aap-109'
      END IF
   END IF
   IF NOT cl_null(l_apa44) AND g_apz.apz05 = 'N' THEN
     #---------------------MOD-CC0286-------------(S)
      SELECT npp07 INTO l_npp07 FROM npp_file
       WHERE npp01 = g_apg[l_ac].apg04
         AND npptype = '0'
         AND nppsys = 'AP'
     #---------------------MOD-CC0286-------------(E)
      LET g_plant_new = g_apz.apz02p
      CALL s_getdbs()
      LET g_sql = "SELECT aba19 ",
                # "  FROM ",g_dbs_new,"aba_file",                         #FUN-A50102 mark
                  "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                  "  WHERE aba01 = ? AND aba00 = ? "
 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t310_p3x FROM g_sql DECLARE t310_c3x CURSOR FOR t310_p3x
     #OPEN t310_c3x USING l_apa44,g_apz.apz02b                               #MOD-CC0286 mark
      OPEN t310_c3x USING l_apa44,l_npp07                                    #MOD-CC0286 add
      FETCH t310_c3x INTO l_aba19
      IF cl_null(l_aba19) THEN LET l_aba19 = 'N' END IF
      IF l_aba19 = 'N' THEN LET g_errno = 'aap-110' END IF
   END IF
   LET g_sql = " SELECT apa20,apc08,apc10+apc14,apc09,apc11+apc15,apa14,apa72,apc13 ",   #No.FUN-680027 add #MOD-B70047 add apc14/acp15
             # "   FROM ",g_dbs_new CLIPPED,"apa_file ,",                      #FUN-A50102 mark
             #            g_dbs_new CLIPPED,"apc_file  ",                      #FUN-A50102 mark
               "   FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",     #FUN-A50102
                          cl_get_target_table(g_plant_new,'apc_file'),         #FUN-A50102
               "  WHERE apa01= ? ",
               "    AND apc02= ? AND apa01= apc01 ", #No.FUN-680027 add
#               "    AND apa00[1,1] = '1'",                                    #No.FUN-A40003
               "    AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add

#No.FUN-A40003 --begin
   IF g_aptype = '32' THEN 
      LET g_sql = g_sql CLIPPED,"   AND apa00[1,1] = '2'"
   ELSE 
      LET g_sql = g_sql CLIPPED,"   AND apa00[1,1] = '1'"
   END IF 
#No.FUN-A40003 --end
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102 
   PREPARE t310_str1 FROM g_sql
   DECLARE t310_z1 CURSOR FOR t310_str1
   OPEN t310_z1 USING g_apg[l_ac].apg04,g_apg[l_ac].apg06  #No.FUN-680027 add apc06
   FETCH t310_z1 INTO l_apc16,l_apc08 ,l_apc10 ,l_apc09,l_apc11,l_apa14,l_apa72,l_apc13   #NO.FUN-680027 add
   CLOSE t310_z1
 
   SELECT SUM(apg05f),SUM(apg05) INTO l_apg05f,l_apg05
     FROM apg_file,apf_file
    WHERE apg04=g_apg[l_ac].apg04
      AND apg06=g_apg[l_ac].apg06  #No.FUN-680027 add
      AND apg01<>g_apf.apf01
      AND apg01=apf01 AND apf41='N'
   IF cl_null(l_apg05f) THEN LET l_apg05f = 0 END IF
   IF cl_null(l_apg05) THEN LET l_apg05 = 0 END IF
   IF g_apz.apz27 = 'N' THEN
      IF (l_apc08 -l_apc10 -l_apc16-l_apg05f) > l_amtf OR         #No.FUN-680027 add 
         (l_apc09-l_apc11-(l_apc16*l_apa14)-l_apg05) > l_amt THEN #No.FUN-680027 add 
         LET g_errno='aap-250'
      END IF
   ELSE
      IF (l_apc08 -l_apc10 -l_apc16-l_apg05f) > l_amtf OR #No.FUN-680027 add
         (l_apc13-(l_apc16*l_apa72)-l_apg05) > l_amt THEN #No.FUN-680027 add 
         LET g_errno='aap-250'
      END IF
   END IF
   IF l_amt = 0 THEN LET g_errno = 'aap-123' END IF   #TQC-BC0062
    IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_apg[l_ac].apg05f= l_amtf
   LET g_apg[l_ac].apg05 = l_amt
   IF g_apg[l_ac].apa13 != g_aza.aza17 THEN
      LET g_apg[l_ac].apg05 = l_amt - l_apg05  #TQC-780065
      CALL cl_digcut(g_apg[l_ac].apg05,g_azi04) RETURNING g_apg[l_ac].apg05   #No.CHI-6A0004
      LET g_apg[l_ac].apg05f = l_amtf - l_apg05f   #TQC-780065
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_apg[l_ac].apa13   #TQC-780065
      LET g_apg[l_ac].apg05f = cl_digcut(g_apg[l_ac].apg05f,t_azi04)   #TQC-780065
      DISPLAY BY NAME g_apg[l_ac].apg05
      DISPLAY BY NAME g_apg[l_ac].apg05f
   END IF
END FUNCTION
 
FUNCTION t310_b2()
DEFINE p_cmd           LIKE type_file.chr1,   #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690028 SMALLINT
       l_apa01         LIKE apa_file.apa01,   #TQC-B10199
       l_apa41         LIKE apa_file.apa41,   #FUN-660117
       l_apa42         LIKE apa_file.apa42,   #FUN-660117
       l_apa13         LIKE apa_file.apa13,
       l_apa14         LIKE apa_file.apa14,
       l_apa08         LIKE apa_file.apa08,
       l_cnt           LIKE type_file.num5,   #No.FUN-690028 SMALLINT
       l_cnt2          LIKE type_file.num5,   #TQC-B10199
       l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
       l_aptype        LIKE apa_file.apa00,   #No.FUN-690028 VARCHAR(2),               #
       l_type          LIKE apa_file.apa00,   #FUN-660117
       l_t1            LIKE type_file.chr5,   #No.FUN-690028 VARCHAR(03),     #No.MOD-6B0141
       l_apydmy3       LIKE apy_file.apydmy3,
       l_apf42         LIKE apf_file.apf42,   #MOD-4A0299
       l_amt3          LIKE apa_file.apa72,
       l_apa20         LIKE apa_file.apa20,
       l_apc16         LIKE apc_file.apc16,   #No.FUN-680027 add
       l_apa72         LIKE apa_file.apa72,
       l_aph05         LIKE aph_file.aph05,
       l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,   #可刪除否  #No.FUN-690028 SMALLINT
       l_aph07         LIKE aph_file.aph07,   #TQC-5C0108
       l_w             LIKE type_file.num5,   # No.FUN-690028 SMALLINT,       #TQC-5C0108
       l_nma28         LIKE nma_file.nma28,   #TQC-5B0021
       l_apa58         LIKE apa_file.apa58,   #MOD-880203 add
       l_sum_aph05f    LIKE aph_file.aph05f,  #MOD-8B0176 add
       l_sum_aph05     LIKE aph_file.aph05,   #MOD-8B0176 add
       l_apc08         LIKE apc_file.apc08,   #MOD-8B0176 add
       l_apc09         LIKE apc_file.apc09,   #MOD-8B0176 add
       l_apc13         LIKE apc_file.apc13,   #MOD-980010 add
       l_aag05         LIKE aag_file.aag05,   #FUN-8C0106 add
       l_aag05_1       LIKE aag_file.aag05,    #FUN-8C0106 add
      #l_nmh17         LIKE nmh_file.nmh17    #FUN-B40011 add   #No.TQC-C30121   Mark
       l_nmh02         LIKE nmh_file.nmh02    #No.TQC-C30121  Add
#FUN-A20010 --Begin
DEFINE l_pmf11         LIKE pmf_file.pmf11
DEFINE l_pmf14         LIKE pmf_file.pmf14
DEFINE l_pmf15         LIKE pmf_file.pmf15
#FUN-A20010 --End
#No.FUN-A90007 --begin
DEFINE li_result       LIKE type_file.num5  
DEFINE l_apr02         LIKE apr_file.apr02
DEFINE l_apracti       LIKE apr_file.apracti
DEFINE l_pmc03   LIKE pmc_file.pmc03
DEFINE l_pmc04   LIKE pmc_file.pmc04
DEFINE l_pmc05   LIKE pmc_file.pmc05
DEFINE l_pmcacti LIKE pmc_file.pmcacti
DEFINE l_pmc24   LIKE pmc_file.pmc24
#No.FUN-A90007 --end 
#No.FUN-B40011 --begin
DEFINE l_aph05f  LIKE aph_file.aph05f
DEFINE l_aph14   LIKE aph_file.aph14 
DEFINE l_aph13   LIKE aph_file.aph13 
DEFINE l_aph04   LIKE aph_file.aph04 
DEFINE l_aph04_o LIKE aph_file.aph04
#No.FUN-B40011 --end
#FUN-C90122--add--str--
DEFINE l_nmd08   LIKE nmd_file.nmd08,
       l_nmd10   LIKE nmd_file.nmd10,
       l_nmd30   LIKE nmd_file.nmd30,
       l_nmd04   LIKE nmd_file.nmd04,
       l_nmd55   LIKE nmd_file.nmd55,
       l_nmd21   LIKE nmd_file.nmd21,
       l_nmd19   LIKE nmd_file.nmd19
#FUN-C90122--add--end
DEFINE l_genacti  LIKE gen_file.genacti  #FUN-CB0065
DEFINE l_apa31f   LIKE apa_file.apa31f   #FUN-CB0065
DEFINE l_apa35f   LIKE apa_file.apa35f   #FUN-CB0065
DEFINE l_sme02   LIKE sme_file.sme02              #CHI-C10043
DEFINE l_n2      LIKE aeh_file.aeh11     #add by liyjf170330

 # add by zhangsba190808---s
 DEFINE l_nmp06    LIKE  nmp_file.nmp06
 DEFINE l_nmp09    LIKE  nmp_file.nmp09
 DEFINE l_yy       LIKE  type_file.num5
 DEFINE l_mm       LIKE  type_file.num5
 DEFINE l_d1       LIKE  nme_file.nme04
 DEFINE l_d2       LIKE  nme_file.nme08
 DEFINE l_c1       LIKE  nme_file.nme04
 DEFINE l_c2       LIKE  nme_file.nme08
 DEFINE l_e1       LIKE  abb_file.abb07f
 DEFINE l_e2       LIKE  abb_file.abb07
 DEFINE l_f1       LIKE  abb_file.abb07f
 DEFINE l_f2       LIKE  abb_file.abb07
 DEFINE l_g1       LIKE  aph_file.aph05f
 DEFINE l_g2       LIKE  aph_file.aph05
 # add by zhangsba190808---e
    LET g_action_choice = ""        #No.FUN-A60024
    IF s_aapshut(0) THEN RETURN END IF
    IF g_apf.apf01 IS NULL THEN RETURN END IF
    SELECT * INTO g_apf.* FROM apf_file
     WHERE apf01=g_apf.apf01
      LET l_apf42 = g_apf.apf42          #MOD-4A0299
    IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF #no.7277 #FUN-CB0054 mark
    IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF  #FUN-CB0054 add
    IF g_apf.apfacti ='N' THEN CALL cl_err(g_apf.apf01,'9027',0) RETURN END IF
     IF g_apf.apf42 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    IF g_apz.apz13 = 'Y' THEN
       SELECT * INTO g_aps.* FROM aps_file WHERE aps01=g_apf.apf05
    ELSE
       SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aph02,aph03,aph26,'',aph21,aph25,aph22,'',aph08,aph04,aph041,aph17,aph23,aph24,aph16,'',aph07,aph09,aph13,",   #MOD-590054   #TQC-5B0021  #No.FUN-680027 add  FUN-A90007 add aph21,'',aph22,''   aph23,aph24 #FUN-CB0065 add aph26,''
                       "       aph14,aph05f,aph05,aph18,aph19,aph20,",#FUN-A20010 add aph18/aph19/aph20
                       "       aphud01,aphud02,aphud03,aphud04,aphud05,", #''--->aph25 CHI-CA0054 add
                       "       aphud06,aphud07,aphud08,aphud09,aphud10,",
                       "       aphud11,aphud12,aphud13,aphud14,aphud15", 
                       " FROM aph_file",
                       " WHERE aph01=? AND aph02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_apf.apfmodu=g_user
    LET g_apf.apfdate=g_today
    DISPLAY BY NAME g_apf.apfmodu,g_apf.apfdate
    CALL t310_b2_fill(g_wc3)                 #單身 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE
    LET l_exit_sw = 'y'
    INPUT ARRAY g_aph WITHOUT DEFAULTS FROM s_aph.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''                   #MOD-D60211 add
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET l_aph04_o =''              #FUN-B40011
#No.TQC-B30220 --Beign #去掉mark
#No.FUN-A90007 --begin
           CALL t310_set_entry_b(p_cmd)   #MOD-770123
           CALL t310_set_no_entry_b(p_cmd)   #MOD-770123
#No.FUN-A90007 --end
           CALL cl_set_comp_entry("aph26",FALSE) #FUN-CB0065 add
#No.TQC-B30220 --Beign #去掉mark
           BEGIN WORK
           LET g_success = 'Y'
           OPEN t310_cl USING g_apf.apf01
           IF STATUS THEN
              CALL cl_err("OPEN t310_cl.", STATUS, 1)
              CLOSE t310_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t310_cl INTO g_apf.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t310_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              #No.MOD-C60006  --Begin
              LET g_apf_t.apf08 = g_apf.apf08
              LET g_apf_t.apf09 = g_apf.apf09
              LET g_apf_t.apf10 = g_apf.apf10
              #No.MOD-C60006  --End
              LET g_aph_t.* = g_aph[l_ac].*  #BACKUP
              OPEN t310_bcl USING g_apf.apf01,g_aph_t.aph02
              IF STATUS THEN
                 CALL cl_err("OPEN t310_bcl.", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t310_bcl INTO g_aph[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aph_t.aph02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
#No.FUN-A90007 --begin
              #SELECT pmc03 INTO g_aph[l_ac].pmc03 FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21 #CHI-CA0054 mark
              ##CHI-CA0054 add beg------
              IF cl_null(g_aph[l_ac].aph25) THEN 
              	 SELECT pmc03 INTO g_aph[l_ac].aph25 FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21 #CHI-CA0054
              END IF 	
              ##CHI-CA0054 add end------              
              SELECT apr02 INTO g_aph[l_ac].apr02 FROM apr_file WHERE apr01 = g_aph[l_ac].aph22
              CALL t310_set_entry_b(p_cmd)   #MOD-770123
              CALL t310_set_no_entry_b(p_cmd)   #MOD-770123
#No.FUN-A90007 --end
              SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                 WHERE nmc01 = g_aph[l_ac].aph16
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              #FUN-C90044--add--str
              IF g_aptype = '32' OR g_aptype = '33' THEN
                 CALL cl_set_comp_entry('aph22',g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H')   #FUN-CB0117 add--aph03=H
                 IF g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H' THEN    #FUN-CB0117 add--aph03=H
                    IF g_aptype = '33' THEN
                       CALL cl_set_comp_entry('aph07,aph08,aph16',FALSE)
                    END IF
                    IF g_aptype = '32' THEN
                       CALL cl_set_comp_entry('aph17',FALSE)
                    END IF
                 ELSE
                    IF g_aptype = '32' THEN
                       CALL cl_set_comp_entry('aph04,aph17',TRUE)
                    END IF
                 END IF
                 IF g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H' THEN  #FUN-CB0117-add-H
                    IF g_aptype = '33' THEN
                       LET g_aph[l_ac].aph07 = ''
                       LET g_aph[l_ac].aph08 = ''
                       LET g_aph[l_ac].aph16 = ''
                    END IF
                    IF g_aptype = '32' THEN
                      #LET g_aph[l_ac].aph04 = ''
                       LET g_aph[l_ac].aph17 = ''
                    END IF
                 END IF
              END IF
             #FUN-C90044--add--end
             #FUN-CB0065--add--str--
             IF g_aptype = '33' AND g_aph[l_ac].aph03 = 'G' THEN
                CALL cl_set_comp_entry('aph26',TRUE)
                SELECT gen02 INTO g_aph[l_ac].aph26_desc FROM gen_file
                WHERE gen01=g_aph[l_ac].aph26
             END IF
             #FUN-CB0065--add--end
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aph[l_ac].* TO NULL
           LET g_aph[l_ac].aph09 = 'N'
           LET g_aph[l_ac].aph14  = 1
         #remod MOD-D20032 取消 FUN-C90027修改，移到下面
         #FUN-C90027--mod--str
           LET g_aph[l_ac].aph05f = 0
           LET g_aph[l_ac].aph05 = 0
         # SELECT SUM(apf08f-apf10f) INTO g_aph[l_ac].aph05f FROM apf_file
         #  WHERE apf01 = g_apf.apf01
         # SELECT SUM(apf08-apf10) INTO g_aph[l_ac].aph05 FROM apf_file
         #  WHERE apf01 = g_apf.apf01 
         # IF g_apf.apf47 = '2' AND g_aptype = '36' THEN 
         #    LET g_aph[l_ac].aph23 = g_apz.apz70
         # END IF 
         ##FUN-C90027--mod--end
         #End remod MOD-D20032
           LET g_aph_t.* = g_aph[l_ac].*         #新輸入資料
          #LET g_aph_o.aph08 = NULL              #MOD-A80076 #MOD-BC0242 mark
           LET g_aph_t.aph08 = NULL              #MOD-BC0242 add             

           #Add MOD-D20032 将FUN-C90027移下
           SELECT SUM(apf08f-apf10f) INTO g_aph[l_ac].aph05f FROM apf_file
            WHERE apf01 = g_apf.apf01
           SELECT SUM(apf08-apf10) INTO g_aph[l_ac].aph05 FROM apf_file
            WHERE apf01 = g_apf.apf01 
           IF g_apf.apf47 = '2' AND g_aptype = '36' THEN 
              LET g_aph[l_ac].aph23 = g_apz.apz70
           END IF 
           #End Add MOD-D20032

#No.FUN-A90007 --begin
           CALL t310_aph_def()
#No.FUN-A90007 --end           
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD aph02                      #No.MOD-510094
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_aph[l_ac].aph04 IS NULL AND g_aph[l_ac].aph05 = 0 THEN
              CALL g_aph.deleteElement(l_ac)
              NEXT FIELD aph02
              CANCEL INSERT
           END IF
#No.FUN-A90007 --begin
           IF g_aptype = '36' THEN      
              IF g_aph[l_ac].aph21 IS NULL  THEN
                 NEXT FIELD aph21
              END IF
              IF g_aph[l_ac].aph22 IS NULL  THEN
                 NEXT FIELD aph22
              END IF
              IF g_aph[l_ac].aph23 IS NULL  THEN
                 NEXT FIELD aph23
              END IF
              IF g_aph[l_ac].aph24 IS NULL  THEN
                 NEXT FIELD aph24
              END IF
           END IF
#No.FUN-A90007 --end
           INSERT INTO aph_file(aph01,aph02,aph03,aph08,aph18,aph19,aph20, #FUN-A20010 add aph18/19/20
                                aph04,aph041,aph17,aph07,aph09,   #TQC-5B0021  #No.FUN-680027 add aph041,aph17
                                aph13,aph14,aph05f,aph05,aph16,aph21,aph22,aph23,aph24,aph25,       #No.FUN-A90007 add aph21,aph22,aph23,aph24
                                aph26,      #FUN-CB0065 add
                                  aphud01,aphud02,aphud03, ##CHI-CA0054 add aph25
                                  aphud04,aphud05,aphud06,
                                  aphud07,aphud08,aphud09,
                                  aphud10,aphud11,aphud12,
                                  aphud13,aphud14,aphud15,aphlegal) #FUN-980001 add legal
            VALUES(g_apf.apf01,g_aph[l_ac].aph02,g_aph[l_ac].aph03,
                   g_aph[l_ac].aph08,g_aph[l_ac].aph18,g_aph[l_ac].aph19, #FUN-970077 add aph18/aph19
                   g_aph[l_ac].aph20,                                     #FUN-A20010 add aph20
                   g_aph[l_ac].aph04,g_aph[l_ac].aph041,g_aph[l_ac].aph17,     #No.FUN-680027 add aph041,aph17
                   g_aph[l_ac].aph07,   #TQC-5B0021
                   g_aph[l_ac].aph09,g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                   g_aph[l_ac].aph05f,g_aph[l_ac].aph05,g_aph[l_ac].aph16,   #MOD-590054
#No.FUN-A90007 --begin
                   g_aph[l_ac].aph21,
                   g_aph[l_ac].aph22,
                   g_aph[l_ac].aph23,
                   g_aph[l_ac].aph24,g_aph[l_ac].aph25, #CHI-CA0054 add aph25
#No.FUN-A90007 --end
                   g_aph[l_ac].aph26,  #FUN-CB0065 add                   
                                  g_aph[l_ac].aphud01,
                                  g_aph[l_ac].aphud02,
                                  g_aph[l_ac].aphud03,
                                  g_aph[l_ac].aphud04,
                                  g_aph[l_ac].aphud05,
                                  g_aph[l_ac].aphud06,
                                  g_aph[l_ac].aphud07,
                                  g_aph[l_ac].aphud08,
                                  g_aph[l_ac].aphud09,
                                  g_aph[l_ac].aphud10,
                                  g_aph[l_ac].aphud11,
                                  g_aph[l_ac].aphud12,
                                  g_aph[l_ac].aphud13,
                                  g_aph[l_ac].aphud14,
                                  g_aph[l_ac].aphud15,g_legal) #FUN-980001 add legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aph_file",g_apf.apf01,g_aph[l_ac].aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                  LET l_apf42 = '0'          #MOD-4A0299
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        BEFORE FIELD aph02                        #default 序號
           IF g_aph[l_ac].aph02 IS NULL OR g_aph[l_ac].aph02 = 0 THEN
              SELECT max(aph02)+1
                INTO g_aph[l_ac].aph02
                FROM aph_file
               WHERE aph01 = g_apf.apf01
              IF g_aph[l_ac].aph02 IS NULL THEN
                 LET g_aph[l_ac].aph02 = 1
              END IF
           END IF
 
        AFTER FIELD aph02                        #check 序號是否重複
           IF NOT cl_null(g_aph[l_ac].aph02) THEN
              IF g_aph[l_ac].aph02 != g_aph_t.aph02 OR g_aph_t.aph02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM aph_file
                  WHERE aph01 = g_apf.apf01
                    AND aph02 = g_aph[l_ac].aph02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aph[l_ac].aph02 = g_aph_t.aph02
                    NEXT FIELD aph02
                 END IF
              END IF
           END IF
 
        BEFORE FIELD aph03
            IF g_aph[l_ac].aph03 = '1' AND g_aph[l_ac].aph09='Y' THEN
               CALL cl_err('','aap-085',1) NEXT FIELD aph02
            END IF
            CALL t310_set_entry_b(p_cmd)               #No.FUN-510010
 
        AFTER FIELD aph03                  
        #FUN-DA0054 --- add --- begin “转账” “票据” “收票转让”转付”单据日期不可大于票据关帐日期
           IF g_aptype = '33' THEN
              IF g_aph[l_ac].aph03 = '2' OR g_aph[l_ac].aph03 = '1' OR g_aph[l_ac].aph03 = 'D' THEN
                 LET g_nmz10 = ''
                 SELECT nmz10 INTO g_nmz10 FROM nmz_file
                 #IF g_nmz10 > g_apf.apf02 THEN
                 IF g_nmz10 >= g_apf.apf02 THEN       #MOD-DB0017
                    CALL cl_err('','cxr-072',1)
                    NEXT FIELD aph03
                 END IF
              END IF
           END IF
         #FUN-DA0054 --- add --- end
            #FUN-C90044--add--str
           IF g_aptype = '32' OR g_aptype = '33' THEN
              IF g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H' THEN #FUN-CB0117 add-H
                 IF cl_null(g_aph[l_ac].aph22) THEN
                    LET g_aph[l_ac].aph22 = g_apz.apz66
                 END IF
              ELSE
                 LET g_aph[l_ac].aph22 = ''
              END IF
           END IF
           #FUN-C90044--add--end                                                                                                     
           IF g_aptype <> '32' THEN     #No.FUN-A$0003
              IF g_aph[l_ac].aph03 = '2'  THEN   
                 SELECT pmf14,pmf15,pmf11 INTO l_pmf14,l_pmf15,l_pmf11
                   FROM pmf_file
                  WHERE pmf01 = g_apf.apf03
                    AND pmf08 = g_apf.apf06
                    AND pmf05 = 'Y'
                    AND pmfacti = 'Y'
                 IF cl_null(g_aph[l_ac].aph18) THEN
                     LET g_aph[l_ac].aph18 = l_pmf14
                 END IF
                 IF cl_null(g_aph[l_ac].aph19) THEN
                     IF NOT cl_null(l_pmf15) THEN
                        LET g_aph[l_ac].aph19 = l_pmf15
                     ELSE
                        LET g_aph[l_ac].aph19 = '1'
                     END IF
                 END IF
                 IF cl_null(g_aph[l_ac].aph20) THEN
                     LET g_aph[l_ac].aph20 = l_pmf11
                 END IF
              ELSE
                 IF cl_null(g_aph[l_ac].aph19) THEN
                    LET g_aph[l_ac].aph19 = '3'
                 END IF
              END IF
           END IF                    #No.FUN-A40003 
           IF NOT cl_null(g_aph[l_ac].aph03) THEN
             #-CHI-CA0044-mark-
             #CASE WHEN g_aptype = '32'
             #  IF g_aph[l_ac].aph03 NOT MATCHES "[12E]" THEN                #No.FUN-A40003 #FUN-C90044--add-E
             #     CALL cl_err('','aap-078',0)
             #     NEXT FIELD aph03
             #  END IF
             #END CASE
             #-CHI-CA0044-end-
             #No.FUN-A40003 --begin
             #IF p_cmd='u' OR
             #  (p_cmd='a' AND (g_aph_o.aph03 IS NULL OR g_aph_o.aph03 != g_aph[l_ac].aph03)) THEN   #TQC-5B0021
            #No.MOD-BC0242 --begin
             #IF p_cmd='a' OR
             #  (p_cmd='u' AND (g_aph_o.aph03 != g_aph[l_ac].aph03)) THEN   #TQC-5B0021
             #No.FUN-A40003 --end
              IF p_cmd='a' OR
                (p_cmd='u' AND (g_aph_t.aph03 != g_aph[l_ac].aph03)) THEN   
            #No.MOD-BC0242 --end
             #No.FUN-A40003 --end
               #IF g_aptype <> '32' THEN              #No.FUN-A40003#FUN-C90027 mark
                IF (g_aptype <> '32' AND g_aptype !='36') OR (g_aptype = '36' AND g_apz.apz68 = 'Y') THEN#FUN-C90027 add
                   CASE WHEN g_aph[l_ac].aph03 = '1'   #TQC-5B0021   #MOD-640555
                             LET g_aph[l_ac].aph04 = g_aps.aps24   #TQC-5B0021   #MOD-640555
                             LET g_aph[l_ac].aph041= g_aps.aps241  #No.FUN-680029
                        WHEN g_aph[l_ac].aph03 = '3'
                             LET g_aph[l_ac].aph04 = g_aps.aps47
                             LET g_aph[l_ac].aph041= g_aps.aps471  #No.FUN-680029
                        WHEN g_aph[l_ac].aph03 = '4'
                             LET g_aph[l_ac].aph04 = g_aps.aps43
                             LET g_aph[l_ac].aph041= g_aps.aps431  #No.FUN-680029
                             LET g_aph[l_ac].aph13 = g_aza.aza17   #MOD-A80175
                        WHEN g_aph[l_ac].aph03 = '5'
                             LET g_aph[l_ac].aph04 = g_aps.aps42
                             LET g_aph[l_ac].aph041= g_aps.aps421  #No.FUN-680029
                             LET g_aph[l_ac].aph13 = g_aza.aza17   #MOD-A80175
                        WHEN g_aph[l_ac].aph03 = 'A'
                             LET g_aph[l_ac].aph04 = g_aps.aps46
                             LET g_aph[l_ac].aph041= g_aps.aps461  #No.FUN-680029
                        WHEN g_aph[l_ac].aph03 = 'B'
                             LET g_aph[l_ac].aph04 = g_aps.aps57
                             LET g_aph[l_ac].aph041= g_aps.aps571  #No.FUN-680029
                        WHEN g_aph[l_ac].aph03 = 'C'
                             LET g_aph[l_ac].aph04 = g_aps.aps58
                             LET g_aph[l_ac].aph041= g_aps.aps581  #No.FUN-680029
                        #---> TQC-C30294 add
                        WHEN g_aph[l_ac].aph03 = 'D'
                             LET g_aph[l_ac].aph04 = ''
                             LET g_aph[l_ac].aph041= ''
                        #---> TQC-C30294 add--end
                        WHEN g_aph[l_ac].aph03 = 'Z'
                             LET g_aph[l_ac].aph04 = g_aps.aps56
                             LET g_aph[l_ac].aph041= g_aps.aps561  #No.FUN-680029
                   END CASE
                END IF                                          #No.FUN-A40003
               #LET g_aph_o.aph03 = g_aph[l_ac].aph03   #TQC-5B0021 #MOD-BC0242 mark
               #LET g_aph_t.aph03 = g_aph[l_ac].aph03   #MOD-BC0242 add        #yinhy131015 mark
              ELSE
              #-MOD-A80076-mark-
              # IF l_ac != 1 THEN   #MOD-870108 add
              #    LET g_aph[l_ac].aph04 = g_aph[l_ac-1].aph04
              #    LET g_aph[l_ac].aph041= g_aph[l_ac-1].aph041
              #    LET g_aph_o.aph03 = g_aph[l_ac].aph03   #TQC-5B0021
              # END IF              #MOD-870108 add
              #-MOD-A80076-end-
              END IF
             #IF g_aptype <>'32' THEN     #No.FUN-A40003#FUN-C90027 mark
             #IF (g_aptype <> '32' AND g_aptype !='36') OR (g_aptype = '36' AND g_apz.apz68 = 'Y') THEN   #CHI-CA0044 mark  #FUN-C90027 add
              IF (g_aptype !='36') OR (g_aptype = '36' AND g_apz.apz68 = 'Y') THEN   #CHI-CA0044
                 #IF g_aph[l_ac].aph03 NOT MATCHES "[6789ABDFGZ]"  AND g_aph[l_ac].aph03 != g_aph_t.aph03 THEN      #FUN-B40011 add D #FUN-C90122 Add F #FUN-CB0065 add G
                 IF g_aph[l_ac].aph03 NOT MATCHES "[6789ABDFGZ]"  AND (g_aph[l_ac].aph03 != g_aph_t.aph03 OR  g_aph_t.aph03 IS NULL) THEN  #yinhy131015 
                    SELECT apw03 INTO g_aph[l_ac].aph04 FROM apw_file   #CHI-CA0054 add g_aph_t.aph03
                     WHERE apw01=g_aph[l_ac].aph03
                    IF g_aza.aza63 = 'Y' THEN
                       #SELECT apw03 INTO g_aph[l_ac].aph041 FROM apw_file  #TQC-B90205
                       SELECT apw031 INTO g_aph[l_ac].aph041 FROM apw_file  #TQC-B90205
                        WHERE apw01=g_aph[l_ac].aph03
                    END IF
                 END IF
              END IF         #No.FUN-A40003
              CALL t310_set_no_entry_b(p_cmd)              #No.FUN-510010
           END IF

           IF g_aza.aza63 = 'Y' AND g_aph[l_ac].aph03 NOT MATCHES "[6789FG]"  AND g_aptype <> '32' THEN #No.FUN-A40003 #FUN-C90122 Add F #FUN-CB0065 add G
              CALL cl_set_comp_visible("aph041",TRUE)
           ELSE
              CALL cl_set_comp_visible("aph041",FALSE)
           END IF
           #FUN-C90044--add--str
           IF g_aptype = '32' OR g_aptype = '33' THEN
              CALL cl_set_comp_entry('aph22',g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H') #FUN-CB0117 add--H
              IF g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H' THEN  #FUN-CB0117 add--H
                 IF g_aptype = '33' THEN
                    CALL cl_set_comp_entry('aph07,aph08,aph16',FALSE)
                 END IF
                 IF g_aptype = '32' THEN
                    CALL cl_set_comp_entry('aph17',FALSE)
                 END IF
              ELSE
                 IF g_aptype = '32' THEN
                    CALL cl_set_comp_entry('aph04,aph17',TRUE)
                 END IF
              END IF
              IF g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H' THEN #FUN-CB0117 add--H 
                 IF g_aptype = '33' THEN
                    LET g_aph[l_ac].aph07 = ''
                    LET g_aph[l_ac].aph08 = ''
                    LET g_aph[l_ac].aph16 = ''
                 END IF
                 IF g_aptype = '32' THEN
                 #  LET g_aph[l_ac].aph04 = ''
                    LET g_aph[l_ac].aph17 = ''
                 END IF
              END IF
           END IF
          #FUN-C90044--add--end
          #FUN-C90122--add--str--
          IF g_aptype='33' AND g_aph[l_ac].aph03='F' THEN
             CALL cl_set_comp_entry('aph08',FALSE)
          ELSE
             CALL cl_set_comp_entry('aph08',TRUE)
          END IF
          #FUN-C90122--add--end
          LET g_aph_t.aph03 = g_aph[l_ac].aph03   #NO.yinhy131015
      #FUN-CB0065--add--str--
           IF g_aptype='33' AND g_aph[l_ac].aph03='G' THEN
             CALL cl_set_comp_entry('aph26',TRUE)
             LET l_type='25'
          ELSE
             CALL cl_set_comp_entry('aph26',FALSE)   
          END IF
         #FUN-D80070--add--str--
         IF g_aptype='33' AND g_aph[l_ac].aph03 MATCHES '[6789DG]' THEN
            CALL cl_set_comp_entry('aph08',FALSE)
         ELSE
            CALL cl_set_comp_entry('aph08',TRUE)
         END IF
         #FUN-D80070--add--end

        AFTER FIELD aph26
           IF NOT cl_null(g_aph[l_ac].aph26) AND g_aptype='33' THEN
              IF cl_null(g_aph_t.aph26) OR g_aph[l_ac].aph26<>g_aph_t.aph26 THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM gen_file 
                 WHERE gen01=g_aph[l_ac].aph26
                 IF l_cnt=0 THEN
                    CALL cl_err('','aap-038',0)
                    NEXT FIELD aph26
                 END IF
                 SELECT genacti INTO l_genacti FROM gen_file
                 IF l_genacti<>'Y' THEN
                    CALL cl_err('','art-733',0)
                    NEXT FIELD aph26
                 END IF
                 SELECT COUNT(*) INTO l_cnt FROM apa_file 
                 WHERE apa41='Y' AND apa00='25' AND apa06=g_aph[l_ac].aph26 
                 IF l_cnt=0 THEN
                    CALL cl_err('','aap-179',0)
                    NEXT FIELD aph26
                 END IF
                 IF NOT cl_null(g_aph[l_ac].aph04) THEN
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM apa_file 
                    WHERE apa06=g_aph[l_ac].aph26 AND apa01=g_aph[l_ac].aph04
                    IF l_cnt=0 THEN
                       CALL cl_err('','aap-173',0)
                       NEXT FIELD aph26
                    END IF
                 END IF
                 SELECT gen02 INTO g_aph[l_ac].aph26_desc FROM gen_file
                 WHERE gen01=g_aph[l_ac].aph26
              END IF
           END IF
       #FUN-CB0065--add--end 
        BEFORE FIELD aph04
           #FUN-CB0065--add--str--
           IF g_aptype='33' AND g_aph[l_ac].aph03='G' THEN
              IF cl_null(g_aph[l_ac].aph26) THEN
                 CALL cl_err('','gpy-017',0)
                 NEXT FIELD aph26
               END IF
           END IF
           #FUN-CB0065--add--end
  
        AFTER FIELD aph04
            IF NOT cl_null(g_aph[l_ac].aph04) AND g_aptype <> '32' THEN   #No.FUN-A40003 add aptype
               IF g_aph_t.aph04 IS NULL OR g_aph[l_ac].aph04!=g_aph_t.aph04
                   OR g_aph[l_ac].aph03!=g_aph_t.aph03 THEN                   #No.MOD-530383
                   IF g_aph[l_ac].aph03 NOT MATCHES "[6789DFG]" THEN     #No.FUN-B40011  #FUN-C90122 add F #FUN-CB0065 add G
                      IF g_apz.apz02 = 'Y' THEN
                       CALL s_aapact('2',g_bookno1,g_aph[l_ac].aph04) RETURNING g_msg   #No.8727   #No.FUN-730064
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                          NEXT FIELD aph04
                       END IF
                      END IF
                   ELSE
                      #當aph03='6'待抵時,輸入的帳款不可是apa58='1'的資料
                      IF g_aph[l_ac].aph03='6' THEN
                         SELECT apa58 INTO l_apa58 FROM apa_file
                          WHERE apa00='21' AND apa01=g_aph[l_ac].aph04
                            AND apa02 <= g_apf.apf02          #MOD-A30146 add
                         IF l_apa58='1' THEN
                            CALL cl_err('','aap-296',1)
                            NEXT FIELD aph04
                         END IF
                      END IF
                      #FUN-C90122--add--str--
                      IF g_aptype='33' AND g_aph[l_ac].aph03='F' THEN
                         SELECT nmd08,nmd10,nmd30,nmd04,nmd55
                           INTO l_nmd08,l_nmd10,l_nmd30,l_nmd04,l_nmd55
                         FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                         IF SQLCA.sqlcode = 100 THEN
                            CALL cl_err('','axr-944',0)
                            NEXT FIELD aph04
                         END IF
                         IF l_nmd08<>g_apf.apf03 THEN
                            CALL cl_err('','aap-040',0)
                            NEXT FIELD aph04
                         END IF
                         IF l_nmd30<>'Y' THEN
                            CALL cl_err('','axr-194',0)
                            NEXT FIELD aph04
                         END IF
                         IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
                         IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
                         IF l_nmd04-l_nmd55<=0 THEN
                            CALL cl_err('','aap-268',0)
                            NEXT FIELD aph04
                         END IF
                         SELECT nmd03,nmd21,nmd19,nmd04-nmd55,nmd05
                         INTO g_aph[l_ac].aph08,g_aph[l_ac].aph13,
                              g_aph[l_ac].aph14,g_aph[l_ac].aph05f,
                              g_aph[l_ac].aph07
                         FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                         LET g_aph[l_ac].aph05=g_aph[l_ac].aph05f*g_aph[l_ac].aph14
                         LET g_aph_t.aph04=g_aph[l_ac].aph04
                         DISPLAY BY NAME g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                                         g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                                         g_aph[l_ac].aph07
                      END IF
                      #FUN-C90122--add--end
                      #FUN-CB0065--add--str--
                      IF g_aptype='33' AND g_aph[l_ac].aph03='G' THEN 
                         CALL t310_chk_aph04()
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err('',g_errno,0)
                            NEXT FIELD aph04
                         END IF
                         DISPLAY BY NAME g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                                         g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                                         g_aph[l_ac].aph07,g_aph[l_ac].aph22
                      END IF
                      #FUN-CB0065--add--end
                   END IF
                   DISPLAY BY NAME g_aph[l_ac].aph08
               END IF
 
              #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_aph[l_ac].aph04
                  AND aag00 = g_bookno1    
 
               LET g_errno = ' '    
              ###add by liyjf170330 str
               IF g_aph[l_ac].aph04 = '1001' OR g_aph[l_ac].aph04 LIKE '1002%' THEN
                 SELECT (aeh11-aeh12) INTO l_n2 FROM aeh_file WHERE  aeh00 = g_bookno1  AND aeh01 = g_aph[l_ac].aph04 AND aeh09 = YEAR(g_apf.apf02) and aeh10 = MONTH(g_apf.apf05)
                 IF l_n2 < 0 THEN 
                  CALL cl_err('','cap-100',0)
                  NEXT FIELD aph04
                 END IF 
               END IF 
              ###add by liyjf170330 end
               IF l_aag05 = 'Y' AND g_aph[l_ac].aph03 NOT MATCHES "[6789]"   
                  AND NOT cl_null(g_apf.apf05) THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_aph[l_ac].aph04,g_apf.apf05,g_bookno1)  
                                   RETURNING g_errno
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD aph04
                  END IF
               END IF
            END IF
#No.FUN-A40003 --begin
            IF NOT cl_null(g_aph[l_ac].aph04) AND g_aptype = '32'  AND g_aph[l_ac].aph03<>'E' THEN   #FUN-C90044 add aph03
               IF p_cmd ='a' OR (g_aph[l_ac].aph04!=g_aph_t.aph04 OR g_aph[l_ac].aph17!=g_aph_t.aph17) THEN 
                  CALL t310_aph04() 
                  RETURNING g_aph[l_ac].aph07,g_aph[l_ac].aph13,g_aph[l_ac].aph14,g_aph[l_ac].aph05f,g_aph[l_ac].aph05
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                     LET g_aph[l_ac].aph04 = g_aph_t.aph04
                     LET g_aph[l_ac].aph07 = g_aph_t.aph07
                     LET g_aph[l_ac].aph13 = g_aph_t.aph13
                     LET g_aph[l_ac].aph14 = g_aph_t.aph14
                     LET g_aph[l_ac].aph05f= g_aph_t.aph05f
                     LET g_aph[l_ac].aph05 = g_aph_t.aph05
                     NEXT FIELD aph04
                  END IF
               END IF 
               LET g_aph[l_ac].aph041 = g_aph[l_ac].aph04  #TQC-B80069 add
            END IF 
          #  LET g_aph[l_ac].aph041 = g_aph[l_ac].aph04  #TQC-B80069  mark
#No.FUN-A40003 --end            
#No.FUN-B40011 --begin
	    IF NOT cl_null(g_aph[l_ac].aph04) AND g_aph[l_ac].aph03='D' THEN
	        IF cl_null(l_aph04_o) THEN
	           LET l_aph04_o = g_aph_t.aph04
	        END IF
                CALL t310_aph04()
                RETURNING l_aph07,l_aph13,l_aph14,l_aph05f,l_aph05
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                   LET g_aph[l_ac].aph04 = g_aph_t.aph04
                   LET g_aph[l_ac].aph07 = g_aph_t.aph07
                   LET g_aph[l_ac].aph13 = g_aph_t.aph13
                   LET g_aph[l_ac].aph14 = g_aph_t.aph14
                   LET g_aph[l_ac].aph05f= g_aph_t.aph05f
                   LET g_aph[l_ac].aph05 = g_aph_t.aph05
                   NEXT FIELD aph04
                END IF
                IF g_aph[l_ac].aph04!=l_aph04_o OR l_aph04_o IS NULL THEN
                   LET g_aph[l_ac].aph07 = l_aph07
                   LET g_aph[l_ac].aph13 = l_aph13
                   LET g_aph[l_ac].aph14 = l_aph14
                   LET g_aph[l_ac].aph05f= l_aph05f
                   LET g_aph[l_ac].aph05 = l_aph05
                   LET l_aph04_o = g_aph[l_ac].aph04
                END IF
            END IF
#No.FUN-B40011 --end
            
 
        BEFORE FIELD aph041
 
        AFTER FIELD aph041
            IF NOT cl_null(g_aph[l_ac].aph041) THEN
               IF g_aph_t.aph041 IS NULL OR g_aph[l_ac].aph041!=g_aph_t.aph041
                   OR g_aph[l_ac].aph03!=g_aph_t.aph03 THEN                   #No.MOD-530383
                  IF g_apz.apz02 = 'Y' THEN
                     CALL s_aapact('2',g_bookno2,g_aph[l_ac].aph041) RETURNING g_msg   #No.8727    #No.FUN-730064
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aph[l_ac].aph041,g_errno,0)
                        NEXT FIELD aph041
                     END IF
                  END IF
               END IF
 
              #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
               IF g_aza.aza63='Y' THEN
                  LET l_aag05_1=''
                  SELECT aag05 INTO l_aag05_1 FROM aag_file
                   WHERE aag01 = g_aph[l_ac].aph041
                     AND aag00 = g_bookno2    
                  
                  LET g_errno = ' '   
                  IF l_aag05_1 = 'Y' AND g_aph[l_ac].aph03 NOT MATCHES "[6789G]"  #FUN-CB0065 add G 
                     AND NOT cl_null(g_apf.apf05) THEN
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                     IF g_aaz.aaz90 !='Y' THEN
                        CALL s_chkdept(g_aaz.aaz72,g_aph[l_ac].aph041,g_apf.apf05,g_bookno2)  
                                      RETURNING g_errno
                     END IF
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD aph041
                     END IF
                  END IF
               END IF
 
            END IF
 
 
        AFTER FIELD aph17
            IF NOT cl_null(g_aph[l_ac].aph17) AND g_aptype <> '32' THEN       #No.FUN-A40003
               IF g_aph[l_ac].aph03 MATCHES "[6789G]" THEN  #FUN-CB0065 add G 
                  CASE WHEN g_aph[l_ac].aph03 = '6' LET l_type = '21'
                       WHEN g_aph[l_ac].aph03 = '7' LET l_type = '22'
                       WHEN g_aph[l_ac].aph03 = '8' 
                          IF g_aptype = '34' THEN 
                             LET l_type = '25'
                          ELSE
                             LET l_type = '23'
                          END IF
                       WHEN g_aph[l_ac].aph03 = '9' LET l_type = '24'
                       WHEN g_aph[l_ac].aph03 = 'G' LET l_type = '25' #FUN-CB0065
                  END CASE
                   SELECT apa08 INTO l_apa08 FROM apa_file WHERE apa01=g_aph[l_ac].aph04
                                                             AND apa02 <= g_apf.apf02          #MOD-A30146 add
                   IF l_apa08 = 'UNAP' THEN
                      CALL cl_err(g_aph[l_ac].aph04,'aap-915',1)
                      NEXT FIELD aph04
                   END IF
                IF g_apz.apz27 = 'N' THEN  
                   #FUN-CB0065--add--str--
                   IF g_aph[l_ac].aph03='G' THEN 
                      SELECT apa00,apc08-apc10-apc14,apc09-apc11-apc15,apa41,apa42,
                             apa13,apa14,apa08,apc16,apa72
                        INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,
                             l_apa13,l_apa14,l_apa08,l_apc16,l_apa72
                        FROM apa_file,apc_file
                       WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                         AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                         AND apa06 = g_aph[l_ac].aph26
                         AND apa02 <= g_apf.apf02
                   ELSE
                   #FUN-CB0065--add--end
                   SELECT apa00,apc08-apc10-apc14,apc09-apc11-apc15,apa41,apa42, #MOD-B70047 add apc14/apc15
                          apa13,apa14,apa08,apc16,apa72
                     INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,
                          l_apa13,l_apa14,l_apa08,l_apc16,l_apa72
                     FROM apa_file,apc_file
                    WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                      AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                      AND apa06 = g_apf.apf03    #No.TQC-690026   
                      AND apa02 <= g_apf.apf02          #MOD-A30146 add
                   END IF  #FUN-CB0065
                ELSE
                   #FUN-CB0065--add--str--
                   IF g_aph[l_ac].aph03='G' THEN
                      SELECT apa00,apc08-apc10-apc14,apc13,apa41,apa42,
                          apa13,apa14,apa08,apc16,apa72
                     INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,
                          l_apa13,l_apa14,l_apa08,l_apc16,l_apa72
                     FROM apa_file,apc_file
                    WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                      AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                      AND apa06 = g_aph[l_ac].aph26
                      AND apa02 <= g_apf.apf02
                   ELSE
                   #FUN-CB0065--add--end              	
                   #SELECT apa00,apc08-apc10-apc14,apc13-apc15,apa41,apa42, #MOD-B70047 add apc14/apc15 #MOD-90084 mark
                   SELECT apa00,apc08-apc10-apc14,apc13,apa41,apa42, #MOD-B90084 
                          apa13,apa14,apa08,apc16,apa72
                     INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,
                          l_apa13,l_apa14,l_apa08,l_apc16,l_apa72
                     FROM apa_file,apc_file
                    WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                      AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                      AND apa06 = g_apf.apf03    #No.TQC-690026   
                      AND apa02 <= g_apf.apf02          #MOD-A30146 add
                   END IF  #FUN-CB0065
                END IF 
                  CASE WHEN l_aptype[1,1]!='2'  LET g_errno = 'aap-079'
                       WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-072'
                       WHEN l_apa41       = 'N' LET g_errno = 'aap-141'
                       WHEN l_apa42       = 'Y' LET g_errno = 'aap-165'
                       WHEN g_qty1       <= 0   LET g_errno = 'aap-076'
                       WHEN g_qty1       >  0   LET g_errno = ' '
                       OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
                  END CASE
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aph[l_ac].aph04,g_errno,1)
                     NEXT FIELD aph04
                  END IF
                  #--------------->不可沖aapt150所產生
                  IF l_type = '23' OR l_type = '25' THEN   #No.FUN-690080
                     SELECT count(*) INTO l_cnt  FROM apg_file
                                     WHERE apg01 = g_apf.apf01
                                       AND apg04 = l_apa08
                     IF l_cnt > 0 THEN
#                       CALL cl_err(l_apa08,'aap-753',1)   #CHI-B60072 mark
                        CALL cl_err(l_apa08,'aap-753',0)   #CHI-B60072
#                       NEXT FIELD aph04                   #CHI-B60072 mark
                     END IF
                  END IF
 
                 #以aph04+aph17去aph_file尋找已輸入但還未確認的金額,
                 #再以未沖金額扣掉這部份的金額
                  LET l_sum_aph05f= 0
                  LET l_sum_aph05 = 0
                  SELECT SUM(aph05f),SUM(aph05) INTO l_sum_aph05f,l_sum_aph05
                    FROM aph_file,apf_file
                   WHERE aph04 =g_aph[l_ac].aph04 AND aph17=g_aph[l_ac].aph17
                     AND aph01!=g_apf.apf01 AND aph01=apf01 AND apf41='N'
                  IF cl_null(l_sum_aph05f) THEN LET l_sum_aph05f= 0 END IF
                  IF cl_null(l_sum_aph05)  THEN LET l_sum_aph05 = 0 END IF
 
                  LET g_aph[l_ac].aph13 = l_apa13
                  LET g_aph[l_ac].aph14 = l_apa14
                  LET g_aph[l_ac].aph05f= g_qty1 - l_sum_aph05f
                  LET g_aph[l_ac].aph05 = g_qty2 - l_sum_aph05
 
                  DISPLAY BY NAME g_aph[l_ac].aph13
                  DISPLAY BY NAME g_aph[l_ac].aph14
                  DISPLAY BY NAME g_aph[l_ac].aph05f
                  DISPLAY BY NAME g_aph[l_ac].aph05
 
                  IF g_apz.apz27 = 'Y' AND l_apa13 != g_aza.aza17 THEN
                     SELECT SUM(aph05) INTO l_aph05 FROM aph_file,apf_file
                      WHERE aph04=g_aph[l_ac].aph04 AND aph17=g_aph[l_ac].aph17
                        AND aph01<>g_apf.apf01
                        AND aph01=apf01 AND apf41='N'
                     IF cl_null(l_aph05) THEN LET l_aph05 = 0 END IF
 
                     LET g_aph[l_ac].aph14 = l_apa72
                     IF cl_null(g_aph[l_ac].aph14) OR
                        g_aph[l_ac].aph14 = 0 THEN
                        LET g_aph[l_ac].aph14 = l_apa14
                        DISPLAY BY NAME g_aph[l_ac].aph14
                     END IF
                     CALL s_g_np('2',l_aptype,g_aph[l_ac].aph04,'')
                     RETURNING l_amt3
                     #未付金額-已KEY未確認-留置金額
                     LET g_aph[l_ac].aph05 = l_amt3 - l_aph05 -
                                            (l_apc16 * l_apa14)
                     CALL cl_digcut(g_aph[l_ac].aph05,g_azi04)  #No.CHI-6A0004
                          RETURNING g_aph[l_ac].aph05
                     DISPLAY BY NAME g_aph[l_ac].aph05
                  END IF
               END IF
            END IF
#No.FUN-A40003 --begin
            IF NOT cl_null(g_aph[l_ac].aph04) AND g_aptype = '32' THEN  
               IF p_cmd ='a' OR (g_aph[l_ac].aph04!=g_aph_t.aph04 OR g_aph[l_ac].aph17!=g_aph_t.aph17) THEN 
                  CALL t310_aph04()
                  RETURNING g_aph[l_ac].aph07,g_aph[l_ac].aph13,g_aph[l_ac].aph14,g_aph[l_ac].aph05f,g_aph[l_ac].aph05
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                     LET g_aph[l_ac].aph17 = g_aph_t.aph17
                     LET g_aph[l_ac].aph07 = g_aph_t.aph07
                     LET g_aph[l_ac].aph13 = g_aph_t.aph13
                     LET g_aph[l_ac].aph14 = g_aph_t.aph14
                     LET g_aph[l_ac].aph05f= g_aph_t.aph05f
                     LET g_aph[l_ac].aph05 = g_aph_t.aph05
                     NEXT FIELD aph17
                  END IF
               END IF 
            END IF 
#No.FUN-A40003 --end

        #FUN-CB0117----add----str
        BEFORE FIELD aph08
        IF g_aptype = '33' OR g_aptype = '32' THEN
           IF g_aph[l_ac].aph03 = 'E'  OR g_aph[l_ac].aph03 = 'H' THEN    
              IF g_aptype = '33' THEN
                 CALL cl_set_comp_entry('aph08',FALSE)
              END IF
           END IF
        END IF
        #FUN-CB0117----add---end
        
        AFTER FIELD aph08
            IF g_aph[l_ac].aph03 = '2' THEN
               IF cl_null(g_aph[l_ac].aph08) THEN NEXT FIELD aph08 END IF
            END IF
            IF g_aph[l_ac].aph08 IS NOT NULL THEN
               SELECT nma10 INTO g_aph[l_ac].aph13 FROM nma_file
                    WHERE nma01 = g_aph[l_ac].aph08
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","nma_file",g_aph[l_ac].aph08,"",STATUS,"","sel nma.",1)  #No.FUN-660122
                  NEXT FIELD aph08
               END IF
            END IF
            IF g_aph[l_ac].aph03 = '2' AND
               g_aph[l_ac].aph13 != g_aza.aza17 THEN
               CALL s_bankex(g_aph[l_ac].aph08,g_apf.apf02)
                    RETURNING g_aph[l_ac].aph14
              #------------------MOD-CA0072-------------------mark
              #SELECT azi07 INTO t_azi07 FROM azi_file
              # WHERE azi01= g_aph[l_ac].aph13
              #LET g_aph[l_ac].aph14 = cl_digcut(g_aph[l_ac].aph14,t_azi07)
              #------------------MOD-CA0072-------------------mark
               LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
               LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)   #No.CHI-6A0004
               DISPLAY BY NAME g_aph[l_ac].aph14
               DISPLAY BY NAME g_aph[l_ac].aph05
           #MOD-A40156---add---start---
            ELSE
               IF g_aph[l_ac].aph03 = '2' AND g_aph[l_ac].aph13 = g_aza.aza17 THEN
                  LET g_aph[l_ac].aph14 = 1
                  DISPLAY BY NAME g_aph[l_ac].aph14
               END IF
           #MOD-A40156---add---end---
            END IF
 
              IF g_aph[l_ac].aph03 = '1' THEN
                    IF NOT cl_null(g_aph[l_ac].aph08) THEN
                       SELECT nma28 INTO l_nma28 FROM nma_file
                         WHERE nma01=g_aph[l_ac].aph08
                       IF g_aza.aza26 <> '2' THEN       #MOD-BB0329 
                          IF l_nma28 <> g_aph[l_ac].aph03 THEN
                             CALL cl_err('','aap-804',0)
                             NEXT FIELD aph08
                          END IF
                       END IF                           #MOD-BB0329   
                    END IF
              END IF
 
           IF g_aph[l_ac].aph03 = '2' THEN   #TQC-630158
             #IF cl_null(g_aph[l_ac].aph04) AND cl_null(g_aph[l_ac].aph041) THEN  #MOD-990189      #MOD-A80076 mark 
             #IF g_aph_o.aph08 IS NULL OR g_aph_o.aph08 != g_aph[l_ac].aph08 THEN                  #MOD-A80076 ##MOD-BC0242 mark
              IF g_aph_t.aph08 IS NULL OR g_aph_t.aph08 != g_aph[l_ac].aph08 THEN                  #MOD-BC0242 add 
                 SELECT nma05,nma051 INTO g_aph[l_ac].aph04,g_aph[l_ac].aph041 FROM nma_file       #No.FUN-680029
                  WHERE nma01 = g_aph[l_ac].aph08
                 DISPLAY BY NAME g_aph[l_ac].aph04
                #LET g_aph_o.aph08 = g_aph[l_ac].aph08                                             #MOD-A80076 #MOD-BC0242 mark
                 LET g_aph_t.aph08 = g_aph[l_ac].aph08                                             #MOD-BC0242 add
              END IF #MOD-990189   
           END IF
 
        #FUN-970077---Begin 
        AFTER FIELD aph18
           IF NOT cl_null(g_aph[l_ac].aph18) THEN
              SELECT COUNT(*) INTO l_n FROM nnc_file
               WHERE nnc02 = g_aph[l_ac].aph18
              IF l_n = 0 THEN
                 CALL cl_err("","asfi115",0)
                 NEXT FIELD aph18
              END IF
           END IF
       #FUN-970077--End
        BEFORE FIELD aph16
           IF g_aph[l_ac].aph03 = '2' THEN
               IF cl_null(g_aph[l_ac].aph16) THEN
                  LET g_aph[l_ac].aph16 = g_apz.apz58
               END IF
               SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                  WHERE nmc01 = g_aph[l_ac].aph16
               DISPLAY BY NAME g_aph[l_ac].nmc02
           END IF
 
        AFTER FIELD aph16
           IF cl_null(g_aph[l_ac].aph16) AND g_aph[l_ac].aph03 = '2' THEN
              NEXT FIELD aph16
           END IF
           IF NOT cl_null(g_aph[l_ac].aph16) THEN
              SELECT COUNT(*) INTO l_cnt FROM nmc_file
                 WHERE nmc01 = g_aph[l_ac].aph16 AND nmc03 = '2'
              IF l_cnt = 0 THEN
                 CALL cl_err('','anm-024',1)
                #LET g_aph[l_ac].aph16 = g_aph_o.aph16   #MOD-BC0242 mark
                 LET g_aph[l_ac].aph16 = g_aph_t.aph16   #MOD-BC0242 add
                 NEXT FIELD aph16
              ELSE
                 SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                    WHERE nmc01 = g_aph[l_ac].aph16  AND nmc03 = '2' #僅能為提出
                    DISPLAY BY NAME g_aph[l_ac].nmc02
                #LET g_aph_o.aph16 = g_aph[l_ac].aph16   #MOD-BC0242 mark
                 LET g_aph_t.aph16 = g_aph[l_ac].aph16   #MOD-BC0242 add
              END IF
           END IF
 
        BEFORE FIELD aph13
            IF g_aph[l_ac].aph13 IS NULL THEN
               LET g_aph[l_ac].aph13 = g_apf.apf06
            END IF
            DISPLAY BY NAME g_aph[l_ac].aph13
 
        AFTER FIELD aph13,aph14
            IF g_aph[l_ac].aph13 IS NULL THEN NEXT FIELD aph13 END IF 
            IF p_cmd = 'a' OR g_aph[l_ac].aph13 != g_aph_t.aph13 THEN     #No.TQC-B80079
               IF g_aph[l_ac].aph03 NOT MATCHES "[6789FG]" AND  #FUN-C90122 add 'F' #FUN-CB0065 add G
                  g_aph[l_ac].aph13 != g_aza.aza17 AND
                  g_aph[l_ac].aph14 = 1 AND g_aph[l_ac].aph14 = g_aph_t.aph14 THEN   #No.TQC-B80079 add  AND g_aph[l_ac].aph14 = g_aph_t.aph14  
                  CALL s_curr3(g_aph[l_ac].aph13,g_apf.apf02,g_apz.apz33) #FUN-640022
                       RETURNING g_aph[l_ac].aph14
                  DISPLAY BY NAME g_aph[l_ac].aph14
               END IF      
#            IF p_cmd = 'a' OR g_aph[l_ac].aph13 != g_aph_t.aph13 THEN    #No.TQC-B80079   
               CALL t310_aph13(g_aph[l_ac].aph13)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aph[l_ac].aph13,g_errno,0)
                  NEXT FIELD aph13
               END IF
 
            END IF
 
            IF g_aph[l_ac].aph14 IS NOT NULL THEN
              #-MOD-A80034-add-
               IF g_aph[l_ac].aph14 < 0 THEN
                  CALL cl_err('','mfg4012',1)
                  LET g_aph[l_ac].aph14 = g_aph_t.aph14
                  NEXT FIELD aph14
               END IF
              #-MOD-A80034-end-
               IF g_aph[l_ac].aph13 =g_aza.aza17 THEN
                  LET g_aph[l_ac].aph14 =1
                  DISPLAY BY NAME g_aph[l_ac].aph14
               ELSE
                 #------------------MOD-CA0072-------------------mark
                 #SELECT azi07 INTO t_azi07 FROM azi_file
                 # WHERE azi01= g_aph[l_ac].aph13
                 #LET g_aph[l_ac].aph14 = cl_digcut(g_aph[l_ac].aph14,t_azi07)
                 #------------------MOD-CA0072-------------------mark
                  DISPLAY BY NAME g_aph[l_ac].aph14
               END IF
            END IF
 
        BEFORE FIELD aph05f
            IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
               IF p_cmd='a' THEN
                  LET g_aph[l_ac].aph05f = 0
               END IF
            ELSE
              IF g_aph[l_ac].aph05f = 0 OR g_aph[l_ac].aph05f IS NULL THEN           #MOD-930115
                  LET g_aph[l_ac].aph05f = g_apf.apf08f+g_apf.apf09f-g_apf.apf10f
               END IF                                                                 #MOD-930115  
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_aph[l_ac].aph13
            LET g_aph[l_ac].aph05f = cl_digcut(g_aph[l_ac].aph05f,t_azi04)
            IF g_aph[l_ac].aph05f = 0 OR g_aph[l_ac].aph05f IS NULL THEN
               IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
                  LET g_aph[l_ac].aph05 = g_apf.apf08+g_aph_t.aph05-g_apf.apf10
               END IF
               IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
                  LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
                  LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)   #MOD-780148
               END IF
               DISPLAY BY NAME g_aph[l_ac].aph05f,g_aph[l_ac].aph05
            END IF
 
        AFTER FIELD aph05f
            #TQC-C50124--add--str
            #IF NOT cl_null(g_aph[l_ac].aph05f) AND g_aph[l_ac].aph05f < 0 THEN       #MOD-C50109 mark
             IF NOT cl_null(g_aph[l_ac].aph05f) AND g_aptype = '36' THEN              #MOD-C50109 add
                IF g_aph[l_ac].aph05f < 0 THEN                                        #MOD-C50109 add
                   CALL cl_err('','aec-992',1)
                   LET g_aph[l_ac].aph05f = g_aph_t.aph05f
                   NEXT FIELD aph05f
                END IF                                                                 #MOD-C50109 add
             END IF
             #TQC-C50124--add--end
             
             # add by zhangsba190808---s  
             IF g_prog='aapt330' THEN
             IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
             	 IF g_aph[l_ac].aph03 MATCHES "[12]"  OR g_aph[l_ac].aph03='F' THEN  # add by zhangsba190828
               LET l_yy = YEAR(g_apf.apf02)
               LET l_mm = MONTH(g_apf.apf02)
 
               SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file   #anmq300，抛转凭证的银存收支单anmt302，抛转凭证的aapt330冲账单
                 WHERE nme01 = g_aph[l_ac].aph08 AND nme03 = nmc01 AND nmc03 = '1'  #借
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
               SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = g_aph[l_ac].aph08 AND nme03 = nmc01 AND nmc03 = '2'  #贷
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
                   
               IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
               IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
               IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
               IF l_c2 IS NULL THEN LET l_c2 = 0 END IF    
             #mark by zhangsba190904---s 未审核凭证已经包含在anmq300中
             #  SELECT SUM(abb07f),SUM(abb07) INTO l_e1,l_e2 FROM abb_file,aba_file  #该银行科目未审核凭证
             #   WHERE abb03 = g_aph[l_ac].aph08 AND abb06 = '2'  #贷
             #     AND aba00 = abb00 AND aba01 = abb01 AND  aba019 = 'N' 
             #    
             #  SELECT SUM(abb07f),SUM(abb07) INTO l_f1,l_f2 FROM abb_file,aba_file  #该银行科目未审核凭证
             #   WHERE abb03 = g_aph[l_ac].aph08 AND abb06 = '1'  #借
             #     AND aba00 = abb00 AND aba01 = abb01 AND  aba019 = 'N'
             # 
             #  IF l_e1 IS NULL THEN LET l_e1 = 0 END IF
             #  IF l_e2 IS NULL THEN LET l_e2 = 0 END IF
             #  IF l_f1 IS NULL THEN LET l_f1 = 0 END IF
             #  IF l_f2 IS NULL THEN LET l_f2 = 0 END IF
             #mark by zhangsba190904---e  
               SELECT SUM(aph05f),SUM(aph05) INTO l_g1,l_g2 FROM aph_file,apf_file  #未抛转凭证的aapt330冲账单
                WHERE aph01 = apf01 AND aph08 = g_aph[l_ac].aph08 
                  #AND apf41 = 'Y' AND apf42 = '1'     #mark by zhangsba190903
                  AND apf41 = 'N'                      #add by zhangsba190903
                  AND YEAR(apf02)=l_yy and MONTH(apf02)=l_mm  #add by zhangsba190903
               
               IF l_g1 IS NULL THEN LET l_g1 = 0 END IF
               IF l_g2 IS NULL THEN LET l_g2 = 0 END IF
               
               IF l_mm =1 THEN
                  LET l_mm = 12 
                  LET l_yy =l_yy - 1
               ELSE 
                  LET l_mm = l_mm -1
               END IF  
                           
               SELECT nmp06,nmp09 INTO l_nmp06,l_nmp09 FROM nmp_file
                WHERE nmp01 = g_aph[l_ac].aph08
                  AND nmp02 = l_yy
                  AND nmp03 = l_mm
               IF cl_null(l_nmp06) THEN LET l_nmp06 = 0 END IF 
               IF cl_null(l_nmp09) THEN LET l_nmp09 = 0 END IF
     
               #IF l_nmp06 + l_d1 + l_f1 - l_c1 - l_e1 - l_g1 - g_aph[l_ac].aph05f < 0 THEN                     #mark by zhangsba190904
               #   CALL cl_err_msg("","cnm-001",g_aph[l_ac].aph05f||"|"||l_nmp06+l_d1+l_f1-l_c1-l_e1-l_g1,0)    #mark by zhangsba190904
               IF l_nmp06 + l_d1 - l_c1 - l_g1 - g_aph[l_ac].aph05f < 0 THEN                         #add by zhangsba190904
                  CALL cl_err_msg("","cnm-001",g_aph[l_ac].aph05f||"|"||l_nmp06+l_d1-l_c1-l_g1,0)    #add by zhangsba190904      
                  NEXT FIELD aph05f
               END IF   
               END IF # add by zhangsba190828
             END IF 
             END IF # add by zhangsba190903
             # add by zhangsba190808---e
             
            SELECT azi04 INTO t_azi04 FROM azi_file    #No.CHI-6A0004
                WHERE azi01 = g_aph[l_ac].aph13
            LET g_aph[l_ac].aph05f = cl_digcut(g_aph[l_ac].aph05f,t_azi04)   #No.CHI-6A0004
            DISPLAY BY NAME g_aph[l_ac].aph05f            
             
            IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
               LET g_aph[l_ac].aph05 = g_apf.apf08+g_aph_t.aph05-g_apf.apf10
            END IF
            IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
               #若原幣付款金額(aph05f)與帳款原幣金額相同時,
               #本幣付款金額(aph05)直接抓取帳款本幣金額
               LET g_qty1=0    LET g_qty2=0
               IF g_apz.apz27 = 'N' THEN
                  #FUN-CB0065--add--str--
                  IF g_aph[l_ac].aph03='G' THEN #員工借支
                     SELECT apc08-apc10-apc14,apc09-apc11-apc15 #MOD-B70047 add apc14/apc15
                       INTO g_qty1,g_qty2
                       FROM apa_file,apc_file
                      WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                        AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                        AND apa06 = g_aph[l_ac].aph26
                        AND apa02 <= g_apf.apf02
                  ELSE 
                  #FUN-CB0065--add--end
                  SELECT apc08-apc10-apc14,apc09-apc11-apc15 #MOD-B70047 add apc14/apc15
                    INTO g_qty1,g_qty2
                    FROM apa_file,apc_file
                   WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                     AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                     AND apa06 = g_apf.apf03
                     AND apa02 <= g_apf.apf02          #MOD-A30146 add
                  END IF  #FUN-CB0065 
               ELSE
                  #FUN-CB0065--add--str--
                  IF g_aph[l_ac].aph03='G' THEN #員工借支
                     SELECT apc08-apc10-apc14,apc13
                       INTO g_qty1,g_qty2
                       FROM apa_file,apc_file
                      WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                        AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                        AND apa06 = g_aph[l_ac].aph26
                        AND apa02 <= g_apf.apf02
                  ELSE  
                  #FUN-CB0065--add--end
                  #SELECT apc08-apc10-apc14,apc13-apc15,  #MOD-B70047 add apc14/apc15 #MOD-B90084 mark
                  #SELECT apc08-apc10-apc14,apc13, #MOD-B90084 #FUN-CB0065 mark
                  SELECT apc08-apc10-apc14,apc13   #FUN-CB0065 add
                    INTO g_qty1,g_qty2
                    FROM apa_file,apc_file
                   WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                     AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                     AND apa06 = g_apf.apf03
                     AND apa02 <= g_apf.apf02          #MOD-A30146 add
                  END IF  #FUN-CB0065
               END IF
               #FUN-CB0065--add--str--
               IF cl_null(g_qty1) THEN LET g_qty1=0 END IF
               IF g_aph[l_ac].aph03='G' THEN #員工借支 
                  IF g_aph[l_ac].aph05f>g_qty1 THEN
                     CALL cl_err('','aap-294',1)
                     NEXT FIELD aph05f
                  END IF
               END IF
               #FUN-CB0065--add--end
               IF g_aph[l_ac].aph05f = g_qty1 THEN
                  LET g_aph[l_ac].aph05 = g_qty2
               ELSE
                  LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
               END IF   #MOD-870337 add
 
 
        IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN   #MOD-920367
                  #付款原幣與帳款原幣不同時,最後一筆以倒扣方式計算以避免尾差問題
                  LET l_sum_aph05f= 0
                  LET l_sum_aph05 = 0
                  SELECT SUM(aph05f),SUM(aph05) INTO l_sum_aph05f,l_sum_aph05
                    FROM aph_file,apf_file   #MOD-9C0147 add apf_file
                   WHERE aph03 MATCHES '[6789]'
                     AND aph04 = g_aph[l_ac].aph04
                     AND aph01!= g_apf.apf01   #MOD-920251 add
                     AND aph01 = apf01 AND apf41 != 'X'   #MOD-9C0147 add
                  IF cl_null(l_sum_aph05f) THEN LET l_sum_aph05f= 0 END IF
                  IF cl_null(l_sum_aph05)  THEN LET l_sum_aph05 = 0 END IF
                  
                  LET l_apc08 = 0
                  LET l_apc09 = 0
                  SELECT apc08,apc09,apc13 INTO l_apc08,l_apc09,l_apc13   #MOD-980010 add apc13
                    FROM apa_file,apc_file
                   WHERE apa01 = g_aph[l_ac].aph04 AND apa00 = l_type
                     AND apc01 = apa01 AND apc02 = g_aph[l_ac].aph17
                     AND apa06 = g_apf.apf03
                     AND apa02 <= g_apf.apf02          #MOD-A30146 add   
                  IF cl_null(l_apc08) THEN LET l_apc08 = 0 END IF
                  IF cl_null(l_apc09) THEN LET l_apc09 = 0 END IF
                  IF cl_null(l_apc13) THEN LET l_apc13 = 0 END IF   #MOD-980010 add
                  
                  IF l_sum_aph05f+g_aph[l_ac].aph05f = l_apc08 THEN  #最後一筆
                     LET g_aph[l_ac].aph05 = l_apc13 - l_sum_aph05   #MOD-980010
                     IF cl_null(g_aph[l_ac].aph05) THEN
                        LET g_aph[l_ac].aph05 = 0
                     END IF
                  ELSE
                     IF l_sum_aph05f+g_aph[l_ac].aph05f>l_apc08 THEN
                        CALL cl_err(l_sum_aph05f+g_aph[l_ac].aph05f,'aap-294',1)
                        NEXT FIELD aph05f
                     END IF
                  END IF
               END IF    #MOD-920367
#No.FUN-B40011--begin
               IF g_aph[l_ac].aph03 = 'D' THEN
                  LET l_sum_aph05f= 0
                  LET l_sum_aph05 = 0
                  SELECT SUM(aph05f),SUM(aph05) INTO l_sum_aph05f,l_sum_aph05
                    FROM aph_file,apf_file
                   WHERE aph03 = 'D'
                     AND aph04 = g_aph[l_ac].aph04
             #       AND aph01!= g_apf.apf01
                     AND aph01 = apf01 AND apf41 != 'X'   #MOD-9C0147 add
                  IF cl_null(l_sum_aph05f) THEN LET l_sum_aph05f= 0 END IF
                  IF cl_null(l_sum_aph05)  THEN LET l_sum_aph05 = 0 END IF
                  IF cl_null(g_aph_t.aph05f) THEN LET g_aph_t.aph05f = 0 END IF
                  
                  LET l_sum_aph05f = l_sum_aph05f - g_aph_t.aph05f
                
                 #SELECT nmh17 INTO l_nmh17    #No.TQC-C30121   Mark
                  SELECT nmh02 INTO l_nmh02    #NO.TQC-C30121   Add
                    FROM nmh_file
                   WHERE nmh01 = g_aph[l_ac].aph04
                     AND nmh24='5'
                     AND nmh38='Y'
                  IF cl_null(l_nmh02) THEN LET l_nmh02 = 0 END IF   #No.TQC-C30121   Add
                 #IF cl_null(l_nmh17) THEN LET l_nmh17 = 0 END IF   #No.TQC-C30121   Mark
                  
                 #IF l_sum_aph05f+g_aph[l_ac].aph05f > l_nmh17 THEN #No.TQC-C30121   Mark
                  IF l_sum_aph05f+g_aph[l_ac].aph05f > l_nmh02 THEN #No.TQC-C30121   Add
                     CALL cl_err(g_aph[l_ac].aph05f,'aap-670',1)
                     NEXT FIELD aph05f
                  END IF
               END IF
#No.FUN-B40011--end
            #FUN-C90122--add--str--
               IF g_aph[l_ac].aph03='F' THEN
                  SELECT nmd04,nmd55,nmd21,nmd19 INTO l_nmd04,l_nmd55,l_nmd21,l_nmd19
                  FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                  IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
                  IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
                  IF g_aph[l_ac].aph05f>l_nmd04-l_nmd55 THEN
                     LET g_aph[l_ac].aph05f=l_nmd04-l_nmd55
                     LET g_aph[l_ac].aph13=l_nmd21
                     LET g_aph[l_ac].aph14=l_nmd19
                     LET g_aph[l_ac].aph05=g_aph[l_ac].aph05f*g_aph[l_ac].aph14
                     DISPLAY BY NAME g_aph[l_ac].aph05f,g_aph[l_ac].aph05,g_aph[l_ac].aph13,g_aph[l_ac].aph14
                     CALL cl_err('','aap-269',0)
                     NEXT FIELD aph05f
                  END IF
               END IF
            #FUN-C90122--add--end      
            END IF
            LET g_aph[l_ac].aph05=cl_digcut(g_aph[l_ac].aph05,g_azi04)  #No.CHI-6A0004
            DISPLAY BY NAME g_aph[l_ac].aph05
      #TQC-C50124--add--str
      AFTER FIELD aph05
        #---------------MOD-C30818---------------------------------------start
         IF g_aph[l_ac].aph14 = 1 THEN
            IF g_aph[l_ac].aph05f != g_aph[l_ac].aph05 THEN
               CALL cl_err('','apm-988',1)
               NEXT FIELD aph05
            END IF
         END IF
        #---------------MOD-C30818-----------------------------------------end
        #IF NOT cl_null(g_aph[l_ac].aph05) THEN                         #MOD-C50109 mark
         IF NOT cl_null(g_aph[l_ac].aph05) AND g_aptype = '36' THEN     #MOD-C50109 add
            IF g_aph[l_ac].aph05 < 0 THEN 
               CALL cl_err('','aec-992',1)
               LET g_aph[l_ac].aph05 = g_aph_t.aph05
               NEXT FIELD aph05
            END IF
         END IF
      #TQC-C50124--add--end
 
      AFTER FIELD aph07
        #僅限於aph03 = '2' or aph03 = 'C'時才需要檢核假日問題
        IF g_aph[l_ac].aph03='2' OR g_aph[l_ac].aph03='C' THEN   #MOD-850173 add
           LET l_w = WEEKDAY(g_aph[l_ac].aph07)
           # 若為週日
           IF l_w = 0 THEN
             #-----------------------CHI-C10043-----------------------------start
             #LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 1
             #CALL cl_err(g_aph[l_ac].aph07,'aap-803',0)
              LET l_sme02='N'
              SELECT sme02 INTO l_sme02 FROM sme_file
               WHERE sme01 = g_aph[l_ac].aph07
              IF cl_null(l_sme02) THEN LET l_sme02 = 'N' END IF
              IF l_sme02 = 'N' THEN
                 LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 1
                 CALL cl_err(g_aph[l_ac].aph07,'aap-803',0)
              ELSE
                 IF cl_confirm('aap-353') THEN
                    LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 1
                 END IF
              END IF

             #-----------------------CHI-C10043-------------------------------end
           END IF
           # 若為週六
           IF l_w = 6 THEN
             #-----------------------CHI-C10043-----------------------------start
             #LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 2
             #CALL cl_err(g_aph[l_ac].aph07,'aap-803',0)
              LET l_sme02='N'
              SELECT sme02 INTO l_sme02 FROM sme_file
               WHERE sme01 = g_aph[l_ac].aph07
              IF cl_null(l_sme02) THEN LET l_sme02 = 'N' END IF
              IF l_sme02 = 'N' THEN
                 LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 2
                 CALL cl_err(g_aph[l_ac].aph07,'aap-803',0)
              ELSE
                 IF cl_confirm('aap-353') THEN
                    LET g_aph[l_ac].aph07 = g_aph[l_ac].aph07 + 2
                 END IF
              END IF

             #-----------------------CHI-C10043-------------------------------end
           END IF
           # 若為假日,找尋下一個工作日
           SELECT nph02 INTO g_buf FROM nph_file WHERE nph01=g_aph[l_ac].aph07
           IF STATUS = 0 THEN
              SELECT MIN(sme01) INTO l_aph07 FROM sme_file
               WHERE sme01 > g_aph[l_ac].aph07 AND sme02 = 'Y'
              IF STATUS = 100 THEN
                 CALL cl_err3("sel","sme_file","","","amr-533","","",1)  #No.FUN-660122
              ELSE
                 CALL cl_err3("sel","sme_file","","","aap-803","","",1)  #No.FUN-660122
                 LET g_aph[l_ac].aph07 = l_aph07
              END IF
           END IF
        END IF   #MOD-850173 add
        IF NOT(g_aptype='33' AND g_aph[l_ac].aph03='F') THEN  #FUN-C90122
        IF g_apf.apf02 = g_aph[l_ac].aph07 AND g_apz.apz52 <> '1' THEN
           SELECT nma05,nma051 INTO g_aph[l_ac].aph04,g_aph[l_ac].aph041 FROM nma_file     #No.FUN-680029
              WHERE nma01 = g_aph[l_ac].aph08
        END IF
        END IF #FUN-C90122
        DISPLAY BY NAME g_aph[l_ac].aph04
#No.FUN-A90007 --begin
      AFTER FIELD aph21
         IF NOT cl_null(g_aph[l_ac].aph21) THEN
            #CHI-CA0054 add beg ------------------- 
            IF g_aph[l_ac].aph21[1,4] <> 'MISC' THEN #CHI-CA0054 add
               CALL cl_set_comp_entry("aph25",FALSE) #CHI-CA0054 add 
               SELECT pmc03 INTO l_pmc03
                 FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21
               LET g_aph[l_ac].aph25 =l_pmc03
            ELSE 
               CALL cl_set_comp_entry("aph25",TRUE) #CHI-CA0054 add
               SELECT pmc03 INTO l_pmc03
                 FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21
               IF cl_null(g_aph[l_ac].aph25) OR g_aph[l_ac].aph21 != g_aph_t.aph21 THEN 
               	  LET g_aph[l_ac].aph25 =l_pmc03 
               END IF 
            END IF 
            #CHI-CA0054 add end -------------------           	  
            IF g_aph_t.aph21 IS NULL OR g_aph[l_ac].aph21 != g_aph_t.aph21 THEN
               SELECT pmc03,pmc04,pmc05,pmcacti,pmc24
               INTO l_pmc03,l_pmc04,l_pmc05,l_pmcacti,l_pmc24
               FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21
               
               LET g_errno = ' '
               
               CASE
                  WHEN l_pmcacti = 'N'            LET g_errno = '9028'
                  WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'                    
                  WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'    
                  WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
               
                   WHEN STATUS=100 LET g_errno = '100'  #MOD-4B0124
                  WHEN SQLCA.SQLCODE != 0
                     LET g_errno = SQLCA.SQLCODE USING '-----'
               END CASE

               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aph[l_ac].aph21,g_errno,0)
                  LET g_aph[l_ac].aph21 = g_aph_t.aph21
                  NEXT FIELD aph21
               END IF
               #LET g_aph[l_ac].pmc03 =l_pmc03 ##CHI-CA0054 mark
               LET g_aph[l_ac].aph25 =l_pmc03                 
            END IF
         END IF
         DISPLAY BY NAME g_aph[l_ac].aph21
         
      AFTER FIELD aph22
         IF NOT cl_null(g_aph[l_ac].aph22) THEN
            IF p_cmd ='a' OR (p_cmd ='u' AND g_aph[l_ac].aph22 != g_aph_t.aph22) THEN 
               LET g_errno = ''
               SELECT apr02,apracti INTO l_apr02,l_apracti
                 FROM apr_file WHERE apr01 = g_aph[l_ac].aph22
               
               CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-044'
                    WHEN l_apracti = 'N' LET g_errno = 'ams-106'
                    WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
               END CASE
               
               IF NOT cl_null(g_errno) THEN
                  LET l_apr02 = ''
               END IF
               LET g_aph[l_ac].apr02 = l_apr02
               #FUN-C90044--add--str
               IF NOT cl_null(g_aph[l_ac].aph22) AND (g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 = 'H') THEN   #FUN-CB0117 add--H
                  IF g_apz.apz13 = 'N' THEN
                     SELECT apt04 INTO g_aph[l_ac].aph04 FROM apt_file
                      WHERE apt01 = g_aph[l_ac].aph22
                  ELSE
                     SELECT apt04 INTO g_aph[l_ac].aph04 FROM apt_file
                      WHERE apt01 = g_aph[l_ac].aph22
                        AND apt02 = g_apf.apf03
                  END IF
                  IF cl_null(g_aph[l_ac].aph04) THEN
                     IF g_aptype = '32' THEN
                        LET g_aph[l_ac].aph04 = g_aps.aps61
                     ELSE
                        LET g_aph[l_ac].aph04 = g_aps.aps22
                     END IF
                  END IF
                  IF g_aza.aza63 = 'Y' THEN
                     IF g_apz.apz13 = 'N' THEN
                        SELECT apt041 INTO g_aph[l_ac].aph041 FROM apt_file
                         WHERE apt01 = g_aph[l_ac].aph22
                     ELSE
                        SELECT apt041 INTO g_aph[l_ac].aph041 FROM apt_file
                         WHERE apt01 = g_aph[l_ac].aph22
                           AND apt02 = g_apf.apf03
                     END IF
                     IF cl_null(g_aph[l_ac].aph041) THEN
                        IF g_aptype = '32' THEN
                           LET g_aph[l_ac].aph041 = g_aps.aps611
                        ELSE
                           LET g_aph[l_ac].aph041 = g_aps.aps221
                        END IF
                     END IF
                  END IF
               END IF
               #FUN-C90044--add-end
            END IF 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aph[l_ac].aph22,g_errno,0)
               NEXT FIELD aph22
            END IF
         ELSE
           CALL cl_err('aph22 is null: ','aap-099',0)
           NEXT FIELD aph22
         END IF
         DISPLAY BY NAME g_aph[l_ac].aph22
       
      AFTER FIELD aph23                  #帳款編號 
         IF NOT cl_null(g_aph[l_ac].aph23) THEN   #No.FUN-690080
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_aph[l_ac].aph23 != g_aph_t.aph23) THEN
               IF g_apf.apf47 = '2' THEN #FUN-C90027 xuxz
                  CALL s_check_no("aap",g_aph[l_ac].aph23,g_aph_t.aph23,"22","apa_file","apa01","")#FUN-C90027 
                  RETURNING li_result,g_aph[l_ac].aph23#FUN-C90027
               ELSE#FUN-C90027
                  CALL s_check_no("aap",g_aph[l_ac].aph23,g_aph_t.aph23,"12","apa_file","apa01","")
                  RETURNING li_result,g_aph[l_ac].aph23
               END IF#FUN-C90027 add 
               DISPLAY BY NAME g_aph[l_ac].aph23
               IF (NOT li_result) THEN
                  LET g_aph[l_ac].aph23=g_aph_t.aph23
                  NEXT FIELD aph23
               END IF
               IF NOT cl_null(g_aph[l_ac].aph23[1,1]) THEN
                  CALL s_get_doc_no(g_aph[l_ac].aph23) RETURNING g_t1
                  SELECT * INTO g_apy.* FROM apy_file
                     WHERE apyslip=g_t1 AND apyacti = 'Y'
                                        AND apykind= '12' 
#No.TQC-BC0195 --begin
                 IF g_apz.apz68 ='Y' THEN  
                    SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_t1 AND apydmy3 ='Y'
                    IF l_n =0 THEN  
                       CALL cl_err(g_t1,'aap-940',1)
                       LET g_t1=NULL 
                       NEXT FIELD aph23 
                    END IF 
                 ELSE  
                    SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_t1 AND apydmy3 ='N'
                    IF l_n =0 THEN  
                       CALL cl_err(g_t1,'aap-941',1)
                       LET g_t1=NULL 
                       NEXT FIELD aph23 
                    END IF 
                     END IF 
#No.TQC-BC0195 --end 
               END IF
            END IF
         END IF  
         DISPLAY BY NAME g_aph[l_ac].aph23
          
      AFTER FIELD aph24
         IF NOT cl_null(g_aph[l_ac].aph24) THEN
            IF g_aph[l_ac].aph24 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL cl_err(g_aph[l_ac].aph23,'aap-176',1)
               NEXT FIELD aph24
            END IF
         END IF
         DISPLAY BY NAME g_aph[l_ac].aph24
         
#No.FUN-A90007 --end 
        AFTER FIELD aphud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aphud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_aph_t.aph02 > 0 AND g_aph_t.aph02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM aph_file
               WHERE aph01 = g_apf.apf01
                 AND aph02 = g_aph_t.aph02
              IF l_cnt > 0 THEN
                 DELETE FROM aph_file
                  WHERE aph01 = g_apf.apf01
                    AND aph02 = g_aph_t.aph02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                    CALL cl_err3("del","aph_file",g_apf.apf01,g_aph_t.aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                    CANCEL DELETE
                 END IF
              END IF   #MOD-870048 add
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                  LET l_apf42 = '0'          #MOD-4A0299
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
           CALL t310_b2_tot()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aph[l_ac].* = g_aph_t.*
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
#No.FUN-A90007 --begin
           IF g_aptype = '36' THEN      
              IF g_aph[l_ac].aph21 IS NULL  THEN
                 NEXT FIELD aph21
              END IF
              IF g_aph[l_ac].aph22 IS NULL  THEN
                 NEXT FIELD aph22
              END IF
              IF g_aph[l_ac].aph23 IS NULL  THEN
                 NEXT FIELD aph23
              END IF
              IF g_aph[l_ac].aph24 IS NULL  THEN
                 NEXT FIELD aph24
              END IF
           END IF
#No.FUN-A90007 --end
           #FUN-CB0065--add--str--
           IF g_aptype='33' AND g_aph[l_ac].aph03='G' THEN
              IF cl_null(g_aph[l_ac].aph26) THEN
                 NEXT FIELD aph26
              END IF
           END IF
           #FUN-CB0065--add--end
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aph[l_ac].aph02,-263,1)
               LET g_aph[l_ac].* = g_aph_t.*
            ELSE
               UPDATE aph_file SET aph02 = g_aph[l_ac].aph02,
                                   aph03 = g_aph[l_ac].aph03,
                                   aph26 = g_aph[l_ac].aph26,   #FUN-CB0065
                                   aph08 = g_aph[l_ac].aph08,   #TQC-5B0021
                                   aph04 = g_aph[l_ac].aph04,   #TQC-5B0021
                                   aph041= g_aph[l_ac].aph041,  #No.FUN-680027 add
                                   aph17 = g_aph[l_ac].aph17,   #No.FUN-680027 add
                                   aph16 = g_aph[l_ac].aph16,   #MOD-590054
                                   aph07 = g_aph[l_ac].aph07,
                                   aph09 = g_aph[l_ac].aph09,
                                   aph13 = g_aph[l_ac].aph13,
                                   aph14 = g_aph[l_ac].aph14,
                                   aph05f = g_aph[l_ac].aph05f,
                                   aph05 = g_aph[l_ac].aph05,
                                   aph18 = g_aph[l_ac].aph18,   #FUN-970077 add
                                   aph19 = g_aph[l_ac].aph19,   #FUN-970077 add
                                   aph20 = g_aph[l_ac].aph20,   #FUN-A20010 add
#No.FUN-A90007 --begin
                                   aph21 = g_aph[l_ac].aph21,
                                   aph22 = g_aph[l_ac].aph22,
                                   aph23 = g_aph[l_ac].aph23,
                                   aph24 = g_aph[l_ac].aph24,
#No.FUN-A90007 --end               
                                   aph25 = g_aph[l_ac].aph25,  #CHI-CA0054 add
                                aphud01 = g_aph[l_ac].aphud01,
                                aphud02 = g_aph[l_ac].aphud02,
                                aphud03 = g_aph[l_ac].aphud03,
                                aphud04 = g_aph[l_ac].aphud04,
                                aphud05 = g_aph[l_ac].aphud05,
                                aphud06 = g_aph[l_ac].aphud06,
                                aphud07 = g_aph[l_ac].aphud07,
                                aphud08 = g_aph[l_ac].aphud08,
                                aphud09 = g_aph[l_ac].aphud09,
                                aphud10 = g_aph[l_ac].aphud10,
                                aphud11 = g_aph[l_ac].aphud11,
                                aphud12 = g_aph[l_ac].aphud12,
                                aphud13 = g_aph[l_ac].aphud13,
                                aphud14 = g_aph[l_ac].aphud14,
                                aphud15 = g_aph[l_ac].aphud15
                WHERE aph01=g_apf.apf01
                 AND aph02 = g_aph_t.aph02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                  CALL cl_err3("upd","aph_file",g_apf.apf01,g_aph_t.aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                  LET g_aph[l_ac].* = g_aph_t.*
                  ROLLBACK WORK
               ELSE

                  MESSAGE 'UPDATE O.K'

                  UPDATE apf_file SET apfmodu=g_user,apfdate=g_today
                   WHERE apf01=g_apf.apf01
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0) 
                     LET g_success='N'
                  END IF
                  IF g_success='Y' THEN
                     LET l_apf42 = '0'          #MOD-4A0299
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aph[l_ac].* = g_aph_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aph.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "payment_detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
              #LET g_aph_o.aph03 = ''  #No.FUN-680029 #MOD-BC0242 mark
               LET g_aph_t.aph03 = ''  #MOD-BC0242 add 
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032
       #-----------------MOD-BC0103--------------------------------------start
            IF l_ac > 0 THEN
               IF g_aph[l_ac].aph03 = '1' THEN
                  IF g_aph[l_ac].aph05f <= 0 THEN
                     CALL cl_err('',"atm-370",0)
                     NEXT FIELD aph05f
                  END IF
               END IF
               # add by zhangsba190904---s     #修改管控的位置，放在这一行全部完成之后判断
               # add by zhangsba190808---s  
             IF g_prog='aapt330' THEN
             IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
             	 IF g_aph[l_ac].aph03 MATCHES "[12]"  OR g_aph[l_ac].aph03='F' THEN  # add by zhangsba190828
               LET l_yy = YEAR(g_apf.apf02)
               LET l_mm = MONTH(g_apf.apf02)
 
               SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file   #anmq300，抛转凭证的银存收支单anmt302，抛转凭证的aapt330冲账单
                 WHERE nme01 = g_aph[l_ac].aph08 AND nme03 = nmc01 AND nmc03 = '1'  #借
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
               SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
                 WHERE nme01 = g_aph[l_ac].aph08 AND nme03 = nmc01 AND nmc03 = '2'  #贷
                   AND YEAR(nme16)=l_yy and MONTH(nme16)=l_mm
                   
               IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
               IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
               IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
               IF l_c2 IS NULL THEN LET l_c2 = 0 END IF    
             #mark by zhangsba190904---s 未审核凭证已经包含在anmq300中
             #  SELECT SUM(abb07f),SUM(abb07) INTO l_e1,l_e2 FROM abb_file,aba_file  #该银行科目未审核凭证
             #   WHERE abb03 = g_aph[l_ac].aph08 AND abb06 = '2'  #贷
             #     AND aba00 = abb00 AND aba01 = abb01 AND  aba019 = 'N' 
             #    
             #  SELECT SUM(abb07f),SUM(abb07) INTO l_f1,l_f2 FROM abb_file,aba_file  #该银行科目未审核凭证
             #   WHERE abb03 = g_aph[l_ac].aph08 AND abb06 = '1'  #借
             #     AND aba00 = abb00 AND aba01 = abb01 AND  aba019 = 'N'
             # 
             #  IF l_e1 IS NULL THEN LET l_e1 = 0 END IF
             #  IF l_e2 IS NULL THEN LET l_e2 = 0 END IF
             #  IF l_f1 IS NULL THEN LET l_f1 = 0 END IF
             #  IF l_f2 IS NULL THEN LET l_f2 = 0 END IF
             #mark by zhangsba190904---e  
               SELECT SUM(aph05f),SUM(aph05) INTO l_g1,l_g2 FROM aph_file,apf_file  #未抛转凭证的aapt330冲账单
                WHERE aph01 = apf01 AND aph08 = g_aph[l_ac].aph08 
                  #AND apf41 = 'Y' AND apf42 = '1'     #mark by zhangsba190903
                  AND apf41 = 'N'                      #add by zhangsba190903
                  AND YEAR(apf02)=l_yy and MONTH(apf02)=l_mm  #add by zhangsba190903
               
               IF l_g1 IS NULL THEN LET l_g1 = 0 END IF
               IF l_g2 IS NULL THEN LET l_g2 = 0 END IF
               
               IF l_mm =1 THEN
                  LET l_mm = 12 
                  LET l_yy =l_yy - 1
               ELSE 
                  LET l_mm = l_mm -1
               END IF  
                           
               SELECT nmp06,nmp09 INTO l_nmp06,l_nmp09 FROM nmp_file
                WHERE nmp01 = g_aph[l_ac].aph08
                  AND nmp02 = l_yy
                  AND nmp03 = l_mm
               IF cl_null(l_nmp06) THEN LET l_nmp06 = 0 END IF 
               IF cl_null(l_nmp09) THEN LET l_nmp09 = 0 END IF
     
               #IF l_nmp06 + l_d1 + l_f1 - l_c1 - l_e1 - l_g1 - g_aph[l_ac].aph05f < 0 THEN                     #mark by zhangsba190904
               #   CALL cl_err_msg("","cnm-001",g_aph[l_ac].aph05f||"|"||l_nmp06+l_d1+l_f1-l_c1-l_e1-l_g1,0)    #mark by zhangsba190904
               IF l_nmp06 + l_d1 - l_c1 - l_g1 - g_aph[l_ac].aph05f < 0 THEN                         #add by zhangsba190904
                  CALL cl_err_msg("","cnm-001",g_aph[l_ac].aph05f||"|"||l_nmp06+l_d1-l_c1-l_g1,0)    #add by zhangsba190904      
                  NEXT FIELD aph05f
               END IF   
               END IF # add by zhangsba190828
             END IF 
             END IF # add by zhangsba190903
             # add by zhangsba190808---e
            END IF
       #-----------------MOD-BC0103----------------------------------------end
            CLOSE t310_bcl
            COMMIT WORK
            CALL g_aph.deleteElement(g_rec_b2+1)   #MOD-D60211
            CALL t310_b2_tot()
 
        ON ACTION mntn_freq_ac
          #IF g_aph[l_ac].aph03 NOT MATCHES '[ABT]' THEN                 #MOD-CC0166 mark
           IF g_aph[l_ac].aph03 NOT MATCHES '[1-9,A,B,C,D,E,Z]' THEN     #MOD-CC0166 add
              CALL cl_cmdrun('aapi204')
           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(aph03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_apw"
                 LET g_qryparam.arg1 = g_bookno1     #No.TQC-A30078
                 LET g_qryparam.default1 = g_aph[l_ac].aph03
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph03
                 DISPLAY g_aph[l_ac].aph03 TO aph03
              #FUN-CB0065--add--str--
              WHEN INFIELD(aph26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_apa06_1"
                 LET g_qryparam.default1 = g_aph[l_ac].aph26
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph26
                 DISPLAY g_aph[l_ac].aph26 TO aph26
              #FUN-CB0065--add--end
              WHEN INFIELD(aph08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nma2"   #No.TQC-5B0114
                 IF g_aph[l_ac].aph03 = 'C' THEN
                    IF g_aptype = '34' THEN
                       LET g_qryparam.arg1 = '25'
                    ELSE
                       LET g_qryparam.arg1 = '23'
                    END IF
                 ELSE
                    IF g_aph[l_ac].aph03 = '2' THEN
                       IF g_aptype = '34' THEN
                          LET g_qryparam.arg1 = '23'     #No.MOD-740498
                       ELSE
                          LET g_qryparam.arg1 = '123'   #MOD-690026
                       END IF
                    ELSE
                       #LET g_qryparam.arg1 = g_aph[l_ac].aph03   #No.TQC-5B0114 #TQC-B90208
                       LET g_qryparam.arg1 = '123'                #TQC-B90208
                    END IF
                 END IF   #MOD-620055
                 LET g_qryparam.default1 = g_aph[l_ac].aph08
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph08
                 DISPLAY g_aph[l_ac].aph08 TO aph08
              #FUN-970077---Begin
              WHEN INFIELD(aph18)
                 CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_nnc1"           #FUN-A20010
#                LET g_qryparam.arg1 = g_aph[l_ac].aph08 #FUN-A20010
                 LET g_qryparam.form ="q_nnc2"           #FUN-A20010
                 LET g_qryparam.arg1 =' '                #FUN-A20010
                 LET g_qryparam.default1 = g_aph[l_ac].aph18
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph18
                 DISPLAY g_aph[l_ac].aph18 TO aph18
              #FUN-970077---End
              WHEN INFIELD(aph16)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_nmc"       #No.MOD-C30621   Mark
                 LET g_qryparam.form ="q_nmc002"    #No.MOD-C30621   Add
                 LET g_qryparam.default1 = g_aph[l_ac].aph16
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph16
                 DISPLAY g_aph[l_ac].aph16 TO aph16
              WHEN INFIELD(aph04)
                 IF g_aph[l_ac].aph03 NOT MATCHES "[6789]" THEN
                    IF g_aptype ='32' THEN 
#No.FUN-A40003 --begin
                       IF g_aph[l_ac].aph03 ='1' THEN
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_nmh5"
                          LET g_qryparam.arg1 = g_apf.apf03
                          LET g_qryparam.arg2 = g_doc_len    
                          CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                          NEXT FIELD aph04
                       END IF 
                       IF g_aph[l_ac].aph03 ='2' THEN
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_nmg"
                          LET g_qryparam.default1 = g_aph[l_ac].aph04
                           LET g_qryparam.arg1 = g_apf.apf03   
                          CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                          NEXT FIELD aph04
                       END IF
                       #FUN-C90044--add--str--
                       IF g_aph[l_ac].aph03 ='E' OR g_aph[l_ac].aph03 ='H' THEN     #FUN-CB0117-add--H
                          CALL q_aapact(FALSE,TRUE,'2',g_aph[l_ac].aph04,g_bookno1)
                                  RETURNING g_aph[l_ac].aph04
                          DISPLAY g_aph[l_ac].aph04 TO aph04
                       END IF
                       #FUN-C90044--add--end
                    ELSE  
#No.FUN-A40003 --end
#No.FUN-B40011 --begin
                       IF g_aph[l_ac].aph03 ='D' THEN
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_nmh6"
                          LET g_qryparam.arg1 = g_apf.apf03  
                          LET g_qryparam.where = " nmh05 >='",g_apf.apf02,"'" #TQC-C50108 add
                          CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                          NEXT FIELD aph04
                       ELSE
#No.FUN-B40011 --end
                          #FUN-C90122--add--str--
                           IF g_aptype='33' AND g_aph[l_ac].aph03 ='F' THEN
                              CALL cl_init_qry_var()
                              LET g_qryparam.form = "q_nmd4"
                              LET g_qryparam.arg1 = g_apf.apf03
                              CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                              NEXT FIELD aph04
                           ELSE
                           #FUN-C90122--add--end 
                           #FUN-CB0065--add--str--
                           IF g_aptype='33' AND g_aph[l_ac].aph03 ='G' THEN
                              CALL cl_init_qry_var()
                              LET g_qryparam.form = "q_apx01"
                              LET g_qryparam.arg1 = g_aph[l_ac].aph26
                              LET g_qryparam.default1 = g_aph[l_ac].aph04
                              CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                              NEXT FIELD aph04
                           ELSE
                           #FUN-CB0065--add--end 
                           CALL q_aapact(FALSE,TRUE,'2',g_aph[l_ac].aph04,g_bookno1)   #No.8727   #No.FUN-730064
                               RETURNING g_aph[l_ac].aph04
                           DISPLAY g_aph[l_ac].aph04 TO aph04
                           END IF   #FUN-C90122
                           END IF   #FUN-CB0065
                       END IF  #No.FUN-B40011
                      #MOD-C70163---S---
                       IF g_aph[l_ac].aph03 = '2' THEN
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_nmg4"
                          LET g_qryparam.default1 = g_aph[l_ac].aph04
                          LET g_qryparam.arg1 = g_apf.apf03
                          CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                          NEXT FIELD aph04
                       END IF
                      #MOD-C70163---E---
                    END IF     #No.FUN-A40003 
                 ELSE
                   IF g_aph[l_ac].aph03='8' THEN                                                                                   
                      CASE WHEN g_aph[l_ac].aph03 = '6' LET l_type = '21'                                                           
                           WHEN g_aph[l_ac].aph03 = '7' LET l_type = '22'                                                           
                           WHEN g_aph[l_ac].aph03 = '8' 
                              IF g_aptype = '34' THEN
                                 LET l_type = '25'
                              ELSE
                                 LET l_type = '23'
                              END IF
                           WHEN g_aph[l_ac].aph03 = '9' LET l_type = '24'                                                           
                      END CASE                                                                                                      
                    ELSE                 
                      CASE WHEN g_aph[l_ac].aph03 = '6' LET l_type = '21'
                           WHEN g_aph[l_ac].aph03 = '7' LET l_type = '22'
                           WHEN g_aph[l_ac].aph03 = '8'  
                              IF g_aptype = '34' THEN
                                 LET l_type = '25'
                              ELSE
                                 LET l_type = '23'
                              END IF
                           WHEN g_aph[l_ac].aph03 = '9' LET l_type = '24'
                      END CASE
                    END IF 
                      CALL q_m_apa2(FALSE,TRUE,'',g_apf.apf03,'*',   #MOD-670014
                                   g_apf.apf06,l_type,g_aph[l_ac].aph04)
                           RETURNING g_aph[l_ac].aph04,g_aph[l_ac].aph17      #No.FUN-680027 add
                      IF cl_null(g_apg[l_ac].apg04) THEN            #No.FUN-680027 add 
                         LET g_apg[l_ac].apg06 = NULL               #No.FUN-680027 add
                      END IF                                        #No.FUN-680027 add 
                      IF g_aph[l_ac].aph04 <> g_aph_t.aph04 THEN    #MOD-D10139 add
                         DISPLAY g_aph[l_ac].aph04 TO aph04
                         DISPLAY g_aph[l_ac].aph17 TO aph17         #No.FUN-680027 add
                      ELSE                                          #MOD-D10139 add
                         IF g_aph[l_ac].aph17 = 0 THEN              #MOD-D10139 add
                            LET g_aph[l_ac].aph17 = g_aph_t.aph17   #MOD-D10139 add
                         END IF                                     #MOD-D10139 add
                      END IF                                        #MOD-D10139 add
                 END IF
              WHEN INFIELD(aph041)
                    CALL q_aapact(FALSE,TRUE,'2',g_aph[l_ac].aph041,g_bookno2)   #No.8727   #No.FUN-730064
                         RETURNING g_aph[l_ac].aph041
                    DISPLAY g_aph[l_ac].aph041 TO aph041
              WHEN INFIELD(aph13) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aph[l_ac].aph13
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph13
                 DISPLAY g_aph[l_ac].aph13 TO aph13
              WHEN INFIELD(aph14)
                   CALL s_rate(g_aph[l_ac].aph13,g_aph[l_ac].aph14)
                   RETURNING g_aph[l_ac].aph14
                   DISPLAY BY NAME g_aph[l_ac].aph14
                   NEXT FIELD aph14
#No.FUN-A90007 --begin
              WHEN INFIELD(aph23) #查詢單据
                 LET g_t1=s_get_doc_no(g_aph[l_ac].aph23)
#No.FUN-C90027--BEGIN
                 IF g_apf.apf47 = '2' THEN
                    CALL q_apy(FALSE,FALSE,g_t1,'22','AAP') RETURNING g_t1 
                 ELSE
                    CALL q_apy(FALSE,FALSE,g_t1,'12','AAP') RETURNING g_t1  
                 END IF
#No.FUN-C90027--END
              #  CALL q_apy(FALSE,FALSE,g_t1,'12','AAP') RETURNING g_t1   #TQC-670008
                 LET g_aph[l_ac].aph23=g_t1            #No.FUN-550030
                 NEXT FIELD aph23
              WHEN INFIELD(aph21) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_aph[l_ac].aph21
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph21
                 NEXT FIELD aph21
              WHEN INFIELD(aph22) # Class
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_apr"
                 LET g_qryparam.default1 = g_aph[l_ac].aph22
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph22
                 #FUN-C90044--add--byxuxz
                 IF NOT cl_null(g_aph[l_ac].aph22) AND (g_aph[l_ac].aph03 = 'E' OR g_aph[l_ac].aph03 ='H')  #FUN-CB0117  add--H
                    AND g_aph[l_ac].aph22 <>g_aph_t.aph22 THEN
                    IF g_apz.apz13 = 'N' THEN
                       SELECT apt04 INTO g_aph[l_ac].aph04 FROM apt_file
                        WHERE apt01 = g_aph[l_ac].aph22
                    ELSE
                       SELECT apt04 INTO g_aph[l_ac].aph04 FROM apt_file
                        WHERE apt01 = g_aph[l_ac].aph22
                          AND apt02 = g_apf.apf03
                    END IF
                    IF cl_null(g_aph[l_ac].aph04) THEN
                       LET g_aph[l_ac].aph04 = g_aps.aps22
                    END IF
                    IF g_aza.aza63 = 'Y' THEN
                       IF g_apz.apz13 = 'N' THEN
                          SELECT apt041 INTO g_aph[l_ac].aph041 FROM apt_file
                          WHERE apt01 = g_aph[l_ac].aph22
                       ELSE
                          SELECT apt041 INTO g_aph[l_ac].aph041 FROM apt_file
                           WHERE apt01 = g_aph[l_ac].aph22
                             AND apt02 = g_apf.apf03
                       END IF
                       IF cl_null(g_aph[l_ac].aph041) THEN
                          LET g_aph[l_ac].aph041 = g_aps.aps221
                       END IF
                    END IF
                 END IF
                 #FUN-C90044--add-by xuxz
                 NEXT FIELD aph22
#No.FUN-A90007 --end
              OTHERWISE
                 EXIT CASE
        END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aph02) AND l_ac > 1 THEN
               LET g_aph[l_ac].* = g_aph[l_ac-1].*
               LET g_aph[l_ac].aph02 = NULL   #TQC-620018
               NEXT FIELD aph02
           END IF
 
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
 
    IF g_action_choice = "payment_detail" THEN RETURN END IF  #FUN-D30032
   #-MOD-A90129-add-
   #TQC-B20092 --begin
   IF g_aptype <>'32' AND g_aptype<>'36' THEN
    SELECT COUNT(*) INTO l_cnt 
      FROM aph_file
     WHERE aph01 = g_apf.apf01 
       AND aph03 = '2' 
       AND aph16 IS NULL
    IF l_cnt > 0 THEN
       CALL cl_err('','aap-307',1)
    END IF
   END IF
   #TQC-B20092 --end
   #-MOD-A90129-end-

   #-TQC-B10199-add-
   #若付款單身已無資料,但溢付款有資料者,需刪除溢付款資料 
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt 
      FROM aph_file
     WHERE aph01 = g_apf.apf01 
    LET l_cnt2 = 0
    SELECT COUNT(*) INTO l_cnt2 
      FROM apa_file
     WHERE apa08 = g_apf.apf01 AND apa00='24'
       AND apa02 <= g_apf.apf02  
   #1.若付款單身已無資料,但溢付款有資料者,須刪除溢付款資料
   #2.若已無溢付金額,但溢付款有資料者,須刪除溢付款資料
   #IF l_cnt = 0 AND l_cnt2 > 0 THEN                                       #TQC-B30175 mark
    IF (l_cnt = 0 AND l_cnt2 > 0) OR (l_cnt2 > 0 AND g_apf.apf09 = 0) THEN #TQC-B30175
       SELECT apa01 INTO l_apa01
         FROM apa_file
        WHERE apa08 = g_apf.apf01

       DELETE FROM apa_file 
        WHERE apa01 = l_apa01 

       DELETE FROM apc_file 
        WHERE apc01 = l_apa01                                                                       
    END IF   
   #-TQC-B10199-end- 

    CALL t3101() #CHI-AA0003 add

    UPDATE apf_file SET apfmodu=g_apf.apfmodu,apf42=l_apf42,  #MOD-4A0299
                       apfdate=g_apf.apfdate
    WHERE apf01=g_apf.apf01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)
       LET g_success='N'
    END IF
    LET g_apf.apf42 = l_apf42
    DISPLAY BY NAME g_apf.apf42
    IF g_apf.apf41 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
    IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
 
    CALL t310_b2_tot()
   #-TQC-B10199-mark- 
   #WHILE TRUE
   #   IF g_apf.apf10 != (g_apf.apf08+g_apf.apf09) THEN    
   #      IF g_apf.apf10 < g_apf.apf08 + g_apf.apf09 AND g_aptype <> '32' THEN      #No.FUN-A80111
   #         IF g_apf.apf10  < g_apf.apf08 THEN                # 付不足  
   #            CALL cl_getmsg('aap-070',g_lang) RETURNING g_msg
   #         ELSE
   #            CALL t310_tmp_apf09() CONTINUE WHILE
   #         END IF
   #      END IF
   #      IF g_apf.apf10 > (g_apf.apf08+g_apf.apf09) AND g_aptype <> '32' THEN        # 付超過   #No.FUN-A80111
   #         IF g_apf.apf10 > g_apf.apf08 THEN                # 付不足
   #           IF g_aptype = '34' THEN   #TQC-750139
   #            CALL cl_getmsg('aap-087',g_lang) RETURNING g_msg
   #           ELSE
   #             CALL cl_getmsg('aap-071',g_lang) RETURNING g_msg
   #           END IF
   #         ELSE
   #            CALL t310_tmp_apf09() CONTINUE WHILE
   #         END IF
   #      END IF
#No.FUN-A80111 --begin
   #      IF g_apf.apf10 > g_apf.apf08 AND g_aptype ='32' THEN        # 付超過  
   #         CALL cl_getmsg('aap-147',g_lang) RETURNING g_msg            
   #      END IF
#No.FUN-A80111 --end
   #      WHILE TRUE
   #         LET g_chr=' '
   #         LET INT_FLAG = 0  ######add for prompt bug
   #         IF g_aptype ='36' THEN CALL cl_getmsg('aap-077',g_lang) RETURNING g_msg  END IF    #No.FUN-A60024
   #         PROMPT g_msg CLIPPED FOR CHAR g_chr
   #            ON IDLE g_idle_seconds  #TQC-860021
   #               CALL cl_on_idle()    #TQC-860021
 
   #            ON ACTION about         #TQC-860021
   #               CALL cl_about()      #TQC-860021
 
   #            ON ACTION help          #TQC-860021
   #               CALL cl_show_help()  #TQC-860021
 
   #            ON ACTION controlg      #TQC-860021
   #               CALL cl_cmdask()     #TQC-860021
   #         END PROMPT                 #TQC-860021
   #         IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   #         IF g_apf.apf10 < g_apf.apf08 AND g_chr='3' THEN
   #            CONTINUE WHILE
   #         END IF
#No.FUN-A80111 --begin
   #         IF g_apf.apf10 > g_apf.apf08 AND g_chr='3' THEN
   #            CALL t310_tmp_apf09()
   #            LET g_chr ='e'
   #            EXIT WHILE 
   #         END IF
#No.FUN-A80111 --end
   #         IF g_aptype = '34' THEN   #TQC-750139
   #           IF g_chr MATCHES "[12Ee]" THEN EXIT WHILE END IF
   #         ELSE
   #           IF g_chr MATCHES "[123Ee]" THEN EXIT WHILE END IF      
   #         END IF
   #      END WHILE
   #      IF g_chr MATCHES '[Ee]' THEN LET l_exit_sw = 'y' EXIT WHILE END IF
   #      IF g_chr = '1' THEN LET l_exit_sw = 'n' EXIT WHILE END IF
   #      IF g_chr = '2' THEN
   #         LET l_n = ARR_COUNT()
   #         CALL t310_b()
   #      END IF
   #      IF g_chr = '3' THEN
   #         CALL t310_tmp_apf09()         # 轉溢付
   #         EXIT WHILE
   #      END IF
   #   ELSE
   #      CALL t310_tmp_apf09()         # 轉溢付
   #      EXIT WHILE
   #   END IF
   #END WHILE
   #-TQC-B10199-end- 
    IF l_exit_sw = 'y' THEN
       EXIT WHILE
    ELSE
       CONTINUE WHILE
    END IF
    END WHILE
 
    CLOSE t310_bcl
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    IF g_chr = 'E' THEN RETURN END IF
 
   IF g_apf.apf00 = '33' AND g_apz.apz40 = 'N' THEN RETURN END IF
    LET g_success='Y'
    BEGIN WORK
 
    LET l_t1=s_get_doc_no(g_apf.apf01)    #No.FUN-550030
    LET l_apydmy3 = ''
    SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_t1
    IF SQLCA.sqlcode THEN 
    CALL cl_err3("sel","apy_file",l_t1,"",STATUS,"","sel apy.",1)  #No.FUN-660122
    END IF
 
    IF g_add = 'Y' THEN
       IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
             CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'0')
          IF g_aza.aza63 = 'Y' THEN
                CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'1')
          END IF
       END IF
       #如果此處沒做COMMIT WORK或ROLLBACK WORK，則在新增完資料後，資料是屬於鎖住狀態
       #在做EASYFLOW送簽時，會無法更新簽核狀況(除非將程式整個關閉在重新執行aapt331才能更新簽核狀況) 
       #而如果要對資料做變更動作也會無法執行 
       IF g_success='Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       RETURN
    END IF
    #IF g_apf.apf10 <> (g_apf.apf08+g_apf.apf09 ) THEN     #No.FUN-A60024   #MOD-C60006
    IF g_apf.apf10 <> g_apf_t.apf10 OR g_apf.apf08 <> g_apf_t.apf08 OR g_apf.apf09 <> g_apf_t.apf09  THEN     #MOD-C60006
       IF cl_confirm('aap-057') THEN  #MOD-4A0219  
          IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
                CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'0')
             IF g_aza.aza63 = 'Y' THEN
                  CALL t310_g_gl(g_apf.apf00,g_apf.apf01,'1')
             END IF
          END IF
       END IF
    END IF                                                #No.FUN-A60024
    CLOSE t310_cl                    #MOD-C30618 add
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t310_tmp_apf09()            # 轉入暫付
   DEFINE l_t1          LIKE type_file.chr5        # No.FUN-690028 VARCHAR(03)     #No.MOD-6B0141
   DEFINE l_apf10       LIKE apf_file.apf10
   DEFINE l_apf10f      LIKE apf_file.apf10f
   DEFINE l_apf08       LIKE apf_file.apf08
   DEFINE l_apf08f      LIKE apf_file.apf08f
   DEFINE l_cnt         LIKE type_file.num5        #CHI-A10034 add
   DEFINE l_aph14       LIKE aph_file.aph14        #MOD-B10116

   IF g_aptype ='36 'THEN RETURN END IF              #No.FUN-A60024 
  #CHI-A10034---add---start---
   LET l_cnt = 0
   SELECT count(aph13) INTO l_cnt FROM aph_file
    WHERE aph01=g_apf.apf01
      AND aph13 <> g_apf.apf06
   IF l_cnt > 0 THEN
      RETURN
   ELSE
  #CHI-A10034---add---end---
      SELECT apf10f,apf10,apf08f,apf08 INTO l_apf10f,l_apf10,l_apf08f,l_apf08
        FROM apf_file WHERE apf01 = g_apf.apf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","sel apf10,apf08",1)  #No.FUN-660122
         LET g_success = 'N'
      END IF
      IF cl_null(l_apf10f) THEN LET l_apf10f = 0 END IF
      IF cl_null(l_apf10)  THEN LET l_apf10  = 0 END IF  
      LET g_apf.apf09f= l_apf10f - l_apf08f
     #-MOD-B10116-add-
     #IF g_apf.apf09f > 0 AND (g_apf.apf10 - l_apf08) < 0 THEN #TQC-B10199 mark 
      IF g_apf.apf09f > 0 THEN                                 #TQC-B10199
         LET g_sql = "SELECT aph14 ",
                     "  FROM aph_file ",
                     " WHERE aph01 = '",g_apf.apf01,"'",
                     "   AND aph13 = '",g_apf.apf06,"'"
         PREPARE t310_aph14tp2 FROM g_sql
         DECLARE t310_aph14tc2 SCROLL CURSOR WITH HOLD FOR t310_aph14tp2
         OPEN t310_aph14tc2    
         FETCH FIRST t310_aph14tc INTO l_aph14
         IF l_aph14 <> 1 THEN                    #TQC-B10199  
            LET g_apf.apf09 = g_apf.apf09f * l_aph14
        #-TQC-B10199-add-
         ELSE
            LET g_apf.apf09 = l_apf10 -  l_apf08
         END IF 
        #-TQC-B10199-end-
         CALL cl_digcut(g_apf.apf09,g_azi04) RETURNING g_apf.apf09 
     #ELSE       #TQC-B10199 mark
     #-MOD-B10116-end-
        #LET g_apf.apf09 = l_apf10 -  l_apf08 #TQC-B10199 mark
      END IF    #MOD-B10116 
      DISPLAY BY NAME g_apf.apf09f,g_apf.apf09
      UPDATE apf_file SET apf09f= g_apf.apf09f, apf09 = g_apf.apf09
       WHERE apf01 = g_apf.apf01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","up apf09f,apf09",1)  #No.FUN-660122
         LET g_success = 'N'
      END IF
   END IF            #CHI-A10034 add
END FUNCTION
 
FUNCTION t310_tmp_pay(m_apf)            # 轉入暫付
   DEFINE l_apa            RECORD LIKE apa_file.*
   DEFINE m_apf            RECORD LIKE apf_file.*
   DEFINE l_amt            LIKE aph_file.aph05
   DEFINE l_t1             LIKE type_file.chr5     # No.FUN-690028 VARCHAR(03)     #No.MOD-6B0141
   DEFINE p_apa            DYNAMIC ARRAY OF RECORD #No.FUN-680027 add
                 apa01     LIKE apa_file.apa01     #No.FUN-680027 add
                           END RECORD              #No.FUN-680027 add
   DEFINE l_apc            RECORD LIKE apc_file.*  #No.FUN-680027 add
   DEFINE i                LIKE type_file.num5     #No.FUN-680027 add  #No.FUN-690028 SMALLINT
   DEFINE l_cnt            LIKE type_file.num5     #MOD-870048 add
   DEFINE g_t1             LIKE oay_file.oayslip  #FUN-990014 add
   
   IF g_aptype ='36 'THEN RETURN END IF              #No.FUN-A60024
   IF g_apf.apf09 <= 0 THEN RETURN END IF #TQC-B70129 
#No.TQC-B80079 --begin
#   DECLARE t310_tmp_apc CURSOR FOR                                                                                          
#     SELECT apa01 FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'                                                     
#                                  AND apa02 <= g_apf.apf02          #MOD-A30146 add
#   LET i=1                                                                                                                 
#   FOREACH t310_tmp_apc INTO p_apa[i].apa01                                                                                 
#      LET i=i+1                                                                                                           
#   END FOREACH                                                                                                             
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt FROM apa_file
#    WHERE apa08=m_apf.apf01 AND apa00='24'
#      AND apa02 <= g_apf.apf02          #MOD-A30146 add
#   IF l_cnt > 0 THEN
#      DELETE FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'
#                             AND apa02 <= g_apf.apf02          #MOD-A30146 add
#      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_success = 'N'
#        #CALL cl_err3("del","apa_file",m_apf.apf01,"",SQLCA.sqlcode,"","t310_tmp_pay",1) #CHI-A60034 mark
#         CALL s_errmsg('apf01',m_apf.apf01,"del apa_file:t310_tmp_pay",SQLCA.sqlcode,1) #CHI-A60034
#      END IF
#      IF SQLCA.sqlcode=0 THEN
#         FOR i=1 TO p_apa.getLength()
#            IF cl_null(p_apa[i].apa01) THEN CONTINUE FOR END IF                                                                      
#            LET l_cnt = 0
#            SELECT COUNT(*) INTO l_cnt FROM apc_file
#             WHERE apc01=p_apa[i].apa01
#            IF l_cnt > 0 THEN
#               DELETE FROM apc_file WHERE apc01=p_apa[i].apa01                                                                       
#               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
#                 #CALL cl_err3("del","apc_file",p_apa[i].apa01,"",SQLCA.sqlcode," ","del apc_file",1)  #CHI-A60034 mark                                                 
#                  CALL s_errmsg('apa01',p_apa[i].apa01,"del apc_file",SQLCA.sqlcode,1) #CHI-A60034
#                  LET g_success = 'N'   #FUN-890128
#               END IF                                                                                                             
#            END IF   #MOD-870048 add
#         END FOR                
#      END IF                                                                                                 
#   END IF   #MOD-870048 add
#No.TQC-B80079 --end  

   INITIALIZE l_apa.* TO NULL
 
   LET l_t1=s_get_doc_no(m_apf.apf01)    #No.FUN-550030
   SELECT apydmy4 INTO g_apy.apydmy4 FROM apy_file WHERE apyslip = l_t1
   IF cl_null(g_apy.apydmy4) THEN
     #CALL cl_err('','aap-295',1) #CHI-A60034 mark
      CALL s_errmsg('','','','aap-295',1) #CHI-A60034
      LET g_success = 'N'
      RETURN
   END IF
   SELECT pmc17 INTO l_apa.apa11 FROM pmc_file
    WHERE pmc01=m_apf.apf03
   IF cl_null(l_apa.apa11) THEN
     #CALL cl_err('','aap-720',1) #CHI-A60034 mark
      CALL s_errmsg('','','','aap-720',1) #CHI-A60034
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_apa.apa00 = '24'
   LET l_apa.apa01 = m_apf.apf01
   LET l_apa.apa01[1,g_doc_len] = g_apy.apydmy4   #MOD-580041
   LET l_apa.apa02 = m_apf.apf02
   LET l_apa.apa05 = m_apf.apf03 #MOD-990221     
   LET l_apa.apa06 = m_apf.apf03
   LET l_apa.apa07 = m_apf.apf12
   LET l_apa.apa08 = m_apf.apf01
   LET l_apa.apa13 = m_apf.apf06
   LET l_apa.apa14 = m_apf.apf09/m_apf.apf09f
  #------------------MOD-CA0072-------------------mark
  #SELECT azi07 INTO t_azi07 FROM azi_file
  #  WHERE azi01= l_apa.apa13
  #LET l_apa.apa14 = cl_digcut(l_apa.apa14,t_azi07)
  #------------------MOD-CA0072-------------------mark
   LET l_apa.apa16 = 0
   LET l_apa.apa20 = 0
   LET l_apa.apa21 = m_apf.apf04
   LET l_apa.apa22 = m_apf.apf05
  #LET l_apa.apa31f= m_apf.apf10f- m_apf.apf08f  #TQC-750139 #MOD-B10116 mark
   LET l_apa.apa31f= m_apf.apf09f                #MOD-B10116
   LET l_apa.apa32f= 0
   LET l_apa.apa33f= 0
   LET l_apa.apa35f= 0
  #LET l_apa.apa31 = m_apf.apf10 - m_apf.apf08   #TQC-750139 #MOD-B10116 mark
   LET l_apa.apa31 = m_apf.apf09                 #MOD-B10116
   LET l_apa.apa32 = 0
   LET l_apa.apa33 = 0
   LET l_apa.apa35 = 0
  #LET l_apa.apa34f= m_apf.apf10f- m_apf.apf08f  #MOD-B10116 mark
   LET l_apa.apa34f= m_apf.apf09f                #MOD-B10116 
  #LET l_apa.apa34 = m_apf.apf10 - m_apf.apf08   #MOD-B10116 mark
   LET l_apa.apa34 = m_apf.apf09                 #MOD-B10116
   LET l_apa.apa54 = g_aps.aps13
   LET l_apa.apa41 = 'Y'
   LET l_apa.apa42 = 'N'
   LET l_apa.apa57f= 0
   LET l_apa.apa57 = 0
   LET l_apa.apa65f= 0
   LET l_apa.apa65 = 0
   LET l_apa.apa60f= 0
   LET l_apa.apa60 = 0
   LET l_apa.apa61f= 0
   LET l_apa.apa61 = 0
   LET l_apa.apaacti ='Y'
   LET l_apa.apauser = m_apf.apfuser
   LET l_apa.apagrup = m_apf.apfgrup
   LET l_apa.apamodu = ' '
   LET l_apa.apadate = ' '
   LET l_apa.apainpd = m_apf.apfinpd
   LET l_apa.apa74 = 'N'
   LET l_apa.apa75 = 'N'
   LET l_apa.apa72 = l_apa.apa14
   LET l_apa.apa930=s_costcenter(l_apa.apa22)  #FUN-670064
   LET l_apa.apa79 ='3'                        #No.FUN-A40003 FUN-A80111 溢付
   CALL t310_comp_oox(l_apa.apa01) RETURNING g_net
   LET l_apa.apa73 = l_apa.apa34-l_apa.apa35 + g_net
   IF g_apz.apz13 = 'Y' THEN
      SELECT aps13,aps131 INTO l_apa.apa54,l_apa.apa541 FROM aps_file WHERE aps01 = m_apf.apf05   #No.TQC-7C0140 add aps131->apa541
   ELSE
      SELECT aps13,aps131 INTO l_apa.apa54,l_apa.apa541 FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)  #No.TQC-7C0140 add aps131->apa541
   END IF
   LET l_apa.apaprno = 0   #MOD-830072
   LET l_apa.apalegal = g_legal  #FUN-980001 add
   CALL s_get_doc_no(l_apa.apa01) RETURNING g_t1
   SELECT apyvcode INTO l_apa.apa77  FROM apy_file WHERE apyslip = g_t1   
     IF cl_null(l_apa.apa77) THEN 
        LET l_apa.apa77 = g_apz.apz63  #FUN-970108 add
     END IF     
   LET l_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO apa_file VALUES (l_apa.*)
   IF SQLCA.sqlcode THEN
     #CALL cl_err3("ins","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","ins tmp_pay",1)  #No.FUN-660122 #CHI-A60034 mark
      CALL s_errmsg('apa01',l_apa.apa01,"ins apa_file:tmp_pay",SQLCA.sqlcode,1) #CHI-A60034
      LET g_success = 'N'
   ELSE
      INITIALIZE l_apc.* TO NULL
      LET l_apc.apc01 = l_apa.apa01
      LET l_apc.apc02 = 1
      LET l_apc.apc03 = l_apa.apa11
      LET l_apc.apc04 = l_apa.apa12
      LET l_apc.apc05 = l_apa.apa64
      LET l_apc.apc06 = l_apa.apa14
      LET l_apc.apc07 = l_apa.apa72
      LET l_apc.apc08 = l_apa.apa34f
      LET l_apc.apc09 = l_apa.apa34
      LET l_apc.apc10 = l_apa.apa35f
      LET l_apc.apc11 = l_apa.apa35
      LET l_apc.apc12 = l_apa.apa08
      LET l_apc.apc13 = l_apa.apa73
      LET l_apc.apc14 = l_apa.apa65f
      LET l_apc.apc15 = l_apa.apa65
      LET l_apc.apc16 = l_apa.apa20
      LET l_apc.apclegal = g_legal #FUN-980001 add
      INSERT INTO apc_file VALUES(l_apc.*)
      IF SQLCA.sqlcode THEN
        #CALL cl_err3("ins","apc_file",l_apa.apa01,"1",SQLCA.sqlcode,"","ins apc_file",1) #CHI-A60034 mark 
         CALL s_errmsg('apa01',l_apa.apa01,"ins apc_file",SQLCA.sqlcode,1) #CHI-A60034
         LET g_success = 'N'
      END IF
   END IF
   LET m_apf.apf09f= m_apf.apf10f- m_apf.apf08f
   LET m_apf.apf09 = m_apf.apf10 - m_apf.apf08
   DISPLAY BY NAME m_apf.apf09f,m_apf.apf09
 
   UPDATE apf_file SET apf09f= m_apf.apf09f,apf09 = m_apf.apf09
    WHERE apf01 = m_apf.apf01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #CALL cl_err3("upd","apf_file",m_apf.apf01,"",SQLCA.sqlcode,"","up apf09f,apf09",1)  #No.FUN-660122 #CHI-A60034 mark
      CALL s_errmsg('apf01',m_apf.apf01,"up apf09f,apf09",SQLCA.sqlcode,1) #CHI-A60034
      LET g_success = 'N'
   END IF
 
   CALL cl_getmsg('aap-080',g_lang) RETURNING g_msg
   LET g_msg=g_msg CLIPPED,l_apa.apa01,' ! '
   CALL cl_msgany(10,20,g_msg)   #FUN-890128
 
END FUNCTION
 
FUNCTION t310_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    CLEAR azp02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON apg02,apg04,apg06,apg05f     #FUN-990031
            FROM s_apg[1].apg02,s_apg[1].apg04,    #FUN-990031 
                 s_apg[1].apg06,s_apg[1].apg05f         #No.FUN-680027 add apg06
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t310_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t310_b_fill(p_wc2)
DEFINE
    p_wc2           STRING #No.FUN-690028 VARCHAR(200) #MOD-BB0305 mod 1000 -> STRING
    
 
   LET g_sql = "SELECT apg02,apg04,apg06,'','','',apg05f,apg05,",    #FUN-990031
                "       apgud01,apgud02,apgud03,apgud04,apgud05,",
                "       apgud06,apgud07,apgud08,apgud09,apgud10,",
                "       apgud11,apgud12,apgud13,apgud14,apgud15", 
                "  FROM apg_file",
                " WHERE apg01 ='",g_apf.apf01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t310_pb FROM g_sql
    DECLARE apg_curs                       CURSOR FOR t310_pb
 
    CALL g_apg.clear()
    LET l_ac = 1
    LET g_note_days = 0
    FOREACH apg_curs INTO g_apg[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
          CALL s_getdbs()
          LET g_sql = "SELECT apa02,apa13,apa14 ",
                      " FROM apa_file ",   #FUN-990031
                      "WHERE apa01 = ? ",
                      "  AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          PREPARE t310_str6 FROM g_sql
          IF STATUS THEN
             CALL cl_err('change dbs_6 error',status,1)
             LET g_success='N'
             EXIT FOREACH
          END IF
          DECLARE z9_curs CURSOR FOR t310_str6
          OPEN z9_curs USING g_apg[l_ac].apg04
          FETCH z9_curs INTO g_apg[l_ac].apa02,g_apg[l_ac].apa13,g_apg[l_ac].apa14
          
          CLOSE z9_curs
          CALL t310_apg04('d')
          LET g_apg[l_ac].apa14=g_apg[l_ac].apg05/g_apg[l_ac].apg05f #add by dengsy170306
          LET g_add_entry='Y'
       LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
  EXIT FOREACH
      END IF
    END FOREACH
    CALL g_apg.deleteElement(l_ac)
    LET g_rec_b = l_ac-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
#No.FUN-A60024 --begin
FUNCTION t310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN  #FUN-D30032
   IF p_ud <> "G" OR g_action_choice = "account_detail" OR g_action_choice = "payment_detail" THEN  #FUN-D30032
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()

   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_apg TO s_apg.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            IF g_aza.aza63 = 'Y' THEN 
               CALL cl_set_act_visible("entry_sheet2",TRUE)
            ELSE
               CALL cl_set_act_visible("entry_sheet2",FALSE) 
            END IF
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='1'
                        
         AFTER DISPLAY
            CONTINUE DIALOG
      
        #ON ACTION controls                       #No.FUN-6B0033 #MOD-C20058 mark(同個function 不可有二個)                                                                      
        #   CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033 #MOD-C20058 mark
      
        #FUN-D10057--add--str--
         ON ACTION payable_sel #雜項應付/待抵查詢
            LET g_action_choice="payable_sel"
            LET g_str=" '' '' '",g_apf.apf01,"' '' "
            EXIT DIALOG
         #FUN-D10057--add--end
      END DISPLAY
      
      DISPLAY ARRAY g_aph TO s_aph.* ATTRIBUTE(COUNT=g_rec_b2)
      
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL cl_show_fld_cont()
            LET g_b_flag='2'
            
         BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
         #FUN-D10057--add--str--
         ON ACTION payable_sel #雜項應付/待抵查詢
            LET g_action_choice="payable_sel"
            LET g_str="'",g_aph[l_ac].aph23,"' 'query' '' '' "
            EXIT DIALOG
         #FUN-D10057--add--end

      END DISPLAY 
   
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
         CALL t310_fetch('F')
#         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DIALOG
 
      ON ACTION previous
         CALL t310_fetch('P')
#         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DIALOG
 
      ON ACTION jump
         CALL t310_fetch('/')
#         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DIALOG
 
      ON ACTION next
         CALL t310_fetch('N')
#         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DIALOG
 
      ON ACTION last
         CALL t310_fetch('L')
#         ACCEPT DISPLAY   #FUN-530067(smin)
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
         IF g_apf.apf41 = 'X' THEN
            LET g_void = 'Y' ELSE LET g_void = 'N'
         END IF
         IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
 
         CALL t310_set_comb()
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
#No.FUn-A60024 --begin
#TQC-AC0409 ---------------Begin----------remark---------
      ON ACTION account_detail #帳款單身
         LET g_action_choice="account_detail"
         EXIT DIALOG
#TQC-AC0409 --------------End-------------remark---------
 
#      ON ACTION qry_account_detail #帳款單身
#         LET g_action_choice="qry_account_detail"
#         EXIT DIALOG
 
#TQC-AC0409 ---------------Begin----------remark---------
      ON ACTION payment_detail #付款單身
         LET g_action_choice="payment_detail"
         EXIT DIALOG
#TQC-AC0409 --------------End-------------remark---------
#No.FUn-A60024 --end 
      ON ACTION gen_entry #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DIALOG
 
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DIALOG
 
      ON ACTION entry_sheet2  #分錄底稿
         LET g_action_choice="entry_sheet2"
         EXIT DIALOG
 
      ON ACTION memo     #備註
         LET g_action_choice="memo"
         EXIT DIALOG
 
      ON ACTION easyflow_approval            #MOD-4A0299
        LET g_action_choice = "easyflow_approval"
        EXIT DIALOG
 
      ON ACTION confirm     #確認
         LET g_action_choice="confirm"
         EXIT DIALOG
 
      ON ACTION undo_confirm     #取消確認
         LET g_action_choice="undo_confirm"
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
 
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DIALOG

      #FUN-D20035---add--str
      #取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20035---add---end 

      ON ACTION accept
        #LET g_action_choice="payment_detail"  #TQC-AC0409      #TQC-B10199 mark
        #-TQC-B10199-add-
         IF g_b_flag = '1' THEN
            LET g_action_choice="account_detail"      
         ELSE
            LET g_action_choice="payment_detail"  
         END IF 
        #-TQC-B10199-end-
       # LET g_action_choice="detail"          #No.FUN-A60024   #TQC-AC0409
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION ExportToExcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apg),base.TypeInfo.create(g_aph),'')
         EXIT DIALOG
 
    #@ON ACTION 簽核狀況
      ON ACTION approval_status    #FUN-640181
         LET g_action_choice="approval_status"
         EXIT DIALOG
 
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DIALOG
    
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DIALOG
 
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
      
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
#No.FUN-A30106 --begin                                                          
      ON ACTION drill_down                                                      
         LET g_action_choice="drill_down"                                       
         EXIT DIALOG                                                           
#No.FUN-A30106 --end 
      #CHI-AA0003 add --start--
      ON ACTION handling_differences
         LET g_action_choice="handling_differences"
         EXIT DIALOG
      #CHI-AA0003 add --end--
#str---add by huanglf160826
      ON ACTION first_confirm
         LET g_action_choice="first_confirm"
         EXIT DIALOG
#str---end by huanglf160826
 #str------ add by maoyy20160905
       ON ACTION weiyue                                                     
          LET g_action_choice="weiyue"                                       
         EXIT DIALOG
      #end------ add by maoyy20160905
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUNCTION t310_bp(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
# 
# 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_apg TO s_apg.* ATTRIBUTE(COUNT=g_rec_b)
#      BEFORE DISPLAY
#         IF g_aza.aza63 = 'Y' THEN 
#            CALL cl_set_act_visible("entry_sheet2",TRUE)
#         ELSE
#            CALL cl_set_act_visible("entry_sheet2",FALSE) 
#         END IF
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      ON ACTION controls                       #No.FUN-6B0033                                                                       
#         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
# 
#   END DISPLAY
# 
#   DISPLAY ARRAY g_aph TO s_aph.* ATTRIBUTE(COUNT=g_rec_b2)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#      BEFORE ROW
#      LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
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
#         CALL t310_fetch('F')
#         ACCEPT DISPLAY   #FUN-530067(smin)
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL t310_fetch('P')
#         ACCEPT DISPLAY   #FUN-530067(smin)
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL t310_fetch('/')
#         ACCEPT DISPLAY   #FUN-530067(smin)
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL t310_fetch('N')
#         ACCEPT DISPLAY   #FUN-530067(smin)
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL t310_fetch('L')
#         ACCEPT DISPLAY   #FUN-530067(smin)
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
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         IF g_apf.apf41 = 'X' THEN
#            LET g_void = 'Y' ELSE LET g_void = 'N'
#         END IF
#         IF g_apf.apf42 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#         CALL cl_set_field_pic(g_apf.apf41,g_chr2,"","",g_void,g_apf.apfacti)
# 
#         CALL t310_set_comb()
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#      ON ACTION account_detail #帳款單身
#         LET g_action_choice="account_detail"
#         EXIT DISPLAY
# 
#      ON ACTION qry_account_detail #帳款單身
#         LET g_action_choice="qry_account_detail"
#         EXIT DISPLAY
# 
#      ON ACTION payment_detail #付款單身
#         LET g_action_choice="payment_detail"
#         EXIT DISPLAY
# 
#      ON ACTION gen_entry #會計分錄產生
#         LET g_action_choice="gen_entry"
#         EXIT DISPLAY
# 
#      ON ACTION entry_sheet  #分錄底稿
#         LET g_action_choice="entry_sheet"
#         EXIT DISPLAY
# 
#      ON ACTION entry_sheet2  #分錄底稿
#         LET g_action_choice="entry_sheet2"
#         EXIT DISPLAY
# 
#      ON ACTION memo     #備註
#         LET g_action_choice="memo"
#         EXIT DISPLAY
# 
#      ON ACTION easyflow_approval            #MOD-4A0299
#        LET g_action_choice = "easyflow_approval"
#        EXIT DISPLAY
# 
#      ON ACTION confirm     #確認
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
# 
#      ON ACTION undo_confirm     #取消確認
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
# 
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
# 
#      ON ACTION void   #作廢
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="payment_detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#             LET INT_FLAG=FALSE   #MOD-570244 mars
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
#      ON ACTION ExportToExcel
#         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apg),base.TypeInfo.create(g_aph),'')
#         EXIT DISPLAY
# 
#    #@ON ACTION 簽核狀況
#      ON ACTION approval_status    #FUN-640181
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
# 
#      ON ACTION carry_voucher #傳票拋轉
#         LET g_action_choice="carry_voucher"
#         EXIT DISPLAY
#    
#      ON ACTION undo_carry_voucher #傳票拋轉還原
#         LET g_action_choice="undo_carry_voucher"
#         EXIT DISPLAY
# 
#      ON ACTION related_document                #No.FUN-6A0016  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
#      
#      ON ACTION controls                       #No.FUN-6B0033                                                                       
#         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
# 
#      &include "qry_string.4gl"
##No.FUN-A30106 --begin                                                          
#      ON ACTION drill_down                                                      
#         LET g_action_choice="drill_down"                                       
#         EXIT DISPLAY                                                           
##No.FUN-A30106 --end 
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#No.FUN-A60024 --end
 
FUNCTION t310_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING #No.FUN-690028 VARCHAR(200) #MOD-BB0305 mod 1000 -> STRING
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
#FUN-A20010 --Begin                                                                                                                 
#   LET g_sql = "SELECT aph02,aph03,aph08,aph18,aph19,aph04,aph041,aph17,aph16,'',aph07,aph09,aph13,aph14,",   #MOD-590054
#               "       aph05f,aph05,", 
    LET g_sql = "SELECT aph02,aph03,aph26,'',aph21,aph25,aph22,'',aph08,aph04,aph041,aph17,aph23,aph24,aph16,'',aph07,aph09,aph13,aph14,",   #MOD-590054   #TQC-5B0021    #No.FUN-FUN-970077  FUN-A90007 add aph21,'',aph22,''   aph23,aph24 #FUN-CB0065 add aph26,''
                "       aph05f,aph05,aph18,aph19,aph20,", #CHI-CA0054 ' '--->aph25
#FUN-A20010 --End
                "       aphud01,aphud02,aphud03,aphud04,aphud05,",
                "       aphud06,aphud07,aphud08,aphud09,aphud10,",
                "       aphud11,aphud12,aphud13,aphud14,aphud15", 
                " FROM aph_file",
                " WHERE aph01 ='",g_apf.apf01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t310_pb2 FROM g_sql
    DECLARE aph_curs CURSOR FOR t310_pb2
 
    CALL g_aph.clear()
    LET g_cnt = 1
    FOREACH aph_curs INTO g_aph[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach.',STATUS,1)
          EXIT FOREACH
       END IF
#No.FUN-A90007 --begin
       #SELECT pmc03 INTO g_aph[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_aph[g_cnt].aph21
       #CHI-CA0054 add
       IF cl_null(g_aph[g_cnt].aph25)  THEN 
       	  SELECT pmc03 INTO g_aph[g_cnt].aph25 FROM pmc_file WHERE pmc01 = g_aph[g_cnt].aph21 
       END IF 	 
       #CHI-CA0054 add       
       SELECT apr02 INTO g_aph[g_cnt].apr02 FROM apr_file WHERE apr01 = g_aph[g_cnt].aph22
#No.FUN-A90007 --end
          SELECT nmc02 INTO g_aph[g_cnt].nmc02 FROM nmc_file
             WHERE nmc01 = g_aph[g_cnt].aph16
       #FUN-CB0065--add--str--
       IF NOT cl_null(g_aph[g_cnt].aph26) THEN
          SELECT gen02 INTO g_aph[g_cnt].aph26_desc 
          FROM gen_file WHERE gen01=g_aph[g_cnt].aph26 
       END IF
       #FUN-CB0065--add--end
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_aph.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
FUNCTION t310_out(p_cmd)
   DEFINE l_cmd                LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          z1,z2                LIKE type_file.chr1000, # No.FUN-690028 VARCHAR(70),
          l_wc          STRING, #No.FUN-690028 VARCHAR(200)   #MOD-BB0305 mod 1000 -> STRING
          p_cmd         LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   CALL cl_wait()
   --LET p_cmd= 'a'
   --IF p_cmd= 'a' THEN
      --LET l_wc = 'apf01="',g_apf.apf01,'"'             # "新增"則印單張
   --ELSE
      --LET l_wc = g_wc CLIPPED,                              # 其他則印多張
                 --"   AND apf00 = '",g_aptype,"'"
   --END IF
   --IF l_wc IS NULL THEN CALL cl_err('','9057',0) END IF
  # LET l_cmd = "aapr311",  #FUN-C30085 mark
   --LET l_cmd = "aapg311",  #FUN-C30085 add  
               --" '",g_today CLIPPED,"' ''",
               --" '",g_lang CLIPPED,"' 'Y' '' '1' '",
            #  l_wc CLIPPED,"' '",g_aptype,"' 'Y' 'N' 'N' 'N' "   #TQC-C40194 MARK
               --l_wc CLIPPED,"' '",g_aptype,"' 'Y' 'Y' 'N' 'N' "   #TQC-C40194 ADD   
   --CALL cl_cmdrun(l_cmd)
   --ERROR ' '
   #str---add by huanglf160818
          LET l_wc = 'apf01="',g_apf.apf01,'"' 
              LET g_msg = "capr330", 
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                       " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
        CALL cl_cmdrun(g_msg)
 
   #str---end by huanglf160818
END FUNCTION
 
FUNCTION t310_m()
   DEFINE i,j       LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_cnt     LIKE type_file.num5    #MOD-870048 add
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02   LIKE apd_file.apd02,
                    apd03   LIKE apd_file.apd03
                    END RECORD,
   l_allow_insert   LIKE type_file.num5,   #可新增否  #No.FUN-690028 SMALLINT
   l_allow_delete   LIKE type_file.num5    #可刪除否  #No.FUN-690028 SMALLINT
 
   IF g_apf.apf01 IS NULL THEN RETURN END IF
   
   IF g_apf.apf42 matches '[Ss]' THEN 
       RETURN
   END IF
   
   OPEN WINDOW t310_m_w AT 8,30 WITH FORM "aap/42f/aapt310_3"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt310_3")
 
   DECLARE t310_m_c CURSOR FOR
           SELECT apd02,apd03 FROM apd_file
            WHERE apd01 = g_apf.apf01
            ORDER BY apd02
   LET i = 1
   FOREACH t310_m_c INTO g_apd[i].*
      LET i = i + 1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_apd.deleteElement(i)
   LET g_rec_b = i - 1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_apd WITHOUT DEFAULTS FROM s_apd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE INPUT        #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT                   #TQC-860021
   CLOSE WINDOW t310_m_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
 
   WHILE TRUE
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apd_file WHERE apd01 = g_apf.apf01
      IF l_cnt > 0 THEN
         DELETE FROM apd_file WHERE apd01 = g_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            LET g_success = 'N'
            CALL cl_err3("del","apd_file",g_apf.apf01,"",SQLCA.sqlcode,"","t310_m(ckp#1).",1)  #No.FUN-660122
            EXIT WHILE
         END IF
      END IF   #MOD-870048 add
      FOR i = 1 TO g_apd.getLength()
         IF g_apd[i].apd03 IS NULL THEN CONTINUE FOR END IF
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add legal
                VALUES(g_apf.apf01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add legal
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("ins","apd_file",g_apf.apf01,"",SQLCA.sqlcode,"","t310_m(ckp#2).",1)  #No.FUN-660122
            EXIT WHILE
         END IF
      END FOR
      EXIT WHILE
   END WHILE
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t310_firm1_chk()
   DEFINE l_aph03 LIKE aph_file.aph03,   #MOD-640216   
          l_aph16 LIKE aph_file.aph16,   #MOD-A90129
          l_aph21 LIKE aph_file.aph21,   #TQC-B30220   
          l_sql   STRING   #MOD-640216
   DEFINE l_cnt   LIKE type_file.num5   #MOD-6A0059
   DEFINE l_nmc05   LIKE nmc_file.nmc05   #MOD-C20117
   DEFINE l_nmz70   LIKE nmz_file.nmz70   #TQC-C60067
   DEFINE l_nmz71   LIKE nmz_file.nmz71   #TQC-C60067
   #FUN-C90122--add--str--
   DEFINE l_aph04  LIKE aph_file.aph04,
          l_aph05f LIKE aph_file.aph05f,
          l_nmd04  LIKE nmd_file.nmd04,
          l_nmd55  LIKE nmd_file.nmd55
   #FUN-C90122--add--end
   
   #LET g_success = 'Y'           #TQC-B10069
 
#FUN-DA0054 --- add --- begin “转账” “票据” “收票转让”转付”单据日期不可大于票据关帐日期
         IF g_aptype = '33' THEN
         LET l_cnt=0 
         SELECT count(*) INTO l_cnt from aph_file where aph01=g_apf.apf01 and aph03 in ('1','2','D')
         IF l_cnt>0 THEN 
         LET g_nmz10 = ''
            SELECT nmz10 INTO g_nmz10 FROM nmz_file
            #IF g_nmz10 > g_apf.apf02 THEN
            IF g_nmz10 >= g_apf.apf02 THEN   #MOD-DB0017
               CALL cl_err('','cxr-072',1)
               LET g_success = 'N'
 						     RETURN
            END IF
          END IF
         END IF
#FUN-DA0054 --- add --- end
 #str----- add by maoyy20160905
   #IF g_apf.apfud02<>'Y' THEN  #mark by dengsy170302
   IF g_apf.apfud02<>'Y' AND g_prog='aapt330' THEN  #add by dengsy170302
      CALL s_errmsg('','','','aap_345',1)
      LET g_success = 'N'  
   END IF 
   #end----- add by maoyy20160905
   IF g_apf.apf08+g_apf.apf09 = 0 AND g_apf.apf10 = 0 THEN 
   #  CALL cl_err(g_apf.apf01,'aap-600',0)              #TQC-B10069
      CALL s_errmsg('apf01',g_apf.apf01,'','aap-600',1) #TQC-B10069
      LET g_success = 'N'
      RETURN
   ELSE
      IF g_apf.apf08+g_apf.apf09 != 0 THEN   #CHI-850001
         IF g_apf.apf08+g_apf.apf09 != g_apf.apf10  THEN 
         #  CALL cl_err(g_apf.apf01,'aap-603',0)              #TQC-B10069  
            CALL s_errmsg('apf01',g_apf.apf01,'','aap-603',1) #TQC-B10069
            LET g_success = 'N'
            RETURN
         END IF 
      END IF   #CHI-850001
   END IF 
 
   #No.yinhy131206  --Begin
   IF g_aptype = '33' THEN
   	  IF g_apf.apf10 < g_apf.apf08 THEN 
   	  	 CALL s_errmsg('apf01',g_apf.apf01,'','aap-318',1) 
         LET g_success = 'N'
         RETURN
   	  END IF
   END IF
   IF g_aptype = '32' THEN
   	  IF g_apf.apf10 > g_apf.apf08 THEN 
   	  	 CALL s_errmsg('apf01',g_apf.apf01,'','aap-251',1) 
         LET g_success = 'N'
         RETURN
   	  END IF
   END IF
   #No.yinhy131206  --End
 
   IF g_apf.apf41 = 'X' THEN
   #  CALL cl_err('','9024',0)        #TQC-B10069
      CALL s_errmsg('apf01',g_apf.apf01,g_apf.apf41,'9024',1) #TQC-B10069
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_apf.apf41 = 'Y' THEN
   #  CALL cl_err('','9023',0)        #TQC-B10069
      CALL s_errmsg('apf01',g_apf.apf01,g_apf.apf41,'9023',1) #TQC-B10069 
      LET g_success = 'N'
      RETURN
   END IF
  
   SELECT nmz70,nmz71 INTO l_nmz70,l_nmz71 FROM nmz_file WHERE nmz00 = '0'  #TQC-C60067
   
  #LET l_sql = "SELECT aph03 FROM aph_file WHERE aph01 = '",g_apf.apf01,"'"        #MOD-A90129 mark
   LET l_sql = "SELECT aph03,aph16,aph21 FROM aph_file WHERE aph01 = '",g_apf.apf01,"'"  #MOD-A90129 #TQC-B50029 add aph21
   PREPARE aph03_p FROM l_sql
   DECLARE aph03_c CURSOR FOR aph03_p
  #FOREACH aph03_c INTO l_aph03                           #MOD-A90129 mark
   FOREACH aph03_c INTO l_aph03,l_aph16,l_aph21           #MOD-A90129     #TQC-B50029 add aph21
    #No.MOD-C20117  --Begin
    IF cl_null(g_apf.apf14) THEN
       SELECT nmc05 INTO l_nmc05 FROM nmc_file
        WHERE nmc01 = l_aph16
    END IF
    #No.MOD-C20117  --End
    #IF l_aph03 = '2' AND cl_null(g_apf.apf14) THEN  #TQC-B20092
    #IF l_aph03 = '2' AND cl_null(g_apf.apf14) AND g_aptype<>'32' AND g_aptype<>'36' THEN  #TQC-B20092
     IF l_nmz71 = 'N' OR (l_nmz71 = 'Y' AND l_nmz70 = '1') THEN   #TQC-C60067
        IF l_aph03 = '2' AND cl_null(g_apf.apf14) AND cl_null(l_nmc05) AND g_aptype<>'32' AND g_aptype<>'36' THEN  #MOD-C20117
        #  CALL cl_err('','aap-101',1)                            #TQC-B10069
           CALL s_errmsg('aph03',g_apf.apf01,l_aph03,'aap-101',1) #TQC-B10069
           LET g_success = 'N'
           RETURN 
        END IF
     END IF       #TQC-C60067
    #-MOD-A90129-add-
    #IF l_aph03 = '2' AND cl_null(l_aph16) THEN #TQC-B20092
     IF l_aph03 = '2' AND cl_null(l_aph16) AND g_aptype <>'32' AND g_aptype<>'36' THEN #TQC-B20092
     #  CALL cl_err('','aap-307',1)                            #TQC-B10069
        CALL s_errmsg('aph03',g_apf.apf01,l_aph03,'aap-307',1) #TQC-B10069
        LET g_success = 'N'
        RETURN       
     END IF
    #-MOD-A90129-end-
    #No.TQC-B30220 --Begin

     IF g_aptype = '36' AND cl_null(l_aph21) THEN
         IF l_aph03<>'4' AND l_aph03<>'5' THEN  #add by lixiaa20160902
            CALL s_errmsg('aph21','','','aapt006',1) 
            LET g_success = 'N' 
            RETURN       
         END IF                                #add by lixiaa20160902
     END IF
   
     #No.TQC-B30220 --End
   END FOREACH
  
  #FUN-C90122--add--str--
   IF g_aptype='33' THEN
      LET l_sql="SELECT aph04,SUM(aph05f) FROM aph_file ",
                " WHERE aph01='",g_apf.apf01,"'",
                "   AND aph03='F' ",
                " GROUP BY aph04 "
      PREPARE sel_aph_pr1 FROM l_sql
      DECLARE sel_aph_cr1 CURSOR FOR sel_aph_pr1
      FOREACH sel_aph_cr1 INTO l_aph04,l_aph05f
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','',SQLCA.sqlcode,0)
            LET g_success='N'
            EXIT FOREACH
         END IF
         SELECT nmd04,nmd55 INTO l_nmd04,l_nmd55 FROM nmd_file
         WHERE nmd01=l_aph04
         IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
         IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
         IF l_nmd04<l_nmd55+l_aph05f THEN
            CALL s_errmsg('','',l_aph04,'aap-269',0)
            LET g_success='N'
         END IF
      END FOREACH
   END IF
   #FUN-C90122--add--end

  #CHI-B10042 add --start--
  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  
  THEN
     IF g_apf.apfmksg='Y' THEN
        IF g_apf.apf42 != '1' THEN
           CALL s_errmsg('apf01',g_apf.apf01,g_apf.apf42,'aws-078',1) 
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
  #CHI-B10042 add --end--
  #str---add by huanglf160826
  IF g_apf.apfud02 = 'N' AND g_prog='aapt330'  THEN   #add aapt332 by kuangxj171012 
     LET g_success = 'N'
     RETURN
  END IF 
  #str---end by huanglf160826
 
END FUNCTION
 
#No.CHI-A80036   ---begin---
FUNCTION t310_firm1_chk1()
 DEFINE  only_one  LIKE type_file.chr1 
 DEFINE  l_amt     LIKE type_file.num20_6     #MOD-AB0197 
 
   #LET g_success = 'Y'            #TQC-B10069
   LET only_one = '1'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640240
   THEN
    #CHI-B10042 mark --start--
    # IF g_action_choice="confirm" THEN                                                                                             
    #    IF g_apf.apfmksg='Y' THEN                                                                                                  
    #       IF g_apf.apf42 NOT matches '[1]' THEN      #FUN-920104 add   
    #       #  CALL cl_err('','aws-078',1)             #FUN-920104 add    #TQC-B10069
    #          CALL s_errmsg('apf01',g_apf.apf01,g_apf.apf42,'aws-078',1) #TQC-B10069                                                                           
    #          LET g_success = 'N'                                                                                                  
    #          RETURN                                                                                                               
    #       END IF                                                                                                                  
    #    END IF                                                                                                                     
    # ELSE                                                                                                                          
    #CHI-B10042 mark --end--  
      IF g_action_choice CLIPPED = "insert" THEN  #CHI-B10042 add
        IF g_apf.apfmksg='Y' THEN
           IF g_apf.apf42 != '1' THEN
           #  CALL cl_err('','aws-078',1)         #TQC-B10069
              CALL s_errmsg('apf01',g_apf.apf01,g_apf.apf42,'aws-078',1) #TQC-B10069 
              LET g_success = 'N'
              RETURN
           END IF
        END IF
      END IF
 
      OPEN WINDOW t310_w6 AT 8,6 WITH FORM "aap/42f/aapt310_6"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("aapt310_6")
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
               IF only_one = '1' AND g_apf.apf01 IS NULL OR g_apf.apf01= ' ' THEN
                  NEXT FIELD only_one
               END IF
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
 
         ON ACTION controls                       #No.FUN-6B0033                                                                       
            CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t310_w6
         LET g_success ='N'   #No.FUN-A90007
         RETURN
      END IF
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " apf01 = '",g_apf.apf01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
 
      CONSTRUCT BY NAME g_wc ON apf44,apf01,apf02,apf04,apf05
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(apf01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_apf1"
                    LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf01
                    NEXT FIELD apf01
                 WHEN INFIELD(apf04) # Employee CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf04
                 WHEN INFIELD(apf05) # Dept CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf05
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
             CALL cl_qbe_select()
                 ON ACTION qbe_save
     CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN
          LET INT_FLAG=0
          CLOSE WINDOW t310_w6
          RETURN
       END IF
   END IF
 
  #-MOD-AB0197-add-
   LET g_sql = "SELECT SUM(apf10) FROM apf_file",
               " WHERE apf41 = 'N' AND ",g_wc clipped
   PREPARE t310_firm1_p2 FROM g_sql
   DECLARE t310_firm1_c2 CURSOR FOR t310_firm1_p2
   OPEN t310_firm1_c2
   FETCH t310_firm1_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   DISPLAY BY NAME l_amt
  #-MOD-AB0197-end-

   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640240
   THEN
       IF NOT cl_confirm('aap-222') THEN
          LET g_success = 'N'
          CLOSE WINDOW t310_w6
          RETURN
       END IF
#CHI-C30107 ------------ add ------------- begin #TQC-C60212
      IF only_one = '1' THEN
         SELECT * INTO g_apf.* FROM apf_file WHERE apf01 = g_apf.apf01
         CALL t310_firm1_chk()
      END IF
#CHI-C30107 ------------ add ------------- end
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t310_w6
      RETURN
   END IF
   IF only_one != '1' THEN                                                                                                          
     #LET g_sql = "SELECT * FROM apf_file WHERE ",g_wc CLIPPED         #MOD-B70159 mark 
      LET g_sql = "SELECT * FROM apf_file WHERE apf41='N'",
                  " AND apf00 = '",g_aptype CLIPPED,"'",                            #MOD-D80049
                  " AND ", g_wc CLIPPED     #MOD-B70159 add
                 
      PREPARE apf_pre FROM g_sql                                                                                                    
      DECLARE apf_curs CURSOR FOR apf_pre                                                                                           
      LET g_apf_t.* = g_apf.*                                                                                                       
      FOREACH apf_curs INTO g_apf.*                                                                                                 
         LET g_success = "Y"        #TQC-B10069
         IF STATUS THEN                                                                                                             
         #  CALL cl_err('foreach:',STATUS,1)            #TQC-B10069
            CALL s_errmsg('','','foreach:',STATUS,1)    #TQC-B10069                                                                                   
            CLOSE WINDOW t310_w6    #MOD-AC0327
            LET g_success = 'N'                                                                                                     
            EXIT FOREACH                                                                                                            
         END IF                                                                                                                     
         CALL t310_firm1_chk()                                                                                                      
         IF g_success = 'N' THEN                                                                                                    
            CLOSE WINDOW t310_w6    #MOD-AC0327
         #  EXIT FOREACH            #TQC-B10069
            CONTINUE FOREACH        #TQC-B10069
         END IF                                                                                                                     
      END FOREACH                                                                                                                   
      LET g_apf.* = g_apf_t.*                                                                                                       
      CLOSE WINDOW t310_w6   #TQC-B20128 add
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.CHI-A80036   --end---   

FUNCTION t310_firm1_upd()
 DEFINE  only_one  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 DEFINE li_result    LIKE type_file.num5      #TQC-C40095
#DEFINE  l_amt     LIKE type_file.num20_6     # No:FUN-690028 DEC(20,6)  #FUN-4B0079 #MOD-AB0197 mark
 
   LET g_success = 'Y'

#No.CHI-A80036   ---mark---begin
#  LET only_one = '1'
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"     #FUN-640240
#  THEN
#     IF g_action_choice="confirm" THEN                                                                                             
#        IF g_apf.apfmksg='Y' THEN                                                                                                  
#           IF g_apf.apf42 NOT matches '[1]' THEN      #FUN-920104 add   
#              CALL cl_err('','aws-078',1)             #FUN-920104 add                                                                             
#              LET g_success = 'N'                                                                                                  
#              RETURN                                                                                                               
#           END IF                                                                                                                  
#        END IF                                                                                                                     
#     ELSE                                                                                                                          
#       IF g_apf.apfmksg='Y' THEN
#          IF g_apf.apf42 != '1' THEN
#             CALL cl_err('','aws-078',1)
#             LET g_success = 'N'
#             RETURN
#          END IF
#       END IF
#     END IF
#
#     OPEN WINDOW t310_w6 AT 8,6 WITH FORM "aap/42f/aapt310_6"
#           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#
#     CALL cl_ui_locale("aapt310_6")
#
#     LET only_one = '1'
#     CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
#     INPUT BY NAME only_one WITHOUT DEFAULTS
#        AFTER FIELD only_one
#           IF NOT cl_null(only_one) THEN
#              IF only_one NOT MATCHES "[12]" THEN
#                 NEXT FIELD only_one
#              END IF
#              IF only_one = '1' AND g_apf.apf01 IS NULL OR g_apf.apf01= ' ' THEN
#                 NEXT FIELD only_one
#              END IF
#           END IF
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        ON ACTION controls                       #No.FUN-6B0033                                                                       
#           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
#
#     END INPUT
#
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t310_w6
#        RETURN
#     END IF
#  END IF
#
#  IF only_one = '1' THEN
#     LET g_wc = " apf01 = '",g_apf.apf01,"' "
#  ELSE
#     CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
#
#     CONSTRUCT BY NAME g_wc ON apf44,apf01,apf02,apf04,apf05
#
#             BEFORE CONSTRUCT
#                CALL cl_qbe_init()
#
#           ON ACTION CONTROLP
#             CASE
#                WHEN INFIELD(apf01) #查詢單据
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_apf1"
#                   LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO apf01
#                   NEXT FIELD apf01
#                WHEN INFIELD(apf04) # Employee CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gen"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO apf04
#                WHEN INFIELD(apf05) # Dept CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gem"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO apf05
#                OTHERWISE EXIT CASE
#          END CASE
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
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
#                ON ACTION qbe_select
#            CALL cl_qbe_select()
#                ON ACTION qbe_save
#    CALL cl_qbe_save()
#      END CONSTRUCT
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         CLOSE WINDOW t310_w6
#         RETURN
#      END IF
#  END IF
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"     #FUN-640240
#  THEN
#      IF NOT cl_confirm('aap-222') THEN
#         LET g_success = 'N'
#         CLOSE WINDOW t310_w6
#         RETURN
#      END IF
#  END IF
#
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     CLOSE WINDOW t310_w6
#     RETURN
#  END IF
#No.CHI-A80036   ---mark---end
 
   CALL cl_msg("WORKING !")                                       #FUN-640240
 
   BEGIN WORK
#  CALL s_showmsg_init() #CHI-A60034 add     #TQC-B10069
 
  #-MOD-AB0197-mark-
  #LET g_sql = "SELECT SUM(apf10) FROM apf_file",
  #            " WHERE apf41 = 'N' AND ",g_wc clipped
  #PREPARE t310_firm1_p2 FROM g_sql
  #DECLARE t310_firm1_c2 CURSOR FOR t310_firm1_p2
  #OPEN t310_firm1_c2
  #FETCH t310_firm1_c2 INTO l_amt
  #IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
  #DISPLAY BY NAME l_amt
  #-MOD-AB0197-end-
 
   CALL t310_bu(1,0)
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     
   THEN
      CLOSE WINDOW t310_w6
   END IF
 
   IF g_success = 'Y' THEN
      IF g_apf.apfmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_apf.apf41="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET g_apf.apf41="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      #FUN-C90122--add--str--
      IF g_aptype='33' AND g_success='Y' THEN
         CALL t310_upd_nmd55('Y')  #檔付款類型為F：已開發票，審核后回寫nmd55
      END IF
      #FUN-C90122--add--end
      #FUN-CB0065--add--str--
      IF g_aptype='33' AND g_success='G' THEN
         CALL t310_upd_apa('Y')  #檔付款類型為G：員工借支，審核后回寫借支單金額 
      END IF
      #FUN-CB0065--add--end
       IF g_success='Y' THEN
         LET g_apf.apf42='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET g_apf.apf41='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         DISPLAY BY NAME g_apf.apf41
         DISPLAY BY NAME g_apf.apf42
         COMMIT WORK
         CALL t310_carry_voucher_apa()                    #No.FUN-A60024
         CALL cl_flow_notify(g_apf.apf01,'Y')
      ELSE
         LET g_apf.apf41='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_apf.apf41='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
#  CALL s_showmsg() #CHI-A60034 add        #TQC-B10069

   IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' AND g_success = 'Y' THEN
     #CALL s_showmsg_init()                                            #MOD-C50093 add #MOD-C50243 mark
     #LET g_wc_gl = 'npp01 = "',g_apf.apf01,'" AND npp011 = 1' #MOD-AC0383 mark
      LET g_wc_gl = " npp01='",g_apf.apf01,"' AND npp011 = 1 " #MOD-AC0383
     #LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_apf.apfuser,"' '",g_apf.apfuser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apy.apygslp,"' '",g_apf.apf02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"'"      #MOD-7B0159  #No.MOD-860075 #MOD-AC0383 mark
      #No.TQC-C30108  --Begin
      IF cl_null(g_apy.apygslp) OR (cl_null(g_apy.apygslp1) AND g_aza.aza63 = 'Y') THEN
         CALL cl_err(g_apf.apf01,'axr-070',1)
         LET g_success = 'N' 
         RETURN
      #TQC-C40095--ADD--STR
      ELSE
         CALL s_check_no("agl",g_apy.apygslp,"","1","aba_file","aba01",g_plant)
         RETURNING li_result,g_apy.apygslp
         IF NOT (li_result) THEN
            CALL cl_err(g_apy.apygslp,'sub-146',1)
            LET g_success = 'N'
            RETURN
         END IF
         IF NOT cl_null(g_apy.apygslp1) and g_aza.aza63 = 'Y' THEN
            CALL s_check_no("agl",g_apy.apygslp1,"","1","aba_file","aba01",g_plant)
            RETURNING li_result,g_apy.apygslp1
            IF NOT (li_result) THEN
               CALL cl_err(g_apy.apygslp1,'sub-146',1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      #TQC-C40095--ADD--END
      END IF
      #No.TQC-C30108  --End
     #-MOD-AC0383-add-
      LET g_str = "aapp400" ,
                  ' "',g_wc_gl CLIPPED,'"',
                  ' "',g_apf.apfuser,'"',  
                  ' "',g_apf.apfuser,'"', 
                  ' "',g_apz.apz02p,'" ',
                  ' "',g_apz.apz02b,'" ',
                  ' "',g_apy.apygslp,'" ',
                  ' "',g_apf.apf02,'" ',
                  ' "Y" ',
                  ' "1" ',  
                  ' "Y" ',
                  ' "',g_apz.apz02c,'" ',
                  ' "',g_apy.apygslp1,'" ',
                  ' "Y" '                    #MOD-B10041
     #-MOD-AC0383-end-
      CALL cl_cmdrun_wait(g_str)
      SELECT apf44,apf43 INTO g_apf.apf44,g_apf.apf43 FROM apf_file
       WHERE apf01 = g_apf.apf01
     #--------------------------MOD-C50093---------------------------(S)
     #CALL s_errmsg('',g_apf.apf44,'','','')                   #MOD-C90246 mark
      IF NOT cl_null(g_apf.apf44) THEN                         #MOD-C90246 add
         CALL s_errmsg('',g_apf.apf44,'','anm-710','')         #MOD-C90246 add
      ELSE                                                     #MOD-C90246 add
         CALL s_errmsg('',g_apf.apf44,'','anm-711','')         #MOD-C90246 add
      END IF                                                   #MOD-C90246 add
      CALL s_showmsg()
     #--------------------------MOD-C50093---------------------------(E)
      DISPLAY BY NAME g_apf.apf44
      DISPLAY BY NAME g_apf.apf43
   END IF
 
   SELECT * INTO g_apf.* FROM apf_file WHERE apf01 = g_apf.apf01
   IF g_apf.apf41='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_apf.apf42='1' OR
      g_apf.apf42='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_apf.apf42='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
   CALL cl_set_field_pic(g_apf.apf41,g_chr2,"",g_chr3,g_chr,g_apf.apfacti)
END FUNCTION
 
FUNCTION t310_bu(u_sw,r_sw)
   DEFINE u_sw,r_sw      LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_apa34f       LIKE apa_file.apa34f
   DEFINE l_apa35f       LIKE apa_file.apa35f
   DEFINE l_apa20        LIKE apa_file.apa20
   DEFINE l_apa14        LIKE apa_file.apa14
   DEFINE l_apa34        LIKE apa_file.apa34
   DEFINE l_apa35        LIKE apa_file.apa35
   DEFINE l_apa41        LIKE apa_file.apa41
   DEFINE l_apa42        LIKE apa_file.apa42
   DEFINE r_apa02        LIKE apa_file.apa02
   DEFINE r_apa34f       LIKE apa_file.apa34f
   DEFINE r_apa35f       LIKE apa_file.apa35f
   DEFINE r_apa20        LIKE apa_file.apa20
   DEFINE r_apa20f       LIKE apa_file.apa20
   DEFINE r_apa14        LIKE apa_file.apa14
   DEFINE r_apa34        LIKE apa_file.apa34
   DEFINE r_apa35        LIKE apa_file.apa35
   DEFINE r_apa41        LIKE apa_file.apa41
   DEFINE r_apa42        LIKE apa_file.apa42
   DEFINE l_msg1,l_msg2  LIKE ze_file.ze03             #No.FUN-690028 VARCHAR(30)
   DEFINE l_amtf,l_amt   LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_amtf2,l_amt2 LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_amt3         LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE t1,t2,t3,t4,t9,t10   LIKE type_file.num20_6  #No.FUN-690028 DEC(20,6)  #FUN-4B0079   #TQC-6C0044
   DEFINE t11,t12        LIKE type_file.num20_6        #MOD-C90082 add
   DEFINE l_cnt          LIKE type_file.num10,         #No.FUN-690028 INTEGER
          l_n            LIKE type_file.num10          #No.FUN-690028 INTEGER
   DEFINE l_apa02        LIKE apa_file.apa02
   DEFINE l_dmy3         LIKE type_file.chr1           #No.FUN-690028 VARCHAR(1)
   DEFINE l_dramt,l_cramt  LIKE type_file.num20_6      #No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_msg          LIKE type_file.chr1000        #No.FUN-690028 VARCHAR(60)
   DEFINE l_apa13        LIKE apa_file.apa13
   DEFINE l_apa44        LIKE apa_file.apa44
   DEFINE l_aba19        LIKE aba_file.aba19
   DEFINE l_apa00        LIKE apa_file.apa00
   DEFINE g_t1           LIKE oay_file.oayslip         #MOD-580041  #No.FUN-690028 VARCHAR(5)
   DEFINE l_apydmy3      LIKE apy_file.apydmy3         #MOD-580041
   DEFINE l_flag         LIKE type_file.chr1           #MOD-590054  #No.FUN-690028 VARCHAR(1)
   DEFINE l_str          STRING                        #FUN-640240
   DEFINE l_apa          DYNAMIC ARRAY OF RECORD       #No.FUN-680027 add
                 apa01   LIKE apa_file.apa01           #No.FUN-680027 add 
                         END RECORD                    #No.FUN-680027 add
   DEFINE i              LIKE type_file.num5           #No.FUN-680027 add  #No.FUN-690028 SMALLINT
   DEFINE l_apc06        LIKE apc_file.apc06           #No.FUN-680027 add
   DEFINE l_apc08        LIKE apc_file.apc08           #No.FUN-680027 add 
   DEFINE l_apc09        LIKE apc_file.apc09           #No.FUN-680027 add 
   DEFINE l_apc10        LIKE apc_file.apc10           #No.FUN-680027 add 
   DEFINE l_apc11        LIKE apc_file.apc11           #No.FUN-680027 add 
   DEFINE l_apc16        LIKE apc_file.apc16           #No.FUN-680027 add 
   DEFINE l_apc16f       LIKE apc_file.apc16           #No.FUN-680027 add 
   DEFINE r_apc08        LIKE apc_file.apc08           #No.FUN-680027 add 
   DEFINE r_apc09        LIKE apc_file.apc09           #No.FUN-680027 add 
   DEFINE r_apc10        LIKE apc_file.apc10           #No.FUN-680027 add 
   DEFINE r_apc11        LIKE apc_file.apc11           #No.FUN-680027 add 
   DEFINE r_apc16        LIKE apc_file.apc16           #No.FUN-680027 add 
   DEFINE r_apc16f       LIKE apc_file.apc16           #No.FUN-680027 add 
   DEFINE l_amtf4,l_amt4 LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)              #No.FUN-680027 add
   DEFINE l_amtf5,l_amt5 LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)              #No.FUN-680027 add
   DEFINE l_apc13        LIKE apc_file.apc13           #No.FUN-680027 add 
   DEFINE l_apc15        LIKE apc_file.apc15           #No.MOD-C20202 add
   DEFINE t5,t6,t7,t8    LIKE type_file.num20_6        #No.FUN-690028 DEC(20,6)               #nO.fun-680027 add
   DEFINE l_apa31        LIKE apa_file.apa31           #CHI-AA0003 add
   DEFINE t_amtf1,t_amt1 LIKE type_file.num20_6        #MOD-BB0020
   DEFINE t_amtf2,t_amt2 LIKE type_file.num20_6        #MOD-BB0020
   DEFINE t_amtf3,t_amt3 LIKE type_file.num20_6        #MOD-BB0020
   DEFINE t_amtf4,t_amt4 LIKE type_file.num20_6        #MOD-BB0020 
   DEFINE l_aph          RECORD LIKE aph_file.*        #FUN-C90044
   DEFINE l_npp07         LIKE npp_file.npp07     #MOD-CC0286 add
 
   OPEN t310_cl USING g_apf.apf01
   IF STATUS THEN
     #CALL cl_err("OPEN t310_cl:", STATUS, 1) #CHI-A60034 mark
      #CHI-A60034 add --start--
      IF u_sw = 1 THEN
         CALL s_errmsg('','','OPEN t310_cl:',STATUS,1)
      ELSE
         CALL cl_err("OPEN t310_cl:", STATUS, 1)
      END IF
      #CHI-A60034 add --end--
      LET g_success = 'N'
      CLOSE t310_cl
      RETURN
   END IF
   FETCH t310_cl INTO g_apf.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK  #CHI-A60034 mark
      #CHI-A60034 add --start--
      IF u_sw = 1 THEN
         CALL s_errmsg('apf01',g_apf.apf01,'',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      END IF
      #CHI-A60034 add --end--
       LET g_success = 'N'
       CLOSE t310_cl
       RETURN
   END IF
   IF u_sw=1 THEN
   	 #No.MOD-D80049  --Begin  
     # LET g_sql="SELECT * FROM apf_file WHERE apf41='N' AND ",g_wc    #MOD-590054       #FUN-640184   #TQC-720009
     LET g_sql="SELECT * FROM apf_file WHERE apf41='N' ",
               "   AND apf00 = '",g_aptype CLIPPED,"'",
               "   AND ",g_wc CLIPPED
     #No.MOD-D80049  --End
   END IF
   IF r_sw=1 THEN
   	  #No.MOD-D80049  --Begin  
      #LET g_sql="SELECT * FROM apf_file WHERE apf41='Y' AND ",g_wc
      LET g_sql="SELECT * FROM apf_file WHERE apf41='Y' ",
          "   AND apf00 = '",g_aptype CLIPPED,"'",
          "   AND ",g_wc CLIPPED
     #No.MOD-D80049  --End
   END IF
   PREPARE t310_bu_p FROM g_sql
   DECLARE t310_bu_c CURSOR FOR t310_bu_p
   LET l_flag = 0   #MOD-590054
   FOREACH t310_bu_c INTO m_apf.*
      LET l_str = 'pay no.',m_apf.apf01
      CALL cl_msg(l_str)
      #END FUN-640240
      LET l_flag = 1   #MOD-590054
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
      LET g_sql ="SELECT apz57 FROM apz_file ",
                 " WHERE apz00 = '0'"
      PREPARE t600_apz57_p FROM g_sql
      EXECUTE t600_apz57_p INTO g_apz.apz57
   #FUN-B50090 add -end--------------------------
      IF m_apf.apf02<=g_apz.apz57 THEN
        #CALL cl_err(m_apf.apf02,'aap-176',0)  #CHI-A60034 mark
         #CHI-A60034 add --start--
         IF u_sw = 1 THEN
            CALL s_errmsg('apf02',m_apf.apf02,'','aap-176',1)
         ELSE
            CALL cl_err(m_apf.apf02,'aap-176',0)
         END IF
         #CHI-A60034 add --end--
         LET g_success='N'
      #  RETURN            #TQC-B10069
         CONTINUE FOREACH  #TQC-B10069
      END IF
      IF u_sw=1 THEN
         #CHI-AA0003 add --start--
         IF m_apf.apf10 != m_apf.apf08 THEN
            SELECT apa31 INTO l_apa31 FROM apa_file
             WHERE apa08=m_apf.apf01 AND apa00='24'
               AND apa02 <= m_apf.apf02
            IF NOT cl_null(l_apa31) THEN
               IF l_apa31 != m_apf.apf09 THEN 
                   CALL s_errmsg('apf01',m_apf.apf01,'','aap-341',1) 
                   LET g_success='N'
               #   RETURN              #TQC-B10069
                   CONTINUE FOREACH    #TQC-B10069      
               END IF
            END IF
         END IF
         #CHI-AA0003 add --end--
        #CHI-AA0003 mark --start--
        #IF m_apf.apf08 != 0 THEN   #CHI-850001
        #   IF m_apf.apf10 != m_apf.apf08 THEN    
        #      IF m_apf.apf10 < m_apf.apf08 THEN                   # 付不足   
        #        #CALL cl_err(m_apf.apf01,'aap-318',1)  #CHI-A60034 mark
        #         CALL s_errmsg('apf01',m_apf.apf01,'','aap-318',1) #CHI-A60034
        #         LET g_success='N'
        #         RETURN
        #      END IF
        #      IF m_apf.apf10 > (m_apf.apf08+m_apf.apf09) THEN     # 付超過
        #        #CALL cl_err(m_apf.apf01,'aap-319',1)  #CHI-A60034 mark
        #         CALL s_errmsg('apf01',m_apf.apf01,'','aap-319',1) #CHI-A60034
        #         LET g_success='N'
        #         RETURN
        #      END IF
        #   END IF
        #END IF   #CHI-850001
        #CHI-AA0003 mark --end--
      END IF
      LET g_t1=s_get_doc_no(m_apf.apf01)
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip = g_t1
 
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM aph_file
       WHERE aph01=m_apf.apf01 AND aph09='Y'
      IF l_cnt>0 THEN
        #CALL cl_err(m_apf.apf01,'aap-228',0)  #CHI-A60034 mark
         #CHI-A60034 add --start--
         IF u_sw = 1 THEN
            CALL s_errmsg('apf01',m_apf.apf01,'','aap-228',1)
         ELSE
            CALL cl_err(m_apf.apf01,'aap-228',0)
         END IF
         #CHI-A60034 add --end--
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      IF r_sw=1 THEN                 #85-10-04判斷票據是否已拋轉
         #-->已產生溢付必須還原
        #-TQC-B10199-mark-
        #IF m_apf.apf09 != 0 THEN
        #   IF g_aptype <> '32' THEN    #No.FUN-A80111
        #      SELECT apa35 INTO l_apa35 FROM apa_file WHERE apa08 = m_apf.apf01
        #                                                AND apa00 = '24'
        #                                                AND apa02 <= m_apf.apf02          #MOD-A30146 add
        #      IF SQLCA.sqlcode THEN
        #         CALL cl_err3("sel","apa_file",m_apf.apf01,"",SQLCA.sqlcode,"","sel apa35",1)  #No.FUN-660122
        #         LET g_success = 'N'  RETURN
        #      END IF
        #      IF l_apa35 != 0 THEN
        #         CALL cl_err(m_apf.apf01,'aap-754',0)
        #         LET g_success = 'N'  RETURN
        #      END IF
        #      UPDATE apf_file SET apf09f= 0, apf09 = 0 WHERE apf01 = m_apf.apf01
        #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #         CALL cl_err3("upd","apf_file",m_apf.apf01,"",SQLCA.sqlcode,"","up apf09f,apf09",1)  #No.FUN-660122
        #         LET g_success = 'N'  RETURN
        #      END IF
        #      DECLARE t310_bu_apc CURSOR FOR                                       #No.FUN-680027 add 
        #        SELECT apa01 FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'  #No.FUN-680027 add
        #                                     AND apa02 <= m_apf.apf02          #MOD-A30146 add
        #      LET i=1
        #      FOREACH t310_bu_apc INTO l_apa[i].apa01
        #          LET i=i+1
        #      END FOREACH
        #      LET l_cnt = 0
        #      SELECT COUNT(*) INTO l_cnt FROM apa_file
        #       WHERE apa08=m_apf.apf01 AND apa00='24'
        #         AND apa02 <= m_apf.apf02          #MOD-A30146 add
        #      IF l_cnt > 0 THEN
        #         DELETE FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'
        #                                AND apa02 <= m_apf.apf02          #MOD-A30146 add
        #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #            CALL cl_err3("del","apa_file",m_apf.apf01,"",SQLCA.sqlcode,"","del apa_file tmp_pay",1)  #No.FUN-660122
        #            LET g_success = 'N'  RETURN
        #         ELSE
        #            FOR i=1 TO l_apa.getLength()
        #               IF cl_null(l_apa[i].apa01) THEN CONTINUE FOR END IF
        #               LET l_cnt = 0
        #               SELECT COUNT(*) INTO l_cnt FROM apc_file
        #                WHERE apc01=l_apa[i].apa01
        #               IF l_cnt > 0 THEN
        #                  DELETE FROM apc_file WHERE apc01=l_apa[i].apa01
        #                  IF SQLCA.sqlcode or SQLCA.sqlerrd[3] = 0  THEN
        #                     CALL cl_err3("del","apc_file",l_apa[i].apa01,"",SQLCA.sqlcode,"","delete apc_file",1)  #No.FUN-680027
        #                     LET g_success = 'N' RETURN
        #                  END IF
        #               END IF   #MOD-870048 add
        #            END FOR
        #         END IF  
        #      END IF   #MOD-870048 add
        #   END IF    #No.FUN-A80111
#No.FUN-A80111 --begin
        #   IF g_aptype ='32'  THEN    
        #      CALL t310_chk_apa35(m_apf.apf01)
        #      IF g_success = 'N' THEN RETURN END IF  
        #      DELETE FROM apc_file WHERE apc01 IN (SELECT apa01 FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='12' AND apa79 ='2' )  
        #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #         CALL cl_err3("del","apc_file",m_apf.apf01,"",SQLCA.sqlcode,"","del apc_file return",1)  #No.FUN-660122
        #         LET g_success = 'N'  RETURN
        #      END IF 
        #      DELETE FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='12'
        #                             AND apa79 ='2'
        #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #         CALL cl_err3("del","apa_file",m_apf.apf01,"",SQLCA.sqlcode,"","del apa_file return",1)  #No.FUN-660122
        #         LET g_success = 'N'  RETURN
        #      END IF 
        #   END IF 
#No.FUN-A80111 --end            
        #   CALL t310_v('2')
        #END IF
        #-TQC-B10199-end-
         CALL t310_del_nme()
         IF g_success='N' THEN EXIT FOREACH END IF
 
         UPDATE apf_file SET apf41='N',apf42='0' WHERE apf01=m_apf.apf01   #No.FUN-540047
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","apf_file",m_apf.apf01,"",SQLCA.sqlcode,"","upd apf41",1)  #No.FUN-660122
            LET g_success='N'
         END IF
      END IF
      #---->確認
      IF u_sw=1 THEN
#CHI-AA0003 mark --start--
#         IF m_apf.apf10 != m_apf.apf08 THEN
#            IF m_apf.apf08 != 0 THEN    #CHI-850001
#               IF m_apf.apf10 < m_apf.apf08 THEN                            # 付不足   
#                  CALL cl_getmsg('aap-070',g_lang) RETURNING l_msg
#                  LET l_msg = '(',m_apf.apf01,')',l_msg clipped
#                 #CALL cl_err(l_msg,'!',1) #CHI-A60034 mark
#                  CALL s_errmsg('apf01',m_apf.apf01,l_msg,'!',1) #CHI-A60034
#                  LET g_success = 'N' EXIT FOREACH
#               END IF
#            END IF   #CHI-850001
#            IF m_apf.apf09 != 0 THEN            # 付超過   #CHI-850001
#               IF g_aptype <>'32' THEN        #No.FUN-A80111
#                  #轉溢付
#                  IF NOT cl_confirm('aap-274') THEN  #no.7147(原本用prompt的  
#                     LET g_success = 'N' EXIT FOREACH   #寫法在UI(6.0) 行不通)
#                  ELSE
#                     CALL t310_tmp_pay(m_apf.*)
#                  END IF
##No.FUN-A80111 --begin
#               ELSE
#                  #轉溢退
#                  IF NOT cl_confirm('aap-148')  THEN  #no.7147(原本用prompt的 
#                     LET g_success = 'N' EXIT FOREACH   #寫法在UI(6.0) 行不通)
#                  ELSE
#                     CALL t310_ins_apa()
#                  END IF
#               END IF 
##No.FUN-A80111 --end                
#            END IF
#         END IF
#CHI-AA0003 mark --end--
         IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'N' THEN  #No.FUN-670060
            CALL s_chknpq(m_apf.apf01,'AP',1,'0',g_bookno1) # 檢查分錄底稿平衡正確否(NO.0151)   #No.FUN-730064
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL s_chknpq(m_apf.apf01,'AP',1,'1',g_bookno2)    #No.FUN-730064
            END IF 
          # IF g_success ='N' THEN EXIT FOREACH END IF     #TQC-B10069
            IF g_success ='N' THEN       #TQC-B10069
               CONTINUE FOREACH          #TQC-B10069
            END IF                       #TQC-B10069
         END IF
 
            IF g_apf.apfmksg = 'N' THEN
               LET g_apf.apf42 = '1'
            END IF
 
          IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
             SELECT count(*) INTO l_n FROM npq_file
              WHERE npq01 = g_apf.apf01
                AND npq011 = 1
                AND npqsys = 'AP'
                AND npq00 = 3
             IF l_n = 0 THEN
                CALL t310_gen_glcr(g_apf.*,g_apy.*)
             END IF
             IF g_success = 'Y' THEN 
                CALL s_chknpq(m_apf.apf01,'AP',1,'0',g_bookno1)     #No.FUN-730064
                IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                   CALL s_chknpq(m_apf.apf01,'AP',1,'1',g_bookno2)    #No.FUN-730064
                END IF
             #  IF g_success ='N' THEN EXIT FOREACH END IF      #TQC-B10069
                IF g_success ='N' THEN      #TQC-B10069
                   CONTINUE FOREACH         #TQC-B10069
                END IF                      #TQC-B10069 
             END IF
          END IF
         UPDATE apf_file SET apf41='Y',apf42=g_apf.apf42 WHERE apf01=m_apf.apf01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
           #CALL cl_err3("upd","apf_file",m_apf.apf01,"",SQLCA.sqlcode,"","upd apf41",1)  #No.FUN-660122 #CHI-A60034 mark
            CALL s_errmsg('apf01',m_apf.apf01,"upd apf41",SQLCA.sqlcode,1) #CHI-A60034
            LET g_success='N'
         END IF
      END IF
      DECLARE t310_bu_c1 CURSOR FOR
          SELECT * FROM apg_file WHERE apg01=m_apf.apf01
      FOREACH t310_bu_c1 INTO m_apg.*
        IF SQLCA.sqlcode THEN
          #CALL cl_err('t310_bu_c1',SQLCA.sqlcode,0) #CHI-A60034 mark  
           #CHI-A60034 add --start--
           IF u_sw = 1 THEN
              CALL s_errmsg('','','t310_bu_cl',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err('t310_bu_c1',SQLCA.sqlcode,0)  
           END IF
           #CHI-A60034 add --end--
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        LET l_aba19 = ' '
        CALL s_getdbs()
        LET g_sql = "SELECT apa44 ",
                    "  FROM apa_file",   #FUN-9A0093
                    "  WHERE apa01 = ?",
#                    "    AND apa00[1,1] = '1'",         #No.FUN-A40003
                    "    AND apa02 <= '",m_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
#No.FUN-A40003 --begin
        IF g_aptype ='32' THEN 
           LET g_sql = g_sql, "    AND apa00[1,1] = '2'"
        ELSE 
#No.FUN-C90027--BEGIN
           IF g_aptype = '36' AND g_apf.apf47 = '2' THEN
              LET g_sql = g_sql ," AND apa00[1,1]='2'"
           ELSE
              LET g_sql = g_sql ," AND apa00[1,1]='1'"
           END IF
#No.FUN-C90027--END
        END IF 
#No.FUN-A40003 --end
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        PREPARE t310_p3t FROM g_sql DECLARE t310_c3t CURSOR FOR t310_p3t
        OPEN t310_c3t USING m_apg.apg04
        FETCH t310_c3t INTO l_apa44
        CLOSE t310_c3t
        IF u_sw='1' THEN #no.7372
            IF g_apz.apz06 = 'N' THEN
               LET g_t1 = s_get_doc_no(m_apg.apg04)
               SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=g_t1
               IF l_apydmy3 = 'Y' AND cl_null(l_apa44) THEN
                  LET g_errno='aap-109'
                 #CALL cl_err(m_apg.apg04,g_errno,0) #CHI-A60034 mark
                  CALL s_errmsg('apg04',m_apg.apg04,'',g_errno,1) #CHI-A60034 add
                  LET g_success = 'N' EXIT FOREACH
               END IF
            END IF
 
           IF NOT cl_null(l_apa44) AND g_apz.apz05 = 'N' THEN
             #---------------------MOD-CC0286-------------(S)
              SELECT npp07 INTO l_npp07 FROM npp_file
               WHERE npp01 = m_apg.apg04
                 AND npptype = '0'
                 AND nppsys = 'AP'
             #---------------------MOD-CC0286-------------(E)
              LET g_plant_new = g_apz.apz02p
              CALL s_getdbs()
              LET g_sql = "SELECT aba19 ",
                        # "  FROM ",g_dbs_new,"aba_file",                        #FUN-A50102 mark
                          "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                          "  WHERE aba01 = ? AND aba00 = ? "
 
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920032
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
              PREPARE t310_p3z FROM g_sql DECLARE t310_c3z CURSOR FOR t310_p3z
             #OPEN t310_c3z USING l_apa44,g_apz.apz02b                               #MOD-CC0286 mark
              OPEN t310_c3z USING l_apa44,l_npp07                                    #MOD-CC0286 add
              FETCH t310_c3z INTO l_aba19
              IF cl_null(l_aba19) THEN LET l_aba19 = 'N' END IF
              IF l_aba19 = 'N' THEN
                 LET g_errno = 'aap-110'
                #CALL cl_err(m_apg.apg04,g_errno,0) #CHI-A60034 mark
                 CALL s_errmsg('apg04',m_apg.apg04,'',g_errno,1) #CHI-A60034 add
                 LET g_success = 'N' EXIT FOREACH
              END IF
           END IF
        END IF
 
        LET l_amtf = 0   LET l_amt  = 0
        LET l_amtf2= 0   LET l_amt2 = 0
        LET g_sql = "SELECT SUM(apg05f),SUM(apg05) ",
                  #   "  FROM ",s_dbstring(g_dbs CLIPPED),"apg_file,",            #FUN-A50102 mark                                                                         
                  #             s_dbstring(g_dbs CLIPPED),"apf_file ",            #FUN-A50102 mark
                      "  FROM ",cl_get_target_table(g_plant,'apg_file'),",",      #FUN-A50102
                                cl_get_target_table(g_plant,'apf_file'),          #FUN-A50102
                      " WHERE apg04 = ? AND apg01 = apf01 AND apf41 = 'Y' "      #MOD-D70039    #yinhy131203还原
                      #" WHERE apg04 = ? AND apg01 = apf01",                       #MOD-D70039  #yinhy131203 mark
                      #"   AND apg01=  '",m_apf.apf01 CLIPPED,"'"                  #MOD-D70039  #yinhy131203 mark
                      
        #No.MOD-D70039  --Begin
        IF u_sw = 1 THEN
           LET g_sql = g_sql CLIPPED, "  AND apf41='Y'"
        END IF     
        #No.MOD-D70039  --End
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102
        PREPARE t310_str2 FROM g_sql
        IF STATUS THEN
          #CALL cl_err('change dbs_1 error',status,1) #CHI-A60034 mark
           #CHI-A60034 add --start--
           IF u_sw = 1 THEN
              CALL s_errmsg('','','change dbs_1 error',status,1)
           ELSE
              CALL cl_err('change dbs_1 error',status,1)
           END IF
           #CHI-A60034 add --end--
           LET g_success='N'
           EXIT FOREACH
        END IF
 
        DECLARE z5_curs CURSOR FOR t310_str2
        OPEN z5_curs USING m_apg.apg04
        FETCH z5_curs INTO l_amtf2,l_amt2
        IF STATUS OR l_amtf2 IS NULL THEN
           LET l_amtf2 = 0
           LET l_amt2  = 0
        END IF
        CLOSE z5_curs
     
        IF NOT cl_null(m_apg.apg06) THEN
           LET l_amtf4 = 0
           LET l_amt4  = 0
           #IF u_sw = 1 THEN    #No.MOD-D80175  #yinhy131203 mark
              LET g_sql = "SELECT SUM(apg05f),SUM(apg05) ",
                        #   "  FROM ",s_dbstring(g_dbs CLIPPED),"apg_file,",             #FUN-A50102 mark                                                                    
                        #             s_dbstring(g_dbs CLIPPED),"apf_file ",             #FUN-A50102 mark
                            " FROM ",cl_get_target_table(g_plant,'apg_file'),",",        #FUN-A50102
                                     cl_get_target_table(g_plant,'apf_file'),            #FUN-A50102   
                            " WHERE apg04 = ? AND apg06 = ? AND apg01 = apf01 AND apf41 = 'Y' "                 #No.FUN-680027 mark
           ##No.MOD-D70039  --Begin  #yinhy131203 mark
           #ELSE
           #   LET g_sql = "SELECT SUM(apg05f),SUM(apg05) ",       
           #                 " FROM ",cl_get_target_table(g_plant,'apg_file'),",",   
           #                          cl_get_target_table(g_plant,'apf_file'),        
           #                 " WHERE apg04 = ? AND apg06 = ? AND apg01 = apf01 AND apf41 = 'N' ",
           #                 "  AND apf01 <> '",m_apf.apf01,"'"              #MOD-D90019
           #END IF
           ##No.MOD-D70039  --End  #yinhy131203 mark
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
           PREPARE t310_str2_2 FROM g_sql
           IF STATUS THEN
             #CALL cl_err('change dbs_1 error',status,1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('','','change dbs_1 error',status,1)
              ELSE
                 CALL cl_err('change dbs_1 error',status,1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
 
           DECLARE z5_curs2 CURSOR FOR t310_str2_2
           OPEN z5_curs2 USING m_apg.apg04,m_apg.apg06 
           FETCH z5_curs2 INTO l_amtf4,l_amt4
           IF STATUS OR l_amtf4 IS NULL THEN
              LET l_amtf4 = 0
              LET l_amt4  = 0
           END IF
           CLOSE z5_curs2
        END IF
 
       #LET g_plant_new = m_apg.apg03   #MOD-B10147 mark 
        LET g_plant_new = g_apz.apz02p  #MOD-B10147
        CALL s_getdbs()
 
        LET g_sql = "SELECT apa20,apa34f,apa35f,apa34,apa35,apa14,apa02,apa41,",
                    "       apa42,apa13,apa00",
                  # "  FROM ",g_dbs_new CLIPPED,"apa_file",                #FUN-A50102 mark
                    "  FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102 
                    " WHERE apa01 = ? ",
                    "   AND apa02 <= '",m_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                    #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        #FUN-A50102 
        PREPARE t310_str3 FROM g_sql
        IF STATUS THEN
          #CALL cl_err('change dbs_2 error',status,1) #CHI-A60034 mark
           #CHI-A60034 add --start--
           IF u_sw = 1 THEN
              CALL s_errmsg('','','change dbs_2 error',status,1)
           ELSE
              CALL cl_err('change dbs_2 error',status,1)
           END IF
           #CHI-A60034 add --end--
           LET g_success='N'
           EXIT FOREACH
        END IF
        DECLARE z3_curs CURSOR FOR t310_str3
        OPEN z3_curs USING m_apg.apg04
        FETCH z3_curs INTO l_apa20,l_apa34f,l_apa35f,l_apa34,l_apa35,
                           l_apa14,l_apa02 ,l_apa41 ,l_apa42,l_apa13,l_apa00
        LET r_apa20f = 0
        LET r_apa20 = 0
        LET r_apa34f = 0
        LET r_apa35f = 0
        LET r_apa34 = 0
        LET r_apa35  = 0
        LET r_apa14  = 0
        IF STATUS THEN
           LET l_apa20 = 0
           LET l_apa34f = 0
           LET l_apa35f = 0
           LET l_apa34 = 0
           LET l_apa35  = 0
           LET l_apa14  = 0
           LET l_apa41 = ' '
           LET l_apa42 = ' '
        ELSE
           IF l_apa41 !='Y' THEN
             #CALL cl_err(m_apg.apg04,'aap-271',1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('apg04',m_apg.apg04,'','aap-271',1)
              ELSE
                 CALL cl_err(m_apg.apg04,'aap-271',1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
           IF l_apa42 ='Y'  THEN
             #CALL cl_err(m_apg.apg04,'aap-272',1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('apg04',m_apg.apg04,'','aap-272',1)
              ELSE
                 CALL cl_err(m_apg.apg04,'aap-272',1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
           LET r_apa20f = r_apa20f + l_apa20 * l_apa14
           LET r_apa20  = r_apa20  + l_apa20
           LET r_apa34f = r_apa34f + l_apa34f
           LET r_apa35f = r_apa35f + l_apa35f
           LET r_apa34  = r_apa34  + l_apa34
           LET r_apa35  = r_apa35  + l_apa35
           LET r_apa20f = cl_digcut(r_apa20f,g_azi04)   #MOD-780148
        END IF
        CLOSE z3_curs
        IF NOT cl_null(m_apg.apg06) THEN
          #LET g_sql = "SELECT apc16,apc08 ,apc10 ,apc09,apc11,apc06  ",           #MOD-C20202 mark
           LET g_sql = "SELECT apc16,apc08 ,apc10 ,apc09,apc11, ",                 #MOD-C20202 add
                       "       apc06,apc15 ",                                      #MOD-C20202 add
                     # "  FROM ",g_dbs_new CLIPPED,"apa_file ,",                   #FUN-A50102 mark
                     #           g_dbs_new CLIPPED,"apc_file  ",                   #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",  #FUN-A50102
                                 cl_get_target_table(g_plant_new,'apc_file'),      #FUN-A50102 
                       " WHERE apc01 = ? AND apc02=? AND apc01=apa01",
                       "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"          #MOD-A30146 add
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql                     #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql         #FUN-A50102
           PREPARE t310_str3_apc FROM g_sql
           IF STATUS THEN
             #CALL cl_err('change dbs_2 error',status,1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('','','change dbs_2 error',status,1)
              ELSE
                 CALL cl_err('change dbs_2 error',status,1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
           DECLARE z3_curs_apc CURSOR FOR t310_str3_apc
           OPEN z3_curs_apc USING m_apg.apg04,m_apg.apg06
          #FETCH z3_curs_apc INTO l_apc16,l_apc08 ,l_apc10 ,l_apc09,l_apc11,l_apc06   #MOD-C20202 mark
           FETCH z3_curs_apc INTO l_apc16,l_apc08 ,l_apc10 ,l_apc09,l_apc11,          #MOD-C20202 add
                                  l_apc06,l_apc15                                     #MOD-C20202 add
           LET r_apc08 = 0   
           LET r_apc09 = 0   
           LET r_apc10 = 0   
           LET r_apc11 = 0   
           LET r_apc16 = 0   
           LET r_apc16f= 0   
           IF SQLCA.sqlcode THEN
              LET l_apc08 = 0
              LET l_apc09 = 0
              LET l_apc10 = 0
              LET l_apc11 = 0
              LET l_apc16 = 0
              LET l_apc16f= 0
           ELSE
              LET r_apc08 = r_apc08 + l_apc08
              LET r_apc09 = r_apc09 + l_apc09
              LET r_apc10 = r_apc10 + l_apc10
              LET r_apc11 = r_apc11 + l_apc11
              LET r_apc16 = r_apc16 + l_apc16
              LET r_apc16f= r_apc16f+ cl_digcut(l_apc16*l_apc06,g_azi04) #MOD-9A0087   
           END IF
           CLOSE z3_curs_apc 
        END IF
        IF g_apz.apz27 = 'N' OR l_apa13 = g_aza.aza17 THEN
           IF u_sw=1 THEN
              IF (r_apa34f-r_apa20) < l_amtf2 OR (r_apa34-r_apa20f) < l_amt2 THEN
                #CALL cl_err(m_apg.apg04,'aap-250',1) #CHI-A60034 mark
                 CALL s_errmsg('apg04',m_apg.apg04,'','aap-250',1) #CHI-A60034
                 LET g_success='N'
                 EXIT FOREACH
              END IF
              IF NOT cl_null(m_apg.apg06) THEN
                 IF (r_apc08-r_apc16) < l_amtf4 OR (r_apc09-r_apc16f) < l_amt4 THEN
                   #CALL cl_err(m_apg.apg04,'aap-250',1) #CHI-A60034 mark
                    CALL s_errmsg('apg04',m_apg.apg04,'','aap-250',1) #CHI-A60034
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
              END IF
           END IF
        END IF
        #---------更新請款已付金額----------------------
       #LET g_plant_new = m_apg.apg03   #MOD-B10147 mark 
        LET g_plant_new = g_apz.apz02p  #MOD-B10147
        CALL s_getdbs()
      # LET g_sql = "UPDATE ",g_dbs_new CLIPPED,"apa_file ",                   #FUN-A50102 mark
       #IF u_sw = 1 THEN
       #CHI-EC0020---mark---str--
#        LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),     #FUN-A50102  
#                    " SET apa35f=?,apa35=?,apa73=? ",
#                    #" SET apa35f=apa35f+?,apa35=apa35+?,apa73=? ",    #MOD-D70039  #yinhy131203 mark
#                    "WHERE apa01= ? AND apa41='Y' AND apa42='N' ",
#                    "  AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
       #CHI-EC0020---mark---end--

       #ELSE
       #LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),     #FUN-A50102  
       #             " SET apa35f=?,apa35=?,apa73=? ",
       #            #" SET apa35f=apa35f-?,apa35=apa35-?,apa73=? ",    #MOD-D70039  #yinhy131203 mark
       #            "WHERE apa01= ? AND apa41='Y' AND apa42='N' ",
       #            "  AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add\
       #END IF
        #CHI-EC0020---add---str--
        IF u_sw = 1 THEN #確認
           LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),
                       "   SET apa35f = apa35f + ? ,",
                       "       apa35 = apa35 + ? ,",
                       "       apa73 = apa73 - ? ",
                       " WHERE apa01= ? ",
                       "   AND apa41='Y' ",
                       "   AND apa42='N' ", 
                       "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"
        ELSE
           LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),
                       "   SET apa35f = apa35f - ? ,",
                       "       apa35 = apa35 - ? ,",
                       "       apa73 = apa73 + ? ",
                       " WHERE apa01= ? ",
                       "   AND apa41='Y' ",
                       "   AND apa42='N' ",
                       "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"
        END IF
       #CHI-EC0020---add---end--
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                   #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql       #FUN-A50102
        PREPARE t310_str4 FROM g_sql
        IF STATUS THEN
          #CALL cl_err('change dbs_3 error',status,1) #CHI-A60034 mark
           #CHI-A60034 add --start--
           IF u_sw = 1 THEN
              CALL s_errmsg('','','change dbs_3 error',status,1)
           ELSE
              CALL cl_err('change dbs_3 error',status,1)
           END IF
           #CHI-A60034 add --end--
           LET g_success='N'
           EXIT FOREACH
        END IF
        #No.MOD-BB0020  --Begin
        #退款冲账作业，金额要加上aph_file,apv_file中的金额
        LET t_amtf1 = 0    LET t_amt1 = 0
        IF g_aptype = '32' OR g_aptype = '33' THEN
           LET g_sql = " SELECT SUM(aph05f),SUM(aph05) ",
                       "   FROM ",cl_get_target_table(g_plant,'aph_file'),",",
                                  cl_get_target_table(g_plant,'apf_file'),
                       "  WHERE aph04= ? ",
                       "    AND aph01=apf01 AND apf41='Y'",
                       "    AND aph03 IN ('6','7','8','9','G')" #FUN-CB0065 add G
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
           PREPARE t310_str2_1 FROM g_sql
           IF STATUS THEN
              IF u_sw = 1 THEN
                 CALL s_errmsg('','','change dbs_1 error',status,1)
              ELSE
                 CALL cl_err('change dbs_1 error',status,1)
              END IF
              LET g_success='N'
              EXIT FOREACH
           END IF
           DECLARE z5_curs_1 CURSOR FOR t310_str2_1
           OPEN z5_curs_1 USING m_apg.apg04
           FETCH z5_curs_1 INTO t_amtf1,t_amt1
           IF STATUS OR t_amtf1 IS NULL THEN
              LET t_amtf1 = 0
              LET t_amt1  = 0
           END IF
           CLOSE z5_curs_1
        
           #LET l_amtf2 = l_amtf2 + t_amtf1
           #LET l_amt2 = l_amt2 + t_amt1
        END IF
        #No.MOD-BB0020  --End
        
        #yinhy131210   --Begin
        LET t_amtf3 = 0    LET t_amt3 = 0
        IF g_aptype = '36' AND m_apf.apf47 =  '2'  THEN          
          LET g_sql = " SELECT SUM(apv04f),SUM(apv04) ",
                      "   FROM ",cl_get_target_table(g_plant,'apv_file'),
                      "  WHERE apv03= ? "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
          PREPARE t310_str3_1 FROM g_sql
          IF STATUS THEN
             IF u_sw = 1 THEN
                CALL s_errmsg('',m_apf.apf01,'change dbs_1 error',status,1)
             ELSE
                CALL cl_err('change dbs_1 error',status,1)
             END IF
             LET g_success='N'
             EXIT FOREACH
          END IF  
          DECLARE z5_curs3_1 CURSOR FOR t310_str3_1
          OPEN z5_curs3_1 USING m_apg.apg04        
          FETCH z5_curs3_1 INTO t_amtf3,t_amt3     
          IF STATUS OR t_amtf3 IS NULL THEN        
             LET t_amtf3 = 0                       
             LET t_amt3  = 0                       
          END IF                                   
          CLOSE z5_curs3_1 
        END IF
        LET l_amtf2 = l_amtf2 + t_amtf1 + t_amtf3
        LET l_amt2 = l_amt2 + t_amt1 +  t_amt3
        #yinhy131210   --End
        IF g_apz.apz27 = 'Y' AND l_apa13 != g_aza.aza17 THEN
           CALL s_g_np('2',l_apa00,m_apg.apg04,'') RETURNING l_amt3
        ELSE
           #No:181125 add begin --------
        	 IF g_prog = 'aapt332' THEN 
        	    IF l_unfirm = 'N' THEN   #审核
        	    	 SELECT SUM(apg05f), SUM(apg05) INTO ll_amtf,ll_amt  FROM apg_file, apf_file   #取消审核
                 WHERE apg04 = m_apg.apg04 AND apg01 = apf01
                 AND apf01=g_apf.apf01 
                 IF cl_null(ll_amtf) THEN LET ll_amtf=0 END IF 
                 IF cl_null(ll_amt) THEN LET ll_amt=0 END IF 
                 LET l_amt2 = ll_amt + l_apa35       #账款冲账金额+本币已冲账金额   
        	       LET l_amtf2 = ll_amtf + l_apa35f    #账款冲账金额+原币已冲账金额   
                 LET l_amt3 = l_apa34 - l_amt2       #本币应冲金额-本币已冲金额 
              ELSE 
           	     SELECT SUM(apg05f), SUM(apg05) INTO ll_amtf,ll_amt  FROM apg_file, apf_file   #取消审核
                 WHERE apg04 = m_apg.apg04 AND apg01 = apf01
                 AND apf01=g_apf.apf01   #No:170803 add 
                 IF cl_null(ll_amtf) THEN LET ll_amtf=0 END IF 
                 IF cl_null(ll_amt) THEN LET ll_amt=0 END IF 	
           	     LET l_amt2 = l_apa35 - ll_amt         #本币已冲账金额-账款冲账金额   
           	     LET l_amtf2 = l_apa35f - ll_amtf      #本币已冲账金额-账款冲账金额   
           	     LET l_amt3 = l_apa34 - l_amt2         #本币未冲金额
           	  END IF 
           ELSE
           #No:181125 add end----------- 
           LET l_amt3 = l_apa34 - l_amt2
           END IF   #No:181125 add
        END IF
        #EXECUTE t310_str4 USING l_amtf2,l_amt2,l_amt3,m_apg.apg04                  #CHI-EC0020 mark
        EXECUTE t310_str4 USING m_apg.apg05f,m_apg.apg05,m_apg.apg05,m_apg.apg04   #CHI-EC0020 add
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0  THEN   
          #CALL cl_err(m_apg.apg04,SQLCA.SQLCODE,1) #CHI-A60034 mark
           #CHI-A60034 add --start--
           IF u_sw = 1 THEN
              CALL s_errmsg('apg04',m_apg.apg04,'',SQLCA.SQLCODE,1)
           ELSE
              CALL cl_err(m_apg.apg04,SQLCA.SQLCODE,1)
           END IF
           #CHI-A60034 add --end--
           LET g_success='N'
           EXIT FOREACH
        END IF
       #更新apc_file
         # LET g_sql = "UPDATE ",g_dbs_new CLIPPED,"apc_file ",              #FUN-A50102 mark
          #IF  u_sw = 1 THEN     #MOD-D70039  #yinhy131203 mark
          #CHI-EC0020---mark---str--
#           LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),#FUN-A50102 
#                       " SET apc10 =?,apc11=?,apc13=? ",
#                       #" SET apc10 =apc10+?,apc11=apc11+?,apc13=? ",   #MOD-D70039
#                       "WHERE apc01 = ? AND apc02 = ? "
    #CHI-EC0020---mark---end--
          #ELSE   #MOD-D70039    #yinhy131203 mark
          # LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),#FUN-A50102 
          #             " SET apc10 =?,apc11=?,apc13=? ",
          #             #" SET apc10 =apc10-?,apc11=apc11-?,apc13=? ",   #MOD-D70039
          #             "WHERE apc01 = ? AND apc02 = ? "
          #END IF  #MOD-D70039  #yinhy131203 mark
          #CHI-EC0020---add---str--
           IF u_sw = 1 THEN   #確認
              LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),
                          "   SET apc10 = apc10 + ? ,",
                          "       apc11 = apc11 + ? ,",
                          "       apc13 = apc13 - ? ",
                          " WHERE apc01 = ? AND apc02 = ? "
           ELSE   #取消確認
              LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),
                          "   SET apc10 = apc10 - ? ,",
                          "       apc11 = apc11 - ? ,",
                          "       apc13 = apc13 + ? ",
                          " WHERE apc01 = ? AND apc02 = ? "
           END IF
          #CHI-EC0020---add---end--
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql          #FUN-A50102
           PREPARE t310_str4_apc FROM g_sql
           IF STATUS THEN
             #CALL cl_err('change dbs_3 error',status,1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('','','change dbs_3 error',status,1)
              ELSE
                 CALL cl_err('change dbs_3 error',status,1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
           #No.MOD-BB0020  --Beign
           #退款冲账作业，金额要加上aph_file,apv_file中的金额
           LET t_amtf2 = 0  LET t_amt2 = 0
           IF g_aptype = '32' OR g_aptype='33' THEN
              IF NOT cl_null(m_apg.apg06) THEN
                 LET g_sql = " SELECT SUM(aph05f),SUM(aph05) ",
                             "   FROM ",cl_get_target_table(g_plant,'aph_file'),",",
                                        cl_get_target_table(g_plant,'apf_file'),
                             "  WHERE aph04= ? AND aph17=? ",
                             "    AND aph01=apf01 AND apf41='Y'",
                             "    AND aph03 IN ('6','7','8','9','G')" #FUN-CB0065 add G

                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                 PREPARE s2_aph_pre2_1 FROM g_sql
                 IF STATUS THEN
                    IF u_sw = 1 THEN
                       CALL s_errmsg('','','s2_aph_pre2',status,1)
                    ELSE
                       CALL cl_err('s2_aph_pre2',status,1)
                    END IF
                    LET g_success='N'
                    EXIT FOREACH
                 END IF

                 DECLARE s2_aph_cur2_1 CURSOR FOR s2_aph_pre2_1
                 OPEN s2_aph_cur2_1 USING m_apg.apg04,m_apg.apg06
                 FETCH s2_aph_cur2_1 INTO t_amtf2,t_amt2
                 IF STATUS THEN
                    IF u_sw = 1 THEN
                       CALL s_errmsg('','','sum h05',STATUS,1)
                    ELSE
                       CALL cl_err('sum h05',STATUS,1)
                    END IF
                    LET g_success='N'
                 END IF
                 IF t_amtf2 IS NULL THEN LET t_amtf2 = 0 END IF
                 IF t_amt2 IS NULL THEN LET t_amt2  = 0 END IF

                 CLOSE s2_aph_cur2_1

                 #LET l_amtf4 = l_amtf4 + t_amtf2 
                 #LET l_amt4 = l_amt4 + t_amt2
              END IF
           END IF
           ##No.MOD-BB0020  --End
          #yinhy131210   --Begin
           LET t_amtf4 = 0    LET t_amt4 = 0
           IF g_aptype = '36' AND m_apf.apf47 =  '2'  THEN                 
              LET g_sql = " SELECT SUM(apv04f),SUM(apv04) ",
                          "   FROM ",cl_get_target_table(g_plant,'apv_file'),
                          "  WHERE apv03= ? AND apv05=? "
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
              PREPARE s2_apv_pre_1 FROM g_sql
              IF STATUS THEN
                 IF u_sw = 1 THEN
                    CALL s_errmsg('','','s2_apv_pre_1',status,1)
                 ELSE
                    CALL cl_err('s2_apv_pre_1',status,1)
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
              END IF            
              DECLARE s2_apv_cur_1 CURSOR FOR s2_apv_pre_1
              OPEN s2_apv_cur_1 USING m_apg.apg04,m_apg.apg06
              FETCH s2_apv_cur_1 INTO t_amtf4,t_amt4
              IF STATUS OR t_amtf4 IS NULL THEN        
                 LET t_amtf4 = 0                       
                 LET t_amt4  = 0                       
              END IF                                   
              CLOSE s2_apv_cur_1               
           END IF
           LET l_amtf4 = l_amtf4 + t_amtf2 + t_amtf3   
           LET l_amt4 = l_amt4 + t_amt2 + t_amtf3
           #yinhy131210   --End           
           IF g_apz.apz27 = 'Y' AND l_apa13 != g_aza.aza17 THEN
              CALL s_g_np1('2',l_apa00,m_apg.apg04,'',m_apg.apg06) RETURNING l_apc13
           ELSE
              #No:181125 add begin --------
              IF g_prog ='aapt332' THEN 
        	       IF l_unfirm = 'N' THEN        #审核 
        	    	    SELECT SUM(apg05f), SUM(apg05) INTO ll_amtf,ll_amt  FROM apg_file, apf_file   #取消审核
                    WHERE apg04 = m_apg.apg04 AND apg01 = apf01
                    AND apf01=g_apf.apf01 
                    IF cl_null(ll_amtf) THEN LET ll_amtf=0 END IF 
                    IF cl_null(ll_amt) THEN LET ll_amt=0 END IF 
                    LET l_amt4 = l_apa35 + ll_amt         #账款冲账金额+本币已冲账金额   
        	          LET l_amtf4 = l_apa35f + ll_amtf      #账款冲账金额+原币已冲账金额   
                    LET l_apc13 = l_apc09 -l_amt4         #本币应冲金额-本币已冲金额     
                 ELSE 
              	    SELECT SUM(apg05f), SUM(apg05) INTO ll_amtf,ll_amt  FROM apg_file, apf_file
                    WHERE apg04 = m_apg.apg04 AND apg01 = apf01
                    AND apf01=g_apf.apf01 #No:170803 add
                    IF cl_null(ll_amtf) THEN LET ll_amtf=0 END IF 
                    IF cl_null(ll_amt) THEN LET ll_amt=0 END IF 
           	        LET l_amt4 = l_apa35 - ll_amt      #本币已冲账金额-账款冲账金额   
           	        LET l_amtf4 = l_apa35f - ll_amtf   #本币已冲账金额-账款冲账金额    
           	        LET l_apc13 = l_apc09 - l_amt4  
           	     END IF 
           	  ELSE    
              #No:181125 add end-----------
              LET  l_apc13= l_apc09 - l_amt4   #No.MOD-740413
              END IF #No:181125 add
           END IF
           LET l_apc13 = l_apc13 - l_apc15                        #MOD-C20202 add
#EXECUTE t310_str4_apc USING l_amtf4,l_amt4,l_apc13,m_apg.apg04,m_apg.apg06                 #CHI-EC0020 mark
           EXECUTE t310_str4_apc USING m_apg.apg05f,m_apg.apg05,m_apg.apg05,m_apg.apg04,m_apg.apg06   #CHI-EC0020 add  
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0  THEN   #CHI-850023    
             #CALL cl_err(m_apg.apg04,SQLCA.SQLCODE,1) #CHI-A60034 mark
              #CHI-A60034 add --start--
              IF u_sw = 1 THEN
                 CALL s_errmsg('apg04',m_apg.apg04,'',SQLCA.SQLCODE,1)
              ELSE
                 CALL cl_err(m_apg.apg04,SQLCA.SQLCODE,1)
              END IF
              #CHI-A60034 add --end--
              LET g_success='N'
              EXIT FOREACH
           END IF
      END FOREACH
      LET l_amtf = 0  LET l_amt = 0
      DECLARE t310_bu_c2 CURSOR FOR
          SELECT * FROM aph_file
           WHERE aph01=m_apf.apf01 AND aph03 IN ('6','7','8','9','G')  #FUN-CB0065 add G
      FOREACH t310_bu_c2 INTO m_aph.*
         IF SQLCA.sqlcode THEN
           #CALL cl_err('t310_bu_c2',SQLCA.sqlcode,0)  #CHI-A60034 mark 
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','t310_bu_c2',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('t310_bu_c2',SQLCA.sqlcode,0) 
            END IF
            #CHI-A60034 add --end--
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_sql = " SELECT SUM(aph05f),SUM(aph05) ",
                   # "   FROM ",s_dbstring(g_dbs CLIPPED),"aph_file,",         #FUN-A50102 mark                                                                        
                   #            s_dbstring(g_dbs CLIPPED),"apf_file",          #FUN-A50102 mark
                     "   FROM ",cl_get_target_table(g_plant,'aph_file'),",",   #FUN-A50102
                                cl_get_target_table(g_plant,'apf_file'),       #FUN-A50102
                     "  WHERE aph04= ? ",                    
                     "    AND aph01=apf01 AND apf41='Y'",
                     "    AND aph03 IN ('6','7','8','9','G')" #FUN-CB0065 add G
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql #FUN-A50102
         PREPARE s2_aph_pre FROM g_sql
         IF STATUS THEN
           #CALL cl_err('s2_aph_pre',status,1) #CHI-A60034 mark
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','s2_aph_pre',status,1)
            ELSE
               CALL cl_err('s2_aph_pre',status,1)
            END IF
            #CHI-A60034 add --end--
            LET g_success='N'
            EXIT FOREACH
         END IF
 
         DECLARE s2_aph_cur CURSOR FOR s2_aph_pre
         OPEN s2_aph_cur USING m_aph.aph04
         FETCH s2_aph_cur INTO l_amtf,l_amt
         IF STATUS THEN
           #CALL cl_err('sum h05',STATUS,1) #CHI-A60034 mark
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','sum h05',STATUS,1)
            ELSE
               CALL cl_err('sum h05',STATUS,1)
            END IF
            #CHI-A60034 add --end--
            LET g_success='N'
         END IF
         IF l_amtf IS NULL THEN
            LET l_amtf = 0
         END IF
         IF l_amt IS NULL THEN
            LET l_amt  = 0
         END IF
 
         CLOSE s2_aph_cur
 
         IF NOT cl_null(m_aph.aph17) THEN
            LET g_sql = " SELECT SUM(aph05f),SUM(aph05) ",
                      # "   FROM ",g_dbs CLIPPED,".aph_file,", #MOD-970282 .-->.           #FUN-A50102 mark
                      #            g_dbs CLIPPED,".apf_file",  #MOD-970282 .-->.           #FUN-A50102 mark
                        "   FROM ",cl_get_target_table(g_plant,'aph_file'),",",            #FUN-A50102
                                   cl_get_target_table(g_plant,'apf_file'),                #FUN-A50102 
                        "  WHERE aph04= ? AND aph17=? ",                    
                        "    AND aph01=apf01 AND apf41='Y'",
                        "    AND aph03 IN ('6','7','8','9','G')"  #FUN-CB0065 add G
 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102
            PREPARE s2_aph_pre2 FROM g_sql
            IF STATUS THEN
              #CALL cl_err('s2_aph_pre2',status,1) #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','s2_aph_pre2',status,1) 
               ELSE
                  CALL cl_err('s2_aph_pre2',status,1)
               END IF
               #CHI-A60034 add --end--
               LET g_success='N'
               EXIT FOREACH
            END IF
 
            DECLARE s2_aph_cur2 CURSOR FOR s2_aph_pre2
            OPEN s2_aph_cur2 USING m_aph.aph04,m_aph.aph17  
            FETCH s2_aph_cur2 INTO l_amtf5,l_amt5
            IF STATUS THEN
              #CALL cl_err('sum h05',STATUS,1) #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','sum h05',STATUS,1)
               ELSE
                  CALL cl_err('sum h05',STATUS,1)
               END IF
               #CHI-A60034 add --end--
               LET g_success='N'
            END IF
            IF l_amtf5 IS NULL THEN
               LET l_amtf5 = 0
            END IF
            IF l_amt5 IS NULL THEN
               LET l_amt5  = 0
            END IF
 
            CLOSE s2_aph_cur2
         END IF 
 
         #---------加總已被K沖帳金額---------------------
         SELECT SUM(apv04f),SUM(apv04) into t1,t2
           FROM apv_file WHERE apv03=m_aph.aph04
         IF t1 IS NULL THEN LET t1 = 0 END IF
         IF t2 IS NULL THEN LET t2 = 0 END IF
         #no.4597  若部份為axrt400沖帳時也要包含
         SELECT SUM(oob09),SUM(oob10) INTO t3,t4
           FROM oob_file,ooa_file
          WHERE oob01 = ooa01
            AND oob06 = m_aph.aph04
            AND oob03 = '2' AND oob04 = '9'
            AND ooaconf = 'Y' #須為已確認
         IF cl_null(t3) THEN LET t3 = 0 END IF
         IF cl_null(t4) THEN LET t4 = 0 END IF
         IF NOT cl_null(m_aph.aph17) THEN
            SELECT SUM(apv04f),SUM(apv04) into t5,t6
              FROM apv_file WHERE apv03=m_aph.aph04
               AND apv05 = m_aph.aph17                #No.FUN-680027 add
            IF t5 IS NULL THEN LET t5 = 0 END IF
            IF t6 IS NULL THEN LET t6 = 0 END IF
            #no.4597  若部份為axrt400沖帳時也要包含
            SELECT SUM(oob09),SUM(oob10) INTO t7,t8
              FROM oob_file,ooa_file
             WHERE oob01 = ooa01
               AND oob06 = m_aph.aph04
               AND oob19 = m_aph.aph17                #No.FUN-680027 add
               AND oob03 = '2' AND oob04 = '9'
               AND ooaconf = 'Y' #須為已確認
            IF cl_null(t7) THEN LET t7 = 0 END IF
            IF cl_null(t8) THEN LET t8 = 0 END IF
         END IF
         #成本分攤
         SELECT SUM(aqb04) INTO t9 FROM aqa_file,aqb_file
          WHERE aqa01 = aqb01 AND aqa04='Y' AND aqaconf = 'Y'
            AND aqb02=m_aph.aph04
         IF cl_null(t9) THEN LET t9 = 0 END IF
         SELECT apa14 INTO l_apa14 FROM apa_file WHERE apa01 =m_aph.aph04
                                                   AND apa02 <= g_apf.apf02          #MOD-A30146 add
         LET t10=t9/l_apa14
        #---------------------------MOD-C90082------------------------(S)
         LET g_sql = "SELECT SUM(apg05f),SUM(apg05) ",
                       "  FROM ",cl_get_target_table(g_plant,'apg_file'),",",
                                 cl_get_target_table(g_plant,'apf_file'),
                       " WHERE apg04 = ? AND apg01 = apf01 AND apf41 = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
         PREPARE s3_apg_pre FROM g_sql
         IF STATUS THEN
            IF u_sw = 1 THEN
               CALL s_errmsg('','','s3_apg_pre',status,1)
            ELSE
               CALL cl_err('s3_apg_pre',status,1)
            END IF
            LET g_success='N'
            EXIT FOREACH
         END IF

         DECLARE s3_apg_cur CURSOR FOR s3_apg_pre
         OPEN s3_apg_cur USING m_aph.aph04
         FETCH s3_apg_cur INTO t11,t12
         IF STATUS OR t11 IS NULL THEN
            LET t11 = 0
            LET t12  = 0
         END IF
         CLOSE s3_apg_cur
        #---------------------------MOD-C90082------------------------(E)
        #--------待抵控制不可沖過----------------------
        #LET g_plant_new = m_aph.aph08   #MOD-B10147 mark 
         LET g_plant_new = g_apz.apz02p  #MOD-B10147
         CALL s_getdbs()
 
         IF g_apz.apz27 = 'N' THEN
               LET g_sql = "SELECT apa34f,apa34,apa35f,apa35,apa00",               #CHI-EC0020 add apa35f,apa35
                      # "  FROM ",g_dbs_new CLIPPED,"apa_file",                 #FUN-A50102 mark
                        "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                        " WHERE apa01=?  AND apa41 = 'Y'",
                        "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
         ELSE
               LET g_sql = "SELECT apa34f,apa35+apa73,apa35f,apa35,apa00",         #CHI-EC0020 add apa35f,apa35
                      # "  FROM ",g_dbs_new CLIPPED,"apa_file",                 #FUN-A50102 mark
                        "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                        " WHERE apa01=?  AND apa41 = 'Y'",
                        "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
         END IF
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE s3_aph_pre FROM g_sql
         IF STATUS THEN
           #CALL cl_err('s3_aph_pre',status,1) #CHI-A60034 mark
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','s3_aph_pre',status,1)
            ELSE
               CALL cl_err('s3_aph_pre',status,1)
            END IF
            #CHI-A60034 add --end--
            LET g_success='N'
            EXIT FOREACH
         END IF
 
         DECLARE s3_aph_cur CURSOR FOR s3_aph_pre
         OPEN s3_aph_cur USING m_aph.aph04
            FETCH s3_aph_cur INTO l_apa34f,l_apa34,l_apa35f,l_apa35,l_apa00   #CHI-EC0020 add l_apa35f,l_apa35
         IF SQLCA.sqlcode THEN
            LET l_apa34f = 0 LET l_apa34 = 0
            LET l_apa35f = 0   #CHI-EC0020 add
               LET l_apa35 = 0    #CHI-EC0020 add
         ELSE
            IF u_sw=1 THEN
              #IF (l_apa34f < (l_amtf+t1+t3+t10) ) OR (l_apa34  < (l_amt +t2+t4+t9)) THEN   #TQC-6C0044 #MOD-C90082 mark
             #IF (l_apa34f < (l_amtf + t1 + t3 + t10 + t11) )      #MOD-C90082 add t11    #CHI-EC0020 mark
                 # OR (l_apa34  < (l_amt + t2 + t4 + t9 + t12)) THEN    #MOD-C90082 add t12   #CHI-EC0020 mark
                  IF (l_apa34f < (l_apa35f + m_aph.aph05f)) OR                                #CHI-EC0020 add
                     (l_apa34  < (l_apa35 + m_aph.aph05)) THEN                                #CHI-EC0020 add
                 #CALL cl_err('','aap-250',1) #CHI-A60034 mark
                  CALL s_errmsg('','','','aap-250',1) #CHI-A60034
                  LET g_success='N'
               END IF
            END IF
         END IF
         CLOSE s3_aph_cur
 
        #LET g_plant_new = m_aph.aph08   #MOD-B10147 mark 
         LET g_plant_new = g_apz.apz02p  #MOD-B10147
         CALL s_getdbs()
       # LET g_sql = "UPDATE ",g_dbs_new CLIPPED,"apa_file ",               #FUN-A50102 mark
       #CHI-EC0020---mark---str--
#         LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102
#                     "   SET apa35f = ?, ",
#                     "       apa35  = ?, ",
#                     "       apa73  = ?  ",
#                     " WHERE apa01=? ",
#                     "   AND apa41 = 'Y' AND apa42 = 'N' ",
#                     "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
 #CHI-EC0020---mark---end--
 #CHI-EC0020---add---str--
            IF u_sw = '1' THEN #確認
               LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'), 
                           "   SET apa35f = apa35f + ?, ",
                           "       apa35  = apa35 + ?, ",
                           "       apa73  = apa73 - ?  ",
                           " WHERE apa01=? ",
                           "   AND apa41 = 'Y' AND apa42 = 'N' ",
                           "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"
            ELSE   #取消確認
               LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),
                           "   SET apa35f = apa35f - ?, ",
                           "       apa35  = apa35 - ?, ",
                           "       apa73  = apa73 + ?  ",
                           " WHERE apa01=? ",
                           "   AND apa41 = 'Y' AND apa42 = 'N' ",
                           "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"
            END IF
           #CHI-EC0020---add---end--
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql       #FUN-A50102
         PREPARE s4_aph_cur FROM g_sql
         IF STATUS THEN
           #CALL cl_err('s4_aph_pre',status,1) #CHI-A60034 mark
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','s4_aph_pre',status,1) 
            ELSE
               CALL cl_err('s4_aph_pre',status,1)
            END IF
            #CHI-A60034 add --end--
            LET g_success='N'
            EXIT FOREACH
         END IF
         LET l_amtf = l_amtf + t1 + t3 + t10 + t11     #MOD-8B0006 mark回復 #MOD-C90082 add t11
         LET l_amt  = l_amt  + t2 + t4 + t9 + t12      #MOD-8B0006 mark回復 #MOD-C90082 add t12
         IF g_apz.apz27 = 'Y' AND m_aph.aph13 != g_aza.aza17 THEN
            CALL s_g_np('2',l_apa00,m_aph.aph04,'') RETURNING l_amt3
         ELSE
            LET l_amt3 = l_apa34 - l_amt
         END IF
         #當付款沖帳是沖8.預付時,實務上本幣金額有可能不等於原幣金額*匯率,
         #所以應直接回寫付款單身輸入的本幣金額,不需重算
         IF m_aph.aph03 != '8' THEN   #MOD-910184 add
            LET g_sql = "SELECT apa14",
                      # "  FROM ",g_dbs_new CLIPPED,"apa_file",                  #FUN-A50102 mark
                        "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102     
                        " WHERE apa01=?  AND apa41 = 'Y'",
                        "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        #FUN-A50102
            PREPARE s3_aph_pre3 FROM g_sql
            IF STATUS THEN 
              #CALL cl_err('s3_aph_pre2',status,1) #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','s3_aph_pre2',status,1)
               ELSE
                  CALL cl_err('s3_aph_pre2',status,1)
               END IF
               #CHI-A60034 add --end--
               LET g_success='N'
               EXIT FOREACH
            END IF 
            DECLARE s3_aph_cur3 CURSOR FOR s3_aph_pre3
            OPEN s3_aph_cur3 USING m_aph.aph04
            FETCH s3_aph_cur3 INTO l_apa14 
            IF l_amtf = l_apa34f THEN
               LET l_amt = l_apa34            #MOD-930243
               LET l_amt = cl_digcut(l_amt,g_azi04)
            END IF
         END IF   #MOD-910184 add
                    #EXECUTE s4_aph_cur USING l_amtf,l_amt,l_amt3,m_aph.aph04                    #CHI-EC0020 mark
            EXECUTE s4_aph_cur USING m_aph.aph05f,m_aph.aph05,m_aph.aph05,m_aph.aph04   #CHI-EC0020 add
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
           #CALL cl_err('s4_aph_cur',SQLCA.sqlcode,1) LET g_success='N' #CHI-A60034 mark
            #CHI-A60034 add --start--
            IF u_sw = 1 THEN
               CALL s_errmsg('','','s4_aph_cur',SQLCA.sqlcode,1) LET g_success='N'
            ELSE
               CALL cl_err('s4_aph_cur',SQLCA.sqlcode,1) LET g_success='N' 
            END IF
            #CHI-A60034 add --end--
         END IF
        #更新apc_file
         IF NOT cl_null(m_aph.aph17) THEN
            IF g_apz.apz27 = 'N' THEN
                  LET g_sql = "SELECT apc08 ,apc09,apc10,apc11,apa00",                     #CHI-EC0020 add apc10,apc11
                         # "  FROM ",g_dbs_new CLIPPED,"apa_file ,",                    #FUN-A50102 mark     
                         #           g_dbs_new CLIPPED,"apc_file  ",                    #FUN-A50102 mark  
                           "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",",   #FUN-A50102
                                     cl_get_target_table(g_plant_new,'apc_file'),       #FUN-A50102
                           " WHERE apc01=? AND apc02=? AND apc01=apa01 AND apa41 = 'Y'",
                           "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
            ELSE
                  LET g_sql = "SELECT apc08,apc11+apc13,apc10,apc11,apa00",              #CHI-EC0020 add apc10,apc11
                         # "  FROM ",g_dbs_new CLIPPED,"apa_file ,",                  #FUN-A50102 mark
                         #           g_dbs_new CLIPPED,"apc_file  ",                  #FUN-A50102 mark
                           "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),",", #FUN-A50102
                                     cl_get_target_table(g_plant_new,'apc_file'),     #FUN-A50102   
                           " WHERE apc01=? AND apc02=? AND apc01=apa01 AND apa41 = 'Y'",
                           "   AND apa02 <= '",g_apf.apf02 CLIPPED,"'"         #MOD-A30146 add
            END IF 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
            PREPARE s3_aph_apc_pre FROM g_sql
            IF STATUS THEN
              #CALL cl_err('s3_aph_apc_pre',status,1) #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','s3_aph_apc_pre',status,1)
               ELSE
                  CALL cl_err('s3_aph_apc_pre',status,1)
               END IF
               #CHI-A60034 add --end--
               LET g_success='N'
               EXIT FOREACH
            END IF
 
            DECLARE s3_aph_cur2 CURSOR FOR s3_aph_apc_pre
            OPEN s3_aph_cur2 USING m_aph.aph04,m_aph.aph17
               FETCH s3_aph_cur2 INTO l_apc08,l_apc09,l_apc10,l_apc11,l_apa00  #No.MOD-740413   #CHI-EC0020 add l_apc10,l_apc11
            IF SQLCA.sqlcode THEN
               LET l_apc08  = 0 LET l_apc09 = 0
            ELSE
               IF u_sw=1 THEN
                 #IF (l_apc08  < (l_amtf5+t5+t7+t10) ) OR (l_apc09  < (l_amt5+t6+t8+t9)) THEN  #No.FUN-7B0055 #MOD-C90082 mark 
                  #IF (l_apc08  < (l_amtf5 + t5 + t7 + t10 + t11) )     #MOD-C90082 add t11    #CHI-EC0020 mark
                    # OR (l_apc09  < (l_amt5 + t6 + t8 + t9 + t12)) THEN   #MOD-C90082 add t12   #CHI-EC0020 mark
                     IF (l_apc08 < (l_apc10 + m_aph.aph05f)) OR                                  #CHI-EC0020 add
                        (l_apc09 < (l_apc11 + m_aph.aph05)) THEN                                 #CHI-EC0020 add 
                    #CALL cl_err('','aap-250',1) #CHI-A60034 mark
                     CALL s_errmsg('','','','aap-250',1) #CHI-A60034
                     LET g_success='N'
                  END IF
               END IF
            END IF
            CLOSE s3_aph_cur2
 
          # LET g_sql = "UPDATE ",g_dbs_new CLIPPED,"apc_file ",                   #FUN-A50102  mark
          # LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),",", #FUN-A50102  #TQC-AC0292
            #CHI-EC0020---mark---str--
              #LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),     #TQC-AC0292
              #            "   SET apc10  = ?, ",
              #            "       apc11  = ?, ",
              #            "       apc13  = ?  ",
              #            " WHERE apc01=? ",
              #            "   AND apc02=? "
              #CHI-EC0020---mark---end--
              #CHI-EC0020---add---str--
               IF u_sw = '1' THEN #確認
                  LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),     #TQC-AC0292
                              "   SET apc10  = apc10 + ?, ",
                              "       apc11  = apc11 + ?, ",
                              "       apc13  = apc13 - ?  ",
                              " WHERE apc01=? ",
                              "   AND apc02=? "
               ELSE   #取消確認
                  LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),     #TQC-AC0292
                              "   SET apc10  = apc10 - ?, ",
                              "       apc11  = apc11 - ?, ",
                              "       apc13  = apc13 + ?  ",
                              " WHERE apc01=? ",
                              "   AND apc02=? "
               END IF
              #CHI-EC0020---add---end--
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql    #FUN-A50102
            PREPARE s4_aph_cur2 FROM g_sql
            IF STATUS THEN
              #CALL cl_err('s4_aph_pre',status,1) #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','s4_aph_pre',status,1)
               ELSE
                  CALL cl_err('s4_aph_pre',status,1)
               END IF
               #CHI-A60034 add --end--
               LET g_success='N'
               EXIT FOREACH
            END IF
            LET l_amtf5 = l_amtf5 + t5 + t7 + t10 + t11  #No.FUN-7B0055  add t10#MOD-C90082 add t11
            LET l_amt5  = l_amt5  + t6 + t8 + t9 + t12   #No.FUN-7B0055  add t9 #MOD-C90082 add t12
            IF g_apz.apz27 = 'Y' AND m_aph.aph13 != g_aza.aza17 THEN
               CALL s_g_np1('2',l_apa00,m_aph.aph04,'',m_aph.aph17) RETURNING l_apc13
            ELSE
               LET l_apc13 = l_apc09 - l_amt5
            END IF
            #當付款沖帳是沖8.預付時,實務上本幣金額有可能不等於原幣金額*匯率,
            #所以應直接回寫付款單身輸入的本幣金額,不需重算
            IF m_aph.aph03 != '8' THEN   #MOD-910184 add
               IF l_amtf5 = l_apc08 THEN
                  LET l_amt5 = l_apc09             #MOD-930243
                  LET l_amt5 = cl_digcut(l_amt5,g_azi04)
               END IF
            END IF   #MOD-910184 add
     #EXECUTE s4_aph_cur2 USING l_amtf5,l_amt5,l_apc13,m_aph.aph04,m_aph.aph17    #No.FUN-690080   #CHI-EC0020 mark
               EXECUTE s4_aph_cur2 USING m_aph.aph05f,m_aph.aph05,m_aph.aph05,m_aph.aph04,m_aph.aph17       #CHI-EC0020 add
                           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
              #CALL cl_err('s4_aph_cur2',SQLCA.sqlcode,1) LET g_success='N' #CHI-A60034 mark
               #CHI-A60034 add --start--
               IF u_sw = 1 THEN
                  CALL s_errmsg('','','s4_aph_cur2',SQLCA.sqlcode,1) LET g_success='N'
               ELSE
                  CALL cl_err('s4_aph_cur2',SQLCA.sqlcode,1) LET g_success='N'
               END IF
               #CHI-A60034 add --end--
            END IF
          
         END IF         
      END FOREACH
#TQC-B10069 -------------------Begin---------------------
     #IF g_success = 'N' THEN EXIT FOREACH END IF 
      IF g_success = 'N' THEN
         CONTINUE FOREACH    
      END IF                   
#TQC-B10069 -------------------End-----------------------
      IF g_aptype <> '32' THEN  #by No.TQC-B20112
         DECLARE t310_bu_c2b CURSOR FOR
             SELECT * FROM aph_file WHERE aph01=m_apf.apf01
                AND aph03 IN ('2','B')
         FOREACH t310_bu_c2b INTO m_aph.*
            IF u_sw=1 THEN
               CALL t310_ins_nme()
            END IF
         END FOREACH
         IF g_success='N' THEN
         #  EXIT FOREACH            #TQC-B10069
            CONTINUE FOREACH        #TQC-B10069
         END IF
      END IF  #by elva end
#No.FUN-A40003 --begin
      IF g_aptype ='32' THEN 
         DECLARE t310_bu_c3b CURSOR FOR
             SELECT * FROM aph_file WHERE aph01=m_apf.apf01
                AND aph03 IN ('1','2')
         FOREACH t310_bu_c3b INTO m_aph.*
            IF u_sw=1 THEN
               IF m_aph.aph03 ='1' THEN 
                  CALL t310_bu_11('+')
               ELSE 
                  CALL t310_bu_12('+')
               END IF 
            ELSE 
               IF m_aph.aph03 ='1' THEN 
                  CALL t310_bu_11('-')
               ELSE 
                  CALL t310_bu_12('-')
               END IF 
            END IF
         END FOREACH
         IF g_success='N' THEN
         #  EXIT FOREACH        #TQC-B10069
            CONTINUE FOREACH    #TQC-B10069
         END IF
      END IF 
#No.FUN-A40003 --end
#No.FUN-A60024 --begin
      IF g_aptype ='36'  THEN   
         IF u_sw ='1' THEN 
            CALL t310_ins_apa()  
         ELSE 
         	  CALL t310_del_apa()
         END IF 
         IF g_success='N' THEN
         #  EXIT FOREACH       #TQC-B10069
         END IF
      END IF 
#No.FUN-A60024 --end
#No.TQC-B80079 --begin
      IF m_apf.apf09 <> 0 THEN 
         IF g_aptype ='33' OR g_aptype ='34' THEN   
            IF u_sw ='1' THEN 
               CALL t310_tmp_pay(m_apf.*)  
            ELSE 
            	  CALL t310_del_tmp_pay(m_apf.*)
            END IF 
            IF g_success='N' THEN
               CONTINUE  FOREACH             
            END IF
         END IF
         IF g_aptype ='32'  THEN   
            IF u_sw ='1' THEN 
               CALL t310_ins_apa()  
            ELSE 
            	  CALL t310_del_apa() 
            END IF 
            IF g_success='N' THEN
               CONTINUE  FOREACH             
            END IF
         END IF
      END IF 
#No.TQC-B80079 --end
#No.FUN-B40011 --begin
        DECLARE t310_bu_cd CURSOR FOR
             SELECT * FROM aph_file WHERE aph01=m_apf.apf01
                AND aph03 = 'D'
         FOREACH t310_bu_cd INTO m_aph.*
            IF u_sw=1 THEN
               CALL t310_ins_nmh()
            ELSE
               CALL t310_del_nmh()
            END IF
         END FOREACH
         IF g_success='N' THEN
            CONTINUE FOREACH
         END IF
#No.FUN-B40011 --end
         #FUN-C90044--ADD----STR
         IF g_aptype = '32' OR g_aptype='33' THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM aph_file WHERE aph03 IN ('E','H') AND aph01= m_apf.apf01 #FUN-CB0117 add--H
            IF l_n = 0  THEN
              #EXIT FOREACH               #MOD-D30176 mark
               CONTINUE FOREACH           #MOD-D30176 add 
            ELSE
               LET g_sql =" SELECT * FROM aph_file WHERE aph03 IN ('E','H') AND aph01 = '",m_apf.apf01,"'" #FUN-CB0117 add--H
               PREPARE t310_aph_pre FROM g_sql
               DECLARE t310_aph_cs  CURSOR FOR t310_aph_pre
               FOREACH t310_aph_cs  INTO l_aph.*
                  IF u_sw=1 THEN
                     CALL t310_ins_apa_1(l_aph.*)
                  ELSE
                     CALL t310_del_apa_1(l_aph.*)
                  END IF
               END FOREACH
               IF g_success='N' THEN
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #FUN-C90044---ADD---END
   END FOREACH
  #IF l_flag = 0 THEN CALL cl_err('',100,1) LET g_success = 'N' END IF   #MOD-590054 #CHI-A60034 mark
   #CHI-A60034 add --start--
   IF u_sw = 1 THEN
      IF l_flag = 0 THEN CALL s_errmsg('','','',100,1) LET g_success = 'N' END IF
   ELSE
      IF l_flag = 0 THEN CALL cl_err('',100,1) LET g_success = 'N' END IF
   END IF
   #CHI-A60034 add --end--
   CALL cl_msg("")                                #FUN-640240
END FUNCTION

#No.FUN-B40011 --begin
FUNCTION t310_ins_nmh()
   DEFINE l_nmh42    LIKE  nmh_file.nmh42
   
   IF m_aph.aph03 != 'D' THEN RETURN END IF

   SELECT nmh42 INTO l_nmh42
     FROM nmh_file
    WHERE nmh01 = m_aph.aph04
    
   IF cl_null(l_nmh42) THEN LET l_nmh42 = 0 END IF
      
   UPDATE nmh_file SET nmh42 = m_aph.aph05f+l_nmh42
    WHERE nmh01 = m_aph.aph04
     IF STATUS THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh42',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh42','axr-198',1) LET g_success = 'N' RETURN      #NO.FUN-710050
     END IF   
END FUNCTION

FUNCTION t310_del_nmh()
    DEFINE l_nmh42    LIKE  nmh_file.nmh42
   
   IF m_aph.aph03 != 'D' THEN RETURN END IF

   SELECT nmh42 INTO l_nmh42
     FROM nmh_file
    WHERE nmh01 = m_aph.aph04
    
   IF cl_null(l_nmh42) THEN LET l_nmh42 = 0 END IF
      
   UPDATE nmh_file SET nmh42 = l_nmh42 - m_aph.aph05f
    WHERE nmh01 = m_aph.aph04
     IF STATUS THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh42',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh42','axr-198',1) LET g_success = 'N' RETURN      #NO.FUN-710050
     END IF
END FUNCTION
#No.FUN-B40011 --end
 
FUNCTION t310_ef()
   CALL s_showmsg_init()     #TQC-B10069
   LET g_success = "Y"       #TQC-B10069
   CALL t310_firm1_chk()     #CALL 原確認的 check 段   #FUN-580150
   CALL s_showmsg()          #TQC-B10069
   IF g_success = "N" THEN
       RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli2()
# 傳入參數. (1)單頭資料, (2-6)單身資料
# 回傳值  . 0 開單失敗; 1 開單成功
##########
 
  IF aws_efcli2(base.TypeInfo.create(g_apf),base.TypeInfo.create(g_apg),base.TypeInfo.create(g_aph),'','','') THEN
     LET g_success = 'Y'
     LET g_apf.apf42 = 'S'
     DISPLAY BY NAME g_apf.apf42
  ELSE
     LET g_success = 'N'
  END IF
 
END FUNCTION
 
FUNCTION t310_ins_nme()
   DEFINE l_nme            RECORD LIKE nme_file.*
   DEFINE l_legal          LIKE azw_file.azw02  #FUN-980001 add
   DEFINE l_nma21          LIKE nma_file.nma21  #MOD-B80144

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF g_apz.apz04 = 'N' THEN RETURN END IF
   IF m_aph.aph03 NOT MATCHES '[2B]' THEN RETURN END IF
   LET l_nme.nme00=0
   LET l_nme.nme01=m_aph.aph08
   LET l_nme.nme02=m_apf.apf02   #MOD-880017 mark還原
   LET l_nme.nme03=m_aph.aph16
   LET l_nme.nme04=m_aph.aph05f
   LET l_nme.nme07=m_aph.aph14
   LET l_nme.nme08=m_aph.aph05
   LET l_nme.nme10=m_apf.apf44
   LET l_nme.nme11=m_apf.apf11
   LET l_nme.nme12=m_apf.apf01
   LET l_nme.nme13=m_apf.apf12
#   LET l_nme.nme14=''
   LET l_nme.nme14 = m_apf.apf14    #No.FUN-A40003
   IF cl_null(l_nme.nme14) THEN     #No.FUN-A40003      
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
       WHERE nmc01 = m_aph.aph16
   END IF                           #No.FUN-A40003
   LET l_nme.nme15=m_apf.apf05
   LET l_nme.nme16=m_apf.apf02
   IF g_aptype ='33' OR g_aptype ='36' THEN         #No.FUN-A60024                                                                                                     
      LET l_nme.nme22='01'                                                                                                          
   END IF                                                                                                                           
   IF g_aptype ='34' THEN                                                                                                           
      LET l_nme.nme22='02'                                                                                                          
   END IF                                                                                                                           
   LET l_nme.nme24='9'                                                                                                              
   LET l_nme.nme25=m_apf.apf03                                                                                                      
   LET l_nme.nme21=m_aph.aph02                                                                                                      
   LET l_nme.nme23=m_aph.aph03 
   LET l_nme.nme17 = ""
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nmeoriu=g_user  #TQC-A10060  add
   LET l_nme.nmeorig=g_grup  #TQC-A10060  add

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

   CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
      IF l_nme.nme23 = '2' THEN   #No.TQC-740142

         #MOD-B80144--add--str--
         LET l_nma21 = NULL
         SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_nme.nme01
         IF l_nma21 IS NOT NULL AND l_nma21 >= l_nme.nme16 THEN
            CALL s_errmsg('nme16',l_nme.nme16,'','anm-225',1) 
            LET g_success='N'
            RETURN
         END IF   
         #MOD-B80144--add--end--

        #-MOD-B50123-mark-
       ##LET g_sql="INSERT INTO ",g_dbs_nm CLIPPED,"nme_file",                 #FUN-A50102
        #LET g_sql="INSERT INTO ",cl_get_target_table(g_apz.apz04p,'nme_file'), #FUN-A50102
        #          "       (nme00,nme01,nme02,nme03,nme04,nme07,nme08,nme10,nme11,nme12,nmeoriu,nmeorig,",      #TQC-A10060   add nmeoriu,nmeorig
        #         #"        nme13,nme14,nme15,nme16,nme17,nmeacti,nmeuser,nmegrup,nmedate,nme21,nme22,nme23,nme24,nme25,nmelegal)", #FUN-980001 add nmelegal  #FUN-B30166 Mark
        #          "        nme13,nme14,nme15,nme16,nme17,nmeacti,nmeuser,nmegrup,nmedate,nme21,nme22,nme23,nme24,nme25,nme27,nmelegal)", #FUN-980001 add nmelegal  #FUN-B30166 add nme27
        #          " VALUES('",l_nme.nme00,"',",
        #                  "'",l_nme.nme01,"',",
        #                  "'",l_nme.nme02,"',",
        #                  "'",l_nme.nme03,"',",
        #                  "'",l_nme.nme04,"',",
        #                  "'",l_nme.nme07,"',",
        #                  "'",l_nme.nme08,"',",
        #                  "'",l_nme.nme10,"',",
        #                  "'",l_nme.nme11,"',",
        #                  "'",l_nme.nme12,"',",
        #                  "'",l_nme.nmeoriu,"',",      #TQC-A10060  add
        #                  "'",l_nme.nmeorig,"',",      #TQC-A10060  add
        #                  "'",l_nme.nme13,"',",
        #                  "'",l_nme.nme14,"',",
        #                  "'",l_nme.nme15,"',",
        #                  "'",l_nme.nme16,"',",
        #                  "'",l_nme.nme17,"',",
        #                  "'",l_nme.nmeacti,"',",
        #                  "'",l_nme.nmeuser,"',",
        #                  "'",l_nme.nmegrup,"',",
        #                  "'",l_nme.nmedate,"',",   #No.TQC-740095 add ','
        #                  "'",l_nme.nme21,"',",     #No.TQC-740095 add ','
        #                  "'",l_nme.nme22,"',",     #No.TQC-740095 add ','
        #                  "'",l_nme.nme23,"',",     #No.TQC-740095 add ','
        #                  "'",l_nme.nme24,"',",     #No.TQC-740095 add ','
        #                  "'",l_nme.nme25,"',",
        #                  "'",l_nme.nme27,"',",     #FUN-B30166 add nme27
        #                  "'",l_legal,"' )" #FUN-980001 add l_legal
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                 #FUN-920032
        #CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql    #FUN-A50102
        #PREPARE t310_y_nme_p FROM g_sql
        ##IF STATUS THEN CALL cl_err('',STATUS,0) LET g_success = 'N' END IF   #FUN-890128 #CHI-A60034 mark
        #IF STATUS THEN CALL s_errmsg('','','',STATUS,1) LET g_success = 'N' END IF #CHI-A60034
        #EXECUTE t310_y_nme_p
        #-MOD-B50123-add-
         INSERT INTO nme_file
                     (nme00,  nme01,  nme02,  nme03,  nme04,
                      nme07,  nme08,  nme10,  nme11,  nme12,
                      nme13,  nme14,  nme15,  nme16,  nme17,
                      nmeacti,nmeuser,nmegrup,nmedate,nme21,
                      nme22,  nme23,  nme24,  nme25,  nme27,
                      nmeoriu,nmeorig,nmelegal)
              VALUES (l_nme.nme00,  l_nme.nme01,  l_nme.nme02,  l_nme.nme03,  l_nme.nme04,
                      l_nme.nme07,  l_nme.nme08,  l_nme.nme10,  l_nme.nme11,  l_nme.nme12,
                      l_nme.nme13,  l_nme.nme14,  l_nme.nme15,  l_nme.nme16,  l_nme.nme17,
                      l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmedate,l_nme.nme21,
                      l_nme.nme22,  l_nme.nme23,  l_nme.nme24,  l_nme.nme25,  l_nme.nme27,
                      l_nme.nmeoriu,l_nme.nmeorig,l_legal )
        #-MOD-B50123-end-
         IF SQLCA.sqlcode THEN   #CHI-850023
           #CALL cl_err('ins nme:',SQLCA.sqlcode,1) #CHI-A60034 mark
            CALL s_errmsg('','','ins nme:',SQLCA.sqlcode,1) #CHI-A60034
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
           #CALL cl_err('ins nme:',SQLCA.SQLCODE,1) #CHI-A60034 mark
            CALL s_errmsg('','','ins nme:',SQLCA.SQLCODE,1) #CHI-A60034
            LET g_success='N'
            RETURN
         END IF
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
      END IF #No.TQC-740142
END FUNCTION
 
FUNCTION t310_del_nme()
   DEFINE l_n      LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_nme24  LIKE nme_file.nme24    #No.FUN-730032
   DEFINE l_aza73  LIKE aza_file.aza73    #No.MOD-740346
   #MOD-B80144--add--str--
   DEFINE l_nma21  LIKE nma_file.nma21 
   DEFINE l_nme01  LIKE nme_file.nme01 
   DEFINE l_nme16  LIKE nme_file.nme16
   #MOD-B80144--add--end-- 
 
   IF g_apz.apz04 = 'N' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM aph_file
    WHERE aph01=m_apf.apf01 AND aph03 IN ('2','B')
   IF l_n = 0 THEN RETURN END IF
   #MOD-B80144--add--str--
   DECLARE del_nme16 CURSOR FOR
    SELECT nme01,nme16 FROM nme_file
     WHERE nme12 = m_apf.apf01
   FOREACH del_nme16 INTO l_nme01,l_nme16
      LET l_nma21 = NULL
      SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_nme01
      IF l_nma21 IS NOT NULL AND l_nma21 >= l_nme16 THEN
         CALL s_errmsg('nme16',l_nme16,'','anm-225',1)
         LET g_success='N'
         RETURN
      END IF
   END FOREACH
   #MOD-B80144--add--end--
 
 # LET g_sql="SELECT aza73 FROM ",g_dbs_nm CLIPPED,"aza_file"                   #FUN-A50102 mark
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_apz.apz04p,'aza_file')  #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql      #FUN-A50102
   PREPARE t741_aza_p FROM g_sql
   DECLARE t741_aza_c CURSOR FOR t741_aza_p
   OPEN t741_aza_c
   FETCH t741_aza_c INTO l_aza73
   IF l_aza73 = 'Y' THEN
    # LET g_sql="SELECT nme24 FROM ",g_dbs_nm CLIPPED,"nme_file",                  #FUN-A50102 mark
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_apz.apz04p,'nme_file'),  #FUN-A50102
                " WHERE nme12='",m_apf.apf01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql   #FUN-A50102
      PREPARE t310_z_nme_p1 FROM g_sql
      DECLARE t310_z_nme_c1 CURSOR FOR t310_z_nme_p1  #No.FUN-740007
      FOREACH t310_z_nme_c1 INTO l_nme24
         IF l_nme24 <> '9' THEN
           #CALL cl_err('','anm-043',1) #CHI-A60034 mark
            CALL s_errmsg('','','','anm-043',1) #CHI-A60034
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346
 
   LET l_n = 0
 # LET g_sql="SELECT COUNT(*) FROM ",g_dbs_nm CLIPPED,"nme_file",                 #FUN-A50102 mark
   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_apz.apz04p,'nme_file'), #FUN-A50102
             " WHERE nme12='",m_apf.apf01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql    #FUN-A50102
   PREPARE t310_z_nme_p_cnt FROM g_sql
   EXECUTE t310_z_nme_p_cnt INTO l_n
   IF l_n > 0 THEN
    # LET g_sql="DELETE FROM ",g_dbs_nm CLIPPED,"nme_file",                 #FUN-A50102 mark
      LET g_sql="DELETE FROM ",cl_get_target_table(g_apz.apz04p,'nme_file'), #FUN-A50102   
                " WHERE nme12='",m_apf.apf01,"'"   #MOD-620030
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql              #FUN-A50102 
      PREPARE t310_z_nme_p FROM g_sql
      EXECUTE t310_z_nme_p
      IF SQLCA.sqlcode THEN   #CHI-850023
        #CALL cl_err('del nme:',SQLCA.sqlcode,1) #CHI-A60034 mark
         CALL s_errmsg('','','del nme:',SQLCA.sqlcode,1) #CHI-A60034
         LET g_success='N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
        #CALL cl_err('no nme deleted:','aap-161',1) #CHI-A60034 mark
         CALL s_errmsg('','','no nme deleted:','aap-161',1) #CHI-A60034
         LET g_success='N'
          RETURN
      END IF
      #FUN-B40056 --begin
      IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
         LET g_sql="DELETE FROM ",cl_get_target_table(g_apz.apz04p,'tic_file'),  
                   " WHERE tic04 ='",m_apf.apf01,"'"   
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
         CALL cl_parse_qry_sql(g_sql,g_apz.apz04p) RETURNING g_sql             
         PREPARE t310_z_tic_p FROM g_sql
         EXECUTE t310_z_tic_p
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','del nme:',SQLCA.sqlcode,1)
            LET g_success='N'
            RETURN
         END IF
      END IF
      #FUN-B40056 --end
   END IF   #MOD-870048 add
END FUNCTION
 
FUNCTION t310_firm2()
   DEFINE  l_amt   LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE  l_cnt   LIKE type_file.num5        #No.FUN-690028 SMALLINT
   DEFINE only_one LIKE type_file.chr1        # No.FUN-690028    VARCHAR(1)
   DEFINE  l_aba19 LIKE aba_file.aba19   #No.FUN-670060
   DEFINE  l_sql   STRING           #No.FUN-670060  #No.FUN-690028 CHAR(1000) #MOD-B50038 mod STRING
   DEFINE  l_dbs   STRING                #No.FUN-670060
   DEFINE  l_aph02 LIKE aph_file.aph02   #MOD-B50038
   DEFINE  l_gaq03 LIKE gaq_file.gaq03   #MOD-B50038
   DEFINE  l_msg   LIKE gaq_file.gaq03   #MOD-B50038
   DEFINE  l_apa35 LIKE apa_file.apa35   #No.TQC-CB0016   Add
   DEFINE  l_apa35f LIKE apa_file.apa35f  #No.TQC-CB0016   Add
   DEFINE  l_apa01  LIKE apa_file.apa01  #No.TQC-CB0016   Add
 
   IF g_apf.apf01 IS NULL THEN RETURN END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
   IF g_apf.apf41 = 'N' THEN RETURN END IF
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   #No.MOD-D80175  --Begin  
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM nmg_file
    WHERE nmg31 = g_apf.apf01
      AND nmgconf != 'X'
   IF l_cnt > 0 THEN 
   	  CALL cl_err("","aap-186",0)
      RETURN  
   END IF
   #No.MOD-D80175  --End

  #No.TQC-CB0016 ---start--- Add
   SELECT apa01,apa35f,apa35 INTO l_apa01,l_apa35f,l_apa35 FROM apa_file,aph_file
    WHERE apa01 = aph23
      AND aph03 = 'E'
      AND aph01 = g_apf.apf01
   IF cl_null(l_apa35f) THEN LET l_apa35f = 0 END IF
   IF cl_null(l_apa35) THEN LET l_apa35 = 0 END IF
   IF l_apa35f > 0 OR l_apa35 > 0 THEN
      CALL cl_err3("","apa01",l_apa01,"","aap-369","","sel apa.",1)
      RETURN
   END IF
  #No.TQC-CB0016 ---start--- Add
 
   IF g_apf.apf42 = "S" THEN
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
   SELECT count(*) INTO l_cnt FROM aph_file WHERE aph01 = g_apf.apf01
                                              AND aph03 = '0'
   IF l_cnt > 0 THEN
      CALL cl_err(g_apf.apf01,'mfg-013',0)
      RETURN
   END IF
  #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
  CALL s_get_doc_no(g_apf.apf01) RETURNING g_t1     #No.FUN-550071
  SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
  IF NOT cl_null(g_apf.apf44) AND NOT cl_null(g_apf.apf43) THEN #No.FUN-680029 
     IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
        CALL cl_err(g_apf.apf01,'aap-145',0) RETURN
     END IF
  END IF
  IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
     LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",                             #FUN-A50102 mark
     LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102  
                 "  WHERE aba00 = '",g_apz.apz02b,"'",
                 "    AND aba01 = '",g_apf.apf44,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
     PREPARE aba_pre FROM l_sql
     DECLARE aba_cs CURSOR FOR aba_pre
     OPEN aba_cs
     FETCH aba_cs INTO l_aba19
     IF l_aba19 = 'Y' THEN
        CALL cl_err(g_apf.apf44,'axr-071',1)
        RETURN
     END IF
   END IF
   #-MOD-B50038-add-
    DECLARE t310_aph02_c CURSOR FOR
        SELECT aph02 FROM aph_file
         WHERE aph01 = g_apf.apf01 
    FOREACH t310_aph02_c INTO l_aph02
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM nme_file
        WHERE nme12 = g_apf.apf01 
          AND nme21 = l_aph02
          AND nme26 = 'Y'
       IF l_cnt > 0 THEN
          CALL cl_get_feldname('aph02',g_lang) RETURNING l_gaq03
          LET l_msg = l_gaq03 , ' = ' ,l_aph02, ','
          CALL cl_err(l_msg,'anm-043',1)
          RETURN
       END IF 
    END FOREACH 
   #-MOD-B50038-end-

   LET only_one = '1'
   IF only_one = '1' THEN
      LET g_wc = " apf01 = '",g_apf.apf01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
 
      CONSTRUCT BY NAME g_wc ON apf44,apf01,apf02,apf04,apf05
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(apf01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_apf1"
                    LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf01
                    NEXT FIELD apf01
                 WHEN INFIELD(apf04) # Employee CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf04
                 WHEN INFIELD(apf05) # Dept CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf05
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
             CALL cl_qbe_select()
                 ON ACTION qbe_save
     CALL cl_qbe_save()
           END CONSTRUCT
           IF INT_FLAG THEN
              LET INT_FLAG=0
              CLOSE WINDOW t310_w7
              RETURN
           END IF
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t310_w7
      RETURN
   END IF
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND apfuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND apfgrup = '",g_grup,"'"
   END IF
   LET g_sql = "SELECT SUM(apf10) FROM apf_file",
               " WHERE apf41 != 'N' AND ",g_wc clipped
   PREPARE t310_firm2_p2 FROM g_sql
   DECLARE t310_firm2_c2 CURSOR FOR t310_firm2_p2
   OPEN t310_firm2_c2
   FETCH t310_firm2_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   DISPLAY BY NAME l_amt
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
       IF NOT cl_null(g_apf.apf44) then   #TQC-C40095  ADD
       #str MOD-B60158 add
       #IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' AND g_success = 'Y' THEN   #MOD-BC0181 mark
        IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN                       #MOD-BC0181
           LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apf.apf44,"' 'Y'"
           CALL cl_cmdrun_wait(g_str)
        END IF   #MOD-BC0181 add
         SELECT apf44,apf43 INTO g_apf.apf44,g_apf.apf43 FROM apf_file
          WHERE apf01 = g_apf.apf01
         DISPLAY BY NAME g_apf.apf44
         DISPLAY BY NAME g_apf.apf43
         IF NOT cl_null(g_apf.apf44) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
        END IF  #TQC-C40095  ADD
     #END IF   #MOD-BC0181 mark
     #end MOD-B60158 add

      BEGIN WORK         #No.TQC-6B0066
      LET g_success='Y'   #MOD-760053
      CALL t310_bu(0,1)
#No.FUN-C90027--BEGIN
      SELECT apz70 INTO g_apz.apz70 FROM apz_file
      IF g_aptype='36'  THEN                           #FUN-C90044
         IF g_apf.apf47 = '2' THEN #xuxz add 20130611
            UPDATE aph_file SET aph23 = g_apz.apz70
             WHERE aph01 = g_apf.apf01 #xuxz add 20130611
         ELSE #xuxz add 20130611
            UPDATE aph_file SET aph23 = g_apz.apz64#xuxz add 20130611
             WHERE aph01 = g_apf.apf01#xuxz add 20130611
         END IF #xuxz add 20130611
      END IF                                           #FUN-C90044
#No.FUN-C90027--END
      #FUN-C90122--add--str--
      IF g_aptype='33' AND g_success='Y' THEN
         CALL t310_upd_nmd55('N') #檔付款類型為F:已開票據時，取消審核后回寫nmd55
      END IF
      #FUN-C90122--add--end
      #FUN-CB0065--add--str--
      IF g_aptype='33' AND g_success='G' THEN
         CALL t310_upd_apa('N')  #檔付款類型為G：員工借支，審核后回寫借支單金額 
      END IF
      #FUN-CB0065--add--end
      IF g_success ='N' THEN
         ROLLBACK WORK
      ELSE
        COMMIT WORK
      END IF
   END IF
  
   IF g_apf.apf01 IS NOT NULL THEN
      SELECT apf41 INTO g_apf.apf41 FROM apf_file WHERE apf01 = g_apf.apf01
      DISPLAY BY NAME g_apf.apf41
      SELECT apf42 INTO g_apf.apf42 FROM apf_file WHERE apf01 = g_apf.apf01
      DISPLAY BY NAME g_apf.apf42
   END IF
  #str MOD-B60158 mark  #移到前面去
  #IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apf.apf44,"' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT apf44,apf43 INTO g_apf.apf44,g_apf.apf43 FROM apf_file
  #    WHERE apf01 = g_apf.apf01
  #   DISPLAY BY NAME g_apf.apf44
  #   DISPLAY BY NAME g_apf.apf43
  #END IF
  #end MOD-B60158 mark  #移到前面去
END FUNCTION
 
FUNCTION t310_v(p_cmd)
   DEFINE l_wc    STRING #No.FUN-690028 VARCHAR(100) #MOD-BB0305 mod 1000 -> STRING
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_apf00 LIKE apf_file.apf00
   DEFINE l_apf01 LIKE apf_file.apf01
   DEFINE only_one    LIKE type_file.chr1        # No.FUN-690028  VARCHAR(1)
   DEFINE l_t1        LIKE apy_file.apyslip      # No.FUN-690028 VARCHAR(5)     #FUN-560095"
   DEFINE l_cnt       LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_apydmy3   LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
   SELECT * INTO g_apf.* FROM apf_file WHERE apf01 = g_apf.apf01
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-C30140--add---str---
   IF NOT cl_null(g_apf.apf42) AND g_apf.apf42 matches '[Ss]' THEN
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF
   #FUN-C30140--add---end---
   IF p_cmd  = '1' THEN
      OPEN WINDOW t310_w9 AT 10,10 WITH FORM "aap/42f/aapt310_9"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt310_9")
 
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
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
         CLOSE WINDOW t310_w9
         RETURN
      END IF
      IF only_one = '1' THEN
         LET l_wc = " apf01 = '",g_apf.apf01,"' "
      ELSE
         CALL cl_set_head_visible("","YES")     #No.FUN-6B0033   
 
         CONSTRUCT BY NAME l_wc ON apf01,apf02,apf04,apf05,apf03
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
               ON ACTION CONTROLP
                 CASE
                    WHEN INFIELD(apf01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_apf1"
                    LET g_qryparam.where ="apf00 ='",g_aptype CLIPPED,"'"      #No.MOD-910030
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO apf01
                    NEXT FIELD apf01
                    WHEN INFIELD(apf03) #PAY TO VENDOR
                       #判断如果是大陆版且客户可以立账 开窗可以开厂商+客户
                       #FUN-DA0051 ----- add ----- begin
                       IF (g_aptype = '32' OR g_aptype = '33') AND g_aza.aza26 AND g_apz.apz74 = 'Y' THEN
                          CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                       ELSE
                       #FUN-DA0051 ----- add ----- end
                       IF g_aptype = '31' OR g_aptype = '32' OR g_aptype = '33' OR g_aptype ='36' THEN  #No.FUN-A60024
                          CALL cl_init_qry_var()
                          LET g_qryparam.state = "c"
                          LET g_qryparam.form ="q_pmc"
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                       ELSE #CALL q_gen(0,0,g_apf.apf03) RETURNING g_apf.apf03
                          CALL cl_init_qry_var()
                          LET g_qryparam.state = "c"
                          LET g_qryparam.form ="q_gen"      #No.CHI-780046
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                       END IF
                       END IF     #FUN-DA0051 add
                       DISPLAY g_qryparam.multiret TO apf03
                       CALL t310_apf03('d')
                    WHEN INFIELD(apf04) # Employee CODE
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gen"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO apf04
                    WHEN INFIELD(apf05) # Dept CODE
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO apf05
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
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      END CONSTRUCT
          IF INT_FLAG THEN
             LET INT_FLAG=0
             CLOSE WINDOW t310_w9
             RETURN
          END IF
      END IF
      CLOSE WINDOW t310_w9
   ELSE
     #LET l_wc = " apf01 = '",m_apf.apf01,"' "   #FUN-C90044
      LET l_wc = " apf01 = '",g_apf.apf01,"' "   #FUN-C90044
   END IF
   IF p_cmd='1' THEN
      LET g_success='Y'
      BEGIN WORK
   END IF
   MESSAGE "WORKING !"
   LET g_sql = "SELECT apf00,apf01 FROM apf_file WHERE ",l_wc CLIPPED,
               "   AND apf00 = '",g_aptype,"'",
               "   AND (apf44 IS NULL OR apf44 = ' ')",
               "   AND apf41 != 'Y' "
   PREPARE t310_v_p FROM g_sql
   DECLARE t310_v_c CURSOR WITH HOLD FOR t310_v_p
   LET l_cnt = 0                                       #MOD-C90060 add
   FOREACH t310_v_c INTO l_apf00,l_apf01
      IF STATUS THEN EXIT FOREACH END IF
      LET l_t1=s_get_doc_no(l_apf01)    #No.FUN-550030
      LET l_apydmy3 = ''
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_t1
      IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","apy_file",l_t1,"",STATUS,"","sel apy.",1)  #No.FUN-660122
      END IF
      IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
         IF l_cnt = 0 THEN                                   #MOD-C90060 add
            IF NOT s_ask_entry(l_apf01) THEN RETURN END IF   #MOD-C90060 add
            CALL t310_g_gl(l_apf00,l_apf01,'0')
            IF g_aza.aza63 = 'Y' THEN
                 CALL t310_g_gl(l_apf00,l_apf01,'1')
            END IF
            LET l_cnt = l_cnt + 1                           #MOD-C90060 add
          ELSE                                              #MOD-C90060 add
            CALL t310_g_gl(l_apf00,l_apf01,'0')             #MOD-C90060 add
            IF g_aza.aza63 = 'Y' THEN                       #MOD-C90060 add
               CALL t310_g_gl(l_apf00,l_apf01,'1')          #MOD-C90060 add
            END IF                                          #MOD-C90060 add
          END IF                                            #MOD-C90060 add
      END IF
   END FOREACH
   IF p_cmd='1' THEN
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   MESSAGE " "
END FUNCTION
 
FUNCTION t310_input_apl()
   DEFINE l_apl RECORD LIKE apl_file.*
 
   LET l_apl.apl01 = g_apf.apf13
   SELECT * INTO l_apl.* FROM apl_file WHERE apl01 = l_apl.apl01
 
 
   OPEN WINDOW t310_apl AT 7,24 WITH FORM "aap/42f/aapt310_b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt310_b")
 
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INPUT BY NAME l_apl.apl01,l_apl.apl02,l_apl.apl03 WITHOUT DEFAULTS
      AFTER FIELD apl01
         SELECT * INTO l_apl.* FROM apl_file WHERE apl01 = l_apl.apl01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","apl_file",l_apl.apl01,"","aap-205","","",1)  #No.FUN-660122
         ELSE
            DISPLAY BY NAME l_apl.apl02,l_apl.apl03
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
   CLOSE WINDOW t310_apl
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_apf.apf13 = l_apl.apl01
   LET g_apf.apf12 = l_apl.apl02[1,8]
   DISPLAY BY NAME g_apf.apf12,g_apf.apf13
   UPDATE apl_file SET * = l_apl.* WHERE apl01 = l_apl.apl01
   IF SQLCA.sqlcode THEN   #CHI-850023
      CALL cl_err3("upd","apl_file",l_apl.apl01,"",SQLCA.sqlcode,"","upd apl",1)  #No.FUN-660122
      RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN
      INSERT INTO apl_file VALUES (l_apl.*)
      IF SQLCA.sqlcode THEN   #CHI-850023
         CALL cl_err3("ins","apl_file",l_apl.apl01,"",STATUS,"","ins apl",1)  #No.FUN-660122
         RETURN
      END IF
   END IF
END FUNCTION
 
#作废/取消作废
#FUNCTION t310_x()                        #FUN-D20035
FUNCTION t310_x(p_type)                   #FUN-D20035    
   DEFINE l_cnt   LIKE type_file.num5     #MOD-870048 add
   DEFINE p_type    LIKE type_file.chr1               #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1               #FUN-D20035
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_apf.apf01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
 
    IF g_apf.apf42 matches '[Ss1]' THEN    #MOD-4A0299
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF  #FUN-CB0054 mark
   IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF #FUN-CB0054 add

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_apf.apf41='X' THEN RETURN END IF
   ELSE
      IF g_apf.apf41<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t310_cl USING g_apf.apf01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl.", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_apf.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_apf.apf01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
  #IF cl_void(0,0,g_apf.apf41) THEN                                    #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      #IF g_apf.apf41 ='N' THEN    #切換為作廢                         #FUN-D20035
      #作废操作时
      IF p_type = 1 THEN                                               #FUN-D20035
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM npp_file
          WHERE npp01=g_apf.apf01 AND nppsys='AP' AND npp00=3 AND npp011=1
         IF l_cnt > 0 THEN
            DELETE FROM npp_file
             WHERE npp01=g_apf.apf01 AND nppsys='AP' AND npp00=3 AND npp011=1
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
               CALL cl_err3("del","npp_file",g_apf.apf01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
               LET g_success='N'
            END IF
         END IF   #MOD-870048 add
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM npq_file
          WHERE npq01=g_apf.apf01 AND npqsys='AP' AND npq00=3 AND npq011=1
         IF l_cnt > 0 THEN
            DELETE FROM npq_file
             WHERE npq01=g_apf.apf01 AND npqsys='AP' AND npq00=3 AND npq011=1
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
               CALL cl_err3("del","npq_file",g_apf.apf01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
               LET g_success='N'
            END IF
         END IF   #MOD-870048 add

         #FUN-B40056--add--str--
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM tic_file
          WHERE tic04 = g_apf.apf01
         IF l_cnt > 0 THEN
            DELETE FROM tic_file WHERE tic04 = g_apf.apf01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("del","tic_file",g_apf.apf01,"",SQLCA.sqlcode,"","del tic.",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF
         #FUN-B40056--add--end--          

         LET g_apf.apf41='X'
         LET g_apf.apf42='9'   #No.FUN-540047
      ELSE                        #取消作廢
         LET g_apf.apf41='N'
         LET g_apf.apf42='0'   #No.FUN-540047
      END IF
      UPDATE apf_file SET apf41 = g_apf.apf41,
                          apf42 = g_apf.apf42   #No.FUN-540047
       WHERE apf01 = g_apf.apf01
      IF SQLCA.sqlcode THEN   #CHI-850023
         CALL cl_err3("upd","apf_file",g_apf.apf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122   #CHI-850023
         LET g_success = 'N'
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('','aap-161',0) LET g_success='N'
      END IF
   END IF
   SELECT apf41 INTO g_apf.apf41 FROM apf_file WHERE apf01 = g_apf.apf01
   SELECT apf42 INTO g_apf.apf42 FROM apf_file WHERE apf01 = g_apf.apf01
   DISPLAY BY NAME g_apf.apf41
   DISPLAY BY NAME g_apf.apf42
   CLOSE t310_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_apf.apf01,'V')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t310_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("apf01",TRUE)
      CALL cl_set_comp_entry("apf03",TRUE)  #add by liyjf161109
    END IF
 
    IF INFIELD(apf03) THEN
      CALL cl_set_comp_entry("apf12,apf13",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
  DEFINE l_pmc14   LIKE pmc_file.pmc14  #FUN-A40037 add                         
  DEFINE l_flag    LIKE type_file.chr1  #FUN-A40037 add 
  DEFINE l_n     LIKE type_file.num5    #FUN-D40083 add
  
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("apf01",FALSE)
       #FUN-D40083--add--str--
       CALL cl_set_comp_entry("apf03,apf12",TRUE)
       IF g_aptype = '33' THEN
          SELECT COUNT(*) INTO l_n FROM apg_file
           WHERE apg01 = g_apf.apf01
          IF l_n > 0 THEN
             CALL cl_set_comp_entry("apf03,apf12",FALSE)
          END IF
       END IF
       #FUN-D40083--add--end--
    END IF
 
#FUN-A40037 ------------------------------add start-------------------------
    LET l_flag = 'N'                                                             
   IF g_aptype = '33' THEN                                                      
      SELECT pmc14 INTO l_pmc14                                                 
        FROM pmc_file                                                           
       WHERE pmc01 = g_apf.apf03                                                
      IF l_pmc14 = '3' THEN                                                     
         LET l_flag = 'Y'                                                       
      END IF                                                                    
   END IF
#FUN-A40037 ----------------------------add end--------------------------------
    IF INFIELD(apf03) THEN
     # IF g_apf.apf03 != 'MISC' AND g_apf.apf03 != 'EMPL' THEN                    #FUN-A40037 mark
       IF g_apf.apf03 != 'MISC' AND g_apf.apf03 != 'EMPL' AND l_flag = 'N' THEN   #FUN-A40037 add
          CALL cl_set_comp_entry("apf12",FALSE)
       END IF
       IF g_apf.apf03 != 'MISC' THEN
          CALL cl_set_comp_entry("apf13",FALSE)
       END IF
    END IF
   
    #No.MOD-D80050  --Begin
    IF g_aptype = '36' THEN
       IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
          CALL cl_set_comp_entry("apf47",FALSE)
       END IF
    END IF 
    #No.MOD-D80050  --End

END FUNCTION
 
FUNCTION t310_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
      CALL cl_set_comp_entry("aph07,aph08,aph13,aph14,aph16",TRUE)   #No.TQC-5B0114
      CALL cl_set_comp_required("aph08",FALSE)   #No.TQC-5B0114
      CALL cl_set_comp_entry("aph17",TRUE)   #MOD-770123 
  #    CALL cl_set_comp_entry("aph09",TRUE)   #FUN-B40011  #TQC-B70152 mark
      CALL cl_set_comp_entry("aph09",TRUE)    #yinhy130923
END FUNCTION
 
FUNCTION t310_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
      IF g_aph[l_ac].aph03 MATCHES '[6789G]' THEN #FUN-CB0065 add G
         CALL cl_set_comp_entry("aph07,aph08,aph13,aph14",FALSE)  #No.TQC-5B0114  
      ELSE
         IF g_aptype <> '32' THEN    #No.FUN-A40003
            CALL cl_set_comp_entry("aph17",FALSE)   #MOD-770123
         END IF                      #No.FUN-A40003
#FUN-B40011 --begin
         IF g_aph[l_ac].aph03 ='D' THEN
            CALL cl_set_comp_entry("aph08,aph17,aph13",FALSE)
          #  CALL cl_set_comp_entry("aph07,aph09,aph14,aph041",FALSE) #TQC-B70152 mark
            CALL cl_set_comp_entry("aph07,aph14,aph041",FALSE)  #TQC-B70152
         END IF
#FUN-B40011 --end
      END IF
      IF g_aph[l_ac].aph03 MATCHES '[12]' THEN    #No.FUN-510011 add
         CALL cl_set_comp_entry("aph13",FALSE)
      END IF
      IF g_aph[l_ac].aph03 <>"2" THEN   #MOD-770123
         CALL cl_set_comp_entry("aph16",FALSE)
         LET g_aph[l_ac].aph16 = ''   #MOD-770123
         LET g_aph[l_ac].nmc02 = ''   #MOD-770123
         DISPLAY BY NAME g_aph[l_ac].aph16,g_aph[l_ac].nmc02   #MOD-770123
      END IF
      IF g_aph[l_ac].aph03 ="2" AND g_aptype <> '32' THEN        #No.FUN-A40003 add g_aptype
         CALL cl_set_comp_required("aph08",TRUE)
      END IF
#No.FUN-A40003 --begin
      IF g_aptype ='32' THEN 
         CALL cl_set_comp_entry("aph07,aph13,aph14",FALSE)
         IF g_aph[l_ac].aph03 ='1' THEN 
            CALL cl_set_comp_entry("aph17",FALSE)
         END IF 
      END IF 
#No.FUN-A40003 --end
#No.FUN-A60024 --begin
     #IF g_aptype ='36' THEN                    #MOD-BB0039 mark 
     #   CALL cl_set_comp_entry("aph03",FALSE)  #MOD-BB0039 mark
     #END IF                                    #MOD-BB0039 mark
#No.FUN-A60024 --end

END FUNCTION
 
FUNCTION t310_set_comb()
  DEFINE l_apw      RECORD LIKE apw_file.*
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(1000)
 
    IF g_aptype='34' THEN                                                                                                           
       LET comb_value = '1,2,3,4,5,8,A,B,C,Z'                                                                        
    ELSE 
       IF g_aptype <> '36' THEN        #MOD-BB0039
          LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,Z'
       END IF                          #MOD-BB0039
    END IF  
    IF g_aptype='34' THEN                                                                                                           
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='aap-337' AND ze02=g_lang                                                                                       
    ELSE 
       IF g_aptype <> '36' THEN        #MOD-BB0039
          SELECT ze03 INTO comb_item FROM ze_file
            WHERE ze01='aap-335' AND ze02=g_lang
       END IF                          #MOD-BB0039
    END IF
   #-MOD-B70011-mark-
   #-MOD-BB0039-add-
   #-CHI-CA0044-mark-
   #IF g_aptype = '36' OR g_aptype = '34' THEN   #MOD-BB0276 add '34'
   #   DECLARE apw_36_cs CURSOR FOR
   #    SELECT * FROM apw_file
   #   FOREACH apw_36_cs INTO l_apw.*
   #       LET comb_value = comb_value CLIPPED,',',l_apw.apw01
   #       LET comb_item  = comb_item  CLIPPED,',',l_apw.apw01 CLIPPED,'.',
   #                                               l_apw.apw02
   #   END FOREACH
   #END IF
   #-CHI-CA0044-end-
   #-MOD-BB0039-end-
   #-MOD-B70011-end-
#No.FUN-A40003 --begin
    IF g_aptype='32' THEN                                                                                                           
       LET comb_value = '1,2,E'                        #FUN-C90044--add--E                                                                                       
       SELECT ze03 INTO comb_item FROM ze_file
        WHERE ze01='aap-808' AND ze02=g_lang
    END IF
#No.FUN-A40003 --end  
#No.FUN-B40011 --begin
    IF g_aptype='33' THEN                                                                                                           
       LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,Z' #FUN-C90044 add--E #FUN-C90122 add 'F' #FUN-CB0065 add'G' #FUN-CB0117 add-H                                                                                    
       SELECT ze03 INTO comb_item FROM ze_file
        WHERE ze01='aap-355' AND ze02=g_lang
    END IF   #CHI-CA0044 reamrk   #TQC-B70160 mark
#No.FUN-B40011 --end  
   #-MOD-B70011-add-
       DECLARE apw_cs CURSOR FOR
         SELECT * FROM apw_file
          ORDER BY apw01
       FOREACH apw_cs INTO l_apw.*
          LET comb_value = comb_value CLIPPED,',',l_apw.apw01
          LET comb_item  = comb_item  CLIPPED,',',l_apw.apw01 CLIPPED,'.',
                                                  l_apw.apw02
       END FOREACH
   #-MOD-B70011-end-
   #END IF   #CHI-CA0044 mark   #TQC-B70160 add
    CALL cl_set_combo_items('aph03',comb_value,comb_item)
#No.FUN-A40003 --begin 
    IF g_aptype = '32' THEN 
       CALL cl_set_comp_visible("aph08,aph041,aph16,aph09,aph18,aph19,aph20,nmc02",FALSE)
    END IF 
#No.FUN-A40003 --end 
#No.FUN-A60024 --begin
    IF g_aptype = '36' THEN 
       CALL cl_set_comp_visible("apf14,apf09,apf09f,aph07,aph08,aph09,aph041,aph16,aph17,aph18,aph19,aph20,nmc02",FALSE)
    END IF 
#No.FUN-A60024 --end
END FUNCTION

#FUN-C90044--ADD---STR
FUNCTION t310_ins_apa_1(l_aph)
DEFINE  l_aph RECORD LIKE aph_file.*
DEFINE  l_apa RECORD LIKE apa_file.*
DEFINE  li_result    LIKE type_file.chr1
DEFINE  l_depno      LIKE apf_file.apf05
DEFINE  i            LIKE type_file.num5
 
   IF g_success ='N' THEN RETURN END IF
   IF g_aptype <>'33' AND g_aptype <>'32' THEN RETURN END IF
  
   CALL s_auto_assign_no("aap",g_apz.apz64,g_apf.apf02,"12","apa_file","apa01","","","")
   RETURNING li_result,l_apa.apa01
   IF li_result THEN
   ELSE
      LET g_success = 'N'
      RETURN
   END IF
   
   LET l_apa.apa00  = '12'
   LET l_apa.apa02  = m_apf.apf02
   LET l_apa.apa05  = m_apf.apf03
   LET l_apa.apa06  = m_apf.apf03
   LET l_apa.apa07  = m_apf.apf12
   SELECT pmc17,pmc47 INTO l_apa.apa11,l_apa.apa15 FROM pmc_file WHERE pmc01 = m_apf.apf03  #FUN-C90044 luttb add APA15
   IF cl_null(l_apa.apa11) THEN
      CALL s_errmsg('','','','aap-720',1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_apa.apa13  = m_apf.apf06
   LET l_apa.apa14  = m_apf.apf07
   LET l_apa.apa22  = m_apf.apf05  #luttb add
   LET l_apa.apa79  = '3'

   LET l_apa.apa54 =l_aph.aph04    #luttb add
   LET l_apa.apa541 = l_aph.aph041 #luttb add
{luttb mark
   IF g_aptype ='32' THEN
      LET l_apa.apa51  = NULL
      LET l_apa.apa511 = NULL
      IF g_apz.apz13 = 'Y' THEN
         SELECT aps61,aps611 INTO l_apa.apa54,l_apa.apa541
           FROM aps_file
          WHERE aps01 = m_apf.apf05
       ELSE
          SELECT aps61,aps611 INTO l_apa.apa54,l_apa.apa541
            FROM aps_file
           WHERE (aps01 = ' ' OR aps01 IS NULL)
       END IF
    ELSE
        IF g_apz.apz68 ='Y' THEN
           LET l_apa.apa51  = l_aph.aph04
           LET l_apa.apa511 = l_aph.aph041
           LET l_apa.apa54  = NULL
           LET l_apa.apa541 = NULL
           FOR i =1 TO g_apg.getlength()
              IF cl_null(l_apa.apa54) THEN
                 SELECT apa54,apa541 INTO l_apa.apa54,l_apa.apa541 FROM apa_file WHERE apa01 = g_apg[i].apg04
                 IF cl_null(l_apa.apa54) THEN
                    LET l_apa.apa54 = NULL
                 END IF
              END IF
              LET i = i + 1
           END FOR
         ELSE
            LET l_apa.apa54  = l_aph.aph04
            LET l_apa.apa541 = l_aph.aph041
            IF g_apz.apz13 = 'Y' THEN
               LET l_depno = m_apf.apf05
            ELSE
               LET l_depno = ' '
            END IF
            SELECT apt03,apt031 INTO l_apa.apa51,l_apa.apa511
              FROM apt_file WHERE apt01 = l_aph.aph22 AND apt02 = l_depno
         END IF
     END IF
}
         #FUN-C90044 luttb--add--str--
         IF l_aph.aph05f<0 THEN LET l_aph.aph05f  =l_aph.aph05f* -1 END IF
         IF l_aph.aph05<0 THEN LET l_aph.aph05=l_aph.aph05 * -1 END IF
         #FUN-C90044 luttb--add--end
         LET l_apa.apa31f = l_aph.aph05f
         LET l_apa.apa31  = l_aph.aph05
         LET l_apa.apa34f = l_aph.aph05f
         LET l_apa.apa34  = l_aph.aph05
         LET l_apa.apa57  = l_aph.aph05
         LET l_apa.apa57f = l_aph.aph05f
         LET l_apa.apa36  = l_aph.aph22

         LET l_apa.apa08  = m_apf.apf01
         LET l_apa.apa20  = 0
         LET l_apa.apa21  = m_apf.apf04
         LET l_apa.apa22  = m_apf.apf05
         LET l_apa.apa16  = 0
         LET l_apa.apa52  = NULL
         LET l_apa.apa521 = NULL
         LET l_apa.apa171 = NULL
         LET l_apa.apa172 = NULL
         LET l_apa.apa73  = l_apa.apa34

         LET l_apa.apa09  = l_apa.apa02
         CALL s_paydate('a','',l_apa.apa09,l_apa.apa02,l_apa.apa11,l_apa.apa06)
              RETURNING l_apa.apa12,l_apa.apa64,l_apa.apa24
         LET l_apa.apa32f = 0
         LET l_apa.apa32  = 0
         LET l_apa.apa33f = 0
         LET l_apa.apa33  = 0

         LET l_apa.apa35f = 0
         LET l_apa.apa35  = 0
         LET l_apa.apa60f = 0
         LET l_apa.apa60  = 0
         LET l_apa.apa61f = 0
         LET l_apa.apa61  = 0
         LET l_apa.apa65f = 0
         LET l_apa.apa65  = 0
         LET l_apa.apa63  = 1
         LET l_apa.apa41  = 'Y'
         LET l_apa.apa42  = 'N'
         LET l_apa.apamksg= 'N'
         LET l_apa.apa55  = 1
         LET l_apa.apa72  = l_apa.apa14
         LET l_apa.apa56  = 0
         LET l_apa.apa100 = g_plant
         LET l_apa.apauser= g_user
         LET l_apa.apagrup= g_grup
         LET l_apa.apaacti= 'Y'
         LET l_apa.apadate= g_today
         LET l_apa.apainpd= m_apf.apf02
         LET l_apa.apaud10 =''
         LET l_apa.apaud11 =''
         LET l_apa.apaud12 =''
         LET l_apa.apaud13 =''
         LET l_apa.apaud14 =''
         LET l_apa.apaud15 =''
         LET l_apa.apaoriu= g_user
         LET l_apa.apaorig= g_grup
         LET l_apa.apalegal=g_legal
         LET l_apa.apa930=s_costcenter(l_apa.apa22)
   INSERT INTO apa_file VALUES(l_apa.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_success ='Y'
      CALL t310_ins_apc(l_apa.*)
      IF g_success ='N' THEN RETURN END IF
      UPDATE aph_file SET aph23=l_apa.apa01
       WHERE aph01 = l_aph.aph01 AND aph02 = l_aph.aph02
         AND aph03 IN ('E','H')    #FUN-CB0117--add--H
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","aph_file",l_apa.apa01,"",SQLCA.sqlcode,"","upd aph",1)
          LET g_success = 'N'
       ELSE
          LET g_aph[l_aph.aph02].aph23 = l_apa.apa01
       END IF
      CALL t310_b2_fill(" 1=1")
   END IF
END FUNCTION


FUNCTION t310_del_apa_1(l_aph)
DEFINE l_apa01  LIKE apa_file.apa01
DEFINE l_aph02  LIKE aph_file.aph02
DEFINE l_aph    RECORD LIKE aph_file.*

    IF g_apf.apf41<>'Y' THEN RETURN END IF

    SELECT aph23 INTO l_apa01 FROM aph_file
     WHERE aph01= l_aph.aph01 AND aph02=l_aph.aph02
       AND aph03 IN ('E','H')      #FUN-CB0117--add--H
       IF cl_null(l_apa01) THEN
          RETURN
       END IF
       DELETE FROM apa_file WHERE apa01=l_apa01 AND apa00 = '12'
       IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("del","apa_file",l_apa01,"",SQLCA.sqlcode,"","",1)
            LET g_success ='N'
       ELSE
           DELETE FROM apc_file WHERE apc01=l_apa01
           IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("del","apc_file",l_apa01,"",SQLCA.sqlcode,"","",1)
               LET g_success ='N'
           ELSE
              UPDATE aph_file SET aph23=''  
               WHERE aph01 = l_aph.aph01 AND aph02=l_aph.aph02 
                 AND aph03 IN ('E','H')   #FUN-CB0117 add-aph03=H
               IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","aph_file",l_apa01,"",SQLCA.sqlcode,"","",1)
                  LET g_success ='N'
               ELSE
                 LET g_aph[l_aph.aph02].aph23 =''
               END IF
           END IF
       END IF
END FUNCTION
#FUN-C90044--ADD---END
 
FUNCTION t310_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_apg TO s_apg.* ATTRIBUTE(COUNT=g_rec_b)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION t310_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
                                              AND apa02 <= g_apf.apf02          #MOD-A30146 add
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION t310_gen_glcr(p_apf,p_apy)
  DEFINE p_apf     RECORD LIKE apf_file.*
  DEFINE p_apy     RECORD LIKE apy_file.*
  
    IF cl_null(p_apy.apygslp) THEN
      #CALL cl_err(p_apf.apf01,'axr-070',1) #CHI-A60034 mark
       CALL s_errmsg('apf01',p_apf.apf01,'','axr-070',1) #CHI-A60034
       LET g_success = 'N'
       RETURN
    END IF       
       CALL t310_g_gl(p_apf.apf00,p_apf.apf01,'0')
    IF g_aza.aza63 = 'Y' THEN
         CALL t310_g_gl(p_apf.apf00,p_apf.apf01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t310_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
  
    IF NOT cl_null(g_apf.apf44) OR g_apf.apf44 IS NOT NULL THEN
       CALL cl_err(g_apf.apf44,'aap-618',1)
       RETURN
    END IF   
    
    IF g_apf.apf42 matches '[Ss]' THEN 
        RETURN 
    END IF
    
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_apf.apf01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF
     IF g_apy.apyglcr = 'Y' OR (g_apy.apyglcr ='N' AND NOT cl_null(g_apy.apygslp)) THEN #No.FUN-860107
       LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",                            #FUN-A50102 mark
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102 
                   "  WHERE aba00 = '",g_apz.apz02b,"'",
                   "    AND aba01 = '",g_apf.apf44,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql     #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_apf.apf44,'aap-991',1)
          RETURN
       END IF
 
       LET l_apygslp = g_apy.apygslp
    ELSE
      CALL cl_err('','aap-936',1)    #No.FUN-860107
       RETURN
 
    END IF
    IF cl_null(l_apygslp) OR (cl_null(g_apy.apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_apf.apf01,'axr-070',1)
       RETURN
    END IF
   #CALL s_showmsg_init()                                    #MOD-C50093 add #MOD-C50243 mark
   #LET g_wc_gl = 'npp01 = "',g_apf.apf01,'" AND npp011 = 1' #MOD-AC0383 mark
    LET g_wc_gl = " npp01='",g_apf.apf01,"' AND npp011 = 1 " #MOD-AC0383
   #LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_apf.apfuser,"' '",g_apf.apfuser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",l_apygslp,"' '",g_apf.apf02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"'"      #MOD-7B0159  #No.MOD-860075 #MOD-AC0383 mark
   #-MOD-AC0383-add-
    LET g_str = "aapp400" ,
                ' "',g_wc_gl CLIPPED,'"',
                ' "',g_apf.apfuser,'"',  
                ' "',g_apf.apfuser,'"', 
                ' "',g_apz.apz02p,'" ',
                ' "',g_apz.apz02b,'" ',
                ' "',l_apygslp,'" ',
                ' "',g_apf.apf02,'" ',
                ' "Y" ',
                ' "1" ',  
                ' "Y" ',
                ' "',g_apz.apz02c,'" ',
                ' "',g_apy.apygslp1,'" ',
                ' "Y" '                    #MOD-B10041
   #-MOD-AC0383-end-
    CALL cl_cmdrun_wait(g_str)
    SELECT apf44,apf43 INTO g_apf.apf44,g_apf.apf43 FROM apf_file
     WHERE apf01 = g_apf.apf01
   #--------------------------MOD-C50093---------------------------(S)
   #CALL s_errmsg('',g_apf.apf44,'','','')                   #MOD-C90246 mark
    CALL s_errmsg('',g_apf.apf44,'','anm-710','')            #MOD-C90246 add
    CALL s_showmsg()
   #--------------------------MOD-C50093---------------------------(E)
    DISPLAY BY NAME g_apf.apf44
    DISPLAY BY NAME g_apf.apf43
    
END FUNCTION
 
FUNCTION t310_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      STRING #No.FUN-690028 VARCHAR(1000) #MOD-BB0305 mod 1000 -> STRING
  DEFINE l_dbs      STRING
 
    IF cl_null(g_apf.apf44) OR g_apf.apf44 IS NULL THEN
       CALL cl_err(g_apf.apf44,'aap-619',1)
       RETURN
    END IF   
    
    IF g_apf.apf42 matches '[Ss]' THEN 
        RETURN 
    END IF
    
    IF NOT cl_confirm('aap-988') THEN RETURN END IF 
 
    CALL s_get_doc_no(g_apf.apf01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF   #TQC-7B0051
    IF g_apy.apyglcr = 'N' AND cl_null(g_apy.apygslp)THEN #No.FUN-860107
      CALL cl_err('','aap-936',1)    #No.FUN-860107
       RETURN
    END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
  # LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",                           #FUN-A50102 mark
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),#FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_apf.apf44,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql    #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_apf.apf44,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apf.apf44,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT apf44,apf43 INTO g_apf.apf44,g_apf.apf43 FROM apf_file
     WHERE apf01 = g_apf.apf01
    DISPLAY BY NAME g_apf.apf44
    DISPLAY BY NAME g_apf.apf43
END FUNCTION
FUNCTION t310_bookno()                                                                                                              
 
   LET g_errmsg= ''      #No.TQC-940123
   IF g_apz.apz02='Y' THEN          #MOD-BB0212 mod sma03 -> apz02
      LET g_db1 = g_apz.apz02p      #MOD-BB0212 mod sma87 -> apz02p
   ELSE                                                                                                                             
      LET g_db1 = g_plant                                                                                                           
   END IF                                                                                                                           
   SELECT azp03 INTO g_azp03 FROM azp_file                                                                                          
    WHERE azp01=g_db1                                                                                                               
   LET g_db_type=cl_db_get_database_type()                                                                                             
 
   LET g_plantm = g_db1                            #FUN-980020
   LET g_dbsm = s_dbstring(g_azp03 CLIPPED)
   CALL s_get_bookno1(YEAR(g_apf.apf02),g_plantm)  #FUN-980020
        RETURNING g_flag,g_bookno1,g_bookno2                                                                                        
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_getmsg('aoo-081',g_lang) RETURNING g_errmsg
      LET g_errmsg = g_dbsm,g_errmsg
   END IF                                                                                                                           
END FUNCTION   
#No.FUN-9C0072 精簡程式碼 
#No.FUN-A30106 --begin                                                          
FUNCTION t310_drill_down()                                                      
                                                                                
   IF cl_null(g_apf.apf44) THEN RETURN END IF                                   
   LET g_msg = "aglt110 '",g_apf.apf44,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    
#No.FUN-A30106 --end 
#No.FUN-A40003 --begin
FUNCTION t310_aph04()
   DEFINE l_nmg           RECORD LIKE nmg_file.*
   DEFINE l_npk           RECORD LIKE npk_file.*
   DEFINE l_sql           STRING 
   DEFINE l_nmydmy3       LIKE nmy_file.nmydmy3
   DEFINE l_nmh           RECORD LIKE nmh_file.*
   DEFINE tot1,tot2,tot3  LIKE type_file.num20_6   
   DEFINE l_nmz20         LIKE nmz_file.nmz20
   DEFINE l_nmz59         LIKE nmz_file.nmz59
   DEFINE l_date          LIKE apa_file.apa02
   DEFINE l_curr          LIKE apa_file.apa13
   DEFINE l_rate          LIKE apa_file.apa14
   DEFINE l_aph05         LIKE aph_file.aph05
   DEFINE l_aph05f        LIKE aph_file.aph05f
  #DEFINE l_nmh17         LIKE nmh_file.nmh17   #No.TQC-C30121   Mark
   DEFINE l_nmh02         LIKE nmh_file.nmh02   #No.TQC-C30121   Add

   
   LET g_errno =''
   #No.yinhy130826  --Begin
   SELECT SUM(aph05f),SUM(aph05) INTO tot1,tot2 FROM aph_file,apf_file
    WHERE aph04 = g_aph[l_ac].aph04
      AND aph01 = apf01 AND apf41 != 'X'   
      #AND aph01 <> g_apf.apf01                 #yinhy130826 mark
      AND (aph01 <> g_apf.apf01 OR aph02 <> g_aph[l_ac].aph02)     #yinhy13082
      AND aph04 = g_aph[l_ac].aph04
      AND aph17 = g_aph[l_ac].aph17    
   
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF 
   #No.yinhy130826  --End
   IF g_aph[l_ac].aph03 = '2' THEN 
      IF g_ooz.ooz04='N' THEN RETURN END IF
     #----------------MOD-C60117--------------------------(S)
      IF g_aptype = '32' THEN
         SELECT nmg_file.* INTO l_nmg.*  FROM nmg_file
          WHERE nmg00= g_aph[l_ac].aph04
            AND nmg23 > nmg24
           #AND nmg20 = '21'           #MOD-C70163 mark
            AND nmg20 IN ('0','21')    #MOD-C70163
            AND (nmg18 = g_apf.apf03 OR nmg18 = 'MISC')  #MOD-C70163
            AND nmg29 = 'N'
            AND nmgconf <> 'X'
      ELSE
     #----------------MOD-C60117--------------------------(E)
         SELECT nmg_file.* INTO l_nmg.*  FROM nmg_file
                WHERE nmg00= g_aph[l_ac].aph04
                  AND nmg23 > nmg24
                  AND nmgconf <> 'X'
                 #AND (nmg20='21' OR nmg20='22')
                 #AND (nmg29 !='Y')    #NO:4181
      END IF                                      #MOD-C60117
      IF STATUS  THEN                                  
         LET g_errno=STATUS  
         RETURN  '','','','',''
      END IF 
   
      IF l_nmg.nmgconf='N' THEN 
         LET g_errno='axr-194' 
         RETURN  '','','','','' 
      END IF
      IF l_nmg.nmgconf='X' THEN 
         LET g_errno='9024' 
         RETURN  '','','','',''  
      END IF

     #MOD-C70163----S---
      IF g_aptype = '32' THEN
         #IF l_nmg.nmg23-l_nmg.nmg24 = 0 THEN                         #yinhy130826 mark
         IF l_nmg.nmg23-l_nmg.nmg24 = 0 OR l_nmg.nmg23-tot1 = 0 THEN  #yinhy130826
            LET g_errno='axr-184'
            RETURN  '','','','',''
         END IF
      ELSE
     #MOD-C70163----E---   
         #IF l_nmg.nmg05-l_nmg.nmg24 = 0 THEN                         #yinhy130826 mark
         IF l_nmg.nmg05-l_nmg.nmg24 = 0 OR l_nmg.nmg05-tot1 = 0 THEN  #yinhy130826
            LET g_errno='axr-184' 
            RETURN  '','','','',''
         END IF
      END IF   #MOD-C70163 add
      
      #yinhy130826  --Mark Begin
      #SELECT SUM(aph05f),SUM(aph05) INTO tot1,tot2 FROM aph_file,apf_file
      # WHERE aph04 = g_aph[l_ac].aph04
      #   AND aph01 = apf01 AND apf41 != 'X'   
      #   #AND aph01 <> g_apf.apf01                 #yinhy130826 mark
      #   AND (aph01 <> g_apf.apf01 OR aph02 <> g_aph[l_ac].aph02)     #yinhy13082
      #   AND aph04 = g_aph[l_ac].aph04
      #   AND aph17 = g_aph[l_ac].aph17    
      #
      #IF cl_null(tot1) THEN LET tot1 = 0 END IF
      #IF cl_null(tot2) THEN LET tot2 = 0 END IF 
      #yinhy130826  --Mark End    
     
         
      #---->為防止收支單輸入兩筆單身
      LET l_sql = "SELECT npk_file.* FROM npk_file ",
                  " WHERE npk00= '",g_aph[l_ac].aph04,"'",
                  "       AND npk01 ='",g_aph[l_ac].aph17,"'"   
      PREPARE t310_aph04_npk FROM l_sql
      DECLARE t310_aph04_npk_c1 CURSOR FOR t310_aph04_npk
      FOREACH t310_aph04_npk_c1 INTO l_npk.*
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode EXIT FOREACH
        END IF
        IF l_npk.npk05!=g_apf.apf06 THEN    #幣別與沖帳不一致
           LET g_errno='axr-144' EXIT FOREACH
        END IF
        LET l_curr=l_npk.npk05   #幣別
        LET l_rate=l_npk.npk06   #匯率
        LET l_aph05f=l_npk.npk08 - tot1   #原幣入帳金額              
        LET l_aph05=l_npk.npk09 - tot2  #本幣入帳金額                       
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_curr  
        CALL cl_digcut(l_aph05f,t_azi04) RETURNING l_aph05f     
        CALL cl_digcut(l_aph05,g_azi04) RETURNING l_aph05      
      
        SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
        IF l_nmz20 = 'Y' AND l_curr != g_aza.aza17 THEN
           IF g_apz.apz27 = 'Y' THEN                  
              LET l_rate = l_nmg.nmg09
           ELSE                                       
              LET l_rate = l_npk.npk06     
           END IF                                     
           IF cl_null(l_rate) OR l_rate = 0 THEN
              LET l_rate = l_npk.npk06
           END IF
           CALL s_g_np('3','2',g_aph[l_ac].aph04,g_aph[l_ac].aph17) RETURNING tot3
           IF (tot1+l_aph05f) = l_nmg.nmg23 THEN    
               LET l_aph05 = tot3 - tot2
           END IF
        END IF   
        LET l_date = l_nmg.nmg01
        EXIT FOREACH
     END FOREACH
   END IF 


   IF g_aph[l_ac].aph03 = '1' THEN
      IF g_ooz.ooz04='N' THEN RETURN  '','','','','' END IF
      LET l_sql="SELECT nmh_file.*,nmydmy3 FROM nmh_file,nmy_file ",
                " WHERE nmh01= '",g_aph[l_ac].aph04,"'",
                "   AND nmh01[1,",g_doc_len,"]=nmyslip"
      PREPARE t310_ins_aph08_2_p FROM l_sql
      DECLARE t310_ins_aph08_2 CURSOR FOR t310_ins_aph08_2_p
      OPEN t310_ins_aph08_2
      FETCH t310_ins_aph08_2 INTO l_nmh.*,l_nmydmy3
      IF STATUS THEN LET g_errno=STATUS RETURN '','','','',''  END IF      
      
      IF l_nmh.nmh24='6' OR l_nmh.nmh24='7' THEN
         LET g_errno = 'axr-115'
         CLOSE t310_ins_aph08_2
      END IF

      IF l_nmh.nmh38 = 'N' THEN
         LET g_errno='axr-194' 
      END IF
      IF l_nmh.nmh38 = 'X' THEN
         LET g_errno = '9024' 
      END IF  
     
     #yinhy130826  --Mark Begin
     ##須考慮未確認沖帳資料
     #SELECT SUM(aph05f),SUM(aph05) INTO tot1,tot2 FROM aph_file,apf_file
     # WHERE aph04 = g_aph[l_ac].aph04
     #   AND aph01 = apf01 AND apf41 = 'N'
     #   #AND (aph01 <> g_apf.apf01 OR aph02 <> g_aph_t.aph02)      #yinhy130826 mark
     #   AND (aph01 <> g_apf.apf01 OR aph02 <> g_aph[l_ac].aph02)   #yinhy130826
     #   AND aph07 = g_aph[l_ac].aph03
     #
     #IF cl_null(tot1) THEN LET tot1 = 0 END IF
     #IF cl_null(tot2) THEN LET tot2 = 0 END IF
     #yinhy130826  --Mark End

      IF l_nmh.nmh03!=g_apf.apf06 THEN
         LET g_errno='axr-144' END IF
      #IF l_nmh.nmh17>=l_nmh.nmh02 THEN                        #yinhy130826 mark
      IF l_nmh.nmh17>=l_nmh.nmh02 OR (tot2>=l_nmh.nmh02) THEN  #yinhy130826
         LET g_errno='axr-185'
      END IF
      IF l_nmh.nmh38 != 'Y' THEN LET g_errno='axr-194' END IF
      LET l_curr=l_nmh.nmh03
      LET l_rate=l_nmh.nmh32/l_nmh.nmh02
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_curr  
      LET l_aph05f=l_nmh.nmh02-l_nmh.nmh17-tot1
      LET l_aph05=l_aph05f*l_rate
      
      SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
      IF l_nmz59 = 'Y' AND l_curr != g_aza.aza17 THEN
         IF g_apz.apz27 = 'Y' THEN                       
            LET l_rate = l_nmh.nmh39
         ELSE                                             
            LET l_rate = l_nmh.nmh28           
         END IF                                              
         IF cl_null(l_rate) OR l_rate = 0 THEN
            LET l_rate = l_nmh.nmh28
         END IF
         CALL s_g_np('4','1',g_aph[l_ac].aph04,g_aph[l_ac].aph17) RETURNING tot3
         IF (l_aph05f+tot1+l_nmh.nmh17) = l_nmh.nmh02 THEN
            LET l_aph05 = tot3 - tot2
         END IF
      END IF
      
      CALL cl_digcut(l_aph05f,t_azi04) RETURNING l_aph05f
      CALL cl_digcut(l_aph05,g_azi04) RETURNING l_aph05
      LET l_date = l_nmh.nmh04
      CLOSE t310_ins_aph08_2
   END IF 
#--begin-- FUN-B40011
   IF g_aph[l_ac].aph03 = 'D' THEN
      LET l_sql="SELECT nmh_file.*,nmydmy3 FROM nmh_file,nmy_file ",
                " WHERE nmh01= '",g_aph[l_ac].aph04,"'",
                "   AND SUBSTR(nmh01,1,",g_doc_len,")=nmyslip"
      PREPARE nmh_p2 FROM l_sql
      DECLARE nmh_c2 CURSOR FOR nmh_p2
      OPEN nmh_c2
      FETCH nmh_c2 INTO l_nmh.*,l_nmydmy3
      IF STATUS THEN CALL cl_err('sel nmh',STATUS,1) LET g_errno=STATUS RETURN '','','','','' END IF
      
      IF l_nmh.nmh24 !='5' THEN
         LET g_errno = 'axr-115'
         CLOSE nmh_c2
      END IF

      IF l_nmh.nmh38 = 'N' THEN
         LET g_errno='axr-194' 
      END IF
      IF l_nmh.nmh38 = 'X' THEN
         LET g_errno = '9024' 
      END IF
      
      #---> TQC-C30293 add
      IF l_nmh.nmh22!=g_apf.apf03 THEN
         LET g_errno='aap-040'
      END IF
      #---> TQC-C30293 add--end
      #TQC-C50108--add--str
      IF l_nmh.nmh05 < g_apf.apf02 THEN
         LET g_errno = 'aap-209'
      END IF
      #TQC-C50108--add--end

      LET tot1 = 0
      
      SELECT SUM(aph05f) INTO tot1
        FROM aph_file,apf_file
       WHERE aph03 = 'D'
         AND aph04 = g_aph[l_ac].aph04
         AND aph01 = apf01 AND apf41 != 'X'   #MOD-9C0147 add
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
     #SELECT nmh17 INTO l_nmh17    #No.TQC-C30121   Mark
      SELECT nmh02 INTO l_nmh02    #No.TQC-C30121   Add
        FROM nmh_file
       WHERE nmh01 = g_aph[l_ac].aph04
         AND nmh24='5'
         AND nmh38='Y'
      IF cl_null(l_nmh02) THEN LET l_nmh02 = 0 END IF    #No.TQC-C30121   Add
     #IF cl_null(l_nmh17) THEN LET l_nmh17 = 0 END IF    #No.TQC-C30121   Mark
                       
      LET l_curr=l_nmh.nmh03
      LET l_rate=l_nmh.nmh32/l_nmh.nmh02
     #LET l_aph05f=l_nmh17 - tot1   #No.TQC-C30121   Mark
      LET l_aph05f=l_nmh02 - tot1   #No.TQC-C30121   Add
      LET l_aph05=l_aph05f*l_rate
      LET l_date = l_nmh.nmh05 #TQC-C40096 nmh04收票日期---->nmh05到期日期
   END IF
#--end-- FUN-B40011
   RETURN l_date,l_curr,l_rate,l_aph05f,l_aph05

END FUNCTION 

FUNCTION t310_bu_11(p_sw)                   #更新應收票據檔 (nmh_file)
  DEFINE p_sw             LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(1),            # +:更新 -:還原
         l_nmh17          LIKE  nmh_file.nmh17,
         l_nmh38          LIKE  nmh_file.nmh38
  DEFINE l_nmz59          LIKE nmz_file.nmz59
  DEFINE l_amt1,l_amt2    LIKE nmg_file.nmg25    #No.MOD-910126
  DEFINE tot3             LIKE type_file.num20_6
   
  #95/12/14 by danny 確認時,判斷此參考單號之單據是否已確認
  SELECT nmh17,nmh38 INTO l_nmh17,l_nmh38 FROM nmh_file WHERE nmh01=m_aph.aph04
  IF STATUS THEN LET l_nmh38 = 'N' END IF
  IF l_nmh38 != 'Y' THEN
     CALL s_errmsg('nmh01',m_aph.aph04,' ','axr-194',1)   
  END IF
  SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
  IF l_nmz59 ='Y' AND m_aph.aph13 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('4','1',m_aph.aph04,m_aph.aph17) RETURNING tot3
  ELSE
    SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = m_aph.aph04
    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
    CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1
    SELECT SUM(aph05) INTO l_amt2 FROM aph_file,apf_file 
     WHERE aph01 = apf01 AND apf41 = 'Y' AND aph03 = '1' 
       AND aph04 = m_aph.aph04
    IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
    LET tot3 = l_amt1 - l_amt2
    IF cl_null(tot3) THEN LET tot3 = 0 END IF
  END IF
 
  #@@@
  IF p_sw = '-' THEN
     UPDATE nmh_file SET nmh17=nmh17-m_aph.aph05f ,nmh40 = tot3
      WHERE nmh01= m_aph.aph04
     IF STATUS THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh17',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh17','axr-198',1) LET g_success = 'N' RETURN      #NO.FUN-710050
     END IF
  END IF
  IF p_sw = '+' THEN
     UPDATE nmh_file SET nmh17=nmh17+m_aph.aph05f ,nmh40 = tot3
      WHERE nmh01= m_aph.aph04
     IF STATUS THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'unp nmh17',STATUS,1)                          #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',m_aph.aph04,'upd nmh17','axr-198',1)  LET g_success = 'N' RETURN    #NO.FUN-710050
     END IF
  END IF
END FUNCTION
 
FUNCTION t310_bu_12(p_sw)             #更新TT檔 (nmg_file)
  DEFINE p_sw           LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)                  # +:更新 -:還原
  DEFINE l_nmg23        LIKE nmg_file.nmg23
  DEFINE l_nmg24        LIKE nmg_file.nmg24,
         l_nmg25        LIKE nmg_file.nmg25,        #bug NO:A053 by plum
         l_nmgconf      LIKE nmg_file.nmgconf,
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE tot1,tot3,tot2 LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #FUN-4C0013 #bug NO:A053 by plum
  DEFINE l_nmz20        LIKE nmz_file.nmz20
  DEFINE l_str          STRING                      #FUN-640246
 
  LET l_str = "bu_12:",m_aph.aph02,' ','2',' ',m_aph.aph03
  CALL cl_msg(l_str) 
 
##No.2724 modify 1998/11/05 確認時,判斷此參考單號之單據是否已確認
  LET l_nmgconf = ' '
  SELECT nmg25,nmgconf 
    INTO l_nmg25,l_nmgconf
    FROM nmg_file 
   WHERE nmg00= m_aph.aph04
    #AND nmg20 = '21'             #MOD-C60117 add  #MOD-C70163 mark
     AND nmg20 IN ('0','21')                       #MOD-C70163
     AND (nmg18 = g_apf.apf03 OR nmg18 = 'MISC')   #MOD-C70163
     AND nmg29 = 'N'              #MOD-C60117 add
  IF STATUS THEN LET l_nmgconf= 'N' END IF
  IF l_nmgconf != 'Y' THEN
     CALL s_errmsg('nmg00',m_aph.aph04,'','axr-194',1)  LET g_success = 'N' RETURN    #NO.FUN-710050
  END IF
  IF cl_null(l_nmg25) THEN LET l_nmg25=0 END IF   #bug NO:A053 by plum
##--------------------------------------------------
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM aph_file
          WHERE aph01=m_aph.aph01
            AND aph02<m_aph.aph02
            AND aph03='3'
            AND aph04=m_aph.aph04
  IF l_cnt>0 THEN RETURN END IF
  
  #No.MOD-D60008  --Begin
  IF g_aptype ='32' THEN
  	LET l_cnt = 0  
    SELECT COUNT(*) INTO l_cnt FROM aph_file
          WHERE aph01=m_aph.aph01
            AND aph02<m_aph.aph02
            AND aph03 IN ('1','2')
            AND aph04=m_aph.aph04
    IF l_cnt>0 THEN RETURN END IF
  END IF
  #No.MOD-D60008  --End
 
  LET tot1 = 0 LET tot2 = 0  #bug NO:A053 by plum
  SELECT SUM(aph05f),SUM(aph05) INTO tot1,tot2 FROM aph_file,apf_file
          WHERE aph04=m_aph.aph04 AND apf01=aph01 AND apf41 ='Y'
            AND aph03 ='2' 
  IF cl_null(tot1) THEN LET tot1 = 0 END IF
  IF cl_null(tot2) THEN LET tot2 = 0 END IF    #bug no:A053 by plum
  SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
  IF l_nmz20 ='Y' AND m_aph.aph13 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('3','',m_aph.aph04,m_aph.aph17) RETURNING tot3
  ELSE
     LET tot3 = 0
  END IF
 
  IF p_sw = '-' THEN
     UPDATE nmg_file SET nmg24 = tot1, nmg10 = tot3
      WHERE nmg00 = m_aph.aph04
       #AND nmg20 = '21'             #MOD-C60117 add  #MOD-C70163 mark
        AND nmg20 IN ('0','21')                       #MOD-C70163
        AND (nmg18 = g_apf.apf03 OR nmg18 = 'MISC')   #MOD-C70163
        AND nmg29 = 'N'              #MOD-C60117 add
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'upd nmg24',SQLCA.SQLCODE,0)              #NO.FUN-710050
       RETURN
    END IF
    RETURN
  END IF
  LET l_nmg24 =0
  SELECT nmg23,nmg23-nmg24 
    INTO l_nmg23,l_nmg24
    FROM nmg_file 
   WHERE nmg00 = m_aph.aph04
    #AND nmg20 = '21'             #MOD-C60117 add  #MOD-C70163 mark
     AND nmg20 IN ('0','21')                       #MOD-C70163
     AND (nmg18 = g_apf.apf03 OR nmg18 = 'MISC')   #MOD-C70163
     AND nmg29 = 'N'              #MOD-C60117 add
    IF STATUS THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'sel nmg24',STATUS,1)              #NO.FUN-710050
       LET g_success = 'N' 
       RETURN
    END IF
    IF l_nmg24 = 0  THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'nmg24=0','axr-185',1) LET g_success='N' RETURN             #NO.FUN-710050
    END IF
# check 是否沖過頭了 ------------
    IF tot1>l_nmg23  THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'','axr-258',1) LET g_success='N' RETURN                    #NO.FUN-710050
    END IF
    UPDATE nmg_file SET nmg24=tot1, nmg10 = tot3
     WHERE nmg00 = m_aph.aph04
      #AND nmg20 = '21'             #MOD-C60117 add  #MOD-C70163 mark
       AND nmg20 IN ('0','21')                       #MOD-C70163
       AND (nmg18 = g_apf.apf03 OR nmg18 = 'MISC')   #MOD-C70163
       AND nmg29 = 'N'              #MOD-C60117 add
    IF STATUS THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'upd nmg24',STATUS,1)               #NO.FUN-710050
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('nmg00',m_aph.aph04,'upd nmg24','axr-198',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
END FUNCTION
#No.FUN-A40003 --end

#No.FUN-A60024 --begin
FUNCTION t310_g_b2()                #create aph_file
DEFINE l_apg05f      LIKE apg_file.apg05f
DEFINE l_apg05       LIKE apg_file.apg05
DEFINE l_apa13       LIKE apa_file.apa13
DEFINE l_apa14       LIKE apa_file.apa14
DEFINE i             LIKE type_file.num5
DEFINE l_aph         RECORD LIKE aph_file.* 
DEFINE l_n           LIKE type_file.num5
#No.FUN-A90007 --begin
DEFINE l_apa36       LIKE apa_file.apa36
DEFINE l_apa54       LIKE apa_file.apa54
DEFINE l_apa541      LIKE apa_file.apa541
DEFINE  l_depno      LIKE apf_file.apf05
#No.FUN-A90007 --end

    IF g_aptype <>'36' THEN RETURN END IF 
    SELECT COUNT(*) INTO l_n FROM aph_file WHERE aph01 = g_apf.apf01
    IF l_n >0 THEN 
       IF cl_confirm('aap-669') THEN 
          DELETE FROM aph_file WHERE aph01 = g_apf.apf01
       ELSE 
          RETURN 
       END IF 
    END IF 
    BEGIN WORK 
    LET g_success ='Y'
    DROP TABLE t310_tmp
    CREATE TEMP TABLE t310_tmp(
       apa13          LIKE apa_file.apa13,
       apa14          LIKE apa_file.apa14,
       apg05f         LIKE apg_file.apg05f,
       apg05          LIKE apg_file.apg05)
    IF STATUS THEN 
       CALL cl_err('create tmp',STATUS,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211 
       EXIT PROGRAM 
    END IF   
#No.FUN-A90007 --begin
    LET l_apa36 = NULL 
    LET l_apa54 = NULL 
#No.FUN-A90007 --end 
    FOR i =1 TO g_apg.getlength()
       IF cl_null(g_apg[i].apg05f) THEN LET g_apg[i].apg05f = 0 END IF 
       IF cl_null(g_apg[i].apg05) THEN LET g_apg[i].apg05 = 0 END IF 
#No.FUN-A90007 --begin
       IF cl_null(l_apa36) AND cl_null(l_apa54) THEN 
          SELECT apa36,apa54,apa541 INTO l_apa36,l_apa54,l_apa541 FROM apa_file WHERE apa01 = g_apg[i].apg04
          IF cl_null(l_apa36) OR cl_null(l_apa54) THEN 
             LET l_apa36 = NULL 
             LET l_apa54 = NULL 
          END IF 
       END IF  
#No.FUN-A90007 --end       
       INSERT INTO t310_tmp VALUES (g_apg[i].apa13,g_apg[i].apa14,g_apg[i].apg05f,g_apg[i].apg05)   #No.FUN-A90007
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   
          CALL cl_err("ins t310_tmp",SQLCA.sqlcode,1) 
          LET g_success ='N'
          EXIT FOR
       END IF  
       LET i = i + 1     
    END FOR
    IF g_success ='N' THEN ROLLBACK WORK RETURN END IF     
    DECLARE t310_tmp_cl CURSOR FOR  
       SELECT apa13,apa14,SUM(apg05f),SUM(apg05) FROM t310_tmp GROUP BY apa13,apa14
       
    LET i =1
    FOREACH t310_tmp_cl INTO l_apa13,l_apa14,l_apg05f,l_apg05
       IF STATUS THEN CALL cl_err('for apg',STATUS,1) EXIT FOREACH END IF
       INITIALIZE l_aph.* TO NULL
       LET l_aph.aph01  = g_apf.apf01
       LET l_aph.aph02  = i
       LET l_aph.aph03  = g_apz.apz65
#No.FUN-A90007 --begin
#       LET l_aph.aph04  = g_apz.apz64
       IF g_apz.apz68 ='Y' THEN  
          SELECT apw03,apw031 INTO l_aph.aph04,l_aph.aph041
            FROM apw_file WHERE apw01 = g_apz.apz65
          IF cl_null(l_aph.aph04) THEN 
             LET l_aph.aph04  = l_apa54
             LET l_aph.aph041 = l_apa541
          END IF 
       ELSE 
       	  LET l_aph.aph04  = l_apa54
          LET l_aph.aph041 = l_apa541
          IF cl_null(l_aph.aph04) THEN 
             SELECT apw03,apw031 INTO l_aph.aph04,l_aph.aph041
               FROM apw_file WHERE apw01 = g_apz.apz65
          END IF 
       END IF
       LET l_aph.aph22  = l_apa36
       IF cl_null(l_aph.aph22) THEN 
          LET l_aph.aph22  = g_apz.apz66
       END IF 
#No.FUN-C90027--BEGIN
       IF g_aptype ='36' AND g_apf.apf47 = '2' THEN
          LET l_aph.aph23  = g_apz.apz70
       ELSE
          LET l_aph.aph23  = g_apz.apz64 
       END IF 
#No.FUN-C90027--END
      #LET l_aph.aph23  = g_apz.apz64#FUN-C90027 mark
       #LET l_aph.aph24  = g_today     #MOD-CC0054
       LET l_aph.aph24  = g_apf.apf02  #MOD-CC0054
#No.FUN-A90007 --end
       LET l_aph.aphlegal   = g_legal
       LET l_aph.aph13  = l_apa13
       LET l_aph.aph14  = l_apa14
       LET l_aph.aph05f = l_apg05f
       LET l_aph.aph05  = l_apg05
       INSERT INTO aph_file VALUES (l_aph.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","aph_file",g_apf.apf01,i,SQLCA.sqlcode,"","",1)  
          LET g_success ='N'
          EXIT FOREACH 
       ELSE
          LET i = i+1
       END IF 
    END FOREACH  
    IF g_success ='Y' THEN 
       COMMIT WORK 
       CALL t310_b2_fill(" 1=1")
    ELSE 
       ROLLBACK WORK 
    END IF 
    CALL t310_b2_tot()
    CALL t310_v('2')
END FUNCTION


FUNCTION t310_ins_apa()
DEFINE  l_aph RECORD LIKE aph_file.*
DEFINE  l_apa RECORD LIKE apa_file.*
DEFINE  li_result    LIKE type_file.num5
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  l_depno      LIKE apf_file.apf05
DEFINE  i            LIKE type_file.num5   #No.FUN-A90007


   IF g_success ='N' THEN RETURN END IF
   IF g_aptype <>'36' AND g_aptype <>'32' THEN RETURN END IF  #No.FUN-A80111 add 32
#   SELECT * INTO m_apf.* FROM apf_file WHERE apf01 = g_apf.apf01   #No.TQC-B20112   No.TQC-B80079 mark
#No.FUN-A80111 --begin
   CALL t310_chk_apa35(m_apf.apf01)
   IF g_success = 'N' THEN RETURN END IF  
#No.FUN-A80111 --end
#No.TQC-B20112 --begin
   CALL t310_del_apa() 
   IF g_success ='N' THEN RETURN END IF                                                                                             
#No.TQC-B20112 --end
   DECLARE t310_sel_aph CURSOR  FOR 
      SELECT * FROM aph_file WHERE aph01 = m_apf.apf01 
                                   AND aph03<>'4' AND aph03<>'5' # add by lixiaa20160902
   
   FOREACH t310_sel_aph INTO l_aph.*
      IF STATUS THEN CALL cl_err('sel aph',STATUS,1) EXIT FOREACH END IF  
#No.FUN-A80111 --begin
         IF g_aptype ='32' THEN 
    #TQC-B70147 --begin mark
    #        SELECT apz67 INTO l_aph.aph04 FROM apz_file 
    #        LET g_apf.apf02 =g_today  
    #TQC-B70147 --end mark    
#No.FUN-A80111 --end     
            SELECT apz67 INTO l_apa.apa01 FROM apz_file   #No.TQC-B80079-110809
            LET l_apa.apa00  = '12'
#            CALL s_auto_assign_no("aap",l_aph.aph04,g_apf.apf02,"12","apa_file","apa01","","","")
            CALL s_auto_assign_no("aap",l_apa.apa01,g_apf.apf02,"12","apa_file","apa01","","","")   #No.TQC-B80079-110809
                 RETURNING li_result,l_apa.apa01   #wujie aph04 -->apa01
            IF  li_result THEN
#                LET l_apa.apa01  = l_aph.aph04   #No.TQC-B80079-110809 
#No.FUN-A80111 --begin    
     #TQC-B70147 --begin mark         
     #           UPDATE aph_file SET aph04 = l_aph.aph04
     #            WHERE aph01 = g_apf.apf01
     #              AND aph02 = l_aph.aph02
     #TQC-B70147 --end mark
#No.FUN-A80111 --end
                #No.MOD-D80144  --Begin
                UPDATE aph_file SET aph23 = l_apa.apa01
                 WHERE aph01 = m_apf.apf01
                   AND aph02 = l_aph.aph02
                #No.MOD-D80144  --End
            ELSE 
                LET g_success = 'N'
                RETURN 
            END IF 
#No.FUN-A80111 --beggin
            
            LET l_apa.apa02  = m_apf.apf02
            LET l_apa.apa05  = m_apf.apf03
            LET l_apa.apa06  = m_apf.apf03
            LET l_apa.apa07  = m_apf.apf12
            LET l_apa.apa13  = m_apf.apf06
            LET l_apa.apa14  = m_apf.apf07           
            LET l_apa.apa51  = NULL 
            LET l_apa.apa511 = NULL
            IF g_apz.apz13 = 'Y' THEN
               SELECT aps61,aps611 INTO l_apa.apa54,l_apa.apa541 
                 FROM aps_file 
                WHERE aps01 = m_apf.apf05
            ELSE
               SELECT aps61,aps611 INTO l_apa.apa54,l_apa.apa541 
                 FROM aps_file 
                WHERE (aps01 = ' ' OR aps01 IS NULL)
            END IF

            SELECT pmc17 INTO l_apa.apa11 FROM pmc_file WHERE pmc01 = m_apf.apf03
            LET l_apa.apa31f = m_apf.apf09f
            LET l_apa.apa31  = m_apf.apf09
            LET l_apa.apa34f = m_apf.apf09f         
            LET l_apa.apa34  = m_apf.apf09
            LET l_apa.apa57  = m_apf.apf09
            LET l_apa.apa57f = m_apf.apf09f
            LET l_apa.apa36  = NULL 
            LET l_apa.apa79  = '2'   #溢退
#No.FUN-A90007 --begin  
         ELSE
            LET l_apa.apa02  = l_aph.aph24  
           #LET l_apa.apa00  = '12'#FUN-C90027 mark
#No.FUN-C90027--BEGIN
            IF g_apf.apf47 = '2' THEN
               LET l_apa.apa00  = '22'
               CALL s_auto_assign_no("aap",l_aph.aph23,l_aph.aph24,"22","apa_file","apa01","","","")
                    RETURNING li_result,l_aph.aph23
            ELSE
               LET l_apa.apa00  = '12'
               CALL s_auto_assign_no("aap",l_aph.aph23,l_aph.aph24,"12","apa_file","apa01","","","")
                    RETURNING li_result,l_aph.aph23
            END IF
#No.FUN-C90027--END
          # CALL s_auto_assign_no("aap",l_aph.aph23,l_aph.aph24,"12","apa_file","apa01","","","")#FUN-C90027 mark
          #      RETURNING li_result,l_aph.aph23#FUN-C90027 mark
            IF  li_result THEN
                LET l_apa.apa01  = l_aph.aph23             
                UPDATE aph_file SET aph23 = l_aph.aph23
                 #WHERE aph01 = g_apf.apf01           #MOD-D80049 mark
                 WHERE aph01 = m_apf.apf01            #MOD-D80049
                   AND aph02 = l_aph.aph02
            ELSE 
                LET g_success = 'N'
                RETURN 
            END IF 
            LET l_apa.apa05  = l_aph.aph21
            LET l_apa.apa06  = l_aph.aph21
            #SELECT pmc03 INTO l_apa.apa07  FROM pmc_file WHERE pmc01 = l_apa.apa06
            #SELECT pmc03 INTO l_apa.apa07  FROM pmc_file WHERE pmc01 = l_apa.apa06 ##CHI-CA0054 mark
            ##CHI-CA0054 add beg
            LET  l_apa.apa07 = l_aph.aph25
            IF cl_null(l_apa.apa07) THEN 
            	 SELECT pmc03 INTO l_apa.apa07  FROM pmc_file WHERE pmc01 = l_apa.apa06
            	 IF l_apa.apa07 IS NULL THEN 
            	    LET l_apa.apa07 = ' '
            	 END IF 
            END IF 	  
            #CHI-CA0054 add end            
            LET l_apa.apa13  = l_aph.aph13
            LET l_apa.apa14  = l_aph.aph14
            IF g_apz.apz68 ='Y' THEN 
               LET l_apa.apa51  = l_aph.aph04
               LET l_apa.apa511 = l_aph.aph041 
               LET l_apa.apa54  = NULL 
               LET l_apa.apa541 = NULL
               FOR i =1 TO g_apg.getlength()
                  IF cl_null(l_apa.apa54) THEN 
                     SELECT apa54,apa541 INTO l_apa.apa54,l_apa.apa541 FROM apa_file WHERE apa01 = g_apg[i].apg04
                     IF cl_null(l_apa.apa54) THEN 
                        LET l_apa.apa54 = NULL 
                     END IF 
                  END IF  
                  LET i = i + 1  
               END FOR 
   
            ELSE 
               LET l_apa.apa54  = l_aph.aph04
               LET l_apa.apa541 = l_aph.aph041 
               IF g_apz.apz13 = 'Y' THEN
                  LET l_depno = m_apf.apf05
               ELSE
                  LET l_depno = ' '
               END IF
               SELECT apt03,apt031 INTO l_apa.apa51,l_apa.apa511 
                 FROM apt_file WHERE apt01 = l_aph.aph22 AND apt02 = l_depno
            END IF 
            SELECT pmc17 INTO l_apa.apa11 FROM pmc_file WHERE pmc01 = l_aph.aph21     #No.FUN-A90007
            LET l_apa.apa31f = l_aph.aph05f
            LET l_apa.apa31  = l_aph.aph05
            LET l_apa.apa34f = l_aph.aph05f         
            LET l_apa.apa34  = l_aph.aph05
            LET l_apa.apa57  = l_aph.aph05
            LET l_apa.apa57f = l_aph.aph05f
            LET l_apa.apa36  = l_aph.aph22
            LET l_apa.apa79  = '1'   #转销
         END IF 
#No.FUN-A90007 --end 
         LET l_apa.apa08  = m_apf.apf01 
         LET l_apa.apa20  = 0                #No.MOD-BB0091   
         LET l_apa.apa21  = m_apf.apf04
         LET l_apa.apa22  = m_apf.apf05
         LET l_apa.apa16  = 0
         LET l_apa.apa52  = NULL 
         LET l_apa.apa521 = NULL 
         LET l_apa.apa171 = NULL 
         LET l_apa.apa172 = NULL 

         LET l_apa.apa09  = l_apa.apa02
         CALL s_paydate('a','',l_apa.apa09,l_apa.apa02,l_apa.apa11,l_apa.apa06)
              RETURNING l_apa.apa12,l_apa.apa64,l_apa.apa24
         LET l_apa.apa32f = 0
         LET l_apa.apa32  = 0
         LET l_apa.apa33f = 0
         LET l_apa.apa33  = 0

         LET l_apa.apa35f = 0
         LET l_apa.apa35  = 0
         LET l_apa.apa60f = 0
         LET l_apa.apa60  = 0
         LET l_apa.apa61f = 0
         LET l_apa.apa61  = 0
         LET l_apa.apa65f = 0
         LET l_apa.apa65  = 0
         LET l_apa.apa63  = 1
         LET l_apa.apa41  = 'Y'
         LET l_apa.apa42  = 'N'           #No.FUN-A80111
         LET l_apa.apamksg= 'N'
         LET l_apa.apa55  = 1             #No.FUN-A80111
         LET l_apa.apa72  = l_apa.apa14   #No.FUN-A80111
         LET l_apa.apa73  = l_apa.apa34          #No.MOD-BB0133
         LET l_apa.apa56  = 0
         LET l_apa.apa100 = g_plant   
         LET l_apa.apauser= g_user
         LET l_apa.apagrup= g_grup
         LET l_apa.apaacti= 'Y'
         LET l_apa.apadate= g_today
         LET l_apa.apaoriu= g_user
         LET l_apa.apaorig= g_grup
         LET l_apa.apalegal=g_legal
         LET l_apa.apa75 = 'N'                        #MOD-C80080 add
         LET l_apa.apa930=s_costcenter(l_apa.apa22)
         INSERT INTO apa_file VALUES(l_apa.*)  
         IF SQLCA.sqlcode THEN                    
            CALL cl_err3("ins","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","",1) 
            LET g_success = 'N'
            EXIT FOREACH 
         ELSE
            LET g_success ='Y'
#No.FUN-A80111 --begin
            CALL t310_ins_apc(l_apa.*) 
            IF g_success ='N' THEN RETURN END IF 
            #IF g_aptype ='32' THEN EXIT FOREACH END IF        #MOD-D80144 mark
#No.FUN-A80111 --end            
            CALL t310_b2_fill(" 1=1")
         END IF
   END FOREACH 
END FUNCTION 

FUNCTION t310_del_apa()
DEFINE  l_aph RECORD LIKE aph_file.*
DEFINE  l_apa RECORD LIKE apa_file.*
DEFINE  l_apy RECORD LIKE apy_file.*
#No.FUN-A90007 --begin
DEFINE  l_apv04      LIKE apv_file.apv04
DEFINE  l_apv04f     LIKE apv_file.apv04f
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  l_apk03      LIKE apk_file.apk03
DEFINE  l_sql        STRING
DEFINE  l_aba19      LIKE aba_file.aba19
DEFINE  l_yy,l_mm,l_n    LIKE type_file.num5
#No.FUN-A90007 --end


   IF g_aptype <>'36' AND g_aptype <>'32' THEN RETURN END IF   #No.FUN-A80111
#No.TQC-B20112 --begin 
#   SELECT * INTO m_apf.* FROM apf_file WHERE apf01 = g_apf.apf01   #No.TQC-B80079                                                                                                           
   LET l_cnt = 0
      #FUN-C90027 --str
   IF m_apf.apf47 = '2' THEN 
      SELECT COUNT(*) INTO l_cnt FROM apa_file
       WHERE apa08=m_apf.apf01 AND apa00='22'
   ELSE
   #FUN-C90027---end
   SELECT COUNT(*) INTO l_cnt FROM apa_file
    WHERE apa08=m_apf.apf01 AND apa00='12'
      #AND apa02 <= g_apf.apf02          #MOD-A30146 add #MOD-BC0235
   END IF #FUN-C90027 add
   IF l_cnt = 0 THEN
      RETURN                                                                             
   END IF   #MOD-870048 add
#No.TQC-B20112 --end
   DECLARE t310_sel_aph1 CURSOR FOR 
      SELECT * FROM aph_file WHERE aph01 = m_apf.apf01
   FOREACH t310_sel_aph1 INTO l_aph.*
      IF STATUS THEN CALL cl_err('sel aph',STATUS,1) EXIT FOREACH END IF   
      LET g_t1 = s_get_doc_no(l_aph.aph04)
#No.FUN-A90007 --begin
      IF g_aptype ='32' THEN 
         SELECT * INTO l_apa.* FROM apa_file WHERE apa08 = m_apf.apf01   #No.TQC-B20112  B80079 apa01 -->apa08
      ELSE
      	 SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = l_aph.aph23
      END IF  

  #-----MOD-770005---------已有產生折讓發票,不可取消確認
     DECLARE apk_curs CURSOR FOR 
       SELECT apk03 FROM apk_file WHERE apk01 = l_apa.apa01
     LET l_apk03=''
     FOREACH apk_curs INTO l_apk03
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
         WHERE apb11 = l_apk03 AND 
               apb01 = apa01 AND 
               apa00 MATCHES "2*" AND 
               apa58 <> '1' #MOD-770081
       IF l_cnt > 0 THEN
          CALL cl_err(l_apk03,'aap-666',0)
          LET g_success ='N'
          RETURN
       END IF
     END FOREACH
 
     #-----TQC-740314--------已有沖暫估資料不可取消確認
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM api_file
       WHERE api01 = l_apa.apa01 AND api02='2'
      IF l_cnt > 0 AND g_aptype ='16' THEN
         CALL cl_err(l_apa.apa01,'aap-140',0)
         LET g_success ='N'
         RETURN
      END IF
     
     #-----MOD-620008---------已有沖帳之資料不可取消確認
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt FROM aph_file,apf_file
       WHERE aph04 = l_apa.apa01 AND apf01=aph01
         AND apf41 != 'X'
      IF l_cnt > 0 THEN
         CALL cl_err(l_apa.apa01,'agl-905',0)
         LET g_success ='N'
         RETURN
      END IF
     
     
     #帳款單號已經存在于進銷項維護作業（amd_file.amd01），
     #不能取消確認
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt
       FROM amd_file
      WHERE amd01 = l_apa.apa01
     IF l_cnt > 0 THEN
        CALL cl_err(l_apa.apa01,'aap-188',0)
        LET g_success ='N'
        RETURN
     END IF
 
     #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原    
     CALL s_get_doc_no(l_apa.apa01) RETURNING g_t1   #No.TQC-740067
     SELECT * INTO l_apy.* FROM apy_file WHERE apyslip=g_t1                                                                           
     IF NOT cl_null(l_apa.apa44)  THEN         #No.TQC-740067                                                            
        IF NOT (l_apy.apydmy3 = 'Y' AND l_apy.apyglcr = 'Y') THEN                                                                     
           CALL cl_err(l_apa.apa01,'axr-370',0) RETURN    #No.TQC-740067                                                                            
        END IF                                                                                                                        
     END IF                                                                                                                           
     IF l_apy.apydmy3 = 'Y' AND l_apy.apyglcr = 'Y' THEN                                                                              
        LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'), 
                    "  WHERE aba00 = '",g_apz.apz02b,"'",
                    "    AND aba01 = '",l_apa.apa44,"'"  
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
        CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql 
        PREPARE aba_pre_del_apa FROM l_sql
        DECLARE aba_cs_del_apa CURSOR FOR aba_pre_del_apa
        OPEN aba_cs_del_apa
        FETCH aba_cs1 INTO l_aba19
        IF l_aba19 = 'Y' THEN                                                                                                         
           CALL cl_err(l_apa.apa44,'axr-071',1)                                                                                     
           CLOSE aba_cs_del_apa  
           LET g_success ='N'
           RETURN                                                                                                                     
        END IF                                                                                                                        
        CLOSE aba_cs_del_apa  
     END IF                                                                                                                           
     
     
     #-->立帳日期不可小於關帳日期
     IF l_apa.apa02 <= g_apz.apz57 THEN
        CALL cl_err(l_apa.apa01,'aap-176',1)
        LET g_success ='N'
        RETURN
     END IF
     # 期末調匯(A008)
     
     IF g_apz.apz27 = 'Y' AND l_apa.apa13 != g_aza.aza17 THEN
        LET l_yy = YEAR(l_apa.apa02)
        LET l_mm = MONTH(l_apa.apa02)
        IF (l_yy*12+l_mm) - (g_apz.apz21*12+g_apz.apz22) = 0 THEN
           CALL cl_err(l_mm,'axr-407',0)
           LET g_success ='N' 
           RETURN
        END IF
     END IF
     
     #-->若有沖帳之資料不可取消確認 modi in 01/03/14 bug:2923
     SELECT COUNT(*) INTO l_n FROM apg_file ,apf_file
      WHERE apg04 = l_apa.apa01 AND apf01=apg01 AND apf00 !='11' AND apf00 !='16'  #MOD-790086
        AND apf41 != 'X'   #no.7349
     IF l_n > 0 THEN
        CALL cl_err(l_apa.apa01,'agl-905',0)
        LET g_success ='N'
        RETURN
     END IF
     
     #-->已付款沖帳不可取消確認
     LET g_t1 = s_get_doc_no(l_apa.apa01)
     SELECT apydmy6 INTO g_apy.apydmy6 FROM apy_file WHERE apyslip = g_t1
     IF (l_apa.apa35<>0 OR l_apa.apa35f<>0) AND l_apa.apa55!='2' THEN
        CALL cl_err("apa41=Y",'aap-255',0)
        LET g_success ='N'
        RETURN
     END IF
     
     #-->已結案不可取消確認
     IF l_apa.apa42 = 'Y' THEN
        CALL cl_err("apa42=Y",'aap-165',0)
        LET g_success ='N'
        RETURN
     END IF
     
     IF g_aza.aza26 = '2' AND l_apa.apa00[1,1] = '1' THEN
        SELECT SUM(apv04),SUM(apv04f) INTO l_apv04,l_apv04f
          FROM apv_file
         WHERE apv03=l_apa.apa01
        IF cl_null(l_apv04) THEN LET l_apv04 = 0 END IF
        IF cl_null(l_apv04f) THEN LET l_apv04f = 0 END IF
        IF l_apv04 != 0 OR l_apv04f != 0 THEN
           CALL cl_err('','aap-914',0)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
     
     #單身已分攤, 則不可取消確認
     LET l_cnt=0
     SELECT COUNT(*) INTO l_cnt
       FROM aqa_file,aqb_file
      WHERE aqb01 = aqa01
        AND aqb02 = l_apa.apa01
        AND aqaconf<> 'X' #CHI-A50028 add
     IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
        LET l_cnt =0
     END IF
     
     IF l_cnt > 0 THEN
        CALL cl_err("apb10<>apb101",'aap-291',0)
        LET g_success ='N'
        RETURN
     END IF

{      #單身已分攤, 則不可取消確認
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt
        FROM aqa_file,aqb_file
       WHERE aqb01 = aqa01
         AND aqb02 = l_apa.apa01
         AND aqaconf<> 'X'
      IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
         LET l_cnt =0
      END IF
      
      IF l_cnt > 0 THEN
         CALL cl_err(l_apa.apa01,'aap-291',0)
         LET g_success ='N'
         RETURN
      END IF

      SELECT SUM(apv04),SUM(apv04f) INTO l_apv04,l_apv04f
        FROM apv_file
       WHERE apv03=g_apa.apa01
      IF cl_null(l_apv04) THEN LET l_apv04 = 0 END IF
      IF cl_null(l_apv04f) THEN LET l_apv04f = 0 END IF
      IF l_apv04 != 0 OR l_apv04f != 0 THEN
         CALL cl_err(l_apa.apa01,'aap-914',0)
         LET g_success = 'N'
         RETURN
      END IF 
}
#No.FUN-A90007 --end
      SELECT * INTO l_apy.* FROM apy_file WHERE apyslip=g_t1
      IF l_apy.apydmy3 = 'Y' AND l_apy.apyglcr = 'Y' THEN
         LET g_wc_gl = 'npp01 = "',l_apa.apa01,'" AND npp011 = 1'
         LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",l_apa.apa44,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
      END IF 
      MESSAGE 'del npp !'
      DELETE FROM npp_file
       WHERE npp01 = l_apa.apa01
         AND nppsys = 'AP'
         AND npp00 = 1
         AND npp011 = 1
      IF STATUS THEN
         CALL cl_err3("del","npp_file",l_apa.apa01,"",STATUS,"","del npp:",1)  #No.FUN-660122
         LET g_success ='N'
         EXIT FOREACH 
      END IF
 
      MESSAGE 'del npq !'
      DELETE FROM npq_file
       WHERE npq01 = l_apa.apa01
         AND npqsys = 'AP'
         AND npq00 = 1
         AND npq011 = 1
      IF STATUS THEN
         CALL cl_err3("del","npq_file",l_apa.apa01,"",STATUS,"","del npq:",1)  #No.FUN-660122
         LET g_success ='N'
         EXIT FOREACH 
      END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = l_apa.apa01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",l_apa.apa01,"",STATUS,"","del tic:",1)
         LET g_success ='N'
         EXIT FOREACH
      END IF
      #FUN-B40056--add--end--

#No.FUN-A80111 --begin
#No.FUN-A90007 --begin
      IF g_aptype ='32' THEN 
         DELETE FROM apc_file WHERE apc01 = l_apa.apa01   #No.TQC-B20112
         IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN                    
            CALL cl_err3("del","apc_file",l_apa.apa01,"",SQLCA.sqlcode,"","",1)   #No.TQC-B20112
            LET g_success ='N'
            EXIT FOREACH 
         END IF 
      ELSE
      	 DELETE FROM apc_file WHERE apc01 = l_aph.aph23
         IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN                    
            CALL cl_err3("del","apc_file",l_aph.aph23,"",SQLCA.sqlcode,"","",1) 
            LET g_success ='N'
            EXIT FOREACH 
         END IF 
      END IF  
#No.FUN-A90007 --end
#No.FUN-A80111 --end
#No.FUN-A90007 --begin
      IF g_aptype ='32' THEN 
         DELETE FROM apa_file WHERE apa01 = l_apa.apa01   #No.TQC-B20112
         IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN                    
            CALL cl_err3("del","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","",1)   #No.TQC-B20112
            LET g_success ='N'
            EXIT FOREACH 
         ELSE
#           UPDATE aph_file SET aph04 = g_apz.apz64 WHERE aph01 = l_aph.aph01 AND aph02 = l_aph.aph02    #No.TQC-B80079-110809
            CALL s_get_doc_no(l_aph.aph23) RETURNING g_t1                                       #MOD-BC0235
            UPDATE aph_file SET aph23 = g_t1 WHERE aph01 = l_aph.aph01 AND aph02 = l_aph.aph02  #MOD-BC0235
         END IF
      ELSE
      	 DELETE FROM apc_file WHERE apc01 = l_aph.aph23
         DELETE FROM apa_file WHERE apa01 = l_aph.aph23
         IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN                    
            CALL cl_err3("del","apa_file",l_aph.aph23,"",SQLCA.sqlcode,"","",1) 
            LET g_success ='N'
            EXIT FOREACH 
         ELSE
#           UPDATE aph_file SET aph23 = g_apz.apz64 WHERE aph01 = l_aph.aph01 AND aph02 = l_aph.aph02  #No.TQC-B20112
         END IF
      END IF  
#No.FUN-A90007 --end
   END FOREACH 
   CALL t310_b2_fill(" 1=1")
END FUNCTION 

#No.FUN-A90007 --begin
#FUNCTION t310_apf46(p_cmd)
#   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#   DEFINE l_pmc22   LIKE pmc_file.pmc22
#   DEFINE l_pmc24   LIKE pmc_file.pmc24
#   DEFINE l_pmc03 LIKE pmc_file.pmc03
#   DEFINE l_pmc05 LIKE pmc_file.pmc05
#   DEFINE l_pmcacti LIKE pmc_file.pmcacti
#
#   IF g_aptype <> '36' THEN RETURN END IF 
#   SELECT pmc22,pmc24,pmc03,pmc05,pmcacti
#      INTO l_pmc22,l_pmc24,l_pmc03,l_pmc05,l_pmcacti
#      FROM pmc_file
#      WHERE pmc01 = g_apf.apf46
#
#   LET g_errno = ' '
#   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
#        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
#        WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'   #No.FUN-690024 add 
#        WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'
#        WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'
#        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
#   END CASE
#
#   DISPLAY l_pmc03 TO FORMONLY.pmc03
#
#END FUNCTION
#No.FUN-A90007 --end
FUNCTION t310_carry_voucher_apa()
  DEFINE l_apy        RECORD LIKE apy_file.*
  DEFINE li_result    LIKE type_file.num5      
  DEFINE g_t1         LIKE oay_file.oayslip   
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5     
  DEFINE l_wc         STRING                 
  DEFINE l_apa        RECORD LIKE apa_file.* 
  DEFINE l_apf44      LIKE apf_file.apf44                 #MOD-C50093 add
    
    IF g_aptype <>'36' THEN RETURN END IF 
    IF g_apz.apz68 ='N' THEN RETURN END IF   #No.FUN-A90007
    DECLARE  t310_sel_apa CURSOR   FOR SELECT apa_file.* FROM apa_file,aph_file WHERE apa01 = aph23 AND aph01 = g_apf.apf01
    FOREACH t310_sel_apa INTO l_apa.* 
       CALL s_get_doc_no(l_apa.apa01) RETURNING g_t1
       SELECT * INTO l_apy.* FROM apy_file WHERE apyslip=g_t1
       IF l_apy.apydmy3 = 'Y' THEN   #是否拋轉傳票
          DELETE FROM npq_file WHERE npqsys = 'AP' AND npq00 = 1
                                 AND npq01  = l_apa.apa01 AND npq011 = 1
          CALL t110_g_gl(l_apa.apa00,l_apa.apa01,'0','')  
          IF g_aza.aza63 ='Y' THEN
             CALL t110_g_gl(l_apa.apa00,l_apa.apa01,'1','') 
          END IF
       ELSE
          CALL cl_err(l_apa.apa00,'aap-286',0)
          RETURN 
       END IF    
       IF l_apy.apydmy3 = 'N' THEN RETURN END IF
       IF l_apy.apyglcr = 'Y' OR (l_apy.apyglcr ='N' AND NOT cl_null(l_apy.apygslp)) THEN 
          LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new     
        # LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",                              #FUN-A50102 mark
          LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                      "  WHERE aba00 = '",g_apz.apz02b,"'",
                      "    AND aba01 = '",l_apa.apa44,"'"
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql        #FUN-A50102 mark
          PREPARE aba_pre21 FROM l_sql
          DECLARE aba_cs21 CURSOR FOR aba_pre21
          OPEN aba_cs21
          FETCH aba_cs21 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(l_apa.apa44,'aap-991',1)
             RETURN
          END IF
       ELSE
       	 CALL cl_err('','aap-936',1)     
          RETURN       
       END IF
       IF cl_null(l_apy.apygslp) OR (cl_null(l_apy.apygslp1) AND g_aza.aza63 = 'Y') THEN  
          CALL cl_err(l_apa.apa01,'axr-070',1)
          RETURN
       END IF
       IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y'  THEN
         #CALL s_showmsg_init()                                    #MOD-C50093 add #MOD-C50243 mark
          LET g_wc_gl = " npp01='",l_apa.apa01,"'"
          LET l_wc = g_wc_gl clipped," AND npp011 = 1 "
          LET g_str = "aapp400" ,
                      ' "',l_wc CLIPPED,'"',
                      ' "',l_apa.apauser,'"',    
                      ' "',l_apa.apauser,'"',    
                      ' "',g_apz.apz02p,'" ',
                      ' "',g_apz.apz02b,'" ',
                      ' "',l_apy.apygslp,'" ',
                      ' "',l_apa.apa02,'" ',
                      ' "Y" ',
                      ' "1" ',      
                      ' "Y" ',
                      ' "',g_apz.apz02c,'" ',
                      ' "',l_apy.apygslp1,'" '
          CALL cl_wait()
          CALL cl_cmdrun_wait(g_str CLIPPED)  
         #--------------------------MOD-C50093---------------------------(S)
          SELECT apf44 INTO l_apf44 FROM apf_file
           WHERE apf01 = l_apa.apa01
          CALL s_errmsg('',l_apf44,'','','')
          CALL s_showmsg()
         #--------------------------MOD-C50093---------------------------(E)
       END IF 
    END FOREACH 
END FUNCTION
#No.FUN-A60024 --end
#No.FUN-A80111 --begin
FUNCTION t310_get_curr()
DEFINE  l_curr    LIKE aph_file.aph13
DEFINE  l_rate    LIKE aph_file.aph14
DEFINE  l_name    LIKE azi_file.azi02
DEFINE  l_str1    STRING
DEFINE  l_str2    STRING
DEFINE  l_n       LIKE type_file.num5
   
   DECLARE t310_get_curr CURSOR FOR
      SELECT DISTINCT aph13 FROM aph_file
       WHERE aph01 = m_apf.apf01
   LET l_curr = NULL 
   LET l_name = NULL 
   LET l_str1 = NULL 
   LET l_str2 = NULL 
   LET l_n = 0
   FOREACH t310_get_curr INTO l_curr
      IF cl_null(l_curr) THEN CONTINUE FOREACH END IF 
      SELECT azi02 INTO l_name FROM azi_file WHERE azi01 = l_curr
      IF cl_null(l_name) THEN LET l_name = ' ' END IF

      IF cl_null(l_str1) THEN 
         LET l_str1 = l_curr CLIPPED
         LET l_str2 = l_curr,":",l_name 
      ELSE
         LET l_str1 = l_str1 CLIPPED,",",l_curr CLIPPED
         LET l_str2 = l_str2 CLIPPED,",",l_curr,":",l_name
      END IF
      LET l_n =l_n + 1
   END FOREACH
   IF l_n >1 THEN 
      OPEN WINDOW t310_w32_1 AT 2,2 WITH FORM "aap/42f/aapt332_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)  

      CALL cl_ui_init()
      CALL cl_set_combo_items("curr",l_str1,l_str2)
      INPUT l_curr FROM curr
      
      
          AFTER FIELD curr
             CALL s_curr3(l_curr,m_apf.apf02,g_apz.apz33) RETURNING l_rate
             IF l_curr =g_aza.aza17 THEN
                LET l_rate = 1
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
          CLOSE WINDOW t310_w32_1
          RETURN '',''
      END IF
      CLOSE WINDOW t310_w32_1
      RETURN l_curr,l_rate
   ELSE 
      CALL s_curr3(l_curr,m_apf.apf02,g_apz.apz33) RETURNING l_rate
      IF l_curr =g_aza.aza17 THEN
         LET l_rate = 1
      END IF
   	  RETURN l_curr,l_rate
   END IF 
END FUNCTION 

FUNCTION t310_ins_apc(l_apa)
DEFINE l_apc     RECORD LIKE apc_file.*
DEFINE l_apa     RECORD LIKE apa_file.*

   SELECT azi04 INTO t_azi04 FROM azi_file                                                                                          
      WHERE azi01 = g_apa.apa13 
      
   LET l_apc.apc01 = l_apa.apa01
   LET l_apc.apc02 = 1
   LET l_apc.apc03 = l_apa.apa11
   LET l_apc.apc04 = l_apa.apa12
   LET l_apc.apc05 = l_apa.apa64
   LET l_apc.apc06 = l_apa.apa14
   LET l_apc.apc07 = l_apa.apa72
   LET l_apc.apc08 = l_apa.apa34f
   LET l_apc.apc09 = l_apa.apa34
   LET l_apc.apc10 = l_apa.apa35f                                                                                          
   LET l_apc.apc11 = l_apa.apa35                                                                                           
   LET l_apc.apc12 = l_apa.apa08
   LET l_apc.apc13 = l_apc.apc09-l_apc.apc11
   LET l_apc.apc14 = 0
   LET l_apc.apc15 = 0
   LET l_apc.apc16 = 0             
   
   LET l_apc.apc08 = cl_digcut(l_apc.apc08,t_azi04)
   LET l_apc.apc09 = cl_digcut(l_apc.apc09,g_azi04)
   LET l_apc.apc13 = cl_digcut(l_apc.apc13,g_azi04)
   
   LET l_apc.apclegal = g_legal 
   INSERT INTO apc_file VALUES(l_apc.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","apc_file","apc01","apc02",SQLCA.sqlcode,"","",1)
      LET g_success ='N'
   END IF 
END FUNCTION 

FUNCTION t310_chk_apa35(p_apf01)
DEFINE l_apa   RECORD LIKE apa_file.*
DEFINE p_apf01 LIKE apf_file.apf01

   DECLARE t310_sel_apa35 CURSOR FOR 
      SELECT * FROM apa_file WHERE apa08 = p_apf01
   
   FOREACH t310_sel_apa35 INTO l_apa.*
      IF STATUS THEN CALL cl_err('sel aph',STATUS,1) EXIT FOREACH END IF  
      IF l_apa.apa35 >0 OR l_apa.apa35f >0 THEN 
         CALL cl_err(l_apa.apa01,'aap-149',1)
         LET g_success ='N' 
         RETURN 
      END IF 
   END FOREACH 
END FUNCTION 
#No.FUN-A80111 --end

##CHI-CA0054 mark beg-----------
#No.FUN-A90007 --begin
#FUNCTION t110_aph21(p_cmd)
#   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#   DEFINE l_pmc03   LIKE pmc_file.pmc03
#   DEFINE l_pmc04   LIKE pmc_file.pmc04
#   DEFINE l_pmc05   LIKE pmc_file.pmc05
#   DEFINE l_pmcacti LIKE pmc_file.pmcacti
#   DEFINE l_pmc24   LIKE pmc_file.pmc24
# 
#   SELECT pmc03,pmc04,pmc05,pmcacti,pmc24
#     INTO l_pmc03,l_pmc04,l_pmc05,l_pmcacti,l_pmc24
#     FROM pmc_file WHERE pmc01 = g_aph[l_ac].aph21
# 
#   LET g_errno = ' '
# 
#   CASE
#      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
#      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'    #No.FUN-690024
#     
#      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'    #MOD-950045        
#      WHEN l_pmc05   = '3'            LET g_errno = 'aap-033' 
# 
#       WHEN STATUS=100 LET g_errno = '100'  #MOD-4B0124
#      WHEN SQLCA.SQLCODE != 0
#         LET g_errno = SQLCA.SQLCODE USING '-----'
#   END CASE
# 
#   DISPLAY l_pmc03 TO pmc03
# 
#   IF NOT cl_null(g_errno) THEN
#      RETURN
#   END IF
#   LET g_aph[l_ac].pmc03 = l_pmc03
# 
#END FUNCTION
#CHI-CA0054 mark end-----------


FUNCTION t310_aph_def()                #create aph_file
DEFINE l_apg05f      LIKE apg_file.apg05f
DEFINE l_apg05       LIKE apg_file.apg05
DEFINE l_apa13       LIKE apa_file.apa13
DEFINE l_apa14       LIKE apa_file.apa14
DEFINE i             LIKE type_file.num5
DEFINE l_aph         RECORD LIKE aph_file.* 
DEFINE l_n           LIKE type_file.num5
DEFINE l_apa36       LIKE apa_file.apa36
DEFINE l_apa54       LIKE apa_file.apa54
DEFINE l_apa541      LIKE apa_file.apa541
DEFINE  l_depno      LIKE apf_file.apf05

    IF g_aptype <>'36' THEN RETURN END IF 
    LET g_aph[l_ac].aph24  = g_apf.apf02  #MOD-CC0054
    LET l_apa36 = NULL 
    LET l_apa54 = NULL 
    FOR i =1 TO g_apg.getlength()
       IF cl_null(l_apa36) AND cl_null(l_apa54) THEN 
          SELECT apa36,apa54,apa541 INTO l_apa36,l_apa54,l_apa541 FROM apa_file WHERE apa01 = g_apg[i].apg04
          IF cl_null(l_apa36) OR cl_null(l_apa54) THEN 
             LET l_apa36 = NULL 
             LET l_apa54 = NULL 
          END IF 
       END IF  
       LET g_aph[l_ac].aph02  = l_ac
       LET g_aph[l_ac].aph03  = g_apz.apz65
       IF g_apz.apz68 ='Y' THEN  
          SELECT apw03,apw031 INTO g_aph[l_ac].aph04,g_aph[l_ac].aph041
            FROM apw_file WHERE apw01 = g_apz.apz65
          IF cl_null(g_aph[l_ac].aph04) THEN 
             LET g_aph[l_ac].aph04  = l_apa54
             LET g_aph[l_ac].aph041 = l_apa541
          END IF 
       ELSE 
       	  LET g_aph[l_ac].aph04  = l_apa54
          LET g_aph[l_ac].aph041 = l_apa541
          IF cl_null(g_aph[l_ac].aph04) THEN 
             SELECT apw03,apw031 INTO g_aph[l_ac].aph04,g_aph[l_ac].aph041
               FROM apw_file WHERE apw01 = g_apz.apz65
          END IF 
       END IF
       LET g_aph[l_ac].aph22  = l_apa36
       IF cl_null(g_aph[l_ac].aph22) THEN 
          LET g_aph[l_ac].aph22  = g_apz.apz66
       END IF 
      #LET g_aph[l_ac].aph23  = g_apz.apz64#FUN-C90027 mark
#No.FUN-C90027--BEGIN
       IF g_aptype ='36' AND g_apf.apf47 = '2' THEN
          LET g_aph[l_ac].aph23  = g_apz.apz70
       ELSE
          LET g_aph[l_ac].aph23  = g_apz.apz64 
       END IF
#No.FUN-C90027--END
      #LET g_aph[l_ac].aph24  = g_today      #MOD-CC0054 mark
       LET g_aph[l_ac].aph13  = g_apg[i].apa13
       LET g_aph[l_ac].aph14  = g_apg[i].apa14
      IF g_aptype != '36' THEN #FUN-C90027
       LET g_aph[l_ac].aph05f = 0
       LET g_aph[l_ac].aph05  = 0         
      END IF #FUN-C90027    
       EXIT FOR      
    END FOR
END FUNCTION

#No.FUN-A90007 --end

#CHI-AA0003 add --start--
FUNCTION t3101()
   DEFINE l_apa31f         LIKE apa_file.apa31f     #CHI-B70031
   DEFINE l_apa31          LIKE apa_file.apa31
   DEFINE l_apa            DYNAMIC ARRAY OF RECORD  
                   apa01   LIKE apa_file.apa01     
                        END RECORD                
   DEFINE i                LIKE type_file.num5    
   DEFINE l_cnt            LIKE type_file.num5    
   DEFINE l_apa00          LIKE apa_file.apa00   #No.TQC-B20112

   IF s_aapshut(0) THEN RETURN END IF
   IF g_apf.apf01 IS NULL THEN RETURN END IF
   SELECT * INTO g_apf.* FROM apf_file
    WHERE apf01=g_apf.apf01
   IF g_apf.apf41 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_apf.apf41 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #IF NOT s_chkpost(g_apf.apf44,g_apf.apf01) THEN RETURN END IF  FUN-CB0054 mark
   IF NOT s_chkpost(g_apf.apf44,g_apf.apf01,0) THEN RETURN END IF #FUN-CB0054 add
   IF g_apf.apfacti ='N' THEN CALL cl_err(g_apf.apf01,'9027',0) RETURN END IF
    IF g_apf.apf42 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
   END IF
   IF g_aptype = '32' THEN RETURN END IF  #MOD-C70154

   IF g_apf.apf10 = g_apf.apf08 THEN RETURN END IF               #TQC-B10199 mark #CHI-B70031 remark
  #-CHI-B70031-add-
   IF g_apf.apf10f!=g_apf.apf08f THEN
      LET l_apa31f=0
      SELECT apa31f INTO l_apa31f 
        FROM apa_file 
       WHERE apa00='24' AND apa08=g_apf.apf01
      IF cl_null(l_apa31f) THEN LET l_apa31f=0 END IF
      IF g_apf.apf10f-l_apa31f=g_apf.apf08f THEN RETURN END IF
   END IF
  #-CHI-B70031-end-
  #-TQC-B10199-add-
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt 
   FROM apg_file,apa_file
   WHERE apg01 = g_apf.apf01 
     AND apa01 = apg04 
     AND apa14 IN (SELECT aph14 FROM aph_file WHERE aph01 = g_apf.apf01 )
   IF l_cnt > 0 THEN  
      #表示匯率相同,檢核是否有暫付差異
      IF g_apf.apf10 = g_apf.apf08 THEN RETURN END IF
   END IF 
  #-TQC-B10199-end-
   
  #-MOD-B10116-mark-
  #SELECT apa31 INTO l_apa31 FROM apa_file
  # WHERE apa08=g_apf.apf01 AND apa00='24'
  #   AND apa02 <= g_apf.apf02
  #IF NOT cl_null(l_apa31) THEN
  #   IF l_apa31 = g_apf.apf09 THEN 
  #       RETURN
  #   END IF
  #END IF
  #-MOD-B10116-end-

  #-MOD-B10116-add-
   LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt                #MOD-B80062 mark
   SELECT COUNT(DISTINCT aph13) INTO l_cnt   #MOD-B80062
     FROM aph_file
    WHERE aph01 = g_apf.apf01 
      AND aph13 <> g_apf.apf06
  #IF l_cnt > 0 THEN               #TQC-B10199 mark
   IF l_cnt > 1 THEN               #TQC-B10199       #代表付款幣別有兩種以上
      CALL cl_err('','aap-154',1)
      RETURN
   END IF
  #-MOD-B10116-end-

   OPEN WINDOW t3101_w WITH FORM "aap/42f/aapt3101"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aapt3101")

   INPUT BY NAME diff_flag
      AFTER FIELD diff_flag
         IF diff_flag NOT MATCHES "[1234567E]" THEN NEXT FIELD diff_flag END IF  #FUN-C90044 add-6 #FUN-CB0117-add--7
   #by No.TQC-B20112 --begin
         #  IF diff_flag MATCHES '[3]'  AND g_apf.apf10 < g_apf.apf08 THEN
         #     CALL cl_err('','aap-143',0) NEXT FIELD diff_flag
         #  END IF
         #  IF diff_flag MATCHES '[4]'  AND g_apf.apf08 < g_apf.apf10 THEN
         #     CALL cl_err('','aap-167',0) NEXT FIELD diff_flag
         #  END IF
         IF g_aptype = '32' THEN
#           IF diff_flag MATCHES '[3]'  AND g_apf.apf10 > g_apf.apf08 THEN
            #FUN-C90044--MOD--STR
           #IF diff_flag MATCHES '[3]'  AND g_apf.apf09 > 0 THEN
           #   CALL cl_err('','aap-143',0) NEXT FIELD diff_flag
           #END IF
            IF diff_flag MATCHES '[35]' THEN
               CALL cl_err('','aap1006',0)
               NEXT FIELD diff_flag
            END IF
            #FUN-C90044--mod--end
            IF diff_flag MATCHES '[4]'  AND g_apf.apf08 > g_apf.apf10 THEN
               CALL cl_err('','aap-167',0) NEXT FIELD diff_flag
            END IF
         ELSE
            #FUN-C90044--ADD--STR
            IF g_aptype = '33' THEN
               IF diff_flag MATCHES '[4]'  THEN
                  CALL cl_err('','aap1005',0) NEXT FIELD diff_flag
               END IF

               IF diff_flag MATCHES '[67]' AND g_apf.apf10 > g_apf.apf08  THEN #FUN-CB0117-add--7
                  CALL cl_err('','aap1007',0) NEXT FIELD diff_flag
               END IF
            END IF
            #FUN-C90044---add--end
           #IF diff_flag MATCHES '[3]'  AND g_apf.apf10 < g_apf.apf08 THEN  #MOD-B10116 mark
            IF diff_flag MATCHES '[3]'  AND g_apf.apf09 < 0 THEN            #MOD-B10116
               CALL cl_err('','aap-143',0) NEXT FIELD diff_flag
            END IF
            IF diff_flag MATCHES '[4]'  AND g_apf.apf08 < g_apf.apf10 THEN
               CALL cl_err('','aap-167',0) NEXT FIELD diff_flag
            END IF
         END IF
   #by No.TQC-B20112 --end


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
   IF INT_FLAG THEN LET INT_FLAG=0 LET diff_flag='1' END IF
   CLOSE WINDOW t3101_w

   IF diff_flag MATCHES "[1234567]" THEN  #FUN-C90044 add--6 #FUN-CB0117-add--7
      BEGIN WORK
#No.TQC-B20112 --begin
      IF g_aptype ='32' OR g_aptype ='36' THEN 
         LET l_apa00 ='12'
      ELSE 
         LET l_apa00 ='24'
      END IF 
#No.TQC-B20112 --end
      DECLARE t3101_apc CURSOR FOR                                     
        SELECT apa01 FROM apa_file WHERE apa08=g_apf.apf01 AND apa00=l_apa00   #No.TQC-B20112
                                     AND apa02 <= g_apf.apf02   
      LET i=1
      FOREACH t3101_apc INTO l_apa[i].apa01
         LET i=i+1
      END FOREACH

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM apa_file
       WHERE apa08=g_apf.apf01 AND apa00=l_apa00   #No.TQC-B20112
         AND apa02 <= g_apf.apf02
      IF l_cnt > 0 THEN
         DELETE FROM apa_file WHERE apa08=g_apf.apf01 AND apa00=l_apa00   #No.TQC-B20112
                                AND apa02 <= g_apf.apf02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("del","apa_file",g_apf.apf01,g_apf.apf02,STATUS,"","del apa_file:t3101",1)
            LET g_success = 'N'
         END IF
         IF SQLCA.sqlcode=0 THEN
            FOR i=1 TO l_apa.getLength()
               IF cl_null(l_apa[i].apa01) THEN CONTINUE FOR END IF                                                                      
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM apc_file
                WHERE apc01=l_apa[i].apa01
               IF l_cnt > 0 THEN
                  DELETE FROM apc_file WHERE apc01=l_apa[i].apa01                                                                       
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("del","apc_file",l_apa[i].apa01,'',SQLCA.sqlcode,"","del apc_file:t3101",1)
                     LET g_success = 'N' 
                  END IF                                                                                                             
               END IF 
            END FOR                
         END IF                                                                                                 
      END IF
      CALL t310_b1_tot()
      CALL t310_b2_tot()
      IF g_success ='N' THEN
         ROLLBACK WORK
      ELSE
         COMMIT WORK
      END IF
   END IF

   IF diff_flag='1' THEN CALL t310_b() END IF #GENERO 再進單身時
   IF diff_flag='2' THEN CALL t310_b2() END IF #GENERO 再進單身時

   IF diff_flag MATCHES "[34567]" THEN   #FUN-C90044 ADD--6 #FUN-CB0117-add--7
      BEGIN WORK
      IF diff_flag ='3' THEN
         CALL t310_tmp_apf09()         # 轉溢付
        #CALL t310_tmp_pay(g_apf.*)    #MOD-B10116 mark
        #-MOD-B10116-add-
         IF g_apf.apf10 != (g_apf.apf08+g_apf.apf09) THEN
            CALL t310_diff()
            CALL t310_b2_fill('1=1')        #單身
         END IF
         CALL t310_b2_tot()
#         CALL t310_tmp_pay(g_apf.*)    #No.TQC-B80079
        #-MOD-B10116-end-
      END IF
      IF diff_flag='4' THEN
#         CALL t310_ins_apa()           #轉溢退   #No.TQC-B80079
      END IF
      IF diff_flag ='5' THEN
         CALL t310_diff()
         CALL t310_b_fill('1=1')         #單身
         CALL t310_b2_fill('1=1')        #單身
        #-MOD-B10116-add-
         IF g_apf.apf09 > 0 THEN
            CALL t310_b2_tot()
#            CALL t310_tmp_pay(g_apf.*)           #No.TQC-B80079
         END IF
        #-MOD-B10116-end-
         LET diff_flag='1'               #若無此段第二次進入單身會當出
      END IF
      #FUN-C90044--add--str
      IF (g_aptype = '33' AND (diff_flag ='6' OR diff_flag ='7')) OR ((diff_flag='4' OR diff_flag = '6') AND g_aptype='32') THEN #FUN-CB0117--add--7
         CALL t310_diff()
         CALL t310_b2_fill('1=1')
      END IF
      #FUN-C90044--ADD---end
      CALL t310_b1_tot()
      CALL t310_b2_tot()
      #FUN-C90044--add--end
      IF (g_aptype = '33' AND (diff_flag ='6' OR diff_flag = '7')) OR ((diff_flag='4' OR diff_flag = '6') AND g_aptype='32') THEN #FUN-CB0117--add--7
         CALL t310_v('2')
      END IF
      #FUN-C90044--add--end
      IF g_success ='N' THEN
         ROLLBACK WORK
      ELSE
         COMMIT WORK
      END IF
   END IF
   LET g_chr = diff_flag  #TQC-B10199  
END FUNCTION

FUNCTION t310_diff()
   DEFINE l_aph05d  LIKE aph_file.aph05
   DEFINE l_aph05c  LIKE aph_file.aph05
   DEFINE l_cnt         LIKE type_file.num5        #MOD-B10116
   DEFINE l_cnt1        LIKE type_file.num5        #MOD-C20058 add
   DEFINE l_cnt2        LIKE type_file.num5        #MOD-C20058 add
   DEFINE l_aph14       LIKE aph_file.aph14        #MOD-B10116

   IF g_apf.apf10 = g_apf.apf08 THEN RETURN END IF

  #-MOD-B10116-add-
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt 
     FROM aph_file
    WHERE aph01 = g_apf.apf01 
      AND aph13 <> g_apf.apf06
  #-MOD-B10116-end-

   INITIALIZE m_aph.* TO NULL
   LET m_aph.aph01 = g_apf.apf01 
   LET m_aph.aph09 = 'N'
   LET m_aph.aph14  = 1
   LET m_aph.aph05f = 0
   LET m_aph.aph05 = 0     #TQC-C70090  add
 #-MOD-B10116-add-
  #IF l_cnt = 0 THEN                                                    #MOD-C20058 mark
   LET g_sql = "SELECT aph14 ",
               "  FROM aph_file ",
               " WHERE aph01 = '",g_apf.apf01,"'",
               "   AND aph13 = '",g_apf.apf06,"'"
   PREPARE t310_aph14dp FROM g_sql
   DECLARE t310_aph14dc SCROLL CURSOR WITH HOLD FOR t310_aph14dp
   OPEN t310_aph14dc    
   FETCH FIRST t310_aph14dc INTO l_aph14 
  #----------------------------MOD-C20058-----------------------start
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   SELECT COUNT(*) INTO l_cnt1            #抓取單身總筆數
     FROM aph_file
    WHERE aph01 = g_apf.apf01

   SELECT COUNT(*) INTO l_cnt2            #判斷單身的匯率是否相同
     FROM aph_file
    WHERE aph01 = g_apf.apf01
      AND aph13 = g_apf.apf06
      AND aph14 = l_aph14
   IF l_cnt = 0 AND l_cnt1 = l_cnt2 THEN   #單頭和單身幣別相同，但單身的匯率不同時，走else段
  #----------------------------MOD-C20058-------------------------end
      LET m_aph.aph05 = g_apf.apf08f * l_aph14 
      CALL cl_digcut(m_aph.aph05,g_azi04) RETURNING m_aph.aph05 
      LET m_aph.aph05 = g_apf.apf08 - m_aph.aph05
      #FUN-C90044--ADD---STR
      IF ((diff_flag='6' OR diff_flag ='7') AND g_aptype='33') OR ((diff_flag='4' OR diff_flag ='6') AND g_aptype='32') THEN #FUN-CB0117--add--7
          LET m_aph.aph05 = g_apf.apf08 - g_apf.apf10
      END IF
      #FUN-C90044--ADD--END 
   ELSE
 #-MOD-B10116-end-
      LET m_aph.aph05 = g_apf.apf08 - g_apf.apf10
   END IF             #MOD-B10116

   #TQC-C70090--add--str--
   IF cl_null(m_aph.aph05) THEN
      LET m_aph.aph05 = 0 
   END IF
   #TQC-C70090--add--end--

  #LET m_aph.aph13 = g_apf.apf06      #MOD-B10116 mark
   LET m_aph.aph13 = g_aza.aza17      #MOD-B10116
   IF g_apf.apf08 > g_apf.apf10 THEN #匯兌收入
      LET m_aph.aph03 = '4'
     #No.MOD-BC0242 --begin
      IF g_aptype <> '32' THEN
         LET m_aph.aph04 = g_aps.aps43
         LET m_aph.aph041= g_aps.aps431
      END IF
     #No.MOD-BC0242 --end
      #FUN-C90044--add--str
      IF ((diff_flag='6' OR diff_flag = '7') AND g_aptype='33') OR ((diff_flag='4'  OR diff_flag = '6') AND g_aptype='32') THEN #FUN-CB0117--add--7
         #FUN-CB0117----add----str
         IF (diff_flag='6' AND g_aptype='33') OR ((diff_flag='4'  OR diff_flag = '6') AND g_aptype='32') THEN
            LET m_aph.aph03 = 'E'
         END IF
         IF diff_flag='7' AND g_aptype='33' THEN
            LET m_aph.aph03 = 'H'
         END IF
         #FUN-CB0117--add----end
        #LET m_aph.aph03 = 'E' #FUN-CB0117 mark
        #FUN-C90044--add-str-by xuxz
         LET m_aph.aph22 = g_apz.apz66
         IF g_apz.apz13 = 'N' THEN
            SELECT apt04 INTO m_aph.aph04 FROM apt_file
          WHERE apt01 = m_aph.aph22
         ELSE
            SELECT apt04 INTO m_aph.aph04 FROM apt_file
             WHERE apt01 = m_aph.aph22
               AND apt02 = g_apf.apf03
         END IF
         IF cl_null(m_aph.aph04) THEN
            LET m_aph.aph04 = g_aps.aps22
         END IF
         IF g_aza.aza63 = 'Y' THEN
            IF g_apz.apz13 = 'N' THEN
               SELECT apt041 INTO m_aph.aph041 FROM apt_file
             WHERE apt01 = m_aph.aph22
            ELSE
               SELECT apt041 INTO m_aph.aph041 FROM apt_file
                WHERE apt01 = m_aph.aph22
                  AND apt02 = g_apf.apf03
            END IF
            IF cl_null(m_aph.aph041) THEN
               LET m_aph.aph041 = g_aps.aps221
            END IF
         END IF

        #FUN-C90044--add--end-by xuxz
        #LET m_aph.aph04 = g_aps.aps22
        #LET m_aph.aph041 = g_aps.aps221
         LET m_aph.aph13 = g_apf.apf06
         LET m_aph.aph14 = g_apf.apf07
     END IF
     #FUN-C90044--add--end
   ELSE #匯兌損失
      LET m_aph.aph03 = '5'
     #No.MOD-BC0242 --begin
      IF g_aptype <> '32' THEN
         LET m_aph.aph04 = g_aps.aps42
         LET m_aph.aph041= g_aps.aps421
      END IF
     #No.MOD-BC0242 --end
      #FUN-C90044--add--str
     IF ((diff_flag='6' OR diff_flag = '7') AND g_aptype='33') OR ((diff_flag='4' OR diff_flag = '6') AND g_aptype='32') THEN #FUN-CB0117 add--7
        #FUN-CB0117----add----str
         IF (diff_flag='6' AND g_aptype='33') OR ((diff_flag='4'  OR diff_flag = '6') AND g_aptype='32') THEN
            LET m_aph.aph03 = 'E'
         END IF
         IF diff_flag='7' AND g_aptype='33' THEN
            LET m_aph.aph03 = 'H'
         END IF
         #FUN-CB0117--add----end
       #LET m_aph.aph03 = 'E'     #FUN-CB0117 mark
        LET m_aph.aph22 = g_apz.apz66
        LET m_aph.aph13 = g_apf.apf06
        LET m_aph.aph14 = g_apf.apf07
        IF g_apz.apz13 = 'N' THEN
        SELECT apt04 INTO m_aph.aph04 FROM apt_file
          WHERE apt01 = m_aph.aph22
        ELSE
          SELECT apt04 INTO m_aph.aph04 FROM apt_file
           WHERE apt01 = m_aph.aph22
             AND apt02 = g_apf.apf03
        END IF
        IF cl_null(m_aph.aph04) THEN
           LET m_aph.aph04 = g_aps.aps61
        END IF
        IF g_aza.aza63 = 'Y' THEN
           IF g_apz.apz13 = 'N' THEN
              SELECT apt041 INTO m_aph.aph041 FROM apt_file
               WHERE apt01 = m_aph.aph22
           ELSE
              SELECT apt041 INTO m_aph.aph041 FROM apt_file
               WHERE apt01 = m_aph.aph22
                 AND apt02 = g_apf.apf03
           END IF
           IF cl_null(m_aph.aph041) THEN
              LET m_aph.aph041 = g_aps.aps611
           END IF
         END IF
     END IF

     #FUN-C90044--add--end
   END IF
   
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = m_aph.aph13 
   CALL cl_digcut(m_aph.aph05,g_azi04) RETURNING m_aph.aph05       #MOD-B10116 mod t_azi04 -> g_azi04
  #CALL cl_digcut(m_aph.aph05f,t_azi04) RETURNING m_aph.aph05f     #MOD-B10116 mod g_azi04 -> t_azi04 #TQC-B30175 mark
   #FUN-C90044--add--str
   IF ((diff_flag='6' OR diff_flag = '7') AND g_aptype='33') OR ((diff_flag='4' OR diff_flag = '6') AND g_aptype='32') THEN #FUN-CB0117 add--7
       LET m_aph.aph05f = m_aph.aph05 / g_apf.apf07
       CALL cl_digcut(m_aph.aph05f,t_azi04) RETURNING m_aph.aph05f
   END IF
   #FUN-C90044--add--end
   IF m_aph.aph05 = 0 THEN RETURN END IF  #TQC-B30175

   SELECT MAX(aph02)+1 INTO m_aph.aph02 FROM aph_file
         WHERE aph01=g_apf.apf01
   IF STATUS OR m_aph.aph02 IS NULL THEN
      IF m_aph.aph03='5' THEN LET m_aph.aph02 = 1 ELSE LET m_aph.aph02 = 5 END IF
   END IF
   LET m_aph.aphlegal = g_legal

   INSERT INTO aph_file VALUES(m_aph.*)
   IF STATUS THEN
      CALL cl_err3("ins","aph_file",m_aph.aph01,m_aph.aph02,STATUS,"","ins aph",1)
      LET g_success ='N'
   END IF   

END FUNCTION
#CHI-AA0003 add --end-- 
#No.TQC-B80079 --begin 
FUNCTION t310_del_tmp_pay(m_apf)
DEFINE m_apf  RECORD LIKE apf_file.*
DEFINE l_apa  RECORD LIKE apa_file.* 
DEFINE p_apa  DYNAMIC ARRAY OF RECORD
              apa01     LIKE apa_file.apa01,
              apa35     LIKE apa_file.apa35,
              apa35f    LIKE apa_file.apa35f    
              END RECORD  
DEFINE i,l_cnt      LIKE type_file.num5

    DECLARE t310_tmp_apc CURSOR FOR                                                                                          
      SELECT apa01,apa35,apa35f FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'                                                     

    LET i=1                                                                                                                 
    FOREACH t310_tmp_apc INTO p_apa[i].apa01,p_apa[i].apa35,p_apa[i].apa35f                                                                                 
       IF p_apa[i].apa35f > 0 OR p_apa[i].apa35 > 0 THEN 
           CALL cl_err('','aap-914',0)
           LET g_success = 'N'
           RETURN
       END IF 
       LET i=i+1                                                                                                           
    END FOREACH                                                                                                             
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM apa_file
     WHERE apa08=m_apf.apf01 AND apa00='24'
    IF l_cnt > 0 THEN
       DELETE FROM apa_file WHERE apa08=m_apf.apf01 AND apa00='24'
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          LET g_success = 'N'
          CALL s_errmsg('apf01',m_apf.apf01,"del apa_file:t310_tmp_pay",SQLCA.sqlcode,1) #CHI-A60034
       END IF
       IF SQLCA.sqlcode=0 THEN
          FOR i=1 TO p_apa.getLength()
             IF cl_null(p_apa[i].apa01) THEN CONTINUE FOR END IF                                                                      
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM apc_file
              WHERE apc01=p_apa[i].apa01
             IF l_cnt > 0 THEN
                DELETE FROM apc_file WHERE apc01=p_apa[i].apa01                                                                       
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023                                             
                   CALL s_errmsg('apa01',p_apa[i].apa01,"del apc_file",SQLCA.sqlcode,1) #CHI-A60034
                   LET g_success = 'N'   #FUN-890128
                END IF                                                                                                             
             END IF   #MOD-870048 add
          END FOR                
       END IF                                                                                                 
    END IF   #MOD-870048 add
  
END FUNCTION 
#No.TQC-B80079 --end 

#FUN-C90122--add--str--
FUNCTION t310_upd_nmd55(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_aph01    LIKE aph_file.aph01,
          l_aph02    LIKE aph_file.aph02,
          l_aph04    LIKE aph_file.aph04,
          l_aph05f   LIKE aph_file.aph05f,
          l_apf02    LIKE apf_file.apf02,
          l_sql      STRING

   LET l_sql="SELECT aph02,aph04,aph05f FROM aph_file ",
             " WHERE aph01='",g_apf.apf01,"'",
             "   AND aph03='F'"
   PREPARE sel_aph_pr FROM l_sql
   DECLARE sel_aph_cr CURSOR FOR sel_aph_pr
   FOREACH sel_aph_cr INTO l_aph02,l_aph04,l_aph05f
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF p_cmd='Y' THEN
         UPDATE nmd_file SET nmd55=nmd55+l_aph05f,
                             nmd10=g_apf.apf01,
                             nmd101=l_aph02
         WHERE nmd01=l_aph04
      ELSE
         #判斷該支票是否用於多次付款，如果沒有更新付款單號和項次為NULL，
         #否則更新為日期除此單號最大付款日期的單號和項次
         LET l_apf02=NULL
         SELECT MAX(apf02) INTO l_apf02 FROM apf_file,aph_file
          WHERE apf01=aph01 AND aph04=l_aph04
            AND apf41='Y'   AND apf01<> g_apf.apf01
         IF cl_null(l_apf02) THEN
            UPDATE nmd_file SET nmd55=nmd55-l_aph05f,
                                nmd10=NULL,
                                nmd101=NULL
            WHERE nmd01=l_aph04
         ELSE
            SELECT aph01,aph02 INTO l_aph01,l_aph02 FROM apf_file,aph_file
            WHERE apf01=aph01 AND aph04=l_aph04 AND apf02=l_apf02
              AND apf41='Y'   AND apf01<> g_apf.apf01
            UPDATE nmd_file SET nmd55=nmd55-l_aph05f,
                                nmd10=l_aph01,
                                nmd101=l_aph02
            WHERE nmd01=l_aph04
         END IF
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","nmd_file",l_aph04,"",STATUS,"","",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-C90122--add--end
#No.FUN-CB0066 --begin
FUNCTION t310_multi_apg04()	
DEFINE tok          base.StringTokenizer			
DEFINE tok1         base.StringTokenizer
DEFINE i            LIKE type_file.num5 
DEFINE l_str        STRING

   LET tok = base.StringTokenizer.create(g_multi_apg04,"|")
   LET l_str = NULL  
   LET g_multi_wc = NULL        	
   WHILE tok.hasMoreTokens()			
      LET l_str = tok.nextToken()
      LET l_str = cl_replace_str(l_str,",","' AND apc02 ='")
      IF cl_null(g_multi_wc) THEN 
         LET g_multi_wc = " (apc01 = '",l_str,"')"
      ELSE 
         LET g_multi_wc = g_multi_wc,"  OR (apc01 = '",l_str,"')"
      END IF 
   END WHILE 
   IF NOT cl_null(g_multi_wc) THEN 
   	  LET g_multi_wc = '(',g_multi_wc,')'
   	  CALL t310_g_b()
   END IF 
#   LET g_multi_wc = NULL              #No.TQC-D10069 
#   LET g_multi_apg04 = NULL           #No.TQC-D10069
END FUNCTION 
#No.FUN-CB0066 --end

#FUN-CB0065--add--str--
FUNCTION t310_chk_aph04()
DEFINE l_apa06     LIKE apa_file.apa06,
       l_apa13     LIKE apa_file.apa13,
       l_apa14     LIKE apa_file.apa14,
       l_apa36     LIKE apa_file.apa36,
       l_apa08     LIKE apa_file.apa08,
       l_amt1      LIKE apa_file.apa31,
       l_amt2      LIKE apa_file.apa31,
       l_apa41     LIKE apa_file.apa41,
       l_apa42     LIKE apa_file.apa42
       
   SELECT apa06,apa13,apa14,apa36,apa08,apa31f-apa35f,apa31-apa35,apa41,apa42
   INTO l_apa06,l_apa13,l_apa14,l_apa36,l_apa08,l_amt1,l_amt2,l_apa41,l_apa42
   FROM apa_file WHERE apa00='25' AND apa01=g_aph[l_ac].aph04
   LET g_errno = ''
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno ='mfg-044'
      WHEN l_apa41<>'Y' LET g_errno ='aap-141'
      WHEN l_apa42='Y' LET g_errno ='aap-165'
      WHEN l_apa06<>g_aph[l_ac].aph26 LET g_errno = 'aap-173'
      WHEN cl_null(l_amt1) OR l_amt1=0 LET g_errno = 'aap-076'
   END CASE
   IF cl_null(g_errno) THEN
      LET g_aph[l_ac].aph13=l_apa13
      LET g_aph[l_ac].aph14=l_apa14
      LET g_aph[l_ac].aph22=l_apa36
      LET g_aph[l_ac].aph05f=l_amt1
      LET g_aph[l_ac].aph05=l_amt2
      SELECT apa64 INTO g_aph[l_ac].aph07 FROM apa_file WHERE apa01=l_apa08
   END IF
END FUNCTION

FUNCTION t310_upd_apa(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_aph02    LIKE aph_file.aph02,
          l_aph04    LIKE aph_file.aph04,
          l_aph05f   LIKE aph_file.aph05f,
          l_aph05    LIKE aph_file.aph05,
          l_sql      STRING

   LET l_sql="SELECT aph02,aph04,aph05f,apa05 FROM aph_file ",
             " WHERE aph01='",g_apf.apf01,"'",
             "   AND aph03='G'"
   PREPARE sel_aph_pr2 FROM l_sql
   DECLARE sel_aph_cr2 CURSOR FOR sel_aph_pr2
   FOREACH sel_aph_cr2 INTO l_aph02,l_aph04,l_aph05f,l_aph05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','FOREACH',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF p_cmd='Y' THEN
         UPDATE apa_file SET apa35f=apa35f+l_aph05f,
                             apa35=apa35+l_aph05
         WHERE apa00='25' AND apa01=l_aph04
      ELSE
         UPDATE apa_file SET apa35f=apa35f-l_aph05f,
                             apa35=apa35-l_aph05
         WHERE apa00='25' AND apa01=l_aph04
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg("upd","apa_file",l_aph04,STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-CB0065--add--end


