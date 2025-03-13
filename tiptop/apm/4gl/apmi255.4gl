# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi255.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 97/08/21 By Kitty
# Modify.........: sma841採購單價取價方式新增 '5'(依核價單價)
# Modify.........: 00/04/06 By Carol:料號可輸入MISC,品名,規格須存檔
#                                    pmj_file add 2 fields:pmj031,pmj032
# Modify.........: 01/08/03 By Carol:add 作廢功能
# Modify.........: No:7745 03/08/06 By Mandy menu1,menu2少了1.分量計價資料...
# Modify.........: No:7904 03/08/27 By Mandy 自動由詢價單轉入產生單身(FUNCTION i255_b_g)中之g_cnt重覆使用致使產生單
#                  身資料時出現資料重覆之訊息
# Modify.........: No.MOD-480231 04/08/10 By Wiky copy段會hold住
# Modify.........: No.MOD-480339 04/08/18 By Wiky 新增圖show
# Modify.........: No.MOD-490280 04/09/16 Melody 新增第二張以上單據時，由單頭至單身新增時會SHOW 100找不到資料的問題
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4A0069 04/10/11 By Echo 查詢時,核假單號應開窗出以核價單號而不是單據別
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4A0344 04/11/19 By Echo 若為要做簽核的單別,在做完easyflow簽核後,要show出紅色字的核!
# Modify.........: No.MOD-4B0197 04/11/19 By Mandy 複製時要一併複製分量計價檔
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0266 04/11/30 By Carol 查詢時單身料號,幣別,作業編號加^P放大鏡功能
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-4C0041 04/12/13 By Echo  查看"簽核狀況"的button
# Modify.........: No.MOD-530570 05/03/30 By Mandy 詢價單已作廢,還可以代入核價單中-->NG
# Modify.........: No.MOD-530582 05/03/30 By Mandy 單身輸入後的附畫面(i255a_w),廠牌編號沒有勾稽,與apmi254控管邏輯不同(請一併提供開窗功能)
# Modify.........: No.MOD-530602 05/03/30 By Mandy 分量計價時,'已有單身資料,不可變更'-->請設定成,已有單身資料,於'更改'模式下,不可進入分量計價欄位,以免造成操作誤導
# Modify.........: No.MOD-530613 05/03/30 By Mandy 分量計價時,單據確認後,再按'分量計價資料'-->選定項次後-->不須要pop視窗告知'已確認,不可以更改或取消!',可能誤導客戶
# Modify.........: No.MOD-530616 05/03/30 By Mandy 在apmi255的'供應商基本資料維護'功能,可直接傳參數到apmi600查詢單據供應商資料(須考慮權限控管)
# Modify         : No.MOD-4A0299 05/04/20 by Echo 複製功能，無判斷單別是否簽核,狀況碼改為combobox
#                                                 將確認與簽核流程程式段拆開
# Modify.........: No.FUN-550019 05/04/27 By Danny 採購含稅單價
# Modify.........: No.MOD-540202 05/05/02 By kim 分配比例欄位可輸入
# Modify.........: No.MOD-540067 05/05/05 By Mandy 分量計價='N'時,無法確認,因為確認的控管有問題
# Modify.........: No.FUN-550060 05/05/27 By Will 單據編號放大
# Modify.........: No.MOD-560007 05/06/02 By Echo 重新定義整合FUN名稱
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify         : No.MOD-560117 05/06/20 by Echo 單頭輸入勾選分量計價, 至單身輸完分量計價即down出
# Modify.........: No.FUN-560193 05/06/28 By kim 單身 '廠商料號' 之後增秀 '採購單位','計價單位'
# Modify.........: No.MOD-570056 05/07/05 By kim 查詢時,不檢核廠商編號是否為待核准
# Modify.........: No.MOD-570060 05/07/05 By kim 不可交易的供應商控管不可複製
# Modify.........: No.MOD-570057 05/07/05 By kim 廠商輸入後的檢核有漏洞
# Modify.........: No.FUN-560204 05/07/05 By kim 單身原核准日控管不可修改
# Modify         : No.MOD-560139 05/08/08 By Rosayu apmi255 (A18,1402-050600004單身廠商料號輸入後,查詢時未顯示出來) OK
# Modify.........: No.MOD-560241 05/07/22 By echo 若單頭選擇做分量計價, 則單身於幣別輸入完畢後, 不會自動開出分量計價的窗可讓USER輸入
# Modify.........: No.FUN-580120 05/08/24 By yiting 以 EF 為 backend engine, 由TIPTOP 處理前端簽核動作
# Modify.........: No.MOD-590361 05/09/19 By echo g_cmd此變數未宣告至足夠長度
# Modify.........: NO.MOD-590519 05/09/30 BY yiting 輸入單身時,CALL i255_pmj03_add()會開畫面i255a_w,KEY IN完資料後,此i255a_w視窗沒有馬上被關閉
# Modify.........: NO.MOD-5A0216 05/10/20 BY Nicola 單身沒資料時,列印秀訊息提示"沒有單身可以列印"
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-5C0071 05/12/23 By Sarah i255_b_g()的pmw01開窗改為q_pmw01
# Modify.........: No.FUN-610018 06/01/05 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.FUN-630044 06/03/16 By Alexstar 新增「申請人」欄位
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-640068 06/04/08 By Joe 單身由(2)詢價單轉入，可開窗查詢詢價單號
# Modify.........: No.MOD-640441 06/04/19 By Sarah 1.單身詢價單開窗改q_pmw02
#                                                  2.當單身有資料時,不可修改單頭分量計價欄位
#                                                  3.單身增加一ACTION"分量計價資料",當單身已有輸入分量計價資料時,再進入單身不用自動彈出分量計價畫面
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660099 06/08/07 By Nicola 價格管理修改-新增欄位作業編號，用傳參數的方式決定採購委外
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-650191 06/11/08 By rainy  pmw03<--改抓 pmx12
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6B0005 06/11/24 By claire 輸入廠商後按確認只帶出稅別沒帶出稅率
# Modify.........: No.TQC-690126 06/12/08 By pengu 原單價取得來源，應為「已確認」的核價檔。(非抓 pmh_file)
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.MOD-710094 07/01/17 By jamie 更改稅別時，新未稅及新含稅金額需重新計算
#                                                  更改稅別時，若為分量計價也需重新計算
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740041 07/04/11 By Nicola 單身從詢價單轉入時，加入價格型態條件
# Modify.........: No.TQC-740113 07/04/18 By jacklai 將 CALL aws_gpmcli_toolbar() 移至 CALL aws_efapp_toolbar() 後面才呼叫
# Modify.........: No.TQC-740122 07/04/18 By jacklai 將EasyFlow使用的ARG參數往後移
# Modify.........: No.TQC-740117 07/04/19 By rainy GP5.0整合測試問題
# Modify.........: No.TQC-740144 07/04/22 By dxfwo 修改資料已審核，作廢無相應提示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760034 07/06/06 By rainy 分量計價開 apmi255c時，單頭資料未顯示
# Modify.........: No.MOD-780186 07/08/20 By kim 核價單身維護時,未預設分配比率(apmi255a)
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.MOD-790163 07/09/29 By claire 複制時,單據未取號造成-239錯誤
# Modify.........: No.MOD-7A0085 07/10/17 By Carol 單身無資料時,單頭資料應不可留
# Modify.........: No.TQC-7B0089 07/11/15 By lumxa  apmi255&apmi265.dbo.pmj_file r l件 ]有考 ]新增加的key值字段pmj10,pmj12,這樣會導致問題
# Modify.........: No.TQC-810025 08/01/08 By lumxa  在程序apmi254 apmi255 apmi258中增加了新增的key值的 在修改單身時 key值賦值錯誤
# Modify.........: No.FUN-810017 08/01/08 By jan 新增服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.MOD-810082 08/03/20 By claire apmi255會查出apmi265的資料
# Modify.........: No.FUN-830114 08/03/31 By jan 若料件編號字段輸入的是多屬性的分段定價資料且不存在于ima_file中             
#                                                那麼單身輸入料號后需帶出的默認資料
# Modify.........: No.MOD-840074 08/04/10 By Dido 抓取 pmh_file 時應用完整 key 值
# Modify.........: NO.FUN-880016 08/08/21 BY yiting 增加GPM控管
# Modify.........: NO.FUN-870124 08/09/23 BY jan 服飾作業修改
# Modify.........: No.MOD-880193 08/08/25 By chenl  增加pmj10變量判斷，若為空，則賦值為空格(' ')
# Modify.........: No.FUN-8A0054 08/10/13 By sabrina 若沒有勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.CHI-880028 08/10/13 By xiaofeizhu 新增欄位價格型態pmi10
# Modify.........: No.MOD-8B0235 08/11/24 By chenyu pmh11增加控管
# Modify.........: No.TQC-8C0068 08/12/24 By Smapmin 調整Drop table的執行時機
# Modify.........: No.MOD-910036 09/01/12 By Smapmin 修正幣別位數取位問題
# Modify.........: No.MOD-910185 09/01/16 By Smapmin 單身筆數計算錯誤
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920027 09/02/03 By sherry 1、審核和取消審核以后更新最近更改者和最近更改日
#                                                   2、新增的時候不應寫入最近更改者
# Modify.........: No.MOD-920024 09/02/03 By Smapmin 廠商性質需為1|3類
# Modify.........: No.FUN-920106 09/02/20 By sabrina (1)將確認段移出至apmi255_sub (2)apmi265與EasyFlow整合
# Modify.........: No.MOD-930125 09/03/12 By rainy 在after insert後再加一段檢查（同料號，作業編號，幣別，單價），若相同則show error
# Modify.........: No.TQC-930072 09/03/25 By chenyu 單身加了key單元編號，所以檢查的時候要加上
# Modify.........: No.MOD-930327 09/04/03 By Smapmin 供應商/料件對應資料若為無效,則不可輸入核價檔
# Modify.........: No.MOD-960211 09/06/22 By mike 將AND改為OR
# Modify.........: No.MOD-960182 09/07/07 By Smapmin 抓取pmj_file時,條件要多加pmj10/pmj12
# Modify.........: No.MOD-980012 09/08/03 By mike 當維護單身時選擇供應商料件查詢action無法產生認何資料，應該少傳供應商之參數。(LET g
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970093 09/07/08 By dxfwo 新增區段_a( ) 在s_auto_assign_no() 之前應該先 BEGIN WORK  不然后面的commit work 和rollback work 會出錯 -255(不在交易中) 
# Modify.........: No.MOD-980166 09/08/22 By Dido 若無單身則需一併刪除 pmr_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930061 09/09/27 By chenmoyan 增加作業名稱本單位
# Modify.........: No.FUN-9C0046 09/12/09 By chenls  (1)單身添加欄位pmj14
#                                                     (2)刪除核價單身資料時 判斷pmj14是否為空
#                                                     (3)刪除整張核價單時 判斷是否為電子採購單
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:MOD-A10179 10/01/27 By Smapmin 修改時,一直卡在單號的地方造成無窮迴圈
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-960300 10/03/05 By vealxu 1.g_t1沒有給值
#                                                   2.資料跟新時用舊值
#                                                   3.g_rec_b=g_cnt-1多餘 
#                                                   4.修改時，如果變動了單號，需一起異動pmr_file
#                                                   5.修改單身時，如果變動了項次，需一起異動到pmr_file
#                                                   6.修改單頭後，單身重新顯示     
# Modify.........: No.FUN-A10043 10/03/15 By Lilan 從EasyFlow端簽核時可進行自動確認
# Modify.........: No.FUN-A30072 10/10/22 by jan 新增欄位pmjicd14
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-AB0025 10/11/03 By chenying 修改Sybase问题 
# Modify.........: No.TQC-AC0402 10/12/31 By destiny 复制取消时核价日期，厂商编号会变成无值
# Modify.........: No.TQC-B40215 11/04/27 By lilingyu 當為未自動確認且已核准,執行修改時會出現"agl-160"的錯誤訊息
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B60087 11/06/15 By Summer 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-B80231 11/08/30 By guoch 资料建立者，资料建立部门查询时无法下条件
# Modify.........: No:TQC-BA0191 11/11/01 By destiny p_wc长度不够
# Modify.........: No:MOD-C10044 12/01/05 By Vampire 核價單號開窗查詢時，應區隔委外及非委外的核價單
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C30161 12/03/10 By yuhuabao 出現項次為0的數據
# Modify.........: No:MOD-C30260 12/03/10 By zhuhao 由詢價單轉入時(i255_b_g)，項次pmj02，改用MAX加1，不要用變數直接累加
# Modify.........: No:MOD-C30482 12/03/13 By dongsz 單身未輸入資料，取消單頭的同時，應刪除單頭，并清空單頭
# Modify.........: No:FUN-C30293 12/03/29 By Abby 執行[單身],按"確定",狀況碼變成0.開立
# Modify.........: No:TQC-C40022 12/04/06 By suncx 錄入供應商時，帶出的稅種不存在，應清空稅種重新錄入
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90034 12/10/22 By Nina  還原 MOD-920027 確認,取消確認時需要更新最近更改者和最近更改日的調整
# Modify.........: No.MOD-CA0057 12/11/08 By SunLM  虛擬料件不得進行核價
# Modify.........: No:CHI-C10008 13/02/01 By Elise 單身新增時,幣別預設廠商慣用幣別pmc22
# Modify.........: No.CHI-C80041 13/02/06 By bart 無單身刪除單頭
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D50104 13/05/30 By lixiang 單身默認作業編號和單元編號欄位可不輸入；底色設置同一般欄位，防止誤輸入
# Modify.........: No:TQC-D50088 13/07/15 By qirl  [是否使用電子採購系統]='N'時，不顯示[電子採購序號]欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmi           RECORD LIKE pmi_file.*,
    g_pmi_t         RECORD LIKE pmi_file.*,
    g_pmi_o         RECORD LIKE pmi_file.*,
    g_pmi01_t       LIKE pmi_file.pmi01,    #簽核等級 (舊值)
    g_t1            LIKE oay_file.oayslip,  #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
    l_cnt           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    g_pmj           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        pmj02       LIKE pmj_file.pmj02,   #項次
        pmj03       LIKE pmj_file.pmj03,   #料件編號
        pmj031      LIKE pmj_file.pmj031,  #品名規格
        pmj032      LIKE pmj_file.pmj032,  #規格
        pmj11       LIKE pmj_file.pmj11,   #工艺说明  
        pmj04       LIKE pmj_file.pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193
        ima908      LIKE ima_file.ima908,  #FUN-560193
        pmj10       LIKE pmj_file.pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        pmj13       LIKE pmj_file.pmj13,   #單元編號 No.FUN-810017
        pmjicd14    LIKE pmj_file.pmjicd14,  #FUN-A30072
        pmj05       LIKE pmj_file.pmj05,   #幣別
        pmj06       LIKE pmj_file.pmj06,   #原單價
        pmj06t      LIKE pmj_file.pmj06t,  #原含稅單價     No.FUN-550019
        pmj07       LIKE pmj_file.pmj07,   #新單價
        pmj07t      LIKE pmj_file.pmj07t,  #新含稅單價     No.FUN-550019
        pmj08       LIKE pmj_file.pmj08,   #原核准日
        pmj09       LIKE pmj_file.pmj09,   #新核准日
        pmj14       LIKE pmj_file.pmj14    #電子採購序號   No.FUN-9C0046 ---add
        #darcy:2023/07/29  s---
        ,ta_pmj01    LIKE pmj_file.ta_pmj01,
        ta_pmj02     LIKE pmj_file.ta_pmj02,
        ta_pmj03     LIKE pmj_file.ta_pmj03,
        ta_pmj04     LIKE pmj_file.ta_pmj04,
        ta_pmj05     LIKE pmj_file.ta_pmj05,
        ta_pmj06     LIKE pmj_file.ta_pmj06,
        ta_pmj07     LIKE pmj_file.ta_pmj07,
        ta_pmj08     LIKE pmj_file.ta_pmj08,
        ta_pmj09     LIKE pmj_file.ta_pmj09,
        ta_pmj10     LIKE pmj_file.ta_pmj10,
        ta_pmj11     LIKE pmj_file.ta_pmj11,
        ta_pmj12     LIKE pmj_file.ta_pmj12,
        ta_pmj13     LIKE pmj_file.ta_pmj13,
        ta_pmj14     LIKE pmj_file.ta_pmj14,
        ta_pmj15     LIKE pmj_file.ta_pmj15
        #darcy:2023/07/29  e---
                    END RECORD,
    g_pmj_t         RECORD                 #程式變數 (舊值)
        pmj02       LIKE pmj_file.pmj02,   #項次
        pmj03       LIKE pmj_file.pmj03,   #料件編號
        pmj031      LIKE pmj_file.pmj031,  #品名規格
        pmj032      LIKE pmj_file.pmj032,  #規格
        pmj11       LIKE pmj_file.pmj11,   #工艺说明
        pmj04       LIKE pmj_file.pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193   
        ima908      LIKE ima_file.ima908,  #FUN-560193
        pmj10       LIKE pmj_file.pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        pmj13       LIKE pmj_file.pmj13,   #單元編號 No.FUN-810017
        pmjicd14    LIKE pmj_file.pmjicd14,  #FUN-A30072
        pmj05       LIKE pmj_file.pmj05,   #幣別
        pmj06       LIKE pmj_file.pmj06,   #原單價
        pmj06t      LIKE pmj_file.pmj06t,  #原含稅單價     No.FUN-550019
        pmj07       LIKE pmj_file.pmj07,   #新單價
        pmj07t      LIKE pmj_file.pmj07t,  #新含稅單價     No.FUN-550019
        pmj08       LIKE pmj_file.pmj08,   #原核准日
        pmj09       LIKE pmj_file.pmj09,   #新核准日
        pmj14       LIKE pmj_file.pmj14    #電子採購序號   No.FUN-9C0046 ---add
        #darcy:2023/07/29  s---
        ,ta_pmj01    LIKE pmj_file.ta_pmj01,
        ta_pmj02     LIKE pmj_file.ta_pmj02,
        ta_pmj03     LIKE pmj_file.ta_pmj03,
        ta_pmj04     LIKE pmj_file.ta_pmj04,
        ta_pmj05     LIKE pmj_file.ta_pmj05,
        ta_pmj06     LIKE pmj_file.ta_pmj06,
        ta_pmj07     LIKE pmj_file.ta_pmj07,
        ta_pmj08     LIKE pmj_file.ta_pmj08,
        ta_pmj09     LIKE pmj_file.ta_pmj09,
        ta_pmj10     LIKE pmj_file.ta_pmj10,
        ta_pmj11     LIKE pmj_file.ta_pmj11,
        ta_pmj12     LIKE pmj_file.ta_pmj12,
        ta_pmj13     LIKE pmj_file.ta_pmj13,
        ta_pmj14     LIKE pmj_file.ta_pmj14,
        ta_pmj15     LIKE pmj_file.ta_pmj15
        #darcy:2023/07/29  e---
                    END RECORD,
    g_pmj_o         RECORD                 #程式變數 (舊值)
        pmj02       LIKE pmj_file.pmj02,   #項次
        pmj03       LIKE pmj_file.pmj03,   #料件編號
        pmj031      LIKE pmj_file.pmj031,  #品名規格
        pmj032      LIKE pmj_file.pmj032,  #規格
        pmj11       LIKE pmj_file.pmj11,   #工艺说明
        pmj04       LIKE pmj_file.pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193  
        ima908      LIKE ima_file.ima908,  #FUN-560193
        pmj10       LIKE pmj_file.pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        pmj13       LIKE pmj_file.pmj13,   #單元編號 No.FUN-810017
        pmjicd14    LIKE pmj_file.pmjicd14,  #FUN-A30072
        pmj05       LIKE pmj_file.pmj05,   #幣別
        pmj06       LIKE pmj_file.pmj06,   #原單價
        pmj06t      LIKE pmj_file.pmj06t,  #原含稅單價     No.FUN-550019
        pmj07       LIKE pmj_file.pmj07,   #新單價
        pmj07t      LIKE pmj_file.pmj07t,  #新含稅單價     No.FUN-550019
        pmj08       LIKE pmj_file.pmj08,   #原核准日
        pmj09       LIKE pmj_file.pmj09,   #新核准日
        pmj14       LIKE pmj_file.pmj14    #電子採購序號   No.FUN-9C0046 ---add
        #darcy:2023/07/29  s---
        ,ta_pmj01    LIKE pmj_file.ta_pmj01,
        ta_pmj02     LIKE pmj_file.ta_pmj02,
        ta_pmj03     LIKE pmj_file.ta_pmj03,
        ta_pmj04     LIKE pmj_file.ta_pmj04,
        ta_pmj05     LIKE pmj_file.ta_pmj05,
        ta_pmj06     LIKE pmj_file.ta_pmj06,
        ta_pmj07     LIKE pmj_file.ta_pmj07,
        ta_pmj08     LIKE pmj_file.ta_pmj08,
        ta_pmj09     LIKE pmj_file.ta_pmj09,
        ta_pmj10     LIKE pmj_file.ta_pmj10,
        ta_pmj11     LIKE pmj_file.ta_pmj11,
        ta_pmj12     LIKE pmj_file.ta_pmj12,
        ta_pmj13     LIKE pmj_file.ta_pmj13,
        ta_pmj14     LIKE pmj_file.ta_pmj14,
        ta_pmj15     LIKE pmj_file.ta_pmj15
        #darcy:2023/07/29  e---
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_bc        LIKE type_file.num5,   #No.FUN-680136 SMALLINT  #單身筆數(分量計價)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    g_sta           LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
    g_gec07         LIKE gec_file.gec07,   #No.Fun-550019
    tm              RECORD
                    wc    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
                    END RECORD,
    g_message       LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
 
