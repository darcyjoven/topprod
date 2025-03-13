# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt710.4gl
# Descriptions...: 短期融資申請單建檔
# Date & Author..: 96/11/13 BY jimmy
# Modify.........: 97/05/28 By Lynn  1.確認時, 若單別須拋轉總帳, 檢查分錄底稿
#                                    2.已拋轉總帳者, 不可再產生分錄底稿
#                                    3.新增時,詢問是否產生分錄底稿
#                                    4.取消確認,若已拋轉總帳,show警告訊息
# Modify.........: 03/05/27 By Kammy 1.傳票拋轉移到 anmp400
#                  (No.7277)         2.傳票還原移到 anmp409
#                                    3.注意:npp00原 '3' 改 '16'以利區分
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.7901 03/12/08 By Kitty 預設科目部份多三個科目供其設定
# Modify.........: No.8614 03/12/10 By Kitty 增加開帳否及最後還息日,預付費用改為可不輸入
# Modify.........: No.8609 03/12/16 By Kitty 增加判斷若已有暫估資料不可取消確認
# Modify.........: No.8935 04/01/05 By Kitty 增加判斷nnn07若為N則確認時不產生nme_file
# Modify.........: No.MOD-480290 04/08/12 By Kammy 票據資料維護新增資料都不成功
# Modify.........: No.MOD-480328 04/08/19 By Kammy 承銷費率修改完不會自動重新承銷費
# Modify.........: No.MOD-480617 04/09/15 By Kitty 融資種類若為購料借款,存入銀行應該要可以空白
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0177 04/10/12 By Nicola 依類別判斷還息日可否輸入
# Modify.........: No.MOD-4A0248 04/10/22 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510040 05/01/21 By Kitty nmf05/nmf06 取值邏輯應同 anmp500/anmt750
# Modify.........: No.MOD-510076 05/03/21 By Kitty 應付票據維護點了出不來資料
# Modify.........: No.MOD-530898 05/04/12 By Nicola 1.幣別應從合約資料自動帶出
#                                                   3.無輸入存入銀行時其異動碼應不可輸入
#                                                   4.額度匯率,借款利率未自動從合約資料帶出
# Modify.........: No.MOD-540078 05/04/13 By Nicola 5.背書保證為'N'時,不應輸入公司編號,保證金額
#                                                   6.若非發行商業本票/銀行承兌匯票時,保證金率,承銷費率,簽證費率,保證金,承銷費,簽證費,本票折價應控制不可輸入
#                                                   7.現金變動碼為何一定要輸入?
#                                                   8.融資種類為:預付購料款時程式控制不需產生分錄,但新增輸入存檔後卻跳出會科維護視窗  ==>nnn06='1',會科不輸入
#                                                   9.按'信貸額度'出現的視窗,沒有訊息?.有英文顯示
#                                                   10.存入銀行其幣別應與信貸種類之幣別一致,否則造成後續資料都錯
#                                                   11.分錄產生:若保證金..等欄位有值時,其會科應必要輸入
#                                                   12.產生之nme_file,原幣金額有誤.請參考單號941-530002
# Modify.........: No.FUN-550037 05/05/13 By saki   欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/02 By vivien 單據編號修改
# Modify.........: NO.FUN-560095 05/06/20 By ching 2.0功能修改
# Modify.........: No.MOD-560195 05/07/07 By Nicola Menu段程式標準化
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.MOD-580329 05/09/12 By Smapmin NEXT FIELD 有誤
# Modify.........: No.MOD-580383 05/09/12 By Smapmin "存入銀行"欄位沒打,按"放棄"無法離開程式
# Modify.........: No.FUN-5B0110 05/11/23 By kim 合約編號開窗要加秀銀行簡稱,q_nnp->q_nnp01
# Modify.........: No.MOD-5B0290 05/11/23 By kim 他保銀行的開窗要抓全省銀行檔,而非銀行帳戶檔
# Modify.........: No.MOD-5C0126 05/12/27 By Smapmin 1.新增時來源營運中心欄位無帶值
#                                                    2.沒產生應付票據資料,做'票據還原',不應可執行
# Modify.........: No.MOD-5C0157 05/12/28 By Smapmin 修改產生分錄之原幣金額
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼、摘要default值
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.MOD-5C0140 06/03/31 By Smapmin 若客戶不做外購信用狀流程,但有外購融資情形,則在此無法
#                                                    產生分錄.應用系統單別是否產生傳票加以控制才是.
# Modify.........: No.MOD-640062 06/04/08 By Sarah 還息日為必key欄位
# Modify.........: No.FUN-640021 06/04/12 By Smapmin 存入銀行異動碼開窗有誤
# Modify.........: No.FUN-640242 06/04/25 By Smapmin 增加nne45,nne46,nne_d7三個欄位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660143 06/06/21 By Echo p_flow功能補強
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/08/02 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680088 06/08/28 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690076 06/10/16 By Smapmin 增加nne241,nne291,nne371,nne461等欄位,並修改nme04回寫的金額
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0015 06/11/06 By Smapmin 增加列印功能串anmr711
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6B0125 06/11/24 By Smapmin 由aapt820串資料過來有誤
# Modify.........: No.FUN-710024 07/02/05 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-730116 07/03/23 By Smapmin 修改L/C No開窗
# Modify.........: No.MOD-740209 07/04/22 By Smapmin 信用額度不足只秀出訊息
# Modify.........: No.MOD-740228 07/04/22 By Smapmin 已失效合約不可登打
# Modify.........: No.CHI-740028 07/04/23 By Smapmin 修改開窗查詢
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.MOD-740474 07/04/26 By Smapmin 他保銀行不寫入銀行存款異動檔
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.TQC-790093 07/09/20 By yiting Primary Key的-268訊息 程式修改 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810167 08/01/25 By Smapmin q_nnp01改為Hard Code
# Modify.........: No.MOD-840250 08/04/21 By Smapmin 修改信貸額度檢查
# Modify.........: No.MOD-840248 08/04/28 By Smapmin 預設會計科目/計算本票折價
# Modify.........: No.FUN-850038 08/05/12 By TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-8A0148 08/10/16 By Sarah 當nnn06='2','3'時才需要計算nne25
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8C0090 08/12/15 By Sarah 票據資料維護,判斷當nnf06不為null時,不可異動
# Modify.........: No.MOD-8C0145 08/12/16 By clover 將該段mark 取消
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-910235 09/01/22 By Sarah 當勾選開帳(nne32='Y')時,存入銀行(nne05)不卡必輸
# Modify.........: No.MOD-920196 09/02/16 By Smapmin 修改錯誤訊息
# Modify.........: No.MOD-930296 09/03/30 By Sarah 資料若是由aapt820拋轉過來的,就不檢查nne05是否存nma_file裡
# Modify.........: No.MOD-940145 09/04/10 By lilingyu計算nme04 nme08時沒有扣除保証費用nne291 nne29
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/04 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.MOD-990156 09/09/29 By mike 修改anmt710.4gl,FUNCTION t710_g_gl(),  
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下,开放nne43可录
# Modify.........: No.MOD-990237 09/10/21 By mike 透过aapt820到单转融资资料时,若将此笔到单融资资料删除,应将到货请款之已付金额归0.   
# Modify.........: No:MOD-9B0206 09/11/30 By Sarah 當nne13為Nul或0時,才需抓取nnp05當預設值
# Modify.........: No:TQC-9B0092 09/12/25 By wujie 数值栏位不能为负数
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-950167 10/03/04 By vealxu formonly拼錯，畫面無nmd01欄位
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善
# Modify.........: No:MOD-B20141 11/02/24 By Dido 會科預設值位置調整;nne_c1給預設值nms63 
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:CHI-B30035 11/03/11 By Summer 動用日期nne03,應要大於等於申請日期,不可小於申請日期 
# Modify.........: No:MOD-B30181 11/03/17 By lixia 取消確認段增加檢核nne01是否存在nmd10
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:MOD-B40043 11/04/11 By Dido 分錄底稿中不應區分他保銀行分錄 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:MOD-B50191 11/05/23 By Dido nne05/nne051判斷nnn07='Y'才需輸入 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60086 11/06/16 By zhangweib CONSTURCT時加上資料建立者和資料建立部門
# Modify.........: No.TQC-B60097 11/06/16 By lixiang  当科目编号为空时，科目名称也应该显示为空
# Modify.........: No.TQC-B60092 11/06/16 By yinhy 檢查截止日期不可以大于合約有效日期
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B70050 11/08/10 By Polly 新增權限Action控管
# Modify.........: No:MOD-B80231 11/08/25 By Polly 1.調整原幣nne291、nne241、nne371、nne461後，本幣需自動調整帶入
#                                                  2.修正切換頁簽，修改資料會還原
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.MOD-B90155 11/09/20 By Polly 增加nnn07='Y'的控卡異動碼(nne051)
# Modify.........: No.MOD-B90192 11/09/23 By Polly FUNCTION t710_r 段增加檢核 aap-310
# Modify.........: No.CHI-B80011 11/10/06 By Polly s_chknpq 取消 nnn06 判斷
# Modify.........: No.MOD-BB0211 11/11/17 By Polly 更換幣別後，需重新計算匯率和本幣金額
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C20173 12/02/22 By Polly Call t710_default_acctno增加新舊值判斷
# Modify.........: No.MOD-C30267 12/03/10 By wangrr 更新后提示是否產生分錄底稿，確認時金額與分錄底稿金額相等才可以確認
# Modify.........: No.MOD-C30710 12/03/15 By lujh  取消 MOD-B90192 修改,否則 aapt820 無法還原
# Modify.........: No.MOD-C50032 12/05/08 By Elise 分錄底稿的異動日應預設動用日期
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No.TQC-C80199 12/08/31 By lujh 還款日nne21”欄位也應不可大于合約借款額度中單頭有效日期[nno05]
# Modify.........: No.TQC-C80198 12/09/03 By lujh q_nnp01增加動用日期的參數
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.TQC-CA0055 12/10/23 By zhangweib 比照 anmt100 判斷 nmz11 抓取 nms_file 給予 g_nms
# Modify.........: No.MOD-C90257 12/10/01 by Polly 確定段增加控卡，原幣、本幣金額控卡；當nnn07為Y時，nne05為必填欄位
# Modify.........: No.MOD-CA0017 12/10/02 By Polly nne32為Y時，nne33才可做維護
# Modify.........: No.MOD-CB0273 12/12/04 By Polly 調整aap-938條件控卡
# Modify.........: No.TQC-CC0022 12/12/06 By xuxz 添加存入異動碼名稱顯示，他保銀行簡稱sql修改為從nmt_file表中抓取
# Modify.........: No.MOD-D10081 13/01/09 By Polly 不產生銀存異動(nnn07)時，不需重抓nne05值
# Modify.........: No.TQC-D10060 13/01/14 By Polly 需取完位後再做aap-938控卡
# Modify.........: No.MOD-D10187 13/01/23 By Polly 取消anm1017的控卡
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No.FUN-D30032 13/04/09 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-C60006 13/05/08 By qirl 系統作廢/取消作廢需要及時更新修改者以及修改時間欄位
# Modify.........: No:FUN-D40118 13/05/20 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空 
# Modify.........: No:TQC-DA0035 13/10/23 By yangxf 修改信用余额控卡有遗漏BUG

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nne               RECORD LIKE nne_file.*,
    g_nne_t             RECORD LIKE nne_file.*,
    g_nne_o             RECORD LIKE nne_file.*,
    g_nne01_t           LIKE nne_file.nne01,
    g_nne04_t           LIKE nne_file.nne04,
    g_nne05_t           LIKE nne_file.nne05,
    g_nms               RECORD LIKE nms_file.*,
    g_alg               RECORD LIKE alg_file.*,
    g_alh               RECORD LIKE alh_file.*,
    g_nma               RECORD LIKE nma_file.*,
    g_nmg               RECORD LIKE nmg_file.*,
    g_npp               RECORD LIKE npp_file.*,
    g_npq               RECORD LIKE npq_file.*,
    g_dept              LIKE aab_file.aab02,         #No.FUN-680107 VARCHAR(6)
    l_azi04             LIKE azi_file.azi04,         #add03/01/07   
    amtf,amt,balf,bal   LIKE nne_file.nne12,         #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
    amty,amtu,u_amty,u_amtu  LIKE nne_file.nne12,    #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
    g_wc,g_sql          LIKE type_file.chr1000,      #No.FUN-580092 HCN #No.FUN-680107
    g_nnn06             LIKE nnn_file.nnn06,
    g_nnn07             LIKE nnn_file.nnn07,         #MOD-B50191
    g_nnn03             LIKE nnn_file.nnn03,
    g_nma10             LIKE nma_file.nma10,         #No.MOD-540078
    g_nma11             LIKE nma_file.nma11,
    g_nma14             LIKE nma_file.nma14,
    g_dbs_gl            LIKE type_file.chr21,        #No.FUN-680107 VARCHAR(21)
    l_ans               LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(01)
    l_cmd               LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(100)
    l_wc,l_wc2          LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(50)
    l_prtway            LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
    g_argv1             LIKE nne_file.nne01,         #No.FUN-680107 VARCHAR(16)  
    g_argv3             LIKE nne_file.nne01,         #No.FUN-680107 VARCHAR(16) #TQC-630074
    gl_no_b,gl_no_e     LIKE nne_file.nne01,         #No.FUN-680107 VARCHAR(16)
    g_t1                LIKE oay_file.oayslip,       #No.FUN-680107 VARCHAR(5)
    g_dec6              LIKE type_file.num20_6       #No.FUN-680107 dec(15,6)
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_nmc02          LIKE nmc_file.nmc02          #No.TQC-CC0022 add
DEFINE g_argv2          STRING                       #指定執行的功能 #TQC-630074
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
#------for ora修改-------------------
DEFINE g_system         LIKE ooy_file.ooytype        #No.FUN-680107 VARCHAR(2)
DEFINE g_zero           LIKE ade_file.ade05          #No.FUN-680107 decimal(15,3)
DEFINE g_zero1          LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE g_N              LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_forupd_sql     STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE   g_str          STRING                       #No.FUN-670060
DEFINE   g_wc_gl        STRING                       #No.FUN-670060
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE   g_plant_gl     LIKE type_file.chr10         #FUN-980020
DEFINE   g_npq25        LIKE npq_file.npq25          #No.FUN-9A0036
DEFINE   g_aag44        LIKE aag_file.aag44          #FUN-D40118 add
 
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
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)           #TQC-630074
   LET g_argv3=ARG_VAL(3)           #TQC-630074
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nne.nne16   #FUN-690076
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   LET g_plant_gl = g_nmz.nmz02p                                     #FUN-980020
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   INITIALIZE g_nne.* TO NULL
   INITIALIZE g_nne_t.* TO NULL
   INITIALIZE g_nne_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM nne_file WHERE nne01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t710_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 1 LET p_col = 10
   OPEN WINDOW t710_w AT p_row,p_col
     WITH FORM "anm/42f/anmt710"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("page05",TRUE)
    ELSE
       CALL cl_set_comp_visible("page05",FALSE)
    END IF
 
 
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) THEN   #MOD-6B0125
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
         OTHERWISE                       #FUN-660143
            CALL t710_q()
      END CASE
   END IF
 
 
      LET g_action_choice=""
   CALL t710_menu()
 
   CLOSE WINDOW t710_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   MESSAGE ' '
END MAIN
 
