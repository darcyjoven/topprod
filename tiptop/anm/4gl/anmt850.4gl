# Prog. Version..: '5.30.07-13.06.04(00010)'     #
#
# Pattern name...: anmt850.4gl
# Descriptions...: 定存到期收款作業
# Date & Author..: 99/12/06 By Polly Hsu
# Modify.........: 02/12/10 By Kitty 增加展期功能
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.7350 03/10/17 By Kitty 產生分錄貸方改取gxl13
# Modify.........: No.8677 03/11/11 By Kitty 解約及到期也考慮利息收入
# Modify.........: No.MOD-470530 No.9764 04/07/26 By Nicola ,nme04應該是實付原幣應收->gxk11,nme08應該是實付本幣應收->gxk1
# Modify.........: No.MOD-490140 04/09/09 By Yuna gxk08開窗的next field皆寫為gxk28應為gxk08
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0155 04/12/24 By Kitty t850_show()將應收本幣及實收原幣放錯位置
# Modify.........: No.MOD-510073 05/04/14 By NIcola 單身UPDATE錯誤，且修改時，欄位資料會亂掉
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: NO.MOD-580384 05/09/02 By Smapmin KEY值是否修改設定錯誤
# Modify.........: No.MOD-5A0388 05/11/08 By Smapmin 增加報表列印功能
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-5B0093 05/11/29 By Smapmin 定期存款的科目應該先抓取定存銀行其anmi030的科目
#                                                    如果不存在才抓取參數的定存科目
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.MOD-610057 06/01/12 By Smapmin 產生分錄有誤
#                                                    定存銀行,支出幣別,支出異動碼輸入順序變更
#                                                    產生分錄的本幣金額未取位.原幣為0時,幣別應為本國幣別.
#                                                    所得稅分錄幣別應為本國幣別
# Modify.........: No.TQC-5C0098 06/01/20 By Smapmin INSERT INTO nme_file的金額有誤
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.TQC-630216 06/03/22 By Smapmin 調整FUN-5B0093
# Modify.........: No.MOD-640388 06/04/13 By Smapmin 避免到單續約與解約時金額重複計算
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650057 06/05/12 By alexstar 修改程式中cl_outnam的位置須在assign
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660109 06/06/29 By Smapmin 修正單據編號方式
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670127 06/07/27 By Smapmin 出帳匯率開窗應以支出幣別判斷
# Modify.........: No.FUN-670060 06/08/02 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-670067 06/08/07 By Jackho voucher型報表轉template1
# Modify.........: No.TQC-680079 06/08/22 By Sarah cl_err3裡面傳的參數有寫錯字,需訂正
# Modify.........: No.TQC-680080 06/08/22 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680107 06/08/29 By Hellen 欄位類型修改
# Modify.........: No.FUN-680088 06/08/31 By day 多帳套修改
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.CHI-6A0004 06/10/27 By Carrier g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0036 07/01/08 By Smapmin 新增gxl181欄位
# Modify.........: No.MOD-710051 07/01/09 By rainy 單身申請單號開窗應過濾掉已轉續存得資料
# Modify.........: No.FUN-710024 07/01/29 By cheunl錯誤訊息匯整
# Modify.........: No.MOD-710175 07/01/30 By Smapmin 原幣金額依照支出幣別(gxk04)取位
# Modify.........: No.MOD-720122 07/02/28 By Smapmin 金額欄位不可小於0
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Elva  新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-730110 07/03/23 By Smapmin 修改月付利息天數計算方式
# Modify.........: No.TQC-710112 07/03/27 By Judy 匯率不可小于零
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760041 07/06/13 By Smapmin 修改回寫銀行存款異動檔的原幣金額(nme04)
# Modify.........: No.MOD-760038 07/06/14 By Smapmin 修改起息日期與應還日之後，重新計算相關金額
# Modify.........: No.MOD-760121 07/06/26 By Smapmin 同一定存單單號有多筆, 造成分錄底稿金額有誤
# Modify.........: No.MOD-770012 07/07/03 By Smapmin   1.借方科目需為存入銀行科目
#                                                      2.增加檢核還原時若該續存單已確認則不可還原
#                                                      3.修改拋轉提出銀行欄位為 gxk06
# Modify.........: No.MOD-790019 07/09/07 By Smapmin 依定存銀行計算出帳匯率
# Modify.........: No.TQC-790094 07/09/14 By Judy 報表中制表日期在表名之上
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.MOD-7B0123 07/11/13 By Smapmin nme04>0 才 insert into nme_file 
# Modify.........: No.MOD-7B0264 07/12/03 By Smapmin 以實收金額寫入nme_file
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810211 08/01/31 By Smapmin 修改查詢時收款單號的開窗
# Modify.........: No.MOD-820149 08/02/27 By Smapmin 提出異動寫入nme_file時,應抓取原始存款匯率
# Modify.........: No.FUN-830145 08/04/21 By lutingting報表轉為使用Crystal Report 輸出
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.CHI-860034 08/07/17 By xiaofeizhu 到期續存之后(gxk20 = '3')，不需INSERT INTO nme_file
# Modify.........: No.FUN-870145 08/07/28 BY yiting 將CHI-860034的處理方式移到anmi820處理
# Modify.........: No.MOD-870316 08/08/01 By Sarah t850_b_more()段,增加判斷輸入的gxl21金額不可小於等於0
# Modify.........: No.MOD-880007 08/08/05 By Sarah 當anmi820計息方式gxf04為1.月付時,起息日date1不可輸入
# Modify.........: No.MOD-880119 08/08/18 By Sarah t850_upd_gxf()段,刪除gxf_file前需先檢查gxf13為空值才可刪除
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.TQC-870042 08/08/19 By Sarah t850_firm1()段,一開始就要先抓nmy_file資料,否則後面無法判斷
# Modify.........: No.MOD-8A0034 08/10/03 By Sarah t850_upd_gxf()段,當p_sta='3'時,LET l_gxk02=g_gxk.gxk02
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8C0114 08/12/11 By Sarah 當g_gxf.gxf11='3'時才顯示anm-624訊息
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-920267 09/02/19 By Dido 依據 gxk22 抓取 nme14 預設值
# Modify.........: No.MOD-930127 09/03/11 By Sarah 產生之分錄底稿借貸不平
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-960086 09/06/10 By xiaofeizhu 增加“狀態”頁簽
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960418 09/06/29 By dxfwo 鎖單身時，沒有一并鎖單頭(同一筆數據，單頭被A修改中，但B卻可以修改單身)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.MOD-990031 09/09/08 By mike 若anmt850未輸入定存單號，其產生分錄時，貸方的本金未產生，而key值應只有申請單號，將定存單號的sql條件拿掉
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No:MOD-A10090 10/01/15 By Sarah 當nmz04='1'時CALL s_bankex() ELSE CALL s_curr3(g_curr,p_date,'B')
# Modify.........: No:MOD-A10093 10/01/15 By Sarah 修正MOD-610057產生所得稅分錄做法,幣別應為支出幣別
# Modify.........: No:MOD-A10094 10/01/15 By Sarah 1.目前anmt850無法沖暫估利息,故不應該回寫暫估利息單的利息單號
#                                                  2.單身輸入完申請單號後,應檢查是否已做過最後一期暫估利息的沖銷(檢查anmt840),若沒有不允許繼續輸入
# Modify.........: No:MOD-A10097 10/01/15 By Sarah 目前anmt850無法沖暫估利息,故不應該產生暫估的回轉分錄
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A40024 10/04/19 By Summer 將原 MOD-8C0114 修改還原
# Modify.........: No.MOD-A60032 10/06/04 By sabrina 自動拋轉傳票時，若分錄底稿有問題，未將g_gxk.gxkconf變成"N"就RETURN
# Modify.........: No:CHI-A50017 10/06/08 By Summer 將MOD-A10094|MOD-A10097修改還原
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:MOD-A80143 10/08/20 By Dido cl_wcchp回傳的變數不要使用g_wc 
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No:MOD-AB0010 10/11/01 By Dido gxk09 預設值調整 
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.MOD-AC0155 10/12/17 By Dido 單身 t850_b_more 函式取消 ls_tmp
# Modify.........: No:MOD-B10059 11/01/07 By Dido 報表列印只需印出畫面上的這一筆
# Modify.........: No:FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30135 11/03/18 By Sarah 當定存有做暫估利息時,anmt850的利息收入分錄應扣掉暫估利息金額
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:MOD-B40077 11/04/14 By Dido 分錄暫估資料改用申請單號 gxl13 串聯
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B80173 11/08/18 By Polly 1.調整到期續存，在計算利息收入的公式
#                                                  2.增加判斷，在產生分錄前先判斷是否npq07 > 0
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.MOD-B90225 11/09/28 By Polly 設定續存金額時,需控卡限定僅限於本金 or 本金+利息
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C20065 12/02/09 By Polly 修正ACTION"維護續存資料"依單身不同項次維護續存到期日
# Modify.........: No.MOD-C20160 12/02/22 By Polly 調整錯誤訊息顯示
# Modify.........: No.MOD-C40026 12/04/09 By Polly 當nmz20='Y'時，匯率應以上個月月底的重評價匯率計算
# Modify.........: No.CHI-C30094 12/05/04 By Belle 單身輸入單據時的幣別不可和單頭的帳戶幣別不相同(gxk08)
# Modify.........: No.TQC-C50064 12/05/09 By Elise 若無 oox07 時,應使用原 gxf26 給予 gxl13
# Modify.........: No.TQC-C50070 12/05/09 By xuxz gxf41賦值修改
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C20028 12/05/31 By wangrr 在gxk22、gxk24旁邊添加對應異動名稱nmc02_1、nmc02_2
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C60072 12/06/11 By Polly 申請單號需排除已過期的單據
# Modify.........: No.MOD-C70308 12/08/06 By Polly 到期續存產生定存科目改抓gxk05,借方存入利息金額不可包含暫估利息
# Modify.........: No.MOD-C90199 12/09/24 By Polly 如果超過本金+利息時，才需控卡anm-813
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-B80125 12/10/25 By Belle 增加作廢選項
# Modify.........: No.MOD-C90253 12/10/01 By Polly 取得日期抓取值調整
# Modify.........: No.MOD-CA0015 12/10/02 By Polly 若提前解約的話，應收利息(gxl15、gxl17)金額調整為0元
# Modify.........: No.CHI-C80041 13/02/18 By bart 無單身刪除單頭控制
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-CB0066 13/04/10 By apo 定存單增加作廢條件判斷
# Modify.........: No:FUN-C60006 13/05/08 By qirl 系統作廢/取消作廢需要及時更新修改者以及修改時間欄位
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.TQC-DA0025 13/10/21 By yangxf 修改删除逻辑BUG

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gxk               RECORD LIKE gxk_file.*,
    g_gxk_t             RECORD LIKE gxk_file.*,
    g_gxk_o             RECORD LIKE gxk_file.*,
    g_gxk01_t           LIKE gxk_file.gxk01,
    b_gxl               RECORD LIKE gxl_file.*,
    g_gxf               RECORD LIKE gxf_file.*,
    g_nms               RECORD LIKE nms_file.*,
    g_npp               RECORD LIKE npp_file.*,
    g_npq               RECORD LIKE npq_file.*,
    g_wc,g_wc2,g_sql    STRING,
    g_statu             LIKE type_file.chr1,    # 是否從新賦予等級  #No.FUN-680107 VARCHAR(1)
    g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,   #No.FUN-980020
    l_desc              LIKE type_file.chr4,    #No.FUN-680107 VARCHAR(04)
    b_date              LIKE type_file.dat,     #No.FUN-680107 DATE
    nm_no_b,nm_no_e     LIKE type_file.chr18,   #No.FUN-680107 INTEGER 
    gl_no_b,gl_no_e     LIKE oea_file.oea01,    #No.FUN-550057 #No.FUN-680107 VARCHAR(16)
    ddd,yy,mm           LIKE type_file.num5,    #No.FUN-680107 SMALLINT        
    g_gxl            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gxl02           LIKE gxl_file.gxl02,
        gxl03           LIKE gxl_file.gxl03,
        gxl04           LIKE gxl_file.gxl04,
        date1           LIKE type_file.dat,     #No.FUN-680107 DATE
        date2           LIKE type_file.dat,     #No.FUN-680107 DATE
        gxl11           LIKE gxl_file.gxl11,
        gxl13           LIKE gxl_file.gxl13,    #No.MOD-4C0155 12,13位置互換
        gxl12           LIKE gxl_file.gxl12,
        gxl14           LIKE gxl_file.gxl14,
        gxl15           LIKE gxl_file.gxl15,
        gxl17           LIKE gxl_file.gxl17,
        gxl181          LIKE gxl_file.gxl181,   #FUN-6C0036
        gxl18           LIKE gxl_file.gxl18,
        gxl16           LIKE gxl_file.gxl16
       ,gxlud01         LIKE gxl_file.gxlud01,
        gxlud02         LIKE gxl_file.gxlud02,
        gxlud03         LIKE gxl_file.gxlud03,
        gxlud04         LIKE gxl_file.gxlud04,
        gxlud05         LIKE gxl_file.gxlud05,
        gxlud06         LIKE gxl_file.gxlud06,
        gxlud07         LIKE gxl_file.gxlud07,
        gxlud08         LIKE gxl_file.gxlud08,
        gxlud09         LIKE gxl_file.gxlud09,
        gxlud10         LIKE gxl_file.gxlud10,
        gxlud11         LIKE gxl_file.gxlud11,
        gxlud12         LIKE gxl_file.gxlud12,
        gxlud13         LIKE gxl_file.gxlud13,
        gxlud14         LIKE gxl_file.gxlud14,
        gxlud15         LIKE gxl_file.gxlud15
                    END RECORD,
    g_gxl_t         RECORD                      #程式變數 (舊值)
        gxl02           LIKE gxl_file.gxl02,
        gxl03           LIKE gxl_file.gxl03,
        gxl04           LIKE gxl_file.gxl04,
        date1           LIKE type_file.dat,     #No.FUN-680107 DATE
        date2           LIKE type_file.dat,     #No.FUN-680107 DATE
        gxl11           LIKE gxl_file.gxl11,
        gxl13           LIKE gxl_file.gxl13,    #No.MOD-4C0155 12,13位置互換
        gxl12           LIKE gxl_file.gxl12,
        gxl14           LIKE gxl_file.gxl14,
        gxl15           LIKE gxl_file.gxl15,
        gxl17           LIKE gxl_file.gxl17,
        gxl181          LIKE gxl_file.gxl181,   #FUN-6C0036
        gxl18           LIKE gxl_file.gxl18,
        gxl16           LIKE gxl_file.gxl16
       ,gxlud01         LIKE gxl_file.gxlud01,
        gxlud02         LIKE gxl_file.gxlud02,
        gxlud03         LIKE gxl_file.gxlud03,
        gxlud04         LIKE gxl_file.gxlud04,
        gxlud05         LIKE gxl_file.gxlud05,
        gxlud06         LIKE gxl_file.gxlud06,
        gxlud07         LIKE gxl_file.gxlud07,
        gxlud08         LIKE gxl_file.gxlud08,
        gxlud09         LIKE gxl_file.gxlud09,
        gxlud10         LIKE gxl_file.gxlud10,
        gxlud11         LIKE gxl_file.gxlud11,
        gxlud12         LIKE gxl_file.gxlud12,
        gxlud13         LIKE gxl_file.gxlud13,
        gxlud14         LIKE gxl_file.gxlud14,
        gxlud15         LIKE gxl_file.gxlud15
                    END RECORD,
    g_buf           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(78)
    g_tot           LIKE type_file.num20_6, #No.FUN-4C0010 #No.FUN-680107 DEC(20,6)
    g_rec_b         LIKE type_file.num5,    #單身筆數      #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
    #f_azi04         LIKE azi_file.azi04        #MOD-710175
DEFINE g_system     LIKE ooy_file.ooytype   #No.FUN-680107 VARCHAR(2) #TQC-840066
DEFINE g_N          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_y          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
DEFINE g_argv1      LIKE oea_file.oea01     #No.FUN-680107  VARCHAR(16)   #單號           #TQC-630074
DEFINE g_argv2      STRING                  #指定執行的功能 #TQC-630074
 
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done  LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_chr        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03       #No.FUN-680107 VARCHAR(72)
DEFINE g_str        STRING                  #No.FUN-670060
DEFINE g_wc_gl      STRING                  #No.FUN-670060
DEFINE g_t1         LIKE oay_file.oayslip   #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
 
DEFINE g_row_count  LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE g_flag       LIKE type_file.chr1       #No.FUN-730032
DEFINE g_bookno1    LIKE aza_file.aza81       #No.FUN-730032
DEFINE g_bookno2    LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_bookno3    LIKE aza_file.aza82       #No.FUN-730032
DEFINE l_sql        STRING                 #No.FUN-830145
DEFINE l_str        STRING                 #No.FUN-830145
DEFINE l_table      STRING                 #No.FUN-830145
DEFINE g_npq25      LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE g_void       LIKE type_file.chr1    #FUN-B80125
DEFINE g_aag44      LIKE aag_file.aag44    #FUN-D40118 add
 
MAIN
DEFINE      p_row,p_col  LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
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
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET p_row = 2 LET p_col = 2
 
   LET l_sql = "gxk01.gxk_file.gxk01,",
               "gxk06.gxk_file.gxk06,",
               "gxk22.gxk_file.gxk22,",
               "gxk02.gxk_file.gxk02,",
               "l_nma02.nma_file.nma02,", 
               "gxk19.gxk_file.gxk19,",
               "gxk04.gxk_file.gxk04,",
               "gxk08.gxk_file.gxk08,",
               "l_nml02.nml_file.nml02,",
               "gxk24.gxk_file.gxk24,",
               "gxkconf.gxk_file.gxkconf,",
               "gxk05.gxk_file.gxk05,",
               "gxk09.gxk_file.gxk09,",
               "gxkglno.gxk_file.gxkglno,",
               "l_nma02_1.nma_file.nma02,",
               "gxk10.gxk_file.gxk10,", 
               "gxk20.gxk_file.gxk20,", 
               "gxk07.gxk_file.gxk07,", 
               "gxl02.gxl_file.gxl02,", 
               "gxl03.gxl_file.gxl03,", 
               "l_date1.type_file.dat,",
               "gxl11.gxl_file.gxl11,",
               "gxl12.gxl_file.gxl12,",
               "gxl15.gxl_file.gxl15,",
               "gxl181.gxl_file.gxl181,",
               "l_date2.type_file.dat,",
               "gxl04.gxl_file.gxl04,",
               "gxl13.gxl_file.gxl13,",
               "gxl14.gxl_file.gxl14,",
               "gxl17.gxl_file.gxl17,",
               "gxl16.gxl_file.gxl16,",
               "gxl18.gxl_file.gxl18,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07 "   #No.FUN-870151
              
   LET l_table = cl_prt_temptable('anmt850',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?)"                #FUN-870151 ADD ?
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF         
 
   OPEN WINDOW t850_w AT p_row,p_col
     WITH FORM "anm/42f/anmt850"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_aza.aza63 != 'Y' THEN
       CALL cl_set_comp_visible("gxk101",FALSE) 
    ELSE
       CALL cl_set_comp_visible("gxk101",TRUE) 
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t850_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t850_a()
            END IF
         OTHERWISE
            CALL t850_q()
      END CASE
   END IF
 
 
   CALL t850()
   CLOSE WINDOW t850_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t850()
   LET g_plant_gl = g_nmz.nmz02p       #FUN-980020
   LET g_plant_new=g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
 
   INITIALIZE g_gxk.* TO NULL
   INITIALIZE g_gxk_t.* TO NULL
   INITIALIZE g_gxk_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM gxk_file WHERE gxk01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t850_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   CALL t850_menu()
END FUNCTION
 
