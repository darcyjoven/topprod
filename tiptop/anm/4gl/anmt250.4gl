# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt250.4gl
# Descriptions...: 應收票據異動維護作業
# Date & Author..: 97/04/24 By Charis
# Modify.........: 97/05/13 By Danny 1.確認時, 若單別須拋轉總帳, 檢查分錄底稿
#                                    2.判斷異動別為2,3,4時,不可輸入借/貸方科目
# Modify.........: 97/05/27 By Lynn  1.新增時,詢問是否產生分錄底稿
#                                    2.取消確認,若已拋轉總帳,show警告訊息
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8608 03/10/30 By Kitty 確認段的Transction再改善
# Modify.........: No.9589 04/05/24 By Kitty t250_g_b1的l_wc定義太小,加長
# Modify.........: No.MOD-480280 04/08/11 Kammy 刪除單身金額合計未重 show
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.MOD-4B0261 04/11/30 By Nicola 異動別輸入為'5'時,無法輸入轉付廠商資料,異動別輸入為'2'時,不應該可以輸入轉付廠商
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530663 05/03/28 By Smapmin 當單身所輸入的應收票單號的幣
#                                                    別等於本國幣別時,其本幣金額必須與原幣金額一致
# Modify.........: No.FUN-550037 05/05/13 By saki   欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: NO.FUN-540059 05/06/19 By wujie  單據編號加大
# Modify.........: NO.FUN-560095 05/06/20 By ching 2.0功能修改
# Modify.........: No.FUN-560251 05/07/07 By Nicola 加強確認時,已確認之錯誤訊息
# Modify.........: No.MOD-580071 05/08/17 By Smapmin nmh24無 'X'的狀況,將相關判斷移除.
#                                票況為 5/6/7/8 時, 單身輸入的收票單號其收票日期, 不可以大於 單頭的 單據日期.
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-5A0124 05/10/20 By elva 刪除帳款資料時刪除oov_file
# Modify.........: No.MOD-5A0243 05/10/24 By Smapmin 系統參數傳遞錯誤
# Modify..........: NO.MOD-5B0148 05/11/10 BY yiting 2.託收異動時,單頭之託收銀行不可空白
# Modify..........: NO.MOD-5B0150 05/11/28 BY yiting
# Modify..........: NO.FUN-5A0088 05/12/08 BY yiting 異動別='2'託收時,有些客戶的做法是要產生傳票的!
#                                                    將單頭的借貸方科目開放輸入!
# Modify.........: No.FUN-630020 06/03/07 By pengu 流程訊息通知功能
# Modify.........: No.MOD-640315 06/04/10 By Smapmin 按確認時要去判斷,若為託收時託收銀行不可空白
# Modify.........: No.MOD-640036 06/04/11 By Smapmin 單身收票單號開窗要考慮單頭幣別
# Modify.........: No.FUN-5C0014 06/05/29 By Rainy   新增欄位oma67存放INVOICE NO.
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/28 By ice 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680034 06/08/23 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION t250()_q 一開始應清空g_npn.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.CHI-6A0004 06/10/27 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-710024 07/01/30 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740128 07/04/22 By Smapmin 修改報表名稱
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750246 07/05/30 By rainy 撤票重立AR收款客戶,名稱 未寫入,沖帳資料未寫入 oma51f,oma51!"
# Modify.........: No.MOD-810048 08/01/07 By Smapmin 修改單據編號開窗
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-810016 08/02/19 By Judy 寫入多帳期資料(omc_file)
# Modify.........: No.MOD-820079 08/02/21 By Smapmin 確認段時做單據是否可以確認的合理性判斷
# Modify.........: No.MOD-830049 08/03/07 By Smapmin 單頭幣別不可空白(改在畫面檔)/託收時單頭託收銀行幣別要跟單頭幣別一致
# Modify.........: No.CHI-810019 08/04/16 By Smapmin 應撤/退/作廢票立帳時,預設QBE條件.
#                                                    增加"應撤/退/作廢票還原" action取代原本取消確認段刪除axrt300的動作,
#                                                    且取消確認段要控管是否有axrt300資料存在
# Modify.........: No.MOD-840530 08/04/25 By mike  增加ACTION 撤退票串查應收
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8C0280 08/12/31 By Sarah 新增時需檢查輸入單號是否正確
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值
# Modify.........: No.MOD-920326 09/02/25 By Dido 幣別條件有誤
# Modify.........: No.MOD-930139 09/03/13 By chenl  若當月認列匯差,則本幣開票金額應為月底重評價金額.
# Modify.........: No.MOD-940045 09/04/03 By Sarah 確認段先判斷anms101的nmz33,nmz34兩參數值不可為NULL,才可作確認
# Modify.........: No.MOD-940192 09/04/15 By lilingyu 按"應撤/退票作廢立帳"按鈕,產生axrt300,其收款條件 應收賬日 票到期日皆無空值
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980093 09/08/12 By mike 銀行已關帳至８月底，但anmt150 , anmt250 卻還能做８月的兌現異動
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:MOD-9B0018 09/11/03 By Sarah 將ACTION"分錄底稿二"是否隱藏的控制段移到t250_bp()
# Modify.........: No:FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No:MOD-9C0372 10/02/04 By sabrina 若單頭有修改匯率資料時，應同步更新單頭、單身本幣異動金額
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A60056 10/07/07 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/19 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No.MOD-AB0172 10/11/17 by Dido 退票應允許託收
# Modify.........: No.TQC-AB0247 10/11/30 By lixia執行撤/退/作廢票立帳時,報錯
# Modify.........: No.MOD-AC0019 10/12/02 by Dido 拋轉應收立帳取消 QBE 選擇,以單一單據拋轉為主
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.MOD-AC0104 10/12/13 by Dido REPORT 段取消 GROUP SUM(oma58)
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:MOD-AC0121 10/12/16 By Dido REPORT 段增加 GROUP SUM(oma61)
# Modify.........: No:TQC-B10106 11/01/14 By Dido 取消 show 段檢核編號
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30576 11/03/18 By Sarah nme12不應給值m_npo.npo03,應給值g_npn.npn01
# Modify.........: No:MOD-B30631 11/03/22 By Dido omb06 說明需依語言別轉換
# Modify.........: No:FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40003 11/04/06 By guoch  取消異動別2.託收的狀態輸入
# Modify.........: No:FUN-B40011 11/04/22 By guoch  npn03='5'時，判斷該收票單號的轉付金額大於0時，不可取消審核
# Modify.........: No:MOD-B50085 11/05/11 By Dido 刪除 nme_file 需增加 nme21 條件
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No:TQC-B70197 11/07/26 By guoch 将FUN-B4003取消移动别2.托收的状态还原
# Modify.........: No:TQC-B70209 11/07/29 By guoch tic_file数据删除时逻辑错误，进行bug修复
# Modify.........: No:CHI-B80020 11/08/11 By Polly 應撤/退/作廢票時，oma33=''
# Modify.........: No:MOD-B80268 11/08/27 By Dido 自動產生兌現與檢核需以異動日以後的到期為主
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file
# Modify.........: No.MOD-BB0017 11/11/03 By Polly 當有單身資料時,單頭幣別不可異動
# Modify.........: No.TQC-BB0089 11/11/09 By yinhy 查詢時，資料建立者，資料建立部門無法下查詢條件
# Modify.........: No.MOD-BB0301 11/11/29 By Dido 單別說明顯示處理
# Modify.........: No.TQC-BC0031 11/12/06 By yinhy 轉付時，需判斷該票據nmh41是否為'Y'，若為'Y'則不可做轉付
# Modify.........: No.MOD-C10010 12/01/04 By Polly 將SQL有使用到MATCHES者改為IN
# Modify.........: No.MOD-C20010 12/02/01 By yinhy nme14若為空給默認值
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C20085 12/02/08 By yinhy nmz59為Y時，npo05應該為開票原幣金額*nmh39
# Modify.........: No.TQC-C30121 12/03/07 By zhangweib 異動別為'5:轉付'時,轉付廠商不可為空,單身本幣金額,本幣移動金額不可錄入
# Modify.........: No.TQC-C40101 12/04/13 By xuxz 單身npo05欄位不可以再重新隨便輸入
# Modify.........: No.TQC-C50107 12/05/14 By xuxz 單頭單據日期不可以大于到期日期
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30113 12/06/04 By minpp 增加客戶名稱及托收銀行簡稱顯示
# Modify.........: No.MOD-C60017 12/06/11 By Elise 新增完資料進行刪除後，畫面並不會重show
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:TQC-C70026 12/07/04 By lujh 刪除唯一一筆資料後畫面未清空，仍然顯示于畫面
# Modify.........: No.MOD-C70032 12/07/04 By Polly 調整寫入nmi_file錯誤
# Modify.........: No.FUN-C70129 12/07/31 By xuxz 添加轉付退票
# Modify.........: No:MOD-C80059 12/08/09 By Polly 判斷為轉付異動時，才控卡單據日期不得大於到期日
# Modify.........: No:MOD-C80088 12/08/14 By Polly 調整sql語法抓取順序，解決錯誤訊息的顯示錯誤
# Modify.........: No:MOD-C90120 12/09/14 By Polly 確認/取消確認後，需重新帶出票況資訊
# Modify.........: No.TQC-C10084 12/09/20 By wangwei 轉付時，轉付廠商為必輸欄位
# Modify.........: No.FUN-C80083 12/09/07 By minpp 1.单头票贴需判断托收状态才可做票贴 2.单身最后增加手续费npo09，用于票贴时可录，其他情况隐藏
#..................................................3.自动计算汇差，根据npo09+npo06-npo05得出汇差
#..................................................4.产生分录底稿，借方抓托收银行对应的科目anmi030，手续费抓nms25,汇损抓nms13,贷方抓应收票据科目nmh26,为>
#                                                    空抓nms22,汇盈抓nms12
#..................................................5.审核后产生nme_file，金额为npo06;取消审核需删除nme_file
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-CA0083 12/10/16 By xuxz 轉付退票時科目抓取
# Modify.........: No.FUN-C90092 12/10/18 By minpp 单头厂商改为厂商/客户
# Modify.........: No.MOD-C90252 12/10/02 By Polly 針對轉付異動，不可以大於到期日期做票據的異動處理控卡
# Modify.........: No.MOD-C80263 12/10/22 By Polly 取消確認時，異動別為679(撤票/退票/作廢)增加異動單日期檢核
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gnmg250
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gnmg250
# Modify.........: No.MOD-CB0070 13/02/19 By yinhy 將SQL中IN寫法有誤
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10101 13/03/07 By wangrr 9主機追單到30主機,axrt300單身新增已開票數量欄位，賦默認值0
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D70045 13/07/08 By yinhy 應給omb48賦值
# Modify.........: No:MOD-D80121 13/08/19 By yinhy 狀態為質押，審核時應更新anmt200票況為質押
# Modify.........: No:MOD-D90007 13/09/02 By yinhy 暫收的收票單據可以做轉付
# Modify.........: NO:FUN-E80012 18/11/27 By lixwz 修改付款日期之後,tic現金流量明細重複


IMPORT os   #No.FUN-9C0009
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_nme   RECORD LIKE nme_file.*,
    g_nmh   RECORD LIKE nmh_file.*,
    g_nmi   RECORD LIKE nmi_file.*,
    g_oma   RECORD LIKE oma_file.*,
    g_omb   RECORD LIKE omb_file.*,
    g_nme_o RECORD LIKE nme_file.*,
    g_npn   RECORD LIKE npn_file.*,
    g_amtdiff  LIKE npn_file.npn11,
    g_npn_o RECORD LIKE npn_file.*,
    g_npn_t RECORD LIKE npn_file.*,
    m_npo   RECORD LIKE npo_file.*,                 #INSERT ime_file 用
    b_npo   RECORD LIKE npo_file.*,
    g_npo   DYNAMIC ARRAY OF RECORD
            npo02    LIKE npo_file.npo02,
            npo03    LIKE npo_file.npo03,
            nmh31    LIKE nmh_file.nmh31,
            nmh11    LIKE nmh_file.nmh11,
            nmh30    LIKE nmh_file.nmh30,   #CHI-C30113
            nmh21    LIKE nmh_file.nmh21,
            nma02_1  LIKE nma_file.nma02,   #CHI-C30113
            nmh05    LIKE nmh_file.nmh05,
            nmh09    LIKE nmh_file.nmh09,
            nmh24    LIKE nmh_file.nmh24,
            nmh28    LIKE nmh_file.nmh28,
            npo04    LIKE npo_file.npo04,
            npo05    LIKE npo_file.npo05,
            npo06    LIKE npo_file.npo06,
            npo10    LIKE npo_file.npo10,     #FUN-C80083
            npo09    LIKE npo_file.npo09,     #FUN-C80083
            npodiff  LIKE npo_file.npo06,
            npoud01  LIKE npo_file.npoud01,
            npoud02  LIKE npo_file.npoud02,
            npoud03  LIKE npo_file.npoud03,
            npoud04  LIKE npo_file.npoud04,
            npoud05  LIKE npo_file.npoud05,
            npoud06  LIKE npo_file.npoud06,
            npoud07  LIKE npo_file.npoud07,
            npoud08  LIKE npo_file.npoud08,
            npoud09  LIKE npo_file.npoud09,
            npoud10  LIKE npo_file.npoud10,
            npoud11  LIKE npo_file.npoud11,
            npoud12  LIKE npo_file.npoud12,
            npoud13  LIKE npo_file.npoud13,
            npoud14  LIKE npo_file.npoud14,
            npoud15  LIKE npo_file.npoud15
           END RECORD,
    g_npo_t RECORD
            npo02    LIKE npo_file.npo02,
            npo03    LIKE npo_file.npo03,
            nmh31    LIKE nmh_file.nmh31,
            nmh11    LIKE nmh_file.nmh11,
            nmh30    LIKE nmh_file.nmh30,   #CHI-C30113
            nmh21    LIKE nmh_file.nmh21,
            nma02_1  LIKE nma_file.nma02,   #CHI-C30113
            nmh05    LIKE nmh_file.nmh05,
            nmh09    LIKE nmh_file.nmh09,
            nmh24    LIKE nmh_file.nmh24,
            nmh28    LIKE nmh_file.nmh28,
            npo04    LIKE npo_file.npo04,
            npo05    LIKE npo_file.npo05,
            npo06    LIKE npo_file.npo06,
            npo10    LIKE npo_file.npo10,     #FUN-C80083
            npo09    LIKE npo_file.npo09,     #FUN-C80083
            npodiff  LIKE npo_file.npo06,
            npoud01  LIKE npo_file.npoud01,
            npoud02  LIKE npo_file.npoud02,
            npoud03  LIKE npo_file.npoud03,
            npoud04  LIKE npo_file.npoud04,
            npoud05  LIKE npo_file.npoud05,
            npoud06  LIKE npo_file.npoud06,
            npoud07  LIKE npo_file.npoud07,
            npoud08  LIKE npo_file.npoud08,
            npoud09  LIKE npo_file.npoud09,
            npoud10  LIKE npo_file.npoud10,
            npoud11  LIKE npo_file.npoud11,
            npoud12  LIKE npo_file.npoud12,
            npoud13  LIKE npo_file.npoud13,
            npoud14  LIKE npo_file.npoud14,
            npoud15  LIKE npo_file.npoud15
           END RECORD,
    g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,   #No.FUN-980020
    g_nms               RECORD LIKE nms_file.*,
    g_buf               LIKE nma_file.nma02,    #No.FUN-680107 VARCHAR(20)
    g_dept              LIKE type_file.chr6,    #No.FUN-680107 VARCHAR(6)
    m_chr               LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
    g_wc,g_wc1,g_sql    string,                 #No.FUN-580092 HCN
    g_t1                LIKE nmy_file.nmyslip,  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    g_nmydmy1           LIKE nmy_file.nmydmy1,  #No.FUN-680107 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_cmd               LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
    g_argv1             LIKE npn_file.npn01     #No.FUN-680107 VARCHAR(16)         #No.FUN-540059
DEFINE g_flag         LIKE type_file.chr1       #No.FUN-730032
DEFINE g_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE g_bookno2      LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_bookno3      LIKE aza_file.aza82       #No.FUN-730032

DEFINE g_argv2          STRING                  #No.FUN-630020 add
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT

DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(72)
DEFINE   g_str          STRING                 #No.FUN-670060
DEFINE   g_wc_gl        STRING                 #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_oma01        LIKE oma_file.oma01    #No.MOD-840530
DEFINE   g_dbs2         LIKE type_file.chr30   #MOD-940192
DEFINE   g_plant2       LIKE type_file.chr10   #FUN-980020
DEFINE   g_apa01        LIKE apa_file.apa01    #FUN-C70129
DEFINE   g_apa          RECORD LIKE apa_file.* #FUN-C70129
DEFINE   g_apb          RECORD LIKE apb_file.* #FUN-C70129
DEFINE g_net            LIKE apv_file.apv04    #FUN-C70129

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE comb_value    STRING                 #TQC-B70197 add
   DEFINE comb_item     LIKE type_file.chr1000 #TQC-B70197 add
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
   LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082

   LET g_forupd_sql = "SELECT * FROM npn_file WHERE npn01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t250_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

   LET g_wc1 = " 1=1"
   LET g_plant_gl = g_nmz.nmz02p                       #FUN-980020
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
   LET p_row = 1 LET p_col = 2
    OPEN WINDOW t250_w AT p_row,p_col
      WITH FORM "anm/42f/anmt250"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    CALL cl_set_comp_visible("npn061,npn071",g_aza.aza63 = 'Y')
  #TQC-B70197 --begin
    IF g_aza.aza26 = '2' THEN
       LET comb_value = '3,4,5,6,7,8,9' #FUN-C70129 add 9
       SELECT ze03 INTO comb_item FROM ze_file
        WHERE ze01='anm-662' AND ze02=g_lang
       CALL cl_set_combo_items('npn03',comb_value,comb_item)
 #--begin-- FUN-B40003
       CALL cl_set_comp_visible("npn13,nma02",FALSE)
 #--end-- FUN-B40003
     END IF
  #TQC-B70197 --end  mark
   # 先以g_argv2判斷直接執行哪種功能，
   # 執行I時，g_argv1是單號

   LET g_plant2 = g_plant                       #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)       #MOD-940192

   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t250_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t250_a()
            END IF
         OTHERWISE
                CALL t250_q()
      END CASE
   END IF
   CALL t250_menu()
   CLOSE WINDOW t250_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN

FUNCTION t250_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_npo.clear()
   INITIALIZE g_npn.* TO NULL #FUN-560095
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN         #No.FUN-630020 add
      LET g_wc=" npn01='",g_argv1,"'"
      LET g_wc1=" 1=1"
   ELSE
   INITIALIZE g_npn.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON npn01,npn02,npn03,npn04,npn05,npn13,
                   npn14,npn06,npn07,npn061,npn071,                  # No.FUN-680034 add  npn061,npn071
                   npn09,npn08,npnconf,npn10,npn11,npn12,
                   npnuser,npngrup,npnmodu,npndate,
                   npnoriu,npnorig,                                  #TQC-BB0089
                   npnud01,npnud02,npnud03,npnud04,npnud05,
                   npnud06,npnud07,npnud08,npnud09,npnud10,
                   npnud11,npnud12,npnud13,npnud14,npnud15
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npn01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_npn"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npn01
                  NEXT FIELD npn01
               WHEN INFIELD(npn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npn04
                  NEXT FIELD npn04
               WHEN INFIELD(npn06)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2    #No.FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npn.npn06,'23',g_bookno1)     #No.FUN-980025
                  RETURNING g_npn.npn06
                  DISPLAY BY NAME g_npn.npn06
                  NEXT FIELD npn06
               WHEN INFIELD(npn07)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npn.npn07,'23',g_bookno1)     #No.FUN-980025
                  RETURNING g_npn.npn07
                  DISPLAY BY NAME g_npn.npn07
                  NEXT FIELD npn07

               WHEN INFIELD(npn061)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npn.npn061,'23',g_bookno2)     #No.FUN-980025
                  RETURNING g_npn.npn061
                  DISPLAY BY NAME g_npn.npn061
                  NEXT FIELD npn061
               WHEN INFIELD(npn071)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2    #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npn.npn071,'23',g_bookno2)     #No.FUN-980025
                  RETURNING g_npn.npn071
                  DISPLAY BY NAME g_npn.npn071
                  NEXT FIELD npn071


              WHEN INFIELD(npn13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npn13
                  NEXT FIELD npn13
               WHEN INFIELD(npn14)
                 #FUN-C90092--mod--str
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_pmc"
                 #LET g_qryparam.state = "c"
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 #DISPLAY g_qryparam.multiret TO npn14
                 #NEXT FIELD npn14
                  CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npn14
                  NEXT FIELD npn14
                 #FUN-C90092---mod--end
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

      IF INT_FLAG THEN RETURN END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('npnuser', 'npngrup')

      CONSTRUCT g_wc1 ON npo02,npo03,npo04,npo05,npo06
                         ,npoud01,npoud02,npoud03,npoud04,npoud05
                         ,npoud06,npoud07,npoud08,npoud09,npoud10
                         ,npoud11,npoud12,npoud13,npoud14,npoud15
                 FROM s_npo[1].npo02,s_npo[1].npo03,s_npo[1].npo04,
                      s_npo[1].npo05,s_npo[1].npo06
                      ,s_npo[1].npoud01,s_npo[1].npoud02,s_npo[1].npoud03
                      ,s_npo[1].npoud04,s_npo[1].npoud05,s_npo[1].npoud06
                      ,s_npo[1].npoud07,s_npo[1].npoud08,s_npo[1].npoud09
                      ,s_npo[1].npoud10,s_npo[1].npoud11,s_npo[1].npoud12
                      ,s_npo[1].npoud13,s_npo[1].npoud14,s_npo[1].npoud15

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npo03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmh"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npo03
                  NEXT FIELD npo03
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
   END IF

   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN
      LET g_sql="SELECT npn01 FROM npn_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY npn01"
   ELSE
      LET g_sql="SELECT UNIQUE npn_file.npn01 ",
                "  FROM npn_file,npo_file ", # 組合出 SQL 指令
                " WHERE npn01=npo01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY npn01"
   END IF
   PREPARE t250_pr FROM g_sql           # RUNTIME 編譯
   DECLARE t250_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t250_pr

   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
      LET g_sql="SELECT COUNT(*) FROM npn_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT npn01) FROM npn_file,npo_file ",
                " WHERE npn01=npo01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF
   PREPARE t250_precount FROM g_sql                           # row的個數
   DECLARE t250_count CURSOR FOR t250_precount
END FUNCTION

FUNCTION t250_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)

   WHILE TRUE
      CALL t250_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t250_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t250_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t250_r()
               LET g_nmy.nmydesc = NULL   #TQC-C70026   add
               CALL t250_show()    #TQC-C70026   add
               DISPLAY g_row_count TO FORMONLY.cnt   #TQC-C70026   add
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t250_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t250_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET g_wc = 'npn01="',g_npn.npn01,'"'
              #LET l_cmd =  "anmr250 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED #FUN-C30085 mark
               #FUN-D10098--add--str--
               IF g_aza.aza26 = '2' THEN
                  LET l_cmd =  "gnmg250 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED
               ELSE
               #FUN-D10098--add--end--
                  LET l_cmd =  "anmg250 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED #FUN-C30085 add
               END IF   #FUN-D10098 add
               CALL cl_cmdrun(l_cmd CLIPPED)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t250_x()                  #FUN-D20035
               CALL t250_x(1)                 #FUN-D20035
               IF g_npn.npnconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
            END IF

         #FUN-D20035----add---str
         #WHEN "取消作廢"
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t250_x(2)
               IF g_npn.npnconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
            END IF
         #FUN-D20035---ADD---END

         #WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t250_firm1()
               IF g_npn.npnconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
            END IF
         #WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t250_firm2()
               IF g_npn.npnconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
            END IF
         #WHEN "產生分錄"
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               CALL t250_v(1)
            END IF
         #WHEN "分錄底稿"
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               #系統別、類別、單號、票面金額
               CALL s_showmsg_init()   #No.FUN-710024
               CALL s_fsgl('NM',2,g_npn.npn01,g_npn.npn10,g_nmz.nmz02b,
                             g_npn.npn03,g_npn.npnconf,'0',g_nmz.nmz02p)
               CALL s_showmsg()        #No.FUN-710024
               CALL t250_npp02('0')
            END IF
         WHEN "entry_sheet1"
          IF cl_chk_act_auth()  THEN
             CALL s_showmsg_init()   #No.FUN-710024
             CALL s_fsgl('NM',2,g_npn.npn01,g_npn.npn10,g_nmz.nmz02c,
                          g_npn.npn03,g_npn.npnconf,'1',g_nmz.nmz02p)
             CALL s_showmsg()        #No.FUN-710024
             CALL t250_npp02('1')
          END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_npn.npnconf ='Y' THEN
                  CALL t250_carry_voucher()
               ELSE
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_npn.npnconf ='Y' THEN
                  CALL t250_undo_carry_voucher()
               ELSE
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         #WHEN "應撤/退票立帳"
         WHEN "ent_note_wtdw_ret_ac"
            IF cl_chk_act_auth() THEN
               CALL t250_t()
            END IF
         #WHEN "應撤/退/作廢票立帳還原"
         WHEN "ent_note_wtdw_ret_ac_rtn"
            IF cl_chk_act_auth() THEN
               CALL t250_t2()
            END IF

        WHEN "qry_misc_ar"
           IF cl_chk_act_auth() THEN
              IF not cl_null(g_npn.npn01) THEN
                 LET g_oma01 = null
                 SELECT oma01 INTO g_oma01 FROM oma_file WHERE oma16=g_npn.npn01
                 LET l_cmd = "axrt300 '",g_oma01,"' q"
                 CALL cl_cmdrun(l_cmd CLIPPED)
              END IF
           END IF

        WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npo),'','')
            END IF
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_npn.npn01 IS NOT NULL THEN
                LET g_doc.column1 = "npn01"
                LET g_doc.value1 = g_npn.npn01
                CALL cl_doc()
              END IF
          END IF
        #FUN-C70129-add--str
        WHEN "ent_note_wtdw_ret_ac1"
            IF cl_chk_act_auth() THEN
               CALL t250_s()
            END IF

         WHEN "ent_note_wtdw_ret_ac_rtn1"
            IF cl_chk_act_auth() THEN
               CALL t250_s2()
            END IF

         WHEN "qry_misc_ap"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_npn.npn01) AND g_npn.npn03 = '9' THEN
                  LET g_apa01 = null
                  SELECT apa01 INTO g_apa01 FROM apa_file WHERE apa25=g_npn.npn01
                  LET l_cmd = "aapt120 '",g_apa01,"' q"
                  CALL cl_cmdrun(l_cmd CLIPPED)
               END IF
            END IF
        #FUN-C70129--add--end
      END CASE
   END WHILE
    CLOSE t250_cs