FUNCTION t710_cs()
 
   CLEAR FORM
 
   LET g_wc = ''
   IF NOT cl_null(g_argv1) OR  g_argv3<>' ' THEN
      IF NOT cl_null(g_argv1) THEN
          LET g_wc =" nne01 = '",g_argv1,"'"    #No.TQC-630074
      END IF
      IF g_argv3 <> ' ' THEN
          LET g_wc= g_wc CLIPPED," nne28='",g_argv3,"'"
      END IF
   ELSE
   INITIALIZE g_nne.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
         nne43,nne01,nne32,nne02,nne03,nne30,nne04,nne06,nne05,nne051,nne28,nne44,nne07,nne08,nne09,nne10, #No:8614 add nne32
         nneconf,nneglno,nne33,nne26,nne111,nne112,nne16,nne17,nneex2,nne12,nne19,nne13,nne14,nne21,       #No:8614 add nne33
         nne22,nne27,nne20,nne41,nne31,nne42,nne18,nne35,nne38,nne15,nne25,
         nne291,nne241,nne371,nne461,nne29,nne24,nne37,nne46,nne_d1,nne_d2,nne_c1,nne_d11,nne_d21,nne_c11,nneuser,nnegrup,nnemodu,nnedate   #FUN-690076  
         ,nneud01,nneud02,nneud03,nneud04,nneud05,
         nneud06,nneud07,nneud08,nneud09,nneud10,
         nneud11,nneud12,nneud13,nneud14,nneud15
        ,nneoriu,nneorig     #TQC-B60086   Add
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(nne01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_nne"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne01
                  NEXT FIELD nne01
##Genero: nne30此欄位在construct 開窗的時候,會因為OUTER table而卡住, 一種-用別的qry
##另一種 要詢問hiko能否保留OUTER table的where條件
               WHEN INFIELD(nne30) #合約號碼
                  CALL q_nnp01(1,1,g_nne.nne30,g_nne.nne03)      #TQC-C80198 add g_nne.nne03
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne30
               WHEN INFIELD(nne04) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_alg"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne04
                  NEXT FIELD nne04
##Genero: sql組合沒錯, FOREACH有問題
               WHEN INFIELD(nne06) #融資種類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnn"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne06
                  NEXT FIELD nne06
               WHEN INFIELD(nne05) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne05
                  NEXT FIELD nne05
               WHEN INFIELD(nne35) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmt" #MOD-5B0290 add
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne35
                  NEXT FIELD nne35
               WHEN INFIELD(nne31) #銀行代號 add
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nab"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne31
                  NEXT FIELD nne31
               WHEN INFIELD(nne051) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne051
                  NEXT FIELD nne051
               WHEN INFIELD(nne38) #銀行異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne38
                  NEXT FIELD nne38
               WHEN INFIELD(nne15) #L/C NO
                  CALL q_ala2(TRUE,TRUE,g_nne.nne15) RETURNING g_qryparam.multiret   #MOD-730116
                  DISPLAY g_qryparam.multiret TO nne15
                  NEXT FIELD nne15
               WHEN INFIELD(nne16) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne16
                  NEXT FIELD nne16
               WHEN INFIELD(nne18) #現金變動碼值
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne18
                  NEXT FIELD nne18
               WHEN INFIELD(nne44) #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nne44
                  NEXT FIELD nne44
              WHEN INFIELD(nne_d1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_d1,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_d1
                 NEXT FIELD nne_d1
              WHEN INFIELD(nne_d2)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_d2,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_d2
                 NEXT FIELD nne_d2
              WHEN INFIELD(nne_c1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_c1,'23',g_bookno1)     #No.FUN-980025  
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_c1
                 NEXT FIELD nne_c1
              WHEN INFIELD(nne_d11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_d11,'23',g_bookno2)     #No.FUN-980025
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_d11
                 NEXT FIELD nne_d11
              WHEN INFIELD(nne_d21)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020 
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_d21,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_d21
                 NEXT FIELD nne_d21
              WHEN INFIELD(nne_c11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                 CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nne.nne_c11,'23',g_bookno2)     #No.FUN-980025
                 RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO nne_c11
                 NEXT FIELD nne_c11
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
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
 
 
   LET g_sql="SELECT nne01 FROM nne_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED, " ORDER BY nne01"
   PREPARE t710_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE t710_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t710_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM nne_file WHERE ",g_wc CLIPPED
   PREPARE t710_precount FROM g_sql
   DECLARE t710_count CURSOR FOR t710_precount
 
END FUNCTION
 
FUNCTION t710_menu()
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("maintain_entry_sheet2",TRUE)
            ELSE
               CALL cl_set_act_visible("maintain_entry_sheet2",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
             IF cl_chk_act_auth() THEN   #No.MOD-560195
               CALL t710_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
             IF cl_chk_act_auth() THEN   #No.MOD-560195
               CALL t710_q()
            END IF
 
        ON ACTION next
            CALL t710_fetch('N')
 
        ON ACTION previous
            CALL t710_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
             IF cl_chk_act_auth() THEN   #No.MOD-560195
               CALL t710_u()
            END IF
 
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              LET l_wc = 'nne01="',g_nne.nne01,'"'
             #LET l_cmd =  "anmr711 ",g_today," '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"'" #FUN-C30085
              LET l_cmd =  "anmg711 ",g_today," '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"'" #FUN-C30085
              CALL cl_cmdrun(l_cmd)
           END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t710_r()
            END IF
 
        #@COMMAND "票據資料維護"
        ON ACTION maintain_n_p
           LET g_action_choice="maintain_n_p"         #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                  #No.CHI-B70050 add
              CALL t710_6()
           END IF                                     #No.CHI-B70050 add
 
        #@COMMAND "產生應付票據"
        ON ACTION gen_n_p
           LET g_action_choice="gen_n_p"              #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                  #No.CHI-B70050 add
              CALL t710_g_np()
           END IF                                     #No.CHI-B70050 add
 
        #@COMMAND "預設科目"
        ON ACTION default_Account
           LET g_action_choice="default_Account"      #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                  #No.CHI-B70050 add
              LET g_nmy.nmydmy3 = 'Y'
              IF g_nmy.nmydmy3 = 'Y' THEN #No.8614
                 CALL t710_4()
              ELSE
                 CALL cl_err('','anm-702',1)
              END IF
           END IF                                      #No.CHI-B70050 add 

        #@COMMAND "應付票據還原"
        ON ACTION undo_n_p
           LET g_action_choice="undo_n_p"             #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                  #No.CHI-B70050 add
              CALL t710_del_np()
           END IF                                     #No.CHI-B70050 add
 
        #@COMMAND "應付開票維護"
        ON ACTION mantain_n_p
           LET g_action_choice="mantain_n_p"                  #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                          #No.CHI-B70050 add 
              LET g_msg="anmt100 '' '' '",g_nne.nne01,"'"     #No.MOD-510076 #TQC-630074
              CALL cl_cmdrun_wait(g_msg)   #FUN-660216 add
           END IF                                             #No.CHI-B70050 add
 
        #@COMMAND "L/C 到單"
        ON ACTION l_c_arr_nt
           LET g_action_choice="l_c_arr_nt"                   #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                          #No.CHI-B70050 add
              LET g_msg="aapt820 '",g_nne.nne28,"'"
              CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
           END IF                                              #No.CHI-B70050 add 

        #@COMMAND "信貸額度"
        ON ACTION cr_quota
           LET g_action_choice="cr_quota"                     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                          #No.CHI-B70050 add
              CALL s_credit2('Y',g_nne.nne04,g_nne.nne30,g_nne.nne06)  
                   RETURNING amty,amtu,u_amty,u_amtu,bal
           END IF                                             #No.CHI-B70050 add 

        #@COMMAND "應收帳款融資貸款維護"
        ON ACTION maint_a_r_fin_lone
           LET g_action_choice="maint_a_r_fin_lone"      #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                     #No.CHI-B70050 add
              IF g_nne.nneconf <> 'X' THEN
                 LET g_msg="anmt701 '",g_nne.nne01,"'"
                 CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
              END IF
           END IF                                        #No.CHI-B70050 add 


        #@COMMAND "擔保票據融資貸款維護"
        ON ACTION secur_paper_fin_lone
           LET g_action_choice="secur_paper_fin_lone"      #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                       #No.CHI-B70050 add
              IF g_nne.nneconf <> 'X' THEN
                 LET g_msg="anmt702 '",g_nne.nne01,"'"
                 CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
              END IF
           END IF                                           #No.CHI-B70050 add
 
        #@COMMAND "資產抵押融資貸款維護"
        ON ACTION collateral_fin_loan
           LET g_action_choice="collateral_fin_loan"       #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                       #No.CHI-B70050 add
              IF g_nne.nneconf <> 'X' THEN
                 LET g_msg="anmt703 '",g_nne.nne01,"'"
                 CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
              END IF
           END IF                                          #No.CHI-B70050 add
 
        #@COMMAND "擔保票券融資貸款維護"
        ON ACTION secur_bill_fin_lone
           LET g_action_choice="secur_bill_fin_lone"       #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                       #No.CHI-B70050 add
              IF g_nne.nneconf <> 'X' THEN
                 LET g_msg="anmt704 '",g_nne.nne01,"'"
                 CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
              END IF
           END IF                                           #No.CHI-B70050 add 

        #@COMMAND "結案日期"
        ON ACTION close_date
             LET g_action_choice="close_date"   #No.MOD-560195
            IF cl_chk_act_auth() THEN
               CALL t710_k()
            END IF
 
        #@COMMAND "備註"
        ON ACTION memo
           LET g_action_choice="memo"                     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                      #No.CHI-B70050 add
              LET g_msg="anmt700 '",g_nne.nne01,"' '1' "
              CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
           END IF                                         #No.CHI-B70050 add
 
        #@COMMAND "分錄底稿產生"
        ON ACTION gen_entry_sheet
           LET g_action_choice="gen_entry_sheet"          #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                      #No.CHI-B70050 add
              CALL t710_g_gl(g_nne.nne01,'0')
              IF g_aza.aza63 = 'Y' THEN
                 CALL t710_g_gl(g_nne.nne01,'1')
              END IF
           END IF                                          #No.CHI-B70050 add
 
        #@COMMAND "分錄底稿維護"
        ON ACTION maintain_entry_sheet
          #BugNo.+086 010502 by plum
           LET g_action_choice="maintain_entry_sheet"      #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                       #No.CHI-B70050 add
              CALL s_fsgl('NM',16,g_nne.nne01,0,g_nmz.nmz02b,0,g_nne.nneconf,'0',g_nmz.nmz02p)      #No.FUN-680088
              CALL cl_navigator_setting( g_curs_index, g_row_count )      #No.FUN-680088
              CALL t710_npp02('0')      #No.FUN-680088
           END IF                                           #No.CHI-B70050 add
 
        #@COMMAND "分錄底稿維護2"
        ON ACTION maintain_entry_sheet2
           LET g_action_choice="maintain_entry_sheet2"      #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                        #No.CHI-B70050 add
              CALL s_fsgl('NM',16,g_nne.nne01,0,g_nmz.nmz02c,0,g_nne.nneconf,'1',g_nmz.nmz02p) 
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              CALL t710_npp02('1')
           END IF                                           #No.CHI-B70050 add 

        #@COMMAND "確認"
        ON ACTION confirm
             LET g_action_choice="confirm"   #No.MOD-560195
            IF cl_chk_act_auth() THEN
               CALL t710_firm1()
               IF g_nne.nneconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
            END IF
 
        #@COMMAND "取消確認"
        ON ACTION undo_confirm
             LET g_action_choice="undo_confirm"   #No.MOD-560195
            IF cl_chk_act_auth() THEN
               CALL t710_firm2()
               IF g_nne.nneconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
            END IF
 
        ON ACTION carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_nne.nneconf = 'Y' THEN
                 CALL t710_carry_voucher()
              ELSE 
                 CALL cl_err('','atm-402',1)
              END IF
           END IF
        ON ACTION undo_carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_nne.nneconf = 'Y' THEN
                 CALL t710_undo_carry_voucher() 
              ELSE 
                 CALL cl_err('','atm-403',1)
              END IF
           END IF
 
        #@COMMAND "作廢"
        ON ACTION void
             LET g_action_choice="void"   #No.MOD-560195
            IF cl_chk_act_auth() THEN
               #CALL t710_x() #FUN-D20035 mark
               CALL t710_x(1) #FUN-D20035 add 
               IF g_nne.nneconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
            END IF
#FUN-D20035 add
        #@COMMAND "取消作廢"
        ON ACTION undo_void
             LET g_action_choice="undo_void"  
            IF cl_chk_act_auth() THEN
               CALL t710_x(2) 
               IF g_nne.nneconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
            END IF
#FUN-D20035 end
 
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_nne.nneconf = 'X' THEN
              LET g_void = 'Y'
           ELSE
              LET g_void = 'N'
           END IF
           CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t710_fetch('/')
        ON ACTION first
            CALL t710_fetch('F')
        ON ACTION last
            CALL t710_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_nne.nne01 IS NOT NULL THEN
               LET g_doc.column1 = "nne01"
               LET g_doc.value1 = g_nne.nne01
               CALL cl_doc()
             END IF
          END IF
            LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 	     #MOD-570244 mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t710_cs
END FUNCTION
 
FUNCTION t710_a()
DEFINE   l_sta    LIKE type_file.chr4        #No.FUN-680107 VARCHAR(04)
DEFINE li_result  LIKE type_file.num5        #No.FUN-550057 #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                # 清螢墓欄位內容
   INITIALIZE g_nne.* LIKE nne_file.*
   LET g_nne_t.* = g_nne.*
   LET g_nne.nne43 = g_plant   #MOD-5C0126
   LET g_nne.nne02 = TODAY     
   LET g_nne.nne12 = 0
   LET g_nne.nneex2 = 1
   LET g_nne.nne19 = 0
   LET g_nne.nne27 = 0
   LET g_nne.nne20 = 0
   LET g_nne.nne34 = 0     # 保證金率
   LET g_nne.nne291= 0     # 保證費用   #FUN-690076
   LET g_nne.nne29 = 0     # 保證費用
   LET g_nne.nne23 = 0     # 承銷費率
   LET g_nne.nne241= 0     # 承銷費用   #FUN-690076
   LET g_nne.nne24 = 0     # 承銷費用
   LET g_nne.nne36 = 0     # 簽證費率
   LET g_nne.nne371= 0     # 簽證費用   #FUN-690076
   LET g_nne.nne37 = 0     # 簽證費用
   LET g_nne.nne45 = 0     # 交割服務費率   #FUN-640242
   LET g_nne.nne461= 0     # 交割服務費用   #FUN-690076
   LET g_nne.nne46 = 0     # 交割服務費用   #FUN-640242
   LET g_nne.nne25 = 0     # 本票折價
   LET g_nne.nne41 = 'N'
   LET g_nne.nne31 = ''
   LET g_nne.nne32 = 'N' #開帳否 No:8614
   LET g_nne.nne42 = 0
   LET g_nne.nneconf = 'N'
   LET g_nne01_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_nne.nneuser = g_user
      LET g_nne.nneoriu = g_user #FUN-980030
      LET g_nne.nneorig = g_grup #FUN-980030
      LET g_nne.nnegrup = g_grup               #使用者所屬群
      LET g_nne.nnedate = g_today
      LET g_nne.nnelegal= g_legal
 
      CALL t710_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_nne.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      BEGIN WORK  #No.7875
        CALL s_auto_assign_no("anm",g_nne.nne01,g_nne.nne02,"4","nne_file","nne01","","","")
             RETURNING li_result,g_nne.nne01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nne.nne01
 
 
      IF g_nne.nne01 IS NULL THEN
         CONTINUE WHILE
      END IF
 
 
      INSERT INTO nne_file VALUES(g_nne.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nne_file",g_nne.nne01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK #No.7875
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No.7875
         CALL cl_flow_notify(g_nne.nne01,'I')
      END IF
 
      LET g_nne_t.* = g_nne.*                # 保存上筆資料
      SELECT nne01 INTO g_nne.nne01 FROM nne_file
       WHERE nne01 = g_nne.nne01
 
       IF g_nnn06 <> "1" THEN   #No.MOD-540078
         IF g_nmy.nmydmy3 = 'Y' THEN   #No.8614
            CALL t710_4()
         END IF                        #No.8614
      END IF                        #No.8614
 
       LET g_t1 = s_get_doc_no(g_nne.nne01)       #No.FUN-550057
 
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
 
      IF g_nmy.nmydmy1 = 'Y' THEN
         CALL t710_firm1()
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t710_i(p_cmd)
   DEFINE l_aag02         LIKE aag_file.aag02,   #No.FUN-680107 VARCHAR(30)
          p_cmd           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cmd           LIKE type_file.chr50,  #No.FUN-680107 VARCHAR(50)
          l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
          l_nmo02         LIKE nmo_file.nmo02,   #票別說明
          l_nnp07         LIKE nnp_file.nnp07,   #
          l_nnn02         LIKE nnn_file.nnn02,   #
          l_nma02         LIKE nma_file.nma02,
          l_nml02         LIKE nml_file.nml02,
          l_temp          LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #add03/01/07   #No.FUN-4C0010
          l_tmp,l_days    LIKE type_file.num10,  #No.FUN-680107 INTEGER
          l_n             LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_cnt           LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          last_date       LIKE type_file.dat,    #No.FUN-680107 DATE
          l_nab02         LIKE nab_file.nab02,   #add 03/01/07
          l_nnn06         LIKE nnn_file.nnn06,   #add 03/01/07
          li_result       LIKE type_file.num5,   #No.FUN-550057  #No.FUN-680107 SMALLINT
          l_nno05         LIKE nno_file.nno05,   #MOD-740228
          l_nnp05         LIKE nnp_file.nnp05    #MOD-9B0206 add
 
   INPUT BY NAME g_nne.nneoriu,g_nne.nneorig,g_nne.nne43,g_nne.nne01,g_nne.nne32,g_nne.nne02,g_nne.nne03, #No:8614 add nne32
                 g_nne.nne30,g_nne.nne04,g_nne.nne06,g_nne.nne05,g_nne.nne051,
                 g_nne.nne28,g_nne.nne44,g_nne.nne07,g_nne.nne08,g_nne.nne09,
                 g_nne.nne10,g_nne.nneconf,g_nne.nneglno,g_nne.nne33, #No:8614 add nne33
                 g_nne.nne26,g_nne.nne111,g_nne.nne112,g_nne.nne16,g_nne.nne17,
                 g_nne.nneex2,g_nne.nne12,g_nne.nne19,g_nne.nne13,g_nne.nne14,
                 g_nne.nne21,g_nne.nne22,g_nne.nne27,g_nne.nne20,g_nne.nne41,
                 g_nne.nne31,g_nne.nne42,g_nne.nne18,g_nne.nne35,g_nne.nne38,
                 g_nne.nne15,g_nne.nne25,g_nne.nne34,g_nne.nne23,g_nne.nne36,g_nne.nne45,  #FUN-640242
                 g_nne.nne291,g_nne.nne241,g_nne.nne371,g_nne.nne461,g_nne.nne29,g_nne.nne24,g_nne.nne37,g_nne.nne46,g_nne.nne_d1,g_nne.nne_d2,   #FUN-690076
                 g_nne.nne_d4,g_nne.nne_d5,g_nne.nne_d6,g_nne.nne_d7,g_nne.nne_c1, #No.7901   #FUN-640242
                 g_nne.nne_d11,g_nne.nne_d21,g_nne.nne_d41,g_nne.nne_d51,g_nne.nne_d61,      #No.FUN-680088
                 g_nne.nne_d71,g_nne.nne_c11,      #No.FUN-680088
                 g_nne.nneuser,g_nne.nnegrup,g_nne.nnemodu,g_nne.nnedate
                 ,g_nne.nneud01,g_nne.nneud02,g_nne.nneud03,g_nne.nneud04,
                 g_nne.nneud05,g_nne.nneud06,g_nne.nneud07,g_nne.nneud08,
                 g_nne.nneud09,g_nne.nneud10,g_nne.nneud11,g_nne.nneud12,
                 g_nne.nneud13,g_nne.nneud14,g_nne.nneud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t710_set_entry(p_cmd)
         CALL t710_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nne01")
         CALL cl_set_docno_format("nne28")
 
        AFTER FIELD nne43
          IF NOT cl_null(g_nne.nne43) THEN
             SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw01 = g_nne.nne43
                AND azw02 = g_legal
             IF l_n = 0  THEN
                CALL cl_err('sel_azw','agl-171',0)
                NEXT FIELD nne43
             END IF
          END IF
 
        AFTER FIELD nne44   #部門
           IF NOT cl_null(g_nne.nne44) THEN  #No:8614
              SELECT count(*) INTO l_n FROM gem_file
               WHERE gem01=g_nne.nne44
                 AND gemacti='Y'
              IF STATUS OR l_n<=0 THEN
                 NEXT FIELD nne44
              END IF
              CALL t710_default_acctno1()    #No.TQC-CA0055   Add
           END IF
 
        AFTER FIELD nne01   #融資單號
           IF NOT cl_null(g_nne.nne01) AND (g_nne.nne01!=g_nne_t.nne01) THEN
    CALL s_check_no("anm",g_nne.nne01,g_nne01_t,"4","nne_file","nne01","")
         RETURNING li_result,g_nne.nne01
    DISPLAY BY NAME g_nne.nne01
       IF (NOT li_result) THEN
          NEXT FIELD nne01
       END IF
           END IF
 
        AFTER FIELD nne32
           IF g_nne.nne32 NOT MATCHES '[YN]'  THEN
              NEXT FIELD nne32
           END IF
           CALL t710_set_entry(p_cmd)        #MOD-CA0017 add
           CALL t710_set_no_entry(p_cmd)     #MOD-CA0017 add
 
        AFTER FIELD nne02
           IF NOT cl_null(g_nne.nne02) THEN
              IF g_nne.nne02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1)
                 NEXT FIELD nne02
              END IF
           END IF
 
        BEFORE FIELD nne03
           IF cl_null(g_nne.nne03) THEN
              LET g_nne.nne03 = g_nne.nne02
              DISPLAY BY NAME g_nne.nne03
           END IF

        #CHI-B30035 add --start--
        AFTER FIELD nne03
           IF NOT cl_null(g_nne.nne03) THEN
              IF NOT cl_null(g_nne.nne02) THEN
                 IF g_nne.nne03 < g_nne.nne02 THEN
                    CALL cl_err('','anm-127',1)
                    NEXT FIELD nne03 
                 END IF
              END IF
           END IF
        #CHI-B30035 add --end--
 
        AFTER FIELD nne30   #合約編號
           IF NOT cl_null(g_nne.nne30) THEN
              CALL t710_nne30('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne30,g_errno,0)
                 LET g_nne.nne30=g_nne_t.nne30
                 DISPLAY BY NAME g_nne.nne30
                 NEXT FIELD nne30
              END IF
               LET l_nno05 = ''
               SELECT nno05 INTO l_nno05 FROM nno_file
                 WHERE nno01=g_nne.nne30
               IF l_nno05 < g_nne.nne03 THEN
                  CALL cl_err(g_nne.nne30,'anm-320',0)
                  NEXT FIELD nne30
               END IF
              SELECT nnp05,nnp07,nnp08
                INTO l_nnp05,g_nne.nne16,g_nne.nneex2       #MOD-9B0206
                FROM nnp_file
               WHERE nnp01 = g_nne.nne30
                 AND nnp03 = g_nne.nne06
              IF cl_null(g_nne.nne13) OR g_nne.nne13=0 THEN
                 LET g_nne.nne13 = l_nnp05
              END IF
              DISPLAY BY NAME g_nne.nne13,g_nne.nne16,g_nne.nneex2
              #TQC-DA0035 add begin ---
              CALL t710_check_nne12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD nne30
              END IF
              #TQC-DA0035 add end -----
           END IF
 
        AFTER FIELD nne04   #信貸銀行編號
          IF NOT cl_null(g_nne.nne04) THEN
             CALL t710_nne04('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nne.nne04,g_errno,0)
                LET g_nne.nne04=g_nne_t.nne04
                DISPLAY BY NAME g_nne.nne04
                NEXT FIELD nne04
             END IF
          END IF
 
        BEFORE FIELD nne06
           CALL t710_set_entry(p_cmd)
 
        AFTER FIELD nne06   #融資種類
           IF NOT cl_null(g_nne.nne06)  THEN
              CALL t710_nne06('u')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne06,g_errno,0)
                 LET g_nne.nne06=g_nne_t.nne06
                 DISPLAY BY NAME g_nne.nne06
                 DISPLAY '' TO FORMONLY.nnn02
                 NEXT FIELD nne06
              END IF
              SELECT nnp07 INTO l_nnp07 FROM nnp_file
               WHERE nnp01 = g_nne.nne30
                 AND nnp03 = g_nne.nne06
              IF g_nne.nne16 IS NULL THEN
                 LET g_nne.nne16 = l_nnp07
              END IF
              SELECT nnp05,nnp07,nnp08
                INTO l_nnp05,g_nne.nne16,g_nne.nneex2       #MOD-9B0206
                FROM nnp_file
               WHERE nnp01 = g_nne.nne30
                 AND nnp03 = g_nne.nne06
              IF cl_null(g_nne.nne13) OR g_nne.nne13=0 THEN
                 LET g_nne.nne13 = l_nnp05
              END IF
              DISPLAY BY NAME g_nne.nne13,g_nne.nne16,g_nne.nneex2
              LET g_nnn06 = null
              LET g_nnn07 = null                          #MOD-B50191
              SELECT nnn06,nnn07 INTO g_nnn06,g_nnn07     #MOD-B50191 add nnn07
                FROM nnn_file WHERE nnn01 = g_nne.nne06
              IF g_nnn06 NOT MATCHES '[23]' THEN
                 LET g_nne.nne25=0
                 DISPLAY BY NAME g_nne.nne25
              END IF
              #TQC-DA0035 add begin ---
              CALL t710_check_nne12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD nne06
              END IF
              #TQC-DA0035 add end -----
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nne.nne06 != g_nne_o.nne06) THEN   #MOD-C20173 add
                 CALL t710_default_acctno()     #MOD-B20141
              END IF                                                                  #MOD-C20173 add
           END IF
 
           CALL t710_set_entry(p_cmd)        #MOD-B50191
           CALL t710_set_no_entry(p_cmd)
 
         BEFORE FIELD nne41     #No.MOD-540078
           CALL t710_set_entry(p_cmd)
 
        AFTER FIELD nne41
           IF NOT cl_null(g_nne.nne41) THEN
              IF g_nne.nne41 NOT MATCHES '[YN]' THEN
                 NEXT FIELD nne41
              END IF
           END IF
            CALL t710_set_no_entry(p_cmd)   #No.MOD-540078
 
        BEFORE FIELD nne31
           IF g_nne.nne41 <> 'Y' THEN
              LET g_nne.nne42 = 0
              DISPLAY BY NAME g_nne.nne42
           END IF
 
        AFTER FIELD nne31
           IF NOT cl_null(g_nne.nne31) THEN
              SELECT nab02 INTO l_nab02 FROM nab_file WHERE nab01 = g_nne.nne31
              IF STATUS THEN NEXT FIELD nne31 END IF
           END IF
 
        BEFORE FIELD nne42
           IF g_nne.nne41 <> 'Y' THEN
              LET g_nne.nne42 = 0
              DISPLAY BY NAME g_nne.nne42
           END IF
 
         BEFORE FIELD nne05   #No.MOD-530898
           CALL t710_set_entry(p_cmd)
 
        AFTER FIELD nne05   #銀行編號
           IF NOT cl_null(g_nne.nne05) THEN
              CALL t710_nne05('a')
              LET l_cnt = 0
              IF NOT cl_null(g_nne.nne28) THEN   #參考單號不是空的
                 SELECT COUNT(*) INTO l_cnt FROM alh_file
                  WHERE alh01=g_nne.nne28 AND alh44='2'   #aapt820拋轉過來的
                 IF l_cnt > 0 THEN
                    LET g_errno = ''
                    DISPLAY '' TO FORMONLY.nma02
                 END IF
              END IF
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne05,g_errno,0)
                 LET g_nne.nne05=g_nne_t.nne05
                 DISPLAY BY NAME g_nne.nne05
                 NEXT FIELD nne05
              ELSE
                 IF l_cnt = 0 THEN   #MOD-930296 add
                    SELECT nma10 INTO g_nma10 FROM nma_file
                     WHERE nma01 = g_nne.nne05
                    IF g_nma10 <> g_nne.nne16 THEN
                       CALL cl_err(g_nne.nne05,'anm-048',0)
                       NEXT FIELD nne05
                    END IF
                 END IF              #MOD-930296 add
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nne.nne05 != g_nne_o.nne05) THEN   #MOD-C20173 add
                 CALL t710_default_acctno()     #MOD-B20141
              END IF                                                                  #MOD-C20173 add
           END IF
          #------------------------MOD-C90257------------(S)
           IF g_nnn07 = 'Y' THEN
              IF cl_null(g_nne.nne05) THEN
                 CALL cl_err(g_nne.nne05,'azz-310',0)
                 NEXT FIELD nne05
              END IF
           END IF
          #------------------------MOD-C90257------------(E)
           CALL t710_set_no_entry(p_cmd)  #No.MOD-530898
 
        AFTER FIELD nne051
           IF cl_null(g_nne.nne051) AND NOT cl_null(g_nne.nne05) THEN
              NEXT FIELD nne051
           END IF
           IF NOT cl_null(g_nne.nne051)  THEN
              CALL t710_nmc('a',g_nne.nne051,'1')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne051,g_errno,0)
                 NEXT FIELD nne051
              #TQC-CC0022--add--str
              ELSE
                 LET g_nmc02 = ''
                 SELECT nmc02 INTO g_nmc02 FROM nmc_file
                  WHERE nmc01 = g_nne.nne051
                 DISPLAY g_nmc02 TO nmc02
              #TQC-CC0022--add--end
              END IF
           END IF
 
        AFTER FIELD nne07  #擔保品
           IF NOT cl_null(g_nne.nne07) THEN
              IF g_nne.nne07 NOT MATCHES '[12]' THEN
                 NEXT FIELD nne07
              END IF
           END IF
 
        AFTER FIELD nne08   #付息方式
           IF NOT cl_null(g_nne.nne08) THEN
              IF g_nne.nne08 NOT MATCHES '[12]' THEN
                 NEXT FIELD nne08
              END IF
           END IF
 
        AFTER FIELD nne09   #計息方式
           IF NOT cl_null(g_nne.nne09) THEN
              IF g_nne.nne09 NOT MATCHES '[12]' THEN
                 NEXT FIELD nne09
              END IF
           END IF
 
        BEFORE FIELD nne111
           IF g_nne.nne111 IS NULL THEN
              LET g_nne.nne111 = g_nne.nne03
              DISPLAY BY NAME g_nne.nne111
           END IF
 
        AFTER FIELD nne111   #起始日
           IF NOT cl_null(g_nne.nne111) THEN
              IF NOT cl_null(g_nne.nne12) AND NOT cl_null(g_nne.nne111) THEN
                 LET l_days = g_nne.nne112 - g_nne.nne111
                 DISPLAY l_days TO FORMONLY.days
              END IF
              IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
                 IF (g_nne_t.nne111 IS NULL OR g_nne_t.nne111 <> g_nne.nne111) THEN
                    LET g_dec6=1-(g_nne.nne13/100*(g_nne.nne112-g_nne.nne111)/365)
                    LET g_nne.nne25=g_nne.nne19-(g_nne.nne19*g_dec6)
                    CALL cl_digcut(g_nne.nne25,g_azi04) RETURNING g_nne.nne25
                    DISPLAY BY NAME g_nne.nne25
                 END IF
              ELSE
                 LET g_nne.nne25=0
                 DISPLAY BY NAME g_nne.nne25
              END IF
           END IF
 
        AFTER FIELD nne112   #截止日
           IF NOT cl_null(g_nne.nne112) THEN
              IF g_nne.nne112 < g_nne.nne111 THEN
                 CALL cl_err(g_nne.nne112,'anm-091',0)
                 NEXT FIELD nne112
              END IF
             #------------------MOD-D10187-------------mark
             ##No.TQC-B60092  --Begin
             #LET l_nno05 = ''
             #SELECT nno05 INTO l_nno05 FROM nno_file WHERE nno01=g_nne.nne30
             #IF l_nno05 < g_nne.nne112 THEN
             #   CALL cl_err(g_nne.nne112,'anm1017',0)
             #   NEXT FIELD nne112
             #END IF
             ##No.TQC-B60092  --End
             #------------------MOD-D10187-------------mark
              IF NOT cl_null(g_nne.nne12) AND NOT cl_null(g_nne.nne111) THEN
                 LET l_days = g_nne.nne112 - g_nne.nne111
                 DISPLAY l_days TO FORMONLY.days
              END IF
              IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
                 IF (g_nne_t.nne112 IS NULL OR g_nne_t.nne112 <> g_nne.nne112) THEN
                    LET g_dec6=1-(g_nne.nne13/100*(g_nne.nne112-g_nne.nne111)/365)
                    LET g_nne.nne25=g_nne.nne19-(g_nne.nne19*g_dec6)
                    CALL cl_digcut(g_nne.nne25,g_azi04) RETURNING g_nne.nne25
                    DISPLAY BY NAME g_nne.nne25
                 END IF
              ELSE
                 LET g_nne.nne25=0
                 DISPLAY BY NAME g_nne.nne25
              END IF
           END IF
    
        AFTER FIELD nne13
           IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
              IF NOT cl_null(g_nne.nne13) AND 
                 (g_nne_t.nne13 IS NULL OR g_nne_t.nne13 <> g_nne.nne13) THEN
                 LET g_dec6=1-(g_nne.nne13/100 * (g_nne.nne112-g_nne.nne111)/365)
                 LET g_nne.nne25 = g_nne.nne19 - (g_nne.nne19*g_dec6)
                 CALL cl_digcut(g_nne.nne25,g_azi04) RETURNING g_nne.nne25
                 DISPLAY BY NAME g_nne.nne25
              END IF
           ELSE
              LET g_nne.nne25=0
              DISPLAY BY NAME g_nne.nne25
           END IF
           IF g_nne.nne13 <0 THEN                                               
              CALL cl_err(g_nne.nne13,'aim-391',1)                              
              LET g_nne.nne13 = g_nne_t.nne13                                   
              NEXT FIELD nne13                                                  
           END IF                                                               
 
        BEFORE FIELD nne14
            IF g_nne.nne14 IS NULL THEN
               LET g_nne.nne14 = g_nne.nne13
               DISPLAY BY NAME g_nne.nne14
            END IF
 
        AFTER FIELD nne14   #還款利率
           IF NOT cl_null(g_nne.nne14) THEN
              IF g_nne.nne14 < 0 THEN
                 CALL cl_err(g_nne.nne14,'aim-391',0)  NEXT FIELD nne14     #No.TQC-9B0092
              END IF
           END IF
 
        AFTER FIELD nne15   #L/C no
           IF NOT cl_null(g_nne.nne15) THEN
              SELECT * FROM ala_file
               WHERE ala03 = g_nne.nne15 AND alafirm <> 'X'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","ala_file",g_nne.nne15,"",STATUS,"","sel ala:",1)  #No.FUN-660148
                 NEXT FIELD nne15
              END IF
           END IF
 
        AFTER FIELD nne35   #他保銀行
           IF NOT cl_null(g_nne.nne35) THEN
              SELECT nmt02 INTO l_nma02 FROM nmt_file WHERE nmt01=g_nne.nne35 #MOD-5B0290 add
              IF STATUS THEN
                 CALL cl_err3("sel","nmt_file",g_nne.nne35,"",STATUS,"","sel nma:",1)  #No.FUN-660148
                 NEXT FIELD nne35
              END IF
              DISPLAY l_nma02 TO FORMONLY.k
           END IF
 
        BEFORE FIELD nne38
           IF cl_null(g_nne.nne35) THEN
              LET g_nne.nne38='  '
              DISPLAY BY NAME g_nne.nne38
              DISPLAY '' TO k
              NEXT FIELD nne15
           END IF
 
        AFTER FIELD nne38
          IF NOT cl_null(g_nne.nne38) THEN
             CALL t710_nmc('a',g_nne.nne38,'2')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nne.nne38,g_errno,0) NEXT FIELD nne38
             END IF
          END IF
 
        AFTER FIELD nne16   #幣別
           IF NOT cl_null(g_nne.nne16) THEN
              SELECT azi04 INTO t_azi04 FROM azi_file
               WHERE azi01 = g_nne.nne16
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","azi_file",g_nne.nne16,"","anm-040","","sel azi:",1)  #No.FUN-660148
                 NEXT FIELD nne16
              END IF
             #----------------------------------MOD-BB0211-------------------------start
              IF cl_null(g_nne_t.nne16) OR (NOT cl_null(g_nne_t.nne16) AND g_nne_t.nne16!=g_nne.nne16) THEN
                 LET g_nne.nne17=s_curr3(g_nne.nne16,g_nne.nne03,'S')
                 DISPLAY BY NAME g_nne.nne17
                 IF g_nne.nne12 >0 THEN
                    LET g_nne.nne19 = g_nne.nne12 * g_nne.nne17
                    CALL cl_digcut(g_nne.nne19,g_azi04) RETURNING g_nne.nne19
                    DISPLAY BY NAME g_nne.nne19
                 END IF
              END IF
              #TQC-DA0035 add begin ---
              CALL t710_check_nne12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD nne16
              END IF
              #TQC-DA0035 add end -----
              LET g_nne_t.nne16 = g_nne.nne16
             #----------------------------------MOD-BB0211---------------------------end
           END IF

       #-----------------------MOD-BB0211------------------------------mark 
       #BEFORE FIELD nne17
       #    IF cl_null(g_nne.nne17) OR g_nne.nne17 = 0 THEN
       #       LET g_nne.nne17=s_curr3(g_nne.nne16,g_nne.nne03,'S')
       #       DISPLAY BY NAME g_nne.nne17
       #    END IF
       #-----------------------MOD-BB0211------------------------------mark
 
        AFTER FIELD nne17   #匯率
           IF NOT cl_null(g_nne.nne17) THEN
              IF g_nne.nne17 = 0 THEN
                 CALL cl_err(g_nne.nne17,'anm-003',0)
                 NEXT FIELD nne17
              END IF
 
              IF g_nne.nne16 =g_aza.aza17 THEN
                 LET g_nne.nne17  =1
                 DISPLAY BY NAME g_nne.nne17
              END IF
 
              #TQC-DA0035 add begin ---
              CALL t710_check_nne12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD nne17
              END IF
              #TQC-DA0035 add end -----
           END IF
 
        AFTER FIELD nne18   #現金變動碼
            IF NOT cl_null(g_nne.nne18) THEN
               SELECT nml02 INTO l_nml02 FROM nml_file
                WHERE nml01 = g_nne.nne18 AND nmlacti = 'Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","nml_file",g_nne.nne18,"","anm-006","","",1)  #No.FUN-660148
                  NEXT FIELD nne18
               END IF
               DISPLAY l_nml02 TO FORMONLY.nml02
            END IF
 
        AFTER FIELD nne12
           IF NOT cl_null(g_nne.nne12) THEN
              CALL cl_digcut(g_nne.nne12,t_azi04) RETURNING g_nne.nne12
              DISPLAY BY NAME g_nne.nne12
              LET g_nne.nne19 = g_nne.nne12 * g_nne.nne17
              CALL cl_digcut(g_nne.nne19,g_azi04) RETURNING g_nne.nne19
              DISPLAY BY NAME g_nne.nne19
              #TQC-DA0035 add begin ---
              CALL t710_check_nne12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD nne12
              END IF
              #TQC-DA0035 add end -----
             #TQC-DA0035 mark begin --- 
             #CALL s_credit2('N',g_nne.nne04,g_nne.nne30,g_nne.nne06)   
             #             RETURNING amty,amtu,u_amty,u_amtu,bal
             #                # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
              IF g_nne_t.nne19 IS NULL THEN LET g_nne_t.nne19 = 0 END IF
             #LET bal=bal-(g_nne.nne12*g_nne.nneex2)   #MOD-840250
             #IF bal<0 THEN
             #   call cl_err('','anm-287',1)
             #   NEXT FIELD nne12             #MOD-8C0145
             #END IF
             #TQC-DA0035 mark end  ----
              IF g_nne.nne12 <0 THEN                                            
                 CALL cl_err(g_nne.nne12,'aim-391',1)                           
                 LET g_nne.nne12 = g_nne_t.nne12                                
                 NEXT FIELD nne12                                               
              END IF                                                            
           END IF
 
        AFTER FIELD nne19
           IF NOT cl_null(g_nne.nne19) THEN
              CALL cl_digcut(g_nne.nne19,g_azi04) RETURNING g_nne.nne19
              DISPLAY BY NAME g_nne.nne19
              IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
                 IF (g_nne_t.nne19 IS NULL OR g_nne_t.nne19 <> g_nne.nne19) THEN
                    LET g_dec6=1-(g_nne.nne13/100*(g_nne.nne112-g_nne.nne111)/365)
                    LET g_nne.nne25=g_nne.nne19-(g_nne.nne19*g_dec6)
                    CALL cl_digcut(g_nne.nne25,g_azi04) RETURNING g_nne.nne25
                    DISPLAY BY NAME g_nne.nne25
                 END IF
              ELSE
                 LET g_nne.nne25=0
                 DISPLAY BY NAME g_nne.nne25
              END IF
              IF g_nne.nne19 <0 THEN                                            
                 CALL cl_err(g_nne.nne19,'aim-391',1)                           
                 LET g_nne.nne19 = g_nne_t.nne19                                
                 NEXT FIELD nne19                                               
              END IF                                                            
           END IF
 
        #TQC-C80199--add--str--
        AFTER FIELD nne21
           IF NOT cl_null(g_nne.nne21) THEN
              LET l_nno05 = ''
              SELECT nno05 INTO l_nno05 FROM nno_file WHERE nno01=g_nne.nne30
              IF l_nno05 < g_nne.nne21 THEN
                 CALL cl_err(g_nne.nne21,'anm-182',0)
                 NEXT FIELD nne21
              END IF
           END IF
        #TQC-C80199--add--end--

        AFTER FIELD nne22  #還息日
            IF NOT cl_null(g_nne.nne22) THEN
               IF g_nne.nne22 < 1 OR g_nne.nne22 > 31 THEN
                  NEXT FIELD nne22
               END IF
            END IF
 
        AFTER FIELD nne34  #保證金利率
           IF p_cmd = "a" OR (p_cmd = "u" AND g_nne_o.nne34 <> g_nne.nne34) THEN    #No.MOD-B80231 add
              IF NOT cl_null(g_nne.nne34) THEN
                 IF g_nne.nne34 < 0 THEN
                    NEXT FIELD nne34
                 END IF
                 LET g_nne.nne291 = g_nne.nne12 * g_nne.nne34/100 *
                                   ((g_nne.nne112-g_nne.nne111)/365)
                 CALL cl_digcut(g_nne.nne291,t_azi04) RETURNING g_nne.nne291
                 DISPLAY BY NAME g_nne.nne291
                 LET g_nne.nne29 = g_nne.nne291 * g_nne.nne17
                 CALL cl_digcut(g_nne.nne29,g_azi04) RETURNING g_nne.nne29
                 DISPLAY BY NAME g_nne.nne29
              END IF
           END IF                                                                      #No.MOD-B80231 add
 
        AFTER FIELD nne23  #承銷費率
           IF p_cmd = "a" OR (p_cmd = "u" AND g_nne_o.nne23 <> g_nne.nne23) THEN    #No.MOD-B80231 add
              IF NOT cl_null(g_nne.nne23) THEN
                 IF g_nne.nne23 < 0 THEN
                    NEXT FIELD nne23
                 END IF
                 LET g_nne.nne241 = g_nne.nne12 * g_nne.nne23/100 *
                                    ((g_nne.nne112-g_nne.nne111)/365)
                 CALL cl_digcut(g_nne.nne241,t_azi04) RETURNING g_nne.nne241
                 DISPLAY BY NAME g_nne.nne241
                 LET g_nne.nne24 = g_nne.nne241 * g_nne.nne17
                 CALL cl_digcut(g_nne.nne24,g_azi04) RETURNING g_nne.nne24
                 DISPLAY BY NAME g_nne.nne24
              END IF
           END IF                                                                       #No.MOD-B80231 add
 
        AFTER FIELD nne36  #簽證費率
           IF p_cmd = "a" OR (p_cmd = "u" AND g_nne_o.nne36 <> g_nne.nne36) THEN    #No.MOD-B80231 add
              IF NOT cl_null(g_nne.nne36) THEN
                 IF g_nne.nne36 < 0 THEN
                    NEXT FIELD nne36
                 END IF
                 LET g_nne.nne371 = g_nne.nne12 * g_nne.nne36/100 *
                                   ((g_nne.nne112-g_nne.nne111)/365)
                 CALL cl_digcut(g_nne.nne371,t_azi04) RETURNING g_nne.nne371
                 DISPLAY BY NAME g_nne.nne371
                 LET g_nne.nne37 = g_nne.nne371 * g_nne.nne17
                 CALL cl_digcut(g_nne.nne37,g_azi04) RETURNING g_nne.nne37
                 DISPLAY BY NAME g_nne.nne37
              END IF
           END IF                                                                        #No.MOD-B80231 add
 
        AFTER FIELD nne45  #交割服務費率
           IF p_cmd = "a" OR (p_cmd = "u" AND g_nne_o.nne45 <> g_nne.nne45) THEN    #No.MOD-B80231 add
              IF NOT cl_null(g_nne.nne45) THEN
                 IF g_nne.nne45 < 0 THEN
                    NEXT FIELD nne45
                 END IF
                 LET g_nne.nne461 = g_nne.nne12 * g_nne.nne45/100 *
                                   ((g_nne.nne112-g_nne.nne111)/365)
                 CALL cl_digcut(g_nne.nne461,t_azi04) RETURNING g_nne.nne461
                 DISPLAY BY NAME g_nne.nne461
                 LET g_nne.nne46 = g_nne.nne461 * g_nne.nne17
                 CALL cl_digcut(g_nne.nne46,g_azi04) RETURNING g_nne.nne46
                 DISPLAY BY NAME g_nne.nne46
              END IF
           END IF                                                                       #No.MOD-B80231 add
 
        BEFORE FIELD nne25   #
          LET g_nnn06 = null
          SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
          IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN
             IF YEAR(g_nne.nne111)*12+MONTH(g_nne.nne111)<>
                YEAR(g_nne.nne112)*12+MONTH(g_nne.nne112) THEN
                LET last_date= s_monend(YEAR(g_nne.nne111),MONTH(g_nne.nne111))
             ELSE
                LET last_date=g_nne.nne112
             END IF
             LET g_nne.nne25 = g_nne.nne19 * g_nne.nne13/100
             LET g_dec6=1-(g_nne.nne13/100 * (g_nne.nne112-g_nne.nne111)/365)
             LET g_nne.nne25 = g_nne.nne19 - (g_nne.nne19*g_dec6)
             CALL cl_digcut(g_nne.nne25,g_azi04) RETURNING g_nne.nne25
             DISPLAY BY NAME g_nne.nne25
          END IF
 
        #BEFORE FIELD nne_d1               #No.MOD-540078 #MOD-C20173 mark
        #     CALL t710_default_acctno()   #MOD-C20173 mark
        #No.TQC-CA0055 ---start--- Add
         BEFORE FIELD nne_d1
            CALL t710_default_acctno1()
        #No.TQC-CA0055 ---end --- Add

        AFTER FIELD nne_d1
           IF NOT cl_null(g_nne.nne_d1) THEN
              CALL t710_aag(g_nne.nne_d1,'0') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d1,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d1,'23',g_bookno1)    
                    RETURNING g_nne.nne_d1
                 DISPLAY BY NAME g_nne.nne_d1
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d1
              ELSE
                 DISPLAY l_aag02 TO aag02_d1
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d1
           #No.TQC-B60097--end--
           END IF
           
        AFTER FIELD nne_d2
           IF NOT cl_null(g_nne.nne_d2) THEN
              CALL t710_aag(g_nne.nne_d2,'0') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d2,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d2,'23',g_bookno1)
                   RETURNING g_nne.nne_d2
                 DISPLAY BY NAME g_nne.nne_d2
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d2
              ELSE
                 DISPLAY l_aag02 TO aag02_d2
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d2
           #No.TQC-B60097--end--
           END IF
 
      BEFORE FIELD nne29
         CALL t710_set_required(p_cmd)
 
      AFTER FIELD nne29
         CALL t710_set_no_required(p_cmd)
         LET g_nne.nne29 = cl_digcut(g_nne.nne29,g_azi04)
         DISPLAY BY NAME g_nne.nne29
 
      BEFORE FIELD nne24
         CALL t710_set_required(p_cmd)
 
      AFTER FIELD nne24
         CALL t710_set_no_required(p_cmd)
         LET g_nne.nne24 = cl_digcut(g_nne.nne24,g_azi04)
         DISPLAY BY NAME g_nne.nne24
 
      BEFORE FIELD nne37
         CALL t710_set_required(p_cmd)
 
      AFTER FIELD nne37
         CALL t710_set_no_required(p_cmd)
         LET g_nne.nne37 = cl_digcut(g_nne.nne37,g_azi04)
         DISPLAY BY NAME g_nne.nne37
 
      BEFORE FIELD nne46
         CALL t710_set_required(p_cmd)
 
      AFTER FIELD nne46
         CALL t710_set_no_required(p_cmd)
         LET g_nne.nne46 = cl_digcut(g_nne.nne46,g_azi04)
         DISPLAY BY NAME g_nne.nne46
 
      AFTER FIELD nne291
         LET g_nne.nne291 = cl_digcut(g_nne.nne291,t_azi04)
         DISPLAY BY NAME g_nne.nne291
         LET g_nne.nne29 = g_nne.nne291 * g_nne.nne17                #No.MOD-B80231 add
         CALL cl_digcut(g_nne.nne29,g_azi04) RETURNING g_nne.nne29   #No.MOD-B80231 add
         DISPLAY BY NAME g_nne.nne29                                 #No.MOD-B80231 add

      AFTER FIELD nne241
         LET g_nne.nne241 = cl_digcut(g_nne.nne241,t_azi04)
         DISPLAY BY NAME g_nne.nne241
         LET g_nne.nne24 = g_nne.nne241 * g_nne.nne17                #No.MOD-B80231 add
         CALL cl_digcut(g_nne.nne24,g_azi04) RETURNING g_nne.nne24   #No.MOD-B80231 add
         DISPLAY BY NAME g_nne.nne24                                 #No.MOD-B80231 add

      AFTER FIELD nne371
         LET g_nne.nne371 = cl_digcut(g_nne.nne371,t_azi04)
         DISPLAY BY NAME g_nne.nne371
         LET g_nne.nne37 = g_nne.nne371 * g_nne.nne17                #No.MOD-B80231 add
         CALL cl_digcut(g_nne.nne37,g_azi04) RETURNING g_nne.nne37   #No.MOD-B80231 add
         DISPLAY BY NAME g_nne.nne37                                 #No.MOD-B80231 add

      AFTER FIELD nne461
         LET g_nne.nne461 = cl_digcut(g_nne.nne461,t_azi04)
         DISPLAY BY NAME g_nne.nne461
         LET g_nne.nne46 = g_nne.nne461 * g_nne.nne17                #No.MOD-B80231 add
         CALL cl_digcut(g_nne.nne46,g_azi04) RETURNING g_nne.nne46   #No.MOD-B80231 add
         DISPLAY BY NAME g_nne.nne46                                 #No.MOD-B80231 add 
 
      AFTER FIELD nne_d4
         IF NOT cl_null(g_nne.nne_d4) THEN
            CALL t710_aag(g_nne.nne_d4,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d4,g_errno,0) 