DEFINE g_argv1         LIKE pmi_file.pmi01    #核價單號.  #FUN-580120
DEFINE g_argv4         LIKE pmi_file.pmi01    #核價單號.  #FUN-580120
DEFINE g_argv2           STRING               #指定執行的功能 #TQC-630074
DEFINE g_laststage   LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)                    #FUN-580120
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_chr          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_chr2         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_chr3         LIKE type_file.chr1    #FUN-580120  #No.FUN-680136 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_cnt1         LIKE type_file.num10   #MOD-710094 add
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_no_ask      LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_cmd          LIKE type_file.chr1000 #MOD-530616    #MOD-590361  #No.FUN-680136 VARCHAR(300)
DEFINE g_tmp01        LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_tmp_file     STRING
DEFINE g_argv3        LIKE pmj_file.pmj12  #No.FUN-670099
DEFINE g_pmj12        LIKE pmj_file.pmj12  #No.FUN-670099
DEFINE g_pmi10        LIKE pmi_file.pmi10  #No.CHI-880028
DEFINE g_buf          string               #No.TQC-9A0145
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF
  
   LET g_argv3 = ARG_VAL(1)   #No.TQC-740122 LET g_argv3=ARG_VAL(3) 
   LET g_argv1 = ARG_VAL(2)
   LET g_argv2 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
   
   IF g_argv3 = "1" THEN
      LET g_prog="apmi255"
      LET g_pmj12 = "1"
   ELSE
      LET g_prog="apmi265"
      LET g_pmj12= "2"
   END IF 
   LET g_pmi10=g_pmj12                   #No.CHI-880028 Add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM pmi_file WHERE pmi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i255_cl CURSOR FROM g_forupd_sql
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
    
        OPEN WINDOW i255_w WITH FORM "apm/42f/apmi255"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
        CALL cl_set_locale_frm_name("apmi255")   #No.FUN-670099
        CALL cl_ui_init()
    
        IF g_pmj12 = "1" THEN
            CALL cl_set_comp_visible("pmj10,ecd02,ecbud02",FALSE)#No.FUN-930061 add ecd02 #add ecbud02 by guanyao160730
        END IF


        #FUN-A30072--begin--add----------------
        IF g_pmj12 = '1' OR NOT s_industry('icd') THEN
           CALL cl_set_comp_visible("pmjicd14",FALSE)
        END IF
        IF g_pmj12 = '2' AND s_industry('icd') THEN
           CALL cl_set_comp_required("pmjicd14",TRUE)
        END IF
        #FUN-A30072--end--add------------------

        IF g_pmj12 = "1" THEN
            CALL cl_set_comp_visible("pmj13",FALSE)
        END IF

        #TQC-D50088---add--begin-------------
        IF g_aza.aza95 = 'N' THEN
           CALL cl_set_comp_visible("pmj14",FALSE)
        END IF
        #TQC-D50088---add--end---------------

        #FUN-D50104--add-begin--
        IF g_pmj12 = "2" THEN
           CALL cl_set_comp_bgcolor("pmj10,pmj13", "achromatism")#背景色設置成無色
        END IF
        #FUN-D50104--add-end--
    
    END IF
 
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580120
    
   #將aws_gpmcli_toolbar()移到aws_efapp_toolbar()之後
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       IF g_aza.aza71 MATCHES '[Yy]' THEN 
          CALL aws_gpmcli_toolbar()
          CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
       ELSE
          CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
       END IF
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i255_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i255_a()
            END IF
         WHEN "efconfirm"
            LET g_action_choice = "efconfirm"        #FUN-A10043 add
            CALL i255_q()
            CALL apmi255sub_y_chk(g_pmi.pmi01)          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL apmi255sub_y_upd(g_pmi.pmi01, g_action_choice, g_pmj12,false)    #CALL 原確認的 update 段 #darcy:2023/06/12 add p_transaction
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL i255_q()
 
      END CASE
   END IF
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, #FUN-D20025 mark
   #locale, void, confirm, undo_confirm,easyflow_approval") #FUN-D20025 mark
   #FUN-D20025 add
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, 
   locale, void, undo_void, confirm, undo_confirm,easyflow_approval")
   #FUN-D20025 add 
          RETURNING g_laststage
 
   IF (g_sma.sma116 MATCHES '[02]') THEN   #No.FUN-610076
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
 
   CALL i255_menu()
   CLOSE WINDOW i255_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i255_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
IF NOT cl_null(g_argv1) THEN
   # LET g_wc = " pmi01 = '",g_argv1,"'"  #FUN-580120 #darcy:2023/06/02 remark 
   LET g_wc = " pmi01 between '",g_argv1,"' and '",g_argv4,"' "   #FUN-580120 #darcy:2023/06/02 add
   LET g_wc2= ' 1=1'
ELSE
 
   CLEAR FORM                             #清除畫面
   CALL g_pmj.clear()
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmi.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON pmi01,pmi02,pmi09,pmi03,pmi08,pmi081,pmi04, #FUN-630044
                             pmi05,pmi07,pmi06,
                             pmiconf,pmiuser,pmigrup,pmimodu,pmidate,pmiacti,
                             pmioriu,pmiorig   #TQC-B80231  add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION controlp
         CASE
 
            WHEN INFIELD(pmi01) #核價單號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_pmi"
               LET g_qryparam.default1 = g_pmi.pmi01
               LET g_qryparam.where = " pmi10 ='",g_pmi10,"'" #MOD-C10044 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi01
               NEXT FIELD pmi01
 
            WHEN INFIELD(pmi09) #申請人
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi09
               NEXT FIELD pmi09
 
            WHEN INFIELD(pmi03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_pmi.pmi03
               CALL cl_create_qry() RETURNING g_pmi.pmi03
               DISPLAY BY NAME g_pmi.pmi03
               CALL i255_pmi03('d')
               NEXT FIELD pmi03
            WHEN INFIELD(pmi08)   #稅別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " gec011='1' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmi08
                 NEXT FIELD pmi08
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
		#No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED," AND pmi10 ='",g_pmi10,"'"         #No.CHI-880028 Add
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
 
 
   CONSTRUCT g_wc2 ON pmj02,pmj03,pmj031,pmj032,pmj11,pmj04,pmj10,pmjicd14,pmj05,		 #FUN-A30072
                      pmj06,pmj06t,pmj07,pmj07t,    #No.FUN-550019
                      pmj08,pmj09,pmj13,pmj14             #No.FUN-810017 Add pmj13
           FROM s_pmj[1].pmj02,s_pmj[1].pmj03,s_pmj[1].pmj031,s_pmj[1].pmj032,s_pmj[1].pmj11,
                s_pmj[1].pmj04,s_pmj[1].pmj10,s_pmj[1].pmjicd14,s_pmj[1].pmj05,	 #FUN-A30072
                s_pmj[1].pmj06,s_pmj[1].pmj06t,    #No.FUN-550019
                s_pmj[1].pmj07,s_pmj[1].pmj07t,    #No.FUN-550019
                s_pmj[1].pmj08,s_pmj[1].pmj09,s_pmj[1].pmj13,s_pmj[1].pmj14 #No.FUN-810017 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(pmj03) #料件編號
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.state ="c"
                #   LET g_qryparam.form ="q_ima"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO pmj03
                   NEXT FIELD pmj03
              WHEN INFIELD(pmj05)     #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmj05
                   NEXT FIELD pmj05
              WHEN INFIELD(pmj11)                                                                                               
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.state = 'c'                                                                                      
                LET g_qryparam.form ="q_ecb12"                                                                                    
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO pmj11                                                                            
                NEXT FIELD pmj11 
              WHEN INFIELD(pmj13)                                                                                               
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.state = 'c'                                                                                      
                LET g_qryparam.form ="q_sga"                                                                                    
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO pmj13                                                                            
                NEXT FIELD pmj13                                                                                                
              WHEN INFIELD(pmj10)     #作業編號
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmj10
                 NEXT FIELD pmj10
              OTHERWISE EXIT CASE
           END CASE
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
END IF  #FUN-580120
   IF INT_FLAG THEN
      RETURN
   END IF
 
   
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  pmi_file.pmi01 FROM pmi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pmi01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  pmi_file.pmi01 ",
                  "  FROM pmi_file, pmj_file ",
                  " WHERE pmi01 = pmj01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " AND pmj12='",g_pmj12,"'",
                  " ORDER BY pmi01"
   END IF
 
   PREPARE i255_prepare FROM g_sql
   DECLARE i255_cs                         #CURSOR
       SCROLL CURSOR WITH HOLD FOR i255_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmi_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE pmi01) FROM pmi_file,pmj_file WHERE ",
                "pmj01=pmi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " AND pmj12='",g_pmj12,"'"     #MOD-7A0085-add
   END IF
   PREPARE i255_precount FROM g_sql
   DECLARE i255_count CURSOR FOR i255_precount
 
END FUNCTION
 
FUNCTION i255_menu()
   DEFINE l_creator     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  #FUN-580120
   DEFINe l_flowuser    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)         # 是否有指定加簽人員      #FUN-580120
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   LET l_flowuser = "N"
 
   WHILE TRUE
      CALL i255_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i255_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i255_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i255_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i255_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i255_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CALL i255_b()   #mark by guanyao160525
               CALL i255_b('i') #add by guanyao160525
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i255_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "pricing_by_qty"
            IF cl_chk_act_auth() THEN
               IF g_pmi.pmi05 = 'Y' THEN
                  #控管單身未輸入資料
                  LET g_cnt=0
                  SELECT COUNT(*) INTO g_cnt
                    FROM pmj_file
                    WHERE pmj01=g_pmi.pmi01 #MOD-540067 變數寫錯,修正
                  IF g_cnt>=1 THEN
                     LET g_tmp_file = FGL_GETPID() USING '<<<<<<<<<<'
                     LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"  #MOD-560241
                     LET g_cmd = "apmi255c '",g_pmi.pmi01 CLIPPED,"' ", #MOD-530616
                                 "'", g_pmj[l_ac].pmj02, "' '", g_pmj[l_ac].pmj03 ,"' ",
                                 "'", g_pmj[l_ac].pmj031,"' '", g_pmj[l_ac].pmj032,"' ",
                                 "'", g_pmj[l_ac].pmj11,"' '", g_pmj[l_ac].pmj05, "' ",
                                 "'", g_prog CLIPPED,"' '", ##MOD-560241
                                 g_tmp_file CLIPPED,"' '",g_pmj[l_ac].pmj10,"'"  #No.FUN-670099
                     CALL cl_cmdrun_wait(g_cmd) #MOD-530612
 
                     IF g_pmi.pmiconf='N' AND g_pmi.pmi06 NOT MATCHES '[Ss]' THEN
                        LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                        PREPARE tmp_prep FROM g_sql
                        IF STATUS THEN CALL cl_err('tmp_prep:',status,1) RETURN -1 END IF
                        DECLARE tmp_curs CURSOR FOR tmp_prep
                        OPEN tmp_curs
                        FETCH tmp_curs INTO g_tmp01
 
                        IF g_tmp01 <> g_pmi.pmi06 THEN
                           UPDATE pmi_file set pmi06=g_tmp01 where pmi01= g_pmi.pmi01
                        END IF
 
                     END IF
                     LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
                     PREPARE drop_prep FROM g_sql   #TQC-8C0068
                     EXECUTE drop_prep   #TQC-8C0068
                     SELECT pmi06 INTO g_pmi.pmi06 FROM pmi_file where pmi01 = g_pmi.pmi01
                     DISPLAY BY NAME g_pmi.pmi06
                     CALL i255_pic()            #FUN-920106
                  ELSE
                     CALL cl_err('','arm-034',1)
                  END IF
               ELSE
                  #不是分量計價資料
                  CALL cl_err(g_pmi.pmi01,'apm-286',1)
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL apmi255sub_y_chk(g_pmi.pmi01)          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                   CALL apmi255sub_y_upd(g_pmi.pmi01, g_action_choice, g_pmj12,false)      #CALL 原確認的 update 段  #darcy:2023/06/12 p_transaction
                   CALL apmi255sub_refresh(g_pmi.pmi01) RETURNING g_pmi.*   #FUN-920106 重新讀取g_pmi
                   CALL i255_show()                                      #FUN-920106         
                END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i255_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL i255_x() #FUN-D20025 mark
               CALL i255_x(1) #FUN-D20025 add
            END IF
         #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
            IF cl_chk_act_auth() THEN
               CALL i255_x(2)
            END IF
         #FUN-D20025 add      
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmj),'','')
            END IF
       #@WHEN "簽核狀況"
          WHEN "approval_status"               # BUG-4C0041   #MOD-4A0299
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN
                    CALL aws_efstat2()     #MOD-560007
               END IF
            END IF
 
 #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL apmi255sub_y_upd(g_pmi.pmi01, g_action_choice, g_pmj12,false)      #CALL 原確認的 update 段 #darcy:2023/06/12 add p_transaction
                 CALL apmi255sub_refresh(g_pmi.pmi01) RETURNING g_pmi.*   #FUN-920106 重新讀取g_pmi
                 CALL i255_show()                                      #FUN-920106         
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i255_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete, reproduce, detail, query, locale,
                                void,undo_void,confirm, undo_confirm,easyflow_approval")#FUN-D20025 add undo_void
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
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_pmi.pmi06 = 'R'
                      DISPLAY BY NAME g_pmi.pmi06
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i255_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,reproduce, detail, query, locale,void,undo_void,
                                confirm, undo_confirm,easyflow_approval") #FUN-D20025 add undo_void
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
 
 
         WHEN "easyflow_approval"     #MOD-4A0299
           IF cl_chk_act_auth() THEN
               #FUN-C20026 add str---
                SELECT * INTO g_pmi.* FROM pmi_file
                 WHERE pmi01 = g_pmi.pmi01
                CALL i255_show()
                CALL i255_b_fill(' 1=1')
               #FUN-C20026 add end---
                CALL i255_ef()
                CALL i255_show()  #FUN-C20026 add
           END IF

#str---add by guanyao160525
         WHEN "price_u"
            IF cl_chk_act_auth() THEN
               CALL i255_b('p')
            END IF 
