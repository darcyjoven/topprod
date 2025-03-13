# Prog. Version..: '5.30.07-13.06.04(00010)'     #
#
# Pattern name...: anmt840.4gl
# Descriptions...: 利息收入作業
# Date & Author..: 99/12/04 By Polly Hsu
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8664 03/11/11 By Kitty 若幣別為本幣,則不產生匯差
# Modify.........: No.8665 03/11/11 By Kitty 原幣未扣所得稅金額
# Modify.........: No:4A0176 04/10/12 By Nicola 單頭異動碼必需輸入, 且存提別須為'存入'
# Modify.........: No.MOD-4A0248 04/10/21 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-4C0009 04/12/08 By Nicola _b_tot中，gxi18,gxi19預設值設定
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: No.MOD-5A0389 05/11/08 By Smapmin 增加報表列印功能
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: NO.MOD-610052 06/01/12 By Smapmin 存入銀行應要輸入,存入幣別應不可以輸入.
# Modify.........: No.MOD-5C0161 06/01/12 By Smapmin 單身本幣所得稅輸入完後,原幣所得稅欄位未重算,以至於值為0!
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.TQC-630231 06/03/24 By Smapmin 無法列印
# Modify.........: No.MOD-640565 06/04/26 By Smapmin 產生分錄時,應收利息與利息收入科目相反
# Modify.........: No.MOD-640568 06/04/26 By Smapmin 產生分錄時,原幣金額少算利差
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-660131 06/06/29 By Smapmin 取消anm-629的判斷
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670066 06/07/18 By douzh voucher型報表轉template1
# Modify.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.TQC-680080 06/08/22 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680088 06/08/28 By day 多帳套修改
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0" 
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6C0036 07/01/08 By Smapmin 新增gxi18,gxj18二個欄位
# Modify.........: No.MOD-710171 07/01/26 By Smapmin 新增時,應要能夠即時判斷單別是否正確
# Modify.........: No.FUN-710024 07/01/29 By cheunl錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/22 By Elva  新增nme21,nme22,nme23,nme24
# Modify.........: No.TQC-710112 07/03/27 By Judy 匯率不可小于零
# Modify.........: No.MOD-730145 07/04/02 By Smapmin 修改利差與匯差公式
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-740299 07/05/02 By Sarah 
#                  1.進入單身後,右邊有個自動產生單身,當單身有資料時,會出現資料重複,應修改為先檢查單身有無資料,詢問是否刪除後重新產生
#                  2.已先執行利息暫估,修改單身止算日期時,暫估金額出現小數點
#                  3.產生的分錄,本幣金額出現小數
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.CHI-7B0037 07/12/07 By Smapmin 修改單身日期後,暫估金額不可重新計算,但實收金額必須重新計算
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810152 08/01/23 By Smapmin 有跨月的情況時,才去CHECK是否存在暫估資料
# Modify.........: No.MOD-810249 08/01/31 By Smapmin 代扣所得稅=實收利息收入*10%(國內稅率)
# Modify.........: No.MOD-820005 08/02/12 By Smapmin 實收原幣修改後實收本幣及代扣所得稅未重算
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-830151 08/05/07 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.CHI-850013 08/05/23 By Sarah 1.AFTER FIELD gxj031增加檢核gxf011=gxj031是否存在,並自動帶出gxj03=gxf01
#                                                  2.AFTER FIELD gxj03 增加檢核gxf011=gxj031 AND gxf01=gxj03是否存在
# Modify.........: No.FUN-870032 08/07/08 By Sarah gxj031欄位增加開窗功能
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-8A0121 08/10/16 By Sarah 連續新增第二筆,銀行名稱跟會計科目沒有正常帶出
# Modify.........: No.MOD-8A0184 08/10/21 By Sarah 1.程式裡判斷>=g_nmz.nmz56改為>g_nmz.nmz56
#                                                  2.AFTER FIELD gxj12段,無須再重算gxj12
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8A0231 08/10/30 By Sarah 將摘要(npq04)的舊值清空
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-920132 09/02/10 By Sarah 1.相關使用gxi03_y,gxi03_m抓取gxh_file的部分,改取gxj05(起算日期)年與月
#                                                  2.t840_g_b()部分改用gxi03_y,gxi03_m-1的方式;需判斷若gxi03_m=1時,gxi03_y=gxi03_y-1,gxi03_m=12
#                                                  3.畫面上gxi03_y,gxi03_m予以隱藏
# Modify.........: No.MOD-920171 09/02/12 By Sarah 當月第一次沖暫估利息時需要帶出暫估金額,確認時將入息單號回寫到anmt830的利息單號,
#                                                  後面同月的幾次入息,暫估金額應為0,且確認時不需回寫anmt830
# Modify.........: No.MOD-920267 09/02/19 By Dido 依據 gxi22 抓取 nme14 預設值
# Modify.........: No.MOD-920235 09/02/20 By Sarah t840_g_gl_1()段,若沒沖暫估的利息收入單,貸方科目應為nms70
# Modify.........: No.MOD-930323 09/03/31 By Sarah 新增後無法直接列印
# Modify.........: No.MOD-940059 09/04/09 By lilingyu 原暫估利息的利率計算錯誤
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-960085 09/06/10 By xiaofeizhu 增加“狀態”頁簽
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960407 09/06/29 By dxfwo 鎖單身時，沒有一并鎖單頭(同一筆數據，單頭被A修改中，但B卻可以修改單身)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:MOD-A10090 10/01/15 By Sarah
#                  1.當nmz04='1'時CALL s_bankex() ELSE CALL s_curr3(g_curr,p_date,'B')
#                  2.單身的止算日應由單頭止算日期帶入
#                  3.gxj11,gxj12,gxj13,gxj14金額重算後應重新做小數位數取位
#                  4.分錄底稿利差的原幣金額應為實收原幣-暫估原幣
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No:MOD-A10118 10/01/19 By Sarah 修正MOD-940059,UPDATE npq_file的WHERE條件增加項次
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-8C0019 10/06/08 By Summer gxiconf 改用下拉選單,增加作廢'X'選項
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:MOD-B10228 11/01/28 By Dido 定存單增加到期日檢核 
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.CHI-B30066 11/10/25 By Polly 判斷如果抓不到上個月的暫估利息，則抓取當月的暫估利息
# Modify.........: No.MOD-BB0206 11/11/17 By Polly 調整anm-615控卡條件
# Modify.........: No:TQC-C10011 12/01/04 By yinhy 狀態頁簽的“資料建立者”和“資料建立部門”欄位無法下查詢條件查詢
# Modify.........: No.MOD-C10017 12/01/04 By Polly 增加條件，做沖銷時，需gxh15=Y
# Modify.........: No.MOD-C10104 12/01/11 By Polly 單身的申請單號與存單號碼只需控卡定期存款狀態(gxf11)不為到期
# Modify.........: No.MOD-C10209 12/01/31 By Polly AFTER FILED gxj05/gxj06同時帶出gxj15/gxj16/gxj18/gxj19
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20101 12/02/14 By Polly 調整天數計數，算頭不算尾
# Modify.........: No.MOD-C30703 12/03/15 By wangrr 產生分錄底稿，當爲暫估：wq時原幣幣別設為暫估幣別
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C20028 12/05/31 By wangrr 在gxi22添加nmc02欄位
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-B80125 12/10/25 By Belle 作廢單據不做利息計算
# Modify.........: No.MOD-CA0121 12/10/18 by Polly 1.天數異動(gxj07)時，需重新計算 2.調整暫估金額區間抓取
# Modify.........: No:MOD-D10095 13/01/10 By Polly 調整誇年月抓取日期條件
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D30111 13/03/12 By Polly 增加單身gxj19欄位訊息提示aap-938
# Modify.........: No:MOD-CB0288 13/04/03 By apo 取消確認段增加檢核不可存在於anmt850單身中
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-CB0066 13/04/10 By apo 定存單增加作廢條件判斷
# Modify.........: No:FUN-C60006 13/05/08 By qirl 系統作廢/取消作廢需要及時更新修改者以及修改時間欄位
# Modify.........: No:MOD-D50113 13/05/14 By Lori 取消q_gxf03傳遞第二個參數
# Modify.........: No:FUN-D40118 13/05/20 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空 
# Modify.........: No.TQC-DA0025 13/10/21 By yangxf 修改删除逻辑BUG

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gxi               RECORD LIKE gxi_file.*,
    g_gxi_t             RECORD LIKE gxi_file.*,
    g_gxi_o             RECORD LIKE gxi_file.*,
    g_gxi01_t           LIKE gxi_file.gxi01,
    b_gxj               RECORD LIKE gxj_file.*,
    g_nmd               RECORD LIKE nmd_file.*,
    g_npp               RECORD LIKE npp_file.*,
    g_npq               RECORD LIKE npq_file.*,
    g_nms               RECORD LIKE nms_file.*,
    g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
    g_statu             LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01) # 是否從新賦予等級
    g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,   #No.FUN-980025 VARCHAR(10)
    ddd                 LIKE type_file.num5,    #No.FUN-680107 SMALLINT
    g_gxj           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        gxj02            LIKE gxj_file.gxj02,
        gxj031           LIKE gxj_file.gxj031,
        gxj03            LIKE gxj_file.gxj03,
        gxj05            LIKE gxj_file.gxj05,
        gxj06            LIKE gxj_file.gxj06,
        gxj07            LIKE gxj_file.gxj07,
        gxj08            LIKE gxj_file.gxj08,
        gxj11            LIKE gxj_file.gxj11,
        gxj13            LIKE gxj_file.gxj13,
        gxj12            LIKE gxj_file.gxj12,
        gxj14            LIKE gxj_file.gxj14,
        gxj15            LIKE gxj_file.gxj15,
        gxj16            LIKE gxj_file.gxj16,
        gxj18            LIKE gxj_file.gxj18,   #FUN-6C0036
        gxj19            LIKE gxj_file.gxj19
       ,gxjud01          LIKE gxj_file.gxjud01,
        gxjud02          LIKE gxj_file.gxjud02,
        gxjud03          LIKE gxj_file.gxjud03,
        gxjud04          LIKE gxj_file.gxjud04,
        gxjud05          LIKE gxj_file.gxjud05,
        gxjud06          LIKE gxj_file.gxjud06,
        gxjud07          LIKE gxj_file.gxjud07,
        gxjud08          LIKE gxj_file.gxjud08,
        gxjud09          LIKE gxj_file.gxjud09,
        gxjud10          LIKE gxj_file.gxjud10,
        gxjud11          LIKE gxj_file.gxjud11,
        gxjud12          LIKE gxj_file.gxjud12,
        gxjud13          LIKE gxj_file.gxjud13,
        gxjud14          LIKE gxj_file.gxjud14,
        gxjud15          LIKE gxj_file.gxjud15
                    END RECORD,
    g_gxj_t         RECORD                      #程式變數 (舊值)
        gxj02            LIKE gxj_file.gxj02,
        gxj031           LIKE gxj_file.gxj031,
        gxj03            LIKE gxj_file.gxj03,
        gxj05            LIKE gxj_file.gxj05,
        gxj06            LIKE gxj_file.gxj06,
        gxj07            LIKE gxj_file.gxj07,
        gxj08            LIKE gxj_file.gxj08,
        gxj11            LIKE gxj_file.gxj11,
        gxj13            LIKE gxj_file.gxj13,
        gxj12            LIKE gxj_file.gxj12,
        gxj14            LIKE gxj_file.gxj14,
        gxj15            LIKE gxj_file.gxj15,
        gxj16            LIKE gxj_file.gxj16,
        gxj18            LIKE gxj_file.gxj18,   #FUN-6C0036
        gxj19            LIKE gxj_file.gxj19
       ,gxjud01          LIKE gxj_file.gxjud01,
        gxjud02          LIKE gxj_file.gxjud02,
        gxjud03          LIKE gxj_file.gxjud03,
        gxjud04          LIKE gxj_file.gxjud04,
        gxjud05          LIKE gxj_file.gxjud05,
        gxjud06          LIKE gxj_file.gxjud06,
        gxjud07          LIKE gxj_file.gxjud07,
        gxjud08          LIKE gxj_file.gxjud08,
        gxjud09          LIKE gxj_file.gxjud09,
        gxjud10          LIKE gxj_file.gxjud10,
        gxjud11          LIKE gxj_file.gxjud11,
        gxjud12          LIKE gxj_file.gxjud12,
        gxjud13          LIKE gxj_file.gxjud13,
        gxjud14          LIKE gxj_file.gxjud14,
        gxjud15          LIKE gxj_file.gxjud15
                    END RECORD,
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    gl_no_b,gl_no_e     LIKE oea_file.oea01     #No.FUN-680107 VARCHAR(16) #No.FUN-550057
#------for ora修改-------------------
DEFINE g_system         LIKE ooy_file.ooytype   #No.FUN-680107 VARCHAR(2) #TQC-840066
DEFINE g_N              LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_chr          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_str          STRING                 #No.FUN-670060
DEFINE g_wc_gl        STRING                 #No.FUN-670060
DEFINE g_t1           LIKE oay_file.oayslip  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_argv1        LIKE gxi_file.gxi01    #No.FUN-680107 VARCHAR(16) #單號 #TQC-630074
DEFINE g_argv2        STRING                 #指定執行的功能 #TQC-630074
DEFINE g_void         LIKE type_file.chr1    #CHI-8C0019 add
DEFINE g_npq25        LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE g_flag         LIKE type_file.chr1    #MOD-C10017 add
DEFINE g_aag44        LIKE aag_file.aag44   #FUN-D40118 add
 
MAIN
   DEFINE
       p_row,p_col      LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
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
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074
 
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
 
   LET g_forupd_sql = "SELECT * FROM gxi_file WHERE gxi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t840_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   LET p_row = 1 LET p_col = 6
 
   OPEN WINDOW t840_w AT p_row,p_col
     WITH FORM "anm/42f/anmt840"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_aza.aza63 != 'Y' THEN
       CALL cl_set_comp_visible("gxi101",FALSE)
    ELSE
       CALL cl_set_comp_visible("gxi101",TRUE)
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t840_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t840_a()
            END IF
         OTHERWISE
            CALL t840_q()
      END CASE
   END IF
 
   IF cl_null(g_nmz.nmz56) THEN LET g_nmz.nmz56=0 END IF
   IF cl_null(g_nmz.nmz57) THEN LET g_nmz.nmz57=0 END IF
   CALL t840()
   CLOSE WINDOW t840_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t840()
   LET g_plant_new=g_nmz.nmz02p
   LET g_plant_gl =g_nmz.nmz02p #No.FUN-980025
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
   INITIALIZE g_gxi.* TO NULL
   INITIALIZE g_gxi_t.* TO NULL
   INITIALIZE g_gxi_o.* TO NULL
   CALL t840_menu()
END FUNCTION
 
