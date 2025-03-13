# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asmi300.4gl
# Descriptions...: 製造系統單據性質維護作業
# Date & Author..: 94/12/16 By Danny
# Modify         : No:8313 92/09/24 By Melody asmi300 多加 2 個欄位 insert 時將 *,? 轉成 %,_
# Modify         : No:8741 03/11/25 By Melody asf系統,性質'4'時, 應default成會分類='3'
# Modify         : MOD-480037 04/08/04 By Carol 報表列印內容少了倉庫及儲位的表頭
#                                         --> za add 68項
# Modify........ : MOD-470535 04/08/13 Kammy是否產生RUN CARD、對應入庫、驗退單別
#                                           set_noentry控管加強
# Modify.........: MOD-480023 04/08/13 Kammy 加圖示
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0022 04/11/05 By Yuna 新增單別開窗
# Modify.........: No.FUN-4B0048 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0033 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510031 05/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-510041 05/01/28 By Carol smy54改成no use,在per拿掉此欄位,4gl同步修改
#                                                  單別對應的對方科目改成不在此設定一律到axci010維護
# Modify.........: No.MOD-520133 05/03/16 By pengu 在查詢段時，刪除單據性質欄位的開窗動作
# Modify.........: No.FUN-530038 05/03/23 By Carol 成本拋轉傳票’欄位不使用,改no use,因為在axcp191(分錄底稿產生)時,
#                                                  是以成本入項’一欄來判斷(跟axcp500一致性),所以怕使用者混淆,所以此欄位不使用
# Modify.........: No.FUN-540024 05/04/26 By ice   smykind新增aimD庫存調整單(asm-038)
# Modify.........: No.MOD-540166 05/04/22 By Carol 在正式區p_qry單身沒有q_smy1資料,程式直接跳出。
# Modify.........: No.MOD-540098 05/04/22 By Carol 單據性質名稱改由ze_file中取得資料顯示
# Modify.........: No.MOD-550137 05/06/15 By pengu '當 "是否產生RUNCARD" 欄位有勾選時, 無法使用 MOUSE 點選 "對應入庫單別/RUNCARD單別" 欄位, 只能按 ENTER
# Modify.........: No.FUN-560060 05/06/17 By jackie 單據編號修改
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-560234 05/07/15 By elva  加入系統別AEM
# Modify.........: No.MOD-570218 05/08/03 By Nicola 單別輸入重覆時，秀錯誤訊息
# Modify.........: No.MOD-570074 05/08/05 By pengu 系統別未輸入,先輸入單據性質,系統出現錯誤訊息mfg0070
                                               #   但清除單據性質後再挑選系統別apm系統還是會出現錯誤訊息mfg0070
# Modify.........: No.MOD-570298 05/08/14 By kim 修改"單別,單據性質"的show hint,倉庫和儲位增加開窗功能
# Modify.........: No.FUN-580037 05/08/29 By Smapmin set noentry時,值要清空
# Modify.........: No.FUN-580129 05/09/12 By Nicola "立即確認"與"應簽核"欄位應為互斥的選項, 其中一項為 "Y" 時,另一項應只能為 "N"
# Modify.........: No.MOD-5A0124 05/11/01 By Claire  匯出excel功能失效了->調整成有效
# Modify.........: No.FUN-5B0078 05/11/17 by Brendan: 當走 EasyFlow 簽核時, 簽核等級等欄位不需輸入
# Modify.........: No.MOD-5B0239 05/11/22 by kim 報表列印,資料與資料間會有一空白行
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-5C0114 06/02/15 By kim GP3.0-系統別加入ASR
# Modify.........: No.FUN-610014 06/02/20 By vivien smykind新增aimE雜發申請單，apm9調撥申請單
# Modify.........: No.FUN-610060 06/03/24 By pengu 若為銷售系統單據別時，必須同步更新銷售系統單據性質檔oay_file的相對映欄位
# Modify.........: No.MOD-640105 06/04/09 By Alexstar 編號欄位拆開為自動編號及編號方式兩欄位
# Modify.........: No.FUN-640211 06/04/19 By Echo 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650096 06/05/22 By ice 新增屬性組欄位smy62
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.TQC-670002 06/07/05 By Pengu 權限修正
# Modify.........: No.FUN-680010 06/08/05 By Joe Add 對應檢驗單欄位(smy63)
# Modify.........: No.FUN-690003 06/09/01 By Mandy 新增單據性質,系統別'apm'->'Z':廠商申請
# Modify.........: No.FUN-690003 06/09/01 By Mandy 新增單據性質,系統別'aim'->'Z':料件申請
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0150 06/10/26 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0056 06/11/14 By Ray 修正無效資料仍可更改
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0002 06/11/15 By johnray 報表修改
# Modify.........: No.MOD-710126 07/01/19 By day 新增與修改時判斷當屬性群組為NULL時賦值為空 
# Modify.........: No.MOD-710003 07/03/06 By pengu 第二筆單身開窗口選擇倉庫後，倉庫代號會出現於第一筆
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: NO.FUN-720041 07/03/12 BY yiting 加入AQC系統
# Modify.........: No.TQC-740137 07/04/19 By Carrier 基礎日時數和基礎月天數為負數無控管
# Modify.........: No.TQC-740141 07/04/20 By Carol QBE後的g_wc加上轉碼的處理
# Modify.........: No.TQC-740321 07/04/26 By Ray 控制當"入庫單流水號缺省同收貨單流水號"勾選時對應入庫單別/RUN Card單別"不可為空
# Modify.........: No.TQC-740154 07/05/04 By kim ASF系統增加單據別J報工單
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-6A0061 07/05/28 By kim AQC系統增加單據別2檢驗申請單
# Modify.........: No.TQC-750096 07/05/29 By pengu 若性統別為'abm'且單據性質為'1'時簽核欄位與自動確認應為互斥
# Modify.........: No.MOD-750145 07/05/31 By Carol 調整update oay_file ok後的訊息處理cl_err3()->cl_msgany()
# Modify.........: No.MOD-760029 07/06/06 By Carol 調整update oay_file之前應判斷單據性質為'50''60'才回寫
# Modify.........: NO.FUN-6B0045 07/07/25 BY yiting ASF系統增加單據別K/L(MPS/獨立需求)
# Modify.........: No.TQC-760164 07/08/29 By claire 單據性質6*,5* 在自動確認及簽核欄位應互斥
# Modify.........: NO.FUN-770057 07/08/30 BY rainy AIM系統增加單據別H(廠對廠調撥-撥入單)
# Modify.........: No.TQC-790052 07/09/12 By lumxa 匯出Excel多出一空白行
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.TQC-7B0149 07/11/28 By chenl 增加字段smy53,內部交易單據否
# Modify.........: No.FUN-810016 08/01/09 By ve007 單據性質增加類型
# Modify.........: No.FUN-830087 #No.FUN-840137 08/03/24 By ve007 810016 debug
# Modify.........: No.FUN-850091 08/05/23 By lutingting報表轉為使用CR
# Modify.........: NO.FUN-880016 08/08/04 BY yiting 增加smy64 for GPM
# Modify.........: No.FUN-870124 08/08/12 By jan 服飾業單據別增加T工單工藝變更單
# Modify.........: No.CHI-880012 08/08/22 By sherry 刪除單據單別，若已使用則不允刪除
# Modify.........: No.FUN-8A0034 08/10/21 By jan 新增的單據若為盤點標簽時編碼原則應為1依流水號
# Modify.........: No.CHI-910025 09/01/12 By Smapmin 核價單別簽核與自動確認不可同時勾選
# Modify.........: No.CHI-910055 09/02/13 By jan asmi300 開放當類型為工單時,可以設定"smy57_5(應輸入手冊編號)"
# Modify.........: No.CHI-920085 09/02/25 By jan 修改單據性質時 ,需再次判斷"手冊編號"可否輸入  
# Modify.........: No.FUN-930119 09/03/17 By Carrier 組合拆解關聯單別:工單/發料/完工單別 & 修正_x中g_smy.smylip的錯誤
# Modify.........: No.FUN-930105 09/03/18 By lilingyu 1.增加兩個字段:smy67(報工單對應入庫單別),
# ...................................................................smy68(報工單對應FQC單別)
# ....................................................2.調整單據性質G:Runcard調整單->工藝調整單
# Modify.........: No.FUN-930108 09/03/25 By zhaijie單據性質增加類型:5-料件承認申請單
# Modify.........: No.CHI-950012 09/05/11 By lutingting調整遇到axm-408的錯誤時應ROLLBACK WORK并RETURN
# Modify.........: No.FUN-950021 09/05/14 By Carrier 把smy67/smy68放至組合拆解字段下面，以節省畫面空間
# Modify.........: No.MOD-950219 09/05/27 By Smapmin axm-408的錯誤應增加判斷銷售單據性質為'5*'/'6*'
# Modify.........: No.CHI-960025 09/06/24 By mike 當系統別(smysys)='aim' 且單據性質(smykind)='3'時，應輸入手冊編號(smy57_5)應該要可>
# Modify.........: No.FUN-960130 09/07/21 By Sunyanchun 增加系統別art及相應的單據性質
# Modify.........: No.TQC-980186 09/08/21 By liuxqa 在對應入庫單別錄入錯誤的單別，系統無報錯信息。
# Modify.........: No.TQC-970399 08/08/28 By liuxqa 資料無效時，不可刪除。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980038 09/09/09 By chenmoyan 添加"單據形態"欄位及其名稱
# Modify.........: NO.FUN-990016 09/09/14 BY Mandy 當系統有跟GPM整合時(aza71='Y'),系統別為'asf','apm'時,新增和修改時需開放GPM整合單據控管方式選項
# Modify.........: No:MOD-950297 09/10/20 By Pengu 單身輸入中文字會造成程式當掉
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No.CHI-960065 09/11/06 By jan AIM系統增加單據別I
# Modify.........: NO.FUN-950009 09/11/06 BY jan 拿掉smy55欄位
# Modify.........: NO.FUN-9B0144 09/11/27 BY jan 新增smy73欄位
# Modify.........: No.TQC-9B0191 09/12/02 By jan APM系統增加單據別A/B/C/D
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: NO.MOD-A10166 10/01/27 By Dido 單身刪除邏輯調整 
# Modify.........: No:FUN-A10109 10/02/09 By TSD.lucasyeh 單據編碼優化
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: NO.FUN-A10043 10/03/15 By Lilan 開放核價單於EF簽核時可進行自動確認
# Modify.........: No.TQC-A50081 10/05/19 By lilingyu "應生產RUN CARD "欄位被勾選時,"工藝"欄位也應該一併勾選
# Modify.........: No.FUN-A50023 10/06/04 By liuxqa 增加工单备置/退备置时，可修改单据形态栏位.
# Modify.........: No.MOD-A70052 10/07/06 By Carrier 已经使用过的FOR组合拆解的工单等单别,smy73会被更新为'N' & 凡在smy69/smy70/smy71中的单据,不能将smy73变为'Y'
# Modify.........: No.FUN-A80026 10/08/13 By Carrier 增加smy74 确认时自动转应付
# Modify.........: No.FUN-A80054 10/08/26 By jan GP5.25 工單間合拼--新增smy75
# Modify.........: No.FUN-A80150 10/09/13 By sabrina GP5.2號機管理：新增smy76、smy77
# Modify.........: No.FUN-A70130 10/10/15 By shiwuying 回写oay_file时，同时更新arti010和atmi010相关单别
# Modify.........: No:CHI-8B0052 10/11/26 By Summer 控管單別不能有'-'字元存在
# Modify.........: No.TQC-B10177 11/01/18 By vealxu "單別資料"頁面，左下角加上 "底稿類別產生方式(smy78)"
# Modify.........: No:CHI-B10010 11/01/10 By sabrina 當smysys='aim' and smykind='5'時，自動編號欄位不可修改
# Modify.........: No:MOD-B30102 11/03/11 By sabrina 當smyapr='Y' AND smyatsg='N'時，smysign不可輸入
# Modify.........: No:MOD-B30405 11/03/14 By lixh1   單據興值"WAFER採購單"也要可以挑"Blanket PO" 
# Modify.........: No:MOD-B30414 11/03/15 By jan 工單也要可以輸入PBI單別
# Modify.........: No:FUN-B30113 11/03/15 By lixh1 單據型態已經是WB1或WB2,smy57_4 Blanket PO自動預設打勾
# Modify.........: No.FUN-B30161 11/03/30 By xianghui 移除"確認時自動轉應付(smy74)"欄位
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40082 11/05/17 By jason 欄位調整&新增在製盤差處理倉
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60259 11/06/21 By jan 解決系統設定單別只有三碼，組合拆解工單(發料/入庫)單別卻可以指定五碼的單別的問題
# Modify.........: No.FUN-B50039 11/07/08 By fengrui 增加自定義欄位
# Modify.........: No.FUN-B70022 11/07/22 By Abby abmi710、abmi720開放自動確認功能
# Modify.........: No.FUN-B30053 11/08/18 By xianghui 開放雜收發／調撥單別也可以勾選"QC勾稽"否
# Modify.........: No:MOD-BA0177 11/10/24 By suncx 新增系統為apm及單據性質為E:驗退單的管控
# Modify.........: No:MOD-BB0045 11/11/12 By johung 單據型態為空時，說明欄應一併清空
# Modify.........: No:MOD-BA0154 12/01/17 By Vampire 採購/收貨/入庫/退貨單據型態都要有'REG'/'EXP'/'CAP'/'SUB'/'TRI'/'TAP'
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20032 12/02/03 By destiny oriu,orig不能下条件查询
# Modify.........: No.MOD-C20127 12/02/14 By suncx MOD-BA0177遺留問題處理
# Modify.........: No.TQC-C20542 12/02/29 By bart 修改"在製盤差處理倉"欄位為非必填,修改時會卡
# Modify.........: No.MOD-C30906 12/03/30 By Vampire DELETE FROM smz_file時，應為smz021=g_smz[l_i].smz021
# Modify.........: No.TQC-BA0112 11/10/21 By destiny 重过单 
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C70014 12/07/13 By suncx 新增RunCard發料作業，所以新增单据型态D，表示RunCard發料單別
# Modify.........: No.CHI-C90048 12/10/12 By Elise 檢查倉庫是否存在imd_file且為有效
# Modify.........: No.TQC-CA0035 12/10/15 By suncx 單據型態D的說明未帶出
# Modify.........: No.FUN-CA0008 12/11/08 By Nina 新增欄位「預設機器編號」smy80
# Modify.........: No.CHI-C80041 12/12/26 By bart 刪除單頭時刪除相關table
# Modify.........: No:TQC-CC0076 12/12/26 By Elise 修正CHI-C90048,使其可刪除不存在之倉庫
# Modify.........: No:MOD-CB0251 12/12/27 By jt_chen 單據別設定的單身資料為非必要資訊,還原CHI-C30002的調整
# Modify.........: No:FUN-D10118 13/01/28 By SunLM  可按单别设置采购单是否要有请购单转入
# Modify.........: No.TQC-D20066 13/03/04 By SunLM 因規划有變，暫時還原FUN-D10118的所以調整。
# Modify.........: No.CHI-D30015 13/03/14 By Elise 增加出通單同步更新 
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-CB0005為GP5.25 的單號
# Modify.........: No.FUN-D50077 13/05/22 By Mandy 刪除單別資料時因DELETE FROM smyb_file導致異常

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_smy_t         RECORD LIKE smy_file.*,
    g_smy_o         RECORD LIKE smy_file.*,
    g_smyslip_t     LIKE smy_file.smyslip,
    g_smz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                        smz021      LIKE smz_file.smz021,
                        smz031      LIKE smz_file.smz031
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,   #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(200)
    g_argv1         LIKE smy_file.smysys,   #No.FUN-690010 VARCHAR(3),
    smy57_1,smy57_2 LIKE smy_file.smy56,    #No.FUN-690010 VARCHAR(01),      
    smy57_3,smy57_4 LIKE smy_file.smy56,    #No.FUN-690010 VARCHAR(01),
    smy57_5,smy57_6 LIKE smy_file.smy56,    #No.FUN-690010 VARCHAR(01),  #add 021111 NO.A041
    g_buf           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)    
    g_zemsg         DYNAMIC ARRAY OF STRING      #MOD-540098
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000  #No.FUN-690010CHAR(100)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-690010 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5      #No.FUN-690010 SMALLINT
DEFINE   g_abm_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_abm_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_aim_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_aim_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_apm_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_apm_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_asf_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_asf_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_aem_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_aem_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_asr_str      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_asr_end      LIKE type_file.num5      #No.FUN-690010 SMALLINT #FUN-690003 add
DEFINE   g_aqc_str      LIKE type_file.num5      #FUN-720041
DEFINE   g_aqc_end      LIKE type_file.num5      #FUN-720041
DEFINE   gg_sql         STRING                   #No.FUN-850091
DEFINE   g_str          STRING                   #No.FUN-850091
DEFINE   l_table        STRING                   #No.FUN-850091
DEFINE   l_table1       STRING                   #No.FUN-850091
DEFINE   g_art_str      LIKE type_file.num5      #FUN-960130           #NO.FUN-9B0016                                                             
DEFINE   g_art_end      LIKE type_file.num5      #FUN-960130
DEFINE   g_str_1        LIKE type_file.num5
DEFINE   g_str_2        LIKE type_file.num5
DEFINE   g_str_3        LIKE type_file.num5
DEFINE   g_str_4        LIKE type_file.num5
DEFINE   g_str_5        LIKE type_file.num5
DEFINE   g_str_6        LIKE type_file.num5
DEFINE   g_str_7        LIKE type_file.num5
DEFINE   g_str_8        LIKE type_file.num5
DEFINE   g_str_9        LIKE type_file.num5    #FUN-A50023
DEFINE   g_str_10        LIKE type_file.num5   #FUN-A50023 
DEFINE   g_str_a        LIKE type_file.num5  #TQC-9B0191
DEFINE   g_str_b        LIKE type_file.num5  #TQC-9B0191
DEFINE   g_end_1        LIKE type_file.num5
DEFINE   g_end_2        LIKE type_file.num5
DEFINE   g_end_3        LIKE type_file.num5
DEFINE   g_end_4        LIKE type_file.num5
DEFINE   g_end_5        LIKE type_file.num5
DEFINE   g_end_6        LIKE type_file.num5
DEFINE   g_end_7        LIKE type_file.num5
DEFINE   g_end_8        LIKE type_file.num5
DEFINE   g_end_9        LIKE type_file.num5   #FUN-A50023
DEFINE   g_end_10       LIKE type_file.num5   #FUN-A50023 
DEFINE   g_end_a        LIKE type_file.num5   #TQC-9B0191
DEFINE   g_end_b        LIKE type_file.num5   #TQC-9B0191
DEFINE   g_t1           LIKE oay_file.oayslip #DEV-D30026 add 