#end---add by guanyao160525
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmi.pmi01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmi01"
                 LET g_doc.value1 = g_pmi.pmi01
                 CALL cl_doc()
               END IF
         END IF
 
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmj[l_ac].pmj03 END IF
              LET l_supplierid = g_pmi.pmi03
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmj[l_ac].pmj03 END IF
              LET l_supplierid = g_pmi.pmi03
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i255_a()
DEFINE li_result LIKE type_file.num5                     #No.FUN-550060  #No.FUN-680136 SMALLINT
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pmj.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pmi.* LIKE pmi_file.*             #DEFAULT 設定
   LET g_pmi01_t = NULL
   LET g_pmi.pmi02 = g_today
   #預設值及將數值類變數清成零
   LET g_pmi_t.* = g_pmi.*
   LET g_pmi_o.* = g_pmi.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pmi.pmiuser=g_user
      LET g_pmi.pmioriu = g_user #FUN-980030
      LET g_pmi.pmiorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_pmi.pmigrup=g_grup
      LET g_pmi.pmidate=g_today
      LET g_pmi.pmi06  ='0'              #開立
      LET g_pmi.pmiacti='Y'              #資料有效
      LET g_pmi.pmi10=g_pmi10            #CHI-880028 Add
 
      LET g_pmi.pmi09=g_user                            
      CALL i255_pmi09('d')
      IF NOT cl_null(g_errno) THEN
         LET g_pmi.pmi09 = ''
      END IF
 
      LET g_pmi.pmiconf='N'              #確認碼
      LET g_pmi.pmi05  ='N'              #分量計價 NO:7178
      LET g_pmi.pmiplant = g_plant  #FUN-980006 add
      LET g_pmi.pmilegal = g_legal  #FUN-980006 add
 
      CALL i255_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_pmi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_pmi.pmi01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK               #No.TQC-970093   dxfwo  add   
      CALL s_auto_assign_no("apm",g_pmi.pmi01,g_pmi.pmi02,"5","pmi_file","pmi01","","","")
        RETURNING li_result,g_pmi.pmi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_pmi.pmi01
 
      INSERT INTO pmi_file VALUES (g_pmi.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("ins","pmi_file",g_pmi.pmi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129  #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK #No:7857
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No:7857
         CALL cl_flow_notify(g_pmi.pmi01,'I')
      END IF
 
      SELECT pmi01 INTO g_pmi.pmi01 FROM pmi_file
       WHERE pmi01 = g_pmi.pmi01
      LET g_pmi01_t = g_pmi.pmi01        #保留舊值
      LET g_pmi_t.* = g_pmi.*
      LET g_pmi_o.* = g_pmi.*
      CALL g_pmj.clear()
 
       LET g_rec_b=0  #No.MOD-490280
      #CALL i255_b()                   #輸入單身   #mark by guanyao160525
       CALL i255_b('i') #add by guanyao160525
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i255_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmi.pmi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pmi.* FROM pmi_file
    WHERE pmi01=g_pmi.pmi01
 
   #檢查資料是否已確認
   IF g_pmi.pmiconf='Y' THEN
      CALL cl_err(g_pmi.pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_pmi.pmiconf='X' THEN
      CALL cl_err(g_pmi.pmiconf,'9024',0)
      RETURN
   END IF
 
   IF g_pmi.pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmi.pmi01,'mfg1000',0)
      RETURN
   END IF
 
    IF g_pmi.pmi06 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
#TQC-B40215 --begin--
#   IF g_pmi.pmi07 = 'Y' AND (g_pmi.pmi06 = '1' OR g_pmi.pmi06 = 'S') THEN #MOD-960211   
#      CALL cl_err(g_pmi.pmi01,'agl-160',0)
#      RETURN
#   END IF
#TQC-B40215 --end--
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmi01_t = g_pmi.pmi01
   BEGIN WORK
 
   OPEN i255_cl USING g_pmi.pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_pmi.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i255_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i255_show()
 
   WHILE TRUE
      LET g_pmi01_t = g_pmi.pmi01
      LET g_pmi_o.* = g_pmi.*
      LET g_pmi.pmimodu=g_user
      LET g_pmi.pmidate=g_today
      LET g_pmi.pmi10=g_pmi10            #CHI-880028 Add
 
      CALL i255_i("u")                      #欄位更改
      SELECT COUNT(*) INTO g_cnt FROM pmj_file
        WHERE pmj01 = g_pmi.pmi01
 
      IF g_cnt > 0 THEN
         IF g_pmi.pmi05 ="Y" THEN
            CALL i255_update_price1()     
         ELSE
            CALL i255_update_price()  
         END IF		
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmi.*=g_pmi_t.*
         CALL i255_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pmi.pmi01 != g_pmi01_t THEN            # 更改單號
#No.TQC-960300 ---start---
         UPDATE pmr_File SET pmr01 = g_pmi.pmi01
          WHERE pmr01 = g_pmi01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmr_file",g_pmi01_t,"",SQLCA.sqlcode,"","pmr",1)
            CONTINUE WHILE 
         END IF
#No.TQC-960300 ---end---    
         UPDATE pmj_file SET pmj01 = g_pmi.pmi01
          WHERE pmj01 = g_pmi01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmj_file",g_pmi01_t,"",SQLCA.sqlcode,"","pmj",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_pmi.pmi06 = '0'
      UPDATE pmi_file SET pmi_file.* = g_pmi.*
       WHERE pmi01 = g_pmi01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   DISPLAY BY NAME g_pmi.pmi06              #MOD-4A0299
   CALL i255_pic()               #FUN-920106
 
   CLOSE i255_cl
   COMMIT WORK
   CALL i255_b_fill(g_wc2)                 #No.TQC-960300  
   CALL cl_flow_notify(g_pmi.pmi01,'U')
 
END FUNCTION
 
FUNCTION i255_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
   li_result LIKE type_file.num5,    #No.FUN-550060  #No.FUN-680136 SMALLINT
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
 
   DISPLAY BY NAME g_pmi.pmi02,g_pmi.pmiconf,g_pmi.pmiuser,g_pmi.pmimodu,
       g_pmi.pmigrup,g_pmi.pmidate,g_pmi.pmiacti,g_pmi.pmi07,g_pmi.pmi06
 
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME g_pmi.pmioriu,g_pmi.pmiorig,g_pmi.pmi01,g_pmi.pmi02,g_pmi.pmi09,g_pmi.pmi03,#FUN-630044
                 g_pmi.pmi08,g_pmi.pmi081,g_pmi.pmi04,g_pmi.pmi05
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i255_set_entry(p_cmd)
         CALL i255_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("pmi01")        #No.FUN-550060
 
      AFTER FIELD pmi01
         #IF NOT cl_null(g_pmi.pmi01) THEN   #MOD-A10179
         IF NOT cl_null(g_pmi.pmi01) AND   #MOD-A10179
            (g_pmi.pmi01 <> g_pmi_t.pmi01 OR cl_null(g_pmi_t.pmi01))THEN   #MOD-A10179
             LET g_t1 = s_get_doc_no(g_pmi.pmi01)                          #TQC-960300
             CALL s_check_no("apm",g_pmi.pmi01,g_pmi_t.pmi01,"5","pmi_file","pmi01","")
               RETURNING li_result,g_pmi.pmi01
             DISPLAY BY NAME g_pmi.pmi01
             IF (NOT li_result) THEN
    	        NEXT FIELD pmi01
             END IF
            SELECT smyapr INTO g_smy.smyapr FROM smy_file
             WHERE smyslip = g_t1
            IF cl_null(g_pmi_t.pmi01) OR (g_pmi.pmi01 != g_pmi_t.pmi01) THEN
               LET g_pmi.pmi07 = g_smy.smyapr
               DISPLAY g_pmi.pmi07 TO pmi07
            END IF
         END IF
 
      AFTER FIELD pmi09
          IF NOT cl_null(g_pmi.pmi09) THEN
             CALL i255_pmi09('a')
             IF NOT cl_null(g_errno) THEN
                LET g_pmi.pmi09 = g_pmi_t.pmi09
                CALL cl_err(g_pmi.pmi09,g_errno,0)
                DISPLAY BY NAME g_pmi.pmi09 #
                NEXT FIELD pmi09
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.gen02
          END IF
 
      AFTER FIELD pmi03                       #廠商編號
         IF NOT cl_null(g_pmi.pmi03) THEN
                IF (g_pmi.pmi03 != g_pmi_o.pmi03 ) THEN #MOD-570057
                   LET g_chr=NULL #MOD-570057
                END IF #MOD-570057
               CALL i255_pmi03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmi.pmi03,g_errno,0)
                  LET g_pmi.pmi03 = g_pmi_o.pmi03
                  DISPLAY BY NAME g_pmi.pmi03
                  NEXT FIELD pmi03
               END IF
               CALL i255_pmi08(p_cmd)   #MOD-6B0005 add                                          
               IF NOT cl_null(g_errno) THEN
                  #TQC-C40022 mod str---------------------
                  #CALL cl_err(g_pmi.pmi03,g_errno,0)
                  #LET g_pmi.pmi03 = g_pmi_o.pmi03
                  #DISPLAY BY NAME g_pmi.pmi03
                  #NEXT FIELD pmi03
                  CALL cl_err(g_pmi.pmi08,g_errno,0)
                  LET g_pmi.pmi08 = g_pmi_o.pmi08
                  DISPLAY BY NAME g_pmi.pmi08
                  NEXT FIELD pmi08
                  #TQC-C40022 mod end---------------------
               END IF
            LET g_pmi_o.pmi03 = g_pmi.pmi03
         END IF
 
      AFTER FIELD pmi08                  #稅別
         IF NOT cl_null(g_pmi.pmi08) THEN
            IF g_pmi_o.pmi08 IS NULL OR
               (g_pmi_o.pmi08 != g_pmi.pmi08 ) THEN
               IF p_cmd='u' THEN
                  IF cl_confirm2('axm-415',g_pmi.pmi08) THEN
                     CALL i255_pmi08(p_cmd)
                  ELSE
                     LET g_pmi.pmi08 = g_pmi_o.pmi08
                     DISPLAY BY NAME g_pmi.pmi08
                     NEXT FIELD pmi08
                  END IF
               ELSE
                  CALL i255_pmi08(p_cmd)
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmi.pmi08,g_errno,0)
                  LET g_pmi.pmi08 = g_pmi_o.pmi08
                  DISPLAY BY NAME g_pmi.pmi08
                  NEXT FIELD pmi08
               END IF
            END IF
            LET g_pmi_o.pmi08 = g_pmi.pmi08
         END IF
 
      AFTER FIELD pmi05 #分量計價
         IF NOT cl_null(g_pmi.pmi05) THEN
            IF g_pmi.pmi05 NOT MATCHES "[YN]" THEN     #欄位必須輸入Y或N,請重新輸入
               LET g_pmi.pmi05 = g_pmi_t.pmi05
               DISPLAY BY NAME g_pmi.pmi05
               CALL cl_err('','9061',0)
               NEXT FIELD pmi05
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION supplier_data
                  LET g_cmd = "apmi600 ",g_pmi.pmi03 CLIPPED #MOD-530616 #FUN-7C0050
                 CALL cl_cmdrun(g_cmd)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmi01) #單據編號
               LET g_t1=s_get_doc_no(g_pmi.pmi01)     #No.FUN-550060
               CALL q_smy(FALSE,FALSE,g_t1,'APM','5') RETURNING g_t1 #TQC-670008
               LET g_pmi.pmi01=g_t1                   #No.FUN-550060
               DISPLAY BY NAME g_pmi.pmi01
               CALL i255_pmi01('d')
               NEXT FIELD pmi01
 
            WHEN INFIELD(pmi09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_pmi.pmi09
                 CALL cl_create_qry() RETURNING g_pmi.pmi09
                 DISPLAY BY NAME g_pmi.pmi09
                 NEXT FIELD pmi09
 
            WHEN INFIELD(pmi03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_pmi.pmi03
               CALL cl_create_qry() RETURNING g_pmi.pmi03
               DISPLAY BY NAME g_pmi.pmi03
               CALL i255_pmi03('d')
               NEXT FIELD pmi03
            WHEN INFIELD(pmi08) #稅別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.default1 = g_pmi.pmi08
               LET g_qryparam.arg1     = '1'
               CALL cl_create_qry() RETURNING g_pmi.pmi08
               DISPLAY BY NAME g_pmi.pmi08
               CALL i255_pmi08('d')
               NEXT FIELD pmi08
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
 
FUNCTION i255_pmi01(p_cmd)  #單據編號
    DEFINE l_smydesc   LIKE smy_file.smydesc,
           l_smyacti LIKE smy_file.smyacti,
           l_t1      LIKE smy_file.smyslip, #No.FUN-550060 #No.FUN-680136 VARCHAR(5)
           p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_chr = ' '
   LET l_t1 = s_get_doc_no(g_pmi.pmi01)    #No.FUN-550060
   IF g_pmi.pmi01 IS NULL THEN
      LET g_chr = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_chr = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
   IF cl_null(g_chr) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION
 
FUNCTION i255_pmi03(p_cmd)  #廠商編號
    DEFINE l_pmc03 LIKE pmc_file.pmc03,
           l_pmc05 LIKE pmc_file.pmc05,
           l_pmc47 LIKE pmc_file.pmc47,        #No.FUN-550019
           l_pmcacti LIKE pmc_file.pmcacti,
           l_pmc30 LIKE pmc_file.pmc30,   #MOD-920024
           p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_errno = " "
   SELECT pmc03,pmc05,pmc47,pmcacti,pmc30   #MOD-920024
     INTO l_pmc03,l_pmc05,l_pmc47,l_pmcacti,l_pmc30   #MOD-920024
     FROM pmc_file
    WHERE pmc01 = g_pmi.pmi03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET l_pmc03 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'    #No.FUN-690024
        WHEN l_pmc30 = "2" LET g_errno='mfg3290'   #MOD-920024       
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='s' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
      RETURN
   END IF
 
   CASE
        WHEN l_pmc05 = '0'   #尚待核准           #No.FUN-690025
             CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg
             WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YyNn]'
            LET INT_FLAG = 0  ######add for prompt bug
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
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
                IF g_chr MATCHES '[Nn]' THEN LET g_errno='apm-132' END IF #MOD-570056
             END WHILE
        WHEN l_pmc05 = '3'    #No.FUN-690025
             LET g_errno='mfg3042'
        OTHERWISE EXIT CASE
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_pmi.pmi08 = l_pmc47
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION
 
FUNCTION i255_pmi08(p_cmd)  #稅別
    DEFINE  l_gec04   LIKE gec_file.gec04,
            l_gecacti LIKE gec_file.gecacti,
            p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
	
    LET g_errno = " "
    SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07
      FROM gec_file
     WHERE gec01 = g_pmi.pmi08 AND gec011='1'  #進項
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_gec07) THEN
       LET g_gec07 = 'N'
    END IF
 
    IF p_cmd = 'a' OR p_cmd='u' THEN   #MOD-710094 mod                                                       
       LET g_pmi.pmi081 = l_gec04
       DISPLAY BY NAME g_pmi.pmi081
    END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_gec07 TO FORMONLY.gec07
    END IF
 
 
END FUNCTION
 
FUNCTION i255_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmi.* TO NULL                  #No.FUN-6A0162
 
   CALL cl_msg("")                              #FUN-640184
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmj.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i255_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pmi.* TO NULL
      RETURN
   END IF
 
   OPEN i255_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmi.* TO NULL
   ELSE
      OPEN i255_count
      FETCH i255_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i255_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i255_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     i255_cs INTO g_pmi.pmi01
       WHEN 'P' FETCH PREVIOUS i255_cs INTO g_pmi.pmi01
       WHEN 'F' FETCH FIRST    i255_cs INTO g_pmi.pmi01
       WHEN 'L' FETCH LAST     i255_cs INTO g_pmi.pmi01
       WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i255_cs INTO g_pmi.pmi01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)
      INITIALIZE g_pmi.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_pmi.* FROM pmi_file WHERE pmi01 = g_pmi.pmi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pmi.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_pmi.pmiuser      #FUN-4C0056 add
   LET g_data_group = g_pmi.pmigrup      #FUN-4C0056 add
   LET g_data_plant = g_pmi.pmiplant #FUN-980030
 
   CALL i255_show()
 
END FUNCTION
 
FUNCTION i255_show()
 
   LET g_pmi_t.* = g_pmi.*                #保存單頭舊值
   LET g_pmi_o.* = g_pmi.*                #保存單頭舊值
   DISPLAY BY NAME g_pmi.pmioriu,g_pmi.pmiorig, g_pmi.pmi01,g_pmi.pmi02,g_pmi.pmi09,g_pmi.pmi03,g_pmi.pmi04,g_pmi.pmi05,#FUN-630044
                   g_pmi.pmi07,g_pmi.pmi06,g_pmi.pmiconf,g_pmi.pmiuser,
                   g_pmi.pmigrup,g_pmi.pmimodu,g_pmi.pmidate,g_pmi.pmiacti,
                   g_pmi.pmi08,g_pmi.pmi081             #No.FUN-550019
    
    CALL i255_pic()         #FUN-920106
   CALL i255_pmi01('d')
    CALL i255_pmi03('s') #MOD-570056
   CALL i255_pmi08('d')                    #No.FUN-550019
   CALL i255_pmi09('d')                      #FUN-630044  
 
   CALL i255_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i255_r()
   DEFINE i         LIKE type_file.num10    #No.FUN-9C0046  ..Add
   DEFINE l_len     LIKE type_file.num10    #No.FUN-9C0046  ..Add
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-9C0046  ..Add
   DEFINE l_ac      LIKE type_file.num5     #No.FUN-9C0046  ..Add
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmi.pmi01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pmi.* FROM pmi_file
    WHERE pmi01=g_pmi.pmi01
 
   #檢查資料是否已確認
   IF g_pmi.pmiconf='Y' THEN
      CALL cl_err(g_pmi.pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_pmi.pmiconf='X' THEN
      CALL cl_err(g_pmi.pmiconf,'9024',0)
      RETURN
   END IF
 
   IF g_pmi.pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmi.pmi01,'mfg1000',0)
      RETURN
   END IF
 
    IF g_pmi.pmi06 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
    END IF
 
#TQC-B40215 --begin--
#    IF g_pmi.pmi07 = 'Y' AND (g_pmi.pmi06 = '1' OR g_pmi.pmi06 = 'S')#MOD-4A0299
#   THEN
#      CALL cl_err(g_pmi.pmi01,'agl-160',0)
#      RETURN
#   END IF
#TQC-B40215 --end--
 
   BEGIN WORK
 
   OPEN i255_cl USING g_pmi.pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i255_show()

      LET i=1
      LET l_len = g_pmj.getLength()
      FOR i=1 TO l_len
         IF g_pmj[i].pmj14 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_ac FROM pmj_file WHERE pmj01=g_pmi.pmi01 AND pmj14=g_pmj[i].pmj14
            IF l_ac > 0 THEN
               CALL cl_confirm("apm1025") RETURNING l_chr
               IF l_chr THEN
                  UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=g_pmj[i].pmj14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     RETURN
                  END IF
                  UPDATE wpc_file SET wpc09='N' WHERE wpc01=g_pmj[i].pmj14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     RETURN
                  END IF
               ELSE
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
         END IF
      END FOR
   
   IF cl_null(l_chr) THEN
      IF NOT cl_delh(0,0) THEN
         RETURN
      END IF
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "pmi01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_pmi.pmi01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                              #No.FUN-9B0098 10/02/24
   END IF

      DELETE FROM pmi_file WHERE pmi01 = g_pmi.pmi01
      DELETE FROM pmj_file WHERE pmj01 = g_pmi.pmi01
      IF g_pmi.pmi05 = 'Y' THEN
         DELETE FROM pmr_file WHERE pmr01 = g_pmi.pmi01
      END IF
      CLEAR FORM
      CALL g_pmj.clear()
      OPEN i255_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i255_cs
         CLOSE i255_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i255_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i255_cs
         CLOSE i255_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i255_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i255_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i255_fetch('/')
      END IF
 
   CLOSE i255_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmi.pmi01,'D')
 
END FUNCTION
 
