# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt740.4gl
# Descriptions...: 還息付款作業
# Date & Author..: 97/03/20 By paul
# Modify ........: 99/05/10 By kammy 傳票拋轉作業移到anmp400
#                                    還原傳票作業移到anmp409
# Modify.........: No:7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No:8041 03/10/15 By Kitty 已產生支票號碼不可作3.應付票據還原
# Modify.........: No:8024 03/10/15 By Kitty nne_file,nng_file未確認不可作anmt740
# Modify.........: No:7354 03/10/28 By Kitty nnj08改成dec(7,4)
# Modify.........: No:8664 03/11/11 By Kitty 若幣別為本幣,則不產生匯差
# Modify.........: No:8614 03/12/10 By Kitty 增加update最後還息日期
# Modify.........: No:6703 03/12/10 By Kitty 銀行類別可以修改,但活存不可改為支存
# Modify.........: No:8609 04/01/05 By Kitty 依回轉不回轉判斷科目
# Modify.........: No:9078 04/01/29 By Kitty 配合融資修改
# Modify.........: No.MOD-470467 04/07/21 By Mandy 單身輸入完融資單號,無帶出其基本資料如動用日期/利率等
# Modify.........: No.MOD-470477 04/08/20 By Nicola 單身單據號碼開窗查詢短借或長貸的單號
# Modify.........: No.MOD-4B0157 04/11/17 By Nicola 若無每月利息暫估資料，則單身的融資/合約單號可隨便打
# Modify.........: No.FUN-4B0008 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-510048 05/01/19 By Kitty 產生分錄底稿有錯誤訊息
# Modify.........: No.MOD-510038 05/01/21 By Kitty nmf05/nmf06 取值邏輯應同 anmp500/anmt750
# Modify.........: No.FUN-4C0098 05/02/24 By pengu 報表轉XML
# Modify.........: No.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: No.MOD-560177 05/07/07 By Nicola 行數828,AND nneconf ='Y'要改成AND nngconf ='Y'
# Modify.........: No.MOD-580031 05/08/04 By Dido 還息項目為中長貸時修改利息之起算日與結算日後，利息天數重新計算
# Modify.........: No.MOD-580030 05/08/10 By Dido 取消暫估金額為0檢核
# Modify.........: No.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5B0236 05/11/22 By Smapmin 單身自動帶入時,止算天數帶錯,應該帶anmt730的止算天數
# Modify.........: No.MOD-5B0181 05/12/01 By Smapmin nmz52 若為NULL,等同於為N的作法
# Modify.........: No.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-5C0128 06/01/20 By Smapmin 單身輸入單據編號條件CHECK修改
# Modify.........: No.MOD-5C0142 05/01/20 By Smapmin 單身修改利率,其實付金額沒有重算
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.MOD-640073 06/04/08 By Sarah 將銀存異動碼(nni22)請改為必KEY欄位,以免收支帳錯誤
# Modify.........: No.MOD-640409 06/04/20 By Smapmin 單身金額計算有誤
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/08/02 By Xufeng 新增“直接拋轉總帳”功能                                                             
# Modify.........: No.TQC-680080 06/08/22 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680088 06/08/28 By day 多帳套修改
# Modify.........: No.FUN-680107 06/09/18 By Hellen 欄位類型修改
# Modify.........: No.MOD-680099 06/10/16 By Smapmin 有跨月的情況時,才去CHECK是否存在暫估資料
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
#                                         1744行上的l_azi04 改成 t_azi04 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6C0158 06/12/26 By rainy 利息費用的原幣寫入錯誤
# Modify.........: No.FUN-710024 07/02/05 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-730102 07/03/21 By Smapmin 寫入nme_file時,未將nme14寫入
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750125 07/05/28 By Smapmin 暫估金額一律抓取anmt730暫估時的金額
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.CHI-7A0027 07/10/18 By Smapmin 沒有暫估資料仍需產生利差
# Modify.........: No.MOD-7C0216 07/12/27 By Smapmin 修改update nnm_file時的條件
# Modify.........: No.MOD-7C0230 07/12/31 By Smapmin 當融資種類為要計暫估利息時,才CHECK有無利息暫估資料存在
# Modify.........: No.MOD-830093 08/03/12 By chenl   新增功能，增加對單身止算日期的判斷，止算日不可大于還息日。
# Modify.........: No.MOD-830232 08/03/28 By chenl   在止算日期處增加對"利差損失"的計算。
# Modify.........: No.FUN-830151 08/04/01 By sherry  報表改由CR輸出  
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-870044 08/07/08 By Sarah t740_upd_nnm(),UPDATE nnm_file時,改抓nnj06的年月當條件
# Modify.........: No.MOD-870249 08/07/29 By Sarah 報表列印只需印出畫面上的這一筆
# Modify.........: No.MOD-870290 08/07/30 By Sarah t740_out()段的l_sql增加OUTER azi_file,多抓azi07
# Modify.........: No.CHI-8A0019 08/10/17 By Sarah 匯差應計算後寫入nnj16,不應併入nnj15,會造成利差虛增
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-8C0104 08/12/11 By Sarah 1.輸入單身單據號碼時,依種類檢核nne04/nng04是否與單頭nni05一致
#                                                  2.INPUT開窗使用q_nne,q_nng要傳arg1=g_nni.nni05
# Modify.........: No.MOD-8C0174 08/12/18 By Sarah 修正MOD-870044,t740_upd_nnm(),UPDATE nnm_file時,改抓nnj05的年月當條件
# Modify.........: No.MOD-8C0251 08/12/31 By Sarah 利息計算的方式應是算頭不算尾,第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
# Modify.........: No.MOD-910025 09/01/06 By Nicola 1.延續 MOD-8C0174 修改,相關使用 nni03_y,nni03_m 抓取 nnm_file 的部分  改取 nnj05(起算日期) 年與月
#                                                   2.t740_g_b() 部分改用 nni03_y,nni03_m 減一個月的方式;需判斷若 nni03_m = 1 時, nni03_y = nni03_y - 1 , nni03_m = 12
#                                                   3.畫面上 nni03_y,nni03_m 予已隱藏
# Modify.........: No.CHI-890008 09/01/13 By jamie 取消此單的程式改在5.15，但FUN-860040已經過單，所以重新過單
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值
# Mofify.........: NO.MOD-930043 09/03/06 By lilingyu 付款單號欄位查詢時開窗錯誤
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No:FUN-910014 09/04/13 By Sarah 新增無效功能,並增加狀態頁簽
# Modify.........: No.MOD-950048 09/05/14 By lilingyu將MOD-830093的修改段改為大陸版(g_aza.aza26='2')才卡
# Modify.........: No.TQC-950195 09/05/31 By Carrier "支付銀行"錯誤信息修改
# Modify.........: No.TQC-960015 09/06/04 By xiaofeizhu 修改新增時，錄入完信貸銀行后，取消后再次錄入信貸銀行且和上次一樣的資料時，無法帶出銀行名稱的問題
# Modify.........: No.FUN-960160 09/07/21 By chenmoyan nni07='1'時不卡nni21為必輸欄
# Modify.........: No.MOD-980005 09/08/03 By mike FUNCTION t740_g_gl_1()段，當參數「融資暫估利息，次月回轉」設定打勾(nmz52='Y')時   
#                                                 ,產生的科目應抓nmq10/nmq101,而不是nms60/nms601 
# Modify.........: No.MOD-980006 09/08/03 By mike FUNCTION t740_b()的AFTER FIELD nnj05段,增加檢核nnj03+nnj05是否已輸入過,若是則不可>
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9A0099 09/10/16 By liuxqa 查詢時，狀態頁簽不可用。
# Modify.........: No:MOD-9A0012 09/10/19 By sabrina 回寫融資/中長貸的最後還息日時，改為回寫該筆單身的止算日 
# Modify.........: No:MOD-9A0110 09/10/30 By mike FUNCTION t740_g_b(),nnj06算法请改回    
# Modify.........: No:MOD-9B0059 09/11/10 By Sarah 應付利息的匯率帶錯
# Modify.........: No:TQC-9B0069 09/11/23 By jan 增加 狀態 頁簽欄位顯示處理
# Modify.........: No:MOD-9C0011 09/12/02 By Sarah 修正MOD-980006,第一次與第二次還息有可能是同一個月份,卡關需調整
# Modify.........: No:MOD-A10028 10/01/06 By Sarah 修正MOD-980005,應改抓nmq01與nmq011
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No.MOD-A20096 10/02/26 By sabrina 單據確認後不可做無效
# Modify.........: No.MOD-A30109 10/03/16 By sabrina AFTER FIELD nnj05/nnj06 卡關須加p_cmd='a'時才需進入之後的判斷，
#                                                    否則在新增時還會對原來的資料作判斷
# Modify.........: No.MOD-A50160 10/05/25 By sabrina 串查程式無法使用
# Modify.........: No.MOD-A50065 10/06/03 By sabrina 原幣未依照其幣別小數位數取位，rpt裡以本幣位數取位，造成原幣金額錯誤
# Modify.........: No:CHI-A40018 10/06/14 By Summer 確認段檢核npq03=nni10時,金額與nni14比對是否一致,否則提示錯誤訊息(aap-065)
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70196 10/07/27 By Dido 自動產生時,利息天數預設值應與 b 段相同 
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.MOD-A40098 10/08/03 by sabrina 修改MOD-A30109 
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No.MOD-B30156 11/03/12 By zhangweib 請將FUNCTION t740_show()裡CALL s_check_no()段(以下兩行)mark掉
# Modify.........: No:MOD-B30683 11/03/28 By Dido nni07 檢核調整與 nni10/nni101 預設調整
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B70232 11/07/25 By Sarah 報表SQL改為欄位展開的寫法(不要寫成nni_file.*,要寫nni01,nni02,...),
#                                                  並使用別名(SELECT a.nni01....FROM nni_file a...)
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B80058 11/08/05 By Polly 修正單身利差是(nnj15)不會計算
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: N0.CHI-B80051 11/10/06 By Polly 單身增加原單的借款金額 nne12/nne19 or nng20/nng22
# Modify.........: No.MOD-BC0283 11/12/29 By Polly 調整查詢筆數抓取sql語法
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C30023 12/03/02 By Polly BEFORE ROW增加l_date/l_j09t/l_j09g抓取顯示
# Modify.........: No.MOD-C30686 12/03/14 By minpp FUNCTION t740_g_gl_1 中 PREPARE nnm_nnj_p 需再抓取 nnm09
# Moidfy.........: No.MOD-C30870 12/04/02 By Polly 將aap-065檢核獨立出來針對nni101做控卡
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70010 12/07/02 By lujh 單身【nnj03單據編號】欄位after field和開窗邏輯不一致，開窗會篩選此筆借款是否已還清(nne19-nne20>0)，
#                                                 但若直接輸入融則不會控卡
# Modify.........: No.TQC-C70054 12/07/09 By lujh 第一筆資料點擊“刪除”後畫面資料全部清空，未默認顯示原第二筆資料
# Modify.........: No.MOD-C70016 12/07/03 By Polly 直按輸入融資單號需在控卡此借款是否還清
# Modify.........: No.MOD-C70284 12/07/31 By Polly 增加潤年判斷，如屬於潤年度時，則使用366天計算
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No.MOD-C90128 12/09/14 By Polly AFTER FIELD nnj05 取消 nnj04 判斷
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-CA0018 12/10/02 By Polly 『天數』nnj07為『算頭不算尾』，取消加1動作
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No.MOD-D20008 13/02/01 By Polly 寫入nme_file一律依據存入銀行角度寫入
# Modify.........: No:MOD-D20172 13/03/05 By Polly 調整利差計算
# Modify.........: No:MOD-D30039 13/03/06 By Polly 增加單身輸入單據編號後自動帶出起算日和止算日
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:MOD-D30214 13/03/28 By Dido 當月無暫估時,預設值調整 
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.CHI-D50031 13/05/27 By Polly 調整本金原幣/本金本幣應為當時融資餘額,而非融資原始金額

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nni   RECORD LIKE nni_file.*,
    g_nni_t RECORD LIKE nni_file.*,
    g_nni_o RECORD LIKE nni_file.*,
    g_nni01_t LIKE nni_file.nni01,
    b_nnj   RECORD LIKE nnj_file.*,
    g_nmd   RECORD LIKE nmd_file.*,
    g_npp   RECORD LIKE npp_file.*,
    g_npq   RECORD LIKE npq_file.*,
    g_nms   RECORD LIKE nms_file.*,
   #g_nmq   RECORD LIKE nmq_file.*,  #mark #CHI-890008 add
    g_nmq   RECORD LIKE nmq_file.*,  #MOD-980005   
    g_wc,g_wc2,g_sql     string,                #No.FUN-580092 HCN
    g_statu              LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01) # 是否從新賦予等級
    g_dbs_gl             LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,  #No.FUN-980020
    g_nnj           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        nnj02            LIKE nnj_file.nnj02,
        nnj09            LIKE nnj_file.nnj09,
        nnj03            LIKE nnj_file.nnj03,
        nnj04            LIKE nnj_file.nnj04,
        date1            LIKE type_file.dat,    #No.FUN-680107 DATE
        nnj05            LIKE nnj_file.nnj05,
        nnj06            LIKE nnj_file.nnj06,
        nnj07            LIKE nnj_file.nnj07,
        nnj08            LIKE nnj_file.nnj08,
        j09t             LIKE nne_file.nne12,    #CHI-B80051 add
        j09g             LIKE nne_file.nne19,    #CHI-B80051 add
        nnj11            LIKE nnj_file.nnj11,
        nnj13            LIKE nnj_file.nnj13,
        nnj12            LIKE nnj_file.nnj12,
        nnj14            LIKE nnj_file.nnj14,
        nnj15            LIKE nnj_file.nnj15,
        nnj16            LIKE nnj_file.nnj16,
        nnjud01          LIKE nnj_file.nnjud01,
        nnjud02          LIKE nnj_file.nnjud02,
        nnjud03          LIKE nnj_file.nnjud03,
        nnjud04          LIKE nnj_file.nnjud04,
        nnjud05          LIKE nnj_file.nnjud05,
        nnjud06          LIKE nnj_file.nnjud06,
        nnjud07          LIKE nnj_file.nnjud07,
        nnjud08          LIKE nnj_file.nnjud08,
        nnjud09          LIKE nnj_file.nnjud09,
        nnjud10          LIKE nnj_file.nnjud10,
        nnjud11          LIKE nnj_file.nnjud11,
        nnjud12          LIKE nnj_file.nnjud12,
        nnjud13          LIKE nnj_file.nnjud13,
        nnjud14          LIKE nnj_file.nnjud14,
        nnjud15          LIKE nnj_file.nnjud15
                    END RECORD,
    g_nnj_t         RECORD                       #程式變數 (舊值)
        nnj02            LIKE nnj_file.nnj02,
        nnj09            LIKE nnj_file.nnj09,
        nnj03            LIKE nnj_file.nnj03,
        nnj04            LIKE nnj_file.nnj04,
        date1            LIKE type_file.dat,     #No.FUN-680107 DATE
        nnj05            LIKE nnj_file.nnj05,
        nnj06            LIKE nnj_file.nnj06,
        nnj07            LIKE nnj_file.nnj07,
        nnj08            LIKE nnj_file.nnj08,
        j09t             LIKE nne_file.nne12,    #CHI-B80051 add
        j09g             LIKE nne_file.nne19,    #CHI-B80051 add
        nnj11            LIKE nnj_file.nnj11,
        nnj13            LIKE nnj_file.nnj13,
        nnj12            LIKE nnj_file.nnj12,
        nnj14            LIKE nnj_file.nnj14,
        nnj15            LIKE nnj_file.nnj15,
        nnj16            LIKE nnj_file.nnj16,
        nnjud01          LIKE nnj_file.nnjud01,
        nnjud02          LIKE nnj_file.nnjud02,
        nnjud03          LIKE nnj_file.nnjud03,
        nnjud04          LIKE nnj_file.nnjud04,
        nnjud05          LIKE nnj_file.nnjud05,
        nnjud06          LIKE nnj_file.nnjud06,
        nnjud07          LIKE nnj_file.nnjud07,
        nnjud08          LIKE nnj_file.nnjud08,
        nnjud09          LIKE nnj_file.nnjud09,
        nnjud10          LIKE nnj_file.nnjud10,
        nnjud11          LIKE nnj_file.nnjud11,
        nnjud12          LIKE nnj_file.nnjud12,
        nnjud13          LIKE nnj_file.nnjud13,
        nnjud14          LIKE nnj_file.nnjud14,
        nnjud15          LIKE nnj_file.nnjud15
                         END RECORD,
    g_rec_b              LIKE type_file.num5,    #單身筆數  #No.FUN-680107 SMALLINT
    l_ac                 LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    gl_no_b,gl_no_e      LIKE type_file.chr20    #No.FUN-680107 VARCHAR(16) #No.FUN-550057
#------for ora修改-------------------
DEFINE g_system          LIKE type_file.chr2     #No.FUN-680107 VARCHAR(2)
DEFINE g_zero            LIKE type_file.num20_6  #No.FUN-680107 decimal(15,3)
DEFINE g_N               LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_y               LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE g_argv1           LIKE nni_file.nni01     #No.FUN-680107 VARCHAR(16) #單號 #TQC-630074
DEFINE g_argv2           STRING                  #指定執行的功能 #TQC-630074
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
 
DEFINE g_forupd_sql      STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_void          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE   g_str           STRING                  #No.FUN-670060
DEFINE   g_wc_gl         STRING                  #No.FUN-670060
DEFINE   g_t1            LIKE nmy_file.nmyslip   #No.FUN-670060  #No.FUN-680107 VARCHAR(5)
DEFINE   g_npq25         LIKE npq_file.npq25     #No.FUN-9A0036
DEFINE   g_nma05         LIKE nma_file.nma05     #MOD-B30683 
DEFINE   g_nma051        LIKE nma_file.nma051    #MOD-B30683 
DEFINE   g_nma28         LIKE nma_file.nma28     #MOD-B30683
DEFINE   g_jump          LIKE type_file.num10    #TQC-C70054
DEFINE   g_no_ask        LIKE type_file.num5     #TQC-C70054
 
MAIN
DEFINE          p_row,p_col    LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
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
    SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00 = '0' # MOD-580030 重新讀取 nmz_file
   SELECT * INTO g_nmq.* FROM nmq_file WHERE nmq00='0' #MOD-980005   
   LET g_forupd_sql = "SELECT * FROM nni_file WHERE nni01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t740_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET p_row = 1 LET p_col = 6
   OPEN WINDOW t740_w AT p_row,p_col
     WITH FORM "anm/42f/anmt740"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF g_aza.aza63 != 'Y' THEN
      CALL cl_set_comp_visible("nni101",FALSE) 
   ELSE
      CALL cl_set_comp_visible("nni101",TRUE)  
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t740_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t740_a()
            END IF
         OTHERWISE
            CALL t740_q()
      END CASE
   END IF
 
   CALL t740()
   CLOSE WINDOW t740_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t740()
    LET g_plant_gl = g_nmz.nmz02p                     #FUN-980020
    LET g_plant_new=g_nmz.nmz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new
    INITIALIZE g_nni.* TO NULL
    INITIALIZE g_nni_t.* TO NULL
    INITIALIZE g_nni_o.* TO NULL
    CALL t740_menu()
END FUNCTION
 