MAIN
DEFINE l_sql         string                       #No.FUN-810016
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1=ARG_VAL(1)

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ASM")) THEN
       EXIT PROGRAM
    END IF

    LET gg_sql = "smyacti.smy_file.smyacti,", 
                 "smyslip.smy_file.smyslip,", 
                 "smydesc.smy_file.smydesc,", 
                 "smyauno.smy_file.smyauno,", 
    #             "smydmy5.smy_file.smydmy5,",    #FUN-A10109 mark by TSD.lucasyeh
                 "smysys.smy_file.smysys,", 
                 "smykind.smy_file.smykind,", 
                 "smyapr.smy_file.smyapr,", 
                 "smyatsg.smy_file.smyatsg,", 
                 "smysign.smy_file.smysign,", 
                 "smyprint.smy_file.smyprint,",
                 "smy53.smy_file.smy53,", 
                 "smydmy4.smy_file.smydmy4" 
    LET l_table = cl_prt_temptable('asmi300',gg_sql) CLIPPED
    IF l_table =-1 THEN EXIT PROGRAM END IF
    
    LET gg_sql = "smz01.smz_file.smz01,", 
                 "smz021.smz_file.smz021,",
                 "smz031.smz_file.smz031"    
    LET l_table1 = cl_prt_temptable('asmi3001',gg_sql) CLIPPED
    IF l_table1 =-1 THEN EXIT PROGRAM END IF     

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    
   # 系統為abm時，單據性質增加類型:3-款式BOM固定屬性變更單，4-正式BOM底稿單
    IF NOT s_industry('slk') THEN
      LET l_sql=
          "SELECT ze03 FROM ze_file ",
          " WHERE ze01 IN ('asm-024','asm-025','asm-092')",   #FUN-930108 add asm-092
          "  AND ze02 = '",g_lang,"'",
          " ORDER By ze01 "   
    ELSE  
      LET l_sql=
          "SELECT ze03 FROM ze_file ",
          " WHERE ze01 IN ('asm-024','asm-025','asm-082','asm-083','asm-092')", #FUN-930108 add asm-092
          "  AND ze02 = '",g_lang,"'",
          " ORDER By ze01 "   
    END IF 
    PREPARE i300_ze_abm_pre FROM l_sql
    DECLARE i300_ze_abm_cur CURSOR FOR i300_ze_abm_pre      
    LET g_i = 1
    LET g_abm_str = g_i
    FOREACH i300_ze_abm_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_abm_end = g_i - 1
 
    #aim=>
    DECLARE i300_ze_aim_cur CURSOR FOR
        SELECT ze03 FROM ze_file
         WHERE ze01 IN ('asm-023',
                        'asm-026','asm-027','asm-028','asm-029','asm-030',
                        'asm-031','asm-032','asm-033','asm-034','asm-035',
                        'asm-036','asm-037','asm-038','asm-039',
                        'asm-073','asm-074','asm-081','asm-704')   #FUN-770057 add asm-081 #CHI-960065 add asm-704
           AND ze02 = g_lang
         ORDER By ze01
    LET g_aim_str = g_i
    FOREACH i300_ze_aim_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_aim_end = g_i - 1
 
    #apm=>
    DECLARE i300_ze_apm_cur CURSOR FOR
        SELECT ze03 FROM ze_file
         WHERE ze01 IN ('asm-040','asm-041','asm-042','asm-043','asm-044','asm-045',
                        'asm-046','asm-047','asm-048','asm-049',
                        'asm-106','asm-107','asm-108','asm-109')   #TQC-9B0191 add
           AND ze02 = g_lang
         ORDER By ze01
    LET g_apm_str = g_i
    FOREACH i300_ze_apm_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_apm_end = g_i - 1
    
    #asf=>
    #No.FUn-810016 --begin-- 增加單據類型:O-單元報工單，P-產品工藝變更單
    #Q-工單工藝變更單，R-裁片轉移單
    IF NOT s_industry('slk') THEN 
      LET l_sql =
          "SELECT ze03 FROM ze_file ",
          " WHERE ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
          "                'asm-056','asm-057','asm-058','asm-059','asm-060',",
          "                'asm-061','asm-062','asm-063','asm-064','asm-065',",
          "                'asm-066','asm-067','asm-077',",  #TQC-740154
          "                'asm-079','asm-080','asm-084',",           #no.FUN-6B0045 #No.FUn-830087
          "                'asm-085','asm-086'",
          "               )    ",
          "  AND ze02 ='", g_lang,"'",
          "  ORDER By ze01"
    ELSE
    	LET l_sql = 
         "SELECT ze03 FROM ze_file ",
          " WHERE ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
          "                'asm-056','asm-057','asm-058','asm-059','asm-060',",
          "                'asm-061','asm-062','asm-063','asm-064','asm-065',",
          "                'asm-066','asm-067','asm-077',",  #TQC-740154
          "                'asm-079','asm-080', ",           #no.FUN-6B0045
          "                'asm-084','asm-085','asm-086','asm-087','asm-088','asm-089','asm-090'",  #No.FUN-870124 add asm-088
          "                'asm-093','asm-094'",  #FUN-A50023 add 
          "                )    ",
          "  AND ze02 ='", g_lang,"'",
          "  ORDER By ze01"
    END IF
    PREPARE i300_ze_asf_pre FROM l_sql
    DECLARE i300_ze_asf_cur CURSOR FOR i300_ze_asf_pre               
    LET g_asf_str = g_i
    FOREACH i300_ze_asf_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_asf_end = g_i - 1
 
    #aem=>
    DECLARE i300_ze_aem_cur CURSOR FOR
        SELECT ze03 FROM ze_file
         WHERE ze01 IN ('asm-068','asm-069','asm-070','asm-071')
           AND ze02 = g_lang
         ORDER By ze01
    LET g_aem_str = g_i
    FOREACH i300_ze_aem_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_aem_end = g_i - 1
 
    #asr=>
    DECLARE i300_ze_asr_cur CURSOR FOR
        SELECT ze03 FROM ze_file
         WHERE ze01 IN ('asm-072')
           AND ze02 = g_lang
         ORDER By ze01
    LET g_asr_str = g_i
    FOREACH i300_ze_asr_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_asr_end = g_i - 1
 
    #aqc=>
    DECLARE i300_ze_aqc_cur CURSOR FOR
        SELECT ze03 FROM ze_file
         WHERE ze01 IN ('asm-076','asm-078') #CHI-6A0061
           AND ze02 = g_lang
         ORDER By ze01
    LET g_aqc_str = g_i
    FOREACH i300_ze_aqc_cur INTO g_msg
        LET g_zemsg[g_i] = g_msg
        LET g_i = g_i + 1
    END FOREACH
    LET g_aqc_end = g_i - 1

    #art=>
    DECLARE i300_ze_art_cur CURSOR FOR
        SELECT ze03 FROM ze_file
           WHERE ze01 IN ('asm-427','asm-428','asm-429','asm-430',
                          'asm-431','asm-432','asm-433','asm-434',
                          'asm-435','asm-436','asm-437','asm-438',
                          'asm-439','asm-440','asm-441','asm-442',
                          'asm-443','asm-444','asm-445','asm-446',
                          'asm-447','asm-448','asm-449','asm-450',
                          'asm-451','asm-452','asm-453','asm-454')         #No.FUN-870007   #NO.FUN-960130
             AND ze02 = g_lang
           ORDER By ze01
    LET g_art_str = g_i
    FOREACH i300_ze_art_cur INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_art_end = g_i - 1
    DECLARE i300_ze_1 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-115','asm-116','asm-117','asm-118')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_1 = g_i
    FOREACH i300_ze_1 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_1 = g_i - 1
 
    DECLARE i300_ze_2 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-119','asm-120','asm-121',
                       'asm-122','asm-123','asm-124')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_2 = g_i
    FOREACH i300_ze_2 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_2 = g_i - 1
 
    DECLARE i300_ze_3 CURSOR FOR
     SELECT ze03 FROM ze_file
        #MOD-BA0154 --- strat ---
        #WHERE ze01 IN ('asm-101','asm-119','asm-120','asm-121')
        WHERE ze01 IN ('asm-119','asm-120','asm-121','asm-122','asm-123','asm-124')
        #MOD-BA0154 ---  end  ---
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_3 = g_i
    FOREACH i300_ze_3 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_3 = g_i - 1
 
    DECLARE i300_ze_4 CURSOR FOR
     SELECT ze03 FROM ze_file
        #MOD-BA0154 --- strat ---
        #WHERE ze01 IN ('asm-119','asm-120','asm-121','asm-126')
        WHERE ze01 IN ('asm-119','asm-120','asm-121','asm-122','asm-123','asm-124')
        #MOD-BA0154 ---  end  ---
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_5 = g_i
    LET g_str_4 = g_i
    FOREACH i300_ze_4 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_5 = g_i - 1
    LET g_end_4 = g_i - 1
 
    DECLARE i300_ze_6 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-127','asm-128','asm-129',
                       'asm-130','asm-131','asm-132','asm-133')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_6 = g_i
    FOREACH i300_ze_6 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_6 = g_i - 1
 
    DECLARE i300_ze_7 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-134','asm-135','asm-136',
                       'asm-137','asm-138','asm-139','asm-146') #TQC-CA0035 add asm-146
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_7 = g_i
    FOREACH i300_ze_7 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_7 = g_i - 1
 
    DECLARE i300_ze_8 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-140','asm-141','asm-142',
                       'asm-143','asm-144')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_8 = g_i
    FOREACH i300_ze_8 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_8 = g_i - 1

#FUN-A50023 add --begin
    DECLARE i300_ze_9 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-093')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_9 = g_i
    FOREACH i300_ze_9 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_9 = g_i - 1 

    DECLARE i300_ze_10 CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-094')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_10 = g_i
    FOREACH i300_ze_10 INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_10 = g_i - 1     
#FUN-A50023 add --end 

    DECLARE i300_ze_a CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-102','asm-103','asm-104','asm-105')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_a = g_i
    FOREACH i300_ze_a INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_a = g_i - 1

    DECLARE i300_ze_b CURSOR FOR
     SELECT ze03 FROM ze_file
        WHERE ze01 IN ('asm-102','asm-103','asm-104')
          AND ze02 = g_lang
       ORDER BY ze01
    LET g_str_b = g_i
    FOREACH i300_ze_b INTO g_msg
       LET g_zemsg[g_i] = g_msg
       LET g_i = g_i + 1
    END FOREACH
    LET g_end_b = g_i - 1

    OPEN WINDOW i300_w WITH FORM "asm/42f/asmi300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("smy61",FALSE)
    CALL cl_set_comp_visible("smy63",FALSE)  ##FUN-680010 
    CALL cl_set_comp_visible("smy76",g_sma.sma1432='Y')    #FUN-A80150 add
    CALL cl_set_comp_visible("smy77",g_sma.sma1433='Y')    #FUN-A80150 add
 
    IF g_sma.sma907 ='N' THEN
       CALL cl_set_comp_visible("smy62",FALSE)
    END IF
 
    IF g_aza.aza71 = 'N' THEN
       CALL cl_set_comp_visible("gb8",FALSE)
    ELSE
       CALL cl_set_comp_visible("gb8",TRUE)
    END IF
 
    #No:DEV-D30026--add--begin
    IF g_aza.aza131 MATCHES '[Nn]' OR cl_null(g_aza.aza131) THEN
       CALL cl_set_act_visible("barcode_related", FALSE)
    END IF
    #No:DEV-D30026--add--end

    LET g_forupd_sql = "SELECT * FROM smy_file WHERE smyslip = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i300_cl CURSOR FROM g_forupd_sql
 
    CALL i300_menu()
 
    CLOSE WINDOW i300_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i300_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