#FUNCTION i255_b()  #mark by guanyao160525
FUNCTION i255_b(p_cmd_1)#add by guanyao160525
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_n1            LIKE type_file.num5,    #No.FUN-810017
    l_n2            LIKE type_file.num5,    #No.FUN-810017
    l_n3            LIKE type_file.num5,    #No.FUN-810017
    l_cnt           LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE gfe_file.gfe01,    #No.FUN-680136 VARCHAR(04)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
    l_pmj01         LIKE pmj_file.pmj01,
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    l_pmi06         LIKE pmi_file.pmi06
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
DEFINE  l_s1     LIKE type_file.chr1000                                                                                             
DEFINE  l_m1     LIKE type_file.chr1000                                                                                             
DEFINE  i1       LIKE type_file.num5                                                                                                
DEFINE  l_cnt1   LIKE type_file.num5  #MOD-920027
DEFINE  l_flag   LIKE type_file.chr1  #MOD-920027
DEFINE  l_pmhacti   LIKE pmh_file.pmhacti   #MOD-930327
DEFINE  l_pmr02  LIKE pmr_file.pmr02  #MOD-980166
DEFINE  l_chr    LIKE type_file.chr1  #No.FUN-9C0046
DEFINE  l_cnt2   LIKE type_file.num5  #MOD-CA0057 add
DEFINE  l_pmc22  LIKE pmc_file.pmc22  #CHI-C10008 add
DEFINE  p_cmd_1   LIKE type_file.chr1 #add by guanyao160525  
DEFINE  l_COUNT  INT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_pmi.pmi01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_pmi.* FROM pmi_file
     WHERE pmi01=g_pmi.pmi01
 
    LET l_pmi06 = g_pmi.pmi06     #MOD-4A0299
 
   #檢查資料是否已確認
   IF g_pmi.pmiconf='Y' THEN
      CALL cl_err(g_pmi.pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_pmi.pmiconf='X' THEN
      CALL cl_err(g_pmi.pmiconf,'9024',0)
      RETURN
   END IF
 
    IF g_pmi.pmi06 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
   IF g_pmi.pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmi.pmi01,'mfg1000',0)
      RETURN
   END IF
   #str----add by guanyao160525
   IF p_cmd_1 = 'p' THEN 
      CALL cl_set_comp_entry('pmj02,pmj03,pmj05',FALSE)
   ELSE 
      CALL cl_set_comp_entry('pmj02,pmj03,pmj05',TRUE)
   END IF 
   #end----add by guanyao160525
 
   LET l_cnt1 = 0
   LET l_flag = ' '
   SELECT COUNT(*) INTO l_cnt1 FROM pmj_file
    WHERE pmj01 = g_pmi.pmi01
   IF l_cnt1 = 0 THEN
      LET l_flag = 'Y'
   END IF
   #NO:7178自動由詢價單轉入產生單身
   #str----mark by guanyao160711
   #IF g_pmi.pmi05 = 'N' THEN
   #   CALL i255_b_g()
   #END IF
   #end----mark by guanyao160711
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pmj02,pmj03,pmj031,pmj032,pmj11,pmj04,'','',pmj10,'','',pmj13,pmjicd14,pmj05,pmj06,",  #FUN-560193 add '','' #FUN-930061 add ''	 #FUN-A30072   
                       "       pmj06t,pmj07,pmj07t,pmj08,pmj09,pmj14 ", #No.FUN-550019  #No.FUN-9C0046 ..Add pmj14
                       "  FROM pmj_file",
                       " WHERE pmj01=? AND pmj02=? AND pmj12='",g_pmj12,"' FOR UPDATE"  #No.FUN-670099
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i255_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmj WITHOUT DEFAULTS FROM s_pmj.*
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
           OPEN i255_cl USING g_pmi.pmi01
           IF STATUS THEN
              CALL cl_err("OPEN i255_cl:", STATUS, 1)
              CLOSE i255_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i255_cl INTO g_pmi.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i255_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pmj_t.* = g_pmj[l_ac].*  #BACKUP
              LET g_pmj_o.* = g_pmj[l_ac].*  #BACKUP
              OPEN i255_bcl USING g_pmi.pmi01,g_pmj_t.pmj02
              IF STATUS THEN
                 CALL cl_err("OPEN i255_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i255_bcl INTO g_pmj[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pmj_t.pmj02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                LET g_errno = ' '
             SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
               FROM ima_file WHERE ima01=g_pmj[l_ac].pmj03
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                            LET l_ima02 = NULL
                                            LET l_ima021= NULL
                  WHEN l_imaacti='N' LET g_errno = '9028'
                  WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
                  OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            SELECT ecd02 INTO g_pmj[l_ac].ecd02
              FROM ecd_file
             WHERE ecd01 = g_pmj[l_ac].pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_pmj[l_ac].ecd02 = ''
            END IF
            #str----add by guanyao160730
            SELECT ecbud02 INTO g_pmj[l_ac].ecbud02 
              FROM ecb_file 
             WHERE ecb01 = g_pmj[l_ac].pmj03 
               AND ecb06 = g_pmj[l_ac].pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_pmj[l_ac].ecbud02 = ''
            END IF
            #end----add by guanyao160730
            LET l_m1 = ' '
            IF g_sma.sma120 = 'Y' THEN                 
               IF NOT cl_null(g_errno) THEN 
                  LET g_buf = g_pmj[l_ac].pmj03
                  LET l_s1 = g_buf.trim()
                  FOR i1=1 TO length(l_s1)                                                                                                  
                  IF l_s1[i1,i1] = '_' THEN                                                                                              
                     LET l_m1 = l_s1[1,i1-1]                                                                                             
                     EXIT FOR                                                                                                         
                  ELSE                                                                                                                
                     CONTINUE FOR                                                                                                     
                  END IF                                                                                                              
                  IF l_s1[i1,i1] = '-' THEN                                                                                               
                     LET l_m1 = l_s1[1,i1-1]                                                                                              
                     EXIT FOR                                                                                                          
                  ELSE                                                                                                                 
                    CONTINUE FOR                                                                                                       
                  END IF                                                                                                               
                  IF l_s1[i1,i1] = ' ' THEN                                                                                               
                     LET l_m1 = l_s1[1,i1-1]                                                                                              
                     EXIT FOR                                                                                                          
                  ELSE                                                                                                                 
                     CONTINUE FOR                                                                                                       
                  END IF                                                                                                               
                  END FOR
               END IF
            END IF
            IF NOT cl_null(l_m1) THEN
               SELECT ima44,ima908 INTO g_pmj[l_ac].ima44,g_pmj[l_ac].ima908   
                FROM ima_file WHERE ima01=l_m1
            ELSE
               SELECT ima44,ima908 INTO g_pmj[l_ac].ima44,g_pmj[l_ac].ima908   
                 FROM ima_file WHERE ima01=g_pmj[l_ac].pmj03
            END IF
                 IF SQLCA.sqlcode THEN
                    LET g_pmj[l_ac].ima44 =NULL   
                    LET g_pmj[l_ac].ima908=NULL
                 END IF
              END IF
              CALL i255_set_entry_b(p_cmd)      #No.FUN-610018
              CALL i255_set_no_entry_b(p_cmd)   #No.FUN-610018
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pmj[l_ac].* TO NULL      #900423
           LET g_pmj[l_ac].pmj07 = 0        #Body default
           LET g_pmj[l_ac].pmj07t= 0            #No.FUN-550019
           LET g_pmj[l_ac].pmj09 = g_today      #Body default
           LET g_pmj_t.* = g_pmj[l_ac].*         #新輸入資料
           LET g_pmj_o.* = g_pmj[l_ac].*         #新輸入資料
           LET g_pmj[l_ac].pmj13 = " "           #No.FUN-810017
           IF g_pmj12 = '2' AND s_industry('icd') THEN
              LET g_pmj[l_ac].pmjicd14 = '0'
           END IF
           CALL i255_set_entry_b(p_cmd)      #No.FUN-610018
           CALL i255_set_no_entry_b(p_cmd)   #No.FUN-610018
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD pmj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              DELETE FROM pmr_file
               WHERE pmr01 = g_pmi.pmi01
                 AND pmr02 = g_pmj_t.pmj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
              END IF
              CANCEL INSERT
           END IF
           IF cl_null(g_pmj[l_ac].pmj10) THEN
              LET g_pmj[l_ac].pmj10=' '
              LET g_pmj[l_ac].ecd02=' '        #No.FUN-930061
              LET g_pmj[l_ac].ecbud02 = '' #add by guanyao160730
           END IF
            #FUN-A30072--begin--add-------
            IF g_pmj12 = '2' AND s_industry('icd') THEN
            SELECT COUNT(*) INTO l_n FROM pmj_file
             WHERE pmj03=g_pmj[l_ac].pmj03
               AND pmj01=g_pmi.pmi01
               AND pmj02!=g_pmj[l_ac].pmj02
               AND pmj03[1,4] !='MISC'
               AND pmj05=g_pmj[l_ac].pmj05
               AND pmj10=g_pmj[l_ac].pmj10
               AND pmj13=g_pmj[l_ac].pmj13     #No.TQC-930072 add
               AND pmj12=g_pmj12  #No.FUN-670099
               AND pmjicd14 = g_pmj[l_ac].pmjicd14
            ELSE
            #FUN-A30072--end--add-------------
               SELECT COUNT(*) INTO l_n FROM pmj_file
                WHERE pmj03=g_pmj[l_ac].pmj03
                  AND pmj01=g_pmi.pmi01
                  AND pmj02!=g_pmj[l_ac].pmj02
                  AND pmj03[1,4] !='MISC'
                  AND pmj05=g_pmj[l_ac].pmj05
                  AND pmj10=g_pmj[l_ac].pmj10
                  AND pmj13=g_pmj[l_ac].pmj13     #No.TQC-930072 add
                  AND pmj12=g_pmj12  #No.FUN-670099
            END IF
            IF l_n>0 THEN
               CALL cl_err(g_pmj[l_ac].pmj03,'apm-296',1)
               CANCEL INSERT
               NEXT FIELD pmj03
            END IF
           INSERT INTO pmj_file(pmj01,pmj02,pmj03,pmj031,pmj032,pmj11,pmj04,pmj05,
                                pmj06,pmj06t,pmj07,pmj07t,pmj09,pmj10,pmj08,       #No.FUN-550019  
                                pmj12,pmj13,pmjicd14,pmjplant,pmjlegal
                                ,ta_pmj01,ta_pmj02,ta_pmj03,ta_pmj04,ta_pmj05,ta_pmj06)  #No.FUN-670099 #No.FUN-810017 #FUN-980006 add pmjplant,pmjlegal  #FUN-A30072 #darcy:2023/08/04 add
                VALUES(g_pmi.pmi01,g_pmj[l_ac].pmj02,
                       g_pmj[l_ac].pmj03,g_pmj[l_ac].pmj031,
                       g_pmj[l_ac].pmj032,g_pmj[l_ac].pmj11,g_pmj[l_ac].pmj04,
                       g_pmj[l_ac].pmj05,g_pmj[l_ac].pmj06,
                       g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj07,    #No.FUN-550019
                       g_pmj[l_ac].pmj07t,g_pmj[l_ac].pmj09,    #No.FUN-550019
                       g_pmj[l_ac].pmj10,g_pmj[l_ac].pmj08,
                       g_pmj12,g_pmj[l_ac].pmj13,g_pmj[l_ac].pmjicd14,g_plant,g_legal
                       ,g_pmj[l_ac].ta_pmj01,g_pmj[l_ac].ta_pmj02,g_pmj[l_ac].ta_pmj03,g_pmj[l_ac].ta_pmj04,g_pmj[l_ac].ta_pmj05,g_pmj[l_ac].ta_pmj06)  #No.FUN-670099 #No.FUN-810017 #FUN-980006 add g_plant,g_legal  #FUN-A30072 #darcy:2023/08/04 add
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","pmj_file",g_pmi.pmi01,g_pmj[l_ac].pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD pmj02                        #default 序號
           IF g_pmj[l_ac].pmj02 IS NULL OR g_pmj[l_ac].pmj02 = 0 THEN
              SELECT max(pmj02)+1 INTO g_pmj[l_ac].pmj02 FROM pmj_file
               WHERE pmj01 = g_pmi.pmi01
              IF g_pmj[l_ac].pmj02 IS NULL THEN
                 LET g_pmj[l_ac].pmj02 = 1
              END IF
           END IF
 
        AFTER FIELD pmj02       #check 序號是否重複
           IF NOT cl_null(g_pmj[l_ac].pmj02) THEN
#MOD-C30161 ----- add ----- begin
              IF g_pmj[l_ac].pmj02 <=0 THEN
                 CALL cl_err('','aec-994',0)
                 LET g_pmj[l_ac].pmj02 = g_pmj_t.pmj02
                 NEXT FIELD pmj02
              END IF
#MOD-C30161 ----- add ----- end
              IF g_pmj[l_ac].pmj02 != g_pmj_t.pmj02 OR g_pmj_t.pmj02 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM pmj_file
                  WHERE pmj01 = g_pmi.pmi01
                    AND pmj02 = g_pmj[l_ac].pmj02
                 IF l_cnt > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pmj[l_ac].pmj02 = g_pmj_t.pmj02
                    NEXT FIELD pmj02
                 END IF
              END IF
           END IF
 
        BEFORE FIELD pmj03
           CALL i255_set_entry_b(p_cmd)
 
        AFTER FIELD pmj03                  #料件編號
           IF NOT cl_null(g_pmj[l_ac].pmj03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_pmj[l_ac].pmj03,"") THEN
                 CALL cl_err(g_pmj[l_ac].pmj03,g_errno,1)
                 LET g_pmj[l_ac].pmj03= g_pmj_t.pmj03
                 NEXT FIELD pmj03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
#MOD-CA0057 add begin------------------------------
              SELECT COUNT(*) INTO l_cnt2 FROM ima_file 
               WHERE ima01 = g_pmj[l_ac].pmj03
                 AND ima08 = 'X' 
              IF l_cnt2 > 0 THEN 
              	 CALL cl_err(g_pmj[l_ac].pmj03,'mfg9022',0)
              	 NEXT FIELD pmj03
              END IF  	   
#MOD-CA0057 add end--------------------------------
              LET l_misc=g_pmj[l_ac].pmj03[1,4]
              IF g_pmj[l_ac].pmj03[1,4]='MISC' THEN
                 SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima01=l_misc
                    AND ima01='MISC'
                 IF l_n=0 THEN
                    CALL cl_err('','aim-806',0)
                    NEXT FIELD pmj03
                 END IF
              END IF                                  #NO:6808
              IF g_pmj_o.pmj03 IS NULL OR g_pmj_o.pmj031 IS NULL OR
                (g_pmj[l_ac].pmj03 != g_pmj_o.pmj03) THEN
                 CALL i255_pmj03('a')
               LET l_m = ' '
              IF g_sma.sma120 = 'Y' THEN                 
                IF NOT cl_null(g_errno) THEN                                                                        
                  SELECT count(*) INTO l_n3                                                                                    
                    FROM imx_file,sma_file                                                                                     
                   WHERE (imx00||sma46||imx01||sma46||imx02||sma46||imx03||sma46||imx04=g_pmj[l_ac].pmj03)                     
                      OR (imx00||sma46||imx01||sma46||imx02||sma46||imx03=g_pmj[l_ac].pmj03)                                   
                      OR (imx00||sma46||imx01||sma46||imx02=g_pmj[l_ac].pmj03)                                                 
                      OR (imx00||sma46||imx01=g_pmj[l_ac].pmj03)                                                               
                      OR imx00=g_pmj[l_ac].pmj03                                                                               
                  IF l_n3 > 0 THEN   
                     LET g_errno = ' '
                     LET g_buf = g_pmj[l_ac].pmj03
                     LET l_s = g_buf.trim()
                    FOR i=1 TO length(l_s)                                                                                          
                        IF l_s[i,i] = '_' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = '-' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = ' ' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                    END FOR                                                                                                         
                  ELSE                                                                                          
                     CALL cl_err('','apm-828',0)                                                                               
                     NEXT FIELD pmj03                                                                                          
                  END IF                                                                                                       
                END IF                                                                                                          
              END IF                                                                                                             
                 IF NOT cl_null(g_errno) AND g_pmj[l_ac].pmj03[1,4] !='MISC' THEN #NO:6808
                    CALL cl_err(g_pmj[l_ac].pmj03,g_errno,0)
                    LET g_pmj[l_ac].pmj03 = g_pmj_o.pmj03
                    DISPLAY BY NAME g_pmj[l_ac].pmj03
                    NEXT FIELD pmj03
                 END IF
              END IF
              LET g_pmj_o.pmj03 = g_pmj[l_ac].pmj03
              #CHI-C10008 ----- add start -----
              IF p_cmd = 'a' THEN
                 SELECT pmc22 INTO l_pmc22 FROM pmc_file WHERE pmc01 = g_pmi.pmi03
                 LET g_pmj[l_ac].pmj05 = l_pmc22
                 DISPLAY BY NAME g_pmj[l_ac].pmj05
              END IF       
              #CHI-C10008 ----- add end -----
           END IF

           IF NOT cl_null(l_m) THEN
              SELECT ima44,ima908 INTO g_pmj[l_ac].ima44,g_pmj[l_ac].ima908    
                FROM ima_file WHERE ima01=l_m
           ELSE
              SELECT ima44,ima908 INTO g_pmj[l_ac].ima44,g_pmj[l_ac].ima908      
                FROM ima_file WHERE ima01=g_pmj[l_ac].pmj03
           END IF     #No.FUN-830114
           IF SQLCA.sqlcode THEN
              LET g_pmj[l_ac].ima44 =NULL   
              LET g_pmj[l_ac].ima908=NULL
           END IF
           #str-----add by guanyao160730
            IF NOT cl_null(g_pmj[l_ac].pmj03) AND NOT cl_null(g_pmj[l_ac].pmj10) THEN 
               SELECT ecbud02 INTO g_pmj[l_ac].ecbud02 
                 FROM ecb_file 
                WHERE ecb01 = g_pmj[l_ac].pmj03
                  AND ecb06 = g_pmj[l_ac].pmj10
               DISPLAY BY NAME g_pmj[l_ac].ecbud02
            END IF 
            #end-----add by guanyao160730
           CALL i255_set_no_entry_b(p_cmd)
 
        BEFORE FIELD pmj05
           CALL i255_set_entry_b(p_cmd)
 
        AFTER FIELD pmj05
           IF cl_null(g_pmj[l_ac].pmj05) THEN
              NEXT FIELD pmj05
           ELSE
              CALL i255_pmj05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pmj[l_ac].pmj05,g_errno,0)
                 NEXT FIELD pmj05
              ELSE
                 #FUN-A30072--begin--add-----------
                 IF g_pmj12 = '2' AND s_industry('icd') THEN
                 SELECT COUNT(*) INTO l_n FROM pmj_file
                  WHERE pmj03=g_pmj[l_ac].pmj03
                    AND pmj01=g_pmi.pmi01
                    AND pmj02!=g_pmj[l_ac].pmj02
                    AND pmj03[1,4] !='MISC'
                    AND pmj05=g_pmj[l_ac].pmj05
                    AND pmj10=g_pmj[l_ac].pmj10
                    AND pmj11=g_pmj[l_ac].pmj11
                    AND pmj13=g_pmj[l_ac].pmj13    #No.TQC-930072 add
                    AND pmj12=g_pmj12  #No.FUN-670099
                       AND pmjicd14=g_pmj[l_ac].pmjicd14
                 ELSE
                 #FUN-A30072--end--add-----------------
                    SELECT COUNT(*) INTO l_n FROM pmj_file
                     WHERE pmj03=g_pmj[l_ac].pmj03
                       AND pmj01=g_pmi.pmi01
                       AND pmj02!=g_pmj[l_ac].pmj02
                       AND pmj03[1,4] !='MISC'
                       AND pmj05=g_pmj[l_ac].pmj05
                       AND pmj10=g_pmj[l_ac].pmj10
                       AND pmj11=g_pmj[l_ac].pmj11
                       AND pmj13=g_pmj[l_ac].pmj13    #No.TQC-930072 add
                       AND pmj12=g_pmj12  #No.FUN-670099
                 END IF
                 IF l_n>0 THEN
                    CALL cl_err(g_pmj[l_ac].pmj03,'apm-296',0)
                    LET g_pmj_o.pmj03 = g_pmj[l_ac].pmj03
                    LET g_pmj[l_ac].pmj031= NULL
                    LET g_pmj[l_ac].pmj032= NULL
                    NEXT FIELD pmj05
                 END IF
                 LET l_pmj01 = NULL
                 SELECT pmj01 INTO l_pmj01 FROM pmi_file,pmj_file
                  WHERE pmi03=g_pmi.pmi03
                    AND pmi08=g_pmi.pmi08        #No.FUN-550019
                    AND pmiconf='N'
                    AND pmi01!=g_pmi.pmi01
                    AND pmj01=pmi01
                    AND pmj03=g_pmj[l_ac].pmj03
                    AND pmj03[1,4] != 'MISC'
                    AND pmj05=g_pmj[l_ac].pmj05
                    AND pmj10=g_pmj[l_ac].pmj10
                    AND pmj11=g_pmj[l_ac].pmj11
                    AND pmj12=g_pmj12  #No.FUN-670099
                 IF NOT cl_null(l_pmj01) THEN
                     LET g_message = NULL
                     LET g_message = 'NO:',l_pmj01,'==>',g_pmj[l_ac].pmj03 CLIPPED
                     LET g_message = g_message CLIPPED
                     #(廠商+料號+幣別+作業編號)尚有未確認之核價單
                     CALL cl_err(g_message,'apm-262',0)
                     NEXT FIELD pmj03
                 END IF
                IF g_pmj[l_ac].pmj03[1,4] !='MISC' THEN  #料號非為MISC才check    
                   IF cl_null(g_pmj[l_ac].pmj10) THEN
                   SELECT COUNT(*) INTO l_cnt FROM pmh_file   #check存在pmh
                    WHERE pmh01=g_pmj[l_ac].pmj03 AND pmh02=g_pmi.pmi03
                      AND pmh02 = g_pmi.pmi03   #TQC-740117
                      AND pmh13=g_pmj[l_ac].pmj05
                      AND pmh22=g_pmj12  #No.FUN-670099
                   ELSE
                   SELECT COUNT(*) INTO l_cnt FROM pmh_file   #check存在pmh
                    WHERE pmh01=g_pmj[l_ac].pmj03 AND pmh02=g_pmi.pmi03
                      AND pmh02 = g_pmi.pmi03   #TQC-740117
                      AND pmh13=g_pmj[l_ac].pmj05
                      AND pmh21=g_pmj[l_ac].pmj10  #No.FUN-670099
                      AND pmh23=g_pmj[l_ac].pmj13  #No.FUN-870124
                      AND pmh22=g_pmj12  #No.FUN-670099
                   END IF
                   IF l_cnt=0 THEN
                      #mark darcy:2022/10/10 s---
                      #CALL i255sub_pmj03_add(g_pmj[l_ac].pmj03,g_pmj[l_ac].pmj05,g_pmj12,g_pmj[l_ac].pmj10,g_pmi.*,g_pmj[l_ac].pmj13)#NO:7100  #No.FUN-670099
                      #CALL ui.interface.refresh()  #NO.MOD-590519
                      CALL i255_pmj06_def()
                      #mark darcy:2022/10/10 e---
                   ELSE
                     IF cl_null(g_pmj[l_ac].pmj10) THEN
                        SELECT pmhacti INTO l_pmhacti FROM pmh_file       
                           WHERE pmh01 = g_pmj[l_ac].pmj03
                             AND pmh02 = g_pmi.pmi03
                             AND pmh13 = g_pmj[l_ac].pmj05
                             AND pmh22 = g_pmj12            
                     ELSE
                        SELECT pmhacti INTO l_pmhacti FROM pmh_file       
                           WHERE pmh01 = g_pmj[l_ac].pmj03
                             AND pmh02 = g_pmi.pmi03
                             AND pmh13 = g_pmj[l_ac].pmj05
                             AND pmh21 = g_pmj[l_ac].pmj10  
                             AND pmh22 = g_pmj12            
                     END IF
                     IF l_pmhacti = 'N' THEN 
                        CALL cl_err('','apm-068',0)
                        LET g_pmj[l_ac].pmj05 = g_pmj_t.pmj05 
                        NEXT FIELD pmj03
                     END IF 
                      CALL i255_pmj06_def()
                   END IF
                END IF
              END IF
           END IF
 
           IF g_pmi.pmi05 = 'Y' THEN
              #當分量計價沒有輸入資料,才需要自動跳出畫面要求User輸入
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM pmr_file 
               WHERE pmr01 = g_pmi.pmi01 AND pmr02=g_pmj[l_ac].pmj02
              IF l_n = 0 THEN 
                 LET g_tmp_file = FGL_GETPID() USING '<<<<<<<<<<'
                 LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"
                 LET g_cmd = "apmi255c '",g_pmi.pmi01 CLIPPED,"' ", g_pmj[l_ac].pmj02 CLIPPED," '",
                              g_pmj[l_ac].pmj03 CLIPPED,"' ", #MOD-530616
                              " '",g_pmj[l_ac].pmj031 CLIPPED,"' ", #MOD-530616
                              " '",g_pmj[l_ac].pmj032 CLIPPED,"' ", #MOD-530616
                              " '",g_pmj[l_ac].pmj11 CLIPPED,"' ", #MOD-530616
                              " '",g_pmj[l_ac].pmj05 CLIPPED,"' ", #MOD-530616
                             " '",g_prog CLIPPED,"' '",g_tmp_file CLIPPED,"' '",
                             g_pmj[l_ac].pmj10 CLIPPED,"'"  #No.FUN-670099
 
                 CALL cl_cmdrun_wait(g_cmd)                  #MOD-530612
 
                 IF g_pmi.pmiconf='N' AND g_pmi.pmi06 NOT MATCHES '[Ss]' THEN
                    LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                    PREPARE tmp_prep2 FROM g_sql
                    IF STATUS THEN CALL cl_err('tmp_prep2:',status,1) RETURN -1 END IF
                    DECLARE tmp_curs2 CURSOR FOR tmp_prep2
                    OPEN tmp_curs2
                    FETCH tmp_curs2 INTO g_tmp01
                    LET l_pmi06 = g_tmp01
 
                    IF g_tmp01 <> g_pmi.pmi06 THEN
                       UPDATE pmi_file set pmi06=l_pmi06 where pmi01= g_pmi.pmi01
                    END IF
 
                 END IF
                 LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
                 PREPARE drop_prep2 FROM g_sql   #TQC-8C0068
                 EXECUTE drop_prep2   #TQC-8C0068
 
                 SELECT pmi06 INTO g_pmi.pmi06 FROM pmi_file where pmi01 = g_pmi.pmi01
                 DISPLAY BY NAME g_pmi.pmi06
                 CALL i255_pic()     #FUN-920106
 
                 SELECT COUNT(*) INTO g_cnt
                   FROM pmr_file
                  WHERE pmr01 = g_pmi.pmi01
                    AND pmr02 = g_pmj[l_ac].pmj02
                 IF g_cnt <=0 THEN
                    #請輸入分量計價資料!
                    CALL cl_err('','apm-289',0)
                    NEXT FIELD pmj05
                 END IF
              END IF   #MOD-640441 add
           END IF
           CALL i255_set_no_entry_b(p_cmd)
 
        AFTER FIELD pmj07                 #新單價
           IF g_pmi.pmi05 != 'Y' THEN
              IF cl_null(g_pmj[l_ac].pmj07) OR g_pmj[l_ac].pmj07 <=0 THEN
                 CALL cl_err(g_pmj[l_ac].pmj07,'mfg5034',0)
                 NEXT FIELD pmj07
              END IF
