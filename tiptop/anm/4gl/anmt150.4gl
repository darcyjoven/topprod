# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt150.4gl
# Descriptions...: 應付票據異動維護作業
# Date & Author..: 97/04/18 By Charis
# Modify.........: 97/05/13 By Danny 1.確認時, 若單別須拋轉總帳, 檢查分錄底稿
#                                    2.已拋轉總帳者, 不可再產生分錄底稿
#                                    3.產生分錄底稿時, 傳票日期=NULL
#                                    4.取消時, 刪除分錄底稿
# Modify.........: 97/05/27 By Lynn  1.新增時,詢問是否產生分錄底稿
#                                    2.取消確認,若已拋轉總帳,show警告訊息
# Modify.........: 99/08/04 By Carol:1.作廢->資料寫入支票作廢檔nnz_file
#                                            (t150_ins_nnz())
#                                    2.票況為開立,不可退票(t150_nmd())
#                                    3.修改時不可異動票況,以免確認時有誤
#                                    4.科目不做部門管理,產生分錄不應有部門
# Modify.........: 03/04/08 By Kitty:確認時判斷若為融資產生之支票兌現要回寫
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8 AND gec011='1'
# Modify.........: No:815903/10/15 By Kitty 執行 T.應撤/退/作廢票立帳apa給值修改
# Modify.........: No.8608 03/10/30 By Kitty 確認段的Transction再改善
# Modify.........: No.9006 04/01/09 By Kammy npl05 並不會位幣別帶出匯率
# Modify.........: No.9519 04/05/05 By Carol mark BEFORE FIELD npm05,npm06 段的檢查
# Modify.........: No.9568 04/05/18 By Kitty t150_g_b1()中l_wc定義太小
# Modify.........: No.MOD-480323 04/08/16 Kammy 票況兌現，不可撤票
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4B0027 04/11/16 By Nicola 輸入完npl04後，npl05無法取出匯率
# Modify.........: No.MOD-4B0026 04/11/17 By Nicola 新增輸入時,若為外幣,且user有自行輸入指定的匯率,會被再一次的改掉
# Modify.........: No.FUN-4B0008 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.MOD-4B0244 04/11/30 By Nicola 修改單頭匯率資料後，應重新計算本幣異動金額欄位
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510079 05/01/12 By Kitty 簿號98要可以作兌現
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.MOD-550071 05/05/30 By ching s_fsgl傳本幣
# Modify.........: No.FUN-560002 05/06/03 By Will 單據編號修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5A0078 05/10/07 By Dido 列印時使用 s_auto_assign_no 修改傳入參數
# Modify.........: No.MOD-5A0204 05/10/28 By Smapmin 單身自行輸入開票單號時,沒有控管支票號碼為空白者,不能輸入.
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.MOD-5A0287 05/12/06 By Smapmin 取消作廢時,以日期判斷該單據是否是最後一張異動單才可以取消作廢.
#                                                    若日期一樣,則以票況來判斷!
# Modify.........: No.FUN-630020 06/03/07 By pengu 流程訊息通知功能
# Modify.........: No.MOD-640092 06/04/09 By Smapmin 確認的單子不可再按產生分錄
# Modify.........: NO.MOD-640077 06/04/11 BY yiting  未產生分錄卻能確認
# Modify.........: No.MOD-650001 06/05/03 By Smapmin 修改DELETE FROM nme_file的錯誤判斷條件
# Modify.........: No.MOD-660100 06/06/26 By Smapmin Update apa57f
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670033 06/07/07 By Smapmin 已兌現支票不可再做兌現
# Modify.........: No.FUN-670064 06/07/19 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670060 06/07/26 By ice 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680034 06/08/22 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION t150_q() 一開始應清空g_npl.*值
#                                                  2.新增action"相關文件"
#
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6C0057 06/12/11 By Smapmin 應付電匯款開放可以作廢
# Modify.........: No.FUN-710024 07/01/25 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.MOD-720066 07/02/08 By Smapmin 確認段不應只控管nnf08='2'才UPDATE nne_file
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740108 07/04/22 By Smapmin 修改報表名稱
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier apb34給default值'N'
# Modify.........: No.MOD-7C0090 07/12/14 By Smapmin Return時,要把當下Window close掉
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810265 08/01/31 By Sarah anmt150產生aapt120時,沒有寫入多帳期資料(apc_file)
# Modify.........: No.CHI-810018 08/03/07 By Smapmin 應撤/退/作廢票立帳時,預設QBE條件.
#                                                    增加"應撤/退/作廢票立帳還原"
# Modify.........: No.MOD-810268 08/03/07 By Smapmin 確認段寫入 nme_file 前檢核異動碼正確性
# Modify.........: No.MOD-830031 08/03/07 By Smapmin 立帳時,單據未確認或已產生立帳資料都應秀出訊息.
# Modify.........: No.MOD-840530 08/04/22 By mike 增加撤退票串查AR/AP功能
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860308 08/07/08 By Sarah 當有單身資料時,單頭幣別不可異動
# Modify.........: No.MOD-870317 08/08/01 By Sarah t150_nmd()段,anm-028訊息的條件改為l_nmd12 !='8'
# Modify.........: No.MOD-8C0280 08/12/31 By Sarah 新增時需檢查輸入單號是否正確
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-910237 09/01/22 By Sarah t150_g_b1()段,檢查開單單號是否還有未確認單據的SQL應直接過濾nplconf='N'
# Modify.........: No.MOD-940044 09/04/03 By Sarah 應付票據兌現後,不可作廢
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.MOD-960276 09/06/24 By mike FUNCTION t150_b()段的npm03開窗,需調整  
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-960141 09/08/12 By lutingtingGP5.2去除apaplant,apbplant
# Modify.........: No.MOD-980093 09/08/12 By mike 銀行已關帳至８月底，但anmt150 , anmt250 卻還能做８月的兌現異動                    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-990004 09/09/07 By mike 客戶需要將票況為X.自動產生的應付票據也產生進anmt150里,為的是要產生分錄底稿!       
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9A0073 09/10/14 By xiaofeizhu 單頭異動別為“兌現”,單頭“單據日期”必須大于等于單身的“到期日期”  
# Modify.........: No:MOD-9A0160 09/10/26 By sabrina 產生應付時，應依有無付款單及營運中心判斷，是否由付款單產生 
# Modify.........: No:MOD-9A0180 09/10/28 By mike 单身开窗条件q_nmd1与_g_b 的捞资料条件不一致                                 
# Modify.........: No:MOD-9B0027 09/11/04 By Sarah 當npl03=7.退票/9.作廢且npm07=8.兌現時,
#                                                  確認時應減少nng21/nng23或nne27/nne20,取消確認應增加nng21/nng23或nne27/nne20
# Modify.........: No.FUN-9C0012 09/12/02 By ddestiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0098 09/12/14 By lilingyu 審核資料時,若單頭異動別為"8.兌現",增加判斷單據日期不可小于單身的到期日
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A60020 10/06/03 By sabrina npl03='9'且單據日期小於單身到期日要可以做確認 
# Modify.........: No:FUN-A60024 10/06/12 By wujie   新增apa79，预设值为0
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90052 10/09/07 By Dido anm-158 訊息僅限兌現才需要檢核 
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No:MOD-AB0196 10/11/24 By Dido 語法調整
# Modify.........: No:TQC-AB0025 10/11/25 By chenying 修改Sybase問題
# Modify.........: No.TQC-AB0243 10/11/30 By lixia執行撤/退/作廢票立帳時,插入零時表時報錯
# Modify.........: No:MOD-AC0053 10/12/07 By Dido 1.當單別為不產生分錄者不可選擇開立異動.
#                                                 2.自動產生應僅限目前票況為 '1' 的資料.
#                                                 3.手工輸入應僅限 '1'與 'X' 票況. 
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.MOD-AC0157 10/12/17 By wujie   apa79给预设值
# Modify.........: No.TQC-B10230 11/01/24 By yinhy 查詢時，單據不重複也會報錯"單據編號重複"
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30353 11/03/17 By lixia t150_t2()在BEGIN WORK前增加提示,若為'Y'則進入處理
# Modify.........: No:FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:TQC-B10225 11/04/27 By Dido 取消作廢增加與 AFTER FILE npm03 相同檢核 
# Modify.........: No:TQC-B40183 11/04/28 By yinhy 進入單身后在點擊右側退出，會出現多個btn_01等多個按鈕
# Modify.........: No:MOD-B50085 11/05/11 By Dido nme12不應給值m_npo.npm03,應給值g_npn.npl01 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No:TQC-B70209 11/07/29 By guoch tic_file删除数据时逻辑错误，进行bug修复
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.TQC-BB0070 11/11/14 By Carrier entry_sheet1变成 entry_sheet2
# Modify.........: No.MOD-BB0301 11/11/29 By Dido 單別說明顯示處理 
# Modify.........: No.MOD-C20010 12/02/01 By yinhy nme14若為空給默認值
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C40041 12/04/06 By Polly 增加控卡，異動別是相同且確認碼為Y
# Modify.........: No:MOD-C40080 12/04/12 By Elise 取消確認段增加判斷若傳票編號(npl09)為空時,則不需執行 anmp409
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50224 12/05/28 By lujh 點擊【審核】時應自動產生分錄，不需再去點產生分錄底稿按鈕
# Modify.........: No.MOD-C60017 12/06/11 By Elise 新增完資料進行刪除後，畫面並不會重show
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:MOD-C70025 12/07/03 By Carrier 点“删除”按钮确定后,该单据内容仍然显示在画面中,如果重新查询该单据倒是查询不出来
# Modify.........: No:MOD-C80141 12/08/22 By Polly 確認段中,無條件產生分錄,增加條件當npq_file無資料時,才需要 CALL t150_v() 函式
# Modify.........: No:MOD-C80205 12/08/30 By Polly 限定當異動別(npl03)為1開立時，應無本幣異動(npm06)為 0
# Modify.........: No:FUN-C50125 12/09/26 By wangwei 增加自動產生分錄底稿功能
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0045 12/12/27 By wangrr 增加功能:大陸版本anmt150中保證金可以從保證金帳戶直接解付
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gnmg150
# Modify..........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D30035 13/03/06 By Polly 相關非本張npl_file資料，一律改用nplconf <> 'X'條件  
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D80148 13/08/23 By yinhy 更改了實際銀行npm09並未在數據庫中更新

IMPORT os   #No.FUN-9C0009

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nme   RECORD LIKE nme_file.*,
    g_nmd   RECORD LIKE nmd_file.*,
    g_nmf   RECORD LIKE nmf_file.*,
    g_nnz   RECORD LIKE nnz_file.*,
    g_nme_o RECORD LIKE nme_file.*,
    g_npl   RECORD LIKE npl_file.*,
    g_apa   RECORD LIKE apa_file.*,
    g_apb   RECORD LIKE apb_file.*,
 g_amtdiff  LIKE npl_file.npl11,
    g_npl_o RECORD LIKE npl_file.*,
    g_npl_t RECORD LIKE npl_file.*,
    m_npm   RECORD LIKE npm_file.*,          #INSERT ime_file 用
    b_npm   RECORD LIKE npm_file.*,
    g_npm   DYNAMIC ARRAY OF RECORD
            npm02    LIKE npm_file.npm02,
            npm03    LIKE npm_file.npm03,
            nmd02    LIKE nmd_file.nmd02,
            nmd08    LIKE nmd_file.nmd08,
            nmd24    LIKE nmd_file.nmd24,
            nmd03    LIKE nmd_file.nmd03,
            nmd23    LIKE nmd_file.nmd23,
            nmd231   LIKE nmd_file.nmd231,   # No.FUN-680034
            nmd05    LIKE nmd_file.nmd05,
            nmd19    LIKE nmd_file.nmd19,
            npm09    LIKE npm_file.npm09,   #FUN-CB0045
            npm04    LIKE npm_file.npm04,
            npm05    LIKE npm_file.npm05,
            npm06    LIKE npm_file.npm06,
            npmdiff  LIKE npm_file.npm06,
            npmud01  LIKE npm_file.npmud01,
            npmud02  LIKE npm_file.npmud02,
            npmud03  LIKE npm_file.npmud03,
            npmud04  LIKE npm_file.npmud04,
            npmud05  LIKE npm_file.npmud05,
            npmud06  LIKE npm_file.npmud06,
            npmud07  LIKE npm_file.npmud07,
            npmud08  LIKE npm_file.npmud08,
            npmud09  LIKE npm_file.npmud09,
            npmud10  LIKE npm_file.npmud10,
            npmud11  LIKE npm_file.npmud11,
            npmud12  LIKE npm_file.npmud12,
            npmud13  LIKE npm_file.npmud13,
            npmud14  LIKE npm_file.npmud14,
            npmud15  LIKE npm_file.npmud15
 	    END RECORD,
    g_npm_t RECORD
            npm02    LIKE npm_file.npm02,
            npm03    LIKE npm_file.npm03,
            nmd02    LIKE nmd_file.nmd02,
            nmd08    LIKE nmd_file.nmd08,
            nmd24    LIKE nmd_file.nmd24,
            nmd03    LIKE nmd_file.nmd03,
            nmd23    LIKE nmd_file.nmd23,
            nmd231   LIKE nmd_file.nmd231,   # No.FUN-680034
            nmd05    LIKE nmd_file.nmd05,
            nmd19    LIKE nmd_file.nmd19,
            npm09    LIKE npm_file.npm09,   #FUN-CB0045
            npm04    LIKE npm_file.npm04,
            npm05    LIKE npm_file.npm05,
            npm06    LIKE npm_file.npm06,
            npmdiff  LIKE npm_file.npm06,
            npmud01  LIKE npm_file.npmud01,
            npmud02  LIKE npm_file.npmud02,
            npmud03  LIKE npm_file.npmud03,
            npmud04  LIKE npm_file.npmud04,
            npmud05  LIKE npm_file.npmud05,
            npmud06  LIKE npm_file.npmud06,
            npmud07  LIKE npm_file.npmud07,
            npmud08  LIKE npm_file.npmud08,
            npmud09  LIKE npm_file.npmud09,
            npmud10  LIKE npm_file.npmud10,
            npmud11  LIKE npm_file.npmud11,
            npmud12  LIKE npm_file.npmud12,
            npmud13  LIKE npm_file.npmud13,
            npmud14  LIKE npm_file.npmud14,
            npmud15  LIKE npm_file.npmud15
 	    END RECORD,
    g_dbs_gl            LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,  #No.FUN-980020
    g_nms               RECORD LIKE nms_file.*,
    g_buf               LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(20)
    g_dept              LIKE aab_file.aab02,   #No.FUN-680107 VARCHAR(6)
    m_chr               LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
    g_wc,g_wc1          string,                #No.FUN-580092 HCN
    g_sql               string,                #No.FUN-580092 HCN
    g_t1                LIKE oay_file.oayslip, #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    g_nmydmy1           LIKE nmy_file.nmydmy1, #No.FUN-680107 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,   #單身筆數  #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_cmd               LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(100)
    g_argv1		LIKE npl_file.npl01    #No.FUN-680107 VARCHAR(16)               #No.FUN-550057