DEFINE  l_wc_str               STRING               #TQC-740141 add
DEFINE  l_i                    LIKE type_file.num5  #TQC-740141 add
DEFINE  l_smy57_o,l_smy57_n    LIKE type_file.chr20 #TQC-740141 add
 
    CLEAR FORM                             #清除畫面
    CALL g_smz.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_smy.* TO NULL    #No.FUN-750051
   #FUN-B40082 --START--
    #CONSTRUCT BY NAME g_wc ON smyslip,smydesc,smysys,smykind,smy72,smyauno,#smydmy5,         #FUN-A10109 mark by TSD.lucasyeh
    #                          smyware,smy58,smy52,smy51,smy61,smy62,smy63,smy75,smy57_3,smyprint,  #FUN-610014  TQC-650096 ##No.FUN-680010 #FUN-A80054
    #                          smydmy4,smy73,smy78,smy57_6,smy57_1,smy57_4,smy57_2,smy57_5, #FUN-9B0144   #TQC-B10177 add smy78                   
    #                          smy69,smy70,smy71,    #No.FUN-930119
    #                          smy67,smy68,smy76,smy77,     #NO.FUN-930105 add  #FUN-A80150 add smy76、smy77
    #                          smy64,       #NO.FUN-880016
    #                          smyapr,smyatsg,smysign,smydays,smyprit,smymemo1,
    #                          smydmy2,smydmy1,smy56,smy59,smy53,     #No.TQC-7B0149 add smy53       #FUN-950009 mod
    #                          #smy74,          #NO.FUN-A80026  #FUN-B30161 mark
    #                          smyuser,smygrup,smymodu,smydate,smyacti
     CONSTRUCT BY NAME g_wc ON smyslip,smydesc,smysys,smykind,smy72,smyauno,#smydmy5,         #FUN-A10109 mark by TSD.lucasyeh
                              smyware,smy58,smy57_3,smy52,smy51,smy61,smy62,smy63,smy75,smyprint,  #FUN-610014  TQC-650096 ##No.FUN-680010 #FUN-A80054
                              smydmy4,smy57_6,smy57_1,smy57_4,smy57_2,smy57_5, #FUN-9B0144   #TQC-B10177 add smy78                   
                              #smy69,smy70,smy71,    #No.FUN-930119
                              #smy67,smy68,smy76,smy77,     #NO.FUN-930105 add  #FUN-A80150 add smy76、smy77
                              #smy81,  #FUN-D10118 add smy81 TQC-D20066
                              smy64,       #NO.FUN-880016
                              smyapr,smyatsg,smysign,smydays,smyprit,smymemo1,
                              smydmy2,smydmy1,smy56,smy59,smy53,     #No.TQC-7B0149 add smy53       #FUN-950009 mod
                              smy73,
                              smy69,smy70,smy71,
                              smy67,smy68,smy76,smy77,
                              smy78,smy79,     #FUN-B40082
                              #smy74,          #NO.FUN-A80026  #FUN-B30161 mark
                              smyuser,smygrup,smymodu,smydate,smyacti,
                              #FUN-B50039-add-str--
                              smyorig,smyoriu, #TQC-C20032
                              smyud01,smyud02,smyud03,smyud04,smyud05,
                              smyud06,smyud07,smyud08,smyud09,smyud10,
                              smyud11,smyud12,smyud13,smyud14,smyud15,
                              #FUN-B50039-add-end--
                              smy80           #FUN-CA0008 add 
    #FUN-B40082 --END--
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           IF INFIELD(smyslip) THEN        #單別
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_smy1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smyslip
              NEXT FIELD smyslip
           END IF
           IF INFIELD(smysign) THEN        #簽核等級
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aze"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smysign
              NEXT FIELD smysign
           END IF
           IF INFIELD(smysys) THEN                #系統別
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sys"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smysys
              NEXT FIELD smysys
           END IF
           
           IF INFIELD(smy67) THEN 
              CALL q_smy(TRUE,TRUE,'','ASF','A') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy67
              NEXT FIELD smy67
           END IF 
           
           IF INFIELD(smy68) THEN 
              CALL q_smy(TRUE,TRUE,'','ASF','B') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy68
              NEXT FIELD smy68
           END IF    
           
          #FUN-A80150---add---start---
           IF INFIELD(smy76) THEN 
              CALL q_smy(TRUE,TRUE,'','APM','2') RETURNING g_qryparam.multiret 
              DISPLAY g_qryparam.multiret TO smy76
              NEXT FIELD smy76
           END IF    
           IF INFIELD(smy77) THEN 
              CALL q_smy(TRUE,TRUE,'','APM','3') RETURNING g_qryparam.multiret 
              DISPLAY g_qryparam.multiret TO smy77
              NEXT FIELD smy77
           END IF    
          #FUN-A80150---add---end---
           IF INFIELD(smy51) THEN
              IF g_smy.smysys = 'apm' THEN
                 IF g_smy.smykind = 'B' THEN
                    CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','D') RETURNING g_smy.smy51
                 ELSE
                   #CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','4') RETURNING g_smy.smy51   #TQC-670008
                    CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','E') RETURNING g_smy.smy51   #TQC-670008  #MOD-C20127
                 END IF   #TQC-9B0191
                 DISPLAY BY NAME g_smy.smy51
                 NEXT FIELD smy51
              END IF
           END IF
           IF INFIELD(smy52) THEN
              DISPLAY "g_smy.smysys=",g_smy.smysys
              IF g_smy.smysys = 'apm' THEN
                 IF g_smy.smykind = 'B' THEN
                    CALL q_smy(FALSE, FALSE,g_smy.smy52,'APM','C') RETURNING g_smy.smy52
                 ELSE 
                    CALL q_smy(FALSE, FALSE,g_smy.smy52,'APM','7') RETURNING g_smy.smy52   #TQC-670008
                 END IF    #TQC-9B0191
              END IF
              IF g_smy.smysys = 'asf' THEN
                 IF g_smy.smykind = '1' THEN
                    CALL q_smy(FALSE, FALSE,g_smy.smy52,'ASF','2') RETURNING g_smy.smy52   #TQC-670008
                 ELSE
                    CALL q_smy(FALSE, FALSE,g_smy.smy52,'ASF','A') RETURNING g_smy.smy52   #TQC-670008
                 END IF
              END IF
              DISPLAY BY NAME g_smy.smy52
              NEXT FIELD smy52
           END IF
           #組合拆解關聯單別
           IF INFIELD(smy69) THEN  #工單
              CALL q_smy(TRUE,TRUE,'','ASF','1') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy69
              NEXT FIELD smy69
           END IF
           IF INFIELD(smy70) THEN  #發料單
              CALL q_smy(TRUE,TRUE,'','ASF','3') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy70
              NEXT FIELD smy70
           END IF
           IF INFIELD(smy71) THEN  #完工入庫單  #下面A..根本不用care
              CALL q_smy(TRUE,TRUE,'','ASF','A') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy71
              NEXT FIELD smy71
           END IF
                     
           IF INFIELD(smy63) THEN
              IF g_smy.smysys = 'apm' THEN
                 CALL q_smy(FALSE, FALSE,g_smy.smy63,'APM','4') RETURNING g_smy.smy63   
                 DISPLAY BY NAME g_smy.smy63
                 NEXT FIELD smy63
              END IF
           END IF
           #FUN-A80054--begin--add-----------
           IF INFIELD(smy75) THEN  #對應PBI單別
              CALL q_smy(TRUE,TRUE,'','ASF','8') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy75
              NEXT FIELD smy75
           END IF
           #FUN-A80054--end--add----------
           IF INFIELD(smy61) THEN
              IF g_smy.smysys = 'aim' THEN
                 IF g_smy.smykind='E' THEN
                    CALL q_smy(FALSE, FALSE,g_smy.smy61,'AIM','1') RETURNING g_smy.smy61  #TQC-670008
                 END IF
                 DISPLAY BY NAME g_smy.smy61
                 NEXT FIELD smy61
              END IF
           END IF
           IF INFIELD(smy62) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aga"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy62
              NEXT FIELD smy62
           END IF
           #FUN-B40082 --START--
           IF INFIELD(smy79) THEN  
              CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_smy.smy79
              DISPLAY BY NAME g_smy.smy79
              NEXT FIELD smy79
           END IF
           #FUN-B40082 --END--

           #FUN-CA0008 --START--
           IF INFIELD(smy80) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_eci"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO smy80
              NEXT FIELD smy80
           END IF
           #FUN-CA0008 --END--

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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
 
   #因smy57的使用特殊,在畫面上所輸入的欄位無法直接使用在SQL中要先轉碼
   #資料查詢時才不會有錯誤產生,要注意per smy57欄位有調整的話,下方的欄位
   #欄位轉換也要跟著變動
   #將smy57_x  --> smy57[x,x]
 
    LET l_wc_str = g_wc
    LET l_i = 0 
    FOR l_i = 1 TO 6     #因smy57 為char(6)所以設定 1-6 
        LET l_smy57_o = 'smy57_',l_i USING '&' CLIPPED
        LET l_smy57_n = 'smy57[',l_i USING '&',',',l_i USING '&',']' CLIPPED
        LET l_wc_str = cl_replace_str(l_wc_str,l_smy57_o,l_smy57_n)
    END FOR 
    LET g_wc = l_wc_str 
 
    IF g_argv1 <> ' ' THEN
       LET g_wc=g_wc CLIPPED," AND smysys='",g_argv1,"'"
    END IF
 
    CONSTRUCT g_wc2 ON smz021,smz031 FROM s_smz[1].smz021, s_smz[1].smz031
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
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(smz021)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_imd"
             LET g_qryparam.arg1     = 'SW'        #倉庫類別
             LET g_qryparam.state    = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO smz021
             NEXT FIELD smz021
          WHEN INFIELD(smz031) #儲位
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_imfe"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = GET_FLDBUF(smz031)
             LET g_qryparam.arg1 =GET_FLDBUF(smz021)
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO smz031
             NEXT FIELD smz031
          OTHERWISE EXIT CASE
       END CASE
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF  s_industry("slk") THEN                       #No.FUN-810016--add--  #No.FUN-840137
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT smyslip FROM smy_file",
                   " WHERE ", g_wc CLIPPED,          
                   " ORDER BY smyslip"       
    ELSE                                        # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE smy_file.smyslip",
                   "  FROM smy_file, smz_file",
                   " WHERE smyslip = smz01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY smyslip"
    END IF
  ELSE   
  	IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
  	   LET g_sql = "SELECT smyslip FROM smy_file",
                   " WHERE ", g_wc CLIPPED, 
                   " AND smyslip NOT IN ",
                   " (SELECT smyslip FROM smy_file where (smysys= 'abm' and (smykind ='3' or smykind ='4') )or(smysys= 'asf' and smykind ='R'))",
                   " ORDER BY smyslip" 
    ELSE                                        # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE smy_file.smyslip",
                   "  FROM smy_file, smz_file",
                   " WHERE smyslip = smz01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND smyslip NOT IN ",                                                                                                        #MOD-A10166
                   " (SELECT smyslip FROM smy_file where (smysys= 'abm' and (smykind ='3' or smykind ='4') )or(smysys= 'asf' and smykind ='R'))",
                   " ORDER BY smyslip"              
    END IF 
  END IF 
    DISPLAY "g_sql=",g_sql
    PREPARE i300_prepare FROM g_sql
    DECLARE i300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i300_prepare
 
  IF  s_industry("slk") THEN                       #No.FUN-810016--add--
    IF g_wc2 = " 1=1" THEN                        # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM smy_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT smyslip) FROM smy_file,smz_file",
                 " WHERE smz01=smyslip",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
  ELSE   
  	IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
  	   LET g_sql = "SELECT COUNT(*) FROM smy_file ",
                   " WHERE ", g_wc CLIPPED, 
                   " AND smyslip NOT IN ",
                   " (SELECT smyslip FROM smy_file where (smysys= 'abm' and (smykind ='3' or smykind ='4') )or(smysys= 'asf' and smykind ='R'))"
    ELSE                                        # 若單身有輸入條件
       LET g_sql = "SELECT COUNT(DISTINCT smyslip)",
                   "  FROM smy_file, smz_file",
                   " WHERE smyslip = smz01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND smyslip NOT IN ",                                                                                                        #MOD-A10166
                   " (SELECT smyslip FROM smy_file where (smysys= 'abm' and (smykind ='3' or smykind ='4') )or(smysys= 'asf' and smykind ='R'))"            
    END IF 
  END IF 
    PREPARE i300_precount FROM g_sql
    DECLARE i300_count CURSOR FOR i300_precount
 
