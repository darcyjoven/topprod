# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: saapt710.4gl
# Descriptions...: L/C 開狀維護
# Date & Author..: 92/12/28 By Roger
# Modify.........: 97/04/21 By Star [將apc_file 改為 npp_file,npq_file ]
# Modify.........: MOD-470028 04/07/14 By Carol 付款科目add開窗選會計科目
# Modify.........: MOD-470303 04/07/28 By ching q_pmn 參數傳遞錯誤
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.MOD-4C0040 04/12/14 By Smapmin 新增ala77會計日期的欄位
# Modify.........: No.FUN-4C0073 04/12/17 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530819 05/03/29 By saki 若有合約時,其信貸銀行及融資種類必須要輸入.反之則不可輸入.
# Modify.........: No.MOD-530832 05/03/30 By Nicola 切換'申請明細','會計資料',手續費欄位資料會被清除
# Modify.........: No.MOD-530815 05/04/04 By Nicola 1.帶出來時若金額單身超過單頭有一個prompt的訊息,請改為gp寫法
#                                                   2.display資料的window顯示看不出顯示什麼資料
#                                                   3.預購單號的開窗請拿掉
# Modify.........: No.MOD-530817 05/04/12 By Nicola 會計日期為null，預設為開立日
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560089 05/06/19 By Smapmin 計價單位處理問題,
#                                            合約編號, 應可不輸入, 因採購部門可能不知使用何合約
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.MOD-630109 06/03/28 By Smapmin pma11增加C的判斷
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: No.MOD-640519 06/04/19 By Smapmin 修正SELECT 條件
# Modify.........: NO.MOD-650011 06/05/03 By Smapmin 修正修改記錄
# Modify.........: No.TQC-640198 06/05/03 By Smapmin 當單身存在資料時,單頭的採購廠商,付款條件,幣別不可修改
# Modify.........: No.TQC-660072 06/06/14 By Dido 補充TQC-630070
# Modify.........: No.TQC-660066 06/06/15 By Smapmin 除了付款類別為LC的之外,不可控管合約編號與融資種類不可空白
# Modify.........: No.FUN-660117 06/06/19 By Rainy Char改為 Like
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/07/31 By Xufeng 新增"直接拋轉"功能                                                      
# Modify.........: No.FUN-680019 06/08/07 By kim GP3.5 利潤中心
# Modify.........: No.MOD-680045 06/08/17 By Smapmin DISPLAY ARRAY時,多加UNBUFFERED屬性
# Modify.........: No.FUN-680029 06/08/23 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能			
# Modify.........: No.FUN-690014 06/12/01 By Smapmin 當開狀應攤金額為0時,可以直接確認.
# Modify.........: No.MOD-690132 06/12/06 By Smapmin 幣別不應受合約編號的影響
# Modify.........: No.MOD-690139 06/12/07 By Smapmin 數量應該抓取alb07
# Modify.........: No.MOD-710054 07/01/08 By Smapmin 檢查數量是否超出時,應該要把作廢的外購申請單剔除
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.MOD-720130 07/03/01 By Smapmin 自動產生單身資料時,要先抓取幣別取位位數
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/04/03 By Lynn    會計科目加帳套 
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.CHI-750011 07/05/09 By kim 產生單身時的SQL error
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790011 07/09/11 By Smapmin 付款條件僅能為3/4/6/7/8
# Modify.........: No.TQC-7C0050 07/12/06 By Smapmin 程式一開始就先預設主帳別/次帳別
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810167 08/01/25 By Smapmin q_nnp01改為Hard Code
# Modify.........: No.MOD-840557 08/04/22 By Zhangyajun 解決右邊Action顯示問題
# Modify.........: No.FUN-850038 08/05/12 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.MOD-960251 09/06/22 By mike 1.g_sql請多抓pmn83,pmn85,pmn80,pmn82,pmn86,pmn87給予g_apb[l_ac].alb83,alb85,alb80,
#                                                 2.最后對此段有給予值的g_apb[l_ac]加上DISPLAY BY NAME g_alb[l_ac].*,例如           
#                                                   DISPLAY BY NAME g_alb[l_ac].alb06  DISPLAY BY NAME g_alb[l_ac].alb07 ...        
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980076 09/08/27 By TSD.apple    GP5.2架構重整，移除xxxplant 
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
# Modify.........: No.FUN-980020 09/09/04 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.FUN-980094 09/10/19 By TSD.hoho GP5.2 跨資料庫語法修改 
# Modify.........: NO.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录 
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 09/12/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/24 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.MOD-A80215 10/08/27 by Dido 產生單身應排除作廢資料;變數清空;CS段語法調整 
# Modify.........: No.MOD-A90075 10/09/10 by Dido 檢核合約編號額度是否有超出 
# Modify.........: No.MOD-AA0145 10/10/25 by Dido 單身採購若已收貨則不可刪除或作廢 
# Modify.........: No:CHI-AA0015 10/11/05 By Summer alc02原為vachar(1)改為Number(5)
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善
# Modify.........: No:FUN-B20059 11/02/22 By wujie  科目自动开窗hard code修改
# Modify.........: No:TQC-B40039 11/04/08 By yinhy 進入單身后點擊"自動生成採購單身"按鈕退出后，顯示bnt*按钮
# Modify.........: No:TQC-B40047 11/04/08 By yinhy 查詢時狀態PAGE中資料建立者，資料建立部門無法下查詢條件
# Modify.........: No:TQC-B40082 11/04/12 By yinhy 单身錄入時，“採購單號”欄位開窗採購單對應的“料件編號”未帶出顯示
# Modify.........: No:TQC-B40089 11/04/12 By yinhy 查詢時，“採購單號”"欄位未帶出
# Modify.........: No:TQC-B40091 11/04/12 By yinhy 新增時，單身"採購單項次"不需默認為0
# Modify.........: No:TQC-B40135 11/04/18 By yinhy 自動生成單身資料時，付款方式應與採購單付款方式相同
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.MOD-B50148 11/05/18 By Dido 變數定義調整 
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B90033 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No:MOD-B90274 11/09/30 By Dido ala34 計算後須取位 
# Modify.........: No.MOD-BB0212 11/11/21 By Dido 帳別預設值調整 
# Modify.........: No:MOD-BC0258 11/12/28 By Polly 調整aapt710與aapt720的ala41和ala42欄位預帶aps14和aps22
# Modify.........: No:FUN-BB0086 12/01/12 By tanxc 增加數量欄位小數取位  
# Modify.........: No:MOD-C10185 12/01/30 By Polly 錯誤訊息anm-287，將ala23 * ala51取位後再與l_bal判斷
# Modify.........: No:TQC-BB0140 12/02/10 By yinhy 增加部門名稱
# Modify.........: No:TQC-BB0144 12/02/10 By yinhy 增加付款條件的判斷
# Modify.........: No:TQC-BB0147 12/02/10 By yinhy 增加付款條件說明
# Modify.........: No:TQC-C20183 12/02/15 By xujing 修改小數取位欄位關閉問題
# Modify.........: No.MOD-C20027 12/02/06 By Polly AFTER FIELD ala35 增加抓取nnp08給予ala79
# Modify.........: No.MOD-C30614 12/03/13 By minpp AFTER FIELD ala23/ala21/ala34 增加計算完 ala52 後 CALL t710_ala59()
# Modify.........: No.MOD-C30690 12/03/14 By Polly 增加幣別取位動作
# Modify.........: No.TQC-BB0233 12/03/19 By yinhy AFTER FIELD ala33增加對ala53賦值
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身時若單身無資料則，提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C70288 12/07/30 By Polly 分錄中費用資料的原幣與本幣應該一致,幣別為 aza17,匯率為 1
# Modify.........: No:TQC-C80198 12/09/03 By lujh q_nnp01增加一个参数
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Mofidy.........: NO.CHI-C90047 13/01/16 By Yiting s_credit2此時傳回的金額都是合約幣別，直接拿l_bal和l_ala23來比對，可能會有幣別不相同的狀況
#                                                   應該要判斷這個合約幣別是否為本幣，如果不同於本幣時要換算為本幣後才能拿來和l_ala23做比對
# Modify.........: No:FUN-D20035 13/02/20 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-C60006 13/05/08 By qirl 系統作廢/取消作廢需要及時更新修改者以及修改時間欄位
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ala               RECORD LIKE ala_file.*,
       g_ala_t             RECORD LIKE ala_file.*,
       g_ala_o             RECORD LIKE ala_file.*,
       g_ala01_t           LIKE ala_file.ala01,
       g_wc,g_wc2,g_sql    STRING,      #No.7410  #No.FUN-580092 HCN
       g_cmd               LIKE type_file.chr1000,     # 1.開狀申請(採購部門) 2.會計作業  #No.FUN-690028 VARCHAR(1)
       g_act_sw            LIKE type_file.num5,        # No.FUN-690028 SMALLINT,      # 1.會計作業 2.財務作業
       g_statu             LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),       # 是否從新賦予等級
       g_dbs_gl            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),                 #MOD-B50148 mod chr1 -> chr21
       g_plant_gl          LIKE type_file.chr10,       # No.FUN-690028 VARCHAR(21),  #No.FUN-980059 #MOD-B50148 mod chr1 -> chr10
       g_dbs_nm            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
       amty,amtu,u_amty,u_amtu,bal  LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       nm_no_b,nm_no_e            LIKE type_file.num10,       # No.FUN-690028 INTEGER,
       gl_no_b,gl_no_e            LIKE abb_file.abb01,      # No.FUN-690028 VARCHAR(16),        #No.FUN-550030
       g_alb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
           alb02            LIKE alb_file.alb02,
           alb04            LIKE alb_file.alb04,
           alb05            LIKE alb_file.alb05,
           alb11            LIKE alb_file.alb11,
           pmn041           LIKE pmn_file.pmn041,
           alb83            LIKE alb_file.alb83, 
           alb84            LIKE alb_file.alb84,
           alb85            LIKE alb_file.alb85,
           alb80            LIKE alb_file.alb80,
           alb81            LIKE alb_file.alb81,
           alb82            LIKE alb_file.alb82,
           alb86            LIKE alb_file.alb86,
           alb87            LIKE alb_file.alb87,
           alb06            LIKE alb_file.alb06,
           alb07            LIKE alb_file.alb07,
           alb08            LIKE alb_file.alb08,
           alb12            LIKE alb_file.alb12,
           alb13            LIKE alb_file.alb13,
           pmn06            LIKE pmn_file.pmn06,
           alb930           LIKE alb_file.alb930, #FUN-680019
           gem02c           LIKE gem_file.gem02,   #FUN-680019
           albud01 LIKE alb_file.albud01,
           albud02 LIKE alb_file.albud02,
           albud03 LIKE alb_file.albud03,
           albud04 LIKE alb_file.albud04,
           albud05 LIKE alb_file.albud05,
           albud06 LIKE alb_file.albud06,
           albud07 LIKE alb_file.albud07,
           albud08 LIKE alb_file.albud08,
           albud09 LIKE alb_file.albud09,
           albud10 LIKE alb_file.albud10,
           albud11 LIKE alb_file.albud11,
           albud12 LIKE alb_file.albud12,
           albud13 LIKE alb_file.albud13,
           albud14 LIKE alb_file.albud14,
           albud15 LIKE alb_file.albud15
 
                       END RECORD,
       g_alb_t         RECORD                 #程式變數 (舊值)
           alb02            LIKE alb_file.alb02,
           alb04            LIKE alb_file.alb04,
           alb05            LIKE alb_file.alb05,
           alb11            LIKE alb_file.alb11,
           pmn041           LIKE pmn_file.pmn041,
           alb83            LIKE alb_file.alb83, 
           alb84            LIKE alb_file.alb84,
           alb85            LIKE alb_file.alb85,
           alb80            LIKE alb_file.alb80,
           alb81            LIKE alb_file.alb81,
           alb82            LIKE alb_file.alb82,
           alb86            LIKE alb_file.alb86,
           alb87            LIKE alb_file.alb87,
           alb06            LIKE alb_file.alb06,
           alb07            LIKE alb_file.alb07,
           alb08            LIKE alb_file.alb08,
           alb12            LIKE alb_file.alb12,
           alb13            LIKE alb_file.alb13,
           pmn06            LIKE pmn_file.pmn06,
           alb930           LIKE alb_file.alb930, #FUN-680019
           gem02c           LIKE gem_file.gem02,   #FUN-680019
           albud01 LIKE alb_file.albud01,
           albud02 LIKE alb_file.albud02,
           albud03 LIKE alb_file.albud03,
           albud04 LIKE alb_file.albud04,
           albud05 LIKE alb_file.albud05,
           albud06 LIKE alb_file.albud06,
           albud07 LIKE alb_file.albud07,
           albud08 LIKE alb_file.albud08,
           albud09 LIKE alb_file.albud09,
           albud10 LIKE alb_file.albud10,
           albud11 LIKE alb_file.albud11,
           albud12 LIKE alb_file.albud12,
           albud13 LIKE alb_file.albud13,
           albud14 LIKE alb_file.albud14,
           albud15 LIKE alb_file.albud15
                       END RECORD,
       g_nnp07         LIKE nnp_file.nnp07,
       g_buf           LIKE type_file.chr1000,             #  #No.FUN-690028 VARCHAR(78)
       g_tot           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
       l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_nnn02         LIKE nnn_file.nnn02
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_void         LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
DEFINE g_argv1         LIKE ala_file.ala01       #No.FUN-4A0081
DEFINE g_argv2         STRING                    #TQC-630070      #執行功能
DEFINE g_param_flag    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_alc02        LIKE alc_file.alc02   #MOD-650011
DEFINE g_str           STRING               #No.FUN-670060
DEFINE g_wc_gl         STRING               #No.FUN-670060
DEFINE g_t1            LIKE oay_file.oayslip              #No.FUN-670060  #No.FUN-690028 VARCHAR(5)
DEFINE g_img09             LIKE img_file.img09
DEFINE       g_ima25             LIKE ima_file.ima25
DEFINE       g_ima44             LIKE ima_file.ima44
DEFINE       g_ima31             LIKE ima_file.ima31
DEFINE       g_ima906            LIKE ima_file.ima906
DEFINE       g_ima907            LIKE ima_file.ima907
DEFINE       g_ima908            LIKE ima_file.ima908
DEFINE       g_factor            LIKE pmn_file.pmn09
DEFINE       g_tot1               LIKE img_file.img10
DEFINE       g_qty               LIKE img_file.img10
DEFINE       g_flag              LIKE type_file.chr1
DEFINE g_azp03             LIKE azp_file.azp03    #No.FUN-730064
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730064                                                                    
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730064                                                                    
DEFINE g_bookno            LIKE aag_file.aag00    #No.FUN-730064
DEFINE g_dbsm              LIKE type_file.chr21   #No.FUN-730064                                                                    
DEFINE g_plantm            LIKE type_file.chr10   #No.FUN-980020
DEFINE g_db_type           LIKE type_file.chr3    #No.FUN-730064
DEFINE g_flag1             LIKE type_file.chr1    #No.FUN-730064
DEFINE g_db1               LIKE type_file.chr21   #No.FUN-730064
DEFINE g_alb80_t           LIKE alb_file.alb80    #No.FUN-BB0086 
DEFINE g_alb82_t           LIKE alb_file.alb82    #No.FUN-BB0086 
DEFINE g_alb83_t           LIKE alb_file.alb83    #No.FUN-BB0086 
DEFINE g_alb86_t           LIKE alb_file.alb86    #No.FUN-BB0086 
DEFINE g_rate1             LIKE nnp_file.nnp08       #CHI-C90047
DEFINE g_nno06             LIKE nno_file.nno06       #CHI-C90047