FUNCTION t850_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_gxl.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_gxk.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON gxk01,gxk20,gxk02,gxk05,gxk09,gxk04,gxk24,gxk06,gxk08,
                                gxk07,gxk22,gxk19,gxkconf,gxkglno,gxk10,gxk101 #No.FUN-680088
                                ,gxkud01,gxkud02,gxkud03,gxkud04,gxkud05,
                                gxkud06,gxkud07,gxkud08,gxkud09,gxkud10,
                                gxkud11,gxkud12,gxkud13,gxkud14,gxkud15
                                ,gxkuser,gxkgrup,gxkmodu,gxkdate,gxkacti           #TQC-960086
                                      
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
      
          ON ACTION controlp
             CASE
                WHEN INFIELD(gxk01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gxk"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk01
                WHEN INFIELD(gxk05) # Dept CODE
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk05
                WHEN INFIELD(gxk06) # Dept CODE
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk06
                WHEN INFIELD(gxk10) # Dept CODE
                   CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                   CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_gxk.gxk10,'23',g_bookno1) #No.FUN-980025 
                   RETURNING g_gxk.gxk10
                   DISPLAY BY NAME g_gxk.gxk10
                WHEN INFIELD(gxk101) # Dept CODE
                   CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020
                   CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_gxk.gxk101,'23',g_bookno2) #No.FUN-980025 
                   RETURNING g_gxk.gxk101
                   DISPLAY BY NAME g_gxk.gxk101
                WHEN INFIELD(gxk19) #現金變動碼值
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nml"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk19
                WHEN INFIELD(gxk22) #銀行異動碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #MOD-670127
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = '1'   #MOD-670127
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk22
                   NEXT FIELD gxk22
                WHEN INFIELD(gxk24) #銀行異動碼(提)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #MOD-670127
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = '2'   #MOD-670127
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk24
                   NEXT FIELD gxk24
                WHEN INFIELD(gxk08) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk08
                    NEXT FIELD gxk08 #No.MOD-490140
                WHEN INFIELD(gxk04) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxk04
                   NEXT FIELD gxk04
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
       CONSTRUCT g_wc2 ON gxl02,gxl03,gxl04
                         ,gxlud01,gxlud02,gxlud03,gxlud04,gxlud05
                         ,gxlud06,gxlud07,gxlud08,gxlud09,gxlud10
                         ,gxlud11,gxlud12,gxlud13,gxlud14,gxlud15
               FROM s_gxl[1].gxl02,s_gxl[1].gxl03,s_gxl[1].gxl04
                   ,s_gxl[1].gxlud01,s_gxl[1].gxlud02,s_gxl[1].gxlud03
                   ,s_gxl[1].gxlud04,s_gxl[1].gxlud05,s_gxl[1].gxlud06
                   ,s_gxl[1].gxlud07,s_gxl[1].gxlud08,s_gxl[1].gxlud09
                   ,s_gxl[1].gxlud10,s_gxl[1].gxlud11,s_gxl[1].gxlud12
                   ,s_gxl[1].gxlud13,s_gxl[1].gxlud14,s_gxl[1].gxlud15
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(gxl03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gxf02"               #MOD-710051
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxl03
                   NEXT FIELD gxl03
                WHEN INFIELD(gxl04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gxf02"              #MOD-710051
                   LET g_qryparam.state = "c"
                   LET g_qryparam.multiret_index = 2
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxl04
                   NEXT FIELD gxl04
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
      LET g_wc =" gxk01 = '",g_argv1,"'"    #No.TQC-630074
      LET g_wc2 = ' 1=1'
   END IF
 
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxkuser', 'gxkgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT gxk01 FROM gxk_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY gxk01"
   ELSE
      LET g_sql="SELECT UNIQUE gxk01 FROM gxk_file,gxl_file",
                " WHERE gxk01=gxl01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY gxk01"
   END IF
   PREPARE t850_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t850_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t850_prepare
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT COUNT(*) FROM gxk_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gxk01) FROM gxk_file,gxl_file",
                " WHERE gxk01=gxl01",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t850_precount FROM g_sql
   DECLARE t850_count CURSOR FOR t850_precount
END FUNCTION
 
FUNCTION t850_menu()
 
   WHILE TRUE
      CALL t850_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t850_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t850_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t850_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t850_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t850_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t850_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_entry_sheet"
            CALL t850_g_gl(g_gxk.gxk01,'0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL t850_g_gl(g_gxk.gxk01,'1')
            END IF
         WHEN "maintain_entry_sheet"
            CALL s_fsgl('NM',11,g_gxk.gxk01,0,g_nmz.nmz02b, 0,g_gxk.gxkconf, '0',g_nmz.nmz02p) 
            CALL t850_npp02('0')
         WHEN "maintain_entry_sheet2"
            CALL s_fsgl('NM',11,g_gxk.gxk01,0,g_nmz.nmz02c, 0,g_gxk.gxkconf, '1',g_nmz.nmz02p) 
            CALL t850_npp02('1')
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t850_firm1()
               #FUN-B80125 --start--
               IF g_gxk.gxkconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
               #FUN-B80125 --end--
              #CALL cl_set_field_pic(g_gxk.gxkconf,"","","","","")    #FUN-B80125 mark
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t850_firm2()
              #FUN-B80125 add --start--
               IF g_gxk.gxkconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
            END IF
               CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
              #FUN-B80125 add --end--
              #CALL cl_set_field_pic(g_gxk.gxkconf,"","","","","")     #FUN-B80125 mark
            END IF
         #FUN-B80125 add --start--
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t850_x() #FUN-D20035 mark
               CALL t850_x(1) #FUN-D20035 add
               IF g_gxk.gxkconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
            END IF
         #FUN-B80125 add --end--
         #FUN-D20035 add str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t850_x(2)
               IF g_gxk.gxkconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
            END IF         
         #FUN-D20035 add end
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_gxk.gxkconf = 'Y' THEN
                  CALL t850_carry_voucher()   
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_gxk.gxkconf = 'Y' THEN
                  CALL t850_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gxl),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_gxk.gxk01 IS NOT NULL THEN
                 LET g_doc.column1 = "gxk01"
                 LET g_doc.value1 = g_gxk.gxk01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
    CLOSE t850_cs
END FUNCTION
 
FUNCTION t850_a()
DEFINE li_result   LIKE type_file.num5     #No.FUN-550057 #No.FUN-680107 SMALLINT
   IF s_anmshut(0) THEN
      RETURN
   END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_gxl.clear()
   INITIALIZE g_gxk.* LIKE gxk_file.*
   LET g_gxk_t.* = g_gxk.*
   LET g_gxk01_t = NULL
   LET g_gxk.gxk02 = g_today
   LET g_gxk.gxkconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_gxk.gxkacti ='Y'                   # 有效的資料
      LET g_gxk.gxkuser = g_user
      LET g_gxk.gxkoriu = g_user #FUN-980030
      LET g_gxk.gxkorig = g_grup #FUN-980030
      LET g_gxk.gxkgrup = g_grup               # 使用者所屬群
      LET g_gxk.gxkdate = g_today
      LET g_gxk.gxkinpd = g_today
 
      LET g_gxk.gxklegal= g_legal
 
      CALL t850_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_gxk.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
   CALL g_gxl.clear()
         EXIT WHILE
      END IF
      IF g_gxk.gxk01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK  #No.7875
        CALL s_auto_assign_no("anm",g_gxk.gxk01,g_gxk.gxk02,"E","gxk_file","gxk01","","","")
             RETURNING li_result,g_gxk.gxk01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gxk.gxk01
 
      INSERT INTO gxk_file VALUES(g_gxk.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gxk_file",g_gxk.gxk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_gxk.gxk01,'I')
         LET g_gxk_t.* = g_gxk.*               # 保存上筆資料
         SELECT gxk01 INTO g_gxk.gxk01 FROM gxk_file
          WHERE gxk01 = g_gxk.gxk01
      END IF
      CALL g_gxl.clear()
      LET g_rec_b =0                            #NO.FUN-680064
      CALL t850_b('0')
      IF g_nmy.nmydmy1 = 'Y' THEN
         CALL t850_firm1()
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t850_i(p_cmd)
   DEFINE
       p_cmd           LIKE type_file.chr1,     #No.FUN-680107          VARCHAR(1)
       l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入 #No.FUN-680107 VARCHAR(1)
       g_t1            LIKE oay_file.oayslip,   #No.FUN-550057          #No.FUN-680107 VARCHAR(5)
       l_dept          LIKE cre_file.cre08,     #No.FUN-680107          VARCHAR(10) #Dept
       l_amt           LIKE type_file.num20_6,  #No.FUN-4C0010          #No.FUN-680107 DES(20,6)
       l_n             LIKE type_file.num5      #No.FUN-680107          SMALLINT
DEFINE li_result       LIKE type_file.num5      #No.FUN-550057          #No.FUN-680107 SMALLINT
DEFINE l_nmc02         LIKE nmc_file.nmc02      #CHI-C20028 add
 
   DISPLAY BY NAME g_gxk.gxkuser,g_gxk.gxkmodu,                              #TQC-960086
       g_gxk.gxkgrup,g_gxk.gxkdate,g_gxk.gxkacti                             #TQC-960086
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
  INPUT BY NAME g_gxk.gxk01,g_gxk.gxk20,g_gxk.gxk02,g_gxk.gxk05,g_gxk.gxk09, g_gxk.gxkoriu,g_gxk.gxkorig,
                g_gxk.gxk04,g_gxk.gxk24,g_gxk.gxk06,g_gxk.gxk08,g_gxk.gxk07,
                g_gxk.gxk22,g_gxk.gxk19,g_gxk.gxkconf,g_gxk.gxkglno,g_gxk.gxk10,g_gxk.gxk101 #No.FUN-680088
               ,g_gxk.gxkud01,g_gxk.gxkud02,g_gxk.gxkud03,g_gxk.gxkud04,
                g_gxk.gxkud05,g_gxk.gxkud06,g_gxk.gxkud07,g_gxk.gxkud08,
                g_gxk.gxkud09,g_gxk.gxkud10,g_gxk.gxkud11,g_gxk.gxkud12,
                g_gxk.gxkud13,g_gxk.gxkud14,g_gxk.gxkud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t850_set_entry(p_cmd)
         CALL t850_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxk01")
         CALL cl_set_docno_format("gxl03")
         CALL cl_set_docno_format("gxl04")
 
      AFTER FIELD gxk01
         IF NOT cl_null(g_gxk.gxk01) AND (g_gxk.gxk01!=g_gxk_t.gxk01) THEN
            CALL s_check_no("anm",g_gxk.gxk01,g_gxk01_t,"E","gxk_file","gxk01","")
               RETURNING li_result,g_gxk.gxk01
            DISPLAY BY NAME g_gxk.gxk01
            IF (NOT li_result) THEN
               NEXT FIELD gxk01
            END IF
         END IF
 
      AFTER FIELD gxk20
         IF NOT cl_null(g_gxk.gxk20) THEN
            IF g_gxk.gxk20 NOT MATCHES '[123]' THEN
               NEXT FIELD gxk20
            END IF
            CALL s_gxksta(g_gxk.gxk20) RETURNING l_desc    #顯示對應的中文字
            DISPLAY l_desc TO FORMONLY.desc
         END IF
 
      AFTER FIELD gxk02
         IF NOT cl_null(g_gxk.gxk02) THEN
            IF g_gxk.gxk02 <= g_nmz.nmz10 THEN  #no.5261
               CALL cl_err('','aap-176',1) NEXT FIELD gxk02
            END IF
         END IF
 
      AFTER FIELD gxk24      #銀存異動碼 02/12/10 add
         IF NOT cl_null(g_gxk.gxk24) THEN
            SELECT nmc03 FROM nmc_file WHERE nmc01=g_gxk.gxk24 AND nmc03='2'
            IF STATUS THEN
               CALL cl_err3("sel","nmc_file",g_gxk.gxk24,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
               NEXT FIELD gxk24
            #CHI-C20028--add--str
            ELSE
               LET l_nmc02=NULL
               SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxk.gxk24
               DISPLAY l_nmc02 TO FORMONLY.nmc02_2
            #CHI-C20028--add--end
            END IF
         END IF
 
      AFTER FIELD gxk05
         IF NOT cl_null(g_gxk.gxk05) THEN
            CALL t850_gxk05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gxk.gxk05,g_errno,0)
               LET g_gxk.gxk05 = g_gxk_o.gxk05
               DISPLAY BY NAME g_gxk.gxk05
               NEXT FIELD gxk05
            END IF
            LET g_gxk_o.gxk05 = g_gxk.gxk05
           #str MOD-A10090 mod
           #CALL s_bankex(g_gxk.gxk05,g_gxk.gxk02) RETURNING g_gxk.gxk09   #MOD-790019
           #當nmz04='1'時CALL s_bankex() ELSE CALL s_curr3(curr,date,'B')
            SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
            IF g_nmz.nmz04='1' THEN
               CALL s_bankex(g_gxk.gxk05,g_gxk.gxk02) RETURNING g_gxk.gxk09
            ELSE
              #CALL s_curr3(g_gxk.gxk08,g_gxk.gxk02,'B') RETURNING g_gxk.gxk09  #MOD-AB0010 mark
               CALL s_curr3(g_gxk.gxk04,g_gxk.gxk02,'B') RETURNING g_gxk.gxk09  #MOD-AB0010
            END IF
           #end MOD-A10090 mod
         END IF
 
      AFTER FIELD gxk06
         IF g_gxk.gxk06 IS NULL THEN
            LET g_gxk.gxk07 = '0'
            DISPLAY BY NAME g_gxk.gxk07
         END IF
         CALL t850_gxk06('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_gxk.gxk06,g_errno,0)
            LET g_gxk.gxk06 = g_gxk_o.gxk06
            DISPLAY BY NAME g_gxk.gxk06
            NEXT FIELD gxk06
         END IF
         LET g_gxk_o.gxk06 = g_gxk.gxk06
 
      AFTER FIELD gxk09                                                         
         IF NOT cl_null(g_gxk.gxk09) THEN                                       
            IF g_gxk.gxk09 <= 0 THEN                                            
               CALL cl_err(g_gxk.gxk09,'anm-995',0)                             
               NEXT FIELD gxk09                                                 
            END IF                                                              
         END IF                                                                 
 
      AFTER FIELD gxk10
         IF NOT cl_null(g_gxk.gxk10) THEN
            IF g_gxk_o.gxk10 IS NULL OR g_gxk.gxk10 != g_gxk_o.gxk10 THEN
               CALL t850_gxk10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gxk.gxk10,g_errno,0)
#FUN-B20073 --begin--
                CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) 
                 RETURNING g_flag,g_bookno1,g_bookno2  
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_dbs_gl || ' ' || g_gxk.gxk02,'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxk.gxk10,'23',g_bookno1) 
                  RETURNING g_gxk.gxk10                  
#                  LET g_gxk.gxk10 = g_gxk_o.gxk10
#FUN-B20073 --end--
                  DISPLAY BY NAME g_gxk.gxk10
                  NEXT FIELD gxk10
               END IF
            END IF
            LET g_gxk_o.gxk10 = g_gxk.gxk10
         END IF
              
      AFTER FIELD gxk101
         IF NOT cl_null(g_gxk.gxk101) THEN
            IF g_gxk_o.gxk101 IS NULL OR g_gxk.gxk101 != g_gxk_o.gxk101 THEN
               CALL t850_gxk101('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gxk.gxk101,g_errno,0)
#FUN-B20073 --begin--
               CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) 
                  RETURNING g_flag,g_bookno1,g_bookno2 
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_dbs_gl || ' ' || g_gxk.gxk02,'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_gxk.gxk101,'23',g_bookno2) 
                 RETURNING g_gxk.gxk101                  
#                  LET g_gxk.gxk101 = g_gxk_o.gxk101
#FUN-B20073 --end--
                  DISPLAY BY NAME g_gxk.gxk101
                  NEXT FIELD gxk101
               END IF
            END IF
            LET g_gxk_o.gxk101 = g_gxk.gxk101
         END IF
 
      AFTER FIELD gxk22
          IF g_gxk.gxk07='2' AND cl_null(g_gxk.gxk22) THEN
             NEXT FIELD gxk22
          END IF
          IF NOT cl_null(g_gxk.gxk22) THEN
             SELECT nmc05 INTO g_gxk.gxk19 FROM nmc_file WHERE nmc01=g_gxk.gxk22 AND nmc03='1'  #MOD-920267
             IF STATUS THEN 
                CALL cl_err3("sel","nmc_file",g_gxk.gxk22,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
                NEXT FIELD gxk22 
             #CHI-C20028--add--str
             ELSE
                LET l_nmc02=NULL
                SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxk.gxk22
                DISPLAY l_nmc02 TO FORMONLY.nmc02_1
             #CHI-C20028--add--end
             END IF
          END IF
 
      AFTER FIELD gxk19   #現金變動碼
         IF NOT cl_null(g_gxk.gxk19) THEN
            SELECT nml02 INTO g_buf FROM nml_file WHERE nml01 = g_gxk.gxk19
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","nml_file",g_gxk.gxk19,"","anm-006","","",1)  #No.FUN-660148
               NEXT FIELD gxk19
            END IF
            DISPLAY g_buf TO nml02
         END IF
 
        AFTER FIELD gxkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_gxk.gxkuser = s_get_data_owner("gxk_file") #FUN-C10039
         LET g_gxk.gxkgrup = s_get_data_group("gxk_file") #FUN-C10039
          LET l_flag='N'
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          IF g_gxk.gxk20 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_gxk.gxk20
          END IF
          IF g_gxk.gxk07 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_gxk.gxk07
          END IF
          IF g_gxk.gxk05 IS NULL THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_gxk.gxk05
          END IF
          IF g_gxk.gxk09 IS NULL OR g_gxk.gxk09 = 0 THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_gxk.gxk09
          END IF
          IF l_flag='Y' THEN
             NEXT FIELD gxk01
          END IF
 
      ON KEY(F1)
         NEXT FIELD gxk01
 
      ON KEY(F2)
         NEXT FIELD gxk06
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gxk01)
               LET g_t1 = s_get_doc_no(g_gxk.gxk01)       #No.FUN-550057
               CALL q_nmy( FALSE, TRUE, g_t1,'E','ANM') RETURNING g_t1  #TQC-670008
               LET g_gxk.gxk01 = g_t1        #No.FUN-550057
               DISPLAY BY NAME g_gxk.gxk01 NEXT FIELD gxk01
            WHEN INFIELD(gxk05) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_gxk.gxk05
               CALL cl_create_qry() RETURNING g_gxk.gxk05
               DISPLAY BY NAME g_gxk.gxk05
            WHEN INFIELD(gxk06) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_gxk.gxk06
               CALL cl_create_qry() RETURNING g_gxk.gxk06
               DISPLAY BY NAME g_gxk.gxk06
            WHEN INFIELD(gxk10) # Dept CODE
               CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_dbs_gl || ' ' || g_gxk.gxk02,'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxk.gxk10,'23',g_bookno1) #No.FUN-980025 
               RETURNING g_gxk.gxk10
               DISPLAY BY NAME g_gxk.gxk10
            WHEN INFIELD(gxk101) # Dept CODE
               CALL s_get_bookno1(YEAR(g_gxk.gxk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_dbs_gl || ' ' || g_gxk.gxk02,'aoo-081',1)
               END IF
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_gxk.gxk101,'23',g_bookno2) #No.FUN-980025 
               RETURNING g_gxk.gxk101
               DISPLAY BY NAME g_gxk.gxk101
            WHEN INFIELD(gxk19) #現金變動碼值
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_gxk.gxk19
               CALL cl_create_qry() RETURNING g_gxk.gxk19
               DISPLAY BY NAME g_gxk.gxk19
            WHEN INFIELD(gxk22) #銀行異動碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc01"   #MOD-670127
               LET g_qryparam.default1 = g_gxk.gxk22
               LET g_qryparam.arg1 = '1'   #MOD-670127
               CALL cl_create_qry() RETURNING g_gxk.gxk22
               DISPLAY BY NAME g_gxk.gxk22
               NEXT FIELD gxk22
            WHEN INFIELD(gxk24) #銀行異動碼(提)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc01"   #MOD-670127
               LET g_qryparam.default1 = g_gxk.gxk24
               LET g_qryparam.arg1 = '2'   #MOD-670127
               CALL cl_create_qry() RETURNING g_gxk.gxk24
               DISPLAY BY NAME g_gxk.gxk24
               NEXT FIELD gxk24
            WHEN INFIELD(gxk08) #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_gxk.gxk08
               CALL cl_create_qry() RETURNING g_gxk.gxk08
               DISPLAY BY NAME g_gxk.gxk08
                NEXT FIELD gxk08  #No.MOD-490140
            WHEN INFIELD(gxk04) #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_gxk.gxk04
               CALL cl_create_qry() RETURNING g_gxk.gxk04
               DISPLAY BY NAME g_gxk.gxk04
               NEXT FIELD gxk04
              WHEN INFIELD(gxk09)
                   CALL s_rate(g_gxk.gxk04,g_gxk.gxk09) RETURNING g_gxk.gxk09   #MOD-670127
                   DISPLAY BY NAME g_gxk.gxk09
                   NEXT FIELD gxk09
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
 
FUNCTION t850_gxk05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma02_1 LIKE nma_file.nma02
   DEFINE l_nma10   LIKE nma_file.nma10   #MOD-610057
 
  SELECT nma02,nma10 INTO l_nma02_1,l_nma10
     FROM nma_file WHERE nma01 = g_gxk.gxk05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   DISPLAY l_nma02_1 TO nma02_1
   LET g_gxk.gxk04 = l_nma10   #MOD-610057
   DISPLAY BY NAME g_gxk.gxk04   #MOD-610057
END FUNCTION
 
FUNCTION t850_gxk06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma   RECORD LIKE nma_file.*
 
   IF g_gxk.gxk06 IS NULL THEN RETURN END IF
   SELECT * INTO l_nma.*
     FROM nma_file WHERE nma01 = g_gxk.gxk06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-039'
        WHEN l_nma.nmaacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY BY NAME l_nma.nma02
   IF p_cmd != 'a' THEN RETURN END IF
   LET g_gxk.gxk07 = l_nma.nma28
   LET g_gxk.gxk08 = l_nma.nma10
   IF g_gxk.gxk07='1' THEN     # 貸: 應付票據
      SELECT nms15 INTO g_gxk.gxk10 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
      IF g_aza.aza63 = 'Y' THEN
         SELECT nms151 INTO g_gxk.gxk101 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
      END IF
   ELSE
      LET g_gxk.gxk10 = l_nma.nma05     # 貸: 銀行存款
      IF g_aza.aza63 = 'Y' THEN
         LET g_gxk.gxk101 = l_nma.nma051     # 貸: 銀行存款
      END IF
   END IF
   DISPLAY BY NAME g_gxk.gxk07,g_gxk.gxk08,g_gxk.gxk10
   DISPLAY BY NAME g_gxk.gxk101  #No.FUN-680088
END FUNCTION
 
FUNCTION t850_gxk10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_aag   RECORD LIKE aag_file.*
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
 
   CALL s_get_bookno(YEAR(g_gxk.gxk02)) RETURNING l_flag1,l_bookno1,l_bookno2
   IF l_flag1 = '1' THEN
       LET g_errno = 'aoo-081'
       RETURN
   END IF
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01 = g_gxk.gxk10
                                         AND aag00 = l_bookno1 #No.FUN-730032
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
        WHEN l_aag.aagacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
END FUNCTION
 
FUNCTION t850_gxk101(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-680107 VARCHAR(1)
   DEFINE l_aag   RECORD LIKE aag_file.*
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
 
   CALL s_get_bookno(YEAR(g_gxk.gxk02)) RETURNING l_flag1,l_bookno1,l_bookno2
   IF l_flag1 = '1' THEN
       LET g_errno = 'aoo-081'
       RETURN
   END IF
 
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01 = g_gxk.gxk101
                                         AND aag00 = l_bookno2 #No.FUN-730032
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
        WHEN l_aag.aagacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
END FUNCTION
 
FUNCTION t850_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gxk.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t850_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
   CALL g_gxl.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t850_count
   FETCH t850_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t850_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)
      INITIALIZE g_gxk.* TO NULL
   ELSE
      CALL t850_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t850_fetch(p_flgxk)
   DEFINE
       p_flgxk LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
       l_abso  LIKE type_file.num10    #No.FUN-680107 INTEGER 
 
   CASE p_flgxk
      WHEN 'N' FETCH NEXT     t850_cs INTO g_gxk.gxk01
      WHEN 'P' FETCH PREVIOUS t850_cs INTO g_gxk.gxk01
      WHEN 'F' FETCH FIRST    t850_cs INTO g_gxk.gxk01
      WHEN 'L' FETCH LAST     t850_cs INTO g_gxk.gxk01
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
            FETCH ABSOLUTE g_jump t850_cs INTO g_gxk.gxk01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)
      INITIALIZE g_gxk.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flgxk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_gxk.* FROM gxk_file       # 重讀DB,因TEMP有不被更新特性
    WHERE gxk01 = g_gxk.gxk01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gxk_file",g_gxk.gxk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_gxk.gxkuser     #No.FUN-4C0063
      LET g_data_group = g_gxk.gxkgrup     #No.FUN-4C0063
      CALL t850_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION t850_show()