FUNCTION t840_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
   CLEAR FORM
   CALL g_gxj.clear()
   IF cl_null(g_argv1) THEN
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_gxi.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON gxi01,gxi02,gxi03,gxi04,gxi05,                  #MOD-920132
                                gxi17,gxi08,gxi09,gxi22,gxiconf,gxiglno,
                                gxi11,gxi13,gxi12,gxi14,gxi15,gxi16,gxi18,gxi19,   #FUN-6C0036
                                gxi10,gxi101  #No.FUN-680088
                                ,gxiud01,gxiud02,gxiud03,gxiud04,gxiud05,
                                gxiud06,gxiud07,gxiud08,gxiud09,gxiud10,
                                gxiud11,gxiud12,gxiud13,gxiud14,gxiud15
                                ,gxiuser,gxigrup,gximodu,gxidate,gxiacti           #TQC-960085    
                                ,gxioriu,gxiorig                                   #TQC-C10011
  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gxi01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gxi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi01
                  NEXT FIELD gxi01
               WHEN INFIELD(gxi04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi04
                  NEXT FIELD gxi04
               WHEN INFIELD(gxi05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi05
                  NEXT FIELD gxi05
               WHEN INFIELD(gxi08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi08
                  NEXT FIELD gxi08
               WHEN INFIELD(gxi17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi17
                  NEXT FIELD gxi17
               WHEN INFIELD(gxi10) # Dept CODE
                  CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2       #No.FUN-730032
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_gxi.gxi10,'23',l_bookno1) #No.FUN-980025
                  RETURNING g_gxi.gxi10
                  DISPLAY BY NAME g_gxi.gxi10
               WHEN INFIELD(gxi101) # Dept CODE
                  CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2       #No.FUN-730032
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_gxi.gxi101,'23',l_bookno2)  #No.FUN-980025
                  RETURNING g_gxi.gxi101
                  DISPLAY BY NAME g_gxi.gxi101
               WHEN INFIELD(gxi22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxi22
                  NEXT FIELD gxi22
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
      CONSTRUCT g_wc2 ON gxj02,gxj031,gxj03,gxj05,gxj06,gxj07,gxj08
                        ,gxjud01,gxjud02,gxjud03,gxjud04,gxjud05
                        ,gxjud06,gxjud07,gxjud08,gxjud09,gxjud10
                        ,gxjud11,gxjud12,gxjud13,gxjud14,gxjud15
              FROM s_gxj[1].gxj02,s_gxj[1].gxj031,s_gxj[1].gxj03,s_gxj[1].gxj05,
                   s_gxj[1].gxj06,s_gxj[1].gxj07,s_gxj[1].gxj08
                  ,s_gxj[1].gxjud01,s_gxj[1].gxjud02,s_gxj[1].gxjud03
                  ,s_gxj[1].gxjud04,s_gxj[1].gxjud05,s_gxj[1].gxjud06
                  ,s_gxj[1].gxjud07,s_gxj[1].gxjud08,s_gxj[1].gxjud09
                  ,s_gxj[1].gxjud10,s_gxj[1].gxjud11,s_gxj[1].gxjud12
                  ,s_gxj[1].gxjud13,s_gxj[1].gxjud14,s_gxj[1].gxjud15
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
     
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gxj031)   #申請單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gxf03"   #MOD-B10228 mod gxf02 -> gxf03 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxj031
                  NEXT FIELD gxj031
               WHEN INFIELD(gxj03)    #存單號碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gxf03"   #MOD-B10228 mod gxf02 -> gxf03   
                  LET g_qryparam.state = "c"
                  LET g_qryparam.multiret_index = 2
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gxj03
                  NEXT FIELD gxj03
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
      LET g_wc =" gxi01 = '",g_argv1,"'"    #No.TQC-630074
      LET g_wc2 = ' 1=1'
   END IF
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxiuser', 'gxigrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT gxi01 FROM gxi_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY gxi01"
   ELSE
      LET g_sql="SELECT gxi01 FROM gxi_file,gxj_file ",
                " WHERE gxi01=gxj01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY gxi01"
   END IF
   PREPARE t840_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t840_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t840_prepare
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT COUNT(*) FROM gxi_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gxi01) FROM gxi_file,gxj_file",
                " WHERE gxi01=gxj01",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t840_precount FROM g_sql
   DECLARE t840_count CURSOR FOR t840_precount
END FUNCTION
 
FUNCTION t840_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
   WHILE TRUE
      CALL t840_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t840_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t840_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t840_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t840_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t840_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t840_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_entry_sheet"
            CALL t840_g_gl(g_gxi.gxi01,'0')
            IF g_aza.aza63 = 'Y' THEN
               CALL t840_g_gl(g_gxi.gxi01,'1')
            END IF
         WHEN "maintain_entry_sheet"
            CALL s_fsgl('NM',10,g_gxi.gxi01,0,g_nmz.nmz02b,0,g_gxi.gxiconf,'0',g_nmz.nmz02p)              
            CALL t840_npp02('0')
         WHEN "maintain_entry_sheet2"
            CALL s_fsgl('NM',10,g_gxi.gxi01,0,g_nmz.nmz02c,0,g_gxi.gxiconf,'1',g_nmz.nmz02p)              
            CALL t840_npp02('1')
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t840_firm1()
               #CHI-8C0019 add --start--
               IF g_gxi.gxiconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               #CHI-8C0019 add --end--
              #CALL cl_set_field_pic(g_gxi.gxiconf,"","","","","")      #CHI-8C0019 mark
               CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")  #CHI-8C0019
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t840_firm2()
               #CHI-8C0019 add --start--
               IF g_gxi.gxiconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               #CHI-8C0019 add --end--
              #CALL cl_set_field_pic(g_gxi.gxiconf,"","","","","")      #CHI-8C0019 mark
               CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")  #CHI-8C0019
            END IF
         #CHI-8C0019 add --start--
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t840_x() #FUN-D20035 mark
               CALL t840_x(1) #FUN-D20035 add
               IF g_gxi.gxiconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")
            END IF
         #CHI-8C0019 add --end--
         #FUN-D20035 add end
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t840_x(2)
               IF g_gxi.gxiconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")
            END IF
         #FUN-D20035 add end   
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_gxi.gxiconf = 'Y' THEN
                  CALL t840_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_gxi.gxiconf = 'Y' THEN
                  CALL t840_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gxj),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_gxi.gxi01 IS NOT NULL THEN
                 LET g_doc.column1 = "gxi01"
                 LET g_doc.value1 = g_gxi.gxi01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
    CLOSE t840_cs
END FUNCTION
 
FUNCTION t840_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_gxj.clear()
   INITIALIZE g_gxi.* LIKE gxi_file.*
   INITIALIZE g_gxi_t.* TO NULL   #MOD-8A0121 add
   INITIALIZE g_gxi_o.* TO NULL   #MOD-8A0121 add
   LET g_gxi_t.* = g_gxi.*
   LET g_gxi01_t = NULL
   LET g_gxi.gxi02 = g_today
   LET g_gxi.gxiconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_gxi.gxiacti ='Y'                   # 有效的資料
      LET g_gxi.gxiuser = g_user
      LET g_gxi.gxioriu = g_user #FUN-980030
      LET g_gxi.gxiorig = g_grup #FUN-980030
      LET g_gxi.gxigrup = g_grup               # 使用者所屬群
      LET g_gxi.gxidate = g_today
      LET g_gxi.gxiinpd = g_today
 
      LET g_gxi.gxilegal= g_legal
 
      CALL t840_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          INITIALIZE g_gxi.* TO NULL
          CALL cl_err('',9001,0)
          CLEAR FORM
          CALL g_gxj.clear()
          EXIT WHILE
      END IF
      IF g_gxi.gxi01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
        CALL s_auto_assign_no("anm",g_gxi.gxi01,g_gxi.gxi02,"D","gxi_file","gxi01","","","")
             RETURNING li_result,g_gxi.gxi01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gxi.gxi01
 
      INSERT INTO gxi_file VALUES(g_gxi.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gxi_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_gxi.gxi01,'I')
         LET g_gxi_t.* = g_gxi.*               # 保存上筆資料
         LET g_rec_b =0                        #NO.FUN-680064
         SELECT gxi01 INTO g_gxi.gxi01 FROM gxi_file
                WHERE gxi01 = g_gxi.gxi01
      END IF
      FOR g_i = 1 TO g_gxj.getLength() INITIALIZE g_gxj[g_i].* TO NULL END FOR
      CALL SET_COUNT(0)
      CALL t840_b()
      IF g_nmy.nmydmy1 = 'Y' THEN CALL t840_firm1() END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t840_i(p_cmd)
    DEFINE
        l_nmd01         LIKE nmd_file.nmd01,
        p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
        l_dept          LIKE cre_file.cre08,    #No.FUN-680107 VARCHAR(10),              #Dept
        l_n             LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
DEFINE  li_result       LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
DEFINE  l_nmc02        LIKE nmc_file.nmc02      #CHI-C20028 add
 
   DISPLAY BY NAME g_gxi.gxiuser,g_gxi.gximodu,                              #TQC-960085
       g_gxi.gxigrup,g_gxi.gxidate,g_gxi.gxiacti                             #TQC-960085
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_gxi.gxioriu,g_gxi.gxiorig,
           g_gxi.gxi01,g_gxi.gxi02,g_gxi.gxi03,                              #MOD-920132
           g_gxi.gxi04,g_gxi.gxi05,g_gxi.gxi17,g_gxi.gxi08,g_gxi.gxi09,
           g_gxi.gxi22,g_gxi.gxiconf,g_gxi.gxiglno,g_gxi.gxi11,
           g_gxi.gxi13,g_gxi.gxi12,g_gxi.gxi14,g_gxi.gxi15,g_gxi.gxi16,g_gxi.gxi18,g_gxi.gxi19,   #FUN-6C0036
           g_gxi.gxi10,g_gxi.gxi101   #No.FUN-680088
          ,g_gxi.gxiud01,g_gxi.gxiud02,g_gxi.gxiud03,g_gxi.gxiud04,
           g_gxi.gxiud05,g_gxi.gxiud06,g_gxi.gxiud07,g_gxi.gxiud08,
           g_gxi.gxiud09,g_gxi.gxiud10,g_gxi.gxiud11,g_gxi.gxiud12,
           g_gxi.gxiud13,g_gxi.gxiud14,g_gxi.gxiud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t840_set_entry(p_cmd)
         CALL t840_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxi01")
         CALL cl_set_docno_format("gxj031")
         CALL cl_set_docno_format("gxj03")
 
        AFTER FIELD gxi01
           IF NOT cl_null(g_gxi.gxi01) THEN   #MOD-710171
           CALL s_check_no("anm",g_gxi.gxi01,g_gxi_t.gxi01,"D","gxi_file","gxi01","")
              RETURNING li_result,g_gxi.gxi01
           DISPLAY BY NAME g_gxi.gxi01
           IF (NOT li_result) THEN
              NEXT FIELD gxi01
           END IF
           END IF
 
        AFTER FIELD gxi02
           IF NOT cl_null(g_gxi.gxi02) THEN
              IF g_gxi.gxi02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1)
                 NEXT FIELD gxi02
              END IF
           END IF
 
        AFTER FIELD gxi03
           IF NOT cl_null(g_gxi.gxi03) THEN
              LET g_gxi.gxi03_y= YEAR(g_gxi.gxi03)
              LET g_gxi.gxi03_m=MONTH(g_gxi.gxi03)
           END IF
 
        AFTER FIELD gxi04
           IF NOT cl_null(g_gxi.gxi04) THEN
              SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = g_gxi.gxi04
              IF SQLCA.SQLCODE OR l_n <= 0 THEN
                 CALL cl_err3("sel","azi_file",g_gxi.gxi04,"","anm-007","","",1)  #No.FUN-660148
                 NEXT FIELD gxi04
              END IF
           END IF
 
        AFTER FIELD gxi05
           IF NOT cl_null(g_gxi.gxi05) THEN
              IF cl_null(g_gxi_o.gxi05) OR g_gxi.gxi05 != g_gxi_o.gxi05 THEN
                 CALL t840_gxi05('1',g_gxi.gxi05)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_gxi.gxi05,g_errno,0)
                    LET g_gxi.gxi05 = g_gxi_o.gxi05
                    DISPLAY BY NAME g_gxi.gxi05
                    NEXT FIELD gxi05
                 END IF
              END IF
              LET g_gxi_o.gxi05 = g_gxi.gxi05
           END IF
 
        AFTER FIELD gxi17                       # 存入銀行
           IF NOT cl_null(g_gxi.gxi17) THEN
              IF cl_null(g_gxi_o.gxi17) OR g_gxi.gxi17 != g_gxi_o.gxi17 THEN
                 CALL t840_gxi05('2',g_gxi.gxi17)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_gxi.gxi17,g_errno,0)
                    LET g_gxi.gxi17 = g_gxi_o.gxi17
                    DISPLAY BY NAME g_gxi.gxi17
                    NEXT FIELD gxi17
                 END IF
                 SELECT nma05 INTO g_gxi.gxi10 FROM nma_file
                  WHERE nma01=g_gxi.gxi17
                 DISPLAY BY NAME g_gxi.gxi10
                 SELECT nma051 INTO g_gxi.gxi101 FROM nma_file
                  WHERE nma01=g_gxi.gxi17
                 DISPLAY BY NAME g_gxi.gxi101
              END IF
              LET g_gxi_o.gxi17 = g_gxi.gxi17
           END IF
 
        BEFORE FIELD gxi09                  # 自動計算出帳匯率
            IF g_gxi.gxi09 IS NULL OR g_gxi.gxi09 = 0 THEN
              #當nmz04='1'時CALL s_bankex() ELSE CALL s_curr3(curr,date,'B')
               SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
               IF g_nmz.nmz04='1' THEN
                  CALL s_bankex(g_gxi.gxi05,g_gxi.gxi02) RETURNING g_gxi.gxi09
               ELSE
                  CALL s_curr3(g_gxi.gxi08,g_gxi.gxi02,'B') RETURNING g_gxi.gxi09
               END IF
               DISPLAY BY NAME g_gxi.gxi09
            END IF
 
        AFTER FIELD gxi09
            IF NOT cl_null(g_gxi.gxi09) THEN
               IF g_gxi.gxi09 <= 0 THEN  #TQC-710112
                  CALL cl_err(g_gxi.gxi09,'anm-995',0)  #TQC-710112
                  NEXT FIELD gxi09
               END IF
            END IF
 
        AFTER FIELD gxi10
           IF NOT cl_null(g_gxi.gxi10) THEN
              CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
              IF l_flag1 = '1' THEN
                 CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
              END IF
              SELECT aag02 FROM aag_file WHERE aag01=g_gxi.gxi10
                                           AND aag00 = l_bookno1       #No.FUN-730032
              IF STATUS THEN
#FUN-B20073 --begin--
#                 CALL cl_err3("sel","aag_file",g_gxi.gxi10,"",STATUS,"","sel aag:",1)  #No.FUN-660148
                  CALL cl_err3("sel","aag_file",g_gxi.gxi10,"",STATUS,"","sel aag:",0)
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxi.gxi10,'23',l_bookno1)  
                    RETURNING g_gxi.gxi10
                    DISPLAY BY NAME g_gxi.gxi10
#FUN-B20073 --end--
                 NEXT FIELD gxi10
              END IF
           END IF
                
        AFTER FIELD gxi101
           IF NOT cl_null(g_gxi.gxi101) THEN
              CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
              IF l_flag1 = '1' THEN
                 CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
              END IF
              SELECT aag02 FROM aag_file WHERE aag01=g_gxi.gxi101
                                           AND aag00 = l_bookno1       #No.FUN-730032
              IF STATUS THEN
#FUN-B20073 --begin--
#                CALL cl_err3("sel","aag_file",g_gxi.gxi101,"",STATUS,"","sel aag:",1) 
                 CALL cl_err3("sel","aag_file",g_gxi.gxi101,"",STATUS,"","sel aag:",0)               
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxi.gxi101,'23',l_bookno2)  
                  RETURNING g_gxi.gxi101
                 DISPLAY BY NAME g_gxi.gxi101                 