END FUNCTION

FUNCTION t250_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_npn.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t250_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t250_count
   FETCH t250_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t250_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      INITIALIZE g_npn.* TO NULL
   ELSE
      CALL t250_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION t250_fetch(p_flnpn)
   DEFINE
       p_flnpn         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER

   CASE p_flnpn
      WHEN 'N' FETCH NEXT     t250_cs INTO g_npn.npn01
      WHEN 'P' FETCH PREVIOUS t250_cs INTO g_npn.npn01
      WHEN 'F' FETCH FIRST    t250_cs INTO g_npn.npn01
      WHEN 'L' FETCH LAST     t250_cs INTO g_npn.npn01
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
            FETCH ABSOLUTE g_jump t250_cs INTO g_npn.npn01
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      INITIALIZE g_npn.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnpn
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_npn.* FROM npn_file            # 重讀DB,因TEMP有不被更新特性
    WHERE npn01 = g_npn.npn01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","npn_file",g_npn.npn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_npn.npnuser     #No.FUN-4C0063
      LET g_data_group = g_npn.npngrup     #No.FUN-4C0063
      CALL t250_show()                      # 重新顯示
   END IF
END FUNCTION

FUNCTION t250_show()
   DEFINE l_azi02,a,b LIKE azi_file.azi02    #No.FUN-680107 VARCHAR(20)
   DEFINE l_nml02     LIKE nml_file.nml02    #No.FUN-680107 VARCHAR(12)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
   DEFINE l_npo09     LIKE npo_file.npo09    #FUN-C80083
   DEFINE l_npo10     LIKE npo_file.npo10    #FUN-C80083
   #FUN-C80083--ADD--STR
   IF g_npn.npn03='4' THEN
      CALL cl_set_comp_visible('npo09,npo10',TRUE)
   ELSE
      CALL cl_set_comp_visible('npo09.npo10',FALSE)
   END IF
   #FUN-C80083--ADD--END
   DISPLAY BY NAME g_npn.npn01,g_npn.npn02,g_npn.npn03,g_npn.npn04,g_npn.npn05, g_npn.npnoriu,g_npn.npnorig,
                   g_npn.npn06,g_npn.npn07,g_npn.npn061,g_npn.npn071,           # No.FUN-680034  add g_npn.npn061,g_npn.npn071
                   g_npn.npn08,g_npn.npn09,g_npn.npn10,
                   g_npn.npn11,g_npn.npn12,g_npn.npn13,g_npn.npn14,g_npn.npnconf,
                   g_npn.npnuser,g_npn.npngrup,g_npn.npnmodu,g_npn.npndate,
                   g_npn.npnud01,g_npn.npnud02,g_npn.npnud03,g_npn.npnud04,
                   g_npn.npnud05,g_npn.npnud06,g_npn.npnud07,g_npn.npnud08,
                   g_npn.npnud09,g_npn.npnud10,g_npn.npnud11,g_npn.npnud12,
                   g_npn.npnud13,g_npn.npnud14,g_npn.npnud15


   #CALL s_check_no("anm",g_npn.npn01,"","B","","","")  #FUN-560095 #TQC-B10106 mark
   #RETURNING li_result,g_npn.npn01                                 #TQC-B10106 mark

   #-MOD-BB0301-add-
    LET g_t1 = s_get_doc_no(g_npn.npn01)
    SELECT * INTO g_nmy.*
      FROM nmy_file
     WHERE nmyslip = g_t1
   #-MOD-BB0301-end-

    DISPLAY g_nmy.nmydesc TO nmydesc
    LET g_buf = NULL

   SELECT nma02 INTO g_buf FROM nma_file WHERE nma01=g_npn.npn13
   DISPLAY g_buf TO nma02
   LET g_buf = NULL
   SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_npn.npn14
   DISPLAY g_buf TO pmc03
   LET g_buf = NULL
   LET g_amtdiff=g_npn.npn12-g_npn.npn11
   DISPLAY g_amtdiff TO amt
   CALL t250_b_fill(g_wc1)
   IF g_npn.npnconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
   CALL cl_show_fld_cont()                   #No.FUN-550037
END FUNCTION

FUNCTION t250_a()           #輸入
   DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT

   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                # 清螢墓欄位內容
   CALL g_npo.clear()
   INITIALIZE g_npn.* TO NULL
   LET g_npn_t.* = g_npn.*
   LET g_npn.npnconf='N'
   LET g_npn.npn02 = g_today
   LET g_npn.npnuser = g_user
   LET g_npn.npnoriu = g_user #FUN-980030
   LET g_npn.npnorig = g_grup #FUN-980030
   LET g_npn.npngrup = g_grup               #使用者所屬群
   LET g_npn.npnmodu = ''
   LET g_npn.npndate = g_today
   LET g_npn.npn10=0
   LET g_npn.npn11=0
   LET g_npn.npn12=0
   LET g_npn.npn04=g_aza.aza17
   CALL s_curr3(g_npn.npn04,g_npn.npn02,'B') RETURNING g_npn.npn05
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t250_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_npn.* TO NULL
         EXIT WHILE
      END IF
      IF cl_null(g_npn.npn01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
        CALL s_auto_assign_no("anm",g_npn.npn01,g_npn.npn02,"B","npn_file","npn01","","","")
             RETURNING li_result,g_npn.npn01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_npn.npn01
      IF cl_null(g_npn.npn05) OR g_npn.npn05<=0 THEN
         CALL s_curr3(g_npn.npn04,g_npn.npn02,'B') RETURNING g_npn.npn05
      END IF

      LET g_npn.npnlegal = g_legal

      INSERT INTO npn_file VALUES (g_npn.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","npn_file",g_npn.npn01,"",SQLCA.sqlcode,"","t250_ins_npn:",1)  #No.FUN-660148
         LET g_success = 'N'
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_npn.npn01,'I')
      END IF
      COMMIT WORK
      CALL g_npo.clear()
      SELECT npn01 INTO g_npn.npn01 FROM npn_file WHERE npn01 = g_npn.npn01
      LET g_npn_t.* = g_npn.*
      LET g_rec_b = 0                    #No.FUN-680064
      CALL t250_b()
      MESSAGE " Wait ...."
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      SELECT COUNT(*) INTO g_cnt FROM npo_file WHERE npo01=g_npn.npn01
      IF g_nmy.nmydmy1 = 'Y' AND g_cnt!=0 THEN
         CALL t250_firm1()
      END IF
      MESSAGE ""
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t250_g_b()                       #由出貨通知單/訂單自動產生單身
   SELECT COUNT(*) INTO g_cnt FROM npo_file WHERE npo01=g_npn.npn01
   IF g_cnt = 0 THEN
      CALL t250_g_b1()
      CALL t250_bu()
      CALL t250_b_fill(' 1=1')
   END IF

END FUNCTION

FUNCTION t250_g_b1()                       #由應付票據產生單身
   DEFINE l_wc    STRING   #No:9589  #No.FUN-680107 VARCHAR(1000) #MOD-BB0301 mod 1000 -> STRING
   DEFINE l_npn01 LIKE npn_file.npn01
   DEFINE l_rate  LIKE nmh_file.nmh39 #MOD-C20085
   #darcy:2024/09/04 add s---
   define l_npo04 like npo_file.npo04
   define l_npo05 like npo_file.npo05
   #darcy:2024/09/04 add e---

   LET b_npo.npo01=g_npn.npn01
   LET b_npo.npo02=0


   OPEN WINDOW t250b_w AT 6,20 WITH FORM "anm/42f/anmt2501"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("anmt2501")


   CONSTRUCT BY NAME l_wc ON nmh04,nmh01,nmh31,nmh05,nmh09,nmh10,nmh29,nmh21
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
      CLOSE WINDOW t250b_w
      RETURN
   END IF
   CLOSE WINDOW t250b_w

   MESSAGE "WORKING !"
   LET g_sql = "SELECT *  FROM nmh_file WHERE",
               "  nmh38='Y' AND ",
              #"  nmh05 >= '",g_npn.npn02,"' AND",             #TQC-C50107 add #MOD-C90252 mark
               " nmh03='",g_npn.npn04,"' AND ",l_wc CLIPPED
  #IF g_npn.npn03 MATCHES '[1235]' THEN           #NO.FUN-B40003  #TQC-B70197 add 2 #FUN-C80083 del 4 #MOD-C90252 mark
   IF g_npn.npn03 MATCHES '[123]' THEN            #MOD-C90252 del 5
       LET g_sql=g_sql CLIPPED," AND nmh24 = 1 "   #MOD-580071
   END IF

   #FUN-C80083--ADD---STR
   IF g_npn.npn03 ='4' THEN
      #darcy:2025/06/27 mod s---
      -- LET g_sql=g_sql CLIPPED," AND nmh24 = 2 "
      -- 托收 票贴 转服 兑现后 都可以做 票贴
      let g_sql = g_sql clipped ," and nmh24 in ('2','4','5','8') ",
                  " and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npo01 = npn01 and npnconf <> 'X' and npo03 = nmh01),0)"
      #darcy:2025/06/27 mod e---
   END IF
   #FUN-C80083--ADD---END
  #-----------------MOD-C90252---------------(S)
   IF g_npn.npn03 ='5' THEN
      # darcy:2025/06/27 mod s---
      -- 票贴 转付 兑现  后 都可以转付
      -- LET g_sql = g_sql CLIPPED," AND nmh24 = 1 AND nmh05 >= '",g_npn.npn02,"'"
      -- let g_sql = g_sql , " or ( nmh24 = '5' and nmh02 > (select sum(npo04) from npo_file,npn_file where npo01 = npn01 and npnconf <> 'X' and npo03 = nmh01) ) "#darcy:2024/09/04 add
      let g_sql = g_sql clipped," and ( (nmh24 = 1 and nmh05 >= '",g_npn.npn02,"' ) ",
                  "or ( nmh24 in ('4','5','6') and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npo01 = npn01 and npnconf <> 'X' and npo03 = nmh01),0) )  )"
      # darcy:2025/06/27 mod e---
   END IF
  #-----------------MOD-C90252---------------(E)

   IF g_npn.npn03 MATCHES '[6]' THEN
       LET g_sql=g_sql CLIPPED," AND nmh24 IN ('1','2','3','4') "   #MOD-580071
   END IF
   IF g_npn.npn03 MATCHES '[8]' THEN
     #LET g_sql=g_sql CLIPPED," AND nmh24 IN ('2','3') "            #MOD-B80268 mark
      LET g_sql=g_sql CLIPPED," AND nmh24 IN ('2','3','4','5') AND nmh05 <= '",g_npn.npn02,"'" #MOD-B80268
                ," and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npo01 = npn01 and npnconf <> 'X' and npo03 = nmh01),0) "# darcy:2025/06/27 add
      # darcy:2025/06/27 mod add 4,5 票贴 和 转付 后也可以兑现
   END IF
   IF g_npn.npn03 MATCHES '[7]' THEN
     #LET g_sql=g_sql CLIPPED," AND nmh24 IN ('3','4','8') "        #MOD-AB0172 mark
      LET g_sql=g_sql CLIPPED," AND nmh24 IN ('2','3','4','8') "    #MOD-AB0172
   END IF
   #FUN-C70129--add--str
   IF g_npn.npn03 = '9' THEN
      LET g_sql = g_sql CLIPPED," AND nmh24 = '5' AND nmh22 = '",g_npn.npn14,"'",
                  "               AND nmh42 > 0 "
   END IF
   #FUN-C70129--add--str
   PREPARE t250_b_p FROM g_sql
   DECLARE t250_b_c CURSOR WITH HOLD FOR t250_b_p
   FOREACH t250_b_c INTO g_nmh.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO g_cnt FROM npn_file,npo_file
       WHERE npn01 = npo01
         AND npo03 = g_nmh.nmh01
         AND npnconf='N'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      IF g_npn.npn03 MATCHES '[5678]' AND g_npn.npn02 < g_nmh.nmh04 THEN
         CALL cl_err(g_nmh.nmh01,'anm-074',1)
         CONTINUE FOREACH
      END IF
      LET b_npo.npo02=b_npo.npo02+1
      LET b_npo.npo03=g_nmh.nmh01
      #darcy:2024/09/04 add s---
      # 票据金额去掉已转付金额
      if g_npn.npn03 MATCHES '[458]' then  #darcy:2025/06/27 增加兑现
         select sum(npo04),sum(npo05) into l_npo04,l_npo05
           from npo_file,npn_file where npn01 = npo01
            and npnconf <> 'X' and npn03 in ('4','5','8') and npo03 = g_nmh.nmh01 #darcy:2025/06/27 add 4,8
         if cl_null(l_npo04) then let l_npo04 = 0 end if
         if cl_null(l_npo05) then let l_npo05 = 0 end if
         let g_nmh.nmh02 = g_nmh.nmh02 - l_npo04
         let g_nmh.nmh32 = g_nmh.nmh32 - l_npo05
      end if
      #darcy:2024/09/04 add e---
      LET b_npo.npo04=g_nmh.nmh02
      IF g_nmz.nmz59 = 'Y' THEN
         #No.MOD-C20085  --Begin
         #LET b_npo.npo05 = g_nmh.nmh40
         LET l_rate = g_nmh.nmh39
         IF cl_null(l_rate) OR l_rate = 0 THEN
            LET l_rate = g_nmh.nmh28
         END IF
         LET b_npo.npo05 = g_nmh.nmh02 * l_rate
         #No.MOD-C20085  --End
      ELSE
         LET b_npo.npo05=g_nmh.nmh32
      END IF  #No.MOD-930139
      CALL cl_digcut(b_npo.npo05,g_azi04) RETURNING b_npo.npo05
      LET b_npo.npo06=g_nmh.nmh02 * g_npn.npn05
      CALL cl_digcut(b_npo.npo06,g_azi04) RETURNING b_npo.npo06
      LET b_npo.npo07=g_nmh.nmh24
      LET b_npo.npo08=g_nmh.nmh25
      LET b_npo.npo09=0          #FUN-C80083
      LET b_npo.npo10=0          #FUN-C80083

      LET b_npo.npoud01 = ''
      LET b_npo.npoud02 = ''
      LET b_npo.npoud03 = ''
      LET b_npo.npoud04 = ''
      LET b_npo.npoud05 = ''
      LET b_npo.npoud06 = ''
      LET b_npo.npoud07 = ''
      LET b_npo.npoud08 = ''
      LET b_npo.npoud09 = ''
      LET b_npo.npoud10 = ''
      LET b_npo.npoud11 = ''
      LET b_npo.npoud12 = ''
      LET b_npo.npoud13 = ''
      LET b_npo.npoud14 = ''
      LET b_npo.npoud15 = ''

      LET b_npo.npolegal = g_legal

      INSERT INTO npo_file VALUES (b_npo.*)
   END FOREACH
   MESSAGE " "
END FUNCTION

FUNCTION t250_i(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_n       LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE l_tot     LIKE type_file.num20_6 #No.FUN-4C0010  #No.FUN-680107 DECIMAL(20,6)
    DEFINE l_nma02   LIKE nma_file.nma02
    DEFINE l_nma21   LIKE nma_file.nma21
    DEFINE l_nmaacti LIKE nma_file.nmaacti
    DEFINE l_flag    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_msg     LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(30)
    DEFINE g_t1      LIKE nmy_file.nmyslip  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    DEFINE li_result LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
    DEFINE l_nph02   LIKE nph_file.nph02    #MOD-580071
    DEFINE l_nma10   LIKE nma_file.nma10    #MOD-830049
    DEFINE l_npo02   LIKE npo_file.npo02    #MOD-9C0372 add
    DEFINE l_npo04   LIKE npo_file.npo04    #MOD-9C0372 add
    DEFINE l_npo06   LIKE npo_file.npo06    #MOD-9C0372 add
    #TQC-C50107--add--str
    DEFINE l_npo03   LIKE npo_file.npo03
    DEFINE l_nmh05   LIKE nmh_file.nmh05
    DEFINE l_true    LIKE type_file.num5
    DEFINE li_sql    STRING
    #TQC-C50107--add--end
    DEFINE l_pmc03   LIKE pmc_file.pmc03    #No.FUN-C90092

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_npn.npn01,g_npn.npn02,g_npn.npn03,g_npn.npn04,g_npn.npn05, g_npn.npnoriu,g_npn.npnorig,
                  g_npn.npn13,g_npn.npn14,g_npn.npn06,g_npn.npn07,
                  g_npn.npn061,g_npn.npn071,                          # No.FUN-680034
                  g_npn.npn09,
                  g_npn.npn08,g_npn.npnconf,g_npn.npn10,g_npn.npn11,g_npn.npn12,
                  g_npn.npnuser,g_npn.npngrup,g_npn.npndate,
                  g_npn.npnud01,g_npn.npnud02,g_npn.npnud03,g_npn.npnud04,
                  g_npn.npnud05,g_npn.npnud06,g_npn.npnud07,g_npn.npnud08,
                  g_npn.npnud09,g_npn.npnud10,g_npn.npnud11,g_npn.npnud12,
                  g_npn.npnud13,g_npn.npnud14,g_npn.npnud15
        WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t250_set_entry(p_cmd)
         CALL t250_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("npn01")  #FUN-560095
         CALL cl_set_docno_format("npn09")  #FUN-560095
         CALL cl_set_docno_format("npo03")  #FUN-560095

        AFTER FIELD npn01
           IF (p_cmd='a' AND g_npn.npn01 IS NOT NULL) OR                      #MOD-8C0280
              (p_cmd='u' AND g_npn.npn01 != g_npn_t.npn01) THEN               #MOD-8C0280
           CALL s_check_no("anm",g_npn.npn01,g_npn_t.npn01,"B","npn_file","npn01","")
              RETURNING li_result,g_npn.npn01
           DISPLAY BY NAME g_npn.npn01
           IF (NOT li_result) THEN
              NEXT FIELD npn01
           END IF
           END IF

        AFTER FIELD npn02
           IF NOT cl_null(g_npn.npn02) THEN
               SELECT nph02 INTO l_nph02 FROM nph_file WHERE nph01=g_npn.npn02
               IF STATUS = 0 THEN
                 CALL cl_err(l_nph02,'anm-075',0)    #No.FUN-660148
                 CALL cl_err3("sel","nph_file",g_npn.npn02,"","anm-075","","",1)  #No.FUN-660148
                 NEXT FIELD npn02
               END IF
              IF g_npn.npn02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1)
                 NEXT FIELD npn02
              END IF
              #TQC-C50107 ---add--str
              #當對單頭進行修改時，單頭票據日期必須不大於單身所有的到期日期
             #IF p_cmd='u' THEN                                            #MOD-C80059 mark
              IF p_cmd='u' AND g_npn.npn03 = '5' THEN                      #MOD-C80059 ad
                 LET l_true = 0
                 LET li_sql = " SELECT npo03 FROM npo_file ",
                              "  WHERE npo01 = '",g_npn.npn01,"'"
                 PREPARE t250_npo03 FROM li_sql
                 DECLARE npo03_cur1 CURSOR FOR t250_npo03
                 FOREACH npo03_cur1 INTO l_npo03
                    SELECT nmh05 INTO l_nmh05 FROM nmh_file
                     WHERE nmh01 = l_npo03
                    IF l_nmh05 < g_npn.npn02 THEN
                       LET l_true = 1
                    END IF
                 END FOREACH
                 IF l_true = 1 THEN
                    CALL cl_err('','anm-664',1)
                    NEXT FIELD npn02
                 END IF
              END IF
              #TQC-C50107---add--end
           END IF

        BEFORE FIELD npn03
           CALL t250_set_entry(p_cmd)

        AFTER FIELD npn03
           IF NOT cl_null(g_npn.npn03) THEN
              IF g_npn.npn03 NOT MATCHES "[23456789]" THEN      #NO.FUN-B40003  #TQC-B70197 add 2 #FUN-C70129 add 9
                 NEXT FIELD npn03
              END IF
           END IF
           #FUN-C70129--add--str
           IF g_npn.npn03 = '9' THEN
              CALL cl_set_comp_required('npn14',TRUE)
           ELSE
              CALL cl_set_comp_required('npn14',FALSE)
           END IF
           #FUN-C70129--add--end
           CALL t250_set_no_entry(p_cmd)

        #FUN-C80083--ADD--STR
        ON CHANGE npn03
           IF g_npn.npn03='4' THEN
              CALL cl_set_comp_visible('npo09,npo10',TRUE)
           ELSE
              CALL cl_set_comp_visible('npo09,npo10',FALSE)
           END IF
        #FUN-C80083--ADD--END
           #FUN-CA0083--add--str
           IF g_npn.npn03 = '9' THEN
              IF g_nmz.nmz11 = 'N' THEN
                 SELECT DISTINCT nms22,nms40 INTO g_npn.npn06,g_npn.npn07 FROM nms_file
                  WHERE nms01 = ' '
                 IF g_aza.aza63 = 'Y' THEN
                    SELECT DISTINCT nms221,nms401 INTO g_npn.npn061,g_npn.npn071 FROM nms_file
                     WHERE nms01 = ' '
                 END IF
              ELSE
                 IF NOT cl_null(g_npn.npn14) THEN
                    SELECT DISTINCT nms22,nms40 INTO g_npn.npn06,g_npn.npn07 FROM nms_file
                     WHERE nms01 = g_npn.npn14
                    IF g_aza.aza63 = 'Y' THEN
                       SELECT DISTINCT nms221,nms401 INTO g_npn.npn061,g_npn.npn071 FROM nms_file
                        WHERE nms01 = g_npn.npn14
                    END IF
                 END IF
              END IF
           ELSE
              IF p_cmd = 'a' THEN
                 LET g_npn.npn06 = ''
                 LET g_npn.npn07 = ''
              END IF
           END IF
           DISPLAY g_npn.npn06 to npn06
           DISPLAY g_npn.npn07 to npn07
           IF g_aza.aza63 = 'Y' THEN
              DISPLAY g_npn.npn061 to npn061
              DISPLAY g_npn.npn071 to npn071
           END IF
        #FUN-CA0083--add--end

        AFTER FIELD npn04
           IF NOT cl_null(g_npn.npn04) THEN
              SELECT azi02 INTO g_buf FROM azi_file WHERE azi01=g_npn.npn04
              IF STATUS THEN
                 CALL cl_err3("sel","azi_file",g_npn.npn04,"",STATUS,"","select azi",1)  #No.FUN-660148
                 NEXT FIELD npn04
              END IF
              IF g_npn_t.npn04 IS NULL OR g_npn_t.npn04 <> g_npn.npn04 THEN
                 CALL s_curr3(g_npn.npn04,g_npn.npn02,'B') RETURNING g_npn.npn05
              END IF
              IF cl_null(g_npn.npn05) THEN
                 LET g_npn.npn05=1
              END IF
              DISPLAY BY NAME g_npn.npn05
           END IF

       AFTER FIELD npn05   #匯率
           IF g_npn.npn04 =g_aza.aza17 THEN
              LET g_npn.npn05 =1
              DISPLAY BY NAME g_npn.npn05
            END IF
          #MOD-9C0372---add---start---
           IF g_npn.npn05 != g_npn_t.npn05 THEN
              DECLARE npn05_cs CURSOR FOR
               SELECT npo02,npo04 from npo_file
                WHERE npo01=g_npn.npn01
              FOREACH npn05_cs INTO l_npo02,l_npo04
               LET l_npo06= l_npo04 * g_npn.npn05
               CALL cl_digcut(l_npo06,g_azi04) RETURNING l_npo06
               UPDATE npo_file SET npo06=l_npo06 WHERE npo01=g_npn.npn01 AND npo02=l_npo02
              END FOREACH
              CALL t250_bu()
           END IF
          #MOD-9C0372---add---end---


        AFTER FIELD npn13
          #TQC-B70197 restorem --begin
           #NO.FUN-B40003--start--
           IF g_npn.npn03 = '2' THEN
               IF cl_null(g_npn.npn13) THEN
                   CALL cl_err('','anm-253',0)
                   NEXT FIELD npn13
               END IF
           END IF
           #NO.FUN-B40003--end--
          #TQC-B70197 restore --end
           IF NOT cl_null(g_npn.npn13) THEN
              CALL t250_npn13()
              IF NOT cl_null(g_errno) THEN
                 NEXT FIELD npn13
              END IF
              DISPLAY BY NAME g_npn.npn13
           END IF

        AFTER FIELD npn14
           IF NOT cl_null(g_npn.npn14) THEN
              CALL t250_npn14()
              IF NOT cl_null(g_errno) THEN
                 NEXT FIELD npn14
              END IF
              DISPLAY BY NAME g_npn.npn14
           END IF
           #TQC-C10084  --Begin
           IF cl_null(g_npn.npn14) AND g_npn.npn03 = '5' THEN
              CALL cl_err('','anm-103',0)
              NEXT FIELD npn14
           END IF
           #TQC-C10084  --End
           #FUN-CA0083--add--str
           IF g_npn.npn03 = '9' THEN
              IF g_nmz.nmz11 = 'Y' THEN
                 IF NOT cl_null(g_npn.npn14) THEN
                    SELECT DISTINCT nms22,nms40 INTO g_npn.npn06,g_npn.npn07 FROM nms_file
                     WHERE nms01 = g_npn.npn14
                    IF g_aza.aza63 = 'Y' THEN
                       SELECT DISTINCT nms221,nms401 INTO g_npn.npn061,g_npn.npn071 FROM nms_file
                        WHERE nms01 = g_npn.npn14
                    END IF
                 END IF
              END IF
              DISPLAY g_npn.npn06 to npn06
              DISPLAY g_npn.npn07 to npn07
              IF g_aza.aza63 = 'Y' THEN
                 DISPLAY g_npn.npn061 to npn061
                 DISPLAY g_npn.npn071 to npn071
              END IF
           END IF
           #FUN-CA0083--add--end

        AFTER FIELD npn06
           IF NOT cl_null(g_npn.npn06) THEN
              CALL t250_chkag(g_npn.npn06,'0')       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npn.npn06,'23',g_bookno1)
                    RETURNING g_npn.npn06
                 DISPLAY BY NAME g_npn.npn06