DEFINE g_argv2          STRING                 #No.FUN-630020 add
DEFINE g_net            LIKE apv_file.apv04    #MOD-590440
DEFINE g_flag         LIKE type_file.chr1       #No.FUN-730032
DEFINE g_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE g_bookno2      LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_str            STRING                 #No.FUN-670060
DEFINE g_wc_gl          STRING                 #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_apa01        LIKE apa_file.apa01    #No.MOD-840530
 
 MAIN
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

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM npl_file WHERE npl01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t150_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

   LET g_plant_gl = g_nmz.nmz02p                      #FUN-980020
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new

   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'

   OPEN WINDOW t150_w WITH FORM "anm/42f/anmt150"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("npl061,npl071,nmd231", g_aza.aza63 = 'Y')
   #No.TQC-BB0070  --Begin
   #CALL cl_set_act_visible("entry_sheet1",g_aza.aza63 = 'Y') 
   CALL cl_set_act_visible("entry_sheet2",g_aza.aza63 = 'Y') 
   #No.TQC-BB0070  --End  
   CALL cl_set_comp_visible("npm09",g_aza.aza26='2')  #FUN-CB0045
   # 先以g_argv2判斷直接執行哪種功能，
   # 執行I時，g_argv1是單號
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t150_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t150_a()
            END IF
         OTHERWISE
                CALL t150_q()
      END CASE
   END IF
   CALL t150_menu()
   CLOSE WINDOW t150_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t150_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM
   CALL g_npm.clear()
   
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN         #No.FUN-630020 add
      LET g_wc=" npl01='",g_argv1,"'"
      LET g_wc1=" 1=1"
   ELSE
   INITIALIZE g_npl.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON npl01,npl02,npl03,npl04,npl05,npl08,
               npl09,nplconf,npl10,npl11,npl12,
               npl06,npl07,npl061,npl071, # No.FUN-680034 
               npluser,nplgrup,npldate,
               nplud01,nplud02,nplud03,nplud04,nplud05,
               nplud06,nplud07,nplud08,nplud09,nplud10,
               nplud11,nplud12,nplud13,nplud14,nplud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(npl01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_npl"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npl01
                 NEXT FIELD npl01
              WHEN INFIELD(npl04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npl04
                 NEXT FIELD npl04
              WHEN INFIELD(npl06)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npl.npl06,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_npl.npl06
                 DISPLAY BY NAME g_npl.npl06
                 NEXT FIELD npl06
              WHEN INFIELD(npl07)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npl.npl07,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_npl.npl07
                 DISPLAY BY NAME g_npl.npl07
                 NEXT FIELD npl07
             WHEN INFIELD(npl061)
                CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npl.npl061,'23',g_bookno2)     #No.FUN-980025
                RETURNING g_npl.npl061
                DISPLAY BY NAME g_npl.npl061
                NEXT FIELD npl061
             WHEN INFIELD(npl071)
                CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_npl.npl071,'23',g_bookno2)     #No.FUN-980025 
                RETURNING g_npl.npl071
                DISPLAY BY NAME g_npl.npl071
                NEXT FIELD npl071
 
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
 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('npluser', 'nplgrup')
 
 
      CONSTRUCT g_wc1 ON npm02,npm03,npm09,npm04,npm05,npm06     #FUN-CB0045 add npm09
                         ,npmud01,npmud02,npmud03,npmud04,npmud05
                         ,npmud06,npmud07,npmud08,npmud09,npmud10
                         ,npmud11,npmud12,npmud13,npmud14,npmud15
           FROM  s_npm[1].npm02,s_npm[1].npm03,s_npm[1].npm09,   #FUN-CB0045 add npm09
                 s_npm[1].npm04,s_npm[1].npm05,s_npm[1].npm06
                ,s_npm[1].npmud01,s_npm[1].npmud02,s_npm[1].npmud03
                ,s_npm[1].npmud04,s_npm[1].npmud05,s_npm[1].npmud06
                ,s_npm[1].npmud07,s_npm[1].npmud08,s_npm[1].npmud09
                ,s_npm[1].npmud10,s_npm[1].npmud11,s_npm[1].npmud12
                ,s_npm[1].npmud13,s_npm[1].npmud14,s_npm[1].npmud15
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npm03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmd1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npm03
                  NEXT FIELD npm03
               #FUN-CB0045--add--str--
               WHEN INFIELD(npm09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_npm09"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npm09
                  NEXT FIELD npm09
               #FUN-CB0045--add--end
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
   END IF
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN
      LET g_sql="SELECT npl01 FROM npl_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY npl01"
   ELSE
      LET g_sql="SELECT UNIQUE npl_file.npl01 ",
                "  FROM npl_file,npm_file ", # 組合出 SQL 指令
                " WHERE npl01=npm01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY npl01"
   END IF
   PREPARE t150_pr FROM g_sql           # RUNTIME 編譯
   DECLARE t150_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t150_pr
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
      LET g_sql="SELECT COUNT(*) FROM npl_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT npl01) FROM npl_file,npm_file ",
                " WHERE npl01=npm01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF
   PREPARE t150_precount FROM g_sql                           # row的個數
   DECLARE t150_count CURSOR FOR t150_precount
 
END FUNCTION
 
FUNCTION t150_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
   WHILE TRUE
      CALL t150_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t150_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t150_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t150_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t150_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t150_firm1()
               IF g_npl.nplconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t150_firm2()
               IF g_npl.nplconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t150_x()                      #FUN-D20035
               CALL t150_x(1)                     #FUN-D20035
               IF g_npl.nplconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
            END IF

         #FUN-D20035---ADD--STR
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t150_x(2)                 
               IF g_npl.nplconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
            END IF
         #FUN-D20035--ADD---END
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               CALL t150_v(1)
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_npl.npl01) THEN
               #系統別、類別、單號、票面金額
               CALL s_showmsg_init()   #No.FUN-710024
               CALL s_fsgl('NM',1,g_npl.npl01,g_npl.npl10,g_nmz.nmz02b,g_npl.npl03,
                                g_npl.nplconf,'0',g_nmz.nmz02p)
               CALL s_showmsg()          #No.FUN-710024
               CALL t150_npp02('0')
             END IF
        #No.TQC-BB0070  --Begin
        #WHEN "entry_sheet1"
        WHEN "entry_sheet2"
        #No.TQC-BB0070  --End  
           IF cl_chk_act_auth() AND not cl_null(g_npl.npl01) THEN
               CALL s_showmsg_init()   #No.FUN-710024
               CALL s_fsgl('NM',1,g_npl.npl01,g_npl.npl10,g_nmz.nmz02c,g_npl.npl03,
                               g_npl.nplconf,'1',g_nmz.nmz02p)
               CALL s_showmsg()          #No.FUN-710024
               CALL t150_npp02('1')
            END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_npl.nplconf ='Y' THEN
                  CALL t150_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_npl.nplconf ='Y' THEN
                  CALL t150_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         WHEN "ent_note_wtdw_ret_ac"
            IF cl_chk_act_auth() THEN
               CALL t150_t()
            END IF
 
         WHEN "ent_note_wtdw_ret_ac_rtn"
            IF cl_chk_act_auth() THEN
               CALL t150_t2()
            END IF
   
         WHEN "qry_misc_ap"
            IF cl_chk_act_auth() THEN
               IF not cl_null(g_npl.npl01) THEN
                  LET g_apa01 = null 
                  SELECT apa01 INTO g_apa01 FROM apa_file WHERE apa25=g_npl.npl01
                  LET l_cmd = "aapt120 '",g_apa01,"' q"
                  CALL cl_cmdrun(l_cmd CLIPPED)
               END IF 
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET g_wc = 'npl01="',g_npl.npl01,'"'
              #LET l_cmd =  "anmr150 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED  #FUN-C30085 mark
               #FUN-D10098--add--str--
               IF g_aza.aza26 = '2' THEN
                  LET l_cmd =  "gnmg150 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED 
               ELSE
               #FUN-D10098--add--end--
                  LET l_cmd =  "anmg150 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED  #FUN-C30085 add
               END IF   #FUN-D10098 add
               CALL cl_cmdrun(l_cmd CLIPPED)
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npm),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_npl.npl01 IS NOT NULL THEN
                 LET g_doc.column1 = "npl01"
                 LET g_doc.value1 = g_npl.npl01
                 CALL cl_doc()
               END IF
           END IF
      END CASE
   END WHILE
 
   CLOSE t150_cs
 
END FUNCTION
 
FUNCTION t150_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_npl.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t150_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN t150_count
   FETCH t150_count INTO g_row_count
 
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN t150_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      INITIALIZE g_npl.* TO NULL
   ELSE
      CALL t150_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t150_fetch(p_flnpl)
   DEFINE
       p_flnpl         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnpl
      WHEN 'N' FETCH NEXT     t150_cs INTO g_npl.npl01
      WHEN 'P' FETCH PREVIOUS t150_cs INTO g_npl.npl01
      WHEN 'F' FETCH FIRST    t150_cs INTO g_npl.npl01
      WHEN 'L' FETCH LAST     t150_cs INTO g_npl.npl01
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
            FETCH ABSOLUTE g_jump t150_cs INTO g_npl.npl01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      INITIALIZE g_npl.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnpl
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO FORMONLY.idx  #FUN-CB0045 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_npl.* FROM npl_file            # 重讀DB,因TEMP有不被更新特性
    WHERE npl01 = g_npl.npl01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_npl.npluser     #No.FUN-4C0063
      LET g_data_group = g_npl.nplgrup     #No.FUN-4C0063
      CALL t150_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION t150_show()
   DEFINE l_azi02,a,b   LIKE azi_file.azi02      #No.FUN-680107 VARCHAR(20)
   DEFINE l_nml02       LIKE nml_file.nml02      #No.FUN-680107 VARCHAR(20)
   DEFINE   li_result   LIKE type_file.num5      #No.FUN-560002 #No.FUN-680107 SMALLINT
 
   DISPLAY BY NAME g_npl.nploriu,g_npl.nplorig,
            g_npl.npl01,g_npl.npl02,g_npl.npl03,g_npl.npl04,
            g_npl.npl05,
            g_npl.npl08,g_npl.npl09,g_npl.npl10,g_npl.npl11,
            g_npl.npl12,
            g_npl.npl06,g_npl.npl07,g_npl.npl061,g_npl.npl071,  # No.FUN-680034 
            g_npl.nplconf,g_npl.npluser,g_npl.nplgrup,g_npl.npldate,
            g_npl.nplud01,g_npl.nplud02,g_npl.nplud03,g_npl.nplud04,
            g_npl.nplud05,g_npl.nplud06,g_npl.nplud07,g_npl.nplud08,
            g_npl.nplud09,g_npl.nplud10,g_npl.nplud11,g_npl.nplud12,
            g_npl.nplud13,g_npl.nplud14,g_npl.nplud15 
 
   LET g_t1 = s_get_doc_no(g_npl.npl01)       #No.FUN-550057

   SELECT * INTO g_nmy.*   #MOD-BB0301 
     FROM nmy_file         #MOD-BB0301
    WHERE nmyslip = g_t1   #MOD-BB0301

  #CALL s_check_no("anm",g_npl.npl01,"","A","","","")   #No.TQC-B10230 mark
  #     RETURNING li_result,g_npl.npl01                 #No.TQC-B10230 mark
   DISPLAY g_nmy.nmydesc TO nmydesc
   LET g_amtdiff=g_npl.npl11-g_npl.npl12
   DISPLAY g_amtdiff TO amt
   CALL cl_set_comp_visible("npm09",g_aza.aza26='2' AND g_npl.npl03='8')  #FUN-CB0045 
   CALL t150_b_fill(g_wc1)
   IF g_npl.nplconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t150_a()     #輸入
   DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_npm.clear()
   CALL g_npm.clear()
   INITIALIZE g_npl.* TO NULL
   LET g_npl_t.* = g_npl.*
   LET g_npl.nplconf='N'
   LET g_npl.npl02 = g_today
   LET g_npl.npluser = g_user
   LET g_npl.nploriu = g_user #FUN-980030
   LET g_npl.nplorig = g_grup #FUN-980030
   LET g_npl.nplgrup = g_grup               #使用者所屬群
   LET g_npl.npldate = g_today
   LET g_npl.npl10=0
   LET g_npl.npl11=0
   LET g_npl.npl12=0
   LET g_npl.npl04=g_aza.aza17
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t150_i('a')
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_npl.* TO NULL
         EXIT WHILE
      END IF
 
      IF cl_null(g_npl.npl01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
        CALL s_auto_assign_no("anm",g_npl.npl01,g_npl.npl02,"A","npl_file","npl01","","","")
             RETURNING li_result,g_npl.npl01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_npl.npl01
 
       IF (cl_null(g_npl.npl05) OR g_npl.npl05<=0) AND (g_npl.npl04 <> g_aza.aza17) THEN  #No.MOD-4B0026
         CALL s_curr3(g_npl.npl04,g_npl.npl02,'S') RETURNING g_npl.npl05
      END IF
 
      LET g_npl.npllegal = g_legal 
 
      INSERT INTO npl_file VALUES (g_npl.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('t150_ins_npl:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_npl.npl01,'I')
      END IF
 
      SELECT npl01 INTO g_npl.npl01 FROM npl_file WHERE npl01 = g_npl.npl01
      LET g_npl_t.* = g_npl.*
 
      CALL g_npm.clear()
      LET g_rec_b = 0                    #No.FUN-680064 
 
      CALL t150_b()
 
      MESSAGE " Wait ...."
      IF g_nmy.nmydmy1 = 'Y' AND g_nmy.nmydmy3 ='N' THEN
         CALL t150_firm1()
      END IF
 
      MESSAGE ""
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t150_g_b()                 	#由出貨通知單/訂單自動產生單身
 
   SELECT COUNT(*) INTO g_cnt FROM npm_file WHERE npm01=g_npl.npl01
 
   IF g_cnt = 0 THEN
      CALL t150_g_b1()
      CALL t150_bu()
      CALL t150_b_fill(' 1=1')
   END IF
 
END FUNCTION
 
FUNCTION t150_g_b1()                 	#由應付票據產生單身
   DEFINE l_wc    STRING #No:9568  #No.FUN-680107 VARCHAR(1000) #MOD-BB0301 mod 1000 -> STRING
   DEFINE l_npl01 LIKE npl_file.npl01
   DEFINE l_npm04 LIKE npm_file.npm04  #FUN-CB0045
   
   LET b_npm.npm01=g_npl.npl01
   LET b_npm.npm02=0
 
 
   OPEN WINDOW t150b_w AT 6,20
     WITH FORM "anm/42f/anmt1501"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt1501")
 
 
   CONSTRUCT BY NAME l_wc ON nmd05,nmd01,nmd02,nmd03
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
      CLOSE WINDOW t150b_w
      RETURN
   END IF
 
   CLOSE WINDOW t150b_w
   MESSAGE "WORKING !"
  #加上票號不可空白的判斷
   LET g_sql = "SELECT *  FROM nmd_file WHERE ",                                                                                    
               "(nmd02<>' ' AND nmd02 IS NOT NULL) AND ",                                                                           
               t150_get_npl03_where(),                                                                                              
               " AND ",l_wc CLIPPED                                                                                                 
   PREPARE t150_b_p FROM g_sql
   DECLARE t150_b_c CURSOR WITH HOLD FOR t150_b_p
 
   FOREACH t150_b_c INTO g_nmd.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      IF g_npl.npl03 MATCHES '[689]' AND g_nmd.nmd12 = '8' THEN  #MOD-940044
         CONTINUE FOREACH
      END IF
 
      SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file
       WHERE npl01 = npm01 AND npm03 = g_nmd.nmd01
        #AND nplconf = 'N'                               #未確認單據  #MOD-910237 #MOD-C40041 mark
         AND npl03 = g_npl.npl03                         #MOD-C40041 add
        #AND nplconf = 'Y'                               #MOD-C40041 add #MOD-D30035 mark
         AND nplconf <> 'X'                              #MOD-D30035 add

      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
 
      LET b_npm.npm02=b_npm.npm02+1
      LET b_npm.npm03=g_nmd.nmd01
     #LET b_npm.npm04=g_nmd.nmd04 #FUN-CB0045 Mark
     #LET b_npm.npm05=g_nmd.nmd26 #FUN-CB0045 Mark
     #FUN-CB0045--add--str--
      SELECT SUM(npm04) INTO l_npm04 FROM npm_file
      WHERE npm03=g_nmd.nmd01
        AND npm01<>g_npl.npl01 
      IF cl_null(l_npm04) THEN LET l_npm04=0 END IF
      LET b_npm.npm04=g_nmd.nmd04-l_npm04
      LET b_npm.npm05=b_npm.npm04*g_nmd.nmd19
     #FUN-CB0045--add--end
      CALL cl_digcut(b_npm.npm05,g_azi04) RETURNING b_npm.npm05
      IF g_npl.npl03 = 1 THEN                                     #MOD-C80205 add
         LET b_npm.npm06 = 0                                      #MOD-C80205 add
      ELSE                                                        #MOD-C80205 add
        #LET b_npm.npm06=g_nmd.nmd04 * g_npl.npl05 #FUN-CB0045 Mark
         LET b_npm.npm06=b_npm.npm04 * g_npl.npl05 #FUN-CB0045 Add
      END IF                                                      #MOD-C80205 add
      CALL cl_digcut(b_npm.npm06,g_azi04) RETURNING b_npm.npm06
      LET b_npm.npm07=g_nmd.nmd12
      LET b_npm.npm08=g_nmd.nmd13
 
      LET b_npm.npmud01 = ''
      LET b_npm.npmud02 = ''
      LET b_npm.npmud03 = ''
      LET b_npm.npmud04 = ''
      LET b_npm.npmud05 = ''
      LET b_npm.npmud06 = ''
      LET b_npm.npmud07 = ''
      LET b_npm.npmud08 = ''
      LET b_npm.npmud09 = ''
      LET b_npm.npmud10 = ''
      LET b_npm.npmud11 = ''
      LET b_npm.npmud12 = ''
      LET b_npm.npmud13 = ''
      LET b_npm.npmud14 = ''
      LET b_npm.npmud15 = ''
 
      LET b_npm.npmlegal = g_legal 
 
      INSERT INTO npm_file VALUES (b_npm.*)
   END FOREACH
   MESSAGE " "
 
END FUNCTION
 
FUNCTION t150_i(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_n        LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE l_tot      LIKE type_file.num20_6 #No.FUN-4C0010 #No.FUN-680107 DECIMAL(20,6)
    DEFINE l_nma02    LIKE nma_file.nma02
    DEFINE l_nma21    LIKE nma_file.nma21
    DEFINE l_nmaacti  LIKE nma_file.nmaacti
    DEFINE l_flag     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_msg      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
    DEFINE g_t1       LIKE nmy_file.nmyslip  #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
    DEFINE li_result  LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
    DEFINE l_nmydmy3  LIKE nmy_file.nmydmy3  #MOD-AC0053
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_npl.npl01,g_npl.npl02,g_npl.npl03,g_npl.npl04,g_npl.npl05, g_npl.nploriu,g_npl.nplorig,
                  g_npl.npl08,g_npl.npl09,g_npl.nplconf,
                  g_npl.npl10,g_npl.npl11,g_npl.npl12,
                  g_npl.npl06,g_npl.npl07,g_npl.npl061,g_npl.npl071,  # No.FUN-680034
                  g_npl.npluser,g_npl.nplgrup,g_npl.npldate,
                  g_npl.nplud01,g_npl.nplud02,g_npl.nplud03,g_npl.nplud04,
                  g_npl.nplud05,g_npl.nplud06,g_npl.nplud07,g_npl.nplud08,
                  g_npl.nplud09,g_npl.nplud10,g_npl.nplud11,g_npl.nplud12,
                  g_npl.nplud13,g_npl.nplud14,g_npl.nplud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t150_set_entry(p_cmd)
         CALL t150_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("npl01")
 
        AFTER FIELD npl01
           IF (p_cmd='a' AND g_npl.npl01 IS NOT NULL) OR
              (p_cmd='u' AND g_npl.npl01 != g_npl_t.npl01) THEN
              CALL s_check_no("anm",g_npl.npl01,g_npl_t.npl01,"A","npl_file","npl01","")
                RETURNING li_result,g_npl.npl01
              DISPLAY BY NAME g_npl.npl01
              IF (NOT li_result) THEN
                NEXT FIELD npl01
              END IF
           END IF
 
        AFTER FIELD npl02
           IF NOT cl_null(g_npl.npl02) THEN
              IF g_npl.npl02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1) NEXT FIELD npl02
              END IF
           END IF
 
        BEFORE FIELD npl03
           CALL t150_set_entry(p_cmd)
 
        AFTER FIELD npl03
           IF NOT cl_null(g_npl.npl03) THEN
              IF g_npl.npl03 NOT MATCHES "[16789C]" THEN
                 NEXT FIELD npl03
              END IF
             #-MOD-AC0053-add-
              LET g_t1 = s_get_doc_no(g_npl.npl01) 
              LET l_nmydmy3 = ''
              SELECT nmydmy3 INTO l_nmydmy3 
                FROM nmy_file 
               WHERE nmyslip = g_t1
              IF g_npl.npl03 = '1' AND l_nmydmy3 = 'N' THEN
                 CALL cl_err('','anm-131',1) 
                 NEXT FIELD npl01
              END IF
             #-MOD-AC0053-end-
           END IF
           CALL t150_set_no_entry(p_cmd)
 
        AFTER FIELD npl04
           IF NOT cl_null(g_npl.npl04) THEN
              SELECT azi02 INTO g_buf
                FROM azi_file
               WHERE azi01=g_npl.npl04
              IF STATUS THEN
                 CALL cl_err('select azi',STATUS,0)
                 NEXT FIELD npl04
              END IF
              IF g_npl.npl05=0 OR cl_null(g_npl.npl05) THEN
                 CALL s_curr3(g_npl.npl04,g_npl.npl02,'S') RETURNING g_npl.npl05
              END IF
              IF cl_null(g_npl.npl05) THEN
                 LET g_npl.npl05=1
              END IF
              DISPLAY BY NAME g_npl.npl05
           END IF
 
        AFTER FIELD npl05
           IF NOT cl_null(g_npl.npl05) OR g_npl.npl05 <> 0 THEN
              IF cl_null(g_npl_t.npl05) OR g_npl_t.npl05 <> g_npl.npl05 THEN
                 IF g_npl.npl03 = 1 THEN                  #MOD-C80205 add
                    UPDATE npm_file                       #MOD-C80205 add
                       SET npm06 = 0                      #MOD-C80205 add
                     WHERE npm01 = g_npl.npl01            #MOD-C80205 add
                 ELSE                                     #MOD-C80205 add
                     UPDATE npm_file 
                        SET npm06 = npm04 * g_npl.npl05
                      WHERE npm01 = g_npl.npl01
                 END IF                                   #MOD-C80205 add
                 CALL t150_bu()
              END IF
 
              IF g_npl.npl04 =g_aza.aza17 THEN
                 LET g_npl.npl05 =1
                 DISPLAY BY NAME g_npl.npl05
              END IF
 
           END IF
 
        AFTER FIELD npl06
          IF NOT cl_null(g_npl.npl06) THEN
             CALL t150_chkag(g_npl.npl06,'0')       #No.FUN-730032
             IF NOT cl_null(g_errno) THEN 
#FUN-B20073 --begin--
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) 
                    RETURNING g_flag,g_bookno1,g_bookno2  
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npl.npl06,'23',g_bookno1)  
                    RETURNING g_npl.npl06
                 DISPLAY BY NAME g_npl.npl06
#FUN-B20073 --end--             
                NEXT FIELD npl06 
             END IF
             DISPLAY BY NAME g_npl.npl06
          END IF
 
        AFTER FIELD npl07
          IF NOT cl_null(g_npl.npl07) THEN
             CALL t150_chkag(g_npl.npl07,'0')       #No.FUN-730032
             IF NOT cl_null(g_errno) THEN 
#FUN-B20073 --begin--
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) 
                   RETURNING g_flag,g_bookno1,g_bookno2   
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npl.npl07,'23',g_bookno1)     
                   RETURNING g_npl.npl07
                 DISPLAY BY NAME g_npl.npl07