#FUN-B20073 --end--                 
                 NEXT FIELD gxi101
              END IF
           END IF
 
        AFTER FIELD gxi22
           IF NOT cl_null(g_gxi.gxi22) THEN
              SELECT nmc03 FROM nmc_file WHERE nmc01=g_gxi.gxi22 AND nmc03='1'
              IF STATUS THEN 
                 CALL cl_err3("sel","nmc_file",g_gxi.gxi22,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
                 NEXT FIELD gxi22
              #CHI-C20028--add--str
              ELSE
                 LET l_nmc02=NULL
                 SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxi.gxi22
                 DISPLAY l_nmc02 TO FORMONLY.nmc02 
              #CHI-C20028--add--end
              END IF
           END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_gxi.gxiuser = s_get_data_owner("gxi_file") #FUN-C10039
           LET g_gxi.gxigrup = s_get_data_group("gxi_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gxi01)
                 LET g_t1 = s_get_doc_no(g_gxi.gxi01)       #No.FUN-550057
                 CALL q_nmy(FALSE,TRUE,g_t1,'D','ANM') RETURNING g_t1  #TQC-670008
                 LET g_gxi.gxi01 = g_t1    #No.FUN-550057
                 DISPLAY BY NAME g_gxi.gxi01 NEXT FIELD gxi01
              WHEN INFIELD(gxi04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_gxi.gxi04
                 CALL cl_create_qry() RETURNING g_gxi.gxi04
                 DISPLAY BY NAME g_gxi.gxi04 NEXT FIELD gxi04
              WHEN INFIELD(gxi08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_gxi.gxi08
                 CALL cl_create_qry() RETURNING g_gxi.gxi08
                 DISPLAY BY NAME g_gxi.gxi04 NEXT FIELD gxi08
              WHEN INFIELD(gxi05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_gxi.gxi05
                 CALL cl_create_qry() RETURNING g_gxi.gxi05
                 DISPLAY BY NAME g_gxi.gxi05 NEXT FIELD gxi05
              WHEN INFIELD(gxi17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_gxi.gxi17
                 CALL cl_create_qry() RETURNING g_gxi.gxi17
                 DISPLAY BY NAME g_gxi.gxi17 NEXT FIELD gxi17
              WHEN INFIELD(gxi10) # Dept CODE
                  CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
                  IF l_flag1 = '1' THEN
                      CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
                  END IF
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxi.gxi10,'23',l_bookno1)  #No.FUN-980025
                 RETURNING g_gxi.gxi10
                 DISPLAY BY NAME g_gxi.gxi10
              WHEN INFIELD(gxi101) # Dept CODE
                 CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
                 IF l_flag1 = '1' THEN
                     CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxi.gxi101,'23',l_bookno2)  #No.FUN-980025
                 RETURNING g_gxi.gxi101
                 DISPLAY BY NAME g_gxi.gxi101
              WHEN INFIELD(gxi22)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc01"     #No.MOD-4A0176
                  LET g_qryparam.arg1 = "1"           #No.MOD-4A0176
                 LET g_qryparam.default1 = g_gxi.gxi22
                 CALL cl_create_qry() RETURNING g_gxi.gxi22
                 DISPLAY BY NAME g_gxi.gxi22 NEXT FIELD gxi22
              WHEN INFIELD(gxi09)
                   CALL s_rate(g_gxi.gxi08,g_gxi.gxi09) RETURNING g_gxi.gxi09
                   DISPLAY BY NAME g_gxi.gxi09
                   NEXT FIELD gxi09
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
END FUNCTION
 
FUNCTION t840_gxi05(p_cmd,l_gxi05)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma   RECORD LIKE nma_file.*
   DEFINE l_gxi05 LIKE gxi_file.gxi05
 
   SELECT * INTO l_nma.*
     FROM nma_file WHERE nma01 = l_gxi05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = SQLCA.SQLCODE USING '-----'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   IF p_cmd='1' THEN
      DISPLAY l_nma.nma02 TO FORMONLY.nma02
   ELSE
      DISPLAY l_nma.nma02 TO FORMONLY.nma02_1
   END IF
  IF p_cmd = '2' THEN
     LET g_gxi.gxi08 = l_nma.nma10
     DISPLAY BY NAME g_gxi.gxi08
  END IF
END FUNCTION
 
FUNCTION t840_g_b()
   DEFINE l_gxh         RECORD LIKE gxh_file.*
   DEFINE l_gxj         RECORD LIKE gxj_file.*
   DEFINE l_gxi03_y     LIKE gxi_file.gxi03_y   #MOD-920132 add
   DEFINE l_gxi03_m     LIKE gxi_file.gxi03_m   #MOD-920132 add
   DEFINE l_cnt         LIKE type_file.num5     #CHI-B30066 add
 
   IF g_gxi.gxi01 IS NULL THEN RETURN END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxi.gxi08
 
   IF g_gxi.gxi03_m = 1 THEN
      LET l_gxi03_y = g_gxi.gxi03_y - 1
      LET l_gxi03_m = 12
   ELSE
      LET l_gxi03_y = g_gxi.gxi03_y
      LET l_gxi03_m = g_gxi.gxi03_m - 1
   END IF

  #----------------------------CHI-B30066------------start
   SELECT COUNT(*) INTO l_cnt
     FROM gxh_file
    WHERE gxh09=g_gxi.gxi04
      AND gxh14=g_gxi.gxi05
      AND gxh02=l_gxi03_y
      AND gxh03=l_gxi03_m
      AND gxh13 IS NULL
      AND gxh15 = 'Y'                      #MOD-C10017 add
   IF l_cnt = 0 THEN
      LET l_gxi03_y = g_gxi.gxi03_y
      LET l_gxi03_m = g_gxi.gxi03_m
   END IF 
  #----------------------------CHI-B30066--------------end
 
   DECLARE t840_g_b_c1 CURSOR WITH HOLD FOR
      SELECT *
        FROM gxh_file
       WHERE gxh09=g_gxi.gxi04
         AND gxh14=g_gxi.gxi05
         AND gxh02=l_gxi03_y      #MOD-920132
         AND gxh03=l_gxi03_m      #MOD-920132
         AND gxh13 IS NULL
         AND gxh15 = 'Y'          #MOD-C10017 add
       ORDER BY 1
   LET l_ac = 1
   LET l_gxj.gxj01=g_gxi.gxi01
   LET l_gxj.gxj02=0
   BEGIN WORK LET g_success='Y'
   FOREACH t840_g_b_c1 INTO l_gxh.*
      IF STATUS THEN CALL cl_err('g_b()foreach',STATUS,1) EXIT FOREACH END IF
      LET l_gxj.gxj031=l_gxh.gxh011
      LET l_gxj.gxj03=l_gxh.gxh01
      IF STATUS THEN CONTINUE FOREACH END IF
      # 注意: 僅月付息者, 可自動產生單身
      LET l_gxj.gxj05=l_gxh.gxh05
      LET l_gxj.gxj06=g_gxi.gxi03   #MOD-A10090 mod gxh06->gxi03
     #LET l_gxj.gxj07=l_gxj.gxj06-l_gxj.gxj05+1       #MOD-A10090 #MOD-C20101 mark
      LET l_gxj.gxj07=l_gxj.gxj06-l_gxj.gxj05         #MOD-C20101 add
      LET l_gxj.gxj08=l_gxh.gxh08
      LET l_gxj.gxj11=l_gxh.gxh11
      LET l_gxj.gxj13=l_gxh.gxh12
      IF l_gxh.gxh12> g_nmz.nmz56 THEN  #需扣所得稅   #MOD-8A0184
         LET l_gxj.gxj12=l_gxh.gxh11*(l_gxj.gxj07/l_gxh.gxh07)   #MOD-A10090 mod
         LET l_gxj.gxj14=l_gxj.gxj12*g_gxi.gxi09                 #MOD-A10090 mod
         LET l_gxj.gxj18 = l_gxj.gxj12*g_nmz.nmz57/100   #MOD-810249
         LET l_gxj.gxj19 = l_gxj.gxj18*g_gxi.gxi09
      ELSE
         LET l_gxj.gxj12=l_gxh.gxh11*(l_gxj.gxj07/l_gxh.gxh07)   #MOD-A10090 mod
         LET l_gxj.gxj14=l_gxj.gxj12*g_gxi.gxi09                 #MOD-A10090 mod
         LET l_gxj.gxj18=0
         LET l_gxj.gxj19=0
      END IF
      IF l_gxj.gxj11 != 0 THEN
         LET l_gxj.gxj15=(l_gxj.gxj12-l_gxj.gxj11)*g_gxi.gxi09
      ELSE
         LET l_gxj.gxj15= 0
      END IF
      IF g_gxi.gxi04 != g_aza.aza17 THEN
         IF l_gxj.gxj13 != 0 THEN
            LET l_gxj.gxj16=(l_gxj.gxj14-l_gxj.gxj13)-l_gxj.gxj15
         ELSE
            LET l_gxj.gxj16= 0
         END IF
      ELSE
         LET l_gxj.gxj16 = 0
      END IF
      CALL cl_digcut(l_gxj.gxj11,t_azi04) RETURNING l_gxj.gxj11
      CALL cl_digcut(l_gxj.gxj12,t_azi04) RETURNING l_gxj.gxj12
      CALL cl_digcut(l_gxj.gxj13,g_azi04) RETURNING l_gxj.gxj13
      CALL cl_digcut(l_gxj.gxj14,g_azi04) RETURNING l_gxj.gxj14
      CALL cl_digcut(l_gxj.gxj15,g_azi04) RETURNING l_gxj.gxj15
      CALL cl_digcut(l_gxj.gxj16,g_azi04) RETURNING l_gxj.gxj16
      CALL cl_digcut(l_gxj.gxj18,t_azi04) RETURNING l_gxj.gxj18
      CALL cl_digcut(l_gxj.gxj19,g_azi04) RETURNING l_gxj.gxj19
      LET l_gxj.gxj02=l_gxj.gxj02+1
      MESSAGE '>:',l_gxj.gxj02,' ',l_gxj.gxj031,' ',l_gxj.gxj03
 
      LET l_gxj.gxjlegal= g_legal
      INSERT INTO gxj_file VALUES(l_gxj.*)
      IF STATUS THEN
         CALL cl_err3("ins","gxj_file",l_gxj.gxj01,l_gxj.gxj02,STATUS,"","ins gxj:",1)  #No.FUN-660148
         LET g_success='N' EXIT FOREACH
      END IF
   END FOREACH
   IF STATUS THEN CALL cl_err('g_b()foreach',STATUS,1) END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL t840_b_tot()
END FUNCTION
 
FUNCTION t840_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gxi.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t840_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
   CALL g_gxj.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t840_count
   FETCH t840_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t840_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0)
      INITIALIZE g_gxi.* TO NULL
   ELSE
      CALL t840_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t840_fetch(p_flgxi)
   DEFINE
       p_flgxi         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flgxi
      WHEN 'N' FETCH NEXT     t840_cs INTO g_gxi.gxi01
      WHEN 'P' FETCH PREVIOUS t840_cs INTO g_gxi.gxi01
      WHEN 'F' FETCH FIRST    t840_cs INTO g_gxi.gxi01
      WHEN 'L' FETCH LAST     t840_cs INTO g_gxi.gxi01
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
            FETCH ABSOLUTE g_jump t840_cs INTO g_gxi.gxi01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0)
      INITIALIZE g_gxi.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flgxi
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_gxi.* FROM gxi_file       # 重讀DB,因TEMP有不被更新特性
    WHERE gxi01 = g_gxi.gxi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gxi_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_gxi.gxiuser     #No.FUN-4C0063
      LET g_data_group = g_gxi.gxigrup     #No.FUN-4C0063
      CALL t840_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t840_show()
DEFINE g_t1        LIKE oay_file.oayslip    #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
DEFINE li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-680107 SMALLINT
DEFINE l_nmc02     LIKE nmc_file.nmc02      #CHI-C20028 add

   LET g_gxi_t.* = g_gxi.*
   DISPLAY BY NAME g_gxi.gxioriu,g_gxi.gxiorig,
          g_gxi.gxi01, g_gxi.gxi02, g_gxi.gxi03,                                #MOD-920132
          g_gxi.gxi04, g_gxi.gxi05,
          g_gxi.gxi08, g_gxi.gxi10, g_gxi.gxi101,g_gxi.gxi17,  #No.FUN-680088
          g_gxi.gxi09, g_gxi.gxi22, g_gxi.gxiglno, g_gxi.gxiconf,
          g_gxi.gxi11, g_gxi.gxi12, g_gxi.gxi13,
          g_gxi.gxi14, g_gxi.gxi15, g_gxi.gxi16,g_gxi.gxi18,g_gxi.gxi19   #FUN-6C0036
          ,g_gxi.gxiud01,g_gxi.gxiud02,g_gxi.gxiud03,g_gxi.gxiud04,
           g_gxi.gxiud05,g_gxi.gxiud06,g_gxi.gxiud07,g_gxi.gxiud08,
           g_gxi.gxiud09,g_gxi.gxiud10,g_gxi.gxiud11,g_gxi.gxiud12,
           g_gxi.gxiud13,g_gxi.gxiud14,g_gxi.gxiud15 
           ,g_gxi.gxiuser,g_gxi.gxigrup,g_gxi.gximodu,g_gxi.gxidate,g_gxi.gxiacti           #TQC-960085
   CALL t840_gxi05('1',g_gxi.gxi05)
   CALL t840_gxi05('2',g_gxi.gxi17)
#CHI-C20028--add--str
   LET l_nmc02=NULL
   SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxi.gxi22
   DISPLAY l_nmc02 TO FORMONLY.nmc02
#CHI-C20028--add--end
   CALL t840_b_fill(' 1=1')
   LET g_t1 = s_get_doc_no(g_gxi.gxi01)       #No.FUN-550057
  #CALL s_check_no("anm",g_gxi.gxi01,"","D","","","")      #MOD-B10228 mark 
  #RETURNING li_result,g_gxi.gxi01                         #MOD-B10228 mark
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   #CHI-8C0019 add --end--
  #CALL cl_set_field_pic(g_gxi.gxiconf,"","","","","")      #CHI-8C0019 mark
   CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")  #CHI-8C0019
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t840_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_gxi.gxi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
  #IF g_gxi.gxiconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF  #CHI-8C0019 mark
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf='Y' THEN
      CALL cl_err(g_gxi.gxi01,'anm-105',2)
      RETURN
   END IF
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err(g_gxi.gxi01,'9024',0)
      RETURN
   END IF
   #CHI-8C0019 add --end--
   IF g_gxi.gxiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_gxi.gxi01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t840_cl USING g_gxi.gxi01
   IF STATUS THEN
      CALL cl_err("OPEN t840_cl:", STATUS, 1)
      CLOSE t840_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t840_cl INTO g_gxi.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0)
       RETURN
   END IF
   LET g_gxi01_t = g_gxi.gxi01
   LET g_gxi_o.*=g_gxi.*
   LET g_gxi_t.*=g_gxi.*
   LET g_gxi.gximodu=g_user                     #修改者
   LET g_gxi.gxidate = g_today                  #修改日期
   CALL t840_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t840_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gxi.*=g_gxi_t.*
         CALL t840_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gxi_file SET gxi_file.* = g_gxi.*    # 更新DB
       WHERE gxi01 = g_gxi01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gxi_file",g_gxi01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      IF g_gxi.gxi02 != g_gxi_t.gxi02 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_gxi.gxi02
          WHERE npp01=g_gxi.gxi01 AND npp00=10 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_gxi01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t840_cl
   COMMIT WORK
   CALL cl_flow_notify(g_gxi.gxi01,'U')
END FUNCTION
 
FUNCTION t840_npp02(p_npptype)              #No.FUN-680088
 DEFINE p_npptype  LIKE npp_file.npptype    #No.FUN-680088
 
   IF g_gxi.gxiglno IS NULL OR g_gxi.gxiglno=' ' THEN
      UPDATE npp_file SET npp02=g_gxi.gxi02
       WHERE npp01=g_gxi.gxi01 AND npp00=10 AND npp011=0
         AND nppsys = 'NM'
         AND npptype= p_npptype  #No.FUN-680088
      IF STATUS THEN 
         CALL cl_err3("upd","npp_file",g_gxi.gxi01,"",STATUS,"","upd npp02:",1)  #No.FUN-66014
      END IF
   END IF
END FUNCTION
 
FUNCTION t840_r()
   DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_gxi.gxi01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
  #IF g_gxi.gxiconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF #CHI-8C0019 mark
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf='Y' THEN
      CALL cl_err(g_gxi.gxi01,'anm-105',2)
      RETURN
   END IF
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err(g_gxi.gxi01,'9024',0)
      RETURN
   END IF
   #CHI-8C0019 add --end--
   BEGIN WORK
   OPEN t840_cl USING g_gxi.gxi01
   IF STATUS THEN
      CALL cl_err("OPEN t840_cl:", STATUS, 1)
      CLOSE t840_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t840_cl INTO g_gxi.*
   IF SQLCA.sqlcode THEN CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0) RETURN END IF
   CALL t840_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gxi01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gxi.gxi01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM gxi_file WHERE gxi01 = g_gxi.gxi01
      IF STATUS THEN 
         CALL cl_err3("del","gxi_file",g_gxi.gxi01,"",STATUS,"","del gxi:",1)  #No.FUN-66014
         ROLLBACK WORK RETURN END IF
      DELETE FROM gxj_file WHERE gxj01 = g_gxi.gxi01
      IF STATUS THEN 
         CALL cl_err3("del","gxj_file",g_gxi.gxi01,"",STATUS,"","del gxj:",1)  #No.FUN-66014
         ROLLBACK WORK RETURN END IF
      DELETE FROM npp_file
         WHERE nppsys='NM' AND npp00=10 AND npp01=g_gxi.gxi01 AND npp011=0
      IF STATUS THEN 
         CALL cl_err3("del","npp_file",g_gxi.gxi01,"",STATUS,"","del npp:",1)  #No.FUN-66014
         ROLLBACK WORK RETURN END IF
      DELETE FROM npq_file
         WHERE npqsys='NM' AND npq00=10 AND npq01=g_gxi.gxi01 AND npq011=0
      IF STATUS THEN 
         CALL cl_err3("del","npqi_file",g_gxi.gxi01,"",STATUS,"","del npq:",1)  #No.FUN-66014
         ROLLBACK WORK RETURN END IF
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_gxi.gxi01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_gxi.gxi01,"",STATUS,"","del tic:",1)
         ROLLBACK WORK 
         RETURN 
      END IF
      #FUN-B40056--add--end--       
      INITIALIZE g_gxi.* TO NULL
      OPEN t840_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t840_cs
         CLOSE t840_count
         COMMIT WORK
         #TQC-DA0025 add start ---
         CLEAR FORM
         CALL g_gxj.clear()
         #TQC-DA0025 add end -----
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t840_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t840_cs
         CLOSE t840_count
         COMMIT WORK
         #TQC-DA0025 add start ---
         CLEAR FORM
         CALL g_gxj.clear()
         #TQC-DA0025 add end -----
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t840_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t840_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t840_fetch('/')
      END IF
   #TQC-DA0025 add start ---
   ELSE
      CLOSE t840_cs
      ROLLBACK WORK
      RETURN
   #TQC-DA0025 add end -----
   END IF
   CLOSE t840_cl
   COMMIT WORK
   CALL cl_flow_notify(g_gxi.gxi01,'D')