FUNCTION t740_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE g_t1        LIKE nmy_file.nmyslip  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
   CLEAR FORM
   CALL g_nnj.clear()
 
   IF cl_null(g_argv1) THEN
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nni.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON nni01,nni02,nni03,nni04,nni05,   #No.MOD-910025
                nni06,nni07,nni08,nni09,nni22,nni21,nniglno,nniconf,nni10,nni101, #No.FUN-680088
                nniud01,nniud02,nniud03,nniud04,nniud05,
                nniud06,nniud07,nniud08,nniud09,nniud10,
                nniud11,nniud12,nniud13,nniud14,nniud15
                ,nniuser,nnidate,nniacti,nnigrup,nnimodu    #No.TQC-9A0099 add
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nni01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nni"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nni01
                  NEXT FIELD nni01
               WHEN INFIELD(nni04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nni04
                  NEXT FIELD nni04
               WHEN INFIELD(nni05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_alg"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nni05
                  NEXT FIELD nni05
               WHEN INFIELD(nni06) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nni06
               WHEN INFIELD(nni10) # Dept CODE
                  CALL s_get_bookno1(YEAR(g_nni.nni02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nni.nni10,'23',g_bookno1)     #No.FUN-980025 
                  RETURNING g_nni.nni10
                  DISPLAY BY NAME g_nni.nni10
               WHEN INFIELD(nni101) # Dept CODE
                  CALL s_get_bookno1(YEAR(g_nni.nni02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nni.nni101,'23',g_bookno2) #No.FUN-980025
                  RETURNING g_nni.nni101
                  DISPLAY BY NAME g_nni.nni101
               WHEN INFIELD(nni21)
                  LET g_t1 = s_get_doc_no(g_nni.nni21)       #No.FUN-550057
                  CALL q_nmy(TRUE,FALSE,g_t1,'1','ANM') RETURNING g_t1  #TQC-670008
                  LET g_nni.nni21= g_t1    #No.FUN-550057
                  DISPLAY BY NAME g_nni.nni21
                  NEXT FIELD nni21
               WHEN INFIELD(nni22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nni22
                  NEXT FIELD nni22
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
      CONSTRUCT g_wc2 ON nnj02,nnj09,nnj03,nnj05,nnj06,nnj07,nnj08
                         ,nnjud01,nnjud02,nnjud03,nnjud04,nnjud05
                         ,nnjud06,nnjud07,nnjud08,nnjud09,nnjud10
                         ,nnjud11,nnjud12,nnjud13,nnjud14,nnjud15
              FROM s_nnj[1].nnj02,s_nnj[1].nnj09,s_nnj[1].nnj03,s_nnj[1].nnj05,
                   s_nnj[1].nnj06,s_nnj[1].nnj07,s_nnj[1].nnj08
                   ,s_nnj[1].nnjud01,s_nnj[1].nnjud02,s_nnj[1].nnjud03
                   ,s_nnj[1].nnjud04,s_nnj[1].nnjud05,s_nnj[1].nnjud06
                   ,s_nnj[1].nnjud07,s_nnj[1].nnjud08,s_nnj[1].nnjud09
                   ,s_nnj[1].nnjud10,s_nnj[1].nnjud11,s_nnj[1].nnjud12
                   ,s_nnj[1].nnjud13,s_nnj[1].nnjud14,s_nnj[1].nnjud15
           BEFORE CONSTRUCT
              CALL cl_qbe_display_condition(lc_qbe_sn)
      
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
      LET g_wc =" nni01 = '",g_argv1,"'"    #No.TQC-630074
      LET g_wc2 = ' 1=1'
   END IF
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nniuser', 'nnigrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT nni01 FROM nni_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY nni01"
   ELSE
      LET g_sql="SELECT nni_file.nni01 FROM nni_file,nnj_file ",
                " WHERE nni01=nnj01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY nni01"
   END IF
   PREPARE t740_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t740_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t740_prepare
  #-------------------------MOD-BC0283----------------------------------start
  #LET g_sql= "SELECT COUNT(*) FROM nni_file WHERE ",g_wc CLIPPED
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT COUNT(*) FROM nni_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY nni01"
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nni01) FROM nni_file,nnj_file ",
                " WHERE nni01=nnj01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY nni01"
   END IF
  #-------------------------MOD-BC0283------------------------------------end
   PREPARE t740_precount FROM g_sql
   DECLARE t740_count CURSOR FOR t740_precount
END FUNCTION
 
FUNCTION t740_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
   WHILE TRUE
      CALL t740_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t740_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t740_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t740_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t740_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t740_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL t740_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_n_p"
            CALL t740_g_np()
         WHEN "modify_n_p"
            LET g_msg="anmt100 '",g_nni.nni21,"'"
            CALL cl_cmdrun_wait(g_msg)   #FUN-660216 add
         WHEN "undo_n_p"
            IF cl_chk_act_auth() THEN
               CALL t740_del_np()
            END IF
         WHEN "gen_entry_sheet"
            CALL t740_g_gl(g_nni.nni01,'0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL t740_g_gl(g_nni.nni01,'1')
            END IF
         WHEN "maintain_entry_sheet"
            CALL s_fsgl('NM',6,g_nni.nni01,0,g_nmz.nmz02b,0,g_nni.nniconf,'0',g_nmz.nmz02p)   
            CALL t740_npp02('0')
 
         WHEN "maintain_entry_sheet2"
            CALL s_fsgl('NM',6,g_nni.nni01,0,g_nmz.nmz02c,0,g_nni.nniconf,'1',g_nmz.nmz02p)   
            CALL t740_npp02('1')
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t740_firm1()
               #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)     #MOD-A20096 "" modify nniacti  #CHI-C80041 
               IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
               CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041  
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t740_firm2()
               #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)     #MOD-A20096 "" modify nniacti  #CHI-C80041
               IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
               CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041 
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnj),'','')
            END IF
 
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
             IF g_nni.nniconf = "Y" THEN
                CALL t740_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
             END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
             IF g_nni.nniconf = "Y" THEN
                CALL t740_undo_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-403',1)
             END IF
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nni.nni01 IS NOT NULL THEN
                    LET g_doc.column1 = "nni01"
                    LET g_doc.value1 = g_nni.nni01
                    CALL cl_doc()
                 END IF
              END IF
        #str FUN-910014 add
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t740_x()
            END IF
        #end FUN-910014 add
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t740_v()
               IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)   
            END IF
         #CHI-C80041---end  
      END CASE
   END WHILE
   CLOSE t740_cs
END FUNCTION
 
FUNCTION t740_a()
DEFINE g_t1        LIKE nmy_file.nmyslip    #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
DEFINE li_result   LIKE type_file.num5      #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                               # 清螢幕欄位內容
   CALL g_nnj.clear()
   INITIALIZE g_nni.* LIKE nni_file.*
   LET g_nni_t.* = g_nni.*
   LET g_nni_o.* = g_nni.*                  #TQC-960015
   LET g_nni01_t = NULL
   LET g_nni.nni02 = g_today
   LET g_nni.nniconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_nni.nniacti ='Y'                   # 有效的資料
      LET g_nni.nniuser = g_user
      LET g_nni.nnioriu = g_user #FUN-980030
      LET g_nni.nniorig = g_grup #FUN-980030
      LET g_nni.nnigrup = g_grup               # 使用者所屬群
      LET g_nni.nnidate = g_today
      LET g_nni.nniinpd = g_today
      LET g_nni.nnilegal= g_legal
 
      CALL t740_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_nni.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_nnj.clear()
         EXIT WHILE
      END IF
      IF g_nni.nni01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK  #No.7875
        CALL s_auto_assign_no("anm",g_nni.nni01,g_nni.nni02,"6","nni_file","nni01","","","")
             RETURNING li_result,g_nni.nni01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nni.nni01
 
      INSERT INTO nni_file VALUES(g_nni.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nni_file",g_nni.nni01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK #No.7875
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No.7875
         CALL cl_flow_notify(g_nni.nni01,'I')
         LET g_nni_t.* = g_nni.*               # 保存上筆資料
         SELECT nni01 INTO g_nni.nni01 FROM nni_file
                WHERE nni01 = g_nni.nni01
      END IF
      CALL g_nnj.clear()
      LET g_rec_b=0
      CALL t740_b()
       LET g_t1 = s_get_doc_no(g_nni.nni01)       #No.FUN-550057
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
      IF g_nmy.nmydmy1 = 'Y' THEN CALL t740_firm1() END IF
      EXIT WHILE
   END WHILE
   LET g_wc=' '
END FUNCTION
 
FUNCTION t740_i(p_cmd)
DEFINE
        l_nmd01         LIKE nmd_file.nmd01,
        p_cmd           LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
        g_t1            LIKE nmy_file.nmyslip,   #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
        l_dept          LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(10)              #Dept
        l_n             LIKE type_file.num5      #No.FUN-680107 SMALLINT
DEFINE  li_result       LIKE type_file.num5      #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   DISPLAY BY NAME g_nni.nniuser,g_nni.nnimodu,g_nni.nnidate, #TQC-9B0069
                   g_nni.nnigrup,g_nni.nniacti                #TQC-9B0069
    INPUT BY NAME g_nni.nnioriu,g_nni.nniorig,
           g_nni.nni01,g_nni.nni02,g_nni.nni03,   #No.MOD-910025
           g_nni.nni04,g_nni.nni05,
           g_nni.nni06,g_nni.nni07,g_nni.nni08,g_nni.nni10, 
           g_nni.nni09,g_nni.nni22,g_nni.nniconf,g_nni.nni21,g_nni.nniglno,
           g_nni.nni11,g_nni.nni12,g_nni.nni13,
           g_nni.nni14,g_nni.nni15,g_nni.nni16,
           g_nni.nniud01,g_nni.nniud02,g_nni.nniud03,g_nni.nniud04,
           g_nni.nniud05,g_nni.nniud06,g_nni.nniud07,g_nni.nniud08,
           g_nni.nniud09,g_nni.nniud10,g_nni.nniud11,g_nni.nniud12,
           g_nni.nniud13,g_nni.nniud14,g_nni.nniud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t740_set_entry(p_cmd)
         CALL t740_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nni01")
         CALL cl_set_docno_format("nni21")
         CALL cl_set_docno_format("nnj03")
 
        AFTER FIELD nni01
           IF NOT cl_null(g_nni.nni01) AND (g_nni.nni01!=g_nni01_t) THEN
           CALL s_check_no("anm",g_nni.nni01,g_nni_t.nni01,"6","nni_file","nni01","")
             RETURNING li_result,g_nni.nni01
           DISPLAY BY NAME g_nni.nni01
             IF (NOT li_result) THEN
               NEXT FIELD nni01
             END IF
           END IF
 
        AFTER FIELD nni02
           IF NOT cl_null(g_nni.nni02) THEN
              IF g_nni.nni02 <= g_nmz.nmz10 THEN  #no.5261
                 CALL cl_err('','aap-176',1) NEXT FIELD nni02
              END IF
           END IF
 
        AFTER FIELD nni03
           IF NOT cl_null(g_nni.nni03) THEN
              LET g_nni.nni03_y= YEAR(g_nni.nni03)
              LET g_nni.nni03_m=MONTH(g_nni.nni03)
           END IF
 
 
 
        AFTER FIELD nni04
           IF NOT cl_null(g_nni.nni04) THEN
              SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = g_nni.nni04
              IF SQLCA.SQLCODE OR l_n <= 0 THEN
                 CALL cl_err3("sel","azi_file",g_nni.nni04,"","anm-007","","",1)  #No.FUN-660148
                 NEXT FIELD nni04
              END IF
           END IF
 
        AFTER FIELD nni05
           IF NOT cl_null(g_nni.nni05) THEN
              IF cl_null(g_nni_o.nni05) OR g_nni.nni05 != g_nni_o.nni05 THEN
                 CALL t740_nni05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nni.nni05,g_errno,0)
                    LET g_nni.nni05 = g_nni_o.nni05
                    DISPLAY BY NAME g_nni.nni05
                    NEXT FIELD nni05
                 END IF
              END IF
              LET g_nni_o.nni05 = g_nni.nni05
           END IF
 
        AFTER FIELD nni06
           IF NOT cl_null(g_nni.nni06) THEN
              CALL t740_nni06('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nni.nni06,g_errno,0)
                 LET g_nni.nni06 = g_nni_o.nni06
                 DISPLAY BY NAME g_nni.nni06
                 NEXT FIELD nni06
              END IF
              LET g_nni_o.nni06 = g_nni.nni06
           END IF
 
        AFTER FIELD nni07
           IF NOT cl_null(g_nni.nni07) THEN
              IF  g_nni.nni07 NOT MATCHES '[123]' THEN
                NEXT FIELD nni07
              END IF
              #No:6703 活存不能改為支存,但支存可以改活存
             #IF (g_nni_o.nni07='2'OR g_nni_o.nni07='3') AND         #MOD-B30683 mark  
             #    g_nni.nni07='1' THEN                               #MOD-B30683 mark
              IF g_nni.nni07 = '1' AND g_nni.nni07 <> g_nma28 THEN 
                 IF  g_aza.aza26!='2' THEN    #FUN-C80018
                     CALL cl_err(g_nni.nni07,'anm-149 ',0)               #MOD-B30683 mod anm-098 -> anm-149
                    NEXT FIELD nni07
                 END IF                       #FUN-C80018
              END IF 
             #-MOD-B30683-add-
              IF g_nni.nni07 <> '1' THEN
                 LET g_nni.nni10 = g_nma05
                 IF g_aza.aza63 = 'Y' THEN
                    LET g_nni.nni101 = g_nma051 
                    DISPLAY BY NAME g_nni.nni101
                 END IF
              END IF
              DISPLAY BY NAME g_nni.nni07,g_nni.nni10
             #-MOD-B30683-add-
           END IF   #No:6703
 
        BEFORE FIELD nni09                  # 自動計算出帳匯率
           IF g_nni.nni09 IS NULL OR g_nni.nni09 = 0 THEN
              CALL s_bankex(g_nni.nni06,g_nni.nni02) RETURNING g_nni.nni09
              DISPLAY BY NAME g_nni.nni09
           END IF
 
        AFTER FIELD nni09
           IF NOT cl_null(g_nni.nni09) THEN
              IF g_nni.nni09 = 0 THEN
                 NEXT FIELD nni09
              END IF
           END IF
 
        AFTER FIELD nni10
           IF NOT cl_null(g_nni.nni10) THEN
              CALL s_get_bookno(YEAR(g_nni.nni02)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN
                 CALL cl_err(YEAR(g_nni.nni02),'aoo-081',1)
              END IF
              SELECT aag02 FROM aag_file WHERE aag01=g_nni.nni10
                                           AND aag00 = g_bookno1
              IF STATUS THEN
                 CALL cl_err3("sel","aag_file",g_nni.nni10,"",STATUS,"","sel aag:",1)  #No.FUN-660148
                 NEXT FIELD nni10
              END IF
           END IF
 
        AFTER FIELD nni22
           IF g_nni.nni07='2' AND cl_null(g_nni.nni22) THEN
              NEXT FIELD nni22
           END IF
           IF NOT cl_null(g_nni.nni22) THEN
              SELECT nmc03 FROM nmc_file WHERE nmc01=g_nni.nni22 AND nmc03='2'
               IF STATUS THEN 
                CALL cl_err3("sel","nmc_file",g_nni.nni22,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
                NEXT FIELD nni22
              END IF
           ELSE
              CALL cl_err('','mfg0037',0)
              NEXT FIELD nni22
           END IF
 
        BEFORE FIELD nni21
           IF g_nni.nni07='2' THEN
              LET g_nni.nni21=''
              DISPLAY BY NAME g_nni.nni21
           END IF
 
        AFTER FIELD nni21
           IF NOT cl_null(g_nni.nni21) AND (g_nni.nni21!=g_nni_t.nni21) THEN
            CALL s_check_no("anm",g_nni.nni21,g_nni_t.nni21,"1","","","")
                 RETURNING li_result,g_nni.nni21
            DISPLAY BY NAME g_nni.nni21
            IF (NOT li_result) THEN
               NEXT FIELD nni21
            END IF
           END IF
 
        AFTER FIELD nniud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nniud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nni.nniuser = s_get_data_owner("nni_file") #FUN-C10039
           LET g_nni.nnigrup = s_get_data_group("nni_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(g_nni.nni01) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni01
            END IF
            IF cl_null(g_nni.nni02) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni02
            END IF
            IF cl_null(g_nni.nni03) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni03
            END IF
            IF cl_null(g_nni.nni04) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni04
            END IF
            IF cl_null(g_nni.nni05) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni05
            END IF
            IF cl_null(g_nni.nni06) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni06
            END IF
            IF cl_null(g_nni.nni07) THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni07
            END IF
            IF cl_null(g_nni.nni09) OR g_nni.nni09 = 0 THEN
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni09
            END IF
            IF cl_null(g_nni.nni22) THEN   #AND g_nni.nni07 = '2' THEN   #MOD-640073 modify
               LET l_flag='Y' DISPLAY BY NAME g_nni.nni22
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('',9033,0)
               NEXT FIELD nni01
            END IF
 
        ON KEY(F1) NEXT FIELD nni01
        ON KEY(F2) NEXT FIELD nni06
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nni01)
                 LET g_t1 = s_get_doc_no(g_nni.nni01)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'6','ANM') RETURNING g_t1  #TQC-670008
                 LET g_nni.nni01= g_t1     #No.FUN-550057
                 DISPLAY BY NAME g_nni.nni01 NEXT FIELD nni01
              WHEN INFIELD(nni04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nni.nni04
                 CALL cl_create_qry() RETURNING g_nni.nni04
                 DISPLAY BY NAME g_nni.nni04 NEXT FIELD nni04
              WHEN INFIELD(nni05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.default1 = g_nni.nni05
                 CALL cl_create_qry() RETURNING g_nni.nni05
                      DISPLAY BY NAME g_nni.nni05 NEXT FIELD nni05
              WHEN INFIELD(nni06) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nni.nni06
                 CALL cl_create_qry() RETURNING g_nni.nni06
                 DISPLAY BY NAME g_nni.nni06
              WHEN INFIELD(nni10) # Dept CODE
                 CALL s_get_bookno1(YEAR(g_nni.nni02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nni.nni02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nni.nni10,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_nni.nni10
                 DISPLAY BY NAME g_nni.nni10
              WHEN INFIELD(nni21)
                 LET g_t1 = s_get_doc_no(g_nni.nni21)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'1','ANM') RETURNING g_t1  #TQC-670008
                 LET g_nni.nni21= g_t1      #No.FUN-550057
                 DISPLAY BY NAME g_nni.nni21 NEXT FIELD nni21
              WHEN INFIELD(nni22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmc01"   #MOD-640409
                 LET g_qryparam.default1 = g_nni.nni22
                 LET g_qryparam.arg1 = '2'   #MOD-640409
                 CALL cl_create_qry() RETURNING g_nni.nni22
                 DISPLAY BY NAME g_nni.nni22 NEXT FIELD nni22
              WHEN INFIELD(nni09)
                   CALL s_rate(g_nni.nni08,g_nni.nni09) RETURNING g_nni.nni09
                   DISPLAY BY NAME g_nni.nni09
                   NEXT FIELD nni09
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
 
FUNCTION t740_nni05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_alg   RECORD LIKE alg_file.*
 
   SELECT * INTO l_alg.*
          FROM alg_file WHERE alg01 = g_nni.nni05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   DISPLAY l_alg.alg02 TO FORMONLY.alg02
END FUNCTION
 
FUNCTION t740_nni06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma   RECORD LIKE nma_file.*
   DEFINE l_nmd02 LIKE nmd_file.nmd02
 
   SELECT nmd02 INTO l_nmd02 FROM nmd_file WHERE nmd01 = g_nni.nni21
   DISPLAY l_nmd02 TO FORMONLY.nmd02
   SELECT * INTO l_nma.*
     FROM nma_file WHERE nma01 = g_nni.nni06
   LET g_errno = ' '
   LET g_nma05 = ''     #MOD-B30683
   LET g_nma051 = ''    #MOD-B30683
   LET g_nma28 = ''     #MOD-B30683
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'  #No.TQC-950195
        WHEN l_nma.nmaacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY l_nma.nma02 TO FORMONLY.nma02
   IF p_cmd != 'a' THEN RETURN END IF
   LET g_nni.nni07 = l_nma.nma28
   LET g_nma28 = l_nma.nma28         #MOD-B30683
   LET g_nma05 = l_nma.nma05         #MOD-B30683 
   LET g_nni.nni08 = l_nma.nma10
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni08
   IF g_nni.nni07='1' THEN # 貸: 應付票據
      SELECT nms15 INTO g_nni.nni10 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
      IF g_aza.aza63 = 'Y' THEN
         SELECT nms151 INTO g_nni.nni101 FROM nms_file 
          WHERE (nms01 = ' ' OR nms01 IS NULL)
         DISPLAY BY NAME g_nni.nni101
      END IF
   ELSE
      LET g_nni.nni10 = l_nma.nma05      # 貸: 銀行存款
      IF g_aza.aza63 = 'Y' THEN
         LET g_nni.nni101 = l_nma.nma051 
         LET g_nma051 = l_nma.nma051         #MOD-B30683 
         DISPLAY BY NAME g_nni.nni101
      END IF
   END IF
   DISPLAY BY NAME g_nni.nni07,g_nni.nni08,g_nni.nni10
END FUNCTION
 
FUNCTION t740_g_b()
   DEFINE l_nnm         RECORD LIKE nnm_file.*
   DEFINE l_nnj         RECORD LIKE nnj_file.*
   DEFINE l_day         LIKE nne_file.nne22
   DEFINE l_dd          LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE g_yy          LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE g_mm          LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE g_i           LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_nnl12       LIKE nnl_file.nnl12
   DEFINE l_nne27       LIKE nne_file.nne27,
          l_nne17       LIKE nne_file.nne17,
          l_nne12       LIKE nne_file.nne12
   DEFINE l_nng19       LIKE nng_file.nng19,
          l_nng20       LIKE nng_file.nng20,
          l_nng21       LIKE nng_file.nng21
   DEFINE l_date        LIKE nne_file.nne112    #MOD-8C0251 add
   DEFINE l_nni03_y     LIKE nni_file.nni03_y   #No.MOD-910025 
   DEFINE l_nni03_m     LIKE nni_file.nni03_m   #No.MOD-910025 
   DEFINE l_rate        LIKE nni_file.nni09     #MOD-9B0059 add
 
   IF g_nni.nni01 IS NULL THEN RETURN END IF
 
   IF g_nni.nni03_m = 1 THEN
      LET l_nni03_y = g_nni.nni03_y - 1
      LET l_nni03_m = 12
   ELSE
      LET l_nni03_y = g_nni.nni03_y
      LET l_nni03_m = g_nni.nni03_m - 1
   END IF 
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni04
   DECLARE t740_g_b_c1 CURSOR WITH HOLD FOR
    SELECT * FROM nnm_file
     WHERE nnm09=g_nni.nni04
       AND nnm14=g_nni.nni05
       AND nnm02=l_nni03_y   #No.MOD-910025
       AND nnm03=l_nni03_m   #No.MOD-910025
       AND nnm13 IS NULL
       AND nnm16 IS NULL
     ORDER BY 1
   LET l_ac = 1
   LET l_nnj.nnj01=g_nni.nni01
   LET l_nnj.nnj02=0
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)  
      CLOSE t740_cl
      LET g_success='N'        #FUN-8A0086 
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl
      LET g_success='N'        #FUN-8A0086 
      ROLLBACK WORK
      RETURN
   END IF
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t740_g_b_c1 INTO l_nnm.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN 
         CALL cl_err('g_b()foreach',STATUS,1)
         LET g_success='N'        #FUN-8A0086 
         EXIT FOREACH
      END IF
      LET l_nnj.nnj03=l_nnm.nnm01
      LET l_nnj.nnj09=l_nnm.nnm04
      LET l_nnj.nnj04=NULL
      LET l_dd=DAY(g_nni.nni03)        #No:9078 利息日期的day
      LET g_yy=YEAR(g_nni.nni03)       #No:9078 利息日期的年
      LET g_mm=MONTH(g_nni.nni03)      #No:9078 利息日期的月
      IF l_nnj.nnj09 ='1' THEN
         SELECT nne08,nne22,nne27,nne12,nne17,nne112  #No.9078    #MOD-8C0251 add nne112
           INTO l_nnj.nnj04,l_day,l_nne27,l_nne12,l_nne17,l_date  #MOD-8C0251 add l_date
           FROM nne_file
         #WHERE nne01=l_nnm.nnm01 AND nneconf <> 'X'              #MOD-D30039 mark
          WHERE nne01=l_nnm.nnm01                                 #MOD-D30039 add
            AND nneconf ='Y'   #No:8024
      ELSE
         SELECT nng13,nng16,nng19,nng20,nng21,nng102  #No.9078    #MOD-8C0251 add nng082
           INTO l_day,l_nnj.nnj04,l_nng19,l_nng20,l_nng21,l_date  #MOD-8C0251 add l_date
           FROM nng_file
         #WHERE nng01=l_nnm.nnm01 AND nngconf <> 'X'              #MOD-D30039 mark
          WHERE nng01=l_nnm.nnm01                                 #MOD-D30039 add
            AND nngconf ='Y'   #No:8024   #No.MOD-560177
      END IF
      IF STATUS THEN CONTINUE FOREACH END IF
      #No:9078 若付息日在利息日期之後則不可出現
      IF l_dd < l_day THEN CONTINUE FOREACH END IF
      # 注意: 僅月付息者, 可自動產生單身
      IF l_nnj.nnj04 = '2' THEN CONTINUE FOREACH END IF
      LET l_nnj.nnj05=l_nnm.nnm05
      #No:9078 止算日用單頭利息日期的年月+每張單子的日去產生
      LET l_nnj.nnj06=MDY(g_mm,l_day,g_yy) #MOD-5B0236 #MOD-9A0110 取消MARK  
     #利息計算的方式應是算頭不算尾,
     #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
     #---------------------------MOD-CA0018-----------------mark
     #IF l_nnj.nnj06=l_date THEN   #止算日期=融資截止日期->最後一個月
     #   LET l_nnj.nnj07 = l_nnj.nnj06 - l_nnj.nnj05
     #ELSE
     #   LET l_nnj.nnj07 = l_nnj.nnj06 - l_nnj.nnj05 + 1
     #END IF
     #---------------------------MOD-CA0018-----------------mark
      LET l_nnj.nnj07 = l_nnj.nnj06 - l_nnj.nnj05           #MOD-CA0018 add
      LET l_nnj.nnj08=l_nnm.nnm08
     #-MOD-A70196-add-
      IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17 THEN 
         IF YEAR(g_nnj[l_ac].nnj05) MOD 4 = 0 THEN                 #MOD-C70284 add
            LET g_i = 366       # 本幣潤年一年採366天              #MOD-C70284 add
         ELSE                                                      #MOD-C70284 add
            LET g_i = 365	# 本幣一年採365天
         END IF                                                    #MOD-C70284 add
      ELSE 
         LET g_i = 360	# 外幣一年採360天
      END IF
     #-MOD-A70196-end-
      IF l_nnj.nnj09 ='1' THEN
         #************ 原幣利息=(貸款金額-已還金額)*(利率/100/365)*天數 ******
         SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
          WHERE nnl01=nnk01 AND nnl03='1' AND nnl04=l_nnm.nnm01
            AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
         IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
         LET l_nne27 = l_nne27 - l_nnl12    #已還金額
         #------------------------------------------------------#
         LET l_nnj.nnj12=(l_nne12-l_nne27)*(l_nnj.nnj08/100/g_i)*l_nnj.nnj07
        #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
         IF g_nni.nni04 != g_nni.nni08 THEN
            LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
            LET l_nnj.nnj12=cl_digcut(l_nnj.nnj12*l_rate,g_azi04)
            LET l_nnj.nnj14=l_nnj.nnj12
         END IF
         LET l_nnj.nnj14=cl_digcut(l_nnj.nnj12*g_nni.nni09,g_azi04)   #MOD-640409
      ELSE
         SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
          WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=l_nnm.nnm01
            AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
         IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
         LET l_nng21 = l_nng21 - l_nnl12   #已還金額
         LET l_nnj.nnj12=(l_nng20-l_nng21)*(l_nnj.nnj08/100/g_i)*l_nnj.nnj07
        #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
         IF g_nni.nni04 != g_nni.nni08 THEN
            LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
            LET l_nnj.nnj12=cl_digcut(l_nnj.nnj12*l_rate,g_azi04)
            LET l_nnj.nnj14=l_nnj.nnj12
         END IF
         LET l_nnj.nnj14=cl_digcut(l_nnj.nnj12*g_nni.nni09,g_azi04)   #MOD-640409
      END IF
      LET l_nnj.nnj11 = l_nnm.nnm11
      LET l_nnj.nnj13 = l_nnm.nnm12    
     #--------------------MOD-D20172--------------------(S)
     #LET l_nnj.nnj15 = 0              #MOD-D20172 mark
     #LET l_nnj.nnj16 = 0              #MOD-D20172 mark
      IF g_nni.nni04 != g_nni.nni08 THEN
         LET l_nnj.nnj15 = (l_nnj.nnj14 - l_nnj.nnj13)
         LET l_nnj.nnj16 = 0
      ELSE
         IF cl_null(l_nnj.nnj12) THEN
            LET l_nnj.nnj12 = 0
         END IF
         LET l_nnj.nnj15 = (l_nnj.nnj12 - l_nnj.nnj11) * g_nni.nni09
         IF g_nni.nni04 <> g_aza.aza17 THEN
            LET l_nnj.nnj16 = (l_nnj.nnj14 - l_nnj.nnj13 - l_nnj.nnj15)
         ELSE
            LET l_nnj.nnj16 = 0
         END IF
      END IF
     #--------------------MOD-D20172--------------------(E)
      LET l_nnj.nnj02 = l_nnj.nnj02+1
      CALL cl_digcut(l_nnj.nnj11,t_azi04) RETURNING l_nnj.nnj11
      CALL cl_digcut(l_nnj.nnj12,t_azi04) RETURNING l_nnj.nnj12
      CALL cl_digcut(l_nnj.nnj13,g_azi04) RETURNING l_nnj.nnj13
      CALL cl_digcut(l_nnj.nnj14,g_azi04) RETURNING l_nnj.nnj14
      CALL cl_digcut(l_nnj.nnj15,g_azi04) RETURNING l_nnj.nnj15    #MOD-D20172 add
      CALL cl_digcut(l_nnj.nnj16,g_azi04) RETURNING l_nnj.nnj16    #MOD-D20172 add

      MESSAGE '>:',l_nnj.nnj02,' ',l_nnj.nnj03
 
      LET l_nnj.nnjlegal= g_legal
      INSERT INTO nnj_file VALUES(l_nnj.*)
      IF STATUS THEN
         LET g_showmsg = l_nnj.nnj01,"/",l_nnj.nnj02                   #No.FUN-710024
         CALL s_errmsg('nnj01,nnj02',g_showmsg,'ins nnj:',STATUS,1)    #No.FUN-710024
         LET g_success='N' CONTINUE FOREACH  #No.FUN-710024
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF STATUS THEN CALL cl_err('g_b()foreach',STATUS,1) END IF
   CALL s_showmsg()   #No.FUN-710024
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL t740_b_tot()
END FUNCTION
 
FUNCTION t740_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nni.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t740_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_nnj.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t740_count
   FETCH t740_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t740_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      INITIALIZE g_nni.* TO NULL
   ELSE
      CALL t740_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t740_fetch(p_flnni)
   DEFINE
       p_flnni   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso    LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnni
      WHEN 'N' FETCH NEXT     t740_cs INTO g_nni.nni01
      WHEN 'P' FETCH PREVIOUS t740_cs INTO g_nni.nni01
      WHEN 'F' FETCH FIRST    t740_cs INTO g_nni.nni01
      WHEN 'L' FETCH LAST     t740_cs INTO g_nni.nni01
      WHEN '/'
      IF (NOT g_no_ask) THEN      #TQC-C70054  add
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
         #PROMPT g_msg CLIPPED,': ' FOR l_abso     #TQC-C70054  mark
         PROMPT g_msg CLIPPED,': ' FOR g_jump      #TQC-C70054  add
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
      END IF   #TQC-C70054  add
         #FETCH ABSOLUTE l_abso t740_cs INTO g_nni.nni01     #TQC-C70054  mark
         FETCH ABSOLUTE g_jump t740_cs INTO g_nni.nni01      #TQC-C70054  add
         LET g_no_ask = FALSE                                #TQC-C70054  add
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      INITIALIZE g_nni.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnni
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         #WHEN '/' LET g_curs_index = l_abso         #TQC-C70054  mark
         WHEN '/' LET g_curs_index = g_jump          #TQC-C70054  add
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nni.* FROM nni_file       # 重讀DB,因TEMP有不被更新特性
    WHERE nni01 = g_nni.nni01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nni_file",g_nni.nni01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_nni.nniuser     #No.FUN-4C0063
      LET g_data_group = g_nni.nnigrup     #No.FUN-4C0063
      CALL t740_show()                     # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t740_show()
DEFINE  g_t1        LIKE nmy_file.nmyslip    #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
DEFINE  li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-680107 SMALLINT
   LET g_nni_t.* = g_nni.*
   DISPLAY BY NAME g_nni.nnioriu,g_nni.nniorig,
          g_nni.nni01,g_nni.nni02,g_nni.nni03,   #No.MOD-910025
          g_nni.nni04,g_nni.nni05,
          g_nni.nni06,g_nni.nni07,g_nni.nni08,g_nni.nni10,g_nni.nni101, #No.FUN-680088
          g_nni.nni09,g_nni.nni22,g_nni.nni21,g_nni.nniglno,g_nni.nniconf,
          g_nni.nni11,g_nni.nni12,g_nni.nni13,
          g_nni.nni14,g_nni.nni15,g_nni.nni16,
          g_nni.nniuser,g_nni.nnimodu,g_nni.nnidate,  #TQC-9B0069 
          g_nni.nnigrup,g_nni.nniacti,                #TQC-9B0069
          g_nni.nniud01,g_nni.nniud02,g_nni.nniud03,g_nni.nniud04,
          g_nni.nniud05,g_nni.nniud06,g_nni.nniud07,g_nni.nniud08,
          g_nni.nniud09,g_nni.nniud10,g_nni.nniud11,g_nni.nniud12,
          g_nni.nniud13,g_nni.nniud14,g_nni.nniud15 
   CALL t740_nni05('d')
   CALL t740_nni06('d')
   CALL t740_b_fill(' 1=1')
   LET g_t1 = s_get_doc_no(g_nni.nni01)       #No.FUN-550057
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
#  CALL s_check_no("anm",g_nni.nni01,"","6","","","")          #No.MOD-B30156  Mark
#  RETURNING li_result,g_nni.nni01                             #No.MOD-B30156  Mark
   #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)     #MOD-A20096 "" modify nniacti  #CHI-C80041 
   IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t740_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nni.nni01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF g_nni.nniconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_nni.nniacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_nni.nni01,'9027',0)
       RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nni01_t = g_nni.nni01
   LET g_nni_o.*=g_nni.*
   LET g_nni_t.*=g_nni.*
   LET g_nni.nnimodu=g_user                     #修改者
   LET g_nni.nnidate = g_today                  #修改日期
   CALL t740_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t740_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nni.*=g_nni_t.*
         CALL t740_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE nni_file SET nni_file.* = g_nni.*    # 更新DB
       WHERE nni01 = g_nni01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","nni_file",g_nni01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      IF g_nni.nni02 != g_nni_t.nni02 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_nni.nni02
          WHERE npp01=g_nni.nni01 AND npp00=6 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN 
            CALL cl_err3("upd","nnp_file",g_nni.nni01,"",STATUS,"","upd nnp02:",1)  #No.FUN-660148
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t740_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nni.nni01,'U')
END FUNCTION
 
FUNCTION t740_npp02(p_npptype)   #No.FUN-680088
DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680088
 
   IF g_nni.nniglno IS NULL OR g_nni.nniglno=' ' THEN
      UPDATE npp_file SET npp02=g_nni.nni02
       WHERE npp01=g_nni.nni01 AND npp00=6 AND npp011=0
         AND nppsys = 'NM'
         AND npptype = p_npptype  #No.FUN-680088
      IF STATUS THEN 
         CALL cl_err3("upd","nnp_file",g_nni.nni01,"",STATUS,"","upd nnp02:",1)  #No.FUN-660148
      END IF
   END IF
END FUNCTION
 
#str FUN-910014 add
FUNCTION t740_x()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_nni.nni01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
  
  #MOD-A20096---add---start---
   IF g_nni.nniconf = 'Y' THEN
      CALL cl_err('','aim1006',0)
      RETURN
   END IF
  #MOD-A20096---add---end---

   BEGIN WORK

   OPEN t740_cl USING g_nni.nni01   #FUN-910014 mod
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t740_cl INTO g_nni.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t740_show()

   IF cl_exp(0,0,g_nni.nniacti) THEN                   #確認一下
      LET g_chr=g_nni.nniacti      
      IF g_nni.nniacti='Y' THEN
         LET g_nni.nniacti='N'
      ELSE
         LET g_nni.nniacti='Y'
      END IF

      UPDATE nni_file SET nniacti=g_nni.nniacti,
                          nnimodu=g_user,
                          nnidate=g_today
       WHERE nni01=g_nni.nni01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
         LET g_nni.nniacti=g_chr
      END IF
   END IF

   CLOSE t740_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT nniacti,nnimodu,nnidate
     INTO g_nni.nniacti,g_nni.nnimodu,g_nni.nnidate FROM nni_file
    WHERE nni01=g_nni.nni01
   DISPLAY BY NAME g_nni.nniacti,g_nni.nnimodu,g_nni.nnidate
   #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)     #MOD-A20096 add #CHI-C80041
   IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041

END FUNCTION
#end FUN-910014 add

FUNCTION t740_r()
   DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nni.nni01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF g_nni.nniconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   SELECT count(*) INTO l_cnt FROM nmd_file WHERE nmd01 = g_nni.nni21
   IF l_cnt > 0 THEN
      CALL cl_err(g_nni.nni01,'aap-235',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF
   CALL t740_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nni01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nni.nni01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM nni_file WHERE nni01 = g_nni.nni01
      IF STATUS THEN 
         CALL cl_err3("del","nni_file",g_nni.nni01,"",STATUS,"","del nni:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM nnj_file WHERE nnj01 = g_nni.nni01
      IF STATUS THEN 
         CALL cl_err3("del","nnj_file",g_nni.nni01,"",STATUS,"","del nnj:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM npp_file
       WHERE nppsys='NM' AND npp00=6 AND npp01=g_nni.nni01 AND npp011=0
      IF STATUS THEN 
         CALL cl_err3("del","nnp_file",g_nni.nni01,"",STATUS,"","del nnp:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM npq_file
       WHERE npqsys='NM' AND npq00=6 AND npq01=g_nni.nni01 AND npq011=0
      IF STATUS THEN 
         CALL cl_err3("del","npq_file",g_nni.nni01,"",STATUS,"","del npq:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF

 
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_nni.nni01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_nni.nni01,"",STATUS,"","del tic:",1)
         ROLLBACK WORK
         RETURN
      END IF
      #FUN-B40056--add--end--
      INITIALIZE g_nni.* TO NULL
      #TQC-C70054--add--str--
      OPEN t740_count
      FETCH t740_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t740_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t740_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE     
         CALL t740_fetch('/')
      END IF
      #TQC-C70054--add--end--
   END IF
   CLOSE t740_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nni.nni01,'D')
   #CLEAR FORM     #TQC-C70054  mark
   #CALL g_nnj.clear()   #TQC-C70054  mark
END FUNCTION
 
FUNCTION t740_g_np()
   DEFINE l_nmd       RECORD LIKE nmd_file.*
   DEFINE l_nmf       RECORD LIKE nmf_file.*
   DEFINE l_n         LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE l_msg       LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(60)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-560002  #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF g_nni.nniconf = 'N' THEN RETURN END IF
   IF g_nni.nni07 != '1' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM nmd_file WHERE nmd01=g_nni.nni21
   IF l_n>0 THEN
      CALL cl_getmsg('aap-741',g_lang) RETURNING l_msg
      ERROR l_msg CLIPPED  RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF
   INITIALIZE l_nmd.* TO NULL
   LET g_nni_t.* = g_nni.*
 
   IF cl_null(g_nni.nni21) THEN
      LET g_t1 = s_get_doc_no(g_nni.nni21)
      CALL q_nmy(FALSE,FALSE,g_t1,'1','ANM') RETURNING g_t1
      LET g_nni.nni21= g_t1
   END IF
   LET l_nmd.nmd01=g_nni.nni21
    CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nni.nni02,"1","","","","","")
         RETURNING li_result,l_nmd.nmd01
    IF (NOT li_result) THEN
        ROLLBACK WORK
        RETURN
    END IF
   LET l_nmd.nmd03=g_nni.nni06
   LET l_nmd.nmd04=g_nni.nni12
   LET l_nmd.nmd05=g_nni.nni02
   LET l_nmd.nmd07=g_nni.nni02
   LET l_nmd.nmd08=g_nni.nni05
   SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09
     FROM alg_file WHERE alg01=l_nmd.nmd08
   LET l_nmd.nmd10=g_nni.nni01
   CALL cl_getmsg('anm-959',g_lang) RETURNING g_msg
   LET l_nmd.nmd11=g_msg
   LET l_nmd.nmd12='X'
   LET l_nmd.nmd13=g_nni.nni02
   LET l_nmd.nmd14='3'
   LET l_nmd.nmd19=1
   LET l_nmd.nmd21=g_nni.nni08
   LET l_nmd.nmd23=g_nni.nni10
   IF g_aza.aza63 = 'Y' THEN
      LET l_nmd.nmd231=g_nni.nni101
   END IF
   LET l_nmd.nmd23=g_nni.nni10
   LET l_nmd.nmd26=g_nni.nni14
   LET l_nmd.nmd30='N'
   LET l_nmd.nmduser=g_user
   LET l_nmd.nmdgrup=g_grup
   LET l_nmd.nmddate=TODAY
   LET l_nmd.nmd34 = g_plant
   MESSAGE l_nmd.nmd01
    LET l_nmd.nmd33=l_nmd.nmd19
   LET l_nmd.nmdlegal= g_legal
   LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nmd_file VALUES(l_nmd.*)
   IF STATUS THEN
      CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1)  #No.FUN-660148
      ROLLBACK WORK RETURN 
   END IF
   INITIALIZE l_nmf.* TO NULL
   LET l_nmf.nmf01=l_nmd.nmd01
   LET l_nmf.nmf02=g_nni.nni02
   LET l_nmf.nmf03="1"
   LET l_nmf.nmf04=g_user
    LET l_nmf.nmf05='0'          #No.MOD-510038
   LET l_nmf.nmf06='X'
   LET l_nmf.nmf07=l_nmd.nmd08
   LET l_nmf.nmf08=0
   LET l_nmf.nmf09=l_nmd.nmd19
   LET l_nmf.nmflegal= g_legal
   INSERT INTO nmf_file VALUES(l_nmf.*)            # 注意多工廠環境
   IF STATUS THEN
      CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf:",1)  #No.FUN-660148
      ROLLBACK WORK RETURN 
   END IF
   UPDATE nni_file SET nni21=l_nmd.nmd01 WHERE nni01=g_nni.nni01
   IF STATUS THEN
      CALL cl_err3("upd","nni_file",g_nni.nni01,"",STATUS,"","upd nni21:",1)  #No.FUN-660148
      ROLLBACK WORK RETURN
   END IF
   COMMIT WORK
   SELECT nni21 INTO g_nni.nni21 FROM nni_file WHERE nni01=g_nni.nni01
   DISPLAY BY NAME g_nni.nni21
   LET g_msg="anmt100 '",g_nni.nni21,"'"
   CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
END FUNCTION
 
FUNCTION t740_del_np()
   DEFINE l_nmd      RECORD LIKE nmd_file.*
   DEFINE l_nmf      RECORD LIKE nmf_file.*
   DEFINE l_n        LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE l_msg      LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(60)
   DEFINE l_nni21    LIKE nni_file.nni21
 
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF g_nni.nniconf = 'N' THEN RETURN END IF
   IF g_nni.nni07 != '1' THEN RETURN END IF
   IF g_nni.nni21 IS NULL THEN RETURN END IF
   SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=g_nni.nni21
   IF STATUS THEN 
      CALL cl_err3("sel","nmd_file",g_nni.nni21,"","anm-221","","",1)  #No.FUN-660148
      RETURN  END IF
   IF l_nmd.nmd12 <> 'X' OR (l_nmd.nmd02 IS NOT NULL AND l_nmd.nmd02<>' ') THEN    #No:8041
      CALL cl_err(l_nmd.nmd12,'anm-236',0)
      RETURN
   END IF
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success='Y'
   DELETE FROM nmd_file WHERE nmd01 = g_nni.nni21
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","nmd_file",g_nni.nni21,"",STATUS,"","del nmd",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   DELETE FROM nmf_file WHERE nmf01 = g_nni.nni21
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","nmf_file",g_nni.nni21,"",STATUS,"","del nmf",1)  #No.FUN-660148
      LET g_success = 'N' 
   END IF
    LET l_nni21 = s_get_doc_no(g_nni.nni21)       #No.FUN-550057
   UPDATE nni_file SET nni21 = l_nni21
    WHERE nni01 = g_nni.nni01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","nni_file",g_nni.nni01,"",STATUS,"","upd nni",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   SELECT nni21 INTO g_nni.nni21 FROM nni_file WHERE nni01=g_nni.nni01
   DISPLAY BY NAME g_nni.nni21
END FUNCTION
 
FUNCTION t740_firm1()
   DEFINE l_n   LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_npq03    LIKE npq_file.npq03  #CHI-A40018 add
   DEFINE l_npq07    LIKE npq_file.npq07  #CHI-A40018 add
   DEFINE l_nni14    LIKE nni_file.nni14  #CHI-A40018 add
#CHI-C30107 ------------ add ----------- begin
   IF g_nni.nniconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM nnj_file
    WHERE nnj01=g_nni.nni01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF g_nni.nniacti = 'N' THEN
      CALL cl_err('','9027',1)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add ----------- end
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF g_nni.nniconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM nnj_file
    WHERE nnj01=g_nni.nni01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
  #MOD-A20096---add---start---
   IF g_nni.nniacti = 'N' THEN
      CALL cl_err('','9027',1) 
      RETURN
   END IF
  #MOD-A20096---add---end---
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nni.nni02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_nni.nni01,'aap-176',1) RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   CALL s_get_bookno(YEAR(g_nni.nni02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nni.nni02),'aoo-081',1)
      RETURN
   END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF

   #CHI-A40018 add --start--
   IF cl_null(g_nni.nni14) THEN 
      LET l_nni14 = 0
   ELSE
      LET l_nni14=g_nni.nni14
   END IF
   DECLARE t740_c2 CURSOR FOR
      SELECT npq03 FROM npq_file
       WHERE npqsys = "NM" 
         AND npq00= 6
         AND npq01=g_nni.nni01  
         AND npq011= 0 
   FOREACH t740_c2 INTO l_npq03
      IF l_npq03 = g_nni.nni10 THEN
        #SELECT npq07 INTO l_npq07              #MOD-C30870 mark
         SELECT SUM(npq07) INTO l_npq07         #MOD-C30870 add
           FROM npq_file
          WHERE npqsys = "NM" 
            AND npq00= 6
            AND npq01=g_nni.nni01  
            AND npq011= 0 
            AND npqtype='0'
            AND npq03=l_npq03
      
         IF l_nni14 <> l_npq07 THEN
            CALL cl_err(g_nni.nni01,'aap-065',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF                                                      #MOD-C30870 add

     #IF g_aza.aza63 = 'Y' THEN                                   #MOD-C30870 mark
      IF g_aza.aza63 = 'Y' AND l_npq03 = g_nni.nni101  THEN       #MOD-C30870 add
        #SELECT npq07 INTO l_npq07                                #MOD-C30870 mark 
         SELECT SUM(npq07) INTO l_npq07                           #MOD-C30870 add
           FROM npq_file
          WHERE npqsys = "NM" 
            AND npq00= 6
            AND npq01=g_nni.nni01  
            AND npq011= 0 
            AND npqtype='1'
            AND npq03=l_npq03
   
         IF l_nni14 <> l_npq07 THEN
            CALL cl_err(g_nni.nni01,'aap-065',1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
     #END IF                                                         #MOD-C30870 mark
   END FOREACH
   IF g_success='N' THEN RETURN END IF
   #CHI-A40018 add --end--

   LET g_t1 = s_get_doc_no(g_nni.nni01)     #No.FUN-670060 
   SELECT nmydmy3,nmyglcr INTO g_nmy.nmydmy3,g_nmy.nmyglcr FROM nmy_file WHERE nmyslip = g_t1    #No.FUN-670060
   IF g_nmy.nmydmy3 = 'Y'AND g_nmy.nmyglcr = 'N' THEN  #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      CALL s_chknpq(g_nni.nni01,'NM',0,'0',g_bookno1)        #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_nni.nni01,'NM',0,'1',g_bookno2)       #No.FUN-730032
      END IF
   END IF
   LET g_nni.nniconf ='Y'
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      CALL s_get_doc_no(g_nni.nni01) RETURNING g_t1
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
      SELECT count(*) INTO l_n FROM npq_file 
       WHERE npqsys='NM' AND npq00=6 AND npq01=g_nni.nni01 AND npq011=0 
       IF l_n = 0 THEN
         CALL t740_gen_glcr(g_nni.*,g_nmy.*)
       END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_nni.nni01,'NM',0,'0',g_bookno1)        #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nni.nni01,'NM',0,'1',g_bookno2)       #No.FUN-730032
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF   #No.FUN-680088
   END IF
   UPDATE nni_file SET nniconf = 'Y' WHERE nni01 = g_nni.nni01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","nni_file",g_nni.nni01,"",SQLCA.sqlcode,"","upd nniconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CALL t740_y1()
   CALL s_showmsg() #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_nni.nni01,'Y')
      LET g_nni.nniconf = 'Y'
      DISPLAY BY NAME g_nni.nniconf
   ELSE
      ROLLBACK WORK
      LET g_nni.nniconf ='N'
   END IF
   DISPLAY BY NAME g_nni.nniconf
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_nni.nni01,'" AND npp011 = 0'
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0'  'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nni.nni02,"' 'Y' '1' 'Y'"   #No.FUN-680088 #FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT nniglno INTO g_nni.nniglno FROM nni_file
       WHERE nni01 = g_nni.nni01
      DISPLAY BY NAME g_nni.nniglno
   END IF
   #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)  #MOD-AC0073  #CHI-C80041
   IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041   
 
END FUNCTION
 
FUNCTION t740_y1()
   DECLARE t740_y1_c CURSOR FOR
      SELECT * FROM nnj_file WHERE nnj01=g_nni.nni01
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t740_y1_c INTO b_nnj.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         LET g_success='N'        #FUN-8A0086 
         EXIT FOREACH 
      END IF
      MESSAGE b_nnj.nnj02
      IF b_nnj.nnj12 IS NULL THEN       #該筆到單尚未輸入還息資料!
         CALL s_errmsg('','',b_nnj.nnj03,'aap-705',1)     #No.FUN-710023
         LET g_success='N'
         CONTINUE FOREACH    #No.FUN-710024
      END IF
      CALL t740_upd_nnm()
      CALL t740_upd_nne()
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF g_nni.nni07='2' THEN CALL t740_ins_nme() END IF
 
END FUNCTION
 
FUNCTION t740_upd_nnm()
   IF b_nnj.nnj04='1' THEN
      UPDATE nnm_file SET nnm13 = g_nni.nni01
       WHERE nnm01=b_nnj.nnj03
         AND nnm02=YEAR(b_nnj.nnj05)    #MOD-8C0174 mod nnj06->nnj05
         AND nnm03=MONTH(b_nnj.nnj05)   #MOD-8C0174 mod nnj06->nnj05
   ELSE
      UPDATE nnm_file SET nnm13 = g_nni.nni01
       WHERE nnm01=b_nnj.nnj03
         AND (nnm13 IS NULL OR nnm13 = ' ')    #MOD-7C0216
   END IF
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nnm01',b_nnj.nnj03,'upd nnm13:',SQLCA.SQLCODE,1)  #No.FUN-710024
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t740_upd_nne()
   DEFINE l_nne33  LIKE nne_file.nne33,        #No:8614
          l_nng26  LIKE nng_file.nng26         #No:8614
     IF b_nnj.nnj09='1' THEN
        #No:8614以下整段修改
        UPDATE nne_file SET nne14 = b_nnj.nnj08
         WHERE nne01 = b_nnj.nnj03 AND nne09='2'
        IF SQLCA.SQLCODE THEN
           LET g_showmsg = b_nnj.nnj03,"/",'2'          #No.FUN-710024
           CALL s_errmsg('nne01,nne09',g_showmsg,'upd nne14:',SQLCA.SQLCODE,1)    #No.FUN-710024
           LET g_success='N'
        END IF
        SELECT nne33 INTO l_nne33 FROM nne_file
         WHERE nne01 = b_nnj.nnj03 AND nne09='2'
        IF g_nni.nni02 > l_nne33 OR cl_null(l_nne33) THEN
           UPDATE nne_file SET nne33 = b_nnj.nnj06   #MOD-9A0012 add
            WHERE nne01 = b_nnj.nnj03
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('nne01',b_nnj.nnj03,'upd nne33:',SQLCA.SQLCODE,1)    #No.FUN-710024
              LET g_success='N'
           END IF
        END IF
     ELSE
        UPDATE nng_file SET nng09 = b_nnj.nnj08
         WHERE nng01 = b_nnj.nnj03 AND nng14='2'
        IF SQLCA.SQLCODE THEN
           LET g_showmsg = b_nnj.nnj03,"/",'2'         #No.FUN-710024
           CALL s_errmsg('nng0,nng14',g_showmsg,'upd nng09',SQLCA.SQLCODE,1)    #No.FUN-710024
           LET g_success='N'
        END IF
        SELECT nng26 INTO l_nng26 FROM nng_file
         WHERE nng01 = b_nnj.nnj03 AND nng14='2'
        IF g_nni.nni02 > l_nng26 OR cl_null(l_nng26)  THEN
           UPDATE nng_file SET nng26 = b_nnj.nnj06     #MOD-9A0012 add
            WHERE nng01 = b_nnj.nnj03
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('nng01',b_nnj.nnj03,'upd nng26:',SQLCA.SQLCODE,1)    #No.FUN-710024
              LET g_success='N'
           END IF
        END IF
      END IF
END FUNCTION
 
FUNCTION t740_ins_nme()
   DEFINE l_azi04 LIKE azi_file.azi04
   DEFINE l_nme   RECORD LIKE nme_file.*

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
   LET l_nme.nme01=g_nni.nni06
   LET l_nme.nme02=g_nni.nni02
   LET l_nme.nme03=g_nni.nni22
   LET l_nme.nme04=g_nni.nni12
   LET l_nme.nme06=g_nni.nni10
   IF g_aza.aza63 = 'Y' THEN
      LET l_nme.nme061=g_nni.nni101
   END IF
   LET l_nme.nme07=g_nni.nni09
   LET l_nme.nme08=g_nni.nni14
   LET l_nme.nme10=g_nni.nniglno
   LET l_nme.nme12=g_nni.nni01
   LET l_nme.nme14 = ''
   SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
     WHERE nmc01 = g_nni.nni22 AND nmcacti = 'Y'
  #付款幣別與利息幣別相同, 以單身原/本幣金額出帳   #MOD-D20008一律依存入銀行角度寫入
  #IF g_nni.nni08 = g_nni.nni04 THEN               #MOD-D20008 mark
      LET l_nme.nme04=g_nni.nni12
      LET l_nme.nme07=g_nni.nni09
      LET l_nme.nme08=g_nni.nni14
  #ELSE  # 否則以付款幣別為準                      #MOD-D20008 mark
  #   LET l_nme.nme04=g_nni.nni14                  #MOD-D20008 mark
  #   LET l_nme.nme07=1                            #MOD-D20008 mark
  #   LET l_nme.nme08=g_nni.nni14                  #MOD-D20008 mark
   SELECT alg02 INTO l_nme.nme13 FROM alg_file where alg01=g_nni.nni05
   IF STATUS THEN LET l_nme.nme13=g_nni.nni05 END IF
   LET l_nme.nme16=g_nni.nni02
   LET l_nme.nme17=g_nni.nni01
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_azi04 = 0
   SELECT azi04 INTO t_azi04 FROM azi_file, nma_file  #NO.CHI-6A0004
    WHERE azi01 = nma10 AND nma01 = l_nme.nme01
   IF NOT cl_null(t_azi04) THEN                                   #NO.CHI-6A0004
      CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04   #NO.CHI-6A0004
   END IF
   LET l_nme.nme21 = b_nnj.nnj02
   LET l_nme.nme22 = '16'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = g_nni.nni05
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
      CALL s_errmsg('nme02',l_nme.nme02,'ins nme:',STATUS,1) #No.FUN-710024
      LET g_success='N' END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062    
END FUNCTION
 
FUNCTION t740_firm2()
   DEFINE  l_aba19        LIKE aba_file.aba19   #No.FUN-670060
   DEFINE  l_dbs          STRING                #No.FUN-670060
   DEFINE  l_sql          STRING                #No.FUN-670060
   
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
  #MOD-A20096---add---start---
   IF g_nni.nniacti = 'N' THEN
      CALL cl_err('','9027',1) 
      RETURN
   END IF
  #MOD-A20096---add---end---
   IF g_nni.nniconf='N' THEN RETURN END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nni.nni02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nni.nni01,'aap-176',1) RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   IF g_nni.nni21 IS NOT NULL THEN   #若已開票,則不可取消確認
      SELECT COUNT(*) INTO g_cnt FROM nmd_file WHERE nmd01=g_nni.nni21
      IF g_cnt > 0 THEN
         CALL cl_err(g_nni.nni01,'anm-958',0) RETURN
      END IF
   END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nni.nniglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nniglno INTO g_nni.nniglno FROM nni_file
       WHERE nni01 = g_nni.nni01
      IF NOT cl_null(g_nni.nniglno) THEN
         CALL cl_err(g_nni.nniglno,'aap-929',0) 
         RETURN
      END IF
      DISPLAY BY NAME g_nni.nniglno
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_nni.nni01) RETURNING g_t1 
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nni.nniglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nni.nni01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nni.nniglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nni.nniglno,'axr-071',1)
         RETURN
      END IF
   END IF
   
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF
   LET g_success='Y'
   LET g_nni.nniconf ='N'
   UPDATE nni_file SET nniconf = 'N' WHERE nni01 = g_nni.nni01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","nni_file",g_nni.nni01,"",SQLCA.sqlcode,"","upd nniconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   CALL t740_y2()
   CALL s_showmsg() #No.FUN-710024
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_nni.nniconf ='N'
   ELSE
      ROLLBACK WORK
      LET g_nni.nniconf ='Y'
   END IF
   DISPLAY BY NAME g_nni.nniconf
  
   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nni.nniglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT nniglno INTO g_nni.nniglno FROM nni_file
   #    WHERE nni01 = g_nni.nni01
   #   DISPLAY BY NAME g_nni.nniglno
   #END IF
   #CHI-C90052 mark end-----
 
END FUNCTION
 
FUNCTION t740_y2()
   DECLARE t740_y2_c CURSOR FOR
      SELECT * FROM nnj_file WHERE nnj01=g_nni.nni01
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t740_y2_c INTO b_nnj.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      MESSAGE b_nnj.nnj02
      CALL t740_rec_nnm()
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF g_nni.nni07='2' THEN CALL t740_del_nme() END IF
 
END FUNCTION
 
FUNCTION t740_rec_nnm()
   IF b_nnj.nnj04='1' THEN
      UPDATE nnm_file SET nnm13 = NULL
       WHERE nnm01 = b_nnj.nnj03
         AND nnm02=YEAR(b_nnj.nnj05)   #No.MOD-910025
         AND nnm03=MONTH(b_nnj.nnj05)   #No.MOD-910025
   ELSE
      UPDATE nnm_file SET nnm13 = NULL
       WHERE nnm01=b_nnj.nnj03
         AND nnm13=g_nni.nni01   #MOD-7C0216
   END IF
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nnm01',b_nnj.nnj03,'upd nnm13:',SQLCA.SQLCODE,1) #No.FUN-710024
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t740_del_nme()
 DEFINE l_nme24     LIKE nme_file.nme24  #No.FUN-730032
 
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme17='",g_nni.nni01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nni.nni01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 in 
  (SELECT nme12 FROM nme_file
    WHERE nme17 = g_nni.nni01)
   IF STATUS THEN 
      CALL s_errmsg('tic04',g_nni.nni01,'del tic:',STATUS,1)
      LET g_success='N' END IF
 #FUN-B40056  --end
   END IF                 #No.TQC-B70021 
   DELETE FROM nme_file WHERE nme17=g_nni.nni01
   IF STATUS THEN 
      CALL s_errmsg('nme17',g_nni.nni01,'del nme:',STATUS,1) #No.FUN-710024
      LET g_success='N' END IF
END FUNCTION
 
FUNCTION t740_b()
DEFINE l_nne           RECORD LIKE nne_file.*,
       l_nng           RECORD LIKE nng_file.*,
       l_nnm           RECORD LIKE nnm_file.*,
       l_nnl12         LIKE nnl_file.nnl12,     #No:9078
       g_i             LIKE type_file.num5,     #No:9078  #No.FUN-680107 SMALLINT
       s_nne,s_nng     LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1) #SWITCH
       l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680107 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680107 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-680107 VARCHAR(1)
       l_day           LIKE type_file.num5,     #No.FUN-680107 SMALLINT #No:9078
       g_yy            LIKE type_file.num5,     #No.FUN-680107 SMALLINT #No:9078
       g_mm            LIKE type_file.num5,     #No.FUN-680107 SMALLINT #No:9078
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-680107 SMALLINT
       l_allow_delete  LIKE type_file.num5      #可刪除否  #No.FUN-680107 SMALLINT
DEFINE l_date,l_bdate,l_edate LIKE type_file.dat   #MOD-680099
DEFINE l_cnt           LIKE type_file.num5      #MOD-680099
DEFINE l_nnn03         LIKE nnn_file.nnn03      #MOD-7C0230
DEFINE l_errno         LIKE type_file.chr2      #No.MOD-830093
DEFINE l_rate          LIKE nni_file.nni09      #MOD-9B0059 add
DEFINE l_j09t          LIKE nne_file.nne12      #MOD-C30023 add
DEFINE l_j09g          LIKE nne_file.nne19      #MOD-C30023 add
DEFINE l_yy            LIKE type_file.num5      #MOD-D30039 add
DEFINE l_mm            LIKE type_file.num5      #MOD-D30039 add
DEFINE l_nne12         LIKE nne_file.nne12      #MOD-D30039 add
DEFINE l_nne27         LIKE nne_file.nne27      #MOD-D30039 add
DEFINE l_nng20         LIKE nng_file.nng20      #MOD-D30039 add
DEFINE l_nng21         LIKE nng_file.nng21      #MOD-D30039 add
DEFINE l_nnl11         LIKE nnl_file.nnl11      #CHI-D50031 add
DEFINE l_nnl13         LIKE nnl_file.nnl17      #CHI-D50031 add
 
    LET g_action_choice = ""
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
    IF g_nni.nniconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF cl_null(g_nni.nni01) THEN RETURN END IF
 
    SELECT COUNT(*) INTO l_n FROM nnj_file WHERE nnj01 = g_nni.nni01
    IF l_n = 0 THEN
       IF cl_confirm('aap-702') THEN   #MOD-5C0128
          CALL t740_g_b()
          CALL t740_b_fill('1=1')
       END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
         "SELECT nnj02,nnj09,nnj03,nnj04,'',",
         "       nnj05,nnj06,nnj07,nnj08,'',",                #CHI-B80051 add '' 
         "       '',nnj11,nnj13,nnj12,nnj14,nnj15,",          #CHI-B80051 add '' 
         "       nnj16,nnjud01,nnjud02,nnjud03,nnjud04,",
         "       nnjud05,nnjud06,nnjud07,nnjud08,nnjud09,",
         "       nnjud10,nnjud11,nnjud12,nnjud13,nnjud14,",
         "       nnjud15",
         "       FROM nnj_file",
         " WHERE nnj01=? AND nnj02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t740_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nnj WITHOUT DEFAULTS FROM s_nnj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
          CALL t740_set_entry_b()
          CALL t740_set_no_entry_b()
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN t740_cl USING g_nni.nni01
           IF STATUS THEN
              CALL cl_err("OPEN t740_cl:", STATUS, 1)
              CLOSE t740_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t740_cl INTO g_nni.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
               CLOSE t740_cl ROLLBACK WORK RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_nnj_t.* = g_nnj[l_ac].*  #BACKUP
              OPEN t740_bcl USING g_nni.nni01,g_nnj_t.nnj02
              IF STATUS THEN
                 CALL cl_err("OPEN t740_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t740_bcl INTO g_nnj[l_ac].*
             #------------------------MOD-C30023------------------start
              LET l_j09t = ''
              LET l_j09g = ''
              IF g_nnj[l_ac].nnj09 ='1' THEN
                 SELECT nne03,nne12,nne19 INTO l_date,l_j09t,l_j09g
                   FROM nne_file
                  WHERE nne01 = g_nnj[l_ac].nnj03
              ELSE
                 SELECT nng03,nng20,nng22 INTO l_date,l_j09t,l_j09g
                   FROM nng_file
                  WHERE nng01 = g_nnj[l_ac].nnj03
              END IF
             #-----------------CHI-D50031------------------(S)
              SELECT SUM(nnl11),SUM(nnl13) INTO l_nnl11,l_nnl13
                FROM nnl_file,nnk_file
               WHERE nnl04 = g_nnj[l_ac].nnj03
                 AND nnl01 = nnk01
                 AND nnk02 <= g_nnj[l_ac].nnj06
                 AND nnkconf = 'Y'
              IF cl_null(l_nnl11) THEN LET l_nnl11 = 0 END IF
              IF cl_null(l_nnl13) THEN LET l_nnl13 = 0 END IF
              LET g_nnj[l_ac].j09t = l_j09t - l_nnl11
              LET g_nnj[l_ac].j09g = l_j09g - l_nnl13
             #LET g_nnj[l_ac].j09t= l_j09t                   #CHI-D50031 mark
             #LET g_nnj[l_ac].j09g= l_j09g                   #CHI-D50031 mark
             #-----------------CHI-D50031--------------------(E)
              DISPLAY BY NAME g_nnj[l_ac].j09t
              DISPLAY BY NAME g_nnj[l_ac].j09g
             #------------------------MOD-C30023--------------------end
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_nnj_t.nnj02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_nnj[l_ac].date1 = g_nnj_t.date1
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nnj[l_ac].* TO NULL      #900423
           LET g_nnj[l_ac].nnj11 = 0
           LET g_nnj[l_ac].nnj12 = 0
           LET g_nnj[l_ac].nnj13 = 0
           LET g_nnj[l_ac].nnj14 = 0
           LET g_nnj[l_ac].nnj15 = 0
           LET g_nnj[l_ac].nnj16 = 0
           LET g_nnj_t.* = g_nnj[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD nnj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO nnj_file(nnj01,nnj02,nnj09,nnj03,
                                nnj04,nnj05,nnj06,nnj07,nnj08,
                                nnj11,nnj12,nnj13,nnj14,
                                nnj15,nnj16,
                                nnjud01,nnjud02,nnjud03,
                                nnjud04,nnjud05,nnjud06,
                                nnjud07,nnjud08,nnjud09,
                                nnjud10,nnjud11,nnjud12,
                                nnjud13,nnjud14,nnjud15,
                                nnjlegal)  #FUN-980005 add legal 
            VALUES(g_nni.nni01,g_nnj[l_ac].nnj02,g_nnj[l_ac].nnj09,
                   g_nnj[l_ac].nnj03,g_nnj[l_ac].nnj04,
                   g_nnj[l_ac].nnj05,g_nnj[l_ac].nnj06,
                   g_nnj[l_ac].nnj07,g_nnj[l_ac].nnj08,
                   g_nnj[l_ac].nnj11,g_nnj[l_ac].nnj12,
                   g_nnj[l_ac].nnj13,g_nnj[l_ac].nnj14,
                   g_nnj[l_ac].nnj15,g_nnj[l_ac].nnj16,
                   g_nnj[l_ac].nnjud01,g_nnj[l_ac].nnjud02,
                   g_nnj[l_ac].nnjud03,g_nnj[l_ac].nnjud04,
                   g_nnj[l_ac].nnjud05,g_nnj[l_ac].nnjud06,
                   g_nnj[l_ac].nnjud07,g_nnj[l_ac].nnjud08,
                   g_nnj[l_ac].nnjud09,g_nnj[l_ac].nnjud10,
                   g_nnj[l_ac].nnjud11,g_nnj[l_ac].nnjud12,
                   g_nnj[l_ac].nnjud13,g_nnj[l_ac].nnjud14,
                   g_nnj[l_ac].nnjud15,
                   g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nnj_file",g_nni.nni01,g_nnj[l_ac].nnj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
 
        BEFORE FIELD nnj02                        #default 序號
           IF cl_null(g_nnj[l_ac].nnj02) OR g_nnj[l_ac].nnj02 = 0 THEN
              SELECT max(nnj02)+1
                INTO g_nnj[l_ac].nnj02
                FROM nnj_file
               WHERE nnj01 = g_nni.nni01
              IF cl_null(g_nnj[l_ac].nnj02) THEN
                 LET g_nnj[l_ac].nnj02 = 1
              END IF
           END IF
 
        AFTER FIELD nnj02                        #check 序號是否重複
           IF NOT cl_null(g_nnj[l_ac].nnj02)  THEN
              IF g_nnj[l_ac].nnj02 != g_nnj_t.nnj02 OR cl_null(g_nnj_t.nnj02) THEN
                 SELECT count(*) INTO l_n
                   FROM nnj_file
                  WHERE nnj01 = g_nni.nni01
                    AND nnj02 = g_nnj[l_ac].nnj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nnj[l_ac].nnj02 = g_nnj_t.nnj02
                    NEXT FIELD nnj02
                 END IF
              END IF
           END IF
 
        AFTER FIELD nnj09
           IF NOT cl_null(g_nnj[l_ac].nnj09) THEN
              IF g_nnj[l_ac].nnj09 NOT MATCHES '[12]' THEN
                 NEXT FIELD nnj09
              END IF
           END IF
 
        AFTER FIELD nnj03
           IF NOT cl_null(g_nnj[l_ac].nnj03) THEN
              IF g_nnj[l_ac].nnj09 ='1' THEN
                 SELECT * INTO l_nne.* FROM nne_file
                  WHERE nne01 = g_nnj[l_ac].nnj03 
                    AND nne25 = 0
                    AND (nne19 - nne20) > 0               #MOD-C70016 add
                    AND nneconf ='Y'   #No:8024
                 IF STATUS THEN
                    CALL cl_err3("sel","nne_file",g_nnj[l_ac].nnj03,"",STATUS,"","sel nne:",1)  #No.FUN-660148
                    NEXT FIELD nnj03
                 ELSE
                    #-->融資資料之信貸銀行必須與單頭信貸銀行一致
                    IF l_nne.nne04 !=g_nni.nni05 THEN
                       CALL cl_err(l_nne.nne04,'anm-661',0) NEXT FIELD nnj03
                    END IF
                    #TQC-C70010--add--str--
                    IF l_nne.nne19-l_nne.nne20 = 0 THEN
                       CALL cl_err('','anm-632',1) 
                       NEXT FIELD nnj03
                    END IF
                    #TQC-C70010--add--end--
                    LET l_day = l_nne.nne22              #No:9078
                    LET g_nnj[l_ac].nnj04=l_nne.nne08
                    LET g_nnj[l_ac].date1=l_nne.nne03
                    LET g_nnj[l_ac].nnj08=l_nne.nne13    #MOD-D30214
                   #LET g_nnj[l_ac].j09t=l_nne.nne12     #CHI-B80051 add #CHI-D50031 mark
                   #LET g_nnj[l_ac].j09g=l_nne.nne19     #CHI-B80051 add #CHI-D50031 mark
                    DISPLAY BY NAME g_nnj[l_ac].nnj04
                    DISPLAY BY NAME g_nnj[l_ac].date1
                   #DISPLAY BY NAME g_nnj[l_ac].j09g     #CHI-B80051 add #CHI-D50031 mark
                   #DISPLAY BY NAME g_nnj[l_ac].j09t     #CHI-B80051 add #CHI-D50031 mark
                 END IF
              END IF
              IF g_nnj[l_ac].nnj09 ='2' THEN
                 SELECT * INTO l_nng.* FROM nng_file
                  WHERE nng01 = g_nnj[l_ac].nnj03
                    AND nngconf ='Y'                     #No:8024
                    AND (nng22 - nng23 ) > 0             #MOD-C70016 add
                 IF STATUS THEN
                    CALL cl_err3("sel","nng_file",g_nnj[l_ac].nnj03,"",STATUS,"","sel nng:",1)  #No.FUN-660148
                    NEXT FIELD nnj03
                 ELSE
                    #-->融資資料之信貸銀行必須與單頭信貸銀行一致
                    IF l_nng.nng04 !=g_nni.nni05 THEN
                       CALL cl_err(l_nng.nng04,'anm-661',0) NEXT FIELD nnj03
                    END IF
                    #TQC-C70010--add--str--
                    IF l_nng.nng22-l_nng.nng23 = 0 THEN
                       CALL cl_err('','anm-632',1)
                       NEXT FIELD nnj03
                    END IF
                    #TQC-C70010--add--end--
                    LET l_day=l_nng.nng13                   #No:9078
                    LET g_nnj[l_ac].nnj04=l_nng.nng16
                    LET g_nnj[l_ac].date1=l_nng.nng03
                    LET g_nnj[l_ac].nnj08=l_nng.nng09    #MOD-D30214
                   #LET g_nnj[l_ac].j09t=l_nng.nng20     #CHI-B80051 add #CHI-D50031 mark
                   #LET g_nnj[l_ac].j09g=l_nng.nng22     #CHI-B80051 add #CHI-D50031 mark
                    DISPLAY BY NAME g_nnj[l_ac].nnj04
                    DISPLAY BY NAME g_nnj[l_ac].date1
                   #DISPLAY BY NAME g_nnj[l_ac].j09g     #CHI-B80051 add #CHI-D50031 mark
                   #DISPLAY BY NAME g_nnj[l_ac].j09t     #CHI-B80051 add #CHI-D50031 mark
                 END IF
              END IF
             #-------------------MOD-D30039----------------------(S)
              IF g_nni.nni03_m = 1 THEN
                 LET l_yy = g_nni.nni03_y - 1
                 LET l_mm = 12
              ELSE
                 LET l_yy = g_nni.nni03_y
                 LET l_mm = g_nni.nni03_m - 1
              END IF

              LET l_cnt = 0                               #MOD-D30214  
              SELECT COUNT(*) INTO l_cnt FROM nnm_file
                WHERE nnm09 = g_nni.nni04
                  AND nnm14 = g_nni.nni05
                  AND nnm01 = g_nnj[l_ac].nnj03
                  AND nnm02 = l_yy
                  AND nnm03 = l_mm
                  AND nnm13 IS NULL
                  AND nnm16 IS NULL
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF #MOD-D30214
              IF l_cnt = 0 THEN
                 LET l_yy = g_nni.nni03_y
                 LET l_mm = g_nni.nni03_m
                #-MOD-D30214-add-
                 LET l_cnt = 0                             
                 SELECT COUNT(*) INTO l_cnt FROM nnm_file
                   WHERE nnm09 = g_nni.nni04
                     AND nnm14 = g_nni.nni05
                     AND nnm01 = g_nnj[l_ac].nnj03
                     AND nnm02 = l_yy
                     AND nnm03 = l_mm
                     AND nnm13 IS NULL
                     AND nnm16 IS NULL
                 IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
                #-MOD-D30214-end-
              END IF

             #止算日用單頭利息日期的年月+每張單子的日去產生    #MOD-D30214
              LET g_yy = YEAR(g_nni.nni03)       #利息日期的年 #MOD-D30214
              LET g_mm = MONTH(g_nni.nni03)      #利息日期的月 #MOD-D30214
              IF l_cnt <> 0 THEN  #MOD-D30214 
                 SELECT * INTO l_nnm.* FROM nnm_file
                  WHERE nnm09 = g_nni.nni04
                    AND nnm14 = g_nni.nni05
                    AND nnm01 = g_nnj[l_ac].nnj03
                    AND nnm02 = l_yy
                    AND nnm03 = l_mm
                    AND nnm13 IS NULL
                    AND nnm16 IS NULL
               
                 LET g_nnj[l_ac].nnj03 = l_nnm.nnm01
                 LET g_nnj[l_ac].nnj09 = l_nnm.nnm04
                 IF g_nnj[l_ac].nnj09 = '1' THEN
                    SELECT nne22,nne27,nne12
                      INTO l_day,l_nne27,l_nne12
                      FROM nne_file
                     WHERE nne01 = l_nnm.nnm01
                       AND nneconf = 'Y'
                 ELSE
                    SELECT nng13,nng20,nng21
                      INTO l_day,l_nng20,l_nng21
                      FROM nng_file
                     WHERE nng01 = l_nnm.nnm01
                       AND nngconf = 'Y'
                 END IF
                 LET g_nnj[l_ac].nnj05 = l_nnm.nnm05
                #止算日用單頭利息日期的年月+每張單子的日去產生
                #LET g_yy = YEAR(g_nni.nni03)       #利息日期的年 #MOD-D30214 mark
                #LET g_mm = MONTH(g_nni.nni03)      #利息日期的月 #MOD-D30214 mark
                 LET g_nnj[l_ac].nnj06 = MDY(g_mm,l_day,g_yy)
                #利息計算的方式應是算頭不算尾,
                #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
                 LET g_nnj[l_ac].nnj07 = g_nnj[l_ac].nnj06 - g_nnj[l_ac].nnj05
                 LET g_nnj[l_ac].nnj08 = l_nnm.nnm08
               
                 IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17 THEN
                    IF YEAR(g_nnj[l_ac].nnj05) MOD 4 = 0 THEN
                       LET g_i = 366                             #本幣潤年一年採366天
                    ELSE
                       LET g_i = 365                             #本幣一年採365天
                    END IF
                 ELSE
                    LET g_i = 360                                #外幣一年採360天
                 END IF
                 IF g_nnj[l_ac].nnj09 = '1' THEN
                   #原幣利息=(貸款金額-已還金額)*(利率/100/365)*天數
                    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                     WHERE nnl01 = nnk01 AND nnl03 = '1' AND nnl04 = l_nnm.nnm01
                       AND nnk02 > l_nnm.nnm06 AND nnkconf = 'Y'
                    IF cl_null(l_nnl12) THEN LET l_nnl12 = 0 END IF
                    LET l_nne27 = l_nne27 - l_nnl12                      #已還金額
                    LET g_nnj[l_ac].nnj12 = (l_nne12-l_nne27)*(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate = s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12 = cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14 = g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14 = cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)
                 ELSE
                    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                     WHERE nnl01 = nnk01 AND nnl03 = '2' AND nnl04 = l_nnm.nnm01
                       AND nnk02 > l_nnm.nnm06 AND nnkconf = 'Y'
                    IF cl_null(l_nnl12) THEN LET l_nnl12 = 0 END IF
                    LET l_nng21 = l_nng21 - l_nnl12                       #已還金額
                    LET g_nnj[l_ac].nnj12=(l_nng20-l_nng21)*(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12 = cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14 = g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)
                 END IF
                 LET g_nnj[l_ac].nnj11 = l_nnm.nnm11
                 LET g_nnj[l_ac].nnj13 = l_nnm.nnm12
             #-MOD-D30214-add-
              ELSE
                 LET g_nnj[l_ac].nnj05 = MDY(g_mm,1,g_yy)
                 LET l_day = DAY(g_nni.nni03)      #利息日期的日
                 LET g_nnj[l_ac].nnj06 = MDY(g_mm,l_day,g_yy)
                 LET g_nnj[l_ac].nnj07 = g_nnj[l_ac].nnj06 - g_nnj[l_ac].nnj05          
                 IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17 THEN
                    IF YEAR(g_nnj[l_ac].nnj05) MOD 4 = 0 THEN                 
                       LET g_i = 366                             #本幣潤年一年採366天              
                    ELSE                                                      
                       LET g_i = 365                             #本幣一年採365天
                    END IF                                                    
                 ELSE
                    LET g_i = 360                                #外幣一年採360天
                 END IF
                 IF g_nnj[l_ac].nnj09 = '1' THEN
                   #原幣利息=貸款金額*(利率/100/365)*天數
                    LET g_nnj[l_ac].nnj12 = l_nne.nne12*(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate = s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12 = cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14 = g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14 = cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   
                 ELSE
                    LET g_nnj[l_ac].nnj12 = l_nng.nng20*(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12 = cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14 = g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   
                 END IF
                 LET g_nnj[l_ac].nnj11 = 0 
                 LET g_nnj[l_ac].nnj13 = 0  
              END IF     
             #-MOD-D30214-end-

              IF g_nni.nni04 != g_nni.nni08 THEN
                 LET g_nnj[l_ac].nnj15 = (g_nnj[l_ac].nnj14 - g_nnj[l_ac].nnj13)
                 LET g_nnj[l_ac].nnj16 = 0
              ELSE
                 IF cl_null(g_nnj[l_ac].nnj12) THEN
                    LET g_nnj[l_ac].nnj12 = 0
                 END IF
                 LET g_nnj[l_ac].nnj15 = (g_nnj[l_ac].nnj12 - g_nnj[l_ac].nnj11) * g_nni.nni09
                 IF g_nni.nni04 <> g_aza.aza17 THEN
                    LET g_nnj[l_ac].nnj16 = (g_nnj[l_ac].nnj14 - g_nnj[l_ac].nnj13 - g_nnj[l_ac].nnj15)
                 ELSE
                    LET g_nnj[l_ac].nnj16 = 0
                 END IF
              END IF

              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni04
              CALL cl_digcut(g_nnj[l_ac].nnj11,t_azi04) RETURNING g_nnj[l_ac].nnj11
              CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04) RETURNING g_nnj[l_ac].nnj12
              CALL cl_digcut(g_nnj[l_ac].nnj13,g_azi04) RETURNING g_nnj[l_ac].nnj13
              CALL cl_digcut(g_nnj[l_ac].nnj14,g_azi04) RETURNING g_nnj[l_ac].nnj14
              CALL cl_digcut(g_nnj[l_ac].nnj15,g_azi04) RETURNING g_nnj[l_ac].nnj15
              CALL cl_digcut(g_nnj[l_ac].nnj16,g_azi04) RETURNING g_nnj[l_ac].nnj16

              DISPLAY BY NAME g_nnj[l_ac].nnj05
              DISPLAY BY NAME g_nnj[l_ac].nnj06
              DISPLAY BY NAME g_nnj[l_ac].nnj11
              DISPLAY BY NAME g_nnj[l_ac].nnj12
              DISPLAY BY NAME g_nnj[l_ac].nnj13
              DISPLAY BY NAME g_nnj[l_ac].nnj14
              DISPLAY BY NAME g_nnj[l_ac].nnj15
              DISPLAY BY NAME g_nnj[l_ac].nnj16
             #-------------------MOD-D30039----------------------(E)
           END IF
 
        AFTER FIELD nnj05
          #IF g_nnj[l_ac].nnj05 != g_nnj_t.nnj05 THEN         #MOD-A30109 add              #MOD-A40098 mark
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nnj[l_ac].nnj05 != g_nnj_t.nnj05) THEN     #MOD-A40098 add
              IF NOT cl_null(g_nnj[l_ac].nnj05) THEN
                 LET l_cnt=0                                                                                                           
                #IF g_nnj[l_ac].nnj04='1' THEN     #MOD-C90128 mark
                 SELECT COUNT(*) INTO l_cnt FROM nnj_file                                                                           
                  WHERE nnj03=g_nnj[l_ac].nnj03                                                                                     
                    AND YEAR(nnj05)=YEAR(g_nnj[l_ac].nnj05)                                                                         
                    AND MONTH(nnj05)=MONTH(g_nnj[l_ac].nnj05)                                                                       
                    AND ( nnj01!=g_nni.nni01 OR                             #MOD-9B0059 add
                         (nnj01 =g_nni.nni01 AND nnj02!=g_nnj[l_ac].nnj02)) #MOD-9B0059 add
                 IF l_cnt>0 THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM nnj_file
                     WHERE nnj03=g_nnj[l_ac].nnj03
                       AND YEAR(nnj05)=YEAR(g_nnj[l_ac].nnj05)
                       AND MONTH(nnj05)=MONTH(g_nnj[l_ac].nnj05)
                       AND (nnj05 >= g_nnj[l_ac].nnj05
                        OR  nnj06 >= g_nnj[l_ac].nnj05)
                       AND ( nnj01!=g_nni.nni01 OR
                            (nnj01 =g_nni.nni01 AND nnj02!=g_nnj[l_ac].nnj02))
                    IF l_cnt>0 THEN
                       CALL cl_err(g_nnj[l_ac].nnj03,'anm-983',0)
                       NEXT FIELD nnj05
                    END IF
                 END IF
                #---------------------------MOD-C90128--------------------mark
                #ELSE                                                                                                                  
                #   SELECT COUNT(*) INTO l_cnt FROM nnj_file                                                                           
                #    WHERE nnj03=g_nnj[l_ac].nnj03                                                                                     
                #      AND ( nnj01!=g_nni.nni01 OR                             #MOD-9B0059 add
                #           (nnj01 =g_nni.nni01 AND nnj02!=g_nnj[l_ac].nnj02)) #MOD-9B0059 add
                #   IF l_cnt>0 THEN
                #      CALL cl_err(g_nnj[l_ac].nnj03,'anm-983',0)
                #      NEXT FIELD nnj05
                #   END IF
                #END IF                                                                                                                
                #---------------------------MOD-C90128--------------------mark
                #----------------------MOD-CA0018-----------------mark
                #IF g_nnj[l_ac].nnj09 ='1' THEN
                #   IF l_nne.nne112=g_nnj[l_ac].nnj06 THEN
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05
                #   ELSE
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05+1
                #   END IF
                #ELSE
                #   IF l_nng.nng082=g_nnj[l_ac].nnj06 THEN
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05
                #   ELSE
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05+1
                #   END IF
                #END IF
                #----------------------MOD-CA0018-----------------mark
                 LET g_nnj[l_ac].nnj07 = g_nnj[l_ac].nnj06 - g_nnj[l_ac].nnj05     #MOD-CA0018 add
                 DISPLAY BY NAME g_nnj[l_ac].nnj07
                 CALL t740_get_default()
              END IF
           END IF                #MOD-A30109 add
 
        AFTER FIELD nnj06
          #IF g_nnj[l_ac].nnj06 != g_nnj_t.nnj06 THEN         #MOD-A30109 add                  #MOD-A40098 mark
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_nnj[l_ac].nnj06 != g_nnj_t.nnj06) THEN         #MOD-A40098 add
              IF NOT cl_null(g_nnj[l_ac].nnj06) THEN
                IF g_aza.aza26 = '2' THEN     #MOD-950048 add 
                    CALL t740_chk_edate(g_nnj[l_ac].nnj09,g_nnj[l_ac].nnj03,g_nnj[l_ac].nnj06)         #No.MOD-830093
                       RETURNING l_errno
                    CASE l_errno
                      WHEN '01'
                        CALL cl_err('','anm-822',0)
                        NEXT FIELD nnj09
                      WHEN '02'
                        CALL cl_err('','anm-823',0)
                        NEXT FIELD nnj03
                    END CASE 
                END IF                        #MOD-950048 add
                 IF g_nnj[l_ac].nnj06 < g_nnj[l_ac].nnj05 THEN
                    CALL cl_err('',"agl-031",0)
                    NEXT FIELD nnj06
                 END IF
                 LET l_nnn03 = ''
                 SELECT nnn03 INTO l_nnn03 FROM nnn_file,nne_file
                   WHERE nnn01 = nne06  
                     AND nne01 = g_nnj[l_ac].nnj03
                 IF l_nnn03 = '1' THEN  
                    LET l_date = MDY(g_nni.nni03_m,1,g_nni.nni03_y)
                    CALL s_mothck(l_date) RETURNING l_bdate,l_edate
                    IF g_nnj[l_ac].nnj05 < l_bdate OR g_nnj[l_ac].nnj05 > l_edate OR
                       g_nnj[l_ac].nnj06 < l_bdate OR g_nnj[l_ac].nnj06 > l_edate THEN
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM nnm_file
                        WHERE nnm01=g_nnj[l_ac].nnj03
                        # AND nnm02=g_nni.nni03_y AND nnm03=g_nni.nni03_m
                          AND nnm02=YEAR(g_nnj[l_ac].nnj05)   #No.MOD-910025
                          AND nnm03=MONTH(g_nnj[l_ac].nnj05)   #No.MOD-910025
                       IF l_cnt =0 THEN
                          CALL cl_err('','anm-629',0) NEXT FIELD nnj03
                       END IF
                    END IF
                 END IF   #MOD-7C0230
 
                #----------------------MOD-CA0018-----------------mark
                #IF g_nnj[l_ac].nnj09 ='1' THEN
                #   IF l_nne.nne112=g_nnj[l_ac].nnj06 THEN
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05
                #   ELSE
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05+1
                #   END IF
                #ELSE
                #   IF l_nng.nng082=g_nnj[l_ac].nnj06 THEN
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05
                #   ELSE
                #      LET g_nnj[l_ac].nnj07=g_nnj[l_ac].nnj06-g_nnj[l_ac].nnj05+1
                #   END IF
                #END IF
                #----------------------MOD-CA0018-----------------mark
                 LET g_nnj[l_ac].nnj07 = g_nnj[l_ac].nnj06 - g_nnj[l_ac].nnj05     #MOD-CA0018 add
                 DISPLAY BY NAME g_nnj[l_ac].nnj07
                 SELECT COUNT(*) INTO l_n
                       FROM nnm_file
                      WHERE nnm01=g_nnj[l_ac].nnj03
                        AND nnm06>=g_nnj[l_ac].nnj05
                 IF l_n=0 THEN
                    LET g_nnj[l_ac].nnj11 = 0
                    LET g_nnj[l_ac].nnj13 = 0
                    DISPLAY BY NAME g_nnj[l_ac].nnj11
                    DISPLAY BY NAME g_nnj[l_ac].nnj13
                 END IF
                 CALL t740_get_default()
                #IF g_nni.nni04 = g_aza.aza17                           #CHI-A10014 mark
               #-----------------------------MOD-C70284------------------(S)
               #---MOD-C70284 mark
                #IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17     #CHI-A10014 add
                #   THEN LET g_i=365    # 本幣一年採365天
                #   ELSE LET g_i=360    # 外幣一年採360天
                #END IF
               #---MOD-C70284 mark
                 IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17 THEN
                    IF YEAR(g_nnj[l_ac].nnj05) MOD 4 = 0 THEN
                       LET g_i = 366       # 本幣潤年一年採366天
                    ELSE
                       LET g_i = 365       # 本幣一年採365天
                    END IF
                 ELSE
                    LET g_i = 360          # 外幣一年採360天
                 END IF
               #-----------------------------MOD-C70284------------------(E)
                 SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nni.nni04
                 IF g_nnj[l_ac].nnj09 ='1' THEN
                    SELECT * INTO l_nne.* FROM nne_file
                     WHERE nne01 = g_nnj[l_ac].nnj03 AND nne25 = 0
                       AND nneconf ='Y'   #No:8024
                    #** 原幣利息=(貸款金額-已還金額)*(利率/100/365)*天數 ******#
                    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                     WHERE nnl01=nnk01 AND nnl03='1' AND nnl04=g_nnj[l_ac].nnj03   #MOD-680099
                       AND nnk02 > g_nnj[l_ac].nnj06 AND nnkconf='Y'   #MOD-680099
                    IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
                    LET l_nne.nne27 = l_nne.nne27 - l_nnl12    #已還金額
                    #------------------------------------------------------#
                    LET g_nnj[l_ac].nnj12=(l_nne.nne12-l_nne.nne27) *
                        (g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                    CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04)
                         RETURNING g_nnj[l_ac].nnj12
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12=cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14=g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   #MOD-640409
                 ELSE
                    SELECT * INTO l_nng.* FROM nng_file
                     WHERE nng01 = g_nnj[l_ac].nnj03
                       AND nngconf ='Y'     #No:8024
                    SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                     WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=g_nnj[l_ac].nnj03   #MOD-680099
                       AND nnk02 > g_nnj[l_ac].nnj06 AND nnkconf='Y'   #MOD-680099
                    IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
                    LET l_nng.nng21 = l_nng.nng21 - l_nnl12   #已還金額
                    LET g_nnj[l_ac].nnj12=(l_nng.nng20-l_nng.nng21)
                                   *(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                    CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04)
                         RETURNING g_nnj[l_ac].nnj12
                   #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                    IF g_nni.nni04 != g_nni.nni08 THEN
                       LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                       LET g_nnj[l_ac].nnj12=cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                       LET g_nnj[l_ac].nnj14=g_nnj[l_ac].nnj12
                    END IF
                    LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   #MOD-640409
                 END IF
                 DISPLAY BY NAME g_nnj[l_ac].nnj12
                 DISPLAY BY NAME g_nnj[l_ac].nnj14
                #當融資幣別與還息幣別不同時,不應有匯差,全歸入利差
                #-----------------------No.MOD-B80058--------------------------------start
                 CALL t740_nnj15()
                #IF g_nni.nni04 != g_nni.nni08 THEN
                #   LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13)  
                #   LET g_nnj[l_ac].nnj16=0
                #ELSE
                #   LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj12-g_nnj[l_ac].nnj11)*
                #                          g_nni.nni09
                #   IF g_nni.nni04<>g_aza.aza17 THEN
                #      LET g_nnj[l_ac].nnj16=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13
                #                                              -g_nnj[l_ac].nnj15)
                #   ELSE
                #      LET g_nnj[l_ac].nnj16=0
                #   END IF
                #END IF   #MOD-9B0059 add
                #CALL cl_digcut(g_nnj[l_ac].nnj15,g_azi04) RETURNING g_nnj[l_ac].nnj15
                #CALL cl_digcut(g_nnj[l_ac].nnj16,g_azi04) RETURNING g_nnj[l_ac].nnj16
                #-----------------------No.MOD-B80058-----------------------------------end
                 DISPLAY BY NAME g_nnj[l_ac].nnj15
                 DISPLAY BY NAME g_nnj[l_ac].nnj16
                #------------------------CHI-D50031------------------(S)
                 LET l_j09t = ''
                 LET l_j09g = ''
                 LET l_nnl11 = ''
                 LET l_nnl13 = ''
                 IF g_nnj[l_ac].nnj09 = '1' THEN
                    SELECT nne12,nne19 INTO l_j09t,l_j09g
                      FROM nne_file
                     WHERE nne01 = g_nnj[l_ac].nnj03
                 ELSE
                    SELECT nng20,nng22 INTO l_j09t,l_j09g
                      FROM nng_file
                     WHERE nng01 = g_nnj[l_ac].nnj03
                 END IF
                 SELECT SUM(nnl11),SUM(nnl13) INTO l_nnl11,l_nnl13
                   FROM nnl_file,nnk_file
                  WHERE nnl04 = g_nnj[l_ac].nnj03
                    AND nnl01 = nnk01
                    AND nnk02 <= g_nnj[l_ac].nnj06
                    AND nnkconf = 'Y'
                 IF cl_null(l_nnl11) THEN LET l_nnl11 = 0 END IF
                 IF cl_null(l_nnl13) THEN LET l_nnl13 = 0 END IF
                 LET g_nnj[l_ac].j09t = l_j09t - l_nnl11
                 LET g_nnj[l_ac].j09g = l_j09g - l_nnl13
                 DISPLAY BY NAME g_nnj[l_ac].j09t
                 DISPLAY BY NAME g_nnj[l_ac].j09g
                #------------------------CHI-D50031--------------------(E)
              END IF
           END IF                #MOD-A30109 add
 
        AFTER FIELD nnj08
           IF NOT cl_null(g_nnj[l_ac].nnj08) THEN
              IF g_nnj[l_ac].nnj08 = 0 THEN
                 NEXT FIELD nnj8
              END IF
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni04
              CALL cl_digcut(g_nnj[l_ac].nnj11,t_azi04)
                         RETURNING g_nnj[l_ac].nnj11
              CALL cl_digcut(g_nnj[l_ac].nnj13,g_azi04)
                         RETURNING g_nnj[l_ac].nnj13
              DISPLAY BY NAME g_nnj[l_ac].nnj11
              DISPLAY BY NAME g_nnj[l_ac].nnj13
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nni.nni04
              IF g_nnj[l_ac].nnj09 ='1' THEN
                 SELECT * INTO l_nne.* FROM nne_file
                  WHERE nne01 = g_nnj[l_ac].nnj03 AND nne25 = 0
                    AND nneconf ='Y'   #No:8024
                 #** 原幣利息=(貸款金額-已還金額)*(利率/100/365)*天數 ******#
                 SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                  WHERE nnl01=nnk01 AND nnl03='1' AND nnl04=l_nnm.nnm01
                    AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
                 IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
                 LET l_nne.nne27 = l_nne.nne27 - l_nnl12    #已還金額
               #-----------------------------MOD-C70284------------------(S)
               #---MOD-C70284 mark
               ##---------------No.MOD-B80058------------------------start
               # IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17
               #    THEN LET g_i=365    # 本幣一年採365天
               #    ELSE LET g_i=360    # 外幣一年採360天
               # END IF
               ##---------------No.MOD-B80058-------------------------end
               #---MOD-C70284 mark
                 IF g_aza.aza26 = '0' AND g_nni.nni04 = g_aza.aza17 THEN
                    IF YEAR(g_nnj[l_ac].nnj05) MOD 4 = 0 THEN
                       LET g_i = 366       # 本幣潤年一年採366天
                    ELSE
                       LET g_i = 365       # 本幣一年採365天
                    END IF
                 ELSE
                    LET g_i = 360          # 外幣一年採360天
                 END IF
               #-----------------------------MOD-C70284------------------(E)
                 LET g_nnj[l_ac].nnj12=(l_nne.nne12-l_nne.nne27) *
                     (g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                 CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04)
                      RETURNING g_nnj[l_ac].nnj12
                #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                 IF g_nni.nni04 != g_nni.nni08 THEN
                    LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                    LET g_nnj[l_ac].nnj12=cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                    LET g_nnj[l_ac].nnj14=g_nnj[l_ac].nnj12
                 END IF
                 LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   #MOD-640409
              ELSE
                 SELECT * INTO l_nng.* FROM nng_file
                  WHERE nng01 = g_nnj[l_ac].nnj03
                    AND nngconf ='Y'     #No:8024
                 SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
                  WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=l_nnm.nnm01
                    AND nnk02 > l_nnm.nnm06 AND nnkconf='Y'
                 IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
                 LET l_nng.nng21 = l_nng.nng21 - l_nnl12   #已還金額
                 LET g_nnj[l_ac].nnj12=(l_nng.nng20-l_nng.nng21)
                                *(g_nnj[l_ac].nnj08/100/g_i)*g_nnj[l_ac].nnj07
                 CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04)
                      RETURNING g_nnj[l_ac].nnj12
                #當融資幣別與還息幣別不同時,應該再將算出的利息金額換算成這次還息的幣別金額
                 IF g_nni.nni04 != g_nni.nni08 THEN
                    LET l_rate=s_exrate(g_nni.nni04,g_nni.nni08,"S")
                    LET g_nnj[l_ac].nnj12=cl_digcut(g_nnj[l_ac].nnj12*l_rate,g_azi04)
                    LET g_nnj[l_ac].nnj14=g_nnj[l_ac].nnj12
                 END IF
                 LET g_nnj[l_ac].nnj14=cl_digcut(g_nnj[l_ac].nnj12*g_nni.nni09,g_azi04)   #MOD-640409
              END IF
           END IF
           DISPLAY BY NAME g_nnj[l_ac].nnj12
           DISPLAY BY NAME g_nnj[l_ac].nnj14
 
        AFTER FIELD nnj12
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nni.nni04
           CALL cl_digcut(g_nnj[l_ac].nnj12,t_azi04) RETURNING g_nnj[l_ac].nnj12
           LET g_nnj[l_ac].nnj14=g_nnj[l_ac].nnj12*g_nni.nni09
           CALL cl_digcut(g_nnj[l_ac].nnj14,g_azi04) RETURNING g_nnj[l_ac].nnj14
           CALL t740_nnj15()                                                     #No.MOD-B80058 add
           DISPLAY BY NAME g_nnj[l_ac].nnj12
           DISPLAY BY NAME g_nnj[l_ac].nnj14
           DISPLAY BY NAME g_nnj[l_ac].nnj15                                     #No.MOD-B80058 add
 
        AFTER FIELD nnj14
           CALL cl_digcut(g_nnj[l_ac].nnj14,g_azi04) RETURNING g_nnj[l_ac].nnj14
           SELECT COUNT(*) INTO g_cnt FROM nnm_file
            WHERE nnm01=g_nnj[l_ac].nnj03
              AND nnm02=YEAR(g_nnj[l_ac].nnj05)   #No.MOD-910025
              AND nnm03=MONTH(g_nnj[l_ac].nnj05)   #No.MOD-910025
           #當融資幣別與還息幣別不同時,不應有匯差,全歸入利差
           #----------------------------No.MOD-B80058-----------------------------start
           #IF g_nni.nni04 != g_nni.nni08 THEN
           #   LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13)  
           #   LET g_nnj[l_ac].nnj16=0
           #ELSE
           #   LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj12-g_nnj[l_ac].nnj11)*  #CHI-8A0019 mark回復
           #                          g_nni.nni09                            #CHI-8A0019 mark回復
           #   IF g_nni.nni04<>g_aza.aza17 THEN
           #      LET g_nnj[l_ac].nnj16=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13
           #                                              -g_nnj[l_ac].nnj15)
           #   ELSE
           #      LET g_nnj[l_ac].nnj16=0
           #   END IF
           #END IF   #MOD-9B0059 add
           #CALL cl_digcut(g_nnj[l_ac].nnj15,g_azi04)
           #               RETURNING g_nnj[l_ac].nnj15
           #CALL cl_digcut(g_nnj[l_ac].nnj16,g_azi04)
           #               RETURNING g_nnj[l_ac].nnj16
           #----------------------------No.MOD-B80058-----------------------------end
            DISPLAY BY NAME g_nnj[l_ac].nnj14
            DISPLAY BY NAME g_nnj[l_ac].nnj15
            DISPLAY BY NAME g_nnj[l_ac].nnj16
 
        AFTER FIELD nnjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_nnj_t.nnj02 > 0 AND g_nnj_t.nnj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM nnj_file
               WHERE nnj01 = g_nni.nni01
                 AND nnj02 = g_nnj_t.nnj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nnj_file",g_nni.nni01,g_nnj_t.nnj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              COMMIT WORK
              CALL t740_b_tot()
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nnj[l_ac].* = g_nnj_t.*
              CLOSE t740_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nnj[l_ac].nnj02,-263,1)
              LET g_nnj[l_ac].* = g_nnj_t.*
           ELSE
              UPDATE nnj_file SET nnj02 = g_nnj[l_ac].nnj02,
                                  nnj09 = g_nnj[l_ac].nnj09,
                                  nnj03 = g_nnj[l_ac].nnj03,
                                  nnj04 = g_nnj[l_ac].nnj04,
                                  nnj05 = g_nnj[l_ac].nnj05,
                                  nnj06 = g_nnj[l_ac].nnj06,
                                  nnj07 = g_nnj[l_ac].nnj07,
                                  nnj08 = g_nnj[l_ac].nnj08,
                                  nnj11 = g_nnj[l_ac].nnj11,
                                  nnj12 = g_nnj[l_ac].nnj12,
                                  nnj13 = g_nnj[l_ac].nnj13,
                                  nnj14 = g_nnj[l_ac].nnj14,
                                  nnj15 = g_nnj[l_ac].nnj15,
                                  nnj16 = g_nnj[l_ac].nnj16,
                                  nnjud01 = g_nnj[l_ac].nnjud01,
                                  nnjud02 = g_nnj[l_ac].nnjud02,
                                  nnjud03 = g_nnj[l_ac].nnjud03,
                                  nnjud04 = g_nnj[l_ac].nnjud04,
                                  nnjud05 = g_nnj[l_ac].nnjud05,
                                  nnjud06 = g_nnj[l_ac].nnjud06,
                                  nnjud07 = g_nnj[l_ac].nnjud07,
                                  nnjud08 = g_nnj[l_ac].nnjud08,
                                  nnjud09 = g_nnj[l_ac].nnjud09,
                                  nnjud10 = g_nnj[l_ac].nnjud10,
                                  nnjud11 = g_nnj[l_ac].nnjud11,
                                  nnjud12 = g_nnj[l_ac].nnjud12,
                                  nnjud13 = g_nnj[l_ac].nnjud13,
                                  nnjud14 = g_nnj[l_ac].nnjud14,
                                  nnjud15 = g_nnj[l_ac].nnjud15
               WHERE nnj01=g_nni.nni01 AND nnj02=g_nnj_t.nnj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nnj_file",g_nni.nni01,g_nnj_t.nnj02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 LET g_nnj[l_ac].* = g_nnj_t.*
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
                 LET g_nnj[l_ac].* = g_nnj_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_nnj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE t740_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30032  add
           CLOSE t740_bcl
           COMMIT WORK
           CALL t740_b_tot()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nnj03)
                 IF g_nnj[l_ac].nnj09="1" THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nne"
                    LET g_qryparam.arg1 = g_nni.nni05   #MOD-8C0104 add
                    CALL cl_create_qry() RETURNING g_nnj[l_ac].nnj03
                    DISPLAY BY NAME g_nnj[l_ac].nnj03
                    NEXT FIELD nnj03
                 END IF
                 IF g_nnj[l_ac].nnj09="2" THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nng"
                    LET g_qryparam.arg1 = g_nni.nni05   #MOD-8C0104 add
                    CALL cl_create_qry() RETURNING g_nnj[l_ac].nnj03
                    DISPLAY BY NAME g_nnj[l_ac].nnj03
                    NEXT FIELD nnj03
                 END IF
              OTHERWISE
                 EXIT CASE
              END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(nnj02) AND l_ac > 1 THEN
              LET g_nnj[l_ac].* = g_nnj[l_ac-1].*
              LET g_nnj[l_ac].nnj02 = NULL   #TQC-620018
              NEXT FIELD nnj02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION auto_gen_body
           CALL t740_g_b()
           CALL t740_b_fill('1=1')
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
    CALL t740_b_tot()
 
    CLOSE t740_bcl
    COMMIT WORK
    CALL t740_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t740_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_nni.nni01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM nni_file ",
                  "  WHERE nni01 LIKE '",l_slip,"%' ",
                  "    AND nni01 > '",g_nni.nni01,"'"
      PREPARE t740_pb1 FROM l_sql 
      EXECUTE t740_pb1 INTO l_cnt       
      
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
         CALL t740_v()
         IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti) 
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=6 AND npp01=g_nni.nni01 AND npp011=0
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=6 AND npq01=g_nni.nni01 AND npq011=0
         DELETE FROM tic_file WHERE tic04 = g_nni.nni01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM nni_file WHERE nni01 = g_nni.nni01
         INITIALIZE g_nni.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t740_b_tot()
   SELECT SUM(nnj11),SUM(nnj12),SUM(nnj13),SUM(nnj14),SUM(nnj15),SUM(nnj16)
          INTO g_nni.nni11,g_nni.nni12,g_nni.nni13,
               g_nni.nni14,g_nni.nni15,g_nni.nni16
          FROM nnj_file
         WHERE nnj01 = g_nni.nni01
   IF STATUS THEN
      CALL cl_err3("sel","nnj_file",g_nni.nni01,"",STATUS,"","sel sum(nnj11-16):",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   IF g_nni.nni11 IS NULL THEN LET g_nni.nni11 = 0 END IF
   IF g_nni.nni12 IS NULL THEN LET g_nni.nni12 = 0 END IF
   IF g_nni.nni13 IS NULL THEN LET g_nni.nni13 = 0 END IF
   IF g_nni.nni14 IS NULL THEN LET g_nni.nni14 = 0 END IF
   IF g_nni.nni15 IS NULL THEN LET g_nni.nni15 = 0 END IF
   IF g_nni.nni16 IS NULL THEN LET g_nni.nni16 = 0 END IF
   DISPLAY BY NAME g_nni.nni11,g_nni.nni12,g_nni.nni13,
                   g_nni.nni14,g_nni.nni15,g_nni.nni16
   UPDATE nni_file SET nni11=g_nni.nni11,
                       nni12=g_nni.nni12,
                       nni13=g_nni.nni13,
                       nni14=g_nni.nni14,
                       nni15=g_nni.nni15,
                       nni16=g_nni.nni16
    WHERE nni01=g_nni.nni01
END FUNCTION
 
FUNCTION t740_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT g_wc2 ON nnj02,nnj03,nnj05.nnj06,nnj07,nnj08
                      ,nnjud01,nnjud02,nnjud03,nnjud04,nnjud05
                      ,nnjud06,nnjud07,nnjud08,nnjud09,nnjud10
                      ,nnjud11,nnjud12,nnjud13,nnjud14,nnjud15
           FROM s_nnj[1].nnj02,s_nnj[1].nnj03,s_nnj[1].nnj05,
                s_nnj[1].nnj06,s_nnj[1].nnj07,s_nnj[1].nnj08
                ,s_nnj[1].nnjud01,s_nnj[1].nnjud02,s_nnj[1].nnjud03
                ,s_nnj[1].nnjud04,s_nnj[1].nnjud05,s_nnj[1].nnjud06
                ,s_nnj[1].nnjud07,s_nnj[1].nnjud08,s_nnj[1].nnjud09
                ,s_nnj[1].nnjud10,s_nnj[1].nnjud11,s_nnj[1].nnjud12
                ,s_nnj[1].nnjud13,s_nnj[1].nnjud14,s_nnj[1].nnjud15
 
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
   CALL t740_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t740_b_fill(p_wc2)                #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(200)
   l_date          LIKE type_file.dat,     #No.FUN-680107 DATE
   l_j09t          LIKE nne_file.nne12,    #CHI-B80051 add
   l_j09g          LIKE nne_file.nne19     #CHI-B80051 add
DEFINE l_nnl11     LIKE nnl_file.nnl11     #CHI-D50031 add
DEFINE l_nnl13     LIKE nnl_file.nnl17     #CHI-D50031 add
 
   LET g_sql = "SELECT nnj02,nnj09,nnj03,nnj04,'',",
               "       nnj05,nnj06,nnj07,nnj08,'',",        #CHI-B80051 add j09t
               "       '',nnj11,nnj13,nnj12,nnj14,",        #CHI-B80051 add j09g
               "       nnj15,nnj16, ",
               "       nnjud01,nnjud02,nnjud03,nnjud04,nnjud05,",
               "       nnjud06,nnjud07,nnjud08,nnjud09,nnjud10,",
               "       nnjud11,nnjud12,nnjud13,nnjud14,nnjud15 ",
               " FROM nnj_file ",
               " WHERE nnj01 ='",g_nni.nni01,"'",
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE t740_pb FROM g_sql
   DECLARE nnj_curs CURSOR FOR t740_pb
 
   CALL g_nnj.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH nnj_curs INTO g_nnj[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_date=NULL
      IF g_nnj[g_cnt].nnj09 ='1' THEN
        #SELECT nne03 INTO l_date FROM nne_file                             #CHI-B80051 mark
         SELECT nne03,nne12,nne19 INTO l_date,l_j09t,l_j09g FROM nne_file   #CHI-B80051 add
          WHERE nne01 = g_nnj[g_cnt].nnj03
      ELSE
        #SELECT nng03 INTO l_date FROM nng_file                             #CHI-B80051 mark
         SELECT nng03,nng20,nng22 INTO l_date,l_j09t,l_j09g FROM nng_file   #CHI-B80051 add
          WHERE nng01 = g_nnj[g_cnt].nnj03
      END IF
     #------------------------CHI-D50031------------------(S)
      SELECT SUM(nnl11),SUM(nnl13) INTO l_nnl11,l_nnl13
        FROM nnl_file,nnk_file
       WHERE nnl04 = g_nnj[l_ac].nnj03
         AND nnl01 = nnk01
         AND nnk02 <= g_nnj[l_ac].nnj06
         AND nnkconf = 'Y'
      IF cl_null(l_nnl11) THEN LET l_nnl11 = 0 END IF
      IF cl_null(l_nnl13) THEN LET l_nnl13 = 0 END IF
      LET g_nnj[l_ac].j09t = l_j09t - l_nnl11
      LET g_nnj[l_ac].j09g = l_j09g - l_nnl13
     #------------------------CHI-D50031--------------------(E)
      LET g_nnj[g_cnt].date1 = l_date
      LET g_nnj[g_cnt].j09t = l_j09t           #CHI-B80051 add
      LET g_nnj[g_cnt].j09g = l_j09g           #CHI-B80051 add
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_nnj.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=(g_cnt-1)
   IF g_rec_b = 0 AND g_cnt > 1 THEN
      LET g_rec_b=999
   END IF
   LET g_cnt = 0
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t740_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnj TO s_nnj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t740_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t740_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t740_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t740_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t740_fetch('L')
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
         #CALL cl_set_field_pic(g_nni.nniconf,"","","","",g_nni.nniacti)     #MOD-A20096 "" modify nniacti  #CHI-C80041  
         IF g_nni.nniconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
         CALL cl_set_field_pic(g_nni.nniconf,"","","",g_void,g_nni.nniacti)  #CHI-C80041  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生應付票據
      ON ACTION gen_n_p
         LET g_action_choice="gen_n_p"
         EXIT DISPLAY
      #@ON ACTION 應付票據修改
      ON ACTION modify_n_p
         LET g_action_choice="modify_n_p"
         EXIT DISPLAY
      #@ON ACTION 應付票據還原
      ON ACTION undo_n_p
         LET g_action_choice="undo_n_p"
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
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
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
 
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice = 'carry_voucher'
         EXIT DISPLAY
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice = 'undo_carry_voucher'
         EXIT DISPLAY																										
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
     #MOD-A50160 add
      &include "qry_string.4gl" 
     #MOD-A50160 add
     #str FUN-910014 add
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
     #end FUN-910014 add

      AFTER DISPLAY
         CONTINUE DISPLAY
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t740_g_gl(p_trno,p_npptype)   #No.FUN-680088
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680088
   DEFINE p_trno        LIKE npp_file.npp01    #No.FUN-680107 VARCHAR(20)
   DEFINE l_buf         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n           LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_t           LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(05) #No.FUN-550057
          l_nmydmy3     LIKE nmy_file.nmydmy3
 
   BEGIN WORK
 
   LET g_success='Y'  #No.FUN-680088
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)
      CLOSE t740_cl ROLLBACK WORK RETURN ELSE COMMIT WORK
   END IF
   SELECT * INTO g_nni.* FROM nni_file WHERE nni01 = g_nni.nni01
   IF p_trno IS NULL THEN RETURN END IF
   #-->立帳日期不可小於關帳日期
   IF g_nni.nni02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_nni.nni01,'aap-176',1) RETURN
   END IF
   IF g_nni.nniconf='Y' THEN CALL cl_err(g_nni.nni01,'anm-232',0) RETURN END IF
   IF NOT cl_null(g_nni.nniglno) THEN
      CALL cl_err(g_nni.nni01,'aap-122',1) RETURN
   END IF
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)   #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN LET l_nmydmy3 = 'N' END IF
   IF l_nmydmy3 = 'N' THEN RETURN END IF
 
   IF p_npptype = '0' THEN  #No.FUN-680088
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=6 AND npq01=p_trno AND npq011=0
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
          WHERE npqsys='NM' AND npq00=6 AND npq01=p_trno AND npq011=0
      END IF
   END IF   #No.FUN-680088
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =6
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_nni.nni02
   LET g_npp.npptype = p_npptype  #No.FUN-680088
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
      UPDATE npp_file SET npp02=g_npp.npp02
       WHERE nppsys='NM' AND npp00=6 AND npp01=p_trno AND npp011=0
         AND npptype=p_npptype    #No.FUN-680088
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","nnp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         LET g_success='N' #No.FUN-680088
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      CALL cl_err3("ins","nnp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp:",1)  #No.FUN-660148
      LET g_success='N' #No.FUN-680088
      RETURN END IF
   CALL t740_g_gl_1(p_trno,p_npptype)
   CALL t740_gen_diff()    #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t740_g_gl_1(p_trno,p_npqtype)   #No.FUN-680088
   DEFINE p_npqtype            LIKE npq_file.npqtype   #No.FUN-680088
   DEFINE p_trno               LIKE alk_file.alk01
   DEFINE amt1,amt2,amt3,amt4  LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE l_nnm10              LIKE nnm_file.nnm10     #MOD-9B0059 add
   DEFINE l_nnj11              LIKE nnj_file.nnj11     #MOD-9B0059 add
   DEFINE l_nnj13              LIKE nnj_file.nnj13     #MOD-9B0059 add
   DEFINE l_aaa03              LIKE aaa_file.aaa03     #FUN-A40067
   DEFINE l_azi04_2            LIKE azi_file.azi04     #FUN-A40067
   DEFINE l_nnm09              LIKE nnm_file.nnm09     #MOD-C30686 add 
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   LET g_success = 'Y'            #No.FUN-680088
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqtype = p_npqtype   #No.FUN-680088
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02  = 0
   LET g_npq.npq24 = g_nni.nni08
   LET g_npq.npq25 = g_nni.nni09
   LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
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
   #------------------------------------------------ Dr:應付利息
   IF g_nmz.nmz52<> 'Y'  THEN     #No:8609 不回轉則為應付利息   #MOD-5B0181
     #當單身多筆,對應到的利息暫估(anmt730)的匯率不同時,分錄需拆多筆呈現
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nni.nni04
    # LET g_sql = "SELECT nnm10,SUM(nnj11),SUM(nnj13)",  #MOD-C30686 mark
      LET g_sql = "SELECT nnm09,nnm10,SUM(nnj11),SUM(nnj13)",  #MOD-C30686  add
                  "  FROM nnm_file,nnj_file",
                  " WHERE nnm01 = nnj03",
                  "   AND nnm02 = YEAR(nnj05) AND nnm03 = MONTH(nnj05)",
                  "   AND nnj01 ='",g_nni.nni01,"'",
                # " GROUP BY nnm10",     #MOD-C30686 mark
                # " ORDER BY nnm10"      #MOD-C30686 mark
                  " GROUP BY nnm09,nnm10",  #MOD-C30686  add
                  " ORDER BY nnm09,nnm10"   #MOD-C30686  add
      PREPARE nnm_nnj_p FROM g_sql
      DECLARE nnm_nnj_cs CURSOR FOR nnm_nnj_p
     #FOREACH nnm_nnj_cs INTO l_nnm10,l_nnj11,l_nnj13   #MOD-C30686 mark
      FOREACH nnm_nnj_cs INTO l_nnm09,l_nnm10,l_nnj11,l_nnj13  #MOD-C30686  add
        IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH 
         END IF 
         LET g_npq.npq02 = g_npq.npq02+1
         IF p_npqtype = '0' THEN
            LET g_npq.npq03 = g_nms.nms64
         ELSE
            LET g_npq.npq03 = g_nms.nms641
         END IF
         LET g_npq.npq04 = NULL  #FUN-D10065
         LET g_npq.npq06 = '1'
         LET g_npq.npq07f= l_nnj11      #MOD-9B0059
         LET g_npq.npq07 = l_nnj13      #MOD-9B0059
         CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-9B0059 add
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-9B0059 add
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
              RETURNING  g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
        #LET g_npq.npq24 = g_nni.nni04   #MOD-9B0059 add   #MOD-C30686 MARK
         LET g_npq.npq24 = l_nnm09       #MOD-C30686 add
         LET g_npq.npq25 = l_nnm10       #MOD-9B0059 add
         LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
         LET g_npq.npqlegal= g_legal
         IF g_npq.npq07 > 0 THEN   #CHI-7A0027
