# Prog. Version..: '5.10.16-10.11.01(00010)'     #
#
# Pattern name...: aglp001.4gl
# Descriptions...: 資料匯入合併區作業(整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify.......... No.9699 04/07/09 By Nicola aag_file前加上g_dbs_gl
# Modify.......... No.9701 04/07/09 By Nicola 幣別小數捉取, 應依母公司幣別為主SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=x_aaa03
# Modify.........: No:MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0072 04/11/25 By Nicola 加入"匯率計算"功能
# Modify ........: No.FUN-560060 05/06/13 By wujie 單據編號加大,多工廠返工 
# Modify ........: No.FUN-580063 05/08/19 By Sarah 
#                  1.不使用TIPTOP(axz04='N')資料抓aglt003資料(axq13)匯入(axg_file,axk_file)
#                  2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
#                    年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
#                    金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
#                    乘上匯率逐一算出借貸方計帳金額(axg08,axg09 OR axk10,axk11)
#                  3.一併存入上層公司記帳幣別(axg12,axk14)
#                  4.從aglt003匯入axk_file時(合併前科目異動碼資料),
#                    axk06固定='4',axk07=axq13(關係人代號)
#                  5.axg_file增加四欄位：axg13(下層公司原幣別借方金額),
#                                        axg14(下層公司原幣別貸方金額),
#                                        axg15(功能幣別借方金額),
#                                        axg16(功能幣別貸方金額)
# Modify ........: No.FUN-5A0020 05/10/05 By Sarah 
# Modify ........: No.FUN-5A0118 05/10/19 By Sarah 1.沒產生沖銷分錄
#                                                  2.資料寫入axg_file時,科目沒有轉換
# Modify ........: No:FUN-570145 06/02/27 By YITING 批次背景執行
# Modify ........: No:FUN-630063 06/03/22 By ching 10組異動碼相關
# Modify.........: No:MOD-660034 06/06/13 By Smapmin 修改抓取匯率方式
# Modify.........: No:TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No:FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No:MOD-6A0039 06/10/14 By Smapmin 年度與月份不應受限於aaa07
# Modify.......... No.MOD-6A0066 06/10/17 By yjkhero  當有多個科目合并為一個科目時，axg_file記錄有問題
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No:FUN-710023 07/01/15 By yjkhero 錯誤訊息匯整
# Modify.........: No:MOD-730070 07/03/16 By Smapmin 修改對沖公司代號判斷條件
# Modify.........: No:FUN-740020 07/04/12 By Carrier 會計科目加帳套-財務
# Modify.........: No:MOD-750036 07/05/10 By Smapmin 修改變數使用錯誤等相關問題
# Modify.........: No:FUN-750078 07/05/24 By Sarah 畫面INPUT條件增加版本、歷史匯率年度、歷史匯率期別
# Modify.........: No:FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,歷史匯率年度,期別,計算時寫死抓版本00的資料
# Modify.........: No:FUN-760053 07/06/21 By Sarah 
#                  1.來源、對沖科目為MISC的，獨立寫入分錄
#                  2.匯入時,若科目設定依歷史匯率(axe11='2',axe12='2'),金額抓agli011裡的設定,依異動日期抓歷史匯率(agli008)計算匯率
#                  3.當來源、對沖科目是MISC時,MISC來源科目餘額應抓來源公司的科目餘額,MISC對沖科目餘額應抓對沖公司的科目餘額
#                  4.非tiptop公司,INSERT axk_file,axk06(異動碼序)應給99
# Modify.........: No:TQC-770118 07/07/25 By Sarah 
#                  1.當公司層級資料較複雜(有非tiptop公司)時,INSERT INTO axg_file或axk_file時有可能出現-239,增加判斷出現-239則做UPDATE
#                  2.當錯誤訊息匯整後,應該用CONTUINUE FOREACH而不是用EXIT FOREACH
#                  3.當執行有錯誤時,就不執行寫入分錄(p001_modi(),p001_adj())的動作
# Modify.......... No.FUN-770069 07/07/31 By Sarah 1.寫入axk_file,axg_file,axi_file時,除了寫入版本為00的資料外,要再寫入版本為截止期別(tm.em)的資料
#                                                  2.歷史匯率部分改以axr07,axr03,axr08,axr09對應抓出輸入歷史變動金額(axr05)
# Modify.........: No:MOD-780115 07/08/17 By Sarah 換算子公司功能幣別時,應與該子公司記帳幣別比較,若不同才需換算
# Modify.........: No:MOD-890130 08/09/17 By Sarah 產生沖銷分錄時,若金額為0則不產生分錄
# Modify.........: No:MOD-910248 09/02/02 By Sarah 當axu05='+'時,SUM(axg08-axg09)不需*-1
# Modify.........: No:MOD-930135 09/03/12 By lilingyu 增加版本條件
# Modify.......... No.MOD-930210 09/03/20 By Sarah 刪除axi_file、axj_file、計算axi_file筆數時,請加串版本(axi21)條件
# Modify.......... No.MOD-940010 09/04/02 By Sarah get_rate()段,抓axd_file時應串下層公司,且SQL應以axd08b由大至小排序
# Modify.........: No:MOD-950019 09/05/05 By Sarah 抓取科目餘額檔、科目異動碼餘額檔時,只抓貨幣性科目(aag09='Y')的資料
# Modify.......... NO.FUN-920067 09/05/19 BY jan 寫入axk_file,axg_file時應以合併帳別寫入
# Modify.........: No:FUN-910001 09/05/19 By lutingting 由11區追單,                                                                                  
# Modify.........: NO.FUN-A90006 10/09/02 BY yiting 對沖科餘計算BS/IS皆採用累計式計算方式
#                  1.串axe_file時,增加串axe13(族群代號)=tm.axa01                                                                    
#                  2.產生分錄時寫入的關系人(axj05)需以公司代號串到axz_file抓取axz08 
# Modify........... NO.FUN-930018 09/05/20 BY ve007 在抓取axr_file時，當axr13有值，直接用此金額帶入，ELSE IF axr05 > 0 照舊用axr05金額計算    
# Modify........... NO.FUN-930112 09/05/20 BY ve007 1.產生調整分錄時，原本抓取axk_file科目餘額檔時
#                                                   axk10 = 0時就CONTINUE FOREACH，將此段MARK
#                                                   2.對沖時，金額小於零放在借方，反之放貸方
#                                                   3.科目性質為1時，要累算前期餘額
# Modify..........: NO.FUN-930117 09/05/20 BY ve007 pk值異動，相關程式修改
# Modify..........: NO.FUN-930144 09/05/20 BY ve007
#                                             1.aglt001在確認時，自動產生一筆分錄單號，版本為"截止期別" ，其餘資料與00版本相同(年度/期別為current單據) ，並將00版本的單號axi01記錄在
#                                               產生的新單號axi13欄位
#                                             2.aglp001 在產生axi_file時(截止期別那張，版本00) 將ins_ver那段先執行後，回頭寫入axi13單號記錄(原本為no use)
#                                             3.非MISC類科目，抓取axk_file時，科目性質為1.資料負債類科目，需從第0期開始sum到截止期別金額，非資料負債類則只有當期金額
# Modify..........: NO.FUN-920167 09/05/21 BY jan 科目來源及對象皆為MISC時，關係人應回抓axz08 
# Modify........... NO.FUN-920110 09/05/21 BY jan 1抓取axr_file時，以抓取結轉的年度+前期月份資料
# Modify........... No.FUN-910023 09/05/21 By lutingting 將下層合并後異動碼餘額檔axkk_file并到上層的合并前異動碼於額檔axk_file 
# Modify..........: No.FUN-950048 09/05/25 By jan 畫面上的起始期別設為noentry,并且預設為0
# Modify..........: NO.FUN-960003 09/05/30 BY yiting 1.處理第0期股本調整分錄時，以axf14為依據產生，axf14 = 'Y'時才產生第0期分錄
#                                                    2.取消版本觀念,ins_ver( )段取消
#                                                    3.原只分為MISC<->MISC,及非MISC<->非MISC,現改為以agli003設定為主
#                                                    4.Axg_file,axk_file新增「功能幣別匯率」「合併幣別匯率」記錄當時計算的匯率
# Modify........... NO.FUN-970046 09/07/13 BY yiting 1.aglp001在抓取aah_file,aed_file,axq_file寫入axg_file,axk_file時，應依科目性質處理是否做累計處理
#                                                      資產負債類做SUM(借-貸)處理，期別BETWEEN 0~截止期別，損益類則不做SUM
#                                                      寫入axg_file,axk_file時，只寫入截止期別，己產生過的期別不再異動
#                                                    2.寫入axi_file,axj_file時，對沖科目設定"股本"打勾者，才能處理"axt05 是否依股權沖銷" 
#                                                    3.寫入axi_file,axj_file時，只抓取截止期別當期資料寫入調整分錄
#                                                    4.因axr_file(axr08,axr09,axr10,axr11) schema異動，加axr06，原本日期條件改對應到axr06抓取資料，以公司+科目為key，抓於小於截止期別的資料SUM(axr13) 
#                                                    5.處理對沖科目時，如果來源科目找不到資料寫入調整分錄，但對沖科目找的到，也要寫進分錄中
# Modify.........: No.MOD-980063 09/08/11 By xiaofeizhu 如果各子公司先做月結，會把科目余額清0，金額拋成CE類的憑証
#                                                       但是這支p作業沒有考慮CE類的憑証，只抓科目余額過去，如果抓到0，那樣在aglr002里就打不出資料來了
#                                                       所以aglp001中需要增加判斷是否是損益類的科目，且余額為0，是的話就要去找CE類憑証中將這個科目的金額抓回來
# Modify.......... No.FUN-980074 09/08/18 By hongmei 計算累換調整數來源都應只有axg_file,不用再處理axk_file
# Modify.........: NO.FUN-980083 09/08/19 BY yiting aglp001在取異動月份最後一天日期時有誤 
# Modify.........: NO.FUN-980095 09/08/21 BY yiting 累換數計算條件有誤,應只計算科目性質為"資產負債類"會科
# Modify.........: NO.MOD-990059 09/09/07 BY sabrina 過單 
# Modify.........: NO.FUN-990020 09/09/08 BY yiting 1.在agli011中同一年度不同期別分別有股本異動二次，但GROUP SUM時因為有抓axr05造成無法把相同年度不同期別的合併金額加總
#                                                   2.外幣換算損益(aaz86)科目計算
# Modify.......... NO.FUN-9B0017 09/11/24 By mike 1.將異動碼科目余額檔aed_file做滾算至上層公司處理(異動碼5-8)aei_file，提供后續部門別合并財報使用
#                                                 2.aglp001目前有計算記賬幣別轉換功能幣別的金額, 差異歸入兌換損益處理
# Modify.........: No:MOD-A10005 10/01/04 By Sarah 修正FUN-990020,p001_adj()段SELECT後沒將值丟給變數,造成後續使用該變數時抓到Null值
# Modify.........: No.FUN-A10015 10/02/09 By chenmoyan
# Modify.........: No.FUN-A30064 10/03/19 By chenmoyan 合并報表-側流功能修正 開放子公司間互相對衝
# Modify.........: No.FUN-A30122 10/04/08 By chenmoyan 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: NO.FUN-A30079 10/03/24 By yiting 1.因應agli003加入合併主體axf16欄位，產生對沖分錄應以此為依據
#                                                   2.增加axk18,axk19,axk20,axk21記錄下層公司記帳/功能幣金額
# Modify.........: NO.MOD-A40158 10/04/27 By sabrina p001_axg_misc_p1的sql有誤，AMD改為AND
# Modify.........: NO.MOD-A40179 10/04/30 By sabrina 資產負債類科目產生之累換調整數之分錄有誤 
# Modify.........: NO.MOD-A50056 10/05/10 BY yiting 取g_aaz113的SQL被MARK掉
# Modify.........: NO.MOD-A60056 10/06/09 BY Dido 調整抓取語法與變數宣告 
# Modify.........: NO.MOD-A60080 10/06/11 BY Dido axi09 預設值為N 
# Modify.........: NO.FUN-A60038 10/06/15 by Yiting 1.BS本期損益數計算方式應同IS科目計算方式避免造成過大的累換數
#                                                   2.合併計算時沒有月結處理，需手動調整結清虛帳戶，不合理
# Modify.......... NO.FUN-A60060 10/06/22 by Yiting 1.側流問題  2.axq_file加入群組為條件 3.取axh_file要取位
# Modify.........: NO.FUN-A60078 10/06/24 BY yiting 產生沖銷分錄時，上下層公司條件取法
# Modify.........: NO.MOD-A60178 10/06/28 BY Dido p001_acc_amt 傳遞參數調整 
# Modify.........: NO.FUN-A60099 10/06/30 by Yiting 取沖銷來源金額時，中間層母公司的上下層公司條件應為自己
# Modify.........: NO.FUN-A70011 10/07/02 BY yiting 取對沖資料，最下層公司要加入上層公司=目前下層公司的上層公司 為條件
# Modify.........: NO.MOD-A70064 10/07/08 BY yiting 變數寫錯
# Modify.........: NO.FUN-A70053 10/07/09 BY yiting 本期損益BS科目設為平均匯率時，應各月乘各自匯率再累加
# Modify.........: NO.MOD-A70083 10/07/09 BY yiting 累換數分錄沒有產生
# Modify.........: NO.MOD-A70091 10/07/12 BY Dido axk18/19/20/21 應以原欄位計算 
# Modify.......... NO.FUN-A70065 10/07/12 BY yiting 資料來源為axh_file時,再衡量/換算採平均匯率計算方式,同一般由總帳來源資料算法
# Modify.........: NO.MOD-A70107 10/07/14 BY sabrina 將axe06的值給axg05
# Modify.........: NO.MOD-A70111 10/07/14 BY sabrina 若axee06抓不到值時要顯示aap-021的錯誤訊息 
# Modify.........: NO.MOD-A70113 10/07/14 BY sabrina 使用axf10取得axz05，將取得的axz05作為axb05、axd05b的條件 
# Modify.........: NO.FUN-A70086 10/07/16 BY yiting agli011增加功能幣別/再衡量匯率/功能幣金額，換算採歷史匯率時，要依此寫入
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.......... NO.MOD-A80102 10/08/12 BY yiting 取來源axh,axkk的資料時，aag_file不需要跨資料庫
# Modify.........: NO.FUN-A80125 10/08/23 BY yiting 產生換匯分錄時如果計算的結果是沒有傳票單身，但傳票單頭不要產生
# Modify.........: NO.FUN-A80130 10/08/24 by Yiting 1.axg,axk取平均匯率的方式應分開計算
#                                                   2.計算科目平均匯率金額時，傳入科目變數參數應為轉換後科目
# Modify.........: NO.FUN-A80137 10/08/26 BY yiting 來源及目的公司對沖科目，可個別設定來源檔案
# Modify.........: NO.FUN-A90006 10/09/02 BY yiting 對沖科餘計算BS/IS皆採用累計式計算方式
# Modify.........: NO.FUN-A90026 10/09/14 BY yiting 1.aah->aej,aed->aek,aedd->aem,axq->aej,aek,aem
#                                                   2.輸入增加選項
# Modify.........: NO.FUN-A90036 (1)分錄順序改先產生換匯(step4) ->再產生沖銷分錄(step3)
#                                (2)沖銷分錄含累換數(axg + axj)
# Modify.........: NO.FUN-AA0005 10/10/04 BY yiting 取來源aej,aek匯入axg,axk時，加入調整分錄屬於1.調整作業者
# Modify.........: NO.TQC-AA0098 10/10/16 BY yiting 1.平均匯率(axa05)選擇1，匯率要倒除之前先判斷axe11,axe12匯率方式，為3.平均匯率者才倒除
#                                                   2.移除axz04(是否為TIPTOP公司條件) 因此段己移往aglp000處理
# Modify.........: NO.FUN-AA0093 10/10/28 BY yiting 當下層公司亦為上層公司時，沖銷分錄金額如科目採平均匯率，一律採累計額*當期匯率
# Modify.........:...............10/11/10 By lutingting insert axi_file,axj_file拆分至aglp007处理,本作业处理axg,axk
# Modify.........................10/11/17 By lutingting拿掉tm.gl.在aglp007中才会用到
# Modify.........................11/08/03 By lutingting 新增原始公司編號
# Modify.........: No.FUN-B80135 11/08/24 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: NO.130717     13/07/17 by xiayan 修正原始公司编号取值

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm         RECORD  
                  yy        LIKE type_file.num5,   #匯入會計年度  #No.FUN-680098     SMALLINT
                  bm        LIKE type_file.num5,   #起始期間      #No.FUN-680098     SMALLINT
                  em        LIKE type_file.num5,   #截止期間      #No.FUN-680098     SMALLINT
                  axa01     LIKE axa_file.axa01,   #族群代號
                  axa02     LIKE axa_file.axa02,   #上層公司編號
                  axa03     LIKE axa_file.axa03,   #帳別
                  gl        LIKE aac_file.aac01,   #調整單別
                  ver       LIKE axg_file.axg17,   #版本          #FUN-750078 add
                  hisyy     LIKE axg_file.axg06,   #歷史匯率年度  #FUN-750078 add
                  hismm     LIKE axg_file.axg07,    #歷史匯率期別  #FUN-750078 add
                  axa06     LIKE axa_file.axa06,   #FUN-A90026 
                  q1        LIKE type_file.chr1,    #FUN-A90026
                  h1        LIKE type_file.chr1    #FUN-A90026
                  END RECORD,
       x_aaa03    LIKE aaa_file.aaa03,             #上層公司記帳幣別
       g_aaa04    LIKE aaa_file.aaa04,             #現行會計年度
       g_aaa05    LIKE aaa_file.aaa05,             #現行期別
       g_aaa07    LIKE aaa_file.aaa07,             #關帳日期
       g_bdate    LIKE type_file.dat,              #期間起始日期  #No.FUN-680098     DATE
       g_edate    LIKE type_file.dat,              #期間起始日期  #No.FUN-680098     DATE
       g_dbs_gl   LIKE type_file.chr21,                           #No.FUN-680098     VARCHAR(21)
       g_bookno   LIKE aea_file.aea00,             #帳別
       ls_date         STRING,                     #No:FUN-570145
       l_flag          LIKE type_file.chr1,        #NO.FUN-570145      #No.FUN-680098 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,        #NO.FUN-570145      #No.FUN-680098 VARCHAR(1)    
       g_axk      RECORD LIKE axk_file.*,
       g_axg      RECORD LIKE axg_file.*,          #FUN-760053 add
       g_rate     LIKE type_file.num20_6,          #FUN-770069 mod
       g_aac      RECORD LIKE aac_file.*,
       g_axi      RECORD LIKE axi_file.*,
       g_axj      RECORD LIKE axj_file.*,
       g_i        LIKE type_file.num5,             #count/index for any purpose     #No.FUN-680098 SMALLINT
       g_amt      LIKE axg_file.axg08,             #FUN-5A011                       #No.FUN-680098 DECIMAL(20,6)    
       g_axg04    LIKE axg_file.axg04,             #FUN-770068 add 09/12                       #No.FUN-680098 DECIMAL(20,6)    
       g_axk10_d  LIKE axk_file.axk10,             #FUN-750078 add
       g_axk10_c  LIKE axk_file.axk10,             #FUN-750078 add
       g_axf      RECORD LIKE axf_file.*,          #FUN-750078 add
       g_axt03    LIKE axt_file.axt03,             #FUN-750078 add
       g_axs03    LIKE axs_file.axs03,             #FUN-760053 add
       g_axu03    LIKE axu_file.axu03,             #FUN-760053 add
       g_affil    LIKE axj_file.axj05,             #FUN-760053 add
       g_dc       LIKE axj_file.axj06,             #FUN-760053 add
       g_flag_r   LIKE type_file.chr1,             #FUN-760053 add
       g_yy       LIKE type_file.num5,             #FUN-770069 add
       g_mm       LIKE type_file.num5,             #FUN-770069 add
       g_em       LIKE type_file.chr10             #FUN-770069 add
DEFINE g_aaz641        LIKE aaz_file.aaz641        #FUN-920067
DEFINE g_aaz113        LIKE aaz_file.aaz113        #FUN-A30079 
DEFINE g_dbs_axz03     LIKE type_file.chr21        #FUN-920067
DEFINE g_axz03         LIKE axz_file.axz03         #FUN-920067
DEFINE g_sql           STRING                      #FUN-920067
DEFINE g_aaz641_axb04  LIKE aaz_file.aaz641        #FUN-930117
DEFINE g_dbs_axb04     LIKE type_file.chr21        #FUN-930117
DEFINE g_newno         LIKE axi_file.axi01         #FUN-930144
DEFINE g_axa        DYNAMIC ARRAY OF RECORD        
                    axa01      LIKE axa_file.axa01,  #族群代號
                    axa02      LIKE axa_file.axa02,  #上層公司
                    axa03      LIKE axa_file.axa03   #帳別
                   #axa00      LIKE axa_file.axa03   #帳別         #MOD-A60056 mark
                    END RECORD 
DEFINE g_axk09_o    LIKE axk_file.axk09,             #期別
       g_axk09_o1   LIKE axk_file.axk09,             #期別  
       g_axk07_o    LIKE axk_file.axk07,             #異動碼值
       g_axk07_o1   LIKE axk_file.axk07             #異動碼值 
DEFINE g_axg07_o    LIKE axg_file.axg07,             #期別
       g_axg07_o1   LIKE axg_file.axg07             #期別  
DEFINE g_axk07      LIKE axk_file.axk07      #FUN-960096
DEFINE g_axj07_total  LIKE axj_file.axj07    #FUN-970046
DEFINE g_date_e     LIKE type_file.dat       #FUN-970046
DEFINE g_cnt_axf09  LIKE type_file.num5      #FUN-A30079
DEFINE g_cnt_axf10  LIKE type_file.num5      #FUN-A30079
DEFINE g_dbs_axf09  LIKE azp_file.azp03      #FUN-A30079 
DEFINE g_dbs_axf10  LIKE azp_file.azp03      #FUN-A30079 
DEFINE g_aaz641_axf09 LIKE aaz_file.aaz641   #FUN-A30079
DEFINE g_aaz641_axf10 LIKE aaz_file.aaz641   #FUN-A30079
DEFINE g_aaz114       LIKE aaz_file.aaz114   #FUN-A60038
#----FUN-A60038 start---
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                     END RECORD
DEFINE l_rate        LIKE axp_file.axp05             #功能幣別匯率    
DEFINE l_rate1       LIKE axp_file.axp05             #記帳幣別匯率   
#------FUN-A60038 end---
DEFINE g_axf09_axz05 LIKE axz_file.axz05   #FUN-A90006
DEFINE g_axf10_axz05 LIKE axz_file.axz05   #FUN-A90006
DEFINE g_axz08       LIKE axz_file.axz08   #FUN-A90006
DEFINE g_axz08_axf10 LIKE axz_file.axz08   #FUN-A90006
DEFINE g_low_axf09        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_axf09         LIKE type_file.num5    #FUN-A90006
DEFINE g_low_axf10        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_axf10         LIKE type_file.num5    #FUN-A90006
DEFINE g_axa02_axf09      LIKE axa_file.axa02    #FUN-A90006
DEFINE g_axa02_axf10      LIKE axa_file.axa02    #FUN-A90006
DEFINE g_axa09_axf09      LIKE axa_file.axa09    #FUN-A90006
DEFINE g_axa09_axf10      LIKE axa_file.axa09    #FUN-A90006
DEFINE g_axz06_axf09      LIKE axz_file.axz06    #FUN-A90006
DEFINE g_axz06_axf10      LIKE axz_file.axz06    #FUN-A90006
#---FUN-A90026 start-----------------------------------
DEFINE g_aej              RECORD 
                          aej04  LIKE aej_file.aej04,
                          aej05  LIKE aej_file.aej05,
                          aej07  LIKE aej_file.aej07,
                          aej08  LIKE aej_file.aej08,
                          aej09  LIKE aej_file.aej09,
                          aej10  LIKE aej_file.aej10,
                          aej11  LIKE aej_file.aej11
                         ,aej12  LIKE aej_file.aej12   #luttb 110803
                         ,aej18  LIKE aej_file.aej18   #NO.130717 add
                          END RECORD
DEFINE g_aek              RECORD 
                          aek04  LIKE aek_file.aek04,
                          aek05  LIKE aek_file.aek05,
                          aek06  LIKE aek_file.aek06,
                          aek08  LIKE aek_file.aek08,
                          aek09  LIKE aek_file.aek09,
                          aek10  LIKE aek_file.aek10,
                          aek11  LIKE aek_file.aek11
                         ,aek13  LIKE aek_file.aek13   #luttb 110803
                         ,aek19  LIKE aek_file.aek19   #NO.130717 add
                          END RECORD
DEFINE g_aem              RECORD 
                          aem04  LIKE aem_file.aem04,
                          aem05  LIKE aem_file.aem05,
                          aem06  LIKE aem_file.aem06,
                          aem07  LIKE aem_file.aem07,
                          aem08  LIKE aem_file.aem08,
                          aem09  LIKE aem_file.aem09,
                          aem11  LIKE aem_file.aem11,
                          aem12  LIKE aem_file.aem12,
                          aem13  LIKE aem_file.aem13,
                          aem14  LIKE aem_file.aem14,
                          aem15  LIKE aem_file.aem15
                          END RECORD
#---FUN-AA0005 start---
DEFINE g_axj1             RECORD 
                          axj06  LIKE axj_file.axj06,
                          axj07  LIKE axj_file.axj07
                          END RECORD
#---FUN-AA0005 end------
DEFINE g_axa06            LIKE axa_file.axa06    
DEFINE g_axa05            LIKE axa_file.axa05
DEFINE g_type             LIKE type_file.chr1  
DEFINE g_flag             LIKE type_file.chr1
#----FUN-A90026 end---------------------------------------
#FUN-B80135--add--str--
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add--end

MAIN

   OPTIONS
      FORM LINE     FIRST + 2,
      MESSAGE LINE  LAST,
      PROMPT LINE   LAST,
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz641 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   #--FUN-A90026 start----
   LET tm.axa01 = ARG_VAL(1)
   LET tm.axa02 = ARG_VAL(2)
   LET tm.axa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.axa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
  #luttb--mod--str--
  # LET tm.gl    = ARG_VAL(9)
  # LET tm.ver   = ARG_VAL(10)
  # LET tm.hisyy = ARG_VAL(11)
  # LET tm.hismm = ARG_VAL(12)
  # LET g_bgjob  = ARG_VAL(13)
  ##--FUN-A90026 end---
   LET tm.ver   = ARG_VAL(9)
   LET tm.hisyy = ARG_VAL(10)
   LET tm.hismm = ARG_VAL(11)
   LET g_bgjob  = ARG_VAL(12)
  #luttb--mod--end
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file
    WHERE aaa01 = g_aaz.aaz641 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add—end--

  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp001_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p001()
           CALL s_showmsg()                       #NO.FUN-710023   
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp001_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07      #MOD-660034
          FROM aaa_file 
        #WHERE aaa01 = g_bookno         #FUN-B80135
         WHERE aaa01 = g_aaz.aaz641     #FUN-B80135
        SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
       
        LET g_success = 'Y'
        BEGIN WORK
        CALL p001()
        CALL s_showmsg()                       #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp001_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_cnt          LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_axa03        LIKE axa_file.axa03           #FUN-580063
   DEFINE  lc_cmd         LIKE type_file.chr1000        #No.FUN-570145       #No.FUN-680098 VARCHAR(500)    
   DEFINE  l_axa09        LIKE axa_file.axa09           #FUN-A30079 
   DEFINE  l_aznn01       LIKE aznn_file.aznn01         #FUN-A90026 
     
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)     

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp001_w AT p_row,p_col WITH FORM "cgl/42f/cglp001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)   
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    #MOD-660034
        FROM aaa_file 
#      WHERE aaa01 = g_bookno   #FUN-B80135
       WHERE aaa01 = g_aaz.aaz641  #FUN-B80135
      SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034

      LET tm.yy = g_aaa04
      LET tm.bm = 0                #FUN-950048
      DISPLAY tm.bm TO FORMONLY.bm #FUN-950048
      LET tm.em = g_aaa05
      LET tm.ver = '00'        #FUN-760044 add
      LET tm.hisyy = g_aaa04   #FUN-760044 add
      LET tm.hismm = g_aaa05   #FUN-760044 add
      LET g_bgjob = 'N'        #No:FUN-570145  

      #--FUN-A90026 start--
      #INPUT BY NAME tm.yy,tm.em,tm.axa01,tm.axa02,tm.gl,g_bgjob  #NO.FUN-570145   #FUN-920067 del tm.axa03 #FUN-950048 mod
      #             ,tm.ver,tm.hisyy,tm.hismm   #FUN-750078 add
      #INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,tm.gl,g_bgjob,    #luttb 
      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,g_bgjob,    #luttb 
                    tm.ver,tm.hisyy,tm.hismm  
      #--FUN-A90026 end---
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE    #NO.FUN-570145 
            EXIT INPUT                  #NO.FUN-570145 

         #No.FUN-B80135--add--str--
        AFTER FIELD yy 
            IF NOT cl_null(tm.yy) THEN
              IF tm.yy < 0 THEN
                  CALL cl_err(tm.yy,'apj-035',0)
                  NEXT FIELD yy
               END IF
               IF tm.yy<g_year  THEN
                  CALL cl_err(tm.yy,'axm-164',0)
                  NEXT FIELD yy
               END IF 
                 IF tm.yy=g_year AND tm.em<=g_month THEN
                     CALL cl_err(tm.em,'axm-164',0)
                     NEXT FIELD em
                  END IF  
           END IF
        #No.FUN-B80135--add—end--

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
               LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #FUN-980083
               #FUN-B80135--add--str--
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = g_axq.axq06
                IF g_azm.azm02 = 1 THEN
                   IF tm.em > 12 OR tm.em< 1 THEN
                      CALL cl_err('','agl-020',0)
                      NEXT FIELD em
                   END IF
                ELSE
                   IF tm.em > 13 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                   END IF
                END IF

                IF NOT cl_null(tm.yy) AND tm.yy=g_year
                   AND tm.em<=g_month THEN
                   CALL cl_err(tm.em,'axm-164',0)
                   NEXT FIELD em
                END IF
                #FUN-B80135--add--end-- 
           END IF

         #--FUN-A90026 start-
         AFTER FIELD q1    #季
         IF cl_null(tm.q1) AND  g_axa06 = '2' THEN 
            NEXT FIELD q1 
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
         #--FUN-A90026 end
           
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 #no.6155
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  #No.FUN-660123
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02  #公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
               END IF
               SELECT DISTINCT axa03 INTO l_axa03 FROM axa_file
                WHERE axa01=tm.axa01   #FUN-580063
                  AND axa02=tm.axa02   #FUN-580063
               LET tm.axa03 = l_axa03     #FUN-580063
               DISPLAY l_axa03 TO axa03   #FUN-580063
#---FUN-A30122 mark------
#               SELECT axz03 INTO g_axz03 FROM axz_file
#                WHERE axz01 = tm.axa02
#               #--FUN-A30079 start---
#               SELECT azp03 INTO g_dbs_axz03 
#                 FROM azp_file 
#                WHERE azp01 = g_axz03
#               SELECT axa09 INTO l_axa09 
#                 FROM axa_file
#                WHERE axa01 = tm.axa01
#                  AND axa02 = tm.axa02
#               IF l_axa09 = 'Y' THEN
#                   LET g_dbs_axz03 = s_dbstring(g_dbs_axz03)
#               ELSE
#                   LET g_dbs_axz03 = s_dbstring(g_dbs)
#               END IF
#               #LET g_plant_new = g_axz03      #營運中心
#               #CALL s_getdbs()
#               #IF cl_null(g_dbs_new) THEN            #FUN-930117
#               #    LET g_dbs_new=g_dbs CLIPPED,'.'   #FUN-930117
#               #END IF                                #FUN-930117
#               #LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#               #--FUN-A30079 end---
#-----FUN-A30122 mark----------------------------------

               #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
               #LET g_sql = "SELECT aaz113,aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A30079
               #LET g_sql = "SELECT aaz113 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A30079  #MOD-A50056
               LET g_sql = "SELECT aaz113,aaz114 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A60038
                           " WHERE aaz00 = '0'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
               PREPARE p001_pre_01 FROM g_sql
               DECLARE p001_cur_01 CURSOR FOR p001_pre_01
               OPEN p001_cur_01
               #FETCH p001_cur_01 INTO g_aaz641   #合併帳別
               #FETCH p001_cur_01 INTO g_aaz113,g_aaz641   #合併帳別  #FUN-A30079
               #FETCH p001_cur_01 INTO g_aaz113             #MOD-A50056
               FETCH p001_cur_01 INTO g_aaz113,g_aaz114     #FUN-A60038
               CLOSE p001_cur_01
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03  #FUN-A30122 add
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641           #FUN-A30122 add
            END IF
            DISPLAY l_axa03 TO axa03   #FUN-580063

            #--FUN-A90026 start---
            LET g_axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,g_axa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'   #最上層公司否
            LET tm.axa06 = g_axa06
            DISPLAY BY NAME tm.axa06
            CALL p001_set_entry()    
            CALL p001_set_no_entry()

            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1
         #---FUN-A90026 end----
            #---FUN-A90026 end---

       #luttb--mark--str--
       #  AFTER FIELD gl
       #     IF NOT cl_null(tm.gl) THEN
       #        SELECT *  FROM aac_file        #讀取單據性質資料
       #         WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
       #        IF SQLCA.sqlcode THEN          #抱歉,讀不到
       #           CALL cl_err3("sel","aac_file",tm.gl,"","agl-035","","",0)  #No.FUN-660123
       #           NEXT FIELD gl
       #        END IF
       #     END IF
       #     #--FUN-A90026 start--
       #     IF NOT cl_null(tm.axa06) THEN
       #         CASE
       #             WHEN tm.axa06 = '1'  #月 
       #                  LET tm.bm = 0
       #             WHEN tm.axa06 = '2'  #季 
       #                  SELECT MAX(aznn01) INTO l_aznn01
       #                    FROM aznn_file
       #                   WHERE aznn00 = tm.axa03
       #                     AND aznn02 = tm.yy
       #                     AND aznn03 = tm.q1
       #                  LET tm.em = MONTH(l_aznn01)
       #             WHEN tm.axa06 = '3'  #半年
       #                  IF tm.h1 = '1' THEN  #上半年
       #                      SELECT MAX(aznn01) INTO l_aznn01
       #                        FROM aznn_file
       #                       WHERE aznn00 = tm.axa03
       #                         AND aznn02 = tm.yy
       #                         AND aznn03 < 3
       #                  ELSE                 #下半年
       #                      SELECT MAX(aznn01) INTO l_aznn01
       #                        FROM aznn_file
       #                       WHERE aznn00 = tm.axa03
       #                         AND aznn02 = tm.yy
       #                         AND aznn03 >='3' #大於等於第三季
       #                  END IF
       #                  LET tm.em = MONTH(l_aznn01)
       #             WHEN tm.axa06 = '4'  #年
       #                  SELECT MAX(aznn01) INTO l_aznn01
       #                    FROM aznn_file
       #                   WHERE aznn00 = tm.axa03
       #                     AND aznn02 = tm.yy
       #                  LET tm.em = MONTH(l_aznn01)
       #         END CASE
       #     END IF
       #     #--FUN-A90026
       #luttb--mark--end

         AFTER FIELD ver      #版本 
            IF cl_null(tm.ver) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD ver 
            END IF

         AFTER FIELD hisyy    #歷史匯率年度 
            IF cl_null(tm.hisyy) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hisyy 
            END IF

         AFTER FIELD hismm    #歷史匯率期別 
            IF cl_null(tm.hismm) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hismm
            END IF

        #ON ACTION CONTROLZ   #yangtt 130819
         ON ACTION CONTROLR   #yangtt 130819
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
              #luttb--mark--str--
              # WHEN INFIELD(gl) #單據性質
              #    CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','AGL')  #TQC-670078 
              #         RETURNING tm.gl         
              #    DISPLAY  BY NAME tm.gl  
              #    NEXT FIELD gl     
              #luttb--mark--end
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()
             CALL p001_set_entry()      #FUN-A90026
             CALL p001_set_no_entry()   #FUN-A90026 

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'aglp001'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp001','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       #--FUN-A90026 start--
                       " ''",
                       " '",tm.axa01,"'", 
                       " '",tm.axa02,"'", 
                       " '",tm.axa03,"'", 
                       " '",tm.yy,"'",    
                       " '",tm.axa06,"'", 
                       " '",tm.em,"'",    
                       " '",tm.q1,"'",    
                       " '",tm.h1,"'",    
                       #" '",tm.gl,"'",   #luttb 
                       #---FUN-A90026 end----
                       #---FUN-A90026 mark--
                       #" ''",
                       #" '",tm.yy CLIPPED,"'",
                       #" '",tm.bm CLIPPED,"'",
                       #" '",tm.em CLIPPED,"'",
                       #" '",tm.axa01 CLIPPED,"'",
                       #" '",tm.axa02 CLIPPED,"'",
                       #" '",tm.axa03 CLIPPED,"'",
                       #--FUN-A90026 mark-------
                       #" '",tm.gl CLIPPED,"'",      #luttb
                       " '",tm.ver CLIPPED,"'",      #FUN-750078 add
                       " '",tm.hisyy CLIPPED,"'",    #FUN-750078 add
                       " '",tm.hismm CLIPPED,"'",    #FUN-750078 add
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aglp001',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW aglp001_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p001()
#DEFINE l_sql        LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(1000)
DEFINE l_sql        STRING,                   #FUN-A60038
       l_sql_axr    LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(1000)
       i,g_no       LIKE type_file.num5,      #No.FUN-680098 SMALLINT  
       l_aah         RECORD 
                     aah01      LIKE aah_file.aah01,  #科目編號
                     aah02      LIKE aah_file.aah02,  #會計年度
                     aah03      LIKE aah_file.aah03,  #期別
                     aah04      LIKE aah_file.aah04,  #借方金額
                     aah05      LIKE aah_file.aah05,  #貸方金額
                     aah06      LIKE aah_file.aah06,  #借方筆數
                     aah07      LIKE aah_file.aah07   #貸方筆數
                     END RECORD,
       l_aed         RECORD
                     aed01      LIKE aed_file.aed01,  #科目年度
                     aed011     LIKE aed_file.aed011, #異動碼順序
                     aed02      LIKE aed_file.aed02,  #異動碼值
                     aed03      LIKE aed_file.aed03,  #會計年度
                     aed04      LIKE aed_file.aed04,  #期別
                     aed05      LIKE aed_file.aed05,  #借方總金額
                     aed06      LIKE aed_file.aed06,  #貸方總金額
                     aed07      LIKE aed_file.aed07,  #借方總筆數
                     aed08      LIKE aed_file.aed08   #貸方總筆數
                     END RECORD,
#       l_aedd        RECORD LIKE aedd_file.*,        #FUN-A90026 mark
       #l_aeh         RECORD LIKE aeh_file.*,          #FUN-A90026
       l_aei16       LIKE aei_file.aei16,
       l_aei17       LIKE aei_file.aei17,
       l_chg_aeii11_1 LIKE axr_file.axr13,
       l_chg_aeii12_1 LIKE axr_file.axr13,
       l_chg_aeii11   LIKE axr_file.axr13,
       l_chg_aeii12   LIKE axr_file.axr13,
       l_chg_aeii11_a LIKE axr_file.axr13,
       l_chg_aeii12_a LIKE axr_file.axr13,
       l_aeii        RECORD LIKE aeii_file.*,
       l_chg_aedd05   LIKE aed_file.aed05,             #功能幣別借方總金額
       l_chg_aedd06   LIKE aed_file.aed06,             #功能幣別貸方總金額
       l_chg_aedd05_1 LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aedd06_1 LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aedd05_a LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aedd06_a LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_axq1        RECORD                                       #FUN-580063
                     axq05      LIKE axq_file.axq05,  #科目年度
                     axq06      LIKE axq_file.axq06,  #會計年度
                     axq07      LIKE axq_file.axq07,  #期別
                     axq08      LIKE axq_file.axq08,  #借方金額
                     axq09      LIKE axq_file.axq09,  #貸方金額
                     axq10      LIKE axq_file.axq10,  #借方筆數
                     axq11      LIKE axq_file.axq11,  #貸方筆數
                     axq13      LIKE axq_file.axq13   #關係人代號 
                     END RECORD,
       l_axq         RECORD          
                     axq00      LIKE axq_file.axq00,
                     axq01      LIKE axq_file.axq01,
                     axq02      LIKE axq_file.axq02,
                     axq03      LIKE axq_file.axq03,
                     axq04      LIKE axq_file.axq04,
                     axq041     LIKE axq_file.axq041,
                     axq05      LIKE axq_file.axq05,
                     axq06      LIKE axq_file.axq06,
                     axq07      LIKE axq_file.axq07,
                     axq08      LIKE axq_file.axq08,
                     axq09      LIKE axq_file.axq09,
                     axq10      LIKE axq_file.axq10,
                     axq11      LIKE axq_file.axq11,
                     axq12      LIKE axq_file.axq12,
                     axq13      LIKE axq_file.axq13
                     END RECORD,
#----FUN-A60038 mark----移到global變數---
#       g_dept        DYNAMIC ARRAY OF RECORD        
#                     axa01      LIKE axa_file.axa01,  #族群代號
#                     axa02      LIKE axa_file.axa02,  #上層公司
#                     axa03      LIKE axa_file.axa03,  #帳別
#                     axb04      LIKE axb_file.axb04,  #下層公司
#                     axb05      LIKE axb_file.axb05   #帳別  
#                     END RECORD,
#---FUN-A60038 mark----------------------
       l_axe         RECORD                                       #FUN-580063
                     #axe06      LIKE axe_file.axe06,  #合併後財報會計科目編號  #FUN-A90026 mark
                     axe04      LIKE axe_file.axe04,  #TQC-AA0098
                     axe11      LIKE axe_file.axe11,  #再衡量匯率類別
                     axe12      LIKE axe_file.axe12   #換算匯率類別
                     END RECORD,
       l_axee        RECORD  
       #             axee06     LIKE axee_file.axee06,  #合併後財報會計科目編號   #FUN-A90026 mark
                     axee04     LIKE axee_file.axee04,  #TQC-AA0098
                     axee11     LIKE axee_file.axee11,  #再衡量匯率類別
                     axee12     LIKE axee_file.axee12   #換算匯率類別
                     END RECORD,
       l_axh         RECORD LIKE axh_file.*,
       l_axkk        RECORD LIKE axkk_file.*,         #FUN-910023 add 
       l_axe06       LIKE axe_file.axe06,             #合併後財報會計科目編號
       l_axee06      LIKE axee_file.axee06,           #合併後財報會計科目編號   #FUN-920067
       l_aaa03       LIKE aaa_file.aaa03,             #原工廠本國幣別
       l_chg_aed05   LIKE aed_file.aed05,             #功能幣別借方總金額
       l_chg_aed06   LIKE aed_file.aed06,             #功能幣別貸方總金額
       l_chg_aed05_1 LIKE aed_file.aed05,             #記帳幣別借方總金額 #FUN-580063
       l_chg_aed06_1 LIKE aed_file.aed06,             #記帳幣別貸方總金額 #FUN-580063
       l_chg_aed05_a LIKE aed_file.aed05,             #記帳幣別借方總金額 #FUN-580063
       l_chg_aed06_a LIKE aed_file.aed06,             #記帳幣別貸方總金額 #FUN-580063
       l_chg_aah04   LIKE aah_file.aah04,             #功能幣別借方金額
       l_chg_aah05   LIKE aah_file.aah05,             #功能幣別貸方金額
       l_chg_aah04_1 LIKE aah_file.aah04,             #記帳幣別借方金額   #FUN-580063
       l_chg_aah05_1 LIKE aah_file.aah05,             #記帳幣別貸方金額   #FUN-580063
       l_chg_aah04_a LIKE aah_file.aah04,             #記帳幣別借方金額   #FUN-580063
       l_chg_aah05_a LIKE aah_file.aah05,             #記帳幣別貸方金額   #FUN-580063
       l_chg_axq08   LIKE axq_file.axq08,             #功能幣別借方金額   #FUN-580063
       l_chg_axq09   LIKE axq_file.axq09,             #功能幣別貸方金額   #FUN-580063
       l_chg_axq08_1 LIKE axq_file.axq08,             #記帳幣別借方金額   #FUN-580063
       l_chg_axq09_1 LIKE axq_file.axq09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_axq08_a LIKE axq_file.axq08,             #記帳幣別借方金額   #FUN-580063
       l_chg_axq09_a LIKE axq_file.axq09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_axh08   LIKE axh_file.axh08,             #功能幣別借方金額   #FUN-580063
       l_chg_axh09   LIKE axh_file.axh09,             #功能幣別貸方金額   #FUN-580063
       l_chg_axh08_1 LIKE axh_file.axh08,             #記帳幣別借方金額   #FUN-580063
       l_chg_axh09_1 LIKE axh_file.axh09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_axh08_a LIKE axh_file.axh08,             #記帳幣別借方金額   #FUN-580063
       l_chg_axh09_a LIKE axh_file.axh09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_axkk10   LIKE axkk_file.axkk10,          #功能幣別借方金額   #FUN-910023 add                                           
       l_chg_axkk11   LIKE axkk_file.axkk11,          #功能幣別貸方金額   #FUN-910023 add                                           
       l_chg_axkk10_1 LIKE axkk_file.axkk10,          #記帳幣別借方金額   #FUN-910023 add                                           
       l_chg_axkk11_1 LIKE axkk_file.axkk11,          #記帳幣別貸方金額   #FUN-910023 add                                           
       l_chg_axkk10_a LIKE axkk_file.axkk10,          #記帳幣別借方金額   #FUN-910023 add                                           
       l_chg_axkk11_a LIKE axkk_file.axkk11,          #記帳幣別貸方金額   #FUN-910023 add
       l_n           LIKE type_file.num5,             #No.FUN-680098 SMALLINT
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)                  #No.FUN-680098  SMALLINT
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別) #FUN-5A0020      #No.FUN-680098  SMALLINT
       #l_rate        LIKE axp_file.axp05,             #功能幣別匯率       #No:FUN-4B0072   #No.FUN-680098  DECIMAL(20,6)  #FUN-A60038 mark
       #l_rate1       LIKE axp_file.axp05,             #記帳幣別匯率       #FUN-580063      #No.FUN-680098  DECIMAL(20,6)  #FUN-A60038 mark
       l_axz04       LIKE axz_file.axz04,             #使用TIPTOP否
       l_axz06       LIKE axz_file.axz06,             #上層公司記帳幣別   #FUN-580063
       l_axz         RECORD LIKE axz_file.*,                              #FUN-580063
       l_axp08       LIKE axp_file.axp08,                                 #FUN-580063
       l_axp09       LIKE axp_file.axp09,                                 #FUN-580063
       l_axz03       LIKE axz_file.axz03,             #TQC-660043
       l_axr05       LIKE axr_file.axr05,             #FUN-760053 add
       l_axr08       LIKE axr_file.axr08,             #FUN-770069 add
       l_axr09       LIKE axr_file.axr09,             #FUN-770069 add
       l_aag06       LIKE aag_file.aag06              #FUN-760053 add
DEFINE l_aag04       LIKE aag_file.aag04              #FUN-760053 add
DEFINE l_bs_yy       LIKE type_file.num5              #FUN-760053 add
DEFINE l_bs_mm       LIKE type_file.num5              #FUN-760053 add
DEFINE l_aaz641      LIKE aaz_file.aaz641             #FUN-920067
DEFINE l_axr_count   LIKE type_file.num5              #FUN-920167
DEFINE l_axr13       LIKE axr_file.axr13              #FUN-930018 add
DEFINE l_axg18       LIKE axg_file.axg18              #FUN-960003
DEFINE l_axg19       LIKE axg_file.axg19              #FUN-960003
DEFINE l_axk16       LIKE axk_file.axk16              #FUN-960003
DEFINE l_axk17       LIKE axk_file.axk17              #FUN-960003
DEFINE l_axq05       STRING                           #FUN-960096
DEFINE l_axe04       LIKE axr_file.axr07              #FUN-970046
DEFINE l_axe04_cnt   LIKE type_file.num5              #FUN-970046 
DEFINE l_axa09       LIKE axa_file.axa09              #FUN-970046
DEFINE l_aah04       LIKE aah_file.aah04              #MOD-980063
DEFINE l_chg_dr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_chg_cr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_axi081      LIKE axi_file.axi081     
DEFINE l_fun_dr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_fun_cr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_acc_dr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_acc_cr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_aah04_1     LIKE aah_file.aah04              #FUN-A60038
DEFINE l_aah05_1     LIKE aah_file.aah05              #FUN-A60038
DEFINE l_aed05       LIKE aed_file.aed05              #FUN-A60038
DEFINE l_aed06       LIKE aed_file.aed06              #FUN-A60038
DEFINE l_axq08       LIKE axq_file.axq08              #FUN-A60038
DEFINE l_axq09       LIKE axq_file.axq09              #FUN-A60038
#DEFINE l_aedd05      LIKE aedd_file.aedd05            #FUN-A60038
#DEFINE l_aedd06      LIKE aedd_file.aedd06            #FUN-A60038
DEFINE l_dr          LIKE aah_file.aah04              #FUN-A70053
DEFINE l_cr          LIKE aah_file.aah05              #FUN-A70053
DEFINE l_axh08       LIKE axh_file.axh08              #FUN-A70065
DEFINE l_axh08_1     LIKE axh_file.axh08              #FUN-A70065
DEFINE l_axh08_2     LIKE axh_file.axh08              #FUN-A70065
DEFINE l_axh09       LIKE axh_file.axh09              #FUN-A70065
DEFINE l_axh09_1     LIKE axh_file.axh09              #FUN-A70065
DEFINE l_axh09_2     LIKE axh_file.axh09              #FUN-A70065
DEFINE l_axkk10      LIKE axkk_file.axkk10            #FUN-A70065
DEFINE l_axkk10_1    LIKE axkk_file.axkk10            #FUN-A70065
DEFINE l_axkk10_2    LIKE axkk_file.axkk10            #FUN-A70065
DEFINE l_axkk11      LIKE axkk_file.axkk11            #FUN-A70065
DEFINE l_axkk11_1    LIKE axkk_file.axkk11            #FUN-A70065
DEFINE l_axkk11_2    LIKE axkk_file.axkk11            #FUN-A70065
DEFINE l_aeii11      LIKE aeii_file.aeii11            #FUN-A70065
DEFINE l_aeii12      LIKE aeii_file.aeii12            #FUN-A70065
DEFINE l_aeii11_1    LIKE aeii_file.aeii11            #FUN-A70065
DEFINE l_aeii11_2    LIKE aeii_file.aeii11            #FUN-A70065
DEFINE l_aeii12_1    LIKE aeii_file.aeii12            #FUN-A70065
DEFINE l_aeii12_2    LIKE aeii_file.aeii12            #FUN-A70065
DEFINE l_mm          LIKE type_file.chr4              #FUN-A90006
DEFINE l_axq_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aah_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aed_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aed01       LIKE aed_file.aed01              #FUN-A90006
DEFINE l_aah01       LIKE aah_file.aah01              #FUN-A90006
DEFINE l_aah02       LIKE aah_file.aah02              #FUN-A90006
DEFINE l_aah03       LIKE aah_file.aah03              #FUN-A90006
DEFINE l_aed02       LIKE aed_file.aed02              #FUN-A90006
DEFINE l_axk         RECORD LIKE axk_file.*           #FUN-A90006
DEFINE l_axg         RECORD LIKE axg_file.*           #FUN-A90006
DEFINE l_chg_aem11_1 LIKE aem_file.aem11              #FUN-A90026
DEFINE l_chg_aem12_1 LIKE aem_file.aem12              #FUN-A90026 
DEFINE l_chg_aem11   LIKE aem_file.aem11              #FUN-A90026
DEFINE l_chg_aem12   LIKE aem_file.aem12              #FUN-A90026
DEFINE l_chg_aem11_a LIKE aem_file.aem11              #FUN-A90026
DEFINE l_chg_aem12_a LIKE aem_file.aem12              #FUN-A90026 
DEFINE l_num         LIKE type_file.num5              #FUN-AA0005

    #-->step 1 刪除資料
    CALL p001_del()
    IF g_success = 'N' THEN RETURN END IF

    #-->step 2 資料匯入,更換科目
    #-->aah_file->axg_file;aed_file->axk_file;ref.axe_file
    #-->axq_file->axg_file;axq_file->axk_file                #FUN-580063
    LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR

    LET l_sql=" SELECT UNIQUE axa01,axa02,axa03,axa02,axa03",
              "   FROM axa_file ",
              "  WHERE axa01='",tm.axa01,"' ",
             #"    AND axa02='",tm.axa02,"' ",
             #"    AND axa03='",tm.axa03,"' ",
              "    AND axa04 = 'Y' ",#Add by sam 20101203
              "  UNION ",
              " SELECT UNIQUE axa01,axa02,axa03,axb04,axb05",
              "   FROM axb_file,axa_file ",
              "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
              "    AND axa01='",tm.axa01,"' ",
             #"    AND axa02='",tm.axa02,"' ",
             #"    AND axa03='",tm.axa03,"' ",
             # "    AND axb07 > 20 ", #Add by sam 20101204   #luttb 110307
              "    AND axb06 = 'Y'",  #luttb 110307
             #"    AND axa04 = 'Y' ",#Add by sam 20101203
              "  ORDER BY 1,2,3,4 "
    PREPARE p001_axa_p FROM l_sql
    IF STATUS THEN 
      CALL cl_err('prepare:1',STATUS,1)             
       CALL cl_batch_bg_javamail('N')      #FUN-57014
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
    DECLARE p001_axa_c CURSOR FOR p001_axa_p
    LET g_no = 1
    CALL s_showmsg_init()           #NO.FUN-710023 
    FOREACH p001_axa_c INTO g_dept[g_no].*
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF 
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg(' ',' ','for_axa_c:',STATUS,1) #NO.FUN-710023
          LET g_success = 'N'
          RETURN                                     
       END IF
       LET g_no=g_no+1
    END FOREACH
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
    LET g_no=g_no-1

    LET l_sql_axr=
        #"SELECT '2',SUM(axr13)",          #FUN-990020 mod
        "SELECT '2',SUM(axr16),SUM(axr13)",    #FUN-A70086
        "  FROM axr_file,axz_file",
        " WHERE axr01=? AND axr02=? ",
        "   AND axr02=axz01 ",
        "   AND axr04=axz06 ",
        #"   AND axr07=? ",               #FUN-A90026 mark             
        "   AND axr03=? ",
        "   AND axr06<=? "  #異動日期
    PREPARE p001_axr_p FROM l_sql_axr
    
    LET l_sql_axr=
        "SELECT COUNT(*) ",       
        "  FROM axr_file,axz_file",
        " WHERE axr01=? AND axr02=? ",
        "   AND axr02=axz01 ",
        "   AND axr04=axz06 ",
        #"   AND axr07=? ",    #FUN-A90026 mark                         
        "   AND axr03=? ",
        "   AND axr06<=? "
    PREPARE p001_axr_p2 FROM l_sql_axr

    FOR i =1 TO g_no   #insert axg_file
        IF g_success='N' THEN                                                    
          LET g_totsuccess='N'                                                   
          LET g_success='Y'                                                      
        END IF
        SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01=g_dept[i].axb04   #TQC-660043
        SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_axz03   #TQC-660043
        IF STATUS THEN LET g_dbs_new = NULL END IF
        IF NOT cl_null(g_dbs_new) THEN 
           LET g_dbs_new=g_dbs_new CLIPPED,'.' 
        END IF
        LET g_dbs_gl = g_dbs_new CLIPPED

        #母公司的記帳幣別
        SELECT axz06 INTO l_axz06 FROM axz_file WHERE axz01=g_dept[i].axa02

        LET l_rate = 1 
        LET l_cut  = 0
        LET l_cut1 = 0   #FUN-5A0020

        DISPLAY 'cur db-->',g_dept[i].axb04

        #-->產生axg_file(合併前會計科目餘額檔)
        #-->check 是否有下層資料,無下層(aej_file,aek_file,aem_file),有下層(axh_file,axkk_file)
        #抓取歷史匯率檔時機：
        #判斷現在計算的這個公司有沒有下層公司，
        #若有，則抓合併後餘額檔﹔若沒有，則抓歷史匯率檔
        #Mark by sam 20101204
        # SELECT COUNT(*) INTO l_n FROM axa_file 
        #  WHERE axa01=g_dept[i].axa01 
        #    AND axa02=g_dept[i].axb04 
        #    AND axa03=g_dept[i].axb05 
        # IF l_n=0 OR 
        # (g_dept[i].axa02=g_dept[i].axb04 AND g_dept[i].axa03=g_dept[i].axb05)   #FUN-A90026 mod
        # THEN #無下層資料
        #End Mark
            SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept[i].axb04
                #--------FUN-A90026 aah->aej ---start---
                #取aej_file SUM(借),SUM(貸)之科餘(BETWEEN tm.bm and tm.em)寫入合併科餘
                #寫入期別= tm.em
                LET l_sql=
                #" SELECT aej04,aej05,SUM(aej07),SUM(aej08),SUM(aej09),SUM(aej10),aej11,aej12",  #luttb 110803 add aej12  #NO.130717 mark
                " SELECT aej04,aej05,SUM(aej07),SUM(aej08),SUM(aej09),SUM(aej10),aej11,aej18",  #luttb 110803 add aej12  #NO.130717 modify
                "   FROM aej_file ",
                "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                "    AND aej01 = '",g_dept[i].axa01,"'", #族群
                "    AND aej02 = '",g_dept[i].axb04,"'", #公司
                "    AND aej05 = '",tm.yy,"'",
                "    AND aej06 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                #"  GROUP BY aej04,aej05,aej11 ",   #luttb 110803
                #"  GROUP BY aej04,aej05,aej11,aej12 ",   #luttb 110803  #NO.130717 mark
                "  GROUP BY aej04,aej05,aej11,aej18 ",   #luttb 110803   #NO.130717 modify
                "  ORDER BY aej04 "
                #--------FUN-A90026 end-----------------

                PREPARE p001_aah_p5 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                    CALL s_errmsg('aah02,aah00',g_showmsg,'prepare:2',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                DECLARE p001_aah_c5 CURSOR FOR p001_aah_p5
                #FOREACH p001_aah_c5 INTO l_aah01                  #FUN-A90026 mark
                FOREACH p001_aah_c5 INTO g_aej.aej04,g_aej.aej05,  #FUN-A90026 add
                                         g_aej.aej07,g_aej.aej08,g_aej.aej09,  #FUN-A90026 add
                                         #g_aej.aej10,g_aej.aej11           #FUN-A90026 add  #luttb 110803
                                         g_aej.aej10,g_aej.aej11,
                                         #g_aej.aej12    #NO.130717 mark
                                         g_aej.aej18   #NO.130717 modify
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_aah_c5',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                       
                    #--FUN-A90026 start---
                    LET l_aah.aah01 = g_aej.aej04
                    LET l_aah.aah02 = g_aej.aej05
                    LET l_aah.aah03 = tm.em
                    LET l_aah.aah04 = g_aej.aej07
                    LET l_aah.aah05 = g_aej.aej08
                    LET l_aah.aah06 = g_aej.aej09
                    LET l_aah.aah07 = g_aej.aej10
                    #--FUN-A90026 end-----

                    DISPLAY l_aah.aah03,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05
#                   LET l_axe.axe06 = l_aah.aah01   #FUN-A90026 mark
                    LET l_axe.axe11 = '1'
                    LET l_axe.axe12 = '1'
                    #抓取下層公司的科目的合併財報科目編號(axe06),
                    #再衡量匯率類別(axe11),換算匯率類別(axe12),
                    #以判斷後續轉換幣別時,要用那種匯率計算

                    #---FUN-A90026 start----
                    LET l_sql = 
                    #" SELECT axe11,axe12 FROM axe_file ",
                    " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
                    "  WHERE axe01 = '",g_dept[i].axb04,"'",
                    "    AND axe06 = '",l_aah.aah01,"'",
                    "    AND axe00 = '",g_dept[i].axb05,"'", 
                    "    AND axe13 = '",tm.axa01,"'"   
                    PREPARE p001_axe_p1 FROM l_sql
                    DECLARE p001_axe_c1 SCROLL CURSOR FOR p001_axe_p1
                    OPEN p001_axe_c1 
                    FETCH FIRST p001_axe_c1 INTO l_axe.*
                    CLOSE p001_axe_c1
                    #---FUN-A90026 end--------

                    IF STATUS  THEN                      #FUN-580063
                       LET g_showmsg=g_dept[i].axb04,"/",l_aah.aah01                                                #NO.FUN-710023 
                       CALL s_errmsg('axe01,axe04',g_showmsg,l_aah.aah01,'aap-021',1)                               #NO.FUN-710023     
                       LET g_success = 'N' 
                        CONTINUE FOREACH                       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                    END IF
#                   LET l_axe06 = l_axe.axe06            #FUN-580063   #FUN-A90026 mark

                    #DISPLAY l_aah.aah03,'->',l_axe06,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05
                    DISPLAY l_aah.aah03,'->',l_aah.aah01,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05  　　　　 #FUN-A90026 mod

                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
                    #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
                    #  乘上匯率逐一算出借貸方計帳金額(axg08,axg09 OR axk10,axk11)
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg('axz01',g_dept[i].axb04,' ',SQLCA.sqlcode,1)   #NO.FUN-710023
                       LET g_success = 'N'
                       CONTINUE  FOREACH                            #NO.FUN-710023    #TQC-770178 mod EXIT->CONTINUE
                    END IF

                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                    #一一換算後再加總起來
                    
                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-A60038 mark
                    LET l_chg_aah04_1=0
                    LET l_chg_aah05_1=0
                    LET l_chg_aah04=0
                    LET l_chg_aah05=0
                    LET l_chg_aah04_a=0
                    LET l_chg_aah05_a=0

                    #---FUN-A60038 start---
                    LET l_chg_dr = 0 
                    LET l_chg_cr = 0
                    LET l_fun_dr = 0 
                    LET l_fun_cr = 0 
                    LET l_acc_dr = 0 
                    LET l_acc_cr = 0
                    #---FUN-A60038 end-----
                    LET l_dr = 0  #MOD-A80102
                    LET l_cr = 0  #MOD-A80102

                    #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                    #--現時匯率---
                    IF l_axe.axe11='1' THEN 
                        CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,l_aah.aah02,l_aah.aah03)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs2 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs2
                        USING g_dept[i].axa01,g_dept[i].axb04,
                             #l_aah.aah01,l_axe.axe06,g_date_e  #FUN-970046
                             l_aah.aah01,g_date_e               #FUN-A90026 mod
                        FETCH p001_cnt_cs2 INTO l_axr_count
                        CLOSE p001_cnt_cs2
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,l_aah.aah01,l_axe.axe06,g_date_e)   #FUN-A60038 add
                            #CALL p001_axr(i,l_aah.aah01,g_date_e)    #FUN-A90026 mod
                            CALL p001_axr(i,l_axe.axe04,l_aah.aah01,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
                            #--FUN-A70086 start--
                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            #LET l_fun_dr = l_chg_dr
                            #LET l_fun_cr = l_chg_cr
                            #LET l_acc_dr = l_chg_dr
                            #LET l_acc_cr = l_chg_cr
                            #--FUN-A70086 end----
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,l_aah.aah02,l_aah.aah03)
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
                    ELSE
                        CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,l_aah.aah02,l_aah.aah03)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe11='3' THEN
#FUN-A90006 start---
                        #--FUN-A90026 start--
                        IF g_axa05 = '1' THEN      
                            #CALL p001_fun_avg(l_axe.axe11,l_aah.aah01,l_axz.axz06,l_axz.axz07,l_aah.aah02,l_aah.aah03,i)  #luttb 110913 
                            #CALL p001_fun_avg(l_axe.axe11,l_aah.aah01,l_axz.axz06,l_axz.axz07,l_aah.aah02,l_aah.aah03,i,g_aej.aej12)   #luttb 110913  #NO.130717 mark
                            CALL p001_fun_avg(l_axe.axe11,l_aah.aah01,l_axz.axz06,l_axz.axz07,l_aah.aah02,l_aah.aah03,i,g_aej.aej18)   #luttb 110913 #NO.130717 modify
                            RETURNING l_fun_dr,l_fun_cr 
                            #CALL p001_fun_avg('1',g_dbs_gl,l_axe.axe06,   #FUN-A90026 mark
                            #                  g_dept[i].axb05,l_aag04,    #FUN-A90026 mark
                            #                  l_axz.axz06,l_axz.axz07,i,  #FUN-A90026 mark
                            #                  l_aah.aah04,l_aah.aah05)    #FUN-A90026 mark
                            #RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr
                        ELSE                
                            CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                              l_axe.axe11,l_axz.axz06,
                                              l_axz.axz07,l_aah.aah02,l_aah.aah03)
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
                        #--FUN-A90026 end----
#FUN-A90006 end-----
                    END IF
                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_axe.axe12='1' THEN 
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,l_aah.aah02,l_aah.aah03)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs24 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs24
                        USING g_dept[i].axa01,g_dept[i].axb04,
                             #l_aah.aah01,l_axe.axe06,g_date_e  #FUN-970046
                             l_aah.aah01,g_date_e               #FUN-A90026 mod
                        FETCH p001_cnt_cs24 INTO l_axr_count
                        CLOSE p001_cnt_cs24
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,l_aed.aed01,l_axe.axe06,g_date_e) 
                            #CALL p001_axr(i,l_aah.aah01,g_date_e)     #FUN-A90026 mod
                            CALL p001_axr(i,l_axe.axe04,l_aah.aah01,g_date_e)     #FUN-A90026 mod  #TQC-AA0098
                            #--FUN-A70086 start--
                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            #LET l_fun_dr = l_chg_dr
                            #LET l_fun_cr = l_chg_cr
                            #LET l_acc_dr = l_chg_dr
                            #LET l_acc_cr = l_chg_cr
                            #--FUN-A70086 end----
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              x_aaa03,l_aah.aah02,l_aah.aah03)
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,l_aah.aah02,l_aah.aah03)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe12='3' THEN
#--FUN-A90006 start-
                        #---FUN-A90026 start
                        IF g_axa05 = '1' THEN 
                            CALL p001_avg(l_axe.axe11,l_axe.axe12,l_aah.aah01,
                                          l_axz.axz06,l_axz.axz07,
                                          #l_aah.aah02,l_aah.aah03,i,g_aej.aej12) #luttb add aej12 #NO.130717 mark
                                          l_aah.aah02,l_aah.aah03,i,g_aej.aej18) #luttb add aej12 #NO.130717 modify
                        #FUN-A90026 end--
                            #CALL p001_avg('2',g_dbs_gl,l_axe.axe06,   #FUN-A90026 mark
                            #               g_dept[i].axb05,l_aag04,   #FUN-A90026 mark
                            #               l_axz.axz06,l_axz.axz07,i, #FUN-A90026 mark
                            #               l_dr,l_cr)                 #FUN-A90026 mark
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #--FUN-A90026 start---
                        ELSE
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              x_aaa03,l_aah.aah02,l_aah.aah03)
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                        #--FUN-A90026 end-------
#FUN-A90006 end-----
                    END IF
                    #-------FUN-A60038 end-----------------------------------


                    #---FUN-A60038 start---
                    LET l_chg_aah04  =l_chg_aah04   + l_fun_dr
                    LET l_chg_aah05  =l_chg_aah05   + l_fun_cr
                    LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
                    LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額
                    #---FUN-A60038 end------

                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07                                                                               
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
                    LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
                    LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
                    LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
                    LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
                    IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
                    IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF                                                                                   
 
                    #--FUN-A90026 start--
                    IF g_axa05 = '1' THEN
                        IF l_axe.axe11 = '3' THEN   #TQC-AA0098
                            IF l_axz.axz06 != l_axz.axz07 THEN
                                LET l_axg18 = (l_chg_aah04-l_chg_aah05)/(l_aah.aah04-l_aah.aah05)
                            ELSE
                                LET l_axg18 = l_rate
                            END IF
                        ELSE                         #TQC-AA0098
                            LET l_axg18 = l_rate     #TQC-AA0098
                        END IF                       #TQC-AA0098

                        IF l_axe.axe12 = '3' THEN    #TQC-AA0098
                            IF l_axz.axz07 != x_aaa03 THEN
                                LET l_axg19 = (l_chg_aah04_1-l_chg_aah05_1)/(l_chg_aah04-l_chg_aah05)
                            ELSE
                                LET l_axg19 = l_rate1
                            END IF
                        ELSE                         #TQC-AA0098
                            LET l_axg19 = l_rate1    #TQC-AA0098
                        END IF                       #TQC-AA0098
                    ELSE
                    #---FUN-A90026 end-----
                        LET l_axg18 = l_rate    #FUN-960003 add
                        LET l_axg19 = l_rate1   #FUN-960003 add
                    END IF   #FUN-A90026 add

                    INSERT INTO axg_file                                                                                                                        
                      (axg00,axg01,axg02,axg03,axg04,axg041,   #No:MOD-470041                                                                                 
                       axg05,axg06,axg07,axg08,axg09,axg10,                                                                                                   
                       axg11,axg12,axg13,axg14,axg15,axg16,    #FUN-580063                                                                                    
                       axg17,                                  #FUN-750078 add                                                                                
                       #axg18,axg19)                            #FUN-970046      #luttb 110803
                       axg18,axg19,axg20,axglegal)   #luttb 110803  #NO.130717 add axglegal
                     VALUES                                                                                                                                     
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  #FUN-5A0020 #FUN-920067                                                                      
                       g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05,                                                                                        
                       l_aah.aah01,l_aah.aah02,l_aah.aah03,l_chg_aah04_1,   #FUN-A90026 mod
                       l_chg_aah05_1,l_aah.aah06,l_aah.aah07,l_axz06,                                                                                          
                       l_aah.aah04,l_aah.aah05,l_chg_aah04,l_chg_aah05,                                                                                        
                       tm.ver,                                                                                                            
                       #l_axg18,l_axg19,g_aej.aej12,g_legal)   #luttb 110803      #NO.130717 mark
                       l_axg18,l_axg19,g_aej.aej18,g_legal)   #luttb 110803  #NO.130717 modify
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                        UPDATE axg_file SET axg08=axg08+l_chg_aah04_1, #MOD-6A0066                                                                             
                                            axg09=axg09+l_chg_aah05_1, #MOD-6A0066                                                                             
                                            axg10=axg10+l_aah.aah06,   #MOD-6A0066                                                                             
                                            axg11=axg11+l_aah.aah07,   #MOD-6A0066                                                                             
                                            axg13=axg13+l_aah.aah04,   #FUN-770069 mod                                                                         
                                            axg14=axg14+l_aah.aah05,   #FUN-770069 mod                                                                         
                                            axg15=axg15+l_chg_aah04,   #MOD-6A0066                                                                             
                                            axg16=axg16+l_chg_aah05,    #MOD-6A0066                                                                            
                                            axg18=l_axg18,             #FUN-970046 ADD                                                                         
                                            axg19=l_axg19              #FUN-970046 ADD                                                                         
                         WHERE axg00 = g_aaz641    #FUN-970046 add                                                                                                 
                           AND axg01 = g_dept[i].axa01                                                                                                         
                          AND axg02 = g_dept[i].axa02                                                                                                         
                          # AND axg02 = tm.axa02  #FUN-A30064                                                                                                         
                           AND axg03 = g_dept[i].axa03                                                                                                         
                           AND axg04 = g_dept[i].axb04                                                                                                         
                           AND axg041= g_dept[i].axb05                                                                                                         
                           AND axg05 = l_aah.aah01     #FUN-A90026 mod
                           AND axg06 = l_aah.aah02                                                                                                             
                           AND axg07 = l_aah.aah03                                                                                                             
                           AND axg12 = l_axz06              #FUN-930117                                                                                        
                           AND axg17 = tm.ver              #MOD-930135                                                                                         
                           #AND axg20 = g_aej.aej18    #luttb 110803
                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                            CALL s_errmsg('axg01',g_dept[i].axa01,'upd_axg',SQLCA.sqlcode,1)                                                                       
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE                                                                  
                         END IF                                                                                                                                    
                    ELSE                                                                                                                                        
                        IF STATUS THEN                                                                                                                            
                            CALL s_errmsg('axg01',g_dept[i].axa01,'ins_axg',status,1)                                                                              
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE                                                                  
                        END IF                                                                                                                                    
                    END IF                                        
                END FOREACH

                
                #---FUN-AA0005 start---
                LET l_sql=
                    " SELECT axi03,axi04,axi081,axj03,axj06,aag04,SUM(axj07),COUNT(*),axi06 ",  #luttb add axi06
                    " FROM axi_file,axj_file,aag_file",
                    " WHERE axi00 = axj00 ",
                    "   AND axi01 = axj01 ",
                    "   AND axi00 = '",g_aaz641,"'",
                    "   AND axi03 = '",tm.yy,"'",
                    "   AND axi04 = '",tm.em,"'", 
                    "   AND axi08 = '1'",
                   #"   AND axi081 = 'U'",    #luttb
                    "   AND (axi081 = 'U' OR axi081 = 'W' OR axi081 = 'V')",    #sam 20101125 #NO.130806 mark
                    #"   AND (axi081 = 'U' OR axi081 = 'V')",    #sam 20101125  #NO.130806 modify
                    "   AND axi05 = '",g_dept[i].axa01,"'",
                    "   AND axi06 = '",g_dept[i].axb04,"'",
                   # "   AND axi09 = 'N'",    #luttb 暂时mark
                    "   AND axiconf = 'Y'",
                    "   AND aag00 = axj00 ",
                    "   AND aag01 = axj03 ",
                    #" GROUP BY axi03,axi04,axi081,axj03,axj06,aag04 ",  #luttb 110804
                    " GROUP BY axi03,axi04,axi081,axj03,axj06,aag04,axi06 ",
                    " ORDER BY axi03,axi04,axi081,axj03,axj06 "
                PREPARE p001_axj_p1 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                    CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p1',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                LET l_num = 0
                LET g_axj1.axj07 = 0
                DECLARE p001_axj_c1 CURSOR FOR p001_axj_p1
                FOREACH p001_axj_c1 INTO g_axg.axg06,g_axg.axg07,
                                         l_axi081,
                                         g_axg.axg05,g_axj1.axj06,
                                         l_aag04,
                                         g_axj1.axj07,l_num
                                        ,g_axg.axg20    #luttb 110804
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_axj_c1',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                   #Add by sam 20101125
                    IF l_axi081 = 'W' AND l_aag04 = '2' THEN
                       CONTINUE FOREACH 
                    END IF
                   #End Add
                    LET g_axg.axg00 = g_aaz641
                    LET g_axg.axg01 = g_dept[i].axa01
                    LET g_axg.axg02 = g_dept[i].axa02 
                    LET g_axg.axg03 = g_dept[i].axa03
                    LET g_axg.axg04 = g_dept[i].axb04
                    LET g_axg.axg041 = g_dept[i].axb05

                    IF g_axj1.axj06 = '1' THEN #借
                        LET g_axg.axg13 = g_axj1.axj07
                        LET g_axg.axg14 = 0
                        LET g_axg.axg10 = l_num
                    ELSE                       #貸
                        LET g_axg.axg13 = 0
                        LET g_axg.axg14 = g_axj1.axj07
                        LET g_axg.axg11 = l_num
                    END IF
                    DISPLAY g_axg.axg07,' ',g_axg.axg05,' ',g_axg.axg13,' ',g_axg.axg14
                 #Mark by sam 20101125     
                   #IF g_axg.axg13- g_axg.axg14 = 0 THEN                                  
                   #   IF l_aag04 = '2' THEN                                               
                   #      CALL p001_chkaah(g_axg.axg05,g_axg.axg07,g_axg.axg13,g_dept[i].axb05)             
                   #      RETURNING g_axg.axg13
                   #   END IF                                                               
                   #END IF                                                                                                                                     
                 #End Mark 
                    LET l_axe.axe11 = '1'
                    LET l_axe.axe12 = '1'
                   
                    LET l_sql = 
                    #" SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
                    " SELECT axe11,axe12 FROM axe_file ",
                    "  WHERE axe01 = '",g_dept[i].axb04,"'",
                    "    AND axe06 = '",g_axg.axg05,"'",
                    "    AND axe00 = '",g_dept[i].axb05,"'", 
                    "    AND axe13 = '",tm.axa01,"'"   
                    PREPARE p001_axe_p5 FROM l_sql
                    DECLARE p001_axe_c5 SCROLL CURSOR FOR p001_axe_p5
                    OPEN p001_axe_c5 
                    FETCH FIRST p001_axe_c5 INTO l_axe.*
                    CLOSE p001_axe_c5

                    IF STATUS THEN           
                       LET g_showmsg=g_dept[i].axb04,"/",g_axg.axg05
                       CALL s_errmsg('axe01,axe04',g_showmsg,g_axg.axg05,'aap-021',1)                               #NO.FUN-710023     
                       LET g_success = 'N' 
                       CONTINUE FOREACH        
                    END IF

                    DISPLAY g_axg.axg07,'->',g_axg.axg05,' ',g_axg.axg05,' ',g_axg.axg08,' ',g_axg.axg09

                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
                    #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
                    #  乘上匯率逐一算出借貸方計帳金額(axg08,axg09 OR axk10,axk11)
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg('axz01',g_dept[i].axb04,' ',SQLCA.sqlcode,1)   #NO.FUN-710023
                       LET g_success = 'N'
                       CONTINUE  FOREACH           
                    END IF

                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                    #一一換算後再加總起來
                    
                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    LET l_chg_aah04_1=0
                    LET l_chg_aah05_1=0
                    LET l_chg_aah04=0
                    LET l_chg_aah05=0
                    LET l_chg_aah04_a=0
                    LET l_chg_aah05_a=0

                    LET l_chg_dr = 0 
                    LET l_chg_cr = 0
                    LET l_fun_dr = 0 
                    LET l_fun_cr = 0 
                    LET l_acc_dr = 0 
                    LET l_acc_cr = 0
                    LET l_dr = 0  
                    LET l_cr = 0 

                    #依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                    #--現時匯率---
                    IF l_axe.axe11='1' THEN 
                        CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,tm.yy,tm.em)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs51 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs51
                        USING g_dept[i].axa01,g_dept[i].axb04,
                              g_axg.axg05,g_date_e    
                        FETCH p001_cnt_cs51 INTO l_axr_count
                        CLOSE p001_cnt_cs51
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,g_axg.axg05,g_date_e)  
                            CALL p001_axr(i,l_axe.axe04,g_axg.axg05,g_date_e)   #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,tm.yy,tm.em)
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
                    ELSE
                        CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,tm.yy,tm.em)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe11='3' THEN
                        CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,tm.yy,tm.em)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_axe.axe12='1' THEN 
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,tm.yy,tm.em)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs47 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs47
                        USING g_dept[i].axa01,g_dept[i].axb04,
                              g_axg.axg05,g_date_e  
                        FETCH p001_cnt_cs47 INTO l_axr_count
                        CLOSE p001_cnt_cs47
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,g_axg.axg05,g_date_e)  
                            CALL p001_axr(i,l_axe.axe04,g_axg.axg05,g_date_e)   #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              x_aaa03,tm.yy,tm.em)
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,tm.yy,tm.em)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe12='3' THEN
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,tm.yy,tm.em)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF

                    LET l_chg_aah04  =l_chg_aah04   + l_fun_dr
                    LET l_chg_aah05  =l_chg_aah05   + l_fun_cr
                    LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
                    LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07                                                                               
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
                    LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
                    LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
                    LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
                    LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
                    IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
                    IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF                                                                                   
 
                    IF g_axa05 = '1' THEN
                        IF l_axe.axe11 = '3' THEN   #TQC-AA0098
                            IF l_axz.axz06 != l_axz.axz07 THEN
                                LET l_axg18 = (l_chg_aah04-l_chg_aah05)/(g_axg.axg13-g_axg.axg14)
                            ELSE
                                LET l_axg18 = l_rate
                            END IF
                        ELSE                        #TQC-AA0098
                            LET l_axg18 = l_rate   #TQC-AA0098
                        END IF                     #TQC-AA0098
                        IF l_axe.axe12 = '3' THEN  #TQC-AA0098
                            IF l_axz.axz07 != x_aaa03 THEN
                                LET l_axg19 = (l_chg_aah04_1-l_chg_aah05_1)/(l_chg_aah04-l_chg_aah05)
                            ELSE
                                LET l_axg19 = l_rate1
                            END IF
                        ELSE                       #TQC-AA0098
                            LET l_axg19 = l_rate1  #TQC-AA0098
                        END IF                     #TQC-AA0098
                    ELSE
                        LET l_axg18 = l_rate
                        LET l_axg19 = l_rate1
                    END IF

                    INSERT INTO axg_file                                                                                                                        
                      (axg00,axg01,axg02,axg03,axg04,axg041,  
                       axg05,axg06,axg07,axg08,axg09,axg10,  
                       axg11,axg12,axg13,axg14,axg15,axg16, 
                       axg17,                              
                       axg18,axg19,axg20,axglegal)   #luttb 110804 add axg20  #NO.130717 add axglegal                   
                     VALUES                                                                                                                                     
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02, 
                       g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05,                                                                                        
                       g_axg.axg05,tm.yy,tm.em,l_chg_aah04_1, 
                       l_chg_aah05_1,g_axg.axg10,g_axg.axg11,l_axz06,                                                                                          
                       g_axg.axg13,g_axg.axg14,l_chg_aah04,l_chg_aah05,                                                                                        
                       tm.ver,                                                                                                            
                       l_axg18,l_axg19,g_axg.axg20,g_legal)   #luttb 110804 add axg20      
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                        UPDATE axg_file SET axg08=axg08+l_chg_aah04_1, 
                                            axg09=axg09+l_chg_aah05_1,
                                            axg10=axg10+g_axg.axg10,
                                            axg11=axg11+g_axg.axg11,
                                            axg13=axg13+g_axg.axg13,
                                            axg14=axg14+g_axg.axg14,
                                            axg15=axg15+l_chg_aah04,  
                                            axg16=axg16+l_chg_aah05,  
                                            axg18=l_axg18,            
                                            axg19=l_axg19            
                         WHERE axg00 = g_aaz641   
                           AND axg01 = g_dept[i].axa01                                                                                                         
                           #AND axg02 = tm.axa02
                           AND axg02 = g_dept[i].axa02
                           AND axg03 = g_dept[i].axa03                                                                                                         
                           AND axg04 = g_dept[i].axb04                                                                                                         
                           AND axg041= g_dept[i].axb05                                                                                                         
                           AND axg05 = g_axg.axg05
                           AND axg06 = g_axg.axg06
                           AND axg07 = g_axg.axg07
                           AND axg12 = l_axz06   
                           AND axg17 = tm.ver    
                           #AND axg20 = g_axg.axg20   #luttb 110804
                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                            CALL s_errmsg('axg01',g_dept[i].axa01,'upd_axg',SQLCA.sqlcode,1)                                                                       
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH     
                         END IF                                                                                                                                    
                    ELSE                                                                                                                                        
                        IF STATUS THEN                                                                                                                            
                            CALL s_errmsg('axg01',g_dept[i].axa01,'ins_axg',status,1)                                                                              
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      
                        END IF                                                                                                                                    
                    END IF                                        
                END FOREACH

                #--取調整分錄中有關係人的資料---#
                LET l_sql=
                    " SELECT axi03,axi04,axi081,axj03,axj05,axj06,aag04,SUM(axj07),COUNT(*),axi06 ", #luttb 110804 add axi06
                    " FROM axi_file,axj_file,aag_file",
                    " WHERE axi00 = axj00 ",
                    "   AND axi01 = axj01 ",
                    "   AND axi00 = '",g_aaz641,"'",
                    "   AND axi03 = '",tm.yy,"'",
                    "   AND axi04 = '",tm.em,"'", 
                    "   AND axi08 = '1'",
                   #"   AND axi081= 'U'",   #luttb
                    "   AND (axi081= 'U' OR axi081 ='W' OR axi081 ='V')",   #sam 20101125
                    "   AND (axi081= 'U' OR axi081 ='W' OR axi081 ='V')",   #sam 20101125
                    "   AND axi05 = '",g_dept[i].axa01,"'",
                    "   AND axi06 = '",g_dept[i].axb04,"'",
                    #"   AND axi09 = 'N'",    #luttb 暂时mark
                    "   AND axiconf = 'Y'",
                    "   AND axj05 <> ' '",
                    "   AND aag00 = axj00 ",
                    "   AND aag01 = axj03 ",
                   #" GROUP BY axi03,axi04,axi081,axj03,axj05,axj06,aag04 ", #luttb 110804
                    " GROUP BY axi03,axi04,axi081,axj03,axj05,axj06,aag04,axi06 ",
                    " ORDER BY axi03,axi04,axi081,axj03,axj06 "
                PREPARE p001_axj_p2 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                    CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p2',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                LET l_num = 0
                LET g_axj1.axj07 = 0
                DECLARE p001_axj_c2 CURSOR FOR p001_axj_p2
                FOREACH p001_axj_c2 INTO g_axk.axk08,g_axk.axk09,
                                         l_axi081,
                                         g_axk.axk05,g_axk.axk07,
                                         g_axj1.axj06,
                                         l_aag04,
                                         g_axj1.axj07,l_num
                                        ,g_axk.axk22    #luttb 110804
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_axj_c2',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                   #Add by sam 20101125
                    IF l_axi081 = 'W' AND l_aag04 = '2' THEN
                       CONTINUE FOREACH 
                    END IF
                   #End Add

                    LET g_axk.axk00 = g_aaz641
                    LET g_axk.axk01 = g_dept[i].axa01
                    LET g_axk.axk02 = g_dept[i].axa02 
                    LET g_axk.axk03 = g_dept[i].axa03
                    LET g_axk.axk04 = g_dept[i].axb04
                    LET g_axk.axk041 = g_dept[i].axb05

                    IF g_axj1.axj06 = '1' THEN #借
                        LET g_axk.axk18 = g_axj1.axj07
                        LET g_axk.axk19 = 0
                        LET g_axk.axk12 = l_num
                    ELSE                       #貸
                        LET g_axk.axk18 = 0
                        LET g_axk.axk19 = g_axj1.axj07
                        LET g_axk.axk13 = l_num
                    END IF

                    LET l_sql = 
                    #" SELECT axe11,axe12 FROM axe_file ",
                    " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
                    "  WHERE axe01 = '",g_dept[i].axb04,"'",
                    "    AND axe06 = '",g_axk.axk05,"'",
                    "    AND axe00 = '",g_dept[i].axb05,"'", 
                    "    AND axe13 = '",tm.axa01,"'"   
                    PREPARE p001_axe_p4 FROM l_sql
                    DECLARE p001_axe_c4 SCROLL CURSOR FOR p001_axe_p4
                    OPEN p001_axe_c4 
                    FETCH FIRST p001_axe_c4 INTO l_axe.*
                    CLOSE p001_axe_c4

                     IF STATUS  THEN                   
                        LET g_showmsg=g_dept[i].axb04,"/",g_axk.axk05
                         CALL s_errmsg('axe01,axe04',g_showmsg,g_axk.axk05,'aap-021',1)                #NO.FUN-710023    
                         LET g_success = 'N'
                         CONTINUE FOREACH    
                     END IF

                     #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                     LET l_rate  = 1
                     LET l_rate1 = 1
                     #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                     #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                     #一一換算後再加總起來

                     #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                     #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-770069  #FUN-970046 mOd  #FUN-A60038 MARK
                     LET l_chg_aed05_1=0
                     LET l_chg_aed06_1=0
                     LET l_chg_aed05=0
                     LET l_chg_aed06=0
                     LET l_chg_aed05_a=0
                     LET l_chg_aed06_a=0
                     LET l_chg_dr = 0 
                     LET l_chg_cr = 0
                     LET l_fun_dr = 0 
                     LET l_fun_cr = 0 
                     LET l_acc_dr = 0 
                     LET l_acc_cr = 0
                     LET l_dr = 0   
                     LET l_cr = 0  

                     #依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                     #--現時匯率---
                     IF l_axe.axe11='1' THEN 
                         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,g_axk.axk08,g_axk.axk09)
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF

                     #--歷史匯率---
                     IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                         #----如果agli011抓不到資料，則依科目餘額計算---- 
                         DECLARE p001_cnt_cs49 CURSOR FOR p001_axr_p2
                         OPEN p001_cnt_cs49
                         USING g_dept[i].axa01,g_dept[i].axb04,
                               g_axk.axk05,g_date_e  
                         FETCH p001_cnt_cs49 INTO l_axr_count
                         CLOSE p001_cnt_cs49
                         IF l_axr_count > 0 THEN   
                             #CALL p001_axr(i,g_axk.axk05,g_date_e)   
                             CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)    #TQC-AA0098
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,g_axk.axk08,g_axk.axk09)
                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                         END IF
                     ELSE
                         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                       l_axe.axe11,l_axz.axz06,
                                       l_axz.axz07,g_axk.axk08,g_axk.axk09)
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF
       
                     #--平均匯率---
                     IF l_axe.axe11='3' THEN
                         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,g_axk.axk08,g_axk.axk09)
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF

                     #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                     #--現時匯率---
                     IF l_axe.axe12='1' THEN 
                         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                           l_axe.axe12,l_axz.axz07,
                                           x_aaa03,g_axk.axk08,g_axk.axk09)
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF

                     #--歷史匯率---
                     IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                         #----如果agli011抓不到資料，則依科目餘額計算---- 
                         DECLARE p001_cnt_cs50 CURSOR FOR p001_axr_p2
                         OPEN p001_cnt_cs50
                         USING g_dept[i].axa01,g_dept[i].axb04,
                               g_axk.axk05,g_date_e    
                         FETCH p001_cnt_cs50 INTO l_axr_count
                         CLOSE p001_cnt_cs50
                         IF l_axr_count > 0 THEN   
                             #CALL p001_axr(i,g_axk.axk05,g_date_e)  
                             CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)    #TQC-AA0098
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                               l_axe.axe12,l_axz.axz07,
                                               x_aaa03,g_axk.axk08,g_axk.axk09)
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         END IF
                     ELSE
	                 CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
	             		      l_axe.axe12,l_axz.axz07,
	             		      x_aaa03,g_axk.axk08,g_axk.axk09)
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF

                     #--平均匯率---
                     IF l_axe.axe12='3' THEN
                         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                           l_axe.axe12,l_axz.axz07,
                                           x_aaa03,g_axk.axk08,g_axk.axk09)
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF       

                     LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
                     LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
                     LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
                     LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr

                     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07    #FUN-A60060 mod
                     IF cl_null(l_cut) THEN LET l_cut=0 END IF
                     SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
                     IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                     
                     #->幣別轉換及取位
                     LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
                     LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
                     LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
                     LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
                     IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
                     IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
                     
                     IF g_axa05 = '1' THEN
                         IF l_axe.axe11 = '3' THEN     #TQC-AA0098
                             IF l_axz.axz06 != l_axz.axz07 THEN
                                 LET l_axk16 = (l_chg_aed05-l_chg_aed06)/(g_axk.axk18-g_axk.axk19)
                             ELSE
                                 LET l_axk16 = l_rate
                             END IF
                         #TQC-AA0098 start
                         ELSE
                             LET l_axk16 = l_rate
                         END IF
                         #TQC-AA0098 end

                         IF l_axe.axe12 = '3' THEN   #TQC-AA0098
                             IF l_axz.axz07 != x_aaa03 THEN
                                 LET l_axk17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06)
                             ELSE
                                 LET l_axk17 = l_rate1
                             END IF
                         #--TQC-AA0098
                         ELSE
                             LET l_axk17 = l_rate1
                         END IF
                         #--TQC-AA0098
                     ELSE
                         LET l_axk16 = l_rate
                         LET l_axk17 = l_rate1
                     END IF
                     INSERT INTO axk_file 
                      (axk00,axk01,axk02,axk03,axk04,axk041,   
                       axk05,axk06,axk07,axk08,axk09,axk10,
                       axk11,axk12,axk13,axk14,axk15, 
                       axk16,axk17,
                       axk18,axk19,axk20,axk21,axk22,axklegal)   #luttb 110804 add axk22  #NO.130717 add axklegal 
                      VALUES 
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  
                        g_dept[i].axa03,  
                        g_dept[i].axb04,g_dept[i].axb05,g_axk.axk05,'99',
                        g_axk.axk07,g_axk.axk08,g_axk.axk09,
                        l_chg_aed05_1,l_chg_aed06_1,  
                        g_axk.axk12,g_axk.axk13,l_axz06, 
                        tm.ver,                                        
                        l_axk16,l_axk17,
                        g_axk.axk18,g_axk.axk19,l_chg_aed05,l_chg_aed06,g_axk.axk22,g_legal) #luttb 110804 add axk22 #NO.130717 add g_legal 
                     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                        UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
                                               axk11=axk11+l_chg_aed06_1,
                                               axk12=axk12+g_axk.axk12,
                                               axk13=axk13+g_axk.axk13,
                                               axk16=l_axk16,            
                                               axk17=l_axk17,
                                               axk18=axk18+g_axk.axk18,
                                               axk19=axk19+g_axk.axk19,                 #MOD-A70091
                                               axk20=axk20+l_chg_aed05,                 #MOD-A70091
                                               axk21=axk21+l_chg_aed06                  #MOD-A70091
                            WHERE axk00 = g_aaz641  
                              AND axk01 = g_dept[i].axa01
                             # AND axk02 = tm.axa02 
                              AND axk02 = g_dept[i].axa02
                              AND axk03 = g_dept[i].axa03
                              AND axk04 = g_dept[i].axb04
                              AND axk041= g_dept[i].axb05
                              AND axk05 = g_axk.axk05
                              AND axk06 = '99'
                              AND axk07 = g_axk.axk07
                              AND axk08 = g_axk.axk08
                              AND axk09 = g_axk.axk09
                              AND axk14 = l_axz06
                              AND axk15 = tm.ver           
                              #AND axk22 = g_axk.axk22   #luttb 110804
                        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                           CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
                           LET g_success = 'N' 
                           CONTINUE FOREACH      
                        END IF
                     ELSE
                        IF STATUS THEN 
                           LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04      
                           CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                
                           LET g_success = 'N'
                           CONTINUE FOREACH       
                        END IF
                     END IF                          
                END FOREACH
                #---------------FUN-AA0005 end------------------
 
#FUN-920067 無下層且使用TIPTOP(axz04 = 'Y')時 以本層aed_file資料寫入axk_file----------
                #--FUN-A90026 start--將aed_file->aek_file 且BS/IS類科目均作累計處理----
                LET l_sql=
                    " SELECT aek04,aek05,aek06,SUM(aek08),SUM(aek09),SUM(aek10),SUM(aek11),aek19 ",  #luttb 110804 add aek13
                    " FROM aek_file",
                    " WHERE aek00 = '",g_aaz641,"'",
                    "   AND aek01 = '",g_dept[i].axa01,"'",
                    "   AND aek02 = '",g_dept[i].axb04,"'",
                    "   AND aek06 = '",tm.yy,"'",
                    "   AND aek07 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
                    #" GROUP BY aek04,aek05,aek06 ",  #luttb 110804
                    " GROUP BY aek04,aek05,aek06,aek19 ", #NO.130717 aek13->aek19
                    " ORDER BY aek04,aek05 "
                #--FUN-A90026 end----------------------------------------------------

#--FUN-A90026 mark --start------       
#             #--FUN-A90006 start--
#               LET l_sql=
#                 #" SELECT unique aed01 ",
#                 " SELECT unique aed01,aed02 ",  #FUN-A90006
#                 " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
#                 " WHERE aed03=",tm.yy,
#                 " AND aed00='",g_dept[i].axb05,"' AND aed011='99' ",
#                 " AND aed01 = aag01 ",
#                 " AND aed00 = aag00 ",
#                 " AND aag07 IN ('2','3') ",
#                 " AND aag04 <> '1'",
#                 " AND aag01 <> '",g_aaz113,"'",
#                 " AND aag09 = 'Y' ",
#                 " ORDER BY aed01 "
#               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#--FUN-A90026 mark end----------------------------------------------
                PREPARE p001_aed_p5 FROM l_sql
                IF STATUS THEN
                     LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
                     CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR
                END IF
                DECLARE p001_aed_c5 CURSOR FOR p001_aed_p5
                #FOREACH p001_aed_c5 INTO l_aed01
                #FOREACH p001_aed_c5 INTO l_aed01,l_aed02  #FUN-A90006
                #--FUN-A90026 start--
                FOREACH p001_aed_c5 INTO g_aek.aek04,g_aek.aek05,g_aek.aek06,   
                                         g_aek.aek08,g_aek.aek09,  
                                         g_aek.aek10,g_aek.aek11              
                                        #,g_aek.aek13   #luttb 110804 #NO.130717 mark
                                        ,g_aek.aek19   #luttb 110804 #NO.130717 modify
                     LET l_aed.aed01 = g_aek.aek04
                     LET l_aed.aed02 = g_aek.aek05
                     LET l_aed.aed03 = g_aek.aek06
                     LET l_aed.aed04 = tm.em
                     LET l_aed.aed05 = g_aek.aek08 
                     LET l_aed.aed06 = g_aek.aek09
                     LET l_aed.aed07 = g_aek.aek10
                     LET l_aed.aed08 = g_aek.aek11
                     LET l_aed.aed011 = '99'
                   
                     LET l_axe.axe11 = '1'
                     LET l_axe.axe12 = '1'
#--------------------FUN-A90026 mark------------
#                     SELECT axe06,axe11,axe12 INTO l_axe.* FROM axe_file   
#                      WHERE axe01 = g_dept[i].axb04 AND axe06 = l_aed.aed01
#                        AND axe00 = g_dept[i].axb05 
#                        AND axe13 = tm.axa01         
#--------------------FUN-A90026 mark------------

                    #---FUN-A90026 start----
                    LET l_sql = 
                    #" SELECT axe11,axe12 FROM axe_file ",
                    " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
                    "  WHERE axe01 = '",g_dept[i].axb04,"'",
                    "    AND axe06 = '",l_aed.aed01,"'",
                    "    AND axe00 = '",g_dept[i].axb05,"'", 
                    "    AND axe13 = '",tm.axa01,"'"   
                    PREPARE p001_axe_p2 FROM l_sql
                    DECLARE p001_axe_c2 SCROLL CURSOR FOR p001_axe_p2
                    OPEN p001_axe_c2 
                    FETCH FIRST p001_axe_c2 INTO l_axe.*
                    CLOSE p001_axe_c2
                    #---FUN-A90026 end--------

                     IF STATUS  THEN                   
                        LET g_showmsg=g_dept[i].axb04,"/",l_aed.aed01 
                         CALL s_errmsg('axe01,axe04',g_showmsg,l_aed.aed01,'aap-021',1)                #NO.FUN-710023    
                         LET g_success = 'N'
                         CONTINUE FOREACH    
                     END IF
                #---FUN-A90026 end-----
#--FUN-A90026 mark start--------------------------------------------- 
#               LET l_sql=
#                     " SELECT COUNT(*) ",
#                    " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
#                    " WHERE aed03=",tm.yy,
#                    " AND aed04 ='",tm.em,"'",
#                     " AND aed00='",g_dept[i].axb05,"' AND aed011='99' ",
#                     " AND aed01 = aag01 ",
#                     " AND aed01 = '",l_aed01,"'",
#                     " AND aed00 = aag00 ",
#                     " AND aag07 IN ('2','3') ",
#                     " AND aag04 <> '1'",
#                     " AND aed02 = '",l_aed02,"'",     #FUN-A90006
#                     " AND aag09 = 'Y' "
#               PREPARE p001_aed_cnt_p1 FROM l_sql
#               DECLARE p001_aed_cnt_c1 CURSOR FOR p001_aed_cnt_p1
#               LET l_aed_cnt = 0
#               OPEN p001_aed_cnt_c1
#               FETCH p001_aed_cnt_c1 INTO l_aed_cnt
#               CLOSE p001_aed_cnt_c1
#
#               IF l_aed_cnt = 0 THEN
#                   LET l_mm = tm.em - 1
#                   INITIALIZE l_axg.* TO NULL
#                   SELECT * INTO l_axk.*
#                     FROM axk_file
#                    WHERE axk00 = g_aaz641
#                      AND axk01 = g_dept[i].axa01
#                      AND axk02 = g_dept[i].axa02
#                      AND axk03 = g_dept[i].axa03
#                      AND axk04 = g_dept[i].axb04
#                      AND axk041 = g_dept[i].axb05
#                      AND axk05 = l_aed01
#                      AND axk06 = '99'
#                      AND axk07 = l_aed02
#                      AND axk08 = tm.yy
#                      AND axk09 = l_mm
#                      AND axk14 = l_axz06
#                      AND axk15 = tm.ver
#                   IF NOT cl_null(l_axk.axk10) OR NOT cl_null(l_axk.axk11) THEN
#                       LET l_axk.axk09 = l_axk.axk09 +  1
#                       LET l_axk.axk18 = 0
#                       LET l_axk.axk19 = 0
#                       INSERT INTO axk_file VALUES (l_axk.*)
#                        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
#                            UPDATE axk_file SET axk10=axk10+l_axk.axk10,
#                                                axk11=axk11+l_axk.axk11,
#                                                axk12=axk12+l_axk.axk12,
#                                                axk13=axk13+l_axk.axk13,
#                                                axk16=l_axk.axk16,
#                                                axk17=l_axk.axk17,
#                                                axk18=axk18+l_axk.axk18,
#                                                axk19=axk19+l_axk.axk19,
#                                                axk20=axk20+l_axk.axk20,
#                                                axk21=axk21+l_axk.axk21
#                           WHERE axk00 = l_axk.axk00
#                             AND axk01 = l_axk.axk01
#                             AND axk02 = l_axk.axk02
#                             AND axk03 = l_axk.axk03
#                             AND axk04 = l_axk.axk04
#                             AND axk041 = l_axk.axk041
#                             AND axk05 = l_axk.axk05
#                             AND axk06 = l_axk.axk06
#                             AND axk07 = l_axk.axk07
#                             AND axk08 = l_axk.axk08
#                             AND axk09 = l_axk.axk09
#                             AND axk14 = l_axk.axk14
#                             AND axk15 = l_axk.axk15
#                            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                                CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1)
#                               LET g_success = 'N'
#                            END IF
#                        ELSE
#                            IF STATUS THEN
#                                LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04
#                                CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)
#                                LET g_success = 'N'
#                            END IF
#                        END IF
#                   END IF
#               ELSE  
#               #-------FUN-A90006 end----------
#                   LET l_sql=" SELECT aed01,aed011,aed02,aed03,aed04,",
#                             " aed05,aed06,aed07,aed08 ",
#                             " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",  #MOD-950019 add aag_file
#                             " WHERE aed03=",tm.yy,
#                             " AND aed04 ='",tm.em,"'",                           #FUN-970046
#                             " AND aed00='",g_dept[i].axb05,"' AND aed011='99' ", #FUN-630063
#                             " AND aed01 = aag01 ",
#                             " AND aed01 = '",l_aed01,"'",    #FUN-A90006
#                             " AND aed02 = '",l_aed02,"'",    #FUN-A90006
#                             " AND aed00 = aag00 ",
#                             " AND aag07 IN ('2','3') ",
#                             " AND aag04 <> '1'",        #FUN-970046 add                       
#                             " AND aag01 <> '",g_aaz113,"'",          #FUN-A30079 排除本期損益-IS科目
#                             " AND aag09 = 'Y' "
#
#	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
#                   PREPARE p001_aed_p FROM l_sql
#                   IF STATUS THEN
#                       LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
#                       CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                   END IF
#                   DECLARE p001_aed_c CURSOR FOR p001_aed_p
#                   FOREACH p001_aed_c INTO l_aed.*
#                       IF SQLCA.SQLCODE THEN 
#                          LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
#                          CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                       END IF
#                       IF l_aed.aed05 =0 AND l_aed.aed06=0 THEN CONTINUE FOREACH END IF
#                       LET l_axe.axe06 = l_aed.aed01
#                       LET l_axe.axe11 = '1'
#                       LET l_axe.axe12 = '1'
#                       #抓取下層公司的科目的合併財報科目編號(axe06),
#                       #再衡量匯率類別(axe11),換算匯率類別(axe12),
#                       #以判斷後續轉換幣別時,要用那種匯率計算
#                       SELECT axe06,axe11,axe12 INTO l_axe.* FROM axe_file   
#                        WHERE axe01 = g_dept[i].axb04 AND axe04 = l_aed.aed01
#                          AND axe00 = g_dept[i].axb05   #No.FUN-740020
#                          AND axe13 = tm.axa01          #FUN-910001 add
#                       IF STATUS  THEN                   
#                          LET g_showmsg=g_dept[i].axb04,"/",l_aed.aed01 
#                           CALL s_errmsg('axe01,axe04',g_showmsg,l_aed.aed01,'aap-021',1)                #NO.FUN-710023    
#                           LET g_success = 'N'
#                           CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                       END IF
#                       LET l_axe06 = l_axe.axe06   #FUN-580063    
#
#                       #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
#                       #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
#                       #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
#                       #  乘上匯率逐一算出借貸方記帳金額(axg08,axg09 OR axk10,axk11)
#                       SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
#                       IF SQLCA.sqlcode THEN
#                          CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)                                  #NO.FUN-710023
#                          LET g_success = 'N'
#                          CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                       END IF
#                       LET l_aag04=''
#                       LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
#                                   " WHERE aag00='",g_dept[i].axb05,"'", #帳別
#                                   "   AND aag01='",l_aed.aed01,"'" #科目
#	                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
#                       PREPARE p001_pre_02 FROM g_sql
#                       DECLARE p001_cur_02 CURSOR FOR p001_pre_02
#                       OPEN p001_cur_02
#                       FETCH p001_cur_02 INTO l_aag04
#                       CLOSE p001_cur_02
#                       IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
#----------FUN-A90026 mark end-----------------------------------------------

                     #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                     LET l_rate  = 1
                     LET l_rate1 = 1
                     #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                     #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                     #一一換算後再加總起來

                     #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                     #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-770069  #FUN-970046 mOd  #FUN-A60038 MARK
                     LET l_chg_aed05_1=0
                     LET l_chg_aed06_1=0
                     LET l_chg_aed05=0
                     LET l_chg_aed06=0
                     LET l_chg_aed05_a=0
                     LET l_chg_aed06_a=0
                     #---FUN-A60038 start---
                     LET l_chg_dr = 0 
                     LET l_chg_cr = 0
                     LET l_fun_dr = 0 
                     LET l_fun_cr = 0 
                     LET l_acc_dr = 0 
                     LET l_acc_cr = 0
                     #---FUN-A60038 end-----
                     LET l_dr = 0   #MOD-A80102
                     LET l_cr = 0   #MOD-A80102

                     #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                     #--現時匯率---
                     IF l_axe.axe11='1' THEN 
                         CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,l_aed.aed03,l_aed.aed04)
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF

                     #--歷史匯率---
                     IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                         #----如果agli011抓不到資料，則依科目餘額計算---- 
                         DECLARE p001_cnt_cs23 CURSOR FOR p001_axr_p2
                         OPEN p001_cnt_cs23
                         USING g_dept[i].axa01,g_dept[i].axb04,
                              #l_aed.aed01,l_axe.axe06,g_date_e 
                              l_aed.aed01,g_date_e                #FUN-A90026 mod
                         FETCH p001_cnt_cs23 INTO l_axr_count
                         CLOSE p001_cnt_cs23
                         IF l_axr_count > 0 THEN   
                             #CALL p001_axr(i,l_aed.aed01,l_axe.axe06,g_date_e) 
                             #CALL p001_axr(i,l_aed.aed01,g_date_e)    #FUN-A90026 
                             CALL p001_axr(i,l_axe.axe04,l_aed.aed01,g_date_e)    #FUN-A90026   #TQC-AA0098
                             #--FUN-A70086 start--
                             #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                             #LET l_fun_dr = l_chg_dr
                             #LET l_fun_cr = l_chg_cr
                             #LET l_acc_dr = l_chg_dr
                             #LET l_acc_cr = l_chg_cr
                             #--FUN-A70086 end----
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,l_aed.aed03,l_aed.aed04)
                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                         END IF
                     ELSE
                         CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                       l_axe.axe11,l_axz.axz06,
                                       l_axz.axz07,l_aed.aed03,l_aed.aed04)
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF
       
                     #--平均匯率---
                     IF l_axe.axe11='3' THEN
#--FUN-A90006 start--
                         #--FUN-A90026 start--
                         IF g_axa05 = '1' THEN     
       		     	     CALL p001_fun_axk_avg(l_axe.axe11,l_aed.aed01,
                                                   l_aed.aed02,l_axz.axz06,l_axz.axz07,
                                                   #l_aed.aed03,l_aed.aed04,i,g_aek.aek13) #luttb 110913 add aek13 #NO.130717 mark
                                                   l_aed.aed03,l_aed.aed04,i,g_aek.aek19) #luttb 110913 add aek13 #NO.130717 modify
                             RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                             #CALL p001_fun_axk_avg('1',l_axe.axe06,l_aed.aed02,        #FUN-A9026 mark
                             #                      l_aag04,                            #FUN-A9026 mark
                             #                      l_axz.axz06,l_axz.axz07,i,          #FUN-A9026 mark
                             #                      l_aed.aed05,l_aed.aed06)            #FUN-A9026 mark
                             #RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                         ELSE
                             CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                           l_axe.axe11,l_axz.axz06,
                                           l_axz.axz07,l_aed.aed03,l_aed.aed04)
                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                         END IF
                         #--FUN-A90026 end----
#--FUN-A90006 end----
                     END IF

                     #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                     #--現時匯率---
                     IF l_axe.axe12='1' THEN 
                         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                           l_axe.axe12,l_axz.axz07,
                                           x_aaa03,l_aed.aed03,l_aed.aed04)
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF

                     #--歷史匯率---
                     IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                         #----如果agli011抓不到資料，則依科目餘額計算---- 
                         DECLARE p001_cnt_cs26 CURSOR FOR p001_axr_p2
                         OPEN p001_cnt_cs26
                         USING g_dept[i].axa01,g_dept[i].axb04,
                               #l_aed.aed01,l_axe.axe06,g_date_e 
                               l_aed.aed01,g_date_e              #FUN-A90026 mod
                         FETCH p001_cnt_cs26 INTO l_axr_count
                         CLOSE p001_cnt_cs26
                         IF l_axr_count > 0 THEN   
                             #CALL p001_axr(i,l_aed.aed01,l_axe.axe06,g_date_e)  
                             #CALL p001_axr(i,l_aed.aed01,g_date_e)    #FUN-A90026 mod
                             CALL p001_axr(i,l_axe.axe04,l_aed.aed01,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
                             #--FUN-A70086 start--
                             #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                             #LET l_fun_dr = l_chg_dr
                             #LET l_fun_cr = l_chg_cr
                             #LET l_acc_dr = l_chg_dr
                             #LET l_acc_cr = l_chg_cr
                             #--FUN-A70086 end----
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                               l_axe.axe12,l_axz.axz07,
                                               x_aaa03,l_aed.aed03,l_aed.aed04)
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         END IF
                     ELSE
	                 CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
	             		      l_axe.axe12,l_axz.axz07,
	             		      x_aaa03,l_aed.aed03,l_aed.aed04)
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF

                     #--平均匯率---
                     IF l_axe.axe12='3' THEN
#--FUN-A90006 START--
                         #--FUN-A90026 start--
                         IF g_axa05 = '1' THEN        
                             CALL p001_axk_avg(l_axe.axe11,l_axe.axe12,l_aed.aed01,l_aed.aed02,
                                               l_axz.axz06,l_axz.axz07,l_aed.aed03,l_aed.aed04,i,g_aek.aek19) #luttb 110913 add aek13  
                             #CALL p001_axk_avg('2',g_dbs_gl,l_aed.aed01,l_aed.aed02,    #FUN-A90026 mark 
                             #                  g_dept[i].axb05,l_aag04,                 #FUN-A90026 mark
                             #                  l_axz.axz06,l_axz.axz07,i,               #FUN-A90026 mark
                             #                  l_dr,l_cr)                               #FUN-A90026 mark
                             #--FUN-A90026 end----
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         #--FUN-A90026 start---
                         ELSE
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,l_aed.aed03,l_aed.aed04)
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         END IF
                         #--FUN-A90026 end------
#--FUN-A90006 end---
                     END IF       
                     #-------FUN-A60038 end-----------------------------------

#---------FUN-A60038 mark---------------------------------------------
#                    DECLARE p001_cnt_cs3 CURSOR FOR p001_axr_p2
#                    OPEN p001_cnt_cs3
#                    USING g_dept[i].axa01,g_dept[i].axb04,
#                          l_aed.aed01,l_axe.axe06,g_date_e   #FUN-970046
#                    FETCH p001_cnt_cs3 INTO l_axr_count
#                    IF l_axr_count > 0 THEN
#                       DECLARE p001_axr_cs5 CURSOR FOR p001_axr_p
#                       OPEN p001_axr_cs5                         #FUN-970046 add
#                       USING g_dept[i].axa01,g_dept[i].axb04,
#                             l_aed.aed01,l_axe.axe06,g_date_e    #FUN-970046 mod
#                       FETCH p001_axr_cs5                        #FUN-970046 add
#                        INTO l_aag06,l_axr13                     #FUN-990020 mark
#                       #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                       IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                           #功能幣別匯率
#                           CALL p001_getrate(l_axe.axe11,l_axr08,l_axr09,   #FUN-770069 mod
#                                             l_axz.axz06,l_axz.axz07)   #MOD-780115
#                           RETURNING l_rate
#                           IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                       END IF
#                       #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                       IF l_axz.axz07 != x_aaa03 THEN
#                           #記帳幣別匯率
#                           CALL p001_getrate(l_axe.axe12,l_axr08,l_axr09,   #FUN-770069 mod
#                                             l_axz.axz07,x_aaa03)
#                           RETURNING l_rate1
#                           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                       END IF
#                       IF g_dept[i].axa02=g_dept[i].axb04 THEN
#                           LET l_rate=1
#                           LET l_rate1=1
#                       END IF                     
#
#                       #->幣別轉換及取位
#                       #原本程式: IF l_axr05 > 0 段增加下列判斷式
#                       #->幣別轉換及取位
#                       IF l_axr13 > 0 THEN 
#                           IF l_aag06='1' THEN                 #正常餘額為1.借餘
#                               LET l_chg_aed05_a=l_axr13       #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=0             #下層公司功能幣別貸方金額
#                           ELSE                   #正常餘額為2.貸餘
#                               LET l_chg_aed05_a=0             #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=l_axr13       #下層公司功能幣別貸方金額
#                           END IF
#                       ELSE
#                           IF l_aag06='1' THEN    #正常餘額為1.借餘
#                               LET l_chg_aed05_a=0             #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=(l_axr13*-1)  #下層公司功能幣別貸方金額
#                           ELSE                   #正常餘額為2.貸餘
#                               LET l_chg_aed05_a=(l_axr13*-1)  #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=0             #下層公司功能幣別貸方金額
#                           END IF
#                       END IF
#                       LET l_chg_aed05  =l_chg_aed05   + l_chg_aed05_a           #下層公司功能幣借方金額
#                       LET l_chg_aed06  =l_chg_aed06   + l_chg_aed06_a           #下層公司功能幣貸方金額
#                       LET l_chg_aed05_1=l_chg_aed05_1 + l_chg_aed05_a * l_rate1 #上層記帳幣別借方金額
#                       LET l_chg_aed06_1=l_chg_aed06_1 + l_chg_aed06_a * l_rate1 #上層記帳幣別貸方金額
#------------------FUN-A60038 mark-----------------------------------------------

                     #--FUN-A60038 start--
                     LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
                     LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
                     LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
                     LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr
                     #---FUN-A60038 end----

                     #SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
                     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07    #FUN-A60060 mod
                     IF cl_null(l_cut) THEN LET l_cut=0 END IF
                     SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
                     IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                     
                     #LET l_aed.aed01=l_axe06   #FUN-A90026 mark
                     #->幣別轉換及取位
                     LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
                     LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
                     LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
                     LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
                     IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
                     IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
                     
                     #--FUN-A90026 start--
                     IF g_axa05 = '1' THEN
                         IF l_axe.axe11 = '3' THEN  #TQC-AA0098
                             IF l_axz.axz06 != l_axz.axz07 THEN
                                 LET l_axk16 = (l_chg_aed05-l_chg_aed06)/(l_aed.aed05-l_aed.aed06)
                             ELSE
                                 LET l_axk16 = l_rate
                             END IF
                         #TQC-AA0098
                         ELSE
                             LET l_axk16 = l_rate
                         END IF
                         #TQC-AA0098

                         IF l_axe.axe12 = '3' THEN   #TQC-AA0098
                             IF l_axz.axz07 != x_aaa03 THEN
                                 LET l_axk17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06)
                             ELSE
                                 LET l_axk17 = l_rate1     #FUN-960003 add
                             END IF
                         #TQC-AA0098
                         ELSE
                             LET l_axk17 = l_rate1
                         END IF
                         #TQC-AA0098
                     ELSE
                     #--FUN-A90026 end---
                         LET l_axk16 = l_rate      #FUN-960003 add
                         LET l_axk17 = l_rate1     #FUN-960003 add
                     END IF   #FUN-A90026 add

                     INSERT INTO axk_file 
                      (axk00,axk01,axk02,axk03,axk04,axk041,   
                       axk05,axk06,axk07,axk08,axk09,axk10,
                       axk11,axk12,axk13,axk14,axk15,  #FUN-580063   
                       axk16,axk17,
                       axk18,axk19,axk20,axk21,axk22,axklegal)        #FUN-A30079 #luttb 110804 add axk22 #NO.130717 add axklegal
                      VALUES 
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  
                        g_dept[i].axa03,   #FUN-5A0020
                        g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
                        l_aed.aed02,l_aed.aed03,l_aed.aed04,
                        l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
                        l_aed.aed07,l_aed.aed08,l_axz06, 
                        tm.ver,                                        
                        l_axk16,l_axk17,
                        l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06,g_aek.aek19,g_legal)  #FUN-A30079  #luttb 110804 add axk22  #NO.130717 add g_legal                     
                     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                        UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
                                               axk11=axk11+l_chg_aed06_1,
                                               axk12=axk12+l_aed.aed07,
                                               axk13=axk13+l_aed.aed08,
                                               axk16=l_axk16,            
                                               axk17=l_axk17,
                                              #axk18=l_axk18+l_aed.aed05,  #FUN-A30079  #MOD-A70091 mark            
                                              #axk19=l_axk19+l_aed.aed06,  #FUN-A30079  #MOD-A70091 mark 
                                              #axk20=l_axk20+l_chg_aed05,  #FUN-A30079  #MOD-A70091 mark             
                                              #axk21=l_axk21+l_chg_aed06   #FUN-A30079  #MOD-A70091 mark             
                                               axk18=axk18+l_aed.aed05,                 #MOD-A70091              
                                               axk19=axk19+l_aed.aed06,                 #MOD-A70091
                                               axk20=axk20+l_chg_aed05,                 #MOD-A70091
                                               axk21=axk21+l_chg_aed06                  #MOD-A70091
                            WHERE axk00 = g_aaz641  
                              AND axk01 = g_dept[i].axa01
                            AND axk02 = g_dept[i].axa02 #FUN-A30064
                          #    AND axk02 = tm.axa02        #FUN-A30064
                              AND axk03 = g_dept[i].axa03
                              AND axk04 = g_dept[i].axb04
                              AND axk041= g_dept[i].axb05
                              AND axk05 = l_aed.aed01
                              AND axk06 = l_aed.aed011
                              AND axk07 = l_aed.aed02
                              AND axk08 = l_aed.aed03
                              AND axk09 = l_aed.aed04
                              AND axk14 = l_axz06
                              AND axk15 = tm.ver           
                              #AND axk22 = g_aek.aek19   #luttb 110804
                        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                           CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
                           LET g_success = 'N' 
                           CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                        END IF
                     ELSE
                        IF STATUS THEN 
                           CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
                           CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1) 
                           LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04      
                           CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                
                           LET g_success = 'N'
                           CONTINUE FOREACH       
                        END IF
                     END IF                          
#---------------FUN-A60038 mark------------------------
#                      ELSE       #找不到axr資料時以aed資料寫入axk_file
#                            IF l_aag04='1' THEN #1.BS 2.IS
#                                LET l_bs_yy=l_aed.aed03
#                                LET l_bs_mm=tm.em
#                            ELSE
#                                LET l_bs_yy=l_aed.aed03
#                                LET l_bs_mm=l_aed.aed04
#                            END IF
#                            IF g_dept[i].axa02 != g_dept[i].axb04 THEN
#                                #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                                IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                                #功能幣別匯率
#                                    CALL p001_getrate(l_axe.axe11,l_bs_yy,l_bs_mm,
#                                                      l_axz.axz06,l_axz.axz07)   #MOD-780115
#                                    RETURNING l_rate
#                                    IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                                END IF
#  
#                                #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                                IF l_axz.axz07 != x_aaa03 THEN
#                                   #記帳幣別匯率
#                                   CALL p001_getrate(l_axe.axe12,l_bs_yy,l_bs_mm,
#                                                     l_axz.axz07,x_aaa03)
#                                   RETURNING l_rate1
#                                   IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                                END IF
#                            END IF
#                            #->幣別轉換
#                            LET l_chg_aed05  = l_aed.aed05 * l_rate   #下層公司功能幣借方金額
#                            LET l_chg_aed06  = l_aed.aed06 * l_rate   #下層公司功能幣貸方金額
#                            LET l_chg_aed05_1= l_chg_aed05 * l_rate1  #上層公司記帳幣借方金額
#                            LET l_chg_aed06_1= l_chg_aed06 * l_rate1  #上層公司記帳幣貸方金額
#                           
#                            SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
#                            IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                            SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                            IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                            
#                            LET l_aed.aed01=l_axe06
#                            #->幣別轉換及取位
#                            LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                            LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                            LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                            LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                            IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                            IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                            
#                            LET l_axk16 = l_rate      #FUN-960003 add
#                            LET l_axk17 = l_rate1     #FUN-960003 add
#                            
#                            INSERT INTO axk_file 
#                             (axk00,axk01,axk02,axk03,axk04,axk041,  
#                              axk05,axk06,axk07,axk08,axk09,axk10,
#                              axk11,axk12,axk13,axk14,axk15,  #FUN-580063   
#                              axk16,axk17,
#                              axk18,axk19,axk20,axk21)  #FUN-A30079 add                                  
#                             VALUES 
#                              (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,   
#                               g_dept[i].axa03,   #FUN-5A0020
#                               g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
#                               l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                               l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                               l_aed.aed07,l_aed.aed08,l_axz06,  
#                               tm.ver,                                        
#                               l_axk16,l_axk17,
#                               l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079                               
#                            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                               UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
#                                                      axk11=axk11+l_chg_aed06_1,
#                                                      axk12=axk12+l_aed.aed07,
#                                                      axk13=axk13+l_aed.aed08,
#                                                      axk16=l_axk16,             
#                                                      axk17=l_axk17,
#                                                      axk18=axk18+l_aed.aed05,  #FUN-A30079
#                                                      axk19=axk19+l_aed.aed06,  #FUN-A30079
#                                                      axk20=axk20+l_chg_aed05,  #FUN-A30079
#                                                      axa21=axk21+l_chg_aed06   #FUN-A30079             
#                                   WHERE axk00 = g_aaz641  
#                                     AND axk01 = g_dept[i].axa01
#    #                                AND axk02 = g_dept[i].axa02 #FUN-A30064
#                                     AND axk02 = tm.axa02        #FUN-A30064
#                                     AND axk03 = g_dept[i].axa03
#                                     AND axk04 = g_dept[i].axb04
#                                     AND axk041= g_dept[i].axb05
#                                     AND axk05 = l_aed.aed01
#                                     AND axk06 = l_aed.aed011
#                                     AND axk07 = l_aed.aed02
#                                     AND axk08 = l_aed.aed03
#                                     AND axk09 = l_aed.aed04
#                                     AND axk14 = l_axz06
#                                     AND axk15 = tm.ver          
#                               #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                                  CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
#                                  LET g_success = 'N' 
#                                  CONTINUE FOREACH       
#                               END IF
#                            ELSE
#                               IF STATUS THEN 
#                                  CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
#                                  CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1)  
#                                  LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04        
#                                  CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                    
#                                  LET g_success = 'N'
#                                  CONTINUE FOREACH       
#                               END IF
#                            END IF    
#                        END IF  
#                  ELSE    #(axe11,axe12 <> '2')
#                      IF l_aag04='1' THEN #1.BS 2.IS
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=tm.em
#                      ELSE
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=l_aed.aed04
#                      END IF
#                      IF g_dept[i].axa02 != g_dept[i].axb04 THEN
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                            #功能幣別匯率
#                            CALL p001_getrate(l_axe.axe11,l_bs_yy,l_bs_mm,
#                                              l_axz.axz06,l_axz.axz07)   #MOD-780115
#                                 RETURNING l_rate
#                                 IF cl_null(l_rate) THEN LET l_rate= 1 END IF #FUN-970046 
#                         END IF
#                      
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz07 != x_aaa03 THEN
#                            #記帳幣別匯率
#                            CALL p001_getrate(l_axe.axe12,l_bs_yy,l_bs_mm,
#                                              l_axz.axz07,x_aaa03)
#                                 RETURNING l_rate1
#                                 IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                         END IF
#                      END IF
#                      #->幣別轉換
#                      LET l_chg_aed05  = l_aed.aed05 * l_rate   #下層公司功能幣借方金額 
#                      LET l_chg_aed06  = l_aed.aed06 * l_rate   #下層公司功能幣貸方金額
#                      LET l_chg_aed05_1= l_chg_aed05 * l_rate1  #上層公司記帳幣借方金額
#                      LET l_chg_aed06_1= l_chg_aed06 * l_rate1  #上層公司記帳幣貸方金額
#
#                      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
#                      IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                      SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                      IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                      
#                      LET l_aed.aed01=l_axe06
#                      #->幣別轉換及取位
#                      LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                      LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                      LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                      LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                      IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                      IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                      
#                      LET l_axk16 = l_rate      #FUN-960003 add
#                      LET l_axk17 = l_rate1     #FUN-960003 add
#                      
#                      INSERT INTO axk_file 
#                       (axk00,axk01,axk02,axk03,axk04,axk041,   #No:MOD-470041
#                        axk05,axk06,axk07,axk08,axk09,axk10,
#                        axk11,axk12,axk13,axk14,axk15,  #FUN-580063   #FUN-750078 add axk15
#                        axk16,axk17,                                  #FUN-970046 add
#                        axk18,axk19,axk20,axk21)                      #FUN-A30079
#                       VALUES 
#                        (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,   #FUN-920067
#                         g_dept[i].axa03,   #FUN-5A0020
#                         g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
#                         l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                         l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                         l_aed.aed07,l_aed.aed08,l_axz06,  #FUN-580063 3.將上層公司記帳幣別存入axk14
#                         tm.ver,                                        #FUN-750078 add tm.ver 
#                         l_axk16,l_axk17,                               #FUN-970046 add 
#                         l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079
#                      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                         UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
#                                                axk11=axk11+l_chg_aed06_1,
#                                                axk12=axk12+l_aed.aed07,
#                                                axk13=axk13+l_aed.aed08,
#                                                axk16=l_axk16,             #FUN-970046 add
#                                                axk17=l_axk17,             #FUN-970046 add
#                                                axk18=axk18+l_aed.aed05,   #FUN-A30079 add
#                                                axk19=axk19+l_aed.aed06,   #FUN-A30079 add
#                                                axk20=axk20+l_chg_aed05,   #FUN-A30079 add
#                                                axk21=axk21+l_chg_aed06    #FUN-A30079 add
#                             WHERE axk00 = g_aaz641  
#                               AND axk01 = g_dept[i].axa01
##                              AND axk02 = g_dept[i].axa02 #FUN-A30064
#                               AND axk02 = tm.axa02        #FUN-A30064
#                               AND axk03 = g_dept[i].axa03
#                               AND axk04 = g_dept[i].axb04
#                               AND axk041= g_dept[i].axb05
#                               AND axk05 = l_aed.aed01
#                               AND axk06 = l_aed.aed011
#                               AND axk07 = l_aed.aed02
#                               AND axk08 = l_aed.aed03
#                               AND axk09 = l_aed.aed04
#                               AND axk14 = l_axz06
#                               AND axk15 = tm.ver           #MOD-930135
#                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                            CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
#                            LET g_success = 'N' 
#                            CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                         END IF
#                      ELSE
#                         IF STATUS THEN 
#                            CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
#                            CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1)  #No.FUN-660123 #NO.FUN-710023
#                            LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04        #NO.FUN-710023    #FUN-920067 mod
#                            CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                #NO.FUN-710023      
#                            LET g_success = 'N'
#                            CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                         END IF
#                      END IF 
#                  END IF            #FUN-970046 add
#-----------------FUN-A60038 mark------------------------------------
#                     END FOREACH            #FUN-A90026 mark
#                 END IF       #FUN-A90006   #FUN-A90026 mark
                END FOREACH
              
#---FUN-A90026 mark----start---------------------------------------
#              #-----FUN-970046 start---再加處理一段aag04 = '1'的寫入-------
#              LET l_sql=" SELECT aed01,aed011,aed02,aed03,'',",
#                        " SUM(aed05),SUM(aed06),SUM(aed07),SUM(aed08) ",
#                        " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
#                        " WHERE aed03=",tm.yy,
#                        " AND aed04 BETWEEN ",tm.bm," AND ",tm.em,
#                        " AND aed00='",g_dept[i].axb05,"' AND aed011='99' ", 
#                        " AND aed01 = aag01 ",
#                        " AND aed00 = aag00 ",
#                        " AND aag07 IN ('2','3') ",
#                        " AND aag04 = '1'",                             
#                        " AND aag09 = 'Y' ",
#                        " AND aag01 <> '",g_aaz113,"'",          #FUN-A30079 排除本期損益-IS科目
#                        " GROUP BY aed01,aed011,aed02,aed03,aed04",
#                        " ORDER BY aed01 "
#
#	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
#              PREPARE p001_aed_p1 FROM l_sql
#              IF STATUS THEN
#                  LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
#                  CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#              END IF
#              DECLARE p001_aed_c1 CURSOR FOR p001_aed_p1
#              FOREACH p001_aed_c1 INTO l_aed.*
#                  IF SQLCA.SQLCODE THEN 
#                     LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
#                     CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                  END IF
#                  IF l_aed.aed05 =0 AND l_aed.aed06=0 THEN CONTINUE FOREACH END IF
#                  
#                  LET l_aed.aed04 = tm.em
#                  LET l_axe.axe11 = '1'
#                  LET l_axe.axe12 = '1'
#                  #抓取下層公司的科目的合併財報科目編號(axe06),
#                  #再衡量匯率類別(axe11),換算匯率類別(axe12),
#                  #以判斷後續轉換幣別時,要用那種匯率計算
#                  SELECT axe06,axe11,axe12 INTO l_axe.* FROM axe_file   
#                   WHERE axe01 = g_dept[i].axb04 AND axe04 = l_aed.aed01
#                     AND axe00 = g_dept[i].axb05  
#                     AND axe13 = tm.axa01          
#                  IF STATUS  THEN                   
#                     LET g_showmsg=g_dept[i].axb04,"/",l_aed.aed01 
#                      CALL s_errmsg('axe01,axe04',g_showmsg,l_aed.aed01,'aap-021',1)              
#                      LET g_success = 'N'
#                      CONTINUE FOREACH   
#                  END IF
#                  LET l_axe06 = l_axe.axe06
#
#                  #--取總帳借貸方異動額---
#                  #-------- FUN-A60038 start----------
#                  IF l_axe.axe06 = g_aaz114 THEN
#                      LET l_sql=
#                            " SELECT aed05,aed06 ",
#                            " FROM ",g_dbs_gl,"aed_file",
#                            " WHERE aed03=",tm.yy,
#                            " AND aed04 = ",tm.em,
#                            " AND aed00='",g_dept[i].axb05,"' AND aed011='99' ", 
#                            " AND aag01='",g_aaz114,"'",
#                            " AND aed02='",l_aed.aed02,"'"   #FUN-A80130
#                          
#	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
#                      PREPARE p001_aed_p3 FROM l_sql
#                      IF STATUS THEN
#                         LET g_showmsg=tm.yy,"/",g_dept[i].axb05     
#                         CALL s_errmsg('aed00,aed01',g_showmsg,'prepare:p001_aed_p3',STATUS,1) 
#                         LET g_success = 'N'
#                         CONTINUE FOR                                 
#                      END IF
#                      LET l_aed05 = 0   #FUN-A90006
#                      LET l_aed06 = 0   #FUN-A90006
#                      DECLARE p001_aed_c3 SCROLL CURSOR FOR p001_aed_p3
#                      OPEN p001_aed_c3
#                      FETCH p001_aed_c3 INTO l_aed05,l_aed06
#                      CLOSE p001_aed_c3
#                  END IF
#                  #-------FUN-A60038 end----------------------
#                  #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
#                  #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
#                  #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
#                  #  乘上匯率逐一算出借貸方記帳金額(axg08,axg09 OR axk10,axk11)
#                  SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
#                  IF SQLCA.sqlcode THEN
#                     CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)                            
#                     LET g_success = 'N'
#                     CONTINUE FOREACH     
#                  END IF
#                  LET l_aag04=''
#                  LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
#                              " WHERE aag00='",g_dept[i].axb05,"'", #帳別
#                              "   AND aag01='",l_aed.aed01,"'" #科目
#	                CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
#                  PREPARE p001_pre_13 FROM g_sql
#                  DECLARE p001_cur_13 CURSOR FOR p001_pre_13
#                  OPEN p001_cur_13
#                  FETCH p001_cur_13 INTO l_aag04
#                  CLOSE p001_cur_13
#                  IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
#
#                  #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
#                  LET l_rate  = 1
#                  LET l_rate1 = 1
#                  #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
#                  #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                  #一一換算後再加總起來
#
#                  #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
#                  #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-A60038 mark
#                  LET l_chg_aed05_1=0
#                  LET l_chg_aed06_1=0
#                  LET l_chg_aed05=0
#                  LET l_chg_aed06=0
#                  LET l_chg_aed05_a=0
#                  LET l_chg_aed06_a=0
#
#                  #---FUN-A60038 start---
#                  LET l_chg_dr = 0 
#                  LET l_chg_cr = 0
#                  LET l_fun_dr = 0 
#                  LET l_fun_cr = 0 
#                  LET l_acc_dr = 0 
#                  LET l_acc_cr = 0
#                  #---FUN-A60038 end-----
#
#                  LET l_dr = 0    #FUN-A70053
#                  LET l_cr = 0    #FUN-A70053
#
#                  #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
#                  #--現時匯率---
#                  IF l_axe.axe11='1' THEN 
#                      CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                        l_axe.axe11,l_axz.axz06,
#                                        l_axz.axz07,l_aed.aed03,l_aed.aed04)
#                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                  END IF
#
#                  #--歷史匯率---
#                  IF l_axe.axe11='2' THEN  
#                      IF ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN
#                          #----如果agli011抓不到資料，則依科目餘額計算---- 
#                          DECLARE p001_cnt_cs27 CURSOR FOR p001_axr_p2
#                          OPEN p001_cnt_cs27
#                          USING g_dept[i].axa01,g_dept[i].axb04,
#                                l_aed.aed01,l_axe.axe06,g_date_e 
#                          FETCH p001_cnt_cs27 INTO l_axr_count
#                          CLOSE p001_cnt_cs27
#                          IF l_axr_count > 0 THEN   
#                              CALL p001_axr(i,l_aed.aed01,l_axe.axe06,g_date_e)   #FUN-A60038 add
#                              #--FUN-A70086 start--
#                              #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                              RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                              #LET l_fun_dr = l_chg_dr
#                              #LET l_fun_cr = l_chg_cr
#                              #LET l_acc_dr = l_chg_dr
#                              #LET l_acc_cr = l_chg_cr
#                              #--FUN-A70086 end----
#                          ELSE
#                              #--取不到agli011時一樣用匯率換算---
#                              CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                                l_axe.axe11,l_axz.axz06,
#                                                l_axz.axz07,l_aed.aed03,l_aed.aed04)
#                              RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                          END IF
#                      ELSE
#                          CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                            l_axe.axe11,l_axz.axz06,
#                                            l_axz.axz07,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                      END IF
#                  END IF
#       
#                  #--平均匯率---
#                  IF l_axe.axe11='3' THEN
#                      #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                      #例:截止期別=3,則要按1月異動額*平均匯率+2月異動*匯率+3月異動額*匯率
#                          IF l_axe.axe06 = g_aaz114  THEN  
#                          CALL p001_fun_axk_avg('1',l_axe.axe06,l_aed.aed02,      #FUN-A90006
#                                                 l_aag04,
#                                                 l_axz.axz06,l_axz.axz07,i,
#                                                 l_aed05,l_aed06)
#                          RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr  #上層記帳借/貸金額  
#                      ELSE
#                          CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                            l_axe.axe11,l_axz.axz06,
#                                            l_axz.axz07,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                      END IF
#                  END IF
#
#                  #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                  #--現時匯率---
#                  IF l_axe.axe12='1' THEN 
#                      CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                        l_axe.axe12,l_axz.axz07,
#                                        x_aaa03,l_aed.aed03,l_aed.aed04)
#                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                  END IF
#
#                  #--歷史匯率---
#                  IF l_axe.axe12 = '2' THEN  
#                      IF ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN
#                          #----如果agli011抓不到資料，則依科目餘額計算---- 
#                          DECLARE p001_cnt_cs28 CURSOR FOR p001_axr_p2
#                          OPEN p001_cnt_cs28
#                          USING g_dept[i].axa01,g_dept[i].axb04,
#                               l_aed.aed01,l_axe.axe06,g_date_e  
#                          FETCH p001_cnt_cs28 INTO l_axr_count
#                          CLOSE p001_cnt_cs28
#                          IF l_axr_count > 0 THEN   
#                              CALL p001_axr(i,l_aed.aed01,l_axe.axe06,g_date_e)   #FUN-A60038 add
#                              #--FUN-A70086 start--
#                              #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                              RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                              #LET l_fun_dr = l_chg_dr
#                              #LET l_fun_cr = l_chg_cr
#                              #LET l_acc_dr = l_chg_dr
#                              #LET l_acc_cr = l_chg_cr
#                              #--FUN-A70086 end----
#                          ELSE
#                              #--取不到agli011時一樣用匯率換算---
#                              CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                                l_axe.axe12,l_axz.axz07,
#                                                x_aaa03,l_aed.aed03,l_aed.aed04)
#                              RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                          END IF
#                      ELSE
#                          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                            l_axe.axe12,l_axz.axz07,
#                                            x_aaa03,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                      END IF
#                  END IF
#       
#                  #--平均匯率---
#                  IF l_axe.axe12='3' THEN 
#                      #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                      #例:截止期別=3,則要按1月異動額*平均匯率+2月異動*匯率+3月異動額*匯率
#                      IF l_axe.axe06 = g_aaz114 THEN  #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                          IF cl_null(l_dr) THEN LET l_dr = l_fun_dr END IF   #FUN-A70053
#                          IF cl_null(l_cr) THEN LET l_cr = l_fun_cr END IF   #FUN-A70053
#                          #--MOD-A80102 start---
#                          #CALL p001_avg('2',g_dbs_gl,l_aed.aed01,  #FUN-A80130 mark
#                          CALL p001_axk_avg('2',g_dbs_gl,l_axe.axe06,l_aed.aed02,  #FUN-A80130 add
#                                            g_dept[i].axb05,l_aag04,              #FUN-A90006
#                                            l_axz.axz06,l_axz.axz07,i,
#                                            l_dr,l_cr)
#                          RETURNING l_acc_dr,l_acc_cr  
#                      ELSE
#                          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                            l_axe.axe12,l_axz.axz07,
#                                            x_aaa03,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                      END IF
#                  END IF
#                  #-------FUN-A60038 end-----------------------------------
#
#----------FUN-A90026 mark--end--------------------------------------------


#----------FUN-A60038 mark 移至p001_axr()---------------------------
#                      DECLARE p001_cnt_cs8 CURSOR FOR p001_axr_p2
#                      OPEN p001_cnt_cs8
#                      USING g_dept[i].axa01,g_dept[i].axb04,
#                            l_aed.aed01,l_axe.axe06,g_date_e 
#                      FETCH p001_cnt_cs8 INTO l_axr_count
#                      IF l_axr_count > 0 THEN
#                         DECLARE p001_axr_cs8 CURSOR FOR p001_axr_p
#                         OPEN p001_axr_cs8                       
#                         USING g_dept[i].axa01,g_dept[i].axb04,
#                               l_aed.aed01,l_axe.axe06,g_date_e    
#                         FETCH p001_axr_cs8              
#                         INTO l_aag06,l_axr13           #FUN-990020 mark
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                             #功能幣別匯率
#                             CALL p001_getrate(l_axe.axe11,l_axr08,l_axr09,
#                                               l_axz.axz06,l_axz.axz07)  
#                             RETURNING l_rate
#                             IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                         END IF
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz07 != x_aaa03 THEN
#                             #記帳幣別匯率
#                             CALL p001_getrate(l_axe.axe12,l_axr08,l_axr09,   
#                                               l_axz.axz07,x_aaa03)
#                             RETURNING l_rate1
#                             IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                         END IF
#                         IF g_dept[i].axa02=g_dept[i].axb04 THEN
#                             LET l_rate=1
#                             LET l_rate1=1
#                         END IF                     
#
#                         #->幣別轉換及取位
#                         #原本程式: IF l_axr05 > 0 段增加下列判斷式
#                         #->幣別轉換及取位
#                         IF l_axr13 > 0 THEN 
#                             IF l_aag06='1' THEN                 #正常餘額為1.借餘
#                                 LET l_chg_aed05_a=l_axr13       #功能幣別借方金額
#                                 LET l_chg_aed06_a=0                    #功能幣別貸方金額
#                             ELSE                   #正常餘額為2.貸餘
#                                 LET l_chg_aed05_a=0            #功能幣別借方金額
#                                 LET l_chg_aed06_a=l_axr13      #功能幣別貸方金額
#                             END IF
#                         ELSE
#                                 IF l_aag06='1' THEN    #正常餘額為1.借餘
#                                     LET l_chg_aed05_a=0                      #功能幣別借方金額
#                                     LET l_chg_aed06_a=(l_axr13*-1)  #功能幣別貸方金額
#                                 ELSE                   #正常餘額為2.貸餘
#                                     LET l_chg_aed05_a=(l_axr13*-1)  #功能幣別借方金額
#                                     LET l_chg_aed06_a=0                      #功能幣別貸方金額
#                                 END IF
#                         END IF
#                         LET l_chg_aed05  =l_chg_aed05   + l_chg_aed05_a                    #下層公司功能幣借方金額 
#                         LET l_chg_aed06  =l_chg_aed06   + l_chg_aed06_a                    #下層公司功能幣貸方金額
#                         LET l_chg_aed05_1=l_chg_aed05_1 + l_chg_aed05_a * l_rate1          #上層記帳幣別借方金額
#                         LET l_chg_aed06_1=l_chg_aed06_1 + l_chg_aed06_a * l_rate1          #上層記帳幣別貸方金額
#----FUN-A60038 mark----------------------------------------------------------
 
#----FUN-A90026 mark start-----
#                  #----FUN-A60038 start---                        
#                  LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
#                  LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
#                  #LET l_chg_aed05_1=l_chg_aed05_1 + l_fun_dr   #MOD-A70064
#                  #LET l_chg_aed06_1=l_chg_aed06_1 + l_fun_cr   #MOD-A70064
#                  LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
#                  LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr
#                  #---FUN-A60038 end-----
#                  
#                  SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
#                  IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                  SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                  IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                  LET l_aed.aed01=l_axe06
#
#                  #->幣別轉換及取位
#                  LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                  LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                  LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                  LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                  IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                  IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                  
#                  LET l_axk16 = l_rate      #FUN-960003 add
#                  LET l_axk17 = l_rate1     #FUN-960003 add
#
#                  INSERT INTO axk_file 
#                   (axk00,axk01,axk02,axk03,axk04,axk041,   
#                    axk05,axk06,axk07,axk08,axk09,axk10,
#                    axk11,axk12,axk13,axk14,axk15,  #FUN-580063   
#                    axk16,axk17,
#                    axk18,axk19,axk20,axk21)    #FUN-A30079                                 
#                   VALUES 
#                    (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  
#                     g_dept[i].axa03,   #FUN-5A0020
#                     g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
#                     l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                     l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                     l_aed.aed07,l_aed.aed08,l_axz06, 
#                     tm.ver,                                        
#                     l_axk16,l_axk17,
#                     l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                  IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                     UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
#                                            axk11=axk11+l_chg_aed06_1,
#                                            axk12=axk12+l_aed.aed07,
#                                            axk13=axk13+l_aed.aed08,
#                                            axk16=l_axk16,            
#                                            axk17=l_axk17,
#                                            axk18=axk18+l_aed.aed05,   #FUN-A30079
#                                            axk19=axk19+l_aed.aed06,   #FUN-A30079
#                                            axk20=axk20+l_chg_aed05,   #FUN-A30079
#                                            axk21=axk21+l_chg_aed06    #FUN-A30079           
#                         WHERE axk00 = g_aaz641  
#                           AND axk01 = g_dept[i].axa01
# #                         AND axk02 = g_dept[i].axa02 #FUN-A30064
#                           AND axk02 = tm.axa02        #FUN-A30064
#                           AND axk03 = g_dept[i].axa03
#                           AND axk04 = g_dept[i].axb04
#                           AND axk041= g_dept[i].axb05
#                           #AND axk05 = l_aed.aed01
#                           AND axk05 = l_axe.axe06    #FUN-A90006
#                           AND axk06 = l_aed.aed011
#                           AND axk07 = l_aed.aed02
#                           AND axk08 = l_aed.aed03
#                           AND axk09 = l_aed.aed04
#                           AND axk14 = l_axz06
#                           AND axk15 = tm.ver           
#                     #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                        CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
#                        LET g_success = 'N' 
#                        CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                     END IF
#                  ELSE
#                     IF STATUS THEN 
#                        CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
#                        CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1) 
#                        LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04      
#                        CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                
#                        LET g_success = 'N'
#                        CONTINUE FOREACH       
#                     END IF
#                  END IF                          
#---FUN-A90026 mark end--------------------------------------------------

#--------FUN-A60038 MARK start------------------------------------------
#                      ELSE       #找不到axr資料時以aed資料寫入axk_file
#                          IF l_aag04='1' THEN #1.BS 2.IS
#                              LET l_bs_yy=l_aed.aed03
#                              LET l_bs_mm=tm.em
#                          ELSE
#                              LET l_bs_yy=l_aed.aed03
#                              LET l_bs_mm=l_aed.aed04
#                          END IF
#                          IF g_dept[i].axa02 != g_dept[i].axb04 THEN
#                              #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                              IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                              #功能幣別匯率
#                                  CALL p001_getrate(l_axe.axe11,l_bs_yy,l_bs_mm,
#                                                    l_axz.axz06,l_axz.axz07)   #MOD-780115
#                                  RETURNING l_rate
#                                  IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                              END IF
#  
#                              #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                              IF l_axz.axz07 != x_aaa03 THEN
#                                 #記帳幣別匯率
#                                 CALL p001_getrate(l_axe.axe12,l_bs_yy,l_bs_mm,
#                                                   l_axz.axz07,x_aaa03)
#                                 RETURNING l_rate1
#                                 IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                              END IF
#                          END IF
#                          #->幣別轉換
#                          LET l_chg_aed05  = l_aed.aed05 * l_rate    #下層功能幣借方金額
#                          LET l_chg_aed06  = l_aed.aed06 * l_rate    #下層功能幣貸方金額 
#                          LET l_chg_aed05_1= l_chg_aed05 * l_rate1   #上層記帳幣借方金額
#                          LET l_chg_aed06_1= l_chg_aed06 * l_rate1   #上層記帳幣貸方金額
#                          
#                          SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
#                          IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                          SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                          IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                          
#                          LET l_aed.aed01=l_axe06
#                          #->幣別轉換及取位
#                          LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                          LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                          LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                          LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                          IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                          IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                          
#                          LET l_axk16 = l_rate      #FUN-960003 add
#                          LET l_axk17 = l_rate1     #FUN-960003 add
#                          
#                          INSERT INTO axk_file 
#                           (axk00,axk01,axk02,axk03,axk04,axk041,  
#                            axk05,axk06,axk07,axk08,axk09,axk10,
#                            axk11,axk12,axk13,axk14,axk15,  #FUN-580063   
#                            axk16,axk17,
#                            axk18,axk19,axk20,axk21)        #FUN-A30079                                  
#                           VALUES 
#                            (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,   
#                             g_dept[i].axa03,   #FUN-5A0020
#                             g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
#                             l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                             l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                             l_aed.aed07,l_aed.aed08,l_axz06,  
#                             tm.ver,                                        
#                             l_axk16,l_axk17,
#                             l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                             UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
#                                                    axk11=axk11+l_chg_aed06_1,
#                                                    axk12=axk12+l_aed.aed07,
#                                                    axk13=axk13+l_aed.aed08,
#                                                    axk16=l_axk16,             
#                                                    axk17=l_axk17,
#                                                    axk18=axk18+l_aed.aed05,   #FUN-A30079              
#                                                    axk19=axk19+l_aed.aed06,   #FUN-A30079              
#                                                    axk20=axk20+l_chg_aed05,   #FUN-A30079              
#                                                    axk21=axk21+l_chg_aed06    #FUN-A30079              
#                                 WHERE axk00 = g_aaz641  
#                                   AND axk01 = g_dept[i].axa01
#    #                              AND axk02 = g_dept[i].axa02 #FUN-A30064
#                                   AND axk02 = tm.axa02        #FUN-A30064
#                                   AND axk03 = g_dept[i].axa03
#                                   AND axk04 = g_dept[i].axb04
#                                   AND axk041= g_dept[i].axb05
#                                   AND axk05 = l_aed.aed01
#                                   AND axk06 = l_aed.aed011
#                                   AND axk07 = l_aed.aed02
#                                   AND axk08 = l_aed.aed03
#                                   AND axk09 = l_aed.aed04
#                                   AND axk14 = l_axz06
#                                   AND axk15 = tm.ver          
#                             #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                                CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
#                                LET g_success = 'N' 
#                                CONTINUE FOREACH       
#                             END IF
#                          ELSE
#                             IF STATUS THEN 
#                                CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
#                                CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1)  
#                                LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04        
#                                CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                    
#                                LET g_success = 'N'
#                                CONTINUE FOREACH       
#                             END IF
#                          END IF    
#                      END IF  
#                  ELSE    #(axe11,axe12 <> '2')
#                      IF l_aag04='1' THEN #1.BS 2.IS
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=tm.em
#                      ELSE
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=l_aed.aed04
#                      END IF
#                      IF g_dept[i].axa02 != g_dept[i].axb04 THEN
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz06 != l_axz.axz07 THEN   #MOD-780115
#                            #功能幣別匯率
#                            CALL p001_getrate(l_axe.axe11,l_bs_yy,l_bs_mm,
#                                              l_axz.axz06,l_axz.axz07)   #MOD-780115
#                                 RETURNING l_rate
#                                 IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                         END IF
#                      
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_axz.axz07 != x_aaa03 THEN
#                            #記帳幣別匯率
#                            CALL p001_getrate(l_axe.axe12,l_bs_yy,l_bs_mm,
#                                              l_axz.axz07,x_aaa03)
#                                 RETURNING l_rate1
#                                 IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                         END IF
#                      END IF
#                      #->幣別轉換
#                      LET l_chg_aed05  = l_aed.aed05 * l_rate   #下層功能幣借方
#                      LET l_chg_aed06  = l_aed.aed06 * l_rate   #下層功能幣貸方
#                      LET l_chg_aed05_1= l_chg_aed05 * l_rate1  #上層記帳幣借方
#                      LET l_chg_aed06_1= l_chg_aed06 * l_rate1  #上層記帳幣貸方
#
#                      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06   #FUN-920167 記帳幣別
#                      IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                      SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                      IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                      
#                      LET l_aed.aed01=l_axe06
#                      #->幣別轉換及取位
#                      LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                      LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                      LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                      LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                      IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                      IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                      
#                      LET l_axk16 = l_rate      #FUN-960003 add
#                      LET l_axk17 = l_rate1     #FUN-960003 add
#                      
#                      INSERT INTO axk_file 
#                       (axk00,axk01,axk02,axk03,axk04,axk041,   #No:MOD-470041
#                        axk05,axk06,axk07,axk08,axk09,axk10,
#                        axk11,axk12,axk13,axk14,axk15,  #FUN-580063   #FUN-750078 add axk15
#                        axk16,axk17,                                  #FUN-970046 add
#                        axk18,axk19,axk20,axk21)                      #FUN-A30079
#                       VALUES 
#                        (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,   #FUN-920067
#                         g_dept[i].axa03,   #FUN-5A0020
#                         g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
#                         l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                         l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                         l_aed.aed07,l_aed.aed08,l_axz06,  #FUN-580063 3.將上層公司記帳幣別存入axk14
#                         tm.ver,                                       
#                         l_axk16,l_axk17,
#                         l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                         UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
#                                                axk11=axk11+l_chg_aed06_1,
#                                                axk12=axk12+l_aed.aed07,
#                                                axk13=axk13+l_aed.aed08,
#                                                axk16=l_axk16,             
#                                                axk17=l_axk17,
#                                                axk18=axk18+l_aed.aed05,  #FUN-A30079
#                                                axk19=axk19+l_aed.aed06,  #FUN-A30079
#                                                axk20=axk20+l_chg_aed05,  #FUN-A30079
#                                                axk21=axk21+l_chg_aed06   #FUN-A30079
#                             WHERE axk00 = g_aaz641  
#                               AND axk01 = g_dept[i].axa01
##                              AND axk02 = g_dept[i].axa02 #FUN-A30064
#                               AND axk02 = tm.axa02        #FUN-A30064
#                               AND axk03 = g_dept[i].axa03
#                               AND axk04 = g_dept[i].axb04
#                               AND axk041= g_dept[i].axb05
#                               AND axk05 = l_aed.aed01
#                               AND axk06 = l_aed.aed011
#                               AND axk07 = l_aed.aed02
#                               AND axk08 = l_aed.aed03
#                               AND axk09 = l_aed.aed04
#                               AND axk14 = l_axz06
#                               AND axk15 = tm.ver          
#                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                            CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
#                            LET g_success = 'N' 
#                            CONTINUE FOREACH    
#                         END IF
#                      ELSE
#                         IF STATUS THEN 
#                            CALL cl_err('ins_axk',status,1)   #FUN-5A0020   #No.FUN-660123
#                            CALL cl_err3("ins","axk_file",g_dept[i].axa01,g_dept[i].axa02,status,"","ins_axk",1) 
#                            LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04       
#                            CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)               
#                            LET g_success = 'N'
#                            CONTINUE FOREACH    
#                         END IF
#                      END IF 
#                  END IF     
#-------------------FUN-A60038 mark end------------------------------
                #END FOREACH    #FUN-A90026 mark

#--FUN-A90026 mark---start------
#               LET l_sql=" SELECT *",
#                         " FROM ",g_dbs_gl,"aedd_file,",g_dbs_gl,"aag_file ",
#                         " WHERE aedd03=",tm.yy,
#                         " AND aedd04 ='",tm.em,"'",
#                         " AND aedd00='",g_dept[i].axb05,"'",
#                         " AND aedd01 = aag01 ",
#                         " AND aedd00 = aag00 ",
#                         " AND aag07 IN ('2','3') ",
#                         " AND aag04 <> '1'",
#                         " AND aag09 = 'Y' ",
#                         " AND aag01 <> '",g_aaz113,"'"    #FUN-A70086
#-FUN-A90026 mark end-------------

                #--FUN-A90026 start----
                LET l_sql=" SELECT aem04,aem05,aem06,aem07,aem08,aem09,",
                          "        SUM(aem11),SUM(aem12),SUM(aem13),SUM(aem14)",
                          "   FROM aem_file ",
                          "  WHERE aem09 =",tm.yy,
                          "    AND aem10 BETWEEN ",tm.bm," AND ",tm.em,
                          "    AND aem00='",g_aaz641,"'",
                          "    AND aem01='",g_dept[i].axa01,"'",
                          "    AND aem02='",g_dept[i].axb04,"'",
                          "  GROUP BY aem04,aem05,aem06,aem07,aem08,aem09 ",
                          "  ORDER BY aem04,aem05,aem06,aem07,aem08 "
                #--FUN-A90026 end--------

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
                PREPARE p001_aei_p1 FROM l_sql
                IF STATUS THEN
                   #LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                   LET g_showmsg=tm.yy,"/",g_dept[i].axb04    #FUN-A90026
                   #CALL s_errmsg('aedd03,aedd00',g_showmsg,'prepare:aei_p1',STATUS,1) LET g_success='N' CONTINUE FOR  #FUN-A90026 mark
                   CALL s_errmsg('aem09,aem02',g_showmsg,'prepare:aei_p1',STATUS,1) LET g_success='N' CONTINUE FOR     #FUN-A90026 mod
                END IF
                DECLARE p001_aei_c1 CURSOR FOR p001_aei_p1
                #FOREACH p001_aei_c1 INTO l_aedd.*
                FOREACH p001_aei_c1 INTO g_aem.*      #FUN-A90026 mod
                    IF SQLCA.SQLCODE THEN
                       #LET g_showmsg=tm.yy,"/",g_dept[i].axb05   #FUN-A90026 mark
                       LET g_showmsg=tm.yy,"/",g_dept[i].axb04    #FUN-A90026 add
                       #CALL s_errmsg('aedd03,aedd00',g_showmsg,'prepare:aei_c1',STATUS,1) LET g_success='N' CONTINUE FOR  #FUN-A90026 mark
                       CALL s_errmsg('aem09,aem02',g_showmsg,'foreach:aei_c1',STATUS,1) LET g_success ='N' CONTINUE FOR    #FUN-A90026 mark
                    END IF
                    #IF l_aedd.aedd05 =0 AND l_aedd.aedd06=0 THEN CONTINUE FOREACH END IF   #FUN-A90026 mark
                    IF g_aem.aem11 =0 AND g_aem.aem12=0 THEN CONTINUE FOREACH END IF        #FUN-A90026 add
                    #LET l_axe.axe06 = l_aedd.aedd01   #FUN-A90026 mark
                    LET l_axe.axe11 = '1'
                    LET l_axe.axe12 = '1'
                    #抓取下層公司的科目的合并財報科目編號(axe06),
                    #再衡量匯率類別(axe11),換算匯率類別(axe12),
                    #以判斷后續轉換幣別時,要用那種匯率計算
#-----------FUN-A90026 mark----------
#                    SELECT axe06,axe11,axe12 INTO l_axe.* FROM axe_file
#                     #WHERE axe01 = g_dept[i].axb04 AND axe04 = l_aedd.aedd01 #FUN-A90026 mark
#                     WHERE axe01 = g_dept[i].axb04 AND axe06 = g_aem.aem04    #FUN-A90026 mod
#                       AND axe00 = g_dept[i].axb05   
#                       AND axe13 = tm.axa01         
#-----------FUN-A90026 mark
                    #---FUN-A90026 start----
                    LET l_sql = 
                    #" SELECT axe11,axe12 FROM axe_file ",
                    " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
                    "  WHERE axe01 = '",g_dept[i].axb04,"'",
                    "    AND axe06 = '",g_aem.aem04,"'",
                    "    AND axe00 = '",g_dept[i].axb05,"'", 
                    "    AND axe13 = '",tm.axa01,"'"   
                    PREPARE p001_axe_p3 FROM l_sql
                    DECLARE p001_axe_c3 SCROLL CURSOR FOR p001_axe_p3
                    OPEN p001_axe_c3 
                    FETCH FIRST p001_axe_c3 INTO l_axe.*
                    CLOSE p001_axe_c3
                    #---FUN-A90026 end--------

                    IF STATUS  THEN
                       #LET g_showmsg=g_dept[i].axb04,"/",l_aedd.aedd01
                       LET g_showmsg=g_dept[i].axb04,"/",g_aem.aem04          #FUN-A90026 mod
                       #CALL s_errmsg('axe01,axe04',g_showmsg,l_aedd.aedd01,'aap-021',1)
                       CALL s_errmsg('axe01,axe06',g_showmsg,'','aap-021',1)  #FUN-A90026 mod      
                       LET g_success = 'N'
                       CONTINUE FOREACH       
                    END IF
#                    LET l_axe06 = l_axe.axe06     #FUN-A90026 mark
                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
                    #  乘上匯率逐一算出借貸方記賬金額(aei10,aei11)
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH     
                    END IF
                    LET l_aag04=''
                    LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
                                " WHERE aag00='",g_dept[i].axb05,"'", #帳別
                                #"   and aag01='",l_aedd.aedd01,"'" #科目
                                "   and aag01='",g_aem.aem04,"'" #科目    #FUN-A90026
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    PREPARE p001_aei_p2 FROM g_sql
                    DECLARE p001_aei_c2 CURSOR FOR p001_aei_p2
                    OPEN p001_aei_c2
                    FETCH p001_aei_c2 INTO l_aag04
                    CLOSE p001_aei_c2
                    IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
                    #當上層公司不等于下層公司時,才需要抓匯率來計算,否則匯率用1來計
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記賬幣別金額(小于等于本期),
                    #一一換算后再加總起來

                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 !=g_dept[i].axb04 ) THEN  #FUN-A60038 MARK
#-----------------FUN-A90026 mark--
#                   LET l_chg_aedd05_1=0
#                   LET l_chg_aedd06_1=0
#                   LET l_chg_aedd05=0
#                   LET l_chg_aedd06=0
#                   LET l_chg_aedd05_a=0
#                   LET l_chg_aedd06_a=0
#----------------FUN-A90026 mark---------
                    #--FUN-A90026 start----
                    LET l_chg_aem11_1=0
                    LET l_chg_aem12_1=0
                    LET l_chg_aem11=0
                    LET l_chg_aem12=0
                    LET l_chg_aem11_a=0
                    LET l_chg_aem12_a=0
                    #---FUN-A60038 start---
                    LET l_chg_dr = 0 
                    LET l_chg_cr = 0
                    LET l_fun_dr = 0 
                    LET l_fun_cr = 0 
                    LET l_acc_dr = 0 
                    LET l_acc_cr = 0
                    #---FUN-A60038 end-----
                    LET l_dr = 0   #MOD-A80102
                    LET l_cr = 0   #MOD-A80102

                    #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                    #--現時匯率---
                    IF l_axe.axe11='1' THEN 
                        #---FUN-A90026 mark----
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #                  l_axe.axe11,l_axz.axz06,
                        #                  l_axz.axz07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark---
                        #--FUN-A90026 start--
                        CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,g_aem.aem09,tm.em)
                        #--FUN-A90026 end---- 
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs29 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs29
                        USING g_dept[i].axa01,g_dept[i].axb04,
                             #l_aedd.aedd01,l_axe.axe06,g_date_e   #FUN-A90026 mark
                             g_aem.aem04,g_date_e      #FUN-A90026 mod
                        FETCH p001_cnt_cs29 INTO l_axr_count
                        CLOSE p001_cnt_cs29
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,l_aedd.aedd01,l_axe.axe06,g_date_e)  #FUN-A90026 mark
                            #CALL p001_axr(i,g_aem.aem04,g_date_e)     #FUN-A90026 mod
                            CALL p001_axr(i,l_axe.axe04,g_aem.aem04,g_date_e)     #FUN-A90026 mod #TQC-AA0098
                            #--FUN-A70086 start--
                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            #LET l_fun_dr = l_chg_dr
                            #LET l_fun_cr = l_chg_cr
                            #LET l_acc_dr = l_chg_dr
                            #LET l_acc_cr = l_chg_cr
                            #--FUN-A70086 end----
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            #--FUN-A90026 mark---
                            #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                            #              l_axe.axe11,l_axz.axz06,
                            #              l_axz.axz07,l_aedd.aedd03,l_aedd.aedd04)
                            #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            #--FUN-A90026 mark---
                            #--FUN-A90026 start--
                            CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,g_aem.aem09,tm.em)
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            #--FUN-A90026 end----
                        END IF
                    ELSE
                        #--FUN-A90026 mark----
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #              l_axe.axe11,l_axz.axz06,
                        #              l_axz.axz07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark---
                        #--FUN-A90026 start---
                        CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                      l_axe.axe11,l_axz.axz06,
                                      l_axz.axz07,g_aem.aem09,tm.em)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 end---
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe11='3' THEN  #本期損益BS為資產負債類科目，此時不需處理
                        #--FUN-A90026 mark--
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #              l_axe.axe11,l_axz.axz06,
                        #              l_axz.axz07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark--
                        #--FUN-A90026 start--
                        CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                      l_axe.axe11,l_axz.axz06,
                                      l_axz.axz07,g_aem.aem09,tm.em)
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 end----
                    END IF

                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_axe.axe12='1' THEN 
                        #--FUN-A90026 mark--
                        #CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                        #                  l_axe.axe12,l_axz.axz07,
                        #                  x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #--FUN-A90026 mark--
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                          x_aaa03,g_aem.aem09,tm.em)
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #---FUN-A90026 mark----
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs30 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs30
                        USING g_dept[i].axa01,g_dept[i].axb04,
                              #l_aedd.aedd01,l_axe.axe06,g_date_e 
                              g_aem.aem04,g_date_e      #FUN-A90026
                        FETCH p001_cnt_cs30 INTO l_axr_count
                        CLOSE p001_cnt_cs30
                        IF l_axr_count > 0 THEN   
                            #CALL p001_axr(i,l_aedd.aedd01,l_axe.axe06,g_date_e)  
                            #CALL p001_axr(i,g_aem.aem04,g_date_e)      #FUN-A90026
                            CALL p001_axr(i,l_axe.axe04,g_aem.aem04,g_date_e)      #FUN-A90026   #TQC-AA0098
                            #--FUN-A70086 start--
                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            #LET l_fun_dr = l_chg_dr
                            #LET l_fun_cr = l_chg_cr
                            #LET l_acc_dr = l_chg_dr
                            #LET l_acc_cr = l_chg_cr
                            #--FUN-A70086 end----
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
                                              x_aaa03,g_aem.aem09,tm.em)       #FUN-A90026
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
		        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		    		      l_axe.axe12,l_axz.axz07,
		    		      #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
		    		      x_aaa03,g_aem.aem09,tm.em)            #FUN-A90026	
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe12='3' THEN 
		        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		            	      l_axe.axe12,l_axz.axz07,
		            	      #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
		            	      x_aaa03,g_aem.aem09,tm.em)        #FUN-A90026     
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
                    #-------FUN-A60038 end-----------------------------------

#----------------------FUN-A60038 mark- 移至p001_axr()---------------------------
#                   DECLARE p001_aei_c3 CURSOR FOR p001_axr_p2
#                   OPEN p001_aei_c3
#                   USING g_dept[i].axa01,g_dept[i].axb04,
#                         l_aedd.aedd01,l_axe.axe06,g_date_e
#                   FETCH p001_aei_c3 INTO l_axr_count
#                   IF l_axr_count > 0 THEN
#                      DECLARE p001_aei_c4 CURSOR FOR p001_axr_p
#                      OPEN p001_aei_c4   
#                      USING g_dept[i].axa01,g_dept[i].axb04,
#                            l_aedd.aedd01,l_axe.axe06,g_date_e  
#                      FETCH p001_aei_c4    
#                       INTO l_aag06,l_axr13        
#                      #當子公司記賬幣別與子公司功能幣別不同時才需要抓匯率來計
#                      IF l_axz.axz06 != l_axz.axz07 THEN  
#                         #功能幣別匯率
#                         CALL p001_getrate(l_axe.axe11,l_axr08,l_axr09,
#                                           l_axz.axz06,l_axz.axz07)
#                         RETURNING l_rate
#                         IF cl_null(l_rate) THEN LET l_rate = 1 END IF
#                      END IF
#                      #當子公司功能幣別與母公司記賬幣別不同時才需要抓匯率來計算
#                      IF l_axz.axz07 != x_aaa03 THEN
#                         #記賬幣別匯率 
#                         CALL p001_getrate(l_axe.axe12,l_axr08,l_axr09,
#                                           l_axz.axz07,x_aaa03)
#                         RETURNING l_rate1
#                         IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
#                      END IF
#                      IF g_dept[i].axa02=g_dept[i].axb04 THEN
#                         LET l_rate=1
#                         LET l_rate1=1
#                      END IF
#                      #->幣別轉換及取位
#                      IF l_axr13 > 0 THEN
#                         IF l_aag06='1' THEN                #正常余額為1.借 
#                            LET l_chg_aedd05_a=l_axr13       #功能幣別借方金額 
#                            LET l_chg_aedd06_a=0             #功能幣別       
#                         ELSE                               #正常余額為2.貸余
#                            LET l_chg_aedd05_a=0             #功能幣別借方金額
#                            LET l_chg_aedd06_a=l_axr13       #功能幣別貸方金額
#                         END IF
#                      ELSE
#                         IF l_aag06='1' THEN                #正常余額為1.借余
#                            LET l_chg_aedd05_a=0                      
#                            LET l_chg_aedd06_a=(l_axr13*-1)  #功能幣別貸方金額
#                         ELSE                               #正常余額為2.貸余  
#                            LET l_chg_aedd05_a=(l_axr13*-1)  #功能幣別借方金額
#                            LET l_chg_aedd06_a=0                      
#                         END IF
#                      END IF
#
#                      LET l_chg_aedd05  =l_chg_aedd05   + l_chg_aedd05_a
#                      LET l_chg_aedd06  =l_chg_aedd06   + l_chg_aedd06_a
#                      LET l_chg_aedd05_1=l_chg_aedd05_1 + l_chg_aedd05_a * l_rate1    #記賬幣別借方金額     
#                      LET l_chg_aedd06_1=l_chg_aedd06_1 + l_chg_aedd06_a * l_rate1    #記賬幣別貸方金額 
#---------------FUN-A60038 mark------------------------

                    #----FUN-A90026 mark---
                    # #-------FUN-A60038 start---------
                    # LET l_chg_aedd05  =l_chg_aedd05   + l_fun_dr
                    # LET l_chg_aedd06  =l_chg_aedd06   + l_fun_cr
                    # LET l_chg_aedd05_1=l_chg_aedd05_1 + l_acc_dr
                    # LET l_chg_aedd06_1=l_chg_aedd06_1 + l_acc_cr
                    # #-------FUN-A60038 end----------
                    #----FUN-A90026 mark---

                    #SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06  
                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07    #FUN-A60060 mod
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                    #LET l_aedd.aedd01=l_axe06    #FUN-A90026 mark
                    #->幣別轉換及取位 
 
                    #--FUN-A90026 mark----
                    #LET l_chg_aedd05=cl_digcut(l_chg_aedd05,l_cut)
                    #LET l_chg_aedd06=cl_digcut(l_chg_aedd06,l_cut)
                    #LET l_chg_aedd05_1= cl_digcut(l_chg_aedd05_1,l_cut1)
                    #LET l_chg_aedd06_1= cl_digcut(l_chg_aedd06_1,l_cut1)
                    #IF cl_null(l_chg_aedd05_1) THEN LET l_chg_aedd05_1=0 END IF
                    #IF cl_null(l_chg_aedd06_1) THEN LET l_chg_aedd06_1=0 END IF
                    #--FUN-A90026 mark-----

                    #--FUN-A90026 start----
                    LET l_chg_aem11=cl_digcut(l_chg_aem11,l_cut)
                    LET l_chg_aem12=cl_digcut(l_chg_aem12,l_cut)
                    LET l_chg_aem11_1= cl_digcut(l_chg_aem11_1,l_cut1)
                    LET l_chg_aem12_1= cl_digcut(l_chg_aem12_1,l_cut1)
                    IF cl_null(l_chg_aem11_1) THEN LET l_chg_aem11_1=0 END IF
                    IF cl_null(l_chg_aem12_1) THEN LET l_chg_aem12_1=0 END IF
                    #--FUN-A90026 end-----

                    LET l_aei16 = l_rate   
                    LET l_aei17 = l_rate1   
                    INSERT INTO aei_file
                     (aei00,aei01,aei02,aei021,aei03,aei031,
                      aei04,aei05,aei06,aei07,aei08,aei09,
                      aei10,aei11,aei12,aei13,aei14,aei15,
                      aei16,aei17,aei18,aeilegal)  #NO.130717 add aeilegal
                    VALUES
                      (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,
                      g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05, 
                      #l_aedd.aedd01,l_aedd.aedd015,l_aedd.aedd016,    #FUN-A90026 mark
                      #l_aedd.aedd017,l_aedd.aedd018,l_aedd.aedd03,    #FUN-A90026 mark
                      #l_aedd.aedd04,l_aedd.aedd05,l_aedd.aedd06,      #FUN-A90026 mark
                      #l_aedd.aedd07,l_aedd.aedd08,tm.ver,             #FUN-A90026 mark
                      g_aem.aem04,g_aem.aem05,g_aem.aem06,g_aem.aem07, #FUN-A90026 mod
                      g_aem.aem08,g_aem.aem09,tm.em,g_aem.aem11, #FUN-A90026 mod
                      g_aem.aem12,g_aem.aem13,g_aem.aem14,tm.ver,      #FUN-A90026 mod
                      l_aei16,l_aei17,l_axz06,g_legal)  #NO.130717 add g_legal
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                       #UPDATE aei_file    SET aei11=aei11+l_chg_aedd05_1,    #FUN-A90026 mark
                       #                       aei12=aei12+l_chg_aedd06_1,    #FUN-A90026 mark
                       #                       aei13=aei13+l_aedd.aedd07,     #FUN-A90026 mark
                       #                       aei14=aei14+l_aedd.aedd08,     #FUN-A90026 mark
                       UPDATE aei_file SET aei11=aei11+l_chg_aem11_1,         #FUN-A90026 mod
                                           aei12=aei12+l_chg_aem12_1,         #FUN-A90026 mod
                                           aei13=aei13+g_aem.aem13,           #FUN-A90026 mod
                                           aei14=aei14+g_aem.aem14,           #FUN-A90026 mod
                                           aei16=l_aei16,
                                           aei17=l_aei17
                        WHERE aei00 = g_aaz641
                          AND aei01 = g_dept[i].axa01
                          AND aei02 = g_dept[i].axa02
                          #AND aei02 = tm.axa02  #FUN-A30064                                                                                                         
                          AND aei021= g_dept[i].axa03
                          AND aei03 = g_dept[i].axb04
                          AND aei031= g_dept[i].axb05
                          #AND aei04 = l_aedd.aedd01        #FUN-A90026 mark
                          #AND aei05 = l_aedd.aedd015       #FUN-A90026 mark
                          #AND aei06 = l_aedd.aedd016       #FUN-A90026 mark
                          #AND aei07 = l_aedd.aedd017       #FUN-A90026 mark 
                          #AND aei08 = l_aedd.aedd018       #FUN-A90026 mark
                          #AND aei09 = l_aedd.aedd03        #FUN-A90026 mark
                          #AND aei10 = l_aedd.aedd04        #FUN-A90026 mark
                          AND aei04 = g_aem.aem04    #FUN-A90026 mod
                          AND aei05 = g_aem.aem05    #FUN-A90026 mod
                          AND aei06 = g_aem.aem06    #FUN-A90026 mod
                          AND aei07 = g_aem.aem07    #FUN-A90026 mod
                          AND aei08 = g_aem.aem08    #FUN-A90026 mod
                          AND aei09 = g_aem.aem09    #FUN-A90026 mod
                          AND aei10 = tm.em          #FUN-A90026 mod
                          AND aei15 = tm.ver
                          AND aei18 = l_axz06
                       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                          CALL s_errmsg('aei01',g_dept[i].axa01,'upd_aei',SQLCA.sqlcode,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                    ELSE
                       IF STATUS THEN
                          LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04
                          CALL s_errmsg('aei01,aei02,aei03,aei04 ',g_showmsg,'ins_aei',status,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                    END IF
                END FOREACH	　	　	　	　
    END FOR
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
  
    IF g_success="N" THEN
       RETURN
    END IF 
 
#luttb---mark--str---拆分至aglp007.4gl
## --FUN-A90036 先產生換匯差額分錄,並寫入p001_adj_tmp()  換匯分錄寫入
#    #-->step 4
#    CALL p001_adj()
## --FUN-A90036 end-----

#    #-->step 3 產生調整分錄
#    #-->ref.axf_file insert into axi_file,axj_file
#    CALL p001_modi()

#    CALL p001_modi_adj()  #FUN-A60038

##--FUN-A90036 mark---
##    #-->step 4 
##    CALL p001_adj()  
##--FUN-A90036 mark--
#luttb--mark--end
END FUNCTION
#--FUN-A90026 end-----

FUNCTION p001_del() 
  LET g_em = tm.em   #FUN-770069 add
  #-->delete aei_file(合并前科目異動碼(固定)衝賬余額檔) 
  DELETE FROM aei_file
        WHERE aei00=g_aaz641 
          AND aei01=tm.axa01
       #  AND aei02=tm.axa02  #Mark by sam 20101204
          AND aei09=tm.yy
          AND aei10=tm.em
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","aei_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del aei_file",1)
     LET g_success = 'N'
     RETURN
  END IF
  #FUN-9B0017   ---end

  #-->delete axg_file(合併前會計科目各期餘額檔)
  DELETE FROM axg_file 
        WHERE axg00=g_aaz641   #FUN-5A0020  #FUN-920067 mod
          AND axg01=tm.axa01 
         #AND axg02=tm.axa02 #Mark by sam 20101204 
          AND axg06=tm.yy AND axg07 = tm.em #FUN-970046 mod
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axg_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del axg_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

  #-->delete axk_file(科目異動碼沖帳餘額檔)
  DELETE FROM axk_file 
        WHERE axk00=g_aaz641   #FUN-5A0020   #FUN-920067 mod
          AND axk01=tm.axa01 
         #AND axk02=tm.axa02 #Mark by sam 20101204 
          AND axk08=tm.yy AND axk09 = tm.em   #FUN-970046
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axk_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del axk_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

#luttb--mark--str----
#  #-->delete axj_file(調整與銷除分錄底稿單身檔)
#  DELETE FROM axj_file 
#        WHERE axj00=g_aaz641   #FUN-5A0020   #FUN-920067 mod
#          AND axj01 IN (SELECT axi01 FROM axi_file 
#                         WHERE axi00=g_aaz641 AND axi05=tm.axa01   #FUN-5A0020  #FUN-920067 mod
#                           AND axi06=tm.axa02 AND axi07=tm.axa03
#                           AND axi03=tm.yy AND axi04 = tm.em   #FUN-970046 mod
#                           AND (axi21=tm.ver OR axi21=g_em)    #MOD-930210 add
#                           AND axi08='2')
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err3("del","axj_file",g_aaz641,"",SQLCA.sqlcode,"","del axj_file",1)  #No.FUN-660123    #FUN-920067 mod
#     LET g_success = 'N' 
#     RETURN 
#  END IF 
#
#  #-->delete axi_file
#  #-->delete axi_file(調整與銷除分錄底稿單頭檔)
#  DELETE FROM axi_file 
#        WHERE axi00=g_aaz641   #FUN-5A0020   #FUN-920067  mod
#          AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
#          AND axi03=tm.yy AND axi04 = tm.em   #FUN-970046
#          AND (axi21=tm.ver OR axi21=g_em)    #MOD-930210 add
#          AND axi08='2'
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err3("del","axi_file",tm.axa03,"",SQLCA.sqlcode,"","del axi_file",1)  #No.FUN-660123 
#     LET g_success = 'N' 
#     RETURN 
#  END IF 
#luttb--mark--end
END FUNCTION
 
#luttn----mark--str----------------  
#FUNCTION p001_modi()   #產生調整分錄
#DEFINE l_axk09_o    LIKE axk_file.axk09,             #期別
#       l_axg07_m    LIKE axg_file.axg07,             #FUN-960003 add
#       l_axk09_o1   LIKE axk_file.axk09,             #期別  #FUN-930144
#       l_axg07_m1   LIKE axg_file.axg07,             #FUN-960003 add
#       l_axk07_o    LIKE axk_file.axk07,             #異動碼值
#       l_axk07_o1   LIKE axk_file.axk07,             #異動碼值  #FUN-930144 
#       l_axg07_o    LIKE axg_file.axg07,             #期別   #FUN-760053 add
#       l_cnt        LIKE type_file.num5,             #FUN-760053 add
#       l_sql,l_sql1 STRING,                          #FUN-5A0118        
#       i,g_no       LIKE type_file.num5              #No.FUN-680098   SMALLINT  
#DEFINE l_axz08      LIKE axz_file.axz08              #FUN-920067 add
#DEFINE l_axf09_axz05      LIKE axz_file.axz05              #FUN-920067 add  
#DEFINE l_axf10_axz05      LIKE axz_file.axz05              #FUN-920067
#DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10  #FUN-920167
#DEFINE l_i                LIKE type_file.num5  #FUN-920167 
#DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
#DEFINE l_axf01            STRING  #FUN-950111
#DEFINE l_axf02            STRING  #FUN-950111
#
#   #建立TempTable以便處理科目為MISC的資料
#   DROP TABLE p001_tmp
#   CREATE TEMP TABLE p001_tmp(
#      axg06    SMALLINT,
#      axg07    SMALLINT,
#      axg05    VARCHAR(24),
#      axg02    VARCHAR(10),
#      axg04    VARCHAR(10),
#      axg08    DECIMAL(20,6),
#      axg12    VARCHAR(4),       #FUN-A30079
#      affil    VARCHAR(15),
#      dc       VARCHAR(1),
#      flag_r   VARCHAR(1))        #要不要經過持股比例的計算
#
##--TQC-AA0098 mark--
###--FUN-A60038 start---
##   DROP TABLE p001_axj_tmp
##   CREATE TEMP TABLE p001_axj_tmp(
##      axj03    VARCHAR(24),
##      axj06    VARCHAR(1),
##      axj07    DECIMAL(20,6))
###--FUN-A60038 end----
##--TQC-AA0098 mark
#
#   DELETE FROM p001_tmp
#   #LET l_sql = "INSERT INTO p001_tmp VALUES(?,?,?,?,?, ?,?,?,?)"
#   LET l_sql = "INSERT INTO p001_tmp VALUES(?,?,?,?,?,?,?,?,?,?)" #FUN-A30079
#   PREPARE insert_prep FROM l_sql
#   #IF STATUS THEN
#   IF SQLCA.SQLCODE THEN   #FUN-A80130
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF
#
##---FUN-A60038 start---
#   LET l_sql = "INSERT INTO p001_axj_tmp VALUES(?,?,?)" 
#   PREPARE insert_axj_prep FROM l_sql
#   #IF STATUS THEN
#   IF SQLCA.SQLCODE THEN  #FUN-A80130
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF
##--FUN-A60038 end------
#
#   LET l_sql1=
#   #"SELECT axa01,axa02,axa03,axa03 FROM axa_file ",     #MOD-A60056 mark
#    "SELECT axa01,axa02,axa03 FROM axa_file ",           #MOD-A60056
#    " WHERE axa01='",tm.axa01,"'",
#    #AND axa02='",tm.axa02,"' ",      #FUN-A30079 mark 
#    #"   AND axa03='",tm.axa03,"' ",  #FUN-A30079 mark
##--FUN-A30064 start--
#    " UNION ",
#   #"SELECT axb01,axb04,axb05,axa03 ",                   #MOD-A60056 mark
#    "SELECT axb01,axb04,axb05 ",                         #MOD-A60056
#    "  FROM axb_file,axa_file ",
#    " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
#    "   AND axa01='",tm.axa01,"'"
#   #"   AND axa02='",tm.axa02,"' ",   #FUN-A30079 mark
#   #"   AND axa03='",tm.axa03,"' "    #FUN-A30079 mark
##--FUN-A30064 end--
#
#   PREPARE p001_axa_p1 FROM l_sql1
#	   DECLARE p001_axa_c1 CURSOR FOR p001_axa_p1
#
#   LET g_no = 1
#   FOREACH p001_axa_c1 INTO g_axa[g_no].*
#      IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y'                                                      
#      END IF  
#      IF SQLCA.SQLCODE THEN
#         LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03
#         CALL s_errmsg('axa01,axa02,axa03',g_showmsg,'for_axa_c1:',STATUS,1)   #NO.FUN-710023
#         LET g_success = 'N'
#         CONTINUE FOREACH                               #NO.FUN-710023 
#      END IF
#      LET g_no=g_no+1
#   END FOREACH
#   IF g_totsuccess="N" THEN LET g_success="N" END IF     #NO.FUN-710023 add
#   LET g_no=g_no-1
#
#   INITIALIZE g_axi.* TO NULL
#   INITIALIZE g_axj.* TO NULL
#
#   FOR i =1 TO g_no
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y'                                                      
#     END IF 
#
##FUN-960003 ---配合agli003己開放非股本資料也能設為MISC對沖
##1.先抓來源會科，如果是MISC時，則來源為axs_file，
##接著處理對沖科目，如果亦為MISC則來源為axt_file
##其它狀況可能會一對一 ，一對多，多對一，多對多，所以在程式上要配合
##如果一對多時，axf<->axt, 一對一 axf<->axf, 多對一 axs<->axf, 多對多 axs<->axt
##2.資料來源又可分為axg_file,axk_file,依axf15,axf17決定
#
#     DECLARE p001_axf_cs1 CURSOR FOR
#        SELECT *
#          FROM axf_file 
#        # WHERE axf00=g_aaz641         #上層帳別   #FUN-920067  #FUN-A30079
#        #   AND axf13=g_axa[i].axa01   #族群 #FUN-930117        #FUN-A30079 mark
#          WHERE axf13=g_axa[i].axa01   #族群 #FUN-930117        #FUN-A30079 mod
#           AND axf09=g_axa[i].axa02   #來源公司               
#           AND axfacti='Y'            #有效的資料
#         ORDER BY axf12,axf10,axf01,axf02,axf03,axf04
#     FOREACH p001_axf_cs1 INTO g_axf.*
#     IF g_axf.axf16 <> tm.axa02 THEN CONTINUE FOREACH END IF  #FUN-A30079 合併主體= 目前輸入的上層公司才進行沖銷分錄
#
#     LET l_axf01 = g_axf.axf01   #FUN-960003 
#     LET l_axf02 = g_axf.axf02   #FUN-960003
#     LET l_axf01 = l_axf01.substring(1,4)  #FUN-960003 
#     LET l_axf02 = l_axf02.substring(1,4)  #FUN-960003
#    
#     #--FUN-920067 start-- 抓出下層公司axf10在agli009中設定的關係人異動碼值--
#     #SELECT axz08 INTO l_axz08  
#     SELECT axz08 INTO g_axz08     #FUN-A90006
#       FROM axz_file
#      #WHERE axz01 = g_axf.axf10
#      WHERE axz01 = g_axf.axf09    #FUN-A90026
#         #--FUN-A30079 mark--
#         #非上層公司不處理 MISC
#         #IF g_axa[i].axa02<>tm.axa02 THEN
#         #    CONTINUE FOR
#         #ELSE
#         #--FUN-A30079 mark
##              CALL p001_modi_axf_misc(l_axf01,l_axf02,g_axf.axf15,i)  
#              CALL p001_modi_axf_misc(l_axf01,l_axf02,g_axf.axf15,g_axf.axf17,i)    #FUN-A80137
#         #END IF   #FUN-A30079 
#     #    #傳入參數 '來源科目代號' '科目性質'  '科目來源' 
#     
#     END FOREACH
#   END FOR
#
#   IF g_totsuccess="N" THEN                                                                                                         
#      LET g_success="N"                                                                                                             
#   END IF 
#END FUNCTION
#   
#FUNCTION p001_ins_axi()
#DEFINE li_result  LIKE type_file.num5     #No.FUN-560060        #No.FUN-680098 SMALLINT
#
#    INITIALIZE g_axi.* TO NULL
#
#    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
#     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
#    IF SQLCA.sqlcode THEN 
#       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
#       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
#       RETURN 
#    END IF
#    LET g_axi.axi00  = g_aaz641      #帳別      #FUN-5A0020   #FUN-920067 mod
#    LET g_axi.axi01  = tm.gl         #傳票編號
#    LET g_axi.axi02  = g_edate       #單據日期
#    LET g_axi.axi03  = g_yy          #調整年度  #FUN-770069 mod
#    LET g_axi.axi04  = g_mm          #調整月份  #FUN-770069 mod
#    LET g_axi.axi05  = tm.axa01      #族群編號
#    LET g_axi.axi06  = tm.axa02      #上層公司編號
#    LET g_axi.axi07  = tm.axa03      #上層帳別
#    LET g_axi.axi08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
#    LET g_axi.axi09  = 'N'           #換匯差額調整否    #MOD-A60080
#    LET g_axi.axiconf= 'Y'           #確認碼
#    LET g_axi.axiuser= g_user        #資料所有者
#    LET g_axi.axigrup= g_grup        #資料所有群
#    LET g_axi.axidate= g_today       #最近修改日
#    LET g_axi.axi21  = tm.ver        #版本      #FUN-750078 add
#    LET g_axi.axi081 = '1'           #內部交易 (1.內部交易 2.未實現損益  3.攤銷)  #FUN-A90026
#
#    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
#                          "axi_file","axi01",g_dbs,"2",g_aaz641)   #FUN-5A0020      #FUN-920067 mod
#    RETURNING li_result,g_axi.axi01
#    DISPLAY g_axi.axi01
#    IF g_success='N' THEN 
#        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
#        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)         #NO.FUN-710023 
#        RETURN 
#    END IF
#
#    INSERT INTO axi_file VALUES(g_axi.*)
#    IF SQLCA.sqlcode THEN 
#       LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
#       CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
#       RETURN 
#    END IF
#
#END FUNCTION
#
#FUNCTION p001_ins_axj1()
#DEFINE l_axz06_axf16   LIKE axz_file.axz06   #FUN-A30079
#DEFINE l_aag04         LIKE aag_file.aag04   #FUN-A30079
#DEFINE l_rate          LIKE axp_file.axp05   #FUN-A30079   #各公司與合併主體公司匯率
#DEFINE l_cut           LIKE type_file.num5   #FUN-A30079
#
#   INITIALIZE g_axj.* TO NULL
# 
#   LET g_axj.axj00=g_aaz641        #帳別   #FUN-920067 mod
#   LET g_axj.axj01=g_axi.axi01     #傳票編號   
#
#   SELECT MAX(axj02)+1 INTO g_axj.axj02 
#     FROM axj_file 
#    WHERE axj01=g_axj.axj01
#      AND axj00=g_axj.axj00  #FUN-760053
#   IF g_axj.axj02 IS NULL THEN LET g_axj.axj02 = 1 END IF   #項次
#   LET g_axj.axj03=g_axg.axg05                              #科目
#   LET g_axj.axj04=' '                                      #摘要
#   LET g_axj.axj05=g_affil                                  #關係人   #FUN-760053 mod
#   IF g_axg.axg08 < 0 THEN 
#      IF g_dc='1' THEN LET g_dc='2' ELSE LET g_dc='1' END IF
#   END IF
#   LET g_axj.axj06=g_dc                                     #借貸別
#   LET l_rate = 1   #FUN-A60038
#   IF g_axf.axf03='N' OR (g_axf.axf03='Y' AND g_rate=0) THEN
#      LET g_axj.axj07=g_axg.axg08                           #金額
#   ELSE
#      IF g_flag_r='Y' THEN
#         LET g_axj.axj07=g_axg.axg08*(1-g_rate)          #金額
#         #-FUN-A30079 start--
#         IF g_axj.axj07 > 0 THEN
#             LET g_axj.axj06 = '1'
#         ELSE
#             LET g_axj.axj06 = '2'
#         END IF
#         #--FUN-A30079 end---
#      ELSE
#         LET g_axj.axj07=g_axg.axg08                        #金額
#      END IF
#   END IF
#   #------------FUN-A30079 start------------------
#   #原本都是以tm.axa02為上層公司寫入對沖分錄
#   #改以"合併主體(axf16)"寫入對沖分錄上層公司(axi06),
#   #對沖金額(axj07)的值原本是以上層公司的幣別計算
#   #改以合併主體幣別
#   #(axg08,axg09為捲算過後的上層公司記帳幣金額不可直接拿來使用)
#   #當要產生對沖分錄時，tm.axa02取axf_file的值(axf16 = tm.axa02)再進行對沖產生
#   #並且要把對沖金額換算為合併主體公司記帳幣，才能算出差額科目金額
#   #一一將對沖的科目寫入分錄之後(要換算成合併主體幣別)，再計算差額額目(同一組分錄借-貸)
# 
#   SELECT axz06 INTO l_axz06_axf16 
#     FROM axz_file
#    WHERE axz01 = g_axf.axf16   #合併主體幣別
#  
#   #將來源/目的公司的幣別和合併主體幣別做比較
#   #幣別相同者不用換，不相同時將幣別換成合併主體幣別and金額
#   LET l_rate = 1  #FUN-A60038
#   #IF g_axf.axf14 = 'N' THEN    #股本類科目不需要進行匯率轉換,從餘額檔取時就己經是換算為上層公司幣別的金額了  #FUN-A40026 mark  #FUN-A60038 cancel mark #FUN-A60099
##------FUN-A90026 mark---------
##       IF g_axg.axg12 != l_axz06_axf16 THEN 
##           SELECT aag04 INTO l_aag04
##            FROM aag_file
##            WHERE aag00=g_aaz641
##              AND aag01=g_axg.axg05
##           #依科目性質來判斷取"現時"或"平均"匯率
##           IF l_aag04 = '1' THEN   
##               CALL p001_getrate('1',g_axi.axi03,g_axi.axi04,
##                                 g_axg.axg12,l_axz06_axf16)  
##               RETURNING l_rate
##           ELSE
##               #--FUN-A90006--與合併主體幣別不相同時，採平均法算法時
##               #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
##               #ex.處理3月份沖銷金額= 1月記帳(axj07) x 匯率 + 2月記帳(axj07) X 2月匯率 + 3月記帳(axj07) X 3月匯率
##               CALL p001_ins_axj1_chg(g_axg.axg12,l_axz06_axf16) RETURNING g_axj.axj07
##               #CALL p001_getrate('3',g_axi.axi03,g_axi.axi04,
##               #                 g_axg.axg12,l_axz06_axf16)
##               #RETURNING l_rate
##               #--FUN-A90006 end---
##           END IF
##           IF cl_null(l_rate) THEN LET l_rate = 1 END IF
##       ELSE
##           LET l_rate = 1
##       END IF
##   #END IF  #FUN-A40026  mark #FUN-A60038 cancel mark  #FUN-A60099
##
##   LET g_axj.axj07 = g_axj.axj07 * l_rate
##---FUN-A90026 mark-------------------------
#
#   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
#   IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#   LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)
#   #------------FUN-A30079 end ------------------
#   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
#   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
#   IF g_axj.axj07 != 0 THEN   #MOD-890130 add
#      INSERT INTO axj_file VALUES (g_axj.*)
#      IF SQLCA.sqlcode THEN 
#         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01                                  #NO.FUN-710023      
#         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)          #NO.FUN-710023
#         LET g_success = 'N' 
#         RETURN 
#      END IF
#      #----FUN-A60038 start--
#      LET l_aag04 = ''
#      SELECT aag04 INTO l_aag04
#        FROM aag_file
#       WHERE aag00 = g_aaz641
#         AND aag01 = g_axj.axj03
#      IF l_aag04 = '2' THEN  #FUN-A60060
#           EXECUTE insert_axj_prep USING g_axj.axj03,g_axj.axj06,g_axj.axj07
#                                         
#      END IF 
#      #---FUN-A60038 end-------
#   END IF                     #MOD-890130 add
#
#END FUNCTION
#
#FUNCTION p001_ins_axj2()   #差異科目
#DEFINE l_sumd  LIKE axj_file.axj07,
#       l_sumc  LIKE axj_file.axj07,
#       l_sumdc LIKE axj_file.axj07
#DEFINE l_aag04 LIKE aag_file.aag04  #FUN-A60060
#
#   INITIALIZE g_axj.* TO NULL
#
#   SELECT SUM(axj07) INTO l_sumd FROM axj_file
#    WHERE axj00=g_aaz641 AND axj01=g_axi.axi01 AND axj06='1'   #借方合計   #FUN-920067
#   IF cl_null(l_sumd) THEN LET l_sumd = 0 END IF   #FUN-960096
#   SELECT SUM(axj07) INTO l_sumc FROM axj_file
#    WHERE axj00=g_aaz641 AND axj01=g_axi.axi01 AND axj06='2'   #貸方合計  #FUN-920067
#   IF cl_null(l_sumc) THEN LET l_sumc = 0 END IF   #FUN-960003 
#   LET l_sumdc=l_sumd-l_sumc   
#   IF l_sumdc = 0 THEN RETURN END IF
#
#   LET g_axj.axj00=g_aaz641     #帳別   #FUN-920067 mod
#   LET g_axj.axj01=g_axi.axi01     #傳票編號   
#
#   SELECT MAX(axj02)+1 INTO g_axj.axj02 
#     FROM axj_file
#    WHERE axj01=g_axj.axj01
#      AND axj00=g_axj.axj00  #FUN-760053
#   IF cl_null(g_axj.axj02)  THEN LET g_axj.axj02 = 1 END IF
#   LET g_axj.axj03=g_axf.axf04     #科目   #FUN-750078 modify
#   LET g_axj.axj04=' '             #摘要
#   LET g_axj.axj05=' '             #關係人
#   IF l_sumdc >0 THEN              #借貸別
#      LET g_axj.axj06='2' 
#   ELSE 
#      LET g_axj.axj06='1' 
#   END IF
#   LET g_axj.axj07=l_sumdc         #金額
#   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
#   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
#   IF g_axj.axj07 != 0 THEN   #MOD-890130 add
#      INSERT INTO axj_file VALUES (g_axj.*)
#      IF SQLCA.sqlcode THEN 
#         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01                                  #NO.FUN-710023      
#         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)          #NO.FUN-710023
#         LET g_success = 'N' 
#         RETURN 
#      END IF
#      #----FUN-A60038 start--
#      LET l_aag04 = ''
#      SELECT aag04 INTO l_aag04
#        FROM aag_file
#       WHERE aag00 = g_aaz641
#         AND aag01 = g_axj.axj03
#      IF l_aag04 = '2' THEN
#           EXECUTE insert_axj_prep USING g_axj.axj03,
#                                         g_axj.axj06,g_axj.axj07
#      END IF 
#      #---FUN-A60038 end-------
#   END IF                     #MOD-890130 add
#
#END FUNCTION
# 
##----FUN-A60038 start--
#FUNCTION p001_modi_adj()
#DEFINE l_axj03   LIKE axj_file.axj03
#DEFINE l_axj06   LIKE axj_file.axj06
#DEFINE l_axj07   LIKE axj_file.axj07
#DEFINE l_aag06   LIKE aag_file.aag06
#DEFINE li_result LIKE type_file.num5     
#DEFINE l_cnt     LIKE type_file.num5
#
#   INITIALIZE g_axi.* TO NULL
#   INITIALIZE g_axj.* TO NULL
#
#   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
#   RETURNING g_bdate,g_edate
#   LET g_yy=tm.yy 
#   LET g_mm=tm.em 
#
#    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
#     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
#    IF SQLCA.sqlcode THEN 
#       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
#       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
#       RETURN 
#    END IF
#    LET g_axi.axi00  = g_aaz641      #帳別      
#    LET g_axi.axi01  = tm.gl         #傳票編號
#    LET g_axi.axi02  = g_edate       #單據日期
#    LET g_axi.axi03  = g_yy          #調整年度 
#    LET g_axi.axi04  = g_mm          #調整月份 
#    LET g_axi.axi05  = tm.axa01      #族群編號
#    LET g_axi.axi06  = tm.axa02      #上層公司編號
#    LET g_axi.axi07  = tm.axa03      #上層帳別
#    LET g_axi.axi08  = '2'           #來源碼
#    LET g_axi.axi09  = 'N'           #換匯差額調整否    
#    LET g_axi.axiconf= 'Y'           #確認碼
#    LET g_axi.axiuser= g_user        #資料所有者
#    LET g_axi.axigrup= g_grup        #資料所有群
#    LET g_axi.axidate= g_today       #最近修改日
#    LET g_axi.axi21  = tm.ver        #版本   
#    LET g_axi.axi081 = '1'           #FUN-A90026
#
#    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
#                          "axi_file","axi01",g_dbs,"2",g_aaz641) 
#    RETURNING li_result,g_axi.axi01
#    DISPLAY g_axi.axi01
#    IF g_success='N' THEN 
#        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
#        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)         #NO.FUN-710023 
#        RETURN 
#    END IF
#
#   #--取出此上層公司的調整分錄非換匯者 ----
#     DECLARE p001_axj_cs CURSOR FOR
#        SELECT axj03,axj06,axj07
#          FROM p001_axj_tmp
#     LET l_cnt = 0
#     FOREACH p001_axj_cs INTO l_axj03,l_axj06,l_axj07
#        IF SQLCA.sqlcode THEN 
#           LET g_showmsg= l_axj03,"/",l_axj06,"/"
#           CALL s_errmsg('axj03,axj06',g_showmsg,'p001_axj_cs',SQLCA.sqlcode,1) 
#           LET g_success = 'N'
#           CONTINUE FOREACH 
#        END IF
#        LET l_cnt = l_cnt + 1
#
###. 取沖銷調整分錄中換匯差額否[axi09<>'Y']者的分錄
##1. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##2. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##           C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##3. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##4. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
##   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##          C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#
#      LET g_axj.axj00=g_aaz641                                                  
#      LET g_axj.axj01=g_axi.axi01                                               
#
#      CASE 
#          WHEN l_axj06 = '1'
#               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#                WHERE axj01=g_axj.axj01                                                  
#                  AND axj00=g_axj.axj00                                                  
#               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#               LET g_axj.axj03=g_aaz114
#               LET g_axj.axj04=' '                      #摘要                         
#               LET g_axj.axj06='1'                      #借貸別                       
#               LET g_axj.axj07= l_axj07
#               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#               IF g_axj.axj07 != 0 THEN                                                  
#                  INSERT INTO axj_file VALUES (g_axj.*)                                  
#               END IF                                                                    
#
#               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#                WHERE axj01=g_axj.axj01                                                  
#                  AND axj00=g_axj.axj00                                                  
#               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#               LET g_axj.axj03=g_aaz113
#               LET g_axj.axj04=' '                      #摘要                         
#               LET g_axj.axj06='2'                      #借貸別                       
#               LET g_axj.axj07= l_axj07
#               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#               IF g_axj.axj07 != 0 THEN                                                  
#                  INSERT INTO axj_file VALUES (g_axj.*)                                  
#               END IF                                                                    
#          WHEN l_axj06 = '2'
#               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#                WHERE axj01=g_axj.axj01                                                  
#                  AND axj00=g_axj.axj00                                                  
#               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#               LET g_axj.axj03=g_aaz113
#               LET g_axj.axj04=' '                      #摘要                         
#               LET g_axj.axj06='1'                      #借貸別                       
#               LET g_axj.axj07= l_axj07
#               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#               IF g_axj.axj07 != 0 THEN                                                  
#                  INSERT INTO axj_file VALUES (g_axj.*)                                  
#               END IF                                                                    
#
#               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#                WHERE axj01=g_axj.axj01                                                  
#                  AND axj00=g_axj.axj00                                                  
#               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#               LET g_axj.axj03=g_aaz114
#               LET g_axj.axj04=' '                      #摘要                         
#               LET g_axj.axj06='2'                      #借貸別                       
#               LET g_axj.axj07= l_axj07
#               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#               IF g_axj.axj07 != 0 THEN                                                  
#                  INSERT INTO axj_file VALUES (g_axj.*)                                  
#               END IF                                                                    
#      END CASE
#   END FOREACH
#
#   #--先寫完單身再寫單頭，避免單身無值
#   IF l_cnt > 0 THEN
#       INSERT INTO axi_file VALUES(g_axi.*)
#       IF SQLCA.sqlcode THEN 
#          LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
#          CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
#          RETURN 
#       END IF
#       IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF   
#   END IF
#END FUNCTION 
##-------------FUN-A60038 end---------------------
#FUNCTION p001_adj()
#DEFINE l_aaz86        LIKE aaz_file.aaz86   #FUN-5A0118  #外幣換算損益
#DEFINE l_aaz87        LIKE aaz_file.aaz87   #FUN-5A0118  #換算調整數
#DEFINE l_flag         LIKE type_file.chr1   #FUN-770069 add 10/19  #判斷是不是第一次進入迴圈
#DEFINE l_axz08_axf10  LIKE axz_file.axz08   #FUN-960096
#DEFINE l_axa09        LIKE axa_file.axa09   #FUN-980095
#DEFINE l_aag04        LIKE aag_file.aag04   #FUN-980095
#DEFINE l_amt_aaz113   LIKE axg_file.axg08   #FUN-990020                             
#DEFINE l_amt_aaz114   LIKE axg_file.axg08   #FUN-990020                             
#DEFINE l_aaz113       LIKE aaz_file.aaz113  #FUN-990020                             
#DEFINE l_aaz114       LIKE aaz_file.aaz114  #FUN-990020                             
#DEFINE l_amt_cnt      LIKE axg_file.axg08   #FUN-990020  
#DEFINE l_amt_tot      LIKE axg_file.axg08   #FUN-9B0017
#DEFINE l_amt          LIKE axg_file.axg08   #FUN-9B0017
#DEFINE l_axg19        LIKE axg_file.axg19   #FUN-A30079  
#DEFINE l_axz06_axf16  LIKE axf_file.axf16   #FUN-A30079
#DEFINE l_cut          LIKE type_file.num5   #FUN-A30079
#DEFINE l_cnt          LIKE type_file.num5   #FUN-A80125
#DEFINE l_sql          STRING                #FUN-A90036
#
##--TQC-AA0098 add
#   DROP TABLE p001_axj_tmp
#   CREATE TEMP TABLE p001_axj_tmp(
#      axj03    VARCHAR(24),
#      axj06    VARCHAR(1),
#      axj07    DECIMAL(20,6))
##--TQC-AA0098 add
#
##--FUN-A90036 start--
#   DROP TABLE p001_adj_tmp
#   CREATE TEMP TABLE p001_adj_tmp(
#      axj03    VARCHAR(24),
#      axj05    VARCHAR(15),
#      axj06    VARCHAR(1),
#      axj07    DECIMAL(20,6),
#      axj071    DECIMAL(20,6))
#
#   LET l_sql = "INSERT INTO p001_adj_tmp VALUES(?,?,?,?,?)"
#   PREPARE insert_adj_prep FROM l_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:p001_adj_tmp',status,1) EXIT PROGRAM
#   END IF
##--FUN-A90036 end--
#
#   #外幣換算損益(aaz86),換算調整數(aaz87)
#   #本期損益-IS(aaz113),本期損益-BS(aaz114)   #FUN-990020
#   SELECT aaz86,aaz87,aaz113,aaz114   #FUN-990020
#     INTO l_aaz86,l_aaz87,l_aaz113,l_aaz114   #MOD-A10005 add
#     FROM aaz_file   #FUN-580063
#
#   #--FUN-A30079 start-
#   SELECT axz06 INTO l_axz06_axf16
#     FROM axz_file
#    WHERE axz01 = g_axf.axf16
#   #--FUN-A30079 end---
#
#   LET l_amt_cnt = 0    #MOD-A70083
#
#   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
#   RETURNING g_bdate,g_edate
#   LET g_yy=tm.yy   #FUN-770069 add
#   LET g_mm=tm.em   #FUN-770069 add
#
#   LET g_axg04 = ''  #FUN-770069 add 10/19
#   LET g_amt = 0  #FUN-5A0118
#   LET l_flag = "Y"  #FUN-770069 add 10/19
#
#   SELECT axa09 INTO l_axa09 FROM axa_file                                     
#    WHERE axa01= tm.axa01                                                      
#     AND axa02= tm.axa02                                                      
#     AND axa03= tm.axa03                                                      
#  IF l_axa09 = 'Y' THEN  
#     LET g_dbs_axz03 =  s_dbstring(g_dbs_axz03)                              
#  ELSE                                                                        
#     LET g_dbs_axz03 =  s_dbstring(g_dbs)                                    
#  END IF                      
#
#  INITIALIZE g_axi.* TO NULL  #TQC-AA0098
#  INITIALIZE g_axj.* TO NULL  #TQC-AA0098
#
#  #將累積換算調整數拆開依各子公司列示
#
#  #--FUN-990020 add--兌換損益----                                                   
#  LET g_sql =                                                                
#      #"SELECT axg04,SUM(axg08-axg09)",                                       
#      "SELECT axg04,SUM(axg09-axg08)",   #FUN-A60099                                       
#      "  FROM axg_file,",g_dbs_axz03,"aag_file",                             
#      " WHERE axg00='",g_aaz641,"'",                                         
#      "   AND axg01='",tm.axa01,"'",                                         
#      "   AND axg02='",tm.axa02,"'",                                         
#      "   AND axg17='",tm.ver,"'",                                           
#      "   AND axg06='",tm.yy,"'",                                            
#      "   AND aag00 ='",g_aaz641,"'",                                        
#      "   AND axg05 = aag01",                                                
#      "   AND aag04 != '1'",                                                 
#      "   AND axg05 != '",l_aaz113,"'",                                      
#      #"   AND axg07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",   #FUN-A90006 mark
#      "   AND axg07 = '",tm.em,"'",                     #FUN-A90006 mod
#      " GROUP BY axg04",                                                     
#      " ORDER BY axg04"                                                      
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
#  PREPARE p001_adj_p2 FROM g_sql                                              
#  DECLARE p001_adj_c2 CURSOR FOR p001_adj_p2                                  
#  LET l_cnt = 0   #FUN-A80125
#  FOREACH p001_adj_c2 INTO g_axg04,l_amt_aaz113                               
#     IF SQLCA.sqlcode THEN                                                    
#        LET g_axg04 = ' '                                                     
#        LET l_amt_aaz113   = 0                                                
#        CONTINUE FOREACH                                
#     END IF                                                                   
#
#    #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#    IF l_flag = "Y" THEN   #FUN-770069 add 10/19
#       CALL p001_ins_axi()
#       IF g_success = 'N' THEN RETURN  END IF
#       UPDATE axi_file set axi09='Y' 
#        WHERE axi01=g_axi.axi01
#          AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
#       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#          CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
#          RETURN 
#       END IF
#       LET l_flag = "N"
#    END IF   #FUN-770069 add 10/19
#
##--FUN-990020 start-----兌換損益aaz86分錄----                                     
#    #SELECT SUM(axg08-axg09)                                                
#    SELECT SUM(axg09-axg08)  #FUN-A60099                                               
#      INTO l_amt_aaz114                                                    
#      FROM axg_file                                                        
#     WHERE axg00=g_aaz641                                                  
#       AND axg01=tm.axa01                                                  
#       AND axg02=tm.axa02                                                  
#       AND axg04=g_axg04                                                   
#       AND axg17=tm.ver                                                    
#       AND axg06=tm.yy                                                     
#       AND axg05 =l_aaz114                                                 
#       AND axg07 = tm.em                                                   
#
#    LET l_amt_cnt = l_amt_aaz113 - l_amt_aaz114                               
#         
#    #-FUN-A90006 ---start
#    IF l_amt_cnt <> 0 THEN
#        #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#        IF l_flag = "Y" THEN   
#           CALL p001_ins_axi()
#           IF g_success = 'N' THEN RETURN  END IF
#           UPDATE axi_file set axi09='Y'
#            WHERE axi01=g_axi.axi01
#              AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
#           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1)
#              RETURN
#           END IF
#           LET l_flag = "N"
#        END IF 
#    END IF
#    #--FUN-A90006 -- end
#                                                                     
#      LET g_axj.axj00=g_aaz641                                                  
#      LET g_axj.axj01=g_axi.axi01                                               
#      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#       WHERE axj01=g_axj.axj01                                                  
#         AND axj00=g_axj.axj00                                                  
#      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#      LET g_axj.axj03=l_aaz114                    #科目  #FUN-A30079 mod
#      #LET g_axj.axj03=l_aaz86                    #科目  #FUN-A30079 mark                   
#      LET g_axj.axj04=' '                         #摘要                         
#      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
#       WHERE axz01=g_axg04                                                      
#                                                                                
#      IF l_amt_cnt >0 THEN                                                      
#         LET g_axj.axj06='2'                      #借貸別                       
#         LET g_axj.axj07= l_amt_cnt               #金額                         
#      ELSE                                                                      
#         LET g_axj.axj06='1'                      #借貸別                       
#         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
#      END IF                                                                    
#      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#      IF g_axj.axj07 != 0 THEN                                                  
#         INSERT INTO axj_file VALUES (g_axj.*)                                  
#      END IF                                                                    
#                                                                                
#      #--寫入一筆aaz87為對向科目的分錄和aaz86為一組---                          
#      LET g_axj.axj00=g_aaz641                                                  
#      LET g_axj.axj01=g_axi.axi01                                               
#      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
#       WHERE axj01=g_axj.axj01                                                  AND axj00=g_axj.axj00                                                  
#                                                                                
#      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
#                                                                                
#      LET g_axj.axj03=l_aaz87                     #科目                         
#      LET g_axj.axj04=' '                         #摘要                         
#      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
#       WHERE axz01=g_axg04 
#                                                     
#      #--FUN-A30079 start--
#      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
#      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#      LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)
#      #--FUN-A30079 end--
#
#      IF l_amt_cnt >0 THEN                                                      
#         LET g_axj.axj06='1'                      #借貸別                       
#         LET g_axj.axj07= l_amt_cnt               #金額                         
#      ELSE                                                                      
#         LET g_axj.axj06='2'                      #借貸別                       
#         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
#      END IF                                                                    
#      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
#      IF g_axj.axj07 != 0 THEN                                                  
#         INSERT INTO axj_file VALUES (g_axj.*)                               
#         LET l_cnt = l_cnt + 1   #FUN-A80125
#      END IF                                                                    
#   END FOREACH                                                                  
#
#   #---FUN-A80125 start--
#   IF l_cnt = 0 THEN
#       DELETE FROM axi_file where axi00 = g_aaz641 AND axi01 = g_axi.axi01
#       LET l_flag = 'Y'   #TQC-AA0098
#   END IF
#   #--FUN-A80125 end----
#
##--FUN-A30079 mark------         
##  #增加本期損益處理
##   LET g_sql =	　	　	　	　	　
##        #"SELECT axg04,SUM(axg15-axg16)*axg19 ",	　 #FUN-A30079 mark
##        "SELECT axg04,axg19,SUM(axg15-axg16)",  　
##        "  FROM axg_file,",g_dbs_axz03,"aag_file",	　
##        " WHERE axg00='",g_aaz641,"'",	　	　
##        "   AND axg01='",tm.axa01,"'",	　	　
##        "   AND axg02='",tm.axa02,"'",	　	　
##        "   AND axg17='",tm.ver,"'",	　	　
##        "   AND axg06='",tm.yy,"'",	　	　	　
##        "   AND aag00 ='",g_aaz641,"'",	　	　
##        "   AND axg05 = aag01",	　	　	　
##        #"   AND aag04 != '1'",	　	　	　
##        "   AND aag04 = '1'",   #FUN-A30079 mod
##        #"   AND axg07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
##        "   AND axg07 ='",tm.em,"'",  #FUN-A30079 
##        " GROUP BY axg04",	　	　	　	　
##        " ORDER BY axg04"	　	　	　	　
##   PREPARE p001_adj_p3 FROM g_sql	　	　	　
##   DECLARE p001_adj_c3 CURSOR FOR p001_adj_p3	　
##   LET l_amt_tot = 0   LET l_amt = 0	　	　
##   #FOREACH p001_adj_c3 INTO g_axg04,l_amt	#下層公司 / 下層公司功能幣別*匯率-->上層公司記賬幣
##   FOREACH p001_adj_c3 INTO g_axg04,l_axg19,l_amt  #FUN-A30079 mod
##      IF SQLCA.sqlcode THEN	　	　	　
##         LET g_axg04 = ' '	　	　	　	　
##         LET l_amt   = 0	　	　	　	　
##         CONTINUE FOREACH	　	　	　	　
##      END IF	　	　	　	　	　
##      LET l_amt_tot = l_amt_tot + l_amt	　	　
##   END FOREACH	　	　	　	　	　
##
##--系統自動產生的分錄共三組1.本期損益-BS科目/累換數(借貸) 2.本期損益(單向) 3.累換數(單向)
##   LET g_axj.axj00=g_aaz641	　	　	　
##   LET g_axj.axj01=g_axi.axi01	　	　	　
##   SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file
##    WHERE axj01=g_axj.axj01	　	　	　
##      AND axj00=g_axj.axj00	　	　	　
##   IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
##   LET g_axj.axj03=l_aaz86                     #科目
##   LET g_axj.axj04=' '                         #摘要
##   LET g_axj.axj05 = ' '                       #關系人
##   IF l_amt_cnt >0 THEN	　	　	　	　
##      LET g_axj.axj06='2'                      #借貸別
##      LET g_axj.axj07= l_amt_tot       #金額	　
##   ELSE	　	　	　	　	　
##      LET g_axj.axj06='1'                      #借貸別
##      LET g_axj.axj07= l_amt_tot*-1            #金額	　
##   END IF	　	　	　	　	　
##   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF
##   IF g_axj.axj07 != 0 THEN	　	　	　
##      INSERT INTO axj_file VALUES (g_axj.*)	　
##   END IF	　	　	　	　	　
##--FUN-A30079 mark--------------
#
##--MOD-A70083 start--
#   IF l_amt_cnt = 0 THEN
#      IF l_flag = "Y" THEN   
#         CALL p001_ins_axi()
#         IF g_success = 'N' THEN RETURN  END IF
#         UPDATE axi_file set axi09='Y' 
#          WHERE axi01=g_axi.axi01
#            AND axi00=g_aaz641 
#         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#            CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
#            RETURN 
#         END IF
#         LET l_flag = "N"
#      END IF  
#   END IF
##---MOD-A70083 end-----
#
#   LET g_sql =                                                                  
#       "SELECT axg04,SUM(axg08-axg09)",    #TQC-AA009                                        
#       #"SELECT axg04,SUM(axg09-axg08)",   #FUN-A90006                                        
#       "  FROM axg_file,",g_dbs_axz03,"aag_file" ,                              
#       " WHERE axg00='",g_aaz641,"'",                                           
#       "   AND axg01='",tm.axa01,"'",                                           
#       "   AND axg02='",tm.axa02,"'",                                           
#       "   AND axg17='",tm.ver,"'",                                             
#       "   AND axg06='",tm.yy,"'",                                              
#       "   AND axg07 ='",tm.em,"'",                                             
#       "   AND aag00 ='",g_aaz641,"'",                                          
#       "   AND axg05 = aag01",                                                  
#       "   AND aag04 = '1'",                                                    
#       " GROUP BY axg04",                                                       
#       " ORDER BY axg04"                                                        
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
#   PREPARE p001_adj_p1 FROM g_sql                                               
#   DECLARE p001_adj_c1 CURSOR FOR p001_adj_p1                                   
#   LET l_cnt = 0   #FUN-A80125
#   FOREACH p001_adj_c1 INTO g_axg04,g_amt                                       
#      IF SQLCA.sqlcode THEN                                                     LET g_axg04 = ' '                                                      
#         LET g_amt   = 0                                                        
#         CONTINUE FOREACH                                                       
#      END IF                                                                    
#      IF g_amt = 0 THEN                                                         
#         CONTINUE FOREACH                                                       
#      END IF                                                                    
#
##MOD-A40179---mark---start---
###---FUN-A30079 start--
##     SELECT axg19,SUM(axg15-axg16)
##       INTO l_axg19,l_amt_tot
##      FROM axg_file,aag_file   　
##      WHERE axg00=g_aaz641     　      　
##      AND axg01=tm.axa01       　      　
##      AND axg02=tm.axa02       　      　
##      AND axg04=g_axg04
##      AND axg06=tm.yy  　      　      　
##      AND aag00= g_aaz641      　      　
##      AND axg05= aag01 　      　      　
##      AND aag04 = '1'  　
##      AND axg07 =tm.em
##     GROUP BY axg04,axg19
##     LET l_amt_tot = l_amt_tot * l_axg19 
##     LET l_amt_tot=cl_digcut(l_amt_tot,l_cut)
###--FUN-A30079 end------
##MOD-A40179---mark---end---
#     #g_amt金額重新計算
##      LET g_amt = g_amt - l_amt_tot   #FUN-A30079 mark
#     #LET g_amt = l_amt_tot            #FUN-A30079   #累換數   #MOD-A40179 mark
#      LET g_axj.axj00=g_aaz641   #FUN-920067 mod
#      LET g_axj.axj01=g_axi.axi01
#      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file 
#       WHERE axj01=g_axj.axj01
#         AND axj00=g_axj.axj00  #FUN-760053
#      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
#      LET g_axj.axj03=l_aaz87                     #科目
#      LET g_axj.axj04=' '                         #摘要
#      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                                                                   
#       WHERE axz01=g_axg04                                                                                                  
#      IF g_amt >0 THEN
#         LET g_axj.axj06='2'                      #借貸別
#         LET g_axj.axj07=g_amt                    #金額
#      ELSE
#         LET g_axj.axj06='1'                      #借貸別
#         LET g_axj.axj07=g_amt*-1                 #金額
#      END IF
#      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
#      IF g_axj.axj07 != 0 THEN   #MOD-890130 add
#         INSERT INTO axj_file VALUES (g_axj.*)
#         LET l_cnt = l_cnt + 1   #FUN-A80125
#         #先將資料寫TempTable裡,後續股本累換數使用
#         CALL p001_adj_tmp(g_axj.*)      #FUN-A90036
#      END IF                     #MOD-890130 add
#   END FOREACH   #FUN-770069 add 10/19
#   #---FUN-A80125 start--
#   IF l_cnt = 0 THEN
#       DELETE FROM axi_file where axi00 = g_aaz641 AND axi01 = g_axi.axi01
#   END IF
#   #--FUN-A80125 end----
#   CALL upd_axi()
#END FUNCTION 
#
##--FUN-A90036 start--
#FUNCTION p001_adj_tmp(p_axj)
#DEFINE p_axj  RECORD LIKE axj_file.*
#DEFINE l_axj  RECORD 
#              axj03    VARCHAR(24),
#              axj05    VARCHAR(15),               
#              axj06    VARCHAR(1),
#              axj07    DECIMAL(20,6),             
#              axj071    DECIMAL(20,6)             
#              END RECORD
#DEFINE l_x    LIKE type_file.num5
#
#   SELECT COUNT(*) INTO l_x FROM p001_adj_tmp
#    WHERE axj03 = p_axj.axj03
#      AND axj05 = p_axj.axj05
#
#   LET l_axj.axj03 = p_axj.axj03
#   LET l_axj.axj05 = p_axj.axj05
#   LET l_axj.axj06 = ''
#
#   IF l_x = 0 THEN
#      IF p_axj.axj06 = '1' THEN
#         LET l_axj.axj07 = p_axj.axj07
#         LET l_axj.axj071 = 0
#      ELSE
#         LET l_axj.axj07 =  0
#         LET l_axj.axj071 = p_axj.axj07
#      END IF
#      #EXECUTE insert_adj_prep USING l_axj.axj03,l_axj.axj05,l_axj.axj06,l_axj.axj07,l_axj.axj071 
#      EXECUTE insert_adj_prep USING l_axj.axj03,l_axj.axj05,p_axj.axj06,l_axj.axj07,l_axj.axj071    #TQC-AA0098
#   ELSE
#      SELECT * INTO l_axj.*  FROM  p001_adj_tmp
#       WHERE axj03 = p_axj.axj03
#         AND axj05 = p_axj.axj05
#
#      IF p_axj.axj06 = '1' THEN
#         LET l_axj.axj07 = l_axj.axj07 + p_axj.axj07
#      ELSE
#         LET l_axj.axj071 = l_axj.axj071 + p_axj.axj07
#      END IF
#
#      UPDATE p001_adj_tmp SET axj07  =  l_axj.axj07,
#                              axj071 =  l_axj.axj071,
#                              axj06 = p_axj.axj06    #TQC-AA0098
#       WHERE axj03 = p_axj.axj03
#         AND axj05 = p_axj.axj05
#   END IF
#
#END FUNCTION                                                                        
##--FUN-A90036 end---
#
#FUNCTION get_rate()#持股比率
#DEFINE l_axb07    LIKE axb_file.axb07,
#       l_axb08    LIKE axb_file.axb08,
#       l_axd07b   LIKE axd_file.axd07b,
#       l_axd08b   LIKE axd_file.axd08b,
#       l_count    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
#       l_sql      LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(600)
#       l_axz05    LIKE axz_file.axz05        #MOD-A70113 add
#
#    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=g_axf.axf10      #MOD-A70113 add
#    SELECT axb07,axb08 INTO l_axb07,l_axb08 FROM axb_file 
#     WHERE axb01=tm.axa01 AND axb02=tm.axa02 AND axb03=tm.axa03
#      #AND axb04=g_axf.axf10 AND axb05=g_axf.axf12   #FUN-760053 #下層公司/帳號    #MOD-A70113 mark
#       AND axb04=g_axf.axf10 AND axb05=l_axz05          #MOD-A70113 add
#    IF STATUS THEN LET g_rate=0 RETURN END IF
#    IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN LET g_rate=l_axb07/100 RETURN END IF
#    
#    LET l_count=0
#    LET g_rate =0
#    LET l_sql="SELECT axd07b,axd08b  FROM axd_file ",
#              " WHERE axd01='",tm.axa01,"'",
#              "   AND axd02='",tm.axa02,"' AND axd03='",tm.axa03,"'",
#             #"   AND axd04b='",g_axf.axf10,"' AND axd05b='",g_axf.axf12,"'",  #MOD-940010 add  #MOD-A70113 mark
#              "   AND axd04b='",g_axf.axf10,"' AND axd05b='",l_axz05,"'",      #MOD-A70113 add 
#              " ORDER BY axd08b desc"  #MOD-940010 add
#    PREPARE p001_axd_p FROM l_sql
#    IF STATUS THEN 
#        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN     #NO.FUN-710023    
#    END IF
#    DECLARE p001_axd_c CURSOR FOR p001_axd_p
#
#    FOREACH p001_axd_c INTO l_axd07b,l_axd08b
#       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
#       LET l_count=l_count+1
#       IF g_edate>=l_axd08b THEN LET g_rate=l_axd07b/100 EXIT FOREACH END IF   #FUN-770069      10/19
#    END FOREACH       
#    IF l_count=0 THEN LET g_rate=0 RETURN END IF
#END FUNCTION
#   
#FUNCTION upd_axi()
#DEFINE l_sum_tot    LIKE axj_file.axj07
#
#    LET l_sum_tot=0
#    SELECT SUM(axj07) INTO l_sum_tot  FROM axj_file 
#     WHERE axj01=g_axi.axi01 AND axj06='1'
#       AND axj00=g_aaz641 #FUN-760053   #FUN-920067 mod
#    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
#    IF STATUS OR cl_null(l_sum_tot) THEN 
#       RETURN
#    END IF
#    UPDATE axi_file SET axi11 = l_sum_tot 
#     WHERE axi01=g_axi.axi01
#       AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#       RETURN
#    END IF
#
#    LET l_sum_tot=0
#    SELECT SUM(axj07) INTO l_sum_tot FROM axj_file 
#     WHERE axj01=g_axi.axi01 AND axj06='2'
#       AND axj00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
#    IF STATUS OR cl_null(l_sum_tot) THEN
#       RETURN
#    END IF
#    UPDATE axi_file SET axi12 = l_sum_tot 
#     WHERE axi01=g_axi.axi01
#       AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#       RETURN
#    END IF
#END FUNCTION
#luttb--mark--end
#抓匯率
FUNCTION p001_getrate(l_value,l_axp01,l_axp02,l_axp03,l_axp04)
DEFINE l_value LIKE axe_file.axe11,
       l_axp01 LIKE axp_file.axp01,
       l_axp02 LIKE axp_file.axp02,
       l_axp03 LIKE axp_file.axp03,
       l_axp04 LIKE axp_file.axp04,
       l_axp05 LIKE axp_file.axp05,    #FUN-770069 add
       l_axp06 LIKE axp_file.axp06,    #FUN-770069 add
       l_axp07 LIKE axp_file.axp07,    #FUN-770069 add
       l_rate  LIKE axp_file.axp05     #No.FUN-680098  DECIMAL(20,6)


   SELECT axp05,axp06,axp07 
     INTO l_axp05,l_axp06,l_axp07 
     FROM axp_file
    WHERE axp01=l_axp01
      AND axp02=(SELECT max(axp02) FROM axp_file
                  WHERE axp01 = l_axp01
                    AND axp02 <=l_axp02
                    AND axp03 = l_axp03
                    AND axp04 = l_axp04)
      AND axp03=l_axp03 
      AND axp04=l_axp04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_axp05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_axp06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_axp07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION

#luttb---mark-----str------
##FUNCTION p001_modi_axf_misc(p_axf01,p_axf02,p_axf15,i)         #FUN-A80137 mark
#FUNCTION p001_modi_axf_misc(p_axf01,p_axf02,p_axf15,p_axf17,i)  #FUN-A80137
#DEFINE p_axf01   STRING
#DEFINE p_axf02   STRING
#DEFINE p_axf17   LIKE axf_file.axf17                 #FUN-A80137
#DEFINE p_axf15   LIKE axf_file.axf15,
#       l_cnt        LIKE type_file.num5,             #FUN-760053 add
#       l_sql,l_sql1 STRING,                          #FUN-5A0118        
#       i,g_no       LIKE type_file.num5             #No.FUN-680098   SMALLINT
#DEFINE l_axz08      LIKE axz_file.axz08              #FUN-920067 add
#DEFINE l_axf09_axz05      LIKE axz_file.axz05              #FUN-920067 add  
#DEFINE l_axf10_axz05      LIKE axz_file.axz05              #FUN-920067
#DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10  #FUN-920167
#DEFINE l_i                LIKE type_file.num5  #FUN-920167 
#DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
#DEFINE l_axz08_axf10      LIKE axz_file.axz08  #FUN-960096
#DEFINE l_axz03_axf09      LIKE axz_file.axz03  #FUN-A30079
#DEFINE l_axz03_axf10      LIKE axz_file.axz03  #FUN-A30079
#DEFINE g_dbs_axf09        LIKE azp_file.azp03  #FUN-A30079 
#DEFINE g_dbs_axf10        LIKE azp_file.azp03  #FUN-A30079 
#DEFINE l_axb02            LIKE axb_file.axb02  #FUN-A30079
##DEFINE l_axa09_axf09      LIKE axa_file.axa09  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_axa09_axf10      LIKE axa_file.axa09  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_axz06_axf09      LIKE axz_file.axz06  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_axz06_axf10      LIKE axz_file.axz06  #FUN-A30079  #FUN-A90006 mark
#DEFINE l_low_axf09        LIKE type_file.num5  #FUN-A60060
#DEFINE l_up_axf09         LIKE type_file.num5  #FUN-A60060
#DEFINE l_low_axf10        LIKE type_file.num5  #FUN-A60060
#DEFINE l_up_axf10         LIKE type_file.num5  #FUN-A60060
#DEFINE l_axa02_axf09      LIKE axa_file.axa02  #FUN-A60060
#DEFINE l_axa02_axf10      LIKE axa_file.axa02  #FUN-A60060
#DEFINE l_axz06_axf16      LIKE axz_file.axz06  #FUN-A90026 
## -- FUN-A90036 start--
#DEFINE l_axj03            LIKE axj_file.axj03
#DEFINE l_axj05            LIKE axj_file.axj05
#DEFINE l_axj06            LIKE axj_file.axj06
#DEFINE l_axj07             LIKE axj_file.axj07
#DEFINE l_axj07_d            LIKE axj_file.axj07
#DEFINE l_axj07_c            LIKE axj_file.axj07
## -- FUN-A90036 end--
#DEFINE l_axt03             LIKE axt_file.axt03   #TQC-AA0098
#
#     DELETE FROM p001_tmp   #FUN-760053 add
#
#     #--FUN-920067 start-- 抓出上層公司axf10在agli009中設定帳別
#     #SELECT axz05 INTO l_axf09_axz05  
#     SELECT axz05 INTO g_axf09_axz05   #FUN-A90006
#       FROM axz_file
#      WHERE axz01 = g_axf.axf09
#     #SELECT axz05 INTO l_axf10_axz05
#      SELECT axz05 INTO g_axf10_axz05  #FUN-A90006
#       FROM axz_file
#      WHERE axz01 = g_axf.axf10
#
#     #--FUN-920167 start-- 抓出下層公司axf10在agli009中設定的關係人異動碼值--
#     #SELECT axz08 INTO l_axz08  
#     SELECT axz08 INTO g_axz08  #FUN-A90006 
#       FROM axz_file
#      WHERE axz01 = g_axf.axf09   #FUN-930112
##     SELECT axz08 INTO l_axz08_axf10
#      SELECT axz08 INTO g_axz08_axf10  #FUN-A90006 
#       FROM axz_file WHERE axz01 = g_axf.axf10
#
# 
#     #--FUN-A30079 start--
#     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
#     #之前的應用方式為tm.axa02上層公司輸入之後抓取的axg,axk資料都是自己本身
#     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
#     #SQL抓資料時分為以下狀況 ：
#     #A.來源(目的)公司=合併主體：(順流)
#     #  A1.axg02 = 自己, axg04 = 自己
#     #  A2.axg02 = 不用加入此條件, axg04 = 自己
#     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
#     #  IF 屬於上層公司
#     #    1.最上層公司：條件=>axg02 = 自己, axg04 = 自己
#     #    2.中間層(有上層也有下層),條件=> axg02 = 自己的上層公司,axg04 = 自己 
#     #  ELSE
#     #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己
#     #  END IF
#  
#     #--先判斷g_axf.axf09(來源)/g_axf.axf10(目的)各自是否為上層公司--
#     LET g_cnt_axf09 = 0
#     SELECT COUNT(*) INTO g_cnt_axf09 
#       FROM axa_file
#      WHERE axa01 = g_axf.axf13   #群組
#        AND axa02 = g_axf.axf09   #上層公司 
#
#     LET g_cnt_axf10 = 0
#     SELECT COUNT(*) INTO g_cnt_axf10 
#       FROM axa_file
#      WHERE axa01 = g_axf.axf13   #群組
#        AND axa02 = g_axf.axf10   #上層公司
#
#     #--FUN-A60060 start-------------------
#     IF g_cnt_axf09 > 0 THEN    #代表為上層公司
#        #判斷是否存在下層
#        # SELECT COUNT(*) INTO l_low_axf09  
#        SELECT COUNT(*) INTO g_low_axf09  #FUN-A90006
#          FROM axb_file
#         WHERE axb01 = tm.axa01
#           AND axb04 = g_axf.axf09
##       IF l_low_axf09 > 0 THEN  
#        IF g_low_axf09 > 0 THEN          #FUN-A90006
#             #--如果l_up_axf09 = 0 代表是最下層
#             #SELECT COUNT(*) INTO l_up_axf09
#             SELECT COUNT(*) INTO g_up_axf09    #FUN-A90006
#               FROM axa_file 
#              WHERE axa01 = tm.axa01
#                AND axa02 = g_axf.axf09
#            #IF l_up_axf09 <> 0 THEN
#            IF g_up_axf09 <> 0 THEN             #FUN-A90006
#                #SELECT axb02 INTO l_axa02_axf09
#                SELECT axb02 INTO g_axa02_axf09   #FUN-A90006
#                  FROM axb_file
#                 WHERE axb01 = tm.axa01
#                   AND axb04 = g_axf.axf09
#                #--如果g_up_axf09 = 0 代表是最下層
#                #SELECT COUNT(*) INTO l_up_axf09
#                SELECT COUNT(*) INTO g_up_axf09    #FUN-A90006
#                  FROM axa_file 
#                 WHERE axa01 = tm.axa01
#                   AND axa02 = g_axf.axf09
#             END IF
#         END IF
#     #--FUN-A60078 start--
#     ELSE
#         #SELECT axb02 INTO l_axa02_axf09
#         SELECT axb02 INTO g_axa02_axf09          #FUN-A90006
#           FROM axb_file
#          WHERE axb01 = tm.axa01
#            AND axb04 = g_axf.axf09
#     #--FUN-A60078 end--
#     END IF   
#
#     IF g_cnt_axf10 > 0 THEN   #代表為上層公司
#         #判斷是否存在下層
#         #SELECT COUNT(*) INTO l_low_axf10  
#         SELECT COUNT(*) INTO g_low_axf10     #FUN-A90006
#           FROM axb_file
#          WHERE axb01 = tm.axa01
#            AND axb04 = g_axf.axf10
#         #IF l_low_axf10 > 0 THEN  
#         IF g_low_axf10 > 0 THEN              #FUN-A90006
#             #--如果l_up_axf10 = 0 代表是最下層
#             #SELECT COUNT(*) INTO l_up_axf10
#             SELECT COUNT(*) INTO g_up_axf10  #FUN-A90006
#               FROM axa_file 
#              WHERE axa01 = tm.axa01
#                AND axa02 = g_axf.axf10
#            #IF l_up_axf10 <> 0 THEN
#            IF g_up_axf10 <> 0 THEN           #FUN-A90006
#                #SELECT axb02 INTO l_axa02_axf10
#                SELECT axb02 INTO g_axa02_axf10    #FUN-A90006
#                  FROM axb_file
#                 WHERE axb01 = tm.axa01
#                   AND axb04 = g_axf.axf10
#            END IF
#         END IF
#     #--FUN-A60078 START
#     ELSE
#         #SELECT axb02 INTO l_axa02_axf10
#         SELECT axb02 INTO g_axa02_axf10           #FUN-A90006
#           FROM axb_file
#          WHERE axb01 = tm.axa01
#            AND axb04 = g_axf.axf10
#     #--FUN-A60078 end--
#     END IF   
#     #--FUN-A60060 end-----------------------
#
#     #合併帳別取法： 
#     #是上層公司-->判斷是否做獨立合併會科
#     #IF 'Y' -->則為目前公司的合併帳別
#     #IF 'N' -->則為當下營運中心合併帳別
#     #不是上層公司-->判斷是否做獨立合併會科
#     #IF 'Y' -->則為目前公司的上層公司的合併帳別
#     #IF 'N' -->則為當下營運中心的合併帳別
#     
#     IF g_cnt_axf09 > 0 THEN   #為上層公司
#         #SELECT axa09 INTO l_axa09_axf09
#         SELECT axa09 INTO g_axa09_axf09   #FUN-A90006
#           FROM axa_file 
#          WHERE axa01 = tm.axa01
#            AND axa02 = g_axf.axf09
#         SELECT axz03 INTO l_axz03_axf09 
#           FROM axz_file 
#          WHERE axz01 = g_axf.axf09
#         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
#          WHERE azp01 = l_axz03_axf09
#         #IF l_axa09_axf09 = 'Y' THEN     #來源公司合併帳別
#         IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
#         ELSE
#             LET g_dbs_axf09 = s_dbstring(g_dbs)
#         END IF
#     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
#         SELECT axb02 INTO l_axb02
#           FROM axb_file 
#          WHERE axb01 = tm.axa01
#            AND axb04 = g_axf.axf09
#         #SELECT axa09 INTO l_axa09_axf09
#         #SELECT axa09,axa02 INTO l_axa09_axf09,l_axa02_axf09  #FUN-A60060
#         SELECT axa09,axa02 INTO g_axa09_axf09,g_axa02_axf09   #FUN-A90006
#           FROM axa_file 
#          WHERE axa01 = tm.axa01
#            AND axa02 = l_axb02
#         SELECT axz03 INTO l_axz03_axf09 
#           FROM axz_file 
#          WHERE axz01 = l_axb02
#         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
#          WHERE azp01 = l_axz03_axf09
#         #IF l_axa09_axf09 = 'Y' THEN     #來源公司合併帳別
#         IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別     #FUN-A90006
#             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
#         ELSE
#             LET g_dbs_axf09 = s_dbstring(g_dbs)
#         END IF
#     END IF        
#     LET g_sql = "SELECT aaz641 FROM ",g_dbs_axf09,"aaz_file",
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
#     PREPARE p001_aaz_p1 FROM g_sql
#     DECLARE p001_aaz_c1 CURSOR FOR p001_aaz_p1
#     OPEN p001_aaz_c1
#     FETCH p001_aaz_c1 INTO g_aaz641_axf09   #合併帳別
#     CLOSE p001_aaz_c1
#
#     IF g_cnt_axf10 > 0 THEN   #為上層公司
#         #SELECT axa09 INTO l_axa09_axf10
#         SELECT axa09 INTO g_axa09_axf10  #FUN-A90006
#           FROM axa_file 
#          WHERE axa01 = tm.axa01
#            AND axa02 = g_axf.axf10
#         SELECT axz03 INTO l_axz03_axf10 
#           FROM axz_file 
#          WHERE axz01 = g_axf.axf10
#         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
#          WHERE azp01 = l_axz03_axf10
#         #IF l_axa09_axf10 = 'Y' THEN     #來源公司合併帳別
#         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
#         ELSE
#             LET g_dbs_axf10 = s_dbstring(g_dbs)
#         END IF
#     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
#         SELECT axb02 INTO l_axb02
#           FROM axb_file 
#          WHERE axb01 = tm.axa01
#            AND axb04 = g_axf.axf10
#         #SELECT axa09 INTO l_axa09_axf10
#         SELECT axa09 INTO g_axa09_axf10   #FUN-A90006
#           FROM axa_file 
#          WHERE axa01 = tm.axa01
#            AND axa02 = l_axb02
#         SELECT axz03 INTO l_axz03_axf10 
#           FROM axz_file 
#          WHERE axz01 = l_axb02
#         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
#          WHERE azp01 = l_axz03_axf10
#         #IF l_axa09_axf10 = 'Y' THEN     #來源公司合併帳別
#         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
#         ELSE
#             LET g_dbs_axf10 = s_dbstring(g_dbs)
#         END IF
#     END IF        
#     LET g_sql = "SELECT aaz641 FROM ",g_dbs_axf10,"aaz_file",
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
#     PREPARE p001_aaz_p2 FROM g_sql
#     DECLARE p001_aaz_c2 CURSOR FOR p001_aaz_p2
#     OPEN p001_aaz_c2
#     FETCH p001_aaz_c2 INTO g_aaz641_axf10   #合併帳別
#     CLOSE p001_aaz_c2
# 
#     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
#     #SELECT axz06 INTO l_axz06_axf09 
#     SELECT axz06 INTO g_axz06_axf09    #FUN-A90006
#       FROM axz_file
#      WHERE axz01 = g_axf.axf09   #來源公司記帳幣別
#     #SELECT axz06 INTO l_axz06_axf10 
#     SELECT axz06 INTO g_axz06_axf10    #FUN-A90006
#       FROM axz_file
#      WHERE axz01 = g_axf.axf10   #目的公司記帳幣別
#     
#     #--FUN-A30079 end---
#
#     #--#資料來源為axg_file---start----
#     IF p_axf15 = '1' THEN        
#         #IF g_cnt_axf09 > 0 THEN   #來源公司屬於上層公司   #FUN-A30079  #FUN-A60038
#         #LET l_sql =" SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",  #FUN-930144 mod
#         LET l_sql =" SELECT 'A','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",  #FUN-930144 mod  #FUN-A90026 mod
#                    #"        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N' "       #FUN-A30079
#                    #"        axg12,'",l_axz08_axf10,"','2','N' "     #FUN-A60038 mod
#                    #"        axg12,'",l_axz08_axf10,"','2','N','' "   #FUN-A80137 mod
#                    "         axg12,'",g_axz08_axf10,"','2','N','' "    #FUN-A90006
##--FUN-A60038 mark---
##         #---FUN-A30079 start-
##         ELSE 
##             #FUN-A40026 mark
##             #IF g_axf.axf14 = 'Y' THEN  #股本沖銷類科目不處理換算為合併幣別問題，直接取上層的記帳幣
##             #    LET l_sql =" SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",  
##             #               "        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N' "     
##             #ELSE
##             #FUN-A40026 mark
##                 LET l_sql =" SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14),",  
##                            "        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N' "
##             #END IF
##         END IF
##---FUN-A60038 mark----
#
#         LET l_sql = l_sql CLIPPED,
#         #---FUN-A30079 end---
#                    "   FROM axg_file ",
#                    "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
#                    #"    AND axg02 = '",g_axa[i].axa02,"'",  #FUN-970046 add
#                    #"     AND axg02 = '",tm.axa02,"'",        #FUN-A30064 #FUN-A30079 mark 
#                    #"    AND axg00 ='",g_aaz641,"' ",        #合併帳別
#                    "     AND axg00 ='",g_aaz641_axf09,"' ",  #合併帳別   #FUN0-A30079
#                    #"    AND axg12 ='",x_aaa03,"' ",         #幣別       #FUN-A30079 mark
#                    "    AND axg04 ='",g_axf.axf09,"' ",      #來源公司
#                    #"    AND axg041='",l_axf09_axz05,"' ",    #來源帳別 
#                    "    AND axg041='",g_axf09_axz05,"' ",    #來源帳別    #FUN-A90006
#                    "    AND axg06 = ",tm.yy,                 #年度
#                    "    AND axg07 = '",tm.em,"'"             #FUN-970046 mod   只抓截止期別的金額
#
#                    #---FUN-A60060 start---
#                    #A.來源公司=合併主體：(順流)
#                    #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
#                    #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
#                    #B.來源公司 <> 合併主體：(側流或逆流)
#                    #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
#                    #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
#                    #    2.中間層(有上層也有下層),
#                    #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
#                    #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
#                    #  ELSE
#                    #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
#                    #  END IF
#                     IF g_axf.axf09 = g_axf.axf16 THEN
#                         #-FUN-A70011
#                         IF g_axf.axf14 = 'Y' THEN
#                             LET l_sql = l_sql CLIPPED,
#                                 #"    AND axg02 = '",l_axa02_axf10,"'"
#                                 "    AND axg02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                         ELSE
#                         #-FUN-A70011 end--
#                             LET l_sql = l_sql CLIPPED,
#                             "    AND axg02 = '",g_axf.axf09,"'" 
#                         END IF         #FUN-A70011
#                     ELSE
#                         IF g_cnt_axf09 > 0 THEN
#                             #IF l_low_axf09 = 0 THEN #最上層
#                             IF g_low_axf09 = 0 THEN #最上層   #FUN-A90006
#                                 LET l_sql = l_sql CLIPPED,
#                                     "    AND axg02 = '",g_axf.axf09,"'" 
#                             ELSE
#                                 IF g_axf.axf14 = 'Y' THEN   #FUN-A60099
#                                     LET l_sql = l_sql CLIPPED,
#                                         #"    AND axg02 = '",l_axa02_axf09,"'" 
#                                         "    AND axg02 = '",g_axa02_axf09,"'"   #FUN-A90006
#                                 ELSE                                            #FUN-A60099
#                                     LET l_sql = l_sql CLIPPED,                  #FUN-A60099
#                                         "    AND axg02 = '",g_axf.axf09,"'"     #FUN-A60099
#                                 END IF                                          #FUN-A60099 
#                             END IF
#                         #--FUN-A70011 start--
#                         ELSE
#                             LET l_sql = l_sql CLIPPED,
#                             #"    AND axg02 = '",l_axa02_axf09,"'"
#                             "    AND axg02 = '",g_axa02_axf09,"'"               #FUN-A90006
#                         #-FUN-A70011 end--
#                         END IF  
#                     END IF
#                     #--FUN-A60060 end--------
##---FUN-A60060 mark---
##                    #--FUN-A30079 start--
##                    IF g_cnt_axf09 > 0 THEN
##                        LET l_sql = l_sql CLIPPED,
##                        "    AND axg02 = '",g_axf.axf09,"'" 
##                    END IF
##--FUN-A60060 mark----
#
#
##---FUN-A80137 start---#axf15 = '2' 來源科目檔案資料來源.axk_file
#     ELSE
#         #LET l_sql =" SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ", 
#         LET l_sql =" SELECT 'A','1',axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ",   #FUN-A90026 mod
#                    #"        axk14,'",l_axz08_axf10,"','2','N',axk07 ",
#                    "        axk14,'",g_axz08_axf10,"','2','N',axk07 ",      #FUN-A90006   
#                    "   FROM axk_file ",
#                    "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
#                    "    AND axk00 ='",g_aaz641_axf09,"' ",   
#                    "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
#                    #"    AND axk041='",l_axf09_axz05,"' ",     #來源帳別 
#                    "    AND axk041='",g_axf09_axz05,"' ",     #來源帳別    #FUN-A90006
#                    "    AND axk08 = ",tm.yy,                  #年度
#                    #"    AND axk07 = '",l_axz08_axf10 ,"'",  
#                    "    AND axk07 = '",g_axz08_axf10 ,"'",    #FUN-A90006
#                    "    AND axk09 = '",tm.em,"'"           
#         #A.來源公司=合併主體：(順流)
#         #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
#         #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
#         #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
#         #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
#         #  ELSE
#         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
#         #  END IF
#         IF g_axf.axf09 = g_axf.axf16 THEN
#             IF g_axf.axf14 = 'Y' THEN
#                 LET l_sql = l_sql CLIPPED,
#                 #"    AND axk02 = '",l_axa02_axf09,"'"
#                 "    AND axk02 = '",g_axa02_axf09,"'"   #FUN-A90006
#             ELSE
#                 LET l_sql = l_sql CLIPPED,
#                 "    AND axk02 = '",g_axf.axf09,"'" 
#             END IF    #FUN-A70011 
#         ELSE
#             IF g_cnt_axf09 > 0 THEN
##                 IF l_low_axf09 = 0 THEN #最上層
#                  IF g_low_axf09 = 0 THEN #最上層  #FUN-A90006
#                     LET l_sql = l_sql CLIPPED,
#                         "    AND axk02 = '",g_axf.axf09,"'" 
#                 ELSE
#                     IF g_axf.axf14 = 'Y' THEN     
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND axk02 = '",l_axa02_axf09,"'" 
#                             "    AND axk02 = '",g_axa02_axf09,"'"    #FUN-A90006
#                     ELSE                         
#                         LET l_sql = l_sql CLIPPED, 
#                             "    AND axk02 = '",g_axf.axf09,"'"   
#                     END IF                                       
#                 END IF
#             ELSE
#                  LET l_sql = l_sql CLIPPED,
#                  #"    AND axk02 = '",l_axa02_axf09,"'"
#                  "    AND axk02 = '",g_axa02_axf09,"'"               #FUN-A90006
#             END IF  
#         END IF
#     END IF
#
#     IF p_axf15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
#         CASE 
#           WHEN p_axf01 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
#             "                   WHERE axs00 = '",g_aaz641_axf09,"'",   
#             "                     AND axs01 = '",g_axf.axf01,"'",
#             "                     AND axs09 = '",g_axf.axf09,"'",
#             "                     AND axs10 = '",g_axf.axf10,"'",
#             "                     AND axs12 = '",g_aaz641_axf10,"'",  
#             "                     AND axs13 = '",g_axf.axf13,"')" 
#           WHEN p_axf01 != 'MISC'
#             LET l_sql = l_sql CLIPPED,
#             "    AND axg05 = '",g_axf.axf01,"'"
#         END CASE
#     ELSE   #axf15 = '2'
#         CASE WHEN p_axf01 = 'MISC' 
#               LET l_sql = l_sql CLIPPED,
#               "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
#               "                   WHERE axs00 = '",g_aaz641_axf09,"'",  
#               "                     AND axs01 = '",g_axf.axf01,"'",
#               "                     AND axs09 = '",g_axf.axf09,"'",
#               "                     AND axs10 = '",g_axf.axf10,"'",
#               "                     AND axs12 = '",g_aaz641_axf10,"'",  
#               "                     AND axs13 = '",g_axf.axf13,"')"  
#              WHEN p_axf01 != 'MISC'
#                LET l_sql = l_sql CLIPPED,
#                "    AND axk05 = '",g_axf.axf01,"'"
#         END CASE
#     END IF
#
#     IF p_axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axg_file
#         LET l_sql = l_sql CLIPPED,   
#         "  UNION ",
#         #" SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,", 
#         " SELECT 'B','2',axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-A90026 mod
#         "        axg12,'",g_axz08,"','1','N','' ",   
#         "   FROM axg_file ",
#         "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#         "    AND axg00 ='",g_aaz641_axf10,"' ",               
#         "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
#         "    AND axg041='",g_axf10_axz05,"' ",                 #對沖帳別  
#         "    AND axg06 = ",tm.yy,
#         "    AND axg07 = '",tm.em,"'"                         
#         CASE 
#           WHEN p_axf02 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
#             "                   WHERE axt00 = '",g_aaz641_axf09,"'", 
#             "                     AND axt01 = '",g_axf.axf02,"'",
#             "                     AND axt09 = '",g_axf.axf09,"'",
#             "                     AND axt10 = '",g_axf.axf10,"'",
#             "                     AND axt12 = '",g_aaz641_axf10,"'",  
#             "                     AND axt13 = '",g_axf.axf13,"'",  
#             "                     AND axt04 != 'Y') "  #是否依據公式設定
#           WHEN p_axf02 != 'MISC'
#             LET l_sql = l_sql CLIPPED,
#             "    AND axg05 = '",g_axf.axf02,"'"
#         END CASE
#
#         #A.來源公司=合併主體：(順流)
#         #  目的:axg02 = 自己的上層公司(g_axa02_axf10), axg04 = 自己
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 目的屬於上層公司
#         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
#         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
#         #  ELSE
#         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
#         #  END IF
#         IF g_cnt_axf10 > 0 THEN
#             #IF l_low_axf10 = 0 THEN #最上層
#             IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                 LET l_sql = l_sql CLIPPED,
#                     "    AND axg02 = '",g_axf.axf10,"'"
#             ELSE
#                 #IF l_up_axf10 > 0 THEN    #大於0代表不是最下層 
#                 IF g_up_axf10 > 0 THEN    #大於0代表不是最下層    #FUN-A90006
#                     IF g_axf.axf14 = 'Y' THEN             
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND axg02 = '",l_axa02_axf10,"'"
#                             "    AND axg02 = '",g_axa02_axf10,"'" #FUN-A90006
#                     ELSE                                 
#                         LET l_sql = l_sql CLIPPED,      
#                             "    AND axg02 = '",g_axf.axf10,"'" 
#                     END IF                                      
#                 END IF                
#             END IF
#         ELSE
#             LET l_sql = l_sql CLIPPED,
#             #"    AND axg02 = '",l_axa02_axf10,"'"
#             "    AND axg02 = '",g_axa02_axf10,"'"                 #FUN-A90006
#         END IF
#     ELSE                             #axf17 = '2' -->axk_file        
#         LET l_sql = l_sql CLIPPED,       
#         "  UNION ",
#         #" SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ", 
#         " SELECT 'B','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ",  #FUN-A90026 mod
#         "        axk14,'",g_axz08,"','1','N',axk07 ",                  
#         "   FROM axk_file ",
#         "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#         "    AND axk00 ='",g_aaz641_axf10,"' ",   
#         "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
#         "    AND axk041='",g_axf10_axz05,"' ",    #對沖帳別  
#         "    AND axk08 = ",tm.yy,
#         "    AND axk07 = '",g_axz08,"'",         
#         "    AND axk09 = '",tm.em,"'"
#         CASE 
#           WHEN p_axf02 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
#             "                   WHERE axt00 = '",g_aaz641_axf09,"'",   
#             "                     AND axt01 = '",g_axf.axf02,"'",
#             "                     AND axt09 = '",g_axf.axf09,"'",
#             "                     AND axt10 = '",g_axf.axf10,"'",
#             "                     AND axt12 = '",g_aaz641_axf10,"'",  
#             "                     AND axt13 = '",g_axf.axf13,"'",
#             "                     AND axt04 != 'Y') "    #是否依據公式設定
#           WHEN p_axf02 != 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND axk05 = '",g_axf.axf02,"'"   
#         END CASE
#         #A.來源公司=合併主體：(順流)
#         #  目的:axg02 = 不用加入此條件, axg04 = 自己
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 目的屬於上層公司
#         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
#         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
#         #  ELSE
#         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
#         #  END IF
#         IF g_cnt_axf10 > 0 THEN
#             #IF l_low_axf10 = 0 THEN #最上層
#             IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                 LET l_sql = l_sql CLIPPED,
#                     "    AND axk02 = '",g_axf.axf10,"'"
#             ELSE
#                 #IF l_up_axf10 > 0 THEN    
#                 IF g_up_axf10 > 0 THEN         #FUN-A90006
#                     IF g_axf.axf14 = 'Y' THEN 
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND axk02 = '",l_axa02_axf10,"'"
#                             "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                     ELSE                   
#                         LET l_sql = l_sql CLIPPED,                
#                             "    AND axk02 = '",g_axf.axf10,"'"  
#                     END IF                                      
#                 END IF   
#             END IF
#         ELSE
#             LET l_sql = l_sql CLIPPED,
#                #"    AND axk02 = '",l_axa02_axf10,"'"
#                "    AND axk02 = '",g_axa02_axf10,"'"                #FUN-A90006
#         END IF
#     END IF
#     PREPARE p001_axg_misc_p1 FROM l_sql
#     IF STATUS THEN 
#        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                  
#
#        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
#        LET g_success = 'N'  
#     END IF 
#     DECLARE p001_axg_misc_c1 CURSOR FOR p001_axg_misc_p1
#     
#     #FOREACH p001_axg_misc_c1 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
#     FOREACH p001_axg_misc_c1 INTO g_type,g_flag,g_axg.axg06,g_axg.axg07,g_axg.axg05,  #FUN-A90026 g_type:A.來源/B.目的 g_flag:1.aej/2.aek
#                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                              g_axg.axg12,   #FUN-A30079 
#                              g_affil,g_dc,g_flag_r,g_axk07
#       IF SQLCA.sqlcode THEN 
#          LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
#          CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_axg_misc_1',SQLCA.sqlcode,1) 
#          LET g_success = 'N' 
#          CONTINUE FOREACH  
#       END IF
#   
#       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
#
#       #---FUN-A90026 start--寫入temp table之前先判斷幣別是否同於合併主體
#       #不相同時如果為損益類科目且axa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
#       SELECT axz06 INTO l_axz06_axf16 
#         FROM axz_file
#        WHERE axz01 = g_axf.axf16   #合併主體幣別
#       IF g_axg.axg12 != l_axz06_axf16 THEN 
#           SELECT aag04 INTO l_aag04
#            FROM aag_file
#            WHERE aag00=g_aaz641
#              AND aag01=g_axg.axg05
#           #依科目性質來判斷取"現時"或"平均"匯率
#           IF l_aag04 = '1' THEN   
#               CALL p001_getrate('1',tm.yy,tm.em,
#                                 g_axg.axg12,l_axz06_axf16)  
#               RETURNING l_rate
#               LET g_axg.axg08 = g_axg.axg08  * l_rate   #TQC-AA0098
#           ELSE
#               #--FUN-AA0093 start--
#               IF g_up_axf10 > 0 THEN    #大於0代表不是最下層
#                   CALL p001_getrate('3',tm.yy,tm.em,
#                                     g_axg.axg12,l_axz06_axf16)
#                   RETURNING l_rate
#                   IF cl_null(l_rate) THEN LET l_rate = 1 END IF   #101023
#                   LET g_axg.axg08 = g_axg.axg08  * l_rate  #101016
#               ELSE
#               #--FUN-AA0093 end--
#                   #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
#                   #                     來源或目的/aej_file or aek_file/合併主體幣別
#                   CALL p001_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
#               END IF   #FUN-AA0093
#           END IF
#       END IF
#       #---FUN-A90026 end----
#
#       #先將資料寫進TempTable裡 
#       EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axg.axg05,
#                                 g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                 g_axg.axg12,            #FUN-A30079 
#                                 g_affil,g_dc,g_flag_r
#     END FOREACH
##---FUN-A80137 end------------------------------------
#
#
###------FUN-A80137 mark----------------------------
##          CASE WHEN p_axf01 = 'MISC' AND p_axf02 = 'MISC'
##                LET l_sql = l_sql CLIPPED,
##                "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
##                #"                   WHERE axs00 = '",g_aaz641,"'",     #FUN-920067
##                "                   WHERE axs00 = '",g_aaz641_axf09,"'",   #FUN-A30079
##                "                     AND axs01 = '",g_axf.axf01,"'",
##                "                     AND axs09 = '",g_axf.axf09,"'",
##                "                     AND axs10 = '",g_axf.axf10,"'",
##                #"                    AND axs12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND axs12 = '",g_aaz641_axf10,"'",   #FUN-A30079
##                "                     AND axs13 = '",g_axf.axf13,"')"  #FUN-930117
###                IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark  #FUN-A60038 mark  #FUN-A60038 mark  #FUN-A60038 mark
##                    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                    "  UNION ",
##                    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-931044 mod
##                    #"       '",l_axz08,"','1','N' " 
##                    #"        '",l_axz06_axf10,"','",l_axz08,"','1','N' "             #FUN-A30079
##                    "        axg12,'",l_axz08,"','1','N' "        #FUN-A60038 mod
##
## #----FUN-A60038 mark-------------------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y'  THEN 
## #                    #    LET l_sql = l_sql CLIPPED,     
## #                    #    "  UNION ",
## #                    #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-931044 mod
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "             #FUN-A30079
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,  
## #                        "  UNION ",
## #                        " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,",  #FUN-931044 mod
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N' " 
## #                    #END IF  FUN-A40026 mark
## #                END IF
## #-----FUN-A60038 mark--------------------
##
##                LET l_sql = l_sql CLIPPED, 
##                #--FUN-A30079 end-----
##                "   FROM axg_file ",
##                "  WHERE axg01 ='",g_axa[i].axa01,"' ",
##                #"   AND axg02 = '",g_axa[i].axa02,"'",               #FUN-970046 add
##                #"    AND axg02 = '",tm.axa02,"'",                     #FUN-A30064  #FUN-A30079 mark 
##                #"   AND axg00 ='",g_aaz641,"' ",                     #FUN-760053   #FUN-920067 mod
##                "    AND axg00 ='",g_aaz641_axf10,"' ",                  #FUN-A30079
##                #"    AND axg12 ='",x_aaa03,"' ",                      #FUN-760053   #FUN-A30079 mark 
##                "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
##                "    AND axg041='",l_axf10_axz05,"' ",                 #對沖帳別  #FUN-920067
##                "    AND axg06 = ",tm.yy,
##                "    AND axg07 = '",tm.em,"'",                         #FUN-970046 mod
##                "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
##                #"                  WHERE axt00 = '",g_aaz641,"'",     #FUN-920067 mod
##                "                   WHERE axt00 = '",g_aaz641_axf09,"'",  #FUN-A30079
##                "                     AND axt01 = '",g_axf.axf02,"'",
##                "                     AND axt09 = '",g_axf.axf09,"'",
##                "                     AND axt10 = '",g_axf.axf10,"'",
##                #"                    AND axt12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND axt12 = '",g_aaz641_axf10,"'",  #FUN-A30079
##                "                     AND axt13 = '",g_axf.axf13,"'",  #FUN-930117
##                "                     AND axt04 != 'Y') "              #是否依據公式設定
##                #--FUN-A30079 start--
##                #"  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                #--FUN-A60060 mark--
##                #IF g_cnt_axf10 > 0 THEN  
##                #    LET l_sql = l_sql CLIPPED,
##                #        "    AND axg02 = '",g_axf.axf10,"'", 
##                #        "  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                #END IF                    
##                #--FUN-A60060 mark--
##          WHEN p_axf01 = 'MISC' AND p_axf02 != 'MISC'
##                LET l_sql = l_sql CLIPPED,
##                "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
##                #"                  WHERE axs00 = '",g_aaz641,"'",     #FUN-920067
##                "                   WHERE axs00 = '",g_aaz641_axf09,"'",  #FUN-A30079
##                "                     AND axs01 = '",g_axf.axf01,"'",
##                "                     AND axs09 = '",g_axf.axf09,"'",
##                "                     AND axs10 = '",g_axf.axf10,"'",
##                #"                    AND axs12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND axs12 = '",g_aaz641_axf10,"'",  #FUN-A30079
##                "                     AND axs13 = '",g_axf.axf13,"')"  #FUN-930117
###                IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                    "  UNION ",
##                    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-931044 mod
##                    #"        '",l_axz08,"','1','N' ",  #FUN-920167
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N' "  #FUN-A30079 mod
##                     "         axg12,'",l_axz08,"','1','N' "                #FUN-A60038 mod
## #-----FUN-A60038 mark----------------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,    
## #                    #    "  UNION ",
## #                    #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,  
## #                        "  UNION ",
## #                        " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N' " 
## #                    #END IF   #FUN-A40026 mark
## #                END IF
## #----------FUN-A60038 mark----------
## 
##                  LET l_sql = l_sql CLIPPED, 
##                  #--FUN-A30079 end----
##                  "   FROM axg_file ",
##                  "  WHERE axg01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axg02 = '",g_axa[i].axa02,"'",                    #FUN-970046 add
##                 #"    AND axg02 = '",tm.axa02,"'",                          #FUN-A30064 #FUN-A30079 mark  
##                 #"   AND axg00 ='",g_aaz641,"' ",                          #FUN-760053   #FUN-920067 mod
##                 "    AND axg00 ='",g_aaz641_axf10,"' ",                       #FUN-A30079
##                 #"   AND axg12 ='",x_aaa03,"' ",                           #FUN-760053   #FUN-A30079 mark
##                 "    AND axg04 ='",g_axf.axf10,"' ",                       #對沖公司
##                 "    AND axg041='",l_axf10_axz05,"' ",                     #對沖帳別  #FUN-920067
##                 "    AND axg06 = ",tm.yy,
##                 "    AND axg07 = '",tm.em,"'",                             #FUN-970046 mod
##                 "    AND axg05 = '",g_axf.axf02,"'"                        #FUN-970046 mod
##                 #---FUN-A60060 mark---------
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 #IF g_cnt_axf10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axg02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 #END IF
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark----
## 
##            WHEN p_axf01 != 'MISC' AND p_axf02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axg05 = '",g_axf.axf01,"'"
## #                IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079 #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,", 
##                     #"       '",l_axz08,"','1','N' "
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N' "  #FUN-A30079 mod
##                     "        axg12,'",l_axz08,"','1','N' "  #FUN-A60038 mod
## 
## #---------FUN-A60038 mark--------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED, 
## #                    #    "  UNION ",
## #                    #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,
## #                        "  UNION ",
## #                        " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #------------FUN-A60038 mark-----------
## 
##                 LET l_sql = l_sql CLIPPED, 
##                 #--FUN-A30079 end---
##                 "   FROM axg_file ",
##                 "  WHERE axg01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axg02 = '",g_axa[i].axa02,"'",  #FUN-970046 add
##                 #"    AND axg02 = '",tm.axa02,"'",        #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND axg00 ='",g_aaz641,"' ", 
##                 "    AND axg00 ='",g_aaz641_axf10,"' ",     #FUN-A30079
##                 #"    AND axg12 ='",x_aaa03,"' ",         #FUN-A30079  mark 
##                 "    AND axg04 ='",g_axf.axf10,"' ",      #對沖公司
##                 "    AND axg041='",l_axf10_axz05,"' ",    #對沖帳別  
##                 "    AND axg06 = ",tm.yy,
##                 "    AND axg07 = '",tm.em,"'",            #FUN-970046 mod
##                 "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
##                 #"                  WHERE axt00 = '",g_aaz641,"'",  
##                 "                   WHERE axt00 = '",g_aaz641_axf09,"'",    #FUN-A30079
##                 "                     AND axt01 = '",g_axf.axf02,"'",
##                 "                     AND axt09 = '",g_axf.axf09,"'",
##                 "                     AND axt10 = '",g_axf.axf10,"'",
##                 #"                    AND axt12 = '",g_aaz641,"'", 
##                 "                     AND axt12 = '",g_aaz641_axf10,"'",    #FUN-A30079
##                 "                     AND axt13 = '",g_axf.axf13,"'",
##                 "                     AND axt04 != 'Y') "     #是否依據公式設定
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 ##IF g_cnt_axf10 > 0 THEN   #FUN-A60060 mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axg02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 #END IF                     #FUN-A60060 add
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark--
## 
##            WHEN p_axf01 != 'MISC' AND p_axf02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axg05 = '",g_axf.axf01,"'"
## #                IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079 #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,", 
##                     #"       '",l_axz08,"','1','N' ",
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N' "  #FUN-A30079 mod
##                     "        axg12,'",l_axz08,"','1','N' "                 #FUN-A60038 mod
## 
## #-----FUN-A60038 mark-----
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,    
## #                    #    "  UNION ",
## #                    #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,       
## #                        "  UNION ",
## #                        " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N' "  
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #-----FUN-A60038 mark--------
## 
##                 LET l_sql = l_sql CLIPPED,     
##                 "   FROM axg_file ",
##                 "  WHERE axg01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axg02 = '",g_axa[i].axa02,"'", 　 　#FUN-970046 add
##                 #"    AND axg02 = '",tm.axa02,"'",        　  #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND axg00 ='",g_aaz641,"' ", 
##                 "    AND axg00 ='",g_aaz641_axf10,"' ",         #FUN-A30079
##                 #"   AND axg12 ='",x_aaa03,"' ",             #FUN-A30079 mark
##                 "    AND axg04 ='",g_axf.axf10,"' ",          #對沖公司
##                 "    AND axg041='",l_axf10_axz05,"' ",        #對沖帳別  
##                 "    AND axg06 = ",tm.yy,
##                 "    AND axg07 = '",tm.em,"'",                #FUN-970046 mod
##                 "    AND axg05 = '",g_axf.axf02,"'"                            #FUN-970046 mod
##                 #--FUN-A60060 mark----
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 #IF g_cnt_axf10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axg02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##                 #END IF                 
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark---
##           END CASE
##           #--FUN-A60060 start---
##           #A.來源公司=合併主體：(順流)
##           #  目的:axg02 = 自己的上層公司(l_axa02_axf10), axg04 = 自己
##           #B.來源公司 <> 合併主體：(側流或逆流)
##           #  IF 目的屬於上層公司
##           #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
##           #    2.中間層(有上層也有下層):
##           #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
##           #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
##           #  ELSE
##           #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
##           #  END IF
## 
##           #--FUN-A70011 mark--
##           #IF g_axf.axf09 = g_axf.axf16 THEN     #FUN-A60078
##           #    IF g_axf.axf14 = 'Y' THEN         #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,        #FUN-A60078
##           #            "    AND axg02 = '",l_axa02_axf10,"'"   #FUN-A60078
##           #    ELSE                                            #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,                  #FUN-A60099
##           #            "    AND axg02 = '",g_axf.axf10,"'"     #FUN-A60099
##           #    END IF
##           #ELSE                                  #FUN-A60078
##           #--FUN-A70011 mark--
##               IF g_cnt_axf10 > 0 THEN
##                   IF l_low_axf10 = 0 THEN #最上層
##                       LET l_sql = l_sql CLIPPED,
##                           "    AND axg02 = '",g_axf.axf10,"'"
##                   ELSE
##                       IF l_up_axf10 > 0 THEN    #FUN-A60078  #大於0代表不是最下層 
##                           IF g_axf.axf14 = 'Y' THEN                     #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,
##                                   "    AND axg02 = '",l_axa02_axf10,"'"
##                           ELSE                                          #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,                #FUN-A60099
##                                   "    AND axg02 = '",g_axf.axf10,"'"   #FUN-A60099
##                           END IF                                        #FUN-A60099
##                       END IF                    #FUN-A60078
##                   END IF
##               #-FUN-A70011 start-
##               ELSE
##                   LET l_sql = l_sql CLIPPED,
##                   "    AND axg02 = '",l_axa02_axf10,"'"
##               #-FUN-A70011 end--
##               END IF
##           #END IF          #FUN-A70011 mark
##           LET l_sql = l_sql CLIPPED,
##                "  ORDER BY axg06,axg07,axg05,axg02,axg04 "
##           #--FUN-A60060 end--------
##     ELSE
##          #---資料來源為axk_file--------------
##           #IF g_cnt_axf09 > 0 THEN   #來源公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##               LET l_sql =" SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ", 
##                          #"        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N',axk07 " #FUN-A30079 add axk14
##                          "        axk14,'",l_axz08_axf10,"','2','N',axk07 "                #FUN-A60038 mod
## #-------FUN-A60038 mark------------
## #          #--FUN-A30079 start--
## #          ELSE
## #              #FUN-A40026 mark
## #              #IF g_axf.axf14 = 'Y' THEN
## #              #    LET l_sql =" SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ",
## #              #               "        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N',axk07 "
## #              #ELSE
## #              #FUN-A40026 mark
## #                  LET l_sql =" SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19), ", 
## #                             "        '",l_axz06_axf09,"','",l_axz08_axf10,"','2','N',axk07 "
## #              #END IF  #FUN-A40026 mark
## #          END IF
## #------------FUN-A60038 mark----------
## 
##            LET l_sql = l_sql CLIPPED,    
##            #---FUN-A30079 end----
##                      "   FROM axk_file ",
##                      "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
##                      #"   AND axk00 ='",g_aaz641,"' ",          #合併帳別
##                      "    AND axk00 ='",g_aaz641_axf09,"' ",       #FUN-A30079
##                      #"   AND axk02 = '",g_axa[i].axa02,"'",    #FUN-970046 add
##                      #"    AND axk02 = '",tm.axa02,"'",          #FUN-A30064  #FUN-A30079 mark 
##                      #"    AND axk14 ='",x_aaa03,"' ",           #幣別        #FUN-A30079 mark 
##                      "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
##                      "    AND axk041='",l_axf09_axz05,"' ",     #來源帳別 
##                      "    AND axk08 = ",tm.yy,         #年度
##                      "    AND axk07 = '",l_axz08_axf10 ,"'",    #FUN-960096
##                      "    AND axk09 = '",tm.em,"'"              #FUN-970046 mod
## 
##                      #---FUN-A60060 start---
##                      #A.來源公司=合併主體：(順流)
##                      #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
##                      #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
##                      #B.來源公司 <> 合併主體：(側流或逆流)
##                      #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
##                      #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
##                      #    2.中間層(有上層也有下層):
##                      #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
##                      #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
##                      #  ELSE
##                      #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
##                      #  END IF
##                       IF g_axf.axf09 = g_axf.axf16 THEN
##                           #--FUN-A70011 start-
##                           IF g_axf.axf14 = 'Y' THEN
##                               LET l_sql = l_sql CLIPPED,
##                               "    AND axk02 = '",l_axa02_axf09,"'"
##                           ELSE
##                           #--FUN-A70011 end--
##                               LET l_sql = l_sql CLIPPED,
##                               "    AND axk02 = '",g_axf.axf09,"'" 
##                           END IF    #FUN-A70011 
##                       ELSE
##                           IF g_cnt_axf09 > 0 THEN
##                               IF l_low_axf09 = 0 THEN #最上層
##                                   LET l_sql = l_sql CLIPPED,
##                                       "    AND axk02 = '",g_axf.axf09,"'" 
##                               ELSE
##                                   IF g_axf.axf14 = 'Y' THEN     #FUN-A60099
##                                       LET l_sql = l_sql CLIPPED,
##                                           "    AND axk02 = '",l_axa02_axf09,"'" 
##                                   ELSE                                           #FUN-A60099
##                                       LET l_sql = l_sql CLIPPED,                 #FUN-A60099
##                                           "    AND axk02 = '",g_axf.axf09,"'"    #FUN-A60099
##                                   END IF                                         #FUN-A60099
##                               END IF
##                           #--FUN-A70011 start-
##                           ELSE
##                                LET l_sql = l_sql CLIPPED,
##                                "    AND axk02 = '",l_axa02_axf09,"'"
##                           #--FUN-A70011 end--
##                           END IF  
##                       END IF
##                      #--FUN-A60060 end--------
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 #IF g_cnt_axf09 > 0 THEN
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axk02 = '",g_axf.axf09,"'" 
##                 #END IF
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark---
##           CASE WHEN p_axf01 = 'MISC' AND p_axf02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
##                 #"                  WHERE axs00 = '",g_aaz641,"'", 
##                 "                   WHERE axs00 = '",g_aaz641_axf09,"'",   #FUN-A30079
##                 "                     AND axs01 = '",g_axf.axf01,"'",
##                 "                     AND axs09 = '",g_axf.axf09,"'",
##                 "                     AND axs10 = '",g_axf.axf10,"'",
##                 #"                    AND axs12 = '",g_aaz641,"'",
##                 "                     AND axs12 = '",g_aaz641_axf10,"'",   #FUN-A30079
##                 "                     AND axs13 = '",g_axf.axf13,"')"  #FUN-930117
## #                IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ", 
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "       #FUN-A30079 add axk14
##                     "        axk14,'",l_axz08,"','1','N',axk07 "                      #FUN-A60038 mod
## 
## #----------FUN-A60038 mark----
## #                #--FUN-A30079 start-
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y'  THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT axk08,axk09,axk05,axk02,axk04,(axg10-axk11)*-1, ",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,      
## #                        "  UNION ",
## #                        " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1, ", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 " 
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #--------FUN-A60038 mark---------
## 
##                 LET l_sql = l_sql CLIPPED,      
##                 #--FUN-A30079 end----
##                 "   FROM axk_file ",
##                 "  WHERE axk01 ='",g_axa[i].axa01,"' ",
##                 #"    AND axk00 ='",g_aaz641,"' ", 
##                 "    AND axk00 ='",g_aaz641_axf10,"' ",     #FUN-A30079
##                 #"   AND axk02 = '",g_axa[i].axa02,"'",  #FUN-970046 add
##                 #"    AND axk02 = '",tm.axa02,"'",        #FUN-A30064  #FUN-A30079 MARK 
##                 #"    AND axk14 ='",x_aaa03,"' ",         #FUN-760053  #FUN-A30079 mark 
##                 "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
##                 "    AND axk041='",l_axf10_axz05,"' ",    #對沖帳別  
##                 "    AND axk08 = ",tm.yy,
##                 "    AND axk07 = '",l_axz08,"'",          #FUN-960096
##                 "    AND axk09 = '",tm.em,"'",            #FUN-970046 mod
##                 "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
##                 #"                   WHERE axt00 = '",g_aaz641,"'", 
##                 "                   WHERE axt00 = '",g_aaz641_axf09,"'",   #FUN-A30079
##                 "                     AND axt01 = '",g_axf.axf02,"'",
##                 "                     AND axt09 = '",g_axf.axf09,"'",
##                 "                     AND axt10 = '",g_axf.axf10,"'",
##                 #"                    AND axt12 = '",g_aaz641,"'", 
##                 "                     AND axt12 = '",g_aaz641_axf10,"'",   #FUN-A30079
##                 "                     AND axt13 = '",g_axf.axf13,"'",
##                 "                     AND axt04 != 'Y') "    #是否依據公式設定
## 　　　　　　　　#--FUN-A60060 mark--　　　　　　
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 #IF g_cnt_axf10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axk02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axk08,axk09,axk05,axk02,axk04 " 
##                 #END IF                 
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
##            WHEN p_axf01 = 'MISC' AND p_axf02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
##                 #"                  WHERE axs00 = '",g_aaz641,"'", 
##                 "                   WHERE axs00 = '",g_aaz641_axf09,"'",   #FUN-A30079
##                 "                     AND axs01 = '",g_axf.axf01,"'",
##                 "                     AND axs09 = '",g_axf.axf09,"'",
##                 "                     AND axs10 = '",g_axf.axf10,"'",
##                 #"                    AND axs12 = '",g_aaz641,"'",
##                 "                     AND axs12 = '",g_aaz641_axf10,"'",   #FUN-A30079
##                 "                     AND axs13 = '",g_axf.axf13,"')"
##                 #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,", 
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "       #FUN-A30079 add axk14
##                     "        axk14,'",l_axz08,"','1','N',axk07 "       #FUN-A60038
## #-----FUN-A60038 mark------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,           
## #                        "  UNION ",
## #                        " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1,", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 " 
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #------FUN-A60038 mark--------
## 
##                 LET l_sql = l_sql CLIPPED,          
##                 #--FUN-A30079 end---- 
##                 "   FROM axk_file ",
##                 "  WHERE axk01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axk02 = '",g_axa[i].axa02,"'",             #FUN-970046 add
##                 #"   AND axk02 = '",tm.axa02,"'",                   #FUN-A30064 #FUN-A30079 mark
##                 #"    AND axk00 ='",g_aaz641,"' ", 
##                 "    AND axk00 ='",g_aaz641_axf10,"' ",                #FUN-A30079
##                 #"   AND axk14 ='",x_aaa03,"' ",                    #FUN-760053 #FUN-A30079 mark 
##                 "    AND axk04 ='",g_axf.axf10,"' ",                 #對沖公司
##                 "    AND axk041='",l_axf10_axz05,"' ",               #對沖帳別  
##                 "    AND axk08 = ",tm.yy,
##                 "    AND axk07 = '",l_axz08,"'",                     #FUN-960096
##                 "    AND axk09 = '",tm.em,"'",                       #FUN-970046 mod
##                 "    AND axk05 = '",g_axf.axf02,"'"                  #FUN-970046 mod
##                 #--FUN-A60060 mark---
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 #IF g_cnt_axf10 > 0 THEN  
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axk02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
## 
##            WHEN p_axf01 != 'MISC' AND p_axf02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axk05 = '",g_axf.axf01,"'"
##                 #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ", 
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "       #FUN-A30079 add axk14
##                     "        axk14,'",l_axz08,"','1','N',axk07 "       #FUN-A60038 mod
## #-------FUN-A60038 mark------------
## #                #--FUN-A30079 start--
## #                ELSE 
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED, 
## #                        "  UNION ",
## #                        " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1, ", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "  
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #---------FUN-A60038 mark----------
## 
##                 LET l_sql = l_sql CLIPPED, 
##                 #--FUN-A30079 end----
##                 "   FROM axk_file ",
##                 "  WHERE axk01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axk02 = '",g_axa[i].axa02,"'",  #FUN-970046 add
##                 #"    AND axk02 = '",tm.axa02,"'",        #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND axk00 ='",g_aaz641,"' ", 
##                 "    AND axk00 ='",g_aaz641_axf10,"' ",     #FUN-A30079
##                 #"    AND axk14 ='",x_aaa03,"' ",         #FUN-760053  #FUN-A30079 mark 
##                 "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
##                 "    AND axk041='",l_axf10_axz05,"' ",    #對沖帳別  
##                 "    AND axk08 = ",tm.yy,
##                 "    AND axk07 = '",l_axz08,"'",
##                #"    AMD axk09 = '",tm.em,"'",            #FUN-970046 mod  #MOD-A40158 mark
##                 "    AND axk09 = '",tm.em,"'",            #MOD-A40158 add
##                 "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
##                 #"                   WHERE axt00 = '",g_aaz641,"'",  
##                 "                   WHERE axt00 = '",g_aaz641_axf09,"'",    #FUN-A30079
##                 "                     AND axt01 = '",g_axf.axf02,"'",
##                 "                     AND axt09 = '",g_axf.axf09,"'",
##                 "                     AND axt10 = '",g_axf.axf10,"'",
##                 #"                    AND axt12 = '",g_aaz641,"'", 
##                 "                     AND axt12 = '",g_aaz641_axf10,"'",    #FUN-A30079
##                 "                     AND axt13 = '",g_axf.axf13,"'",
##                 "                     AND axt04 != 'Y') "     #是否依據公式設定
##                 #---FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 ##IF g_cnt_axf10 > 0 THEN    #FUN-A60060  mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axk02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #---FUN-A60060 mark--
## 
##            WHEN p_axf01 != 'MISC' AND p_axf02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND axk05 = '",g_axf.axf01,"'"
##                 #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,", 
##                     #"        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "       #FUN-A30079 add axk14
##                     "        axk14,'",l_axz08,"','1','N',axk07 "       #FUN-A60038 mod
## 
## #----------FUN-A60038 mark-------------
## #                #--FUN-A30079 start
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_axf.axf14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,",
## #                    #    "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 " 
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,    
## #                        "  UNION ",
## #                        " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1,", 
## #                        "        '",l_axz06_axf10,"','",l_axz08,"','1','N',axk07 "
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #----------FUN-A60038 mark--------------
## 
##                 LET l_sql = l_sql CLIPPED,    
##                 #--FUN-A30079 end---
##                 "   FROM axk_file ",
##                 "  WHERE axk01 ='",g_axa[i].axa01,"' ",
##                 #"   AND axk02 = '",g_axa[i].axa02,"'",              #FUN-970046 add
##                 #"    AND axk02 = '",tm.axa02,"'",                    #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND axk00 ='",g_aaz641,"' ", 
##                 "    AND axk00 ='",g_aaz641_axf10,"' ",                  #FUN-A30079
##                 #"    AND axk14 ='",x_aaa03,"' ",                      #FUN-760053  #FUN-A30079 mark
##                 "    AND axk04 ='",g_axf.axf10,"' ",                  #對沖公司
##                 "    AND axk041='",l_axf10_axz05,"' ",                #對沖帳別  
##                 "    AND axk08 = ",tm.yy,
##                 "    AND axk07 = '",l_axz08,"'",                      #FUN-960096
##                 "    AND axk09 = '",tm.em,"'",                        #FUN-970046 mod
##                 "    AND axk05 = '",g_axf.axf02,"'"                   #FUN-970046 mod
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 ##IF g_cnt_axf10 > 0 THEN  #FUN-A6060 mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND axk02 = '",g_axf.axf10,"'", 
##                 #        "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
##           END CASE
##           #--FUN-A60060 start---
##           #A.來源公司=合併主體：(順流)
##           #  目的:axg02 = 不用加入此條件, axg04 = 自己
##           #B.來源公司 <> 合併主體：(側流或逆流)
##           #  IF 目的屬於上層公司
##           #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
##           #    2.中間層(有上層也有下層):
##           #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
##           #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
##           #  ELSE
##           #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
##           #  END IF
##            
##           #--FUN-A70011 mark--
##           #IF g_axf.axf09 = g_axf.axf16 THEN     #FUN-A60078
##           #    IF g_axf.axf14 = 'Y' THEN         #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,        #FUN-A60078
##           #            "    AND axk02 = '",l_axa02_axf10,"'"   #FUN-A60078
##           #    ELSE                                            #FUN-A60099
## 	  #        LET l_sql = l_sql CLIPPED,                  #FUN-A60099
## 	  #            "    AND axk02 = '",g_axf.axf10,"'"     #FUN-A60099
##           #    END IF                                          #FUN-A60099
##           #ELSE                                  #FUN-A60078
##           #--FUN-A70011 mark--
##               IF g_cnt_axf10 > 0 THEN
##                   IF l_low_axf10 = 0 THEN #最上層
##                       LET l_sql = l_sql CLIPPED,
##                           "    AND axk02 = '",g_axf.axf10,"'"
##                   ELSE
##                       IF l_up_axf10 > 0 THEN    #FUN-A60078   #大於0代表為中間層
##                           IF g_axf.axf14 = 'Y' THEN  #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,
##                                   "    AND axk02 = '",l_axa02_axf10,"'"
##                           ELSE                                           #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,                 #FUN-A60099
##                                   "    AND axk02 = '",g_axf.axf10,"'"    #FUN-A60099 
##                           END IF                                         #FUN-A60099
##                       END IF                    #FUN-A60078
##                   END IF
##               #--FUN-A70011 start-
##               ELSE
##                   LET l_sql = l_sql CLIPPED,
##                      "    AND axk02 = '",l_axa02_axf10,"'"
##               #--FUN-A70011 end--
##               END IF
##           #END IF    #FUN-A70011 mark
##           LET l_sql = l_sql CLIPPED,
##               "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
##           #--FUN-A60060 end--------
##     END IF
##
##     PREPARE p001_axg_misc_p1 FROM l_sql
##     IF STATUS THEN 
##        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                  
##
##        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
##        LET g_success = 'N'  
##     END IF 
##     DECLARE p001_axg_misc_c1 CURSOR FOR p001_axg_misc_p1
##     
##     FOREACH p001_axg_misc_c1 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
##                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
##                              g_axg.axg12,   #FUN-A30079 
##                              g_affil,g_dc,g_flag_r,g_axk07
##       IF SQLCA.sqlcode THEN 
##          LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
##          CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_axg_misc_1',SQLCA.sqlcode,1) 
##          LET g_success = 'N' 
##          CONTINUE FOREACH  
##       END IF
##       LET l_axz08 = ''
##   
##       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
##
##       #先將資料寫進TempTable裡 
##       EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axg.axg05,
##                                 g_axg.axg02,g_axg.axg04,g_axg.axg08,
##                                 g_axg.axg12,            #FUN-A30079 
##                                 g_affil,g_dc,g_flag_r
##     END FOREACH
##------FUN-A80137 mark----------------------------
#
#
#     IF p_axf02 = 'MISC' THEN
#         #IF p_axf15 = '1' THEN
#         IF p_axf17 = '1' THEN     #FUN-A80137 mod
#             #貸 子公司 少數股權,少數股權淨利
#             #依據公式設定(對沖科目中axt04=Y)
#             DECLARE p001_axt_cs CURSOR FOR
#                SELECT DISTINCT axt03,axt04,axt05 FROM axt_file 
#                 #WHERE axt00 = g_aaz641   #FUN-920067 mod
#                 WHERE axt00 = g_aaz641_axf09 #FUN-A30079
#                   AND axt01 = g_axf.axf02
#                   AND axt09 = g_axf.axf09
#                   AND axt10 = g_axf.axf10
#                   #AND axt12 = g_aaz641    #FUN-920067
#                   AND axt12 =  g_aaz641_axf10 #FUN-A30079
#                   AND axt04 = 'Y'             #是否依據公式設定]
#                   AND axt13 = g_axf.axf13 #FUN-930117
#             FOREACH p001_axt_cs INTO g_axu03
#                  #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                      LET l_sql =
#                      " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",     #MOD-910248  #FUN-930144 mod
#                      #"        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "  #FUN-A30079 add axg12
#                      #"        axg12,'",l_axz08_axf10,"','2','Y' "                #FUN-A60038 mod
#                      "        axg12,'",g_axz08_axf10,"','2','Y' "                 #FUN-A90006
# #---FUN-A60038 mark--
# #                  #---FUN-A30079 start--
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_axf.axf14 = 'Y' THEN 
# #                      #    LET l_sql =
# #                      #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",     #MOD-910248  #FUN-930144 mod
# #                      #    "        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "  #FUN-A30079 add axg12
# #                      #ELSE    
# #                      #FUN-A40026 mark
# #                          LET l_sql =
# #                           " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14),",    
# #                           "        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "
# #                      #END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark----
#                   LET l_sql = l_sql CLIPPED,
#                   #---FUN-A30079 end---
#                   "   FROM axg_file ",
#                   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#                   #"    AND axg00 ='",g_aaz641,"' ",     #FUN-760053   #FUN-920067 mod
#                   "    AND axg00 ='",g_aaz641_axf10,"' ",   #FUN-A30079
#                   #"   AND axg12 ='",x_aaa03,"' ",       #FUN-760053   #FUN-A30079 mark
#                   "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
#                   #"    AND axg041='",l_axf10_axz05,"' ", #對沖帳別  #FUN-920067
#                   "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別   #FUN-A90006
#                   "    AND axg06 = ",tm.yy,
#                   "    AND axg07 = '",tm.em,"'"          #FUN-970046 add
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark--
#                   #IF g_axf.axf09 = g_axf.axf16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND axg02 = '",l_axa02_axf10,"'"   #
#                   #ELSE
#                   #--FUN-A70011 mark--
#                       IF g_cnt_axf10 > 0 THEN
#                           #IF l_low_axf10 = 0 THEN #最上層
#                           IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND axg02 = '",g_axf.axf10,"'"
#                           ELSE
#                               #IF l_up_axf10 > 0 THEN
#                               IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND axg02 = '",l_axa02_axf10,"'"
#                                       "    AND axg02 = '",g_axa02_axf10,"'"    #FUN-A90006
#                               END IF
#                          END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND axg02 = '",l_axa02_axf10,"'"
#                           "    AND axg02 = '",g_axa02_axf10,"'"     #FUN-A90006
#                       END IF
#                       #--FUN-A70011 end--
#                   #END IF
# #---FUN-A60078 end--
#                   LET l_sql = l_sql CLIPPED,
#                   #--FUN-A30079 end----       
#                   "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                   #"                   WHERE axu00 = '",g_aaz641,"'",    #FUN-920067
#                   "                   WHERE axu00 = '",g_aaz641_axf09,"'",  #FUN-A30079
#                   "                     AND axu01 = '",g_axf.axf02,"'",
#                   "                     AND axu09 = '",g_axf.axf09,"'",
#                   "                     AND axu10 = '",g_axf.axf10,"'",
#                   #"                    AND axu12 = '",g_aaz641,"'",     #FUN-920067
#                   "                     AND axu12 = '",g_aaz641_axf10,"'",  #FUN-A30079
#                   "                     AND axu13 = '",g_axf.axf13,"'",　#FUN-930117
#                   "                     AND axu05 = '+'",
#                   "                     AND axu03 = '",g_axu03,"')"
#                   #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                   #--TQC-AA098 mark
#                   #    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                   #    "  UNION ",
#                   #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-930144 mod
#                   #    #"        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "    #FUN-A30079 add axg12
#                   #    #"        axg12,'",l_axz08_axf10,"','2','Y' "      #FUN-A60038 
#                   #    "        axg12,'",g_axz08_axf10,"','2','Y' "       #FUN-A90006
#                   #--TQC-AA0098 mark
# #----FUN-A60038 mark--
# #                 #--FUN-A30079 start--
#                   #ELSE
#                       #FUN-A40026 mark
#                       #IF g_axf.axf14 = 'Y' THEN
#                       #    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                       #    "  UNION ",
#                       #    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-930144 mod
#                       #    "        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "    #FUN-A30079 add axg12
#                       #ELSE
#                       #FUN-A40026 mark
#                           LET l_sql = l_sql CLIPPED,     
#                           "  UNION ",
#                           " SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,",  #FUN-930144 mod
#                           #"        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "
#                           "        '",g_axz06_axf10,"','",g_axz08_axf10,"','2','Y' "  #FUN-A90006
#                       #END IF  #FUN-A40026 mark
#                   #END IF
# #---FUN-A60038 mark----
#                   LET l_sql = l_sql CLIPPED,    
#                   #--FUN-A30079 end---
#                   "   FROM axg_file ",
#                   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#                   #"    AND axg00 ='",g_aaz641,"' ",
#                   "    AND axg00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                   #"   AND axg12 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
#                   #"    AND axg041='",l_axf10_axz05,"' ",   #對沖帳別 
#                   "    AND axg041='",g_axf10_axz05,"' ",   #對沖帳別   #FUN-A90006
#                   "    AND axg06 = ",tm.yy,
#                   "    AND axg07 = '",tm.em,"'",           #FUN-970046 add
#                   "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                   #"                   WHERE axu00 = '",g_aaz641,"'", 
#                   "                   WHERE axu00 = '",g_aaz641_axf09,"'",   #FUN-A30079
#                   "                     AND axu01 = '",g_axf.axf02,"'",
#                   "                     AND axu09 = '",g_axf.axf09,"'",
#                   "                     AND axu10 = '",g_axf.axf10,"'",
#                   #"                     AND axu12 = '",g_aaz641,"'",
#                   "                     AND axu12 = '",g_aaz641_axf10,"'",   #FUN-A30079
#                   "                     AND axu13 = '",g_axf.axf13,"'",
#                   "                     AND axu05 = '-'",
#                   "                     AND axu03 = '",g_axu03,"')"
#                   #--FUN-A30079 start--
#                   #"  ORDER BY axg06,axg07,axg05,axg02,axg04 " 
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark--
#                   #IF g_axf.axf09 = g_axf.axf16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND axg02 = '",l_axa02_axf10,"'" ,
#                   #                "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                   #ELSE
#                   #--FUN-A70011 mark--
#                       IF g_cnt_axf10 > 0 THEN
#                           #IF l_low_axf10 = 0 THEN #最上層
#                           IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND axg02 = '",g_axf.axf10,"'" ,
#                                   "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                           ELSE
#                               #IF l_up_axf10 > 0 THEN
#                               IF g_up_axf10 > 0 THEN         #10027
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND axg02 = '",l_axa02_axf10,"'",
#                                       "    AND axg02 = '",g_axa02_axf10,"'",   #FUN-A90006
#                                       "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                               END IF
#                          END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND axg02 = '",l_axa02_axf10,"'",
#                           "    AND axg02 = '",g_axa02_axf10,"'",       #FUN-A90006
#                           "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#                   PREPARE p001_misc_p2 FROM l_sql
#                   IF STATUS THEN 
#                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
#                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
#                   DECLARE p001_misc_c2 CURSOR FOR p001_misc_p2
#      
#                   FOREACH p001_misc_c2 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
#                                             g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                             g_axg.axg12,   #FUN-A30079 
#                                             g_affil,g_dc,g_flag_r
#                      IF SQLCA.sqlcode THEN 
#                         LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
#                         CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_misc_c2',SQLCA.sqlcode,1)   #NO.FUN-710023
#                         LET g_success = 'N' 
#                         CONTINUE FOREACH  
#                      END IF
# 
#                      IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
# 
#                      #先將資料寫進TempTable裡 
#                      EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
#                                                g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                                g_axg.axg12,   #FUN-A30079 
#                                                g_affil,g_dc,g_flag_r
#                   END FOREACH
#              END FOREACH
#             # -- FUN-A90036 start--
#             IF g_axf.axf14 = 'Y' THEN 
#                 #--TQC-AA098 start-換匯差額的累換數是否加入沖銷分錄需依對沖設定
#                 DECLARE p001_axt_cs2 CURSOR FOR
#                    SELECT DISTINCT axt03 FROM axt_file
#                     WHERE axt00 = g_aaz641_axf09
#                       AND axt01 = g_axf.axf02
#                       AND axt09 = g_axf.axf09
#                       AND axt10 = g_axf.axf10
#                       AND axt12 = g_aaz641_axf10
#                       AND axt13 = g_axf.axf13
#                 FOREACH p001_axt_cs2 INTO l_axt03
#                     #---TQC-AA0098 end--
#                     DECLARE p001_adj_cs CURSOR FOR
#                      #SELECT axj03,axj05,(axj07-axj071) FROM p001_adj_tmp
#                      SELECT axj03,axj05,axj06,(axj07-axj071) FROM p001_adj_tmp    #TQC-AA0098
#                       #WHERE axj05 = g_axf.axf10        #TQC-AA0098 mark
#                           WHERE axj05 = g_axz08_axf10   #TQC-AA0098 mod
#                             AND axj03 = l_axt03         #TQC-AA0098 add
#
#                      #FOREACH p001_adj_cs INTO l_axj03,l_axj05,g_axg.axg08
#                      FOREACH p001_adj_cs INTO l_axj03,l_axj05,l_axj06,g_axg.axg08   #TQC-AA0098
#
#                        IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
#
#                        #LET g_affil  = g_axf.axf09
#                        LET g_affil  = l_axj05    #TQC-AA0098
#                        LET g_flag_r = 'N'
#                            #--TQC-AA0098 start-借貸需與換匯差額的累換相反加入對沖分錄 
#                            IF g_axg.axg08 < 0 THEN
#                                IF l_axj06 = '1' THEN LET g_dc = '1' ELSE LET g_dc = '2' END IF
#                            ELSE
#                                IF l_axj06 = '1' THEN LET g_dc = '2' ELSE LET g_dc = '1' END IF
#                            END IF
#                            #-TQC-AA0098 end--
#                        #先將資料進TempTable
#                        EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,l_axj03,
#                                                  g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                                  g_axg.axg12,
#                                                  g_affil,g_dc,g_flag_r
#                      END FOREACH
#                  END FOREACH   #TQC-AA0098 
#              END IF                 
#             # --FUN-A90036 end --  取出換匯差額的累換數值 ---
#          ELSE
#              #貸 子公司 少數股權,少數股權淨利
#              #依據公式設定(對沖科目中axt04=Y)
#              DECLARE p001_axt_cs1 CURSOR FOR
#                 SELECT DISTINCT axt03,axt04,axt05 FROM axt_file 
#                  #WHERE axt00 = g_aaz641   #FUN-920067 mod
#                  WHERE axt00 = g_aaz641_axf09 #FUN-A30079
#                    AND axt01 = g_axf.axf02
#                    AND axt09 = g_axf.axf09
#                    AND axt10 = g_axf.axf10
#                    #AND axt12 = g_aaz641    #FUN-920067
#                    AND axt12 = g_aaz641_axf10  #FUN-A30079
#                    AND axt04 = 'Y'             #是否依據公式設定]
#                    AND axt13 = g_axf.axf13 #FUN-930117
#              FOREACH p001_axt_cs1 INTO g_axu03
#                   #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                       LET l_sql =
#                       " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11),",  
#                       #"        '",l_axz06_axf10,"','",g_axf.axf10,"','2','Y' "         #FUN-A30079 add axk14
#                       "        axk14,'",g_axf.axf10,"','2','Y' "          #FUN-A60038 mod
# #----FUN-A60038 mark---
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_axf.axf14 = 'Y' THEN
# #                      #    LET l_sql =
# #                      #    " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11),",  
# #                      #    "        '",l_axz06_axf10,"','",g_axf.axf10,"','2','Y' "       
# #                      #ELSE
# #                      #FUN-A40026 mark
# #                          LET l_sql =
# #                          " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19),",  
# #                          "        '",l_axz06_axf10,"','",g_axf.axf10,"','2','Y' "
# #                     END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark---
#                   LET l_sql = l_sql CLIPPED,
#                   #---FUN-A30079 end----
#                   "   FROM axk_file ",
#                   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#                   #"    AND axk00 ='",g_aaz641,"' ",
#                   "    AND axk00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                   #"   AND axk14 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
#                   #"    AND axk041='",l_axf10_axz05,"' ", #對沖帳別  
#                   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    #FUN-A90006
#                   #"    AND axk07 = '",l_axz08,"'",       #FUN-960096
#                   "    AND axk07 = '",g_axz08,"'",       #FUN-960096  #FUN-A90006
#                   "    AND axk08 = ",tm.yy,
#                   "    AND axk09 = '",tm.em,"'"     #FUN-970046 add
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark
#                   #IF g_axf.axf09 = g_axf.axf16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND axk02 = '",l_axa02_axf10,"'"
#                   #ELSE
#                   #--FUN-A70011 mark
#                       IF g_cnt_axf10 > 0 THEN
#                           #IF l_low_axf10 = 0 THEN #最上層
#                           IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND axk02 = '",g_axf.axf10,"'"
#                           ELSE
#                               #IF l_up_axf10 > 0 THEN
#                               IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND axk02 = '",l_axa02_axf10,"'"
#                                       "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                               END IF
#                           END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND axk02 = '",l_axa02_axf10,"'"
#                           "    AND axk02 = '",g_axa02_axf10,"'"               #FUN-A90006
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#                   LET l_sql = l_sql CLIPPED,
#                   #--FUN-A30079 end----       
#                   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                   #"                   WHERE axu00 = '",g_aaz641,"'",  
#                   "                   WHERE axu00 = '",g_aaz641_axf09,"'",    #FUN-A30079
#                   "                     AND axu01 = '",g_axf.axf02,"'",
#                   "                     AND axu09 = '",g_axf.axf09,"'",
#                   "                     AND axu10 = '",g_axf.axf10,"'",
#                   #"                     AND axu12 = '",g_aaz641,"'",  
#                   "                     AND axu12 = '",g_aaz641_axf10,"'",    #FUN-A30079
#                   "                     AND axu13 = '",g_axf.axf13,"'",　
#                   "                     AND axu05 = '+'",
#                   "                     AND axu03 = '",g_axu03,"')"
#                   #IF g_cnt_axf10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                       LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                       "  UNION ",
#                       " SELECT axk08,axk09,axk05,axk02,axk04,(axk08-axk09)*-1,",
#                       #"        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "  #FUN-A30079 add axk14
#                       #"        axk14,'",l_axz08_axf10,"','2','Y' "   #FUN-A60038 mod
#                       "        axk14,'",g_axz08_axf10,"','2','Y' "   #FUN-A90006
# #----FUN-A60038 mark--
# #                  #--FUN-A30079 start---
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_axf.axf14 = 'Y' THEN
# #                      #    LET l_sql = l_sql CLIPPED,                       
# #                      #    "  UNION ",
# #                      #    " SELECT axk08,axk09,axk05,axk02,axk04,(axk08-axk09)*-1,",
# #                      #    "        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "
# #                      #ELSE
# #                      #FUN-A40026 mark
# #                          LET l_sql = l_sql CLIPPED,    
# #                          "  UNION ",
# #                          " SELECT axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1,",
# #                          "        '",l_axz06_axf10,"','",l_axz08_axf10,"','2','Y' "
# #                      #END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark---
#                   LET l_sql = l_sql CLIPPED,    
#                   #---FUN-A30079 end---
#                   "   FROM axk_file ",
#                   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#                   #"    AND axk00 ='",g_aaz641,"' ",
#                   "    AND axk00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                   #"   AND axk14 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
#                   #"    AND axk041='",l_axf10_axz05,"' ", #對沖帳別 
#                   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    #FUN-A90006
#                   "    AND axk08 = ",tm.yy,
#                   #"    AND axk07 = '",l_axz08,"'",  #FUN-960096
#                   "    AND axk07 = '",g_axz08,"'",  #FUN-960096       #FUN-A90006
#                   "    AND axk09 = '",tm.em,"'",    #FUN-970046 add
#                   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                   #"                   WHERE axu00 = '",g_aaz641,"'", 
#                   "                   WHERE axu00 = '",g_aaz641_axf09,"'",   #FUN-A30079
#                   "                     AND axu01 = '",g_axf.axf02,"'",
#                   "                     AND axu09 = '",g_axf.axf09,"'",
#                   "                     AND axu10 = '",g_axf.axf10,"'",
#                   #"                    AND axu12 = '",g_aaz641,"'",
#                   "                     AND axu12 = '",g_aaz641_axf10,"'",   #FUN-A30079
#                   "                     AND axu13 = '",g_axf.axf13,"'",
#                   "                     AND axu05 = '-'",
#                   "                     AND axu03 = '",g_axu03,"')"
#                   #--FUN-A30079 start--
#                   #"  ORDER BY axk08,axk09,axk05,axk02,axk04 "
# #--FUN-A60078 start-- 
#                   #--FUN-A70011 mark-
#                   #IF g_axf.axf09 = g_axf.axf16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND axk02 = '",l_axa02_axf10,"'",
#                   #                "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
#                   #ELSE
#                   #--FUN-A70011 mark-
#                       IF g_cnt_axf10 > 0 THEN
#                           #IF l_low_axf10 = 0 THEN #最上層
#                           IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND axk02 = '",g_axf.axf10,"'" ,
#                                   "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
#                           ELSE
#                               #IF l_up_axf10 > 0 THEN
#                               IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND axk02 = '",l_axa02_axf10,"'",
#                                       "    AND axk02 = '",g_axa02_axf10,"'",   #FUN-A90006
#                                       "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
#                               END IF
#                           END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND axk02 = '",l_axa02_axf10,"'"
#                           "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#
#                  PREPARE p001_misc_p3 FROM l_sql
#                  IF STATUS THEN 
#                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
#                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
#                  #DECLARE p001_misc_c3 CURSOR FOR p001_misc_p2
#                  DECLARE p001_misc_c3 CURSOR FOR p001_misc_p3   #FUN-A80130
#     
#                  FOREACH p001_misc_c3 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
#                                            g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                            g_axg.axg12,   #FUN-A30079 
#                                            g_affil,g_dc,g_flag_r
#                     IF SQLCA.sqlcode THEN 
#                        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
#                        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_misc_c3',SQLCA.sqlcode,1)   #NO.FUN-710023
#                        LET g_success = 'N' 
#                        CONTINUE FOREACH  
#                     END IF
#
#                     IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
#
#                     #先將資料寫進TempTable裡 
#                     EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
#                                               g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                               g_axg.axg12,   #FUN-A30079
#                                               g_affil,g_dc,g_flag_r
#                  END FOREACH
#             END FOREACH 
#         END IF          
#     END IF    
#
#     DECLARE p001_tmp_cs CURSOR FOR
#        #SELECT axg06,axg07,axg05,axg02,axg04,SUM(axg08),affil,dc,flag_r
#        SELECT axg06,axg07,axg05,axg02,axg04,SUM(axg08),axg12,affil,dc,flag_r   #FUN-A30079
#          FROM p001_tmp
#         #GROUP BY axg06,axg07,axg05,axg02,axg04,affil,dc,flag_r
#         GROUP BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r  #FUN-A30079
#         #ORDER BY axg06,axg07,axg05,axg02,axg04,affil,dc,flag_r
#         ORDER BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r  #FUN-A30079
#                 #年    月
#     LET g_axg07_o = '' 
#     FOREACH p001_tmp_cs INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
#                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                              g_axg.axg12,   #FUN-A30079
#                              g_affil,g_dc,g_flag_r
#        IF SQLCA.sqlcode THEN 
#           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
#           CALL s_errmsg('axk01,axk04,axk041,axk08',g_showmsg,'p001_tmp_cs',SQLCA.sqlcode,1)   #NO.FUN-710023
#           LET g_success = 'N'
#           CONTINUE FOREACH 
#        END IF
#
#        CALL s_ymtodate(g_axg.axg06,g_axg.axg07,g_axg.axg06,g_axg.axg07)
#               RETURNING g_bdate,g_edate
#
#        IF NOT cl_null(g_axg07_o) AND g_axg07_o<>g_axg.axg07 AND 
#           NOT cl_null(g_axi.axi01) THEN
#           CALL p001_ins_axj2()   #寫入差異分錄
#           IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF   #FUN-770069 add
#        END IF
#
#        #--a抓持股比率
#        CALL get_rate()  
#        
#        LET l_cnt = 0
#        
#        SELECT COUNT(*) INTO l_cnt FROM axi_file  #判斷是否已存在單頭
#         WHERE axi00 = g_aaz641      #帳別   #FUN-920067
#           AND axi02 = g_edate       #單據日期
#           AND axi03 = g_axg.axg06   #調整年度
#           AND axi04 = g_axg.axg07   #調整月份
#           AND axi05 = tm.axa01      #族群編號
#          #AND axi06 = tm.axa02      #上層公司編號
#           AND axi06 = g_axf.axf16   #合併主體公司編號  #FUN-A30079
#           AND axi07 = tm.axa03      #上層帳別
#           AND axi08 = '2'           #資料來源-2.資料匯入   #FUN-770069 add
#           AND axi21 = tm.ver        #MOD-930210 add
#           AND axi081 = '1'          #FUN-A90036
#           AND axi09 = 'N'           #FUN-A90036 
#        IF l_cnt = 0 THEN     #沒有符合的資料才要新增
#           LET g_yy=g_axg.axg06 
#           LET g_mm=g_axg.axg07 
#           CALL p001_ins_axi() 
#        ELSE                  #取出單頭資料以供後續寫入axj時用
#           SELECT * INTO g_axi.* FROM axi_file
#            WHERE axi00 = g_aaz641   #FUN-920067
#              AND axi02 = g_edate
#              AND axi03 = g_axg.axg06
#              AND axi04 = g_axg.axg07
#              AND axi05 = tm.axa01
#             #AND axi06 = tm.axa02
#              AND axi06 = g_axf.axf16   #FUN-A30079
#              AND axi07 = tm.axa03
#              AND axi08 = '2'           #FUN-770069 add
#              AND axi081 = '1'          #FUN-A90036
#              AND axi21 = tm.ver        #MOD-930210 add
#              AND axi09 = 'N'           #FUN-A90036 
#        END IF
#        
#        #-->寫入調整與銷除分錄底稿單身
#        IF NOT cl_null(g_axi.axi01) THEN    #當單頭檔(axi_file)的傳票號碼(axi01)有值石才需計算差異
#           CALL p001_ins_axj1()
#        END IF
#        IF g_success = 'N' THEN RETURN  END IF
#        LET g_axg07_o=g_axg.axg07   #期別舊值備份
#     END FOREACH
#
#     #當單頭檔(axi_file)的傳票號碼(axi01)有值時才需計算差異
#     IF NOT cl_null(g_axi.axi01) THEN    
#        CALL p001_ins_axj2()   #寫入差異分錄
#     END IF
#     IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF
#     LET p_axf01 = ''
#     LET p_axf02 = ''
#END FUNCTION
#luttb-----mark--end

FUNCTION p001_chkaah(p_aah01,p_aah03,p_aah04,p_axb05)
DEFINE p_aah01    LIKE aah_file.aah01
DEFINE p_aah03    LIKE aah_file.aah03
DEFINE p_aah04    LIKE aah_file.aah04
DEFINE p_axb05    LIKE axb_file.axb05
DEFINE l_aah04    LIKE aah_file.aah04
DEFINE l_abb06    LIKE abb_file.abb06
DEFINE l_abb07    LIKE abb_file.abb07
DEFINE l_abb07_1  LIKE abb_file.abb07
DEFINE l_sql      STRING

  LET l_abb07_1 = 0

  LET l_sql=" SELECT abb06,abb07 ",
            "   FROM ",g_dbs_gl,"aba_file,",g_dbs_gl,"abb_file ",             
            "  WHERE aba00 = abb00 ",
            "    AND aba01 = abb01 ",
            "    AND aba00 = '",p_axb05,"' ",            
            "    AND aba03 = '",tm.yy,"' ",
            "    AND aba04 = '",p_aah03,"' ",
            "    AND aba06 = 'CE' ",
            "    AND abb03 = '",p_aah01,"' "

	CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  PREPARE p001_abb_1 FROM l_sql
  DECLARE p001_abb CURSOR FOR p001_abb_1
  FOREACH p001_abb INTO l_abb06,l_abb07
    IF l_abb06 = '1' THEN
       LET l_abb07_1 = l_abb07_1 + l_abb07
    ELSE
    	 LET l_abb07_1 = l_abb07_1 - l_abb07
    END IF	   
  END FOREACH
  IF cl_null(l_abb07_1) THEN 
     LET l_abb07_1 = 0
  END IF   
  LET l_aah04 = p_aah04 - l_abb07_1
  RETURN l_aah04
END FUNCTION

#-------FUN-A60038 start---
#--依agli0111設定股東權益金額作為下層功能/上層記帳金額--
FUNCTION p001_axr(p_i,p_aag01,p_axe06,p_date)  #TQC-AA0098 取消mark
#FUNCTION p001_axr(p_i,p_axe06,p_date)   #FUN-A90026   #TQC-AA0098 mark
DEFINE p_aag01  LIKE aag_file.aag01
DEFINE p_axe06  LIKE axe_file.axe06
DEFINE p_date   LIKE type_file.dat 
DEFINE l_aag06  LIKE aag_file.aag06
DEFINE l_axr13  LIKE axr_file.axr13
DEFINE l_chg_dr LIKE aah_file.aah04             #借方金額
DEFINE l_chg_cr LIKE aah_file.aah05             #貸方金額
DEFINE l_cut    LIKE type_file.num5             #幣別取位(功能幣別)                  
DEFINE p_i      LIKE type_file.num5
DEFINE l_axr16  LIKE axr_file.axr16             #FUN-A70086
DEFINE l_fun_dr      LIKE aah_file.aah04        #功能幣借方 #FUN-A70086
DEFINE l_fun_cr      LIKE aah_file.aah04        #功能幣貸方 #FUN-A70086

    DECLARE p001_axr_cs1 CURSOR FOR p001_axr_p
    OPEN p001_axr_cs1 
    USING g_dept[p_i].axa01,g_dept[p_i].axb04,
          #p_aag01,p_axe06,p_date
          p_axe06,p_date    #FUN-A90026 
    FETCH p001_axr_cs1                      
    #INTO l_aag06,l_axr13                   
    INTO l_aag06,l_axr16,l_axr13                #FUN-A70086     

    IF l_axr13 > 0 THEN 
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
             LET l_fun_dr=l_axr16          #FUN-A70086
             LET l_chg_dr=l_axr13          #借
             LET l_fun_cr=0                #FUN-A70086
             LET l_chg_cr=0                #貸
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=0                 #FUN-A70086
            LET l_chg_dr=0                 
            LET l_chg_cr=l_axr13          
            LET l_fun_cr=l_axr16           #FUN-A70086
        END IF
    ELSE
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
            LET l_fun_dr=0                      #FUN-A70086
            LET l_chg_dr=0
            LET l_chg_cr=(l_axr13 *-1)
            LET l_fun_cr=(l_axr16 *-1)          #FUN-A70086
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=(l_axr16*-1)           #FUN-A70086
            LET l_chg_dr=(l_axr13*-1)
            LET l_chg_cr=0
            LET l_fun_cr=0                      #FUN-A70086
        END IF
    END IF
    #RETURN l_chg_dr,l_chg_cr

    #--FUN-A70086 start--
    LET l_rate = 1
    LET l_rate1 = 1
    SELECT axr15,axr12
    INTO l_rate,l_rate1  
     FROM axr_file
    WHERE axr01= g_dept[p_i].axa01
      AND axr02= g_dept[p_i].axb04
      AND axr07= p_aag01
      AND axr03= p_axe06
      AND axr06<=p_date
  #---FUN-A70086 end-----
    IF cl_null(l_rate) THEN LET l_rate = 1 END IF  #TQC-AA0098
    IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF   #TQC-AA0098
    RETURN l_fun_dr,l_fun_cr,l_chg_dr,l_chg_cr  #FUN-A70086
END FUNCTION

#--依匯率計算下層公司功能幣---------
FUNCTION p001_fun_amt(p_aag04,p_dr,p_cr,p_axe11,p_axz06,p_axz07,p_yy,p_mm)
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_axe11    LIKE axe_file.axe11
DEFINE p_axz06    LIKE axz_file.axz06
DEFINE p_axz07    LIKE axz_file.axz07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_fun_dr   LIKE aah_file.aah04
DEFINE l_fun_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut      LIKE type_file.num5   

    IF p_aag04='1' THEN #1.BS 2.IS
         LET l_bs_yy=p_yy
         LET l_bs_mm=tm.em
    ELSE
         LET l_bs_yy=p_yy
         LET l_bs_mm=p_mm
    END IF

    LET l_fun_dr=0 
    LET l_fun_cr=0 
    #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
    LET l_rate = 1
    IF p_axz06 != p_axz07 THEN 
        #功能幣別匯率
        CALL p001_getrate(p_axe11,l_bs_yy,l_bs_mm,
                          p_axz06,p_axz07)
        RETURNING l_rate
        IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
    END IF

    #->幣別轉換及取位
    LET l_fun_dr=p_dr * l_rate     #下層公司功能幣別借方金額
    LET l_fun_cr=p_cr * l_rate     #下層公司功能幣別貸方金額
   
    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz07                                                                               
    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                                                                                                                                         
    LET l_fun_dr=cl_digcut(l_fun_dr,l_cut)                                                                                                
    LET l_fun_cr=cl_digcut(l_fun_cr,l_cut)                                                                                                
    IF cl_null(l_fun_dr) THEN LET l_fun_dr=0 END IF                                                                                   
    IF cl_null(l_fun_cr) THEN LET l_fun_cr=0 END IF                                                                                   
    RETURN l_fun_dr,l_fun_cr
END FUNCTION

#--依匯率計算上層記帳幣---------
FUNCTION p001_acc_amt(p_aag04,p_dr,p_cr,p_axe12,p_axz07,p_aaa03,p_yy,p_mm)
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_axe12    LIKE axe_file.axe12
DEFINE p_aaa03    LIKE aaa_file.aaa03
DEFINE p_axz07    LIKE axz_file.axz07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_acc_dr   LIKE aah_file.aah04
DEFINE l_acc_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut1     LIKE type_file.num5             #幣別取位(記帳幣別) 

    IF p_aag04='1' THEN #1.BS 2.IS
         LET l_bs_yy=p_yy
         LET l_bs_mm=tm.em
    ELSE
         LET l_bs_yy=p_yy
         LET l_bs_mm=p_mm
    END IF
    LET l_acc_dr=0 
    LET l_acc_cr=0 

    #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
    LET l_rate1 = 1
    IF p_axz07 != p_aaa03 THEN
        #記帳幣別匯率
        CALL p001_getrate(p_axe12,l_bs_yy,l_bs_mm,
                          p_axz07,p_aaa03)
        RETURNING l_rate1
        IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF 
    END IF

    #->幣別轉換及取位
    LET l_acc_dr=p_dr * l_rate1  #上層公司記帳幣別借方金額
    LET l_acc_cr=p_cr * l_rate1  #上層公司記帳幣別貸方金額

    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                         
    LET l_acc_dr=cl_digcut(l_acc_dr,l_cut1)                                                                                           
    LET l_acc_cr=cl_digcut(l_acc_cr,l_cut1) 
    IF cl_null(l_acc_dr) THEN LET l_acc_dr=0 END IF                                                                                   
    IF cl_null(l_acc_cr) THEN LET l_acc_cr=0 END IF                                                                                   
    RETURN l_acc_dr,l_acc_cr

END FUNCTION

#計算axg_file為來源的合併幣別(採平均匯率者)
FUNCTION p001_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i,p_aej18) #luttb 110913 add aej12
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_dr         LIKE aah_file.aah04
DEFINE p_cr         LIKE aah_file.aah05
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_acc_dr     LIKE aah_file.aah04
DEFINE l_acc_cr     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_axg08      LIKE axg_file.axg08
DEFINE l_axg09      LIKE axg_file.axg09
DEFINE p_yy         LIKE type_file.num5   #FUN-A90026
DEFINE p_mm         LIKE type_file.num5   #FUN-A90026
DEFINE l_month      LIKE type_file.num5   #FUN-A90026
DEFINE l_last_dr    LIKE axg_file.axg08   #FUN-A90026
DEFINE l_last_cr    LIKE axg_file.axg09   #FUN-A90026
DEFINE l_sum_axg08  LIKE axg_file.axg08   #FUN-A90026
DEFINE l_sum_axg09  LIKE axg_file.axg09   #FUN-A90026
DEFINE l_axg13      LIKE axg_file.axg13   #FUN-A90026
DEFINE l_axg14      LIKE axg_file.axg14   #FUN-A90026
DEFINE p_axe12      LIKE axe_file.axe12   #FUN-A90026
DEFINE p_axe11      LIKE axe_file.axe11   #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5   #FUN-A90026
DEFINE p_aej18      LIKE aej_file.aej18   #luttb 110913

  LET l_axg08 = 0
  LET l_axg09 = 0
  LET l_sum_axg08 = 0
  LET l_sum_axg09 = 0
  LET l_axg13 = 0  #TQC-AA0098
  LET l_axg14 = 0  #TQC-AA0098

  LET l_sql=
   " SELECT aej06,aej07,aej08",
   "   FROM aej_file ",
   "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
   "    AND aej01 = '",g_dept[p_i].axa01,"'", #族群
   "    AND aej02 = '",g_dept[p_i].axb04,"'", #公司
   "    AND aej04 = '",p_aah01,"'",
   "    AND aej05 = '",tm.yy,"'",
   #"    AND aej12 = '",p_aej12,"'",   #luttb 110913 #NO.130717 mark
   "    AND aej18 = '",p_aej18,"'",   #luttb 110913 #NO.130717 modify
   "    AND aej06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
   PREPARE p001_aej_p3 FROM l_sql
   DECLARE p001_aej_c3 CURSOR FOR p001_aej_p3
   FOREACH p001_aej_c3 INTO l_month,l_axg13,l_axg14
        IF l_month = 0 THEN LET l_month = 1 END IF
        IF p_axz06 != p_axz07 THEN 
            #功能幣別匯率
            CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
            RETURNING l_rate
        END IF
        IF p_axz07 != x_aaa03 THEN 
            #合併幣別匯率
            CALL p001_getrate(p_axe12,p_yy,l_month,p_axz07,x_aaa03)
            RETURNING l_rate1
        END IF
        IF cl_null(l_rate) THEN LET l_rate = 1 END IF
        IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
        LET l_axg08 = l_axg13 * l_rate * l_rate1
        LET l_axg09 = l_axg14 * l_rate * l_rate1
        LET l_sum_axg08 = l_sum_axg08  + l_axg08
        LET l_sum_axg09 = l_sum_axg09  + l_axg09
  END FOREACH
  LET l_dr_sum = l_sum_axg08 
  LET l_cr_sum = l_sum_axg09 
  RETURN l_dr_sum,l_cr_sum
  #--FUN-A90026 end-----

#--FUN-A70053 mark-- 移至p001_fun_avg( )
#   IF p_type = '1' THEN  #記帳幣借/貸方異動額(同總帳)
#       CALL p001_fun_amt(p_aag04,p_dr,p_cr,
#                         '3',p_axz06,p_axz07,tm.yy,tm.em)
#       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#
#       LET l_axg15 = 0
#       LET l_axg16 = 0
#       IF tm.em <> '1' THEN
#           SELECT axg15,axg16 INTO l_axg15,l_axg16
#             FROM axg_file
#           WHERE axg00 =g_aaz641
#             AND axg01 =g_dept[p_i].axa01
#             AND axg02 =g_dept[p_i].axa02
#             AND axg03 =g_dept[p_i].axa03
#             AND axg04 =g_dept[p_i].axb04
#             AND axg05 =g_aaz114
#             AND axg06 =tm.yy
#             AND axg07 =tm.em-1
#       END IF
#       LET l_dr_sum = l_axg15 + l_fun_dr
#       LET l_cr_sum = l_axg16 + l_fun_cr
#   ELSE
#--- FUN-A70053 mark------------------

#--FUN-A90026 mark-------
#       CALL p001_acc_amt(p_aag04,p_dr,p_cr,
#                         '3',p_axz07,x_aaa03,tm.yy,tm.em)
#       RETURNING l_acc_dr,l_acc_cr  
# 
#       LET l_axg08 = 0
#       LET l_axg09 = 0
#       IF tm.em <> '1' THEN
#           SELECT axg08,axg09 INTO l_axg08,l_axg09
#             FROM axg_file
#           WHERE axg00 =g_aaz641
#             AND axg01 =g_dept[p_i].axa01
#             AND axg02 =g_dept[p_i].axa02
#             AND axg03 =g_dept[p_i].axa03
#             AND axg04 =g_dept[p_i].axb04
#        #     AND axg05 =g_aaz114
#             AND axg05 =p_aah01    #FUN-A90006
#             AND axg06 =tm.yy
#             AND axg07 =tm.em-1
#       END IF
#
#       LET l_dr_sum = l_axg08 + l_acc_dr
#       LET l_cr_sum = l_axg09 + l_acc_cr
#   #END IF   #FUN-A70053 mark
#   RETURN l_dr_sum,l_cr_sum
#----FUN-A90026 mark--------

END FUNCTION
#----FUN-A60038 end---------

#--FUN-A70053 start------------
#計算axg_file為來源功能幣別(採平均匯率者)
#FUNCTION p001_fun_avg(p_type,p_dbs,p_aah01,p_aah00,p_aag04,p_axz06,p_axz07,p_i,p_dr,p_cr)
FUNCTION p001_fun_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i,p_aej18)   #FUN-A90026 mod   #luttb 110913
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE l_dr_sum LIKE aah_file.aah04
DEFINE l_cr_sum LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_axg08      LIKE axg_file.axg08
DEFINE l_axg09      LIKE axg_file.axg09
DEFINE l_axg15      LIKE axg_file.axg15
DEFINE l_axg16      LIKE axg_file.axg16
DEFINE l_last_fun_dr  LIKE axg_file.axg15  #FUN-A90026
DEFINE l_last_fun_cr  LIKE axg_file.axg16  #FUN-A90026
DEFINE l_sum_axg15  LIKE axg_file.axg15    #FUN-A90026 
DEFINE l_sum_axg16  LIKE axg_file.axg16    #FUN-A90026
DEFINE l_axg13      LIKE axg_file.axg13    #FUN-A90026
DEFINE l_axg14      LIKE axg_file.axg14    #FUN-A90026
DEFINE p_yy         LIKE aah_file.aah02    #FUN-A90026 
DEFINE p_mm         LIKE aah_file.aah03    #FUN-A90026 
DEFINE p_axe11      LIKE axe_file.axe11    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026
DEFINE p_aej18      LIKE aej_file.aej18    #luttb 110913
  LET l_dr_sum = 0
  LET l_cr_sum = 0

  #--FUN-A90026 mark-
  #CALL p001_fun_amt(p_aag04,p_dr,p_cr,
  #                  '3',p_axz06,p_axz07,tm.yy,tm.em)
  #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
  #--FUN-A90026 mark-

  LET l_axg15 = 0
  LET l_axg16 = 0

  #--FUN-A90026 start--
  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axg_file之前要倒推匯率再存入(算完合併幣金額之後再推)

  LET l_axg13 = 0
  LET l_axg14 = 0
  LET l_axg15 = 0
  LET l_axg16 = 0
  LET l_sum_axg15 = 0
  LET l_sum_axg16 = 0
  LET l_sql=
  " SELECT aej06,aej07,aej08",
  "   FROM aej_file ",
  "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
  "    AND aej01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND aej02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND aej04 = '",p_aah01,"'",
  "    AND aej05 = '",tm.yy,"'",
  #"    AND aej12 = '",p_aej12,"'",   #luttb 110913  #NO.130717 mark
  "    AND aej18 = '",p_aej18,"'",   #luttb 110913  #NO.130717 modify
  "    AND aej06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_aej_p1 FROM l_sql
  DECLARE p001_aej_c1 CURSOR FOR p001_aej_p1
  FOREACH p001_aej_c1 INTO l_month,l_axg13,l_axg14
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_axz06 != p_axz07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
           RETURNING l_rate
       END IF
       LET l_axg15 = l_axg13 * l_rate
       LET l_axg16 = l_axg14 * l_rate
       LET l_sum_axg15 = l_sum_axg15  + l_axg15
       LET l_sum_axg16 = l_sum_axg16  + l_axg16
  END FOREACH
  #--FUN-A90026 end-----

  #--FUN-A90026 mark----
  #IF tm.em <> '1' THEN   #FUN-A90026 mark
  #    SELECT axg15,axg16 INTO l_axg15,l_axg16
  #      FROM axg_file
  #    WHERE axg00 =g_aaz641
  #      AND axg01 =g_dept[p_i].axa01
  #      AND axg02 =g_dept[p_i].axa02
  #      AND axg03 =g_dept[p_i].axa03
  #      AND axg04 =g_dept[p_i].axb04
  # #     AND axg05 =g_aaz114
  #      AND axg05 =p_aah01    #FUN-A90006
  #      AND axg06 =tm.yy
  #      #AND axg07 =tm.em-1
  #      AND axg07 = l_mm      #FUN-A90026  mod
  #END IF
  #LET l_dr_sum = l_axg15 + l_fun_dr   #寫入功能幣的金額
  #LET l_cr_sum = l_axg16 + l_fun_cr
  #--FUN-A90026 mark---

  #LET l_dr_sum = l_sum_axg15 + l_last_fun_dr   #寫入功能幣的金額  #FUN-A90026 
  #LET l_cr_sum = l_sum_axg16 + l_last_fun_cr                      #FUN-A90026 
  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  #l_dr_sum/l_cr_sum: axa05 ='1'者適用(先累加各期金額後*最後一期匯率)
  #RETURN l_fun_dr,l_fun_cr,l_dr_sum,l_cr_sum  
  RETURN l_dr_sum,l_cr_sum     #FUN-A90026 mod
END FUNCTION
#--FUN-A70053 end-------------

#--FUN-A90006 start--
#計算axk_file為來源的合併幣別(採平均匯率者) 
#FUNCTION p001_axk_avg(p_type,p_dbs,p_aed01,p_aed02,p_aah00,p_aag04,p_axz06,p_axz07,p_i,p_dr,p_cr)
FUNCTION p001_axk_avg(p_axe11,p_axe12,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i,p_aek19)   #FUN-A90026 mod  #luttb 110913 add aek13
DEFINE l_sql        STRING 
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_axk10      LIKE axk_file.axk10
DEFINE l_axk11      LIKE axk_file.axk11
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE l_last_dr    LIKE axk_file.axk10    #FUN-A90026
DEFINE l_last_cr    LIKE axk_file.axk11    #FUN-A90026
DEFINE p_yy         LIKE aah_file.aah02    #FUN-A90026 
DEFINE p_mm         LIKE aah_file.aah03    #FUN-A90026 
DEFINE l_axk18      LIKE axk_file.axk18    #FUN-A90026
DEFINE l_axk19      LIKE axk_file.axk19    #FUN-A90026
DEFINE l_axk20      LIKE axk_file.axk20    #FUN-A90026
DEFINE l_axk21      LIKE axk_file.axk21    #FUN-A90026
DEFINE p_axe12      LIKE axe_file.axe12    #FUN-A90026
DEFINE p_axe11      LIKE axe_file.axe11    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_sum_axk10  LIKE axk_file.axk10    #FUN-A90026
DEFINE l_sum_axk11  LIKE axk_file.axk11    #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026
DEFINE p_aek19      LIKE aek_file.aek19    #luttb 110913

#--FUN-A90026 mark-----------------------
#    CALL p001_acc_amt(p_aag04,p_dr,p_cr,
#                      '3',p_axz07,x_aaa03,tm.yy,tm.em)
#    RETURNING l_acc_dr,l_acc_cr
#
#    LET l_axk10 = 0
#    LET l_axk11 = 0
#    IF tm.em <> '1' THEN
#        SELECT axk10,axk11 INTO l_axk10,l_axk11
#          FROM axk_file
#        WHERE axk00 =g_aaz641
#          AND axk01 =g_dept[p_i].axa01
#          AND axk02 =g_dept[p_i].axa02
#          AND axk03 =g_dept[p_i].axa03
#          AND axk04 =g_dept[p_i].axb04
#          AND axk05 =p_aed01
#          AND axk07 =p_aed02
#          AND axk08 =tm.yy
#          AND axk09 = tm.em - 1
#    END IF
#
#    #--此時的l_acc_dr,l_acc_cr應為當月異動額*再衡量(非累計餘額)
#
#    LET l_dr_sum = l_axk10 + l_acc_dr
#    LET l_cr_sum = l_axk11 + l_acc_cr
#----FUN-A90026 mark--------------------

#--FUN-A90026 start--
  #--先處理依編製期別取每期金額後
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axk_file之前要倒推匯率再存入
 
  #上一期合併幣金額：
  LET l_axk10 = 0
  LET l_axk11 = 0
  LET l_last_dr = 0
  LET l_last_cr = 0
  LET l_sum_axk10 = 0  #TQC-AA0098
  LET l_sum_axk11 = 0  #TQC-AA0098
  LET l_axk20  = 0  #TQC-AA0098
  LET l_axk21  = 0  #TQC-AA0098

  LET l_sql=
  " SELECT aek07,aek08,aek09",
  "   FROM aek_file ",
  "  WHERE aek00 = '",g_aaz641,"'",        #合併帳別 
  "    AND aek01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND aek02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND aek04 = '",p_aed01,"'",
  "    AND aek05 = '",p_aed02,"'",
  "    AND aek06 = '",tm.yy,"'",
  #"    AND aek13 = '",p_aek13,"'",   #luttb 110913 #NO.130717 mark
  "    AND aek19 = '",p_aek19,"'",   #luttb 110913 #NO.130717 modify
  "    AND aek07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_aek_p1 FROM l_sql
  DECLARE p001_aek_c1 CURSOR FOR p001_aek_p1
  FOREACH p001_aek_c1 INTO l_month,l_axk18,l_axk19
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_axz06 != p_axz07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
           RETURNING l_rate
       END IF
       IF p_axz07 != x_aaa03 THEN 
           #合併幣別匯率
           CALL p001_getrate(p_axe12,p_yy,l_month,p_axz07,x_aaa03)
           RETURNING l_rate1
       END IF
       IF cl_null(l_rate) THEN LET l_rate = 1 END IF
       IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
       LET l_axk20 = l_axk18 * l_rate * l_rate1
       LET l_axk21 = l_axk19 * l_rate * l_rate1
       LET l_sum_axk10 = l_sum_axk10  + l_axk20
       LET l_sum_axk11 = l_sum_axk11  + l_axk21
  END FOREACH
  LET l_dr_sum = l_sum_axk10 
  LET l_cr_sum = l_sum_axk11
  #---FUN-A90026 end------------

  RETURN l_dr_sum,l_cr_sum
END FUNCTION
#FUN-A90006 end-------

#--FUN-A80130 start---
#計算axk_file為來源功能幣別(採平均匯率者)
FUNCTION p001_fun_axk_avg(p_axe11,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i,p_aek19)  #Luttb 110913
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_axk20      LIKE axk_file.axk20
DEFINE l_axk21      LIKE axk_file.axk21
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE p_axe11      LIKE axe_file.axe11    #FUN-A90026
DEFINE l_last_axk20 LIKE axk_file.axk20    #FUN-A90026
DEFINE l_last_axk21 LIKE axk_file.axk21    #FUN-A90026
DEFINE l_sum_axk20  LIKE axk_file.axk20    #FUN-A90026
DEFINE l_sum_axk21  LIKE axk_file.axk21    #FUN-A90026
DEFINE l_axk18      LIKE axk_file.axk18    #FUN-A90026
DEFINE l_axk19      LIKE axk_file.axk19    #FUN-A90026
DEFINE p_yy         LIKE type_file.num5    #FUN-A90026
DEFINE p_mm         LIKE type_file.num5    #FUN-A90026
DEFINE l_sql        STRING                 #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026
DEFINE p_aek19      LIKE axk_file.axk19    #luttb 110913

  #--FUN-A90026 start--
  #--先處理依編製期別取每期金額
  #功能幣金額：(記帳幣*再衡量匯率 (0~迄期別)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率(0~迄期別))
  #例:1~6月各期記帳幣異動額各為100，
  #上一期(3月)功能金額：820
  #出6月季報時，應先記算0~6月各期金額=SUM(每期異動額*當期平均匯率)：
  #存檔axk_file之前要倒推匯率再存入(算完合併幣金額之後再推)
 
  LET l_sum_axk20 = 0   #TQC-AA0098
  LET l_sum_axk21 = 0   #TQC-AA0098
  LET l_axk18 = 0   #TQC-AA0098
  LET l_axk19 = 0   #TQC-AA0098
  LET l_axk20 = 0   #TQC-AA0098
  LET l_axk21 = 0   #TQC-AA0098

  LET l_sql=
  " SELECT aek07,aek08,aek09",
  "   FROM aek_file ",
  "  WHERE aek00 = '",g_aaz641,"'",        #合併帳別 
  "    AND aek01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND aek02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND aek04 = '",p_aed01,"'",
  "    AND aek05 = '",p_aed02,"'",
  "    AND aek06 = '",tm.yy,"'",
  #"    AND aek13 = '",p_aek13,"'",   #luttb 110913 #NO.130717 mark
  "    AND aek19 = '",p_aek19,"'",   #luttb 110913 #NO.130717 modify
  "    AND aek07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_aek_p2 FROM l_sql
  DECLARE p001_aek_c2 CURSOR FOR p001_aek_p2
  FOREACH p001_aek_c2 INTO l_month,l_axk18,l_axk19
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_axz06 != p_axz07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
           RETURNING l_rate
       END IF
       IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
       LET l_axk20 = l_axk18 * l_rate 
       LET l_axk21 = l_axk19 * l_rate
       LET l_sum_axk20 = l_sum_axk20  + l_axk20
       LET l_sum_axk21 = l_sum_axk21  + l_axk21
  END FOREACH
  
  LET l_dr_sum = l_sum_axk20
  LET l_cr_sum = l_sum_axk21
  
  RETURN l_dr_sum,l_cr_sum  
  #-----FUN-A90026 end-------------------------
  
#-----FUN-A90026 mark-------
#    LET l_acc_dr = 0
#    LET l_acc_cr = 0
#    LET l_dr_sum = 0
#    LET l_cr_sum = 0
#
#    CALL p001_fun_amt(p_aag04,p_dr,p_cr,
#                      '3',p_axz06,p_axz07,tm.yy,tm.em)
#    RETURNING l_fun_dr,l_fun_cr  
#
#    LET l_axk20 = 0
#    LET l_axk21 = 0
#    IF tm.em <> '1' THEN
#        SELECT axk20,axk21 INTO l_axk20,l_axk21
#          FROM axk_file
#        WHERE axk00 =g_aaz641
#          AND axk01 =g_dept[p_i].axa01
#          AND axk02 =g_dept[p_i].axa02
#          AND axk03 =g_dept[p_i].axa03
#          AND axk04 =g_dept[p_i].axb04
#          AND axk05 =p_aed01
#          AND axk07 =p_aed02
#          AND axk08 =tm.yy
#          AND axk09 =tm.em-1
#    END IF
#    LET l_dr_sum = l_axk20 + l_fun_dr 
#    LET l_cr_sum = l_axk21 + l_fun_cr
#
#    RETURN l_fun_dr,l_fun_cr,l_dr_sum,l_cr_sum
#----FUN-A90026 mark----------

END FUNCTION 
#---FUN-A80130 end--------

#luttb--mark--str--
##---FUN-A90006 start----------------
#FUNCTION p001_ins_axj1_chg(p_type,p_flag,p_axz06)
##FUNCTION p001_ins_axj1_chg(p_axg12,p_axz06)
#DEFINE p_axz06     LIKE axz_file.axz06
#DEFINE p_axg12     LIKE axg_file.axg12
#DEFINE l_axg08     LIKE axg_file.axg08
#DEFINE l_axg09     LIKE axg_file.axg09
#DEFINE l_axg08_b   LIKE axg_file.axg08
#DEFINE l_axg09_b   LIKE axg_file.axg09
#DEFINE l_month_amt LIKE axg_file.axg08
#DEFINE l_tot_amt   LIKE axg_file.axg08
#DEFINE i           LIKE type_file.num5
#DEFINE l_sql       STRING
#DEFINE l_cut       LIKE type_file.num5
#DEFINE l_axg12     LIKE axg_file.axg12   #FUN-A90026
#DEFINE l_r         LIKE axp_file.axp05   #FUN-A90026 
#DEFINE l_r1        LIKE axp_file.axp05   #FUN-A90026
#DEFINE p_flag      LIKE type_file.chr1   #FUN-A90026
#DEFINE p_type      LIKE type_file.chr1   #FUN-A90026
#DEFINE l_axz07     LIKE axf_file.axf09   #FUN-A90026
#
#     #取下層公司記帳金額期別計算各月異動額
#     #轉換為合併幣別金額後加總
#     #各期各自先計算出當月金額後累加
#     #沖銷金額=1-9月各期餘額加總
#     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
#      LET l_axg08 = 0
#      LET l_axg09 = 0
#      LET l_axg08_b = 0
#      LET l_axg09_b = 0
#      LET l_month_amt = 0
#      LET l_tot_amt = 0
#      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
#      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#
#     #先依來源為axk_file or axg_file取各月餘額
#     #FOR i = 1 TO tm.em
#     FOR i = 0 TO tm.em   #FUN-A90026 mod
##----FUN-A90026 mark-----------------------來源改為aej_file or aek_file
##         IF g_axf.axf15 = '1' THEN   #axg_file
##             LET l_sql =" SELECT axg08,axg09",
##                        "   FROM axg_file ",
##                        "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
##                        "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
##                        "    AND axg02 ='",g_axg.axg02,"'",       #上層
##                        "    AND axg04 ='",g_axg.axg04,"' ",      #下層
##                        "    AND axg05 ='",g_axg.axg05,"'",       #科目
##                        "    AND axg06 = ",tm.yy,                 #年度
##                        "    AND axg07 = '",i,"'"                 #期別
##         ELSE    #axk_file
##             LET l_sql =" SELECT axk10,axk11",
##                        "   FROM axk_file",
##                        "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
##                        "    AND axk02 ='",g_axg.axg02,"'",        #上層公司
##                        "    AND axk04 ='",g_axg.axg04,"' ",       #下層
##                        "    AND axk05 ='",g_axg.axg05,"'",
##                        "    AND axk08 = ",tm.yy,                  #年度
##                        "    AND axk07 = '",g_affil,"'",           #異動碼
##                        "    AND axk09 = '",i,"'"                  #期別
##         END IF
##---FUN-A90026 mark----------------------------------------------------
#
##---FUN-A90026 start--- 
#         SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg04
#         IF p_type = 'A' THEN       #來源公司 
#             CASE 
#                WHEN p_flag = '1'        #aej_file
#                    LET l_sql =
#                    " SELECT SUM(aej07-aej08),aej11",
#                    "   FROM aej_file ",
#                    "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
#                    "    AND aej01 = '",tm.axa01,"'",        #族群
#                    "    AND aej02 = '",g_axg.axg04,"'",     #公司
#                    "    AND aej04 = '",g_axg.axg05,"'",
#                    "    AND aej05 = '",tm.yy,"'",
#                    "    AND aej06 = '",i,"'",
#                    "  GROUP BY aej11 "
#                WHEN p_flag = '2'        #aek_file
#                    LET l_sql=
#                    " SELECT SUM(aek08-aek09),aek12",
#                    "   FROM aek_file",
#                    "  WHERE aek00 = '",g_aaz641,"'",
#                    "    AND aek01 = '",tm.axa01,"'",
#                    "    AND aek02 = '",g_axg.axg04,"'",
#                    "    AND aek04 = '",g_axg.axg05,"'",
#                    "    AND aek05 = '",g_axk07,"'",
#                    "    AND aek06 = '",tm.yy,"'",
#                    "    AND aek07 = '",i,"'",
#                    "  GROUP BY aek12"
#            END CASE
#        ELSE        #目的公司
#            CASE
#              WHEN p_flag = '1'        #aej_file
#                 LET l_sql =
#                 " SELECT SUM(aej07-aej08),aej11",
#                 "   FROM aej_file ",
#                 "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
#                 "    AND aej01 = '",tm.axa01,"'", #族群
#                 "    AND aej02 = '",g_axg.axg04,"'",     #公司
#                 "    AND aej04 = '",g_axg.axg05,"'",
#                 "    AND aej05 = '",tm.yy,"'",
#                 "    AND aej06 = '",i,"'",
#                 "  GROUP BY aej11 "
#              WHEN p_flag = '2'        #aek_file
#                 LET l_sql=
#                 " SELECT SUM(aek08-aek09),aek12",
#                 "   FROM aek_file",
#                 "  WHERE aek00 = '",g_aaz641,"'",
#                 "    AND aek01 = '",tm.axa01,"'",
#                 "    AND aek02 = '",g_axg.axg04,"'",
#                 "    AND aek04 = '",g_axg.axg05,"'",
#                 "    AND aek05 = '",g_axk07,"'",
#                 "    AND aek06 = '",tm.yy,"'",
#                 "    AND aek07 = '",i,"'",
#                 "  GROUP BY aek12"
#            END CASE
#        END IF
#        #---FUN-A90026 end-----
#
#        PREPARE p001_ins_axj1_p1 FROM l_sql
#        IF STATUS THEN
#           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy
#           CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'pre:ins_axj1_p1',STATUS,1)
#           LET g_success = 'N'
#        END IF
#        DECLARE p001_ins_axj1_c1 CURSOR FOR p001_ins_axj1_p1
#        #FOREACH p001_ins_axj1_c1 INTO l_axg08,l_axg09    #借/貸
#        FOREACH p001_ins_axj1_c1 INTO l_month_amt,l_axg12    #借-貸/幣別   #FUN-A90026 mod
#        #--FUN-A90026 srart---
#            LET l_r = 1
#            LET l_r1 = 1
#            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
#            CALL p001_getrate('3',tm.yy,i,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
#            RETURNING l_r   
#            IF cl_null(l_r) THEN LET l_r = 1 END IF
#            CALL p001_getrate('3',tm.yy,i,l_axz07,p_axz06) 
#            RETURNING l_r1   
#            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
#            LET l_month_amt = l_month_amt * l_r * l_r1
#            LET l_tot_amt = l_tot_amt + l_month_amt
#        END FOREACH
#        #--FUN-A90026 end----
#
##---FUN-A90026 mark ------------
##             CALL p001_getrate('3',tm.yy,i,p_axg12,p_axz06)      #取起始月份至當下月份的匯率
##             RETURNING l_rate
##             IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
##             IF i = 1 THEN   #月份為1時，取出的axg08,axg09即為當月異動額，否則要扣掉前期才能得出當月異動額
##                 LET l_month_amt = (l_axg09 * l_rate) - (l_axg08 * l_rate)
##             ELSE
##                 IF g_axf.axf15 = '1' THEN   #axg_file
##                     SELECT axg08,axg09 INTO l_axg08_b,l_axg09_b
##                       FROM axg_file
##                      WHERE axg01 =g_axa[i].axa01 #群組
##                        AND axg02 =g_axg.axg02      #上層
##                        AND axg04 =g_axg.axg04      #下層
##                        AND axg05 =g_axg.axg05      #科目
##                        AND axg06 =tm.yy            #年度
##                        AND axg07 =i-1              #期別
##                 ELSE    #axk_file
##                     SELECT axk10,axk11 INTO l_axg08_b,l_axg09_b
##                       FROM axk_file
##                      WHERE axk01 =g_axa[i].axa01    #群組
##                        AND axk02 =g_axg.axg02        #上層公司
##                        AND axk04 =g_axg.axg04        #下層
##                        AND axk05 =g_axg.axg05
##                        AND axk08 =tm.yy              #年度
##                        AND axk07 =g_affil            #異動碼
##                        AND axk09 =i-1                #期別
##                 END IF
##                 LET l_month_amt = ((l_axg09 - l_axg09_b) * l_rate) - ((l_axg08 - l_axg08_b) * l_rate)
##            END IF
##            LET l_month_amt=cl_digcut(l_month_amt,l_cut)
##            LET l_tot_amt = l_tot_amt + l_month_amt
##         END FOREACH
##------------FUN-A90026 mark----------------
#     END FOR
#     RETURN l_tot_amt 
#END FUNCTION
##---FUN-A90006 end-----------------
#luttb--mark--end
#FUN-A90026 start---
FUNCTION p001_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION p001_set_no_entry() 

      CALL cl_set_comp_entry("axa06",FALSE) 

      IF tm.axa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.axa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.axa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.axa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION
#--FUN-A90026 end------------------