#  CLEAR FORM                   #TQC-DA0025 mark
#  CALL g_gxj.clear()           #TQC-DA0025 mark
END FUNCTION
 
#CHI-8C0019 add --start--
#FUNCTION t840_x()  #FUN-D20035 mark
FUNCTION t840_x(p_type) #FUN-D20035 add
   DEFINE l_year,l_month  LIKE type_file.num5,
          l_flag          LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add  
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gxi.gxi01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
   IF g_gxi.gxiconf='Y' THEN
      CALL cl_err(g_gxi.gxi01,'anm-105',2)
      RETURN
   END IF
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gxi.gxiglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gxi.gxi01,'aap-618',0) 
         RETURN
      END IF
   END IF
   #FUN-D20035---begin 
   IF p_type = 1 THEN 
      IF g_gxi.gxiconf='X' THEN RETURN END IF
   ELSE
      IF g_gxi.gxiconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20035---end 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t840_cl USING g_gxi.gxi01
   IF STATUS THEN
      CALL cl_err("OPEN t840_cl:", STATUS, 1)
      CLOSE t840_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t840_cl INTO g_gxi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0)
      CLOSE t840_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_gxi_o.* = g_gxi.*
   LET g_gxi_t.* = g_gxi.*
   CALL t840_show()
   IF cl_void(0,0,g_gxi.gxiconf) THEN
      IF g_gxi.gxiconf='N' THEN    #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00=10
            AND npp01 = g_gxi.gxi01
            AND npp011=0
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","(t840_r:delete npp)",1)
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'NM'
            AND npq00=10
            AND npq01 = g_gxi.gxi01
            AND npq011=0
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","(t840_r:delete npq)",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_gxi.gxi01
         IF STATUS THEN
            CALL cl_err3("del","tic_file",g_gxi.gxi01,"",STATUS,"","del tic:",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--
 
         LET g_gxi.gxiconf='X'
      ELSE                         #取消作廢
         LET g_gxi.gxiconf='N'
      END IF
#No:FUN-C60006---add--star---
      LET g_gxi.gximodu = g_user
      LET g_gxi.gxidate = g_today
      DISPLAY BY NAME g_gxi.gximodu
      DISPLAY BY NAME g_gxi.gxidate
#No:FUN-C60006---add--end---
      UPDATE gxi_file SET gxiconf=g_gxi.gxiconf,
      #No:FUN-C60006---add--star---
                          gximodu = g_user,
                          gxidate = g_today
      #No:FUN-C60006---add--end---
       WHERE gxi01 = g_gxi.gxi01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gxi_file",g_gxi.gxi01,"",STATUS,"","",1)
         LET g_success='N'
      END IF
   END IF
   SELECT gxiconf INTO g_gxi.gxiconf FROM gxi_file
    WHERE gxi01 = g_gxi.gxi01
   DISPLAY BY NAME g_gxi.gxiconf
   CLOSE t840_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_gxi.gxi01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
#CHI-8C0019 add --end--

FUNCTION t840_firm1()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060  #No.FUN-680107 INTEGER
   DEFINE l_flag1        LIKE type_file.chr1       #No.FUN-730032
   DEFINE l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
   DEFINE l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
   DEFINE l_gxj03        LIKE gxj_file.gxj03       #MOD-B10228
   DEFINE l_gxj031       LIKE gxj_file.gxj031      #MOD-B10228
  #DEFINE l_gxf05        LIKE gxf_file.gxf05       #MOD-B10228 #MOD-C10104 mark
   DEFINE l_gxf11        LIKE gxf_file.gxf11       #MOD-C10104
 
#CHI-C30107 ------------- add -------------- begin
   IF g_gxi.gxiconf='Y' THEN RETURN END IF
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM gxj_file
    WHERE gxj01=g_gxi.gxi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
   IF g_gxi.gxiconf='Y' THEN RETURN END IF
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   #CHI-8C0019 add --end--
   SELECT COUNT(*) INTO g_cnt FROM gxj_file
    WHERE gxj01=g_gxi.gxi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gxi.gxi02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gxi.gxi01,'aap-176',1) RETURN
   END IF

  #-MOD-MOD-B10228-add-
  #由於 gxf_file key 申請單號,故使用申請單號檢核定存單問題
   DECLARE t840_gxj_c CURSOR FOR 
     SELECT gxj03,gxj031 
       FROM gxj_file 
      WHERE gxj01 = g_gxi.gxi01
   FOREACH t840_gxj_c INTO l_gxj03,l_gxj031
     IF NOT cl_null(l_gxj031) THEN
       #SELECT gxf05 INTO l_gxf05               #MOD-C10104 mark
        SELECT gxf11 INTO l_gxf11               #MOD-C10104 add
          FROM gxf_file
         WHERE gxf011 = l_gxj031
           AND gxfconf <> 'X'                      #MOD-CB0066 add
       #IF l_gxf05 < g_gxi.gxi02 THEN           #MOD-BB0206 mark
       #IF l_gxf05 <= g_gxi.gxi02 THEN          #MOD-BB0206 add #MOD-C10104 mark
        IF l_gxf11 = '3' OR l_gxf11 ='4' THEN                   #MOD-C10104 add
           CALL cl_err(l_gxj03,'anm-615',1) 
           RETURN
        END IF
     END IF
   END FOREACH
  #-MOD-MOD-B10228-end-

#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   LET g_success='Y'
   BEGIN WORK
   CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
   IF l_flag1 = '1' THEN
       CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
       LET g_success = 'N'
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN  #No.FUN-670060  #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      CALL s_chknpq(g_gxi.gxi01,'NM',0,'0',l_bookno1)         #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_gxi.gxi01,'NM',0,'1',l_bookno2)       #No.FUN-730032
      END IF
      IF g_success ='N' THEN RETURN END IF
   END IF
   LET g_gxi.gxiconf ='Y'
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_gxi.gxi01
         AND npq011 = 0
         AND npqsys = 'NM'
         AND npq00 = 10
      IF l_n = 0 THEN
         CALL t840_gen_glcr(g_gxi.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_gxi.gxi01,'NM',0,'0',l_bookno1)         #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_gxi.gxi01,'NM',0,'1',l_bookno2)       #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF
   END IF
   UPDATE gxi_file SET gxiconf = 'Y' WHERE gxi01 = g_gxi.gxi01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","gxi_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","upd gxiconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CALL s_showmsg_init()              #No.FUN-710024
   CALL t840_y1()
   CALL s_showmsg()                   #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_gxi.gxi01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_gxi.gxiconf ='N'
   END IF
   DISPLAY BY NAME g_gxi.gxiconf
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_gxi.gxi01,'" AND npp011 = 0'
      LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxi.gxi02,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT gxiglno,gxi25 INTO g_gxi.gxiglno,g_gxi.gxi25 FROM gxi_file
       WHERE gxi01 = g_gxi.gxi01
      DISPLAY BY NAME g_gxi.gxiglno
      DISPLAY BY NAME g_gxi.gxi25
   END IF
   CALL cl_set_field_pic(g_gxi.gxiconf,"","","","","")  #MOD-AC0073
END FUNCTION
 
FUNCTION t840_y1()
   DECLARE t840_y1_c CURSOR FOR
      SELECT * FROM gxj_file WHERE gxj01=g_gxi.gxi01
   FOREACH t840_y1_c INTO b_gxj.*
      IF STATUS THEN
         LET g_success='N'      #FUN-8A0086
         EXIT FOREACH
      END IF
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
      MESSAGE b_gxj.gxj02
      IF b_gxj.gxj12 IS NULL THEN       #該筆到單尚未輸入還息資料!
         CALL s_errmsg('','','',"aap-705",1)                 #No.FUN-710024
         LET g_success='N'
         EXIT FOREACH
      END IF
      CALL t840_upd_gxh()
   END FOREACH
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
   CALL t840_ins_nme()
 
END FUNCTION
 
FUNCTION t840_upd_gxh()
   DEFINE l_gxh13  LIKE gxh_file.gxh13   #MOD-920171 add
   DEFINE l_cnt  LIKE type_file.num5                            #MOD-CA0121 add
 
   LET l_cnt = 0                                                #MOD-CA0121 add
  #當anmt830的利息單號為NULL時,表示還未沖過,這時才需要回寫
  #------------------MOD-CA0121--------------(S)
  #--MOD-CA0121--mark
  #SELECT gxh13 INTO l_gxh13 FROM gxh_file
  # WHERE gxh011=b_gxj.gxj031
  #   AND gxh02=YEAR(b_gxj.gxj05)
  #   AND gxh03=MONTH(b_gxj.gxj05)
  #IF cl_null(l_gxh13) THEN
  #   UPDATE gxh_file SET gxh13 = g_gxi.gxi01
  #    WHERE gxh011=b_gxj.gxj031
  #      AND gxh02=YEAR(b_gxj.gxj05)   #MOD-920132
  #      AND gxh03=MONTH(b_gxj.gxj05)  #MOD-920132
  #--MOD-CA0121--mark
   SELECT COUNT(*) INTO l_cnt
     FROM gxh_file
    WHERE gxh011 = b_gxj.gxj031
     #AND gxh02 >= YEAR(b_gxj.gxj05)                                                             #MOD-D10095 mark
     #AND gxh03 >= MONTH(b_gxj.gxj05)                                                            #MOD-D10095 mark
     #AND gxh02 <= YEAR(b_gxj.gxj06)                                                             #MOD-D10095 mark
     #AND gxh03 <= MONTH(b_gxj.gxj06)                                                            #MOD-D10095 mark
      AND YEAR(gxh05)||MONTH(gxh05) >= YEAR(g_gxj[l_ac].gxj05)||MONTH(g_gxj[l_ac].gxj05)         #MOD-D10095 add
      AND YEAR(gxh06)||MONTH(gxh06) <= YEAR(g_gxj[l_ac].gxj06)||MONTH(g_gxj[l_ac].gxj06)         #MOD-D10095 add
      AND gxh13 IS NULL
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      UPDATE gxh_file SET gxh13 = g_gxi.gxi01
       WHERE gxh011 = b_gxj.gxj031
        #AND gxh02 >= YEAR(b_gxj.gxj05)                                                          #MOD-D10095 mark
        #AND gxh03 >= MONTH(b_gxj.gxj05)                                                         #MOD-D10095 mark
        #AND gxh02 <= YEAR(b_gxj.gxj06)                                                          #MOD-D10095 mark
        #AND gxh03 <= MONTH(b_gxj.gxj06)                                                         #MOD-D10095 mark
         AND YEAR(gxh05)||MONTH(gxh05) >= YEAR(g_gxj[l_ac].gxj05)||MONTH(g_gxj[l_ac].gxj05)      #MOD-D10095 add
         AND YEAR(gxh06)||MONTH(gxh06) <= YEAR(g_gxj[l_ac].gxj06)||MONTH(g_gxj[l_ac].gxj06)      #MOD-D10095 add
         AND gxh13 IS NULL
  #------------------MOD-CA0121--------------(E)
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","gxh_file",b_gxj.gxj031,g_gxi.gxi03_y,SQLCA.sqlcode,"","upd gxh13:",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF   #MOD-920171 add
END FUNCTION
 
FUNCTION t840_ins_nme()
   DEFINE l_nme            RECORD LIKE nme_file.*

#FUN-B30166--add--str
  DEFINE l_year     LIKE type_file.chr4
  DEFINE l_month    LIKE type_file.chr4
  DEFINE l_day      LIKE type_file.chr4
  DEFINE l_dt       LIKE type_file.chr20
  DEFINE l_date1    LIKE type_file.chr20
  DEFINE l_time     LIKE type_file.chr20
  DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

   LET l_nme.nme00=0
   LET l_nme.nme01=g_gxi.gxi17    #銀行編號
   LET l_nme.nme02=g_gxi.gxi02
   LET l_nme.nme03=g_gxi.gxi22
   LET l_nme.nme04=g_gxi.gxi12 - g_gxi.gxi18   #no.5311
   LET l_nme.nme07=g_gxi.gxi09
   LET l_nme.nme08=g_gxi.gxi14 - g_gxi.gxi19   #no.5311
   LET l_nme.nme10=g_gxi.gxiglno
   LET l_nme.nme12=g_gxi.gxi01
   SELECT nma02 INTO l_nme.nme13 FROM nma_file where nma01=g_gxi.gxi05
   IF STATUS THEN LET l_nme.nme13=g_gxi.gxi05 END IF
   SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
    WHERE nmc01 = g_gxi.gxi22
   LET l_nme.nme16=g_gxi.gxi02
   LET l_nme.nme17=g_gxi.gxi01
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21 = b_gxj.gxj02
   LET l_nme.nme22 = '17'
   LET l_nme.nme24 = '9'
   LET l_nme.nme25 = g_gxi.gxi05
 
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
#FUN-B30166--add--end

   INSERT INTO nme_file VALUES(l_nme.*)
   IF STATUS THEN
      CALL s_errmsg("nme02",l_nme.nme02,"INS nme_file",SQLCA.sqlcode,1)     #No.FUN-710024
      LET g_success='N' END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
END FUNCTION
 
FUNCTION t840_firm2()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000#No.FUN-670060  #No.FUN-680107 VARCHAR(1000)
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_cnt       LIKE type_file.num5        #MOD-CB0288 add
   DEFINE l_gxj031    LIKE gxj_file.gxj031       #MOD-CB0288 add
 
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
   IF g_gxi.gxiconf='N' THEN RETURN END IF
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   #CHI-8C0019 add --end--
  #-----------------MOD-CB0288----------------(S)
   DECLARE t840_y2_c2 CURSOR FOR
      SELECT gxj031 FROM gxj_file WHERE gxj01 = g_gxi.gxi01 
   FOREACH t840_y2_c2 INTO l_gxj031 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM gxl_file,gxk_file
       WHERE gxl03 = l_gxj031 
         AND gxl01 = gxk01
         AND gxkconf <> 'X'
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         CALL cl_err(l_gxj031,'anm-242',1) 
         RETURN
      END IF 
   END FOREACH
  #-----------------MOD-CB0288----------------(E)
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gxi.gxi02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gxi.gxi01,'aap-176',1) RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_gxi.gxi01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gxi.gxiglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gxi.gxi01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_gxi.gxiglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_gxi.gxiglno,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   IF NOT cl_null(g_gxi.gxiglno) AND g_nmy.nmyglcr = 'N' THEN       #FUN-670060
      CALL cl_err(g_gxi.gxi01,'anm-230',1)
      RETURN
   END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxi.gxiglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT gxiglno,gxi25 INTO g_gxi.gxiglno,g_gxi.gxi25 FROM gxi_file
       WHERE gxi01 = g_gxi.gxi01
      IF NOT cl_null(g_gxi.gxiglno) THEN
         CALL cl_err(g_gxi.gxiglno,'aap-929',1)
         RETURN         
      END IF
      DISPLAY BY NAME g_gxi.gxiglno
      DISPLAY BY NAME g_gxi.gxi25
   END IF
   #CHI-C90052 add end---

   BEGIN WORK
   LET g_success='Y'
   LET g_gxi.gxiconf ='N'
   UPDATE gxi_file SET gxiconf = 'N' WHERE gxi01 = g_gxi.gxi01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","gxi_file",g_gxi.gxi01,"",SQLCA.sqlcode,"","upd gxiconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CALL s_showmsg_init()                 #No.FUN-710024
   CALL t840_y2()
   CALL s_showmsg()                       #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_gxi.gxiconf ='N'
   ELSE
      ROLLBACK WORK
      LET g_gxi.gxiconf ='Y'
   END IF
   DISPLAY BY NAME g_gxi.gxiconf

   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxi.gxiglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT gxiglno,gxi25 INTO g_gxi.gxiglno,g_gxi.gxi25 FROM gxi_file
   #    WHERE gxi01 = g_gxi.gxi01
   #   DISPLAY BY NAME g_gxi.gxiglno
   #   DISPLAY BY NAME g_gxi.gxi25
   #END IF
   #CHI-C90052 mark end---
END FUNCTION
 