#str----add by guanyao160525
              IF p_cmd_1 = 'i' THEN
                 IF g_pmj[l_ac].pmj07<>g_pmj_t.pmj07 AND  g_pmj_t.pmj07<>0 THEN 
                    IF g_pmj[l_ac].pmj07 >g_pmj[l_ac].pmj06 THEN 
                       CALL cl_err('','cpm-016',0)
                       NEXT FIELD pmj07
                    END IF 
                 END IF                  
              END IF 
#end----add by guanyao160525
              SELECT azi03 INTO t_azi03 FROM azi_file   #MOD-910036
                  WHERE azi01 = g_pmj[l_ac].pmj05   #MOD-910036
              LET g_pmj[l_ac].pmj07 = cl_digcut(g_pmj[l_ac].pmj07,t_azi03) #No.FUN-550019  #No.CHI-6A0004
              LET g_pmj_o.pmj07 = g_pmj[l_ac].pmj07
              LET g_pmj[l_ac].pmj07t= g_pmj[l_ac].pmj07 * (1 + g_pmi.pmi081/100)
              LET g_pmj[l_ac].pmj07t = cl_digcut(g_pmj[l_ac].pmj07t,t_azi03)  #No.CHI-6A0004
              LET g_pmj_o.pmj07t = g_pmj[l_ac].pmj07t
           END IF
 
        AFTER FIELD pmj07t                 #新含稅單價
           IF g_pmi.pmi05 != 'Y' THEN
              IF cl_null(g_pmj[l_ac].pmj07t) OR g_pmj[l_ac].pmj07t <=0 THEN
                 CALL cl_err(g_pmj[l_ac].pmj07t,'mfg5034',0)
                 NEXT FIELD pmj07t
              END IF
              SELECT azi03 INTO t_azi03 FROM azi_file   #MOD-910036
                  WHERE azi01 = g_pmj[l_ac].pmj05   #MOD-910036
              LET g_pmj[l_ac].pmj07t = cl_digcut(g_pmj[l_ac].pmj07t,t_azi03)  #No.CHI-6A0004
              LET g_pmj_o.pmj07t = g_pmj[l_ac].pmj07t
 
              LET g_pmj[l_ac].pmj07 = g_pmj[l_ac].pmj07t / (1 + g_pmi.pmi081/100)
              LET g_pmj[l_ac].pmj07 = cl_digcut(g_pmj[l_ac].pmj07,t_azi03)   #No.CHI-6A0004
              LET g_pmj_o.pmj07 = g_pmj[l_ac].pmj07
           END IF
 
        AFTER FIELD pmj09                 #新核准日
           IF NOT cl_null(g_pmj[l_ac].pmj09) THEN
              LET g_pmj_o.pmj09 = g_pmj[l_ac].pmj09
           END IF

        AFTER FIELD pmj11                 #工艺说明
           IF NOT cl_null(g_pmj[l_ac].pmj11) THEN
              SELECT COUNT(*) INTO l_COUNT FROM ECB_FILE 
                 WHERE ECB01=g_pmj[l_ac].pmj03  AND ECB02=g_pmj[l_ac].pmj11
                 
                 IF l_COUNT=0 THEN
                   CALL cl_err( g_pmj[l_ac].pmj02,'mfg5102',1)
                   NEXT FIELD pmj11
                 END IF
              LET g_pmj_o.pmj11 = g_pmj[l_ac].pmj11
           END IF
            
        AFTER FIELD pmj10
            IF NOT cl_null(g_pmj[l_ac].pmj10) THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_pmj[l_ac].pmj10
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD pmj10
               END IF
            END IF
            IF cl_null(g_pmj[l_ac].pmj10) THEN
               LET g_pmj[l_ac].pmj10=' '
            END IF
            IF NOT cl_null(g_pmj[l_ac].pmj13) AND g_pmj[l_ac].pmj13 != " " THEN
               IF g_pmj[l_ac].pmj10 IS NULL OR g_pmj[l_ac].pmj10 = " " THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD pmj10
               END IF
            END IF
 
            SELECT ecd02 INTO g_pmj[l_ac].ecd02
              FROM ecd_file
             WHERE ecd01 = g_pmj[l_ac].pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_pmj[l_ac].ecd02 = ''
            END IF
            #str-----add by guanyao160730
            IF NOT cl_null(g_pmj[l_ac].pmj03) AND NOT cl_null(g_pmj[l_ac].pmj10) THEN 
               SELECT ecbud02 INTO g_pmj[l_ac].ecbud02 
                 FROM ecb_file 
                WHERE ecb01 = g_pmj[l_ac].pmj03
                  AND ecb06 = g_pmj[l_ac].pmj10
               DISPLAY BY NAME g_pmj[l_ac].ecbud02
            END IF 
            #end-----add by guanyao160730
        AFTER FIELD pmj13
           IF cl_null(g_pmj[l_ac].pmj13) THEN 
              LET g_pmj[l_ac].pmj13 = " "
           END IF
           IF NOT cl_null(g_pmj[l_ac].pmj13) AND g_pmj[l_ac].pmj13 != " " THEN
              SELECT count(*) INTO l_n1 FROM sga_file
               WHERE sga01 = g_pmj[l_ac].pmj13
                 AND sgaacti = 'Y'
              IF l_n1 = 0 THEN
                 CALL cl_err('','apm-105',0)
                 NEXT FIELD pmj13
              END IF
              IF g_pmj[l_ac].pmj10 IS NULL OR g_pmj[l_ac].pmj10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD pmj10
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_pmj_t.pmj02 > 0 AND g_pmj_t.pmj02 IS NOT NULL THEN
              IF g_pmj_t.pmj14 IS NOT NULL THEN
                 CALL cl_confirm("apm1025") RETURNING l_chr
                 IF NOT l_chr THEN
                    CANCEL DELETE
                 END IF
              ELSE
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pmj_file
               WHERE pmj01=g_pmi.pmi01
                 AND pmj02=g_pmj_t.pmj02
                 AND pmj10=g_pmj_t.pmj10          #FUN-870124
                 AND pmj12=g_pmj12                #FUN-870124
                 AND pmj13=g_pmj_t.pmj13          #FUN-870124
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmj_file",g_pmi.pmi01,g_pmj_t.pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              IF g_pmi.pmi05 = 'Y' THEN
                 DELETE FROM pmr_file
                  WHERE pmr01 = g_pmi.pmi01
                    AND pmr02 = g_pmj_t.pmj02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
              IF g_pmj_t.pmj14 IS NOT NULL THEN
                 UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=g_pmj_t.pmj14
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 UPDATE wpc_file SET wpc09='N' WHERE wpc01=g_pmj_t.pmj14
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pmj[l_ac].* = g_pmj_t.*
              CLOSE i255_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pmj[l_ac].pmj02,-263,1)
              LET g_pmj[l_ac].* = g_pmj_t.*
           ELSE
              IF cl_null(g_pmj[l_ac].pmj10) THEN
                 LET g_pmj[l_ac].pmj10 = " "
              END IF
              UPDATE pmj_file SET pmj02 = g_pmj[l_ac].pmj02,
                                  pmj03 = g_pmj[l_ac].pmj03,
                                  pmj031 = g_pmj[l_ac].pmj031,
                                  pmj032 = g_pmj[l_ac].pmj032,
                                  pmj11 = g_pmj[l_ac].pmj11,
                                  pmj04 = g_pmj[l_ac].pmj04,
                                  pmj05 = g_pmj[l_ac].pmj05,
                                  pmj06 = g_pmj[l_ac].pmj06,
                                  pmj06t= g_pmj[l_ac].pmj06t,     #No.FUN-550019
                                  pmj07 = g_pmj[l_ac].pmj07,
                                  pmj07t= g_pmj[l_ac].pmj07t,     #No.FUN-550019
                                  pmj08 = g_pmj[l_ac].pmj08,
                                  pmj09 = g_pmj[l_ac].pmj09,
                                  pmj13 = g_pmj[l_ac].pmj13,      #No.FUN-810017
                                  pmjicd14 = g_pmj[l_ac].pmjicd14, #FUN-A30072
                                  pmj10 = g_pmj[l_ac].pmj10,
                                  #darcy:2023/08/04 add s---
                                  ta_pmj01 = g_pmj[l_ac].ta_pmj01,
                                  ta_pmj02 = g_pmj[l_ac].ta_pmj02,
                                  ta_pmj03 = g_pmj[l_ac].ta_pmj03,
                                  ta_pmj04 = g_pmj[l_ac].ta_pmj04,
                                  ta_pmj05 = g_pmj[l_ac].ta_pmj05,
                                  ta_pmj06 = g_pmj[l_ac].ta_pmj06
                                  #darcy:2023/08/04 add e---
               WHERE pmj01=g_pmi.pmi01
                 AND pmj02=g_pmj_t.pmj02
                 AND pmj10=g_pmj_t.pmj10          #TQC-810025
                 AND pmj12=g_pmj12                #TQC-7B0089
                 AND pmj13=g_pmj_t.pmj13          #No.FUN-810017
               
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","pmj_file",g_pmi.pmi01,g_pmj_t.pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmj[l_ac].* = g_pmj_t.*
              ELSE
#No.TQC-960300---start---
                 IF g_pmj[l_ac].pmj02 != g_pmj_t.pmj02 THEN
                    UPDATE pmr_file SET pmr02 = g_pmj[l_ac].pmj02
                     WHERE pmr01 = g_pmi.pmi01
                       AND pmr02 = g_pmj_t.pmj02
                 END IF
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","pmr_file",g_pmi.pmi01,g_pmj_t.pmj02,SQLCA.sqlcode,"","",1)
                 LET g_pmj[l_ac].* = g_pmj_t.*
                 ELSE   
#No.TQC-960300---end---
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF                          #No.TQC-960300  
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac          #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pmj[l_ac].* = g_pmj_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pmj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              LET l_pmi06 = g_pmi.pmi06  #FUN-C30293
              CLOSE i255_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_pmi06 = '0'  #FUN-C30293
           LET l_ac_t = l_ac          #FUN-D30034 add
           CLOSE i255_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmj02) AND l_ac > 1 THEN
              LET g_pmj[l_ac].* = g_pmj[l_ac-1].*
              LET g_pmj[l_ac].pmj02 = NULL   #MOD-B60087 add
              NEXT FIELD pmj02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION pricing_by_qty
           IF g_pmi.pmi05 = 'Y' THEN
              LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"
              LET g_cmd = "apmi255c '",g_pmi.pmi01 CLIPPED,"' ", g_pmj[l_ac].pmj02 CLIPPED," '",
                           g_pmj[l_ac].pmj03 CLIPPED,"' ", #MOD-530616
                           " '",g_pmj[l_ac].pmj031 CLIPPED,"' ", #MOD-530616
                           " '",g_pmj[l_ac].pmj032 CLIPPED,"' ", #MOD-530616
                           " '",g_pmj[l_ac].pmj11 CLIPPED,"' ", #MOD-530616
                           " '",g_pmj[l_ac].pmj05 CLIPPED,"' ", #MOD-530616
                          " '",g_prog CLIPPED,"' '",g_tmp_file CLIPPED,"' '",
                             g_pmj[l_ac].pmj10 CLIPPED,"'"  #No.FUN-670099
              CALL cl_cmdrun_wait(g_cmd)                  #MOD-530612
 
              IF g_pmi.pmiconf='N' AND g_pmi.pmi06 NOT MATCHES '[Ss]' THEN
                 LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                 PREPARE tmp_prep3 FROM g_sql
                 IF STATUS THEN CALL cl_err('tmp_prep3:',status,1) RETURN -1 END IF
                 DECLARE tmp_curs3 CURSOR FOR tmp_prep3
                 OPEN tmp_curs3
                 FETCH tmp_curs3 INTO g_tmp01
                 LET l_pmi06 = g_tmp01
 
                 IF g_tmp01 <> g_pmi.pmi06 THEN
                    UPDATE pmi_file set pmi06=l_pmi06 where pmi01= g_pmi.pmi01
                 END IF
 
              END IF
              LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
              PREPARE drop_prep3 FROM g_sql   #TQC-8C0068
              EXECUTE drop_prep3   #TQC-8C0068
              SELECT pmi06 INTO g_pmi.pmi06 FROM pmi_file where pmi01 = g_pmi.pmi01
              DISPLAY BY NAME g_pmi.pmi06
              CALL i255_pic()    #FUN-920106 add
           ELSE
              #不是分量計價資料
              CALL cl_err(g_pmi.pmi01,'apm-286',1)
           END IF
 
        ON ACTION item
           CASE
              WHEN INFIELD(pmj03) #料件編號
                 IF g_sma.sma38 matches'[Yy]' THEN
                    CALL cl_cmdrun("aimi109 ")
                 ELSE
                    CALL cl_err(g_sma.sma38,'mfg0035',1)
                 END IF
              
              WHEN INFIELD(pmj11) #工艺说明
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecb12"
                 LET g_qryparam.default1 =''
                 #LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj11
                 NEXT FIELD pmj11
              OTHERWISE EXIT CASE
           END CASE
#str-----add by guanyao160525
        ON ACTION pltj
           CALL i255_pl('b')      
#end-----add by guanyao160525
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(pmj03) #料件編號
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_ima"
              #   LET g_qryparam.default1 = g_pmj[l_ac].pmj03
              #   CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pmj[l_ac].pmj03, "", "", "", "" ,"",'' )  RETURNING g_pmj[l_ac].pmj03
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_pmj[l_ac].pmj03           #No.MOD-490371
                 IF NOT cl_null(g_pmj[l_ac].pmj03) AND
                    g_pmj[l_ac].pmj03[1,4] !='MISC' THEN
                    CALL i255_pmj03('d')
                    NEXT FIELD pmj03
                 END IF
              WHEN INFIELD(pmj05)     #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = ''
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj05
                  DISPLAY BY NAME g_pmj[l_ac].pmj05           #No.MOD-490371
                 NEXT FIELD pmj05
                 
              WHEN INFIELD(pmj11)     #工艺说明
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecb12"
                 LET g_qryparam.default1 =''
                 #LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj11
                  DISPLAY BY NAME g_pmj[l_ac].pmj11           #No.MOD-490371
                 NEXT FIELD pmj11
                 
              WHEN INFIELD(pmj13)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_sga"                                                                                       
                 LET g_qryparam.default1 = g_pmj[l_ac].pmj13                                                                        
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj13                                                                   
                 DISPLAY BY NAME g_pmj[l_ac].pmj13                                                                                  
              WHEN INFIELD(pmj10)     #作業編號
                 CALL q_ecd(FALSE,TRUE,'') RETURNING g_pmj[l_ac].pmj10
                  DISPLAY BY NAME g_pmj[l_ac].pmj10           #No.MOD-490371
                 SELECT ecd02 INTO g_pmj[l_ac].ecd02
                   FROM ecd_file
                  WHERE ecd01 = g_pmj[l_ac].pmj10
                 IF SQLCA.sqlcode = 100 THEN
                    LET g_pmj[l_ac].ecd02 = ''
                 END IF
                 NEXT FIELD pmj10
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION query_supplier_item
           CASE
              WHEN INFIELD(pmj03) #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmh"
                 LET g_qryparam.arg1 = g_pmi.pmi03 #MOD-980012   
                 LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj03
                 CALL i255_pmj03('d')
                 NEXT FIELD pmj03
              WHEN INFIELD(pmj11) #工艺说明
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecb12"
                 LET g_qryparam.default1 =''
                 #LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_pmj[l_ac].pmj11
                 NEXT FIELD pmj11
              OTHERWISE EXIT CASE
           END CASE
 
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
 
   IF l_flag != 'Y' THEN     #MOD-920027
      LET g_pmi.pmimodu = g_user
      LET g_pmi.pmidate = g_today
      UPDATE pmi_file SET pmimodu = g_pmi.pmimodu,pmidate = g_pmi.pmidate
       WHERE pmi01 = g_pmi.pmi01
      DISPLAY BY NAME g_pmi.pmimodu,g_pmi.pmidate
   END IF             #MOD-920027   
 
        UPDATE pmi_file SET pmi06 = l_pmi06
           WHERE pmi01=g_pmi.pmi01
        LET g_pmi.pmi06 = l_pmi06
        DISPLAY BY NAME g_pmi.pmi06
        CALL i255_pic()      #FUN-920106
 
    IF g_pmi.pmi05 = 'Y' THEN
       LET g_sql = "SELECT DISTINCT pmr02 ",   
                   " FROM pmr_file",
                   " WHERE pmr01 ='",g_pmi.pmi01,"'"      
       PREPARE pmrchk_pre FROM g_sql
       DECLARE pmrchk_cs                       #CURSOR
           CURSOR FOR pmrchk_pre
       LET g_cnt = 0
       FOREACH pmrchk_cs INTO l_pmr02
          IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          SELECT COUNT(*) INTO g_cnt
            FROM pmj_file
           WHERE pmj01 = g_pmi.pmi01 AND pmj02 = l_pmr02
          IF g_cnt = 0 THEN
             DELETE FROM pmr_file 		
             WHERE pmr01 = g_pmi.pmi01 AND pmr02 = l_pmr02	
          END IF
       END FOREACH
    END IF 
 
    CLOSE i255_bcl
    COMMIT WORK
 
#   CALL i255_delall() #MOD-7A0085-add  #CHI-C30002 mark
    CALL i255_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i255_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_pmi.pmi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM pmi_file ",
                  "  WHERE pmi01 LIKE '",l_slip,"%' ",
                  "    AND pmi01 > '",g_pmi.pmi01,"'"
      PREPARE i255_pb1 FROM l_sql 
      EXECUTE i255_pb1 INTO l_cnt      
      
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
         #CALL i255_x() #FUN-D20025 mark
         CALL i255_x(1) #FUN-D20025 add
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pmi_file WHERE pmi01 = g_pmi.pmi01
         INITIALIZE g_pmi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i255_delall()
#
#   LET g_cnt= 0
#   SELECT COUNT(*) INTO g_cnt FROM pmj_file
#    WHERE pmj01 = g_pmi.pmi01 
#
#   IF g_cnt = 0 THEN 
#      			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM pmi_file WHERE pmi01 = g_pmi.pmi01 
#      CLEAR FORM        #MOD-C30482 add
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i255_pmj03_def()  #帶出料件廠商之資料

   SELECT pmh04,pmh06,pmh12,pmh19,pmh13
     INTO g_pmj[l_ac].pmj04,g_pmj[l_ac].pmj08,g_pmj[l_ac].pmj06,
          g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj05
     FROM pmh_file
    WHERE pmh01 = g_pmj[l_ac].pmj03
      AND pmh02=g_pmi.pmi03
      AND pmh13 = g_pmj[l_ac].pmj05
      AND pmhacti = 'Y'                                           #CHI-910021
 
   IF cl_null(g_pmj[l_ac].pmj06) THEN
      LET g_pmj[l_ac].pmj06 = 0
   END IF
 
   IF cl_null(g_pmj[l_ac].pmj08) THEN
      LET g_pmj[l_ac].pmj08 = ' '
   END IF
   #要重show,不然會影響ON ROW CHANGE
   DISPLAY g_pmj[l_ac].pmj04,g_pmj[l_ac].pmj08,g_pmj[l_ac].pmj06,
           g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj05                      #No.FUN-610018   
        TO pmj04,pmj08,pmj06,pmj06t,pmj05                          
 
   IF cl_null(g_pmj[l_ac].pmj06t) THEN
      LET g_pmj[l_ac].pmj06t = g_pmj[l_ac].pmj06 * ( 1 + g_pmi.pmi081/100)
   END IF
 