#FUN-B20073 --begin---
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d4,'23',g_bookno1) 
                     RETURNING g_nne.nne_d4
               DISPLAY BY NAME g_nne.nne_d4
#FUN-B20073 --end--               
               NEXT FIELD nne_d4
            ELSE
               DISPLAY l_aag02 TO aag02_d4
            END IF
         #No.TQC-B60097--add--
         ELSE
            LET l_aag02=NULL
            DISPLAY l_aag02 TO aag02_d4
         #No.TQC-B60097--end--
         END IF
         
      AFTER FIELD nne_d5
         IF NOT cl_null(g_nne.nne_d5) THEN
            CALL t710_aag(g_nne.nne_d5,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d5,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d5,'23',g_bookno1) 
                     RETURNING g_nne.nne_d5
               DISPLAY BY NAME g_nne.nne_d5
#FUN-B20073 --end--               
               NEXT FIELD nne_d5
            ELSE
               DISPLAY l_aag02 TO aag02_d5
            END IF
         #No.TQC-B60097--add--
         ELSE
            LET l_aag02=NULL
            DISPLAY l_aag02 TO aag02_d5
         #No.TQC-B60097--end--
         END IF
      AFTER FIELD nne_d6
         IF NOT cl_null(g_nne.nne_d6) THEN
            CALL t710_aag(g_nne.nne_d6,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d6,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d6,'23',g_bookno1)   
                     RETURNING g_nne.nne_d6
               DISPLAY BY NAME g_nne.nne_d6
#FUN-B20073 --end--               
               NEXT FIELD nne_d6
            ELSE
               DISPLAY l_aag02 TO aag02_d6
            END IF
         #No.TQC-B60097--add--
         ELSE
            LET l_aag02=NULL
            DISPLAY l_aag02 TO aag02_d6
         #No.TQC-B60097--end--
         END IF

      AFTER FIELD nne_d7
         IF NOT cl_null(g_nne.nne_d7) THEN
            CALL t710_aag(g_nne.nne_d7,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d7,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d7,'23',g_bookno1)  
                     RETURNING g_nne.nne_d7
               DISPLAY BY NAME g_nne.nne_d7
#FUN-B20073 --end--               
               NEXT FIELD nne_d7
            ELSE
               DISPLAY l_aag02 TO aag02_d7
            END IF
         #No.TQC-B60097--add--
         ELSE
            LET l_aag02=NULL
            DISPLAY l_aag02 TO aag02_d7
         #No.TQC-B60097--end--
         END IF
 
 
        AFTER FIELD nne_c1
           IF NOT cl_null(g_nne.nne_c1) THEN
              CALL t710_aag(g_nne.nne_c1,'0') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_c1,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_c1,'23',g_bookno1)  
                   RETURNING g_nne.nne_c1
                 DISPLAY BY NAME g_nne.nne_c1