FUNCTION t710(p_cmd,p_argv1,p_argv2)           #No.FUN-4A0081,#TQC-630070
   DEFINE p_cmd  LIKE type_file.chr1              # 1.開狀申請 2.會計作業 3.財務作業  #No.FUN-690028 VARCHAR(1)
   DEFINE p_argv1 LIKE ala_file.ala01  #No.FUN-4A0081
   DEFINE p_argv2 STRING               #TQC-630070
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   CALL s_get_bookno('') RETURNING g_flag,g_bookno1,g_bookno2    #TQC-7C0050
 
   LET g_plant_new = g_apz.apz04p
 
   CALL s_getdbs()
 
   LET g_dbs_nm = g_dbs_new
 
   IF g_dbs_gl = ' ' THEN
      LET g_dbs_gl = NULL
   END IF
 
   LET g_plant_new = g_apz.apz02p
 
   CALL s_getdbs()
 
   LET g_dbs_gl = g_dbs_new
 
   IF g_dbs_gl = ' ' THEN
      LET g_dbs_gl = NULL
   END IF
 
   LET g_cmd = p_cmd
 
   INITIALIZE g_ala.* TO NULL
   INITIALIZE g_ala_t.* TO NULL
   INITIALIZE g_ala_o.* TO NULL
 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2          #TQC-630070
   LET g_ala.ala01 = g_argv1
   DISPLAY BY NAME g_ala.ala01
   IF NOT cl_null(g_argv1) THEN
      LET g_param_flag = TRUE
   END IF
 
   CALL t710_def_form()
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("ala411,ala421",FALSE)
   END IF
 
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("ala04",TRUE)
   END IF
   CALL cl_set_comp_visible("ala930,gem02b,alb930,gem02c",g_aaz.aaz90='Y')
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t710_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t710_a()
            END IF
         OTHERWISE          #TQC-660072
            CALL t710_q()   #TQC-660072
      END CASE
   END IF
 
   CALL t710_lock_cur()
 
   WHILE TRUE
      LET g_action_choice = ""
      CASE
         WHEN g_cmd = '1'
            CALL t710_menu_po()
         WHEN g_cmd = '2'
            CALL t710_menu0()
      END CASE
 
      IF g_action_choice = 'exit' THEN
         EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION t710_lock_cur()
 
   LET g_forupd_sql = "SELECT * FROM ala_file WHERE ala01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t710_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE   l_argv_flag   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   CLEAR FORM
   CALL g_alb.clear()
 
 IF cl_null(g_argv1) THEN 
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   INITIALIZE g_ala.* TO NULL      #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON ala97,ala01,ala72,ala03,ala04,ala930,ala08,     #FUN-680019      #No.FUN-980017
                             ala11,ala05,ala06,ala02,ala20,ala23,ala21,
                             ala34,ala51,ala52,ala56,ala53,ala54,ala59,
                              alafirm ,alaclos,ala33,ala35,ala07,ala22,  #MOD-4C0040
                             ala77,ala79,ala24,ala25,ala26,ala60,ala61,
                             ala41,ala42,ala411,ala421,
                                alaud01,alaud02,alaud03,alaud04,alaud05,
                                alaud06,alaud07,alaud08,alaud09,alaud10,
                                alaud11,alaud12,alaud13,alaud14,alaud15,
                             alauser,alagrup,alamodu,aladate,  #No.FUN-680029 add ala411,ala421
                             alaoriu,alaorig                   #No.TQC-B40047
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()  #No.FUN-580031
         IF g_param_flag THEN
            LET g_ala.ala01 = g_argv1
            DISPLAY g_ala.ala01 TO ala01
            LET g_param_flag = FALSE
         END IF
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(ala01) # APO  #No.MOD-530815 Mark
               CALL q_ala(TRUE,TRUE,g_ala.ala01) RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala01
            WHEN INFIELD(ala02) # PAY TERM
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma01"   #MOD-790011
               LET g_qryparam.default1 = g_ala.ala02
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala02
            WHEN INFIELD(ala05) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_ala.ala05
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala05
            WHEN INFIELD(ala06) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_ala.ala06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala06
            WHEN INFIELD(ala07) #PAY BANK
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_alg"
               LET g_qryparam.default1 = g_ala.ala07
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala07
            WHEN INFIELD(ala20) # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_ala.ala20
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala20
            WHEN INFIELD(ala04) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_ala.ala04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala04
            WHEN INFIELD(ala33) #合約號碼
               CALL q_nnp01(1,1,g_ala.ala33,'')      #TQC-C80198  add  ''
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala33
            WHEN INFIELD(ala35) #融資種類
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nnn"
               LET g_qryparam.default1 = g_ala.ala35
               CALL cl_create_qry() RETURNING g_ala.ala35,l_nnn02
               DISPLAY BY NAME g_ala.ala35
               DISPLAY l_nnn02 TO FORMONLY.nnn02
            WHEN INFIELD(ala41) # Account number
               CALL q_aapact(TRUE,TRUE,'2',g_ala.ala41,g_bookno1)    #No:8727     #No.FUN-730064 
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala41
            WHEN INFIELD(ala42) # Account number
               CALL q_aapact(TRUE,TRUE,'2',g_ala.ala42,g_bookno1)    #No:8727     #No.FUN-730064 
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala42
            WHEN INFIELD(ala411)
               CALL q_aapact(TRUE,TRUE,'2',g_ala.ala411,g_bookno2)     #No.FUN-730064  
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala411
            WHEN INFIELD(ala421)
               CALL q_aapact(TRUE,TRUE,'2',g_ala.ala421,g_bookno2)   #No.FUN-730064  
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala421
            WHEN INFIELD(ala930)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ala930
               NEXT FIELD ala930
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
 
   CONSTRUCT g_wc2 ON alb02,alb04,alb05,alb11,
                      alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87,  #NO.FUN-710029
                      alb06,alb07,alb08,alb12,alb930 #FUN-680019
                     ,albud01,albud02,albud03,albud04,albud05
                     ,albud06,albud07,albud08,albud09,albud10
                     ,albud11,albud12,albud13,albud14,albud15
        FROM s_alb[1].alb02,s_alb[1].alb04,s_alb[1].alb05,s_alb[1].alb11,
             s_alb[1].alb83,s_alb[1].alb84,s_alb[1].alb85,s_alb[1].alb80,  #NO.FUN-710029
             s_alb[1].alb81,s_alb[1].alb82,s_alb[1].alb86,s_alb[1].alb87,  #NO.FUN-710029
             s_alb[1].alb06,s_alb[1].alb07,s_alb[1].alb08,s_alb[1].alb12,
             s_alb[1].alb930 #FUN-680019
            ,s_alb[1].albud01,s_alb[1].albud02,s_alb[1].albud03,s_alb[1].albud04,s_alb[1].albud05
            ,s_alb[1].albud06,s_alb[1].albud07,s_alb[1].albud08,s_alb[1].albud09,s_alb[1].albud10
            ,s_alb[1].albud11,s_alb[1].albud12,s_alb[1].albud13,s_alb[1].albud14,s_alb[1].albud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(alb04)
               CALL q_m_pmm5(TRUE,TRUE,g_alb[1].alb04,g_plant,g_ala.ala05)
                    RETURNING g_alb[1].alb04
                DISPLAY g_alb[1].alb04 TO alb04             #No.MOD-490344               
            WHEN INFIELD(alb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmn"
               LET g_qryparam.arg1     = g_alb[1].alb04
               CALL cl_create_qry() RETURNING g_alb[1].alb05
               DISPLAY g_alb[1].alb05 TO alb05             #No.MOD-490344
            WHEN INFIELD(alb80)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alb80
                NEXT FIELD alb80
            WHEN INFIELD(alb86)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alb86
                NEXT FIELD alb86
            WHEN INFIELD(alb930)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alb930
               NEXT FIELD alb930
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
      RETURN
   END IF
 
 ELSE 
      LET g_wc=" ala01='",g_argv1,"'"
      LET g_wc2=" 1=1"
 END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT ala01 FROM ala_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY ala01"
   ELSE
     #LET g_sql="SELECT ala01 FROM ala_file,alb_file ",           #MOD-A80215 mark
      LET g_sql="SELECT UNIQUE ala01 FROM ala_file,alb_file ",    #MOD-A80215
                " WHERE ala01=alb01",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY ala01"
   END IF
 
   PREPARE t710_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t710_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t710_prepare
  IF g_wc2 = ' 1=1' THEN
     LET g_sql= "SELECT COUNT(*) FROM ala_file WHERE ",g_wc CLIPPED
  ELSE
     LET g_sql= "SELECT COUNT(DISTINCT ala01) FROM ala_file,alb_file ",
                "WHERE ala01 = alb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  END IF
 
   PREPARE t710_precount FROM g_sql
   DECLARE t710_count CURSOR FOR t710_precount
 
END FUNCTION
 
FUNCTION t710_menu_po()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL t710_bp_po("G")
      CASE g_action_choice
           WHEN "insert"
                IF cl_chk_act_auth() THEN
                   CALL t710_a()
                END IF
           WHEN "query"
                IF cl_chk_act_auth() THEN
                   CALL t710_q()
                END IF
           WHEN "modify"
                IF cl_chk_act_auth() THEN
                   CALL t710_u()
                END IF
           WHEN "delete"
               IF cl_chk_act_auth() THEN
                  CALL t710_r()
               END IF
           WHEN "detail"
               IF cl_chk_act_auth() THEN
                  CALL t710_b()
               ELSE
                  LET g_action_choice = NULL
               END IF
           WHEN "output"  CALL t710_out('a')
           WHEN "memo"
                IF cl_chk_act_auth() THEN
                   CALL t710_m()
                END IF
           WHEN "other_data"
                IF cl_chk_act_auth() THEN
                   CALL t710_7('2')
                END IF
           WHEN "bl"
                CALL t710_g()
           WHEN "arriving_note"
                CALL t710_j()
           WHEN "arrivals"
                CALL t710_k()
           WHEN "closing_log"
                LET g_msg="aapt750 '",g_ala.ala01,"'"
                CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
           WHEN "update_log"
                LET g_alc02 = 0
                SELECT MAX(alc02) INTO g_alc02 FROM alc_file
                  WHERE alc01 = g_ala.ala01
                    AND alcfirm <> 'X' #CHI-C80041
                LET g_msg="aapq700 '",g_ala.ala01,"' '", g_alc02,"'"
                CALL cl_cmdrun(g_msg)
          #--FUN-B10030--start--
          #  WHEN "switch_plant"
          #      CALL t710_d()
          #--FUN-B10030--end--
           WHEN "void"
                IF cl_chk_act_auth() THEN
                  #CALL t710_x()                     #FUN-D20035
                   CALL t710_x(1)                     #FUN-D20035
                   IF g_ala.alafirm = 'X' THEN
                      LET g_void = 'Y'
                   ELSE
                      LET g_void = 'N'
                   END IF
                   CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
                END IF

           #FUN-D20035----add--str
           WHEN "undo_void"
                IF cl_chk_act_auth() THEN
                   CALL t710_x(2)           
                   IF g_ala.alafirm = 'X' THEN
                      LET g_void = 'Y'
                   ELSE
                      LET g_void = 'N'
                   END IF
                   CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
                END IF
           #FUN-D20035----add--end  

           WHEN "help"
                CALL cl_show_help()
           WHEN "exit"
                EXIT WHILE
           WHEN "controlg"
                CALL cl_cmdask()
 
           WHEN "exporttoexcel"
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel
                  (ui.Interface.getRootNode(),base.TypeInfo.create(g_alb),'','')
               END IF
 
           WHEN "related_document"  #相關文件
                IF cl_chk_act_auth() THEN
                   IF g_ala.ala01 IS NOT NULL THEN
                   LET g_doc.column1 = "ala01"
                   LET g_doc.value1 = g_ala.ala01
                   CALL cl_doc()
                 END IF
           END IF
    END CASE
   END WHILE
   CLOSE t710_cs
END FUNCTION
 
FUNCTION t710_menu0()
   LET g_action_choice=" "
 
   WHILE TRUE
      CALL t710_bp0("G")
      CASE g_action_choice
           WHEN "query"
                IF cl_chk_act_auth() THEN
                   CALL t710_q()
                END IF
           WHEN "modify"
                IF cl_chk_act_auth() THEN
                   CALL t710_u()
                END IF
           WHEN "delete"
                IF cl_chk_act_auth() THEN
                   CALL t710_r()
                END IF
           WHEN "detail"
                IF cl_chk_act_auth() THEN
                   CALL t710_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "output"
                CALL t710_out('a')
           WHEN "gen_entry"
                CALL t710_g_gl(g_ala.ala01,4,0)
                CALL t710_npp02()
           WHEN "maintain_entry"
                CALL s_fsgl('LC',4,g_ala.ala01,0,g_apz.apz02b,0,g_ala.alafirm,'0',g_apz.apz02p)  #No.FUN-680029 add '0',g_apz.apz02p
           WHEN "maintain_entry2"
                CALL s_fsgl('LC',4,g_ala.ala01,0,g_apz.apz02c,0,g_ala.alafirm,'1',g_apz.apz02p)
           WHEN "other_data"
                IF cl_chk_act_auth() THEN
                   CALL t710_7('2')
                END IF
           WHEN "modify_lc_no"
                IF cl_chk_act_auth() THEN
                   CALL t710_8()
                END IF
           WHEN "payment_acct"
                CALL t710_s(2)
           WHEN "confirm"
                IF cl_chk_act_auth() THEN
                   CALL t710_firm1()
                   IF g_ala.alafirm = 'X' THEN
                      LET g_void = 'Y'
                   ELSE
                      LET g_void = 'N'
                   END IF
                   CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
                END IF
           WHEN "undo_confirm"
                IF cl_chk_act_auth() THEN
                   CALL t710_firm2()
                   IF g_ala.alafirm = 'X' THEN
                      LET g_void = 'Y'
                   ELSE
                      LET g_void = 'N'
                   END IF
                   CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
                END IF
           WHEN "memo"
                IF cl_chk_act_auth() THEN
                   CALL t710_m()
                END IF
           WHEN "payment_record"
                LET g_msg="aapt711 '",g_ala.ala01,"'"
                CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
           WHEN "bl"
                CALL t710_g()
           WHEN "arriving_note"
                CALL t710_j()
           WHEN "arrivals"
                CALL t710_k()
           WHEN "close_the_case"
                LET g_msg="aapt750 '",g_ala.ala01,"'"
                CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
           WHEN "update_log"
                LET g_alc02 = 0
                SELECT MAX(alc02) INTO g_alc02 FROM alc_file
                  WHERE alc01 = g_ala.ala01
                    AND alcfirm <> 'X' #CHI-C80041
                LET g_msg="aapq700 '",g_ala.ala01,"' '", g_alc02,"'"
                CALL cl_cmdrun(g_msg)
           WHEN "cr_balance"
                IF not cl_null(g_ala.ala33) THEN
                   CALL s_credit2('Y',g_ala.ala07,g_ala.ala33,g_ala.ala35)
                      RETURNING amty,amtu,u_amty,u_amtu,bal
                END IF 
           #--FUN-B10030--start--
          # WHEN "switch_plant"
          #      CALL t710_d()
          #--FUN-B10030--end--
           WHEN "void"
               IF cl_chk_act_auth() THEN
                 #CALL t710_x()                  #FUN-D20035
                  CALL t710_x(1)                  #FUN-D20035
                  IF g_ala.alafirm = 'X' THEN
                     LET g_void = 'Y'
                  ELSE
                     LET g_void = 'N'
                  END IF
                  CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
               END IF

           #FUN-D20035---ADD---STR
           WHEN "undo_void"
               IF cl_chk_act_auth() THEN
                  CALL t710_x(2)                
                  IF g_ala.alafirm = 'X' THEN
                     LET g_void = 'Y'
                  ELSE
                     LET g_void = 'N'
                  END IF
                  CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
               END IF
           #FUN-D20035---ADD--END

           WHEN "help"
               CALL cl_show_help()
           WHEN "exit"
               EXIT WHILE
           WHEN "controlg"
               CALL cl_cmdask()
 
           WHEN "exporttoexcel"
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel
                  (ui.Interface.getRootNode(),base.TypeInfo.create(g_alb),'','')
               END IF
           WHEN "carry_voucher"
               IF cl_chk_act_auth() THEN
                  IF g_ala.alafirm = 'Y' THEN
                     CALL t710_carry_voucher()
                  ELSE 
                     CALL cl_err('','atm-402',1)
                  END IF
               END IF
           WHEN "undo_carry_voucher"
               IF cl_chk_act_auth() THEN
                  IF g_ala.alafirm = 'Y' THEN
                     CALL t710_undo_carry_voucher()
                  ELSE 
                     CALL cl_err('','atm-403',1)
                  END IF
               END IF
           WHEN "related_document"  #相關文件
                IF cl_chk_act_auth() THEN
                   IF g_ala.ala01 IS NOT NULL THEN
                   LET g_doc.column1 = "ala01"
                   LET g_doc.value1 = g_ala.ala01
                   CALL cl_doc()
                 END IF
           END IF
    END CASE
   END WHILE
    CLOSE t710_cs
END FUNCTION
 
FUNCTION t710_a()
 
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_alb.clear()
   INITIALIZE g_ala.* LIKE ala_file.*
   LET g_ala_o.* = g_ala.*                      #MOD-A80215
   LET g_ala_t.* = g_ala.*
   LET g_ala01_t = NULL
   LET g_ala.ala97=g_plant                      #No.FUN-980017
   LET g_ala.ala08 = g_today LET g_ala.ala21 = 0
   LET g_ala.ala22 = 0 LET g_ala.ala23 = 0
   LET g_ala.ala24 = 0 LET g_ala.ala34 = 0
   LET g_ala.ala25 = 0 LET g_ala.ala26 = 0 LET g_ala.ala51 = 1
   LET g_ala.ala52 = 0 LET g_ala.ala53 = 0 LET g_ala.ala54 = 0
   LET g_ala.ala55 = 0 LET g_ala.ala56 = 0 LET g_ala.ala57 = 0
   LET g_ala.ala59 = 0 LET g_ala.ala60 = 0 LET g_ala.ala61 = 0
   LET g_ala.ala78 = 'N' LET g_ala.ala79 = 1
   LET g_ala.alamksg = 'N' LET g_ala.alafirm = 'N' LET g_ala.alaclos = 'N'
   LET g_ala.ala04=g_grup #FUN-680019
   LET g_ala.ala930=s_costcenter(g_ala.ala04) #FUN-680019
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_ala.alaacti ='Y'                   # 有效的資料
      LET g_ala.alauser = g_user
      LET g_ala.alaoriu = g_user #FUN-980030
      LET g_ala.alaorig = g_grup #FUN-980030
      LET g_ala.alagrup = g_grup               # 使用者所屬群
      LET g_ala.aladate = g_today
      LET g_ala.alainpd = g_today
      LET g_ala.alalegal = g_legal #FUN-980001 add
 
     IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
        LET g_ala.ala01 = g_argv1
     END IF
 
      CALL t710_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_ala.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_alb.clear()
         EXIT WHILE
      END IF
      IF g_ala.ala01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
     IF cl_null(g_ala.ala85) THEN LET g_ala.ala85=0 END IF
     IF cl_null(g_ala.ala95) THEN LET g_ala.ala95=0 END IF
      INSERT INTO ala_file VALUES(g_ala.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      ELSE
         LET g_ala_t.* = g_ala.*               # 保存上筆資料
         SELECT ala01 INTO g_ala.ala01 FROM ala_file
          WHERE ala01 = g_ala.ala01
      END IF
      CALL g_alb.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      CALL t710_b()
      IF NOT cl_null(g_ala.ala01) THEN  #是否馬上列印
         IF cl_confirm('mfg3242') THEN
            CALL t710_out('a')
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t710_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_pmc03         LIKE pmc_file.pmc03,
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,               #單別  #No.FUN-690028 VARCHAR(5)
                                               #No.FUN-550030
        l_dept          LIKE ala_file.ala04,          #FUN-660117
        l_nnp06         LIKE nnp_file.nnp06,
        l_amt           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
        l_pma11         LIKE pma_file.pma11,
        l_nno02         LIKE nno_file.nno02,
        l_cnt           LIKE type_file.num5,   #No.FUN-690028 SMALLINT
        l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
    DEFINE l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal  LIKE ala_file.ala23   #MOD-A90075
    DEFINE l_aps14      LIKE aps_file.aps14,      #MOD-BC0258 add
           l_aps141     LIKE aps_file.aps141,     #MOD-BC0258 add
           l_aps22      LIKE aps_file.aps22,      #MOD-BC0258 add
           l_aps221     LIKE aps_file.aps221      #MOD-BC0258 add
    DEFINE l_ala23      LIKE ala_file.ala23       #MOD-C10185 add
    DEFINE l_ala79      LIKE ala_file.ala79       #MOD-C20027 add

    CALL cl_set_head_visible("","YES")         #No.FUN-6B0033			
 
    INPUT BY NAME g_ala.alaoriu,g_ala.alaorig,g_ala.ala97,g_ala.ala01,g_ala.ala72,g_ala.ala03,              #No.FUN-980017
                  g_ala.ala04,g_ala.ala930,g_ala.ala08,g_ala.ala11,g_ala.ala05, #FUN-680019
                  g_ala.ala06,g_ala.ala02,g_ala.ala20,g_ala.ala23,
                  g_ala.ala21,g_ala.ala34,g_ala.ala51,g_ala.ala52,
                  g_ala.ala56,g_ala.ala53,g_ala.ala54,g_ala.ala59,
                  g_ala.alafirm,g_ala.alaclos,g_ala.ala33,g_ala.ala35,
                   g_ala.ala07,g_ala.ala22,g_ala.ala77,g_ala.ala79,  #MOD-4C0040
                  g_ala.ala24,g_ala.ala25,g_ala.ala26,g_ala.ala60,
                  g_ala.ala61,g_ala.ala41,g_ala.ala42,g_ala.ala411,g_ala.ala421,g_ala.alauser,  #No.FUN-680029 add g_ala.ala411,g_ala.ala421
                  g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
                  g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
                  g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
                  g_ala.alaud13,g_ala.alaud14,g_ala.alaud15, 
                  g_ala.alagrup,g_ala.alamodu,g_ala.aladate 
         WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t710_set_entry(p_cmd)
          CALL t710_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
       AFTER FIELD ala97
          IF NOT cl_null(g_ala.ala97) THEN
             SELECT count(*) INTO g_cnt FROM azw_file WHERE azw01 = g_ala.ala97
                AND azw02 = g_legal  
             IF g_cnt = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)
               NEXT FIELD ala97 
             END IF
          END IF 

       AFTER FIELD ala01
          IF NOT cl_null(g_ala.ala01) THEN
             IF (g_ala.ala01 != g_ala01_t) OR (g_ala01_t IS NULL) THEN
                SELECT COUNT(*) INTO g_cnt FROM ala_file
                 WHERE ala01 = g_ala.ala01
                IF g_cnt > 0 THEN                   # 資料重複
                   CALL cl_err(g_ala.ala01,-239,0)
                   LET g_ala.ala01 = g_ala01_t
                   DISPLAY BY NAME g_ala.ala01
                   NEXT FIELD ala01
                END IF
             END IF
             IF cl_null(g_ala.ala03) THEN
                LET g_ala.ala03=g_ala.ala01
                DISPLAY BY NAME g_ala.ala03
             END IF
          END IF
 
       AFTER FIELD ala02
          IF NOT cl_null(g_ala.ala02) THEN
             #No.TQC-BB0147  --Begin
             #SELECT COUNT(*) INTO l_cnt FROM pma_file
             # WHERE pma01 = g_ala.ala02
             #   AND pma11 IN ('3','4','6','7','8')   #MOD-630109   #MOD-790011
             #IF l_cnt = 0 THEN
             #   CALL cl_err('sel pma:','aap-016',0)
             #   NEXT FIELD ala02
             #END IF
             IF g_ala_o.ala02 IS NULL OR g_ala.ala02 != g_ala_o.ala02 THEN     
                CALL t710_ala02('a')     
                IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_ala.ala02,g_errno,0)
                   LET g_ala.ala02 = g_ala_t.ala02
                   DISPLAY BY NAME g_ala.ala02
                   NEXT FIELD ala02
                END IF
             END IF
             #No.TQC-BB0147  --End
          END IF
 
       AFTER FIELD ala04
          IF NOT cl_null(g_ala.ala04) THEN
             IF g_ala_t.ala04 IS NULL OR g_ala.ala04 != g_ala_t.ala04 THEN
                CALL t710_ala04('a')                 # 帳款部門
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala04,g_errno,0)
                   LET g_ala.ala04 = g_ala_t.ala04
                   DISPLAY BY NAME g_ala.ala04
                   NEXT FIELD ala04
                END IF
             END IF
          END IF
         #------------------------------MOD-BC0258---------------------------start
          IF g_apz.apz13 = 'Y' THEN
             LET l_dept = g_ala.ala04
          ELSE
             LET l_dept = ' '
          END IF

          SELECT aps14,aps22 INTO l_aps14,l_aps22
            FROM aps_file                               # 部門預設會計科目檔
           WHERE aps01 = l_dept                         # 部門編號
          IF STATUS THEN RETURN END IF
          LET g_ala.ala41 = l_aps14
          LET g_ala.ala42 = l_aps22
          DISPLAY BY NAME g_ala.ala41,g_ala.ala42
          IF g_aza.aza63 = 'Y' THEN
             SELECT aps141,aps221 INTO l_aps141,l_aps221
               FROM aps_file
              WHERE aps01 = l_dept
             IF STATUS THEN RETURN END IF
             LET g_ala.ala411 = l_aps141
             LET g_ala.ala421 = l_aps221
             DISPLAY BY NAME g_ala.ala411,g_ala.ala421
          END IF
         #------------------------------MOD-BC0258-----------------------------end
 
       AFTER FIELD ala08
          IF cl_null(g_ala.ala77) AND NOT cl_null(g_ala.ala08) THEN
             LET g_ala.ala77 = g_ala.ala08
             DISPLAY BY NAME g_ala.ala77
          END IF
 
       AFTER FIELD ala05
          IF NOT cl_null(g_ala.ala05) THEN
             IF g_ala_o.ala05 IS NULL OR g_ala.ala05 != g_ala_o.ala05 THEN     #TQC-5C0095
                CALL t710_ala05('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala05,g_errno,0)
                   LET g_ala.ala05 = g_ala_t.ala05
                   DISPLAY BY NAME g_ala.ala05
                   NEXT FIELD ala05
                END IF
             END IF
          END IF
          LET g_ala_o.ala05 = g_ala.ala05   #TQC-5C0095
 
       AFTER FIELD ala06
          IF NOT cl_null(g_ala.ala06) THEN
             IF g_ala.ala06 = 'MISC' THEN
                NEXT FIELD ala06
             ELSE
                CALL t710_ala06('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala06,g_errno,0)
                   LET g_ala.ala06 = g_ala_t.ala06
                   DISPLAY BY NAME g_ala.ala06
                   NEXT FIELD ala06
                END IF
             END IF
          END IF
        AFTER FIELD alaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       BEFORE FIELD ala33
         CALL t710_set_entry(p_cmd)
 
        AFTER FIELD ala77                                                                                                           
          IF NOT cl_null(g_ala.ala77) THEN
             CALL t710_bookno()
          END IF                                                                                                        
 
       AFTER FIELD ala33
          SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01=g_ala.ala02
          IF (l_pma11 = "3") OR (l_pma11 = "8") THEN

          END IF
          CALL t710_ala33('1')
         #-MOD-A90075-add-
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_ala.ala33,g_errno,0)
             LET g_ala.ala33 = g_ala_t.ala33
             DISPLAY BY NAME g_ala.ala33
             NEXT FIELD ala33
          END IF
         #-MOD-A90075-end-
          CALL t710_set_no_entry(p_cmd)
          IF cl_null(g_ala.ala33) THEN
             LET g_ala.ala35 = NULL
             LET g_ala.ala07 = NULL
             DISPLAY BY NAME g_ala.ala35,g_ala.ala07
          #No.TQC-BB0233  --Begin
          ELSE 
             IF g_ala.ala53 = 0 THEN 
                SELECT nnp06 INTO l_nnp06 FROM nnp_file
                 WHERE nnp01=g_ala.ala33 AND nnp03=g_ala.ala35
                IF STATUS THEN LET l_nnp06=0 END IF
                LET g_ala.ala53 = g_ala.ala23 * l_nnp06/100 * g_ala.ala51
                DISPLAY BY NAME g_ala.ala53
             END IF
          #No.TQC-BB0233  --End
          END IF
 
       AFTER FIELD ala35
          CALL t710_ala33('2')
         #-MOD-A90075-add-
          IF NOT cl_null(g_ala.ala35) AND NOT cl_null(g_errno) THEN 
              CALL cl_err(g_ala.ala35,g_errno,0)
              LET g_ala.ala35=g_ala_o.ala35
              DISPLAY BY NAME g_ala.ala35
              NEXT FIELD ala33
          END IF
         #-MOD-A90075-end-
          IF NOT cl_null(g_ala.ala35) AND (g_ala.ala33 IS NOT NULL) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM nnp_file
              WHERE nnp01=g_ala.ala33 AND nnp03 = g_ala.ala35
             IF l_cnt = 0 THEN
                CALL cl_err(g_ala.ala35,'anm-161',0)
                NEXT FIELD ala35
             END IF
             SELECT nnn02 INTO l_nnn02 FROM nnn_file
              WHERE nnn01=g_ala.ala35 AND nnnacti='Y'
             IF STATUS THEN
                CALL cl_err(g_ala.ala35,'anm-601',0)
                LET l_nnn02 =''
                DISPLAY l_nnn02 TO FORMONLY.nnn02
                NEXT FIELD ala35
             END IF
            #-------------------------MOD-C20027-----------------------start
             SELECT nnp08 INTO l_ala79
               FROM nnp_file
              WHERE nnp01 = g_ala.ala33
                AND nnp03 = g_ala.ala35
             LET g_ala.ala79 = l_ala79
             DISPLAY BY NAME g_ala.ala79
            #-------------------------MOD-C20027-------------------------end
          ELSE
             LET g_ala.ala35=''
             LET l_nnn02=''
          END IF
          DISPLAY l_nnn02 TO FORMONLY.nnn02
          DISPLAY BY NAME g_ala.ala35
 
       AFTER FIELD ala07
           IF cl_null(l_pma11) THEN
              SELECT pma11 INTO l_pma11 FROM pma_file
               WHERE pma01=g_ala.ala02 AND pmaacti = 'Y'
              IF cl_null(l_pma11) THEN LET l_pma11 = ' ' END IF
           END IF
 
           IF NOT cl_null(g_ala.ala07) THEN
              IF ( l_pma11='3' OR l_pma11='8') THEN
                SELECT nno02 INTO l_nno02 FROM nno_file WHERE nno01=g_ala.ala33
                                                          AND nno09='N'
                IF SQLCA.sqlcode THEN LET l_nno02 = ' ' END IF
                IF g_ala.ala07 != l_nno02 THEN
                   CALL cl_err(l_nno02,'aap-906',0)
                   LET g_ala.ala07 = l_nno02
                   DISPLAY BY NAME g_ala.ala07
                   NEXT FIELD ala07
                END IF
                CALL t710_ala07('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala07,g_errno,0)
                   LET g_ala.ala07 = g_ala_t.ala07
                   DISPLAY BY NAME g_ala.ala07
                   NEXT FIELD ala07
                END IF
              END IF
           END IF
 
       AFTER FIELD ala20
          IF NOT cl_null(g_ala.ala20) THEN
             IF p_cmd = 'a' OR g_ala.ala20 != g_ala_t.ala20 THEN
                CALL t710_ala20('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala20,g_errno,0)
                   NEXT FIELD ala20
                END IF
             END IF
          END IF

       BEFORE FIELD ala23             #MOD-B90274
          SELECT azi04 INTO t_azi04   #MOD-B90274 
            FROM azi_file             #MOD-B90274
           WHERE azi01=g_ala.ala20    #MOD-B90274
 
       AFTER FIELD ala23
          IF NOT cl_null(g_ala.ala23) THEN
             IF (g_ala_o.ala23 IS NULL) OR (g_ala_o.ala23 != g_ala.ala23) THEN   #MOD-5C0170
                IF g_ala.ala23 = 0 THEN
                   NEXT FIELD ala23
                END IF
                LET g_ala.ala34 = g_ala.ala23 * g_ala.ala21 / 100
                LET g_ala.ala34 = cl_digcut(g_ala.ala34,t_azi04)  #MOD-B90274
                DISPLAY BY NAME g_ala.ala34
                IF g_ala.ala51 > 0 THEN
                   LET g_ala.ala52 = g_ala.ala34 * g_ala.ala51   #MOD-5C0104
                   LET g_ala.ala52 = cl_digcut(g_ala.ala52,g_azi04)
                   DISPLAY BY NAME g_ala.ala52
                   CALL t710_ala59()  #MOD-C30614
                END IF
             END IF   #MOD-5C0170
             LET g_ala_o.ala23 = g_ala.ala23   #MOD-5C0170
          END IF
 
       AFTER FIELD ala21
          IF NOT cl_null(g_ala.ala21) THEN
             IF (g_ala_o.ala21 IS NULL) OR (g_ala_o.ala21 != g_ala.ala21) THEN   #MOD-5C0170
                LET g_ala.ala34 = g_ala.ala23 * g_ala.ala21 / 100
                LET g_ala.ala34 = cl_digcut(g_ala.ala34,t_azi04)  #MOD-B90274
                DISPLAY BY NAME g_ala.ala34
                IF g_ala.ala51 > 0 THEN
                   LET g_ala.ala52 = g_ala.ala34 * g_ala.ala51
                   LET g_ala.ala52 = cl_digcut(g_ala.ala52,g_azi04)
                   DISPLAY BY NAME g_ala.ala52
                   CALL t710_ala59()  #MOD-C30614
                END IF
             END IF
             LET g_ala_o.ala21 = g_ala.ala21
          END IF
 
      AFTER FIELD ala34
         IF NOT cl_null(g_ala.ala34) THEN
            IF (g_ala_o.ala34 IS NULL) OR (g_ala_o.ala34 != g_ala.ala34) THEN
               IF g_ala.ala51 > 0 THEN
                  LET g_ala.ala52 = g_ala.ala34 * g_ala.ala51
                  LET g_ala.ala52 = cl_digcut(g_ala.ala52,g_azi04)
                  DISPLAY BY NAME g_ala.ala52
                  CALL t710_ala59()  #MOD-C30614
               END IF
            END IF
            LET g_ala_o.ala34 = g_ala.ala34
         END IF
         LET g_ala.ala34 = cl_digcut(g_ala.ala34,t_azi04)  #MOD-B90274
         DISPLAY BY NAME g_ala.ala34                       #MOD-B90274
 
       AFTER FIELD ala51
          IF NOT cl_null(g_ala.ala51) THEN
              IF (g_ala_t.ala51 IS NULL) OR (g_ala_t.ala51 != g_ala.ala51) THEN  #No.MOD-530832
                IF g_ala.ala20 =g_aza.aza17 THEN
                   LET g_ala.ala51=1
                   DISPLAY BY NAME g_ala.ala51
               ELSE
                  SELECT azi07 INTO t_azi07 FROM azi_file
                     WHERE azi01=g_ala.ala20
                  LET g_ala.ala51 = cl_digcut(g_ala.ala51,t_azi07)
                  DISPLAY BY NAME g_ala.ala51
                END IF
               IF g_ala.ala51 > 0 THEN
                  LET g_ala.ala52 = g_ala.ala34 * g_ala.ala51   #MOD-5C0104
                  LET g_ala.ala52 = cl_digcut(g_ala.ala52,g_azi04)
                  DISPLAY BY NAME g_ala.ala52
               END IF
                SELECT nnp06 INTO l_nnp06 FROM nnp_file
                 WHERE nnp01=g_ala.ala33 AND nnp03=g_ala.ala35
                IF STATUS THEN LET l_nnp06=0 END IF
                LET g_ala.ala53 = g_ala.ala23 * l_nnp06/100 * g_ala.ala51
                LET g_ala.ala53 = cl_digcut(g_ala.ala53,g_azi04)                #MOD-C30690 add
                DISPLAY BY NAME g_ala.ala53
                CALL t710_ala59()
             END IF
             LET g_ala_t.ala51 = g_ala.ala51   #TQC-5C0025
          END IF
 
       AFTER FIELD ala56
          IF NOT cl_null(g_ala.ala56) THEN
             LET g_ala.ala56 = cl_digcut(g_ala.ala56,g_azi04)                #MOD-C30690 add
             CALL t710_ala59()
             DISPLAY BY NAME g_ala.ala56                                     #MOD-C30690 add
          END IF
 
      AFTER FIELD ala53
         IF NOT cl_null(g_ala.ala53) THEN
            LET g_ala.ala53 = cl_digcut(g_ala.ala53,g_azi04)                #MOD-C30690 add
            CALL t710_ala59()
            DISPLAY BY NAME g_ala.ala53                                     #MOD-C30690 add
         END IF
 
      AFTER FIELD ala52
         IF NOT cl_null(g_ala.ala52) THEN
            LET g_ala.ala52 = cl_digcut(g_ala.ala52,g_azi04)                #MOD-C30690 add
            CALL t710_ala59()
            DISPLAY BY NAME g_ala.ala52                                     #MOD-C30690 add
         END IF
 
      AFTER FIELD ala54
         IF NOT cl_null(g_ala.ala54) THEN
            LET g_ala.ala54 = cl_digcut(g_ala.ala54,g_azi04)                #MOD-C30690 add
            CALL t710_ala59()
            DISPLAY BY NAME g_ala.ala54                                     #MOD-C30690 add
         END IF
 
       AFTER FIELD ala41            # 會計科目, 可空白, 須存在
          IF NOT cl_null(g_ala.ala41) THEN
             IF (g_ala_t.ala41 IS NULL) OR (g_ala.ala41 != g_ala_t.ala41) THEN
                CALL s_aapact('2',g_bookno1,g_ala.ala41) RETURNING g_msg   #No:8727    #No.FUN-730064 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala41,g_errno,0)
 
#No.FUN-B20059 --begin
#                  LET g_ala.ala41 = g_ala_t.ala41                   
                   CALL q_aapact(FALSE,FALSE,'2',g_ala.ala41,g_bookno1)   #No:8727  #No.FUN-730064 
                   RETURNING g_ala.ala41
#No.FUN-B20059 --end
                   DISPLAY BY NAME g_ala.ala41
                   NEXT FIELD ala41
                END IF
             END IF
          END IF
 
       AFTER FIELD ala411
          IF NOT cl_null(g_ala.ala411) THEN
             IF (g_ala_t.ala411 IS NULL) OR (g_ala.ala411 != g_ala_t.ala411) THEN
                CALL s_aapact('2',g_bookno2,g_ala.ala411) RETURNING g_msg     #No.FUN-730064 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala411,g_errno,0)
#No.FUN-B20059 --begin
#                   LET g_ala.ala411 = g_ala_t.ala411
                   CALL q_aapact(FALSE,FALSE,'2',g_ala.ala411,g_bookno2)     #No.FUN-730064
                          RETURNING g_ala.ala411
#No.FUN-B20059 --end
                   DISPLAY BY NAME g_ala.ala411
                   NEXT FIELD ala411
                END IF
             END IF
          END IF
 
       AFTER FIELD ala42            # 會計科目, 可空白, 須存在
          IF NOT cl_null(g_ala.ala42) THEN
             IF (g_ala_t.ala42 IS NULL) OR (g_ala.ala42 != g_ala_t.ala42) THEN
                CALL s_aapact('2',g_bookno1,g_ala.ala42) RETURNING g_msg   #No:8727   #No.FUN-730064 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala42,g_errno,0)
#No.FUN-B20059 --begin
#                   LET g_ala.ala42 = g_ala_t.ala42
                   CALL q_aapact(FALSE,FALSE,'2',g_ala.ala42,g_bookno1)   #No:8727    #No.FUN-730064
                        RETURNING g_ala.ala42
#No.FUN-B20059 --end
                   DISPLAY BY NAME g_ala.ala42
                   NEXT FIELD ala42
                END IF
             END IF
          END IF
          
       AFTER FIELD ala421
          IF NOT cl_null(g_ala.ala421) THEN
             IF (g_ala_t.ala421 IS NULL) OR (g_ala.ala421 != g_ala_t.ala421) THEN
                CALL s_aapact('2',g_bookno2,g_ala.ala421) RETURNING g_msg   #No.FUN-730064 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ala.ala421,g_errno,0)
#No.FUN-B20059 --begin
#                   LET g_ala.ala421 = g_ala_t.ala421
                   CALL q_aapact(FALSE,FALSE,'2',g_ala.ala421,g_bookno2)   #No.FUN-730064 
                        RETURNING g_ala.ala421
#No.FUN-B20059 --end
                   DISPLAY BY NAME g_ala.ala421
                   NEXT FIELD ala421
                END IF
             END IF
          END IF
 
       AFTER FIELD ala930 
          IF NOT s_costcenter_chk(g_ala.ala930) THEN
             LET g_ala.ala930=g_ala_t.ala930
             DISPLAY BY NAME g_ala.ala930
             DISPLAY NULL TO gem02b
             NEXT FIELD ala930
          ELSE
             DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b
          END IF
 
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT END IF
 
       ON KEY(F1) NEXT FIELD ala01
 
       ON KEY(F2) NEXT FIELD ala07
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ala02) # PAY TERM
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pma01"   #TQC-5C0095
                LET g_qryparam.default1 = g_ala.ala02
                CALL cl_create_qry() RETURNING g_ala.ala02
                DISPLAY BY NAME g_ala.ala02
             WHEN INFIELD(ala05) #PAY TO VENDOR
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc"
                LET g_qryparam.default1 = g_ala.ala05
                CALL cl_create_qry() RETURNING g_ala.ala05
                DISPLAY BY NAME g_ala.ala05
                CALL t710_ala05('d')
             WHEN INFIELD(ala06) #PAY TO VENDOR
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc"
                LET g_qryparam.default1 = g_ala.ala06
                CALL cl_create_qry() RETURNING g_ala.ala06
                DISPLAY BY NAME g_ala.ala06
                CALL t710_ala06('d')
             WHEN INFIELD(ala07) #PAY BANK
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_alg"
                LET g_qryparam.default1 = g_ala.ala07
                CALL cl_create_qry() RETURNING g_ala.ala07
                DISPLAY BY NAME g_ala.ala07
                CALL t710_ala07('d')
             WHEN INFIELD(ala20) # CURRENCY
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azi"
                LET g_qryparam.default1 = g_ala.ala20
                CALL cl_create_qry() RETURNING g_ala.ala20
                DISPLAY BY NAME g_ala.ala20
             WHEN INFIELD(ala04) # Dept CODE
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem"
                LET g_qryparam.default1 = g_ala.ala04
                CALL cl_create_qry() RETURNING g_ala.ala04
                DISPLAY BY NAME g_ala.ala04
                CALL t710_ala04('d')    #TQC-BB0140
             WHEN INFIELD(ala33) #合約號碼
                CALL q_nnp01(0,1,g_ala.ala33,'')     #TQC-C80198  add  ''
                     RETURNING g_ala.ala33
                DISPLAY BY NAME g_ala.ala33
             WHEN INFIELD(ala35) #融資種類
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_nnn01"  #TQC-5C0095
                LET g_qryparam.arg1 = g_ala.ala33   #TQC-5C0095
                LET g_qryparam.default1 = g_ala.ala35
                CALL cl_create_qry() RETURNING g_ala.ala35,l_nnn02
                DISPLAY BY NAME g_ala.ala35
                DISPLAY l_nnn02 TO FORMONLY.nnn02
             WHEN INFIELD(ala41) # Account number
                CALL q_aapact(FALSE,TRUE,'2',g_ala.ala41,g_bookno1)   #No:8727  #No.FUN-730064 
                RETURNING g_ala.ala41
                DISPLAY BY NAME g_ala.ala41
             WHEN INFIELD(ala42) # Account number
                CALL q_aapact(FALSE,TRUE,'2',g_ala.ala42,g_bookno1)   #No:8727    #No.FUN-730064
                RETURNING g_ala.ala42
                DISPLAY BY NAME g_ala.ala42
             WHEN INFIELD(ala411)
                CALL q_aapact(FALSE,TRUE,'2',g_ala.ala411,g_bookno2)     #No.FUN-730064
                RETURNING g_ala.ala411
                DISPLAY BY NAME g_ala.ala411
             WHEN INFIELD(ala421)
                CALL q_aapact(FALSE,TRUE,'2',g_ala.ala421,g_bookno2)   #No.FUN-730064 
                RETURNING g_ala.ala421
                DISPLAY BY NAME g_ala.ala421
             WHEN INFIELD(ala51)
                CALL s_rate(g_ala.ala20,g_ala.ala51)
                RETURNING g_ala.ala51
                DISPLAY BY NAME g_ala.ala51
                NEXT FIELD ala51
             WHEN INFIELD(ala79)  #MOD-4B0295
               CALL s_rate(g_ala.ala20,g_ala.ala79)
               RETURNING g_ala.ala79
               DISPLAY BY NAME g_ala.ala79
               NEXT FIELD ala79
             WHEN INFIELD(ala930)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_ala.ala930
                DISPLAY BY NAME g_ala.ala930
                NEXT FIELD ala930
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
 
 
    END INPUT
   #-MOD-A90075-add-
    CALL s_credit2('N',g_ala.ala07,g_ala.ala33,g_ala.ala35)   
                 RETURNING l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal
                         # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
   #------------------MOD-C10185---------------------------------start
    LET l_ala23 = g_ala.ala23 * g_ala.ala51
    CALL cl_digcut(l_ala23,g_azi04) RETURNING l_ala23

    #--CHI-C90047 start--s_credit2此時傳回的金額都是合約幣別，直接拿l_bal和l_ala23來比對，可能會有幣別不相同的狀況
    #應該要判斷這個ala20是否同於合約幣別，如果不同要先都換算為本幣後才能進行l_bal和l_ala23做比對
    
    SELECT nno06 INTO g_nno06 FROM nno_file 
     WHERE nno01 = g_ala.ala33
       AND nno09='N'
   IF NOT cl_null(g_nno06) AND g_nno06 <> g_ala.ala20 THEN
       CALL s_curr3(g_nno06,g_ala.ala08,'B') RETURNING g_rate1  
       LET l_bal = l_bal * g_rate1 
       CALL cl_digcut(l_bal,g_azi04) RETURNING l_bal
   END IF
   #--CHI-C90047 end-------

    IF l_bal < l_ala23 THEN
   #IF l_bal < g_ala.ala23 THEN
   #------------------MOD-C10185---------------------------------start
       CALL cl_err('','anm-287',1)
    END IF
   #-MOD-A90075-end-
END FUNCTION
 
FUNCTION t710_ala59()
   IF g_ala.ala78='Y' THEN            # 若已付款, 則以付款為主
      LET g_ala.ala59 = g_ala.ala56 + g_ala.ala85 + g_ala.ala95
   ELSE
      LET g_ala.ala59 = g_ala.ala52 + g_ala.ala53 + g_ala.ala54 +
                        g_ala.ala55 + g_ala.ala56 + g_ala.ala57
   END IF
   DISPLAY BY NAME g_ala.ala59
END FUNCTION

#No.TQC-BB0147  --Begin
FUNCTION t710_ala02(p_cmd) #付款方式
   DEFINE   p_cmd        LIKE type_file.chr1,
            l_pma02      LIKE pma_file.pma02,
            l_pma11      LIKE pma_file.pma11,
            l_pmaacti    LIKE pma_file.pmaacti

   LET g_errno = ' '
   LET l_pma02 = ' '
   LET l_pma11 = ' '
   SELECT pma02,pma11,pmaacti
          INTO l_pma02,l_pma11,l_pmaacti
          FROM pma_file WHERE pma01 = g_ala.ala02

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                           LET l_pmaacti = NULL  LET l_pma02=NULL  LET l_pma11=NULL
        WHEN l_pmaacti='N' LET g_errno = '9028'
        WHEN l_pma11 NOT MATCHES '[3-8]' LET g_errno='aap-016'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_pma02 TO FORMONLY.pma02
END FUNCTION
#No.TQC-BB0147  --End
 
FUNCTION t710_ala04(p_cmd)
    #No.TQC-BB0140  --Begin
    #DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    #DEFINE l_gemacti LIKE gem_file.gemacti
    #DEFINE l_dept    LIKE ala_file.ala04  #FUN-660117
    #DEFINE l_aps11   LIKE aps_file.aps11
    #DEFINE l_aps14   LIKE aps_file.aps14
    #DEFINE l_aps22   LIKE aps_file.aps22
    #DEFINE l_aps24   LIKE aps_file.aps22
    #DEFINE l_aps111  LIKE aps_file.aps111
    #DEFINE l_aps141  LIKE aps_file.aps141
    #DEFINE l_aps221  LIKE aps_file.aps221
 
    #SELECT gemacti INTO l_gemacti
    #  FROM gem_file WHERE gem01 = g_ala.ala04
    #LET g_errno = ' '
    #CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
    #     WHEN l_gemacti = 'N'     LET g_errno = '9028'
    #     WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    #END CASE
    #IF NOT cl_null(g_errno) THEN RETURN END IF
    #IF p_cmd != 'a' THEN RETURN END IF
    #IF g_apz.apz13 = 'Y' THEN
    #   LET l_dept = g_ala.ala04
    #ELSE
    #   LET l_dept = ' '
    #END IF
    #SELECT aps11,aps14,aps22 INTO l_aps11,l_aps14,l_aps22
    #  FROM aps_file  # 部門預設會計科目檔
    # WHERE aps01 = l_dept     # 部門編號
    #IF STATUS THEN RETURN END IF
    #LET g_ala.ala41 = l_aps14
    #LET g_ala.ala42 = l_aps22
    #LET g_ala.ala43 = l_aps11
    #DISPLAY BY NAME g_ala.ala41,g_ala.ala42
    #IF g_aza.aza63 = 'Y' THEN
    #   SELECT aps111,aps141,aps221 INTO l_aps111,l_aps141,l_aps221
    #     FROM aps_file
    #    WHERE aps01 = l_dept
    #   IF STATUS THEN RETURN END IF
    #   LET g_ala.ala411 = l_aps141
    #   LET g_ala.ala421 = l_aps221
    #   LET g_ala.ala431 = l_aps111
    #   DISPLAY BY NAME g_ala.ala411,g_ala.ala421
    #END IF
    #LET g_ala.ala930= s_costcenter(g_ala.ala04) #FUN-680019
    #DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b #FUN-680019
    DEFINE p_cmd        LIKE type_file.chr1,
           l_gem02      LIKE gem_file.gem02,
           l_gemacti    LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01=g_ala.ala04

    CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-039'
                                      LET l_gem02 = ' '
         WHEN l_gemacti      ='N'     LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 

    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
    #No.TQC-BB0140  --End
  
END FUNCTION
 
FUNCTION t710_ala05(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc05   LIKE pmc_file.pmc05
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmc17   LIKE pmc_file.pmc17
    DEFINE l_pmc22   LIKE pmc_file.pmc22
    DEFINE l_pmc30   LIKE pmc_file.pmc30
    DEFINE l_pmc901  LIKE pmc_file.pmc901
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmc05,pmc17,pmc22,pmc30,pmc901,pmcacti
           INTO l_pmc03,l_pmc05,l_pmc17,l_pmc22,l_pmc30,l_pmc901,l_pmcacti
           FROM pmc_file
           WHERE pmc01 = g_ala.ala05
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
                                  LET l_pmc03=' '
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'   #NO.FUN-690024 add 
 
         WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'
         WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'
         WHEN l_pmc30   = '1'     LET g_errno = 'aap-103'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_pmc03 TO pmc03
    END IF
    IF g_ala_o.ala05 IS NULL OR g_ala.ala05 != g_ala_o.ala05 THEN   #TQC-5C0095
       LET g_ala.ala06 = l_pmc901
       LET g_ala.ala20 = l_pmc22
       LET g_ala.ala02 = l_pmc17
       DISPLAY BY NAME g_ala.ala02
       DISPLAY BY NAME g_ala.ala06,g_ala.ala20
    END IF
END FUNCTION
 
FUNCTION t710_ala06(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
    LET l_pmc03=''
    LET l_pmcacti=''
    SELECT pmc03,pmcacti
      INTO l_pmc03,l_pmcacti FROM pmc_file
     WHERE pmc01 = g_ala.ala06
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF p_cmd ='d' OR cl_null(g_errno) THEN
       DISPLAY l_pmc03 TO pmc03b
    END IF
END FUNCTION
 
FUNCTION t710_ala07(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_alg02 LIKE alg_file.alg02
    DEFINE l_nnp07 LIKE nnp_file.nnp07
 
    SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01 = g_ala.ala07
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-722'           #MOD-A90075 aap-772 -> aap-722
                                  LET l_alg02 =' '
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DISPLAY l_alg02 TO pmc03c
END FUNCTION
 
FUNCTION t710_ala20(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_ala.ala20
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
         WHEN l_aziacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF g_ala.ala51 = 1 AND g_ala.ala20 != g_aza.aza17 THEN
       CALL s_curr3(g_ala.ala20,g_ala.ala08,g_apz.apz33) RETURNING g_ala.ala51 #FUN-640022
       DISPLAY BY NAME g_ala.ala51
    END IF
END FUNCTION
 
FUNCTION t710_ala33(p_cmd)    #合約單號
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_nnoacti   LIKE nno_file.nnoacti
    DEFINE l_nno02     LIKE nno_file.nno02
    DEFINE l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal  LIKE ala_file.ala23   #MOD-A90075
    DEFINE l_ala23      LIKE ala_file.ala23                             #MOD-C10185 add
 
    LET g_errno = ' '
    IF p_cmd = '1' THEN     #check 合約單號
       SELECT nno02,nnoacti INTO l_nno02,l_nnoacti
         FROM nno_file WHERE nno01 = g_ala.ala33
          AND nno09='N'
       CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-630'
            WHEN l_nnoacti = 'N'     LET g_errno = '9028'
            WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
       END CASE
       IF NOT cl_null(g_errno) THEN RETURN END IF
       LET g_ala.ala07=l_nno02
       DISPLAY BY NAME g_ala.ala07
       CALL t710_ala07('d')      #信貸銀行
    ELSE                         #check融資種類
       SELECT nnp07 INTO g_nnp07 FROM nnp_file
        WHERE nnp01 = g_ala.ala33 AND nnp03=g_ala.ala35
       CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
            WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
       END CASE
      #-MOD-A90075-add-
       CALL s_credit2('N',g_ala.ala07,g_ala.ala33,g_ala.ala35)   
                    RETURNING l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal
                            # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
      #------------------MOD-C10185---------------------------------start
       LET l_ala23 = g_ala.ala23 * g_ala.ala51
       CALL cl_digcut(l_ala23,g_azi04) RETURNING l_ala23

       #--CHI-C90047 start--s_credit2此時傳回的金額都是合約幣別，直接拿l_bal和l_ala23來比對，可能會有幣別不相同的狀況
       #應該要判斷這個合約幣別是否為本幣，如果不同於本幣時要換算為本幣後才能拿來和l_ala23做比對
       
       SELECT nno06 INTO g_nno06 FROM nno_file 
        WHERE nno01 = g_ala.ala33
          AND nno09='N'
       IF NOT cl_null(g_nno06) AND g_nno06 <> g_ala.ala20 THEN
           CALL s_curr3(g_nno06,g_ala.ala08,'B') RETURNING g_rate1   
           LET l_bal = l_bal * g_rate1 
           CALL cl_digcut(l_bal,g_azi04) RETURNING l_bal
       END IF
       #--CHI-C90047 end-------
       IF l_bal < l_ala23 THEN
      #IF l_bal < g_ala.ala23 THEN
      #------------------MOD-C10185---------------------------------start
          LET g_errno = 'anm-287'
       END IF
      #-MOD-A90075-end-
    END IF
END FUNCTION
 
FUNCTION t710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_ala.ala01 = NULL                 #FUN-6A0016 add
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t710_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_ala.ala01 = NULL               #MOD-660086 add
      CLEAR FORM
      CALL g_alb.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t710_count
   FETCH t710_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
      INITIALIZE g_ala.* TO NULL
   ELSE
      CALL t710_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t710_fetch(p_flala)
   DEFINE
       p_flala       LIKE type_file.chr1        # No.FUN-690028   VARCHAR(1)
 
   CASE p_flala
      WHEN 'N' FETCH NEXT     t710_cs INTO g_ala.ala01
      WHEN 'P' FETCH PREVIOUS t710_cs INTO g_ala.ala01
      WHEN 'F' FETCH FIRST    t710_cs INTO g_ala.ala01
      WHEN 'L' FETCH LAST     t710_cs INTO g_ala.ala01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump t710_cs INTO g_ala.ala01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
      INITIALIZE g_ala.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flala
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_ala.* FROM ala_file       # 重讀DB,因TEMP有不被更新特性
    WHERE ala01 = g_ala.ala01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_ala.alauser     #No.FUN-4C0047
      LET g_data_group = g_ala.alagrup     #No.FUN-4C0047
      CALL t710_bookno()                   #No.FUN-730064
      CALL t710_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t710_show()
   LET g_ala_t.* = g_ala.*
   LET g_ala_o.* = g_ala.*   #TQC-5C0095
   DISPLAY BY NAME g_ala.alaoriu,g_ala.alaorig,
             g_ala.ala97,g_ala.ala01,g_ala.ala72,g_ala.ala03,g_ala.ala04,g_ala.ala930,    #FUN-680019         #No.FUN-980017
             g_ala.ala08   ,g_ala.ala11,g_ala.ala05,g_ala.ala06,g_ala.ala02,
             g_ala.ala20   ,g_ala.ala23,g_ala.ala21,g_ala.ala34,g_ala.ala51,
             g_ala.ala52   ,g_ala.ala56,g_ala.ala53,g_ala.ala54,g_ala.ala59,
             g_ala.alafirm ,g_ala.alaclos,
              g_ala.ala33   ,g_ala.ala35,g_ala.ala07,g_ala.ala22,g_ala.ala77,   #MOD-4C0040
             g_ala.ala79   ,
             g_ala.ala24   ,g_ala.ala25,g_ala.ala26,g_ala.ala60,g_ala.ala61,
             g_ala.ala41   ,g_ala.ala42,g_ala.ala411,g_ala.ala421,  #No.FUN-680029 add g_ala.ala411,g_ala.ala421
             g_ala.alauser,g_ala.alagrup,g_ala.alamodu,g_ala.aladate,
           g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
           g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
           g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
           g_ala.alaud13,g_ala.alaud14,g_ala.alaud15 
   SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01=g_ala.ala35
   IF STATUS THEN  LET l_nnn02=' ' END IF
   DISPLAY l_nnn02 TO FORMONLY.nnn02
   DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b #FUN-680019
   CALL t710_ala02('d')  #TQC-BB0147
   CALL t710_ala04('d')  #TQC-BB0140
   CALL t710_ala05('d')
   CALL t710_ala06('d')
   CALL t710_ala07('d')
   CALL t710_b_tot()
   CALL t710_b_fill(g_wc2)
 
   IF g_ala.alafirm = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t710_u()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_ala.ala01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
   IF g_ala.alafirm='Y' THEN CALL cl_err('firm=Y ','axm-101',0) RETURN END IF
   IF g_ala.alaclos='Y' THEN CALL cl_err('clos=Y ','aap-730',0) RETURN END IF
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_ala.alaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ala.ala01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t710_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_ala.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   LET g_ala01_t = g_ala.ala01
   LET g_ala_o.*=g_ala.*
   LET g_ala.alamodu=g_user                     #修改者
   LET g_ala.aladate = g_today                  #修改日期
   CALL t710_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t710_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ala.*=g_ala_t.*
         CALL t710_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE ala_file SET ala_file.* = g_ala.*    # 更新DB
       WHERE ala01 = g_ala.ala01             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      IF g_ala.ala01 != g_ala_t.ala01 THEN
         UPDATE alb_file SET alb01=g_ala.ala01 WHERE alb01=g_ala_t.ala01
         IF STATUS THEN
            CALL cl_err('upd alb01',STATUS,1)
            LET g_ala.*=g_ala_t.* CALL t710_show() ROLLBACK WORK RETURN
         END IF
      END IF
      IF g_ala_t.ala08 != g_ala.ala08  AND g_cmd='2' THEN
         UPDATE npp_file SET npp02=g_ala.ala08
          WHERE npp01=g_ala.ala01 AND npp011=0
            AND npp00 = 4         AND nppsys = 'LC'
         IF STATUS THEN CALL cl_err('upd npp02:',STATUS,1) END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t710_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t710_npp02()
   IF g_cmd='2' THEN
      IF cl_null(g_ala.ala72) THEN
          UPDATE npp_file SET npp02=g_ala.ala77     #MOD-4C0040   異動日以會計日期為基準
          WHERE npp01=g_ala.ala01 AND npp011=0 AND npp00 = 4 AND nppsys = 'LC'
         IF STATUS THEN CALL cl_err('upd npp02:',STATUS,1) END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION t710_8()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_ala.ala01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
   IF g_ala.ala24!=0 THEN CALL cl_err('ala24!=0','aap-732',0) RETURN END IF
   IF g_ala.ala25!=0 THEN CALL cl_err('ala25!=0','aap-732',0) RETURN END IF
   IF g_ala.ala26!=0 THEN CALL cl_err('ala26!=0','aap-732',0) RETURN END IF
   IF g_ala.alaclos='Y' THEN CALL cl_err('clos=Y','aap-730',0) RETURN END IF
   IF g_ala.alaacti ='N' THEN CALL cl_err(g_ala.ala01,'9027',0) RETURN END IF
   IF g_ala.alafirm ='X' THEN CALL cl_err('','9024',0) RETURN END IF
   BEGIN WORK
   OPEN t710_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_ala.*               # 對DB鎖定
   IF STATUS THEN CALL cl_err('Lock ala:',STATUS,0) ROLLBACK WORK RETURN END IF
   LET g_ala_t.*=g_ala.*
   WHILE TRUE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
      INPUT BY NAME g_ala.ala03 WITHOUT DEFAULTS
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
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ala.*=g_ala_t.*
         DISPLAY BY NAME g_ala.ala03
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE ala_file SET ala03=g_ala.ala03 WHERE ala01 = g_ala.ala01
      IF STATUS THEN
         CALL cl_err('upd ala01',STATUS,1)
         LET g_ala.*=g_ala_t.*
         DISPLAY BY NAME g_ala.ala01
         ROLLBACK WORK
         RETURN
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION t710_r()
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5     #No.FUN-690028 SMALLINT
   DEFINE l_alb04 LIKE alb_file.alb04     #MOD-AA0145
   DEFINE l_alb05 LIKE alb_file.alb05     #MOD-AA0145
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_ala.ala01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
   IF g_ala.alafirm='Y' THEN CALL cl_err('fimr=Y ','axm-101',0) RETURN END IF
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_ala.alaclos = 'Y' THEN
      CALL cl_err(g_ala.ala01,'aap-197',0)
      RETURN
   END IF
   SELECT count(*) INTO l_cnt FROM ale_file WHERE ale03 = g_ala.ala01
   IF l_cnt > 0 THEN CALL cl_err('ale.cnt>0','aap-190',0) RETURN END IF
   SELECT count(*) INTO l_cnt FROM alc_file WHERE alc01 = g_ala.ala01
                                              AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                                              AND alcfirm <> 'X' #CHI-C80041
   IF l_cnt > 0 THEN CALL cl_err('ale.cnt>0','aap-709',0) RETURN END IF
  #-MOD-AA0145-add-
   DECLARE t710_albchk_c CURSOR FOR
       SELECT alb04,alb05 
         FROM alb_file
        WHERE alb01 = g_ala.ala01
   FOREACH t710_albchk_c INTO l_alb04,l_alb05 
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ala.ala97,'rva_file'),",", 
                  "                     ",cl_get_target_table(g_ala.ala97,'rvb_file'),
                  " WHERE rva01 = rvb01       ", 
                  "   AND rvaconf <> 'X'      ",
                  "   AND rvb04 = '",l_alb04,"'",
                  "   AND rvb03 = ",l_alb05  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               
      CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql     
      PREPARE sel_rvar_pre FROM g_sql
      EXECUTE sel_rvar_pre INTO l_cnt 
      IF l_cnt > 0 THEN 
         CALL cl_err(l_alb04,'apm-602',0) 
         RETURN 
      END IF
   END FOREACH
  #-MOD-AA0145-end-
   BEGIN WORK
   OPEN t710_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_ala.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
   END IF
   CALL t710_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ala01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ala.ala01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM ala_file WHERE ala01 = g_ala.ala01
      IF STATUS THEN CALL cl_err('del ala:',STATUS,0) RETURN END IF
      DELETE FROM alb_file WHERE alb01 = g_ala.ala01
      IF STATUS THEN CALL cl_err('del alb:',STATUS,0) RETURN END IF
      DELETE FROM npp_file WHERE npp01 = g_ala.ala01
                             AND npp011= 0
                             AND nppsys='LC'
                             AND npp00 = 4
      IF STATUS THEN CALL cl_err('del npp:',STATUS,0) RETURN END IF
      DELETE FROM npq_file WHERE npq01 = g_ala.ala01
                             AND npq011= 0
                             AND npqsys='LC'
                             AND npq00 = 4
      IF STATUS THEN CALL cl_err('del npq:',STATUS,0) RETURN END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_ala.ala01
      IF STATUS THEN CALL cl_err('del tic:',STATUS,0) RETURN END IF   
      #FUN-B40056--add--end--

      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
      VALUES ('saapt710',g_user,g_today,g_msg,g_ala.ala01,'delete',g_plant,g_legal) #FUN-980001 add
      CLEAR FORM
      CALL g_alb.clear()
      INITIALIZE g_ala.* TO NULL
      OPEN t710_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t710_cs
         CLOSE t710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t710_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t710_cs
         CLOSE t710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t710_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t710_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t710_fetch('/')
      END IF
   END IF
   CLOSE t710_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t710_m()
   DEFINE i,j              LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_ac,l_sql,l_n  LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
          g_apd_t   RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
          l_ac_t    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
 
   IF g_ala.ala01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t710_m_w AT 8,30 WITH FORM "aap/42f/aapt710_3"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710_3")
 
 
   DECLARE t710_m_c CURSOR FOR
           SELECT apd02,apd03 FROM apd_file
             WHERE apd01 = g_ala.ala01
             ORDER BY apd02
   LET i = 1
   FOREACH t710_m_c INTO g_apd[i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t710_m_c',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
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
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
 
      BEFORE FIELD apd02                        #default 序號
         IF g_apd[l_ac].apd02 IS NULL OR g_apd[l_ac].apd02 = 0 THEN
            IF l_ac > 1 THEN
               LET g_apd[l_ac].apd02 = g_apd[l_ac-1].apd02 + 1
            ELSE
               IF cl_null(g_apd[l_ac].apd02) THEN
                  LET g_apd[l_ac].apd02 = 1
               END IF
            END IF
         END IF
 
      AFTER ROW
        IF INT_FLAG THEN EXIT INPUT END IF
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
      CLOSE WINDOW t710_m_w
      RETURN
   END IF
   CLOSE WINDOW t710_m_w
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
   WHILE TRUE
      DELETE FROM apd_file
       WHERE apd01 = g_ala.ala01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('t710_m(ckp#1):',SQLCA.sqlcode,1)
         EXIT WHILE
      END IF
      FOR i = 1 TO j
         IF cl_null(g_apd[i].apd03) THEN CONTINUE FOR END IF
         IF g_apd[i].apd02 <=0      THEN CONTINUE FOR END IF
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add legal   #FUN-980076 
                VALUES(g_ala.ala01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add legal   #FUN-980076
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('t710_m(ckp#2):',SQLCA.sqlcode,1)
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
 
FUNCTION t710_firm1()
 DEFINE l_tot   LIKE alb_file.alb08,
        l_pma11 LIKE pma_file.pma11
 DEFINE l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal  LIKE ala_file.ala23   #MOD-A90075
 DEFINE l_ala23      LIKE ala_file.ala23                             #MOD-C10185 add
 
   IF cl_null(g_ala.ala01) THEN RETURN END IF
   IF g_ala.alafirm='Y' THEN RETURN END IF       #CHI-C30107 add
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF #CHI-C30107 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 add
   SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_ala.ala01
   IF g_ala.alafirm='Y' THEN RETURN END IF
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_ala.ala08<=g_apz.apz57 THEN
      CALL cl_err(g_ala.ala01,'aap-176',1)
      RETURN
   END IF
   IF g_tot != g_ala.ala23 THEN CALL cl_err('','aap-901',1) END IF
   SELECT COUNT(*) INTO g_cnt FROM alb_file
    WHERE alb01=g_ala.ala01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #--->LC,DA,DP 須要輸入合約號碼
    SELECT pma11 INTO l_pma11 FROM pma_file
     WHERE pma01=g_ala.ala02 AND pmaacti = 'Y'
    IF SQLCA.sqlcode THEN LET l_pma11 = ' ' END IF
    IF (l_pma11 = '3' OR l_pma11 = '8')   #TQC-660066
       AND (g_ala.ala33 IS NULL OR g_ala.ala33 = ' '  OR
            g_ala.ala35 IS NULL OR g_ala.ala35 = ' '  OR
            g_ala.ala07 IS NULL OR g_ala.ala07 = ' '  ) THEN
       CALL cl_err(g_ala.ala01,'aap-765',1) RETURN
    END IF
   #-MOD-A90075-add-
    CALL s_credit2('N',g_ala.ala07,g_ala.ala33,g_ala.ala35)   
                 RETURNING l_amty,l_amtu,l_u_amty,l_u_amtu,l_bal
                         # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
   #------------------MOD-C10185---------------------------------start
    LET l_ala23 = g_ala.ala23 * g_ala.ala51
    CALL cl_digcut(l_ala23,g_azi04) RETURNING l_ala23

    #--CHI-C90047 start--s_credit2此時傳回的金額都是合約幣別，直接拿l_bal和l_ala23來比對，可能會有幣別不相同的狀況
    #應該要判斷這個合約幣別是否為本幣，如果不同於本幣時要換算為本幣後才能拿來和l_ala23做比對
    
    SELECT nno06 INTO g_nno06 FROM nno_file 
     WHERE nno01 = g_ala.ala33
       AND nno09='N'
    IF NOT cl_null(g_nno06) AND g_nno06 <> g_ala.ala20 THEN
        CALL s_curr3(g_nno06,g_ala.ala08,'B') RETURNING g_rate1 
        LET l_bal = l_bal * g_rate1 
        CALL cl_digcut(l_bal,g_azi04) RETURNING l_bal
    END IF
    #--CHI-C90047 end-------
    IF l_bal < l_ala23 THEN
   #IF l_bal < g_ala.ala23 THEN
   #------------------MOD-C10185---------------------------------start
       CALL cl_err('','anm-287',1)
    END IF
   #-MOD-A90075-end-
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
    BEGIN WORK
    LET g_success='Y'
    OPEN t710_cl USING g_ala.ala01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_ala.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF g_ala.ala59 > 0 THEN   #FUN-690014
       CALL s_chknpq1(g_ala.ala01,0,4,'0',g_bookno1)           # 檢查分錄底稿平衡正確否 #No.FUN-680029 add '0' #No.FUN-730064
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          CALL s_chknpq1(g_ala.ala01,0,4,'1',g_bookno2)       #No.FUN-730064
       END IF
    END IF   #FUN-690014
    IF g_success = 'N' THEN RETURN END IF
    
  
    UPDATE ala_file SET alafirm = 'Y' WHERE ala01 = g_ala.ala01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err('upd ala:',SQLCA.SQLCODE,0)
       LET g_success='N'
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
       LET g_ala.alafirm ='Y'
       DISPLAY BY NAME  g_ala.alafirm
    ELSE
       ROLLBACK WORK
    END IF
 
 
END FUNCTION
 
FUNCTION t710_firm2()
   DEFINE  l_sql          LIKE type_file.chr1000  #No.FUN-670060  #No.FUN-690028 VARCHAR(1000)
   DEFINE  l_dbs          STRING       #No.FUN-670060
 
   IF cl_null(g_ala.ala01) THEN RETURN END IF
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
   IF g_ala.alafirm='N' THEN RETURN END IF
   IF g_ala.ala78 = 'Y' THEN CALL cl_err('','mfg-013',0) RETURN END IF #已付款 No:8957
   IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF NOT cl_null(g_ala.ala72) THEN
      CALL cl_err(g_ala.ala01,'aap-145',1)
      RETURN
   END IF
   #檢查修改資料
   SELECT COUNT(*) INTO g_cnt FROM alc_file,all_file
    #WHERE alc01=g_ala.ala01 AND alc01=all01   #MOD-640018
    WHERE alc01=g_ala.ala01 AND alc01=all01 AND alc02 <> 0  #MOD-640018 #CHI-AA0015 mod '0'->0
      AND alcfirm <> 'X' #CHI-C80041
   IF g_cnt > 0 THEN
      CALL cl_err(g_ala.ala01,'aap-709',1) RETURN
   END IF
   #檢查提單資料
   SELECT COUNT(*) INTO g_cnt FROM als_file
    WHERE als03=g_ala.ala01
      AND alsfirm <> 'X'  #CHI-C80041
   IF g_cnt > 0 THEN
      CALL cl_err(g_ala.ala01,'aap-732',1) RETURN
   END IF
   #檢查到貨資料
   SELECT COUNT(*) INTO g_cnt FROM alh_file
    WHERE alh03=g_ala.ala01
   IF g_cnt > 0 THEN
      CALL cl_err(g_ala.ala01,'aap-732',1) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_ala.ala08<=g_apz.apz57 THEN
      CALL cl_err(g_ala.ala01,'aap-176',1) RETURN
   END IF
   
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t710_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_ala.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE ala_file SET alafirm = 'N' WHERE ala01 = g_ala.ala01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd ala:',SQLCA.SQLCODE,0)
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_ala.alafirm ='N'
      DISPLAY BY NAME  g_ala.alafirm
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t710_out(p_cmd)
   DEFINE l_cmd                LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_wc,l_wc2      LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(50)
          p_cmd         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_prtway         LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
   CALL cl_wait()
   IF p_cmd= 'a' THEN           # "新增"則印單張
      #LET l_cmd= "aapr700", #FUN-C30085 mark
      LET l_cmd= "aapg700", #FUN-C30085 add
                 " '",g_today CLIPPED,"' ''",
                 " '",g_lang CLIPPED,"' 'Y' '' '1' 'ala01="
      LET l_cmd=l_cmd CLIPPED,'"',g_ala.ala01,'"'
      LET l_cmd=l_cmd CLIPPED,"' "
   ELSE                        # 其他則印多張
      IF g_wc IS NULL THEN
         CALL cl_err('','9057',0) END IF
         #LET l_cmd= "aapr700", #FUN-C30085 mark
         LET l_cmd= "aapg700", #FUN-C30085 add
                    " '",g_today CLIPPED,"' ''",
                    " '",g_lang CLIPPED,"' 'Y' '' '1' '",
                    g_wc  CLIPPED,"' "
   END IF
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
FUNCTION t710_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno      LIKE ala_file.ala01
   DEFINE p_sw1            LIKE type_file.num5        # No.FUN-690028 SMALLINT #LC  (1.應付 2.直接付款 3.付款 4.外購)
   DEFINE p_sw2            LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE l_buf            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n              LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET g_success = 'Y'    #No.FUN-680029
   IF p_apno IS NULL THEN
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF
   SELECT alafirm,alaclos,ala72 INTO g_ala.alafirm,g_ala.alaclos,g_ala.ala72
     FROM ala_file
    WHERE ala01=p_apno
   IF g_ala.alafirm='Y' OR g_ala.alaclos='Y' THEN
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF
   IF g_ala.alafirm = 'X' THEN
      CALL cl_err("alafirm='X'",'aap-165',0)
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF
   IF NOT cl_null(g_ala.ala72) THEN
      LET g_success = 'N' #No.FUN-680029
      RETURN
   END IF            #傳票編號不為空白
   BEGIN WORK  #No.FUN-680029
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_apno AND npp00 = p_sw1 AND nppsys = 'LC'
      AND npp011= p_sw2
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN 
         LET g_success = 'N' #No.FUN-680029
         RETURN
      END IF #Genero

      #FUN-B40056--add--str--
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_apno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            LET g_success = 'N' 
            RETURN
         ELSE
            DELETE FROM tic_file WHERE tic04 = p_apno
            IF STATUS THEN
               CALL cl_err3("del","tic_file","","",STATUS,"","",1)
               LET g_success = 'N' 
               ROLLBACK WORK
               RETURN
            END IF
         END IF
      END IF
      #FUN-B40056--add--end--

      DELETE FROM npp_file WHERE npp01 = p_apno
                             AND npp011= p_sw2
                             AND nppsys='LC'
                             AND npp00 = p_sw1
      IF STATUS THEN
         CALL cl_err3("del","npp_file","","",STATUS,"","",1)
         LET g_success = 'N' #No.FUN-680029
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npq_file WHERE npq01 = p_apno
                             AND npq011= p_sw2
                             AND npqsys='LC'
                             AND npq00 = p_sw1
      IF STATUS THEN
         CALL cl_err3("del","npq_file","","",STATUS,"","",1)
         LET g_success = 'N' #No.FUN-680029
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   IF p_sw1='4' THEN
      CALL t710_g_gl_1(p_apno,p_sw1,p_sw2,'0')    #暫估  #No.FUN-680029 add '0'
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL t710_g_gl_1(p_apno,p_sw1,p_sw2,'1')
      END IF
   ELSE
      CALL t710_g_gl_2(p_apno,p_sw1,p_sw2,'0')    #暫估  #No.FUN-680029 add '0'
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL t710_g_gl_2(p_apno,p_sw1,p_sw2,'1')
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t710_g_gl_1(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_apno      LIKE ala_file.ala01
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT {LC  (1.應付 2.直接付款 3.付款 4.外購)   }
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept      LIKE ala_file.ala04
   DEFINE l_ala            RECORD LIKE ala_file.*
   DEFINE l_pmc03    LIKE pmc_file.pmc03    #FUN-660117
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_aps            RECORD LIKE aps_file.*
   DEFINE l_mesg        LIKE npq_file.npq04  #FUN-660117
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add
 
   SELECT * INTO l_ala.* FROM ala_file WHERE ala01 = p_apno
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   IF g_apz.apz13 = 'Y' THEN
      LET l_dept = g_ala.ala04
   ELSE
      LET l_dept = ' '
   END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = l_ala.ala42 END IF
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = l_ala.ala421 END IF
   END IF
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg       #預估保險費
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_ala.ala01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   LET l_npp.npp02  = l_ala.ala08      #異動日期 = 開狀日
   LET l_npp.npptype = p_npptype       #No.FUN-680029
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   IF l_npp.npptype = '0' THEN
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
   ELSE
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
   END IF
   LET l_npp.npplegal = g_legal  #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN CALL cl_err('ins npp#1',STATUS,1)
      LET g_success = 'N'  #No.FUN-680029
   END IF
 
   # 然後, Insert 其單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_ala.ala01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02  = 0                #項次
   LET l_npq.npq07  = 0                #本幣金額
   IF l_ala.ala21 = 0 THEN                   #MOD-C70288 add
      LET l_npq.npq24 = g_aza.aza17    #幣別 #MOD-C70288 add
      LET l_npq.npq25 = 1              #匯率 #MOD-C70288 add
   ELSE                                      #MOD-C70288 add
      LET l_npq.npq24  = l_ala.ala20   #幣別
      LET l_npq.npq25  = l_ala.ala51   #匯率
   END IF                                    #MOD-C70288 add
   LET l_npq.npqtype = p_npptype       #No.FUN-680029
 
   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=l_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
   #--->借:預付購料款 (自備款 + 手續費 + 郵電費 + 其它費用)
  #LET l_npq.npq07f= l_ala.ala34                                  #MOD-C70288 mark
   LET l_npq.npq07 = l_ala.ala52 + l_ala.ala53 +
                     l_ala.ala54 + l_ala.ala55 + l_ala.ala57
   LET l_npq.npq02 = l_npq.npq02 + 1 #項次
   IF p_npptype = '0' THEN  #No.FUN-680029
      LET l_npq.npq03 = l_ala.ala41     #預付科目
      LET g_bookno = g_bookno1 #No.FUN-730064 
   ELSE
      LET l_npq.npq03 = l_ala.ala411
      LET g_bookno = g_bookno2      #No.FUN-730064
   END IF
  #----------------MOD-C70288---------------(S)
   IF l_ala.ala21 = 0 THEN
      LET l_npq.npq07f = l_npq.npq07         #本幣金額
   ELSE
      LET l_npq.npq07f = l_ala.ala34         #本幣金額
   END IF
  #----------------MOD-C70288---------------(E)
 #FUN-D10065---mark--str 
 # LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
 #                   l_ala.ala51 USING '##.###','*',
 #                   l_ala.ala21 USING '<<<','%+',
 #                   (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
 #                               USING '<<<<<'
 #FUN-D10065---mark--end 
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
            AND aag00 = g_bookno   #No.FUN-730064 
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq06 = '1'             #D/C
   LET l_npq.npq21 = l_ala.ala05     #廠商編號
   LET l_npq.npq22 = l_pmc03         #廠商簡稱
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04 = NULL #FUN-D10065 add
   IF l_npp.npptype = '0' THEN                                                                                                      
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
      RETURNING l_npq.*
       #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
                           l_ala.ala51 USING '##.###','*',
                           l_ala.ala21 USING '<<<','%+',
                           (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
                                 USING '<<<<<'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087                                                                                                             
   ELSE                                                                                                                             
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
      RETURNING l_npq.*
       #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
                           l_ala.ala51 USING '##.###','*',
                           l_ala.ala21 USING '<<<','%+',
                           (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
                                 USING '<<<<<'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087                                                                                                             
   END IF                                                                                                                           
   LET l_npq.npqlegal = g_legal #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1)
      LET g_success = 'N'  #No.FUN-680029
   END IF
   MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
   #--->借:預付購料款 (預估保費)
   IF l_ala.ala56 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_ala.ala41
         LET g_bookno = g_bookno1  #No.FUN-730064 
      ELSE
         LET l_npq.npq03 = l_ala.ala411
         LET g_bookno = g_bookno2   #No.FUN-730064 
      END IF
      LET l_npq.npq04 = l_mesg
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_bookno    #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'
     #LET l_npq.npq07f= 0                          #MOD-C70288 mark
      LET l_npq.npq21 = l_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq07 = l_ala.ala56
      LET l_npq.npq07f = l_npq.npq07    #本幣金額  #MOD-C70288 add
      LET l_npq.npq24 = g_aza.aza17
      LET l_npq.npq25 = 1
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      IF l_npp.npptype = '0' THEN                                                                                                      
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_mesg
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087                                                                                                             
      ELSE                                                                                                                             
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_mesg
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087                                                                                                             
      END IF                                                                                                                           
      LET l_npq.npqlegal = g_legal #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1)
         LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
   END IF
   #--->貸:應付帳款 (同借方第一筆)
  #LET l_npq.npq07f = l_ala.ala34                                 #MOD-C70288 mark
   LET l_npq.npq07 = l_ala.ala52 + l_ala.ala53 + l_ala.ala54 +
                     l_ala.ala55 + l_ala.ala57
   LET l_npq.npq02 = l_npq.npq02 + 1
   IF p_npptype = '0' THEN  #No.FUN-680029
      LET l_npq.npq03 = l_ala.ala42
      LET g_bookno = g_bookno1 #No.FUN-730064 
   ELSE
      LET l_npq.npq03 = l_ala.ala421
      LET g_bookno = g_bookno2   #No.FUN-730064 
   END IF
  #----------------MOD-C70288---------------(S)
   IF l_ala.ala21 = 0 THEN
      LET l_npq.npq07f = l_npq.npq07         #本幣金額
   ELSE
      LET l_npq.npq07f = l_ala.ala34         #本幣金額
   END IF
  #----------------MOD-C70288---------------(E)
  #FUN-D10065---mark--str
  #LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
  #                  l_ala.ala51 USING '##.###','*',
  #                  l_ala.ala21 USING '<<<','%+',
  #                  (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
  #                              USING '<<<<<'
  #FUN-D10065--mark--end
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
      AND aag00 = g_bookno   #No.FUN-730064 
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   LET l_npq.npq06 = '2'
   LET l_npq.npq21 = l_ala.ala05     #廠商編號
   LET l_npq.npq22 = l_pmc03         #廠商簡稱
   IF l_ala.ala21 = 0 THEN                   #MOD-C70288 add
      LET l_npq.npq24 = g_aza.aza17    #幣別 #MOD-C70288 add
      LET l_npq.npq25 = 1              #匯率 #MOD-C70288 add
   ELSE                                      #MOD-C70288 add
      LET l_npq.npq24  = l_ala.ala20   #幣別
      LET l_npq.npq25  = l_ala.ala51   #匯率
   END IF                                    #MOD-C70288 add
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   LET l_npq.npq04 = NULL #FUN-D10065 add
   IF l_npp.npptype = '0' THEN                                                                                                      
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
      RETURNING l_npq.*   
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
                           l_ala.ala51 USING '##.###','*',
                           l_ala.ala21 USING '<<<','%+',
                           (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
                                  USING '<<<<<'
      END IF
      #FUN-D10065---add--end
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                                                                                                          
   ELSE                                                                                                                             
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
      RETURNING l_npq.* 
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_ala.ala20 CLIPPED,l_ala.ala23 USING '<<<<<<<<','*',
                           l_ala.ala51 USING '##.###','*',
                           l_ala.ala21 USING '<<<','%+',
                           (l_ala.ala53+l_ala.ala54+l_ala.ala55+l_ala.ala57)
                                  USING '<<<<<'
      END IF
      #FUN-D10065---add--end
      CALl s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                                                                                                            
   END IF                                                                                                                           
   LET l_npq.npqlegal = g_legal #FUN-980001 add
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN CALL cl_err('ins npq#3',STATUS,1)
      LET g_success = 'N'  #No.FUN-680029
   END IF
   MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   #--->貸:應付帳款 (同借方第二筆)
   IF l_ala.ala56 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_aps.aps231
         LET g_bookno = g_bookno1  #No.FUN-730064 
      ELSE
         LET l_npq.npq03 = l_aps.aps236
         LET g_bookno = g_bookno2   #No.FUN-730064 
      END IF
     #LET l_npq.npq04 = '保險費'     #FUN-D10065  mark
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_bookno     #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '2'
     #LET l_npq.npq07f= 0               #MOD-C70288 mark
      LET l_npq.npq21 = ' '             #廠商編號
      LET l_npq.npq22 = ' '             #廠商簡稱
      LET l_npq.npq07 = l_ala.ala56
      LET l_npq.npq07f = l_npq.npq07    #本幣金額  #MOD-C70288 add
      LET l_npq.npq24 = g_aza.aza17
      LET l_npq.npq25 = 1
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      IF l_npp.npptype = '0' THEN                                                                                                      
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = '保險費'
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                                                                                                             
      ELSE                                                                                                                             
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
         RETURNING l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = '保險費'
         END IF
         #FUN-D10065--add--end--
         CALL s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                                                                                                             
      END IF                                                                                                                           
      LET l_npq.npqlegal = g_legal #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN CALL cl_err('ins npq#4',STATUS,1)
         LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
FUNCTION t710_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_apno      LIKE ala_file.ala01
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT {LC  (1.應付 2.直接付款 3.付款 4.外購)   }
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE p_npptype   LIKE npp_file.npptype   #No.FUN-680029
   DEFINE l_dept      LIKE ala_file.ala04
   DEFINE l_ala            RECORD LIKE ala_file.*
   DEFINE l_pmc03       LIKE pmc_file.pmc03  #FUN-660117
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_aps            RECORD LIKE aps_file.*
   DEFINE l_mesg        LIKE npq_file.npq04  #FUN-660117
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add
 
   SELECT * INTO l_ala.* FROM ala_file WHERE ala01 = p_apno
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   IF g_apz.apz13 = 'Y'
      THEN LET l_dept = g_ala.ala04
      ELSE LET l_dept = ' '
   END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = l_ala.ala42 END IF
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = l_ala.ala421 END IF
   END IF
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg       #預估保險費
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_ala.ala01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   LET l_npp.npp02  = l_ala.ala08      #異動日期 = 開狀日
   LET l_npp.npptype = p_npptype       #No.FUN-680029
   LET l_npp.npplegal = g_legal  #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN CALL cl_err('ins npp#1',STATUS,1)
      LET g_success = 'N'  #No.FUN-680029
   END IF
 
   # 然後, Insert 其單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_ala.ala01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02  = 0                #項次
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq24  = l_ala.ala20      #幣別
   LET l_npq.npq25  = l_ala.ala51      #匯率
   LET l_npq.npqtype = p_npptype       #No.FUN-680029
 
   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=l_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
   #--->借:應付帳款
   LET l_npq.npq07f = l_ala.ala52 + l_ala.ala53 + l_ala.ala54 +
                     l_ala.ala55 + l_ala.ala57
   IF l_npq.npq07f != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_ala.ala42
         LET g_bookno = g_bookno1   #No.FUN-730064 
      ELSE
         LET l_npq.npq03 = l_ala.ala421
         LET g_bookno = g_bookno2   #No.FUN-730064
      END IF
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_bookno     #No.FUN-730064
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'             #D/C (1/2)
      LET l_npq.npq21 = l_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
   IF l_npp.npptype = '0' THEN                                                                                                      
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
      RETURNING l_npq.* 
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087                                                                                                            
   ELSE                                                                                                                             
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
      RETURNING l_npq.* 
      CALL s_def_npq31_npq34(l_npq.*,g_bookno2) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087                                                                                                            
   END IF                                                                                                                           
      LET l_npq.npqlegal = g_legal #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN CALL cl_err('ins npq#5',STATUS,1)
         LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
   #--->貸:銀行存款
   IF l_npq.npq07f != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_ala.ala43
         LET g_bookno = g_bookno1   #No.FUN-730064 
      ELSE
         LET l_npq.npq03 = l_ala.ala431
         LET g_bookno = g_bookno2   #No.FUN-730064 
      END IF
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_bookno   #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05=t710_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq21 = ' '             #廠商編號
      LET l_npq.npq22 = ' '             #廠商簡稱
      LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq31=''
      LET l_npq.npq32=''
      LET l_npq.npq33=''
      LET l_npq.npq34=''
      LET l_npq.npq35=''
      LET l_npq.npq36=''
      LET l_npq.npq37=''
   IF l_npp.npptype = '0' THEN                                                                                                      
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)                                                        
      RETURNING l_npq.* 
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087                                                                                                            
   ELSE                                                                                                                             
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno2)                                                        
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno2)  RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087                                                                                                             
   END IF                                                                                                                           
      LET l_npq.npqlegal = g_legal #FUN-980001 add
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN CALL cl_err('ins npq#6',STATUS,1)
         LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
 
FUNCTION t710_s(p_sw)
   DEFINE p_sw      LIKE type_file.chr1              # 1.不要update ala 2.要update ala  #No.FUN-690028 VARCHAR(1)
   DEFINE aag02_1  LIKE aag_file.aag02 #FUN-660117
   DEFINE aag02_2  LIKE aag_file.aag02 #No.FUN-680029
   DEFINE o_ala RECORD LIKE ala_file.*
 
   IF g_ala.ala01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
   LET o_ala.*=g_ala.*
 
 
   OPEN WINDOW t710_s_w AT 8,3 WITH FORM "aap/42f/aapt710c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710c")
 
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("ala431,aag02_2",FALSE)
    END IF
 
   SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_ala.ala43
                                             AND aag00=g_bookno1     #No.FUN-730064 
   DISPLAY BY NAME aag02_1
   SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_ala.ala431
                                             AND aag00=g_bookno2    #No.FUN-730064 
   DISPLAY BY NAME aag02_2
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   INPUT BY NAME g_ala.ala43,g_ala.ala431,g_ala.ala73 WITHOUT DEFAULTS  #No.FUN-680029 add g_ala.ala431
      AFTER FIELD ala43
         IF NOT cl_null(g_ala.ala43) THEN
            #No.FUN-B10050  --Begin
            #SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_ala.ala43
            #                                          AND aag00=g_bookno1   #No.FUN-730064 
            #IF STATUS THEN CALL cl_err('sel aag:',STATUS,0) NEXT FIELD ala43 END IF
            #DISPLAY BY NAME aag02_1
            CALL t710_aag01(g_bookno1,g_ala.ala43,'1')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ala.ala43,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ala.ala43
               LET g_qryparam.arg1 = g_bookno1
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala43 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ala.ala43
               DISPLAY BY NAME g_ala.ala43
               NEXT FIELD ala43
            END IF
            #No.FUN-B10050  --End  
         END IF
 
      AFTER FIELD ala431
         IF NOT cl_null(g_ala.ala431) THEN
            #No.FUN-B10050  --Begin
            #SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_ala.ala431
            #                                          AND aag00=g_bookno2    #No.FUN-730064 
            #IF STATUS THEN CALL cl_err('sel aag:',STATUS,0) NEXT FIELD ala431 END IF
            #DISPLAY BY NAME aag02_2
            CALL t710_aag01(g_bookno2,g_ala.ala431,'2')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ala.ala431,g_errno,0)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ala.ala431
               LET g_qryparam.arg1 = g_bookno2
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala431 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ala.ala431
               DISPLAY BY NAME g_ala.ala431
               NEXT FIELD ala431
            END IF
            #No.FUN-B10050  --End  
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
 
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(ala43)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_ala.ala43
                LET g_qryparam.arg1 = g_bookno1   #No.FUN-730064
                CALL cl_create_qry() RETURNING g_ala.ala43
                DISPLAY BY NAME g_ala.ala43
             WHEN INFIELD(ala431)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_ala.ala431
                LET g_qryparam.arg1 = g_bookno2  #No.FUN-730064
                CALL cl_create_qry() RETURNING g_ala.ala431
                DISPLAY BY NAME g_ala.ala431
             OTHERWISE EXIT CASE
         END CASE
 
   END INPUT
   CLOSE WINDOW t710_s_w
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_ala.*=o_ala.* RETURN END IF
 
   IF p_sw = '1' THEN RETURN END IF
 
   UPDATE ala_file SET ala43=g_ala.ala43,
                       ala73=g_ala.ala73
    WHERE ala01 = g_ala.ala01
   IF g_aza.aza63 = 'Y' THEN
      UPDATE ala_file SET ala431 = g_ala.ala431
       WHERE ala01 = g_ala.ala01
   END IF
END FUNCTION
 
FUNCTION t710_7(p_sw)
   DEFINE p_sw      LIKE type_file.chr1              # 1.不要update ala 2.要update ala  #No.FUN-690028 VARCHAR(1)
   DEFINE o_ala RECORD LIKE ala_file.*
   IF g_ala.ala01 IS NULL THEN RETURN END IF
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
   LET o_ala.*=g_ala.*
 
 
   OPEN WINDOW t710_7_w AT 8,3 WITH FORM "aap/42f/aapt710e"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt710e")
 
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   INPUT BY NAME g_ala.ala36,g_ala.ala37,g_ala.ala38,g_ala.ala39,
                 g_ala.ala40 WITHOUT DEFAULTS
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
 
   CLOSE WINDOW t710_7_w
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_ala.*=o_ala.* RETURN END IF
 
   IF p_sw = '1' THEN RETURN END IF
 
   UPDATE ala_file SET ala36 = g_ala.ala36,
                       ala37 = g_ala.ala37,
                       ala38 = g_ala.ala38,
                       ala39 = g_ala.ala39,
                       ala40 = g_ala.ala40
    WHERE ala01 = g_ala.ala01
END FUNCTION
 
FUNCTION t710_g()
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_als     DYNAMIC ARRAY OF RECORD
                    als01            LIKE als_file.als01,
                    als21            LIKE als_file.als21,
                    als02            LIKE als_file.als02,
                    als13            LIKE als_file.als13
                    END RECORD
   DEFINE als13_t   LIKE als_file.als13  #FUN-4B0079
 
 
   OPEN WINDOW t710_g_w AT 10,3 WITH FORM "aap/42f/aapt710d"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710d")
 
 
   DECLARE t710_g_c CURSOR FOR
       SELECT als01,als21,als02,als13
         FROM als_file
        WHERE als03 = g_ala.ala01
          AND alsfirm <> 'X' #CHI-C80041
        ORDER BY als01
 
   CALL g_als.clear()
   LET k = 1 LET als13_t=0
 
   FOREACH t710_g_c INTO g_als[k].*
      LET als13_t = als13_t + g_als[k].als13
      IF k <= 5 THEN
         DISPLAY g_als[k].* TO s_als[k].*
      END IF
      LET k = k + 1 IF k > 10 THEN EXIT FOREACH END IF
   END FOREACH
 
   DISPLAY BY NAME als13_t
   DISPLAY ARRAY g_als TO s_als.* ATTRIBUTE(COUNT=k-1)
 
   CLOSE WINDOW t710_g_w
 
END FUNCTION
 
FUNCTION t710_j()
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_alh     DYNAMIC ARRAY OF RECORD
                    alh01            LIKE alh_file.alh01,
                    alh30            LIKE alh_file.alh30,
                    alh02            LIKE alh_file.alh02,
                    alh12            LIKE alh_file.alh12,
                    payd             LIKE type_file.dat
                    END RECORD
   DEFINE alh12_t   LIKE alh_file.alh12 #FUN-4B0079
 
 
   OPEN WINDOW t710_j_w AT 10,3 WITH FORM "aap/42f/aapt710b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710b")
 
 
   DECLARE t710_j_c CURSOR FOR
       SELECT alh01,alh30,alh02,alh12, ''
         FROM alh_file
        WHERE alh03 = g_ala.ala01 AND alhfirm='Y' AND alh00='1'
        ORDER BY alh01
 
   CALL g_alh.clear()
   LET k = 1 LET alh12_t=0
 
   FOREACH t710_j_c INTO g_alh[k].*
      LET alh12_t = alh12_t + g_alh[k].alh12
      SELECT MAX(alp02) INTO g_alh[k].payd FROM alp_file, alq_file
             WHERE alq03=g_alh[k].alh01 AND alq01=alp01
      IF k <= 5 THEN DISPLAY g_alh[k].* TO s_alh[k].* END IF
      LET k = k + 1 IF k > 10 THEN EXIT FOREACH END IF
   END FOREACH
 
   DISPLAY BY NAME alh12_t
   DISPLAY ARRAY g_alh TO s_alh.* ATTRIBUTE(COUNT=k-1)
 
   CLOSE WINDOW t710_j_w
 
END FUNCTION
 
FUNCTION t710_k()
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_alk     DYNAMIC ARRAY OF RECORD
                    alk01            LIKE alk_file.alk01,
                    alk07            LIKE alk_file.alk07,
                    alk02            LIKE alk_file.alk02,
                    alk13            LIKE alk_file.alk13,
                    alk26            LIKE alk_file.alk26
                    END RECORD
   DEFINE alk13_t     LIKE alk_file.alk13  #FUN-4B0079
   DEFINE alk26_t     LIKE alk_file.alk26  #FUN-4B0079
 
 
   OPEN WINDOW t710_k_w AT 10,3 WITH FORM "aap/42f/aapt710a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710a")
 
 
   DECLARE t710_k_c CURSOR FOR
       SELECT alk01,alk07,alk02,alk13,alk26
         FROM alk_file
        WHERE alk03 = g_ala.ala01 AND alkfirm='Y'
        ORDER BY alk01
 
   CALL g_alk.clear()
   LET k = 1 LET alk13_t=0 LET alk26_t=0
 
   FOREACH t710_k_c INTO g_alk[k].*
      LET alk13_t = alk13_t + g_alk[k].alk13
      LET alk26_t = alk26_t + g_alk[k].alk26
      IF k <= 5 THEN DISPLAY g_alk[k].* TO s_alk[k].* END IF
      LET k = k + 1 IF k > 10 THEN EXIT FOREACH END IF
   END FOREACH
 
   DISPLAY BY NAME alk13_t, alk26_t
            LET INT_FLAG = 0  ######add for prompt bug
   DISPLAY ARRAY g_alk TO s_alk.* ATTRIBUTE(COUNT=k-1)
 
   CLOSE WINDOW t710_k_w
 
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION t710_d()
#   DEFINE l_plant   LIKE azp_file.azp01,  #FUN-660117
#          l_dbs     LIKE azp_file.azp02   #FUN-660117 
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant 
#   LET g_dbs   = l_dbs 
#   CALL s_chgdbs()                       #FUN-B10030 
#   CALL t710_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION t710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_lcqty,l_sumalb07 LIKE alb_file.alb07,
    l_poqty            LIKE alb_file.alb07,
    l_pmn04            LIKE pmn_file.pmn04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-690028 SMALLINT
    l_tf            LIKE type_file.chr1,                #No.FUN-BB0086
    l_case          STRING                 #No.FUN-BB0086
    
    LET g_action_choice = ""
    IF s_aapshut(0) THEN RETURN END IF
    IF g_ala.ala01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
    IF g_ala.alafirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_ala.ala97 != g_plant THEN CALL cl_err('','aap-707',0)RETURN END IF        #No.FUN-980017
 
    SELECT COUNT(*) INTO l_n FROM alb_file WHERE alb01 = g_ala.ala01
    IF l_n = 0 THEN
       IF cl_confirm('aap-718') THEN
          CALL t710_g_b()
          CALL t710_b_fill('1=1')
       END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT alb02,alb04,alb05,alb11,'',",
                       "       alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87,", #NO.FUN-710029
                       "       alb06,alb07,",
                       "       alb08,alb12,alb13,'',alb930,'', ",
                       "       albud01,albud02,albud03,albud04,albud05,",
                       "       albud06,albud07,albud08,albud09,albud10,",
                       "       albud11,albud12,albud13,albud14,albud15", 
                       " FROM alb_file", #FUN-680019
                       " WHERE alb01=? AND alb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_alb WITHOUT DEFAULTS FROM s_alb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           SELECT azi04 INTO t_azi04 FROM azi_file
              WHERE azi01=g_ala.ala20
           #No.FUN-BB0086--add--begin--
           LET g_alb80_t = NULL 
           LET g_alb82_t = NULL 
           LET g_alb83_t = NULL 
           LET g_alb86_t = NULL 
           #No.FUN-BB0086--add--end--
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN t710_cl USING g_ala.ala01
           IF STATUS THEN
              CALL cl_err("OPEN t710_cl:", STATUS, 1)
              CLOSE t710_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t710_cl INTO g_ala.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
              CLOSE t710_cl ROLLBACK WORK RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET g_alb_t.* = g_alb[l_ac].*  #BACKUP
              #No.FUN-BB0086--add--begin--
              LET g_alb80_t = g_alb[l_ac].alb80
              LET g_alb82_t = g_alb[l_ac].alb82
              LET g_alb83_t = g_alb[l_ac].alb83
              LET g_alb86_t = g_alb[l_ac].alb86
              #No.FUN-BB0086--add--end--
              LET p_cmd='u'
              OPEN t710_bcl USING g_ala.ala01,g_alb_t.alb02
              IF STATUS THEN
                 CALL cl_err("OPEN t710_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t710_bcl INTO g_alb[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_alb_t.alb02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_alb[l_ac].pmn041 = g_alb_t.pmn041
              #LET g_alb[l_ac].pmn07  = g_alb_t.pmn07     #FUN-560089
              LET g_alb[l_ac].pmn06  = g_alb_t.pmn06
              LET g_alb[l_ac].gem02c=s_costcenter_desc(g_alb[l_ac].alb930) #FUN-680019
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_alb[l_ac].alb11) THEN
                 SELECT ima44,ima31 INTO g_ima44,g_ima31
                   FROM ima_file WHERE ima01=g_alb[l_ac].alb11
 
                 CALL s_chk_va_setting(g_alb[l_ac].alb11)
                      RETURNING g_flag,g_ima906,g_ima907
 
                 CALL s_chk_va_setting1(g_alb[l_ac].alb11)
                      RETURNING g_flag,g_ima908
              END IF
           END IF
           CALL t710_set_required() 
           CALL t710_set_entry_b(p_cmd)
           CALL t710_set_no_entry_b(p_cmd)
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_alb[l_ac].* TO NULL      #900423
           #LET g_alb[l_ac].alb05 = 0    #TQC-B40091
            LET g_alb[l_ac].alb81 = 0    #FUN-710029
            LET g_alb[l_ac].alb82 = 0    #FUN-710029
            LET g_alb[l_ac].alb84 = 0    #FUN-710029
            LET g_alb[l_ac].alb85 = 0    #FUN-710029
            LET g_alb[l_ac].alb87 = 0    #FUN-710029
            LET g_alb[l_ac].alb06 = 0
            LET g_alb[l_ac].alb07 = 0
            LET g_alb[l_ac].alb08 = 0
            LET g_alb[l_ac].alb12 = 0
            LET g_alb[l_ac].alb13 = 0
            LET g_alb[l_ac].alb930= g_ala.ala930 #FUN-680019
            LET g_alb[l_ac].gem02c=s_costcenter_desc(g_alb[l_ac].alb930) #FUN-680019
            LET g_alb_t.* = g_alb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL t710_set_entry_b(p_cmd)      #NO.FUN-710029
            CALL t710_set_no_entry_b(p_cmd)   #NO.FUN-710029
            NEXT FIELD alb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL t710_set_origin_field()
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_alb[l_ac].alb11) THEN
                 SELECT ima44,ima31 INTO g_ima44,g_ima31
                   FROM ima_file WHERE ima01=g_alb[l_ac].alb11
              END IF
 
              CALL s_chk_va_setting(g_alb[l_ac].alb11)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD alb11
              END IF
 
              CALL s_chk_va_setting1(g_alb[l_ac].alb11)
                   RETURNING g_flag,g_ima908
              IF g_flag=1 THEN
                 NEXT FIELD alb05
              END IF
 
              CALL t710_du_data_to_correct()
              CALL t710_set_origin_field()
           END IF
           INSERT INTO alb_file(alb01,alb02,alb04,alb05,
                          alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87,  #FUN-710029
                          alb06,alb07,alb08,alb11,alb12,alb13,alb930, #FUN-680019
                                  albud01,albud02,albud03,
                                  albud04,albud05,albud06,
                                  albud07,albud08,albud09,
                                  albud10,albud11,albud12,
                                  albud13,albud14,albud15,alblegal) #FUN-980001 add legal  #FUN-980076
            VALUES(g_ala.ala01, g_alb[l_ac].alb02,
                   g_alb[l_ac].alb04,g_alb[l_ac].alb05,
                   g_alb[l_ac].alb83,g_alb[l_ac].alb84,   #FUN-710029
                   g_alb[l_ac].alb85,g_alb[l_ac].alb80,   #FUN-710029
                   g_alb[l_ac].alb81,g_alb[l_ac].alb82,   #FUN-710029
                   g_alb[l_ac].alb86,g_alb[l_ac].alb87,   #FUN-710029
                   g_alb[l_ac].alb06,g_alb[l_ac].alb07,
                   g_alb[l_ac].alb08,g_alb[l_ac].alb11,
                   g_alb[l_ac].alb12,g_alb[l_ac].alb13,g_alb[l_ac].alb930, #FUN-680019
                                  g_alb[l_ac].albud01,
                                  g_alb[l_ac].albud02,
                                  g_alb[l_ac].albud03,
                                  g_alb[l_ac].albud04,
                                  g_alb[l_ac].albud05,
                                  g_alb[l_ac].albud06,
                                  g_alb[l_ac].albud07,
                                  g_alb[l_ac].albud08,
                                  g_alb[l_ac].albud09,
                                  g_alb[l_ac].albud10,
                                  g_alb[l_ac].albud11,
                                  g_alb[l_ac].albud12,
                                  g_alb[l_ac].albud13,
                                  g_alb[l_ac].albud14,
                                  g_alb[l_ac].albud15,g_legal) #FUN-980001 add legal  #FUN-980076
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_alb[l_ac].alb02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t710_bu(1,0)
           END IF
 
        BEFORE FIELD alb02                        #default 序號
           IF g_alb[l_ac].alb02 IS NULL OR g_alb[l_ac].alb02 = 0 THEN
              SELECT max(alb02)+1
                INTO g_alb[l_ac].alb02
                FROM alb_file
               WHERE alb01 = g_ala.ala01
              IF g_alb[l_ac].alb02 IS NULL THEN
                 LET g_alb[l_ac].alb02 = 1
              END IF
           END IF
 
        AFTER FIELD alb02                        #check 序號是否重複
           IF NOT cl_null(g_alb[l_ac].alb02) THEN
              IF g_alb[l_ac].alb02 != g_alb_t.alb02 OR g_alb_t.alb02 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM alb_file
                  WHERE alb01 = g_ala.ala01
                    AND alb02 = g_alb[l_ac].alb02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_alb[l_ac].alb02 = g_alb_t.alb02
                    NEXT FIELD alb02
                 END IF
              END IF
           END IF
 
        AFTER FIELD alb04
           IF NOT cl_null(g_alb[l_ac].alb04) THEN
              IF g_alb[l_ac].alb04 != 'MISC' AND
                 (g_alb[l_ac].alb04 != g_alb_t.alb04 OR
                  g_alb_t.alb04 IS NULL ) THEN
                 CALL t710_alb04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_alb[l_ac].alb04,g_errno,0)
                    NEXT FIELD alb04
                 END IF
              END IF
              #No.TQC-B40089  --Begin
              IF NOT cl_null(g_alb[l_ac].alb05) OR
                 (g_alb[l_ac].alb04 != g_alb_t.alb04 OR
                  g_alb[l_ac].alb05 != g_alb_t.alb05) THEN
                 CALL t710_alb05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_alb[l_ac].alb04=g_alb_t.alb04
                    LET g_alb[l_ac].alb05=g_alb_t.alb05
                    NEXT FIELD alb04
                    DISPLAY BY NAME g_alb[l_ac].alb04
                    DISPLAY BY NAME g_alb[l_ac].alb05
                 END IF
              END IF
              #No.TQC-B40089  --End
           END IF
 
        AFTER FIELD alb05
           IF NOT cl_null(g_alb[l_ac].alb05) THEN
              IF g_alb_t.alb04 IS NULL OR
                 (g_alb[l_ac].alb04 != g_alb_t.alb04 OR
                  g_alb[l_ac].alb05 != g_alb_t.alb05) THEN
                 CALL t710_alb05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_alb[l_ac].alb04=g_alb_t.alb04
                    LET g_alb[l_ac].alb05=g_alb_t.alb05
                    NEXT FIELD alb04
                    DISPLAY BY NAME g_alb[l_ac].alb04
                    DISPLAY BY NAME g_alb[l_ac].alb05
                 END IF
              END IF
           END IF
 
        AFTER FIELD alb06
            LET g_alb[l_ac].alb08 = g_alb[l_ac].alb06 * g_alb[l_ac].alb07
            LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
            DISPLAY BY NAME g_alb[l_ac].alb08
 
        AFTER FIELD alb07
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           CALL t710_alb07_check(l_sumalb07,l_poqty,l_lcqty,p_cmd) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "alb04" NEXT FIELD alb04 
                 WHEN "alb07" NEXT FIELD alb07
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
           #No.FUN-BB0086--mark--begin--
           ##-->檢查數量是否超出
           #IF g_alb[l_ac].alb04 != 'MISC' THEN
           #   SELECT sum(alb07) INTO l_sumalb07 FROM alb_file,ala_file
           #    WHERE alb04 = g_alb[l_ac].alb04
           #      AND alb05 = g_alb[l_ac].alb05
           #      AND ala01 = alb01 
           #      AND alafirm <> 'X'
           #   IF l_sumalb07 IS NULL OR l_sumalb07 = ' ' THEN
           #      LET l_sumalb07 = 0
           #   END IF
           #  #FUN-A60056--mod--str--
           #  #SELECT pmn87 INTO l_poqty FROM pmn_file    
           #  # WHERE pmn01 = g_alb[l_ac].alb04
           #  #   AND pmn02 = g_alb[l_ac].alb05
           #   LET g_sql = "SELECT pmn87 FROM ",cl_get_target_table(g_ala.ala97,'pmn_file'),
           #               " WHERE pmn01 = '",g_alb[l_ac].alb04,"'" ,
           #               "   AND pmn02 = '",g_alb[l_ac].alb05,"'"
           #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           #   CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql
           #   PREPARE sel_pmn07 FROM g_sql
           #   EXECUTE sel_pmn07 INTO l_poqty
           #  #FUN-A60056--mod--end
           #   IF SQLCA.sqlcode THEN
           #      CALL cl_err(g_alb[l_ac].alb04,'aap-006',0)
           #      NEXT FIELD alb04
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      LET l_lcqty = l_sumalb07 + g_alb[l_ac].alb07
           #   ELSE
           #      LET l_lcqty = l_sumalb07 + g_alb[l_ac].alb07 - g_alb_t.alb07
           #   END IF
           #   IF l_lcqty > l_poqty THEN
           #      CALL cl_err(l_sumalb07,'aap-196',0)
           #      LET g_alb[l_ac].alb07 = g_alb_t.alb07
           #      NEXT FIELD alb07
           #   END IF
           #END IF
           #LET g_alb[l_ac].alb08 = g_alb[l_ac].alb06 * g_alb[l_ac].alb07
           #
           #LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
           #DISPLAY BY NAME g_alb[l_ac].alb08
           #No.FUN-BB0086--mark--end--
 
       AFTER FIELD alb08
          LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
          DISPLAY BY NAME g_alb[l_ac].alb08
 
       BEFORE FIELD alb11
          CALL t710_set_no_required()       
          CALL t710_set_entry_b(p_cmd)
 
       AFTER FIELD alb11
           #-->料號不允許修改
           IF g_alb[l_ac].alb04 != 'MISC' THEN
             #FUN-A60056--mod--str--
             #SELECT pmn04 INTO l_pmn04 FROM pmn_file
             # WHERE pmn01 = g_alb[l_ac].alb04
             #   AND pmn02 = g_alb[l_ac].alb05
              LET g_sql = "SELECT pmn04 FROM ",cl_get_target_table(g_ala.ala97,'pmn_file'),
                          " WHERE pmn01 = '",g_alb[l_ac].alb04,"'",
                          "   AND pmn02 = '",g_alb[l_ac].alb05,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql
              PREPARE sel_pmn04 FROM g_sql
              EXECUTE sel_pmn04 INTO l_pmn04
             #FUN-A60056--mod--end
              IF l_pmn04 != g_alb[l_ac].alb11 THEN
                 CALL cl_err(l_pmn04,'aap-195',0)
                 LET g_alb[l_ac].alb11 = l_pmn04
                 DISPLAY BY NAME g_alb[l_ac].alb11
                 NEXT FIELD alb04
              END IF
           END IF
           CALL t710_set_no_entry_b(p_cmd)
           CALL t710_set_required()
 
           IF g_sma.sma115 = 'Y' THEN
              CALL s_chk_va_setting(g_alb[l_ac].alb11)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD alb11
              END IF
              CALL s_chk_va_setting1(g_alb[l_ac].alb11)
                   RETURNING g_flag,g_ima908
              IF g_flag=1 THEN
                 NEXT FIELD alb05
              END IF
              IF g_ima906 = '3' THEN
                 LET g_alb[l_ac].alb83=g_ima907
              END IF
              IF g_sma.sma116 MATCHES '[13]' THEN   
                 LET g_alb[l_ac].alb86=g_ima908
              END IF
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_alb[l_ac].alb11
              IF cl_null(g_alb[l_ac].alb80) AND  
                 cl_null(g_alb[l_ac].alb83) THEN
                 CALL t710_du_default(p_cmd)
              END IF
          END IF
          CALL t710_set_required()
 
        BEFORE FIELD alb83
           IF NOT cl_null(g_alb[l_ac].alb11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_alb[l_ac].alb11
           END IF
           CALL t710_set_no_required()
 
        AFTER FIELD alb83  #第二單位
           IF cl_null(g_alb[l_ac].alb11) THEN NEXT FIELD alb11 END IF
           IF NOT cl_null(g_alb[l_ac].alb83) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_alb[l_ac].alb83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_alb[l_ac].alb83,"",STATUS,"","gfe:",1)
                 NEXT FIELD alb83
              END IF
              CALL s_du_umfchk(g_alb[l_ac].alb11,'','','',
                               g_ima44,g_alb[l_ac].alb83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_alb[l_ac].alb83,g_errno,1)
                 NEXT FIELD alb83
              END IF
              IF cl_null(g_alb_t.alb83) OR g_alb_t.alb83 <> g_alb[l_ac].alb83 THEN
                 LET g_alb[l_ac].alb84 = g_factor
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_alb[l_ac].alb85) THEN
                 IF NOT t710_alb85_check(p_cmd) THEN
                    LET g_alb83_t = g_alb[l_ac].alb83
                    NEXT FIELD alb85
                 END IF 
              END IF 
              LET g_alb83_t = g_alb[l_ac].alb83
              #No.FUN-BB0086--add--end--
           END IF
           CALL t710_du_data_to_correct()
           CALL t710_set_required()
           CALL cl_show_fld_cont()  
 
        AFTER FIELD alb84  #第二轉換率
           IF NOT cl_null(g_alb[l_ac].alb84) THEN
              IF g_alb[l_ac].alb84=0 THEN
                 NEXT FIELD alb84
              END IF
           END IF
 
        AFTER FIELD alb85  #第二數量
           IF NOT t710_alb85_check(p_cmd) THEN NEXT FIELD alb85 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin---
           #IF NOT cl_null(g_alb[l_ac].alb85) THEN
           #   IF g_alb[l_ac].alb85 < 0 THEN
           #      CALL cl_err('','aim-391',1) 
           #      NEXT FIELD alb85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_alb_t.alb85 <> g_alb[l_ac].alb85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_alb[l_ac].alb85*g_alb[l_ac].alb84
           #         IF cl_null(g_alb[l_ac].alb82) OR g_alb[l_ac].alb82=0 THEN #CHI-960022
           #            LET g_alb[l_ac].alb82=g_tot*g_alb[l_ac].alb81
           #            DISPLAY BY NAME g_alb[l_ac].alb82                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           #IF cl_null(g_alb[l_ac].alb86) THEN
           #   LET g_alb[l_ac].alb87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
           #          g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
           #          g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
           #          g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
           #          g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
           #      CALL t710_set_alb87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()  
           #No.FUN-BB0086--mark--begin---
 
        AFTER FIELD alb80  #第一單位
           IF cl_null(g_alb[l_ac].alb11) THEN NEXT FIELD alb11 END IF
           IF NOT cl_null(g_alb[l_ac].alb80) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_alb[l_ac].alb80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_alb[l_ac].alb80,"",STATUS,"","gfe:",1)
                 NEXT FIELD alb80
              END IF
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                    (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
                     g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
                     g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
                     g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
                     g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
                 CALL t710_set_alb87()
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_alb[l_ac].alb82) THEN
                 IF NOT t710_alb82_check(p_cmd) THEN 
                    LET g_alb80_t = g_alb[l_ac].alb80
                    NEXT FIELD alb82
                 END IF 
              END IF 
              LET g_alb82_t = g_alb[l_ac].alb80
              #No.FUN-BB0086--add--end--
           END IF
           CALL cl_show_fld_cont()         
 
        AFTER FIELD alb81  #第一轉換率
           IF NOT cl_null(g_alb[l_ac].alb81) THEN
              IF g_alb[l_ac].alb81=0 THEN
                 NEXT FIELD alb81
              END IF
           END IF
 
        AFTER FIELD alb82  #第一數量
           IF NOT t710_alb82_check(p_cmd) THEN NEXT FIELD alb82 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_alb[l_ac].alb82) THEN
           #   IF g_alb[l_ac].alb82 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD alb82
           #   END IF
           #END IF
           #CALL t710_set_origin_field()
           #IF cl_null(g_alb[l_ac].alb86) THEN
           #   LET g_alb[l_ac].alb87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
           #          g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
           #          g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
           #          g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
           #          g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
           #      CALL t710_set_alb87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD alb86
           IF NOT cl_null(g_alb[l_ac].alb11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_alb[l_ac].alb11
           END IF
           CALL t710_set_no_required()

        AFTER FIELD alb86
           #No.FUN-BB0086--add--begin--
           LET l_tf = ""
           LET l_case = ""
           IF NOT cl_null(g_alb[l_ac].alb07) THEN
              CALL t710_alb07_check(l_sumalb07,l_poqty,l_lcqty,p_cmd) RETURNING l_tf,l_case
           END IF
           IF g_sma.sma116 NOT MATCHES '[02]' THEN                                  #TQC-C20183 
              IF NOT cl_null(g_alb[l_ac].alb87) THEN
                 IF NOT t710_alb87_check() THEN 
                    LET g_alb86_t = g_alb[l_ac].alb86
                    NEXT FIELD alb87
                 END IF 
              END IF 
           ELSE                                                                     #TQC-C20183
              LET g_alb[l_ac].alb87=s_digqty(g_alb[l_ac].alb87,g_alb[l_ac].alb86)   #TQC-C20183
              DISPLAY BY NAME g_alb[l_ac].alb87                                     #TQC-C20183
           END IF                                                                   #TQC-C20183 
           LET g_alb86_t = g_alb[l_ac].alb86
           IF NOT l_tf THEN 
              CASE l_case
                 WHEN "alb04" NEXT FIELD alb04 
                 WHEN "alb07" NEXT FIELD alb07
                 OTHERWISE EXIT CASE 
              END CASE 
           END IF 
           #No.FUN-BB0086--add--end--
 
        BEFORE FIELD alb87
           IF g_sma.sma115 = 'Y' THEN
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
                  g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
                  g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
                  g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
                  g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
                 CALL t710_set_alb87()
              END IF
           ELSE
              IF g_alb[l_ac].alb87 = 0 OR
                 g_alb_t.alb86 <> g_alb[l_ac].alb86 THEN
                 CALL t710_set_alb87()
              END IF
           END IF
 
        AFTER FIELD alb87
           IF NOT t710_alb87_check() THEN NEXT FIELD alb87 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_alb[l_ac].alb87) THEN
           #   IF g_alb[l_ac].alb87 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD alb87
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
        AFTER FIELD albud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD albud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alb930 
           IF NOT s_costcenter_chk(g_alb[l_ac].alb930) THEN
              LET g_alb[l_ac].alb930=g_alb_t.alb930
              LET g_alb[l_ac].gem02c=g_alb_t.gem02c
              DISPLAY BY NAME g_alb[l_ac].alb930,g_alb[l_ac].gem02c
              NEXT FIELD alb930
           ELSE
              LET g_alb[l_ac].gem02c=s_costcenter_desc(g_alb[l_ac].alb930)
              DISPLAY BY NAME g_alb[l_ac].gem02c
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_alb_t.alb02 > 0 AND g_alb_t.alb02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM alb_file
               WHERE alb01 = g_ala.ala01
                 AND alb02 = g_alb_t.alb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_alb_t.alb02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t710_bu(0,1)
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_alb[l_ac].* = g_alb_t.*
              CLOSE t710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_alb[l_ac].alb02,-263,1)
              LET g_alb[l_ac].* = g_alb_t.*
           ELSE
               CALL t710_set_origin_field()  
 
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_alb[l_ac].alb11) THEN
                     SELECT ima44,ima31 INTO g_ima44,g_ima31
                       FROM ima_file WHERE ima01=g_alb[l_ac].alb11
                  END IF
 
                  CALL s_chk_va_setting(g_alb[l_ac].alb11)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD alb11
                  END IF
                  CALL s_chk_va_setting1(g_alb[l_ac].alb11)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD alb02
                  END IF
 
                  CALL t710_du_data_to_correct()
 
                  CALL t710_set_origin_field()
               END IF
              UPDATE alb_file SET alb02 = g_alb[l_ac].alb02,
                                  alb04 = g_alb[l_ac].alb04,
                                  alb05 = g_alb[l_ac].alb05,
                                  alb83 = g_alb[l_ac].alb83,   #FUN-710029
                                  alb84 = g_alb[l_ac].alb84,   #FUN-710029
                                  alb85 = g_alb[l_ac].alb85,   #FUN-710029 
                                  alb80 = g_alb[l_ac].alb80,   #FUN-710029
                                  alb81 = g_alb[l_ac].alb81,   #FUN-710029
                                  alb82 = g_alb[l_ac].alb82,   #FUN-710029
                                  alb86 = g_alb[l_ac].alb86,   #FUN-710029
                                  alb87 = g_alb[l_ac].alb87,   #FUN-710029
                                  alb06 = g_alb[l_ac].alb06,
                                  alb07 = g_alb[l_ac].alb07,
                                  alb08 = g_alb[l_ac].alb08,
                                  alb11 = g_alb[l_ac].alb11,
                                  alb12 = g_alb[l_ac].alb12,
                                  alb13 = g_alb[l_ac].alb13,
                                  alb930= g_alb[l_ac].alb930, #FUN-680019
                                albud01 = g_alb[l_ac].albud01,
                                albud02 = g_alb[l_ac].albud02,
                                albud03 = g_alb[l_ac].albud03,
                                albud04 = g_alb[l_ac].albud04,
                                albud05 = g_alb[l_ac].albud05,
                                albud06 = g_alb[l_ac].albud06,
                                albud07 = g_alb[l_ac].albud07,
                                albud08 = g_alb[l_ac].albud08,
                                albud09 = g_alb[l_ac].albud09,
                                albud10 = g_alb[l_ac].albud10,
                                albud11 = g_alb[l_ac].albud11,
                                albud12 = g_alb[l_ac].albud12,
                                albud13 = g_alb[l_ac].albud13,
                                albud14 = g_alb[l_ac].albud14,
                                albud15 = g_alb[l_ac].albud15
               WHERE alb01=g_ala.ala01
                 AND alb02=g_alb_t.alb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_alb[l_ac].alb02,SQLCA.sqlcode,0)
                 LET g_alb[l_ac].* = g_alb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 CALL t710_bu(1,1)
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_alb[l_ac].* = g_alb_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_alb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
              END IF
              CLOSE t710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           CLOSE t710_bcl
           COMMIT WORK
           CALL t710_b_tot()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(alb04)
              #No.TQC-B40082  --Begin
               #  CALL q_m_pmm6(FALSE,FALSE,g_alb[l_ac].alb04,g_plant,g_ala.ala05,g_ala.ala02)   #TQC-5C0095
               #       RETURNING g_alb[l_ac].alb04
               #    DISPLAY BY NAME g_alb[l_ac].alb04       #No.MOD-490344
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmm18"
               LET g_qryparam.arg1 = g_ala.ala05
               IF NOT cl_null(g_ala.ala02) THEN
                  LET g_qryparam.where = " pmm20='",g_ala.ala02,"'"
               END IF
               CALL cl_create_qry() RETURNING g_alb[l_ac].alb04,g_alb[l_ac].alb05
               DISPLAY g_alb[l_ac].alb04 TO alb04
               DISPLAY g_alb[l_ac].alb05 TO alb05 
               #No.TQC-B40082  --End
              WHEN INFIELD(alb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmn"
                 LET g_qryparam.arg1 = g_alb[l_ac].alb04
                 CALL cl_create_qry() RETURNING g_alb[l_ac].alb05
                   DISPLAY BY NAME g_alb[l_ac].alb05       #No.MOD-490344
               WHEN INFIELD(alb80) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_alb[l_ac].alb80
                    CALL cl_create_qry() RETURNING g_alb[l_ac].alb80
                    DISPLAY BY NAME g_alb[l_ac].alb80
                    NEXT FIELD alb80
               WHEN INFIELD(alb83) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_alb[l_ac].alb83
                    CALL cl_create_qry() RETURNING g_alb[l_ac].alb83
                    DISPLAY BY NAME g_alb[l_ac].alb83
                    NEXT FIELD alb83
               WHEN INFIELD(alb86) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_alb[l_ac].alb86
                    CALL cl_create_qry() RETURNING g_alb[l_ac].alb86
                    DISPLAY BY NAME g_alb[l_ac].alb86
                    NEXT FIELD alb86
              WHEN INFIELD(alb930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_alb[l_ac].alb930
                 DISPLAY BY NAME g_alb[l_ac].alb930
                 NEXT FIELD alb930
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(alb02) AND l_ac > 1 THEN
              LET g_alb[l_ac].* = g_alb[l_ac-1].*
              LET g_alb[l_ac].alb02 = NULL   #TQC-620018
              NEXT FIELD alb02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION auto_gen_detail
            CALL t710_g_b()
            CALL t710_b_fill('1=1')
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
    UPDATE ala_file SET alamodu=g_user,aladate=g_today
     WHERE ala01=g_ala.ala01
    CALL t710_delHeader()   #CHI-C30002 add
 
    CLOSE t710_bcl
    COMMIT WORK
 
END FUNCTION

#CHI-C30002 ------ add ------ begin
FUNCTION t710_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ala.ala01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ala_file ",
                  "  WHERE ala01 LIKE '",l_slip,"%' ",
                  "    AND ala01 > '",g_ala.ala01,"'"
      PREPARE t710_pb1 FROM l_sql 
      EXECUTE t710_pb1 INTO l_cnt    
      
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
        #CALL t710_x()                   #FUN-D20035
         CALL t710_x(1)                  #FUN-D20035
         IF g_ala.alafirm = 'X' THEN
           LET g_void = 'Y'
         ELSE
           LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE npp01 = g_ala.ala01
                                AND npp011= 0
                                AND nppsys='LC'
                                AND npp00 = 4
         DELETE FROM npq_file WHERE npq01 = g_ala.ala01
                                AND npq011= 0
                                AND npqsys='LC'
                                AND npq00 = 4
         DELETE FROM tic_file WHERE tic04 = g_ala.ala01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ala_file WHERE ala01 = g_ala.ala01
         INITIALIZE g_ala.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------ add ------ end
 
FUNCTION t710_alb04()
  DEFINE l_pmm09 LIKE pmm_file.pmm09,  #FUN-660117
         l_pmm20 LIKE pmm_file.pmm20,  #TQC-BB0144
         l_pma11 LIKE pma_file.pma11,  #FUN-660117
         l_sql   LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET g_errno = " "                         #-->check 付款廠商是否一致
  #FUN-A60056--mod--str--
  #SELECT pmm09,pma11 INTO l_pmm09,l_pma11 FROM pmm_file,pma_file
  # WHERE pmm01 = g_alb[l_ac].alb04
  #   AND pmm20 = pma01 AND pmm18 !='X'
   LET l_sql = "SELECT pmm09,pmm20,pma11 FROM ",                       #TQC-BB0144
                 cl_get_target_table(g_ala.ala97,'pmm_file'),",",
                 cl_get_target_table(g_ala.ala97,'pma_file'),
               " WHERE pmm01 = '",g_alb[l_ac].alb04,"'",
               "   AND pmm20 = pma01 AND pmm18 !='X'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_ala.ala97) RETURNING l_sql
   PREPARE sel_pmm09 FROM l_sql
   EXECUTE sel_pmm09 INTO l_pmm09,l_pmm20,l_pma11      #TQC-BB0144 add pmm20
  #FUN-A60056--mod--end
   CASE WHEN SQLCA.SQLCODE = 100      LET g_errno = 'aap-006'
        WHEN l_pmm09 != g_ala.ala05   LET g_errno = 'aap-199'
        #WHEN l_pma11 = '1'  LET g_errno = 'aap-740'   #MOD-790011
        WHEN l_pma11 = '1' OR l_pma11='2' OR l_pma11='C' LET g_errno = 'aap-740'   #MOD-790011
        WHEN l_pmm20 != g_ala.ala02   LET g_errno = 'aap-740'  #TQC-BB0144
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION t710_alb05(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_pmm09         LIKE pmm_file.pmm09,
           l_pmm22         LIKE pmm_file.pmm22,
           l_pmn04         LIKE pmn_file.pmn04,
           l_pmn16         LIKE pmn_file.pmn16,
           l_pmn87         LIKE pmn_file.pmn87,   #FUN-560089
           l_pmn31         LIKE pmn_file.pmn31,
           l_pmn041        LIKE pmn_file.pmn041,
           l_pmn86         LIKE pmn_file.pmn86 ,   #FUN-560089 
           l_pmn06         LIKE pmn_file.pmn06 ,
           l_sumalb07      LIKE alb_file.alb07,
           l_pmn930        LIKE pmn_file.pmn930  #FUN-680019
 
    LET g_errno = ' '
    IF g_alb[l_ac].alb04 = 'MISC' THEN RETURN END IF
    #LET g_sql = "SELECT pmm09,pmm22,pmn04,pmn16,pmn20,pmn31,pmn041,pmn07,pmn06",   #FUN-560089
    LET g_sql = "SELECT pmm09,pmm22,pmn04,pmn16,pmn87,pmn31,pmn041,pmn86,pmn06,pmn930",   #FUN-560089 #FUN-680019
                "      ,pmn83,pmn85,pmn80,pmn82 ", #MOD-960251     
               #FUN-A60056--mod--str--
               #"     FROM pmm_file,pmn_file",
                "  FROM ",cl_get_target_table(g_ala.ala97,'pmm_file'),",",
                "       ",cl_get_target_table(g_ala.ala97,'pmn_file'),
               #FUN-A60056--mod--end
                "    WHERE pmn01 = ? AND pmn02 = ?",
                "      AND pmn01 = pmm01 AND pmn16 !='9'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql   #FUN-A60056
    PREPARE t710_afp51 FROM g_sql
    DECLARE t710_af_51 CURSOR FOR t710_afp51
    OPEN t710_af_51 USING g_alb[l_ac].alb04,g_alb[l_ac].alb05
    FETCH t710_af_51 INTO
      l_pmm09,l_pmm22,l_pmn04,l_pmn16,l_pmn87,l_pmn31,l_pmn041,l_pmn86,l_pmn06,l_pmn930   #FUN-560089 #FUN-680019
      ,g_alb[l_ac].alb83,g_alb[l_ac].alb85,g_alb[l_ac].alb80,g_alb[l_ac].alb82 #MOD-960251 
    CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-006'
         WHEN l_pmm22 != g_ala.ala20 LET g_errno = 'aap-104'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    #-->採購單狀況必須為(發出狀況)
    IF l_pmn16 != '2' THEN LET g_errno = 'aap-198' RETURN END IF  #85-10-11by kitty 改為與整批產生一致
     IF NOT cl_null(g_errno) THEN RETURN END IF
    IF l_pmn87 IS NULL THEN LET l_pmn87 = 0 END IF   #FUN-560089
    IF l_pmn31 IS NULL THEN LET l_pmn31 = 0 END IF
    #-->檢查採購數量是否多預購
   #SELECT sum(alb07) INTO l_sumalb07 FROM alb_file              #MOD-A80215 mark
    SELECT sum(alb07) INTO l_sumalb07 FROM ala_file,alb_file     #MOD-A80215
     WHERE alb04 = g_alb[l_ac].alb04
       AND alb05 = g_alb[l_ac].alb05
       AND alb01 = ala01                                         #MOD-A80215
       AND alafirm <> 'X'                                        #MOD-A80215
    IF l_sumalb07 IS NULL OR l_sumalb07 = ' ' THEN
       LET l_sumalb07 = 0
    END IF
    LET g_alb[l_ac].alb06 = l_pmn31
    LET g_alb[l_ac].alb07 = l_pmn87 - l_sumalb07   #FUN-560089
    LET g_alb[l_ac].alb08 = g_alb[l_ac].alb06 * g_alb[l_ac].alb07
    LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
    LET g_alb[l_ac].alb11 = l_pmn04
    LET g_alb[l_ac].pmn041 = l_pmn041
    LET g_alb[l_ac].alb86  = l_pmn86    #FUN-710029 
    LET g_alb[l_ac].pmn06  = l_pmn06
    LET g_alb[l_ac].alb930=l_pmn930 #FUN-680019
    LET g_alb[l_ac].gem02c=s_costcenter_desc(g_alb[l_ac].alb930) #FUN-680019
    LET g_alb[l_ac].alb87 = l_pmn87                                                                                                 
    DISPLAY BY NAME g_alb[l_ac].alb06                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb07                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb08                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb11                                                                                               
    DISPLAY BY NAME g_alb[l_ac].pmn041                                                                                              
    DISPLAY BY NAME g_alb[l_ac].pmn06                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb930                                                                                              
    DISPLAY BY NAME g_alb[l_ac].gem02c                                                                                              
    DISPLAY BY NAME g_alb[l_ac].alb83                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb85                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb80                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb82                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb86                                                                                               
    DISPLAY BY NAME g_alb[l_ac].alb87                                                                                               
END FUNCTION
 
FUNCTION t710_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON alb02,alb04,alb05,alb11,
                       alb83,alb84,alb85,alb80,  #FUN-710029
                       alb81,alb82,alb86,alb87,  #FUN-710029
                       alb06,alb07,alb08,alb12
            FROM s_alb[1].alb02,s_alb[1].alb04,s_alb[1].alb05,
                 s_alb[1].alb11,
                 s_alb[1].alb83,s_alb[1].alb84,   #FUN-710029
                 s_alb[1].alb85,s_alb[1].alb80,   #FUN-710029
                 s_alb[1].alb81,s_alb[1].alb82,   #FUN-710029
                 s_alb[1].alb86,s_alb[1].alb87,   #FUN-710029
                 s_alb[1].alb06,s_alb[1].alb07,
                 s_alb[1].alb08,s_alb[1].alb11,s_alb[1].alb12
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
    CALL t710_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    LET g_sql = "SELECT alb02,alb04,alb05,alb11,pmn041,",                      #NO.FUN-710029  
                "       alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87, ",    #NO.FUN-710029
                "       alb06,alb07,",   #FUN-560089   #MOD-690139
                "       alb08,alb12,alb13,pmn06,alb930,'',",  #FUN-680019
                "       albud01,albud02,albud03,albud04,albud05,",
                "       albud06,albud07,albud08,albud09,albud10,",
                "       albud11,albud12,albud13,albud14,albud15", 
               #FUN-A60056--mod--str--
               #" FROM alb_file LEFT OUTER JOIN pmn_file ON alb_file.alb04 = pmn_file.pmn01 AND alb_file.alb05 = pmn_file.pmn02",
                " FROM alb_file LEFT OUTER JOIN ",cl_get_target_table(g_ala.ala97,'pmn_file'),
                "   ON alb_file.alb04 = pmn_file.pmn01 AND alb_file.alb05 = pmn_file.pmn02",
               #FUN-A60056--mod--end
                " WHERE alb01 ='",g_ala.ala01,"'",
                "   AND ",p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql   #FUN-A60056
    PREPARE t710_pb FROM g_sql
    DECLARE alb_curs CURSOR FOR t710_pb
 
    CALL g_alb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH alb_curs INTO g_alb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_alb[g_cnt].gem02c=s_costcenter_desc(g_alb[g_cnt].alb930) #FUN-680019
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_alb.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t710_bp_po(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_act_visible("maintain_entry2",FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_alb TO s_alb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #MOD-680045
 
      BEFORE DISPLAY                                              #MOD-840557
         CALL cl_navigator_setting(g_curs_index,g_row_count)      #MOD-840557
         CALL cl_show_fld_cont()       #No.TQC-B40039
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()       #No.TQC-B40039
 
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
       CALL t710_fetch('F')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION previous
       CALL t710_fetch('P')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION jump
       CALL t710_fetch('/')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION next
       CALL t710_fetch('N')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION last
       CALL t710_fetch('L')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION memo #備註
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      ON ACTION other_data  #其他資料
         LET g_action_choice="other_data"
         EXIT DISPLAY
 
      ON ACTION bl #提單記錄
         LET g_action_choice="bl"
         EXIT DISPLAY
 
      ON ACTION arriving_note #到單記錄
         LET g_action_choice="arriving_note"
         EXIT DISPLAY
 
      ON ACTION arrivals  #到貨記錄
         LET g_action_choice="arrivals"
         EXIT DISPLAY
 
      ON ACTION closing_log  #結案記錄
         LET g_action_choice="closing_log"
         EXIT DISPLAY
 
      ON ACTION update_log  #修改記錄
         LET g_action_choice="update_log"
         EXIT DISPLAY
      #--FUN-B10030--start--
     # ON ACTION switch_plant #工廠切換
     #    LET g_action_choice="switch_plant"
     #    EXIT DISPLAY
     # --FUN-B10030--end--
      ON ACTION void #作廢
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY 
      #FUN-D20035---add---end
 
       ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL t710_def_form()      #NO.FUN-710029
         IF g_ala.alafirm = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t710_bp0(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_act_visible("maintain_entry2",FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_alb TO s_alb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #MOD-680045
      BEFORE DISPLAY                                          #MOD-840557
        CALL cl_navigator_setting(g_curs_index,g_row_count)   #MOD-840557
        CALL cl_show_fld_cont()       #No.TQC-B40039
      BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()       #No.TQC-B40039
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
       CALL t710_fetch('F')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION previous
       CALL t710_fetch('P')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION jump
       CALL t710_fetch('/')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION next
       CALL t710_fetch('N')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    ON ACTION last
       CALL t710_fetch('L')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         IF g_ala.alafirm = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ala.alafirm,"","",g_ala.alaclos,g_void,"")
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
 
      ON ACTION gen_entry   #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
      ON ACTION maintain_entry #會計分錄維護
         LET g_action_choice="maintain_entry"
         EXIT DISPLAY
 
      ON ACTION maintain_entry2
         LET g_action_choice="maintain_entry2"
         EXIT DISPLAY
 
      ON ACTION other_data  #其他資料
         LET g_action_choice="other_data"
         EXIT DISPLAY
 
      ON ACTION modify_lc_no #改L/C NO
         LET g_action_choice="modify_lc_no"
         EXIT DISPLAY
 
      ON ACTION payment_acct  #付款科目
         LET g_action_choice="payment_acct"
         EXIT DISPLAY
 
      ON ACTION confirm  #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm  #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION memo #備註
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      ON ACTION payment_record  #付款記錄
         LET g_action_choice="payment_record"
         EXIT DISPLAY
 
      ON ACTION bl   #提單記錄
         LET g_action_choice="bl"
         EXIT DISPLAY
 
      ON ACTION arriving_note  #到單記錄
         LET g_action_choice="arriving_note"
         EXIT DISPLAY
 
      ON ACTION arrivals  #到貨記錄
         LET g_action_choice="arrivals"
         EXIT DISPLAY
 
      ON ACTION close_the_case  #結案記錄
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
 
      ON ACTION update_log  #修改記錄
         LET g_action_choice="update_log"
         EXIT DISPLAY
 
      ON ACTION cr_balance  #信貸餘額
         LET g_action_choice="cr_balance"
         EXIT DISPLAY
      #--FUN-B10030--start-- 
      # ON ACTION switch_plant #工廠切換
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
      ON ACTION void  #作廢
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY 
      #FUN-D20035---add---end
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
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
      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t710_bu(u_sw,r_sw)
   DEFINE u_sw,r_sw        LIKE type_file.num5        # No.FUN-690028 SMALLINT
 
 
   CALL t710_b_tot()
 
END FUNCTION
 
FUNCTION t710_b_tot()
 
   LET g_tot = NULL
 
   SELECT SUM(alb08) INTO g_tot FROM alb_file
    WHERE alb01 = g_ala.ala01
 
   DISPLAY g_tot TO tot2
 
END FUNCTION
 
FUNCTION t710_g_b()
   DEFINE l_tot              LIKE alb_file.alb08,
          l_sumalb07  LIKE alb_file.alb07,
          l_pmn930    LIKE pmn_file.pmn930 #FUN-680019
 
   IF g_ala.ala01 IS NULL THEN RETURN END IF
   SELECT azi04 INTO t_azi04 FROM azi_file
      WHERE azi01=g_ala.ala20
 
   OPEN WINDOW t710_g_b_w2 AT 10,20
     WITH FORM "aap/42f/aapt710_2"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt710_2")
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   CONSTRUCT BY NAME g_wc ON pmm01,pmm04,pmm13,pmm12,pmn04
 
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
 
   CLOSE WINDOW t710_g_b_w2
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
 
   LET g_sql = "SELECT '',pmn01,pmn02,pmn04,'',",
               "  pmn83,pmn84,pmn85,pmn80,pmn81,pmn82,pmn86,pmn87,", #FUN-710029
               "   pmn31,pmn87,0,0,0,'',pmn930",   #FUN-560089  #FUN-680019 #CHI-750011
              #FUN-A60056--mod--str--
              #"  FROM pmm_file, pmn_file, pma_file", 
               "  FROM ",cl_get_target_table(g_ala.ala97,'pmm_file'),",",
               "       ",cl_get_target_table(g_ala.ala97,'pmn_file'),",",
               "       ",cl_get_target_table(g_ala.ala97,'pma_file'),
              #FUN-A60056--mod--end 
               " WHERE ",g_wc CLIPPED,
               "   AND pmm01 = pmn01",
               "   AND pmn16 = '2' ",
               "   AND pmm09 = '",g_ala.ala05 CLIPPED,"'",
               "   AND pmm22 = '",g_ala.ala20 CLIPPED,"'",
               "   AND pmm20 = '",g_ala.ala02 CLIPPED,"'",    #TQC-B40135 add
               "   AND pmm20 = pma01 AND (pma11!='1' AND pma11!='2' AND pma11!='C')",   #TQC-5C0043   #MOD-790011
               " ORDER BY pmn01,pmn02"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
   CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql   #FUN-A60056
   PREPARE t710_g_b_p1 FROM g_sql
 
   DECLARE t710_g_b_c1 CURSOR WITH HOLD FOR t710_g_b_p1
 
   SELECT SUM(alb08) INTO g_tot FROM alb_file
    WHERE alb01 = g_ala.ala01
 
   IF g_tot IS NULL THEN
      LET g_tot = 0
   END IF
 
   LET l_ac = 1
 
   FOREACH t710_g_b_c1 INTO g_alb[l_ac].*,l_pmn930
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(g_alb[l_ac].alb07) THEN
         LET g_alb[l_ac].alb07 = 0
      END IF
 
     #SELECT sum(alb07) INTO l_sumalb07 FROM alb_file #-->採購預購申請量控制   #MOD-A80215 mark
      SELECT sum(alb07) INTO l_sumalb07 FROM ala_file,alb_file                 #MOD-A80215
       WHERE alb04 = g_alb[l_ac].alb04
         AND alb05 = g_alb[l_ac].alb05
         AND alb01 = ala01                                                     #MOD-A80215
         AND alafirm <> 'X'                                                    #MOD-A80215
 
      IF l_sumalb07 IS NULL THEN
         LET l_sumalb07 = 0
      END IF
 
      LET g_alb[l_ac].alb07 = g_alb[l_ac].alb07 - l_sumalb07
 
      IF g_alb[l_ac].alb07 <= 0 THEN
         CONTINUE FOREACH
      END IF
 
      SELECT max(alb02)+1 INTO g_alb[l_ac].alb02 FROM alb_file
       WHERE alb01 = g_ala.ala01
 
      IF g_alb[l_ac].alb02 IS NULL THEN
         LET g_alb[l_ac].alb02 = 1
      END IF
 
      IF g_alb[l_ac].alb06 IS NULL THEN
         LET g_alb[l_ac].alb06 = 0
      END IF
 
      LET g_alb[l_ac].alb08 = g_alb[l_ac].alb06 * g_alb[l_ac].alb07
      LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
      LET l_tot = g_tot + g_alb[l_ac].alb08
 
      DISPLAY '>:',g_alb[l_ac].alb02,' ',g_alb[l_ac].alb06,' ',
              g_alb[l_ac].alb07,' ',g_alb[l_ac].alb08,' Total:',l_tot AT 1,1
 
      IF (g_tot + g_alb[l_ac].alb08) > (g_ala.ala23 + g_ala.ala24) THEN
          IF cl_confirm("aap-106") THEN   #No.MOD-530815
            EXIT FOREACH
         END IF
      END IF
 
      LET g_tot = g_tot + g_alb[l_ac].alb08
 
      BEGIN WORK
      LET g_success='Y'
      IF g_sma.sma115 = 'Y' THEN
          CALL t710_set_du_by_origin('b')
      END IF
 
      INSERT INTO alb_file(alb01,alb02,alb04,alb05,alb06,alb07,alb08,
                           alb11,alb12,alb13,alb930, #FUN-680019
                           alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87,alblegal)  #FUN-710029 #FUN-980001 add legal #FUN-980076
                    VALUES(g_ala.ala01,g_alb[l_ac].alb02,
                           g_alb[l_ac].alb04,g_alb[l_ac].alb05,
                           g_alb[l_ac].alb06,g_alb[l_ac].alb07,
                           g_alb[l_ac].alb08,g_alb[l_ac].alb11,
                           g_alb[l_ac].alb12,g_alb[l_ac].alb13,g_alb[l_ac].alb930, #FUN-680019
                           g_alb[l_ac].alb83,g_alb[l_ac].alb84,g_alb[l_ac].alb85,  #FUN-710029
                           g_alb[l_ac].alb80,g_alb[l_ac].alb81,g_alb[l_ac].alb82,  #FUN-710029
                           g_alb[l_ac].alb86,g_alb[l_ac].alb87,g_legal)                      #FUN-710029 #FUN-980001 add legal  #FUN-980076
   
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_alb[l_ac].alb02,SQLCA.sqlcode,1)
         ROLLBACK WORK
         CONTINUE FOREACH
      END IF
 
      COMMIT WORK
   END FOREACH
 
   CALL t710_b_tot()
 
END FUNCTION

#作废/取消作废 
#FUNCTION t710_x()                        #FUN-D20035
FUNCTION t710_x(p_type)                   #FUN-D20035
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5     #No.FUN-690028 SMALLINT
   DEFINE l_alb04 LIKE alb_file.alb04     #MOD-AA0145
   DEFINE l_alb05 LIKE alb_file.alb05     #MOD-AA0145
   DEFINE p_type    LIKE type_file.chr1   #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1   #FUN-D20035

   IF s_aapshut(0) THEN
      RETURN
   END IF
 
   IF g_ala.ala01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01=g_ala.ala01
 
   IF g_ala.alafirm = 'Y' THEN
      CALL cl_err('fimr=Y ','axm-101',0)
      RETURN
   END IF
 
   IF g_ala.alaclos = 'Y' THEN
      CALL cl_err(g_ala.ala01,'aap-197',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM ale_file
    WHERE ale03 = g_ala.ala01
   IF l_cnt > 0 THEN
      CALL cl_err('ale.cnt>0','aap-190',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM alc_file
    WHERE alc01 = g_ala.ala01 AND
          alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
      AND alcfirm <> 'X' #CHI-C80041
   IF l_cnt > 0 THEN
      CALL cl_err('ale.cnt>0','aap-709',0)
      RETURN
   END IF
 
  #-MOD-AA0145-add-
   DECLARE t710_albchk2_c CURSOR FOR
       SELECT alb04,alb05 
         FROM alb_file
        WHERE alb01 = g_ala.ala01
   FOREACH t710_albchk2_c INTO l_alb04,l_alb05 
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ala.ala97,'rva_file'),",", 
                  "                     ",cl_get_target_table(g_ala.ala97,'rvb_file'),
                  " WHERE rva01 = rvb01       ", 
                  "   AND rvaconf <> 'X'      ",
                  "   AND rvb04 = '",l_alb04,"'",
                  "   AND rvb03 = ",l_alb05
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql               
      CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql     
      PREPARE sel_rvax_pre FROM g_sql
      EXECUTE sel_rvax_pre INTO l_cnt 
      IF l_cnt > 0 THEN 
         CALL cl_err(l_alb04,'apm-602',0) 
         RETURN 
      END IF
   END FOREACH
  #-MOD-AA0145-end-

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_ala.alafirm='X' THEN RETURN END IF
   ELSE
      IF g_ala.alafirm<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   LET g_success='Y'
   BEGIN WORK
 
   OPEN t710_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t710_cl INTO g_ala.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t710_show()
 
   #IF cl_void(0,0,g_ala.alafirm) THEN                                 #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
     #IF g_ala.alafirm='N' THEN    #切換為作廢                         #FUN-D20035
      #作废操作时
      IF p_type = 1 THEN                                               #FUN-D20035
         DELETE FROM npp_file
          WHERE npp01 = g_ala.ala01
            AND npp011 = 0
            AND nppsys = 'LC'
            AND npp00 = 4
         IF STATUS THEN
            CALL cl_err('del npp:',STATUS,0)
            LET g_success='N'
         END IF
 
         DELETE FROM npq_file
          WHERE npq01 = g_ala.ala01
            AND npq011 = 0
            AND npqsys = 'LC'
            AND npq00 = 4
         IF STATUS THEN
            CALL cl_err('del npq:',STATUS,0)
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_ala.ala01
         IF STATUS THEN
            CALL cl_err('del tic:',STATUS,0)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--
 
         LET g_ala.alafirm='X'
      ELSE                        #取消作廢
         LET g_ala.alafirm='N'
      END IF
#No:FUN-C60006---add--star---
      LET g_ala.alamodu = g_user
      LET g_ala.aladate = g_today
      DISPLAY BY NAME g_ala.alamodu
      DISPLAY BY NAME g_ala.aladate
#No:FUN-C60006---add--end---
 
      UPDATE ala_file SET alafirm = g_ala.alafirm,
           #No:FUN-C60006---add--star---
                          alamodu = g_user,
                          aladate = g_today
      #No:FUN-C60006---add--end---

       WHERE ala01 = g_ala.ala01
 
      IF STATUS THEN
         CALL cl_err('',STATUS,0)
         LET g_success = 'N'
      END IF
 
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('','aap-161',0)
         LET g_success = 'N'
      END IF
   END IF
 
   SELECT alafirm INTO g_ala.alafirm FROM ala_file
    WHERE ala01 = g_ala.ala01
 
   DISPLAY BY NAME g_ala.alafirm
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CLOSE t710_cl
 
END FUNCTION
 
FUNCTION t710_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ala01",TRUE)
   END IF
 
   IF INFIELD(ala33) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ala35,ala07",TRUE)
   END IF
 
   CALL cl_set_comp_entry("ala05,ala02,ala20",TRUE)   #TQC-640198
 
 
END FUNCTION
 
FUNCTION t710_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5     #TQC-640198  #No.FUN-690028 SMALLINT
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      IF g_chkey = 'N' THEN
         CALL cl_set_comp_entry("ala01",FALSE)
      END IF
      IF g_ala.ala25 > 0 THEN
         CALL cl_set_comp_entry("ala01",FALSE)
      END IF
      IF g_ala.ala26 > 0 THEN
         CALL cl_set_comp_entry("ala01",FALSE)
      END IF
   END IF
 
   IF INFIELD(ala33) OR (NOT g_before_input_done) THEN
      IF cl_null(g_ala.ala33) THEN
         CALL cl_set_comp_entry("ala35,ala07",FALSE)
         CALL cl_set_comp_required("ala35,ala07",FALSE)
      ELSE
         CALL cl_set_comp_required("ala35,ala07",TRUE)
      END IF
   END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM alb_file
     WHERE alb01=g_ala.ala01
   IF l_cnt > 0 THEN
      CALL cl_set_comp_entry("ala05,ala02,ala20",FALSE)
   END IF
END FUNCTION
 
FUNCTION t710_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
   CALL cl_set_comp_entry("alb81,alb83,alb84,alb85,alb87",TRUE)
END FUNCTION
 
FUNCTION t710_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("alb83,alb84,alb85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("alb83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("alb84,alb81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("alb87",FALSE)
   END IF
END FUNCTION
 
FUNCTION t710_gen_glcr(p_ala,p_apy)
  DEFINE p_ala     RECORD LIKE ala_file.*
  DEFINE p_apy     RECORD LIKE apy_file.*
 
    IF cl_null(p_apy.apygslp) THEN
       CALL cl_err(p_ala.ala01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t710_g_gl(p_ala.ala01,4,0)
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t710_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_no         LIKE type_file.chr3    #No.FUN-840125                
  DEFINE l_no1        LIKE type_file.chr3    #No.FUN-840125                
  DEFINE l_aac03      LIKE aac_file.aac03    #No.FUN-840125 
  DEFINE l_aac03_1    LIKE aac_file.aac03    #No.FUN-840125 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_ala.ala72,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl = g_apz.apz02p    #No.FUN-980059
 
    OPEN WINDOW t710p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
 
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029 add l_apygslp1
    
       AFTER FIELD gl_no
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)      #TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
        LET l_no = l_apygslp                                                        
        SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
        IF l_aac03 != '0' THEN                                                  
           CALL cl_err(l_no ,'agl-991',0)                                       
           NEXT FIELD gl_no                                                      
        END IF                                                                  
    
       AFTER FIELD gl_no1
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
                RETURNING li_result,l_apygslp1
          IF (NOT li_result) THEN
             NEXT FIELD gl_no1
          END IF
          LET l_no1 = l_apygslp1                                                        
          SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
          IF l_aac03_1 != '0' THEN                                                  
             CALL cl_err(l_no1,'agl-991',0)                                       
             NEXT FIELD l_apygslp1                                                     
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
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
             RETURNING l_apygslp
             DISPLAY l_apygslp TO FORMONLY.gl_no
             NEXT FIELD gl_no
          END IF
 
          IF INFIELD(gl_no1) THEN
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
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
    CLOSE WINDOW t710p  
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_ala.ala01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_ala.ala01,'" AND npp011 = 0'
    LET g_t1 = s_get_doc_no(l_apygslp)
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '1' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_ala.ala08,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT ala72 INTO g_ala.ala72 FROM ala_file
     WHERE ala01 = g_ala.ala01
    DISPLAY BY NAME g_ala.ala72
    
END FUNCTION
 
FUNCTION t710_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102 
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_ala.ala05,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_ala.ala72,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT ala72 INTO g_ala.ala72 FROM ala_file
     WHERE ala01 = g_ala.ala01
    DISPLAY BY NAME g_ala.ala72
END FUNCTION
 
FUNCTION t710_set_npq05(p_dept,p_ala930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ala930 LIKE ala_file.ala930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ala930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
 
FUNCTION t710_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("alb83,alb85,alb80,alb82",FALSE)
      CALL cl_set_comp_visible("alb86,alb07",TRUE)
   ELSE
      CALL cl_set_comp_visible("alb83,alb84,alb85,alb80,alb81,alb82",TRUE)
      CALL cl_set_comp_visible("alb07",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN   
      CALL cl_set_comp_visible("alb87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("alb84,alb81",FALSE)
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alb82",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("alb930,gem02b",g_aaz.aaz90='Y')
END FUNCTION
 
FUNCTION t710_set_required()
 
   IF g_sma.sma115 = 'Y' THEN
       #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
       IF g_ima906 = '3' THEN
            CALL cl_set_comp_required("alb83,alb85,alb80,alb82",TRUE)
       END IF
       #單位不同,轉換率,數量必KEY
       IF NOT cl_null(g_alb[l_ac].alb80) THEN
          CALL cl_set_comp_required("alb82",TRUE)
       END IF
       IF NOT cl_null(g_alb[l_ac].alb83) THEN
          CALL cl_set_comp_required("alb85",TRUE)
       END IF
       IF g_sma.sma116 NOT MATCHES '[02]' THEN
            IF NOT cl_null(g_alb[l_ac].alb86) THEN
                CALL cl_set_comp_required("alb87",TRUE)
            END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t710_set_no_required()
  CALL cl_set_comp_required("alb83,alb84,alb85,alb80,alb81,alb82,alb86,alb87",FALSE)
END FUNCTION
 
#default 雙單位/轉換率/數量
FUNCTION t710_du_default(p_cmd)
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
 
    LET l_item = g_alb[l_ac].alb11
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
       LET g_alb[l_ac].alb83=l_unit2
       LET g_alb[l_ac].alb84=l_fac2
       LET g_alb[l_ac].alb85=l_qty2
       LET g_alb[l_ac].alb80=l_unit1
       LET g_alb[l_ac].alb81=l_fac1
       LET g_alb[l_ac].alb82=l_qty1
       LET g_alb[l_ac].alb86=l_unit3
       LET g_alb[l_ac].alb87=l_qty3
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t710_set_origin_field()
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
      FROM ima_file WHERE ima01=g_alb[l_ac].alb11
    IF SQLCA.sqlcode = 100 THEN
       IF g_alb[l_ac].alb11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_alb[l_ac].alb84
    LET l_qty2=g_alb[l_ac].alb85
    LET l_fac1=g_alb[l_ac].alb81
    LET l_qty1=g_alb[l_ac].alb82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_alb[l_ac].alb86=g_alb[l_ac].alb80
                   LET g_alb[l_ac].alb07=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_alb[l_ac].alb86=l_ima44
                   LET g_alb[l_ac].alb07=l_tot
          WHEN '3' LET g_alb[l_ac].alb86=g_alb[l_ac].alb80
                   LET g_alb[l_ac].alb07=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_alb[l_ac].alb84=l_qty1/l_qty2
                   ELSE
                      LET g_alb[l_ac].alb84=0
                   END IF
       END CASE
    END IF
 
    LET g_factor = 1
    CALL s_umfchk(g_alb[l_ac].alb11,g_alb[l_ac].alb86,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
       LET g_alb[l_ac].alb87 = g_alb[l_ac].alb07
    END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t710_du_data_to_correct()
   IF cl_null(g_alb[l_ac].alb80) THEN
      LET g_alb[l_ac].alb81 = NULL
      LET g_alb[l_ac].alb82 = NULL
   END IF
 
   IF cl_null(g_alb[l_ac].alb83) THEN
      LET g_alb[l_ac].alb84 = NULL
      LET g_alb[l_ac].alb85 = NULL
   END IF
 
   IF cl_null(g_alb[l_ac].alb86) THEN
      LET g_alb[l_ac].alb87 = NULL
   END IF
   DISPLAY BY NAME g_alb[l_ac].alb81
   DISPLAY BY NAME g_alb[l_ac].alb82
   DISPLAY BY NAME g_alb[l_ac].alb84
   DISPLAY BY NAME g_alb[l_ac].alb85
   DISPLAY BY NAME g_alb[l_ac].alb86
   DISPLAY BY NAME g_alb[l_ac].alb87
 
END FUNCTION
 
FUNCTION t710_set_du_by_origin(p_code)
  DEFINE l_ima44    LIKE ima_file.ima44,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_alb11    LIKE alb_file.alb11,
         l_factor   LIKE ima_file.ima31_fac,  #No.FUN-680136  DECIMAL(16,8),
         p_code     LIKE type_file.chr1       #No.FUN-680136  VARCHAR(01)
 
    LET l_alb11 = g_alb[l_ac].alb11
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_alb11
 
    IF cl_null(g_alb[l_ac].alb80) THEN
       LET g_alb[l_ac].alb80 = g_alb[l_ac].alb86
       LET g_alb[l_ac].alb82 = g_alb[l_ac].alb07
    END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET g_alb[l_ac].alb83 = NULL
       LET g_alb[l_ac].alb84 = NULL
       LET g_alb[l_ac].alb85 = NULL
    ELSE
       IF cl_null(g_alb[l_ac].alb83) THEN
          LET g_alb[l_ac].alb83 = l_ima907
          CALL s_du_umfchk(l_alb11,'','','',g_alb[l_ac].alb86,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET g_alb[l_ac].alb84 = l_factor
          LET g_alb[l_ac].alb85 = 0
       END IF
    END IF
    IF cl_null(g_alb[l_ac].alb86) THEN
       LET g_alb[l_ac].alb86 = g_alb[l_ac].alb86
       LET g_alb[l_ac].alb87 = g_alb[l_ac].alb07
    END IF
 
END FUNCTION
 
FUNCTION t710_set_alb87()
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
      FROM ima_file WHERE ima01=g_alb[l_ac].alb11
 
    IF SQLCA.sqlcode =100 THEN
       IF g_alb[l_ac].alb11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_alb[l_ac].alb84
       LET l_qty2=g_alb[l_ac].alb85
       LET l_fac1=g_alb[l_ac].alb81
       LET l_qty1=g_alb[l_ac].alb82
    ELSE
       LET l_fac1=g_alb[l_ac].alb86
       LET l_qty1=g_alb[l_ac].alb07
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
    CALL s_umfchk(g_alb[l_ac].alb11,l_ima44,g_alb[l_ac].alb86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_alb[l_ac].alb87 = l_tot
    LET g_alb[l_ac].alb87 = s_digqty(g_alb[l_ac].alb87,g_alb[l_ac].alb86)   #No.FUN-BB0086
END FUNCTION
 
 
FUNCTION t710_bookno()                                                                                                              
   IF g_apz.apz02='Y' THEN          #MOD-BB0212 mod sma03 -> apz02
      LET g_db1 = g_apz.apz02p      #MOD-BB0212 mod sma87 -> apz02p
   ELSE                                                                                                                             
      LET g_db1 = g_plant                                                                                                           
   END IF 
   LET g_plantm = g_db1               #FUN-980020
   SELECT azp03 INTO g_azp03 FROM azp_file                                                                                          
    WHERE azp01=g_db1                                                                                                               
   LET g_db_type=cl_db_get_database_type()                                                                                             
 
   LET g_dbsm = s_dbstring(g_azp03 CLIPPED)

   CALL s_get_bookno1(YEAR(g_ala.ala77),g_plantm)    #FUN-980020
        RETURNING g_flag1,g_bookno1,g_bookno2                                                                                        
   IF g_flag1 =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_err(g_plantm,'aoo-081',1)              #FUN-980020                                                                                  
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B90033
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#No.FUN-B10050  --Begin
FUNCTION t710_aag01(p_aag00,p_aag01,p_type)
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
            WHEN '1'  DISPLAY l_aag02 TO FORMONLY.aag02_1
            WHEN '2'  DISPLAY l_aag02 TO FORMONLY.aag02_2
       END CASE
    END IF
END FUNCTION
#No.FUN-B10050  --End

#No.FUN-BB0086--add--begin--
FUNCTION t710_alb07_check(l_sumalb07,l_poqty,l_lcqty,p_cmd)
DEFINE l_sumalb07,l_poqty,l_lcqty LIKE alb_file.alb07
DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_alb[l_ac].alb07) AND NOT cl_null(g_alb[l_ac].alb86) THEN
      IF cl_null(g_alb_t.alb07) OR cl_null(g_alb86_t) OR g_alb_t.alb07 != g_alb[l_ac].alb07 OR g_alb86_t != g_alb[l_ac].alb86 THEN
         LET g_alb[l_ac].alb07=s_digqty(g_alb[l_ac].alb07,g_alb[l_ac].alb86)
         DISPLAY BY NAME g_alb[l_ac].alb07
      END IF
   END IF
   
   IF g_alb[l_ac].alb04 != 'MISC' THEN
      SELECT sum(alb07) INTO l_sumalb07 FROM alb_file,ala_file
       WHERE alb04 = g_alb[l_ac].alb04
         AND alb05 = g_alb[l_ac].alb05
         AND ala01 = alb01 
         AND alafirm <> 'X'
      IF l_sumalb07 IS NULL OR l_sumalb07 = ' ' THEN
         LET l_sumalb07 = 0
      END IF
      LET g_sql = "SELECT pmn87 FROM ",cl_get_target_table(g_ala.ala97,'pmn_file'),
                  " WHERE pmn01 = '",g_alb[l_ac].alb04,"'" ,
                  "   AND pmn02 = '",g_alb[l_ac].alb05,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ala.ala97) RETURNING g_sql
      PREPARE sel_pmn07 FROM g_sql
      EXECUTE sel_pmn07 INTO l_poqty
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_alb[l_ac].alb04,'aap-006',0)
         RETURN FALSE,'abl04'
      END IF
      IF p_cmd = 'a' THEN
         LET l_lcqty = l_sumalb07 + g_alb[l_ac].alb07
      ELSE
         LET l_lcqty = l_sumalb07 + g_alb[l_ac].alb07 - g_alb_t.alb07
      END IF
      IF l_lcqty > l_poqty THEN
         CALL cl_err(l_sumalb07,'aap-196',0)
         LET g_alb[l_ac].alb07 = g_alb_t.alb07
         RETURN FALSE,'abl07'
      END IF
   END IF
   LET g_alb[l_ac].alb08 = g_alb[l_ac].alb06 * g_alb[l_ac].alb07
   LET g_alb[l_ac].alb08 = cl_digcut(g_alb[l_ac].alb08,t_azi04)
   DISPLAY BY NAME g_alb[l_ac].alb08
   RETURN TRUE,''
END FUNCTION 

FUNCTION t710_alb82_check(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1
   IF NOT cl_null(g_alb[l_ac].alb82) AND NOT cl_null(g_alb[l_ac].alb80) THEN
      IF cl_null(g_alb_t.alb82) OR cl_null(g_alb80_t) OR g_alb_t.alb82 != g_alb[l_ac].alb82 OR g_alb80_t != g_alb[l_ac].alb80 THEN
         LET g_alb[l_ac].alb82=s_digqty(g_alb[l_ac].alb82,g_alb[l_ac].alb80)
         DISPLAY BY NAME g_alb[l_ac].alb82
      END IF
   END IF

   IF NOT cl_null(g_alb[l_ac].alb82) THEN
      IF g_alb[l_ac].alb82 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF
   CALL t710_set_origin_field()
   IF cl_null(g_alb[l_ac].alb86) THEN
      LET g_alb[l_ac].alb87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
             g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
             g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
             g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
             g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
         CALL t710_set_alb87()
      END IF
   END IF
   CALL cl_show_fld_cont()                   
   RETURN TRUE
END FUNCTION 

FUNCTION t710_alb85_check(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1
   IF NOT cl_null(g_alb[l_ac].alb85) AND NOT cl_null(g_alb[l_ac].alb83) THEN
      IF cl_null(g_alb_t.alb85) OR cl_null(g_alb83_t) OR g_alb_t.alb85 != g_alb[l_ac].alb85 OR g_alb83_t != g_alb[l_ac].alb83 THEN
         LET g_alb[l_ac].alb85=s_digqty(g_alb[l_ac].alb85,g_alb[l_ac].alb83)
         DISPLAY BY NAME g_alb[l_ac].alb85
      END IF
   END IF

   IF NOT cl_null(g_alb[l_ac].alb85) THEN
      IF g_alb[l_ac].alb85 < 0 THEN
         CALL cl_err('','aim-391',1) 
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_alb_t.alb85 <> g_alb[l_ac].alb85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_alb[l_ac].alb85*g_alb[l_ac].alb84
            IF cl_null(g_alb[l_ac].alb82) OR g_alb[l_ac].alb82=0 THEN #CHI-960022
               LET g_alb[l_ac].alb82=g_tot*g_alb[l_ac].alb81
               DISPLAY BY NAME g_alb[l_ac].alb82                      #CHI-960022
            END IF                                                    #CHI-960022
         END IF
      END IF
   END IF
   IF cl_null(g_alb[l_ac].alb86) THEN
      LET g_alb[l_ac].alb87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_alb_t.alb81 <> g_alb[l_ac].alb81 OR
             g_alb_t.alb82 <> g_alb[l_ac].alb82 OR
             g_alb_t.alb84 <> g_alb[l_ac].alb84 OR
             g_alb_t.alb85 <> g_alb[l_ac].alb85 OR
             g_alb_t.alb86 <> g_alb[l_ac].alb86) THEN
         CALL t710_set_alb87()
      END IF
   END IF
   CALL cl_show_fld_cont()                    
   RETURN TRUE
END FUNCTION 

FUNCTION t710_alb87_check()
   IF NOT cl_null(g_alb[l_ac].alb87) AND NOT cl_null(g_alb[l_ac].alb86) THEN
      IF cl_null(g_alb_t.alb87) OR cl_null(g_alb86_t) OR g_alb_t.alb87 != g_alb[l_ac].alb87 OR g_alb86_t != g_alb[l_ac].alb86 THEN
         LET g_alb[l_ac].alb87=s_digqty(g_alb[l_ac].alb87,g_alb[l_ac].alb86)
         DISPLAY BY NAME g_alb[l_ac].alb87
      END IF
   END IF

   IF NOT cl_null(g_alb[l_ac].alb87) THEN
      IF g_alb[l_ac].alb87 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF                  
   RETURN TRUE
END FUNCTION 
#No.FUN-BB0086--add--end--