END FUNCTION
 
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i300_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i300_x()
                CALL cl_set_field_pic("","","","","",g_smy.smyacti)#No.MOD-480023
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i300_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "倉庫單身"      #NO:6842
         WHEN "detail"
            IF NOT cl_null(g_smy.smyslip) THEN
               IF cl_chk_act_auth() THEN
                  CALL i300_b()
               ELSE
               END IF
            ELSE
               CALL cl_err('','-400',0)
            END IF
            LET g_action_choice = ""
       #@WHEN "使用者設限"
         WHEN "authorization"
            IF NOT cl_null(g_smy.smyslip) THEN  #NO:6842
               IF cl_chk_act_auth() THEN
                  CALL s_smu(g_smy.smyslip,g_smy.smysys)
               END IF
               LET g_msg = s_smu_d(g_smy.smyslip,g_smy.smysys)
               DISPLAY g_msg TO smu02_display
            ELSE
              CALL cl_err('','-400',0)
            END IF
       #@WHEN "部門設限"     #NO:6842
         WHEN "dept_authorization"     #NO:6842
            IF NOT cl_null(g_smy.smyslip) THEN
               IF cl_chk_act_auth() THEN
                  CALL s_smv(g_smy.smyslip,g_smy.smysys)
               END IF
               LET g_msg = s_smv_d(g_smy.smyslip,g_smy.smysys)
               DISPLAY g_msg TO smv02_display
            ELSE
               CALL cl_err('','-400',0)
            END IF
         WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_smy.smyslip IS NOT NULL THEN
                  LET g_doc.column1 = "smyslip"
                  LET g_doc.value1 = g_smy.smyslip
                  CALL cl_doc()
               END IF
            END IF
        #DEV-D30026--add--begin
         WHEN "barcode_related"  #條碼相關
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_smy.smyslip) THEN
                  LET g_t1 = s_get_doc_no(g_smy.smyslip)
                  LET g_msg="abai150 '",g_t1,"'"
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                  CALL cl_err('','anm-217',0)
               END IF
            END IF
        #DEV-D30026--add--end
         WHEN "exporttoexcel"     #FUN-4B0048
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_smz),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i300_a()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_smz.clear()
   INITIALIZE g_smy.* LIKE smy_file.*             #DEFAULT 設定
 
   IF g_argv1<>' ' THEN
      LET g_smy.smysys=g_argv1
   END IF
 
   LET g_smyslip_t = NULL
   LET g_smy_o.* = g_smy.*
   LET g_smy.smyuser=g_user
   LET g_smy.smyoriu = g_user #FUN-980030
   LET g_smy.smyorig = g_grup #FUN-980030
   LET g_smy.smygrup=g_grup
   LET g_smy.smydate=g_today
   LET g_smy.smyacti='Y'           #資料有效
   LET g_smy.smyauno='Y'
   #LET g_smy.smydmy5='2'          #FUN-A10109 mark by TSD.lucasyeh
   LET g_smy.smydmy1='Y'
   LET g_smy.smy61=''              #FUN-530038
   LET g_smy.smy56='Y'
   LET smy57_1='N'
   LET smy57_2='N'
   LET smy57_3='N'
   LET smy57_4='N'
   LET smy57_5='N'                 #add 021111 NO.A041
   LET smy57_6='1'                 #add 021111 NO.A041
   LET g_smy.smy58='N'
   LET g_smy.smy59='N'
   LET g_smy.smy53='N'      #No.TQC-7B0149
   #LET g_smy.smy74= 'N'     #No.FUN-A80026  #FUN-B30161 mark
   LET g_smy.smydmy4='N'
   LET g_smy.smyapr ='N'
   LET g_smy.smyatsg='N'
   LET g_smy.smyprint='N'
   LET g_smy.smyware='0'
   LET g_smy.smy73='N'     #FUN-9B0144
   IF g_aza.aza71 = 'Y' THEN
       IF g_smy.smysys = 'apm' THEN
           LET g_smy.smy64 = '1' 
       ELSE
           LET g_smy.smy64 = '0'
       END IF
   ELSE
       LET g_smy.smy64 = '0'
   END IF
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i300_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_smy.smyslip IS NULL THEN CONTINUE WHILE END IF
 
      IF g_smy.smyatsg = 'Y'  THEN
         LET g_smy.smysign = ' '
      END IF
 
      IF cl_null(smy57_1) THEN LET smy57_1='N' END IF
      IF cl_null(smy57_2) THEN LET smy57_2='N' END IF
      IF cl_null(smy57_3) THEN LET smy57_3='N' END IF
      IF cl_null(smy57_4) THEN LET smy57_4='N' END IF
      IF cl_null(smy57_5) THEN LET smy57_5='N' END IF
      IF cl_null(smy57_6) THEN LET smy57_6='1' END IF
      LET g_smy.smy57=smy57_1,smy57_2,smy57_3,smy57_4,smy57_5,smy57_6
 
      IF cl_null(g_smy.smy62) THEN
         LET g_smy.smy62 = ' '
      END IF

      #FUN-A10109 mark by TSD.lucasyeh---(S) 
      #IF g_smy.smysys='aim' AND g_smy.smykind='5' THEN  
      #   LET g_smy.smydmy5='1'
      #   DISPLAY BY NAME g_smy.smydmy5 
      #END IF
      #FUN-A10109 mark by TSD.lucasyeh---(E) 
      INSERT INTO smy_file VALUES(g_smy.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
         CALL cl_err3("ins","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
         CONTINUE WHILE
      END IF
      #FUN-A10109  ===S===
      CALL s_access_doc('a',g_smy.smyauno,g_smy.smykind,g_smy.smyslip,UPSHIFT(g_smy.smysys),g_smy.smyacti)
      #FUN-A10109  ===E===
 
      LET g_smy_t.* = g_smy.*
      CALL g_smz.clear()
      LET g_rec_b = 0
 
      SELECT smyslip INTO g_smy.smyslip FROM smy_file
       WHERE smyslip = g_smy.smyslip
      LET g_smyslip_t = g_smy.smyslip        #保留舊值
 
      CALL i300_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
   LET g_wc=' '
 
END FUNCTION
 
FUNCTION i300_u()
DEFINE l_cnt     LIKE type_file.num10     #No.FUN-610060 add   #No.FUN-690010 INTEGER 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_smy.smyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_smy.smyslip
   IF g_smy.smyacti = 'N' THEN
       CALL cl_err('',9027,0)
       RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_smyslip_t = g_smy.smyslip
   LET g_smy_o.* = g_smy.*
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i300_cl USING g_smy.smyslip
   IF STATUS THEN
      CALL cl_err("OPEN i300_cl:", STATUS, 1)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i300_cl INTO g_smy.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i300_cl
      RETURN
   END IF
 
   CALL i300_show()
 
   WHILE TRUE
      LET g_smyslip_t = g_smy.smyslip
      LET g_smy.smymodu=g_user
      LET g_smy.smydate=g_today
      LET smy57_1=g_smy.smy57[1,1]
      LET smy57_2=g_smy.smy57[2,2]
      LET smy57_3=g_smy.smy57[3,3]
      LET smy57_4=g_smy.smy57[4,4]
      LET smy57_5=g_smy.smy57[5,5]  #modify 021111 NO.A041
      LET smy57_6=g_smy.smy57[6,6]
      IF cl_null(smy57_1)      THEN LET smy57_1='N' END IF
      IF cl_null(smy57_2)      THEN LET smy57_2='N' END IF
      IF cl_null(smy57_3)      THEN LET smy57_3='N' END IF
      IF cl_null(smy57_4)      THEN LET smy57_4='N' END IF
      IF cl_null(smy57_5)      THEN LET smy57_5='N' END IF #modify 021111 NO.A041
      IF cl_null(smy57_6)      THEN LET smy57_6='1' END IF
      IF cl_null(g_smy.smy58)  THEN LET g_smy.smy58  ='N' END IF
 
      CALL i300_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_smy.*=g_smy_t.*
         CALL i300_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_smy.smyatsg MATCHES '[Yy]' AND g_smy.smyapr MATCHES '[Yy]' THEN
         LET g_smy.smysign = ' '
      END IF
 
      LET g_smy.smy57=smy57_1,smy57_2,smy57_3,smy57_4,smy57_5,smy57_6 #modify 021111 NO.A041
      LET g_smy.smy54 = ''   #FUN-510041 add
 
      IF cl_null(g_smy.smy62) THEN
         LET g_smy.smy62 = ' '
      END IF
 
      IF cl_null(g_smy.smy64) THEN LET g_smy.smy64 = '0' END IF  #FUN-880016 
      UPDATE smy_file SET * = g_smy.* WHERE smyslip = g_smy.smyslip
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","smy_file",g_smyslip_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
         CONTINUE WHILE
         LET g_success='N'
      END IF
 
      #FUN-A10109  ===S===
      CALL s_access_doc('r','','',g_smy.smyslip,UPSHIFT(g_smy_t.smysys),g_smy.smyacti)
      CALL s_access_doc('a',g_smy.smyauno,g_smy.smykind,g_smy.smyslip,UPSHIFT(g_smy.smysys),g_smy.smyacti)
      #FUN-A10109  ===E===

#加上oay單據性質的控管(50-60)才更新,以免如多角貿易一單到底的狀況,
#因訂單與採購單的單別相同,採購單異動也會同時異動訂單的狀況
 
      SELECT COUNT(*) INTO l_cnt FROM oay_file 
       WHERE oayslip=g_smy.smyslip
         AND (( oaytype LIKE '5%' AND oaytype !='55' ) 
          OR oaytype like 'I%' OR oaytype like 'J%'    #No.FUN-A70130 Add
          OR oaytype = 'U6' OR oaytype = 'U7'          #No.FUN-A70130 Add
          OR oaytype LIKE '6%' OR oaytype LIKE '4%')   #CHI-D30015 add 4
 
      IF l_cnt > 0 THEN
         CALL i300_upd_oay()
         LET g_smy.*=g_smy_t.*
      END IF
 
 
      CALL i300_ins()   #NO:6842
 
      EXIT WHILE
   END WHILE
 
   CLOSE i300_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION i300_ins()    # 調整權限人員NO:6842
DEFINE
      l_smv      RECORD LIKE smv_file.*,
      l_smu      RECORD LIKE smu_file.*
DEFINE l_smy_t_smysys     LIKE smy_file.smysys
 
   LET l_smy_t_smysys = g_smy_t.smysys
   LET l_smy_t_smysys = UPSHIFT(l_smy_t_smysys)
 
   IF g_smy.smysys != g_smy_t.smysys THEN
      LET g_sql=" SELECT smv_file.*  FROM smv_file ",
                "  WHERE smv01='",g_smy.smyslip,"' ",
                "    AND UPPER(smv03)='",l_smy_t_smysys, "' "
      PREPARE i300_smv FROM g_sql
      DECLARE smv_curs
      CURSOR FOR i300_smv
 
      LET g_sql=" SELECT smu_file.*  FROM smu_file ",
                "  WHERE smu01='",g_smy.smyslip,"' ",
                "    AND UPPER(smu03)='",l_smy_t_smysys, "' "
      PREPARE i300_smu FROM g_sql
      DECLARE smu_curs
      CURSOR FOR i300_smu
 
      FOREACH smv_curs INTO l_smv.*
         LET l_smv.smv03=g_smy.smysys
         LET l_smv.smv03=UPSHIFT(l_smv.smv03)    #No.TQC-670002 add
         INSERT INTO smv_file VALUES (l_smv.*)
         IF SQLCA.sqlcode AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN #CHI-790021
            CALL cl_err3("ins","smv_file",l_smv.smv01,l_smv.smv02,SQLCA.sqlcode,"","ins smv:",1)  #No.FUN-660138
            LET g_success='N'
            RETURN
         ELSE
            CONTINUE FOREACH
         END IF
 
      END FOREACH
      DELETE FROM smv_file WHERE smv01=g_smy.smyslip AND UPPER(smv03)=l_smy_t_smysys
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","smv_file",g_smy.smyslip,g_smy_t.smysys,SQLCA.sqlcode,"","",1)  #No.FUN-660138
         LET g_success='N'
         RETURN
      END IF
 
      FOREACH smu_curs INTO l_smu.*
         LET l_smu.smu03=g_smy.smysys
         LET l_smu.smu03=UPSHIFT(l_smu.smu03)    #No.TQC-670002 add
         INSERT INTO smu_file VALUES (l_smu.*)
         IF SQLCA.sqlcode AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN #CHI-790021
            CALL cl_err3("ins","smu_file",l_smu.smu01,l_smu.smu02,SQLCA.sqlcode,"","ins smu:",1)  #No.FUN-660138
            LET g_success='N'
            RETURN
         ELSE
            CONTINUE FOREACH
         END IF
      END FOREACH
 
      DELETE FROM smu_file WHERE smu01=g_smy.smyslip AND UPPER(smu03)=l_smy_t_smysys
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","smu_file",g_smy.smyslip,g_smy_t.smysys,SQLCA.sqlcode,"","",1)  #No.FUN-660138
         LET g_success='N'
         RETURN
       END IF
   END IF
 
END FUNCTION
 
#處理INPUT
FUNCTION i300_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
    l_count         LIKE type_file.num5,    #No.FUN-690010  SMALLINT
    l_n1            LIKE type_file.num5,    #No.FUN-690010  SMALLINT
    l_key           LIKE smy_file.smyapr,   #TQC-760164
    p_cmd           LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
    DEFINE l_i      LIKE type_file.num5     #No.FUN-560150  #No.FUN-690010 SMALLINT
        
    DISPLAY smy57_1,smy57_2,smy57_3 ,smy57_4,smy57_5 ,smy57_6
         TO FORMONLY.smy57_1, FORMONLY.smy57_2,
            FORMONLY.smy57_3, FORMONLY.smy57_4,
            FORMONLY.smy57_5, FORMONLY.smy57_6    #modify 021111 NO.A041
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    #FUN-B40082 --START--
    #INPUT BY NAME g_smy.smyoriu,g_smy.smyorig,
    #      g_smy.smyslip,g_smy.smydesc,g_smy.smysys,g_smy.smykind,g_smy.smy72,
    #      #FUN-A10109 mod by TSD.lucasyeh---(S)
    #      #g_smy.smyauno,g_smy.smydmy5,g_smy.smyware,g_smy.smy58,
    #      g_smy.smyauno,g_smy.smyware,g_smy.smy58,
    #      #FUN-A10109 mod by TSD.lucasyeh---(E)
    #      g_smy.smy52,g_smy.smy51,g_smy.smy61,g_smy.smy62,g_smy.smy63,
    #      g_smy.smy75,smy57_3,g_smy.smyprint,g_smy.smydmy4, #FUN-610014 TQC-650096 ##No.FUN-680010 #FUN-A80054
    #      g_smy.smy73,  #FUN-9B0144
    #      g_smy.smy78,  #TQC-B10177 
    #      smy57_6,smy57_1,smy57_4,smy57_2,smy57_5, 
    #      g_smy.smy69,g_smy.smy70,g_smy.smy71,        #No.FUN-930119
    #      g_smy.smy67,g_smy.smy68,                    #NO.FUN-930105
    #      g_smy.smy76,g_smy.smy77,                    #FUN-A80150 add
    #      g_smy.smy64,                                #NO.FUN-880016
    #      g_smy.smyapr,
    #      g_smy.smyatsg,g_smy.smysign,g_smy.smydays,g_smy.smyprit,
    #      g_smy.smymemo1,g_smy.smydmy2,g_smy.smydmy1,g_smy.smy56,
    #      g_smy.smy59,g_smy.smy53,  #g_smy.smy55,        #No.TQC-7B0149 add smy53 #FUN-950009
    #      #g_smy.smy74,              #No.FUN-A80026  #FUN-B30161 mark
    #      g_smy.smyuser,g_smy.smygrup,g_smy.smymodu,g_smy.smydate,g_smy.smyacti
    INPUT BY NAME g_smy.smyoriu,g_smy.smyorig,
          g_smy.smyslip,g_smy.smydesc,g_smy.smysys,g_smy.smykind,g_smy.smy72,
          #FUN-A10109 mod by TSD.lucasyeh---(S)
          #g_smy.smyauno,g_smy.smydmy5,g_smy.smyware,g_smy.smy58,
          g_smy.smyauno,g_smy.smyware,g_smy.smy58,smy57_3,
          #FUN-A10109 mod by TSD.lucasyeh---(E)
          g_smy.smy52,g_smy.smy51,g_smy.smy61,g_smy.smy62,g_smy.smy63,
          g_smy.smy75,g_smy.smyprint,g_smy.smydmy4, #FUN-610014 TQC-650096 ##No.FUN-680010 #FUN-A80054
          #g_smy.smy73,  #FUN-9B0144
          #g_smy.smy78,  #TQC-B10177 
          smy57_6,smy57_1,smy57_4,smy57_2,smy57_5, #g_smy.smy81, #FUN-D10118
          #g_smy.smy69,g_smy.smy70,g_smy.smy71,        #No.FUN-930119
          #g_smy.smy67,g_smy.smy68,                    #NO.FUN-930105
          #g_smy.smy76,g_smy.smy77,                    #FUN-A80150 add
          g_smy.smy64,                                #NO.FUN-880016
          g_smy.smyapr,
          g_smy.smyatsg,g_smy.smysign,g_smy.smydays,g_smy.smyprit,
          g_smy.smymemo1,g_smy.smydmy2,g_smy.smydmy1,g_smy.smy56,
          g_smy.smy59,g_smy.smy53,  #g_smy.smy55,        #No.TQC-7B0149 add smy53 #FUN-950009
          g_smy.smy73,
          g_smy.smy69,g_smy.smy70,g_smy.smy71,
          g_smy.smy67,g_smy.smy68,
          g_smy.smy76,g_smy.smy77,
          g_smy.smy78,g_smy.smy79,   #FUN-B40082
          #g_smy.smy74,              #No.FUN-A80026  #FUN-B30161 mark
          g_smy.smyuser,g_smy.smygrup,g_smy.smymodu,g_smy.smydate,g_smy.smyacti,
   #FUN-B40082 --END--
          #FUN-B50039-add-str--
          g_smy.smyud01,g_smy.smyud02,g_smy.smyud03,g_smy.smyud04,g_smy.smyud05,
          g_smy.smyud06,g_smy.smyud07,g_smy.smyud08,g_smy.smyud09,g_smy.smyud10,
          g_smy.smyud11,g_smy.smyud12,g_smy.smyud13,g_smy.smyud14,g_smy.smyud15,
          #FUN-B50039-add-end--
          g_smy.smy80           #FUN-CA0008 add
          WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i300_set_entry(p_cmd)
            CALL i300_set_no_entry(p_cmd)
             #No.MOD-470535 smy51,smy52 先關閉，符合狀況才開啟
            CALL i300_set_noentry_smy51(p_cmd)
            CALL i300_set_entry_smy51(p_cmd)
            CALL i300_set_entry_smy69(p_cmd)
            CALL i300_set_noentry_smy69(p_cmd)
            
            CALL i300_set_noentry_smy67(p_cmd)   #NO.FUN-930105 
            CALL i300_set_entry_smy67(p_cmd)     #NO.FUN-930105
            CALL i300_set_noentry_smy75()   #NO.FUN-A80054 
            CALL i300_set_entry_smy75()     #NO.FUN-A80054
            LET g_before_input_done = TRUE
            CALL cl_set_doctype_format("smyslip")
            CALL i300_set_noentry_smy72()
            CALL i300_set_entry_smy72()
            CALL i300_set_entry_smy73()     #FUN-9B0144
            CALL i300_set_entry_smy79()     #TQC-C20542
           #FUN-CA0008 add----start
            IF g_smy.smysys = 'asf' AND g_smy.smykind = 'J' THEN
               CALL cl_set_comp_entry("smy80",TRUE)
            ELSE
               LET g_smy.smy80 = ''
               CALL cl_set_comp_entry("smy80",FALSE)
            END IF
           #FUN-CA0008 add----end
 
        AFTER FIELD smyslip
           IF cl_null(g_smy_o.smyslip) OR                #若輸入
              g_smy.smyslip != g_smy_o.smyslip THEN    #更改鍵值
              SELECT COUNT(*) INTO l_n1 FROM smy_file
               WHERE smyslip = g_smy.smyslip
              IF l_n1 > 0 THEN
                 CALL cl_err(g_smy.smyslip,'asm-099',0)
                 LET g_smy.smyslip = g_smy_t.smyslip
                 NEXT FIELD smyslip
              END IF
              FOR l_i = 1 TO g_doc_len
                 IF cl_null(g_smy.smyslip[l_i,l_i]) THEN
                    CALL cl_err('','sub-146',0)
                    NEXT FIELD smyslip
                 END IF
                #----------No:CHI-8B0052 add
                 IF g_smy.smyslip[l_i,l_i] = '-' THEN
                     CALL cl_err('','sub-519',0)
                    NEXT FIELD smyslip
                 END IF
                #----------No:CHI-8B0052 end
              END FOR
           END IF
 
        AFTER FIELD smyauno
           IF NOT cl_null(g_smy.smyauno) THEN
              IF g_smy.smyauno NOT MATCHES '[YN]' THEN
                 NEXT FIELD smyauno
              END IF
           END IF
 
        AFTER FIELD smyware
           IF NOT cl_null(g_smy.smyware) THEN
              IF g_smy.smyware NOT MATCHES '[01234]' THEN NEXT FIELD smyware END IF
           END IF

 
        AFTER FIELD smyapr
           IF NOT cl_null(g_smy.smyapr) THEN
              IF g_smy.smyapr NOT MATCHES '[YN]' THEN NEXT FIELD smyapr END IF
                IF g_smy.smyapr='Y' THEN
                   LET g_cnt=0
                   SELECT COUNT(*) INTO g_cnt FROM oay_file 
                    WHERE oayslip=g_smy.smyslip
                      AND (( oaytype LIKE '5%' AND oaytype !='55' ) 
                       OR oaytype LIKE '6%' )
                   IF g_cnt>0 AND g_smy.smydmy4='Y' THEN
                      CALL cl_err('','axm-066',0)
                      LET g_smy.smyapr="N"
                      NEXT FIELD smyapr
                   END IF 
                 END IF
           END IF
 
        BEFORE FIELD smyatsg
           CALL i300_set_entry(p_cmd)
 
        AFTER FIELD smyatsg
           IF NOT cl_null(g_smy.smyatsg) THEN
              IF g_smy.smyatsg NOT MATCHES '[YN]' THEN
                 NEXT FIELD smyatsg
              END IF
           END IF
           CALL i300_set_no_entry(p_cmd)
 
        BEFORE FIELD smysign
          IF g_smy.smyatsg = 'Y' THEN
             LET g_smy.smysign = ' '
             DISPLAY BY NAME g_smy.smysign
          END IF
 
        AFTER FIELD smysign
          IF NOT cl_null(g_smy.smysign) THEN
             SELECT COUNT(*) INTO g_cnt  FROM aze_file
              WHERE aze01 = g_smy.smysign
             IF g_cnt = 0 THEN
                CALL cl_err('sel aze',100,1)
                NEXT FIELD smysign
             END IF
          END IF
 
        AFTER FIELD smydmy2
          IF NOT cl_null(g_smy.smydmy2) THEN
              IF g_smy.smydmy2 NOT MATCHES '[12345X]' THEN NEXT FIELD smydmy2 END IF
          END IF
 
        AFTER FIELD smydmy1
          IF NOT cl_null(g_smy.smydmy1) THEN
              IF g_smy.smydmy1 NOT MATCHES '[YN]' THEN NEXT FIELD smydmy1 END IF
              IF g_smy.smydmy1 = 'Y' AND g_smy.smydmy2 = 'X'
              THEN CALL cl_err(g_smy.smydmy1,'mfg0180',1)
                   NEXT FIELD smydmy1
              END IF
          END IF
 
        BEFORE FIELD smy58
          CALL i300_set_noentry_smy51(p_cmd)
 
        AFTER FIELD smy58
          IF NOT cl_null(g_smy.smy58) THEN
              IF g_smy.smy58 not matches '[YN]' THEN
                  NEXT FIELD smy58
              END IF
          END IF
          CALL i300_set_entry_smy51(p_cmd)
 
         ON CHANGE smy58                        #--No.MOD-550137
            CALL i300_set_entry_smy51(p_cmd)    #--No.MOD-550137
#TQC-A50081 --begin--
            IF g_smy.smy58 = 'Y' THEN 
               LET smy57_1 = 'Y'
            ELSE
            	 LET smy57_1 = 'N'
            END IF  	    
            DISPLAY smy57_1 TO FORMONLY.smy57_1
#TQC-A50081 --end-- 
 
 
        AFTER FIELD smy52
          IF NOT cl_null(g_smy.smy52) THEN
              IF g_smy.smysys='apm' AND g_smy.smykind='3' THEN
                 IF NOT cl_null(g_smy.smy52) THEN
                    SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                     WHERE smyslip=g_smy.smy52 AND smysys='apm' {AND smykind='3'}
                       AND smykind = '7'   #TQC-9B0191
                    IF g_cnt=0 THEN 
                       CALL cl_err(g_smy.smy52,'asm-110',1)    #No.TQC-980186 add #TQC-9B0191
                       NEXT FIELD smy52 
                    END IF
                    LET g_cnt = 0                              #No.TQC-980186 add
                    SELECT COUNT(*) INTO g_cnt FROM smy_file
                     WHERE smysys = 'apm' AND smykind = '3'
                       AND smy52 = g_smy.smy52 AND smyslip!=g_smy.smyslip
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_smy.smy52,'apm-001',1)   #TQC-9B0191
                    END IF
                 END IF
              END IF
              IF g_smy.smysys='apm' AND g_smy.smykind='B' THEN
                    LET g_cnt = 0
                    SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                     WHERE smyslip=g_smy.smy52 AND smysys='apm'
                       AND smykind = 'C'
                    IF g_cnt=0 THEN 
                       CALL cl_err(g_smy.smy52,'asm-110',1) 
                       NEXT FIELD smy52 
                    END IF
                    LET g_cnt = 0  
                    SELECT COUNT(*) INTO g_cnt FROM smy_file
                     WHERE smysys = 'apm' AND smykind = 'B'
                       AND smy52 = g_smy.smy52 AND smyslip!=g_smy.smyslip
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_smy.smy52,'apm-001',1)  #TQC-9B0191
                    END IF
              END IF
              IF g_smy.smysys='asf' AND g_smy.smykind='B' THEN
                 IF cl_null(g_smy.smy52) THEN NEXT FIELD smy52 END IF
                 SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                  WHERE smyslip=g_smy.smy52 AND smysys='asf' {AND smykind='A'}
                 IF g_cnt=0 THEN
                    CALL cl_err(g_smy.smy52,'aap-010',1)   #No.TQC-980186 add
                    NEXT FIELD smy52 
                 END IF
              END IF
              IF g_smy.smysys='asf' AND g_smy.smykind='1' AND g_smy.smy58='Y' THEN
                 IF cl_null(g_smy.smy52) THEN NEXT FIELD smy52 END IF
                 SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                  WHERE smyslip=g_smy.smy52 AND smysys='asf' AND smykind='2'
                 IF g_cnt=0 THEN 
                    CALL cl_err(g_smy.smy52,'apm-001',1)   #No.TQC-980186 add
                    NEXT FIELD smy52 
                 END IF
              END IF
          END IF
 
        AFTER FIELD smy51
          IF NOT cl_null(g_smy.smy51) THEN
              IF g_smy.smysys = 'apm' AND  g_smy.smykind='3' THEN
                 IF NOT cl_null(g_smy.smy51) THEN
                    LET g_cnt = 0
                    SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                     WHERE smyslip=g_smy.smy51 AND smysys='apm'
                      #AND smykind = '4'     #MOD-C20127 mark
                       AND smykind = 'E'     #MOD-C20127
                    IF g_cnt=0 THEN 
                       CALL cl_err(g_smy.smy51,'asm-455',1) 
                       NEXT FIELD smy51 
                    END IF
                    SELECT COUNT(*) INTO g_cnt FROM smy_file
                     WHERE smysys = 'apm' AND smykind = '3'
                       AND smy51 = g_smy.smy51 AND smyslip!=g_smy.smyslip
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_smy.smy51,'apm-001',1)
                    END IF
                 END IF
              END IF
              IF g_smy.smysys = 'apm' AND  g_smy.smykind='B' THEN
                 LET g_cnt = 0
                 SELECT COUNT(*) INTO g_cnt FROM smy_file       #判斷是否存在
                  WHERE smyslip=g_smy.smy51 AND smysys='apm'
                    AND smykind = 'D'
                 IF g_cnt=0 THEN 
                    CALL cl_err(g_smy.smy51,'asm-455',1) 
                    NEXT FIELD smy51 
                 END IF
                 SELECT COUNT(*) INTO g_cnt FROM smy_file
                  WHERE smysys = 'apm' AND smykind = 'B'
                    AND smy51 = g_smy.smy51 AND smyslip!=g_smy.smyslip
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_smy.smy51,'apm-001',1)
                    END IF
              END IF
          END IF
 
       AFTER FIELD smy67
          IF NOT cl_null(g_smy.smy67) THEN 
            CALL i300_smy67(g_smy.smy67,'A',p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD smy67
            END IF 
          END IF 
       
#FUN-A80054--begin--add-----------
       AFTER FIELD smy75
          IF NOT cl_null(g_smy.smy75) THEN 
            CALL i300_smy67(g_smy.smy75,'8',p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD smy75
            END IF 
          END IF 
#FUN-A80054--end--add--------------
       
       AFTER FIELD smy68    
          IF NOT cl_null(g_smy.smy68) THEN 
            CALL i300_smy67(g_smy.smy68,'B',p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD smy68
            END IF 
          END IF           
       #FUN-A80150---add---start---
        AFTER FIELD smy76    
           IF NOT cl_null(g_smy.smy76) THEN 
              CALL i300_smy76(g_smy.smy76,'2',p_cmd)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD smy76
              END IF 
           END IF           
        AFTER FIELD smy77    
           IF NOT cl_null(g_smy.smy77) THEN 
              CALL i300_smy76(g_smy.smy77,'3',p_cmd)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD smy77
              END IF 
           END IF           
       #FUN-A80150---add---end---
        AFTER FIELD smy69   #組合拆解關聯工單單別
          IF NOT cl_null(g_smy.smy69) THEN
             CALL i300_smy69(g_smy.smy69,'1',p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_smy.smy69,g_errno,0)
                LET g_smy.smy69 = g_smy_t.smy69
                DISPLAY BY NAME g_smy.smy69
                NEXT FIELD smy69
             END IF
          END IF
 
        AFTER FIELD smy70   #組合拆解關聯發料單別
          IF NOT cl_null(g_smy.smy70) THEN
             CALL i300_smy69(g_smy.smy70,'3',p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_smy.smy70,g_errno,0)
                LET g_smy.smy70 = g_smy_t.smy70
                DISPLAY BY NAME g_smy.smy70
                NEXT FIELD smy70
             END IF
          END IF
 
        AFTER FIELD smy71   #組合拆解關聯入庫單別
          IF cl_null(g_smy.smysys)  THEN NEXT FIELD smysys  END IF
          IF cl_null(g_smy.smykind) THEN NEXT FIELD smykind END IF
          IF NOT cl_null(g_smy.smy71) THEN
             IF g_smy.smykind = 'F' THEN  #組合單
                CALL i300_smy69(g_smy.smy71,'A',p_cmd)     #一般的完工入庫單
             ELSE
                IF g_smy.smykind = 'G' THEN  #拆解單
                   CALL i300_smy69(g_smy.smy71,'C',p_cmd)  #拆解式入庫單
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_smy.smy71,g_errno,0)
                LET g_smy.smy71 = g_smy_t.smy71
                DISPLAY BY NAME g_smy.smy71
                NEXT FIELD smy71
             END IF
          END IF
 
        AFTER FIELD smy61
          IF NOT cl_null(g_smy.smy61) THEN
              IF g_smy.smysys = 'aim' AND  g_smy.smykind='E' THEN
                 IF NOT cl_null(g_smy.smy61) THEN
                    SELECT COUNT(*) INTO g_cnt FROM smy_file
                     WHERE smysys = 'aim' AND smykind = '1'
                       AND smy61 = g_smy.smy61 AND smyslip!=g_smy.smyslip
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_smy.smy61,'apm-001',1)
                    END IF
                 END IF
              END IF
          END IF
 
      AFTER FIELD smy62
         IF NOT cl_null(g_smy.smy62) THEN
            SELECT count(*) INTO g_cnt FROM aga_file  
             WHERE aga01 = g_smy.smy62 AND agsmyti='Y'    
            IF g_cnt <= 0 THEN  
               CALL cl_err(g_smy.smy62,'aim-910',0)     
               DISPLAY BY NAME g_smy.smy62     
               NEXT FIELD smy62  
            END IF
         END IF
 
        BEFORE FIELD smysys 
          CALL i300_set_entry(p_cmd)
          CALL i300_set_entry_smy69(p_cmd)    #No.FUN-930119          
 
        AFTER FIELD smysys
           LET g_errno = NULL        #No.MOD-570074 add
          IF NOT cl_null(g_smy.smysys) THEN
              IF NOT cl_null(g_errno) THEN        #有誤
                 CALL cl_err(g_smy.smysys,g_errno,0) NEXT FIELD smysys
              END IF
             #FUN-CA0008 add----start
              IF g_smy.smysys = 'asf' AND g_smy.smykind = 'J' THEN
                 CALL cl_set_comp_entry("smy80",TRUE)
              ELSE
                 LET g_smy.smy80 = ''
                 CALL cl_set_comp_entry("smy80",FALSE)
              END IF
             #FUN-CA0008 add----end
          END IF
#FUN-B30113 --------------Begin--------------
          IF (p_cmd = 'a') THEN
             CALL i300_smy57_4_default() 
          END IF 
#FUN-B30113 --------------End----------------
          IF g_aza.aza71 = 'Y' THEN
              IF g_smy.smysys = 'apm' THEN
                  LET g_smy.smy64 = '1' 
              ELSE
                  LET g_smy.smy64 = '0'
              END IF
          ELSE
              LET g_smy.smy64 = '0'
          END IF
          CALL i300_set_no_entry(p_cmd) #CHI-920085
          CALL i300_set_noentry_smy69(p_cmd)  #No.FUN-930119
          CALL i300_set_entry_smy67(p_cmd)    #NO.FUN-930105
          CALL i300_set_noentry_smy72()       #No.FUN-980038 
          CALL i300_set_entry_smy72()         #No.FUN-980038 
          CALL i300_set_entry_smy73()         #FUN-9B0144
          CALL i300_set_entry_smy75()         #FUN-A80054
          CALL i300_set_entry_smy78()         #TQC-B10177
          CALL i300_set_entry_smy79()         #FUN-B40082
                 
        BEFORE FIELD smykind
          CALL i300_set_entry(p_cmd)
          CALL i300_set_noentry_smy51(p_cmd) #No.MOD-470535
          CALL i300_set_entry_smy69(p_cmd)    #No.FUN-930119
                   
        AFTER FIELD smykind
          IF NOT cl_null(g_smy.smykind) THEN
              CALL i300_kind('i')
              IF NOT cl_null(g_errno) THEN        #有誤
                 CALL cl_err(g_smy.smykind,g_errno,0) NEXT FIELD smykind
              END IF
              IF g_smy.smysys='asf' AND g_smy.smykind='1' THEN
                 IF cl_null(smy57_1) THEN
                    LET smy57_1=g_sma.sma54
                    DISPLAY smy57_1 TO FORMONLY.smy57_1
                 END IF
                 IF cl_null(smy57_2) THEN
                    LET smy57_2=g_sma.sma896
                    DISPLAY smy57_2 TO FORMONLY.smy57_2
                 END IF
              ELSE
                 LET smy57_1='N' DISPLAY smy57_1 TO FORMONLY.smy57_1
                 LET smy57_2='N' DISPLAY smy57_2 TO FORMONLY.smy57_2
              END IF
              IF g_smy.smysys='asf' AND g_smy.smykind='4' THEN  #No:8741
                 LET g_smy.smydmy2='3'
                 DISPLAY g_smy.smydmy2 TO FORMONLY.smydmy2
              END IF

              #FUN-10109 mark by TSD.lucasyeh---(S)
              #IF g_smy.smysys='aim' AND g_smy.smykind='5' THEN  
              #   LET g_smy.smydmy5='1'
              #   DISPLAY BY NAME g_smy.smydmy5 
              #END IF
              #FUN-10109 mark by TSD.lucasyeh---(S)
#FUN-B30113 --------------Begin--------------
              IF (p_cmd = 'a') THEN
                 CALL i300_smy57_4_default()     
              END IF
#FUN-B30113 --------------End----------------
             #FUN-CA0008 add----start
              IF g_smy.smysys = 'asf' AND g_smy.smykind = 'J' THEN
                 CALL cl_set_comp_entry("smy80",TRUE)
              ELSE
                 LET g_smy.smy80 = ''
                 CALL cl_set_comp_entry("smy80",FALSE)
              END IF
             #FUN-CA0008 add----end
          END IF
          CALL i300_set_no_entry(p_cmd)
          CALL i300_set_entry_smy51(p_cmd) #No.MOD-470535
          CALL i300_set_noentry_smy69(p_cmd)  #No.FUN-930119
          CALL i300_set_entry_smy67(p_cmd)    #NO.FUN-930105 
          CALL i300_set_noentry_smy72()       #No.FUN-980038 
          CALL i300_set_entry_smy72()         #No.FUN-980038 
          CALL i300_set_entry_smy73()         #FUN-9B0144
          CALL i300_set_entry_smy75()         #FUN-A80054
          CALL i300_set_entry_smy78()         #TQC-B10177 
          CALL i300_set_entry_smy79()         #FUN-B40082
 
        BEFORE FIELD smy72
          CALL i300_set_noentry_smy72()
          CALL i300_set_entry_smy72()
 
        AFTER FIELD smy72
          CASE g_smy.smysys
             WHEN "apm"
                CASE
                   WHEN g_smy.smykind="1"
                      IF g_smy.smy72<>'REG' AND g_smy.smy72<>'EXP' AND
                         g_smy.smy72<>'CAP' AND g_smy.smy72<>'TAP' THEN  
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   WHEN g_smy.smykind="2"
                      IF g_smy.smy72<>'REG' AND g_smy.smy72<>'EXP' AND
                         g_smy.smy72<>'CAP' AND g_smy.smy72<>'SUB' AND
                         g_smy.smy72<>'TAI' AND g_smy.smy72<>'TAP' THEN  
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   WHEN g_smy.smykind="3"
                      IF g_smy.smy72<>'REG' AND g_smy.smy72<>'EXP' AND 
                         #g_smy.smy72<>'CAP' AND g_smy.smy72<>'SUB' THEN   #MOD-BA0154 mark
                         g_smy.smy72<>'CAP' AND g_smy.smy72<>'SUB' AND     #MOD-BA0154 add
                         g_smy.smy72<>'TAI' AND g_smy.smy72<>'TAP' THEN    #MOD-BA0154 add
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   WHEN g_smy.smykind="4"
                      IF g_smy.smy72<>'REG' AND g_smy.smy72<>'EXP' AND
                         #g_smy.smy72<>'CAP' AND g_smy.smy72<>'RTN' THEN   #MOD-BA0154 mark
                         g_smy.smy72<>'CAP' AND g_smy.smy72<>'SUB' AND     #MOD-BA0154 add
                         g_smy.smy72<>'TAI' AND g_smy.smy72<>'TAP' THEN    #MOD-BA0154 add
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   WHEN g_smy.smykind="7"
                      IF g_smy.smy72<>'REG' AND g_smy.smy72<>'EXP' AND
                         #g_smy.smy72<>'CAP' AND g_smy.smy72<>'RTN' THEN   #MOD-BA0154 mark
                         g_smy.smy72<>'CAP' AND g_smy.smy72<>'SUB' AND     #MOD-BA0154 add
                         g_smy.smy72<>'TAI' AND g_smy.smy72<>'TAP' THEN    #MOD-BA0154 add
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   #TQC-9B0191--begin--add----------
                   WHEN g_smy.smykind="A"
                      IF g_smy.smy72<>'WB0' AND g_smy.smy72<>'WB1' AND
                         g_smy.smy72<>'WB2' AND g_smy.smy72<>'WB3' THEN  
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                   WHEN g_smy.smykind="B" OR g_smy.smykind="C" OR g_smy.smykind="D"
                      IF g_smy.smy72<>'WB0' AND g_smy.smy72<>'WB1' AND
                         g_smy.smy72<>'WB2'  THEN  
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                END CASE
             WHEN "asf"
                 CASE g_smy.smykind
                    WHEN "1"
                      IF g_smy.smy72<>'1' AND g_smy.smy72<>'5' AND
                         g_smy.smy72<>'7' AND g_smy.smy72<>'8' AND
                         g_smy.smy72<>'11' AND g_smy.smy72<>'13' AND
                         g_smy.smy72<>'15' THEN
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                    WHEN "3"
                      IF g_smy.smy72<>'1' AND g_smy.smy72<>'2' AND
                         g_smy.smy72<>'3' AND g_smy.smy72<>'4' AND
                        #g_smy.smy72<>'A' AND g_smy.smy72<>'C' THEN
                         g_smy.smy72<>'A' AND g_smy.smy72<>'C' AND g_smy.smy72<>'D' THEN   #FUN-C70014 add g_smy.smy72<>'D'
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                    WHEN "4"
                      IF g_smy.smy72<>'6' AND g_smy.smy72<>'7' AND
                         g_smy.smy72<>'8' AND g_smy.smy72<>'9' AND
                         g_smy.smy72<>'B' THEN
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
#FUN-A50023 add --begin                      
                    WHEN "5"
                      IF g_smy.smy72<>'1' AND g_smy.smy72<>'2' THEN 
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF
                    WHEN "6"
                      IF g_smy.smy72<>'1' AND g_smy.smy72<>'2' THEN 
                         CALL cl_err(g_smy.smy72,'asm-125',0)
                         NEXT FIELD smy72
                      END IF                      
#FUN-A50023 add --end                                            
                END CASE
          END CASE
          CALL i300_smy72('i')
#FUN-B30113 --------------Begin--------------
          IF (p_cmd = 'a') THEN
             CALL i300_smy57_4_default()
          END IF
#FUN-B30113 --------------End----------------
                  
        AFTER FIELD smy57_1
          IF NOT cl_null(smy57_1) THEN
              IF smy57_1 NOT MATCHES '[YN]' THEN
                  NEXT FIELD smy57_1
              END IF
          END IF
 
        AFTER FIELD smy57_2
          IF NOT cl_null(smy57_2) THEN
              IF smy57_2 NOT MATCHES '[YN]' THEN
                  NEXT FIELD smy57_2
              END IF
          END IF
 
        AFTER FIELD smy57_3
          IF NOT cl_null(smy57_3) THEN
              IF smy57_3 NOT MATCHES '[YN]' THEN
                  NEXT FIELD smy57_3
              END IF
          END IF
 
 
        AFTER FIELD smy57_4
          IF NOT cl_null(smy57_4) THEN
              IF smy57_4 NOT MATCHES '[YN]' THEN
                  NEXT FIELD smy57_4
              END IF
          END IF
 
        AFTER FIELD smy57_5
          IF NOT cl_null(smy57_5) THEN
              IF smy57_5 NOT MATCHES '[YN]' THEN
                  NEXT FIELD smy57_5
              END IF
          END IF
 
        AFTER FIELD smy56
          IF NOT cl_null(g_smy.smy56) THEN
              IF g_smy.smy56 NOT MATCHES '[YN]' THEN
                 NEXT FIELD smy56
              END IF
          END IF
 
        AFTER FIELD smy59
          IF g_smy.smy59 IS NOT NULL THEN
              IF g_smy.smy59 NOT MATCHES '[YN]' THEN
                 NEXT FIELD smy59
              END IF
          ELSE
              LET g_smy.smy59=' '
          END IF
 
        AFTER FIELD smyprint
            IF NOT cl_null(g_smy.smyprint) THEN
                IF g_smy.smyprint NOT MATCHES '[YN]' THEN
                    NEXT FIELD smyprint
                END IF
            END IF
 
        AFTER FIELD smydmy4
            IF NOT cl_null(g_smy.smydmy4) THEN
                IF g_smy.smydmy4 NOT MATCHES '[YN]' THEN
                    NEXT FIELD smydmy4
                END IF
                IF g_smy.smydmy4='Y' THEN
                   LET g_cnt=0
                   SELECT COUNT(*) INTO g_cnt FROM oay_file 
                    WHERE oayslip=g_smy.smyslip
                      AND (( oaytype LIKE '5%' AND oaytype !='55' ) 
                       OR oaytype LIKE '6%' )
                   IF g_cnt>0 AND g_smy.smyapr='Y' THEN
                      CALL cl_err('','axm-066',0)
                      LET g_smy.smydmy4="N"
                      NEXT FIELD smydmy4
                   END IF 
                 END IF
            END IF
        #FUN-B30161-mark-start--
        ##No.FUN-A80026  --Begin
        #AFTER FIELD smy74
        #    IF g_smy.smy74 NOT MATCHES '[YN]' THEN
        #       NEXT FIELD smy74
        #    END IF
        ##No.FUN-A80026  --End  
        #FUN-B30161-mark-end--
      #FUN-B50039-add-str--
      AFTER FIELD smyud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smyud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
        ON CHANGE smyapr
           #FUN-B70022 mark str---
           #IF g_smy.smysys = 'abm' AND g_smy.smykind = '1' THEN
           #   IF i300_chk_apr() THEN
           #      CALL cl_err('','axm-066',1)
           #      LET g_smy.smyapr= 'N'
           #      NEXT FIELD smyapr
           #   END IF
           #END IF
           #FUN-B70022 mark end---
            CALL i300_set_entry(p_cmd)      #FUN-5B0078
            CALL i300_set_no_entry(p_cmd)   #FUN-5B0078
 
       #FUN-B70022 mark str---
       #ON CHANGE smydmy4
       #   IF NOT cl_null(g_smy.smydmy4) THEN
       #      IF g_smy.smysys = 'abm' AND g_smy.smykind = '1' THEN
       #         IF i300_chk_apr() THEN
       #            CALL cl_err('','axm-066',1)
       #            LET g_smy.smydmy4= 'N'
       #            NEXT FIELD smydmy4
       #         END IF
       #      END IF
       #   END IF        
       #FUN-B70022 mark end---
        AFTER INPUT
           LET g_smy.smyuser = s_get_data_owner("smy_file") #FUN-C10039
           LET g_smy.smygrup = s_get_data_group("smy_file") #FUN-C10039
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
          IF cl_null(g_smy.smysys) OR cl_null(g_smy.smykind) THEN
             DISPLAY BY NAME g_smy.smysys,g_smy.smykind
             CALL cl_err('','9033',0)
             NEXT FIELD smysys
          END IF
          IF smy57_3 = 'Y' AND cl_null(g_smy.smy52) THEN
             CALL cl_err('','asm-021',0)
             NEXT FIELD smy52
          END IF
          #組合拆解單別時，smy69/smy70/smy71 非空
          IF g_smy.smysys = 'aim' AND g_smy.smykind MATCHES '[FG]' THEN
             IF cl_null(g_smy.smy69) THEN 
                CALL cl_err('','asm-701',0)   #組合拆解關聯工單不可為空！
                NEXT FIELD smy69
             END IF
             IF cl_null(g_smy.smy70) THEN 
                CALL cl_err('','asm-702',0)   #組合拆解關聯發料單不可為空！
                NEXT FIELD smy70
             END IF
             IF cl_null(g_smy.smy71) THEN 
                CALL cl_err('','asm-703',0)   #組合拆解關聯完工入庫單不可為空！
                NEXT FIELD smy71
             END IF
          END IF
          IF cl_null(smy57_1) OR cl_null(smy57_2) OR cl_null(smy57_3) THEN
             DISPLAY smy57_1,smy57_2,smy57_3
                  TO FORMONLY.smy57_1, FORMONLY.smy57_2, FORMONLY.smy57_3
             CALL cl_err('','9033',0)
             NEXT FIELD smy57_1
          END IF
          IF cl_null(g_smy.smydmy1) THEN
             DISPLAY BY NAME g_smy.smydmy1
             CALL cl_err('','9033',0)
             NEXT FIELD smydmy1
          END IF
          IF cl_null(g_smy.smydmy2) THEN
             DISPLAY BY NAME g_smy.smydmy2
             CALL cl_err('','9033',0)
             NEXT FIELD smydmy2
          END IF
          IF g_smy.smydmy1='Y' AND g_smy.smydmy2 = 'X' THEN
             DISPLAY BY NAME g_smy.smydmy1,g_smy.smydmy2
             CALL cl_err('','mfg0180',0)
             NEXT FIELD smydmy2
          END IF
          CALL i300_kind('i')
          IF NOT cl_null(g_errno) THEN  #有誤
             CALL cl_err(g_smy.smykind,g_errno,0)
             DISPLAY BY NAME g_smy.smysys,g_smy.smykind
             NEXT FIELD smysys
          END IF
          IF g_smy.smyapr='Y' AND g_aza.aza23='N' AND cl_null(g_smy.smysign) THEN   #FUN-5B0078
             IF g_smy.smyatsg = 'N' THEN     #MOD-B30102 add
                NEXT FIELD smysign
             END IF                          #MOD-B30102 add
          END IF

         #FUN-A10043 mark str -----
         #IF g_smy.smysys='apm' AND g_smy.smykind='5' AND 
         #   g_smy.smyapr='Y' AND g_smy.smydmy4='Y' THEN
         #   CALL cl_err('','axm-066',0)
         #   LET g_smy.smydmy4="N"
         #   NEXT FIELD smydmy4
         #END IF
         #FUN-A10043 mark end -----

        ON KEY(F1) NEXT FIELD smyslip
        ON KEY(F2) NEXT FIELD smyapr
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
                IF INFIELD(smysign) THEN        #簽核等級
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_aze"
                        LET g_qryparam.default1 = g_smy.smysign
                        CALL cl_create_qry() RETURNING g_smy.smysign
                        DISPLAY BY NAME g_smy.smysign
                        NEXT FIELD smysign
                END IF
 
                IF INFIELD(smykind) THEN        #單據性質

                   #FUN-A10109 mod by TSD.lucasyeh---(S) 
                   #CALL q_kind(FALSE, FALSE, g_smy.smysys,g_smy.smykind) RETURNING g_smy.smykind
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gee01"
                   LET g_qryparam.where = " gee01 = '",UPSHIFT(g_smy.smysys),
                                          "' AND gee03 = '",g_lang,"'",
                                          "  AND gee04 = 'asmi300'"
                   LET g_qryparam.default1 = g_smy.smykind
                   CALL cl_create_qry() RETURNING g_smy.smykind
                   #FUN-A10109 mod by TSD.lucasyeh---(E) 
                   DISPLAY BY NAME g_smy.smykind
                   NEXT FIELD smykind

                END IF
                IF INFIELD(smy72) THEN        #單據形態
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.plant = g_plant
                   CALL q_smy72(FALSE, FALSE, g_smy.smysys,g_smy.smykind,g_smy.smy72) RETURNING g_smy.smy72
                   DISPLAY BY NAME g_smy.smy72
                   NEXT FIELD smy72
                END IF
                IF INFIELD(smy51) THEN        #單據性質
                   IF g_smy.smysys = 'apm' THEN
                      IF g_smy.smykind = 'B' THEN
                         CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','D') RETURNING g_smy.smy51
                      ELSE
                        #CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','4') RETURNING g_smy.smy51   #TQC-670008
                         CALL q_smy(FALSE, FALSE,g_smy.smy51,'APM','E') RETURNING g_smy.smy51   #MOD-C20127 add
                      END IF   #TQC-9B0191
                      DISPLAY BY NAME g_smy.smy51
                      NEXT FIELD smy51
                   END IF
                END IF
                IF INFIELD(smy52) THEN        #單據性質
                   IF g_smy.smysys = 'apm' THEN
                      IF g_smy.smykind = 'B' THEN
                         CALL q_smy(FALSE, FALSE,g_smy.smy52,'APM','C') RETURNING g_smy.smy52
                      ELSE
                          CALL q_smy(FALSE, FALSE,g_smy.smy52,'APM','7') RETURNING g_smy.smy52    #TQC-670008
                      END IF   #TQC-9B0191
                   END IF
                   IF g_smy.smysys = 'asf' THEN
                      IF g_smy.smykind = '1' THEN
                          CALL q_smy(FALSE, FALSE,g_smy.smy52,'ASF','2') RETURNING g_smy.smy52   #TQC-670008
                      ELSE
                          CALL q_smy(FALSE, FALSE,g_smy.smy52,'ASF','A') RETURNING g_smy.smy52   #TQC-670008
                      END IF
                   END IF
                   DISPLAY BY NAME g_smy.smy52
                   NEXT FIELD smy52
                END IF
                
                IF INFIELD(smy67) THEN
                   CALL q_smy(FALSE,FALSE,g_smy.smy67,'ASF','A') RETURNING g_smy.smy67
                   DISPLAY BY NAME g_smy.smy67
                   NEXT FIELD smy67
                END IF 
                IF INFIELD(smy68) THEN 
                   CALL q_smy(FALSE,FALSE,g_smy.smy68,'ASF','B') RETURNING g_smy.smy68 
                   DISPLAY BY NAME g_smy.smy68
                   NEXT FIELD smy68
                END IF      

               #FUN-A80150---add---start---
                IF INFIELD(smy76) THEN 
                   CALL q_smy(FALSE,FALSE,g_smy.smy76,'APM','2') RETURNING g_smy.smy76 
                   DISPLAY BY NAME g_smy.smy76 
                   NEXT FIELD smy76
                END IF      
                IF INFIELD(smy77) THEN 
                   CALL q_smy(FALSE,FALSE,g_smy.smy77,'APM','3') RETURNING g_smy.smy77 
                   DISPLAY BY NAME g_smy.smy77 
                   NEXT FIELD smy77
                END IF      
               #FUN-A80150---add---end---
                
                IF INFIELD(smy69) THEN        #組合拆解關聯工單單別
                   LET g_sql = " smy73 = 'Y'"  #FUN-9B0144
                   CALL smy_qry_set_par_where(g_sql)  #FUN-9B0144
                   CALL q_smy(FALSE, FALSE,g_smy.smy69,'ASF','1') RETURNING g_smy.smy69
                   DISPLAY BY NAME g_smy.smy69
                   NEXT FIELD smy69
                END IF
                IF INFIELD(smy70) THEN        #組合拆解關聯發料單別
                   LET g_sql = " smy73 = 'Y'"  #FUN-9B0144
                   CALL smy_qry_set_par_where(g_sql)  #FUN-9B0144
                   CALL q_smy(FALSE, FALSE,g_smy.smy69,'ASF','3') RETURNING g_smy.smy70
                   DISPLAY BY NAME g_smy.smy70
                   NEXT FIELD smy70
                END IF
                IF INFIELD(smy71) THEN        #組合拆解關聯完工入庫單別
                   LET g_sql = " smy73 = 'Y'"  #FUN-9B0144
                   CALL smy_qry_set_par_where(g_sql)  #FUN-9B0144
                   IF g_smy.smykind = 'F' THEN     #組合單
                      CALL q_smy(FALSE, FALSE,g_smy.smy71,'ASF','A') RETURNING g_smy.smy71
                   ELSE
                      IF g_smy.smykind = 'G' THEN  #拆解單
                         CALL q_smy(FALSE, FALSE,g_smy.smy71,'ASF','C') RETURNING g_smy.smy71
                      END IF
                   END IF
                   DISPLAY BY NAME g_smy.smy71
                   NEXT FIELD smy71
                END IF
                IF INFIELD(smy61) THEN        #單據性質
                   IF g_smy.smysys = 'aim' AND g_smy.smykind='E' THEN
                        CALL q_smy(FALSE, FALSE,g_smy.smy61,'AIM','1') RETURNING g_smy.smy61   #TQC-670008
                        DISPLAY BY NAME g_smy.smy61
                        NEXT FIELD smy61
                   END IF
                END IF
                #FUN-A80054--begin--add-----------
                IF INFIELD(smy75) THEN
                   CALL q_smy(FALSE,FALSE,g_smy.smy75,'ASF','8') RETURNING g_smy.smy75
                   DISPLAY BY NAME g_smy.smy75
                   NEXT FIELD smy75
                END IF 
                #FUN-A80054--end--add-------------
                IF INFIELD(smy62) THEN
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aga"
                   LET g_qryparam.default1= g_smy.smy62
                   CALL cl_create_qry() RETURNING g_smy.smy62
                   DISPLAY BY NAME g_smy.smy62
                   NEXT FIELD smy62
                END IF
                #FUN-B40082 --START--
                IF INFIELD(smy79) THEN
                   CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_smy.smy79
                   DISPLAY BY NAME g_smy.smy79
                   NEXT FIELD smy79
                END IF
                #FUN-B40082 --END--
               
                #FUN-CA0008 --START--
                IF INFIELD(smy80) THEN
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   CALL cl_create_qry() RETURNING g_smy.smy80
                   DISPLAY BY NAME g_smy.smy80
                   NEXT FIELD smy80
                END IF
                #FUN-CA0008 --END--
 
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
 
#FUN-B30113 ---------------Begin---------------------------------
FUNCTION i300_smy57_4_default()
   IF g_smy.smysys = 'apm' AND g_smy.smykind = 'A' AND
      (g_smy.smy72 = 'WB1' OR g_smy.smy72 = 'WB2') THEN
      LET smy57_4='Y'
   ELSE
      LET smy57_4='N'
   END IF
   DISPLAY BY NAME smy57_4
END FUNCTION
#FUN-B30113 ---------------End-----------------------------------
FUNCTION i300_kind(p_cmd)
DEFINE
        p_cmd         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_desc        LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100),
        l_c30         LIKE smy_file.smydesc, #FUN-5C0114
        l_c30_1       LIKE smy_file.smydesc, #FUN-5C0114
        l_kind        LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01),
        l_n,l_inx,l_inx1,l_str,l_end LIKE type_file.num5    #No.FUN-690010SMALLINT