#FUN-B20073 --end--                 
                 NEXT FIELD nne_c1
              ELSE
                 DISPLAY l_aag02 TO aag02_c1
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_c1
           #No.TQC-B60097--end--
           END IF
 
       #BEFORE FIELD nne_d11              #MOD-C20173 mark
       #     CALL t710_default_acctno()   #MOD-C20173 mark
        #No.TQC-CA0055 ---start--- Add
         BEFORE FIELD nne_d11
            CALL t710_default_acctno1()
        #No.TQC-CA0055 ---end --- Add
 
        AFTER FIELD nne_d11
           IF NOT cl_null(g_nne.nne_d11) THEN
              CALL t710_aag(g_nne.nne_d11,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d11,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d11,'23',g_bookno2)     
                    RETURNING g_nne.nne_d11
                 DISPLAY BY NAME g_nne.nne_d11
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d11
              ELSE
                 DISPLAY l_aag02 TO aag02_d11
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d11
           #No.TQC-B60097--end--
           END IF
 
        AFTER FIELD nne_d21
           IF NOT cl_null(g_nne.nne_d21) THEN
              CALL t710_aag(g_nne.nne_d21,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d21,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d21,'23',g_bookno2)  
                    RETURNING g_nne.nne_d21
                 DISPLAY BY NAME g_nne.nne_d21
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d21
              ELSE
                 DISPLAY l_aag02 TO aag02_d21
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d21
           #No.TQC-B60097--end--
           END IF
 
        AFTER FIELD nne_d41
           IF NOT cl_null(g_nne.nne_d41) THEN
              CALL t710_aag(g_nne.nne_d41,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d41,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d41,'23',g_bookno2)   
                       RETURNING g_nne.nne_d41
                 DISPLAY BY NAME g_nne.nne_d41
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d41
              ELSE
                 DISPLAY l_aag02 TO aag02_d41
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d41
           #No.TQC-B60097--end--
           END IF
        AFTER FIELD nne_d51
           IF NOT cl_null(g_nne.nne_d51) THEN
              CALL t710_aag(g_nne.nne_d51,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d51,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d51,'23',g_bookno2)   
                      RETURNING g_nne.nne_d51
                 DISPLAY BY NAME g_nne.nne_d51
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d51
              ELSE
                 DISPLAY l_aag02 TO aag02_d51
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d51
           #No.TQC-B60097--end--
           END IF
        AFTER FIELD nne_d61
           IF NOT cl_null(g_nne.nne_d61) THEN
              CALL t710_aag(g_nne.nne_d61,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d61,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d61,'23',g_bookno2)    
                         RETURNING g_nne.nne_d61
                 DISPLAY BY NAME g_nne.nne_d61
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d61
              ELSE
                 DISPLAY l_aag02 TO aag02_d61
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d61
           #No.TQC-B60097--end--
           END IF
 
        AFTER FIELD nne_d71
           IF NOT cl_null(g_nne.nne_d71) THEN
              CALL t710_aag(g_nne.nne_d71,'1') RETURNING l_aag02       #No.FUN-730032
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nne.nne_d71,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d71,'23',g_bookno2)  
                        RETURNING g_nne.nne_d71
                 DISPLAY BY NAME g_nne.nne_d71
#FUN-B20073 --end--                 
                 NEXT FIELD nne_d71
              ELSE
                 DISPLAY l_aag02 TO aag02_d71
              END IF
           #No.TQC-B60097--add--
           ELSE
              LET l_aag02=NULL
              DISPLAY l_aag02 TO aag02_d71
           #No.TQC-B60097--end--
           END IF
 
          AFTER FIELD nne_c11
             IF NOT cl_null(g_nne.nne_c11) THEN
                CALL t710_aag(g_nne.nne_c11,'1') RETURNING l_aag02       #No.FUN-730032
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_nne.nne_c11,g_errno,0) 
#FUN-B20073 --begin--
                   CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_c11,'23',g_bookno2)  
                     RETURNING g_nne.nne_c11
                    DISPLAY BY NAME g_nne.nne_c11
#FUN-B20073 --end--                   
                   NEXT FIELD nne_c11
                ELSE
                   DISPLAY l_aag02 TO aag02_c11
                END IF
             #No.TQC-B60097--add--
             ELSE
                LET l_aag02=NULL
                DISPLAY l_aag02 TO aag02_c11
             #No.TQC-B60097--end--
             END IF
 
        AFTER FIELD nneud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nneud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nne.nneuser = s_get_data_owner("nne_file") #FUN-C10039
           LET g_nne.nnegrup = s_get_data_group("nne_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF   #MOD-580383
            CALL t710_default_acctno()    #No.TQC-CA0055   Add
            SELECT nnn06 INTO l_nnn06 FROM nnn_file
             WHERE nnn01 = g_nne.nne06
            IF g_nnn07 = 'Y' THEN   #MOD-B50191
               IF g_nne.nne32='N' AND g_nne.nne05 IS NULL AND   #MOD-910235
                  (g_nnn06 IS NOT NULL AND g_nnn06<>'1') THEN # 若為L/C銀行可空白
                  DISPLAY BY NAME g_nne.nne05
                  NEXT FIELD nne05
               END IF
              #------------------------MOD-B90155--------------------------START
               IF g_nne.nne32='N' AND g_nne.nne051 IS NULL AND
                  (g_nnn06 IS NOT NULL AND g_nnn06<>'1') THEN
                  DISPLAY BY NAME g_nne.nne051
                  NEXT FIELD nne051
               END IF
              #------------------------MOD-B90155--------------------------END
            END IF                  #MOD-B50191
            IF g_nne.nne12 < 0 THEN
               NEXT FIELD nne12
            END IF
            IF g_nne.nne19 < 0 THEN
               NEXT FIELD nne19
            END IF
            IF g_nne.nne22 > 31 OR g_nne.nne22 < 1 THEN
               NEXT FIELD nne22
            END IF
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nne01)
                 LET g_t1 = s_get_doc_no(g_nne.nne01)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'4','ANM') RETURNING g_t1 #票據性質:收支單號  #TQC-670008
                 LET g_nne.nne01 = g_t1                  #No.FUN-550057
                 DISPLAY BY NAME g_nne.nne01 NEXT FIELD nne01
              WHEN INFIELD(nne30) #合約號碼
                CALL q_nnp01(0,1,g_nne.nne30,g_nne.nne03)     #TQC-C80198 add g_nne.nne03
                     RETURNING g_nne.nne30
                DISPLAY BY NAME g_nne.nne30
              WHEN INFIELD(nne04) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.default1 = g_nne.nne04
                 CALL cl_create_qry() RETURNING g_nne.nne04
                 DISPLAY BY NAME g_nne.nne04
                 NEXT FIELD nne04
              WHEN INFIELD(nne06) #融資種類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nnp2"   #CHI-740028
                 LET g_qryparam.default1 = g_nne.nne06
                 LET g_qryparam.arg1 = g_nne.nne30   #CHI-740028
                 CALL cl_create_qry() RETURNING g_nne.nne06,l_nnn02
                 DISPLAY BY NAME g_nne.nne06           #No.MOD-490344
#                DISPLAY l_nnn02 TO FROMONLY.nnn02     #No.TQC-950167
                 DISPLAY l_nnn02 TO FORMONLY.nnn02     #No.TQC-950167
                CALL t710_nne06('d')
                NEXT FIELD nne06
              WHEN INFIELD(nne05) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nne.nne05
                 CALL cl_create_qry() RETURNING g_nne.nne05
                 DISPLAY BY NAME g_nne.nne05
                 NEXT FIELD nne05
              WHEN INFIELD(nne35) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmt" #MOD-5B0290
                 LET g_qryparam.default1 = g_nne.nne35
                 CALL cl_create_qry() RETURNING g_nne.nne35
                 DISPLAY BY NAME g_nne.nne35
                 NEXT FIELD nne35
              WHEN INFIELD(nne31) #銀行代號 add
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nab"
                 LET g_qryparam.default1 = g_nne.nne31
                 CALL cl_create_qry() RETURNING g_nne.nne31
                 DISPLAY BY NAME g_nne.nne31
                 NEXT FIELD nne31
              WHEN INFIELD(nne051) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmc01"   #FUN-640021
                 LET g_qryparam.default1 = g_nne.nne051
                 LET g_qryparam.arg1 = '1'   #FUN-640021
                 CALL cl_create_qry() RETURNING g_nne.nne051
                 DISPLAY BY NAME g_nne.nne051
                #TQC-CC0022--add--str
                 LET g_nmc02 = ''
                 SELECT nmc02 INTO g_nmc02 FROM nmc_file
                  WHERE nmc01 = g_nne.nne051
                 DISPLAY g_nmc02 TO nmc02
                #TQC-CC0022--add--end
                 NEXT FIELD nne051
              WHEN INFIELD(nne38) #銀行異動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmc"
                 LET g_qryparam.default1 = g_nne.nne38
                 CALL cl_create_qry() RETURNING g_nne.nne38
                 DISPLAY BY NAME g_nne.nne38
                 NEXT FIELD nne38
              WHEN INFIELD(nne15) #L/C NO
                 CALL q_ala2(FALSE,TRUE,g_nne.nne15) RETURNING g_nne.nne15   #MOD-730116
                 DISPLAY BY NAME g_nne.nne15
                 NEXT FIELD nne15
              WHEN INFIELD(nne16) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nne.nne16
                 CALL cl_create_qry() RETURNING g_nne.nne16
                 DISPLAY BY NAME g_nne.nne16
                 NEXT FIELD nne16
              WHEN INFIELD(nne18) #現金變動碼值
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nml"
                 LET g_qryparam.default1 = g_nne.nne18
                 CALL cl_create_qry() RETURNING g_nne.nne18
                 DISPLAY BY NAME g_nne.nne18
                 NEXT FIELD nne18
              WHEN INFIELD(nne44) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_nne.nne44
                 CALL cl_create_qry() RETURNING g_nne.nne44
                 DISPLAY BY NAME g_nne.nne44
                 NEXT FIELD nne44
              WHEN INFIELD(nne_d1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d1,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_nne.nne_d1
                 DISPLAY BY NAME g_nne.nne_d1
                 NEXT FIELD nne_d1
              WHEN INFIELD(nne_d2)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d2,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_nne.nne_d2
                 DISPLAY BY NAME g_nne.nne_d2
                 NEXT FIELD nne_d2
              WHEN INFIELD(nne_d4)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d4,'23',g_bookno1)     #No.FUN-980025
                         RETURNING g_nne.nne_d4
                    DISPLAY BY NAME g_nne.nne_d4
                    NEXT FIELD nne_d4
              WHEN INFIELD(nne_d5)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d5,'23',g_bookno1)     #No.FUN-980025
                         RETURNING g_nne.nne_d5
                    DISPLAY BY NAME g_nne.nne_d5
                    NEXT FIELD nne_d5
              WHEN INFIELD(nne_d6)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2    #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d6,'23',g_bookno1)     #No.FUN-980025
                         RETURNING g_nne.nne_d6
                    DISPLAY BY NAME g_nne.nne_d6
                    NEXT FIELD nne_d6
              WHEN INFIELD(nne_d7)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2    #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d7,'23',g_bookno1)     #No.FUN-980025 
                         RETURNING g_nne.nne_d7
                    DISPLAY BY NAME g_nne.nne_d7
                    NEXT FIELD nne_d7
              WHEN INFIELD(nne_c1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_c1,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_nne.nne_c1
                 DISPLAY BY NAME g_nne.nne_c1
                 NEXT FIELD nne_c1   #MOD-580329
              WHEN INFIELD(nne_d11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d11,'23',g_bookno2)     #No.FUN-980025
                 RETURNING g_nne.nne_d11
                 DISPLAY BY NAME g_nne.nne_d11
                 NEXT FIELD nne_d11
              WHEN INFIELD(nne_d21)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020  
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d21,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nne.nne_d21
                 DISPLAY BY NAME g_nne.nne_d21
                 NEXT FIELD nne_d21
              WHEN INFIELD(nne_d41)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d41,'23',g_bookno2)     #No.FUN-980025  
                         RETURNING g_nne.nne_d41
                    DISPLAY BY NAME g_nne.nne_d41
                    NEXT FIELD nne_d41
              WHEN INFIELD(nne_d51)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d51,'23',g_bookno2)     #No.FUN-980025  
                         RETURNING g_nne.nne_d51
                    DISPLAY BY NAME g_nne.nne_d51
                    NEXT FIELD nne_d51
              WHEN INFIELD(nne_d61)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d61,'23',g_bookno2)     #No.FUN-980025
                         RETURNING g_nne.nne_d61
                    DISPLAY BY NAME g_nne.nne_d61
                    NEXT FIELD nne_d61
              WHEN INFIELD(nne_d71)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                    CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d71,'23',g_bookno2)     #No.FUN-980025 
                         RETURNING g_nne.nne_d71
                    DISPLAY BY NAME g_nne.nne_d71
                    NEXT FIELD nne_d71
              WHEN INFIELD(nne_c11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_c11,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nne.nne_c11
                 DISPLAY BY NAME g_nne.nne_c11
                 NEXT FIELD nne_c11
              WHEN INFIELD(nne17)
                   CALL s_rate(g_nne.nne16,g_nne.nne17) RETURNING g_nne.nne17
                   DISPLAY BY NAME g_nne.nne17
                   NEXT FIELD nne17
              WHEN INFIELD(nneex2)
                   CALL s_rate(g_nne.nne16,g_nne.nneex2) RETURNING g_nne.nneex2
                   DISPLAY BY NAME g_nne.nneex2
                   NEXT FIELD nneex2
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
END FUNCTION

#TQC-DA0035 add begin ---
FUNCTION t710_check_nne12()
   DEFINE l_nnp07         LIKE nnp_file.nnp07
   LET g_errno = ""
   IF cl_null(g_nne.nne30) OR cl_null(g_nne.nne06) OR cl_null(g_nne.nne04) THEN
      RETURN
   END IF
   CALL s_credit2('N',g_nne.nne04,g_nne.nne30,g_nne.nne06)
                RETURNING amty,amtu,u_amty,u_amtu,bal
                   # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
   SELECT nnp07 INTO l_nnp07
     FROM nnp_file
    WHERE nnp01 = g_nne.nne30
      AND nnp03 = g_nne.nne06
   IF cl_null(l_nnp07) THEN LET l_nnp07 = g_aza.aza17 END IF
   IF l_nnp07 = g_nne.nne16 THEN
      LET bal=bal-(g_nne.nne12*g_nne.nneex2)
   ELSE
      LET bal= bal-(g_nne.nne12*g_nne.nne17)
   END IF
   IF bal<0 THEN
      LET g_errno = "anm-287"
      RETURN
   END IF

END FUNCTION
#TQC-DA0035 add end -----
 
FUNCTION t710_nne28_1()
   LET g_errno=' '
   SELECT * INTO g_alh.* FROM alh_file WHERE alh01=g_nne.nne28
   IF STATUS THEN
      CALL cl_err3("sel","alh_file",g_nne.nne28,"",STATUS,"","sel alh:",1)  #No.FUN-660148
      LET g_errno='x'
      RETURN
   END IF
   LET g_nne.nne07=g_alh.alh51
 
   SELECT ala03 INTO g_nne.nne15 FROM ala_file
    WHERE ala01=g_alh.alh03 AND alafirm <> 'X'
 
   LET g_nne.nne111=g_alh.alh02
   LET g_nne.nne112=g_alh.alh08
   LET g_nne.nne16=g_alh.alh11
   LET g_nne.nne17=g_alh.alh18
   LET g_nne.nne12=g_alh.alh14
   LET g_nne.nne19=g_alh.alh16
   LET g_nne.nne13=g_alh.alh09
   CALL t710_show1()
END FUNCTION
 
FUNCTION t710_nne30(p_cmd)    #合約號碼
   DEFINE p_cmd     LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
   DEFINE l_nnoacti LIKE nno_file.nnoacti
   DEFINE l_nno02   LIKE nno_file.nno02
 
   LET g_errno = ' '
   SELECT nnoacti,nno02 INTO l_nnoacti,l_nno02
     FROM nno_file
    WHERE nno01=g_nne.nne30
      AND nno09='N'  #NO:4417
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-603'
                                  LET l_nnoacti = NULL
                                  LET l_nno02   = NULL
        WHEN l_nnoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   LET g_nne.nne04=l_nno02  #信貸銀行
   DISPLAY BY NAME g_nne.nne04
   CALL t710_nne04('d')
 
END FUNCTION
 
FUNCTION t710_nmc(p_cmd,p_key,p_type)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE p_key     LIKE nmc_file.nmc01
   DEFINE p_type    LIKE nmc_file.nmc03
   DEFINE l_nmc03   LIKE nmc_file.nmc03
   DEFINE l_nmcacti LIKE nmc_file.nmcacti
 
   LET g_errno = ' '
   SELECT nmc03,nmcacti INTO l_nmc03,l_nmcacti FROM nmc_file
    WHERE nmc01=p_key
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-030'
                                  LET l_nmc03 = NULL
        WHEN l_nmc03 != p_type LET g_errno = 'anm-151'
        WHEN l_nmcacti='N'     LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION t710_nne04(p_cmd)  #信貸銀行
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_nno02   LIKE nno_file.nno02
   DEFINE l_alg02   LIKE alg_file.alg02
 
   LET g_errno = ' '
   SELECT nno02 INTO l_nno02 FROM nno_file
    WHERE nno01=g_nne.nne30
      AND nno09='N'  #NO:4417
   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-722'
                                    LET l_nno02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) AND p_cmd='d' THEN
      SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=g_nne.nne04
      IF STATUS THEN LET g_errno='aap-722' RETURN END IF
      DISPLAY l_alg02 TO FORMONLY.alg02
   END IF
END FUNCTION
 
FUNCTION t710_nne05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nmaacti   LIKE nma_file.nmaacti
 
   LET g_errno = ' '
   SELECT nma02,nmaacti INTO l_nma02,l_nmaacti FROM nma_file
    WHERE nma01=g_nne.nne05
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'
                                 LET l_nma02 = NULL
        WHEN l_nmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_nma02 TO FORMONLY.nma02
   END IF
END FUNCTION
 
