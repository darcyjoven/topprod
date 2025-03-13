# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglp201.4gl
# Descriptions...: 資料匯入合併區作業(整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify.......... No.9699 04/07/09 By Nicola aag_file前加上g_dbs_gl
# Modify.......... No.9701 04/07/09 By Nicola 幣別小數捉取, 應依母公司幣別為主SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=x_aaa03
# Modify.........: No:MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0072 04/11/25 By Nicola 加入"匯率計算"功能
# Modify ........: No.FUN-560060 05/06/13 By wujie 單據編號加大,多工廠返工 
# Modify ........: No.FUN-580063 05/08/19 By Sarah 
#                  1.不使用TIPTOP(asg04='N')資料抓aglt003資料(asi13)匯入(asr_file,ass_file)
#                  2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
#                    年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
#                    金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
#                    乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
#                  3.一併存入上層公司記帳幣別(asr12,ass14)
#                  4.從aglt003匯入ass_file時(合併前科目異動碼資料),
#                    ass06固定='4',ass07=asi13(關係人代號)
#                  5.asr_file增加四欄位：asr13(下層公司原幣別借方金額),
#                                        asr14(下層公司原幣別貸方金額),
#                                        asr15(功能幣別借方金額),
#                                        asr16(功能幣別貸方金額)
# Modify ........: No.FUN-5A0020 05/10/05 By Sarah 
# Modify ........: No.FUN-5A0118 05/10/19 By Sarah 1.沒產生沖銷分錄
#                                                  2.資料寫入asr_file時,科目沒有轉換
# Modify ........: No:FUN-570145 06/02/27 By YITING 批次背景執行
# Modify ........: No:FUN-630063 06/03/22 By ching 10組異動碼相關
# Modify.........: No:MOD-660034 06/06/13 By Smapmin 修改抓取匯率方式
# Modify.........: No:TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No:FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No:MOD-6A0039 06/10/14 By Smapmin 年度與月份不應受限於aaa07
# Modify.......... No.MOD-6A0066 06/10/17 By yjkhero  當有多個科目合并為一個科目時，asr_file記錄有問題
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
#                  2.匯入時,若科目設定依歷史匯率(ash11='2',ash12='2'),金額抓agli011裡的設定,依異動日期抓歷史匯率(agli008)計算匯率
#                  3.當來源、對沖科目是MISC時,MISC來源科目餘額應抓來源公司的科目餘額,MISC對沖科目餘額應抓對沖公司的科目餘額
#                  4.非tiptop公司,INSERT ass_file,ass06(異動碼序)應給99
# Modify.........: No:TQC-770118 07/07/25 By Sarah 
#                  1.當公司層級資料較複雜(有非tiptop公司)時,INSERT INTO asr_file或ass_file時有可能出現-239,增加判斷出現-239則做UPDATE
#                  2.當錯誤訊息匯整後,應該用CONTUINUE FOREACH而不是用EXIT FOREACH
#                  3.當執行有錯誤時,就不執行寫入分錄(p001_modi(),p001_adj())的動作
# Modify.......... No.FUN-770069 07/07/31 By Sarah 1.寫入ass_file,asr_file,asj_file時,除了寫入版本為00的資料外,要再寫入版本為截止期別(tm.em)的資料
#                                                  2.歷史匯率部分改以asf07,asf03,asf08,asf09對應抓出輸入歷史變動金額(asf05)
# Modify.........: No:MOD-780115 07/08/17 By Sarah 換算子公司功能幣別時,應與該子公司記帳幣別比較,若不同才需換算
# Modify.........: No:MOD-890130 08/09/17 By Sarah 產生沖銷分錄時,若金額為0則不產生分錄
# Modify.........: No:MOD-910248 09/02/02 By Sarah 當asv05='+'時,SUM(asr08-asr09)不需*-1
# Modify.........: No:MOD-930135 09/03/12 By lilingyu 增加版本條件
# Modify.......... No.MOD-930210 09/03/20 By Sarah 刪除asj_file、ask_file、計算asj_file筆數時,請加串版本(asj21)條件
# Modify.......... No.MOD-940010 09/04/02 By Sarah get_rate()段,抓asd_file時應串下層公司,且SQL應以asd08b由大至小排序
# Modify.........: No:MOD-950019 09/05/05 By Sarah 抓取科目餘額檔、科目異動碼餘額檔時,只抓貨幣性科目(aag09='Y')的資料
# Modify.......... NO.FUN-920067 09/05/19 BY jan 寫入ass_file,asr_file時應以合併帳別寫入
# Modify.........: No:FUN-910001 09/05/19 By lutingting 由11區追單,                                                                                  
# Modify.........: NO.FUN-A90006 10/09/02 BY yiting 對沖科餘計算BS/IS皆採用累計式計算方式
#                  1.串ash_file時,增加串ash13(族群代號)=tm.asa01                                                                    
#                  2.產生分錄時寫入的關系人(ask05)需以公司代號串到asg_file抓取asg08 
# Modify........... NO.FUN-930018 09/05/20 BY ve007 在抓取asf_file時，當asf13有值，直接用此金額帶入，ELSE IF asf05 > 0 照舊用asf05金額計算    
# Modify........... NO.FUN-930112 09/05/20 BY ve007 1.產生調整分錄時，原本抓取ass_file科目餘額檔時
#                                                   ass10 = 0時就CONTINUE FOREACH，將此段MARK
#                                                   2.對沖時，金額小於零放在借方，反之放貸方
#                                                   3.科目性質為1時，要累算前期餘額
# Modify..........: NO.FUN-930117 09/05/20 BY ve007 pk值異動，相關程式修改
# Modify..........: NO.FUN-930144 09/05/20 BY ve007
#                                             1.aglt001在確認時，自動產生一筆分錄單號，版本為"截止期別" ，其餘資料與00版本相同(年度/期別為current單據) ，並將00版本的單號asj01記錄在
#                                               產生的新單號asj13欄位
#                                             2.gglp201 在產生asj_file時(截止期別那張，版本00) 將ins_ver那段先執行後，回頭寫入asj13單號記錄(原本為no use)
#                                             3.非MISC類科目，抓取ass_file時，科目性質為1.資料負債類科目，需從第0期開始sum到截止期別金額，非資料負債類則只有當期金額
# Modify..........: NO.FUN-920167 09/05/21 BY jan 科目來源及對象皆為MISC時，關係人應回抓asg08 
# Modify........... NO.FUN-920110 09/05/21 BY jan 1抓取asf_file時，以抓取結轉的年度+前期月份資料
# Modify........... No.FUN-910023 09/05/21 By lutingting 將下層合并後異動碼餘額檔atcc_file并到上層的合并前異動碼於額檔ass_file 
# Modify..........: No.FUN-950048 09/05/25 By jan 畫面上的起始期別設為noentry,并且預設為0
# Modify..........: NO.FUN-960003 09/05/30 BY yiting 1.處理第0期股本調整分錄時，以asq14為依據產生，asq14 = 'Y'時才產生第0期分錄
#                                                    2.取消版本觀念,ins_ver( )段取消
#                                                    3.原只分為MISC<->MISC,及非MISC<->非MISC,現改為以agli003設定為主
#                                                    4.Axg_file,ass_file新增「功能幣別匯率」「合併幣別匯率」記錄當時計算的匯率
# Modify........... NO.FUN-970046 09/07/13 BY yiting 1.gglp201在抓取aah_file,aed_file,asi_file寫入asr_file,ass_file時，應依科目性質處理是否做累計處理
#                                                      資產負債類做SUM(借-貸)處理，期別BETWEEN 0~截止期別，損益類則不做SUM
#                                                      寫入asr_file,ass_file時，只寫入截止期別，己產生過的期別不再異動
#                                                    2.寫入asj_file,ask_file時，對沖科目設定"股本"打勾者，才能處理"asu05 是否依股權沖銷" 
#                                                    3.寫入asj_file,ask_file時，只抓取截止期別當期資料寫入調整分錄
#                                                    4.因asf_file(asf08,asf09,asf10,asf11) schema異動，加asf06，原本日期條件改對應到asf06抓取資料，以公司+科目為key，抓於小於截止期別的資料SUM(asf13) 
#                                                    5.處理對沖科目時，如果來源科目找不到資料寫入調整分錄，但對沖科目找的到，也要寫進分錄中
# Modify.........: No.MOD-980063 09/08/11 By xiaofeizhu 如果各子公司先做月結，會把科目余額清0，金額拋成CE類的憑証
#                                                       但是這支p作業沒有考慮CE類的憑証，只抓科目余額過去，如果抓到0，那樣在aglr002里就打不出資料來了
#                                                       所以gglp201中需要增加判斷是否是損益類的科目，且余額為0，是的話就要去找CE類憑証中將這個科目的金額抓回來
# Modify.......... No.FUN-980074 09/08/18 By hongmei 計算累換調整數來源都應只有asr_file,不用再處理ass_file
# Modify.........: NO.FUN-980083 09/08/19 BY yiting gglp201在取異動月份最後一天日期時有誤 
# Modify.........: NO.FUN-980095 09/08/21 BY yiting 累換數計算條件有誤,應只計算科目性質為"資產負債類"會科
# Modify.........: NO.MOD-990059 09/09/07 BY sabrina 過單 
# Modify.........: NO.FUN-990020 09/09/08 BY yiting 1.在agli011中同一年度不同期別分別有股本異動二次，但GROUP SUM時因為有抓asf05造成無法把相同年度不同期別的合併金額加總
#                                                   2.外幣換算損益(aaz86)科目計算
# Modify.......... NO.FUN-9B0017 09/11/24 By mike 1.將異動碼科目余額檔aed_file做滾算至上層公司處理(異動碼5-8)asl_file，提供后續部門別合并財報使用
#                                                 2.gglp201目前有計算記賬幣別轉換功能幣別的金額, 差異歸入兌換損益處理
# Modify.........: No:MOD-A10005 10/01/04 By Sarah 修正FUN-990020,p001_adj()段SELECT後沒將值丟給變數,造成後續使用該變數時抓到Null值
# Modify.........: No.FUN-A10015 10/02/09 By chenmoyan
# Modify.........: No.FUN-A30064 10/03/19 By chenmoyan 合并報表-側流功能修正 開放子公司間互相對衝
# Modify.........: No.FUN-A30122 10/04/08 By chenmoyan 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: NO.FUN-A30079 10/03/24 By yiting 1.因應agli003加入合併主體asq16欄位，產生對沖分錄應以此為依據
#                                                   2.增加ass18,ass19,ass20,ass21記錄下層公司記帳/功能幣金額
# Modify.........: NO.MOD-A40158 10/04/27 By sabrina p001_asr_misc_p1的sql有誤，AMD改為AND
# Modify.........: NO.MOD-A40179 10/04/30 By sabrina 資產負債類科目產生之累換調整數之分錄有誤 
# Modify.........: NO.MOD-A50056 10/05/10 BY yiting 取g_aaz113的SQL被MARK掉
# Modify.........: NO.MOD-A60056 10/06/09 BY Dido 調整抓取語法與變數宣告 
# Modify.........: NO.MOD-A60080 10/06/11 BY Dido asj09 預設值為N 
# Modify.........: NO.FUN-A60038 10/06/15 by Yiting 1.BS本期損益數計算方式應同IS科目計算方式避免造成過大的累換數
#                                                   2.合併計算時沒有月結處理，需手動調整結清虛帳戶，不合理
# Modify.......... NO.FUN-A60060 10/06/22 by Yiting 1.側流問題  2.asi_file加入群組為條件 3.取atc_file要取位
# Modify.........: NO.FUN-A60078 10/06/24 BY yiting 產生沖銷分錄時，上下層公司條件取法
# Modify.........: NO.MOD-A60178 10/06/28 BY Dido p001_acc_amt 傳遞參數調整 
# Modify.........: NO.FUN-A60099 10/06/30 by Yiting 取沖銷來源金額時，中間層母公司的上下層公司條件應為自己
# Modify.........: NO.FUN-A70011 10/07/02 BY yiting 取對沖資料，最下層公司要加入上層公司=目前下層公司的上層公司 為條件
# Modify.........: NO.MOD-A70064 10/07/08 BY yiting 變數寫錯
# Modify.........: NO.FUN-A70053 10/07/09 BY yiting 本期損益BS科目設為平均匯率時，應各月乘各自匯率再累加
# Modify.........: NO.MOD-A70083 10/07/09 BY yiting 累換數分錄沒有產生
# Modify.........: NO.MOD-A70091 10/07/12 BY Dido ass18/19/20/21 應以原欄位計算 
# Modify.......... NO.FUN-A70065 10/07/12 BY yiting 資料來源為atc_file時,再衡量/換算採平均匯率計算方式,同一般由總帳來源資料算法
# Modify.........: NO.MOD-A70107 10/07/14 BY sabrina 將ash06的值給asr05
# Modify.........: NO.MOD-A70111 10/07/14 BY sabrina 若ashh06抓不到值時要顯示aap-021的錯誤訊息 
# Modify.........: NO.MOD-A70113 10/07/14 BY sabrina 使用asq10取得asg05，將取得的asg05作為asb05、asd05b的條件 
# Modify.........: NO.FUN-A70086 10/07/16 BY yiting agli011增加功能幣別/再衡量匯率/功能幣金額，換算採歷史匯率時，要依此寫入
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.......... NO.MOD-A80102 10/08/12 BY yiting 取來源atc,atcc的資料時，aag_file不需要跨資料庫
# Modify.........: NO.FUN-A80125 10/08/23 BY yiting 產生換匯分錄時如果計算的結果是沒有傳票單身，但傳票單頭不要產生
# Modify.........: NO.FUN-A80130 10/08/24 by Yiting 1.asr,ass取平均匯率的方式應分開計算
#                                                   2.計算科目平均匯率金額時，傳入科目變數參數應為轉換後科目
# Modify.........: NO.FUN-A80137 10/08/26 BY yiting 來源及目的公司對沖科目，可個別設定來源檔案
# Modify.........: NO.FUN-A90006 10/09/02 BY yiting 對沖科餘計算BS/IS皆採用累計式計算方式
# Modify.........: NO.FUN-A90026 10/09/14 BY yiting 1.aah->asm,aed->asn,aedd->asnn,asi->asm,asn,asnn
#                                                   2.輸入增加選項
# Modify.........: NO.FUN-A90036 (1)分錄順序改先產生換匯(step4) ->再產生沖銷分錄(step3)
#                                (2)沖銷分錄含累換數(asr + ask)
# Modify.........: NO.FUN-AA0005 10/10/04 BY yiting 取來源asm,asn匯入asr,ass時，加入調整分錄屬於1.調整作業者
# Modify.........: NO.TQC-AA0098 10/10/16 BY yiting 1.平均匯率(asa05)選擇1，匯率要倒除之前先判斷ash11,ash12匯率方式，為3.平均匯率者才倒除
#                                                   2.移除asg04(是否為TIPTOP公司條件) 因此段己移往aglp000處理
# Modify.........: NO.FUN-AA0093 10/10/28 BY yiting 當下層公司亦為上層公司時，沖銷分錄金額如科目採平均匯率，一律採累計額*當期匯率
# Modify.........: NO:CHI-B10030 11/01/24 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: NO.FUN-B50001 11/05/05 By zhangweib 考慮族群是否为分层合并
# Modify.........: NO.FUN-B50001 11/05/05 By zhangweib asr,ass新加栏位给值
# Modify.........: NO.FUN-B50001 11/05/09 By zhangweib 將INSERT ask,asj的功能拆分出去
# Modify.........: NO.MOD-B60197 11/06/24 BY Dido g_date_e變數在針對季或年時會無設定,需再重新給予
# Modify.........: No.FUN-B60159 11/07/01 By lutingting asm_file非tiptop公司時期別只取當期
# Modify.........: NO.FUN-B70064 11/08/09 BY belle gglp201計算時如選擇"3.當期科目餘額累積數*最末期平均匯率 " 時，以累計餘額* agli008當期匯率
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B80195 11/08/31 By lutingting 修改FUN-B50001導致的問題
# Modify.........: No.FUN-B90019 11/09/02 By lutingting 匯率改放在aglp000處理
# Modify.........: No.FUN-B90034 11/09/05 By lutingting asr12應該取合併族群最上層公司的幣別
# Modify.........: No.FUN-B90057 11/09/06 By lutingting 扣除本期損益(IS)
# Modify.........................11/09/26 By lutingting 从asj/ask_file产生asr_file的时候不必计算汇率
# Modify.........................11/09/26 By lutingting 从asj/ask_file产生asr_file/ass_file时币种要给最上层公司币种
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: NO.FUN-C80020 12/08/09 By Carrier 增加key 值字段 asm20/asn20/asnn20 合并年度 asm21/asn21/asnn21 合并期别
# Modify.........: No.TQC-C90057 12/09/20 By Carrier INSERT和UPDATE语句的WHERE里所有涉及 asr02/ass02/asl02=g_dept[i].asa02和asr03/ass03/asl03=g_dept[i].asa03的部分改成asr02 = tm.asa02及asr03 = tm.asa03
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD   #FUN-BB0036 
                  yy        LIKE type_file.num5,   #匯入會計年度  #No.FUN-680098     SMALLINT
                  bm        LIKE type_file.num5,   #起始期間      #No.FUN-680098     SMALLINT
                  em        LIKE type_file.num5,   #截止期間      #No.FUN-680098     SMALLINT
                  asa01     LIKE asa_file.asa01,   #族群代號
                  asa02     LIKE asa_file.asa02,   #上層公司編號
                  asa03     LIKE asa_file.asa03,   #帳別
                  gl        LIKE aac_file.aac01,   #調整單別
                  ver       LIKE asr_file.asr17,   #版本          #FUN-750078 add
                  hisyy     LIKE asr_file.asr06,   #歷史匯率年度  #FUN-750078 add
                  hismm     LIKE asr_file.asr07,    #歷史匯率期別  #FUN-750078 add
                  asa06     LIKE asa_file.asa06,   #FUN-A90026 
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
       g_ass      RECORD LIKE ass_file.*,
       g_asr      RECORD LIKE asr_file.*,          #FUN-760053 add
       g_rate     LIKE type_file.num20_6,          #FUN-770069 mod
       g_aac      RECORD LIKE aac_file.*,
       g_asj      RECORD LIKE asj_file.*,
       g_ask      RECORD LIKE ask_file.*,
       g_i        LIKE type_file.num5,             #count/index for any purpose     #No.FUN-680098 SMALLINT
       g_amt      LIKE asr_file.asr08,             #FUN-5A011                       #No.FUN-680098 DECIMAL(20,6)    
       g_asr04    LIKE asr_file.asr04,             #FUN-770068 add 09/12                       #No.FUN-680098 DECIMAL(20,6)    
       g_ass10_d  LIKE ass_file.ass10,             #FUN-750078 add
       g_ass10_c  LIKE ass_file.ass10,             #FUN-750078 add
       g_asq      RECORD LIKE asq_file.*,          #FUN-750078 add
       g_asu03    LIKE asu_file.asu03,             #FUN-750078 add
       g_ast03    LIKE ast_file.ast03,             #FUN-760053 add
       g_asv03    LIKE asv_file.asv03,             #FUN-760053 add
       g_affil    LIKE ask_file.ask05,             #FUN-760053 add
       g_dc       LIKE ask_file.ask06,             #FUN-760053 add
       g_flag_r   LIKE type_file.chr1,             #FUN-760053 add
       g_yy       LIKE type_file.num5,             #FUN-770069 add
       g_mm       LIKE type_file.num5,             #FUN-770069 add
       g_em       LIKE type_file.chr10             #FUN-770069 add
#DEFINE g_aaz641        LIKE aaz_file.aaz641        #FUN-920067   #FUN-B50001
DEFINE g_asz01        LIKE asz_file.asz01        #FUN-920067
#DEFINE g_aaz113        LIKE aaz_file.aaz113        #FUN-A30079   #FUN-B50001
DEFINE g_asz05        LIKE asz_file.asz05  
DEFINE g_dbs_asg03     LIKE type_file.chr21        #FUN-920067
DEFINE g_asg03         LIKE asg_file.asg03         #FUN-920067
DEFINE g_sql           STRING                      #FUN-920067
#DEFINE g_aaz641_asb04  LIKE aaz_file.aaz641        #FUN-930117   #FUN-B50001
DEFINE g_asz01_asb04  LIKE asz_file.asz01
DEFINE g_dbs_asb04     LIKE type_file.chr21        #FUN-930117
DEFINE g_newno         LIKE asj_file.asj01         #FUN-930144
DEFINE g_asa        DYNAMIC ARRAY OF RECORD        
                    asa01      LIKE asa_file.asa01,  #族群代號
                    asa02      LIKE asa_file.asa02,  #上層公司
                    asa03      LIKE asa_file.asa03   #帳別
                   #asa00      LIKE asa_file.asa03   #帳別         #MOD-A60056 mark
                    END RECORD 
DEFINE g_ass09_o    LIKE ass_file.ass09,             #期別
       g_ass09_o1   LIKE ass_file.ass09,             #期別  
       g_ass07_o    LIKE ass_file.ass07,             #異動碼值
       g_ass07_o1   LIKE ass_file.ass07             #異動碼值 
DEFINE g_asr07_o    LIKE asr_file.asr07,             #期別
       g_asr07_o1   LIKE asr_file.asr07             #期別  
DEFINE g_ass07      LIKE ass_file.ass07      #FUN-960096
DEFINE g_ask07_total  LIKE ask_file.ask07    #FUN-970046
DEFINE g_date_e     LIKE type_file.dat       #FUN-970046
DEFINE g_cnt_asq09  LIKE type_file.num5      #FUN-A30079
DEFINE g_cnt_asq10  LIKE type_file.num5      #FUN-A30079
DEFINE g_dbs_asq09  LIKE azp_file.azp03      #FUN-A30079 
DEFINE g_dbs_asq10  LIKE azp_file.azp03      #FUN-A30079 
#FUN-B50001--mod--str--
#DEFINE g_aaz641_asq09 LIKE aaz_file.aaz641   #FUN-A30079
#DEFINE g_aaz641_asq10 LIKE aaz_file.aaz641   #FUN-A30079
DEFINE g_asz01_asq09 LIKE asz_file.asz01 
DEFINE g_asz01_asq10 LIKE asz_file.asz01
#FUN-B50001--mod--end
#DEFINE g_aaz114       LIKE aaz_file.aaz114   #FUN-A60038   #FUN-B50001
DEFINE g_asz06       LIKE asz_file.asz06
#----FUN-A60038 start---
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                     END RECORD
DEFINE l_rate        LIKE ase_file.ase05             #功能幣別匯率    
DEFINE l_rate1       LIKE ase_file.ase05             #記帳幣別匯率   
#------FUN-A60038 end---
DEFINE g_asq09_asg05 LIKE asg_file.asg05   #FUN-A90006
DEFINE g_asq10_asg05 LIKE asg_file.asg05   #FUN-A90006
DEFINE g_asg08       LIKE asg_file.asg08   #FUN-A90006
DEFINE g_asg08_asq10 LIKE asg_file.asg08   #FUN-A90006
DEFINE g_low_asq09        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_asq09         LIKE type_file.num5    #FUN-A90006
DEFINE g_low_asq10        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_asq10         LIKE type_file.num5    #FUN-A90006
DEFINE g_asa02_asq09      LIKE asa_file.asa02    #FUN-A90006
DEFINE g_asa02_asq10      LIKE asa_file.asa02    #FUN-A90006
DEFINE g_asa09_asq09      LIKE asa_file.asa09    #FUN-A90006
DEFINE g_asa09_asq10      LIKE asa_file.asa09    #FUN-A90006
DEFINE g_asg06_asq09      LIKE asg_file.asg06    #FUN-A90006
DEFINE g_asg06_asq10      LIKE asg_file.asg06    #FUN-A90006
#---FUN-A90026 start-----------------------------------
DEFINE g_asm              RECORD 
                          asm04  LIKE asm_file.asm04,
                          asm05  LIKE asm_file.asm05,
                          asm07  LIKE asm_file.asm07,
                          asm08  LIKE asm_file.asm08,
                          asm09  LIKE asm_file.asm09,
                          asm10  LIKE asm_file.asm10,
                          asm11  LIKE asm_file.asm11
#FUN-B50001   ---start
                         ,asm12  LIKE asm_file.asm12,
                          asm13  LIKE asm_file.asm13,
                          asm14  LIKE asm_file.asm14,
                          asm15  LIKE asm_file.asm15,
                          asm16  LIKE asm_file.asm16,
                          asm17  LIKE asm_file.asm17,
                          asm18  LIKE asm_file.asm18
#FUN-B50001   ---end
                          END RECORD
DEFINE g_asn              RECORD 
                          asn04  LIKE asn_file.asn04,
                          asn05  LIKE asn_file.asn05,
                          asn06  LIKE asn_file.asn06,
                          asn08  LIKE asn_file.asn08,
                          asn09  LIKE asn_file.asn09,
                          asn10  LIKE asn_file.asn10,
                          asn11  LIKE asn_file.asn11
                          ,asn13  LIKE asn_file.asn13,   #FUN-B50001  Add
                          asn14  LIKE asn_file.asn14,   #FUN-B50001  Add
                          asn15  LIKE asn_file.asn15,   #FUN-B50001  Add
                          asn16  LIKE asn_file.asn16,   #FUN-B50001  Add
                          asn17  LIKE asn_file.asn17,   #FUN-B50001  Add
                          asn18  LIKE asn_file.asn18,   #FUN-B50001  Add
                          asn19  LIKE asn_file.asn19    #FUN-B50001  Add
                          END RECORD
DEFINE g_asnn              RECORD 
                          asnn04  LIKE asnn_file.asnn04,
                          asnn05  LIKE asnn_file.asnn05,
                          asnn06  LIKE asnn_file.asnn06,
                          asnn07  LIKE asnn_file.asnn07,
                          asnn08  LIKE asnn_file.asnn08,
                          asnn09  LIKE asnn_file.asnn09,
                          asnn11  LIKE asnn_file.asnn11,
                          asnn12  LIKE asnn_file.asnn12,
                          asnn13  LIKE asnn_file.asnn13,
                          asnn14  LIKE asnn_file.asnn14,
                          asnn15  LIKE asnn_file.asnn15
                          END RECORD
#---FUN-AA0005 start---
DEFINE g_ask1             RECORD 
                          ask06  LIKE ask_file.ask06,
                          ask07  LIKE ask_file.ask07
                          END RECORD
#---FUN-AA0005 end------
DEFINE g_asa06            LIKE asa_file.asa06    
DEFINE g_asa05            LIKE asa_file.asa05
DEFINE g_type             LIKE type_file.chr1  
DEFINE g_flag             LIKE type_file.chr1
#----FUN-A90026 end---------------------------------------
DEFINE g_azw02            LIKE azw_file.azw02
#FUN-B80135--add--str--
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add--end
DEFINE g_asz            RECORD LIKE asz_file.*   #FUN-B90057


MAIN
DEFINE l_asg03  LIKE asg_file.asg03

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   #--FUN-A90026 start----
   LET tm.asa01 = ARG_VAL(1)
   LET tm.asa02 = ARG_VAL(2)
   LET tm.asa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.asa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
  #FUN-B50001--mod--str--
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
  #FUN-B50001--mod--end
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add
   
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add--end---
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00='0'  #FUN-B80135
   SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0'    #FUN-B90057
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL gglp201_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02     #MOD-660034
           SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = tm.asa02
           SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_asg03
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
              CLOSE WINDOW gglp201_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        #No.FUN-B80135-mod--str--
        # SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07      #MOD-660034
        #  FROM aaa_file WHERE aaa01 = g_bookno
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file WHERE aaa01 = g_asz01
        #FUN-B80135--mod--end--
        SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02     #MOD-660034
        SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = tm.asa02
        SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_asg03
       
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

FUNCTION gglp201_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_cnt          LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_asa03        LIKE asa_file.asa03           #FUN-580063
   DEFINE  lc_cmd         LIKE type_file.chr1000        #No.FUN-570145       #No.FUN-680098 VARCHAR(500)    
   DEFINE  l_asa09        LIKE asa_file.asa09           #FUN-A30079 
   DEFINE  l_aznn01       LIKE aznn_file.aznn01         #FUN-A90026 
   DEFINE  l_asg03        LIKE asg_file.asg03          #CHI-B10030 add
     
   IF s_shut(0) THEN RETURN END IF
   #CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW gglp201_w AT p_row,p_col WITH FORM "ggl/42f/gglp201" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

  # CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
     #No.FUN-B80135-mark--str--
     # SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    #MOD-660034
     #   FROM aaa_file 
     #  WHERE aaa01 = g_bookno
     #No.FUN-B80135--mark—end—
     #FUN-B80135--add--str--
     #現行會計年度(aaa04)、現行期別(aaa05)
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file WHERE aaa01 = g_asz01
     #FUN-B80135--add--end--

      SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02     #MOD-660034

      LET tm.yy = g_aaa04         
      LET tm.bm = 0                #FUN-950048
      DISPLAY tm.bm TO FORMONLY.bm #FUN-950048
      LET tm.em = g_aaa05          
      LET tm.ver = '00'        #FUN-760044 add
      LET tm.hisyy = g_aaa04   #FUN-760044 add
      LET tm.hismm = g_aaa05   #FUN-760044 add
      LET g_bgjob = 'N'        #No:FUN-570145  

      #--FUN-A90026 start--
      #INPUT BY NAME tm.yy,tm.em,tm.asa01,tm.asa02,tm.gl,g_bgjob  #NO.FUN-570145   #FUN-920067 del tm.asa03 #FUN-950048 mod
      #             ,tm.ver,tm.hisyy,tm.hismm   #FUN-750078 add
      #INPUT BY NAME tm.asa01,tm.asa02,tm.yy,tm.asa06,tm.em,tm.q1,tm.h1,tm.gl,g_bgjob,    #FUN-B50001 
      INPUT BY NAME tm.asa01,tm.asa02,tm.yy,tm.asa06,tm.em,tm.q1,tm.h1,g_bgjob,    #FUN-B50001 
                    tm.ver,tm.hisyy,tm.hismm  
      #--FUN-A90026 end---
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE    #NO.FUN-570145 
            EXIT INPUT                  #NO.FUN-570145
     
        #No.FUN-B80135--add--str--
         AFTER FIELD  yy
            IF NOT cl_null(tm.yy) THEN
              IF tm.yy < 0 THEN
                  CALL cl_err(tm.yy,'apj-035',0)
                  NEXT FIELD yy
               END IF
               IF tm.yy<g_year  THEN
                  CALL cl_err(tm.yy,'atp-164',0)
                  NEXT FIELD yy
               END IF
               IF tm.yy=g_year AND tm.em<=g_month THEN
                     CALL cl_err(tm.em,'atp-164',0)
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
                 WHERE azm01 = g_asi.asi06
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
                   CALL cl_err(tm.em,'atp-164',0)
                   NEXT FIELD em
                END IF 
            END IF
         #FUN-B80135--add--end-- 
         #--FUN-A90026 start-
         AFTER FIELD q1    #季
            IF cl_null(tm.q1) AND  g_asa06 = '2' THEN 
               NEXT FIELD q1 
            END IF
           IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
              NEXT FIELD q1
           END IF
            #FUN-B80195--add--str--COPY FROM #FUN-A90026 AFTER FIELD gl段
            IF NOT cl_null(tm.asa06) THEN
                 CASE
                     WHEN tm.asa06 = '1'  #月
                          LET tm.bm = 0
                     WHEN tm.asa06 = '2'  #季
                          SELECT MAX(aznn01) INTO l_aznn01
                            FROM aznn_file
                           WHERE aznn00 = tm.asa03
                             AND aznn02 = tm.yy
                             AND aznn03 = tm.q1
                          LET tm.em = MONTH(l_aznn01)
                     WHEN tm.asa06 = '3'  #半年
                          IF tm.h1 = '1' THEN  #上半年
                              SELECT MAX(aznn01) INTO l_aznn01
                                FROM aznn_file
                               WHERE aznn00 = tm.asa03
                                 AND aznn02 = tm.yy
                                 AND aznn03 < 3
                          ELSE                 #下半年
                              SELECT MAX(aznn01) INTO l_aznn01
                                FROM aznn_file
                               WHERE aznn00 = tm.asa03
                                 AND aznn02 = tm.yy
                                 AND aznn03 >='3' #大於等於第三季
                          END IF
                          LET tm.em = MONTH(l_aznn01)
                     WHEN tm.asa06 = '4'  #年
                          SELECT MAX(aznn01) INTO l_aznn01
                            FROM aznn_file
                           WHERE aznn00 = tm.asa03
                             AND aznn02 = tm.yy
                             LET tm.em = MONTH(l_aznn01)
                 END CASE
             END IF
         #FUN-B80195--add--end
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.asa06='4' THEN
               NEXT FIELD h1
            END IF
         #--FUN-A90026 end
            #FUN-B80195--add--str--COPY FROM #FUN-A90026 AFTER FIELD gl段
            IF NOT cl_null(tm.asa06) THEN
                 CASE
                     WHEN tm.asa06 = '1'  #月
                          LET tm.bm = 0
                     WHEN tm.asa06 = '2'  #季
                          SELECT MAX(aznn01) INTO l_aznn01
                            FROM aznn_file
                           WHERE aznn00 = tm.asa03
                             AND aznn02 = tm.yy
                             AND aznn03 = tm.q1
                          LET tm.em = MONTH(l_aznn01)
                     WHEN tm.asa06 = '3'  #半年
                          IF tm.h1 = '1' THEN  #上半年
                              SELECT MAX(aznn01) INTO l_aznn01
                                FROM aznn_file
                               WHERE aznn00 = tm.asa03
                                 AND aznn02 = tm.yy
                                 AND aznn03 < 3
                          ELSE                 #下半年
                              SELECT MAX(aznn01) INTO l_aznn01
                                FROM aznn_file
                               WHERE aznn00 = tm.asa03
                                 AND aznn02 = tm.yy
                                 AND aznn03 >='3' #大於等於第三季
                          END IF
                          LET tm.em = MONTH(l_aznn01)
                     WHEN tm.asa06 = '4'  #年
                          SELECT MAX(aznn01) INTO l_aznn01
                            FROM aznn_file
                           WHERE aznn00 = tm.asa03
                             AND aznn02 = tm.yy
                             LET tm.em = MONTH(l_aznn01)
                 END CASE
             END IF
         #FUN-B80195--add--end
           
         AFTER FIELD asa01
            IF NOT cl_null(tm.asa01) THEN
               SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01 #no.6155
               IF STATUS THEN
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-11","","",0)  #No.FUN-660123
                  NEXT FIELD asa01 
               END IF
            END IF

         AFTER FIELD asa02  #公司編號
            IF NOT cl_null(tm.asa02) THEN
               SELECT count(*) INTO l_cnt FROM asa_file 
                WHERE asa01=tm.asa01 AND asa02=tm.asa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa02 
               END IF
               SELECT DISTINCT asa03 INTO l_asa03 FROM asa_file
                WHERE asa01=tm.asa01   #FUN-580063
                  AND asa02=tm.asa02   #FUN-580063
               LET tm.asa03 = l_asa03     #FUN-580063
               DISPLAY l_asa03 TO asa03   #FUN-580063
#---FUN-A30122 mark------
#               SELECT asg03 INTO g_asg03 FROM asg_file
#                WHERE asg01 = tm.asa02
#               #--FUN-A30079 start---
#               SELECT azp03 INTO g_dbs_asg03 
#                 FROM azp_file 
#                WHERE azp01 = g_asg03
#               SELECT asa09 INTO l_asa09 
#                 FROM asa_file
#                WHERE asa01 = tm.asa01
#                  AND asa02 = tm.asa02
#               IF l_asa09 = 'Y' THEN
#                   LET g_dbs_asg03 = s_dbstring(g_dbs_asg03)
#               ELSE
#                   LET g_dbs_asg03 = s_dbstring(g_dbs)
#               END IF
#               #LET g_plant_new = g_asg03      #營運中心
#               #CALL s_getdbs()
#               #IF cl_null(g_dbs_new) THEN            #FUN-930117
#               #    LET g_dbs_new=g_dbs CLIPPED,'.'   #FUN-930117
#               #END IF                                #FUN-930117
#               #LET g_dbs_asg03 = g_dbs_new    #上層公司所屬DB
#               #--FUN-A30079 end---
#-----FUN-A30122 mark----------------------------------

               #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",
               #LET g_sql = "SELECT aaz113,aaz641 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A30079
               #LET g_sql = "SELECT aaz113 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A30079  #MOD-A50056
#FUN-B50001--mod--str--
#              LET g_sql = "SELECT aaz113,aaz114 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A60038
#                          " WHERE aaz00 = '0'"
               LET g_sql = "SELECT asz05,asz06 FROM ",g_dbs_asg03,"asz_file", 
                           " WHERE asz00 = '0'"
#FUN-B50001--mod--end
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
               PREPARE p001_pre_01 FROM g_sql
               DECLARE p001_cur_01 CURSOR FOR p001_pre_01
               OPEN p001_cur_01
               #FETCH p001_cur_01 INTO g_aaz641   #合併帳別
               #FETCH p001_cur_01 INTO g_aaz113,g_aaz641   #合併帳別  #FUN-A30079
               #FETCH p001_cur_01 INTO g_aaz113             #MOD-A50056
               #FETCH p001_cur_01 INTO g_aaz113,g_aaz114     #FUN-A60038   #FUN-B50001
               FETCH p001_cur_01 INTO g_asz05,g_asz06
               CLOSE p001_cur_01
               CALL s_aaz641_asg(tm.asa01,tm.asa02) RETURNING g_dbs_asg03  #FUN-A30122 add
               #CALL s_get_aaz641(g_dbs_asg03) RETURNING g_aaz641           #FUN-A30122 add   #FUN-B50001
               CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
            END IF
            DISPLAY l_asa03 TO asa03   #FUN-580063

            #--FUN-A90026 start---
            LET g_asa06 = '2'
            SELECT asa05,asa06 
              INTO g_asa05,g_asa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM asa_file
            WHERE asa01 = tm.asa01     #族群編號
              AND asa04 = 'Y'   #最上層公司否
            LET tm.asa06 = g_asa06
            DISPLAY BY NAME tm.asa06
            CALL p001_set_entry()    
            CALL p001_set_no_entry()

            IF tm.asa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.asa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.asa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.asa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1
         #---FUN-A90026 end----
            #---FUN-A90026 end---

       #FUN-B50001--mark--str--
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
       #     IF NOT cl_null(tm.asa06) THEN
       #         CASE
       #             WHEN tm.asa06 = '1'  #月 
       #                  LET tm.bm = 0
       #             WHEN tm.asa06 = '2'  #季 
       #                  SELECT MAX(aznn01) INTO l_aznn01
       #                    FROM aznn_file
       #                   WHERE aznn00 = tm.asa03
       #                     AND aznn02 = tm.yy
       #                     AND aznn03 = tm.q1
       #                  LET tm.em = MONTH(l_aznn01)
       #             WHEN tm.asa06 = '3'  #半年
       #                  IF tm.h1 = '1' THEN  #上半年
       #                      SELECT MAX(aznn01) INTO l_aznn01
       #                        FROM aznn_file
       #                       WHERE aznn00 = tm.asa03
       #                         AND aznn02 = tm.yy
       #                         AND aznn03 < 3
       #                  ELSE                 #下半年
       #                      SELECT MAX(aznn01) INTO l_aznn01
       #                        FROM aznn_file
       #                       WHERE aznn00 = tm.asa03
       #                         AND aznn02 = tm.yy
       #                         AND aznn03 >='3' #大於等於第三季
       #                  END IF
       #                  LET tm.em = MONTH(l_aznn01)
       #             WHEN tm.asa06 = '4'  #年
       #                  SELECT MAX(aznn01) INTO l_aznn01
       #                    FROM aznn_file
       #                   WHERE aznn00 = tm.asa03
       #                     AND aznn02 = tm.yy
       #                  LET tm.em = MONTH(l_aznn01)
       #         END CASE
       #     END IF
       #     #--FUN-A90026
       #FUN-B50001--mark--end

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

         #ON ACTION CONTROLZ    #TQC-C40010  mark
         ON ACTION CONTROLR     #TQC-C40010  add
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa"
                  LET g_qryparam.default1 = tm.asa01
                  CALL cl_create_qry() RETURNING tm.asa01,tm.asa02,tm.asa03
                  DISPLAY BY NAME tm.asa01,tm.asa02,tm.asa03
                  NEXT FIELD asa01
               WHEN INFIELD(asa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asg"
                  LET g_qryparam.default1 = tm.asa02
                  CALL cl_create_qry() RETURNING tm.asa02
                  DISPLAY BY NAME tm.asa02
                  NEXT FIELD asa02
              #FUN-B50001--mark--str--
              # WHEN INFIELD(gl) #單據性質
              #    CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','GGL')  #TQC-670078 
              #         RETURNING tm.gl         
              #    DISPLAY  BY NAME tm.gl  
              #    NEXT FIELD gl     
              #FUN-B50001--mark--end
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
      CLOSE WINDOW gglp201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   #CHI-B10030 add --start--
   IF tm.asa06 MATCHES '[234]' THEN      
      CALL s_asg03_dbs(tm.asa02) RETURNING l_asg03 
      CALL s_get_aznn01(l_asg03,tm.asa06,tm.asa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
   END IF
   #CHI-B10030 add --end--
   LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #MOD-B60197
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01= 'gglp201'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('gglp201','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      #--FUN-A90026 start--
                      " ''",
                      " '",tm.asa01,"'", 
                      " '",tm.asa02,"'", 
                      " '",tm.asa03,"'", 
                      " '",tm.yy,"'",    
                      " '",tm.asa06,"'", 
                      " '",tm.em,"'",    
                      " '",tm.q1,"'",    
                      " '",tm.h1,"'",    
                      #" '",tm.gl,"'",   #FUN-B50001 
                      #---FUN-A90026 end----
                      #---FUN-A90026 mark--
                      #" ''",
                      #" '",tm.yy CLIPPED,"'",
                      #" '",tm.bm CLIPPED,"'",
                      #" '",tm.em CLIPPED,"'",
                      #" '",tm.asa01 CLIPPED,"'",
                      #" '",tm.asa02 CLIPPED,"'",
                      #" '",tm.asa03 CLIPPED,"'",
                      #--FUN-A90026 mark-------
                      #" '",tm.gl CLIPPED,"'",      #FUN-B50001
                      " '",tm.ver CLIPPED,"'",      #FUN-750078 add
                      " '",tm.hisyy CLIPPED,"'",    #FUN-750078 add
                      " '",tm.hismm CLIPPED,"'",    #FUN-750078 add
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('gglp201',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW gglp201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p001()
DEFINE l_cnt        LIKE type_file.num5   #luttb 110926 test
#DEFINE l_sql        LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(1000)
DEFINE l_sql        STRING,                   #FUN-A60038
       l_sql_asf    LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(1000)
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
       l_asl16       LIKE asl_file.asl16,
       l_asl17       LIKE asl_file.asl17,
       l_chg_asll11_1 LIKE asf_file.asf13,
       l_chg_asll12_1 LIKE asf_file.asf13,
       l_chg_asll11   LIKE asf_file.asf13,
       l_chg_asll12   LIKE asf_file.asf13,
       l_chg_asll11_a LIKE asf_file.asf13,
       l_chg_asll12_a LIKE asf_file.asf13,
       l_asll        RECORD LIKE asll_file.*,
       l_chg_aedd05   LIKE aed_file.aed05,             #功能幣別借方總金額
       l_chg_aedd06   LIKE aed_file.aed06,             #功能幣別貸方總金額
       l_chg_aedd05_1 LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aedd06_1 LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aedd05_a LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aedd06_a LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_asi1        RECORD                                       #FUN-580063
                     asi05      LIKE asi_file.asi05,  #科目年度
                     asi06      LIKE asi_file.asi06,  #會計年度
                     asi07      LIKE asi_file.asi07,  #期別
                     asi08      LIKE asi_file.asi08,  #借方金額
                     asi09      LIKE asi_file.asi09,  #貸方金額
                     asi10      LIKE asi_file.asi10,  #借方筆數
                     asi11      LIKE asi_file.asi11,  #貸方筆數
                     asi13      LIKE asi_file.asi13   #關係人代號 
                     END RECORD,
       l_asi         RECORD          
                     asi00      LIKE asi_file.asi00,
                     asi01      LIKE asi_file.asi01,
                     asi02      LIKE asi_file.asi02,
                     asi03      LIKE asi_file.asi03,
                     asi04      LIKE asi_file.asi04,
                     asi041     LIKE asi_file.asi041,
                     asi05      LIKE asi_file.asi05,
                     asi06      LIKE asi_file.asi06,
                     asi07      LIKE asi_file.asi07,
                     asi08      LIKE asi_file.asi08,
                     asi09      LIKE asi_file.asi09,
                     asi10      LIKE asi_file.asi10,
                     asi11      LIKE asi_file.asi11,
                     asi12      LIKE asi_file.asi12,
                     asi13      LIKE asi_file.asi13
                     END RECORD,
#----FUN-A60038 mark----移到global變數---
#       g_dept        DYNAMIC ARRAY OF RECORD        
#                     asa01      LIKE asa_file.asa01,  #族群代號
#                     asa02      LIKE asa_file.asa02,  #上層公司
#                     asa03      LIKE asa_file.asa03,  #帳別
#                     asb04      LIKE asb_file.asb04,  #下層公司
#                     asb05      LIKE asb_file.asb05   #帳別  
#                     END RECORD,
#---FUN-A60038 mark----------------------
       l_ash         RECORD                                       #FUN-580063
                     #ash06      LIKE ash_file.ash06,  #合併後財報會計科目編號  #FUN-A90026 mark
                     ash04      LIKE ash_file.ash04,  #TQC-AA0098
                     ash11      LIKE ash_file.ash11,  #再衡量匯率類別
                     ash12      LIKE ash_file.ash12   #換算匯率類別
                     END RECORD,
       l_ashh        RECORD  
       #             ashh06     LIKE ashh_file.ashh06,  #合併後財報會計科目編號   #FUN-A90026 mark
                     ashh04     LIKE ashh_file.ashh04,  #TQC-AA0098
                     ashh11     LIKE ashh_file.ashh11,  #再衡量匯率類別
                     ashh12     LIKE ashh_file.ashh12   #換算匯率類別
                     END RECORD,
       l_atc         RECORD LIKE atc_file.*,
       l_atcc        RECORD LIKE atcc_file.*,         #FUN-910023 add 
       l_ash06       LIKE ash_file.ash06,             #合併後財報會計科目編號
       l_ashh06      LIKE ashh_file.ashh06,           #合併後財報會計科目編號   #FUN-920067
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
       l_chg_asi08   LIKE asi_file.asi08,             #功能幣別借方金額   #FUN-580063
       l_chg_asi09   LIKE asi_file.asi09,             #功能幣別貸方金額   #FUN-580063
       l_chg_asi08_1 LIKE asi_file.asi08,             #記帳幣別借方金額   #FUN-580063
       l_chg_asi09_1 LIKE asi_file.asi09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_asi08_a LIKE asi_file.asi08,             #記帳幣別借方金額   #FUN-580063
       l_chg_asi09_a LIKE asi_file.asi09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_atc08   LIKE atc_file.atc08,             #功能幣別借方金額   #FUN-580063
       l_chg_atc09   LIKE atc_file.atc09,             #功能幣別貸方金額   #FUN-580063
       l_chg_atc08_1 LIKE atc_file.atc08,             #記帳幣別借方金額   #FUN-580063
       l_chg_atc09_1 LIKE atc_file.atc09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_atc08_a LIKE atc_file.atc08,             #記帳幣別借方金額   #FUN-580063
       l_chg_atc09_a LIKE atc_file.atc09,             #記帳幣別貸方金額   #FUN-580063
       l_chg_atcc10   LIKE atcc_file.atcc10,          #功能幣別借方金額   #FUN-910023 add                                           
       l_chg_atcc11   LIKE atcc_file.atcc11,          #功能幣別貸方金額   #FUN-910023 add                                           
       l_chg_atcc10_1 LIKE atcc_file.atcc10,          #記帳幣別借方金額   #FUN-910023 add                                           
       l_chg_atcc11_1 LIKE atcc_file.atcc11,          #記帳幣別貸方金額   #FUN-910023 add                                           
       l_chg_atcc10_a LIKE atcc_file.atcc10,          #記帳幣別借方金額   #FUN-910023 add                                           
       l_chg_atcc11_a LIKE atcc_file.atcc11,          #記帳幣別貸方金額   #FUN-910023 add
       l_n           LIKE type_file.num5,             #No.FUN-680098 SMALLINT
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)                  #No.FUN-680098  SMALLINT
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別) #FUN-5A0020      #No.FUN-680098  SMALLINT
       #l_rate        LIKE ase_file.ase05,             #功能幣別匯率       #No:FUN-4B0072   #No.FUN-680098  DECIMAL(20,6)  #FUN-A60038 mark
       #l_rate1       LIKE ase_file.ase05,             #記帳幣別匯率       #FUN-580063      #No.FUN-680098  DECIMAL(20,6)  #FUN-A60038 mark
       l_asg04       LIKE asg_file.asg04,             #使用TIPTOP否
       l_asg06       LIKE asg_file.asg06,             #上層公司記帳幣別   #FUN-580063
       l_asg         RECORD LIKE asg_file.*,                              #FUN-580063
       l_ase08       LIKE ase_file.ase08,                                 #FUN-580063
       l_ase09       LIKE ase_file.ase09,                                 #FUN-580063
       l_asg03       LIKE asg_file.asg03,             #TQC-660043
       l_asf05       LIKE asf_file.asf05,             #FUN-760053 add
       l_asf08       LIKE asf_file.asf08,             #FUN-770069 add
       l_asf09       LIKE asf_file.asf09,             #FUN-770069 add
       l_aag06       LIKE aag_file.aag06              #FUN-760053 add
DEFINE l_aag04       LIKE aag_file.aag04              #FUN-760053 add
DEFINE l_bs_yy       LIKE type_file.num5              #FUN-760053 add
DEFINE l_bs_mm       LIKE type_file.num5              #FUN-760053 add
#DEFINE l_aaz641      LIKE aaz_file.aaz641             #FUN-920067   #FUN-B50001
DEFINE l_asz01       LIKE asz_file.asz01
DEFINE l_asf_count   LIKE type_file.num5              #FUN-920167
DEFINE l_asf13       LIKE asf_file.asf13              #FUN-930018 add
DEFINE l_asr18       LIKE asr_file.asr18              #FUN-960003
DEFINE l_asr19       LIKE asr_file.asr19              #FUN-960003
DEFINE l_ass16       LIKE ass_file.ass16              #FUN-960003
DEFINE l_ass17       LIKE ass_file.ass17              #FUN-960003
DEFINE l_asi05       STRING                           #FUN-960096
DEFINE l_ash04       LIKE asf_file.asf07              #FUN-970046
DEFINE l_ash04_cnt   LIKE type_file.num5              #FUN-970046 
DEFINE l_asa09       LIKE asa_file.asa09              #FUN-970046
DEFINE l_aah04       LIKE aah_file.aah04              #MOD-980063
DEFINE l_chg_dr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_chg_cr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_asj081      LIKE asj_file.asj081     
DEFINE l_fun_dr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_fun_cr      LIKE aah_file.aah04              #借方金額  #FUN-A60038
DEFINE l_acc_dr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_acc_cr      LIKE aah_file.aah05              #貸方金額  #FUN-A60038
DEFINE l_aah04_1     LIKE aah_file.aah04              #FUN-A60038
DEFINE l_aah05_1     LIKE aah_file.aah05              #FUN-A60038
DEFINE l_aed05       LIKE aed_file.aed05              #FUN-A60038
DEFINE l_aed06       LIKE aed_file.aed06              #FUN-A60038
DEFINE l_asi08       LIKE asi_file.asi08              #FUN-A60038
DEFINE l_asi09       LIKE asi_file.asi09              #FUN-A60038
#DEFINE l_aedd05      LIKE aedd_file.aedd05            #FUN-A60038
#DEFINE l_aedd06      LIKE aedd_file.aedd06            #FUN-A60038
DEFINE l_dr          LIKE aah_file.aah04              #FUN-A70053
DEFINE l_cr          LIKE aah_file.aah05              #FUN-A70053
DEFINE l_atc08       LIKE atc_file.atc08              #FUN-A70065
DEFINE l_atc08_1     LIKE atc_file.atc08              #FUN-A70065
DEFINE l_atc08_2     LIKE atc_file.atc08              #FUN-A70065
DEFINE l_atc09       LIKE atc_file.atc09              #FUN-A70065
DEFINE l_atc09_1     LIKE atc_file.atc09              #FUN-A70065
DEFINE l_atc09_2     LIKE atc_file.atc09              #FUN-A70065
DEFINE l_atcc10      LIKE atcc_file.atcc10            #FUN-A70065
DEFINE l_atcc10_1    LIKE atcc_file.atcc10            #FUN-A70065
DEFINE l_atcc10_2    LIKE atcc_file.atcc10            #FUN-A70065
DEFINE l_atcc11      LIKE atcc_file.atcc11            #FUN-A70065
DEFINE l_atcc11_1    LIKE atcc_file.atcc11            #FUN-A70065
DEFINE l_atcc11_2    LIKE atcc_file.atcc11            #FUN-A70065
DEFINE l_asll11      LIKE asll_file.asll11            #FUN-A70065
DEFINE l_asll12      LIKE asll_file.asll12            #FUN-A70065
DEFINE l_asll11_1    LIKE asll_file.asll11            #FUN-A70065
DEFINE l_asll11_2    LIKE asll_file.asll11            #FUN-A70065
DEFINE l_asll12_1    LIKE asll_file.asll12            #FUN-A70065
DEFINE l_asll12_2    LIKE asll_file.asll12            #FUN-A70065
DEFINE l_mm          LIKE type_file.chr4              #FUN-A90006
DEFINE l_asi_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aah_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aed_cnt     LIKE type_file.num5              #FUN-A90006
DEFINE l_aed01       LIKE aed_file.aed01              #FUN-A90006
DEFINE l_aah01       LIKE aah_file.aah01              #FUN-A90006
DEFINE l_aah02       LIKE aah_file.aah02              #FUN-A90006
DEFINE l_aah03       LIKE aah_file.aah03              #FUN-A90006
DEFINE l_aed02       LIKE aed_file.aed02              #FUN-A90006
DEFINE l_ass         RECORD LIKE ass_file.*           #FUN-A90006
DEFINE l_asr         RECORD LIKE asr_file.*           #FUN-A90006
DEFINE l_chg_asnn11_1 LIKE asnn_file.asnn11              #FUN-A90026
DEFINE l_chg_asnn12_1 LIKE asnn_file.asnn12              #FUN-A90026 
DEFINE l_chg_asnn11   LIKE asnn_file.asnn11              #FUN-A90026
DEFINE l_chg_asnn12   LIKE asnn_file.asnn12              #FUN-A90026
DEFINE l_chg_asnn11_a LIKE asnn_file.asnn11              #FUN-A90026
DEFINE l_chg_asnn12_a LIKE asnn_file.asnn12              #FUN-A90026 
DEFINE l_num         LIKE type_file.num5              #FUN-AA0005
DEFINE l_tmp         LIKE type_file.chr1              #FUN-B50001  Add
DEFINE x_aaa03       LIKE aaa_file.aaa03              #FUN-B90034 族群最上層公司幣別

    #FUN-B90034--add--str--
    SELECT asg06 INTO x_aaa03 FROM asg_file,asa_file
     WHERE asg01 = asa02 AND asa01 = tm.asa01
       AND asa04 = 'Y' 
    #FUN-B90034--add--end

    #-->step 1 刪除資料
    CALL p001_del()
    IF g_success = 'N' THEN RETURN END IF

    #-->step 2 資料匯入,更換科目
    #-->aah_file->asr_file;aed_file->ass_file;ref.ash_file
    #-->asi_file->asr_file;asi_file->ass_file                #FUN-580063
    LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR

    LET l_sql=" SELECT UNIQUE asa01,asa02,asa03,asa02,asa03",
              "   FROM asa_file ",
             #"  WHERE asa01='",tm.asa01,"' AND asa02='",tm.asa02, #FUN-B50001 Mark
             #"'   AND asa03='",tm.asa03,"' ",                     #FUN-B50001 Mark
              "  WHERE asa01 = '",tm.asa01,"'",                    #FUN-B50001 Add
              "    AND asa04 = 'Y' ",                              #FUN-B50001 Add
              "  UNION ",
              " SELECT UNIQUE asa01,asa02,asa03,asb04,asb05",
              "   FROM asb_file,asa_file ",
              "  WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
             #"    AND asa01='",tm.asa01,"' AND asa02='",tm.asa02,#FUN-B50001 Mark
             #"'   AND asa03='",tm.asa03,"' ",                    #FUN-B50001 Mark
              "    AND asa01 = '",tm.asa01,"'",                   #FUN-B50001 Add
              "    AND asb06 = 'Y' ",                             #FUN-B50001 Add
              "  ORDER BY 1,2,3,4 "
    PREPARE p001_asa_p FROM l_sql
    IF STATUS THEN 
      CALL cl_err('prepare:1',STATUS,1)             
       CALL cl_batch_bg_javamail('N')      #FUN-57014
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
    DECLARE p001_asa_c CURSOR FOR p001_asa_p
    LET g_no = 1
    CALL s_showmsg_init()           #NO.FUN-710023 
    FOREACH p001_asa_c INTO g_dept[g_no].*
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF 
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg(' ',' ','for_asa_c:',STATUS,1) #NO.FUN-710023
          LET g_success = 'N'
          RETURN                                     
       END IF
       LET g_no=g_no+1
    END FOREACH
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
    LET g_no=g_no-1

    LET l_sql_asf=
        #"SELECT '2',SUM(asf13)",          #FUN-990020 mod
        "SELECT '2',SUM(asf16),SUM(asf13)",    #FUN-A70086
        "  FROM asf_file,asg_file",
        " WHERE asf01=? AND asf02=? ",
        "   AND asf02=asg01 ",
        "   AND asf04=asg06 ",
        #"   AND asf07=? ",               #FUN-A90026 mark             
        "   AND asf03=? ",
        "   AND asf06<=? "  #異動日期
    PREPARE p001_asf_p FROM l_sql_asf
    
    LET l_sql_asf=
        "SELECT COUNT(*) ",       
        "  FROM asf_file,asg_file",
        " WHERE asf01=? AND asf02=? ",
        "   AND asf02=asg01 ",
        "   AND asf04=asg06 ",
        #"   AND asf07=? ",    #FUN-A90026 mark                         
        "   AND asf03=? ",
        "   AND asf06<=? "
    PREPARE p001_asf_p2 FROM l_sql_asf

    FOR i =1 TO g_no   #insert asr_file
        IF g_success='N' THEN                                                    
          LET g_totsuccess='N'                                                   
          LET g_success='Y'                                                      
        END IF
        SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01=g_dept[i].asb04   #TQC-660043
        SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_asg03   #TQC-660043
        IF STATUS THEN LET g_dbs_new = NULL END IF
        IF NOT cl_null(g_dbs_new) THEN 
           LET g_dbs_new=g_dbs_new CLIPPED,'.' 
        END IF
        LET g_dbs_gl = g_dbs_new CLIPPED

        #母公司的記帳幣別
        SELECT asg06 INTO l_asg06 FROM asg_file WHERE asg01=g_dept[i].asa02

        LET l_rate = 1 
        LET l_cut  = 0
        LET l_cut1 = 0   #FUN-5A0020

        DISPLAY 'cur db-->',g_dept[i].asb04

        #-->產生asr_file(合併前會計科目餘額檔)
        #-->check 是否有下層資料,無下層(asm_file,asn_file,asnn_file),有下層(atc_file,atcc_file)
        #抓取歷史匯率檔時機：
        #判斷現在計算的這個公司有沒有下層公司，
        #若有，則抓合併後餘額檔﹔若沒有，則抓歷史匯率檔
        #Mark by sam 20101204
        # SELECT COUNT(*) INTO l_n FROM asa_file 
        #  WHERE asa01=g_dept[i].asa01 
        #    AND asa02=g_dept[i].asb04 
        #    AND asa03=g_dept[i].asb05 
        # IF l_n=0 OR 
        # (g_dept[i].asa02=g_dept[i].asb04 AND g_dept[i].asa03=g_dept[i].asb05)   #FUN-A90026 mod
        # THEN #無下層資料
        #End Mark
            SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept[i].asb04
 
                #--------FUN-A90026 aah->asm ---start---
                #取asm_file SUM(借),SUM(貸)之科餘(BETWEEN tm.bm and tm.em)寫入合併科餘
                #寫入期別= tm.em
                LET l_sql=
                " SELECT asm04,asm05,SUM(asm07),SUM(asm08),SUM(asm09),SUM(asm10),asm11",
                "        ,SUM(asm12),SUM(asm13),asm14,SUM(asm15),SUM(asm16),asm17,asm18 ",     #FUN-B50001 Add
                "   FROM asm_file ",
                #"  WHERE asm00 = '",g_aaz641,"'",        #合併帳別    #FUN-B50001
                "  WHERE asm00 = '",g_asz01,"'",        #合併帳別 
                "    AND asm01 = '",g_dept[i].asa01,"'", #族群
                "    AND asm02 = '",g_dept[i].asb04,"'", #公司
                "    AND asm20 = ",tm.yy," AND asm21 = ",tm.em,        #No.FUN-C80020
                "    AND asm05 = '",tm.yy,"'"
#FUN-B60159--mod--STR--
#               ,"    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
#               #"  GROUP BY asm04,asm05,asm11 ",   #FUN-B50001
#               "  GROUP BY asm04,asm05,asm11,asm14,asm17,asm18 ",
#               "  ORDER BY asm04 "
#               #--------FUN-A90026 end-----------------
                IF l_asg04 = 'Y' THEN
                   LET l_sql = l_sql CLIPPED,
                               "    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                               "  GROUP BY asm04,asm05,asm11,asm14,asm17,asm18 ",
                               "  ORDER BY asm04 "
                ELSE
                   LET l_sql = l_sql CLIPPED,
                               "    AND asm06 ='",tm.em,"'",
                               "  GROUP BY asm04,asm05,asm11,asm14,asm17,asm18 ",
                               "  ORDER BY asm04 "
                END IF 
#FUN-B60159--mod--end
       

                PREPARE p001_aah_p5 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].asb05
                    CALL s_errmsg('aah02,aah00',g_showmsg,'prepare:2',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                DECLARE p001_aah_c5 CURSOR FOR p001_aah_p5
                #FOREACH p001_aah_c5 INTO l_aah01                  #FUN-A90026 mark
                FOREACH p001_aah_c5 INTO g_asm.asm04,g_asm.asm05,  #FUN-A90026 add
                                         g_asm.asm07,g_asm.asm08,g_asm.asm09,  #FUN-A90026 add
                                         g_asm.asm10,g_asm.asm11              #FUN-A90026 add
                                         ,g_asm.asm12,g_asm.asm13,g_asm.asm14,  #FUN-B50001 Add
                                         g_asm.asm15,g_asm.asm16,g_asm.asm17,  #FUN-B50001 Add
                                         g_asm.asm18
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_aah_c5',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                       
                    #--FUN-A90026 start---
                    LET l_aah.aah01 = g_asm.asm04
                    LET l_aah.aah02 = g_asm.asm05
                    LET l_aah.aah03 = tm.em
                    LET l_aah.aah04 = g_asm.asm07
                    LET l_aah.aah05 = g_asm.asm08
                    LET l_aah.aah06 = g_asm.asm09
                    LET l_aah.aah07 = g_asm.asm10
                    #--FUN-A90026 end-----

                    DISPLAY l_aah.aah03,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05
#FUN-B70064 --Beatk
                    SELECT aag04 INTO l_aag04
                      FROM aag_file
                     WHERE aag00 = g_aaz641
                       AND aag01 = l_aah.aah01
#FUN-B70064 --End
#FUN-B90019--mark--str--
##                   LET l_ash.ash06 = l_aah.aah01   #FUN-A90026 mark
#                   LET l_ash.ash11 = '1'
#                   LET l_ash.ash12 = '1'
#                   #抓取下層公司的科目的合併財報科目編號(ash06),
#                   #再衡量匯率類別(ash11),換算匯率類別(ash12),
#                   #以判斷後續轉換幣別時,要用那種匯率計算

#                   #---FUN-A90026 start----
#                   LET l_sql = 
#                   #" SELECT ash11,ash12 FROM ash_file ",
#                   " SELECT ash04,ash11,ash12 FROM ash_file ",  #TQC-AA0098
#                   "  WHERE ash01 = '",g_dept[i].asb04,"'",
#                   "    AND ash06 = '",l_aah.aah01,"'",
#                   "    AND ash00 = '",g_dept[i].asb05,"'", 
#                   "    AND ash13 = '",tm.asa01,"'"   
#                   PREPARE p001_ash_p1 FROM l_sql
#                   DECLARE p001_ash_c1 SCROLL CURSOR FOR p001_ash_p1
#                   OPEN p001_ash_c1 
#                   FETCH FIRST p001_ash_c1 INTO l_ash.*
#                   CLOSE p001_ash_c1
#                   #---FUN-A90026 end--------

#                   IF STATUS  THEN                      #FUN-580063
#                      LET g_showmsg=g_dept[i].asb04,"/",l_aah.aah01                                                #NO.FUN-710023 
#                      CALL s_errmsg('ash01,ash04',g_showmsg,l_aah.aah01,'aap-021',1)                               #NO.FUN-710023     
#                      LET g_success = 'N' 
#                       CONTINUE FOREACH                       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                   END IF
##                   LET l_ash06 = l_ash.ash06            #FUN-580063   #FUN-A90026 mark

#                   #DISPLAY l_aah.aah03,'->',l_ash06,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05
#                   DISPLAY l_aah.aah03,'->',l_aah.aah01,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05  　　　　 #FUN-A90026 mod

#                   #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
#                   #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
#                   #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
#                   #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
#                   SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asb04
#                   IF SQLCA.sqlcode THEN
#                      CALL s_errmsg('asg01',g_dept[i].asb04,' ',SQLCA.sqlcode,1)   #NO.FUN-710023
#                      LET g_success = 'N'
#                      CONTINUE  FOREACH                            #NO.FUN-710023    #TQC-770178 mod EXIT->CONTINUE
#                   END IF

#                   #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
#                   LET l_rate  = 1
#                   LET l_rate1 = 1
#                   #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
#                   #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                   #一一換算後再加總起來
#                   
#                   #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
#                   #IF l_ash.ash11='2' AND l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN   #FUN-A60038 mark
#                   LET l_chg_aah04_1=0
#                   LET l_chg_aah05_1=0
#                   LET l_chg_aah04=0
#                   LET l_chg_aah05=0
#                   LET l_chg_aah04_a=0
#                   LET l_chg_aah05_a=0

#                   #---FUN-A60038 start---
#                   LET l_chg_dr = 0 
#                   LET l_chg_cr = 0
#                   LET l_fun_dr = 0 
#                   LET l_fun_cr = 0 
#                   LET l_acc_dr = 0 
#                   LET l_acc_cr = 0
#                   #---FUN-A60038 end-----
#                   LET l_dr = 0  #MOD-A80102
#                   LET l_cr = 0  #MOD-A80102

#                   #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
#                   #--現時匯率---
#                   IF l_ash.ash11='1' THEN 
#                       CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
#                                         l_ash.ash11,l_asg.asg06,
#                                        #l_asg.asg07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark
#                                         l_asg.asg07,l_aah.aah02,l_aah.aah03,g_asa05)   #FUN-B70064 add
#                       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                   END IF

#                   #--歷史匯率---
#                   IF l_ash.ash11='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                       #----如果agli011抓不到資料，則依科目餘額計算---- 
#                       DECLARE p001_cnt_cs2 CURSOR FOR p001_asf_p2
#                       OPEN p001_cnt_cs2
#                       USING g_dept[i].asa01,g_dept[i].asb04,
#                            #l_aah.aah01,l_ash.ash06,g_date_e  #FUN-970046
#                            l_aah.aah01,g_date_e               #FUN-A90026 mod
#                       FETCH p001_cnt_cs2 INTO l_asf_count
#                       CLOSE p001_cnt_cs2
#                       IF l_asf_count > 0 THEN   
#                           #CALL p001_asf(i,l_aah.aah01,l_ash.ash06,g_date_e)   #FUN-A60038 add
#                           #CALL p001_asf(i,l_aah.aah01,g_date_e)    #FUN-A90026 mod
#                           CALL p001_asf(i,l_ash.ash04,l_aah.aah01,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
#                           #--FUN-A70086 start--
#                           #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                           RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                           #LET l_fun_dr = l_chg_dr
#                           #LET l_fun_cr = l_chg_cr
#                           #LET l_acc_dr = l_chg_dr
#                           #LET l_acc_cr = l_chg_cr
#                           #--FUN-A70086 end----
#                       ELSE
#                           #--取不到agli011時一樣用匯率換算---
#                           CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
#                                         l_ash.ash11,l_asg.asg06,
#                                        #l_asg.asg07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 MARK
#                                         l_asg.asg07,l_aah.aah02,l_aah.aah03,g_asa05)   #FUN-B70064 ADD
#                           RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                       END IF
#                   ELSE
#                       CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
#                                         l_ash.ash11,l_asg.asg06,
#                                        #l_asg.asg07,l_aah.aah02,l_aah.aah03)            #FUN-B70064 MARK
#                                         l_asg.asg07,l_aah.aah02,l_aah.aah03,g_asa05)    #FUN-B70064 mod
#                       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                   END IF
#      
#                   #--平均匯率---
#                   IF l_ash.ash11='3' THEN
##FUN-A90006 start---
#                       #--FUN-A90026 start--
#                       IF g_asa05 = '1' THEN      
#                           CALL p001_fun_avg(l_ash.ash11,l_aah.aah01,l_asg.asg06,l_asg.asg07,l_aah.aah02,l_aah.aah03,i)   
#                           RETURNING l_fun_dr,l_fun_cr 
#                           #CALL p001_fun_avg('1',g_dbs_gl,l_ash.ash06,   #FUN-A90026 mark
#                           #                  g_dept[i].asb05,l_aag04,    #FUN-A90026 mark
#                           #                  l_asg.asg06,l_asg.asg07,i,  #FUN-A90026 mark
#                           #                  l_aah.aah04,l_aah.aah05)    #FUN-A90026 mark
#                           #RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr
#                       ELSE                
#                           CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
#                                             l_ash.ash11,l_asg.asg06,
#                                            #l_asg.asg07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark
#                                             l_asg.asg07,l_aah.aah02,l_aah.aah03,g_asa05)   #FUN-B70064 add
#                           RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                       END IF
#                       #--FUN-A90026 end----
##FUN-A90006 end-----
#                   END IF
#                   #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                   #--現時匯率---
#                   IF l_ash.ash12='1' THEN 
#                       CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                         l_ash.ash12,l_asg.asg07,
#                                        #x_aaa03,l_aah.aah02,l_aah.aah03)                  #FUN-B70064 MARK
#                                         x_aaa03,l_aah.aah02,l_aah.aah03,g_asa05)          #FUN-B70064 ADD
#                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                   END IF

#                   #--歷史匯率---
#                   IF l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                       #----如果agli011抓不到資料，則依科目餘額計算---- 
#                       DECLARE p001_cnt_cs24 CURSOR FOR p001_asf_p2
#                       OPEN p001_cnt_cs24
#                       USING g_dept[i].asa01,g_dept[i].asb04,
#                            #l_aah.aah01,l_ash.ash06,g_date_e  #FUN-970046
#                            l_aah.aah01,g_date_e               #FUN-A90026 mod
#                       FETCH p001_cnt_cs24 INTO l_asf_count
#                       CLOSE p001_cnt_cs24
#                       IF l_asf_count > 0 THEN   
#                           #CALL p001_asf(i,l_aed.aed01,l_ash.ash06,g_date_e) 
#                           #CALL p001_asf(i,l_aah.aah01,g_date_e)     #FUN-A90026 mod
#                           CALL p001_asf(i,l_ash.ash04,l_aah.aah01,g_date_e)     #FUN-A90026 mod  #TQC-AA0098
#                           #--FUN-A70086 start--
#                           #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                           RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                           #LET l_fun_dr = l_chg_dr
#                           #LET l_fun_cr = l_chg_cr
#                           #LET l_acc_dr = l_chg_dr
#                           #LET l_acc_cr = l_chg_cr
#                           #--FUN-A70086 end----
#                       ELSE
#                           #--取不到agli011時一樣用匯率換算---
#                           CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                             l_ash.ash12,l_asg.asg07,
#                                            #x_aaa03,l_aah.aah02,l_aah.aah03)           #FUN-B70064 MARK
#                                             x_aaa03,l_aah.aah02,l_aah.aah03,g_asa05)   #FUN-B70064 ADD
#                           RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                       END IF
#                   ELSE
#                       CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                         l_ash.ash12,l_asg.asg07,
#                                        #x_aaa03,l_aah.aah02,l_aah.aah03)              #FUN-B70064 MARK
#                                         x_aaa03,l_aah.aah02,l_aah.aah03,g_asa05)      #FUN-B70064 ADD
#                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                   END IF
#      
#                   #--平均匯率---
#                   IF l_ash.ash12='3' THEN
##--FUN-A90006 start-
#                       #---FUN-A90026 start
#                       IF g_asa05 = '1' THEN 
#                           CALL p001_avg(l_ash.ash11,l_ash.ash12,l_aah.aah01,
#                                         l_asg.asg06,l_asg.asg07,
#                                         l_aah.aah02,l_aah.aah03,i)
#                       #FUN-A90026 end--
#                           #CALL p001_avg('2',g_dbs_gl,l_ash.ash06,   #FUN-A90026 mark
#                           #               g_dept[i].asb05,l_aag04,   #FUN-A90026 mark
#                           #               l_asg.asg06,l_asg.asg07,i, #FUN-A90026 mark
#                           #               l_dr,l_cr)                 #FUN-A90026 mark
#                           RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                       #--FUN-A90026 start---
#                       ELSE
#                           CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                             l_ash.ash12,l_asg.asg07,
#                                            #x_aaa03,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark 
#                                             x_aaa03,l_aah.aah02,l_aah.aah03,g_asa05)   #FUN-B70064 add
#                           RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                       END IF
#                       #--FUN-A90026 end-------
##FUN-A90006 end-----
#                   END IF
#                   #-------FUN-A60038 end-----------------------------------


#                   #---FUN-A60038 start---
#                   LET l_chg_aah04  =l_chg_aah04   + l_fun_dr
#                   LET l_chg_aah05  =l_chg_aah05   + l_fun_cr
#                   LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
#                   LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額
#                   #---FUN-A60038 end------

#                   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
#                   IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
#                   SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
#                   IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
#                                                                                                                                                     
#                   LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
#                   LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
#                   LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
#                   LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
#                                                                                                            
#                   IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
#                   IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF                                                                                   
#FUN-B90019--mark--end
 
                   #FUN-B90019--mod--str--aglp000已經處理了匯率,所以p001匯率只需拿金額倒推就可
                    LET l_asr18 = (g_asm.asm15-g_asm.asm16)/(g_asm.asm12-g_asm.asm13)
                    LET l_asr19 = (g_asm.asm07-g_asm.asm08)/(g_asm.asm15-g_asm.asm16)
                   ##--FUN-A90026 start--
                   #IF g_asa05 = '1' THEN
                   #    IF l_ash.ash11 = '3' THEN   #TQC-AA0098
                   #        IF l_asg.asg06 != l_asg.asg07 THEN
                   #            LET l_asr18 = (l_chg_aah04-l_chg_aah05)/(l_aah.aah04-l_aah.aah05)
                   #        ELSE
                   #            LET l_asr18 = l_rate
                   #        END IF
                   #    ELSE                         #TQC-AA0098
                   #        LET l_asr18 = l_rate     #TQC-AA0098
                   #    END IF                       #TQC-AA0098

                   #    IF l_ash.ash12 = '3' THEN    #TQC-AA0098
                   #        IF l_asg.asg07 != x_aaa03 THEN
                   #            LET l_asr19 = (l_chg_aah04_1-l_chg_aah05_1)/(l_chg_aah04-l_chg_aah05)
                   #        ELSE
                   #            LET l_asr19 = l_rate1
                   #        END IF
                   #    ELSE                         #TQC-AA0098
                   #        LET l_asr19 = l_rate1    #TQC-AA0098
                   #    END IF                       #TQC-AA0098
                   #ELSE
                   ##---FUN-A90026 end-----
                   #    LET l_asr18 = l_rate    #FUN-960003 add
                   #    LET l_asr19 = l_rate1   #FUN-960003 add
                   #END IF   #FUN-A90026 add
                   #FUN-B90019--mod--end

                    #FUN-B50001--add--str--
                    #IF NOT cl_null(g_asm.asm12) AND g_asm.asm12<>0 THEN   #下層公司原幣別借方金額  #FUN-B90019
                       LET l_aah.aah04 = g_asm.asm12
                    #END IF    #FUN-B90019
                    #IF NOT cl_null(g_asm.asm13) AND g_asm.asm13<>0 THEN   #下層公司原幣別貸方金額 #FUN-B90019
                       LET l_aah.aah05 = g_asm.asm13
                    #END IF    #FUN-B90019
                    IF cl_null(g_asm.asm14) THEN       #原始公司幣別
                       LET g_asm.asm14 = l_asg.asg06
                    END IF 
                    #IF NOT cl_null(g_asm.asm15) AND g_asm.asm15<>0 THEN   #功能幣借方金額   #FUN-B90019
                       LET l_chg_aah04 = g_asm.asm15
                    #END IF    #FUN-B90019
                    #IF NOT cl_null(g_asm.asm16) AND g_asm.asm16<>0 THEN   #功能幣貸方金額    #FUN-B90019
                       LET l_chg_aah05 = g_asm.asm16
                    #END IF    #FUN-B90019
                    IF cl_null(g_asm.asm17) THEN       #功能幣
                       LET g_asm.asm17 = l_asg.asg07
                    END IF 
                    IF cl_null(g_asm.asm18) THEN       #原始公司編號
                       LET g_asm.asm18 = g_dept[i].asb04
                    END IF 
                    IF cl_null(l_asr18) THEN
                       LET l_asr18 = 1
                    END IF 
                    IF cl_null(l_asr19) THEN 
                       LET l_asr19 = 1
                    END IF 
                    LET l_chg_aah04_1 = g_asm.asm07   #FUN-B90001
                    LET l_chg_aah05_1 = g_asm.asm08   #FUN-B90001
                    #FUN-B50001--add--end
                    INSERT INTO asr_file                                                                                                                        
                      (asr00,asr01,asr02,asr03,asr04,asr041,   #No:MOD-470041                                                                                 
                       asr05,asr06,asr07,asr08,asr09,asr10,                                                                                                   
                       asr11,asr12,asr13,asr14,asr15,asr16,    #FUN-580063                                                                                    
                       asr17,asrlegal,                                  #FUN-750078 add                                                                                
                       asr20,asr21,asr22,   #FUN-B50001 Add
                       asr18,asr19)                            #FUN-970046                                                                                    
                     VALUES                                                                                                                                     
                       (g_asz01,g_dept[i].asa01,g_dept[i].asa02,  #FUN-5A0020 #FUN-920067                                                                      
                       g_dept[i].asa03,g_dept[i].asb04,g_dept[i].asb05,                                                                                        
                       l_aah.aah01,l_aah.aah02,l_aah.aah03,l_chg_aah04_1,   #FUN-A90026 mod
                       #l_chg_aah05_1,l_aah.aah06,l_aah.aah07,l_asg06,      #FUN-B90034                                                                                       
                       l_chg_aah05_1,l_aah.aah06,l_aah.aah07,x_aaa03,   #FUN-B90034                                                                                          
                       l_aah.aah04,l_aah.aah05,l_chg_aah04,l_chg_aah05,                                                                                        
                       tm.ver,g_azw02,                                                                                                            
                       g_asm.asm18,g_asm.asm17,g_asm.asm14,
                       l_asr18,l_asr19)      
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                        UPDATE asr_file SET asr08=asr08+l_chg_aah04_1, #MOD-6A0066                                                                             
                                            asr09=asr09+l_chg_aah05_1, #MOD-6A0066                                                                             
                                            asr10=asr10+l_aah.aah06,   #MOD-6A0066                                                                             
                                            asr11=asr11+l_aah.aah07,   #MOD-6A0066                                                                             
                                            asr13=asr13+l_aah.aah04,   #FUN-770069 mod                                                                         
                                            asr14=asr14+l_aah.aah05,   #FUN-770069 mod                                                                         
                                            asr15=asr15+l_chg_aah04,   #MOD-6A0066                                                                             
                                            asr16=asr16+l_chg_aah05,    #MOD-6A0066                                                                            
                                            asr18=l_asr18,             #FUN-970046 ADD                                                                         
                                            asr19=l_asr19              #FUN-970046 ADD                                                                         
                         WHERE asr00 = g_asz01    #FUN-970046 add                                                                                                 
                           AND asr01 = g_dept[i].asa01                                                                                                         
                          # AND asr02 = tm.asa02  #FUN-A30064                                                                                                         
                          #No.TQC-C90057  --Begin
                          #AND asr02 = g_dept[i].asa02                                                                                                         
                          # AND asr03 = g_dept[i].asa03                                                                                                         
                           AND asr02 = tm.asa02
                           AND asr03 = tm.asa03
                          #No.TQC-C90057  --End  
                           AND asr04 = g_dept[i].asb04                                                                                                         
                           AND asr041= g_dept[i].asb05                                                                                                         
                           AND asr05 = l_aah.aah01     #FUN-A90026 mod
                           AND asr06 = l_aah.aah02                                                                                                             
                           AND asr07 = l_aah.aah03                                                                                                             
                           #AND asr12 = l_asg06              #FUN-930117  #FUN-B90034                                                                                      
                           AND asr12 = x_aaa03             #FUN-B90034
                           AND asr17 = tm.ver              #MOD-930135                                                                                         
                           AND asr20 = g_asm.asm18     #FUN-B50001
                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                            CALL s_errmsg('asr01',g_dept[i].asa01,'upd_asr',SQLCA.sqlcode,1)                                                                       
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE                                                                  
                         END IF                                                                                                                                    
                    ELSE                                                                                                                                        
                        IF STATUS THEN                                                                                                                            
                            CALL s_errmsg('asr01',g_dept[i].asa01,'ins_asr',status,1)                                                                              
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE                                                                  
                        END IF                                                                                                                                    
                    END IF                                        
                END FOREACH

                
                #---FUN-AA0005 start---
                LET l_sql=
                    " SELECT asj03,asj04,asj081,ask03,ask06,aag04,SUM(ask07),COUNT(*) ",
                    " FROM asj_file,ask_file,aag_file",
                    " WHERE asj00 = ask00 ",
                    "   AND asj01 = ask01 ",
                    "   AND asj00 = '",g_asz01,"'",
                    "   AND asj03 = '",tm.yy,"'",
                    "   AND asj04 = '",tm.em,"'", 
                    "   AND asj08 = '1'",
                   #"   AND asj081 = 'U'",    #FUN-B50001
                    #"   AND (asj081 = 'U' OR asj081 = 'W' OR asj081 = 'V' )",    #sam 20101125   #FUN-B90057
                    "   AND (asj081 = 'U' OR asj081 = 'W' OR asj081 = 'V' OR asj081 = '9' )",    #FUN-B90057
                    "   AND asj05 = '",g_dept[i].asa01,"'",
                    "   AND asj06 = '",g_dept[i].asb04,"'",
                   # "   AND asj09 = 'N'",    #FUN-B50001 暂时mark
                    "   AND asjconf = 'Y'",
                    "   AND aag00 = ask00 ",
                    "   AND aag01 = ask03 ",
                    "   AND ask03<>'",g_asz.asz05,"'",   #FUN-B90057
                    " GROUP BY asj03,asj04,asj081,ask03,ask06,aag04 ",
                    " ORDER BY asj03,asj04,asj081,ask03,ask06 "
                PREPARE p001_ask_p1 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].asb05
                    CALL s_errmsg('ask00,ask01',g_showmsg,'pre:ask_p1',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                LET l_num = 0
                LET g_ask1.ask07 = 0
                DECLARE p001_ask_c1 CURSOR FOR p001_ask_p1
                FOREACH p001_ask_c1 INTO g_asr.asr06,g_asr.asr07,
                                         l_asj081,
                                         g_asr.asr05,g_ask1.ask06,
                                         l_aag04,
                                         g_ask1.ask07,l_num
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_ask_c1',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                   #Add by sam 20101125
                    IF l_asj081 = 'W' AND l_aag04 = '2' THEN
                       CONTINUE FOREACH 
                    END IF
                   #End Add
                    LET g_asr.asr00 = g_asz01
                    LET g_asr.asr01 = g_dept[i].asa01
                    LET g_asr.asr02 = g_dept[i].asa02 
                    LET g_asr.asr03 = g_dept[i].asa03
                    LET g_asr.asr04 = g_dept[i].asb04
                    LET g_asr.asr041 = g_dept[i].asb05

#luttb 110926--mod--str--
#                    IF g_ask1.ask06 = '1' THEN #借
#                        LET g_asr.asr13 = g_ask1.ask07
#                        LET g_asr.asr14 = 0
#                        LET g_asr.asr10 = l_num
#                    ELSE                       #貸
#                        LET g_asr.asr13 = 0
#                        LET g_asr.asr14 = g_ask1.ask07
#                        LET g_asr.asr11 = l_num
#                    END IF
                    IF g_ask1.ask06 = '1' THEN #借
                        LET g_asr.asr08 = g_ask1.ask07
                        LET g_asr.asr09 = 0
                        LET g_asr.asr10 = l_num
                    ELSE                       #貸
                        LET g_asr.asr08 = 0
                        LET g_asr.asr09 = g_ask1.ask07
                        LET g_asr.asr11 = l_num
                    END IF
#luttb 110926--mod--end
                    #DISPLAY g_asr.asr07,' ',g_asr.asr05,' ',g_asr.asr13,' ',g_asr.asr14   #luttb 110926
                    DISPLAY g_asr.asr07,' ',g_asr.asr05,' ',g_asr.asr08,' ',g_asr.asr09
                 #Mark by sam 20101125     
                   #IF g_asr.asr13- g_asr.asr14 = 0 THEN                                  
                   #   IF l_aag04 = '2' THEN                                               
                   #      CALL p001_chkaah(g_asr.asr05,g_asr.asr07,g_asr.asr13,g_dept[i].asb05)             
                   #      RETURNING g_asr.asr13
                   #   END IF                                                               
                   #END IF                                                                                                                                     
                 #End Mark 
#luttb 110926--mark--str---------
#                    LET l_ash.ash11 = '1'
#                    LET l_ash.ash12 = '1'
                   
#                    LET l_sql = 
#                    #" SELECT ash04,ash11,ash12 FROM ash_file ",  #TQC-AA0098
#                    " SELECT ash11,ash12 FROM ash_file ",
#                    "  WHERE ash01 = '",g_dept[i].asb04,"'",
#                    "    AND ash06 = '",g_asr.asr05,"'",
#                    "    AND ash00 = '",g_dept[i].asb05,"'", 
#                    "    AND ash13 = '",tm.asa01,"'"   
#                    PREPARE p001_ash_p5 FROM l_sql
#                    DECLARE p001_ash_c5 SCROLL CURSOR FOR p001_ash_p5
#                    OPEN p001_ash_c5 
#                    FETCH FIRST p001_ash_c5 INTO l_ash.*
#                    CLOSE p001_ash_c5

#                    IF STATUS THEN           
#                       LET g_showmsg=g_dept[i].asb04,"/",g_asr.asr05
#                       CALL s_errmsg('ash01,ash04',g_showmsg,g_asr.asr05,'aap-021',1)                               #NO.FUN-710023     
#                       LET g_success = 'N' 
#                       CONTINUE FOREACH        
#                    END IF

#                    DISPLAY g_asr.asr07,'->',g_asr.asr05,' ',g_asr.asr05,' ',g_asr.asr08,' ',g_asr.asr09

#                    #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
#                    #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
#                    #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
#                    #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
#                    SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asb04
#                    IF SQLCA.sqlcode THEN
#                       CALL s_errmsg('asg01',g_dept[i].asb04,' ',SQLCA.sqlcode,1)   #NO.FUN-710023
#                       LET g_success = 'N'
#                       CONTINUE  FOREACH           
#                    END IF

#                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
#                    LET l_rate  = 1
#                    LET l_rate1 = 1
#                    #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
#                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                    #一一換算後再加總起來
#                    
#                    #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
#                    LET l_chg_aah04_1=0
#                    LET l_chg_aah05_1=0
#                    LET l_chg_aah04=0
#                    LET l_chg_aah05=0
#                    LET l_chg_aah04_a=0
#                    LET l_chg_aah05_a=0
#
#                    LET l_chg_dr = 0 
#                    LET l_chg_cr = 0
#                    LET l_fun_dr = 0 
#                    LET l_fun_cr = 0 
#                    LET l_acc_dr = 0 
#                    LET l_acc_cr = 0
#                    LET l_dr = 0  
#                    LET l_cr = 0 

#                    #依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
#                    #--現時匯率---
#                    IF l_ash.ash11='1' THEN 
#                        CALL p001_fun_amt(l_aag04,g_asr.asr13,g_asr.asr14,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,tm.yy,tm.em)            #FUN-B70064 MARK
#                                          l_asg.asg07,tm.yy,tm.em,g_asa05)    #FUN-B70064 ADD
#                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                    END IF

#                    #--歷史匯率---
#                    IF l_ash.ash11='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                        #----如果agli011抓不到資料，則依科目餘額計算---- 
#                        DECLARE p001_cnt_cs51 CURSOR FOR p001_asf_p2
#                        OPEN p001_cnt_cs51
#                        USING g_dept[i].asa01,g_dept[i].asb04,
#                              g_asr.asr05,g_date_e    
#                        FETCH p001_cnt_cs51 INTO l_asf_count
#                        CLOSE p001_cnt_cs51
#                        IF l_asf_count > 0 THEN   
#                            #CALL p001_asf(i,g_asr.asr05,g_date_e)  
#                            CALL p001_asf(i,l_ash.ash04,g_asr.asr05,g_date_e)   #TQC-AA0098
#                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                        ELSE
#                            #--取不到agli011時一樣用匯率換算---
#                            CALL p001_fun_amt(l_aag04,g_asr.asr13,g_asr.asr14,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,tm.yy,tm.em)            #FUN-B70064 MARK
#                                          l_asg.asg07,tm.yy,tm.em,g_asa05)    #FUN-B70064 ADD
#                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                        END IF
#                    ELSE
#                        CALL p001_fun_amt(l_aag04,g_asr.asr13,g_asr.asr14,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,tm.yy,tm.em)            #FUN-B70064 MARK
#                                          l_asg.asg07,tm.yy,tm.em,g_asa05)    #FUN-B70064 ADD
#                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                    END IF
       
#                    #--平均匯率---
#                    IF l_ash.ash11='3' THEN
#                        CALL p001_fun_amt(l_aag04,g_asr.asr13,g_asr.asr14,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,tm.yy,tm.em)            #FUN-B70064 MARK
#                                          l_asg.asg07,tm.yy,tm.em,g_asa05)    #FUN-B70064 ADD
#                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                    END IF
#
#                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                    #--現時匯率---
#                    IF l_ash.ash12='1' THEN 
#                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                          l_ash.ash12,l_asg.asg07,
#                                         #x_aaa03,tm.yy,tm.em)            #FUN-B70064 MARK
#                                          x_aaa03,tm.yy,tm.em,g_asa05)    #FUN-B70064 ADD
#                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                    END IF

#                    #--歷史匯率---
#                    IF l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                        #----如果agli011抓不到資料，則依科目餘額計算---- 
#                        DECLARE p001_cnt_cs47 CURSOR FOR p001_asf_p2
#                        OPEN p001_cnt_cs47
#                        USING g_dept[i].asa01,g_dept[i].asb04,
#                              g_asr.asr05,g_date_e  
#                        FETCH p001_cnt_cs47 INTO l_asf_count
#                        CLOSE p001_cnt_cs47
#                        IF l_asf_count > 0 THEN   
#                            #CALL p001_asf(i,g_asr.asr05,g_date_e)  
#                            CALL p001_asf(i,l_ash.ash04,g_asr.asr05,g_date_e)   #TQC-AA0098
#                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                        ELSE
#                            #--取不到agli011時一樣用匯率換算---
#                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                              l_ash.ash12,l_asg.asg07,
#                                             #x_aaa03,tm.yy,tm.em)             #FUN-B70064 MARK
#                                              x_aaa03,tm.yy,tm.em,g_asa05)     #FUN-B70064 ADD
#                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                        END IF
#                    ELSE
#                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                          l_ash.ash12,l_asg.asg07,
#                                         #x_aaa03,tm.yy,tm.em)                 #FUN-B70064 MARK
#                                          x_aaa03,tm.yy,tm.em,g_asa05)         #FUN-B70064 ADD
#                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                    END IF
#       
#                    #--平均匯率---
#                    IF l_ash.ash12='3' THEN
#                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                          l_ash.ash12,l_asg.asg07,
#                                         #x_aaa03,tm.yy,tm.em)                #FUN-B70064 MARK
#                                          x_aaa03,tm.yy,tm.em,g_asa05)        #FUN-B70064 ADD 
#                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                    END IF
#
#                    LET l_chg_aah04  =l_chg_aah04   + l_fun_dr
#                    LET l_chg_aah05  =l_chg_aah05   + l_fun_cr
#                    LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
#                    LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

#                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
#                    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
#                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
#                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
#                    LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
#                    LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
#                    LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
#                    LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
#                                                                                                             
#                    IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
#                    IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF                                                                                   
# 
#                    IF g_asa05 = '1' THEN
#                        IF l_ash.ash11 = '3' THEN   #TQC-AA0098
#                            IF l_asg.asg06 != l_asg.asg07 THEN
#                                LET l_asr18 = (l_chg_aah04-l_chg_aah05)/(g_asr.asr13-g_asr.asr14)
#                            ELSE
#                                LET l_asr18 = l_rate
#                            END IF
#                        ELSE                        #TQC-AA0098
#                            LET l_asr18 = l_rate   #TQC-AA0098
#                        END IF                     #TQC-AA0098
#                        IF l_ash.ash12 = '3' THEN  #TQC-AA0098
#                            IF l_asg.asg07 != x_aaa03 THEN
#                                LET l_asr19 = (l_chg_aah04_1-l_chg_aah05_1)/(l_chg_aah04-l_chg_aah05)
#                            ELSE
#                                LET l_asr19 = l_rate1
#                            END IF
#                        ELSE                       #TQC-AA0098
#                            LET l_asr19 = l_rate1  #TQC-AA0098
#                        END IF                     #TQC-AA0098
#                    ELSE
#                        LET l_asr18 = l_rate
#                        LET l_asr19 = l_rate1
#                    END IF
#                    #FUN-B50001--add--str--
#                    IF cl_null(l_asr18) THEN
#                       LET l_asr18 = 0
#                    END IF 
#                    IF cl_null(l_asr19) THEN
#                       LET l_asr19 = 0
#                    END IF 
#                    #FUN-B50001--add--end
#luttb 110926--mark--end
                   #luttb 110926--add--str--
                    LET g_asr.asr13 = g_asr.asr08
                    LET g_asr.asr14 = g_asr.asr09
                    LET l_chg_aah04 = g_asr.asr08
                    LET l_chg_aah05 = g_asr.asr09
                    LET l_asr18 = 1
                    LET l_asr19 = 1
                   #luttb 110926--add--str--
                    INSERT INTO asr_file                                                                                                                        
                      (asr00,asr01,asr02,asr03,asr04,asr041,  
                       asr05,asr06,asr07,asr08,asr09,asr10,  
                       asr11,asr12,asr13,asr14,asr15,asr16, 
                       asr17,                              
                       asr20,asr21,asr22,      #FUN-B50001
                       asr18,asr19,asrlegal)                       
                     VALUES                                                                                                                                     
                       (g_asz01,g_dept[i].asa01,g_dept[i].asa02, 
                       g_dept[i].asa03,g_dept[i].asb04,g_dept[i].asb05,                                                                                        
                       #g_asr.asr05,tm.yy,tm.em,l_chg_aah04_1,  #luttb 110926 
                       g_asr.asr05,tm.yy,tm.em,g_asr.asr08,     #luttb 110926
                       #l_chg_aah05_1,g_asr.asr10,g_asr.asr11,l_asg06,  #FUN-B90034                                                                                        
                       #l_chg_aah05_1,g_asr.asr10,g_asr.asr11,x_aaa03,    #FUN-B90034   #luttb 110926
                       g_asr.asr09,g_asr.asr10,g_asr.asr11,x_aaa03,    #FUN-B90034
                       g_asr.asr13,g_asr.asr14,l_chg_aah04,l_chg_aah05,                                                                                        
                       tm.ver,                                                                                                            
                       g_dept[i].asa02,l_asg06,l_asg06,   #FUN-B50001
                       l_asr18,l_asr19,g_azw02)      
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                       #luttb 110926--mod--str--
                       # UPDATE asr_file SET asr08=asr08+l_chg_aah04_1, 
                       #                     asr09=asr09+l_chg_aah05_1,
                        UPDATE asr_file SET asr08=asr08+g_asr.asr08,
                                            asr09=asr09+g_asr.asr09,
                       #luttb 110926--mod--end
                                            asr10=asr10+g_asr.asr10,
                                            asr11=asr11+g_asr.asr11,
                                            asr13=asr13+g_asr.asr13,
                                            asr14=asr14+g_asr.asr14,
                                            asr15=asr15+l_chg_aah04,  
                                            asr16=asr16+l_chg_aah05,  
                                            asr18=l_asr18,            
                                            asr19=l_asr19            
                         WHERE asr00 = g_asz01   
                           AND asr01 = g_dept[i].asa01                                                                                                         
                           #AND asr02 = tm.asa02
                           #No.TQC-C90057  --Begin
                           #AND asr02 = g_dept[i].asa02
                           #AND asr03 = g_dept[i].asa03                                                                                                         
                           AND asr02 = tm.asa02
                           AND asr03 = tm.asa03
                           #No.TQC-C90057  --End  
                           AND asr04 = g_dept[i].asb04                                                                                                         
                           AND asr041= g_dept[i].asb05                                                                                                         
                           AND asr05 = g_asr.asr05
                           AND asr06 = g_asr.asr06
                           AND asr07 = g_asr.asr07
                           #AND asr12 = l_asg06    #FUN-B90034 
                           AND asr12 = x_aaa03     #FUN-B90034
                           AND asr17 = tm.ver    
                           AND asr20 = g_dept[i].asa02   #FUN-B50001
                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                            CALL s_errmsg('asr01',g_dept[i].asa01,'upd_asr',SQLCA.sqlcode,1)                                                                       
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH     
                         END IF                                                                                                                                    
                    ELSE                                                                                                                                        
                        IF STATUS THEN                                                                                                                            
                            CALL s_errmsg('asr01',g_dept[i].asa01,'ins_asr',status,1)                                                                              
                            LET g_success = 'N'                                                                                                                    
                            CONTINUE FOREACH      
                        END IF                                                                                                                                    
                    END IF                                        
                END FOREACH

                #--取調整分錄中有關係人的資料---#
                LET l_sql=
                    " SELECT asj03,asj04,asj081,ask03,ask05,ask06,aag04,SUM(ask07),COUNT(*) ",
                    " FROM asj_file,ask_file,aag_file",
                    " WHERE asj00 = ask00 ",
                    "   AND asj01 = ask01 ",
                    "   AND asj00 = '",g_asz01,"'",
                    "   AND asj03 = '",tm.yy,"'",
                    "   AND asj04 = '",tm.em,"'", 
                    "   AND asj08 = '1'",
                   #"   AND asj081= 'U'",   #FUN-B50001
                    #"   AND (asj081= 'U' OR asj081 ='W' OR asj081 ='V')",   #sam 20101125  #FUN-B90057
                    "   AND (asj081= 'U' OR asj081 ='W' OR asj081 ='V' OR asj081 = '9' )",   #FUN-B90057
                    "   AND asj05 = '",g_dept[i].asa01,"'",
                    "   AND asj06 = '",g_dept[i].asb04,"'",
                    #"   AND asj09 = 'N'",    #FUN-B50001 暂时mark
                    "   AND asjconf = 'Y'",
                    "   AND ask05 <> ' '",
                    "   AND aag00 = ask00 ",
                    "   AND aag01 = ask03 ",
                    "   AND ask03<>'",g_asz.asz05,"'",   #FUN-B90047
                    " GROUP BY asj03,asj04,asj081,ask03,ask05,ask06,aag04 ",
                    " ORDER BY asj03,asj04,asj081,ask03,ask06 "
                PREPARE p001_ask_p2 FROM l_sql
                IF STATUS THEN
                    LET g_showmsg=tm.yy,"/",g_dept[i].asb05
                    CALL s_errmsg('ask00,ask01',g_showmsg,'pre:ask_p2',STATUS,1)
                    LET g_success = 'N'
                    CONTINUE FOR
                END IF
                LET l_num = 0
                LET g_ask1.ask07 = 0
                DECLARE p001_ask_c2 CURSOR FOR p001_ask_p2
                FOREACH p001_ask_c2 INTO g_ass.ass08,g_ass.ass09,
                                         l_asj081,
                                         g_ass.ass05,g_ass.ass07,
                                         g_ask1.ask06,
                                         l_aag04,
                                         g_ask1.ask07,l_num
                    IF SQLCA.SQLCODE THEN
                       CALL s_errmsg(' ',' ','p001_ask_c2',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH
                    END IF
                   #Add by sam 20101125
                    IF l_asj081 = 'W' AND l_aag04 = '2' THEN
                       CONTINUE FOREACH 
                    END IF
                   #End Add

                    LET g_ass.ass00 = g_asz01
                    LET g_ass.ass01 = g_dept[i].asa01
                    LET g_ass.ass02 = g_dept[i].asa02 
                    LET g_ass.ass03 = g_dept[i].asa03
                    LET g_ass.ass04 = g_dept[i].asb04
                    LET g_ass.ass041 = g_dept[i].asb05

#luttb 110926--mod--str--
#                    IF g_ask1.ask06 = '1' THEN #借
#                        LET g_ass.ass18 = g_ask1.ask07
#                        LET g_ass.ass19 = 0
#                        LET g_ass.ass12 = l_num
#                    ELSE                       #貸
#                        LET g_ass.ass18 = 0
#                        LET g_ass.ass19 = g_ask1.ask07
#                        LET g_ass.ass13 = l_num
#                    END IF
                    IF g_ask1.ask06 = '1' THEN #借
                        LET g_ass.ass10 = g_ask1.ask07
                        LET g_ass.ass11 = 0
                        LET g_ass.ass12 = l_num
                    ELSE                       #貸
                        LET g_ass.ass10 = 0
                        LET g_ass.ass11 = g_ask1.ask07
                        LET g_ass.ass13 = l_num
                    END IF
#luttb 110926--mod--end

#luttb 110926--mark--str--
#                    LET l_sql = 
#                    #" SELECT ash11,ash12 FROM ash_file ",
#                    " SELECT ash04,ash11,ash12 FROM ash_file ",  #TQC-AA0098
#                    "  WHERE ash01 = '",g_dept[i].asb04,"'",
#                    "    AND ash06 = '",g_ass.ass05,"'",
#                    "    AND ash00 = '",g_dept[i].asb05,"'", 
#                    "    AND ash13 = '",tm.asa01,"'"   
#                    PREPARE p001_ash_p4 FROM l_sql
#                    DECLARE p001_ash_c4 SCROLL CURSOR FOR p001_ash_p4
#                    OPEN p001_ash_c4 
#                    FETCH FIRST p001_ash_c4 INTO l_ash.*
#                    CLOSE p001_ash_c4

#                     IF STATUS  THEN                   
#                        LET g_showmsg=g_dept[i].asb04,"/",g_ass.ass05
#                         CALL s_errmsg('ash01,ash04',g_showmsg,g_ass.ass05,'aap-021',1)                #NO.FUN-710023    
#                         LET g_success = 'N'
#                         CONTINUE FOREACH    
#                     END IF

#                     #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
#                     LET l_rate  = 1
#                     LET l_rate1 = 1
#                     #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
#                     #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                     #一一換算後再加總起來

#                     #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
#                     #IF l_ash.ash11='2' AND l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN   #FUN-770069  #FUN-970046 mOd  #FUN-A60038 MARK
#                     LET l_chg_aed05_1=0
#                     LET l_chg_aed06_1=0
#                     LET l_chg_aed05=0
#                     LET l_chg_aed06=0
#                     LET l_chg_aed05_a=0
#                     LET l_chg_aed06_a=0
#                     LET l_chg_dr = 0 
#                     LET l_chg_cr = 0
#                     LET l_fun_dr = 0 
#                     LET l_fun_cr = 0 
#                     LET l_acc_dr = 0 
#                     LET l_acc_cr = 0
#                     LET l_dr = 0   
#                     LET l_cr = 0  

#                     #依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
#                     #--現時匯率---
#                     IF l_ash.ash11='1' THEN 
#                         CALL p001_fun_amt(l_aag04,g_ass.ass18,g_ass.ass19,
#                                           l_ash.ash11,l_asg.asg06,
#                                          #l_asg.asg07,g_ass.ass08,g_ass.ass09)           #FUN-B70064 MARK
#                                           l_asg.asg07,g_ass.ass08,g_ass.ass09,g_asa05)   #FUN-B70064 ADD
#                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                     END IF

#                     #--歷史匯率---
#                     IF l_ash.ash11='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                         #----如果agli011抓不到資料，則依科目餘額計算---- 
#                         DECLARE p001_cnt_cs49 CURSOR FOR p001_asf_p2
#                         OPEN p001_cnt_cs49
#                         USING g_dept[i].asa01,g_dept[i].asb04,
#                               g_ass.ass05,g_date_e  
#                         FETCH p001_cnt_cs49 INTO l_asf_count
#                         CLOSE p001_cnt_cs49
#                         IF l_asf_count > 0 THEN   
#                             #CALL p001_asf(i,g_ass.ass05,g_date_e)   
#                             CALL p001_asf(i,l_ash.ash04,g_ass.ass05,g_date_e)    #TQC-AA0098
#                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                         ELSE
#                             #--取不到agli011時一樣用匯率換算---
#                             CALL p001_fun_amt(l_aag04,g_ass.ass18,g_ass.ass19,
#                                           l_ash.ash11,l_asg.asg06,
#                                          #l_asg.asg07,g_ass.ass08,g_ass.ass09)           #FUN-B70064 MARK
#                                           l_asg.asg07,g_ass.ass08,g_ass.ass09,g_asa05)   #FUN-B70064 ADD
#                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                         END IF
#                     ELSE
#                         CALL p001_fun_amt(l_aag04,g_ass.ass18,g_ass.ass19,
#                                       l_ash.ash11,l_asg.asg06,
#                                      #l_asg.asg07,g_ass.ass08,g_ass.ass09)              #FUN-B70064 MARK
#                                       l_asg.asg07,g_ass.ass08,g_ass.ass09,g_asa05)      #FUN-B70064 ADD
#                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                     END IF
#       
#                     #--平均匯率---
#                     IF l_ash.ash11='3' THEN
#                         CALL p001_fun_amt(l_aag04,g_ass.ass18,g_ass.ass19,
#                                           l_ash.ash11,l_asg.asg06,
#                                          #l_asg.asg07,g_ass.ass08,g_ass.ass09)             #FUN-B70064 MARK
#                                           l_asg.asg07,g_ass.ass08,g_ass.ass09,g_asa05)     #FUN-B70064 ADD 
#                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                     END IF
#
#                     #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                     #--現時匯率---
#                     IF l_ash.ash12='1' THEN 
#                         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                           l_ash.ash12,l_asg.asg07,
#                                          #x_aaa03,g_ass.ass08,g_ass.ass09)             #FUN-B70064 MARK
#                                           x_aaa03,g_ass.ass08,g_ass.ass09,g_asa05)     #FUN-B70064 ADD
#
#                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                     END IF
#
#                     #--歷史匯率---
#                     IF l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                         #----如果agli011抓不到資料，則依科目餘額計算---- 
#                         DECLARE p001_cnt_cs50 CURSOR FOR p001_asf_p2
#                         OPEN p001_cnt_cs50
#                         USING g_dept[i].asa01,g_dept[i].asb04,
#                               g_ass.ass05,g_date_e    
#                         FETCH p001_cnt_cs50 INTO l_asf_count
#                         CLOSE p001_cnt_cs50
#                         IF l_asf_count > 0 THEN   
#                             #CALL p001_asf(i,g_ass.ass05,g_date_e)  
#                             CALL p001_asf(i,l_ash.ash04,g_ass.ass05,g_date_e)    #TQC-AA0098
#                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                         ELSE
#                             #--取不到agli011時一樣用匯率換算---
#                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                               l_ash.ash12,l_asg.asg07,
#                                              #x_aaa03,g_ass.ass08,g_ass.ass09)               #FUN-B70064 MARK
#                                               x_aaa03,g_ass.ass08,g_ass.ass09,g_asa05)       #FUN-B70064 ADD
#                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                         END IF
#                     ELSE
#	                 CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#	             		      l_ash.ash12,l_asg.asg07,
#	             		     #x_aaa03,g_ass.ass08,g_ass.ass09)               #FUN-B70064 MARK
#	             		      x_aaa03,g_ass.ass08,g_ass.ass09,g_asa05)       #FUN-B70064 ADD
#                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                     END IF
#
#                     #--平均匯率---
#                     IF l_ash.ash12='3' THEN
#                         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                           l_ash.ash12,l_asg.asg07,
#                                          #x_aaa03,g_ass.ass08,g_ass.ass09)             #FUN-B70064 MARK
#                                           x_aaa03,g_ass.ass08,g_ass.ass09,g_asa05)     #FUN-B70064 ADD
#                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                     END IF       
#
#                     LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
#                     LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
#                     LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
#                     LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr
#
#                     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07    #FUN-A60060 mod
#                     IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                     SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                     IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                     
#                     #->幣別轉換及取位
#                     LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                     LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                     LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                     LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                     IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                     IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                     
#                     IF g_asa05 = '1' THEN
#                         IF l_ash.ash11 = '3' THEN     #TQC-AA0098
#                             IF l_asg.asg06 != l_asg.asg07 THEN
#                                 LET l_ass16 = (l_chg_aed05-l_chg_aed06)/(g_ass.ass18-g_ass.ass19)
#                             ELSE
#                                 LET l_ass16 = l_rate
#                             END IF
##                         #TQC-AA0098 start
#                         ELSE
#                             LET l_ass16 = l_rate
#                         END IF
#                         #TQC-AA0098 end
#
#                         IF l_ash.ash12 = '3' THEN   #TQC-AA0098
#                             IF l_asg.asg07 != x_aaa03 THEN
#                                 LET l_ass17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06)
#                             ELSE
#                                 LET l_ass17 = l_rate1
#                             END IF
#                         #--TQC-AA0098
#                         ELSE
#                             LET l_ass17 = l_rate1
#                         END IF
#                         #--TQC-AA0098
#                     ELSE
#                         LET l_ass16 = l_rate
#                         LET l_ass17 = l_rate1
#                     END IF
#luttb 110926--mark--end
                     INSERT INTO ass_file 
                      (ass00,ass01,ass02,ass03,ass04,ass041,   
                       ass05,ass06,ass07,ass08,ass09,ass10,
                       ass11,ass12,ass13,ass14,ass15, 
                       ass16,ass17,
                       ass22,ass23,ass24,     #FUN-B50001
                       ass18,ass19,ass20,ass21,asslegal)   
                      VALUES 
                       (g_asz01,g_dept[i].asa01,g_dept[i].asa02,  
                        g_dept[i].asa03,  
                        g_dept[i].asb04,g_dept[i].asb05,g_ass.ass05,'99',
                        g_ass.ass07,g_ass.ass08,g_ass.ass09,
                        #l_chg_aed05_1,l_chg_aed06_1,   #luttb 110926 
                        g_ass.ass10,g_ass.ass11,        #luttb 110926
                        #g_ass.ass12,g_ass.ass13,l_asg06,  #luttb 110927 
                        g_ass.ass12,g_ass.ass13,x_aaa03,   #luttb 110927
                        tm.ver,                                        
                        #l_ass16,l_ass17,   #luttb 110926
                        1,1,                #luttb 110926
                        g_dept[i].asa02,l_asg06,l_asg06,    #FUN-B50001
                        #g_ass.ass18,g_ass.ass19,l_chg_aed05,l_chg_aed06,g_azw02)  #luttb 110926 
                        g_ass.ass10,g_ass.ass11,g_ass.ass10,g_ass.ass11,g_azw02)  #luttb 110926
                     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                       #luttb 110926--mod--str--
                        #UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
                        #                       ass11=ass11+l_chg_aed06_1,
                        UPDATE ass_file    SET ass10=ass10+g_ass.ass10,
                                               ass11=ass11+g_ass.ass11,
                       #luttb 110926--mod--end
                                               ass12=ass12+g_ass.ass12,
                                               ass13=ass13+g_ass.ass13,
                                              #luttb 110926--mod--str--
                                              # ass16=l_ass16,            
                                              # ass17=l_ass17,
                                              # ass18=ass18+g_ass.ass18,
                                              # ass19=ass19+g_ass.ass19,                 #MOD-A70091
                                              # ass20=ass20+l_chg_aed05,                 #MOD-A70091
                                              # ass21=ass21+l_chg_aed06                  #MOD-A70091
                                               ass16=1,
                                               ass17=1,
                                               ass18=ass18+g_ass.ass10,
                                               ass19=ass19+g_ass.ass11,
                                               ass20=ass20+g_ass.ass10,
                                               ass21=ass21+g_ass.ass11
                                              #luttb 110926--mod--end
                            WHERE ass00 = g_asz01  
                              AND ass01 = g_dept[i].asa01
                             # AND ass02 = tm.asa02 
                              #No.TQC-C90057  --Begin
                              #AND ass02 = g_dept[i].asa02
                              #AND ass03 = g_dept[i].asa03
                              AND ass02 = tm.asa02
                              AND ass03 = tm.asa03
                              #No.TQC-C90057  --End  
                              AND ass04 = g_dept[i].asb04
                              AND ass041= g_dept[i].asb05
                              AND ass05 = g_ass.ass05
                              AND ass06 = '99'
                              AND ass07 = g_ass.ass07
                              AND ass08 = g_ass.ass08
                              AND ass09 = g_ass.ass09
                              #AND ass14 = l_asg06   #luttb 110927
                              AND ass14 = x_aaa03    #luttb 110927
                              AND ass15 = tm.ver           
                              AND ass22 = g_dept[i].asa02   #FUN-B50001
                        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                           CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
                           LET g_success = 'N' 
                           CONTINUE FOREACH      
                        END IF
                     ELSE
                        IF STATUS THEN 
                           LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_asz01,"/",g_dept[i].asb04      
                           CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                
                           LET g_success = 'N'
                           CONTINUE FOREACH       
                        END IF
                     END IF                          
                END FOREACH
                #---------------FUN-AA0005 end------------------
 
#FUN-920067 無下層且使用TIPTOP(asg04 = 'Y')時 以本層aed_file資料寫入ass_file----------
                #--FUN-A90026 start--將aed_file->asn_file 且BS/IS類科目均作累計處理----
                LET l_sql=
                    " SELECT asn04,asn05,asn06,SUM(asn08),SUM(asn09),SUM(asn10),SUM(asn11) ",
                    "        ,SUM(asn13),SUM(asn14),asn15,SUM(asn16),SUM(asn17),asn18,asn19 ",    #FUN-B50001 Add
                    " FROM asn_file",
                    " WHERE asn00 = '",g_asz01,"'",
                    "   AND asn01 = '",g_dept[i].asa01,"'",
                    "   AND asn02 = '",g_dept[i].asb04,"'",
                    "   AND asn06 = '",tm.yy,"'",
                    "   AND asn20 = ",tm.yy," AND asn21 = ",tm.em,        #No.FUN-C80020
                    "   AND asn07 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
                    #" GROUP BY asn04,asn05,asn06 ",   #FUN-B50001
                    " GROUP BY asn04,asn05,asn06,asn15,asn18,asn19 ",
                    " ORDER BY asn04,asn05 "
                #--FUN-A90026 end----------------------------------------------------

#--FUN-A90026 mark --start------       
#             #--FUN-A90006 start--
#               LET l_sql=
#                 #" SELECT unique aed01 ",
#                 " SELECT unique aed01,aed02 ",  #FUN-A90006
#                 " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
#                 " WHERE aed03=",tm.yy,
#                 " AND aed00='",g_dept[i].asb05,"' AND aed011='99' ",
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
                     LET g_showmsg=tm.yy,"/",g_dept[i].asb05,'99'
                     CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR
                END IF
                DECLARE p001_aed_c5 CURSOR FOR p001_aed_p5
                #FOREACH p001_aed_c5 INTO l_aed01
                #FOREACH p001_aed_c5 INTO l_aed01,l_aed02  #FUN-A90006
                #--FUN-A90026 start--
                FOREACH p001_aed_c5 INTO g_asn.asn04,g_asn.asn05,g_asn.asn06,   
                                         g_asn.asn08,g_asn.asn09,  
                                         g_asn.asn10,g_asn.asn11              
                                         ,g_asn.asn13,g_asn.asn14,    #FUN-B50001 Add
                                         g_asn.asn15,g_asn.asn16,    #FUN-B50001 Add
                                         g_asn.asn17,g_asn.asn18,    #FUN-B50001 Add
                                         g_asn.asn19                 #FUN-B50001 Add
                     LET l_aed.aed01 = g_asn.asn04
                     LET l_aed.aed02 = g_asn.asn05
                     LET l_aed.aed03 = g_asn.asn06
                     LET l_aed.aed04 = tm.em
                     LET l_aed.aed05 = g_asn.asn08 
                     LET l_aed.aed06 = g_asn.asn09
                     LET l_aed.aed07 = g_asn.asn10
                     LET l_aed.aed08 = g_asn.asn11
                     LET l_aed.aed011 = '99'
                   
                     LET l_ash.ash11 = '1'
                     LET l_ash.ash12 = '1'
#FUN-B70064 --Beatk
                    SELECT aag04 INTO l_aag04
                      FROM aag_file
                     WHERE aag00 = g_aaz641
                       AND aag01 = l_aed.aed01
#FUN-B70064 --End
#--------------------FUN-A90026 mark------------
#                     SELECT ash06,ash11,ash12 INTO l_ash.* FROM ash_file   
#                      WHERE ash01 = g_dept[i].asb04 AND ash06 = l_aed.aed01
#                        AND ash00 = g_dept[i].asb05 
#                        AND ash13 = tm.asa01         
#--------------------FUN-A90026 mark------------

#FUN-B90019--mark--str--
#                   #---FUN-A90026 start----
#                   LET l_sql = 
#                   #" SELECT ash11,ash12 FROM ash_file ",
#                   " SELECT ash04,ash11,ash12 FROM ash_file ",  #TQC-AA0098
#                   "  WHERE ash01 = '",g_dept[i].asb04,"'",
#                   "    AND ash06 = '",l_aed.aed01,"'",
#                   "    AND ash00 = '",g_dept[i].asb05,"'", 
#                   "    AND ash13 = '",tm.asa01,"'"   
#                   PREPARE p001_ash_p2 FROM l_sql
#                   DECLARE p001_ash_c2 SCROLL CURSOR FOR p001_ash_p2
#                   OPEN p001_ash_c2 
#                   FETCH FIRST p001_ash_c2 INTO l_ash.*
#                   CLOSE p001_ash_c2
#                   #---FUN-A90026 end--------

#                    IF STATUS  THEN                   
#                       LET g_showmsg=g_dept[i].asb04,"/",l_aed.aed01 
#                        CALL s_errmsg('ash01,ash04',g_showmsg,l_aed.aed01,'aap-021',1)                #NO.FUN-710023    
#                        LET g_success = 'N'
#                        CONTINUE FOREACH    
#                    END IF
#               #---FUN-A90026 end-----
#FUN-B90019--mark--end

#--FUN-A90026 mark start--------------------------------------------- 
#               LET l_sql=
#                     " SELECT COUNT(*) ",
#                    " FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
#                    " WHERE aed03=",tm.yy,
#                    " AND aed04 ='",tm.em,"'",
#                     " AND aed00='",g_dept[i].asb05,"' AND aed011='99' ",
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
#                   INITIALIZE l_asr.* TO NULL
#                   SELECT * INTO l_ass.*
#                     FROM ass_file
#                    WHERE ass00 = g_aaz641
#                      AND ass01 = g_dept[i].asa01
#                      AND ass02 = g_dept[i].asa02
#                      AND ass03 = g_dept[i].asa03
#                      AND ass04 = g_dept[i].asb04
#                      AND ass041 = g_dept[i].asb05
#                      AND ass05 = l_aed01
#                      AND ass06 = '99'
#                      AND ass07 = l_aed02
#                      AND ass08 = tm.yy
#                      AND ass09 = l_mm
#                      AND ass14 = l_asg06
#                      AND ass15 = tm.ver
#                   IF NOT cl_null(l_ass.ass10) OR NOT cl_null(l_ass.ass11) THEN
#                       LET l_ass.ass09 = l_ass.ass09 +  1
#                       LET l_ass.ass18 = 0
#                       LET l_ass.ass19 = 0
#                       INSERT INTO ass_file VALUES (l_ass.*)
#                        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
#                            UPDATE ass_file SET ass10=ass10+l_ass.ass10,
#                                                ass11=ass11+l_ass.ass11,
#                                                ass12=ass12+l_ass.ass12,
#                                                ass13=ass13+l_ass.ass13,
#                                                ass16=l_ass.ass16,
#                                                ass17=l_ass.ass17,
#                                                ass18=ass18+l_ass.ass18,
#                                                ass19=ass19+l_ass.ass19,
#                                                ass20=ass20+l_ass.ass20,
#                                                ass21=ass21+l_ass.ass21
#                           WHERE ass00 = l_ass.ass00
#                             AND ass01 = l_ass.ass01
#                             AND ass02 = l_ass.ass02
#                             AND ass03 = l_ass.ass03
#                             AND ass04 = l_ass.ass04
#                             AND ass041 = l_ass.ass041
#                             AND ass05 = l_ass.ass05
#                             AND ass06 = l_ass.ass06
#                             AND ass07 = l_ass.ass07
#                             AND ass08 = l_ass.ass08
#                             AND ass09 = l_ass.ass09
#                             AND ass14 = l_ass.ass14
#                             AND ass15 = l_ass.ass15
#                            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                                CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1)
#                               LET g_success = 'N'
#                            END IF
#                        ELSE
#                            IF STATUS THEN
#                                LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04
#                                CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)
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
#                             " AND aed00='",g_dept[i].asb05,"' AND aed011='99' ", #FUN-630063
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
#                       LET g_showmsg=tm.yy,"/",g_dept[i].asb05,'99'
#                       CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                   END IF
#                   DECLARE p001_aed_c CURSOR FOR p001_aed_p
#                   FOREACH p001_aed_c INTO l_aed.*
#                       IF SQLCA.SQLCODE THEN 
#                          LET g_showmsg=tm.yy,"/",g_dept[i].asb05,'99'
#                          CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                       END IF
#                       IF l_aed.aed05 =0 AND l_aed.aed06=0 THEN CONTINUE FOREACH END IF
#                       LET l_ash.ash06 = l_aed.aed01
#                       LET l_ash.ash11 = '1'
#                       LET l_ash.ash12 = '1'
#                       #抓取下層公司的科目的合併財報科目編號(ash06),
#                       #再衡量匯率類別(ash11),換算匯率類別(ash12),
#                       #以判斷後續轉換幣別時,要用那種匯率計算
#                       SELECT ash06,ash11,ash12 INTO l_ash.* FROM ash_file   
#                        WHERE ash01 = g_dept[i].asb04 AND ash04 = l_aed.aed01
#                          AND ash00 = g_dept[i].asb05   #No.FUN-740020
#                          AND ash13 = tm.asa01          #FUN-910001 add
#                       IF STATUS  THEN                   
#                          LET g_showmsg=g_dept[i].asb04,"/",l_aed.aed01 
#                           CALL s_errmsg('ash01,ash04',g_showmsg,l_aed.aed01,'aap-021',1)                #NO.FUN-710023    
#                           LET g_success = 'N'
#                           CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                       END IF
#                       LET l_ash06 = l_ash.ash06   #FUN-580063    
#
#                       #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
#                       #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
#                       #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
#                       #  乘上匯率逐一算出借貸方記帳金額(asr08,asr09 OR ass10,ass11)
#                       SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asb04
#                       IF SQLCA.sqlcode THEN
#                          CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)                                  #NO.FUN-710023
#                          LET g_success = 'N'
#                          CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                       END IF
#                       LET l_aag04=''
#                       LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
#                                   " WHERE aag00='",g_dept[i].asb05,"'", #帳別
#                                   "   AND aag01='",l_aed.aed01,"'" #科目
#	                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
#                       PREPARE p001_pre_02 FROM g_sql
#                       DECLARE p001_cur_02 CURSOR FOR p001_pre_02
#                       OPEN p001_cur_02
#                       FETCH p001_cur_02 INTO l_aag04
#                       CLOSE p001_cur_02
#                       IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
#----------FUN-A90026 mark end-----------------------------------------------

#FUN-B90019--mark--str--
#                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
#                    LET l_rate  = 1
#                    LET l_rate1 = 1
#                    #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
#                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                    #一一換算後再加總起來

#                    #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
#                    #IF l_ash.ash11='2' AND l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN   #FUN-770069  #FUN-970046 mOd  #FUN-A60038 MARK
#                    LET l_chg_aed05_1=0
#                    LET l_chg_aed06_1=0
#                    LET l_chg_aed05=0
#                    LET l_chg_aed06=0
#                    LET l_chg_aed05_a=0
#                    LET l_chg_aed06_a=0
#                    #---FUN-A60038 start---
#                    LET l_chg_dr = 0 
#                    LET l_chg_cr = 0
#                    LET l_fun_dr = 0 
#                    LET l_fun_cr = 0 
#                    LET l_acc_dr = 0 
#                    LET l_acc_cr = 0
#                    #---FUN-A60038 end-----
#                    LET l_dr = 0   #MOD-A80102
#                    LET l_cr = 0   #MOD-A80102

#                    #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
#                    #--現時匯率---
#                    IF l_ash.ash11='1' THEN 
#                        CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,l_aed.aed03,l_aed.aed04)           #FUN-B70064 MARK
#                                          l_asg.asg07,l_aed.aed03,l_aed.aed04,g_asa05)   #FUN-B70064 ADD
#                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                    END IF

#                    #--歷史匯率---
#                    IF l_ash.ash11='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                        #----如果agli011抓不到資料，則依科目餘額計算---- 
#                        DECLARE p001_cnt_cs23 CURSOR FOR p001_asf_p2
#                        OPEN p001_cnt_cs23
#                        USING g_dept[i].asa01,g_dept[i].asb04,
#                             #l_aed.aed01,l_ash.ash06,g_date_e 
#                             l_aed.aed01,g_date_e                #FUN-A90026 mod
#                        FETCH p001_cnt_cs23 INTO l_asf_count
#                        CLOSE p001_cnt_cs23
#                        IF l_asf_count > 0 THEN   
#                            #CALL p001_asf(i,l_aed.aed01,l_ash.ash06,g_date_e) 
#                            #CALL p001_asf(i,l_aed.aed01,g_date_e)    #FUN-A90026 
#                            CALL p001_asf(i,l_ash.ash04,l_aed.aed01,g_date_e)    #FUN-A90026   #TQC-AA0098
#                            #--FUN-A70086 start--
#                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                            #LET l_fun_dr = l_chg_dr
#                            #LET l_fun_cr = l_chg_cr
#                            #LET l_acc_dr = l_chg_dr
#                            #LET l_acc_cr = l_chg_cr
#                            #--FUN-A70086 end----
#                        ELSE
#                            #--取不到agli011時一樣用匯率換算---
#                            CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,l_aed.aed03,l_aed.aed04)           #FUN-B70064 MARK
#                                          l_asg.asg07,l_aed.aed03,l_aed.aed04,g_asa05)   #FUN-B70064 ADD
#                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                        END IF
#                    ELSE
#                        CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                      l_ash.ash11,l_asg.asg06,
#                                     #l_asg.asg07,l_aed.aed03,l_aed.aed04)               #FUN-B70064 MARK
#                                      l_asg.asg07,l_aed.aed03,l_aed.aed04,g_asa05)       #FUN-B70064 ADD
#                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                    END IF
#      
#                    #--平均匯率---
#                    IF l_ash.ash11='3' THEN
##--FUN-A90006 start--
#                        #--FUN-A90026 start--
#                        IF g_asa05 = '1' THEN     
#      		     	     CALL p001_fun_ass_avg(l_ash.ash11,l_aed.aed01,
#                                                  l_aed.aed02,l_asg.asg06,l_asg.asg07,
#                                                  l_aed.aed03,l_aed.aed04,i)  
#                            RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
#                            #CALL p001_fun_ass_avg('1',l_ash.ash06,l_aed.aed02,        #FUN-A9026 mark
#                            #                      l_aag04,                            #FUN-A9026 mark
#                            #                      l_asg.asg06,l_asg.asg07,i,          #FUN-A9026 mark
#                            #                      l_aed.aed05,l_aed.aed06)            #FUN-A9026 mark
#                            #RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr  #上層記帳借/貸金額
#                        ELSE
#                            CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                          l_ash.ash11,l_asg.asg06,
#                                         #l_asg.asg07,l_aed.aed03,l_aed.aed04)            #FUN-B70064 mark
#                                          l_asg.asg07,l_aed.aed03,l_aed.aed04,g_asa05)    #FUN-B70064 add
#                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                        END IF
#                        #--FUN-A90026 end----
##--FUN-A90006 end----
#                    END IF

#                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                    #--現時匯率---
#                    IF l_ash.ash12='1' THEN 
#                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                          l_ash.ash12,l_asg.asg07,
#                                         #x_aaa03,l_aed.aed03,l_aed.aed04)              #FUN-B70064 MARK
#                                          x_aaa03,l_aed.aed03,l_aed.aed04,g_asa05)      #FUN-B70064 ADD
#                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                    END IF

#                    #--歷史匯率---
#                    IF l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
#                        #----如果agli011抓不到資料，則依科目餘額計算---- 
#                        DECLARE p001_cnt_cs26 CURSOR FOR p001_asf_p2
#                        OPEN p001_cnt_cs26
#                        USING g_dept[i].asa01,g_dept[i].asb04,
#                              #l_aed.aed01,l_ash.ash06,g_date_e 
#                              l_aed.aed01,g_date_e              #FUN-A90026 mod
#                        FETCH p001_cnt_cs26 INTO l_asf_count
#                        CLOSE p001_cnt_cs26
#                        IF l_asf_count > 0 THEN   
#                            #CALL p001_asf(i,l_aed.aed01,l_ash.ash06,g_date_e)  
#                            #CALL p001_asf(i,l_aed.aed01,g_date_e)    #FUN-A90026 mod
#                            CALL p001_asf(i,l_ash.ash04,l_aed.aed01,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
#                            #--FUN-A70086 start--
#                            #RETURNING l_chg_dr,l_chg_cr  #回傳借/貸方金額
#                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
#                            #LET l_fun_dr = l_chg_dr
#                            #LET l_fun_cr = l_chg_cr
#                            #LET l_acc_dr = l_chg_dr
#                            #LET l_acc_cr = l_chg_cr
#                            #--FUN-A70086 end----
#                        ELSE
#                            #--取不到agli011時一樣用匯率換算---
#                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                              l_ash.ash12,l_asg.asg07,
#                                             #x_aaa03,l_aed.aed03,l_aed.aed04)                #FUN-B70064 MARK  
#                                              x_aaa03,l_aed.aed03,l_aed.aed04,g_asa05)        #FUN-B70064 ADD
#                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                        END IF
#                    ELSE
#                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                    		      l_ash.ash12,l_asg.asg07,
#                   		     #x_aaa03,l_aed.aed03,l_aed.aed04)                        #FUN-B70064 MARK
#                    		      x_aaa03,l_aed.aed03,l_aed.aed04,g_asa05)                #FUN-B70064 ADD
#                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                    END IF

#                    #--平均匯率---
#                    IF l_ash.ash12='3' THEN
##--FUN-A90006 START--
#                        #--FUN-A90026 start--
#                        IF g_asa05 = '1' THEN        
#                            CALL p001_ass_avg(l_ash.ash11,l_ash.ash12,l_aed.aed01,l_aed.aed02,
#                                              l_asg.asg06,l_asg.asg07,l_aed.aed03,l_aed.aed04,i)  
#                            #CALL p001_ass_avg('2',g_dbs_gl,l_aed.aed01,l_aed.aed02,    #FUN-A90026 mark 
#                            #                  g_dept[i].asb05,l_aag04,                 #FUN-A90026 mark
#                            #                  l_asg.asg06,l_asg.asg07,i,               #FUN-A90026 mark
#                            #                  l_dr,l_cr)                               #FUN-A90026 mark
#                            #--FUN-A90026 end----
#                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                        #--FUN-A90026 start---
#                        ELSE
#                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                         l_ash.ash12,l_asg.asg07,
#                                        #x_aaa03,l_aed.aed03,l_aed.aed04)              #FUN-B70064 mark
#                                         x_aaa03,l_aed.aed03,l_aed.aed04,g_asa05)      #FUN-B70064 add
#                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                        END IF
#                        #--FUN-A90026 end------
##--FUN-A90006 end---
#                    END IF       
#                    #-------FUN-A60038 end-----------------------------------
#FUN-B90019--mark--end

#---------FUN-A60038 mark---------------------------------------------
#                    DECLARE p001_cnt_cs3 CURSOR FOR p001_asf_p2
#                    OPEN p001_cnt_cs3
#                    USING g_dept[i].asa01,g_dept[i].asb04,
#                          l_aed.aed01,l_ash.ash06,g_date_e   #FUN-970046
#                    FETCH p001_cnt_cs3 INTO l_asf_count
#                    IF l_asf_count > 0 THEN
#                       DECLARE p001_asf_cs5 CURSOR FOR p001_asf_p
#                       OPEN p001_asf_cs5                         #FUN-970046 add
#                       USING g_dept[i].asa01,g_dept[i].asb04,
#                             l_aed.aed01,l_ash.ash06,g_date_e    #FUN-970046 mod
#                       FETCH p001_asf_cs5                        #FUN-970046 add
#                        INTO l_aag06,l_asf13                     #FUN-990020 mark
#                       #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                       IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                           #功能幣別匯率
#                           CALL p001_getrate(l_ash.ash11,l_asf08,l_asf09,   #FUN-770069 mod
#                                             l_asg.asg06,l_asg.asg07)   #MOD-780115
#                           RETURNING l_rate
#                           IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                       END IF
#                       #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                       IF l_asg.asg07 != x_aaa03 THEN
#                           #記帳幣別匯率
#                           CALL p001_getrate(l_ash.ash12,l_asf08,l_asf09,   #FUN-770069 mod
#                                             l_asg.asg07,x_aaa03)
#                           RETURNING l_rate1
#                           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                       END IF
#                       IF g_dept[i].asa02=g_dept[i].asb04 THEN
#                           LET l_rate=1
#                           LET l_rate1=1
#                       END IF                     
#
#                       #->幣別轉換及取位
#                       #原本程式: IF l_asf05 > 0 段增加下列判斷式
#                       #->幣別轉換及取位
#                       IF l_asf13 > 0 THEN 
#                           IF l_aag06='1' THEN                 #正常餘額為1.借餘
#                               LET l_chg_aed05_a=l_asf13       #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=0             #下層公司功能幣別貸方金額
#                           ELSE                   #正常餘額為2.貸餘
#                               LET l_chg_aed05_a=0             #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=l_asf13       #下層公司功能幣別貸方金額
#                           END IF
#                       ELSE
#                           IF l_aag06='1' THEN    #正常餘額為1.借餘
#                               LET l_chg_aed05_a=0             #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=(l_asf13*-1)  #下層公司功能幣別貸方金額
#                           ELSE                   #正常餘額為2.貸餘
#                               LET l_chg_aed05_a=(l_asf13*-1)  #下層公司功能幣別借方金額
#                               LET l_chg_aed06_a=0             #下層公司功能幣別貸方金額
#                           END IF
#                       END IF
#                       LET l_chg_aed05  =l_chg_aed05   + l_chg_aed05_a           #下層公司功能幣借方金額
#                       LET l_chg_aed06  =l_chg_aed06   + l_chg_aed06_a           #下層公司功能幣貸方金額
#                       LET l_chg_aed05_1=l_chg_aed05_1 + l_chg_aed05_a * l_rate1 #上層記帳幣別借方金額
#                       LET l_chg_aed06_1=l_chg_aed06_1 + l_chg_aed06_a * l_rate1 #上層記帳幣別貸方金額
#------------------FUN-A60038 mark-----------------------------------------------

#FUN-B90019--mark--str--
#                    #--FUN-A60038 start--
#                    LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
#                    LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
#                    LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
#                    LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr
#                    #---FUN-A60038 end----

#                    #SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07    #FUN-A60060 mod
#                    IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                    
#                    #LET l_aed.aed01=l_ash06   #FUN-A90026 mark
#                    #->幣別轉換及取位
#                    LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                    LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                    LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                    LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                    IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                    IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#FUN-B90019--mark--end
                     
                    #FUN-B90019--mod--str--aglp000已經處理了匯率,所以p001匯率只需拿金額倒推就可
                    LET l_ass16 = (g_asn.asn16-g_asn.asn17)/(g_asn.asn13-g_asn.asn14) 
                    LET l_ass17 = (g_asn.asn08-g_asn.asn09)/(g_asn.asn16-g_asn.asn17)
                    ##--FUN-A90026 start--
                    #IF g_asa05 = '1' THEN
                    #    IF l_ash.ash11 = '3' THEN  #TQC-AA0098
                    #        IF l_asg.asg06 != l_asg.asg07 THEN
                    #            LET l_ass16 = (l_chg_aed05-l_chg_aed06)/(l_aed.aed05-l_aed.aed06) 
                    #        ELSE
                    #            LET l_ass16 = l_rate
                    #        END IF
                    #    #TQC-AA0098
                    #    ELSE
                    #        LET l_ass16 = l_rate
                    #    END IF
                    #    #TQC-AA0098

                    #    IF l_ash.ash12 = '3' THEN   #TQC-AA0098
                    #        IF l_asg.asg07 != x_aaa03 THEN
                    #            LET l_ass17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06) 
                    #        ELSE
                    #            LET l_ass17 = l_rate1     #FUN-960003 add
                    #        END IF
                    #    #TQC-AA0098
                    #    ELSE
                    #        LET l_ass17 = l_rate1
                    #    END IF
                    #    #TQC-AA0098
                    #ELSE
                    ##--FUN-A90026 end---
                    #    LET l_ass16 = l_rate      #FUN-960003 add
                    #    LET l_ass17 = l_rate1     #FUN-960003 add
                    #END IF   #FUN-A90026 add
                    #FUN-B90019--mod--end

                     #FUN-B50001--add--str--
                     #IF NOT cl_null(g_asn.asn13) AND g_asn.asn13<>0 THEN   #下層公司原幣借方金額  #FUN-B90019
                        LET l_aed.aed05 = g_asn.asn13
                     #END IF    #FUN-B90019
                     #IF NOT cl_null(g_asn.asn14) AND g_asn.asn14<>0 THEN   #下層公司原幣貸方金額  #FUN-B90019
                        LET l_aed.aed06 = g_asn.asn14
                     #END IF    #FUN-B90019
                     IF cl_null(g_asn.asn15)  THEN      #下層公司幣別
                         LET g_asn.asn15 = l_asg.asg06
                     END IF 
                     #IF NOT cl_null(g_asn.asn16) AND g_asn.asn16<>0 THEN   #下層公司功能幣借方金額 #FUN-B90019
                        LET l_chg_aed05 = g_asn.asn16
                     #END IF    #FUN-B90019
                     #IF NOT cl_null(g_asn.asn17) AND g_asn.asn17<>0 THEN    #下層公司功能幣貸方金額  #FUN-B90019
                        LET l_chg_aed06 = g_asn.asn17
                     #END IF    #FUN-B90019
                     IF cl_null(g_asn.asn18) THEN        #功能幣別
                        LET g_asn.asn18 = l_asg.asg07
                     END IF 
                     IF cl_null(g_asn.asn19) THEN        #原始公司編碼
                        LET g_asn.asn19 = g_dept[i].asb04
                     END IF 
                     LET l_chg_aed05_1 = g_asn.asn08  #FUN-B90019
                     LET l_chg_aed06_1 = g_asn.asn09  #FUN-B90019
                     #FUN-B50001--add--end
                     #luttb 110926--test--str--
                       SELECT COUNT(*) INTO l_cnt FROM ass_file
                        WHERE ass00 = g_asz01
                              AND ass01 = g_dept[i].asa01
                          #    AND ass02 = tm.asa02        #FUN-A30064
                              #No.TQC-C90057  --Begin
                              #AND ass02 = g_dept[i].asa02 #FUN-A30064
                              #AND ass03 = g_dept[i].asa03
                              AND ass02 = tm.asa02
                              AND ass03 = tm.asa03
                              #No.TQC-C90057  --End  
                              AND ass04 = g_dept[i].asb04
                              AND ass041= g_dept[i].asb05
                              AND ass05 = l_aed.aed01
                              AND ass06 = l_aed.aed011
                              AND ass07 = l_aed.aed02
                              AND ass08 = l_aed.aed03
                              AND ass09 = l_aed.aed04
                                #AND ass14 = l_asg06   #luttb 110927
                                AND ass14 = x_aaa03    #luttb 110927
                              AND ass15 = tm.ver
                              AND ass22 = g_asn.asn19    #FUN-B50001
                     IF l_cnt = 0 THEN
                     #luttb 110926--test--end

                        INSERT INTO ass_file 
                      (ass00,ass01,ass02,ass03,ass04,ass041,   
                       ass05,ass06,ass07,ass08,ass09,ass10,
                       ass11,ass12,ass13,ass14,ass15,  #FUN-580063   
                       ass16,ass17,asslegal,
                       #ass18,ass19,ass20,ass21)        #FUN-A30079   #FUN-B50001 Mark
                       ass18,ass19,ass20,ass21,ass22,ass23,ass24)    #FUN-B50001 Add
                      VALUES 
                       (g_asz01,g_dept[i].asa01,g_dept[i].asa02,  
                        g_dept[i].asa03,   #FUN-5A0020
                        g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
                        l_aed.aed02,l_aed.aed03,l_aed.aed04,
                        #l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036   #luttb 110926
                        g_asn.asn08,g_asn.asn09,                     #luttb 110926
                        #l_aed.aed07,l_aed.aed08,l_asg06,  #luttb 110927 
                        l_aed.aed07,l_aed.aed08,x_aaa03,   #luttb 110927
                        tm.ver,
                        #l_ass16,l_ass17,g_azw02,
                        l_ass16,l_ass17,g_azw02,
                        #l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079  #FUN-B50001                             
                        l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06,   #FUN-B50001
                        g_asn.asn19,g_asn.asn18,g_asn.asn15)                #FUN-B50001
                        #luttb 110926--test--add--str--
                        IF STATUS THEN
                           CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
                           CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1)
                           LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_asz01,"/",g_dept[i].asb04
                           CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)
                           LET g_success = 'N'
                           CONTINUE FOREACH
                        END IF
                        #luttb 110926--test--add--end
                     #IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069   #luttb 110926 test
                      ELSE   #luttb 110926  test
                      #luttb 110926--mod--str--
                      # UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
                      #                        ass11=ass11+l_chg_aed06_1,
                        UPDATE ass_file    SET ass10=ass10+g_asn.asn08,
                                               ass11=ass11+g_asn.asn09,
                      #luttb 110926--mod--end
                                               ass12=ass12+l_aed.aed07,
                                               ass13=ass13+l_aed.aed08,
                                               ass16=l_ass16,            
                                               ass17=l_ass17,
                                              #ass18=l_ass18+l_aed.aed05,  #FUN-A30079  #MOD-A70091 mark            
                                              #ass19=l_ass19+l_aed.aed06,  #FUN-A30079  #MOD-A70091 mark 
                                              #ass20=l_ass20+l_chg_aed05,  #FUN-A30079  #MOD-A70091 mark             
                                              #ass21=l_ass21+l_chg_aed06   #FUN-A30079  #MOD-A70091 mark             
                                               ass18=ass18+l_aed.aed05,                 #MOD-A70091              
                                               ass19=ass19+l_aed.aed06,                 #MOD-A70091
                                               ass20=ass20+l_chg_aed05,                 #MOD-A70091
                                               ass21=ass21+l_chg_aed06                  #MOD-A70091
                            WHERE ass00 = g_asz01  
                              AND ass01 = g_dept[i].asa01
                          #    AND ass02 = tm.asa02        #FUN-A30064
                              #No.TQC-C90057  --Begin
                              #AND ass02 = g_dept[i].asa02 #FUN-A30064
                              #AND ass03 = g_dept[i].asa03
                              AND ass02 = tm.asa02
                              AND ass03 = tm.asa03
                              #No.TQC-C90057  --End  
                              AND ass04 = g_dept[i].asb04
                              AND ass041= g_dept[i].asb05
                              AND ass05 = l_aed.aed01
                              AND ass06 = l_aed.aed011
                              AND ass07 = l_aed.aed02
                              AND ass08 = l_aed.aed03
                              AND ass09 = l_aed.aed04
                              #AND ass14 = l_asg06   #luttb 110927
                              AND ass14 = x_aaa03    #luttb 110927
                              AND ass15 = tm.ver           
                              AND ass22 = g_asn.asn19    #FUN-B50001
                        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                           CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
                           LET g_success = 'N' 
                           CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                        END IF
                    #luttb 110926--test--mark--str--
                    # ELSE
                    #    IF STATUS THEN 
                    #       CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
                    #       CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1) 
                    #       LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_asz01,"/",g_dept[i].asb04      
                    #       CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                
                    #       LET g_success = 'N'
                    #       CONTINUE FOREACH       
                    #    END IF
                    #luttb 110926--test--mark--end
                     END IF                          
#---------------FUN-A60038 mark------------------------
#                      ELSE       #找不到asf資料時以aed資料寫入ass_file
#                            IF l_aag04='1' THEN #1.BS 2.IS
#                                LET l_bs_yy=l_aed.aed03
#                                LET l_bs_mm=tm.em
#                            ELSE
#                                LET l_bs_yy=l_aed.aed03
#                                LET l_bs_mm=l_aed.aed04
#                            END IF
#                            IF g_dept[i].asa02 != g_dept[i].asb04 THEN
#                                #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                                IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                                #功能幣別匯率
#                                    CALL p001_getrate(l_ash.ash11,l_bs_yy,l_bs_mm,
#                                                      l_asg.asg06,l_asg.asg07)   #MOD-780115
#                                    RETURNING l_rate
#                                    IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                                END IF
#  
#                                #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                                IF l_asg.asg07 != x_aaa03 THEN
#                                   #記帳幣別匯率
#                                   CALL p001_getrate(l_ash.ash12,l_bs_yy,l_bs_mm,
#                                                     l_asg.asg07,x_aaa03)
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
#                            SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                            IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                            SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                            IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                            
#                            LET l_aed.aed01=l_ash06
#                            #->幣別轉換及取位
#                            LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                            LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                            LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                            LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                            IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                            IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                            
#                            LET l_ass16 = l_rate      #FUN-960003 add
#                            LET l_ass17 = l_rate1     #FUN-960003 add
#                            
#                            INSERT INTO ass_file 
#                             (ass00,ass01,ass02,ass03,ass04,ass041,  
#                              ass05,ass06,ass07,ass08,ass09,ass10,
#                              ass11,ass12,ass13,ass14,ass15,  #FUN-580063   
#                              ass16,ass17,
#                              ass18,ass19,ass20,ass21)  #FUN-A30079 add                                  
#                             VALUES 
#                              (g_aaz641,g_dept[i].asa01,g_dept[i].asa02,   
#                               g_dept[i].asa03,   #FUN-5A0020
#                               g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
#                               l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                               l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                               l_aed.aed07,l_aed.aed08,l_asg06,  
#                               tm.ver,                                        
#                               l_ass16,l_ass17,
#                               l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079                               
#                            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                               UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
#                                                      ass11=ass11+l_chg_aed06_1,
#                                                      ass12=ass12+l_aed.aed07,
#                                                      ass13=ass13+l_aed.aed08,
#                                                      ass16=l_ass16,             
#                                                      ass17=l_ass17,
#                                                      ass18=ass18+l_aed.aed05,  #FUN-A30079
#                                                      ass19=ass19+l_aed.aed06,  #FUN-A30079
#                                                      ass20=ass20+l_chg_aed05,  #FUN-A30079
#                                                      asa21=ass21+l_chg_aed06   #FUN-A30079             
#                                   WHERE ass00 = g_aaz641  
#                                     AND ass01 = g_dept[i].asa01
#    #                                AND ass02 = g_dept[i].asa02 #FUN-A30064
#                                     AND ass02 = tm.asa02        #FUN-A30064
#                                     AND ass03 = g_dept[i].asa03
#                                     AND ass04 = g_dept[i].asb04
#                                     AND ass041= g_dept[i].asb05
#                                     AND ass05 = l_aed.aed01
#                                     AND ass06 = l_aed.aed011
#                                     AND ass07 = l_aed.aed02
#                                     AND ass08 = l_aed.aed03
#                                     AND ass09 = l_aed.aed04
#                                     AND ass14 = l_asg06
#                                     AND ass15 = tm.ver          
#                               #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                                  CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
#                                  LET g_success = 'N' 
#                                  CONTINUE FOREACH       
#                               END IF
#                            ELSE
#                               IF STATUS THEN 
#                                  CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
#                                  CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1)  
#                                  LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04        
#                                  CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                    
#                                  LET g_success = 'N'
#                                  CONTINUE FOREACH       
#                               END IF
#                            END IF    
#                        END IF  
#                  ELSE    #(ash11,ash12 <> '2')
#                      IF l_aag04='1' THEN #1.BS 2.IS
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=tm.em
#                      ELSE
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=l_aed.aed04
#                      END IF
#                      IF g_dept[i].asa02 != g_dept[i].asb04 THEN
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                            #功能幣別匯率
#                            CALL p001_getrate(l_ash.ash11,l_bs_yy,l_bs_mm,
#                                              l_asg.asg06,l_asg.asg07)   #MOD-780115
#                                 RETURNING l_rate
#                                 IF cl_null(l_rate) THEN LET l_rate= 1 END IF #FUN-970046 
#                         END IF
#                      
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg07 != x_aaa03 THEN
#                            #記帳幣別匯率
#                            CALL p001_getrate(l_ash.ash12,l_bs_yy,l_bs_mm,
#                                              l_asg.asg07,x_aaa03)
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
#                      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                      IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                      SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                      IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                      
#                      LET l_aed.aed01=l_ash06
#                      #->幣別轉換及取位
#                      LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                      LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                      LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                      LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                      IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                      IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                      
#                      LET l_ass16 = l_rate      #FUN-960003 add
#                      LET l_ass17 = l_rate1     #FUN-960003 add
#                      
#                      INSERT INTO ass_file 
#                       (ass00,ass01,ass02,ass03,ass04,ass041,   #No:MOD-470041
#                        ass05,ass06,ass07,ass08,ass09,ass10,
#                        ass11,ass12,ass13,ass14,ass15,  #FUN-580063   #FUN-750078 add ass15
#                        ass16,ass17,                                  #FUN-970046 add
#                        ass18,ass19,ass20,ass21)                      #FUN-A30079
#                       VALUES 
#                        (g_aaz641,g_dept[i].asa01,g_dept[i].asa02,   #FUN-920067
#                         g_dept[i].asa03,   #FUN-5A0020
#                         g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
#                         l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                         l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                         l_aed.aed07,l_aed.aed08,l_asg06,  #FUN-580063 3.將上層公司記帳幣別存入ass14
#                         tm.ver,                                        #FUN-750078 add tm.ver 
#                         l_ass16,l_ass17,                               #FUN-970046 add 
#                         l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079
#                      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                         UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
#                                                ass11=ass11+l_chg_aed06_1,
#                                                ass12=ass12+l_aed.aed07,
#                                                ass13=ass13+l_aed.aed08,
#                                                ass16=l_ass16,             #FUN-970046 add
#                                                ass17=l_ass17,             #FUN-970046 add
#                                                ass18=ass18+l_aed.aed05,   #FUN-A30079 add
#                                                ass19=ass19+l_aed.aed06,   #FUN-A30079 add
#                                                ass20=ass20+l_chg_aed05,   #FUN-A30079 add
#                                                ass21=ass21+l_chg_aed06    #FUN-A30079 add
#                             WHERE ass00 = g_aaz641  
#                               AND ass01 = g_dept[i].asa01
##                              AND ass02 = g_dept[i].asa02 #FUN-A30064
#                               AND ass02 = tm.asa02        #FUN-A30064
#                               AND ass03 = g_dept[i].asa03
#                               AND ass04 = g_dept[i].asb04
#                               AND ass041= g_dept[i].asb05
#                               AND ass05 = l_aed.aed01
#                               AND ass06 = l_aed.aed011
#                               AND ass07 = l_aed.aed02
#                               AND ass08 = l_aed.aed03
#                               AND ass09 = l_aed.aed04
#                               AND ass14 = l_asg06
#                               AND ass15 = tm.ver           #MOD-930135
#                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                            CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
#                            LET g_success = 'N' 
#                            CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                         END IF
#                      ELSE
#                         IF STATUS THEN 
#                            CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
#                            CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1)  #No.FUN-660123 #NO.FUN-710023
#                            LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04        #NO.FUN-710023    #FUN-920067 mod
#                            CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                #NO.FUN-710023      
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
#                        " AND aed00='",g_dept[i].asb05,"' AND aed011='99' ", 
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
#                  LET g_showmsg=tm.yy,"/",g_dept[i].asb05,'99'
#                  CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#              END IF
#              DECLARE p001_aed_c1 CURSOR FOR p001_aed_p1
#              FOREACH p001_aed_c1 INTO l_aed.*
#                  IF SQLCA.SQLCODE THEN 
#                     LET g_showmsg=tm.yy,"/",g_dept[i].asb05,'99'
#                     CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR #NO.FUN-710023
#                  END IF
#                  IF l_aed.aed05 =0 AND l_aed.aed06=0 THEN CONTINUE FOREACH END IF
#                  
#                  LET l_aed.aed04 = tm.em
#                  LET l_ash.ash11 = '1'
#                  LET l_ash.ash12 = '1'
#                  #抓取下層公司的科目的合併財報科目編號(ash06),
#                  #再衡量匯率類別(ash11),換算匯率類別(ash12),
#                  #以判斷後續轉換幣別時,要用那種匯率計算
#                  SELECT ash06,ash11,ash12 INTO l_ash.* FROM ash_file   
#                   WHERE ash01 = g_dept[i].asb04 AND ash04 = l_aed.aed01
#                     AND ash00 = g_dept[i].asb05  
#                     AND ash13 = tm.asa01          
#                  IF STATUS  THEN                   
#                     LET g_showmsg=g_dept[i].asb04,"/",l_aed.aed01 
#                      CALL s_errmsg('ash01,ash04',g_showmsg,l_aed.aed01,'aap-021',1)              
#                      LET g_success = 'N'
#                      CONTINUE FOREACH   
#                  END IF
#                  LET l_ash06 = l_ash.ash06
#
#                  #--取總帳借貸方異動額---
#                  #-------- FUN-A60038 start----------
#                  IF l_ash.ash06 = g_aaz114 THEN
#                      LET l_sql=
#                            " SELECT aed05,aed06 ",
#                            " FROM ",g_dbs_gl,"aed_file",
#                            " WHERE aed03=",tm.yy,
#                            " AND aed04 = ",tm.em,
#                            " AND aed00='",g_dept[i].asb05,"' AND aed011='99' ", 
#                            " AND aag01='",g_aaz114,"'",
#                            " AND aed02='",l_aed.aed02,"'"   #FUN-A80130
#                          
#	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
#                      PREPARE p001_aed_p3 FROM l_sql
#                      IF STATUS THEN
#                         LET g_showmsg=tm.yy,"/",g_dept[i].asb05     
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
#                  #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
#                  #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
#                  #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
#                  #  乘上匯率逐一算出借貸方記帳金額(asr08,asr09 OR ass10,ass11)
#                  SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asb04
#                  IF SQLCA.sqlcode THEN
#                     CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)                            
#                     LET g_success = 'N'
#                     CONTINUE FOREACH     
#                  END IF
#                  LET l_aag04=''
#                  LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
#                              " WHERE aag00='",g_dept[i].asb05,"'", #帳別
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
#                  #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
#                  #金額需抓agli011設定的記帳幣別金額(小於等於本期),
#                  #一一換算後再加總起來
#
#                  #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
#                  #IF l_ash.ash11='2' AND l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN   #FUN-A60038 mark
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
#                  IF l_ash.ash11='1' THEN 
#                      CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                        l_ash.ash11,l_asg.asg06,
#                                        l_asg.asg07,l_aed.aed03,l_aed.aed04)
#                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                  END IF
#
#                  #--歷史匯率---
#                  IF l_ash.ash11='2' THEN  
#                      IF ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN
#                          #----如果agli011抓不到資料，則依科目餘額計算---- 
#                          DECLARE p001_cnt_cs27 CURSOR FOR p001_asf_p2
#                          OPEN p001_cnt_cs27
#                          USING g_dept[i].asa01,g_dept[i].asb04,
#                                l_aed.aed01,l_ash.ash06,g_date_e 
#                          FETCH p001_cnt_cs27 INTO l_asf_count
#                          CLOSE p001_cnt_cs27
#                          IF l_asf_count > 0 THEN   
#                              CALL p001_asf(i,l_aed.aed01,l_ash.ash06,g_date_e)   #FUN-A60038 add
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
#                                                l_ash.ash11,l_asg.asg06,
#                                                l_asg.asg07,l_aed.aed03,l_aed.aed04)
#                              RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                          END IF
#                      ELSE
#                          CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                            l_ash.ash11,l_asg.asg06,
#                                            l_asg.asg07,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                      END IF
#                  END IF
#       
#                  #--平均匯率---
#                  IF l_ash.ash11='3' THEN
#                      #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                      #例:截止期別=3,則要按1月異動額*平均匯率+2月異動*匯率+3月異動額*匯率
#                          IF l_ash.ash06 = g_aaz114  THEN  
#                          CALL p001_fun_ass_avg('1',l_ash.ash06,l_aed.aed02,      #FUN-A90006
#                                                 l_aag04,
#                                                 l_asg.asg06,l_asg.asg07,i,
#                                                 l_aed05,l_aed06)
#                          RETURNING l_dr,l_cr,l_fun_dr,l_fun_cr  #上層記帳借/貸金額  
#                      ELSE
#                          CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
#                                            l_ash.ash11,l_asg.asg06,
#                                            l_asg.asg07,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#                      END IF
#                  END IF
#
#                  #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
#                  #--現時匯率---
#                  IF l_ash.ash12='1' THEN 
#                      CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                        l_ash.ash12,l_asg.asg07,
#                                        x_aaa03,l_aed.aed03,l_aed.aed04)
#                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                  END IF
#
#                  #--歷史匯率---
#                  IF l_ash.ash12 = '2' THEN  
#                      IF ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN
#                          #----如果agli011抓不到資料，則依科目餘額計算---- 
#                          DECLARE p001_cnt_cs28 CURSOR FOR p001_asf_p2
#                          OPEN p001_cnt_cs28
#                          USING g_dept[i].asa01,g_dept[i].asb04,
#                               l_aed.aed01,l_ash.ash06,g_date_e  
#                          FETCH p001_cnt_cs28 INTO l_asf_count
#                          CLOSE p001_cnt_cs28
#                          IF l_asf_count > 0 THEN   
#                              CALL p001_asf(i,l_aed.aed01,l_ash.ash06,g_date_e)   #FUN-A60038 add
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
#                                                l_ash.ash12,l_asg.asg07,
#                                                x_aaa03,l_aed.aed03,l_aed.aed04)
#                              RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                          END IF
#                      ELSE
#                          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                            l_ash.ash12,l_asg.asg07,
#                                            x_aaa03,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                      END IF
#                  END IF
#       
#                  #--平均匯率---
#                  IF l_ash.ash12='3' THEN 
#                      #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                      #例:截止期別=3,則要按1月異動額*平均匯率+2月異動*匯率+3月異動額*匯率
#                      IF l_ash.ash06 = g_aaz114 THEN  #本期損益BS要按月異動額換算匯率，不能用累計值直接去換算
#                          IF cl_null(l_dr) THEN LET l_dr = l_fun_dr END IF   #FUN-A70053
#                          IF cl_null(l_cr) THEN LET l_cr = l_fun_cr END IF   #FUN-A70053
#                          #--MOD-A80102 start---
#                          #CALL p001_avg('2',g_dbs_gl,l_aed.aed01,  #FUN-A80130 mark
#                          CALL p001_ass_avg('2',g_dbs_gl,l_ash.ash06,l_aed.aed02,  #FUN-A80130 add
#                                            g_dept[i].asb05,l_aag04,              #FUN-A90006
#                                            l_asg.asg06,l_asg.asg07,i,
#                                            l_dr,l_cr)
#                          RETURNING l_acc_dr,l_acc_cr  
#                      ELSE
#                          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
#                                            l_ash.ash12,l_asg.asg07,
#                                            x_aaa03,l_aed.aed03,l_aed.aed04)
#                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
#                      END IF
#                  END IF
#                  #-------FUN-A60038 end-----------------------------------
#
#----------FUN-A90026 mark--end--------------------------------------------


#----------FUN-A60038 mark 移至p001_asf()---------------------------
#                      DECLARE p001_cnt_cs8 CURSOR FOR p001_asf_p2
#                      OPEN p001_cnt_cs8
#                      USING g_dept[i].asa01,g_dept[i].asb04,
#                            l_aed.aed01,l_ash.ash06,g_date_e 
#                      FETCH p001_cnt_cs8 INTO l_asf_count
#                      IF l_asf_count > 0 THEN
#                         DECLARE p001_asf_cs8 CURSOR FOR p001_asf_p
#                         OPEN p001_asf_cs8                       
#                         USING g_dept[i].asa01,g_dept[i].asb04,
#                               l_aed.aed01,l_ash.ash06,g_date_e    
#                         FETCH p001_asf_cs8              
#                         INTO l_aag06,l_asf13           #FUN-990020 mark
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                             #功能幣別匯率
#                             CALL p001_getrate(l_ash.ash11,l_asf08,l_asf09,
#                                               l_asg.asg06,l_asg.asg07)  
#                             RETURNING l_rate
#                             IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                         END IF
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg07 != x_aaa03 THEN
#                             #記帳幣別匯率
#                             CALL p001_getrate(l_ash.ash12,l_asf08,l_asf09,   
#                                               l_asg.asg07,x_aaa03)
#                             RETURNING l_rate1
#                             IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF #FUN-970046 
#                         END IF
#                         IF g_dept[i].asa02=g_dept[i].asb04 THEN
#                             LET l_rate=1
#                             LET l_rate1=1
#                         END IF                     
#
#                         #->幣別轉換及取位
#                         #原本程式: IF l_asf05 > 0 段增加下列判斷式
#                         #->幣別轉換及取位
#                         IF l_asf13 > 0 THEN 
#                             IF l_aag06='1' THEN                 #正常餘額為1.借餘
#                                 LET l_chg_aed05_a=l_asf13       #功能幣別借方金額
#                                 LET l_chg_aed06_a=0                    #功能幣別貸方金額
#                             ELSE                   #正常餘額為2.貸餘
#                                 LET l_chg_aed05_a=0            #功能幣別借方金額
#                                 LET l_chg_aed06_a=l_asf13      #功能幣別貸方金額
#                             END IF
#                         ELSE
#                                 IF l_aag06='1' THEN    #正常餘額為1.借餘
#                                     LET l_chg_aed05_a=0                      #功能幣別借方金額
#                                     LET l_chg_aed06_a=(l_asf13*-1)  #功能幣別貸方金額
#                                 ELSE                   #正常餘額為2.貸餘
#                                     LET l_chg_aed05_a=(l_asf13*-1)  #功能幣別借方金額
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
#                  SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                  IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                  SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                  IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                  LET l_aed.aed01=l_ash06
#
#                  #->幣別轉換及取位
#                  LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                  LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                  LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                  LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                  IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                  IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                  
#                  LET l_ass16 = l_rate      #FUN-960003 add
#                  LET l_ass17 = l_rate1     #FUN-960003 add
#
#                  INSERT INTO ass_file 
#                   (ass00,ass01,ass02,ass03,ass04,ass041,   
#                    ass05,ass06,ass07,ass08,ass09,ass10,
#                    ass11,ass12,ass13,ass14,ass15,  #FUN-580063   
#                    ass16,ass17,
#                    ass18,ass19,ass20,ass21)    #FUN-A30079                                 
#                   VALUES 
#                    (g_aaz641,g_dept[i].asa01,g_dept[i].asa02,  
#                     g_dept[i].asa03,   #FUN-5A0020
#                     g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
#                     l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                     l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                     l_aed.aed07,l_aed.aed08,l_asg06, 
#                     tm.ver,                                        
#                     l_ass16,l_ass17,
#                     l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                  IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                     UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
#                                            ass11=ass11+l_chg_aed06_1,
#                                            ass12=ass12+l_aed.aed07,
#                                            ass13=ass13+l_aed.aed08,
#                                            ass16=l_ass16,            
#                                            ass17=l_ass17,
#                                            ass18=ass18+l_aed.aed05,   #FUN-A30079
#                                            ass19=ass19+l_aed.aed06,   #FUN-A30079
#                                            ass20=ass20+l_chg_aed05,   #FUN-A30079
#                                            ass21=ass21+l_chg_aed06    #FUN-A30079           
#                         WHERE ass00 = g_aaz641  
#                           AND ass01 = g_dept[i].asa01
# #                         AND ass02 = g_dept[i].asa02 #FUN-A30064
#                           AND ass02 = tm.asa02        #FUN-A30064
#                           AND ass03 = g_dept[i].asa03
#                           AND ass04 = g_dept[i].asb04
#                           AND ass041= g_dept[i].asb05
#                           #AND ass05 = l_aed.aed01
#                           AND ass05 = l_ash.ash06    #FUN-A90006
#                           AND ass06 = l_aed.aed011
#                           AND ass07 = l_aed.aed02
#                           AND ass08 = l_aed.aed03
#                           AND ass09 = l_aed.aed04
#                           AND ass14 = l_asg06
#                           AND ass15 = tm.ver           
#                     #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                        CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
#                        LET g_success = 'N' 
#                        CONTINUE FOREACH       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
#                     END IF
#                  ELSE
#                     IF STATUS THEN 
#                        CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
#                        CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1) 
#                        LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04      
#                        CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                
#                        LET g_success = 'N'
#                        CONTINUE FOREACH       
#                     END IF
#                  END IF                          
#---FUN-A90026 mark end--------------------------------------------------

#--------FUN-A60038 MARK start------------------------------------------
#                      ELSE       #找不到asf資料時以aed資料寫入ass_file
#                          IF l_aag04='1' THEN #1.BS 2.IS
#                              LET l_bs_yy=l_aed.aed03
#                              LET l_bs_mm=tm.em
#                          ELSE
#                              LET l_bs_yy=l_aed.aed03
#                              LET l_bs_mm=l_aed.aed04
#                          END IF
#                          IF g_dept[i].asa02 != g_dept[i].asb04 THEN
#                              #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                              IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                              #功能幣別匯率
#                                  CALL p001_getrate(l_ash.ash11,l_bs_yy,l_bs_mm,
#                                                    l_asg.asg06,l_asg.asg07)   #MOD-780115
#                                  RETURNING l_rate
#                                  IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                              END IF
#  
#                              #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                              IF l_asg.asg07 != x_aaa03 THEN
#                                 #記帳幣別匯率
#                                 CALL p001_getrate(l_ash.ash12,l_bs_yy,l_bs_mm,
#                                                   l_asg.asg07,x_aaa03)
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
#                          SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                          IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                          SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                          IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                          
#                          LET l_aed.aed01=l_ash06
#                          #->幣別轉換及取位
#                          LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                          LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                          LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                          LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                          IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                          IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                          
#                          LET l_ass16 = l_rate      #FUN-960003 add
#                          LET l_ass17 = l_rate1     #FUN-960003 add
#                          
#                          INSERT INTO ass_file 
#                           (ass00,ass01,ass02,ass03,ass04,ass041,  
#                            ass05,ass06,ass07,ass08,ass09,ass10,
#                            ass11,ass12,ass13,ass14,ass15,  #FUN-580063   
#                            ass16,ass17,
#                            ass18,ass19,ass20,ass21)        #FUN-A30079                                  
#                           VALUES 
#                            (g_aaz641,g_dept[i].asa01,g_dept[i].asa02,   
#                             g_dept[i].asa03,   #FUN-5A0020
#                             g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
#                             l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                             l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                             l_aed.aed07,l_aed.aed08,l_asg06,  
#                             tm.ver,                                        
#                             l_ass16,l_ass17,
#                             l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                             UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
#                                                    ass11=ass11+l_chg_aed06_1,
#                                                    ass12=ass12+l_aed.aed07,
#                                                    ass13=ass13+l_aed.aed08,
#                                                    ass16=l_ass16,             
#                                                    ass17=l_ass17,
#                                                    ass18=ass18+l_aed.aed05,   #FUN-A30079              
#                                                    ass19=ass19+l_aed.aed06,   #FUN-A30079              
#                                                    ass20=ass20+l_chg_aed05,   #FUN-A30079              
#                                                    ass21=ass21+l_chg_aed06    #FUN-A30079              
#                                 WHERE ass00 = g_aaz641  
#                                   AND ass01 = g_dept[i].asa01
#    #                              AND ass02 = g_dept[i].asa02 #FUN-A30064
#                                   AND ass02 = tm.asa02        #FUN-A30064
#                                   AND ass03 = g_dept[i].asa03
#                                   AND ass04 = g_dept[i].asb04
#                                   AND ass041= g_dept[i].asb05
#                                   AND ass05 = l_aed.aed01
#                                   AND ass06 = l_aed.aed011
#                                   AND ass07 = l_aed.aed02
#                                   AND ass08 = l_aed.aed03
#                                   AND ass09 = l_aed.aed04
#                                   AND ass14 = l_asg06
#                                   AND ass15 = tm.ver          
#                             #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                                CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
#                                LET g_success = 'N' 
#                                CONTINUE FOREACH       
#                             END IF
#                          ELSE
#                             IF STATUS THEN 
#                                CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
#                                CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1)  
#                                LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04        
#                                CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)                    
#                                LET g_success = 'N'
#                                CONTINUE FOREACH       
#                             END IF
#                          END IF    
#                      END IF  
#                  ELSE    #(ash11,ash12 <> '2')
#                      IF l_aag04='1' THEN #1.BS 2.IS
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=tm.em
#                      ELSE
#                         LET l_bs_yy=l_aed.aed03
#                         LET l_bs_mm=l_aed.aed04
#                      END IF
#                      IF g_dept[i].asa02 != g_dept[i].asb04 THEN
#                         #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg06 != l_asg.asg07 THEN   #MOD-780115
#                            #功能幣別匯率
#                            CALL p001_getrate(l_ash.ash11,l_bs_yy,l_bs_mm,
#                                              l_asg.asg06,l_asg.asg07)   #MOD-780115
#                                 RETURNING l_rate
#                                 IF cl_null(l_rate) THEN LET l_rate = 1 END IF #FUN-970046 
#                         END IF
#                      
#                         #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
#                         IF l_asg.asg07 != x_aaa03 THEN
#                            #記帳幣別匯率
#                            CALL p001_getrate(l_ash.ash12,l_bs_yy,l_bs_mm,
#                                              l_asg.asg07,x_aaa03)
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
#                      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06   #FUN-920167 記帳幣別
#                      IF cl_null(l_cut) THEN LET l_cut=0 END IF
#                      SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
#                      IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
#                      
#                      LET l_aed.aed01=l_ash06
#                      #->幣別轉換及取位
#                      LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
#                      LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
#                      LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
#                      LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
#                      IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
#                      IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
#                      
#                      LET l_ass16 = l_rate      #FUN-960003 add
#                      LET l_ass17 = l_rate1     #FUN-960003 add
#                      
#                      INSERT INTO ass_file 
#                       (ass00,ass01,ass02,ass03,ass04,ass041,   #No:MOD-470041
#                        ass05,ass06,ass07,ass08,ass09,ass10,
#                        ass11,ass12,ass13,ass14,ass15,  #FUN-580063   #FUN-750078 add ass15
#                        ass16,ass17,                                  #FUN-970046 add
#                        ass18,ass19,ass20,ass21)                      #FUN-A30079
#                       VALUES 
#                        (g_aaz641,g_dept[i].asa01,g_dept[i].asa02,   #FUN-920067
#                         g_dept[i].asa03,   #FUN-5A0020
#                         g_dept[i].asb04,g_dept[i].asb05,l_aed.aed01,l_aed.aed011,
#                         l_aed.aed02,l_aed.aed03,l_aed.aed04,
#                         l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
#                         l_aed.aed07,l_aed.aed08,l_asg06,  #FUN-580063 3.將上層公司記帳幣別存入ass14
#                         tm.ver,                                       
#                         l_ass16,l_ass17,
#                         l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)   #FUN-A30079                               
#                      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
#                         UPDATE ass_file    SET ass10=ass10+l_chg_aed05_1,
#                                                ass11=ass11+l_chg_aed06_1,
#                                                ass12=ass12+l_aed.aed07,
#                                                ass13=ass13+l_aed.aed08,
#                                                ass16=l_ass16,             
#                                                ass17=l_ass17,
#                                                ass18=ass18+l_aed.aed05,  #FUN-A30079
#                                                ass19=ass19+l_aed.aed06,  #FUN-A30079
#                                                ass20=ass20+l_chg_aed05,  #FUN-A30079
#                                                ass21=ass21+l_chg_aed06   #FUN-A30079
#                             WHERE ass00 = g_aaz641  
#                               AND ass01 = g_dept[i].asa01
##                              AND ass02 = g_dept[i].asa02 #FUN-A30064
#                               AND ass02 = tm.asa02        #FUN-A30064
#                               AND ass03 = g_dept[i].asa03
#                               AND ass04 = g_dept[i].asb04
#                               AND ass041= g_dept[i].asb05
#                               AND ass05 = l_aed.aed01
#                               AND ass06 = l_aed.aed011
#                               AND ass07 = l_aed.aed02
#                               AND ass08 = l_aed.aed03
#                               AND ass09 = l_aed.aed04
#                               AND ass14 = l_asg06
#                               AND ass15 = tm.ver          
#                         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#                            CALL s_errmsg('ass01',g_dept[i].asa01,'upd_ass',SQLCA.sqlcode,1) 
#                            LET g_success = 'N' 
#                            CONTINUE FOREACH    
#                         END IF
#                      ELSE
#                         IF STATUS THEN 
#                            CALL cl_err('ins_ass',status,1)   #FUN-5A0020   #No.FUN-660123
#                            CALL cl_err3("ins","ass_file",g_dept[i].asa01,g_dept[i].asa02,status,"","ins_ass",1) 
#                            LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_aaz641,"/",g_dept[i].asb04       
#                            CALL s_errmsg('ass01,ass02,ass03,ass04 ',g_showmsg,'ins_ass',status,1)               
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
#                         " AND aedd00='",g_dept[i].asb05,"'",
#                         " AND aedd01 = aag01 ",
#                         " AND aedd00 = aag00 ",
#                         " AND aag07 IN ('2','3') ",
#                         " AND aag04 <> '1'",
#                         " AND aag09 = 'Y' ",
#                         " AND aag01 <> '",g_aaz113,"'"    #FUN-A70086
#-FUN-A90026 mark end-------------

                #--FUN-A90026 start----
                LET l_sql=" SELECT asnn04,asnn05,asnn06,asnn07,asnn08,asnn09,",
                          "        SUM(asnn11),SUM(asnn12),SUM(asnn13),SUM(asnn14)",
                          "   FROM asnn_file ",
                          "  WHERE asnn09 =",tm.yy,
                          "    AND asnn10 BETWEEN ",tm.bm," AND ",tm.em,
                          "    AND asnn20 = ",tm.yy," AND asnn21 = ",tm.em,        #No.FUN-C80020
                          "    AND asnn00='",g_asz01,"'",
                          "    AND asnn01='",g_dept[i].asa01,"'",
                          "    AND asnn02='",g_dept[i].asb04,"'",
                          "  GROUP BY asnn04,asnn05,asnn06,asnn07,asnn08,asnn09 ",
                          "  ORDER BY asnn04,asnn05,asnn06,asnn07,asnn08 "
                #--FUN-A90026 end--------

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
                PREPARE p001_asl_p1 FROM l_sql
                IF STATUS THEN
                   #LET g_showmsg=tm.yy,"/",g_dept[i].asb05
                   LET g_showmsg=tm.yy,"/",g_dept[i].asb04    #FUN-A90026
                   #CALL s_errmsg('aedd03,aedd00',g_showmsg,'prepare:asl_p1',STATUS,1) LET g_success='N' CONTINUE FOR  #FUN-A90026 mark
                   CALL s_errmsg('asnn09,asnn02',g_showmsg,'prepare:asl_p1',STATUS,1) LET g_success='N' CONTINUE FOR     #FUN-A90026 mod
                END IF
                DECLARE p001_asl_c1 CURSOR FOR p001_asl_p1
                #FOREACH p001_asl_c1 INTO l_aedd.*
                FOREACH p001_asl_c1 INTO g_asnn.*      #FUN-A90026 mod
                    IF SQLCA.SQLCODE THEN
                       #LET g_showmsg=tm.yy,"/",g_dept[i].asb05   #FUN-A90026 mark
                       LET g_showmsg=tm.yy,"/",g_dept[i].asb04    #FUN-A90026 add
                       #CALL s_errmsg('aedd03,aedd00',g_showmsg,'prepare:asl_c1',STATUS,1) LET g_success='N' CONTINUE FOR  #FUN-A90026 mark
                       CALL s_errmsg('asnn09,asnn02',g_showmsg,'foreach:asl_c1',STATUS,1) LET g_success ='N' CONTINUE FOR    #FUN-A90026 mark
                    END IF
                    #IF l_aedd.aedd05 =0 AND l_aedd.aedd06=0 THEN CONTINUE FOREACH END IF   #FUN-A90026 mark
                    IF g_asnn.asnn11 =0 AND g_asnn.asnn12=0 THEN CONTINUE FOREACH END IF        #FUN-A90026 add
                    #LET l_ash.ash06 = l_aedd.aedd01   #FUN-A90026 mark
                    LET l_ash.ash11 = '1'
                    LET l_ash.ash12 = '1'
                    #抓取下層公司的科目的合并財報科目編號(ash06),
                    #再衡量匯率類別(ash11),換算匯率類別(ash12),
                    #以判斷后續轉換幣別時,要用那種匯率計算
#-----------FUN-A90026 mark----------
#                    SELECT ash06,ash11,ash12 INTO l_ash.* FROM ash_file
#                     #WHERE ash01 = g_dept[i].asb04 AND ash04 = l_aedd.aedd01 #FUN-A90026 mark
#                     WHERE ash01 = g_dept[i].asb04 AND ash06 = g_asnn.asnn04    #FUN-A90026 mod
#                       AND ash00 = g_dept[i].asb05   
#                       AND ash13 = tm.asa01         
#-----------FUN-A90026 mark
                    #---FUN-A90026 start----
                    LET l_sql = 
                    #" SELECT ash11,ash12 FROM ash_file ",
                    " SELECT ash04,ash11,ash12 FROM ash_file ",  #TQC-AA0098
                    "  WHERE ash01 = '",g_dept[i].asb04,"'",
                    "    AND ash06 = '",g_asnn.asnn04,"'",
                    "    AND ash00 = '",g_dept[i].asb05,"'", 
                    "    AND ash13 = '",tm.asa01,"'"   
                    PREPARE p001_ash_p3 FROM l_sql
                    DECLARE p001_ash_c3 SCROLL CURSOR FOR p001_ash_p3
                    OPEN p001_ash_c3 
                    FETCH FIRST p001_ash_c3 INTO l_ash.*
                    CLOSE p001_ash_c3
                    #---FUN-A90026 end--------

                    IF STATUS  THEN
                       #LET g_showmsg=g_dept[i].asb04,"/",l_aedd.aedd01
                       LET g_showmsg=g_dept[i].asb04,"/",g_asnn.asnn04          #FUN-A90026 mod
                       #CALL s_errmsg('ash01,ash04',g_showmsg,l_aedd.aedd01,'aap-021',1)
                       CALL s_errmsg('ash01,ash06',g_showmsg,'','aap-021',1)  #FUN-A90026 mod      
                       LET g_success = 'N'
                       CONTINUE FOREACH       
                    END IF
#                    LET l_ash06 = l_ash.ash06     #FUN-A90026 mark
                    #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
                    #  乘上匯率逐一算出借貸方記賬金額(asl10,asl11)
                    SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg(' ',' ','',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH     
                    END IF
                    LET l_aag04=''
                    LET g_sql = "SELECT aag04 FROM ",g_dbs_gl,"aag_file",
                                " WHERE aag00='",g_dept[i].asb05,"'", #帳別
                                #"   and aag01='",l_aedd.aedd01,"'" #科目
                                "   and aag01='",g_asnn.asnn04,"'" #科目    #FUN-A90026
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    PREPARE p001_asl_p2 FROM g_sql
                    DECLARE p001_asl_c2 CURSOR FOR p001_asl_p2
                    OPEN p001_asl_c2
                    FETCH p001_asl_c2 INTO l_aag04
                    CLOSE p001_asl_c2
                    IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
                    #當上層公司不等于下層公司時,才需要抓匯率來計算,否則匯率用1來計
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記賬幣別金額(小于等于本期),
                    #一一換算后再加總起來

                    #--條件( g_dept[i].asa02 != g_dept[i].asb04 )-->本層對本層不會有長投
                    #IF l_ash.ash11='2' AND l_ash.ash12='2' AND ( g_dept[i].asa02 !=g_dept[i].asb04 ) THEN  #FUN-A60038 MARK
#-----------------FUN-A90026 mark--
#                   LET l_chg_aedd05_1=0
#                   LET l_chg_aedd06_1=0
#                   LET l_chg_aedd05=0
#                   LET l_chg_aedd06=0
#                   LET l_chg_aedd05_a=0
#                   LET l_chg_aedd06_a=0
#----------------FUN-A90026 mark---------
                    #--FUN-A90026 start----
                    LET l_chg_asnn11_1=0
                    LET l_chg_asnn12_1=0
                    LET l_chg_asnn11=0
                    LET l_chg_asnn12=0
                    LET l_chg_asnn11_a=0
                    LET l_chg_asnn12_a=0
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
                    IF l_ash.ash11='1' THEN 
                        #---FUN-A90026 mark----
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #                  l_ash.ash11,l_asg.asg06,
                        #                  l_asg.asg07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark---
                        #--FUN-A90026 start--
                        CALL p001_fun_amt(l_aag04,g_asnn.asnn11,g_asnn.asnn12,
                                          l_ash.ash11,l_asg.asg06,
                                         #l_asg.asg07,g_asnn.asnn09,tm.em)           #FUN-B70064 MARK  
                                          l_asg.asg07,g_asnn.asnn09,tm.em,g_asa05)   #FUN-B70064 ADD
                        #--FUN-A90026 end---- 
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_ash.ash11='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs29 CURSOR FOR p001_asf_p2
                        OPEN p001_cnt_cs29
                        USING g_dept[i].asa01,g_dept[i].asb04,
                             #l_aedd.aedd01,l_ash.ash06,g_date_e   #FUN-A90026 mark
                             g_asnn.asnn04,g_date_e      #FUN-A90026 mod
                        FETCH p001_cnt_cs29 INTO l_asf_count
                        CLOSE p001_cnt_cs29
                        IF l_asf_count > 0 THEN   
                            #CALL p001_asf(i,l_aedd.aedd01,l_ash.ash06,g_date_e)  #FUN-A90026 mark
                            #CALL p001_asf(i,g_asnn.asnn04,g_date_e)     #FUN-A90026 mod
                            CALL p001_asf(i,l_ash.ash04,g_asnn.asnn04,g_date_e)     #FUN-A90026 mod #TQC-AA0098
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
                            #              l_ash.ash11,l_asg.asg06,
                            #              l_asg.asg07,l_aedd.aedd03,l_aedd.aedd04)
                            #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            #--FUN-A90026 mark---
                            #--FUN-A90026 start--
                            CALL p001_fun_amt(l_aag04,g_asnn.asnn11,g_asnn.asnn12,
                                          l_ash.ash11,l_asg.asg06,
                                         #l_asg.asg07,g_asnn.asnn09,tm.em)            #FUN-B70064 MARK
                                          l_asg.asg07,g_asnn.asnn09,tm.em,g_asa05)    #FUN-B70064 ADD
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            #--FUN-A90026 end----
                        END IF
                    ELSE
                        #--FUN-A90026 mark----
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #              l_ash.ash11,l_asg.asg06,
                        #              l_asg.asg07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark---
                        #--FUN-A90026 start---
                        CALL p001_fun_amt(l_aag04,g_asnn.asnn11,g_asnn.asnn12,
                                      l_ash.ash11,l_asg.asg06,
                                     #l_asg.asg07,g_asnn.asnn09,tm.em)            #FUB-B70064 MARK
                                      l_asg.asg07,g_asnn.asnn09,tm.em,g_asa05)    #FUN-B70064 ADD
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 end---
                    END IF
       
                    #--平均匯率---
                    IF l_ash.ash11='3' THEN  #本期損益BS為資產負債類科目，此時不需處理
                        #--FUN-A90026 mark--
                        #CALL p001_fun_amt(l_aag04,l_aedd.aedd05,l_aedd.aedd06,
                        #              l_ash.ash11,l_asg.asg06,
                        #              l_asg.asg07,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 mark--
                        #--FUN-A90026 start--
                        CALL p001_fun_amt(l_aag04,g_asnn.asnn11,g_asnn.asnn12,
                                      l_ash.ash11,l_asg.asg06,
                                     #l_asg.asg07,g_asnn.asnn09,tm.em)            #FUN-B70064 MARK
                                      l_asg.asg07,g_asnn.asnn09,tm.em,g_asa05)    #FUN-B70064 ADD
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 end----
                    END IF

                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_ash.ash12='1' THEN 
                        #--FUN-A90026 mark--
                        #CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                        #                  l_ash.ash12,l_asg.asg07,
                        #                  x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
                        #RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #--FUN-A90026 mark--
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_ash.ash12,l_asg.asg07,
                                         #x_aaa03,g_asnn.asnn09,tm.em)            #FUN-B70064 MARK
                                          x_aaa03,g_asnn.asnn09,tm.em,g_asa05)    #FUN-B70064  ADD
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #---FUN-A90026 mark----
                    END IF

                    #--歷史匯率---
                    IF l_ash.ash12='2' AND ( g_dept[i].asa02 != g_dept[i].asb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs30 CURSOR FOR p001_asf_p2
                        OPEN p001_cnt_cs30
                        USING g_dept[i].asa01,g_dept[i].asb04,
                              #l_aedd.aedd01,l_ash.ash06,g_date_e 
                              g_asnn.asnn04,g_date_e      #FUN-A90026
                        FETCH p001_cnt_cs30 INTO l_asf_count
                        CLOSE p001_cnt_cs30
                        IF l_asf_count > 0 THEN   
                            #CALL p001_asf(i,l_aedd.aedd01,l_ash.ash06,g_date_e)  
                            #CALL p001_asf(i,g_asnn.asnn04,g_date_e)      #FUN-A90026
                            CALL p001_asf(i,l_ash.ash04,g_asnn.asnn04,g_date_e)      #FUN-A90026   #TQC-AA0098
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
                                              l_ash.ash12,l_asg.asg07,
                                             #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
                                             #x_aaa03,g_asnn.asnn09,tm.em)       #FUN-A90026    #FUN-B70064 MARK
                                              x_aaa03,g_asnn.asnn09,tm.em,g_asa05)              #FUN-B70064 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
		        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		    		      l_ash.ash12,l_asg.asg07,
		    		     #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
		    		     #x_aaa03,g_asnn.asnn09,tm.em)           #FUN-A90026        #FUN-B70064 MARK	  
		    		      x_aaa03,g_asnn.asnn09,tm.em,g_asa05)                      #FUN-B70064 ADD 	
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_ash.ash12='3' THEN 
		        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		            	      l_ash.ash12,l_asg.asg07,
		            	     #x_aaa03,l_aedd.aedd03,l_aedd.aedd04)
                                     #x_aaa03,g_asnn.asnn09,tm.em)        #FUN-A90026         #FUN-B70064 MARK
		            	      x_aaa03,g_asnn.asnn09,tm.em,g_asa05)                    #FUN-B70064 ADD
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
                    #-------FUN-A60038 end-----------------------------------

#----------------------FUN-A60038 mark- 移至p001_asf()---------------------------
#                   DECLARE p001_asl_c3 CURSOR FOR p001_asf_p2
#                   OPEN p001_asl_c3
#                   USING g_dept[i].asa01,g_dept[i].asb04,
#                         l_aedd.aedd01,l_ash.ash06,g_date_e
#                   FETCH p001_asl_c3 INTO l_asf_count
#                   IF l_asf_count > 0 THEN
#                      DECLARE p001_asl_c4 CURSOR FOR p001_asf_p
#                      OPEN p001_asl_c4   
#                      USING g_dept[i].asa01,g_dept[i].asb04,
#                            l_aedd.aedd01,l_ash.ash06,g_date_e  
#                      FETCH p001_asl_c4    
#                       INTO l_aag06,l_asf13        
#                      #當子公司記賬幣別與子公司功能幣別不同時才需要抓匯率來計
#                      IF l_asg.asg06 != l_asg.asg07 THEN  
#                         #功能幣別匯率
#                         CALL p001_getrate(l_ash.ash11,l_asf08,l_asf09,
#                                           l_asg.asg06,l_asg.asg07)
#                         RETURNING l_rate
#                         IF cl_null(l_rate) THEN LET l_rate = 1 END IF
#                      END IF
#                      #當子公司功能幣別與母公司記賬幣別不同時才需要抓匯率來計算
#                      IF l_asg.asg07 != x_aaa03 THEN
#                         #記賬幣別匯率 
#                         CALL p001_getrate(l_ash.ash12,l_asf08,l_asf09,
#                                           l_asg.asg07,x_aaa03)
#                         RETURNING l_rate1
#                         IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
#                      END IF
#                      IF g_dept[i].asa02=g_dept[i].asb04 THEN
#                         LET l_rate=1
#                         LET l_rate1=1
#                      END IF
#                      #->幣別轉換及取位
#                      IF l_asf13 > 0 THEN
#                         IF l_aag06='1' THEN                #正常余額為1.借 
#                            LET l_chg_aedd05_a=l_asf13       #功能幣別借方金額 
#                            LET l_chg_aedd06_a=0             #功能幣別       
#                         ELSE                               #正常余額為2.貸余
#                            LET l_chg_aedd05_a=0             #功能幣別借方金額
#                            LET l_chg_aedd06_a=l_asf13       #功能幣別貸方金額
#                         END IF
#                      ELSE
#                         IF l_aag06='1' THEN                #正常余額為1.借余
#                            LET l_chg_aedd05_a=0                      
#                            LET l_chg_aedd06_a=(l_asf13*-1)  #功能幣別貸方金額
#                         ELSE                               #正常余額為2.貸余  
#                            LET l_chg_aedd05_a=(l_asf13*-1)  #功能幣別借方金額
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

                    #SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg06  
                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07    #FUN-A60060 mod
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                    #LET l_aedd.aedd01=l_ash06    #FUN-A90026 mark
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
                    LET l_chg_asnn11=cl_digcut(l_chg_asnn11,l_cut)
                    LET l_chg_asnn12=cl_digcut(l_chg_asnn12,l_cut)
                    LET l_chg_asnn11_1= cl_digcut(l_chg_asnn11_1,l_cut1)
                    LET l_chg_asnn12_1= cl_digcut(l_chg_asnn12_1,l_cut1)
                    IF cl_null(l_chg_asnn11_1) THEN LET l_chg_asnn11_1=0 END IF
                    IF cl_null(l_chg_asnn12_1) THEN LET l_chg_asnn12_1=0 END IF
                    #--FUN-A90026 end-----

                    LET l_asl16 = l_rate   
                    LET l_asl17 = l_rate1   
                    INSERT INTO asl_file
                     (asl00,asl01,asl02,asl021,asl03,asl031,
                      asl04,asl05,asl06,asl07,asl08,asl09,
                      asl10,asl11,asl12,asl13,asl14,asl15,
                      asl16,asl17,asl18)
                    VALUES
                      (g_asz01,g_dept[i].asa01,g_dept[i].asa02,
                      g_dept[i].asa03,g_dept[i].asb04,g_dept[i].asb05, 
                      #l_aedd.aedd01,l_aedd.aedd015,l_aedd.aedd016,    #FUN-A90026 mark
                      #l_aedd.aedd017,l_aedd.aedd018,l_aedd.aedd03,    #FUN-A90026 mark
                      #l_aedd.aedd04,l_aedd.aedd05,l_aedd.aedd06,      #FUN-A90026 mark
                      #l_aedd.aedd07,l_aedd.aedd08,tm.ver,             #FUN-A90026 mark
                      g_asnn.asnn04,g_asnn.asnn05,g_asnn.asnn06,g_asnn.asnn07, #FUN-A90026 mod
                      g_asnn.asnn08,g_asnn.asnn09,tm.em,g_asnn.asnn11, #FUN-A90026 mod
                      g_asnn.asnn12,g_asnn.asnn13,g_asnn.asnn14,tm.ver,      #FUN-A90026 mod
                      l_asl16,l_asl17,l_asg06)
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                       #UPDATE asl_file    SET asl11=asl11+l_chg_aedd05_1,    #FUN-A90026 mark
                       #                       asl12=asl12+l_chg_aedd06_1,    #FUN-A90026 mark
                       #                       asl13=asl13+l_aedd.aedd07,     #FUN-A90026 mark
                       #                       asl14=asl14+l_aedd.aedd08,     #FUN-A90026 mark
                       UPDATE asl_file SET asl11=asl11+l_chg_asnn11_1,         #FUN-A90026 mod
                                           asl12=asl12+l_chg_asnn12_1,         #FUN-A90026 mod
                                           asl13=asl13+g_asnn.asnn13,           #FUN-A90026 mod
                                           asl14=asl14+g_asnn.asnn14,           #FUN-A90026 mod
                                           asl16=l_asl16,
                                           asl17=l_asl17
                        WHERE asl00 = g_asz01
                          AND asl01 = g_dept[i].asa01
                          #AND asl02 = tm.asa02  #FUN-A30064                                                                                                         
                          AND asl021= g_dept[i].asa03
                          #No.TQC-C90057  --Begin
                          #AND asl02 = g_dept[i].asa02
                          #AND asl03 = g_dept[i].asb04
                          AND asl02 = tm.asa02
                          AND asl03 = tm.asa03
                          #No.TQC-C90057  --End  
                          AND asl031= g_dept[i].asb05
                          #AND asl04 = l_aedd.aedd01        #FUN-A90026 mark
                          #AND asl05 = l_aedd.aedd015       #FUN-A90026 mark
                          #AND asl06 = l_aedd.aedd016       #FUN-A90026 mark
                          #AND asl07 = l_aedd.aedd017       #FUN-A90026 mark 
                          #AND asl08 = l_aedd.aedd018       #FUN-A90026 mark
                          #AND asl09 = l_aedd.aedd03        #FUN-A90026 mark
                          #AND asl10 = l_aedd.aedd04        #FUN-A90026 mark
                          AND asl04 = g_asnn.asnn04    #FUN-A90026 mod
                          AND asl05 = g_asnn.asnn05    #FUN-A90026 mod
                          AND asl06 = g_asnn.asnn06    #FUN-A90026 mod
                          AND asl07 = g_asnn.asnn07    #FUN-A90026 mod
                          AND asl08 = g_asnn.asnn08    #FUN-A90026 mod
                          AND asl09 = g_asnn.asnn09    #FUN-A90026 mod
                          AND asl10 = tm.em          #FUN-A90026 mod
                          AND asl15 = tm.ver
                          AND asl18 = l_asg06
                       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                          CALL s_errmsg('asl01',g_dept[i].asa01,'upd_asl',SQLCA.sqlcode,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                    ELSE
                       IF STATUS THEN
                          LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_asz01,"/",g_dept[i].asb04
                          CALL s_errmsg('asl01,asl02,asl03,asl04 ',g_showmsg,'ins_asl',status,1)
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
 
#FUN-B50001---mark--str---拆分至aglp007.4gl
## --FUN-A90036 先產生換匯差額分錄,並寫入p001_adj_tmp()  換匯分錄寫入
#    #-->step 4
#    CALL p001_adj()
## --FUN-A90036 end-----

#    #-->step 3 產生調整分錄
#    #-->ref.asq_file insert into asj_file,ask_file
#    CALL p001_modi()

#    CALL p001_modi_adj()  #FUN-A60038

##--FUN-A90036 mark---
##    #-->step 4 
##    CALL p001_adj()  
##--FUN-A90036 mark--
#FUN-B50001--mark--end
END FUNCTION
#--FUN-A90026 end-----

FUNCTION p001_del() 
  LET g_em = tm.em   #FUN-770069 add
  #-->delete asl_file(合并前科目異動碼(固定)衝賬余額檔) 
  DELETE FROM asl_file
        WHERE asl00=g_asz01 
          AND asl01=tm.asa01
       #  AND asl02=tm.asa02  #Mark by sam 20101204
          AND asl09=tm.yy
          AND asl10=tm.em
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","asl_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","del asl_file",1)
     LET g_success = 'N'
     RETURN
  END IF
  #FUN-9B0017   ---end

  #-->delete asr_file(合併前會計科目各期餘額檔)
  DELETE FROM asr_file 
        WHERE asr00=g_asz01   #FUN-5A0020  #FUN-920067 mod
          AND asr01=tm.asa01 
         #AND asr02=tm.asa02 #Mark by sam 20101204 
          AND asr06=tm.yy AND asr07 = tm.em #FUN-970046 mod
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","asr_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","del asr_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

  #-->delete ass_file(科目異動碼沖帳餘額檔)
  DELETE FROM ass_file 
        WHERE ass00=g_asz01   #FUN-5A0020   #FUN-920067 mod
          AND ass01=tm.asa01 
         #AND ass02=tm.asa02 #Mark by sam 20101204 
          AND ass08=tm.yy AND ass09 = tm.em   #FUN-970046
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","ass_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","del ass_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

#FUN-B50001--mark--str----
#  #-->delete ask_file(調整與銷除分錄底稿單身檔)
#  DELETE FROM ask_file 
#        WHERE ask00=g_aaz641   #FUN-5A0020   #FUN-920067 mod
#          AND ask01 IN (SELECT asj01 FROM asj_file 
#                         WHERE asj00=g_aaz641 AND asj05=tm.asa01   #FUN-5A0020  #FUN-920067 mod
#                           AND asj06=tm.asa02 AND asj07=tm.asa03
#                           AND asj03=tm.yy AND asj04 = tm.em   #FUN-970046 mod
#                           AND (asj21=tm.ver OR asj21=g_em)    #MOD-930210 add
#                           AND asj08='2')
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err3("del","ask_file",g_aaz641,"",SQLCA.sqlcode,"","del ask_file",1)  #No.FUN-660123    #FUN-920067 mod
#     LET g_success = 'N' 
#     RETURN 
#  END IF 
#
#  #-->delete asj_file
#  #-->delete asj_file(調整與銷除分錄底稿單頭檔)
#  DELETE FROM asj_file 
#        WHERE asj00=g_aaz641   #FUN-5A0020   #FUN-920067  mod
#          AND asj05=tm.asa01 AND asj06=tm.asa02 AND asj07=tm.asa03
#          AND asj03=tm.yy AND asj04 = tm.em   #FUN-970046
#          AND (asj21=tm.ver OR asj21=g_em)    #MOD-930210 add
#          AND asj08='2'
#  IF SQLCA.sqlcode THEN 
#     CALL cl_err3("del","asj_file",tm.asa03,"",SQLCA.sqlcode,"","del asj_file",1)  #No.FUN-660123 
#     LET g_success = 'N' 
#     RETURN 
#  END IF 
#FUN-B50001--mark--end
END FUNCTION
 
#FUN-B50001----mark--str----------------  
#FUNCTION p001_modi()   #產生調整分錄
#DEFINE l_ass09_o    LIKE ass_file.ass09,             #期別
#       l_asr07_m    LIKE asr_file.asr07,             #FUN-960003 add
#       l_ass09_o1   LIKE ass_file.ass09,             #期別  #FUN-930144
#       l_asr07_m1   LIKE asr_file.asr07,             #FUN-960003 add
#       l_ass07_o    LIKE ass_file.ass07,             #異動碼值
#       l_ass07_o1   LIKE ass_file.ass07,             #異動碼值  #FUN-930144 
#       l_asr07_o    LIKE asr_file.asr07,             #期別   #FUN-760053 add
#       l_cnt        LIKE type_file.num5,             #FUN-760053 add
#       l_sql,l_sql1 STRING,                          #FUN-5A0118        
#       i,g_no       LIKE type_file.num5              #No.FUN-680098   SMALLINT  
#DEFINE l_asg08      LIKE asg_file.asg08              #FUN-920067 add
#DEFINE l_asq09_asg05      LIKE asg_file.asg05              #FUN-920067 add  
#DEFINE l_asq10_asg05      LIKE asg_file.asg05              #FUN-920067
#DEFINE l_ass10_ass11_sum  LIKE ass_file.ass10  #FUN-920167
#DEFINE l_i                LIKE type_file.num5  #FUN-920167 
#DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
#DEFINE l_asq01            STRING  #FUN-950111
#DEFINE l_asq02            STRING  #FUN-950111
#
#   #建立TempTable以便處理科目為MISC的資料
#   DROP TABLE p001_tmp
#   CREATE TEMP TABLE p001_tmp(
#      asr06    SMALLINT,
#      asr07    SMALLINT,
#      asr05    VARCHAR(24),
#      asr02    VARCHAR(10),
#      asr04    VARCHAR(10),
#      asr08    DECIMAL(20,6),
#      asr12    VARCHAR(4),       #FUN-A30079
#      affil    VARCHAR(15),
#      dc       VARCHAR(1),
#      flag_r   VARCHAR(1))        #要不要經過持股比例的計算
#
##--TQC-AA0098 mark--
###--FUN-A60038 start---
##   DROP TABLE p001_ask_tmp
##   CREATE TEMP TABLE p001_ask_tmp(
##      ask03    VARCHAR(24),
##      ask06    VARCHAR(1),
##      ask07    DECIMAL(20,6))
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
#   LET l_sql = "INSERT INTO p001_ask_tmp VALUES(?,?,?)" 
#   PREPARE insert_ask_prep FROM l_sql
#   #IF STATUS THEN
#   IF SQLCA.SQLCODE THEN  #FUN-A80130
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF
##--FUN-A60038 end------
#
#   LET l_sql1=
#   #"SELECT asa01,asa02,asa03,asa03 FROM asa_file ",     #MOD-A60056 mark
#    "SELECT asa01,asa02,asa03 FROM asa_file ",           #MOD-A60056
#    " WHERE asa01='",tm.asa01,"'",
#    #AND asa02='",tm.asa02,"' ",      #FUN-A30079 mark 
#    #"   AND asa03='",tm.asa03,"' ",  #FUN-A30079 mark
##--FUN-A30064 start--
#    " UNION ",
#   #"SELECT asb01,asb04,asb05,asa03 ",                   #MOD-A60056 mark
#    "SELECT asb01,asb04,asb05 ",                         #MOD-A60056
#    "  FROM asb_file,asa_file ",
#    " WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
#    "   AND asa01='",tm.asa01,"'"
#   #"   AND asa02='",tm.asa02,"' ",   #FUN-A30079 mark
#   #"   AND asa03='",tm.asa03,"' "    #FUN-A30079 mark
##--FUN-A30064 end--
#
#   PREPARE p001_asa_p1 FROM l_sql1
#	   DECLARE p001_asa_c1 CURSOR FOR p001_asa_p1
#
#   LET g_no = 1
#   FOREACH p001_asa_c1 INTO g_asa[g_no].*
#      IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y'                                                      
#      END IF  
#      IF SQLCA.SQLCODE THEN
#         LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03
#         CALL s_errmsg('asa01,asa02,asa03',g_showmsg,'for_asa_c1:',STATUS,1)   #NO.FUN-710023
#         LET g_success = 'N'
#         CONTINUE FOREACH                               #NO.FUN-710023 
#      END IF
#      LET g_no=g_no+1
#   END FOREACH
#   IF g_totsuccess="N" THEN LET g_success="N" END IF     #NO.FUN-710023 add
#   LET g_no=g_no-1
#
#   INITIALIZE g_asj.* TO NULL
#   INITIALIZE g_ask.* TO NULL
#
#   FOR i =1 TO g_no
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y'                                                      
#     END IF 
#
##FUN-960003 ---配合agli003己開放非股本資料也能設為MISC對沖
##1.先抓來源會科，如果是MISC時，則來源為ast_file，
##接著處理對沖科目，如果亦為MISC則來源為asu_file
##其它狀況可能會一對一 ，一對多，多對一，多對多，所以在程式上要配合
##如果一對多時，asq<->asu, 一對一 asq<->asq, 多對一 ast<->asq, 多對多 ast<->asu
##2.資料來源又可分為asr_file,ass_file,依asq15,asq17決定
#
#     DECLARE p001_asq_cs1 CURSOR FOR
#        SELECT *
#          FROM asq_file 
#        # WHERE asq00=g_aaz641         #上層帳別   #FUN-920067  #FUN-A30079
#        #   AND asq13=g_asa[i].asa01   #族群 #FUN-930117        #FUN-A30079 mark
#          WHERE asq13=g_asa[i].asa01   #族群 #FUN-930117        #FUN-A30079 mod
#           AND asq09=g_asa[i].asa02   #來源公司               
#           AND asqacti='Y'            #有效的資料
#         ORDER BY asq12,asq10,asq01,asq02,asq03,asq04
#     FOREACH p001_asq_cs1 INTO g_asq.*
#     IF g_asq.asq16 <> tm.asa02 THEN CONTINUE FOREACH END IF  #FUN-A30079 合併主體= 目前輸入的上層公司才進行沖銷分錄
#
#     LET l_asq01 = g_asq.asq01   #FUN-960003 
#     LET l_asq02 = g_asq.asq02   #FUN-960003
#     LET l_asq01 = l_asq01.substring(1,4)  #FUN-960003 
#     LET l_asq02 = l_asq02.substring(1,4)  #FUN-960003
#    
#     #--FUN-920067 start-- 抓出下層公司asq10在agli009中設定的關係人異動碼值--
#     #SELECT asg08 INTO l_asg08  
#     SELECT asg08 INTO g_asg08     #FUN-A90006
#       FROM asg_file
#      #WHERE asg01 = g_asq.asq10
#      WHERE asg01 = g_asq.asq09    #FUN-A90026
#         #--FUN-A30079 mark--
#         #非上層公司不處理 MISC
#         #IF g_asa[i].asa02<>tm.asa02 THEN
#         #    CONTINUE FOR
#         #ELSE
#         #--FUN-A30079 mark
##              CALL p001_modi_asq_misc(l_asq01,l_asq02,g_asq.asq15,i)  
#              CALL p001_modi_asq_misc(l_asq01,l_asq02,g_asq.asq15,g_asq.asq17,i)    #FUN-A80137
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
#FUNCTION p001_ins_asj()
#DEFINE li_result  LIKE type_file.num5     #No.FUN-560060        #No.FUN-680098 SMALLINT
#
#    INITIALIZE g_asj.* TO NULL
#
#    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
#     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
#    IF SQLCA.sqlcode THEN 
#       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
#       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
#       RETURN 
#    END IF
#    LET g_asj.asj00  = g_aaz641      #帳別      #FUN-5A0020   #FUN-920067 mod
#    LET g_asj.asj01  = tm.gl         #傳票編號
#    LET g_asj.asj02  = g_edate       #單據日期
#    LET g_asj.asj03  = g_yy          #調整年度  #FUN-770069 mod
#    LET g_asj.asj04  = g_mm          #調整月份  #FUN-770069 mod
#    LET g_asj.asj05  = tm.asa01      #族群編號
#    LET g_asj.asj06  = tm.asa02      #上層公司編號
#    LET g_asj.asj07  = tm.asa03      #上層帳別
#    LET g_asj.asj08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
#    LET g_asj.asj09  = 'N'           #換匯差額調整否    #MOD-A60080
#    LET g_asj.asjconf= 'Y'           #確認碼
#    LET g_asj.asjuser= g_user        #資料所有者
#    LET g_asj.asjgrup= g_grup        #資料所有群
#    LET g_asj.asjdate= g_today       #最近修改日
#    LET g_asj.asj21  = tm.ver        #版本      #FUN-750078 add
#    LET g_asj.asj081 = '1'           #內部交易 (1.內部交易 2.未實現損益  3.攤銷)  #FUN-A90026
#
#    CALL s_auto_assign_no("agl",g_asj.asj01,g_asj.asj02,"A",
#                          "asj_file","asj01",g_dbs,"2",g_aaz641)   #FUN-5A0020      #FUN-920067 mod
#    RETURNING li_result,g_asj.asj01
#    DISPLAY g_asj.asj01
#    IF g_success='N' THEN 
#        LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate  
#        CALL s_errmsg('asj00,asj01,asj02',g_showmsg,g_asj.asj01,'mfg-059',1)         #NO.FUN-710023 
#        RETURN 
#    END IF
#
#    INSERT INTO asj_file VALUES(g_asj.*)
#    IF SQLCA.sqlcode THEN 
#       LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate
#       CALL s_errmsg('asj00,asj01,asj02 ',g_showmsg,'ins asj',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
#       RETURN 
#    END IF
#
#END FUNCTION
#
#FUNCTION p001_ins_ask1()
#DEFINE l_asg06_asq16   LIKE asg_file.asg06   #FUN-A30079
#DEFINE l_aag04         LIKE aag_file.aag04   #FUN-A30079
#DEFINE l_rate          LIKE ase_file.ase05   #FUN-A30079   #各公司與合併主體公司匯率
#DEFINE l_cut           LIKE type_file.num5   #FUN-A30079
#
#   INITIALIZE g_ask.* TO NULL
# 
#   LET g_ask.ask00=g_aaz641        #帳別   #FUN-920067 mod
#   LET g_ask.ask01=g_asj.asj01     #傳票編號   
#
#   SELECT MAX(ask02)+1 INTO g_ask.ask02 
#     FROM ask_file 
#    WHERE ask01=g_ask.ask01
#      AND ask00=g_ask.ask00  #FUN-760053
#   IF g_ask.ask02 IS NULL THEN LET g_ask.ask02 = 1 END IF   #項次
#   LET g_ask.ask03=g_asr.asr05                              #科目
#   LET g_ask.ask04=' '                                      #摘要
#   LET g_ask.ask05=g_affil                                  #關係人   #FUN-760053 mod
#   IF g_asr.asr08 < 0 THEN 
#      IF g_dc='1' THEN LET g_dc='2' ELSE LET g_dc='1' END IF
#   END IF
#   LET g_ask.ask06=g_dc                                     #借貸別
#   LET l_rate = 1   #FUN-A60038
#   IF g_asq.asq03='N' OR (g_asq.asq03='Y' AND g_rate=0) THEN
#      LET g_ask.ask07=g_asr.asr08                           #金額
#   ELSE
#      IF g_flag_r='Y' THEN
#         LET g_ask.ask07=g_asr.asr08*(1-g_rate)          #金額
#         #-FUN-A30079 start--
#         IF g_ask.ask07 > 0 THEN
#             LET g_ask.ask06 = '1'
#         ELSE
#             LET g_ask.ask06 = '2'
#         END IF
#         #--FUN-A30079 end---
#      ELSE
#         LET g_ask.ask07=g_asr.asr08                        #金額
#      END IF
#   END IF
#   #------------FUN-A30079 start------------------
#   #原本都是以tm.asa02為上層公司寫入對沖分錄
#   #改以"合併主體(asq16)"寫入對沖分錄上層公司(asj06),
#   #對沖金額(ask07)的值原本是以上層公司的幣別計算
#   #改以合併主體幣別
#   #(asr08,asr09為捲算過後的上層公司記帳幣金額不可直接拿來使用)
#   #當要產生對沖分錄時，tm.asa02取asq_file的值(asq16 = tm.asa02)再進行對沖產生
#   #並且要把對沖金額換算為合併主體公司記帳幣，才能算出差額科目金額
#   #一一將對沖的科目寫入分錄之後(要換算成合併主體幣別)，再計算差額額目(同一組分錄借-貸)
# 
#   SELECT asg06 INTO l_asg06_asq16 
#     FROM asg_file
#    WHERE asg01 = g_asq.asq16   #合併主體幣別
#  
#   #將來源/目的公司的幣別和合併主體幣別做比較
#   #幣別相同者不用換，不相同時將幣別換成合併主體幣別and金額
#   LET l_rate = 1  #FUN-A60038
#   #IF g_asq.asq14 = 'N' THEN    #股本類科目不需要進行匯率轉換,從餘額檔取時就己經是換算為上層公司幣別的金額了  #FUN-A40026 mark  #FUN-A60038 cancel mark #FUN-A60099
##------FUN-A90026 mark---------
##       IF g_asr.asr12 != l_asg06_asq16 THEN 
##           SELECT aag04 INTO l_aag04
##            FROM aag_file
##            WHERE aag00=g_aaz641
##              AND aag01=g_asr.asr05
##           #依科目性質來判斷取"現時"或"平均"匯率
##           IF l_aag04 = '1' THEN   
##               CALL p001_getrate('1',g_asj.asj03,g_asj.asj04,
##                                 g_asr.asr12,l_asg06_asq16)  
##               RETURNING l_rate
##           ELSE
##               #--FUN-A90006--與合併主體幣別不相同時，採平均法算法時
##               #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
##               #ex.處理3月份沖銷金額= 1月記帳(ask07) x 匯率 + 2月記帳(ask07) X 2月匯率 + 3月記帳(ask07) X 3月匯率
##               CALL p001_ins_ask1_chg(g_asr.asr12,l_asg06_asq16) RETURNING g_ask.ask07
##               #CALL p001_getrate('3',g_asj.asj03,g_asj.asj04,
##               #                 g_asr.asr12,l_asg06_asq16)
##               #RETURNING l_rate
##               #--FUN-A90006 end---
##           END IF
##           IF cl_null(l_rate) THEN LET l_rate = 1 END IF
##       ELSE
##           LET l_rate = 1
##       END IF
##   #END IF  #FUN-A40026  mark #FUN-A60038 cancel mark  #FUN-A60099
##
##   LET g_ask.ask07 = g_ask.ask07 * l_rate
##---FUN-A90026 mark-------------------------
#
#   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg06_asq16
#   IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#   LET g_ask.ask07=cl_digcut(g_ask.ask07,l_cut)
#   #------------FUN-A30079 end ------------------
#   IF g_ask.ask07<0 THEN LET g_ask.ask07=g_ask.ask07*-1 END IF
#   IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF   #FUN-760053 add
#   IF g_ask.ask07 != 0 THEN   #MOD-890130 add
#      INSERT INTO ask_file VALUES (g_ask.*)
#      IF SQLCA.sqlcode THEN 
#         LET g_showmsg=g_asj.asj07,"/",g_asj.asj01                                  #NO.FUN-710023      
#         CALL s_errmsg('ask00,ask01',g_showmsg ,'ins ask',SQLCA.sqlcode,1)          #NO.FUN-710023
#         LET g_success = 'N' 
#         RETURN 
#      END IF
#      #----FUN-A60038 start--
#      LET l_aag04 = ''
#      SELECT aag04 INTO l_aag04
#        FROM aag_file
#       WHERE aag00 = g_aaz641
#         AND aag01 = g_ask.ask03
#      IF l_aag04 = '2' THEN  #FUN-A60060
#           EXECUTE insert_ask_prep USING g_ask.ask03,g_ask.ask06,g_ask.ask07
#                                         
#      END IF 
#      #---FUN-A60038 end-------
#   END IF                     #MOD-890130 add
#
#END FUNCTION
#
#FUNCTION p001_ins_ask2()   #差異科目
#DEFINE l_sumd  LIKE ask_file.ask07,
#       l_sumc  LIKE ask_file.ask07,
#       l_sumdc LIKE ask_file.ask07
#DEFINE l_aag04 LIKE aag_file.aag04  #FUN-A60060
#
#   INITIALIZE g_ask.* TO NULL
#
#   SELECT SUM(ask07) INTO l_sumd FROM ask_file
#    WHERE ask00=g_aaz641 AND ask01=g_asj.asj01 AND ask06='1'   #借方合計   #FUN-920067
#   IF cl_null(l_sumd) THEN LET l_sumd = 0 END IF   #FUN-960096
#   SELECT SUM(ask07) INTO l_sumc FROM ask_file
#    WHERE ask00=g_aaz641 AND ask01=g_asj.asj01 AND ask06='2'   #貸方合計  #FUN-920067
#   IF cl_null(l_sumc) THEN LET l_sumc = 0 END IF   #FUN-960003 
#   LET l_sumdc=l_sumd-l_sumc   
#   IF l_sumdc = 0 THEN RETURN END IF
#
#   LET g_ask.ask00=g_aaz641     #帳別   #FUN-920067 mod
#   LET g_ask.ask01=g_asj.asj01     #傳票編號   
#
#   SELECT MAX(ask02)+1 INTO g_ask.ask02 
#     FROM ask_file
#    WHERE ask01=g_ask.ask01
#      AND ask00=g_ask.ask00  #FUN-760053
#   IF cl_null(g_ask.ask02)  THEN LET g_ask.ask02 = 1 END IF
#   LET g_ask.ask03=g_asq.asq04     #科目   #FUN-750078 modify
#   LET g_ask.ask04=' '             #摘要
#   LET g_ask.ask05=' '             #關係人
#   IF l_sumdc >0 THEN              #借貸別
#      LET g_ask.ask06='2' 
#   ELSE 
#      LET g_ask.ask06='1' 
#   END IF
#   LET g_ask.ask07=l_sumdc         #金額
#   IF g_ask.ask07<0 THEN LET g_ask.ask07=g_ask.ask07*-1 END IF
#   IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF   #FUN-760053 add
#   IF g_ask.ask07 != 0 THEN   #MOD-890130 add
#      INSERT INTO ask_file VALUES (g_ask.*)
#      IF SQLCA.sqlcode THEN 
#         LET g_showmsg=g_asj.asj07,"/",g_asj.asj01                                  #NO.FUN-710023      
#         CALL s_errmsg('ask00,ask01',g_showmsg ,'ins ask',SQLCA.sqlcode,1)          #NO.FUN-710023
#         LET g_success = 'N' 
#         RETURN 
#      END IF
#      #----FUN-A60038 start--
#      LET l_aag04 = ''
#      SELECT aag04 INTO l_aag04
#        FROM aag_file
#       WHERE aag00 = g_aaz641
#         AND aag01 = g_ask.ask03
#      IF l_aag04 = '2' THEN
#           EXECUTE insert_ask_prep USING g_ask.ask03,
#                                         g_ask.ask06,g_ask.ask07
#      END IF 
#      #---FUN-A60038 end-------
#   END IF                     #MOD-890130 add
#
#END FUNCTION
# 
##----FUN-A60038 start--
#FUNCTION p001_modi_adj()
#DEFINE l_ask03   LIKE ask_file.ask03
#DEFINE l_ask06   LIKE ask_file.ask06
#DEFINE l_ask07   LIKE ask_file.ask07
#DEFINE l_aag06   LIKE aag_file.aag06
#DEFINE li_result LIKE type_file.num5     
#DEFINE l_cnt     LIKE type_file.num5
#
#   INITIALIZE g_asj.* TO NULL
#   INITIALIZE g_ask.* TO NULL
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
#    LET g_asj.asj00  = g_aaz641      #帳別      
#    LET g_asj.asj01  = tm.gl         #傳票編號
#    LET g_asj.asj02  = g_edate       #單據日期
#    LET g_asj.asj03  = g_yy          #調整年度 
#    LET g_asj.asj04  = g_mm          #調整月份 
#    LET g_asj.asj05  = tm.asa01      #族群編號
#    LET g_asj.asj06  = tm.asa02      #上層公司編號
#    LET g_asj.asj07  = tm.asa03      #上層帳別
#    LET g_asj.asj08  = '2'           #來源碼
#    LET g_asj.asj09  = 'N'           #換匯差額調整否    
#    LET g_asj.asjconf= 'Y'           #確認碼
#    LET g_asj.asjuser= g_user        #資料所有者
#    LET g_asj.asjgrup= g_grup        #資料所有群
#    LET g_asj.asjdate= g_today       #最近修改日
#    LET g_asj.asj21  = tm.ver        #版本   
#    LET g_asj.asj081 = '1'           #FUN-A90026
#
#    CALL s_auto_assign_no("agl",g_asj.asj01,g_asj.asj02,"A",
#                          "asj_file","asj01",g_dbs,"2",g_aaz641) 
#    RETURNING li_result,g_asj.asj01
#    DISPLAY g_asj.asj01
#    IF g_success='N' THEN 
#        LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate  
#        CALL s_errmsg('asj00,asj01,asj02',g_showmsg,g_asj.asj01,'mfg-059',1)         #NO.FUN-710023 
#        RETURN 
#    END IF
#
#   #--取出此上層公司的調整分錄非換匯者 ----
#     DECLARE p001_ask_cs CURSOR FOR
#        SELECT ask03,ask06,ask07
#          FROM p001_ask_tmp
#     LET l_cnt = 0
#     FOREACH p001_ask_cs INTO l_ask03,l_ask06,l_ask07
#        IF SQLCA.sqlcode THEN 
#           LET g_showmsg= l_ask03,"/",l_ask06,"/"
#           CALL s_errmsg('ask03,ask06',g_showmsg,'p001_ask_cs',SQLCA.sqlcode,1) 
#           LET g_success = 'N'
#           CONTINUE FOREACH 
#        END IF
#        LET l_cnt = l_cnt + 1
#
###. 取沖銷調整分錄中換匯差額否[asj09<>'Y']者的分錄
##1. 當沖銷銷調整分錄中有借方科目[ask06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##2. 當沖銷銷調整分錄中有貸方科目[ask06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##           C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##3. 當沖銷銷調整分錄中有借方科目[ask06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
##   則切一筆本期損益沖銷分錄
##   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
##           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##4. 當沖銷銷調整分錄中有貸方科目[ask06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
##   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
##          C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#
#      LET g_ask.ask00=g_aaz641                                                  
#      LET g_ask.ask01=g_asj.asj01                                               
#
#      CASE 
#          WHEN l_ask06 = '1'
#               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#                WHERE ask01=g_ask.ask01                                                  
#                  AND ask00=g_ask.ask00                                                  
#               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#               LET g_ask.ask03=g_aaz114
#               LET g_ask.ask04=' '                      #摘要                         
#               LET g_ask.ask06='1'                      #借貸別                       
#               LET g_ask.ask07= l_ask07
#               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#               IF g_ask.ask07 != 0 THEN                                                  
#                  INSERT INTO ask_file VALUES (g_ask.*)                                  
#               END IF                                                                    
#
#               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#                WHERE ask01=g_ask.ask01                                                  
#                  AND ask00=g_ask.ask00                                                  
#               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#               LET g_ask.ask03=g_aaz113
#               LET g_ask.ask04=' '                      #摘要                         
#               LET g_ask.ask06='2'                      #借貸別                       
#               LET g_ask.ask07= l_ask07
#               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#               IF g_ask.ask07 != 0 THEN                                                  
#                  INSERT INTO ask_file VALUES (g_ask.*)                                  
#               END IF                                                                    
#          WHEN l_ask06 = '2'
#               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#                WHERE ask01=g_ask.ask01                                                  
#                  AND ask00=g_ask.ask00                                                  
#               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#               LET g_ask.ask03=g_aaz113
#               LET g_ask.ask04=' '                      #摘要                         
#               LET g_ask.ask06='1'                      #借貸別                       
#               LET g_ask.ask07= l_ask07
#               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#               IF g_ask.ask07 != 0 THEN                                                  
#                  INSERT INTO ask_file VALUES (g_ask.*)                                  
#               END IF                                                                    
#
#               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#                WHERE ask01=g_ask.ask01                                                  
#                  AND ask00=g_ask.ask00                                                  
#               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#               LET g_ask.ask03=g_aaz114
#               LET g_ask.ask04=' '                      #摘要                         
#               LET g_ask.ask06='2'                      #借貸別                       
#               LET g_ask.ask07= l_ask07
#               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#               IF g_ask.ask07 != 0 THEN                                                  
#                  INSERT INTO ask_file VALUES (g_ask.*)                                  
#               END IF                                                                    
#      END CASE
#   END FOREACH
#
#   #--先寫完單身再寫單頭，避免單身無值
#   IF l_cnt > 0 THEN
#       INSERT INTO asj_file VALUES(g_asj.*)
#       IF SQLCA.sqlcode THEN 
#          LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate
#          CALL s_errmsg('asj00,asj01,asj02 ',g_showmsg,'ins asj',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
#          RETURN 
#       END IF
#       IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF   
#   END IF
#END FUNCTION 
##-------------FUN-A60038 end---------------------
#FUNCTION p001_adj()
#DEFINE l_aaz86        LIKE aaz_file.aaz86   #FUN-5A0118  #外幣換算損益
#DEFINE l_aaz87        LIKE aaz_file.aaz87   #FUN-5A0118  #換算調整數
#DEFINE l_flag         LIKE type_file.chr1   #FUN-770069 add 10/19  #判斷是不是第一次進入迴圈
#DEFINE l_asg08_asq10  LIKE asg_file.asg08   #FUN-960096
#DEFINE l_asa09        LIKE asa_file.asa09   #FUN-980095
#DEFINE l_aag04        LIKE aag_file.aag04   #FUN-980095
#DEFINE l_amt_aaz113   LIKE asr_file.asr08   #FUN-990020                             
#DEFINE l_amt_aaz114   LIKE asr_file.asr08   #FUN-990020                             
#DEFINE l_aaz113       LIKE aaz_file.aaz113  #FUN-990020                             
#DEFINE l_aaz114       LIKE aaz_file.aaz114  #FUN-990020                             
#DEFINE l_amt_cnt      LIKE asr_file.asr08   #FUN-990020  
#DEFINE l_amt_tot      LIKE asr_file.asr08   #FUN-9B0017
#DEFINE l_amt          LIKE asr_file.asr08   #FUN-9B0017
#DEFINE l_asr19        LIKE asr_file.asr19   #FUN-A30079  
#DEFINE l_asg06_asq16  LIKE asq_file.asq16   #FUN-A30079
#DEFINE l_cut          LIKE type_file.num5   #FUN-A30079
#DEFINE l_cnt          LIKE type_file.num5   #FUN-A80125
#DEFINE l_sql          STRING                #FUN-A90036
#
##--TQC-AA0098 add
#   DROP TABLE p001_ask_tmp
#   CREATE TEMP TABLE p001_ask_tmp(
#      ask03    VARCHAR(24),
#      ask06    VARCHAR(1),
#      ask07    DECIMAL(20,6))
##--TQC-AA0098 add
#
##--FUN-A90036 start--
#   DROP TABLE p001_adj_tmp
#   CREATE TEMP TABLE p001_adj_tmp(
#      ask03    VARCHAR(24),
#      ask05    VARCHAR(15),
#      ask06    VARCHAR(1),
#      ask07    DECIMAL(20,6),
#      ask071    DECIMAL(20,6))
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
#   SELECT asg06 INTO l_asg06_asq16
#     FROM asg_file
#    WHERE asg01 = g_asq.asq16
#   #--FUN-A30079 end---
#
#   LET l_amt_cnt = 0    #MOD-A70083
#
#   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
#   RETURNING g_bdate,g_edate
#   LET g_yy=tm.yy   #FUN-770069 add
#   LET g_mm=tm.em   #FUN-770069 add
#
#   LET g_asr04 = ''  #FUN-770069 add 10/19
#   LET g_amt = 0  #FUN-5A0118
#   LET l_flag = "Y"  #FUN-770069 add 10/19
#
#   SELECT asa09 INTO l_asa09 FROM asa_file                                     
#    WHERE asa01= tm.asa01                                                      
#     AND asa02= tm.asa02                                                      
#     AND asa03= tm.asa03                                                      
#  IF l_asa09 = 'Y' THEN  
#     LET g_dbs_asg03 =  s_dbstring(g_dbs_asg03)                              
#  ELSE                                                                        
#     LET g_dbs_asg03 =  s_dbstring(g_dbs)                                    
#  END IF                      
#
#  INITIALIZE g_asj.* TO NULL  #TQC-AA0098
#  INITIALIZE g_ask.* TO NULL  #TQC-AA0098
#
#  #將累積換算調整數拆開依各子公司列示
#
#  #--FUN-990020 add--兌換損益----                                                   
#  LET g_sql =                                                                
#      #"SELECT asr04,SUM(asr08-asr09)",                                       
#      "SELECT asr04,SUM(asr09-asr08)",   #FUN-A60099                                       
#      "  FROM asr_file,",g_dbs_asg03,"aag_file",                             
#      " WHERE asr00='",g_aaz641,"'",                                         
#      "   AND asr01='",tm.asa01,"'",                                         
#      "   AND asr02='",tm.asa02,"'",                                         
#      "   AND asr17='",tm.ver,"'",                                           
#      "   AND asr06='",tm.yy,"'",                                            
#      "   AND aag00 ='",g_aaz641,"'",                                        
#      "   AND asr05 = aag01",                                                
#      "   AND aag04 != '1'",                                                 
#      "   AND asr05 != '",l_aaz113,"'",                                      
#      #"   AND asr07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",   #FUN-A90006 mark
#      "   AND asr07 = '",tm.em,"'",                     #FUN-A90006 mod
#      " GROUP BY asr04",                                                     
#      " ORDER BY asr04"                                                      
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
#  PREPARE p001_adj_p2 FROM g_sql                                              
#  DECLARE p001_adj_c2 CURSOR FOR p001_adj_p2                                  
#  LET l_cnt = 0   #FUN-A80125
#  FOREACH p001_adj_c2 INTO g_asr04,l_amt_aaz113                               
#     IF SQLCA.sqlcode THEN                                                    
#        LET g_asr04 = ' '                                                     
#        LET l_amt_aaz113   = 0                                                
#        CONTINUE FOREACH                                
#     END IF                                                                   
#
#    #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#    IF l_flag = "Y" THEN   #FUN-770069 add 10/19
#       CALL p001_ins_asj()
#       IF g_success = 'N' THEN RETURN  END IF
#       UPDATE asj_file set asj09='Y' 
#        WHERE asj01=g_asj.asj01
#          AND asj00=g_aaz641  #FUN-760053   #FUN-920067 mod
#       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#          CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1) 
#          RETURN 
#       END IF
#       LET l_flag = "N"
#    END IF   #FUN-770069 add 10/19
#
##--FUN-990020 start-----兌換損益aaz86分錄----                                     
#    #SELECT SUM(asr08-asr09)                                                
#    SELECT SUM(asr09-asr08)  #FUN-A60099                                               
#      INTO l_amt_aaz114                                                    
#      FROM asr_file                                                        
#     WHERE asr00=g_aaz641                                                  
#       AND asr01=tm.asa01                                                  
#       AND asr02=tm.asa02                                                  
#       AND asr04=g_asr04                                                   
#       AND asr17=tm.ver                                                    
#       AND asr06=tm.yy                                                     
#       AND asr05 =l_aaz114                                                 
#       AND asr07 = tm.em                                                   
#
#    LET l_amt_cnt = l_amt_aaz113 - l_amt_aaz114                               
#         
#    #-FUN-A90006 ---start
#    IF l_amt_cnt <> 0 THEN
#        #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#        IF l_flag = "Y" THEN   
#           CALL p001_ins_asj()
#           IF g_success = 'N' THEN RETURN  END IF
#           UPDATE asj_file set asj09='Y'
#            WHERE asj01=g_asj.asj01
#              AND asj00=g_aaz641  #FUN-760053   #FUN-920067 mod
#           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1)
#              RETURN
#           END IF
#           LET l_flag = "N"
#        END IF 
#    END IF
#    #--FUN-A90006 -- end
#                                                                     
#      LET g_ask.ask00=g_aaz641                                                  
#      LET g_ask.ask01=g_asj.asj01                                               
#      SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#       WHERE ask01=g_ask.ask01                                                  
#         AND ask00=g_ask.ask00                                                  
#      IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#      LET g_ask.ask03=l_aaz114                    #科目  #FUN-A30079 mod
#      #LET g_ask.ask03=l_aaz86                    #科目  #FUN-A30079 mark                   
#      LET g_ask.ask04=' '                         #摘要                         
#      SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                       
#       WHERE asg01=g_asr04                                                      
#                                                                                
#      IF l_amt_cnt >0 THEN                                                      
#         LET g_ask.ask06='2'                      #借貸別                       
#         LET g_ask.ask07= l_amt_cnt               #金額                         
#      ELSE                                                                      
#         LET g_ask.ask06='1'                      #借貸別                       
#         LET g_ask.ask07= l_amt_cnt*-1            #金額                         
#      END IF                                                                    
#      IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#      IF g_ask.ask07 != 0 THEN                                                  
#         INSERT INTO ask_file VALUES (g_ask.*)                                  
#      END IF                                                                    
#                                                                                
#      #--寫入一筆aaz87為對向科目的分錄和aaz86為一組---                          
#      LET g_ask.ask00=g_aaz641                                                  
#      LET g_ask.ask01=g_asj.asj01                                               
#      SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#       WHERE ask01=g_ask.ask01                                                  AND ask00=g_ask.ask00                                                  
#                                                                                
#      IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#                                                                                
#      LET g_ask.ask03=l_aaz87                     #科目                         
#      LET g_ask.ask04=' '                         #摘要                         
#      SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                       
#       WHERE asg01=g_asr04 
#                                                     
#      #--FUN-A30079 start--
#      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg06_asq16
#      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#      LET g_ask.ask07=cl_digcut(g_ask.ask07,l_cut)
#      #--FUN-A30079 end--
#
#      IF l_amt_cnt >0 THEN                                                      
#         LET g_ask.ask06='1'                      #借貸別                       
#         LET g_ask.ask07= l_amt_cnt               #金額                         
#      ELSE                                                                      
#         LET g_ask.ask06='2'                      #借貸別                       
#         LET g_ask.ask07= l_amt_cnt*-1            #金額                         
#      END IF                                                                    
#      IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#      IF g_ask.ask07 != 0 THEN                                                  
#         INSERT INTO ask_file VALUES (g_ask.*)                               
#         LET l_cnt = l_cnt + 1   #FUN-A80125
#      END IF                                                                    
#   END FOREACH                                                                  
#
#   #---FUN-A80125 start--
#   IF l_cnt = 0 THEN
#       DELETE FROM asj_file where asj00 = g_aaz641 AND asj01 = g_asj.asj01
#       LET l_flag = 'Y'   #TQC-AA0098
#   END IF
#   #--FUN-A80125 end----
#
##--FUN-A30079 mark------         
##  #增加本期損益處理
##   LET g_sql =	　	　	　	　	　
##        #"SELECT asr04,SUM(asr15-asr16)*asr19 ",	　 #FUN-A30079 mark
##        "SELECT asr04,asr19,SUM(asr15-asr16)",  　
##        "  FROM asr_file,",g_dbs_asg03,"aag_file",	　
##        " WHERE asr00='",g_aaz641,"'",	　	　
##        "   AND asr01='",tm.asa01,"'",	　	　
##        "   AND asr02='",tm.asa02,"'",	　	　
##        "   AND asr17='",tm.ver,"'",	　	　
##        "   AND asr06='",tm.yy,"'",	　	　	　
##        "   AND aag00 ='",g_aaz641,"'",	　	　
##        "   AND asr05 = aag01",	　	　	　
##        #"   AND aag04 != '1'",	　	　	　
##        "   AND aag04 = '1'",   #FUN-A30079 mod
##        #"   AND asr07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
##        "   AND asr07 ='",tm.em,"'",  #FUN-A30079 
##        " GROUP BY asr04",	　	　	　	　
##        " ORDER BY asr04"	　	　	　	　
##   PREPARE p001_adj_p3 FROM g_sql	　	　	　
##   DECLARE p001_adj_c3 CURSOR FOR p001_adj_p3	　
##   LET l_amt_tot = 0   LET l_amt = 0	　	　
##   #FOREACH p001_adj_c3 INTO g_asr04,l_amt	#下層公司 / 下層公司功能幣別*匯率-->上層公司記賬幣
##   FOREACH p001_adj_c3 INTO g_asr04,l_asr19,l_amt  #FUN-A30079 mod
##      IF SQLCA.sqlcode THEN	　	　	　
##         LET g_asr04 = ' '	　	　	　	　
##         LET l_amt   = 0	　	　	　	　
##         CONTINUE FOREACH	　	　	　	　
##      END IF	　	　	　	　	　
##      LET l_amt_tot = l_amt_tot + l_amt	　	　
##   END FOREACH	　	　	　	　	　
##
##--系統自動產生的分錄共三組1.本期損益-BS科目/累換數(借貸) 2.本期損益(單向) 3.累換數(單向)
##   LET g_ask.ask00=g_aaz641	　	　	　
##   LET g_ask.ask01=g_asj.asj01	　	　	　
##   SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file
##    WHERE ask01=g_ask.ask01	　	　	　
##      AND ask00=g_ask.ask00	　	　	　
##   IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
##   LET g_ask.ask03=l_aaz86                     #科目
##   LET g_ask.ask04=' '                         #摘要
##   LET g_ask.ask05 = ' '                       #關系人
##   IF l_amt_cnt >0 THEN	　	　	　	　
##      LET g_ask.ask06='2'                      #借貸別
##      LET g_ask.ask07= l_amt_tot       #金額	　
##   ELSE	　	　	　	　	　
##      LET g_ask.ask06='1'                      #借貸別
##      LET g_ask.ask07= l_amt_tot*-1            #金額	　
##   END IF	　	　	　	　	　
##   IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF
##   IF g_ask.ask07 != 0 THEN	　	　	　
##      INSERT INTO ask_file VALUES (g_ask.*)	　
##   END IF	　	　	　	　	　
##--FUN-A30079 mark--------------
#
##--MOD-A70083 start--
#   IF l_amt_cnt = 0 THEN
#      IF l_flag = "Y" THEN   
#         CALL p001_ins_asj()
#         IF g_success = 'N' THEN RETURN  END IF
#         UPDATE asj_file set asj09='Y' 
#          WHERE asj01=g_asj.asj01
#            AND asj00=g_aaz641 
#         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#            CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1) 
#            RETURN 
#         END IF
#         LET l_flag = "N"
#      END IF  
#   END IF
##---MOD-A70083 end-----
#
#   LET g_sql =                                                                  
#       "SELECT asr04,SUM(asr08-asr09)",    #TQC-AA009                                        
#       #"SELECT asr04,SUM(asr09-asr08)",   #FUN-A90006                                        
#       "  FROM asr_file,",g_dbs_asg03,"aag_file" ,                              
#       " WHERE asr00='",g_aaz641,"'",                                           
#       "   AND asr01='",tm.asa01,"'",                                           
#       "   AND asr02='",tm.asa02,"'",                                           
#       "   AND asr17='",tm.ver,"'",                                             
#       "   AND asr06='",tm.yy,"'",                                              
#       "   AND asr07 ='",tm.em,"'",                                             
#       "   AND aag00 ='",g_aaz641,"'",                                          
#       "   AND asr05 = aag01",                                                  
#       "   AND aag04 = '1'",                                                    
#       " GROUP BY asr04",                                                       
#       " ORDER BY asr04"                                                        
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
#   PREPARE p001_adj_p1 FROM g_sql                                               
#   DECLARE p001_adj_c1 CURSOR FOR p001_adj_p1                                   
#   LET l_cnt = 0   #FUN-A80125
#   FOREACH p001_adj_c1 INTO g_asr04,g_amt                                       
#      IF SQLCA.sqlcode THEN                                                     LET g_asr04 = ' '                                                      
#         LET g_amt   = 0                                                        
#         CONTINUE FOREACH                                                       
#      END IF                                                                    
#      IF g_amt = 0 THEN                                                         
#         CONTINUE FOREACH                                                       
#      END IF                                                                    
#
##MOD-A40179---mark---start---
###---FUN-A30079 start--
##     SELECT asr19,SUM(asr15-asr16)
##       INTO l_asr19,l_amt_tot
##      FROM asr_file,aag_file   　
##      WHERE asr00=g_aaz641     　      　
##      AND asr01=tm.asa01       　      　
##      AND asr02=tm.asa02       　      　
##      AND asr04=g_asr04
##      AND asr06=tm.yy  　      　      　
##      AND aag00= g_aaz641      　      　
##      AND asr05= aag01 　      　      　
##      AND aag04 = '1'  　
##      AND asr07 =tm.em
##     GROUP BY asr04,asr19
##     LET l_amt_tot = l_amt_tot * l_asr19 
##     LET l_amt_tot=cl_digcut(l_amt_tot,l_cut)
###--FUN-A30079 end------
##MOD-A40179---mark---end---
#     #g_amt金額重新計算
##      LET g_amt = g_amt - l_amt_tot   #FUN-A30079 mark
#     #LET g_amt = l_amt_tot            #FUN-A30079   #累換數   #MOD-A40179 mark
#      LET g_ask.ask00=g_aaz641   #FUN-920067 mod
#      LET g_ask.ask01=g_asj.asj01
#      SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file 
#       WHERE ask01=g_ask.ask01
#         AND ask00=g_ask.ask00  #FUN-760053
#      IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
#      LET g_ask.ask03=l_aaz87                     #科目
#      LET g_ask.ask04=' '                         #摘要
#      SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                                                                   
#       WHERE asg01=g_asr04                                                                                                  
#      IF g_amt >0 THEN
#         LET g_ask.ask06='2'                      #借貸別
#         LET g_ask.ask07=g_amt                    #金額
#      ELSE
#         LET g_ask.ask06='1'                      #借貸別
#         LET g_ask.ask07=g_amt*-1                 #金額
#      END IF
#      IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF   #FUN-760053 add
#      IF g_ask.ask07 != 0 THEN   #MOD-890130 add
#         INSERT INTO ask_file VALUES (g_ask.*)
#         LET l_cnt = l_cnt + 1   #FUN-A80125
#         #先將資料寫TempTable裡,後續股本累換數使用
#         CALL p001_adj_tmp(g_ask.*)      #FUN-A90036
#      END IF                     #MOD-890130 add
#   END FOREACH   #FUN-770069 add 10/19
#   #---FUN-A80125 start--
#   IF l_cnt = 0 THEN
#       DELETE FROM asj_file where asj00 = g_aaz641 AND asj01 = g_asj.asj01
#   END IF
#   #--FUN-A80125 end----
#   CALL upd_asj()
#END FUNCTION 
#
##--FUN-A90036 start--
#FUNCTION p001_adj_tmp(p_ask)
#DEFINE p_ask  RECORD LIKE ask_file.*
#DEFINE l_ask  RECORD 
#              ask03    VARCHAR(24),
#              ask05    VARCHAR(15),               
#              ask06    VARCHAR(1),
#              ask07    DECIMAL(20,6),             
#              ask071    DECIMAL(20,6)             
#              END RECORD
#DEFINE l_x    LIKE type_file.num5
#
#   SELECT COUNT(*) INTO l_x FROM p001_adj_tmp
#    WHERE ask03 = p_ask.ask03
#      AND ask05 = p_ask.ask05
#
#   LET l_ask.ask03 = p_ask.ask03
#   LET l_ask.ask05 = p_ask.ask05
#   LET l_ask.ask06 = ''
#
#   IF l_x = 0 THEN
#      IF p_ask.ask06 = '1' THEN
#         LET l_ask.ask07 = p_ask.ask07
#         LET l_ask.ask071 = 0
#      ELSE
#         LET l_ask.ask07 =  0
#         LET l_ask.ask071 = p_ask.ask07
#      END IF
#      #EXECUTE insert_adj_prep USING l_ask.ask03,l_ask.ask05,l_ask.ask06,l_ask.ask07,l_ask.ask071 
#      EXECUTE insert_adj_prep USING l_ask.ask03,l_ask.ask05,p_ask.ask06,l_ask.ask07,l_ask.ask071    #TQC-AA0098
#   ELSE
#      SELECT * INTO l_ask.*  FROM  p001_adj_tmp
#       WHERE ask03 = p_ask.ask03
#         AND ask05 = p_ask.ask05
#
#      IF p_ask.ask06 = '1' THEN
#         LET l_ask.ask07 = l_ask.ask07 + p_ask.ask07
#      ELSE
#         LET l_ask.ask071 = l_ask.ask071 + p_ask.ask07
#      END IF
#
#      UPDATE p001_adj_tmp SET ask07  =  l_ask.ask07,
#                              ask071 =  l_ask.ask071,
#                              ask06 = p_ask.ask06    #TQC-AA0098
#       WHERE ask03 = p_ask.ask03
#         AND ask05 = p_ask.ask05
#   END IF
#
#END FUNCTION                                                                        
##--FUN-A90036 end---
#
#FUNCTION get_rate()#持股比率
#DEFINE l_asb07    LIKE asb_file.asb07,
#       l_asb08    LIKE asb_file.asb08,
#       l_asd07b   LIKE asd_file.asd07b,
#       l_asd08b   LIKE asd_file.asd08b,
#       l_count    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
#       l_sql      LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(600)
#       l_asg05    LIKE asg_file.asg05        #MOD-A70113 add
#
#    SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01=g_asq.asq10      #MOD-A70113 add
#    SELECT asb07,asb08 INTO l_asb07,l_asb08 FROM asb_file 
#     WHERE asb01=tm.asa01 AND asb02=tm.asa02 AND asb03=tm.asa03
#      #AND asb04=g_asq.asq10 AND asb05=g_asq.asq12   #FUN-760053 #下層公司/帳號    #MOD-A70113 mark
#       AND asb04=g_asq.asq10 AND asb05=l_asg05          #MOD-A70113 add
#    IF STATUS THEN LET g_rate=0 RETURN END IF
#    IF g_edate >= l_asb08 OR cl_null(l_asb08) THEN LET g_rate=l_asb07/100 RETURN END IF
#    
#    LET l_count=0
#    LET g_rate =0
#    LET l_sql="SELECT asd07b,asd08b  FROM asd_file ",
#              " WHERE asd01='",tm.asa01,"'",
#              "   AND asd02='",tm.asa02,"' AND asd03='",tm.asa03,"'",
#             #"   AND asd04b='",g_asq.asq10,"' AND asd05b='",g_asq.asq12,"'",  #MOD-940010 add  #MOD-A70113 mark
#              "   AND asd04b='",g_asq.asq10,"' AND asd05b='",l_asg05,"'",      #MOD-A70113 add 
#              " ORDER BY asd08b desc"  #MOD-940010 add
#    PREPARE p001_asd_p FROM l_sql
#    IF STATUS THEN 
#        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN     #NO.FUN-710023    
#    END IF
#    DECLARE p001_asd_c CURSOR FOR p001_asd_p
#
#    FOREACH p001_asd_c INTO l_asd07b,l_asd08b
#       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
#       LET l_count=l_count+1
#       IF g_edate>=l_asd08b THEN LET g_rate=l_asd07b/100 EXIT FOREACH END IF   #FUN-770069      10/19
#    END FOREACH       
#    IF l_count=0 THEN LET g_rate=0 RETURN END IF
#END FUNCTION
#   
#FUNCTION upd_asj()
#DEFINE l_sum_tot    LIKE ask_file.ask07
#
#    LET l_sum_tot=0
#    SELECT SUM(ask07) INTO l_sum_tot  FROM ask_file 
#     WHERE ask01=g_asj.asj01 AND ask06='1'
#       AND ask00=g_aaz641 #FUN-760053   #FUN-920067 mod
#    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
#    IF STATUS OR cl_null(l_sum_tot) THEN 
#       RETURN
#    END IF
#    UPDATE asj_file SET asj11 = l_sum_tot 
#     WHERE asj01=g_asj.asj01
#       AND asj00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#       RETURN
#    END IF
#
#    LET l_sum_tot=0
#    SELECT SUM(ask07) INTO l_sum_tot FROM ask_file 
#     WHERE ask01=g_asj.asj01 AND ask06='2'
#       AND ask00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
#    IF STATUS OR cl_null(l_sum_tot) THEN
#       RETURN
#    END IF
#    UPDATE asj_file SET asj12 = l_sum_tot 
#     WHERE asj01=g_asj.asj01
#       AND asj00=g_aaz641  #FUN-760053   #FUN-920067 mod
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#       RETURN
#    END IF
#END FUNCTION
#FUN-B50001--mark--end
#抓匯率
FUNCTION p001_getrate(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
DEFINE l_value LIKE ash_file.ash11,
       l_ase01 LIKE ase_file.ase01,
       l_ase02 LIKE ase_file.ase02,
       l_ase03 LIKE ase_file.ase03,
       l_ase04 LIKE ase_file.ase04,
       l_ase05 LIKE ase_file.ase05,    #FUN-770069 add
       l_ase06 LIKE ase_file.ase06,    #FUN-770069 add
       l_ase07 LIKE ase_file.ase07,    #FUN-770069 add
       l_rate  LIKE ase_file.ase05     #No.FUN-680098  DECIMAL(20,6)


   SELECT ase05,ase06,ase07 
     INTO l_ase05,l_ase06,l_ase07 
     FROM ase_file
    WHERE ase01=l_ase01
      AND ase02=(SELECT max(ase02) FROM ase_file
                  WHERE ase01 = l_ase01
                    AND ase02 <=l_ase02
                    AND ase03 = l_ase03
                    AND ase04 = l_ase04)
      AND ase03=l_ase03 
      AND ase04=l_ase04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_ase05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_ase06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_ase07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION
#---FUN-B70064 start---
FUNCTION p001_getrate3(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
DEFINE l_value LIKE ash_file.ash11,
       l_ase01 LIKE ase_file.ase01,
       l_ase02 LIKE ase_file.ase02,
       l_ase03 LIKE ase_file.ase03,
       l_ase04 LIKE ase_file.ase04,
       l_ase05 LIKE ase_file.ase05,    
       l_ase06 LIKE ase_file.ase06,   
       l_ase07 LIKE ase_file.ase07,  
       l_rate  LIKE ase_file.ase05  

   SELECT ase05,ase06,ase07 
     INTO l_ase05,l_ase06,l_ase07 
     FROM ase_file
    WHERE ase01=l_ase01
      AND ase02=l_ase02
      AND ase03=l_ase03 
      AND ase04=l_ase04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_ase05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_ase06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_ase07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION
#---FUN-B70064 end----------

#FUN-B50001---mark-----str------
##FUNCTION p001_modi_asq_misc(p_asq01,p_asq02,p_asq15,i)         #FUN-A80137 mark
#FUNCTION p001_modi_asq_misc(p_asq01,p_asq02,p_asq15,p_asq17,i)  #FUN-A80137
#DEFINE p_asq01   STRING
#DEFINE p_asq02   STRING
#DEFINE p_asq17   LIKE asq_file.asq17                 #FUN-A80137
#DEFINE p_asq15   LIKE asq_file.asq15,
#       l_cnt        LIKE type_file.num5,             #FUN-760053 add
#       l_sql,l_sql1 STRING,                          #FUN-5A0118        
#       i,g_no       LIKE type_file.num5             #No.FUN-680098   SMALLINT
#DEFINE l_asg08      LIKE asg_file.asg08              #FUN-920067 add
#DEFINE l_asq09_asg05      LIKE asg_file.asg05              #FUN-920067 add  
#DEFINE l_asq10_asg05      LIKE asg_file.asg05              #FUN-920067
#DEFINE l_ass10_ass11_sum  LIKE ass_file.ass10  #FUN-920167
#DEFINE l_i                LIKE type_file.num5  #FUN-920167 
#DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
#DEFINE l_asg08_asq10      LIKE asg_file.asg08  #FUN-960096
#DEFINE l_asg03_asq09      LIKE asg_file.asg03  #FUN-A30079
#DEFINE l_asg03_asq10      LIKE asg_file.asg03  #FUN-A30079
#DEFINE g_dbs_asq09        LIKE azp_file.azp03  #FUN-A30079 
#DEFINE g_dbs_asq10        LIKE azp_file.azp03  #FUN-A30079 
#DEFINE l_asb02            LIKE asb_file.asb02  #FUN-A30079
##DEFINE l_asa09_asq09      LIKE asa_file.asa09  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_asa09_asq10      LIKE asa_file.asa09  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_asg06_asq09      LIKE asg_file.asg06  #FUN-A30079  #FUN-A90006 mark
##DEFINE l_asg06_asq10      LIKE asg_file.asg06  #FUN-A30079  #FUN-A90006 mark
#DEFINE l_low_asq09        LIKE type_file.num5  #FUN-A60060
#DEFINE l_up_asq09         LIKE type_file.num5  #FUN-A60060
#DEFINE l_low_asq10        LIKE type_file.num5  #FUN-A60060
#DEFINE l_up_asq10         LIKE type_file.num5  #FUN-A60060
#DEFINE l_asa02_asq09      LIKE asa_file.asa02  #FUN-A60060
#DEFINE l_asa02_asq10      LIKE asa_file.asa02  #FUN-A60060
#DEFINE l_asg06_asq16      LIKE asg_file.asg06  #FUN-A90026 
## -- FUN-A90036 start--
#DEFINE l_ask03            LIKE ask_file.ask03
#DEFINE l_ask05            LIKE ask_file.ask05
#DEFINE l_ask06            LIKE ask_file.ask06
#DEFINE l_ask07             LIKE ask_file.ask07
#DEFINE l_ask07_d            LIKE ask_file.ask07
#DEFINE l_ask07_c            LIKE ask_file.ask07
## -- FUN-A90036 end--
#DEFINE l_asu03             LIKE asu_file.asu03   #TQC-AA0098
#
#     DELETE FROM p001_tmp   #FUN-760053 add
#
#     #--FUN-920067 start-- 抓出上層公司asq10在agli009中設定帳別
#     #SELECT asg05 INTO l_asq09_asg05  
#     SELECT asg05 INTO g_asq09_asg05   #FUN-A90006
#       FROM asg_file
#      WHERE asg01 = g_asq.asq09
#     #SELECT asg05 INTO l_asq10_asg05
#      SELECT asg05 INTO g_asq10_asg05  #FUN-A90006
#       FROM asg_file
#      WHERE asg01 = g_asq.asq10
#
#     #--FUN-920167 start-- 抓出下層公司asq10在agli009中設定的關係人異動碼值--
#     #SELECT asg08 INTO l_asg08  
#     SELECT asg08 INTO g_asg08  #FUN-A90006 
#       FROM asg_file
#      WHERE asg01 = g_asq.asq09   #FUN-930112
##     SELECT asg08 INTO l_asg08_asq10
#      SELECT asg08 INTO g_asg08_asq10  #FUN-A90006 
#       FROM asg_file WHERE asg01 = g_asq.asq10
#
# 
#     #--FUN-A30079 start--
#     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
#     #之前的應用方式為tm.asa02上層公司輸入之後抓取的asr,ass資料都是自己本身
#     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
#     #SQL抓資料時分為以下狀況 ：
#     #A.來源(目的)公司=合併主體：(順流)
#     #  A1.asr02 = 自己, asr04 = 自己
#     #  A2.asr02 = 不用加入此條件, asr04 = 自己
#     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
#     #  IF 屬於上層公司
#     #    1.最上層公司：條件=>asr02 = 自己, asr04 = 自己
#     #    2.中間層(有上層也有下層),條件=> asr02 = 自己的上層公司,asr04 = 自己 
#     #  ELSE
#     #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己
#     #  END IF
#  
#     #--先判斷g_asq.asq09(來源)/g_asq.asq10(目的)各自是否為上層公司--
#     LET g_cnt_asq09 = 0
#     SELECT COUNT(*) INTO g_cnt_asq09 
#       FROM asa_file
#      WHERE asa01 = g_asq.asq13   #群組
#        AND asa02 = g_asq.asq09   #上層公司 
#
#     LET g_cnt_asq10 = 0
#     SELECT COUNT(*) INTO g_cnt_asq10 
#       FROM asa_file
#      WHERE asa01 = g_asq.asq13   #群組
#        AND asa02 = g_asq.asq10   #上層公司
#
#     #--FUN-A60060 start-------------------
#     IF g_cnt_asq09 > 0 THEN    #代表為上層公司
#        #判斷是否存在下層
#        # SELECT COUNT(*) INTO l_low_asq09  
#        SELECT COUNT(*) INTO g_low_asq09  #FUN-A90006
#          FROM asb_file
#         WHERE asb01 = tm.asa01
#           AND asb04 = g_asq.asq09
##       IF l_low_asq09 > 0 THEN  
#        IF g_low_asq09 > 0 THEN          #FUN-A90006
#             #--如果l_up_asq09 = 0 代表是最下層
#             #SELECT COUNT(*) INTO l_up_asq09
#             SELECT COUNT(*) INTO g_up_asq09    #FUN-A90006
#               FROM asa_file 
#              WHERE asa01 = tm.asa01
#                AND asa02 = g_asq.asq09
#            #IF l_up_asq09 <> 0 THEN
#            IF g_up_asq09 <> 0 THEN             #FUN-A90006
#                #SELECT asb02 INTO l_asa02_asq09
#                SELECT asb02 INTO g_asa02_asq09   #FUN-A90006
#                  FROM asb_file
#                 WHERE asb01 = tm.asa01
#                   AND asb04 = g_asq.asq09
#                #--如果g_up_asq09 = 0 代表是最下層
#                #SELECT COUNT(*) INTO l_up_asq09
#                SELECT COUNT(*) INTO g_up_asq09    #FUN-A90006
#                  FROM asa_file 
#                 WHERE asa01 = tm.asa01
#                   AND asa02 = g_asq.asq09
#             END IF
#         END IF
#     #--FUN-A60078 start--
#     ELSE
#         #SELECT asb02 INTO l_asa02_asq09
#         SELECT asb02 INTO g_asa02_asq09          #FUN-A90006
#           FROM asb_file
#          WHERE asb01 = tm.asa01
#            AND asb04 = g_asq.asq09
#     #--FUN-A60078 end--
#     END IF   
#
#     IF g_cnt_asq10 > 0 THEN   #代表為上層公司
#         #判斷是否存在下層
#         #SELECT COUNT(*) INTO l_low_asq10  
#         SELECT COUNT(*) INTO g_low_asq10     #FUN-A90006
#           FROM asb_file
#          WHERE asb01 = tm.asa01
#            AND asb04 = g_asq.asq10
#         #IF l_low_asq10 > 0 THEN  
#         IF g_low_asq10 > 0 THEN              #FUN-A90006
#             #--如果l_up_asq10 = 0 代表是最下層
#             #SELECT COUNT(*) INTO l_up_asq10
#             SELECT COUNT(*) INTO g_up_asq10  #FUN-A90006
#               FROM asa_file 
#              WHERE asa01 = tm.asa01
#                AND asa02 = g_asq.asq10
#            #IF l_up_asq10 <> 0 THEN
#            IF g_up_asq10 <> 0 THEN           #FUN-A90006
#                #SELECT asb02 INTO l_asa02_asq10
#                SELECT asb02 INTO g_asa02_asq10    #FUN-A90006
#                  FROM asb_file
#                 WHERE asb01 = tm.asa01
#                   AND asb04 = g_asq.asq10
#            END IF
#         END IF
#     #--FUN-A60078 START
#     ELSE
#         #SELECT asb02 INTO l_asa02_asq10
#         SELECT asb02 INTO g_asa02_asq10           #FUN-A90006
#           FROM asb_file
#          WHERE asb01 = tm.asa01
#            AND asb04 = g_asq.asq10
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
#     IF g_cnt_asq09 > 0 THEN   #為上層公司
#         #SELECT asa09 INTO l_asa09_asq09
#         SELECT asa09 INTO g_asa09_asq09   #FUN-A90006
#           FROM asa_file 
#          WHERE asa01 = tm.asa01
#            AND asa02 = g_asq.asq09
#         SELECT asg03 INTO l_asg03_asq09 
#           FROM asg_file 
#          WHERE asg01 = g_asq.asq09
#         SELECT azp03 INTO g_dbs_asq09 FROM azp_file
#          WHERE azp01 = l_asg03_asq09
#         #IF l_asa09_asq09 = 'Y' THEN     #來源公司合併帳別
#         IF g_asa09_asq09 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_asq09 = s_dbstring(g_dbs_asq09)
#         ELSE
#             LET g_dbs_asq09 = s_dbstring(g_dbs)
#         END IF
#     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
#         SELECT asb02 INTO l_asb02
#           FROM asb_file 
#          WHERE asb01 = tm.asa01
#            AND asb04 = g_asq.asq09
#         #SELECT asa09 INTO l_asa09_asq09
#         #SELECT asa09,asa02 INTO l_asa09_asq09,l_asa02_asq09  #FUN-A60060
#         SELECT asa09,asa02 INTO g_asa09_asq09,g_asa02_asq09   #FUN-A90006
#           FROM asa_file 
#          WHERE asa01 = tm.asa01
#            AND asa02 = l_asb02
#         SELECT asg03 INTO l_asg03_asq09 
#           FROM asg_file 
#          WHERE asg01 = l_asb02
#         SELECT azp03 INTO g_dbs_asq09 FROM azp_file
#          WHERE azp01 = l_asg03_asq09
#         #IF l_asa09_asq09 = 'Y' THEN     #來源公司合併帳別
#         IF g_asa09_asq09 = 'Y' THEN     #來源公司合併帳別     #FUN-A90006
#             LET g_dbs_asq09 = s_dbstring(g_dbs_asq09)
#         ELSE
#             LET g_dbs_asq09 = s_dbstring(g_dbs)
#         END IF
#     END IF        
#     LET g_sql = "SELECT aaz641 FROM ",g_dbs_asq09,"aaz_file",
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
#     PREPARE p001_aaz_p1 FROM g_sql
#     DECLARE p001_aaz_c1 CURSOR FOR p001_aaz_p1
#     OPEN p001_aaz_c1
#     FETCH p001_aaz_c1 INTO g_aaz641_asq09   #合併帳別
#     CLOSE p001_aaz_c1
#
#     IF g_cnt_asq10 > 0 THEN   #為上層公司
#         #SELECT asa09 INTO l_asa09_asq10
#         SELECT asa09 INTO g_asa09_asq10  #FUN-A90006
#           FROM asa_file 
#          WHERE asa01 = tm.asa01
#            AND asa02 = g_asq.asq10
#         SELECT asg03 INTO l_asg03_asq10 
#           FROM asg_file 
#          WHERE asg01 = g_asq.asq10
#         SELECT azp03 INTO g_dbs_asq10 FROM azp_file
#          WHERE azp01 = l_asg03_asq10
#         #IF l_asa09_asq10 = 'Y' THEN     #來源公司合併帳別
#         IF g_asa09_asq10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_asq10 = s_dbstring(g_dbs_asq10)
#         ELSE
#             LET g_dbs_asq10 = s_dbstring(g_dbs)
#         END IF
#     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
#         SELECT asb02 INTO l_asb02
#           FROM asb_file 
#          WHERE asb01 = tm.asa01
#            AND asb04 = g_asq.asq10
#         #SELECT asa09 INTO l_asa09_asq10
#         SELECT asa09 INTO g_asa09_asq10   #FUN-A90006
#           FROM asa_file 
#          WHERE asa01 = tm.asa01
#            AND asa02 = l_asb02
#         SELECT asg03 INTO l_asg03_asq10 
#           FROM asg_file 
#          WHERE asg01 = l_asb02
#         SELECT azp03 INTO g_dbs_asq10 FROM azp_file
#          WHERE azp01 = l_asg03_asq10
#         #IF l_asa09_asq10 = 'Y' THEN     #來源公司合併帳別
#         IF g_asa09_asq10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
#             LET g_dbs_asq10 = s_dbstring(g_dbs_asq10)
#         ELSE
#             LET g_dbs_asq10 = s_dbstring(g_dbs)
#         END IF
#     END IF        
#     LET g_sql = "SELECT aaz641 FROM ",g_dbs_asq10,"aaz_file",
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
#     PREPARE p001_aaz_p2 FROM g_sql
#     DECLARE p001_aaz_c2 CURSOR FOR p001_aaz_p2
#     OPEN p001_aaz_c2
#     FETCH p001_aaz_c2 INTO g_aaz641_asq10   #合併帳別
#     CLOSE p001_aaz_c2
# 
#     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
#     #SELECT asg06 INTO l_asg06_asq09 
#     SELECT asg06 INTO g_asg06_asq09    #FUN-A90006
#       FROM asg_file
#      WHERE asg01 = g_asq.asq09   #來源公司記帳幣別
#     #SELECT asg06 INTO l_asg06_asq10 
#     SELECT asg06 INTO g_asg06_asq10    #FUN-A90006
#       FROM asg_file
#      WHERE asg01 = g_asq.asq10   #目的公司記帳幣別
#     
#     #--FUN-A30079 end---
#
#     #--#資料來源為asr_file---start----
#     IF p_asq15 = '1' THEN        
#         #IF g_cnt_asq09 > 0 THEN   #來源公司屬於上層公司   #FUN-A30079  #FUN-A60038
#         #LET l_sql =" SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",  #FUN-930144 mod
#         LET l_sql =" SELECT 'A','1',asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",  #FUN-930144 mod  #FUN-A90026 mod
#                    #"        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N' "       #FUN-A30079
#                    #"        asr12,'",l_asg08_asq10,"','2','N' "     #FUN-A60038 mod
#                    #"        asr12,'",l_asg08_asq10,"','2','N','' "   #FUN-A80137 mod
#                    "         asr12,'",g_asg08_asq10,"','2','N','' "    #FUN-A90006
##--FUN-A60038 mark---
##         #---FUN-A30079 start-
##         ELSE 
##             #FUN-A40026 mark
##             #IF g_asq.asq14 = 'Y' THEN  #股本沖銷類科目不處理換算為合併幣別問題，直接取上層的記帳幣
##             #    LET l_sql =" SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",  
##             #               "        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N' "     
##             #ELSE
##             #FUN-A40026 mark
##                 LET l_sql =" SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14),",  
##                            "        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N' "
##             #END IF
##         END IF
##---FUN-A60038 mark----
#
#         LET l_sql = l_sql CLIPPED,
#         #---FUN-A30079 end---
#                    "   FROM asr_file ",
#                    "  WHERE asr01 ='",g_asa[i].asa01,"' ",   #群組
#                    #"    AND asr02 = '",g_asa[i].asa02,"'",  #FUN-970046 add
#                    #"     AND asr02 = '",tm.asa02,"'",        #FUN-A30064 #FUN-A30079 mark 
#                    #"    AND asr00 ='",g_aaz641,"' ",        #合併帳別
#                    "     AND asr00 ='",g_aaz641_asq09,"' ",  #合併帳別   #FUN0-A30079
#                    #"    AND asr12 ='",x_aaa03,"' ",         #幣別       #FUN-A30079 mark
#                    "    AND asr04 ='",g_asq.asq09,"' ",      #來源公司
#                    #"    AND asr041='",l_asq09_asg05,"' ",    #來源帳別 
#                    "    AND asr041='",g_asq09_asg05,"' ",    #來源帳別    #FUN-A90006
#                    "    AND asr06 = ",tm.yy,                 #年度
#                    "    AND asr07 = '",tm.em,"'"             #FUN-970046 mod   只抓截止期別的金額
#
#                    #---FUN-A60060 start---
#                    #A.來源公司=合併主體：(順流)
#                    #  來源:asr02 = 自己(asq09), asr04 = 自己(asq09)
#                    #  目的:asr02 = 不用加入此條件, asr04 = 自己(asq10)
#                    #B.來源公司 <> 合併主體：(側流或逆流)
#                    #  IF 來源屬於上層公司(g_cnt_asq09 > 0)
#                    #    1.最上層公司：條件=>asr02 = 自己(asq09), asr04 = 自己(asq09)
#                    #    2.中間層(有上層也有下層),
#                    #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq09),asr04 = 自己(asq09) 
#                    #       b.關係人交易:條件=>asr02 = 自己(asq09),asr04 = 自己(asq09)
#                    #  ELSE
#                    #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq09)
#                    #  END IF
#                     IF g_asq.asq09 = g_asq.asq16 THEN
#                         #-FUN-A70011
#                         IF g_asq.asq14 = 'Y' THEN
#                             LET l_sql = l_sql CLIPPED,
#                                 #"    AND asr02 = '",l_asa02_asq10,"'"
#                                 "    AND asr02 = '",g_asa02_asq10,"'"   #FUN-A90006
#                         ELSE
#                         #-FUN-A70011 end--
#                             LET l_sql = l_sql CLIPPED,
#                             "    AND asr02 = '",g_asq.asq09,"'" 
#                         END IF         #FUN-A70011
#                     ELSE
#                         IF g_cnt_asq09 > 0 THEN
#                             #IF l_low_asq09 = 0 THEN #最上層
#                             IF g_low_asq09 = 0 THEN #最上層   #FUN-A90006
#                                 LET l_sql = l_sql CLIPPED,
#                                     "    AND asr02 = '",g_asq.asq09,"'" 
#                             ELSE
#                                 IF g_asq.asq14 = 'Y' THEN   #FUN-A60099
#                                     LET l_sql = l_sql CLIPPED,
#                                         #"    AND asr02 = '",l_asa02_asq09,"'" 
#                                         "    AND asr02 = '",g_asa02_asq09,"'"   #FUN-A90006
#                                 ELSE                                            #FUN-A60099
#                                     LET l_sql = l_sql CLIPPED,                  #FUN-A60099
#                                         "    AND asr02 = '",g_asq.asq09,"'"     #FUN-A60099
#                                 END IF                                          #FUN-A60099 
#                             END IF
#                         #--FUN-A70011 start--
#                         ELSE
#                             LET l_sql = l_sql CLIPPED,
#                             #"    AND asr02 = '",l_asa02_asq09,"'"
#                             "    AND asr02 = '",g_asa02_asq09,"'"               #FUN-A90006
#                         #-FUN-A70011 end--
#                         END IF  
#                     END IF
#                     #--FUN-A60060 end--------
##---FUN-A60060 mark---
##                    #--FUN-A30079 start--
##                    IF g_cnt_asq09 > 0 THEN
##                        LET l_sql = l_sql CLIPPED,
##                        "    AND asr02 = '",g_asq.asq09,"'" 
##                    END IF
##--FUN-A60060 mark----
#
#
##---FUN-A80137 start---#asq15 = '2' 來源科目檔案資料來源.ass_file
#     ELSE
#         #LET l_sql =" SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11), ", 
#         LET l_sql =" SELECT 'A','1',ass08,ass09,ass05,ass02,ass04,(ass10-ass11), ",   #FUN-A90026 mod
#                    #"        ass14,'",l_asg08_asq10,"','2','N',ass07 ",
#                    "        ass14,'",g_asg08_asq10,"','2','N',ass07 ",      #FUN-A90006   
#                    "   FROM ass_file ",
#                    "  WHERE ass01 ='",g_asa[i].asa01,"' ",    #群組
#                    "    AND ass00 ='",g_aaz641_asq09,"' ",   
#                    "    AND ass04 ='",g_asq.asq09,"' ",       #來源公司
#                    #"    AND ass041='",l_asq09_asg05,"' ",     #來源帳別 
#                    "    AND ass041='",g_asq09_asg05,"' ",     #來源帳別    #FUN-A90006
#                    "    AND ass08 = ",tm.yy,                  #年度
#                    #"    AND ass07 = '",l_asg08_asq10 ,"'",  
#                    "    AND ass07 = '",g_asg08_asq10 ,"'",    #FUN-A90006
#                    "    AND ass09 = '",tm.em,"'"           
#         #A.來源公司=合併主體：(順流)
#         #  來源:asr02 = 自己(asq09), asr04 = 自己(asq09)
#         #  目的:asr02 = 不用加入此條件, asr04 = 自己(asq10)
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 來源屬於上層公司(g_cnt_asq09 > 0)
#         #    1.最上層公司：條件=>asr02 = 自己(asq09), asr04 = 自己(asq09)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq09),asr04 = 自己(asq09) 
#         #       b.關係人交易:條件=>asr02 = 自己(asq09),asr04 = 自己(asq09)
#         #  ELSE
#         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq09)
#         #  END IF
#         IF g_asq.asq09 = g_asq.asq16 THEN
#             IF g_asq.asq14 = 'Y' THEN
#                 LET l_sql = l_sql CLIPPED,
#                 #"    AND ass02 = '",l_asa02_asq09,"'"
#                 "    AND ass02 = '",g_asa02_asq09,"'"   #FUN-A90006
#             ELSE
#                 LET l_sql = l_sql CLIPPED,
#                 "    AND ass02 = '",g_asq.asq09,"'" 
#             END IF    #FUN-A70011 
#         ELSE
#             IF g_cnt_asq09 > 0 THEN
##                 IF l_low_asq09 = 0 THEN #最上層
#                  IF g_low_asq09 = 0 THEN #最上層  #FUN-A90006
#                     LET l_sql = l_sql CLIPPED,
#                         "    AND ass02 = '",g_asq.asq09,"'" 
#                 ELSE
#                     IF g_asq.asq14 = 'Y' THEN     
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND ass02 = '",l_asa02_asq09,"'" 
#                             "    AND ass02 = '",g_asa02_asq09,"'"    #FUN-A90006
#                     ELSE                         
#                         LET l_sql = l_sql CLIPPED, 
#                             "    AND ass02 = '",g_asq.asq09,"'"   
#                     END IF                                       
#                 END IF
#             ELSE
#                  LET l_sql = l_sql CLIPPED,
#                  #"    AND ass02 = '",l_asa02_asq09,"'"
#                  "    AND ass02 = '",g_asa02_asq09,"'"               #FUN-A90006
#             END IF  
#         END IF
#     END IF
#
#     IF p_asq15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
#         CASE 
#           WHEN p_asq01 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND asr05 IN (SELECT DISTINCT ast03 FROM ast_file ",
#             "                   WHERE ast00 = '",g_aaz641_asq09,"'",   
#             "                     AND ast01 = '",g_asq.asq01,"'",
#             "                     AND ast09 = '",g_asq.asq09,"'",
#             "                     AND ast10 = '",g_asq.asq10,"'",
#             "                     AND ast12 = '",g_aaz641_asq10,"'",  
#             "                     AND ast13 = '",g_asq.asq13,"')" 
#           WHEN p_asq01 != 'MISC'
#             LET l_sql = l_sql CLIPPED,
#             "    AND asr05 = '",g_asq.asq01,"'"
#         END CASE
#     ELSE   #asq15 = '2'
#         CASE WHEN p_asq01 = 'MISC' 
#               LET l_sql = l_sql CLIPPED,
#               "    AND ass05 IN (SELECT DISTINCT ast03 FROM ast_file ",
#               "                   WHERE ast00 = '",g_aaz641_asq09,"'",  
#               "                     AND ast01 = '",g_asq.asq01,"'",
#               "                     AND ast09 = '",g_asq.asq09,"'",
#               "                     AND ast10 = '",g_asq.asq10,"'",
#               "                     AND ast12 = '",g_aaz641_asq10,"'",  
#               "                     AND ast13 = '",g_asq.asq13,"')"  
#              WHEN p_asq01 != 'MISC'
#                LET l_sql = l_sql CLIPPED,
#                "    AND ass05 = '",g_asq.asq01,"'"
#         END CASE
#     END IF
#
#     IF p_asq17 = '1' THEN    #目的檔案資料來源 asq17 = '1'-->asr_file
#         LET l_sql = l_sql CLIPPED,   
#         "  UNION ",
#         #" SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,", 
#         " SELECT 'B','2',asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-A90026 mod
#         "        asr12,'",g_asg08,"','1','N','' ",   
#         "   FROM asr_file ",
#         "  WHERE asr01 ='",g_asa[i].asa01,"' ",
#         "    AND asr00 ='",g_aaz641_asq10,"' ",               
#         "    AND asr04 ='",g_asq.asq10,"' ",                   #對沖公司
#         "    AND asr041='",g_asq10_asg05,"' ",                 #對沖帳別  
#         "    AND asr06 = ",tm.yy,
#         "    AND asr07 = '",tm.em,"'"                         
#         CASE 
#           WHEN p_asq02 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND asr05 IN (SELECT DISTINCT asu03 FROM asu_file ",
#             "                   WHERE asu00 = '",g_aaz641_asq09,"'", 
#             "                     AND asu01 = '",g_asq.asq02,"'",
#             "                     AND asu09 = '",g_asq.asq09,"'",
#             "                     AND asu10 = '",g_asq.asq10,"'",
#             "                     AND asu12 = '",g_aaz641_asq10,"'",  
#             "                     AND asu13 = '",g_asq.asq13,"'",  
#             "                     AND asu04 != 'Y') "  #是否依據公式設定
#           WHEN p_asq02 != 'MISC'
#             LET l_sql = l_sql CLIPPED,
#             "    AND asr05 = '",g_asq.asq02,"'"
#         END CASE
#
#         #A.來源公司=合併主體：(順流)
#         #  目的:asr02 = 自己的上層公司(g_asa02_asq10), asr04 = 自己
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 目的屬於上層公司
#         #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
#         #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
#         #  ELSE
#         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
#         #  END IF
#         IF g_cnt_asq10 > 0 THEN
#             #IF l_low_asq10 = 0 THEN #最上層
#             IF g_low_asq10 = 0 THEN #最上層    #FUN-A90006
#                 LET l_sql = l_sql CLIPPED,
#                     "    AND asr02 = '",g_asq.asq10,"'"
#             ELSE
#                 #IF l_up_asq10 > 0 THEN    #大於0代表不是最下層 
#                 IF g_up_asq10 > 0 THEN    #大於0代表不是最下層    #FUN-A90006
#                     IF g_asq.asq14 = 'Y' THEN             
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND asr02 = '",l_asa02_asq10,"'"
#                             "    AND asr02 = '",g_asa02_asq10,"'" #FUN-A90006
#                     ELSE                                 
#                         LET l_sql = l_sql CLIPPED,      
#                             "    AND asr02 = '",g_asq.asq10,"'" 
#                     END IF                                      
#                 END IF                
#             END IF
#         ELSE
#             LET l_sql = l_sql CLIPPED,
#             #"    AND asr02 = '",l_asa02_asq10,"'"
#             "    AND asr02 = '",g_asa02_asq10,"'"                 #FUN-A90006
#         END IF
#     ELSE                             #asq17 = '2' -->ass_file        
#         LET l_sql = l_sql CLIPPED,       
#         "  UNION ",
#         #" SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ", 
#         " SELECT 'B','2',ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ",  #FUN-A90026 mod
#         "        ass14,'",g_asg08,"','1','N',ass07 ",                  
#         "   FROM ass_file ",
#         "  WHERE ass01 ='",g_asa[i].asa01,"' ",
#         "    AND ass00 ='",g_aaz641_asq10,"' ",   
#         "    AND ass04 ='",g_asq.asq10,"' ",      #對沖公司
#         "    AND ass041='",g_asq10_asg05,"' ",    #對沖帳別  
#         "    AND ass08 = ",tm.yy,
#         "    AND ass07 = '",g_asg08,"'",         
#         "    AND ass09 = '",tm.em,"'"
#         CASE 
#           WHEN p_asq02 = 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND ass05 IN (SELECT DISTINCT asu03 FROM asu_file ",
#             "                   WHERE asu00 = '",g_aaz641_asq09,"'",   
#             "                     AND asu01 = '",g_asq.asq02,"'",
#             "                     AND asu09 = '",g_asq.asq09,"'",
#             "                     AND asu10 = '",g_asq.asq10,"'",
#             "                     AND asu12 = '",g_aaz641_asq10,"'",  
#             "                     AND asu13 = '",g_asq.asq13,"'",
#             "                     AND asu04 != 'Y') "    #是否依據公式設定
#           WHEN p_asq02 != 'MISC' 
#             LET l_sql = l_sql CLIPPED,
#             "    AND ass05 = '",g_asq.asq02,"'"   
#         END CASE
#         #A.來源公司=合併主體：(順流)
#         #  目的:asr02 = 不用加入此條件, asr04 = 自己
#         #B.來源公司 <> 合併主體：(側流或逆流)
#         #  IF 目的屬於上層公司
#         #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
#         #    2.中間層(有上層也有下層):
#         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
#         #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
#         #  ELSE
#         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
#         #  END IF
#         IF g_cnt_asq10 > 0 THEN
#             #IF l_low_asq10 = 0 THEN #最上層
#             IF g_low_asq10 = 0 THEN #最上層    #FUN-A90006
#                 LET l_sql = l_sql CLIPPED,
#                     "    AND ass02 = '",g_asq.asq10,"'"
#             ELSE
#                 #IF l_up_asq10 > 0 THEN    
#                 IF g_up_asq10 > 0 THEN         #FUN-A90006
#                     IF g_asq.asq14 = 'Y' THEN 
#                         LET l_sql = l_sql CLIPPED,
#                             #"    AND ass02 = '",l_asa02_asq10,"'"
#                             "    AND ass02 = '",g_asa02_asq10,"'"   #FUN-A90006
#                     ELSE                   
#                         LET l_sql = l_sql CLIPPED,                
#                             "    AND ass02 = '",g_asq.asq10,"'"  
#                     END IF                                      
#                 END IF   
#             END IF
#         ELSE
#             LET l_sql = l_sql CLIPPED,
#                #"    AND ass02 = '",l_asa02_asq10,"'"
#                "    AND ass02 = '",g_asa02_asq10,"'"                #FUN-A90006
#         END IF
#     END IF
#     PREPARE p001_asr_misc_p1 FROM l_sql
#     IF STATUS THEN 
#        LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                  
#
#        CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:6',STATUS,1)  
#        LET g_success = 'N'  
#     END IF 
#     DECLARE p001_asr_misc_c1 CURSOR FOR p001_asr_misc_p1
#     
#     #FOREACH p001_asr_misc_c1 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
#     FOREACH p001_asr_misc_c1 INTO g_type,g_flag,g_asr.asr06,g_asr.asr07,g_asr.asr05,  #FUN-A90026 g_type:A.來源/B.目的 g_flag:1.asm/2.asn
#                              g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                              g_asr.asr12,   #FUN-A30079 
#                              g_affil,g_dc,g_flag_r,g_ass07
#       IF SQLCA.sqlcode THEN 
#          LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy                                    #NO.FUN-710023
#          CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p001_asr_misc_1',SQLCA.sqlcode,1) 
#          LET g_success = 'N' 
#          CONTINUE FOREACH  
#       END IF
#   
#       IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
#
#       #---FUN-A90026 start--寫入temp table之前先判斷幣別是否同於合併主體
#       #不相同時如果為損益類科目且asa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
#       SELECT asg06 INTO l_asg06_asq16 
#         FROM asg_file
#        WHERE asg01 = g_asq.asq16   #合併主體幣別
#       IF g_asr.asr12 != l_asg06_asq16 THEN 
#           SELECT aag04 INTO l_aag04
#            FROM aag_file
#            WHERE aag00=g_aaz641
#              AND aag01=g_asr.asr05
#           #依科目性質來判斷取"現時"或"平均"匯率
#           IF l_aag04 = '1' THEN   
#               CALL p001_getrate('1',tm.yy,tm.em,
#                                 g_asr.asr12,l_asg06_asq16)  
#               RETURNING l_rate
#               LET g_asr.asr08 = g_asr.asr08  * l_rate   #TQC-AA0098
#           ELSE
#               #--FUN-AA0093 start--
#               IF g_up_asq10 > 0 THEN    #大於0代表不是最下層
#                   CALL p001_getrate('3',tm.yy,tm.em,
#                                     g_asr.asr12,l_asg06_asq16)
#                   RETURNING l_rate
#                   IF cl_null(l_rate) THEN LET l_rate = 1 END IF   #101023
#                   LET g_asr.asr08 = g_asr.asr08  * l_rate  #101016
#               ELSE
#               #--FUN-AA0093 end--
#                   #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
#                   #                     來源或目的/asm_file or asn_file/合併主體幣別
#                   CALL p001_ins_ask1_chg(g_type,g_flag,l_asg06_asq16) RETURNING g_asr.asr08
#               END IF   #FUN-AA0093
#           END IF
#       END IF
#       #---FUN-A90026 end----
#
#       #先將資料寫進TempTable裡 
#       EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asr.asr05,
#                                 g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                 g_asr.asr12,            #FUN-A30079 
#                                 g_affil,g_dc,g_flag_r
#     END FOREACH
##---FUN-A80137 end------------------------------------
#
#
###------FUN-A80137 mark----------------------------
##          CASE WHEN p_asq01 = 'MISC' AND p_asq02 = 'MISC'
##                LET l_sql = l_sql CLIPPED,
##                "    AND asr05 IN (SELECT DISTINCT ast03 FROM ast_file ",
##                #"                   WHERE ast00 = '",g_aaz641,"'",     #FUN-920067
##                "                   WHERE ast00 = '",g_aaz641_asq09,"'",   #FUN-A30079
##                "                     AND ast01 = '",g_asq.asq01,"'",
##                "                     AND ast09 = '",g_asq.asq09,"'",
##                "                     AND ast10 = '",g_asq.asq10,"'",
##                #"                    AND ast12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND ast12 = '",g_aaz641_asq10,"'",   #FUN-A30079
##                "                     AND ast13 = '",g_asq.asq13,"')"  #FUN-930117
###                IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark  #FUN-A60038 mark  #FUN-A60038 mark  #FUN-A60038 mark
##                    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                    "  UNION ",
##                    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-931044 mod
##                    #"       '",l_asg08,"','1','N' " 
##                    #"        '",l_asg06_asq10,"','",l_asg08,"','1','N' "             #FUN-A30079
##                    "        asr12,'",l_asg08,"','1','N' "        #FUN-A60038 mod
##
## #----FUN-A60038 mark-------------------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y'  THEN 
## #                    #    LET l_sql = l_sql CLIPPED,     
## #                    #    "  UNION ",
## #                    #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-931044 mod
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "             #FUN-A30079
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,  
## #                        "  UNION ",
## #                        " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,",  #FUN-931044 mod
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N' " 
## #                    #END IF  FUN-A40026 mark
## #                END IF
## #-----FUN-A60038 mark--------------------
##
##                LET l_sql = l_sql CLIPPED, 
##                #--FUN-A30079 end-----
##                "   FROM asr_file ",
##                "  WHERE asr01 ='",g_asa[i].asa01,"' ",
##                #"   AND asr02 = '",g_asa[i].asa02,"'",               #FUN-970046 add
##                #"    AND asr02 = '",tm.asa02,"'",                     #FUN-A30064  #FUN-A30079 mark 
##                #"   AND asr00 ='",g_aaz641,"' ",                     #FUN-760053   #FUN-920067 mod
##                "    AND asr00 ='",g_aaz641_asq10,"' ",                  #FUN-A30079
##                #"    AND asr12 ='",x_aaa03,"' ",                      #FUN-760053   #FUN-A30079 mark 
##                "    AND asr04 ='",g_asq.asq10,"' ",                   #對沖公司
##                "    AND asr041='",l_asq10_asg05,"' ",                 #對沖帳別  #FUN-920067
##                "    AND asr06 = ",tm.yy,
##                "    AND asr07 = '",tm.em,"'",                         #FUN-970046 mod
##                "    AND asr05 IN (SELECT DISTINCT asu03 FROM asu_file ",
##                #"                  WHERE asu00 = '",g_aaz641,"'",     #FUN-920067 mod
##                "                   WHERE asu00 = '",g_aaz641_asq09,"'",  #FUN-A30079
##                "                     AND asu01 = '",g_asq.asq02,"'",
##                "                     AND asu09 = '",g_asq.asq09,"'",
##                "                     AND asu10 = '",g_asq.asq10,"'",
##                #"                    AND asu12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND asu12 = '",g_aaz641_asq10,"'",  #FUN-A30079
##                "                     AND asu13 = '",g_asq.asq13,"'",  #FUN-930117
##                "                     AND asu04 != 'Y') "              #是否依據公式設定
##                #--FUN-A30079 start--
##                #"  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                #--FUN-A60060 mark--
##                #IF g_cnt_asq10 > 0 THEN  
##                #    LET l_sql = l_sql CLIPPED,
##                #        "    AND asr02 = '",g_asq.asq10,"'", 
##                #        "  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                #END IF                    
##                #--FUN-A60060 mark--
##          WHEN p_asq01 = 'MISC' AND p_asq02 != 'MISC'
##                LET l_sql = l_sql CLIPPED,
##                "    AND asr05 IN (SELECT DISTINCT ast03 FROM ast_file ",
##                #"                  WHERE ast00 = '",g_aaz641,"'",     #FUN-920067
##                "                   WHERE ast00 = '",g_aaz641_asq09,"'",  #FUN-A30079
##                "                     AND ast01 = '",g_asq.asq01,"'",
##                "                     AND ast09 = '",g_asq.asq09,"'",
##                "                     AND ast10 = '",g_asq.asq10,"'",
##                #"                    AND ast12 = '",g_aaz641,"'",     #FUN-920067
##                "                     AND ast12 = '",g_aaz641_asq10,"'",  #FUN-A30079
##                "                     AND ast13 = '",g_asq.asq13,"')"  #FUN-930117
###                IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                    "  UNION ",
##                    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-931044 mod
##                    #"        '",l_asg08,"','1','N' ",  #FUN-920167
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N' "  #FUN-A30079 mod
##                     "         asr12,'",l_asg08,"','1','N' "                #FUN-A60038 mod
## #-----FUN-A60038 mark----------------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,    
## #                    #    "  UNION ",
## #                    #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,  
## #                        "  UNION ",
## #                        " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N' " 
## #                    #END IF   #FUN-A40026 mark
## #                END IF
## #----------FUN-A60038 mark----------
## 
##                  LET l_sql = l_sql CLIPPED, 
##                  #--FUN-A30079 end----
##                  "   FROM asr_file ",
##                  "  WHERE asr01 ='",g_asa[i].asa01,"' ",
##                 #"   AND asr02 = '",g_asa[i].asa02,"'",                    #FUN-970046 add
##                 #"    AND asr02 = '",tm.asa02,"'",                          #FUN-A30064 #FUN-A30079 mark  
##                 #"   AND asr00 ='",g_aaz641,"' ",                          #FUN-760053   #FUN-920067 mod
##                 "    AND asr00 ='",g_aaz641_asq10,"' ",                       #FUN-A30079
##                 #"   AND asr12 ='",x_aaa03,"' ",                           #FUN-760053   #FUN-A30079 mark
##                 "    AND asr04 ='",g_asq.asq10,"' ",                       #對沖公司
##                 "    AND asr041='",l_asq10_asg05,"' ",                     #對沖帳別  #FUN-920067
##                 "    AND asr06 = ",tm.yy,
##                 "    AND asr07 = '",tm.em,"'",                             #FUN-970046 mod
##                 "    AND asr05 = '",g_asq.asq02,"'"                        #FUN-970046 mod
##                 #---FUN-A60060 mark---------
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 #IF g_cnt_asq10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND asr02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 #END IF
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark----
## 
##            WHEN p_asq01 != 'MISC' AND p_asq02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND asr05 = '",g_asq.asq01,"'"
## #                IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079 #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,", 
##                     #"       '",l_asg08,"','1','N' "
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N' "  #FUN-A30079 mod
##                     "        asr12,'",l_asg08,"','1','N' "  #FUN-A60038 mod
## 
## #---------FUN-A60038 mark--------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED, 
## #                    #    "  UNION ",
## #                    #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,
## #                        "  UNION ",
## #                        " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #------------FUN-A60038 mark-----------
## 
##                 LET l_sql = l_sql CLIPPED, 
##                 #--FUN-A30079 end---
##                 "   FROM asr_file ",
##                 "  WHERE asr01 ='",g_asa[i].asa01,"' ",
##                 #"   AND asr02 = '",g_asa[i].asa02,"'",  #FUN-970046 add
##                 #"    AND asr02 = '",tm.asa02,"'",        #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND asr00 ='",g_aaz641,"' ", 
##                 "    AND asr00 ='",g_aaz641_asq10,"' ",     #FUN-A30079
##                 #"    AND asr12 ='",x_aaa03,"' ",         #FUN-A30079  mark 
##                 "    AND asr04 ='",g_asq.asq10,"' ",      #對沖公司
##                 "    AND asr041='",l_asq10_asg05,"' ",    #對沖帳別  
##                 "    AND asr06 = ",tm.yy,
##                 "    AND asr07 = '",tm.em,"'",            #FUN-970046 mod
##                 "    AND asr05 IN (SELECT DISTINCT asu03 FROM asu_file ",
##                 #"                  WHERE asu00 = '",g_aaz641,"'",  
##                 "                   WHERE asu00 = '",g_aaz641_asq09,"'",    #FUN-A30079
##                 "                     AND asu01 = '",g_asq.asq02,"'",
##                 "                     AND asu09 = '",g_asq.asq09,"'",
##                 "                     AND asu10 = '",g_asq.asq10,"'",
##                 #"                    AND asu12 = '",g_aaz641,"'", 
##                 "                     AND asu12 = '",g_aaz641_asq10,"'",    #FUN-A30079
##                 "                     AND asu13 = '",g_asq.asq13,"'",
##                 "                     AND asu04 != 'Y') "     #是否依據公式設定
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 ##IF g_cnt_asq10 > 0 THEN   #FUN-A60060 mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND asr02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 #END IF                     #FUN-A60060 add
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark--
## 
##            WHEN p_asq01 != 'MISC' AND p_asq02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND asr05 = '",g_asq.asq01,"'"
## #                IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079 #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,", 
##                     #"       '",l_asg08,"','1','N' ",
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N' "  #FUN-A30079 mod
##                     "        asr12,'",l_asg08,"','1','N' "                 #FUN-A60038 mod
## 
## #-----FUN-A60038 mark-----
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,    
## #                    #    "  UNION ",
## #                    #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,       
## #                        "  UNION ",
## #                        " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N' "  
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #-----FUN-A60038 mark--------
## 
##                 LET l_sql = l_sql CLIPPED,     
##                 "   FROM asr_file ",
##                 "  WHERE asr01 ='",g_asa[i].asa01,"' ",
##                 #"   AND asr02 = '",g_asa[i].asa02,"'", 　 　#FUN-970046 add
##                 #"    AND asr02 = '",tm.asa02,"'",        　  #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND asr00 ='",g_aaz641,"' ", 
##                 "    AND asr00 ='",g_aaz641_asq10,"' ",         #FUN-A30079
##                 #"   AND asr12 ='",x_aaa03,"' ",             #FUN-A30079 mark
##                 "    AND asr04 ='",g_asq.asq10,"' ",          #對沖公司
##                 "    AND asr041='",l_asq10_asg05,"' ",        #對沖帳別  
##                 "    AND asr06 = ",tm.yy,
##                 "    AND asr07 = '",tm.em,"'",                #FUN-970046 mod
##                 "    AND asr05 = '",g_asq.asq02,"'"                            #FUN-970046 mod
##                 #--FUN-A60060 mark----
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 #IF g_cnt_asq10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND asr02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##                 #END IF                 
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark---
##           END CASE
##           #--FUN-A60060 start---
##           #A.來源公司=合併主體：(順流)
##           #  目的:asr02 = 自己的上層公司(l_asa02_asq10), asr04 = 自己
##           #B.來源公司 <> 合併主體：(側流或逆流)
##           #  IF 目的屬於上層公司
##           #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
##           #    2.中間層(有上層也有下層):
##           #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
##           #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
##           #  ELSE
##           #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
##           #  END IF
## 
##           #--FUN-A70011 mark--
##           #IF g_asq.asq09 = g_asq.asq16 THEN     #FUN-A60078
##           #    IF g_asq.asq14 = 'Y' THEN         #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,        #FUN-A60078
##           #            "    AND asr02 = '",l_asa02_asq10,"'"   #FUN-A60078
##           #    ELSE                                            #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,                  #FUN-A60099
##           #            "    AND asr02 = '",g_asq.asq10,"'"     #FUN-A60099
##           #    END IF
##           #ELSE                                  #FUN-A60078
##           #--FUN-A70011 mark--
##               IF g_cnt_asq10 > 0 THEN
##                   IF l_low_asq10 = 0 THEN #最上層
##                       LET l_sql = l_sql CLIPPED,
##                           "    AND asr02 = '",g_asq.asq10,"'"
##                   ELSE
##                       IF l_up_asq10 > 0 THEN    #FUN-A60078  #大於0代表不是最下層 
##                           IF g_asq.asq14 = 'Y' THEN                     #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,
##                                   "    AND asr02 = '",l_asa02_asq10,"'"
##                           ELSE                                          #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,                #FUN-A60099
##                                   "    AND asr02 = '",g_asq.asq10,"'"   #FUN-A60099
##                           END IF                                        #FUN-A60099
##                       END IF                    #FUN-A60078
##                   END IF
##               #-FUN-A70011 start-
##               ELSE
##                   LET l_sql = l_sql CLIPPED,
##                   "    AND asr02 = '",l_asa02_asq10,"'"
##               #-FUN-A70011 end--
##               END IF
##           #END IF          #FUN-A70011 mark
##           LET l_sql = l_sql CLIPPED,
##                "  ORDER BY asr06,asr07,asr05,asr02,asr04 "
##           #--FUN-A60060 end--------
##     ELSE
##          #---資料來源為ass_file--------------
##           #IF g_cnt_asq09 > 0 THEN   #來源公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##               LET l_sql =" SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11), ", 
##                          #"        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N',ass07 " #FUN-A30079 add ass14
##                          "        ass14,'",l_asg08_asq10,"','2','N',ass07 "                #FUN-A60038 mod
## #-------FUN-A60038 mark------------
## #          #--FUN-A30079 start--
## #          ELSE
## #              #FUN-A40026 mark
## #              #IF g_asq.asq14 = 'Y' THEN
## #              #    LET l_sql =" SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11), ",
## #              #               "        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N',ass07 "
## #              #ELSE
## #              #FUN-A40026 mark
## #                  LET l_sql =" SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19), ", 
## #                             "        '",l_asg06_asq09,"','",l_asg08_asq10,"','2','N',ass07 "
## #              #END IF  #FUN-A40026 mark
## #          END IF
## #------------FUN-A60038 mark----------
## 
##            LET l_sql = l_sql CLIPPED,    
##            #---FUN-A30079 end----
##                      "   FROM ass_file ",
##                      "  WHERE ass01 ='",g_asa[i].asa01,"' ",    #群組
##                      #"   AND ass00 ='",g_aaz641,"' ",          #合併帳別
##                      "    AND ass00 ='",g_aaz641_asq09,"' ",       #FUN-A30079
##                      #"   AND ass02 = '",g_asa[i].asa02,"'",    #FUN-970046 add
##                      #"    AND ass02 = '",tm.asa02,"'",          #FUN-A30064  #FUN-A30079 mark 
##                      #"    AND ass14 ='",x_aaa03,"' ",           #幣別        #FUN-A30079 mark 
##                      "    AND ass04 ='",g_asq.asq09,"' ",       #來源公司
##                      "    AND ass041='",l_asq09_asg05,"' ",     #來源帳別 
##                      "    AND ass08 = ",tm.yy,         #年度
##                      "    AND ass07 = '",l_asg08_asq10 ,"'",    #FUN-960096
##                      "    AND ass09 = '",tm.em,"'"              #FUN-970046 mod
## 
##                      #---FUN-A60060 start---
##                      #A.來源公司=合併主體：(順流)
##                      #  來源:asr02 = 自己(asq09), asr04 = 自己(asq09)
##                      #  目的:asr02 = 不用加入此條件, asr04 = 自己(asq10)
##                      #B.來源公司 <> 合併主體：(側流或逆流)
##                      #  IF 來源屬於上層公司(g_cnt_asq09 > 0)
##                      #    1.最上層公司：條件=>asr02 = 自己(asq09), asr04 = 自己(asq09)
##                      #    2.中間層(有上層也有下層):
##                      #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq09),asr04 = 自己(asq09) 
##                      #       b.關係人交易:條件=>asr02 = 自己(asq09),asr04 = 自己(asq09)
##                      #  ELSE
##                      #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq09)
##                      #  END IF
##                       IF g_asq.asq09 = g_asq.asq16 THEN
##                           #--FUN-A70011 start-
##                           IF g_asq.asq14 = 'Y' THEN
##                               LET l_sql = l_sql CLIPPED,
##                               "    AND ass02 = '",l_asa02_asq09,"'"
##                           ELSE
##                           #--FUN-A70011 end--
##                               LET l_sql = l_sql CLIPPED,
##                               "    AND ass02 = '",g_asq.asq09,"'" 
##                           END IF    #FUN-A70011 
##                       ELSE
##                           IF g_cnt_asq09 > 0 THEN
##                               IF l_low_asq09 = 0 THEN #最上層
##                                   LET l_sql = l_sql CLIPPED,
##                                       "    AND ass02 = '",g_asq.asq09,"'" 
##                               ELSE
##                                   IF g_asq.asq14 = 'Y' THEN     #FUN-A60099
##                                       LET l_sql = l_sql CLIPPED,
##                                           "    AND ass02 = '",l_asa02_asq09,"'" 
##                                   ELSE                                           #FUN-A60099
##                                       LET l_sql = l_sql CLIPPED,                 #FUN-A60099
##                                           "    AND ass02 = '",g_asq.asq09,"'"    #FUN-A60099
##                                   END IF                                         #FUN-A60099
##                               END IF
##                           #--FUN-A70011 start-
##                           ELSE
##                                LET l_sql = l_sql CLIPPED,
##                                "    AND ass02 = '",l_asa02_asq09,"'"
##                           #--FUN-A70011 end--
##                           END IF  
##                       END IF
##                      #--FUN-A60060 end--------
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 #IF g_cnt_asq09 > 0 THEN
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND ass02 = '",g_asq.asq09,"'" 
##                 #END IF
##                 ##--FUN-A30079 end----       
##                 #--FUN-A60060 mark---
##           CASE WHEN p_asq01 = 'MISC' AND p_asq02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND ass05 IN (SELECT DISTINCT ast03 FROM ast_file ",
##                 #"                  WHERE ast00 = '",g_aaz641,"'", 
##                 "                   WHERE ast00 = '",g_aaz641_asq09,"'",   #FUN-A30079
##                 "                     AND ast01 = '",g_asq.asq01,"'",
##                 "                     AND ast09 = '",g_asq.asq09,"'",
##                 "                     AND ast10 = '",g_asq.asq10,"'",
##                 #"                    AND ast12 = '",g_aaz641,"'",
##                 "                     AND ast12 = '",g_aaz641_asq10,"'",   #FUN-A30079
##                 "                     AND ast13 = '",g_asq.asq13,"')"  #FUN-930117
## #                IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ", 
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "       #FUN-A30079 add ass14
##                     "        ass14,'",l_asg08,"','1','N',ass07 "                      #FUN-A60038 mod
## 
## #----------FUN-A60038 mark----
## #                #--FUN-A30079 start-
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y'  THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT ass08,ass09,ass05,ass02,ass04,(asr10-ass11)*-1, ",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,      
## #                        "  UNION ",
## #                        " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19)*-1, ", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 " 
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #--------FUN-A60038 mark---------
## 
##                 LET l_sql = l_sql CLIPPED,      
##                 #--FUN-A30079 end----
##                 "   FROM ass_file ",
##                 "  WHERE ass01 ='",g_asa[i].asa01,"' ",
##                 #"    AND ass00 ='",g_aaz641,"' ", 
##                 "    AND ass00 ='",g_aaz641_asq10,"' ",     #FUN-A30079
##                 #"   AND ass02 = '",g_asa[i].asa02,"'",  #FUN-970046 add
##                 #"    AND ass02 = '",tm.asa02,"'",        #FUN-A30064  #FUN-A30079 MARK 
##                 #"    AND ass14 ='",x_aaa03,"' ",         #FUN-760053  #FUN-A30079 mark 
##                 "    AND ass04 ='",g_asq.asq10,"' ",      #對沖公司
##                 "    AND ass041='",l_asq10_asg05,"' ",    #對沖帳別  
##                 "    AND ass08 = ",tm.yy,
##                 "    AND ass07 = '",l_asg08,"'",          #FUN-960096
##                 "    AND ass09 = '",tm.em,"'",            #FUN-970046 mod
##                 "    AND ass05 IN (SELECT DISTINCT asu03 FROM asu_file ",
##                 #"                   WHERE asu00 = '",g_aaz641,"'", 
##                 "                   WHERE asu00 = '",g_aaz641_asq09,"'",   #FUN-A30079
##                 "                     AND asu01 = '",g_asq.asq02,"'",
##                 "                     AND asu09 = '",g_asq.asq09,"'",
##                 "                     AND asu10 = '",g_asq.asq10,"'",
##                 #"                    AND asu12 = '",g_aaz641,"'", 
##                 "                     AND asu12 = '",g_aaz641_asq10,"'",   #FUN-A30079
##                 "                     AND asu13 = '",g_asq.asq13,"'",
##                 "                     AND asu04 != 'Y') "    #是否依據公式設定
## 　　　　　　　　#--FUN-A60060 mark--　　　　　　
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 #IF g_cnt_asq10 > 0 THEN 
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND ass02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY ass08,ass09,ass05,ass02,ass04 " 
##                 #END IF                 
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
##            WHEN p_asq01 = 'MISC' AND p_asq02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND ass05 IN (SELECT DISTINCT ast03 FROM ast_file ",
##                 #"                  WHERE ast00 = '",g_aaz641,"'", 
##                 "                   WHERE ast00 = '",g_aaz641_asq09,"'",   #FUN-A30079
##                 "                     AND ast01 = '",g_asq.asq01,"'",
##                 "                     AND ast09 = '",g_asq.asq09,"'",
##                 "                     AND ast10 = '",g_asq.asq10,"'",
##                 #"                    AND ast12 = '",g_aaz641,"'",
##                 "                     AND ast12 = '",g_aaz641_asq10,"'",   #FUN-A30079
##                 "                     AND ast13 = '",g_asq.asq13,"')"
##                 #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1,", 
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "       #FUN-A30079 add ass14
##                     "        ass14,'",l_asg08,"','1','N',ass07 "       #FUN-A60038
## #-----FUN-A60038 mark------
## #                #--FUN-A30079 start--
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1,",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,           
## #                        "  UNION ",
## #                        " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19)*-1,", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 " 
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #------FUN-A60038 mark--------
## 
##                 LET l_sql = l_sql CLIPPED,          
##                 #--FUN-A30079 end---- 
##                 "   FROM ass_file ",
##                 "  WHERE ass01 ='",g_asa[i].asa01,"' ",
##                 #"   AND ass02 = '",g_asa[i].asa02,"'",             #FUN-970046 add
##                 #"   AND ass02 = '",tm.asa02,"'",                   #FUN-A30064 #FUN-A30079 mark
##                 #"    AND ass00 ='",g_aaz641,"' ", 
##                 "    AND ass00 ='",g_aaz641_asq10,"' ",                #FUN-A30079
##                 #"   AND ass14 ='",x_aaa03,"' ",                    #FUN-760053 #FUN-A30079 mark 
##                 "    AND ass04 ='",g_asq.asq10,"' ",                 #對沖公司
##                 "    AND ass041='",l_asq10_asg05,"' ",               #對沖帳別  
##                 "    AND ass08 = ",tm.yy,
##                 "    AND ass07 = '",l_asg08,"'",                     #FUN-960096
##                 "    AND ass09 = '",tm.em,"'",                       #FUN-970046 mod
##                 "    AND ass05 = '",g_asq.asq02,"'"                  #FUN-970046 mod
##                 #--FUN-A60060 mark---
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 #IF g_cnt_asq10 > 0 THEN  
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND ass02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
## 
##            WHEN p_asq01 != 'MISC' AND p_asq02 = 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND ass05 = '",g_asq.asq01,"'"
##                 #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ", 
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "       #FUN-A30079 add ass14
##                     "        ass14,'",l_asg08,"','1','N',ass07 "       #FUN-A60038 mod
## #-------FUN-A60038 mark------------
## #                #--FUN-A30079 start--
## #                ELSE 
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED, 
## #                        "  UNION ",
## #                        " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19)*-1, ", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "  
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #---------FUN-A60038 mark----------
## 
##                 LET l_sql = l_sql CLIPPED, 
##                 #--FUN-A30079 end----
##                 "   FROM ass_file ",
##                 "  WHERE ass01 ='",g_asa[i].asa01,"' ",
##                 #"   AND ass02 = '",g_asa[i].asa02,"'",  #FUN-970046 add
##                 #"    AND ass02 = '",tm.asa02,"'",        #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND ass00 ='",g_aaz641,"' ", 
##                 "    AND ass00 ='",g_aaz641_asq10,"' ",     #FUN-A30079
##                 #"    AND ass14 ='",x_aaa03,"' ",         #FUN-760053  #FUN-A30079 mark 
##                 "    AND ass04 ='",g_asq.asq10,"' ",      #對沖公司
##                 "    AND ass041='",l_asq10_asg05,"' ",    #對沖帳別  
##                 "    AND ass08 = ",tm.yy,
##                 "    AND ass07 = '",l_asg08,"'",
##                #"    AMD ass09 = '",tm.em,"'",            #FUN-970046 mod  #MOD-A40158 mark
##                 "    AND ass09 = '",tm.em,"'",            #MOD-A40158 add
##                 "    AND ass05 IN (SELECT DISTINCT asu03 FROM asu_file ",
##                 #"                   WHERE asu00 = '",g_aaz641,"'",  
##                 "                   WHERE asu00 = '",g_aaz641_asq09,"'",    #FUN-A30079
##                 "                     AND asu01 = '",g_asq.asq02,"'",
##                 "                     AND asu09 = '",g_asq.asq09,"'",
##                 "                     AND asu10 = '",g_asq.asq10,"'",
##                 #"                    AND asu12 = '",g_aaz641,"'", 
##                 "                     AND asu12 = '",g_aaz641_asq10,"'",    #FUN-A30079
##                 "                     AND asu13 = '",g_asq.asq13,"'",
##                 "                     AND asu04 != 'Y') "     #是否依據公式設定
##                 #---FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 ##IF g_cnt_asq10 > 0 THEN    #FUN-A60060  mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND ass02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #---FUN-A60060 mark--
## 
##            WHEN p_asq01 != 'MISC' AND p_asq02 != 'MISC'
##                 LET l_sql = l_sql CLIPPED,
##                 "    AND ass05 = '",g_asq.asq01,"'"
##                 #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
##                     LET l_sql = l_sql CLIPPED,                         #FUN-A30079
##                     "  UNION ",
##                     " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1,", 
##                     #"        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "       #FUN-A30079 add ass14
##                     "        ass14,'",l_asg08,"','1','N',ass07 "       #FUN-A60038 mod
## 
## #----------FUN-A60038 mark-------------
## #                #--FUN-A30079 start
## #                ELSE
## #                    #FUN-A40026 mark
## #                    #IF g_asq.asq14 = 'Y' THEN
## #                    #    LET l_sql = l_sql CLIPPED,
## #                    #    "  UNION ",
## #                    #    " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1,",
## #                    #    "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 " 
## #                    #ELSE
## #                    #FUN-A40026 mark
## #                        LET l_sql = l_sql CLIPPED,    
## #                        "  UNION ",
## #                        " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19)*-1,", 
## #                        "        '",l_asg06_asq10,"','",l_asg08,"','1','N',ass07 "
## #                    #END IF  #FUN-A40026 mark
## #                END IF
## #----------FUN-A60038 mark--------------
## 
##                 LET l_sql = l_sql CLIPPED,    
##                 #--FUN-A30079 end---
##                 "   FROM ass_file ",
##                 "  WHERE ass01 ='",g_asa[i].asa01,"' ",
##                 #"   AND ass02 = '",g_asa[i].asa02,"'",              #FUN-970046 add
##                 #"    AND ass02 = '",tm.asa02,"'",                    #FUN-A30064  #FUN-A30079 mark 
##                 #"   AND ass00 ='",g_aaz641,"' ", 
##                 "    AND ass00 ='",g_aaz641_asq10,"' ",                  #FUN-A30079
##                 #"    AND ass14 ='",x_aaa03,"' ",                      #FUN-760053  #FUN-A30079 mark
##                 "    AND ass04 ='",g_asq.asq10,"' ",                  #對沖公司
##                 "    AND ass041='",l_asq10_asg05,"' ",                #對沖帳別  
##                 "    AND ass08 = ",tm.yy,
##                 "    AND ass07 = '",l_asg08,"'",                      #FUN-960096
##                 "    AND ass09 = '",tm.em,"'",                        #FUN-970046 mod
##                 "    AND ass05 = '",g_asq.asq02,"'"                   #FUN-970046 mod
##                 #--FUN-A60060 mark--
##                 ##--FUN-A30079 start--
##                 ##"  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 ##IF g_cnt_asq10 > 0 THEN  #FUN-A6060 mark
##                 #    LET l_sql = l_sql CLIPPED,
##                 #        "    AND ass02 = '",g_asq.asq10,"'", 
##                 #        "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##                 #END IF
##                 ##--FUN-A30079 end---
##                 #--FUN-A60060 mark---
##           END CASE
##           #--FUN-A60060 start---
##           #A.來源公司=合併主體：(順流)
##           #  目的:asr02 = 不用加入此條件, asr04 = 自己
##           #B.來源公司 <> 合併主體：(側流或逆流)
##           #  IF 目的屬於上層公司
##           #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
##           #    2.中間層(有上層也有下層):
##           #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
##           #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
##           #  ELSE
##           #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
##           #  END IF
##            
##           #--FUN-A70011 mark--
##           #IF g_asq.asq09 = g_asq.asq16 THEN     #FUN-A60078
##           #    IF g_asq.asq14 = 'Y' THEN         #FUN-A60099
##           #        LET l_sql = l_sql CLIPPED,        #FUN-A60078
##           #            "    AND ass02 = '",l_asa02_asq10,"'"   #FUN-A60078
##           #    ELSE                                            #FUN-A60099
## 	  #        LET l_sql = l_sql CLIPPED,                  #FUN-A60099
## 	  #            "    AND ass02 = '",g_asq.asq10,"'"     #FUN-A60099
##           #    END IF                                          #FUN-A60099
##           #ELSE                                  #FUN-A60078
##           #--FUN-A70011 mark--
##               IF g_cnt_asq10 > 0 THEN
##                   IF l_low_asq10 = 0 THEN #最上層
##                       LET l_sql = l_sql CLIPPED,
##                           "    AND ass02 = '",g_asq.asq10,"'"
##                   ELSE
##                       IF l_up_asq10 > 0 THEN    #FUN-A60078   #大於0代表為中間層
##                           IF g_asq.asq14 = 'Y' THEN  #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,
##                                   "    AND ass02 = '",l_asa02_asq10,"'"
##                           ELSE                                           #FUN-A60099
##                               LET l_sql = l_sql CLIPPED,                 #FUN-A60099
##                                   "    AND ass02 = '",g_asq.asq10,"'"    #FUN-A60099 
##                           END IF                                         #FUN-A60099
##                       END IF                    #FUN-A60078
##                   END IF
##               #--FUN-A70011 start-
##               ELSE
##                   LET l_sql = l_sql CLIPPED,
##                      "    AND ass02 = '",l_asa02_asq10,"'"
##               #--FUN-A70011 end--
##               END IF
##           #END IF    #FUN-A70011 mark
##           LET l_sql = l_sql CLIPPED,
##               "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
##           #--FUN-A60060 end--------
##     END IF
##
##     PREPARE p001_asr_misc_p1 FROM l_sql
##     IF STATUS THEN 
##        LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                  
##
##        CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:6',STATUS,1)  
##        LET g_success = 'N'  
##     END IF 
##     DECLARE p001_asr_misc_c1 CURSOR FOR p001_asr_misc_p1
##     
##     FOREACH p001_asr_misc_c1 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
##                              g_asr.asr02,g_asr.asr04,g_asr.asr08,
##                              g_asr.asr12,   #FUN-A30079 
##                              g_affil,g_dc,g_flag_r,g_ass07
##       IF SQLCA.sqlcode THEN 
##          LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy                                    #NO.FUN-710023
##          CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p001_asr_misc_1',SQLCA.sqlcode,1) 
##          LET g_success = 'N' 
##          CONTINUE FOREACH  
##       END IF
##       LET l_asg08 = ''
##   
##       IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
##
##       #先將資料寫進TempTable裡 
##       EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asr.asr05,
##                                 g_asr.asr02,g_asr.asr04,g_asr.asr08,
##                                 g_asr.asr12,            #FUN-A30079 
##                                 g_affil,g_dc,g_flag_r
##     END FOREACH
##------FUN-A80137 mark----------------------------
#
#
#     IF p_asq02 = 'MISC' THEN
#         #IF p_asq15 = '1' THEN
#         IF p_asq17 = '1' THEN     #FUN-A80137 mod
#             #貸 子公司 少數股權,少數股權淨利
#             #依據公式設定(對沖科目中asu04=Y)
#             DECLARE p001_asu_cs CURSOR FOR
#                SELECT DISTINCT asu03,asu04,asu05 FROM asu_file 
#                 #WHERE asu00 = g_aaz641   #FUN-920067 mod
#                 WHERE asu00 = g_aaz641_asq09 #FUN-A30079
#                   AND asu01 = g_asq.asq02
#                   AND asu09 = g_asq.asq09
#                   AND asu10 = g_asq.asq10
#                   #AND asu12 = g_aaz641    #FUN-920067
#                   AND asu12 =  g_aaz641_asq10 #FUN-A30079
#                   AND asu04 = 'Y'             #是否依據公式設定]
#                   AND asu13 = g_asq.asq13 #FUN-930117
#             FOREACH p001_asu_cs INTO g_asv03
#                  #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                      LET l_sql =
#                      " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",     #MOD-910248  #FUN-930144 mod
#                      #"        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "  #FUN-A30079 add asr12
#                      #"        asr12,'",l_asg08_asq10,"','2','Y' "                #FUN-A60038 mod
#                      "        asr12,'",g_asg08_asq10,"','2','Y' "                 #FUN-A90006
# #---FUN-A60038 mark--
# #                  #---FUN-A30079 start--
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_asq.asq14 = 'Y' THEN 
# #                      #    LET l_sql =
# #                      #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",     #MOD-910248  #FUN-930144 mod
# #                      #    "        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "  #FUN-A30079 add asr12
# #                      #ELSE    
# #                      #FUN-A40026 mark
# #                          LET l_sql =
# #                           " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14),",    
# #                           "        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "
# #                      #END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark----
#                   LET l_sql = l_sql CLIPPED,
#                   #---FUN-A30079 end---
#                   "   FROM asr_file ",
#                   "  WHERE asr01 ='",g_asa[i].asa01,"' ",
#                   #"    AND asr00 ='",g_aaz641,"' ",     #FUN-760053   #FUN-920067 mod
#                   "    AND asr00 ='",g_aaz641_asq10,"' ",   #FUN-A30079
#                   #"   AND asr12 ='",x_aaa03,"' ",       #FUN-760053   #FUN-A30079 mark
#                   "    AND asr04 ='",g_asq.asq10,"' ",   #對沖公司
#                   #"    AND asr041='",l_asq10_asg05,"' ", #對沖帳別  #FUN-920067
#                   "    AND asr041='",g_asq10_asg05,"' ", #對沖帳別   #FUN-A90006
#                   "    AND asr06 = ",tm.yy,
#                   "    AND asr07 = '",tm.em,"'"          #FUN-970046 add
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark--
#                   #IF g_asq.asq09 = g_asq.asq16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND asr02 = '",l_asa02_asq10,"'"   #
#                   #ELSE
#                   #--FUN-A70011 mark--
#                       IF g_cnt_asq10 > 0 THEN
#                           #IF l_low_asq10 = 0 THEN #最上層
#                           IF g_low_asq10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND asr02 = '",g_asq.asq10,"'"
#                           ELSE
#                               #IF l_up_asq10 > 0 THEN
#                               IF g_up_asq10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND asr02 = '",l_asa02_asq10,"'"
#                                       "    AND asr02 = '",g_asa02_asq10,"'"    #FUN-A90006
#                               END IF
#                          END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND asr02 = '",l_asa02_asq10,"'"
#                           "    AND asr02 = '",g_asa02_asq10,"'"     #FUN-A90006
#                       END IF
#                       #--FUN-A70011 end--
#                   #END IF
# #---FUN-A60078 end--
#                   LET l_sql = l_sql CLIPPED,
#                   #--FUN-A30079 end----       
#                   "    AND asr05 IN (SELECT DISTINCT asv04 FROM asv_file ",
#                   #"                   WHERE asv00 = '",g_aaz641,"'",    #FUN-920067
#                   "                   WHERE asv00 = '",g_aaz641_asq09,"'",  #FUN-A30079
#                   "                     AND asv01 = '",g_asq.asq02,"'",
#                   "                     AND asv09 = '",g_asq.asq09,"'",
#                   "                     AND asv10 = '",g_asq.asq10,"'",
#                   #"                    AND asv12 = '",g_aaz641,"'",     #FUN-920067
#                   "                     AND asv12 = '",g_aaz641_asq10,"'",  #FUN-A30079
#                   "                     AND asv13 = '",g_asq.asq13,"'",　#FUN-930117
#                   "                     AND asv05 = '+'",
#                   "                     AND asv03 = '",g_asv03,"')"
#                   #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                   #--TQC-AA098 mark
#                   #    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                   #    "  UNION ",
#                   #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-930144 mod
#                   #    #"        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "    #FUN-A30079 add asr12
#                   #    #"        asr12,'",l_asg08_asq10,"','2','Y' "      #FUN-A60038 
#                   #    "        asr12,'",g_asg08_asq10,"','2','Y' "       #FUN-A90006
#                   #--TQC-AA0098 mark
# #----FUN-A60038 mark--
# #                 #--FUN-A30079 start--
#                   #ELSE
#                       #FUN-A40026 mark
#                       #IF g_asq.asq14 = 'Y' THEN
#                       #    LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                       #    "  UNION ",
#                       #    " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",  #FUN-930144 mod
#                       #    "        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "    #FUN-A30079 add asr12
#                       #ELSE
#                       #FUN-A40026 mark
#                           LET l_sql = l_sql CLIPPED,     
#                           "  UNION ",
#                           " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,",  #FUN-930144 mod
#                           #"        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "
#                           "        '",g_asg06_asq10,"','",g_asg08_asq10,"','2','Y' "  #FUN-A90006
#                       #END IF  #FUN-A40026 mark
#                   #END IF
# #---FUN-A60038 mark----
#                   LET l_sql = l_sql CLIPPED,    
#                   #--FUN-A30079 end---
#                   "   FROM asr_file ",
#                   "  WHERE asr01 ='",g_asa[i].asa01,"' ",
#                   #"    AND asr00 ='",g_aaz641,"' ",
#                   "    AND asr00 ='",g_aaz641_asq10,"' ",  #FUN-A30079
#                   #"   AND asr12 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND asr04 ='",g_asq.asq10,"' ",   #對沖公司
#                   #"    AND asr041='",l_asq10_asg05,"' ",   #對沖帳別 
#                   "    AND asr041='",g_asq10_asg05,"' ",   #對沖帳別   #FUN-A90006
#                   "    AND asr06 = ",tm.yy,
#                   "    AND asr07 = '",tm.em,"'",           #FUN-970046 add
#                   "    AND asr05 IN (SELECT DISTINCT asv04 FROM asv_file ",
#                   #"                   WHERE asv00 = '",g_aaz641,"'", 
#                   "                   WHERE asv00 = '",g_aaz641_asq09,"'",   #FUN-A30079
#                   "                     AND asv01 = '",g_asq.asq02,"'",
#                   "                     AND asv09 = '",g_asq.asq09,"'",
#                   "                     AND asv10 = '",g_asq.asq10,"'",
#                   #"                     AND asv12 = '",g_aaz641,"'",
#                   "                     AND asv12 = '",g_aaz641_asq10,"'",   #FUN-A30079
#                   "                     AND asv13 = '",g_asq.asq13,"'",
#                   "                     AND asv05 = '-'",
#                   "                     AND asv03 = '",g_asv03,"')"
#                   #--FUN-A30079 start--
#                   #"  ORDER BY asr06,asr07,asr05,asr02,asr04 " 
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark--
#                   #IF g_asq.asq09 = g_asq.asq16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND asr02 = '",l_asa02_asq10,"'" ,
#                   #                "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
#                   #ELSE
#                   #--FUN-A70011 mark--
#                       IF g_cnt_asq10 > 0 THEN
#                           #IF l_low_asq10 = 0 THEN #最上層
#                           IF g_low_asq10 = 0 THEN #最上層    #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND asr02 = '",g_asq.asq10,"'" ,
#                                   "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
#                           ELSE
#                               #IF l_up_asq10 > 0 THEN
#                               IF g_up_asq10 > 0 THEN         #10027
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND asr02 = '",l_asa02_asq10,"'",
#                                       "    AND asr02 = '",g_asa02_asq10,"'",   #FUN-A90006
#                                       "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
#                               END IF
#                          END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND asr02 = '",l_asa02_asq10,"'",
#                           "    AND asr02 = '",g_asa02_asq10,"'",       #FUN-A90006
#                           "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#                   PREPARE p001_misc_p2 FROM l_sql
#                   IF STATUS THEN 
#                      LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
#                      CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
#                   DECLARE p001_misc_c2 CURSOR FOR p001_misc_p2
#      
#                   FOREACH p001_misc_c2 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
#                                             g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                             g_asr.asr12,   #FUN-A30079 
#                                             g_affil,g_dc,g_flag_r
#                      IF SQLCA.sqlcode THEN 
#                         LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy                                    #NO.FUN-710023
#                         CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p001_misc_c2',SQLCA.sqlcode,1)   #NO.FUN-710023
#                         LET g_success = 'N' 
#                         CONTINUE FOREACH  
#                      END IF
# 
#                      IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
# 
#                      #先將資料寫進TempTable裡 
#                      EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asv03,   #將asr05改成寫入asv03
#                                                g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                                g_asr.asr12,   #FUN-A30079 
#                                                g_affil,g_dc,g_flag_r
#                   END FOREACH
#              END FOREACH
#             # -- FUN-A90036 start--
#             IF g_asq.asq14 = 'Y' THEN 
#                 #--TQC-AA098 start-換匯差額的累換數是否加入沖銷分錄需依對沖設定
#                 DECLARE p001_asu_cs2 CURSOR FOR
#                    SELECT DISTINCT asu03 FROM asu_file
#                     WHERE asu00 = g_aaz641_asq09
#                       AND asu01 = g_asq.asq02
#                       AND asu09 = g_asq.asq09
#                       AND asu10 = g_asq.asq10
#                       AND asu12 = g_aaz641_asq10
#                       AND asu13 = g_asq.asq13
#                 FOREACH p001_asu_cs2 INTO l_asu03
#                     #---TQC-AA0098 end--
#                     DECLARE p001_adj_cs CURSOR FOR
#                      #SELECT ask03,ask05,(ask07-ask071) FROM p001_adj_tmp
#                      SELECT ask03,ask05,ask06,(ask07-ask071) FROM p001_adj_tmp    #TQC-AA0098
#                       #WHERE ask05 = g_asq.asq10        #TQC-AA0098 mark
#                           WHERE ask05 = g_asg08_asq10   #TQC-AA0098 mod
#                             AND ask03 = l_asu03         #TQC-AA0098 add
#
#                      #FOREACH p001_adj_cs INTO l_ask03,l_ask05,g_asr.asr08
#                      FOREACH p001_adj_cs INTO l_ask03,l_ask05,l_ask06,g_asr.asr08   #TQC-AA0098
#
#                        IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
#
#                        #LET g_affil  = g_asq.asq09
#                        LET g_affil  = l_ask05    #TQC-AA0098
#                        LET g_flag_r = 'N'
#                            #--TQC-AA0098 start-借貸需與換匯差額的累換相反加入對沖分錄 
#                            IF g_asr.asr08 < 0 THEN
#                                IF l_ask06 = '1' THEN LET g_dc = '1' ELSE LET g_dc = '2' END IF
#                            ELSE
#                                IF l_ask06 = '1' THEN LET g_dc = '2' ELSE LET g_dc = '1' END IF
#                            END IF
#                            #-TQC-AA0098 end--
#                        #先將資料進TempTable
#                        EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,l_ask03,
#                                                  g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                                  g_asr.asr12,
#                                                  g_affil,g_dc,g_flag_r
#                      END FOREACH
#                  END FOREACH   #TQC-AA0098 
#              END IF                 
#             # --FUN-A90036 end --  取出換匯差額的累換數值 ---
#          ELSE
#              #貸 子公司 少數股權,少數股權淨利
#              #依據公式設定(對沖科目中asu04=Y)
#              DECLARE p001_asu_cs1 CURSOR FOR
#                 SELECT DISTINCT asu03,asu04,asu05 FROM asu_file 
#                  #WHERE asu00 = g_aaz641   #FUN-920067 mod
#                  WHERE asu00 = g_aaz641_asq09 #FUN-A30079
#                    AND asu01 = g_asq.asq02
#                    AND asu09 = g_asq.asq09
#                    AND asu10 = g_asq.asq10
#                    #AND asu12 = g_aaz641    #FUN-920067
#                    AND asu12 = g_aaz641_asq10  #FUN-A30079
#                    AND asu04 = 'Y'             #是否依據公式設定]
#                    AND asu13 = g_asq.asq13 #FUN-930117
#              FOREACH p001_asu_cs1 INTO g_asv03
#                   #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                       LET l_sql =
#                       " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11),",  
#                       #"        '",l_asg06_asq10,"','",g_asq.asq10,"','2','Y' "         #FUN-A30079 add ass14
#                       "        ass14,'",g_asq.asq10,"','2','Y' "          #FUN-A60038 mod
# #----FUN-A60038 mark---
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_asq.asq14 = 'Y' THEN
# #                      #    LET l_sql =
# #                      #    " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11),",  
# #                      #    "        '",l_asg06_asq10,"','",g_asq.asq10,"','2','Y' "       
# #                      #ELSE
# #                      #FUN-A40026 mark
# #                          LET l_sql =
# #                          " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19),",  
# #                          "        '",l_asg06_asq10,"','",g_asq.asq10,"','2','Y' "
# #                     END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark---
#                   LET l_sql = l_sql CLIPPED,
#                   #---FUN-A30079 end----
#                   "   FROM ass_file ",
#                   "  WHERE ass01 ='",g_asa[i].asa01,"' ",
#                   #"    AND ass00 ='",g_aaz641,"' ",
#                   "    AND ass00 ='",g_aaz641_asq10,"' ",  #FUN-A30079
#                   #"   AND ass14 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND ass04 ='",g_asq.asq10,"' ",   #對沖公司
#                   #"    AND ass041='",l_asq10_asg05,"' ", #對沖帳別  
#                   "    AND ass041='",g_asq10_asg05,"' ", #對沖帳別    #FUN-A90006
#                   #"    AND ass07 = '",l_asg08,"'",       #FUN-960096
#                   "    AND ass07 = '",g_asg08,"'",       #FUN-960096  #FUN-A90006
#                   "    AND ass08 = ",tm.yy,
#                   "    AND ass09 = '",tm.em,"'"     #FUN-970046 add
# #--FUN-A60078 start--
#                   #--FUN-A70011 mark
#                   #IF g_asq.asq09 = g_asq.asq16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND ass02 = '",l_asa02_asq10,"'"
#                   #ELSE
#                   #--FUN-A70011 mark
#                       IF g_cnt_asq10 > 0 THEN
#                           #IF l_low_asq10 = 0 THEN #最上層
#                           IF g_low_asq10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND ass02 = '",g_asq.asq10,"'"
#                           ELSE
#                               #IF l_up_asq10 > 0 THEN
#                               IF g_up_asq10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND ass02 = '",l_asa02_asq10,"'"
#                                       "    AND ass02 = '",g_asa02_asq10,"'"   #FUN-A90006
#                               END IF
#                           END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND ass02 = '",l_asa02_asq10,"'"
#                           "    AND ass02 = '",g_asa02_asq10,"'"               #FUN-A90006
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#                   LET l_sql = l_sql CLIPPED,
#                   #--FUN-A30079 end----       
#                   "    AND ass05 IN (SELECT DISTINCT asv04 FROM asv_file ",
#                   #"                   WHERE asv00 = '",g_aaz641,"'",  
#                   "                   WHERE asv00 = '",g_aaz641_asq09,"'",    #FUN-A30079
#                   "                     AND asv01 = '",g_asq.asq02,"'",
#                   "                     AND asv09 = '",g_asq.asq09,"'",
#                   "                     AND asv10 = '",g_asq.asq10,"'",
#                   #"                     AND asv12 = '",g_aaz641,"'",  
#                   "                     AND asv12 = '",g_aaz641_asq10,"'",    #FUN-A30079
#                   "                     AND asv13 = '",g_asq.asq13,"'",　
#                   "                     AND asv05 = '+'",
#                   "                     AND asv03 = '",g_asv03,"')"
#                   #IF g_cnt_asq10 > 0 THEN   #目的公司屬於上層公司        #FUN-A30079  #FUN-A60038 mark
#                       LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                       "  UNION ",
#                       " SELECT ass08,ass09,ass05,ass02,ass04,(ass08-ass09)*-1,",
#                       #"        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "  #FUN-A30079 add ass14
#                       #"        ass14,'",l_asg08_asq10,"','2','Y' "   #FUN-A60038 mod
#                       "        ass14,'",g_asg08_asq10,"','2','Y' "   #FUN-A90006
# #----FUN-A60038 mark--
# #                  #--FUN-A30079 start---
# #                  ELSE
# #                      #FUN-A40026 mark
# #                      #IF g_asq.asq14 = 'Y' THEN
# #                      #    LET l_sql = l_sql CLIPPED,                       
# #                      #    "  UNION ",
# #                      #    " SELECT ass08,ass09,ass05,ass02,ass04,(ass08-ass09)*-1,",
# #                      #    "        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "
# #                      #ELSE
# #                      #FUN-A40026 mark
# #                          LET l_sql = l_sql CLIPPED,    
# #                          "  UNION ",
# #                          " SELECT ass08,ass09,ass05,ass02,ass04,(ass18-ass19)*-1,",
# #                          "        '",l_asg06_asq10,"','",l_asg08_asq10,"','2','Y' "
# #                      #END IF  #FUN-A40026 mark
# #                  END IF
# #---FUN-A60038 mark---
#                   LET l_sql = l_sql CLIPPED,    
#                   #---FUN-A30079 end---
#                   "   FROM ass_file ",
#                   "  WHERE ass01 ='",g_asa[i].asa01,"' ",
#                   #"    AND ass00 ='",g_aaz641,"' ",
#                   "    AND ass00 ='",g_aaz641_asq10,"' ",  #FUN-A30079
#                   #"   AND ass14 ='",x_aaa03,"' ",      #FUN-A30079 mark
#                   "    AND ass04 ='",g_asq.asq10,"' ",   #對沖公司
#                   #"    AND ass041='",l_asq10_asg05,"' ", #對沖帳別 
#                   "    AND ass041='",g_asq10_asg05,"' ", #對沖帳別    #FUN-A90006
#                   "    AND ass08 = ",tm.yy,
#                   #"    AND ass07 = '",l_asg08,"'",  #FUN-960096
#                   "    AND ass07 = '",g_asg08,"'",  #FUN-960096       #FUN-A90006
#                   "    AND ass09 = '",tm.em,"'",    #FUN-970046 add
#                   "    AND ass05 IN (SELECT DISTINCT asv04 FROM asv_file ",
#                   #"                   WHERE asv00 = '",g_aaz641,"'", 
#                   "                   WHERE asv00 = '",g_aaz641_asq09,"'",   #FUN-A30079
#                   "                     AND asv01 = '",g_asq.asq02,"'",
#                   "                     AND asv09 = '",g_asq.asq09,"'",
#                   "                     AND asv10 = '",g_asq.asq10,"'",
#                   #"                    AND asv12 = '",g_aaz641,"'",
#                   "                     AND asv12 = '",g_aaz641_asq10,"'",   #FUN-A30079
#                   "                     AND asv13 = '",g_asq.asq13,"'",
#                   "                     AND asv05 = '-'",
#                   "                     AND asv03 = '",g_asv03,"')"
#                   #--FUN-A30079 start--
#                   #"  ORDER BY ass08,ass09,ass05,ass02,ass04 "
# #--FUN-A60078 start-- 
#                   #--FUN-A70011 mark-
#                   #IF g_asq.asq09 = g_asq.asq16 THEN
#                   #    LET l_sql = l_sql CLIPPED,
#                   #                "    AND ass02 = '",l_asa02_asq10,"'",
#                   #                "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
#                   #ELSE
#                   #--FUN-A70011 mark-
#                       IF g_cnt_asq10 > 0 THEN
#                           #IF l_low_asq10 = 0 THEN #最上層
#                           IF g_low_asq10 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                   "    AND ass02 = '",g_asq.asq10,"'" ,
#                                   "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
#                           ELSE
#                               #IF l_up_asq10 > 0 THEN
#                               IF g_up_asq10 > 0 THEN        #FUN-A90006
#                                   LET l_sql = l_sql CLIPPED,
#                                       #"    AND ass02 = '",l_asa02_asq10,"'",
#                                       "    AND ass02 = '",g_asa02_asq10,"'",   #FUN-A90006
#                                       "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
#                               END IF
#                           END IF
#                       #--FUN-A70011 start--
#                       ELSE
#                           LET l_sql = l_sql CLIPPED,
#                           #"    AND ass02 = '",l_asa02_asq10,"'"
#                           "    AND ass02 = '",g_asa02_asq10,"'"   #FUN-A90006
#                       #--FUN-A70011 end--
#                       END IF
#                   #END IF    #FUN-A70011 mark
# #---FUN-A60078 end--
#
#                  PREPARE p001_misc_p3 FROM l_sql
#                  IF STATUS THEN 
#                     LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
#                     CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
#                  #DECLARE p001_misc_c3 CURSOR FOR p001_misc_p2
#                  DECLARE p001_misc_c3 CURSOR FOR p001_misc_p3   #FUN-A80130
#     
#                  FOREACH p001_misc_c3 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
#                                            g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                            g_asr.asr12,   #FUN-A30079 
#                                            g_affil,g_dc,g_flag_r
#                     IF SQLCA.sqlcode THEN 
#                        LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy                                    #NO.FUN-710023
#                        CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p001_misc_c3',SQLCA.sqlcode,1)   #NO.FUN-710023
#                        LET g_success = 'N' 
#                        CONTINUE FOREACH  
#                     END IF
#
#                     IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
#
#                     #先將資料寫進TempTable裡 
#                     EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asv03,   #將asr05改成寫入asv03
#                                               g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                                               g_asr.asr12,   #FUN-A30079
#                                               g_affil,g_dc,g_flag_r
#                  END FOREACH
#             END FOREACH 
#         END IF          
#     END IF    
#
#     DECLARE p001_tmp_cs CURSOR FOR
#        #SELECT asr06,asr07,asr05,asr02,asr04,SUM(asr08),affil,dc,flag_r
#        SELECT asr06,asr07,asr05,asr02,asr04,SUM(asr08),asr12,affil,dc,flag_r   #FUN-A30079
#          FROM p001_tmp
#         #GROUP BY asr06,asr07,asr05,asr02,asr04,affil,dc,flag_r
#         GROUP BY asr06,asr07,asr05,asr02,asr04,asr12,affil,dc,flag_r  #FUN-A30079
#         #ORDER BY asr06,asr07,asr05,asr02,asr04,affil,dc,flag_r
#         ORDER BY asr06,asr07,asr05,asr02,asr04,asr12,affil,dc,flag_r  #FUN-A30079
#                 #年    月
#     LET g_asr07_o = '' 
#     FOREACH p001_tmp_cs INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
#                              g_asr.asr02,g_asr.asr04,g_asr.asr08,
#                              g_asr.asr12,   #FUN-A30079
#                              g_affil,g_dc,g_flag_r
#        IF SQLCA.sqlcode THEN 
#           LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy                                    #NO.FUN-710023
#           CALL s_errmsg('ass01,ass04,ass041,ass08',g_showmsg,'p001_tmp_cs',SQLCA.sqlcode,1)   #NO.FUN-710023
#           LET g_success = 'N'
#           CONTINUE FOREACH 
#        END IF
#
#        CALL s_ymtodate(g_asr.asr06,g_asr.asr07,g_asr.asr06,g_asr.asr07)
#               RETURNING g_bdate,g_edate
#
#        IF NOT cl_null(g_asr07_o) AND g_asr07_o<>g_asr.asr07 AND 
#           NOT cl_null(g_asj.asj01) THEN
#           CALL p001_ins_ask2()   #寫入差異分錄
#           IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF   #FUN-770069 add
#        END IF
#
#        #--a抓持股比率
#        CALL get_rate()  
#        
#        LET l_cnt = 0
#        
#        SELECT COUNT(*) INTO l_cnt FROM asj_file  #判斷是否已存在單頭
#         WHERE asj00 = g_aaz641      #帳別   #FUN-920067
#           AND asj02 = g_edate       #單據日期
#           AND asj03 = g_asr.asr06   #調整年度
#           AND asj04 = g_asr.asr07   #調整月份
#           AND asj05 = tm.asa01      #族群編號
#          #AND asj06 = tm.asa02      #上層公司編號
#           AND asj06 = g_asq.asq16   #合併主體公司編號  #FUN-A30079
#           AND asj07 = tm.asa03      #上層帳別
#           AND asj08 = '2'           #資料來源-2.資料匯入   #FUN-770069 add
#           AND asj21 = tm.ver        #MOD-930210 add
#           AND asj081 = '1'          #FUN-A90036
#           AND asj09 = 'N'           #FUN-A90036 
#        IF l_cnt = 0 THEN     #沒有符合的資料才要新增
#           LET g_yy=g_asr.asr06 
#           LET g_mm=g_asr.asr07 
#           CALL p001_ins_asj() 
#        ELSE                  #取出單頭資料以供後續寫入ask時用
#           SELECT * INTO g_asj.* FROM asj_file
#            WHERE asj00 = g_aaz641   #FUN-920067
#              AND asj02 = g_edate
#              AND asj03 = g_asr.asr06
#              AND asj04 = g_asr.asr07
#              AND asj05 = tm.asa01
#             #AND asj06 = tm.asa02
#              AND asj06 = g_asq.asq16   #FUN-A30079
#              AND asj07 = tm.asa03
#              AND asj08 = '2'           #FUN-770069 add
#              AND asj081 = '1'          #FUN-A90036
#              AND asj21 = tm.ver        #MOD-930210 add
#              AND asj09 = 'N'           #FUN-A90036 
#        END IF
#        
#        #-->寫入調整與銷除分錄底稿單身
#        IF NOT cl_null(g_asj.asj01) THEN    #當單頭檔(asj_file)的傳票號碼(asj01)有值石才需計算差異
#           CALL p001_ins_ask1()
#        END IF
#        IF g_success = 'N' THEN RETURN  END IF
#        LET g_asr07_o=g_asr.asr07   #期別舊值備份
#     END FOREACH
#
#     #當單頭檔(asj_file)的傳票號碼(asj01)有值時才需計算差異
#     IF NOT cl_null(g_asj.asj01) THEN    
#        CALL p001_ins_ask2()   #寫入差異分錄
#     END IF
#     IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF
#     LET p_asq01 = ''
#     LET p_asq02 = ''
#END FUNCTION
#FUN-B50001-----mark--end

FUNCTION p001_chkaah(p_aah01,p_aah03,p_aah04,p_asb05)
DEFINE p_aah01    LIKE aah_file.aah01
DEFINE p_aah03    LIKE aah_file.aah03
DEFINE p_aah04    LIKE aah_file.aah04
DEFINE p_asb05    LIKE asb_file.asb05
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
            "    AND aba00 = '",p_asb05,"' ",            
            "    AND aba03 = '",tm.yy,"' ",
            "    AND aba04 = '",p_aah03,"' ",
            "    AND aba06 = 'CE' ",
            "    AND abb03 = '",p_aah01,"' ",
            "    AND aba19 <> 'X' "   #CHI-C80041

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
FUNCTION p001_asf(p_i,p_aag01,p_ash06,p_date)  #TQC-AA0098 取消mark
#FUNCTION p001_asf(p_i,p_ash06,p_date)   #FUN-A90026   #TQC-AA0098 mark
DEFINE p_aag01  LIKE aag_file.aag01
DEFINE p_ash06  LIKE ash_file.ash06
DEFINE p_date   LIKE type_file.dat 
DEFINE l_aag06  LIKE aag_file.aag06
DEFINE l_asf13  LIKE asf_file.asf13
DEFINE l_chg_dr LIKE aah_file.aah04             #借方金額
DEFINE l_chg_cr LIKE aah_file.aah05             #貸方金額
DEFINE l_cut    LIKE type_file.num5             #幣別取位(功能幣別)                  
DEFINE p_i      LIKE type_file.num5
DEFINE l_asf16  LIKE asf_file.asf16             #FUN-A70086
DEFINE l_fun_dr      LIKE aah_file.aah04        #功能幣借方 #FUN-A70086
DEFINE l_fun_cr      LIKE aah_file.aah04        #功能幣貸方 #FUN-A70086

    DECLARE p001_asf_cs1 CURSOR FOR p001_asf_p
    OPEN p001_asf_cs1 
    USING g_dept[p_i].asa01,g_dept[p_i].asb04,
          #p_aag01,p_ash06,p_date
          p_ash06,p_date    #FUN-A90026 
    FETCH p001_asf_cs1                      
    #INTO l_aag06,l_asf13                   
    INTO l_aag06,l_asf16,l_asf13                #FUN-A70086     

    IF l_asf13 > 0 THEN 
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
             LET l_fun_dr=l_asf16          #FUN-A70086
             LET l_chg_dr=l_asf13          #借
             LET l_fun_cr=0                #FUN-A70086
             LET l_chg_cr=0                #貸
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=0                 #FUN-A70086
            LET l_chg_dr=0                 
            LET l_chg_cr=l_asf13          
            LET l_fun_cr=l_asf16           #FUN-A70086
        END IF
    ELSE
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
            LET l_fun_dr=0                      #FUN-A70086
            LET l_chg_dr=0
            LET l_chg_cr=(l_asf13 *-1)
            LET l_fun_cr=(l_asf16 *-1)          #FUN-A70086
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=(l_asf16*-1)           #FUN-A70086
            LET l_chg_dr=(l_asf13*-1)
            LET l_chg_cr=0
            LET l_fun_cr=0                      #FUN-A70086
        END IF
    END IF
    #RETURN l_chg_dr,l_chg_cr

    #--FUN-A70086 start--
    LET l_rate = 1
    LET l_rate1 = 1
    SELECT asf15,asf12
    INTO l_rate,l_rate1  
     FROM asf_file
    WHERE asf01= g_dept[p_i].asa01
      AND asf02= g_dept[p_i].asb04
      AND asf07= p_aag01
      AND asf03= p_ash06
      AND asf06<=p_date
  #---FUN-A70086 end-----
    IF cl_null(l_rate) THEN LET l_rate = 1 END IF  #TQC-AA0098
    IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF   #TQC-AA0098
    RETURN l_fun_dr,l_fun_cr,l_chg_dr,l_chg_cr  #FUN-A70086
END FUNCTION

#--依匯率計算下層公司功能幣---------
#FUNCTION p001_fun_amt(p_aag04,p_dr,p_cr,p_ash11,p_asg06,p_asg07,p_yy,p_mm)           #FUN-B70064 mark
FUNCTION p001_fun_amt(p_aag04,p_dr,p_cr,p_ash11,p_asg06,p_asg07,p_yy,p_mm,p_asa05)    #FUN-B70064 add
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash11    LIKE ash_file.ash11
DEFINE p_asg06    LIKE asg_file.asg06
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_fun_dr   LIKE aah_file.aah04
DEFINE l_fun_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut      LIKE type_file.num5   
DEFINE p_asa05    LIKE asa_file.asa05    #FUN-B70064 add

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
    IF p_asg06 != p_asg07 THEN 
        #功能幣別匯率
        IF p_ash11 <> '3' THEN    #FUN-B70064   #不採平均匯率時直接取當期匯率
           CALL p001_getrate(p_ash11,l_bs_yy,l_bs_mm,
                             p_asg06,p_asg07)
           RETURNING l_rate
           IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
#---FUN-B70064 start
        ELSE
           IF p_asa05 != '3' THEN
               CALL p001_getrate1(p_aag04,p_asg06,p_asg07)
               RETURNING l_rate
           ELSE
               CALL p001_getrate3(p_ash11,l_bs_yy,l_bs_mm,
                                 p_asg06,p_asg07)
               RETURNING l_rate
               IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
           END IF
        END IF
#---FUN-B70064 end---
    END IF

    #->幣別轉換及取位
    LET l_fun_dr=p_dr * l_rate     #下層公司功能幣別借方金額
    LET l_fun_cr=p_cr * l_rate     #下層公司功能幣別貸方金額
   
    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg07                                                                               
    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                                                                                                                                         
    LET l_fun_dr=cl_digcut(l_fun_dr,l_cut)                                                                                                
    LET l_fun_cr=cl_digcut(l_fun_cr,l_cut)                                                                                                
    IF cl_null(l_fun_dr) THEN LET l_fun_dr=0 END IF                                                                                   
    IF cl_null(l_fun_cr) THEN LET l_fun_cr=0 END IF                                                                                   
    RETURN l_fun_dr,l_fun_cr
END FUNCTION

#--依匯率計算上層記帳幣---------
#FUNCTION p001_acc_amt(p_aag04,p_dr,p_cr,p_ash12,p_asg07,p_aaa03,p_yy,p_mm)     #FUN-B70064 MARK
FUNCTION p001_acc_amt(p_aag04,p_dr,p_cr,p_ash12,p_asg07,p_aaa03,p_yy,p_mm,p_asa05)      #FUN-B70064 ADD
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash12    LIKE ash_file.ash12
DEFINE p_aaa03    LIKE aaa_file.aaa03
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_acc_dr   LIKE aah_file.aah04
DEFINE l_acc_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut1     LIKE type_file.num5             #幣別取位(記帳幣別)
DEFINE p_asa05    LIKE asa_file.asa05    #FUN-B70064 add 

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
    IF p_asg07 != p_aaa03 THEN
        #記帳幣別匯率
        IF p_ash12 <> '3' THEN   #FUN-B70064
           CALL p001_getrate(p_ash12,l_bs_yy,l_bs_mm,
                             p_asg07,p_aaa03)
           RETURNING l_rate1
           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
#---FUN-B70064 start--
        ELSE
           IF p_asa05 != '3' THEN  #FUN-B70064 add
               CALL p001_getrate1(p_aag04,p_asg07,p_aaa03)
               RETURNING l_rate1
           ELSE
               CALL p001_getrate3(p_ash12,l_bs_yy,l_bs_mm,
                                 p_asg07,p_aaa03)
               RETURNING l_rate1
               IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF 
           END IF
        END IF
#---FUN-B70064 end---
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

#計算asr_file為來源的合併幣別(採平均匯率者)
FUNCTION p001_avg(p_ash11,p_ash12,p_aah01,p_asg06,p_asg07,p_yy,p_mm,p_i)
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE p_dr         LIKE aah_file.aah04
DEFINE p_cr         LIKE aah_file.aah05
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_acc_dr     LIKE aah_file.aah04
DEFINE l_acc_cr     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_asr08      LIKE asr_file.asr08
DEFINE l_asr09      LIKE asr_file.asr09
DEFINE p_yy         LIKE type_file.num5   #FUN-A90026
DEFINE p_mm         LIKE type_file.num5   #FUN-A90026
DEFINE l_month      LIKE type_file.num5   #FUN-A90026
DEFINE l_last_dr    LIKE asr_file.asr08   #FUN-A90026
DEFINE l_last_cr    LIKE asr_file.asr09   #FUN-A90026
DEFINE l_sum_asr08  LIKE asr_file.asr08   #FUN-A90026
DEFINE l_sum_asr09  LIKE asr_file.asr09   #FUN-A90026
DEFINE l_asr13      LIKE asr_file.asr13   #FUN-A90026
DEFINE l_asr14      LIKE asr_file.asr14   #FUN-A90026
DEFINE p_ash12      LIKE ash_file.ash12   #FUN-A90026
DEFINE p_ash11      LIKE ash_file.ash11   #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5   #FUN-A90026
DEFINE l_asg04      LIKE asg_file.asg04   #FUN-B60159

  LET l_asr08 = 0
  LET l_asr09 = 0
  LET l_sum_asr08 = 0
  LET l_sum_asr09 = 0
  LET l_asr13 = 0  #TQC-AA0098
  LET l_asr14 = 0  #TQC-AA0098

  SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01 = g_dept[p_i].asb04  #FUN-B60159

  LET l_sql=
   " SELECT asm06,asm07,asm08",
   "   FROM asm_file ",
   "  WHERE asm00 = '",g_asz01,"'",        #合併帳別 
   "    AND asm01 = '",g_dept[p_i].asa01,"'", #族群
   "    AND asm02 = '",g_dept[p_i].asb04,"'", #公司
   "    AND asm04 = '",p_aah01,"'",
   "    AND asm20 = ",tm.yy," AND asm21 = ",tm.em,        #No.FUN-C80020
   "    AND asm05 = '",tm.yy,"'"
#FUN-B60159--mod--str--
#  ,"    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
   IF l_asg04 = 'Y' THEN
      LET l_sql = l_sql CLIPPED,
                  "    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
   ELSE
      LET l_sql = l_sql CLIPPED,
                  "    AND asm06 ='",tm.em,"'"
   END IF 
#FUN-B60159--mod--end
   PREPARE p001_asm_p3 FROM l_sql
   DECLARE p001_asm_c3 CURSOR FOR p001_asm_p3
   FOREACH p001_asm_c3 INTO l_month,l_asr13,l_asr14
        IF l_month = 0 THEN LET l_month = 1 END IF
        IF p_asg06 != p_asg07 THEN 
            #功能幣別匯率
            CALL p001_getrate(p_ash11,p_yy,l_month,p_asg06,p_asg07)
            RETURNING l_rate
        END IF
        IF p_asg07 != x_aaa03 THEN 
            #合併幣別匯率
            CALL p001_getrate(p_ash12,p_yy,l_month,p_asg07,x_aaa03)
            RETURNING l_rate1
        END IF
        IF cl_null(l_rate) THEN LET l_rate = 1 END IF
        IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
        LET l_asr08 = l_asr13 * l_rate * l_rate1
        LET l_asr09 = l_asr14 * l_rate * l_rate1
        LET l_sum_asr08 = l_sum_asr08  + l_asr08
        LET l_sum_asr09 = l_sum_asr09  + l_asr09
  END FOREACH
  LET l_dr_sum = l_sum_asr08 
  LET l_cr_sum = l_sum_asr09 
  RETURN l_dr_sum,l_cr_sum
  #--FUN-A90026 end-----

#--FUN-A70053 mark-- 移至p001_fun_avg( )
#   IF p_type = '1' THEN  #記帳幣借/貸方異動額(同總帳)
#       CALL p001_fun_amt(p_aag04,p_dr,p_cr,
#                         '3',p_asg06,p_asg07,tm.yy,tm.em)
#       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
#
#       LET l_asr15 = 0
#       LET l_asr16 = 0
#       IF tm.em <> '1' THEN
#           SELECT asr15,asr16 INTO l_asr15,l_asr16
#             FROM asr_file
#           WHERE asr00 =g_aaz641
#             AND asr01 =g_dept[p_i].asa01
#             AND asr02 =g_dept[p_i].asa02
#             AND asr03 =g_dept[p_i].asa03
#             AND asr04 =g_dept[p_i].asb04
#             AND asr05 =g_aaz114
#             AND asr06 =tm.yy
#             AND asr07 =tm.em-1
#       END IF
#       LET l_dr_sum = l_asr15 + l_fun_dr
#       LET l_cr_sum = l_asr16 + l_fun_cr
#   ELSE
#--- FUN-A70053 mark------------------

#--FUN-A90026 mark-------
#       CALL p001_acc_amt(p_aag04,p_dr,p_cr,
#                         '3',p_asg07,x_aaa03,tm.yy,tm.em)
#       RETURNING l_acc_dr,l_acc_cr  
# 
#       LET l_asr08 = 0
#       LET l_asr09 = 0
#       IF tm.em <> '1' THEN
#           SELECT asr08,asr09 INTO l_asr08,l_asr09
#             FROM asr_file
#           WHERE asr00 =g_aaz641
#             AND asr01 =g_dept[p_i].asa01
#             AND asr02 =g_dept[p_i].asa02
#             AND asr03 =g_dept[p_i].asa03
#             AND asr04 =g_dept[p_i].asb04
#        #     AND asr05 =g_aaz114
#             AND asr05 =p_aah01    #FUN-A90006
#             AND asr06 =tm.yy
#             AND asr07 =tm.em-1
#       END IF
#
#       LET l_dr_sum = l_asr08 + l_acc_dr
#       LET l_cr_sum = l_asr09 + l_acc_cr
#   #END IF   #FUN-A70053 mark
#   RETURN l_dr_sum,l_cr_sum
#----FUN-A90026 mark--------

END FUNCTION
#----FUN-A60038 end---------

#--FUN-A70053 start------------
#計算asr_file為來源功能幣別(採平均匯率者)
#FUNCTION p001_fun_avg(p_type,p_dbs,p_aah01,p_aah00,p_aag04,p_asg06,p_asg07,p_i,p_dr,p_cr)
FUNCTION p001_fun_avg(p_ash11,p_aah01,p_asg06,p_asg07,p_yy,p_mm,p_i)   #FUN-A90026 mod
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE l_dr_sum LIKE aah_file.aah04
DEFINE l_cr_sum LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_asr08      LIKE asr_file.asr08
DEFINE l_asr09      LIKE asr_file.asr09
DEFINE l_asr15      LIKE asr_file.asr15
DEFINE l_asr16      LIKE asr_file.asr16
DEFINE l_last_fun_dr  LIKE asr_file.asr15  #FUN-A90026
DEFINE l_last_fun_cr  LIKE asr_file.asr16  #FUN-A90026
DEFINE l_sum_asr15  LIKE asr_file.asr15    #FUN-A90026 
DEFINE l_sum_asr16  LIKE asr_file.asr16    #FUN-A90026
DEFINE l_asr13      LIKE asr_file.asr13    #FUN-A90026
DEFINE l_asr14      LIKE asr_file.asr14    #FUN-A90026
DEFINE p_yy         LIKE aah_file.aah02    #FUN-A90026 
DEFINE p_mm         LIKE aah_file.aah03    #FUN-A90026 
DEFINE p_ash11      LIKE ash_file.ash11    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026
DEFINE l_asg04      LIKE asg_file.asg04    #FUN-B60159

  SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01 = g_dept[p_i].asb04  #FUN-B60159
  LET l_dr_sum = 0
  LET l_cr_sum = 0

  #--FUN-A90026 mark-
  #CALL p001_fun_amt(p_aag04,p_dr,p_cr,
  #                  '3',p_asg06,p_asg07,tm.yy,tm.em)
  #RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
  #--FUN-A90026 mark-

  LET l_asr15 = 0
  LET l_asr16 = 0

  #--FUN-A90026 start--
  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔asr_file之前要倒推匯率再存入(算完合併幣金額之後再推)

  LET l_asr13 = 0
  LET l_asr14 = 0
  LET l_asr15 = 0
  LET l_asr16 = 0
  LET l_sum_asr15 = 0
  LET l_sum_asr16 = 0
  LET l_sql=
  " SELECT asm06,asm07,asm08",
  "   FROM asm_file ",
  "  WHERE asm00 = '",g_asz01,"'",        #合併帳別 
  "    AND asm01 = '",g_dept[p_i].asa01,"'", #族群
  "    AND asm02 = '",g_dept[p_i].asb04,"'", #公司
  "    AND asm04 = '",p_aah01,"'",
  "    AND asm20 = ",tm.yy," AND asm21 = ",tm.em,        #No.FUN-C80020
  "    AND asm05 = '",tm.yy,"'"
#FUN-B60159--mod--str--
#  ,"    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  IF l_asg04 = 'Y' THEN
     LET l_sql = l_sql CLIPPED,
                 "    AND asm06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  ELSE
     LET l_sql = l_sql CLIPPED,
                 "    AND asm06 ='",tm.em,"'"
  END IF 
#FUN-B60159--mod--end
  PREPARE p001_asm_p1 FROM l_sql
  DECLARE p001_asm_c1 CURSOR FOR p001_asm_p1
  FOREACH p001_asm_c1 INTO l_month,l_asr13,l_asr14
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_asg06 != p_asg07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_ash11,p_yy,l_month,p_asg06,p_asg07)
           RETURNING l_rate
       END IF
       LET l_asr15 = l_asr13 * l_rate
       LET l_asr16 = l_asr14 * l_rate
       LET l_sum_asr15 = l_sum_asr15  + l_asr15
       LET l_sum_asr16 = l_sum_asr16  + l_asr16
  END FOREACH
  #--FUN-A90026 end-----

  #--FUN-A90026 mark----
  #IF tm.em <> '1' THEN   #FUN-A90026 mark
  #    SELECT asr15,asr16 INTO l_asr15,l_asr16
  #      FROM asr_file
  #    WHERE asr00 =g_aaz641
  #      AND asr01 =g_dept[p_i].asa01
  #      AND asr02 =g_dept[p_i].asa02
  #      AND asr03 =g_dept[p_i].asa03
  #      AND asr04 =g_dept[p_i].asb04
  # #     AND asr05 =g_aaz114
  #      AND asr05 =p_aah01    #FUN-A90006
  #      AND asr06 =tm.yy
  #      #AND asr07 =tm.em-1
  #      AND asr07 = l_mm      #FUN-A90026  mod
  #END IF
  #LET l_dr_sum = l_asr15 + l_fun_dr   #寫入功能幣的金額
  #LET l_cr_sum = l_asr16 + l_fun_cr
  #--FUN-A90026 mark---

  #LET l_dr_sum = l_sum_asr15 + l_last_fun_dr   #寫入功能幣的金額  #FUN-A90026 
  #LET l_cr_sum = l_sum_asr16 + l_last_fun_cr                      #FUN-A90026 
  LET l_dr_sum = l_sum_asr15 
  LET l_cr_sum = l_sum_asr16 

  #l_dr_sum/l_cr_sum: asa05 ='1'者適用(先累加各期金額後*最後一期匯率)
  #RETURN l_fun_dr,l_fun_cr,l_dr_sum,l_cr_sum  
  RETURN l_dr_sum,l_cr_sum     #FUN-A90026 mod
END FUNCTION
#--FUN-A70053 end-------------

#--FUN-A90006 start--
#計算ass_file為來源的合併幣別(採平均匯率者) 
#FUNCTION p001_ass_avg(p_type,p_dbs,p_aed01,p_aed02,p_aah00,p_aag04,p_asg06,p_asg07,p_i,p_dr,p_cr)
FUNCTION p001_ass_avg(p_ash11,p_ash12,p_aed01,p_aed02,p_asg06,p_asg07,p_yy,p_mm,p_i)   #FUN-A90026 mod
DEFINE l_sql        STRING
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_ass10      LIKE ass_file.ass10
DEFINE l_ass11      LIKE ass_file.ass11
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE l_last_dr    LIKE ass_file.ass10    #FUN-A90026
DEFINE l_last_cr    LIKE ass_file.ass11    #FUN-A90026
DEFINE p_yy         LIKE aah_file.aah02    #FUN-A90026 
DEFINE p_mm         LIKE aah_file.aah03    #FUN-A90026 
DEFINE l_ass18      LIKE ass_file.ass18    #FUN-A90026
DEFINE l_ass19      LIKE ass_file.ass19    #FUN-A90026
DEFINE l_ass20      LIKE ass_file.ass20    #FUN-A90026
DEFINE l_ass21      LIKE ass_file.ass21    #FUN-A90026
DEFINE p_ash12      LIKE ash_file.ash12    #FUN-A90026
DEFINE p_ash11      LIKE ash_file.ash11    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_sum_ass10  LIKE ass_file.ass10    #FUN-A90026
DEFINE l_sum_ass11  LIKE ass_file.ass11    #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026

#--FUN-A90026 mark-----------------------
#    CALL p001_acc_amt(p_aag04,p_dr,p_cr,
#                      '3',p_asg07,x_aaa03,tm.yy,tm.em)
#    RETURNING l_acc_dr,l_acc_cr
#
#    LET l_ass10 = 0
#    LET l_ass11 = 0
#    IF tm.em <> '1' THEN
#        SELECT ass10,ass11 INTO l_ass10,l_ass11
#          FROM ass_file
#        WHERE ass00 =g_aaz641
#          AND ass01 =g_dept[p_i].asa01
#          AND ass02 =g_dept[p_i].asa02
#          AND ass03 =g_dept[p_i].asa03
#          AND ass04 =g_dept[p_i].asb04
#          AND ass05 =p_aed01
#          AND ass07 =p_aed02
#          AND ass08 =tm.yy
#          AND ass09 = tm.em - 1
#    END IF
#
#    #--此時的l_acc_dr,l_acc_cr應為當月異動額*再衡量(非累計餘額)
#
#    LET l_dr_sum = l_ass10 + l_acc_dr
#    LET l_cr_sum = l_ass11 + l_acc_cr
#----FUN-A90026 mark--------------------

#--FUN-A90026 start--
  #--先處理依編製期別取每期金額後
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔ass_file之前要倒推匯率再存入
 
  #上一期合併幣金額：
  LET l_ass10 = 0
  LET l_ass11 = 0
  LET l_last_dr = 0
  LET l_last_cr = 0
  LET l_sum_ass10 = 0  #TQC-AA0098
  LET l_sum_ass11 = 0  #TQC-AA0098
  LET l_ass20  = 0  #TQC-AA0098
  LET l_ass21  = 0  #TQC-AA0098

  LET l_sql=
  " SELECT asn07,asn08,asn09",
  "   FROM asn_file ",
  "  WHERE asn00 = '",g_asz01,"'",        #合併帳別 
  "    AND asn01 = '",g_dept[p_i].asa01,"'", #族群
  "    AND asn02 = '",g_dept[p_i].asb04,"'", #公司
  "    AND asn04 = '",p_aed01,"'",
  "    AND asn05 = '",p_aed02,"'",
  "    AND asn20 = ",tm.yy," AND asn21 = ",tm.em,        #No.FUN-C80020
  "    AND asn06 = '",tm.yy,"'",
  "    AND asn07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_asn_p1 FROM l_sql
  DECLARE p001_asn_c1 CURSOR FOR p001_asn_p1
  FOREACH p001_asn_c1 INTO l_month,l_ass18,l_ass19
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_asg06 != p_asg07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_ash11,p_yy,l_month,p_asg06,p_asg07)
           RETURNING l_rate
       END IF
       IF p_asg07 != x_aaa03 THEN 
           #合併幣別匯率
           CALL p001_getrate(p_ash12,p_yy,l_month,p_asg07,x_aaa03)
           RETURNING l_rate1
       END IF
       IF cl_null(l_rate) THEN LET l_rate = 1 END IF
       IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
       LET l_ass20 = l_ass18 * l_rate * l_rate1
       LET l_ass21 = l_ass19 * l_rate * l_rate1
       LET l_sum_ass10 = l_sum_ass10  + l_ass20
       LET l_sum_ass11 = l_sum_ass11  + l_ass21
  END FOREACH
  LET l_dr_sum = l_sum_ass10 
  LET l_cr_sum = l_sum_ass11
  #---FUN-A90026 end------------

  RETURN l_dr_sum,l_cr_sum
END FUNCTION
#FUN-A90006 end-------

#--FUN-A80130 start---
#計算ass_file為來源功能幣別(採平均匯率者)
FUNCTION p001_fun_ass_avg(p_ash11,p_aed01,p_aed02,p_asg06,p_asg07,p_yy,p_mm,p_i)
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_ass20      LIKE ass_file.ass20
DEFINE l_ass21      LIKE ass_file.ass21
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE p_ash11      LIKE ash_file.ash11    #FUN-A90026
DEFINE l_last_ass20 LIKE ass_file.ass20    #FUN-A90026
DEFINE l_last_ass21 LIKE ass_file.ass21    #FUN-A90026
DEFINE l_sum_ass20  LIKE ass_file.ass20    #FUN-A90026
DEFINE l_sum_ass21  LIKE ass_file.ass21    #FUN-A90026
DEFINE l_ass18      LIKE ass_file.ass18    #FUN-A90026
DEFINE l_ass19      LIKE ass_file.ass19    #FUN-A90026
DEFINE p_yy         LIKE type_file.num5    #FUN-A90026
DEFINE p_mm         LIKE type_file.num5    #FUN-A90026
DEFINE l_sql        STRING                 #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026

  #--FUN-A90026 start--
  #--先處理依編製期別取每期金額
  #功能幣金額：(記帳幣*再衡量匯率 (0~迄期別)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率(0~迄期別))
  #例:1~6月各期記帳幣異動額各為100，
  #上一期(3月)功能金額：820
  #出6月季報時，應先記算0~6月各期金額=SUM(每期異動額*當期平均匯率)：
  #存檔ass_file之前要倒推匯率再存入(算完合併幣金額之後再推)
 
  LET l_sum_ass20 = 0   #TQC-AA0098
  LET l_sum_ass21 = 0   #TQC-AA0098
  LET l_ass18 = 0   #TQC-AA0098
  LET l_ass19 = 0   #TQC-AA0098
  LET l_ass20 = 0   #TQC-AA0098
  LET l_ass21 = 0   #TQC-AA0098

  LET l_sql=
  " SELECT asn07,asn08,asn09",
  "   FROM asn_file ",
  "  WHERE asn00 = '",g_asz01,"'",        #合併帳別 
  "    AND asn01 = '",g_dept[p_i].asa01,"'", #族群
  "    AND asn02 = '",g_dept[p_i].asb04,"'", #公司
  "    AND asn04 = '",p_aed01,"'",
  "    AND asn05 = '",p_aed02,"'",
  "    AND asn20 = ",tm.yy," AND asn21 = ",tm.em,        #No.FUN-C80020
  "    AND asn06 = '",tm.yy,"'",
  "    AND asn07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_asn_p2 FROM l_sql
  DECLARE p001_asn_c2 CURSOR FOR p001_asn_p2
  FOREACH p001_asn_c2 INTO l_month,l_ass18,l_ass19
       IF l_month = 0 THEN LET l_month = 1 END IF
       IF p_asg06 != p_asg07 THEN 
           #功能幣別匯率
           CALL p001_getrate(p_ash11,p_yy,l_month,p_asg06,p_asg07)
           RETURNING l_rate
       END IF
       IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
       LET l_ass20 = l_ass18 * l_rate 
       LET l_ass21 = l_ass19 * l_rate
       LET l_sum_ass20 = l_sum_ass20  + l_ass20
       LET l_sum_ass21 = l_sum_ass21  + l_ass21
  END FOREACH
  
  LET l_dr_sum = l_sum_ass20
  LET l_cr_sum = l_sum_ass21
  
  RETURN l_dr_sum,l_cr_sum  
  #-----FUN-A90026 end-------------------------
  
#-----FUN-A90026 mark-------
#    LET l_acc_dr = 0
#    LET l_acc_cr = 0
#    LET l_dr_sum = 0
#    LET l_cr_sum = 0
#
#    CALL p001_fun_amt(p_aag04,p_dr,p_cr,
#                      '3',p_asg06,p_asg07,tm.yy,tm.em)
#    RETURNING l_fun_dr,l_fun_cr  
#
#    LET l_ass20 = 0
#    LET l_ass21 = 0
#    IF tm.em <> '1' THEN
#        SELECT ass20,ass21 INTO l_ass20,l_ass21
#          FROM ass_file
#        WHERE ass00 =g_aaz641
#          AND ass01 =g_dept[p_i].asa01
#          AND ass02 =g_dept[p_i].asa02
#          AND ass03 =g_dept[p_i].asa03
#          AND ass04 =g_dept[p_i].asb04
#          AND ass05 =p_aed01
#          AND ass07 =p_aed02
#          AND ass08 =tm.yy
#          AND ass09 =tm.em-1
#    END IF
#    LET l_dr_sum = l_ass20 + l_fun_dr 
#    LET l_cr_sum = l_ass21 + l_fun_cr
#
#    RETURN l_fun_dr,l_fun_cr,l_dr_sum,l_cr_sum
#----FUN-A90026 mark----------

END FUNCTION 
#---FUN-A80130 end--------

#FUN-B50001--mark--str--
##---FUN-A90006 start----------------
#FUNCTION p001_ins_ask1_chg(p_type,p_flag,p_asg06)
##FUNCTION p001_ins_ask1_chg(p_asr12,p_asg06)
#DEFINE p_asg06     LIKE asg_file.asg06
#DEFINE p_asr12     LIKE asr_file.asr12
#DEFINE l_asr08     LIKE asr_file.asr08
#DEFINE l_asr09     LIKE asr_file.asr09
#DEFINE l_asr08_b   LIKE asr_file.asr08
#DEFINE l_asr09_b   LIKE asr_file.asr09
#DEFINE l_month_amt LIKE asr_file.asr08
#DEFINE l_tot_amt   LIKE asr_file.asr08
#DEFINE i           LIKE type_file.num5
#DEFINE l_sql       STRING
#DEFINE l_cut       LIKE type_file.num5
#DEFINE l_asr12     LIKE asr_file.asr12   #FUN-A90026
#DEFINE l_r         LIKE ase_file.ase05   #FUN-A90026 
#DEFINE l_r1        LIKE ase_file.ase05   #FUN-A90026
#DEFINE p_flag      LIKE type_file.chr1   #FUN-A90026
#DEFINE p_type      LIKE type_file.chr1   #FUN-A90026
#DEFINE l_asg07     LIKE asq_file.asq09   #FUN-A90026
#
#     #取下層公司記帳金額期別計算各月異動額
#     #轉換為合併幣別金額後加總
#     #各期各自先計算出當月金額後累加
#     #沖銷金額=1-9月各期餘額加總
#     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
#      LET l_asr08 = 0
#      LET l_asr09 = 0
#      LET l_asr08_b = 0
#      LET l_asr09_b = 0
#      LET l_month_amt = 0
#      LET l_tot_amt = 0
#      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg06
#      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#
#     #先依來源為ass_file or asr_file取各月餘額
#     #FOR i = 1 TO tm.em
#     FOR i = 0 TO tm.em   #FUN-A90026 mod
##----FUN-A90026 mark-----------------------來源改為asm_file or asn_file
##         IF g_asq.asq15 = '1' THEN   #asr_file
##             LET l_sql =" SELECT asr08,asr09",
##                        "   FROM asr_file ",
##                        "  WHERE asr01 ='",g_asa[i].asa01,"' ",   #群組
##                        "  WHERE asr01 ='",g_asa[i].asa01,"' ",   #群組
##                        "    AND asr02 ='",g_asr.asr02,"'",       #上層
##                        "    AND asr04 ='",g_asr.asr04,"' ",      #下層
##                        "    AND asr05 ='",g_asr.asr05,"'",       #科目
##                        "    AND asr06 = ",tm.yy,                 #年度
##                        "    AND asr07 = '",i,"'"                 #期別
##         ELSE    #ass_file
##             LET l_sql =" SELECT ass10,ass11",
##                        "   FROM ass_file",
##                        "  WHERE ass01 ='",g_asa[i].asa01,"' ",    #群組
##                        "    AND ass02 ='",g_asr.asr02,"'",        #上層公司
##                        "    AND ass04 ='",g_asr.asr04,"' ",       #下層
##                        "    AND ass05 ='",g_asr.asr05,"'",
##                        "    AND ass08 = ",tm.yy,                  #年度
##                        "    AND ass07 = '",g_affil,"'",           #異動碼
##                        "    AND ass09 = '",i,"'"                  #期別
##         END IF
##---FUN-A90026 mark----------------------------------------------------
#
##---FUN-A90026 start--- 
#         SELECT asg07 INTO l_asg07 FROM asg_file WHERE asg01 = g_asr.asr04
#         IF p_type = 'A' THEN       #來源公司 
#             CASE 
#                WHEN p_flag = '1'        #asm_file
#                    LET l_sql =
#                    " SELECT SUM(asm07-asm08),asm11",
#                    "   FROM asm_file ",
#                    "  WHERE asm00 = '",g_aaz641,"'",        #合併帳別 
#                    "    AND asm01 = '",tm.asa01,"'",        #族群
#                    "    AND asm02 = '",g_asr.asr04,"'",     #公司
#                    "    AND asm04 = '",g_asr.asr05,"'",
#                    "    AND asm05 = '",tm.yy,"'",
#                    "    AND asm06 = '",i,"'",
#                    "  GROUP BY asm11 "
#                WHEN p_flag = '2'        #asn_file
#                    LET l_sql=
#                    " SELECT SUM(asn08-asn09),asn12",
#                    "   FROM asn_file",
#                    "  WHERE asn00 = '",g_aaz641,"'",
#                    "    AND asn01 = '",tm.asa01,"'",
#                    "    AND asn02 = '",g_asr.asr04,"'",
#                    "    AND asn04 = '",g_asr.asr05,"'",
#                    "    AND asn05 = '",g_ass07,"'",
#                    "    AND asn06 = '",tm.yy,"'",
#                    "    AND asn07 = '",i,"'",
#                    "  GROUP BY asn12"
#            END CASE
#        ELSE        #目的公司
#            CASE
#              WHEN p_flag = '1'        #asm_file
#                 LET l_sql =
#                 " SELECT SUM(asm07-asm08),asm11",
#                 "   FROM asm_file ",
#                 "  WHERE asm00 = '",g_aaz641,"'",        #合併帳別 
#                 "    AND asm01 = '",tm.asa01,"'", #族群
#                 "    AND asm02 = '",g_asr.asr04,"'",     #公司
#                 "    AND asm04 = '",g_asr.asr05,"'",
#                 "    AND asm05 = '",tm.yy,"'",
#                 "    AND asm06 = '",i,"'",
#                 "  GROUP BY asm11 "
#              WHEN p_flag = '2'        #asn_file
#                 LET l_sql=
#                 " SELECT SUM(asn08-asn09),asn12",
#                 "   FROM asn_file",
#                 "  WHERE asn00 = '",g_aaz641,"'",
#                 "    AND asn01 = '",tm.asa01,"'",
#                 "    AND asn02 = '",g_asr.asr04,"'",
#                 "    AND asn04 = '",g_asr.asr05,"'",
#                 "    AND asn05 = '",g_ass07,"'",
#                 "    AND asn06 = '",tm.yy,"'",
#                 "    AND asn07 = '",i,"'",
#                 "  GROUP BY asn12"
#            END CASE
#        END IF
#        #---FUN-A90026 end-----
#
#        PREPARE p001_ins_ask1_p1 FROM l_sql
#        IF STATUS THEN
#           LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy
#           CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'pre:ins_ask1_p1',STATUS,1)
#           LET g_success = 'N'
#        END IF
#        DECLARE p001_ins_ask1_c1 CURSOR FOR p001_ins_ask1_p1
#        #FOREACH p001_ins_ask1_c1 INTO l_asr08,l_asr09    #借/貸
#        FOREACH p001_ins_ask1_c1 INTO l_month_amt,l_asr12    #借-貸/幣別   #FUN-A90026 mod
#        #--FUN-A90026 srart---
#            LET l_r = 1
#            LET l_r1 = 1
#            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
#            CALL p001_getrate('3',tm.yy,i,l_asr12,l_asg07)  #取起始月份至當下月份的匯率  #FUN-A90026
#            RETURNING l_r   
#            IF cl_null(l_r) THEN LET l_r = 1 END IF
#            CALL p001_getrate('3',tm.yy,i,l_asg07,p_asg06) 
#            RETURNING l_r1   
#            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
#            LET l_month_amt = l_month_amt * l_r * l_r1
#            LET l_tot_amt = l_tot_amt + l_month_amt
#        END FOREACH
#        #--FUN-A90026 end----
#
##---FUN-A90026 mark ------------
##             CALL p001_getrate('3',tm.yy,i,p_asr12,p_asg06)      #取起始月份至當下月份的匯率
##             RETURNING l_rate
##             IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
##             IF i = 1 THEN   #月份為1時，取出的asr08,asr09即為當月異動額，否則要扣掉前期才能得出當月異動額
##                 LET l_month_amt = (l_asr09 * l_rate) - (l_asr08 * l_rate)
##             ELSE
##                 IF g_asq.asq15 = '1' THEN   #asr_file
##                     SELECT asr08,asr09 INTO l_asr08_b,l_asr09_b
##                       FROM asr_file
##                      WHERE asr01 =g_asa[i].asa01 #群組
##                        AND asr02 =g_asr.asr02      #上層
##                        AND asr04 =g_asr.asr04      #下層
##                        AND asr05 =g_asr.asr05      #科目
##                        AND asr06 =tm.yy            #年度
##                        AND asr07 =i-1              #期別
##                 ELSE    #ass_file
##                     SELECT ass10,ass11 INTO l_asr08_b,l_asr09_b
##                       FROM ass_file
##                      WHERE ass01 =g_asa[i].asa01    #群組
##                        AND ass02 =g_asr.asr02        #上層公司
##                        AND ass04 =g_asr.asr04        #下層
##                        AND ass05 =g_asr.asr05
##                        AND ass08 =tm.yy              #年度
##                        AND ass07 =g_affil            #異動碼
##                        AND ass09 =i-1                #期別
##                 END IF
##                 LET l_month_amt = ((l_asr09 - l_asr09_b) * l_rate) - ((l_asr08 - l_asr08_b) * l_rate)
##            END IF
##            LET l_month_amt=cl_digcut(l_month_amt,l_cut)
##            LET l_tot_amt = l_tot_amt + l_month_amt
##         END FOREACH
##------------FUN-A90026 mark----------------
#     END FOR
#     RETURN l_tot_amt 
#END FUNCTION
##---FUN-A90006 end-----------------
#FUN-B50001--mark--end
#FUN-A90026 start---
FUNCTION p001_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION p001_set_no_entry() 

      CALL cl_set_comp_entry("asa06",FALSE) 

      IF tm.asa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.asa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.asa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.asa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION
#--FUN-A90026 end------------------
#FUN-B70064 --Beatk
FUNCTION p001_getrate1(p_aag04,p_asg06,p_asg07)
DEFINE p_aah01       LIKE aah_file.aah01
DEFINE p_asg06       LIKE asg_file.asg07
DEFINE p_asg07       LIKE asg_file.asg07
DEFINE p_aag04       LIKE aag_file.aag04
DEFINE l_bm          LIKE type_file.num5
DEFINE l_month_count LIKE type_file.num5
DEFINE l_sum_ase07   LIKE ase_file.ase07
DEFINE l_rate        LIKE ase_file.ase05
   IF p_aag04 = '1' THEN
      LET l_bm = 0
   ELSE
      LET l_bm = 1
   END IF
   SELECT SUM(ase07) INTO l_sum_ase07
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN l_bm AND tm.em
      AND (ase07 IS NOT NULL AND ase07<>0)
   SELECT COUNT(ase07) INTO l_month_count
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN l_bm AND tm.em
      AND (ase07 IS NOT NULL AND ase07<>0)
     
   LET l_rate = l_sum_ase07/l_month_count
   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
   RETURN l_rate
END FUNCTION
#FUN-B70064 --End