#FUN-A10109 add by TSD.lucasyeh---(S)
DEFINE l_gee01        LIKE gee_file.gee01,
       l_geeacti      LIKE gee_file.geeacti
#FUN-A10109 add by TSD.lucasyeh---(S)
DEFINE l_gee          RECORD LIKE gee_file.* 
 
    LET g_errno = ' '

   #FUN-A10109 mark by TSD.lucasyeh---(S) 
   # CASE g_smy.smysys
   #      WHEN 'abm'  LET l_inx = 1
   #                  LET l_str = g_abm_str
   #                  LET l_end = g_abm_end
   #
   #      WHEN 'aim'  LET l_inx = 2
   #                  LET l_str = g_aim_str
   #                  LET l_end = g_aim_end
   #
   #      WHEN 'apm'  LET l_inx = 3
   #                  LET l_str = g_apm_str
   #                  LET l_end = g_apm_end
   #
   #      WHEN 'asf'  LET l_inx = 4
   #                  LET l_str = g_asf_str
   #                  LET l_end = g_asf_end
   #
   #      WHEN 'aem'  LET l_inx = 5
   #                  LET l_str = g_aem_str
   #                  LET l_end = g_aem_end
   #      WHEN 'asr'  LET l_inx = 6
   #                  LET l_str = g_asr_str
   #                  LET l_end = g_asr_end
   #      WHEN 'aqc'  LET l_inx = 7
   #                  LET l_str = g_aqc_str
   #                  LET l_end = g_aqc_end
   #      WHEN 'art'  LET l_inx = 8
   #                  LET l_str = g_art_str
   #                  LET l_end = g_art_end
   # END CASE
   # IF l_inx=0 THEN
   #    LET g_errno='mfg0070'
   # ELSE
   #    FOR l_n= l_str TO l_end
   #        LET l_kind = g_zemsg[l_n].subString(1,1)
   #        IF g_smy.smykind= l_kind THEN
   #           LET l_desc=g_zemsg[l_n]
   #           LET l_c30=l_desc[2,40] #FUN-5C0114 30->40
   #           LET l_inx1=l_n            #check 所輸入是否已定義好
   #        END IF
   #    END FOR
   #    IF l_inx1=0 THEN LET g_errno='mfg0071' END IF
   #END IF
   #FUN-A10109 mark by TSD.lucasyeh---(E) 

   #FUN-A10109 add by TSD.lucasyeh---(S)
   IF cl_null(g_smy.smysys) THEN
      RETURN
   ELSE
      LET l_gee01 = UPSHIFT(g_smy.smysys)
      SELECT gee05,geeacti INTO l_c30,l_geeacti
        FROM gee_file
       WHERE gee01 = l_gee01
         AND gee02 = g_smy.smykind
         AND gee03 = g_lang
         AND gee04 = g_prog
      CASE
         WHEN l_geeacti = 'N'
            LET g_errno = 'aap991'
         OTHERWISE
            LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
   END IF

   #FUN-A10109 add by TSD.lucasyeh---(E)
 
 
   IF cl_null(g_errno)  OR p_cmd = 'd' THEN
      DISPLAY l_c30 TO FORMONLY.ename0
   END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_smy.* TO NULL             #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i300_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_smy.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_smy.* TO NULL
    ELSE
        OPEN i300_count
        FETCH i300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690010 VARCHAR(1)
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i300_cs INTO g_smy.smyslip
    WHEN 'P' FETCH PREVIOUS i300_cs INTO g_smy.smyslip
    WHEN 'F' FETCH FIRST    i300_cs INTO g_smy.smyslip
    WHEN 'L' FETCH LAST     i300_cs INTO g_smy.smyslip
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
       FETCH ABSOLUTE g_jump i300_cs INTO g_smy.smyslip
       LET g_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0)
       INITIALIZE g_smy.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_smy.* FROM smy_file WHERE smyslip = g_smy.smyslip
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
        INITIALIZE g_smy.* TO NULL
        RETURN
    ELSE                                  #FUN-4C0033權限控管
         LET g_data_owner=g_smy.smyuser
         LET g_data_group=g_smy.smygrup
         CALL  i300_show()
 
    END IF
    CALL i300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i300_show()
    LET g_smy_t.* = g_smy.*                #保存單頭舊值
    DISPLAY BY NAME g_smy.smyoriu,g_smy.smyorig,
          g_smy.smyslip,g_smy.smydesc,g_smy.smyauno,#g_smy.smydmy5,     #FUN-A10109 mark by TSD.lucasyeh
          g_smy.smysys,g_smy.smykind,g_smy.smy72,g_smy.smydmy2,g_smy.smydmy1,
          g_smy.smyapr,g_smy.smyatsg,g_smy.smysign,g_smy.smydays,g_smy.smy56,
          g_smy.smyprit,g_smy.smyprint,g_smy.smydmy4,g_smy.smy73,g_smy.smy78, #FUN-9B0144 add smy73          #TQC-B10177
          g_smy.smy52,g_smy.smy51,g_smy.smy61,g_smy.smy62,g_smy.smy63,g_smy.smy58,  #FUN-610014  TQC-650096  ##NO.FUN-680010
          g_smy.smymemo1,g_smy.smy59,g_smy.smy53, #g_smy.smy55,     #No.TQC-7B0149 add smy53  #FUN-950009
          g_smy.smyware,
          #g_smy.smy74,g_smy.smy75,                     #No.FUN-A80026 #FUN-A80054   #FUN-B30161 mark
          g_smy.smy75,                                 #FUN-A80054
          g_smy.smy67,g_smy.smy68,                     #NO.FUN-930105 add 
          g_smy.smy76,g_smy.smy77,                     #FUN-A80150 add
          g_smy.smy78,g_smy.smy79,                     #FUN-B40082
          g_smy.smyuser,g_smy.smygrup,g_smy.smymodu,g_smy.smydate,g_smy.smyacti,
          g_smy.smy69,g_smy.smy70,g_smy.smy71,      #No.FUN-930119
          g_smy.smy64,           #NO.FUN-880016
          #FUN-B50039-add-str--
          g_smy.smyud01,g_smy.smyud02,g_smy.smyud03,g_smy.smyud04,g_smy.smyud05,
          g_smy.smyud06,g_smy.smyud07,g_smy.smyud08,g_smy.smyud09,g_smy.smyud10,
          g_smy.smyud11,g_smy.smyud12,g_smy.smyud13,g_smy.smyud14,g_smy.smyud15,
          #FUN-B50039-add-end--
          g_smy.smy80 #,g_smy.smy81          #FUN-CA0008 add  #FUN-FUN-D10118 ADD SMY81

    CALL i300_kind('d')
   #IF (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCD]') OR   #TQC-9B0191 add ABCD
    IF (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCDE]') OR  #MOD-BA0177 add E
      (g_smy.smysys='asf' AND g_smy.smykind MATCHES '[134]') THEN
       CALL i300_smy72('d')
    #MOD-BB0045 -- begin --
    ELSE
       IF cl_null(g_smy.smy72) THEN
          DISPLAY '' TO FORMONLY.smy72_name
       END IF
    #MOD-BB0045 -- end --
    END IF
 
 
    LET smy57_1=g_smy.smy57[1,1] DISPLAY smy57_1 TO FORMONLY.smy57_1
    LET smy57_2=g_smy.smy57[2,2] DISPLAY smy57_2 TO FORMONLY.smy57_2
    LET smy57_3=g_smy.smy57[3,3] DISPLAY smy57_3 TO FORMONLY.smy57_3
    LET smy57_4=g_smy.smy57[4,4] DISPLAY smy57_4 TO FORMONLY.smy57_4
    LET smy57_5=g_smy.smy57[5,5] DISPLAY smy57_5 TO FORMONLY.smy57_5 #add 021111 NO.A041
    LET smy57_6=g_smy.smy57[6,6] DISPLAY smy57_6 TO FORMONLY.smy57_6
    CALL i300_b_fill(g_wc2)                 #單身
    LET g_msg = s_smu_d(g_smy.smyslip,g_smy.smysys)
    DISPLAY g_msg TO smu02_display
    LET g_msg = s_smv_d(g_smy.smyslip,g_smy.smysys) #NO:6842
    DISPLAY g_msg TO smv02_display
     CALL cl_set_field_pic("","","","","",g_smy.smyacti) #No.MOD-480023
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i300_r()
   DEFINE l_chr,l_sure  LIKE type_file.chr1   #No.FUN-690010 VARCHAR(1)
   DEFINE l_smy_smysys     LIKE smy_file.smysys
   DEFINE l_cnt       LIKE type_file.num5     #No.CHI-880012 
   
   LET l_smy_smysys = g_smy.smysys
   LET l_smy_smysys = UPSHIFT(l_smy_smysys)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smy.smyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_smy.smyacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i300_cl USING g_smy.smyslip
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_smy.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i300_show()
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM oay_file WHERE oayslip=g_smy.smyslip
      AND (( oaytype LIKE '5%' AND oaytype !='55' ) 
       OR oaytype like 'I%' OR oaytype like 'J%'    #No.FUN-A70130 Add
       OR oaytype = 'U6' OR oaytype = 'U7'          #No.FUN-A70130 Add
       OR oaytype LIKE '6%' OR oaytype LIKE '4%' )  #MOD-950219 add  #CHI-D30015 add 4
    IF g_cnt > 0 THEN
       CALL cl_err(g_smy.smyslip,'axm-408',1)
       ROLLBACK WORK     #No.CHI-950012 add                                                                                         
       RETURN            #No.CHI-950012 add 
    END IF
    LET l_cnt = 0
    CASE g_aza.aza41
      WHEN '1'  
       SELECT COUNT(*) INTO l_cnt FROM tlf_file
        WHERE tlf905[1,3] = g_smy.smyslip
      WHEN '2'  
       SELECT COUNT(*) INTO l_cnt FROM tlf_file
        WHERE tlf905[1,4] = g_smy.smyslip
      WHEN '3'  
       SELECT COUNT(*) INTO l_cnt FROM tlf_file
        WHERE tlf905[1,5] = g_smy.smyslip
    END CASE
    IF l_cnt > 0 THEN
       CALL cl_err(g_smy.smyslip,'asm-091',1)
       RETURN
    END IF
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "smyslip"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_smy.smyslip      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
        DELETE FROM smz_file WHERE smz01 = g_smy.smyslip
        DELETE FROM smv_file WHERE smv01 = g_smy.smyslip AND UPPER(smv03)=l_smy_smysys
        DELETE FROM smu_file WHERE smu01 = g_smy.smyslip AND UPPER(smu03)=l_smy_smysys
        DELETE FROM smy_file WHERE smyslip = g_smy.smyslip
        #DELETE FROM smyb_file WHERE smybslip = g_smyb.smybslip #No:DEV-D30026--add #FUN-D50077
       #FUN-D50077 add---str---
        IF NOT cl_null(g_aza.aza131) AND g_aza.aza131 = 'Y' THEN
            DELETE FROM smyb_file WHERE smybslip = g_smy.smyslip
        END IF
       #FUN-D50077 add---end---        
        IF STATUS THEN
            CALL cl_err3("del","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
        ELSE

            #FUN-A10109  ===S===
            CALL s_access_doc('r','','',g_smy.smyslip,UPSHIFT(g_smy.smysys),g_smy.smyacti)
            #FUN-A10109  ===E===

            CLEAR FORM
            CALL g_smz.clear()
            INITIALIZE g_smy.* LIKE smy_file.*             #DEFAULT 設定
            OPEN i300_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i300_cs
               CLOSE i300_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i300_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i300_cs
               CLOSE i300_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i300_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i300_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE
               CALL i300_fetch('/')
            END IF
        END IF
    END IF
    CLOSE i300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smy.smyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i300_cl USING g_smy.smyslip
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_smy.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_smy.smyslip,SQLCA.sqlcode,0) RETURN END IF
    CALL i300_show()
    IF cl_exp(0,0,g_smy.smyacti) THEN
        LET g_chr=g_smy.smyacti
        IF g_smy.smyacti='Y'
           THEN LET g_smy.smyacti='N'
           ELSE LET g_smy.smyacti='Y'
        END IF
        UPDATE smy_file
            SET smyacti=g_smy.smyacti,
               smymodu=g_user, smydate=g_today
            WHERE smyslip=g_smy.smyslip
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
            LET g_smy.smyacti=g_chr
        END IF
        SELECT * INTO g_smy.* FROM smy_file WHERE  smyslip = g_smy.smyslip  #No.FUN-930119
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_smy.smyauno,g_smy.smykind,g_smy.smyslip,UPSHIFT(g_smy.smysys),g_smy.smyacti)
        #FUN-A10109  ===E===
        DISPLAY BY NAME g_smy.smyacti
    END IF
    CLOSE i300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_b()
    IF g_smy.smyslip IS NULL THEN RETURN END IF
    CALL cl_opmsg('b')
 
    BEGIN WORK
    LET g_success='Y'
    CALL i300_bb()
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
     LET g_smy.smymodu = g_user
     LET g_smy.smydate = g_today
     UPDATE smy_file SET smymodu = g_smy.smymodu,smydate = g_smy.smydate
      WHERE smyslip = g_smy.smyslip
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","smy_file",g_smy.smyslip,"",SQLCA.sqlcode,"","upd smy",1)  #No.FUN-660138
     END IF
     #FUN-A10109  ===S===
     CALL s_access_doc('u',g_smy.smyauno,g_smy.smykind,g_smy.smyslip,UPSHIFT(g_smy.smysys),g_smy.smyacti)
     #FUN-A10109  ===E===
     DISPLAY BY NAME g_smy.smymodu,g_smy.smydate
 