FUNCTION t710_nne06(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE g_nnn02   LIKE nnn_file.nnn02
 
   LET g_errno = ' '
   SELECT COUNT(*) INTO g_cnt FROM nnp_file
    WHERE nnp01=g_nne.nne30 AND nnp03=g_nne.nne06
   IF g_cnt=0 THEN
      LET g_errno='anm-609'
      RETURN
   END IF
   IF cl_null(g_errno) OR p_cmd='d' THEN
       SELECT nnn02,nnn03,nnn06 INTO g_nnn02,g_nnn03,g_nnn06    #No.MOD-4A0177
        FROM nnn_file WHERE nnn01=g_nne.nne06
      IF STATUS THEN
         LET g_errno='anm-601'
         RETURN
      END IF
      DISPLAY g_nnn02 TO FORMONLY.nnn02
   END IF
 
END FUNCTION
 
FUNCTION t710_default_acctno()


  #IF cl_null(g_nne.nne_d1) THEN                                         #MOD-C20173 mark
   IF g_nnn07 = 'Y' THEN                                                 #MOD-D10081 add
      SELECT nma05 INTO g_nne.nne_d1 FROM nma_file WHERE nma01=g_nne.nne05
      IF SQLCA.sqlcode THEN
         LET g_nne.nne_d1 = ' '
      END IF
   END IF                                                                #MOD-D10081 add
  #END IF                                                                #MOD-C20173 mark
  #IF cl_null(g_nne.nne_d2) THEN                                         #MOD-C20173 mark
   LET g_nnn06 = null
   SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
   IF g_nnn06 = '2' THEN
      LET g_nne.nne_d2 = g_nms.nms59
   END IF
   IF g_nnn06 = '3' THEN
      LET g_nne.nne_d2 = g_nms.nms61
   END IF
  #END IF                                                                #MOD-C20173 mark
  #-----------------------------MOD-C20173----------------------------start
  #SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
  #IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
  #   IF cl_null(g_nne.nne_d4) THEN 
  #      LET g_nne.nne_d4 = g_nms.nms58
  #   END IF
  #   IF cl_null(g_nne.nne_d5) THEN 
  #      LET g_nne.nne_d5 = g_nms.nms58
  #   END IF
  #   IF cl_null(g_nne.nne_d6) THEN 
  #      LET g_nne.nne_d6 = g_nms.nms58
  #   END IF
  #   IF cl_null(g_nne.nne_d7) THEN 
  #      LET g_nne.nne_d7 = g_nms.nms58
  #   END IF
  #END IF
   IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
      LET g_nne.nne_d4 = g_nms.nms58
      LET g_nne.nne_d5 = g_nms.nms58
      LET g_nne.nne_d6 = g_nms.nms58
      LET g_nne.nne_d7 = g_nms.nms58
   END IF
  #-----------------------------MOD-C20173------------------------------end
  #IF cl_null(g_nne.nne_c1) THEN                                           #MOD-C20173 mark
   SELECT nnn04 INTO g_nne.nne_c1 FROM nnn_file WHERE nnn01=g_nne.nne06
   IF SQLCA.sqlcode THEN
     #LET g_nne.nne_c1 = ' '          #MOD-B20141 mark
      LET g_nne.nne_c1 = g_nms.nms63  #MOD-B20141
   END IF
  #END IF                                                                  #MOD-C20173 mark
   IF g_aza.aza63 = 'Y' THEN
     #IF cl_null(g_nne.nne_d11) THEN                                       #MOD-C20173 mark
      SELECT nma051 INTO g_nne.nne_d11 FROM nma_file WHERE nma01=g_nne.nne05
      IF SQLCA.sqlcode THEN
         LET g_nne.nne_d11 = ' '
      END IF
     #END IF                                                               #MOD-C20173 mark
     #IF cl_null(g_nne.nne_d21) THEN                                       #MOD-C20173 mark
      LET g_nnn06 = null
      SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
      IF g_nnn06 = '2' THEN
         LET g_nne.nne_d21 = g_nms.nms591
      END IF
      IF g_nnn06 = '3' THEN
         LET g_nne.nne_d21 = g_nms.nms611
      END IF
     #END IF                                                               #MOD-C20173 mark
     #--------------------------MOD-C20173--------------------------------start
     #SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
     #IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
     #   IF cl_null(g_nne.nne_d41) THEN 
     #      LET g_nne.nne_d41 = g_nms.nms581
     #   END IF
     #   IF cl_null(g_nne.nne_d51) THEN 
     #      LET g_nne.nne_d51 = g_nms.nms581
     #   END IF
     #   IF cl_null(g_nne.nne_d61) THEN 
     #      LET g_nne.nne_d61 = g_nms.nms581
     #   END IF
     #   IF cl_null(g_nne.nne_d71) THEN 
     #      LET g_nne.nne_d71 = g_nms.nms581
     #   END IF
     #END IF
      IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
         LET g_nne.nne_d41 = g_nms.nms581
         LET g_nne.nne_d51 = g_nms.nms58
         LET g_nne.nne_d61 = g_nms.nms581
         LET g_nne.nne_d71 = g_nms.nms581
      END IF
     #--------------------------MOD-C20173----------------------------------end
     #IF cl_null(g_nne.nne_c11) THEN       #MOD-C20173 mark
      SELECT nnn041 INTO g_nne.nne_c11 FROM nnn_file WHERE nnn01=g_nne.nne06
      IF SQLCA.sqlcode THEN
        #LET g_nne.nne_c1 = ' '            #MOD-B20141 mark
         LET g_nne.nne_c11 = g_nms.nms631  #MOD-B20141
      END IF
     #END IF                                                               #MOD-C20173 mark
   END IF
   DISPLAY BY NAME g_nne.nne_d1,g_nne.nne_d2,g_nne.nne_d4,g_nne.nne_d5,
                   g_nne.nne_d6,g_nne.nne_d7,g_nne.nne_c1
   IF g_aza.aza63 = 'Y' THEN
      DISPLAY BY NAME g_nne.nne_d11,g_nne.nne_d21,g_nne.nne_d41,g_nne.nne_d51,
                      g_nne.nne_d61,g_nne.nne_d71,g_nne.nne_c11
   END IF
   CALL t710_show()                      # 重新顯示  #MOD-B20141
END FUNCTION
 
#No.TQC-CA0055 ---start--- Add
FUNCTION t710_default_acctno1()
   IF cl_null(g_nne.nne_d1) THEN     
      SELECT nma05 INTO g_nne.nne_d1
        FROM nma_file
       WHERE nma01=g_nne.nne05
      IF SQLCA.sqlcode THEN
         LET g_nne.nne_d1 = ' '
      END IF
   END IF          
   IF cl_null(g_nne.nne_d2) THEN 
      LET g_nnn06 = NULL
      SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
      IF g_nnn06 = '2' THEN
         LET g_nne.nne_d2 = g_nms.nms59
      END IF
      IF g_nnn06 = '3' THEN
         LET g_nne.nne_d2 = g_nms.nms61
      END IF
   END IF  
   SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
   IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
      IF cl_null(g_nne.nne_d4) THEN
         LET g_nne.nne_d4 = g_nms.nms58
      END IF
      IF cl_null(g_nne.nne_d5) THEN
         LET g_nne.nne_d5 = g_nms.nms58
      END IF
      IF cl_null(g_nne.nne_d6) THEN
         LET g_nne.nne_d6 = g_nms.nms58
      END IF
      IF cl_null(g_nne.nne_d7) THEN
         LET g_nne.nne_d7 = g_nms.nms58
      END IF
   END IF
   IF cl_null(g_nne.nne_c1) THEN  
      SELECT nnn04 INTO g_nne.nne_c1 FROM nnn_file WHERE nnn01=g_nne.nne06
      IF SQLCA.sqlcode THEN
         LET g_nne.nne_c1 = g_nms.nms63  
      END IF
   END IF 
   IF g_aza.aza63 = 'Y' THEN
      IF cl_null(g_nne.nne_d11) THEN     
         SELECT nma051 INTO g_nne.nne_d11
           FROM nma_file
          WHERE nma01=g_nne.nne05
         IF SQLCA.sqlcode THEN
            LET g_nne.nne_d11 = ' '
         END IF
      END IF 
      IF cl_null(g_nne.nne_d21) THEN
      LET g_nnn06 = null
      SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
      IF g_nnn06 = '2' THEN
         LET g_nne.nne_d21 = g_nms.nms591
      END IF
      IF g_nnn06 = '3' THEN
         LET g_nne.nne_d21 = g_nms.nms611
      END IF
      END IF
      SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nne.nne06
      IF g_nnn06 = '2' OR g_nnn06 = '3' THEN
         IF cl_null(g_nne.nne_d41) THEN
            LET g_nne.nne_d41 = g_nms.nms581
         END IF
         IF cl_null(g_nne.nne_d51) THEN
            LET g_nne.nne_d51 = g_nms.nms581
         END IF
         IF cl_null(g_nne.nne_d61) THEN
            LET g_nne.nne_d61 = g_nms.nms581
         END IF
         IF cl_null(g_nne.nne_d71) THEN
            LET g_nne.nne_d71 = g_nms.nms581
         END IF
      END IF
      IF cl_null(g_nne.nne_c11) THEN
         SELECT nnn041 INTO g_nne.nne_c11 FROM nnn_file WHERE nnn01=g_nne.nne06
         IF SQLCA.sqlcode THEN
            LET g_nne.nne_c11 = g_nms.nms631  
         END IF
      END IF
   END IF

   DISPLAY BY NAME g_nne.nne_d1,g_nne.nne_d2,g_nne.nne_d4,g_nne.nne_d5,
                   g_nne.nne_d6,g_nne.nne_d7,g_nne.nne_c1
   IF g_aza.aza63 = 'Y' THEN
      DISPLAY BY NAME g_nne.nne_d11,g_nne.nne_d21,g_nne.nne_d41,g_nne.nne_d51,
                      g_nne.nne_d61,g_nne.nne_d71,g_nne.nne_c11
   END IF
   CALL t710_show()
END FUNCTION
#No.TQC-CA0055 ---end  --- Add

FUNCTION t710_4()
   DEFINE l_aag02   LIKE aag_file.aag02   #No.FUN-680107 VARCHAR(30)
 
   OPEN WINDOW t710_t_w AT 3,20
     WITH FORM "anm/42f/anmt710a"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt710a")
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("group02",TRUE)
    ELSE
       CALL cl_set_comp_visible("group02",FALSE)
    END IF
 
    CALL s_get_bookno(YEAR(g_nne.nne02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_nne.nne03),'aoo-081',1)
       RETURN
    END IF
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d1
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d2
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d2
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_c1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c1
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d11
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d21
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d21
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_c11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c11
   LET l_aag02=NULL
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='X' THEN
      CALL cl_err('','9024',1)
      CLOSE WINDOW t710_t_w
      RETURN
   END IF
   LET g_success='Y' #no.6505
   BEGIN WORK
 
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_nne.nne01,STATUS,0)
      ROLLBACK WORK
      CLOSE WINDOW t710_t_w
      RETURN
   END IF
 
   INPUT BY NAME g_nne.nne_d1,g_nne.nne_d2,g_nne.nne_c1,g_nne.nne_d11,g_nne.nne_d21,g_nne.nne_c11 WITHOUT DEFAULTS      #No.FUN-680088

      AFTER FIELD nne_d1
         IF NOT cl_null(g_nne.nne_d1) THEN
            CALL t710_aag(g_nne.nne_d1,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d1,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d1,'23',g_bookno1)  
                  RETURNING g_nne.nne_d1
               DISPLAY BY NAME g_nne.nne_d1
#FUN-B20073 --end--               
               NEXT FIELD nne_d1
            ELSE
               DISPLAY l_aag02 TO aag02_d1
            END IF
         END IF
 
      AFTER FIELD nne_d2
         IF NOT cl_null(g_nne.nne_d2) THEN  #No:8614 改為可不輸入
            CALL t710_aag(g_nne.nne_d2,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d2,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d2,'23',g_bookno1)   
                   RETURNING g_nne.nne_d2
               DISPLAY BY NAME g_nne.nne_d2
#FUN-B20073 --end--               
               NEXT FIELD nne_d2
            ELSE
               DISPLAY l_aag02 TO aag02_d2
            END IF
         END IF
 
      AFTER FIELD nne_c1
         IF NOT cl_null(g_nne.nne_c1) THEN
            CALL t710_aag(g_nne.nne_c1,'0') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_c1,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_c1,'23',g_bookno1)    
                  RETURNING g_nne.nne_c1
               DISPLAY BY NAME g_nne.nne_c1
#FUN-B20073 --end--               
               NEXT FIELD nne_c1
            ELSE
               DISPLAY l_aag02 TO aag02_c1
            END IF
         END IF
 
      AFTER FIELD nne_d11
         IF NOT cl_null(g_nne.nne_d11) THEN
            CALL t710_aag(g_nne.nne_d11,'1') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d11,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d11,'23',g_bookno2)  
                  RETURNING g_nne.nne_d11
               DISPLAY BY NAME g_nne.nne_d11
#FUN-B20073 --end--               
               NEXT FIELD nne_d11
            ELSE
               DISPLAY l_aag02 TO aag02_d11
            END IF
         END IF
 
      AFTER FIELD nne_d21
         IF NOT cl_null(g_nne.nne_d21) THEN  #No:8614 改為可不輸入
            CALL t710_aag(g_nne.nne_d21,'1') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_d21,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_d21,'23',g_bookno2)   
                  RETURNING g_nne.nne_d21
               DISPLAY BY NAME g_nne.nne_d21
#FUN-B20073 --end--               
               NEXT FIELD nne_d21
            ELSE
               DISPLAY l_aag02 TO aag02_d21
            END IF
         END IF
 
      AFTER FIELD nne_c11
         IF NOT cl_null(g_nne.nne_c11) THEN
            CALL t710_aag(g_nne.nne_c11,'1') RETURNING l_aag02       #No.FUN-730032
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nne.nne_c11,g_errno,0) 
#FUN-B20073 --begin--
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nne.nne_c11,'23',g_bookno2) 
                  RETURNING g_nne.nne_c11
               DISPLAY BY NAME g_nne.nne_c11