#No.FUN-9A0036 --Begin
            IF p_npqtype = '1' THEN
               CALL s_newrate(g_bookno1,g_bookno2,
                              g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
               LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            END IF
#No.FUN-9A0036 --End 
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno3
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)
         END IF   #CHI-7A0027
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq:d2",1)  #No.FUN-660148 
            LET g_success='N' #No.FUN-680088
         END IF
      END FOREACH   #MOD-9B0059 add
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nni.nni08  #MOD-9B0059 add
   #------------------------------------------------ Dr:利息費用(未暫估)
   LET amt1=0 LET amt2=0 LET amt3=0 LET amt4=0
   SELECT SUM(nnj12),SUM(nnj14),SUM(nnj15),SUM(nnj16)
     INTO amt1,amt2,amt3,amt4 FROM nnj_file
    WHERE nnj01=g_nni.nni01
     IF cl_null(amt1) THEN LET amt1=0 END IF           #No.MOD-510048
     IF cl_null(amt2) THEN LET amt2=0 END IF           #No.MOD-510048
     IF cl_null(amt3) THEN LET amt3=0 END IF           #No.MOD-510048
     IF cl_null(amt4) THEN LET amt4=0 END IF           #No.MOD-510048
   IF g_nmz.nmz52='Y' THEN                  #No:8609 要回轉
      LET g_npq.npq02 = g_npq.npq02 + 1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nmq.nmq01  #MOD-980005 nms60->nmq10    #MOD-A10028 mod nmq10->nmq01
      ELSE
         LET g_npq.npq03 = g_nmq.nmq011 #MOD-980005 nms601->nmq101  #MOD-A10028 mod nmq101->nmq011
      END IF
      LET g_npq.npq04 = NULL  #FUN-D10065
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= amt1
      LET g_npq.npq07 = amt2
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-9B0059 add
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-9B0059 add
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
      
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
      LET g_npq.npq24 = g_nni.nni08   #MOD-9B0059 add
      LET g_npq.npq25 = g_nni.nni09   #MOD-9B0059 add
      LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
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
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq:d1",1)  #No.FUN-660148 
         LET g_success='N' #No.FUN-680088
      END IF
      LET g_nni.nni11=g_nni.nni11+amt1
      LET g_nni.nni13=g_nni.nni13+amt2
      LET g_nni.nni15=g_nni.nni15-amt3
      LET g_nni.nni16=g_nni.nni16-amt4
   END IF
   #------------------------------------------------ Cr:Diff-利差
   IF g_nni.nni15 <> 0 THEN
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nms.nms60  
      ELSE
         LET g_npq.npq03 = g_nms.nms601 
      END IF
      LET g_npq.npq04 = NULL  #FUN-D10065
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= g_nni.nni15/g_nni.nni09                #MOD-9B0059
      IF g_npq.npq07f < 0 THEN LET g_npq.npq07f = g_npq.npq07f * (-1) END IF #MOD-6C0158
      LET g_npq.npq07 = g_nni.nni15
      IF g_npq.npq07 < 0 THEN
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = g_npq.npq07 * -1
      END IF
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-9B0059 add
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-9B0059 add
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
           RETURNING  g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34     #FUN-AA0087  
      LET g_npq.npq24 = g_nni.nni08   #MOD-9B0059 add
      LET g_npq.npq25 = g_nni.nni09   #MOD-9B0059 add
      LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
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
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1",1)  #No.FUN-660148 
         LET g_success='N' #No.FUN-680088
      END IF
   END IF
   #------------------------------------------------ Cr:Diff-匯差
   IF g_nni.nni16 <> 0 THEN
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npqtype = '0' THEN
         LET g_npq.npq03 = g_nms.nms13
      ELSE
         LET g_npq.npq03 = g_nms.nms131
      END IF
      LET g_npq.npq04 = NULL  #FUN-D10065
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= 0
      LET g_npq.npq07 = g_nni.nni16
      IF g_npq.npq07 < 0 THEN
         IF p_npqtype = '0' THEN
            LET g_npq.npq03 = g_nms.nms12
         ELSE
            LET g_npq.npq03 = g_nms.nms121
         END IF
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = g_npq.npq07 * -1
      END IF
      CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-9B0059 add
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-9B0059 add
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
       
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34     #FUN-AA0087  
      LET g_npq.npq24 = g_nni.nni08   #MOD-9B0059 add
      LET g_npq.npq25 = g_nni.nni09   #MOD-9B0059 add
      LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
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
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1",1)  #No.FUN-660148 
         LET g_success='N' #No.FUN-680088
      END IF
   END IF
   #------------------------------------------------ Cr:Cash/NP
   LET g_npq.npq02 = g_npq.npq02+1
   IF p_npqtype = '0' THEN
      LET g_npq.npq03 = g_nni.nni10
   ELSE
      LET g_npq.npq03 = g_nni.nni101
   END IF
   LET g_npq.npq04 = NULL  #FUN-D10065
   LET g_npq.npq06 = '2'
   LET g_npq.npq07f= g_nni.nni12
   LET g_npq.npq07 = g_nni.nni14
   CALL cl_digcut(g_npq.npq07f,t_azi04) RETURNING g_npq.npq07f #MOD-9B0059 add
   CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-9B0059 add
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
    
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34     #FUN-AA0087  
   LET g_npq.npq24 = g_nni.nni08   #MOD-9B0059 add
   LET g_npq.npq25 = g_nni.nni09   #MOD-9B0059 add
   LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
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
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1",1)  #No.FUN-660148 
      LET g_success='N' #No.FUN-680088
   END IF 
