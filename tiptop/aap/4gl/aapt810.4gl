# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt810.4gl
# Descriptions...: 信用狀到貨作業
# Date & Author..: 95/11/10 By Roger
# Modify.........: No:7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No:8916 03/12/16 By ching 取消確認,不必開窗給條件
# Modify.........: No.MOD-470303 04/07/28 By ching INPUT CONSTRUCT  順序錯誤
# Modify.........: No.MOD-470303 04/07/28 By ching q_rvv 參數傳遞錯誤
# Modify.........: No.MOD-470303 04/07/28 By ching 無法產生單身
# Modify.........: No.MOD-490264 04/09/13 By ching show user,grup,modu.date,acti
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0073 04/12/14 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530129 05/03/17 By Kitty UN-AP改UNAP
# Modify.........: No.MOD-530732 05/03/28 By Nicola 會計科目做部門科目允許/拒絕檢查
#                                                   單身科目可開窗
# Modify.........: No.MOD-530729 05/03/28 By Nicola 單身原幣/本幣 所有單價,金額未作正確小數取位
# Modify.........: No.MOD-530678 05/03/28 By Nicola 分攤時，分錄已存在詢問視窗會出現二次
# Modify.........: No.MOD-530669 05/03/29 By Nicola 匯差金額未自動計算
# Modify.........: No.MOD-530727 05/03/29 By Nicola 廠商為"關係人"才產生異動碼四
# Modify.........: No.MOD-530827 05/03/29 By Nicola 產生分錄時廠商編號帶錯
# Modify.........: No.MOD-550098 05/06/06 By ching  fix產生分錄問題
# Modify.........: No.FUN-560070 05/06/18 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.FUN-560099 05/06/20 By Smapmin 自動編號
# Modify.........: No.FUN-560266 05/06/30 By Nicola t810_g_b()中，不需要將預購單組在sql中
# Modify.........: No.FUN-580141 05/09/12 By Smapmin 新增開窗功能
# Modify.........: No.MOD-590394 05/10/20 By Smapmin 金額抓取錯誤.
#            key完到單編號後,抓 aapt820,'到單匯率'/'到單原幣'/'應還本幣' default
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5B0176 05/11/21 BY yiting 確認時 詢問是否確認,按放棄程式當出
# Modify.........: No.MOD-5A0255 05/11/24 By Smapmin 單身輸入完後,若單身原幣金額合計不等於單頭到貨原幣,則開窗詢問是否UPDATE
# Modify.........: No.TQC-5C0028 05/12/13 By Smapmin 自備比率為100時,應還本幣要設為noentry
#                                                    分錄中預付費用科目幣別為 aza17 匯率為 1
#                                                    執行完分攤後請修改分攤合計重新顯示
#                                                    分攤確定訊息修改為"是否做分攤"
#                                                    修改SQL條件
# Modify.........: No.TQC-5C0016 05/12/13 By Smapmin 轉到單時要開窗詢問到單編號
# Modify.........: No.FUN-5C0015 05/12/20 By alana call s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.MOD-630117 06/03/30 By Smapmin 主要是防堵到貨轉到單時 alh30 會與 alk01 一致,所以在到貨單 aapt810 取消確認時增加刪除 alh 的條件
#                                                    相反的,到單再到貨的流程 alh30 是不會有資料的
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640557 06/04/25 By Smapmin aap-776的錯誤判斷移到AFTER FIELD ale17
# Modify.........: No.TQC-650011 06/05/05 By Smapmin 新增INSERT INTO apg_file,aph_file,nme_file
# Modify.........: No.TQC-660072 06/06/14 By Dido 補充TQC-630070
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670060 06/08/01 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/09 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680029 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0055 06/10/26 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By hellen 本原幣取位修改
# Modify.........: No.FUN-6B0033 06/11/15 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-690048 06/12/01 By Smapmin 自動計算alk39(到單本幣)與alk27(匯差應攤)
# Modify.........: No.MOD-6B0127 06/12/05 By Smapmin 計算稅額
# Modify.........: No.CHI-690070 06/12/06 By Smapmin 取消TQC-650011所修改的部份,另付款處理方式只有"轉應付帳款".
# Modify.........: No.MOD-690157 06/12/06 By Smapmin 回寫alb12其到貨數量應該排除其樣品的收貨入庫數量.
# Modify.........: No.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.MOD-720056 07/02/07 By Smapmin 自動產生單身時,金額應為單價*數量
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-720018 07/03/19 By jamie 增加"多發票"action
# Modify.........: No.FUN-730064 07/03/30 By sherry 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By lora 會計科目加帳套
# Modify.........: No.TQC-750034 07/05/09 By Ray 會計科目設置中不使用多套帳時，科目而沒有隱藏
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.MOD-770003 07/07/05 By Smapmin 重新顯示應攤合計
# Modify.........: No.TQC-770081 07/07/16 By Smapmin 修改立帳金額
# Modify.........: No.MOD-790060 07/09/13 By Smapmin 分攤單價/金額做幣別位數取位
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier apb34賦初值'N'
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-810016 08/02/19 By Judy 寫入多帳期資料(apc_file)
# Modify.........: No.MOD-820158 08/02/26 By Smapmin 變數使用錯誤
# Modify.........: No.MOD-830044 08/03/06 By Smapmin 輸入到單單號時,抓取到單借方科目(alh41)來當預付科目(alk40)
# Modify.........: No.MOD-830072 08/03/10 By Smapmin列印次數default為0
# Modify.........: No.MOD-830085 08/03/11 By Smapmin 分錄底稿的廠商編號/簡稱未帶出
# Modify.........: No.FUN-850038 08/05/12 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-850175 08/05/20 By Sarah t810_del_apa()段DELETE alh_file增加條件alh72(傳票號碼)IS NULL
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT,INPUT ARRAY段漏了ON IDLE控制
# Modify.........: No.MOD-870330 08/08/05 By Sarah 匯率(alk12,alk37,apk13)增加以azi07取位
# Modify.........: No.MOD-880094 08/08/13 By Sarah t810_ins_apa()段,當pma11!='4'時,增加UPDATE apa_file的apa35f,apa35為apa34f,apa34
# Modify.........: No.CHI-880038 08/09/02 By Sarah t810_g_gl_1()段,增加產生稅額分錄
# Modify.........: No.CHI-830037 08/03/28 By sherry 將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱" 
# Modify.........: No.CHI-8C0005 08/12/10 By Sarah 當使用利潤中心時(aaz90=Y),CALL s_chkdept()允許/拒絕部門的判斷請改用成本中心
# Modify.........: No.FUN-8C0106 09/01/05 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD 
# Modify.........: No.MOD-940261 09/04/20 By Sarah 當單頭部門+單身科目要檢查允許/拒絕部門,需先判斷單身有沒有資料
# Modify.........: No.MOD-940196 09/04/21 By Sarah
#                  1.單身使用批次產生功能,若使用"收貨單之到貨單號範圍"無法正常轉出單身
#                  2.直接在單身輸入入庫單不會帶出多單位數量
#                  3.會計科目設定STOCK無法正常產生分錄
# Modify.........: No.MOD-960017 09/06/09 By baofei t810_bu_alb()段計算tot1和tot2時，不需要過濾單號ale16和項次ale17                 
# Modify.........: No.MOD-960107 09/06/09 By baofei t810_t()段，回寫alk07的值應為arr_no                                             
# Modify.........: No.MOD-960269 09/06/23 By mike 修改aapt810.4gl,將FUNCTION t810_ins_apa()中給予apa31f值的程式段改回               
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-960141 09/08/12 By lutingting GP5.2修改,去除apaplant,apbplant欄位
# Modify.........: No.FUN-980076 09/08/27 By TSD.apple    GP5.2架構重整，移除xxxplant 
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alkplant該為alk97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/14 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980093 09/09/23 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/25 By hongmei 抓apz63欄位寫入apa77
# Modify.........: No.FUN-990014 09/09/08 By hongmei 先抓apyvcode申報統編，若無則將apz63的值寫入apa77/apk32
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: NO.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录 
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting q_rvv2增傳參數營運中心,拋轉apb時給欄位apb37賦值
# Modify.........: No.TQC-9B0018 09/11/04 By xiaofeizhu 標準SQL修改
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No:FUN-990053 09/09/16 By hongmei s_chkban前先检查aza21 = 'Y' 
# Modify.........: No:FUN-9C0077 10/01/07 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40072 10/04/15 By Dido 匯損應獨立,不可納入其他金額中
# Modify.........: No:FUN-A40003 10/05/21 By wujie   增加apa79，预设为N
# Modify.........: No:FUN-A60024 10/06/12 By wujie   调整apa79的值为0 
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90085 10/09/13 By Dido 多發票視窗異動需同步調整此部分 
# Modify.........: No:MOD-AA0028 10/10/07 By Dido 若為多發票,寫入 apa08 應為 MISC 
# Modify.........: No:TQC-B10069 11/01/12 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息.
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action
# Modify.........: No:TQC-B10069 11/01/13 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-AA0087 11/01/27 By Mengxw 異動碼類型設定的改善
# Modify.........: No.MOD-B30392 11/03/17 By lixia 發票號碼欄位alk46取值修改
# Modify.........: No.MOD-B30613 11/03/18 By Dido 先到單後到貨才須更新 apa35f/apa35 
# Modify.........: No.MOD-B30689 11/03/29 By Dido apb28 預設值為 rvv86 
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.MOD-B50102 11/05/12 By Dido AFTER FIELD alk12/13/16/23 後需 CALL t810_alk25_26() 
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B50184 11/05/21 By Dido 關係人應判斷 aag371 為 234 才需輸入
# Modify.........: No:MOD-B60248 11/06/30 By Dido 應判斷apz14或g_aza.aza21為Y再搭配CALL s_chkban()判斷統一編號的正確性
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:CHI-B80025 11/10/12 By Polly 增加功能：1.可選擇單頭的金額分攤到單身或單身的金額分攤到單頭
#                                                            2.科目是stock的情況下，如果條件相同在分錄底稿會合併成一筆
# Modify.........: No:MOD-BC0246 11/12/27 By Dido apa22 部門預設值調整 
# Modify.........: No:FUN-BB0084 11/12/27 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 12/01/13 By tanxc 增加數量欄位小數取位  

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C10017 12/02/10 By yinhy 調整apb25，apb26，apb27，apb36，apb31，apb930欄位的值
# Modify.........: No.TQC-C20183 12/02/20 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C50109 12/05/14 By xuxz npqlegal賦值
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 單身無資料時候提示是否刪除單頭資料
# Modify.........: No:MOD-C50161 12/05/25 By Polly PREPARE t810_prepare 調整
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:MOD-C60214 12/06/28 By Polly 調整分錄底稿產出分錄
# Modify.........: No:MOD-C70029 12/07/04 By polly 依單身設定科目產生分錄，調整條件
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C70117 12/07/10 By Polly 依有無到單單號來調整匯差應攤金額計算
# Modify.........: No:MOD-C80252 12/09/03 By Polly 調整t810_g_b_p1寫入g_ale個數
# Modify.........: No:MOD-CA0050 12/10/08 By Polly 匯率為1時分錄底稿借貸方金額需一致
# Modify.........: No:CHI-C80041 12/11/29 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No:MOD-CB0260 12/11/29 By Polly 調整q_rvv5開窗條件
# Modify.........: No:MOD-CC0085 12/12/12 By Polly 預購沖帳反推，本幣金額需加上原幣金額
# Modify.........: No:MOD-D20059 13/02/18 By Polly 給予apa51、apb25借方科目值
# Modify.........: No.FUN-D10065 13/03/07 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40211 13/04/29 By Polly 課稅為3免稅時，扣抵區分應預設為3不可扣抵進貨及費用
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: NO:FUN-E80012 18/11/27 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_alk   RECORD LIKE alk_file.*,
    g_azi   RECORD LIKE azi_file.*,
    g_alk_t RECORD LIKE alk_file.*,
    g_alk_o RECORD LIKE alk_file.*,
    g_alk01_t LIKE alk_file.alk01,
    g_ala   RECORD LIKE ala_file.*,
    b_ale   RECORD LIKE ale_file.*,
    g_alh   RECORD LIKE alh_file.*,
    g_wc,g_wc2,g_sql    string,                     #No.FUN-580092 HCN
    alk25_26            LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_statu             LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),       # 是否從新賦予等級
    g_dbs_gl            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_plant_gl          LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21), #No.FUN-980059
    g_dbs_nm            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_pma11             LIKE pma_file.pma11,
    nm_no_b,nm_no_e     LIKE type_file.num10,       # No.FUN-690028 INTEGER,
    gl_no_b,gl_no_e     LIKE abb_file.abb01,        # No.FUN-690028 VARCHAR(12),
    g_argv1 LIKE alk_file.alk01,   #TQC-630070
    g_argv2 STRING,                #TQC-630070      #執行功能
    g_ale               DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        ale02            LIKE ale_file.ale02,
        ale16            LIKE ale_file.ale16,
        ale17            LIKE ale_file.ale17,
        ale14            LIKE ale_file.ale14,
        ale15            LIKE ale_file.ale15,
        ale11            LIKE ale_file.ale11,
        pmn041           LIKE pmn_file.pmn041,      #FUN-660117
        ale83            LIKE ale_file.ale83, 
        ale84            LIKE ale_file.ale84,
        ale85            LIKE ale_file.ale85,
        ale80            LIKE ale_file.ale80,
        ale81            LIKE ale_file.ale81,
        ale82            LIKE ale_file.ale82,
        ale86            LIKE ale_file.ale86,
        ale87            LIKE ale_file.ale87,
        ale06            LIKE ale_file.ale06,
        ale13            LIKE ale_file.ale13,
        ale131           LIKE ale_file.ale131,  #No.FUN-680029
        ale05            LIKE ale_file.ale05,
        ale07            LIKE ale_file.ale07,
        ale08            LIKE ale_file.ale08,
        ale09            LIKE ale_file.ale09,
        ale930           LIKE ale_file.ale930,  #FUN-680019
        gem02c           LIKE gem_file.gem02,   #FUN-680019
        aleud01		 LIKE ale_file.aleud01,
        aleud02		 LIKE ale_file.aleud02,
        aleud03		 LIKE ale_file.aleud03,
        aleud04		 LIKE ale_file.aleud04,
        aleud05		 LIKE ale_file.aleud05,
        aleud06		 LIKE ale_file.aleud06,
        aleud07		 LIKE ale_file.aleud07,
        aleud08		 LIKE ale_file.aleud08,
        aleud09		 LIKE ale_file.aleud09,
        aleud10		 LIKE ale_file.aleud10,
        aleud11		 LIKE ale_file.aleud11,
        aleud12		 LIKE ale_file.aleud12,
        aleud13		 LIKE ale_file.aleud13,
        aleud14		 LIKE ale_file.aleud14,
        aleud15		 LIKE ale_file.aleud15
                    END RECORD,
    g_apk           DYNAMIC ARRAY OF RECORD
        apk02            LIKE apk_file.apk02,          #MOD-A90085
        apk11            LIKE apk_file.apk11,
        apk171           LIKE apk_file.apk171,
        apk17            LIKE apk_file.apk17,
        apk172           LIKE apk_file.apk172,
        apk05            LIKE apk_file.apk05,     
        apk03            LIKE apk_file.apk03,
        apk04            LIKE apk_file.apk04,
        apk12            LIKE apk_file.apk12,
        apk13            LIKE apk_file.apk13,
        apk08f           LIKE apk_file.apk08f,
        apk07f           LIKE apk_file.apk07f,
        apk06f           LIKE apk_file.apk06f,
        apk08            LIKE apk_file.apk08,
        apk07            LIKE apk_file.apk07,
        apk06            LIKE apk_file.apk06,         
        apk32            LIKE apk_file.apk32          #MOD-A90085
                    END RECORD,
    g_pmc03         LIKE pmc_file.pmc03,
    g_ale_t         RECORD                      #程式變數 (舊值)
        ale02            LIKE ale_file.ale02,
        ale16            LIKE ale_file.ale16,
        ale17            LIKE ale_file.ale17,
        ale14            LIKE ale_file.ale14,
        ale15            LIKE ale_file.ale15,
        ale11            LIKE ale_file.ale11,
        pmn041           LIKE pmn_file.pmn041,  #FUN-660117
        ale83            LIKE ale_file.ale83, 
        ale84            LIKE ale_file.ale84,
        ale85            LIKE ale_file.ale85,
        ale80            LIKE ale_file.ale80,
        ale81            LIKE ale_file.ale81,
        ale82            LIKE ale_file.ale82,
        ale86            LIKE ale_file.ale86,
        ale87            LIKE ale_file.ale87,
        ale06            LIKE ale_file.ale06,
        ale13            LIKE ale_file.ale13,
        ale131           LIKE ale_file.ale131,  #No.FUN-680029
        ale05            LIKE ale_file.ale05,
        ale07            LIKE ale_file.ale07,
        ale08            LIKE ale_file.ale08,
        ale09            LIKE ale_file.ale09,
        ale930           LIKE ale_file.ale930,  #FUN-680019
        gem02c           LIKE gem_file.gem02,   #FUN-680019
        aleud01		 LIKE ale_file.aleud01,
        aleud02		 LIKE ale_file.aleud02,
        aleud03		 LIKE ale_file.aleud03,
        aleud04		 LIKE ale_file.aleud04,
        aleud05		 LIKE ale_file.aleud05,
        aleud06		 LIKE ale_file.aleud06,
        aleud07		 LIKE ale_file.aleud07,
        aleud08		 LIKE ale_file.aleud08,
        aleud09		 LIKE ale_file.aleud09,
        aleud10		 LIKE ale_file.aleud10,
        aleud11		 LIKE ale_file.aleud11,
        aleud12		 LIKE ale_file.aleud12,
        aleud13		 LIKE ale_file.aleud13,
        aleud14		 LIKE ale_file.aleud14,
        aleud15		 LIKE ale_file.aleud15
                    END RECORD,
    g_buf           LIKE type_file.chr1000,     # #No.FUN-690028 VARCHAR(78)
    g_tot           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_qty1,g_qty2,g_qty3 LIKE rvv_file.rvv87,   # No.FUN-690028 DECIMAL(15,3),
    g_rec_b         LIKE type_file.num5,        #單身筆數  #No.FUN-690028 SMALLINT
    z               LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
DEFINE g_net           LIKE apv_file.apv04      #MOD-59044
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
DEFINE g_forupd_sql STRING                         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-690028 INTEGER
DEFINE g_i             LIKE type_file.num5         #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-690028 VARCHAR(72)
DEFINE g_str           STRING                      #No.FUN-670060
DEFINE g_wc_gl         STRING                      #No.FUN-670060
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-690028 SMALLINT
DEFINE g_img09             LIKE img_file.img09,
       g_ima25             LIKE ima_file.ima25,
       g_ima44             LIKE ima_file.ima44,
       g_ima31             LIKE ima_file.ima31,
       g_ima906            LIKE ima_file.ima906,
       g_ima907            LIKE ima_file.ima907,
       g_ima908            LIKE ima_file.ima908,
       g_factor            LIKE pmn_file.pmn09,
       g_tot1              LIKE img_file.img10,
       g_qty               LIKE img_file.img10,
       g_flag              LIKE type_file.chr1,
       g_apb_sarrno        LIKE type_file.num5,     #SMALLINT #螢幕變數的個數  #FUN-720018 add
       g_aptype            LIKE type_file.chr2      #CHAR(02) #帳款種類        #FUN-720018 add
DEFINE g_bookno1           LIKE aza_file.aza81      #No.FUN-730064
DEFINE g_bookno2           LIKE aza_file.aza82      #No.FUN-730064      
DEFINE g_bookno3           LIKE aza_file.aza82      #No.FUN-D40118   Add
DEFINE l_dbs_tra           LIKE azw_file.azw05      #FUN-980093 add
DEFINE g_pass              LIKE type_file.chr1      #No.FUN-B10050    
DEFINE g_ale80_t           LIKE ale_file.ale80      #No.FUN-BB0086
DEFINE g_ale83_t           LIKE ale_file.ale83      #No.FUN-BB0086
DEFINE g_ale86_t           LIKE ale_file.ale86      #No.FUN-BB0086
DEFINE g_void       LIKE type_file.chr1      #CHI-C80041

MAIN
      DEFINE    p_row,p_col  LIKE type_file.num5    #No.FUN-690028 SMALLINT  #No.FUN-6A0055
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)               #TQC-630070
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW t810_w AT p_row,p_col
     WITH FORM "aap/42f/aapt810"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   
   CALL t810_def_form()
 
   IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_visible("ale131",TRUE)
   ELSE
      CALL cl_set_comp_visible("ale131",FALSE)
   END IF
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("alk04",TRUE)
   END IF
   CALL cl_set_comp_visible("alk930,gem02b,ale930,gem02c",g_aaz.aaz90='Y')
 
   # 先以g_argv2判斷直接執行哪種功能：
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t810_a()
           END IF
         OTHERWISE          #TQC-660072
            CALL t810_q()   #TQC-660072
      END CASE
   END IF

   CALL t810()
   CLOSE WINDOW t810_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
FUNCTION t810_declare()
 
   LET g_forupd_sql = "SELECT * FROM alk_file WHERE alk01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t810_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t810()
   LET g_plant_new=g_apz.apz04p CALL s_getdbs() LET g_dbs_nm=g_dbs_new
   IF cl_null(g_dbs_nm) THEN LET g_dbs_nm = NULL END IF
   LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET g_dbs_gl=g_dbs_new
   IF cl_null(g_dbs_gl) THEN LET g_dbs_gl = NULL END IF
 
   INITIALIZE g_alk.* TO NULL
   INITIALIZE g_alk_t.* TO NULL
   INITIALIZE g_alk_o.* TO NULL
   CALL t810_declare()
   WHILE TRUE
     LET g_action_choice = ""
     CALL t810_menu()
     IF g_action_choice = 'exit' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION t810_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_ale.clear()
 
   IF cl_null(g_argv1) THEN
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_alk.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON alk97,alk01,alk03,alk02,alk04,alk930,alk10,alk05,    #FUN-680019     #No.FUN-980017
                             alk46,alk72,alkfirm,alk07,alk37,alk38,alk39,
                             alk33,alk11,alk12,alk13,alk16,alk23,alk25,
                             alk26,alk27,alkuser,alkgrup,alkmodu,alkdate,
                             alkacti,        #MOD-490240
                             alkud01,alkud02,alkud03,alkud04,alkud05,
                             alkud06,alkud07,alkud08,alkud09,alkud10,
                             alkud11,alkud12,alkud13,alkud14,alkud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(alk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_als"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO alk01
             WHEN INFIELD(alk03) # L/C
                CALL q_ala(TRUE,TRUE,g_alk.alk03)
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk03
             WHEN INFIELD(alk05) #PAY TO VENDOR
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_pmc"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk05
                CALL t810_alk05('d')
             WHEN INFIELD(alk11) # CURRENCY
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_azi"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk11
             WHEN INFIELD(alk04) # Dept CODE
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk04
             WHEN INFIELD(alk07) # L/C No
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_alh1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk07
             WHEN INFIELD(alk10)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_pma"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk10
             WHEN INFIELD(alk930)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alk930
                NEXT FIELD alk930
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alkuser', 'alkgrup') #FUN-980030
 
  IF INT_FLAG THEN RETURN END IF
   CONSTRUCT g_wc2 ON ale02,ale16,ale17,ale14,ale15,ale11,
                      ale83,ale84,ale85,ale80,ale81,ale82,ale86,ale87,  #FUN-710029
                      ale06,ale13,ale131,ale930 #FUN-680019  #No.FUN-680029
                     ,aleud01,aleud02,aleud03,aleud04,aleud05
                     ,aleud06,aleud07,aleud08,aleud09,aleud10
                     ,aleud11,aleud12,aleud13,aleud14,aleud15
           FROM s_ale[1].ale02,s_ale[1].ale16,s_ale[1].ale17,
                s_ale[1].ale14,s_ale[1].ale15,s_ale[1].ale11,
                s_ale[1].ale83,s_ale[1].ale84,s_ale[1].ale85,   #FUN-710029
                s_ale[1].ale80,s_ale[1].ale81,s_ale[1].ale82,   #FUN-710029
                s_ale[1].ale86,s_ale[1].ale87,   #FUN-710029
                s_ale[1].ale06,s_ale[1].ale13,s_ale[1].ale131,s_ale[1].ale930 #FUN-680019  #No.FUN-680029
               ,s_ale[1].aleud01,s_ale[1].aleud02,s_ale[1].aleud03
               ,s_ale[1].aleud04,s_ale[1].aleud05,s_ale[1].aleud06
               ,s_ale[1].aleud07,s_ale[1].aleud08,s_ale[1].aleud09
               ,s_ale[1].aleud10,s_ale[1].aleud11,s_ale[1].aleud12
               ,s_ale[1].aleud13,s_ale[1].aleud14,s_ale[1].aleud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(ale16) # 入庫單號
           CALL q_rvv2(TRUE,TRUE,g_alk.alk05,
                      #'','','')  #FUN-9A0093 mark
                      '','','','') #FUN-9A0093
           RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ale16
 

         WHEN INFIELD(ale13)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_aag"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ale13
            NEXT FIELD ale13
         WHEN INFIELD(ale131)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_aag"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ale131
            NEXT FIELD ale131
          WHEN INFIELD(ale80)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gfe"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ale80
              NEXT FIELD ale80
          WHEN INFIELD(ale86)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gfe"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ale86
              NEXT FIELD ale86
         WHEN INFIELD(ale930)
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_gem4"
            LET g_qryparam.state = "c"   #多選
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ale930
            NEXT FIELD ale930
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
 
    ELSE 
       LET g_wc=" alk01='",g_argv1,"'"
       LET g_wc2=" 1=1"
    END IF

 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT alk01 FROM alk_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY alk01"
   ELSE
     #LET g_sql="SELECT alk01 FROM alk_file,ale_file ",     #MOD-C50161 mark
      LET g_sql="SELECT UNIQUE alk01 ",                     #MOD-C50161 add
                "  FROM alk_file,ale_file ",                #MOD-C50161 add
                " WHERE alk01=ale01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY alk01"
   END IF
   PREPARE t810_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t810_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t810_prepare
   IF g_wc2=' 1=1' THEN
      LET g_sql= "SELECT COUNT(*) FROM alk_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE alk01) FROM alk_file,ale_file ",
                " WHERE alk01=ale01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t810_precount FROM g_sql
   DECLARE t810_count CURSOR FOR t810_precount
END FUNCTION
 
FUNCTION t810_menu()
 
   WHILE TRUE
      CALL t810_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t810_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t810_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t810_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t810_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t810_out('a')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ale),'','')
             END IF
 
         WHEN "apportion"
            CALL t810_s()
         WHEN "transfer_to_an"
            CALL t810_t()
         WHEN "get_estd_exp"
            CALL t810_k()
         WHEN "gen_entry"
               CALL t810_g_gl(g_alk.alk01)
         WHEN "maintain_entry"
               CALL s_fsgl('LC',4,g_alk.alk01,0,g_apz.apz02b,1,g_alk.alkfirm,'0',g_apz.apz02p)      #No.FUN-680029
               CALL t810_npp02('0')  #No.+081 010425 by plum      #No.FUN-680029
         WHEN "maintain_entry2"
               CALL s_fsgl('LC',4,g_alk.alk01,0,g_apz.apz02c,1,g_alk.alkfirm,'1',g_apz.apz02p)      #No.FUN-680029
               CALL t810_npp02('1')  #No.+081 010425 by plum      #No.FUN-680029
         WHEN "acct_title"
            CALL t810_7(2)
 
         WHEN "carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_alk.alkfirm = 'Y' THEN  
                  CALL t810_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF  
            END IF 
         WHEN "undo_carry_voucher"  
            IF cl_chk_act_auth() THEN
               IF g_alk.alkfirm = 'Y' THEN 
                  CALL t810_undo_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF 
            END IF 
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069
               CALL t810_firm1()
               #CALL cl_set_field_pic(g_alk.alkfirm,"","","","","") #CHI-C80041
               IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
               CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"")  #CHI-C80041
               CALL t810_tax()   #MOD-6B0127
               CALL s_showmsg()               #TQC-B10069
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t810_firm2()
               #CALL cl_set_field_pic(g_alk.alkfirm,"","","","","")  #CHI-C80041
               IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
               CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"")  #CHI-C80041
               CALL t810_tax()   #MOD-6B0127
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t810_m()
            END IF
         #--FUN-B10030--start--
         # WHEN "switch_plant"
         #   CALL t810_d()
         #--FUN-B10030--end--
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_alk.alk01 IS NOT NULL THEN
                 LET g_doc.column1 = "alk01"
                 LET g_doc.value1 = g_alk.alk01
                 CALL cl_doc()
               END IF
         END IF
 
         WHEN "mul_invoice"
            CALL t810_ddd()
            SELECT pmc03
              INTO g_pmc03
              FROM pmc_file
             WHERE pmc01 = g_alk.alk05
            DISPLAY BY NAME g_pmc03
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t810_x()
               IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"")   
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
      CLOSE t810_cs
END FUNCTION
 