FUNCTION t840_y2()
   DECLARE t840_y2_c CURSOR FOR
      SELECT * FROM gxj_file WHERE gxj01=g_gxi.gxi01
   FOREACH t840_y2_c INTO b_gxj.*
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
      MESSAGE b_gxj.gxj02
      CALL t840_rec_gxh()               # recover gxh_file gxh13 = g_gxi.gxi01
   END FOREACH
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
   CALL t840_del_nme()
 
END FUNCTION
 
FUNCTION t840_rec_gxh()
   DEFINE l_cnt  LIKE type_file.num5   #MOD-920171 add
 
  #當這張入息單號有去沖anmt830暫估時,取消確認才需要去清空gxh13
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM gxh_file
    WHERE gxh011= b_gxj.gxj031
     #AND gxh02 = YEAR(b_gxj.gxj05)                  #MOD-CA0121 mark
     #AND gxh03 = MONTH(b_gxj.gxj05)                 #MOD-CA0121 mark
      AND gxh13 = b_gxj.gxj01
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      UPDATE gxh_file SET gxh13 = NULL
       WHERE gxh011= b_gxj.gxj031
         AND gxh13 = b_gxj.gxj01                     #MOD-CA0121 add
        #AND gxh02 = YEAR(b_gxj.gxj05)               #MOD-920132 #MOD-CA0121 mark
        #AND gxh03 = MONTH(b_gxj.gxj05)              #MOD-920132 #MOD-CA0121 mark
      IF SQLCA.SQLCODE THEN
        #LET g_showmsg=b_gxj.gxj031,"/",g_gxi.gxi03_y,"/",g_gxi.gxi03_m                             #No.FUN-710024 #MOD-CA0121 mark
         LET g_showmsg=b_gxj.gxj031,"/",b_gxj.gxj01                                                 #MOD-CA0121 add
         CALL s_errmsg("gxh011,gxh02,gxh03",g_showmsg,"UPD gxh_file",SQLCA.sqlcode,1)               #No.FUN-710024
         LET g_success='N'
      END IF
   END IF   #MOD-920171 add
END FUNCTION
 
FUNCTION t840_del_nme()
DEFINE l_nme24 LIKE nme_file.nme24   #FUN-730032
 
   IF g_aza.aza73 = 'Y' THEN #No.MOD-740346
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme17='",g_gxi.gxi01,"'"
      PREPARE del_nme24_p FROM g_sql
      DECLARE del_nme24_cs CURSOR FOR del_nme24_p
      FOREACH del_nme24_cs INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_gxi.gxi01,'anm-043',1)
            LET g_success='N'        #No.MOD-740346
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 IN
  (SELECT nme12 FROM nme_file 
    WHERE nme17 = g_gxi.gxi01)
   
   IF STATUS THEN 
      CALL cl_err3("del","tic_file",g_gxi.gxi01,"",STATUS,"","del tic:",1)
      LET g_success='N' END IF
   #FUN-B40056  --end
   END IF                 #No.TQC-B70021 
   DELETE FROM nme_file WHERE nme17=g_gxi.gxi01
   IF STATUS THEN 
      CALL s_errmsg("nme17",g_gxi.gxi01,"DEL nme_file",SQLCA.sqlcode,1)     #No.FUN-710024
      LET g_success='N' END IF
END FUNCTION
 