END FUNCTION
 
FUNCTION i255_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON pmj02,pmj03,pmj11,pmj04,pmj10 ,pmjicd14,pmj05,	   #FUN-A30072
                       pmj06,pmj06t,pmj07,pmj07t,pmj08,pmj09,pmj13,pmj14      #No.FUN-810017 add pmj13   #No.FUN-9C0046 add pmj14
            FROM s_pmj[1].pmj02,s_pmj[1].pmj03,s_pmj[1].pmj11,s_pmj[1].pmj04,s_pmj[1].pmj10,
                 s_pmj[1].pmjicd14,s_pmj[1].pmj05,s_pmj[1].pmj06,s_pmj[1].pmj06t,  #FUN-A30072
                 s_pmj[1].pmj07,s_pmj[1].pmj07t,
                 s_pmj[1].pmj08,s_pmj[1].pmj09,s_pmj[1].pmj13,s_pmj[1].pmj14         #NO.FUN-810017 add pmj13  #No.FUN-9C0046 add pmj14 
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
 
    CALL i255_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i255_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200) #TQC-BA0191
    p_wc2           STRING #TQC-BA0191
DEFINE l_ima02    LIKE ima_file.ima02,                                                                                              
       l_ima021   LIKE ima_file.ima021,                                                                                             
       l_imaacti  LIKE ima_file.imaacti                                                                                             
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
 
    IF cl_null(p_wc2) THEN
       LET p_wc2='1=1 '
    END IF
 
    LET g_sql = "SELECT pmj02,pmj03,pmj031,pmj032,pmj11,pmj04,ima44,ima908,pmj10,ecd02,ecbud02,",#No.FUN-930061 add ecd02 #add ecbud02 by guanyao160730
                "       pmj13,pmjicd14,pmj05,pmj06,pmj06t,",  #FUN-560193  add ima44,ima908 #No.FUN-810017 add pmj13   #FUN-A30072
                " pmj07,pmj07t,pmj08,pmj09,pmj14",      #end No.FUN-550019    #No.FUN-9C0046 add pmj14
#TQC-AB0025------------------mod-----------------str------------------
#               " FROM pmj_file,OUTER ima_file,OUTER ecd_file",  #FUN-560193 add OUTER ima_file#No.FUN-930061 add ecd_file
#               " WHERE pmj01 ='",g_pmi.pmi01,"' AND ",  #單頭
#               p_wc2 CLIPPED,                           #單身
#               " AND pmj_file.pmj03=ima_file.ima01 ",  #FUN-560193
#               " AND pmj10=ecd_file.ecd01 ",  #FUN-930061
                " ,ta_pmj01,ta_pmj02,ta_pmj03,ta_pmj04,ta_pmj05,ta_pmj06 ",
                " FROM pmj_file,ima_file,ecd_file,ecb_file WHERE pmj_file.pmj03=ima_file.ima01 ",
                " AND pmj_file.pmj10 = ecd_file.ecd01(+) ",
                " AND ecb01(+) = pmj03 AND ecb06(+) = nvl(pmj10,'a') and nvl(pmj11,'a')=ecb02(+)",     #add by guanyao160730
                " AND pmj01 ='",g_pmi.pmi01,"' AND ",p_wc2 CLIPPED, 
#TQC-AB0025------------------mod-----------------end------------------                
                " ORDER BY 1"
    PREPARE i255_pb FROM g_sql
    DECLARE pmj_cs                       #CURSOR
        CURSOR FOR i255_pb
 
    CALL g_pmj.clear()
    LET g_cnt = 1
    FOREACH pmj_cs INTO g_pmj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_errno = ' '
        SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
          FROM ima_file WHERE ima01=g_pmj[g_cnt].pmj03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                      LET l_ima02 = NULL
                                      LET l_ima021= NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
            WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
        LET l_m = ' '
        IF g_sma.sma120 = 'Y' THEN                 
           IF NOT cl_null(g_errno) THEN 
              LET g_buf = g_pmj[g_cnt].pmj03
              LET l_s = g_buf.trim()
             FOR i=1 TO length(l_s)                                                                                                  
                IF l_s[i,i] = '_' THEN                                                                                              
                   LET l_m = l_s[1,i-1]                                                                                             
                   EXIT FOR                                                                                                         
                ELSE                                                                                                                
                   CONTINUE FOR                                                                                                     
                END IF                                                                                                              
               IF l_s[i,i] = '-' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
               IF l_s[i,i] = ' ' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
            END FOR
           END IF
        END IF
          IF NOT cl_null(l_m) THEN                                                                                                     
          SELECT ima44,ima908 INTO g_pmj[g_cnt].ima44,g_pmj[g_cnt].ima908        
            FROM ima_file                                                                                                           
           WHERE ima01 = l_m
          END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i255_update_price()              #CHANGE pmi08
 
    DEFINE  l_pmj02   LIKE pmj_file.pmj02,                                      
            l_pmj07   LIKE pmj_file.pmj07,                                      
            l_pmj07t  LIKE pmj_file.pmj07t,
            l_pmj05   LIKE pmj_file.pmj05   #MOD-910036   增加pmj05                                    
 
    IF g_pmj[l_ac].pmj02 IS NULL THEN
       RETURN
    END IF
 
    LET g_sql = "SELECT pmj02,pmj07,pmj07t,pmj05 ",   #MOD-910036   增加pmj05
                " FROM pmj_file",
                " WHERE pmj01 ='",g_pmi.pmi01,"'"          #單頭
 
    PREPARE i255_upd FROM g_sql
 
    DECLARE upd_cs                       #CURSOR
        CURSOR FOR i255_upd
 
    LET g_cnt = 1
    FOREACH upd_cs INTO l_pmj02,l_pmj07,l_pmj07t,l_pmj05  #單身    #MOD-910036   增加pmj05
 
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT azi03 INTO t_azi03 FROM azi_file
         WHERE azi01=l_pmj05
       #含稅單價                                                                  
       IF g_gec07 = 'N' THEN
           LET l_pmj07t= l_pmj07 * (1 + g_pmi.pmi081/100)
           LET l_pmj07t = cl_digcut(l_pmj07t,t_azi03)   #MOD-910036   g_azi03-->t_azi03
       ELSE
           LET l_pmj07 = l_pmj07t / (1 + g_pmi.pmi081/100)
           LET l_pmj07 = cl_digcut(l_pmj07,t_azi03)    #MOD-910036   g_azi03-->t_azi03
       END IF
    
       UPDATE pmj_file SET pmj07 = l_pmj07,
                           pmj07t = l_pmj07t
       WHERE pmj01=g_pmi.pmi01 AND pmj02=l_pmj02 
 
       IF SQLCA.SQLCODE THEN
          LET g_success = FALSE
          ROLLBACK WORK
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmj.deleteElement(g_cnt)
    CALL i255_show()
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i255_update_price1()       #CHANGE pmi08  WHEN pmi05="Y" 分量計價
 
    DEFINE  l_pmj02   LIKE pmj_file.pmj02,                                      
            l_pmr03   LIKE pmr_file.pmr03,                                      
            l_pmr04   LIKE pmr_file.pmr04,                                      
            l_pmr05   LIKE pmr_file.pmr05,                                      
            l_pmr05t  LIKE pmr_file.pmr05t,                                    
            l_pmj05   LIKE pmj_file.pmj05   #MOD-910036
 
    IF g_pmj[l_ac].pmj02 IS NULL THEN
       RETURN
    END IF
#第一層
 
    LET g_sql = "SELECT pmj02,pmj05 ",   #MOD-910036  增加pmj05
                " FROM pmj_file",
                " WHERE pmj01 ='",g_pmi.pmi01,"'"          #單頭
 
    PREPARE i255_upd1 FROM g_sql
 
    DECLARE upd_cs1                       #CURSOR
        CURSOR FOR i255_upd1
 
    LET g_cnt1 = 1
    FOREACH upd_cs1 INTO l_pmj02,l_pmj05   #單身 ARRAY 填充   #MOD-910036  增加pmj05
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
#第二層
    LET g_forupd_sql=
        "SELECT pmr03,pmr04,pmr05,pmr05t ", 
        "  FROM pmr_file ",
        " WHERE pmr01 ='",g_pmi.pmi01,"'", 
        "   AND pmr02 = ",l_pmj02,
        " ORDER BY pmr03,pmr04,pmr05 "
 
    PREPARE i255_upd2 FROM g_forupd_sql
 
    DECLARE upd_cs2                      #CURSOR
        CURSOR FOR i255_upd2
 
    LET g_cnt = 1
    FOREACH upd_cs2 INTO l_pmr03,l_pmr04,l_pmr05,l_pmr05t   #分量計價 單身 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #分量計價                                                                 
        SELECT azi03 INTO t_azi03 FROM azi_file
          WHERE azi01 = l_pmj05
        IF g_gec07 = 'N' THEN
            LET l_pmr05t = l_pmr05 * (1 + g_pmi.pmi081/100)
            LET l_pmr05t = cl_digcut(l_pmr05t,t_azi03)   #MOD-910036   g_azi03-->t_azi03
        ELSE
            LET l_pmr05 = l_pmr05t / (1 + g_pmi.pmi081/100)
            LET l_pmr05 = cl_digcut(l_pmr05,t_azi03)   #MOD-910036   g_azi03-->t_azi03
        END IF
 
        UPDATE pmr_file SET  pmr05  = l_pmr05,
                             pmr05t = l_pmr05t  
        WHERE pmr01=g_pmi.pmi01 
          AND pmr02=l_pmj02
          AND pmr03=l_pmr03
          AND pmr04=l_pmr04
 
        IF SQLCA.SQLCODE THEN
           LET g_success = FALSE
           ROLLBACK WORK
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmj.deleteElement(g_cnt)
    LET g_cnt = 0
#第二層結束
        IF SQLCA.SQLCODE THEN
           LET g_success = FALSE
           ROLLBACK WORK
        END IF
        LET g_cnt1 = g_cnt1 + 1
        IF g_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmj.deleteElement(g_cnt1)
    LET g_cnt = 0
#第一層結束
 
END FUNCTION
 
 
FUNCTION i255_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmj TO s_pmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i255_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i255_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i255_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i255_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i255_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         CALL i255_pic()     #FUN-920106
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 分量計價資料
      ON ACTION pricing_by_qty
         LET g_action_choice="pricing_by_qty"
         EXIT DISPLAY
#str----add by guanyao160525
      ON ACTION pltj
         LET g_action_choice="pltj"
         EXIT DISPLAY
#end----add by guanyao160525
#@    ON ACTION 送簽
      ON ACTION easyflow_approval     #MOD-4A0299
         LET g_action_choice="easyflow_approval"
         EXIT DISPLAY
#str----add by guanyao160525
      ON ACTION price_u
         LET g_action_choice="price_u"
         EXIT DISPLAY
#end----add by guanyao160525
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #@ON ACTION 簽核狀況
       ON ACTION approval_status     #MOD-4C0041
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
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
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i255_copy()
DEFINE
    l_newno         LIKE pmi_file.pmi01,
    l_newdate       LIKE pmi_file.pmi02,
    l_pmi03         LIKE pmi_file.pmi03, #MOD-570060
    l_oldno         LIKE pmi_file.pmi01,
    li_result       LIKE type_file.num5   #No.FUN-550060  #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmi.pmi01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
     LET l_newno   = NULL              #MOD-480231
     LET l_newdate = NULL              #MOD-480231
     LET l_pmi03   = NULL              #MOD-570060
     LET g_before_input_done = FALSE   #MOD-480231
     CALL i255_set_entry('a')          #MOD-480231
     LET g_before_input_done = TRUE    #MOD-480231
 
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT l_newno,l_newdate,l_pmi03 FROM pmi01,pmi02,pmi03 #MOD-570060 add pmi03
 
        BEFORE INPUT
            CALL cl_set_docno_format("pmi01")      #No.FUN-550060
 
        AFTER FIELD pmi01
                CALL s_check_no("apm",l_newno,"","5","pmi_file","pmi01","")
                   RETURNING li_result,l_newno
                DISPLAY l_newno to pmi01
                IF (NOT li_result) THEN
                    NEXT FIELD pmi01
                END IF
 
        AFTER FIELD pmi02
             IF cl_null(l_newdate) THEN NEXT FIELD pmi02 END IF  #MOD-790163 modify
                BEGIN WORK
                CALL s_auto_assign_no("apm",l_newno,l_newdate,"5","pmi_file","pmi01","","","")
                  RETURNING li_result,l_newno
                IF (NOT li_result) THEN
                  NEXT FIELD pmi01
                END IF
                DISPLAY l_newno to pmi01
 
        AFTER FIELD pmi03                       #廠商編號
           IF NOT cl_null(l_pmi03) THEN
               LET g_chr=NULL
               LET g_pmi.pmi03=l_pmi03
               CALL i255_pmi03('a')
               LET g_pmi.pmi03=NULL
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_pmi03,g_errno,0)
                  NEXT FIELD pmi03
               END IF
           END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(pmi01) #單據編號
                    LET g_t1=s_get_doc_no(l_newno)     #No.FUN-550060
                    CALL q_smy(FALSE,FALSE,g_t1,'APM','5') RETURNING g_t1 #TQC-670008
                    LET l_newno=g_t1                   #No.FUN-550060
                    DISPLAY l_newno TO pmi01
                    CALL i255_pmi01('d')
                    NEXT FIELD pmi01
               WHEN INFIELD(pmi03) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc1"
                  LET g_qryparam.default1 = l_pmi03
                  CALL cl_create_qry() RETURNING l_pmi03
                  DISPLAY l_pmi03 TO pmi03
                  NEXT FIELD pmi03
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
       ROLLBACK WORK         #No.FUN-550060
       DISPLAY BY NAME g_pmi.pmi01
       DISPLAY BY NAME g_pmi.pmi02  #TQC-AC0402
       DISPLAY BY NAME g_pmi.pmi03  #TQC-AC0402
       RETURN
    END IF
 
     #MOD-4B0197(整段的羅輯重新組合過,因為要1.將複製過程包Transaction
    #                                      2.複製時要一併複製分量計價檔)
    #單頭
    DROP TABLE y
    SELECT * FROM pmi_file
        WHERE pmi01=g_pmi.pmi01
        INTO TEMP y
 
    #單身
    DROP TABLE x
    SELECT * FROM pmj_file
     WHERE pmj01=g_pmi.pmi01
      INTO TEMP x
 
    #分量計價檔
    DROP TABLE z
    SELECT * FROM pmr_file
     WHERE pmr01=g_pmi.pmi01
      INTO TEMP z
 
    BEGIN WORK
    LET g_success = 'Y'
 
    #==>單頭複製
    UPDATE y SET pmi01=l_newno,    #新的鍵值
                 pmi02=l_newdate,  #新的鍵值
                  pmi03=l_pmi03,    #MOD-570060
                 pmiuser=g_user,   #資料所有者
                 pmigrup=g_grup,   #資料所有者所屬群
                 pmimodu=NULL,     #資料修改日期
                 pmidate=g_today,  #資料建立日期
                 pmiacti='Y',      #有效資料
                 pmiconf='N',       #確認
                  pmi07 = g_smy.smyapr,      #MOD-4A0299
                  pmi06 = '0'               #MOD-4A0299
 
    INSERT INTO pmi_file SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        LET g_success = 'N'
        ROLLBACK WORK
        RETURN
     ELSE
        COMMIT WORK
     END IF
 
    IF g_success = 'Y' AND g_pmi.pmi05 = 'Y' THEN
        #==>分量計價檔複製
        UPDATE z SET pmr01=l_newno
        INSERT INTO pmr_file SELECT * FROM z
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmr_file","","",SQLCA.sqlcode,"","INSERT INTO pmr_file",1)  #No.FUN-660129
            LET g_success = 'N'
        END IF
    END IF
    IF g_success = 'Y' THEN
        #==>單身複製
        UPDATE x SET pmj01=l_newno
        INSERT INTO pmj_file SELECT * FROM x
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmj_file","","",SQLCA.sqlcode,"","INSERT INTO pmj_file",1)  #No.FUN-660129
            LET g_success = 'N'
        ELSE
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        END IF
    END IF
 
    IF g_success = 'Y' THEN
        COMMIT WORK
        LET l_oldno = g_pmi.pmi01
        SELECT pmi_file.* INTO g_pmi.* FROM pmi_file WHERE pmi01 = l_newno
        CALL i255_u()
        #CALL i255_b()   #mark by guanyao160525
        CALL i255_b('i') #add by guanyao160525
    ELSE
        ROLLBACK WORK
    END IF
 
    #SELECT pmi_file.* INTO g_pmi.* FROM pmi_file WHERE pmi01 = l_oldno  #FUN-C80046
 
    CALL i255_show()
 
END FUNCTION
 
FUNCTION i255_out()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   SELECT COUNT(*) INTO l_cnt
     FROM pmj_file
    WHERE pmj01=g_pmi.pmi01
 
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','arm-034',1)
      RETURN
   END IF
 
   CALL cl_wait()
 
   LET l_wc='pmi01="',g_pmi.pmi01,'"'
 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'apmr255'
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
      LET l_wc2 = " '3' 'N' "
   END IF
 
   LET l_cmd = "apmr255",
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                " '",l_wc CLIPPED,"' '3'"    #,l_wc2   #No.TQC-610085 mark   #TQC-740117 add '3'(tm.a)
 
   CALL cl_cmdrun(l_cmd)
 
   ERROR ' '
 
END FUNCTION
#---確認
 
FUNCTION i255_z()
   DEFINE  l_pmj           RECORD LIKE pmj_file.*
 
   IF g_pmi.pmi01 IS NULL THEN RETURN END IF
    SELECT * INTO g_pmi.* FROM pmi_file
     WHERE pmi01=g_pmi.pmi01
   IF g_pmi.pmiconf='X' THEN CALL cl_err(g_pmi.pmiconf,'9024',0) RETURN END IF
   IF g_pmi.pmiconf='N' THEN RETURN END IF
   IF g_pmi.pmi06 = 'S' THEN
      CALL cl_err(g_pmi.pmi06,'apm-030',1)
      RETURN
   END IF
 
   #(廠商+料號+幣別+作業編號)尚有未確認之核價單
   DECLARE i255_chk_pmj CURSOR FOR
       SELECT pmj03,pmj05,pmj10 FROM pmj_file
        WHERE pmj01 = g_pmi.pmi01
 
   INITIALIZE l_pmj.* TO NULL
 
   FOREACH i255_chk_pmj INTO l_pmj.pmj03,l_pmj.pmj05,l_pmj.pmj10
      SELECT pmj01 INTO l_pmj.pmj01 FROM pmi_file,pmj_file
       WHERE pmi03=g_pmi.pmi03
         AND pmi08=g_pmi.pmi08        #No.FUN-550019
         AND pmiconf='N'
         AND pmi01!=g_pmi.pmi01
         AND pmj01=pmi01
         AND pmj03[1,4] != 'MISC'
         AND pmj03 = l_pmj.pmj03
         AND pmj05 = l_pmj.pmj05
         AND pmj10 = l_pmj.pmj10
         AND pmj12=g_pmj12  #No.FUN-670099
      IF NOT cl_null(l_pmj.pmj01) THEN
         LET g_message = NULL
         LET g_message = 'NO:',l_pmj.pmj01,'==>',l_pmj.pmj03 CLIPPED
         LET g_message = g_message CLIPPED
         CALL cl_err(g_message,'apm-262',0)
         RETURN
      END IF
      INITIALIZE l_pmj.* TO NULL
   END FOREACH
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN i255_cl USING g_pmi.pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   LET g_pmi.pmi06 = '0'
 
    UPDATE pmi_file SET pmiconf='N',
                        pmi06 = g_pmi.pmi06
                        #,pmimodu=g_user,     #MOD-920027 add #MOD-C90034 mark
                        #pmidate=g_today      #MOD-920027 add #MOD-C90034 mark
                WHERE pmi01=g_pmi.pmi01
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","pmi_file",g_pmi.pmi01,"","apm-266","","upd pmi_file",1)  #No.FUN-660129
      LET g_success='N'
   END IF
 
   IF g_pmi.pmi07 = 'N' AND g_pmi.pmi06 = '1' THEN
      LET g_pmi.pmi06 = '0'
      UPDATE pmi_file SET pmi06 = g_pmi.pmi06 WHERE pmi01 = g_pmi.pmi01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","pmi_file",g_pmi.pmi01,"","apm-266","","upd pmi_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      LET g_pmi.pmiconf='N'
      #LET g_pmi.pmimodu=g_user  #MOD-920027 add #MOD-C90034 mark
      #LET g_pmi.pmidate=g_today #MOD-920027 add #MOD-C90034 mark
      COMMIT WORK
      #DISPLAY BY NAME g_pmi.pmimodu    #MOD-920027 add #MOD-C90034 mark
      #DISPLAY BY NAME g_pmi.pmidate    #MOD-920027 add #MOD-C90034 mark
      DISPLAY BY NAME g_pmi.pmiconf
      DISPLAY BY NAME g_pmi.pmi06
   ELSE
      LET g_pmi.pmiconf='Y'
      DISPLAY BY NAME g_pmi.pmiconf
      DISPLAY BY NAME g_pmi.pmi06
      ROLLBACK WORK
   END IF
  
   CALL i255_pic()       #FUN-920106
