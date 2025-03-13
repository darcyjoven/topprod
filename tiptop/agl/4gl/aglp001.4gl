# Prog. Version..: '5.30.06-13.04.19(00010)'     #
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
# Modify.........: No.FUN-770069 07/07/31 By Sarah 1.寫入axk_file,axg_file,axi_file時,除了寫入版本為00的資料外,要再寫入版本為截止期別(tm.em)的資料
#                                                  2.歷史匯率部分改以axr07,axr03,axr08,axr09對應抓出輸入歷史變動金額(axr05)
# Modify.........: No:MOD-780115 07/08/17 By Sarah 換算子公司功能幣別時,應與該子公司記帳幣別比較,若不同才需換算
# Modify.........: No:MOD-890130 08/09/17 By Sarah 產生沖銷分錄時,若金額為0則不產生分錄
# Modify.........: No:MOD-910248 09/02/02 By Sarah 當axu05='+'時,SUM(axg08-axg09)不需*-1
# Modify.........: No:MOD-930135 09/03/12 By lilingyu 增加版本條件
# Modify.........: No.MOD-930210 09/03/20 By Sarah 刪除axi_file、axj_file、計算axi_file筆數時,請加串版本(axi21)條件
# Modify.........: No.MOD-940010 09/04/02 By Sarah get_rate()段,抓axd_file時應串下層公司,且SQL應以axd08b由大至小排序
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
# Modify..........: NO.FUN-970046 09/07/13 BY yiting 1.aglp001在抓取aah_file,aed_file,axq_file寫入axg_file,axk_file時，應依科目性質處理是否做累計處理
#                                                      資產負債類做SUM(借-貸)處理，期別BETWEEN 0~截止期別，損益類則不做SUM
#                                                      寫入axg_file,axk_file時，只寫入截止期別，己產生過的期別不再異動
#                                                    2.寫入axi_file,axj_file時，對沖科目設定"股本"打勾者，才能處理"axt05 是否依股權沖銷" 
#                                                    3.寫入axi_file,axj_file時，只抓取截止期別當期資料寫入調整分錄
#                                                    4.因axr_file(axr08,axr09,axr10,axr11) schema異動，加axr06，原本日期條件改對應到axr06抓取資料，以公司+科目為key，抓於小於截止期別的資料SUM(axr13) 
#                                                    5.處理對沖科目時，如果來源科目找不到資料寫入調整分錄，但對沖科目找的到，也要寫進分錄中
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980063 09/08/11 By xiaofeizhu 如果各子公司先做月結，會把科目余額清0，金額拋成CE類的憑証
#                                                       但是這支p作業沒有考慮CE類的憑証，只抓科目余額過去，如果抓到0，那樣在aglr002里就打不出資料來了
#                                                       所以aglp001中需要增加判斷是否是損益類的科目，且余額為0，是的話就要去找CE類憑証中將這個科目的金額抓回來
# Modify.........: No.FUN-980074 09/08/18 By hongmei 計算累換調整數來源都應只有axg_file,不用再處理axk_file
# Modify.........: NO.FUN-980083 09/08/19 BY yiting aglp001在取異動月份最後一天日期時有誤 
# Modify.........: NO.FUN-980095 09/08/21 BY yiting 累換數計算條件有誤,應只計算科目性質為"資產負債類"會科
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: NO.MOD-990059 09/09/07 BY sabrina 過單 
# Modify.........: NO.FUN-990020 09/09/08 BY yiting 1.在agli011中同一年度不同期別分別有股本異動二次，但GROUP SUM時因為有抓axr05造成無法把相同年度不同期別的合併金額加總
#                                                   2.外幣換算損益(aaz86)科目計算
# Modify.........: NO.MOD-9C0336 09/12/22 BY sabrina axklegal改成axglegal
# Modify.........: NO.MOD-9C0421 09/12/29 BY jan 寫入legal欄位不可直接用g_legal,要以上層公司營運中心取到azw02寫入
# Modify.........: NO.FUN-9B0017 09/11/24 By mike 1.將異動碼科目余額檔aed_file做滾算至上層公司處理(異動碼5-8)aei_file，提供后續部門別合并財報使用
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
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A60056 10/06/09 BY Dido 調整抓取語法與變數宣告 
# Modify.........: NO.MOD-A60080 10/06/11 BY Dido axi09 預設值為N 
# Modify.........: NO.FUN-A60038 10/06/15 by Yiting 1.BS本期損益數計算方式應同IS科目計算方式避免造成過大的累換數
#                                                   2.合併計算時沒有月結處理，需手動調整結清虛帳戶，不合理
# Modify.........: NO.FUN-A60060 10/06/22 by Yiting 1.側流問題  2.axq_file加入群組為條件 3.取axh_file要取位
# Modify.........: NO.FUN-A60078 10/06/24 BY yiting 產生沖銷分錄時，上下層公司條件取法
# Modify.........: NO.MOD-A60178 10/06/28 BY Dido p001_acc_amt 傳遞參數調整 
# Modify.........: NO.FUN-A60099 10/06/30 by Yiting 取沖銷來源金額時，中間層母公司的上下層公司條件應為自己
# Modify.........: NO.FUN-A70011 10/07/02 BY yiting 取對沖資料，最下層公司要加入上層公司=目前下層公司的上層公司 為條件
# Modify.........: NO.MOD-A70064 10/07/08 BY yiting 變數寫錯
# Modify.........: NO.FUN-A70053 10/07/09 BY yiting 本期損益BS科目設為平均匯率時，應各月乘各自匯率再累加
# Modify.........: NO.MOD-A70083 10/07/09 BY yiting 累換數分錄沒有產生
# Modify.........: NO.MOD-A70091 10/07/12 BY Dido axk18/19/20/21 應以原欄位計算 
# Modify.........: NO.FUN-A70065 10/07/12 BY yiting 資料來源為axh_file時,再衡量/換算採平均匯率計算方式,同一般由總帳來源資料算法
# Modify.........: NO.MOD-A70107 10/07/14 BY sabrina 將axe06的值給axg05
# Modify.........: NO.MOD-A70111 10/07/14 BY sabrina 若axee06抓不到值時要顯示aap-021的錯誤訊息 
# Modify.........: NO.MOD-A70113 10/07/14 BY sabrina 使用axf10取得axz05，將取得的axz05作為axb05、axd05b的條件 
# Modify.........: NO.FUN-A70086 10/07/16 BY yiting agli011增加功能幣別/再衡量匯率/功能幣金額，換算採歷史匯率時，要依此寫入
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: NO.FUN-B70065 11/08/10 BY belle 追單,少數股權設定抓「累積換算調整數」做金額計算，但無法將換匯產生的累換數納入。
# Modify.........: NO.MOD-A80102 10/08/12 BY yiting 取來源axh,axkk的資料時，aag_file不需要跨資料庫
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
# Modify.........: NO.FUN-AB0004 10/11/02 BY yiting axkk,axh為來源資料時，選擇平均匯率計算方式要依agli002設定方式計算
# Modify.........: No.FUN-AC0051 10/12/18 By chenmoyan 重新取平均匯率
# Modify.........: NO.MOD-AC0271 10/12/22 BY Dido 修正 TQC-AA0098 應為 axe04,axe11,axe12 
# Modify.........: NO.MOD-AC0388 10/12/29 BY yiting 側流換算幣別金額時要考慮科目來源為上層或下層公司
# Modify.........: NO:CHI-B10030 11/01/24 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: NO.FUN-AA0005 11/01/30 BY chenmoyan 取來源aej,aek匯入axg,axk時,加入調整分錄屬於1.調整作業者
# Modify.........: NO.MOD-B30429 11/03/14 BY yiting l_amt_aaz114取不到值時要預設為0
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.MOD-B60197 11/06/24 BY Dido g_date_e變數在針對季或年時會無設定,需再重新給予
# Modify.........: NO.FUN-B70064 11/08/09 BY belle aglp001計算時如選擇"3.當期科目餘額累積數*最末期平均匯率 " 時，以累計餘額* agli008當期匯率
# Modify.........: NO.MOD-B80164 11/08/16 By johung 單號取號加上取號錯誤判斷
# Modify.........: No.CHI-B90065 11/09/30 By Dido axr15/axr12 改用平均值方式計算 
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.TQC-BA0066 11/10/13 by belle 修改aglp001在產生沖銷資料時，跨資料庫取法因單號FUN-A50102修改錯誤，造成合併帳別取不到後沖銷分錄也產生失敗的問題
# Modify.........: No.TQC-B50162 11/10/19 by belle 修改aglp001對沖時以異動碼科餘對沖(axk_file)錯誤
# Modify.........: No.CHI-B80061 11/10/27 By Sarah 科目的換算匯率是設2:歷史匯率,當客戶aglt001有做調整時,執行aglp001後產生的金額會Double
# Modify.........: No.MOD-BB0266 11/11/24 By Dido 產生換匯差額時,檢核單身刪除單頭方式調整 
# Modify.........: No.MOD-BC0072 11/12/09 By Polly 調整PREPARE p001_axr_p借貸抓取aag06
# Modify.........: No.MOD-BC0156 11/12/15 By Dido 刪除 axi_file/axj_file 應僅限與 tm.gl 相同的單別 
# Modify.........: No.MOD-BC0176 11/12/19 By Polly 修正axj071的型態like axj07
# Modify.........: No.MOD-C10035 12/01/05 By Sarah 不論來源或對沖公司,如果勾選"股本",當科目不等於"少數股權"或"少數股權沖銷"
#                                                  時,取科目都應 上層=自己,下層=自己
# Modify.........: No.CHI-BC0039 12/02/16 By Dido 調整分錄整合於記帳金額時一起計算避免尾差問題 
# Modify.........: No.MOD-C20161 12/02/20 By Polly 調整l_aac01變數型態
# Modify.........: No.MOD-C30082 12/03/09 By Polly 增加單別的判斷
# Modify.........: No.MOD-C30498 12/03/16 By minpp INSERT INTO axj_file前，将抓取axz06的条件axf16改成azi06
# Modify.........: No.MOD-C50247 12/04/04 By Polly 子公司的科目沒有餘額但做調整分錄時，跑報表要有合計金額
# Modify.........: No.FUN-BA0111 12/04/17 By Belle 將總帳的異動碼科餘1~4碼也納入合併資料
# Modify.........: NO.MOD-C40135 12/04/18 By Elise 增加抓取 aglt001 部分
# Modify.........: NO.TQC-C40126 12/04/23 By Elise 延續 MOD-C30082 處理,於 IF l_cnt = 0 THEN 的 ELSE 段 WHERE 條件增加  AND axi01 LIKE l_aac01
# Modify.........: NO.TQC-C50094 12/05/10 By xuxz AND axr07= p_aag01應該拿掉來計算平均匯率值
# Modify.........: NO.CHI-C40012 12/07/05 BY fengmy 取匯率時應依axa05 的值(1/2/3)來呼叫不同的取匯率FUNCTION
# Modify.........: No.MOD-C90078 12/09/11 By Polly 抓取agli003對沖分錄資料時，增加抓取axf00與axf12條件
# Modify.........: No.FUN-C90097 12/11/06 By Belle 產生aglt001時應把其它綜合損益科目納入考慮
# Modify.........: NO.FUN-C50059 12/12/20 By Belle 將axb07,axb08修改為axbb07,axbb06
# Modify.........: NO.FUN-C50084 12/12/20 By Belle 將少數股權淨利做分段計算
# Modify.........: No.MOD-CC0280 13/01/02 By Polly 調整本期合計抓取月份條件
# Modify.........: No.FUN-B90069 13/01/29 By apo 因為少數股權是在沖銷時才會產生在消銷分錄中，目前如果agli003設置此科目，但科餘檔會取不到
#                                                當agli003 來源和對沖公司的科目設定有"少數股權"或"少數股權淨利"科目時，
#                                                應取axh_file的合併後科餘檔中的少數股權金額作為對沖金額
# Modify.........: No.MOD-D10049 13/01/09 By apo 調整為以個體公司總帳帳別對帳
# Modify.........: No.MOD-D10131 13/01/16 By apo 換匯方式匯率取法前,判斷如果原來axe11、axe12 無值，則依科目的aag04 為BS OR IS來判斷
# Modify.........: No.MOD-C90148 13/01/22 By apo 寫入 aei_file 欄位問題與平均匯率計算處理
# Modify.........: NO.CHI-CC0031 13/01/29 By apo 中間層母公司沖銷時應取合併前科餘axg or axk
# Modify.........: No.MOD-C30083 13/01/29 By apo 產生跨層沖銷資料時，對沖/來源公司變動時，需重抓對沖/來源帳別
# Modify.........: No.CHI-C30001 13/01/29 By apo 沖銷抓取匯率邏輯調整
# Modify.........: No.MOD-CC0176 13/01/29 By apo 累換數科目於agli001設定為2:歷史匯率，合併幣別金額如無資料需用科餘去換算
# Modify.........: No.MOD-CA0135 13/01/29 By apo 調整帳別的抓取
# Modify.........: No.TQC-C70219 13/01/30 By apo 改用 ARRAY 紀錄發生的科目,如未在餘額檔發生時,則才抓取調整 aglt001 的科目資料
# Modify.........: No.MOD-CC0089 13/01/30 By apo 不可異動l_arr_i變數，改用l_arr_cnt執行FOR迴圈，以免調整分錄錯誤
# Modify.........: No.MOD-CC0175 13/01/30 By apo 借貸相反時，金額需* -1
# Modify.........: No.MOD-CC0216 13/01/30 By apo 不是截止月時，需重取調整單之匯率
# Modify.........: NO.FUN-CA0085 13/02/23 By apo 因科目轉換來源原本只有agli001入口後續又增加agli020(依部門別)，所以取axe11,axe12時要判斷來源後取值
# Modify.........: No.CHI-D20029 13/03/18 By apo 增加axz10欄位
# Modify.........: No.FUN-D20048 13/03/21 By Lori 1.產生沖銷傳票時,自動依agli003的沖銷組別(axf19)寫入aglt001(axj13)
#                                                 2.INSERT INTO axj_file 的摘要一欄時,記錄「母公司 :子公司」以供使用者可以方便查詢對沖公司
#                                                 3.當沖銷分錄中借方金額<貸方金額，就取借方差額科目，貸方金額<借方金額，就取貸方差額科目補入讓分錄平衡
# Modify.........: NO.TQC-D30026 13/03/27 BY Belle  1.當aglt001有調整傳票時，且科目選擇為平均匯率，有金額double的問題
#                                                   2.MOD-C40135調整錯誤的問題，SQL組不出數字，且金額大量重複應予以修復
#                                                   3.MOD-CC0280處理有問題，並不需要處理，予以MARK
# Modify.........: No:CHI-D40021 13/04/12 By apo axt05不使用
# Modify.........: No:MOD-D40107 13/04/12 By apo 調整月份為12時,MDY數值改變
# Modify.........: No:MOD-D40128 13/04/18 By apo 在捲算調整分錄,做科目比對時增加判斷關係人是否相同
# Modify.........: No:TQC-D40045 13/04/18 By apo 合併報表中取得tat_file時,應以aaz641合併帳別為key

DATABASE ds
 
GLOBALS "../../config/top.global"

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
DEFINE g_azw02      LIKE azw_file.azw02      #MOD-9C0421
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
                          END RECORD
DEFINE g_aek              RECORD 
                          aek04  LIKE aek_file.aek04,
                          aek05  LIKE aek_file.aek05,
                          aek06  LIKE aek_file.aek06,
                          aek08  LIKE aek_file.aek08,
                          aek09  LIKE aek_file.aek09,
                          aek10  LIKE aek_file.aek10,
                          aek11  LIKE aek_file.aek11
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
                          aem14  LIKE aem_file.aem14
                         #aem15  LIKE aem_file.aem15	 #FUN-BA0111 mark
                         ,aem16  LIKE aem_file.aem16     #FUN-BA0111 add
                         ,aem17  LIKE aem_file.aem17     #FUN-BA0111 add
                         ,aem18  LIKE aem_file.aem18     #FUN-BA0111 add
                         ,aem19  LIKE aem_file.aem19     #FUN-BA0111 add
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
DEFINE g_aaz87            LIKE aaz_file.aaz87   #FUN-B70065
DEFINE g_aaz128           LIKE aaz_file.aaz128  #FUN-B90069
DEFINE g_aaz129           LIKE aaz_file.aaz129  #FUN-B90069
MAIN
DEFINE  l_axz03     LIKE axz_file.axz03      #MOD-9C0421

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
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
   LET tm.gl    = ARG_VAL(9)
   LET tm.ver   = ARG_VAL(10)
   LET tm.hisyy = ARG_VAL(11)
   LET tm.hismm = ARG_VAL(12)
   LET g_bgjob  = ARG_VAL(13)
   #--FUN-A90026 end---
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add

  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp001_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
           SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = tm.axa02
           SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_axz03
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
          FROM aaa_file WHERE aaa01 = g_bookno

        SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
        SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = tm.axa02
        SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_axz03
       
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
   DEFINE  l_axz03        LIKE axz_file.axz03           #CHI-B10030 add
     
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp001_w AT p_row,p_col WITH FORM "agl/42f/aglp001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    #MOD-660034
        FROM aaa_file 
       WHERE aaa01 = g_bookno

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
      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,tm.gl,g_bgjob,  
                    tm.ver,tm.hisyy,tm.hismm  
      #--FUN-A90026 end---
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE    #NO.FUN-570145 
            EXIT INPUT                  #NO.FUN-570145 

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
               LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #FUN-980083
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
           #IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN   #FUN-C50059 mark
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='3' THEN   #FUN-C50059
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

               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03  #FUN-A30122 add   #FUN-BA0006 
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641           #FUN-A30122 add   #FUN-BA0006
              #LET g_sql = "SELECT aaz113,aaz114 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A60038  #FUN-A50102 mark
              #LET g_sql = "SELECT aaz113,aaz114 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
               #LET g_sql = "SELECT aaz113,aaz114 FROM ",cl_get_target_table(g_dbs_axz03,'aaz_file'),   #FUN-A50102  #FUN-BA0006
               LET g_sql = "SELECT aaz113,aaz114,aaz128,aaz129 FROM ",cl_get_target_table(g_dbs_axz03,'aaz_file'),   #FUN-A50102  #FUN-BA0006   #FUN-B90069 mod
                           " WHERE aaz00 = '0'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
              #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,g_dbs) RETURNING g_sql  #FUN-A50102  #FUN-BA0006
               PREPARE p001_pre_01 FROM g_sql
               DECLARE p001_cur_01 CURSOR FOR p001_pre_01
               OPEN p001_cur_01
               #FETCH p001_cur_01 INTO g_aaz641   #合併帳別
               #FETCH p001_cur_01 INTO g_aaz113,g_aaz641   #合併帳別  #FUN-A30079
               #FETCH p001_cur_01 INTO g_aaz113             #MOD-A50056
               #FETCH p001_cur_01 INTO g_aaz113,g_aaz114     #FUN-A60038
               FETCH p001_cur_01 INTO g_aaz113,g_aaz114,g_aaz128,g_aaz129      #FUN-B90069
               CLOSE p001_cur_01
              #CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03  #FUN-A30122 add	#FUN-BA0006	mark
              #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641           #FUN-A30122 add	#FUN-BA0006 mark
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

         AFTER FIELD gl
            IF NOT cl_null(tm.gl) THEN
               SELECT *  FROM aac_file        #讀取單據性質資料
                WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
               IF SQLCA.sqlcode THEN          #抱歉,讀不到
                  CALL cl_err3("sel","aac_file",tm.gl,"","agl-035","","",0)  #No.FUN-660123
                  NEXT FIELD gl
               END IF
            END IF
            #--FUN-A90026 start--
            IF NOT cl_null(tm.axa06) THEN
                CASE
                    WHEN tm.axa06 = '1'  #月 
                         LET tm.bm = 0
                   #CHI-B10030 add --start--
                    OTHERWISE      
                         CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                         CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                   #CHI-B10030 add --end--
                   #CHI-B10030 mark --start--
                   #WHEN tm.axa06 = '2'  #季 
                   #     SELECT MAX(aznn01) INTO l_aznn01
                   #       FROM aznn_file
                   #      WHERE aznn00 = tm.axa03
                   #        AND aznn02 = tm.yy
                   #        AND aznn03 = tm.q1
                   #     LET tm.em = MONTH(l_aznn01)
                   #WHEN tm.axa06 = '3'  #半年
                   #     IF tm.h1 = '1' THEN  #上半年
                   #         SELECT MAX(aznn01) INTO l_aznn01
                   #           FROM aznn_file
                   #          WHERE aznn00 = tm.axa03
                   #            AND aznn02 = tm.yy
                   #            AND aznn03 < 3
                   #     ELSE                 #下半年
                   #         SELECT MAX(aznn01) INTO l_aznn01
                   #           FROM aznn_file
                   #          WHERE aznn00 = tm.axa03
                   #            AND aznn02 = tm.yy
                   #            AND aznn03 >='3' #大於等於第三季
                   #     END IF
                   #     LET tm.em = MONTH(l_aznn01)
                   #WHEN tm.axa06 = '4'  #年
                   #     SELECT MAX(aznn01) INTO l_aznn01
                   #       FROM aznn_file
                   #      WHERE aznn00 = tm.axa03
                   #        AND aznn02 = tm.yy
                   #     LET tm.em = MONTH(l_aznn01)
                   #CHI-B10030 mark --end--
                END CASE
            END IF
            #--FUN-A90026

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

         ON ACTION CONTROLR
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
               WHEN INFIELD(gl) #單據性質
                  CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','AGL')  #TQC-670078 
                       RETURNING tm.gl         
                  DISPLAY  BY NAME tm.gl  
                  NEXT FIELD gl     
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
   #CHI-B10030 add --start--
   IF tm.axa06 MATCHES '[234]' THEN      
      CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
      CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
   END IF
   #CHI-B10030 add --end--
   LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #MOD-B60197
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
                       " '",tm.gl,"'",    
                       #---FUN-A90026 end----
                       " '",tm.gl CLIPPED,"'",
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
       l_aeh         RECORD LIKE aeh_file.*,          #FUN-A90026
       l_aei16       LIKE aei_file.aei16,
       l_aei17       LIKE aei_file.aei17,
       l_chg_aeii11_1 LIKE axr_file.axr13,
       l_chg_aeii12_1 LIKE axr_file.axr13,
       l_chg_aeii11   LIKE axr_file.axr13,
       l_chg_aeii12   LIKE axr_file.axr13,
       l_chg_aeii11_a LIKE axr_file.axr13,
       l_chg_aeii12_a LIKE axr_file.axr13,
       l_aeii        RECORD LIKE aeii_file.*,
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
DEFINE l_cnt_axr     LIKE type_file.num5              #CHI-B80061 add
DEFINE l_aei23       LIKE aei_file.aei23              #FUN-BA0111
DEFINE l_aei24       LIKE aei_file.aei24              #FUN-BA0111
DEFINE l_flag1       LIKE type_file.chr1              #MOD-C50247 add
DEFINE l_flag2       LIKE type_file.chr1              #MOD-C50247 add
DEFINE l_axe00       LIKE axe_file.axe00              #MOD-D10131 
DEFINE l_accno       DYNAMIC ARRAY OF RECORD          #TQC-C70219 add
                     aej04      LIKE aej_file.aej04   #TQC-C70219 add
                    ,aek05      LIKE aek_file.aek05   #MOD-D40128
                     END RECORD                       #TQC-C70219 add
DEFINE l_arr_i       LIKE type_file.num5              #TQC-C70219 add
DEFINE l_arr_cnt     LIKE type_file.num5              #TQC-C70219 add
DEFINE l_axz10       LIKE axz_file.axz10              #CHI-D20029 add
DEFINE l_ayf10       LIKE ayf_file.ayf10              #FUN-D20048 add
DEFINE l_ayf11       LIKE ayf_file.ayf11              #FUN-D20048 add

    #---FUN-B70065 start--
    #外幣換算損益(aaz86),換算調整數(aaz87)
    SELECT aaz87
      INTO g_aaz87
      FROM aaz_file 
    #---FUN-B70065 end---

    #-->step 1 刪除資料
    CALL p001_del()
    IF g_success = 'N' THEN RETURN END IF

    #str CHI-B80061 add
    #建立TempTable紀錄axr03/axr07欄位,方便判斷歷史匯率者是否已經抓過
    DROP TABLE p001_axr_tmp
    CREATE TEMP TABLE p001_axr_tmp(
       axr03    LIKE axr_file.axr03,
       axr07    LIKE axr_file.axr07)
    LET l_sql = "INSERT INTO p001_axr_tmp VALUES(?,?)"
    PREPARE insert_prep_axr FROM l_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err('insert_prep_axr:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    #end CHI-B80061 add
   #LET l_flag1 = 'N'       #MOD-C50247 add   #TQC-C70219 mark
   #LET l_flag2 = 'N'       #MOD-C50247 add   #TQC-C70219 mark

    #-->step 2 資料匯入,更換科目
    #-->aah_file->axg_file;aed_file->axk_file;ref.axe_file
    #-->axq_file->axg_file;axq_file->axk_file                #FUN-580063
    LET g_no = 1 FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR

    LET l_sql=" SELECT axa01,axa02,axa03,axa02,axa03",
              "   FROM axa_file ",
              "  WHERE axa01='",tm.axa01,"' AND axa02='",tm.axa02,
              "'   AND axa03='",tm.axa03,"' ",
              "  UNION ",
              " SELECT axa01,axa02,axa03,axb04,axb05",
              "   FROM axb_file,axa_file ",
              "  WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
              "    AND axa01='",tm.axa01,"' AND axa02='",tm.axa02,
              "'   AND axa03='",tm.axa03,"' ",
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
       #"SELECT '2',SUM(axr13)",                   #FUN-990020 mod
       #"SELECT '2',SUM(axr16),SUM(axr13)",        #FUN-A70086 #MOD-BC0072 mark
        "SELECT aag06,SUM(axr16),SUM(axr13)",      #MOD-BC0072 add
       #"  FROM axr_file,axz_file",                #MOD-BC0072 mark
        "  FROM axr_file,axz_file,aag_file",       #MOD-BC0072 add
        " WHERE axr01=? AND axr02=? ",
        "   AND axr02=axz01 ",
        "   AND axr04=axz06 ",
       #"   AND axr07=? ",                         #FUN-A90026 mark             
        "   AND axr03=? ",
        "   AND axr06<=? ",                        #異動日期
        "   AND axr03=aag01 ",                     #MOD-BC0072 add
        "   AND aag00 = '",g_aaz641,"'",           #MOD-BC0072 add
        " GROUP BY aag06"                          #MOD-BC0072 add
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
       #SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01=g_dept[i].axb04   #TQC-660043                #CHI-D20029 mark   
        SELECT axz03,axz10 INTO l_axz03,l_axz10 FROM axz_file WHERE axz01=g_dept[i].axb04   #TQC-660043  #CHI-D20029
        SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_axz03   #TQC-660043
        IF STATUS THEN LET g_dbs_new = NULL END IF
        IF NOT cl_null(g_dbs_new) THEN 
           LET g_dbs_new=g_dbs_new CLIPPED,'.' 
        END IF
        LET g_dbs_gl = g_dbs_new CLIPPED

        #母公司的記帳幣別
        SELECT axz06 INTO l_axz06 FROM axz_file WHERE axz01=g_dept[i].axa02

        #每個子公司執行前先清空temptable
        DELETE FROM p001_axr_tmp   #CHI-B80061 add

        LET l_rate = 1 
        LET l_cut  = 0
        LET l_cut1 = 0   #FUN-5A0020

        DISPLAY 'cur db-->',g_dept[i].axb04

        #-->產生axg_file(合併前會計科目餘額檔)
        #-->check 是否有下層資料,無下層(aej_file,aek_file,aem_file),有下層(axh_file,axkk_file)
        #抓取歷史匯率檔時機：
        #判斷現在計算的這個公司有沒有下層公司，
        #若有，則抓合併後餘額檔﹔若沒有，則抓歷史匯率檔
        SELECT COUNT(*) INTO l_n FROM axa_file 
         WHERE axa01=g_dept[i].axa01 
           AND axa02=g_dept[i].axb04 
           AND axa03=g_dept[i].axb05 
        IF l_n=0 OR 
        (g_dept[i].axa02=g_dept[i].axb04 AND g_dept[i].axa03=g_dept[i].axb05)   #FUN-A90026 mod
        THEN #無下層資料
            SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept[i].axb04
            LET l_arr_i = 1                                                     #TQC-C70219 add
            CALL l_accno.clear()                                                #TQC-C70219 add
                #--------FUN-A90026 aah->aej ---start---
                #取aej_file SUM(借),SUM(貸)之科餘(BETWEEN tm.bm and tm.em)寫入合併科餘
                #寫入期別= tm.em
                LET l_sql=
                " SELECT aej04,aej05,SUM(aej07),SUM(aej08),SUM(aej09),SUM(aej10),aej11",
                "   FROM aej_file ",
                "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                "    AND aej01 = '",g_dept[i].axa01,"'", #族群
                "    AND aej02 = '",g_dept[i].axb04,"'", #公司
                "    AND aej05 = '",tm.yy,"'",
                "    AND aej06 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                "  GROUP BY aej04,aej05,aej11 ",
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
                                         g_aej.aej10,g_aej.aej11              #FUN-A90026 add
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

                    LET l_accno[l_arr_i].aej04 = g_aej.aej04     #TQC-C70219 add
                    LET l_arr_i = l_arr_i + 1                    #TQC-C70219 add

                   #-CHI-BC0039-add-
                    LET l_sql=
                       " SELECT axj06,SUM(axj07),COUNT(*) ",
                       " FROM axi_file,axj_file ",
                       " WHERE axi00 = axj00 ",
                       "   AND axi01 = axj01 ",
                       "   AND axi00 = '",g_aaz641,"'",
                       "   AND axi03 = '",tm.yy,"'",
                       "   AND axi04 = '",tm.em,"'", 
                       "   AND axi08 = '1'",
                       "   AND axi05 = '",g_dept[i].axa01,"'",
                       "   AND axi06 = '",g_dept[i].axb04,"'",
                       "   AND axi09 = 'N'",
                       "   AND axiconf = 'Y'",
                       "   AND axj03 = '",l_aah.aah01,"'",
                       " GROUP BY axj06 ",
                       " ORDER BY axj06 "
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
                    FOREACH p001_axj_c1 INTO g_axj1.axj06,g_axj1.axj07,l_num
                       IF g_axj1.axj06 = '1' THEN #借
                           LET l_aah.aah04 = l_aah.aah04 + g_axj1.axj07
                           LET l_aah.aah06 = l_aah.aah06 + l_num
                       ELSE                       #貸
                           LET l_aah.aah05 = l_aah.aah05 + g_axj1.axj07
                           LET l_aah.aah07 = l_aah.aah07 + l_num
                       END IF
                      #LET l_flag1 = 'Y'       #MOD-C50247 add   #TQC-C70219 mark
                    END FOREACH
                   #-CHI-BC0039-end-

                    DISPLAY l_aah.aah03,' ',l_aah.aah01,' ',l_aah.aah04,' ',l_aah.aah05
#FUN-AC0051 --Begin
                    SELECT aag04 INTO l_aag04
                      FROM aag_file
                     WHERE aag00 = g_aaz641
                       AND aag01 = l_aah.aah01
#FUN-AC0051 --End
                       
                    IF l_aah.aah04 - l_aah.aah05 = 0 THEN                                  
                       IF l_aag04 = '2' THEN                                               
                          CALL p001_chkaah(l_aah.aah01,l_aah.aah03,l_aah.aah04,g_dept[i].axb05,l_axz03) #FUN-A50102 add l_axz03             
                          #CALL p001_chkaah(l_aah.aah01,l_aah.aah03,l_aah.aah04,g_dept[i].axb05)             
                          RETURNING l_aah04
                          LET l_aah.aah04 = l_aah04                                               
                       END IF                                                               
                    END IF                                                                                                                                     

                    LET l_axe.axe11 = '1'
                    LET l_axe.axe12 = '1'
                    #抓取下層公司的科目的合併財報科目編號(axe06),
                    #再衡量匯率類別(axe11),換算匯率類別(axe12),
                    #以判斷後續轉換幣別時,要用那種匯率計算
                    IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
                    #---FUN-A90026 start----
                    LET l_sql = 
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
                    ELSE                                       #CHI-D20029 add
                    #--FUN-CA0085 start--
                    #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                        #IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN     #CHI-D20029 mark
                        LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                    " FROM ayf_file",    
                                    "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                    "    AND ayf06 = '",l_aah.aah01,"'",
                                    "    AND ayf00 = '",g_dept[i].axb05,"'", 
                                    "    AND ayf09 = '",tm.axa01,"'",
                                    "    AND ayf10 =  ",l_aah.aah02,           #FUN-D20048 add
                                    "    AND ayf11 =  ",l_aah.aah03            #FUN-D20048 add
                        PREPARE p001_ayf_p1 FROM l_sql
                        DECLARE p001_ayf_c1 SCROLL CURSOR FOR p001_ayf_p1
                        OPEN p001_ayf_c1 
                        FETCH FIRST p001_ayf_c1 INTO l_axe.*
                        CLOSE p001_ayf_c1
                        #FUN-D20048 add begin---
                        IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN
                           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axb04
                              AND ayf09 = tm.axa01
                           LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                       " FROM ayf_file",
                                       "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                       "    AND ayf09 = '",tm.axa01,"'",
                                       "    AND ayf10 =  ",l_ayf10,
                                       "    AND ayf11 =  ",l_ayf11
                           PREPARE p001_ayf_p8 FROM l_sql
                           DECLARE p001_ayf_c8 SCROLL CURSOR FOR p001_ayf_p8
                           OPEN p001_ayf_c8
                           FETCH FIRST p001_ayf_c8 INTO l_axe.*
                           CLOSE p001_ayf_c8
                        ENd IF
                        #FUN-D20048 add end-----
                    END IF
                    #---FUN-CA0085 end--

                    #MOD-D10131--str
                    #如果原axe11無值，則依科目的aag04為1(BS)或2(IS)來判斷axe11為1(現時匯率)或3(平均匯率)
                    LET l_axe00 = g_dept[i].axb05 
                    IF cl_null(l_axe.axe11) THEN
                       SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                       IF l_aag04 = '1' THEN
                           LET l_axe.axe11 = '1'
                       ELSE
                           LET l_axe.axe11 = '3'
                       END IF
                    END IF
                    #如果原axe12無值，則依科目的aag04為1(BS)或2(IS)來判斷axe12為1(現時匯率)或3(平均匯率)
                    IF cl_null(l_axe.axe12) THEN
                       SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                       IF l_aag04 = '1' THEN
                           LET l_axe.axe12 = '1'
                       ELSE
                           LET l_axe.axe12 = '3'
                       END IF
                    END IF
                    #MOD-D10131--end

                    IF STATUS  THEN                      #FUN-580063
                       LET g_showmsg=g_dept[i].axb04,"/",l_aah.aah01                                                #NO.FUN-710023 
                       CALL s_errmsg('axe01,axe04',g_showmsg,l_aah.aah01,'aap-021',1)                               #NO.FUN-710023     
                       LET g_success = 'N' 
                        CONTINUE FOREACH                       #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                    END IF
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
                                        #l_axz.axz07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark
                                         l_axz.axz07,l_aah.aah02,l_aah.aah03,g_axa05)   #FUN-B70064 add
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
                            #紀錄axr03/axr07欄位,方便後續判斷歷史匯率者是否已經抓過
                            EXECUTE insert_prep_axr USING l_aah.aah01,l_axe.axe04  #CHI-B80061 add
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
                                        #l_axz.axz07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 MARK
                                         l_axz.axz07,l_aah.aah02,l_aah.aah03,g_axa05)   #FUN-B70064 ADD
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
                    ELSE
                        CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                          l_axe.axe11,l_axz.axz06,
                                       #l_axz.axz07,l_aah.aah02,l_aah.aah03)            #FUN-B70064 MARK
                                         l_axz.axz07,l_aah.aah02,l_aah.aah03,g_axa05)    #FUN-B70064 mod
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe11='3' THEN
#FUN-A90006 start---
                        #--FUN-A90026 start--
                        IF g_axa05 = '1' THEN      
                            CALL p001_fun_avg(l_axe.axe11,l_aah.aah01,l_axz.axz06,l_axz.axz07,l_aah.aah02,l_aah.aah03,i)   
                            RETURNING l_fun_dr,l_fun_cr 
                        ELSE                
                            CALL p001_fun_amt(l_aag04,l_aah.aah04,l_aah.aah05,
                                              l_axe.axe11,l_axz.axz06,
                                            #l_axz.axz07,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark
                                             l_axz.axz07,l_aah.aah02,l_aah.aah03,g_axa05)   #FUN-B70064 add
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
                                        #x_aaa03,l_aah.aah02,l_aah.aah03)                  #FUN-B70064 MARK
                                         x_aaa03,l_aah.aah02,l_aah.aah03,g_axa05)          #FUN-B70064 ADD
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
                            #紀錄axr03/axr07欄位,方便後續判斷歷史匯率者是否已經抓過
                            EXECUTE insert_prep_axr USING l_aah.aah01,l_axe.axe04  #CHI-B80061 add
                            CALL p001_axr(i,l_axe.axe04,l_aah.aah01,g_date_e)     #FUN-A90026 mod  #TQC-AA0098
                            #--FUN-A70086 start--
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            #--FUN-A70086 end----
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                            #x_aaa03,l_aah.aah02,l_aah.aah03)           #FUN-B70064 MARK
                                             x_aaa03,l_aah.aah02,l_aah.aah03,g_axa05)   #FUN-B70064 ADD
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                        #x_aaa03,l_aah.aah02,l_aah.aah03)              #FUN-B70064 MARK
                                         x_aaa03,l_aah.aah02,l_aah.aah03,g_axa05)      #FUN-B70064 ADD
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe12='3' THEN
#--FUN-A90006 start-
                        #---FUN-A90026 start
                        IF g_axa05 = '1' THEN 
                            CALL p001_avg(l_axe.axe11,l_axe.axe12,l_aah.aah01,
                                          l_axz.axz06,l_axz.axz07,
                                          l_aah.aah02,l_aah.aah03,i)
                        #FUN-A90026 end--
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #--FUN-A90026 start---
                        ELSE
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                            #x_aaa03,l_aah.aah02,l_aah.aah03)           #FUN-B70064 mark 
                                             x_aaa03,l_aah.aah02,l_aah.aah03,g_axa05)   #FUN-B70064 add
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
                       axg17,axglegal,                        #FUN-750078 add #FUN-980003 add legal
                       axg18,axg19)                            #FUN-970046                                                                                    
                     VALUES                                                                                                                                     
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  #FUN-5A0020 #FUN-920067                                                                      
                       g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05,                                                                                        
                       l_aah.aah01,l_aah.aah02,l_aah.aah03,l_chg_aah04_1,   #FUN-A90026 mod
                       l_chg_aah05_1,l_aah.aah06,l_aah.aah07,l_axz06,                                                                                          
                       l_aah.aah04,l_aah.aah05,l_chg_aah04,l_chg_aah05,                                                                                        
                       tm.ver,g_azw02,    #MOD-9C0421 mod            
                       l_axg18,l_axg19)      
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
                          #AND axg02 = g_dept[i].axa02                                                                                                         
                           AND axg02 = tm.axa02  #FUN-A30064                                                                                                         
                           AND axg03 = g_dept[i].axa03                                                                                                         
                           AND axg04 = g_dept[i].axb04                                                                                                         
                           AND axg041= g_dept[i].axb05                                                                                                         
                           AND axg05 = l_aah.aah01     #FUN-A90026 mod
                           AND axg06 = l_aah.aah02                                                                                                             
                           AND axg07 = l_aah.aah03                                                                                                             
                           AND axg12 = l_axz06              #FUN-930117                                                                                        
                           AND axg17 = tm.ver              #MOD-930135                                                                                         
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
               #IF l_flag1 = 'N' THEN         #MOD-C50247 add   #TQC-C70219 mark
                 #----------------------MOD-C50247---------------------------remark
                  #-CHI-BC0039-mark-
                   LET l_sql=
                       " SELECT axi03,axi04,axj03,axj06,aag04,SUM(axj07),COUNT(*) ",
                       " FROM axi_file,axj_file,aag_file",
                       " WHERE axi00 = axj00 ",
                       "   AND axi01 = axj01 ",
                       "   AND axi00 = '",g_aaz641,"'",
                       "   AND axi03 = '",tm.yy,"'",
                       "   AND axi04 = '",tm.em,"'", 
                       "   AND axi08 = '1'",
                       "   AND axi05 = '",g_dept[i].axa01,"'",
                       "   AND axi06 = '",g_dept[i].axb04,"'",
                       "   AND axi09 = 'N'",
                       "   AND axiconf = 'Y'",
                       "   AND aag00 = axj00 ",
                       "   AND aag01 = axj03 ",
                       " GROUP BY axi03,axi04,axj03,axj06,aag04 ",
                       " ORDER BY axi03,axi04,axj03,axj06 "
                   PREPARE p001_axj_p3 FROM l_sql                          #MOD-C50247 1 mod 3
                   IF STATUS THEN
                       LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                       CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p1',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOR
                   END IF
                   LET l_num = 0
                   LET g_axj1.axj07 = 0
                   DECLARE p001_axj_c3 CURSOR FOR p001_axj_p3              #MOD-C50247 1 mod 3
                   FOREACH p001_axj_c1 INTO g_axg.axg06,g_axg.axg07,       
                                            g_axg.axg05,g_axj1.axj06,
                                            l_aag04,
                                            g_axj1.axj07,l_num
                       IF SQLCA.SQLCODE THEN
                          CALL s_errmsg(' ',' ','p001_axj_c1',STATUS,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                     #---------------------MOD-CC0089-------------------(S)
                     #------MOD-CC0089-----mark
                     ##---------------TQC-C70219-------------------(S)
                     # LET l_arr_cnt = l_arr_i - 1
                     # FOR l_arr_i = 1 TO l_arr_cnt
                     #     IF l_accno[l_arr_i].aej04 = g_axk.axk05 THEN
                     #        CONTINUE FOREACH
                     #     END IF
                     # END FOR
                     ##---------------TQC-C70219-------------------(E)
                     #------MOD-CC0089-----mark
                       FOR l_arr_cnt = 1 TO l_arr_i - 1
                           IF l_accno[l_arr_cnt].aej04 = g_axg.axg05 THEN
                              CONTINUE FOREACH
                           END IF
                       END FOR
                     #---------------------MOD-CC0089-------------------(E)
                  
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
                          
                       IF g_axg.axg13- g_axg.axg14 = 0 THEN                                  
                          IF l_aag04 = '2' THEN                                               
                             CALL p001_chkaah(g_axg.axg05,g_axg.axg07,g_axg.axg13,g_dept[i].axb05,l_axz03)             
                             RETURNING g_axg.axg13
                          END IF                                                               
                       END IF                                                                                                                                     
                  
                       LET l_axe.axe11 = '1'
                       LET l_axe.axe12 = '1'
                       IF l_axz10 = 'N' OR cl_null(l_axz10) THEN        #CHI-D20029 add 
                       LET l_sql = 
                       " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098 #MOD-AC0271 remark
                       "  WHERE axe01 = '",g_dept[i].axb04,"'",
                       "    AND axe06 = '",g_axg.axg05,"'",
                       "    AND axe00 = '",g_dept[i].axb05,"'", 
                       "    AND axe13 = '",tm.axa01,"'"   
                       PREPARE p001_axe_p5 FROM l_sql
                       DECLARE p001_axe_c5 SCROLL CURSOR FOR p001_axe_p5
                       OPEN p001_axe_c5 
                       FETCH FIRST p001_axe_c5 INTO l_axe.*
                       CLOSE p001_axe_c5
                       ELSE                                             #CHI-D20029 add
                       #--FUN-CA0085 start--
                       #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                           #IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN      #CHI-D20029 mark
                           LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                       " FROM ayf_file",    
                                       "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                       "    AND ayf06 = '",g_axg.axg05,"'",
                                       "    AND ayf00 = '",g_dept[i].axb05,"'", 
                                       "    AND ayf09 = '",tm.axa01,"'",
                                       "    AND ayf10 =  ",l_aah.aah02,         #FUN-D20048 add
                                       "    AND ayf11 =  ",l_aah.aah03          #FUN-D20048 add
                           PREPARE p001_ayf_p2 FROM l_sql
                           DECLARE p001_ayf_c2 SCROLL CURSOR FOR p001_ayf_p2
                           OPEN p001_ayf_c2 
                           FETCH FIRST p001_ayf_c2 INTO l_axe.*
                           CLOSE p001_ayf_c2
                           #FUN-D20048 add begin---
                           IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN
                              SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                                FROM ayf_file
                               WHERE ayf01 = g_dept[i].axb04
                                 AND ayf09 = tm.axa01
                              LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                          " FROM ayf_file",
                                          "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                          "    AND ayf09 = '",tm.axa01,"'",
                                          "    AND ayf10 =  ",l_ayf10,
                                          "    AND ayf11 =  ",l_ayf11
                              PREPARE p001_ayf_p9 FROM l_sql
                              DECLARE p001_ayf_c9 SCROLL CURSOR FOR p001_ayf_p9
                              OPEN p001_ayf_c9
                              FETCH FIRST p001_ayf_c9 INTO l_axe.*
                              CLOSE p001_ayf_c9
                           ENd IF
                           #FUN-D20048 add end-----
                       END IF
                       #---FUN-CA0085 end--
                       IF STATUS THEN           
                          LET g_showmsg=g_dept[i].axb04,"/",g_axg.axg05
                          CALL s_errmsg('axe01,axe04',g_showmsg,g_axg.axg05,'aap-021',1)                               #NO.FUN-710023     
                          LET g_success = 'N' 
                          CONTINUE FOREACH        
                       END IF
                  
                       #MOD-D10131--str
                       #如果原axe11無值，則依科目的aag04為1(BS)或2(IS)來判斷axe11為1(現時匯率)或3(平均匯率)
                       LET l_axe00 = g_dept[i].axb05
                       IF cl_null(l_axe.axe11) THEN
                          SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                          IF l_aag04 = '1' THEN
                              LET l_axe.axe11 = '1'
                          ELSE
                              LET l_axe.axe11 = '3'
                          END IF
                       END IF
                       #如果原axe12無值，則依科目的aag04為1(BS)或2(IS)來判斷axe12為1(現時匯率)或3(平均匯率)
                       IF cl_null(l_axe.axe12) THEN
                          SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                          IF l_aag04 = '1' THEN
                              LET l_axe.axe12 = '1'
                          ELSE
                              LET l_axe.axe12 = '3'
                          END IF
                       END IF
                       #MOD-D10131--end
 
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
                                            #l_axz.axz07,tm.yy,tm.em)            #FUN-B70064 MARK
                                             l_axz.axz07,tm.yy,tm.em,g_axa05)    #FUN-B70064 ADD
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
                                            #l_axz.axz07,tm.yy,tm.em)            #FUN-B70064 MARK
                                             l_axz.axz07,tm.yy,tm.em,g_axa05)    #FUN-B70064 ADD
                               RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                           END IF
                       ELSE
                           CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                             l_axe.axe11,l_axz.axz06,
                                            #l_axz.axz07,tm.yy,tm.em)            #FUN-B70064 MARK
                                             l_axz.axz07,tm.yy,tm.em,g_axa05)    #FUN-B70064 ADD
                           RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                       END IF
                  
                       #--平均匯率---
                       IF l_axe.axe11='3' THEN
                         #-MOD-C90148-add-
                          IF g_axa05 = '1' THEN 
                             CALL p001_fun_axj_avg(l_axe.axe11,g_axg.axg05,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                             RETURNING l_fun_dr,l_fun_cr 
                             #TQC-D30026 START--
                              IF g_axj1.axj06 = '1' THEN #借
                                 LET l_fun_cr = 0
                              ELSE
                                 LET l_fun_dr = 0
                              END IF
                             #TQC-D30026 END---
                          ELSE
                         #-MOD-C90148-end-
                             CALL p001_fun_amt(l_aag04,g_axg.axg13,g_axg.axg14,
                                               l_axe.axe11,l_axz.axz06,
                                              #l_axz.axz07,tm.yy,tm.em)            #FUN-B70064 MARK
                                               l_axz.axz07,tm.yy,tm.em,g_axa05)    #FUN-B70064 ADD
                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                          END IF   #MOD-C90148
                       END IF
                  
                       #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                       #--現時匯率---
                       IF l_axe.axe12='1' THEN 
                           CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                             l_axe.axe12,l_axz.axz07,
                                            #x_aaa03,tm.yy,tm.em)            #FUN-B70064 MARK
                                             x_aaa03,tm.yy,tm.em,g_axa05)    #FUN-B70064 ADD
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
                                                #x_aaa03,tm.yy,tm.em)             #FUN-B70064 MARK
                                                 x_aaa03,tm.yy,tm.em,g_axa05)     #FUN-B70064 ADD
                               RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                           END IF
                       ELSE
                           CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                             l_axe.axe12,l_axz.axz07,
                                            #x_aaa03,tm.yy,tm.em)                 #FUN-B70064 MARK
                                             x_aaa03,tm.yy,tm.em,g_axa05)         #FUN-B70064 ADD
                           RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                       END IF
                  
                       #--平均匯率---
                       IF l_axe.axe12='3' THEN
                         #-MOD-C90148-add-
                          IF g_axa05 = '1' THEN 
                             CALL p001_axj_avg(l_axe.axe11,l_axe.axe12,g_axg.axg05,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                             #TQC-D30026 START--
                              IF g_axj1.axj06 = '1' THEN #借
                                 LET l_fun_cr = 0
                              ELSE
                                 LET l_fun_dr = 0
                              END IF
                             #TQC-D30026 END---
                          ELSE
                         #-MOD-C90148-end-
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                               l_axe.axe12,l_axz.axz07,
                                              #x_aaa03,tm.yy,tm.em)                #FUN-B70064 MARK
                                               x_aaa03,tm.yy,tm.em,g_axa05)        #FUN-B70064 ADD 
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                          END IF  #MOD-C90148
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
                          axg17,axglegal,                              
                          axg18,axg19)                       
                        VALUES                                                                                                                                     
                          (g_aaz641,g_dept[i].axa01,g_dept[i].axa02, 
                          g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05,                                                                                        
                          g_axg.axg05,tm.yy,tm.em,l_chg_aah04_1, 
                          l_chg_aah05_1,g_axg.axg10,g_axg.axg11,l_axz06,                                                                                          
                          g_axg.axg13,g_axg.axg14,l_chg_aah04,l_chg_aah05,                                                                                        
                          tm.ver,g_azw02,  #MOD-9C0421                                                                                                           
                          l_axg18,l_axg19)      
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
                              AND axg02 = tm.axa02
                              AND axg03 = g_dept[i].axa03                                                                                                         
                              AND axg04 = g_dept[i].axb04                                                                                                         
                              AND axg041= g_dept[i].axb05                                                                                                         
                              AND axg05 = g_axg.axg05
                              AND axg06 = g_axg.axg06
                              AND axg07 = g_axg.axg07
                              AND axg12 = l_axz06   
                              AND axg17 = tm.ver    
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
                  #-CHI-BC0039-end-
                 #----------------------MOD-C50247---------------------------remark
               #END IF                           #MOD-C50247 add   #TQC-C70219 mark
               #MOD-C40135---str---
               ##--取調整分錄中有關係人的資料---#
               #LET l_sql=
               #    " SELECT axi03,axi04,axj03,axj05,axj06,aag04,SUM(axj07),COUNT(*) ",
               #    " FROM axi_file,axj_file,aag_file",
               #    " WHERE axi00 = axj00 ",
               #    "   AND axi01 = axj01 ",
               #    "   AND axi00 = '",g_aaz641,"'",
               #    "   AND axi03 = '",tm.yy,"'",
               #    "   AND axi04 = '",tm.em,"'", 
               #    "   AND axi08 = '1'",
               #    "   AND axi05 = '",g_dept[i].axa01,"'",
               #    "   AND axi06 = '",g_dept[i].axb04,"'",
               #    "   AND axi09 = 'N'",
               #    "   AND axiconf = 'Y'",
               #    "   AND axj05 <> ' '",
               #    "   AND aag00 = axj00 ",
               #    "   AND aag01 = axj03 ",
               #    " GROUP BY axi03,axi04,axj03,axj05,axj06,aag04 ",
               #    " ORDER BY axi03,axi04,axj03,axj06 "
               #PREPARE p001_axj_p2 FROM l_sql
               #IF STATUS THEN
               #    LET g_showmsg=tm.yy,"/",g_dept[i].axb05
               #    CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p2',STATUS,1)
               #    LET g_success = 'N'
               #    CONTINUE FOR
               #END IF
               #LET l_num = 0
               #LET g_axj1.axj07 = 0
               #DECLARE p001_axj_c2 CURSOR FOR p001_axj_p2
               #FOREACH p001_axj_c2 INTO g_axk.axk08,g_axk.axk09,
               #                         g_axk.axk05,g_axk.axk07,
               #                         g_axj1.axj06,
               #                         l_aag04,
               #                         g_axj1.axj07,l_num
               #    IF SQLCA.SQLCODE THEN
               #       CALL s_errmsg(' ',' ','p001_axj_c2',STATUS,1)
               #       LET g_success = 'N'
               #       CONTINUE FOREACH
               #    END IF

               #    LET g_axk.axk00 = g_aaz641
               #    LET g_axk.axk01 = g_dept[i].axa01
               #    LET g_axk.axk02 = g_dept[i].axa02 
               #    LET g_axk.axk03 = g_dept[i].axa03
               #    LET g_axk.axk04 = g_dept[i].axb04
               #    LET g_axk.axk041 = g_dept[i].axb05

               #    IF g_axj1.axj06 = '1' THEN #借
               #        LET g_axk.axk18 = g_axj1.axj07
               #        LET g_axk.axk19 = 0
               #        LET g_axk.axk12 = l_num
               #    ELSE                       #貸
               #        LET g_axk.axk18 = 0
               #        LET g_axk.axk19 = g_axj1.axj07
               #        LET g_axk.axk13 = l_num
               #    END IF

               #    LET l_sql = 
               #    #" SELECT axe11,axe12 FROM axe_file ",
               #    " SELECT axe04,axe11,axe12 FROM axe_file ",  #TQC-AA0098
               #    "  WHERE axe01 = '",g_dept[i].axb04,"'",
               #    "    AND axe06 = '",g_axk.axk05,"'",
               #    "    AND axe00 = '",g_dept[i].axb05,"'", 
               #    "    AND axe13 = '",tm.axa01,"'"   
               #    PREPARE p001_axe_p4 FROM l_sql
               #    DECLARE p001_axe_c4 SCROLL CURSOR FOR p001_axe_p4
               #    OPEN p001_axe_c4 
               #    FETCH FIRST p001_axe_c4 INTO l_axe.*
               #    CLOSE p001_axe_c4

               #     IF STATUS  THEN                   
               #        LET g_showmsg=g_dept[i].axb04,"/",g_axk.axk05
               #         CALL s_errmsg('axe01,axe04',g_showmsg,g_axk.axk05,'aap-021',1)                #NO.FUN-710023    
               #         LET g_success = 'N'
               #         CONTINUE FOREACH    
               #     END IF

               #     #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
               #     LET l_rate  = 1
               #     LET l_rate1 = 1
               #     #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
               #     #金額需抓agli011設定的記帳幣別金額(小於等於本期),
               #     #一一換算後再加總起來

               #     #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
               #     #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-770069  #FUN-970046 mOd  #FUN-A60038 MARK
               #     LET l_chg_aed05_1=0
               #     LET l_chg_aed06_1=0
               #     LET l_chg_aed05=0
               #     LET l_chg_aed06=0
               #     LET l_chg_aed05_a=0
               #     LET l_chg_aed06_a=0
               #     LET l_chg_dr = 0 
               #     LET l_chg_cr = 0
               #     LET l_fun_dr = 0 
               #     LET l_fun_cr = 0 
               #     LET l_acc_dr = 0 
               #     LET l_acc_cr = 0
               #     LET l_dr = 0   
               #     LET l_cr = 0  

               #     #依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
               #     #--現時匯率---
               #     IF l_axe.axe11='1' THEN 
               #         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
               #                           l_axe.axe11,l_axz.axz06,
               #                          #l_axz.axz07,g_axk.axk08,g_axk.axk09)           #FUN-B70064 MARK
               #                           l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)   #FUN-B70064 ADD
               #         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               #     END IF

               #     #--歷史匯率---
               #     IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
               #         #----如果agli011抓不到資料，則依科目餘額計算---- 
               #         DECLARE p001_cnt_cs49 CURSOR FOR p001_axr_p2
               #         OPEN p001_cnt_cs49
               #         USING g_dept[i].axa01,g_dept[i].axb04,
               #               g_axk.axk05,g_date_e  
               #         FETCH p001_cnt_cs49 INTO l_axr_count
               #         CLOSE p001_cnt_cs49
               #         IF l_axr_count > 0 THEN   
               #             #CALL p001_axr(i,g_axk.axk05,g_date_e)   
               #             CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)    #TQC-AA0098
               #             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
               #         ELSE
               #             #--取不到agli011時一樣用匯率換算---
               #             CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
               #                           l_axe.axe11,l_axz.axz06,
               #                          #l_axz.axz07,g_axk.axk08,g_axk.axk09)           #FUN-B70064 MARK
               #                           l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)   #FUN-B70064 ADD
               #             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               #         END IF
               #     ELSE
               #         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
               #                       l_axe.axe11,l_axz.axz06,
               #                      #l_axz.axz07,g_axk.axk08,g_axk.axk09)              #FUN-B70064 MARK
               #                       l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)      #FUN-B70064 ADD
               #         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               #     END IF
       
               #     #--平均匯率---
               #     IF l_axe.axe11='3' THEN
               #         CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
               #                           l_axe.axe11,l_axz.axz06,
               #                          #l_axz.axz07,g_axk.axk08,g_axk.axk09)             #FUN-B70064 MARK
               #                           l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)     #FUN-B70064 ADD 
               #         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               #     END IF

               #     #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
               #     #--現時匯率---
               #     IF l_axe.axe12='1' THEN 
               #         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
               #                           l_axe.axe12,l_axz.axz07,
               #                          #x_aaa03,g_axk.axk08,g_axk.axk09)             #FUN-B70064 MARK
               #                           x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)     #FUN-B70064 ADD
               #         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               #     END IF

               #     #--歷史匯率---
               #     IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
               #         #----如果agli011抓不到資料，則依科目餘額計算---- 
               #         DECLARE p001_cnt_cs50 CURSOR FOR p001_axr_p2
               #         OPEN p001_cnt_cs50
               #         USING g_dept[i].axa01,g_dept[i].axb04,
               #               g_axk.axk05,g_date_e    
               #         FETCH p001_cnt_cs50 INTO l_axr_count
               #         CLOSE p001_cnt_cs50
               #         IF l_axr_count > 0 THEN   
               #             #CALL p001_axr(i,g_axk.axk05,g_date_e)  
               #             CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)    #TQC-AA0098
               #             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
               #         ELSE
               #             #--取不到agli011時一樣用匯率換算---
               #             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
               #                               l_axe.axe12,l_axz.axz07,
               #                              #x_aaa03,g_axk.axk08,g_axk.axk09)               #FUN-B70064 MARK
               #                               x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)       #FUN-B70064 ADD
               #             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               #         END IF
               #     ELSE
	       #         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
	       #     		      l_axe.axe12,l_axz.axz07,
	       #     		     #x_aaa03,g_axk.axk08,g_axk.axk09)               #FUN-B70064 MARK
	       #     		      x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)       #FUN-B70064 ADD
               #         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               #     END IF

               #     #--平均匯率---
               #     IF l_axe.axe12='3' THEN
               #         CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
               #                           l_axe.axe12,l_axz.axz07,
               #                          #x_aaa03,g_axk.axk08,g_axk.axk09)             #FUN-B70064 MARK
               #                           x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)     #FUN-B70064 ADD
               #         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               #     END IF       

               #     LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
               #     LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
               #     LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
               #     LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr

               #     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07    #FUN-A60060 mod
               #     IF cl_null(l_cut) THEN LET l_cut=0 END IF
               #     SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03 
               #     IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
               #     
               #     #->幣別轉換及取位
               #     LET l_chg_aed05=cl_digcut(l_chg_aed05,l_cut) 
               #     LET l_chg_aed06=cl_digcut(l_chg_aed06,l_cut)
               #     LET l_chg_aed05_1= cl_digcut(l_chg_aed05_1,l_cut1)
               #     LET l_chg_aed06_1= cl_digcut(l_chg_aed06_1,l_cut1)
               #     IF cl_null(l_chg_aed05_1) THEN LET l_chg_aed05_1=0 END IF
               #     IF cl_null(l_chg_aed06_1) THEN LET l_chg_aed06_1=0 END IF
               #     
               #     IF g_axa05 = '1' THEN
               #         IF l_axe.axe11 = '3' THEN     #TQC-AA0098
               #             IF l_axz.axz06 != l_axz.axz07 THEN
               #                 LET l_axk16 = (l_chg_aed05-l_chg_aed06)/(g_axk.axk18-g_axk.axk19)
               #             ELSE
               #                 LET l_axk16 = l_rate
               #             END IF
               #         #TQC-AA0098 start
               #         ELSE
               #             LET l_axk16 = l_rate
               #         END IF
               #         #TQC-AA0098 end

               #         IF l_axe.axe12 = '3' THEN   #TQC-AA0098
               #             IF l_axz.axz07 != x_aaa03 THEN
               #                 LET l_axk17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06)
               #             ELSE
               #                 LET l_axk17 = l_rate1
               #             END IF
               #         #--TQC-AA0098
               #         ELSE
               #             LET l_axk17 = l_rate1
               #         END IF
               #         #--TQC-AA0098
               #     ELSE
               #         LET l_axk16 = l_rate
               #         LET l_axk17 = l_rate1
               #     END IF
               #     INSERT INTO axk_file 
               #      (axk00,axk01,axk02,axk03,axk04,axk041,   
               #       axk05,axk06,axk07,axk08,axk09,axk10,
               #       axk11,axk12,axk13,axk14,axk15, 
               #       axk16,axk17,axklegal,
               #       axk18,axk19,axk20,axk21)   
               #      VALUES 
               #       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  
               #        g_dept[i].axa03,  
               #        g_dept[i].axb04,g_dept[i].axb05,g_axk.axk05,'99',
               #        g_axk.axk07,g_axk.axk08,g_axk.axk09,
               #        l_chg_aed05_1,l_chg_aed06_1,  
               #        g_axk.axk12,g_axk.axk13,l_axz06, 
               #        tm.ver,                                        
               #        l_axk16,l_axk17,g_azw02,
               #        g_axk.axk18,g_axk.axk19,l_chg_aed05,l_chg_aed06) 
               #     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
               #        UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
               #                               axk11=axk11+l_chg_aed06_1,
               #                               axk12=axk12+g_axk.axk12,
               #                               axk13=axk13+g_axk.axk13,
               #                               axk16=l_axk16,            
               #                               axk17=l_axk17,
               #                               axk18=axk18+g_axk.axk18,
               #                               axk19=axk19+g_axk.axk19,                 #MOD-A70091
               #                               axk20=axk20+l_chg_aed05,                 #MOD-A70091
               #                               axk21=axk21+l_chg_aed06                  #MOD-A70091
               #            WHERE axk00 = g_aaz641  
               #              AND axk01 = g_dept[i].axa01
               #              AND axk02 = tm.axa02 
               #              AND axk03 = g_dept[i].axa03
               #              AND axk04 = g_dept[i].axb04
               #              AND axk041= g_dept[i].axb05
               #              AND axk05 = g_axk.axk05
               #              AND axk06 = '99'
               #              AND axk07 = g_axk.axk07
               #              AND axk08 = g_axk.axk08
               #              AND axk09 = g_axk.axk09
               #              AND axk14 = l_axz06
               #              AND axk15 = tm.ver           
               #        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
               #        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
               #           CALL s_errmsg('axk01',g_dept[i].axa01,'upd_axk',SQLCA.sqlcode,1) 
               #           LET g_success = 'N' 
               #           CONTINUE FOREACH      
               #        END IF
               #     ELSE
               #        IF STATUS THEN 
               #           LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_aaz641,"/",g_dept[i].axb04      
               #           CALL s_errmsg('axk01,axk02,axk03,axk04 ',g_showmsg,'ins_axk',status,1)                
               #           LET g_success = 'N'
               #           CONTINUE FOREACH       
               #        END IF
               #     END IF                          
               #END FOREACH
               #MOD-C40135---end---
                #---------------FUN-AA0005 end------------------
                LET l_arr_i = 1                 #TQC-C70219 add
                CALL l_accno.clear()            #TQC-C70219 add

#FUN-920067 無下層且使用TIPTOP(axz04 = 'Y')時 以本層aed_file資料寫入axk_file----------
                #--FUN-A90026 start--將aed_file->aek_file 且BS/IS類科目均作累計處理----
                LET l_sql=
                    " SELECT aek04,aek05,aek06,SUM(aek08),SUM(aek09),SUM(aek10),SUM(aek11) ",
                    " FROM aek_file",
                    " WHERE aek00 = '",g_aaz641,"'",
                    "   AND aek01 = '",g_dept[i].axa01,"'",
                    "   AND aek02 = '",g_dept[i].axb04,"'",
                    "   AND aek06 = '",tm.yy,"'",
                    "   AND aek07 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
                    " GROUP BY aek04,aek05,aek06 ",
                    " ORDER BY aek04,aek05 "
                #--FUN-A90026 end----------------------------------------------------

                PREPARE p001_aed_p5 FROM l_sql
                IF STATUS THEN
                     LET g_showmsg=tm.yy,"/",g_dept[i].axb05,'99'
                     CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) LET g_success ='N' CONTINUE FOR
                END IF
                DECLARE p001_aed_c5 CURSOR FOR p001_aed_p5
                #--FUN-A90026 start--
                FOREACH p001_aed_c5 INTO g_aek.aek04,g_aek.aek05,g_aek.aek06,   
                                         g_aek.aek08,g_aek.aek09,  
                                         g_aek.aek10,g_aek.aek11              
                     LET l_aed.aed01 = g_aek.aek04
                     LET l_aed.aed02 = g_aek.aek05
                     LET l_aed.aed03 = g_aek.aek06
                     LET l_aed.aed04 = tm.em
                     LET l_aed.aed05 = g_aek.aek08 
                     LET l_aed.aed06 = g_aek.aek09
                     LET l_aed.aed07 = g_aek.aek10
                     LET l_aed.aed08 = g_aek.aek11
                     LET l_aed.aed011 = '99'
                     LET l_accno[l_arr_i].aej04 = g_aek.aek04     #TQC-C70219 add
                     LET l_accno[l_arr_i].aek05 = g_aek.aek05     #MOD-D40128
                     LET l_arr_i = l_arr_i + 1                    #TQC-C70219 add
                  
                   #MOD-C40135---str---
                    LET l_sql=
                       " SELECT axj06,SUM(axj07),COUNT(*) ",
                       " FROM axi_file,axj_file ",
                       " WHERE axi00 = axj00 ",
                       "   AND axi01 = axj01 ",
                       "   AND axi00 = '",g_aaz641,"'",
                       "   AND axi03 = '",tm.yy,"'",
                       "   AND axi04 = '",tm.em,"'",
                       "   AND axi08 = '1'",
                       "   AND axi05 = '",g_dept[i].axa01,"'",
                       "   AND axi06 = '",g_dept[i].axb04,"'",
                       "   AND axi09 = 'N'",
                       "   AND axiconf = 'Y'",
                       "   AND axj05 = '",l_aed.aed02,"'",
                       "   AND axj03 = '",l_aed.aed01,"'",
                       " GROUP BY axj06 ",
                       " ORDER BY axj06 "
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
                    FOREACH p001_axj_c2 INTO g_axj1.axj06,g_axj1.axj07,l_num
                       IF g_axj1.axj06 = '1' THEN #借
                           LET l_aed.aed05 = l_aed.aed05 + g_axj1.axj07
                           LET l_aed.aed07 = l_aed.aed07 + l_num
                       ELSE                       #貸
                           LET l_aed.aed06 = l_aed.aed06 + g_axj1.axj07
                           LET l_aed.aed08 = l_aed.aed08 + l_num
                       END IF
                      #LET l_flag2 = 'Y'       #MOD-C50247 add   #TQC-C70219 mark
                    END FOREACH
                   #MOD-C40135---end---
 
                     LET l_axe.axe11 = '1'
                     LET l_axe.axe12 = '1'
#FUN-AC0051 --Begin
                    SELECT aag04 INTO l_aag04
                      FROM aag_file
                     WHERE aag00 = g_aaz641
                       AND aag01 = l_aed.aed01
#FUN-AC0051 --End
                    IF l_axz10 = 'N' OR cl_null(l_axz10) THEN        #CHI-D20029  
                    #---FUN-A90026 start----
                    LET l_sql = 
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
                     ELSE                                             #CHI-D20029 add    
                     #--FUN-CA0085 start--
                     #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                        #IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN     #CHI-D20029 mark
                         LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                     " FROM ayf_file",    
                                     "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                     "    AND ayf06 = '",l_aed.aed01,"'",
                                     "    AND ayf00 = '",g_dept[i].axb05,"'", 
                                     "    AND ayf09 = '",tm.axa01,"'",
                                     "    AND ayf10 =  ",l_aah.aah02,             #FUN-D20048 add
                                     "    AND ayf11 =  ",l_aah.aah03              #FUN-D20048 add
                         PREPARE p001_ayf_p3 FROM l_sql
                         DECLARE p001_ayf_c3 SCROLL CURSOR FOR p001_ayf_p3
                         OPEN p001_ayf_c3 
                         FETCH FIRST p001_ayf_c3 INTO l_axe.*
                         CLOSE p001_ayf_c3
                         #FUN-D20048 add begin---
                         IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN
                            SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                              FROM ayf_file
                             WHERE ayf01 = g_dept[i].axb04
                               AND ayf09 = tm.axa01
                            LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                        " FROM ayf_file",
                                        "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                        "    AND ayf09 = '",tm.axa01,"'",
                                        "    AND ayf10 =  ",l_ayf10,
                                        "    AND ayf11 =  ",l_ayf11
                            PREPARE p001_ayf_p10 FROM l_sql
                            DECLARE p001_ayf_c10 SCROLL CURSOR FOR p001_ayf_p10
                            OPEN p001_ayf_c10
                            FETCH FIRST p001_ayf_c10 INTO l_axe.*
                            CLOSE p001_ayf_c10
                         ENd IF
                         #FUN-D20048 add end-----
                     END IF
                     #---FUN-CA0085 end--
                     IF STATUS  THEN                   
                        LET g_showmsg=g_dept[i].axb04,"/",l_aed.aed01 
                         CALL s_errmsg('axe01,axe04',g_showmsg,l_aed.aed01,'aap-021',1)                #NO.FUN-710023    
                         LET g_success = 'N'
                         CONTINUE FOREACH    
                     END IF

                    #MOD-D10131--str
                     #如果原axe11無值，則依科目的aag04為1(BS)或2(IS)來判斷axe11為1(現時匯率)或3(平均匯率)
                     LET l_axe00 = g_dept[i].axb05
                     IF cl_null(l_axe.axe11) THEN
                        SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                        IF l_aag04 = '1' THEN
                            LET l_axe.axe11 = '1'
                        ELSE
                            LET l_axe.axe11 = '3'
                        END IF
                     END IF
                     #如果原axe12無值，則依科目的aag04為1(BS)或2(IS)來判斷axe12為1(現時匯率)或3(平均匯率)
                     IF cl_null(l_axe.axe12) THEN
                        SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                        IF l_aag04 = '1' THEN
                            LET l_axe.axe12 = '1'
                        ELSE
                            LET l_axe.axe12 = '3'
                        END IF
                     END IF
                     #MOD-D10131--end

                     #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                     LET l_rate  = 1
                     LET l_rate1 = 1
                     #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                     #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                     #一一換算後再加總起來

                     #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
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
                                         #l_axz.axz07,l_aed.aed03,l_aed.aed04)           #FUN-B70064 MARK
                                          l_axz.axz07,l_aed.aed03,l_aed.aed04,g_axa05)   #FUN-B70064 ADD
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
                             CALL p001_axr(i,l_axe.axe04,l_aed.aed01,g_date_e)    #FUN-A90026   #TQC-AA0098
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                           l_axe.axe11,l_axz.axz06,
                                         #l_axz.axz07,l_aed.aed03,l_aed.aed04)           #FUN-B70064 MARK
                                          l_axz.axz07,l_aed.aed03,l_aed.aed04,g_axa05)   #FUN-B70064 ADD
                             RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                         END IF
                     ELSE
                         CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                       l_axe.axe11,l_axz.axz06,
                                     #l_axz.axz07,l_aed.aed03,l_aed.aed04)               #FUN-B70064 MARK
                                      l_axz.axz07,l_aed.aed03,l_aed.aed04,g_axa05)       #FUN-B70064 ADD
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF
       
                     #--平均匯率---
                     IF l_axe.axe11='3' THEN
#--FUN-A90006 start--
                         #--FUN-A90026 start--
                         IF g_axa05 = '1' THEN     
       		     	     CALL p001_fun_axk_avg(l_axe.axe11,l_aed.aed01,
                                                   l_aed.aed02,l_axz.axz06,l_axz.axz07,
                                                   l_aed.aed03,l_aed.aed04,i)  
                             RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                         ELSE
                             CALL p001_fun_amt(l_aag04,l_aed.aed05,l_aed.aed06,
                                           l_axe.axe11,l_axz.axz06,
                                         #l_axz.axz07,l_aed.aed03,l_aed.aed04)            #FUN-B70064 mark
                                          l_axz.axz07,l_aed.aed03,l_aed.aed04,g_axa05)    #FUN-B70064 add
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
                                         #x_aaa03,l_aed.aed03,l_aed.aed04)              #FUN-B70064 MARK
                                          x_aaa03,l_aed.aed03,l_aed.aed04,g_axa05)      #FUN-B70064 ADD
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
                             CALL p001_axr(i,l_axe.axe04,l_aed.aed01,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
                             RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                         ELSE
                             #--取不到agli011時一樣用匯率換算---
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                               l_axe.axe12,l_axz.axz07,
                                             #x_aaa03,l_aed.aed03,l_aed.aed04)                #FUN-B70064 MARK  
                                              x_aaa03,l_aed.aed03,l_aed.aed04,g_axa05)        #FUN-B70064 ADD
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         END IF
                     ELSE
	                 CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
	             		      l_axe.axe12,l_axz.axz07,
                   		     #x_aaa03,l_aed.aed03,l_aed.aed04)                        #FUN-B70064 MARK
                    		      x_aaa03,l_aed.aed03,l_aed.aed04,g_axa05)                #FUN-B70064 ADD
                         RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                     END IF

                     #--平均匯率---
                     IF l_axe.axe12='3' THEN
#--FUN-A90006 START--
                         #--FUN-A90026 start--
                         IF g_axa05 = '1' THEN        
                             CALL p001_axk_avg(l_axe.axe11,l_axe.axe12,l_aed.aed01,l_aed.aed02,
                                               l_axz.axz06,l_axz.axz07,l_aed.aed03,l_aed.aed04,i)  
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         #--FUN-A90026 start---
                         ELSE
                             CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                        #x_aaa03,l_aed.aed03,l_aed.aed04)              #FUN-B70064 mark
                                         x_aaa03,l_aed.aed03,l_aed.aed04,g_axa05)      #FUN-B70064 add
                             RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                         END IF
                         #--FUN-A90026 end------
#--FUN-A90006 end---
                     END IF       
                     #-------FUN-A60038 end-----------------------------------

                     #--FUN-A60038 start--
                     LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
                     LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
                     LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
                     LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr
                     #---FUN-A60038 end----

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
                       axk16,axk17,axklegal,
                       axk18,axk19,axk20,axk21)        #FUN-A30079                                 
                      VALUES 
                       (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,  
                        g_dept[i].axa03,   #FUN-5A0020
                        g_dept[i].axb04,g_dept[i].axb05,l_aed.aed01,l_aed.aed011,
                        l_aed.aed02,l_aed.aed03,l_aed.aed04,
                        l_chg_aed05_1,l_chg_aed06_1,  #MOD-750036
                        l_aed.aed07,l_aed.aed08,l_axz06, 
                        tm.ver,                                        
                        l_axk16,l_axk17,g_azw02,
                        l_aed.aed05,l_aed.aed06,l_chg_aed05,l_chg_aed06)  #FUN-A30079                               
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
                              AND axk02 = tm.axa02        #FUN-A30064
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
                END FOREACH
               #-------------------------------------MOD-C50247---------------------------(S)
               #--取調整分錄中有關係人的資料---#
               #IF l_flag2 = 'N' THEN   #TQC-C70219 mark
                   LET l_sql=
                       " SELECT axi03,axi04,axj03,axj05,axj06,aag04,SUM(axj07),COUNT(*) ",
                       " FROM axi_file,axj_file,aag_file",
                       " WHERE axi00 = axj00 ",
                       "   AND axi01 = axj01 ",
                       "   AND axi00 = '",g_aaz641,"'",
                       "   AND axi03 = '",tm.yy,"'",
                       "   AND axi04 = '",tm.em,"'",
                       "   AND axi08 = '1'",
                       "   AND axi05 = '",g_dept[i].axa01,"'",
                       "   AND axi06 = '",g_dept[i].axb04,"'",
                       "   AND axi09 = 'N'",
                       "   AND axiconf = 'Y'",
                       "   AND axj05 <> ' '",
                       "   AND aag00 = axj00 ",
                       "   AND aag01 = axj03 ",
                       " GROUP BY axi03,axi04,axj03,axj05,axj06,aag04 ",
                       " ORDER BY axi03,axi04,axj03,axj06 "
                   PREPARE p001_axj_p4 FROM l_sql
                   IF STATUS THEN
                       LET g_showmsg=tm.yy,"/",g_dept[i].axb05
                       CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p2',STATUS,1)
                       LET g_success = 'N'
                       CONTINUE FOR
                   END IF
                   LET l_num = 0
                   LET g_axj1.axj07 = 0
                   DECLARE p001_axj_c4 CURSOR FOR p001_axj_p4
                   FOREACH p001_axj_c4 INTO g_axk.axk08,g_axk.axk09,
                                            g_axk.axk05,g_axk.axk07,
                                            g_axj1.axj06,
                                            l_aag04,
                                            g_axj1.axj07,l_num
                       IF SQLCA.SQLCODE THEN
                          CALL s_errmsg(' ',' ','p001_axj_c2',STATUS,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                      
                    #---------------------MOD-CC0089-------------------(S)
                    #------MOD-CC0089-----mark
                    ##--------------TQC-C70219-------------------(S)
                    # LET l_arr_cnt = l_arr_i - 1
                    # FOR l_arr_i = 1 TO l_arr_cnt
                    #     IF l_accno[l_arr_i].aej04 = g_axk.axk05 THEN
                    #        CONTINUE FOREACH
                    #     END IF
                    # END FOR
                    ##--------------TQC-C70219-------------------(E)
                    #------MOD-CC0089-----mark
                      FOR l_arr_cnt = 1 TO l_arr_i - 1
                          IF l_accno[l_arr_cnt].aej04 = g_axk.axk05 
                          AND l_accno[l_arr_cnt].aek05 = g_axk.axk07  #MOD-D40128
			  THEN
                             CONTINUE FOREACH
                          END IF
                      END FOR
                    #---------------------MOD-CC0089-------------------(E)
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

                      IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
                       LET l_sql =
                       " SELECT axe04,axe11,axe12 FROM axe_file ",
                       "  WHERE axe01 = '",g_dept[i].axb04,"'",
                       "    AND axe06 = '",g_axk.axk05,"'",
                       "    AND axe00 = '",g_dept[i].axb05,"'",
                       "    AND axe13 = '",tm.axa01,"'"
                       PREPARE p001_axe_p4 FROM l_sql
                       DECLARE p001_axe_c4 SCROLL CURSOR FOR p001_axe_p4
                       OPEN p001_axe_c4
                       FETCH FIRST p001_axe_c4 INTO l_axe.*
                       CLOSE p001_axe_c4
                      ELSE                                         #CHI-D20029 add              
                      #--FUN-CA0085 start--
                      #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                          #IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN     #CHI-D20029 mark
                          LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                      " FROM ayf_file",    
                                      "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                     #"    AND axe06 = '",g_axk.axk05,"'",	#CHI-D20029 mark
                                      "    AND ayf06 = '",g_axk.axk05,"'",      #CHI-D20029
                                      "    AND ayf00 = '",g_dept[i].axb05,"'", 
                                      "    AND ayf09 = '",tm.axa01,"'",
                                      "    AND ayf10 =  ",l_aah.aah02,          #FUN-D20048 add
                                      "    AND ayf11 =  ",l_aah.aah03           #FUN-D20048 add
                          PREPARE p001_ayf_p4 FROM l_sql
                          DECLARE p001_ayf_c4 SCROLL CURSOR FOR p001_ayf_p4
                          OPEN p001_ayf_c4 
                          FETCH FIRST p001_ayf_c4 INTO l_axe.*
                          CLOSE p001_ayf_c4
                          #FUN-D20048 add begin---
                          IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN
                             SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                               FROM ayf_file
                              WHERE ayf01 = g_dept[i].axb04
                                AND ayf09 = tm.axa01
                             LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                         " FROM ayf_file",
                                         "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                         "    AND ayf09 = '",tm.axa01,"'",
                                         "    AND ayf10 =  ",l_ayf10,
                                         "    AND ayf11 =  ",l_ayf11
                             PREPARE p001_ayf_p11 FROM l_sql
                             DECLARE p001_ayf_c11 SCROLL CURSOR FOR p001_ayf_p11
                             OPEN p001_ayf_c11
                             FETCH FIRST p001_ayf_c11 INTO l_axe.*
                             CLOSE p001_ayf_c11
                          ENd IF
                          #FUN-D20048 add end-----
                      END IF
                      #---FUN-CA0085 end--
                        IF STATUS  THEN
                           LET g_showmsg=g_dept[i].axb04,"/",g_axk.axk05
                            CALL s_errmsg('axe01,axe04',g_showmsg,g_axk.axk05,'aap-021',1)
                            LET g_success = 'N'
                            CONTINUE FOREACH
                        END IF
       
                        #MOD-D10131--str
                        #如果原axe11無值，則依科目的aag04為1(BS)或2(IS)來判斷axe11為1(現時匯率)或3(平均匯率)
                      LET l_axe00 = g_dept[i].axb05
                        IF cl_null(l_axe.axe11) THEN
                           SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                           IF l_aag04 = '1' THEN
                               LET l_axe.axe11 = '1'
                           ELSE
                               LET l_axe.axe11 = '3'
                           END IF
                        END IF
                        #如果原axe12無值，則依科目的aag04為1(BS)或2(IS)來判斷axe12為1(現時匯率)或3(平均匯率)
                        IF cl_null(l_axe.axe12) THEN
                           SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                           IF l_aag04 = '1' THEN
                               LET l_axe.axe12 = '1'
                           ELSE
                               LET l_axe.axe12 = '3'
                           END IF
                        END IF
                        #MOD-D10131--end

                        #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                        LET l_rate  = 1
                        LET l_rate1 = 1
                        #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                        #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                        #一一換算後再加總起來

                        #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
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
                                              l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)
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
                                CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)
                                RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額
                            ELSE
                                #--取不到agli011時一樣用匯率換算---
                                CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                              l_axe.axe11,l_axz.axz06,
                                              l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF
                        ELSE
                            CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                          l_axe.axe11,l_axz.axz06,
                                          l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF

                        #--平均匯率---
                        IF l_axe.axe11='3' THEN
                          #-MOD-C90148-add-
                           IF g_axa05 = '1' THEN     
       		     	      CALL p001_fun_axj2_avg(l_axe.axe11,g_axk.axk05,g_axk.axk07,l_axz.axz06,l_axz.axz07,g_axk.axk08,g_axk.axk09,i)
                              RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                             #TQC-D30026 START--
                              IF g_axj1.axj06 = '1' THEN 
                                 LET l_fun_cr = 0
                              ELSE
                                 LET l_fun_dr = 0
                              END IF
                             #TQC-D30026 END---
                           ELSE
                          #-MOD-C90148-end-
                              CALL p001_fun_amt(l_aag04,g_axk.axk18,g_axk.axk19,
                                                l_axe.axe11,l_axz.axz06,
                                                l_axz.axz07,g_axk.axk08,g_axk.axk09,g_axa05)
                              RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                           END IF   #MOD-C90148
                        END IF

                        #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                        #--現時匯率---
                        IF l_axe.axe12='1' THEN
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)
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
                                CALL p001_axr(i,l_axe.axe04,g_axk.axk05,g_date_e)
                                RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr             #回傳借/貸方金額
                            ELSE
                                #--取不到agli011時一樣用匯率換算---
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axe.axe12,l_axz.axz07,
                                                  x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF
                        ELSE
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                              x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF

                        #--平均匯率---
                        IF l_axe.axe12='3' THEN
                          #-MOD-C90148-add-
                           IF g_axa05 = '1' THEN        
                              CALL p001_axj2_avg(l_axe.axe11,l_axe.axe12,g_axk.axk05,g_axk.axk07,
                                                l_axz.axz06,l_axz.axz07,g_axk.axk08,g_axk.axk09,i)  
                              RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            #TQC-D30026 START--
                              IF g_axj1.axj06 = '1' THEN #-I
                                 LET l_acc_cr = 0
                              ELSE
                                 LET l_acc_dr = 0
                              END IF
                             #TQC-D30026 END---
                           ELSE
                          #-MOD-C90148-end-
                              CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                l_axe.axe12,l_axz.axz07,
                                                x_aaa03,g_axk.axk08,g_axk.axk09,g_axa05)
                              RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                           END IF   #MOD-C90148
                        END IF

                        LET l_chg_aed05  =l_chg_aed05   + l_fun_dr
                        LET l_chg_aed06  =l_chg_aed06   + l_fun_cr
                        LET l_chg_aed05_1=l_chg_aed05_1 + l_acc_dr
                        LET l_chg_aed06_1=l_chg_aed06_1 + l_acc_cr

                        SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07
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
                            IF l_axe.axe11 = '3' THEN
                                IF l_axz.axz06 != l_axz.axz07 THEN
                                    LET l_axk16 = (l_chg_aed05-l_chg_aed06)/(g_axk.axk18-g_axk.axk19)
                                ELSE
                                    LET l_axk16 = l_rate
                                END IF
                            ELSE
                                LET l_axk16 = l_rate
                            END IF


                            IF l_axe.axe12 = '3' THEN
                                IF l_axz.axz07 != x_aaa03 THEN
                                    LET l_axk17 = (l_chg_aed05_1-l_chg_aed06_1)/(l_chg_aed05-l_chg_aed06)
                                ELSE
                                    LET l_axk17 = l_rate1
                                END IF
                            ELSE
                                LET l_axk17 = l_rate1
                            END IF
                        ELSE
                            LET l_axk16 = l_rate
                            LET l_axk17 = l_rate1
                        END IF
                        INSERT INTO axk_file
                         (axk00,axk01,axk02,axk03,axk04,axk041,
                          axk05,axk06,axk07,axk08,axk09,axk10,
                          axk11,axk12,axk13,axk14,axk15,
                          axk16,axk17,axklegal,
                          axk18,axk19,axk20,axk21)
                         VALUES
                          (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,
                           g_dept[i].axa03,
                           g_dept[i].axb04,g_dept[i].axb05,g_axk.axk05,'99',
                           g_axk.axk07,g_axk.axk08,g_axk.axk09,
                           l_chg_aed05_1,l_chg_aed06_1,
                           g_axk.axk12,g_axk.axk13,l_axz06,
                           tm.ver,
                           l_axk16,l_axk17,g_azw02,
                           g_axk.axk18,g_axk.axk19,l_chg_aed05,l_chg_aed06)
                        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                           UPDATE axk_file    SET axk10=axk10+l_chg_aed05_1,
                                                  axk11=axk11+l_chg_aed06_1,
                                                  axk12=axk12+g_axk.axk12,
                                                  axk13=axk13+g_axk.axk13,
                                                  axk16=l_axk16,
                                                  axk17=l_axk17,
                                                  axk18=axk18+g_axk.axk18,
                                                  axk19=axk19+g_axk.axk19,
                                                  axk20=axk20+l_chg_aed05,
                                                  axk21=axk21+l_chg_aed06
                               WHERE axk00 = g_aaz641
                                 AND axk01 = g_dept[i].axa01
                                 AND axk02 = tm.axa02
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
               #END IF    #TQC-C70219 mark
               #-------------------------------------MOD-C50247---------------------------(E)
                #--FUN-A90026 start----
                LET l_sql=" SELECT aem04,aem05,aem06,aem07,aem08,aem09,",
                          "        SUM(aem11),SUM(aem12),SUM(aem13),SUM(aem14)",
                          "       ,aem16,aem17,aem18,aem19",            #FUN-BA0111 add
                          "   FROM aem_file ",
                          "  WHERE aem09 =",tm.yy,
                          "    AND aem10 BETWEEN ",tm.bm," AND ",tm.em,
                          "    AND aem00='",g_aaz641,"'",
                          "    AND aem01='",g_dept[i].axa01,"'",
                          "    AND aem02='",g_dept[i].axb04,"'",
                          "  GROUP BY aem04,aem05,aem06,aem07,aem08,aem09 ",
                          "          ,aem16,aem17,aem18,aem19 ",          #FUN-BA0111 add
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
                FOREACH p001_aei_c1 INTO g_aem.*      #FUN-A90026 mod
                    IF SQLCA.SQLCODE THEN
                       LET g_showmsg=tm.yy,"/",g_dept[i].axb04    #FUN-A90026 add
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

                    IF l_axz10 = 'N' OR cl_null(l_axz10) THEN        #CHI-D20029 add
                    #---FUN-A90026 start----
                    LET l_sql = 
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
                    ELSE                                            #CHI-D20029
                    #--FUN-CA0085 start--
                    #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                        #IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN           #CHI-D20029 mark
                        LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                    " FROM ayf_file",    
                                    "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                    "    AND ayf06 = '",g_aem.aem04,"'",
                                    "    AND ayf00 = '",g_dept[i].axb05,"'", 
                                    "    AND ayf09 = '",tm.axa01,"'",
                                    "    AND ayf10 =  ",l_aah.aah02,                 #FUN-D20048 add
                                    "    AND ayf11 =  ",l_aah.aah03                  #FUN-D20048 add
                        PREPARE p001_ayf_p5 FROM l_sql
                        DECLARE p001_ayf_c5 SCROLL CURSOR FOR p001_ayf_p5
                        OPEN p001_ayf_c5 
                        FETCH FIRST p001_ayf_c5 INTO l_axe.*
                        CLOSE p001_ayf_c5
                        #FUN-D20048 add begin---
                        IF cl_null(l_axe.axe11) OR cl_null(l_axe.axe12) THEN
                           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axb04
                              AND ayf09 = tm.axa01
                           LET l_sql = "SELECT ayf04,ayf07,ayf08",
                                       " FROM ayf_file",
                                       "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                       "    AND ayf09 = '",tm.axa01,"'",
                                       "    AND ayf10 =  ",l_ayf10,
                                       "    AND ayf11 =  ",l_ayf11
                           PREPARE p001_ayf_p12 FROM l_sql
                           DECLARE p001_ayf_c12 SCROLL CURSOR FOR p001_ayf_p12
                           OPEN p001_ayf_c12
                           FETCH FIRST p001_ayf_c8 INTO l_axe.*
                           CLOSE p001_ayf_c12
                        ENd IF
                        #FUN-D20048 add end-----
                    END IF
                    #---FUN-CA0085 end--
                    IF STATUS  THEN
                       LET g_showmsg=g_dept[i].axb04,"/",g_aem.aem04          #FUN-A90026 mod
                       CALL s_errmsg('axe01,axe06',g_showmsg,'','aap-021',1)  #FUN-A90026 mod      
                       LET g_success = 'N'
                       CONTINUE FOREACH       
                    END IF

                    #MOD-D10131--str
                    #如果原axe11無值，則依科目的aag04為1(BS)或2(IS)來判斷axe11為1(現時匯率)或3(平均匯率)
                    LET l_axe00 = g_dept[i].axb05
                    IF cl_null(l_axe.axe11) THEN
                       SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                       IF l_aag04 = '1' THEN
                           LET l_axe.axe11 = '1'
                       ELSE
                           LET l_axe.axe11 = '3'
                       END IF
                    END IF
                    #如果原axe12無值，則依科目的aag04為1(BS)或2(IS)來判斷axe12為1(現時匯率)或3(平均匯率)
                    IF cl_null(l_axe.axe12) THEN
                       SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag01 = l_axe.axe04 AND aag00 = l_axe00
                       IF l_aag04 = '1' THEN
                           LET l_axe.axe12 = '1'
                       ELSE
                           LET l_axe.axe12 = '3'
                       END IF
                    END IF
                    #MOD-D10131--end

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
                    LET g_sql = "SELECT aag04 ",
                                " FROM ",cl_get_target_table(l_axz03,'aag_file'),   #FUN-A50102
                                " WHERE aag00='",g_dept[i].axb05,"'", #帳別
                                "   and aag01='",g_aem.aem04,"'" #科目    #FUN-A90026
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql   #FUN-A50102
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
                        CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                          l_axe.axe11,l_axz.axz06,
                                         #l_axz.axz07,g_aem.aem09,tm.em)           #FUN-B70064 MARK  
                                          l_axz.axz07,g_aem.aem09,tm.em,g_axa05)   #FUN-B70064 ADD
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs29 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs29
                        USING g_dept[i].axa01,g_dept[i].axb04,
                              g_aem.aem04,g_date_e      #FUN-A90026 mod
                        FETCH p001_cnt_cs29 INTO l_axr_count
                        CLOSE p001_cnt_cs29
                        IF l_axr_count > 0 THEN   
                            CALL p001_axr(i,l_axe.axe04,g_aem.aem04,g_date_e)     #FUN-A90026 mod #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                          l_axe.axe11,l_axz.axz06,
                                         #l_axz.axz07,g_aem.aem09,tm.em)            #FUN-B70064 MARK
                                          l_axz.axz07,g_aem.aem09,tm.em,g_axa05)    #FUN-B70064 ADD
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            #--FUN-A90026 end----
                        END IF
                    ELSE
                        #--FUN-A90026 start---
                        CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                      l_axe.axe11,l_axz.axz06,
                                     #l_axz.axz07,g_aem.aem09,tm.em)            #FUB-B70064 MARK
                                      l_axz.axz07,g_aem.aem09,tm.em,g_axa05)    #FUN-B70064 ADD
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        #--FUN-A90026 end---
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe11='3' THEN  #本期損益BS為資產負債類科目，此時不需處理
                      #-MOD-C90148-add-
                       IF g_axa05 = '1' THEN     
                          CALL p001_fun_aem_avg(l_axe.axe11,g_aem.aem04,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                          RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                       ELSE
                      #-MOD-C90148-end- 
                          #--FUN-A90026 start--
                          CALL p001_fun_amt(l_aag04,g_aem.aem11,g_aem.aem12,
                                        l_axe.axe11,l_axz.axz06,
                                       #l_axz.axz07,g_aem.aem09,tm.em)            #FUN-B70064 MARK
                                        l_axz.axz07,g_aem.aem09,tm.em,g_axa05)    #FUN-B70064 ADD
                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                          #--FUN-A90026 end----
                       END IF   #MOD-C90148
                    END IF

                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_axe.axe12='1' THEN 
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axe.axe12,l_axz.axz07,
                                         #x_aaa03,g_aem.aem09,tm.em)            #FUN-B70064 MARK
                                          x_aaa03,g_aem.aem09,tm.em,g_axa05)    #FUN-B70064  ADD
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        #---FUN-A90026 mark----
                    END IF

                    #--歷史匯率---
                    IF l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs30 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs30
                        USING g_dept[i].axa01,g_dept[i].axb04,
                              g_aem.aem04,g_date_e      #FUN-A90026
                        FETCH p001_cnt_cs30 INTO l_axr_count
                        CLOSE p001_cnt_cs30
                        IF l_axr_count > 0 THEN   
                            CALL p001_axr(i,l_axe.axe04,g_aem.aem04,g_date_e)      #FUN-A90026   #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axe.axe12,l_axz.axz07,
                                             #x_aaa03,g_aem.aem09,tm.em)       #FUN-A90026    #FUN-B70064 MARK
                                              x_aaa03,g_aem.aem09,tm.em,g_axa05)              #FUN-B70064 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
		        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		    		      l_axe.axe12,l_axz.axz07,
		    		     #x_aaa03,g_aem.aem09,tm.em)           #FUN-A90026        #FUN-B70064 MARK	  
		    		      x_aaa03,g_aem.aem09,tm.em,g_axa05)                      #FUN-B70064 ADD 	
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axe.axe12='3' THEN
                      #-MOD-C90148-add-
                       IF g_axa05 = '1' THEN 
                          CALL p001_aem_avg(l_axe.axe11,l_axe.axe12,g_aem.aem04,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                       ELSE
                      #-MOD-C90148-end- 
   		          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
		             	        l_axe.axe12,l_axz.axz07,
                                       #x_aaa03,g_aem.aem09,tm.em)        #FUN-A90026         #FUN-B70064 MARK
		            	        x_aaa03,g_aem.aem09,tm.em,g_axa05)                    #FUN-B70064 ADD
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                       END IF   #MOD-C90148
                    END IF
                    #-------FUN-A60038 end-----------------------------------

                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07    #FUN-A60060 mod
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                    #->幣別轉換及取位 
 
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
                   #FUN-BA0111--
                    CALL p001_get_aei23(
                         g_aaz641,g_dept[i].axa01,g_dept[i].axa02,g_dept[i].axa03,g_dept[i].axb04
                        ,g_dept[i].axb05,g_aem.aem04,g_aem.aem05,g_aem.aem06,g_aem.aem07
                        ,g_aem.aem08,g_aem.aem09,tm.em,l_axz06,g_aem.aem16
                        ,g_aem.aem17,g_aem.aem18,g_aem.aem19)
                    RETURNING l_aei23,l_aei24
                   #FUN-BA0111--

                    INSERT INTO aei_file
                     (aei00,aei01,aei02,aei021,aei03,aei031,
                      aei04,aei05,aei06,aei07,aei08,aei09,
                      aei10,aei11,aei12,aei13,aei14,aei15,
                      aei16,aei17,aei18,aeilegal
                     ,aei19,aei20,aei21,aei22,aei23,aei24              #FUN-BA0111 add
                     )
                    VALUES
                      (g_aaz641,g_dept[i].axa01,g_dept[i].axa02,
                      g_dept[i].axa03,g_dept[i].axb04,g_dept[i].axb05, 
                      g_aem.aem04,g_aem.aem05,g_aem.aem06,g_aem.aem07, #FUN-A90026 mod
                      g_aem.aem08,g_aem.aem09,tm.em,g_aem.aem11, #FUN-A90026 mod
                      g_aem.aem12,g_aem.aem13,g_aem.aem14,tm.ver,      #FUN-A90026 mod
                      l_aei16,l_aei17,l_axz06,g_azw02
                     ,g_aem.aem16,g_aem.aem17,g_aem.aem18,g_aem.aem19 #FUN-BA0111 add
                      ,l_aei23,l_aei24                                 #FUN-BA0111 add
                     )
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                       UPDATE aei_file SET aei11=aei11+l_chg_aem11_1,         #FUN-A90026 mod
                                           aei12=aei12+l_chg_aem12_1,         #FUN-A90026 mod
                                           aei13=aei13+g_aem.aem13,           #FUN-A90026 mod
                                           aei14=aei14+g_aem.aem14,           #FUN-A90026 mod
                                           aei16=l_aei16,
                                           aei17=l_aei17
                        WHERE aei00 = g_aaz641
                          AND aei01 = g_dept[i].axa01
                          AND aei02 = tm.axa02  #FUN-A30064                                                                                                         
                          AND aei021= g_dept[i].axa03
                          AND aei03 = g_dept[i].axb04
                          AND aei031= g_dept[i].axb05
                          AND aei04 = g_aem.aem04    #FUN-A90026 mod
                          AND aei05 = g_aem.aem05    #FUN-A90026 mod
                          AND aei06 = g_aem.aem06    #FUN-A90026 mod
                          AND aei07 = g_aem.aem07    #FUN-A90026 mod
                          AND aei08 = g_aem.aem08    #FUN-A90026 mod
                          AND aei09 = g_aem.aem09    #FUN-A90026 mod
                          AND aei10 = tm.em          #FUN-A90026 mod
                          AND aei15 = tm.ver
                          AND aei18 = l_axz06
                          AND aei19 = g_aem.aem16          #FUN-BA0111 add
                          AND aei20 = g_aem.aem17          #FUN-BA0111 add
                          AND aei21 = g_aem.aem18          #FUN-BA0111 add
                          AND aei22 = g_aem.aem19          #FUN-BA0111 add
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
        ELSE #有下層資料
                LET l_sql=" SELECT * FROM axh_file ",          
                          " WHERE axh06=",tm.yy,
                          " AND axh07 ='",tm.em,"'",             #FUN-970046 mod  只抓異動月份資料
                          " AND axh01 ='",g_dept[i].axa01,"'",
                          " AND axh04 ='",g_dept[i].axb04,"'", 
                          " AND axh041='",g_dept[i].axb05,"'",
                          " AND axh13 ='",tm.ver,"' ",          #FUN-760053
                          " AND axh05 <> '",g_aaz113,"'",       #FUN-A90006 
                          " ORDER BY axh05 "                    #FUN-A90006
                    
                PREPARE p001_axh_p FROM l_sql
                IF STATUS THEN
                   CALL s_errmsg(' ',' ','prepare:3',STATUS,1)  
                   LET g_success = 'N'
                   CONTINUE FOR                       #NO.FUN-710023 
                END IF
                DECLARE p001_axh_c CURSOR FOR p001_axh_p
                FOREACH p001_axh_c INTO l_axh.*
                    IF SQLCA.sqlcode THEN 
                       CALL s_errmsg(' ',' ','p001_axh_c',SQLCA.sqlcode,1) #NO.FUN-710023 
                       LET g_success = 'N' 
                       CONTINUE FOREACH      #TQC-770178 mod EXIT->CONTINUE
                    END IF
                    LET l_axh.axh00=g_aaz641    #FUN-920067 mod
                    LET l_axh.axh01=g_dept[i].axa01
                    LET l_axh.axh02=g_dept[i].axa02
                    LET l_axh.axh03=g_dept[i].axa03
              
                    LET l_axe04_cnt = 0                    #MOD-A80102
                    SELECT COUNT(*) INTO l_axe04_cnt
                       FROM axr_file,axee_file,axh_file    #MOD-A80102
                      WHERE axr07 = axee04                 #MOD-A80102
                        AND axh05 = axee06                 #MOD-A80102
                        AND axr01 = g_dept[i].axa01                   
                        AND axr02 = g_dept[i].axb04                   
                        AND axr03 = axee06                 #FUN-A90026 add
                        AND axee06 = l_axh.axh05           #MOD-A80102
               
                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
                    #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
                    #  乘上匯率逐一算出借貸方計帳金額(axg08,axg09 OR axk10,axk11)
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)      #NO.FUN-710023
                       LET g_success = 'N'
                       CONTINUE FOREACH      #TQC-770178 mod EXIT->CONTINUE
                    END IF
               
                    LET l_axee.axee11 = '1'                                                                                               
                    LET l_axee.axee12 = '1'                                                                                               

                    #---FUN-A90026 start----
                    LET l_sql = 
                    " SELECT axee04,axee11,axee12 FROM axee_file ",  #TQC-AA0098
                    "  WHERE axee01 = '",g_dept[i].axb04,"'",
                    "    AND axee06 = '",l_axh.axh05,"'",
                    "    AND axee00 = '",l_axh.axh00,"'", 
                    "    AND axee13 = '",tm.axa01,"'"   
                    PREPARE p001_axee_p1 FROM l_sql
                    DECLARE p001_axee_c1 SCROLL CURSOR FOR p001_axee_p1
                    OPEN p001_axee_c1 
                    FETCH FIRST p001_axee_c1 INTO l_axee.*
                    CLOSE p001_axee_c1
                    #---FUN-A90026 end--------

                    IF SQLCA.sqlcode THEN                                                                                                 
                       LET g_showmsg=g_dept[i].axb04,"/",l_axh.axh05                          #MOD-A70111 add  
                       CALL s_errmsg('axee01,axee04',g_showmsg,l_axh.axh05,'aap-021',1)       #MOD-A70111 add 
                       LET g_success = 'N'                                                    #MOD-A70111 add
                       CONTINUE FOREACH                                                                                                   
                    END IF                                                                                                                
                    LET l_aag04=''                                                                                                        
                    LET l_axe.* = l_axee.*  

                    LET g_sql = "SELECT aag04 FROM aag_file",    #MOD-A80102
                                " WHERE aag00='",l_axh.axh00,"'", #帳別                                                                 
                                "   AND aag01='",l_axh.axh05,"'" #科目                                                                  
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
                    PREPARE p001_pre_axee01 FROM g_sql 
                    DECLARE p001_cur_axee01 CURSOR FOR p001_pre_axee01                                                                            
                    OPEN p001_cur_axee01                                                                                                      
                    FETCH p001_cur_axee01 INTO l_aag04                                                                                        
                    CLOSE p001_cur_axee01                                                                                                     
                    IF cl_null(l_aag04) THEN LET l_aag04='1' END IF                                                                       
                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                    #一一換算後再加總起來

                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    #IF l_axe.axe11='2' AND l_axe.axe12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN   #FUN-770069  #FUN-970046 mod #FUN-A60038 mark
                    LET l_chg_axh08_1=0
                    LET l_chg_axh09_1=0
                    LET l_chg_axh08=0
                    LET l_chg_axh09=0
                    LET l_chg_axh08_a=0
                    LET l_chg_axh09_a=0
                    #---FUN-A60038 start---
                    LET l_chg_dr = 0 
                    LET l_chg_cr = 0
                    LET l_fun_dr = 0 
                    LET l_fun_cr = 0 
                    LET l_acc_dr = 0 
                    LET l_acc_cr = 0
                    #---FUN-A60038 end-----

                    #--FUN-A70065 start-------
                    LET l_dr = 0  
                    LET l_cr = 0  
                    LET l_axh08_1=0
                    LET l_axh08_2=0
                    LET l_axh09_1=0
                    LET l_axh09_2=0
                    IF l_axe04_cnt > 0 THEN   #有抓到來源科目
                            #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                            #--現時匯率---
                            IF l_axee.axee11='1' THEN 
                                CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axh.axh06,l_axh.axh07)           #FUN-BA0012
                                                  l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF

                            #--歷史匯率---
                            IF l_axee.axee11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                                #----如果agli011抓不到資料，則依科目餘額計算---- 
                                DECLARE p001_cnt_cs38 CURSOR FOR p001_axr_p2
                                OPEN p001_cnt_cs38
                                USING g_dept[i].axa01,g_dept[i].axb04,
                                l_axh.axh05,g_date_e      #FUN-A90026 mod
                                FETCH p001_cnt_cs38 INTO l_axr_count
                                CLOSE p001_cnt_cs38
                                IF l_axr_count > 0 THEN   
                                    CALL p001_axr(i,l_axee.axee04,l_axh.axh05,g_date_e)   #FUN-A90026 mod   #TQC-AA0098
                                    RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                                ELSE
                                    #--取不到agli011時一樣用匯率換算---
                                    CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                                      l_axee.axee11,l_axz.axz06,
                                                     #l_axz.axz07,l_axh.axh06,l_axh.axh07)          #FUN-BA0012 mark
                                                      l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)  #FUN-BA0012 add
                                    RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                                END IF
                            ELSE
                                CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axh.axh06,l_axh.axh07)              #FUN-BA0012 mark
                                                  l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)      #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF

                            #--平均匯率---       
                            IF l_axee.axee11='3' THEN
                                #-FUN-AB0004 start-
                                IF g_axa05 = '1' THEN      
                                    CALL p001_axh_fun_avg(l_axee.axee11,l_axh.axh05,
                                                          l_axz.axz06,l_axz.axz07,
                                                          l_axh.axh06,l_axh.axh07,i)   
                                    RETURNING l_fun_dr,l_fun_cr 
                                ELSE
                                #--FUN-AB0004 end--
                                    CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                                      l_axee.axee11,l_axz.axz06,
                                                     #l_axz.axz07,l_axh.axh06,l_axh.axh07)           #FUN-BA0012 mark
                                                      l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012 add
                                    RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                                END IF  #FUN-AB0004
                            END IF

                            #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                            #--現時匯率---
                            IF l_axee.axee12='1' THEN 
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axh.axh06,l_axh.axh07)           #FUN-BA0012 mark
                                                  x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF

                            #--歷史匯率---
                            IF l_axee.axee12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                                #----如果agli011抓不到資料，則依科目餘額計算---- 
                                DECLARE p001_cnt_cs37 CURSOR FOR p001_axr_p2
                                OPEN p001_cnt_cs37
                                USING g_dept[i].axa01,g_dept[i].axb04,
                                l_axh.axh05,g_date_e     #FUN-A90026 mod
                                FETCH p001_cnt_cs37 INTO l_axr_count
                                CLOSE p001_cnt_cs37
                                IF l_axr_count > 0 THEN   
                                    CALL p001_axr(i,l_axee.axee04,l_axh.axh05,g_date_e)   #FUN-A90026 mod   #TQC-AA0098
                                    RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                                ELSE
                                    #--取不到agli011時一樣用匯率換算---
                                    CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axh.axh06,l_axh.axh07)         #FUN-BA0012 mark
                                                  x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05) #FUN-BA0012 add
                                    RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                                END IF
                            ELSE
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                             #x_aaa03,l_axh.axh06,l_axh.axh07)           #FUN-BA0012 mark
                                              x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF
       
                            #--平均匯率---
                            IF l_axee.axee12='3' THEN
                                #-FUN-AB0004 start-
                                IF g_axa05 = '1' THEN 
                                    CALL p001_axh_avg(l_axee.axee11,l_axee.axee12,l_axh.axh05,
                                                      l_axz.axz06,l_axz.axz07,
                                                      l_axh.axh06,l_axh.axh07,i)
                                    RETURNING l_acc_dr,l_acc_cr 
                                ELSE
                                #-FUN-AB0004 end--
                                    CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axh.axh06,l_axh.axh07)         #FUN-BA0012 mark
                                                  x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05) #FUN-BA0012 add
                                    RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                                END IF    #FUN-AB0004
                            END IF
                            #-------FUN-A60038 end-----------------------------------

                            #---FUN-A60038 start---
                            LET l_chg_axh08  =l_chg_axh08   + l_fun_dr
                            LET l_chg_axh09  =l_chg_axh09   + l_fun_cr
                            LET l_chg_axh08_1=l_chg_axh08_1 + l_acc_dr 
                            LET l_chg_axh09_1=l_chg_axh09_1 + l_acc_cr
                            #---FUN-A60038 end----
                            
                            #--FUN-A60060 start-
                            SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07
                            IF cl_null(l_cut) THEN LET l_cut=0 END IF
                            SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                            IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                            #--FUN-A60060 end---

                            LET l_chg_axh08=cl_digcut(l_chg_axh08,l_cut)
                            LET l_chg_axh09=cl_digcut(l_chg_axh09,l_cut)
                            LET l_chg_axh08_1=cl_digcut(l_chg_axh08_1,l_cut1)
                            LET l_chg_axh09_1=cl_digcut(l_chg_axh09_1,l_cut1)
                            IF cl_null(l_chg_axh08_1) THEN LET l_chg_axh08_1=0 END IF
                            IF cl_null(l_chg_axh09_1) THEN LET l_chg_axh09_1=0 END IF
              
                            #--FUN-A90026 start--
                            IF g_axa05 = '1' THEN
                                IF l_axe.axe11 = '3' THEN  #1010116
                                    IF l_axz.axz06 != l_axz.axz07 THEN
                                        LET l_axg18 = (l_chg_axh08-l_chg_axh09)/(l_axh.axh08-l_axh.axh09)
                                    ELSE
                                        LET l_axg18 = l_rate
                                    END IF
                                #--TQC-AA0098 START
                                ELSE
                                    LET l_axg18 = l_rate
                                END IF
                                #--TQC-AA0098 end

                                IF l_axe.axe12 = '3' THEN   #TQC-AA0098
                                    IF l_axz.axz07 != x_aaa03 THEN
                                        LET l_axg19 = (l_chg_axh08_1-l_chg_axh09_1)/(l_chg_axh08-l_chg_axh09)
                                    ELSE
                                        LET l_axg19 = l_rate1
                                    END IF
                                #--TQC-AA0098 START
                                ELSE
                                    LET l_axg19 = l_rate1
                                END IF
                                #--TQC-AA0098 end
                            ELSE
                            #--FUN-A90026 end-------
                                LET l_axg18 = l_rate   #FUN-960003
                                LET l_axg19 = l_rate1  #FUN-960003
                            END IF   #FUN-A90026 add

                            INSERT INTO axg_file 
                                  (axg00,axg01,axg02,axg03,axg04,axg041,
                                   axg05,axg06,axg07,axg08,axg09,axg10,
                                   axg11,axg12,axg13,axg14,axg15,axg16,axg17,   #FUN-750078 add axg17
                                   axglegal,
                                   axg18,axg19)                                 #FUN-970046
                             VALUES 
                                  (g_aaz641,l_axh.axh01,l_axh.axh02,l_axh.axh03,      #FUN-970046 mod
                                   l_axh.axh04,l_axh.axh041,l_axh.axh05,l_axh.axh06,    #MOD-A70107 mark   #FUN-A90026 mod
                                   l_axh.axh07,l_chg_axh08_1,l_chg_axh09_1,l_axh.axh10,
                                   l_axh.axh11,l_axz06,l_axh.axh08,l_axh.axh09,   #MOD-750036
                                   l_chg_axh08,l_chg_axh09,tm.ver,              #FUN-750078 add tm.ver
                                   g_azw02,
                                   l_axg18,l_axg19)                             #FUN-970046
                            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                               UPDATE axg_file    SET axg08=axg08+l_chg_axh08_1,
                                                      axg09=axg09+l_chg_axh09_1,
                                                      axg10=axg10+l_axh.axh10,
                                                      axg11=axg11+l_axh.axh11,
                                                      axg13=axg13+l_axh.axh08,   #FUN-770069 mod
                                                      axg14=axg14+l_axh.axh09,   #FUN-770069 mod
                                                      axg15=axg15+l_chg_axh08,
                                                      axg16=axg16+l_chg_axh09,
                                                      axg18=l_axg18,             #FUN-970046
                                                      axg19=l_axg19              #FUN-970046
                                   WHERE axg00 = g_aaz641            #FUN-970046 MOD
                                     AND axg01 = l_axh.axh01
                                     AND axg02 = l_axh.axh02
                                     AND axg03 = l_axh.axh03
                                     AND axg04 = l_axh.axh04
                                     AND axg041= l_axh.axh041
                                     AND axg05 = l_axh.axh05        #FUN-A90026 mod
                                     AND axg06 = l_axh.axh06
                                     AND axg07 = l_axh.axh07
                                     AND axg12 = l_axz06              #FUN-930117
                                     AND axg17 = tm.ver              #MOD-930135
                               #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                                  CALL s_errmsg('axg01',l_axh.axh01,'upd_axg',SQLCA.sqlcode,1) 
                                  LET g_success = 'N' 
                                  CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                               END IF
                            ELSE
                               IF SQLCA.sqlcode THEN 
                                  LET g_showmsg=l_axh.axh01,"/",l_axh.axh02,l_axh.axh03,"/",l_axh.axh04 
                                  CALL s_errmsg('axg01,axg02,axg03,axg04',g_showmsg,'ins_axg',status,1)   #NO.FUN-710023
                                  LET g_success = 'N' 
                                  CONTINUE FOREACH      #NO.FUN-710023   #TQC-770178 mod EXIT->CONTINUE
                               END IF
                            END IF   #TQC-770118 add
                    ELSE     #無來源科目時抓不到axr_file,依舊用axh_file處理
                        #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                        #--現時匯率---
                        IF l_axee.axee11='1' THEN 
                            CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                              l_axee.axee11,l_axz.axz06,
                                             #l_axz.axz07,l_axh.axh06,l_axh.axh07)          #FUN-BA0012 mark
                                              l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)  #FUN-BA0012 add
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF

                        #--歷史匯率---
                        IF l_axee.axee11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                            CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                              l_axee.axee11,l_axz.axz06,
                                             #l_axz.axz07,l_axh.axh06,l_axh.axh07)          #FUN-BA0012 mark
                                              l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)  #FUN-BA0012 add
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
       
                        #--平均匯率---
                        IF l_axee.axee11='3' THEN
                            #-FUN-AB0004 start-
                            IF g_axa05 = '1' THEN      
                                CALL p001_axh_fun_avg(l_axee.axee11,l_axh.axh05,
                                                      l_axz.axz06,l_axz.axz07,
                                                      l_axh.axh06,l_axh.axh07,i)   
                                RETURNING l_fun_dr,l_fun_cr 
                            ELSE
                            #--FUN-AB0004 end--
                                CALL p001_fun_amt(l_aag04,l_axh.axh08,l_axh.axh09,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axh.axh06,l_axh.axh07)           #FUN-BA0012 mark
                                                  l_axz.axz07,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF #FUN-AB0004
                        END IF
 

                        #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                        #--現時匯率---
                        IF l_axee.axee12='1' THEN 
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                             #x_aaa03,l_axh.axh06,l_axh.axh07)          #FUN-BA0012 mark
                                              x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05)  #FUN-BA0012 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF

                        #--歷史匯率---
                        IF l_axee.axee12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                          l_axee.axee12,l_axz.axz07,
                                         #x_aaa03,l_axh.axh06,l_axh.axh07)             #FUN-BA0012 mark
                                          x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05)     #FUN-BA0012 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
       
                        #--平均匯率---
                        IF l_axee.axee12='3' THEN
                            #-FUN-AB0004 start-
                            IF g_axa05 = '1' THEN 
                                CALL p001_axh_avg(l_axee.axee11,l_axee.axee12,l_axh.axh05,
                                                  l_axz.axz06,l_axz.axz07,
                                                  l_axh.axh06,l_axh.axh07,i)
                                RETURNING l_acc_dr,l_acc_cr 
                            ELSE
                            #-FUN-AB0004 end--
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                             #x_aaa03,l_axh.axh06,l_axh.axh07)           #FUN-BA0012 mark
                                              x_aaa03,l_axh.axh06,l_axh.axh07,g_axa05)   #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF  #FUN-AB0004
                        END IF
                        #-------FUN-A60038 end-----------------------------------

                        #--FUN-A60038 start--
                        LET l_chg_axh08=l_fun_dr
                        LET l_chg_axh09=l_fun_cr
                        LET l_chg_axh08_1=l_acc_dr
                        LET l_chg_axh09_1=l_acc_cr
                        #---FUN-A60038 end---

                        #--FUN-A60060 start-
                        SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07
                        IF cl_null(l_cut) THEN LET l_cut=0 END IF
                        SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                        IF cl_null(l_cut1) THEN LET l_cut1=0 END IF
                        #--FUN-A60060 end---

##--FUN-970046 add for 無來源科目時直接以axh資料單筆寫入-------------
                        #LET l_axh.axh05=l_axee.axee06  #FUN-970046 mod  #FUN-A90026 mark
                        LET l_chg_axh08=cl_digcut(l_chg_axh08,l_cut)
                        LET l_chg_axh09=cl_digcut(l_chg_axh09,l_cut)
                        LET l_chg_axh08_1=cl_digcut(l_chg_axh08_1,l_cut1)
                        LET l_chg_axh09_1=cl_digcut(l_chg_axh09_1,l_cut1)
                        IF cl_null(l_chg_axh08_1) THEN LET l_chg_axh08_1=0 END IF
                        IF cl_null(l_chg_axh09_1) THEN LET l_chg_axh09_1=0 END IF
              
                        #--FUN-A90026 start---
                        IF g_axa05 = '1' THEN
                            IF l_axe.axe11 = '3' THEN   #TQC-AA0098
                                IF l_axz.axz06 != l_axz.axz07 THEN
                                    LET l_axg18 = (l_chg_axh08-l_chg_axh09)/(l_axh.axh08-l_axh.axh09)
                                ELSE
                                    LET l_axg18 = l_rate
                                END IF
                            #--TQC-AA0098 START
                            ELSE
                                LET l_axg18 = l_rate
                            END IF
                            #--TQC-AA0098 end--

                            IF l_axe.axe12 = '3' THEN 　#TQC-AA0098
                                IF l_axz.axz07 != x_aaa03 THEN
                                    LET l_axg19 = (l_chg_axh08_1-l_chg_axh09_1)/(l_chg_axh08-l_chg_axh09)
                                ELSE
                                    LET l_axg19 = l_rate1
                                END IF
                            #--TQC-AA0098 START
                            ELSE
                                LET l_axg19 = l_rate1
                            END IF
                            #--TQC-AA0098 end--
                        ELSE
                        #---FUN-A90026 end---
                            LET l_axg18 = l_rate   #FUN-960003
                            LET l_axg19 = l_rate1  #FUN-960003
                        END IF   #FUN-A90026 add

                        INSERT INTO axg_file 
                              (axg00,axg01,axg02,axg03,axg04,axg041,
                               axg05,axg06,axg07,axg08,axg09,axg10,
                               axg11,axg12,axg13,axg14,axg15,axg16,axg17,   #FUN-750078 add axg17
                               axglegal,
                               axg18,axg19)                                 #FUN-970046
                         VALUES 
                              (g_aaz641,l_axh.axh01,l_axh.axh02,l_axh.axh03, 
                               l_axh.axh04,l_axh.axh041,l_axh.axh05,l_axh.axh06,      #MOD-A70107 mark  #FUN-A90026 mod
                               l_axh.axh07,l_chg_axh08_1,l_chg_axh09_1,l_axh.axh10,
                               l_axh.axh11,l_axz06,l_axh.axh08,l_axh.axh09,   
                               l_chg_axh08,l_chg_axh09,tm.ver,
                               g_azw02,
                               l_axg18,l_axg19)                     #FUN-970046           
                        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                           UPDATE axg_file    SET axg08=axg08+l_chg_axh08_1,
                                                  axg09=axg09+l_chg_axh09_1,
                                                  axg10=axg10+l_axh.axh10,
                                                  axg11=axg11+l_axh.axh11,
                                                  axg13=axg13+l_axh.axh08,   
                                                  axg14=axg14+l_axh.axh09,   
                                                  axg15=axg15+l_chg_axh08,
                                                  axg16=axg16+l_chg_axh09,
                                                  axg18=l_axg18,            #FUN-970046
                                                  axg19=l_axg19             #FUN-970046
                               WHERE axg00 = g_aaz641          
                                 AND axg01 = l_axh.axh01
                                 AND axg02 = l_axh.axh02
                                 AND axg03 = l_axh.axh03
                                 AND axg04 = l_axh.axh04
                                 AND axg041= l_axh.axh041
                                 AND axg05 = l_axh.axh05     #FUN-A90026 mod 
                                 AND axg06 = l_axh.axh06
                                 AND axg07 = l_axh.axh07
                                 AND axg12 = l_axz06            
                                 AND axg17 = tm.ver              
                           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                              CALL s_errmsg('axg01',l_axh.axh01,'upd_axg',SQLCA.sqlcode,1) 
                              LET g_success = 'N' 
                              CONTINUE FOREACH      
                           END IF
                        ELSE
                           IF SQLCA.sqlcode THEN 
                              LET g_showmsg=l_axh.axh01,"/",l_axh.axh02,l_axh.axh03,"/",l_axh.axh04 
                              CALL s_errmsg('axg01,axg02,axg03,axg04',g_showmsg,'ins_axg',status,1)   
                              LET g_success = 'N' 
                              CONTINUE FOREACH     
                           END IF
                        END IF   #TQC-770118 add
                    END IF    #FUN-A90006 add
                END FOREACH

#FUN-920067--先取出下層公司axkk_file合并帳別---                                                                                     
                LET g_sql = "SELECT aaz641 ",
                            " FROM ",cl_get_target_table(l_axz03,'aaz_file'),   #FUN-A50102
                            " WHERE aaz00 = '0'"                                                                                        
	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
                CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql   #FUN-A50102
                PREPARE p001_pre_04 FROM g_sql                                                                                          
                DECLARE p001_cur_04 CURSOR FOR p001_pre_04                                                                              
                OPEN p001_cur_04                                                                                                        
                FETCH p001_cur_04 INTO l_aaz641                                                                                         
                CLOSE p001_cur_04                                                                                                       

                LET l_sql=" SELECT * FROM axkk_file ",                                                                                  
                          " WHERE axkk08=",tm.yy,                                                                                       
                          " AND axkk09 ='",tm.em,"'",          #FUN-970046 mod                                                                   
                          " AND axkk00 ='",g_aaz641,"'",       #帳別     #FUN-A90006                                                                
                          " AND axkk01 ='",g_dept[i].axa01,"'",                                                                         
                          " AND axkk04 ='",g_dept[i].axb04,"'",                                                                         
                          " AND axkk041='",g_dept[i].axb05,"'",                                                                         
                          " AND axkk15 ='",tm.ver,"'",                                                                                   
                          " AND axkk05 <> '",g_aaz113,"'"        #FUN-A70086 

                PREPARE p001_axkk_p FROM l_sql                                                                                          
                IF STATUS THEN                                                                                                          
                   CALL s_errmsg(' ',' ','prepare:3_1',STATUS,1)                                                                        
                   LET g_success = 'N'                                                                                                  
                   CONTINUE FOR                                                                                                         
                END IF                                                                                                                  
                DECLARE p001_axkk_c CURSOR FOR p001_axkk_p                                                                              
                FOREACH p001_axkk_c INTO l_axkk.*                                                                                       
                    IF SQLCA.sqlcode THEN                                                                                                 
                       CALL s_errmsg(' ',' ','p001_axkk_c',SQLCA.sqlcode,1)                                                               
                       LET g_success = 'N'                                                                                                
                       CONTINUE FOREACH                                                                                                   
                    END IF                                                                                                                
                    LET l_axkk.axkk01=g_dept[i].axa01                                                                                     
                    LET l_axkk.axkk02=g_dept[i].axa02 
                    LET l_axkk.axkk03=g_dept[i].axa03                                                                                     
                                                                                                                                          
                    SELECT COUNT(*) INTO l_axe04_cnt
                      FROM axr_file,axee_file,axkk_file  #MOD-A80102
                     WHERE axr07 = axee04                #MOD-A80102
                       and axkk05 = axee06               #MOD-A80102
                       and axr01 = g_dept[i].axa01
                       and axr02 = g_dept[i].axb04
                       AND axr03 = axee06                #FUN-A90026 add
                       AND axee06 = l_axkk.axkk05        #MOD-A80102
                    
                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008                                                                   
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,                                                             
                    #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),                                                                   
                    #  乘上匯率逐一算出借貸方記帳金額(axg08,axg09 OR axk10,axk11)                                                         
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04                                                       
                    IF SQLCA.sqlcode THEN                                                                                                 
                       CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)                                                                         
                       LET g_success = 'N'                                                                                                
                       CONTINUE FOREACH                                                                                                   
                    END IF

                    LET l_axee.axee11 = '1'                                                                                               
                    LET l_axee.axee12 = '1'                                                                                               

                    #---FUN-A90026 start----
                    LET l_sql = 
                    " SELECT axee04,axee11,axee12 FROM axee_file ",  #TQC-AA0098
                    "  WHERE axee01 = '",g_dept[i].axb04,"'",
                    "    AND axee06 = '",l_axkk.axkk05,"'",
                    "    AND axee00 = '",l_axkk.axkk00,"'", 
                    "    AND axee13 = '",tm.axa01,"'"   
                    PREPARE p001_axee_p2 FROM l_sql
                    DECLARE p001_axee_c2 SCROLL CURSOR FOR p001_axee_p2
                    OPEN p001_axee_c2 
                    FETCH FIRST p001_axee_c2 INTO l_axee.*
                    CLOSE p001_axee_c2
                    #---FUN-A90026 end--------

                    IF SQLCA.sqlcode THEN                                                                                                 
                       LET g_showmsg=g_dept[i].axb04,"/",l_axkk.axkk05                            #MOD-A70111 add  
                       CALL s_errmsg('axee01,axee04',g_showmsg,l_axkk.axkk05,'aap-021',1)         #MOD-A70111 add 
                       LET g_success = 'N'                                                        #MOD-A70111 add
                       CONTINUE FOREACH                                                                                                   
                    END IF                                                                                                                
                    
                    LET l_aag04=''                                                                                                        
                    LET g_sql = "SELECT aag04 FROM aag_file",       #MOD-A80102                                                             
                                " WHERE aag00='",l_axkk.axkk00,"'", #帳別                                                                 
                                "   AND aag01='",l_axkk.axkk05,"'" #科目                                                                  
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
                    PREPARE p001_pre_03 FROM g_sql 
                    DECLARE p001_cur_03 CURSOR FOR p001_pre_03                                                                            
                    OPEN p001_cur_03                                                                                                      
                    FETCH p001_cur_03 INTO l_aag04                                                                                        
                    CLOSE p001_cur_03                                                                                                     
                    IF cl_null(l_aag04) THEN LET l_aag04='1' END IF                                                                       
                    #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算                                                      
                    LET l_rate  = 1                                                                                                       
                    LET l_rate1 = 1                                                                                                       
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,                                                       
                    #金額需抓agli011設定的記帳幣別金額(小於等於本期),                                                                     
                    #一一換算後再加總起來                                                                                                 

                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    LET l_chg_axkk10_1=0                                                                                               
                    LET l_chg_axkk11_1=0                                                                                               
                    LET l_chg_axkk10=0                                                                                                 
                    LET l_chg_axkk11=0                                                                                                 
                    LET l_chg_axkk10_a=0                                                                                               
                    LET l_chg_axkk11_a=0                                                                                               
                    #---FUN-A60038 start---
                    LET l_chg_dr = 0 
                    LET l_chg_cr = 0
                    LET l_fun_dr = 0 
                    LET l_fun_cr = 0 
                    LET l_acc_dr = 0 
                    LET l_acc_cr = 0
                    #---FUN-A60038 end-----

                    #--FUN-A70065 start-------
                    LET l_dr = 0  
                    LET l_cr = 0  
                    LET l_axkk10_1=0
                    LET l_axkk10_2=0
                    LET l_axkk11_1=0
                    LET l_axkk11_2=0
                    IF l_axe04_cnt > 0 THEN   #有抓到來源科目
                            #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                            #--現時匯率---
                            IF l_axee.axee11='1' THEN 
                                CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF

                            #--歷史匯率---
                            IF l_axee.axee11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                                #----如果agli011抓不到資料，則依科目餘額計算---- 
                                DECLARE p001_cnt_cs39 CURSOR FOR p001_axr_p2
                                OPEN p001_cnt_cs39
                                USING g_dept[i].axa01,g_dept[i].axb04,
                                l_axkk.axkk05,g_date_e     #FUN-A90026 mod
                                FETCH p001_cnt_cs39 INTO l_axr_count
                                CLOSE p001_cnt_cs39
                                IF l_axr_count > 0 THEN   
                                    CALL p001_axr(i,l_axee.axee04,l_axkk.axkk05,g_date_e)   #FUN-A90026 mod  #TQC-AA0098
                                    RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                                ELSE
                                    #--取不到agli011時一樣用匯率換算---
                                    CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                      l_axee.axee11,l_axz.axz06,
                                                     #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                      l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                    RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                                END IF
                            ELSE
                                CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF
       
                            #--平均匯率---
                            IF l_axee.axee11='3' THEN
                                #--FUN-AB0004 start---
                                IF g_axa05 = '1' THEN
       		     	            CALL p001_fun_axkk_avg(l_axee.axee11,l_axkk.axkk05,
                                                           l_axkk.axkk07,l_axz.axz06,l_axz.axz07,
                                                           l_axkk.axkk08,l_axkk.axkk09,i)  
                                    RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                                ELSE
                                #--FUN-AB0004 end---
                                    CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                      l_axee.axee11,l_axz.axz06,
                                                     #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                      l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                    RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                                END IF   #FUN-AB0004
                            END IF 

                            #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                            #--現時匯率---
                            IF l_axee.axee12='1' THEN 
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)         #FUN-BA0012 mark
                                                  x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05) #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF

                            #--歷史匯率---
                            IF l_axee.axee12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                                #----如果agli011抓不到資料，則依科目餘額計算---- 
                                DECLARE p001_cnt_cs40 CURSOR FOR p001_axr_p2
                                OPEN p001_cnt_cs40
                                USING g_dept[i].axa01,g_dept[i].axb04,
                                l_axkk.axkk05,g_date_e      #FUN-A90026 mod
                                FETCH p001_cnt_cs40 INTO l_axr_count
                                CLOSE p001_cnt_cs40
                                IF l_axr_count > 0 THEN   
                                    CALL p001_axr(i,l_axee.axee04,l_axkk.axkk05,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
                                    RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                                ELSE
                                    #--取不到agli011時一樣用匯率換算---
                                    CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                      l_axee.axee12,l_axz.axz07,
                                                     #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                      x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                    RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                                END IF
                            ELSE
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF
       
                            #--平均匯率---
                            IF l_axee.axee12='3' THEN
                                #--FUN-AB0004 start--
                                IF g_axa05 = '1' THEN        
                                    CALL p001_axkk_avg(l_axee.axee11,l_axee.axee12,l_axkk.axkk05,l_axkk.axkk07,
                                                       l_axz.axz06,l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,i)  
                                    RETURNING l_acc_dr,l_acc_cr 
                                ELSE
                                #--FUN-AB0004 end----
                                    CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                      l_axee.axee12,l_axz.axz07,
                                                     #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)         #FUN-BA0012 add
                                                      x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05) #FUN-BA0012 mark
                                    RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                                END IF    #FUN-AB0004 add
                            END IF
                            #-------FUN-A60038 end-----------------------------------
                            #---FUN-A60038 start-- 
                            LET l_chg_axkk10  =l_chg_axkk10   + l_fun_dr
                            LET l_chg_axkk11  =l_chg_axkk11   + l_fun_cr
                            LET l_chg_axkk10_1=l_chg_axkk10_1 + l_acc_dr
                            LET l_chg_axkk11_1=l_chg_axkk11_1 + l_acc_cr 
                            #---FUN-A60038 end----

##--FUN-970046 add for 依axr07科目數來決定寫入筆數-------------
                            #SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06  #FUN-920167                                            
                            SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07   #FUN-A60060
                            IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                             
                            SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                            
                            IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                           
                                                                                                                                                  
                            LET l_chg_axkk10=cl_digcut(l_chg_axkk10,l_cut)                                                                        
                            LET l_chg_axkk11=cl_digcut(l_chg_axkk11,l_cut)                                                                        
                            LET l_chg_axkk10_1=cl_digcut(l_chg_axkk10_1,l_cut1)                                                                   
                            LET l_chg_axkk11_1=cl_digcut(l_chg_axkk11_1,l_cut1)                                                                   
                            IF cl_null(l_chg_axkk10_1) THEN LET l_chg_axkk10_1=0 END IF                                                           
                            IF cl_null(l_chg_axkk11_1) THEN LET l_chg_axkk11_1=0 END IF

                            LET l_axk16 = l_rate      #FUN-960003 add 
                            LET l_axk17 = l_rate1     #FUN-960003 add
 
                            INSERT INTO axk_file                                                                                                  
                                  (axk00,axk01,axk02,axk03,axk04,axk041,                                                                          
                                   axk05,axk06,axk07,axk08,axk09,axk10,                                                                           
                                   axk11,axk12,axk13,axk14,axk15,
                                   axk16,axk17,                    #FUN-970046                                                                                 
                                   axklegal,
                                   axk18,axk19,axk20,axk21)        #FUN-A30079
                             VALUES                                                                                                               
                                  (g_aaz641, l_axkk.axkk01, l_axkk.axkk02,l_axkk.axkk03,    #FUN-920067                                           
                                   l_axkk.axkk04, l_axkk.axkk041,l_axkk.axkk05,l_axkk.axkk06,                                                     
                                   l_axkk.axkk07, l_axkk.axkk08, l_axkk.axkk09,l_chg_axkk10_1,                                                    
                                   l_chg_axkk11_1,l_axkk.axkk12, l_axkk.axkk13,l_axz06,tm.ver,
                                   l_axk16,l_axk17,   #FUN-970046                                                    
                                   g_azw02,
                                   l_axkk.axkk10,l_axkk.axkk11,l_chg_axkk10,l_chg_axkk11)   #FUN-A30079
                            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                                                                               
                               UPDATE axk_file SET axk10=axk10+l_chg_axkk10_1,                                                                    
                                                   axk11=axk11+l_chg_axkk11_1,                                                                    
                                                   axk12=axk12+l_axkk.axkk12,                                                                     
                                                   axk13=axk13+l_axkk.axkk13,
                                                   axk16=l_axk16,  #FUN-970046 
                                                   axk17=l_axk17,  #FUN-970046                                                                     
                                                   axk18=axk18+l_axkk.axkk10,   #FUN-A30079
                                                   axk19=axk19+l_axkk.axkk11,   #FUN-A30079
                                                   axk20=axk20+l_chg_axkk10,    #FUN-A30079
                                                   axk21=axk21+l_chg_axkk11     #FUN-A30079
                                   WHERE axk00 = l_axkk.axkk00                                                                                    
                                     AND axk01 = l_axkk.axkk01                                                                                    
                                     AND axk02 = l_axkk.axkk02                                                                                    
                                     AND axk03 = l_axkk.axkk03                                                                                    
                                     AND axk04 = l_axkk.axkk04                                                                                    
                                     AND axk041= l_axkk.axkk041                                                                                   
                                     AND axk05 = l_axkk.axkk05                                                                                    
                                     AND axk06 = l_axkk.axkk06                                                                                    
                                     AND axk07 = l_axkk.axkk07 
                                     AND axk08 = l_axkk.axkk08                                                                                    
                                     AND axk09 = l_axkk.axkk09                                                                                    
                                     AND axk14 = l_axkk.axkk14        #FUN-930117                                                                 
                                     AND axk15 = tm.ver               #MOD-930135                                                                 
                               #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                            
                               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                        
                                  CALL s_errmsg('axk01',l_axkk.axkk01,'upd_axk',SQLCA.sqlcode,1)                                                  
                                  LET g_success = 'N'                                                                                             
                                  CONTINUE FOREACH                                                                                                
                               END IF                                                                                                             
                            ELSE                                                                                                                  
                               IF SQLCA.sqlcode THEN                                                                                              
                                  LET g_showmsg=l_axkk.axkk01,"/",l_axkk.axkk02,l_axkk.axkk03,"/",l_axkk.axkk04                                   
                                  CALL s_errmsg('axk01,axk02,axk03,axk04',g_showmsg,'ins_axk',status,1)                                           
                                  LET g_success = 'N'                                                                                             
                                  CONTINUE FOREACH                                                                                                
                               END IF                                                                                                             
                            END IF                             
##無來源科目時抓不到axr_file,依舊用axkk_file處理  
                    ELSE        
                        #----FUN-A60038 start-- 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                        #--現時匯率---
                        IF l_axee.axee11='1' THEN 
                            CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                              l_axee.axee11,l_axz.axz06,
                                             #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)           #FUN-BA0012 mark
                                              l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)   #FUN-BA0012 add
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF

                        #--歷史匯率---
                        IF l_axee.axee11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                            #----如果agli011抓不到資料，則依科目餘額計算---- 
                            DECLARE p001_cnt_cs41 CURSOR FOR p001_axr_p2
                            OPEN p001_cnt_cs41
                            USING g_dept[i].axa01,g_dept[i].axb04,
                            l_axkk.axkk05,g_date_e      #FUN-A90026 mark
                            FETCH p001_cnt_cs41 INTO l_axr_count
                            CLOSE p001_cnt_cs41
                            IF l_axr_count > 0 THEN   
                                CALL p001_axr(i,l_axee.axee04,l_axkk.axkk05,g_date_e)   #FUN-A90026 mod   #TQC-AA0098
                                RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            ELSE
                                #--取不到agli011時一樣用匯率換算---
                                CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)         #FUN-BA0012 mark
                                                  l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05) #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF
                        ELSE
                            CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                              l_axee.axee11,l_axz.axz06,
                                             #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)         #FUN-BA0012 mark
                                              l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05) #FUN-BA0012 add
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
       
                        #--平均匯率---
                        IF l_axee.axee11='3' THEN
                            #--FUN-AB0004 start---
                            IF g_axa05 = '1' THEN
       		     	        CALL p001_fun_axkk_avg(l_axee.axee11,l_axkk.axkk05,
                                                       l_axkk.axkk07,l_axz.axz06,l_axz.axz07,
                                                       l_axkk.axkk08,l_axkk.axkk09,i)  
                                RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                            ELSE
                            #--FUN-AB0004 end---
                                CALL p001_fun_amt(l_aag04,l_axkk.axkk10,l_axkk.axkk11,
                                                  l_axee.axee11,l_axz.axz06,
                                                 #l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                            END IF   #FUN-AB0004
                        END IF

                        #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                        #--現時匯率---
                        IF l_axee.axee12='1' THEN 
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                             #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)         #FUN-BA0012 mark
                                              x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05) #FUN-BA0012 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF

                        #--歷史匯率---
                        IF l_axee.axee12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                            #----如果agli011抓不到資料，則依科目餘額計算---- 
                            DECLARE p001_cnt_cs42 CURSOR FOR p001_axr_p2
                            OPEN p001_cnt_cs42
                            USING g_dept[i].axa01,g_dept[i].axb04,
                            l_axkk.axkk05,g_date_e      #FUN-A90026 mod
                            FETCH p001_cnt_cs42 INTO l_axr_count
                            CLOSE p001_cnt_cs42
                            IF l_axr_count > 0 THEN   
                                CALL p001_axr(i,l_axee.axee04,l_axkk.axkk05,g_date_e)    #FUN-A90026 mod   #TQC-AA0098
                                RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                            ELSE
                                #--取不到agli011時一樣用匯率換算---
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF
                        ELSE
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                             #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)           #FUN-BA0012 mark
                                              x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05)   #FUN-BA0012 add
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
       
                        IF l_axee.axee12='3' THEN
                            #--FUN-AB0004 start--
                            IF g_axa05 = '1' THEN        
                                CALL p001_axkk_avg(l_axee.axee11,l_axee.axee12,l_axkk.axkk05,l_axkk.axkk07,
                                                   l_axz.axz06,l_axz.axz07,l_axkk.axkk08,l_axkk.axkk09,i)  
                                RETURNING l_acc_dr,l_acc_cr 
                            ELSE
                            #--FUN-AB0004 end----
                                CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                                  l_axee.axee12,l_axz.axz07,
                                                 #x_aaa03,l_axkk.axkk08,l_axkk.axkk09)          #FUN-BA0012 mark
                                                  x_aaa03,l_axkk.axkk08,l_axkk.axkk09,g_axa05)  #FUN-BA0012 add
                                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                            END IF   #FUN-AB0004
                        END IF

                        LET l_chg_axkk10=l_fun_dr     #功能幣別借方金額                                               
                        LET l_chg_axkk11=l_fun_cr     #功能幣別貸方金額                                               
                        LET l_chg_axkk10_1= l_acc_dr  #記帳幣別借方金額                                               
                        LET l_chg_axkk11_1= l_acc_cr  #記帳幣別貸方金額                                               
                        #----FUN-A60038 end--------

                        SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz07   #FUN-A60060
                        IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                             
                        SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                            
                        IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                           

                        LET l_chg_axkk10=cl_digcut(l_chg_axkk10,l_cut)                                                                        
                        LET l_chg_axkk11=cl_digcut(l_chg_axkk11,l_cut)                                                                        
                        LET l_chg_axkk10_1=cl_digcut(l_chg_axkk10_1,l_cut1)                                                                   
                        LET l_chg_axkk11_1=cl_digcut(l_chg_axkk11_1,l_cut1)                                                                   
                        IF cl_null(l_chg_axkk10_1) THEN LET l_chg_axkk10_1=0 END IF                                                           
                        IF cl_null(l_chg_axkk11_1) THEN LET l_chg_axkk11_1=0 END IF
                        
                        LET l_axk16 = l_rate      #FUN-960003 add  
                        LET l_axk17 = l_rate1     #FUN-960003 add 

                        INSERT INTO axk_file                                                                                                  
                              (axk00,axk01,axk02,axk03,axk04,axk041,                                                                          
                               axk05,axk06,axk07,axk08,axk09,axk10,                                                                           
                               axk11,axk12,axk13,axk14,axk15,
                               axk16,axk17,                       #FUN-970046                                                         
                               axklegal,
                               axk18,axk19,axk20,axk21)           #FUN-A30079
                         VALUES                                                                                                               
                              (g_aaz641, l_axkk.axkk01, l_axkk.axkk02,l_axkk.axkk03,                                         
                               l_axkk.axkk04, l_axkk.axkk041,l_axkk.axkk05,l_axkk.axkk06,                                                     
                               l_axkk.axkk07, l_axkk.axkk08, l_axkk.axkk09,l_chg_axkk10_1,                                                    
                               l_chg_axkk11_1,l_axkk.axkk12, l_axkk.axkk13,l_axz06,tm.ver,
                               l_axk16,l_axk17,   #FUN-97046                                                    
                               g_azw02,
                               l_axkk.axkk10,l_axkk.axkk11,l_chg_axkk10,l_chg_axkk11)  #FUN-A30079
                        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                                                                               
                           UPDATE axk_file SET axk10=axk10+l_chg_axkk10_1,                                                                    
                                               axk11=axk11+l_chg_axkk11_1,                                                                    
                                               axk12=axk12+l_axkk.axkk12,                                                                     
                                               axk13=axk13+l_axkk.axkk13,
                                               axk16=l_axk16,    #FUN-970046
                                               axk17=l_axk17,    #FUN-970046                                                                      
                                               axk18=axk18+l_axkk.axkk10,  #FUN-A30079
                                               axk19=axk19+l_axkk.axkk11,  #FUN-A30079
                                               axk20=axk20+l_chg_axkk10,   #FUN-A30079
                                               axk21=axk21+l_chg_axkk11    #FUN-A30079
                               WHERE axk00 = l_axkk.axkk00                                                                                    
                                 AND axk01 = l_axkk.axkk01                                                                                    
                                 AND axk02 = l_axkk.axkk02                                                                                    
                                 AND axk03 = l_axkk.axkk03                                                                                    
                                 AND axk04 = l_axkk.axkk04                                                                                    
                                 AND axk041= l_axkk.axkk041                                                                                   
                                 AND axk05 = l_axkk.axkk05                                                                                    
                                 AND axk06 = l_axkk.axkk06                                                                                    
                                 AND axk07 = l_axkk.axkk07 
                                 AND axk08 = l_axkk.axkk08                                                                                    
                                 AND axk09 = l_axkk.axkk09                                                                                    
                                 AND axk14 = l_axkk.axkk14                                                             
                                 AND axk15 = tm.ver                                                                          
                           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                            
                           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                        
                              CALL s_errmsg('axk01',l_axkk.axkk01,'upd_axk',SQLCA.sqlcode,1)                                                  
                              LET g_success = 'N'                                                                                             
                              CONTINUE FOREACH                                                                                                
                           END IF                                                                                                             
                        ELSE                                                                                                                  
                           IF SQLCA.sqlcode THEN                                                                                              
                              LET g_showmsg=l_axkk.axkk01,"/",l_axkk.axkk02,l_axkk.axkk03,"/",l_axkk.axkk04                                   
                              CALL s_errmsg('axk01,axk02,axk03,axk04',g_showmsg,'ins_axk',status,1)                                           
                              LET g_success = 'N'                                                                                             
                              CONTINUE FOREACH                                                                                                
                           END IF                                                                                                             
                        END IF                                                                                                                
                    END IF  #for l_axr_count = 0 
                END FOREACH    #FOR axkk_file foreach                                                                                                          

                LET l_sql=" SELECT * FROM aeii_file ",
                       "  WHERE aeii09=",tm.yy,	
                       "  AND aeii10 ='",tm.em,"'",
                       "  AND aeii00 ='",g_aaz641,"'",       #帳別    #FUN-A90006
                       "  AND aeii01 ='",g_dept[i].axa01,"'",
                       "  AND aeii03 ='",g_dept[i].axb04,"'",
                       "  AND aeii031='",g_dept[i].axb05,"'",
                       "  AND aeii15 ='",tm.ver,"'"
                PREPARE p001_aeii_p FROM l_sql
                IF STATUS THEN
                   CALL s_errmsg(' ',' ','prepare:aeii_p',STATUS,1)
                   LET g_success = 'N'
                   CONTINUE FOR	
                END IF
                DECLARE p001_aeii_c CURSOR FOR p001_aeii_p
                FOREACH p001_aeii_c INTO l_aeii.*
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg(' ',' ','p001_aeii_c',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH	
                    END IF
                    LET l_aeii.aeii01 =g_dept[i].axa01
                    LET l_aeii.aeii02 =g_dept[i].axa02
                    LET l_aeii.aeii021=g_dept[i].axa03
                    SELECT COUNT(*) INTO l_axe04_cnt
                      FROM axr_file,axee_file,aeii_file  #FUN-A80130
                     WHERE axr07 = axee04	　           #FUN-A80130
                       AND aeii04 = axee06	             #FUN-A80130
                       AND axr01 = g_dept[i].axa01
                       AND axr02 = g_dept[i].axb04
                       AND axee06 = l_aeii.aeii04        #FUN-A80130

                    #2.匯率依agli001科目匯率類別(axe11)設定,對應agli008
                    #  年度期別來源幣別轉換匯率(axp05 or axp06 or axp07)設定,
                    #  金額(axq08,axq09 OR aah04,aah05 OR aed05,aed06),
                    #  乘上匯率逐一算出借貸方記賬金額(axg08,axg09 OR aei11,aei12)
                    SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_dept[i].axb04
                    IF SQLCA.sqlcode THEN
                       CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       CONTINUE FOREACH	
                    END IF
                    LET l_axee.axee11 = '1'
                    LET l_axee.axee12 = '1'

                    #---FUN-A90026 start----
                    LET l_sql = 
                    " SELECT axee04,axee11,axee12 FROM axee_file ",   #TQC-AA0098
                    "  WHERE axee01 = '",g_dept[i].axb04,"'",
                    "    AND axee06 = '",l_aeii.aeii04,"'",
                    "    AND axee00 = '",l_aeii.aeii00,"'", 
                    "    AND axee13 = '",tm.axa01,"'" 
                    PREPARE p001_axee_p3 FROM l_sql
                    DECLARE p001_axee_c3 SCROLL CURSOR FOR p001_axee_p3
                    OPEN p001_axee_c3 
                    FETCH FIRST p001_axee_c3 INTO l_axee.*
                    CLOSE p001_axee_c3
                    #---FUN-A90026 end--------

                    IF SQLCA.sqlcode THEN
                       LET g_showmsg=g_dept[i].axb04,"/",l_aeii.aeii04                          #MOD-A70111 add
                       CALL s_errmsg('axee01,axee04',g_showmsg,l_aeii.aeii04,'aap-021',1)       #MOD-A70111 add 
                       LET g_success = 'N'                                                      #MOD-A70111 add
                       CONTINUE FOREACH	
                    END IF
                    LET l_aag04=''
                    LET g_sql = "SELECT aag04 FROM aag_file",                                   #FUN-A80130 
                                " WHERE aag00='",l_aeii.aeii00,"'", #帳別
                                "   AND aag01='",l_aeii.aeii04,"'" #科目
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    PREPARE p001_aeii_p1 FROM g_sql
                    DECLARE p001_aeii_c1 CURSOR FOR p001_aeii_p1
                    OPEN p001_aeii_c1
                    FETCH p001_aeii_c1 INTO l_aag04
                    CLOSE p001_aeii_c1
                    IF cl_null(l_aag04) THEN LET l_aag04='1' END IF
                    #當上層公司不等于下層公司時,才需要抓匯率來計算,否則匯率用1來計算
                    LET l_rate  = 1
                    LET l_rate1 = 1
                    #當再衡量匯率類別(axe11),換算匯率類別(axe12)選擇的是歷史匯率時,
                    #金額需抓agli011設定的記賬幣別金額(小于等于本期),
                    #一一換算后再加總起來

                    #--條件( g_dept[i].axa02 != g_dept[i].axb04 )-->本層對本層不會有長投
                    LET l_chg_aeii11_1=0
                    LET l_chg_aeii12_1=0
                    LET l_chg_aeii11=0
                    LET l_chg_aeii12=0
                    LET l_chg_aeii11_a=0
                    LET l_chg_aeii12_a=0

                    #--FUN-A70065 start-------
                    LET l_dr = 0
                    LET l_cr = 0
                    LET l_aeii11_1=0
                    LET l_aeii11_2=0
                    LET l_aeii12_1=0
                    LET l_aeii12_2=0

                    
                    #----FUN-A60038 依科目在agli001中(再衡量)匯率後計算下層功能幣金額--
                    #--現時匯率---
                    IF l_axee.axee11='1' THEN 
                        CALL p001_fun_amt(l_aag04,l_aeii.aeii11,l_aeii.aeii12,  #FUN-A70065
                                          l_axee.axee11,l_axz.axz06,
                                         #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012
                                          l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012 add
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axee.axee11='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs43 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs43
                        USING g_dept[i].axa01,g_dept[i].axb04,
                        l_aeii.aeii04,g_date_e     #FUN-A90026 mod
                        FETCH p001_cnt_cs43 INTO l_axr_count
                        CLOSE p001_cnt_cs43
                        IF l_axr_count > 0 THEN   
                            CALL p001_axr(i,l_axee.axee04,l_aeii.aeii04,g_date_e)    #FUN-A90026 mod  #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                            CALL p001_fun_amt(l_aag04,l_aeii.aeii11,l_aeii.aeii12,  #FUN-A70065
                                              l_axee.axee11,l_axz.axz06,
                                             #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012 mark
                                              l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012 add
                            RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                        END IF
                    ELSE
                        CALL p001_fun_amt(l_aag04,l_aeii.aeii11,l_aeii.aeii12,  #FUN-A70065
                                          l_axee.axee11,l_axz.axz06,
                                         #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012 mark
                                          l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012 add
                        RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axee.axee11='3' THEN
                      #-MOD-C90148-add-
                       IF g_axa05 = '1' THEN     
                          CALL p001_fun_aeii_avg(l_axe.axe11,l_aeii.aeii04,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                          RETURNING l_fun_dr,l_fun_cr  #上層記帳借/貸金額
                       ELSE
                      #-MOD-C90148-end- 
                          CALL p001_fun_amt(l_aag04,l_aeii.aeii11,l_aeii.aeii12,   #FUN-A70065 
                                            l_axee.axee11,l_axz.axz06,
                                           #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012 mark
                                            l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012 add
                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                       END IF   #MOD-C90148
                    END IF

                    #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                    #--現時匯率---
                    IF l_axee.axee12='1' THEN
                      #-MOD-C90148-mark- 
                      # CALL p001_fun_amt(l_aag04,l_fun_dr,l_fun_cr,
                      #                   l_axee.axee11,l_axz.axz06,
                      #                  #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012 mark
                      #                   l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012 add
                      #-MOD-C90148-mark-
                      #-MOD-C90148-add- 
                       CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_axee.axee12,l_axz.axz07,
                                         x_aaa03,l_aeii.aeii09,l_aeii.aeii10,g_axa05) 
                      #-MOD-C90148-end- 
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF

                    #--歷史匯率---
                    IF l_axee.axee12='2' AND ( g_dept[i].axa02 != g_dept[i].axb04 ) THEN  
                        #----如果agli011抓不到資料，則依科目餘額計算---- 
                        DECLARE p001_cnt_cs44 CURSOR FOR p001_axr_p2
                        OPEN p001_cnt_cs44
                        USING g_dept[i].axa01,g_dept[i].axb04,
                        l_aeii.aeii04,g_date_e      #FUN-A90026 mod
                        FETCH p001_cnt_cs44 INTO l_axr_count
                        CLOSE p001_cnt_cs44
                        IF l_axr_count > 0 THEN   
                            CALL p001_axr(i,l_axee.axee04,l_aeii.aeii04,g_date_e)     #FUN-A90026 mod  #TQC-AA0098
                            RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                        ELSE
                            #--取不到agli011時一樣用匯率換算---
                           #-MOD-C90148-mark-
                           #CALL p001_fun_amt(l_aag04,l_fun_dr,l_fun_cr,
                           #                  l_axee.axee11,l_axz.axz06,
                           #                 #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012
                           #                  l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012
                           #-MOD-C90148-mark-
                           #-MOD-C90148-add- 
                            CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                              l_axee.axee12,l_axz.axz07,
                                              x_aaa03,l_aeii.aeii09,l_aeii.aeii10,g_axa05) 
                           #-MOD-C90148-end- 
                            RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                        END IF
                    ELSE
                       #-MOD-C90148-mark-
                       #CALL p001_fun_amt(l_aag04,l_fun_dr,l_fun_cr,
                       #                  l_axee.axee11,l_axz.axz06,
                       #                 #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012
                       #                  l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012
                       #-MOD-C90148-mark-
                       #-MOD-C90148-add-
                        CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_axee.axee12,l_axz.axz07,
                                         x_aaa03,l_aeii.aeii09,l_aeii.aeii10,g_axa05)
                       #-MOD-C90148-end-
                        RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                    END IF
       
                    #--平均匯率---
                    IF l_axee.axee12='3' THEN
                      #-MOD-C90148-add-
                       IF g_axa05 = '1' THEN 
                          CALL p001_aeii_avg(l_axe.axe11,l_axe.axe12,l_aeii.aeii04,l_axz.axz06,l_axz.axz07,tm.yy,tm.em,i)   
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                       ELSE
                       #-MOD-C90148-mark- 
                       #CALL p001_fun_amt(l_aag04,l_fun_dr,l_fun_cr,
                       #                  l_axee.axee11,l_axz.axz06,
                       #                 #l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10)          #FUN-BA0012
                       #                  l_axz.axz07,l_aeii.aeii09,l_aeii.aeii10,g_axa05)  #FUN-BA0012
                       #-MOD-C90148-mark-
                      #-MOD-C90148-add-
                          CALL p001_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                            l_axee.axee12,l_axz.axz07,
                                            x_aaa03,l_aeii.aeii09,l_aeii.aeii10,g_axa05)
                      #-MOD-C90148-end- 
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                       END If   #MOD-C90148
                    END IF
                    #-------FUN-A60038 end-----------------------------------

                    LET l_chg_aeii11=l_fun_dr     #功能幣別借方金額
                    LET l_chg_aeii12=l_fun_cr     #功能幣別貸方金額
                    LET l_chg_aeii11_1=l_acc_dr   #記賬幣別借方金額
                    LET l_chg_aeii12_1=l_acc_cr   #記賬幣別貸方金額
                    #---FUN-A60038 end----------

                    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz.axz06
                    IF cl_null(l_cut) THEN LET l_cut=0 END IF	　
                    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
                    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF	　

                    LET l_chg_aeii11=cl_digcut(l_chg_aeii11,l_cut)	　
                    LET l_chg_aeii12=cl_digcut(l_chg_aeii12,l_cut)	　
                    LET l_chg_aeii11_1=cl_digcut(l_chg_aeii11_1,l_cut1)
                    LET l_chg_aeii12_1=cl_digcut(l_chg_aeii12_1,l_cut1)

                    IF cl_null(l_chg_aeii11_1) THEN LET l_chg_aeii11_1=0 END IF
                    IF cl_null(l_chg_aeii12_1) THEN LET l_chg_aeii12_1=0 END IF

                   #-MOD-C90148-add-
                    IF g_axa05 = '1' THEN
                       IF l_axe.axe11 = '3' THEN
                          IF l_axz.axz06 != l_axz.axz07 THEN
                             LET l_aei16 = (l_chg_aeii11-l_chg_aeii12)/(l_aeii.aeii11-l_aeii.aeii12)
                          ELSE
                             LET l_aei16 = l_rate
                          END IF
                       ELSE
                          LET l_aei16 = l_rate
                       END IF

                       IF l_axe.axe12 = '3' THEN  
                          IF l_axz.axz07 != x_aaa03 THEN
                             LET l_aei17 = (l_chg_aeii11_1-l_chg_aeii12_1)/(l_chg_aeii11-l_chg_aeii12)
                          ELSE
                             LET l_aei17 = l_rate1
                          END IF
                       ELSE
                          LET l_aei17 = l_rate1
                       END IF
                    ELSE
                   #-MOD-C90148-end-
                       LET l_aei16 = l_rate
                       LET l_aei17 = l_rate1
                    END IF  #MOD-C90148
#FUN-A10015 --Begin
                   #FUN-BA0111--
                    CALL p001_get_aei23(
                         l_aeii.aeii00,l_aeii.aeii01,l_aeii.aeii02,l_aeii.aeii021,l_aeii.aeii03
                        ,l_aeii.aeii031,l_aeii.aeii04,l_aeii.aeii05,l_aeii.aeii06,l_aeii.aeii07
                        ,l_aeii.aeii08,l_aeii.aeii09,l_aeii.aeii10,l_aeii.aeii18,l_aeii.aeii19
                        ,l_aeii.aeii20,l_aeii.aeii21,l_aeii.aeii22)
                    RETURNING l_aei23,l_aei24
                   #FUN-BA0111--
                    INSERT INTO aei_file
                     (aei00,aei01,aei02,aei021,aei03,aei031,
                      aei04,aei05,aei06,aei07,aei08,aei09,
                      aei10,aei11,aei12,aei13,aei14,aei15,
                      aei16,aei17,aei18,aeilegal
                     ,aei19,aei20,aei21,aei22,aei23,aei24)                 #FUN-BA0111 add
                    VALUES
                     (l_aeii.aeii00,l_aeii.aeii01,l_aeii.aeii02,
                      l_aeii.aeii021,l_aeii.aeii03,l_aeii.aeii031,
                      l_aeii.aeii04,l_aeii.aeii05,l_aeii.aeii06,
                      l_aeii.aeii07,l_aeii.aeii08,l_aeii.aeii09,
                     #l_aeii.aeii10,l_aeii.aeii11,l_aeii.aeii12,          #MOD-C90148 mark
                      l_aeii.aeii10,l_chg_aeii11_1,l_chg_aeii12_1,        #MOD-C90148
                      l_aeii.aeii13,l_aeii.aeii14,l_aeii.aeii15,
                     #l_aeii.aeii16,l_aeii.aeii17,l_aeii.aeii18,g_azw02   #MOD-C90148 mark
                      l_aei16,l_aei17,l_axz06,g_azw02                     #MOD-C90148 
                     ,l_aeii.aeii19,l_aeii.aeii20,l_aeii.aeii21,l_aeii.aeii22,l_aei23,l_aei24)   #FUN-BA0111 add
#FUN-A10015 --End
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
#FUN-A10015 --Begin
                       UPDATE aei_file SET aei11=aei11+l_chg_aeii11_1,
                                           aei12=aei12+l_chg_aeii12_1,
                                           aei13=aei13+l_aeii.aeii13,
                                           aei14=aei14+l_aeii.aeii14,
                                           aei16=l_aei16,
                                           aei17=l_aei17
                        WHERE aei00 = l_aeii.aeii00
                          AND aei01 = l_aeii.aeii01
                          AND aei02 = l_aeii.aeii02
                          AND aei021= l_aeii.aeii021
                          AND aei03 = l_aeii.aeii03
                          AND aei031= l_aeii.aeii031
                          AND aei04 = l_aeii.aeii04
                          AND aei05 = l_aeii.aeii05
                          AND aei06 = l_aeii.aeii06
                          AND aei07 = l_aeii.aeii07
                          AND aei08 = l_aeii.aeii08
                          AND aei09 = l_aeii.aeii09
                          AND aei10 = l_aeii.aeii10
                         #AND aei18 = l_aeii.aeii18      #MOD-C90148 mark
                          AND aei18 = l_axz06            #MOD-C90148
                          AND aei19 = l_aeii.aeii19      #FUN-BA0111 add
                          AND aei20 = l_aeii.aeii20      #FUN-BA0111 add
                          AND aei21 = l_aeii.aeii21      #FUN-BA0111 add
                          AND aei22 = l_aeii.aeii22      #FUN-BA0111 add
#FUN-A10015 --End
                       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                          CALL s_errmsg('aei01',l_aeii.aeii01,'upd_aei',SQLCA.sqlcode,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF
                    ELSE
                       IF SQLCA.sqlcode THEN
                          LET g_showmsg=l_aeii.aeii01,"/",l_aeii.aeii02,l_aeii.aeii03,"/",l_aeii.aeii04
                          CALL s_errmsg('aei01,aei02,aei03,aei04',g_showmsg,'ins_aei',status,1)
                          LET g_success = 'N'
                          CONTINUE FOREACH
                       END IF 
                    END IF
            END FOREACH    #FOR aeii_file foreach
        END IF         #l_n<>0
    END FOR
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
  
    IF g_success="N" THEN
       RETURN
    END IF 
 
# --FUN-A90036 先產生換匯差額分錄,並寫入p001_adj_tmp()  換匯分錄寫入
    #-->step 4
    CALL p001_adj()
# --FUN-A90036 end-----
   #FUN-C50084--
   #建立TempTable計算金額總額
   DROP TABLE p001_aaz129_tmp
   CREATE TEMP TABLE p001_aaz129_tmp(
      yy       LIKE type_file.num5,
      mm       LIKE type_file.num5,
      axj07    LIKE axj_file.axj07)
   LET l_sql = "INSERT INTO p001_aaz129_tmp VALUES(?,?,?)"
   PREPARE insert_prep_aaz129 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep_aaz129:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #FUN-C50084--
    #-->step 3 產生調整分錄
    #-->ref.axf_file insert into axi_file,axj_file
    CALL p001_modi()

    CALL p001_modi_adj()  #FUN-A60038

END FUNCTION
#--FUN-A90026 end-----

FUNCTION p001_del() 
#DEFINE l_aac01        LIKE aac_file.aac01        #MOD-BC0156 #MOD-C20161 mark
 DEFINE l_aac01        LIKE type_file.chr6        #MOD-C20161 add

  LET g_em = tm.em   #FUN-770069 add
  #-->delete aei_file(合并前科目異動碼(固定)衝賬余額檔) 
  DELETE FROM aei_file
        WHERE aei00=g_aaz641 
          AND aei01=tm.axa01
          AND aei02=tm.axa02
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
          AND axg01=tm.axa01 AND axg02=tm.axa02 
          AND axg06=tm.yy AND axg07 = tm.em #FUN-970046 mod
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axg_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del axg_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

  #-->delete axk_file(科目異動碼沖帳餘額檔)
  DELETE FROM axk_file 
        WHERE axk00=g_aaz641   #FUN-5A0020   #FUN-920067 mod
          AND axk01=tm.axa01 AND axk02=tm.axa02 
          AND axk08=tm.yy AND axk09 = tm.em   #FUN-970046
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axk_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del axk_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

  LET l_aac01 = tm.gl,'%'   #MOD-BC0156
  #-->delete axj_file(調整與銷除分錄底稿單身檔)
  DELETE FROM axj_file 
        WHERE axj00=g_aaz641   #FUN-5A0020   #FUN-920067 mod
          AND axj01 IN (SELECT axi01 FROM axi_file 
                         WHERE axi00=g_aaz641 AND axi05=tm.axa01   #FUN-5A0020  #FUN-920067 mod
                           AND axi06=tm.axa02 AND axi07=tm.axa03
                           AND axi03=tm.yy AND axi04 = tm.em   #FUN-970046 mod
                           AND (axi21=tm.ver OR axi21=g_em)    #MOD-930210 add
                           AND axi01 LIKE l_aac01              #MOD-BC0156
                           AND axi08='2')
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axj_file",g_aaz641,"",SQLCA.sqlcode,"","del axj_file",1)  #No.FUN-660123    #FUN-920067 mod
     LET g_success = 'N' 
     RETURN 
  END IF 

  #-->delete axi_file
  #-->delete axi_file(調整與銷除分錄底稿單頭檔)
  DELETE FROM axi_file 
        WHERE axi00=g_aaz641   #FUN-5A0020   #FUN-920067  mod
          AND axi05=tm.axa01 AND axi06=tm.axa02 AND axi07=tm.axa03
          AND axi03=tm.yy AND axi04 = tm.em   #FUN-970046
          AND (axi21=tm.ver OR axi21=g_em)    #MOD-930210 add
          AND axi01 LIKE l_aac01              #MOD-BC0156
          AND axi08='2'
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axi_file",tm.axa03,"",SQLCA.sqlcode,"","del axi_file",1)  #No.FUN-660123 
     LET g_success = 'N' 
     RETURN 
  END IF 
END FUNCTION
   
FUNCTION p001_modi()   #產生調整分錄
DEFINE l_axk09_o    LIKE axk_file.axk09,             #期別
       l_axg07_m    LIKE axg_file.axg07,             #FUN-960003 add
       l_axk09_o1   LIKE axk_file.axk09,             #期別  #FUN-930144
       l_axg07_m1   LIKE axg_file.axg07,             #FUN-960003 add
       l_axk07_o    LIKE axk_file.axk07,             #異動碼值
       l_axk07_o1   LIKE axk_file.axk07,             #異動碼值  #FUN-930144 
       l_axg07_o    LIKE axg_file.axg07,             #期別   #FUN-760053 add
       l_cnt        LIKE type_file.num5,             #FUN-760053 add
       l_sql,l_sql1 STRING,                          #FUN-5A0118        
       i,g_no       LIKE type_file.num5              #No.FUN-680098   SMALLINT  
DEFINE l_axz08      LIKE axz_file.axz08              #FUN-920067 add
DEFINE l_axf09_axz05      LIKE axz_file.axz05              #FUN-920067 add  
DEFINE l_axf10_axz05      LIKE axz_file.axz05              #FUN-920067
DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10  #FUN-920167
DEFINE l_i                LIKE type_file.num5  #FUN-920167 
DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
DEFINE l_axf01            STRING  #FUN-950111
DEFINE l_axf02            STRING  #FUN-950111
DEFINE l_plant_gl    LIKE type_file.chr21      #MOD-C90078 add
DEFINE l_axf00       LIKE axf_file.axf00       #MOD-C90078 add
DEFINE l_axf12       LIKE axf_file.axf12       #MOD-C90078 add

   #建立TempTable以便處理科目為MISC的資料
   DROP TABLE p001_tmp
   CREATE TEMP TABLE p001_tmp(
      axg06   LIKE axg_file.axg06,
      axg07   LIKE axg_file.axg07,
      axg05   LIKE axg_file.axg05,
      axg02   LIKE axg_file.axg02,
      axg04   LIKE axg_file.axg04,
      axg08   LIKE axg_file.axg08,
      axg12   LIKE axg_file.axg12,  #FUN-A30079
      affil   LIKE axj_file.axj05,
      dc      LIKE axj_file.axj06,
      flag_r  LIKE type_file.chr1)   

   DELETE FROM p001_tmp
   #LET l_sql = "INSERT INTO p001_tmp VALUES(?,?,?,?,?, ?,?,?,?)"
   LET l_sql = "INSERT INTO p001_tmp VALUES(?,?,?,?,?,?,?,?,?,?)" #FUN-A30079
   PREPARE insert_prep FROM l_sql
   #IF STATUS THEN
   IF SQLCA.SQLCODE THEN   #FUN-A80130
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-BA0006
      EXIT PROGRAM
   END IF

#---FUN-A60038 start---
   #LET l_sql = "INSERT INTO p001_axj_tmp VALUES(?,?,?)"    #FUN-D20048 mark
   LET l_sql = "INSERT INTO p001_axj_tmp VALUES(?,?,?,?)"   #FUN-D20048 add
   PREPARE insert_axj_prep FROM l_sql
   #IF STATUS THEN
   IF SQLCA.SQLCODE THEN  #FUN-A80130
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-BA0006
      EXIT PROGRAM
   END IF
#--FUN-A60038 end------

   LET l_sql1=
    "SELECT axa01,axa02,axa03 FROM axa_file ",           #MOD-A60056
    " WHERE axa01='",tm.axa01,"'",
    " UNION ",
    "SELECT axb01,axb04,axb05 ",                         #MOD-A60056
    "  FROM axb_file,axa_file ",
    " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
    "   AND axa01='",tm.axa01,"'"

   PREPARE p001_axa_p1 FROM l_sql1
	   DECLARE p001_axa_c1 CURSOR FOR p001_axa_p1

   LET g_no = 1
   FOREACH p001_axa_c1 INTO g_axa[g_no].*
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
      END IF  
      IF SQLCA.SQLCODE THEN
         LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03
         CALL s_errmsg('axa01,axa02,axa03',g_showmsg,'for_axa_c1:',STATUS,1)   #NO.FUN-710023
         LET g_success = 'N'
         CONTINUE FOREACH                               #NO.FUN-710023 
      END IF
      LET g_no=g_no+1
   END FOREACH
   IF g_totsuccess="N" THEN LET g_success="N" END IF     #NO.FUN-710023 add
   LET g_no=g_no-1

   INITIALIZE g_axi.* TO NULL
   INITIALIZE g_axj.* TO NULL

   FOR i =1 TO g_no
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
     END IF 

#FUN-960003 ---配合agli003己開放非股本資料也能設為MISC對沖
#1.先抓來源會科，如果是MISC時，則來源為axs_file，
#接著處理對沖科目，如果亦為MISC則來源為axt_file
#其它狀況可能會一對一 ，一對多，多對一，多對多，所以在程式上要配合
#如果一對多時，axf<->axt, 一對一 axf<->axf, 多對一 axs<->axf, 多對多 axs<->axt
#2.資料來源又可分為axg_file,axk_file,依axf15,axf17決定

     DECLARE p001_axf_cs1 CURSOR FOR
        SELECT *
          FROM axf_file 
          WHERE axf13=g_axa[i].axa01   #族群 #FUN-930117        #FUN-A30079 mod
           AND axf09=g_axa[i].axa02   #來源公司               
           AND axfacti='Y'            #有效的資料
         ORDER BY axf12,axf10,axf01,axf02,axf03,axf04
     FOREACH p001_axf_cs1 INTO g_axf.*
     IF g_axf.axf16 <> tm.axa02 THEN CONTINUE FOREACH END IF  #FUN-A30079 合併主體= 目前輸入的上層公司才進行沖銷分錄
    #---------------------MOD-C90078--------------------------(S)
     CALL s_aaz641_dbs(g_axf.axf13,g_axf.axf09) RETURNING l_plant_gl
     CALL s_get_aaz641(l_plant_gl) RETURNING l_axf00
     CALL s_aaz641_dbs(g_axf.axf13,g_axf.axf10) RETURNING l_plant_gl
     CALL s_get_aaz641(l_plant_gl) RETURNING l_axf12
     IF (g_axf.axf00 <> l_axf00) OR (g_axf.axf12 <> l_axf12) THEN
        CONTINUE FOREACH
     END IF
    #---------------------MOD-C90078--------------------------(E)

     LET l_axf01 = g_axf.axf01   #FUN-960003 
     LET l_axf02 = g_axf.axf02   #FUN-960003
     LET l_axf01 = l_axf01.substring(1,4)  #FUN-960003 
     LET l_axf02 = l_axf02.substring(1,4)  #FUN-960003
    
     #--FUN-920067 start-- 抓出下層公司axf10在agli009中設定的關係人異動碼值--
     SELECT axz08 INTO g_axz08     #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf09    #FUN-A90026

     CALL p001_modi_axf_misc(l_axf01,l_axf02,g_axf.axf15,g_axf.axf17,i)    #FUN-A80137
     
     END FOREACH
   END FOR

   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
END FUNCTION
   
FUNCTION p001_ins_axi()
DEFINE li_result  LIKE type_file.num5     #No.FUN-560060        #No.FUN-680098 SMALLINT

    INITIALIZE g_axi.* TO NULL

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
       RETURN 
    END IF
    LET g_axi.axi00  = g_aaz641      #帳別      #FUN-5A0020   #FUN-920067 mod
    LET g_axi.axi01  = tm.gl         #傳票編號
    LET g_axi.axi02  = g_edate       #單據日期
    LET g_axi.axi03  = g_yy          #調整年度  #FUN-770069 mod
    LET g_axi.axi04  = g_mm          #調整月份  #FUN-770069 mod
    LET g_axi.axi05  = tm.axa01      #族群編號
    LET g_axi.axi06  = tm.axa02      #上層公司編號
    LET g_axi.axi07  = tm.axa03      #上層帳別
    LET g_axi.axi08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
    LET g_axi.axi09  = 'N'           #換匯差額調整否    #MOD-A60080 
    LET g_axi.axiconf= 'Y'           #確認碼
    LET g_axi.axiuser= g_user        #資料所有者
    LET g_axi.axigrup= g_grup        #資料所有群
    LET g_axi.axidate= g_today       #最近修改日
    LET g_axi.axi21  = tm.ver        #版本      #FUN-750078 add
    LET g_axi.axi081 = '1'           #內部交易 (1.內部交易 2.未實現損益  3.攤銷)  #FUN-A90026
    LET g_axi.axilegal = g_legal     #FUN-980003 add legal

    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
                          #"axi_file","axi01",g_dbs,"2",g_aaz641)   #FUN-5A0020      #FUN-920067 mod
                          "axi_file","axi01",g_plant,"2",g_aaz641) #FUN-5A0020      #FUN-920067 mod #FUN-980094 
    RETURNING li_result,g_axi.axi01
#MOD-B80164 -- begin --
    IF (NOT li_result) THEN
       CALL s_errmsg('axi_file','axi01',g_axi.axi01,'mfg-059',1)
       LET g_success = 'N' 
    END IF
#MOD-B80164 -- end --
    DISPLAY g_axi.axi01
    IF g_success='N' THEN 
        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)         #NO.FUN-710023 
        RETURN 
    END IF

    LET g_axi.axioriu = g_user      #No.FUN-980030 10/01/04
    LET g_axi.axiorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO axi_file VALUES(g_axi.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
       CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
       RETURN 
    END IF

END FUNCTION

#FUNCTION p001_ins_axj1()    #FUN-C50084 mark
FUNCTION p001_ins_axj1(i)    #FUN-C50084
DEFINE l_axz06_axf16   LIKE axz_file.axz06   #FUN-A30079
DEFINE l_aag04         LIKE aag_file.aag04   #FUN-A30079
DEFINE l_rate          LIKE axp_file.axp05   #FUN-A30079   #各公司與合併主體公司匯率
DEFINE l_cut           LIKE type_file.num5   #FUN-A30079
DEFINE i               LIKE type_file.num5   #FUN-C50084

   INITIALIZE g_axj.* TO NULL
 
   LET g_axj.axj00=g_aaz641        #帳別   #FUN-920067 mod
   LET g_axj.axj01=g_axi.axi01     #傳票編號   

   SELECT MAX(axj02)+1 INTO g_axj.axj02 
     FROM axj_file 
    WHERE axj01=g_axj.axj01
      AND axj00=g_axj.axj00  #FUN-760053
   IF g_axj.axj02 IS NULL THEN LET g_axj.axj02 = 1 END IF   #項次
   LET g_axj.axj03=g_axg.axg05                              #科目
   LET g_axj.axj04=' '                                      #摘要
   LET g_axj.axj05=g_affil                                  #關係人   #FUN-760053 mod
   IF g_axg.axg08 < 0 THEN 
      IF g_dc='1' THEN LET g_dc='2' ELSE LET g_dc='1' END IF
   END IF
   LET g_axj.axj06=g_dc                                     #借貸別
   LET l_rate = 1   #FUN-A60038
  #FUN-C50084-- 
  #如果科目為少數股權淨利(aaz129)時，需依持股天數依比率(axbb_file)計算金額
   IF (g_axg.axg05 = g_aaz129) THEN
      DELETE FROM p001_aaz129_tmp    #TQC-D30026 add
      CALL p001_get_aaz129(i) RETURNING g_axj.axj07
      #TQC-D30026 start--
      IF g_axj.axj07 > 0 THEN
         LET g_axj.axj06 = '1'
   ELSE
         LET g_axj.axj06 = '2'
         LET g_axj.axj07 = g_axj.axj07 * -1
      END IF
      #TQC-D30026 end--
   ELSE
  #FUN-C50084--
   IF g_axf.axf03='N' OR (g_axf.axf03='Y' AND g_rate=0) THEN
      LET g_axj.axj07=g_axg.axg08                           #金額
   ELSE
      IF g_flag_r='Y' THEN
         LET g_axj.axj07=g_axg.axg08*(1-g_rate)          #金額
         #-FUN-A30079 start--
         IF g_axj.axj07 > 0 THEN
             LET g_axj.axj06 = '1'
         ELSE
             LET g_axj.axj06 = '2'
         END IF
         #--FUN-A30079 end---
      ELSE
         LET g_axj.axj07=g_axg.axg08                        #金額
      END IF
   END IF
   END IF          #FUN-C50084--
   #------------FUN-A30079 start------------------
   #原本都是以tm.axa02為上層公司寫入對沖分錄
   #改以"合併主體(axf16)"寫入對沖分錄上層公司(axi06),
   #對沖金額(axj07)的值原本是以上層公司的幣別計算
   #改以合併主體幣別
   #(axg08,axg09為捲算過後的上層公司記帳幣金額不可直接拿來使用)
   #當要產生對沖分錄時，tm.axa02取axf_file的值(axf16 = tm.axa02)再進行對沖產生
   #並且要把對沖金額換算為合併主體公司記帳幣，才能算出差額科目金額
   #一一將對沖的科目寫入分錄之後(要換算成合併主體幣別)，再計算差額額目(同一組分錄借-貸)
 
   SELECT axz06 INTO l_axz06_axf16 
     FROM axz_file
   #WHERE axz01 = g_axf.axf16   #合併主體幣別  #MOD-C30498  MARK
    WHERE axz01 = g_axi.axi06   #MOD-C30498
  
   #將來源/目的公司的幣別和合併主體幣別做比較
   #幣別相同者不用換，不相同時將幣別換成合併主體幣別and金額
   LET l_rate = 1  #FUN-A60038

   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
   IF cl_null(l_cut) THEN LET l_cut = 0 END IF
   LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)
   #------------FUN-A30079 end ------------------
   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
   LET g_axj.axjlegal=g_legal   
   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
   LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10         #FUN-D20048 add
   LET g_axj.axj13 =  g_axf.axf19                         #FUN-D20048 add
   DISPLAY "1)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
   IF g_axj.axj07 != 0 THEN   #MOD-890130 add
      INSERT INTO axj_file VALUES (g_axj.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01                                  #NO.FUN-710023      
         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)          #NO.FUN-710023
         LET g_success = 'N' 
         RETURN 
      END IF
      #----FUN-A60038 start--
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_aaz641
         AND aag01 = g_axj.axj03
      IF l_aag04 = '2' THEN  #FUN-A60060
          #EXECUTE insert_axj_prep USING g_axj.axj03,g_axj.axj06,g_axj.axj07              #FUN-D20048 mark
          EXECUTE insert_axj_prep USING g_axj.axj13,g_axj.axj03,g_axj.axj06,g_axj.axj07   #FUN-D20048 add
      END IF 
      #---FUN-A60038 end-------
   END IF                     #MOD-890130 add

END FUNCTION

FUNCTION p001_ins_axj2()   #差異科目
DEFINE l_sumd  LIKE axj_file.axj07,
       l_sumc  LIKE axj_file.axj07,
       l_sumdc LIKE axj_file.axj07
DEFINE l_aag04 LIKE aag_file.aag04  #FUN-A60060

   INITIALIZE g_axj.* TO NULL

   SELECT SUM(axj07) INTO l_sumd FROM axj_file
    WHERE axj00=g_aaz641 AND axj01=g_axi.axi01 AND axj06='1'   #借方合計   #FUN-920067
   IF cl_null(l_sumd) THEN LET l_sumd = 0 END IF   #FUN-960096
   SELECT SUM(axj07) INTO l_sumc FROM axj_file
    WHERE axj00=g_aaz641 AND axj01=g_axi.axi01 AND axj06='2'   #貸方合計  #FUN-920067
   IF cl_null(l_sumc) THEN LET l_sumc = 0 END IF   #FUN-960003 
   LET l_sumdc=l_sumd-l_sumc   
   IF l_sumdc = 0 THEN RETURN END IF

   LET g_axj.axj00=g_aaz641     #帳別   #FUN-920067 mod
   LET g_axj.axj01=g_axi.axi01     #傳票編號   

   SELECT MAX(axj02)+1 INTO g_axj.axj02 
     FROM axj_file
    WHERE axj01=g_axj.axj01
      AND axj00=g_axj.axj00  #FUN-760053
   IF cl_null(g_axj.axj02)  THEN LET g_axj.axj02 = 1 END IF
   #LET g_axj.axj03=g_axf.axf04     #科目   #FUN-750078 modify    #FUN-D20048 mark
   #LET g_axj.axj04=' '             #摘要   #FUN-D20048 mark
   #FUN-D20048 add begin---
   IF l_sumd < l_sumc THEN
      LET g_axj.axj03=g_axf.axf04
   END IF
   IF l_sumd > l_sumc THEN
      LET g_axj.axj03=g_axf.axf18
   END IF
   LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10
   #FUN-D20048 add end------
   LET g_axj.axj05=' '             #關係人
   IF l_sumdc >0 THEN              #借貸別
      LET g_axj.axj06='2' 
   ELSE 
      LET g_axj.axj06='1' 
   END IF
   LET g_axj.axj07=l_sumdc         #金額
   IF g_axj.axj07<0 THEN LET g_axj.axj07=g_axj.axj07*-1 END IF
   IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
   LET g_axj.axjlegal=g_legal     #FUN-980003 add
   LET g_axj.axj13 =  g_axf.axf19                         #FUN-D20048 add
   DISPLAY "2)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
   IF g_axj.axj07 != 0 THEN   #MOD-890130 add
      INSERT INTO axj_file VALUES (g_axj.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_axi.axi07,"/",g_axi.axi01                                  #NO.FUN-710023      
         CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)          #NO.FUN-710023
         LET g_success = 'N' 
         RETURN 
      END IF
      #----FUN-A60038 start--
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_aaz641
         AND aag01 = g_axj.axj03
      IF l_aag04 = '2' THEN
          #EXECUTE insert_axj_prep USING g_axj.axj03,                                     #FUN-D20048 mark
          #                              g_axj.axj06,g_axj.axj07                          #FUN-D20048 mark
          EXECUTE insert_axj_prep USING g_axj.axj13,g_axj.axj03,g_axj.axj06,g_axj.axj07   #FUN-D20048 add
      END IF 
      #---FUN-A60038 end-------
   END IF                     #MOD-890130 add

END FUNCTION
 
#----FUN-A60038 start--
FUNCTION p001_modi_adj()
DEFINE l_axj13   LIKE axj_file.axj13    #FUN-D20048 add
DEFINE l_axj03   LIKE axj_file.axj03
DEFINE l_axj06   LIKE axj_file.axj06
DEFINE l_axj07   LIKE axj_file.axj07
DEFINE l_aag06   LIKE aag_file.aag06
DEFINE li_result LIKE type_file.num5     
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_cnt1    LIKE type_file.num5    #FUN-C90097
DEFINE l_tat04   LIKE tat_file.tat04    #FUN-C90097
DEFINE l_tat05   LIKE tat_file.tat05    #FUN-C90097
DEFINE l_sql     STRING                 #FUN-C90097

   INITIALIZE g_axi.* TO NULL
   INITIALIZE g_axj.* TO NULL

   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
   RETURNING g_bdate,g_edate
   LET g_yy=tm.yy 
   LET g_mm=tm.em 

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
       RETURN 
    END IF
    LET g_axi.axi00  = g_aaz641      #帳別      
    LET g_axi.axi01  = tm.gl         #傳票編號
    LET g_axi.axi02  = g_edate       #單據日期
    LET g_axi.axi03  = g_yy          #調整年度 
    LET g_axi.axi04  = g_mm          #調整月份 
    LET g_axi.axi05  = tm.axa01      #族群編號
    LET g_axi.axi06  = tm.axa02      #上層公司編號
    LET g_axi.axi07  = tm.axa03      #上層帳別
    LET g_axi.axi08  = '2'           #來源碼
    LET g_axi.axi09  = 'N'           #換匯差額調整否
    LET g_axi.axiconf= 'Y'           #確認碼
    LET g_axi.axiuser= g_user        #資料所有者
    LET g_axi.axigrup= g_grup        #資料所有群
    LET g_axi.axidate= g_today       #最近修改日
    LET g_axi.axi21  = tm.ver        #版本   
    LET g_axi.axi081 = '1'           #FUN-A90026
    LET g_axi.axilegal = g_legal 
    LET g_axi.axioriu = g_user    
    LET g_axi.axiorig = g_grup  
    LET g_axj.axjlegal=g_legal    #FUN-A80125

    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
                         #"axi_file","axi01",g_dbs,"2",g_aaz641)    #MOD-BC0072 mark
                          "axi_file","axi01",g_plant,"2",g_aaz641)  #MOD-BC0072 add
    RETURNING li_result,g_axi.axi01
#MOD-B80164 -- begin --
    IF (NOT li_result) THEN
       CALL s_errmsg('axi_file','axi01',g_axi.axi01,'mfg-059',1)
       LET g_success = 'N'
    END IF
#MOD-B80164 -- end --
    DISPLAY g_axi.axi01
    IF g_success='N' THEN 
        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)         #NO.FUN-710023 
        RETURN 
    END IF
   #FUN-C90097--(B)--
    LET l_sql = "SELECT tat04,tat05 FROM tat_file"
              #," WHERE tat01 = '",tm.axa03,"' AND tat02 = '",tm.yy,"'"  #TQC-D40045 mark
               ," WHERE tat01 = '",g_aaz641,"' AND tat02 = '",tm.yy,"'"  #TQC-D40045
               ,"   AND tat03 = ?" 
    PREPARE p001_axj_p9 FROM l_sql
    DECLARE p001_axj_cs9 CURSOR WITH HOLD FOR p001_axj_p9
   #FUN-C90097--(E)--
   #--取出此上層公司的調整分錄非換匯者 ----
     DECLARE p001_axj_cs CURSOR FOR
        SELECT axj13,axj03,axj06,axj07                              #FUN-D20048 add axj13
          FROM p001_axj_tmp
     LET l_cnt = 0
     FOREACH p001_axj_cs INTO l_axj13,l_axj03,l_axj06,l_axj07       #FUN-D20048 add axj13
        IF SQLCA.sqlcode THEN 
           LET g_showmsg= l_axj03,"/",l_axj06,"/"
           CALL s_errmsg('axj03,axj06',g_showmsg,'p001_axj_cs',SQLCA.sqlcode,1) 
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF
        LET l_cnt = l_cnt + 1
       #FUN-C90097--(B)--
        LET l_cnt1 = 0
        SELECT COUNT(*) INTO l_cnt1 FROM tat_file
        #WHERE tat01 = tm.axa03 AND tat02 = tm.yy   #TQC-D40045 mark
         WHERE tat01 = g_aaz641 AND tat02 = tm.yy   #TQC-D40045
           AND tat03 = l_axj03
        IF l_cnt1 > 0 THEN
           LET l_tat04 = ""
           LET l_tat05 = ""
           OPEN p001_axj_cs9 USING l_axj03
           FETCH p001_axj_cs9 INTO l_tat04,l_tat05
           IF cl_null(l_tat04) THEN LET l_tat04 = "" END IF
           IF cl_null(l_tat05) THEN LET l_tat05 = "" END IF
        END IF
       #FUN-C90097--(E)--
##. 取沖銷調整分錄中換匯差額否[axi09<>'Y']者的分錄
#1. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
#2. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
#           C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#3. 當沖銷銷調整分錄中有借方科目[axj06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
#4. 當沖銷銷調整分錄中有貸方科目[axj06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   D : 本期損益IS [aaz113]==>僅配合借貸平衡暫存科目
#          C : 本期損益BS [aaz114] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益

      LET g_axj.axj00=g_aaz641                                                  
      LET g_axj.axj01=g_axi.axi01                                               

      CASE 
          WHEN l_axj06 = '1'
               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
              #FUN-C90097--(B)--
               IF l_cnt1 > 0 THEN
                  LET g_axj.axj03 = l_tat04
               ELSE
              #FUN-C90097--(E)--
                  LET g_axj.axj03=g_aaz114
               END IF         #FUN-C90097
               #LET g_axj.axj04=' '                      #摘要        #FUN-D20048 mark                     
               LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10         #FUN-D20048 add
               LET g_axj.axj06='1'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               LET g_axj.axj13 = l_axj13                              #FUN-D20048 add
               DISPLAY "3)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    

               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
              #FUN-C90097--(B)--
               IF l_cnt1 > 0 THEN
                  LET g_axj.axj03 = l_tat05
               ELSE
              #FUN-C90097--(E)--
                  LET g_axj.axj03=g_aaz113
               END IF         #FUN-C90097
               #LET g_axj.axj04=' '                      #摘要        #FUN-D20048 mark                 
               LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10         #FUN-D20048 add
               LET g_axj.axj06='2'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               LET g_axj.axj13 = l_axj13                              #FUN-D20048 add
               DISPLAY "4)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    
          WHEN l_axj06 = '2'
               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
              #FUN-C90097--(B)--
               IF l_cnt1 > 0 THEN
                  LET g_axj.axj03 = l_tat05
               ELSE
              #FUN-C90097--(E)--
                  LET g_axj.axj03=g_aaz113
               END IF         #FUN-C90097               
               #LET g_axj.axj04=' '                      #摘要        #FUN-D20048 mark                      
               LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10         #FUN-D20048 add
               LET g_axj.axj06='1'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               LET g_axj.axj13 = l_axj13                              #FUN-D20048 add
               DISPLAY "5)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    

               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
                WHERE axj01=g_axj.axj01                                                  
                  AND axj00=g_axj.axj00                                                  
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
              #FUN-C90097--(B)--
               IF l_cnt1 > 0 THEN
                  LET g_axj.axj03 = l_tat04
               ELSE
              #FUN-C90097--(E)--
                  LET g_axj.axj03=g_aaz114
               END IF         #FUN-C90097
               #LET g_axj.axj04=' '                      #摘要        #FUN-D20048 add                  
               LET g_axj.axj04 =  g_axf.axf09,':',g_axf.axf10         #FUN-D20048 add
               LET g_axj.axj06='2'                      #借貸別                       
               LET g_axj.axj07= l_axj07
               LET g_axj.axj13 = l_axj13                              #FUN-D20048 add
               DISPLAY "6)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
               IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
               IF g_axj.axj07 != 0 THEN                                                  
                  INSERT INTO axj_file VALUES (g_axj.*)                                  
               END IF                                                                    
      END CASE
   END FOREACH

   #--先寫完單身再寫單頭，避免單身無值
   IF l_cnt > 0 THEN
       INSERT INTO axi_file VALUES(g_axi.*)
       IF SQLCA.sqlcode THEN 
          LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
          CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
          RETURN 
       END IF
       IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF   
   END IF
END FUNCTION 
#-------------FUN-A60038 end---------------------

FUNCTION p001_adj()
DEFINE l_aaz86        LIKE aaz_file.aaz86   #FUN-5A0118  #外幣換算損益
DEFINE l_aaz87        LIKE aaz_file.aaz87   #FUN-5A0118  #換算調整數
DEFINE l_flag         LIKE type_file.chr1   #FUN-770069 add 10/19  #判斷是不是第一次進入迴圈
DEFINE l_axz08_axf10  LIKE axz_file.axz08   #FUN-960096
DEFINE l_axa09        LIKE axa_file.axa09   #FUN-980095
DEFINE l_aag04        LIKE aag_file.aag04   #FUN-980095
DEFINE l_amt_aaz113   LIKE axg_file.axg08   #FUN-990020                             
DEFINE l_amt_aaz114   LIKE axg_file.axg08   #FUN-990020                             
DEFINE l_aaz113       LIKE aaz_file.aaz113  #FUN-990020                             
DEFINE l_aaz114       LIKE aaz_file.aaz114  #FUN-990020                             
DEFINE l_amt_cnt      LIKE axg_file.axg08   #FUN-990020  
DEFINE l_amt_tot      LIKE axg_file.axg08   #FUN-9B0017
DEFINE l_amt          LIKE axg_file.axg08   #FUN-9B0017
DEFINE l_axg19        LIKE axg_file.axg19   #FUN-A30079  
DEFINE l_axz06_axf16  LIKE axf_file.axf16   #FUN-A30079
DEFINE l_cut          LIKE type_file.num5   #FUN-A30079
DEFINE l_cnt          LIKE type_file.num5   #FUN-A80125
DEFINE l_cnt2         LIKE type_file.num5   #MOD-BB0266
DEFINE l_sql          STRING                #FUN-A90036

#--TQC-AA0098 add
   DROP TABLE p001_axj_tmp
   CREATE TEMP TABLE p001_axj_tmp(
      axj13   LIKE axj_file.axj13,    #FUN-D20048 add
      axj03   LIKE axj_file.axj03,
      axj06   LIKE axj_file.axj06,
      axj07   LIKE axj_file.axj07)
#--TQC-AA0098 add

#--FUN-A90036 start--
   DROP TABLE p001_adj_tmp
   CREATE TEMP TABLE p001_adj_tmp(
      axj03   LIKE axj_file.axj03,
      axj05   LIKE axj_file.axj05,
      axj06   LIKE axj_file.axj06,
      axj07   LIKE axj_file.axj07,
      axj071  LIKE axj_file.axj07)  #MOD-BC0176 add
     #axj071  LIKE axj_file.axj071) #MOD-BC0176 mark

   LET l_sql = "INSERT INTO p001_adj_tmp VALUES(?,?,?,?,?)"
   PREPARE insert_adj_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:p001_adj_tmp',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-BA0006
      EXIT PROGRAM
   END IF
#--FUN-A90036 end--

   #外幣換算損益(aaz86),換算調整數(aaz87)
   #本期損益-IS(aaz113),本期損益-BS(aaz114)   #FUN-990020
   SELECT aaz86,aaz87,aaz113,aaz114   #FUN-990020
     INTO l_aaz86,l_aaz87,l_aaz113,l_aaz114   #MOD-A10005 add
     FROM aaz_file   #FUN-580063

   #--FUN-A30079 start-
   SELECT axz06 INTO l_axz06_axf16
     FROM axz_file
  # WHERE axz01 = g_axf.axf16   #MOD-C30498  MARK
    WHERE axz01 = g_axi.axi06   #MOD-C30498  add
   #--FUN-A30079 end---

   LET l_amt_cnt = 0    #MOD-A70083

   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
   RETURNING g_bdate,g_edate
   LET g_yy=tm.yy   #FUN-770069 add
   LET g_mm=tm.em   #FUN-770069 add

   LET g_axg04 = ''  #FUN-770069 add 10/19
   LET g_amt = 0  #FUN-5A0118
   LET l_flag = "Y"  #FUN-770069 add 10/19

   SELECT axa09 INTO l_axa09 FROM axa_file                                     
    WHERE axa01= tm.axa01                                                      
     AND axa02= tm.axa02                                                      
     AND axa03= tm.axa03                                                      
  IF l_axa09 = 'Y' THEN  
     LET g_dbs_axz03 =  s_dbstring(g_dbs_axz03)                              
  ELSE                                                                        
     LET g_dbs_axz03 =  s_dbstring(g_dbs)                                    
  END IF                      

  INITIALIZE g_axi.* TO NULL  #TQC-AA0098
  INITIALIZE g_axj.* TO NULL  #TQC-AA0098

  #將累積換算調整數拆開依各子公司列示

  #--FUN-990020 add--兌換損益----                                                   
  LET g_sql =                                                                
      "SELECT axg04,SUM(axg09-axg08)",   #FUN-A60099                                       
#     "  FROM axg_file,",g_dbs_axz03,"aag_file",                             
      "  FROM axg_file,aag_file",        #FUN-A50102 
      " WHERE axg00='",g_aaz641,"'",                                         
      "   AND axg01='",tm.axa01,"'",                                         
      "   AND axg02='",tm.axa02,"'",                                         
      "   AND axg17='",tm.ver,"'",                                           
      "   AND axg06='",tm.yy,"'",                                            
      "   AND aag00 ='",g_aaz641,"'",                                        
      "   AND axg05 = aag01",                                                
      "   AND aag04 != '1'",                                                 
      "   AND axg05 != '",l_aaz113,"'",                                      
      "   AND axg07 = '",tm.em,"'",                     #FUN-A90006 mod
      "   AND NOT EXISTS (SELECT tat03 FROM tat_file WHERE tat01 = axg00 AND tat02 = axg06 and tat03 = axg05) ",  #FUN-C90097
      " GROUP BY axg04",                                                     
      " ORDER BY axg04"                                                      
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
 #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102	 #FUN-BA0006 mark
  PREPARE p001_adj_p2 FROM g_sql                                              
  DECLARE p001_adj_c2 CURSOR FOR p001_adj_p2                                  
  LET l_cnt = 0   #FUN-A80125
  FOREACH p001_adj_c2 INTO g_axg04,l_amt_aaz113                               
     IF SQLCA.sqlcode THEN                                                    
        LET g_axg04 = ' '                                                     
        LET l_amt_aaz113   = 0                                                
        CONTINUE FOREACH                                
     END IF                                                                   

    #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
    IF l_flag = "Y" THEN   #FUN-770069 add 10/19
       CALL p001_ins_axi()
       IF g_success = 'N' THEN RETURN  END IF
       UPDATE axi_file set axi09='Y' 
        WHERE axi01=g_axi.axi01
          AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
       #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
          CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
          RETURN 
       END IF
       LET l_flag = "N"
    END IF   #FUN-770069 add 10/19

#--FUN-990020 start-----兌換損益aaz86分錄----                                     
    SELECT SUM(axg09-axg08)  #FUN-A60099                                               
      INTO l_amt_aaz114                                                    
      FROM axg_file                                                        
     WHERE axg00=g_aaz641                                                  
       AND axg01=tm.axa01                                                  
       AND axg02=tm.axa02                                                  
       AND axg04=g_axg04                                                   
       AND axg17=tm.ver                                                    
       AND axg06=tm.yy                                                     
       AND axg05 =l_aaz114                                                 
       AND axg07 = tm.em                                                   

    IF cl_null(l_amt_aaz114) THEN LET l_amt_aaz114 = 0 END IF   #MOD-B30429
    LET l_amt_cnt = l_amt_aaz113 - l_amt_aaz114                               
         
    #-FUN-A90006 ---start
    IF l_amt_cnt <> 0 THEN
        #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
        IF l_flag = "Y" THEN   
           CALL p001_ins_axi()
           IF g_success = 'N' THEN RETURN  END IF
           UPDATE axi_file set axi09='Y'
            WHERE axi01=g_axi.axi01
              AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
           #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1)
              RETURN
           END IF
           LET l_flag = "N"
        END IF 
    END IF
    #--FUN-A90006 -- end
                                                                     
      LET g_axj.axj00=g_aaz641                                                  
      LET g_axj.axj01=g_axi.axi01                                               
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
       WHERE axj01=g_axj.axj01                                                  
         AND axj00=g_axj.axj00                                                  
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
      LET g_axj.axj03=l_aaz114                    #科目  #FUN-A30079 mod
      #LET g_axj.axj03=l_aaz86                    #科目  #FUN-A30079 mark                   
      #LET g_axj.axj04=' '                         #摘要    #FUN-D20048 mark
      LET g_axj.axj04 =  tm.axa02,':',g_axg04                #FUN-D20048 add                     
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
       WHERE axz01=g_axg04                                                      
                                                                                
      IF l_amt_cnt >0 THEN                                                      
         LET g_axj.axj06='2'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt               #金額                         
      ELSE                                                                      
         LET g_axj.axj06='1'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
      END IF                                                                    
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
      LET g_axj.axjlegal=g_legal     #FUN-A80125
      LET g_axj.axj13 = NULL         #FUN-D20048 add
      DISPLAY "7)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
      IF g_axj.axj07 != 0 THEN                                                  
         INSERT INTO axj_file VALUES (g_axj.*)                                  
      END IF                                                                    
                                                                                
      #--寫入一筆aaz87為對向科目的分錄和aaz86為一組---                          
      LET g_axj.axj00=g_aaz641                                                  
      LET g_axj.axj01=g_axi.axi01                                               
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file                        
       WHERE axj01=g_axj.axj01                                                  AND axj00=g_axj.axj00                                                  
                                                                                
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF                   
                                                                                
      LET g_axj.axj03=l_aaz87                     #科目                         
      #LET g_axj.axj04=' '                         #摘要     #FUN-D20048 add               
      LET g_axj.axj04 =  tm.axa02,':',g_axg04                #FUN-D20048 add        
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                       
       WHERE axz01=g_axg04 
                                                     
      #--FUN-A30079 start--
      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF
      LET g_axj.axj07=cl_digcut(g_axj.axj07,l_cut)
      #--FUN-A30079 end--

      IF l_amt_cnt >0 THEN                                                      
         LET g_axj.axj06='1'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt               #金額                         
      ELSE                                                                      
         LET g_axj.axj06='2'                      #借貸別                       
         LET g_axj.axj07= l_amt_cnt*-1            #金額                         
      END IF                                                                    
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF                      
      LET g_axj.axjlegal=g_legal     #FUN-A80125
      LET g_axj.axj13 =  NULL                                #FUN-D20048 add
      DISPLAY "8)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
      IF g_axj.axj07 != 0 THEN                                                  
         INSERT INTO axj_file VALUES (g_axj.*)                               
         LET l_cnt = l_cnt + 1   #FUN-A80125
      END IF                                                                    
   END FOREACH                                                                  

   #---FUN-A80125 start--
  #-MOD-BB0266-mark- 
  #IF l_cnt = 0 THEN
  #    DELETE FROM axi_file where axi00 = g_aaz641 AND axi01 = g_axi.axi01
  #    LET l_flag = 'Y'   #TQC-AA0098
  #END IF
  #-MOD-BB0266-end- 
   #--FUN-A80125 end----

#--MOD-A70083 start--
   IF l_amt_cnt = 0 THEN
      IF l_flag = "Y" THEN   
         CALL p001_ins_axi()
         IF g_success = 'N' THEN RETURN  END IF
         UPDATE axi_file set axi09='Y' 
          WHERE axi01=g_axi.axi01
            AND axi00=g_aaz641 
         #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
            CALL s_errmsg('axi01',g_axi.axi01,'upd_axi',SQLCA.sqlcode,1) 
            RETURN 
         END IF
         LET l_flag = "N"
      END IF  
   END IF
#---MOD-A70083 end-----

   LET g_sql =                                                                  
       "SELECT axg04,SUM(axg08-axg09)",    #TQC-AA009                                        
       "  FROM axg_file,aag_file" ,                              
       " WHERE axg00='",g_aaz641,"'",                                           
       "   AND axg01='",tm.axa01,"'",                                           
       "   AND axg02='",tm.axa02,"'",                                           
       "   AND axg17='",tm.ver,"'",                                             
       "   AND axg06='",tm.yy,"'",                                              
       "   AND axg07 ='",tm.em,"'",                                             
       "   AND aag00 ='",g_aaz641,"'",                                          
       "   AND axg05 = aag01",                                                  
       "   AND aag04 = '1'",                                                    
       " GROUP BY axg04",                                                       
       " ORDER BY axg04"                                                        
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE p001_adj_p1 FROM g_sql                                               
   DECLARE p001_adj_c1 CURSOR FOR p001_adj_p1                                   
   LET l_cnt2 = 0   #FUN-A80125   #MOD-BB0266 mod l_cnt -> l_cnt2
   FOREACH p001_adj_c1 INTO g_axg04,g_amt                                       
      IF SQLCA.sqlcode THEN                                                     LET g_axg04 = ' '                                                      
         LET g_amt   = 0                                                        
         CONTINUE FOREACH                                                       
      END IF                                                                    
      IF g_amt = 0 THEN                                                         
         CONTINUE FOREACH                                                       
      END IF                                                                    

      LET g_axj.axj00=g_aaz641   #FUN-920067 mod
      LET g_axj.axj01=g_axi.axi01
      SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file 
       WHERE axj01=g_axj.axj01
         AND axj00=g_axj.axj00  #FUN-760053
      IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
      LET g_axj.axj03=l_aaz87                     #科目
      #LET g_axj.axj04=' '                         #摘要     #FUN-D20048 mark
      LET g_axj.axj04 = tm.axa02,':',g_axg04                 #FUN-D20048 add
      SELECT axz08 INTO g_axj.axj05 FROM axz_file #關系人                                                                   
       WHERE axz01=g_axg04                                                                                                  
      IF g_amt >0 THEN
         LET g_axj.axj06='2'                      #借貸別
         LET g_axj.axj07=g_amt                    #金額
      ELSE
         LET g_axj.axj06='1'                      #借貸別
         LET g_axj.axj07=g_amt*-1                 #金額
      END IF
      IF g_axj.axj07 IS NULL THEN LET g_axj.axj07=0 END IF   #FUN-760053 add
      LET g_axj.axjlegal=g_legal     #FUN-A80125
      LET g_axj.axj13 =  NULL                                #FUN-D20048 add
      DISPLAY "9)axj04: ",g_axj.axj04," axj13: ",g_axj.axj13 #FUN-D20048
      IF g_axj.axj07 != 0 THEN   #MOD-890130 add
         INSERT INTO axj_file VALUES (g_axj.*)
         LET l_cnt2 = l_cnt2 + 1   #FUN-A80125 #MOD-BB0266 mod l_cnt -> l_cnt2
         #先將資料寫TempTable裡,後續股本累換數使用
         CALL p001_adj_tmp(g_axj.*)      #FUN-A90036
      END IF                     #MOD-890130 add
   END FOREACH   #FUN-770069 add 10/19
   LET l_cnt = l_cnt + l_cnt2  #MOD-BB0266
   #---FUN-A80125 start--
   IF l_cnt = 0 THEN
       DELETE FROM axi_file where axi00 = g_aaz641 AND axi01 = g_axi.axi01
   END IF
   #--FUN-A80125 end----
   CALL upd_axi()
END FUNCTION 

#--FUN-A90036 start--
FUNCTION p001_adj_tmp(p_axj)
DEFINE p_axj  RECORD LIKE axj_file.*
DEFINE l_axj  RECORD 
              axj03    VARCHAR(24),
              axj05    VARCHAR(15),               
              axj06    VARCHAR(1),
              axj07    DECIMAL(20,6),             
              axj071    DECIMAL(20,6)             
              END RECORD
DEFINE l_x    LIKE type_file.num5

   SELECT COUNT(*) INTO l_x FROM p001_adj_tmp
    WHERE axj03 = p_axj.axj03
      AND axj05 = p_axj.axj05

   LET l_axj.axj03 = p_axj.axj03
   LET l_axj.axj05 = p_axj.axj05
   LET l_axj.axj06 = ''

   IF l_x = 0 THEN
      IF p_axj.axj06 = '1' THEN
         LET l_axj.axj07 = p_axj.axj07
         LET l_axj.axj071 = 0
      ELSE
         LET l_axj.axj07 =  0
         LET l_axj.axj071 = p_axj.axj07
      END IF
      EXECUTE insert_adj_prep USING l_axj.axj03,l_axj.axj05,p_axj.axj06,l_axj.axj07,l_axj.axj071    #TQC-AA0098
   ELSE
      SELECT * INTO l_axj.*  FROM  p001_adj_tmp
       WHERE axj03 = p_axj.axj03
         AND axj05 = p_axj.axj05

      IF p_axj.axj06 = '1' THEN
         LET l_axj.axj07 = l_axj.axj07 + p_axj.axj07
      ELSE
         LET l_axj.axj071 = l_axj.axj071 + p_axj.axj07
      END IF

      UPDATE p001_adj_tmp SET axj07  =  l_axj.axj07,
                              axj071 =  l_axj.axj071,
                              axj06 = p_axj.axj06    #TQC-AA0098
       WHERE axj03 = p_axj.axj03
         AND axj05 = p_axj.axj05
   END IF

END FUNCTION                                                                        
#--FUN-A90036 end---

FUNCTION get_rate()#持股比率
#DEFINE l_axb07   LIKE axb_file.axb07,       #FUN-C50059 mark
#      l_axb08    LIKE axb_file.axb08,       #FUN-C50059 mark
DEFINE l_axbb07   LIKE axbb_file.axbb07,     #FUN-C50059
       l_axbb06   LIKE axbb_file.axbb06,     #FUN-C50059
       l_axd07b   LIKE axd_file.axd07b,
       l_axd08b   LIKE axd_file.axd08b,
       l_count    LIKE type_file.num5,       #No.FUN-680098   SMALLINT
       l_sql      LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(600)
       l_axz05    LIKE axz_file.axz05        #MOD-A70113 add
      ,l_axbb03   LIKE axbb_file.axbb03      #MOD-D10049 ADD

    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=g_axf.axf10      #MOD-A70113 add
    #SELECT axb07,axb08 INTO l_axb07,l_axb08 FROM axb_file
   #FUN-C50059--mark-- 
   #SELECT unique axb07,axb08 INTO l_axb07,l_axb08 FROM axb_file  #FUN-B90069
   # WHERE axb01=tm.axa01 AND axb02=tm.axa02 AND axb03=tm.axa03
   #   AND axb04=g_axf.axf10 AND axb05=l_axz05          #MOD-A70113 add
   #FUN-C50059--mark--
   #MOD-D10049
   SELECT axz05 INTO l_axbb03 FROM axz_file WHERE axz01=tm.axa02
   #MOD-D10049
   #FUN-C50059--
    SELECT axbb07,axbb06 INTO l_axbb07,l_axbb06 FROM axbb_file    #FUN-C50059
     #WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=tm.axa03   #MOD-D10049 mark
     WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=l_axbb03   #MOD-D10049
       AND axbb04=g_axf.axf10 AND axbb05=l_axz05
       AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                      #WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=tm.axa03   #MOD-D10049 mark
                      WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=l_axbb03  #MOD-D10049
                        AND axbb04=g_axf.axf10 AND axbb05=l_axz05 AND axbb06<g_edate) 
   #FUN-C50059--
    IF STATUS THEN LET g_rate=0 RETURN END IF
   #IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN LET g_rate=l_axb07/100 RETURN END IF         #FUN-C50059 mark
    IF g_edate >= l_axbb06 OR cl_null(l_axbb06) THEN LET g_rate=l_axbb07/100 RETURN END IF      #FUN-C50059
    
    LET l_count=0
    LET g_rate =0
    LET l_sql="SELECT axd07b,axd08b  FROM axd_file ",
              " WHERE axd01='",tm.axa01,"'",
              "   AND axd02='",tm.axa02,"' AND axd03='",tm.axa03,"'",
              "   AND axd04b='",g_axf.axf10,"' AND axd05b='",l_axz05,"'",      #MOD-A70113 add 
              " ORDER BY axd08b desc"  #MOD-940010 add
    PREPARE p001_axd_p FROM l_sql
    IF STATUS THEN 
        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN     #NO.FUN-710023    
    END IF
    DECLARE p001_axd_c CURSOR FOR p001_axd_p

    FOREACH p001_axd_c INTO l_axd07b,l_axd08b
       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
       LET l_count=l_count+1
       IF g_edate>=l_axd08b THEN LET g_rate=l_axd07b/100 EXIT FOREACH END IF   #FUN-770069      10/19
    END FOREACH       
    IF l_count=0 THEN LET g_rate=0 RETURN END IF
END FUNCTION
   
FUNCTION upd_axi()
DEFINE l_sum_tot    LIKE axj_file.axj07

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot  FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='1'
       AND axj00=g_aaz641 #FUN-760053   #FUN-920067 mod
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
    IF STATUS OR cl_null(l_sum_tot) THEN 
       RETURN
    END IF
    UPDATE axi_file SET axi11 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
       RETURN
    END IF

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='2'
       AND axj00=g_aaz641  #FUN-760053   #FUN-920067 mod
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF   #FUN-5A0195
    IF STATUS OR cl_null(l_sum_tot) THEN
       RETURN
    END IF
    UPDATE axi_file SET axi12 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaz641  #FUN-760053   #FUN-920067 mod
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       RETURN
    END IF
END FUNCTION

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
#---FUN-B70064 start---
FUNCTION p001_getrate3(l_value,l_axp01,l_axp02,l_axp03,l_axp04)
DEFINE l_value LIKE axe_file.axe11,
       l_axp01 LIKE axp_file.axp01,
       l_axp02 LIKE axp_file.axp02,
       l_axp03 LIKE axp_file.axp03,
       l_axp04 LIKE axp_file.axp04,
       l_axp05 LIKE axp_file.axp05,    
       l_axp06 LIKE axp_file.axp06,   
       l_axp07 LIKE axp_file.axp07,  
       l_rate  LIKE axp_file.axp05  

   SELECT axp05,axp06,axp07 
     INTO l_axp05,l_axp06,l_axp07 
     FROM axp_file
    WHERE axp01=l_axp01
      AND axp02=l_axp02
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
#---FUN-B70064 end----------


#FUNCTION p001_modi_axf_misc(p_axf01,p_axf02,p_axf15,i)         #FUN-A80137 mark
FUNCTION p001_modi_axf_misc(p_axf01,p_axf02,p_axf15,p_axf17,i)  #FUN-A80137
   DEFINE p_axf01   STRING
   DEFINE p_axf02   STRING
   DEFINE p_axf17   LIKE axf_file.axf17                 #FUN-A80137
   DEFINE p_axf15   LIKE axf_file.axf15,
          l_cnt        LIKE type_file.num5,             #FUN-760053 add
          l_sql,l_sql1 STRING,                          #FUN-5A0118        
          i,g_no       LIKE type_file.num5             #No.FUN-680098   SMALLINT
   DEFINE l_axz08      LIKE axz_file.axz08              #FUN-920067 add
   DEFINE l_axf09_axz05      LIKE axz_file.axz05              #FUN-920067 add  
   DEFINE l_axf10_axz05      LIKE axz_file.axz05              #FUN-920067
   DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10  #FUN-920167
   DEFINE l_i                LIKE type_file.num5  #FUN-920167 
   DEFINE l_aag04            LIKE aag_file.aag04  #FUN-920167
   DEFINE l_axz08_axf10      LIKE axz_file.axz08  #FUN-960096
   DEFINE l_axz03_axf09      LIKE axz_file.axz03  #FUN-A30079
   DEFINE l_axz03_axf10      LIKE axz_file.axz03  #FUN-A30079
   DEFINE g_dbs_axf09        LIKE azp_file.azp03  #FUN-A30079 
   DEFINE g_dbs_axf10        LIKE azp_file.azp03  #FUN-A30079 
   DEFINE l_axb02            LIKE axb_file.axb02  #FUN-A30079
  #DEFINE l_axa09_axf09      LIKE axa_file.axa09  #FUN-A30079  #FUN-A90006 mark
  #DEFINE l_axa09_axf10      LIKE axa_file.axa09  #FUN-A30079  #FUN-A90006 mark
  #DEFINE l_axz06_axf09      LIKE axz_file.axz06  #FUN-A30079  #FUN-A90006 mark
  #DEFINE l_axz06_axf10      LIKE axz_file.axz06  #FUN-A30079  #FUN-A90006 mark
   DEFINE l_low_axf09        LIKE type_file.num5  #FUN-A60060
   DEFINE l_up_axf09         LIKE type_file.num5  #FUN-A60060
   DEFINE l_low_axf10        LIKE type_file.num5  #FUN-A60060
   DEFINE l_up_axf10         LIKE type_file.num5  #FUN-A60060
   DEFINE l_axa02_axf09      LIKE axa_file.axa02  #FUN-A60060
   DEFINE l_axa02_axf10      LIKE axa_file.axa02  #FUN-A60060
   DEFINE l_axz06_axf16      LIKE axz_file.axz06  #FUN-A90026 
  # -- FUN-A90036 start--
   DEFINE l_axj03            LIKE axj_file.axj03
   DEFINE l_axj05            LIKE axj_file.axj05
   DEFINE l_axj06            LIKE axj_file.axj06
   DEFINE l_axj07            LIKE axj_file.axj07
   DEFINE l_axj07_d          LIKE axj_file.axj07
   DEFINE l_axj07_c          LIKE axj_file.axj07
  # -- FUN-A90036 end--
   DEFINE l_axt03            LIKE axt_file.axt03   #TQC-AA0098
   DEFINE l_aac01            LIKE type_file.chr6   #MOD-C30082

     DELETE FROM p001_tmp   #FUN-760053 add

     #--FUN-920067 start-- 抓出上層公司axf10在agli009中設定帳別
     SELECT axz05 INTO g_axf09_axz05   #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf09
      SELECT axz05 INTO g_axf10_axz05  #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf10

     #--FUN-920167 start-- 抓出下層公司axf10在agli009中設定的關係人異動碼值--
     SELECT axz08 INTO g_axz08  #FUN-A90006 
       FROM axz_file
      WHERE axz01 = g_axf.axf09   #FUN-930112
      SELECT axz08 INTO g_axz08_axf10  #FUN-A90006 
       FROM axz_file WHERE axz01 = g_axf.axf10

 
     #--FUN-A30079 start--
     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
     #之前的應用方式為tm.axa02上層公司輸入之後抓取的axg,axk資料都是自己本身
     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
     #SQL抓資料時分為以下狀況 ：
     #A.來源(目的)公司=合併主體：(順流)
     #  A1.axg02 = 自己, axg04 = 自己
     #  A2.axg02 = 不用加入此條件, axg04 = 自己
     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
     #  IF 屬於上層公司
     #    1.最上層公司：條件=>axg02 = 自己, axg04 = 自己
     #    2.中間層(有上層也有下層),條件=> axg02 = 自己的上層公司,axg04 = 自己 
     #  ELSE
     #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己
     #  END IF
  
     #--先判斷g_axf.axf09(來源)/g_axf.axf10(目的)各自是否為上層公司--
     LET g_cnt_axf09 = 0
     SELECT COUNT(*) INTO g_cnt_axf09 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf09   #上層公司 

     LET g_cnt_axf10 = 0
     SELECT COUNT(*) INTO g_cnt_axf10 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf10   #上層公司

     #--FUN-A60060 start-------------------
     IF g_cnt_axf09 > 0 THEN    #代表為上層公司
        #判斷是否存在下層
        SELECT COUNT(*) INTO g_low_axf09  #FUN-A90006
          FROM axb_file
         WHERE axb01 = tm.axa01
           AND axb04 = g_axf.axf09
        IF g_low_axf09 > 0 THEN          #FUN-A90006
          #--如果l_up_axf09 = 0 代表是最下層
           SELECT COUNT(*) INTO g_up_axf09    #FUN-A90006
             FROM axa_file 
            WHERE axa01 = tm.axa01
              AND axa02 = g_axf.axf09
           IF g_up_axf09 <> 0 THEN             #FUN-A90006
              SELECT axb02 INTO g_axa02_axf09   #FUN-A90006
                FROM axb_file
               WHERE axb01 = tm.axa01
                 AND axb04 = g_axf.axf09
             #--如果g_up_axf09 = 0 代表是最下層
              SELECT COUNT(*) INTO g_up_axf09    #FUN-A90006
                FROM axa_file 
               WHERE axa01 = tm.axa01
                 AND axa02 = g_axf.axf09
           END IF
        END IF
     #--FUN-A60078 start--
     ELSE
         SELECT axb02 INTO g_axa02_axf09          #FUN-A90006
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf09
     #--FUN-A60078 end--
     END IF   

     IF g_cnt_axf10 > 0 THEN   #代表為上層公司
         #判斷是否存在下層
         SELECT COUNT(*) INTO g_low_axf10     #FUN-A90006
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         IF g_low_axf10 > 0 THEN              #FUN-A90006
             #--如果l_up_axf10 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_axf10  #FUN-A90006
               FROM axa_file 
              WHERE axa01 = tm.axa01
                AND axa02 = g_axf.axf10
            IF g_up_axf10 <> 0 THEN           #FUN-A90006
                SELECT axb02 INTO g_axa02_axf10    #FUN-A90006
                  FROM axb_file
                 WHERE axb01 = tm.axa01
                   AND axb04 = g_axf.axf10
            END IF
         END IF
     #--FUN-A60078 START
     ELSE
         SELECT axb02 INTO g_axa02_axf10           #FUN-A90006
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
     #--FUN-A60078 end--
     END IF   
     #--FUN-A60060 end-----------------------

     #合併帳別取法： 
     #是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的合併帳別
     #IF 'N' -->則為當下營運中心合併帳別
     #不是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的上層公司的合併帳別
     #IF 'N' -->則為當下營運中心的合併帳別
     
     IF g_cnt_axf09 > 0 THEN   #為上層公司
        SELECT axa09 INTO g_axa09_axf09   #FUN-A90006
          FROM axa_file 
         WHERE axa01 = tm.axa01
           AND axa02 = g_axf.axf09
        SELECT axz03 INTO l_axz03_axf09 
          FROM axz_file 
         WHERE axz01 = g_axf.axf09
        SELECT azp03 INTO g_dbs_axf09 FROM azp_file
         WHERE azp01 = l_axz03_axf09
        IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
            LET l_axz03_axf09 = l_axz03_axf09            #TQC-BA0066
           #LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)	  #TQC-BA0066 mark
        ELSE
           #LET g_dbs_axf09 = s_dbstring(g_dbs)          #TQC-BA0066 mark
            LET l_axz03_axf09 = g_plant                  #TQC-BA0066
        END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
        SELECT axb02 INTO l_axb02
          FROM axb_file 
         WHERE axb01 = tm.axa01
           AND axb04 = g_axf.axf09
        SELECT axa09,axa02 INTO g_axa09_axf09,g_axa02_axf09   #FUN-A90006
          FROM axa_file 
         WHERE axa01 = tm.axa01
           AND axa02 = l_axb02
        SELECT axz03 INTO l_axz03_axf09 
          FROM axz_file 
         WHERE axz01 = l_axb02
        SELECT azp03 INTO g_dbs_axf09 FROM azp_file
         WHERE azp01 = l_axz03_axf09
        IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別     #FUN-A90006
          #LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)     #TQC-BA0066
           LET l_axz03_axf09 = l_axz03_axf09             #TQC-BA0066
        ELSE
          #LET g_dbs_axf09 = s_dbstring(g_dbs)           #TQC-BA0066
           LET l_axz03_axf09 = g_plant                   #TQC-BA0066
        END IF
     END IF        
    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axf09,"aaz_file",   #FUN-A50102
     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(l_axz03_axf09,'aaz_file'),   #FUN-A50102
                 " WHERE aaz00 = '0'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
    #CALL cl_parse_qry_sql(g_sql,l_axz03_axf10) RETURNING g_sql   #TQC-BA0066 mark #FUN-A50102
     CALL cl_parse_qry_sql(g_sql,l_axz03_axf09) RETURNING g_sql   #TQC-BA0066
     PREPARE p001_aaz_p1 FROM g_sql
     DECLARE p001_aaz_c1 CURSOR FOR p001_aaz_p1
     OPEN p001_aaz_c1
     FETCH p001_aaz_c1 INTO g_aaz641_axf09   #合併帳別
     CLOSE p001_aaz_c1

     IF g_cnt_axf10 > 0 THEN   #為上層公司
         SELECT axa09 INTO g_axa09_axf10  #FUN-A90006
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = g_axf.axf10
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = g_axf.axf10
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
            #LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)	     #TQC-BA0066 mark
             LET l_axz03_axf10 = l_axz03_axf10               #TQC-BA0066
         ELSE
            #LET g_dbs_axf10 = s_dbstring(g_dbs)             #TQC-BA0066 mark
             LET l_axz03_axf10 = g_plant                     #TQC-BA0066
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
         SELECT axb02 INTO l_axb02
           FROM axb_file 
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         SELECT axa09 INTO g_axa09_axf10   #FUN-A90006
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = l_axb02
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = l_axb02
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別   #FUN-A90006
            #LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)	     #TQC-BA0066 mark
             LET l_axz03_axf10 = l_axz03_axf10               #TQC-BA0066
         ELSE
            #LET g_dbs_axf10 = s_dbstring(g_dbs)			 #TQC-BA0066 mark
             LET l_axz03_axf10 = g_plant                     #TQC-BA0066
         END IF
     END IF        
    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axf10,"aaz_file",  #TQC-BA0066	mark
     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(l_axz03_axf10,'aaz_file'),   #TQC-BA0066
                 " WHERE aaz00 = '0'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
     CALL cl_parse_qry_sql(g_sql,l_axz03_axf10) RETURNING g_sql #TQC-BA0066
     PREPARE p001_aaz_p2 FROM g_sql
     DECLARE p001_aaz_c2 CURSOR FOR p001_aaz_p2
     OPEN p001_aaz_c2
     FETCH p001_aaz_c2 INTO g_aaz641_axf10   #合併帳別
     CLOSE p001_aaz_c2
 
     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
     SELECT axz06 INTO g_axz06_axf09    #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf09   #來源公司記帳幣別
     SELECT axz06 INTO g_axz06_axf10    #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf10   #目的公司記帳幣別
     
     #--FUN-A30079 end---
     #--------FUN-B90069 start--
     #--------由此處開始處理來源科目---------
     #先判斷來源科目是否為MISC
     #如果不是,則判斷是否為"少數股權"或"少數股權淨利"科目
     #如果是，先利用FOREACH將科目一一解析,判斷是否為"少數股權"或"少數股權淨利"科目
     #屬於"少數股權"或"少數股權淨利"科目者，需從axh,axkk取得
     #因為這是沖銷後產生至分錄的(aglp002會寫入axh,axkk)，axg,axk不存在
     
     IF p_axf01 <> 'MISC' THEN
         IF (g_axf.axf01 = g_aaz128) OR (g_axf.axf01 = g_aaz129) THEN
             CALL p001_axf01_axh(g_axf.axf01,i) RETURNING l_sql  
         ELSE
             CALL p001_axf01_axg(g_axf.axf01,i) RETURNING l_sql
         END IF
         CALL p001_ins_temp(l_sql,i)    #將l_sql取到的科餘寫入TEMP檔供後續產生沖銷資料用
     ELSE
         LET g_sql = "SELECT axs03 FROM axs_file ",
                     " WHERE axs00 = '",g_aaz641_axf09,"'",   
                     "   AND axs01 = '",g_axf.axf01,"'",
                     "   AND axs09 = '",g_axf.axf09,"'",
                     "   AND axs10 = '",g_axf.axf10,"'",
                     "   AND axs12 = '",g_aaz641_axf10,"'",  
                     "   AND axs13 = '",g_axf.axf13,"'" 
         PREPARE p001_axs03_p1 FROM g_sql
         IF STATUS THEN 
            CALL s_errmsg('axs03','','p001_axs03_p1',STATUS,1)  
            LET g_success = 'N'  
         END IF 
         DECLARE p001_axs03_c1 CURSOR FOR p001_axs03_p1
         FOREACH p001_axs03_c1 INTO g_axs03
             IF (g_axs03 = g_aaz128) OR (g_axs03 = g_aaz129) THEN
                 CALL p001_axf01_axh(g_axs03,i) RETURNING l_sql
             ELSE
                 CALL p001_axf01_axg(g_axs03,i) RETURNING l_sql
             END IF
             CALL p001_ins_temp(l_sql,i)    #將l_sql取到的科餘寫入TEMP檔供後續產生沖銷資料用
         END FOREACH
     END IF

     #--------由此處開始處理對沖科目---------
     #先判斷對沖科目是否為MISC
     #如果不是,則判斷是否為"少數股權"或"少數股權淨利"科目
     #如果是，先利用FOREACH將科目一一解析,判斷是否為"少數股權"或"少數股權淨利"科目
     #屬於"少數股權"或"少數股權淨利"科目者，需從axh,axkk取得
     #因為這是沖銷後產生至分錄的(aglp002會寫入axh,axkk)，axg,axk不存在
     
     IF p_axf02 <> 'MISC' THEN
         IF (g_axf.axf02 = g_aaz128) OR (g_axf.axf02 = g_aaz129) THEN
             CALL p001_axf02_axh(g_axf.axf02,i) RETURNING l_sql
         ELSE
             CALL p001_axf02_axg(g_axf.axf02,i) RETURNING l_sql
         END IF
         CALL p001_ins_temp(l_sql,i)    #將l_sql取到的科餘寫入TEMP檔供後續產生沖銷資料用
     ELSE
         LET g_sql = "SELECT axt03 FROM axt_file ",
                     " WHERE axt00 = '",g_aaz641_axf09,"'",   
                     "   AND axt01 = '",g_axf.axf02,"'",
                     "   AND axt09 = '",g_axf.axf09,"'",
                     "   AND axt10 = '",g_axf.axf10,"'",
                     "   AND axt12 = '",g_aaz641_axf10,"'",  
                     "   AND axt13 = '",g_axf.axf13,"'",
                     "   AND axt04 != 'Y' "    #是否依據公式設定
         PREPARE p001_axt03_p1 FROM g_sql
         IF STATUS THEN 
            CALL s_errmsg('axt03','','p001_axt03_p1',STATUS,1)  
            LET g_success = 'N'  
         END IF 
         DECLARE p001_axt03_c1 CURSOR FOR p001_axt03_p1
         FOREACH p001_axt03_c1 INTO g_axt03
             IF (g_axt03 = g_aaz128) OR (g_axt03 = g_aaz129) THEN
                 CALL p001_axf02_axh(g_axt03,i) RETURNING l_sql
             ELSE
                 CALL p001_axf02_axg(g_axt03,i) RETURNING l_sql
             END IF
             CALL p001_ins_temp(l_sql,i)    #將l_sql取到的科餘寫入TEMP檔供後續產生沖銷資料用
         END FOREACH
     END IF
     #--------FUN-B90069 end-----------

#----FUN-B90069 mark---移到p001_axf01_axg()處理------------
#    #--#資料來源為axg_file---start----
#    IF p_axf15 = '1' THEN        
#        LET l_sql =" SELECT 'A','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",  #FUN-930144 mod  #FUN-A90026 mod
#                   "         axg12,'",g_axz08_axf10,"','2','N','' "    #FUN-A90006
#        LET l_sql = l_sql CLIPPED,
#        #---FUN-A30079 end---
#                   "   FROM axg_file ",
#                   "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
#                   "     AND axg00 ='",g_aaz641_axf09,"' ",  #合併帳別   #FUN0-A30079
#                   "    AND axg04 ='",g_axf.axf09,"' ",      #來源公司
#                   "    AND axg041='",g_axf09_axz05,"' ",    #來源帳別    #FUN-A90006
#                   "    AND axg06 = ",tm.yy,                 #年度
#                   "    AND axg07 = '",tm.em,"'"             #FUN-970046 mod   只抓截止期別的金額
#                   #---FUN-A60060 start---
#                   #A.來源公司=合併主體：(順流)
#                   #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
#                   #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
#                   #B.來源公司 <> 合併主體：(側流或逆流)
#                   #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
#                   #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
#                         #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axg02、axg04都抓自己(axf09)
#                   #    2.中間層(有上層也有下層),
#                   #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
#                   #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
#                   #  ELSE
#                   #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
#                   #  END IF
#                    IF g_axf.axf09 = g_axf.axf16 THEN
#                        #-FUN-A70011
#                        IF g_axf.axf14 = 'Y' THEN
#                            LET l_sql = l_sql CLIPPED,
#                                "    AND axg02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                        ELSE
#                        #-FUN-A70011 end--
#                            LET l_sql = l_sql CLIPPED,
#                            "    AND axg02 = '",g_axf.axf09,"'" 
#                        END IF         #FUN-A70011
#                    ELSE
#                        IF g_cnt_axf09 > 0 THEN
#                            IF g_low_axf09 = 0 THEN #最上層   #FUN-A90006
#                               LET l_sql = l_sql CLIPPED,
#                                           "    AND axg02 = '",g_axf.axf09,"'" 
#                            ELSE
#                           #str MOD-C10035 mod
#                           #   IF g_axf.axf14 = 'Y' THEN   #FUN-A60099
#                           #      LET l_sql = l_sql CLIPPED,
#                           #                  "    AND axg02 = '",g_axa02_axf09,"'"   #FUN-A90006
#                           #   ELSE                                            #FUN-A60099
#                           #      LET l_sql = l_sql CLIPPED,                  #FUN-A60099
#                           #                  "    AND axg02 = '",g_axf.axf09,"'"     #FUN-A60099
#                           #   END IF                                          #FUN-A60099
#                               LET l_sql = l_sql CLIPPED,
#                                           "    AND axg02 = '",g_axf.axf09,"'" 
#                           #end MOD-C10035 mod
#                            END IF
#                        #--FUN-A70011 start--
#                        ELSE
#                            LET l_sql = l_sql CLIPPED,
#                            "    AND axg02 = '",g_axa02_axf09,"'"               #FUN-A90006
#                        #-FUN-A70011 end--
#                        END IF  
#                    END IF
#                    #--FUN-A60060 end--------
#---FUN-A80137 start---#axf15 = '2' 來源科目檔案資料來源:axk_file
#    ELSE
#        LET l_sql =" SELECT 'A','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ",   #FUN-A90026 mod  #MOD-AC0388
#                   "        axk14,'",g_axz08_axf10,"','2','N',axk07 ",      #FUN-A90006   
#                   "   FROM axk_file ",
#                   "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
#                   "    AND axk00 ='",g_aaz641_axf09,"' ",   
#                   "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
#                   "    AND axk041='",g_axf09_axz05,"' ",     #來源帳別    #FUN-A90006
#                   "    AND axk08 = ",tm.yy,                  #年度
#                   "    AND axk07 = '",g_axz08_axf10 ,"'",    #FUN-A90006
#                   "    AND axk09 = '",tm.em,"'"           
#        #A.來源公司=合併主體：(順流)
#        #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
#        #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
#        #B.來源公司 <> 合併主體：(側流或逆流)
#        #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
#        #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
#              #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axk02、axk04都抓自己(axf09)
#        #    2.中間層(有上層也有下層):
#        #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
#        #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
#        #  ELSE
#        #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
#        #  END IF
#        IF g_axf.axf09 = g_axf.axf16 THEN
#            IF g_axf.axf14 = 'Y' THEN
#                LET l_sql = l_sql CLIPPED,
#               #"    AND axk02 = '",g_axa02_axf09,"'"   #TQC-B50162 mark #FUN-A90006
#                "    AND axk02 = '",g_axa02_axf10,"'"   #TQC-B50162
#            ELSE
#                LET l_sql = l_sql CLIPPED,
#                "    AND axk02 = '",g_axf.axf09,"'" 
#            END IF    #FUN-A70011 
#        ELSE
#            IF g_cnt_axf09 > 0 THEN
#                 IF g_low_axf09 = 0 THEN #最上層  #FUN-A90006
#                    LET l_sql = l_sql CLIPPED,
#                        "    AND axk02 = '",g_axf.axf09,"'" 
#                 ELSE
#                   #str MOD-C10035 mod
#                   #2.中間層(有上層也有下層): 條件=>axk02 = 自己(axf09),axk04 = 自己(axf09)
#                   #IF g_axf.axf14 = 'Y' THEN     
#                   #   LET l_sql = l_sql CLIPPED,
#                   #       "    AND axk02 = '",g_axa02_axf09,"'"    #FUN-A90006
#                   #ELSE                         
#                   #   LET l_sql = l_sql CLIPPED, 
#                   #       "    AND axk02 = '",g_axf.axf09,"'"   
#                   #END IF 
#                    LET l_sql = l_sql CLIPPED,
#                        "    AND axk02 = '",g_axf.axf09,"'"
#                   #end MOD-C10035 mod                                      
#                END IF
#            ELSE
#                 LET l_sql = l_sql CLIPPED,
#                 "    AND axk02 = '",g_axa02_axf09,"'"               #FUN-A90006
#            END IF  
#        END IF
#    END IF

#    IF p_axf15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
#        CASE 
#          WHEN p_axf01 = 'MISC' 
#            LET l_sql = l_sql CLIPPED,
#            "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
#            "                   WHERE axs00 = '",g_aaz641_axf09,"'",   
#            "                     AND axs01 = '",g_axf.axf01,"'",
#            "                     AND axs09 = '",g_axf.axf09,"'",
#            "                     AND axs10 = '",g_axf.axf10,"'",
#            "                     AND axs12 = '",g_aaz641_axf10,"'",  
#            "                     AND axs13 = '",g_axf.axf13,"')" 
#          WHEN p_axf01 != 'MISC'
#            LET l_sql = l_sql CLIPPED,
#            "    AND axg05 = '",g_axf.axf01,"'"
#        END CASE
#    ELSE   #axf15 = '2'
#        CASE WHEN p_axf01 = 'MISC' 
#              LET l_sql = l_sql CLIPPED,
#              "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
#              "                   WHERE axs00 = '",g_aaz641_axf09,"'",  
#              "                     AND axs01 = '",g_axf.axf01,"'",
#              "                     AND axs09 = '",g_axf.axf09,"'",
#              "                     AND axs10 = '",g_axf.axf10,"'",
#              "                     AND axs12 = '",g_aaz641_axf10,"'",  
#              "                     AND axs13 = '",g_axf.axf13,"')"  
#             WHEN p_axf01 != 'MISC'
#               LET l_sql = l_sql CLIPPED,
#               "    AND axk05 = '",g_axf.axf01,"'"
#        END CASE
#    END IF

#    IF p_axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axg_file
#        LET l_sql = l_sql CLIPPED,   
#        "  UNION ",
#        " SELECT 'B','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-A90026 mod   #MOD-AC0388
#        "        axg12,'",g_axz08,"','1','N','' ",   
#        "   FROM axg_file ",
#        "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#        "    AND axg00 ='",g_aaz641_axf10,"' ",               
#        "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
#        "    AND axg041='",g_axf10_axz05,"' ",                 #對沖帳別  
#        "    AND axg06 = ",tm.yy,
#        "    AND axg07 = '",tm.em,"'"                         
#        CASE 
#          WHEN p_axf02 = 'MISC' 
#            LET l_sql = l_sql CLIPPED,
#            "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
#            "                   WHERE axt00 = '",g_aaz641_axf09,"'", 
#            "                     AND axt01 = '",g_axf.axf02,"'",
#            "                     AND axt09 = '",g_axf.axf09,"'",
#            "                     AND axt10 = '",g_axf.axf10,"'",
#            "                     AND axt12 = '",g_aaz641_axf10,"'",  
#            "                     AND axt13 = '",g_axf.axf13,"'",  
#            "                     AND axt04 != 'Y') "  #是否依據公式設定
#          WHEN p_axf02 != 'MISC'
#            LET l_sql = l_sql CLIPPED,
#            "    AND axg05 = '",g_axf.axf02,"'"
#        END CASE

#        #A.來源公司=合併主體：(順流)
#        #  目的:axg02 = 自己的上層公司(g_axa02_axf10), axg04 = 自己
#        #B.來源公司 <> 合併主體：(側流或逆流)
#        #  IF 目的屬於上層公司
#        #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
#        #    2.中間層(有上層也有下層):
#        #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
#        #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
#        #  ELSE
#        #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
#        #  END IF
#        IF g_cnt_axf10 > 0 THEN
#            IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                LET l_sql = l_sql CLIPPED,
#                    "    AND axg02 = '",g_axf.axf10,"'"
#            ELSE
#                IF g_up_axf10 > 0 THEN    #大於0代表不是最下層    #FUN-A90006
#                    IF g_axf.axf14 = 'Y' THEN             
#                        LET l_sql = l_sql CLIPPED,
#                            "    AND axg02 = '",g_axa02_axf10,"'" #FUN-A90006
#                    ELSE                                 
#                        LET l_sql = l_sql CLIPPED,      
#                            "    AND axg02 = '",g_axf.axf10,"'" 
#                    END IF                                      
#                END IF                
#            END IF
#        ELSE
#            LET l_sql = l_sql CLIPPED,
#            "    AND axg02 = '",g_axa02_axf10,"'"                 #FUN-A90006
#        END IF
#    ELSE                             #axf17 = '2' -->axk_file        
#        LET l_sql = l_sql CLIPPED,       
#        "  UNION ",
#        " SELECT 'B','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ",  #FUN-A90026 mod
#        "        axk14,'",g_axz08,"','1','N',axk07 ",                  
#        "   FROM axk_file ",
#        "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#        "    AND axk00 ='",g_aaz641_axf10,"' ",   
#        "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
#        "    AND axk041='",g_axf10_axz05,"' ",    #對沖帳別  
#        "    AND axk08 = ",tm.yy,
#        "    AND axk07 = '",g_axz08,"'",         
#        "    AND axk09 = '",tm.em,"'"
#        CASE 
#          WHEN p_axf02 = 'MISC' 
#            LET l_sql = l_sql CLIPPED,
#            "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
#            "                   WHERE axt00 = '",g_aaz641_axf09,"'",   
#            "                     AND axt01 = '",g_axf.axf02,"'",
#            "                     AND axt09 = '",g_axf.axf09,"'",
#            "                     AND axt10 = '",g_axf.axf10,"'",
#            "                     AND axt12 = '",g_aaz641_axf10,"'",  
#            "                     AND axt13 = '",g_axf.axf13,"'",
#            "                     AND axt04 != 'Y') "    #是否依據公式設定
#          WHEN p_axf02 != 'MISC' 
#            LET l_sql = l_sql CLIPPED,
#            "    AND axk05 = '",g_axf.axf02,"'"   
#        END CASE
#        #A.來源公司=合併主體：(順流)
#        #  目的:axg02 = 不用加入此條件, axg04 = 自己
#        #B.來源公司 <> 合併主體：(側流或逆流)
#        #  IF 目的屬於上層公司
#        #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
#        #    2.中間層(有上層也有下層):
#        #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
#        #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
#        #  ELSE
#        #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
#        #  END IF
#        IF g_cnt_axf10 > 0 THEN
#            IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                LET l_sql = l_sql CLIPPED,
#                    "    AND axk02 = '",g_axf.axf10,"'"
#            ELSE
#                IF g_up_axf10 > 0 THEN         #FUN-A90006
#                    IF g_axf.axf14 = 'Y' THEN 
#                        LET l_sql = l_sql CLIPPED,
#                            "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                    ELSE                   
#                        LET l_sql = l_sql CLIPPED,                
#                            "    AND axk02 = '",g_axf.axf10,"'"  
#                    END IF                                      
#                END IF   
#            END IF
#        ELSE
#            LET l_sql = l_sql CLIPPED,
#               "    AND axk02 = '",g_axa02_axf10,"'"                #FUN-A90006
#        END IF
#    END IF
#    PREPARE p001_axg_misc_p1 FROM l_sql
#    IF STATUS THEN 
#       LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                  
#       CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
#       LET g_success = 'N'  
#    END IF 
#    DECLARE p001_axg_misc_c1 CURSOR FOR p001_axg_misc_p1
#    
#    FOREACH p001_axg_misc_c1 INTO g_type,g_flag,g_axg.axg06,g_axg.axg07,g_axg.axg05,  #FUN-A90026 g_type:A.來源/B.目的 g_flag:1.aej/2.aek
#                             g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                             g_axg.axg12,   #FUN-A30079 
#                             g_affil,g_dc,g_flag_r,g_axk07
#      IF SQLCA.sqlcode THEN 
#         LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
#         CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_axg_misc_1',SQLCA.sqlcode,1) 
#         LET g_success = 'N' 
#         CONTINUE FOREACH  
#      END IF
#  
#      IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

#      #---FUN-A90026 start--寫入temp table之前先判斷幣別是否同於合併主體
#      #不相同時如果為損益類科目且axa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
#      SELECT axz06 INTO l_axz06_axf16 
#        FROM axz_file
#       WHERE axz01 = g_axf.axf16   #合併主體幣別
#      IF g_axg.axg12 != l_axz06_axf16 THEN 
#          SELECT aag04 INTO l_aag04
#           FROM aag_file
#           WHERE aag00=g_aaz641
#             AND aag01=g_axg.axg05
#          #依科目性質來判斷取"現時"或"平均"匯率
#          IF l_aag04 = '1' THEN   
#              CALL p001_getrate('1',tm.yy,tm.em,
#                                g_axg.axg12,l_axz06_axf16)  
#              RETURNING l_rate
#              LET g_axg.axg08 = g_axg.axg08  * l_rate   #TQC-AA0098
#          ELSE 
#              IF g_axa05 <> '1' THEN    #FUN-AB0004
#              #--FUN-AA0093 start--
#                  CALL p001_getrate('3',tm.yy,tm.em,
#                                    g_axg.axg12,l_axz06_axf16)
#                  RETURNING l_rate
#                  IF cl_null(l_rate) THEN LET l_rate = 1 END IF   #101023
#                  LET g_axg.axg08 = g_axg.axg08  * l_rate  #101016
#              ELSE
#              #--FUN-AA0093 end--
#                  #-MOD-AC0388 add-start-
#                  IF g_type = 'A' THEN
#                      IF g_cnt_axf09 > 0 THEN
#                          CALL p001_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
#                      ELSE
#                          #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
#                          #來源或目的/aej_file or aek_file/合併主體幣別
#                          CALL p001_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
#                      END IF   #FUN-AB0004
#                  ELSE
#                  #--MOD-AC0388 add-end---
#                      #--FUN-AB0004 start-- 
#                      IF g_cnt_axf10 > 0 THEN    #大於0代表不是最下層,資料來源->axkk_file or axh_file  
#                          CALL p001_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
#                      ELSE
#                      #--FUN-AB0004 end---
#                          #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
#                          #來源或目的/aej_file or aek_file/合併主體幣別
#                          CALL p001_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
#                      END IF   #FUN-AB0004
#                  END IF   #MOD-AC0388 add
#              END IF   #FUN-AA0093
#          END IF
#      END IF
#      #---FUN-A90026 end----

#      #先將資料寫進TempTable裡 
#      EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axg.axg05,
#                                g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                g_axg.axg12,            #FUN-A30079 
#                                g_affil,g_dc,g_flag_r
#    END FOREACH
#---FUN-A80137 end------------------------------------
#-------FUN-B90069 mark end-------------------------------------

     IF p_axf02 = 'MISC' THEN
         #IF p_axf15 = '1' THEN
         IF p_axf17 = '1' THEN     #FUN-A80137 mod
             #貸 子公司 少數股權,少數股權淨利
             #依據公式設定(對沖科目中axt04=Y)
             DECLARE p001_axt_cs CURSOR FOR
               #SELECT DISTINCT axt03,axt04,axt05 FROM axt_file  #CHI-D40021 mark
                SELECT DISTINCT axt03 FROM axt_file              #CHI-D40021
                 #WHERE axt00 = g_aaz641   #FUN-920067 mod
                 WHERE axt00 = g_aaz641_axf09 #FUN-A30079
                   AND axt01 = g_axf.axf02
                   AND axt09 = g_axf.axf09
                   AND axt10 = g_axf.axf10
                   #AND axt12 = g_aaz641    #FUN-920067
                   AND axt12 =  g_aaz641_axf10 #FUN-A30079
                   AND axt04 = 'Y'             #是否依據公式設定]
                   AND axt13 = g_axf.axf13 #FUN-930117
             FOREACH p001_axt_cs INTO g_axu03
                 #--FUN-B90069 start---
                 CALL p001_axf02_axg_2(g_axu03,i) RETURNING l_sql
                 #--FUN-B90069 end-----
#---FUN-B90069 mark start------移到p001_axf02_axg_2()----------------------
#                     LET l_sql =
#                     " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",     #MOD-910248  #FUN-930144 mod
#                     "        axg12,'",g_axz08_axf10,"','2','Y' "                 #FUN-A90006
#                  LET l_sql = l_sql CLIPPED,
#                  #---FUN-A30079 end---
#                  "   FROM axg_file ",
#                  "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#                  "    AND axg00 ='",g_aaz641_axf10,"' ",   #FUN-A30079
#                  "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
#                  "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別   #FUN-A90006
#                  "    AND axg06 = ",tm.yy,
#                  "    AND axg07 = '",tm.em,"'"          #FUN-970046 add
##--FUN-A60078 start--
#                      IF g_cnt_axf10 > 0 THEN
#                          IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                              LET l_sql = l_sql CLIPPED,
#                                  "    AND axg02 = '",g_axf.axf10,"'"
#                          ELSE
#                              IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                  LET l_sql = l_sql CLIPPED,
#                                      "    AND axg02 = '",g_axa02_axf10,"'"    #FUN-A90006
#                              END IF
#                         END IF
#                      #--FUN-A70011 start--
#                      ELSE
#                          LET l_sql = l_sql CLIPPED,
#                          "    AND axg02 = '",g_axa02_axf10,"'"     #FUN-A90006
#                      END IF
#                      #--FUN-A70011 end--
##---FUN-A60078 end--
#                  LET l_sql = l_sql CLIPPED,
#                  #--FUN-A30079 end----
#                     "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                    #"                   WHERE axu00 = '",g_aaz641,"'",    #FUN-920067
#                     "                   WHERE axu00 = '",g_aaz641_axf09,"'",  #FUN-A30079
#                     "                     AND axu01 = '",g_axf.axf02,"'",
#                     "                     AND axu09 = '",g_axf.axf09,"'",
#                     "                     AND axu10 = '",g_axf.axf10,"'",
#                    #"                     AND axu12 = '",g_aaz641,"'",     #FUN-920067
#                     "                     AND axu12 = '",g_aaz641_axf10,"'",  #FUN-A30079
#                     "                     AND axu13 = '",g_axf.axf13,"'",　#FUN-930117
#                     "                     AND axu05 = '+'",
#                     "                     AND axu03 = '",g_axu03,"')"
#                  LET l_sql = l_sql CLIPPED,
#                          "  UNION ",
#                         #" SELECT axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,",  #FUN-BA0006 mark #FUN-930144 mod
#                          " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,",  #FUN-BA0006 #FUN-930144 mod
#                         #"        '",g_axz06_axf10,"','",g_axz08_axf10,"','2','Y' "  #FUN-A90006 mark
#                          "        axg12,'",g_axz08_axf10,"','2','Y' "                #FUN-A90006
#                  LET l_sql = l_sql CLIPPED,    
#                          "   FROM axg_file ",
#                          "  WHERE axg01 ='",g_axa[i].axa01,"' ",
#                          "    AND axg00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                          "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
#                          "    AND axg041='",g_axf10_axz05,"' ",   #對沖帳別   #FUN-A90006
#                          "    AND axg06 = ",tm.yy,
#                          "    AND axg07 = '",tm.em,"'",           #FUN-970046 add
#                          "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                          "                   WHERE axu00 = '",g_aaz641_axf09,"'",   #FUN-A30079
#                          "                     AND axu01 = '",g_axf.axf02,"'",
#                          "                     AND axu09 = '",g_axf.axf09,"'",
#                          "                     AND axu10 = '",g_axf.axf10,"'",
#                          "                     AND axu12 = '",g_aaz641_axf10,"'",   #FUN-A30079
#                          "                     AND axu13 = '",g_axf.axf13,"'",
#                          "                     AND axu05 = '-'",
#                          "                     AND axu03 = '",g_axu03,"')"
#                      IF g_cnt_axf10 > 0 THEN
#                          IF g_low_axf10 = 0 THEN #最上層    #FUN-A90006
#                              LET l_sql = l_sql CLIPPED,
#                                  "    AND axg02 = '",g_axf.axf10,"'" ,
#                                  "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                          ELSE
#                              IF g_up_axf10 > 0 THEN         #10027
#                                  LET l_sql = l_sql CLIPPED,
#                                      "    AND axg02 = '",g_axa02_axf10,"'",   #FUN-A90006
#                                      "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                              END IF
#                         END IF
#                      #--FUN-A70011 start--
#                      ELSE
#                          LET l_sql = l_sql CLIPPED,
#                          "    AND axg02 = '",g_axa02_axf10,"'",       #FUN-A90006
#                          "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
#                      #--FUN-A70011 end--
#                      END IF
##--FUN-B90069 mark end-----移到p001_axf02_axg_2()----------------

                   PREPARE p001_misc_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_c2 CURSOR FOR p001_misc_p2
      
                   FOREACH p001_misc_c2 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                             g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                             g_axg.axg12,   #FUN-A30079 
                                             g_affil,g_dc,g_flag_r
                      IF SQLCA.sqlcode THEN 
                         LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
                         CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_misc_c2',SQLCA.sqlcode,1)   #NO.FUN-710023
                         LET g_success = 'N' 
                         CONTINUE FOREACH  
                      END IF
 
                      IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
 
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
                                                g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                                g_axg.axg12,   #FUN-A30079 
                                                g_affil,g_dc,g_flag_r
                   END FOREACH
                   #----------------FUN-B70065 start-------------
                   #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                   #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                   LET l_sql =
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '1' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaz641,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 = 'Y' ",
                   "    AND axi08 = '2' ",
                   "    AND axj03 = '",g_aaz87,"'", 
                   "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaz641_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '+'",
                   "                     AND axu03 = '",g_axu03,"')",
                   "  UNION ",
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '1' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",tm.axa02,"'",
                   "    AND axi00 ='",g_aaz641,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 = '",g_aaz87,"'", 
                   "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaz641_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"

                   PREPARE p001_misc_aaz87_p1 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c1 CURSOR FOR p001_misc_aaz87_p1
                   OPEN p001_misc_aaz87_c1
                   FETCH p001_misc_aaz87_c1 INTO l_axj07_d
                   IF cl_null(l_axj07_d) THEN LET l_axj07_d = 0 END IF

                   LET l_sql =
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '2' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaz641,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 ='",g_aaz87,"'", 
                   "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaz641_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '+'",
                   "                     AND axu03 = '",g_axu03,"')",
                   "  UNION ",
                   " SELECT SUM(axj07) FROM axi_file,axj_file ",
                   "  WHERE axi01=axj01 ",
                   "    AND axi03 = '",tm.yy,"'",
                   "    AND axi04 = '",tm.em,"'",
                   "    AND axj06 = '2' ",
                   "    AND axi05 ='",g_axa[i].axa01,"' ", 
                   "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                   "    AND axi00 ='",g_aaz641,"'",
                   "    AND axi00 =axj00 ",
                   "    AND axiconf ='Y' ",
                   "    AND axi09 ='Y' ",
                   "    AND axi08 ='2' ",
                   "    AND axj03 ='",g_aaz87,"'", 
                   "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                   "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                   "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                   "                     AND axu01 = '",g_axf.axf02,"'",
                   "                     AND axu09 = '",g_axf.axf09,"'",
                   "                     AND axu10 = '",g_axf.axf10,"'",
                   "                     AND axu12 = '",g_aaz641_axf10,"'",
                   "                     AND axu13 = '",g_axf.axf13,"'",
                   "                     AND axu05 = '-'",
                   "                     AND axu03 = '",g_axu03,"')"
                   PREPARE p001_misc_aaz87_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c2 CURSOR FOR p001_misc_aaz87_p2
                   OPEN p001_misc_aaz87_c2
                   FETCH p001_misc_aaz87_c2 INTO l_axj07_c
                   IF cl_null(l_axj07_c) THEN LET l_axj07_c = 0 END IF

                   LET l_axj07 = l_axj07_d - l_axj07_c

                   IF l_axj07 <> 0 THEN
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING tm.yy,tm.em,g_axu03,  
                                                g_axf.axf16,g_axz08_axf10,l_axj07,
                                                x_aaa03,
                                                g_axz08_axf10,'2','Y'
                   END IF
                   #---FUN-B70065 end-----------------------
              END FOREACH  
#---TQC-D30026 mark start---
#            # -- FUN-A90036 start--
#            IF g_axf.axf14 = 'Y' THEN 
#                #--TQC-AA098 start-換匯差額的累換數是否加入沖銷分錄需依對沖設定
#                DECLARE p001_axt_cs2 CURSOR FOR
#                   SELECT DISTINCT axt03 FROM axt_file
#                    WHERE axt00 = g_aaz641_axf09
#                      AND axt01 = g_axf.axf02
#                      AND axt09 = g_axf.axf09
#                      AND axt10 = g_axf.axf10
#                      AND axt12 = g_aaz641_axf10
#                      AND axt13 = g_axf.axf13
#                FOREACH p001_axt_cs2 INTO l_axt03
#                    #---TQC-AA0098 end--
#                    DECLARE p001_adj_cs CURSOR FOR
#                     SELECT axj03,axj05,axj06,(axj07-axj071) FROM p001_adj_tmp    #TQC-AA0098
#                          WHERE axj05 = g_axz08_axf10   #TQC-AA0098 mod
#                            AND axj03 = l_axt03         #TQC-AA0098 add

#                     FOREACH p001_adj_cs INTO l_axj03,l_axj05,l_axj06,g_axg.axg08   #TQC-AA0098

#                       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

#                       LET g_affil  = l_axj05    #TQC-AA0098
#                       LET g_flag_r = 'N'
#                           #--TQC-AA0098 start-借貸需與換匯差額的累換相反加入對沖分錄 
#                           IF g_axg.axg08 < 0 THEN
#                               IF l_axj06 = '1' THEN LET g_dc = '1' ELSE LET g_dc = '2' END IF
#                           ELSE
#                               IF l_axj06 = '1' THEN LET g_dc = '2' ELSE LET g_dc = '1' END IF
#                           END IF
#                           #-TQC-AA0098 end--
#                       #先將資料進TempTable
#                       EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,l_axj03,
#                                                 g_axg.axg02,g_axg.axg04,g_axg.axg08,
#                                                 g_axg.axg12,
#                                                 g_affil,g_dc,g_flag_r
#                     END FOREACH
#                 END FOREACH   #TQC-AA0098 
#             END IF                 
#            # --FUN-A90036 end --  取出換匯差額的累換數值 ---
#----TQC-D30026 mark end--------------------------------------
          ELSE
              #貸 子公司 少數股權,少數股權淨利
              #依據公式設定(對沖科目中axt04=Y)
              DECLARE p001_axt_cs1 CURSOR FOR
                #SELECT DISTINCT axt03,axt04,axt05 FROM axt_file   #CHI-D40021 mark
                 SELECT DISTINCT axt03 FROM axt_file               #CHI-D40021 
                  WHERE axt00 = g_aaz641_axf09 #FUN-A30079
                    AND axt01 = g_axf.axf02
                    AND axt09 = g_axf.axf09
                    AND axt10 = g_axf.axf10
                    AND axt12 = g_aaz641_axf10  #FUN-A30079
                    AND axt04 = 'Y'             #是否依據公式設定]
                    AND axt13 = g_axf.axf13 #FUN-930117
              FOREACH p001_axt_cs1 INTO g_axu03
                  #--FUN-B90069 start---
                  CALL p001_axf02_axk(g_axu03,i) RETURNING l_sql
                  #--FUN-B90069 end-----

#---FUN-B90069 mark start---移到p001_axf02_axk()內處理----------------
#                      LET l_sql =
#                      " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11),",  
#                      "        axk14,'",g_axf.axf10,"','2','Y' "          #FUN-A60038 mod
#                  LET l_sql = l_sql CLIPPED,
#                  "   FROM axk_file ",
#                  "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#                  "    AND axk00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                  "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
#                  "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    #FUN-A90006
#                  "    AND axk07 = '",g_axz08,"'",       #FUN-960096  #FUN-A90006
#                  "    AND axk08 = ",tm.yy,
#                  "    AND axk09 = '",tm.em,"'"     #FUN-970046 add
#                      IF g_cnt_axf10 > 0 THEN
#                          IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                              LET l_sql = l_sql CLIPPED,
#                                  "    AND axk02 = '",g_axf.axf10,"'"
#                          ELSE
#                              IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                  LET l_sql = l_sql CLIPPED,
#                                      "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                              END IF
#                          END IF
#                      ELSE
#                          LET l_sql = l_sql CLIPPED,
#                          "    AND axk02 = '",g_axa02_axf10,"'"               #FUN-A90006
#                      END IF
#                  LET l_sql = l_sql CLIPPED,
#                  #--FUN-A30079 end----       
#                  "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                  "                   WHERE axu00 = '",g_aaz641_axf09,"'",    #FUN-A30079
#                  "                     AND axu01 = '",g_axf.axf02,"'",
#                  "                     AND axu09 = '",g_axf.axf09,"'",
#                  "                     AND axu10 = '",g_axf.axf10,"'",
#                  "                     AND axu12 = '",g_aaz641_axf10,"'",    #FUN-A30079
#                  "                     AND axu13 = '",g_axf.axf13,"'",　
#                  "                     AND axu05 = '+'",
#                  "                     AND axu03 = '",g_axu03,"')"
#                      LET l_sql = l_sql CLIPPED,                         #FUN-A30079
#                      "  UNION ",
#                     #" SELECT axk08,axk09,axk05,axk02,axk04,(axk08-axk09)*-1,",       #FUN-BA0006 Mark
#                      " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,",       #FUN-BA0006
#                      "        axk14,'",g_axz08_axf10,"','2','Y' "   #FUN-A90006
#                  LET l_sql = l_sql CLIPPED,    
#                  #---FUN-A30079 end---
#                  "   FROM axk_file ",
#                  "  WHERE axk01 ='",g_axa[i].axa01,"' ",
#                  "    AND axk00 ='",g_aaz641_axf10,"' ",  #FUN-A30079
#                  "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
#                  "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    #FUN-A90006
#                  "    AND axk08 = ",tm.yy,
#                  "    AND axk07 = '",g_axz08,"'",  #FUN-960096       #FUN-A90006
#                  "    AND axk09 = '",tm.em,"'",    #FUN-970046 add
#                  "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
#                  "                   WHERE axu00 = '",g_aaz641_axf09,"'",   #FUN-A30079
#                  "                     AND axu01 = '",g_axf.axf02,"'",
#                  "                     AND axu09 = '",g_axf.axf09,"'",
#                  "                     AND axu10 = '",g_axf.axf10,"'",
#                  "                     AND axu12 = '",g_aaz641_axf10,"'",   #FUN-A30079
#                  "                     AND axu13 = '",g_axf.axf13,"'",
#                  "                     AND axu05 = '-'",
#                  "                     AND axu03 = '",g_axu03,"')"
#                      IF g_cnt_axf10 > 0 THEN
#                          IF g_low_axf10 = 0 THEN #最上層   #FUN-A90006
#                              LET l_sql = l_sql CLIPPED,
#                                  "    AND axk02 = '",g_axf.axf10,"'" ,
#                                  "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
#                          ELSE
#                              IF g_up_axf10 > 0 THEN        #FUN-A90006
#                                  LET l_sql = l_sql CLIPPED,
#                                      "    AND axk02 = '",g_axa02_axf10,"'",   #FUN-A90006
#                                      "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
#                              END IF
#                          END IF
#                      #--FUN-A70011 start--
#                      ELSE
#                          LET l_sql = l_sql CLIPPED,
#                          "    AND axk02 = '",g_axa02_axf10,"'"   #FUN-A90006
#                      #--FUN-A70011 end--
#                      END IF
#---FUN-B90069 mark end----移到p001_axf02_axk()內處理----------------

                  PREPARE p001_misc_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_c3 CURSOR FOR p001_misc_p3   #FUN-A80130
     
                  FOREACH p001_misc_c3 INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                            g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                            g_axg.axg12,   #FUN-A30079 
                                            g_affil,g_dc,g_flag_r
                     IF SQLCA.sqlcode THEN 
                        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
                        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_misc_c3',SQLCA.sqlcode,1)   #NO.FUN-710023
                        LET g_success = 'N' 
                        CONTINUE FOREACH  
                     END IF

                     IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
                                               g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                               g_axg.axg12,   #FUN-A30079
                                               g_affil,g_dc,g_flag_r
                  END FOREACH
                  #----------------FUN-B70065 start-------------
                  #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                  #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                  LET l_sql =
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '1' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaz641,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 = 'Y' ",
                  "    AND axi08 = '2' ",
                  "    AND axj03 = '",g_aaz87,"'", 
                  "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaz641_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '+'",
                  "                     AND axu03 = '",g_axu03,"')",
                  "  UNION ",
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '1' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",tm.axa02,"'",
                  "    AND axi00 ='",g_aaz641,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 = '",g_aaz87,"'", 
                  "    AND axj05 = '",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaz641_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '-'",
                  "                     AND axu03 = '",g_axu03,"')"

                  PREPARE p001_misc_aaz87_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c3 CURSOR FOR p001_misc_aaz87_p3
                  OPEN p001_misc_aaz87_c3
                  FETCH p001_misc_aaz87_c3 INTO l_axj07_d
                  IF cl_null(l_axj07_d) THEN LET l_axj07_d = 0 END IF

                  LET l_sql =
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '2' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaz641,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 ='",g_aaz87,"'", 
                  "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaz641_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '+'",
                  "                     AND axu03 = '",g_axu03,"')",
                  "  UNION ",
                  " SELECT SUM(axj07) FROM axi_file,axj_file ",
                  "  WHERE axi01=axj01 ",
                  "    AND axi03 = '",tm.yy,"'",
                  "    AND axi04 = '",tm.em,"'",
                  "    AND axj06 = '2' ",
                  "    AND axi05 ='",g_axa[i].axa01,"' ", 
                  "    AND axi06 ='",g_axf.axf16,"'",     #合併主體
                  "    AND axi00 ='",g_aaz641,"'",
                  "    AND axi00 =axj00 ",
                  "    AND axiconf ='Y' ",
                  "    AND axi09 ='Y' ",
                  "    AND axi08 ='2' ",
                  "    AND axj03 ='",g_aaz87,"'", 
                  "    AND axj05 ='",g_axz08_axf10,"'",     #關係人
                  "    AND axj03 IN (SELECT DISTINCT axu04 FROM axu_file ",
                  "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                  "                     AND axu01 = '",g_axf.axf02,"'",
                  "                     AND axu09 = '",g_axf.axf09,"'",
                  "                     AND axu10 = '",g_axf.axf10,"'",
                  "                     AND axu12 = '",g_aaz641_axf10,"'",
                  "                     AND axu13 = '",g_axf.axf13,"'",
                  "                     AND axu05 = '-'",
                  "                     AND axu03 = '",g_axu03,"')"
                  PREPARE p001_misc_aaz87_p4 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c4 CURSOR FOR p001_misc_aaz87_p4
                  OPEN p001_misc_aaz87_c4
                  FETCH p001_misc_aaz87_c4 INTO l_axj07_c
                  IF cl_null(l_axj07_c) THEN LET l_axj07_c = 0 END IF

                  LET l_axj07 = l_axj07_d - l_axj07_c

                  IF l_axj07 <> 0 THEN
                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING tm.yy,tm.em,g_axu03,  
                                               g_axf.axf16,g_axz08_axf10,l_axj07,
                                               x_aaa03,
                                               g_axz08_axf10,'2','Y'
                  END IF
                  #---FUN-B70065 end-----------------------
             END FOREACH 
         END IF          
     END IF    

     DECLARE p001_tmp_cs CURSOR FOR
        SELECT axg06,axg07,axg05,axg02,axg04,SUM(axg08),axg12,affil,dc,flag_r   #FUN-A30079
          FROM p001_tmp
         GROUP BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r  #FUN-A30079
         ORDER BY axg06,axg07,axg05,axg02,axg04,axg12,affil,dc,flag_r  #FUN-A30079
                 #年    月
     LET g_axg07_o = '' 
     FOREACH p001_tmp_cs INTO g_axg.axg06,g_axg.axg07,g_axg.axg05,
                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
                              g_axg.axg12,   #FUN-A30079
                              g_affil,g_dc,g_flag_r
        IF SQLCA.sqlcode THEN 
           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                                    #NO.FUN-710023
           CALL s_errmsg('axk01,axk04,axk041,axk08',g_showmsg,'p001_tmp_cs',SQLCA.sqlcode,1)   #NO.FUN-710023
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF

        CALL s_ymtodate(g_axg.axg06,g_axg.axg07,g_axg.axg06,g_axg.axg07)
               RETURNING g_bdate,g_edate

        IF NOT cl_null(g_axg07_o) AND g_axg07_o<>g_axg.axg07 AND 
           NOT cl_null(g_axi.axi01) THEN
           CALL p001_ins_axj2()   #寫入差異分錄
           IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF   #FUN-770069 add
        END IF

        #--a抓持股比率
        CALL get_rate()  
        LET l_aac01 = tm.gl,'%'       #MOD-C30082 add        
        LET l_cnt = 0
        
        SELECT COUNT(*) INTO l_cnt FROM axi_file  #判斷是否已存在單頭
         WHERE axi00 = g_aaz641      #帳別   #FUN-920067
           AND axi02 = g_edate       #單據日期
           AND axi03 = g_axg.axg06   #調整年度
           AND axi04 = g_axg.axg07   #調整月份
           AND axi05 = tm.axa01      #族群編號
          #AND axi06 = tm.axa02      #上層公司編號
           AND axi06 = g_axf.axf16   #合併主體公司編號  #FUN-A30079
           AND axi07 = tm.axa03      #上層帳別
           AND axi08 = '2'           #資料來源-2.資料匯入   #FUN-770069 add
           AND axi21 = tm.ver        #MOD-930210 add
           AND axi081 = '1'          #FUN-A90036
           AND axi09 = 'N'           #FUN-A90036
           AND axi01 LIKE l_aac01    #MOD-C30082 add
 
        IF l_cnt = 0 THEN     #沒有符合的資料才要新增
           LET g_yy=g_axg.axg06 
           LET g_mm=g_axg.axg07 
           CALL p001_ins_axi() 
        ELSE                  #取出單頭資料以供後續寫入axj時用
           SELECT * INTO g_axi.* FROM axi_file
            WHERE axi00 = g_aaz641   #FUN-920067
              AND axi02 = g_edate
              AND axi03 = g_axg.axg06
              AND axi04 = g_axg.axg07
              AND axi05 = tm.axa01
             #AND axi06 = tm.axa02
              AND axi06 = g_axf.axf16   #FUN-A30079
              AND axi07 = tm.axa03
              AND axi08 = '2'           #FUN-770069 add
              AND axi081 = '1'          #FUN-A90036
              AND axi21 = tm.ver        #MOD-930210 add
              AND axi09 = 'N'           #FUN-A90036 
              AND axi01 LIKE l_aac01    #TQC-C40126
        END IF
        
        #-->寫入調整與銷除分錄底稿單身
        IF NOT cl_null(g_axi.axi01) THEN    #當單頭檔(axi_file)的傳票號碼(axi01)有值石才需計算差異
          #CALL p001_ins_axj1()    #FUN-C50084 mark
           CALL p001_ins_axj1(i)   #FUN-C50084
        END IF
        IF g_success = 'N' THEN RETURN  END IF
        LET g_axg07_o=g_axg.axg07   #期別舊值備份
     END FOREACH

     #當單頭檔(axi_file)的傳票號碼(axi01)有值時才需計算差異
     IF NOT cl_null(g_axi.axi01) THEN    
        CALL p001_ins_axj2()   #寫入差異分錄
     END IF
     IF NOT cl_null(g_axi.axi01) THEN CALL upd_axi() END IF
     LET p_axf01 = ''
     LET p_axf02 = ''
END FUNCTION

FUNCTION p001_chkaah(p_aah01,p_aah03,p_aah04,p_axb05,p_axz03)  #FUN-A50102 add axz03
#FUNCTION p001_chkaah(p_aah01,p_aah03,p_aah04,p_axb05)
DEFINE p_aah01    LIKE aah_file.aah01
DEFINE p_aah03    LIKE aah_file.aah03
DEFINE p_aah04    LIKE aah_file.aah04
DEFINE p_axb05    LIKE axb_file.axb05
DEFINE l_aah04    LIKE aah_file.aah04
DEFINE l_abb06    LIKE abb_file.abb06
DEFINE l_abb07    LIKE abb_file.abb07
DEFINE l_abb07_1  LIKE abb_file.abb07
DEFINE l_sql      STRING
DEFINE p_axz03    LIKE axz_file.axz03  #FUN-A50102

  LET l_abb07_1 = 0

  LET l_sql=" SELECT abb06,abb07 ",
            #"   FROM ",g_dbs_gl,"aba_file,",g_dbs_gl,"abb_file ",             
            "   FROM ",cl_get_target_table(p_axz03,'aba_file'),",",   #FUN-A50102
            "        ",cl_get_target_table(p_axz03,'abb_file'),       #FUN-A50102
            "  WHERE aba00 = abb00 ",
            "    AND aba01 = abb01 ",
            "    AND aba00 = '",p_axb05,"' ",            
            "    AND aba03 = '",tm.yy,"' ",
            "    AND aba04 = '",p_aah03,"' ",
            "    AND aba06 = 'CE' ",
            "    AND abb03 = '",p_aah01,"' "

  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  CALL cl_parse_qry_sql(l_sql,p_axz03) RETURNING l_sql   #FUN-A50102
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
   #SELECT axr15,axr12             #CHI-B90065 mark
    SELECT AVG(axr15),AVG(axr12)   #CHI-B90065
    INTO l_rate,l_rate1  
     FROM axr_file
    WHERE axr01= g_dept[p_i].axa01
      AND axr02= g_dept[p_i].axb04
     # AND axr07= p_aag01#TQC-C50094 mark
      AND axr03= p_axe06
      AND axr06<=p_date
  #---FUN-A70086 end-----
    IF cl_null(l_rate) THEN LET l_rate = 1 END IF  #TQC-AA0098
    IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF   #TQC-AA0098
    RETURN l_fun_dr,l_fun_cr,l_chg_dr,l_chg_cr  #FUN-A70086
END FUNCTION

#--依匯率計算下層公司功能幣---------
#FUNCTION p001_fun_amt(p_aag04,p_dr,p_cr,p_axe11,p_axz06,p_axz07,p_yy,p_mm)           #FUN-B70064 mark
FUNCTION p001_fun_amt(p_aag04,p_dr,p_cr,p_axe11,p_axz06,p_axz07,p_yy,p_mm,p_axa05)    #FUN-B70064 add
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
DEFINE p_axa05    LIKE axa_file.axa05    #FUN-B70064 add

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
        IF p_axe11 <> '3' THEN    #FUN-AC0051
           CALL p001_getrate(p_axe11,l_bs_yy,l_bs_mm,
                             p_axz06,p_axz07)
           RETURNING l_rate
           IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
#---FUN-B70064 start
        ELSE
        	 #---CHI-C40012 mark---
           #IF p_axa05 != '3' THEN  #CHI-C40012 mark
           #CALL p001_getrate1(p_aag04,p_axz06,p_axz07)
           #RETURNING l_rate
           #ELSE
           #    CALL p001_getrate3(p_axe11,l_bs_yy,l_bs_mm,
           #                       p_axz06,p_axz07)
           #    RETURNING l_rate
           #--CHI-C40012 mark----
           
           #--CHI-C40012 start ---
           CASE 
               WHEN p_axa05 = '1' 
                   CALL p001_getrate(p_axe11,l_bs_yy,l_bs_mm,
                                     p_axz06,p_axz07)
                   RETURNING l_rate
               WHEN p_axa05 = '2'
                   CALL p001_getrate1(p_aag04,p_axz06,p_axz07)
                   RETURNING l_rate
               WHEN p_axa05 = '3'
                   CALL p001_getrate3(p_axe11,l_bs_yy,l_bs_mm,
                                      p_axz06,p_axz07)
                   RETURNING l_rate
           END CASE
           #---CHI-C40012 end---
               IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
        END IF
     END IF
#FUN-AC0051 --End
#---FUN-B70064 end---
#    END IF  #CHI-C40012 mark

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
#FUNCTION p001_acc_amt(p_aag04,p_dr,p_cr,p_axe12,p_axz07,p_aaa03,p_yy,p_mm)     #FUN-B70064 MARK
FUNCTION p001_acc_amt(p_aag04,p_dr,p_cr,p_axe12,p_axz07,p_aaa03,p_yy,p_mm,p_axa05)      #FUN-B70064 ADD
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
DEFINE p_axa05    LIKE axa_file.axa05    #FUN-B70064 add 

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
        IF p_axe12 <> '3' THEN   #FUN-AC0051
           CALL p001_getrate(p_axe12,l_bs_yy,l_bs_mm,
                             p_axz07,p_aaa03)
           RETURNING l_rate1
           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF 
#FUN-AC0051 --Begin
        ELSE
        	 #---CHI-C40012 mark---
           #IF p_axa05 != '3' THEN  #FUN-B70064 add
           #CALL p001_getrate1(p_aag04,p_axz07,p_aaa03)
           #RETURNING l_rate1
           #ELSE
           #    CALL p001_getrate3(p_axe12,l_bs_yy,l_bs_mm,
           #                      p_axz07,p_aaa03)
           #    RETURNING l_rate1
           #---CHI-C40012 mark---
           
           #--CHI-C40012 start--
           CASE
               WHEN p_axa05 = '1'
                   CALL p001_getrate(p_axe12,l_bs_yy,l_bs_mm,
                                     p_axz07,p_aaa03)
                   RETURNING l_rate1
               WHEN p_axa05 = '2'
                   CALL p001_getrate1(p_aag04,p_axz07,p_aaa03)
                   RETURNING l_rate1
               WHEN p_axa05 = '3'
                   CALL p001_getrate3(p_axe12,l_bs_yy,l_bs_mm,
                                     p_axz07,p_aaa03)
                   RETURNING l_rate1
           END CASE
           #--CHI-C40012 end----
           
           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF 
        END IF
     END IF
#FUN-AC0051 --End
#---FUN-B70064 end---
#    END IF  #CHI-C40012 mark

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
FUNCTION p001_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i)
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
DEFINE l_avg_axg08  LIKE axg_file.axg08   #MOD-C40135
DEFINE l_avg_axg09  LIKE axg_file.axg09   #MOD-C40135
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
   "    AND aej06 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
   PREPARE p001_aej_p3 FROM l_sql
   DECLARE p001_aej_c3 CURSOR FOR p001_aej_p3
   FOREACH p001_aej_c3 INTO l_month,l_axg13,l_axg14
        IF l_month = 0 THEN LET l_month = 1 END IF
        #TQC-D30026 START--
        #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
        #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
        CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09   
        #TQC-D30026 END----
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
        #LET l_axg08 = l_axg13 * l_rate * l_rate1    #TQC-D30026 MARK
        #LET l_axg09 = l_axg14 * l_rate * l_rate1    #TQC-D30026 MARK
        LET l_axg08 = (l_axg13+l_avg_axg08) * l_rate * l_rate1      #TQC-D30026 ADD
        LET l_axg09 = (l_axg14+l_avg_axg09) * l_rate * l_rate1      #TQC-D30026 ADD
        LET l_sum_axg08 = l_sum_axg08  + l_axg08
        LET l_sum_axg09 = l_sum_axg09  + l_axg09
  END FOREACH
 #--TQC-D30026 mark start--
 #-----------------------------MOD-CC0216--------------------(S)
 #IF l_month <> tm.em THEN
 #   IF p_axz07 != x_aaa03 THEN 
 #     #合併幣別匯率
 #      CALL p001_getrate(p_axe12,p_yy,tm.em,p_axz07,x_aaa03)
 #           RETURNING l_rate1
 #   END IF
 #END IF
 #-----------------------------MOD-CC0216--------------------(E)
#--TQC-D30026 mark end---
 #MOD-C40135---str---
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09   #TQC-D30026 MARK
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
#--TQC-D30026 MARK START--
# LET l_avg_axg08 = l_avg_axg08 * l_rate * l_rate1
# LET l_avg_axg09 = l_avg_axg09 * l_rate * l_rate1
# LET l_sum_axg08 = l_sum_axg08 + l_avg_axg08
# LET l_sum_axg09 = l_sum_axg09 + l_avg_axg09
#--TQC-D30026 MARK END---
 #MOD-C40135---end---
  LET l_dr_sum = l_sum_axg08 
  LET l_cr_sum = l_sum_axg09 
  RETURN l_dr_sum,l_cr_sum
  #--FUN-A90026 end-----

END FUNCTION
#----FUN-A60038 end---------

#--FUN-A70053 start------------
#計算axg_file為來源功能幣別(採平均匯率者)
#FUNCTION p001_fun_avg(p_type,p_dbs,p_aah01,p_aah00,p_aag04,p_axz06,p_axz07,p_i,p_dr,p_cr)
FUNCTION p001_fun_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i)   #FUN-A90026 mod
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
DEFINE l_avg_axg15  LIKE axg_file.axg15    #MOD-C40135
DEFINE l_avg_axg16  LIKE axg_file.axg16    #MOD-C40135
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

  LET l_dr_sum = 0
  LET l_cr_sum = 0

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
       #TQC-D30026 START--
       #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
       #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
       CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16  
       #TQC-D30026 END--
       #LET l_axg15 = l_axg13 * l_rate   #TQC-D30026 MARK 
       #LET l_axg16 = l_axg14 * l_rate   #TQC-D30026 MARK
       LET l_axg15 = (l_axg13+l_avg_axg15) * l_rate    #TQC-D30026 MOD
       LET l_axg16 = (l_axg14+l_avg_axg16) * l_rate    #TQC-D30026 MOD
       LET l_sum_axg15 = l_sum_axg15  + l_axg15
       LET l_sum_axg16 = l_sum_axg16  + l_axg16
  END FOREACH
  #--FUN-A90026 end-----
#--TQC-D30026 MARK START--
 #-----------------------------MOD-CC0216--------------------(S)
 #IF l_month <> tm.em THEN
 #   IF p_axz07 != x_aaa03 THEN
 #     #合併幣別匯率
 #      CALL p001_getrate(p_axe11,p_yy,tm.em,p_axz06,p_axz07)
 #         RETURNING l_rate1
 #   END IF
 #END IF
 #-----------------------------MOD-CC0216--------------------(E)
#--TQC-D30026 MARK END---
#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
##MOD-C40135---str---
# CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16
# LET l_avg_axg15 = l_avg_axg15 * l_rate
# LET l_avg_axg16 = l_avg_axg16 * l_rate
# LET l_sum_axg15 = l_sum_axg15 + l_avg_axg15
# LET l_sum_axg16 = l_sum_axg16 + l_avg_axg16
##MOD-C40135---end--- 
#--TQC-D30026 MARK END----
  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  RETURN l_dr_sum,l_cr_sum     #FUN-A90026 mod
END FUNCTION
#--FUN-A70053 end-------------

#MOD-C40135---add---
FUNCTION p001_avg_adj(p_axj03,p_axj05,p_i)
   DEFINE l_sql        STRING
   DEFINE p_axj03      LIKE axj_file.axj03
   DEFINE p_axj05      LIKE axj_file.axj05
   DEFINE p_i          LIKE type_file.num5
   DEFINE l_axj06      LIKE axj_file.axj06
   DEFINE l_axj07      LIKE axj_file.axj07
   DEFINE l_axg15      LIKE axg_file.axg15
   DEFINE l_axg16      LIKE axg_file.axg16

   LET l_sql= " SELECT axj06,SUM(axj07) ",
              "   FROM axi_file,axj_file ",
              "  WHERE axi00 = axj00 ",
              "    AND axi01 = axj01 ",
              "    AND axi00 = '",g_aaz641,"'",
              "    AND axi03 = '",tm.yy,"'",
              "    AND axi04 = '",tm.em,"'",
              "    AND axi08 = '1'",
              "    AND axi05 = '",g_dept[p_i].axa01,"'",
              "    AND axi06 = '",g_dept[p_i].axb04,"'",
              "    AND axi09 = 'N'",
              "    AND axiconf = 'Y'",
              "    AND axj03 = '",p_axj03,"'"
  IF NOT cl_null(p_axj05) THEN
     LET l_sql = l_sql," AND axj05 = '",p_axj05,"'"
  END IF
  LET l_sql = l_sql,"  GROUP BY axj06 ",
                    "  ORDER BY axj06 "
   PREPARE p001_avg_p1 FROM l_sql
   IF STATUS THEN
      LET g_showmsg=tm.yy,"/",g_dept[p_i].axb05
      CALL s_errmsg('axj00,axj01',g_showmsg,'pre:axj_p1',STATUS,1)
      LET g_success = 'N'
   END IF
   LET l_axj07 = 0
   LET l_axg15 = 0
   LET l_axg16 = 0
   DECLARE p001_avg_c1 CURSOR FOR p001_avg_p1
   FOREACH p001_avg_c1 INTO l_axj06,l_axj07
      IF l_axj06 = '1' THEN #借
         LET l_axg15 = l_axg15 + l_axj07
      ELSE                  #貸
         LET l_axg16 = l_axg16 + l_axj07
      END IF
   END FOREACH
  RETURN l_axg15,l_axg16
END FUNCTION
#MOD-C40135---end---

#--FUN-A90006 start--
#計算axk_file為來源的合併幣別(採平均匯率者) 
#FUNCTION p001_axk_avg(p_type,p_dbs,p_aed01,p_aed02,p_aah00,p_aag04,p_axz06,p_axz07,p_i,p_dr,p_cr)
FUNCTION p001_axk_avg(p_axe11,p_axe12,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)   #FUN-A90026 mod
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
DEFINE l_avg_axk18  LIKE axk_file.axk18    #MOD-C40135
DEFINE l_avg_axk19  LIKE axk_file.axk19    #MOD-C40135
DEFINE l_axk20      LIKE axk_file.axk20    #FUN-A90026
DEFINE l_axk21      LIKE axk_file.axk21    #FUN-A90026
DEFINE p_axe12      LIKE axe_file.axe12    #FUN-A90026
DEFINE p_axe11      LIKE axe_file.axe11    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_sum_axk10  LIKE axk_file.axk10    #FUN-A90026
DEFINE l_sum_axk11  LIKE axk_file.axk11    #FUN-A90026
DEFINE l_max_month  LIKE type_file.num5    #FUN-A90026


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
       #--TQC-D30026 START---
       #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
       #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
       CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
       #--TQC-D30026 END---
       #LET l_axk20 = l_axk18 * l_rate * l_rate1   #TQC-D30026 MARK
       #LET l_axk21 = l_axk19 * l_rate * l_rate1   #TQC-D30026 MARK
       LET l_axk20 = (l_axk18+l_avg_axk18) * l_rate * l_rate1    #TQC-D30026 MOD
       LET l_axk21 = (l_axk19+l_avg_axk19) * l_rate * l_rate1    #TQC-D30026 MOD
       LET l_sum_axk10 = l_sum_axk10  + l_axk20
       LET l_sum_axk11 = l_sum_axk11  + l_axk21
  END FOREACH
#--TQC-D30026 MARK START--
# #-----------------------------MOD-CC0216--------------------(S)
#  IF l_month <> tm.em THEN
#     IF p_axz07 != x_aaa03 THEN
#       #合併幣別匯率
#        CALL p001_getrate(p_axe12,p_yy,tm.em,p_axz07,x_aaa03)
#             RETURNING l_rate1
#     END IF
#  END IF
# #-----------------------------MOD-CC0216--------------------(E)
#--TQC-D30026 MARK END---

#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
# #MOD-C40135---str---
#  CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
#  LET l_avg_axk18 = l_avg_axk18 * l_rate * l_rate1
#  LET l_avg_axk19 = l_avg_axk19 * l_rate * l_rate1
#  LET l_sum_axk10 = l_sum_axk10 + l_avg_axk18
#  LET l_sum_axk11 = l_sum_axk11 + l_avg_axk19
# #MOD-C40135---end---
#--TQC-D30026 MARK END---

  LET l_dr_sum = l_sum_axk10 
  LET l_cr_sum = l_sum_axk11
  #---FUN-A90026 end------------

  RETURN l_dr_sum,l_cr_sum
END FUNCTION
#FUN-A90006 end-------

#--FUN-A80130 start---
#計算axk_file為來源功能幣別(採平均匯率者)
FUNCTION p001_fun_axk_avg(p_axe11,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)
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
DEFINE l_avg_axk18  LIKE axk_file.axk18    #MOD-C40135
DEFINE l_avg_axk19  LIKE axk_file.axk19    #MOD-C40135
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
       #--TQC-D30026 START--
       #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
       #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
       CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
       #--TQC-D30026 END---
       #LET l_axk20 = l_axk18 * l_rate     #TQC-D30026 MARK
       #LET l_axk21 = l_axk19 * l_rate     #TQC-D30026 MARK
       LET l_axk20 = (l_axk18+l_avg_axk18) * l_rate    #TQC-D30026 MOD
       LET l_axk21 = (l_axk19+l_avg_axk19) * l_rate    #TQC-D30026 MOD

       LET l_sum_axk20 = l_sum_axk20  + l_axk20
       LET l_sum_axk21 = l_sum_axk21  + l_axk21
  END FOREACH

#---TQC-D30026 mark start--
# #-----------------------------MOD-CC0216--------------------(S)
#  IF l_month <> tm.em THEN
#     IF p_axz07 != x_aaa03 THEN
#       #合併幣別匯率
#        CALL p001_getrate(p_axe11,p_yy,tm.em,p_axz06,p_axz07)
#             RETURNING l_rate1
#     END IF
#  END IF
# #-----------------------------MOD-CC0216--------------------(E)
#--TQC-D30026 mark end---

#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
# #MOD-C40135---str---
#  CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
#  LET l_avg_axk18 = l_avg_axk18 * l_rate
#  LET l_avg_axk19 = l_avg_axk19 * l_rate
#  LET l_sum_axk20 = l_sum_axk20 + l_avg_axk18
#  LET l_sum_axk21 = l_sum_axk21 + l_avg_axk19
# #MOD-C40135---end---  
#--TQC-D30026 MARK END---
  LET l_dr_sum = l_sum_axk20
  LET l_cr_sum = l_sum_axk21
  
  RETURN l_dr_sum,l_cr_sum  
END FUNCTION 
#---FUN-A80130 end--------

#-MOD-C90148-add-
FUNCTION p001_fun_axj_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg15      LIKE axg_file.axg15
DEFINE l_axg16      LIKE axg_file.axg16
DEFINE l_avg_axg15  LIKE axg_file.axg15    
DEFINE l_avg_axg16  LIKE axg_file.axg16    
DEFINE l_sum_axg15  LIKE axg_file.axg15     
DEFINE l_sum_axg16  LIKE axg_file.axg16    
DEFINE l_axj06      LIKE axj_file.axj06   
DEFINE l_axj07      LIKE axj_file.axj07   
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0

  LET l_axg15 = 0
  LET l_axg16 = 0

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
  LET l_axj07 = 0
  LET l_sql=
  " SELECT axi04,axj06,SUM(axj07) ",
  #" FROM axi_file,axj_file,aag_file",  #TQC-D30026 MARK
  " FROM axi_file,axj_file",    #TQC-D30026 MOD
  " WHERE axi00 = axj00 ",
  "   AND axi01 = axj01 ",
  "   AND axi00 = '",g_aaz641,"'",
  "   AND axi03 = '",tm.yy,"'",
  "   AND axi04 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
  "   AND axi08 = '1'",
  "   AND axi05 = '",g_dept[p_i].axa01,"'",
  "   AND axi06 = '",g_dept[p_i].axb04,"'",
  "   AND axi09 = 'N'",
  "   AND axiconf = 'Y'",
  "   AND axj03 = '",p_aah01,"'",   #TQC-D30026 MOD
  " GROUP BY axi04,axj06 "          #TQC-D30026 MOD
  PREPARE p001_axj_p5 FROM l_sql
  DECLARE p001_axj_c5 CURSOR FOR p001_axj_p5
  FOREACH p001_axj_c5 INTO l_month,l_axj06,l_axj07
     IF l_month = 0 THEN LET l_month = 1 END IF
     IF p_axz06 != p_axz07 THEN 
         #功能幣別匯率
         CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
         RETURNING l_rate
     END IF

     LET l_axg13 = 0  #TQC-D30026 add
     LET l_axg14 = 0  #TQC-D30026 ADD

     IF l_axj06 = '1' THEN
        LET l_axg13 = l_axj07
     ELSE
        LET l_axg14 = l_axj07
     END IF
     LET l_axg15 = l_axg13 * l_rate
     LET l_axg16 = l_axg14 * l_rate
     LET l_sum_axg15 = l_sum_axg15  + l_axg15
     LET l_sum_axg16 = l_sum_axg16  + l_axg16
  END FOREACH

#--TQC-D30026 MARK START--
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16
#  LET l_avg_axg15 = l_avg_axg15 * l_rate
#  LET l_avg_axg16 = l_avg_axg16 * l_rate
#  LET l_sum_axg15 = l_sum_axg15 + l_avg_axg15
#  LET l_sum_axg16 = l_sum_axg16 + l_avg_axg16
#--TQC-D30026 MARK END---

  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION

FUNCTION p001_axj_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_axe12      LIKE axe_file.axe12    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg08      LIKE axg_file.axg08
DEFINE l_axg09      LIKE axg_file.axg09
DEFINE l_avg_axg08  LIKE axg_file.axg08    
DEFINE l_avg_axg09  LIKE axg_file.axg09    
DEFINE l_sum_axg08  LIKE axg_file.axg08     
DEFINE l_sum_axg09  LIKE axg_file.axg09    
DEFINE l_axj06      LIKE axj_file.axj06   
DEFINE l_axj07      LIKE axj_file.axj07   
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0
  LET l_axg08 = 0
  LET l_axg09 = 0
  LET l_sum_axg08 = 0
  LET l_sum_axg09 = 0

  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axg_file之前要倒推匯率再存入(算完合併幣金額之後再推)

  LET l_axg13 = 0
  LET l_axg14 = 0
  LET l_axj07 = 0
  LET l_sql=
  " SELECT axi04,axj06,SUM(axj07) ",
  #" FROM axi_file,axj_file,aag_file",  #TQC-D30026 mark
  " FROM axi_file,axj_file",    #TQC-D30026 MOD
  " WHERE axi00 = axj00 ",
  "   AND axi01 = axj01 ",
  "   AND axi00 = '",g_aaz641,"'",
  "   AND axi03 = '",tm.yy,"'",
  "   AND axi04 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
  "   AND axi08 = '1'",
  "   AND axi05 = '",g_dept[p_i].axa01,"'",
  "   AND axi06 = '",g_dept[p_i].axb04,"'",
  "   AND axi09 = 'N'",
  "   AND axiconf = 'Y'",
  "   AND axj03 = '",p_aah01,"'",   #TQC-D30026 MOD
  " GROUP BY aei04,axj06 "          #TQC-D30026 ADD
  PREPARE p001_axj_p6 FROM l_sql
  DECLARE p001_axj_c6 CURSOR FOR p001_axj_p6
  FOREACH p001_axj_c6 INTO l_month,l_axj06,l_axj07
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
     LET l_axg13 = 0   #TQC-D30026 ADD
     LET l_axg14 = 0   #TQC-D30026 ADD
     IF l_axj06 = '1' THEN
        LET l_axg13 = l_axj07
     ELSE
        LET l_axg14 = l_axj07
     END IF
     LET l_axg08 = l_axg13 * l_rate * l_rate1
     LET l_axg09 = l_axg14 * l_rate * l_rate1
     LET l_sum_axg08 = l_sum_axg08  + l_axg08
     LET l_sum_axg09 = l_sum_axg09  + l_axg09
  END FOREACH
#--TQC-D30026 MARK START--
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09
#  LET l_avg_axg08 = l_avg_axg08 * l_rate * l_rate1
#  LET l_avg_axg09 = l_avg_axg09 * l_rate * l_rate1
#  LET l_sum_axg08 = l_sum_axg08 + l_avg_axg08
#  LET l_sum_axg09 = l_sum_axg09 + l_avg_axg09
#--TQC-D30026 MARK END---
  LET l_dr_sum = l_sum_axg08 
  LET l_cr_sum = l_sum_axg09 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION

FUNCTION p001_fun_axj2_avg(p_axe11,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE type_file.num5   
DEFINE p_mm         LIKE type_file.num5  
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axk20      LIKE axk_file.axk20
DEFINE l_axk21      LIKE axk_file.axk21
DEFINE l_month      LIKE type_file.num5    
DEFINE l_sum_axk20  LIKE axk_file.axk20   
DEFINE l_sum_axk21  LIKE axk_file.axk21     
DEFINE l_axk18      LIKE axk_file.axk18     
DEFINE l_axk19      LIKE axk_file.axk19     
DEFINE l_avg_axk18  LIKE axk_file.axk18     
DEFINE l_avg_axk19  LIKE axk_file.axk19     
DEFINE l_axj06      LIKE axj_file.axj06   
DEFINE l_axj07      LIKE axj_file.axj07   
DEFINE l_sql        STRING                  

  #--先處理依編製期別取每期金額
  #功能幣金額：(記帳幣*再衡量匯率 (0~迄期別)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率(0~迄期別))
  #例:1~6月各期記帳幣異動額各為100，
  #上一期(3月)功能金額：820
  #出6月季報時，應先記算0~6月各期金額=SUM(每期異動額*當期平均匯率)：
  #存檔axk_file之前要倒推匯率再存入(算完合併幣金額之後再推)
 
  LET l_sum_axk20 = 0    
  LET l_sum_axk21 = 0    
  LET l_axk18 = 0    
  LET l_axk19 = 0    
  LET l_axk20 = 0    
  LET l_axk21 = 0    

  LET l_sql=
  " SELECT axi04,axj06,SUM(axj07) ",
  #" FROM axi_file,axj_file,aag_file",   #TQC-D30026 mark
  " FROM axi_file,axj_file",      #TQC-D30026 MOD
  " WHERE axi00 = axj00 ",
  "   AND axi01 = axj01 ",
  "   AND axi00 = '",g_aaz641,"'",
  "   AND axi03 = '",tm.yy,"'",
  "   AND axi04 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
  "   AND axi08 = '1'",
  "   AND axi05 = '",g_dept[p_i].axa01,"'",
  "   AND axi06 = '",g_dept[p_i].axb04,"'",
  "   AND axi09 = 'N'",
  "   AND axiconf = 'Y'",
  "   AND axj03 = '",p_aed01,"'",
  "   AND axj05 = '",p_aed02,"'",   #TQC-D30026 ADD,
  " GROUP BY axi04,axj06 "          #TQC-D30026 ADD
  PREPARE p001_axj_p7 FROM l_sql
  DECLARE p001_axj_c7 CURSOR FOR p001_axj_p7
  FOREACH p001_axj_c7 INTO l_month,l_axj06,l_axj07
     IF l_month = 0 THEN LET l_month = 1 END IF
     IF p_axz06 != p_axz07 THEN 
         #功能幣別匯率
         CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
         RETURNING l_rate
     END IF
     IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
     LET l_axk18 = 0   #TQC-D30026 ADD
     LET l_axk19 = 0   #TQC-D30026 ADD
     IF l_axj06 = '1' THEN
        LET l_axk18 = l_axj07
     ELSE
        LET l_axk19 = l_axj07
     END IF
     LET l_axk20 = l_axk18 * l_rate 
     LET l_axk21 = l_axk19 * l_rate
     LET l_sum_axk20 = l_sum_axk20  + l_axk20
     LET l_sum_axk21 = l_sum_axk21  + l_axk21
  END FOREACH
  #--TQC-D30026 MARK START--
  #CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
  #LET l_avg_axk18 = l_avg_axk18 * l_rate 
  #LET l_avg_axk19 = l_avg_axk19 * l_rate
  #LET l_sum_axk20 = l_sum_axk20 + l_avg_axk18
  #LET l_sum_axk21 = l_sum_axk21 + l_avg_axk19 
  #--TQC-D30026 MARK END---
  LET l_dr_sum = l_sum_axk20
  LET l_cr_sum = l_sum_axk21
  
  RETURN l_dr_sum,l_cr_sum  
END FUNCTION 

FUNCTION p001_axj2_avg(p_axe11,p_axe12,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)   
DEFINE p_axe11      LIKE axe_file.axe11    #FUN-A90026
DEFINE p_axe12      LIKE axe_file.axe12    #FUN-A90026
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02    #FUN-A90026 
DEFINE p_mm         LIKE aah_file.aah03    #FUN-A90026 
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axk18      LIKE axk_file.axk18    #FUN-A90026
DEFINE l_axk19      LIKE axk_file.axk19    #FUN-A90026
DEFINE l_avg_axk18  LIKE axk_file.axk18    #MOD-C40135
DEFINE l_avg_axk19  LIKE axk_file.axk19    #MOD-C40135
DEFINE l_axk20      LIKE axk_file.axk20    #FUN-A90026
DEFINE l_axk21      LIKE axk_file.axk21    #FUN-A90026
DEFINE l_month      LIKE type_file.num5    #FUN-A90026
DEFINE l_sum_axk20  LIKE axk_file.axk10    #FUN-A90026
DEFINE l_sum_axk21  LIKE axk_file.axk11    #FUN-A90026
DEFINE l_axj06      LIKE axj_file.axj06   
DEFINE l_axj07      LIKE axj_file.axj07   
DEFINE l_sql        STRING

  #--先處理依編製期別取每期金額後
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axk_file之前要倒推匯率再存入
 
  #上一期合併幣金額：
  LET l_sum_axk20 = 0  #TQC-AA0098
  LET l_sum_axk21 = 0  #TQC-AA0098
  LET l_axk20  = 0  #TQC-AA0098
  LET l_axk21  = 0  #TQC-AA0098

  LET l_sql=
  " SELECT axi04,axj06,SUM(axj07) ",
  #" FROM axi_file,axj_file,aag_file",   #TQC-D30026 mark
  " FROM axi_file,axj_file",   #TQC-D30026 MOD
  " WHERE axi00 = axj00 ",
  "   AND axi01 = axj01 ",
  "   AND axi00 = '",g_aaz641,"'",
  "   AND axi03 = '",tm.yy,"'",
  "   AND axi04 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
  "   AND axi08 = '1'",
  "   AND axi05 = '",g_dept[p_i].axa01,"'",
  "   AND axi06 = '",g_dept[p_i].axb04,"'",
  "   AND axi09 = 'N'",
  "   AND axiconf = 'Y'",
  "   AND axj03 = '",p_aed01,"'",
  "   AND axj05 = '",p_aed02,"'",   #TQC-D30026 ADD,
  " GROUP BY axi04,axj06"           #TQC-D30026 ADD
  PREPARE p001_axj_p8 FROM l_sql
  DECLARE p001_axj_c8 CURSOR FOR p001_axj_p8
  FOREACH p001_axj_c8 INTO l_month,l_axj06,l_axj07
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
     LET l_axk18 = 0  #TQC-D30026 ADD
     LET l_axk19 = 0  #TQC-D30026 ADD
     IF l_axj06 = '1' THEN
        LET l_axk18 = l_axj07
     ELSE
        LET l_axk19 = l_axj07
     END IF
     LET l_axk20 = l_axk18 * l_rate * l_rate1
     LET l_axk21 = l_axk19 * l_rate * l_rate1
     LET l_sum_axk20 = l_sum_axk20  + l_axk20
     LET l_sum_axk21 = l_sum_axk21  + l_axk21
  END FOREACH
  #--TQC-D30026 MARK START--
  #CALL p001_avg_adj(p_aed01,p_aed02,p_i) RETURNING l_avg_axk18,l_avg_axk19
  #LET l_avg_axk18 = l_avg_axk18 * l_rate * l_rate1 
  #LET l_avg_axk19 = l_avg_axk19 * l_rate * l_rate1
  #LET l_sum_axk20 = l_sum_axk20 + l_avg_axk18
  #LET l_sum_axk21 = l_sum_axk21 + l_avg_axk19
  #--TQC-D30026 MARK END---
  LET l_dr_sum = l_sum_axk20 
  LET l_cr_sum = l_sum_axk21

  RETURN l_dr_sum,l_cr_sum
END FUNCTION

FUNCTION p001_fun_aem_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg15      LIKE axg_file.axg15
DEFINE l_axg16      LIKE axg_file.axg16
DEFINE l_avg_axg15  LIKE axg_file.axg15    
DEFINE l_avg_axg16  LIKE axg_file.axg16    
DEFINE l_sum_axg15  LIKE axg_file.axg15     
DEFINE l_sum_axg16  LIKE axg_file.axg16    
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0

  LET l_axg15 = 0
  LET l_axg16 = 0

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
  " SELECT aem10,aem11,aem12 ",
  "   FROM aem_file ",
  "  WHERE aem09 =",tm.yy,
  "    AND aem10 BETWEEN ",tm.bm," AND ",tm.em,
  "    AND aem00='",g_aaz641,"'",
  "    AND aem01='",g_dept[p_i].axa01,"'",
  "    AND aem02='",g_dept[p_i].axb04,"'",
  "    AND aem04 = '",p_aah01,"'"
  PREPARE p001_aem_p FROM l_sql
  DECLARE p001_aem_c CURSOR FOR p001_aem_p
  FOREACH p001_aem_c INTO l_month,l_axg13,l_axg14
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
#--TQC-D30026 MARK START--
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16
#  LET l_avg_axg15 = l_avg_axg15 * l_rate
#  LET l_avg_axg16 = l_avg_axg16 * l_rate
#  LET l_sum_axg15 = l_sum_axg15 + l_avg_axg15
#  LET l_sum_axg16 = l_sum_axg16 + l_avg_axg16
#--TQC-D30026 MARK END---

  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION

FUNCTION p001_aem_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_axe12      LIKE axe_file.axe12    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg08      LIKE axg_file.axg08
DEFINE l_axg09      LIKE axg_file.axg09
DEFINE l_avg_axg08  LIKE axg_file.axg08    
DEFINE l_avg_axg09  LIKE axg_file.axg09    
DEFINE l_sum_axg08  LIKE axg_file.axg08     
DEFINE l_sum_axg09  LIKE axg_file.axg09    
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0
  LET l_axg08 = 0
  LET l_axg09 = 0
  LET l_sum_axg08 = 0
  LET l_sum_axg09 = 0

  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axg_file之前要倒推匯率再存入(算完合併幣金額之後再推)

  LET l_axg13 = 0
  LET l_axg14 = 0
  LET l_sql=
  " SELECT aem10,aem11,aem12 ",
  "   FROM aem_file ",
  "  WHERE aem09 =",tm.yy,
  "    AND aem10 BETWEEN ",tm.bm," AND ",tm.em,
  "    AND aem00='",g_aaz641,"'",
  "    AND aem01='",g_dept[p_i].axa01,"'",
  "    AND aem02='",g_dept[p_i].axb04,"'",
  "    AND aem04 = '",p_aah01,"'"
  PREPARE p001_aem_p2 FROM l_sql
  DECLARE p001_aem_c2 CURSOR FOR p001_aem_p2
  FOREACH p001_aem_c2 INTO l_month,l_axg13,l_axg14
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

     #--TQC-D30026 START-
     #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
     #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
     CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09
     #--TQC-D30026 END--

     #LET l_axg08 = l_axg13 * l_rate * l_rate1   #TQC-D30026 MARK
     #LET l_axg09 = l_axg14 * l_rate * l_rate1   #TQC-D30026 MARK
     LET l_axg08 = (l_axg13+l_avg_axg08) * l_rate * l_rate1   #TQC-D30026 MOD
     LET l_axg09 = (l_axg14+l_avg_axg09) * l_rate * l_rate1   #TQC-D30026 MOD
     LET l_sum_axg08 = l_sum_axg08  + l_axg08
     LET l_sum_axg09 = l_sum_axg09  + l_axg09
  END FOREACH

#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09
#  LET l_avg_axg08 = l_avg_axg08 * l_rate * l_rate1
#  LET l_avg_axg09 = l_avg_axg09 * l_rate * l_rate1
#  LET l_sum_axg08 = l_sum_axg08 + l_avg_axg08
#  LET l_sum_axg09 = l_sum_axg09 + l_avg_axg09
#--TQC-D30026 MARK END--
  LET l_dr_sum = l_sum_axg08 
  LET l_cr_sum = l_sum_axg09 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION

FUNCTION p001_fun_aeii_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg15      LIKE axg_file.axg15
DEFINE l_axg16      LIKE axg_file.axg16
DEFINE l_avg_axg15  LIKE axg_file.axg15    
DEFINE l_avg_axg16  LIKE axg_file.axg16    
DEFINE l_sum_axg15  LIKE axg_file.axg15     
DEFINE l_sum_axg16  LIKE axg_file.axg16    
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0

  LET l_axg15 = 0
  LET l_axg16 = 0

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
  " SELECT aeii10,aeii11,aeii12 ",
  "   FROM aeii_file ",
  "  WHERE aeii09 = ",tm.yy,
  "    AND aeii10 BETWEEN ",tm.bm," AND ",tm.em,
  "    AND aeii00 = '",g_aaz641,"'",       
  "    AND aeii01 = '",g_dept[p_i].axa01,"'",
  "    AND aeii03 = '",g_dept[p_i].axb04,"'",
  "    AND aeii031= '",g_dept[p_i].axb05,"'",
  "    AND aeii15 = '",tm.ver,"'",
  "    AND aeii04 = '",p_aah01,"'"
  PREPARE p001_aeii_p3 FROM l_sql
  DECLARE p001_aeii_c3 CURSOR FOR p001_aeii_p3
  FOREACH p001_aeii_c3 INTO l_month,l_axg13,l_axg14
     IF l_month = 0 THEN LET l_month = 1 END IF
     IF p_axz06 != p_axz07 THEN 
         #功能幣別匯率
         CALL p001_getrate(p_axe11,p_yy,l_month,p_axz06,p_axz07)
         RETURNING l_rate
     END IF
     #--TQC-D30026 START--
     #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
     #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
     CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16
     #--TQC-D30026 END---

     #LET l_axg15 = l_axg13 * l_rate    #TQC-D30026 MARK
     #LET l_axg16 = l_axg14 * l_rate    #TQC-D30026 MARK
     LET l_axg15 = (l_axg13+l_avg_axg15) * l_rate     #TQC-D30026 MOD
     LET l_axg16 = (l_axg14+l_avg_axg16) * l_rate     #TQC-D30026 MOD

     LET l_sum_axg15 = l_sum_axg15  + l_axg15
     LET l_sum_axg16 = l_sum_axg16  + l_axg16
  END FOREACH

#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯應該都是要先加總之後再一起換匯
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg15,l_avg_axg16
#  LET l_avg_axg15 = l_avg_axg15 * l_rate
#  LET l_avg_axg16 = l_avg_axg16 * l_rate
#  LET l_sum_axg15 = l_sum_axg15 + l_avg_axg15
#  LET l_sum_axg16 = l_sum_axg16 + l_avg_axg16
#--TQC-D30026 MARK END---

  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION

FUNCTION p001_aeii_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i) 
DEFINE l_sql        STRING
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE p_axe12      LIKE axe_file.axe12    
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_yy         LIKE aah_file.aah02     
DEFINE p_mm         LIKE aah_file.aah03     
DEFINE p_i          LIKE type_file.num5
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE l_axg08      LIKE axg_file.axg08
DEFINE l_axg09      LIKE axg_file.axg09
DEFINE l_avg_axg08  LIKE axg_file.axg08    
DEFINE l_avg_axg09  LIKE axg_file.axg09    
DEFINE l_sum_axg08  LIKE axg_file.axg08     
DEFINE l_sum_axg09  LIKE axg_file.axg09    
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE l_month      LIKE type_file.num5   

  LET l_dr_sum = 0
  LET l_cr_sum = 0
  LET l_axg08 = 0
  LET l_axg09 = 0
  LET l_sum_axg08 = 0
  LET l_sum_axg09 = 0

  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axg_file之前要倒推匯率再存入(算完合併幣金額之後再推)

  LET l_axg13 = 0
  LET l_axg14 = 0
  LET l_sql=
  " SELECT aeii10,aeii11,aeii12 ",
  "   FROM aeii_file ",
  "  WHERE aeii09 = ",tm.yy,
  "    AND aeii10 BETWEEN ",tm.bm," AND ",tm.em,
  "    AND aeii00 = '",g_aaz641,"'",       
  "    AND aeii01 = '",g_dept[p_i].axa01,"'",
  "    AND aeii03 = '",g_dept[p_i].axb04,"'",
  "    AND aeii031= '",g_dept[p_i].axb05,"'",
  "    AND aeii15 = '",tm.ver,"'",
  "    AND aeii04 = '",p_aah01,"'"
  PREPARE p001_aeii_p4 FROM l_sql
  DECLARE p001_aeii_c4 CURSOR FOR p001_aeii_p4
  FOREACH p001_aeii_c4 INTO l_month,l_axg13,l_axg14
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

     #--TQC-D30026 START--
     #因為採用平均匯率第一種計算方式算法者，如果沒有再加取出調整分錄的金額
     #會造成只有總帳餘額，lose了調整分錄的部份，所以要一邊取每月份總帳的錢再一邊取調整分錄先加總再做換匯
     CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09
     #--TQC-D30026 END--

     #LET l_axg08 = l_axg13 * l_rate * l_rate1    #TQC-D30026 MARK
     #LET l_axg09 = l_axg14 * l_rate * l_rate1    #TQC-D30026 MARK
     LET l_axg08 = (l_axg13+l_avg_axg08) * l_rate * l_rate1     #TQC-D30026 MOD
     LET l_axg09 = (l_axg14+l_avg_axg09) * l_rate * l_rate1     #TQC-D30026 MOD
     LET l_sum_axg08 = l_sum_axg08  + l_axg08
     LET l_sum_axg09 = l_sum_axg09  + l_axg09
  END FOREACH

#--TQC-D30026 MARK START--
#把p001_avg_adj的處理移入FOREACH，才不會變成總帳和調整分錄的錢各自換匯
#系統的處理邏輯要先加總之後再一起換匯
#  CALL p001_avg_adj(p_aah01,'',p_i) RETURNING l_avg_axg08,l_avg_axg09
#  LET l_avg_axg08 = l_avg_axg08 * l_rate * l_rate1
#  LET l_avg_axg09 = l_avg_axg09 * l_rate * l_rate1
#  LET l_sum_axg08 = l_sum_axg08 + l_avg_axg08
#  LET l_sum_axg09 = l_sum_axg09 + l_avg_axg09
#--TQC-D30026 MARK END---

  LET l_dr_sum = l_sum_axg08 
  LET l_cr_sum = l_sum_axg09 

  RETURN l_dr_sum,l_cr_sum    
END FUNCTION
#-MOD-C90148-end-

#---FUN-A90006 start----------------
FUNCTION p001_ins_axj1_chg(p_type,p_flag,p_axz06)
#FUNCTION p001_ins_axj1_chg(p_axg12,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_month_amt LIKE axg_file.axg08
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   #FUN-A90026
DEFINE l_r         LIKE axp_file.axp05   #FUN-A90026 
DEFINE l_r1        LIKE axp_file.axp05   #FUN-A90026
DEFINE p_flag      LIKE type_file.chr1   #FUN-A90026
DEFINE p_type      LIKE type_file.chr1   #FUN-A90026
DEFINE l_axz07     LIKE axf_file.axf09   #FUN-A90026

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
      LET l_axg08 = 0
      LET l_axg09 = 0
      LET l_axg08_b = 0
      LET l_axg09_b = 0
      LET l_month_amt = 0
      LET l_tot_amt = 0
      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axk_file or axg_file取各月餘額
     FOR i = 0 TO tm.em   #FUN-A90026 mod
#---FUN-A90026 start--- 
         SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg04
         IF p_type = 'A' THEN       #來源公司 
             CASE 
                WHEN p_flag = '1'        #aej_file
                    LET l_sql =
                    " SELECT SUM(aej07-aej08),aej11",      
                    "   FROM aej_file ",
                    "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                    "    AND aej01 = '",tm.axa01,"'",        #族群
                    "    AND aej02 = '",g_axg.axg04,"'",     #公司
                    "    AND aej04 = '",g_axg.axg05,"'",
                    "    AND aej05 = '",tm.yy,"'",
                    "    AND aej06 = '",i,"'",
                    "  GROUP BY aej11 "
                WHEN p_flag = '2'        #aek_file
                    LET l_sql=
                    " SELECT SUM(aek08-aek09),aek12",   
                    "   FROM aek_file",
                    "  WHERE aek00 = '",g_aaz641,"'",
                    "    AND aek01 = '",tm.axa01,"'",
                    "    AND aek02 = '",g_axg.axg04,"'",
                    "    AND aek04 = '",g_axg.axg05,"'",
                    "    AND aek05 = '",g_axk07,"'",
                    "    AND aek06 = '",tm.yy,"'",
                    "    AND aek07 = '",i,"'",
                    "  GROUP BY aek12"
            END CASE
        ELSE        #目的公司
            CASE
              WHEN p_flag = '1'        #aej_file
                 LET l_sql =
                #" SELECT SUM(aej07-aej08),aej11",        #MOD-CC0175 mark
                 " SELECT SUM(aej07-aej08)*-1,aej11",     #MOD-CC0175 add
                 "   FROM aej_file ",
                 "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                 "    AND aej01 = '",tm.axa01,"'", #族群
                 "    AND aej02 = '",g_axg.axg04,"'",     #公司
                 "    AND aej04 = '",g_axg.axg05,"'",
                 "    AND aej05 = '",tm.yy,"'",
                 "    AND aej06 = '",i,"'",
                 "  GROUP BY aej11 "
              WHEN p_flag = '2'        #aek_file
                 LET l_sql=
                #" SELECT SUM(aek08-aek09),aek12",        #MOD-CC0175 mark
                 " SELECT SUM(aek08-aek09)*-1,aek12",     #MOD-CC0175 add
                 "   FROM aek_file",
                 "  WHERE aek00 = '",g_aaz641,"'",
                 "    AND aek01 = '",tm.axa01,"'",
                 "    AND aek02 = '",g_axg.axg04,"'",
                 "    AND aek04 = '",g_axg.axg05,"'",
                 "    AND aek05 = '",g_axk07,"'",
                 "    AND aek06 = '",tm.yy,"'",
                 "    AND aek07 = '",i,"'",
                 "  GROUP BY aek12"
            END CASE
        END IF
        #---FUN-A90026 end-----

        PREPARE p001_ins_axj1_p1 FROM l_sql
        IF STATUS THEN
           LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy
           CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'pre:ins_axj1_p1',STATUS,1)
           LET g_success = 'N'
        END IF
        DECLARE p001_ins_axj1_c1 CURSOR FOR p001_ins_axj1_p1
        #FOREACH p001_ins_axj1_c1 INTO l_axg08,l_axg09    #借/貸
        FOREACH p001_ins_axj1_c1 INTO l_month_amt,l_axg12    #借-貸/幣別   #FUN-A90026 mod
        #--FUN-A90026 srart---
            LET l_r = 1
            LET l_r1 = 1
            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
            CALL p001_getrate('3',tm.yy,i,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
            RETURNING l_r   
            IF cl_null(l_r) THEN LET l_r = 1 END IF
            CALL p001_getrate('3',tm.yy,i,l_axz07,p_axz06) 
            RETURNING l_r1   
            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
            LET l_month_amt = l_month_amt * l_r * l_r1
            LET l_tot_amt = l_tot_amt + l_month_amt
        END FOREACH
        #--FUN-A90026 end----
     END FOR
     RETURN l_tot_amt 
END FUNCTION
#---FUN-A90006 end-----------------

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

#---FUN-AB0004 start--
FUNCTION p001_fun_axkk_avg(p_axe11,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)
DEFINE p_axz07      LIKE axz_file.axz07
DEFINE p_axz06      LIKE axz_file.axz06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE l_axk20      LIKE axk_file.axk20
DEFINE l_axk21      LIKE axk_file.axk21
DEFINE p_aed01      LIKE aed_file.aed01
DEFINE p_aed02      LIKE aed_file.aed02
DEFINE l_month      LIKE type_file.num5   
DEFINE p_axe11      LIKE axe_file.axe11   
DEFINE l_sum_axk20  LIKE axk_file.axk20   
DEFINE l_sum_axk21  LIKE axk_file.axk21   
DEFINE l_axk18      LIKE axk_file.axk18   
DEFINE l_axk19      LIKE axk_file.axk19   
DEFINE p_yy         LIKE type_file.num5  
DEFINE p_mm         LIKE type_file.num5  
DEFINE l_sql        STRING               
DEFINE l_axkk10_1   LIKE axkk_file.axkk10
DEFINE l_axkk11_1   LIKE axkk_file.axkk11
DEFINE l_axkk10_2   LIKE axkk_file.axkk10
DEFINE l_axkk11_2   LIKE axkk_file.axkk11

  #--先處理依編製期別取每期金額
  #功能幣金額：(記帳幣*再衡量匯率 (0~迄期別)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率(0~迄期別))
  #例:1~6月各期記帳幣異動額各為100，
  #上一期(3月)功能金額：820
  #出6月季報時，應先記算0~6月各期金額=SUM(每期異動額*當期平均匯率)：
  #存檔axk_file之前要倒推匯率再存入(算完合併幣金額之後再推)
 
  LET l_sum_axk20 = 0  
  LET l_sum_axk21 = 0 
  LET l_axk18 = 0   
  LET l_axk19 = 0  
  LET l_axk20 = 0 
  LET l_axk21 = 0
  LET l_axkk10_1 = 0
  LET l_axkk11_1 = 0
  LET l_axkk10_2 = 0
  LET l_axkk11_2 = 0 
  LET l_sql=
  " SELECT axkk09",
  "   FROM axkk_file ",
  "  WHERE axkk00 = '",g_aaz641,"'",        #合併帳別 
  "    AND axkk01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND axkk02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND axkk05 = '",p_aed01,"'",
  "    AND axkk07 = '",p_aed02,"'",
  "    AND axkk08 = '",tm.yy,"'",
  "    AND axkk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_axkk_p1 FROM l_sql
  DECLARE p001_axkk_c1 CURSOR FOR p001_axkk_p1
  FOREACH p001_axkk_c1 INTO l_month
       IF l_month = 0 THEN CONTINUE FOREACH END IF 
       SELECT axkk10,axkk11 INTO l_axkk10_2,l_axkk11_2    #當期  
         FROM axkk_file 
        WHERE axkk00 = g_aaz641          #合併帳別 
          AND axkk01 = g_dept[p_i].axa01 #族群
          AND axkk02 = g_dept[p_i].axb04 #公司
          AND axkk05 = p_aed01
          AND axkk07 = p_aed02
          AND axkk08 = tm.yy
          AND axkk09 = l_month
       IF cl_null(l_axkk10_2) THEN LET l_axkk10_2 = 0 END IF
       IF cl_null(l_axkk11_2) THEN LET l_axkk11_2 = 0 END IF

       SELECT axkk10,axkk11 INTO l_axkk10_1,l_axkk11_1   #上期
         FROM axkk_file 
        WHERE axkk00 = g_aaz641          #合併帳別 
          AND axkk01 = g_dept[p_i].axa01 #族群
          AND axkk02 = g_dept[p_i].axb04 #公司
          AND axkk05 = p_aed01
          AND axkk07 = p_aed02
          AND axkk08 = tm.yy
          AND axkk09 = (SELECT MAX(axkk09) FROM axkk_file
                         WHERE axkk00 = g_aaz641          #合併帳別 
                           AND axkk01 = g_dept[p_i].axa01 #族群
                           AND axkk02 = g_dept[p_i].axb04 #公司
                           AND axkk05 = p_aed01
                           AND axkk07 = p_aed02
                           AND axkk08 = tm.yy
                           AND axkk09 <l_month)
       IF cl_null(l_axkk10_1) THEN LET l_axkk10_1 = 0 END IF
       IF cl_null(l_axkk11_1) THEN LET l_axkk11_1 = 0 END IF
       LET l_axk18 = l_axkk10_2 - l_axkk10_1
       LET l_axk19 = l_axkk11_2 - l_axkk11_1

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

END FUNCTION 

FUNCTION p001_axkk_avg(p_axe11,p_axe12,p_aed01,p_aed02,p_axz06,p_axz07,p_yy,p_mm,p_i)   
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
DEFINE p_yy         LIKE aah_file.aah02    
DEFINE p_mm         LIKE aah_file.aah03    
DEFINE l_axk18      LIKE axk_file.axk18    
DEFINE l_axk19      LIKE axk_file.axk19    
DEFINE l_axk20      LIKE axk_file.axk20    
DEFINE l_axk21      LIKE axk_file.axk21    
DEFINE p_axe12      LIKE axe_file.axe12    
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE l_month      LIKE type_file.num5    
DEFINE l_sum_axk10  LIKE axk_file.axk10    
DEFINE l_sum_axk11  LIKE axk_file.axk11    
DEFINE l_axkk10_1   LIKE axkk_file.axkk10
DEFINE l_axkk11_1   LIKE axkk_file.axkk11
DEFINE l_axkk10_2   LIKE axkk_file.axkk10
DEFINE l_axkk11_2   LIKE axkk_file.axkk11

  #--先處理依編製期別取每期金額後
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)
  #存檔axk_file之前要倒推匯率再存入
 
  #上一期合併幣金額：
  LET l_axkk10_1 = 0
  LET l_axkk11_1 = 0
  LET l_axkk10_2 = 0
  LET l_axkk11_2 = 0
  LET l_sum_axk10 = 0  
  LET l_sum_axk11 = 0 
  LET l_axk20  = 0  
  LET l_axk21  = 0 

  LET l_sql=
  " SELECT axkk09",
  "   FROM axkk_file ",
  "  WHERE axkk00 = '",g_aaz641,"'",        #合併帳別 
  "    AND axkk01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND axkk02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND axkk05 = '",p_aed01,"'",
  "    AND axkk07 = '",p_aed02,"'",
  "    AND axkk08 = '",tm.yy,"'",
  "    AND axkk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_axkk_p2 FROM l_sql
  DECLARE p001_axkk_c2 CURSOR FOR p001_axkk_p2
  FOREACH p001_axkk_c2 INTO l_month
       IF l_month = 0 THEN CONTINUE FOREACH END IF 
       SELECT axkk10,axkk11 INTO l_axkk10_2,l_axkk11_2    #當期  
         FROM axkk_file 
        WHERE axkk00 = g_aaz641          #合併帳別 
          AND axkk01 = g_dept[p_i].axa01 #族群
          AND axkk02 = g_dept[p_i].axb04 #公司
          AND axkk05 = p_aed01
          AND axkk07 = p_aed02
          AND axkk08 = tm.yy
          AND axkk09 = l_month
       IF cl_null(l_axkk10_2) THEN LET l_axkk10_2 = 0 END IF
       IF cl_null(l_axkk11_2) THEN LET l_axkk11_2 = 0 END IF

       SELECT axkk10,axkk11 INTO l_axkk10_1,l_axkk11_1   #上期
         FROM axkk_file 
        WHERE axkk00 = g_aaz641          #合併帳別 
          AND axkk01 = g_dept[p_i].axa01 #族群
          AND axkk02 = g_dept[p_i].axb04 #公司
          AND axkk05 = p_aed01
          AND axkk07 = p_aed02
          AND axkk08 = tm.yy
          AND axkk09 = (SELECT MAX(axkk09) FROM axkk_file
                         WHERE axkk00 = g_aaz641          #合併帳別 
                           AND axkk01 = g_dept[p_i].axa01 #族群
                           AND axkk02 = g_dept[p_i].axb04 #公司
                           AND axkk05 = p_aed01
                           AND axkk07 = p_aed02
                           AND axkk08 = tm.yy
                           AND axkk09 <l_month)
       IF cl_null(l_axkk10_1) THEN LET l_axkk10_1 = 0 END IF
       IF cl_null(l_axkk11_1) THEN LET l_axkk11_1 = 0 END IF
       LET l_axk18 = l_axkk10_2 - l_axkk10_1
       LET l_axk19 = l_axkk11_2 - l_axkk11_1

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

  RETURN l_dr_sum,l_cr_sum
END FUNCTION

FUNCTION p001_axh_fun_avg(p_axe11,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i)  
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
DEFINE l_sum_axg15  LIKE axg_file.axg15    
DEFINE l_sum_axg16  LIKE axg_file.axg16    
DEFINE l_axg13      LIKE axg_file.axg13    
DEFINE l_axg14      LIKE axg_file.axg14    
DEFINE p_yy         LIKE aah_file.aah02    
DEFINE p_mm         LIKE aah_file.aah03    
DEFINE p_axe11      LIKE axe_file.axe11    
DEFINE l_month      LIKE type_file.num5    
DEFINE l_axh08_1    LIKE axh_file.axh08
DEFINE l_axh09_1    LIKE axh_file.axh09
DEFINE l_axh08_2    LIKE axh_file.axh08
DEFINE l_axh09_2    LIKE axh_file.axh09

  LET l_dr_sum = 0
  LET l_cr_sum = 0

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
  LET l_axh08_1 = 0
  LET l_axh09_1 = 0
  LET l_axh08_2 = 0
  LET l_axh09_2 = 0

  LET l_sql=
  " SELECT axh07",
  "   FROM axh_file ",
  "  WHERE axh00 = '",g_aaz641,"'",        #合併帳別 
  "    AND axh01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND axh02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND axh05 = '",p_aah01,"'",
  "    AND axh06= '",tm.yy,"'",
  "    AND axh07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_axh_p1 FROM l_sql
  DECLARE p001_axh_c1 CURSOR FOR p001_axh_p1
  FOREACH p001_axh_c1 INTO l_month
       IF l_month = 0 THEN CONTINUE FOREACH END IF 
       SELECT axh08,axh09 INTO l_axh08_2,l_axh09_2    #當期  
         FROM axh_file 
        WHERE axh00 = g_aaz641 
          AND axh01 = g_dept[p_i].axa01
          AND axh02 = g_dept[p_i].axb04
          AND axh05 = p_aah01
          AND axh06 = tm.yy
          AND axh07 = l_month
       IF cl_null(l_axh08_2) THEN LET l_axh08_2 = 0 END IF
       IF cl_null(l_axh09_2) THEN LET l_axh09_2 = 0 END IF

       SELECT axh08,axh09 INTO l_axh08_1,l_axh09_1  #前期
         FROM axh_file 
        WHERE axh00 = g_aaz641 
          AND axh01 = g_dept[p_i].axa01
          AND axh02 = g_dept[p_i].axb04
          AND axh05 = p_aah01
          AND axh06 = tm.yy
          AND axh07 = (SELECT MAX(axh07) FROM axh_file
                        WHERE axh00 = g_aaz641 
                          AND axh01 = g_dept[p_i].axa01
                          AND axh02 = g_dept[p_i].axb04
                          AND axh05 = p_aah01
                          AND axh06 = tm.yy
                          AND axh07 <l_month)
       IF cl_null(l_axh08_1) THEN LET l_axh08_1 = 0 END IF
       IF cl_null(l_axh09_1) THEN LET l_axh09_1 = 0 END IF

       LET l_axg13 = l_axh08_2 - l_axh08_1
       LET l_axg14 = l_axh09_2 - l_axh09_1

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

  LET l_dr_sum = l_sum_axg15 
  LET l_cr_sum = l_sum_axg16 

  RETURN l_dr_sum,l_cr_sum   
END FUNCTION

FUNCTION p001_axh_avg(p_axe11,p_axe12,p_aah01,p_axz06,p_axz07,p_yy,p_mm,p_i)
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
DEFINE p_yy         LIKE type_file.num5   
DEFINE p_mm         LIKE type_file.num5   
DEFINE l_month      LIKE type_file.num5   
DEFINE l_sum_axg08  LIKE axg_file.axg08   
DEFINE l_sum_axg09  LIKE axg_file.axg09   
DEFINE l_axg13      LIKE axg_file.axg13   
DEFINE l_axg14      LIKE axg_file.axg14   
DEFINE p_axe12      LIKE axe_file.axe12   
DEFINE p_axe11      LIKE axe_file.axe11   
DEFINE l_axh08_1    LIKE axh_file.axh08
DEFINE l_axh09_1    LIKE axh_file.axh09
DEFINE l_axh08_2    LIKE axh_file.axh08
DEFINE l_axh09_2    LIKE axh_file.axh09

  LET l_axg08 = 0
  LET l_axg09 = 0
  LET l_sum_axg08 = 0
  LET l_sum_axg09 = 0
  LET l_axg13 = 0 
  LET l_axg14 = 0
  LET l_axh08_1 = 0
  LET l_axh09_1 = 0
  LET l_axh08_2 = 0
  LET l_axh09_2 = 0

  LET l_sql=
  " SELECT axh07",
  "   FROM axh_file ",
  "  WHERE axh00 = '",g_aaz641,"'",          #合併帳別  
  "    AND axh01 = '",g_dept[p_i].axa01,"'", #族群
  "    AND axh02 = '",g_dept[p_i].axb04,"'", #公司
  "    AND axh05 = '",p_aah01,"'",
  "    AND axh06= '",tm.yy,"'",
  "    AND axh07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
  PREPARE p001_axh_p2 FROM l_sql
  DECLARE p001_axh_c2 CURSOR FOR p001_axh_p2
  FOREACH p001_axh_c2 INTO l_month
       IF l_month = 0 THEN CONTINUE FOREACH END IF 
       SELECT axh08,axh09 INTO l_axh08_2,l_axh09_2    #當期  
         FROM axh_file 
        WHERE axh00 = g_aaz641 
          AND axh01 = g_dept[p_i].axa01
          AND axh02 = g_dept[p_i].axb04
          AND axh05 = p_aah01
          AND axh06 = tm.yy
          AND axh07 = l_month
       IF cl_null(l_axh08_2) THEN LET l_axh08_2 = 0 END IF
       IF cl_null(l_axh09_2) THEN LET l_axh09_2 = 0 END IF

       SELECT axh08,axh09 INTO l_axh08_1,l_axh09_1   #前期 
         FROM axh_file 
        WHERE axh00 = g_aaz641 
          AND axh01 = g_dept[p_i].axa01
          AND axh02 = g_dept[p_i].axb04
          AND axh05 = p_aah01
          AND axh06 = tm.yy
          AND axh07 = (SELECT MAX(axh07) FROM axh_file
                        WHERE axh00 = g_aaz641 
                          AND axh01 = g_dept[p_i].axa01
                          AND axh02 = g_dept[p_i].axb04
                          AND axh05 = p_aah01
                          AND axh06 = tm.yy
                          AND axh07 <l_month)
       IF cl_null(l_axh08_1) THEN LET l_axh08_1 = 0 END IF
       IF cl_null(l_axh09_1) THEN LET l_axh09_1 = 0 END IF

       LET l_axg13 = l_axh08_2 - l_axh08_1
       LET l_axg14 = l_axh09_2 - l_axh09_1


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
END FUNCTION

FUNCTION p001_ins_axj1_chg1(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   
DEFINE l_r         LIKE axp_file.axp05   
DEFINE l_r1        LIKE axp_file.axp05   
DEFINE p_flag      LIKE type_file.chr1   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_axz07     LIKE axf_file.axf09   
DEFINE l_month     LIKE type_file.num5
DEFINE l_amt2      LIKE axh_file.axh08
DEFINE l_amt1      LIKE axh_file.axh08
DEFINE l_amt       LIKE axh_file.axh08

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)

     LET l_tot_amt = 0
     LET l_amt2 = 0
     LET l_amt1 = 0
     LET l_amt  = 0

     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
     IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axkk_file or axh_file取各期餘額
     LET l_sql=
     " SELECT axh07,axh12",
     "   FROM axh_file ",
     "  WHERE axh00 = '",g_aaz641,"'",          #合併帳別  
     "    AND axh01 = '",tm.axa01,"'", #族群
     "    AND axh02 = '",g_axg.axg02,"'", #公司
     "    AND axh05 = '",g_axg.axg05,"'",
     "    AND axh06= '",tm.yy,"'",
     "    AND axh07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
     PREPARE p001_axh_p3 FROM l_sql
     DECLARE p001_axh_c3 CURSOR FOR p001_axh_p3
     FOREACH p001_axh_c3 INTO l_month,l_axg12
        IF l_month = 0 THEN CONTINUE FOREACH END IF
        SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg02
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt2
                 FROM axh_file 
                WHERE axh00 = g_aaz641        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = l_month
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt2
                 FROM axkk_file
                WHERE axkk00 = g_aaz641
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = l_month
        END CASE
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt1
                 FROM axh_file
                WHERE axh00 = g_aaz641        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = (SELECT MAX(axh07) FROM axh_file
                                WHERE axh00 = g_aaz641        #合併帳別 
                                  AND axh01 = tm.axa01        #族群
                                  AND axh02 = g_axg.axg02     #公司
                                  AND axh05 = g_axg.axg05
                                  AND axh06 = tm.yy
                                  AND axh07 < l_month)
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt1
                 FROM axkk_file
                WHERE axkk00 = g_aaz641
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = (SELECT MAX(axkk09) FROM axkk_file
                                 WHERE axkk00 = g_aaz641
                                   AND axkk01 = tm.axa01
                                   AND axkk02 = g_axg.axg02
                                   AND axkk05 = g_axg.axg05
                                   AND axkk07 = g_axk07
                                   AND axkk08 = tm.yy
                                   AND axkk09 < l_month)
        END CASE
       #-MOD-CC0175-add-
        IF p_type != 'A' THEN 
            LET l_amt1 = l_amt1 * -1
            LET l_amt2 = l_amt2 * -1
        END IF
       #-MOD-CC0175-end-
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        LET l_amt = l_amt2 - l_amt1

        LET l_r = 1
        LET l_r1 = 1
        CALL p001_getrate('3',tm.yy,l_month,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
        RETURNING l_r   
        IF cl_null(l_r) THEN LET l_r = 1 END IF

        CALL p001_getrate('3',tm.yy,l_month,l_axz07,p_axz06) 
        RETURNING l_r1   
        IF cl_null(l_r1) THEN LET l_r1 = 1 END IF

        LET l_amt = l_amt * l_r * l_r1
        LET l_tot_amt = l_tot_amt + l_amt
     END FOREACH

     RETURN l_tot_amt 
END FUNCTION
#----FUN-AB0004 end-----

#---CHI-CC0031 add start----
FUNCTION p001_ins_axj2_chg2(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   
DEFINE l_r         LIKE axp_file.axp05   
DEFINE l_r1        LIKE axp_file.axp05   
DEFINE p_flag      LIKE type_file.chr1   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_axz07     LIKE axf_file.axf09   
DEFINE l_month     LIKE type_file.num5
DEFINE l_amt2      LIKE axh_file.axh08
DEFINE l_amt1      LIKE axh_file.axh08
DEFINE l_amt       LIKE axh_file.axh08

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)

     LET l_tot_amt = 0
     LET l_amt2 = 0
     LET l_amt1 = 0
     LET l_amt  = 0

     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
     IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axg_file or axk_file取各期餘額
     LET l_sql=
     " SELECT axg07,axg12",
     "   FROM axg_file ",
     "  WHERE axg00 = '",g_aaz641,"'",          #合併帳別  
     "    AND axg01 = '",tm.axa01,"'", #族群
     "    AND axg02 = '",g_axg.axg02,"'", #公司
     "    AND axg04 = '",g_axg.axg02,"'", #公司
     "    AND axg05 = '",g_axg.axg05,"'",
     "    AND axg06= '",tm.yy,"'",
     "    AND axg07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
     PREPARE p001_axg_p3 FROM l_sql
     DECLARE p001_axg_c3 CURSOR FOR p001_axg_p3
     FOREACH p001_axg_c3 INTO l_month,l_axg12
        IF l_month = 0 THEN CONTINUE FOREACH END IF
        SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg02
        CASE 
           WHEN p_flag = '1'     
               SELECT SUM(axg08-axg09) INTO l_amt2
                 FROM axg_file 
                WHERE axg00 = g_aaz641        #合併帳別 
                  AND axg01 = tm.axa01        #族群
                  AND axg02 = g_axg.axg02     #公司
                  AND axg04 = g_axg.axg02    
                  AND axg05 = g_axg.axg05
                  AND axg06 = tm.yy
                  AND axg07 = l_month
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axk10-axk11) INTO l_amt2
                 FROM axk_file
                WHERE axk00 = g_aaz641
                  AND axk01 = tm.axa01
                  AND axk02 = g_axg.axg02
                  AND axk04 = g_axg.axg02
                  AND axk05 = g_axg.axg05
                  AND axk07 = g_axk07
                  AND axk08 = tm.yy
                  AND axk09 = l_month
        END CASE
        CASE 
           WHEN p_flag = '1'      
               SELECT SUM(axg08-axg09) INTO l_amt1
                 FROM axg_file
                WHERE axg00 = g_aaz641        #合併帳別 
                  AND axg01 = tm.axa01        #族群
                  AND axg02 = g_axg.axg02     #公司
                 #AND axg04 = g_axg.axg04     #MOD-CC0089 mark
                  AND axg04 = g_axg.axg02     #MOD-CC0089 add
                  AND axg05 = g_axg.axg05
                  AND axg06 = tm.yy
                  AND axg07 = (SELECT MAX(axg07) FROM axg_file
                                WHERE axg00 = g_aaz641        #合併帳別 
                                  AND axg01 = tm.axa01        #族群
                                  AND axg02 = g_axg.axg02     #公司
                                  AND axg04 = g_axg.axg02     #公司
                                  AND axg05 = g_axg.axg05
                                  AND axg06 = tm.yy
                                  AND axg07 < l_month)
           WHEN p_flag = '2'  
               SELECT SUM(axk10-axk11) INTO l_amt1
                 FROM axk_file
                WHERE axk00 = g_aaz641
                  AND axk01 = tm.axa01
                  AND axk02 = g_axg.axg02
                  AND axk04 = g_axg.axg02
                  AND axk05 = g_axg.axg05
                  AND axk07 = g_axk07
                  AND axk08 = tm.yy
                  AND axk09 = (SELECT MAX(axk09) FROM axkk_file
                                 WHERE axk00 = g_aaz641
                                   AND axk01 = tm.axa01
                                   AND axk02 = g_axg.axg02
                                   AND axk04 = g_axg.axg02
                                   AND axk05 = g_axg.axg05
                                   AND axk07 = g_axk07
                                   AND axk08 = tm.yy
                                   AND axk09 < l_month)
        END CASE

        IF p_type != 'A' THEN 
            LET l_amt1 = l_amt1 * -1
            LET l_amt2 = l_amt2 * -1
        END IF

        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        LET l_amt = l_amt2 - l_amt1

        LET l_r = 1
        LET l_r1 = 1
        CALL p001_getrate('3',tm.yy,l_month,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
        RETURNING l_r   
        IF cl_null(l_r) THEN LET l_r = 1 END IF

        CALL p001_getrate('3',tm.yy,l_month,l_axz07,p_axz06) 
        RETURNING l_r1   
        IF cl_null(l_r1) THEN LET l_r1 = 1 END IF

        LET l_amt = l_amt * l_r * l_r1
        LET l_tot_amt = l_tot_amt + l_amt
     END FOREACH

     RETURN l_tot_amt 
END FUNCTION
#--CHI-CC0031 add end------------------
#FUN-AC0051 --Begin
FUNCTION p001_getrate1(p_aag04,p_axz06,p_axz07)
DEFINE p_aah01       LIKE aah_file.aah01
DEFINE p_axz06       LIKE axz_file.axz07
DEFINE p_axz07       LIKE axz_file.axz07
DEFINE p_aag04       LIKE aag_file.aag04
DEFINE l_bm          LIKE type_file.num5
DEFINE l_month_count LIKE type_file.num5
DEFINE l_sum_axp07   LIKE axp_file.axp07
DEFINE l_rate        LIKE axp_file.axp05
   IF p_aag04 = '1' THEN
      LET l_bm = 0
   ELSE
      LET l_bm = 1
   END IF
   SELECT SUM(axp07) INTO l_sum_axp07
     FROM axp_file
    WHERE axp01 = tm.yy
      AND axp03 = p_axz06
      AND axp04 = p_axz07
      AND axp02 BETWEEN l_bm AND tm.em
      AND (axp07 IS NOT NULL AND axp07<>0)
   SELECT COUNT(axp07) INTO l_month_count
     FROM axp_file
    WHERE axp01 = tm.yy
      AND axp03 = p_axz06
      AND axp04 = p_axz07
      AND axp02 BETWEEN l_bm AND tm.em
      AND (axp07 IS NOT NULL AND axp07<>0)
     
   LET l_rate = l_sum_axp07/l_month_count
   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
   RETURN l_rate
END FUNCTION
#FUN-AC0051 --End

#---FUN-B90069 start------
FUNCTION p001_axf01_axh(p_axf01,i) 
DEFINE i         LIKE type_file.num5
DEFINE p_axf01   LIKE axf_file.axf01
DEFINE l_sql     STRING
DEFINE l_cnt1    LIKE type_file.num5
DEFINE l_axf09   LIKE axf_file.axf09
DEFINE l_axz05   LIKE axz_file.axz05    #MOD-CA0135 add

     #Ex: A(母公司) , B(中間層母公司) ,C(最下層子公司)
     #B公司可由agli003設定公式計算出對C公司投股的少數股權科餘，
     #(agli003沖銷設定來源B，目的C，合併主體B)
     #透過aglp002執行後寫入axh,axkk中(寫入後axh02=B,axh04=B)
     #但A公司的長投要沖銷C公司的少數股權時，
     #如果設定agli003沖銷設定來源A，目的B，合併主體A會沖不到B對C公司的少數股權
     #所以應設定來源A,目的C，合併主體A
     #但axh,axkk中並沒有存在axh02=C,axh04=C的資料，只有axh02=B,axh04=B
     #所以先以當下的公司(axf09) 為條件找看看有無存在axh/axkk科餘中
     #如果找不到時，再以上層公司為條件找axh/axkk科餘
     #p001_axf01_axh(),p001_axf02_axh(),皆為相同處理方式

     IF g_axf.axf15 = '1' THEN  
         LET l_sql =" SELECT COUNT(*) ",
                    "   FROM axh_file ",
                    "  WHERE axh01 = '",g_axa[i].axa01,"' ",   #群組
                    "    AND axh00 = '",g_aaz641_axf09,"' ",   #合併帳別   
                    "    AND axh04 = ? ",      #來源公司
                    "    AND axh06 = ",tm.yy,                 #年度
                    "    AND axh07 = '",tm.em,"'",            #只抓截止期別的金額
                    "    AND axh05 = '",p_axf01,"'"
     ELSE
         LET l_sql =" SELECT COUNT(*) ",
                    "   FROM axkk_file ",
                    "  WHERE axkk01 = '",g_axa[i].axa01,"' ",    #群組
                    "    AND axkk00 = '",g_aaz641_axf09,"' ",   
                    "    AND axkk04 = ? ",       #來源公司
                    "    AND axkk08 = ",tm.yy,                  #年度
                    "    AND axkk07 = '",g_axz08_axf10 ,"'",    
                    "    AND axkk09 = '",tm.em,"'",           
                    "    AND axkk05 = '",p_axf01,"'"
     END IF
     #先以目前設定的來源公司為條件找尋是否有存在axh/axkk科餘
     LET l_axf09 = g_axf.axf09
     LET l_cnt1 = 0
     PREPARE p001_axf01_axh_p1 FROM l_sql
     DECLARE p001_axf01_axh_c1 CURSOR FOR p001_axf01_axh_p1
     OPEN p001_axf01_axh_c1 USING g_axf.axf09
     FETCH p001_axf01_axh_c1 INTO l_cnt1

     #以當下的來源公司找不到axh,axkk資料
     #先判斷目前公司是否為上層母公司
     #IF 屬於上層公司(g_cnt_axf09 > 0) THEN
     #    IF 屬於最上層母公司(g_low_axf09 = 0) THEN
     #       取axh_file/axkk_file時直接用目前的axf09為條件
     #    ELSE
     #       屬於中間層母公司時，先取出其上層公司，再以其上層公司為條件帶入axf09
     #    END IF
     #ELSE
     #    屬於最下層的子公司 THEN
     #    先取出其上層公司，再以其上層公司為條件帶入axf09
     #END IF

     IF l_cnt1 = 0 THEN           
         CLOSE p001_axf01_axh_c1          
         IF g_cnt_axf09 > 0 THEN            #屬於上層公司
             IF g_low_axf09 = 0 THEN        #屬於最上層母公司
                 LET l_axf09 = g_axf.axf09
             ELSE                           #屬於中間層母公司
                 LET l_axf09 = g_axa02_axf09
             END IF
         ELSE                               #屬於最下層子公司
             LET l_axf09 = g_axa02_axf09
         END IF  
     END IF
     LET l_axz05 = g_axf09_axz05             #MOD-CA0135 add
    #-----------------MOD-C30083--------------------start
     SELECT axz05 INTO g_axf09_axz05 
       FROM axz_file
      WHERE axz01 = l_axf09 
    #-----------------MOD-C30083----------------------end

     IF g_axf.axf15 = '1' THEN  
         LET l_sql =" SELECT 'A','1',axh06,axh07,axh05,axh02,axh04,(axh08-axh09),",
                    "         axh12,'",g_axz08_axf10,"','2','N','' ",  
                    "   FROM axh_file ",
                    "  WHERE axh01 ='",g_axa[i].axa01,"' ",   #群組
                    "    AND axh00 ='",g_aaz641_axf09,"' ",   #合併帳別   
                    "    AND axh04 ='",l_axf09,"' ",          #來源公司
                    "    AND axh041='",g_axf09_axz05,"' ",    #來源帳別   
                    "    AND axh06 = ",tm.yy,                 #年度
                    "    AND axh07 = '",tm.em,"'",            #只抓截止期別的金額
                    "    AND axh05 = '",p_axf01,"'"
     ##-------axf15 = '2' 來源科目檔案資料來源:axkk_file
     ELSE
         LET l_sql =" SELECT 'A','2',axkk08,axkk09,axkk05,axkk02,axkk04,(axkk10-axkk11), ",  
                    "        axkk14,'",g_axz08_axf10,"','2','N',axkk07 ", 
                    "   FROM axkk_file ",
                    "  WHERE axkk01 ='",g_axa[i].axa01,"' ",    #群組
                    "    AND axkk00 ='",g_aaz641_axf09,"' ",   
                    "    AND axkk04 ='",l_axf09,"' ",           #來源公司
                    "    AND axkk041='",g_axf09_axz05,"' ",     #來源帳別   
                    "    AND axkk08 = ",tm.yy,                  #年度
                    "    AND axkk07 = '",g_axz08_axf10 ,"'",    
                    "    AND axkk09 = '",tm.em,"'",           
                    "    AND axkk05 = '",p_axf01,"'"
     END IF
     LET g_axf09_axz05 = l_axz05                                #MOD-CA0135 add
     RETURN l_sql
END FUNCTION

FUNCTION p001_axf01_axg(p_axf01,i) 
DEFINE p_axf01  LIKE axf_file.axf01
DEFINE l_sql    STRING
DEFINE i        LIKE type_file.num5

     #--#資料來源為axg_file
     IF g_axf.axf15 = '1' THEN        
         LET l_sql =" SELECT 'A','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09),", 
                    "         axg12,'",g_axz08_axf10,"','2','N','' ",
         "   FROM axg_file ",
         "  WHERE axg01 ='",g_axa[i].axa01,"' ",   #群組
         "    AND axg00 ='",g_aaz641_axf09,"' ",   #合併帳別 
         "    AND axg04 ='",g_axf.axf09,"' ",      #來源公司
         "    AND axg041='",g_axf09_axz05,"' ",    #來源帳別 
         "    AND axg06 = ",tm.yy,                 #年度
         "    AND axg07 = '",tm.em,"'" ,           #只抓截止期別的金額
         "    AND axg05 = '",p_axf01,"'"
        
         #A.來源公司=合併主體：(順流)
         #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
         #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
             #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axg02、axg04都抓自己(axf09)
         #   #2.中間層(有上層也有下層),
         #   #   a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09)
         #   #   b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
         #    2.中間層(有上層也有下層): 條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
         #  END IF

         IF g_axf.axf09 = g_axf.axf16 THEN    #如果來源公司和合併主體相同,axk02=axf09,axk04=axf09
             LET l_sql = l_sql CLIPPED,
             "    AND axg02 = '",g_axf.axf09,"'" 
         ELSE
             IF g_cnt_axf09 > 0 THEN
                 IF g_low_axf09 = 0 THEN #最上層 
                     LET l_sql = l_sql CLIPPED,
                         "    AND axg02 = '",g_axf.axf09,"'" 
                 ELSE
                    #str MOD-C10035 mod
                    #2.中間層(有上層也有下層): 條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
                    #IF g_axf.axf14 = 'Y' THEN  
                    #    LET l_sql = l_sql CLIPPED,
                    #        "    AND axg02 = '",g_axa02_axf09,"'"   
                    #ELSE                                            
                    #    LET l_sql = l_sql CLIPPED,                  
                    #        "    AND axg02 = '",g_axf.axf09,"'"     
                    #END IF           
                     LET l_sql = l_sql CLIPPED,
                         "    AND axg02 = '",g_axf.axf09,"'"
                    #end MOD-C10035 mod                               
                 END IF
             ELSE
                 LET l_sql = l_sql CLIPPED,
                 "    AND axg02 = '",g_axa02_axf09,"'"      
             END IF  
         END IF
##axf15 = '2' 來源科目檔案資料來源:axk_file
     ELSE
         LET l_sql =" SELECT 'A','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11), ", 
                    "        axk14,'",g_axz08_axf10,"','2','N',axk07 ",     
                    "   FROM axk_file ",
                    "  WHERE axk01 ='",g_axa[i].axa01,"' ",    #群組
                    "    AND axk00 ='",g_aaz641_axf09,"' ",   
                    "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
                    "    AND axk041='",g_axf09_axz05,"' ",     #來源帳別   
                    "    AND axk08 = ",tm.yy,                  #年度
                    "    AND axk07 = '",g_axz08_axf10 ,"'",   
                    "    AND axk09 = '",tm.em,"'",           
                    "    AND axk05 = '",p_axf01,"'"

         #A.來源公司=合併主體：(順流)
         #  來源:axk02 = 自己(axf09), axk04 = 自己(axf09)
         #  目的:axk02 = 不用加入此條件, axk04 = 自己(axf10)
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
         #    1.最上層公司：條件=>axk02 = 自己(axf09), axk04 = 自己(axf09)
             #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axk02、axk04都抓自己(axf09)
         #   #2.中間層(有上層也有下層):
         #   #   a.股本:條件=> axk02 = 自己的上層公司(l_axa_axf09),axk04 = 自己(axf09)
         #   #   b.關係人交易:條件=>axk02 = 自己(axf09),axk04 = 自己(axf09)
         #    2.中間層(有上層也有下層): 條件=>axk02 = 自己(axf09),axk04 = 自己(axf09)
         #  ELSE
         #    1.最下層公司: 條件=>axk02 = 不用加入此條件, axk04 = 自己(axf09)
         #  END IF

         IF g_axf.axf09 = g_axf.axf16 THEN
             LET l_sql = l_sql CLIPPED,
             "    AND axk02 = '",g_axf.axf09,"'" 
         ELSE
             IF g_cnt_axf09 > 0 THEN
                  IF g_low_axf09 = 0 THEN #最上層 
                     LET l_sql = l_sql CLIPPED,
                         "    AND axk02 = '",g_axf.axf09,"'" 
                 ELSE
                    #str MOD-C10035 mod
                    #2.中間層(有上層也有下層): 條件=>axk02 = 自己(axf09),axk04 = 自己(axf09)
                    #IF g_axf.axf14 = 'Y' THEN     
                    #    LET l_sql = l_sql CLIPPED,
                    #        "    AND axk02 = '",g_axa02_axf09,"'" 
                    #ELSE                         
                    #    LET l_sql = l_sql CLIPPED, 
                    #        "    AND axk02 = '",g_axf.axf09,"'"   
                    #END IF
                     LET l_sql = l_sql CLIPPED,
                         "    AND axk02 = '",g_axf.axf09,"'"
                    #end MOD-C10035 mod                                       
                 END IF
             ELSE
                  LET l_sql = l_sql CLIPPED,
                  "    AND axk02 = '",g_axa02_axf09,"'"      
             END IF  
         END IF
     END IF
     RETURN l_sql
END FUNCTION

FUNCTION p001_axf02_axh(p_axf02,i) 
DEFINE p_axf02 LIKE axf_file.axf02
DEFINE i       LIKE type_file.num5
DEFINE l_sql   STRING
DEFINE l_axf10 LIKE axf_file.axf10
DEFINE l_cnt1  LIKE type_file.num5
DEFINE l_axz05   LIKE axz_file.axz05    #MOD-CA0135 add

     #Ex: A(母公司) , B(中間層母公司) ,C(最下層子公司)
     #B公司可由agli003設定公式計算出對C公司投股的少數股權科餘，
     #(agli003沖銷設定來源B，目的C，合併主體B)
     #透過aglp002執行後寫入axh,axkk中(寫入後axh02=B,axh04=B)
     #但A公司的長投要沖銷C公司的少數股權時，
     #如果設定agli003沖銷設定來源A，目的B，合併主體A會沖不到B對C公司的少數股權
     #所以應設定來源A,目的C，合併主體A
     #但axh,axkk中並沒有存在axh02=C,axh04=C的資料，只有axh02=B,axh04=B
     #所以先以當下的公司(axf09) 為條件找看看有無存在axh/axkk科餘中
     #如果找不到時，再以上層公司為條件找axh/axkk科餘
     #p001_axf01_axh(),p001_axf02_axh(),皆為相同處理方式

     IF g_axf.axf17 = '1' THEN  
         LET l_sql =" SELECT COUNT(*) ",
                    "   FROM axh_file ",
                    "  WHERE axh01 = '",g_axa[i].axa01,"' ",
                    "    AND axh00 = '",g_aaz641_axf10,"' ",               
                    "    AND axh04 = ? ",                   #對沖公司
                    "    AND axh041= '",g_axf10_axz05,"' ",                 #對沖帳別  
                    "    AND axh06 = ",tm.yy,
                    "    AND axh07 = '",tm.em,"'",                         
                    "    AND axh05 = '",p_axf02,"'"
     ELSE
         LET l_sql =" SELECT COUNT(*) ",
                    "   FROM axkk_file ",
                    "  WHERE axkk01 = '",g_axa[i].axa01,"' ",
                    "    AND axkk00 = '",g_aaz641_axf10,"' ",   
                    "    AND axkk04 = ? ",      #對沖公司
                    "    AND axkk041= '",g_axf10_axz05,"' ",    #對沖帳別  
                    "    AND axkk08 = ",tm.yy,
                    "    AND axkk07 = '",g_axz08,"'",         
                    "    AND axkk09 = '",tm.em,"'",
                    "    AND axkk05 = '",p_axf02,"'"   
     END IF
     #先以目前設定的來源公司為條件找尋是否有存在axh/axkk科餘
     LET l_axf10 = g_axf.axf10
     LET l_cnt1 = 0
     PREPARE p001_axf02_axh_p1 FROM l_sql
     DECLARE p001_axf02_axh_c1 CURSOR FOR p001_axf02_axh_p1
     OPEN p001_axf02_axh_c1 USING g_axf.axf10
     FETCH p001_axf02_axh_c1 INTO l_cnt1

     #以當下的來源公司找不到axh,axkk資料
     #先判斷目前公司是否為上層母公司
     #IF 屬於上層公司(g_cnt_axf10 > 0) THEN
     #    IF 屬於最上層母公司(g_low_axf10 = 0) THEN
     #       取axh_file/axkk_file時直接用目前的axf10為條件
     #    ELSE
     #       屬於中間層母公司時，先取出其上層公司，再以其上層公司為條件帶入axf10
     #    END IF
     #ELSE
     #    屬於最下層的子公司 THEN
     #    先取出其上層公司，再以其上層公司為條件帶入axf10
     #END IF

     IF l_cnt1 = 0 THEN           
         CLOSE p001_axf02_axh_c1          
         IF g_cnt_axf10 > 0 THEN            #屬於上層公司
             IF g_low_axf10 = 0 THEN        #屬於最上層母公司
                 LET l_axf10 = g_axf.axf10
             ELSE                           #屬於中間層母公司
                 LET l_axf10 = g_axa02_axf10
             END IF
         ELSE                               #屬於最下層子公司
             LET l_axf10 = g_axa02_axf10
         END IF  
     END IF
     LET l_axz05 = g_axf10_axz05                   #MOD-CA0135 add
    #-----------------MOD-C30083--------------------start
     SELECT axz05 INTO g_axf10_axz05
       FROM axz_file
      WHERE axz01 = l_axf10
    #-----------------MOD-C30083----------------------end
     IF g_axf.axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axh_file
         LET l_sql = " SELECT 'B','1',axh06,axh07,axh05,axh02,axh04,(axh08-axh09)*-1,",
                     "        axh12,'",g_axz08,"','1','N','' ",   
                     "   FROM axh_file ",
                     "  WHERE axh01 = '",g_axa[i].axa01,"' ",
                     "    AND axh00 = '",g_aaz641_axf10,"' ",               
                     "    AND axh04 = '",l_axf10,"' ",                   #對沖公司
                     "    AND axh041= '",g_axf10_axz05,"' ",                 #對沖帳別  
                     "    AND axh06 = ",tm.yy,
                     "    AND axh07 = '",tm.em,"'",                         
                     "    AND axh05 = '",p_axf02,"'"
     ELSE                             #axf17 = '2' -->axk_file        
         LET l_sql = " SELECT 'B','2',axkk08,axkk09,axkk05,axkk02,axkk04,(axkk10-axkk11)*-1, ",  
                     "        axkk14,'",g_axz08,"','1','N',axkk07 ",                  
                     "   FROM axkk_file ",
                     "  WHERE axkk01 = '",g_axa[i].axa01,"' ",
                     "    AND axkk00 = '",g_aaz641_axf10,"' ",   
                     "    AND axkk04 = '",l_axf10,"' ",      #對沖公司
                     "    AND axkk041= '",g_axf10_axz05,"' ",    #對沖帳別  
                     "    AND axkk08 = ",tm.yy,
                     "    AND axkk07 = '",g_axz08,"'",         
                     "    AND axkk09 = '",tm.em,"'",
         "    AND axkk05 = '",p_axf02,"'"   
     END IF
     LET g_axf10_axz05 = l_axz05                            #MOD-CA0135 add
     RETURN l_sql
END FUNCTION

FUNCTION p001_axf02_axg(p_axf02,i) 
DEFINE 	p_axf02  LIKE axf_file.axf02  
DEFINE  l_sql    STRING
DEFINE  i        LIKE type_file.num5

  IF g_axf.axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axg_file
      LET l_sql = " SELECT 'B','1',axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,", 
                  "        axg12,'",g_axz08,"','1','N','' ",   
                  "   FROM axg_file ",
                  "  WHERE axg01 ='",g_axa[i].axa01,"' ",
                  "    AND axg00 ='",g_aaz641_axf10,"' ",               
                  "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
                  "    AND axg041='",g_axf10_axz05,"' ",                 #對沖帳別  
                  "    AND axg06 = ",tm.yy,
                  "    AND axg07 = '",tm.em,"'",                         
                  "    AND axg05 = '",p_axf02,"'"

      #A.來源公司=合併主體：(順流)
      #  目的:axg02 = 自己的上層公司(g_axa02_axf10), axg04 = 自己
      #B.來源公司 <> 合併主體：(側流或逆流)
      #  IF 目的屬於上層公司
      #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
          #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axg02、axg04都抓自己(axf10)
      #   #2.中間層(有上層也有下層),
      #   #   a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10)
      #   #   b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
      #    2.中間層(有上層也有下層): 條件=>axg02 = 自己(axf10),axg04 = 自己(axfi10)
      #  ELSE
      #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
      #  END IF

      IF g_cnt_axf10 > 0 THEN
          IF g_low_axf10 = 0 THEN #最上層  
              LET l_sql = l_sql CLIPPED,
                  "    AND axg02 = '",g_axf.axf10,"'"
          ELSE
              IF g_up_axf10 > 0 THEN    #大於0代表不是最下層  
                #str MOD-C10035 mod
                #2.中間層(有上層也有下層): 條件=>axg02 = 自己(axf10),axg04 = 自己(axf10) 
                #IF g_axf.axf14 = 'Y' THEN             
                #   LET l_sql = l_sql CLIPPED,
                #       "    AND axg02 = '",g_axa02_axf10,"'" 
                #ELSE                                 
                #   LET l_sql = l_sql CLIPPED,      
                #       "    AND axg02 = '",g_axf.axf10,"'" 
                #END IF          
                 LET l_sql = l_sql CLIPPED,
                     "    AND axg02 = '",g_axf.axf10,"'"
                #end MOD-C10035 mod                            
              END IF                
          END IF
      ELSE
          LET l_sql = l_sql CLIPPED,
          "    AND axg02 = '",g_axa02_axf10,"'"           
      END IF
  ELSE                             #axf17 = '2' -->axk_file        
      LET l_sql = " SELECT 'B','2',axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1, ", 
                  "        axk14,'",g_axz08,"','1','N',axk07 ",                  
                  "   FROM axk_file ",
                  "  WHERE axk01 ='",g_axa[i].axa01,"' ",
                  "    AND axk00 ='",g_aaz641_axf10,"' ",   
                  "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
                  "    AND axk041='",g_axf10_axz05,"' ",    #對沖帳別  
                  "    AND axk08 = ",tm.yy,
                  "    AND axk07 = '",g_axz08,"'",         
                  "    AND axk09 = '",tm.em,"'",
                  "    AND axk05 = '",p_axf02,"'"   

      #A.來源公司=合併主體：(順流)
      #  目的:axk02 = 不用加入此條件, axk04 = 自己
      #B.來源公司 <> 合併主體：(側流或逆流)
      #  IF 目的屬於上層公司
      #    1.最上層公司：條件=>axk02 = 自己(axf10), axk04 = 自己(axf10)
          #MOD-C10035 mod  中間層的處理邏輯調整,不管是不是股本,axk02、axk04都抓自己(axf10)
      #   #2.中間層(有上層也有下層),
      #   #   a.股本:條件=> axk02 = 自己的上層公司(l_axa_axf10),axk04 = 自己(axf10)
      #   #   b.關係人交易:條件=>axk02 = 自己(axf10),axk04 = 自己(axf10)
      #    2.中間層(有上層也有下層): 條件=>axk02 = 自己(axf10),axk04 = 自己(axfi10)
      #  ELSE
      #    1.最下層公司: 條件=>axk02 = 不用加入此條件, axk04 = 自己(axf10)
      #  END IF

      IF g_cnt_axf10 > 0 THEN
          IF g_low_axf10 = 0 THEN #最上層   
              LET l_sql = l_sql CLIPPED,
                  "    AND axk02 = '",g_axf.axf10,"'"
          ELSE
              IF g_up_axf10 > 0 THEN  
                #str MOD-C10035 mod
                #2.中間層(有上層也有下層): 條件=>axk02 = 自己(axf10),axk04 = 自己(axf10) 
                #IF g_axf.axf14 = 'Y' THEN 
                #   LET l_sql = l_sql CLIPPED,
                #       "    AND axk02 = '",g_axa02_axf10,"'"   
                #ELSE                   
                #   LET l_sql = l_sql CLIPPED,                
                #       "    AND axk02 = '",g_axf.axf10,"'"  
                #END IF                                     
                 LET l_sql = l_sql CLIPPED,
                     "    AND axk02 = '",g_axf.axf10,"'"
                #end MOD-C10035 mod 
              END IF   
          END IF
      ELSE
          LET l_sql = l_sql CLIPPED,
             "    AND axk02 = '",g_axa02_axf10,"'"       
      END IF
  END IF
  RETURN l_sql
END FUNCTION

FUNCTION p001_ins_temp(p_sql,i)
DEFINE p_sql          STRING
DEFINE i              LIKE type_file.num5
DEFINE l_axz06_axf16  LIKE axz_file.axz06
DEFINE l_aag04        LIKE aag_file.aag04
DEFINE l_axe12        LIKE axe_file.axe12    #CHI-C30001
DEFINE l_axr02        LIKE axr_file.axr02    #CHI-C30001
DEFINE l_axz07_axf16  LIKE axz_file.axz07    #CHI-C40012 add
DEFINE l_sql          STRING                 #FUN-CA0085
DEFINE l_axg08        LIKE axg_file.axg08    #MOD-CC0176 add
DEFINE l_axz10_axf16  LIKE axz_file.axz10    #CHI-D20029
DEFINE l_ayf10        LIKE ayf_file.ayf10    #FUN-D20048 add
DEFINe l_ayf11        LIKE ayf_file.ayf11    #FUN-D20048 add

     PREPARE p001_axg_misc_p1 FROM p_sql
     IF STATUS THEN 
        LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa02,"/",g_axa[i].axa03,"/",tm.yy                                  
        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
        LET g_success = 'N'  
     END IF 
     DECLARE p001_axg_misc_c1 CURSOR FOR p001_axg_misc_p1
     FOREACH p001_axg_misc_c1 INTO g_type,g_flag,g_axg.axg06,g_axg.axg07,g_axg.axg05, #g_type:A.來源/B.目的 g_flag:1.aej/2.aek
                              g_axg.axg02,g_axg.axg04,g_axg.axg08,
                              g_axg.axg12, 
                              g_affil,g_dc,g_flag_r,g_axk07
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=g_axa[i].axa01,"/",g_axa[i].axa01,"/",g_axa[i].axa01,"/",tm.yy                               
          CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'p001_axg_misc_1',SQLCA.sqlcode,1) 
          LET g_success = 'N' 
          CONTINUE FOREACH  
       END IF
   
       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

       #--寫入temp table之前先判斷幣別是否同於合併主體
       #不相同時如果為損益類科目且axa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
       #SELECT axz06 INTO l_axz06_axf16                      #CHI-D20029 mark
       SELECT axz06,axz10 INTO l_axz06_axf16,l_axz10_axf16   #CHI-D20029 add    
         FROM axz_file
        WHERE axz01 = g_axf.axf16   #合併主體幣別
       IF g_axg.axg12 != l_axz06_axf16 THEN 
         #-CHI-C30001-mark-
         #SELECT aag04 INTO l_aag04
         # FROM aag_file
         # WHERE aag00=g_aaz641
         #   AND aag01=g_axg.axg05
         ##依科目性質來判斷取"現時"或"平均"匯率
         #IF l_aag04 = '1' THEN   
         #-CHI-C30001-add-
          LET l_axe12 = ''
          IF g_type = 'A' THEN
             IF l_axz10_axf16 ='N' OR cl_null(l_axz10_axf16) THEN   #CHI-D20029 add
             DECLARE p001_axe12_c1 SCROLL CURSOR FOR
                SELECT axe12   
                  FROM axe_file
                 WHERE axe00 = g_axf09_axz05
                   AND axe01 = g_axf.axf09
                   AND axe06 = g_axg.axg05
                   AND axe13 = tm.axa01
             OPEN p001_axe12_c1 
             FETCH FIRST p001_axe12_c1 INTO l_axe12    
             ELSE                                                   #CHI-D20029 add
             #--FUN-CA0085 start--
             #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                 #IF cl_null(l_axe12) THEN                              #CHI-D20029 mark 
                 LET l_sql = "SELECT ayf08",
                             " FROM ayf_file",    
                             "  WHERE ayf01 = '",g_axf.axf09,"'",
                             "    AND ayf06 = '",g_axg.axg05,"'",
                             "    AND ayf00 = '",g_axf09_axz05,"'", 
                             "    AND ayf09 = '",tm.axa01,"'",
                             "    AND ayf10 =  ",g_axg.axg06,           #FUN-D20048 add
                             "    AND ayf11 =  ",g_axg.axg07            #FUN-D20048 add
                 PREPARE p001_ayf_p6 FROM l_sql
                 DECLARE p001_ayf_c6 SCROLL CURSOR FOR p001_ayf_p6
                 OPEN p001_ayf_c6 
                 FETCH FIRST p001_ayf_c6 INTO l_axe12
                 CLOSE p001_ayf_c6
                 #FUN-D20048 add begin---
                 IF cl_null(l_axe12) THEN
                    SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                      FROM ayf_file
                     WHERE ayf01 = g_dept[i].axb04
                       AND ayf09 = tm.axa01
                    LET l_sql = "SELECT ayf08",
                                " FROM ayf_file",
                                "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                "    AND ayf09 = '",tm.axa01,"'",
                                "    AND ayf10 =  ",l_ayf10,
                                "    AND ayf11 =  ",l_ayf11
                    PREPARE p001_ayf_p13 FROM l_sql
                    DECLARE p001_ayf_c13 SCROLL CURSOR FOR p001_ayf_p13
                    OPEN p001_ayf_c13
                    FETCH FIRST p001_ayf_c13 INTO l_axe12
                    CLOSE p001_ayf_c13
                 ENd IF
                 #FUN-D20048 add end-----
             END IF
             #---FUN-CA0085 end--
             LET l_axr02 = g_axf.axf09
          ELSE
              IF l_axz10_axf16 ='N' OR cl_null(l_axz10_axf16) THEN   #CHI-D20029 add
              DECLARE p001_axe12_c2 SCROLL CURSOR FOR
                 SELECT axe12   
                   FROM axe_file
                  WHERE axe00 = g_axf10_axz05
                    AND axe01 = g_axf.axf10
                    AND axe06 = g_axg.axg05
                    AND axe13 = tm.axa01
              OPEN p001_axe12_c2 
              FETCH FIRST p001_axe12_c2 INTO l_axe12                 
              ELSE                                                   #CHI-D20029 add
              #--FUN-CA0085 start--
              #匯率的取法邏輯 1.先取axe_file(axe11,axe12)  2.取ayf_file(ayf07,ayf08)
                  #IF cl_null(l_axe12) THEN                              #CHI-D20029 mark 
                  LET l_sql = "SELECT ayf08",
                              " FROM ayf_file",    
                              "  WHERE ayf01 = '",g_axf.axf10,"'",
                              "    AND ayf06 = '",g_axg.axg05,"'",
                              "    AND ayf00 = '",g_axf10_axz05,"'", 
                              "    AND ayf09 = '",tm.axa01,"'",
                              "    AND ayf10 =  ",g_axg.axg06,           #FUN-D20048 add
                              "    AND ayf11 =  ",g_axg.axg07            #FUN-D20048 add
                  PREPARE p001_ayf_p7 FROM l_sql
                  DECLARE p001_ayf_c7 SCROLL CURSOR FOR p001_ayf_p7
                  OPEN p001_ayf_c7 
                  FETCH FIRST p001_ayf_c7 INTO l_axe12
                  CLOSE p001_ayf_c7
                  #FUN-D20048 add begin---
                  IF cl_null(l_axe12) THEN
                     SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                       FROM ayf_file
                      WHERE ayf01 = g_dept[i].axb04
                        AND ayf09 = tm.axa01
                     LET l_sql = "SELECT ayf08",
                                 " FROM ayf_file",
                                 "  WHERE ayf01 = '",g_dept[i].axb04,"'",
                                 "    AND ayf09 = '",tm.axa01,"'",
                                 "    AND ayf10 =  ",l_ayf10,
                                 "    AND ayf11 =  ",l_ayf11
                     PREPARE p001_ayf_p14 FROM l_sql
                     DECLARE p001_ayf_c14 SCROLL CURSOR FOR p001_ayf_p14
                     OPEN p001_ayf_c14
                     FETCH FIRST p001_ayf_c14 INTO l_axe12
                     CLOSE p001_ayf_c14
                  ENd IF
                  #FUN-D20048 add end-----
              END IF
              #---FUN-CA0085 end--
              LET l_axr02 = g_axf.axf10
          END IF           
          CASE l_axe12
             WHEN '1'
         #-CHI-C30001-end-
               CALL p001_getrate('1',tm.yy,tm.em,
                                 g_axg.axg12,l_axz06_axf16)  
               RETURNING l_rate
               LET g_axg.axg08 = g_axg.axg08  * l_rate  
         #ELSE   #CHI-C30001 mark 
            #-CHI-C30001-add-
             WHEN '2'   
               #SELECT SUM(axr13) INTO g_axg.axg08              #MOD-CC0176 mark
                SELECT SUM(axr13) INTO l_axg08                  #MOD-CC0176 add
                  FROM axr_file,aag_file  
                 WHERE axr01 = tm.axa01 AND axr02 = l_axr02 
                   AND axr07 = g_axg.axg05
                   AND axr06 <= g_date_e  #異動日期
                   AND axr07 = aag01                   
                   AND aag00 = g_aaz641
               #----------------MOD-CC0176----------------------(S)
                IF cl_null(l_axg08) THEN
                   CALL p001_getrate('2',tm.yy,tm.em,
                                     g_axg.axg12,l_axz06_axf16)
                   RETURNING l_rate
                   LET g_axg.axg08 = g_axg.axg08  * l_rate
                ELSE
                   LET g_axg.axg08 = l_axg08
                END IF 
               #----------------MOD-CC0176----------------------(E)
             WHEN '3'   
            #-CHI-C30001-end-
                #IF (g_axa05 <> '1') OR (g_axt03 = g_aaz128) OR (g_axt03 = g_aaz129) THEN    #CHI-CC0031 mark
                IF (g_axa05 <> '1') THEN   #CHI-CC0031 mod
                    #--CHI-C40012 mark---
                    #CALL p001_getrate('3',tm.yy,tm.em,
                    #                  g_axg.axg12,l_axz06_axf16)
                    #RETURNING l_rate
                    #--CHI-C40012 mark--
                    
                    #--CHI-C40012 start--
                    IF g_axa05 = '2' THEN
                        SELECT aag04 INTO l_aag04
                          FROM aag_file
                         WHERE aag00=g_aaz641
                           AND aag01=g_axg.axg05
                        CALL p001_getrate1(l_aag04,g_axg.axg12,l_axz06_axf16)
                        RETURNING l_rate
                    ELSE
                        CALL p001_getrate3(l_axe12,g_axg.axg06,g_axg.axg07,
                                           g_axg.axg12,l_axz06_axf16)
                        RETURNING l_rate
                    END IF
                    #--CHI-C40012 end---

                    IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
                    LET g_axg.axg08 = g_axg.axg08  * l_rate 
                ELSE
                    IF g_type = 'A' THEN  
                        IF g_cnt_axf09 > 0 THEN
                            IF (g_axt03 = g_aaz128) OR (g_axt03 = g_aaz129) THEN    #CHI-CC0031 add  #少數股權/少數股權淨利只存在上層公司的合併後科餘(axh or axkk)
                                CALL p001_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                            #--CHI-CC0031 add start--
                            ELSE
                                CALL p001_ins_axj2_chg2(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08  #非少數股權/少數股權淨利科目，則取axg or axk
                            END IF
                            #--CHI-CC0031 add end---
                        ELSE
                            #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                            #來源或目的/aej_file or aek_file/合併主體幣別
                            CALL p001_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                        END IF   #FUN-AB0004
                    ELSE
                        IF g_cnt_axf10 > 0 THEN    #大於0代表不是最下層,資料來源->axkk_file or axh_file  
                            IF (g_axt03 = g_aaz128) OR (g_axt03 = g_aaz129) THEN    #CHI-CC0031 add  #少數股權/少數股權淨利只存在上層公司的合併後科餘(axh or axkk)
                                CALL p001_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                            #--CHI-CC0031 add start--
                            ELSE
                                CALL p001_ins_axj2_chg2(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08  #非少數股權/少數股權淨利科目，則取axg or axk
                            END IF
                            #--CHI-CC0031 add end---
                        ELSE
                            #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                            #來源或目的/aej_file or aek_file/合併主體幣別
                            CALL p001_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_axg.axg08
                        END IF   
                    END IF  
                END IF  
          END CASE   #CHI-C30001
         #END IF     #CHI-C30001 mark
       END IF

       #先將資料寫進TempTable裡 
       EXECUTE insert_prep USING g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                 g_axg.axg02,g_axg.axg04,g_axg.axg08,
                                 g_axg.axg12,        
                                 g_affil,g_dc,g_flag_r
         IF g_axg.axg05 = g_aaz128 THEN 
             DISPLAY p_sql 
         END IF
     END FOREACH
END FUNCTION


FUNCTION p001_axf02_axg_2(p_axu03,i)
DEFINE l_sql    STRING
DEFINE p_axu03  LIKE axu_file.axu03
DEFINE i        LIKE type_file.num5

    LET l_sql =
    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09),",   
    "        axg12,'",g_axz08_axf10,"','2','Y' ",
    "   FROM axg_file ",
    "  WHERE axg01 ='",g_axa[i].axa01,"' ",
    "    AND axg00 ='",g_aaz641_axf10,"' ",  
    "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
    "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別  
    "    AND axg06 = ",tm.yy,
    "    AND axg07 = '",tm.em,"'"         
    IF g_cnt_axf10 > 0 THEN
        IF g_low_axf10 = 0 THEN #最上層 
            LET l_sql = l_sql CLIPPED,
                "    AND axg02 = '",g_axf.axf10,"'"
        ELSE
            IF g_up_axf10 > 0 THEN     
                LET l_sql = l_sql CLIPPED,
                    "    AND axg02 = '",g_axa02_axf10,"'"
            END IF
       END IF
    ELSE
        LET l_sql = l_sql CLIPPED,
        "    AND axg02 = '",g_axa02_axf10,"'"   
    END IF
    LET l_sql = l_sql CLIPPED,
    "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
    "                   WHERE axu00 = '",g_aaz641_axf09,"'",
    "                     AND axu01 = '",g_axf.axf02,"'",
    "                     AND axu09 = '",g_axf.axf09,"'",
    "                     AND axu10 = '",g_axf.axf10,"'",
    "                     AND axu12 = '",g_aaz641_axf10,"'", 
    "                     AND axu13 = '",g_axf.axf13,"'",
    "                     AND axu05 = '+'",
    "                     AND axu03 = '",p_axu03,"')",
    "  UNION ",
    " SELECT axg06,axg07,axg05,axg02,axg04,(axg08-axg09)*-1,", 
    "        '",g_axz06_axf10,"','",g_axz08_axf10,"','2','Y' ", 
    "   FROM axg_file ",
    "  WHERE axg01 ='",g_axa[i].axa01,"' ",
    "    AND axg00 ='",g_aaz641_axf10,"' ",  
    "    AND axg04 ='",g_axf.axf10,"' ",     #對沖公司
    "    AND axg041='",g_axf10_axz05,"' ",   #對沖帳別  
    "    AND axg06 = ",tm.yy,
    "    AND axg07 = '",tm.em,"'",          
    "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
    "                   WHERE axu00 = '",g_aaz641_axf09,"'",   
    "                     AND axu01 = '",g_axf.axf02,"'",
    "                     AND axu09 = '",g_axf.axf09,"'",
    "                     AND axu10 = '",g_axf.axf10,"'",
    "                     AND axu12 = '",g_aaz641_axf10,"'",   
    "                     AND axu13 = '",g_axf.axf13,"'",
    "                     AND axu05 = '-'",
    "                     AND axu03 = '",p_axu03,"')"
    IF g_cnt_axf10 > 0 THEN
        IF g_low_axf10 = 0 THEN #最上層 
            LET l_sql = l_sql CLIPPED,
                "    AND axg02 = '",g_axf.axf10,"'" ,
                "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
        ELSE
            IF g_up_axf10 > 0 THEN     
                LET l_sql = l_sql CLIPPED,
                    "    AND axg02 = '",g_axa02_axf10,"'",  
                    "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
            END IF
       END IF
    ELSE
        LET l_sql = l_sql CLIPPED,
            "    AND axg02 = '",g_axa02_axf10,"'",      
            "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
    END IF
    RETURN l_sql
END FUNCTION

FUNCTION p001_axf02_axk(p_axu03,i)
DEFINE l_sql    STRING
DEFINE p_axu03  LIKE axu_file.axu03
DEFINE i        LIKE type_file.num5

      LET l_sql =
      " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11),",  
      "        axk14,'",g_axf.axf10,"','2','Y' ",
      "   FROM axk_file ",
      "  WHERE axk01 ='",g_axa[i].axa01,"' ",
      "    AND axk00 ='",g_aaz641_axf10,"' ",  
      "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
      "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    
      "    AND axk07 = '",g_axz08,"'",      
      "    AND axk08 = ",tm.yy,
      "    AND axk09 = '",tm.em,"'"     
      IF g_cnt_axf10 > 0 THEN
          IF g_low_axf10 = 0 THEN #最上層  
              LET l_sql = l_sql CLIPPED,
                  "    AND axk02 = '",g_axf.axf10,"'"
          ELSE
              IF g_up_axf10 > 0 THEN      
                  LET l_sql = l_sql CLIPPED,
                      "    AND axk02 = '",g_axa02_axf10,"'"  
              END IF
          END IF
      ELSE
          LET l_sql = l_sql CLIPPED,
          "    AND axk02 = '",g_axa02_axf10,"'"             
      END IF
      LET l_sql = l_sql CLIPPED,
      "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
      "                   WHERE axu00 = '",g_aaz641_axf09,"'",   
      "                     AND axu01 = '",g_axf.axf02,"'",
      "                     AND axu09 = '",g_axf.axf09,"'",
      "                     AND axu10 = '",g_axf.axf10,"'",
      "                     AND axu12 = '",g_aaz641_axf10,"'",   
      "                     AND axu13 = '",g_axf.axf13,"'",　
      "                     AND axu05 = '+'",
      "                     AND axu03 = '",p_axu03,"')",
      "  UNION ",
      " SELECT axk08,axk09,axk05,axk02,axk04,(axk10-axk11)*-1,", 
      "        axk14,'",g_axz08_axf10,"','2','Y' ", 
      "   FROM axk_file ",
      "  WHERE axk01 ='",g_axa[i].axa01,"' ",
      "    AND axk00 ='",g_aaz641_axf10,"' ", 
      "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
      "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別   
      "    AND axk08 = ",tm.yy,
      "    AND axk07 = '",g_axz08,"'", 
      "    AND axk09 = '",tm.em,"'",  
      "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
      "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
      "                     AND axu01 = '",g_axf.axf02,"'",
      "                     AND axu09 = '",g_axf.axf09,"'",
      "                     AND axu10 = '",g_axf.axf10,"'",
      "                     AND axu12 = '",g_aaz641_axf10,"'", 
      "                     AND axu13 = '",g_axf.axf13,"'",
      "                     AND axu05 = '-'",
      "                     AND axu03 = '",p_axu03,"')"
      IF g_cnt_axf10 > 0 THEN
          IF g_low_axf10 = 0 THEN #最上層  
              LET l_sql = l_sql CLIPPED,
                  "    AND axk02 = '",g_axf.axf10,"'" ,
                  "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
          ELSE
              IF g_up_axf10 > 0 THEN      
                  LET l_sql = l_sql CLIPPED,
                      "    AND axk02 = '",g_axa02_axf10,"'", 
                      "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
              END IF
          END IF
      ELSE
          LET l_sql = l_sql CLIPPED,
          "    AND axk02 = '",g_axa02_axf10,"'"  
      END IF
      RETURN l_sql
END FUNCTION
#--FUN-B90069 end--------
#FUN-BA0111--
FUNCTION p001_get_aei23(l_aei00,l_aei01,l_aei02,l_aei021,l_aei03,l_aei031,l_aei04,l_aei05,l_aei06,l_aei07,l_aei08,l_aei09,l_aei10,l_aei18,l_aei19,l_aei20,l_aei21,l_aei22)
DEFINE l_aei00   LIKE aei_file.aei00
DEFINE l_aei01   LIKE aei_file.aei01
DEFINE l_aei02   LIKE aei_file.aei02
DEFINE l_aei021  LIKE aei_file.aei021
DEFINE l_aei03   LIKE aei_file.aei03
DEFINE l_aei031  LIKE aei_file.aei031
DEFINE l_aei04   LIKE aei_file.aei04
DEFINE l_aei05   LIKE aei_file.aei05
DEFINE l_aei06   LIKE aei_file.aei06
DEFINE l_aei07   LIKE aei_file.aei07
DEFINE l_aei08   LIKE aei_file.aei08
DEFINE l_aei09   LIKE aei_file.aei09
DEFINE l_aei10   LIKE aei_file.aei10
DEFINE l_aei18   LIKE aei_file.aei18
DEFINE l_aei19   LIKE aei_file.aei19
DEFINE l_aei20   LIKE aei_file.aei20
DEFINE l_aei21   LIKE aei_file.aei21
DEFINE l_aei22   LIKE aei_file.aei22
DEFINE l_aei23   LIKE aei_file.aei23
DEFINE l_aei24   LIKE aei_file.aei24
DEFINE l_str     STRING

   LET l_str   = l_aei00
   LET l_aei23 = l_str.trim()
   LET l_str   = l_aei01 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei02 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei021
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei03 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei031
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei04 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei05 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei06 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei07 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei08 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei09 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei10 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()
   LET l_str   = l_aei18 
   LET l_aei23 = l_aei23 CLIPPED,l_str.trim()

   LET l_str   = l_aei19 
   LET l_aei24 = l_str.trim()
   LET l_str   = l_aei20 
   LET l_aei24 = l_aei24 CLIPPED,l_str.trim()
   LET l_str   = l_aei21 
   LET l_aei24 = l_aei24 CLIPPED,l_str.trim()
   LET l_str   = l_aei22 
   LET l_aei24 = l_aei24 CLIPPED,l_str.trim()
   IF cl_null(l_aei23) THEN LET l_aei23 = ' ' END IF
   IF cl_null(l_aei24) THEN LET l_aei24 = ' ' END IF
   RETURN l_aei23,l_aei24
END FUNCTION
#FUN-BA0111--
#FUN-C50084--
FUNCTION p001_get_aaz129(i)
DEFINE l_axj07   LIKE axj_file.axj07,
       l_axj071  LIKE axj_file.axj07,   #本期金額
       l_axj072  LIKE axj_file.axj07,   #上期金額
       l_sql     STRING,               
       i         LIKE type_file.num5, 
       j         LIKE type_file.num5, 
       k         LIKE type_file.num5
DEFINE l_axbb06  LIKE axbb_file.axbb06,
       l_axbb07  LIKE axbb_file.axbb07,
       l_bdate   LIKE type_file.dat,
       l_edate   LIKE type_file.dat,
       l_day1    LIKE type_file.num5,
       l_day2    LIKE type_file.num5, 
       l_period  LIKE type_file.num5,
       l_axz03   LIKE axz_file.axz03,
       l_axf02   STRING,
       l_axt04   LIKE axt_file.axt04
DEFINE l_date    DYNAMIC ARRAY OF RECORD
         mm      LIKE type_file.num5,
         bdate   LIKE axbb_file.axbb06,
         axbb07  LIKE axbb_file.axbb07,
         period  LIKE type_file.num5
                 END RECORD 

  #抓對沖的就好
   FOR j =1 TO tm.em
      LET l_axj07 = 0
      LET l_axf02 = g_axf.axf02
      LET l_axf02 = l_axf02.substring(1,4)
      #依來源科目設定為MISC或非MISC判斷取合併前科餘(axg/axk)或合併後科餘(axh/axkk)
      #IF l_axf02 <> 'MISC'<--代表少數股權淨利科目是設定在agli003畫面的axf02一欄
      #直接以axf02的科目取axh or axkk(要依axf17判斷)
      IF l_axf02 <> 'MISC' THEN   
         IF g_axf.axf17 = '1' THEN
            CALL p001_aaz129_axh(g_aaz129,i,j) RETURNING l_axj07
         ELSE
            CALL p001_aaz129_axkk(g_aaz129,i,j) RETURNING l_axj07
         END IF
      ELSE
         #IF l_axf02  =  'MISC' ，代表會有二種狀況要判斷 
         # A. 設在agli0032中(axt_file)，但依公式設定(axt04 = 'Y')
         #    要再取出公式設定的科目(axu_file)
         # B. 設在agli0032中(axt_file)，但非依公式設定(axt04 = 'N')
         #    以agli0032中設定的少數股權淨利科目，取axh/axkk即可(要依axf17判斷)
         # 以下先取出「少數股權淨利」科目在axt04的設定為Y OR N

         LET l_sql = "SELECT axt04 FROM axt_file ",
                     " WHERE axt00 = '",g_aaz641_axf09,"'",
                     "   AND axt01 = '",g_axf.axf02,"'",
                     "   AND axt09 = '",g_axf.axf09,"'",
                     "   AND axt10 = '",g_axf.axf10,"'",
                     "   AND axt12 = '",g_aaz641_axf10,"'",
                     "   AND axt13 = '",g_axf.axf13,"'",
                     "   AND axt03 = '",g_aaz129,"'" 
         PREPARE p001_aaz129_p1 FROM l_sql
         DECLARE p001_aaz129_c1 CURSOR FOR p001_aaz129_p1
         OPEN p001_aaz129_c1
         FETCH p001_aaz129_c1 INTO l_axt04
         IF cl_null(l_axt04) THEN LET l_axt04 = 'N' END IF
        #依公式計算
         IF l_axt04 = 'Y' THEN
            IF g_axf.axf17 = '1' THEN    #取axg_file(無異動碼科餘)
               CALL p001_aaz129_axg(g_aaz129,i,j) RETURNING l_axj07
            ELSE                         #取axk_file(異動碼科餘)
               CALL p001_aaz129_axk(g_aaz129,i,j) RETURNING l_axj07
            END IF
        #非公式計算只有一筆資料
         ELSE
            IF g_axf.axf17 = '1' THEN
               CALL p001_aaz129_axh(g_aaz129,i,j) RETURNING l_axj07
            ELSE
               CALL p001_aaz129_axkk(g_aaz129,i,j) RETURNING l_axj07
            END IF
         END IF
      END IF
      EXECUTE insert_prep_aaz129 USING tm.yy,j,l_axj07
   END FOR
  #計算持股比例的月份寫入l_date陣列
   FOR j=1  TO tm.em
      CALL s_ymtodate(tm.yy,j,tm.yy,j) RETURNING l_bdate,l_edate
      CALL l_date.appendElement()
      LET l_date[l_date.getLength()].mm = j
      LET l_date[l_date.getLength()].bdate = l_bdate     #第一筆寫入本年度第一天
      LET l_date[l_date.getLength()].axbb07 = 0
      CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03
     #依據tm.axa06寫入期別
      CASE                   #編制合併期別 1.月 2.季 3.半年 4.年
         WHEN tm.axa06='1'   #1.月
            LET l_date[l_date.getLength()].period = j
         WHEN tm.axa06='2'   #2.季
            LET l_sql = "SELECT MONTH(MAX(aznn01)) "
                       ,"  FROM ",cl_get_target_table(l_axz03,'aznn_file')
                       ," WHERE aznn00 = '",tm.axa03,"'"
                       ,"   AND aznn02 = '",tm.yy,"'"
                       ,"   AND aznn03 = (SELECT MAX(aznn03) FROM ",cl_get_target_table(l_axz03,'aznn_file')
                       ,"                  WHERE aznn00 = '",tm.axa03,"'"
                       ,"                    AND aznn02 = '",tm.yy,"'"
                       ,"                    AND aznn04 = '",j,"')"
            PREPARE p001_aaz129_p7 FROM l_sql
            DECLARE p001_aaz129_c7 CURSOR FOR p001_aaz129_p7
            OPEN p001_aaz129_c7
            FETCH p001_aaz129_c7 INTO l_period
            LET l_date[l_date.getLength()].period = l_period
         WHEN tm.axa06='3'   #3.半年
            LET l_sql = "SELECT MONTH(MAX(aznn01)) "
                       ,"  FROM ",cl_get_target_table(l_axz03,'aznn_file')
                       ," WHERE aznn00 = '",tm.axa03,"'"
                       ,"   AND aznn02 = '",tm.yy,"'"
            IF tm.h1 = '1' THEN
               LET l_sql = l_sql CLIPPED, " AND aznn03 < 3 "
            ELSE
               LET l_sql = l_sql CLIPPED, " AND aznn03 >= 3 "
            END IF
            PREPARE p001_aaz129_p8 FROM l_sql
            DECLARE p001_aaz129_c8 CURSOR FOR p001_aaz129_p8
            OPEN p001_aaz129_c8
            FETCH p001_aaz129_c8 INTO l_period
            LET l_date[l_date.getLength()].period = l_period
         WHEN tm.axa06='4'   #4.年
            LET l_sql = "SELECT MONTH(MAX(aznn01)) "
                       ,"  FROM ",cl_get_target_table(l_axz03,'aznn_file')
                       ," WHERE aznn00 = '",tm.axa03,"'"
                       ,"   AND aznn02 = '",tm.yy,"'"
            PREPARE p001_aaz129_p9 FROM l_sql
            DECLARE p001_aaz129_c9 CURSOR FOR p001_aaz129_p9
            OPEN p001_aaz129_c9
            FETCH p001_aaz129_c9 INTO l_period
            LET l_date[l_date.getLength()].period = l_period
      END CASE
      IF j = 1 THEN
         SELECT axbb06,axbb07 INTO l_axbb06,l_axbb07
           FROM axbb_file
          WHERE axbb01 = g_axf.axf13 
          # AND axbb03 = g_aaz641_axf09   #TQC-D30026 MARK
            AND axbb02 = g_axf.axf09 AND axbb04 = g_axf.axf10
          # AND axbb05 = g_aaz641_axf10   #TQC-D30026 MARK
            AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                           WHERE axbb01 = g_axf.axf13
                           # AND axbb03 = g_aaz641_axf09  #TQC-D30026 MARK
                             AND axbb02 = g_axf.axf09 AND axbb04 = g_axf.axf10
                           # AND axbb05 = g_aaz641_axf10  #TQC-D30026 MARK
                             AND axbb06 < l_bdate)
          IF NOT cl_null(l_axbb06) THEN
             LET l_date[l_date.getLength()].axbb07 = l_axbb07
          END IF
      ELSE
         LET l_date[l_date.getLength()].axbb07 = l_date[l_date.getLength()-1].axbb07
      END IF
      LET l_sql = " SELECT axbb06,axbb07 FROM axbb_file"
                 ,"  WHERE axbb01 = '",g_axf.axf13,"'"
                #," AND axbb03 = '",g_aaz641_axf09,"'"    #TQC-D30026 MARK
                 ,"    AND axbb02 = '",g_axf.axf09,"' AND axbb04 = '",g_axf.axf10,"'"
                #,"    AND axbb05 = '",g_aaz641_axf10,"'" #TQC-D30026 MARK
                 ,"    AND axbb06 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
                 ,"  ORDER BY axbb06,axbb07"
      PREPARE p001_aaz129_p4 FROM l_sql
      DECLARE p001_aaz129_c4 CURSOR FOR p001_aaz129_p4
      FOREACH p001_aaz129_c4 INTO l_axbb06,l_axbb07
         IF l_bdate = l_axbb06 THEN
            LET l_date[l_date.getLength()].bdate = l_axbb06
            LET l_date[l_date.getLength()].axbb07 = l_axbb07
         ELSE
            CALL l_date.appendElement()
            LET l_date[l_date.getLength()].mm = j
            LET l_date[l_date.getLength()].bdate = l_axbb06
            LET l_date[l_date.getLength()].axbb07 = l_axbb07
         END IF
      END FOREACH
   END FOR
   
   LET l_axj07 = 0

   FOR j = 1 TO l_date.getLength()
      CALL s_ymtodate(tm.yy,l_date[j].mm,tm.yy,l_date[j].mm) RETURNING l_bdate,l_edate
     #計算期間的總天數
      CASE                   #編制合併期別 1.月 2.季 3.半年 4.年
         WHEN tm.axa06='1'   #1.月
            LET l_day2 = l_edate - l_bdate+1       #該月份的總天數
         WHEN tm.axa06='2'   #2.季
            SELECT MIN(aznn01),MAX(aznn01) INTO l_bdate,l_edate
              FROM aznn_file
             WHERE aznn00 = g_aaz641                                           #CHI-D20029
               AND aznn02 = tm.yy                                              #CHI-D20029
                          AND aznn03 = (SELECT MAX(aznn03) FROM aznn_file      #CHI-D20029
                          WHERE aznn00 = g_aaz641                              #CHI-D20029
                          AND aznn02 = tm.yy                                   #CHI-D20029
                          AND aznn01 = l_bdate)                                #CHI-D20029
            #CHI-D20029--Begin Mark--
            #WHERE aznn00 = tm.yy
            #  AND aznn02 = tm.axa03
            #             AND aznn03 = (SELECT MAX(aznn03) FROM aznn_file
            #             WHERE aznn00 = tm.yy
            #             AND aznn02 = tm.axa03
            #             AND aznn04 = l_bdate) 
            #CHI-D20029---End Mark---
            LET l_day2 = l_edate - l_bdate+1       #該月份的總天數
         WHEN tm.axa06='3'   #3.半年
            IF tm.h1 = '1' THEN
               SELECT MIN(aznn01),MAX(aznn01) INTO l_bdate,l_edate
                 FROM aznn_file
                WHERE aznn00 = g_aaz641 AND aznn02 = tm.yy AND aznn03 < 3      #CHI-D20029
               #WHERE aznn00 = tm.yy AND aznn02 = tm.axa03 AND aznn03 < 3      #CHI-D20029 mark
            ELSE
               SELECT MIN(aznn01),MAX(aznn01) INTO l_bdate,l_edate
                 FROM aznn_file
                WHERE aznn00 = g_aaz641 AND aznn02 = tm.yy AND aznn03 >= 3     #CHI-D20029
               #WHERE aznn00 = tm.yy AND aznn02 = tm.axa03 AND aznn03 >= 3     #CHI-D20029 mark
            END IF
         WHEN tm.axa06='4'   #4.年
           #MOD-D40107--str
            IF l_date[j].mm=12 THEN
               LET l_day2 = MDY(1,1,tm.yy+1) - l_date[1].bdate
            ELSE
           #MOD-D40107--end
               LET l_day2 = MDY(l_date[l_date.getLength()].mm+1,1,tm.yy) - l_date[1].bdate
            END IF   #MOD-D40107
      END CASE
     #本期合計數
      LET l_sql = " SELECT SUM(axj07) FROM p001_aaz129_tmp"
                 ,"  WHERE yy = ? AND mm = ?"
      PREPARE p001_aaz129_p5 FROM l_sql
      DECLARE p001_aaz129_c5 CURSOR FOR p001_aaz129_p5
      OPEN p001_aaz129_c5 USING tm.yy,l_date[j].period
      FETCH p001_aaz129_c5 INTO l_axj071
     #上期合計數
      LET l_sql = " SELECT SUM(axj07) FROM p001_aaz129_tmp"
                 ,"  WHERE yy = ? AND mm = (SELECT MAX(mm)"
                 ,                           "FROM p001_aaz129_tmp"
                 ,"                          WHERE yy = ? AND mm < ?)"
      PREPARE p001_aaz129_p6 FROM l_sql
      DECLARE p001_aaz129_c6 CURSOR FOR p001_aaz129_p6
      OPEN p001_aaz129_c6 USING tm.yy,tm.yy,l_date[j].period           #MOD-CC0280 mark  #TQC-D30026移除mark
      #OPEN p001_aaz129_c6 USING tm.yy,tm.yy,l_date[j].mm               #MOD-CC0280 add  #TQC-D30026 mark
      FETCH p001_aaz129_c6 INTO l_axj072
      IF cl_null(l_axj071) THEN LET l_axj071 = 0 END IF
      IF cl_null(l_axj072) THEN LET l_axj072 = 0 END IF
      LET l_axj071 = l_axj071-l_axj072
      IF j < l_date.getLength() THEN
         LET l_day1 = l_date[j+1].bdate - l_date[j].bdate                      #該期間持股天數
      ELSE
        #MOD-D40107--str
         IF l_date[j].mm=12 THEN
            LET l_day1 = (MDY(1,1,tm.yy+1)-1) - l_date[j].bdate +1
         ELSE 
        #MOD-D40107--end
            LET l_day1 = (MDY(l_date[j].mm+1,1,tm.yy)-1) - l_date[j].bdate +1     #該期間持股天數 
         END IF   #MOD-D40107
      END IF
      LET l_axj071 = l_axj071 * l_day1/l_day2 * (1-(l_date[j].axbb07/100))
      IF cl_null(l_axj071) THEN LET l_axj071 = 0 END IF
      LET l_axj07 = l_axj07 + l_axj071 
   END FOR
   RETURN l_axj07
END FUNCTION
FUNCTION p001_aaz129_axg(p_axf02,i,l_em)
DEFINE p_axf02 LIKE axf_file.axf02 
DEFINE l_sql   STRING
DEFINE i       LIKE type_file.num5
DEFINE l_em    LIKE type_file.num5
DEFINE l_axj07 LIKE axj_file.axj07

   LET l_sql =
   " SELECT (axg08-axg09) ",   
   "   FROM axg_file ",
   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
   "    AND axg00 ='",g_aaz641_axf10,"' ",  
   "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
   "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別  
   "    AND axg06 = ",tm.yy,
   "    AND axg07 = '",l_em,"'"
   IF g_cnt_axf10 > 0 THEN
       IF g_low_axf10 = 0 THEN #最上層 
           LET l_sql = l_sql CLIPPED,
               "    AND axg02 = '",g_axf.axf10,"'"
       ELSE
           IF g_up_axf10 > 0 THEN     
               LET l_sql = l_sql CLIPPED,
                   "    AND axg02 = '",g_axa02_axf10,"'"
           END IF
      END IF
   ELSE
       LET l_sql = l_sql CLIPPED,
       "    AND axg02 = '",g_axa02_axf10,"'"   
   END IF
   LET l_sql = l_sql CLIPPED,
   "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
   "                   WHERE axu00 = '",g_aaz641_axf09,"'",
   "                     AND axu01 = '",g_axf.axf02,"'",
   "                     AND axu09 = '",g_axf.axf09,"'",
   "                     AND axu10 = '",g_axf.axf10,"'",
   "                     AND axu12 = '",g_aaz641_axf10,"'", 
   "                     AND axu13 = '",g_axf.axf13,"'",
   "                     AND axu05 = '+'",
   "                     AND axu03 = '",p_axf02,"')",
   "  UNION ",
   " SELECT (axg08-axg09)*-1 ", 
   "   FROM axg_file ",
   "  WHERE axg01 ='",g_axa[i].axa01,"' ",
   "    AND axg00 ='",g_aaz641_axf10,"' ",  
   "    AND axg04 ='",g_axf.axf10,"' ",     #對沖公司
   "    AND axg041='",g_axf10_axz05,"' ",   #對沖帳別  
   "    AND axg06 = ",tm.yy,
   "    AND axg07 = '",l_em,"'",          
   "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
   "                   WHERE axu00 = '",g_aaz641_axf09,"'",   
   "                     AND axu01 = '",g_axf.axf02,"'",
   "                     AND axu09 = '",g_axf.axf09,"'",
   "                     AND axu10 = '",g_axf.axf10,"'",
   "                     AND axu12 = '",g_aaz641_axf10,"'",   
   "                     AND axu13 = '",g_axf.axf13,"'",
   "                     AND axu05 = '-'",
   "                     AND axu03 = '",p_axf02,"')"
   IF g_cnt_axf10 > 0 THEN
       IF g_low_axf10 = 0 THEN #最上層 
           LET l_sql = l_sql CLIPPED,
               "    AND axg02 = '",g_axf.axf10,"'"
       ELSE
           IF g_up_axf10 > 0 THEN     
               LET l_sql = l_sql CLIPPED,
                   "    AND axg02 = '",g_axa02_axf10,"'"
           END IF
      END IF
   ELSE
       LET l_sql = l_sql CLIPPED,
           "    AND axg02 = '",g_axa02_axf10,"'"
   END IF
   PREPARE p001_aaz129_axg_p1 FROM l_sql
   DECLARE p001_aaz129_axg_c1 CURSOR FOR p001_aaz129_axg_p1
   OPEN p001_aaz129_axg_c1
   FETCH p001_aaz129_axg_c1 INTO l_axj07
   IF cl_null(l_axj07) THEN LET l_axj07 = 0 END IF
   RETURN l_axj07
END FUNCTION
FUNCTION p001_aaz129_axh(p_axf02,i,l_em)
DEFINE p_axf02 LIKE axf_file.axf02 
DEFINE i       LIKE type_file.num5
DEFINE l_sql   STRING
DEFINE l_axf10 LIKE axf_file.axf10
DEFINE l_cnt1  LIKE type_file.num5
DEFINE l_em    LIKE type_file.num5
DEFINE l_axj07 LIKE axj_file.axj07

  #Ex: A(母公司) , B(中間層母公司) ,C(最下層子公司)
  #B公司可由agli003設定公式計算出對C公司投股的少數股權科餘，
  #(agli003沖銷設定來源B，目的C，合併主體B)
  #透過aglp002執行後寫入axh,axkk中(寫入後axh02=B,axh04=B)
  #但A公司的長投要沖銷C公司的少數股權時，
  #如果設定agli003沖銷設定來源A，目的B，合併主體A會沖不到B對C公司的少數股權
  #所以應設定來源A,目的C，合併主體A
  #但axh,axkk中並沒有存在axh02=C,axh04=C的資料，只有axh02=B,axh04=B
  #所以先以當下的公司(axf09) 為條件找看看有無存在axh/axkk科餘中
  #如果找不到時，再以上層公司為條件找axh/axkk科餘
  #p001_axf01_axh(),p001_axf02_axh(),皆為相同處理方式

   LET l_sql =" SELECT COUNT(*) ",
              "   FROM axh_file ",
              "  WHERE axh01 = '",g_axa[i].axa01,"' ",
              "    AND axh00 = '",g_aaz641_axf10,"' ",               
              "    AND axh04 = ? ",                   #對沖公司
              "    AND axh041= '",g_axf10_axz05,"' ", #對沖帳別  
              "    AND axh06 = ",tm.yy,
              "    AND axh07 = '",l_em,"'",                         
              "    AND axh05 = '",p_axf02,"'"
  #先以目前設定的來源公司為條件找尋是否有存在axh/axkk科餘
   LET l_axf10 = g_axf.axf10
   LET l_cnt1 = 0
   PREPARE p001_aaz129_axh_p1 FROM l_sql
   DECLARE p001_aaz129_axh_c1 CURSOR FOR p001_aaz129_axh_p1
   OPEN p001_aaz129_axh_c1 USING g_axf.axf10
   FETCH p001_aaz129_axh_c1 INTO l_cnt1

  #以當下的來源公司找不到axh,axkk資料
  #先判斷目前公司是否為上層母公司
  #IF 屬於上層公司(g_cnt_axf10 > 0) THEN
  #    IF 屬於最上層母公司(g_low_axf10 = 0) THEN
  #       取axh_file/axkk_file時直接用目前的axf10為條件
  #    ELSE
  #       屬於中間層母公司時，先取出其上層公司，再以其上層公司為條件帶入axf10
  #    END IF
  #ELSE
  #    屬於最下層的子公司 THEN
  #    先取出其上層公司，再以其上層公司為條件帶入axf10
  #END IF

   IF l_cnt1 = 0 THEN
       CLOSE p001_aaz129_axh_c1
       IF g_cnt_axf10 > 0 THEN            #屬於上層公司
           IF g_low_axf10 = 0 THEN        #屬於最上層母公司
               LET l_axf10 = g_axf.axf10
           ELSE                           #屬於中間層母公司
               LET l_axf10 = g_axa02_axf10
           END IF
       ELSE                               #屬於最下層子公司
           LET l_axf10 = g_axa02_axf10
       END IF  
   END IF
   SELECT axz05 INTO g_axf10_axz05
     FROM axz_file
    WHERE axz01 = l_axf10

  #目的檔案資料來源 axf17 = '1'-->axh_file
   LET l_sql = " SELECT (axh08-axh09)*-1 ",
               "   FROM axh_file ",
               "  WHERE axh01 = '",g_axa[i].axa01,"' ",
               "    AND axh00 = '",g_aaz641_axf10,"' ",               
               "    AND axh04 = '",l_axf10,"' ",                   #對沖公司
               "    AND axh041= '",g_axf10_axz05,"' ",             #對沖帳別  
               "    AND axh06 = ",tm.yy,
               "    AND axh07 = '",l_em,"'",                         
               "    AND axh05 = '",p_axf02,"'"
   PREPARE p001_aaz129_axh_p2 FROM l_sql
   DECLARE p001_aaz129_axh_c2 CURSOR FOR p001_aaz129_axh_p2
   OPEN p001_aaz129_axh_c2
   FETCH p001_aaz129_axh_c2 INTO l_axj07
   IF cl_null(l_axj07) THEN LET l_axj07 = 0 END IF
   RETURN l_axj07
END FUNCTION
FUNCTION p001_aaz129_axkk(p_axf02,i,l_em) 
DEFINE p_axf02 LIKE axf_file.axf02 
DEFINE i       LIKE type_file.num5
DEFINE l_sql   STRING
DEFINE l_axf10 LIKE axf_file.axf10
DEFINE l_cnt1  LIKE type_file.num5
DEFINE l_em    LIKE type_file.num5
DEFINE l_axj07 LIKE axj_file.axj07

  #Ex: A(母公司) , B(中間層母公司) ,C(最下層子公司)
  #B公司可由agli003設定公式計算出對C公司投股的少數股權科餘，
  #(agli003沖銷設定來源B，目的C，合併主體B)
  #透過aglp002執行後寫入axh,axkk中(寫入後axh02=B,axh04=B)
  #但A公司的長投要沖銷C公司的少數股權時，
  #如果設定agli003沖銷設定來源A，目的B，合併主體A會沖不到B對C公司的少數股權
  #所以應設定來源A,目的C，合併主體A
  #但axh,axkk中並沒有存在axh02=C,axh04=C的資料，只有axh02=B,axh04=B
  #所以先以當下的公司(axf09) 為條件找看看有無存在axh/axkk科餘中
  #如果找不到時，再以上層公司為條件找axh/axkk科餘
  #p001_axf01_axh(),p001_axf02_axh(),皆為相同處理方式
   
   LET l_sql =" SELECT COUNT(*) ",
              "   FROM axkk_file ",
              "  WHERE axkk01 = '",g_axa[i].axa01,"' ",
              "    AND axkk00 = '",g_aaz641_axf10,"' ",   
              "    AND axkk04 = ? ",      #對沖公司
              "    AND axkk041= '",g_axf10_axz05,"' ",    #對沖帳別  
              "    AND axkk08 = ",tm.yy,
              "    AND axkk07 = '",g_axz08,"'",         
              "    AND axkk09 = '",l_em,"'",
              "    AND axkk05 = '",p_axf02,"'"
  #先以目前設定的來源公司為條件找尋是否有存在axh/axkk科餘
   LET l_axf10 = g_axf.axf10
   LET l_cnt1 = 0
   PREPARE p001_aaz129_axkk_p1 FROM l_sql
   DECLARE p001_aaz129_axkk_c1 CURSOR FOR p001_aaz129_axkk_p1
   OPEN p001_aaz129_axkk_c1 USING g_axf.axf10
   FETCH p001_aaz129_axkk_c1 INTO l_cnt1

  #以當下的來源公司找不到axh,axkk資料
  #先判斷目前公司是否為上層母公司
  #IF 屬於上層公司(g_cnt_axf10 > 0) THEN
  #    IF 屬於最上層母公司(g_low_axf10 = 0) THEN
  #       取axh_file/axkk_file時直接用目前的axf10為條件
  #    ELSE
  #       屬於中間層母公司時，先取出其上層公司，再以其上層公司為條件帶入axf10
  #    END IF
  #ELSE
  #    屬於最下層的子公司 THEN
  #    先取出其上層公司，再以其上層公司為條件帶入axf10
  #END IF

   IF l_cnt1 = 0 THEN           
       CLOSE p001_aaz129_axkk_c1          
       IF g_cnt_axf10 > 0 THEN            #屬於上層公司
           IF g_low_axf10 = 0 THEN        #屬於最上層母公司
               LET l_axf10 = g_axf.axf10
           ELSE                           #屬於中間層母公司
               LET l_axf10 = g_axa02_axf10
           END IF
       ELSE                               #屬於最下層子公司
           LET l_axf10 = g_axa02_axf10
       END IF  
   END IF
   SELECT axz05 INTO g_axf10_axz05
     FROM axz_file
    WHERE axz01 = l_axf10
  #axf17 = '2' -->axkk_file        
   LET l_sql = " SELECT (axkk10-axkk11)*-1 ",  
               "   FROM axkk_file ",
               "  WHERE axkk01 = '",g_axa[i].axa01,"' ",
               "    AND axkk00 = '",g_aaz641_axf10,"' ",   
               "    AND axkk04 = '",l_axf10,"' ",          #對沖公司
               "    AND axkk041= '",g_axf10_axz05,"' ",    #對沖帳別  
               "    AND axkk08 = ",tm.yy,
               "    AND axkk07 = '",g_axz08,"'",         
               "    AND axkk09 = '",l_em,"'",
               "    AND axkk05 = '",p_axf02,"'"
   PREPARE p001_aaz129_axkk_p2 FROM l_sql
   DECLARE p001_aaz129_axkk_c2 CURSOR FOR p001_aaz129_axkk_p2
   OPEN p001_aaz129_axkk_c2
   FETCH p001_aaz129_axkk_c2 INTO l_axj07
   IF cl_null(l_axj07) THEN LET l_axj07 = 0 END IF
   RETURN l_axj07
END FUNCTION
FUNCTION p001_aaz129_axk(p_axu03,i,l_em)
DEFINE l_sql    STRING
DEFINE p_axu03  LIKE axu_file.axu03
DEFINE i        LIKE type_file.num5
DEFINE l_em    LIKE type_file.num5
DEFINE l_axj07 LIKE axj_file.axj07

   LET l_sql =
   " SELECT (axk10-axk11)",  
   "   FROM axk_file ",
   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
   "    AND axk00 ='",g_aaz641_axf10,"' ",  
   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    
   "    AND axk07 = '",g_axz08,"'",      
   "    AND axk08 = ",tm.yy,
   "    AND axk09 = '",tm.em,"'"     
   IF g_cnt_axf10 > 0 THEN
       IF g_low_axf10 = 0 THEN #最上層  
           LET l_sql = l_sql CLIPPED,
               "    AND axk02 = '",g_axf.axf10,"'"
       ELSE
           IF g_up_axf10 > 0 THEN      
               LET l_sql = l_sql CLIPPED,
                   "    AND axk02 = '",g_axa02_axf10,"'"  
           END IF
       END IF
   ELSE
       LET l_sql = l_sql CLIPPED,
       "    AND axk02 = '",g_axa02_axf10,"'"             
   END IF
   LET l_sql = l_sql CLIPPED,
   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
   "                   WHERE axu00 = '",g_aaz641_axf09,"'",   
   "                     AND axu01 = '",g_axf.axf02,"'",
   "                     AND axu09 = '",g_axf.axf09,"'",
   "                     AND axu10 = '",g_axf.axf10,"'",
   "                     AND axu12 = '",g_aaz641_axf10,"'",   
   "                     AND axu13 = '",g_axf.axf13,"'",　
   "                     AND axu05 = '+'",
   "                     AND axu03 = '",p_axu03,"')",
   "  UNION ",
   " SELECT (axk10-axk11)*-1,", 
   "   FROM axk_file ",
   "  WHERE axk01 ='",g_axa[i].axa01,"' ",
   "    AND axk00 ='",g_aaz641_axf10,"' ", 
   "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
   "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別   
   "    AND axk08 = ",tm.yy,
   "    AND axk07 = '",g_axz08,"'", 
   "    AND axk09 = '",l_em,"'",  
   "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
   "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
   "                     AND axu01 = '",g_axf.axf02,"'",
   "                     AND axu09 = '",g_axf.axf09,"'",
   "                     AND axu10 = '",g_axf.axf10,"'",
   "                     AND axu12 = '",g_aaz641_axf10,"'", 
   "                     AND axu13 = '",g_axf.axf13,"'",
   "                     AND axu05 = '-'",
   "                     AND axu03 = '",p_axu03,"')"
   IF g_cnt_axf10 > 0 THEN
       IF g_low_axf10 = 0 THEN #最上層  
           LET l_sql = l_sql CLIPPED,
               "    AND axk02 = '",g_axf.axf10,"'"
       ELSE
           IF g_up_axf10 > 0 THEN      
               LET l_sql = l_sql CLIPPED,
                   "    AND axk02 = '",g_axa02_axf10,"'"
           END IF
       END IF
   ELSE
       LET l_sql = l_sql CLIPPED,
       "    AND axk02 = '",g_axa02_axf10,"'"  
   END IF
   PREPARE p001_aaz129_axk_p1 FROM l_sql
   DECLARE p001_aaz129_axk_c1 CURSOR FOR p001_aaz129_axk_p1
   OPEN p001_aaz129_axk_c1
   FETCH p001_aaz129_axk_c1 INTO l_axj07
   IF cl_null(l_axj07) THEN LET l_axj07 = 0 END IF
   RETURN l_axj07
END FUNCTION
#FUN-C50084--