FUNCTION t810_a()
 
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_ale.clear()
   INITIALIZE g_alk.* LIKE alk_file.*
   LET g_alk01_t = NULL
   LET g_alk.alk97=g_plant                  #No.FUN-980017
   LET g_alk.alk02 = g_today
   LET g_alk.alk12 = 1 #LET g_alk.alk13 = 0 LET g_alk.alk16 = 0
   LET g_alk.alk23 = 0 LET g_alk.alk24 = 0
   LET g_alk.alk25 = 0 LET g_alk.alk26 = 0
   LET g_alk.alk27 = 0
   LET g_alk.alk33 = 0
   LET g_alk.alk37 = 0 LET g_alk.alk38 = 0 LET g_alk.alk39 = 0
   LET g_alk.alk70 = 'N' LET g_alk.alkfirm = 'N'
   LET g_alk.alk04 = g_grup #FUN-680019
   LET g_alk.alk930= s_costcenter(g_alk.alk04) #FUN-680019
   DISPLAY BY NAME g_alk.alk04,g_alk.alk930 #FUN-680019
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_alk.alkacti ='Y'                   # 有效的資料
      LET g_alk.alkuser = g_user
      LET g_alk.alkoriu = g_user #FUN-980030
      LET g_alk.alkorig = g_grup #FUN-980030
      LET g_alk.alkgrup = g_grup               # 使用者所屬群
      LET g_alk.alkdate = g_today
      LET g_alk.alkinpd = g_today
      LET g_alk.alklegal= g_legal  #FUN-980001
 
     IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
        LET g_alk.alk01 = g_argv1
     END IF
 
      CALL t810_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_ale.clear()
         EXIT WHILE
      END IF
      IF g_alk.alk01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK #No.7875

      CALL t810_7(1)
      INSERT INTO alk_file VALUES(g_alk.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)   #FUN-B80105
         ROLLBACK WORK
        #CALL cl_err3("ins","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122   #FUN-B80105
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_alk.alk01,'I')
         LET g_alk_t.* = g_alk.*               # 保存上筆資料
         SELECT alk01 INTO g_alk.alk01 FROM alk_file
          WHERE alk01 = g_alk.alk01
      END IF
      CALL g_ale.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      CALL t810_b('0')
      IF NOT cl_null(g_alk.alk01) THEN   #CHI-C30002 add
         IF cl_confirm('aap-126') THEN
            CALL t810_out('a')
         END IF
      END IF                             #CHI-C30002 add
      CALL s_showmsg_init()    #TQC-B10069 
      CALL t810_firm1()
      CALL s_showmsg()         #TQC-B10069
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t810_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,        #No.FUN-690028 VARCHAR(1)
          l_flag          LIKE type_file.chr1,        #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
          g_t1            LIKE oay_file.oayslip,      # No.FUN-690028 VARCHAR(3),               #單別
          l_dept          LIKE alk_file.alk04,        #Dept  #FUN-660117
          l_amt           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
          l_als           RECORD LIKE als_file.*,
          l_n             LIKE type_file.num5,        #No.FUN-690028 SMALLINT
          l_cnt,ll        LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
          ll1             LIKE als_file.alsfirm,      #FUN-660117
          l_pma11         LIKE pma_file.pma11,
          l_alh11         LIKE alh_file.alh11         #MOD-870330 add
   DEFINE l_aag05         LIKE aag_file.aag05         #FUN-8C0106 add
   DEFINE l_pay_alk38     LIKE alk_file.alk38         #MOD-C70117 add
   DEFINE l_pay_alk13     LIKE alk_file.alk13         #MOD-C70117 add
 
   CALL cl_set_head_visible("","YES")                 #No.FUN-6B0033
   INPUT BY NAME g_alk.alkoriu,g_alk.alkorig,g_alk.alk97,g_alk.alk01,g_alk.alk03,g_alk.alk02,              #No.FUN-980017
                 g_alk.alk04,g_alk.alk930,g_alk.alk10,g_alk.alk05,g_alk.alk46, #FUN-680019
                 g_alk.alk72,g_alk.alkfirm,g_alk.alk07,g_alk.alk37,
                 g_alk.alk38,g_alk.alk39,g_alk.alk33,g_alk.alk11,
                 g_alk.alk12,g_alk.alk13,g_alk.alk16,g_alk.alk23,
                 g_alk.alk25,g_alk.alk26,g_alk.alk27,
                 g_alk.alkud01,g_alk.alkud02,g_alk.alkud03,g_alk.alkud04,
                 g_alk.alkud05,g_alk.alkud06,g_alk.alkud07,g_alk.alkud08,
                 g_alk.alkud09,g_alk.alkud10,g_alk.alkud11,g_alk.alkud12,
                 g_alk.alkud13,g_alk.alkud14,g_alk.alkud15
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t810_set_entry(p_cmd)
         CALL t810_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
        AFTER FIELD alk97
          IF NOT cl_null(g_alk.alk97) THEN
             SELECT count(*) INTO l_n FROM azw_file WHERE azw01 = g_alk.alk97
                AND azw02 = g_legal
             IF l_n = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)
               NEXT FIELD alk97
             END IF
          END IF

      AFTER FIELD alk01
         LET ll = 0
         SELECT COUNT(*) INTO ll FROM als_file
          WHERE als01 = g_alk.alk01
            AND alsfirm <> 'X'  #CHI-C80041
         IF ll = 0 OR STATUS = 100 THEN
            CALL cl_err(g_alk.alk01,'aap-762',1)
            NEXT FIELD alk01
         END IF
 
         #Wendy 990128 若要產生到貨資料，其提單須已確認-----B------
         SELECT alsfirm INTO ll1 FROM als_file
          WHERE als01 = g_alk.alk01
            AND alsfirm <> 'X'  #CHI-C80041
         IF ll1 = 'N' THEN
            CALL cl_err(g_alk.alk01,'aap-763',1)
            NEXT FIELD alk01
         END IF
 
         IF g_alk.alk01[1,1] = ' ' OR g_alk.alk01[1,1] IS NULL THEN
            NEXT FIELD alk01
         END IF
 
         IF (g_alk.alk01 != g_alk01_t) OR (g_alk01_t IS NULL) THEN
            SELECT COUNT(*) INTO g_cnt FROM alk_file
             WHERE alk01 = g_alk.alk01
            IF g_cnt > 0 THEN                   # 資料重複
               CALL cl_err(g_alk.alk01,-239,0)
               LET g_alk.alk01 = g_alk01_t
               DISPLAY BY NAME g_alk.alk01
               NEXT FIELD alk01
            END IF
         END IF
 
         INITIALIZE l_als.* TO NULL
         SELECT * INTO l_als.* FROM als_file
          WHERE als01 = g_alk.alk01
         IF SQLCA.SQLCODE = 0 THEN
            LET g_alk.alk03 = l_als.als03
            LET g_alk.alk04 = l_als.als04
            LET g_alk.alk05 = l_als.als05
            LET g_alk.alk10 = l_als.als10
            LET g_alk.alk11 = l_als.als11
            LET g_alk.alk12 = l_als.als12
            LET g_alk.alk13 = l_als.als13
            #LET g_alk.alk46 = l_als.als07   #MOD-B30392 mark
 
            DISPLAY BY NAME g_alk.alk03,g_alk.alk04,g_alk.alk05,g_alk.alk10,
                            #g_alk.alk11,g_alk.alk12,g_alk.alk13,g_alk.alk46     #MOD-B30392 mark
                            g_alk.alk11,g_alk.alk12,g_alk.alk13                  #MOD-B30392 add
 
            IF l_als.als31 IS NULL THEN LET l_als.als31 = 0 END IF
            IF l_als.als32 IS NULL THEN LET l_als.als32 = 0 END IF
            IF l_als.als33 IS NULL THEN LET l_als.als33 = 0 END IF
            IF l_als.als34 IS NULL THEN LET l_als.als34 = 0 END IF
            IF l_als.als35 IS NULL THEN LET l_als.als35 = 0 END IF
            IF l_als.als36 IS NULL THEN LET l_als.als36 = 0 END IF
 
            LET g_alk.alk23=l_als.als31+l_als.als32+l_als.als33+
                            l_als.als34+l_als.als35+l_als.als36
 
            SELECT * INTO g_ala.* FROM ala_file
             WHERE ala01 = g_alk.alk03
 
            IF cl_null(g_ala.ala21) THEN
               LET g_ala.ala21 = 0
            END IF
 
            LET g_alk.alk16 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21) / 100
            LET g_alk.alk25 = g_alk.alk16 + g_alk.alk23
            LET g_alk.alk16 = cl_digcut(g_alk.alk16,g_azi04)
            LET g_alk.alk23 = cl_digcut(g_alk.alk23,g_azi04)
            LET g_alk.alk25 = cl_digcut(g_alk.alk25,g_azi04)
            LET g_alk.alk40 = g_ala.ala41
 
            CALL t810_alk04("a")
 
            DISPLAY BY NAME g_alk.alk40,g_alk.alk41,g_alk.alk42
 
            CALL t810_alk25_26()
 
            DISPLAY BY NAME g_alk.alk23,g_alk.alk26,g_alk.alk25,g_alk.alk16
         END IF
 
         SELECT * INTO g_ala.* FROM ala_file
          WHERE ala01 = g_alk.alk03
         IF STATUS THEN
            CALL cl_err3("sel","ala_file",g_alk.alk03,"",STATUS,"","",1)  #No.FUN-660122
            NEXT FIELD alk01
         END IF
 
         IF g_ala.alafirm = 'X' THEN
            CALL cl_err("alafirm = 'X'",'9024',0)
            NEXT FIELD alk01
         END IF
 
         IF g_ala.ala59 > 0 AND g_ala.ala78 != 'Y' THEN
            # Thomas 98/12/25 預購申請不付款哪來的到貨呢?
            CALL cl_err(g_alk.alk03,'aap-721',0)
            NEXT FIELD alk01
         END IF
 
      AFTER FIELD alk02
         IF NOT cl_null(g_alk.alk02) THEN
            # Thomas alk12 匯率擷取到貨日期的賣出匯率 98/08/11
            CALL s_curr3(g_alk.alk11,g_alk.alk02,g_apz.apz33) RETURNING g_alk.alk12 #FUN-640022
            CALL s_get_bookno(YEAR(g_alk.alk02))
                 RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag = "1" THEN    #抓不到帳別
               CALL cl_err(g_alk.alk02,'aoo-081',1)
               NEXT FIELD alk02
            END IF         
 
            DISPLAY BY NAME g_alk.alk12
         END IF
 
      AFTER FIELD alk10
         IF NOT cl_null(g_alk.alk10) THEN
            SELECT pma11 INTO l_pma11 FROM pma_file
             WHERE pma01 = g_alk.alk10
            IF STATUS THEN
               CALL cl_err3("sel","pma_file",g_alk.alk10,"","aap-016","","sel pma:",1)  #No.FUN-660122
               NEXT FIELD alk10
            END IF
            IF l_pma11 NOT MATCHES "[234678]" THEN   #TQC-5C0028
               NEXT FIELD alk10
            END IF
         END IF
 
      AFTER FIELD alk04
         IF NOT cl_null(g_alk.alk04) THEN
            CALL t810_alk04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alk.alk04,g_errno,0)
               LET g_alk.alk04 = g_alk_o.alk04
               DISPLAY BY NAME g_alk.alk04
               NEXT FIELD alk04
            END IF
           #會科一
            IF p_cmd='u' OR g_alk.alk04 != g_alk_t.alk04 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ale_file WHERE ale03=g_alk.alk01
               IF l_cnt > 0 THEN
                  LET l_aag05=''
                  SELECT aag05 INTO l_aag05 FROM aag_file
                    WHERE aag01 = g_ale[l_ac].ale13
                      AND aag00 = g_bookno1         
                  IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale13) THEN
                    #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                     IF g_aaz.aaz90 !='Y' THEN
                        CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale13,g_alk.alk04,g_bookno1) RETURNING g_errno                
                     END IF
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD alk04
                     END IF
                  END IF
                  
                 #會科二
                  IF g_aza.aza63='Y' THEN
                     LET l_aag05=''
                     SELECT aag05 INTO l_aag05 FROM aag_file
                       WHERE aag01 = g_ale[l_ac].ale131
                         AND aag00 = g_bookno2         
                     IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale131) THEN
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                        IF g_aaz.aaz90 !='Y' THEN
                           CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale131,g_alk.alk04,g_bookno2) RETURNING g_errno                
                        END IF
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           NEXT FIELD alk04
                        END IF
                     END IF
                  END IF 
               END IF    #MOD-940261 add
            END IF
 
            LET g_alk_o.alk04 = g_alk.alk04
         END IF
 
      AFTER FIELD alk03
         IF NOT cl_null(g_alk.alk03) THEN
            INITIALIZE g_ala.* TO NULL
            LET g_ala.ala21 = 0
            IF g_alk.alk03 IS NOT NULL THEN
               SELECT * INTO g_ala.* FROM ala_file
                WHERE ala01 = g_alk.alk03
               IF STATUS THEN
                  CALL cl_err3("sel","ala_file",g_alk.alk03,"",STATUS,"","sel ala:",1)  #No.FUN-660122
                  NEXT FIELD alk03
               END IF
               IF g_ala.alafirm = 'X' THEN
                  CALL cl_err("alafirm='X'",'9024',0)
                  NEXT FIELD alk03
               END IF
            END IF
         END IF
 
      BEFORE FIELD alk05
         IF NOT cl_null(g_alk.alk03) THEN
            CALL t810_alk05('d')
         END IF
 
      AFTER FIELD alk05
         IF NOT cl_null(g_alk.alk05) THEN
            CALL t810_alk05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alk.alk05,g_errno,0)
               LET g_alk.alk05 = g_alk_t.alk05
               DISPLAY BY NAME g_alk.alk05
               NEXT FIELD alk05
            END IF
         END IF
 
      AFTER FIELD alk07
         #------MOD-C70117---mark
         #IF g_alk.alk07 IS NULL THEN
         #   LET g_alk.alk37=0
         #   LET g_alk.alk38=0
         #   LET g_alk.alk16=0   #MOD-590394
         #   DISPLAY BY NAME g_alk.alk37,g_alk.alk38,g_alk.alk16   #MOD-590394
         #END IF
         #------MOD-C70117---mark
 
          IF NOT cl_null(g_alk.alk07) THEN
             SELECT alh11,alh15,alh12,alh14,alh41   #MOD-830044   #MOD-870330 add alh11
               INTO l_alh11,g_alk.alk37,g_alk.alk38,g_alk.alk16,g_alk.alk40   #MOD-830044   #MOD-870330 add alh11
               FROM alh_file
              WHERE alh01 = g_alk.alk07
             IF STATUS THEN
                CALL cl_err3("sel","alh_file",g_alk.alk07,"",STATUS,"","",1)  #No.FUN-660122
                NEXT FIELD alk07
             END IF
             SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=l_alh11
             IF SQLCA.SQLCODE != 0 THEN
                LET t_azi07 = 0
             END IF
             LET g_alk.alk37 = cl_digcut(g_alk.alk37,t_azi07)
             LET g_alk.alk16 = g_alk.alk16 * g_alk.alk12
             LET g_alk.alk16 = cl_digcut(g_alk.alk16,g_azi04)
             LET g_alk.alk39 = g_alk.alk37 * g_alk.alk38
             LET g_alk.alk39 = cl_digcut(g_alk.alk39,g_azi04)
         #----------------------MOD-C70117---------------------(S)
            #LET g_alk.alk27 = g_alk.alk39-g_alk.alk16                                       #MOD-C70117 mark
             LET l_pay_alk38 = g_alk.alk38 * g_alk.alk37 * (100 - g_ala.ala21)/100
             LET l_pay_alk13 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21)/100
             LET l_pay_alk38 = cl_digcut(l_pay_alk38,g_azi04)
             LET l_pay_alk13 = cl_digcut(l_pay_alk13,g_azi04)
             LET g_alk.alk27 = l_pay_alk38 - l_pay_alk13
          ELSE
             LET g_alk.alk37 = 0
             LET g_alk.alk38 = 0
             LET g_alk.alk16 = 0
             LET g_alk.alk27 = g_ala.ala52 - g_ala.ala84 * g_ala.ala34
          END IF
         #----------------------MOD-C70117---------------------(E)
               LET g_alk.alk27 = cl_digcut(g_alk.alk27,g_azi04)
             DISPLAY BY NAME g_alk.alk37,g_alk.alk38,g_alk.alk16,g_alk.alk39,g_alk.alk27    #MOD-690048
         #END IF                                                                              #MOD-C70117 mark
 
 
      AFTER FIELD alk11
         IF NOT cl_null(g_alk.alk11) THEN
            SELECT azi02 INTO g_buf FROM azi_file
             WHERE azi01 = g_alk.alk11
            IF STATUS THEN
               CALL cl_err3("sel","azi_file",g_alk.alk01,"",STATUS,"","sel azi:",1)  #No.FUN-660122
               NEXT FIELD alk11
            END IF
 
            CALL t810_alk11(p_cmd)
 
            # Wendy 990406 小數點統一check幣別檔
            SELECT azi03,azi04,azi07 INTO t_azi03,t_azi04,t_azi07   #MOD-870330 add azi07
              FROM azi_file
             WHERE azi01 = g_alk.alk11
            IF SQLCA.SQLCODE != 0 THEN
               LET t_azi03 = 0
               LET t_azi04 = 0
               LET t_azi07 = 0   #MOD-870330 add
            END IF
            LET g_alk.alk12 = cl_digcut(g_alk.alk12,t_azi07)   #MOD-870330 add
            DISPLAY BY NAME g_alk.alk12                        #MOD-870330 add
         END IF
 
      AFTER FIELD alk12
         IF NOT cl_null(g_alk.alk12) THEN
            IF g_alk.alk12 = 0 THEN
               NEXT FIELD alk12
            END IF
 
            IF g_alk.alk11 =g_aza.aza17 THEN
               LET g_alk.alk12 = 1
               DISPLAY g_alk.alk12 TO alk12
            END IF
            LET g_alk.alk12 = cl_digcut(g_alk.alk12,t_azi07)   #MOD-870330 add
            DISPLAY BY NAME g_alk.alk12                        #MOD-870330 add
           #----------------------MOD-C70117---------------------(S)
           #------MOD-C70117---mark
           #IF g_alk.alk07 IS NULL THEN
           #   LET g_alk.alk16=g_alk.alk13*g_alk.alk12*(100-g_ala.ala21)/100
           #ELSE
           #    SELECT alh14 INTO g_alk.alk16 FROM alh_file
           #      WHERE alh01 = g_alk.alk07
           #    LET g_alk.alk16 = g_alk.alk16 * g_alk.alk12
           #    LET g_alk.alk27 = g_alk.alk39 - g_alk.alk16
           #------MOD-C70117---mark
            IF NOT cl_null(g_alk.alk07) THEN
               LET l_pay_alk38 = g_alk.alk38 * g_alk.alk37 * (100 - g_ala.ala21)/100
               LET l_pay_alk13 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21)/100
               LET l_pay_alk38 = cl_digcut(l_pay_alk38,g_azi04)
               LET l_pay_alk13 = cl_digcut(l_pay_alk13,g_azi04)
               LET g_alk.alk27 = l_pay_alk38 - l_pay_alk13
            ELSE
               LET g_alk.alk27 = g_ala.ala52 - g_ala.ala84 * g_ala.ala34
            END IF
           #----------------------MOD-C70117---------------------(E)
            LET g_alk.alk27 = cl_digcut(g_alk.alk27,g_azi04)
            DISPLAY BY NAME g_alk.alk27
           #END IF                                                #MOD-C70117 mark
            LET g_alk.alk16 = cl_digcut(g_alk.alk16,g_azi04)
            DISPLAY BY NAME g_alk.alk16
            CALL t810_alk25_26()     #MOD-B50102 
         END IF
 
      AFTER FIELD alk13
         IF NOT cl_null(g_alk.alk13) THEN
            LET g_alk.alk13=cl_digcut(g_alk.alk13,t_azi04)
            IF g_alk.alk07 IS NULL THEN   #MOD-690048
               LET g_alk.alk16=g_alk.alk13*g_alk.alk12*(100-g_ala.ala21)/100
               #no.A010依幣別取位
               LET g_alk.alk16=cl_digcut(g_alk.alk16,g_azi04)
               DISPLAY BY NAME g_alk.alk16
            END IF   #MOD-690048
            CALL t810_alk25_26()     #MOD-B50102 
         END IF
 
     BEFORE FIELD alk16
           IF g_ala.ala21 = 100 THEN
              CALL t810_set_no_entry(p_cmd)
           END IF
 
      AFTER FIELD alk16
         IF NOT cl_null(g_alk.alk16) THEN
            LET g_alk.alk16=cl_digcut(g_alk.alk16,g_azi04)  #No.MOD-530729
            LET g_alk.alk25=g_alk.alk16+g_alk.alk23
            LET g_alk.alk25=cl_digcut(g_alk.alk25,g_azi04)
            DISPLAY BY NAME g_alk.alk16,g_alk.alk25
           #----------------------MOD-C70117---------------------(S)
           #------MOD-C70117---mark
           #IF g_alk.alk07 IS NOT NULL THEN
           #   LET g_alk.alk27 = g_alk.alk39 - g_alk.alk16
           #------MOD-C70117---mark
            IF NOT cl_null(g_alk.alk07) THEN
               LET l_pay_alk38 = g_alk.alk38 * g_alk.alk37 * (100 - g_ala.ala21)/100
               LET l_pay_alk13 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21)/100
               LET l_pay_alk38 = cl_digcut(l_pay_alk38,g_azi04)
               LET l_pay_alk13 = cl_digcut(l_pay_alk13,g_azi04)
               LET g_alk.alk27 = l_pay_alk38 - l_pay_alk13
            ELSE
               LET g_alk.alk27 = g_ala.ala52 - g_ala.ala84 * g_ala.ala34
            END IF
           #----------------------MOD-C70117---------------------(E)
            LET g_alk.alk27 = cl_digcut(g_alk.alk27,g_azi04)
            DISPLAY BY NAME g_alk.alk27
           #END IF                                        #MOD-C70117 mark
            CALL t810_alk25_26()     #MOD-B50102 
         END IF
 
      AFTER FIELD alk23
         IF NOT cl_null(g_alk.alk23) THEN
            LET g_alk.alk23=cl_digcut(g_alk.alk23,g_azi04)  #No.MOD-530729
            LET g_alk.alk25=g_alk.alk16+g_alk.alk23
            LET g_alk.alk25=cl_digcut(g_alk.alk25,g_azi04)
            DISPLAY BY NAME g_alk.alk23,g_alk.alk25
            CALL t810_alk25_26()     #MOD-B50102 
         END IF
 
      AFTER FIELD alk25
         IF NOT cl_null(g_alk.alk25) THEN
            LET g_alk.alk25=cl_digcut(g_alk.alk25,g_azi04)
            DISPLAY BY NAME g_alk.alk25
           #LET alk25_26 = g_alk.alk25 + g_alk.alk26 + g_alk.alk27   #MOD-770003   #MOD-A40072 mark
            LET alk25_26 = g_alk.alk25 + g_alk.alk26                 #MOD-770003   #MOD-A40072
            DISPLAY BY NAME g_alk.alk25,g_alk.alk26,alk25_26,g_alk.alk27   #MOD-770003
         END IF
 
      AFTER FIELD alk26
         IF NOT cl_null(g_alk.alk26) THEN
            LET g_alk.alk26=cl_digcut(g_alk.alk26,g_azi04)
            DISPLAY BY NAME g_alk.alk26
            IF NOT cl_null(g_alk.alk25) THEN
              #LET alk25_26 = g_alk.alk25 + g_alk.alk26 + g_alk.alk27   #MOD-770003   #MOD-A40072 mark
               LET alk25_26 = g_alk.alk25 + g_alk.alk26                 #MOD-770003   #MOD-A40072
               DISPLAY BY NAME g_alk.alk25,g_alk.alk26,alk25_26,g_alk.alk27   #MOD-770003
            END IF
         END IF
 
      BEFORE FIELD alk27
         IF cl_null(g_alk.alk07) THEN   #MOD-690048
            IF g_ala.ala80 = "1" THEN
               LET g_alk.alk27 = g_ala.ala52 - g_ala.ala84 * g_ala.ala34
            ELSE
               LET g_alk.alk27 = 0
            END IF
        #----------------------MOD-C70117---------------------(S)
         ELSE
            LET l_pay_alk38 = g_alk.alk38 * g_alk.alk37 * (100 - g_ala.ala21)/100
            LET l_pay_alk13 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21)/100
            LET l_pay_alk38 = cl_digcut(l_pay_alk38,g_azi04)
            LET l_pay_alk13 = cl_digcut(l_pay_alk13,g_azi04)
            LET g_alk.alk27 = l_pay_alk38 - l_pay_alk13
        #----------------------MOD-C70117---------------------(E)
         END IF   #MOD-690048
 
      AFTER FIELD alk27
         IF NOT cl_null(g_alk.alk27) THEN
            LET g_alk.alk27=cl_digcut(g_alk.alk27,g_azi04)
            DISPLAY BY NAME g_alk.alk27
            IF NOT cl_null(g_alk.alk25) THEN
              #LET alk25_26 = g_alk.alk25 + g_alk.alk26 + g_alk.alk27   #MOD-770003   #MOD-A40072 mark
               LET alk25_26 = g_alk.alk25 + g_alk.alk26                 #MOD-770003   #MOD-A40072
               DISPLAY BY NAME g_alk.alk25,g_alk.alk26,alk25_26,g_alk.alk27   #MOD-770003
            END IF
         END IF
 
      AFTER FIELD alk46
         IF NOT cl_null(g_alk.alk46) AND p_cmd = 'a' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM alk_file
             WHERE alk46=g_alk.alk46
            IF l_cnt > 0 THEN
               CALL cl_err(g_alk.alk46,'aap-737',0)
            END IF
         END IF
 
         IF p_cmd='u' AND g_alk.alk46='MISC' AND
            (g_alk_t.alk08<>'MISC' OR g_alk_t.alk08 IS NULL) THEN
            CALL t810_ddd()
            SELECT pmc03
              INTO g_pmc03
              FROM pmc_file
             WHERE pmc01 = g_alk.alk05
            DISPLAY BY NAME g_pmc03
         END IF

      AFTER FIELD alk38
          LET g_alk.alk38 = cl_digcut(g_alk.alk38,t_azi04)
 
      AFTER FIELD alk39
          LET g_alk.alk39 = cl_digcut(g_alk.alk39,g_azi04)
         #----------------------MOD-C70117---------------------(S)
         #------MOD-C70117---mark
         #IF g_alk.alk07 IS NOT NULL THEN
         #   LET g_alk.alk27 = g_alk.alk39 - g_alk.alk16
         #------MOD-C70117---mark
          IF NOT cl_null(g_alk.alk07) THEN
             LET l_pay_alk38 = g_alk.alk38 * g_alk.alk37 * (100 - g_ala.ala21)/100
             LET l_pay_alk13 = g_alk.alk13 * g_alk.alk12 * (100 - g_ala.ala21)/100
             LET l_pay_alk38 = cl_digcut(l_pay_alk38,g_azi04)
             LET l_pay_alk13 = cl_digcut(l_pay_alk13,g_azi04)
             LET g_alk.alk27 = l_pay_alk38 - l_pay_alk13
          ELSE
             LET g_alk.alk27 = g_ala.ala52 - g_ala.ala84 * g_ala.ala34
          END IF
         #----------------------MOD-C70117---------------------(E)
          LET g_alk.alk27 = cl_digcut(g_alk.alk27,g_azi04)
          DISPLAY BY NAME g_alk.alk27
         #END IF                                   #MOD-C70117 mark
 
      AFTER FIELD alk930 
         IF NOT s_costcenter_chk(g_alk.alk930) THEN
            LET g_alk.alk930=g_alk_t.alk930
            DISPLAY BY NAME g_alk.alk930
            DISPLAY NULL TO FORMONLY.gem02b
            NEXT FIELD alk930
         ELSE
            DISPLAY s_costcenter_desc(g_alk.alk930) TO FORMONLY.gem02b
         END IF
         #會科一
          IF p_cmd='u' OR g_alk.alk930 != g_alk_t.alk930 THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ale_file WHERE ale03=g_alk.alk01
             IF l_cnt > 0 THEN
                LET l_aag05=''
                SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_ale[l_ac].ale13
                    AND aag00 = g_bookno1         
                IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale13) THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                   IF g_aaz.aaz90 ='Y' THEN
                      CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale13,g_alk.alk930,g_bookno1) RETURNING g_errno                
                   END IF
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD alk930
                   END IF
                END IF
                
               #會科二
                IF g_aza.aza63='Y' THEN
                   LET l_aag05=''
                   SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_ale[l_ac].ale131
                       AND aag00 = g_bookno2         
                   IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale131) THEN
                     #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                      IF g_aaz.aaz90 ='Y' THEN
                         CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale131,g_alk.alk930,g_bookno2) RETURNING g_errno                
                      END IF
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         NEXT FIELD alk930
                      END IF
                   END IF
                END IF 
             END IF    #MOD-940261 add
          END IF
 
 
        AFTER FIELD alkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD alkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_alk.alkuser = s_get_data_owner("alk_file") #FUN-C10039
         LET g_alk.alkgrup = s_get_data_group("alk_file") #FUN-C10039
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT END IF
          CALL t810_alk04('a')

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(alk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_als"
                 CALL cl_create_qry() RETURNING g_alk.alk01
                 DISPLAY BY NAME g_alk.alk01
            WHEN INFIELD(alk03) # L/C
               CALL q_ala(FALSE,TRUE,g_alk.alk03) RETURNING g_alk.alk03
               DISPLAY BY NAME g_alk.alk03
            WHEN INFIELD(alk05) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_alk.alk05
               CALL cl_create_qry() RETURNING g_alk.alk05
               DISPLAY BY NAME g_alk.alk05
               CALL t810_alk05('d')
            WHEN INFIELD(alk11) # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_alk.alk11
               CALL cl_create_qry() RETURNING g_alk.alk11
               DISPLAY BY NAME g_alk.alk11
            WHEN INFIELD(alk04) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_alk.alk04
               CALL cl_create_qry() RETURNING g_alk.alk04
               DISPLAY BY NAME g_alk.alk04
            WHEN INFIELD(alk07) # L/C No
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_alh1"
               LET g_qryparam.default1 = g_alk.alk07
               LET g_qryparam.arg1 = g_alk.alk03
               CALL cl_create_qry() RETURNING g_alk.alk07
               DISPLAY BY NAME g_alk.alk07
            WHEN INFIELD(alk10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pma"
               LET g_qryparam.default1 = g_alk.alk10
               CALL cl_create_qry() RETURNING g_alk.alk10
               DISPLAY BY NAME g_alk.alk10
            WHEN INFIELD(alk12)
               CALL s_rate(g_alk.alk11,g_alk.alk12)
               RETURNING g_alk.alk12
               DISPLAY BY NAME g_alk.alk12
               NEXT FIELD alk12
            WHEN INFIELD(alk930)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem4"
               CALL cl_create_qry() RETURNING g_alk.alk930
               DISPLAY BY NAME g_alk.alk930
               NEXT FIELD alk930
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
       CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION mul_invoice
         IF g_alk.alk46='MISC' THEN
            IF p_cmd != 'a' THEN
               CALL t810_ddd()
               SELECT pmc03
                 INTO g_pmc03
                 FROM pmc_file
                WHERE pmc01 = g_alk.alk05
               DISPLAY BY NAME g_pmc03
            END IF
         END IF
 
   END INPUT
END FUNCTION
 
FUNCTION t810_alk04(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_gemacti LIKE gem_file.gemacti
    DEFINE l_pma11 LIKE pma_file.pma11
    DEFINE l_dept    LIKE alk_file.alk04   #FUN-660117
    DEFINE l_aps     RECORD LIKE aps_file.*
 
    SELECT gemacti INTO l_gemacti
      FROM gem_file WHERE gem01 = g_alk.alk04
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd != 'a' THEN RETURN END IF
    IF g_apz.apz13 = 'Y' THEN
       LET l_dept = g_alk.alk04
    ELSE
       LET l_dept = ' '
    END IF
    SELECT * INTO l_aps.*
      FROM aps_file WHERE aps01 = l_dept     # 部門預設會計科目檔
    IF STATUS THEN RETURN END IF
    IF cl_null(g_alk.alk44) THEN LET g_alk.alk44 = 'STOCK' END IF
    IF cl_null(g_alk.alk45) THEN LET g_alk.alk45 = l_aps.aps51 END IF
    IF cl_null(g_alk.alk40) THEN LET g_alk.alk40 = l_aps.aps14 END IF
    IF cl_null(g_alk.alk41) THEN LET g_alk.alk41 = l_aps.aps22 END IF
    IF cl_null(g_alk.alk42) THEN LET g_alk.alk42 = l_aps.aps233 END IF
    IF cl_null(g_alk.alk43) THEN LET g_alk.alk43 = l_aps.aps23 END IF
    IF g_aza.aza63 = 'Y' THEN
       IF cl_null(g_alk.alk441) THEN LET g_alk.alk441 = 'STOCK' END IF
       IF cl_null(g_alk.alk451) THEN LET g_alk.alk451 = l_aps.aps511 END IF
       IF cl_null(g_alk.alk401) THEN LET g_alk.alk401 = l_aps.aps141 END IF
       IF cl_null(g_alk.alk411) THEN LET g_alk.alk411 = l_aps.aps221 END IF
       IF cl_null(g_alk.alk421) THEN LET g_alk.alk421 = l_aps.aps238 END IF
       IF cl_null(g_alk.alk431) THEN LET g_alk.alk431 = l_aps.aps235 END IF
    END IF
    SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01 = g_alk.alk10
    IF l_pma11 = '4' THEN LET g_alk.alk41 = l_aps.aps25 END IF
    IF l_pma11 = '6' THEN LET g_alk.alk41 = l_aps.aps55 END IF
    IF g_aza.aza63 = 'Y' THEN
       IF l_pma11 = '4' THEN LET g_alk.alk411 = l_aps.aps251 END IF
       IF l_pma11 = '6' THEN LET g_alk.alk411 = l_aps.aps551 END IF
    END IF
END FUNCTION
 
FUNCTION t810_alk05(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc05   LIKE pmc_file.pmc05
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmc22   LIKE pmc_file.pmc22
    DEFINE l_pmc30   LIKE pmc_file.pmc30
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmc05,pmc22,pmc30,pmcacti
      INTO l_pmc03,l_pmc05,l_pmc22,l_pmc30,l_pmcacti
      FROM pmc_file
     WHERE pmc01 = g_alk.alk05
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'
         WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'
         WHEN l_pmc30   = '1'     LET g_errno = 'aap-103'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DISPLAY l_pmc03 TO pmc03
END FUNCTION
 
FUNCTION t810_alk11(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_alk.alk11
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
         WHEN l_aziacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF g_alk.alk11 != g_aza.aza17 THEN
       CALL s_curr3(g_alk.alk11,g_alk.alk02,g_apz.apz33) RETURNING g_alk.alk12 #FUN-640022
       DISPLAY BY NAME g_alk.alk12
    END IF
END FUNCTION
 
FUNCTION t810_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_alk.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t810_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_ale.clear()
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t810_count
    FETCH t810_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t810_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
       INITIALIZE g_alk.* TO NULL
    ELSE
       CALL t810_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t810_fetch(p_flalk)
    DEFINE
        p_flalk         LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flalk
        WHEN 'N' FETCH NEXT     t810_cs INTO g_alk.alk01
        WHEN 'P' FETCH PREVIOUS t810_cs INTO g_alk.alk01
        WHEN 'F' FETCH FIRST    t810_cs INTO g_alk.alk01
        WHEN 'L' FETCH LAST     t810_cs INTO g_alk.alk01
        WHEN '/'
            IF NOT mi_no_ask THEN
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
            FETCH ABSOLUTE g_jump t810_cs INTO g_alk.alk01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
       INITIALIZE g_alk.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flalk
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_alk.* FROM alk_file       # 重讀DB,因TEMP有不被更新特性
     WHERE alk01 = g_alk.alk01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_alk.alkuser     #No.FUN-4C0047
       LET g_data_group = g_alk.alkgrup     #No.FUN-4C0047
            CALL s_get_bookno(YEAR(g_alk.alk02))                                                                                    
                 RETURNING g_flag,g_bookno1,g_bookno2                                                                               
            IF g_flag = "1" THEN    #抓不到帳別                                                                                     
               CALL cl_err(g_alk.alk02,'aoo-081',1)                                                                                 
            END IF                                                                                                                  
       CALL t810_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t810_show()
    SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_alk.alk11
    SELECT pma11 INTO g_pma11 FROM pma_file WHERE pma01 = g_alk.alk10 #add
    LET g_alk_t.*=g_alk.*
    IF cl_null(g_alk.alk27) THEN LET g_alk.alk27 = 0 END IF
   #LET alk25_26=g_alk.alk25+g_alk.alk26+g_alk.alk27   #MOD-A40072 mark
    LET alk25_26=g_alk.alk25+g_alk.alk26               #MOD-A40072
    DISPLAY BY NAME g_alk.alkoriu,g_alk.alkorig, g_alk.alk97,g_alk.alk01,g_alk.alk10,g_alk.alk02,           #No.FUN-980017
                    g_alk.alk04,g_alk.alk930,g_alk.alk03,g_alk.alk05,g_alk.alk07, #FUN-680019
                    g_alk.alk11,g_alk.alk12,g_alk.alk37,g_alk.alk38,
                    g_alk.alk39,g_alk.alk13,g_alk.alk16,g_alk.alk23,
                    g_alk.alk25,g_alk.alk26,g_alk.alk27,g_alk.alk33,
                    g_alk.alk72,g_alk.alkfirm,alk25_26,g_alk.alk46,
                    g_alk.alkuser,g_alk.alkgrup,     #MOD-490240
                    g_alk.alkmodu,g_alk.alkdate,g_alk.alkacti, #MOD-490240
                    g_alk.alkud01,g_alk.alkud02,g_alk.alkud03,g_alk.alkud04,
                    g_alk.alkud05,g_alk.alkud06,g_alk.alkud07,g_alk.alkud08,
                    g_alk.alkud09,g_alk.alkud10,g_alk.alkud11,g_alk.alkud12,
                    g_alk.alkud13,g_alk.alkud14,g_alk.alkud15
    CALL t810_alk05('d')
    CALL t810_tax()   #MOD-6B0127
    CALL t810_b_tot('d')
    CALL t810_b_fill(g_wc2)
    #CALL cl_set_field_pic(g_alk.alkfirm,"","","","","") #CHI-C80041
    IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"")  #CHI-C80041
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t810_k()
DEFINE l_als   RECORD LIKE als_file.*,
       l_alk23 LIKE alk_file.alk23
    IF s_aapshut(0) THEN RETURN END IF
    IF g_alk.alk01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
    IF g_alk.alkfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_alk.alkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_alk.alkacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_alk.alk01,'9027',0)
       RETURN
    END IF
    MESSAGE ""
    SELECT * INTO l_als.* FROM als_file WHERE als01=g_alk.alk01
    LET l_alk23=l_als.als31+l_als.als32+l_als.als33+
                l_als.als34+l_als.als35+l_als.als36
    IF cl_null(l_alk23) THEN LET l_alk23 = 0 END IF
    LET g_alk.alk25 = g_alk.alk25 - g_alk.alk23 + l_alk23
    LET g_alk.alk23 = l_alk23
   #LET alk25_26=g_alk.alk25+g_alk.alk26+g_alk.alk27   #MOD-A40072 mark
    LET alk25_26=g_alk.alk25+g_alk.alk26               #MOD-A40072
    DISPLAY BY NAME g_alk.alk23,g_alk.alk25,alk25_26
    UPDATE alk_file SET alk23 = g_alk.alk23,    # 更新DB
                        alk25 = g_alk.alk25
     WHERE alk01 = g_alk.alk01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122 
    END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
END FUNCTION
 
FUNCTION t810_u()
DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
   IF s_aapshut(0) THEN RETURN END IF
   IF g_alk.alk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_alk.* FROM alk_file
    WHERE alk01=g_alk.alk01
   IF g_alk.alkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
   IF g_alk.alkacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_alk.alk01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t810_cl USING g_alk.alk01
   IF STATUS THEN
      CALL cl_err("OPEN t810_cl:", STATUS, 1)
      CLOSE t810_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t810_cl INTO g_alk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   LET g_alk01_t = g_alk.alk01
   LET g_alk_o.*=g_alk.*
   LET g_alk.alkmodu=g_user                     #修改者
   LET g_alk.alkdate = g_today                  #修改日期
   CALL t810_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t810_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_alk.*=g_alk_t.*
         CALL t810_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE alk_file SET alk_file.* = g_alk.*    # 更新DB
       WHERE alk01 = g_alk01_t          # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","alk_file",g_alk01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
      CALL t810_b_tot('u')
      IF g_alk_t.alk02 != g_alk.alk02 THEN
         UPDATE npp_file SET npp02=g_alk.alk02
          WHERE npp01=g_alk.alk01 AND npp011=1
            AND npp00 = 4         AND nppsys = 'LC'
         IF STATUS THEN 
         CALL cl_err3("upd","npp_file",g_alk01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
         END IF
      END IF
      #FUN-E80012---add---str---
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
      IF g_nmz.nmz70 = '3' THEN
         LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_alk.alk02,1)
         LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_alk.alk02,3)
         UPDATE tic_file SET tic01=l_tic01,
                              tic02=l_tic02
         WHERE tic04=g_alk.alk01
         IF STATUS THEN
            CALL cl_err3("upd","tic_file",g_alk.alk01,"",STATUS,"","upd tic01 tic02",1)
         END IF
      END IF
      #FUN-E80012---add---end---
      EXIT WHILE
   END WHILE
   CLOSE t810_cl
   COMMIT WORK
   CALL cl_flow_notify(g_alk.alk01,'U')
END FUNCTION
 
FUNCTION t810_npp02(p_npptype)
  DEFINE p_npptype   LIKE npp_file.npptype      #No.FUN-680029
  DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
 
  IF cl_null(g_alk.alk72) THEN
     UPDATE npp_file SET npp02=g_alk.alk02
      WHERE npp01=g_alk.alk01 AND npp011=1
        AND npp00 = 4         AND nppsys = 'LC'
        AND npptype = p_npptype      #No.FUN-680029
     IF STATUS THEN 
     CALL cl_err3("upd","npp_file",g_alk.alk01,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
     END IF
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_alk.alk02,1)
        LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_alk.alk02,3)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_alk.alk01
        IF STATUS THEN
           CALL cl_err3("upd","tic_file",g_alk.alk01,"",STATUS,"","upd tic01 tic02",1)
        END IF
     END IF
     #FUN-E80012---add---end---
  END IF
 
END FUNCTION
 
FUNCTION t810_r()
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_alk.alk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_alk.* FROM alk_file
    WHERE alk01=g_alk.alk01
   IF g_alk.alkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
   SELECT count(*) INTO l_cnt FROM ale_file WHERE ale03 = g_alk.alk01
   IF l_cnt > 0 THEN
      CALL cl_err(g_alk.alk01,'aap-190',0)
      RETURN
   END IF
   BEGIN WORK
   OPEN t810_cl USING g_alk.alk01
   IF STATUS THEN
      CALL cl_err("OPEN t810_cl:", STATUS, 1)
      CLOSE t810_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t810_cl INTO g_alk.*
   IF SQLCA.sqlcode THEN CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0) RETURN END IF
   CALL t810_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "alk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_alk.alk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM alk_file WHERE alk01 = g_alk.alk01
      IF STATUS THEN 
      CALL cl_err3("del","alk_file",g_alk.alk01,"",STATUS,"","del alk:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM ale_file WHERE ale01 = g_alk.alk01
      IF STATUS THEN 
      CALL cl_err3("del","ale_file",g_alk.alk01,"",STATUS,"","del ale:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM npp_file WHERE npp01 = g_alk.alk01
                             AND nppsys = 'LC' AND npp00 = 4
                             AND npp011 = 1  #no.7602
      IF STATUS THEN 
      CALL cl_err3("del","npp_file",g_alk.alk01,"",STATUS,"","del npp:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM npq_file WHERE npq01 = g_alk.alk01
                             AND npqsys = 'LC' AND npq00 = 4
                             AND npq011 = 1  #no.7602
      IF STATUS THEN 
      CALL cl_err3("del","npq_file",g_alk.alk01,"",STATUS,"","del npq:",1)  #No.FUN-660122
      RETURN END IF
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_alk.alk01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_alk.alk01,"",STATUS,"","del tic:",1)
         RETURN
      END IF
      #FUN-B40056--add--end--
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add plant,legal
        VALUES ('saapt810',g_user,g_today,g_msg,g_alk.alk01,'delete',g_plant,g_legal) #FUN-980001 add plant,legal
      CLEAR FORM
      CALL g_ale.clear()
      INITIALIZE g_alk.* TO NULL
      OPEN t810_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t810_cs  
         CLOSE t810_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t810_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t810_cs  
         CLOSE t810_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t810_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t810_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t810_fetch('/')
      END IF
   END IF
   CLOSE t810_cl
   COMMIT WORK
   CALL cl_flow_notify(g_alk.alk01,'D')
END FUNCTION
 
FUNCTION t810_m()
   DEFINE i,j            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
   l_allow_insert   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
   l_allow_delete   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t810_m_w AT 8,30 WITH FORM "aap/42f/aapt710_3"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710_3")
 
 
   DECLARE t810_m_c CURSOR FOR
           SELECT apd02,apd03,'' FROM apd_file
             WHERE apd01 = g_alk.alk01
             ORDER BY apd02
   LET i = 1
   FOREACH t810_m_c INTO g_apd[i].*
      LET i = i + 1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_apd.deleteElement(i)
   LET i = i - 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_apd WITHOUT DEFAULTS FROM s_apd.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
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
   CLOSE WINDOW t810_m_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
 
   WHILE TRUE
      DELETE FROM apd_file
       WHERE apd01 = g_alk.alk01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("del","apd_file",g_alk.alk01,"",SQLCA.sqlcode,"","t810_m(ckp#1):",1)  #No.FUN-660122
         EXIT WHILE
      END IF
      FOR i = 1 TO g_apd.getLength()
         IF g_apd[i].apd03 IS NULL THEN CONTINUE FOR END IF
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add legal FUN-980076 mod
                VALUES(g_alk.alk01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add legal  FUN-980076 mod
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("ins","apd_file",g_alk.alk01,"",SQLCA.sqlcode,"","t810_m(ckp#2):",1)  #No.FUN-660122
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
 
FUNCTION t810_firm1()
   DEFINE tot1,tot2     LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE only_one      LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
   DEFINE l_wc          LIKE type_file.chr1000     #No.FUN-690028 VARCHAR(100)
   DEFINE l_sql         LIKE type_file.chr1000     #No.FUN-690028 VARCHAR(500)
   DEFINE l_alk RECORD LIKE alk_file.*             
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
   IF g_alk.alkfirm='Y' THEN RETURN END IF
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alk.alk02<=g_apz.apz57 THEN
    # CALL cl_err(g_alk.alk01,'aap-176',1)               #TQC-B10069 
      CALL s_errmsg("alk02",g_alk.alk01,"",'aap-176',1)  #TQC-B10069
    # RETURN         #TQC-B10069
   END IF
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
    WHERE azi01 = g_alk.alk11
 
 
   OPEN WINDOW t810_w6 AT 8,18 WITH FORM "aap/42f/aapt810_6"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt810_6")
 
 
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
      CLOSE WINDOW t810_w6
      RETURN
   END IF
   IF only_one = '1' THEN
      LET l_wc = " alk01 = '",g_alk.alk01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
      CONSTRUCT BY NAME l_wc ON alk01,alk02,alk03,alk05,alk07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(alk03) # L/C
                    CALL q_ala(TRUE,TRUE,g_alk.alk03)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO alk03
                 WHEN INFIELD(alk05) #PAY TO VENDOR
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_pmc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO alk05
                    CALL t810_alk05('d')
                WHEN INFIELD(alk07) # L/C No
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_alh1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO alk07
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
           CLOSE WINDOW t810_w6
           RETURN
        END IF
   END IF
   LET l_alk.*     = g_alk.*
 
   IF NOT cl_confirm('axm-108') THEN  
       CLOSE WINDOW t810_w6   #NO.MOD-5B0176 
       RETURN  
   END IF  
#CHI-C30107 ---------------- add ----------------- begin
   IF only_one = '1' THEN
      SELECT * INTO g_alk.* FROM alk_file
       WHERE alk01=g_alk.alk01
      IF g_alk.alkfirm='Y' THEN RETURN END IF         
   END IF
#CHI-C30107 ---------------- add ----------------- end
   MESSAGE "WORKING !"
      LET l_sql = "SELECT alk_file.*  FROM alk_file WHERE ",l_wc CLIPPED,
                  "   AND alkfirm <> 'Y' "
    
      PREPARE t810_firm6  FROM l_sql
      DECLARE t810_firm66 CURSOR WITH HOLD FOR t810_firm6
   BEGIN WORK
   LET g_success='Y'
      OPEN t810_cl USING g_alk.alk01
      IF STATUS THEN
      #  CALL cl_err("OPEN t810_cl:", STATUS, 1)       #TQC-B10069
         CALL s_errmsg("",g_alk.alk01,"OPEN t810_cl:",STATUS,1)  #TQC-B10069
         CLOSE t810_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t810_cl INTO g_alk.*               # 對DB鎖定
      IF SQLCA.sqlcode THEN
      #  CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)          #TQC-B10069
         CALL s_errmsg("",g_alk.alk01,"",SQLCA.sqlcode,1)  #TQC-B10069 
         ROLLBACK WORK
         RETURN
      END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   FOREACH t810_firm66 INTO g_alk.*
      IF g_alk.alk02<=g_apz.apz57 THEN
      #  CALL cl_err(g_alk.alk01,'aap-176',1) CONTINUE FOREACH       #TQC-B10069
         CALL s_errmsg("alk02",g_alk.alk01,"",'aap-176',1)           #TQC-B10069
         LET g_success='N'    
         CONTINUE FOREACH       #TQC-B10069 
      END IF
      SELECT COUNT(*) INTO g_cnt FROM ale_file
       WHERE ale01=g_alk.alk01
      IF g_cnt = 0 THEN
      #  CALL cl_err(g_alk.alk01,'arm-034',1) LET g_success='N' EXIT FOREACH    #TQC-B10069
         CALL s_errmsg("alk01",g_alk.alk01,"",'arm-034',1)           #TQC-B10069
         LET g_success='N'     
         CONTINUE FOREACH       #TQC-B10069 
      END IF
    
      SELECT SUM(ale07),SUM(ale09) INTO tot1,tot2 FROM ale_file
       WHERE ale01 = g_alk.alk01
      IF tot1 IS NULL THEN LET tot1=0 END IF
      IF tot2 IS NULL THEN LET tot2=0 END IF
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
             WHERE azi01 = g_alk.alk11
      LET tot1  = cl_digcut(tot1 ,t_azi04)
      IF g_alk.alk13 <> tot1 THEN
      #  CALL cl_err(g_alk.alk13,'aap-734',1) CONTINUE FOREACH       #TQC-B10069
         CALL s_errmsg("alk13",g_alk.alk01,g_alk.alk13,'aap-734',1)  #TQC-B10069
         LET g_success='N'   
         CONTINUE FOREACH       #TQC-B10069
      END IF
     #IF (g_alk.alk25+g_alk.alk26+g_alk.alk27) <> tot2 THEN             #MOD-A40072 mark
      IF (g_alk.alk25+g_alk.alk26) <> tot2 THEN                         #MOD-A40072
        #CALL cl_err(g_alk.alk25+g_alk.alk26+g_alk.alk27,'aap-735',1)   #MOD-A40072 mark
        #CALL cl_err(g_alk.alk25+g_alk.alk26,'aap-735',1)               #MOD-A40072 #TQC-B10069
         CALL s_errmsg("",g_alk.alk01,g_alk.alk25+g_alk.alk26,'aap-734',1)  #TQC-B10069
         LET g_success='N'      #TQC-B10069
         CONTINUE FOREACH
      END IF
      CALL s_chknpq1(g_alk.alk01,1,4,'0',g_bookno1)    #No.FUN-730064  #check平衡
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq1(g_alk.alk01,1,4,'1',g_bookno2)    #No.TQC-740093  #check平衡
      END IF
     #IF g_success = 'N' THEN EXIT FOREACH END IF      #TQC-B10069
      IF g_success = 'N' THEN                          #TQC-B10069  
         CONTINUE FOREACH                              #TQC-B10069
      END IF                                           #TQC-B10069  
      UPDATE alk_file SET alkfirm = 'Y' WHERE alk01=g_alk.alk01
      IF STATUS THEN
        #CALL cl_err3("upd","alk_file",g_alk.alk01,"",STATUS,"","upd alkfirm:",1)  #No.FUN-660122    #TQC-B10069
         CALL s_errmsg("alk01",g_alk.alk01,"upd alkfirm:",'aap-734',1)  #TQC-B10069
         LET g_success='N'
         CONTINUE FOREACH      #TQC-B10069
      END IF
      CALL t810_ins_apa()
      CALL t810_y1()
 #    IF g_success='N' THEN EXIT FOREACH END IF  #TQC-B10069
      IF g_success='N' THEN                      #TQC-B10069
         CONTINUE FOREACH                        #TQC-B10069
      END IF                                     #TQC-B10069
   END FOREACH              
   CLOSE WINDOW t810_w6    
      LET g_alk.*     = l_alk.*
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
         CALL cl_flow_notify(g_alk.alk01,'Y')
      ELSE
         CALL cl_rbmsg(1)
         ROLLBACK WORK
      END IF
   SELECT alkfirm INTO g_alk.alkfirm
     FROM alk_file WHERE alk01 = g_alk.alk01
   DISPLAY BY NAME g_alk.alkfirm
END FUNCTION
 
FUNCTION t810_firm2()
   DEFINE only_one LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
   DEFINE l_alk    RECORD LIKE alk_file.*
   DEFINE l_wc     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(100)
   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(500)
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
   IF g_alk.alkfirm='N' THEN RETURN END IF
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alk.alk02<=g_apz.apz57 THEN
      CALL cl_err(g_alk.alk01,'aap-176',1) RETURN
   END IF
 
   IF NOT cl_null(g_alk.alk72) THEN  
      CALL cl_err(g_alk.alk01,'axr-370',0) RETURN  
   END IF 
 
   LET l_alk.*     = g_alk.*
 

   LET l_wc = " alk01 = '",g_alk.alk01,"' "
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t810_cl USING g_alk.alk01
   IF STATUS THEN
      CALL cl_err("OPEN t810_cl:", STATUS, 1)
      CLOSE t810_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t810_cl INTO g_alk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   MESSAGE "WORKING !"
 
   LET l_sql = "SELECT alk_file.*  FROM alk_file WHERE ",l_wc CLIPPED,
               "   AND alkfirm <> 'N' "
 
   PREPARE t810_firm8  FROM l_sql
   DECLARE t810_firm88 CURSOR WITH HOLD FOR t810_firm8
 
   FOREACH t810_firm88 INTO g_alk.* 
      UPDATE alk_file SET alkfirm = 'N' WHERE alk01 = g_alk.alk01
      IF STATUS THEN
         CALL cl_err3("upd","alk_file",g_alk.alk01,"",STATUS,"","upd alkfirm:",1)  #No.FUN-660122
  
         LET g_success='N'
      END IF
      CALL t810_del_apa()
      CALL t810_y1()
      IF g_success='N' THEN EXIT FOREACH END IF
   END FOREACH
 
   CLOSE WINDOW t810_w8
   LET g_alk.*     = l_alk.*
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   SELECT alkfirm INTO g_alk.alkfirm
     FROM alk_file WHERE alk01 = g_alk.alk01
  DISPLAY BY NAME g_alk.alkfirm
END FUNCTION
 
FUNCTION t810_y1()
   DECLARE t810_y1_c CURSOR FOR
      SELECT * FROM ale_file WHERE ale01=g_alk.alk01 ORDER BY 1,2
   CALL t810_hu_ala()
   CALL t810_hu_alh()
   FOREACH t810_y1_c INTO b_ale.*
      IF STATUS THEN EXIT FOREACH END IF
      CALL t810_bu_alb()
      CALL t810_bu_rvv()
   END FOREACH
 
END FUNCTION
 
FUNCTION t810_b_tot(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1           # u:要更新單頭 alk_file d:Displayonly  #No.FUN-690028 VARCHAR(1)
   DEFINE tot1,tot2,m1,m2    LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   LET tot1=0 LET tot2=0
   SELECT SUM(ale07),SUM(ale09) INTO tot1,tot2 FROM ale_file
          WHERE ale01 = g_alk.alk01
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
          WHERE azi01 = g_alk.alk11
   IF STATUS THEN 
   CALL cl_err3("sel","azi_file",g_alk.alk11,"",STATUS,"","sel sum(ale07):",1)  #No.FUN-660122
   LET z='N' END IF
   IF cl_null(tot1) THEN LET tot1=0 END IF
   IF cl_null(tot2) THEN LET tot2=0 END IF
   LET tot1  = cl_digcut(tot1,t_azi04)
   DISPLAY BY NAME tot1,tot2
   IF p_cmd='d' THEN RETURN END IF
   IF p_cmd = 'u' THEN
     DISPLAY BY NAME g_alk.alk16,g_alk.alk25,alk25_26
     UPDATE alk_file SET alk16=g_alk.alk16,alk25=g_alk.alk25
      WHERE alk01=g_alk.alk01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        SELECT * INTO g_alk.* FROM alk_file WHERE alk01=g_alk.alk01
       #LET alk25_26=g_alk.alk25+g_alk.alk26+g_alk.alk27   #MOD-A40072 mark
        LET alk25_26=g_alk.alk25+g_alk.alk26               #MOD-A40072
        DISPLAY BY NAME g_alk.alk16,g_alk.alk25,alk25_26
     END IF
   END IF
END FUNCTION
 
FUNCTION t810_alk25_26()
   DEFINE tot1,tot2,m1,m2    LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_ala21,l_ala23_24,l_ala59_60,l_ala61  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_pma11 LIKE pma_file.pma11
   DEFINE l_ala56 LIKE ala_file.ala56
 
   SELECT ala21,ala23 + ala24,ala59 + ala60,ala61,ala56
     INTO l_ala21,l_ala23_24,l_ala59_60,l_ala61,l_ala56
     FROM ala_file
    WHERE ala01 = g_alk.alk03
 
   IF STATUS THEN
      LET l_ala21 = 0
      LET l_ala23_24 = 0
      LET l_ala59_60 = 0
   END IF
 
   LET g_alk.alk25=g_alk.alk16+g_alk.alk23
 
   IF l_ala59_60 != 0 THEN
      IF l_ala23_24 = 0 THEN
         LET g_alk.alk26 = 0
         LET g_alk.alk27 = 0
      ELSE
         SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01 = g_alk.alk10
         IF l_pma11 MATCHES '[46]' THEN # Thomas 98/01/02 OA保險費在這時分攤
            LET g_alk.alk26 = l_ala56
         ELSE
            LET g_alk.alk26=l_ala59_60 * (g_alk.alk13/l_ala23_24)
         END IF
      END IF
 
      IF g_alk.alk26 IS NULL THEN
         LET g_alk.alk26 = 0
      END IF
 
      IF g_alk.alk27 IS NULL THEN
         LET g_alk.alk27 = 0
      END IF
 
      IF l_ala59_60 - l_ala61 - g_alk.alk26 >= -5 AND      #允許5元內全部攤畢
         l_ala59_60 - l_ala61 - g_alk.alk26 <= 5  THEN
         LET g_alk.alk26 = l_ala59_60 - l_ala61
         IF g_alk.alk26 IS NULL THEN
            LET g_alk.alk26 = 0
         END IF
      END IF
   ELSE
      LET g_alk.alk26=0
   END IF
 
   LET g_alk.alk26 = cl_digcut(g_alk.alk26,g_azi04)
  #LET alk25_26 = g_alk.alk25 + g_alk.alk26 + g_alk.alk27    #MOD-A40072 mark
   LET alk25_26 = g_alk.alk25 + g_alk.alk26                  #MOD-A40072
   DISPLAY BY NAME g_alk.alk25,g_alk.alk26,alk25_26,g_alk.alk27
 
END FUNCTION
 
FUNCTION t810_hu_ala()
   DEFINE tot1,tot2  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_ala61  LIKE ala_file.ala61
 
   LET tot1=0 LET tot2=0
   SELECT SUM(ale07),SUM(ale09) INTO tot1,tot2      # 取總共已到貨金額
     FROM alk_file, ale_file
    WHERE alk03=g_alk.alk03 AND alk01=ale01 AND alkfirm='Y'
   IF STATUS THEN 
   CALL cl_err3("sel","alk_file,ale_file",g_alk.alk01,g_alk.alk03,STATUS,"","sel sum(ale07):",1)  #No.FUN-660122
   LET z='N' END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
 
   SELECT SUM(alk26) INTO tot2 FROM alk_file
    WHERE alk03=g_alk.alk03 AND alkfirm='Y'
   IF STATUS THEN 
   CALL cl_err3("sel","alk_file",g_alk.alk03,"",STATUS,"","sel sum(alk26):",1)  #No.FUN-660122
   LET z='N' END IF
   IF tot2 IS NULL THEN LET tot2=0 END IF
   SELECT ala23+ala24 INTO l_ala61 FROM ala_file
    WHERE ala01=g_alk.alk03 AND alafirm <> 'X'
   IF STATUS THEN LET z='N' END IF
   IF tot1 > l_ala61 THEN LET z='N' END IF
   UPDATE ala_file SET ala26=tot1,
                       ala61=tot2    # 更新LC到貨/預付已攤金額
    WHERE ala01=g_alk.alk03
   IF STATUS THEN 
   CALL cl_err3("upd","ala_file",g_alk.alk03,"",STATUS,"","upd ala61:",1)  #No.FUN-660122
   LET z='N' END IF
END FUNCTION
 
FUNCTION t810_hu_alh()
   DEFINE tot1,tot2  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   IF g_alk.alk07 IS NULL THEN RETURN END IF
   LET tot1=0
   SELECT SUM(alk13) INTO tot1      # 取總共已到貨金額
     FROM alk_file WHERE alk07=g_alk.alk07 AND alkfirm='Y'
   IF STATUS THEN 
   CALL cl_err3("sel","alk_file",g_alk.alk07,"",STATUS,"","sel sum(alk16):",1)  #No.FUN-660122
   LET z='N' END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
   UPDATE alh_file SET alh17=tot1      # 更新alh17(已到貨金額)
    WHERE alh01=g_alk.alk07
   IF STATUS THEN 
   CALL cl_err3("upd","alh_file",g_alk.alk07,"",STATUS,"","upd alh17:",1)  #No.FUN-660122
   LET z='N' END IF
END FUNCTION
 
FUNCTION t810_bu_alb()
   DEFINE tot1,tot2  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   LET tot1=0 LET tot2=0
  #FUN-A60056--mod--str--
  #SELECT SUM(ale06),SUM(ale07) INTO tot1,tot2      # 取總共已到貨量,額
  #  FROM alk_file, ale_file,rvv_file   #MOD-690157
  # WHERE alk03=g_alk.alk03 AND alk01=ale01 AND alkfirm='Y'
  #   AND ale14=b_ale.ale14 AND ale15=b_ale.ale15
  #   AND ale16=rvv01 AND ale17=rvv02 AND rvv25 <> 'Y'   #MOD-690157
   LET g_sql = "SELECT SUM(ale06),SUM(ale07) FROM alk_file, ale_file,",
                cl_get_target_table(g_alk.alk97,'rvv_file'),
               " WHERE alk03='",g_alk.alk03,"' AND alk01=ale01 AND alkfirm='Y'",
               "   AND ale14='",b_ale.ale14,"' AND ale15='",b_ale.ale15,"'",
               "   AND ale16=rvv01 AND ale17=rvv02 AND rvv25 <> 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE sel_sum_ale06 FROM g_sql
   EXECUTE sel_sum_ale06 INTO tot1,tot2   # 取總共已到貨量,額
  #FUN-A60056--mod--end
   IF STATUS THEN 
   CALL cl_err3("sel","alk_file,ale_file",g_alk.alk03,b_ale.ale14,STATUS,"","sel sum(ale06):",1)  #No.FUN-660122
   LET z='N' END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
   IF tot2 IS NULL THEN LET tot2=0 END IF
   UPDATE alb_file SET alb12=tot1, alb13=tot2      # 更新LC已到貨量,額
    WHERE alb01=g_alk.alk03
      AND alb04=b_ale.ale14 AND alb05=b_ale.ale15
   IF STATUS THEN 
   CALL cl_err3("upd","alb_file",g_alk.alk03,b_ale.ale14,STATUS,"","upd alb12,13:",1)  #No.FUN-660122
   LET z='N' END IF
END FUNCTION
 
FUNCTION t810_bu_rvv()
   DEFINE tot1,tot2   LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
 
   LET tot1=0 LET tot2=0
   SELECT SUM(ale06) INTO tot1            # 取總共已到貨量(lc系統)
           FROM ale_file,alk_file
           WHERE ale16=b_ale.ale16 AND ale17=b_ale.ale17
             AND ale01=alk01 AND alkfirm='Y'
   IF STATUS THEN 
   CALL cl_err3("sel","ale_file,alk_file",b_ale.ale16,b_ale.ale17,STATUS,"","sel sum(ale06-2):",1)  #No.FUN-660122
   LET z='N' END IF
   IF tot1 IS NULL THEN LET tot1=0 END IF
   IF tot2 IS NULL THEN LET tot2=0 END IF
   LET tot1=tot1+tot2

   LET g_plant_new=g_alk.alk97                               #No.FUN-980017
   CALL s_getdbs()
 
   LET g_plant_new=g_alk.alk97                               #No.FUN-980017
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
 
   #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," rvv_file SET rvv23 = ? ", #FUN-980093 add
   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'rvv_file'), #FUN-A50102
               "   SET rvv23 = ? ",
               " WHERE rvv01 = ?  AND rvv02 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980093
   PREPARE t810_upd_rvv FROM g_sql
   EXECUTE t810_upd_rvv USING tot1,b_ale.ale16,b_ale.ale17
   IF STATUS THEN CALL cl_err('upd rvv23:',STATUS,1) LET z='N' END IF
END FUNCTION
 
FUNCTION t810_out(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_wc         LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a' THEN
      LET l_wc = 'alk01="',g_alk.alk01,'"'             # "新增"則印單張
   ELSE
      LET l_wc = g_wc                                  # 其他則印多張
   END IF
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) END IF
   #LET l_cmd = "aapr812", #FUN-C30085 mark
   LET l_cmd = "aapg812", #FUN-C30085 add
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' ",
               " '",l_wc CLIPPED,"'"   #bugno:6322
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
FUNCTION t810_7(p_sw)
   DEFINE p_sw      LIKE type_file.chr1              # 1.不要update alk 2.要update alk  #No.FUN-690028 VARCHAR(1)
   DEFINE aag02_0,aag02_1,aag02_2,aag02_3,aag02_4,aag02_5 LIKE aag_file.aag02  #FUN-660117
   DEFINE aag02_6,aag02_7,aag02_8,aag02_9,aag02_10,aag02_11 LIKE aag_file.aag02       #No.FUN-680029
   DEFINE o_alk RECORD LIKE alk_file.*
   DEFINE l_aag05 LIKE aag_file.aag05   #TQC-620028
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
   LET o_alk.*=g_alk.*
 
 
   OPEN WINDOW t810_4_w AT 8,3 WITH FORM "aap/42f/aapt810_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt810_1")
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("group03,group04",TRUE)      #No.TQC-750034
    ELSE
       CALL cl_set_comp_visible("group03,group04",FALSE)      #No.TQC-750034
    END IF
 
 
   SELECT aag02 INTO aag02_4 FROM aag_file WHERE aag01=g_alk.alk44
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_5 FROM aag_file WHERE aag01=g_alk.alk45
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_0 FROM aag_file WHERE aag01=g_alk.alk40
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alk.alk41
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alk.alk42
                                             AND aag00=g_bookno1     #No.FUN-730064
   SELECT aag02 INTO aag02_3 FROM aag_file WHERE aag01=g_alk.alk43
                                             AND aag00=g_bookno1     #No.FUN-730064
   IF g_aza.aza63 = 'Y' THEN
      SELECT aag02 INTO aag02_10 FROM aag_file WHERE aag01=g_alk.alk441
                                                 AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_11 FROM aag_file WHERE aag01=g_alk.alk451
                                                 AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_6 FROM aag_file WHERE aag01=g_alk.alk401
                                                AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_7 FROM aag_file WHERE aag01=g_alk.alk411
                                                AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_8 FROM aag_file WHERE aag01=g_alk.alk421
                                                AND aag00=g_bookno2     #No.FUN-730064
      SELECT aag02 INTO aag02_9 FROM aag_file WHERE aag01=g_alk.alk431
                                                AND aag00=g_bookno2     #No.FUN-730064
   END IF
   DISPLAY BY NAME aag02_4,aag02_5,aag02_0,aag02_1,aag02_2,aag02_3,aag02_10,aag02_11,aag02_6,aag02_7,aag02_8,aag02_9 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME g_alk.alk44,g_alk.alk45,
                 g_alk.alk40,g_alk.alk41,g_alk.alk42,g_alk.alk43,
                 g_alk.alk441,g_alk.alk451,
                 g_alk.alk401,g_alk.alk411,g_alk.alk421,g_alk.alk431
                 WITHOUT DEFAULTS
 
     AFTER FIELD alk44
         IF g_alk.alk44 ='STOCK' THEN DISPLAY '' TO aag02_4 END IF
          IF g_alk.alk44 ='UNAP' THEN DISPLAY '' TO aag02_4 END IF      #No.MOD-530129
         IF g_alk.alk44 IS NOT NULL AND g_alk.alk44 !='STOCK'
                                    AND g_alk.alk44 !='UNAP' THEN      #No.MOD-530129
            #No.FUN-B10050  --Begin
            #SELECT aag02 INTO aag02_4 FROM aag_file WHERE aag01=g_alk.alk44
            #                                          AND aag00=g_bookno1     #No.FUN-730064
            #IF STATUS THEN 
            #CALL cl_err3("sel","aag_file",g_alk.alk44,"",STATUS,"","sel aag:",1)  #No.FUN-660122
            #NEXT FIELD alk44 END IF
            #DISPLAY BY NAME aag02_4

            LET g_pass = 'Y'
            CALL t810_aag01(g_bookno1,g_alk.alk44,'4')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alk.alk44,g_errno,0)
               LET g_pass = 'N'
            END IF
            #No.FUN-B10050  --End

            IF g_pass = 'Y' THEN      #No.FUN-B10050
               SELECT aag05 INTO l_aag05 FROM aag_file
                 WHERE aag01 = g_alk.alk44
                   AND aag00=g_bookno1     #No.FUN-730064
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 ='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_alk.alk44,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                  ELSE
                     CALL s_chkdept(g_aaz.aaz72,g_alk.alk44,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     #No.FUN-B10050  --Begin
                     LET g_pass = 'N'
                     #NEXT FIELD alk44
                     #No.FUN-B10050  --End
                  END IF
               END IF   #TQC-620028
            END IF                    #No.FUN-B10050
            #No.FUN-B10050  --Begin
            IF g_pass = 'N' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alk.alk44
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk44 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alk.alk44          
               DISPLAY BY NAME g_alk.alk44          
               NEXT FIELD alk44
            END IF
            #No.FUN-B10050  --End
         END IF
 
     AFTER FIELD alk45
        IF NOT cl_null(g_alk.alk45) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_5 FROM aag_file WHERE aag01=g_alk.alk45
           #                                          AND aag00=g_bookno1     #No.FUN-730064
           #DISPLAY BY NAME aag02_5

           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno1,g_alk.alk45,'5')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk45,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk45
                  AND aag00=g_bookno1     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk45,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk45,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk45
                    #No.FUN-B10050  --End
                 END IF
              END IF   #TQC-620028
            END IF                    #No.FUN-B10050
            #No.FUN-B10050  --Begin
            IF g_pass = 'N' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alk.alk45
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk45 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alk.alk45
               DISPLAY BY NAME g_alk.alk45
               NEXT FIELD alk45
            END IF
            #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk40
        IF NOT cl_null(g_alk.alk40) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_0 FROM aag_file WHERE aag01=g_alk.alk40  
           #                                          AND aag00=g_bookno1     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk40,"",STATUS,"","sel aag:",1)  #No.FUN-660122
           #NEXT FIELD alk40 END IF
           #DISPLAY BY NAME aag02_0
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno1,g_alk.alk40,'0')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk40,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk40
                  AND aag00=g_bookno1     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk40,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk40,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk40
                    #No.FUN-B10050  --End
                 END IF
              END IF   #TQC-620028
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk40
              LET g_qryparam.arg1 = g_bookno1
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk40 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk40
              DISPLAY BY NAME g_alk.alk40
              NEXT FIELD alk40
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk41
        IF NOT cl_null(g_alk.alk41) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alk.alk41 
           #                                          AND aag00=g_bookno1     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk41,"",STATUS,"","sel aag:",1)  #No.FUN-660122
           #NEXT FIELD alk41 END IF
           #DISPLAY BY NAME aag02_1
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno1,g_alk.alk41,'1')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk41,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk41
                  AND aag00=g_bookno1     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk41,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk41,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk41
                    #No.FUN-B10050  --End
                 END IF
              END IF   #TQC-620028
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk41
              LET g_qryparam.arg1 = g_bookno1
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk41 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk41
              DISPLAY BY NAME g_alk.alk41
              NEXT FIELD alk41
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk42
        IF NOT cl_null(g_alk.alk42) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alk.alk42
           #                                          AND aag00=g_bookno1     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk42,"",STATUS,"","sel aag:",1)  #No.FUN-660122
           #NEXT FIELD alk42 END IF
           #DISPLAY BY NAME aag02_2
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno1,g_alk.alk42,'2')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk42,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              #-----TQC-620028---------
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk42
                  AND aag00=g_bookno1     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk42,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk42,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk42
                    #No.FUN-B10050  --End
                 END IF
              END IF   #TQC-620028
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk42
              LET g_qryparam.arg1 = g_bookno1
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk42 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk42
              DISPLAY BY NAME g_alk.alk42
              NEXT FIELD alk42
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk43
        IF NOT cl_null(g_alk.alk43) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_3 FROM aag_file WHERE aag01=g_alk.alk43
           #                                          AND aag00=g_bookno1     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk43,"",STATUS,"","sel aag:",1)  #No.FUN-660122
           #NEXT FIELD alk43 END IF
           #DISPLAY BY NAME aag02_3
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno1,g_alk.alk43,'3')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk43,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk43
                  AND aag00=g_bookno1     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk43,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk43,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk43
                    #No.FUN-B10050  --End
                 END IF
              END IF   #TQC-620028
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk43
              LET g_qryparam.arg1 = g_bookno1
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk43 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk43
              DISPLAY BY NAME g_alk.alk43
              NEXT FIELD alk43
           END IF
           #No.FUN-B10050  --End
        END IF
     AFTER FIELD alk441
         IF g_alk.alk441 ='STOCK' THEN DISPLAY '' TO aag02_10 END IF
          IF g_alk.alk441 ='UNAP' THEN DISPLAY '' TO aag02_10 END IF
         IF g_alk.alk441 IS NOT NULL AND g_alk.alk441 !='STOCK'
                                     AND g_alk.alk441 !='UNAP' THEN
            #No.FUN-B10050  --Begin
            #SELECT aag02 INTO aag02_10 FROM aag_file WHERE aag01=g_alk.alk441
            #                                           AND aag00=g_bookno2     #No.FUN-730064
            #IF STATUS THEN 
            #CALL cl_err3("sel","aag_file",g_alk.alk441,"",STATUS,"","sel aag:",1)
            #NEXT FIELD alk441 END IF
            #DISPLAY BY NAME aag02_10
            LET g_pass = 'Y'
            CALL t810_aag01(g_bookno2,g_alk.alk441,'A')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alk.alk441,g_errno,0)
               LET g_pass = 'N'
            END IF
            #No.FUN-B10050  --End  
            IF g_pass = 'Y' THEN      #No.FUN-B10050
               SELECT aag05 INTO l_aag05 FROM aag_file
                 WHERE aag01 = g_alk.alk441
                   AND aag00=g_bookno2     #No.FUN-730064
               IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 ='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_alk.alk441,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                  ELSE
                     CALL s_chkdept(g_aaz.aaz72,g_alk.alk441,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk441
                    #No.FUN-B10050  --End
                  END IF
               END IF
            END IF                    #No.FUN-B10050
            #No.FUN-B10050  --Begin
            IF g_pass = 'N' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_alk.alk441
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk441 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_alk.alk441
               DISPLAY BY NAME g_alk.alk441
               NEXT FIELD alk441
            END IF
            #No.FUN-B10050  --End
         END IF
 
     AFTER FIELD alk451
        IF NOT cl_null(g_alk.alk451) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_11 FROM aag_file WHERE aag01=g_alk.alk451
           #                                           AND aag00=g_bookno2     #No.FUN-730064
           #DISPLAY BY NAME aag02_11
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno2,g_alk.alk451,'B')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk451,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk451
                  AND aag00=g_bookno2     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk451,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk451,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk451
                    #No.FUN-B10050  --End
                 END IF
              END IF
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk451
              LET g_qryparam.arg1 = g_bookno2
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk451 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk451
              DISPLAY BY NAME g_alk.alk451
              NEXT FIELD alk451
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk401
        IF NOT cl_null(g_alk.alk401) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_6 FROM aag_file WHERE aag01=g_alk.alk401
           #                                          AND aag00=g_bookno2     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk401,"",STATUS,"","sel aag:",1)
           #NEXT FIELD alk401 END IF
           #DISPLAY BY NAME aag02_6
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno2,g_alk.alk401,'6')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk401,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk401
                  AND aag00=g_bookno2     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk401,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk401,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk401
                    #No.FUN-B10050  --End
                 END IF
              END IF
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk401
              LET g_qryparam.arg1 = g_bookno2
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk401 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk401
              DISPLAY BY NAME g_alk.alk401
              NEXT FIELD alk401
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk411
        IF NOT cl_null(g_alk.alk411) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_7 FROM aag_file WHERE aag01=g_alk.alk411
           #                                          AND aag00=g_bookno2     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk411,"",STATUS,"","sel aag:",1)
           #NEXT FIELD alk411 END IF
           #DISPLAY BY NAME aag02_7
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno2,g_alk.alk411,'7')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk411,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk411
                  AND aag00=g_bookno2     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk411,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk411,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk411
                    #No.FUN-B10050  --End
                 END IF
              END IF
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk411
              LET g_qryparam.arg1 = g_bookno2
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk411 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk411
              DISPLAY BY NAME g_alk.alk411
              NEXT FIELD alk411
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk421
        IF NOT cl_null(g_alk.alk421) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_8 FROM aag_file WHERE aag01=g_alk.alk421
           #                                          AND aag00=g_bookno2     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk421,"",STATUS,"","sel aag:",1)
           #NEXT FIELD alk421 END IF
           #DISPLAY BY NAME aag02_8
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno2,g_alk.alk421,'8')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk421,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk421
                  AND aag00=g_bookno2     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk421,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk421,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk421
                    #No.FUN-B10050  --End
                 END IF
              END IF
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk421
              LET g_qryparam.arg1 = g_bookno2
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk421 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk421
              DISPLAY BY NAME g_alk.alk421
              NEXT FIELD alk421
           END IF
           #No.FUN-B10050  --End
        END IF
 
     AFTER FIELD alk431
        IF NOT cl_null(g_alk.alk431) THEN
           #No.FUN-B10050  --Begin
           #SELECT aag02 INTO aag02_9 FROM aag_file WHERE aag01=g_alk.alk431
           #                                          AND aag00=g_bookno2     #No.FUN-730064
           #IF STATUS THEN 
           #CALL cl_err3("sel","aag_file",g_alk.alk431,"",STATUS,"","sel aag:",1)
           #NEXT FIELD alk431 END IF
           #DISPLAY BY NAME aag02_9
           LET g_pass = 'Y'
           CALL t810_aag01(g_bookno2,g_alk.alk431,'9')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_alk.alk431,g_errno,0)
              LET g_pass = 'N'
           END IF
           #No.FUN-B10050  --End  
           IF g_pass = 'Y' THEN      #No.FUN-B10050
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_alk.alk431
                  AND aag00=g_bookno2     #No.FUN-730064
              IF l_aag05 = 'Y' THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk431,g_alk.alk930,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 ELSE
                    CALL s_chkdept(g_aaz.aaz72,g_alk.alk431,g_alk.alk04,g_bookno2) RETURNING g_errno  #No.FUN-730064
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    #No.FUN-B10050  --Begin
                    LET g_pass = 'N'
                    #NEXT FIELD alk431
                    #No.FUN-B10050  --End
                 END IF
              END IF
           END IF                    #No.FUN-B10050
           #No.FUN-B10050  --Begin
           IF g_pass = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_alk.alk431
              LET g_qryparam.arg1 = g_bookno2
              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_alk.alk431 CLIPPED,"%'"
              CALL cl_create_qry() RETURNING g_alk.alk431
              DISPLAY BY NAME g_alk.alk431
              NEXT FIELD alk431
           END IF
           #No.FUN-B10050  --End
        END IF
 
      ON ACTION CONTROLP # Thomas 98/08/17 增加function key
        CASE
           WHEN INFIELD(alk40)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk40
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk40
              NEXT FIELD alk40
           WHEN INFIELD(alk41)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk41
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk41
              DISPLAY BY NAME g_alk.alk41
              NEXT FIELD alk41
           WHEN INFIELD(alk42)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk42
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk42
              DISPLAY BY NAME g_alk.alk42
              NEXT FIELD alk42
           WHEN INFIELD(alk43)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk43
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk43
              DISPLAY BY NAME g_alk.alk43
              NEXT FIELD alk43
           WHEN INFIELD(alk44)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk44
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk44
              DISPLAY BY NAME g_alk.alk44
              NEXT FIELD alk44
           WHEN INFIELD(alk45)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk45
              LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk45
              DISPLAY BY NAME g_alk.alk45
              NEXT FIELD alk45
           WHEN INFIELD(alk401)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk401
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk401
              NEXT FIELD alk401
           WHEN INFIELD(alk411)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk411
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk411
              DISPLAY BY NAME g_alk.alk411
              NEXT FIELD alk411
           WHEN INFIELD(alk421)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk421
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk421
              DISPLAY BY NAME g_alk.alk421
              NEXT FIELD alk421
           WHEN INFIELD(alk431)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk431
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk431
              DISPLAY BY NAME g_alk.alk431
              NEXT FIELD alk431
           WHEN INFIELD(alk441)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk441
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk441
              DISPLAY BY NAME g_alk.alk441
              NEXT FIELD alk441
           WHEN INFIELD(alk451)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.default1 = g_alk.alk451
              LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
              CALL cl_create_qry() RETURNING g_alk.alk451
              DISPLAY BY NAME g_alk.alk451
              NEXT FIELD alk451
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
   CLOSE WINDOW t810_4_w
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_alk.*=o_alk.* RETURN END IF
 
   IF p_sw = '1' THEN RETURN END IF
   UPDATE alk_file SET alk44 = g_alk.alk44,
                       alk45 = g_alk.alk45,
                       alk40 = g_alk.alk40,
                       alk41 = g_alk.alk41,
                       alk42 = g_alk.alk42,
                       alk43 = g_alk.alk43
    WHERE alk01 = g_alk.alk01
   IF g_aza.aza63 = 'Y' THEN
      UPDATE alk_file SET alk441 = g_alk.alk441,
                          alk451 = g_alk.alk451,
                          alk401 = g_alk.alk401,
                          alk411 = g_alk.alk411,
                          alk421 = g_alk.alk421,
                          alk431 = g_alk.alk431
       WHERE alk01 = g_alk.alk01
   END IF
 