#FUN-B20073 --end--               
               NEXT FIELD nne_c11
            ELSE
               DISPLAY l_aag02 TO aag02_c11
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(nne_d1)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d1,'23',g_bookno1)     #No.FUN-980025 
               RETURNING g_nne.nne_d1
               DISPLAY BY NAME g_nne.nne_d1
               NEXT FIELD nne_d1
            WHEN INFIELD(nne_d2)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d2,'23',g_bookno1)     #No.FUN-980025
               RETURNING g_nne.nne_d2
               DISPLAY BY NAME g_nne.nne_d2
               NEXT FIELD nne_d2
            WHEN INFIELD(nne_c1)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_c1,'23',g_bookno1)     #No.FUN-980025 
               RETURNING g_nne.nne_c1
               DISPLAY BY NAME g_nne.nne_c1
                 NEXT FIELD nne_c1   #MOD-580329
            WHEN INFIELD(nne_d11)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d11,'23',g_bookno2)     #No.FUN-980025
               RETURNING g_nne.nne_d11
               DISPLAY BY NAME g_nne.nne_d11
               NEXT FIELD nne_d11
            WHEN INFIELD(nne_d21)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_d21,'23',g_bookno2)     #No.FUN-980025  
               RETURNING g_nne.nne_d21
               DISPLAY BY NAME g_nne.nne_d21
               NEXT FIELD nne_d21
            WHEN INFIELD(nne_c11)         # 總帳會計科目查詢
               CALL s_get_bookno1(YEAR(g_nne.nne02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
               IF g_flag = '1' THEN
                  CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nne.nne_c11,'23',g_bookno2)     #No.FUN-980025 
               RETURNING g_nne.nne_c11
               DISPLAY BY NAME g_nne.nne_c11
                 NEXT FIELD nne_c11
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
      LET INT_FLAG=0
      LET g_nne.*=g_nne_t.*
      CLOSE WINDOW t710_t_w
      RETURN
   END IF
   UPDATE nne_file SET *=g_nne.* WHERE nne01=g_nne.nne01
   IF STATUS THEN
      CALL cl_err3("upd","nne_file",g_nne.nne01,"",STATUS,"","upd nne:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CLOSE WINDOW t710_t_w
   IF g_success= 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nne.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t710_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t710_count
   FETCH t710_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nne.nne01,SQLCA.sqlcode,0)
      INITIALIZE g_nne.* TO NULL
   ELSE
      CALL t710_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t710_fetch(p_flnne)
   DEFINE
       p_flnne         LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10    #No.FUN-680107 INTEGER
 
   CASE p_flnne
      WHEN 'N' FETCH NEXT     t710_cs INTO g_nne.nne01
      WHEN 'P' FETCH PREVIOUS t710_cs INTO g_nne.nne01
      WHEN 'F' FETCH FIRST    t710_cs INTO g_nne.nne01
      WHEN 'L' FETCH LAST     t710_cs INTO g_nne.nne01
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
            FETCH ABSOLUTE g_jump t710_cs INTO g_nne.nne01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nne.nne01,SQLCA.sqlcode,0)
      INITIALIZE g_nne.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnne
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nne.* FROM nne_file            # 重讀DB,因TEMP有不被更新特性
    WHERE nne01 = g_nne.nne01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nne_file",g_nne.nne01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
       LET g_data_owner = g_nne.nneuser     #No.FUN-4C0063
       LET g_data_group = g_nne.nnegrup     #No.FUN-4C0063
      CALL t710_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t710_show()
   DEFINE  l_aag02    LIKE aag_file.aag02   #No.FUN-680107 VARCHAR(30)
   DEFINE  l_nne12    LIKE nne_file.nne12   #No.FUN-680107 VARCHAR(04)
   DEFINE  g_nnn02    LIKE nnn_file.nnn02
   DEFINE  l_nmo02    LIKE nmo_file.nmo02   #No.FUN-680107 VARCHAR(24)
   DEFINE  l_nma02    LIKE nma_file.nma02
   DEFINE  l_nml02    LIKE nml_file.nml02
   DEFINE  l_days     LIKE type_file.num10  #No.FUN-680107 INTEGER
 
   LET g_nne_t.* = g_nne.*
   CALL t710_show1()
   IF not cl_null(g_nne.nne12) AND not cl_null(g_nne.nne111) THEN
      LET l_days = g_nne.nne112 - g_nne.nne111
      DISPLAY l_days TO FORMONLY.days
   END IF
   SELECT * INTO g_alg.* FROM alg_file WHERE alg01=g_nne.nne04
   IF STATUS THEN
      INITIALIZE g_alg.* TO NULL
   END IF
   DISPLAY BY NAME g_alg.alg02
 
   SELECT nnn02 INTO g_nnn02 FROM nnn_file WHERE nnn01=g_nne.nne06
   IF STATUS THEN
      INITIALIZE g_nnn02 TO NULL
   END IF
   DISPLAY g_nnn02 TO FORMONLY.nnn02
 
   CALL t710_nne06('d')
   SELECT * INTO g_nma.* FROM nma_file WHERE nma01=g_nne.nne05
   IF STATUS THEN
      INITIALIZE g_nma.* TO NULL
   END IF
 
   DISPLAY BY NAME g_nma.nma02
  #SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=g_nne.nne35#TQC-CC0022 mark
   SELECT nmt02 INTO l_nma02 FROM nmt_file WHERE nmt01 = g_nne.nne35#TQC-CC0022 add
   IF SQLCA.sqlcode THEN
      LET l_nma02 = ' '
   END IF
   DISPLAY l_nma02 TO FORMONLY.k
  #TQC-CC0022--add--str
   LET g_nmc02 = ''
   SELECT nmc02 INTO g_nmc02 FROM nmc_file
    WHERE nmc01 = g_nne.nne051
   DISPLAY g_nmc02 TO nmc02
  #TQC-CC0022--add--end
 
   SELECT nml02 INTO l_nml02 FROM nml_file WHERE nml01 = g_nne.nne18
   IF SQLCA.sqlcode THEN
      LET l_nml02 = ' '
   END IF
   DISPLAY l_nml02 TO FORMONLY.nml02
   LET g_t1 = s_get_doc_no(g_nne.nne01)       #No.FUN-550057
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
    CALL s_get_bookno(YEAR(g_nne.nne02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
    END IF
 
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d1
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d2
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d2
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_c1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c1
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d4
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d4 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d5
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d5 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d6
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d6 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d7
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d7 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d11
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d21
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d21
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_c11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c11
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d41
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d41 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d51
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d51 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d61
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d61 LET l_aag02=NULL
   LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nne.nne_d71
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d71 LET l_aag02=NULL
 
   LET l_aag02=NULL
   IF g_nne.nneconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_nne.nneconf,"","","",g_void,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t710_show1()
   DISPLAY BY NAME g_nne.nneoriu,g_nne.nneorig,g_nne.nne01,g_nne.nne32,g_nne.nne02,g_nne.nne03,g_nne.nne04,g_nne.nne30, #No:8614 add nne32
                   g_nne.nne05,g_nne.nne051,g_nne.nne41,g_nne.nne31,g_nne.nne06,
                   g_nne.nne28,g_nne.nne43,g_nne.nne44,g_nne.nne42,g_nne.nne07,
                   g_nne.nne08,g_nne.nne09,g_nne.nne10,g_nne.nne111,
                   g_nne.nne112,g_nne.nne16,g_nne.nne17,g_nne.nneex2,g_nne.nne12,
                   g_nne.nne19,g_nne.nne27,g_nne.nne20,g_nne.nne13,g_nne.nne14,
                   g_nne.nne21,g_nne.nne22,g_nne.nne26,g_nne.nne18,
                   g_nne.nneglno,g_nne.nne33,g_nne.nne35,g_nne.nne38,g_nne.nne15,g_nne.nne25, #No:8614 add nne33
                   g_nne.nne34,g_nne.nne291,g_nne.nne29,g_nne.nne23,g_nne.nne241,g_nne.nne24,g_nne.nne36,   #FUN-690076
                   g_nne.nne371,g_nne.nne37,g_nne.nne45,g_nne.nne461,g_nne.nne46,g_nne.nneconf,g_nne.nneuser,g_nne.nnegrup,   #FUN-640242   #FUN-690076
                   g_nne.nnemodu,g_nne.nnedate,
                   g_nne.nne_d1,g_nne.nne_d2,g_nne.nne_d4,g_nne.nne_d5, #No.7901
                   g_nne.nne_d6,g_nne.nne_d7,g_nne.nne_c1,  #FUN-640242
                   g_nne.nne_d11,g_nne.nne_d21,g_nne.nne_d41,g_nne.nne_d51,      #No.FUN-680088
                   g_nne.nne_d61,g_nne.nne_d71,g_nne.nne_c11      #No.FUN-680088
                   ,g_nne.nneud01,g_nne.nneud02,g_nne.nneud03,g_nne.nneud04,
                   g_nne.nneud05,g_nne.nneud06,g_nne.nneud07,g_nne.nneud08,
                   g_nne.nneud09,g_nne.nneud10,g_nne.nneud11,g_nne.nneud12,
                   g_nne.nneud13,g_nne.nneud14,g_nne.nneud15 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t710_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nne.nne01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='Y' THEN
      CALL cl_err('','anm-137',1)
      RETURN
   END IF
   IF g_nne.nne20 != 0 THEN
      CALL cl_err('','anm-240',1)
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nne01_t = g_nne.nne01
   LET g_nne_o.*=g_nne.*
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_nne.nne01,STATUS,0)
      RETURN
   END IF
   LET g_nne.nnemodu=g_user                     #修改者
   LET g_nne.nnedate = g_today                  #修改日期
   CALL t710_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t710_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_nne.*=g_nne_t.*
         CALL t710_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE nne_file SET nne_file.* = g_nne.*    # 更新DB
       WHERE nne01 = g_nne01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("upd","nne_file",g_nne01_t,"",SQLCA.sqlcode,"","(t710_u:nne)",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      IF g_nne.nne02 != g_nne_t.nne02 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_nne.nne02
          WHERE npp01=g_nne.nne01 AND npp00=16 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_nne01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         END IF
      END IF
      #MOD-C30267--add--str
      IF g_nmy.nmydmy3 = 'Y' THEN
         IF cl_confirm('axr-309') THEN
            CALL t710_gen_glcr(g_nne.*,g_nmy.*)
         END IF
         IF g_success = 'Y' THEN
            CALL s_chknpq(g_nne.nne01,'NM',0,'0',g_bookno1)
            IF g_aza.aza63 = 'Y' AND g_success ='Y' THEN
               CALL s_chknpq(g_nne.nne01,'NM',0,'1',g_bookno2)
            END IF
         END IF
      END IF
      #MOD-C30267--add--end
      EXIT WHILE
   END WHILE
   CLOSE t710_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_nne.nne01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t710_npp02(p_npptype)
   DEFINE p_npptype   LIKE npp_file.npptype       #No.FUN-680088        
 
   IF g_nne.nneglno IS NULL OR g_nne.nneglno=' ' THEN
      UPDATE npp_file SET npp02=g_nne.nne02
       WHERE npp01=g_nne.nne01 AND npp00=16 AND npp011=0
         AND nppsys = 'NM'
         AND npptype = p_npptype       #No.FUN-680088        
      IF STATUS THEN 
         CALL cl_err3("upd","npp_file",g_nne.nne01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
      END IF
   END IF
END FUNCTION
 
FUNCTION t710_r()
   DEFINE
      l_chr   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
      l_msg   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(50)
   DEFINE l_alh30 LIKE alh_file.alh30      #MOD-990237    
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF g_nne.nne01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='Y' THEN
      CALL cl_err('','anm-139',1)
      RETURN
   END IF
   IF g_nne.nne20 != 0 THEN
      CALL cl_err('','anm-240',1)
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
   IF g_nne.nneglno IS NOT NULL THEN
      CALL cl_err(g_nne.nne01,'anm-230',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnf_file
    WHERE nnf01 = g_nne.nne01
      AND nnf06 IS NOT NULL
   IF g_cnt > 0 THEN
      RETURN
   END IF
#-------------------------------MOD-C30710--mark------------------------start
#-------------------------------MOD-B90192------------------------------start
#   SELECT COUNT(*) INTO g_cnt FROM alh_file WHERE alh01 = g_nne.nne28
#   IF g_cnt > 0 THEN
#      CALL cl_err(g_nne.nne28,'aap-310',0)
#      RETURN
#   END IF
#-------------------------------MOD-B90192------------------------------end
#-------------------------------MOD-C30710--mark------------------------end

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nne.nne01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t710_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nne01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nne.nne01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM nne_file WHERE nne01 = g_nne.nne01
      IF STATUS THEN
         LET g_success='N'
         CALL cl_err3("del","nne_file",g_nne.nne01,"",STATUS,"","del nne",1)  #No.FUN-660148
      END IF
      DELETE FROM npp_file
       WHERE nppsys='NM' AND npp00=16 AND npp01=g_nne.nne01 AND npp011=0
      IF STATUS THEN
         LET g_success='N'
         CALL cl_err3("del","npp_file",g_nne.nne01,"",STATUS,"","del nnp",1)  #No.FUN-660148
      END IF
      DELETE FROM npq_file
       WHERE npqsys='NM' AND npq00=16 AND npq01=g_nne.nne01 AND npq011=0
      IF STATUS THEN
         LET g_success='N'
         CALL cl_err3("del","npq_file",g_nne.nne01,"",STATUS,"","del npq",1)  #No.FUN-660148
      END IF
      DELETE FROM nnf_file WHERE nnf01 = g_nne.nne01
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_nne.nne01
      #FUN-B40056--add--end--
      IF NOT cl_null(g_nne.nne28) THEN
         UPDATE alh_file SET alh74=NULL,alh75='0' WHERE alh01=g_nne.nne28
         IF STATUS THEN #No:8614
            CALL cl_err3("upd","alh_file",g_nne.nne28,"",SQLCA.sqlcode,"","upd alh:",1)  #No.FUN-660148
            LET g_success='N'
         END IF
         SELECT alh30 INTO l_alh30 FROM alh_file WHERE alh01 = g_nne.nne28                                                          
         IF l_alh30 IS NOT NULL THEN                                                                                                
            UPDATE apa_file SET apa35f=0,apa35 =0,apa73 =apa34 WHERE apa01= l_alh30                                                 
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                    
               CALL cl_err3("upd","apa_file",l_alh30,"",STATUS,"","upd apa_file",1)                                                 
               LET g_errno = STATUS                                                                                                 
            END IF                                                                                                                  
            UPDATE apc_file SET apc10 = 0,apc11 = 0,apc13 = apc09 WHERE apc01 = l_alh30 AND apc02 = 1                               
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                    
               CALL cl_err3("upd","apc_file",l_alh30,"",SQLCA.sqlcode,"","upd apc_file",1)                                          
               LET g_errno = STATUS                                                                                                 
            END IF                                                                                                                  
         END IF                                                                                                                     
      END IF
   END IF
   CLOSE t710_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_nne.nne01,'D')
      CLEAR FORM
      OPEN t710_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t710_cs
         CLOSE t710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t710_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t710_cs
         CLOSE t710_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
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
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
#FUNCTION t710_x() #FUN-D20035 mark
FUNCTION t710_x(p_type)
   
   DEFINE
      l_chr   LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
      l_msg   LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(50)
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add   
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF g_nne.nne01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='Y' THEN
      CALL cl_err('','anm-139',1)
      RETURN
   END IF
   IF g_nne.nne20 != 0 THEN
      CALL cl_err('','anm-240',1)
      RETURN
   END IF
   IF g_nne.nneglno IS NOT NULL THEN
      CALL cl_err(g_nne.nne01,'anm-230',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnf_file
    WHERE nnf01 = g_nne.nne01
      AND nnf06 IS NOT NULL
   IF g_cnt > 0 THEN
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM alh_file WHERE alh01 = g_nne.nne28
   IF g_cnt > 0 THEN
      CALL cl_err(g_nne.nne28,'aap-310',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnj_file WHERE nnj03 = g_nne.nne01
   IF g_cnt > 0 THEN
      CALL cl_err(g_nne.nne01,'anm-240',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnl_file where nnl04 = g_nne.nne01
   IF g_cnt > 0 THEN
      CALL cl_err(g_nne.nne01,'anm-240',0)
      RETURN
   END IF
   #FUN-D20035---begin 
   IF p_type = 1 THEN 
      IF g_nne.nneconf='X' THEN RETURN END IF
   ELSE
      IF g_nne.nneconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20035---end 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nne.nne01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t710_show()
   IF cl_void(0,0,g_nne.nneconf) THEN
      IF g_nne.nneconf='N' THEN    #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=16 AND npp01=g_nne.nne01 AND npp011=0
         IF STATUS THEN
            LET g_success='N'
            CALL cl_err3("del","npp_file",g_nne.nne01,"",STATUS,"","del npp",1)  #No.FUN-660148
         END IF
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=16 AND npq01=g_nne.nne01 AND npq011=0
         IF STATUS THEN
            LET g_success='N'
            CALL cl_err3("del","npq_file",g_nne.nne01,"",STATUS,"","del npq",1)  #No.FUN-660148
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_nne.nne01
         IF STATUS THEN
            LET g_success='N'
            CALL cl_err3("del","tic_file",g_nne.nne01,"",STATUS,"","del tic",1)
         END IF
         #FUN-B40056--add--end--
 
         LET g_nne.nneconf='X'
      ELSE                         #取消作廢
         LET g_nne.nneconf='N'
      END IF
#No:FUN-C60006---add--star---
      LET g_nne.nnemodu = g_user
      LET g_nne.nnedate = g_today
      DISPLAY BY NAME g_nne.nnemodu
      DISPLAY BY NAME g_nne.nnedate
#No:FUN-C60006---add--end---
      UPDATE nne_file SET nneconf=g_nne.nneconf,
      #No:FUN-C60006---add--star---
                          nnemodu = g_user,
                          nnedate = g_today
      #No:FUN-C60006---add--end---

       WHERE nne01 = g_nne.nne01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","nne_file",g_nne.nne01,"",STATUS,"","",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF
   SELECT nneconf INTO g_nne.nneconf FROM nne_file
    WHERE nne01 = g_nne.nne01
   DISPLAY BY NAME g_nne.nneconf
   CLOSE t710_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_nne.nne01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t710_firm1()
   DEFINE l_nnn07 LIKE nnn_file.nnn07     #No:8935
   DEFINE l_n     LIKE type_file.num10    #No.FUN-680107 INTEGER
   DEFINE l_sum   LIKE npq_file.npq07     #MOD-C30267

   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='Y' THEN
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
  #-------------------MOD-C90257---------------(S)
   IF g_nne.nne12 = 0 THEN
      CALL cl_err(g_nne.nne12,'agl-252',0)
      RETURN
   END IF
  #IF g_nne.nne12 <> g_nne.nne19 * g_nne.nne17 THEN       #MOD-CB0273 mark
  #IF g_nne.nne19 <> g_nne.nne12 * g_nne.nne17 THEN                          #MOD-CB0273 add
   IF g_nne.nne19 <> cl_digcut(g_nne.nne12 * g_nne.nne17,g_azi04) THEN       #TQC-D10060 add
      CALL cl_err(g_nne.nne19,'aap-938',0)
      RETURN
   END IF
  #-------------------MOD-C90257---------------(E)
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nne.nne02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nne.nne01,'aap-176',1)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
   LET g_success='Y'
   BEGIN WORK
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_nne.nne01,STATUS,0)
      ROLLBACK WORK
      RETURN
   END IF
   CALL s_get_bookno(YEAR(g_nne.nne02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
      ROLLBACK WORK
      RETURN
   END IF
   #若單別須拋轉總帳且不為購料借款, 檢查分錄底稿平衡正確否
  #IF g_nmy.nmydmy3 = 'Y' AND (g_nnn06 IS NOT NULL AND g_nnn06 != '1') AND g_nmy.nmyglcr = 'N' THEN  #No.FUN-670060 #CHI-B80011 mark 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN  #No.CHI-B80011
      CALL s_chknpq(g_nne.nne01,'NM',0,'0',g_bookno1)   #-->NO:0151       #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success ='Y' THEN
         CALL s_chknpq(g_nne.nne01,'NM',0,'1',g_bookno2)       #No.FUN-730032
      END IF
   END IF
   SELECT nnn07 INTO l_nnn07 FROM nnn_file
    WHERE nnn01=g_nne.nne06
   IF status THEN LET l_nnn07='Y' END IF
   IF g_nne.nne32='N' AND l_nnn07='Y' THEN     #No:8614 不是開帳才insert
      CALL t710_ins_nme()
   END IF                      #No:8614
   IF g_success='N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_nne.nne01
         AND npq011 = 0
         AND npqsys = 'NM'
         AND npq00 = 16
      IF l_n = 0 THEN
         CALL t710_gen_glcr(g_nne.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_nne.nne01,'NM',0,'0',g_bookno1)       #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success ='Y' THEN
            CALL s_chknpq(g_nne.nne01,'NM',0,'1',g_bookno2)       #No.FUN-730032
         END IF
      END IF
   END IF
   #MOD-C30267--add--str
   IF g_nmy.nmydmy3 = 'Y' THEN
      LET l_sum=NULL
      SELECT sum(npq07) INTO l_sum FROM npq_file
       WHERE npq06='1' AND npq01=g_nne.nne01 AND npqtype='0'
      IF l_sum <> g_nne.nne19 THEN
         CALL cl_err(g_nne.nne01,'afa-154',1)
         LET g_success='N'
      END IF
      IF g_aza.aza63 = 'Y' AND g_success ='Y' THEN
         LET l_sum=NULL
         SELECT sum(npq07) INTO l_sum FROM npq_file
          WHERE npq06='1' AND npq01=g_nne.nne01 AND npqtype='1'
         IF l_sum <> g_nne.nne19 THEN
            CALL cl_err(g_nne.nne01,'afa-154',1)
            LET g_success='N'
         END IF
      END IF
   END IF
   #MOD-C30267--add--end
   UPDATE nne_file SET nneconf = 'Y' WHERE nne01 = g_nne.nne01
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_nne.nne01,'Y')
      LET g_nne.nneconf ='Y'
      DISPLAY BY NAME  g_nne.nneconf
   ELSE
      ROLLBACK WORK
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_nne.nne01,'" AND npp011 = 0'
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nne.nne02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT nneglno,nne02 INTO g_nne.nneglno,g_nne.nne02 FROM nne_file
       WHERE nne01 = g_nne.nne01
      DISPLAY BY NAME g_nne.nneglno
      DISPLAY BY NAME g_nne.nne02
   END IF
   CALL cl_set_field_pic(g_nne.nneconf,"","","","N","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t710_firm2()
   DEFINE l_cnt       LIKE type_file.num10      #No.FUN-680107 INTEGER #No:8609
   DEFINE l_aba19     LIKE aba_file.aba19       #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(1000)
   DEFINE l_dbs       STRING
   DEFINE l_n         LIKE type_file.num10      #MOD-B30181
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF g_nne.nneconf='N' THEN
      RETURN
   END IF
   IF g_nne.nne20 != 0 THEN
      CALL cl_err('','anm-240',1)
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_nne.nne02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_nne.nne01,'aap-176',1)
      RETURN
   END IF
   #MOD-B30181--add--str--
   SELECT COUNT(*) INTO l_n FROM nmd_file
    WHERE nmd10 = g_nne.nne01                 
   IF l_n>0 THEN
       CALL cl_err(g_nne.nne01,'aap-228',0)    
      RETURN
   END IF
   #MOD-B30181--add--end--
   #若已作暫估之資料不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM nnm_file
    WHERE nnm01=g_nne.nne01
   IF l_cnt > 0 THEN CALL cl_err(g_nne.nne01,'anm1016',1) RETURN END IF   #MOD-920196 anm-004-->anm1016
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_nne.nne01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nne.nneglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nne.nne01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nne.nneglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nne.nneglno,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
   IF NOT cl_null(g_nne.nneglno) AND g_nmy.nmyglcr = 'N' THEN        #No.FUN-670060
       CALL cl_err(g_nne.nne01,'anm-230',1)
       RETURN
   END IF
   LET g_success='Y'

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nne.nneglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nneglno,nne02 INTO g_nne.nneglno,g_nne.nne02 FROM nne_file
       WHERE nne01 = g_nne.nne01
      IF NOT cl_null(g_nne.nneglno) THEN
         CALL cl_err(g_nne.nneglno,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nne.nneglno
      DISPLAY BY NAME g_nne.nne02
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t710_cl USING g_nne.nne01
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_nne.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_nne.nne01,STATUS,0)
      ROLLBACK WORK
      RETURN
   END IF
   IF g_nne.nne32='N' THEN        #No:8614 開帳不用delete
      CALL t710_del_nme()
   END IF                         #No:8614
 
   IF g_success='N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE nne_file SET nneconf = 'N' WHERE nne01 = g_nne.nne01
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_nne.nneconf ='N'
      DISPLAY BY NAME g_nne.nneconf
   ELSE
      ROLLBACK WORK
   END IF
   
   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nne.nneglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT nneglno,nne02 INTO g_nne.nneglno,g_nne.nne02 FROM nne_file
   #    WHERE nne01 = g_nne.nne01
   #   DISPLAY BY NAME g_nne.nneglno
   #   DISPLAY BY NAME g_nne.nne02
   #END IF
   #CHI-C90052 mark end-----

END FUNCTION
 
FUNCTION t710_ins_nme()
   DEFINE l_nme         RECORD LIKE nme_file.*,
          l_nma10       LIKE nma_file.nma10
 
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

   IF NOT cl_null(g_nne.nne15) THEN RETURN END IF
   LET l_nme.nme00=0
   LET l_nme.nme01=g_nne.nne05
   LET l_nme.nme02=g_nne.nne03
   LET l_nme.nme03=g_nne.nne051
   SELECT nma10 INTO l_nma10 FROM nma_file WHERE nma01 = g_nne.nne05  #存入銀行
   IF NOT cl_null(l_nma10) AND l_nma10 = g_aza.aza17 THEN  #同本國幣別
      LET l_nme.nme04=g_nne.nne12-g_nne.nne241-g_nne.nne371-cl_digcut(g_nne.nne25/g_nne.nne17,t_azi04)-g_nne.nne461-g_nne.nne291   #MOD-940145
      LET l_nme.nme08=g_nne.nne19-g_nne.nne24-g_nne.nne37-g_nne.nne25-g_nne.nne46-g_nne.nne29    #MOD-940145   
      LET l_nme.nme07 = 1
   ELSE                            #不同於本國幣別
      IF l_nma10 = g_nne.nne16 THEN #存入銀行與融資同幣別
         LET l_nme.nme04 = g_nne.nne12-g_nne.nne241-g_nne.nne371-cl_digcut(g_nne.nne25/g_nne.nne17,t_azi04)-g_nne.nne291-g_nne.nne461   #FUN-690076
         LET l_nme.nme08 = g_nne.nne19-g_nne.nne24-g_nne.nne37-g_nne.nne25-g_nne.nne29-g_nne.nne46   #FUN-640242
         LET l_nme.nme07 = g_nne.nne17
      ELSE
         #存入銀行與融資不同幣別,且不同本國幣別
         LET l_nme.nme07 = s_curr3(l_nma10,g_nne.nne03,'S')
         IF cl_null(l_nme.nme07) THEN LET l_nme.nme07 = 1 END IF
         LET l_nme.nme04 =(g_nne.nne19-g_nne.nne24-g_nne.nne37-g_nne.nne25-g_nne.nne29-g_nne.nne46)/l_nme.nme07   #FUN-690076
         LET l_nme.nme08 =g_nne.nne19-g_nne.nne24-g_nne.nne37-g_nne.nne25-g_nne.nne29-g_nne.nne46   #FUN-640242
      END IF
   END IF
   LET l_nme.nme05=g_nne.nne10
   LET l_nme.nme10=g_nne.nneglno
   LET l_nme.nme12=g_nne.nne01
   LET l_nme.nme14=g_nne.nne18
   LET l_nme.nme16=g_nne.nne03
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_azi04 = 0       
   SELECT azi04 INTO l_azi04 FROM azi_file, nma_file  
    WHERE azi01 = nma10 AND nma01 = l_nme.nme01
   IF NOT cl_null(l_azi04) THEN                       
      CALL cl_digcut(l_nme.nme04,l_azi04) RETURNING l_nme.nme04
   END IF
   LET l_nme.nme21 = 1
   LET l_nme.nme22 = '13'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
 
   LET l_nme.nmelegal= g_legal
   LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04

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
#FUN-B30166--add--end`

   INSERT INTO nme_file VALUES(l_nme.*)
   IF STATUS THEN 
      CALL cl_err3("ins","nme_file",l_nme.nme02,"",STATUS,"","ins nme:",1)  #No.FUN-660148
   LET g_success='N' END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
END FUNCTION
 
FUNCTION t710_del_nme()
 DEFINE l_nme24     LIKE nme_file.nme24  #No.FUN-730032
 
   IF cl_null(g_nne.nne01) THEN RETURN END IF
   IF NOT cl_null(g_nne.nne15) THEN RETURN END IF
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme12='",g_nne.nne01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nne.nne01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   DELETE FROM nme_file WHERE nme12=g_nne.nne01  #FUN-560095
   IF STATUS THEN 
      CALL cl_err3("del","nme_file",g_nne.nne01,"",STATUS,"","del nme:",1)  #No.FUN-660148
   LET g_success='N' END IF
   
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04=g_nne.nne01
   IF STATUS THEN 
      CALL cl_err3("del","tic_file",g_nne.nne01,"",STATUS,"","del tic:",1)
   LET g_success='N' END IF
   #FUN-B40056  --end
   END IF                   #No.TQC-B70021 
END FUNCTION
 
FUNCTION t710_6()
   DEFINE l_wc             LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
   DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_lock_sw        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE nnf04f_t         LIKE nnf_file.nnf04f   #No.FUN-4C0010
   DEFINE nnf04_t,nnf04_o  LIKE nnf_file.nnf04    #No.FUN-4C0010
   DEFINE l_rec_b          LIKE type_file.num5    #No.MOD-480290 #No.FUN-680107 SMALLINT
   DEFINE p_cmd            LIKE type_file.chr1    #No.MOD-480290 #No.FUN-680107 VARCHAR(1)
   DEFINE l_amt            LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #No.FUN-4C0010
          l_nnn05          LIKE nnn_file.nnn05
   DEFINE l_nnf   DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
               nnf02     LIKE nnf_file.nnf02,
               nnf08     LIKE nnf_file.nnf08,
               nnf03     LIKE nnf_file.nnf03,
               nnf04f    LIKE nnf_file.nnf04f,
               nnf04     LIKE nnf_file.nnf04,
               nnf05     LIKE nnf_file.nnf05,
               nnf06     LIKE nnf_file.nnf06,   #MOD-8C0090 mod
               nmd02     LIKE nmd_file.nmd02    #MOD-8C0090 mod
                END RECORD
   DEFINE l_nnf_t   RECORD                        #程式變數(Program Variables)
               nnf02     LIKE nnf_file.nnf02,
               nnf08     LIKE nnf_file.nnf08,
               nnf03     LIKE nnf_file.nnf03,
               nnf04f    LIKE nnf_file.nnf04f,
               nnf04     LIKE nnf_file.nnf04,
               nnf05     LIKE nnf_file.nnf05,
               nnf06     LIKE nnf_file.nnf06,   #MOD-8C0090 mod
               nmd02     LIKE nmd_file.nmd02    #MOD-8C0090 mod
                END RECORD
   DEFINE l_allow_insert  LIKE type_file.num5     #可新增否 #No.FUN-680107 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5     #可刪除否 #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF STATUS THEN RETURN END IF
   SELECT nnn05 INTO l_nnn05 FROM nnn_file WHERE nnn01 = g_nne.nne06
   IF l_nnn05 ='N' THEN CALL cl_err(g_nne.nne06,'anm-288',1) RETURN END IF
   IF g_nne.nneconf = 'N' THEN RETURN END IF
   IF g_nne.nneconf='X' THEN CALL cl_err(g_nne.nne01,'9024',0) RETURN END IF
 
 
   OPEN WINDOW t710_6w AT 3,3
     WITH FORM "anm/42f/anmt7101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt7101")
 
 
   INITIALIZE l_nnf_t.* TO NULL
   SELECT SUM(nnf04f),SUM(nnf04) INTO nnf04f_t,nnf04_t FROM nnf_file
    WHERE nnf01 = g_nne.nne01
   DISPLAY BY NAME nnf04f_t,nnf04_t
   CALL l_nnf.clear()
   DECLARE t710_6_c CURSOR WITH HOLD FOR
         SELECT nnf02,nnf08,nnf03,nnf04f,nnf04,nnf05,nnf06,nmd02      #No.MOD-510076
          FROM nnf_file LEFT JOIN nmd_file ON nnf06 = nmd_file.nmd01
         WHERE nnf01 = g_nne.nne01
         ORDER BY 1
   LET i = 1
   FOREACH t710_6_c INTO l_nnf[i].*
      LET i = i + 1
   END FOREACH
    CALL l_nnf.deleteElement(i)  #No.MOD-480290
    LET l_rec_b = i - 1          #No.MOD-480290
   BEGIN WORK
   LET g_success = 'Y'
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET i = 1
   INPUT ARRAY l_nnf WITHOUT DEFAULTS FROM s_nnf.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
 
       BEFORE INPUT
           IF l_rec_b != 0 THEN
              CALL fgl_set_arr_curr(i)
           END IF
 
       BEFORE ROW
          LET i = ARR_CURR()
          LET j = SCR_LINE()
           IF l_rec_b >= i THEN          #No.MOD-480290
             LET p_cmd = 'u'
             LET l_nnf_t.* = l_nnf[i].*
          ELSE
             LET p_cmd = 'a'
          END IF
          CALL cl_show_fld_cont()       #No.FUN-550037
          CALL cl_set_comp_entry("nnf08,nnf03,nnf04f,nnf04,nnf05",cl_null(l_nnf[i].nnf06))   #MOD-8C0090 add
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
             CANCEL INSERT         #No.MOD-480290
         END IF
         INSERT INTO nnf_file (nnf01,nnf02,nnf03,nnf04f,nnf04,nnf05,
                               nnf06,nnf07,nnf08,nnflegal) #FUN-980005 add legal
                 VALUES (g_nne.nne01,l_nnf[i].nnf02,l_nnf[i].nnf03,
                         l_nnf[i].nnf04f,l_nnf[i].nnf04,l_nnf[i].nnf05,
                         l_nnf[i].nnf06,l_nnf[i].nmd02,l_nnf[i].nnf08,
                         g_legal)
         IF STATUS THEN
            CALL cl_err3("ins","nnf_file",g_nne.nne01,l_nnf[i].nnf02,STATUS,"","ins nnf",1)  #No.FUN-660148
            LET g_success = 'N'
         END IF
 
       BEFORE FIELD nnf02
          IF cl_null(l_nnf[i].nnf02) THEN
             SELECT MAX(nnf02) INTO l_nnf[i].nnf02 FROM nnf_file
              WHERE nnf01 = g_nne.nne01
             IF l_nnf[i].nnf02 IS NULL THEN
                LET l_nnf[i].nnf02=0
             END IF
             LET l_nnf[i].nnf02 = l_nnf[i].nnf02 + 1
          END IF
 
        AFTER FIELD nnf02                        #check 序號是否重複
            IF NOT cl_null(l_nnf[i].nnf02) THEN
               IF l_nnf[i].nnf02 != l_nnf_t.nnf02 OR cl_null(l_nnf_t.nnf02) THEN
                  SELECT count(*) INTO g_cnt FROM nnf_file
                   WHERE nnf01 = g_nne.nne01 AND nnf02 = l_nnf[i].nnf02
                  IF g_cnt > 0 THEN
                     LET l_nnf[i].nnf02 = l_nnf_t.nnf02
                     CALL cl_err('',-239,0) NEXT FIELD nnf02
                  END IF
               END IF
            END IF
 
        AFTER FIELD nnf08
           IF NOT cl_null(l_nnf[i].nnf02) THEN
              IF l_nnf[i].nnf08 NOT MATCHES '[12]' THEN
                 NEXT FIELD nnf08
              END IF
           END IF
 
        AFTER FIELD nnf04f
           IF NOT cl_null(l_nnf[i].nnf02) THEN
              CALL cl_digcut(l_nnf[i].nnf04f,t_azi04) RETURNING l_nnf[i].nnf04f
              DISPLAY l_nnf[i].nnf04f TO s_nnf[j].nnf04f
              LET l_nnf[i].nnf04 = l_nnf[i].nnf04f * g_nne.nne17
              CALL cl_digcut(l_nnf[i].nnf04,g_azi04) RETURNING l_nnf[i].nnf04   #FUN-690076
              DISPLAY l_nnf[i].nnf04 TO s_nnf[j].nnf04
           END IF
 
        AFTER FIELD nnf04
           IF NOT cl_null(l_nnf[i].nnf02) THEN
              CALL cl_digcut(l_nnf[i].nnf04,g_azi04) RETURNING l_nnf[i].nnf04   #FUN-690076
              DISPLAY l_nnf[i].nnf04 TO s_nnf[j].nnf04
           END IF
 
        AFTER FIELD nnf05
           IF NOT cl_null(l_nnf[i].nnf02) THEN
              IF NOT cl_null(l_nnf[i].nnf05) THEN
                 SELECT COUNT(*) INTO g_cnt FROM nma_file
                  WHERE nma01=l_nnf[i].nnf05
                 IF g_cnt = 0 THEN
                    CALL cl_err(l_nnf[i].nnf05,'anm-013',0)
                    LET l_nnf[i].nnf05 = l_nnf_t.nnf05
                    DISPLAY l_nnf[i].nnf05 TO s_nnf[j].nnf05
                    NEXT FIELD nnf05
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF cl_null(l_nnf_t.nnf06) THEN   #MOD-8C0090 add
              IF l_nnf_t.nnf02 > 0 AND l_nnf_t.nnf02 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM nnf_file
                  WHERE nnf01 = g_nne.nne01
                    AND nnf02 = l_nnf_t.nnf02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","nnf_file",g_nne.nne01,l_nnf_t.nnf02,SQLCA.sqlcode,"","del nnf:",1)  #No.FUN-660148
                    LET g_success = 'N'
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
           END IF   #MOD-8C0090 add
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_nnf[i].* = l_nnf_t.*
             EXIT INPUT
          END IF
          UPDATE nnf_file SET nnf02=l_nnf[i].nnf02,
                              nnf03=l_nnf[i].nnf03,
                              nnf04f=l_nnf[i].nnf04f,
                              nnf04=l_nnf[i].nnf04,
                              nnf05=l_nnf[i].nnf05,
                              nnf06=l_nnf[i].nnf06,
                              nnf07=l_nnf[i].nmd02,
                              nnf08=l_nnf[i].nnf08
           WHERE nnf01 = g_nne.nne01 AND nnf02 = l_nnf_t.nnf02
          IF STATUS THEN
             CALL cl_err3("upd","nnf_file",g_nne.nne01,l_nnf_t.nnf02,SQLCA.sqlcode,"","upd nnf",1)  #No.FUN-660148
             LET g_success = 'N'
          END IF
 
       AFTER ROW
          LET i  = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET l_nnf[i].* = l_nnf_t.*
           #FUN-D30032--add--str--
              ELSE
                 CALL l_nnf.deleteElement(i)
           #FUN-D30032--add--end--
             END IF
             EXIT INPUT
          END IF
          COMMIT WORK
          SELECT SUM(nnf04f),SUM(nnf04) INTO nnf04f_t,nnf04_t FROM nnf_file
           WHERE nnf01 = g_nne.nne01
          DISPLAY BY NAME nnf04f_t,nnf04_t
 
       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF nnf04_t != (g_nne.nne19-g_nne.nne20) THEN
             CALL cl_err('','anm-234',0)
          END IF
 
       ON ACTION controlp
          IF INFIELD(nnf05) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_nma"
             LET g_qryparam.default1 = l_nnf[i].nnf05
             CALL cl_create_qry() RETURNING l_nnf[i].nnf05
              DISPLAY l_nnf[i].nnf05 TO nnf05             #No.MOD-490344
             NEXT FIELD nnf05
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
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
 
   CLOSE WINDOW t710_6w
 
END FUNCTION
 
FUNCTION t710_g_np()
   DEFINE l_nmd         RECORD LIKE nmd_file.*
   DEFINE l_nmf         RECORD LIKE nmf_file.*
   DEFINE l_nnf         RECORD LIKE nnf_file.*
   DEFINE l_n           LIKE type_file.num10,         #No.FUN-680107 INTEGER
          l_cnt         LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_start,l_end LIKE nmd_file.nmd01           #No.FUN-680107 VARCHAR(16) #No.FUN-560002
   DEFINE l_slip        LIKE oay_file.oayslip         #No.FUN-680107 VARCHAR(5)  #No.FUN-560002
   DEFINE l_nnn05       LIKE nnn_file.nnn05
   DEFINE li_result     LIKE type_file.num5           #No.FUN-560002 #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF STATUS THEN
      RETURN
   END IF
   SELECT nnn05 INTO l_nnn05 FROM nnn_file WHERE nnn01 = g_nne.nne06
   IF l_nnn05 ='N' THEN
      CALL cl_err(g_nne.nne06,'anm-288',1)
      RETURN
   END IF
   IF g_nne.nneconf = 'N' THEN
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM nmd_file
     WHERE nmd10=g_nne.nne01                 #No.MOD-510076
   IF l_n>0 THEN
       CALL cl_err(g_nne.nne01,'aap-741',0)    #No.MOD-510076
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   LET l_slip = NULL
 
 
   OPEN WINDOW t710_g_np_w AT 4,12
     WITH FORM "anm/42f/anmt7102"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt7102")
 
 
   INPUT BY NAME l_slip WITHOUT DEFAULTS
 
       AFTER FIELD l_slip
          IF cl_null(l_slip) THEN
             NEXT FIELD l_slip
          END IF
          CALL s_check_no("anm",l_slip,"","1","","","") #FUN-560095
               RETURNING li_result,l_slip
          DISPLAY BY NAME l_slip
          IF (NOT li_result) THEN
               NEXT FIELD l_slip
          END IF
 
 
       ON ACTION controlp
          IF INFIELD(l_slip) THEN
             CALL q_nmy(FALSE,FALSE,l_slip,'1','ANM')  #TQC-670008
             RETURNING l_slip #票據性質:應付票據
             DISPLAY BY NAME l_slip
             NEXT FIELD l_slip
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
      CLOSE WINDOW t710_g_np_w
      RETURN
   END IF
   LET l_cnt = 1
   LET l_start = null
   LET l_end = null
   DECLARE t710_g_np CURSOR FOR
    SELECT * FROM nnf_file
     WHERE nnf01 = g_nne.nne01
       AND nnf06 IS NULL
   CALL s_showmsg_init()  #No.FUN-710024
   FOREACH t710_g_np INTO l_nnf.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         CALL s_errmsg('nnf01',g_nne.nne01,'foreach nnf',STATUS,0)   #No.FUN-710024
         LET g_success='N'               #FUN-8A0086 
         EXIT FOREACH
      END IF
      INITIALIZE l_nmd.* TO NULL
      LET l_nmd.nmd01= l_slip         #No.FUN-550057
      CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nne.nne02,"1","nmd_file","nmd01",
           "","","")
      RETURNING li_result,l_nmd.nmd01
      IF (NOT li_result) THEN
           EXIT FOREACH
      END IF
#      DISPLAY BY NAME l_nmd.nmd01 #No.TQC-950167  
 
      LET l_nmd.nmd02=l_nnf.nnf07   #票號
      LET l_nmd.nmd03=l_nnf.nnf05   #付款銀行
      LET l_nmd.nmd04=l_nnf.nnf04f  #票面金額
      LET l_nmd.nmd05=l_nnf.nnf03   #到期日
      LET l_nmd.nmd06= NULL         #票別一
      LET l_nmd.nmd07=g_nne.nne02   #開票日
      LET l_nmd.nmd08='MISC'
      SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09
        FROM alg_file WHERE alg01=g_nne.nne04
      LET l_nmd.nmd10=g_nne.nne01
      LET l_nmd.nmd12='X'
      LET l_nmd.nmd13=g_nne.nne02
      LET l_nmd.nmd14='3'
      LET l_nmd.nmd19=1
      LET l_nmd.nmd20=NULL
      LET l_nmd.nmd21=g_nne.nne16
      LET l_nmd.nmd25=g_nne.nne18
      LET l_nmd.nmd26=l_nnf.nnf04
      LET l_nmd.nmd30='N'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      LET l_nmd.nmddate=TODAY
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd51 = '1'
      LET l_nmd.nmd52 = g_nne.nne01
      LET l_nmd.nmd53 = 'Y'
      IF l_nnf.nnf08 = '2' THEN
         LET l_nmd.nmd23 = g_nne.nne_c1
         IF g_aza.aza63 = 'Y' THEN
            LET l_nmd.nmd231 = g_nne.nne_c11
         END IF
         LET l_nmd.nmd31 = 99    # 感謝老天爺, 提供後門99來使用
      END IF
      IF l_cnt = 1 THEN
         LET l_start = l_nmd.nmd01
         LET l_end = l_nmd.nmd01
      ELSE
         LET l_end = l_nmd.nmd01
      END IF
      LET l_nmd.nmd33=l_nmd.nmd19
 
      LET l_nmd.nmdlegal= g_legal
 
      LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL s_errmsg('nmd01',l_nmd.nmd01,'ins nmd:',STATUS,1)  #No.FUN-710024
         LET g_success = 'N'
         CONTINUE FOREACH      #NO.FUN-710024
      END IF
      INITIALIZE l_nmf.* TO NULL
      LET l_nmf.nmf01=l_nmd.nmd01
      LET l_nmf.nmf02=l_nnf.nnf03
      LET l_nmf.nmf03="00001"
      LET l_nmf.nmf04=g_user
       LET l_nmf.nmf05='0'        #No.MOD-510040
      LET l_nmf.nmf06='X'
      LET l_nmf.nmf07=l_nmd.nmd08
      LET l_nmf.nmf08=0
      LET l_nmf.nmf09=l_nmd.nmd19
 
      LET l_nmf.nmflegal= g_legal
 
      INSERT INTO nmf_file VALUES(l_nmf.*)              # 注意多工廠環境
      IF STATUS THEN
         LET g_showmsg = l_nmf.nmf01,"/",l_nmf.nmf03                  #NO.FUN-710024
         CALL s_errmsg('nmf01,nmf03',g_showmsg,'ins nmf:',STATUS,1)   #No.FUN-710024
         LET g_success = 'N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      UPDATE nnf_file SET nnf06 = l_nmd.nmd01
       WHERE nnf01 = l_nnf.nnf01
         AND nnf02 = l_nnf.nnf02
      IF STATUS THEN
         LET g_showmsg = l_nnf.nnf01,"/",l_nnf.nnf02                 #No.FUN-710024
         CALL s_errmsg('nnf01,nnf02',g_showmsg,'upd nnf:',STATUS,1)  #No.FUN-710024
         LET g_success = 'N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant  & legal
        VALUES ('anmt710',g_user,g_today,'U nmf',g_nne.nne01,'UPDATE nnf',g_plant,g_legal)
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW t710_g_np_w
   MESSAGE 'Start No :',l_start,' End No :',l_end
END FUNCTION
 
FUNCTION t710_del_np()
   DEFINE l_nmd         RECORD LIKE nmd_file.*
   DEFINE l_nmf         RECORD LIKE nmf_file.*
   DEFINE l_nnf         RECORD LIKE nnf_file.*
   DEFINE l_nnn05       LIKE nnn_file.nnn05
   DEFINE l_cnt         LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          l_start,l_end LIKE nmd_file.nmd01        #No.FUN-680107 VARCHAR(16) #No.FUN-560002
   DEFINE l_n           LIKE type_file.num5        #MOD-5C0126 #No.FUN-680107 SMALLINT
 
   SELECT COUNT(*) INTO l_n FROM nmd_file
     WHERE nmd10=g_nne.nne01
   IF l_n=0 THEN
      CALL cl_err(g_nne.nne01,'aap-751',0)
      RETURN
   END IF
 
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF STATUS THEN
      RETURN
   END IF
   SELECT nnn05 INTO l_nnn05 FROM nnn_file WHERE nnn01 = g_nne.nne06
   IF l_nnn05 ='N' THEN
      RETURN
   END IF
 
   IF g_nne.nneconf = 'N' THEN
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
 
   IF NOT cl_sure(18,10) THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   LET l_start = null
   LET l_end = null
   LET l_cnt = 1
   DECLARE t710_del_np CURSOR FOR
    SELECT * FROM nnf_file
     WHERE nnf01 = g_nne.nne01
       AND nnf06 IS NOT NULL
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t710_del_np INTO l_nnf.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         CALL s_errmsg('nnf01',g_nne.nne01,'foreach nnf_del',STATUS,0)   #No.FUN-710024
         LET g_success='N'        #FUN-8A0086 
         EXIT FOREACH
      END IF
 
      SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=l_nnf.nnf06
      IF STATUS THEN
         CALL s_errmsg('nmd01',l_nnf.nnf06,g_nne.nne28,'anm-221',1)       #No.FUN-710024
         CONTINUE FOREACH  #No.FUN-710024
      END IF
      IF l_nmd.nmd12 <> 'X' THEN
         CALL cl_err(g_nne.nne28,'anm-236',0)
         EXIT FOREACH
      END IF
      DELETE FROM nmd_file WHERE nmd01 = l_nnf.nnf06
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('nmd01',l_nnf.nnf06,'del nmd',STATUS,1)   #No.FUN-710024
         LET g_success = 'N'
      END IF
      DELETE FROM nmf_file WHERE nmf01 = l_nmd.nmd01
                             AND nmf02 = l_nnf.nnf03
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg = l_nmd.nmd01,"/",l_nnf.nnf03                  #No.FUN-710024
         CALL s_errmsg('nmf01,nmf02',g_showmsg,'del nmf',STATUS,1)    #No.FUN-710024
         LET g_success = 'N'
      END IF
      UPDATE nnf_file SET nnf06 = NULL
       WHERE nnf01 = l_nnf.nnf01
         AND nnf02 = l_nnf.nnf02
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg = l_nnf.nnf01,"/",l_nnf.nnf02                  #No.FUN-710024
         CALL s_errmsg('nnf01,nnf02',g_showmsg,'upd nnf',STATUS,1)    #No.FUN-710024
         LET g_success = 'N'
      END IF
 
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant  & legal
         VALUES ('anmt710',g_user,g_today,'R nmd',g_nne.nne01,'Delete nmf',g_plant,g_legal)
      IF l_cnt = 1 THEN
         LET l_start = l_nnf.nnf06
         LET l_end = l_nnf.nnf06
      ELSE
         LET l_end = l_nnf.nnf06
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL cl_end(18,10)
   MESSAGE 'Start No :',l_start,' End No :',l_end
 
END FUNCTION
 
FUNCTION t710_g_gl(p_trno,p_npptype)
   DEFINE p_trno       LIKE npp_file.npp01        #No.FUN-680107 VARCHAR(20)
   DEFINE p_npptype    LIKE npp_file.npptype      #No.FUN-680088
   DEFINE l_buf        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(70)
   DEFINE l_n          LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          l_t          LIKE nmy_file.nmyslip,     #No.FUN-680107 VARCHAR(05) #No.FUN-560002
          l_nmydmy3    LIKE nmy_file.nmydmy3
 
   SELECT * INTO g_nne.* FROM nne_file WHERE nne01 = g_nne.nne01
   IF p_trno IS NULL THEN
      RETURN
   END IF
   IF g_nne.nneconf='Y' THEN
      CALL cl_err(g_nne.nne01,'anm-232',0)
      RETURN
   END IF
   IF g_nne.nneconf='X' THEN
      CALL cl_err(g_nne.nne01,'9024',0)
      RETURN
   END IF
   IF NOT cl_null(g_nne.nneglno) THEN
      CALL cl_err(g_nne.nne01,'aap-122',1)
      RETURN
   END IF
   #-->立帳日期不可小於關帳日期
   IF g_nne.nne02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nne.nne01,'aap-176',1)
      RETURN
   END IF
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)       #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN
      LET l_nmydmy3 = 'N'
   END IF
   IF l_nmydmy3 = 'N' THEN
      CALL cl_err('','aap-286',1) #MOD-990156            
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM npq_file
    WHERE npqsys='NM' AND npq00=16 AND npq01=p_trno AND npq011=0
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN      #No.FUN-680088
         IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero

         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = p_trno
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               RETURN
            END IF
         END IF
         DELETE FROM tic_file WHERE tic04 = p_trno
         #FUN-B40056--add--end--
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=16 AND npq01=p_trno AND npq011=0
      END IF      #No.FUN-680088
   END IF
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =16
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
  #LET g_npp.npp02 =g_nne.nne02       #MOD-C50032 mark
   LET g_npp.npp02 =g_nne.nne03       #MOD-C50032
   LET g_npp.npptype = p_npptype      #No.FUN-680088
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #NO.TQC-790093 
      UPDATE npp_file SET npp02=g_npp.npp02
       WHERE nppsys='NM' AND npp00=16 AND npp01=p_trno AND npp011=0
         AND npptype = p_npptype      #No.FUN-680088
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","npp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         RETURN
      END IF
   END IF
   IF SQLCA.SQLCODE THEN
      CALL cl_err('ins npp:',STATUS,1)
      RETURN
   END IF
   CALL t710_g_gl_1(p_trno,p_npptype)
   CALL t710_gen_diff()                       #FUN-A40033
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t710_g_gl_1(p_trno,p_npptype) #分錄底稿產生
   DEFINE p_npptype    LIKE npp_file.npptype      #No.FUN-680088
   DEFINE p_trno       LIKE alk_file.alk01,
          l_nma05      LIKE nma_file.nma05,
          l_aag15      LIKE aag_file.aag15,
          l_aag05      LIKE aag_file.aag05
   DEFINE l_azi04       LIKE azi_file.azi04   #FUN-690076  
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_azi04_2   LIKE azi_file.azi04    #FUN-A40067
   DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq05 = g_nne.nne44
   LET g_npq.npqtype = p_npptype      #No.FUN-680088
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF g_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
#FUN-A40067 --Begin                                                             
   SELECT aaa03 INTO l_aaa03 FROM aaa_file                                      
    WHERE aaa01 = g_bookno2                                                     
   SELECT azi04 INTO l_azi04_2 FROM azi_file                                    
    WHERE azi01 = l_aaa03                                                       
#FUN-A40067 --End
 
  #IF cl_null(g_nne.nne35) THEN  #MOD-B40043 mark
      #--------------------- ( 自保 ) ----------------------------#
      #分錄底稿單身檔 借:銀行存款
      LET g_npq.npq02 = 1             #項次
      LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
      #本幣金額
      LET g_npq.npq07 = g_nne.nne19 - g_nne.nne24 - g_nne.nne37 -
                        #g_nne.nne29 - g_nne.nne25   #FUN-640242
                        g_nne.nne29 - g_nne.nne25 - g_nne.nne46  #FUN-640242
      #原幣金額
     IF g_nne.nne24=0 AND g_nne.nne37=0 AND
        #g_nne.nne29=0 AND g_nne.nne25=0 THEN   #FUN-640242
        g_nne.nne29=0 AND g_nne.nne25=0 AND g_nne.nne46=0 THEN   #FUN-640242
        LET g_npq.npq07f= g_nne.nne12
     ELSE
        LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
     END IF
      LET g_npq.npq24 = g_nne.nne16   #原幣幣別
      SELECT azi04 INTO l_azi04 FROM azi_file
        WHERE azi01 = g_npq.npq24
      LET g_npq.npq25 = g_nne.nne17   #匯率
      LET g_npq25     = g_npq.npq25        #No.FUN-9A0036
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = g_nne.nne_d1  #科目
      ELSE
         LET g_npq.npq03 = g_nne.nne_d11  #科目
      END IF
      LET g_npq.npq04 = NULL  #FUN-D10065
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                AND aag00 = g_bookno3       #No.FUN-730032
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         LET g_npq.npq05 = g_nne.nne44
      END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
      RETURNING  g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
      #No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)
          IF p_npptype = '1' THEN                #FUN-A40067
      LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04)