END FUNCTION
 
#FUNCTION i255_x() #FUN-D20025 mark
FUNCTION i255_x(p_type) #FUN-D20025 add
   DEFINE  l_pmj           RECORD LIKE pmj_file.*
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add  
   IF g_pmi.pmi01 IS NULL THEN RETURN END IF
   SELECT * INTO g_pmi.* FROM pmi_file
    WHERE pmi01=g_pmi.pmi01
   IF g_pmi.pmiconf='Y' THEN CALL cl_err('','atm-046',1) RETURN END IF   #No.TQC-740144
   #非開立狀態，不可異動！   
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_pmi.pmiconf='X' THEN RETURN END IF
   ELSE
      IF g_pmi.pmiconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end       
   BEGIN WORK
   LET g_success = 'Y'
    IF g_pmi.pmi06 matches '[Ss1]' THEN          #MOD-4A0299
         CALL cl_err("","mfg3557",0)
         RETURN
   END IF
 
   OPEN i255_cl USING g_pmi.pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_pmi.pmiconf) THEN
      IF g_pmi.pmiconf ='N' THEN
         LET g_pmi.pmiconf='X'
          LET g_pmi.pmi06='9'           #MOD-4A0299
      ELSE
         LET g_pmi.pmiconf='N'
          LET g_pmi.pmi06='0'           #MOD-4A0299
      END IF
      UPDATE pmi_file SET
             pmiconf=g_pmi.pmiconf,
             pmimodu=g_user,
             pmidate=g_today,
              pmi06 =g_pmi.pmi06          #MOD-4A0299
       WHERE pmi01=g_pmi.pmi01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pmi_file",g_pmi.pmi01,"","apm-266","","upd pmi_file",1)  #No.FUN-660129
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pmi.pmi01,'V')
      DISPLAY BY NAME g_pmi.pmiconf
      DISPLAY BY NAME g_pmi.pmi06
   ELSE
      LET g_pmi.pmiconf= g_pmi_t.pmiconf
      LET g_pmi.pmi06 = g_pmi_t.pmi06
      DISPLAY BY NAME g_pmi.pmiconf
      DISPLAY BY NAME g_pmi.pmi06
      ROLLBACK WORK
   END IF
 
   SELECT pmiconf,pmimodu,pmidate
     INTO g_pmi.pmiconf,g_pmi.pmimodu,g_pmi.pmidate FROM pmi_file
    WHERE pmi01=g_pmi.pmi01
 
    DISPLAY BY NAME g_pmi.pmiconf,g_pmi.pmimodu,g_pmi.pmidate
    CALL i255_pic()      #FUN-920106
END FUNCTION
 
FUNCTION i255_pmh13(l_pmh13)  #幣別
    DEFINE l_azi02   LIKE azi_file.azi02             #No.FUN-550019
    DEFINE l_aziacti LIKE azi_file.aziacti           #No.FUN-550019
    DEFINE l_pmh13   LIKE pmh_file.pmh13
 
    LET g_errno = ' '
    SELECT azi02,aziacti INTO l_azi02,l_aziacti      #No.FUN-550019
      FROM azi_file
     WHERE azi01 = l_pmh13
 
    CASE WHEN STATUS=100          LET g_errno = 'mfg3008' #No.7926
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i255_pmj03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01=g_pmj[l_ac].pmj03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmj[l_ac].pmj03[1,4]='MISC' THEN #6808
       LET g_pmj[l_ac].pmj031= l_ima02
       LET g_pmj[l_ac].pmj032= l_ima021
       DISPLAY BY NAME g_pmj[l_ac].pmj031   #No.FUN-830114
       DISPLAY BY NAME g_pmj[l_ac].pmj032   #No.FUN-830114
    END IF
 
END FUNCTION
FUNCTION i255_pmj03_1(p_cmd,l_m)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1   
    DEFINE l_m        LIKE type_file.chr1000
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01=l_m
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmj[l_ac].pmj03[1,4]='MISC' THEN #6808
       LET g_pmj[l_ac].pmj031= l_ima02
       LET g_pmj[l_ac].pmj032= l_ima021
       DISPLAY BY NAME g_pmj[l_ac].pmj031
       DISPLAY BY NAME g_pmj[l_ac].pmj032
    END IF
 
END FUNCTION
 