END FUNCTION
 
FUNCTION t810_g_gl(p_apno)
   DEFINE p_apno      LIKE alk_file.alk01
   DEFINE l_alk72       LIKE alk_file.alk72
   DEFINE l_buf            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n              LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET g_success = 'Y'  #No.FUN-680029
 
   IF p_apno IS NULL THEN RETURN END IF
   IF g_alk.alkfirm='Y' THEN RETURN END IF #MOD-550098
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
   SELECT alk72 INTO l_alk72 FROM alk_file WHERE alk01=p_apno
   IF NOT cl_null(l_alk72) THEN RETURN END IF
 
   DROP TABLE t810_g_gl_p1  #CHI-B80025
   BEGIN WORK      #No.FUN-680029
 
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_apno
      AND nppsys= 'LC'
      AND npp00 = 4
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN ROLLBACK WORK RETURN END IF  #Genero      #No.FUN-680029
      #FUN-B40056--add--str--
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_apno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            ROLLBACK WORK
            RETURN
         ELSE
            DELETE FROM tic_file WHERE tic04 = p_apno
         END IF
      END IF
      #FUN-B40056--add--end--
      DELETE FROM npp_file
       WHERE npp01 = p_apno
         AND nppsys= 'LC'
         AND npp00 = 4
         AND npp011= 1
  
      DELETE FROM npq_file
       WHERE npq01 = p_apno
         AND npqsys= 'LC'
         AND npq00 = 4
         AND npq011= 1
   END IF
  
   CALL t810_g_gl_1(p_apno,'0')
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL t810_g_gl_1(p_apno,'1')
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
 