#---FUN-A40067 start--
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
      END IF
#---FUN-A40067 end--
      LET g_npq.npqlegal= g_legal
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d1:",1)  #No.FUN-660148
         LET g_success='N' 
      END IF
 
      # 借:預付費用
      LET g_npq.npq07 = g_nne.nne25 #No.7901
      IF p_npptype = '0' THEN
         IF g_nne.nne_d2 IS NOT NULL AND g_npq.npq07> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d2
            LET g_npq.npq07 = g_nne.nne25 #No.7901
            LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno1       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)    
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04)   #FUN-9A0036
           LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
                 LET g_success='N' END IF
         END IF
      ELSE
         IF g_nne.nne_d21 IS NOT NULL AND g_npq.npq07> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d21
            LET g_npq.npq07 = g_nne.nne25 #No.7901
            LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno2       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
            
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)   
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
           #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
                 LET g_success='N' END IF
        END IF
      END IF
      #保證費用
      IF p_npptype = '0' THEN
         IF g_nne.nne_d4 IS NOT NULL AND g_nne.nne29> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d4
            LET g_npq.npq07 = g_nne.nne29
            LET g_npq.npq07f= g_nne.nne291   #FUN-690076
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno1       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
            
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)   
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
           #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d4:",1)  #No.FUN-660148
               LET g_success='N'
            END IF
         END IF
      ELSE
         IF g_nne.nne_d41 IS NOT NULL AND g_nne.nne29> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d41
            LET g_npq.npq07 = g_nne.nne29
            LET g_npq.npq07f= g_nne.nne291   #FUN-690076
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno2       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
            
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)   
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
           #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d4:",1)  #No.FUN-660148
               LET g_success='N'
            END IF
         END IF
      END IF
      #承銷費
      IF p_npptype = '0' THEN
         IF g_nne.nne_d5 IS NOT NULL AND g_nne.nne24> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d5
            LET g_npq.npq07 = g_nne.nne24
            LET g_npq.npq07f= g_nne.nne241   #FUN-690076
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno1       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
             
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
           #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d5:",1)  #No.FUN-660148
               LET g_success='N'
            END IF
          END IF
      ELSE
         IF g_nne.nne_d51 IS NOT NULL AND g_nne.nne24> 0 THEN
            LET g_npq.npq02 = g_npq.npq02+1
            LET g_npq.npq03 = g_nne.nne_d51
            LET g_npq.npq07 = g_nne.nne24
            LET g_npq.npq07f= g_nne.nne241   #FUN-690076
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno2       #No.FUN-730032
            IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
            ELSE
               LET g_npq.npq05 = g_nne.nne44
            END IF
            LET g_npq.npq04 = NULL  #FUN-D10065
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
            RETURNING  g_npq.*
             
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
          END IF
          #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d5:",1)  #No.FUN-660148
               LET g_success='N'
            END IF
          END IF
       END IF
       #簽證費
       IF p_npptype = '0' THEN
          IF g_nne.nne_d6 IS NOT NULL AND g_nne.nne37> 0 THEN
             LET g_npq.npq02 = g_npq.npq02+1
             LET g_npq.npq03 = g_nne.nne_d6
             LET g_npq.npq07 = g_nne.nne37
             LET g_npq.npq07f= g_nne.nne371   #FUN-690076
             SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno1       #No.FUN-730032
             IF l_aag05='N' THEN
                LET g_npq.npq05 = ''
             ELSE
                LET g_npq.npq05 = g_nne.nne44
             END IF
             LET g_npq.npq04 = NULL  #FUN-D10065
             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
             RETURNING  g_npq.*
              
             CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
           #FUN-D40118--add--str--
           SELECT aag44 INTO g_aag44 FROM aag_file
            WHERE aag00 = g_bookno3
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
           #FUN-D40118--add--end--
             INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d6:",1)  #No.FUN-660148
                  LET g_success='N'
             END IF
          END IF
       ELSE
          IF g_nne.nne_d61 IS NOT NULL AND g_nne.nne37> 0 THEN
             LET g_npq.npq02 = g_npq.npq02+1
             LET g_npq.npq03 = g_nne.nne_d61
             LET g_npq.npq07 = g_nne.nne37
             LET g_npq.npq07f= g_nne.nne371   #FUN-690076
             SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno2       #No.FUN-730032
             IF l_aag05='N' THEN
                LET g_npq.npq05 = ''
             ELSE
                LET g_npq.npq05 = g_nne.nne44
             END IF
             LET g_npq.npq04 = NULL  #FUN-D10065
             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
             RETURNING  g_npq.*
              
             CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
             #FUN-D40118--add--str--
             SELECT aag44 INTO g_aag44 FROM aag_file
              WHERE aag00 = g_bookno3
                AND aag01 = g_npq.npq03
             IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
                IF l_flag = 'N'   THEN
                   LET g_npq.npq03 = ''
                END IF
             END IF
             #FUN-D40118--add--end--
             INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d6:",1)  #No.FUN-660148
                  LET g_success='N'
             END IF
          END IF
       END IF
 
      #交割服務費
       IF p_npptype = '0' THEN
          IF g_nne.nne_d7 IS NOT NULL AND g_nne.nne46> 0 THEN
             LET g_npq.npq02 = g_npq.npq02+1
             LET g_npq.npq03 = g_nne.nne_d7
             LET g_npq.npq07 = g_nne.nne46
             LET g_npq.npq07f= g_nne.nne461  #FUN-690076
             SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno1       #No.FUN-730032
             IF l_aag05='N' THEN
                LET g_npq.npq05 = ''
             ELSE
                LET g_npq.npq05 = g_nne.nne44
             END IF
             LET g_npq.npq04 = NULL  #FUN-D10065
             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
             RETURNING  g_npq.*
              
             CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
             #FUN-D40118--add--str--
             SELECT aag44 INTO g_aag44 FROM aag_file
              WHERE aag00 = g_bookno3
                AND aag01 = g_npq.npq03
             IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
                IF l_flag = 'N'   THEN
                   LET g_npq.npq03 = ''
                END IF
             END IF
             #FUN-D40118--add--end--
             INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d7:",1)  #No.FUN-660148
                  LET g_success='N'
             END IF
          END IF
       ELSE
          IF g_nne.nne_d71 IS NOT NULL AND g_nne.nne46> 0 THEN
             LET g_npq.npq02 = g_npq.npq02+1
             LET g_npq.npq03 = g_nne.nne_d71
             LET g_npq.npq07 = g_nne.nne46
             LET g_npq.npq07f= g_nne.nne461   #FUN-690076
             SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno2       #No.FUN-730032
             IF l_aag05='N' THEN
                LET g_npq.npq05 = ''
             ELSE
                LET g_npq.npq05 = g_nne.nne44
             END IF
             LET g_npq.npq04 = NULL  #FUN-D10065
             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
             RETURNING  g_npq.*
               
             CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
           LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#          LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
           LET g_npq.npqlegal= g_legal
             #FUN-D40118--add--str--
             SELECT aag44 INTO g_aag44 FROM aag_file
              WHERE aag00 = g_bookno3
                AND aag01 = g_npq.npq03
             IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
                IF l_flag = 'N'   THEN
                   LET g_npq.npq03 = ''
                END IF
             END IF
             #FUN-D40118--add--end-- 
             INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d7:",1)  #No.FUN-660148
                  LET g_success='N'
             END IF
          END IF
       END IF
 
 
      # 貸:短期票據融資
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = g_nne.nne_c1
      ELSE
         LET g_npq.npq03 = g_nne.nne_c11
      END IF
      LET g_npq.npq06 = '2'
      LET g_npq.npq07 = g_nne.nne19
     IF g_nne.nne24=0 AND g_nne.nne37=0 AND
        #g_nne.nne29=0 AND g_nne.nne25=0 THEN   #FUN-640242
        g_nne.nne29=0 AND g_nne.nne25=0 AND g_nne.nne46=0 THEN   #FUN-640242
        LET g_npq.npq07f=g_nne.nne12
     ELSE
        LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
     END IF
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                AND aag00 = g_bookno3       #No.FUN-730032
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         LET g_npq.npq05 = g_nne.nne44
      END IF
      LET g_npq.npq04 = NULL  #FUN-D10065
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
      RETURNING  g_npq.*
       
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
     IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
     IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
           IF p_npptype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE                                                                      
              IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
     LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