#FUN-B20073 --end--
                 NEXT FIELD npn06
              END IF
              DISPLAY BY NAME g_npn.npn06
           END IF

        AFTER FIELD npn07
           IF NOT cl_null(g_npn.npn07) THEN
              CALL t250_chkag(g_npn.npn07,'0')       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npn.npn07,'23',g_bookno1)
                    RETURNING g_npn.npn07
                 DISPLAY BY NAME g_npn.npn07
#FUN-B20073 --end--
                NEXT FIELD npn07
              END IF
              DISPLAY BY NAME g_npn.npn07
           END IF

        AFTER FIELD npn061
           IF NOT cl_null(g_npn.npn061) THEN
              CALL t250_chkag(g_npn.npn061,'1')       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npn.npn061,'23',g_bookno2)
                      RETURNING g_npn.npn061
                 DISPLAY BY NAME g_npn.npn061
#FUN-B20073 --end--
                 NEXT FIELD npn061
              END IF
              DISPLAY BY NAME g_npn.npn061
           END IF

        AFTER FIELD npn071
           IF NOT cl_null(g_npn.npn071) THEN
              CALL t250_chkag(g_npn.npn071,'1')       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npn.npn071,'23',g_bookno2)
                    RETURNING g_npn.npn071
                 DISPLAY BY NAME g_npn.npn071