FUNCTION i255_pmj05(p_cmd)  #幣別
    DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    DEFINE l_azi02   LIKE azi_file.azi02             #No.FUN-550019
    DEFINE l_aziacti LIKE azi_file.aziacti           #No.FUN-550019
 
    LET g_errno = ' '
    SELECT azi02,azi03,aziacti INTO l_azi02,t_azi03,l_aziacti  #No.FUN-550019    #No.CHI-6A0004
        FROM azi_file
        WHERE azi01 = g_pmj[l_ac].pmj05
    CASE WHEN STATUS=100          LET g_errno = 'mfg3008' #No.7926
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i255_1(p_pmr02,p_flag)
DEFINE
    p_pmr02         LIKE pmr_file.pmr02,           #項次
    p_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_pmr           DYNAMIC ARRAY OF RECORD
                    pmr03     LIKE pmr_file.pmr03, #起始數量
                    pmr04     LIKE pmr_file.pmr04, #截止數量
                    pmr05     LIKE pmr_file.pmr05, #單價
                    pmr05t     LIKE pmr_file.pmr05t    #No.FUN-550019
                    END RECORD,
    l_pmj03         LIKE pmj_file.pmj03,           #料件編號
    l_pmj031        LIKE pmj_file.pmj031,          #品名
    l_pmj032        LIKE pmj_file.pmj032,          #規格
    l_pmj05         LIKE pmj_file.pmj05,           #幣別
    l_pmr_t         RECORD
                    pmr03     LIKE pmr_file.pmr03,
                    pmr04     LIKE pmr_file.pmr04,
                    pmr05     LIKE pmr_file.pmr05,
                    pmr05t     LIKE pmr_file.pmr05t    #No.FUN-550019
                    END RECORD,
    l_chr           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_acc,l_n       LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_acc_t         LIKE type_file.num5,      #No.FUN-680136 SMALLINT   #未取消的ARRAY CNT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
 
    IF cl_null(g_pmi.pmi01) THEN RETURN END IF
    IF g_pmi.pmi05 = 'N' THEN
       #分量計價='N'
       CALL cl_err('','apm-286',0)
       RETURN
    END IF
 
    OPEN WINDOW i255c WITH FORM "apm/42f/apmi255c"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmi255c")
 
    DISPLAY g_pmi.pmi01 TO pmr01
 
    IF p_flag ='Y' THEN
       INPUT p_pmr02 FROM pmr02
 
           AFTER FIELD pmr02
              IF NOT cl_null(p_pmr02) THEN
                 SELECT COUNT(*) INTO l_n FROM pmj_file
                  WHERE pmj01=g_pmi.pmi01
                    AND pmj02=p_pmr02
                 IF l_n=0 THEN
                    #無此項次資料，請重新輸入！
                    CALL cl_err('','axm-141',0)
                    NEXT FIELD pmr02
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
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i255c
       RETURN
    END IF
 
    SELECT pmj03,pmj031,pmj032,pmj05
      INTO l_pmj03,l_pmj031,l_pmj032,l_pmj05
      FROM pmj_file
     WHERE pmj01=g_pmi.pmi01
       AND pmj02=p_pmr02
 
    IF cl_null(l_pmj03)  THEN LET l_pmj03 =g_pmj[l_ac].pmj03  END IF
    IF cl_null(l_pmj031) THEN LET l_pmj031=g_pmj[l_ac].pmj031 END IF
    IF cl_null(l_pmj032) THEN LET l_pmj032=g_pmj[l_ac].pmj032 END IF
    IF cl_null(l_pmj05)  THEN LET l_pmj05 =g_pmj[l_ac].pmj05  END IF
    DISPLAY p_pmr02     TO pmr02
    DISPLAY l_pmj03     TO pmj03
    DISPLAY l_pmj031    TO pmj031
    DISPLAY l_pmj032    TO pmj032
    DISPLAY l_pmj05     TO pmj05
    SELECT azi03 INTO t_azi03 FROM azi_file
      WHERE azi01 = l_pmj05
 
    #顯示單身舊值
    LET g_sql = " SELECT pmr03,pmr04,pmr05,pmr05t",     #No.FUN-550019
                "   FROM pmr_file",
                "  WHERE pmr01 = ? ",
                "    AND pmr02 = ? ",
                " ORDER BY 1 "
    PREPARE i255c   FROM g_sql
    DECLARE pmr_curs CURSOR FOR i255c
    CALL l_pmr.clear()
    LET g_cnt = 1
    FOREACH pmr_curs USING g_pmi.pmi01,p_pmr02
       INTO l_pmr[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
            CALL cl_err('pmr_curs:',STATUS,1)
            EXIT FOREACH
        END IF
        IF cl_null(l_pmr[g_cnt].pmr03) THEN
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL l_pmr.deleteElement(g_cnt)
    LET g_rec_bc = g_cnt - 1
 
    IF g_pmi.pmiconf='Y' THEN
       DISPLAY ARRAY l_pmr TO s_pmr.* ATTRIBUTE(COUNT=g_rec_bc,UNBUFFERED)
       #已確認, 不可更改或取消 !
       CLOSE WINDOW i255c
       RETURN
    END IF
 
    LET g_forupd_sql = "SELECT pmr03,pmr04,pmr05,pmr05t FROM pmr_file",  #No.FUN-550019
                       "  WHERE pmr01 = ? AND pmr02 = ? AND pmr03 = ?",
                       "   AND pmr04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i255c_bc CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_acc = 1
    INPUT ARRAY l_pmr WITHOUT DEFAULTS FROM s_pmr.*
          ATTRIBUTE(COUNT=g_rec_bc,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_bc != 0 THEN
                CALL fgl_set_arr_curr(l_acc)
            END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_acc = ARR_CURR()
           LET l_lock_sw = 'N'                   #DEFAULT
           BEGIN WORK
           LET g_success = 'Y'
           OPEN i255_cl USING g_pmi.pmi01
           IF STATUS THEN
              CALL cl_err("OPEN i255_cl:", STATUS, 1)
              CLOSE i255_cl
              LET g_success = 'N'
              RETURN
           END IF
           FETCH i255_cl INTO g_pmi.*  # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_pmi.pmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
              CLOSE i255_cl
              LET g_success = 'N'
              RETURN
           END IF
           IF g_rec_bc >= l_acc THEN
              LET p_cmd='u'
              LET l_pmr_t.* = l_pmr[l_acc].*  #BACKUP
              OPEN i255c_bc USING g_pmi.pmi01,p_pmr02,l_pmr_t.pmr03,l_pmr_t.pmr04
              IF STATUS THEN
                  CALL cl_err("OPEN i255c_bc:", STATUS, 1)
                  LET l_lock_sw = "Y"
              ELSE
                  FETCH i255c_bc INTO l_pmr[l_acc].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock pmr',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
              END IF
           END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE l_pmr[l_acc].* TO NULL      #900423
          LET l_pmr_t.* = l_pmr[l_acc].*         #新輸入資料
          NEXT FIELD pmr03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF cl_null(g_pmj[l_ac].pmj10) THEN
             LET g_pmj[l_ac].pmj10 = " "
          END IF
          INSERT INTO pmr_file(pmr01,pmr02,pmr03,pmr04,pmr05,pmr05t,pmrplant,pmrlegal) #FUN-980006 add pmrplant,pmrlegal
          VALUES(g_pmi.pmi01,p_pmr02,l_pmr[l_acc].pmr03,l_pmr[l_acc].pmr04,
                 l_pmr[l_acc].pmr05,l_pmr[l_acc].pmr05t,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_bc=g_rec_bc+1
          END IF
 
       BEFORE FIELD pmr03               #default 起始數量
          IF cl_null(l_pmr[l_acc].pmr03) THEN
             SELECT MAX(pmr04)+1 INTO l_pmr[l_acc].pmr03
               FROM pmr_file
              WHERE pmr01 = g_pmi.pmi01 #核價單號
                AND pmr02 = p_pmr02     #項次
             IF cl_null(l_pmr[l_acc].pmr03) THEN
                LET l_pmr[l_acc].pmr03 = 1
             END IF
          END IF
          CALL i255c_set_entry_b(p_cmd)       #No.FUN-550019
 
       AFTER FIELD pmr03
          IF p_cmd='a' OR (p_cmd='u' AND l_pmr_t.pmr03 !=l_pmr[l_acc].pmr03) THEN
             SELECT COUNT(*) INTO g_i
               FROM pmr_file
              WHERE pmr01 = g_pmi.pmi01 #核價單號
                AND pmr02 = p_pmr02     #項次
                AND l_pmr[l_acc].pmr03 BETWEEN pmr03 AND pmr04
             IF g_i >=1 THEN
                #起始數量重疊到已輸入的起迄數量
                CALL cl_err('','axm-362',0)
                LET l_pmr[l_acc].pmr03 = l_pmr_t.pmr03
                NEXT FIELD pmr03
             END IF
          END IF
          CALL i255c_set_no_entry_b(p_cmd)       #No.FUN-550019
 
       AFTER FIELD pmr04 #截止數量
          IF NOT cl_null(l_pmr[l_acc].pmr03) AND NOT cl_null(l_pmr[l_acc].pmr04) THEN
             IF p_cmd='a' OR (p_cmd='u' AND (l_pmr_t.pmr03 !=l_pmr[l_acc].pmr03 OR
                l_pmr_t.pmr04 !=l_pmr[l_acc].pmr04)) THEN
                SELECT COUNT(*) INTO l_n
                  FROM pmr_file
                 WHERE pmr01=g_pmi.pmi01
                   AND pmr02=p_pmr02
                   AND pmr03=l_pmr[l_acc].pmr03
                   AND pmr04=l_pmr[l_acc].pmr04
                IF l_n > 0  THEN
                   #資料重覆，請重新輸入!
                   CALL cl_err('sel-pmr','axm-298',0)
                   NEXT FIELD pmr04
                END IF
             END IF
          END IF
 
       AFTER FIELD pmr05
          IF NOT cl_null(l_pmr[l_ac].pmr05) THEN
             LET l_pmr[l_ac].pmr05 = cl_digcut(l_pmr[l_ac].pmr05,t_azi03)   #No.CHI-6A0004
          END IF
 
       AFTER FIELD pmr05t
          IF NOT cl_null(l_pmr[l_ac].pmr05t) THEN
             LET l_pmr[l_ac].pmr05t = cl_digcut(l_pmr[l_ac].pmr05t,t_azi03)  #No.CHI-6A0004
             LET l_pmr[l_ac].pmr05 = l_pmr[l_ac].pmr05t / (1 + g_pmi.pmi081/100)
             LET l_pmr[l_ac].pmr05 = cl_digcut(l_pmr[l_ac].pmr05,t_azi03)    #No.CHI-6A0004
          END IF
 
        BEFORE DELETE                            #是否取消單身
           IF l_pmr_t.pmr03 > 0 AND l_pmr_t.pmr04 > 0 THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
 
 
              DELETE FROM pmr_file
               WHERE pmr01 = g_pmi.pmi01
                 AND pmr02 = p_pmr02
                 AND pmr03 = l_pmr_t.pmr03
                 AND pmr04 = l_pmr_t.pmr04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_success = 'N'
                 CANCEL DELETE
              ELSE
                 LET g_rec_bc=g_rec_bc-1
              END IF
           END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_pmr[l_acc].* = l_pmr_t.*
             CLOSE i255c_bc
             LET g_success = 'N'
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(l_pmr[l_acc].pmr03,-263,1)
             LET l_pmr[l_acc].* = l_pmr_t.*
          ELSE
             UPDATE pmr_file SET pmr01=g_pmi.pmi01,
                                 pmr02=p_pmr02,
                                 pmr03=l_pmr[l_acc].pmr03,
                                 pmr04=l_pmr[l_acc].pmr04,
                                 pmr05=l_pmr[l_acc].pmr05,
                                 pmr05t=l_pmr[l_acc].pmr05t    #No.FUN-550019
              WHERE pmr01=g_pmi.pmi01
                AND pmr02=p_pmr02
                AND pmr03=l_pmr_t.pmr03
                AND pmr04=l_pmr_t.pmr04
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                LET l_pmr[l_acc].* = l_pmr_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_acc = ARR_CURR()
          LET l_acc_t = l_acc
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                 LET l_pmr[l_acc].* = l_pmr_t.*
             END IF
             CLOSE i255c_bc
             ROLLBACK WORK
             LET g_success = 'N'
             EXIT INPUT
          END IF
          CLOSE i255c_bc
          COMMIT WORK
 
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
    CLOSE i255c_bc
    CLOSE WINDOW i255c
 
END FUNCTION
 
FUNCTION i255_b_g()
  DEFINE  l_pmx           RECORD LIKE pmx_file.*, #詢價單單身
          l_pmj           RECORD LIKE pmj_file.*, #核價單單身
          l_ima44         LIKE ima_file.ima44,    #採購單位
          l_pmx09_fac     LIKE ima_file.ima31_fac,  #No.FUN-680136 dec(16,8)   #詢價單位/庫存單位轉換率
          l_pmw04         LIKE pmw_file.pmw04,
          l_pmw01         LIKE pmw_file.pmw01,
          l_sql           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
          l_pmj01         LIKE pmj_file.pmj01,
          l_lineno        LIKE type_file.num5     #No.FUN-680136 SMALLINT      #項次
  DEFINE  l_pmhacti       LIKE pmh_file.pmhacti   #MOD-930327
 
    SELECT COUNT(*) INTO g_cnt
      FROM pmj_file
     WHERE pmj01 = g_pmi.pmi01
    IF g_cnt > 0 THEN RETURN END IF
 
    #單身輸入方式:(1)直接輸入 (2)詢價單轉入
    #CALL cl_conf2(0,0,'apm-287','12') RETURNING g_i  #mark by guanyao160525
    CALL cl_conf2(0,0,'cpm-015','123') RETURNING g_i  #add by guanyao160524
    IF g_i = 1 THEN RETURN END IF
    #str----add by guanyao160525
    IF g_i = 3 THEN 
       CALL i255_pl('a')
    ELSE 
    #end----add by guanyao160525
    OPEN WINDOW i255b_w WITH FORM "apm/42f/apmi255b"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmi255b")
 
    CONSTRUCT BY NAME tm.wc ON pmw01,pmw06
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ## No.TQC-640068 原順序顛倒,調整回來即可
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmw01)    #詢價單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmw02"                 #MOD-640441
                  LET g_qryparam.default1 = l_pmw01,'',''
                  LET g_qryparam.arg1 = g_pmi.pmi03              #MOD-640441 add
                  LET g_qryparam.arg2 = g_pmi.pmi08              #MOD-640441 add
                  LET g_qryparam.arg3 = g_pmj12     #No.FUN-670099 
                  CALL cl_create_qry() RETURNING l_pmw01
                  DISPLAY l_pmw01 TO pmw01
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
       LET INT_FLAG = 0
       CLOSE WINDOW i255b_w
       RETURN
    END IF
    CLOSE WINDOW i255b_w
    LET l_sql = "SELECT pmx_file.*,pmw04 ",
                "  FROM pmw_file,pmx_file",
                " WHERE ",tm.wc CLIPPED,
                "   AND pmw01 = pmx01 ",
                "   AND pmx12 = '",g_pmi.pmi03,"'", #廠商編號     #FUN-650191 pmw03->pmx12
                "   AND pmw05 = '",g_pmi.pmi08,"'", #稅別    No.FUN-550019
                "   AND pmx11 = '",g_pmj12,"'", #No.FUN-740041
                 "   AND pmwacti = 'Y' ", #MOD-530570
                " ORDER BY pmx01,pmx02 "
 
    PREPARE i255b_pre FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('i255b_pre:',SQLCA.sqlcode,1)
       RETURN
    END IF
 
    DECLARE i255b_curs CURSOR FOR i255b_pre
 
    BEGIN WORK
    LET l_lineno = 0
    INITIALIZE l_pmx.* TO NULL
    INITIALIZE l_pmj.* TO NULL
    LET l_pmw04 = NULL
    LET g_success = 'Y'
 
    FOREACH i255b_curs INTO l_pmx.*,l_pmw04
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima44 INTO l_ima44
         FROM ima_file
        WHERE ima01 = l_pmx.pmx08
       IF l_pmx.pmx09 <> l_ima44 THEN #詢價單位<>採購單位
          #檢查該詢價單位與採購單位是否可以轉換
          CALL s_umfchk(l_pmx.pmx08,l_pmx.pmx09,l_ima44)
               RETURNING g_i,l_pmx09_fac
          IF g_i = 1 THEN
             #單位無法與料件主檔之採購單位轉換,請重新輸入
             CALL cl_err('','apm-288',1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       ELSE
          LET l_pmx09_fac = 1
       END IF
 
      #LET l_lineno= l_lineno + 1     #MOD-C30260 mark
       LET l_pmj.pmj01  = g_pmi.pmi01
      #MOD-C30260 -- add -- begin
       SELECT MAX(pmj02)+1 INTO l_lineno FROM pmj_file 
        WHERE pmj01 = g_pmi.pmi01
       IF cl_null(l_lineno) THEN
          LET l_lineno = 1
       END IF
      #MOD-C30260 -- add -- end
       LET l_pmj.pmj02  = l_lineno         #項次
       LET l_pmj.pmj03  = l_pmx.pmx08
       LET l_pmj.pmj031 = l_pmx.pmx081
       LET l_pmj.pmj032 = l_pmx.pmx082
       LET l_pmj.pmj11 =  l_pmx.pmx11
       LET l_pmj.pmj04  = ''
       LET l_pmj.pmj05  = l_pmw04
       LET l_pmj.pmj07  = l_pmx.pmx06/l_pmx09_fac
       LET l_pmj.pmj07t = l_pmx.pmx06t/l_pmx09_fac     #No.FUN-550019
       LET l_pmj.pmj09  = l_pmx.pmx04
       LET l_pmj.pmj10  = l_pmx.pmx10  #No.FUN-670099
       LET l_pmj.pmj12  = l_pmx.pmx11  #No.FUN-670099
       LET l_pmj.pmj13  = l_pmx.pmx13  #No.FUN-810017
       LET l_pmj.pmjplant  = g_plant  #FUN-980006 add
       LET l_pmj.pmjlegal  = g_legal  #FUN-980006 add
       SELECT pmh06,pmh12,pmh19,pmhacti  #No.FUN-610018   #MOD-930327 add pmhacti
         INTO l_pmj.pmj08,l_pmj.pmj06,l_pmj.pmj06t,l_pmhacti    #No.FUN-610018   #MOD-930327 add pmhacti
         FROM pmh_file
        WHERE pmh01 = l_pmj.pmj03
          AND pmh02 = g_pmi.pmi03
          AND pmh13 = l_pmj.pmj05
          AND pmh21 = l_pmj.pmj10  #No.FUN-670099
          AND pmh22 = l_pmj.pmj12  #No.FUN-670099
          AND pmh23 = l_pmj.pmj13  #No.FUN-870124
       IF l_pmhacti = 'N' THEN 
          CONTINUE FOREACH
       END IF 
       IF cl_null(l_pmj.pmj06) THEN LET l_pmj.pmj06=0 END IF
       IF cl_null(l_pmj.pmj08) THEN LET l_pmj.pmj08=' ' END IF
       IF cl_null(l_pmj.pmj06t) THEN
          LET l_pmj.pmj06t = l_pmj.pmj06 * (1 + g_pmi.pmi081/100)
       END IF
       IF cl_null(l_pmj.pmj06t) THEN LET l_pmj.pmj06t=0 END IF
       SELECT COUNT(*) INTO g_cnt FROM pmj_file
        WHERE pmj01 = l_pmj.pmj01
          AND pmj03 = l_pmj.pmj03
          AND pmj05 = l_pmj.pmj05
          AND pmj10 = l_pmj.pmj10
          AND pmj11 = l_pmj.pmj11
          AND pmj12 = l_pmj.pmj12  #No.FUN-670099
       IF g_cnt >= 1 THEN
          #不可同時存在相同的"料件編號"+"幣別"+"作業編號"
          #所以當詢價單是分量計價的資料時,只抓到第一筆
          INITIALIZE l_pmx.* TO NULL
          INITIALIZE l_pmj.* TO NULL
          LET l_pmw04 = NULL
          CONTINUE FOREACH
       END IF
 
       LET l_pmj01 = NULL
       SELECT pmj01 INTO l_pmj01 FROM pmi_file,pmj_file
        WHERE pmi03=g_pmi.pmi03
          AND pmi08=g_pmi.pmi08        #No.FUN-550019
          AND pmiconf='N'
          AND pmi01!=g_pmi.pmi01
          AND pmj01=pmi01
          AND pmj03=l_pmj.pmj03
          AND pmj03[1,4] != 'MISC'
          AND pmj05=l_pmj.pmj05
          AND pmj10=l_pmj.pmj10
          AND pmj11=l_pmj.pmj11
          AND pmj12=l_pmj.pmj12  #No.FUN-670099
       IF NOT cl_null(l_pmj01) THEN
          LET g_message = NULL
          LET g_message = 'NO:',l_pmj01,'==>',l_pmj.pmj03 CLIPPED
          LET g_message = g_message CLIPPED
          #(廠商+料號+幣別+作業編號)尚有未確認之核價單
          CALL cl_err(g_message,'apm-262',1)
          #詢價單轉入未成功!
          CALL cl_err('','apm-128',1)
 
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       INSERT INTO pmj_file VALUES (l_pmj.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","pmj_file",l_pmj.pmj01,l_pmj.pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       INITIALIZE l_pmx.* TO NULL
       INITIALIZE l_pmj.* TO NULL
       LET l_pmw04 = NULL
    END FOREACH
 
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    CALL i255_show()
    END IF 
 
END FUNCTION
 
FUNCTION i255_ef()
 
  CALL apmi255sub_y_chk(g_pmi.pmi01)
  IF g_success = "N" THEN
     RETURN
  END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
   IF aws_efcli2(base.TypeInfo.create(g_pmi),base.TypeInfo.create(g_pmj),'','','','')
   THEN
      LET g_success = 'Y'
      LET g_pmi.pmi06 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_pmi.pmi06
   ELSE
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION i255_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pmi01",TRUE)
    END IF
    CALL cl_set_comp_entry("pmi05",TRUE) #MOD-530602 add pmi05
 
END FUNCTION
 
FUNCTION i255_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680136 VARCHAR(1)
  DEFINE l_n     LIKE type_file.num5   #MOD-530602  #No.FUN-680136 SMALLINT
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pmi01",FALSE)
    END IF
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n
         FROM pmj_file
        WHERE pmj01 = g_pmi.pmi01
       IF l_n >=1 THEN
          CALL cl_set_comp_entry("pmi05",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i255_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmj03) THEN
       CALL cl_set_comp_entry("pmj031,pmj032",TRUE)
    END IF
 
    IF INFIELD(pmj05) THEN
       CALL cl_set_comp_entry("pmj07,pmj07t",TRUE)   #No.FUN-550019  #FUN-560204 拿掉pmj08
    END IF
 
    CALL cl_set_comp_entry("pmj07,pmj07t",TRUE)     #No.FUN-610018
 
END FUNCTION
 
FUNCTION i255_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmj03) THEN
       IF g_pmj[l_ac].pmj03[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("pmj031,pmj032",FALSE)
       END IF
    END IF
 
    IF INFIELD(pmj05) THEN
       IF g_pmi.pmi05 = 'Y' THEN
          CALL cl_set_comp_entry("pmj07,pmj07t",FALSE)  #No.FUN-550019 #FUN-560204 拿掉pmj08
       END IF
    END IF
 
    IF g_pmi.pmi05 = 'Y' THEN
       CALL cl_set_comp_entry("pmj07,pmj07t",FALSE)  #No.FUN-550019 #FUN-560204 拿掉pmj08
    ELSE
       IF g_gec07 = 'N' THEN           #No.FUN-560102
          CALL cl_set_comp_entry("pmj07t",FALSE)
       ELSE
          CALL cl_set_comp_entry("pmj07",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i255c_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmr03) THEN
       CALL cl_set_comp_entry("pmr05,pmr05t",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i255c_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF g_gec07 = 'Y' THEN             #No.FUN-560102
       CALL cl_set_comp_entry("pmr05",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i255_pmi09(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_pmi.pmi09
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
FUNCTION i255_pmj06_def()  #帶出料件廠商之資料
 DEFINE l_cnt      LIKE type_file.num5
 
    IF cl_null(g_pmj[l_ac].pmj10) THEN
       LET g_pmj[l_ac].pmj10 = ' '
       LET g_pmj[l_ac].ecd02 = ' '     #No.FUN-930061
    END IF
 
    #先找看有沒有以確認的估價檔，若沒有則default pmh_file
    SELECT COUNT(*) INTO l_cnt FROM pmi_file,pmj_file
       WHERE pmj01=pmi01 AND pmiconf = 'Y'
          AND pmi03 = g_pmi.pmi03 AND pmj05 = g_pmj[l_ac].pmj05
          AND pmj03 = g_pmj[l_ac].pmj03
          AND pmj11 = g_pmj[l_ac].pmj11
          AND pmj10 = g_pmj[l_ac].pmj10  #MOD-960182
          AND pmj12 = g_pmj12            #MOD-960182
          AND pmj13 = g_pmj[l_ac].pmj13  #MOD-960182
 
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt <= 0 THEN
       IF cl_null(g_pmj[l_ac].pmj10) THEN
          LET g_pmj[l_ac].pmj10 = ' '
          LET g_pmj[l_ac].ecd02 = ' '     #No.FUN-930061
       END IF
       DECLARE pmj06_cur1 CURSOR FOR
          SELECT pmh04,pmh06,pmh12,pmh19,pmh13       
             FROM pmh_file
             WHERE pmh01 = g_pmj[l_ac].pmj03
               AND pmh02=g_pmi.pmi03
               AND pmh13 = g_pmj[l_ac].pmj05
               AND pmh21 = g_pmj[l_ac].pmj10  #No.MOD-840074
               AND pmh22 = g_pmj12            #No.MOD-840074
               AND pmh23 = g_pmj[l_ac].pmj13  #No.FUN-870124
               AND pmhacti = 'Y'                                           #CHI-910021
       OPEN pmj06_cur1
       FETCH pmj06_cur1 INTO g_pmj[l_ac].pmj04,g_pmj[l_ac].pmj08,
                             g_pmj[l_ac].pmj06,
                             g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj05
       CLOSE pmj06_cur1
    ELSE 
       DECLARE pmj06_cur2 CURSOR FOR
          SELECT pmj04,pmj09,pmj07,pmj07t,pmj05
             FROM pmj_file,pmi_file
             WHERE pmj01=pmi01 AND pmiconf = 'Y'
                AND pmi03 = g_pmi.pmi03 AND pmj05 = g_pmj[l_ac].pmj05
                AND pmj03 = g_pmj[l_ac].pmj03
                AND pmj10 = g_pmj[l_ac].pmj10  #MOD-960182
                AND pmj11 = g_pmj[l_ac].pmj11
                AND pmj12 = g_pmj12            #MOD-960182
                AND pmj13 = g_pmj[l_ac].pmj13  #MOD-960182
                AND pmj09 = (SELECT MAX(pmj09) FROM pmi_file,pmj_file
                WHERE pmj01=pmi01 AND pmiconf = 'Y'
                AND pmi03 = g_pmi.pmi03 AND pmj05 = g_pmj[l_ac].pmj05
                AND pmj03 = g_pmj[l_ac].pmj03
                AND pmj11 = g_pmj[l_ac].pmj11
                AND pmj10 = g_pmj[l_ac].pmj10  #MOD-960182
                AND pmj12 = g_pmj12            #MOD-960182
                AND pmj13 = g_pmj[l_ac].pmj13) #MOD-960182
                ORDER BY pmi01 desc
       OPEN pmj06_cur2
       FETCH pmj06_cur2 INTO g_pmj[l_ac].pmj04,g_pmj[l_ac].pmj08,
                             g_pmj[l_ac].pmj06,
                             g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj05
       CLOSE pmj06_cur2 
    END IF

    #darcy:2023/07/29 s---
    # 根据料号计算最新一笔的核价金额
    DECLARE pmj06_cur3 CURSOR FOR
        SELECT pmi03,pmi08,pmj05,pmj09,pmj07,pmj07t
            FROM pmj_file,pmi_file
            WHERE pmj01=pmi01 AND pmiconf = 'Y'
            AND pmj03 = g_pmj[l_ac].pmj03
            AND pmj10 = g_pmj[l_ac].pmj10
            AND pmj12 = g_pmj12
            AND pmj13 = g_pmj[l_ac].pmj13
            AND pmj09 = (SELECT MAX(pmj09) FROM pmi_file,pmj_file
            WHERE pmj01=pmi01 AND pmiconf = 'Y'
            AND pmj03 = g_pmj[l_ac].pmj03
            AND pmj10 = g_pmj[l_ac].pmj10
            AND pmj12 = g_pmj12
            AND pmj13 = g_pmj[l_ac].pmj13)
            ORDER BY pmi01 desc
    OPEN pmj06_cur3
    FETCH pmj06_cur3 INTO g_pmj[l_ac].ta_pmj01,g_pmj[l_ac].ta_pmj02,g_pmj[l_ac].ta_pmj03,
                            g_pmj[l_ac].ta_pmj04,g_pmj[l_ac].ta_pmj05,g_pmj[l_ac].ta_pmj06
    CLOSE pmj06_cur3
    #darcy:2023/07/29 e---
 
   
     IF cl_null(g_pmj[l_ac].pmj06) THEN
        LET g_pmj[l_ac].pmj06 = 0
     END IF
   
     IF cl_null(g_pmj[l_ac].pmj08) THEN
        LET g_pmj[l_ac].pmj08 = ' '
     END IF
     #要重show,不然會影響ON ROW CHANGE
     DISPLAY g_pmj[l_ac].pmj04,g_pmj[l_ac].pmj08,g_pmj[l_ac].pmj06,
             g_pmj[l_ac].pmj06t,g_pmj[l_ac].pmj05
          TO pmj04,pmj08,pmj06,pmj06t,pmj05
   
     IF cl_null(g_pmj[l_ac].pmj06t) THEN
        LET g_pmj[l_ac].pmj06t = g_pmj[l_ac].pmj06 * ( 1 + g_pmi.pmi081/100)
     END IF
END FUNCTION
 
FUNCTION i255_pic()
 
 IF g_pmi.pmiconf='X' THEN
    LET g_chr='Y'
 ELSE
    LET g_chr='N'
 END IF
 
 IF g_pmi.pmi06='1' THEN
    LET g_chr2='Y'
 ELSE
    LET g_chr2='N'
 END IF
 
 CALL cl_set_field_pic(g_pmi.pmiconf,g_chr2,"",g_chr3,g_chr,g_pmi.pmiacti)
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#str----add by guanyao160525
FUNCTION i255_pl(p_cmd)
DEFINE l_price     LIKE type_file.num15_3
DEFINE l_sql       STRING 
DEFINE l_pmj       RECORD LIKE pmj_file.*
DEFINE l_c,l_b     LIKE type_file.num5
DEFINE l_pmj01     LIKE pmj_file.pmj01
DEFINE p_cmd       LIKE type_file.chr1
    IF cl_null(g_pmi.pmi01) THEN 
       RETURN 
    END IF 

    LET l_c = 0
    SELECT COUNT(*) INTO l_c
      FROM pmj_file
     WHERE pmj01 = g_pmi.pmi01
    IF l_c > 0 THEN RETURN END IF
    LET l_c = 0
    SELECT COUNT(*) INTO l_c FROM pmh_file 
     WHERE pmh02 = g_pmi.pmi03
       AND pmhacti = 'Y'
       AND pmh22 = g_argv3
    IF cl_null(l_c) OR l_c = 0 THEN 
       CALL cl_err('','cpm-014',0)
       RETURN 
    END IF 
    OPEN WINDOW i255_w_2 WITH FORM "cpm/42f/cpmi255_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("cpmi255_1")
 
    DISPLAY 0 TO price
 
    INPUT l_price FROM price 
 
       AFTER FIELD price
          IF NOT cl_null(l_price) THEN
             IF l_price <-100 THEN
                CALL cl_err('','cpm-013',0)
                NEXT FIELD price
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
       LET INT_FLAG=0
       CLOSE WINDOW i255_w_2
       RETURN
    END IF
    CLOSE WINDOW i255_w_2

    IF cl_null(l_price) THEN
       LET l_price = 0
    END IF  
    LET g_success = 'Y'
    BEGIN WORK 

    LET l_sql = " SELECT pmh01,ima02,ima021,pmh04,pmh13,pmh12,pmh19,pmh06",
                "   FROM pmh_file LEFT JOIN ima_file ON ima01 = pmh01",
                "  WHERE pmh02 = '",g_pmi.pmi03,"'",
                "    AND pmhacti = 'Y'",
                "    AND pmh22 = '",g_argv3,"'"
    PREPARE i255_pmh FROM l_sql
 
    DECLARE pmh_cs CURSOR WITH HOLD FOR i255_pmh
 
    LET l_b = 1
    FOREACH pmh_cs INTO l_pmj.pmj03,l_pmj.pmj031,l_pmj.pmj032,l_pmj.pmj04,
                        l_pmj.pmj05,l_pmj.pmj06,l_pmj.pmj06t,l_pmj.pmj08
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF

    LET l_pmj.pmj01 = g_pmi.pmi01
    LET l_pmj.pmj02 =l_b
    LET l_pmj.pmj10=' '
    IF g_argv3 = "1" THEN
       LET l_pmj.pmj12 ='1'
    ELSE
       LET l_pmj.pmj12 ='2' 
    END IF 
    LET l_pmj.pmj13 = " "
    IF l_pmj.pmj12 = '2' AND s_industry('icd') THEN
       LET l_pmj.pmjicd14 = '0'
    END IF 
    LET l_pmj.pmj06 = (1+l_price/100)*l_pmj.pmj06
    LET l_pmj.pmj06t = (1+l_price/100)*l_pmj.pmj06t
    LET l_pmj.pmj09 = ' '
    
    LET l_pmj01 = NULL
    SELECT pmj01 INTO l_pmj01 FROM pmi_file,pmj_file
     WHERE pmi03=g_pmi.pmi03
       AND pmi08=g_pmi.pmi08        #No.FUN-550019
       AND pmiconf='N'
       AND pmi01!=g_pmi.pmi01
       AND pmj01=pmi01
       AND pmj03=l_pmj.pmj03
       AND pmj03[1,4] != 'MISC'
       AND pmj05=l_pmj.pmj05
       AND pmj10=l_pmj.pmj10
       AND pmj11=l_pmj.pmj11
       AND pmj12=l_pmj.pmj12  #No.FUN-670099
    IF NOT cl_null(l_pmj01) THEN
       LET g_message = NULL
       LET g_message = 'NO:',l_pmj01,'==>',l_pmj.pmj03 CLIPPED
       LET g_message = g_message CLIPPED
       #(廠商+料號+幣別+作業編號)尚有未確認之核價單
       CALL cl_err(g_message,'apm-262',1)
       #詢價單轉入未成功!
       CALL cl_err('','apm-128',1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
    INSERT INTO pmj_file(pmj01,pmj02,pmj03,pmj031,pmj032,pmj11,pmj04,pmj05,
                         pmj06,pmj06t,pmj07,pmj07t,pmj09,pmj10,pmj08,      
                         pmj12,pmj13,pmjicd14,pmjplant,pmjlegal) 
    VALUES(g_pmi.pmi01,l_pmj.pmj02,
           l_pmj.pmj03,l_pmj.pmj031,
           l_pmj.pmj032,l_pmj.pmj11,l_pmj.pmj04,
           l_pmj.pmj05,l_pmj.pmj06,
           l_pmj.pmj06t,'0',   
           '0',l_pmj.pmj09,    
           l_pmj.pmj10,l_pmj.pmj08,
           l_pmj.pmj12,l_pmj.pmj13,l_pmj.pmjicd14,g_plant,g_legal)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL s_errmsg("ins pmj_file",g_pmi.pmi01||';'||l_pmj.pmj02,'',SQLCA.sqlcode,1)
       LET g_success = 'N' 
    END IF    
    LET l_b = l_b+1
    INITIALIZE l_pmj.* TO NULL
    END FOREACH 

    IF g_success = 'Y' THEN
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
       CALL s_showmsg()
    END IF 
    CALL i255_show()
    CALL i255_b('i')
   
END FUNCTION 
#end----add by guanyao160525