#    LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
      LET g_npq.npqlegal= g_legal
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
        IF STATUS THEN 
           CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
           LET g_success='N'
      END IF
      CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
  #-MOD-B40043-mark-
  #ELSE
  #   # ----------------------- ( 他保銀行 ) -----------------------------#
  #   #分錄底稿單身檔 借:銀行存款
  #   LET g_npq.npq02 = 1
  #   LET g_npq.npq06 = '1'
  #   LET g_npq.npq24 = g_nne.nne16
  #   SELECT azi04 INTO l_azi04 FROM azi_file   
  #     WHERE azi01 = g_npq.npq24
  #   LET g_npq.npq25 = g_nne.nne17
  #   IF p_npptype = '0' THEN
  #      LET g_npq.npq03 = g_nne.nne_d1
  #   ELSE
  #      LET g_npq.npq03 = g_nne.nne_d11
  #   END IF
  #   LET g_npq.npq07 = g_nne.nne19-g_nne.nne24-g_nne.nne37-g_nne.nne25-g_nne.nne46   #FUN-640242
  #  IF g_nne.nne24=0 AND g_nne.nne37=0 AND
  #     g_nne.nne25=0 AND g_nne.nne46=0 THEN   #FUN-640242
  #     LET g_npq.npq07f=g_nne.nne12
  #  ELSE
  #     LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
  #  END IF
  #   SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                             AND aag00 = g_bookno3       #No.FUN-730032
  #   IF l_aag05='N' THEN
  #      LET g_npq.npq05 = ''
  #   ELSE
  #      LET g_npq.npq05 = g_nne.nne44
  #   END IF
  #   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #   RETURNING  g_npq.*
  #     
  #   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #     
  #  IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #  IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #  LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
# #  LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #   LET g_npq.npqlegal= g_legal
  #   INSERT INTO npq_file VALUES (g_npq.*)
  #   IF STATUS THEN
  #      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d1:",1)  #No.FUN-660148
  #      LET g_success='N'
  #   END IF
  #   # 借:預付費用
  #   LET g_npq.npq07 = g_nne.nne25 #No.7901
  #   IF p_npptype = '0' THEN
  #      IF g_nne.nne_d2 IS NOT NULL AND g_npq.npq07 > 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d2
  #         LET g_npq.npq07 = g_nne.nne25 #No.7901
  #         LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#N#.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04) 
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #              CALL cl_err('ins npq_d2:',STATUS,1)   #No.FUN-660148
  #              CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
  #              LET g_success='N' END IF
  #      END IF
  #   ELSE
  #      IF g_nne.nne_d21 IS NOT NULL AND g_npq.npq07 > 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d21
  #         LET g_npq.npq07 = g_nne.nne25 #No.7901
  #         LET g_npq.npq07f= g_npq.npq07 / g_nne.nne17
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #              CALL cl_err('ins npq_d2:',STATUS,1)   #No.FUN-660148
  #              CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
  #              LET g_success='N' END IF
  #      END IF
  #   END IF
  #   #保證費用
  #   IF p_npptype = '0' THEN
  #      IF g_nne.nne_d4 IS NOT NULL AND g_nne.nne29> 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d4
  #         LET g_npq.npq07 = g_nne.nne29
  #         LET g_npq.npq07f= g_nne.nne291   #FUN-690076
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #           
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#N#.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #           CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d4:",1)  #No.FUN-660148
  #           LET g_success='N'
  #         END IF
  #      END IF
  #   ELSE
  #      IF g_nne.nne_d41 IS NOT NULL AND g_nne.nne29> 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d41
  #         LET g_npq.npq07 = g_nne.nne29
  #         LET g_npq.npq07f= g_nne.nne291  #FUN-690076
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)    
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #           CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d4:",1)  #No.FUN-660148
  #           LET g_success='N'
  #         END IF
  #      END IF
  #   END IF
  #   #承銷費
  #   IF p_npptype = '0' THEN
  #      IF g_nne.nne_d5 IS NOT NULL AND g_nne.nne24> 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d5
  #         LET g_npq.npq07 = g_nne.nne24
  #         LET g_npq.npq07f= g_nne.nne241  #FUN-690076
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #              CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d5:",1)  #No.FUN-660148
  #            LET g_success='N'
  #         END IF
  #       END IF
  #   ELSE
  #      IF g_nne.nne_d51 IS NOT NULL AND g_nne.nne24> 0 THEN
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = g_nne.nne_d51
  #         LET g_npq.npq07 = g_nne.nne24
  #         LET g_npq.npq07f= g_nne.nne241   #FUN-690076
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #                       
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #        IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #        IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #         LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
# #         LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #           IF STATUS THEN 
  #              CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d5:",1)  #No.FUN-660148
  #            LET g_success='N'
  #         END IF
  #       END IF
  #    END IF
  #    #簽證費
  #    IF p_npptype = '0' THEN
  #       IF g_nne.nne_d6 IS NOT NULL AND g_nne.nne37> 0 THEN
  #          LET g_npq.npq02 = g_npq.npq02+1
  #          LET g_npq.npq03 = g_nne.nne_d6
  #          LET g_npq.npq07 = g_nne.nne37
  #          LET g_npq.npq07f= g_nne.nne371   #FUN-690076
  #          SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #          IF l_aag05='N' THEN
  #             LET g_npq.npq05 = ''
  #          ELSE
  #             LET g_npq.npq05 = g_nne.nne44
  #          END IF
  #          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #          RETURNING  g_npq.*
  #          
  #          CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #          INSERT INTO npq_file VALUES (g_npq.*)
  #            IF STATUS THEN 
  #               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d6:",1)  #No.FUN-660148
  #               LET g_success='N'
  #          END IF
  #       END IF
  #    ELSE
  #       IF g_nne.nne_d61 IS NOT NULL AND g_nne.nne37> 0 THEN
  #          LET g_npq.npq02 = g_npq.npq02+1
  #          LET g_npq.npq03 = g_nne.nne_d61
  #          LET g_npq.npq07 = g_nne.nne37
  #          LET g_npq.npq07f= g_nne.nne371   #FUN-690076
  #          SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #          IF l_aag05='N' THEN
  #             LET g_npq.npq05 = ''
  #          ELSE
  #             LET g_npq.npq05 = g_nne.nne44
  #          END IF
  #          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #          RETURNING  g_npq.*
  #           
  #          CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04) 
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #          INSERT INTO npq_file VALUES (g_npq.*)
  #            IF STATUS THEN 
  #               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d6:",1)  #No.FUN-660148
  #               LET g_success='N'
  #          END IF
  #       END IF
  #    END IF
  #   
  #    #交割服務費
  #    IF p_npptype = '0' THEN
  #       IF g_nne.nne_d7 IS NOT NULL AND g_nne.nne46> 0 THEN
  #          LET g_npq.npq02 = g_npq.npq02+1
  #          LET g_npq.npq03 = g_nne.nne_d7
  #          LET g_npq.npq07 = g_nne.nne46
  #          LET g_npq.npq07f= g_nne.nne461   #FUN-690076
  #          SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #          IF l_aag05='N' THEN
  #             LET g_npq.npq05 = ''
  #          ELSE
  #             LET g_npq.npq05 = g_nne.nne44
  #          END IF
  #          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #          RETURNING  g_npq.*
  #           
  #          CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04) 
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #         LET g_npq.npqlegal= g_legal
  #          INSERT INTO npq_file VALUES (g_npq.*)
  #            IF STATUS THEN 
  #            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d7:",1)  #No.FUN-660148
  #            LET g_success='N'
  #          END IF
  #       END IF
  #    ELSE
  #       IF g_nne.nne_d71 IS NOT NULL AND g_nne.nne46> 0 THEN
  #          LET g_npq.npq02 = g_npq.npq02+1
  #          LET g_npq.npq03 = g_nne.nne_d71
  #          LET g_npq.npq07 = g_nne.nne46
  #          LET g_npq.npq07f= g_nne.nne461  #FUN-690076
  #          SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #          IF l_aag05='N' THEN
  #             LET g_npq.npq05 = ''
  #          ELSE
  #             LET g_npq.npq05 = g_nne.nne44
  #          END IF
  #          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #          RETURNING  g_npq.*
  #           
  #          CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #          LET g_npq.npqlegal= g_legal
  #          INSERT INTO npq_file VALUES (g_npq.*)
  #            IF STATUS THEN 
  #            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d7:",1)  #No.FUN-660148
  #            LET g_success='N'
  #          END IF
  #       END IF
  #    END IF
 
 
 
  #   # 貸:銀行存款
  #   IF p_npptype = '0' THEN
  #      IF g_nne.nne_d4 IS NOT NULL AND g_nne.nne29> 0 THEN   #MOD-5C0157
  #         SELECT nma05 INTO l_nma05 FROM nma_file WHERE nma01=g_nne.nne35
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = l_nma05
  #         LET g_npq.npq06 = '2'
  #         LET g_npq.npq07f= g_nne.nne291   #FUN-690076
  #         LET g_npq.npq07 = g_nne.nne29
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno1       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)  
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #          LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #         IF STATUS THEN
  #            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
  #            LET g_success='N'
  #         END IF
  #      END IF   #MOD-5C0157
  #   ELSE
  #      IF g_nne.nne_d41 IS NOT NULL AND g_nne.nne29> 0 THEN   #MOD-5C0157
  #         SELECT nma051 INTO l_nma05 FROM nma_file WHERE nma01=g_nne.nne35
  #         LET g_npq.npq02 = g_npq.npq02+1
  #         LET g_npq.npq03 = l_nma05
  #         LET g_npq.npq06 = '2'
  #         LET g_npq.npq07f= g_nne.nne291   #FUN-690076
  #         LET g_npq.npq07 = g_nne.nne29
  #         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                                   AND aag00 = g_bookno2       #No.FUN-730032
  #         IF l_aag05='N' THEN
  #            LET g_npq.npq05 = ''
  #         ELSE
  #            LET g_npq.npq05 = g_nne.nne44
  #         END IF
  #         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #         RETURNING  g_npq.*
  #                          
  #         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #        IF p_npptype = '1' THEN
  #           CALL s_newrate(g_bookno1,g_bookno2,
  #                          g_npq.npq24,g_npq25,g_npp.npp02)
  #           RETURNING g_npq.npq25
  #           LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #        ELSE                                                                      
  #           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #        END IF
#No.FUN-9A0036 --End
  #          LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04)   
  #         #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #          LET g_npq.npqlegal= g_legal
  #         INSERT INTO npq_file VALUES (g_npq.*)
  #         IF STATUS THEN
  #            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
  #            LET g_success='N'
  #         END IF
  #      END IF   #MOD-5C0157
  #   END IF
  #   # 貸:短期票據融資
  #   LET g_npq.npq02 = g_npq.npq02+1
  #   IF p_npptype = '0' THEN
  #      LET g_npq.npq03 = g_nne.nne_c1
  #   ELSE
  #      LET g_npq.npq03 = g_nne.nne_c11
  #   END IF
  #   LET g_npq.npq06 = '2'
  #  IF g_nne.nne24=0 AND g_nne.nne37=0 AND
  #     g_nne.nne25=0 AND g_nne.nne46=0 THEN   #FUN-640242
  #     LET g_npq.npq07f=g_nne.nne12
  #  ELSE
  #     LET g_npq.npq07f= g_nne.nne19 / g_nne.nne17
  #  END IF
  #   LET g_npq.npq07 = g_nne.nne19
  #   SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
  #                                             AND aag00 = g_bookno3       #No.FUN-730032
  #   IF l_aag05='N' THEN
  #      LET g_npq.npq05 = ''
  #   ELSE
  #      LET g_npq.npq05 = g_nne.nne44
  #   END IF
  #   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
  #   RETURNING  g_npq.*
  #    
  #   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
  #   IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #   IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
#No.FUN-9A0036 --Begin
  #   IF p_npptype = '1' THEN
  #      CALL s_newrate(g_bookno1,g_bookno2,
  #                     g_npq.npq24,g_npq25,g_npp.npp02)
  #      RETURNING g_npq.npq25
  #      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
# #      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
  #   ELSE                                                                      
  #      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
  #      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
  #   END IF
#N#.FUN-9A0036 --End
  #   LET g_npq.npq07f = cl_digcut(g_npq.npq07f,l_azi04) 
  #  #LET g_npq.npq07  = cl_digcut(g_npq.npq07 ,g_azi04) #FUN-A40067
  #   LET g_npq.npqlegal= g_legal
  #   INSERT INTO npq_file VALUES (g_npq.*)
  #   IF STATUS THEN
  #      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
  #      LET g_success='N'
  #   END IF
  #END IF
  #-MOD-B40043-end-
END FUNCTION
 
FUNCTION t710_aag(p_key,p_flag)
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE aag_file.aag01,
      p_flag     LIKE type_file.chr1,         #No.FUN-730032
      p_cmd      LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    CALL s_get_bookno(YEAR(g_nne.nne02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_nne.nne02),'aoo-081',1)
    END IF
    IF p_flag = '0' THEN
       LET g_bookno3 = g_bookno1
    ELSE
       LET g_bookno3 = g_bookno2
    END IF
   LET g_errno = " "
   SELECT aag02,aagacti,aag07,aag03,aag09
     INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
     FROM aag_file
    WHERE aag01=p_key
      AND aag00 = g_bookno3       #No.FUN-730032
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                               LET l_aag02 = NULL
                               LET l_aagacti = NULL
      WHEN l_aagacti='N'       LET g_errno = '9028'
      WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
      WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
      WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   RETURN l_aag02
END FUNCTION
 
FUNCTION t710_k()
   IF cl_null(g_nne.nne01) THEN
      RETURN
   END IF
   IF g_nne.nneconf = 'N' THEN
      CALL cl_err('','anm-960',0)
      RETURN
   END IF
   IF g_nne.nneconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   INPUT BY NAME g_nne.nne26 WITHOUT DEFAULTS
 
      AFTER FIELD nne26
         IF g_nne.nne26<g_nne.nne02 THEN
            NEXT FIELD nne26
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         BEGIN WORK
         UPDATE nne_file SET nne26=g_nne.nne26
          WHERE nne01=g_nne.nne01
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            ROLLBACK WORK
         ELSE
            COMMIT WORK
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
END FUNCTION
 
FUNCTION t710_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("nne01",TRUE)
   END IF
 
   IF INFIELD(nne06) THEN    #No.MOD-4A0177
      CALL cl_set_comp_entry("nne22,nne23,nne241,nne24,nne25,nne291,nne29,nne34,nne36,nne371,nne37,nne45,nne461,nne46,nne_d4,nne_d5,nne_d6,nne_d7",TRUE)   #FUN-690076
      IF g_aza.aza63 = 'Y' THEN 
         CALL cl_set_comp_entry("nne_d41,nne_d51,nne_d61,nne_d71",TRUE)  
      END IF
     #-MOD-B50191-add-
      IF g_nnn07 = "Y" THEN
         CALL cl_set_comp_entry("nne05,nne051",TRUE) 
      END IF 
     #-MOD-B50191-end-
   END IF
 
   IF INFIELD(nne05) THEN
      CALL cl_set_comp_entry("nne051",TRUE)
   END IF
 
   IF INFIELD(nne41) THEN
      CALL cl_set_comp_entry("nne31,nne42",TRUE)
   END IF

   IF g_nne.nne32 = 'Y' THEN                      #MOD-CA0017 add
      CALL cl_set_comp_entry("nne33",TRUE)        #MOD-CA0017 add
   END IF                                         #MOD-CA0017 add
 
END FUNCTION
 
FUNCTION t710_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nne01",FALSE)
   END IF
 
   IF INFIELD(nne06) THEN    #No.MOD-4A0177
      IF g_nnn06 ="2" OR g_nnn06 ="3" THEN
      ELSE
         CALL cl_set_comp_entry("nne23,nne241,nne24,nne25,nne291,nne29,nne34,nne36,nne371,nne37,nne45,nne461,nne46,nne_d4,nne_d5,nne_d6,nne_d7",FALSE)    #FUN-690076   #MOD-840248
         IF g_aza.aza63 = 'Y' THEN 
            CALL cl_set_comp_entry("nne_d41,nne_d51,nne_d61,nne_d71",FALSE)  
         END IF
      END IF
     #-MOD-B50191-add-
      IF g_nnn07 = "N" THEN
         CALL cl_set_comp_entry("nne05,nne051",FALSE) 
      END IF 
     #-MOD-B50191-end-
   END IF
 
   IF INFIELD(nne05) THEN
      IF cl_null(g_nne.nne05) THEN
         CALL cl_set_comp_entry("nne051",FALSE)
      END IF
   END IF
 
   IF INFIELD(nne41) THEN
      IF g_nne.nne41 = "N" THEN
         CALL cl_set_comp_entry("nne31,nne42",FALSE)
      END IF
   END IF
 
   IF g_nne.nne32 = 'N' THEN                      #MOD-CA0017 add
      CALL cl_set_comp_entry("nne33",FALSE)       #MOD-CA0017 add
   END IF                                         #MOD-CA0017 add

END FUNCTION
 
FUNCTION t710_set_required(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
 
   IF g_nne.nne29 > 0 THEN
      CALL cl_set_comp_required("nne_d4",TRUE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d41",TRUE)
      END IF
   END IF
 
   IF g_nne.nne24 > 0 THEN
      CALL cl_set_comp_required("nne_d5",TRUE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d51",TRUE)
      END IF
   END IF
 
   IF g_nne.nne37 > 0 THEN
      CALL cl_set_comp_required("nne_d6",TRUE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d61",TRUE)
      END IF
   END IF
 
   IF g_nne.nne46 > 0 THEN
      CALL cl_set_comp_required("nne_d7",TRUE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d71",TRUE)
      END IF
   END IF
 
 
END FUNCTION
 
FUNCTION t710_set_no_required(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF g_nne.nne29<=0 THEN   #FUN-640242
      CALL cl_set_comp_required("nne_d4",FALSE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d41",FALSE)
      END IF
   END IF
 
   IF g_nne.nne24<=0 THEN   #FUN-640242
      CALL cl_set_comp_required("nne_d5",FALSE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d51",FALSE)
      END IF
   END IF
 
   IF g_nne.nne37<=0 THEN   #FUN-640242
      CALL cl_set_comp_required("nne_d6",FALSE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d61",FALSE)
      END IF
   END IF
 
   IF g_nne.nne46<=0 THEN
      CALL cl_set_comp_required("nne_d7",FALSE)
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_required("nne_d71",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t710_gen_glcr(p_nne,p_nmy)
  DEFINE p_nne     RECORD LIKE nne_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_nne.nne01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t710_g_gl(g_nne.nne01,'0')
    IF g_aza.aza63 = 'Y' THEN
       CALL t710_g_gl(g_nne.nne01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t710_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING                                                                                                       
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
                                                                                                                                    
    IF NOT cl_null(g_nne.nneglno) OR g_nne.nneglno IS NOT NULL THEN 
       CALL cl_err(g_nne.nneglno,'aap-618',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nne.nne01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN  #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102                                                                
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102   
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",                                                                                
                   "    AND aba01 = '",g_nne.nneglno,"'"                                                                                  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql                                                                                                      
       DECLARE aba_cs2 CURSOR FOR aba_pre2                                                                                              
       OPEN aba_cs2                                                                                                                     
       FETCH aba_cs2 INTO l_n                                                                                                           
       IF l_n > 0 THEN                                                                                                                  
          CALL cl_err(g_nne.nneglno,'aap-991',1)                                                                                          
          RETURN                                                                                                                        
       END IF     
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN  
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_nne.nne01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_nne.nne01,'" AND npp011 = 0'
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nne.nne02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT nneglno,nne02 INTO g_nne.nneglno,g_nne.nne02 FROM nne_file
     WHERE nne01 = g_nne.nne01
    DISPLAY BY NAME g_nne.nneglno
    DISPLAY BY NAME g_nne.nne02
    
END FUNCTION
 
FUNCTION t710_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_nne.nneglno) OR g_nne.nneglno IS NULL THEN
       CALL cl_err(g_nne.nneglno,'aap-619',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nne.nne01) RETURNING g_t1                                                                                    
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1                                                                           
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF                                                                                        
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036                                                                                                
       RETURN                                                                                                                        
    END IF 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nne.nneglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nne.nneglno,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nne.nneglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nneglno,nne02 INTO g_nne.nneglno,g_nne.nne02 FROM nne_file
     WHERE nne01 = g_nne.nne01
    DISPLAY BY NAME g_nne.nneglno
    DISPLAY BY NAME g_nne.nne02
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#FUN-A40033 --Begin
FUNCTION t710_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
         RETURN
      END IF
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal=g_legal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