FUNCTION t840_b()
DEFINE
    l_gxf           RECORD LIKE gxf_file.*,
    l_gxh           RECORD LIKE gxh_file.*,
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680107 SMALLINT
DEFINE l_date,l_bdate,l_edate LIKE type_file.dat   #MOD-810152
DEFINE l_cnt  LIKE type_file.num5   #MOD-810152
 
    LET g_action_choice = ""
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
   #IF g_gxi.gxiconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF #CHI-8C0019 mark
    IF cl_null(g_gxi.gxi01) THEN RETURN END IF

    #CHI-8C0019 add --start--
    IF g_gxi.gxiconf = 'Y' THEN
       CALL cl_err(g_gxi.gxi01,'anm-105',0)
       RETURN
    END IF
    IF g_gxi.gxiconf='X' THEN
       CALL cl_err(g_gxi.gxi01,'9024',0)
       RETURN
    END IF
    #CHI-8C0019 add --end--

    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxi.gxi08   #TQC-740299 add
 
    SELECT COUNT(*) INTO l_n FROM gxj_file WHERE gxj01 = g_gxi.gxi01
    IF l_n = 0 THEN
       IF cl_confirm('aap-701') THEN
          CALL t840_g_b()
          CALL t840_b_fill('1=1')
       END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gxj02,gxj031,gxj03,gxj05,gxj06,gxj07,gxj08,",
                       "       gxj11,gxj13,gxj12,gxj14,gxj15,gxj16,gxj18,gxj19",   #FUN-6C0036
                       ",gxjud01,gxjud02,gxjud03,gxjud04,gxjud05,",
                       "gxjud06,gxjud07,gxjud08,gxjud09,gxjud10,",
                       "gxjud11,gxjud12,gxjud13,gxjud14,gxjud15",
                       "  FROM gxj_file ",
                       " WHERE gxj01=? AND gxj02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t840_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gxj WITHOUT DEFAULTS FROM s_gxj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         IF g_rec_b!=0 THEN
           CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
            BEGIN WORK                                                                                                              
           OPEN t840_cl USING g_gxi.gxi01                                                                                           
            IF STATUS THEN                                                                                                          
               CALL cl_err("OPEN t840_cl:", STATUS, 1)                                                                              
               CLOSE t840_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
            FETCH t840_cl INTO g_gxi.*            # 鎖住將被更改或取消的資料                                                        
            IF SQLCA.sqlcode THEN                                                                                                   
               CALL cl_err(g_gxi.gxi01,SQLCA.sqlcode,0)      # 資料被他人LOCK                                                       
               CLOSE t840_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_gxj_t.* = g_gxj[l_ac].*  #BACKUP
              OPEN t840_bcl USING g_gxi.gxi01,g_gxj_t.gxj02
              IF STATUS THEN
                 CALL cl_err("OPEN t840_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE         #No.TQC-960407 
              FETCH t840_bcl INTO g_gxj[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gxj_t.gxj02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              END IF       #No.TQC-960407  
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_gxj[l_ac].* TO NULL      #900423
           LET g_gxj[l_ac].gxj11 = 0
           LET g_gxj[l_ac].gxj12 = 0
           LET g_gxj[l_ac].gxj13 = 0
           LET g_gxj[l_ac].gxj14 = 0
           LET g_gxj[l_ac].gxj18 = 0   #FUN-6C0036
           LET g_gxj[l_ac].gxj19 = 0
           LET g_gxj[l_ac].gxj15 = 0
           LET g_gxj[l_ac].gxj16 = 0
           LET g_gxj_t.* = g_gxj[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD gxj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO gxj_file
                 (gxj01,gxj02,gxj03,gxj031,gxj05,gxj06,gxj07,gxj08,
                  gxj11,gxj12,gxj13,gxj14,gxj15,gxj16,gxj18,gxj19
                  ,gxjud01,gxjud02,gxjud03,gxjud04,gxjud05,
                  gxjud06,gxjud07,gxjud08,gxjud09,gxjud10,
                  gxjud11,gxjud12,gxjud13,gxjud14,gxjud15, 
                  gxjlegal)  #FUN-980005 add legal 
           VALUES(g_gxi.gxi01,g_gxj[l_ac].gxj02,
                  g_gxj[l_ac].gxj03,g_gxj[l_ac].gxj031,
                  g_gxj[l_ac].gxj05,g_gxj[l_ac].gxj06,
                  g_gxj[l_ac].gxj07,g_gxj[l_ac].gxj08,
                  g_gxj[l_ac].gxj11,g_gxj[l_ac].gxj12,
                  g_gxj[l_ac].gxj13,g_gxj[l_ac].gxj14,
                  g_gxj[l_ac].gxj15,g_gxj[l_ac].gxj16,
                  g_gxj[l_ac].gxj18,g_gxj[l_ac].gxj19   #FUN-6C0036
                 ,g_gxj[l_ac].gxjud01, g_gxj[l_ac].gxjud02,
                  g_gxj[l_ac].gxjud03, g_gxj[l_ac].gxjud04,
                  g_gxj[l_ac].gxjud05, g_gxj[l_ac].gxjud06,
                  g_gxj[l_ac].gxjud07, g_gxj[l_ac].gxjud08,
                  g_gxj[l_ac].gxjud09, g_gxj[l_ac].gxjud10,
                  g_gxj[l_ac].gxjud11, g_gxj[l_ac].gxjud12,
                  g_gxj[l_ac].gxjud13, g_gxj[l_ac].gxjud14,
                  g_gxj[l_ac].gxjud15, g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gxj_file",g_gxi.gxi01,g_gxj[l_ac].gxj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
 
        BEFORE FIELD gxj02                        #default 序號
           IF cl_null(g_gxj[l_ac].gxj02) OR g_gxj[l_ac].gxj02 = 0 THEN
              SELECT max(gxj02)+1
                INTO g_gxj[l_ac].gxj02
                FROM gxj_file
               WHERE gxj01 = g_gxi.gxi01
              IF cl_null(g_gxj[l_ac].gxj02) THEN
                 LET g_gxj[l_ac].gxj02 = 1
              END IF
           END IF
 
        AFTER FIELD gxj02                        #check 序號是否重複
           IF NOT cl_null(g_gxj[l_ac].gxj02)  THEN
              IF g_gxj[l_ac].gxj02 != g_gxj_t.gxj02 OR
                 cl_null(g_gxj_t.gxj02) THEN
                 SELECT count(*) INTO l_n
                   FROM gxj_file
                  WHERE gxj01 = g_gxi.gxi01
                    AND gxj02 = g_gxj[l_ac].gxj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gxj[l_ac].gxj02 = g_gxj_t.gxj02
                    NEXT FIELD gxj02
                 END IF
              END IF
           END IF
 
        AFTER FIELD gxj031
            IF NOT cl_null(g_gxj[l_ac].gxj031)  THEN
               #增加檢核gxf011=gxj031是否存在,若存在則帶出gxj03=gxf01
               SELECT * INTO l_gxf.* FROM gxf_file
                WHERE gxf011 = g_gxj[l_ac].gxj031
                 #AND gxf05 > g_gxi.gxi02                     #MOD-B10228 #MOD-C10104 mark
                  AND gxf11 NOT IN ('3','4')                  #MOD-C10104 add
                  AND gxfconf <> 'X'                          #MOD-CB0066 add
                  AND gxfacti ='Y'                            #FUN-B80125 add
               IF STATUS THEN
                  CALL cl_err3("sel","gxf_file",g_gxj[l_ac].gxj031,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
                  NEXT FIELD gxj031
               ELSE
                  LET g_gxj[l_ac].gxj03 = l_gxf.gxf01
                  DISPLAY BY NAME g_gxj[l_ac].gxj03
               END IF
            END IF
 
        AFTER FIELD gxj03
            IF NOT cl_null(g_gxj[l_ac].gxj03)  THEN
               #增加檢核gxf011=gxj031 AND gxf01=gxj03是否存在
               SELECT * INTO l_gxf.* FROM gxf_file
                WHERE gxf011 = g_gxj[l_ac].gxj031
                  AND gxf01  = g_gxj[l_ac].gxj03
                 #AND gxf05 > g_gxi.gxi02                     #MOD-B10228 #MOD-C10104 mark
                  AND gxf11 NOT IN ('3','4')                  #MOD-C10104 add
                  AND gxfconf <> 'X'                          #MOD-CB0066 add
                  AND gxfacti = 'Y'                           #FUN-B80125 add
               IF STATUS THEN
                  CALL cl_err3("sel","gxf_file",g_gxj[l_ac].gxj03,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
                  NEXT FIELD gxj03
               END IF
            END IF
 
        AFTER FIELD gxj05
           IF NOT cl_null(g_gxj[l_ac].gxj05) THEN
             #LET g_gxj[l_ac].gxj07=g_gxj[l_ac].gxj06-g_gxj[l_ac].gxj05+1  #MOD-C20101 mark
              LET g_gxj[l_ac].gxj07=g_gxj[l_ac].gxj06-g_gxj[l_ac].gxj05    #MOD-C20101 add
              DISPLAY BY NAME g_gxj[l_ac].gxj07
              LET g_flag = 'Y'                                             #MOD-C10017 add
              CALL t840_get_default()
              IF g_flag = 'N' THEN                                         #MOD-C10017 add
                 NEXT FIELD gxj05                                          #MOD-C10017 add
              END IF                                                       #MOD-C10017 add
              CALL cl_digcut(g_gxj[l_ac].gxj11,t_azi04) RETURNING g_gxj[l_ac].gxj11   #TQC-740299 add
              CALL cl_digcut(g_gxj[l_ac].gxj13,g_azi04) RETURNING g_gxj[l_ac].gxj13   #TQC-740299 add
              CALL cl_digcut(g_gxj[l_ac].gxj12,t_azi04) RETURNING g_gxj[l_ac].gxj12   #MOD-A10090 add
              CALL cl_digcut(g_gxj[l_ac].gxj14,g_azi04) RETURNING g_gxj[l_ac].gxj14   #MOD-A10090 add
              DISPLAY BY NAME g_gxj[l_ac].gxj11,g_gxj[l_ac].gxj13,   #MOD-A10090 add
                              g_gxj[l_ac].gxj12,g_gxj[l_ac].gxj14,   #MOD-A10090 add
                              g_gxj[l_ac].gxj15,g_gxj[l_ac].gxj16,                    #MOD-C10209 add
                              g_gxj[l_ac].gxj18,g_gxj[l_ac].gxj19                     #MOD-C10209 add
           END IF
 
        AFTER FIELD gxj06
           IF NOT cl_null(g_gxj[l_ac].gxj05) THEN
              IF g_gxj[l_ac].gxj06 < g_gxj[l_ac].gxj05 THEN
                 CALL cl_err('',"gxh-204",0)
                 NEXT FIELD gxj06
              END IF
              LET l_date = MDY(g_gxi.gxi03_m,1,g_gxi.gxi03_y)
              CALL s_mothck(l_date) RETURNING l_bdate,l_edate
              IF g_gxj[l_ac].gxj05 < l_bdate OR g_gxj[l_ac].gxj05 > l_edate OR
                 g_gxj[l_ac].gxj06 < l_bdate OR g_gxj[l_ac].gxj06 > l_edate THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM gxh_file
                  WHERE gxh011=g_gxj[l_ac].gxj031
                    AND gxh02 =YEAR(g_gxj[l_ac].gxj05)   #MOD-920132
                    AND gxh03 =MONTH(g_gxj[l_ac].gxj05)  #MOD-920132
                 IF l_cnt =0 THEN
                    CALL cl_err('','anm-629',0) NEXT FIELD gxj031
                 END IF
              END IF
             #LET g_gxj[l_ac].gxj07=g_gxj[l_ac].gxj06-g_gxj[l_ac].gxj05+1  #MOD-C20101 mark
              LET g_gxj[l_ac].gxj07=g_gxj[l_ac].gxj06-g_gxj[l_ac].gxj05    #MOD-C20101 add
              DISPLAY BY NAME g_gxj[l_ac].gxj07
              SELECT COUNT(*) INTO l_n FROM gxh_file
               WHERE gxh011=g_gxj[l_ac].gxj031 AND gxh06>=g_gxj[l_ac].gxj05
              IF l_n=0 THEN
                 LET g_gxj[l_ac].gxj11 = 0   
                 LET g_gxj[l_ac].gxj13 = 0
                 DISPLAY BY NAME g_gxj[l_ac].gxj11   
                 DISPLAY BY NAME g_gxj[l_ac].gxj13
              END IF
              LET g_flag = 'Y'                                                        #MOD-C10017 add
              CALL t840_get_default()
              IF g_flag = 'N' THEN                                                    #MOD-C10017 add
                 NEXT FIELD gxj06                                                     #MOD-C10017 add
              END IF                                                                  #MOD-C10017 add
              CALL cl_digcut(g_gxj[l_ac].gxj11,t_azi04) RETURNING g_gxj[l_ac].gxj11   #TQC-740299 add
              CALL cl_digcut(g_gxj[l_ac].gxj13,g_azi04) RETURNING g_gxj[l_ac].gxj13   #TQC-740299 add
              CALL cl_digcut(g_gxj[l_ac].gxj12,t_azi04) RETURNING g_gxj[l_ac].gxj12   #MOD-A10090 add
              CALL cl_digcut(g_gxj[l_ac].gxj14,g_azi04) RETURNING g_gxj[l_ac].gxj14   #MOD-A10090 add
              DISPLAY BY NAME g_gxj[l_ac].gxj11,g_gxj[l_ac].gxj13,   #MOD-A10090 add
                              g_gxj[l_ac].gxj12,g_gxj[l_ac].gxj14,   #MOD-A10090 add
                              g_gxj[l_ac].gxj15,g_gxj[l_ac].gxj16,                    #MOD-C10209 add
                              g_gxj[l_ac].gxj18,g_gxj[l_ac].gxj19                     #MOD-C10209 add
           END IF

       #----------------------------------MOD-CA0121------------------------------------(S)
        AFTER FIELD gxj07
           IF NOT cl_null(g_gxj[l_ac].gxj07) THEN
              LET g_flag = 'Y'
              CALL t840_get_default()
              IF g_flag = 'N' THEN
                 NEXT FIELD gxj07
              END IF
              CALL cl_digcut(g_gxj[l_ac].gxj11,t_azi04) RETURNING g_gxj[l_ac].gxj11
              CALL cl_digcut(g_gxj[l_ac].gxj13,g_azi04) RETURNING g_gxj[l_ac].gxj13
              CALL cl_digcut(g_gxj[l_ac].gxj12,t_azi04) RETURNING g_gxj[l_ac].gxj12
              CALL cl_digcut(g_gxj[l_ac].gxj14,g_azi04) RETURNING g_gxj[l_ac].gxj14
              DISPLAY BY NAME g_gxj[l_ac].gxj11,g_gxj[l_ac].gxj13,
                              g_gxj[l_ac].gxj12,g_gxj[l_ac].gxj14,
                              g_gxj[l_ac].gxj15,g_gxj[l_ac].gxj16,
                              g_gxj[l_ac].gxj18,g_gxj[l_ac].gxj19
           END IF
       #----------------------------------MOD-CA0121------------------------------------(E)
 
        AFTER FIELD gxj08
           IF NOT cl_null(g_gxj[l_ac].gxj08) THEN
              IF g_gxj[l_ac].gxj08 = 0 THEN
                 NEXT FIELD gxj8
              END IF
           END IF
 
        AFTER FIELD gxj12
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxi.gxi08
           # 判斷是否需扣所得稅
                 IF cl_digcut(g_gxj[l_ac].gxj12*g_gxi.gxi09,g_azi04)> g_nmz.nmz56 THEN   #MOD-8A0184
                    LET g_gxj[l_ac].gxj14=cl_digcut(g_gxj[l_ac].gxj12*g_gxi.gxi09
                                                    ,g_azi04)
                    LET g_gxj[l_ac].gxj18=cl_digcut(g_gxj[l_ac].gxj12*g_nmz.nmz57   #MOD-810249
                                         /100,t_azi04)  #本幣所得稅
                    LET g_gxj[l_ac].gxj19=cl_digcut(g_gxj[l_ac].gxj18*g_gxi.gxi09,
                                                    g_azi04)
 
                 ELSE
                    CALL cl_digcut(g_gxj[l_ac].gxj12,t_azi04)
                         RETURNING g_gxj[l_ac].gxj12
                    LET g_gxj[l_ac].gxj14=g_gxj[l_ac].gxj12*g_gxi.gxi09
                    CALL cl_digcut(g_gxj[l_ac].gxj14,g_azi04)
                         RETURNING g_gxj[l_ac].gxj14
                    LET g_gxj[l_ac].gxj18=0   #FUN-6C0036
                    LET g_gxj[l_ac].gxj19=0
                 END IF
                 DISPLAY BY NAME g_gxj[l_ac].gxj12
                 DISPLAY BY NAME g_gxj[l_ac].gxj14
                 DISPLAY BY NAME g_gxj[l_ac].gxj18   #FUN-6C0036
                 DISPLAY BY NAME g_gxj[l_ac].gxj19
 
        AFTER FIELD gxj14
           IF NOT cl_null(g_gxj[l_ac].gxj14) THEN
              CALL cl_digcut(g_gxj[l_ac].gxj14,g_azi04) RETURNING g_gxj[l_ac].gxj14
              DISPLAY BY NAME g_gxj[l_ac].gxj14
              SELECT COUNT(*) INTO g_cnt FROM gxh_file
               WHERE gxh011=g_gxj[l_ac].gxj031
                 AND gxh02 =YEAR(g_gxj[l_ac].gxj05)   #MOD-920132
                 AND gxh03 =MONTH(g_gxj[l_ac].gxj05)  #MOD-920132
              IF g_cnt > 0 THEN
                 IF g_gxj[l_ac].gxj11 != 0 THEN   #MOD-920171 add
                    LET g_gxj[l_ac].gxj15=(g_gxj[l_ac].gxj12   #MOD-730145 拿掉mark
                                          -g_gxj[l_ac].gxj11)*g_gxi.gxi09   #MOD-730145 拿掉mark
                 ELSE
                    LET g_gxj[l_ac].gxj15= 0
                 END IF
                 CALL cl_digcut(g_gxj[l_ac].gxj15,g_azi04) RETURNING g_gxj[l_ac].gxj15   #TQC-740299 add
                 DISPLAY BY NAME g_gxj[l_ac].gxj15
                 IF g_gxi.gxi04<>g_aza.aza17 THEN
                    IF g_gxj[l_ac].gxj13 != 0 THEN   #MOD-920171 add
                       LET g_gxj[l_ac].gxj16=(g_gxj[l_ac].gxj14-g_gxj[l_ac].gxj13)-g_gxj[l_ac].gxj15   #MOD-730145
                    ELSE
                       LET g_gxj[l_ac].gxj16= 0
                    END IF
                  ELSE
                    LET g_gxj[l_ac].gxj16 = 0
                  END IF
                  CALL cl_digcut(g_gxj[l_ac].gxj16,g_azi04) RETURNING g_gxj[l_ac].gxj16   #TQC-740299 add
                  DISPLAY BY NAME g_gxj[l_ac].gxj16
              END IF
           END IF
 
       AFTER FIELD gxj18
          LET g_gxj[l_ac].gxj18=cl_digcut(g_gxj[l_ac].gxj18,t_azi04)
          DISPLAY BY NAME g_gxj[l_ac].gxj18
 
 
       AFTER FIELD gxj19
          LET g_gxj[l_ac].gxj19=cl_digcut(g_gxj[l_ac].gxj19,g_azi04)
         #----------------------MOD-D30111-------------------(S)
          IF NOT cl_null(g_gxj[l_ac].gxj19) THEN
             IF g_gxj[l_ac].gxj19 <> (g_gxj[l_ac].gxj18 * g_gxi.gxi09) THEN
                CALL cl_err('','aap-938',1)
             END IF
          END IF
         #----------------------MOD-D30111-------------------(E)          
          DISPLAY BY NAME g_gxj[l_ac].gxj19
 
        AFTER FIELD gxjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_gxj_t.gxj02 > 0 AND g_gxj_t.gxj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
              DELETE FROM gxj_file
               WHERE gxj01 = g_gxi.gxi01
                 AND gxj02 = g_gxj_t.gxj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","gxj_file",g_gxi.gxi01,g_gxj_t.gxj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t840_b_tot()
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gxj[l_ac].* = g_gxj_t.*
              CLOSE t840_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gxj[l_ac].gxj02,-263,1)
              LET g_gxj[l_ac].* = g_gxj_t.*
           ELSE
              UPDATE gxj_file
                 SET gxj02 = g_gxj[l_ac].gxj02,
                     gxj031= g_gxj[l_ac].gxj031,
                     gxj03 = g_gxj[l_ac].gxj03,
                     gxj05 = g_gxj[l_ac].gxj05,
                     gxj06 = g_gxj[l_ac].gxj06,
                     gxj07 = g_gxj[l_ac].gxj07,
                     gxj08 = g_gxj[l_ac].gxj08,
                     gxj11 = g_gxj[l_ac].gxj11,
                     gxj12 = g_gxj[l_ac].gxj12,
                     gxj13 = g_gxj[l_ac].gxj13,
                     gxj14 = g_gxj[l_ac].gxj14,
                     gxj15 = g_gxj[l_ac].gxj15,
                     gxj16 = g_gxj[l_ac].gxj16,
                     gxj18 = g_gxj[l_ac].gxj18,   #FUN-6C0036
                     gxj19 = g_gxj[l_ac].gxj19
                    ,gxjud01 = g_gxj[l_ac].gxjud01,
                     gxjud02 = g_gxj[l_ac].gxjud02,
                     gxjud03 = g_gxj[l_ac].gxjud03,
                     gxjud04 = g_gxj[l_ac].gxjud04,
                     gxjud05 = g_gxj[l_ac].gxjud05,
                     gxjud06 = g_gxj[l_ac].gxjud06,
                     gxjud07 = g_gxj[l_ac].gxjud07,
                     gxjud08 = g_gxj[l_ac].gxjud08,
                     gxjud09 = g_gxj[l_ac].gxjud09,
                     gxjud10 = g_gxj[l_ac].gxjud10,
                     gxjud11 = g_gxj[l_ac].gxjud11,
                     gxjud12 = g_gxj[l_ac].gxjud12,
                     gxjud13 = g_gxj[l_ac].gxjud13,
                     gxjud14 = g_gxj[l_ac].gxjud14,
                     gxjud15 = g_gxj[l_ac].gxjud15
               WHERE gxj01=g_gxi.gxi01 AND gxj02=g_gxj_t.gxj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gxj_file",g_gxi.gxi01,g_gxj_t.gxj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 LET g_gxj[l_ac].* = g_gxj_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     ##FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gxj[l_ac].* = g_gxj_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_gxj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE t840_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     ##FUN-D30032 add
            CLOSE t840_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gxj031)   #申請單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gxf03"      #MOD-B10228 mod gxf02 -> gxf03   
                 LET g_qryparam.default1 = g_gxj[l_ac].gxj031
                 LET g_qryparam.default2 = g_gxj[l_ac].gxj03
                 LET g_qryparam.arg1 = g_gxi.gxi05
                #LET g_qryparam.arg2 = g_gxi.gxi02    #MOD-B10228     #MOD-D50113 mark
                 CALL cl_create_qry() RETURNING g_gxj[l_ac].gxj031,g_gxj[l_ac].gxj03
                 DISPLAY BY NAME g_gxj[l_ac].gxj031,g_gxj[l_ac].gxj03
                 NEXT FIELD gxj031
              WHEN INFIELD(gxj03)    #存單號碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gxf03"      #MOD-B10228 mod gxf02 -> gxf03   
                 LET g_qryparam.default1 = g_gxj[l_ac].gxj031
                 LET g_qryparam.default2 = g_gxj[l_ac].gxj03
                 LET g_qryparam.arg1 = g_gxi.gxi05
                #LET g_qryparam.arg2 = g_gxi.gxi02    #MOD-B10228     #MOD-D50113 mark
                 CALL cl_create_qry() RETURNING g_gxj[l_ac].gxj031,g_gxj[l_ac].gxj03
                 DISPLAY BY NAME g_gxj[l_ac].gxj031,g_gxj[l_ac].gxj03
                 NEXT FIELD gxj03
           END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gxj02) AND l_ac > 1 THEN
              LET g_gxj[l_ac].* = g_gxj[l_ac-1].*
              LET G_gxj[l_ac].gxj02 = NULL   #TQC-620018
              NEXT FIELD gxj02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION auto_gen_body
           #自動產生單身前，先檢查原來是否有資料，若有，需詢問是否刪除後重新產生
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM gxj_file WHERE gxj01=g_gxi.gxi01
           IF l_n > 0 THEN
              IF not cl_confirm("axc-096") THEN
                 EXIT INPUT
              END IF
           END IF
           CALL t840_g_b()
           CALL t840_b_fill('1=1')
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END INPUT
    CALL t840_b_tot()
 
    CLOSE t840_bcl
    COMMIT WORK
    CALL t840_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t840_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_gxi.gxi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM gxi_file ",
                  "  WHERE gxi01 LIKE '",l_slip,"%' ",
                  "    AND gxi01 > '",g_gxi.gxi01,"'"
      PREPARE t840_pb1 FROM l_sql 
      EXECUTE t840_pb1 INTO l_cnt 
      
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
         #CALL t840_x()  #FUN-D20035 mark
         CALL t840_x(1)  #FUN-D20035 add
         IF g_gxi.gxiconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=10 AND npp01=g_gxi.gxi01 AND npp011=0
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=10 AND npq01=g_gxi.gxi01 AND npq011=0
         DELETE FROM tic_file WHERE tic04 = g_gxi.gxi01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM gxi_file WHERE gxi01 = g_gxi.gxi01
         INITIALIZE g_gxi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t840_b_tot()
   SELECT SUM(gxj11),SUM(gxj12),SUM(gxj13),SUM(gxj14),
          SUM(gxj15),SUM(gxj16),SUM(gxj18),SUM(gxj19)
     INTO g_gxi.gxi11,g_gxi.gxi12,g_gxi.gxi13,
          g_gxi.gxi14,g_gxi.gxi15,g_gxi.gxi16,g_gxi.gxi18,g_gxi.gxi19
     FROM gxj_file
    WHERE gxj01 = g_gxi.gxi01
   IF STATUS THEN
      CALL cl_err3("sel","gxj_file",g_gxi.gxi01,"",STATUS,"","sel sum(gxj11-16):",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   IF g_gxi.gxi11 IS NULL THEN LET g_gxi.gxi11 = 0 END IF
   IF g_gxi.gxi12 IS NULL THEN LET g_gxi.gxi12 = 0 END IF
   IF g_gxi.gxi13 IS NULL THEN LET g_gxi.gxi13 = 0 END IF
   IF g_gxi.gxi14 IS NULL THEN LET g_gxi.gxi14 = 0 END IF
   IF g_gxi.gxi15 IS NULL THEN LET g_gxi.gxi15 = 0 END IF
   IF g_gxi.gxi16 IS NULL THEN LET g_gxi.gxi16 = 0 END IF
    IF g_gxi.gxi18 IS NULL THEN LET g_gxi.gxi18 = 0 END IF   #No.MOD-4C0009
    IF g_gxi.gxi19 IS NULL THEN LET g_gxi.gxi19 = 0 END IF   #No.MOD-4C0009
   DISPLAY BY NAME g_gxi.gxi11,g_gxi.gxi12,g_gxi.gxi13,
                   g_gxi.gxi14,g_gxi.gxi15,g_gxi.gxi16,g_gxi.gxi18,g_gxi.gxi19   #FUN-6C0036
   UPDATE gxi_file SET gxi11 = g_gxi.gxi11,
                       gxi12 = g_gxi.gxi12,
                       gxi13 = g_gxi.gxi13,
                       gxi14 = g_gxi.gxi14,
                       gxi15 = g_gxi.gxi15,
                       gxi16 = g_gxi.gxi16,
                       gxi18 = g_gxi.gxi18,
                       gxi19 = g_gxi.gxi19
       WHERE gxi01=g_gxi.gxi01
 
END FUNCTION
 
FUNCTION t840_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT g_wc2 ON gxj02,gxj031,gxj03,gxj05.gxj06,gxj07,gxj08
           FROM s_gxj[1].gxj02,s_gxj[1].gxj031,s_gxj[1].gxj03,s_gxj[1].gxj05,
                s_gxj[1].gxj06,s_gxj[1].gxj07,s_gxj[1].gxj08
 
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
   CALL t840_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t840_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(200)
   l_date          LIKE type_file.dat      #No.FUN-680107 DATE
 
   LET g_sql = "SELECT gxj02,gxj031,gxj03,gxj05,gxj06,gxj07,gxj08,",
               "       gxj11,gxj13,gxj12,gxj14,gxj15,gxj16,gxj18,gxj19",   #FUN-6C0036
               ",gxjud01,gxjud02,gxjud03,gxjud04,gxjud05,",
               "gxjud06,gxjud07,gxjud08,gxjud09,gxjud10,",
               "gxjud11,gxjud12,gxjud13,gxjud14,gxjud15", 
               " FROM gxj_file LEFT JOIN gxf_file ON gxj031=gxf_file.gxf011",
               " WHERE gxj01 ='",g_gxi.gxi01,"'",
               " AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE t840_pb FROM g_sql
   DECLARE gxj_curs CURSOR FOR t840_pb
 
   CALL g_gxj.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH gxj_curs INTO g_gxj[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_date=NULL
      SELECT gxf03 INTO l_date FROM gxf_file WHERE gxf011= g_gxj[g_cnt].gxj031
         AND gxfconf <> 'X'                          #MOD-CB0066 add
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gxj.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t840_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gxj TO s_gxj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_aza.aza63 != 'Y' THEN
            CALL cl_set_act_visible("maintain_entry_sheet2",FALSE)  
         ELSE
            CALL cl_set_act_visible("maintain_entry_sheet2",TRUE)  
         END IF
 
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
         CALL t840_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t840_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t840_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t840_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t840_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
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
         #CHI-8C0019 add --start--
         IF g_gxi.gxiconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         #CHI-8C0019 add --end--
        #CALL cl_set_field_pic(g_gxi.gxiconf,"","","","","")     #CHI-8C0019 mark
         CALL cl_set_field_pic(g_gxi.gxiconf,"","","",g_void,"") #CHI-8C0019
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿產生
      ON ACTION gen_entry_sheet
         LET g_action_choice="gen_entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿維護
      ON ACTION maintain_entry_sheet
         LET g_action_choice="maintain_entry_sheet"
         EXIT DISPLAY
      ON ACTION maintain_entry_sheet2
         LET g_action_choice="maintain_entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-8C0019 add --start--
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-8C0019 add --end--
      #FUN-D20035 add sta
      ON ACTION undo_void   #作廢
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035 add end      
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
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
         EXIT DISPLAY #TQC-5B0076
 
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
 
 
FUNCTION t840_g_gl(p_trno,p_npptype)  #No.FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680088
   DEFINE p_trno      LIKE npq_file.npq01    #No.FUN-680107 VARCHAR(20)
   DEFINE l_buf       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(90)
   DEFINE l_n         LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_t         LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(05) #No.FUN-550057
          l_nmydmy3   LIKE nmy_file.nmydmy3
 
   SELECT * INTO g_gxi.* FROM gxi_file WHERE gxi01 = g_gxi.gxi01
   IF p_trno IS NULL THEN RETURN END IF
   IF g_gxi.gxiconf='Y' THEN CALL cl_err(g_gxi.gxi01,'anm-232',0) RETURN END IF
   #CHI-8C0019 add --start--
   IF g_gxi.gxiconf='X' THEN
      CALL cl_err(g_gxi.gxi01,'9024',0)
      RETURN
   END IF
   #CHI-8C0019 add --end--
   IF NOT cl_null(g_gxi.gxiglno) THEN
      CALL cl_err(g_gxi.gxi01,'aap-122',1) RETURN
   END IF
   #-->立帳日期不可小於關帳日期
 
   IF g_gxi.gxi02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gxi.gxi01,'aap-176',1) RETURN
   END IF
   #判斷該單別是否須拋轉總帳
 
   LET l_t = s_get_doc_no(p_trno)       #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN LET l_nmydmy3 = 'N' END IF
   IF l_nmydmy3 = 'N' THEN RETURN END IF
 
   IF p_npptype = '0' THEN   #No.FUN-680088
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=10 AND npq01=p_trno AND npq011=0
      
      IF l_n > 0 THEN
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
         IF STATUS THEN
            CALL cl_err3("del","tic_file",g_gxi.gxi01,"",STATUS,"","del tic:",1)
            ROLLBACK WORK
            RETURN
         END IF
         #FUN-B40056--add--end--
     
         #刪除已產生
         DELETE FROM npp_file
            WHERE nppsys='NM' AND npp00=10 AND npp01=g_gxi.gxi01 AND npp011=0
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_gxi.gxi01,"",STATUS,"","del npp:",1)  #No.FUN-660148
            ROLLBACK WORK
            RETURN
         END IF
      
         DELETE FROM npq_file
            WHERE npqsys='NM' AND npq00=10 AND npq01=g_gxi.gxi01 AND npq011=0
         IF STATUS THEN
            CALL cl_err3("del","npq_file",g_gxi.gxi01,"",STATUS,"","del npq:",1)  #No.FUN-660148
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   END IF  #No.FUN-680088
 
   INITIALIZE g_npp.* TO NULL
   LET g_npp.npptype=p_npptype  #No.FUN-680088
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =10
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_gxi.gxi02
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
      UPDATE npp_file SET npp02=g_npp.npp02
          WHERE nppsys='NM' AND npp00=10 AND npp01=p_trno AND npp011=0
            AND npptype=p_npptype  #No.FUN-680088
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","npp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp:",1)  #No.FUN-660148
      RETURN END IF
   CALL t840_g_gl_1(p_trno,p_npptype)
   CALL t840_gen_diff()            #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t840_g_gl_1(p_trno,p_npqtype)       #No.FUN-680088
   DEFINE p_npqtype   LIKE npq_file.npqtype  #No.FUN-680088
   DEFINE p_trno      LIKE alk_file.alk01
   DEFINE amt1,amt2,amt3,amt4,amt5,amt6  LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
   DEFINE  l_bookno3      LIKE aza_file.aza82       #No.FUN-740009
   DEFINE  l_cnt          LIKE type_file.num10      
   DEFINE  l_count        LIKE type_file.num10 
   DEFINE  l_sql          STRING    
   DEFINE  l_sql_temp     STRING
   DEFINE  l_gxh       DYNAMIC ARRAY OF RECORD 
                   gxh09  LIKE gxh_file.gxh09,#MOD-C30703 add--
                   gxh10  LIKE gxh_file.gxh10
                       END RECORD 
   DEFINE  l_temp      DYNAMIC ARRAY OF RECORD 
                   gxh09  LIKE gxh_file.gxh09,#MOD-C30703 add--
                   gxh10  LIKE gxh_file.gxh10,
                   gxj11  LIKE gxj_file.gxj11,
                   gxj13  LIKE gxj_file.gxj13
                       END RECORD                       
   DEFINE  g_gxh10        LIKE gxh_file.gxh10                             
   DEFINE l_aaa03   LIKE aaa_file.aaa03 #FUN-A40067
   DEFINE l_azi04_2 LIKE azi_file.azi04 #FUN-A40067
   DEFINE l_flag    LIKE type_file.chr1    #FUN-D40118 add
 
   CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2  #FUN-9A0036
                                                                                
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = l_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npqtype = p_npqtype  #No.FUN-680088
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02  = 0
   LET g_npq.npq24 = g_gxi.gxi08
   LET g_npq.npq25 = g_gxi.gxi09
   LET g_npq25     = g_npq.npq25       #No.FUN-9A0036
   #------------------------------------------------ Cr:Cash/NP
   LET g_npq.npq02 = g_npq.npq02+1
   IF p_npqtype = '0' THEN
      LET g_npq.npq03 = g_gxi.gxi10
   ELSE
      LET g_npq.npq03 = g_gxi.gxi101
   END IF
   LET g_npq.npq04 = NULL   #MOD-8A0231 add
   LET g_npq.npq06 = '1'
   LET g_npq.npq07f= g_gxi.gxi12-g_gxi.gxi18    #No:8665   #MOD-640568
   LET g_npq.npq07 = g_gxi.gxi14-g_gxi.gxi19   #MOD-5C0161
   CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #TQC-740299 add
   CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-940059
   CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2
   IF l_flag1 = '1' THEN
       CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
       LET g_success = 'N'
   END IF
   IF g_npq.npqtype = '0' THEN
      LET l_bookno3 = l_bookno1
   ELSE
      LET l_bookno3 = l_bookno2
   END IF
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)
    RETURNING  g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
   LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
   IF p_npqtype = '1' THEN
      CALL s_newrate(l_bookno1,l_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = l_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
   END IF
   #------------------------------------------------ Dr:所得稅
   IF g_gxi.gxi19 > 0 THEN
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nmz.nmz58
      ELSE
         LET g_npq.npq03 = g_nmz.nmz581
      END IF
      LET g_npq.npq04 = NULL   #MOD-8A0231 add
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= g_gxi.gxi18
      LET g_npq.npq07 = g_gxi.gxi19
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #TQC-740299 add
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-940059
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
 
      CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(l_bookno1,l_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = l_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
      END IF
   END IF
   #------------------------------------------------ Dr:利息收入(未暫估)
   LET amt1=0 LET amt2=0 LET amt3=0 LET amt4=0 LET amt5=0 LET amt6=0
   SELECT SUM(gxj12),SUM(gxj14),SUM(gxj15),SUM(gxj16),SUM(gxj18),SUM(gxj19)
     INTO amt1,amt2,amt3,amt4,amt5,amt6 FROM gxj_file
    WHERE gxj01=g_gxi.gxi01 AND gxj11=0 AND gxj13=0
   IF amt2 IS NOT NULL AND amt2<>0 THEN
     LET g_npq.npq02 = g_npq.npq02 + 1
     IF p_npqtype = '0' THEN
        LET g_npq.npq03 = g_nms.nms70   #MOD-640565
     ELSE
        LET g_npq.npq03 = g_nms.nms701
     END IF
     LET g_npq.npq04 = NULL   #MOD-8A0231 add
     LET g_npq.npq06 = '2'    #MOD-920235 mod 1->2
     LET g_npq.npq07f= amt1
     LET g_npq.npq07 = amt2
     CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #TQC-740299 add
     CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-940059
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)       #No.FUN-730032
      RETURNING  g_npq.*
 
     CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
     LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
     IF p_npqtype = '1' THEN
        CALL s_newrate(l_bookno1,l_bookno2,
                       g_npq.npq24,g_npq25,g_npp.npp02)
        RETURNING g_npq.npq25
        LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
     ELSE
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
     END IF
#No.FUN-9A0036 --End
     #FUN-D40118--add--str--
     SELECT aag44 INTO g_aag44 FROM aag_file
      WHERE aag00 = l_bookno3
        AND aag01 = g_npq.npq03
     IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
        CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
        IF l_flag = 'N'   THEN
           LET g_npq.npq03 = ''
        END IF
     END IF
     #FUN-D40118--add--end--
     INSERT INTO npq_file VALUES (g_npq.*)
     IF STATUS THEN 
        CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d1:",1)  #No.FUN-660148
     END IF
     LET g_gxi.gxi11=g_gxi.gxi11+amt1
     LET g_gxi.gxi15=g_gxi.gxi15-amt3
     LET g_gxi.gxi16=g_gxi.gxi16-amt4
   END IF
   #------------------------------------------------ Cr:Diff-匯差
   IF g_gxi.gxi16 <> 0 THEN
     LET g_npq.npq02 = g_npq.npq02+1
     IF p_npqtype = '0' THEN
        LET g_npq.npq03 = g_nms.nms12
     ELSE
        LET g_npq.npq03 = g_nms.nms121
     END IF
     LET g_npq.npq04 = NULL   #MOD-8A0231 add
     LET g_npq.npq06 = '2'   #MOD-5C0161
     LET g_npq.npq07f= 0
     LET g_npq.npq07 = g_gxi.gxi16
     IF g_npq.npq07 < 0 THEN
        LET g_npq.npq03 = g_nms.nms13
        LET g_npq.npq06 = '1'
        LET g_npq.npq07 = g_npq.npq07 * -1
     END IF
     CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #TQC-740299 add
     CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-940059
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)       #No.FUN-730032
      RETURNING  g_npq.*
 
     CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
     LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
     IF p_npqtype = '1' THEN
        CALL s_newrate(l_bookno1,l_bookno2,
                       g_npq.npq24,g_npq25,g_npp.npp02)
        RETURNING g_npq.npq25
        LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
     ELSE
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
     END IF
#No.FUN-9A0036 --End
     #FUN-D40118--add--str--
     SELECT aag44 INTO g_aag44 FROM aag_file
      WHERE aag00 = l_bookno3
        AND aag01 = g_npq.npq03
     IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
        CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
        IF l_flag = 'N'   THEN
           LET g_npq.npq03 = ''
        END IF
     END IF
     #FUN-D40118--add--end--
     INSERT INTO npq_file VALUES (g_npq.*)
     IF STATUS THEN 
        CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
     END IF
   END IF
   #------------------------------------------------ Cr:Diff-利差
   IF g_gxi.gxi15 <> 0 THEN
     LET g_npq.npq02 = g_npq.npq02+1
     IF p_npqtype = '0' THEN
        LET g_npq.npq03 = g_nms.nms70   #FUN-6C0036
     ELSE
        LET g_npq.npq03 = g_nms.nms701   #FUN-6C0036
     END IF
     LET g_npq.npq04 = NULL   #MOD-8A0231 add
     LET g_npq.npq06 = '2'
    #分錄底稿利差的原幣金額應為實收原幣-暫估原幣
     LET g_npq.npq07f= g_gxi.gxi12-g_gxi.gxi11  #MOD-A10090
     LET g_npq.npq07 = g_gxi.gxi15
     IF g_npq.npq07 < 0 THEN
        LET g_npq.npq06 = '1'
        LET g_npq.npq07 = g_npq.npq07 * -1
        LET g_npq.npq07f= g_npq.npq07f* -1
     END IF
     CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #TQC-740299 add
     CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-940059
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)       #No.FUN-730032
      RETURNING  g_npq.*
 
     CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
     LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
     IF p_npqtype = '1' THEN
        CALL s_newrate(l_bookno1,l_bookno2,
                       g_npq.npq24,g_npq25,g_npp.npp02)
        RETURNING g_npq.npq25
        LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
     ELSE
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
     END IF
#No.FUN-9A0036 --End
     #FUN-D40118--add--str--
     SELECT aag44 INTO g_aag44 FROM aag_file
      WHERE aag00 = l_bookno3
        AND aag01 = g_npq.npq03
     IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
        CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
        IF l_flag = 'N'   THEN
           LET g_npq.npq03 = ''
        END IF
     END IF
     #FUN-D40118--add--end--
     INSERT INTO npq_file VALUES (g_npq.*)
     IF STATUS THEN 
        CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
     END IF
   END IF
   #------------------------------------------------ Dr:應收利息
   IF g_gxi.gxi13 <> 0 THEN
   DROP TABLE t830_file 
   CREATE TEMP TABLE t830_file(
        gxh09 LIKE gxh_file.gxh09, #MOD-C30703 add--
        gxh10 LIKE gxh_file.gxh10,
        gxj11 LIKE gxj_file.gxj11,
        gxj13 LIKE gxj_file.gxj13)     
 
   #LET l_sql = "select gxh10 from gxh_file where gxh011 = ? " ,
   LET l_sql = "select gxh09,gxh10 from gxh_file where gxh011 = ? " , #MOD-C30703 add--
               "   and gxh02 = YEAR(?) and gxh03 = MONTH(?) "
   PREPARE gxh_pb FROM l_sql
   DECLARE gxh_curs CURSOR FOR gxh_pb   
   CALL l_gxh.clear()  
   
   FOR l_cnt = 1 TO g_rec_b
       FOREACH gxh_curs USING g_gxj[l_cnt].gxj031,g_gxj[l_cnt].gxj05,g_gxj[l_cnt].gxj05
                    INTO l_gxh[l_cnt].*
               INSERT INTO t830_file VALUES(l_gxh[l_cnt].*,g_gxj[l_cnt].gxj11,g_gxj[l_cnt].gxj13)
               IF STATUS THEN 
                  CALL cl_err('insert t830_file:',STATUS,1)
                  EXIT FOREACH 
               END IF                  
       END FOREACH 
   END FOR 
   
   SELECT COUNT(*) INTO l_count FROM t830_file
   LET l_sql_temp = "select * from t830_file order by gxh10"
   PREPARE temp_pb FROM l_sql_temp
   DECLARE temp_curs CURSOR FOR temp_pb   
   LET l_cnt = 0 
   CALL l_temp.clear()
                    
   LET l_cnt = 1 
   FOREACH temp_curs INTO l_temp[l_cnt].*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH 
      END IF 
      IF l_cnt = 1 THEN     #Row 1
         LET g_npq.npq02 = g_npq.npq02 + 1 
         IF p_npqtype = '0' THEN
            LET g_npq.npq03 = g_nms.nms71
         ELSE
            LET g_npq.npq03 = g_nms.nms711
         END IF 
         LET g_npq.npq04 = NULL   
         LET g_npq.npq06 = '2'
         LET g_npq.npq07f= l_temp[l_cnt].gxj11
         LET g_npq.npq07 = l_temp[l_cnt].gxj13
         LET g_npq.npq24 = l_temp[l_cnt].gxh09 #MOD-C30703 add--
         LET g_npq.npq25 = l_temp[l_cnt].gxh10 
         LET g_npq25     = g_npq.npq25       #No.FUN-9A0036
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07  
         CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)      
         RETURNING  g_npq.*    
 
         CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npqtype = '1' THEN
            CALL s_newrate(l_bookno1,l_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1) 
            EXIT FOREACH 
         END IF
         LET g_gxh10 = l_temp[1].gxh10    ###global 
      ELSE     #Row > 1
      	 IF l_temp[l_cnt].gxh10 = g_gxh10 THEN    #add
      	    UPDATE npq_file SET npq07f = npq07f + l_temp[l_cnt].gxj11,
      	                        npq07  = npq07  + l_temp[l_cnt].gxj13
      	     WHERE npq01 = g_gxi.gxi01
               AND npq02 = g_npq.npq02   #MOD-A10118 add
      	       AND npq25 = g_gxh10
      	       AND npq06 = '2'                    
      	    LET g_gxh10 = l_temp[l_cnt].gxh10                    
      	 ELSE   #chaifen
      	 	  LET g_npq.npq02 = g_npq.npq02 + 1 
      	 	  IF p_npqtype = '0' THEN
               LET g_npq.npq03 = g_nms.nms71
            ELSE
               LET g_npq.npq03 = g_nms.nms711
            END IF 
            LET g_npq.npq04 = NULL   
            LET g_npq.npq06 = '2'
            LET g_npq.npq07f= l_temp[l_cnt].gxj11
            LET g_npq.npq07 = l_temp[l_cnt].gxj13
            LET g_npq.npq25 = l_temp[l_cnt].gxh10  
            LET g_npq25     = g_npq.npq25       #No.FUN-9A0036
            CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07  
            CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',l_bookno3)      
            RETURNING  g_npq.*    
 
            CALL s_def_npq31_npq34(g_npq.*,l_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
            LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
            IF p_npqtype = '1' THEN
               CALL s_newrate(l_bookno1,l_bookno2,
                              g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
               LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            END IF
#No.FUN-9A0036 --End
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = l_bookno3
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,l_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN
               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1) 
               EXIT FOREACH 
            END IF 
            LET g_gxh10 = l_temp[l_cnt].gxh10   #global
      	 END IF    
      END IF  
      LET l_cnt = l_cnt + 1
      IF l_cnt > l_count THEN 
         EXIT FOREACH
      END IF       
   END FOREACH  
  
   LET l_cnt = 0 
   LET g_gxh10 = NULL   
END IF
   #--------------------------------------------------------------
END FUNCTION
 
FUNCTION t840_get_default()
 DEFINE l_gxh07 LIKE gxh_file.gxh07,
        l_gxh11 LIKE gxh_file.gxh11,
        l_gxh12 LIKE gxh_file.gxh12,
        l_gxh13 LIKE gxh_file.gxh13   #MOD-920171 add
 DEFINE l_cnt   LIKE type_file.num5   #MOD-C10017 add
 DEFINE l_cnt1  LIKE type_file.num5   #MOD-C10017 add
 
   IF g_gxj[l_ac].gxj05>g_gxj[l_ac].gxj06 THEN
      LET g_gxj[l_ac].gxj11=0
      LET g_gxj[l_ac].gxj13=0
      RETURN
   END IF

  #------------MOD-CA0121----------------(S)
   IF cl_null(g_gxj[l_ac].gxj05) THEN
      RETURN
   END IF
   IF cl_null(g_gxj[l_ac].gxj06) THEN
      RETURN
   END IF
  #------------MOD-CA0121----------------(E)

 #---------------------MOD-C10017--------------------START
   LET l_cnt = 0
   LET l_cnt1 = 0

   SELECT COUNT(*) INTO l_cnt FROM gxh_file
    WHERE gxh011 = g_gxj[l_ac].gxj031
     #AND gxh02 = YEAR(g_gxj[l_ac].gxj05)                                                      #MOD-CA0121 mark
     #AND gxh03 = MONTH(g_gxj[l_ac].gxj05)                                                     #MOD-CA0121 mark
     #AND gxh02 >= YEAR(g_gxj[l_ac].gxj05)                                                     #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh03 >= MONTH(g_gxj[l_ac].gxj05)                                                    #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh02 <= YEAR(g_gxj[l_ac].gxj06)                                                     #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh03 <= MONTH(g_gxj[l_ac].gxj06)                                                    #MOD-CA0121 add #MOD-D10095 mark
      AND YEAR(gxh05)||MONTH(gxh05) >= YEAR(g_gxj[l_ac].gxj05)||MONTH(g_gxj[l_ac].gxj05)       #MOD-D10095 add
      AND YEAR(gxh06)||MONTH(gxh06) <= YEAR(g_gxj[l_ac].gxj06)||MONTH(g_gxj[l_ac].gxj06)       #MOD-D10095 add
      AND gxh13 IS NULL                                                                        #MOD-CA0121 add

   SELECT COUNT(*) INTO l_cnt1 FROM gxh_file
    WHERE gxh011 = g_gxj[l_ac].gxj031
     #AND gxh02 = YEAR(g_gxj[l_ac].gxj05)                                                      #MOD-CA0121 mark
     #AND gxh03 = MONTH(g_gxj[l_ac].gxj05)                                                     #MOD-CA0121 mark
     #AND gxh02 >= YEAR(g_gxj[l_ac].gxj05)                                                     #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh03 >= MONTH(g_gxj[l_ac].gxj05)                                                    #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh02 <= YEAR(g_gxj[l_ac].gxj06)                                                     #MOD-CA0121 add #MOD-D10095 mark
     #AND gxh03 <= MONTH(g_gxj[l_ac].gxj06)                                                    #MOD-CA0121 add #MOD-D10095 mark
      AND YEAR(gxh05)||MONTH(gxh05) >= YEAR(g_gxj[l_ac].gxj05)||MONTH(g_gxj[l_ac].gxj05)       #MOD-D10095 add
      AND YEAR(gxh06)||MONTH(gxh06) <= YEAR(g_gxj[l_ac].gxj06)||MONTH(g_gxj[l_ac].gxj06)       #MOD-D10095 add
      AND gxh13 IS NULL                                                                        #MOD-CA0121 add
      AND gxh15 = 'Y'

   IF l_cnt > 0 AND l_cnt != l_cnt1 THEN
      CALL cl_err('','anm-840',1)
      LET g_flag = 'N'
      RETURN
   END IF
  #---------------------MOD-C10017----------------------END
 
  #-------------------------MOD-CA0121------------------------(S)
  #--MOD-CA0121--mark
  #SELECT gxh07,gxh11,gxh12,gxh13          #MOD-920171 add gxh13
  #  INTO l_gxh07,l_gxh11,l_gxh12,l_gxh13  #MOD-920171 add gxh13
  #  FROM gxh_file
  # WHERE gxh011=g_gxj[l_ac].gxj031
  #   AND gxh02=YEAR(g_gxj[l_ac].gxj05)
  #   AND gxh03=MONTH(g_gxj[l_ac].gxj05)
  #   AND gxh15 = 'Y'                      #MOD-C10017 add
  #--MOD-CA0121--mark
   SELECT SUM(gxh07),SUM(gxh11),SUM(gxh12)
     INTO l_gxh07,l_gxh11,l_gxh12
     FROM gxh_file
    WHERE gxh011 = g_gxj[l_ac].gxj031
     #AND gxh02 >= YEAR(g_gxj[l_ac].gxj05)                                                      #MOD-D10095 mark
     #AND gxh03 >= MONTH(g_gxj[l_ac].gxj05)                                                     #MOD-D10095 mark
     #AND gxh02 <= YEAR(g_gxj[l_ac].gxj06)                                                      #MOD-D10095 mark
     #AND gxh03 <= MONTH(g_gxj[l_ac].gxj06)                                                     #MOD-D10095 mark
      AND YEAR(gxh05)||MONTH(gxh05) >= YEAR(g_gxj[l_ac].gxj05)||MONTH(g_gxj[l_ac].gxj05)        #MOD-D10095 add
      AND YEAR(gxh06)||MONTH(gxh06) <= YEAR(g_gxj[l_ac].gxj06)||MONTH(g_gxj[l_ac].gxj06)        #MOD-D10095 add
      AND gxh15 = 'Y'
      AND gxh13 IS NULL
  #-------------------------MOD-CA0121------------------------(E)
   IF STATUS THEN
      LET g_gxj[l_ac].gxj11=0
      LET g_gxj[l_ac].gxj13=0
   ELSE
     #IF cl_null(l_gxh13) THEN                                   #MOD-920171 add #MOD-CA0121 mark
    #當利息單號(gxh13)為NULL時,表示還沒被沖過,才需帶出暫估金額
     LET g_gxj[l_ac].gxj11=l_gxh11
     LET g_gxj[l_ac].gxj13=l_gxh12
     #ELSE                                                       #MOD-CA0121 mark
     #   LET g_gxj[l_ac].gxj11=0                                 #MOD-CA0121 mark
     #   LET g_gxj[l_ac].gxj13=0                                 #MOD-CA0121 mark
     #END IF                                                     #MOD-CA0121 mark
      LET g_gxj[l_ac].gxj12=l_gxh11*(g_gxj[l_ac].gxj07/l_gxh07)
      LET g_gxj[l_ac].gxj14=g_gxj[l_ac].gxj12*g_gxi.gxi09        #MOD-A10090
   END IF
  #----------------------------------------MOD-C10209----------------------------start
   IF l_gxh12 > g_nmz.nmz56 THEN
      LET g_gxj[l_ac].gxj18 = g_gxj[l_ac].gxj12 * g_nmz.nmz57/100
      LET g_gxj[l_ac].gxj19 = g_gxj[l_ac].gxj18 * g_gxi.gxi09
   ELSE
      LET g_gxj[l_ac].gxj18=0
      LET g_gxj[l_ac].gxj19=0
   END IF
   IF g_gxj[l_ac].gxj11 != 0 THEN
      LET g_gxj[l_ac].gxj15=(g_gxj[l_ac].gxj12 - g_gxj[l_ac].gxj11) * g_gxi.gxi09
   ELSE
      LET g_gxj[l_ac].gxj15= 0
   END IF
   IF g_gxi.gxi04 != g_aza.aza17 THEN
      IF g_gxj[l_ac].gxj13 != 0 THEN
         LET g_gxj[l_ac].gxj16 = (g_gxj[l_ac].gxj14 - g_gxj[l_ac].gxj13) - g_gxj[l_ac].gxj15
      ELSE
         LET g_gxj[l_ac].gxj16= 0
      END IF
   ELSE
      LET g_gxj[l_ac].gxj16 = 0
   END IF
   CALL cl_digcut(g_gxj[l_ac].gxj15,g_azi04) RETURNING g_gxj[l_ac].gxj15
   CALL cl_digcut(g_gxj[l_ac].gxj16,g_azi04) RETURNING g_gxj[l_ac].gxj16
   CALL cl_digcut(g_gxj[l_ac].gxj18,t_azi04) RETURNING g_gxj[l_ac].gxj18
   CALL cl_digcut(g_gxj[l_ac].gxj19,g_azi04) RETURNING g_gxj[l_ac].gxj19
  #----------------------------------------MOD-C10209------------------------------end
END FUNCTION
 
FUNCTION t840_out()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(3000)
          sr        RECORD
                    gxi01     LIKE gxi_file.gxi01,
                    gxi02     LIKE gxi_file.gxi02,
                    gxi03     LIKE gxi_file.gxi03,
                    gxi04     LIKE gxi_file.gxi04,
                    gxi05     LIKE gxi_file.gxi05,
                    gxi17     LIKE gxi_file.gxi17,
                    gxi08     LIKE gxi_file.gxi08,
                    gxi09     LIKE gxi_file.gxi09,
                    gxi10     LIKE gxi_file.gxi10,
                    gxi22     LIKE gxi_file.gxi22,
                    gxiconf   LIKE gxi_file.gxiconf,
                    gxiglno   LIKE gxi_file.gxiglno,
                    gxj02     LIKE gxj_file.gxj02,
                    gxj031    LIKE gxj_file.gxj031,
                    gxj03     LIKE gxj_file.gxj03,
                    gxj05     LIKE gxj_file.gxj05,
                    gxj06     LIKE gxj_file.gxj06,
                    gxj07     LIKE gxj_file.gxj07,
                    gxj08     LIKE gxj_file.gxj08,
                    gxj11     LIKE gxj_file.gxj11,
                    gxj13     LIKE gxj_file.gxj13,
                    gxj12     LIKE gxj_file.gxj12,
                    gxj14     LIKE gxj_file.gxj14,
                    gxj15     LIKE gxj_file.gxj15,
                    gxj16     LIKE gxj_file.gxj16,
                    gxj18     LIKE gxj_file.gxj18,   #FUN-6C0036
                    gxj19     LIKE gxj_file.gxj19
                    END RECORD
 
   IF g_wc IS NULL THEN
      LET g_wc = "gxi01='",g_gxi.gxi01,"'"
   END IF
   IF g_wc2 IS NULL THEN LET g_wc2 = " 1=1" END IF
   IF g_wc IS NULL THEN                                                       
      CALL cl_err('','9057',0) RETURN                                         
   END IF                                                                     
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmt840' 
   LET l_sql = " SELECT gxi01,gxi02,gxi03,gxi04,gxi05,gxi17,gxi08, ",         
               "        gxi09,gxi10,gxi22,gxiconf,gxiglno, ",                 
               "        gxj02,gxj031,gxj03,gxj05,gxj06,gxj07, ",              
               "        gxj08,gxj11,gxj13,gxj12,gxj14,gxj15, ",               
               "        gxj16,gxj18,gxj19,a.nma02 nma02_a,b.nma02 nma02_b,azi04,azi05,azi07 ",   #No.FUN-870151 add azi07
               " FROM   gxi_file,gxj_file,nma_file a,nma_file b,azi_file  ",  
               " WHERE  gxi01=gxj01 AND a.nma01 = gxi17 AND b.nma01 = gxi05 ",
               "  AND   azi01 = gxi04 ",                                      
               "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                    
   PREPARE t840_p FROM l_sql
   DECLARE t840_c CURSOR FOR t840_p
 
 
   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(g_wc,'gxi01,gxi02,gxi03,gxi04,gxi05,                  #MOD-920132
                    gxi17,gxi08,gxi09,gxi22,gxiconf,gxiglno,gxi11,gxi13,      
                    gxi12,gxi14,gxi15,gxi16,gxi18,gxi19,gxi10,gxi101,gxj02,   
                    gxj031,gxj03,gxj05,gxj06,gxj07,gxj08
                    ,gxiuser,gxigrup,gximodu,gxidate,gxiacti')            #TQC-960085                   
           RETURNING g_str                                                    
   ELSE                                                                       
      LET g_str = ' '                                                         
   END IF                                                                     
   LET g_str = g_str,";",g_azi04,";",g_azi05                                  
   CALL cl_prt_cs1('anmt840','anmt840',l_sql,g_str)                           
END FUNCTION
 
 
FUNCTION t840_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gxi01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t840_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gxi01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t840_gen_glcr(p_gxi,p_nmy)
  DEFINE p_gxi     RECORD LIKE gxi_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxi.gxi01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t840_g_gl(p_gxi.gxi01,'0')
    IF g_aza.aza63 = 'Y' THEN
       CALL t840_g_gl(p_gxi.gxi01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t840_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5    #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gxi.gxiglno) OR g_gxi.gxiglno IS NOT NULL THEN
       CALL cl_err(g_gxi.gxiglno,'aap-618',1) 
       RETURN                                                                                                                       
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxi.gxi01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN  #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxi.gxiglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxi.gxiglno,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088
       CALL cl_err(g_gxi.gxi01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_gxi.gxi01,'" AND npp011 = 0'
    LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxi.gxi02,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT gxiglno,gxi25 INTO g_gxi.gxiglno,g_gxi.gxi25 FROM gxi_file
     WHERE gxi01 = g_gxi.gxi01
    DISPLAY BY NAME g_gxi.gxiglno
    DISPLAY BY NAME g_gxi.gxi25
    
END FUNCTION
 
FUNCTION t840_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_gxi.gxiglno) OR g_gxi.gxiglno IS NULL THEN 
       CALL cl_err(g_gxi.gxiglno,'aap-619',1) 
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxi.gxi01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gxi.gxiglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gxi.gxiglno,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxi.gxiglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT gxiglno,gxi25 INTO g_gxi.gxiglno,g_gxi.gxi25 FROM gxi_file
     WHERE gxi01 = g_gxi.gxi01
    DISPLAY BY NAME g_gxi.gxiglno
    DISPLAY BY NAME g_gxi.gxi25
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t840_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag1          LIKE type_file.chr1
DEFINE l_bookno1        LIKE aza_file.aza81
DEFINE l_bookno2        LIKE aza_file.aza82
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_gxi.gxi02)) RETURNING l_flag1,l_bookno1,l_bookno2       #No.FUN-730032
      IF l_flag1 = '1' THEN
         CALL cl_err(YEAR(g_gxi.gxi02),'aoo-081',1)
         RETURN
      END IF
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = l_bookno2
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
          WHERE aag00 = l_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,l_bookno2) RETURNING l_flag
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
#No.FUN-9C0073 -----------------By chenls 10/01/18