END FUNCTION
 
FUNCTION t810_g_gl_1(p_apno,p_npptype)
   DEFINE p_apno          LIKE alk_file.alk01
   DEFINE p_npptype       LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept          LIKE alk_file.alk04
   DEFINE l_alk           RECORD LIKE alk_file.*
   DEFINE l_pmn40         LIKE pmn_file.pmn40    #FUN-660117 #CHAR(20)
   DEFINE l_ale06         LIKE ale_file.ale06    #FUN-4B0079
   DEFINE l_ale07         LIKE ale_file.ale07    #FUN-4B0079
   DEFINE l_ale09         LIKE ale_file.ale09    #FUN-4B0079
   DEFINE l_ale11         LIKE ale_file.ale11
   DEFINE l_ale13         LIKE ale_file.ale13    #FUN-660117 #CHAR(20)
   DEFINE l_ale131        LIKE ale_file.ale131   #FUN-680029
   DEFINE l_pma11         LIKE pma_file.pma11
   DEFINE l_ale14         LIKE ale_file.ale14
   DEFINE l_ale15         LIKE ale_file.ale15
   DEFINE l_ale16         LIKE ale_file.ale16    #MOD-940196 add
   DEFINE l_ale17         LIKE ale_file.ale17    #MOD-940196 add
   DEFINE l_ala21         LIKE ala_file.ala21    #FUN-4B0079
   DEFINE l_ala56         LIKE ala_file.ala56
   DEFINE l_msg           LIKE ze_file.ze03      #No.FUN-690028 VARCHAR(30)
   DEFINE l_str           LIKE type_file.chr2    #No.FUN-690028 VARCHAR(2)
   DEFINE l_pmc03         LIKE pmc_file.pmc03
   DEFINE l_pmc903        LIKE pmc_file.pmc903   #No.MOD-530727
   DEFINE l_aag05         LIKE aag_file.aag05
   DEFINE l_aag371        LIKE aag_file.aag371   #MOD-B50184
   DEFINE l_npp           RECORD LIKE npp_file.*
   DEFINE l_npq           RECORD LIKE npq_file.*
   DEFINE l_aps           RECORD LIKE aps_file.*
   DEFINE l_als           RECORD LIKE als_file.*
   DEFINE l_taxf          LIKE npq_file.npq07f   #CHI-880038 add
   DEFINE l_tax           LIKE npq_file.npq07    #CHI-880038 add
   DEFINE l_bookno        LIKE aza_file.aza81    #FUN-8C0106 add
   DEFINE l_ware          LIKE rvv_file.rvv32    #MOD-940196 add
   DEFINE l_loc           LIKE rvv_file.rvv33    #MOD-940196 add
   DEFINE l_actno         LIKE alk_file.alk44    #MOD-940196 add
   DEFINE l_sql           LIKE type_file.chr1000 #CHI-B80025 add
   DEFINE l_aag44         LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag          LIKE type_file.chr1    #No.FUN-D40118   Add

   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_alk.* FROM alk_file WHERE alk01 = p_apno
   SELECT * INTO l_als.* FROM als_file WHERE als01 = p_apno
   SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01 = l_alk.alk10
 
   CASE
      WHEN l_pma11 = '3' LET l_str = 'LC'
      WHEN l_pma11 = '4' LET l_str = 'OA'
      WHEN l_pma11 = '2' LET l_str = 'TT'
      OTHERWISE LET l_str = ''
   END CASE
 
   IF g_apz.apz13 = 'Y' THEN
      LET l_dept = g_alk.alk04
   ELSE
      LET l_dept = ' '
   END IF
 
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN
      INITIALIZE l_aps.* TO NULL
   END IF
 
   LET l_ala56 = 0
 
   SELECT ala56 INTO l_ala56 FROM ala_file WHERE ala01=l_alk.alk03
   IF cl_null(l_ala56) THEN
      LET l_ala56 = 0
   END IF
 
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
 
   #-->單頭
   LET l_npp.nppsys = 'LC'
   LET l_npp.npp00  = 4
   LET l_npp.npp01  = l_alk.alk01
   LET l_npp.npp011 = 1
   LET l_npp.npp02  = l_alk.alk02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   LET l_npp.npptype = p_npptype      #No.FUN-680029
 
   LET l_npp.npplegal= g_legal        #FUN-980001
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
 
   #-->單身
   LET l_npq.npqsys = 'LC'
   LET l_npq.npq00  = 4
   LET l_npq.npq01 = l_alk.alk01
   LET l_npq.npq011= 1
   LET l_npq.npq02 = 0
   LET l_npq.npq05 = l_alk.alk04
   LET l_npq.npq24 = l_alk.alk11
   LET l_npq.npq25 = l_alk.alk12
   LET l_npq.npqtype = p_npptype      #No.FUN-680029

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End

   SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903   #No.MOD-530727
     FROM pmc_file
    WHERE pmc01 = l_alk.alk05
   IF SQLCA.sqlcode THEN
      LET l_pmc03 = ' '
      LET g_success = 'N'      #No.FUN-680029
   END IF
 
   #借:存貨/機器/設備 -----------------------------------------------------------
   LET l_npq.npq06 = '1'
 
  #IF (p_npptype='0' AND l_alk.alk44 ='STOCK') OR    #MOD-940196                     #MOD-C70029 mark
  #   (p_npptype='1' AND l_alk.alk441='STOCK') THEN  #MOD-940196                     #MOD-C70029 mark
   IF (p_npptype='0' AND (l_alk.alk44 ='STOCK' OR cl_null(l_alk.alk44))) OR          #MOD-C70029 add
      (p_npptype='1' AND (l_alk.alk441='STOCK' OR cl_null(l_alk.alk441))) THEN       #MOD-C70029 add
     #--------------------------------CHI-B80025------------------------------start
      IF p_npptype = '0' THEN
         LET g_sql="SELECT ale11,ale13,SUM(ale07) ale07,SUM(ale09) ale09,",
                   "       ale14,ale15,ale16,ale17 ",
                   "  FROM ale_file ",
                   " WHERE ale01 = '",l_alk.alk01,"' ",
                   " GROUP BY ale11,ale13,ale14,ale15,ale16,ale17 "
      ELSE
         LET g_sql="SELECT ale11,ale131 ale13,SUM(ale07) ale07,SUM(ale09) ale09,",
                   "       ale14,ale15,ale16,ale17 ",
                   "  FROM ale_file ",
                   " WHERE ale01 = '",l_alk.alk01,"' ",
                   " GROUP BY ale11,ale131,ale14,ale15,ale16,ale17 "
      END IF
     #DECLARE t810_g_gl_c1 CURSOR FOR
     #   SELECT ale11,ale13,ale131,ale06,ale07,  #No.FUN-680029
     #          ale09,ale14,ale15,ale16,ale17   #MOD-940196 add ale16,ale17
     #     FROM ale_file
     #    WHERE ale01 = l_alk.alk01
      LET g_sql = g_sql CLIPPED," INTO TEMP t810_g_gl_p1"
      PREPARE t810_g_gl_c1 FROM g_sql
      EXECUTE t810_g_gl_c1

      LET l_sql = "SELECT * FROM t810_g_gl_p1"                #MOD-AB0195 mod
      PREPARE t810_g_gl_p3 FROM l_sql
      DECLARE t810_g_gl_c3 CURSOR FOR t810_g_gl_p3
 
      IF l_alk.alk44 = 'STOCK' OR l_alk.alk441 = 'STOCK' THEN                 #MOD-C70029 add
        #FOREACH t810_g_gl_c1 INTO l_ale11,l_ale13,l_ale131,l_ale06,l_ale07,  #No.FUN-680029
        #                          l_ale09,l_ale14,l_ale15,l_ale16,l_ale17    #MOD-940196 add l_ale16,l_ale17
         FOREACH t810_g_gl_c3 INTO l_ale11,l_ale13,l_ale07,l_ale09,l_ale14,
                                   l_ale15,l_ale16,l_ale17
        #--------------------------------CHI-B80025------------------------------end
            IF STATUS THEN
               EXIT FOREACH
               LET g_success = 'N'      #No.FUN-680029
            END IF
       
           #FUN-A60056--mod--str--
           #SELECT rvv32,rvv33 INTO l_ware,l_loc
           #  FROM rvv_file
           # WHERE rvv01=l_ale16 AND rvv02=l_ale17
            LET g_sql = "SELECT rvv32,rvv33 FROM ",cl_get_target_table(l_alk.alk97,'rvv_file'),
                        " WHERE rvv01='",l_ale16,"' AND rvv02='",l_ale17,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_alk.alk97) RETURNING g_sql
            PREPARE sel_rvv32 FROM g_sql
            EXECUTE sel_rvv32 INTO l_ware,l_loc
           #FUN-A60056--mod--end
            IF STATUS THEN
               LET l_ware = ''
               LET l_loc  = ''
            END IF
            LET l_actno = t810_stock_act(l_ale11,l_ware,l_loc,p_npptype)
        #--------------------------------CHI-B80025------------------------------start
            UPDATE t810_g_gl_p1 SET ale13=l_actno WHERE ale17=l_ale17
         END FOREACH
      END IF                                                                #MOD-C70029 add
      LET g_sql="SELECT ale11,ale13,SUM(ale07),SUM(ale09),",
                "       ale14,ale15 ",
                "  FROM t810_g_gl_p1 ",
                " GROUP BY ale11,ale13,ale14,ale15,ale16,ale17 "
      PREPARE t810_g_gl_p4 FROM g_sql
      DECLARE t810_g_gl_c4 CURSOR FOR t810_g_gl_p4
     #FOREACH t810_g_gl_c4 INTO l_ale11,l_ale13,l_ale07,l_ale09,l_ale14,  #MOD-C70029 mark
     #                          l_ale15                                   #MOD-C70029 mark
      FOREACH t810_g_gl_c4 INTO l_ale11,l_actno,l_ale07,l_ale09,l_ale14,  #MOD-C70029 add
                                l_ale15                                   #MOD-C70029 add
         IF STATUS THEN EXIT FOREACH END IF
     #--------------------------------CHI-B80025--------------------------------end
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_bookno=''               #FUN-8C0106 add
         LET l_npq.npq03 = l_actno     #MOD-940196 add
         IF p_npptype = '0' THEN
            LET l_bookno=g_bookno1     #FUN-8C0106 add
         ELSE
            LET l_bookno=g_bookno2     #FUN-8C0106 add
         END IF
 
         IF l_ale11[1,4] = 'MISC' THEN
           #FUN-A60056--mod--str--
           #SELECT pmn041 INTO l_npq.npq04 FROM pmn_file
           # WHERE pmn01 = l_ale14
           #   AND pmn02 = l_ale15
            LET g_sql = "SELECT pmn041 FROM ",cl_get_target_table(l_alk.alk97,'pmn_file'),
                        " WHERE pmn01 = '",l_ale14,"'",
                        "   AND pmn02 = '",l_ale15,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_alk.alk97) RETURNING g_sql
            PREPARE sel_pmn041 FROM g_sql
            EXECUTE sel_pmn041 INTO l_npq.npq04
           #FUN-A60056--mod--end
         END IF
 
         LET l_npq.npq04 = NULL          #FUN-D10065  add
         #LET l_npq.npq04 = l_str CLIPPED,' 外購材料請款'   #FUN-D10065  mark
        #-------------MOD-C60214--------------(S)
        #LET l_npq.npq07f= l_ale07                        #MOD-C60214 mark
         IF l_npq.npq25 = 1 THEN
            LET l_npq.npq07f = l_ale09
         ELSE
            LET l_npq.npq07f = l_ale07
         END IF
        #-------------MOD-C60214--------------(E)
         LET l_npq.npq07 = l_ale09
 
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01=l_npq.npq03
            AND aag00=l_bookno      #FUN-8C0106 mod      
         IF l_aag05='N' THEN
            LET l_npq.npq05 = ' '
         ELSE
            LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
         END IF
 
         IF l_npq.npq05 IS NULL THEN LET l_npq.npq05 = ' ' END IF
         LET l_npq.npq21=''
         LET l_npq.npq22=''
         LET l_npq.npq21=l_alk.alk05
         SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
          WHERE pmc01 = l_npq.npq21
 
         IF l_npq.npq07 > 0 THEN
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)     #FUN-8C0106 mod   #No.FUN-730064
            RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_str CLIPPED,' 外購材料請款'
            END IF
            #FUN-D10065--add--end--
            CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
            LET l_npq.npqlegal = g_legal #FUN-980001
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (l_npq.*)
            IF STATUS THEN
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_1:",1)  #No.FUN-660122
               LET g_success = 'N'      #No.FUN-680029
            END IF
         END IF
 
      END FOREACH
   ELSE
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq04 = l_str CLIPPED,' 外購材料請款'
      LET l_bookno=''                      #FUN-8C0106 add
      LET l_npq.npq04 = NULL #FUN-D10065 add
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_alk.alk44
         LET l_bookno=g_bookno1            #FUN-8C0106 add
      ELSE
         LET l_npq.npq03 = l_alk.alk441
         LET l_bookno=g_bookno2            #FUN-8C0106 add
      END IF
     #---------------------MOD-CA0050---------------------(S)
     #LET l_npq.npq07f= l_alk.alk13                     #MOD-CA0050 mark
      IF l_npq.npq25 = 1 THEN
          LET l_npq.npq07f = l_alk.alk25+l_alk.alk26
      ELSE
          LET l_npq.npq07f = l_alk.alk13
      END IF
     #---------------------MOD-CA0050---------------------(E)
     #LET l_npq.npq07 = l_alk.alk25+l_alk.alk26+l_alk.alk27   #MOD-A40072 mark
      LET l_npq.npq07 = l_alk.alk25+l_alk.alk26               #MOD-A40072
 
      IF l_pma11 = '4' THEN
         LET l_npq.npq07 = l_npq.npq07 + l_ala56
      END IF
 
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=l_bookno     #FUN-8C0106 mod    #No.FUN-730064
      IF l_aag05='N' THEN
         LET l_npq.npq05 = ' '
      ELSE
         LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
      END IF
 
      IF l_npq.npq05 IS NULL THEN
         LET l_npq.npq05 = ' '
      END IF
 
      LET l_npq.npq21=''
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alk.alk05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
 
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)   #FUN-8C0106 mod   #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_str CLIPPED,' 外購材料請款'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      LET l_npq.npqlegal = g_legal #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_2:",1)  #No.FUN-660122
         LET g_success = 'N'      #No.FUN-680029
      END IF
   END IF
 
   #借:稅額分錄 (當多發票裡有稅額時,才需切出稅額分錄)
   LET l_taxf = 0   LET l_tax = 0
   IF g_alk.alk46 = 'MISC' THEN
      DROP TABLE x
      SELECT apk11,gec03,apk07f,apk07 FROM apk_file,OUTER gec_file
       WHERE apk01 = g_alk.alk01
         AND apk11 = gec01
        INTO TEMP x
      DECLARE t810_g_gl_c2 CURSOR FOR
         SELECT gec03,SUM(apk07f),SUM(apk07) FROM x
          GROUP BY gec03
          ORDER BY gec03 
      FOREACH t810_g_gl_c2 INTO l_npq.npq03,l_npq.npq07f,l_npq.npq07
         IF STATUS THEN
            EXIT FOREACH
            LET g_success = 'N'
         END IF
 
         IF cl_null(l_npq.npq03)  THEN LET l_npq.npq03 = ' ' END IF
         IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f= 0 END IF
         IF cl_null(l_npq.npq07)  THEN LET l_npq.npq07 = 0 END IF
 
         IF l_npq.npq07f=0 AND l_npq.npq07=0 THEN
            CONTINUE FOREACH
         END IF
 
         LET l_taxf = l_taxf + l_npq.npq07f
         LET l_tax  = l_tax  + l_npq.npq07 
 
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq04 = NULL          #FUN-D10065  add
         #LET l_npq.npq04 = ' '   #FUN-D10065  mark
 
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01=l_npq.npq03
            AND aag00=l_bookno     #FUN-8C0106 mod     #No.FUN-730064 
          
         IF l_aag05='N' THEN
            LET l_npq.npq05 = ' '
         ELSE
            LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930)
         END IF
 
         IF l_npq.npq05 IS NULL THEN
            LET l_npq.npq05 = ' '
         END IF
 
         LET l_npq.npq06 = '1'
 
         LET l_npq.npq21 = ''
         LET l_npq.npq22 = ''
         LET l_npq.npq21 = l_alk.alk05
         SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
          WHERE pmc01 = l_npq.npq21
 
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)   #FUN-8C0106 mod   #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = ' '
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087 
         LET l_npq.npqlegal = g_legal #FUN-980001
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_2:",1)
            LET g_success = 'N'
         END IF
      END FOREACH
   END IF
 
   #借:立帳差異 --------------------------------------------------------------
  #-MOD-A40072-add-
   IF l_alk.alk27 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_bookno=''       
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_alk.alk45
         LET l_bookno=g_bookno1      
      ELSE
         LET l_npq.npq03 = l_alk.alk451
         LET l_bookno=g_bookno2
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f= 0
      LET l_npq.npq07 = l_alk.alk27
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_npq.npq07 * -1
      END IF
      LET l_npq.npq21 = ''
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00=l_bookno     
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) 
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alk.alk05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
      LET l_npq.npq24 = g_aza.aza17
      LET l_npq.npq25 = 1
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)   
      RETURNING l_npq.*
      LET l_npq.npqlegal = g_legal #TQC-C50109 add
      CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq_3:",1)  
         LET g_success = 'N'     
      END IF
   END IF
  #-MOD-A40072-end-
   #貸:預付 (併入 AP-LC)------------------------------------------------------
   LET l_ala21 = 0
   SELECT ala21 INTO l_ala21 FROM ala_file WHERE ala01=l_alk.alk03
 
   IF l_ala21 IS NULL THEN
      LET l_ala21 = 0
   END IF
 
   IF l_alk.alk26 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_bookno=''                      #FUN-8C0106 add
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_alk.alk40
         LET l_bookno=g_bookno1            #FUN-8C0106 add
      ELSE
         LET l_npq.npq03 = l_alk.alk401
         LET l_bookno=g_bookno2            #FUN-8C0106 add
      END IF
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = '預購應攤 ',l_alk.alk11 CLIPPED,
      #                  l_alk.alk13 USING '<<<<<<<<<<.<<',' ',
      #                  l_alk.alk01
      #FUN-D10065--mark--end--
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= l_alk.alk13*l_ala21/100
     #LET l_npq.npq07 = l_alk.alk26+l_alk.alk27   #MOD-A40072 mark
      LET l_npq.npq07 = l_alk.alk26               #MOD-A40072
 
      IF l_alk.alk12 = 1 THEN                     #MOD-C60214 add
         LET l_npq.npq07f = l_npq.npq07           #MOD-C60214 add
      END IF                                      #MOD-C60214 add

      LET l_aag05 = ' '         #MOD-B50184
      LET l_aag371= ' '         #MOD-B50184
      SELECT aag05,aag371 INTO l_aag05,l_aag371  #MOD-B50184
        FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=l_bookno     #FUN-8C0106 mod  #No.FUN-730064 
      IF l_aag05='N' THEN
         LET l_npq.npq05 = ' '
      ELSE
         LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
      END IF
 
      IF l_npq.npq05 IS NULL THEN
         LET l_npq.npq05 = ' '
      END IF
 
      LET l_npq.npq21=''
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alk.alk05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
 
      IF l_npq.npq07 != 0 THEN
         LET l_npq.npq24 = l_alk.alk11   #MOD-A40072 
         LET l_npq.npq25 = l_alk.alk12   #MOD-A40072
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)     #FUN-8C0106 mod  #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = '預購應攤 ',l_alk.alk11 CLIPPED,
                               l_alk.alk13 USING '<<<<<<<<<<.<<',' ',
                               l_alk.alk01
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
         IF l_aag371 MATCHES '[234]' THEN          #MOD-B50184
            IF cl_null(l_npq.npq37) THEN
               IF l_pmc903 = "Y" THEN  
                  LET l_npq.npq37 = l_alk.alk05    #No.CHI-830037
               END IF
            END IF
         END IF                                    #MOD-B50184
         LET l_npq.npqlegal = g_legal #FUN-980001
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_3:",1)  #No.FUN-660122
            LET g_success = 'N'      #No.FUN-680029
         END IF
      END IF
   END IF
 
   #貸:在途存貨/AP-LC --------------------------------------------------------
   LET l_npq.npq02 = l_npq.npq02 + 1
   LET l_bookno=''                     #FUN-8C0106 add
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_alk.alk41
      LET l_bookno=g_bookno1           #FUN-8C0106 add
   ELSE
      LET l_npq.npq03 = l_alk.alk411
      LET l_bookno=g_bookno2           #FUN-8C0106 add
   END IF
   LET l_npq.npq04 = NULL #FUN-D10065 add
   #FUN-D10065--mark--str--
   #LET l_npq.npq04 = l_str CLIPPED,' ',l_alk.alk11 CLIPPED,
   #                  l_alk.alk13 USING '<<<<<<<<<<.<<','*',
   #                  l_alk.alk12 USING '<<<<.<<<','*',(100-l_ala21) USING '<<<','*',
   #                  l_pmc03 CLIPPED
   #FUN-D10065--mark--end--
   LET l_npq.npq06 = '2'
  #-MOD-A40072-add-
   IF l_alk.alk07 IS NULL THEN 
      LET l_npq.npq25 = l_alk.alk12 
      LET l_npq.npq07f= l_alk.alk13*(100-l_ala21)/100
      LET l_npq.npq07 = l_alk.alk16
   
     #str CHI-880038 add
     #加上稅額
      IF l_taxf ! = 0 THEN
         LET l_npq.npq07f = l_npq.npq07f + l_taxf
      END IF
      IF l_tax ! = 0 THEN
         LET l_npq.npq07 = l_npq.npq07 + l_tax
      END IF
     #end CHI-880038 add
   ELSE
      LET l_npq.npq25 = l_alk.alk37 
      LET l_npq.npq07f= l_alk.alk38*(100-l_ala21)/100
     #LET l_npq.npq07 = l_alk.alk39                        #MOD-C70117 mark
      LET l_npq.npq07 = l_npq.npq07f * l_alk.alk37         #MOD-C70117 add
      LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)     #MOD-C70117 add
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)   #MOD-C70117 add
   END IF
  #-MOD-A40072-end-
 
   LET l_npq.npq21=''
   LET l_npq.npq22=''
   SELECT ala05 INTO l_npq.npq21 FROM ala_file   #No.MOD-530827
    WHERE ala01 = l_alk.alk03
 
   IF STATUS THEN
      LET l_npq.npq21 = l_alk.alk05
      LET g_success = 'N'      #No.FUN-680029
   END IF
   SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
    WHERE pmc01 = l_npq.npq21
 
   LET l_aag05 = ' '         #MOD-B50184
   LET l_aag371= ' '         #MOD-B50184
   SELECT aag05,aag371 INTO l_aag05,l_aag371     #MOD-B50184
     FROM aag_file
    WHERE aag01 = l_npq.npq03
      AND aag00 = l_bookno     #FUN-8C0106 mod   #No.FUN-730064  
   IF l_aag05 = 'N' THEN
      LET l_npq.npq05 = ' '
   ELSE
      LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
   END IF
 
   IF l_npq.npq05 IS NULL THEN
      LET l_npq.npq05 = ' '
   END IF
 
 
   IF l_npq.npq07 != 0 THEN

      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)     #FUN-8C0106 mod  #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_str CLIPPED,' ',l_alk.alk11 CLIPPED,
                           l_alk.alk13 USING '<<<<<<<<<<.<<','*',
                           l_alk.alk12 USING '<<<<.<<<','*',(100-l_ala21) USING '<<<','*',
                           l_pmc03 CLIPPED
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
      IF l_aag371 MATCHES '[234]' THEN          #MOD-B50184
         IF cl_null(l_npq.npq37) THEN
            IF l_pmc903 = "Y" THEN   
               LET l_npq.npq37 = l_alk.alk05    #No.CHI-830037
            END IF
         END IF
      END IF                                    #MOD-B50184
      LET l_npq.npqlegal = g_legal #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_4:",1)  #No.FUN-660122
         LET g_success = 'N'      #No.FUN-680029
      END IF
   END IF
 
   #貸:預估應付費用 ----------------------------------------------------------
   IF l_alk.alk23 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_bookno=''                   #FUN-8C0106 add
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_alk.alk43
         LET l_bookno = g_bookno1       #FUN-8C0106 add
      ELSE
         LET l_npq.npq03 = l_alk.alk431
         LET l_bookno = g_bookno2       #FUN-8C0106 add
      END IF
 
      CALL cl_getmsg('aap-752',g_lang) RETURNING l_msg
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #LET l_npq.npq04 = '預估 ',l_alk.alk01,' 其他費用*',l_als.als09 CLIPPED   #FUN-D10065  mark
 
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= 0
      LET l_npq.npq07 = l_alk.alk23
      LET l_npq.npq21 = ''   
 
      LET l_aag05 = ' '         #MOD-B50184
      LET l_aag371= ' '         #MOD-B50184
      SELECT aag05,aag371 INTO l_aag05,l_aag371     #MOD-B50184
        FROM aag_file 
       WHERE aag01=l_npq.npq03
        #AND aag00=g_bookno1    #FUN-8C0106 mark #No.FUN-730064
         AND aag00=l_bookno     #FUN-8C0106 mod  #No.FUN-730064
      IF l_aag05='N' THEN
         LET l_npq.npq05 = ' '
      ELSE
         LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
      END IF
 
      IF l_npq.npq05 IS NULL THEN
         LET l_npq.npq05 = ' '
      END IF
 
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alk.alk05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
 
      LET l_npq.npq24 = g_aza.aza17
      LET l_npq.npq25 = 1
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)   #FUN-8C0106 mod  #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = '預估 ',l_alk.alk01,' 其他費用*',l_als.als09 CLIPPED
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
      IF l_aag371 MATCHES '[234]' THEN          #MOD-B50184
         IF cl_null(l_npq.npq37) THEN
            IF l_pmc903 = "Y" THEN   
               LET l_npq.npq37 = l_alk.alk05     #No.CHI-830037
            END IF
         END IF
      END IF                                    #MOD-B50184
      LET l_npq.npqlegal = g_legal #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_6:",1)  #No.FUN-660122
         LET g_success = 'N'      #No.FUN-680029
      END IF
   END IF
 
   IF l_pma11 = '4' THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_bookno=''                       #FUN-8C0106 add
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_aps.aps231
         LET l_bookno=g_bookno1             #FUN-8C0106 add
      ELSE
         LET l_npq.npq03 = l_aps.aps236
         LET l_bookno=g_bookno2             #FUN-8C0106 add
      END IF
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #LET l_npq.npq04 = '預購應攤 ',l_alk.alk01   #FUN-D10065  mark

      LET l_aag05 = ' '         #MOD-B50184
      LET l_aag371= ' '         #MOD-B50184
      SELECT aag05,aag371 INTO l_aag05,l_aag371     #MOD-B50184
        FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = l_bookno     #FUN-8C0106 mod  #No.FUN-730064   
      IF l_aag05 = 'N' THEN
         LET l_npq.npq05 = ' '
      ELSE
         LET l_npq.npq05 = t810_set_npq05(l_alk.alk04,l_alk.alk930) #FUN-680019
      END IF
 
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= 0
      LET l_npq.npq07 = l_ala56
      LET l_npq.npq21 = ''
 
      IF l_npq.npq05 IS NULL THEN
         LET l_npq.npq05 = ' '
      END IF
 
      LET l_npq.npq22=''
      LET l_npq.npq21=l_alk.alk05
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file
       WHERE pmc01 = l_npq.npq21
 
      IF l_npq.npq07 != 0 THEN
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno)     #FUN-8C0106 mod  #No.FUN-730064
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = '預購應攤 ',l_alk.alk01
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,l_bookno) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
         IF l_aag371 MATCHES '[234]' THEN       #MOD-B50184
            IF cl_null(l_npq.npq37) THEN 
               IF l_pmc903 = "Y" THEN   
                  LET l_npq.npq37 = l_alk.alk05 #No.CHI-830037
               END IF
            END IF
         END IF                                 #MOD-B50184
         LET l_npq.npqlegal = g_legal #FUN-980001
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins noq_6:",1)  #No.FUN-660122
            LET g_success = 'N'      #No.FUN-680029
         END IF
      END IF
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
 
FUNCTION t810_stock_act(p_item,p_ware,p_loc,p_npptype)
   DEFINE p_item    LIKE ima_file.ima01
   DEFINE p_ware    LIKE ime_file.ime01
   DEFINE p_loc     LIKE ime_file.ime02
   DEFINE p_npptype LIKE npp_file.npptype
   DEFINE g_ccz07   LIKE ccz_file.ccz07
   DEFINE l_actno   LIKE aag_file.aag01
  
   SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'
 
   CASE WHEN g_ccz07='1' IF p_npptype = '0' THEN
                            SELECT ima39 INTO l_actno FROM ima_file
                             WHERE ima01=p_item
                         ELSE
                            SELECT ima391 INTO l_actno FROM ima_file
                             WHERE ima01=p_item
                         END IF
        WHEN g_ccz07='2' IF p_npptype = '0' THEN
                            SELECT imz39 INTO l_actno
                              FROM ima_file,imz_file
                             WHERE ima01=p_item AND ima06=imz01
                         ELSE
                            SELECT imz391 INTO l_actno
                              FROM ima_file,imz_file
                             WHERE ima01=p_item AND ima06=imz01
                         END IF
        WHEN g_ccz07='3' IF p_npptype = '0' THEN
                            SELECT imd08 INTO l_actno FROM imd_file
                             WHERE imd01=p_ware
                         ELSE
                            SELECT imd081 INTO l_actno FROM imd_file
                             WHERE imd01=p_ware
                         END IF
        WHEN g_ccz07='4' IF p_npptype = '0' THEN
                            SELECT ime09 INTO l_actno FROM ime_file
                             WHERE ime01=p_ware AND ime02=p_loc
                         ELSE
                            SELECT ime091 INTO l_actno FROM ime_file
                             WHERE ime01=p_ware AND ime02=p_loc
                         END IF
        OTHERWISE        LET l_actno='STOCK'
   END CASE
   RETURN l_actno
END FUNCTION
 
FUNCTION t810_s()
   DEFINE l_tot         LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_wc          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(100)
   DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(500)
   DEFINE l_alk         RECORD LIKE alk_file.*
   DEFINE only_one      LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
   LET g_alk_t.* = g_alk.*
   LET l_alk.* = g_alk.*
 
   IF g_alk.alkfirm = 'Y' THEN
      CALL cl_err('',9023,1)
      RETURN
   END IF
 
   OPEN WINDOW t810_w7 AT 8,18
     WITH FORM "aap/42f/aapt810_7"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt810_7")
 
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
      CLOSE WINDOW t810_w7
      RETURN
   END IF
 
   IF only_one = '1' THEN
      LET l_wc = " alk01 = '",g_alk.alk01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
      CONSTRUCT BY NAME l_wc ON alk01,alk02,alk03,alk05,alk07
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(alk03) # L/C
                  CALL q_ala(TRUE,TRUE,g_alk.alk03) RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO alk03
               WHEN INFIELD(alk05) #PAY TO VENDOR
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO alk05
                  CALL t810_alk05('d')
               WHEN INFIELD(alk07) # L/C No
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_alh1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO alk07
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
         CLOSE WINDOW t810_w7
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('mfg-062') THEN    #TQC-5C0028
      CLOSE WINDOW t810_w7
      RETURN
   END IF
 
   MESSAGE "WORKING !"
 
   LET l_sql = "SELECT alk_file.* FROM alk_file WHERE ",l_wc CLIPPED,
               "   AND alkfirm <> 'Y' "
 
   PREPARE t810_firm7 FROM l_sql
   DECLARE t810_firm77 CURSOR WITH HOLD FOR t810_firm7
 
   FOREACH t810_firm77 INTO g_alk.* 
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      LET l_tot = 0
 
      SELECT SUM(ale09) INTO l_tot FROM ale_file
       WHERE ale01 = g_alk.alk01
         AND ale16 = 'MISC'
 
      IF l_tot IS NULL THEN
         LET l_tot = 0
      END IF
 
     #LET l_tot = g_alk.alk25 + g_alk.alk26 + g_alk.alk27 - l_tot   #MOD-A40072 mark
      LET l_tot = g_alk.alk25 + g_alk.alk26 - l_tot                 #MOD-A40072
 
      CALL t810_share(g_alk.alk01,l_tot)
 
      CALL t810_b_tot('d')
 
      CALL t810_g_gl(g_alk.alk01)
   END FOREACH
 
   CLOSE WINDOW t810_w7
 
   LET g_alk.* = l_alk.*
 
   CALL t810_b_fill('1=1')
 
 
END FUNCTION
 