END FUNCTION
 
FUNCTION i300_bb()
  DEFINE l_i,l_k,l_j   LIKE type_file.num5,           #No.FUN-690010 SMALLINT
         l_n           LIKE type_file.num5,           #No.FUN-690010 SMALLINT
         l_count       LIKE type_file.num5,           #No.FUN-690010 SMALLINT,
         l_buf,l_smz03,l_smz02 LIKE smz_file.smz02,   #No.FUN-690010  VARCHAR(10),
         l_tmp         STRING,                        #No:MOD-950297 add
         l_gec01       LIKE gec_file.gec01,           #No.FUN-690010  VARCHAR(4),
         l_allow_insert  LIKE type_file.num5,         #可新增否  #No.FUN-690010 SMALLINT
         l_allow_delete  LIKE type_file.num5,         #可刪除否  #No.FUN-690010 SMALLINT
         l_cnt     LIKE type_file.num5                #CHI-C90048 add
 
    LET g_action_choice = ""
   #DELETE FROM smz_file WHERE smz01=g_smy.smyslip    #MOD-A10166 mark
   #-MOD-A10166-add-
    FOR l_i = 1 TO g_smz.getLength()
        DELETE FROM smz_file 
         WHERE smz01 = g_smy.smyslip
           AND smz021 = g_smz[l_i].smz021 #MOD-C30906 add 
           #AND smz02 = g_smz[l_i].smz021 #MOD-C30906 mark
    END FOR
   #-MOD-A10166-end-
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_smz WITHOUT DEFAULTS FROM s_smz.*
                      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE ROW
           LET l_ac = ARR_CURR()

       #CHI-C90048---S---
        AFTER FIELD smz021
        IF NOT cl_null(g_smz[l_ac].smz021) THEN  #TQC-CC0076 add
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM imd_file
            WHERE imd01 = g_smz[l_ac].smz021
              AND imdacti = 'Y'

           IF l_cnt = 0 THEN
              CALL cl_err('','asm-626',1)
              NEXT FIELD smz021
           END IF
        END IF    #TQC-CC0076 add
       #CHI-C90048---E---     

        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(smz021)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_imd"
             LET g_qryparam.arg1     = 'SW'        #倉庫類別
             CALL cl_create_qry() RETURNING g_smz[l_ac].smz021
             DISPLAY BY NAME g_smz[l_ac].smz021
          WHEN INFIELD(smz031) #儲位
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_imfe"
             LET g_qryparam.default1 = g_smz[l_ac].smz031
             LET g_qryparam.arg1 = g_smz[l_ac].smz021
             CALL cl_create_qry() RETURNING g_smz[l_ac].smz031
             NEXT FIELD smz031
          OTHERWISE EXIT CASE
       END CASE
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 LET g_success='N' RETURN END IF
    FOR l_i=1 TO  g_smz.getLength()
            IF cl_null(g_smz[l_i].smz021) THEN CONTINUE FOR END IF
            IF cl_null(g_smz[l_i].smz031) THEN LET g_smz[l_i].smz031=' ' END IF
            IF cl_db_get_database_type()='ORA' THEN
               IF g_smz[l_i].smz021!=' ' THEN
                  LET l_tmp=g_smz[l_i].smz021
                  LET l_tmp = cl_replace_str(l_tmp,'*','%')
                  LET l_tmp = cl_replace_str(l_tmp,'?','_')
                  LET l_smz02=l_tmp
               ELSE
                  LET l_smz02=' '
               END IF
               IF g_smz[l_i].smz031!=' ' THEN
                  LET l_tmp=g_smz[l_i].smz031
                  LET l_tmp = cl_replace_str(l_tmp,'*','%')
                  LET l_tmp = cl_replace_str(l_tmp,'?','_')
                  LET l_smz03=l_tmp
               ELSE
                  LET l_smz03=' '
               END IF
            ELSE
               LET l_smz02=g_smz[l_i].smz021
               LET l_smz03=g_smz[l_i].smz031
            END IF
 
            INSERT INTO smz_file(smz01,smz02,smz021,smz03,smz031)
                          VALUES(g_smy.smyslip,
                                          l_smz02,g_smz[l_i].smz021,
                                          l_smz03,g_smz[l_i].smz031)
            IF SQLCA.SQLCODE THEN
               LET g_success='N'
               CALL cl_err3("ins","smz_file",g_smy.smyslip,l_smz02,SQLCA.sqlcode,"","ins smz",1)  #No.FUN-660138
               RETURN
            END IF
    END FOR
   #CALL i300_delHeader()     #CHI-C30002 add   #MOD-CB0251 mark