#FUN-B20073 --end--             
                NEXT FIELD npl07                 
             END IF
             DISPLAY BY NAME g_npl.npl07
          END IF
         
       AFTER FIELD npl061
         IF NOT cl_null(g_npl.npl061) THEN
            CALL t150_chkag(g_npl.npl061,'1')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN 
#FUN-B20073 --begin--
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) 
                   RETURNING g_flag,g_bookno1,g_bookno2  
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npl.npl061,'23',g_bookno2)     
                   RETURNING g_npl.npl061
                DISPLAY BY NAME g_npl.npl061
#FUN-B20073 --end--            
               NEXT FIELD npl061 
            END IF
            DISPLAY BY NAME g_npl.npl061
         END IF
 
       AFTER FIELD npl071
         IF NOT cl_null(g_npl.npl071) THEN
            CALL t150_chkag(g_npl.npl071,'1')       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN 
#FUN-B20073 --begin--
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) 
                    RETURNING g_flag,g_bookno1,g_bookno2 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_npl.npl071,'23',g_bookno2) 
                  RETURNING g_npl.npl071
                DISPLAY BY NAME g_npl.npl071
#FUN-B20073 --end--            
               NEXT FIELD npl071 
            END IF
            DISPLAY BY NAME g_npl.npl071
         END IF
 
       AFTER FIELD nplud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD nplud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_npl.npluser = s_get_data_owner("npl_file") #FUN-C10039
           LET g_npl.nplgrup = s_get_data_group("npl_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
           IF cl_null(g_npl.npl03) THEN
              NEXT FIELD npl03
           END IF
           LET l_flag='N'
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(npl01)
                 LET g_t1 = s_get_doc_no(g_npl.npl01)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'A','ANM') RETURNING g_t1  #TQC-670008
                 LET g_npl.npl01 = g_t1            #No.FUN-550057
                 DISPLAY BY NAME g_npl.npl01 NEXT FIELD npl01
              WHEN INFIELD(npl04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_npl.npl04
                 CALL cl_create_qry() RETURNING g_npl.npl04
                 DISPLAY BY NAME g_npl.npl04
                 NEXT FIELD npl04
              WHEN INFIELD(npl06)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npl.npl06,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_npl.npl06
                 DISPLAY BY NAME g_npl.npl06
                 NEXT FIELD npl06
              WHEN INFIELD(npl07)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npl.npl07,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_npl.npl07
                 DISPLAY BY NAME g_npl.npl07
                 NEXT FIELD npl07
             WHEN INFIELD(npl061)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npl.npl061,'23',g_bookno2)     #No.FUN-980025
                RETURNING g_npl.npl061
                DISPLAY BY NAME g_npl.npl061
                NEXT FIELD npl061
             WHEN INFIELD(npl071)
                 CALL s_get_bookno1(YEAR(g_npl.npl02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
                 END IF
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_npl.npl071,'23',g_bookno2)     #No.FUN-980025
                RETURNING g_npl.npl071
                DISPLAY BY NAME g_npl.npl071
                NEXT FIELD npl071
 
              WHEN INFIELD(npl05)
                   CALL s_rate(g_npl.npl04,g_npl.npl05) RETURNING g_npl.npl05
                   DISPLAY BY NAME g_npl.npl05
                   NEXT FIELD npl05
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
 
FUNCTION t150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #No.FUN-680107 SMALLINT		   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,    #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680107 VARCHAR(1)
    l_nmaacti       LIKE nma_file.nmaacti,
    l_b2     	    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(30) #TQC-840066
    l_flag          LIKE type_file.num10,   #No.FUN-680107 INTEGER
    l_dir           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680107 SMALLINT
#FUN-CB0045--add--str--
DEFINE l_nmd04      LIKE nmd_file.nmd04,
       l_npm04      LIKE npm_file.npm04
#FUN-CB0045--add--end
 
    LET g_action_choice = ""
    SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
 
    IF cl_null(g_npl.npl01) THEN
       RETURN
    END IF
 
    IF g_npl.nplconf = 'Y' THEN
       CALL cl_err('','anm-105',0)
       RETURN
    END IF
 
    IF g_npl.nplconf='X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
 
    CALL t150_g_b()
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM npm_file WHERE npm01=? AND npm02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    #FUN-CB0045--add--str--
    #大陸版本單頭為8:兌現,實際銀行npm09和原幣金額npm04可錄入
    IF g_aza.aza26='2' AND g_npl.npl03='8' THEN
       CALL cl_set_comp_visible("npm09",TRUE)
       CALL cl_set_comp_entry("npm04",TRUE)
    ELSE
       CALL cl_set_comp_visible("npm09",FALSE)
       CALL cl_set_comp_entry("npm04",FALSE)
    END IF
    #FUN-CB0045--add--end
    
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_npm WITHOUT DEFAULTS FROM s_npm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
         CALL cl_set_docno_format("npm03")
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'                   #DEFAULT
           LET l_n  = ARR_COUNT()
	   BEGIN WORK
           OPEN t150_cl USING g_npl.npl01
           IF STATUS THEN
              CALL cl_err("OPEN t150_cl:", STATUS, 1)
              CLOSE t150_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t150_cl INTO g_npl.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
              CLOSE t150_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_npm_t.* = g_npm[l_ac].*  #BACKUP
               OPEN t150_bcl USING g_npl.npl01,g_npm_t.npm02
               IF STATUS THEN
                  CALL cl_err("OPEN t150_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
 
               FETCH t150_bcl INTO b_npm.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock npm',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t150_b_move_to()
                  LET g_npm_t.* = g_npm[l_ac].*  #BACKUP
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_npm[l_ac].* TO NULL      #900423
            LET b_npm.npm01=g_npl.npl01
            INITIALIZE g_npm_t.* TO NULL
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD npm02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t150_b_move_back()
   
            INSERT INTO npm_file VALUES(b_npm.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins npm',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               LET g_success = 'Y'
               CALL t150_bu()
               IF g_success='Y' THEN
                  COMMIT WORK
                  MESSAGE 'ins_npm_file INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
               ELSE
                  ROLLBACK WORK
                  MESSAGE 'ins_npm_file ROLLBACK'
               END IF
            END IF
 
        BEFORE FIELD npm02                            #default 序號
           IF cl_null(g_npm[l_ac].npm02) OR g_npm[l_ac].npm02 = 0 THEN
              SELECT max(npm02)+1 INTO g_npm[l_ac].npm02
                FROM npm_file WHERE npm01 = g_npl.npl01
              IF cl_null(g_npm[l_ac].npm02) THEN
                 LET g_npm[l_ac].npm02 = 1
              END IF
           END IF
 
        AFTER FIELD npm02                        #check 序號是否重複
           IF NOT cl_null(g_npm[l_ac].npm02) THEN
              IF g_npm[l_ac].npm02 != g_npm_t.npm02 OR cl_null(g_npm_t.npm02) THEN
                 SELECT count(*) INTO l_n FROM npm_file
                  WHERE npm01 = g_npl.npl01 AND npm02 = g_npm[l_ac].npm02
                 IF l_n > 0 THEN
                    LET g_npm[l_ac].npm02 = g_npm_t.npm02
                    CALL cl_err('',-239,0) NEXT FIELD npm02
                 END IF
              END IF
           END IF
 
        AFTER FIELD npm03
           #IF NOT cl_null(g_npm[l_ac].npm03) THEN #FUN-CB0045 Mark
           IF NOT cl_null(g_npm[l_ac].npm03)       #FUN-CB0045 add
              AND (p_cmd='a' OR g_npm[l_ac].npm03<> g_npm_t.npm03)THEN #FUN-CB0045 add
              CALL t150_nmd(g_npm[l_ac].npm03)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_npm[l_ac].npm03,g_errno,0)
                 LET g_npm[l_ac].npm03 = g_npm_t.npm03
                 NEXT FIELD npm03
              END IF
              IF NOT(g_aza.aza26='2' AND g_npl.npl03='8') THEN #FUN-CB0045
             #同一張異動,不允許有相同的開票單
              SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file
               WHERE npl01 = npm01 AND npm03 = g_npm[l_ac].npm03
                 AND npl01 = g_npl.npl01 AND npm02 != g_npm[l_ac].npm02
              IF g_cnt > 0 THEN
                 CALL cl_err(g_npm[l_ac].npm03,'anm-219',0)
                 LET g_npm[l_ac].npm03 = g_npm_t.npm03
                 NEXT FIELD npm03
              END IF
              END IF #FUN-CB0045
              SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file  #check是否重覆開立
               WHERE npl01 = npm01 
                 AND npm03 = g_npm[l_ac].npm03
                #AND nplconf='N'                          #MOD-C40041 mark
                 AND npl01 <> g_npl.npl01
                 AND npl03 = g_npl.npl03                  #MOD-C40041 add
                #AND nplconf = 'Y'                        #MOD-C40041 add #MOD-D30035 mark
                 AND nplconf <> 'X'                       #MOD-D30035 add

              IF g_cnt > 0 THEN
                 CALL cl_err(g_npm[l_ac].npm03,'anm-220',0)
                 LET g_npm[l_ac].npm03 = g_npm_t.npm03
                 NEXT FIELD npm03
              END IF
              IF g_npl.npl03 = '1' THEN                                                  #MOD-C80205 add
                 LET g_npm[l_ac].npm06 = 0                                               #MOD-C80205 add
              ELSE                                                                       #MOD-C80205 add
                 LET g_npm[l_ac].npm06 = g_npm[l_ac].npm04 * g_npl.npl05
              END IF                                                                     #MOD-C80205 add
              #DISPLAY BY NAME g_npm[l_ac].npm06    #No.MOD-4B0244 #FUN-CB0045 Mark
              CALL cl_digcut(g_npm[l_ac].npm06,g_azi04) RETURNING g_npm[l_ac].npm06
              DISPLAY BY NAME g_npm[l_ac].npm04,g_npm[l_ac].npm05,g_npm[l_ac].npm06 #FUN-CB0045 add
           END IF
 
     #FUN-CB0045--add--str--
        AFTER FIELD npm09
           IF NOT cl_null(g_npm[l_ac].npm09)
              #AND (p_cmd='a' OR g_npm[l_ac].npm09<> g_npm_t.npm09 ) THEN   
              AND (p_cmd='a' OR g_npm[l_ac].npm09<> g_npm_t.npm09 OR g_npm_t.npm09 IS NULL) THEN      #MOD-D80148
               SELECT nmaacti INTO l_nmaacti FROM nma_file
               WHERE nma01 = g_npm[l_ac].npm09
              IF SQLCA.SQLCODE = 100 THEN
                 CALL cl_err('','anm-013',0)
                 LET g_npm[l_ac].npm09=g_npm_t.npm09
                 NEXT FIELD npm09
              END IF
              IF l_nmaacti='N' THEN
                 CALL cl_err('','9028',0)
                 LET g_npm[l_ac].npm09=g_npm_t.npm09
                 NEXT FIELD npm09
              END IF
              LET g_cnt=0
              SELECT COUNT(*) INTO g_cnt FROM npm_file
              WHERE npm01=g_npl.npl01 AND npm03=g_npm[l_ac].npm03
                AND npm09=g_npm[l_ac].npm09
              IF g_cnt>0 THEN
                 CALL cl_err('','anm-264',0)
                 LET g_npm[l_ac].npm09=g_npm_t.npm09
                 NEXT FIELD npm09
              END IF
              DISPLAY BY NAME g_npm[l_ac].npm09      #MOD-D80148
           END IF

        AFTER FIELD npm04
           IF NOT cl_null(g_npm[l_ac].npm04) 
              AND (p_cmd='a' OR g_npm[l_ac].npm04<> g_npm_t.npm04) THEN
              #金額總額不可大於票據可用金額
              SELECT SUM(npm04) INTO l_npm04 FROM npm_file
              WHERE npm03=g_npm[l_ac].npm03
                AND (npm01<>g_npl.npl01 OR (npm01=g_npl.npl01 AND npm02<>g_npm[l_ac].npm02))
              IF cl_null(l_npm04) THEN LET l_npm04=0 END IF  
              SELECT nmd04 INTO l_nmd04 FROM nmd_file 
              WHERE nmd01=g_npm[l_ac].npm03
              IF l_nmd04<g_npm[l_ac].npm04+l_npm04 THEN
                 CALL cl_err('','anm-263',0)
                 NEXT FIELD npm04
              END IF
              LET g_npm[l_ac].npm05=g_npm[l_ac].npm04*g_npm[l_ac].nmd19
              LET g_npm[l_ac].npm06=g_npm[l_ac].npm04 * g_npl.npl05
              CALL cl_digcut(g_npm[l_ac].npm04,g_azi04) RETURNING g_npm[l_ac].npm04
              CALL cl_digcut(g_npm[l_ac].npm05,g_azi04) RETURNING g_npm[l_ac].npm05
              CALL cl_digcut(g_npm[l_ac].npm06,g_azi04) RETURNING g_npm[l_ac].npm06
              DISPLAY BY NAME g_npm[l_ac].npm04,g_npm[l_ac].npm05,g_npm[l_ac].npm06
           END IF

      AFTER FIELD npm05   
           IF NOT cl_null(g_npm[l_ac].npm05)
              AND (p_cmd='a' OR g_npm[l_ac].npm05<> g_npm_t.npm05) THEN
              LET g_npm[l_ac].npm04=g_npm[l_ac].npm05/g_npm[l_ac].nmd19
              CALL cl_digcut(g_npm[l_ac].npm04,g_azi04) RETURNING g_npm[l_ac].npm04
              IF g_aza.aza26='2' AND g_npl.npl03='8' THEN
                 #金額總額不可大於票據金額
                 SELECT SUM(npm04) INTO l_npm04 FROM npm_file
                  WHERE npm03=g_npm[l_ac].npm03
                    AND (npm01<>g_npl.npl01 OR (npm01=g_npl.npl01 AND npm02<>g_npm[l_ac].npm02))
                 SELECT nmd04 INTO l_nmd04 FROM nmd_file 
                  WHERE nmd01=g_npm[l_ac].npm03
                 IF l_nmd04<g_npm[l_ac].npm04+l_npm04 THEN
                    CALL cl_err('','anm-263',0)
                    NEXT FIELD npm05
                 END IF
              END IF
              LET g_npm[l_ac].npm06=g_npm[l_ac].npm04 * g_npl.npl05
              CALL cl_digcut(g_npm[l_ac].npm05,g_azi04) RETURNING g_npm[l_ac].npm05
              CALL cl_digcut(g_npm[l_ac].npm06,g_azi04) RETURNING g_npm[l_ac].npm06
              LET g_npm[l_ac].npmdiff=g_npm[l_ac].npm05 - g_npm[l_ac].npm06
              DISPLAY BY NAME g_npm[l_ac].npm04,g_npm[l_ac].npm05,
                              g_npm[l_ac].npm06,g_npm[l_ac].npmdiff
           END IF
      #FUN-CB0045--add--end
      
        #AFTER FIELD npm05,npm06 #FUN-CB0045 mark
        #FUN-CB0045--add--str--
        AFTER FIELD npm06
           IF NOT cl_null(g_npm[l_ac].npm06)
              AND (p_cmd='a' OR g_npm[l_ac].npm06<> g_npm_t.npm06) THEN
              LET g_npm[l_ac].npm04=g_npm[l_ac].npm06/g_npl.npl05
              IF g_aza.aza26='2' AND g_npl.npl03='8' THEN
                 #金額總額不可大於票據金額
                 SELECT SUM(npm04) INTO l_npm04 FROM npm_file
                 WHERE npm03=g_npm[l_ac].npm03
                   AND (npm01<>g_npl.npl01 OR (npm01=g_npl.npl01 AND npm02<>g_npm[l_ac].npm02))
                   
                 SELECT nmd04 INTO l_nmd04 FROM nmd_file 
                 WHERE nmd01=g_npm[l_ac].npm03
                 IF l_nmd04<g_npm[l_ac].npm04+l_npm04 THEN
                    CALL cl_err('','anm-263',0)
                    NEXT FIELD npm06
                 END IF
              END IF
              LET g_npm[l_ac].npm05=g_npm[l_ac].npm04 * g_npm[l_ac].nmd19
           END IF
           CALL cl_digcut(g_npm[l_ac].npm04,g_azi04) RETURNING g_npm[l_ac].npm04
           DISPLAY BY NAME g_npm[l_ac].npm04
       #FUN-CB0045--add--end
           CALL cl_digcut(g_npm[l_ac].npm05,g_azi04) RETURNING g_npm[l_ac].npm05
           CALL cl_digcut(g_npm[l_ac].npm06,g_azi04) RETURNING g_npm[l_ac].npm06
           IF g_npl.npl05 = 1 OR g_npl.npl03 = 1 THEN                                    #MOD-C80205 add
              LET g_npm[l_ac].npmdiff = 0                                                #MOD-C80205 add
           ELSE                                                                          #MOD-C80205 add
              LET g_npm[l_ac].npmdiff = g_npm[l_ac].npm05 - g_npm[l_ac].npm06
           END IF                                                                        #MOD-C80205 add
           DISPLAY BY NAME g_npm[l_ac].npm05
           DISPLAY BY NAME g_npm[l_ac].npm06
           DISPLAY BY NAME g_npm[l_ac].npmdiff
 
        AFTER FIELD npmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD npmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_npm_t.npm02 > 0 AND g_npm_t.npm02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM npm_file
                 WHERE npm01 = g_npl.npl01 AND npm02 = g_npm_t.npm02
               IF SQLCA.SQLCODE THEN
                  CALL cl_err(g_npm_t.npm02,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               CALL t150_bu()
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_npm[l_ac].* = g_npm_t.*
               CLOSE t150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_npm[l_ac].npm02,-263,1)
               LET g_npm[l_ac].* = g_npm_t.*
            ELSE
               CALL t150_b_move_back()
               UPDATE npm_file SET * = b_npm.*
                WHERE npm01=g_npl.npl01 AND npm02=g_npm_t.npm02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd npm',SQLCA.sqlcode,0)
                  LET g_npm[l_ac].* = g_npm_t.*
               ELSE
                  LET g_success = 'Y'
                  CALL t150_bu()
                  IF g_success='Y' THEN
                     COMMIT WORK
                     MESSAGE 'UPDATE O.K'
                  ELSE
                     ROLLBACK WORK
                     MESSAGE 'ROLLBACK'
                     MESSAGE 'upd_npm_file ROLLBACK'
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D30032 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_npm[l_ac].* = g_npm_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_npm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end-- 
               END IF
               CLOSE t150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D30032 Add
            CLOSE t150_bcl
            COMMIT WORK
 
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(npm03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmd1"
                 LET g_qryparam.default1 = g_npm[l_ac].npm02
                 LET g_qryparam.default2 = g_npm[l_ac].npm03
                 LET g_qryparam.where = t150_get_npl03_where()                                                                      
                 CALL cl_create_qry() RETURNING g_npm[l_ac].nmd02,g_npm[l_ac].npm03
                  DISPLAY BY NAME g_npm[l_ac].npm03            #No.MOD-490344
                  DISPLAY BY NAME g_npm[l_ac].nmd02            #No.MOD-490344
                 NEXT FIELD npm03
              #FUN-CB0045--add--str--
              WHEN INFIELD(npm09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 CALL cl_create_qry() RETURNING g_npm[l_ac].npm09
                 NEXT FIELD npm09
              #FUN-CB0045--add--end
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

    CALL t150_gen_gl()  #FUN-C50125
 
    UPDATE npl_file SET npldate = g_today
     WHERE npl01 = g_npl.npl01
 
    CLOSE t150_bcl
    COMMIT WORK
    CALL t150_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t150_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_npl.npl01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM npl_file ",
                  "  WHERE npl01 LIKE '",l_slip,"%' ",
                  "    AND npl01 > '",g_npl.npl01,"'"
      PREPARE t150_pb1 FROM l_sql 
      EXECUTE t150_pb1 INTO l_cnt 
      
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
        #CALL t150_x()                   #FUN-D20035
         CALL t150_x(1)                  #FUN-D20035
         IF g_npl.nplconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys = 'NM' AND npp00=1 AND npp01 = g_npl.npl01
            AND npp011=g_npl.npl03 
         DELETE FROM npq_file
          WHERE npqsys = 'NM' AND npq00=1 AND npq01 = g_npl.npl01
            AND npq011=g_npl.npl03 
         DELETE FROM tic_file WHERE tic04 = g_npl.npl01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM npl_file WHERE npl01 = g_npl.npl01
         INITIALIZE g_npl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t150_nmd(p_nmd01)
   DEFINE p_nmd01      LIKE nmd_file.nmd01
   DEFINE p_key        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmd        RECORD LIKE nmd_file.*
   DEFINE l_nmd21      LIKE nmd_file.nmd21    #No.FUN-680107 VARCHAR(4)
   DEFINE l_nmd12      LIKE nmd_file.nmd12
   DEFINE l_nmd31      LIKE nmd_file.nmd31
   DEFINE l_nmdconf    LIKE nmd_file.nmd30    #No.FUN-680107 VARCHAR(1)
   DEFINE l_npm04      LIKE npm_file.npm04    #FUN-CB0045
   
   LET g_errno = ' '
 
   SELECT nmd02,nmd08,nmd24,nmd05,nmd23,nmd231,nmd03,nmd19,nmd04,nmd26,    # No.FUN-680034  add  nmd231
          nmd30,nmd21,nmd12,nmd31
     INTO g_npm[l_ac].nmd02,g_npm[l_ac].nmd08,g_npm[l_ac].nmd24,
          g_npm[l_ac].nmd05,g_npm[l_ac].nmd23,g_npm[l_ac].nmd231,g_npm[l_ac].nmd03,
          g_npm[l_ac].nmd19,g_npm[l_ac].npm04,g_npm[l_ac].npm05,
          l_nmdconf,l_nmd21,l_nmd12,l_nmd31
     FROM nmd_file WHERE nmd01 = p_nmd01 AND nmd12 IN ('X','1','6','8')
#FUN-CB0045--add--str--
   SELECT SUM(npm04) INTO l_npm04 FROM npm_file
    WHERE npm03=p_nmd01 
       AND (npm01<> g_npl.npl01 OR (npm01=g_npl.npl01 AND npm02<>g_npm[l_ac].npm02))
   IF cl_null(l_npm04) THEN LET l_npm04=0 END IF
   LET g_npm[l_ac].npm04=g_npm[l_ac].npm04-l_npm04
   LET g_npm[l_ac].npm05=g_npm[l_ac].npm04*g_npm[l_ac].nmd19
#FUN-CB0045--add--end
   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'anm-026'
        WHEN l_nmdconf='N'          LET g_errno = 'aap-717'
        WHEN l_nmdconf='X'          LET g_errno = '9024'
        WHEN l_nmd21 != g_npl.npl04 LET g_errno = 'axr-144'
        WHEN g_npl.npl03 = '7' AND l_nmd12 !='8' #票況不為8.兌現之支票不可做退票   #MOD-870317
                                    LET g_errno = 'anm-028'
        WHEN g_npl.npl03 NOT MATCHES '[9]' AND
                                   l_nmd12 = '6' #票況撤票之支票不可做兌現
                                    LET g_errno = 'anm-957'
        WHEN g_npl.npl03 = '1' AND l_nmd12 NOT MATCHES '[1X]'  #MOD-AC0053             
                                   LET g_errno = 'anm-228'     #MOD-AC0053 
        WHEN g_npl.npl03 = '6' AND l_nmd12 = '8' #票況兌現之支票不可做撤票
                                    LET g_errno = 'anm-940'
        #若為應付電匯款不可做兌現以外的動作
        WHEN l_nmd31 ='98' AND g_npl.npl03 MATCHES '[67]'   #MOD-6C0057
                                    LET g_errno = 'anm-901'
        WHEN cl_null(g_npm[l_ac].nmd02)    #MOD-5A0204
                                    LET g_errno = 'anm-031'   #MOD-5A0204
 
        WHEN g_npl.npl03 = '8'
             IF l_nmd12 = '8' THEN
                LET g_errno = 'anm-955'
             END IF
             IF g_npl.npl02 < g_npm[l_ac].nmd05 THEN 
                LET g_errno = 'anm-158' 
             END IF     
        WHEN g_npl.npl03 = '9' AND l_nmd12 = '8' #票況兌現之支票不可做作廢  #MOD-940044 add
                                   LET g_errno = 'anm-967'   #MOD-940044 add
 
        OTHERWISE    LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF g_npl.npl03 = '1' THEN                                                                                                        
      IF l_nmd12 ='X' THEN                                                                                                          
         IF NOT cl_confirm('anm-968') THEN                                                                                          
            LET g_errno = 'anm-002'                                                                                                 
         END IF                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
 
  #IF NOT cl_null(g_errno) THEN                                #TQC-B10225 mark
   IF NOT cl_null(g_errno) AND g_action_choice <> "void" THEN  #TQC-B10225
      INITIALIZE g_npm[l_ac].* TO NULL
   END IF
 
END FUNCTION
 
FUNCTION t150_chkag(p_aag01,p_flag)
   DEFINE p_aag01      LIKE aag_file.aag01    #No.FUN-680107 VARCHAR(24)
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_aag03      LIKE aag_file.aag03
   DEFINE l_aag07      LIKE aag_file.aag07
   DEFINE l_acti       LIKE aag_file.aagacti  #No.FUN-680107 VARCHAR(1)
   DEFINE p_flag       LIKE type_file.chr1       #No.FUN-730032
   DEFINE l_bookno     LIKE aza_file.aza81       #No.FUN-730032
   
   LET g_errno = ' '
   CALL s_get_bookno(YEAR(g_npl.npl02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
   END IF
   IF p_flag = '0' THEN
      LET l_bookno = g_bookno1
   ELSE
      LET l_bookno = g_bookno2
   END IF
 
   SELECT aag02,aag03,aag07,aagacti INTO l_aag02,l_aag03,l_aag07,l_acti
     FROM aag_file WHERE aag01 = p_aag01
      AND aag00 = l_bookno       #No.FUN-730032
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
        WHEN l_acti  ='N'         LET g_errno = '9028'
        WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
        WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
 
END FUNCTION
 
FUNCTION t150_bu()
 
   SELECT SUM(npm04),SUM(npm05),SUM(npm06)
     INTO g_npl.npl10,g_npl.npl11,g_npl.npl12 FROM npm_file
    WHERE npm01=g_npl.npl01
 
   IF cl_null(g_npl.npl10) THEN
      LET g_npl.npl10 = 0
   END IF
 
   IF cl_null(g_npl.npl11) THEN
      LET g_npl.npl11 = 0
   END IF
 
   IF cl_null(g_npl.npl12) THEN
      LET g_npl.npl12 = 0
   END IF
 
   UPDATE npl_file SET npl10=g_npl.npl10,
                       npl11=g_npl.npl11,
                       npl12=g_npl.npl12
    WHERE npl01=g_npl.npl01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('upd npl23,06:',STATUS,1)
      RETURN
   END IF
 
   IF g_npl.npl05 = 1 OR g_npl.npl03 = 1 THEN        #MOD-C80205 add
      LET g_amtdiff = 0                              #MOD-C80205 add
   ELSE                                              #MOD-C80205 add
      LET g_amtdiff = g_npl.npl11 - g_npl.npl12
   END IF                                            #MOD-C80205 add
   DISPLAY BY NAME g_npl.npl10,g_npl.npl11,g_npl.npl12
   DISPLAY g_amtdiff TO amt
 
END FUNCTION
 
FUNCTION t150_baskey()
DEFINE l_wc2           STRING #No.FUN-680107 VARCHAR(200) #MOD-BB0301 mod 1000 -> STRING
 
   CONSTRUCT g_wc1 ON npm02,npm03,npm04,npm05,npm06
                      ,npmud01,npmud02,npmud03,npmud04,npmud05
                      ,npmud06,npmud07,npmud08,npmud09,npmud10
                      ,npmud11,npmud12,npmud13,npmud14,npmud15
                 FROM s_npm[1].npm02,s_npm[1].npm03,
                      s_npm[1].npm04,s_npm[1].npm05,s_npm[1].npm06
                      ,s_npm[1].npmud01,s_npm[1].npmud02,s_npm[1].npmud03
                      ,s_npm[1].npmud04,s_npm[1].npmud05,s_npm[1].npmud06
                      ,s_npm[1].npmud07,s_npm[1].npmud08,s_npm[1].npmud09
                      ,s_npm[1].npmud10,s_npm[1].npmud11,s_npm[1].npmud12
                      ,s_npm[1].npmud13,s_npm[1].npmud14,s_npm[1].npmud15
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
 
   CALL t150_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t150_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING #No.FUN-680107 VARCHAR(300) #MOD-BB0301 mod 1000 -> STRING
 
   LET g_sql = "SELECT npm02,npm03,nmd02,nmd08,nmd24,nmd03,nmd23,nmd231,nmd05,nmd19,",     # No.FUN-680034   add  nmd231
               "       npm09,npm04,npm05,npm06,npm05-npm06, ",  #FUN-CB0045 add npm09
               "       npmud01,npmud02,npmud03,npmud04,npmud05,",
               "       npmud06,npmud07,npmud08,npmud09,npmud10,",
               "       npmud11,npmud12,npmud13,npmud14,npmud15 ", 
               " FROM npm_file LEFT JOIN  nmd_file ON npm03 = nmd_file.nmd01 ",
               " WHERE npm01 ='",g_npl.npl01,"'",        #單頭
               " AND ",p_wc2 CLIPPED,
               " ORDER BY 1"
 
   PREPARE t150_pb FROM g_sql
   DECLARE npm_curs CURSOR FOR t150_pb
 
   CALL g_npm.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH npm_curs INTO g_npm[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      IF g_npl.npl05 = 1 OR g_npl.npl03 = 1 THEN        #MOD-C80205 add
         LET g_npm[g_cnt].npmdiff = 0                   #MOD-C80205 add
      END IF                                            #MOD-C80205 add
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_npm.deleteElement(g_cnt)   #取消 Array Element
 
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npm TO s_npm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.TQC-B40183
 
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
         CALL t150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         IF g_npl.nplconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_npl.nplconf,"","","",g_void,"")
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

      #FUN-D20035---add--str
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end 

#@    ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
#@    ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #No.TQC-BB0070  --Begin
      #ON ACTION entry_sheet1
      #   LET g_action_choice="entry_sheet1"
      #   EXIT DISPLAY
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #No.TQC-BB0070  --End  
 
#@    ON ACTION 傳票拋轉
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
    
#@    ON ACTION 傳票拋轉還原
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
 
#@    ON ACTION 應撤/退/作廢票立帳
      ON ACTION ent_note_wtdw_ret_ac
         LET g_action_choice="ent_note_wtdw_ret_ac"
         EXIT DISPLAY
 
#@    ON ACTION 應撤/退/作廢票立帳還原
      ON ACTION ent_note_wtdw_ret_ac_rtn
         LET g_action_choice="ent_note_wtdw_ret_ac_rtn"
         EXIT DISPLAY
 
#@    ON ACTION 撤退票串查應付                                       
      ON ACTION qry_misc_ap                 
         LET g_action_choice="qry_misc_ap"
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
         EXIT DISPLAY    #TQC-5B0076
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
      AFTER DISPLAY
         CONTINUE DISPLAY
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t150_b_move_to()
 
   LET g_npm[l_ac].npm02 = b_npm.npm02
   LET g_npm[l_ac].npm03 = b_npm.npm03
   LET g_npm[l_ac].npm04 = b_npm.npm04
   LET g_npm[l_ac].npm05 = b_npm.npm05
   LET g_npm[l_ac].npm06 = b_npm.npm06
   LET g_npm[l_ac].npm09 = b_npm.npm09    #FUN-CB0045
   LET g_npm[l_ac].npmud01 = b_npm.npmud01
   LET g_npm[l_ac].npmud02 = b_npm.npmud02
   LET g_npm[l_ac].npmud03 = b_npm.npmud03
   LET g_npm[l_ac].npmud04 = b_npm.npmud04
   LET g_npm[l_ac].npmud05 = b_npm.npmud05
   LET g_npm[l_ac].npmud06 = b_npm.npmud06
   LET g_npm[l_ac].npmud07 = b_npm.npmud07
   LET g_npm[l_ac].npmud08 = b_npm.npmud08
   LET g_npm[l_ac].npmud09 = b_npm.npmud09
   LET g_npm[l_ac].npmud10 = b_npm.npmud10
   LET g_npm[l_ac].npmud11 = b_npm.npmud11
   LET g_npm[l_ac].npmud12 = b_npm.npmud12
   LET g_npm[l_ac].npmud13 = b_npm.npmud13
   LET g_npm[l_ac].npmud14 = b_npm.npmud14
   LET g_npm[l_ac].npmud15 = b_npm.npmud15
 
END FUNCTION
 
FUNCTION t150_b_move_back()
 
   LET b_npm.npm01 = g_npl.npl01
   LET b_npm.npm02 = g_npm[l_ac].npm02
   LET b_npm.npm03 = g_npm[l_ac].npm03
   LET b_npm.npm04 = g_npm[l_ac].npm04
   LET b_npm.npm05 = g_npm[l_ac].npm05
   LET b_npm.npm06 = g_npm[l_ac].npm06
   LET b_npm.npm09 = g_npm[l_ac].npm09    #FUN-CB0045
   LET b_npm.npmud01 = g_npm[l_ac].npmud01
   LET b_npm.npmud02 = g_npm[l_ac].npmud02
   LET b_npm.npmud03 = g_npm[l_ac].npmud03
   LET b_npm.npmud04 = g_npm[l_ac].npmud04
   LET b_npm.npmud05 = g_npm[l_ac].npmud05
   LET b_npm.npmud06 = g_npm[l_ac].npmud06
   LET b_npm.npmud07 = g_npm[l_ac].npmud07
   LET b_npm.npmud08 = g_npm[l_ac].npmud08
   LET b_npm.npmud09 = g_npm[l_ac].npmud09
   LET b_npm.npmud10 = g_npm[l_ac].npmud10
   LET b_npm.npmud11 = g_npm[l_ac].npmud11
   LET b_npm.npmud12 = g_npm[l_ac].npmud12
   LET b_npm.npmud13 = g_npm[l_ac].npmud13
   LET b_npm.npmud14 = g_npm[l_ac].npmud14
   LET b_npm.npmud15 = g_npm[l_ac].npmud15
   SELECT nmd12,nmd13 INTO b_npm.npm07,b_npm.npm08 FROM nmd_file
    WHERE nmd01=b_npm.npm03
 
   LET b_npm.npmlegal = g_legal 
 
END FUNCTION
 
FUNCTION t150_u()
    DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
           l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_npl.npl01) THEN
       CALL cl_err('',-400,2)
       RETURN
    END IF
 
    SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
 
    IF g_npl.nplconf='Y' THEN
       CALL cl_err(g_npl.npl01,'anm-105',2)
       RETURN
    END IF
 
    IF g_npl.nplconf='X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
 
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t150_cl USING g_npl.npl01
    IF STATUS THEN
       CALL cl_err("OPEN t150_cl:", STATUS, 1)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t150_cl INTO g_npl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    LET g_npl_o.* = g_npl.*
    LET g_npl_t.* = g_npl.*
 
    CALL t150_show()
 
    IF g_success = 'N' THEN
       LET g_npl.* = g_npl_t.*
       CALL t150_show()
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t150_i('u')
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_npl.* = g_npl_t.*
       CALL t150_show()
       ROLLBACK WORK
       RETURN
    END IF
 
    UPDATE npl_file SET * = g_npl.* WHERE npl01 = g_npl_t.npl01
    IF STATUS THEN
       CALL cl_err('up npl',STATUS,1)
       LET g_success = 'N'
    END IF
 
    IF g_npl.npl02 != g_npl_t.npl02 THEN            # 更改單號
       UPDATE npp_file SET npp02=g_npl.npl02
        WHERE npp01=g_npl.npl01 AND npp00=1 AND npp011=g_npl.npl03
          AND nppsys = 'NM'
       IF STATUS THEN
          CALL cl_err('upd npp02:',STATUS,1)
       END IF
    END IF
 
    CALL t150_show()
 
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_npl.npl01,'U')
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t150_npp02( p_npptype )                  # No.FUN-680034
DEFINE p_npptype    LIKE npp_file.npptype         # No.FUN-680034 
DEFINE l_npl03      LIKE type_file.num5            #TQC-AB0025 add
  LET l_npl03 = g_npl.npl03    #TQC-AB0025 add 
  IF g_npl.npl09 IS NULL OR g_npl.npl09=' ' THEN
     UPDATE npp_file SET npp02=g_npl.npl02
#     WHERE npp01=g_npl.npl01 AND npp00=1 AND npp011=g_npl.npl03 #TQC-AB0025 mark
      WHERE npp01=g_npl.npl01 AND npp00=1 AND npp011=l_npl03     #TQC-AB0025 add
        AND nppsys = 'NM' AND npptype = p_npptype     # No.FUN-680034   add "AND npptype=p_npptypr"
     IF STATUS THEN CALL cl_err('upd npp02:',STATUS,1) END IF
  END IF
END FUNCTION
 
FUNCTION t150_r()
   DEFINE l_year,l_month  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_flag          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_npl03         LIKE type_file.num5    #TQC-AB0025 add
  
   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_npl.npl01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
   IF g_npl.nplconf='Y' THEN CALL cl_err(g_npl.npl01,'anm-105',2) RETURN END IF
   IF g_npl.nplconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   LET g_success = 'Y'
   LET l_npl03 = g_npl.npl03   #TQC-AB0025 add
   BEGIN WORK
 
   OPEN t150_cl USING g_npl.npl01
   IF STATUS THEN
      CALL cl_err("OPEN t150_cl:", STATUS, 1)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t150_cl INTO g_npl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_npl_o.* = g_npl.*
   LET g_npl_t.* = g_npl.*
   IF cl_null(g_wc1) THEN LET g_wc1='1=1' END IF    #No:8412
   CALL t150_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "npl01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_npl.npl01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM npp_file
       WHERE nppsys = 'NM' AND npp00=1 AND npp01 = g_npl.npl01
#         AND npp011=g_npl.npl03   #TQC-AB0025 mark
          AND npp011=l_npl03       #TQC-AB0025 add
      IF SQLCA.sqlcode THEN
         CALL cl_err('(t150_r:delete npp)',SQLCA.sqlcode,1) LET g_success='N'
      END IF
      DELETE FROM npq_file
       WHERE npqsys = 'NM' AND npq00=1 AND npq01 = g_npl.npl01
#        AND npq011=g_npl.npl03 #TQC-AB0025 mark
         AND npq011=l_npl03     #TQC-AB0025 add
      IF SQLCA.sqlcode THEN
         CALL cl_err('(t150_r:delete npq)',SQLCA.sqlcode,1) LET g_success='N'
      END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_npl.npl01
      IF SQLCA.sqlcode THEN
         CALL cl_err('(t150_r:delete tic)',SQLCA.sqlcode,1) 
         LET g_success='N'
      END IF
      #FUN-B40056--add--end--

      DELETE FROM npm_file WHERE npm01 = g_npl.npl01
      IF SQLCA.sqlcode THEN
         CALL cl_err('(t150_r:delete npm)',SQLCA.sqlcode,1) LET g_success='N'
      END IF
      DELETE FROM npl_file WHERE npl01 = g_npl.npl01
      IF SQLCA.sqlcode THEN
         CALL cl_err('(t150_r:delete npl)',SQLCA.sqlcode,1) LET g_success='N'
      END IF
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal 
                   VALUES ('anmt150',g_user,g_today,g_msg,g_npl.npl02,'Delete',g_plant,g_legal)
      INITIALIZE g_npl.* TO NULL
      IF g_success = 'Y' THEN
        #COMMIT WORK   #MOD-C60017 mark
         LET g_npl_t.* = g_npl.*
         CALL cl_flow_notify(g_npl.npl01,'D')
         OPEN t150_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t150_cs
            CLOSE t150_count
            COMMIT WORK   
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t150_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t150_cs
            CLOSE t150_count
            COMMIT WORK  
            DISPLAY g_row_count TO FORMONLY.cnt   #No.MOD-C70025
            CALL t150_show()    #No.MOD-C70025
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t150_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t150_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t150_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_npl.* = g_npl_t.*
      END IF
   END IF
   CALL t150_show()
END FUNCTION
 
#FUNCTION t150_x()                                    #FUN-D20035
FUNCTION t150_x(p_type)                               #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1               #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1               #FUN-D20035
   DEFINE
       l_chr   LIKE type_file.chr1,                   #No.FUN-680107 VARCHAR(1)
       l_npl02 LIKE npl_file.npl02,                   #MOD-5A0287
       l_npl03 DYNAMIC ARRAY OF LIKE npl_file.npl03,  #MOD-5A0287
       l_cnt   LIKE type_file.num5,                   #MOD-5A0287  #No.FUN-680107 SMALLINT
       l_cnt2  LIKE type_file.num5,                   #MOD-5A0287  #No.FUN-680107 SMALLINT
       l_count LIKE type_file.num5                    #No.FUN-680107 SMALLINT #MOD-5A0287
 
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_npl.npl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
   IF g_npl.nplconf='Y' THEN CALL cl_err('','anm-139',1)  RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_npl.nplconf ='X' THEN RETURN END IF
   ELSE
      IF g_npl.nplconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t150_cl USING g_npl.npl01
   IF STATUS THEN
      CALL cl_err("OPEN t150_cl:", STATUS, 1)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t150_cl INTO g_npl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t150_show()
  #IF cl_void(0,0,g_npl.nplconf) THEN              #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
     #IF g_npl.nplconf='N' THEN    #切換為作廢                         #FUN-D20035
      IF p_type = 1 THEN                                               #FUN-D20035
         DELETE FROM npp_file
          WHERE nppsys = 'NM' AND npp00=1 AND npp01 = g_npl.npl01
            AND npp011=g_npl.npl03
         IF SQLCA.sqlcode THEN
            CALL cl_err('(t150_r:delete npp)',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys = 'NM' AND npq00=1 AND npq01 = g_npl.npl01
            AND npq011=g_npl.npl03
         IF SQLCA.sqlcode THEN
            CALL cl_err('(t150_r:delete npq)',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_npl.npl01
         IF SQLCA.sqlcode THEN
            CALL cl_err('(t150_r:delete tic)',SQLCA.sqlcode,1) 
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--

         LET g_npl.nplconf='X'
      ELSE                       #取消作廢
        LET l_cnt = 1
        FOREACH npm_curs INTO g_npm[l_cnt].*
          #-TQC-B10225-add-
           CALL t150_nmd(g_npm[l_cnt].npm03)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_npm[l_cnt].npm03,g_errno,0)
              RETURN
           END IF
          #check同一張異動,不允許有相同的開票單 
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file 
            WHERE npl01 = npm01 AND npm03 = g_npm[l_cnt].npm03
              AND npl01 = g_npl.npl01 AND npm02 != g_npm[l_cnt].npm02
           IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
           IF g_cnt > 0 THEN
              CALL cl_err(g_npm[l_cnt].npm03,'anm-219',0)
              RETURN
           END IF
          #check是否重覆開立 
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file 
            WHERE npl01 = npm01 AND npm03 = g_npm[l_cnt].npm03
             #AND nplconf='N'                      #MOD-C40041 mark 
              AND npl01 <> g_npl.npl01
              AND npl03 = g_npl.npl03              #MOD-C40041 add
             #AND nplconf = 'Y'                    #MOD-C40041 add #MOD-D30035 mark
              AND nplconf <> 'X'                   #MOD-D30035 add
           IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
           IF g_cnt > 0 THEN
              CALL cl_err(g_npm[l_cnt].npm03,'anm-220',0)
              RETURN
           END IF
          #-TQC-B10225-end-
           SELECT MAX(npl02) INTO l_npl02 FROM npl_file,npm_file
              WHERE npl01 = npm01 
                AND npm03 = g_npm[l_cnt].npm03
                AND nplconf <> 'X'                   #MOD-D30035 add
 
           IF g_npl.npl02 < l_npl02 THEN
              CALL cl_err(g_npm[l_cnt].npm03,'anm-033',0)
              RETURN
           ELSE
              DECLARE npl03_c CURSOR FOR
                 SELECT npl03 FROM npl_file,npm_file
                    WHERE npl01 = npm01 AND npm03 = g_npm[l_cnt].npm03 
                      AND npl02 = l_npl02
                      AND nplconf <> 'X'                   #MOD-D30035 add
              LET l_cnt2 = 1
              FOREACH npl03_c INTO l_npl03[l_cnt2]
                 IF g_npl.npl03 < l_npl03[l_cnt2] THEN
                    CALL cl_err(g_npm[l_cnt].npm03,'anm-033',0)
                    RETURN
                 END IF
                 IF g_npl.npl03 = l_npl03[l_cnt2] THEN
                    LET l_count = 0
                    SELECT COUNT(*) INTO l_count FROM npl_file,npm_file
                       WHERE npl01 = npm01 AND npl02 = l_npl02 
                         AND npl03 = l_npl03[l_cnt2] 
                         AND npm03 = g_npm[l_cnt].npm03
                         AND nplconf <> 'X'                   #MOD-D30035 add
                    IF l_count > 1 THEN
                       CALL cl_err(g_npm[l_cnt].npm03,'anm-034',0)
                       RETURN
                    END IF
                 END IF
                 LET l_cnt2 = l_cnt2 + 1
              END FOREACH
           END IF
           LET l_cnt = l_cnt + 1
        END FOREACH
         LET g_npl.nplconf='N'
      END IF
      UPDATE npl_file SET nplconf = g_npl.nplconf
       WHERE npl01 = g_npl.npl01
      IF STATUS THEN CALL cl_err('',STATUS,0) LET g_success='N' END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('','aap-161',0) LET g_success='N'
      END IF
   END IF
   SELECT nplconf INTO g_npl.nplconf FROM npl_file
    WHERE npl01 = g_npl.npl01
   DISPLAY BY NAME g_npl.nplconf
   CLOSE t150_cl
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_npl.npl01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t150_v(p_cmd)
   DEFINE l_wc      STRING #No.FUN-680107 VARCHAR(101) #MOD-BB0301 mod 1000 -> STRING
   DEFINE p_cmd     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(02)
   DEFINE l_npl     RECORD LIKE npl_file.*
   DEFINE only_one  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_t1      LIKE nmy_file.nmyslip  #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3  #No.FUN-680107 VARCHAR(1)
 
   IF g_npl.nplconf='Y' THEN
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t150_cl USING g_npl.npl01
   IF STATUS THEN
      CALL cl_err("OPEN t150_cl:", STATUS, 1)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t150_cl INTO g_npl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      CLOSE t150_cl ROLLBACK WORK RETURN ELSE COMMIT WORK
   END IF
   IF p_cmd  = '1' THEN
 
 
      OPEN WINDOW t150_w9 AT 5,11 WITH FORM "anm/42f/anmt1509"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt1509")
 
 
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
         CLOSE WINDOW t150_w9
         RETURN
      END IF
 
      IF only_one = '1' THEN
         SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
         IF g_npl.nplconf='Y' THEN
            CLOSE WINDOW t150_w9
            RETURN
         END IF
 
         IF g_npl.nplconf='X' THEN
            CALL cl_err('','9024',0)
            CLOSE WINDOW t150_w9
            RETURN
         END IF
 
         LET l_wc = " npl01 = '",g_npl.npl01,"' "
      ELSE
         CONSTRUCT BY NAME l_wc ON npl01,npl02
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
            CLOSE WINDOW t150_w9
            RETURN
         END IF
      END IF
      CLOSE WINDOW t150_w9
   ELSE
      LET l_wc = " npl01 = '",g_npl.npl01,"' "
   END IF
   LET l_npl.* = g_npl.*   # backup old value
   MESSAGE "WORKING !"
   LET g_sql = "SELECT * FROM npl_file WHERE nplconf <> 'X' AND ",l_wc CLIPPED,
               " ORDER BY npl01"
   PREPARE t150_v_p FROM g_sql
   DECLARE t150_v_c CURSOR WITH HOLD FOR t150_v_p
   LET g_success='Y'
   BEGIN WORK
   CALL s_showmsg_init()   #No.FUN-710024
   FOREACH t150_v_c INTO g_npl.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF             
      IF g_npl.npl02 <= g_nmz.nmz10 THEN   #立帳日期小於關帳日期 no.5261
         CALL s_errmsg('','',g_npl.npl01,'aap-176',0)
         CONTINUE FOREACH
      END IF
      LET l_t1 = s_get_doc_no(g_npl.npl01)       #No.FUN-550057
      LET l_nmydmy3 = ''
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('nmyslip',l_t1,'sel nmy',STATUS,0)
      END IF
      IF l_nmydmy3 = 'Y' THEN   #是否拋轉傳票
         IF NOT cl_null(g_npl.npl09) THEN
            CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
            MESSAGE g_npl.npl01,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         IF g_npl.nplconf='Y' THEN
            CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
            MESSAGE g_npl.npl01,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         CALL s_t150_gl(g_npl.npl01,'0')
        IF g_aza.aza63 = 'Y'AND g_success = 'Y' THEN
         CALL s_t150_gl(g_npl.npl01,'1')  
        END IF
     END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   LET g_npl.*=l_npl.*
   MESSAGE " "
END FUNCTION
 
FUNCTION t150_firm1()
   DEFINE l_npl01_old LIKE npl_file.npl01
   DEFINE only_one    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
   DEFINE l_npp       RECORD LIKE npp_file.*   #NO.MOD-640077
   DEFINE l_n         LIKE type_file.num5      #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_npm03     LIKE npm_file.npm03
   DEFINE l_nmd05     LIKE nmd_file.nmd05
   DEFINE l_sql       STRING
   DEFINE l_sql_1     STRING
   DEFINE l_cnt       LIKE type_file.num5     #MOD-C80141 add
 
   IF cl_null(g_npl.npl01) THEN RETURN END IF
#CHI-C30107 ---------- add ----------- begin
   IF g_npl.nplconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npl.nplconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ---------- add ----------- end
   SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = g_npl.npl01
   IF g_npl.nplconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npl.nplconf='Y' THEN 
      CALL cl_err('','9023',0)
      RETURN 
   END IF
   LET g_success = 'Y'   #TQC-C50224  add
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_npl.npl02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_npl.npl01,'aap-176',1) 
      RETURN 
   END IF
   #沒有單身資料,不可確認
   SELECT COUNT(*) INTO g_cnt FROM npm_file
    WHERE npm01 = g_npl.npl01
   IF g_cnt = 0 THEN 
      RETURN 
   END IF

  LET l_sql = "SELECT npm03 FROM npm_file where npm01 = '",g_npl.npl01,"'"
  LET l_sql_1 = "SELECT nmd05 FROM nmd_file WHERE nmd01 = ?"
  PREPARE npm03_pre FROM l_sql
  DECLARE npm03_cus CURSOR FOR npm03_pre
  
  PREPARE nmd05_pre FROM l_sql_1
  DECLARE nmd05_cus CURSOR FOR nmd05_pre  
  
  FOREACH npm03_cus INTO l_npm03
    IF STATUS THEN 
       CALL cl_err('',STATUS,1)
       LET g_success  = 'N'
       EXIT FOREACH 
    END IF    
 
    FOREACH nmd05_cus USING l_npm03 INTO l_nmd05 
       IF STATUS THEN
          CALL cl_err('',STATUS,1)
          LET g_success  = 'N'
          EXIT FOREACH           
       END IF 
       
       IF g_npl.npl02 < l_nmd05 AND
         #g_npl.npl03 <> '9' THEN     #MOD-A60020 add    #MOD-A90052 mark
          g_npl.npl03 = '8' THEN                         #MOD-A90052
          CALL cl_err('','anm-158',1)
          LET g_success = 'N'
          EXIT FOREACH 
       END IF 
    END FOREACH 
    
    IF g_success = 'N' THEN 
       EXIT FOREACH
    END IF    
 
  END FOREACH 
  
  IF g_success = 'N' THEN 
     RETURN 
  END IF 
   
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   CALL s_get_doc_no(g_npl.npl01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
   SELECT COUNT(*) INTO l_cnt FROM npq_file     #MOD-C80141 add
    WHERE npq01 = g_npl.npl01                   #MOD-C80141 add
   IF l_cnt =  0 THEN                           #MOD-C80141 add
      CALL t150_v(1)  #TQC-C50224  add
   END IF                                       #MOD-C80141 add   
   IF cl_null(g_nmy.nmyglcr) THEN LET g_nmy.nmyglcr = 'N' END IF
   CALL s_get_bookno(YEAR(g_npl.npl02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN
       CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'0',g_bookno1)       #No.FUN-730032
     IF g_aza.aza63 = 'Y' THEN
       CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'1',g_bookno2)       #No.FUN-730032
     END IF  
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_success='Y'
   LET l_npl01_old=g_npl.npl01    # backup old key value npl01
   BEGIN WORK
   OPEN t150_cl USING g_npl.npl01
   IF STATUS THEN
      CALL cl_err("OPEN t150_cl:", STATUS, 1)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t150_cl INTO g_npl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      CLOSE t150_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #是否已經有分錄底稿
 
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys= 'NM'
         AND npq00=1
         AND npq01 = g_npl.npl01
         AND npq011=g_npl.npl03 
 
      CALL s_showmsg_init()   #No.FUN-710024
      IF l_n = 0 THEN
         CALL t150_gen_glcr(g_npl.*,g_nmy.*)
      END IF
     IF g_success = 'Y' THEN 
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'0',g_bookno1)       #No.FUN-730032
    IF g_aza.aza63 = 'Y' THEN
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'1',g_bookno2)       #No.FUN-730032
    END IF
   END IF     
 
   END IF
   IF g_success='Y' THEN     #No:8608
      CALL t150_y1()
   END IF
   IF g_success='N' THEN 
      CALL s_showmsg()          #No.FUN-710024
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN 
   END IF
   UPDATE npl_file SET nplconf = 'Y' WHERE npl01 = g_npl.npl01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('npl01',g_npl.npl01,'upd nplconf',STATUS,1)
      CALL s_showmsg()          #No.FUN-710024
      SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   ELSE
      CALL s_showmsg()          #No.FUN-710024
      CLOSE t150_cl
      COMMIT WORK
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_npl.npl01,'" AND npp011 = ',g_npl.npl03
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
                " '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' ",                                #No.FUN-680034
                " '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_npl.npl02,"' 'Y' '1' 'Y'"   #No.FUN-680034#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT npl09 INTO g_npl.npl09 FROM npl_file
       WHERE npl01 = g_npl.npl01
      DISPLAY BY NAME g_npl.npl09
   END IF
 
 
   CALL cl_cmmsg(1)
   CALL cl_flow_notify(g_npl.npl01,'Y')
   SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
   DISPLAY BY NAME g_npl.nplconf
   CALL cl_set_field_pic(g_npl.nplconf,"","","","N","")  #MOD-AC0073
END FUNCTION
 
FUNCTION t150_y1()
  DEFINE l_nma21   LIKE nma_file.nma21
  DEFINE l_nnh01   LIKE nnh_file.nnh01
  DEFINE l_nnf01   LIKE nnf_file.nnf01
  DEFINE l_blue    LIKE type_file.num5    #No.FUN-680107 SMALLINT #modi by kitty
 
  DECLARE t150_ics2 CURSOR  WITH HOLD FOR
       SELECT * FROM npm_file WHERE npm01 = g_npl.npl01 ORDER BY npm02
  MESSAGE g_npl.npl01
  FOREACH t150_ics2 INTO m_npm.*
     IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg('npm01',g_npl.npl01,'foreach #2',status,1)
        ELSE
           CALL cl_err('foreach #2',status,2) 
        END IF
        LET g_success='N' EXIT FOREACH    #No:8608
     END IF
     IF cl_null(m_npm.npm03) THEN CONTINUE FOREACH END IF
     SELECT * INTO g_nmd.* FROM nmd_file
      WHERE nmd01=m_npm.npm03 AND nmd30 = 'Y'
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg('nmd01',m_npm.npm03,'nmd30','anm-231',1)
        ELSE
           CALL cl_err('nmd30','anm-231',1)
        END IF
        LET g_success='N'
        EXIT FOREACH
     END IF
     IF g_nmd.nmd02 IS NULL THEN   #支票號碼為空白,不可作任何異動
        IF g_bgerr THEN
           CALL s_errmsg('','',g_nmd.nmd01,'anm-238',1)
        ELSE
           CALL cl_err(g_nmd.nmd01,'anm-238',1)
        END IF
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     IF g_npl.npl03 MATCHES '[789]' THEN
        LET l_nma21 = null
        SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = g_nmd.nmd03
        IF l_nma21 IS NOT NULL AND l_nma21 >= g_npl.npl02 THEN #MOD-980093 add =  
        IF g_bgerr THEN
           CALL s_errmsg('','',g_nmd.nmd03,'anm-225',1)
        ELSE
           CALL cl_err(g_nmd.nmd03,'anm-225',1)
        END IF
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END IF
     IF g_npl.npl03='8' OR (g_npl.npl03 = '7' AND m_npm.npm07 = '8') OR
        (g_npl.npl03 = '9' AND m_npm.npm07 = '8') THEN
        CALL t150_ins_nme()
        LET l_nnh01 = ' '
        DECLARE nnh_curs CURSOR FOR
         SELECT UNIQUE nnh01
           FROM nnh_file WHERE nnh06 = m_npm.npm03
        FOREACH nnh_curs INTO l_nnh01
           IF g_npl.npl03='8' THEN   #MOD-9B0027 add
              #兌現時應增加已還金額
              uPDATE nng_file SET nng21 = nng21 + m_npm.npm04,
                                  nng23 = nng23 + m_npm.npm05
               WHERE nng01 = l_nnh01 AND nngconf = 'Y'
           ELSE
              #退票或作廢時應減少已還金額
              UPDATE nng_file SET nng21 = nng21 - m_npm.npm04,
                                  nng23 = nng23 - m_npm.npm05
               WHERE nng01 = l_nnh01 AND nngconf = 'Y'
           END IF
        END FOREACH
        #短期融資
        LET l_nnf01 = ' '
        DECLARE nnf_curs CURSOR FOR
         SELECT UNIQUE nnf01
           FROM nnf_file WHERE nnf06 = m_npm.npm03   #MOD-720066
        FOREACH nnf_curs INTO l_nnf01
           LET l_blue = 0
           IF g_nmd.nmd51 = '1' OR g_nmd.nmd51 = '2' THEN
              IF g_npl.npl03='8' THEN   #MOD-9B0027 add
                 #兌現時應增加已還金額
                 UPDATE nne_file SET nne27 = nne27 + m_npm.npm04,
                                     nne20 = nne20 + m_npm.npm05,
                                     nne21 = g_npl.npl02,
                                     nne26 = g_npl.npl02
                  WHERE nne01 = l_nnf01 AND nneconf = 'Y'
              ELSE
                 #退票或作廢時應減少已還金額
                 UPDATE nne_file SET nne27 = nne27 - m_npm.npm04,
                                     nne20 = nne20 - m_npm.npm05,
                                     nne21 = g_npl.npl02,
                                     nne26 = g_npl.npl02
                  WHERE nne01 = l_nnf01 AND nneconf = 'Y'
              END IF
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
              ELSE
                 LET l_blue = l_blue + 1
              END IF
              IF g_npl.npl03='8' THEN   #MOD-9B0027 add
                 #兌現時應增加已還金額
                 UPDATE nng_file SET nng21 = nng21 + m_npm.npm04,
                                     nng23 = nng23 + m_npm.npm05
                  WHERE nng01 = l_nnf01 AND nngconf = 'Y'
              ELSE
                 #退票或作廢時應減少已還金額
                 UPDATE nng_file SET nng21 = nng21 - m_npm.npm04,
                                     nng23 = nng23 - m_npm.npm05
                  WHERE nng01 = l_nnf01 AND nngconf = 'Y'
              END IF
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
              ELSE
                  LET l_blue = l_blue + 1
              END IF
           END IF
           IF g_nmd.nmd51 = '1' OR g_nmd.nmd51 = '2' THEN
              IF l_blue = 0 THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        END FOREACH
     END IF
     IF g_npl.npl03 MATCHES '[56789]' THEN
        CALL t150_ins_nmf()
     END IF
     IF g_npl.npl03 = '9'  THEN   #作廢->資料寫入支票作廢檔
        CALL t150_ins_nnz()
     END IF
     CALL t150_upd_nmd('+')
     IF g_success='N' THEN 
        EXIT FOREACH
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION t150_firm2()
   DEFINE l_npl01_old LIKE npl_file.npl01
   DEFINE only_one    LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       STRING                #No.FUN-670060
 
   IF cl_null(g_npl.npl01) THEN RETURN END IF
   IF g_npl.nplconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_npl.nplconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   LET l_npl01_old=g_npl.npl01    # backup old key value npl01
   LET g_success = 'Y'
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_npl.npl02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_npl.npl01,'aap-176',1) 
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_npl.npl01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_npl.npl09) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_npl.npl01,'anm-230',1)
         LET g_success = 'N'
      ELSE
         LET g_plant_new = g_nmz.nmz02p
         #CALL s_getdbs()    #FUN-A50102
         LET l_sql = "SELECT aba19 ",
                     #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                     " WHERE aba00 = '",g_nmz.nmz02b,"' ",
                     "   AND aba01 = '",g_npl.npl09,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE aba_pre FROM l_sql
         DECLARE aba_cs CURSOR FOR aba_pre
         OPEN aba_cs
         IF SQLCA.sqlcode THEN RETURN END IF
         FETCH aba_cs INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_npl.npl09,'axr-071',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
   IF g_success='N'THEN
      SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
      RETURN
   END IF
   ##1999/11/15 modify 取消確認應擋此票據若已AP立帳應不可取消確認
   SELECT COUNT(*) INTO g_cnt FROM apa_file
    WHERE apa25 = g_npl.npl01 AND apa42 = 'N'
   IF g_cnt > 0 THEN
      CALL cl_err(g_npl.npl01,'anm-280',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   #CHI-C90052 add begin---
   IF NOT cl_null(g_npl.npl09) THEN  #MOD-C40080 add
      IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npl.npl09,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT npl09 INTO g_npl.npl09 FROM npl_file
          WHERE npl01 = g_npl.npl01
         IF NOT cl_null(g_npl.npl09) THEN
            CALL cl_err(g_npl.npl09,'aap-929',1)
            RETURN
         END IF
         DISPLAY BY NAME g_npl.npl09
      END IF
   END IF        #MOD-C40080 add
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t150_cl USING g_npl.npl01
   IF STATUS THEN
      CALL cl_err("OPEN t150_cl:", STATUS, 1)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t150_cl INTO g_npl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
      CLOSE t150_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t150_z1()
   CALL s_showmsg()          #No.FUN-710024
   IF g_success='N'THEN
      SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
      ROLLBACK WORK 
      CLOSE t150_cl
      RETURN
   END IF
   UPDATE npl_file SET nplconf = 'N' WHERE npl01 = g_npl.npl01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd nplconf',STATUS,1)
      SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
      ROLLBACK WORK RETURN
   END IF
   IF g_success='N' THEN
      SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF

   #CHI-C90052 mark begin---
   #IF NOT cl_null(g_npl.npl09) THEN  #MOD-C40080 add
   #   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npl.npl09,"' 'Y'"
   #      CALL cl_cmdrun_wait(g_str)
   #      SELECT npl09 INTO g_npl.npl09 FROM npl_file
   #       WHERE npl01 = g_npl.npl01
   #      DISPLAY BY NAME g_npl.npl09
   #   END IF
   #END IF        #MOD-C40080 add
   #CHI-C90052 mark end-----
 
   SELECT * INTO g_npl.* FROM npl_file WHERE npl01 = l_npl01_old
   DISPLAY g_npl.nplconf TO nplconf
 
END FUNCTION
 
FUNCTION t150_z1()
   DEFINE l_nmd12     LIKE nmd_file.nmd12, #No.FUN-680107 VARCHAR(1)
          l_nnh01     LIKE nnh_file.nnh01,
          l_nnf01     LIKE nnf_file.nnf01
   DEFINE l_nme24     LIKE nme_file.nme24  #No.FUN-730032
 
   DECLARE t150_dcs2 CURSOR  WITH HOLD FOR
        SELECT npm_file.*, nmd12
          FROM npm_file LEFT JOIN nmd_file ON npm03 = nmd_file.nmd01 
         WHERE npm01 = g_npl.npl01
         ORDER BY npm02
   MESSAGE g_npl.npl01
   CALL s_showmsg_init()   #No.FUN-710024
   FOREACH t150_dcs2 INTO m_npm.*, l_nmd12
      IF SQLCA.SQLCODE THEN
	 CALL s_errmsg('npm01',g_npl.npl01,'foreach #2',status,1)
         EXIT FOREACH
      END IF
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF             
      IF cl_null(m_npm.npm03) THEN CONTINUE FOREACH END IF
      IF g_npl.npl03<>l_nmd12 THEN
 	 CALL s_errmsg('','',m_npm.npm02,'anm-228',1)
         LET g_success='N'
         CONTINUE FOREACH 
      END IF
      SELECT COUNT(*) INTO g_cnt FROM npl_file,npm_file
       WHERE npm03 = m_npm.npm03
         AND npm01 = npl01
         AND npl01 <> g_npl.npl01
        #AND nplconf = 'N'                               #MOD-D30035 mark
         AND nplconf <> 'X'                              #MOD-D30035 add
      IF g_cnt > 0 THEN
 	 CALL s_errmsg('','',g_npl.npl01,'anm-653',1)
         LET g_success = 'N'
         CONTINUE FOREACH  
      END IF
      #判斷是否為中長期貸款的支票兌現
      IF g_npl.npl03='8' OR ( g_npl.npl03='7' AND m_npm.npm07='8')
      OR (g_npl.npl03='9' AND m_npm.npm07='8') THEN
         LET l_nnh01 = ' '
         DECLARE nnh_curx CURSOR FOR
          SELECT UNIQUE nnh01 FROM nnh_file WHERE nnh06 = m_npm.npm03
         FOREACH nnh_curx INTO l_nnh01
            IF g_npl.npl03='8' THEN   #MOD-9B0027 add
               #兌現時應增加已還金額
               UPDATE nng_file SET nng21 = nng21 - m_npm.npm04,
                                   nng23 = nng23 - m_npm.npm05
                WHERE nng01 = l_nnh01 AND nngconf = 'Y'
            ELSE
               #退票或作廢時應減少已還金額
               UPDATE nng_file SET nng21 = nng21 + m_npm.npm04,
                                   nng23 = nng23 + m_npm.npm05
                WHERE nng01 = l_nnh01 AND nngconf = 'Y'
            END IF
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('nng01',l_nnh01,'upd nng_file',STATUS,1)     #No.FUN-710024
               LET g_success = 'N' EXIT FOREACH
            END IF
         END FOREACH
         #短期融資
         LET l_nnf01 = ' '
         DECLARE nnf_cursx CURSOR FOR
          SELECT UNIQUE nnf01
            FROM nnf_file WHERE nnf06 = m_npm.npm03
         FOREACH nnf_cursx INTO l_nnf01
            IF g_npl.npl03='8' THEN   #MOD-9B0027 add
               #兌現時應增加已還金額
               UPDATE nne_file SET nne27 = nne27 - m_npm.npm04,
                                   nne20 = nne20 - m_npm.npm05
                WHERE nne01 = l_nnf01 AND nneconf = 'Y'
            ELSE
               #退票或作廢時應減少已還金額
               UPDATE nne_file SET nne27 = nne27 + m_npm.npm04,
                                   nne20 = nne20 + m_npm.npm05
                WHERE nne01 = l_nnf01 AND nneconf = 'Y'
            END IF
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('nne01',l_nnf01,'upd nne_file',STATUS,1)     #No.FUN-710024
               LET g_success = 'N' EXIT FOREACH
            END IF
         END FOREACH
      END IF
      IF g_npl.npl03='8' THEN
         IF NOT cl_null(g_nmz.nmz31) THEN
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03='",g_nmz.nmz31,"'"
               PREPARE nme24_p1 FROM g_sql
               DECLARE nme24_cs1 CURSOR FOR nme24_p1
               FOREACH nme24_cs1 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN
              DELETE FROM tic_file
               WHERE tic04 IN (SELECT nme12 FROM nme_file 
                                WHERE nme12 = g_npl.npl01 
                                  AND nme03 = g_nmz.nmz31
                                  AND nme21 = m_npm.npm02 )
           END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03=g_nmz.nmz31 #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03=g_nmz.nmz31
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin mark
           #FUN-B40056  --Begin
          # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
          #    DELETE FROM tic_file
          #     WHERE tic04 IN (SELECT nme12 FROM nme_file 
          #                      WHERE nme12 = g_npl.npl01 
          #                        AND nme03 = g_nmz.nmz31
          #                        AND nme21 = m_npm.npm02 )
          # END IF
           #FUN-B40056  --End
           #TQC-B70209  --end mark
         ELSE
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03 IS NULL "
               PREPARE nme24_p2 FROM g_sql
               DECLARE nme24_cs2 CURSOR FOR nme24_p2
               FOREACH nme24_cs2 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN
              DELETE FROM tic_file
               WHERE tic04 in 
             (SELECT nme12 FROM nme_file
               WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
                 AND nme21 = m_npm.npm02)
            END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03 IS NULL  #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin mark
           #FUN-B40056  --Begin
          # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
          #    DELETE FROM tic_file
          #     WHERE tic04 in 
          #   (SELECT nme12 FROM nme_file
          #     WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
          #       AND nme21 = m_npm.npm02)
          # END IF
           #FUN-B40056  --End
           #TQC-B70209  --end mark
         END IF
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL s_errmsg('nme12',m_npm.npm03,'del nme',status,1) #MOD-B50085 mark
            CALL s_errmsg('nme12',g_npl.npl01,'del nme',status,1) #MOD-B50085
            LET g_success='N' 
            CONTINUE FOREACH    
         END IF
      END IF
      #兌現後退票
      IF g_npl.npl03='7' AND m_npm.npm07='8' THEN
         IF NOT cl_null(g_nmz.nmz32) THEN
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03='",g_nmz.nmz32,"'"
               PREPARE nme24_p3 FROM g_sql
               DECLARE nme24_cs3 CURSOR FOR nme24_p3
               FOREACH nme24_cs3 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN
              DELETE FROM tic_file
               WHERE tic04 in 
             (SELECT nme12 FROM nme_file
               WHERE nme12 = g_npl.npl01 AND nme03 = g_nmz.nmz32
                 AND nme21 = m_npm.npm02)
            END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03=g_nmz.nmz32 #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03=g_nmz.nmz32
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin mark
           #FUN-B40056  --Begin
          # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
          #    DELETE FROM tic_file
          #     WHERE tic04 in 
          #   (SELECT nme12 FROM nme_file
          #     WHERE nme12 = g_npl.npl01 AND nme03 = g_nmz.nmz32
          #       AND nme21 = m_npm.npm02)
          # END IF
           #FUN-B40056  --End
           #TQC-B70209  --end mark
         ELSE
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03 IS NULL"
               PREPARE nme24_p4 FROM g_sql
               DECLARE nme24_cs4 CURSOR FOR nme24_p4
               FOREACH nme24_cs4 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN
               DELETE FROM tic_file
                WHERE tic04 in 
              (SELECT nme12 FROM nme_file
                WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
                  AND nme21 = m_npm.npm02)
            END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03 IS NULL #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin mark
           #FUN-B40056  --Begin
          # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
          #  DELETE FROM tic_file
          #   WHERE tic04 in 
          # (SELECT nme12 FROM nme_file
          #   WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
          #     AND nme21 = m_npm.npm02)
          # END IF
           #FUN-B40056  --End
           #TQC-B70209  --end  mark
         END IF
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL s_errmsg('nme12',m_npm.npm03,g_npl.npl01,status,1) #MOD-B50085 mark
            CALL s_errmsg('nme12',g_npl.npl01,g_npl.npl01,status,1) #MOD-B50085
            LET g_success='N' 
            CONTINUE FOREACH   
         END IF
      END IF
      #兌現後作廢
      IF g_npl.npl03='9' AND m_npm.npm07='8' THEN
         IF NOT cl_null(g_nmz.nmz32) THEN
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03='",g_nmz.nmz32,"'"
               PREPARE nme24_p5 FROM g_sql
               DECLARE nme24_cs5 CURSOR FOR nme24_p5
               FOREACH nme24_cs5 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
               DELETE FROM tic_file
                WHERE tic04 in 
              (SELECT nme12 FROM nme_file
                WHERE nme12 = g_npl.npl01 AND nme03=g_nmz.nmz32
                  AND nme21 = m_npm.npm02)
            END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03=g_nmz.nmz32 #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03=g_nmz.nmz32
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin  mark
           #FUN-B40056  --Begin
         #  IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
         #   DELETE FROM tic_file
         #    WHERE tic04 in 
         #  (SELECT nme12 FROM nme_file
         #    WHERE nme12 = g_npl.npl01 AND nme03=g_nmz.nmz32
         #      AND nme21 = m_npm.npm02)
         #  END IF
           #FUN-B40056  --End
           #TQC-B70209  --end mark
         ELSE
            IF g_aza.aza73 = 'Y' THEN
               LET g_sql="SELECT nme24 FROM nme_file",
                        #" WHERE nme12='",m_npm.npm03,"'",   #MOD-B50085 mark
                         " WHERE nme12='",g_npl.npl01,"'",   #MOD-B50085
                         "   AND nme21 = '",m_npm.npm02,"'", #MOD-B50085
                         "   AND nme03 IS NULL"
               PREPARE nme24_p6 FROM g_sql
               DECLARE nme24_cs6 CURSOR FOR nme24_p6
               FOREACH nme24_cs6 INTO l_nme24
                  IF l_nme24 != '9' THEN
                     CALL cl_err(m_npm.npm03,'anm-043',1)
                     LET g_success='N'
                     RETURN
                  END IF
               END FOREACH
            END IF
            #TQC-B70209  --begin
            IF g_nmz.nmz70 ='1' THEN
               DELETE FROM tic_file
                WHERE tic04 in 
              (SELECT nme12 FROM nme_file
                WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
                  AND nme21 = m_npm.npm02)
            END IF
            #TQC-B70209  --end
           #DELETE FROM nme_file WHERE nme12 = m_npm.npm03 AND nme03 IS NULL #MOD-B50085 mark
           #-MOD-B50085-add-
            DELETE FROM nme_file 
             WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
               AND nme21 = m_npm.npm02
           #-MOD-B50085-end-
           #TQC-B70209  --begin mark
           #FUN-B40056  --Begin
          # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
          #  DELETE FROM tic_file
          #   WHERE tic04 in 
          # (SELECT nme12 FROM nme_file
          #   WHERE nme12 = g_npl.npl01 AND nme03 IS NULL
          #     AND nme21 = m_npm.npm02)
          # END IF
           #FUN-B40056  --End
           #TQC-B70209  --end  mark
         END IF
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL s_errmsg('nme12',m_npm.npm03,g_npl.npl01,status,1) #MOD-B50085 mark
            CALL s_errmsg('nme12',g_npl.npl01,g_npl.npl01,status,1) #MOD-B50085
            LET g_success='N' 
            CONTINUE FOREACH   
         END IF
      END IF
      IF g_npl.npl03<>'1' THEN
         DELETE FROM nmf_file WHERE nmf01 = m_npm.npm03 AND nmf06=g_npl.npl03
                         AND nmf05=m_npm.npm07
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nmf01',m_npm.npm03,g_npl.npl01,status,1)
            LET g_success='N'  
            CONTINUE FOREACH   
         END IF
      END IF
      IF g_npl.npl03 = '9'  THEN   #作廢
         CALL t150_del_nnz()
         IF g_success='N' THEN 
            CONTINUE FOREACH
         END IF
      END IF
      CALL t150_upd_nmd('-')
      IF g_success='N' THEN 
         CONTINUE FOREACH
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
   END IF 
END FUNCTION
 
FUNCTION t150_ins_nme()
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
   #FUN-CB0045--add--str--取實際付款銀行
   #IF g_aza.aza26='2' AND g_npl.npl03='8' THEN  #MOD-D80148 Mark
   IF g_aza.aza26='2' AND g_npl.npl03='8' AND NOT cl_null(m_npm.npm09) THEN  #MOD-D80148
        LET g_nme.nme01=m_npm.npm09
   ELSE
   #FUN-CB0045--add--end
   LET g_nme.nme01 = g_nmd.nmd03
   END IF  #FUN-CB0045
   IF g_nmz.nmz06 = 'Y' THEN
      LET g_nme.nme02 = g_npl.npl02
   ELSE
      LET g_nme.nme02=' '     #No.FUN-9C0012
   END IF
   IF g_npl.npl03 = '7' OR g_npl.npl03 = '9' THEN  #退票
      SELECT * FROM nmc_file WHERE nmc01=g_nmz.nmz32
      IF STATUS THEN 
         CALL cl_err(g_nmz.nmz32,'anm-024',0)
         LET g_success = 'N'
         RETURN
      END IF
      LET g_nme.nme03 = g_nmz.nmz32
   ELSE
      SELECT * FROM nmc_file WHERE nmc01=g_nmz.nmz31
      IF STATUS THEN 
         CALL cl_err(g_nmz.nmz31,'anm-024',0)
         LET g_success = 'N'
         RETURN
      END IF
      LET g_nme.nme03 = g_nmz.nmz31
   END IF
  #LET g_nme.nme04 = g_nmd.nmd04  #FUN-CB0045 Mark
   LET g_nme.nme04 = m_npm.npm04  #FUN-CB0045 Add
   LET g_nme.nme05 = g_npl.npl08
   LET g_nme.nme06 = g_npl.npl06
  IF g_aza.aza63 = 'Y' THEN  # No.FUN-680034  
   LET g_nme.nme061= g_npl.npl061   # No.FUN-680034
  END IF                  # No.FUN-680034
   LET g_nme.nme07 = g_npl.npl05
   LET g_nme.nme08 = m_npm.npm06
   LET g_nme.nme11 = g_nmd.nmd17
  #LET g_nme.nme12 = m_npm.npm03   #MOD-B50085 mark
   LET g_nme.nme12 = g_npl.npl01   #MOD-B50085
   LET g_nme.nme13 = g_nmd.nmd24
   #No.MOD-C20010  --Begin
   #LET g_nme.nme14 = g_nmd.nmd25
   IF NOT cl_null(g_nmd.nmd25) THEN 
      LET g_nme.nme14 = g_nmd.nmd25
   ELSE 
      SELECT nmc05 INTO g_nme.nme14 FROM nmc_file WHERE nmc01 = g_nme.nme03 
   END IF
   #No.MOD-C20010  --End
   LET g_nme.nme15 = g_nmd.nmd18
   LET g_nme.nme16 = g_npl.npl02
   LET g_nme.nme17 = g_nmd.nmd02
   LET g_nme.nmeacti = 'Y'
   LET g_nme.nmegrup = g_grup
   LET g_nme.nmeuser = g_user
   LET g_nme.nmedate = g_today
   LET g_nme.nme21 = m_npm.npm02
   LET g_nme.nme22 = '10'
   LET g_nme.nme23 = ''
   LET g_nme.nme24 = '9'   #No.TQC-750098
   LET g_nme.nme25 = g_nmd.nmd08
 
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
      CALL s_errmsg('nme02',g_nme.nme02,'t150_ins_nme',SQLCA.sqlcode,1)
      LET g_success = 'N' RETURN
   END IF
   CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062  
END FUNCTION
 
FUNCTION t150_ins_nmf()
   INITIALIZE g_nmf.* TO NULL
   LET g_nmf.nmf01 = g_nmd.nmd01
   LET g_nmf.nmf02 = g_npl.npl02
   SELECT MAX(nmf03) INTO g_nmf.nmf03 FROM nmf_file
    WHERE nmf01=g_nmd.nmd01
   IF cl_null(g_nmf.nmf03) THEN LET g_nmf.nmf03=0 END IF
   LET g_nmf.nmf03=g_nmf.nmf03+1
   LET g_nmf.nmf04 = g_user
   LET g_nmf.nmf05 = g_nmd.nmd12
   LET g_nmf.nmf06 = g_npl.npl03
   LET g_nmf.nmf07 = g_nmd.nmd08
   LET g_nmf.nmf08 = g_nmd.nmd19
   LET g_nmf.nmf09 = g_npl.npl05
   LET g_nmf.nmf12 = g_npl.npl01  #摘要
   LET g_nmf.nmf11 = NULL         #傳票編號
   LET g_nmf.nmf13 = NULL         #傳票日期
 
   LET g_nmf.nmflegal = g_legal 
 
   INSERT INTO nmf_file VALUES(g_nmf.*)
   IF SQLCA.sqlcode THEN
      LET g_showmsg=g_nmf.nmf01,"/",g_nmf.nmf03 
      CALL s_errmsg('nmf01,nmf03',g_showmsg,'t150_ins_nmf',SQLCA.sqlcode,1)
      LET g_success = 'N' RETURN
   END IF
END FUNCTION
 
FUNCTION t150_upd_nmd(p_sw)
   DEFINE p_sw    LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmd29 LIKE nmd_file.nmd29
   IF g_npl.npl03='1' THEN #結案日期僅在確認且票況不為1才更新
      LET l_nmd29=NULL
   ELSE
      LET l_nmd29=g_npl.npl02
   END IF
   IF p_sw='+' THEN   #確認
      UPDATE nmd_file SET nmd12=g_npl.npl03,nmd13=g_npl.npl02,
             nmd29=l_nmd29 WHERE nmd01=m_npm.npm03
   ELSE      #取消確認
      UPDATE nmd_file SET nmd12=m_npm.npm07,nmd13=m_npm.npm08,
             nmd29=NULL WHERE nmd01=m_npm.npm03
   END IF
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nmd01',m_npm.npm03,'upd nmd',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t150_ins_nnz()
   INITIALIZE g_nnz.* TO NULL
   LET g_nnz.nnz01 = g_nmd.nmd03
   LET g_nnz.nnz02 = g_nmd.nmd02
   LET g_nnz.nnz03 = m_npm.npm03
   LET g_nnz.nnzuser = g_user
   LET g_nnz.nnzgrup = g_grup
   LET g_nnz.nnzmodu = ' '
   LET g_nnz.nnzdate = g_today
   LET g_nnz.nnzoriu = g_user      #No.FUN-980030 10/01/04
   LET g_nnz.nnzorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nnz_file VALUES(g_nnz.*)
   IF SQLCA.sqlcode THEN
      LET g_showmsg=g_nnz.nnz01,"/",g_nnz.nnz02
      CALL s_errmsg('nnz01,nnz02',g_showmsg,'t150_ins_nnz',SQLCA.sqlcode,1)  
      LET g_success = 'N' RETURN
   END IF
END FUNCTION
 
FUNCTION t150_del_nnz()
  DEFINE l_nmd02  LIKE nmd_file.nmd02,
         l_nmd03  LIKE nmd_file.nmd03
 
   LET l_nmd02=''
   LET l_nmd03=''
   SELECT nmd02,nmd03 INTO l_nmd02,l_nmd03 FROM nmd_file
    WHERE nmd01 = m_npm.npm03
   IF NOT cl_null(l_nmd02) AND NOT cl_null(l_nmd03) THEN
      DELETE FROM nnz_file  WHERE nnz01 = l_nmd03 AND nnz02 = l_nmd02
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nnz01',l_nmd03,'upd nmd',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t150_t()
   DEFINE l_npl     RECORD LIKE npl_file.*,
          l_nmd     RECORD LIKE nmd_file.*,
          l_npm     RECORD LIKE npm_file.*,
          l_custom         LIKE nmh_file.nmh11,
          l_custom_old     LIKE nmh_file.nmh11,
          l_buf1    LIKE type_file.chr1000, #No.7789  #No.FUN-680107 VARCHAR(300)
          l_apa     RECORD LIKE apa_file.*,
          l_apb     RECORD LIKE apb_file.*,
          l_aps     RECORD LIKE aps_file.*,
          l_nmd08   LIKE nmd_file.nmd08,
          l_name1   LIKE apk_file.apk28,    #No.FUN-680107 VARCHAR(12)
          l_cmd     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(30)
          l_depno   LIKE apa_file.apa22,
          l_apa05   LIKE apa_file.apa05,
          l_apb02   LIKE apb_file.apb02,
        l_i,g_count LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_n       LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          li_result LIKE type_file.num5,    #No.FUN-560002 #No.FUN-680107 SMALLINT
          l_apz13   LIKE apz_file.apz13
   DEFINE ap_slip   LIKE nmy_file.nmyslip   #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE ap_type   LIKE apa_file.apa36
 
   IF s_anmshut(0) THEN RETURN END IF
 
 
   OPEN WINDOW t150_t AT 8,20 WITH FORM "anm/42f/anmt1502"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt1502")
 
 
   CLEAR FORM                                    #清除畫面
   CONSTRUCT BY NAME g_wc ON npl01,npl02
              BEFORE CONSTRUCT
                 DISPLAY g_npl.npl01 TO npl01   #CHI-810018
                 DISPLAY g_npl.npl02 TO npl02   #CHI-810018
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
      CLOSE WINDOW t150_t
      RETURN
   END IF
 
   #資料權限的檢查
 
 
 
 
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
                CALL q_apy(FALSE,FALSE,ap_slip,'12','AAP') RETURNING ap_slip  #NO:6842
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t150_t
      RETURN
   END IF
   LET g_success = 'Y'   #MOD-830031
   BEGIN WORK   #MOD-830031
   LET g_count = 0
   LET l_buf1 = g_wc #No.7789
   IF l_buf1 != ' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM apa_file,npl_file ",
                " WHERE apa25=npl01 AND apa42 = 'N' AND ",l_buf1 CLIPPED
      PREPARE t400_apa_pre FROM g_sql
      IF SQLCA.sqlcode THEN CALL cl_err('t400_apa_pre',STATUS,1) END IF
      DECLARE t400_apa_cur CURSOR FOR t400_apa_pre
      IF SQLCA.sqlcode THEN CALL cl_err('t400_apa_cur',STATUS,1) END IF
      OPEN t400_apa_cur
      FETCH t400_apa_cur INTO g_count
   END IF
   IF g_count > 0 THEN
      LET g_success='N'
   ELSE
      CALL cl_err('','anm-999',0)
#     MESSAGE '資料正在處理中,請稍候.........'
      LET g_sql = "SELECT * FROM npl_file,npm_file LEFT JOIN nmd_file ON  npm03=nmd_file.nmd01 ",
                  " WHERE npl01=npm01 ",
                  "   AND (npl03='6' OR npl03='7' ",
                  "    OR (npl03='9' AND npm07 = '8')",
                  "    OR (npl03='9' AND npm07 = 'X'))",
                  "   AND ", g_wc CLIPPED
 
 
      OPEN t150_cl USING g_npl.npl01
      IF STATUS THEN
         CALL cl_err("OPEN t150_cl:", STATUS, 1)
         CLOSE t150_cl
         CLOSE WINDOW t150_t   #MOD-7C0090
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t150_cl INTO g_npl.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_npl.npl01,SQLCA.sqlcode,0)
         CLOSE t150_cl 
         CLOSE WINDOW t150_t   #MOD-7C0090
         ROLLBACK WORK 
         RETURN
      END IF
      PREPARE t150_t_prepare FROM g_sql
      DECLARE t150_t CURSOR FOR t150_t_prepare
      DROP TABLE tmp1_file
      DROP TABLE tmp2_file
      DROP TABLE tmp3_file
      CALL t150_create_apa()
      CALL t150_create_apb()
      CALL t150_create_apa01()
      CALL s_showmsg_init()   #No.FUN-710024
      FOREACH t150_t INTO g_npl.*,l_npm.*,l_nmd.*
         IF STATUS THEN 
            CALL s_errmsg('','','foreach',STATUS,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF g_npl.nplconf = 'N' THEN
            CALL s_errmsg('npl01',g_npl.npl01,'','anm-960',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         SELECT COUNT(*) INTO l_n FROM nmf_file
          WHERE nmf01=l_npm.npm03 AND (nmf05 = 'X' OR nmf05 = '1')          #MOD-9A0160 add nmf05='1'
         IF l_n = 0 THEN
            CALL s_errmsg('nmf01',l_npm.npm03,l_npm.npm03,'anm-652',1)
             LET g_success='N'                #No:8159
             CONTINUE FOREACH
         END IF
         INITIALIZE g_apa.* TO NULL
         LET g_apa.apa00 = '12'
#TQC-AB0243--add--str--
         #帳款編號字段產生
         CALL s_auto_assign_no("aap",ap_slip,g_npl.npl02,"12","","","","","")
          RETURNING li_result,g_apa.apa01
         IF (NOT li_result) THEN
            LET g_success="N"
         END IF
         LET g_apa.apa79 = 0
#TQC-AB0243--add--end--
         LET g_apa.apa02 = g_npl.npl02
         LET g_apa.apa05 = l_nmd.nmd08
         LET g_apa.apa06 = l_nmd.nmd08
         LET g_apa.apa07 = l_nmd.nmd24
         LET g_apa.apa08 = ' '            #No:8159
         LET g_apa.apa20 = 0
 
         SELECT pmc17,pmc47,pmc24 INTO g_apa.apa11,g_apa.apa15,g_apa.apa18
           FROM pmc_file WHERE pmc01=g_apa.apa05
         IF STATUS THEN
            LET g_success='N' LET g_errno = 'aap-040'
         END IF
         SELECT gec04 INTO g_apa.apa16 FROM gec_file
          WHERE gec01=g_apa.apa15 AND gec011='1'       #No:8159
         CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,g_apa.apa06)
             RETURNING g_apa.apa12,g_apa.apa64,g_apa.apa24
         IF g_errno <> ' ' THEN LET g_success='N' END IF
         LET g_apa.apa13 = g_npl.npl04
         LET g_apa.apa14 = g_npl.npl05
         LET g_apa.apa72 = g_apa.apa72   #bug no:A059
 
         LET g_apa.apa17 = '1'
         LET g_apa.apa171= '21'
         LET g_apa.apa172= '1'
         LET g_apa.apa173=YEAR(g_today)
         LET g_apa.apa174=MONTH(g_today)
 
         LET g_apa.apa21 = g_user
         SELECT gen03 INTO g_apa.apa22 FROM gen_file WHERE gen01=g_apa.apa21
 
         LET g_apa.apa25 = l_npm.npm01
         LET g_apa.apa31f= l_npm.npm04
         LET g_apa.apa32f= 0
         LET g_apa.apa33f= 0
         LET g_apa.apa34f= l_npm.npm04
         LET g_apa.apa35f= 0
         LET g_apa.apa31 = l_npm.npm06
         LET g_apa.apa32 = 0
         LET g_apa.apa33 = 0
         LET g_apa.apa34 = l_npm.npm06
         LET g_apa.apa73 = g_apa.apa34      #bug no:A059
         LET g_apa.apa74 = 'N'              #No:8457
         LET g_apa.apa35 = 0
 
         LET g_apa.apa36 = ap_type
 
         LET g_apa.apa41 = 'Y'
         LET g_apa.apa42 = 'N'
         LET g_apa.apa44 = g_npl.npl09   #CHI-810018
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
         LET g_apa.apa930=s_costcenter(g_apa.apa22)  #FUN-670064
 
         #先存在buffer內
         LET g_apa.apalegal = g_legal  #FUN-A90063
         LET g_apa.apa79 = '1'         #No.MOD-AC0157
         INSERT INTO tmp1_file VALUES(g_apa.*)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp1_file',STATUS,1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
 
         # 單身部份 --------------------------------------------------------#
         INITIALIZE g_apb.* TO NULL
         LET g_apb.apb01 = g_apa.apa01
         LET g_apb.apb08 = l_npm.npm06       #本幣單價
         LET g_apb.apb09 = 1                 #數量
         LET g_apb.apb10 = l_npm.npm06       #本幣金額
         LET g_apb.apb081=g_apb.apb08
         LET g_apb.apb101=g_apb.apb10
         LET g_apb.apb12 = ' '               #料號
         LET g_apb.apb13f= 0                 #原幣折讓單價
         LET g_apb.apb13 = 0                 #本幣折讓單價
         LET g_apb.apb14f= 0                 #原幣折讓金額
         LET g_apb.apb14 = 0                 #本幣折讓金額
         LET g_apb.apb15 = 0                 #折讓數量
         LET g_apb.apb34 = 'N'               #No.TQC-7B0083
         LET g_apb.apb23 = l_npm.npm04       #原幣單價
         LET g_apb.apb24 = l_npm.npm04       #原幣金額
         LET g_apb.apb26 = l_nmd.nmd18       #部門
         LET g_apb.apb27 = '票據立帳'        #品名
         LET g_apb.apb930=g_apa.apa930       #FUN-670064 
         LET g_apb.apb02 = l_npm.npm02       #TQC-AB0243
         LET g_apb.apblegal = g_legal        #TQC-AB0243
         #LET g_apa.apalegal = g_legal  #FUN-A90063#TQC-AB0243
         INSERT INTO tmp2_file VALUES(g_apb.*,l_nmd.nmd08)
         IF STATUS THEN
            CALL s_errmsg('','','ins tmp2_file',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END FOREACH
     #再將資料抓出處理
      DECLARE tmp1_cur CURSOR FOR
       SELECT * FROM tmp1_file
        ORDER BY apa05
      IF SQLCA.sqlcode THEN CALL cl_err('tmp1_cur',STATUS,1) END IF
      CALL cl_outnam('anmt150') RETURNING l_name1   #MOD-740108
      START REPORT t150_rep1 to l_name1
      FOREACH tmp1_cur INTO l_apa.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','foreach oma',SQLCA.sqlcode,1)
            LET g_success='N'                #No:8159
            EXIT FOREACH
         END IF
         OUTPUT TO REPORT t150_rep1(l_apa.*,ap_slip)
      END FOREACH
      FINISH REPORT t150_rep1
      IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009
      DECLARE tmp2_cur CURSOR FOR
        SELECT * FROM tmp2_file ORDER BY cus
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('','','tmp2_cur',STATUS,0)
      END IF
      LET l_custom = ' '
      LET l_custom_old=' '
      INITIALIZE l_apb.* to NULL
      LET l_apb02 = 0
      LET g_cnt = 0
      FOREACH tmp2_cur INTO l_apb.*,l_nmd08
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','foreach omb',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_custom = l_nmd08
         LET g_cnt = g_cnt + 1
         IF l_custom != l_custom_old AND g_cnt != 1 THEN
            LET l_apb02 = 0
         END IF
         LET l_apb02 = l_apb02 + 1
          LET l_nmd08 = l_nmd08 CLIPPED #No.MOD-470464
         SELECT a01 INTO l_apb.apb01 FROM tmp3_file where a03 =l_nmd08
         LET l_apb.apb02 = l_apb02
         LET l_apb.apb34 = 'N'      #No.TQC-7B0083
 
         LET l_apb.apblegal = g_legal 
 
         INSERT INTO apb_file VALUES(l_apb.*)
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('apb01',l_apb.apb01,'ins apb',STATUS,1)
             LET g_success = 'N' #No.MOD-470464
         END IF
         LET l_custom_old = l_nmd08
      END FOREACH
 
      DECLARE tmp3_cs CURSOR FOR SELECT a01 FROM tmp3_file
      FOREACH tmp3_cs INTO l_apa.apa01
         SELECT SUM(apb10),SUM(apb24) INTO l_apa.apa57,l_apa.apa57f FROM apb_file   #MOD-660100
          WHERE apb01=l_apa.apa01
         UPDATE apa_file SET apa57 = l_apa.apa57,
                             apa57f = l_apa.apa57f   #MOD-660100
          WHERE apa01=l_apa.apa01
         IF SQLCA.sqlcode THEN
             CALL s_errmsg('apa01',l_apa.apa01,'upd apa',STATUS,1)
             LET g_success = 'N' #No.MOD-470464
         END IF
      END FOREACH
 
   END IF
 
    CLOSE WINDOW t150_t                 #結束畫面
 
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
         CALL s_errmsg('','','','anm-651',1)   #MOD-830031
        CALL s_showmsg()          #No.FUN-710024
        ROLLBACK WORK
      ELSE
         CALL cl_rbmsg(1)
         CALL s_showmsg()          #No.FUN-710024
         ROLLBACK WORK
      END IF
    END IF
END FUNCTION
 
REPORT t150_rep1(p_apa,p_slip)
   DEFINE p_apa       RECORD LIKE apa_file.*
   DEFINE l_apc       RECORD LIKE apc_file.*   #MOD-810265 add
   DEFINE p_slip      LIKE oay_file.oayslip    #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE li_result   LIKE type_file.num5      #No.FUN-560002 #No.FUN-680107 SMALLINT
 
   ORDER EXTERNAL BY p_apa.apa05  #請款廠商
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
        LET p_apa.apa79  = 0            #No.FUN-A60024
        CALL t150_comp_oox(p_apa.apa01) RETURNING g_net
        LET p_apa.apa73  = p_apa.apa34-p_apa.apa35 + g_net   #MOD NO:A059
 
      CALL s_auto_assign_no("aap",p_slip,p_apa.apa02,"12","","","","","")
           RETURNING li_result,p_apa.apa01
      IF (NOT li_result) THEN
         LET g_success='N'
      END IF
 
       LET p_apa.apa100 = g_plant   #FUN-960141 add 090824
       LET p_apa.apalegal = g_legal 
 
       LET p_apa.apaoriu = g_user      #No.FUN-980030 10/01/04
       LET p_apa.apaorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO apa_file VALUES(p_apa.*)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('apa01',p_apa.apa01,'ins apa_file',SQLCA.sqlcode,1)    #No.FUN-710024
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
          CALL s_errmsg('apa01',p_apa.apa01,'ins tmp3',SQLCA.sqlcode,1)    #No.FUN-710024
       END IF
END REPORT
 
FUNCTION t150_create_apa()
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
 
FUNCTION t150_create_apb()
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
 
FUNCTION t150_create_apa01()
 
    CREATE TEMP TABLE tmp3_file(
      a01 LIKE apb_file.apb01,
      a03 LIKE nmd_file.nmd08)
 
END FUNCTION
 
FUNCTION t150_t2()
   DEFINE l_apa01 LIKE apa_file.apa01
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_apa35 LIKE apa_file.apa35
   DEFINE l_apa35f LIKE apa_file.apa35f
   
   SELECT COUNT(*) INTO l_cnt FROM apa_file
     WHERE apa25 = g_npl.npl01
   IF l_cnt = 0 THEN
      RETURN
   END IF
 
   IF cl_confirm('anm-132') THEN     #MOD-B30353
      BEGIN WORK
      LET g_success='Y'
    
     
      DECLARE apa_c CURSOR FOR 
        SELECT apa01 FROM apa_file WHERE apa25=g_npl.npl01
    
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
         CALL cl_err('','mfg1604',0) #MOD-B30353 add
         ROLLBACK WORK
      END IF
   END IF                            #MOD-B30353 add
END FUNCTION
 
FUNCTION t150_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("npl01",TRUE)
   END IF
   CALL cl_set_comp_entry("npl03,npl04,npl05,npl06,npl07",TRUE)   #MOD-860308 add npl04,npl05
   IF g_aza.aza63 = 'Y' THEN
   CALL cl_set_comp_entry("npl061,npl071",TRUE)
   END IF
END FUNCTION
 
FUNCTION t150_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
  DEFINE l_cnt   LIKE type_file.num5    #MOD-860308 add
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("npl01",FALSE)
    END IF
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("npl03",FALSE)
      #當有單身資料時,單頭幣別,匯率不可異動
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM npm_file
        WHERE npm01=g_npl.npl01
       IF l_cnt > 0 THEN
          CALL cl_set_comp_entry("npl04,npl05",FALSE)
       END IF
    END IF
 
    IF p_cmd = 'u' OR INFIELD(npl03) THEN
       IF g_nmy.nmydmy3 = 'N' OR g_npl.npl03!='1' THEN
          LET g_npl.npl06=NULL
          DISPLAY BY NAME g_npl.npl06
          CALL cl_set_comp_entry("npl06",FALSE)
       IF g_aza.aza63 = 'Y' THEN
          LET g_npl.npl061=NULL
          DISPLAY BY NAME g_npl.npl061
          CALL cl_set_comp_entry("npl061",FALSE)
       END IF  
     END IF
       IF g_nmy.nmydmy3 = 'N' OR g_npl.npl03='8' THEN
          LET g_npl.npl07=NULL
          DISPLAY BY NAME g_npl.npl07
          CALL cl_set_comp_entry("npl07",FALSE)
      IF g_aza.aza63 = 'Y' THEN
          LET g_npl.npl071=NULL
          DISPLAY BY NAME g_npl.npl071
         CALL cl_set_comp_entry("npl071",FALSE)
      END IF 
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t150_comp_oox(p_apv03)
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
 
FUNCTION t150_carry_voucher()
   DEFINE l_nmygslp    LIKE nmy_file.nmygslp
   DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1  #No.FUN-680034
   DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_dbs        STRING                                                                                                        
   DEFINE l_sql        STRING                                                                                                        
   DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_npl.npl09) OR g_npl.npl09 IS NOT NULL THEN
       CALL cl_err(g_npl.npl09,'aap-618',1) 
       RETURN 
    END IF
   IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
   CALL s_get_doc_no(g_npl.npl01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   CALL s_get_bookno(YEAR(g_npl.npl02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
      RETURN
   END IF
 
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'0',g_bookno1)       #No.FUN-730032
    IF g_aza.aza63 = 'Y' THEN
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'1',g_bookno2)       #No.FUN-730032
    END IF
 
   IF g_success='N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
      LET l_nmygslp = g_nmy.nmygslp
      LET l_nmygslp1= g_nmy.nmygslp1     #No.FUN-680034
      LET g_plant_new=g_nmz.nmz02p 
      #CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102                                                              
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file", 
      LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102    
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",                                                                               
                  "    AND aba01 = '",g_npl.npl09,"'"                                                                                 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre2 FROM l_sql                                                                                                     
      DECLARE aba_cs2 CURSOR FOR aba_pre2                                                                                             
      OPEN aba_cs2                                                                                                                    
      FETCH aba_cs2 INTO l_n                                                                                                          
      IF l_n > 0 THEN                                                                                                                 
         CALL cl_err(g_npl.npl09,'aap-991',1)                                                                                         
         RETURN                                                                                                                       
      END IF 
   ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN 
      #開窗作業
 
   END IF
   IF cl_null(l_nmygslp) THEN
      CALL cl_err(g_npl.npl01,'axr-070',1)
      RETURN
   END IF
   IF cl_null(l_nmygslp1) AND g_aza.aza63 = 'Y' THEN
      CALL cl_err(g_npl.npl01,'axr-070',1)
      RETURN
   END IF
   LET g_wc_gl = 'npp01 = "',g_npl.npl01,'" AND npp011 = ',g_npl.npl03
   LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
             " '",g_nmz.nmz02b,"' '",l_nmygslp,"' ",                                #No.FUN-680034
             " '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_npl.npl02,"' 'Y' '1' 'Y'"   #No.FUN-680034#FUN-860040
   CALL cl_cmdrun_wait(g_str)
   SELECT npl09 INTO g_npl.npl09 FROM npl_file
    WHERE npl01 = g_npl.npl01
   DISPLAY BY NAME g_npl.npl09
   
END FUNCTION
 
FUNCTION t150_undo_carry_voucher() 
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      STRING
 
    IF cl_null(g_npl.npl09) OR g_npl.npl09 IS NULL THEN 
       CALL cl_err(g_npl.npl09,'aap-619',1)
       RETURN 
    END IF
   IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
   CALL s_get_doc_no(g_npl.npl01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
      CALL cl_err('','aap-936',1)   #FUN-940036
      RETURN                                                                                                                       
   END IF  
   CALL s_get_bookno(YEAR(g_npl.npl02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npl.npl02),'aoo-081',1)
      RETURN
   END IF
 
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'0',g_bookno1)       #No.FUN-730032
    IF g_aza.aza63 = 'Y' THEN
      CALL s_chknpq(g_npl.npl01,'NM',g_npl.npl03,'1',g_bookno2)       #No.FUN-730032
    END IF
 
 
   IF g_success='N' THEN RETURN END IF
 
   LET g_plant_new = g_nmz.nmz02p
   #CALL s_getdbs() #FUN-A50102
   LET l_sql = "SELECT aba19 ",
               #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               " WHERE aba00 = '",g_nmz.nmz02b,"' ",
               "   AND aba01 = '",g_npl.npl09,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE aba_pre1 FROM l_sql
   DECLARE aba_cs1 CURSOR FOR aba_pre1
   OPEN aba_cs1
   IF SQLCA.sqlcode THEN RETURN END IF
   FETCH aba_cs1 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_npl.npl09,'axr-071',1)
      RETURN
   END IF
   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_npl.npl09,"' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT npl09 INTO g_npl.npl09 FROM npl_file
    WHERE npl01 = g_npl.npl01
   DISPLAY BY NAME g_npl.npl09
END FUNCTION
 
FUNCTION t150_gen_glcr(p_npl,p_nmy)
   DEFINE p_npl    RECORD LIKE npl_file.*
   DEFINE p_nmy    RECORD LIKE nmy_file.*
 
   IF cl_null(p_nmy.nmygslp) THEN
      CALL s_errmsg('','',p_npl.npl01,'axr-070',1)
      LET g_success = 'N'
      RETURN
   END IF       
 
    CALL s_t150_gl(g_npl.npl01,'0')
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
    CALL s_t150_gl(g_npl.npl01,'1')
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION t150_get_npl03_where()                                                                                                     
   DEFINE l_sql  STRING                                                                                                             
                                                                                                                                    
   CASE g_npl.npl03                                                                                                                 
      WHEN '1'                                                                                                                      
         CALL s_get_doc_no(g_npl.npl01) RETURNING g_t1                                                                              
         SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1                                                                     
         IF g_nmy.nmydmy3 = 'N' THEN                                                                                                
            LET l_sql=l_sql CLIPPED,"  nmd12 <> 'X' AND nmd30='Y' AND ",                                                            
                                 "  nmd31 <> '98' AND "                                                                             
         ELSE                                                                                                                       
           #LET l_sql=l_sql CLIPPED,"   nmd30='Y' AND ",               #MOD-AC0053 mark
            LET l_sql=l_sql CLIPPED," nmd12 = '1' AND nmd30='Y' AND ", #MOD-AC0053
                                 "  nmd31 <> '98' AND "                                                                             
         END IF                                                                                                                     
      WHEN '6'                                                                                                                      
        #LET l_sql=l_sql CLIPPED,"  nmd12 MATCHES '[X18]' AND nmd30='Y' AND ",   #MOD-AB0196 mark 
         LET l_sql=l_sql CLIPPED,"  nmd12 IN ('X','1','8') AND nmd30='Y' AND ",  #MOD-AB0196 
                                 "  nmd31 <> '98' AND "                                                                             
      WHEN '7'                                                                                                                      
         LET l_sql=l_sql CLIPPED,"  nmd12 = '8' AND nmd30='Y' AND ",                                                                
                                 "  nmd31 <> '98' AND "                                                                             
      WHEN '8'                                                                                                                      
        #LET l_sql=l_sql CLIPPED,"  nmd12 MATCHES '[X1]' AND nmd30='Y' AND "     #MOD-AB0196 mark 
         LET l_sql=l_sql CLIPPED,"  nmd12 IN ('X','1') AND nmd30='Y' AND "       #MOD-AB0196 
      WHEN '9'                                                     
        #LET l_sql=l_sql CLIPPED,"  nmd12 MATCHES '[X1]' AND nmd30='Y' AND "     #MOD-AB0196 mark 
         LET l_sql=l_sql CLIPPED,"  nmd12 IN ('X','1') AND nmd30='Y' AND "       #MOD-AB0196 
      OTHERWISE                                                                                                                     
        #LET l_sql=l_sql CLIPPED,"  nmd12 MATCHES '[X18]' AND nmd30='Y' AND "    #MOD-AB0196 mark 
         LET l_sql=l_sql CLIPPED,"  nmd12 IN ('X','1','8') AND nmd30='Y' AND "   #MOD-AB0196 
   END CASE                                                                                                                         
   LET l_sql=l_sql CLIPPED," nmd21='",g_npl.npl04,"'"                                                                               
                                                                                                                                    
   RETURN l_sql                                                                                                                     
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15


#No.FUN-C50125  --Begin
FUNCTION t150_gen_gl()
   DEFINE l_t1       LIKE nmy_file.nmyslip,
          l_nmydmy3  LIKE nmy_file.nmydmy3

   IF NOT cl_null(g_npl.npl09) THEN
      CALL cl_err(g_npl.npl09,'aap-122',1) RETURN
   END IF
   LET l_t1 = s_get_doc_no(g_npl.npl01)       #No.FUN-550057
   LET l_nmydmy3 = ''
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nmy_file","","",STATUS,"","sel nmy:",1)
      RETURN
   END IF

   IF l_nmydmy3 = 'Y' THEN
      CALL s_t150_gl(g_npl.npl01,'0')
      IF g_aza.aza63 = 'Y' THEN
         CALL s_t150_gl(g_npl.npl01,'1')
      END IF
   END IF

END FUNCTION

#No.FUN-C50125  --End