FUNCTION t810_share(p_alk01,p_amt)
   DEFINE p_alk01     LIKE alk_file.alk01
   DEFINE p_amt       LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_ale       RECORD LIKE ale_file.*
   DEFINE l_acu_amt   LIKE type_file.num20_6 #FUN-4B0079  #No.FUN-690028 DECIMAL(20,6)
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t810_cl USING g_alk.alk01
   IF STATUS THEN
      CALL cl_err("OPEN t810_cl:", STATUS, 1)
      CLOSE t810_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t810_cl INTO g_alk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET l_acu_amt = 0
 
   DECLARE t810_cs2 CURSOR WITH HOLD FOR SELECT * FROM ale_file
                                          WHERE ale01 = p_alk01
                                            AND ale14 != 'MISC'
 
   FOREACH t810_cs2 INTO l_ale.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      MESSAGE l_ale.ale02,' ',l_ale.ale03
 
      LET l_ale.ale09 = p_amt * l_ale.ale07 / g_alk.alk13
      LET l_ale.ale09 = cl_digcut(l_ale.ale09,g_azi04)   #MOD-790060
      LET l_ale.ale08 = l_ale.ale09 / l_ale.ale06
      LET l_ale.ale08 = cl_digcut(l_ale.ale08,g_azi03)   #MOD-790060
      LET l_acu_amt = l_acu_amt + l_ale.ale09            # Accumulated shared amt
 
      UPDATE ale_file SET ale08 = l_ale.ale08,
                          ale09 = l_ale.ale09
       WHERE ale01 = l_ale.ale01
         AND ale02 = l_ale.ale02
      IF STATUS THEN
         CALL cl_err3("upd","ale_file",l_ale.ale01,l_ale.ale02,SQLCA.sqlcode,"","upd ale.1",1)  #No.FUN-660122
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_ale.ale09 = cl_digcut(l_ale.ale09,g_azi04)   #MOD-790060
   LET l_ale.ale09 = l_ale.ale09 + (p_amt - l_acu_amt)      #總差異分攤至最後一筆
   LET l_ale.ale09 = cl_digcut(l_ale.ale09,g_azi04)   #MOD-790060
   LET l_ale.ale08 = l_ale.ale09 / l_ale.ale06
   LET l_ale.ale08 = cl_digcut(l_ale.ale08,g_azi03)   #MOD-790060
 
   UPDATE ale_file SET ale08 = l_ale.ale08,
                       ale09 = l_ale.ale09
    WHERE ale01 = l_ale.ale01
      AND ale02 = l_ale.ale02
   IF STATUS THEN
      CALL cl_err3("upd","ale_file",l_ale.ale01,l_ale.ale02,SQLCA.sqlcode,"","upd ale.2",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
 
   UPDATE alk_file SET alk70 = 'Y'
    WHERE alk01 = p_alk01
   IF STATUS THEN
      CALL cl_err3("upd","alk_file",p_alk01,"",SQLCA.sqlcode,"","upd alk70",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION t810_d()
#   DEFINE l_plant    LIKE azp_file.azp01,  #FUN-660117
#          l_dbs      LIKE azp_file.azp03   #FUN-660117
 
#   LET INT_FLAG = 0  ######add for prompt bug
 
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
 
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
 
#       ON ACTION controlg      #MOD-4C0121

#          CALL cl_cmdask()     #MOD-4C0121
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030   #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL t810_declare()    # Thomas 98/12/16
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION t810_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),                #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_tot           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079             #判斷是否跳過AFTER ROW的處理
    l_rvv09         like rvv_file.rvv09,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-690028 SMALLINT
    l_aag05 LIKE aag_file.aag05   #TQC-620028
DEFINE g_chr        LIKE type_file.chr1         #CHI-B80025
DEFINE l_pmn07      LIKE pmn_file.pmn07         #TQC-C20183 
 
    LET g_action_choice = ""
    IF s_aapshut(0) THEN RETURN END IF
    IF g_alk.alk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alk.* FROM alk_file
     WHERE alk01=g_alk.alk01
    SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
     WHERE azi01 = g_alk.alk11
    IF SQLCA.SQLCODE != 0 THEN
       LET t_azi03 = 0
       LET t_azi04 = 0
    END IF
    IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
    IF g_alk.alkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_alk.alk97!=g_plant THEN CALL cl_err('','aap-707',0)RETURN END IF        #No.FUN-980017
 
    SELECT COUNT(*) INTO l_n FROM ale_file WHERE ale01 = g_alk.alk01
    IF l_n = 0 THEN
       CALL t810_g_b()            # 依 入庫單 (rvv_file) 產生
       CALL t810_b_fill('1=1')
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ale02,ale16,ale17,ale14,ale15,ale11,'',",
                       "       ale83,ale84,ale85,ale80,ale81,ale82,ale86,ale87,",  #FUN-710029
                       "       ale06,",
                       "       ale13,ale131,ale05,ale07,ale08,ale09,ale930,'',",   #FUN-680019  #No.FUN-680029
                       "       aleud01,aleud02,aleud03,aleud04,aleud05,",
                       "       aleud06,aleud07,aleud08,aleud09,aleud10,",
                       "       aleud11,aleud12,aleud13,aleud14,aleud15 ",
                       " FROM ale_file",
                       " WHERE ale01=? AND ale02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t810_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ale WITHOUT DEFAULTS FROM s_ale.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           #No.FUN-BB0086--add--begin--
           LET g_ale80_t = NULL 
           LET g_ale83_t = NULL 
           LET g_ale86_t = NULL 
           #No.FUN-BB0086--add--end--
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN t810_cl USING g_alk.alk01
           IF STATUS THEN
              CALL cl_err("OPEN t810_cl:", STATUS, 1)
              CLOSE t810_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t810_cl INTO g_alk.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ale_t.* = g_ale[l_ac].*  #BACKUP
              #No.FUN-BB0086--add--begin--
              LET g_ale80_t = g_ale[l_ac].ale80
              LET g_ale83_t = g_ale[l_ac].ale83 
              LET g_ale86_t = g_ale[l_ac].ale86 
              #No.FUN-BB0086--add--end--
              OPEN t810_bcl USING g_alk.alk01,g_ale_t.ale02
              IF STATUS THEN
                 CALL cl_err("OPEN t810_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t810_bcl INTO g_ale[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ale_t.ale02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_ale[l_ac].gem02c=s_costcenter_desc(g_ale[l_ac].ale930) #FUN-680019
              LET g_ale[l_ac].pmn041 = g_ale_t.pmn041
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ale[l_ac].* TO NULL      #900423
           LET g_ale[l_ac].ale05 = 0
           LET g_ale[l_ac].ale06 = 0
           LET g_ale[l_ac].ale07 = 0
           LET g_ale[l_ac].ale08 = 0
           LET g_ale[l_ac].ale09 = 0
           LET g_ale[l_ac].ale81 = 0    #FUN-710029
           LET g_ale[l_ac].ale82 = 0    #FUN-710029
           LET g_ale[l_ac].ale84 = 0    #FUN-710029
           LET g_ale[l_ac].ale85 = 0    #FUN-710029
           LET g_ale[l_ac].ale87 = 0    #FUN-710029
           LET g_ale[l_ac].ale930= g_alk.alk930 #FUN-680019
           LET g_ale[l_ac].gem02c= s_costcenter_desc(g_ale[l_ac].ale930) #FUN-680019
           LET g_ale_t.* = g_ale[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_ale[l_ac].ale11) THEN
                 SELECT ima44,ima31 INTO g_ima44,g_ima31
                   FROM ima_file WHERE ima01=g_ale[l_ac].ale11
 
                 CALL s_chk_va_setting(g_ale[l_ac].ale11)
                      RETURNING g_flag,g_ima906,g_ima907
 
                 CALL s_chk_va_setting1(g_ale[l_ac].ale11)
                      RETURNING g_flag,g_ima908
              END IF
           END IF
           CALL t810_set_required() 
           CALL t810_set_entry_b(p_cmd)
           CALL t810_set_no_entry_b(p_cmd)
           NEXT FIELD ale02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
              EXIT INPUT
           END IF
           IF g_ale[l_ac].ale16 != 'MISC' THEN
             #FUN-A60056--mod--str--
             #SELECT rvv09 INTO l_rvv09 from rvv_file
             # WHERE rvv01 = g_ale[l_ac].ale16
             #   AND rvv02 = g_ale[l_ac].ale17
              LET g_sql = "SELECT rvv09 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
                          " WHERE rvv01 = '",g_ale[l_ac].ale16,"'",
                          "   AND rvv02 = '",g_ale[l_ac].ale17,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
              PREPARE sel_rvv09 FROM g_sql
              EXECUTE sel_rvv09 INTO l_rvv09
             #FUN-A60056--mod--end
 
              IF YEAR(l_rvv09) != YEAR(g_alk.alk02) OR
                 MONTH(l_rvv09) != MONTH(g_alk.alk02) THEN
                  CALL cl_err('','aap-776',1)    #MOD-490422
                 INITIALIZE g_ale[l_ac].* TO NULL
                 CANCEL INSERT
              END IF
           END IF
 
           INSERT INTO ale_file(ale01,ale02,ale16,ale17,ale14,ale15,ale11,
                                ale06,ale05,ale07,ale08,ale09,ale13,ale131,ale930, #FUN-680019  #No.FUN-680029
                                ale80,ale81,ale82,ale83,ale84,ale85,ale86,ale87,   #FUN-710029
                                aleud01,aleud02,aleud03,
                                aleud04,aleud05,aleud06,
                                aleud07,aleud08,aleud09,
                                aleud10,aleud11,aleud12,
                                aleud13,aleud14,aleud15,alelegal) #FUN-980001 add legal   #FUN-980076
            VALUES(g_alk.alk01,g_ale[l_ac].ale02,g_ale[l_ac].ale16,
                   g_ale[l_ac].ale17,g_ale[l_ac].ale14,g_ale[l_ac].ale15,
                   g_ale[l_ac].ale11,g_ale[l_ac].ale06,g_ale[l_ac].ale05,
                   g_ale[l_ac].ale07,g_ale[l_ac].ale08,g_ale[l_ac].ale09,
                   g_ale[l_ac].ale13,g_ale[l_ac].ale131,g_ale[l_ac].ale930, #FUN-680019  #No.FUN-680029
                   g_ale[l_ac].ale80,g_ale[l_ac].ale81,g_ale[l_ac].ale82,   #FUN-710029
                   g_ale[l_ac].ale83,g_ale[l_ac].ale84,g_ale[l_ac].ale85,   #FUN-710029
                   g_ale[l_ac].ale86,g_ale[l_ac].ale87,   #FUN-710029
                   g_ale[l_ac].aleud01,g_ale[l_ac].aleud02,
                   g_ale[l_ac].aleud03,g_ale[l_ac].aleud04,
                   g_ale[l_ac].aleud05,g_ale[l_ac].aleud06,
                   g_ale[l_ac].aleud07,g_ale[l_ac].aleud08,
                   g_ale[l_ac].aleud09,g_ale[l_ac].aleud10,
                   g_ale[l_ac].aleud11,g_ale[l_ac].aleud12,
                   g_ale[l_ac].aleud13,g_ale[l_ac].aleud14,
                   g_ale[l_ac].aleud15,g_legal) #FUN-980001 add legal  FUN-980076 mod
                   
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ale_file",g_alk.alk01,g_ale[l_ac].ale02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t810_b_tot('u')
           END IF
 
        BEFORE FIELD ale02                        #default 序號
           IF g_ale[l_ac].ale02 IS NULL OR g_ale[l_ac].ale02 = 0 THEN
              SELECT max(ale02)+1
                INTO g_ale[l_ac].ale02
                FROM ale_file
               WHERE ale01 = g_alk.alk01
              IF g_ale[l_ac].ale02 IS NULL THEN
                 LET g_ale[l_ac].ale02 = 1
              END IF
           END IF
 
        AFTER FIELD ale02                        #check 序號是否重複
           IF NOT cl_null(g_ale[l_ac].ale02) THEN
              IF g_ale[l_ac].ale02 != g_ale_t.ale02 OR g_ale_t.ale02 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM ale_file
                  WHERE ale01 = g_alk.alk01
                    AND ale02 = g_ale[l_ac].ale02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ale[l_ac].ale02 = g_ale_t.ale02
                    NEXT FIELD ale02
                 END IF
              END IF
           END IF
 
        AFTER FIELD ale16
           IF NOT cl_null(g_ale[l_ac].ale16) THEN
              CALL t810_ale16()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ale[l_ac].ale16,g_errno,0)
                 NEXT FIELD ale16
              END IF
           END IF
 
        AFTER FIELD ale17
           IF NOT cl_null(g_ale[l_ac].ale17) THEN
              CALL t810_ale17('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_ale[l_ac].ale16=g_ale_t.ale16
                 LET g_ale[l_ac].ale17=g_ale_t.ale17
              DISPLAY BY NAME g_ale[l_ac].ale16
              DISPLAY BY NAME g_ale[l_ac].ale17
                 NEXT FIELD ale16
              END IF
              IF g_ale[l_ac].ale16 != 'MISC' THEN
                #FUN-A60056--mod--str--
                #SELECT rvv09 INTO l_rvv09 from rvv_file
                # WHERE rvv01 = g_ale[l_ac].ale16
                #   AND rvv02 = g_ale[l_ac].ale17
                 LET g_sql = "SELECT rvv09 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
                             " WHERE rvv01 = '",g_ale[l_ac].ale16,"'",
                             "   AND rvv02 = '",g_ale[l_ac].ale17,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
                 PREPARE sel_rvv09_pre1 FROM g_sql
                 EXECUTE sel_rvv09_pre1 INTO l_rvv09
                #FUN-A60056--mod--end
                 IF YEAR(l_rvv09) != YEAR(g_alk.alk02) OR
                    MONTH(l_rvv09) != MONTH(g_alk.alk02) THEN
                    CALL cl_err('','aap-776',1)    
                    NEXT FIELD ale16
                 END IF
              END IF
              #TQC-C20183--add--str--
              IF g_sma.sma115 ='N' THEN                      
                 IF NOT t810_ale06_check() THEN NEXT FIELD ale06 END IF #FUN-BB0086 add
              ELSE                                                   
                SELECT pmn07 INTO l_pmn07 FROM pmn_file
                 WHERE pmn01 = g_ale[l_ac].ale14 
                   AND pmn02 = g_ale[l_ac].ale15 
                LET g_ale[l_ac].ale06 = s_digqty(g_ale[l_ac].ale06,l_pmn07)
                DISPLAY BY NAME g_ale[l_ac].ale06
              END IF                                                
              #TQC-C20183--add--end--
           END IF
 
        BEFORE FIELD ale83
           IF NOT cl_null(g_ale[l_ac].ale11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_ale[l_ac].ale11
           END IF
           CALL t810_set_no_required()
 
        AFTER FIELD ale83  #第二單位
           IF cl_null(g_ale[l_ac].ale11) THEN NEXT FIELD ale11 END IF
           IF NOT cl_null(g_ale[l_ac].ale83) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ale[l_ac].ale83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ale[l_ac].ale83,"",STATUS,"","gfe:",1)
                 NEXT FIELD ale83
              END IF
              CALL s_du_umfchk(g_ale[l_ac].ale11,'','','',
                               g_ima44,g_ale[l_ac].ale83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ale[l_ac].ale83,g_errno,1)
                 NEXT FIELD ale83
              END IF
              IF cl_null(g_ale_t.ale83) OR g_ale_t.ale83 <> g_ale[l_ac].ale83 THEN
                 LET g_ale[l_ac].ale84 = g_factor
              END IF
           END IF
           CALL t810_du_data_to_correct()
           CALL t810_set_required()
           CALL cl_show_fld_cont()  
           #No.FUN-BB0086--add--begin--
           IF NOT t810_ale85_check(p_cmd) THEN 
              LET g_ale83_t = g_ale[l_ac].ale83
              NEXT FIELD ale85
           END IF 
           LET g_ale83_t = g_ale[l_ac].ale83
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD ale84  #第二轉換率
           IF NOT cl_null(g_ale[l_ac].ale84) THEN
              IF g_ale[l_ac].ale84=0 THEN
                 NEXT FIELD ale84
              END IF
           END IF
 
        AFTER FIELD ale85  #第二數量
           IF NOT t810_ale85_check(p_cmd) THEN NEXT FIELD ale85 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_ale[l_ac].ale85) THEN
           #   IF g_ale[l_ac].ale85 < 0 THEN
           #      CALL cl_err('','aim-391',1) 
           #      NEXT FIELD ale85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_ale_t.ale85 <> g_ale[l_ac].ale85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_ale[l_ac].ale85*g_ale[l_ac].ale84
           #         IF cl_null(g_ale[l_ac].ale82) OR g_ale[l_ac].ale82=0 THEN #CHI-960022
           #            LET g_ale[l_ac].ale82=g_tot*g_ale[l_ac].ale81
           #            DISPLAY BY NAME g_ale[l_ac].ale82                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           #IF cl_null(g_ale[l_ac].ale86) THEN
           #   LET g_ale[l_ac].ale87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
           #          g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
           #          g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
           #          g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
           #          g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
           #      CALL t810_set_ale87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()  
           #No.FUN-BB0086--mark--end--
 
        AFTER FIELD ale80  #第一單位
           IF cl_null(g_ale[l_ac].ale11) THEN NEXT FIELD ale11 END IF
           IF NOT cl_null(g_ale[l_ac].ale80) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ale[l_ac].ale80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ale[l_ac].ale80,"",STATUS,"","gfe:",1)
                 NEXT FIELD ale80
              END IF
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                    (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
                     g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
                     g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
                     g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
                     g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
                 CALL t810_set_ale87()
              END IF
           END IF
           CALL cl_show_fld_cont()         
           #No.FUN-BB0086--add--begin--
           IF NOT t810_ale82_check(p_cmd) THEN 
              LET g_ale80_t = g_ale[l_ac].ale80
              NEXT FIELD ale82
           END IF 
           LET g_ale80_t = g_ale[l_ac].ale80
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD ale81  #第一轉換率
           IF NOT cl_null(g_ale[l_ac].ale81) THEN
              IF g_ale[l_ac].ale81=0 THEN
                 NEXT FIELD ale81
              END IF
           END IF
 
        AFTER FIELD ale82  #第一數量
           IF NOT t810_ale82_check(p_cmd) THEN NEXT FIELD ale82 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_ale[l_ac].ale82) THEN
           #   IF g_ale[l_ac].ale82 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD ale82
           #   END IF
           #END IF
           #CALL t810_set_origin_field()
           #IF cl_null(g_ale[l_ac].ale86) THEN
           #   LET g_ale[l_ac].ale87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
           #          g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
           #          g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
           #          g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
           #          g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
           #      CALL t810_set_ale87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD ale86
           IF NOT cl_null(g_ale[l_ac].ale11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_ale[l_ac].ale11
           END IF
           CALL t810_set_no_required()
 
        AFTER FIELD ale86
           IF cl_null(g_ale[l_ac].ale11) THEN NEXT FIELD ale11 END IF
           IF NOT cl_null(g_ale[l_ac].ale86) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ale[l_ac].ale86
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ale[l_ac].ale86,"",STATUS,"","gfe:",1)
                 NEXT FIELD ale86
              END IF
              CALL s_du_umfchk(g_ale[l_ac].ale11,'','','',
                               g_ima44,g_ale[l_ac].ale86,'1')
                  RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ale[l_ac].ale86,g_errno,1)  
                 NEXT FIELD ale86
              END IF
           END IF
           CALL t810_set_required()
           #No.FUN-BB0086--add--begin--
           IF g_sma.sma116 NOT MATCHES '[02]' THEN                 #TQC-C20183 add 
              IF NOT t810_ale87_check() THEN
                 LET g_ale86_t = g_ale[l_ac].ale86
                 NEXT FIELD ale87 
              END IF 
           ELSE
              LET g_ale[l_ac].ale87=s_digqty(g_ale[l_ac].ale87,g_ale[l_ac].ale86)
              DISPLAY BY NAME g_ale[l_ac].ale87
           END IF                                                  #TQC-C20183 add
           LET g_ale86_t = g_ale[l_ac].ale86
           #No.FUN-BB0086--add--end--
 
        BEFORE FIELD ale87
           IF g_sma.sma115 = 'Y' THEN
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
                  g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
                  g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
                  g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
                  g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
                 CALL t810_set_ale87()
              END IF
           ELSE
              IF g_ale[l_ac].ale87 = 0 OR
                 g_ale_t.ale86 <> g_ale[l_ac].ale86 THEN
                 CALL t810_set_ale87()
              END IF
           END IF
 
        AFTER FIELD ale87
           IF NOT t810_ale87_check() THEN NEXT FIELD ale87 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_ale[l_ac].ale87) THEN
           #   IF g_ale[l_ac].ale87 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD ale87
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD ale06
          #FUN-A60056--mod--str--
          #SELECT rvv87,rvv23 INTO g_qty1,g_qty2 FROM rvv_file   #FUN-560070
          # WHERE rvv01=g_ale[l_ac].ale16 AND rvv02=g_ale[l_ac].ale17
           LET g_sql = "SELECT rvv87,rvv23 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
                       " WHERE rvv01='",g_ale[l_ac].ale16,"' AND rvv02='",g_ale[l_ac].ale17,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
           PREPARE sel_rvv87 FROM g_sql
           EXECUTE sel_rvv87 INTO g_qty1,g_qty2
          #FUN-A60056--mod--end
           SELECT SUM(ale06) INTO g_qty3 FROM ale_file,alk_file
            WHERE ale16=g_ale[l_ac].ale16 AND ale17=g_ale[l_ac].ale17
              AND ale01=alk01 AND alkfirm='N'
              AND (ale01!=g_alk.alk01 OR ale02!=g_ale[l_ac].ale02)
           IF g_qty1 IS NULL THEN LET g_qty1 = 0 END IF
           IF g_qty2 IS NULL THEN LET g_qty2 = 0 END IF
           IF g_qty3 IS NULL THEN LET g_qty3 = 0 END IF
           LET g_qty2=g_qty2+g_qty3
           CALL cl_getmsg('aap-049',g_lang) RETURNING g_msg
           LET g_msg[10,25] = g_qty1 USING '---,---,---.---'
           LET g_msg[35,50] = g_qty2 USING '---,---,---.---'
           LET g_qty3 = g_qty1 - g_qty2
           ERROR g_msg CLIPPED,g_qty3 USING '---,---,---.---'
           IF g_ale[l_ac].ale06 = 0 THEN
              LET g_ale[l_ac].ale06 = g_qty3
              DISPLAY BY NAME g_ale[l_ac].ale06
           END IF
           LET g_ale[l_ac].ale07 = g_ale[l_ac].ale06 * g_ale[l_ac].ale05
           LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
           DISPLAY BY NAME g_ale[l_ac].ale07
           DISPLAY BY NAME g_ale[l_ac].ale07
           LET g_ale[l_ac].ale09 = g_ale[l_ac].ale06 * g_ale[l_ac].ale08
            LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)  #No.MOD-530729   #MOD-790060
           DISPLAY BY NAME g_ale[l_ac].ale07
           DISPLAY BY NAME g_ale[l_ac].ale09
 
        AFTER FIELD ale06
           IF NOT t810_ale06_check() THEN NEXT FIELD ale06 END IF #FUN-BB0086 add
           #FUN-BB0086--mark--start--  
           #IF NOT cl_null(g_ale[l_ac].ale06) THEN
           #   IF g_ale[l_ac].ale16 != 'MISC' THEN
           #      IF g_ale[l_ac].ale06+g_qty2 > g_qty1 THEN
           #         CALL cl_err('','aap-048',1) NEXT FIELD ale06
           #      END IF
           #   END IF
           #   LET g_ale[l_ac].ale07 = g_ale[l_ac].ale06 * g_ale[l_ac].ale05
           #   LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
           #   LET g_ale[l_ac].ale09 = g_ale[l_ac].ale06 * g_ale[l_ac].ale08
           #    LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)  #No.MOD-530729   #MOD-790060
           #   DISPLAY BY NAME g_ale[l_ac].ale07
           #   DISPLAY BY NAME g_ale[l_ac].ale09
           #   CALL t810_qty_chk()
           #END IF
           #FUN-BB0086--mark---end---  

        BEFORE FIELD ale05
           LET g_ale[l_ac].ale07 = g_ale[l_ac].ale06 * g_ale[l_ac].ale05
           LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
 
        AFTER FIELD ale05
           IF NOT cl_null(g_ale[l_ac].ale05) THEN
               LET g_ale[l_ac].ale05 = cl_digcut(g_ale[l_ac].ale05,t_azi03)   #No.MOD-530729
              LET g_ale[l_ac].ale07 = g_ale[l_ac].ale06 * g_ale[l_ac].ale05
              LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
              DISPLAY BY NAME g_ale[l_ac].ale05
              DISPLAY BY NAME g_ale[l_ac].ale07
           END IF
 
        AFTER FIELD ale07
           LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
 
        BEFORE FIELD ale08
           LET g_ale[l_ac].ale09 = g_ale[l_ac].ale06 * g_ale[l_ac].ale08
           LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)   #MOD-790060
           DISPLAY BY NAME g_ale[l_ac].ale09
           DISPLAY BY NAME g_ale[l_ac].ale09
 
        AFTER FIELD ale08
           IF NOT cl_null(g_ale[l_ac].ale08) THEN
              LET g_ale[l_ac].ale08 = cl_digcut(g_ale[l_ac].ale08,g_azi03)   #MOD-790060
              LET g_ale[l_ac].ale09 = g_ale[l_ac].ale06 * g_ale[l_ac].ale08
              LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)   #MOD-790060
              DISPLAY BY NAME g_ale[l_ac].ale08
              DISPLAY BY NAME g_ale[l_ac].ale09
           END IF
 
        AFTER FIELD ale09
           LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)   #MOD-790060
 
        BEFORE FIELD ale11
           CALL t810_set_entry_b(p_cmd)
           CALL t810_set_no_required()       
           CALL t810_set_entry_b(p_cmd)
 
        AFTER FIELD ale11
           CALL t810_set_no_entry_b(p_cmd)
           CALL t810_set_required()
           IF g_sma.sma115 = 'Y' THEN
              CALL s_chk_va_setting(g_ale[l_ac].ale11)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD ale11
              END IF
              CALL s_chk_va_setting1(g_ale[l_ac].ale11)
                   RETURNING g_flag,g_ima908
              IF g_flag=1 THEN
                 NEXT FIELD ale05
              END IF
              IF g_ima906 = '3' THEN
                 LET g_ale[l_ac].ale83=g_ima907
              END IF
              IF g_sma.sma116 MATCHES '[13]' THEN   
                 LET g_ale[l_ac].ale86=g_ima908
              END IF
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_ale[l_ac].ale11
              IF cl_null(g_ale[l_ac].ale80) AND  
                 cl_null(g_ale[l_ac].ale83) THEN
                 CALL t810_du_default(p_cmd)
              END IF
          END IF
          CALL t810_set_required()
 
        AFTER FIELD ale13
           IF NOT cl_null(g_ale[l_ac].ale13) THEN
              #No.FUN-B10050  --Begin
              LET g_pass = 'Y'
              CALL t810_aag01(g_bookno1,g_ale[l_ac].ale13,'X')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ale[l_ac].ale13,g_errno,0)
                 LET g_pass = 'N' 
              END IF
              #No.FUN-B10050  --End  
              IF g_pass = 'Y' THEN      #No.FUN-B10050
                 SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01 = g_ale[l_ac].ale13
                     AND aag00 = g_bookno1                #No.FUN-730064
                 IF l_aag05 = 'Y' THEN
                   #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 ='Y' THEN
                       IF NOT cl_null(g_alk.alk930) THEN   #FUN-8C0106 add 
                          CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale13,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                       END IF                              #FUN-8C0106 add
                    ELSE
                       IF NOT cl_null(g_alk.alk04) THEN    #FUN-8C0106 add 
                          CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale13,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                       END IF                              #FUN-8C0106 add
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       #No.FUN-B10050  --Begin
                       LET g_pass = 'N'
                       #NEXT FIELD alk44
                       #No.FUN-B10050  --End  
                    END IF
                 END IF   #TQC-620028
              END IF                    #No.FUN-B10050
              #No.FUN-B10050  --Begin
              IF g_pass = 'N' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ale[l_ac].ale13
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ale[l_ac].ale13 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ale[l_ac].ale13
                 DISPLAY BY NAME g_ale[l_ac].ale13
                 NEXT FIELD ale13
              END IF
              #No.FUN-B10050  --End  
           END IF
            
        AFTER FIELD ale131
           IF NOT cl_null(g_ale[l_ac].ale131) THEN
              #No.FUN-B10050  --Begin
              LET g_pass = 'Y'
              CALL t810_aag01(g_bookno2,g_ale[l_ac].ale131,'X')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ale[l_ac].ale131,g_errno,0)
                 LET g_pass = 'N'
              END IF
              #No.FUN-B10050  --End
              IF g_pass = 'Y' THEN      #No.FUN-B10050
                 SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01 = g_ale[l_ac].ale131
                     AND aag00 = g_bookno2             #No.FUN-730064
                 IF l_aag05 = 'Y' THEN
                   #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 ='Y' THEN
                       IF NOT cl_null(g_alk.alk930) THEN   #FUN-8C0106 add 
                          CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale131,g_alk.alk930,g_bookno1) RETURNING g_errno  #No.FUN-730064
                       END IF                              #FUN-8C0106 add
                    ELSE
                       IF NOT cl_null(g_alk.alk04) THEN    #FUN-8C0106 add 
                          CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale131,g_alk.alk04,g_bookno1) RETURNING g_errno  #No.FUN-730064
                       END IF                              #FUN-8C0106 add
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       #No.FUN-B10050  --Begin
                       LET g_pass = 'N'
                       #NEXT FIELD alk44
                       #No.FUN-B10050  --End
                    END IF
                 END IF
              END IF                    #No.FUN-B10050
              #No.FUN-B10050  --Begin
              IF g_pass = 'N' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ale[l_ac].ale131
                 LET g_qryparam.arg1 = g_bookno2
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ale[l_ac].ale131 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ale[l_ac].ale131
                 DISPLAY BY NAME g_ale[l_ac].ale131
                 NEXT FIELD ale131
              END IF
              #No.FUN-B10050  --End

           END IF
 
        AFTER FIELD ale930 
           IF NOT s_costcenter_chk(g_ale[l_ac].ale930) THEN
              LET g_ale[l_ac].ale930=g_ale_t.ale930
              LET g_ale[l_ac].gem02c=g_ale_t.gem02c
              DISPLAY BY NAME g_ale[l_ac].ale930,g_ale[l_ac].gem02c
              NEXT FIELD ale930
           ELSE
              LET g_ale[l_ac].gem02c=s_costcenter_desc(g_ale[l_ac].ale930)
              DISPLAY BY NAME g_ale[l_ac].gem02c
           END IF
 
           IF NOT cl_null(g_ale[l_ac].ale930) THEN
             #會科一
              LET l_aag05=''
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_ale[l_ac].ale13
                  AND aag00 = g_bookno1         
              IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale13) THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 ='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale13,g_alk.alk930,g_bookno1) RETURNING g_errno                
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD ale930
                 END IF
              END IF
 
             #會科二
              IF g_aza.aza63='Y' THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01 = g_ale[l_ac].ale131
                     AND aag00 = g_bookno2         
                 IF l_aag05 = 'Y' AND NOT cl_null(g_ale[l_ac].ale131) THEN
                   #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 ='Y' THEN
                       CALL s_chkdept(g_aaz.aaz72,g_ale[l_ac].ale131,g_alk.alk930,g_bookno2) RETURNING g_errno                
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD ale930
                    END IF
                 END IF
              END IF 
           END IF
 
 
        AFTER FIELD aleud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
        AFTER FIELD aleud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aleud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_ale_t.ale02 > 0 AND g_ale_t.ale02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM ale_file
               WHERE ale01 = g_alk.alk01
                 AND ale02 = g_ale_t.ale02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ale_file",g_alk.alk01,g_ale_t.ale02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t810_b_tot('u')
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ale[l_ac].* = g_ale_t.*
              CLOSE t810_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ale[l_ac].ale02,-263,1)
              LET g_ale[l_ac].* = g_ale_t.*
           ELSE
               CALL t810_set_origin_field()  
 
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_ale[l_ac].ale11) THEN
                     SELECT ima44,ima31 INTO g_ima44,g_ima31
                       FROM ima_file WHERE ima01=g_ale[l_ac].ale11
                  END IF
 
                  CALL s_chk_va_setting(g_ale[l_ac].ale11)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD ale11
                  END IF
                  CALL s_chk_va_setting1(g_ale[l_ac].ale11)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD ale02
                  END IF
                  CALL t810_du_data_to_correct()
                  CALL t810_set_origin_field()
               END IF
              UPDATE ale_file SET ale02 = g_ale[l_ac].ale02,
                                  ale16 = g_ale[l_ac].ale16,
                                  ale17 = g_ale[l_ac].ale17,
                                  ale14 = g_ale[l_ac].ale14,
                                  ale15 = g_ale[l_ac].ale15,
                                  ale11 = g_ale[l_ac].ale11,
                                  ale06 = g_ale[l_ac].ale06,
                                  ale05 = g_ale[l_ac].ale05,
                                  ale07 = g_ale[l_ac].ale07,
                                  ale08 = g_ale[l_ac].ale08,
                                  ale09 = g_ale[l_ac].ale09,
                                  ale13 = g_ale[l_ac].ale13,
                                  ale131= g_ale[l_ac].ale131,  #No.FUN-680029
                                  ale930= g_ale[l_ac].ale930,  #FUN-680019
                                  ale80 = g_ale[l_ac].ale80,   #FUN-710029
                                  ale81 = g_ale[l_ac].ale81,   #FUN-710029
                                  ale82 = g_ale[l_ac].ale82,   #FUN-710029
                                  ale83 = g_ale[l_ac].ale83,   #FUN-710029
                                  ale84 = g_ale[l_ac].ale84,   #FUN-710029
                                  ale85 = g_ale[l_ac].ale85,   #FUN-710029
                                  ale86 = g_ale[l_ac].ale86,   #FUN-710029
                                  ale87 = g_ale[l_ac].ale87,   #FUN-710029
                                  aleud01 = g_ale[l_ac].aleud01,
                                  aleud02 = g_ale[l_ac].aleud02,
                                  aleud03 = g_ale[l_ac].aleud03,
                                  aleud04 = g_ale[l_ac].aleud04,
                                  aleud05 = g_ale[l_ac].aleud05,
                                  aleud06 = g_ale[l_ac].aleud06,
                                  aleud07 = g_ale[l_ac].aleud07,
                                  aleud08 = g_ale[l_ac].aleud08,
                                  aleud09 = g_ale[l_ac].aleud09,
                                  aleud10 = g_ale[l_ac].aleud10,
                                  aleud11 = g_ale[l_ac].aleud11,
                                  aleud12 = g_ale[l_ac].aleud12,
                                  aleud13 = g_ale[l_ac].aleud13,
                                  aleud14 = g_ale[l_ac].aleud14,
                                  aleud15 = g_ale[l_ac].aleud15
               WHERE ale01=g_alk.alk01
                 AND ale02=g_ale_t.ale02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ale_file",g_alk.alk01,g_ale_t.ale02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 LET g_ale[l_ac].* = g_ale_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 CALL t810_b_tot('u')
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ale[l_ac].* = g_ale_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_ale.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE t810_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           CLOSE t810_bcl
           COMMIT WORK
           CALL t810_b_tot('u')
 
        AFTER INPUT
           SELECT SUM(ale07) INTO l_tot FROM ale_file
            WHERE ale01 = g_alk.alk01
           LET l_tot = cl_digcut(l_tot,t_azi04)
           IF g_alk.alk13 != l_tot THEN
          #-----------------------------No.CHI-B80025----------------------start
          #單身原幣金額合計與單頭到貨金額不符, (1)更新單頭 (2)更新單身:
              CALL cl_getmsg('aap-812',g_lang) RETURNING g_msg
              WHILE TRUE
                 LET g_chr=' '
                 LET INT_FLAG = 0
                 PROMPT g_msg CLIPPED FOR CHAR g_chr
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
                    ON ACTION about
                       CALL cl_about()
                    ON ACTION help
                       CALL cl_show_help()
                    ON ACTION controlg
                       CALL cl_cmdask()
                 END PROMPT
                 IF INT_FLAG THEN LET INT_FLAG = 0 END IF
                 IF g_chr MATCHES "[12]" THEN EXIT WHILE END IF
              END WHILE
              IF g_chr = '1' THEN
             #IF cl_confirm("aap-731") THEN
             #-----------------------------No.CHI-B80025----------------------end
                LET g_alk.alk13=l_tot
                DISPLAY BY NAME g_alk.alk13
                UPDATE alk_file set alk13=g_alk.alk13 WHERE alk01=g_alk.alk01
                IF STATUS OR SQLCA.SQLCODE THEN
                   CALL cl_err3("upd","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","upd alk:",1)  #No.FUN-660122
                   ROLLBACK WORK
                END IF
              ELSE                   #No.CHI-B80025 add
                 CALL t810_diff()    #No.CHI-B80025 add
              END IF
           END IF
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ale16) # 入庫單號
                CALL q_rvv2(FALSE,TRUE,g_alk.alk05,
                           #'','','')   #FUN-9A0093
                           '','','','') #FUN-9A0093  
                RETURNING g_ale[l_ac].ale16,g_ale[l_ac].ale17
                DISPLAY g_ale[l_ac].ale16 TO ale16
                DISPLAY g_ale[l_ac].ale17 TO ale17
 
              WHEN INFIELD(ale13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_ale[l_ac].ale13
                 LET g_qryparam.arg1 = g_bookno1         #No.FUN--730064
                 CALL cl_create_qry() RETURNING g_ale[l_ac].ale13
                 DISPLAY BY NAME g_ale[l_ac].ale13
                 NEXT FIELD ale13
              WHEN INFIELD(ale131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_ale[l_ac].ale131
                 LET g_qryparam.arg1 = g_bookno2         #No.FUN--730064
                 CALL cl_create_qry() RETURNING g_ale[l_ac].ale131
                 DISPLAY BY NAME g_ale[l_ac].ale131
                 NEXT FIELD ale131
              WHEN INFIELD(ale80) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ale[l_ac].ale80
                   CALL cl_create_qry() RETURNING g_ale[l_ac].ale80
                   DISPLAY BY NAME g_ale[l_ac].ale80
                   NEXT FIELD ale80
              WHEN INFIELD(ale83) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ale[l_ac].ale83
                   CALL cl_create_qry() RETURNING g_ale[l_ac].ale83
                   DISPLAY BY NAME g_ale[l_ac].ale83
                   NEXT FIELD ale83
              WHEN INFIELD(ale86) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ale[l_ac].ale86
                   CALL cl_create_qry() RETURNING g_ale[l_ac].ale86
                   DISPLAY BY NAME g_ale[l_ac].ale86
                   NEXT FIELD ale86
              WHEN INFIELD(ale930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_ale[l_ac].ale930
                 DISPLAY BY NAME g_ale[l_ac].ale930
                 NEXT FIELD ale930
 
             OTHERWISE EXIT CASE
          END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ale02) AND l_ac > 1 THEN
              LET g_ale[l_ac].* = g_ale[l_ac-1].*
              LET g_ale[l_ac].ale02 = NULL   #TQC-620018
              NEXT FIELD ale02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION gen_detail
           CALL t810_g_b()      # 依 入庫單 (rvv_file) 產生
           CALL t810_b_fill('1=1')
           EXIT INPUT
 
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
    UPDATE alk_file SET alkmodu=g_user,alkdate=g_today
     WHERE alk01=g_alk.alk01
    CALL t810_delHeader()  #CHI-C30002 add
    CLOSE t810_bcl
    COMMIT WORK
    IF NOT cl_null(g_alk.alk01) THEN    #CHI-C30002 add
     CALL t810_b_fill('1=1') #MOD-490422
    END IF                              #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 ------ add ------ begin
FUNCTION t810_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
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
         CALL t810_x()
         IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"") 
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE npp01 = g_alk.alk01
                                AND nppsys = 'LC' AND npp00 = 4
                                AND npp011 = 1
         DELETE FROM npq_file WHERE npq01 = g_alk.alk01
                                AND npqsys = 'LC' AND npq00 = 4
                                AND npq011 = 1
         DELETE FROM tic_file WHERE tic04 = g_alk.alk01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM alk_file WHERE alk01=g_alk.alk01
         INITIALIZE g_alk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------ add ------ end
 
FUNCTION t810_ale16()
  DEFINE l_pmc04 LIKE pmc_file.pmc04,
         l_sql   LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET g_errno = " "                         #-->check 付款廠商是否一致
   IF g_ale[l_ac].ale16='MISC' THEN RETURN END IF
  #FUN-A60056--mod--str--
  #SELECT MAX(pmc04) INTO l_pmc04 FROM rvv_file LEFT OUTER JOIN pmc_file ON rvv_file.rvv06 = pmc_file.pmc01
  # WHERE rvv01 = g_ale[l_ac].ale16
   LET g_sql = "SELECT MAX(pmc04) FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
               "  LEFT OUTER JOIN ",cl_get_target_table(g_alk.alk97,'pmc_file'),
               "       ON rvv_file.rvv06 = pmc_file.pmc01",
               " WHERE rvv01 = '",g_ale[l_ac].ale16,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE sel_pmc04 FROM g_sql
   EXECUTE sel_pmc04 INTO l_pmc04
  #FUN-A60056--mod--end
   CASE
      WHEN l_pmc04 != g_alk.alk05  LET g_errno = 'aap-199'
      OTHERWISE                    LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION t810_ale17(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_alb01        LIKE alb_file.alb01    #FUN-660117 #CHAR(20)
   DEFINE l_qty          LIKE rvv_file.rvv87    #No.FUN-690028 DEC(15,3)  #FUN-4B0079
   DEFINE l_pmn40        LIKE pmn_file.pmn40    #FUN-660117 #CHAR(20)
   DEFINE l_pmn401       LIKE pmn_file.pmn401   #FUN-660117
 
   LET g_errno = ' '
   IF g_ale[l_ac].ale16='MISC' THEN
      LET g_ale[l_ac].ale14='MISC'
      LET g_ale[l_ac].ale15=0
      LET g_ale[l_ac].ale11='MISC'
      DISPLAY BY NAME g_ale[l_ac].ale14   #MOD-5A0095
      DISPLAY BY NAME g_ale[l_ac].ale15   #MOD-5A0095
      DISPLAY BY NAME g_ale[l_ac].ale11   #MOD-5A0095
      RETURN
   END IF
  #FUN-A60056--mod--str--
  #SELECT rvv87-rvv23 INTO l_qty FROM rvv_file   #FUN-560070
  # WHERE rvv01=g_ale[l_ac].ale16 AND rvv02=g_ale[l_ac].ale17
   LET g_sql = "SELECT rvv87-rvv23 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
               " WHERE rvv01='",g_ale[l_ac].ale16,"'",
               "   AND rvv02='",g_ale[l_ac].ale17,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE sel_rvv87_rvv23 FROM g_sql
   EXECUTE sel_rvv87_rvv23 INTO l_qty
  #FUN-A60056--mod--end
   IF STATUS THEN 
      CALL cl_err3("sel","rvv_file",g_ale[l_ac].ale16,g_ale[l_ac].ale17,STATUS,"","rvv_file:",1)  #No.FUN-660122
      LET g_errno=1 RETURN
   END IF
   IF g_ale_t.ale17 IS NULL AND l_qty <= 0 THEN
      CALL cl_err('','aap-245',1)
      LET g_errno=1
      RETURN
   END IF
  #FUN-A60056--mod--str--
  #SELECT rvb04,rvb03,pmn31,rvb05,pmn041,pmn40,pmn401            # 取PO,料號,數量,科目
  #  INTO g_ale[l_ac].ale14,g_ale[l_ac].ale15,g_ale[l_ac].ale05,
  #       g_ale[l_ac].ale11,g_ale[l_ac].pmn041,l_pmn40,l_pmn401
  #  FROM rvv_file, rvb_file, pmn_file
  # WHERE rvv01=g_ale[l_ac].ale16 AND rvv02=g_ale[l_ac].ale17 AND rvv03='1'
  #   AND rvv04=rvb01 AND rvv05=rvb02
  #   AND rvb04=pmn01 AND rvb03=pmn02
   LET g_sql = "SELECT rvb04,rvb03,pmn31,rvb05,pmn041,pmn40,pmn401",
               "  FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),",",
               "       ",cl_get_target_table(g_alk.alk97,'rvb_file'),",",
               "       ",cl_get_target_table(g_alk.alk97,'pmn_file'), 
               " WHERE rvv01='",g_ale[l_ac].ale16,"'" , 
               "   AND rvv02='",g_ale[l_ac].ale17,"'" ,
               "   AND rvv03='1' AND rvv04=rvb01 AND rvv05=rvb02",
               "   AND rvb04=pmn01 AND rvb03=pmn02"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
  PREPARE sel_rvb04 FROM g_sql
  EXECUTE sel_rvb04 INTO g_ale[l_ac].ale14,g_ale[l_ac].ale15,g_ale[l_ac].ale05,
                         g_ale[l_ac].ale11,g_ale[l_ac].pmn041,l_pmn40,l_pmn401
  #FUN-A60056--mod--end
   IF STATUS THEN 
      CALL cl_err3("sel","rvv_file,rvb_file,pmn_file",g_ale[l_ac].ale16,g_ale[l_ac].ale17,STATUS,"","pmn_file:",1)  #No.FUN-660122
      LET g_errno=1 RETURN
   END IF
   IF g_ale[l_ac].ale11[1,4]='MISC' AND g_ale[l_ac].ale13 IS NULL THEN
      LET g_ale[l_ac].ale13=l_pmn40
   ELSE                #抓料件檔預設會計科目
      IF g_ale[l_ac].ale13 IS NULL THEN  #No.FUN-680029
         SELECT ima39 INTO g_ale[l_ac].ale13 FROM ima_file
          WHERE ima01 = g_ale[l_ac].ale11
      END IF  #No.FUN-680029
   END IF
   DISPLAY BY NAME g_ale[l_ac].ale13   #MOD-5A0095
   IF g_aza.aza63 = 'Y' THEN
      IF g_ale[l_ac].ale11[1,4]='MISC' AND g_ale[l_ac].ale131 IS NULL THEN
         LET g_ale[l_ac].ale131=l_pmn401
      ELSE                #抓料件檔預設會計科目
         IF g_ale[l_ac].ale131 IS NULL THEN
            SELECT ima391 INTO g_ale[l_ac].ale131 FROM ima_file
             WHERE ima01 = g_ale[l_ac].ale11
         END IF
      END IF
      DISPLAY BY NAME g_ale[l_ac].ale131
   END IF
   LET l_alb01 = NULL
   SELECT MAX(alb01) INTO l_alb01 FROM alb_file
    WHERE alb04=g_ale[l_ac].ale14 AND alb05=g_ale[l_ac].ale15
   IF g_alk.alk03 IS NULL AND l_alb01 IS NOT NULL THEN
      CALL cl_err(l_alb01,'aap-750',1)
      LET g_errno=1 RETURN
   END IF
   IF g_alk.alk03 IS NOT NULL THEN            # 若有預付款(LC/TT)
      SELECT alb06 INTO g_ale[l_ac].ale05
        FROM alb_file
       WHERE alb01=g_alk.alk03
         AND alb04=g_ale[l_ac].ale14 AND alb05=g_ale[l_ac].ale15
      IF STATUS THEN
         CALL cl_err3("sel","alb_file",g_alk.alk03,g_ale[l_ac].ale14,STATUS,"","read LC:",1)  #No.FUN-660122
      END IF
   END IF
   IF g_ale[l_ac].ale06 = 0 THEN LET g_ale[l_ac].ale06 = l_qty END IF
   DISPLAY BY NAME g_ale[l_ac].ale05   #MOD-5A0095
   DISPLAY BY NAME g_ale[l_ac].ale06   #MOD-5A0095
  #若使用多單位,需帶出多單位欄位的值
   IF g_sma.sma115 = 'Y' THEN
      CALL s_chk_va_setting(g_ale[l_ac].ale11)
           RETURNING g_flag,g_ima906,g_ima907
      CALL s_chk_va_setting1(g_ale[l_ac].ale11)
           RETURNING g_flag,g_ima908
      IF g_ima906 = '3' THEN
         LET g_ale[l_ac].ale83=g_ima907
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN   
         LET g_ale[l_ac].ale86=g_ima908
      END IF
      SELECT ima44,ima31 INTO g_ima44,g_ima31
        FROM ima_file WHERE ima01=g_ale[l_ac].ale11
      IF cl_null(g_ale[l_ac].ale80) AND  
         cl_null(g_ale[l_ac].ale83) THEN
         CALL t810_du_default(p_cmd)
         DISPLAY BY NAME g_ale[l_ac].ale80,g_ale[l_ac].ale81,g_ale[l_ac].ale82,
                         g_ale[l_ac].ale83,g_ale[l_ac].ale84,g_ale[l_ac].ale85,
                         g_ale[l_ac].ale86,g_ale[l_ac].ale87
         CALL t810_du_data_to_correct()
      END IF
   END IF
END FUNCTION
 
FUNCTION t810_qty_chk()
   DEFINE l_alb07,l_totqty     LIKE alb_file.alb07      # No.FUN-690028  DEC(15,3)  #FUN-4B0079
   IF g_ale[l_ac].ale16='MISC' THEN RETURN END IF
   IF g_alk.alk03 IS NULL      THEN RETURN END IF
   SELECT alb07 INTO l_alb07            # 取原LC預購量
     FROM alb_file
    WHERE alb01=g_alk.alk03
      AND alb04=g_ale[l_ac].ale14 AND alb05=g_ale[l_ac].ale15
   SELECT SUM(ale06) INTO l_totqty      # 取總共已到貨量(除本筆外)
     FROM alk_file,ale_file
    WHERE alk03=g_alk.alk03 AND alk01=ale01
      AND ale14=g_ale[l_ac].ale14 AND ale15=g_ale[l_ac].ale15
      AND alk01!=g_alk.alk01
      AND alkfirm <> 'X'  #CHI-C80041
   IF l_totqty IS NULL THEN LET l_totqty=0 END IF
   LET l_totqty = l_totqty + g_ale[l_ac].ale06
   IF l_totqty > l_alb07 THEN
      CALL cl_err('','aap-246',0)
   END IF
END FUNCTION
 
FUNCTION t810_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   CONSTRUCT g_wc2 ON ale02,ale16,ale17,ale14,ale15,ale11,
                      ale83,ale84,ale85,ale80,ale81,ale82,ale86,ale87,  #FUN-710029
                      ale06,ale13,ale131  #No.FUN-680029
                     ,aleud01,aleud02,aleud03,aleud04,aleud05
                     ,aleud06,aleud07,aleud08,aleud09,aleud10
                     ,aleud11,aleud12,aleud13,aleud14,aleud15
           FROM s_ale[1].ale02,s_ale[1].ale16,s_ale[1].ale17,
                s_ale[1].ale14,s_ale[1].ale15,s_ale[1].ale11,
                s_ale[1].ale83,s_ale[1].ale84,s_ale[1].ale85,  #FUN-710029
                s_ale[1].ale80,s_ale[1].ale81,s_ale[1].ale82,  #FUN-710029
                s_ale[1].ale86,s_ale[1].ale87,  #FUN-710029
                s_ale[1].ale06,s_ale[1].ale13,s_ale[1].ale131  #No.FUN-680029
               ,s_ale[1].aleud01,s_ale[1].aleud02,s_ale[1].aleud03
               ,s_ale[1].aleud04,s_ale[1].aleud05,s_ale[1].aleud06
               ,s_ale[1].aleud07,s_ale[1].aleud08,s_ale[1].aleud09
               ,s_ale[1].aleud10,s_ale[1].aleud11,s_ale[1].aleud12
               ,s_ale[1].aleud13,s_ale[1].aleud14,s_ale[1].aleud15
 
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
   CALL t810_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t810_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   LET g_sql = "SELECT ale02,ale16,ale17,ale14,ale15,ale11,pmn041,",
               "       ale83,ale84,ale85,ale80,ale81,ale82,ale86,ale87,",     #FUN-710029
               "       ale06,ale13,ale131,ale05,ale07,ale08,ale09,ale930,'',", #FUN-680019  #No.FUN-680029
               "       aleud01,aleud02,aleud03,aleud04,aleud05,",
               "       aleud06,aleud07,aleud08,aleud09,aleud10,",
               "       aleud11,aleud12,aleud13,aleud14,aleud15 ",
              #FUN-A60056--mod--str--
              #" FROM ale_file LEFT OUTER JOIN pmn_file ON ale_file.ale14 = pmn_file.pmn01 AND ale_file.ale15 = pmn_file.pmn02",
               " FROM ale_file LEFT OUTER JOIN ",cl_get_target_table(g_alk.alk97,'pmn_file'),
               "   ON ale_file.ale14 = pmn_file.pmn01 AND ale_file.ale15 = pmn_file.pmn02",
              #FUN-A60056--mod--end
               " WHERE ale01 ='",g_alk.alk01,"'",
               " ORDER BY 1"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql   #FUN-A60056
   PREPARE t810_pb FROM g_sql
   DECLARE ale_curs CURSOR FOR t810_pb
 
   CALL g_ale.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH ale_curs INTO g_ale[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_ale[g_cnt].gem02c=s_costcenter_desc(g_ale[g_cnt].ale930) #FUN-680019
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ale.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t810_b_tot('d')   #TQC-5C0028
END FUNCTION
 
FUNCTION t810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ale TO s_ale.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("maintain_entry2",TRUE)
         ELSE
            CALL cl_set_act_visible("maintain_entry2",FALSE)
         END IF
 
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
         CALL t810_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t810_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t810_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t810_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t810_fetch('L')
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
         #CALL cl_set_field_pic(g_alk.alkfirm,"","","","","") #CHI-C80041
         IF g_alk.alkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_alk.alkfirm,"","","",g_void,"")  #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION apportion
         LET g_action_choice="apportion"
         EXIT DISPLAY
 
      ON ACTION transfer_to_an
         LET g_action_choice="transfer_to_an"
         EXIT DISPLAY
 
      ON ACTION get_estd_exp
         LET g_action_choice="get_estd_exp"
         EXIT DISPLAY
 
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
      #@ON ACTION 會計分錄維護
      ON ACTION maintain_entry
         LET g_action_choice="maintain_entry"
         EXIT DISPLAY
 
      #@ON ACTION 會計分錄維護2
      ON ACTION maintain_entry2
         LET g_action_choice="maintain_entry2"
         EXIT DISPLAY
 
      #@ON ACTION 會計科目設定
      ON ACTION acct_title
         LET g_action_choice="acct_title"
         EXIT DISPLAY
 
      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher" 
         EXIT DISPLAY 
 
      ON ACTION undo_carry_voucher #傳票拋轉還原 
         LET g_action_choice="undo_carry_voucher" 
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
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
      #--FUN-B10030--start--
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
     ON ACTION mul_invoice  #多發票
        LET g_action_choice="mul_invoice"
        EXIT DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t810_g_b()
   DEFINE l_sql,l_wc  LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
   DEFINE l_alb01     LIKE alb_file.alb01    #FUN-660117 #CHAR(20)
   DEFINE l_msg       LIKE ze_file.ze03      #No.FUN-690028 VARCHAR(30)
   DEFINE l_alb06     LIKE alb_file.alb06    #FUN-4B0079
   DEFINE l_alt05     LIKE alt_file.alt05
   DEFINE l_alt07     LIKE alt_file.alt07
   DEFINE l_rvv06     LIKE rvv_file.rvv06    #No.FUN-690028 VARCHAR(08)
   DEFINE l_pmn40     LIKE pmn_file.pmn40    #FUN-660117 #CHAR(20)
   DEFINE l_pmn401    LIKE pmn_file.pmn401   #FUN-660117
   DEFINE l_yy        LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_mm        LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
 
   OPEN WINDOW t810_g_b_w AT 15,20 WITH FORM "aap/42f/aapt810g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt810g")
 
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   CONSTRUCT BY NAME l_wc ON rvb22,rvv01,rvv09
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rvb22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_rvb2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvb22
            WHEN INFIELD(rvv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_rvv5"
                 LET g_qryparam.where = "rvv01||rvv02 NOT IN (SELECT ale16||ale17 FROM ale_file)"   #MOD-CB0260 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvv01
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
   CLOSE WINDOW t810_g_b_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET l_yy = YEAR(g_alk.alk02)
   LET l_mm = MONTH(g_alk.alk02)
 
  #-------------------------------------MOD-C80252-----------------------------(S)
  #--MOD-C80252--mark
  #LET l_sql= "SELECT '',rvv01,rvv02,rvb04,rvb03,rvb05,pmn041,",
  #           "       rvb83,rvb84,rvb85,rvb80,rvb81,rvb82,rvb86,rvb87,",    #FUN-710029
  #           "       rvv87-rvv23,'','', ",   #FUN-560070 #No.FUN-680029
  #           "       pmn31,0,0,0,pmn930,'',pmn40,pmn401,alb06,0", #FUN-680019  #No.FUN-680029
  #--MOD-C80252--mark
   LET l_sql= "SELECT '',rvv01,rvv02,rvb04,rvb03, ",
              "       rvb05,pmn041,rvb83,rvb84,rvb85, ",
              "       rvb80,rvb81,rvb82,rvb86,rvb87, ",
              "       rvv87-rvv23,'','',pmn31,0, ",
              "       0,0,pmn930,'','', ",
              "       '','','','','', ",
              "       '','','','','', ",
              "       '','','','',pmn40, ",
              "       pmn401,alb06,0 ",
  #-------------------------------------MOD-C80252-----------------------------(E)
             #FUN-A60056--mod--str--
             #"  FROM rvv_file, rvb_file, pmn_file, alb_file,rvu_file",
              "  FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),",",
              "       ",cl_get_target_table(g_alk.alk97,'rvb_file'),",",
              "       ",cl_get_target_table(g_alk.alk97,'pmn_file'),",",
              "       ",cl_get_target_table(g_alk.alk97,'rvu_file'),",alb_file",
             #FUN-A60056--mod--end
              " WHERE rvv03='1' AND rvv87>rvv23",    #FUN-560070
              "   AND rvv04=rvb01 AND rvv05=rvb02",
              "   AND rvb04=pmn01 AND rvb03=pmn02",
              "   AND alb04=pmn01 AND alb05=pmn02",
              "   AND alb01='",g_alk.alk03,"'",
              "   AND YEAR(rvv09)= ",l_yy,                                     #TQC-9B0018 Add
              "   AND MONTH(rvv09)= ",l_mm,                                    #TQC-9B0018 Add 
              "   AND rvv01 = rvu01 ",
              "   AND rvuconf = 'Y'",
              "   AND ",l_wc CLIPPED,
              "   AND rvv01||rvv02 NOT IN (SELECT ale16||ale17 FROM ale_file)", #MOD-CB0260 add
              " ORDER BY rvv01,rvv02"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A60056
   CALL cl_parse_qry_sql(l_sql,g_alk.alk97) RETURNING l_sql   #FUN-A60056
   PREPARE t810_g_b_p1 FROM l_sql
   DECLARE t810_g_b_c1 CURSOR WITH HOLD FOR t810_g_b_p1
   SELECT SUM(ale07) INTO g_tot FROM ale_file WHERE ale01 = g_alk.alk01
   IF g_tot IS NULL THEN LET g_tot = 0 END IF
   LET l_ac = 1
   FOREACH t810_g_b_c1 INTO g_ale[l_ac].*, l_pmn40,l_pmn401, l_alb06,l_alt05 #FUN-680019  #No.FUN-680029
      IF STATUS THEN CALL cl_err('',STATUS,1) EXIT FOREACH END IF
      SELECT alt05,alt07 INTO l_alt05,l_alt07 FROM alt_file
       WHERE alt01 = g_alk.alk01 AND alt14 = g_ale[l_ac].ale14
         AND alt15 = g_ale[l_ac].ale15
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = g_alk.alk11
      IF SQLCA.SQLCODE != 0 THEN
         LET t_azi04 = 0
      END IF
      IF cl_null(l_alt05) THEN LET l_alt05 = 0 END IF
      IF l_alt05 > 0 THEN LET g_ale[l_ac].ale05 = l_alt05 END IF
      LET g_ale[l_ac].ale07 = g_ale[l_ac].ale05 * g_ale[l_ac].ale06   #MOD-720056
      LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
      IF g_ale[l_ac].ale11[1,4]='MISC' THEN 
         LET g_ale[l_ac].ale13=l_pmn40 
         IF g_aza.aza63 = 'Y' THEN
            LET g_ale[l_ac].ale131=l_pmn401 
         END IF
      END IF
      SELECT max(ale02)+1 INTO g_ale[l_ac].ale02
        FROM ale_file WHERE ale01 = g_alk.alk01
      IF g_ale[l_ac].ale02 IS NULL THEN LET g_ale[l_ac].ale02 = 1 END IF
      LET g_tot = g_tot + g_ale[l_ac].ale07
      IF g_sma.sma115 = 'Y' THEN
         CALL t810_set_du_by_origin('b')
      END IF
      MESSAGE '>:',g_ale[l_ac].ale02,' ',
                   g_ale[l_ac].ale16,' ',g_ale[l_ac].ale17,' ',
                   g_ale[l_ac].ale06,' Total:',g_tot
      INSERT INTO ale_file(ale01,ale02,ale16,ale17,ale14,
                           ale15,ale11,ale06,ale05,ale07,
                           ale08,ale09,ale13,ale131,ale930, #FUN-680019  #No.FUN-680029
                           ale80,ale81,ale82,ale83,ale84,ale85,ale86,ale87,alelegal)   #FUN-710029 #FUN-980001 add legal  #FUN-980076
       VALUES(g_alk.alk01, g_ale[l_ac].ale02,
              g_ale[l_ac].ale16,g_ale[l_ac].ale17,
              g_ale[l_ac].ale14,g_ale[l_ac].ale15,
              g_ale[l_ac].ale11,g_ale[l_ac].ale06,
              g_ale[l_ac].ale05,g_ale[l_ac].ale07,
              g_ale[l_ac].ale08,g_ale[l_ac].ale09,
              g_ale[l_ac].ale13,g_ale[l_ac].ale131,g_ale[l_ac].ale930, #FUN-680019  #No.FUN-680029
              g_ale[l_ac].ale80,g_ale[l_ac].ale81,g_ale[l_ac].ale82,   #FUN-710029
              g_ale[l_ac].ale83,g_ale[l_ac].ale84,g_ale[l_ac].ale85,   #FUN-710029
              g_ale[l_ac].ale86,g_ale[l_ac].ale87,g_legal)   #FUN-710029 #FUN-980001 add legal  #FUN-980076
      IF STATUS THEN
         CALL cl_err3("ins","ale_file",g_alk.alk01, g_ale[l_ac].ale02,STATUS,"","ins ale:",1)  #No.FUN-660122
         EXIT FOREACH
      END IF
      CALL t810_b_tot('u')
   END FOREACH
END FUNCTION
 
FUNCTION t810_t()
   DEFINE l_ala RECORD LIKE ala_file.*
   DEFINE l_alh RECORD LIKE alh_file.*
   DEFINE l_aps RECORD LIKE aps_file.*
   DEFINE arr_no LIKE alh_file.alh01   #TQC-5C0016
 
   IF g_alk.alk01 IS NULL THEN RETURN END IF
   SELECT * INTO g_alk.* FROM alk_file WHERE alk01=g_alk.alk01
   IF g_alk.alkfirm ='N' THEN CALL cl_err('','aap-717',0) RETURN END IF
   IF g_alk.alkfirm ='X' THEN RETURN END IF  #CHI-C80041
 
  OPEN WINDOW t810_2 AT 8,30 WITH FORM "aap/42f/aapt810_2"
  ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_locale("aapt810_2")
 
  CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
  INPUT BY NAME arr_no WITHOUT DEFAULTS
 
     AFTER FIELD arr_no
        IF arr_no = g_alk.alk01 THEN
           CALL cl_err(arr_no,'aap-164',0)
           NEXT FIELD arr_no
        END IF
        SELECT COUNT(*) INTO g_cnt FROM alh_file WHERE alh01 = arr_no
        IF g_cnt > 0 THEN
           CALL cl_err(arr_no,'aap-310',0)
           NEXT FIELD arr_no
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
     CLOSE WINDOW t810_2
     RETURN
  END IF

  IF NOT cl_confirm('aap-716') THEN CLOSE WINDOW t810_2 RETURN END IF   #TQC-5C0016
 
   LET g_success = 'Y' BEGIN WORK
   SELECT * INTO l_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
   INITIALIZE l_alh.* TO NULL
   LET l_alh.alh00='1'
   LET l_alh.alh01 = arr_no   #TQC-5C0016
   LET l_alh.alh02=' '  # 由財務自行輸入
   LET l_alh.alh021=g_alk.alk02
   LET l_alh.alh03=g_alk.alk03
   SELECT * INTO l_ala.* FROM ala_file WHERE ala01=g_alk.alk03
   LET l_alh.alh04=g_alk.alk04
   LET l_alh.alh05=g_alk.alk05
   LET l_alh.alh06=l_ala.ala07
   LET l_alh.alh07=l_ala.ala22
   LET l_alh.alh50=l_ala.ala21
   LET l_alh.alh08=' '  # 由財務自行輸入
   LET l_alh.alh09=0
   LET l_alh.alh10=g_alk.alk10
   LET l_alh.alh11=g_alk.alk11
   LET l_alh.alh12=g_alk.alk13
   LET l_alh.alh13=l_alh.alh12 * (l_alh.alh50 / 100)
   LET l_alh.alh14=l_alh.alh12 - l_alh.alh13
   LET l_alh.alh15=g_alk.alk12
   LET l_alh.alh16=l_alh.alh14 * l_alh.alh15
   LET l_alh.alh16 = cl_digcut(l_alh.alh16,g_azi04)
   LET l_alh.alh17=0
   LET l_alh.alh30=g_alk.alk01
   LET l_alh.alh31=g_alk.alk02
   LET l_alh.alh32=g_alk.alk13
   LET l_alh.alh33=l_alh.alh32 * l_alh.alh50 / 100
   LET l_alh.alh34=l_alh.alh32 - l_alh.alh33
   LET l_alh.alh35=g_alk.alk12
   LET l_alh.alh36=g_alk.alk16
   LET l_alh.alh37=(l_alh.alh14 - l_alh.alh34) * l_alh.alh15
   LET l_alh.alh38=l_alh.alh16-l_alh.alh36-l_alh.alh37
   LET l_alh.alh36=cl_digcut(l_alh.alh36,g_azi04)
   LET l_alh.alh37=cl_digcut(l_alh.alh37,g_azi04)
   LET l_alh.alh38=cl_digcut(l_alh.alh38,g_azi04)
   LET l_alh.alh41=''
   LET l_alh.alh42=g_alk.alk41
   LET l_alh.alh43=''
   LET l_alh.alh411=''
   LET l_alh.alh421=g_alk.alk411
   LET l_alh.alh431=''
   LET l_alh.alh44='2'  #No.B103 010517 by plum
   LET l_alh.alh45='N'  #No.B103 010517 by plum
   LET l_alh.alh52='N'   #TQC-5C0016
   LET l_alh.alh75='0'
   LET l_alh.alh76=0
   LET l_alh.alh77=0
   LET l_alh.alhfirm='N'
   LET l_alh.alhinpd=g_today
   LET l_alh.alhacti='Y'
   LET l_alh.alhuser=g_user
   LET l_alh.alhgrup=g_grup
   LET l_alh.alh930=g_alk.alk930 #FUN-680019
   LET l_alh.alhlegal=g_legal #FUN-980001
   LET l_alh.alhoriu = g_user      #No.FUN-980030 10/01/04
   LET l_alh.alhorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO alh_file VALUES(l_alh.*)
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","alh_file",l_alh.alh01,"",SQLCA.sqlcode,"","ins alh:",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
   UPDATE alk_file SET alk07 = arr_no,  #MOD-960107  
                       alk37 = g_alk.alk12,
                       alk38 = g_alk.alk13,
                       alk39 = g_alk.alk16
    WHERE alk01 = g_alk.alk01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","upd alk:",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
   IF g_success='N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(2)
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(2)
   END IF
   CLOSE WINDOW t810_2   #TQC-5C0016
END FUNCTION
 
FUNCTION t810_del_apa()
   DELETE FROM apa_file WHERE apa01 = g_alk.alk01
   IF STATUS THEN
      CALL cl_err3("del","apa_file",g_alk.alk01,"",STATUS,"","del apa:",1)  #No.FUN-660122
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM apc_file WHERE apc01 = g_alk.alk01
   IF STATUS THEN
      CALL cl_err3("del","apc_file",g_alk.alk01,"",STATUS,"","del apc:",1)  
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM apb_file WHERE apb01 = g_alk.alk01
   IF STATUS THEN
      CALL cl_err3("del","apb_file",g_alk.alk01,"",STATUS,"","del apb:",1)  #No.FUN-660122
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM alh_file WHERE alh01 = g_alk.alk01
                          AND alh30 = g_alk.alk01   #MOD-630117
                          AND alh72 IS NULL         #MOD-850175 add
   IF STATUS THEN
      CALL cl_err3("del","alh_file",g_alk.alk01,"",STATUS,"","del alh:",1)  #No.FUN-660122
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t810_ins_apa()
DEFINE l_apa   RECORD LIKE apa_file.*,
       l_apc   RECORD LIKE apc_file.*,  #CHI-810016
       l_apb   RECORD LIKE apb_file.*,
       l_ale   RECORD LIKE ale_file.*,
       l_apa07 LIKE apa_file.apa07,
       l_pmn041 LIKE pmn_file.pmn041,
       l_ala22 LIKE ala_file.ala22,
       l_gen03 LIKE gen_file.gen03,
       l_pma11 LIKE pma_file.pma11,
       alk25_26  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)    #MOD-590394
DEFINE l_ale14 LIKE ale_file.ale14   #MOD-6B0127
DEFINE g_t1    LIKE oay_file.oayslip  #FUN-990014 add
DEFINE l_rvv32 LIKE rvv_file.rvv32    #MOD-D20059 add
DEFINE l_rvv33 LIKE rvv_file.rvv33    #MOD-D20059 add
DEFINE l_pmn40 LIKE pmn_file.pmn40    #MOD-D20059 add
DEFINE l_pmn401 LIKE pmn_file.pmn401  #MOD-D20059 add
 
   INITIALIZE l_apa.* TO NULL
   SELECT pmc03 INTO l_apa07 FROM pmc_file WHERE pmc01 = g_alk.alk05
   SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01 = g_alk.alk10
   SELECT ala22 INTO l_ala22 FROM ala_file WHERE ala01=g_alk.alk03
   SELECT gen03 INTO l_gen03 FROM gen_file WHERE gen01=g_alk.alkuser
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_alk.alk11
  #LET alk25_26 = g_alk.alk25 + g_alk.alk26 + g_alk.alk27    #MOD-A40072 mark
   LET alk25_26 = g_alk.alk25 + g_alk.alk26                  #MOD-A40072
   LET l_apa.apa00 = '11'
   LET l_apa.apa01 = g_alk.alk01
   LET l_apa.apa02 = g_alk.alk02
   LET l_apa.apa05 = g_alk.alk05
   LET l_apa.apa06 = g_alk.alk05
   LET l_apa.apa07 = l_apa07
  #-MOD-AA0028-add-
   IF g_alk.alk46 = 'MISC' THEN
      LET l_apa.apa08 = 'MISC'
   ELSE
      LET l_apa.apa08 = ' '            # Thomas 98/12/25
   END IF
  #-MOD-AA0028-end-
   LET l_apa.apa09 = g_alk.alk02
   LET l_apa.apa11 = g_alk.alk10
   LET l_apa.apa12 = g_alk.alk02+l_ala22  # 以立帳日當應付款日
   LET l_apa.apa13 = g_alk.alk11
   LET l_apa.apa14 = g_alk.alk12
   LET l_apa.apa72 = l_apa.apa14  #A059
   DECLARE t810_ale_cs SCROLL CURSOR FOR
      SELECT ale14 FROM ale_file,alk_file
        WHERE alk01 = ale01 AND alk01 = g_alk.alk01
          AND alkfirm <> 'X'  #CHI-C80041
   OPEN t810_ale_cs
   LET l_ale14 = ''
   FETCH FIRST t810_ale_cs INTO l_ale14
  #FUN-A60056--mod--str--
  #SELECT pmm21,pmm43 INTO l_apa.apa15,l_apa.apa16 FROM pmm_file
  #  WHERE pmm01 = l_ale14
   LET g_sql = "SELECT pmm21,pmm43 FROM ",cl_get_target_table(g_alk.alk97,'pmm_file'),
               " WHERE pmm01 = '",l_ale14,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE sel_pmm21 FROM g_sql
   EXECUTE sel_pmm21 INTO l_apa.apa15,l_apa.apa16 
  #FUN-A60056--mod--end
   IF cl_null(l_apa.apa15) THEN LET l_apa.apa15 = '' END IF
   IF cl_null(l_apa.apa16) THEN LET l_apa.apa16 = 0  END IF
   LET l_apa.apa17 = ' '
   LET l_apa.apa171= ' '
   LET l_apa.apa172= ' '
   LET l_apa.apa20 = 0
   LET l_apa.apa21 = g_alk.alkuser
  #LET l_apa.apa22 = l_gen03          #MOD-BC0246 mark
   LET l_apa.apa22 = g_alk.alk04      #MOD-BC0246
   LET l_apa.apa24 = 0
   LET l_apa.apa25 = g_alk.alk46   # Thomas 98/12/25 InvoiceNo MissD require
   SELECT ala21 INTO g_ala.ala21 FROM ala_File WHERE ala01 = g_alk.alk03
  #LET l_apa.apa31f= cl_digcut(g_alk.alk13,t_azi04)  #MOD-960269               #MOD-CC0085 mark
   LET l_apa.apa31f= cl_digcut((g_alk.alk26/g_alk.alk12)+g_alk.alk13,t_azi04)  #MOD-CC0085
   LET l_apa.apa32f = cl_digcut(g_alk.alk13*(l_apa.apa16/100),t_azi04)
   LET l_apa.apa33f= 0
   LET l_apa.apa35f= 0  # L/C, TT才是付清 OA則否   #CHI-690070
   LET l_apa.apa31 = cl_digcut(alk25_26,g_azi04)
   LET l_apa.apa32 = cl_digcut(g_alk.alk13*(l_apa.apa16/100)*g_alk.alk12,g_azi04)
   LET l_apa.apa33 = 0
   LET l_apa.apa35 = 0  # L/C, TT才是付清 OA則否   #CHI-690070
   CALL t810_comp_oox(l_apa.apa01) RETURNING g_net
   LET l_apa.apa73 = l_apa.apa34 - l_apa.apa35 + g_net      #A059
   LET l_apa.apa36 = ' '
   LET l_apa.apa41 = 'Y'
   LET l_apa.apa43 = g_alk.alk02 # GL date = alk02
   LET l_apa.apa44 = '-' # GL NO
   LET l_apa.apa51 = g_alk.alk44          #未稅科目 MOD-D20059 add
   LET l_apa.apa54 = g_alk.alk41 # 應付會計科目
   LET l_apa.apa55 = '1'   #CHI-690070
   LET l_apa.apa56 = '0'
   LET l_apa.apa57f= g_alk.alk13
   LET l_apa.apa57 = cl_digcut(alk25_26,g_azi04)   #MOD-590394
   LET l_apa.apa60f= 0
   LET l_apa.apa60 = 0
   LET l_apa.apa61f= 0
   LET l_apa.apa61 = 0
   LET l_apa.apa64 = l_apa.apa12
   LET l_apa.apa65f=cl_digcut(g_alk.alk26/g_alk.alk12,t_azi04)   #TQC-770081
   LET l_apa.apa65 =cl_digcut(g_alk.alk26,g_azi04)
   LET l_apa.apa34f= cl_digcut(l_apa.apa31f+l_apa.apa32f-l_apa.apa65f,t_azi04)   #TQC-770081
   LET l_apa.apa34= cl_digcut(l_apa.apa31+l_apa.apa32-l_apa.apa65,g_azi04)   #TQC-770081
   LET l_apa.apaacti = 'Y'
   LET l_apa.apainpd = g_today
   LET l_apa.apauser = g_user
   LET l_apa.apagrup = g_grup
   LET l_apa.apadate = g_today
   LET l_apa.apa42 = 'N'
   LET l_apa.apa74 = 'Y'    #外購付款否 L/C, TT = 'Y'  O/A = 'N'
   IF l_pma11 = '4' THEN    #OA 特別處理
      LET l_apa.apa35 = 0
      LET l_apa.apa35f= 0
      LET l_apa.apa74 = 'N'
 
   ELSE                     #當pma11 != '4'時,更新apa35f,apa35為apa34f,apa34
      IF NOT cl_null(g_alk.alk07) THEN  #MOD-B30613 
         LET l_apa.apa35 = l_apa.apa34
         LET l_apa.apa35f= l_apa.apa34f
      END IF                            #MOD-B30613
   END IF
   CALL t810_comp_oox(l_apa.apa01) RETURNING g_net
   LET l_apa.apa73 = l_apa.apa34 - l_apa.apa35 + g_net      #A059
   LET l_apa.apa75 = 'Y'
   LET l_apa.apa100 = g_alk.alk97                          #No.FUN-980017
   LET l_apa.apa930=g_alk.alk930  #FUN-670064
   LET l_apa.apaprno = 0   #MOD-830072
   LET l_apa.apa100 = g_plant      #FUN-960141 add
   LET l_apa.apalegal = g_legal  #FUN-980001 
   CALL s_get_doc_no(l_apa.apa01) RETURNING g_t1
   SELECT apyvcode INTO l_apa.apa77  FROM apy_file WHERE apyslip = g_t1   
     IF cl_null(l_apa.apa77) THEN 
        LET l_apa.apa77 = g_apz.apz63  #FUN-970108 add
     END IF     
   LET l_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
   LET l_apa.apa79 = '0'           #No.FUN-A40003     #No.FUN-A60024
  #--------------------MOD-D20059--------------(S)
    IF g_aza.aza63 = 'Y' THEN
       LET l_apa.apa511 = g_alk.alk441
    END IF
  #--------------------MOD-D20059--------------(E)
   INSERT INTO apa_file VALUES(l_apa.*)
   IF STATUS THEN
      CALL cl_err3("ins","apa_file",l_apa.apa01,"",SQLCA.sqlcode,"","p110_ins_apa(ckp#1):",1)  #No.FUN-660122
      LET g_success = 'N' RETURN
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
      LET l_apc.apclegal = g_legal  #FUN-980001 add
      INSERT INTO apc_file VALUES(l_apc.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","apc_file",l_apa.apa01,"1",SQLCA.sqlcode,"","ins apc_file",1)
         LET g_success = 'N'
      END IF
   END IF
  #FUN-A60056--mod--str--
  #DECLARE t810_ap_ins CURSOR FOR
  #  SELECT ale_file.*, pmn041
  #    FROM ale_file LEFT OUTER JOIN pmn_file ON ale_file.ale14 = pmn_file.pmn01 AND ale_file.ale15 = pmn_file.pmn02
  #   WHERE ale01 =g_alk.alk01
  #LET g_sql = "SELECT ale_file.*, pmn041 FROM ale_file ",                                               #MOD-D20059 mark
   LET g_sql = "SELECT ale_file.*, pmn041, pmn40, pmn401 FROM ale_file ",                                #MOD-D20059 add
               "  LEFT OUTER JOIN ",cl_get_target_table(g_alk.alk97,'pmn_file'),
               "    ON ale_file.ale14 = pmn_file.pmn01 AND ale_file.ale15 = pmn_file.pmn02 ",
               " WHERE ale01 ='",g_alk.alk01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE t810_ap_pre FROM g_sql
   DECLARE t810_ap_ins CURSOR FOR t810_ap_pre
  #FUN-A60056--mod--end
   FOREACH t810_ap_ins INTO l_ale.*,l_pmn041,l_pmn40,l_pmn401                        #MOD-D20059 add pmn40,pmn401
      IF STATUS THEN EXIT FOREACH END IF
      INITIALIZE l_apb.* TO NULL
      LET l_apb.apb01 = l_ale.ale01
      LET l_apb.apb02 = l_ale.ale02
      LET l_apb.apb06 = l_ale.ale14
      LET l_apb.apb07 = l_ale.ale15
      LET l_apb.apb08 = l_ale.ale08
      LET l_apb.apb09 = l_ale.ale06
      LET l_apb.apb10 = l_ale.ale09
      LET l_apb.apb081= l_apb.apb08
      LET l_apb.apb101= l_apb.apb10
      LET l_apb.apb12 = l_ale.ale11
      LET l_apb.apb13 = 0
      LET l_apb.apb13f= 0
      LET l_apb.apb14 = 0
      LET l_apb.apb14f= 0
      LET l_apb.apb15 = 0
      LET l_apb.apb21 = l_ale.ale16
      LET l_apb.apb22 = l_ale.ale17
      LET l_apb.apb23 = l_ale.ale05
      LET l_apb.apb24 = l_ale.ale07
      LET l_apb.apb27 = l_pmn041
     #-MOD-B30689-add-
     #LET g_sql = "SELECT rvv86 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),     #MOD-D20059 mark
      LET g_sql = "SELECT rvv32,rvv33,rvv86 ",                                          #MOD-D20059 add
                  "  FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),                #MOD-D20059 add
                  " WHERE rvv01='",l_ale.ale16,"'",
                  "   AND rvv02='",l_ale.ale17,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
      PREPARE sel_rvv86 FROM g_sql
     #EXECUTE sel_rvv86 INTO l_apb.apb28                              #MOD-D20059 mark
      EXECUTE sel_rvv86 INTO l_rvv32,l_rvv33,l_apb.apb28              #MOD-D20059 add
      LET l_apb.apb09 = s_digqty(l_apb.apb09,l_apb.apb28)    #FUN-BB0084 
     #-MOD-B30689-end-
      LET l_apb.apb29 = '1'
      IF g_aaz.aaz90='Y' THEN
        #FUN-A60056--mod--str--
        #SELECT rvv930 INTO l_apb.apb930 FROM rvv_file
        #                               WHERE rvv01=l_ale.ale16
        #                                 AND rvv02=l_ale.ale17
         LET g_sql = "SELECT rvv930 FROM ",cl_get_target_table(g_alk.alk97,'rvv_file'),
                     " WHERE rvv01='",l_ale.ale16,"'",
                     "   AND rvv02='",l_ale.ale17,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
         PREPARE sel_rvv930 FROM g_sql
         EXECUTE sel_rvv930 INTO l_apb.apb930
        #FUN-A60056--mod--end
         IF SQLCA.sqlcode THEN
            LET l_apb.apb930=l_ale.ale930
         ELSE
            LET l_apb.apb930=s_costcenter_stock_apb(l_apa.apa930,l_apb.apb930,l_apa.apa51)  #FUN-670064
         END IF
      END IF
      LET l_apb.apb34 = 'N'     #No.TQC-7B0083
      LET l_apb.apblegal = g_legal  #FUN-980001 add
      LET l_apb.apb37 = g_plant     #FUN-9A0093 
     #----------------------------MOD-D20059----------------------------(S)
      LET l_apb.apb25 = l_pmn40
      IF l_apa.apa51 = 'STOCK' THEN
         CALL t110_stock_act(l_apb.apb12,l_rvv32,l_rvv33,'0',l_apb.apb37)
              RETURNING l_apb.apb25
      END IF
      IF g_aza.aza63 = 'Y' THEN
         LET l_apb.apb251 = l_pmn401
         IF l_apa.apa511 = 'STOCK' THEN
            CALL t110_stock_act(l_apb.apb12,l_rvv32,l_rvv33,'1',l_apb.apb37)
                 RETURNING l_apb.apb251
         END IF
      END IF
     #----------------------------MOD-D20059----------------------------(E)
      #TQC-C10017  --Begin
      IF cl_null(l_apb.apb25) THEN LET l_apb.apb25= ' ' END IF
      IF cl_null(l_apb.apb26) THEN LET l_apb.apb26= ' ' END IF
      IF cl_null(l_apb.apb27) THEN LET l_apb.apb27= ' ' END IF
      IF cl_null(l_apb.apb31) THEN LET l_apb.apb31= ' ' END IF
      IF cl_null(l_apb.apb35) THEN LET l_apb.apb35= ' ' END IF
      IF cl_null(l_apb.apb36) THEN LET l_apb.apb36= ' ' END IF
      IF cl_null(l_apb.apb930) THEN LET l_apb.apb930= ' ' END IF
      #TQC-C10017  --End
      INSERT INTO apb_file VALUES(l_apb.*)
      IF STATUS THEN
         CALL cl_err3("ins","apb_file",l_apb.apb01,l_apb.apb02,SQLCA.sqlcode,"","p110_ins_apb(ckp#2):",1)  #No.FUN-660122
         LET g_success = 'N' EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t810_tax()
   DEFINE l_ale14 LIKE ale_file.ale14,
          l_apa16 LIKE apa_file.apa16,
          l_apa32f LIKE apa_file.apa32f
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_alk.alk11
 
   DECLARE t810_ale_cs_2 SCROLL CURSOR FOR
      SELECT ale14 FROM ale_file,alk_file
        WHERE alk01 = ale01 AND alk01 = g_alk.alk01 AND alkfirm = 'Y'
   OPEN t810_ale_cs_2
   LET l_ale14 = ''
   FETCH FIRST t810_ale_cs_2 INTO l_ale14
  #FUN-A60056--mod--str--
  #SELECT pmm43 INTO l_apa16 FROM pmm_file
  #  WHERE pmm01 = l_ale14
   LET g_sql = "SELECT pmm43 FROM ",cl_get_target_table(g_alk.alk97,'pmm_file'),
               " WHERE pmm01 = '",l_ale14,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_alk.alk97) RETURNING g_sql
   PREPARE sel_pmm43 FROM g_sql
   EXECUTE sel_pmm43 INTO l_apa16
  #FUN-A60056--mod--end
   IF cl_null(l_apa16) THEN LET l_apa16 = 0 END IF
   LET l_apa32f = cl_digcut(g_alk.alk13*(l_apa16/100)*g_alk.alk12,t_azi04)
   DISPLAY l_apa32f TO FORMONLY.tax
END FUNCTION
 
 
FUNCTION t810_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    CALL cl_set_comp_entry("alk16",TRUE)   #TQC-5C0028
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("alk01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t810_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("alk01",FALSE)
    END IF
   IF INFIELD (alk16) THEN
      CALL cl_set_comp_entry("alk16",FALSE)
   END IF
END FUNCTION
 
FUNCTION t810_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF INFIELD(ale11) THEN
      CALL cl_set_comp_entry("ale13,ale131,ale05",TRUE)  #No.FUN-680029
    END IF
    CALL cl_set_comp_entry("ale81,ale83,ale84,ale85,ale87",TRUE)
 
END FUNCTION
 
FUNCTION t810_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF INFIELD(ale11) THEN
       IF g_ale[l_ac].ale11[1,4] != 'MISC' THEN
          CALL cl_set_comp_entry("ale13,ale131,ale05",FALSE)  #No.FUN-680029
       END IF
    END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("ale83,ale84,ale85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("ale83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("ale84,ale81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("ale87",FALSE)
   END IF
END FUNCTION
 
FUNCTION t810_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("ale83,ale85,ale80,ale82",FALSE)
      CALL cl_set_comp_visible("ale06",TRUE)
   ELSE
      CALL cl_set_comp_visible("ale83,ale84,ale85,ale80,ale81,ale82",TRUE)
      CALL cl_set_comp_visible("ale06",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("ale86,ale87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("ale84,ale81",FALSE)
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ale82",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("ale930,gem02",g_aaz.aaz90='Y')
END FUNCTION
 
FUNCTION t810_set_required()
   IF g_sma.sma115 = 'Y' THEN
       #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
       IF g_ima906 = '3' THEN
            CALL cl_set_comp_required("ale83,ale85,ale80,ale82",TRUE)
       END IF
       #單位不同,轉換率,數量必KEY
       IF NOT cl_null(g_ale[l_ac].ale80) THEN
          CALL cl_set_comp_required("ale82",TRUE)
       END IF
       IF NOT cl_null(g_ale[l_ac].ale83) THEN
          CALL cl_set_comp_required("ale85",TRUE)
       END IF
       IF g_sma.sma116 NOT MATCHES '[02]' THEN
            IF NOT cl_null(g_ale[l_ac].ale86) THEN
                CALL cl_set_comp_required("ale87",TRUE)
            END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t810_set_no_required()
  CALL cl_set_comp_required("ale83,ale84,ale85,ale80,ale81,ale82,ale86,ale87",FALSE)
END FUNCTION
 
#default 雙單位/轉換率/數量
FUNCTION t810_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima31  LIKE ima_file.ima31,
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
            p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_ale[l_ac].ale11
    SELECT ima44,ima31,ima906,ima907,ima908
      INTO l_ima44,l_ima31,l_ima906,l_ima907,l_ima908
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
 
    IF p_cmd = 'a' THEN
       LET g_ale[l_ac].ale83=l_unit2
       LET g_ale[l_ac].ale84=l_fac2
       LET g_ale[l_ac].ale85=l_qty2
       LET g_ale[l_ac].ale80=l_unit1
       LET g_ale[l_ac].ale81=l_fac1
       LET g_ale[l_ac].ale82=l_qty1
       LET g_ale[l_ac].ale86=l_unit3
       LET g_ale[l_ac].ale87=l_qty3
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t810_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor LIKE ima_file.ima31_fac,  
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_ale[l_ac].ale11
    IF SQLCA.sqlcode = 100 THEN
       IF g_ale[l_ac].ale11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_ale[l_ac].ale84
    LET l_qty2=g_ale[l_ac].ale85
    LET l_fac1=g_ale[l_ac].ale81
    LET l_qty1=g_ale[l_ac].ale82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_ale[l_ac].ale86=g_ale[l_ac].ale80
                   LET g_ale[l_ac].ale06=l_qty1   #MOD-820158
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ale[l_ac].ale86=l_ima44
                   LET g_ale[l_ac].ale06=l_tot   #MOD-820158
                   LET g_ale[l_ac].ale06=s_digqty(g_ale[l_ac].ale06,g_ale[l_ac].ale86)  #FUN-BB0086 add
          WHEN '3' LET g_ale[l_ac].ale86=g_ale[l_ac].ale80
                   LET g_ale[l_ac].ale06=l_qty1   #MOD-820158
                   IF l_qty2 <> 0 THEN
                      LET g_ale[l_ac].ale84=l_qty1/l_qty2
                   ELSE
                      LET g_ale[l_ac].ale84=0
                   END IF
       END CASE
    END IF
 
    LET g_factor = 1
    CALL s_umfchk(g_ale[l_ac].ale11,g_ale[l_ac].ale86,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
       LET g_ale[l_ac].ale87 = g_ale[l_ac].ale07
    END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t810_du_data_to_correct()
   IF cl_null(g_ale[l_ac].ale80) THEN
      LET g_ale[l_ac].ale81 = NULL
      LET g_ale[l_ac].ale82 = NULL
   END IF
 
   IF cl_null(g_ale[l_ac].ale83) THEN
      LET g_ale[l_ac].ale84 = NULL
      LET g_ale[l_ac].ale85 = NULL
   END IF
 
   IF cl_null(g_ale[l_ac].ale86) THEN
      LET g_ale[l_ac].ale87 = NULL
   END IF
   DISPLAY BY NAME g_ale[l_ac].ale81
   DISPLAY BY NAME g_ale[l_ac].ale82
   DISPLAY BY NAME g_ale[l_ac].ale84
   DISPLAY BY NAME g_ale[l_ac].ale85
   DISPLAY BY NAME g_ale[l_ac].ale86
   DISPLAY BY NAME g_ale[l_ac].ale87
 
END FUNCTION
 
FUNCTION t810_set_ale87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor  LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_ale[l_ac].ale11
 
    IF SQLCA.sqlcode =100 THEN
       IF g_ale[l_ac].ale11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_ale[l_ac].ale84
       LET l_qty2=g_ale[l_ac].ale85
       LET l_fac1=g_ale[l_ac].ale81
       LET l_qty1=g_ale[l_ac].ale82
    ELSE
       LET l_fac1=g_ale[l_ac].ale86
       LET l_qty1=g_ale[l_ac].ale07
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
    CALL s_umfchk(g_ale[l_ac].ale11,l_ima44,g_ale[l_ac].ale86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_ale[l_ac].ale87 = l_tot
    LET g_ale[l_ac].ale87 = s_digqty(g_ale[l_ac].ale87,g_ale[l_ac].ale86) #FUN-BB0086 add
END FUNCTION
 
FUNCTION t810_set_du_by_origin(p_code)
  DEFINE l_ima44    LIKE ima_file.ima44,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_ale11    LIKE ale_file.ale11,
         l_factor   LIKE ima_file.ima31_fac,  #No.FUN-680136  DECIMAL(16,8),
         p_code     LIKE type_file.chr1       #No.FUN-680136  VARCHAR(01)
 
    LET l_ale11 = g_ale[l_ac].ale11
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_ale11
 
    IF cl_null(g_ale[l_ac].ale80) THEN
       LET g_ale[l_ac].ale80 = g_ale[l_ac].ale86
       LET g_ale[l_ac].ale82 = g_ale[l_ac].ale07
    END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET g_ale[l_ac].ale83 = NULL
       LET g_ale[l_ac].ale84 = NULL
       LET g_ale[l_ac].ale85 = NULL
    ELSE
       IF cl_null(g_ale[l_ac].ale83) THEN
          LET g_ale[l_ac].ale83 = l_ima907
          CALL s_du_umfchk(l_ale11,'','','',g_ale[l_ac].ale86,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET g_ale[l_ac].ale84 = l_factor
          LET g_ale[l_ac].ale85 = 0
       END IF
    END IF
    IF cl_null(g_ale[l_ac].ale86) THEN
       LET g_ale[l_ac].ale86 = g_ale[l_ac].ale86
       LET g_ale[l_ac].ale87 = g_ale[l_ac].ale07
    END IF
END FUNCTION
 
FUNCTION t810_comp_oox(p_apv03)
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
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION t810_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE g_t1         LIKE oay_file.oayslip  #No.FUN-690028 VARCHAR(5)
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    #LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new    #FUN-A50102
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alk.alk72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_alk.alk72,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl = g_apz.apz02p   #No.FUN-980059
 
    OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
     
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
    CALL cl_set_head_visible("","YES") #No.FUN-6B0033
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029
    
       AFTER FIELD gl_no
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)      #TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
 
       AFTER FIELD gl_no1
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
                RETURNING li_result,l_apygslp1
          IF (NOT li_result) THEN
             NEXT FIELD gl_no1
          END IF
    
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT 
          END IF
          IF cl_null(l_apygslp) THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no  
          END IF
 
          IF cl_null(l_apygslp1) AND g_aza.aza63 = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no1 
          END IF
    
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION CONTROLP
          IF INFIELD(gl_no) THEN
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp,'1',' ',' ','AGL')   #No.FUN-980059
             RETURNING l_apygslp
             DISPLAY l_apygslp TO FORMONLY.gl_no
             NEXT FIELD gl_no
          END IF
 
          IF INFIELD(gl_no1) THEN
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1',' ',' ','AGL') #No.FUN-980059
             RETURNING l_apygslp1
             DISPLAY l_apygslp1 TO FORMONLY.gl_no1
             NEXT FIELD gl_no1
          END IF
    
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
    CLOSE WINDOW t200p  
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_alk.alk01,'axr-070',1)
       RETURN
    END IF
    CALL s_get_doc_no(l_apygslp) RETURNING g_t1
    LET g_wc_gl = 'npp01 = "',g_alk.alk01,'" AND npp011 = 1'
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '3' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_alk.alk02,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT alk72 INTO g_alk.alk72 FROM alk_file
     WHERE alk01 = g_alk.alk01
    DISPLAY BY NAME g_alk.alk72
    
END FUNCTION
 
FUNCTION t810_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF 
 
    #LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alk.alk72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_alk.alk72,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_alk.alk72,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT alk72 INTO g_alk.alk72 FROM alk_file
     WHERE alk01 = g_alk.alk01
    DISPLAY BY NAME g_alk.alk72
END FUNCTION
 
FUNCTION t810_set_npq05(p_dept,p_ale930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ale930 LIKE ale_file.ale930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ale930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
 
FUNCTION t810_ddd()
   DEFINE l_depno                 LIKE type_file.chr10,      #CHAR(10),
          l_rec_b                 LIKE type_file.num5,       #SMALLINT,
          l_tot1, l_tot2, l_tot3  LIKE apa_file.apa31,
          l_totf1,l_totf2,l_totf3 LIKE apa_file.apa31f,
          l_tot28,l_tot28f        LIKE apk_file.apk28,
          i,j,k,u_sign            LIKE type_file.num5,       #SMALLINT,
          l_n,l_nochk             LIKE type_file.num5,       #SMALLINT,
          apk03_t                 LIKE apk_file.apk03,
          l_tax                   LIKE type_file.num20_6,    #DEC(20,6),  #FUN-4B0079
          l_flag1,l_flag          LIKE type_file.chr1,       #CHAR(01),
          l_flag2                 LIKE type_file.chr1,       #CHAR(01),   #MOD-620048
          l_del                   LIKE type_file.chr1,       #CHAR(01),
          l_amb01,l_amb02         LIKE type_file.num5,       #SMALLINT,
          l_amb03                 LIKE type_file.chr2,       #CHAR(02),
          l_chk                   LIKE type_file.chr1,       #CHAR(1),
          l_ans                   LIKE type_file.chr1,       #CHAR(01),
          l_ans1,l_opensw         LIKE type_file.chr1,       #CHAR(01),           #85-09-23
          l_apa31                 LIKE apa_file.apa31,
          l_apa31f                LIKE apa_file.apa31f,
          l_apa32                 LIKE apa_file.apa32,
          l_apa32f                LIKE apa_file.apa32f,
          l_apa34f                LIKE apa_file.apa34f,
          l_apa34                 LIKE apa_file.apa34,
          l_apk29                 LIKE apk_file.apk29,
          l_azi04                 LIKE azi_file.azi04,
          l_azi07                 LIKE azi_file.azi07,   #MOD-870330 add
          apk11_t                 LIKE apk_file.apk11,
          apk08_t                 LIKE apk_file.apk08,
          apk08f_t                LIKE apk_file.apk08f,
          l_allow_insert          LIKE type_file.num5,   #SMALLINT,  #可新增否
          l_allow_delete          LIKE type_file.num5,   #SMALLINT,  #可刪除否
          l_apk173                LIKE apk_file.apk173,  #FUN-720018 add
          l_apk174                LIKE apk_file.apk174   #FUN-720018 add
DEFINE    l_apk32                 LIKE apk_file.apk32    #FUN-990014 add          
DEFINE    g_t1                    LIKE oay_file.oayslip  #FUN-990014 add
DEFINE    l_pmc24                 LIKE pmc_file.pmc24    #MOD-A90085 
DEFINE    l_pmc47                 LIKE pmc_file.pmc47    #MOD-A90085 
 
   IF g_alk.alk46 != 'MISC' OR cl_null(g_alk.alk46) THEN
      RETURN
   END IF
 
   OPEN WINDOW t110_ddd_w AT 7,2
     WITH FORM "aap/42f/aapt110_d"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aapt110_d")
 
 
   DECLARE t110_ddd_c CURSOR FOR SELECT apk02,apk11,apk171,apk17,apk172,
                                        apk05,apk03,apk04,apk12,apk13,   
                                        apk08f,apk07f,apk06f,apk08,apk07,apk06,apk32    #MOD-A90085 add apk32
                                   FROM apk_file
                                  WHERE apk01 = g_alk.alk01
                                  ORDER BY apk02
 
   CALL g_apk.clear()    
   LET k = 1
   LET l_tot1 = 0
   LET l_tot2 = 0
   LET l_tot3 = 0
   LET i = 1
   LET l_tot28 = 0
   LET l_opensw = 'N'
 
  #FOREACH t110_ddd_c INTO i,g_apk[k].*     #MOD-A90085 mark
   FOREACH t110_ddd_c INTO g_apk[k].*       #MOD-A90085
      IF g_apk[k].apk171 = '23' THEN
         LET u_sign = -1
      ELSE
         LET u_sign = 1
      END IF
 
      IF g_apk[k].apk171 = '28' OR g_apk[k].apk171 = '29' THEN
         LET l_tot28 = l_tot28 + g_apk[k].apk08 * u_sign
         LET l_tot2 = l_tot2 + g_apk[k].apk07 * u_sign
      ELSE
         LET l_tot1 = l_tot1 + g_apk[k].apk08 * u_sign
         LET l_tot2 = l_tot2 + g_apk[k].apk07 * u_sign
         LET l_tot3 = (l_tot1 + l_tot2)  
      END IF
 
      IF cl_null(g_apk[k].apk03) THEN
         LET g_apk[k].apk03 = ' '
      END IF   
 
      LET k = k + 1
 
       IF k > g_max_rec THEN  
         EXIT FOREACH
       END IF
   END FOREACH
 
   CALL g_apk.deleteElement(k)
   LET l_rec_b  = k - 1
 
   DISPLAY BY NAME l_tot28,l_tot1,l_tot2,l_tot3
  #-MOD-A90085-add-
   SELECT pmc24,pmc47 INTO l_pmc24,l_pmc47
     FROM pmc_file
    WHERE pmc01 = g_alk.alk05
  #-MOD-A90085-end-
 
   IF g_alk.alkfirm = 'Y' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      DISPLAY ARRAY g_apk TO s_apk.*  ATTRIBUTE(COUNT=l_rec_b)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION about                    
            CALL cl_about()                 
 
         ON ACTION help                     
            CALL cl_show_help()             
 
         ON ACTION controlg                 
            CALL cl_cmdask()                
 
      END DISPLAY
 
      IF INT_FLAG THEN   
         LET INT_FLAG = 0  
         CLOSE WINDOW t110_ddd_w
         RETURN
      END IF   
 
   ELSE
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_apk WITHOUT DEFAULTS FROM s_apk.*
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
            LET l_del='N'
 
         BEFORE ROW
            LET i = ARR_CURR()
            LET j = SCR_LINE()
            LET apk03_t = g_apk[i].apk03
            LET apk11_t = g_apk[i].apk11
 
            #No.5945 稅率用多發票apk29的稅率不用apa16
            SELECT apk29 INTO l_apk29 FROM apk_file
             WHERE apk01 = g_alk.alk01
           #   AND apk02 = i                #MOD-A90085 mark
               AND apk02 = g_apk[i].apk02   #MOD-A90085
               AND apk03 = g_apk[i].apk03
 
            IF cl_null(l_apk29) THEN
               LET l_apk29 = 0
            END IF
 
            SELECT azi04,azi07 INTO l_azi04,l_azi07   #MOD-870330 add azi07
              FROM azi_file
             WHERE azi01 = g_apk[i].apk12
               AND aziacti = 'Y'
 
            IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF
            IF cl_null(l_azi07) THEN LET l_azi07 = 0 END IF   #MOD-870330 add
 
            IF l_del = 'Y' THEN
               LET l_del = 'N'
               CALL cl_show_fld_cont()    
              #NEXT FIELD apk11             #MOD-A90085 mark
            END IF
 
            IF g_apk[i].apk02 IS NULL THEN  #MOD-A90085 mod apk11->apk02
               CALL cl_show_fld_cont()   
               NEXT FIELD apk02             #MOD-A90085 mod apk11->apk02
            END IF
 
            CALL t810_set_entry_apk()
            IF g_apk[i].apk171 = '28' OR g_apk[i].apk171 = '29' THEN
               LET g_apk[i].apk12 = g_aza.aza17  
               LET g_apk[i].apk13 = 1
               CALL t810_set_no_entry_apk()
            END IF
        #-MOD-A90085-add-
         BEFORE FIELD apk02
           IF g_apk[i].apk06 IS NULL THEN
              INITIALIZE g_apk[i].* TO NULL
              IF g_apk[i].apk02 IS NULL OR g_apk[i].apk02 = 0 THEN
                 SELECT MAX(apk02)+1 INTO g_apk[i].apk02 FROM apk_file
                  WHERE apk01 = g_alk.alk01 
                 IF g_apk[i].apk02 IS NULL THEN
                    LET g_apk[i].apk02 = 1
                 END IF
              END IF
              IF i = 1 THEN
                 LET g_apk[i].apk04 = l_pmc24 
                 LET g_apk[i].apk11 = l_pmc47 
                 LET g_apk[i].apk12 = g_alk.alk11
                 LET g_apk[i].apk13 = g_alk.alk12
                 LET g_apk[i].apk06f= 0
                 LET g_apk[i].apk07f= 0
                 LET g_apk[i].apk08f= 0
                 LET g_apk[i].apk06 = 0
                 LET g_apk[i].apk07 = 0
                 LET g_apk[i].apk08 = 0
                 LET g_apk[i].apk32 = g_apz.apz63  
              END IF
              IF i > 1 THEN
                 LET g_apk[i].apk04  = g_apk[i-1].apk04
                 LET g_apk[i].apk05  = g_apk[i-1].apk05
                 LET g_apk[i].apk11  = g_apk[i-1].apk11
                 LET g_apk[i].apk12  = g_apk[i-1].apk12
                 LET g_apk[i].apk13  = g_apk[i-1].apk13
                 LET g_apk[i].apk171 = g_apk[i-1].apk171
                 LET g_apk[i].apk17  = g_apk[i-1].apk17
                 LET g_apk[i].apk172 = g_apk[i-1].apk172
                 LET g_apk[i].apk32  = g_apk[i-1].apk32  
                 LET g_apk[i].apk06f = 0
                 LET g_apk[i].apk07f = 0
                 LET g_apk[i].apk08f = 0
                 LET g_apk[i].apk06  = 0
                 LET g_apk[i].apk07  = 0
                 LET g_apk[i].apk08  = 0
              END IF
              IF g_apk[i].apk171 = 'XX' THEN
                 LET g_apk[i].apk03 = ' '
              END IF
           END IF

         AFTER FIELD apk02
           IF cl_null(g_apk[i].apk02) THEN 
              CALL cl_err('','aqc-052',0)          
              NEXT FIELD apk02
           ELSE
              #檢查項次是否存在
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM apk_file 
               WHERE apk01 = g_apa.apa01 
                 AND apk02 = g_apk[i].apk02
              IF l_n > 0 THEN 
                 CALL cl_err(g_apk[i].apk02,'asf-406',0)
                 NEXT FIELD apk02
              END IF 
           END IF 
        #-MOD-A90085-end-
        #-MOD-A90085-mark-
        #BEFORE FIELD apk11
        #   IF g_apk[i].apk06 IS NULL THEN
        #      INITIALIZE g_apk[i].* TO NULL
        #      IF i = 1 THEN
        #         IF l_flag2 = 'Y' THEN
        #            LET l_flag2 = 'N'
        #         ELSE
        #            LET g_apk[i].apk04 = ''              
        #            LET g_apk[i].apk11 = ''
        #            LET g_apk[i].apk12 = g_alk.alk11
        #            LET g_apk[i].apk13 = g_alk.alk12
        #            LET g_apk[i].apk06f= 0
        #            LET g_apk[i].apk07f= 0
        #            LET g_apk[i].apk08f= 0
        #            LET g_apk[i].apk06 = 0
        #            LET g_apk[i].apk07 = 0
        #            LET g_apk[i].apk08 = 0
        #         END IF
        #      END IF
        #      IF i > 1 THEN
        #         LET g_apk[i].apk04  = g_apk[i-1].apk04
        #         LET g_apk[i].apk05  = g_apk[i-1].apk05
        #         LET g_apk[i].apk11  = g_apk[i-1].apk11
        #         LET g_apk[i].apk12  = g_apk[i-1].apk12
        #         LET g_apk[i].apk13  = g_apk[i-1].apk13
        #         LET g_apk[i].apk171 = g_apk[i-1].apk171
        #         LET g_apk[i].apk17  = g_apk[i-1].apk17
        #         LET g_apk[i].apk172 = g_apk[i-1].apk172
        #         LET g_apk[i].apk06f= 0
        #         LET g_apk[i].apk07f= 0
        #         LET g_apk[i].apk08f= 0
        #         LET g_apk[i].apk06 = 0
        #         LET g_apk[i].apk07 = 0
        #         LET g_apk[i].apk08 = 0
        #      END IF
        #   END IF
        #-MOD-A90085-end-
 
         AFTER FIELD apk11
            IF NOT cl_null(g_apk[i].apk11) THEN
               IF cl_null(apk11_t) OR g_apk[i].apk11 != apk11_t THEN
                  SELECT gec04,gec06,gec08
                    INTO l_apk29,g_apk[i].apk172,g_apk[i].apk171
                    FROM gec_file
                   WHERE gec01 = g_apk[i].apk11 AND gec011='1'  #進項
                     AND gecacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gec_file", g_apk[i].apk11,"","mfg3044","","",1)  
                     NEXT FIELD apk11
                  END IF
                  DISPLAY g_apk[i].apk171,g_apk[i].apk172 TO apk171,apk172   #MOD-A90085
                 #------------------MOD-D40211-----------------(S)
                  IF g_apk[i].apk172 = '3' THEN
                     LET g_apk[i].apk17 = '3'
                     DISPLAY g_apk[i].apk17
                  END IF
                 #------------------MOD-D40211-----------------(E)
                  IF NOT cl_null(g_apk[i].apk08f) THEN
                     LET g_apk[i].apk08f = cl_digcut(g_apk[i].apk08f,l_azi04)
                     LET g_apk[i].apk07f = g_apk[i].apk08f * l_apk29 / 100
                     LET g_apk[i].apk07f = cl_digcut(g_apk[i].apk07f,l_azi04)
                     LET g_apk[i].apk06f = g_apk[i].apk08f + g_apk[i].apk07f
                     LET g_apk[i].apk06f = cl_digcut(g_apk[i].apk06f,l_azi04)
                     LET g_apk[i].apk08  = g_apk[i].apk08f * g_apk[i].apk13
                     LET g_apk[i].apk08  = cl_digcut(g_apk[i].apk08,g_azi04)
                     LET g_apk[i].apk07  = g_apk[i].apk07f * g_apk[i].apk13
                     LET g_apk[i].apk07  = cl_digcut(g_apk[i].apk07,g_azi04)
                     LET g_apk[i].apk06  = g_apk[i].apk08 + g_apk[i].apk07
                     LET g_apk[i].apk06  = cl_digcut(g_apk[i].apk06,g_azi04)
                  END IF
               END IF
             END IF
 
             CALL t810_set_entry_apk()
             IF g_apk[i].apk171 = '28' OR g_apk[i].apk171 = '29' THEN
                LET g_apk[i].apk12 = g_aza.aza17  
                LET g_apk[i].apk13 = 1
                CALL t810_set_no_entry_apk()
             END IF
 
         AFTER FIELD apk03
            IF NOT cl_null(g_apk[i].apk03) AND
               (apk03_t IS NULL OR g_apk[i].apk03 != apk03_t) THEN
               LET g_errno = ''   
 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD apk03
               END IF
               
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD apk03
               END IF
               LET g_errno = ''
               LET g_errno = ''
               IF i > 1 THEN
                  CALL t810_duplicate(' ',g_apk[i].apk03,i-1)
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('duplicate:',g_errno,0)
                  INITIALIZE g_apk[i].* TO NULL
                  NEXT FIELD apk03
               END IF
 
               LET l_nochk = LENGTH(g_apk[i].apk03)
               IF g_apk[i].apk171 = '28' OR g_apk[i].apk171 = '29' THEN
                  IF l_nochk != 14 THEN
                     CALL cl_err(g_apk[i].apk03,'amd-009',0)
                     NEXT FIELD apk03
                  END IF
                  LET l_chk = 'N'
               ELSE
                  IF NOT cl_null(g_apk[i].apk03) THEN
                     IF g_apk[i].apk171 != 'XX' AND g_apk[i].apk171 != '22' THEN  
                        IF l_nochk != 10 THEN
                            CALL cl_err(g_apk[i].apk03,'amd-010',0)
                            NEXT FIELD apk03
                         END IF
                     END IF
                  END IF
               END IF
            END IF
 
            IF l_flag1='Y' THEN
               LET l_amb01=YEAR(g_apk[i].apk05)
               LET l_amb02=MONTH(g_apk[i].apk05)
               LET l_amb03=g_apk[i].apk03[1,2]
               CALL s_apkchk(l_amb01,l_amb02,l_amb03,g_apk[i].apk171)
                      RETURNING g_errno,g_msg
               IF NOT cl_null(g_msg) THEN
                  CALL cl_getmsg(g_msg,g_lang) RETURNING g_msg
                  ERROR g_msg,' invoice =',g_apk[i].apk03,
                              ' SQLCODE=',g_errno
                   IF cl_confirm('aap-766') THEN   
                     IF g_errno='1' OR g_errno='2'  THEN
                        NEXT FIELD apk05
                     ELSE
                        IF g_errno='3'  THEN
                           NEXT FIELD apk03
                        ELSE
                           NEXT FIELD apk171
                        END IF
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD apk171
               IF g_apk[i].apk171 != '21' AND g_apk[i].apk171 != '22' AND
                  g_apk[i].apk171 != '23' AND g_apk[i].apk171 != '24' AND
                  g_apk[i].apk171 != '25' AND g_apk[i].apk171 != 'XX' AND
                  g_apk[i].apk171 != '26' AND g_apk[i].apk171 != '27' AND
                  g_apk[i].apk171 != '28' AND g_apk[i].apk171 != '29' THEN
                  CALL cl_err(g_apk[i].apk171,'amd-006',0)
                  NEXT FIELD apk171
               END IF
 
               #--- modify by apple 98/06/19-(格式22)無發票號碼不檢查字軌--
               LET l_chk = 'Y'
               IF g_apk[i].apk171 = '22' AND cl_null(g_apk[i].apk03) THEN
                  LET l_chk = 'N'
               END IF
               IF g_apk[i].apk171 = 'XX' THEN
                  LET l_chk = 'N'
               END IF
 
               IF g_apk[i].apk171 = '28' OR g_apk[i].apk171 ='29' THEN
                  LET g_apk[i].apk12 = g_aza.aza17  
                  LET g_apk[i].apk13 = 1
               END IF
 
         AFTER FIELD apk17
            IF NOT cl_null(g_apk[i].apk17) THEN
               IF g_apk[i].apk17 <>' ' AND g_apk[i].apk17 NOT MATCHES '[1234]' THEN   
                  NEXT FIELD apk17
               END IF
              #------------------MOD-D40211-----------------(S)
               IF g_apk[i].apk172 = '3' AND g_apk[i].apk17 <> '3' THEN
                  CALL cl_err('','afa-135',0)
                  LET g_apk[i].apk17 = '3'
                  DISPLAY g_apk[i].apk17
                  NEXT FIELD apk17
               END IF
              #------------------MOD-D40211-----------------(E)
               IF g_apk[i].apk17 MATCHES '[1234]'  THEN    
                  LET l_flag1='Y'
                  IF g_apk[i].apk171='22' THEN
                     IF (g_apk[i].apk03 IS NULL OR g_apk[i].apk03=' ' ) THEN
                        LET l_flag1='N'
                     ELSE
                       IF g_apk[i].apk03[1,1] MATCHES '[A-Z]' AND
                          g_apk[i].apk03[2,2] MATCHES '[A-Z]' AND
                          g_apk[i].apk03[3,3] MATCHES '[0-9]' AND
                          g_apk[i].apk03[4,4] MATCHES '[0-9]' AND
                          g_apk[i].apk03[10,10] MATCHES '[0-9]' THEN
                          LET l_flag1='Y'
                       ELSE
                          LET l_flag1='N'
                       END IF
                     END IF
                  END IF
 
                  #BUGNO4197不檢查字軌,no:7393
                  IF g_apk[i].apk171 = '28' OR g_apk[i].apk171='29' THEN
                     LET l_flag1='N'
                  END IF
                  IF g_apk[i].apk171 = 'XX' THEN
                     LET l_flag1='N'
                  END IF
               END IF
            END IF
 
         AFTER FIELD apk172
            IF NOT cl_null(g_apk[i].apk172) THEN
               IF g_apk[i].apk172 NOT MATCHES '[123]' THEN
                  CALL cl_err(g_apk[i].apk172,'amd-007',0)
                  NEXT FIELD apk172
               END IF
               IF g_apk[i].apk172 = '1' THEN
                  SELECT gec04        
                    INTO l_apk29
                    FROM gec_file
                   WHERE gec01 = g_apk[i].apk11 AND gec011='1'  #進項
                     AND gecacti = 'Y'
                  LET l_tax=g_apk[i].apk08* l_apk29 / 100
                  LET l_tax=cl_digcut(l_tax,l_azi04)     
                  IF g_apk[i].apk07 !=l_tax THEN
                     CALL cl_err(g_apk[i].apk171,'aap-757',0)
                     IF (g_apk[i].apk07 > l_tax+2) OR (g_apk[i].apk07<l_tax-2)  THEN
                        CALL cl_err(g_apk[i].apk171,'mfg-033',0)
                        NEXT FIELD apk08
                     END IF
                  END IF
                  LET l_tax=cl_digcut(l_tax,l_azi04)
               ELSE
                  LET l_tax=0
               END IF
              #------------------MOD-D40211-----------------(S)
               IF g_apk[i].apk172 = '3' THEN
                  LET g_apk[i].apk17 = '3'
                  DISPLAY g_apk[i].apk17
               END IF
              #------------------MOD-D40211-----------------(E)
            END IF
 
         AFTER FIELD apk04  #廠商統一編號
           IF NOT cl_null(g_apk[i].apk04) THEN
             #apz14 是否檢查營利事業統一編號
              IF (g_apz.apz14 = 'Y' OR g_aza.aza21 = 'Y')   #FUN-990053 mod #MOD-B60248 add ()
                 AND NOT s_chkban(g_apk[i].apk04) THEN  
                 CALL cl_err('','aoo-080',0) NEXT FIELD apk04
              END IF
 
              IF g_alk.alk05='MISC' THEN
                 CALL t810_input_apl(g_apk[i].apk04)
              END IF
           ELSE
              IF g_alk.alk05='MISC' THEN
                 NEXT FIELD apk04
              END IF
           END IF
 
         AFTER FIELD apk12
            IF NOT cl_null(g_apk[i].apk12) THEN
               SELECT azi04,azi07 INTO l_azi04,l_azi07   #MOD-870330 add azi07
                 FROM azi_file
                WHERE azi01 = g_apk[i].apk12 AND aziacti = 'Y'
               IF STATUS THEN
                  CALL cl_err3("sel","azi_file",g_apk[i].apk12,"","aap-002","","",1)  
                  NEXT FIELD apk12
               ELSE
                  CALL s_curr3(g_apk[i].apk12,g_alk.alk02,g_apz.apz33)  
                       RETURNING g_apk[i].apk13
                  IF g_apk[i].apk12 = g_aza.aza17 THEN
                     LET g_apk[i].apk13 = 1
                  END IF
                  LET g_apk[i].apk13 = cl_digcut(g_apk[i].apk13,l_azi07)   #MOD-870330 add
                  DISPLAY BY NAME g_apk[i].apk13                           #MOD-870330 add
               END IF
               IF g_apk[i].apk171 = '28' OR g_apk[i].apk171='29' THEN
                  IF g_apk[i].apk12 <> g_aza.aza17 THEN
                     CALL cl_err('','aap-905',1)
                     NEXT FIELD apk12
                  END IF
                  LET g_apk[i].apk12 = g_aza.aza17
                  LET g_apk[i].apk13 = 1
               END IF
            END IF
 
         AFTER FIELD apk13
            IF NOT cl_null(g_apk[i].apk13) THEN
               LET g_apk[i].apk13 = cl_digcut(g_apk[i].apk13,l_azi07)
               DISPLAY BY NAME g_apk[i].apk13
            END IF
 
         BEFORE FIELD apk08f
            LET apk08f_t = g_apk[i].apk08f
 
         AFTER FIELD apk08f
            IF NOT cl_null(g_apk[i].apk08f) THEN
               IF g_apk[i].apk08f <= 0 THEN
                  NEXT FIELD apk08f
               END IF
               IF g_apk[i].apk172='1' THEN
                  LET l_tax = g_apk[i].apk08f * (l_apk29/100)
               ELSE
                  LET l_tax = 0
               END IF
               IF apk08f_t IS NULL OR apk08f_t<>g_apk[i].apk08f THEN
                  LET g_apk[i].apk07f = cl_digcut(l_tax,l_azi04)
                  LET g_apk[i].apk08  = g_apk[i].apk08f * g_apk[i].apk13
                  LET g_apk[i].apk07  = g_apk[i].apk07f * g_apk[i].apk13
                  LET g_apk[i].apk06  = g_apk[i].apk08  + g_apk[i].apk07
                  LET g_apk[i].apk08  = cl_digcut(g_apk[i].apk08,g_azi04)
                  LET g_apk[i].apk07  = cl_digcut(g_apk[i].apk07,g_azi04)
                  LET g_apk[i].apk06  = cl_digcut(g_apk[i].apk06,g_azi04)
               END IF
               LET g_apk[i].apk06f = g_apk[i].apk08f + g_apk[i].apk07f
               LET g_apk[i].apk06f = cl_digcut(g_apk[i].apk06f,l_azi04)
               LET g_apk[i].apk08f = cl_digcut(g_apk[i].apk08f,l_azi04)
            END IF
 
         AFTER FIELD apk07f
            IF NOT cl_null(g_apk[i].apk07f) THEN
               IF g_apk[i].apk172='1' THEN
                  LET l_tax = g_apk[i].apk08f*l_apk29/100
                  LET l_tax = cl_digcut(l_tax,l_azi04)
                  IF g_apk[i].apk07f !=l_tax THEN
                     CALL cl_err(g_apk[i].apk171,'aap-757',0)
                     IF (g_apk[i].apk07f > l_tax+2) OR (g_apk[i].apk07f<l_tax-2) THEN
                        CALL cl_err(g_apk[i].apk171,'mfg-033',0)
                        NEXT FIELD apk07f
                     END IF
                  END IF
               END IF
               IF g_apk[i].apk07f > 0 AND l_apk29 = 0 THEN
                  CALL cl_err('','aap-902',1)
                  NEXT FIELD apk07f
               END IF
               LET g_apk[i].apk06f = g_apk[i].apk08f + g_apk[i].apk07f
               LET g_apk[i].apk06f = cl_digcut(g_apk[i].apk06f,l_azi04)
               LET g_apk[i].apk07f = cl_digcut(g_apk[i].apk07f,l_azi04)
               LET g_apk[i].apk07  = g_apk[i].apk07f * g_apk[i].apk13
               LET g_apk[i].apk06  = g_apk[i].apk08  + g_apk[i].apk07
               LET g_apk[i].apk07  = cl_digcut(g_apk[i].apk07,g_azi04)
               LET g_apk[i].apk06  = cl_digcut(g_apk[i].apk06,g_azi04)
            END IF
 
         BEFORE FIELD apk08
            LET apk08_t = g_apk[i].apk08
 
         AFTER FIELD apk08
            IF NOT cl_null(g_apk[i].apk08) THEN
               IF g_apk[i].apk08 <= 0 THEN
                   CALL cl_err('','agl-006',0) 
                  NEXT FIELD apk08
               END IF
               IF g_apk[i].apk172='1' THEN
                  LET l_tax = g_apk[i].apk08 * (l_apk29/100)
               ELSE
                  LET l_tax = 0
               END IF
               IF apk08_t IS NULL OR apk08_t<>g_apk[i].apk08 THEN
                  LET g_apk[i].apk07 = cl_digcut(l_tax,g_azi04)   
               END IF
               LET g_apk[i].apk06 = g_apk[i].apk08 + g_apk[i].apk07
               LET g_apk[i].apk06 = cl_digcut(g_apk[i].apk06,g_azi04)
               LET g_apk[i].apk08 = cl_digcut(g_apk[i].apk08,g_azi04)
            END IF
 
         AFTER FIELD apk07
            IF NOT cl_null(g_apk[i].apk07) THEN
               IF g_apk[i].apk07 < 0 THEN
                  NEXT FIELD apk07
               END IF
               IF g_apk[i].apk07 > 0 AND l_apk29 = 0 THEN
                  CALL cl_err('','aap-902',1)
                  NEXT FIELD apk07
               END IF
               IF g_apk[i].apk172='1' THEN
                  LET l_tax=g_apk[i].apk08*l_apk29/100
                  LET l_tax=cl_digcut(l_tax,l_azi04)
                  IF g_apk[i].apk07 !=l_tax THEN
                     CALL cl_err(g_apk[i].apk171,'aap-757',0)
                     IF (g_apk[i].apk07 > l_tax+2) OR (g_apk[i].apk07<l_tax-2)  THEN
                        CALL cl_err(g_apk[i].apk171,'mfg-033',0)
                        NEXT FIELD apk07
                     END IF
                  END IF
               END IF
               LET g_apk[i].apk06 = g_apk[i].apk08 + g_apk[i].apk07
               LET g_apk[i].apk06 = cl_digcut(g_apk[i].apk06,g_azi04)
               LET g_apk[i].apk07 = cl_digcut(g_apk[i].apk07,g_azi04)
            END IF
 
         BEFORE DELETE                            #是否取消單身
            DELETE FROM apk_file
             WHERE apk03 = g_apk[i].apk03
               AND apk01 = g_alk.alk01
               AND apk02 = g_apk[i].apk02         #MOD-A90085
            LET l_flag2 = 'Y'   
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","apk_file",g_apk[i].apk03,g_alk.alk01,SQLCA.sqlcode,"","",1)  #No.FUN-660122
               LET g_success = 'N'
               ROLLBACK WORK
               CANCEL DELETE
            ELSE                             #MOD-A90085
               COMMIT WORK                   #MOD-A90085
               LET l_rec_b = l_rec_b - 1     #MOD-A90085
            END IF
             LET l_del ='Y'  
 
 
         AFTER ROW
            LET i = ARR_CURR()   #MOD-A90085
            IF INT_FLAG = 0 THEN
               IF cl_null(g_apk[i].apk17) AND g_apk[i].apk171 <> 'XX' THEN 
                     NEXT FIELD apk17
               END IF
            END IF
 
            IF g_apk[i].apk07f=0 AND g_apk[i].apk08f=0 OR                       
               (cl_null(g_apk[i].apk07f) AND cl_null(g_apk[i].apk08f)) THEN   #MOD-A90085
               INITIALIZE g_apk[i].* TO NULL
            END IF
 
            IF g_apk[i].apk17 MATCHES '[1234]' THEN      
               LET l_flag1= 'Y'
               IF g_apk[i].apk171='22' THEN
                  IF g_apk[i].apk03 IS NULL OR g_apk[i].apk03 = ' ' THEN
                     LET l_flag1='N'
                  ELSE
                     IF g_apk[i].apk03[1,1] MATCHES '[A-Z]' AND
                        g_apk[i].apk03[2,2] MATCHES '[A-Z]' AND
                        g_apk[i].apk03[3,3] MATCHES '[0-9]' AND
                        g_apk[i].apk03[4,4] MATCHES '[0-9]' AND
                        g_apk[i].apk03[10,10] MATCHES '[0-9]' THEN
                        LET l_flag1='Y'
                     ELSE
                        LET l_flag1='N'
                     END IF
                  END IF
               END IF
               IF g_apk[i].apk171 = '28' OR g_apk[i].apk171='29' THEN
                  LET l_flag1='N'
               END IF
               IF g_apk[i].apk171 ='XX' THEN LET l_flag1='N' END IF
               IF l_flag1='Y' THEN
                  LET l_amb01=YEAR(g_apk[i].apk05)
                  LET l_amb02=MONTH(g_apk[i].apk05)
                  LET l_amb03=g_apk[i].apk03[1,2]
                  CALL s_apkchk(l_amb01,l_amb02,l_amb03,g_apk[i].apk171)
                         RETURNING g_errno,g_msg
                  IF NOT cl_null(g_msg) THEN
                     CALL cl_getmsg(g_msg,g_lang) RETURNING g_msg
                     ERROR g_msg,' invoice =',g_apk[i].apk03,' SQLCODE=',g_errno
                      IF cl_confirm('aap-766') THEN 
                        IF g_errno='1' OR g_errno='2'  THEN
                           NEXT FIELD apk05
                        ELSE
                           IF g_errno='3'  THEN
                              NEXT FIELD apk03
                           ELSE
                              NEXT FIELD apk171
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
           #-MOD-A90085-add-
            IF g_apk[i].apk06 IS NULL OR g_apk[i].apk06 = 0 THEN
               CALL g_apk.deleteElement(i)
            END IF
           #-MOD-A90085-add-
            LET l_tot1 = 0 
            LET l_tot2 = 0 
            LET l_tot3 = 0
            LET l_tot28 = 0
 
             FOR k = 1 TO g_apk.getLength()    
               IF g_apk[k].apk06 IS NULL OR g_apk[k].apk06=0 THEN
                  CONTINUE FOR
               END IF
               IF g_apk[k].apk171='23' THEN
                  LET u_sign = -1
               ELSE
                  LET u_sign = 1
               END IF
               IF g_apk[k].apk171='28'  OR g_apk[k].apk171='29' THEN
                  LET l_tot2 = l_tot2 + g_apk[k].apk07*u_sign    #稅
                  LET l_tot28= l_tot28+ g_apk[k].apk08*u_sign    #營業稅稅基
                  LET l_tot3 = (l_tot1+l_tot2 )   
                  LET l_opensw = 'Y'
               ELSE
                  LET l_tot1 = l_tot1 + g_apk[k].apk08*u_sign    #未稅
                  LET l_tot2 = l_tot2 + g_apk[k].apk07*u_sign    #稅
                  LET l_tot3 = (l_tot1+l_tot2 )    
               END IF
            END FOR
            DISPLAY BY NAME l_tot28,l_tot1,l_tot2,l_tot3
 
          ON ACTION CONTROLP
             IF INFIELD(apk11) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_gec"
                LET g_qryparam.default1 = g_apk[i].apk11
                LEt g_qryparam.arg1     = '1'
                CALL cl_create_qry() RETURNING g_apk[i].apk11
                 DISPLAY g_apk[i].apk11 TO apk11   
             END IF
             IF INFIELD(apk13) THEN
                   CALL s_rate(g_apk[i].apk12,g_apk[i].apk13)
                   RETURNING g_apk[i].apk13
                   DISPLAY BY NAME g_apk[i].apk13
                   NEXT FIELD apk13
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
      LET INT_FLAG = 0
      CLOSE WINDOW t110_ddd_w
      RETURN
   END IF
 
   LET j = ARR_COUNT()
 
   WHILE TRUE
      DELETE FROM apk_file WHERE apk01 = g_alk.alk01
      IF STATUS THEN
         CALL cl_err3("del","apk_file",g_alk.alk01,"",STATUS,"","t110_ddd(ckp#1):",1)  #No.FUN-660122
         LET g_success = 'N' EXIT WHILE
      END IF
 
       FOR k = 1 TO g_apk.getLength() 
         IF g_apk[k].apk06 IS NULL OR g_apk[k].apk06=0 THEN
            CONTINUE FOR
         END IF
 
         SELECT gec04 INTO l_apk29 FROM gec_file
          WHERE gec01 = g_apk[k].apk11 AND gec011='1'      
 
         LET l_apk173 = ' '  #FUN-720018
         LET l_apk174 = ' '  #FUN-720018
         CALL s_get_doc_no(g_alk.alk01) RETURNING g_t1
         SELECT apyvcode INTO l_apk32  FROM apy_file WHERE apyslip = g_t1   
           IF cl_null(l_apk32) THEN 
              LET l_apk32 = g_apz.apz63  #FUN-970108 add
           END IF     
         IF cl_null(g_apk[k].apk03) THEN LET g_apk[k].apk03=' ' END IF    
         INSERT INTO apk_file (apk01,apk02,apk03,apk04,apk05,apk06,apk06f,
                               apk07,apk07f,apk08,apk08f,apk11,apk12,apk13,
                               apk17,apk171,apk172,apk173,apk174,
                               apk22,apk25,apk29,apklegal,apk32,apkoriu,apkorig)    #FUN-980001 add legal  #FUN-980076 #FUN-970108 add apk32 
             VALUES(g_alk.alk01,k ,g_apk[k].apk03,g_apk[k].apk04,
                    g_apk[k].apk05,
                    g_apk[k].apk06,g_apk[k].apk06f,
                    g_apk[k].apk07,g_apk[k].apk07f,
                    g_apk[k].apk08,g_apk[k].apk08f,
                    g_apk[k].apk11,g_apk[k].apk12,g_apk[k].apk13,
                    g_apk[k].apk17,g_apk[k].apk171,g_apk[k].apk172,
                    l_apk173,l_apk174,g_alk.alk04,g_alk.alk08,l_apk29,g_legal,  #FUN-980001 add legal   #FUN-980076
                    l_apk32, g_user, g_grup)   #FUN-990014 add 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","apk_file",g_alk.alk01,k ,SQLCA.sqlcode,"","t110_ddd(ckp#2):",1)  
         END IF
      END FOR
      EXIT WHILE
   END WHILE
 
    CLOSE WINDOW t110_ddd_w  #MOD-4A0001
 
END FUNCTION
 
FUNCTION t810_set_entry_apk()
 
   CALL cl_set_comp_entry("apk03",TRUE)
   CALL cl_set_comp_entry("apk12,apk13",TRUE)  
 
END FUNCTION
 
FUNCTION t810_set_no_entry_apk()
 
   IF g_alk.alk46 != 'MISC' THEN
      CALL cl_set_comp_entry("apk03",FALSE)
   END IF
 
   CALL cl_set_comp_entry("apk12,apk13",FALSE)   
 
 IF g_aptype MATCHES '1*' THEN
   IF g_alk.alk46 != 'MISC' THEN
      CALL cl_set_comp_entry("apk03",FALSE)
   END IF
 END IF
END FUNCTION
 

 
#檢查發票是否重覆
FUNCTION t810_duplicate(l_apk02,l_apk03,l_n)
    DEFINE l_apk03         LIKE apk_file.apk03,
           l_idx,l_n       LIKE type_file.num10,   #INTEGER,
           l_apk02         LIKE apk_file.apk02
 
    LET g_errno = ''
    FOR l_idx=1 TO l_n
        IF g_apk[l_idx].apk03=l_apk03 THEN
           LET g_errno='aap-034'
        END IF

    END FOR
 
    RETURN
 
END FUNCTION
 
FUNCTION t810_input_apl(p_no)
   DEFINE p_no  LIKE apl_file.apl01  
   DEFINE l_apl RECORD LIKE apl_file.*
 
   IF cl_null(p_no) THEN
      RETURN
   END IF
 
   LET g_errno=' '
   SELECT * INTO l_apl.* FROM apl_file WHERE apl01 = p_no
   LET l_apl.apl01 = p_no
 
   SELECT pmc03 INTO g_pmc03 FROM pmc_file WHERE pmc01 = g_alk.alk05
 
   IF l_apl.apl02 IS NULL THEN
      LET l_apl.apl02 = g_pmc03
   END IF
 
   OPEN WINDOW t110_apl AT 7,24 WITH FORM "aap/42f/aapt110_b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("aapt110_b")
 
   INPUT BY NAME l_apl.apl01,l_apl.apl02,l_apl.apl03 WITHOUT DEFAULTS
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
 
   CLOSE WINDOW t110_apl
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   SELECT count(*) INTO g_cnt FROM apl_file WHERE apl01 = p_no
 
   IF g_cnt > 0 THEN
      UPDATE apl_file SET * = l_apl.* WHERE apl01 = p_no
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("upd","apl_file",p_no,"",SQLCA.sqlcode,"","upd apl:",1) 
      END IF
     LET g_pmc03 = l_apl.apl02                                     
     UPDATE pmc_file SET pmc03 = l_apl.apl02 WHERE pmc01 = g_alk.alk05
   ELSE
      INSERT INTO apl_file VALUES (l_apl.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","apl_file",l_apl.apl01,"",SQLCA.sqlcode,"","ins apl:",1)  
      END IF
     LET g_pmc03 = l_apl.apl02
     UPDATE pmc_file SET pmc03 = l_apl.apl02 WHERE pmc01 = g_alk.alk05
   END IF
 
END FUNCTION
#No.FUN-9C0077 程式精簡

#No.FUN-B10050  --Begin
FUNCTION t810_aag01(p_aag00,p_aag01,p_type)
    DEFINE p_aag00      LIKE aag_file.aag00
    DEFINE p_aag01      LIKE aag_file.aag01
    DEFINE p_type       LIKE type_file.chr1
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_acti
      FROM aag_file 
     WHERE aag00 = p_aag00
       AND aag01 = p_aag01

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-021'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno) THEN
       CASE p_type
            WHEN '0'  DISPLAY l_aag02 TO FORMONLY.aag02_0
            WHEN '1'  DISPLAY l_aag02 TO FORMONLY.aag02_1
            WHEN '2'  DISPLAY l_aag02 TO FORMONLY.aag02_2
            WHEN '3'  DISPLAY l_aag02 TO FORMONLY.aag02_3
            WHEN '4'  DISPLAY l_aag02 TO FORMONLY.aag02_4
            WHEN '5'  DISPLAY l_aag02 TO FORMONLY.aag02_5
            WHEN '6'  DISPLAY l_aag02 TO FORMONLY.aag02_6
            WHEN '7'  DISPLAY l_aag02 TO FORMONLY.aag02_7
            WHEN '8'  DISPLAY l_aag02 TO FORMONLY.aag02_8
            WHEN '9'  DISPLAY l_aag02 TO FORMONLY.aag02_9
            WHEN 'A'  DISPLAY l_aag02 TO FORMONLY.aag02_10
            WHEN 'B'  DISPLAY l_aag02 TO FORMONLY.aag02_11
       END CASE
    END IF
END FUNCTION
#No.FUN-B10050  --End  

#-------------------------CHI-B80025----------------------start
FUNCTION t810_diff()
   DEFINE ale       RECORD LIKE ale_file.*
   DEFINE sum_ale07        LIKE ale_file.ale07
   DEFINE l_ale07          LIKE ale_file.ale07
   DEFINE lamt             LIKE type_file.num20_6
   DEFINE l_ale02          LIKE ale_file.ale02
   DEFINE l_chkamt         LIKE ale_file.ale07
   DEFINE l_cnt            LIKE ale_file.ale02
   DEFINE l_diff           LIKE type_file.num5
   DEFINE l_chkdiff        LIKE type_file.num5
   DEFINE l_diffamt        LIKE type_file.num20_6
   DEFINE tot1             LIKE type_file.num20_6

   SELECT sum(ale07) INTO sum_ale07
     FROM ale_file
     WHERE ale01=g_alk.alk01

   DECLARE t810_diff_c1 CURSOR FOR
    SELECT * FROM ale_file
     WHERE ale01=g_alk.alk01
     ORDER BY ale02

   FOREACH t810_diff_c1 INTO ale.*
      LET ale.ale07 = ale.ale07+(g_alk.alk13-sum_ale07)*ale.ale07/sum_ale07
      LET ale.ale07 = cl_digcut(ale.ale07,g_azi04)

      UPDATE ale_file SET ale07  = ale.ale07
       WHERE ale01=ale.ale01 AND ale02=ale.ale02
   END FOREACH

   SELECT sum(ale07) INTO l_ale07
     FROM ale_file
     WHERE ale01=g_alk.alk01
   IF cl_null(l_ale07) THEN
      LET l_ale07 = 0
   END IF

   IF l_ale07 != g_alk.alk13  THEN
      LET lamt= g_alk.alk13 - l_ale07
      IF lamt != 0 THEN
         LET l_chkamt = 0

         CALL s_abs(lamt) RETURNING l_diffamt

        #抓取金額最大筆的項次
        SELECT MIN(ale02) INTO l_ale02
          FROM ale_file
         WHERE ale01=g_alk.alk01
           AND ale07 = (SELECT MAX(ale07) FROM ale_file WHERE ale01=g_alk.alk01)

        SELECT ale07 INTO l_chkamt
          FROM ale_file
         WHERE ale01=g_alk.alk01 AND ale02 = l_ale02
        IF cl_null(l_chkamt) THEN LET l_chkamt = 0 END IF

        IF l_chkamt > l_diffamt THEN
       #調整至金額最大筆
           UPDATE ale_file SET ale07 = ale07+lamt
            WHERE ale01=g_alk.alk01 AND ale02 = l_ale02
        END IF
      END IF
   END IF

   SELECT sum(ale07) INTO tot1
     FROM ale_file
     WHERE ale01=g_alk.alk01

   DISPLAY BY NAME tot1


   IF g_apb_sarrno > 0 THEN
      CALL t810_b_fill(' 1=1')
   END IF

END FUNCTION
#-------------------------CHI-B80025-----------------------end

#No.FUN-BB0086--add--begin--
FUNCTION t810_ale82_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_ale[l_ac].ale82) AND NOT cl_null(g_ale[l_ac].ale80) THEN
      IF cl_null(g_ale_t.ale82) OR cl_null(g_ale80_t) OR g_ale_t.ale82 != g_ale[l_ac].ale82 OR g_ale80_t != g_ale[l_ac].ale80 THEN
         LET g_ale[l_ac].ale82=s_digqty(g_ale[l_ac].ale82,g_ale[l_ac].ale80)
         DISPLAY BY NAME g_ale[l_ac].ale82
      END IF
   END IF

   IF NOT cl_null(g_ale[l_ac].ale82) THEN
      IF g_ale[l_ac].ale82 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF
   CALL t810_set_origin_field()
   IF cl_null(g_ale[l_ac].ale86) THEN
      LET g_ale[l_ac].ale87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
             g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
             g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
             g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
             g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
         CALL t810_set_ale87()
      END IF
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION 

FUNCTION t810_ale85_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_ale[l_ac].ale85) AND NOT cl_null(g_ale[l_ac].ale83) THEN
      IF cl_null(g_ale_t.ale85) OR cl_null(g_ale83_t) OR g_ale_t.ale85 != g_ale[l_ac].ale85 OR g_ale83_t != g_ale[l_ac].ale83 THEN
         LET g_ale[l_ac].ale85=s_digqty(g_ale[l_ac].ale85,g_ale[l_ac].ale83)
         DISPLAY BY NAME g_ale[l_ac].ale85
      END IF
   END IF

   IF NOT cl_null(g_ale[l_ac].ale85) THEN
      IF g_ale[l_ac].ale85 < 0 THEN
         CALL cl_err('','aim-391',1) 
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_ale_t.ale85 <> g_ale[l_ac].ale85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_ale[l_ac].ale85*g_ale[l_ac].ale84
            IF cl_null(g_ale[l_ac].ale82) OR g_ale[l_ac].ale82=0 THEN 
               LET g_ale[l_ac].ale82=g_tot*g_ale[l_ac].ale81
               DISPLAY BY NAME g_ale[l_ac].ale82                      
            END IF                                                    
         END IF
      END IF
   END IF
   IF cl_null(g_ale[l_ac].ale86) THEN
      LET g_ale[l_ac].ale87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_ale_t.ale81 <> g_ale[l_ac].ale81 OR
             g_ale_t.ale82 <> g_ale[l_ac].ale82 OR
             g_ale_t.ale84 <> g_ale[l_ac].ale84 OR
             g_ale_t.ale85 <> g_ale[l_ac].ale85 OR
             g_ale_t.ale86 <> g_ale[l_ac].ale86) THEN
         CALL t810_set_ale87()
      END IF
   END IF
   CALL cl_show_fld_cont()  
   RETURN TRUE
END FUNCTION 

FUNCTION t810_ale87_check()
   IF NOT cl_null(g_ale[l_ac].ale87) AND NOT cl_null(g_ale[l_ac].ale86) THEN
      IF cl_null(g_ale_t.ale87) OR cl_null(g_ale86_t) OR g_ale_t.ale87 != g_ale[l_ac].ale87 OR g_ale86_t != g_ale[l_ac].ale86 THEN
         LET g_ale[l_ac].ale87=s_digqty(g_ale[l_ac].ale87,g_ale[l_ac].ale86)
         DISPLAY BY NAME g_ale[l_ac].ale87
      END IF
   END IF

   IF NOT cl_null(g_ale[l_ac].ale87) THEN
      IF g_ale[l_ac].ale87 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t810_ale06_check()
DEFINE l_pmn07      LIKE pmn_file.pmn07         
   IF NOT cl_null(g_ale[l_ac].ale06) THEN
      IF g_ale[l_ac].ale16 != 'MISC' THEN
         IF g_ale[l_ac].ale06+g_qty2 > g_qty1 THEN
            CALL cl_err('','aap-048',1)
            RETURN FALSE
         END IF
      END IF
      IF NOT cl_null(g_ale[l_ac].ale14) AND NOT cl_null(g_ale[l_ac].ale15) THEN
         SELECT pmn07 INTO l_pmn07 FROM pmn_file
          WHERE pmn01 = g_ale[l_ac].ale14 
            AND pmn02 = g_ale[l_ac].ale15 
         LET g_ale[l_ac].ale06 = s_digqty(g_ale[l_ac].ale06,l_pmn07)
         DISPLAY BY NAME g_ale[l_ac].ale06
      END IF
      LET g_ale[l_ac].ale07 = g_ale[l_ac].ale06 * g_ale[l_ac].ale05
      LET g_ale[l_ac].ale07 = cl_digcut(g_ale[l_ac].ale07,t_azi04)
      LET g_ale[l_ac].ale09 = g_ale[l_ac].ale06 * g_ale[l_ac].ale08
      LET g_ale[l_ac].ale09 = cl_digcut(g_ale[l_ac].ale09,g_azi04)  #No.MOD-530729   #MOD-790060
      DISPLAY BY NAME g_ale[l_ac].ale07
      DISPLAY BY NAME g_ale[l_ac].ale09
      CALL t810_qty_chk()
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086--add--end--
#CHI-C80041---begin
FUNCTION t810_x()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_alk.alk01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t810_cl USING g_alk.alk01
   IF STATUS THEN
      CALL cl_err("OPEN t810_cl:", STATUS, 1)
      CLOSE t810_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t810_cl INTO g_alk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alk.alk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t810_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_alk.alkfirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_alk.alkfirm)   THEN 
        LET l_chr=g_alk.alkfirm
        IF g_alk.alkfirm='N' THEN 
            LET g_alk.alkfirm='X' 
        ELSE
            LET g_alk.alkfirm='N'
        END IF
        UPDATE alk_file
            SET alkfirm=g_alk.alkfirm,  
                alkmodu=g_user,
                alkdate=g_today
            WHERE alk01=g_alk.alk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","alk_file",g_alk.alk01,"",SQLCA.sqlcode,"","",1)  
            LET g_alk.alkfirm=l_chr 
        END IF
        DISPLAY BY NAME g_alk.alkfirm 
   END IF
 
   CLOSE t810_cl
   COMMIT WORK
   CALL cl_flow_notify(g_alk.alk01,'V')
 
END FUNCTION
#CHI-C80041---end