END FUNCTION
 
FUNCTION t740_get_default()
 DEFINE l_nnm07 LIKE nnm_file.nnm07,
        l_nnm11 LIKE nnm_file.nnm11,
        l_nnm12 LIKE nnm_file.nnm12
 
   IF g_nnj[l_ac].nnj05>g_nnj[l_ac].nnj06 THEN
      LET g_nnj[l_ac].nnj11=0
      LET g_nnj[l_ac].nnj13=0
      RETURN
   END IF
 
   SELECT nnm07,nnm11,nnm12 INTO l_nnm07,l_nnm11,l_nnm12 FROM nnm_file
    WHERE nnm01=g_nnj[l_ac].nnj03
      AND nnm02=YEAR(g_nnj[l_ac].nnj05)
      AND nnm03=MONTH(g_nnj[l_ac].nnj05)
   IF STATUS THEN
     LET g_nnj[l_ac].nnj11=0
     LET g_nnj[l_ac].nnj13=0
   ELSE
        LET g_nnj[l_ac].nnj11=l_nnm11
        LET g_nnj[l_ac].nnj13=l_nnm12
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni04
   CALL cl_digcut(g_nnj[l_ac].nnj11,t_azi04) RETURNING g_nnj[l_ac].nnj11
   CALL cl_digcut(g_nnj[l_ac].nnj13,g_azi04) RETURNING g_nnj[l_ac].nnj13
 