END FUNCTION

#MOD-CB0251 -- mark start --
##CHI-C30002 -------- add -------- begin
#FUNCTION i300_delHeader()
#   IF g_rec_b = 0 THEN
#      IF cl_confirm("9042") THEN
#         #CHI-C80041---begin
#         DELETE FROM smv_file WHERE smv01 = g_smy.smyslip AND UPPER(smv03)=l_smy_smysys
#         DELETE FROM smu_file WHERE smu01 = g_smy.smyslip AND UPPER(smu03)=l_smy_smysys
#         #CHI-C80041---end
#         DELETE FROM smy_file WHERE symslip = g_smy.smyslip
#         INITIALIZE g_smy.* TO NULL
#         CLEAR FORM
#      END IF
#   END IF
#END FUNCTION
##CHI-C30002 -------- add -------- end
#MOD-CB0251 -- mark end --
 
FUNCTION i300_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON smz021,smz031
            FROM s_smz[1].smz021,s_smz[1].smz031
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
    CALL i300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
    IF cl_null(p_wc2) THEN    #NO:6842
       LET p_wc2 = ' 1=1 '
    END IF
    LET g_sql =
        "SELECT smz021,smz031",
        " FROM smz_file",
        " WHERE smz01 ='",g_smy.smyslip,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i300_pb FROM g_sql
    DECLARE smz_curs                       #SCROLL CURSOR
        CURSOR FOR i300_pb
 
    CALL g_smz.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH smz_curs INTO g_smz[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_smz.deleteElement(g_cnt)    #TQC-790052
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_smz TO s_smz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION invalid
         LET g_action_choice="invalid"
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
          CALL cl_set_field_pic("","","","","",g_smy.smyacti) #No.MOD-480023
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 倉庫單身
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
    #@ON ACTION 使用者設限
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DISPLAY
 
    #@ON ACTION 部門設限
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DISPLAY

      #No:DEV-D30026--add--begin
      ON ACTION barcode_related  #條碼相關
         LET g_action_choice="barcode_related"
         EXIT DISPLAY
      #No:DEV-D30026--add--end 

#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0048
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY               #TQC-5A0124
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i300_out()
DEFINE
        sr RECORD LIKE smy_file.*,
        l_i    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_name LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
        l_chr  LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
  
        DEFINE    l_smz        RECORD LIKE smz_file.*
        CALL cl_del_data(l_table)
        CALL cl_del_data(l_table1)
        LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?)"   #FUN-A10109 remove one ? from string
        PREPARE insert_prep FROM gg_sql
        IF STATUS THEN
           CALL cl_err('insert_prep:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM
        END IF
        
        LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                     " VALUES(?,?,?)"
        PREPARE insert_prep1 FROM gg_sql
        IF STATUS THEN
           CALL cl_err('insert_prep1',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM 
        END IF 
           
        SELECT zz05 INTO g_zz05 FROM zz_file 	WHERE zz01 = 'asmi300'  
        
        IF cl_null(g_wc) THEN
           LET g_wc=" smyslip='",g_smy.smyslip,"'"
        END IF
 
        IF g_wc IS NULL THEN
           CALL cl_err('','9057',0)
           RETURN
        END IF
 
        SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
        LET g_sql="SELECT * FROM smy_file ",
                " WHERE ",g_wc CLIPPED
        PREPARE i300_p1 FROM g_sql                # RUNTIME 編譯
        DECLARE i300_co                                        # SCROLL CURSOR
                 CURSOR FOR i300_p1
 
        FOREACH i300_co INTO sr.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
                        EXIT FOREACH
                END IF
                    DECLARE r_c CURSOR FOR
                          SELECT * FROM smz_file WHERE smz01=sr.smyslip
                    LET g_i=0
                    FOREACH r_c INTO l_smz.*
                       LET g_i=g_i+1 
                       EXECUTE insert_prep1 USING
                            l_smz.smz01,l_smz.smz021,l_smz.smz031
                    END FOREACH
                EXECUTE insert_prep USING
                    sr.smyacti,sr.smyslip,sr.smydesc,sr.smyauno,#sr.smydmy5,  #FUN-A10109 mark sr.smydmy5 by TSD.lucasyeh
                    sr.smysys,sr.smykind,sr.smyapr,sr.smyatsg,sr.smysign,
                    sr.smyprint,sr.smy53,sr.smydmy4             
        END FOREACH
 
        LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                     "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                     
        IF g_zz05 = 'Y' THEN 
           CALL cl_wcchp(g_wc,'smyslip,smydesc,smysys,smykind,smyauno,#smydmy5,  #FUN-A10109 mark smydmy5 by lucasyeh 
                        smyware,smy58,smy52,smy51,smy61,smy62,smy63,smy57_3,
                        smyprint,smydmy4,smy57_6,smy57_1,smy57_4,smy57_2,
                        smy57_5,smyapr,smyatsg,smysign,smydays,smyprit,smymemo1,              
	            	smydmy2,smydmy1,smy56,smy59,smy53,smyuser,smygrup,       #FUN-950009
                        smymodu,smydate,smyacti,smz021,smz031,smy69,smy70,smy71')  #No.FUN-930119
            RETURNING g_wc
        END IF
        
        LET g_str = g_wc,";",g_i
        
        CALL cl_prt_cs3('asmi300','asmi300',gg_sql,g_str)
        
        CLOSE i300_co
        ERROR ""
END FUNCTION
 
FUNCTION i300_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("smyslip",TRUE)
   END IF
 
   IF INFIELD(smyatsg) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("smysign",TRUE)
      CALL cl_set_comp_entry("smydays,smyoris",TRUE)
   END IF
 
   IF INFIELD(smyapr) OR (NOT g_before_input_done) THEN
      IF ( g_smy.smyapr = "Y" AND g_aza.aza23 = "N" ) THEN
         CALL cl_set_comp_entry("smyatsg,smysign,smydays,smyprit",TRUE)
      END IF
   END IF
 
   IF INFIELD(smysys) OR INFIELD(smykind) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("smy57_1,smy57_2,smy57_3,
                              smy57_4,smy57_5,smy57_6",TRUE)
   END IF
 
#MOD-B30405 -------------------Begin------------------------
   IF g_smy.smysys = 'apm' AND g_smy.smykind = 'A' THEN
      CALL cl_set_comp_entry("smy57_4",TRUE)
   END IF  
#MOD-B30405 -------------------End--------------------------
   CALL cl_set_comp_entry("smy64",TRUE)
 
END FUNCTION
 
FUNCTION i300_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN         #No.FUN-570110
           CALL cl_set_comp_entry("smyslip",FALSE)
       END IF
   END IF
 
   IF INFIELD(smyatsg) OR (NOT g_before_input_done) THEN
      IF g_smy.smyatsg = 'Y' THEN
          CALL cl_set_comp_entry("smysign",FALSE)
          CALL cl_set_comp_entry("smydays,smyprit",FALSE)
      END IF
   END IF
 
   IF INFIELD(smyapr) OR (NOT g_before_input_done) THEN
      IF g_smy.smyapr = 'N' OR ( g_smy.smyapr = 'Y' AND g_aza.aza23 = 'Y' ) THEN   #FUN-5B0078
          CALL cl_set_comp_entry("smyatsg,smysign",FALSE)
          CALL cl_set_comp_entry("smydays,smyprit",FALSE)
          LET g_smy.smyatsg = 'N'
          LET g_smy.smysign = ' '
          LET g_smy.smydays = ' '
          LET g_smy.smyprit = ' '
          DISPLAY BY NAME g_smy.smyatsg,g_smy.smysign,
                          g_smy.smydays,g_smy.smyprit
      END IF
   END IF
 
   IF INFIELD(smysys) OR INFIELD(smykind) OR (NOT g_before_input_done) THEN
      IF g_smy.smysys != 'asf' THEN
          CALL cl_set_comp_entry("smy57_1,smy57_2",FALSE)
          #FUN-B30053-add-str--
          LET smy57_1 = 'N'
          IF g_smy.smysys = 'aim' AND g_smy.smykind MATCHES '[1234]' THEN
             CALL cl_set_comp_entry("smy57_2",TRUE)
          ELSE
             LET smy57_2 = 'N'
          END IF
          #FUN-B30053-add-end--
      END IF
      IF g_smy.smysys!='apm' OR g_smy.smykind!='3' THEN
          CALL cl_set_comp_entry("smy57_3",FALSE)
      END IF
     #IF g_smy.smysys != 'apm' OR g_smy.smykind != '2' THEN                             #FUN-B30113
      IF g_smy.smysys != 'apm' OR (g_smy.smykind != '2' AND g_smy.smykind != 'A') THEN  #FUN-B30113
          LET smy57_4 = 'N'       #CHI-920085 
          DISPLAY BY NAME smy57_4 #CHI-920085
          CALL cl_set_comp_entry("smy57_4",FALSE)   #CHI-910055
      END IF
#MOD-B30405 -----------------------Begin-------------------------------
      IF g_smy.smysys = 'apm' AND g_smy.smykind = 'A' THEN
         CALL cl_set_comp_entry("smy57_4",TRUE)    
      END IF
#MOD-B30405 -----------------------End---------------------------------
      IF g_smy.smysys != 'apm' OR g_smy.smykind != '2' THEN
         IF g_smy.smysys != 'asf' OR  g_smy.smykind!= '1' THEN
            IF g_smy.smysys !='aim' OR g_smy.smykind !='3' THEN #CHI-960025      
               LET smy57_5 = 'N'        #CHI-920085
               DISPLAY BY NAME smy57_5  #CHI-920085
               CALL cl_set_comp_entry("smy57_5",FALSE)
            END IF  #CHI-960025    
         END IF
      END IF
      IF NOT (g_smy.smysys ='asf' AND g_smy.smykind ='1') THEN
          CALL cl_set_comp_entry("smy57_6",FALSE)
      END IF
      IF (g_smy.smysys!='asf' OR g_smy.smykind!='1') THEN
          CALL cl_set_comp_entry("smy58",FALSE)
      END IF
 
   END IF
 
   IF g_smy.smysys!='apm' AND g_smy.smysys!='asf' THEN #FUN-990016 add
      CALL cl_set_comp_entry("smy64",FALSE)
   END IF
  #CHI-B10010---add---start---
   IF g_smy.smysys = 'aim' AND g_smy.smykind = '5' THEN
      LET g_smy.smyauno = 'Y'
      CALL cl_set_comp_entry("smyauno",FALSE)
   ELSE
      CALL cl_set_comp_entry("smyauno",TRUE)
   END IF
  #CHI-B10010---add---end---  

END FUNCTION
 
FUNCTION i300_set_noentry_smy51(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF INFIELD(smykind) OR (NOT g_before_input_done) OR INFIELD(smy58) THEN
      CALL cl_set_comp_entry("smy51,smy52,smy61",FALSE)    #FUN-610014 
   END IF
 
END FUNCTION
 
FUNCTION i300_set_entry_smy51(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF INFIELD(smykind) OR (NOT g_before_input_done) THEN
      IF (g_smy.smysys='apm' AND g_smy.smykind='3') OR
         (g_smy.smysys='apm' AND g_smy.smykind='B') OR  #TQC-9B0191
         (g_smy.smysys='asf' AND g_smy.smykind='B') THEN
          CALL cl_set_comp_entry("smy51,smy52",TRUE)
      END IF
      IF g_smy.smysys='aim' AND g_smy.smykind='9' THEN
         CALL cl_set_comp_entry("smy51",TRUE)
      END IF
      IF g_smy.smysys='aim' AND g_smy.smykind='E' THEN
         CALL cl_set_comp_entry("smy61",TRUE)
      END IF
      IF g_smy.smysys='asf' AND g_smy.smykind='1'  THEN
          CALL cl_set_comp_entry("smy58",TRUE)
      END IF
   END IF
 
   IF INFIELD(smy58) OR (NOT g_before_input_done) THEN
      IF (g_smy.smysys='asf' AND g_smy.smykind='1' AND g_smy.smy58='Y') THEN
          CALL cl_set_comp_entry("smy52",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION i300_set_entry_smy72()
  #IF (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCD]') OR  #TQC-9B0191
   IF (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCDE]') OR  #TQC-9B0191  #MOD-BA0177 add E
      (g_smy.smysys='asf' AND g_smy.smykind MATCHES '[13456]') THEN    #FUN-A50023 add 5,6
      CALL cl_set_comp_entry("smy72",TRUE)
   END IF
END FUNCTION
 
FUNCTION i300_set_noentry_smy72()
  #IF NOT (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCD]') OR #TQC-9B0191
   IF NOT (g_smy.smysys='apm' AND g_smy.smykind MATCHES '[12347ABCDE]') OR #MOD-BA0177 add E
      NOT (g_smy.smysys='asf' AND g_smy.smykind MATCHES '[13456]') THEN  #FUN-A50023 add 5,6
      CALL cl_set_comp_entry("smy72",FALSE)
   END IF
END FUNCTION

FUNCTION i300_set_entry_smy73()
DEFINE l_n    LIKE type_file.num5
DEFINE l_flag LIKE type_file.chr1 
DEFINE l_sql  STRING

   IF (g_smy.smysys='asf' AND g_smy.smykind='1') OR 
      (g_smy.smysys='asf' AND g_smy.smykind='3') OR
      (g_smy.smysys='asf' AND g_smy.smykind='A') OR
      (g_smy.smysys='asf' AND g_smy.smykind='C') THEN
       LET l_flag = 'Y'
       CALL cl_set_comp_entry("smy73",TRUE)
   ELSE
       LET l_flag = 'N'
       LET g_smy.smy73 = 'N'
       DISPLAY BY NAME g_smy.smy73
       CALL cl_set_comp_entry("smy73",FALSE)
   END IF
   IF l_flag = 'Y' THEN
      LET l_sql="SELECT count(*) FROM sfb_file ",
                " WHERE sfb01[1,",g_doc_len,"] = '",g_smy.smyslip,"'"
      CASE
        WHEN g_smy.smykind = '1' LET l_sql = l_sql
        WHEN g_smy.smykind = '3' 
             CALL cl_replace_str(l_sql,"sfb","sfp") RETURNING l_sql
        WHEN g_smy.smykind = 'A' OR g_smy.smykind = 'C' 
             CALL cl_replace_str(l_sql,"sfb","sfu") RETURNING l_sql
      END CASE
      PREPARE i300_smy73 FROM l_sql
      EXECUTE i300_smy73 INTO l_n
      IF l_n > 0 THEN
         #No.MOD-A70052  --Begin
         #LET g_smy.smy73 = 'N'
         #DISPLAY BY NAME g_smy.smy73
         #No.MOD-A70052  --End  
         CALL cl_set_comp_entry("smy73",FALSE)
      ELSE
      #No.MOD-A70052  --Begin
         LET l_sql="SELECT count(*) FROM smy_file ",
                   " WHERE smy69 = '",g_smy.smyslip,"'"
         CASE
           WHEN g_smy.smykind = '1' LET l_sql = l_sql
           WHEN g_smy.smykind = '3' 
                CALL cl_replace_str(l_sql,"smy69","smy70") RETURNING l_sql
           WHEN g_smy.smykind = 'A' OR g_smy.smykind = 'C' 
                CALL cl_replace_str(l_sql,"smy69","smy71") RETURNING l_sql
         END CASE
         PREPARE i300_smy73_1 FROM l_sql
         EXECUTE i300_smy73_1 INTO l_n
         IF l_n > 0 THEN
            CALL cl_set_comp_entry("smy73",FALSE)
         END IF
      END IF 
      #No.MOD-A70052  --End  
   END IF
END FUNCTION
                 
FUNCTION i300_upd_oay()
DEFINE l_sql     STRING
DEFINE l_oay     RECORD LIKE oay_file.*  
     LET l_sql = "SELECT * FROM oay_file WHERE oayslip=? FOR UPDATE"
     LET l_sql=cl_forupd_sql(l_sql)
 
     DECLARE i300_oay_bcl CURSOR FROM l_sql      # LOCK CURSOR
 
     OPEN i300_oay_bcl USING g_smy.smyslip
     IF STATUS THEN
        CALL cl_err("OPEN i300_oay_bcl:", STATUS, 1)
        CLOSE i300_oay_bcl
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE oay_file SET
            oay24    = g_smy.smy53,        #內部交易單據否  #No.TQC-7B0149 
            oaydesc  = g_smy.smydesc,
            oayauno  = g_smy.smyauno,
            oayprnt  = g_smy.smyprint,     #立即列印
            oayconf   = g_smy.smydmy4,      #立即確認
            #oaydmy6  = g_smy.smydmy5,      #編號方式       #FUN-A10109 mark by TSD.lucasyeh
            oay12    = g_smy.smy56,        #呆滯日期
            oayapr   = g_smy.smyapr,       #簽核處理
            oaysign  = g_smy.smysign       #簽核處理
            WHERE oayslip = g_smy.smyslip
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","oay_file",g_smy.smyslip,"","asm-618","","upd smy:",1)  #No.FUN-660138
        LET g_success = 'N'
     ELSE
         CALL cl_msgany(11,11,'asm-617') #MOD-750145 add
     END IF
     #FUN-A10109  ===S===
     SELECT * INTO l_oay.* FROM oay_file 
      WHERE oayslip = g_smy.smyslip
     CALL s_access_doc('u',l_oay.oayauno,l_oay.oaytype, l_oay.oayslip,'AXM',
                       l_oay.oayacti)
     #FUN-A10109  ===E===
     CLOSE i300_oay_bcl
END FUNCTION

#FUN-B70022 mark str---
#FUNCTION i300_chk_apr()
#   
#   IF g_smy.smyapr = 'Y' AND g_smy.smydmy4 = 'Y' THEN
#      RETURN TRUE
#   ELSE
#     RETURN FALSE
#   END IF
#END FUNCTION
#FUN-B70022 mark end---
 
FUNCTION i300_smy69(p_slip,p_kind,p_cmd)  #幣別
   DEFINE p_slip    LIKE smy_file.smyslip
   DEFINE p_kind    LIKE smy_file.smykind
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_smysys  LIKE smy_file.smysys
   DEFINE l_smykind LIKE smy_file.smykind 
   DEFINE l_smyacti LIKE smy_file.smyacti 
   DEFINE l_smy73   LIKE smy_file.smy73
   DEFINE l_str     STRING     #TQC-B60259
 
   LET g_errno = ' '
   LET l_str=p_slip    #TQC-B60259
   SELECT smysys,smykind,smyacti,smy73 INTO l_smysys,l_smykind,l_smyacti,l_smy73 #FUN-9B0144
     FROM smy_file
    WHERE smyslip = p_slip
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別
        WHEN p_kind <> l_smykind  LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!
        WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
        WHEN l_smyacti='N'        LET g_errno = '9028'
        WHEN l_smy73 <> 'Y' OR l_smy73 is null LET g_errno = 'asf-877'  #組合拆解關聯單別只能選smy73='Y'的單別 #FUN-9B0144
        WHEN l_str.getLength() <> g_doc_len    LET g_errno = 'sub-143'  #TQC-B60259
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
 
FUNCTION i300_set_noentry_smy69(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1
 
   IF INFIELD(smysys) OR INFIELD(smykind) OR (NOT g_before_input_done) THEN
      IF g_smy.smysys='aim' AND g_smy.smykind MATCHES '[FG]' THEN
      ELSE
         LET g_smy.smy69 = ''
         LET g_smy.smy70 = ''
         LET g_smy.smy71 = ''
         DISPLAY BY NAME g_smy.smy69,g_smy.smy70,g_smy.smy71
         CALL cl_set_comp_entry("smy69,smy70,smy71",FALSE) 
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i300_set_entry_smy69(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   CALL cl_set_comp_entry("smy69,smy70,smy71",TRUE)
 
END FUNCTION
 
FUNCTION i300_set_entry_smy67(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1
  
   IF g_smy.smysys = 'asf' AND g_smy.smykind = '9' THEN 
      CALL cl_set_comp_entry("smy67,smy68,smy76,smy77",TRUE)       #FUN-A80150 add smy76,smy77
   ELSE
   	  LET g_smy.smy67 = ''
   	  LET g_smy.smy68 = ''
   	  DISPLAY BY NAME g_smy.smy67,g_smy.smy68
   	  CALL cl_set_comp_entry("smy67,smy68,smy76,smy77",FALSE)   #FUN-A80150 add smy76,smy77
   END IF  
END FUNCTION 
 
FUNCTION i300_set_noentry_smy67(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1 
 
 CALL cl_set_comp_entry("smy67,smy68,smy76,smy77",FALSE)       #FUN-A80150 add smy76,smy77
END FUNCTION 
 
#FUN-A80054--begin--add-------
FUNCTION i300_set_entry_smy75()

   IF g_smy.smysys = 'asf' AND (g_smy.smykind = 'V' OR g_smy.smykind = '1') THEN  #MOD-B30414
      CALL cl_set_comp_entry("smy75",TRUE)
   ELSE
      LET g_smy.smy75 = ''
      DISPLAY BY NAME g_smy.smy75
      CALL cl_set_comp_entry("smy75",FALSE)
   END IF
END FUNCTION 

FUNCTION i300_set_noentry_smy75()
  CALL cl_set_comp_entry("smy75",FALSE) 
END FUNCTION 
#FUN-A80054--end--add---------

#TQC-B10177-------------add start-------------
FUNCTION i300_set_entry_smy78()

   #IF g_smy.smysys = 'aim' AND g_smy.smykind = '5' THEN                          #FUN-B40082 mark
   IF g_smy.smysys = 'aim' AND (g_smy.smykind = '5' OR g_smy.smykind = 'I') THEN  #FUN-B40082 add   
      CALL cl_set_comp_entry("smy78",TRUE) 
   ELSE
      LET g_smy.smy78 = ''      
      DISPLAY BY NAME g_smy.smy78 
      CALL cl_set_comp_entry("smy78",FALSE)
   END IF
END FUNCTION
#TQC-B10177 ------------add end------------

#FUN-B40082 --START--
FUNCTION i300_set_entry_smy79()
   IF g_smy.smysys = 'aim' AND g_smy.smykind = 'I' THEN
      CALL cl_set_comp_entry("smy79",TRUE) 
   ELSE
      LET g_smy.smy79 = ''
      DISPLAY BY NAME g_smy.smy79
      CALL cl_set_comp_entry("smy79",FALSE) 
   END IF
END FUNCTION
#FUN-B40082 --END--

FUNCTION i300_smy67(p_slip,p_kind,p_cmd)  
   DEFINE p_slip    LIKE smy_file.smyslip
   DEFINE p_kind    LIKE smy_file.smykind
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_smysys  LIKE smy_file.smysys
   DEFINE l_smykind LIKE smy_file.smykind 
   DEFINE l_smyacti LIKE smy_file.smyacti 
   DEFINE l_str     STRING   #TQC-B60259
 
   LET g_errno = ' '
   LET l_str=p_slip  #TQC-B60259
   SELECT smysys,smykind,smyacti INTO l_smysys,l_smykind,l_smyacti
     FROM smy_file
    WHERE smyslip = p_slip
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別
        WHEN p_kind <> l_smykind  LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!
        WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
        WHEN l_smyacti='N'        LET g_errno = '9028'
        WHEN l_str.getLength() <> g_doc_len    LET g_errno = 'sub-143'  #TQC-B60259
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

#FUN-A80150---add---start---
FUNCTION i300_smy76(p_slip,p_kind,p_cmd)  
   DEFINE p_slip    LIKE smy_file.smyslip
   DEFINE p_kind    LIKE smy_file.smykind
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_smysys  LIKE smy_file.smysys
   DEFINE l_smykind LIKE smy_file.smykind 
   DEFINE l_smyacti LIKE smy_file.smyacti 
 
   LET g_errno = ' '
   SELECT smysys,smykind,smyacti INTO l_smysys,l_smykind,l_smyacti
     FROM smy_file
    WHERE smyslip = p_slip
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別
        WHEN p_kind <> l_smykind  LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!
        WHEN l_smysys <> 'apm'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
        WHEN l_smyacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#FUN-A80150---add---end---

FUNCTION i300_smy72(p_cmd)
DEFINE
        p_cmd         LIKE type_file.chr1,
        l_desc        LIKE type_file.chr1000,
        l_c30         LIKE smy_file.smydesc,
        l_kind        LIKE type_file.chr1,
        l_n,l_inx,l_inx1,l_str,l_end LIKE type_file.num5
DEFINE  tok           base.StringTokenizer
DEFINE  l_string      string
DEFINE  l_kind1       string
 
    LET g_errno = ' '
 
    CASE g_smy.smysys
       WHEN 'apm' 
          LET l_inx = 1
          CASE
             WHEN g_smy.smykind="1"
                LET l_str = g_str_1
                LET l_end = g_end_1
             WHEN g_smy.smykind="2"
                LET l_str = g_str_2
                LET l_end = g_end_2
             WHEN g_smy.smykind="3"
                LET l_str = g_str_3
                LET l_end = g_end_3
            #WHEN g_smy.smykind="4"
             WHEN g_smy.smykind="4" OR g_smy.smykind="E"  #MOD-BA0177
                LET l_str = g_str_4
                LET l_end = g_end_4
             WHEN g_smy.smykind="7"
                LET l_str = g_str_5
                LET l_end = g_end_5
             WHEN g_smy.smykind="A"
                LET l_str = g_str_a
                LET l_end = g_end_a
             WHEN g_smy.smykind="B" OR g_smy.smykind="C" OR g_smy.smykind="D"
                LET l_str = g_str_b
                LET l_end = g_end_b
          END CASE
 
       WHEN 'asf' 
          LET l_inx = 2
          CASE g_smy.smykind
             WHEN "1"
                LET l_str = g_str_6
                LET l_end = g_end_6
             WHEN "3"
                LET l_str = g_str_7
                LET l_end = g_end_7
             WHEN "4"
                LET l_str = g_str_8
                LET l_end = g_end_8
          #FUN-A50023 -add
             WHEN "5"
                LET l_str = g_str_9
                LET l_end = g_end_9       
             WHEN "6"
                LET l_str = g_str_10
                LET l_end = g_end_10                   
          #FUN-A50023 -end      
          END CASE
    END CASE
    IF l_inx=0 THEN
       LET g_errno='mfg0070'
    ELSE
       FOR l_n= l_str TO l_end
          LET l_string = g_zemsg[l_n]
          LET tok = base.StringTokenizer.create(l_string,":")
          LET tok=base.StringTokenizer.create(l_string,":")
          WHILE tok.hasMoreTokens()
             LET l_kind1 = tok.nextToken()
             IF g_smy.smy72 = l_kind1 THEN
                LET l_desc=tok.nextToken()
                LET l_c30=l_desc
             END IF
             EXIT WHILE
          END WHILE
          LET l_inx1 = l_n
       END FOR
       IF l_inx1=0 THEN LET g_errno='mfg0071' END IF
   END IF
 
   IF cl_null(g_errno)  OR p_cmd = 'd' THEN
      DISPLAY l_c30 TO FORMONLY.smy72_name
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#TQC-BA0112