DEFINE g_t1            LIKE oay_file.oayslip, #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
       g_gxl15         LIKE gxl_file.gxl15,
       g_gxl17         LIKE gxl_file.gxl17,
       g_gxl181        LIKE gxl_file.gxl181,   #FUN-6C0036
       g_gxl18         LIKE gxl_file.gxl18     #FUN-6C0036
DEFINE li_result       LIKE type_file.num5    #No.FUN-560002 #No.FUN-680107 SMALLINT
DEFINE l_nmc02         LIKE nmc_file.nmc02    #CHI-C20028 add
 
   LET g_gxk_t.* = g_gxk.*
   DISPLAY BY NAME g_gxk.gxk01,g_gxk.gxk20,g_gxk.gxk02,g_gxk.gxk04,g_gxk.gxk24, g_gxk.gxkoriu,g_gxk.gxkorig,
                   g_gxk.gxk05,g_gxk.gxk06,g_gxk.gxk07,g_gxk.gxk08,g_gxk.gxk09,
                   g_gxk.gxk10,g_gxk.gxk22,g_gxk.gxk19,g_gxk.gxk11,g_gxk.gxk12,
                   g_gxk.gxk13,g_gxk.gxk14,g_gxk.gxk16,g_gxk.gxkglno,g_gxk.gxkconf,g_gxk.gxk101     #No.FUN-680088 
                  ,g_gxk.gxkud01,g_gxk.gxkud02,g_gxk.gxkud03,g_gxk.gxkud04,
                   g_gxk.gxkud05,g_gxk.gxkud06,g_gxk.gxkud07,g_gxk.gxkud08,
                   g_gxk.gxkud09,g_gxk.gxkud10,g_gxk.gxkud11,g_gxk.gxkud12,
                   g_gxk.gxkud13,g_gxk.gxkud14,g_gxk.gxkud15 
                   ,g_gxk.gxkuser,g_gxk.gxkgrup,g_gxk.gxkmodu,g_gxk.gxkdate,g_gxk.gxkacti           #TQC-960086
 
   SELECT nml02 INTO g_buf FROM nml_file WHERE nml01 = g_gxk.gxk19
   DISPLAY g_buf TO nml02
   LET g_buf = NULL
 
   SELECT sum(gxl15),sum(gxl17),sum(gxl181),sum(gxl18) INTO g_gxl15,g_gxl17,g_gxl181,g_gxl18   #FUN-6C0036
          FROM gxl_file where gxl01 = g_gxk.gxk01
   IF cl_null(g_gxl15) THEN LET g_gxl15 = 0 END IF
   IF cl_null(g_gxl17) THEN LET g_gxl17 = 0 END IF
   IF cl_null(g_gxl181) THEN LET g_gxl181 = 0 END IF
   IF cl_null(g_gxl18) THEN LET g_gxl18 = 0 END IF
   DISPLAY g_gxl15,g_gxl17,g_gxl181,g_gxl18 TO tot1,tot2,tot3,tot4
#CHI-C20028--add--str
   LET l_nmc02=NULL
   SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxk.gxk22
   DISPLAY l_nmc02 TO FORMONLY.nmc02_1
   LET l_nmc02=NULL
   SELECT nmc02 INTO l_nmc02 FROM nmc_file WHERE nmc01=g_gxk.gxk24
   DISPLAY l_nmc02 TO FORMONLY.nmc02_2
#CHI-C20028--add--end 
   CALL t850_gxk05('d')
   CALL t850_gxk06('d')
   CALL s_gxksta(g_gxk.gxk20) RETURNING l_desc    #顯示對應的中文字
   DISPLAY l_desc TO FORMONLY.desc
   CALL t850_b_fill(' 1=1')
   LET g_t1 = s_get_doc_no(g_gxk.gxk01)       #No.FUN-550057
  #CALL s_check_no("anm",g_gxk.gxk01,"","E","","","")   #MOD-B30135 mark
  #RETURNING li_result,g_gxk.gxk01                      #MOD-B30135 mark
   #FUN-B80125 add --start--
   IF g_gxk.gxkconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
   #FUN-B80125 add --end--
  #CALL cl_set_field_pic(g_gxk.gxkconf,"","","","","")  #FUN-B80125
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t850_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_gxk.gxk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
  #FUN-B80125--(B mark)--
  #IF g_gxk.gxkconf='Y' THEN
  #   CALL cl_err('','axm-101',0)
  #   RETURN
  #END IF
  #FUN-B80125--(E mark)--
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf='Y' THEN
      CALL cl_err(g_gxk.gxk01,'anm-105',2)
      RETURN
   END IF
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err(g_gxk.gxk01,'9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
   IF g_gxk.gxkacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_gxk.gxk01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t850_cl USING g_gxk.gxk01
   IF STATUS THEN
      CALL cl_err("OPEN t850_cl:", STATUS, 1)
      CLOSE t850_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t850_cl INTO g_gxk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)
       RETURN
   END IF
   LET g_gxk01_t = g_gxk.gxk01
   LET g_gxk_o.*=g_gxk.*
   LET g_gxk.gxkmodu=g_user                     #修改者
   LET g_gxk.gxkdate = g_today                  #修改日期
   CALL t850_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t850_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gxk.*=g_gxk_t.*
         CALL t850_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gxk_file SET gxk_file.* = g_gxk.*    # 更新DB
       WHERE gxk01 = g_gxk01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gxk_file",g_gxk01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      IF g_gxk.gxk02 != g_gxk_t.gxk02 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_gxk.gxk02
          WHERE npp01=g_gxk.gxk01 AND npp00=11 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_gxk01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t850_cl
   COMMIT WORK
   CALL cl_flow_notify(g_gxk.gxk01,'U')
END FUNCTION
 
FUNCTION t850_npp02(p_npptype)     #No.FUN-680088
 DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680088
 
   IF g_gxk.gxkglno IS NULL OR g_gxk.gxkglno=' ' THEN
      UPDATE npp_file SET npp02=g_gxk.gxk02
       WHERE npp01=g_gxk.gxk01 AND npp00=11 AND npp011=0
         AND nppsys = 'NM'
         AND npptype= p_npptype  #No.FUN-680088
      IF STATUS THEN
         CALL cl_err3("upd","npp_file",g_gxk.gxk01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
      END IF
   END IF
END FUNCTION
 
FUNCTION t850_r()
   DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_gxk.gxk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
  #FUN-B80125--(B mark)--
  #IF g_gxk.gxkconf='Y' THEN
  #   CALL cl_err('','axm-101',0)
  #   RETURN
  #END IF
  #FUN-B80125--(E mark)--
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf='Y' THEN
      CALL cl_err(g_gxk.gxk01,'anm-105',2)
      RETURN
   END IF
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err(g_gxk.gxk01,'9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
 
   BEGIN WORK
 
   OPEN t850_cl USING g_gxk.gxk01
   IF STATUS THEN
      CALL cl_err("OPEN t850_cl:", STATUS, 1)
      CLOSE t850_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t850_cl INTO g_gxk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t850_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gxk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gxk.gxk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM gxk_file WHERE gxk01 = g_gxk.gxk01
      IF STATUS THEN 
         CALL cl_err3("del","gxk_file",g_gxk.gxk01,"",STATUS,"","del gxk:",1)  #No.FUN-660148
         RETURN
      END IF
      DELETE FROM gxl_file WHERE gxl01 = g_gxk.gxk01
      IF STATUS THEN
         CALL cl_err3("del","gxl_file",g_gxk.gxk01,"",STATUS,"","del gxl:",1)  #No.FUN-660148
         RETURN
      END IF
      DELETE FROM npp_file
        WHERE nppsys='NM' AND npp00=11 AND npp01=g_gxk.gxk01 AND npp011=0
      IF STATUS THEN
         CALL cl_err3("del","npp_file",g_gxk.gxk01,"",STATUS,"","del npp:",1)  #No.FUN-660148
         RETURN
      END IF
      DELETE FROM npq_file
        WHERE npqsys='NM' AND npq00=11 AND npq01=g_gxk.gxk01 AND npq011=0
      IF STATUS THEN
         CALL cl_err3("del","npq_file",g_gxk.gxk01,"",STATUS,"","del npq:",1)  #No.FUN-660148
         RETURN
      END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_gxk.gxk01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_gxk.gxk01,"",STATUS,"","del tic:",1)
         RETURN
      END IF
      #FUN-B40056--add--end--
      INITIALIZE g_gxk.* TO NULL
      OPEN t850_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t850_cs
         CLOSE t850_count
         COMMIT WORK
         #TQC-DA0025 add start ---
         CLEAR FORM
         CALL g_gxl.clear()
         #TQC-DA0025 add end -----
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t850_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t850_cs
         CLOSE t850_count
         COMMIT WORK
         #TQC-DA0025 add start ---
         CLEAR FORM
         CALL g_gxl.clear()
         #TQC-DA0025 add end -----
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t850_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t850_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t850_fetch('/')
      END IF
   #TQC-DA0025 add start ---
   ELSE
      CLOSE t850_cl
      ROLLBACK WORK
      RETURN
   #TQC-DA0025 add end -----
   END IF
   CLOSE t850_cl
  #CLEAR FORM              #TQC-DA0025 mark
  #CALL g_gxl.clear()      #TQC-DA0025 mark
   COMMIT WORK
   CALL cl_flow_notify(g_gxk.gxk01,'D')
END FUNCTION
#FUN-B80125--(B)--
#FUNCTION t850_x() #FUN-D20035 mark
FUNCTION t850_x(p_type) #FUN-D20035 add
   
   DEFINE l_year,l_month  LIKE type_file.num5,
          l_flag          LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add
   IF s_anmshut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gxk.gxk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
   IF g_gxk.gxkconf='Y' THEN
      CALL cl_err(g_gxk.gxk01,'anm-105',2)
      RETURN
   END IF
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gxk.gxkglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gxk.gxk01,'aap-618',0) 
         RETURN
      END IF
   END IF
   #FUN-D20035---begin 
   IF p_type = 1 THEN 
      IF g_gxk.gxkconf='X' THEN RETURN END IF
   ELSE
      IF g_gxk.gxkconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20035---end   
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t850_cl USING g_gxk.gxk01
   IF STATUS THEN
      CALL cl_err("OPEN t850_cl:", STATUS, 1)
      CLOSE t850_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t850_cl INTO g_gxk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)
      CLOSE t850_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_gxk_o.* = g_gxk.*
   LET g_gxk_t.* = g_gxk.*
   CALL t850_show()
   IF cl_void(0,0,g_gxk.gxkconf) THEN
      IF g_gxk.gxkconf='N' THEN    #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00=11
            AND npp01 = g_gxk.gxk01
            AND npp011=0
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_gxk.gxk01,"",SQLCA.sqlcode,"","(t850_r:delete npp)",1)
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'NM'
            AND npq00=11
            AND npq01 = g_gxk.gxk01
            AND npq011=0
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_gxk.gxk01,"",SQLCA.sqlcode,"","(t850_r:delete npq)",1)
            LET g_success='N'
         END IF
         DELETE FROM tic_file WHERE tic04 = g_gxk.gxk01
         IF STATUS THEN
            CALL cl_err3("del","tic_file",g_gxk.gxk01,"",STATUS,"","del tic:",1)
            LET g_success='N'
         END IF
 
         LET g_gxk.gxkconf='X'
      ELSE                         #取消作廢
         LET g_gxk.gxkconf='N'
      END IF
#No:FUN-C60006---add--star---
      LET g_gxk.gxkmodu = g_user
      LET g_gxk.gxkdate = g_today
      DISPLAY BY NAME g_gxk.gxkmodu
      DISPLAY BY NAME g_gxk.gxkdate
#No:FUN-C60006---add--end---

      UPDATE gxk_file SET gxkconf=g_gxk.gxkconf,
      #No:FUN-C60006---add--star---
                          gxkmodu = g_user,
                          gxkdate = g_today
      #No:FUN-C60006---add--end---
       WHERE gxk01 = g_gxk.gxk01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gxk_file",g_gxk.gxk01,"",STATUS,"","",1)
         LET g_success='N'
      END IF
   END IF
   SELECT gxkconf INTO g_gxk.gxkconf FROM gxk_file
    WHERE gxk01 = g_gxk.gxk01
   DISPLAY BY NAME g_gxk.gxkconf
   CLOSE t850_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_gxk.gxk01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
#FUN-B80125--(E)--
 
FUNCTION t850_firm1()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060 #No.FUN-680107 INTEGER
 
#CHI-C30107 ----------- add ------------ begin
   IF g_gxk.gxkconf='Y' THEN
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
#CHI-C30107 ----------- add ------------ end
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
   IF g_gxk.gxkconf='Y' THEN
      RETURN
   END IF
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
   CALL s_get_doc_no(g_gxk.gxk01) RETURNING g_t1            #TQC-870042 add
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1   #TQC-870042 add
   SELECT COUNT(*) INTO g_cnt FROM gxl_file
    WHERE gxl01=g_gxk.gxk01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1)
      RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   IF g_gxk.gxk02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gxk.gxk01,'aap-176',1)
      RETURN
   END IF