#FUN-B20073 --end--
                 NEXT FIELD npn071
              END IF
              DISPLAY BY NAME g_npn.npn071
           END IF


        AFTER FIELD npnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER INPUT
           LET g_npn.npnuser = s_get_data_owner("npn_file") #FUN-C10039
           LET g_npn.npngrup = s_get_data_group("npn_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
           IF cl_null(g_npn.npn03) THEN
              NEXT FIELD npn03
           END IF
          #No.TQC-C30121   ---start---   Add
           IF g_npn.npn03 = '5' AND cl_null(g_npn.npn14) THEN
              NEXT FIELD npn14
           END IF
          #No.TQC-C30121   ---end---     Add
           #TQC-B70197  restore --begin
           #NO.FUN-B40003--start--Mark
           IF g_npn.npn03 = '2' THEN
              IF cl_null(g_npn.npn13) THEN
                  CALL cl_err('','anm-253',0)
                  NEXT FIELD npn13
              END IF
              LET l_nma10=''
              SELECT nma10 INTO l_nma10 FROM nma_file
                WHERE nma01=g_npn.npn13
              IF l_nma10 <> g_npn.npn04 THEN
                 CALL cl_err('','anm-260',0)
                 NEXT FIELD npn13
              END IF
           END IF
           #NO.FUN-B40003--end--Mark
           #TQC-B70197  restore  --end
           LET l_flag='N'

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(npn01)
                 LET g_t1 = s_get_doc_no(g_npn.npn01)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'B','ANM') RETURNING g_t1  #TQC-670008
                 LET g_npn.npn01 = g_t1            #No.FUN-550057
                 DISPLAY BY NAME g_npn.npn01 NEXT FIELD npn01
              WHEN INFIELD(npn04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_npn.npn04
                 CALL cl_create_qry() RETURNING g_npn.npn04
                 DISPLAY BY NAME g_npn.npn04
                 NEXT FIELD npn04
              WHEN INFIELD(npn06)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npn.npn06,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_npn.npn06
                 DISPLAY BY NAME g_npn.npn06
                 NEXT FIELD npn06
              WHEN INFIELD(npn07)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npn.npn07,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_npn.npn07
                 DISPLAY BY NAME g_npn.npn07
                 NEXT FIELD npn07

              WHEN INFIELD(npn061)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npn.npn061,'23',g_bookno2)     #No.FUN-980025
                 RETURNING g_npn.npn061
                 DISPLAY BY NAME g_npn.npn061
                 NEXT FIELD npn061
              WHEN INFIELD(npn071)
                  CALL s_get_bookno1(YEAR(g_npn.npn02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npn.npn071,'23',g_bookno2)     #No.FUN-980025
                 RETURNING g_npn.npn071
                 DISPLAY BY NAME g_npn.npn071
                 NEXT FIELD npn071

             WHEN INFIELD(npn13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_npn.npn13
                 CALL cl_create_qry() RETURNING g_npn.npn13
                 DISPLAY BY NAME g_npn.npn13
                 NEXT FIELD npn13
              WHEN INFIELD(npn14)
                #FUN-C90092--mod--str
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_pmc"
                #LET g_qryparam.default1 = g_npn.npn14
                #CALL cl_create_qry() RETURNING g_npn.npn14
                #DISPLAY BY NAME g_npn.npn14
                #NEXT FIELD npn14
                 CALL q_occ_pmc(FALSE,TRUE,g_plant) RETURNING g_npn.npn14,l_pmc03
                 DISPLAY BY NAME g_npn.npn14
                 DISPLAY l_pmc03 TO pmc03
                 NEXT FIELD npn14
                #FUN-C90092--mod--end
              WHEN INFIELD(npn05)
                   CALL s_rate(g_npn.npn04,g_npn.npn05) RETURNING g_npn.npn05
                   DISPLAY BY NAME g_npn.npn05
                   NEXT FIELD npn05
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

FUNCTION t250_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #分段輸入之行,列數  #No.FUN-680107 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,    #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680107 VARCHAR(1)
    l_nmaacti       LIKE nma_file.nmaacti,
    l_nma05         LIKE nma_file.nma05,
    l_b2            LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(30),
#    l_qty           LIKE ima_file.ima26,    #No.FUN-680107 DECIMAL(15,3) #FUN-A20044
    l_qty           LIKE type_file.num15_3, #FUN-A20044
    l_flag          LIKE type_file.num10,   #No.FUN-680107 INTEGER
    l_dir           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680107 SMALLINT
    l_nmh03         LIKE nmh_file.nmh03,
    l_nmh24         LIKE nmh_file.nmh24     #FUN-C80083
	#darcy:2024/08/22 add s---
	define 	l_nmh32	like nmh_file.nmh32,
		 	l_nmh42	like nmh_file.nmh42
	define 	l_npn01 like npn_file.npn01
	#darcy:2024/08/22 add e---

    LET g_action_choice = ""
    SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = g_npn.npn01
    IF cl_null(g_npn.npn01) THEN
       RETURN
    END IF
    IF g_npn.npnconf = 'Y' THEN
       CALL cl_err('','anm-105',0)
       RETURN
    END IF
    IF g_npn.npnconf='X' THEN
       CALL cl_err(g_npn.npn01,'9024',0)
       RETURN
    END IF
    CALL t250_g_b()
    CALL cl_opmsg('b')

   #No.TQC-C30121   ---start---   Add
    IF g_npn.npn03 = '5' THEN
      #CALL cl_set_comp_entry("npo05,npo06",FALSE) #TQC-C40101 mark
       CALL cl_set_comp_entry("npo06",FALSE)#TQC-C40101 add
    ELSE
      #CALL cl_set_comp_entry("npo05,npo06",TRUE)#TQC-C40101 mark
       CALL cl_set_comp_entry("npo06",TRUE)#TQC-C40101 add
    END IF
   #No.TQC-C30121   ---end---     Add

    LET g_forupd_sql = "SELECT * FROM npo_file WHERE npo01=? AND npo02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t250_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_npo WITHOUT DEFAULTS FROM s_npo.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
         IF g_rec_b!=0 THEN
           CALL fgl_set_arr_curr(l_ac)
         END IF

        BEFORE ROW
           LET p_cmd=''
           LET l_lock_sw = 'N'                   #DEFAULT
           LET l_ac = ARR_CURR()
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN t250_cl USING g_npn.npn01
           IF STATUS THEN
              CALL cl_err("OPEN t250_cl:", STATUS, 1)
              CLOSE t250_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t250_cl INTO g_npn.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
              CLOSE t250_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_npo_t.* = g_npo[l_ac].*  #BACKUP
              OPEN t250_bcl USING g_npn.npn01,g_npo_t.npo02
              IF STATUS THEN
                 CALL cl_err("OPEN t250_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t250_bcl INTO b_npo.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('lock npo',SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 CALL t250_b_move_to()
              END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
			#darcy:2024/08/22 add s---
			call anmt250_set_entry_b(p_cmd)
			call anmt250_no_set_entry_b(p_cmd)
			#darcy:2024/08/22 add e---

        BEFORE INSERT
           LET l_ac = ARR_CURR()
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_npo[l_ac].* TO NULL      #900423
           LET b_npo.npo01=g_npn.npn01
           INITIALIZE g_npo_t.* TO NULL
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD npo02

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL t250_b_move_back()
           INSERT INTO npo_file VALUES(b_npo.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","npo_file",b_npo.npo01,b_npo.npo02,SQLCA.sqlcode,"","ins npo",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              LET g_success = 'Y'
              CALL t250_bu()
              IF g_success='Y' THEN
                 COMMIT WORK
                 MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              ELSE
                 ROLLBACK WORK
                 MESSAGE 'ROLLBACK'
              END IF
           END IF

        BEFORE FIELD npo02                            #default 序號
           IF cl_null(g_npo[l_ac].npo02) OR g_npo[l_ac].npo02 = 0 THEN
              SELECT max(npo02)+1 INTO g_npo[l_ac].npo02
                FROM npo_file WHERE npo01 = g_npn.npn01
              IF cl_null(g_npo[l_ac].npo02) THEN
                 LET g_npo[l_ac].npo02 = 1
              END IF
           END IF

        AFTER FIELD npo02                        #check 序號是否重複
           IF cl_null(g_npo[l_ac].npo02) THEN NEXT FIELD npo02 END IF
           IF g_npo[l_ac].npo02 != g_npo_t.npo02 OR
              cl_null(g_npo_t.npo02) THEN
               SELECT count(*) INTO l_n FROM npo_file
                   WHERE npo01 = g_npn.npn01 AND npo02 = g_npo[l_ac].npo02
               IF l_n > 0 THEN
                   LET g_npo[l_ac].npo02 = g_npo_t.npo02
                   CALL cl_err('',-239,0) NEXT FIELD npo02
               END IF
           END IF

        AFTER FIELD npo03
           IF cl_null(g_npo[l_ac].npo03) THEN NEXT FIELD npo03 END IF
			#FUN-C80083--ADD---STR
			IF g_npn.npn03='4' THEN
				SELECT nmh24 INTO l_nmh24 FROM nmh_file
				WHERE nmh01=g_npo[l_ac].npo03
				IF g_aza.aza26 not matches  '[2458]' THEN #darcy:2025/06/27 add 458
				IF l_nmh24 <> 2 THEN
					CALL cl_err('','anm-347',0)
					NEXT FIELD npo03
				END IF
				END IF
			END IF
           #FUN-C80083--add--end
		   	#darcy:2024/08/22 add s---
			# 转付的时候,不能存在未审核资料
			# 增加票贴和转付逻辑一致
			if g_npn.npn03 matches '[458]' then #darcy:2025/05/08 add 增加兑现
				select count(*) into g_cnt from npn_file,npo_file
				where npn01 = npo01 and npnconf = 'N' and npo03 = g_npo[l_ac].npo03
				  and npn01 != g_npn.npn01
				if g_cnt > 0 then
					select unique npn01 into l_npn01 from npn_file,npo_file
					where npn01 = npo01 and npnconf = 'N' and npo03 = g_npo[l_ac].npo03
					call cl_err(l_npn01,"cnm-002",1)
					next field npo03
				end if
			end if
		   	#darcy:2024/08/22 add e---
           CALL t250_nmh(g_npo[l_ac].npo03)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_npo[l_ac].npo03,g_errno,0)
              LET g_npo[l_ac].npo03 = g_npo_t.npo03
              NEXT FIELD npo03
           END IF
           SELECT COUNT(*) INTO g_cnt FROM npn_file,npo_file
            WHERE npn01 = npo01 AND npo03 = g_npo[l_ac].npo03
              AND npn01 = g_npn.npn01 AND npo02 != g_npo[l_ac].npo02
           IF g_cnt > 0 THEN
              CALL cl_err(g_npo[l_ac].npo03,'anm-219',0)
              LET g_npo[l_ac].npo03 = g_npo_t.npo03
              NEXT FIELD npo03
           END IF
           SELECT COUNT(*) INTO g_cnt FROM npn_file,npo_file
            WHERE npn01 = npo01 AND npo03 = g_npo[l_ac].npo03
              AND npn03 = g_npn.npn03
              AND npn01 <> g_npn.npn01
              AND npnconf = 'N' #darcy:2024/08/22 mod <>'X' -> ='N'
           IF g_cnt > 0 THEN
              CALL cl_err(g_npo[l_ac].npo03,'anm-220',0)
              LET g_npo[l_ac].npo03 = g_npo_t.npo03
              NEXT FIELD npo03
           END IF
           LET g_npo[l_ac].npo06=g_npo[l_ac].npo04 * g_npn.npn05
           CALL cl_digcut(g_npo[l_ac].npo06,g_azi04) RETURNING g_npo[l_ac].npo06
           LET g_npo[l_ac].npodiff=g_npo[l_ac].npo06 - g_npo[l_ac].npo05
           DISPLAY BY NAME g_npo[l_ac].npo06
           DISPLAY BY NAME g_npo[l_ac].npodiff
           DISPLAY BY NAME g_npo[l_ac].npo03

		#darcy:2024/08/22 add s---
		after field npo04
			# 修改原币之后

			# 检查是否超过未转付金额
			select nmh02 into l_nmh32 from nmh_file where nmh01 = g_npo[l_ac].npo03
			select sum(npo04) into l_nmh42 from npo_file,npn_file
			 where npo01 = npn01 and npnconf = 'Y' and npo03 = g_npo[l_ac].npo03
			if cl_null(l_nmh32) then let l_nmh32 = 0 end if
			if cl_null(l_nmh42) then let l_nmh42 = 0 end if
			if l_nmh32 - l_nmh42   < g_npo[l_ac].npo04 then
				call cl_err_msg("","cnm-001",sfmt("%1|%2",g_npo[l_ac].npo04,l_nmh32 - l_nmh42 ),1)
				next field npo04
			end if

			let g_npo[l_ac].npo05=g_npo[l_ac].npo04 * g_npn.npn05
			call cl_digcut(g_npo[l_ac].npo05,g_azi04) returning g_npo[l_ac].npo05

			LET g_npo[l_ac].npo06=g_npo[l_ac].npo04 * g_npn.npn05
			call cl_digcut(g_npo[l_ac].npo06,g_azi04) returning g_npo[l_ac].npo06

			let g_npo[l_ac].npodiff=g_npo[l_ac].npo06 - g_npo[l_ac].npo05
			display by name g_npo[l_ac].npo06
			display by name g_npo[l_ac].npodiff
			display by name g_npo[l_ac].npo03
		#darcy:2024/08/22 add e---

        AFTER FIELD npo05,npo06
           SELECT nmh03 INTO l_nmh03 FROM nmh_file WHERE nmh01=g_npo[l_ac].npo03
           IF l_nmh03 = g_aza.aza17 THEN
              IF g_npo[l_ac].npo04 <> g_npo[l_ac].npo05 THEN
                 CALL cl_err(g_npo[l_ac].npo05,'anm-020',1)
                 LET g_npo[l_ac].npo05 = g_npo[l_ac].npo04
                 NEXT FIELD npo05
              END IF
           END IF
        #FUN-C80083---add---str
        AFTER FIELD npo09
           CALL cl_digcut(g_npo[l_ac].npo09,g_azi04) RETURNING g_npo[l_ac].npo09
           DISPLAY BY NAME g_npo[l_ac].npo09
        AFTER FIELD npo10
           IF cl_null(g_npo[l_ac].npo10) THEN
              LET g_npo[l_ac].npo10 = 0
              LET g_npo[l_ac].npo09 = 0
           ELSE
              IF g_npo[l_ac].npo10<0 THEN
                 CALL cl_err('','axm4011',0)
                 NEXT FIELD npo10
              END IF
              LET g_npo[l_ac].npo09 = g_npo[l_ac].npo10 * g_npn.npn05
              CALL cl_digcut(g_npo[l_ac].npo09,g_azi04) RETURNING g_npo[l_ac].npo09
              CALL cl_digcut(g_npo[l_ac].npo10,g_azi04) RETURNING g_npo[l_ac].npo10
              DISPLAY BY NAME g_npo[l_ac].npo10
              DISPLAY BY NAME g_npo[l_ac].npo09
           END IF
       #FUN-C80083--add--end
           CALL cl_digcut(g_npo[l_ac].npo05,g_azi04) RETURNING g_npo[l_ac].npo05
           CALL cl_digcut(g_npo[l_ac].npo06,g_azi04) RETURNING g_npo[l_ac].npo06
           LET g_npo[l_ac].npodiff=g_npo[l_ac].npo06 - g_npo[l_ac].npo05
           DISPLAY BY NAME g_npo[l_ac].npo05
           DISPLAY BY NAME g_npo[l_ac].npodiff
           DISPLAY BY NAME g_npo[l_ac].npo03

        AFTER FIELD npoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
           IF g_npo_t.npo02 > 0 AND g_npo_t.npo02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
              DELETE FROM npo_file
                WHERE npo01 = g_npn.npn01 AND npo02 = g_npo_t.npo02
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("del","npo_file",g_npn.npn01,g_npo_t.npo02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER DELETE
           CALL t250_bu()

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_npo[l_ac].* = g_npo_t.*
              CLOSE t250_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_npo[l_ac].npo02,-263,1)
              LET g_npo[l_ac].* = g_npo_t.*
           ELSE
              CALL t250_b_move_back()
              UPDATE npo_file SET * = b_npo.*
               WHERE npo01=g_npn.npn01 AND npo02=g_npo_t.npo02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","npo_file",g_npn.npn01,g_npo_t.npo02,SQLCA.sqlcode,"","upd npo",1)  #No.FUN-660148
                 LET g_npo[l_ac].* = g_npo_t.*
              ELSE
                 LET g_success = 'Y'
                 CALL t250_bu()
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
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac     #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_npo[l_ac].* = g_npo_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_npo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE t250_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30032 add
           CLOSE t250_bcl
           COMMIT WORK



        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(npo03)
                 CASE
                   #WHEN g_npn.npn03 MATCHES '[2345]'                                    #NO.FUN-B40003  #TQC-B70197 #MOD-C80059 mark
                    WHEN g_npn.npn03 MATCHES '[234]'                                     #MOD-C80059 add
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_nmh"
                       LET g_qryparam.default1 = g_npo[l_ac].npo03
                       LET g_qryparam.where = " nmh24 = 1 AND nmh03 ='",g_npn.npn04,"'"    #MOD-580071   #MOD-640036
                                             # " AND nmh05 >='",g_npn.npn02,"'"             #TQC-C50107 add #MOD-C80059 mark
                       #FUN-C80083---ADD---STR
                       IF g_npn.npn03 = '4' AND g_aza.aza26 = '2' THEN
                          LET g_qryparam.where = " nmh24  in('2','4','5','8') AND nmh03 ='",g_npn.npn04,"'" #darcy:2025/06/27 add 4,5,8
                                                 ," and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npn01 = npo01 and npnconf !='X' and npo03 = nmh01 ),0)" #darcy:2025/06/27 add
                       END IF
                       #FUN-C80083--ADD--END
                       CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                      #DISPLAY BY NAME g_npo[l_ac].npo03                                    #MOD-C80059 mark
                     WHEN g_npn.npn03 = 6   #MOD-580071
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_nmh"
                       LET g_qryparam.default1 = g_npo[l_ac].npo03
                      #LET g_qryparam.where = " nmh24 MATCHES '[1234]' AND nmh03 ='",g_npn.npn04,"'"   #MOD-580071 #MOD-640036 #MOD-C10010 mark
                      #LET g_qryparam.where = " nmh24 IN '[1234]' AND nmh03 ='",g_npn.npn04,"'"        #MOD-C10010 add   #MOD-CB0070
                      LET g_qryparam.where = " nmh24 IN ('1','2','3','4') AND nmh03 ='",g_npn.npn04,"'"    #MOD-CB0070 add
                                             #" AND nmh05 >='",g_npn.npn02,"'"                         #TQC-C50107 add #MOD-C80059 mark
                       CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                     WHEN g_npn.npn03 = 8   #MOD-580071
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_nmh"
                       LET g_qryparam.default1 = g_npo[l_ac].npo03
                      #LET g_qryparam.where = " nmh24 MATCHES '[23]' AND nmh03 ='",g_npn.npn04,"'"      #MOD-640036 #MOD-C10010 mark
                      #LET g_qryparam.where = " nmh24 IN '[23]' AND nmh03 ='",g_npn.npn04,"'"           #MOD-C10010 add #MOD-CB0070 mark
                      LET g_qryparam.where = " nmh24 IN ('2','3','4','5','8') AND nmh03 ='",g_npn.npn04,"'"  #MOD-CB0070 # darcy:2025/06/27 add
                                             ," and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npn01 = npo01 and npnconf !='X' and npo03 = nmh01 ),0)" #darcy:2025/06/27 add
                                             #"  AND nmh05 >='",g_npn.npn02,"'"                         #TQC-C50107 add #MOD-C80059 mark
                       CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                     #FUN-C70129-add--str
                     WHEN g_npn.npn03 = 9
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nmh"
                        LET g_qryparam.default1 = g_npo[l_ac].npo03
                        LET g_qryparam.where = " nmh24 = '5' AND nmh03 ='",g_npn.npn04,"'",
                                               " AND nmh05 >='",g_npn.npn02,"'",
                                               " AND nmh42 > 0 ",
                                               " AND nmh22 = '",g_npn.npn14,"'"
                        CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                     #FUN-C70129--add-end
                     WHEN g_npn.npn03 = 7   #MOD-580071
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_nmh"
                       LET g_qryparam.default1 = g_npo[l_ac].npo03
                      #LET g_qryparam.where = " nmh24 MATCHES '[2348]' AND nmh03='",g_npn.npn04,"'"     #MOD-640036 #MOD-920326 --> npn03 #MOD-C10010 mark
                      #LET g_qryparam.where = " nmh24 IN '[2348]' AND nmh03='",g_npn.npn04,"'"          #MOD-C10010 add  #MOD-CB0070 mark
                       LET g_qryparam.where = " nmh24 IN ('2','3','4','8') AND nmh03 ='",g_npn.npn04,"'" #MOD-CB0070 add
                                            # " AND nmh05 >='",g_npn.npn02,"'"                          #TQC-C50107 add #MOD-C80059 mark
                       CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                    #------------------------------MOD-C80059---------------------------(S)
                    WHEN g_npn.npn03 = 5
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_nmh"
                       LET g_qryparam.default1 = g_npo[l_ac].npo03
                       LET g_qryparam.where = " nmh24 in ('1','4','5','8') and nmh42 < nmh32  AND nmh03 ='",g_npn.npn04,"'", #darcy:2024/08/23 add #darcy:2025/06/27 add 4,8
                                              " AND nmh05 >='",g_npn.npn02,"'",
                                              " and nmh02 > nvl((select sum(npo04) from npo_file,npn_file where npn01 = npo01 and npnconf !='X' and npo03 = nmh01 ),0)" #darcy:2024/08/27 add
                       CALL cl_create_qry() RETURNING g_npo[l_ac].npo03
                    #------------------------------MOD-C80059---------------------------(E)
                 END CASE
                  DISPLAY BY NAME g_npo[l_ac].npo03           #No.MOD-490344
                 NEXT FIELD npo03
           END CASE

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

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END INPUT
    UPDATE npn_file SET npndate = g_today,npnmodu = g_user
     WHERE npn01 = g_npn.npn01

    CLOSE t250_bcl
    COMMIT WORK
    CALL t250_delHeader()     #CHI-C30002 add

END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t250_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041

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
        #CALL t250_x()             #FUN-D20035
         CALL t250_x(1)            #FUN-D20035
         IF g_npn.npnconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")
      END IF

      IF l_cho = 3 THEN
         DELETE FROM npp_file
          WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_npn.npn01
            AND npp011=g_npn.npn03
         DELETE FROM npq_file
          WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_npn.npn01
            AND npq011=g_npn.npn03
         DELETE FROM tic_file WHERE tic04 = g_npn.npn01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM npn_file WHERE npn01 = g_npn.npn01
         INITIALIZE g_npn.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t250_nmh(p_nmh01)
   DEFINE p_nmh01    LIKE nmh_file.nmh01
   DEFINE p_key      LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmh      RECORD LIKE nmh_file.*
   DEFINE l_nmh03    LIKE nmh_file.nmh03   #No.FUN-680107 VARCHAR(4)
   DEFINE l_nmh24    LIKE nmh_file.nmh24
   DEFINE l_nmhconf  LIKE nmh_file.nmh38   #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmh04    LIKE nmh_file.nmh04   #MOD-580071
   DEFINE l_nmh41    LIKE nmh_file.nmh41   #TQC-BC0031
   DEFINE l_rate     LIKE nmh_file.nmh39   #MOD-C20085i
   DEFINE l_nmh22    LIKE nmh_file.nmh22   #FUN-C70129
   DEFINE l_nmh42    LIKE nmh_file.nmh42
   LET g_errno = ' '
   #SELECT nmh31,nmh11,nmh21,nmh05,nmh09,nmh24,nmh28,nmh02,nmh32,nmh38,nmh03,nmh24,nmh04,nmh41          #MOD-580071  #TQC-BC0031  #CHI-C30113
    SELECT nmh31,nmh11,nmh30,nmh21,nmh05,nmh09,nmh24,nmh28,nmh02,nmh32,nmh38,nmh03,nmh24,nmh04,nmh41,   #CHI-C30113
           nmh22,nmh42                                                                                  #FUN-C70129 add
      INTO g_npo[l_ac].nmh31,g_npo[l_ac].nmh11,g_npo[l_ac].nmh30,                                       #CHI-C30113 ADD--g_npo[l_ac].nmh30
           g_npo[l_ac].nmh21,g_npo[l_ac].nmh05,
           g_npo[l_ac].nmh09,g_npo[l_ac].nmh24,g_npo[l_ac].nmh28,g_npo[l_ac].npo04,
           g_npo[l_ac].npo05,l_nmhconf,l_nmh03,l_nmh24,l_nmh04,l_nmh41,          #MOD-580071   #TQC-BC0031 add nmh41
           l_nmh22,l_nmh42 #FUn-C70129 add
      FROM nmh_file WHERE nmh01 = p_nmh01
  #SELECT nma02 INTO g_npo[l_ac].nma02_1 FROM nma_file WHERE nma01=g_npo[l_ac].nmh21   #CHI-C30113 #MOD-C80088 mark
  #DISPLAY BY NAME g_npo[l_ac].nma02_1                                                 #CHI-C30113 #MOD-C80088 mark
   IF g_nmz.nmz59='Y' THEN
      #No.MOD-C20085  --Begin
      #SELECT nmh39,nmh40 INTO g_npo[l_ac].nmh28,g_npo[l_ac].npo05
      #  FROM nmh_file WHERE nmh01 = p_nmh01
      SELECT nmh39 INTO l_rate
        FROM nmh_file WHERE nmh01 = p_nmh01
      IF cl_null(l_rate) OR l_rate = 0 THEN
         LET l_rate = g_npo[l_ac].nmh28
      END IF
      LET g_npo[l_ac].npo05 = g_npo[l_ac].npo04 * l_rate
      #No.MOD-C20085  --End
   END IF
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'anm-026'
      WHEN l_nmhconf='N'
         LET g_errno = 'aap-717'
      WHEN l_nmhconf='X'
         LET g_errno = '9024'
      WHEN l_nmh03 != g_npn.npn04
         LET g_errno = 'axr-144'
      #TQC-C50107--add--str
     #WHEN g_npo[l_ac].nmh05 < g_npn.npn02                                   #MOD-C80059 mark
      WHEN g_npo[l_ac].nmh05 < g_npn.npn02 AND g_npn.npn03 MATCHES '[5]'     #MOD-C80059 add
         LET g_errno = 'anm-664'
      #TQC-C50107--add--end
       WHEN g_npn.npn03 matches '[13]' AND l_nmh24 <> 1   #MOD-580071 #FUN-C80083 del--4 #darcy:2024/08/22 mv 5
         LET g_errno = 'anm-142'

       #FUN-C80083--ADD--STR
       WHEN g_npn.npn03 matches '[4]' AND  l_nmh24 not matches '[2458]' AND g_aza.aza26='2' #darcy:2025/06/27 mod matched 2458
         LET g_errno = 'anm-183'
       #FUN-C80083--ADD--END

       #TQC-B70197  restore  --begin
       #NO.FUN-B40003--start--Mark
       WHEN g_npn.npn03 matches '[2]' AND l_nmh24 NOT MATCHES '[16]'   #MOD-580071
         LET g_errno = 'anm-146'
       #NO.FUN-B40003--end--
       #TQC-B70197  restore  --end
       WHEN g_npn.npn03 matches '[6]' AND l_nmh24 NOT MATCHES '[1234]'    #MOD-580071
         LET g_errno = 'anm-143'
      WHEN g_npn.npn03 matches '[8]' AND l_nmh24 NOT MATCHES '[23458]' #darcy:2025/05/08 mod add 4,5
         LET g_errno = 'anm-145'
     #WHEN g_npn.npn03 matches '[7]' AND l_nmh24 NOT MATCHES '[348]'   #MOD-AB0172 mark
      WHEN g_npn.npn03 matches '[7]' AND l_nmh24 NOT MATCHES '[2348]'  #MOD-AB0172
         LET g_errno = 'anm-144'
      WHEN g_npn.npn03 MATCHES '[5678]' AND g_npn.npn02 < l_nmh04
         LET g_errno = 'anm-074'
      WHEN g_npn.npn03 MATCHES '[8]' AND g_npn.npn02 < g_npo[l_ac].nmh05   #MOD-B80268
         LET g_errno = 'anm-158'                                           #MOD-B80268
     # WHEN g_npn.npn03 = '5' AND l_nmh41 = 'Y'                              #TQC-BC0031   #MOD-D90007 mark
     #   LET g_errno = 'anm-169'                                             #MOD-D90007 mark
      #FUN-C70129--add--str
      WHEN g_npn.npn03 = '9' AND (l_nmh24 ! = '5' OR l_nmh22 ! = g_npn.npn14)
         LET g_errno = 'anm-262'
      WHEN g_npn.npn03 = '9' AND l_nmh24 = '5' AND l_nmh22 = g_npn.npn14 AND l_nmh42 <= 0
         LET g_errno = 'anm-319'
      #FUN-C70129--add--end
	  #darcy:2024/08/22 add s---
	  when g_npn.npn03 matches '[458]' #darcy:2025/05/08 add 8 #darcy:2025/06/27 简化语句
	  	# 1.转付的时候，要计算转付后的金额
		# 暂时不考虑外币情况
		# 2.票贴和转付逻辑一致,因为票贴可能是转付后才票贴
		select sum(npo04) into l_nmh42 from npo_file,npn_file
		 where npo01=npn01 and npnconf = 'Y' and npo03 = p_nmh01
		if cl_null(l_nmh42) then let l_nmh42 = 0 end if
		if g_npo[l_ac].npo04 - l_nmh42 <= 0 then
			let g_errno = 'cnm-003'
		else
			let g_npo[l_ac].npo04 = g_npo[l_ac].npo04 - l_nmh42
			let g_npo[l_ac].npo05 = g_npo[l_ac].npo04 * g_npn.npn05
			call cl_digcut(g_npo[l_ac].npo05,g_azi04) returning g_npo[l_ac].npo05
		end if

	  #darcy:2024/08/22 add e---
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  #-----------------MOD-C80088--------------(S)
   SELECT nma02 INTO g_npo[l_ac].nma02_1
     FROM nma_file
    WHERE nma01 = g_npo[l_ac].nmh21
   DISPLAY BY NAME g_npo[l_ac].nma02_1
  #-----------------MOD-C80088--------------(E)
END FUNCTION

FUNCTION t250_chkag(p_aag01,p_flag)
   DEFINE p_aag01      LIKE aag_file.aag01   #No.FUN-680107 VARCHAR(24)
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_aag03      LIKE aag_file.aag03
   DEFINE l_aag07      LIKE aag_file.aag07
   DEFINE l_acti       LIKE aag_file.aagacti #No.FUN-680107 VARCHAR(1)
   DEFINE p_flag       LIKE type_file.chr1       #No.FUN-730032
   LET g_errno = ' '

   CALL s_get_bookno(YEAR(g_npn.npn02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
   END IF
   IF p_flag = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   SELECT aag02,aag03,aag07,aagacti INTO l_aag02,l_aag03,l_aag07,l_acti
     FROM aag_file WHERE aag01 = p_aag01
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

FUNCTION t250_npn13()
   DEFINE l_nma02      LIKE nma_file.nma02
   DEFINE l_acti       LIKE nma_file.nmaacti #No.FUN-680107 VARCHAR(1)
   LET g_errno = ' '

   SELECT nma02,nmaacti INTO l_nma02,l_acti
     FROM nma_file WHERE nma01 = g_npn.npn13
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
        WHEN l_acti  ='N'         LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
   DISPLAY l_nma02 TO nma02

END FUNCTION

FUNCTION t250_npn14()
   DEFINE l_pmc03      LIKE pmc_file.pmc03
   DEFINE l_acti       LIKE pmc_file.pmcacti #No.FUN-680107 VARCHAR(1)
   LET g_errno = ' '

   SELECT pmc03,pmcacti INTO l_pmc03,l_acti
     FROM pmc_file WHERE pmc01 = g_npn.npn14
   #FUN-C90092--add---str
     IF cl_null(l_pmc03) THEN
        SELECT occ02,occacti INTO l_pmc03,l_acti
        FROM occ_file WHERE occ01=g_npn.npn14
     END IF
     #FUN-C90092--add---end
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
        WHEN l_acti  ='N'         LET g_errno = '9028'
        WHEN l_acti MATCHES '[PH]'       LET g_errno = '9038'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
   DISPLAY l_pmc03 TO pmc03

END FUNCTION

FUNCTION t250_bu()
   SELECT SUM(npo04),SUM(npo05),SUM(npo06)
     INTO g_npn.npn10,g_npn.npn11,g_npn.npn12
     FROM npo_file
    WHERE npo01=g_npn.npn01
   IF cl_null(g_npn.npn10) THEN
      LET g_npn.npn10 = 0
   END IF
   IF cl_null(g_npn.npn11) THEN
      LET g_npn.npn11 = 0
   END IF
   IF cl_null(g_npn.npn12) THEN
      LET g_npn.npn12 = 0
   END IF
   UPDATE npn_file SET npn10=g_npn.npn10,npn11=g_npn.npn11,npn12=g_npn.npn12
    WHERE npn01=g_npn.npn01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err3("upd","npn_file",g_npn.npn01,"",STATUS,"","upd npn23,06:",1)  #No.FUN-660148
      RETURN
   END IF
   LET g_amtdiff = g_npn.npn12-g_npn.npn11
   DISPLAY BY NAME g_npn.npn10,g_npn.npn11,g_npn.npn12
   DISPLAY g_amtdiff TO amt
END FUNCTION

FUNCTION t250_baskey()
DEFINE l_wc2   STRING #No.FUN-680107 VARCHAR(200) #MOD-BB0301 mod 1000 -> STRING

   CONSTRUCT g_wc1 ON npo02,npo03,npo04,npo05,npo06
                      ,npoud01,npoud02,npoud03,npoud04,npoud05
                      ,npoud06,npoud07,npoud08,npoud09,npoud10
                      ,npoud11,npoud12,npoud13,npoud14,npoud15
                 FROM s_npo[1].npo02,s_npo[1].npo03,
                      s_npo[1].npo04,s_npo[1].npo05,s_npo[1].npo06
                      ,s_npo[1].npoud01,s_npo[1].npoud02,s_npo[1].npoud03
                      ,s_npo[1].npoud04,s_npo[1].npoud05,s_npo[1].npoud06
                      ,s_npo[1].npoud07,s_npo[1].npoud08,s_npo[1].npoud09
                      ,s_npo[1].npoud10,s_npo[1].npoud11,s_npo[1].npoud12
                      ,s_npo[1].npoud13,s_npo[1].npoud14,s_npo[1].npoud15
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
   CALL t250_b_fill(l_wc2)
END FUNCTION

FUNCTION t250_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2      STRING #No.FUN-680107 VARCHAR(300) #MOD-BB0301 mod 1000 -> STRING
DEFINE l_nmh39    LIKE nmh_file.nmh39    #No.MOD-930139

    LET g_sql = "SELECT npo02,npo03,nmh31,nmh11,nmh30,nmh21,'',nmh05,nmh09,nmh24,nmh28,npo04, ",   #CHI-C30113  ADD--nmh30,''
                "       npo05,npo06,npo10,npo09,npo06-npo05, ",                                     #FUN-C80083 add npo09,npo10
                "       npoud01,npoud02,npoud03,npoud04,npoud05,",
                "       npoud06,npoud07,npoud08,npoud09,npoud10,",
                "       npoud11,npoud12,npoud13,npoud14,npoud15,",
                "       nmh39 ",  #No.MOD-930139
                " FROM npo_file LEFT OUTER JOIN nmh_file ON  npo03 = nmh_file.nmh01 ",
                " WHERE npo01 ='",g_npn.npn01,"'",        #單頭
                " AND ",p_wc2 CLIPPED,
                " ORDER BY 1"

    PREPARE t250_pb FROM g_sql
    DECLARE npo_curs CURSOR FOR t250_pb

    CALL g_npo.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH npo_curs INTO g_npo[g_cnt].*,l_nmh39    #單身 ARRAY 填充  #No.MOD-930139
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT nma02 INTO g_npo[g_cnt].nma02_1 FROM nma_file WHERE nma01=g_npo[g_cnt].nmh21                   #CHI-C30113
      DISPLAY g_npo[g_cnt].nma02_1 TO nma02_1                                                              #CHI-C30113
      IF g_nmz.nmz59 = 'Y' THEN
         IF NOT cl_null(l_nmh39) AND l_nmh39 > 0 THEN  #No.MOD-C20085
            LET g_npo[g_cnt].nmh28 = l_nmh39
         END IF  #No.MOD-C20085

      END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_npo.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t250_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npo TO s_npo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_set_act_visible("entry_sheet1", g_aza.aza63 = 'Y')  #MOD-9B0018 add

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  #No.FUN-550037
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
         CALL t250_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL t250_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL t250_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL t250_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL t250_fetch('L')
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
         CALL cl_show_fld_cont()                   #No.FUN-550037
         IF g_npn.npnconf = 'X' THEN
           LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_npn.npnconf,"","","",g_void,"")

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

       #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      ON ACTION entry_sheet1
         LET g_action_choice="entry_sheet1"
         EXIT DISPLAY
#@    ON ACTION 傳票拋轉
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY

#@    ON ACTION 傳票拋轉還原
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #@ON ACTION 應撤/退票立帳
      ON ACTION ent_note_wtdw_ret_ac
         LET g_action_choice="ent_note_wtdw_ret_ac"
         EXIT DISPLAY
      #@ON ACTION 應撤/退/作廢票立帳還原
      ON ACTION ent_note_wtdw_ret_ac_rtn
         LET g_action_choice="ent_note_wtdw_ret_ac_rtn"
         EXIT DISPLAY

      #@ON ACTION  撤退票串查應收
      ON ACTION qry_misc_ar
         LET g_action_choice="qry_misc_ar"
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
      #FUN-C70129--add--str
#@    ON ACTION 應撤/退/作廢票立帳
      ON ACTION ent_note_wtdw_ret_ac1
         LET g_action_choice="ent_note_wtdw_ret_ac1"
         EXIT DISPLAY

#@    ON ACTION 應撤/退/作廢票立帳還原
      ON ACTION ent_note_wtdw_ret_ac_rtn1
         LET g_action_choice="ent_note_wtdw_ret_ac_rtn1"
         EXIT DISPLAY

#@    ON ACTION 撤退票串查應付
      ON ACTION qry_misc_ap
         LET g_action_choice="qry_misc_ap"
         EXIT DISPLAY
      #FUN-C70129--add--end

      AFTER DISPLAY
         CONTINUE DISPLAY


     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t250_b_move_to()
   LET g_npo[l_ac].npo02 = b_npo.npo02
   LET g_npo[l_ac].npo03 = b_npo.npo03
   LET g_npo[l_ac].npo04 = b_npo.npo04
   LET g_npo[l_ac].npo05 = b_npo.npo05
   LET g_npo[l_ac].npo06 = b_npo.npo06
   #FUN-C80083--add--str
   LET g_npo[l_ac].npo09 = b_npo.npo09
   LET g_npo[l_ac].npo10 = b_npo.npo10
   IF cl_null(g_npo[l_ac].npo09) OR cl_null(g_npo[l_ac].npo10) THEN
      LET g_npo[l_ac].npo09=0
      LET g_npo[l_ac].npo10=0
   END IF
   #FUN-C80083--add--end
   LET g_npo[l_ac].npoud01 = b_npo.npoud01
   LET g_npo[l_ac].npoud02 = b_npo.npoud02
   LET g_npo[l_ac].npoud03 = b_npo.npoud03
   LET g_npo[l_ac].npoud04 = b_npo.npoud04
   LET g_npo[l_ac].npoud05 = b_npo.npoud05
   LET g_npo[l_ac].npoud06 = b_npo.npoud06
   LET g_npo[l_ac].npoud07 = b_npo.npoud07
   LET g_npo[l_ac].npoud08 = b_npo.npoud08
   LET g_npo[l_ac].npoud09 = b_npo.npoud09
   LET g_npo[l_ac].npoud10 = b_npo.npoud10
   LET g_npo[l_ac].npoud11 = b_npo.npoud11
   LET g_npo[l_ac].npoud12 = b_npo.npoud12
   LET g_npo[l_ac].npoud13 = b_npo.npoud13
   LET g_npo[l_ac].npoud14 = b_npo.npoud14
   LET g_npo[l_ac].npoud15 = b_npo.npoud15
END FUNCTION

FUNCTION t250_b_move_back()
   LET b_npo.npo01 = g_npn.npn01
   LET b_npo.npo02 = g_npo[l_ac].npo02
   LET b_npo.npo03 = g_npo[l_ac].npo03
   LET b_npo.npo04 = g_npo[l_ac].npo04
   LET b_npo.npo05 = g_npo[l_ac].npo05
   LET b_npo.npo06 = g_npo[l_ac].npo06
   #FUN-C80083--add--str
   LET b_npo.npo09 = g_npo[l_ac].npo09
   LET b_npo.npo10 = g_npo[l_ac].npo10
   IF cl_null(b_npo.npo09) OR cl_null(b_npo.npo10) THEN
      LET b_npo.npo09=0
      LET b_npo.npo10=0
   END IF
   #FUN-C80083--add--end
   LET b_npo.npoud01 = g_npo[l_ac].npoud01
   LET b_npo.npoud02 = g_npo[l_ac].npoud02
   LET b_npo.npoud03 = g_npo[l_ac].npoud03
   LET b_npo.npoud04 = g_npo[l_ac].npoud04
   LET b_npo.npoud05 = g_npo[l_ac].npoud05
   LET b_npo.npoud06 = g_npo[l_ac].npoud06
   LET b_npo.npoud07 = g_npo[l_ac].npoud07
   LET b_npo.npoud08 = g_npo[l_ac].npoud08
   LET b_npo.npoud09 = g_npo[l_ac].npoud09
   LET b_npo.npoud10 = g_npo[l_ac].npoud10
   LET b_npo.npoud11 = g_npo[l_ac].npoud11
   LET b_npo.npoud12 = g_npo[l_ac].npoud12
   LET b_npo.npoud13 = g_npo[l_ac].npoud13
   LET b_npo.npoud14 = g_npo[l_ac].npoud14
   LET b_npo.npoud15 = g_npo[l_ac].npoud15
   SELECT nmh24,nmh25 INTO b_npo.npo07,b_npo.npo08 FROM nmh_file
    WHERE nmh01=b_npo.npo03

   LET b_npo.npolegal = g_legal
END FUNCTION

FUNCTION t250_u()
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add

   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_npn.npn01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = g_npn.npn01
   IF g_npn.npnconf='Y' THEN
      CALL cl_err(g_npn.npn01,'anm-105',1)
      RETURN
   END IF
   IF g_npn.npnconf='X' THEN
      CALL cl_err(g_npn.npn01,'9024',0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t250_cl USING g_npn.npn01
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_npn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_npn.npnmodu = g_user
   LET g_npn.npndate = g_today
   LET g_npn_o.* = g_npn.*
   LET g_npn_t.* = g_npn.*
   CALL t250_show()
   IF g_success = 'N' THEN
      LET g_npn.* = g_npn_t.*
      CALL t250_show()
      ROLLBACK WORK
      RETURN
   END IF
   CALL t250_i('u')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_npn.* = g_npn_t.*
      CALL t250_show()
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE npn_file SET * = g_npn.* WHERE npn01 = g_npn_t.npn01
   IF STATUS THEN
      CALL cl_err3("upd","npn_file",g_npn_t.npn01,"",STATUS,"","up npn",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   IF g_npn.npn02 != g_npn_t.npn02 THEN            # 更改單號
      UPDATE npp_file SET npp02=g_npn.npn02
       WHERE npp01=g_npn.npn01
         AND npp00=2
         AND npp011=g_npn.npn03
         AND nppsys = 'NM'
      IF STATUS THEN
         CALL cl_err3("upd","npp_file",g_npn.npn01,g_npn.npn03,STATUS,"","upd npp02:",1)  #No.FUN-660148
      END IF
      #FUN-E80012---add---str---
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
      IF g_nmz.nmz70 = '3' THEN
         LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_npn.npn02,1)
         LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_npn.npn02,3)
         UPDATE tic_file SET tic01=l_tic01,
                             tic02=l_tic02
         WHERE tic04=g_npn.npn01
         IF STATUS THEN
            CALL cl_err3("upd","tic_file",g_npn.npn01,"",STATUS,"","upd tic01 tic02",1)
         END IF
      END IF
      #FUN-E80012---add---end---
   END IF
   CALL t250_show()
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_npn.npn01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t250_npp02(p_npptype)                # No.FUN-680034  add  p_npptype
  DEFINE p_npptype   LIKE npp_file.npptype    # No.FUN-680034
  DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
  IF g_npn.npn09 IS NULL OR g_npn.npn09=' ' THEN
     UPDATE npp_file SET npp02=g_npn.npn02
      WHERE npp01=g_npn.npn01 AND npp00=2 AND npp011=g_npn.npn03
        AND nppsys = 'NM' AND npptype=p_npptype     # No.FUN-680034 add  npptype=p_npptype
     IF STATUS THEN
        CALL cl_err3("upd","npp_file",g_npn.npn01,g_npn.npn03,STATUS,"","upd npp02:",1)  #No.FUN-660148
     END IF
  END IF
  #FUN-E80012---add---str---
      SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
      IF g_nmz.nmz70 = '3' THEN
        # LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_npn.npn02,1)#maoyy20210413
        # LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_npn.npn02,3)
        # UPDATE tic_file SET tic01=l_tic01,
         #                   tic02=l_tic02
        # WHERE tic04=g_npn.npn01
        # IF STATUS THEN
        #    CALL cl_err3("upd","tic_file",g_npn.npn01,"",STATUS,"","upd tic01 tic02",1)
        # END IF
      END IF
      #FUN-E80012---add---end---
END FUNCTION

FUNCTION t250_r()
    DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
           l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)

    IF s_anmshut(0) THEN
       RETURN
    END IF
    IF cl_null(g_npn.npn01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = g_npn.npn01
    IF g_npn.npnconf='Y' THEN
       CALL cl_err(g_npn.npn01,'anm-105',1)
       RETURN
    END IF
    IF g_npn.npnconf='X' THEN
       CALL cl_err(g_npn.npn01,'9024',0)
       RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t250_cl USING g_npn.npn01
    IF STATUS THEN
       CALL cl_err("OPEN t250_cl:", STATUS, 1)
       CLOSE t250_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t250_cl INTO g_npn.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
       CLOSE t250_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_npn_o.* = g_npn.*
    LET g_npn_t.* = g_npn.*
    CALL t250_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "npn01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_npn.npn01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM npp_file
        WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_npn.npn01
          AND npp011=g_npn.npn03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","npp_file",g_npn.npn01,g_npn.npn03,SQLCA.sqlcode,"","(t250_r:delete npp)",1)  #No.FUN-660148
          LET g_success='N'
       END IF
       DELETE FROM npq_file
        WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_npn.npn01
          AND npq011=g_npn.npn03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","npq_file",g_npn.npn01,g_npn.npn03,SQLCA.sqlcode,"","(t250_r:delete npq)",1)  #No.FUN-660148
          LET g_success='N'
       END IF

       #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = g_npn.npn01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","tic_file",g_npn.npn01,g_npn.npn03,SQLCA.sqlcode,"","(t250_r:delete tic)",1)
          LET g_success='N'
       END IF
       #FUN-B40056--add--end--

       DELETE FROM npo_file WHERE npo01 = g_npn.npn01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","npo_file",g_npn.npn01,"",SQLCA.sqlcode,"","(t250_r:delete npo)",1)  #No.FUN-660148
          LET g_success='N'
       END IF
       DELETE FROM npn_file WHERE npn01 = g_npn.npn01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","npn_file",g_npn.npn01,"",SQLCA.sqlcode,"","(t250_r:delete npn)",1)  #No.FUN-660148
          LET g_success='N'
       END IF
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal
                    VALUES ('anmt250',g_user,g_today,g_msg,g_npn.npn02,'Delete',g_plant,g_legal)
       INITIALIZE g_npn.* TO NULL
       CLEAR FORM                    #FUN-C80083
       CALL g_npo.clear()            #FUN-C80083
       IF g_success = 'Y' THEN
         #COMMIT WORK    #MOD-C60017 mark
          CALL cl_flow_notify(g_npn.npn01,'D')
          LET g_npn_t.* = g_npn.*
          OPEN t250_count
          #FUN-B50063-add-start--
          IF STATUS THEN
             CLOSE t250_cs
             CLOSE t250_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end--
          FETCH t250_count INTO g_row_count
          #FUN-B50063-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t250_cs
             CLOSE t250_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t250_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t250_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t250_fetch('/')
          END IF
		  	#darcy:2024/08/22 add s---
		  	CLOSE t250_cs
			CLOSE t250_count
			COMMIT WORK
		  	#darcy:2024/08/22 add e---
       ELSE
          ROLLBACK WORK
          LET g_npn.* = g_npn_t.*
       END IF
    END IF
    CALL t250_show()
END FUNCTION

FUNCTION t250_v(p_cmd)
   DEFINE l_wc      STRING #No.FUN-680107 VARCHAR(101) #MOD-BB0301 mod 1000 -> STRING
   DEFINE p_cmd     LIKE type_file.chr3    #No.FUN-680107 VARCHAR(02)
   DEFINE l_npn     RECORD LIKE npn_file.*
   DEFINE only_one  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_t1      LIKE nmy_file.nmyslip  #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3  #No.FUN-680107 VARCHAR(1)

   SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = g_npn.npn01
   IF g_npn.npnconf='X' THEN
      CALL cl_err(g_npn.npn01,'9024',0)
      RETURN
   END IF

   IF g_npn.npnconf='Y' THEN
      CALL cl_err(g_npn.npn01,'9023',0)
      RETURN
   END IF

   BEGIN WORK

   OPEN t250_cl USING g_npn.npn01
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_npn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF p_cmd  = '1' THEN


      OPEN WINDOW t250_w9 AT 4,11 WITH FORM "anm/42f/anmt2509"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("anmt2509")


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
         CLOSE WINDOW t250_w9
         RETURN
      END IF
      IF only_one = '1' THEN
         LET l_wc = " npn01 = '",g_npn.npn01,"' "
      ELSE
         CONSTRUCT BY NAME l_wc ON npn01,npn02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(npn01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_npn"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO npn01
                     NEXT FIELD npn01
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
            CLOSE WINDOW t250_w9
            RETURN
         END IF
      END IF
      CLOSE WINDOW t250_w9
   ELSE
      LET l_wc = " npn01 = '",g_npn.npn01,"' "
   END IF
   LET l_npn.* = g_npn.*   # backup old value
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM npn_file WHERE ",l_wc CLIPPED,
               " ORDER BY npn01"
   PREPARE t250_v_p FROM g_sql
   DECLARE t250_v_c CURSOR WITH HOLD FOR t250_v_p
   LET g_success='Y'
   CALL s_showmsg_init()           #No.FUN-710024
   FOREACH t250_v_c INTO g_npn.*
      IF STATUS THEN
         LET g_success ='N'     #FUN-8A0086
         EXIT FOREACH
      END IF
      IF g_npn.npn02 <= g_nmz.nmz10 THEN   #立帳日期小於關帳日期 no.5261
         CALL s_errmsg('','',g_npn.npn01,'aap-176',1)
         CONTINUE FOREACH
      END IF
      LET l_t1 = s_get_doc_no(g_npn.npn01)       #No.FUN-550057
      LET l_nmydmy3 = ''
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('nmyslip',l_t1,'sel nmy:',STATUS,0)
      END IF
      IF l_nmydmy3 = 'Y' THEN   #是否拋轉傳票
         IF NOT cl_null(g_npn.npn09) THEN
            CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
            MESSAGE g_npn.npn01,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         IF g_npn.npnconf='Y' THEN
            CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
            MESSAGE g_npn.npn01,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         CALL s_t250_gl(g_npn.npn01,'0')     # No.FUN-680034  add '0'
     IF g_aza.aza63 = 'Y' AND g_success = 'Y'  THEN
       CALL s_t250_gl(g_npn.npn01,'1')
     END IF
      END IF
   END FOREACH
   CALL s_showmsg()          #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   LET g_npn.*=l_npn.*
   MESSAGE " "
END FUNCTION

FUNCTION t250_firm1()
   DEFINE l_npn01_old LIKE npn_file.npn01
   DEFINE only_one    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_npp       RECORD LIKE npp_file.* #NO.FUN-670060
   DEFINE l_n         LIKE type_file.num5    #No.FUN-670060  #No.FUN-680107 SMALLINT

   IF cl_null(g_npn.npn01) THEN RETURN END IF
#CHI-C30107 -------------- add -------------- begin
   IF g_npn.npnconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npn.npnconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add -------------- end
   SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = g_npn.npn01
   IF g_npn.npnconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npn.npnconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
#FUN-B50090 add begin-------------------------
	#darcy:2024/08/22 add s---
	if not sanmt200_chk_amt(g_npn.npn01) then
		return
	end if
	#darcy:2024/08/22 add e---
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_npn.npn02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_npn.npn01,'aap-176',1)
      RETURN
   END IF
   #沒有單身資料,不可確認
   SELECT COUNT(*) INTO g_cnt FROM npo_file
    WHERE npo01 = g_npn.npn01
   IF g_cnt = 0 THEN
      RETURN
   END IF
   IF cl_null(g_nmz.nmz33) OR cl_null(g_nmz.nmz34) THEN
      CALL cl_err('','anm-261',1)
      RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   CALL s_get_doc_no(g_npn.npn01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
   IF cl_null(g_nmy.nmyglcr) THEN LET g_nmy.nmyglcr = 'N' END IF
   CALL s_get_bookno(YEAR(g_npn.npn02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN
     CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'0',g_bookno1)       #No.FUN-730032
   IF g_aza.aza63 = 'Y' AND g_success = 'Y'  THEN
     CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'1',g_bookno2)       #No.FUN-730032
   END IF
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_success='Y'
   LET l_npn01_old=g_npn.npn01    # backup old key value npn01
   BEGIN WORK
   OPEN t250_cl USING g_npn.npn01
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_npn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #是否已經有分錄底稿
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys= 'NM'
         AND npq00=2
         AND npq01 =g_npn.npn01
         AND npq011=g_npn.npn03
      IF l_n = 0 THEN
         CALL t250_gen_glcr(g_npn.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN
         CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'0',g_bookno1)       #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y'  THEN
         CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'1',g_bookno2)       #No.FUN-730032
      END IF
      END IF
   END IF
   IF g_success='Y' THEN     #No:8608
      CALL t250_y1()
      CALL t250_b_fill(' 1=1')                    #MOD-C90120 add
   END IF
   IF g_success='N' THEN
      CALL s_showmsg()          #No.FUN-710024
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE npn_file SET npnconf = 'Y' WHERE npn01 = g_npn.npn01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('npn01',g_npn.npn01,'upd npnconf',STATUS,1)
      SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
      CLOSE t250_cl
      CALL s_showmsg()          #No.FUN-710024
      ROLLBACK WORK
      RETURN
   ELSE
      CLOSE t250_cl
      CALL s_showmsg()          #No.FUN-710024
      COMMIT WORK
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_npn.npn01,'" AND npp011 = ',g_npn.npn03
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
                " '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' ",                                #No.FUN-680034
                " '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_npn.npn02,"' 'Y' '1' 'Y'"   #No.FUN-680034#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT npn09 INTO g_npn.npn09 FROM npn_file
       WHERE npn01 = g_npn.npn01
      DISPLAY BY NAME g_npn.npn09
   END IF

   SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
   DISPLAY g_npn.npnconf TO npnconf
   CALL cl_set_field_pic(g_npn.npnconf,"","","","N","")   #MOD-AC0073
END FUNCTION

FUNCTION t250_y1()
DEFINE l_nma21    LIKE nma_file.nma21

   DECLARE t250_ics2 CURSOR  WITH HOLD FOR
        SELECT * FROM npo_file WHERE npo01 = g_npn.npn01 ORDER BY npo02
   MESSAGE g_npn.npn01
   CALL s_showmsg_init()   #No.FUN-710024
   FOREACH t250_ics2 INTO m_npo.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('npo01',g_npn.npn01,'foreach #2',status,1)
         LET g_success='N'               #No:8608
         EXIT FOREACH
      END IF
      IF cl_null(m_npo.npo03) THEN CONTINUE FOREACH END IF
      SELECT * INTO g_nmh.* FROM nmh_file
       WHERE nmh01=m_npo.npo03 AND nmh38 = 'Y'
      IF STATUS THEN
         CALL s_errmsg('nmh01',m_npo.npo03,'nmd38','anm-231',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF g_npn.npn03 = '8' OR g_npn.npn03 = '7' THEN
         LET l_nma21 = null
         SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = g_nmh.nmh06
         IF l_nma21 IS NOT NULL AND l_nma21 >= g_npn.npn02 THEN #MOD-980093 add =
            CALL s_errmsg('nma01',g_nmh.nmh06,g_nmh.nmh06,'anm-225',1)
            LET g_success = 'N'
         CONTINUE FOREACH
         END IF
      END IF
      IF g_npn.npn03 MATCHES '[235]' THEN         #NO.FUN-B40003 Delete 2 #TQC-B70197 add 2 #FUN-C80083 del--4
         IF g_nmh.nmh24 <> '1' THEN
		 	#darcy:2024/08/22 mod s---
            if g_npn.npn03 != '5' then
               CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
               LET g_success='N'
               CONTINUE FOREACH
            else
               if g_nmh.nmh24 not matches '[1458]' then #darcy add 4 , 8
                  CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
                  LET g_success='N'
                  CONTINUE FOREACH
               end if
            end if
            #darcy:2024/08/22 mod e---
         END IF
      END IF

      #FUN-C80083--ADD---STR
      IF g_npn.npn03 MATCHES '[4]' THEN
         IF g_nmh.nmh24 NOT MATCHES '[2458]' THEN #darcy:2025/06/27 add 3,5,8
            CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      #FUN-C80083--ADD--end-

      IF g_npn.npn03 MATCHES '[6]' THEN
         IF g_nmh.nmh24 NOT MATCHES '[1234]' THEN
            CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      IF g_npn.npn03 MATCHES '[8]' THEN
         IF g_nmh.nmh24 NOT MATCHES '[23458]' THEN #darcy:2025/05/08 add 4  darcy:2025/06/27 add 5
            CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      IF g_npn.npn03 MATCHES '[7]' THEN
        #IF g_nmh.nmh24 NOT MATCHES '[348]' THEN              #MOD-AB0172 mark
         IF g_nmh.nmh24 NOT MATCHES '[2348]' THEN             #MOD-AB0172
            CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-228',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      #兌現or 兌現後退票
     #IF g_npn.npn03='8' OR (g_npn.npn03='7' AND m_npo.npo07='8') OR g_npn.npn03 = '9'  OR g_npn.npn03='4' THEN #FUN-C70129 add 9  #FUN-C80083 add--4#FUN-CA0083 mark
      IF g_npn.npn03='8' OR (g_npn.npn03='7' AND m_npo.npo07='8') OR g_npn.npn03='4' THEN #FUN-CA0083 del 9
         CALL t250_ins_nme()
      END IF
      IF g_npn.npn03<>'1' THEN
         CALL t250_ins_nmi()
      END IF
      CALL t250_upd_nmh('+')
      IF g_success='N' THEN
         CONTINUE FOREACH           #No.FUN-710024
      END IF
   END FOREACH
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF

END FUNCTION

FUNCTION t250_firm2()
   DEFINE l_npn01_old LIKE npn_file.npn01
   DEFINE only_one    LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       STRING                #No.FUN-670060
   DEFINE l_cnt       LIKE type_file.num5   #CHI-810019
   DEFINE l_npo03     LIKE npo_file.npo03   #MOD-C80263 add
   DEFINE l_nmh31     LIKE nmh_file.nmh31   #MOD-C80263 add

   IF cl_null(g_npn.npn01) THEN RETURN END IF
   IF g_npn.npnconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npn.npnconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
  #---------------MOD-C80263---------------------(S)
   IF g_npn.npn03 MATCHES '[678]' THEN
      LET g_sql="SELECT npo03 FROM npo_file",
                " WHERE npo01='",g_npn.npn01,"'"
      PREPARE npo03_p1 FROM g_sql
      DECLARE npo03_cs1 CURSOR FOR npo03_p1

      FOREACH npo03_cs1 INTO l_npo03
         SELECT nmh31 INTO l_nmh31
           FROM nmh_file
          WHERE nmh01 = l_npo03
         SELECT COUNT(*) INTO l_cnt
           FROM nmh_file
          WHERE nmh31 = l_nmh31
            AND nmh04 > g_npn.npn02
            AND nmh38 <> 'X'
         IF l_cnt > 0 THEN
            CALL cl_err(l_nmh31,'anm-242',0)
            RETURN
         END IF
      END FOREACH

   END IF
  #---------------MOD-C80263---------------------(E)
   LET l_npn01_old=g_npn.npn01    # backup old key value npn01
   LET g_success = 'Y'
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_npn.npn02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_npn.npn01,'aap-176',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM oma_file
    WHERE oma16 = g_npn.npn01
   IF l_cnt > 0 THEN
      CALL cl_err(g_npn.npn01,'anm-403',1)
      RETURN
   END IF
   #FUN-C70129--add--str
   SELECT COUNT(*) INTO l_cnt FROM apa_file
    WHERE apa25 = g_npn.npn01
   IF l_cnt > 0 THEN
      CALL cl_err(g_npn.npn01,'axm-389',1)
      RETURN
   END IF
   #FUN-C70129--add--end
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_npn.npn01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_npn.npn09) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_npn.npn01,'anm-230',1)
         LET g_success = 'N'
      ELSE
         LET g_plant_new = g_nmz.nmz02p
         #CALL s_getdbs()    #FUN-A50102
         LET l_sql = "SELECT aba19 ",
                     #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
                     "  FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                     " WHERE aba00 = '",g_nmz.nmz02b,"' ",
                     "   AND aba01 = '",g_npn.npn09,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
         PREPARE aba_pre FROM l_sql
         DECLARE aba_cs CURSOR FOR aba_pre
         OPEN aba_cs
         IF SQLCA.sqlcode THEN RETURN END IF
         FETCH aba_cs INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_npn.npn09,'axr-071',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
   IF g_success='N'THEN
      SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npn.npn09,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT npn09 INTO g_npn.npn09 FROM npn_file
       WHERE npn01 = g_npn.npn01
      IF NOT cl_null(g_npn.npn09) THEN
         CALL cl_err(g_npn.npn09,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_npn.npn09
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t250_cl USING g_npn.npn01
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_npn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t250_z1()
   CALL t250_b_fill(' 1=1')                    #MOD-C90120 add

   IF g_success='N'THEN
      SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
      CALL s_showmsg()   #No.FUN-710024
      ROLLBACK WORK
      CLOSE t250_cl
      RETURN
   END IF

   UPDATE npn_file SET npnconf = 'N' WHERE npn01 = g_npn.npn01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('npn01',g_npn.npn01,'upd npnconf',STATUS,1)  #No.FUN-710024
      SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
      CALL s_showmsg()   #No.FUN-710024
      ROLLBACK WORK RETURN
   END IF
   IF g_success='N' THEN
      SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
      CALL s_showmsg()   #No.FUN-710024
      ROLLBACK WORK
      RETURN
   ELSE
      CALL s_showmsg()   #No.FUN-710024
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF

   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npn.npn09,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT npn09 INTO g_npn.npn09 FROM npn_file
   #    WHERE npn01 = g_npn.npn01
   #   DISPLAY BY NAME g_npn.npn09
   #END IF
   #CHI-C90052 mark end-----

   SELECT * INTO g_npn.* FROM npn_file WHERE npn01 = l_npn01_old
   DISPLAY g_npn.npnconf TO npnconf
END FUNCTION


FUNCTION t250_z1()
   DEFINE l_nmh24     LIKE nmh_file.nmh24    #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt       LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_nme24     LIKE nme_file.nme24    #No.FUN-730032
   DEFINE l_nmh42     LIKE nmh_file.nmh42    #No.FUN-B40011
   #darcy:2024/08/27 add s---
   define l_aph05f   like aph_file.aph05f
   define l_npo04    like npo_file.npo04
   #darcy:2024/08/27 add e---

   DECLARE t250_dcs2 CURSOR  WITH HOLD FOR
        SELECT npo_file.*, nmh24
          FROM npo_file LEFT OUTER JOIN nmh_file ON npo03 = nmh_file.nmh01
         WHERE npo01 = g_npn.npn01
         ORDER BY npo02
   MESSAGE g_npn.npn01
   CALL s_showmsg_init()   #No.FUN-710024
   FOREACH t250_dcs2 INTO m_npo.*,l_nmh24
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('npo01',g_npn.npn01,'foreach #2',STATUS,1)
         EXIT FOREACH
      END IF
      IF cl_null(m_npo.npo03) THEN
         CONTINUE FOREACH
      END IF
      SELECT COUNT(*) INTO l_cnt FROM npn_file,npo_file
       WHERE npo03=m_npo.npo03 AND npn01=npo01
         AND npn01 <> g_npn.npn01
         AND npnconf='N'
      IF l_cnt > 0 THEN
         CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-653',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
	  #darcy:2024/08/22 add s---
	  if not sanmt200_undo_chk(m_npo.npo03,g_npn.npn01) then
	  	let g_success='N'
		continue foreach
	  end if
	  #darcy:2024/08/22 add e---
      IF g_npn.npn03<>l_nmh24 THEN
         CALL cl_err(m_npo.npo02,'anm-228',1)
         CALL s_errmsg('npo03',m_npo.npo03,m_npo.npo03,'anm-653',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF g_npn.npn03='8' OR g_npn.npn03 = '4'  THEN  #FUN-C80083--add-4
         IF g_aza.aza73 = 'Y' THEN
            LET g_sql="SELECT nme24 FROM nme_file",
                     #" WHERE nme12='",m_npo.npo03,"'",   #MOD-B30576 mark
                      " WHERE nme12='",g_npn.npn01,"'",   #MOD-B30576
                      "   AND nme21 = '",m_npo.npo02,"'", #MOD-B50085
                      "   AND nme03='",g_nmz.nmz33,"'"
            PREPARE nme24_p1 FROM g_sql
            DECLARE nme24_cs1 CURSOR FOR nme24_p1
            FOREACH nme24_cs1 INTO l_nme24
               IF l_nme24 != '9' THEN
                  CALL cl_err(m_npo.npo03,'anm-043',1)
                  LET g_success='N'
                  RETURN
               END IF
            END FOREACH
         END IF
         #TQC-B70209  --begin
         IF g_nmz.nmz70 ='1' THEN
            DELETE FROM tic_file
             WHERE tic04 IN (
            SELECT nme12 FROM nme_file
             WHERE nme12 = g_npn.npn01
               AND nme03=g_nmz.nmz33
               AND nme21 = m_npo.npo02)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('tic04',g_npn.npn01,'del tic',STATUS,1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         END IF
         #TQC-B70209  --end
        #DELETE FROM nme_file WHERE nme12 = m_npo.npo03 AND nme03=g_nmz.nmz33   #MOD-B30576 mark
         DELETE FROM nme_file WHERE nme12 = g_npn.npn01 AND nme03=g_nmz.nmz33   #MOD-B30576
                                AND nme21 = m_npo.npo02                         #MOD-B50085
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nme12',g_npn.npn01,'del nme',STATUS,1)  #MOD-B30576 mod
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         #TQC-B70209  --begin  mark
         #FUN-B40056  --begin
        # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
        #    DELETE FROM tic_file
        #     WHERE tic04 IN (
        #    SELECT nme12 FROM nme_file
        #     WHERE nme12 = g_npn.npn01
        #       AND nme03=g_nmz.nmz33
        #       AND nme21 = m_npo.npo02)
        #    IF SQLCA.sqlcode THEN
        #       CALL s_errmsg('tic04',g_npn.npn01,'del tic',STATUS,1)
        #       LET g_success='N'
        #       CONTINUE FOREACH
        #    END IF
        # END IF
         #FUN-B40056  --end
         #TQC-B70209  --end mark
      END IF
      IF (g_npn.npn03='7' AND m_npo.npo07='8') THEN
         IF g_aza.aza73 = 'Y' THEN
            LET g_sql="SELECT nme24 FROM nme_file",
                     #" WHERE nme12='",m_npo.npo03,"'",   #MOD-B30576 mark
                      " WHERE nme12='",g_npn.npn01,"'",   #MOD-B30576
                      "   AND nme21 = '",m_npo.npo02,"'", #MOD-B50085
                      "   AND nme03='",g_nmz.nmz34,"'"
            PREPARE nme24_p2 FROM g_sql
            DECLARE nme24_cs2 CURSOR FOR nme24_p2
            FOREACH nme24_cs2 INTO l_nme24
               IF l_nme24 != '9' THEN
                  CALL cl_err(m_npo.npo03,'anm-043',1)
                  LET g_success='N'
                  RETURN
               END IF
            END FOREACH
         END IF
         #TQC-B70209  --begin
         IF g_nmz.nmz70 ='1' THEN
            DELETE FROM tic_file
             WHERE tic04 IN (
            SELECT nme12 FROM nme_file
             WHERE nme12 = g_npn.npn01
               AND nme03 = g_nmz.nmz34
               AND nme21 = m_npo.npo02)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('tic04',g_npn.npn01,'del tic',STATUS,1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         END IF
         #TQC-B70209  --end
        #DELETE FROM nme_file WHERE nme12 = m_npo.npo03 AND nme03=g_nmz.nmz34   #MOD-B30576 mark
         DELETE FROM nme_file WHERE nme12 = g_npn.npn01 AND nme03=g_nmz.nmz34   #MOD-B30576
                                AND nme21 = m_npo.npo02                         #MOD-B50085
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nme12',g_npn.npn01,'del nme',STATUS,1)  #MOD-B30576 mod
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         #TQC-B70209  --begin mark
         #FUN-B40056  --begin
       #  IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
       #     DELETE FROM tic_file
       #      WHERE tic04 IN (
       #     SELECT nme12 FROM nme_file
       #      WHERE nme12 = g_npn.npn01
       #        AND nme03 = g_nmz.nmz34
       #        AND nme21 = m_npo.npo02)
       #     IF SQLCA.sqlcode THEN
       #        CALL s_errmsg('tic04',g_npn.npn01,'del tic',STATUS,1)
       #        LET g_success='N'
       #        CONTINUE FOREACH
       #     END IF
       #  END IF
         #FUN-B40056  --end
         #TQC-B70209  --end mark
      END IF
#--begin-- FUN-B40011
      IF g_npn.npn03 = '5' THEN
         #darcy:2024/08/27 add s---
         # 如果此笔金额小于aapt330未冲金额，不允许取消审核
         # 1. 获取aapt330 中未作废的冲销金额
         select sum(aph05f) into l_aph05f from aph_file,apf_file
          where apf03 = g_npn.npn14 and apf01 = aph01
            and aph03 = 'D' and aph04 = m_npo.npo03
            and apf41 <> 'X'
         if cl_null(l_aph05f) then let l_aph05f = 0 end if

         # 2. 本币金额汇总
         select sum(npo04) into l_npo04 from npo_file,npn_file
          where npo03 = m_npo.npo03 and npo01 = npn01
            and npnconf <> 'X' and npn14 = g_npn.npn14
            and npn01 = g_npn.npn01 # darcy add
         if cl_null(l_npo04) then let l_npo04 = 0 end if

         # 本笔已经被冲，不允许取消审核
         if l_npo04 - l_aph05f > m_npo.npo04 then
            call cl_err(m_npo.npo03,'anm-404',1)
            let g_success='N'
            return
         end if

         #darcy:2024/08/27 add e---
         #darcy:2024/08/27 mark s---
         # LET g_sql="SELECT nmh42 FROM nmh_file",
         #           " WHERE nmh01 = '",m_npo.npo03,"'"
         # PREPARE nmh42_p2 FROM g_sql
         # DECLARE nmh42_cs2 CURSOR FOR nmh42_p2
         # FOREACH nmh42_cs2 INTO l_nmh42
         #    IF l_nmh42>0 THEN
         #      CALL cl_err(m_npo.npo03,'anm-404',1)
         #      LET g_success='N'
         #      RETURN
         #    END IF
         # END FOREACH
         #darcy:2024/08/27 mark e---
      END IF
#--end-- FUN-B40011

     #FUN-CA0083--mark--str
     ##FUN-C70129--add--str
     #IF g_npn.npn03='9'  THEN
     #   IF g_aza.aza73 = 'Y' THEN
     #      LET g_sql="SELECT nme24 FROM nme_file",
     #                " WHERE nme12='",g_npn.npn01,"'",
     #                "   AND nme21 = '",m_npo.npo02,"'",
     #                "   AND nme03='",g_nmz.nmz32,"'"
     #      PREPARE nme24_p9 FROM g_sql
     #      DECLARE nme24_cs9 CURSOR FOR nme24_p9
     #      FOREACH nme24_cs9 INTO l_nme24
     #         IF l_nme24 != '9' THEN
     #            CALL cl_err(m_npo.npo03,'anm-043',1)
     #            LET g_success='N'
     #            RETURN
     #         END IF
     #      END FOREACH
     #   END IF
     #   IF g_nmz.nmz70 ='1' THEN
     #      DELETE FROM tic_file
     #       WHERE tic04 IN (
     #      SELECT nme12 FROM nme_file
     #       WHERE nme12 = g_npn.npn01
     #         AND nme03=g_nmz.nmz33
     #         AND nme21 = m_npo.npo02)
     #      IF SQLCA.sqlcode THEN
     #         CALL s_errmsg('tic04',g_npn.npn01,'del tic',STATUS,1)
     #         LET g_success='N'
     #         CONTINUE FOREACH
     #      END IF
     #   END IF
     #   DELETE FROM nme_file WHERE nme12 = g_npn.npn01 AND nme03=g_nmz.nmz32
     #                          AND nme21 = m_npo.npo02
     #   IF SQLCA.sqlcode THEN
     #      CALL s_errmsg('nme12',g_npn.npn01,'del nme',STATUS,1)
     #      LET g_success='N'
     #      CONTINUE FOREACH
     #   END IF
     #END IF
     ##FUN-C70129--add--end
     #FUN-CA0083--mark--end
      IF g_npn.npn03<>'1' THEN
         DELETE FROM nmi_file WHERE nmi01 = m_npo.npo03 AND nmi06=g_npn.npn03
                         AND nmi05=m_npo.npo07 and ( nmi10 = g_npn.npn01 or nmi10 is null) #darcy:2024/08/27 add nmi10
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nmi01',m_npo.npo03,'del nmi',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF

      CALL t250_upd_nmh('-')
      IF g_success='N' THEN
         CONTINUE FOREACH             #No.FUN-710024
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

END FUNCTION

#FUNCTION t250_x()                    #FUN-D20035
FUNCTION t250_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_anmshut(0) THEN RETURN END IF
   SELECT * INTO g_npn.* FROM npn_file WHERE npn01=g_npn.npn01
   IF g_npn.npn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_npn.npnconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_npn.npnconf ='X' THEN RETURN END IF
   ELSE
      IF g_npn.npnconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
   OPEN t250_cl USING g_npn.npn01
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_npn.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
  #IF cl_void(0,0,g_npn.npnconf) THEN              #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
     #IF g_npn.npnconf='N' THEN    #切換為作廢                         #FUN-D20035
      IF p_type = 1 THEN                                               #FUN-D20035
         DELETE FROM npp_file
             WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_npn.npn01
               AND npp011=g_npn.npn03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_npn.npn01,"",SQLCA.sqlcode,"","(t250_r:delete npp)",1)  #No.FUN-660148
            LET g_success='N'
         END IF
         DELETE FROM npq_file
             WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_npn.npn01
               AND npq011=g_npn.npn03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_npn.npn01,"",SQLCA.sqlcode,"","(t250_r:delete npq)",1)  #No.FUN-660148
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_npn.npn01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_npn.npn01,g_npn.npn03,SQLCA.sqlcode,"","(t250_r:delete tic)",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--

         LET g_npn.npnconf='X'
      ELSE                         #取消作廢
         LET g_npn.npnconf='N'
      END IF
      UPDATE npn_file SET
             npnconf=g_npn.npnconf,
             npnmodu=g_user,
             npndate=g_today
       WHERE npn01 = g_npn.npn01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","npn_file",g_npn.npn01,"",STATUS,"","",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_npn.npn01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT npnconf INTO g_npn.npnconf FROM npn_file WHERE npn01 = g_npn.npn01
   DISPLAY BY NAME g_npn.npnconf
END FUNCTION

FUNCTION t250_ins_nme()
#FUN-B30166--add--str
  DEFINE l_year     LIKE type_file.chr4
  DEFINE l_month    LIKE type_file.chr4
  DEFINE l_day      LIKE type_file.chr4
  DEFINE l_dt       LIKE type_file.chr20
  DEFINE l_date1    LIKE type_file.chr20
  DEFINE l_time     LIKE type_file.chr20
  DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
   INITIALIZE g_nme.* TO NULL
   LET g_nme.nme00 = 0
   LET g_nme.nme01 = g_nmh.nmh21
   LET g_nme.nme02 = g_npn.npn02
   IF cl_null(g_nme.nme01) THEN LET g_nme.nme01 = ' ' END IF #FUN-C70129 add
   IF g_npn.npn03='7' THEN #退票
      LET g_nme.nme03 = g_nmz.nmz34
   ELSE
      LET g_nme.nme03 = g_nmz.nmz33
   END IF
  #FUN-CA0083--mark--str
  ##FUN-C70129-add--str
  #IF g_npn.npn03 = '9' THEN
  #   LET g_nme.nme03 = g_nmz.nmz32
  #END IF
  ##FUN-C70129--add--end
  #FUN-CA0083--mark--str
   LET g_nme.nme04 = m_npo.npo04 #darcy:2024/09/04 mod  g_nmh.nmh02-->m_npo.npo04
   LET g_nme.nme05 = g_npn.npn08
   LET g_nme.nme06 = g_npn.npn07
 IF g_aza.aza63 = 'Y' THEN
   LET g_nme.nme061 = g_npn.npn071
 END IF
   LET g_nme.nme07 = g_npn.npn05
   LET g_nme.nme08 = m_npo.npo06
   #FUN-C80083--ADD--STR
   IF g_aza.aza26='2' AND g_npn.npn03 = '4' THEN
      LET g_nme.nme04 = m_npo.npo04-m_npo.npo10 #darcy:2024/09/04 mod  g_nmh.nmh02-->m_npo.npo04
      LET g_nme.nme08 = m_npo.npo06-m_npo.npo09
   END IF
   #FUN-C80083--ADD--END
  #LET g_nme.nme12 = m_npo.npo03   #MOD-B30576 mark
   LET g_nme.nme12 = g_npn.npn01   #MOD-B30576
   LET g_nme.nme13 = g_nmh.nmh30
   #No.MOD-C20010  --Begin
   #LET g_nme.nme14 = g_nmh.nmh12
   IF NOT cl_null(g_nmh.nmh12) THEN
      LET g_nme.nme14 = g_nmh.nmh12
   ELSE
      SELECT nmc05 INTO g_nme.nme14 FROM nmc_file WHERE nmc01 = g_nme.nme03
   END IF
   #No.MOD-C20010  --End
   LET g_nme.nme15 = g_nmh.nmh15
   LET g_nme.nme16 = g_npn.npn02
   LET g_nme.nme17 = g_nmh.nmh31
   LET g_nme.nmeacti = 'Y'
   LET g_nme.nmegrup = g_grup
   LET g_nme.nmeuser = g_user
   LET g_nme.nmedate = g_today
   LET g_nme.nme21 = m_npo.npo02
   LET g_nme.nme22 = '09'
   LET g_nme.nme23 = ''
   LET g_nme.nme24 = '9'  #No.TQC-750098
   LET g_nme.nme25 = g_nmh.nmh11
   LET g_nme.nme26 = 'N'           #FUN-C80083

   LET g_nme.nmelegal = g_legal

   LET g_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET g_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(g_nme.nme27) THEN
      LET g_nme.nme27 = l_dt,'000001'
   END if
   #FUN-B30166--add--end
   INSERT INTO nme_file VALUES(g_nme.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nme02',g_nme.nme02,'t250_ins_nme',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062
END FUNCTION

FUNCTION t250_ins_nmi()
DEFINE l_n        LIKE type_file.num5

   INITIALIZE g_nmi.* TO NULL
   LET g_nmi.nmi01 = g_nmh.nmh01
   LET g_nmi.nmi02 = g_npn.npn02
  #SELECT MAX(nmi03) INTO g_nmi.nmi03 FROM nmi_file  #MOD-C70032 mark
   SELECT MAX(CAST(nmi03 AS INT))                    #MOD-C70032 add
     INTO g_nmi.nmi03                                #MOD-C70032 add
     FROM nmi_file                                   #MOD-C70032 add
    WHERE nmi01=g_nmh.nmh01
   IF cl_null(g_nmi.nmi03) THEN LET g_nmi.nmi03=0 END IF
   LET g_nmi.nmi03 = (g_nmi.nmi03 + 1) using '<<<<<' #darcy:2024/08/22 mod
   LET g_nmi.nmi04 = g_user
   LET g_nmi.nmi05 = g_nmh.nmh24
   LET g_nmi.nmi06 = g_npn.npn03
   LET g_nmi.nmi07 = g_nmh.nmh11
   LET g_nmi.nmi08 = g_nmh.nmh28
   LET g_nmi.nmi09 = g_npn.npn05
   let g_nmi.nmi10 = g_npn.npn01 #darcy:2024/08/22 add

   LET g_nmi.nmilegal = g_legal

   INSERT INTO nmi_file VALUES(g_nmi.*)
   IF SQLCA.sqlcode THEN
      LET g_showmsg=g_nmi.nmi01,"/",g_nmi.nmi03
      CALL s_errmsg('nmi01,nmi03',g_showmsg,'t250_ins_nmi',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION t250_upd_nmh(p_sw)
   DEFINE p_sw    LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmh29 LIKE nmh_file.nmh29

   IF p_sw='+' THEN   #確認
      CASE
         WHEN g_npn.npn03 MATCHES '[234]' AND g_aza.aza26<>'2'                #NO.FUN-B40003 Delete  2 #TQC-B70197 add 2  #FUN-C80083 add--aza26<>2
              UPDATE nmh_file SET nmh24=g_npn.npn03,nmh25=g_npn.npn02,
                     nmh19=g_npn.npn03,nmh20=g_npn.npn02, nmh21=g_npn.npn13,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03

         #FUN-C80083---ADD---STR
         WHEN g_npn.npn03 MATCHES '[4]' AND g_aza.aza26 ='2'
              UPDATE nmh_file SET nmh24=g_npn.npn03,nmh19=g_npn.npn03
               WHERE nmh01=m_npo.npo03
         #FUN-C80083---ADD---END

         #No.MOD-D80121 --Begin
         WHEN g_npn.npn03 MATCHES '[3]' AND g_aza.aza26='2'
              UPDATE nmh_file SET nmh24=g_npn.npn03,nmh25=g_npn.npn02,
                     nmh19=g_npn.npn03,nmh20=g_npn.npn02, nmh21=g_npn.npn13,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03
         #No.MOD-D80121 --End

         WHEN g_npn.npn03='5'
              LET g_buf = NULL  #NO.FUN-B40003
              SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_npn.npn14
              UPDATE nmh_file SET nmh24=g_npn.npn03,nmh25=g_npn.npn02,
                     nmh35=g_npn.npn02, nmh22=g_npn.npn14,nmh23=g_buf
               WHERE nmh01=m_npo.npo03
         WHEN g_npn.npn03 MATCHES '[678]'
              UPDATE nmh_file SET nmh24=g_npn.npn03,nmh25=g_npn.npn02,
                     nmh35=g_npn.npn02
               WHERE nmh01=m_npo.npo03
         #FUN-C70129 add--str
         WHEN g_npn.npn03 = '9'
            UPDATE nmh_file SET nmh24 = g_npn.npn03,nmh25=g_npn.npn02,
                   nmh35=g_npn.npn02
               WHERE nmh01=m_npo.npo03
         #FUN-C70129 add--end
      END CASE
   ELSE      #取消確認
      CASE
         WHEN g_npn.npn03 MATCHES '[234]' AND g_aza.aza26<>'2'          #NO.FUN-B40003  delete 2  #TQC-B70197 add 2  #FUN-C80083 add--aza26<>2
              UPDATE nmh_file SET nmh24=m_npo.npo07,nmh25=m_npo.npo08,
                     nmh19=NULL,nmh20=NULL, nmh21=NULL,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03
        #FUN-C80083--ADD--STR
         WHEN g_npn.npn03 MATCHES '[4]' AND g_aza.aza26='2'
               UPDATE nmh_file SET nmh24=m_npo.npo07,nmh19='2' # darcy:2025/06/27 mod '2'=> m_npo.npo07
               WHERE nmh01=m_npo.npo03
         #FUN-C80083--ADD--EnD

         #No.MOD-D80121  --Begin
         WHEN g_npn.npn03 MATCHES '[3]' AND g_aza.aza26='2'
              UPDATE nmh_file SET nmh24=m_npo.npo07,nmh25=m_npo.npo08,
                     nmh19=NULL,nmh20=NULL, nmh21=NULL,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03
         #No.MOD-D80121  --End

         WHEN g_npn.npn03='5'
              UPDATE nmh_file SET nmh24=m_npo.npo07,nmh25=m_npo.npo08,
                     nmh35=NULL, nmh22=NULL,nmh23=NULL
               WHERE nmh01=m_npo.npo03
         WHEN g_npn.npn03 MATCHES '[678]'
              UPDATE nmh_file SET nmh24=m_npo.npo07,nmh25=m_npo.npo08,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03
         #FUN-C70129--add--str
         WHEN g_npn.npn03 = '9'
              UPDATE nmh_file SET nmh24 = m_npo.npo07,nmh25 = m_npo.npo08,
                     nmh35=NULL
               WHERE nmh01=m_npo.npo03
         #FUN-C70129--add--end
      END CASE
   END IF
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nmh01',m_npo.npo03,'upd nmh',SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF
END FUNCTION

FUNCTION t250_t()
   DEFINE l_npo     RECORD LIKE npo_file.*,
          l_ool     RECORD LIKE ool_file.*,
          l_ooy     RECORD LIKE ooy_file.*,
          l_nmh     RECORD LIKE nmh_file.*,
          l_custom,l_custom_old like nmh_file.nmh11,
          l_buf1    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
          g_wc      string,                 #No.FUN-580092 HCN
          g_sql     string,                 #No.FUN-580092 HCN
          l_oma     RECORD LIKE oma_file.*,
          l_omb     RECORD LIKE omb_file.*,
          l_nmh11   LIKE nmh_file.nmh11,
          l_name1   LIKE apk_file.apk28,    #No.FUN-680107 VARCHAR(12)
          l_cmd     LIKE type_file.chr50,   #No.FUN-680107 VARCHAR(30)
          l_omb03   LIKE omb_file.omb03,
          l_i,g_count,nn LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_a01     LIKE cre_file.cre08,    #No.FUN-680107 VARCHAR(10)
          l_a03     LIKE cre_file.cre08     #No.FUN-680107 VARCHAR(10)

   DEFINE ar_slip   LIKE ooy_file.ooyslip   #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE ar_type   LIKE oma_file.oma13
   DEFINE li_result LIKE type_file.num5     #No.FUN-560002  #No.FUN-680107 SMALLINT

   IF s_anmshut(0) THEN RETURN END IF


   OPEN WINDOW t250_t AT 6,20 WITH FORM "anm/42f/anmt2502"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_locale("anmt2502")


   CLEAR FORM                                    #清除畫面
   DISPLAY g_npn.npn01 TO npn01                  #MOD-AC0019
   DISPLAY g_npn.npn02 TO npn02                  #MOD-AC0019
  #-MOD-AC0019-mark-
  #CONSTRUCT BY NAME g_wc ON npn01,npn02         # 螢幕上取單頭條件
  #           BEFORE CONSTRUCT
  #              DISPLAY g_npn.npn01 TO npn01   #CHI-810019
  #              DISPLAY g_npn.npn02 TO npn02   #CHI-810019
  #              CALL cl_qbe_init()
  #   ON ACTION CONTROLP
  #      CASE
  #         WHEN INFIELD(npn01)
  #            CALL cl_init_qry_var()
  #            LET g_qryparam.form = "q_npn"
  #            LET g_qryparam.state = "c"
  #            CALL cl_create_qry() RETURNING g_qryparam.multiret
  #            DISPLAY g_qryparam.multiret TO npn01
  #            NEXT FIELD npn01
  #      END CASE
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE CONSTRUCT

  #   ON ACTION about         #MOD-4C0121
  #      CALL cl_about()      #MOD-4C0121

  #   ON ACTION help          #MOD-4C0121
  #      CALL cl_show_help()  #MOD-4C0121

  #   ON ACTION controlg      #MOD-4C0121
  #      CALL cl_cmdask()     #MOD-4C0121


  #              ON ACTION qbe_select
  #      	   CALL cl_qbe_select()
  #              ON ACTION qbe_save
  #     	   CALL cl_qbe_save()
  #END CONSTRUCT
  #-MOD-AC0019-end-

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t250_t
      RETURN
   END IF
   LET g_wc = " npn01 = '",g_npn.npn01,"' AND npn02 = '",g_npn.npn02,"'"  #MOD-AC0019
   #資料權限的檢查


   LET g_wc  = g_wc CLIPPED," AND npnconf='Y' "   # 已確認

   INPUT BY NAME ar_slip,ar_type WITHOUT DEFAULTS
      AFTER FIELD ar_slip
         IF cl_null(ar_slip) THEN NEXT FIELD ar_slip END IF
         SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip = ar_slip
         CALL s_check_no("axr",ar_slip,"","14","","","")   #MOD-5A0243
           RETURNING li_result,ar_slip
         IF (NOT li_result) THEN
           NEXT FIELD ar_slip
         END IF

      AFTER FIELD ar_type
         IF cl_null(ar_type) THEN NEXT FIELD ar_type END IF
         SELECT * INTO l_ool.* FROM ool_file WHERE ool01=ar_type
         IF STATUS THEN
            CALL cl_err3("sel","ool_file",ar_type,"",STATUS,"","select ool",1)  #No.FUN-660148
            NEXT FIELD ar_type
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ar_slip)
               CALL q_ooy(FALSE,TRUE,ar_slip,'14','AXR') RETURNING ar_slip
               DISPLAY BY NAME ar_slip
               NEXT FIELD ar_slip
              WHEN INFIELD(ar_type)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ool"
                LET g_qryparam.default1 = ar_type
                CALL cl_create_qry() RETURNING ar_type
                DISPLAY BY NAME ar_type
                NEXT FIELD ar_type
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
      CLOSE WINDOW t250_t
      RETURN
   END IF
   LET g_count = 0
   LET l_buf1 = g_wc CLIPPED
   LET l_buf1 = l_buf1 CLIPPED
   LET g_sql=" SELECT COUNT(*) FROM oma_file,npn_file ",
             " WHERE npn01=oma16 AND omavoid<>'Y' AND ",l_buf1 CLIPPED    #No:8034
   PREPARE t400_oma_pre FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t400_oma_pre',STATUS,1)
   END IF
   DECLARE t400_oma_cur CURSOR FOR t400_oma_pre
   IF SQLCA.sqlcode THEN
      CALL cl_err('t400_oma_cur',STATUS,1)
   END IF
   OPEN t400_oma_cur
   LET g_count=0
   FETCH t400_oma_cur INTO g_count
   IF g_count > 0 THEN
      LET g_success='N'
   ELSE
     # MESSAGE '資料正在處理中,請稍候.........'
      CALL cl_wait()                              #No:8034 把中文換掉
      LET g_sql = "SELECT * FROM npn_file,npo_file LEFT OUTER JOIN nmh_file ON npo03=nmh_file.nmh01 ",
                  " WHERE npn01=npo01  ",
                  "   AND (npn03='6' OR npn03='7') AND ", g_wc CLIPPED

      LET g_success = 'Y'
      BEGIN WORK
      OPEN t250_cl USING g_npn.npn01
      IF STATUS THEN
         CALL cl_err("OPEN t250_cl:", STATUS, 1)
         CLOSE t250_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t250_cl INTO g_npn.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
         CLOSE t250_cl
         ROLLBACK WORK
         RETURN
      END IF
      PREPARE t250_t_prepare FROM g_sql
      DECLARE t250_t CURSOR FOR t250_t_prepare
      DROP TABLE tmp1_file
      DROP TABLE tmp2_file
      DROP TABLE tmp3_file
      CALL t250_create_oma()
      CALL t250_create_omb()
      CALL t250_create_oma01()
      LET g_cnt=0   #No.+329 010702 by plum
      CALL s_showmsg_init()    #No.FUN-710024
      FOREACH t250_t INTO g_npn.*,l_npo.*,l_nmh.*
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF

         IF STATUS THEN
            CALL s_errmsg('','','foreach',STATUS,1)   #No.FUN-710024
            LET g_success='N'
            EXIT FOREACH
         END IF
         INITIALIZE g_oma.* TO NULL
         LET g_oma.oma00 = '14'
#TQC-AB0247--add--str--
         #帳款編號字段產生
         CALL s_auto_assign_no("axr",ar_slip,g_npn.npn02,"14","","","","","")
             RETURNING li_result,g_oma.oma01
         IF (NOT li_result) THEN
            LET g_success='N'
         END IF
#TQC-AB0247--add--end--
         LET g_oma.oma02 = g_npn.npn02
         LET g_oma.oma03 = l_nmh.nmh11
         LET g_oma.oma032 = l_nmh.nmh30
         LET g_oma.oma04 = l_nmh.nmh11
         SELECT occ11,occ18,occ231 INTO g_oma.oma042,g_oma.oma043,g_oma.oma044
           FROM occ_file WHERE occ01=g_oma.oma04
         LET g_oma.oma07 = 'N'
         LET g_oma.oma08 = '1'
         LET g_oma.oma09 = g_today
         LET g_oma.oma13 = ar_type
         LET g_oma.oma14 = l_nmh.nmh16
         LET g_oma.oma15 = l_nmh.nmh15
         LET g_oma.oma16 = g_npn.npn01
         LET g_oma.oma171 = '31'
         LET g_oma.oma172 = '1'
         LET g_oma.oma173 = YEAR(g_today)
         LET g_oma.oma174 = MONTH(g_today)
         SELECT oca03 INTO g_oma.oma18 FROM occ_file,oca_file
          WHERE occ01=g_oma.oma03 AND occ03=oca01
         IF cl_null(g_oma.oma18) THEN
           LET g_oma.oma18 = l_ool.ool13
          IF g_aza.aza63 = 'Y' THEN
           LET g_oma.oma18 = l_ool.ool131
          END IF
         END IF
         LET g_oma.oma20 = 'Y'
         SELECT occ41,occ45 INTO g_oma.oma21,g_oma.oma32 FROM occ_file WHERE occ01=g_oma.oma03 #MOD-940192 add oma32
         SELECT gec04,gec05,gec07
           INTO g_oma.oma211,g_oma.oma212,g_oma.oma213
           FROM gec_file WHERE gec01=g_oma.oma21
                           AND gec011='2'  #銷項
         LET g_oma.oma23 = g_npn.npn04
         LET g_oma.oma24 = g_npn.npn05
         LET g_oma.oma50 = 0
         LET g_oma.oma50t = 0
         LET g_oma.oma52 = 0
         LET g_oma.oma53 = 0
         LET g_oma.oma54 = l_npo.npo04
         LET g_oma.oma54x = 0
         LET g_oma.oma54t= l_npo.npo04
         LET g_oma.oma55 = 0
         LET g_oma.oma56 = l_npo.npo06
         LET g_oma.oma56x= 0
         LET g_oma.oma56t= l_npo.npo06
         LET g_oma.oma57 = 0
         LET g_oma.oma58 = g_npn.npn05
         LET g_oma.oma59 = l_npo.npo06
         LET g_oma.oma59x = 0
         LET g_oma.oma59t = l_npo.npo06
         LET g_oma.oma60 = g_oma.oma24
         LET g_oma.oma61 = g_oma.oma56t - g_oma.oma57
         LET g_oma.oma68 = l_nmh.nmh11
         LET g_oma.oma69 = l_nmh.nmh30
         LET g_oma.oma51 = 0
         LET g_oma.oma51f = 0
        #LET g_oma.oma33=g_npn.npn09   #CHI-810019 #CHI-B80020 mark
         LET g_oma.oma33=' '           #CHI-B80020 add
         LET g_oma.omaconf = 'Y'
         LET g_oma.omavoid='N'
         LET g_oma.omaprsw=0
         LET g_oma.omauser=g_user
         LET g_oma.omagrup=g_grup
         LET g_oma.omadate=g_today
         LET g_oma.oma930 =s_costcenter(g_oma.oma15) #FUN-680006
         CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant2)  #FUN-980020
           RETURNING g_oma.oma11,g_oma.oma12
         LET g_oma.omalegal = g_legal   #FUN-A90063
#No.FUN-AB0034 --begin
         IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
         IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
         IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
         INSERT INTO tmp1_file VALUES(g_oma.*)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp1_file',STATUS,1)   #No.FUN-710024
            LET g_success='N'
            CONTINUE FOREACH   #No.FUN-710024
         END IF

         INITIALIZE g_omb.* TO NULL
         LET g_omb.omb00 = '14'
         LET g_omb.omb01 = g_oma.oma01
         LET g_omb.omb04 = 'MISC'
         #LET g_omb.omb06 = '退票立帳'                           #MOD-B30631 mark
         CALL cl_getmsg('anm-136',g_lang) RETURNING g_omb.omb06 #MOD-B30631
         LET g_omb.omb12 = 1
         LET g_omb.omb13 = l_npo.npo04
         LET g_omb.omb14 = l_npo.npo04
         LET g_omb.omb14t = l_npo.npo04
         LET g_omb.omb15 = l_npo.npo06
         LET g_omb.omb16 = l_npo.npo06
         LET g_omb.omb16t= l_npo.npo06
         LET g_omb.omb17  =l_npo.npo06
         LET g_omb.omb18  =l_npo.npo06
         LET g_omb.omb18t =l_npo.npo06
         LET g_omb.omb34  = 0
         LET g_omb.omb35  = 0
         LET g_omb.omb930 = g_oma.oma930 #FUN-680006
         LET g_omb.omblegal = g_legal  #TQC-AB0247
         LET g_omb.omb03 = l_npo.npo02 #TQC-AB0247
         LET g_omb.omb48 = 0         #MOD-D70045
         #LET g_oma.omalegal = g_legal   #FUN-A90063 #TQC-AB0247 mrak
         INSERT INTO tmp2_file VALUES(g_omb.*,l_nmh.nmh11)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp2_file',STATUS,1)   #No.FUN-710024
            LET g_success='N'
            CONTINUE FOREACH   #No.FUN-710024
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF

      DECLARE tmp1_cur CURSOR FOR
          SELECT * FROM tmp1_file
            ORDER BY oma03  #No.MOD-470463
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","tmp1_file","","",STATUS,"","tmp1_cur",1)  #No.FUN-660148
      END IF
      CALL cl_outnam('anmt250') RETURNING l_name1   #MOD-740128
      START REPORT t250_rep1 TO l_name1
      FOREACH tmp1_cur INTO l_oma.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach oma',STATUS,1)
            EXIT FOREACH
         END IF
         OUTPUT TO REPORT t250_rep1(l_oma.*,ar_slip)
      END FOREACH
      FINISH REPORT t250_rep1
      IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009
      DECLARE tmp2_cur CURSOR FOR
        SELECT * FROM tmp2_file ORDER BY cus
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("sel","tmp2_file","","",STATUS,"","tmp2_cur",1)  #No.FUN-660148
      END IF
      LET l_custom = ' '
      LET l_custom_old=' '
      INITIALIZE l_omb.* TO NULL
      LET l_omb03 = 0
      LET g_cnt = 0
      FOREACH tmp2_cur INTO l_omb.*,l_nmh11
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF

         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('','','foreach omb',STATUS,0)  #No.FUN-710024
            EXIT FOREACH
         END IF
         LET l_custom = l_nmh11
         LET g_cnt = g_cnt + 1
         IF l_custom != l_custom_old AND g_cnt != 1 THEN
            LET l_omb03 = 0
         END IF
         LET l_omb03 = l_omb03 + 1

          LET l_nmh11 = l_nmh11 CLIPPED  #No.MOD-470463
         SELECT a01 INTO l_omb.omb01 FROM tmp3_file WHERE a03 =l_nmh11
         LET l_omb.omb03 = l_omb03

         LET l_omb.omblegal = g_legal
         LET l_omb.omb48 = 0   #FUN-D10101 add
         INSERT INTO omb_file VALUES(l_omb.*)
         IF SQLCA.SQLCODE THEN
            LET g_showmsg = l_omb.omb01,"/",l_omb.omb03                 #No.FUN-710024
            CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb',STATUS,1)   #No.FUN-710024
            LET g_success = 'N'   #No.MOD-470463
         END IF
         LET l_custom_old = l_nmh11
      END FOREACH
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF

    END IF

   CLOSE WINDOW t250_t                 #結束畫面
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN
      IF g_cnt=0 THEN
         CALL cl_err('','axr-289',1)
      ELSE
         COMMIT WORK CALL cl_cmmsg(1)
      END IF
   ELSE
      IF g_count > 0 THEN
         CALL cl_err('','anm-997',0)
#        MESSAGE '應收帳款已存在,無法重復產生 !!'
      ELSE
         IF g_cnt=0 THEN
            CALL cl_err('','axr-289',1)
         ELSE
            CALL cl_rbmsg(1) ROLLBACK WORK
         END IF
      END IF
   END IF
END FUNCTION

REPORT t250_rep1(p_oma,p_slip)
 DEFINE p_oma    RECORD LIKE oma_file.*
 DEFINE l_omc    RECORD LIKE omc_file.*  #CHI-810016
 DEFINE p_slip   LIKE type_file.chr5     #No.FUN-680107 VARCHAR(5) #No.FUN-550057
 DEFINE l_oma50  LIKE oma_file.oma50,
        l_oma50t LIKE oma_file.oma50t,
        l_oma52  LIKE oma_file.oma52,
        l_oma53  LIKE oma_file.oma53,
        l_oma54  LIKE oma_file.oma54,
        l_oma54x LIKE oma_file.oma54x,
        l_oma54t LIKE oma_file.oma54t,
        l_oma55  LIKE oma_file.oma55,
        l_oma56  LIKE oma_file.oma56,
        l_oma56x LIKE oma_file.oma56x,
        l_oma56t LIKE oma_file.oma56t,
        l_oma57  LIKE oma_file.oma57,
        l_oma61  LIKE oma_file.oma61,   #MOD-AC0121 mod oma58 -> oma61
        l_oma59  LIKE oma_file.oma59,
        l_oma59x LIKE oma_file.oma59x,
        l_oma59t LIKE oma_file.oma59t
DEFINE  l_a01    LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(10)
        l_a03    LIKE type_file.chr20    #No.FUN-680107 VARCHAR(10)
DEFINE li_result LIKE type_file.num5     #No.FUN-560002  #No.FUN-680107 SMALLINT

    ORDER EXTERNAL BY p_oma.oma03        #客戶編號  No.MOD-470463
   FORMAT
      AFTER GROUP OF p_oma.oma03
         LET l_oma50 = GROUP SUM(p_oma.oma50)
         LET l_oma50t= GROUP SUM(p_oma.oma50t)
         LET l_oma52 = GROUP SUM(p_oma.oma52)
         LET l_oma53 = GROUP SUM(p_oma.oma53)
         LET l_oma54 = GROUP SUM(p_oma.oma54)
         LET l_oma54x = GROUP SUM(p_oma.oma54x)
         LET l_oma54t = GROUP SUM(p_oma.oma54t)
         LET l_oma55 = GROUP SUM(p_oma.oma55)
         LET l_oma56 = GROUP SUM(p_oma.oma56)
         LET l_oma56x = GROUP SUM(p_oma.oma56x)
         LET l_oma56t = GROUP SUM(p_oma.oma56t)
         LET l_oma57 = GROUP SUM(p_oma.oma57)
        #LET l_oma58 = GROUP SUM(p_oma.oma58)     #MOD-AC0104 mark
         LET l_oma59 = GROUP SUM(p_oma.oma59)
         LET l_oma59x = GROUP SUM(p_oma.oma59x)
         LET l_oma59t = GROUP SUM(p_oma.oma59t)
         LET l_oma61 = GROUP SUM(p_oma.oma61)     #MOD-AC0121
         LET p_oma.oma50 = l_oma50
         LET p_oma.oma50t= l_oma50t
         LET p_oma.oma52 = l_oma52
         LET p_oma.oma53 = l_oma53
         LET p_oma.oma54 = l_oma54
         LET p_oma.oma54x = l_oma54x
         LET p_oma.oma54t = l_oma54t
         LET p_oma.oma55 = l_oma55
         LET p_oma.oma56 = l_oma56
         LET p_oma.oma56x = l_oma56x
         LET p_oma.oma56t = l_oma56t
         LET p_oma.oma57 = l_oma57
        #LET p_oma.oma58 = l_oma58               #MOD-AC0104 mark
         LET p_oma.oma59 = l_oma59
         LET p_oma.oma59x = l_oma59x
         LET p_oma.oma59t = l_oma59t
         LET p_oma.oma61 = l_oma61               #MOD-AC0121
         LET p_oma.oma65 = '1'   #FUN-5A0124
         LET p_oma.oma66 = g_plant  #FUN-A60056

        #FUN-A60056--mod--str--
        #SELECT oga27 INTO p_oma.oma67 FROM oga_file
        #  WHERE oga01 = p_oma.oma16
         LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(p_oma.oma66,'oga_file'),
                     " WHERE oga01 = '",p_oma.oma16,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,p_oma.oma66) RETURNING g_sql
         PREPARE sel_oga27 FROM g_sql
         EXECUTE sel_oga27 INTO p_oma.oma67
        #FUN-A60056--mod--end
        CALL s_auto_assign_no("axr",p_slip,p_oma.oma02,"14","","","","","")   #MOD-5A0243
             RETURNING li_result,p_oma.oma01
        IF (NOT li_result) THEN
           LET g_success='N'
        END IF

         LET p_oma.omalegal = g_legal

         LET p_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
         LET p_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
         IF cl_null(p_oma.oma73) THEN LET p_oma.oma73 =0 END IF
         IF cl_null(p_oma.oma73f) THEN LET p_oma.oma73f =0 END IF
         IF cl_null(p_oma.oma74) THEN LET p_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
         INSERT INTO oma_file VALUES(p_oma.*)
         IF SQLCA.SQLCODE THEN
             CALL cl_err3("ins","oma_file",p_oma.oma01,"",STATUS,"","ins oma:",1)  #No.FUN-660148
            LET g_success='N'
          ELSE
            INITIALIZE l_omc.* TO NULL
            LET l_omc.omc01=p_oma.oma01
            LET l_omc.omc02=1
            LET l_omc.omc03=p_oma.oma32
            LET l_omc.omc04=p_oma.oma11
            LET l_omc.omc05=p_oma.oma12
            LET l_omc.omc06=p_oma.oma24
            LET l_omc.omc07=p_oma.oma60
            LET l_omc.omc08=p_oma.oma54t
            LET l_omc.omc09=p_oma.oma56t
            LET l_omc.omc10=p_oma.oma55
            LET l_omc.omc11=p_oma.oma57
            LET l_omc.omc12=p_oma.oma10
            LET l_omc.omc13=l_omc.omc09-l_omc.omc11
            LET l_omc.omc14=p_oma.oma51f
            LET l_omc.omc15=p_oma.oma51

            LET l_omc.omclegal = g_legal

            INSERT INTO omc_file VALUES(l_omc.*)
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("ins","omc_file",p_oma.oma01,"",STATUS,"","ins omc",1)
               LET g_success='N'
               RETURN
            END IF
         END IF

         INSERT INTO tmp3_file (a01,a03) VALUES(p_oma.oma01,p_oma.oma03)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]= 0 THEN
             CALL cl_err3("ins","tmp3_file","","",STATUS,"","ins tmp3:",1)  #No.FUN-660148
            LET g_success='N'
         END IF
END REPORT

FUNCTION t250_create_oma()
   SELECT *
     FROM oma_file
    WHERE oma01='@@@@'
     INTO TEMP tmp1_file
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err3("ins","tmp1_file","","",SQLCA.sqlcode,"","create tmp1_file:",1)  #No.FUN-660148
   END IF
   DELETE FROM tmp1_file WHERE 1=1
END FUNCTION

FUNCTION t250_create_omb()
   SELECT omb_file.*,'aaaaaaaaaa' cus
     FROM omb_file
    WHERE omb01='@@@@'
     INTO TEMP tmp2_file
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err3("ins","tmp2_file","","",SQLCA.sqlcode,"","create tmp2_file:",1)  #No.FUN-660148
   END IF

   DELETE FROM tmp2_file WHERE 1=1
END FUNCTION

FUNCTION t250_create_oma01()
    CREATE TEMP TABLE tmp3_file(
        a01  LIKE pmn_file.pmn01,
        a03  LIKE npp_file.npp06);
END FUNCTION

FUNCTION t250_t2()
   DEFINE l_oma01 LIKE oma_file.oma01
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_oma55 LIKE oma_file.oma55
   DEFINE l_oma57 LIKE oma_file.oma57

   SELECT COUNT(*) INTO l_cnt FROM oma_file
     WHERE oma16 = g_npn.npn01
   IF l_cnt = 0 THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success='Y'


   DECLARE oma_c CURSOR FOR
     SELECT oma01 FROM oma_file WHERE oma16=g_npn.npn01

   FOREACH oma_c INTO l_oma01
      SELECT oma55,oma57 INTO l_oma55,l_oma57 FROM oma_file
        WHERE oma01 = l_oma01
      IF (l_oma55 IS NOT NULL AND l_oma55 >0) OR
         (l_oma57 IS NOT NULL AND l_oma57 >0) THEN
         CALL cl_err('','axr-160',0)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DELETE FROM oma_file WHERE oma01 = l_oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("del","oma_file",l_oma01,"",SQLCA.sqlcode,"","del oma_file",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DELETE FROM omc_file WHERE omc01 = l_oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("del","omc_file",l_oma01,"",SQLCA.sqlcode,"","del omc_file",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DELETE FROM omb_file WHERE omb01 = l_oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("del","omb_file",l_oma01,"",SQLCA.sqlcode,"","del omb_file",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success='Y' THEN
      CALL cl_err('','lib-022',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t250_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("npn01,npn03",TRUE)
    END IF
    CALL cl_set_comp_entry("npn04,npn05",TRUE)     #MOD-BB0017 add
    IF INFIELD(npn03) THEN
      CALL cl_set_comp_entry("npn06,npn07,npn13,npn14",TRUE)
     IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_entry("npn061,npn071",TRUE)
     END IF
    END IF

END FUNCTION

FUNCTION t250_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
  DEFINE l_cnt   LIKE type_file.num5    #MOD-BB0017 add

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("npn01,npn03",FALSE)
      #------------------------MOD-BB0017------------------start
      #當有單身資料時,單頭幣別,匯率不可異動
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM npo_file
        WHERE npo01=g_npn.npn01
       IF l_cnt > 0 THEN
          CALL cl_set_comp_entry("npn04,npn05",FALSE)
       END IF
      #------------------------MOD-BB0017--------------------end
    END IF

    IF INFIELD(npn03) THEN
       IF g_npn.npn03 NOT MATCHES '[234]' THEN                #NO.FUN-B40003  delete   2  #TQC-B70197 add 2
          CALL cl_set_comp_entry("npn13",FALSE)
       END IF
       IF g_npn.npn03 NOT MATCHES '[3459]' THEN #FUN-C70129 add 9
          CALL cl_set_comp_entry("npn14",FALSE)
       END IF
       IF g_nmy.nmydmy3 = 'N' OR g_npn.npn03 MATCHES '[348]' THEN #NO.FUN-5A0088
          CALL cl_set_comp_entry("npn06",FALSE)
        IF g_aza.aza63 = 'Y' THEN
          CALL cl_set_comp_entry("npn061",FALSE)
        END IF
       END IF
       IF g_nmy.nmydmy3 = 'N' OR g_npn.npn03 MATCHES '[34]' THEN  #NO.FUN-5A0088
          CALL cl_set_comp_entry("npn07",FALSE)
        IF g_aza.aza63 = 'Y' THEN
          CALL cl_set_comp_entry("npn071",FALSE)
        END IF
       END IF
    END IF

END FUNCTION

FUNCTION t250_carry_voucher()
   DEFINE l_nmygslp    LIKE nmy_file.nmygslp
   DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1  #No.FUN-680034
   DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT

    IF NOT cl_null(g_npn.npn09) OR g_npn.npn09 IS NOT NULL THEN
       CALL cl_err(g_npn.npn09,'aap-618',1)
       RETURN
    END IF
     IF NOT cl_confirm('aap-989') THEN RETURN END IF

     CALL s_get_doc_no(g_npn.npn01) RETURNING g_t1
     SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
     IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
     #若單別須拋轉總帳,檢查分錄底稿平衡正確否
     CALL s_get_bookno(YEAR(g_npn.npn02)) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag = '1' THEN
        CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
        LET g_success = 'N'
     END IF
      CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'0',g_bookno1)         #No.FUN-730032
     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'1',g_bookno2)       #No.FUN-730032
     END IF
     IF g_success='N' THEN RETURN END IF
     IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
        #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
        #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
        LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                    "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                    "    AND aba01 = '",g_npn.npn09,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
        PREPARE aba_pre5 FROM l_sql
        DECLARE aba_cs5 CURSOR FOR aba_pre5
        OPEN aba_cs5
        FETCH aba_cs5 INTO l_n
        IF l_n > 0 THEN
           CALL cl_err(g_npn.npn09,'aap-991',1)
           RETURN
        END IF
        LET l_nmygslp = g_nmy.nmygslp
        LET l_nmygslp1= g_nmy.nmygslp1     #No.FUN-680034
     ELSE
        CALL cl_err('','aap-936',1) #FUN-940036
        RETURN

        #開窗作業
        LET g_plant_new= g_nmz.nmz02p
        CALL s_getdbs()
        LET g_dbs_gl=g_dbs_new      # 得資料庫名稱

        OPEN WINDOW t250p AT 5,10 WITH FORM "axr/42f/axrt200_p"
             ATTRIBUTE (STYLE = g_win_style CLIPPED)
        CALL cl_ui_locale("axrt200_p")

        INPUT l_nmygslp WITHOUT DEFAULTS FROM FORMONLY.gl_no

           AFTER FIELD gl_no
              CALL s_check_no("agl",l_nmygslp,"","1","aac_file","aac01",g_plant_gl)   #TQC-9B0162
                 RETURNING li_result,l_nmygslp
              IF (NOT li_result) THEN
                 NEXT FIELD gl_no
              END IF

           AFTER INPUT
              IF INT_FLAG THEN
                 EXIT INPUT
              END IF
              IF cl_null(l_nmygslp) THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD gl_no
              END IF

           ON ACTION CONTROLR
              CALL cl_show_req_fields()

           ON ACTION CONTROLG
              CALL cl_cmdask()

           ON ACTION CONTROLP
              IF INFIELD(gl_no) THEN
                 CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_nmygslp,'1',' ',' ','AGL')  #No.FUN-980059
                    RETURNING l_nmygslp
                 DISPLAY l_nmygslp TO FORMONLY.gl_no
                 NEXT FIELD gl_no
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
        CLOSE WINDOW t250p
     END IF
     IF cl_null(l_nmygslp) THEN
        CALL cl_err(g_npn.npn01,'axr-070',1)
        RETURN
     END IF
     IF cl_null(l_nmygslp1) AND g_aza.aza63 = 'Y' THEN
        CALL cl_err(g_npn.npn01,'axr-070',1)
        RETURN
     END IF
     LET g_wc_gl = 'npp01 = "',g_npn.npn01,'" AND npp011 = ',g_npn.npn03
     LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
               " '",g_nmz.nmz02b,"' '",l_nmygslp,"' ",                                #No.FUN-680034
               " '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_npn.npn02,"' 'Y' '1' 'Y'"   #No.FUN-680034#FUN-860040
     CALL cl_cmdrun_wait(g_str)
     SELECT npn09 INTO g_npn.npn09 FROM npn_file
      WHERE npn01 = g_npn.npn01
     DISPLAY BY NAME g_npn.npn09

END FUNCTION

FUNCTION t250_undo_carry_voucher()
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      STRING

    IF cl_null(g_npn.npn09) OR g_npn.npn09 IS NULL THEN
       CALL cl_err(g_npn.npn09,'aap-619',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

    CALL s_get_doc_no(g_npn.npn01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF

    CALL s_get_doc_no(g_npn.npn01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
     CALL s_get_bookno(YEAR(g_npn.npn02)) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag = '1' THEN
        CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)
        LET g_success = 'N'
     END IF
    CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'0',g_bookno1)       #No.FUN-730032
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
    CALL s_chknpq(g_npn.npn01,'NM',g_npn.npn03,'1',g_bookno2)       #No.FUN-730032
   END IF
    IF g_success='N' THEN RETURN END IF

    LET g_plant_new = g_nmz.nmz02p
    #CALL s_getdbs()   #FUN-A50102
    LET l_sql = "SELECT aba19 ",
                #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
                "  FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                " WHERE aba00 = '",g_nmz.nmz02b,"' ",
                "   AND aba01 = '",g_npn.npn09,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    IF SQLCA.sqlcode THEN RETURN END IF
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_npn.npn09,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npn.npn09,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT npn09 INTO g_npn.npn09 FROM npn_file
     WHERE npn01 = g_npn.npn01
    DISPLAY BY NAME g_npn.npn09
END FUNCTION

FUNCTION t250_gen_glcr(p_npn,p_nmy)
   DEFINE p_npn    RECORD LIKE npn_file.*
   DEFINE p_nmy    RECORD LIKE nmy_file.*

   IF cl_null(p_nmy.nmygslp) THEN
      CALL cl_err(p_npn.npn01,'axr-070',1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_t250_gl(g_npn.npn01,'0')       # No.FUN-680034  add '0'
  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL s_t250_gl(g_npn.npn01,'1')
  END IF

   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
#No.FUN-9C0
#FUN-C70129--add--str
FUNCTION t250_s()
   DEFINE l_npn     RECORD LIKE npn_file.*,
          l_nmh     RECORD LIKE nmh_file.*,
          l_npo     RECORD LIKE npo_file.*,
          l_custom         LIKE nmh_file.nmh11,
          l_custom_old     LIKE nmh_file.nmh11,
          l_buf1    LIKE type_file.chr1000,
          l_apa     RECORD LIKE apa_file.*,
          l_apb     RECORD LIKE apb_file.*,
          l_aps     RECORD LIKE aps_file.*,
          l_nmh22   LIKE nmh_file.nmh22,
          l_name1   LIKE apk_file.apk28,
          l_cmd     LIKE type_file.chr1000,
          l_depno   LIKE apa_file.apa22,
          l_apa05   LIKE apa_file.apa05,
          l_apb02   LIKE apb_file.apb02,
        l_i,g_count LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          li_result LIKE type_file.num5,
          l_apz13   LIKE apz_file.apz13
   DEFINE ap_slip   LIKE nmy_file.nmyslip
   DEFINE ap_type   LIKE apa_file.apa36

   IF s_anmshut(0) THEN RETURN END IF

   IF g_npn.npn03 != '9' THEN
      RETURN
   END IF
   OPEN WINDOW t250_s AT 8,20 WITH FORM "anm/42f/anmt2505"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_locale("anmt2505")


   CLEAR FORM                                    #清除畫面
   CONSTRUCT BY NAME g_wc ON npn01,npn02
              BEFORE CONSTRUCT
                 DISPLAY g_npn.npn01 TO npn01
                 DISPLAY g_npn.npn02 TO npn02
                 CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
	 CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t250_s
      RETURN
   END IF

   INPUT BY NAME ap_slip,ap_type WITHOUT DEFAULTS

      AFTER FIELD ap_slip
         IF NOT cl_null(ap_slip) THEN
               CALL s_check_no('AAP',ap_slip,'','12','','','')
                 RETURNING li_result,ap_slip
               IF (NOT li_result) THEN
                  NEXT FIELD ap_slip
               END IF
         END IF

      AFTER FIELD ap_type
         IF NOT cl_null(ap_type) THEN
            SELECT COUNT(*) INTO l_n FROM apr_file WHERE apr01=ap_type
            IF STATUS THEN
               CALL cl_err('select apr',STATUS,0) NEXT FIELD ap_type
            END IF
         END IF

      ON ACTION CONTROLP
         CASE WHEN INFIELD(ap_slip)
                CALL q_apy(FALSE,FALSE,ap_slip,'12','AAP') RETURNING ap_slip
                DISPLAY BY NAME ap_slip
                NEXT FIELD ap_slip
              WHEN INFIELD(ap_type)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_apr"
                LET g_qryparam.default1 = ap_type
                CALL cl_create_qry() RETURNING ap_type
                DISPLAY BY NAME ap_type
                NEXT FIELD ap_type
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t250_s
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   LET g_count = 0
   LET l_buf1 = g_wc
   IF l_buf1 != ' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM apa_file,npn_file ",
                " WHERE apa25=npn01 AND apa42 = 'N' AND ",l_buf1 CLIPPED
      PREPARE t250_apa_pre FROM g_sql
      IF SQLCA.sqlcode THEN CALL cl_err('t250_apa_pre',STATUS,1) END IF
      DECLARE t250_apa_cur CURSOR FOR t250_apa_pre
      IF SQLCA.sqlcode THEN CALL cl_err('t250_apa_cur',STATUS,1) END IF
      OPEN t250_apa_cur
      FETCH t250_apa_cur INTO g_count
   END IF
   IF g_count > 0 THEN
      LET g_success='N'
   ELSE
      CALL cl_err('','anm-999',0)
#     MESSAGE '資料正在處理中,請稍候.........'
      LET g_sql = "SELECT * FROM npn_file,npo_file LEFT JOIN nmh_file ON  npo03=nmh_file.nmh01 ",
                  " WHERE npn01=npo01 ",
                  "   AND npn03='9' ",
                  "   AND ", g_wc CLIPPED

      OPEN t250_cl USING g_npn.npn01
      IF STATUS THEN
         CALL cl_err("OPEN t250_cl:", STATUS, 1)
         CLOSE t250_cl
         CLOSE WINDOW t250_s
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t250_cl INTO g_npn.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_npn.npn01,SQLCA.sqlcode,0)
         CLOSE t250_cl
         CLOSE WINDOW t250_s
         ROLLBACK WORK
         RETURN
      END IF
      PREPARE t250_t_prepare_1 FROM g_sql
      DECLARE t250_t_1 CURSOR FOR t250_t_prepare_1

      DROP TABLE tmp1_file
      DROP TABLE tmp2_file
      DROP TABLE tmp3_file
      CALL t250_create_apa()
      CALL t250_create_apb()
      CALL t250_create_apa01()

      CALL s_showmsg_init()
      FOREACH t250_t_1 INTO g_npn.*,l_npo.*,l_nmh.*
         IF STATUS THEN
            CALL s_errmsg('','','foreach',STATUS,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF g_npn.npnconf = 'N' THEN
            CALL s_errmsg('npn01',g_npn.npn01,'','anm-960',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         SELECT COUNT(*) INTO l_n FROM nmi_file
          WHERE nmi01=l_npo.npo03 AND nmi05 != '5'
         IF l_n = 0 THEN
            CALL s_errmsg('nmi01',l_npo.npo03,l_npo.npo03,'anm-652',1)
             LET g_success='N'
             CONTINUE FOREACH
         END IF
         INITIALIZE g_apa.* TO NULL
         LET g_apa.apa00 = '12'
         #帳款編號字段產生
         CALL s_auto_assign_no("aap",ap_slip,g_npn.npn02,"12","","","","","")
          RETURNING li_result,g_apa.apa01
         IF (NOT li_result) THEN
            LET g_success="N"
         END IF
         LET g_apa.apa79 = 0
         LET g_apa.apa02 = g_npn.npn02
         LET g_apa.apa05 = l_nmh.nmh22
         LET g_apa.apa06 = l_nmh.nmh22
         LET g_apa.apa07 = l_nmh.nmh23
         LET g_apa.apa08 = ' '
         LET g_apa.apa20 = 0

         SELECT pmc17,pmc47,pmc24 INTO g_apa.apa11,g_apa.apa15,g_apa.apa18
           FROM pmc_file WHERE pmc01=g_apa.apa05
         IF STATUS THEN
            LET g_success='N' LET g_errno = 'aap-040'
         END IF
         SELECT gec04 INTO g_apa.apa16 FROM gec_file
          WHERE gec01=g_apa.apa15 AND gec011='1'
         CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,g_apa.apa06)
             RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
         IF g_errno <> ' ' THEN LET g_success='N' END IF
         LET g_apa.apa13 = g_npn.npn04
         LET g_apa.apa14 = g_npn.npn05
         LET g_apa.apa72 = g_apa.apa72

         LET g_apa.apa17 = '1'
         LET g_apa.apa171= '21'
         LET g_apa.apa172= '1'
         LET g_apa.apa173=YEAR(g_today)
         LET g_apa.apa174=MONTH(g_today)

         LET g_apa.apa21 = g_user
         SELECT gen03 INTO g_apa.apa22 FROM gen_file WHERE gen01=g_apa.apa21

         LET g_apa.apa25 = l_npo.npo01
         LET g_apa.apa31f= l_npo.npo04
         LET g_apa.apa32f= 0
         LET g_apa.apa33f= 0
         LET g_apa.apa34f= l_npo.npo04
         LET g_apa.apa35f= 0
         LET g_apa.apa31 = l_npo.npo06
         LET g_apa.apa32 = 0
         LET g_apa.apa33 = 0
         LET g_apa.apa34 = l_npo.npo06
         LET g_apa.apa73 = g_apa.apa34
         LET g_apa.apa74 = 'N'
         LET g_apa.apa35 = 0

         LET g_apa.apa36 = ap_type

         LET g_apa.apa41 = 'Y'
         LET g_apa.apa42 = 'N'
         LET g_apa.apa44 = g_npn.npn09
         SELECT apz13 INTO l_apz13 FROM apz_file WHERE apz00='0'
         IF l_apz13 = 'Y' THEN
            LET l_depno = g_apa.apa22
         ELSE
            LET l_depno = ' '
         END IF
    IF g_aza.aza63 ='N' THEN
        SELECT * INTO l_aps.* FROM aps_file WHERE aps01=l_depno
         SELECT apt03,apt04 INTO  g_apa.apa51,g_apa.apa54 FROM apt_file
          WHERE apt01=g_apa.apa36 AND apt02 = l_depno
         IF STATUS THEN
            LET g_apa.apa51 = l_aps.aps21
            LET g_apa.apa54 = l_aps.aps22
         END IF
    ELSE
        SELECT * INTO l_aps.* FROM aps_file WHERE aps01=l_depno
        SELECT apt03,apt04,apt031,apt041 INTO  g_apa.apa51,g_apa.apa54,g_apa.apa511,g_apa.apa541 FROM apt_file
         WHERE apt01=g_apa.apa36 AND apt02 = l_depno
        IF STATUS THEN
           LET g_apa.apa51 = l_aps.aps21
           LET g_apa.apa54 = l_aps.aps22
           LET g_apa.apa511 = l_aps.aps211
           LET g_apa.apa541 = l_aps.aps221
     END IF
    END IF
         SELECT gec03 INTO g_apa.apa52 FROM gec_file WHERE gec01=g_apa.apa15

         LET g_apa.apa55 = '1'
         LET g_apa.apa56 = '0'
         LET g_apa.apa57 = 0
         LET g_apa.apa57f= 0
         LET g_apa.apa58 = NULL
         LET g_apa.apa59 = NULL
         LET g_apa.apa60f= 0
         LET g_apa.apa61f= 0
         LET g_apa.apa60 = 0
         LET g_apa.apa61 = 0
         LET g_apa.apa65f= 0
         LET g_apa.apa65 = 0
         LET g_apa.apainpd = g_today
         LET g_apa.apaprno = 0
         LET g_apa.apaacti = 'Y'
         LET g_apa.apauser = g_user
         LET g_apa.apagrup = g_grup
         LET g_apa.apadate = g_today
         LET g_apa.apa930=s_costcenter(g_apa.apa22)

         #先存在buffer內
         LET g_apa.apalegal = g_legal
         LET g_apa.apa79 = '1'
         INSERT INTO tmp1_file VALUES(g_apa.*)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp1_file',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF

         # 單身部份 --------------------------------------------------------#
         INITIALIZE g_apb.* TO NULL
         LET g_apb.apb01 = g_apa.apa01
         LET g_apb.apb08 = l_npo.npo06       #本幣單價
         LET g_apb.apb09 = 1                 #數量
         LET g_apb.apb10 = l_npo.npo06       #本幣金額
         LET g_apb.apb081=g_apb.apb08
         LET g_apb.apb101=g_apb.apb10
         LET g_apb.apb12 = ' '               #料號
         LET g_apb.apb13f= 0                 #原幣折讓單價
         LET g_apb.apb13 = 0                 #本幣折讓單價
         LET g_apb.apb14f= 0                 #原幣折讓金額
         LET g_apb.apb14 = 0                 #本幣折讓金額
         LET g_apb.apb15 = 0                 #折讓數量
         LET g_apb.apb34 = 'N'               #No.TQC-7B0083
         LET g_apb.apb23 = l_npo.npo04       #原幣單價
         LET g_apb.apb24 = l_npo.npo04       #原幣金額
         #LET g_apb.apb26 = l_nmd.nmd18       #部門
         LET g_apb.apb27 = '票據立帳'        #品名
         LET g_apb.apb930=g_apa.apa930
         LET g_apb.apb02 = l_npo.npo02
         LET g_apb.apblegal = g_legal
         INSERT INTO tmp2_file VALUES(g_apb.*,l_nmh.nmh22)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp2_file',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END FOREACH
     #再將資料抓出處理
      DECLARE tmp1_cur_1 CURSOR FOR
       SELECT * FROM tmp1_file
        ORDER BY apa05
      IF SQLCA.sqlcode THEN CALL cl_err('tmp1_cur',STATUS,1) END IF
      CALL cl_outnam('anmt250') RETURNING l_name1
      START REPORT t250_rep2 to l_name1
      FOREACH tmp1_cur_1 INTO l_apa.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','foreach oma',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         OUTPUT TO REPORT t250_rep2(l_apa.*,ap_slip)
      END FOREACH
      FINISH REPORT t250_rep2
      IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF
      DECLARE tmp2_cur_1 CURSOR FOR
        SELECT * FROM tmp2_file ORDER BY cus
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','tmp2_cur',STATUS,0)
      END IF
      LET l_custom = ' '
      LET l_custom_old=' '
      INITIALIZE l_apb.* to NULL
      LET l_apb02 = 0
      LET g_cnt = 0
      FOREACH tmp2_cur_1 INTO l_apb.*,l_nmh22
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','foreach omb',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_custom = l_nmh22
         LET g_cnt = g_cnt + 1
         IF l_custom != l_custom_old AND g_cnt != 1 THEN
            LET l_apb02 = 0
         END IF
         LET l_apb02 = l_apb02 + 1
         LET l_nmh22 = l_nmh22 CLIPPED
         SELECT a01 INTO l_apb.apb01 FROM tmp3_file where a03 =l_nmh22
         LET l_apb.apb02 = l_apb02
         LET l_apb.apb34 = 'N'

         LET l_apb.apblegal = g_legal

         INSERT INTO apb_file VALUES(l_apb.*)
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('apb01',l_apb.apb01,'ins apb',STATUS,1)
             LET g_success = 'N'
         END IF
         LET l_custom_old = l_nmh22
      END FOREACH

      DECLARE tmp3_cs_1 CURSOR FOR SELECT a01 FROM tmp3_file
      FOREACH tmp3_cs_1 INTO l_apa.apa01
         SELECT SUM(apb10),SUM(apb24) INTO l_apa.apa57,l_apa.apa57f FROM apb_file
          WHERE apb01=l_apa.apa01
         UPDATE apa_file SET apa57 = l_apa.apa57,
                             apa57f = l_apa.apa57f
          WHERE apa01=l_apa.apa01
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('apa01',l_apa.apa01,'upd apa',STATUS,1)
             LET g_success = 'N'
         END IF
      END FOREACH

   END IF

    CLOSE WINDOW t250_s                 #結束畫面

    IF g_success = 'Y' THEN
       CALL s_showmsg()          #No.FUN-710024
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg('','','',g_errno,0)
       END IF
      IF g_count > 0 THEN
       # MESSAGE '應付帳款已存在,無法重複產生 !!'
         CALL s_errmsg('','','','anm-651',1)
        CALL s_showmsg()
        ROLLBACK WORK
      ELSE
         CALL cl_rbmsg(1)
         CALL s_showmsg()
         ROLLBACK WORK
      END IF
    END IF
END FUNCTION

REPORT t250_rep2(p_apa,p_slip)
   DEFINE p_apa       RECORD LIKE apa_file.*
   DEFINE l_apc       RECORD LIKE apc_file.*
   DEFINE p_slip      LIKE oay_file.oayslip
   DEFINE li_result   LIKE type_file.num5

   ORDER EXTERNAL BY p_apa.apa05  #轉付廠商
   FORMAT
      AFTER GROUP OF p_apa.apa05
        LET p_apa.apa31f = GROUP SUM(p_apa.apa31f)
        LET p_apa.apa32f = GROUP SUM(p_apa.apa32f)
        LET p_apa.apa33f = GROUP SUM(p_apa.apa33f)
        LET p_apa.apa34f = GROUP SUM(p_apa.apa34f)
        LET p_apa.apa35f = GROUP SUM(p_apa.apa35f)
        LET p_apa.apa31  = GROUP SUM(p_apa.apa31)
        LET p_apa.apa32  = GROUP SUM(p_apa.apa32)
        LET p_apa.apa33  = GROUP SUM(p_apa.apa33)
        LET p_apa.apa34  = GROUP SUM(p_apa.apa34)
        LET p_apa.apa35  = GROUP SUM(p_apa.apa35)
        LET p_apa.apa79  = 0
        CALL t250_comp_oox(p_apa.apa01) RETURNING g_net
        LET p_apa.apa73  = p_apa.apa34-p_apa.apa35 + g_net

      CALL s_auto_assign_no("aap",p_slip,p_apa.apa02,"12","","","","","")
           RETURNING li_result,p_apa.apa01
      IF (NOT li_result) THEN
         LET g_success='N'
      END IF

       LET p_apa.apa100 = g_plant
       LET p_apa.apalegal = g_legal

       LET p_apa.apaoriu = g_user
       LET p_apa.apaorig = g_grup
       INSERT INTO apa_file VALUES(p_apa.*)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('apa01',p_apa.apa01,'ins apa_file',SQLCA.sqlcode,1)
          LET g_success='N'
       ELSE
          #寫入多帳期資料
          INITIALIZE l_apc.* TO NULL
          LET l_apc.apc01 = p_apa.apa01
          LET l_apc.apc02 = 1
          LET l_apc.apc03 = p_apa.apa11
          LET l_apc.apc04 = p_apa.apa12
          LET l_apc.apc05 = p_apa.apa64
          LET l_apc.apc06 = p_apa.apa14
          LET l_apc.apc07 = p_apa.apa72
          LET l_apc.apc08 = p_apa.apa34f
          LET l_apc.apc09 = p_apa.apa34
          LET l_apc.apc10 = p_apa.apa35f
          LET l_apc.apc11 = p_apa.apa35
          LET l_apc.apc12 = p_apa.apa08
          LET l_apc.apc13 = p_apa.apa73
          LET l_apc.apc14 = p_apa.apa65f
          LET l_apc.apc15 = p_apa.apa65
          LET l_apc.apc16 = p_apa.apa20

          LET l_apc.apclegal = g_legal

          INSERT INTO apc_file VALUES(l_apc.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","apc_file",p_apa.apa01,"1",SQLCA.sqlcode,"","ins apc_file",1)
             LET g_success = 'N'
          END IF
       END IF
       #記錄同客戶之帳單編號
       INSERT INTO tmp3_file VALUES(p_apa.apa01,p_apa.apa05)
       IF SQLCA.sqlcode THEN
          LET g_success='N'
          CALL s_errmsg('apa01',p_apa.apa01,'ins tmp3',SQLCA.sqlcode,1)
       END IF
END REPORT

FUNCTION t250_create_apa()
   SELECT *
     FROM apa_file
    WHERE apa01='@@@@'
     INTO TEMP tmp1_file
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err('create tmp1_file:',SQLCA.SQLCODE,0)
   END IF
   DELETE FROM tmp1_file WHERE 1=1
END FUNCTION

FUNCTION t250_create_apb()
   SELECT apb_file.*,'aaaaaaaaaa' cus
     FROM apb_file
    WHERE apb01='@@@@'
     INTO TEMP tmp2_file
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err('create tmp2_file:',SQLCA.SQLCODE,0)
   END IF

   DELETE FROM tmp2_file WHERE 1=1
END FUNCTION

FUNCTION t250_create_apa01()

    CREATE TEMP TABLE tmp3_file(
      a01 LIKE apb_file.apb01,
      a03 LIKE nmh_file.nmh22)

END FUNCTION
FUNCTION t250_s2()
   DEFINE l_apa01 LIKE apa_file.apa01
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_apa35 LIKE apa_file.apa35
   DEFINE l_apa35f LIKE apa_file.apa35f

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM apa_file
     WHERE apa25 = g_npn.npn01
   IF l_cnt = 0 THEN
      RETURN
   END IF

   IF cl_confirm('anm-399') THEN
      BEGIN WORK
      LET g_success='Y'


      DECLARE apa_c CURSOR FOR
        SELECT apa01 FROM apa_file WHERE apa25=g_npn.npn01

      FOREACH apa_c INTO l_apa01
         SELECT apa35,apa35f INTO l_apa35,l_apa35f FROM apa_file
           WHERE apa01 = l_apa01
         IF (l_apa35 IS NOT NULL AND l_apa35 > 0) OR
            (l_apa35f IS NOT NULL AND l_apa35f > 0) THEN
            CALL cl_err('','mfg-013',0)
            LET g_success='N'
            EXIT FOREACH
         END IF
         DELETE FROM apa_file WHERE apa01 = l_apa01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("del","apa_file",l_apa01,"",SQLCA.sqlcode,"","del apa_file",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         DELETE FROM apc_file WHERE apc01 = l_apa01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("del","apc_file",l_apa01,"",SQLCA.sqlcode,"","del apc_file",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         DELETE FROM apb_file WHERE apb01 = l_apa01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("del","apb_file",l_apa01,"",SQLCA.sqlcode,"","del apb_file",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF g_success='Y' THEN
         CALL cl_err('','lib-022',0)
         COMMIT WORK
      ELSE
         CALL cl_err('','mfg1604',0)
         ROLLBACK WORK
      END IF
   END IF
END FUNCTION
FUNCTION t250_comp_oox(p_apv03)
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
#FUN-C70129--add--end

#darcy:2024/08/22 add s---
function anmt250_set_entry_b(p_cmd)
	define p_cmd      like type_file.chr1
	if g_npn.npn03 matches '[458]' then #darcy:2025/06/27 add 4
		# 转付的时候，允许修改原币和本币
		call cl_set_comp_entry("npo04",true)
		call cl_set_comp_required("npo04",true)
	end if
end function
function anmt250_no_set_entry_b(p_cmd)
   	define p_cmd      like type_file.chr1
	if g_npn.npn03 not matches '[458]' then #darcy:2025/06/27 add 4
		# 不是转付的时候，不允许修改原币和本币
		call cl_set_comp_entry("npo04",false)
	end if
end function
#darcy:2024/08/22 add e---