END FUNCTION
 
FUNCTION t740_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nni01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t740_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nni01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t740_set_entry_b()
     
   CALL cl_set_comp_entry("nnj16",TRUE)
   
END FUNCTION
 
FUNCTION t740_set_no_entry_b()
 
    IF g_nni.nni04 = g_nni.nni08 THEN
       CALL cl_set_comp_entry("nnj16",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t740_out()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          sr_nni    RECORD LIKE nni_file.*,
          sr_nnj    RECORD LIKE nnj_file.*
 
    #LET g_wc=" nni01='",g_nni.nni01,"'"   #MOD-870249    #MOD-B70232 mark
     LET g_wc=" a.nni01='",g_nni.nni01,"'"   #MOD-870249  #MOD-B70232
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmt840' 
    #str MOD-B70232 mod
    #LET l_sql="SELECT nni_file.*,nnj_file.*,nma02,nmd02,alg02,nne03,nng03,azi07 ",   #MOD-870290 add azi07
    #          "  FROM nni_file  ",
    #          "  LEFT OUTER JOIN nma_file ON nma01 = nni06 ",
    #          "  LEFT OUTER JOIN nmd_file ON nni21 = nmd01 ",
    #          "  LEFT OUTER JOIN alg_file ON nni05 = alg01 ",
    #          "  LEFT OUTER JOIN azi_file ON nni08 = azi01,nnj_file ",
    #          "  LEFT OUTER JOIN nne_file ON nnj03 = nne01 ",
    #          "  LEFT OUTER JOIN nng_file ON nnj03 = nng01 ",
    #          " WHERE nni01=nnj01 ",
    #          "   AND nniconf <> 'X' ",
    #          "   AND ",g_wc CLIPPED
    #LET l_sql=l_sql CLIPPED," ORDER BY nni01,nnj02 "
     LET l_sql="SELECT a.nni01,a.nni02,a.nni03,a.nni04,a.nni05,a.nni06,a.nni08,",
                      "a.nni09,a.nni21,a.nniglno,a.nni10,a.nni22,a.nniconf,",
                      "f.nnj02,f.nnj09,f.nnj03,f.nnj05,f.nnj07,f.nnj11,f.nnj13,",
                      "f.nnj15,f.nnj06,f.nnj08,f.nnj12,f.nnj14,f.nnj16,",
                      "b.nma02,c.nmd02,d.alg02,g.nne03,h.nng03,e.azi07,",   #MOD-870290 add azi07
                      "g.nne12,g.nne19,h.nng20,h.nng22 ",                   #CHI-B80051 add
               "  FROM nni_file a ",
               "  LEFT OUTER JOIN nma_file b ON b.nma01 = a.nni06 ",
               "  LEFT OUTER JOIN nmd_file c ON a.nni21 = c.nmd01 ",
               "  LEFT OUTER JOIN alg_file d ON a.nni05 = d.alg01 ",
               "  LEFT OUTER JOIN azi_file e ON a.nni08 = e.azi01,nnj_file f ",
               "  LEFT OUTER JOIN nne_file g ON f.nnj03 = g.nne01 ",
               "  LEFT OUTER JOIN nng_file h ON f.nnj03 = h.nng01 ",
               " WHERE a.nni01=f.nnj01 ",
               "   AND a.nniconf <> 'X' ",
               "   AND ",g_wc CLIPPED
     LET l_sql=l_sql CLIPPED," ORDER BY a.nni01,f.nnj02 "
    #str MOD-B70232 mod
 
     IF g_zz05 = 'Y' THEN                                                       
        LET g_wc=" nni01='",g_nni.nni01,"'"   #MOD-870249    #MOD-B70232 add
        CALL cl_wcchp(g_wc,'nni01,nni02,nni03,nni04,nni05,nni06,   #No.MOD-910025
                            nni07,nni08,nni09,nni22,nni21,nniglno,nniconf,nni10,
                            nni101,nnj02,nnj09,nnj03,nnj05,nnj06,nnj07,nnj08 ')      
             RETURNING g_str                                                    
     ELSE                                                                       
        LET g_str = ' '                                                         
     END IF                                                                     
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nni.nni04   #MOD-A50065 add
     LET g_str = g_str,";",g_azi04,";",t_azi04      #MOD-A50065 add t_azi04                                  
     CALL cl_prt_cs1('anmt740','anmt740',l_sql,g_str)  
END FUNCTION
 
FUNCTION t740_gen_glcr(p_nni,p_nmy)
  DEFINE p_nni     RECORD LIKE nni_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_nni.nni01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t740_g_gl(p_nni.nni01,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t740_g_gl(p_nni.nni01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t740_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nni.nniglno) OR g_nni.nniglno IS NOT NULL THEN
       CALL cl_err(g_nni.nniglno,'aap-618',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nni.nni01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_nni.nniglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_nni.nniglno,'aap-991',1)
          RETURN
       END IF
       LET l_nmygslp = g_nmy.nmygslp
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
 
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_nni.nni01,'axr-070',1)
       RETURN
    END IF
    IF g_aza.aza63 = 'Y' AND cl_null(g_nmy.nmygslp1) THEN
       CALL cl_err(g_nni.nni01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_nni.nni01,'" AND npp011 = 0'
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nni.nni02,"' 'Y' '1' 'Y'"   #No.FUN-680088 #FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT nniglno INTO g_nni.nniglno FROM nni_file
     WHERE nni01 = g_nni.nni01
    DISPLAY BY NAME g_nni.nniglno
    
END FUNCTION
 
FUNCTION t740_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_nni.nniglno) OR g_nni.nniglno IS NULL THEN 
       CALL cl_err(g_nni.nniglno,'aap-619',1) 
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nni.nni01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nni.nniglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nni.nniglno,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nni.nniglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nniglno INTO g_nni.nniglno FROM nni_file
     WHERE nni01 = g_nni.nni01
    DISPLAY BY NAME g_nni.nniglno
END FUNCTION
 
#函數功能：用于判斷止算日是否小于等于還息日。止算日不可大于還息日。
FUNCTION t740_chk_edate(p_nnj09,p_nnj03,p_nnj06)
DEFINE          p_nnj09     LIKE nnj_file.nnj09     #還款類型
DEFINE          p_nnj03     LIKE nnj_file.nnj03     #單號
DEFINE          p_nnj06     LIKE nnj_file.nnj06     #止算日期
DEFINE          l_sql       STRING                  #組SQL
DEFINE          l_errno     VARCHAR(2)                 #錯誤類型：
                                                    #'00'執行成功
                                                    #'01'未取得還息日
                                                    #'02'止息日大于還息日
DEFINE          l_dd        LIKE nne_file.nne22     #取得止算日
DEFINE          l_ed        LIKE nne_file.nne22     #取得還息日
                                                   
    LET l_dd    = NULL
    LET l_ed    = NULL
    LET l_errno = '00'
    CASE p_nnj09
      WHEN '1'   #短期
        LET l_sql = "SELECT nne22 FROM nne_file WHERE nne01 = '",p_nnj03 CLIPPED,"'"
      WHEN '2'   #中長期
        LET l_sql = "SELECT nng13 FROM nng_file WHERE nng01 = '",p_nnj03 CLIPPED,"'"
    END CASE 
    PREPARE t740_chk_prep FROM l_sql
    EXECUTE t740_chk_prep INTO l_ed
    IF SQLCA.sqlcode THEN 
       LET l_errno = '01'
       RETURN l_errno
    END IF 
    LET l_dd = DAY(p_nnj06) 
    IF l_dd > l_ed THEN 
       LET l_errno = '02'
       RETURN l_errno 
    END IF 
    
    RETURN l_errno
 
END FUNCTION
#-----------------------------No.MOD-B80058-----------------------------------------start
FUNCTION t740_nnj15()
   IF g_nni.nni04 != g_nni.nni08 THEN
      LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13)
      LET g_nnj[l_ac].nnj16=0
   ELSE
      IF cl_null(g_nnj[l_ac].nnj12) THEN
         LET g_nnj[l_ac].nnj12 = 0
      END IF
      LET g_nnj[l_ac].nnj15=(g_nnj[l_ac].nnj12-g_nnj[l_ac].nnj11) * g_nni.nni09
      IF g_nni.nni04<>g_aza.aza17 THEN
         LET g_nnj[l_ac].nnj16=(g_nnj[l_ac].nnj14-g_nnj[l_ac].nnj13 -g_nnj[l_ac].nnj15)
      ELSE
         LET g_nnj[l_ac].nnj16=0
      END IF
   END IF
   CALL cl_digcut(g_nnj[l_ac].nnj15,g_azi04) RETURNING g_nnj[l_ac].nnj15
   CALL cl_digcut(g_nnj[l_ac].nnj16,g_azi04) RETURNING g_nnj[l_ac].nnj16

END FUNCTION
#-----------------------------No.MOD-B80058---------------------------------------------end
#No.FUN-9C0073 -----------------By chenls 10/01/18
#FUN-A40033 --Begin
FUNCTION t740_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

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
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#CHI-C80041---begin
FUNCTION t740_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_nni.nni01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t740_cl USING g_nni.nni01
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_nni.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nni.nni01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_nni.nniconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_nni.nniconf)   THEN 
        LET l_chr=g_nni.nniconf
        IF g_nni.nniconf='N' THEN 
            LET g_nni.nniconf='X' 
        ELSE
            LET g_nni.nniconf='N'
        END IF
        UPDATE nni_file
            SET nniconf=g_nni.nniconf,  
                nnimodu=g_user,
                nnidate=g_today
            WHERE nni01=g_nni.nni01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","nni_file",g_nni.nni01,"",SQLCA.sqlcode,"","",1)  
            LET g_nni.nniconf=l_chr 
        END IF
        DISPLAY BY NAME g_nni.nniconf 
   END IF
 
   CLOSE t740_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nni.nni01,'V')
 
END FUNCTION
#CHI-C80041---end