#CHI-C30107 ----------- add ---------- begin
#  IF NOT cl_confirm('axm-108') THEN
#     RETURN
#  END IF
#CHI-C30107 ----------- add ---------- end
   BEGIN WORK
   LET g_success='Y'
   CALL s_get_bookno(YEAR(g_gxk.gxk02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_gxk.gxk02,'aoo-081',1)
      LET g_success='N'
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN  #No.FUN-670060  #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      CALL s_chknpq1(g_gxk.gxk01,0,11,'0',g_bookno1)  #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq1(g_gxk.gxk01,0,11,'1',g_bookno2)  #No.FUN-730032
      END IF
   END IF
   IF g_success ='N' THEN RETURN END IF  #No.FUN-680088
   LET g_gxk.gxkconf ='Y'
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_gxk.gxk01
         AND npq011 = 0
         AND npqsys = 'NM'
         AND npq00 = 11
      IF l_n = 0 THEN
         CALL t850_gen_glcr(g_gxk.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq1(g_gxk.gxk01,0,11,'0',g_bookno1)  #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND  g_success = 'Y' THEN
            CALL s_chknpq1(g_gxk.gxk01,0,11,'1',g_bookno2) #No.FUN-730032
         END IF
      END IF
      IF g_success ='N' THEN 
         LET g_gxk.gxkconf = 'N'   #MOD-A60032 add
         RETURN 
      END IF  #No.FUN-680088
   END IF
   UPDATE gxk_file SET gxkconf = 'Y' WHERE gxk01 = g_gxk.gxk01
   CALL s_showmsg_init()               #No.FUN-710024
   CALL t850_y1()
   CALL s_showmsg()                    #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_gxk.gxk01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_gxk.gxkconf ='N'
   END IF
   DISPLAY BY NAME g_gxk.gxkconf
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_gxk.gxk01,'" AND npp011 = 0'
      LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxk.gxk02,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT gxkglno INTO g_gxk.gxkglno FROM gxk_file
       WHERE gxk01 = g_gxk.gxk01
      DISPLAY BY NAME g_gxk.gxkglno
   END IF
   CALL cl_set_field_pic(g_gxk.gxkconf,"","","","","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t850_y1()
   DECLARE t850_y1_c CURSOR FOR
      SELECT * FROM gxl_file WHERE gxl01=g_gxk.gxk01
   FOREACH t850_y1_c INTO b_gxl.*
      IF STATUS THEN
         LET g_success = 'N'        #FUN-8A0086
         EXIT FOREACH
      END IF
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
      MESSAGE b_gxl.gxl02
      IF b_gxl.gxl12 IS NULL THEN      #尚未輸入金額資料!
         CALL s_errmsg('','','',"aap-705",1)       #No.FUN-710024
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF g_gxk.gxk20 = '2' THEN
         CALL t850_upd_gxf('3')   # 解約
      ELSE
         CALL t850_upd_gxf('4')   # 到期
      END IF
      CALL t850_upd_gxh()  #CHI-A50017 add
      CASE                                   #No:8677 每個單身的利息自己一筆
         WHEN g_gxk.gxk20 = '1' #到期
            CALL t850_ins_nme('1')
         WHEN g_gxk.gxk20 = '2' #解約
            CALL t850_ins_nme('2')
         WHEN g_gxk.gxk20 = '3' #續存        #No.CHI-860034 Mark   #FUN-870145                                                                 
            CALL t850_ins_nme('3')           #No.CHI-860034 Mark   #FUN-870145
         OTHERWISE EXIT CASE
      END CASE
   END FOREACH                              #No:8677換位置..
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
END FUNCTION
 
#CHI-A50017 add --start--
FUNCTION t850_upd_gxh()
  UPDATE gxh_file SET gxh13 = g_gxk.gxk01
   WHERE gxh13 IS NULL AND gxh011=b_gxl.gxl03
  IF SQLCA.SQLCODE THEN
     CALL s_errmsg("gxh011",b_gxl.gxl03,"UPD gxh_file",SQLCA.sqlcode,1)
     LET g_success='N'
  END IF
END FUNCTION
#CHI-A50017 add --end--

FUNCTION t850_upd_gxf(p_sta)
   DEFINE amt1,amt2      LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE p_sta,l_gxg021 LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_gxk02        LIKE gxk_file.gxk02
   DEFINE l_gxf13        LIKE gxf_file.gxf13     #MOD-880119 add
   DEFINE l_gxf          RECORD LIKE gxf_file.*
   DEFINE l_azi04        LIKE azi_file.azi04
   DEFINE g_i            LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE li_result      LIKE type_file.num5     #No.FUN-550057 #No.FUN-680107 SMALLINT
 
  
   SELECT SUM(gxl12),SUM(gxl14) INTO amt1,amt2
     FROM gxl_file,gxk_file
    WHERE gxl04=b_gxl.gxl04 AND gxl01=gxk01 AND gxkconf='Y'
      AND gxk01=g_gxk.gxk01   #MOD-640388
   IF STATUS THEN
      LET g_showmsg=b_gxl.gxl04,"/",g_gxk.gxk01                       #No.FUN-710024
      CALL s_errmsg("gxl04,gxk01",g_showmsg,"SEL gxl_file,gxk_file",SQLCA.sqlcode,1)   #No.FUN-710024
      LET g_success='N'
   END IF
   IF amt1 IS NULL THEN
      LET amt1=0
   END IF
   IF amt2 IS NULL THEN
      LET amt2=0
   END IF
   LET l_gxk02=''
   IF p_sta = 'z' THEN
      LET l_gxg021 = ' '
      SELECT gxg021 INTO l_gxg021 FROM gxg_file
       WHERE gxg011 = b_gxl.gxl03                        
         AND gxg02 = (SELECT MAX(gxg02) FROM gxg_file WHERE gxg01 = b_gxl.gxl04)
      IF STATUS OR l_gxg021 IS NULL THEN
         LET l_gxg021 = ' '
         LET p_sta = '0'
      ELSE
         LET p_sta = l_gxg021
      END IF
      IF g_gxk.gxk20='3' THEN     #須刪除產生之gxf_file
        #刪除gxf_file前,需檢查xf13(存入傳票編號)為空值才可刪除
         SELECT gxf13 INTO l_gxf13 FROM gxf_file WHERE gxf40=g_gxk.gxk01
         IF cl_null(l_gxf13) OR l_gxf13=' ' THEN
            DELETE FROM gxf_file WHERE gxf40=g_gxk.gxk01
            IF STATUS THEN
               CALL s_errmsg("gxf40",g_gxk.gxk01,"DEL gxf_file",SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         ELSE
            CALL s_errmsg("gxf40",g_gxk.gxk01,"","afa-311",1)
            LET g_success='N'
         END IF
      END IF
   END IF
  #解約時,應將gxk02回寫回gxf23,否則anmr820出表時會將解約資料抓出
   IF p_sta='3' THEN
      LET l_gxk02 = g_gxk.gxk02
   END IF
   UPDATE gxf_file SET gxf23 = l_gxk02,
                       gxf11 = p_sta,
                       gxf27 = amt1,
                       gxf28 = amt2
    WHERE gxf011=b_gxl.gxl03
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg("gxf011",b_gxl.gxl02,"UPD gxf_file",SQLCA.sqlcode,1)     #No.FUN-710024
      LET g_success='N'
   END IF
   IF p_sta='4' AND g_gxk.gxk20='3' THEN
 
      SELECT * INTO l_gxf.* FROM gxf_file   #先取出原來的資料
       WHERE gxf011=b_gxl.gxl03
         AND gxfconf <> 'X'                          #MOD-CB0066 add
      LET l_gxf.gxf01 = b_gxl.gxl04        #存單號碼
      LET l_gxf.gxf021 = b_gxl.gxl21       #定存金額
      LET l_gxf.gxf03 = g_gxk.gxk02        #原存日期
      LET l_gxf.gxf05 = b_gxl.gxl19        #到期日
      LET l_gxf.gxf06 = b_gxl.gxl20        #利率
      #CHI-C90052 add begin---
      IF cl_null(l_gxf.gxf06) THEN
         LET l_gxf.gxf06=0
      END IF
     #CHI-C90052 add end-----
      LET l_gxf.gxf08 = ' '             #質押對象
      LET l_gxf.gxf09 = 0               #質押金額
      LET l_gxf.gxf10 = ' '             #質押性質
      LET l_gxf.gxf11 = 0               #存單狀態
      LET l_gxf.gxf12 = ''                 #摘要
      LET l_gxf.gxf13 = ''                 #存入傳票編號
      LET l_gxf.gxf14 = ''                 #存入傳票日期
      LET l_gxf.gxf15 = ''                 #解約傳票編號
      LET l_gxf.gxf16 = ''                 #解約傳票日期
      LET l_gxf.gxf17 = ''                 #質押傳票編號       
     #LET l_gxf.gxf18 = ''                 #質押傳票日期        #CHI-C90052 mark
      LET l_gxf.gxf19 = ' '                #解除質押傳票編號
      LET l_gxf.gxf20 = ' '                #解除質押傳票日期
     #LET l_gxf.gxf21 = ' '                #質押日期            #CHI-C90052 mark
      LET l_gxf.gxf22 = ' '                #解除質押日期       
      LET l_gxf.gxf23 = ''                 #解約日期
      CALL s_curr3(l_gxf.gxf24,l_gxf.gxf03,'B')
        RETURNING l_gxf.gxf25
      LET l_gxf.gxf26=l_gxf.gxf25*l_gxf.gxf021 #本幣金額
      IF NOT cl_null(g_azi04) THEN
         CALL cl_digcut(l_gxf.gxf26,g_azi04) RETURNING l_gxf.gxf26
      END IF
      LET l_gxf.gxf27 = 0                  #到期收款原幣金額
      LET l_gxf.gxf28 = 0                  #到期收款本幣金額
      LET l_gxf.gxf29 = ' '                #到期傳票
      LET l_gxf.gxf30 = ''                 #到期傳票日期
      LET l_gxf.gxf32 = g_gxk.gxk06        #提出銀行   #MOD-770012
      LET l_gxf.gxf33f = b_gxl.gxl21       #存出原幣金額 No:8677
      LET l_gxf.gxf33 = l_gxf.gxf26        #存出本幣金額
      LET l_gxf.gxf36 = l_gxf.gxf25        #匯率
      LET l_gxf.gxf37 = ' '                #摘要
      LET l_gxf.gxf38 = '2'                #狀況'1' 一般定存 '2' 續約
      LET l_gxf.gxf39 = l_gxf.gxf011       #原申請號碼
      LET l_gxf.gxf40 = g_gxk.gxk01        #收款單號
      LET l_gxf.gxf41 = 'N'                #TQC-C50070 開賬
      LET l_gxf.gxfconf = 'N'              #確認碼
      LET l_gxf.gxfuser = g_user
      LET l_gxf.gxfgrup = g_grup
      LET l_gxf.gxfmodu = ''
      LET l_gxf.gxfdate = g_today
      LET l_gxf.gxfacti = 'Y'
     #申請號碼
      IF g_nmy.nmyauno='Y' THEN
         CALL s_auto_assign_no("anm",l_gxf.gxf011[1,g_doc_len],l_gxf.gxf03,"G","gxf_file","gxf011","","","")
              RETURNING li_result,l_gxf.gxf011
      END IF
      IF (NOT li_result) THEN
         CALL s_errmsg('','',"INS gxf",SQLCA.sqlcode,0)     #No.FUN-710024
      END IF
      DISPLAY BY NAME g_gxf.gxf011
      LET l_gxf.gxflegal= g_legal
      LET l_gxf.gxforiu = g_user            #No.FUN-980030 10/01/04
      LET l_gxf.gxforig = g_grup            #No.FUN-980030 10/01/04
      INSERT INTO gxf_file VALUES(l_gxf.*)
      IF STATUS THEN
         CALL s_errmsg("gxf011",l_gxf.gxf011,"INS gxf_file",SQLCA.sqlcode,1)    #No.FUN-710024
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t850_ins_nme(p_flag)
   DEFINE l_nme    RECORD LIKE nme_file.*
   DEFINE p_flag   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_gxl15  LIKE gxl_file.gxl15
   DEFINE l_gxl17  LIKE gxl_file.gxl17
   DEFINE l_gxl18  LIKE gxl_file.gxl18
   DEFINE l_gxl181 LIKE gxl_file.gxl181   #MOD-760041
   DEFINE l_azi04  LIKE azi_file.azi04

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF p_flag ='1' OR p_flag='3' THEN                   #定存到期 No:8677 因續存金額可能不同,故還是要產生nme
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk06
      LET l_nme.nme02=g_gxk.gxk02
      LET l_nme.nme03=g_gxk.gxk22
      LET l_nme.nme04=b_gxl.gxl12
      LET l_nme.nme08=b_gxl.gxl14
      LET l_nme.nme07=g_gxk.gxk09
      LET l_nme.nme10=g_gxk.gxkglno
      LET l_nme.nme12=g_gxk.gxk01
     SELECT nma02 INTO l_nme.nme13 FROM nma_file where nma01=g_gxk.gxk05
      IF STATUS THEN LET l_nme.nme13=g_gxk.gxk05 END IF
     SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
      WHERE nmc01 = g_gxk.gxk22
      LET l_nme.nme16=g_gxk.gxk02
      LET l_nme.nme17=g_gxk.gxk01
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET t_azi04 = 0
      SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
       WHERE azi01 = nma10 AND nma01 = l_nme.nme01
      IF NOT cl_null(t_azi04) THEN
         CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
      END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '18'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal

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
 
       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
          LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO nme_file VALUES(l_nme.*)
          CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
       END IF   #MOD-7B0123
       IF STATUS THEN 
          CALL s_errmsg("nme02",l_nme.nme02,"INS nme_file",SQLCA.sqlcode,1)      #No.FUN-710024
          LET g_success='N' END IF  #No:8677
       
      SELECT SUM(gxl15),SUM(gxl17),SUM(gxl18),SUM(gxl181)
        INTO l_gxl15,l_gxl17,l_gxl18,l_gxl181
        FROM gxl_file WHERE gxl01=g_gxk.gxk01 AND gxl02=b_gxl.gxl02   #No:8677
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk06   #存入銀行
      LET l_nme.nme02=g_gxk.gxk02   #收款日期
      LET l_nme.nme03=g_gxk.gxk22   #存入異動碼
      LET l_nme.nme07=g_gxk.gxk09   #匯率
      IF l_nme.nme07 = 1 THEN
         LET l_nme.nme04=l_gxl17-l_gxl18
      ELSE
         LET l_nme.nme04=l_gxl15-l_gxl181   #*0.9   # Thomas 020207 020208 020227 No:7352改成直接輸入不會有差   #MOD-760041
      END IF
      LET l_nme.nme08=l_gxl17-l_gxl18
      LET l_nme.nme10=g_gxk.gxkglno #收款傳票編號
      LET l_nme.nme12=g_gxk.gxk01   #收款單號
      SELECT nma02 INTO l_nme.nme13 FROM nma_file
        WHERE nma01=g_gxk.gxk05     #收支對象簡稱
        IF STATUS THEN LET l_nme.nme13=g_gxk.gxk05 END IF
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
        WHERE nmc01 = g_gxk.gxk22
       LET l_nme.nme16=g_gxk.gxk02  #會計日期
       LET l_nme.nme17=g_gxk.gxk01
       LET l_nme.nmeacti='Y'
       LET l_nme.nmeuser=g_user
       LET l_nme.nmegrup=g_grup
       LET l_nme.nmedate=TODAY
       LET t_azi04 = 0
       SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
        WHERE azi01 = nma10 AND nma01 = l_nme.nme01
       IF NOT cl_null(t_azi04) THEN
          CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
       END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '19'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal
 
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

       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          INSERT INTO nme_file VALUES(l_nme.*)
       END IF   #MOD-7B0123
       IF STATUS THEN 
          CALL s_errmsg("nme02",l_nme.nme02,"INS nme_file",SQLCA.sqlcode,1)      #No.FUN-710024
          LET g_success='N' END IF    #No:8677
      #需扣除存款的銀行
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk05   #扣款銀行
      LET l_nme.nme02=g_gxk.gxk02   #扣款日期
      LET l_nme.nme03=g_gxk.gxk24   #支出異動碼
      LET l_nme.nme04=b_gxl.gxl11
     #--------------------MOD-C40026-----------------(S)
      LET l_year = YEAR(g_gxk.gxk02)
      LET l_month = MONTH(g_gxk.gxk02)
      IF l_month = 1 THEN
         LET l_year =  -1
         LET l_month = 12
      ELSE
         LET l_month = l_month - 1
      END IF
      IF g_nmz.nmz20 = 'Y' THEN
         SELECT oox07 INTO l_nme.nme07
           FROM oox_file
          WHERE oox03 = g_gxk.gxk05
            AND oox01 = l_year
            AND oox02 = l_month
      ELSE
     #--------------------MOD-C40026-----------------(E)
        #LET l_nme.nme08=b_gxl.gxl13                                  #MOD-C40026 mark
         SELECT gxf25 INTO l_nme.nme07 FROM gxf_file 
          WHERE gxf011 = b_gxl.gxl03 
            AND gxfconf <> 'X'                          #MOD-CB0066 add
      END IF                                                       #MOD-C40026 add
      LET l_nme.nme08=l_nme.nme04 * l_nme.nme07                    #MOD-C40026 add
      CALL cl_digcut(l_nme.nme08,g_azi04) RETURNING l_nme.nme08    #MOD-C40026 add
      LET l_nme.nme10=g_gxk.gxkglno #付款傳票編號
      LET l_nme.nme12=g_gxk.gxk01   #付款單號
      SELECT nma02 INTO l_nme.nme13 FROM nma_file
       WHERE nma01=g_gxk.gxk06     #收支對象簡稱
       IF STATUS THEN LET l_nme.nme13=g_gxk.gxk06 END IF
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
        WHERE nmc01 = g_gxk.gxk24
       LET l_nme.nme16=g_gxk.gxk02  #會計日期
       LET l_nme.nme17=g_gxk.gxk01
       LET l_nme.nmeacti='Y'
       LET l_nme.nmeuser=g_user
       LET l_nme.nmegrup=g_grup
       LET l_nme.nmedate=TODAY
       LET t_azi04 = 0
       SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
        WHERE azi01 = nma10 AND nma01 = l_nme.nme01
       IF NOT cl_null(t_azi04) THEN
          CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
       END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '18'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal

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
 
       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          INSERT INTO nme_file VALUES(l_nme.*)
          CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
       END IF   #MOD-7B0123
   END IF
   IF p_flag ='2' THEN                   #定存解約
      #需增加存款的銀行
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk06   #存入銀行
      LET l_nme.nme02=g_gxk.gxk02   #收款日期
      LET l_nme.nme03=g_gxk.gxk22   #存入異動碼
      LET l_nme.nme04=b_gxl.gxl12
      LET l_nme.nme08=b_gxl.gxl14
      LET l_nme.nme07=g_gxk.gxk09   #匯率
      LET l_nme.nme10=g_gxk.gxkglno #收款傳票編號
      LET l_nme.nme12=g_gxk.gxk01   #收款單號
      SELECT nma02 INTO l_nme.nme13 FROM nma_file
        WHERE nma01=g_gxk.gxk05     #收支對象簡稱
        IF STATUS THEN LET l_nme.nme13=g_gxk.gxk05 END IF
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
        WHERE nmc01 = g_gxk.gxk22
       LET l_nme.nme16=g_gxk.gxk02  #會計日期
       LET l_nme.nme17=g_gxk.gxk01
       LET l_nme.nmeacti='Y'
       LET l_nme.nmeuser=g_user
       LET l_nme.nmegrup=g_grup
       LET l_nme.nmedate=TODAY
       LET t_azi04 = 0
       SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
        WHERE azi01 = nma10 AND nma01 = l_nme.nme01
       IF NOT cl_null(t_azi04) THEN
          CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
       END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '18'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal
 
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

       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          INSERT INTO nme_file VALUES(l_nme.*)
       END IF   #MOD-7B0123
       IF STATUS THEN 
          CALL s_errmsg("nme02",l_nme.nme02,"INS nme_file",SQLCA.sqlcode,1)      #No.FUN-710024
          LET g_success='N' END IF   #No:8677
 
      #需扣除存款的銀行
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk05   #扣款銀行
      LET l_nme.nme02=g_gxk.gxk02   #扣款日期
      LET l_nme.nme03=g_gxk.gxk24   #支出異動碼
      LET l_nme.nme04=b_gxl.gxl11
      LET l_nme.nme08=b_gxl.gxl13
      SELECT gxf25 INTO l_nme.nme07 FROM gxf_file  
       WHERE gxf011 = b_gxl.gxl03
         AND gxfconf <> 'X'                          #MOD-CB0066 add
      LET l_nme.nme10=g_gxk.gxkglno #付款傳票編號
      LET l_nme.nme12=g_gxk.gxk01   #付款單號
      SELECT nma02 INTO l_nme.nme13 FROM nma_file
        WHERE nma01=g_gxk.gxk06     #收支對象簡稱
        IF STATUS THEN LET l_nme.nme13=g_gxk.gxk06 END IF
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
        WHERE nmc01 = g_gxk.gxk24
       LET l_nme.nme16=g_gxk.gxk02  #會計日期
       LET l_nme.nme17=g_gxk.gxk01
       LET l_nme.nmeacti='Y'
       LET l_nme.nmeuser=g_user
       LET l_nme.nmegrup=g_grup
       LET l_nme.nmedate=TODAY
       LET t_azi04 = 0
       SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
        WHERE azi01 = nma10 AND nma01 = l_nme.nme01
       IF NOT cl_null(t_azi04) THEN
          CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
       END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '18'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal
 
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

       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          INSERT INTO nme_file VALUES(l_nme.*)
       END IF   #MOD-7B0123
      SELECT SUM(gxl15),SUM(gxl17),SUM(gxl18),SUM(gxl181)
        INTO l_gxl15,l_gxl17,l_gxl18,l_gxl181
        FROM gxl_file WHERE gxl01=g_gxk.gxk01 AND gxl02=b_gxl.gxl02    #No:8677
      LET l_nme.nme00=0
      LET l_nme.nme01=g_gxk.gxk06   #存入銀行
      LET l_nme.nme02=g_gxk.gxk02   #收款日期
      LET l_nme.nme03=g_gxk.gxk22   #存入異動碼
      LET l_nme.nme07=g_gxk.gxk09   #匯率
      IF l_nme.nme07 = 1 THEN
         LET l_nme.nme04=l_gxl17-l_gxl18
      ELSE
         LET l_nme.nme04=l_gxl15-l_gxl181   #*0.9   # Thomas 020207 020208 020227 No:7352改成直接輸入不會有差   #MOD-760041
      END IF
      LET l_nme.nme08=l_gxl17-l_gxl18
      LET l_nme.nme10=g_gxk.gxkglno #收款傳票編號
      LET l_nme.nme12=g_gxk.gxk01   #收款單號
      SELECT nma02 INTO l_nme.nme13 FROM nma_file
        WHERE nma01=g_gxk.gxk05     #收支對象簡稱
        IF STATUS THEN LET l_nme.nme13=g_gxk.gxk05 END IF
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
        WHERE nmc01 = g_gxk.gxk22
      LET l_nme.nme16=g_gxk.gxk02  #會計日期
      LET l_nme.nme17=g_gxk.gxk01
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET t_azi04 = 0
      SELECT azi04 INTO t_azi04 FROM azi_file, nma_file
       WHERE azi01 = nma10 AND nma01 = l_nme.nme01
      IF NOT cl_null(t_azi04) THEN
         CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04
      END IF
      LET l_nme.nme21 = b_gxl.gxl02
      LET l_nme.nme22 = '19'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = g_gxk.gxk05
 
      LET l_nme.nmelegal= g_legal
 
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

       IF l_nme.nme04 > 0 THEN   #MOD-7B0123
          INSERT INTO nme_file VALUES(l_nme.*)
          CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
       END IF   #MOD-7B0123
      IF STATUS THEN 
         CALL s_errmsg("nme02",l_nme.nme02,"INE nme_file",SQLCA.sqlcode,1)      #No.FUN-710024
         LET g_success='N' END IF   #No:8677
   END IF
END FUNCTION
 
FUNCTION t850_firm2()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000#No.FUN-670060 #No.FUN-680107 VARCHAR(1000)
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_gxl03  LIKE gxl_file.gxl03   #MOD-770012
   DEFINE l_gxfconf LIKE gxf_file.gxfconf   #MOD-770012
 
 
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
   IF g_gxk.gxkconf='N' THEN
      RETURN
   END IF
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gxk.gxk02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gxk.gxk01,'aap-176',1)
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_gxk.gxk01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gxk.gxkglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gxk.gxk01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_gxk.gxkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_gxk.gxkglno,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
   IF NOT cl_null(g_gxk.gxkglno) AND g_nmy.nmyglcr = 'N' THEN       #FUN-670060
       CALL cl_err(g_gxk.gxk01,'anm-230',1)
       RETURN
   END IF
   DECLARE gxl_curs_2 CURSOR FOR
     SELECT gxl03 FROM gxl_file WHERE gxl01=g_gxk.gxk01
   LET l_gxl03=''
   LET l_gxfconf=''
   FOREACH gxl_curs_2 INTO l_gxl03
      SELECT gxfconf INTO l_gxfconf FROM gxf_file
        WHERE gxf39 = l_gxl03
          AND gxfconf <> 'X'                          #MOD-CB0066 add
      IF l_gxfconf = 'Y' THEN
         CALL cl_err(g_gxk.gxk01,'anm-200',1)
         RETURN
      END IF
   END FOREACH

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxk.gxkglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT gxkglno INTO g_gxk.gxkglno FROM gxk_file
       WHERE gxk01 = g_gxk.gxk01
      IF NOT cl_null(g_gxk.gxkglno) THEN
         CALL cl_err(g_gxk.gxkglno,'aap-929',1)
         RETURN         
      END IF
      DISPLAY BY NAME g_gxk.gxkglno
   END IF
   #CHI-C90052 add end-----
 
   BEGIN WORK
   LET g_success='Y'
   LET g_gxk.gxkconf ='N'
   UPDATE gxk_file SET gxkconf = 'N' WHERE gxk01 = g_gxk.gxk01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","gxk_file",g_gxk.gxk01,"",SQLCA.sqlcode,"","upd gxkconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CALL s_showmsg_init()                #No.FUN-710024
   CALL t850_y2()
   CALL s_showmsg()                     #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_gxk.gxkconf ='N'
   ELSE
      ROLLBACK WORK
      LET g_gxk.gxkconf ='Y'
   END IF
   DISPLAY BY NAME g_gxk.gxkconf

   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxk.gxkglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT gxkglno INTO g_gxk.gxkglno FROM gxk_file
   #    WHERE gxk01 = g_gxk.gxk01
   #   DISPLAY BY NAME g_gxk.gxkglno
   #END IF
   #CHI-C90052 mark end-----
END FUNCTION
 
FUNCTION t850_y2()
   DECLARE t850_y2_c CURSOR FOR
      SELECT * FROM gxl_file WHERE gxl01=g_gxk.gxk01
   FOREACH t850_y2_c INTO b_gxl.*
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
      MESSAGE b_gxl.gxl02
      CALL t850_upd_gxf('z')
      CALL t850_rec_gxh()   #CHI-A50017 add 
   END FOREACH
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
   CALL t850_del_nme()
END FUNCTION
 
#CHI-A50017 add --start--
FUNCTION t850_rec_gxh()
  UPDATE gxh_file SET gxh13 = NULL
  #WHERE gxh01 = b_gxl.gxl04       #MOD-B40077 mark
   WHERE gxh011 = b_gxl.gxl03      #MOD-B40077
     AND gxh13 = g_gxk.gxk01
 IF SQLCA.SQLCODE THEN
     LET g_showmsg=b_gxl.gxl04,"/",g_gxk.gxk01 
     CALL s_errmsg("gxh01,gxh13",g_showmsg,"UPD gxh_file",SQLCA.sqlcode,1)
     LET g_success='N'
  END IF
END FUNCTION
#CHI-A50017 add --end--

FUNCTION t850_del_nme()
DEFINE l_nme24 LIKE nme_file.nme24   #FUN-730032
 
   IF g_aza.aza73 = 'Y' THEN #No.MOD-740346
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme17='",g_gxk.gxk01,"'"
      PREPARE del_nme24_p FROM g_sql
      DECLARE del_nme24_cs CURSOR FOR del_nme24_p
      FOREACH del_nme24_cs INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_gxk.gxk01,'anm-043',1)
            LET g_success='N'        #No.MOD-740346
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 IN
  (SELECT nme12 FROM nme_file 
    WHERE nme17 = g_gxk.gxk01)
   
   IF STATUS THEN 
      CALL cl_err3("del","tic_file",g_gxk.gxk01,"",STATUS,"","del tic:",1)
      LET g_success='N'
   END IF
   #FUN-B40056  --end
   END IF                 #No.TQC-B70021 
   DELETE FROM nme_file WHERE nme17=g_gxk.gxk01
   IF STATUS THEN
      CALL s_errmsg("nme17",g_gxk.gxk01,"DEL nme_file",SQLCA.sqlcode,1)     #No.FUN-710024
      LET g_success='N'
   END IF
END FUNCTION
 
 
FUNCTION t850_b(p_mod_seq)
DEFINE p_mod_seq       LIKE type_file.chr1,    #No.FUN-680107     VARCHAR(1) #修改次數 (0表開狀)
       l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
       l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680107 SMALLINT
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680107 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680107 VARCHAR(1)
       l_rate          LIKE tlf_file.tlf18,    #No.FUN-680107     DEC(12,3)
       l_day           LIKE type_file.num5,    #No.FUN-680107     SMALLINT
       l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680107 SMALLINT
       l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680107 SMALLINT
      #l_cnt           LIKE type_file.num5     #MOD-A10094 add  #CHI-A50017 mark
DEFINE l_oox07         LIKE oox_file.oox07     #MOD-C40026 add
DEFINE l_year          LIKE type_file.num5     #MOD-C40026 add
DEFINE l_month         LIKE type_file.num5     #MOD-C40026 add
DEFINE l_date1         LIKE gxk_file.gxk02     #MOD-C90253 add
DEFINE l_date2         LIKE gxk_file.gxk02     #MOD-C90253 add
 
   LET g_action_choice = ""
   IF s_anmshut(0) THEN RETURN END IF
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
  #FUN-B80125--(B mark)--
  #IF g_gxk.gxkconf='Y' THEN
  #   CALL cl_err('','axm-101',0)
  #   RETURN
  #END IF
  #FUN-B80125--(E mark)--
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf = 'Y' THEN
      CALL cl_err(g_gxk.gxk01,'anm-105',0)
      RETURN
   END IF
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err(g_gxk.gxk01,'9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
   IF g_gxk.gxk01 IS NULL THEN
      RETURN
   END IF
  #--------------------MOD-C40026-----------------(S)
   LET l_year = YEAR(g_gxk.gxk02)
   LET l_month = MONTH(g_gxk.gxk02)
   IF l_month = 1 THEN
      LET l_year =  -1
      LET l_month = 12
   ELSE
      LET l_month = l_month - 1
   END IF
   LET l_oox07 = 0   #TQC-C50064
   SELECT oox07 INTO l_oox07
     FROM oox_file
    WHERE oox03 = g_gxk.gxk05
      AND oox01 = l_year
      AND oox02 = l_month
  #TQC-C50064---S---
   IF cl_null(l_oox07) THEN
      LET l_oox07 = 0
   END IF
  #TQC-C50064---E---
  #--------------------MOD-C40026-----------------(E)
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gxl02,gxl03,gxl04,'','',gxl11,gxl13,gxl12,gxl14,",   #No:BUG-4C0155   #No.MOD-510073
                       "       gxl15,gxl17,gxl181,gxl18,gxl16",         
                              ",gxlud01,gxlud02,gxlud03,gxlud04,gxlud05,",
                              "gxlud06,gxlud07,gxlud08,gxlud09,gxlud10,",
                              "gxlud11,gxlud12,gxlud13,gxlud14,gxlud15",
                       " FROM gxl_file",    #No.MOD-510073   #FUN-6C0036
                      " WHERE gxl01=? AND gxl02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t850_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gxl WITHOUT DEFAULTS FROM s_gxl.*
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
           OPEN t850_cl USING g_gxk.gxk01                                                                                           
            IF STATUS THEN                                                                                                          
               CALL cl_err("OPEN t850_cl:", STATUS, 1)                                                                              
               CLOSE t850_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
            FETCH t850_cl INTO g_gxk.*            # 鎖住將被更改或取消的資料                                                        
            IF SQLCA.sqlcode THEN                                                                                                   
               CALL cl_err(g_gxk.gxk01,SQLCA.sqlcode,0)      # 資料被他人LOCK                                                       
               CLOSE t850_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gxl_t.* = g_gxl[l_ac].*  #BACKUP
            OPEN t850_bcl USING g_gxk.gxk01,g_gxl_t.gxl02
            IF STATUS THEN
               CALL cl_err("OPEN t850_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE   #No.TQC-960418 
            FETCH t850_bcl INTO g_gxl[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gxl_t.gxl02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            END IF  #No.TQC-960418 
            LET g_gxl[l_ac].date1 = g_gxl_t.date1
            LET g_gxl[l_ac].date2 = g_gxl_t.date2
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gxl[l_ac].* TO NULL      #900423
         LET g_gxl[l_ac].gxl11 = 0
         LET g_gxl[l_ac].gxl12 = 0
         LET g_gxl[l_ac].gxl13 = 0
         LET g_gxl[l_ac].gxl14 = 0
         LET g_gxl[l_ac].gxl15 = 0
         LET g_gxl[l_ac].gxl16 = 0
         LET g_gxl[l_ac].gxl17 = 0
         LET g_gxl[l_ac].gxl181= 0   #FUN-6C0036
         LET g_gxl[l_ac].gxl18 = 0
         LET g_gxl_t.* = g_gxl[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gxl02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gxl_file(gxl01,gxl02,gxl03,gxl04,gxl11,gxl12,gxl13,gxl14,
                              gxl15,gxl16,gxl17,gxl181,gxl18,gxl19,gxl20,gxl21   #FUN-6C0036
                             ,gxlud01,gxlud02,gxlud03, gxlud04,gxlud05,gxlud06,
                              gxlud07,gxlud08,gxlud09, gxlud10,gxlud11,gxlud12,
                              gxlud13,gxlud14,gxlud15,
                              gxllegal)                                    #FUN-980005 add legal 
              VALUES(g_gxk.gxk01,g_gxl[l_ac].gxl02,g_gxl[l_ac].gxl03,
                     g_gxl[l_ac].gxl04,g_gxl[l_ac].gxl11,g_gxl[l_ac].gxl12,
                     g_gxl[l_ac].gxl13,g_gxl[l_ac].gxl14,g_gxl[l_ac].gxl15,
                     g_gxl[l_ac].gxl16,g_gxl[l_ac].gxl17,g_gxl[l_ac].gxl181,g_gxl[l_ac].gxl18,   #FUN-6C0036
                     b_gxl.gxl19,b_gxl.gxl20,b_gxl.gxl21
                     ,g_gxl[l_ac].gxlud01, g_gxl[l_ac].gxlud02,
                      g_gxl[l_ac].gxlud03, g_gxl[l_ac].gxlud04,
                      g_gxl[l_ac].gxlud05, g_gxl[l_ac].gxlud06,
                      g_gxl[l_ac].gxlud07, g_gxl[l_ac].gxlud08,
                      g_gxl[l_ac].gxlud09, g_gxl[l_ac].gxlud10,
                      g_gxl[l_ac].gxlud11, g_gxl[l_ac].gxlud12,
                      g_gxl[l_ac].gxlud13, g_gxl[l_ac].gxlud14,
                      g_gxl[l_ac].gxlud15, g_legal)       
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gxl_file",g_gxk.gxk01,g_gxl[l_ac].gxl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD gxl02                        #default 序號
         IF g_gxl[l_ac].gxl02 IS NULL OR g_gxl[l_ac].gxl02 = 0 THEN
            SELECT max(gxl02)+1
              INTO g_gxl[l_ac].gxl02
              FROM gxl_file
             WHERE gxl01 = g_gxk.gxk01
            IF g_gxl[l_ac].gxl02 IS NULL THEN
               LET g_gxl[l_ac].gxl02 = 1
            END IF
         END IF
 
      AFTER FIELD gxl02                        #check 序號是否重複
         IF NOT cl_null(g_gxl[l_ac].gxl02) THEN
            IF g_gxl[l_ac].gxl02 != g_gxl_t.gxl02 OR g_gxl_t.gxl02 IS NULL THEN
               SELECT count(*) INTO l_n
                 FROM gxl_file
                WHERE gxl01 = g_gxk.gxk01
                  AND gxl02 = g_gxl[l_ac].gxl02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gxl[l_ac].gxl02 = g_gxl_t.gxl02
                  NEXT FIELD gxl02
               END IF
            END IF
         END IF
 
      BEFORE FIELD gxl03
         CALL t850_set_entry_b(p_cmd)
 
      AFTER FIELD gxl03
         IF NOT cl_null(g_gxl[l_ac].gxl03) AND
            (g_gxl[l_ac].gxl03 <> g_gxl_t.gxl03 OR g_gxl_t.gxl03 IS NULL) THEN   
            SELECT * INTO g_gxf.* 
              FROM gxf_file
             WHERE gxf011=g_gxl[l_ac].gxl03
               AND gxf35 =g_gxk.gxk08                   #CHI-C30094
               AND gxfacti = 'Y'                        #MOD-C60072 add
               AND gxf11 NOT IN ('3','4')               #MOD-C60072 add
               AND gxfconf = 'Y'                        #MOD-C60072 add
               AND gxf27 < gxf021                       #MOD-C60072 add
            IF STATUS THEN
               CALL cl_err3("sel","gxf_file",g_gxl[l_ac].gxl03,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxf02 <> g_gxk.gxk05 THEN
               CALL cl_err('','anm-904',0)
               NEXT FIELD gxl03
            END IF
           #IF g_gxf.gxf11='3' THEN                      #MOD-8C0114  #No.CHI-A40024 mark
           #------------------------------MOD-C20160--------------------start
           #IF g_gxf.gxf11='1' OR g_gxf.gxf11='3' THEN         #No.CHI-A40024
           #   CALL cl_err('','anm-624',0)
           #   NEXT FIELD gxl03
           #END IF
            IF g_gxf.gxf11 = '1' THEN
               CALL cl_err('','anm-616',0)
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxf11 = '3' THEN
               CALL cl_err('','anm-618',0)
               NEXT FIELD gxl03
            END IF
           #------------------------------MOD-C20160----------------------end
            IF g_gxf.gxf27 >= g_gxf.gxf021 THEN     #已還款!
               CALL cl_err('','aap-712',0)
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxfconf='N' THEN              #未確認
               CALL cl_err('','aap-141',0)
               NEXT FIELD gxl03
            END IF
           #CHI-A50017 mark --start--
           ##str MOD-A10094 add
           ##檢查是否已做過最後一期暫估利息的沖銷(檢查anmt840),若沒有不允許繼續輸入
           # LET l_cnt = 0
           # SELECT COUNT(*) INTO l_cnt FROM gxh_file
           #  WHERE gxh13 IS NULL AND gxh011=g_gxl[l_ac].gxl03
           # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           # IF l_cnt > 0 THEN
           #    CALL cl_err('','anm-850',0)
           #    NEXT FIELD gxl03
           # END IF
           ##end MOD-A10094 add
           #CHI-A50017 mark --end--
            IF g_gxf.gxf04='1'  THEN  #月付
              #--------------------------------MOD-C90253-----------------------(S)
              #LET g_gxl[l_ac].date1=MDY(MONTH(g_gxf.gxf05),1,YEAR(g_gxf.gxf05))
               SELECT MAX(gxh05) INTO l_date1 FROM gxh_file
                WHERE gxh011 = g_gxl[l_ac].gxl03
               SELECT MAX(gxj06) INTO l_date2
                 FROM gxj_file,gxi_file
                WHERE gxj031 = g_gxl[l_ac].gxl03
                  AND gxj01 = gxi01
                  AND gxiconf <> 'X'
                CASE
                  WHEN (l_date1 IS NULL AND l_date2 IS NOT NULL)
                    LET l_date2 = l_date2 + 1
                    LET g_gxl[l_ac].date1 = l_date2
                  WHEN (l_date1 IS NOT NULL AND l_date2 IS NULL)
                    LET l_date1 = l_date1 + 1
                    LET g_gxl[l_ac].date1 = l_date1
                  WHEN (l_date1 IS NULL AND l_date2 IS NULL)
                    SELECT gxf03 INTO l_date1 FROM gxf_file
                    #WHERE gxf01 = g_gxl[l_ac].gxl03               #MOD-CA0015 mark
                     WHERE gxf011 = g_gxl[l_ac].gxl03              #MOD-CA0015 add
                       AND gxfconf <> 'X'                          #MOD-CB0066 add
                    LET l_date1 = l_date1 + 1
                    LET g_gxl[l_ac].date1 = l_date1
                  WHEN (l_date1 = l_date2)
                    LET l_date1 = l_date1 + 1
                    LET g_gxl[l_ac].date1 = l_date1
                  OTHERWISE
                    IF l_date1 > l_date2 THEN
                       LET l_date1 = l_date1 + 1
                       LET g_gxl[l_ac].date1 = l_date1
                    ELSE
                       LET l_date2 = l_date2 + 1
                       LET g_gxl[l_ac].date1 = l_date2
                    END IF
                END CASE
              #--------------------------------MOD-C90253-----------------------(E)
            ELSE                #到期整付
               LET g_gxl[l_ac].date1=g_gxf.gxf03
            END IF
            LET g_gxl[l_ac].date2=g_gxf.gxf05
            LET g_gxl[l_ac].gxl11 = g_gxf.gxf021
           #IF g_nmz.nmz20 = 'Y' THEN                                    #MOD-C40026 add  #TQC-C50064 mark
            IF g_nmz.nmz20 = 'Y' AND l_oox07 > 0 THEN                    #TQC-C50064
               LET g_gxl[l_ac].gxl13 = g_gxl[l_ac].gxl11 * l_oox07       #MOD-C40026 add
            ELSE                                                         #MOD-C40026 add
               LET g_gxl[l_ac].gxl13 = g_gxf.gxf26
            END IF                                                       #MOD-C40026 add
            LET l_day = g_gxl[l_ac].date2 - g_gxl[l_ac].date1 + 1
            LET g_gxl[l_ac].gxl04=g_gxf.gxf01
            DISPLAY BY NAME g_gxl[l_ac].date2
            DISPLAY BY NAME g_gxl[l_ac].gxl04
            #-- 原幣利息=貸款金額*(利率/100/365)*天數 -----------
            IF cl_null(g_gxl[l_ac].gxl15) OR p_cmd <> 'u'
               OR g_gxl_t.gxl03 <> g_gxl[l_ac].gxl03 THEN  #No.7352
               IF g_gxf.gxf04 ='1' THEN   #月付
                 #IF g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣                           #CHI-A10014 mark
                  IF g_aza.aza26 <> '0' OR g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣     #CHI-A10014 add
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(DAY(g_gxf.gxf05)-1)*   #MOD-730110
                                             g_gxf.gxf06/100/360
                  ELSE                                 #本幣
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(DAY(g_gxf.gxf05)-1)*   #MOD-730110
                                             g_gxf.gxf06/100/365
                  END IF
               ELSE
                 #IF g_gxk.gxk04 <> g_aza.aza17 THEN    #外幣                          #CHI-A10014 mark
                  IF g_aza.aza26 <> '0' OR g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣     #CHI-A10014 add
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(g_gxf.gxf05-g_gxf.gxf03)*
                                             g_gxf.gxf06/100/360
                  ELSE
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(g_gxf.gxf05-g_gxf.gxf03)*
                                             g_gxf.gxf06/100/365
                  END IF
               END IF
               IF g_gxl[l_ac].gxl15 < 0 THEN                                 #MOD-CA0015 add
                  LET g_gxl[l_ac].gxl15 = 0                                  #MOD-CA0015 add
               END IF                                                        #MOD-CA0015 add
               #-- 本幣利息=原幣利息*Ex.Rate
               LET g_gxl[l_ac].gxl17 = g_gxl[l_ac].gxl15 * g_gxk.gxk09
               IF g_gxl[l_ac].gxl17 < 0 THEN                                 #MOD-CA0015 add
                  LET g_gxl[l_ac].gxl17 = 0                                  #MOD-CA0015 add
               END IF                                                        #MOD-CA0015 add
               IF g_gxl[l_ac].gxl17 > g_nmz.nmz56 THEN
                  LET g_gxl[l_ac].gxl181 = g_gxl[l_ac].gxl15 * g_nmz.nmz57/100
                  LET g_gxl[l_ac].gxl18 = g_gxl[l_ac].gxl181 * g_gxk.gxk09
               ELSE
                  LET g_gxl[l_ac].gxl181= 0   #FUN-6C0036
                  LET g_gxl[l_ac].gxl18 = 0
               END IF
            END IF #No.7352
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxk.gxk04   #MOD-710175
            CALL cl_digcut(g_gxl[l_ac].gxl11,t_azi04) RETURNING g_gxl[l_ac].gxl11
            CALL cl_digcut(g_gxl[l_ac].gxl13,g_azi04) RETURNING g_gxl[l_ac].gxl13
            #no.A010依幣別取位
            CALL cl_digcut(g_gxl[l_ac].gxl15,t_azi04) RETURNING g_gxl[l_ac].gxl15
            CALL cl_digcut(g_gxl[l_ac].gxl17,g_azi04) RETURNING g_gxl[l_ac].gxl17
            CALL cl_digcut(g_gxl[l_ac].gxl181,t_azi04) RETURNING g_gxl[l_ac].gxl181   #FUN-6C0036
            CALL cl_digcut(g_gxl[l_ac].gxl18,g_azi04) RETURNING g_gxl[l_ac].gxl18
            DISPLAY BY NAME g_gxl[l_ac].gxl11
            DISPLAY BY NAME g_gxl[l_ac].gxl13
            DISPLAY BY NAME g_gxl[l_ac].gxl15
            DISPLAY BY NAME g_gxl[l_ac].gxl17
            DISPLAY BY NAME g_gxl[l_ac].gxl181   #FUN-6C0036
            DISPLAY BY NAME g_gxl[l_ac].gxl18
         END IF
         CALL t850_set_no_entry_b(p_cmd)
 
      AFTER FIELD gxl04               #可用定存單號帶資料
         IF NOT cl_null(g_gxl[l_ac].gxl04) THEN
            SELECT * INTO g_gxf.* FROM gxf_file          #怕同一張定存單有續存狀況
              WHERE gxf01=g_gxl[l_ac].gxl04 AND gxf27=0
                AND gxf35 =g_gxk.gxk08                   #CHI-C30094
                AND gxfconf <> 'X'                          #MOD-CB0066 add
            IF STATUS THEN
               CALL cl_err3("sel","gxf_file",g_gxl[l_ac].gxl04,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
               NEXT FIELD gxl04
            END IF
           #IF g_gxf.gxf11='3' THEN                      #MOD-8C0114  #No.CHI-A40024 mark
           #------------------------------MOD-C20160--------------------start
           #IF g_gxf.gxf11='1' OR g_gxf.gxf11='3' THEN         #No.CHI-A40024
           #   CALL cl_err('','anm-624',0)
           #   NEXT FIELD gxl03
           #END IF
            IF g_gxf.gxf11 = '1' THEN
               CALL cl_err('','anm-616',0)
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxf11 = '3' THEN
               CALL cl_err('','anm-618',0)
               NEXT FIELD gxl03
            END IF
           #------------------------------MOD-C20160----------------------end
            IF g_gxf.gxf27 >= g_gxf.gxf021 THEN     #已還款!
               CALL cl_err('','aap-712',0)
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxfconf='N' THEN              #未確認
               CALL cl_err('','aap-141',0)
               NEXT FIELD gxl03
            END IF
            IF g_gxf.gxf04='1'  THEN  #月付
               LET g_gxl[l_ac].date1=MDY(MONTH(g_gxf.gxf05),1,YEAR(g_gxf.gxf05))
            ELSE                #到期整付
               LET g_gxl[l_ac].date1=g_gxf.gxf03
            END IF
            LET g_gxl[l_ac].date2=g_gxf.gxf05
            LET g_gxl[l_ac].gxl11 = g_gxf.gxf021
           #IF g_nmz.nmz20 = 'Y' THEN                                    #MOD-C40026 add  #TQC-C50064 mark
            IF g_nmz.nmz20 = 'Y' AND l_oox07 > 0 THEN                    #TQC-C50064
               LET g_gxl[l_ac].gxl13 = g_gxl[l_ac].gxl11 * l_oox07       #MOD-C40026 add
            ELSE                                                         #MOD-C40026 add
               LET g_gxl[l_ac].gxl13 = g_gxf.gxf26
            END IF                                                       #MOD-C40026 add   
            LET l_day = g_gxl[l_ac].date2 - g_gxl[l_ac].date1 + 1
            LET g_gxl[l_ac].gxl03=g_gxf.gxf011
            #-- 原幣利息=貸款金額*(利率/100/365)*天數 -----------
            IF cl_null(g_gxl[l_ac].gxl15) OR p_cmd <> 'u'
               OR g_gxl_t.gxl03 <> g_gxl[l_ac].gxl03 THEN   #No.7352
               IF g_gxf.gxf04 ='1' THEN   #月付
                 #IF g_gxk.gxk04 <> g_aza.aza17 THEN    #外幣                           #CHI-A10014 mark
                  IF g_aza.aza26 <> '0' OR g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣     #CHI-A10014 add
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(DAY(g_gxf.gxf05)-1)*   #MOD-730110
                                             g_gxf.gxf06/100/360
                  ELSE                                 #本幣
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(DAY(g_gxf.gxf05)-1)*   #MOD-730110
                                             g_gxf.gxf06/100/365
                  END IF
               ELSE
                 #IF g_gxk.gxk04 <> g_aza.aza17 THEN    #外幣                          #CHI-A10014 mark
                  IF g_aza.aza26 <> '0' OR g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣     #CHI-A10014 add
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(g_gxf.gxf05-g_gxf.gxf03)*
                                             g_gxf.gxf06/100/360
                  ELSE
                     LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*(g_gxf.gxf05-g_gxf.gxf03)*
                                             g_gxf.gxf06/100/365
                  END IF
               END IF
               IF g_gxl[l_ac].gxl15 < 0 THEN                                 #MOD-CA0015 add
                  LET g_gxl[l_ac].gxl15 = 0                                  #MOD-CA0015 add
               END IF                                                        #MOD-CA0015 add
               #-- 本幣利息=原幣利息*Ex.Rate
               LET g_gxl[l_ac].gxl17 = g_gxl[l_ac].gxl15 * g_gxk.gxk09
               IF g_gxl[l_ac].gxl17 < 0 THEN                                 #MOD-CA0015 add
                  LET g_gxl[l_ac].gxl17 = 0                                  #MOD-CA0015 add
               END IF                                                        #MOD-CA0015 add
               IF g_gxl[l_ac].gxl17 > g_nmz.nmz56 THEN
                  LET g_gxl[l_ac].gxl181 = g_gxl[l_ac].gxl15 * g_nmz.nmz57/100
                  LET g_gxl[l_ac].gxl18 = g_gxl[l_ac].gxl181 * g_gxk.gxk09
               ELSE
                  LET g_gxl[l_ac].gxl181 = 0   #FUN-6C0036
                  LET g_gxl[l_ac].gxl18 = 0
               END IF
            END IF #No.7352
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxk.gxk04   #MOD-710175
            CALL cl_digcut(g_gxl[l_ac].gxl11,t_azi04) RETURNING g_gxl[l_ac].gxl11
            CALL cl_digcut(g_gxl[l_ac].gxl13,g_azi04) RETURNING g_gxl[l_ac].gxl13
            #依幣別取位
            CALL cl_digcut(g_gxl[l_ac].gxl15,t_azi04) RETURNING g_gxl[l_ac].gxl15
            CALL cl_digcut(g_gxl[l_ac].gxl17,g_azi04) RETURNING g_gxl[l_ac].gxl17
            CALL cl_digcut(g_gxl[l_ac].gxl181,t_azi04) RETURNING g_gxl[l_ac].gxl181   #FUN-6C0036
            CALL cl_digcut(g_gxl[l_ac].gxl18,g_azi04) RETURNING g_gxl[l_ac].gxl18
            DISPLAY BY NAME g_gxl[l_ac].gxl11
            DISPLAY BY NAME g_gxl[l_ac].gxl13
            DISPLAY BY NAME g_gxl[l_ac].gxl15
            DISPLAY BY NAME g_gxl[l_ac].gxl17
            DISPLAY BY NAME g_gxl[l_ac].gxl181   #FUN-6C0036
            DISPLAY BY NAME g_gxl[l_ac].gxl18
         END IF
 
      AFTER FIELD date2
        #IF g_gxk.gxk04 <> g_aza.aza17 THEN    #外幣                          #CHI-A10014 mark
         IF g_aza.aza26 <> '0' OR g_gxk.gxk04 <>g_aza.aza17 THEN    #外幣     #CHI-A10014 add
            LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*   
                                    g_gxf.gxf06/100/360*
                                    (g_gxl[l_ac].date2-g_gxl[l_ac].date1)
         ELSE                                 #本幣
            LET g_gxl[l_ac].gxl15 = g_gxf.gxf021*
                                    g_gxf.gxf06/100/365*
                                    (g_gxl[l_ac].date2-g_gxl[l_ac].date1)
         END IF
         IF g_gxl[l_ac].gxl15 < 0 THEN                                 #MOD-CA0015 add
            LET g_gxl[l_ac].gxl15 = 0                                  #MOD-CA0015 add
         END IF                                                        #MOD-CA0015 add
         LET g_gxl[l_ac].gxl17 = g_gxl[l_ac].gxl15 * g_gxk.gxk09
         IF g_gxl[l_ac].gxl17 < 0 THEN                                 #MOD-CA0015 add
            LET g_gxl[l_ac].gxl17 = 0                                  #MOD-CA0015 add
         END IF                                                        #MOD-CA0015 add
         IF g_gxl[l_ac].gxl17 > g_nmz.nmz56 THEN
            LET g_gxl[l_ac].gxl181 = g_gxl[l_ac].gxl15 * g_nmz.nmz57/100   
            LET g_gxl[l_ac].gxl18 = g_gxl[l_ac].gxl181 * g_gxk.gxk09   
         ELSE
            LET g_gxl[l_ac].gxl181= 0   
            LET g_gxl[l_ac].gxl18 = 0
         END IF
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxk.gxk04        #MOD-710175
         CALL cl_digcut(g_gxl[l_ac].gxl15,t_azi04) RETURNING g_gxl[l_ac].gxl15
         CALL cl_digcut(g_gxl[l_ac].gxl17,g_azi04) RETURNING g_gxl[l_ac].gxl17
         CALL cl_digcut(g_gxl[l_ac].gxl181,t_azi04) RETURNING g_gxl[l_ac].gxl181   #FUN-6C0036
         CALL cl_digcut(g_gxl[l_ac].gxl18,g_azi04) RETURNING g_gxl[l_ac].gxl18
         DISPLAY BY NAME g_gxl[l_ac].gxl15,g_gxl[l_ac].gxl17,
                         g_gxl[l_ac].gxl18,g_gxl[l_ac].gxl181
 
      AFTER FIELD gxl11
         CALL cl_digcut(g_gxl[l_ac].gxl11,t_azi04) RETURNING g_gxl[l_ac].gxl11
         DISPLAY BY NAME g_gxl[l_ac].gxl11
 
      BEFORE FIELD gxl12
         IF g_gxl[l_ac].gxl12 = 0 OR g_gxl[l_ac].gxl12 IS NULL THEN
            LET g_gxl[l_ac].gxl12 = g_gxl[l_ac].gxl11
            CALL cl_digcut(g_gxl[l_ac].gxl12,t_azi04) RETURNING g_gxl[l_ac].gxl12
            DISPLAY BY NAME g_gxl[l_ac].gxl12
         END IF
 
      AFTER FIELD gxl12
         IF g_gxl[l_ac].gxl12 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl12,'anm-041',0)
            NEXT FIELD gxl12
         END IF 
         CALL cl_digcut(g_gxl[l_ac].gxl12,t_azi04) RETURNING g_gxl[l_ac].gxl12
         LET g_gxl[l_ac].gxl14=g_gxl[l_ac].gxl12*g_gxk.gxk09
         CALL cl_digcut(g_gxl[l_ac].gxl14,g_azi04) RETURNING g_gxl[l_ac].gxl14
         DISPLAY BY NAME g_gxl[l_ac].gxl12
         DISPLAY BY NAME g_gxl[l_ac].gxl14
 
      AFTER FIELD gxl14
         IF g_gxl[l_ac].gxl14 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl14,'anm-041',0)
            NEXT FIELD gxl14
         END IF 
         CALL cl_digcut(g_gxl[l_ac].gxl14,g_azi04) RETURNING g_gxl[l_ac].gxl14
         LET g_gxl[l_ac].gxl16=(g_gxl[l_ac].gxl14-g_gxl[l_ac].gxl13)
         CALL cl_digcut(g_gxl[l_ac].gxl16,g_azi04) RETURNING g_gxl[l_ac].gxl16
         DISPLAY BY NAME g_gxl[l_ac].gxl14
         DISPLAY BY NAME g_gxl[l_ac].gxl16
 
      AFTER FIELD gxl15
         IF g_gxl[l_ac].gxl15 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl15,'anm-041',0)
            NEXT FIELD gxl15
         END IF 
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gxk.gxk04   #MOD-710175
         CALL cl_digcut(g_gxl[l_ac].gxl15,t_azi04) RETURNING g_gxl[l_ac].gxl15   #MOD-710175
         LET g_gxl[l_ac].gxl17=g_gxl[l_ac].gxl15* g_gxk.gxk09
         CALL cl_digcut(g_gxl[l_ac].gxl17,g_azi04) RETURNING g_gxl[l_ac].gxl17
         IF g_gxl[l_ac].gxl17 > g_nmz.nmz56 THEN
            LET g_gxl[l_ac].gxl181 = g_gxl[l_ac].gxl15 * g_nmz.nmz57/100
            CALL cl_digcut(g_gxl[l_ac].gxl181,t_azi04) RETURNING g_gxl[l_ac].gxl181
            LET g_gxl[l_ac].gxl18 = g_gxl[l_ac].gxl181 * g_gxk.gxk09
            CALL cl_digcut(g_gxl[l_ac].gxl18,g_azi04) RETURNING g_gxl[l_ac].gxl18
         ELSE
            LET g_gxl[l_ac].gxl181 = 0   #FUN-6C0036
            LET g_gxl[l_ac].gxl18 = 0
         END IF
         DISPLAY BY NAME g_gxl[l_ac].gxl15
         DISPLAY BY NAME g_gxl[l_ac].gxl17
         DISPLAY BY NAME g_gxl[l_ac].gxl181   #FUN-6C0036
         DISPLAY BY NAME g_gxl[l_ac].gxl18
 
      AFTER FIELD gxl16
         CALL cl_digcut(g_gxl[l_ac].gxl16,g_azi04) RETURNING g_gxl[l_ac].gxl16
         DISPLAY BY NAME g_gxl[l_ac].gxl16
 
      AFTER FIELD gxl17
         IF g_gxl[l_ac].gxl17 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl17,'anm-041',0)
            NEXT FIELD gxl17
         END IF 
         CALL cl_digcut(g_gxl[l_ac].gxl17,g_azi04) RETURNING g_gxl[l_ac].gxl17
         DISPLAY BY NAME g_gxl[l_ac].gxl17
 
      AFTER FIELD gxl181
         IF g_gxl[l_ac].gxl181 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl181,'anm-041',0)
            NEXT FIELD gxl181
         END IF 
         CALL cl_digcut(g_gxl[l_ac].gxl181,t_azi04) RETURNING g_gxl[l_ac].gxl181
         DISPLAY BY NAME g_gxl[l_ac].gxl181
 
      AFTER FIELD gxl18
         IF g_gxl[l_ac].gxl18 < 0 THEN
            CALL cl_err(g_gxl[l_ac].gxl18,'anm-041',0)
            NEXT FIELD gxl18
         END IF 
         CALL cl_digcut(g_gxl[l_ac].gxl18,g_azi04) RETURNING g_gxl[l_ac].gxl18
         DISPLAY BY NAME g_gxl[l_ac].gxl18
 
        AFTER FIELD gxlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_gxl_t.gxl02 > 0 AND g_gxl_t.gxl02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gxl_file
             WHERE gxl01 = g_gxk.gxk01
               AND gxl02 = g_gxl_t.gxl02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gxl_file",g_gxk.gxk01,g_gxl_t.gxl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            CALL t850_b_tot()
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gxl[l_ac].* = g_gxl_t.*
            CLOSE t850_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gxl[l_ac].gxl02,-263,1)
            LET g_gxl[l_ac].* = g_gxl_t.*
         ELSE
            UPDATE gxl_file SET gxl02 = g_gxl[l_ac].gxl02,
                                gxl03 = g_gxl[l_ac].gxl03,
                                gxl04 = g_gxl[l_ac].gxl04,
                                gxl11 = g_gxl[l_ac].gxl11,
                                gxl12 = g_gxl[l_ac].gxl12,
                                gxl13 = g_gxl[l_ac].gxl13,
                                gxl14 = g_gxl[l_ac].gxl14,
                                gxl15 = g_gxl[l_ac].gxl15,
                                gxl16 = g_gxl[l_ac].gxl16,
                                gxl17 = g_gxl[l_ac].gxl17,
                                gxl181 = g_gxl[l_ac].gxl181,   #FUN-6C0036
                                gxl18 = g_gxl[l_ac].gxl18,
                                gxl19 = b_gxl.gxl19,
                                 gxl20 = b_gxl.gxl20,   #No.MOD-510073
                                 gxl21 = b_gxl.gxl21    #No.MOD-510073
                               ,gxlud01 = g_gxl[l_ac].gxlud01,
                                gxlud02 = g_gxl[l_ac].gxlud02,
                                gxlud03 = g_gxl[l_ac].gxlud03,
                                gxlud04 = g_gxl[l_ac].gxlud04,
                                gxlud05 = g_gxl[l_ac].gxlud05,
                                gxlud06 = g_gxl[l_ac].gxlud06,
                                gxlud07 = g_gxl[l_ac].gxlud07,
                                gxlud08 = g_gxl[l_ac].gxlud08,
                                gxlud09 = g_gxl[l_ac].gxlud09,
                                gxlud10 = g_gxl[l_ac].gxlud10,
                                gxlud11 = g_gxl[l_ac].gxlud11,
                                gxlud12 = g_gxl[l_ac].gxlud12,
                                gxlud13 = g_gxl[l_ac].gxlud13,
                                gxlud14 = g_gxl[l_ac].gxlud14,
                                gxlud15 = g_gxl[l_ac].gxlud15
                            
             WHERE gxl01=g_gxk.gxk01
               AND gxl02=g_gxl_t.gxl02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gxl_file",g_gxk.gxk01,g_gxl_t.gxl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_gxl[l_ac].* = g_gxl_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac    #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gxl[l_ac].* = g_gxl_t.*
           #FUN-D30032--add--str--
            ELSE
               CALL g_gxl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D30032--add--end--
            END IF
            CLOSE t850_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30032 add
         CLOSE t850_bcl
         COMMIT WORK
         CALL t850_b_tot()
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gxl02) AND l_ac > 1 THEN
            LET g_gxl[l_ac].* = g_gxl[l_ac-1].*
            LET g_gxl[l_ac].gxl02 = NULL   #TQC-620018
            NEXT FIELD gxl02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION input_other_data
        #IF g_gxk.gxk20='3' THEN               #MOD-C20065 mark
         IF g_gxk.gxk20='3' AND l_ac > 0 THEN  #MOD-C20065
            CALL t850_b_more()
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gxl03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gxf02"              #MOD-710051
               LET g_qryparam.default1 = g_gxl[l_ac].gxl03
               LET g_qryparam.default2 = g_gxl[l_ac].gxl04
               LET g_qryparam.arg1 = g_gxk.gxk05   #MOD-670127
               LET g_qryparam.where = " gxf35 = '",g_gxk.gxk08,"'"      #CHI-C30094
               CALL cl_create_qry() RETURNING g_gxl[l_ac].gxl03,g_gxl[l_ac].gxl04
                 DISPLAY BY NAME g_gxl[l_ac].gxl03       #No.MOD-490344
                 DISPLAY BY NAME g_gxl[l_ac].gxl04       #No.MOD-490344
               NEXT FIELD gxl03
            WHEN INFIELD(gxl04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gxf02"               #MOD-710051
               LET g_qryparam.default1 = g_gxl[l_ac].gxl03
               LET g_qryparam.default2 = g_gxl[l_ac].gxl04
               LET g_qryparam.arg1 = g_gxk.gxk05   #MOD-670127
               LET g_qryparam.where = " gxf35 = '",g_gxk.gxk08,"'"      #CHI-C30094
               CALL cl_create_qry() RETURNING g_gxl[l_ac].gxl03,g_gxl[l_ac].gxl04
                 DISPLAY BY NAME g_gxl[l_ac].gxl03       #No.MOD-490344
                 DISPLAY BY NAME g_gxl[l_ac].gxl04       #No.MOD-490344
               NEXT FIELD gxl04
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END INPUT
   CALL t850_b_tot()
 
   CLOSE t850_bcl
   COMMIT WORK
   CALL t850_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t850_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_gxk.gxk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM gxk_file ",
                  "  WHERE gxk01 LIKE '",l_slip,"%' ",
                  "    AND gxk01 > '",g_gxk.gxk01,"'"
      PREPARE i850_pb1 FROM l_sql 
      EXECUTE i850_pb1 INTO l_cnt      
      
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
         #CALL t850_x() #FUN-D20035 mark
         CALL t850_x(1) #FUN-D20035 add
         IF g_gxk.gxkconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=11 AND npp01=g_gxk.gxk01 AND npp011=0
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=11 AND npq01=g_gxk.gxk01 AND npq011=0
         DELETE FROM tic_file WHERE tic04 = g_gxk.gxk01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM gxk_file WHERE gxk01 = g_gxk.gxk01
         INITIALIZE g_gxk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t850_b_tot()
   #DEFINE l_tot1,l_tot2  LIKE type_file.num20_6                                    #No.FUN-680107  DEC(20,6) #No.FUN-4C0010   #FUN-6C0036
   DEFINE l_tot1,l_tot2,l_tot3,l_tot4  LIKE type_file.num20_6                       #No.FUN-680107  DEC(20,6) #No.FUN-4C0010   #FUN-6C0036
   SELECT SUM(gxl11),SUM(gxl12),SUM(gxl13),SUM(gxl14),SUM(gxl16),       
          SUM(gxl15),SUM(gxl17),SUM(gxl181),SUM(gxl18)   #FUN-6C0036
     INTO g_gxk.gxk11,g_gxk.gxk12,g_gxk.gxk13,g_gxk.gxk14,g_gxk.gxk16,   
          l_tot1 ,l_tot2 ,l_tot3 ,l_tot4  #FUN-6C0036
     FROM gxl_file
    WHERE gxl01 = g_gxk.gxk01
   IF STATUS THEN
      CALL cl_err3("sel","gxl_file",g_gxk.gxk01,"",STATUS,"","sel sum(gxl11-17):",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   IF g_gxk.gxk11 IS NULL THEN
      LET g_gxk.gxk11 = 0
   END IF
   IF g_gxk.gxk12 IS NULL THEN
      LET g_gxk.gxk12 = 0
   END IF
   IF g_gxk.gxk13 IS NULL THEN
      LET g_gxk.gxk13 = 0
   END IF
   IF g_gxk.gxk14 IS NULL THEN
      LET g_gxk.gxk14 = 0
   END IF
   IF g_gxk.gxk16 IS NULL THEN
      LET g_gxk.gxk16 = 0
   END IF
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=g_gxk.gxk04   #MOD-710175
   CALL cl_digcut(g_gxk.gxk11,t_azi05) RETURNING g_gxk.gxk11
   CALL cl_digcut(g_gxk.gxk12,t_azi05) RETURNING g_gxk.gxk12
   CALL cl_digcut(g_gxk.gxk13,g_azi05) RETURNING g_gxk.gxk13
   CALL cl_digcut(g_gxk.gxk14,g_azi05) RETURNING g_gxk.gxk14
   CALL cl_digcut(g_gxk.gxk16,g_azi05) RETURNING g_gxk.gxk16
   DISPLAY BY NAME g_gxk.gxk11,g_gxk.gxk12,g_gxk.gxk13,g_gxk.gxk14,g_gxk.gxk16
   UPDATE gxk_file SET gxk11 = g_gxk.gxk11,
                       gxk12 = g_gxk.gxk12,
                       gxk13 = g_gxk.gxk13,
                       gxk14 = g_gxk.gxk14,
                       gxk16 = g_gxk.gxk16
    WHERE gxk01=g_gxk.gxk01
   IF cl_null(l_tot1) THEN
      LET l_tot1 = 0
   END IF
   IF cl_null(l_tot2) THEN
      LET l_tot2 = 0
   END IF
   IF cl_null(l_tot3) THEN
      LET l_tot3 = 0
   END IF
   IF cl_null(l_tot4) THEN
      LET l_tot4 = 0
   END IF
   CALL cl_digcut(l_tot1,t_azi05) RETURNING l_tot1
   CALL cl_digcut(l_tot2,g_azi05) RETURNING l_tot2
   CALL cl_digcut(l_tot3,t_azi05) RETURNING l_tot3
   CALL cl_digcut(l_tot4,g_azi05) RETURNING l_tot4
   DISPLAY l_tot1,l_tot2,l_tot3,l_tot4 TO tot1,tot2,tot3,tot4
END FUNCTION
 
FUNCTION t850_b_askkey()
DEFINE
   l_wc2  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT g_wc2 ON gxl02,gxl03
           FROM s_gxl[1].gxl02,s_gxl[1].gxl03
 
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
   CALL t850_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t850_b_fill(p_wc2)       #BODY FILL UP
DEFINE
   p_wc2  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT gxl02,gxl03,gxl04,'','',",
                "       gxl11,gxl13,gxl12,gxl14,gxl15,gxl17,gxl181,gxl18,gxl16 ",   #No.MOD-4C0155 12,13互換   #FUN-6C0036   
                ",gxlud01,gxlud02,gxlud03,gxlud04,gxlud05,",
                "gxlud06,gxlud07,gxlud08,gxlud09,gxlud10,",
                "gxlud11,gxlud12,gxlud13,gxlud14,gxlud15", 
               " FROM gxl_file",
               " WHERE gxl01 ='",g_gxk.gxk01,"'",
               " ORDER BY gxl02"
   PREPARE t850_pb FROM g_sql
   DECLARE gxl_curs CURSOR FOR t850_pb
 
   CALL g_gxl.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH gxl_curs INTO g_gxl[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_gxf.* TO NULL
      SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011=g_gxl[g_cnt].gxl03
         AND gxfconf <> 'X'                          #MOD-CB0066 add
      LET g_gxl[g_cnt].date2=g_gxf.gxf05
      IF g_gxf.gxf04='1'  THEN  #月付
         LET g_gxl[g_cnt].date1=MDY(MONTH(g_gxf.gxf05),1,YEAR(g_gxf.gxf05))
      ELSE                #到期整付
         LET g_gxl[g_cnt].date1=g_gxf.gxf03
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gxl.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t850_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gxl TO s_gxl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t850_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t850_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t850_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t850_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t850_fetch('L')
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
        #CALL cl_set_field_pic(g_gxk.gxkconf,"","","","","")     #FUN-B80125 mark
        #FUN-B80125--(B)--
         IF g_gxk.gxkconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_gxk.gxkconf,"","","",g_void,"")
        #FUN-B80125--(E)--
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION gen_entry_sheet
         LET g_action_choice="gen_entry_sheet"
         EXIT DISPLAY
      ON ACTION maintain_entry_sheet
         LET g_action_choice="maintain_entry_sheet"
         EXIT DISPLAY
      ON ACTION maintain_entry_sheet2
         LET g_action_choice="maintain_entry_sheet2"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
     #FUN-B80125--(B)-- 
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
     #FUN-B80125--(E)-- 
     #FUN-D20035 add str
      ON ACTION undo_void   #取消作廢
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
        EXIT DISPLAY  #TQC-5B0076
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
     ON ACTION related_document                #No.FUN-6A0011  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t850_g_gl(p_trno,p_npptype)  #No.FUN-680088
   DEFINE p_npptype      LIKE npp_file.npptype   #No.FUN-680088
   DEFINE p_trno         LIKE type_file.chr20    #No.FUN-680107 VARCHAR(20)
   DEFINE l_buf          LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(70)
   DEFINE l_n            LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_t            LIKE oay_file.oayslip,  #NO.FUN-680107 VARCHAR(05) #No.FUN-550057
          l_nmydmy3      LIKE nmy_file.nmydmy3
 
   LET g_success = 'Y'  #No.FUN-680088
   SELECT * INTO g_gxk.* FROM gxk_file WHERE gxk01 = g_gxk.gxk01
   IF p_trno IS NULL THEN
      RETURN
   END IF
   IF g_gxk.gxkconf='Y' THEN
      CALL cl_err(g_gxk.gxk01,'anm-232',0)
      LET g_success = 'N'  #No.FUN-680088
      RETURN
   END IF
  #FUN-B80125--(B)--
   IF g_gxk.gxkconf='X' THEN
      CALL cl_err(g_gxk.gxk01,'9024',0)
      RETURN
   END IF
  #FUN-B80125--(E)--
   IF NOT cl_null(g_gxk.gxkglno) THEN
      CALL cl_err(g_gxk.gxk01,'aap-122',1)
      LET g_success = 'N'  #No.FUN-680088
      RETURN
   END IF
   #-->立帳日期不可小於關帳日期
   IF g_gxk.gxk02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gxk.gxk01,'aap-176',1)
      LET g_success = 'N'  #No.FUN-680088
      RETURN
   END IF
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)     #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN
      LET l_nmydmy3 = 'N'
   END IF
   IF l_nmydmy3 = 'N' THEN
      LET g_success = 'N'  #No.FUN-680088
      RETURN
   END IF
 
   IF p_npptype = '0' THEN #No.FUN-680088
      SELECT COUNT(*) INTO l_n FROM npq_file
             WHERE npqsys='NM' AND npq00=11 AND npq01=p_trno AND npq011=0
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
         #FUN-B40056--add--end--
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=11 AND npq01=p_trno AND npq011=0
      END IF
   END IF         #No.FUN-680088
   INITIALIZE g_npp.* TO NULL
   LET g_npp.npptype=p_npptype  #No.FUN-680088
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =11
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_gxk.gxk02
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
      UPDATE npp_file SET npp02=g_npp.npp02
       WHERE nppsys='NM' AND npp00=11 AND npp01=p_trno AND npp011=0
         AND npptype=p_npptype  #No.FUN-680088
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","npp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         LET g_success = 'N'  #No.FUN-680088
         RETURN
      END IF
   END IF
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp:",1)  #No.FUN-660148
      LET g_success = 'N'  #No.FUN-680088
      RETURN
   END IF
   CALL t850_g_gl_1(p_trno,p_npptype)
   CALL t850_gen_diff()  #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t850_g_gl_1(p_trno,p_npqtype)        #No.FUN-680088
   DEFINE p_npqtype     LIKE npq_file.npqtype #No.FUN-680088
   DEFINE p_trno        LIKE alk_file.alk01
   DEFINE l_gxl         RECORD LIKE gxl_file.*
   DEFINE amt1,amt2,amt3,amt4  LIKE type_file.num20_6 #NO.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE l_gxl15       LIKE gxl_file.gxl15
   DEFINE l_gxl17       LIKE gxl_file.gxl17
   DEFINE l_gxl181      LIKE gxl_file.gxl181   #FUN-6C0036
   DEFINE l_gxl18       LIKE gxl_file.gxl18
   DEFINE l_nma05       LIKE nma_file.nma05
   DEFINE l_nma10       LIKE nma_file.nma10
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_gxf02       LIKE gxf_file.gxf02,
          l_gxl11       LIKE gxl_file.gxl11,  #MOD-610057
          l_gxl13       LIKE gxl_file.gxl13,  #No:7350
          l_gxh11       LIKE gxh_file.gxh11,
          l_gxh12       LIKE gxh_file.gxh12
   DEFINE l_aaa03       LIKE aaa_file.aaa03   #FUN-A40067
   DEFINE l_azi04_2     LIKE azi_file.azi04   #FUN-A40067
   DEFINE l_flag        LIKE type_file.chr1   #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqtype= p_npqtype  #No.FUN-680088
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02  = 0
   LET g_npq.npq24  = g_gxk.gxk04   #MOD-610057
   LET g_npq.npq25  = g_gxk.gxk09
   LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
   SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
    WHERE azi01=g_gxk.gxk04
 
#定存到期應產生之分錄如下:
#借  定期存款(本金+利息+暫估利息-所得稅)
#      貸  銀行存款(本金)
#          應收利息(暫估利息)
#          利息收入(利息)
#          應付所得稅(所得稅)
 
   #------------------------------------------------ Dr:定期存款
   IF p_npqtype = '0' THEN
      SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk06
   ELSE
      SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk06
   END IF
   IF STATUS=100 OR cl_null(g_npq.npq03) THEN    #找不到才取參數
      IF p_npqtype = '0' THEN
         SELECT nms68 INTO g_npq.npq03 FROM nms_file
          WHERE (nms01 = ' ' OR nms01 IS NULL)
      ELSE
         SELECT nms681 INTO g_npq.npq03 FROM nms_file
          WHERE (nms01 = ' ' OR nms01 IS NULL)
      END IF
   END IF
   LET g_npq.npq02 = g_npq.npq02+1
   LET g_npq.npq06 = '1'
   #原幣應收利息(gxl15),本幣應收利息(gxl17),原幣所得稅(gxl181),本幣所得稅(gxl18)
   SELECT SUM(gxl15),SUM(gxl17),SUM(gxl181),SUM(gxl18)
     INTO l_gxl15,l_gxl17,l_gxl181,l_gxl18
     FROM gxl_file WHERE gxl01=g_gxk.gxk01
   IF cl_null(l_gxl15)  THEN LET l_gxl15 = 0 END IF
   IF cl_null(l_gxl17)  THEN LET l_gxl17 = 0 END IF
   IF cl_null(l_gxl18)  THEN LET l_gxl18 = 0 END IF
   IF cl_null(l_gxl181) THEN LET l_gxl181= 0 END IF   #FUN-6C0036
 
#CHI-A50017 add --start--
 #暫估原幣利息,暫估本幣利息
  SELECT SUM(gxh11),SUM(gxh12) INTO l_gxh11,l_gxh12
    FROM gxh_file
   WHERE gxh13 IS NULL
    #AND gxh01 IN (SELECT gxl04 FROM gxl_file WHERE gxl01=g_gxk.gxk01)  #MOD-B40077 mark
     AND gxh011 IN (SELECT gxl03 FROM gxl_file WHERE gxl01=g_gxk.gxk01) #MOD-B40077
  IF cl_null(l_gxh11) THEN LET l_gxh11 = 0 END IF
  IF cl_null(l_gxh12) THEN LET l_gxh12 = 0 END IF
#CHI-A50017 add --end--

   IF g_gxk.gxk20 != '3' THEN
     #本幣=本金+利息-所得稅+暫估利息
     #       ps.利息=應收利息-暫估利息   #MOD-B30135 add
     #LET g_npq.npq07 = g_gxk.gxk14+l_gxl17-l_gxl18               #MOD-930127  #MOD-A10097 mod #CHI-A50017 mark
     #LET g_npq.npq07f= g_gxk.gxk12+l_gxl15-l_gxl181 #FUN-6C0036  #MOD-930127  #MOD-A10097 mod #CHI-A50017 mark
     #LET g_npq.npq07 = g_gxk.gxk14+l_gxl17-l_gxl18 +l_gxh12   #CHI-A50017
     #LET g_npq.npq07f= g_gxk.gxk12+l_gxl15-l_gxl181+l_gxh11   #CHI-A50017
      LET g_npq.npq07 = g_gxk.gxk14+(l_gxl17-l_gxh12)-l_gxl18 +l_gxh12   #CHI-A50017   #MOD-B30135 mod
      LET g_npq.npq07f= g_gxk.gxk12+(l_gxl15-l_gxh11)-l_gxl181+l_gxh11   #CHI-A50017   #MOD-B30135 mod
   ELSE   #3.到期續存
     #本幣=利息-所得稅                                   #MOD-C70308到期續存不包含暫估利息
     #LET g_npq.npq07 = l_gxl17-l_gxl18                #MOD-930127  #MOD-A10097 mod  #CHI-A50017 mark
     #LET g_npq.npq07f= l_gxl15-l_gxl181  #FUN-6C0036  #MOD-930127  #MOD-A10097 mod  #CHI-A50017 mark
     #LET g_npq.npq07 = l_gxl17 - l_gxl18 + l_gxh12      #CHI-A50017 #MOD-C70308 mark
     #LET g_npq.npq07f= l_gxl15 - l_gxl181 + l_gxh11     #CHI-A50017 #MOD-C70308 mark
      LET g_npq.npq07 = l_gxl17 - l_gxl18                #MOD-C70308 add
      LET g_npq.npq07f= l_gxl15 - l_gxl181               #MOD-C70308 add
   END IF
   CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f
   CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-610057
   CALL s_get_bookno(YEAR(g_gxk.gxk02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_gxk.gxk02,'aoo-081',1)
   END IF
   IF p_npqtype = '0' THEN
      LET g_bookno3=g_bookno1
   ELSE
      LET g_bookno3=g_bookno2
   END IF
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   LET g_npq.npq04=NULL #FUN-D10065
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
    RETURNING  g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
   IF p_npqtype = '1' THEN
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
   END IF                                     #No.MOD-B80173 add
   IF STATUS THEN
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
   END IF
   IF g_gxk.gxk20 = '3' THEN   #3.到期續存
      IF p_npqtype = '0' THEN
        #SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk06    #MOD-770012 #MOD-C70308 mark
         SELECT nma05 INTO g_npq.npq03                                          #MOD-C70308 add
           FROM nma_file                                                        #MOD-C70308 add
          WHERE nma01 = g_gxk.gxk05                                             #MOD-C70308 add
      ELSE
        #SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk06   #MOD-770012 #MOD-C70308 mark
         SELECT nma051 INTO g_npq.npq03                                         #MOD-C70308 add
           FROM nma_file                                                        #MOD-C70308 add
          WHERE nma01 = g_gxk.gxk05                                             #MOD-C70308 add
      END IF
      IF STATUS=100 OR cl_null(g_npq.npq03) THEN    #找不到才取參數
         IF p_npqtype = '0' THEN
            SELECT nms68 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
         ELSE
            SELECT nms681 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
         END IF
      END IF
      LET g_npq.npq02 = g_npq.npq02+1
      LET g_npq.npq06 = '1'
      LET g_npq.npq24 = g_gxk.gxk04    #MOD-610057
      LET g_npq.npq25 = g_gxk.gxk09
      LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
      LET g_npq.npq07 = g_gxk.gxk14    #本幣=本金
      LET g_npq.npq07f= g_gxk.gxk12    #原幣=本金
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-610057
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-610057
      LET g_npq.npq04=NULL #FUN-D10065
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
       RETURNING  g_npq.*
 
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
      END IF                                     #No.MOD-B80173 add
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
      END IF
   END IF
   #------------------------------------------------ Dr:所得稅
   IF l_gxl18<>0 THEN                     #No:7350 不是每筆都有所得稅
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nmz.nmz58
      ELSE
         LET g_npq.npq03 = g_nmz.nmz581
      END IF
      LET g_npq.npq06 = '1'
     #anmt840與anmt850對所得稅分錄的處理應一致,
     #目前anmt840的所得稅幣別是計帳幣別,將MOD-610057修改調整回原先做法
      LET g_npq.npq24 = g_gxk.gxk04   #MOD-A10093 mod 
      LET g_npq.npq25 = g_gxk.gxk09   #MOD-A10093 mod
      LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
      LET g_npq.npq07 = l_gxl18              #代扣所得稅
      LET g_npq.npq07f= l_gxl181      #MOD-A10093 mod
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f   #MOD-710175
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-610057
      LET g_npq.npq04=NULL #FUN-D10065
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
       RETURNING  g_npq.*
 
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
      END IF                                     #No.MOD-B80173 add
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
      END IF
   END IF
   #--------- NO:0088 ------------------------------- Cr:銀行存款(本金)
   LET g_npq.npq06 = '2'
   DECLARE t850_g_gl_c1 CURSOR FOR
    SELECT gxf02,SUM(gxl12),SUM(gxl13) FROM gxl_file,gxf_file      #No:7350
     WHERE gxl01=g_gxk.gxk01
       AND gxfconf <> 'X'                          #MOD-CB0066 add
       AND gxl03=gxf011   #MOD-760121
     GROUP BY gxf02 ORDER By gxf02
   FOREACH t850_g_gl_c1 INTO l_gxf02,l_gxl11,l_gxl13    #No:7350   #MOD-610057
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk05   #MOD-670127
      ELSE
         SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxk.gxk05   #MOD-670127
      END IF
      IF STATUS=100 OR cl_null(g_npq.npq03) THEN
         IF p_npqtype = '0' THEN
            LET g_npq.npq03 = g_nms.nms68
         ELSE
            LET g_npq.npq03 = g_nms.nms681
         END IF
      END IF   #TQC-630216
      LET g_npq.npq07f= l_gxl11
      LET g_npq.npq24 = g_gxk.gxk04
      LET g_npq.npq25 = l_gxl13/l_gxl11
      LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
      CALL cl_digcut(g_npq.npq25,t_azi07) RETURNING g_npq.npq25
      LET g_npq.npq07 = l_gxl13                                    #No:7350
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-610057
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-610057
      LET g_npq.npq04=NULL #FUN-D10065
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
       RETURNING  g_npq.*
 
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
      END IF                                     #No.MOD-B80173 add
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
      END IF
   END FOREACH
   #------------------------------------------------ Cr:利息收入(本期利息)
   LET g_npq.npq02 = g_npq.npq02+1
   IF p_npqtype = '0' THEN
      LET g_npq.npq03 = g_nms.nms70
   ELSE
      LET g_npq.npq03 = g_nms.nms701
   END IF
   LET g_npq.npq24 = g_gxk.gxk04
   LET g_npq.npq25 = g_gxk.gxk09
   LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
  #str MOD-B30135 add
   #利息收入金額應扣除暫估利息
   IF l_gxh11 > 0 OR l_gxh12 > 0 THEN
     #IF g_gxk.gxk20 != '3' THEN               #No.MOD-B80173 add #MOD-C70308 mark
      LET g_npq.npq07f= l_gxl15-l_gxh11
      LET g_npq.npq07 = l_gxl17-l_gxh12
     #ELSE                                     #No.MOD-B80173 add #MOD-C70308 mark
     #   LET g_npq.npq07f= l_gxl15             #No.MOD-B80173 add #MOD-C70308 mark
     #   LET g_npq.npq07 = l_gxl17             #No.MOD-B80173 add #MOD-C70308 mark
     #END IF                                   #No.MOD-B80173 add #MOD-C70308 mark
   ELSE
  #end MOD-B30135 add
      LET g_npq.npq07f= l_gxl15
      LET g_npq.npq07 = l_gxl17
   END IF   #MOD-B30135 add
   IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
   IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07 = 0 END IF
   CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f
   CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
   LET g_npq.npq04=NULL #FUN-D10065
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
    RETURNING  g_npq.*
 
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
   IF p_npqtype = '1' THEN
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
   END IF                                     #No.MOD-B80173 add
   IF STATUS THEN
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
   END IF
#CHI-A50017 add --start--
  #------------------------------------------------ Cr:應收利息(暫估利息)
  SELECT SUM(gxh11),SUM(gxh12) INTO l_gxh11,l_gxh12
    FROM gxh_file
   WHERE gxh13 IS NULL
    #AND gxh01 IN (SELECT gxl04 FROM gxl_file WHERE gxl01=g_gxk.gxk01)  #MOD-B40077 mark
     AND gxh011 IN (SELECT gxl03 FROM gxl_file WHERE gxl01=g_gxk.gxk01) #MOD-B40077
  IF cl_null(l_gxh11) THEN LET l_gxh11 = 0 END IF
  IF cl_null(l_gxh12) THEN LET l_gxh12 = 0 END IF
  IF l_gxh11 > 0 OR l_gxh12 > 0 THEN
     LET g_npq.npq02 = g_npq.npq02+1
     IF p_npqtype = '0' THEN
        LET g_npq.npq03 = g_nms.nms71
     ELSE
        LET g_npq.npq03 = g_nms.nms711
     END IF
     LET g_npq.npq24 = g_gxk.gxk04
     LET g_npq.npq25 = g_gxk.gxk09
     LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
     LET g_npq.npq07f= l_gxh11
     LET g_npq.npq07 = l_gxh12
     IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
     IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07 = 0 END IF
     CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f
     CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07 
     LET g_npq.npq04=NULL #FUN-D10065
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)
      RETURNING  g_npq.*
     
     CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
#No.FUN-9A0036 --Begin
     IF p_npqtype = '1' THEN
        CALL s_newrate(g_bookno1,g_bookno2,
                       g_npq.npq24,g_npq25,g_npp.npp02)
        RETURNING g_npq.npq25
        LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
     ELSE
        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
     END IF
#No.FUN-9A0036 --End
     IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
     END IF                                     #No.MOD-B80173 add
     IF STATUS THEN
        CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d3:",1)
     END IF
  END IF
#CHI-A50017 add --end--
   #------------------------------------------------ Cr:Diff-匯差
   IF g_gxk.gxk16 <> 0 THEN
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nms.nms12
      ELSE
         LET g_npq.npq03 = g_nms.nms121
      END IF
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f= 0
      LET g_npq.npq07 = g_gxk.gxk16
      IF g_npq.npq07 < 0 THEN
         IF p_npqtype = '0' THEN
            LET g_npq.npq03 = g_nms.nms13
         ELSE
            LET g_npq.npq03 = g_nms.nms131
         END IF
         LET g_npq.npq06 = '1'
         LET g_npq.npq07 = g_npq.npq07 * -1
      END IF
     CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
     LET g_npq.npq24=g_aza.aza17
     LET g_npq.npq25=1
     LET g_npq25      = g_npq.npq25   #No.FUN-9A0036
     LET g_npq.npq04=NULL #FUN-D10065
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
       RETURNING  g_npq.*
 
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      IF g_npq.npq07 > '0' THEN                  #No.MOD-B80173 add
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
      END IF                                     #No.MOD-B80173 add
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
      END IF
   END IF
   LET g_npq.npq14 = ' '
   LET g_npq.npq05 = ' '
END FUNCTION
 
FUNCTION t850_b_more()
  DEFINE  l_flag      LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          p_row,p_col LIKE type_file.num5    #No.FUN-680107 SMALLINT
  #DEFINE ls_tmp      STRING                 #MOD-AC0155 mark
   DEFINE l_gxl11     LIKE gxl_file.gxl11    #MOD-B90225 add
   DEFINE l_gxl15     LIKE gxl_file.gxl15    #MOD-B90225 add
 
   LET p_row = 3 LET p_col = 3
 
 
   OPEN WINDOW t8501_w AT p_row,p_col WITH FORM "anm/42f/anmt8501"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt8501")
 
 
   SELECT gxl19,gxl20,gxl21 INTO b_gxl.gxl19,b_gxl.gxl20,b_gxl.gxl21
     FROM gxl_file
    WHERE gxl01=g_gxk.gxk01 AND gxl02=g_gxl[l_ac].gxl02
   IF STATUS THEN
      LET b_gxl.gxl19=' '
      LET b_gxl.gxl20=' '
      LET b_gxl.gxl21=''
   END IF                   #No:8677
   DISPLAY b_gxl.gxl19 TO gxl19
   DISPLAY b_gxl.gxl20 TO gxl20
   DISPLAY b_gxl.gxl21 TO gxl21
 
   INPUT BY NAME b_gxl.gxl19,b_gxl.gxl20,b_gxl.gxl21 WITHOUT DEFAULTS
 
      BEFORE FIELD gxl21                    #定存金額
         IF cl_null(b_gxl.gxl21) THEN
            SELECT gxf021 INTO b_gxl.gxl21 FROM gxf_file
             WHERE gxf011=g_gxl[l_ac].gxl03
               AND gxfconf <> 'X'                          #MOD-CB0066 add
            DISPLAY BY NAME b_gxl.gxl21
         END IF
 
      AFTER FIELD gxl21                    #定存金額
         IF b_gxl.gxl21 <= 0 THEN
            CALL cl_err('','mfg9243',1)
            NEXT FIELD gxl21
         END IF
        #--------------------------MOD-B90225--------------------start
         SELECT gxl11,gxl15 INTO l_gxl11,l_gxl15
           FROM gxl_file
          WHERE gxl01 = g_gxk.gxk01
            AND gxl02 = g_gxl[l_ac].gxl02                                       #MOD-C20065 add
        #IF b_gxl.gxl21 <> l_gxl11 AND b_gxl.gxl21 <> l_gxl11 + l_gxl15 THEN    #MOD-C90199 mark
         IF b_gxl.gxl21 > l_gxl11 + l_gxl15 THEN                                #MOD-C90199 add
            CALL cl_err('','anm-813',1)
            NEXT FIELD gxl21
         END IF
        #--------------------------MOD-B90225--------------------end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
         IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         UPDATE gxl_file
            SET gxl19 = b_gxl.gxl19,
                gxl20 = b_gxl.gxl20,
                gxl21 = b_gxl.gxl21
          WHERE gxl01=g_gxk.gxk01
            AND gxl02=g_gxl[l_ac].gxl02
         IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","gxl_file",g_gxk.gxk01,g_gxl[l_ac].gxl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
         ELSE
             MESSAGE 'UPDATE O.K'
         END IF
         LET l_flag = 'N'
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
   CLOSE WINDOW t8501_w                 #結束畫面
  #LET g_prog = ls_tmp        #MOD-AC0155 mark
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
END FUNCTION
 
FUNCTION t850_out()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,    #No.FUN-680107  VARCHAR(3000)
          sr        RECORD
                    gxk01     LIKE gxk_file.gxk01,
                    gxk20     LIKE gxk_file.gxk20,
                    gxk02     LIKE gxk_file.gxk02,
                    gxk04     LIKE gxk_file.gxk04,
                    gxk24     LIKE gxk_file.gxk24,
                    gxk05     LIKE gxk_file.gxk05,
                    gxk06     LIKE gxk_file.gxk06,
                    gxk08     LIKE gxk_file.gxk08,
                    gxk07     LIKE gxk_file.gxk07,
                    gxk09     LIKE gxk_file.gxk09,
                    gxk10     LIKE gxk_file.gxk10,
                    gxk22     LIKE gxk_file.gxk22,
                    gxk19     LIKE gxk_file.gxk19,
                    gxkconf   LIKE gxk_file.gxkconf,
                    gxkglno   LIKE gxk_file.gxkglno,
                    gxl02     LIKE gxl_file.gxl02,
                    gxl03     LIKE gxl_file.gxl03,
                    gxl04     LIKE gxl_file.gxl04,
                    gxl11     LIKE gxl_file.gxl11,
                    gxl13     LIKE gxl_file.gxl13,
                    gxl12     LIKE gxl_file.gxl12,
                    gxl14     LIKE gxl_file.gxl14,
                    gxl15     LIKE gxl_file.gxl15,
                    gxl17     LIKE gxl_file.gxl17,
                    gxl181    LIKE gxl_file.gxl181,   #FUN-6C0036
                    gxl18     LIKE gxl_file.gxl18,
                    gxl16     LIKE gxl_file.gxl16
                    END RECORD
   DEFINE           l_nma02_1 LIKE nma_file.nma02
   DEFINE           l_nma02   LIKE nma_file.nma02
   DEFINE           l_nml02   LIKE nml_file.nml02
   DEFINE           l_gxf03   LIKE gxf_file.gxf03
   DEFINE           l_gxf04   LIKE gxf_file.gxf04
   DEFINE           l_gxf05   LIKE gxf_file.gxf05
   DEFINE           l_date1   LIKE type_file.dat
   DEFINE           l_date2   LIKE type_file.dat
 
     LET g_wc=" gxk01='",g_gxk.gxk01,"'"   #MOD-B10059
     CALL cl_del_data(l_table)      #No.FUN-830145
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmt850'  #No.FUN-830145     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql=" SELECT gxk01,gxk20,gxk02,gxk04,gxk24,gxk05,gxk06,",
               "        gxk08,gxk07,gxk09,gxk10,gxk22,gxk19,gxkconf,gxkglno,",
               "        gxl02,gxl03,gxl04,gxl11,gxl13,gxl12,gxl14,",
               "        gxl15,gxl17,gxl181,gxl18,gxl16",                         #FUN-6C0036  
               " FROM gxk_file,gxl_file",
               " WHERE gxk01=gxl01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
     PREPARE t850_p FROM l_sql
     DECLARE t850_c CURSOR FOR t850_p
     LET g_pageno=0
     FOREACH t850_c INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_nml02 = ''
       SELECT nma02 INTO l_nma02_1 FROM nma_file
          WHERE nma01=sr.gxk05
       SELECT nma02 INTO l_nma02 FROM nma_file
          WHERE nma01=sr.gxk06
       SELECT nml02 INTO l_nml02 FROM nml_file
          WHERE nml01=sr.gxk19
 
       SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #No.FUN-870151       
          WHERE azi01 = sr.gxk04
       
       LET l_gxf03='' LET l_gxf04='' LET l_gxf05=''
       SELECT gxf03,gxf04,gxf05 INTO l_gxf03,l_gxf04,l_gxf05 FROM gxf_file
          WHERE gxf011=sr.gxl03
          AND gxfconf <> 'X'                          #MOD-CB0066 add
       IF l_gxf04='1' THEN
          LET l_date1 = MDY(MONTH(l_gxf05),1,YEAR(l_gxf05))
       ELSE
          LET l_date1 = l_gxf03
       END IF
       LET l_date2 = l_gxf05
       
       EXECUTE insert_prep USING
          sr.gxk01,sr.gxk06,sr.gxk22,sr.gxk02,l_nma02,sr.gxk19,sr.gxk04,
          sr.gxk08,l_nml02,sr.gxk24,sr.gxkconf,sr.gxk05,sr.gxk09,sr.gxkglno,
          l_nma02_1,sr.gxk10,sr.gxk20,sr.gxk07,sr.gxl02,sr.gxl03,l_date1,
          sr.gxl11,sr.gxl12,sr.gxl15,sr.gxl181,l_date2,sr.gxl04,sr.gxl13,
          sr.gxl14,sr.gxl17,sr.gxl16,sr.gxl18,t_azi04,t_azi05 
          ,t_azi07                                                           #No.FUN-870151    
     END FOREACH
 
     LET l_sql = "SELECT *FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'gxk01,gxk20,gxk02,gxk05,gxk09,gxk04,gxk24,gxk06,
                         gxk08,gxk07,gxk22,gxk19,gxkconf,gxkglno,gxk10,
                         gxk101,gxl02,gxl03,gxl04
                         ,gxkuser,gxkgrup,gxkmodu,gxkdate,gxkacti')            #TQC-960086
       #RETURNING g_wc                                                         #MOD-A80143 mark
        RETURNING l_str                                                        #MOD-A80143
       #LET l_str = g_wc                                                       #MOD-A80143 mark
     END IF
     
     LET l_str = l_str,";",g_azi04,";",g_azi05 
     
     CALL cl_prt_cs3('anmt850','anmt850',l_sql,l_str)                     
 
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
 
END FUNCTION
 
FUNCTION t850_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gxk01",TRUE)   #MOD-580384
    END IF
 
END FUNCTION
 
FUNCTION t850_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gxk01",FALSE)    #MOD-580384
    END IF
 
END FUNCTION
 
FUNCTION t850_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF INFIELD(gxl03) THEN
      CALL cl_set_comp_entry("gxl04,date1",TRUE)   #MOD-880007 add date1
    END IF
 
END FUNCTION
 
FUNCTION t850_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF INFIELD(gxl03) THEN
       IF NOT cl_null(g_gxl[l_ac].gxl03) THEN
          CALL cl_set_comp_entry("gxl04",FALSE)
       END IF
       #當計息方式gxf04為1.月付時,起息日date1不可輸入
       IF g_gxf.gxf04='1' THEN
          CALL cl_set_comp_entry("date1",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t850_gen_glcr(p_gxk,p_nmy)
  DEFINE p_gxk     RECORD LIKE gxk_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxk.gxk01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t850_g_gl(p_gxk.gxk01,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t850_g_gl(p_gxk.gxk01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t850_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gxk.gxkglno) OR g_gxk.gxkglno IS NOT NULL THEN
       CALL cl_err(g_gxk.gxkglno,'aap-618',1)
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxk.gxk01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxk.gxkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxk.gxkglno,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088
       CALL cl_err(g_gxk.gxk01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_gxk.gxk01,'" AND npp011 = 0'
    LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxk.gxk02,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT gxkglno INTO g_gxk.gxkglno FROM gxk_file
     WHERE gxk01 = g_gxk.gxk01
    DISPLAY BY NAME g_gxk.gxkglno
    
END FUNCTION
 
FUNCTION t850_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      STRING
  DEFINE l_dbs      STRING
 
    IF cl_null(g_gxk.gxkglno) OR g_gxk.gxkglno IS NULL THEN
       CALL cl_err(g_gxk.gxkglno,'aap-619',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxk.gxk01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gxk.gxkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gxk.gxkglno,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxk.gxkglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT gxkglno INTO g_gxk.gxkglno FROM gxk_file
     WHERE gxk01 = g_gxk.gxk01
    DISPLAY BY NAME g_gxk.gxkglno
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t850_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_gxk.gxk02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_gxk.gxk02,'aoo-081',1)
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
         IF l_npq1.npq07 > '0' THEN                 #No.MOD-B80173 add
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
         END IF                                     #No.MOD-B80173 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
         END IF
      END IF
   END IF
END FUNCTION
#FUN-A40033 --End
#No.FUN-9C0073 -----------------By chenls 10/01/15
#Patch....NO.MOD-5A0095 <001,002,003,004,005,006,007,008,009,010,011> #
#Patch....NO.TQC-610036 <001,002> #

