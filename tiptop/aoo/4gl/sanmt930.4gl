# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmt930.4gl
# Descriptions...: 集團資金調撥-還本維護作業
# Date & Author..: No.FUN-620051 2006/03/07 By Mandy
# Modify.........: No.MOD-640271 06/04/11 By Nicola 出入營運中心不可相同
#                                                   撥出/入/手續費銀行不可為'支存'(架構上以T/T)
#                                                   若有手續費支出其銀行應與撥出銀行同(帶預設值)
#                                                   若幣別是本位幣時,其匯為應為1,不可異動
# Modify.........: No.MOD-640288 06/04/11 By Mandy  確認後再按產生分錄,不應出現'lib-028'異動更新不成功'訊息
# Modify.........: No.MOD-640250 06/04/11 By Mandy  1.撥出/手續費異動碼需為'2',撥入異動碼需為'1'
#                                                   2.手續費幣別不可異動
# Modify.........: No.MOD-640344 06/04/12 By Mandy  手續費銀行為空時,其手續費相關欄位不可輸入,且不產生分錄底稿,和不INSERT 銀行異動資料
# Modify.........: No.MOD-640354 06/04/12 By Mandy  1.撥出銀行的存款幣別需=撥入銀行的存款幣別
#                                                   2.單身止息日請先預設單頭日期
# Modify.........: No.MOD-640330 06/04/12 By Mandy  撥出/入/手續費銀行不可為'支存'(架構上以T/T)
# Modify.........: No.MOD-640288 06/04/12 By Mandy  撥出/入科目預設anmi930的反向(即撥出的default撥入科目)
# Modify.........: No.MOD-640448 06/04/12 By Mandy  1.撥入本幣 = 撥入原幣 * 撥入匯率
#                                                   2.撥入本幣改成NOENTRY
# Modify.........: No.TQC-640113 06/04/13 By Mandy  按Action撥出/撥入分錄底稿維護/確認時會切換工廠,切換工廠後FETCH的CURSOR應再DECLARE,OPEN 一次
# Modify.........: No.FUN-640142 06/04/14 By Nicola 金額欄位依幣別取位
# Modify.........: No.FUN-640144 06/04/19 By Nicola 增加列印功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.FUN-640185 06/06/01 BY yiting  單身加2 欄位: 原撥出對方科目,原撥入對方科目
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: NO.FUN-640163 06/06/30 BY yiting 加入自動產生單身功能
# Modify.........: No.FUN-670060 06/08/08 By Ray 直接拋總帳修改
# Modify.........: No.FUN-680088 06/08/25 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-690090 06/09/26 By Rayven 新增內部帳戶
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710024 07/01/29 By cheunl錯誤訊息匯整
# Modify.........: No.FUN-730032 07/03/20 By Elva  新增nme21,nme22,nme23,nme24
# Modify.........: No.TQC-740024 07/04/09 By Judy Key值"還款單號"可以修改
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.MOD-740401 07/04/24 By rainy 撥出分錄無法產生
# Modify.........: No.MOD-740400 07/04/24 By rainy 借款匯率應取撥出營運中心匯率
# Modify.........: No.MOD-740397 07/04/26 By Nicola 無法列印
# Modify.........: No.MOD-740400 07/04/25 By rainy 分錄幣別匯率錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-910034 09/01/06 By chenl  增加數據抓取條件nvvacti='Y'
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960419 09/06/29 By dxfwo 鎖單身時，沒有一并鎖單頭(同一筆數據，單頭被A修改中，但B卻可以修改單身
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.TQC-970266 09/09/24 By baofei 新增時t930_fetch_cur()段，g_wc,g_wc2為空，組SQL g_fetch_sql報錯                 
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-9B0179 09/11/23 By jan 產生分錄底稿時有語法錯誤
# Modify.........: No.TQC-9B0182 09/11/23 By jan 確認時有語法錯誤
# Modify.........: No.TQC-9B0185 09/11/23 By jan CALL t930_ins_nme('2',g_dbs_out,g_azp01_in) ，
# ....................................................應改成 g_dbs_in 才對，否則會造成無法拋轉傳票
# Modify.........: No.TQC-9C0099 09/12/14 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.TQC-9B0171 09/12/13 By liuxqa 取不到azp03时，传出变量不能加'.'或者':'
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40056 11/06/07 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nnw00 LIKE nnw_file.nnw00,  # 1:還本          2:還息
       g_npp00 LIKE npp_file.npp00,  #22:集團資金還本 23:集團資金還息
       g_npq00 LIKE npq_file.npq00,  #22:集團資金還本 23:集團資金還息
       g_argv2 LIKE nnw_file.nnw01,
       g_nnv   RECORD LIKE nnv_file.*,
       g_nnw   RECORD LIKE nnw_file.*,
       g_nnw_t RECORD LIKE nnw_file.*,
       g_nnw_o RECORD LIKE nnw_file.*,
       g_nnw01_t LIKE nnw_file.nnw01,
       b_nnx   RECORD LIKE nnx_file.*,
       g_nmd   RECORD LIKE nmd_file.*,
       g_npp   RECORD LIKE npp_file.*,
       g_npq   RECORD LIKE npq_file.*,
       g_nms   RECORD LIKE nms_file.*,
       g_nme   RECORD LIKE nme_file.*,
       g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
       g_statu             LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) # 是否從新賦予等級
       g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
       #目前所在
       g_dbs_curr          STRING,   #No.FUN-680107 VARCHAR(21)
       g_plant_curr        LIKE type_file.chr10,   #No.FUN-980020
       g_azp01_curr        LIKE azp_file.azp01,
       g_azp03_curr        LIKE azp_file.azp03,
       #撥出
       g_dbs_out           STRING,   #No.FUN-680107 VARCHAR(21)
       g_plant_out         LIKE type_file.chr10,   #No.FUN-980020
       g_azp01_out         LIKE azp_file.azp01,
       g_azp03_out         LIKE azp_file.azp03,
       g_aza17_out         LIKE aza_file.aza17,
       g_nms12_out         LIKE nms_file.nms12,
       g_nms13_out         LIKE nms_file.nms13,
       #撥入
       g_dbs_in            STRING,   #No.FUN-680107 VARCHAR(21)
       g_plant_in          LIKE type_file.chr10,   #No.FUN-980020
       g_azp01_in          LIKE azp_file.azp01,
       g_azp03_in          LIKE azp_file.azp03,
       g_aza17_in          LIKE aza_file.aza17,
       g_nms12_in          LIKE nms_file.nms12,
       g_nms13_in          LIKE nms_file.nms13,
       g_aag02_1           LIKE aag_file.aag02,
       g_aag02_2           LIKE aag_file.aag02,
       g_aag02_3           LIKE aag_file.aag02,
       g_aag02_4           LIKE aag_file.aag02,    #No.FUN-680088 
       g_aag02_5           LIKE aag_file.aag02,    #No.FUN-680088 
       g_aag02_6           LIKE aag_file.aag02,    #No.FUN-680088 
       ddd                 LIKE type_file.num5,    #No.FUN-680107 SMALLINT              
       g_nnx           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
           nnx02            LIKE nnx_file.nnx02,
           nnx03            LIKE nnx_file.nnx03,
           nnx04            LIKE nnx_file.nnx04,
           nnx05            LIKE nnx_file.nnx05,
           nnx06            LIKE nnx_file.nnx06,
           nnx07            LIKE nnx_file.nnx07,
           nnx08            LIKE nnx_file.nnx08,
           #------以下為還本anmt930會用到的欄位-------------------
           nnx09            LIKE nnx_file.nnx09,
           nnx10            LIKE nnx_file.nnx10,
           nnx11            LIKE nnx_file.nnx11,
           nnx12            LIKE nnx_file.nnx12,
           nnx13            LIKE nnx_file.nnx13,
           #------以下為還息anmt940會用到的欄位-------------------
           nnx14            LIKE nnx_file.nnx14,
           nnx15            LIKE nnx_file.nnx15,
           nnx16            LIKE nnx_file.nnx16,
           nnx17            LIKE nnx_file.nnx17,
           nnx18            LIKE nnx_file.nnx18,
           nnx19            LIKE nnx_file.nnx19,
           nnx20            LIKE nnx_file.nnx20,   #NO.FUN-640185
           nnx201           LIKE nnx_file.nnx201,  #No.FUN-680088
           nnx21            LIKE nnx_file.nnx21,   #NO.FUN-640185
           nnx211           LIKE nnx_file.nnx211   #No.FUN-680088
          ,nnxud01          LIKE nnx_file.nnxud01,
           nnxud02          LIKE nnx_file.nnxud02,
           nnxud03          LIKE nnx_file.nnxud03,
           nnxud04          LIKE nnx_file.nnxud04,
           nnxud05          LIKE nnx_file.nnxud05,
           nnxud06          LIKE nnx_file.nnxud06,
           nnxud07          LIKE nnx_file.nnxud07,
           nnxud08          LIKE nnx_file.nnxud08,
           nnxud09          LIKE nnx_file.nnxud09,
           nnxud10          LIKE nnx_file.nnxud10,
           nnxud11          LIKE nnx_file.nnxud11,
           nnxud12          LIKE nnx_file.nnxud12,
           nnxud13          LIKE nnx_file.nnxud13,
           nnxud14          LIKE nnx_file.nnxud14,
           nnxud15          LIKE nnx_file.nnxud15
                       END RECORD,
       g_nnx_t         RECORD                      #程式變數 (舊值)
           nnx02            LIKE nnx_file.nnx02,
           nnx03            LIKE nnx_file.nnx03,
           nnx04            LIKE nnx_file.nnx04,
           nnx05            LIKE nnx_file.nnx05,
           nnx06            LIKE nnx_file.nnx06,
           nnx07            LIKE nnx_file.nnx07,
           nnx08            LIKE nnx_file.nnx08,
           #------以下為還本anmt930會用到的欄位-------------------
           nnx09            LIKE nnx_file.nnx09,
           nnx10            LIKE nnx_file.nnx10,
           nnx11            LIKE nnx_file.nnx11,
           nnx12            LIKE nnx_file.nnx12,
           nnx13            LIKE nnx_file.nnx13,
           #------以下為還息anmt940會用到的欄位-------------------
           nnx14            LIKE nnx_file.nnx14,
           nnx15            LIKE nnx_file.nnx15,
           nnx16            LIKE nnx_file.nnx16,
           nnx17            LIKE nnx_file.nnx17,
           nnx18            LIKE nnx_file.nnx18,
           nnx19            LIKE nnx_file.nnx19,    
           nnx20            LIKE nnx_file.nnx20,    #NO.FUN-640185 
           nnx201           LIKE nnx_file.nnx201,   #No.FUN-680088
           nnx21            LIKE nnx_file.nnx21,    #NO.FUN-640185
           nnx211           LIKE nnx_file.nnx211    #No.FUN-680088
          ,nnxud01          LIKE nnx_file.nnxud01,
           nnxud02          LIKE nnx_file.nnxud02,
           nnxud03          LIKE nnx_file.nnxud03,
           nnxud04          LIKE nnx_file.nnxud04,
           nnxud05          LIKE nnx_file.nnxud05,
           nnxud06          LIKE nnx_file.nnxud06,
           nnxud07          LIKE nnx_file.nnxud07,
           nnxud08          LIKE nnx_file.nnxud08,
           nnxud09          LIKE nnx_file.nnxud09,
           nnxud10          LIKE nnx_file.nnxud10,
           nnxud11          LIKE nnx_file.nnxud11,
           nnxud12          LIKE nnx_file.nnxud12,
           nnxud13          LIKE nnx_file.nnxud13,
           nnxud14          LIKE nnx_file.nnxud14,
           nnxud15          LIKE nnx_file.nnxud15
                       END RECORD,
       g_nnx_o         RECORD                       #程式變數 (舊值)
           nnx02            LIKE nnx_file.nnx02,
           nnx03            LIKE nnx_file.nnx03,
           nnx04            LIKE nnx_file.nnx04,
           nnx05            LIKE nnx_file.nnx05,
           nnx06            LIKE nnx_file.nnx06,
           nnx07            LIKE nnx_file.nnx07,
           nnx08            LIKE nnx_file.nnx08,
           #------以下為還本anmt930會用到的欄位-------------------
           nnx09            LIKE nnx_file.nnx09,
           nnx10            LIKE nnx_file.nnx10,
           nnx11            LIKE nnx_file.nnx11,
           nnx12            LIKE nnx_file.nnx12,
           nnx13            LIKE nnx_file.nnx13,
           #------以下為還息anmt940會用到的欄位-------------------
           nnx14            LIKE nnx_file.nnx14,
           nnx15            LIKE nnx_file.nnx15,
           nnx16            LIKE nnx_file.nnx16,
           nnx17            LIKE nnx_file.nnx17,
           nnx18            LIKE nnx_file.nnx18,
           nnx19            LIKE nnx_file.nnx19,
           nnx20            LIKE nnx_file.nnx20,   #NO.FUN-640185
           nnx201           LIKE nnx_file.nnx201,  #No.FUN-680088
           nnx21            LIKE nnx_file.nnx21,   #NO.FUN-640185
           nnx211           LIKE nnx_file.nnx211   #No.FUN-680088
          ,nnxud01          LIKE nnx_file.nnxud01,
           nnxud02          LIKE nnx_file.nnxud02,
           nnxud03          LIKE nnx_file.nnxud03,
           nnxud04          LIKE nnx_file.nnxud04,
           nnxud05          LIKE nnx_file.nnxud05,
           nnxud06          LIKE nnx_file.nnxud06,
           nnxud07          LIKE nnx_file.nnxud07,
           nnxud08          LIKE nnx_file.nnxud08,
           nnxud09          LIKE nnx_file.nnxud09,
           nnxud10          LIKE nnx_file.nnxud10,
           nnxud11          LIKE nnx_file.nnxud11,
           nnxud12          LIKE nnx_file.nnxud12,
           nnxud13          LIKE nnx_file.nnxud13,
           nnxud14          LIKE nnx_file.nnxud14,
           nnxud15          LIKE nnx_file.nnxud15
                       END RECORD,
       g_rec_b         LIKE type_file.num5,        #單身筆數  #No.FUN-680107 SMALLINT
       l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
       gl_no_b,gl_no_e LIKE oea_file.oea01         #No.FUN-680107 VARCHAR(16) #No.FUN-550057
 
DEFINE g_forupd_sql    STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_fetch_sql     STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_jump          LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680107 SMALLINT
DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE g_i             LIKE type_file.num5         #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(200)  #No.FUN-640144
DEFINE g_str           STRING                      #No.FUN-670060                                                                                   
DEFINE g_wc_gl         STRING                      #No.FUN-670060                                                                                   
DEFINE g_t1            LIKE oay_file.oayslip       #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
DEFINE g_row_count     LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE g_curs_index    LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE g_void          LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)
DEFINE g_nmq21         LIKE nmq_file.nmq21
DEFINE g_nmq22         LIKE nmq_file.nmq22
DEFINE g_nmq23         LIKE nmq_file.nmq23
DEFINE g_nmq24         LIKE nmq_file.nmq24
DEFINE g_nmq211        LIKE nmq_file.nmq211
DEFINE g_nmq221        LIKE nmq_file.nmq221
DEFINE g_nmq231        LIKE nmq_file.nmq231
DEFINE g_nmq241        LIKE nmq_file.nmq241
DEFINE o_azi04         LIKE azi_file.azi04         #No.FUN-640142
DEFINE c_azi04         LIKE azi_file.azi04         #No.FUN-640142
DEFINE i_azi04         LIKE azi_file.azi04         #No.FUN-640142
DEFINE p_azi04         LIKE azi_file.azi04         #No.FUN-640142
DEFINE g_nnw31_nma02   LIKE nma_file.nma02         #No.FUN-690090
DEFINE g_nnw32_nma02   LIKE nma_file.nma02         #No.FUN-690090
DEFINE g_nma01         LIKE nma_file.nma01         #No.FUN-690090
DEFINE g_flag       LIKE type_file.chr1       #No.FUN-730032
DEFINE g_bookno1    LIKE aza_file.aza81       #No.FUN-730032
DEFINE g_bookno2    LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_bookno3    LIKE aza_file.aza82       #No.FUN-730032
 
FUNCTION t930_lock_cur_a() #LOCK 單頭的CURSOR
 
   LET g_forupd_sql = "SELECT * FROM nnw_file WHERE nnw01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t930_cl CURSOR FROM g_forupd_sql
 
END FUNCTION
 
FUNCTION t930_lock_cur_b() #LOCK單身的CURSOR
 
   LET g_forupd_sql = "SELECT nnx02,nnx03,nnx04,nnx05,nnx06,nnx07,nnx08, ",
                      "       nnx09,nnx10,nnx11,nnx12,nnx13, ",      #anmt930用
                      "       nnx14,nnx15,nnx16,nnx17,nnx18,nnx19 ", #anmt940用
                      "      ,nnx20,nnx201,nnx21,nnx211 ",  #NO.FUN-640185  #No.FUN-680088 add nnx201,nnx211
                          ",nnxud01,nnxud02,nnxud03,nnxud04,nnxud05,",
                          "nnxud06,nnxud07,nnxud08,nnxud09,nnxud10,",
                          "nnxud11,nnxud12,nnxud13,nnxud14,nnxud15",
                      "  FROM nnx_file ",
                      " WHERE nnx01=? AND nnx02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t930_bcl  CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t930_fetch_cur()
   IF cl_null(g_wc) THEN                                                                                                            
      LET g_wc = "nnw01 = '",g_nnw.nnw01,"'"                                                                                        
      IF cl_null(g_wc2) THEN                                                                                                        
         LET g_wc2 = ' 1=1'                                                                                                         
      END IF                                                                                                                        
   END IF                                                                                                                           
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnwuser', 'nnwgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_fetch_sql="SELECT nnw01 FROM nnw_file ",
                " WHERE ",g_wc CLIPPED 
   ELSE
      LET g_fetch_sql="SELECT nnw01 FROM nnw_file,nnx_file ",
                " WHERE nnw01=nnx01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
 
   LET g_fetch_sql = g_fetch_sql CLIPPED ," AND nnw00 = '",g_nnw00,"'",
                     " ORDER BY nnw01"
               
   PREPARE t930_prepare FROM g_fetch_sql
   DECLARE t930_cs SCROLL CURSOR WITH HOLD FOR t930_prepare
 
END FUNCTION
 
FUNCTION t930(p_nnw00,p_argv2)
   DEFINE p_nnw00   LIKE nnw_file.nnw00
   DEFINE p_argv2   LIKE nnw_file.nnw01
 
   WHENEVER ERROR CONTINUE
   
   LET g_nnw00 = p_nnw00 #1:還本 2:還息
   LET g_argv2 = p_argv2
   IF g_nnw00 = '1' THEN
      LET g_npp00 = 22
      LET g_npq00 = 22
   ELSE
      LET g_npp00 = 23
      LET g_npq00 = 23
   END IF
 
   CALL t930_def_form()
 
   LET g_plant_new=g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
 
   SELECT nmq21,nmq22,nmq23,nmq24,nmq211,nmq221,nmq231,nmq241 #No.FUN-680088
     INTO g_nmq21,g_nmq22,g_nmq23,g_nmq24,                    #No.FUN-680088  
          g_nmq211,g_nmq221,g_nmq231,g_nmq241                 #No.FUN-680088 
     FROM nmq_file
    WHERE nmq00 = '0'
   INITIALIZE g_nnw.* TO NULL
   INITIALIZE g_nnw_t.* TO NULL
   INITIALIZE g_nnw_o.* TO NULL
 
   IF NOT cl_null(g_argv2) THEN
      CALL t930_q()
   END IF
 
   CALL t930_menu()
 
END FUNCTION
 
FUNCTION t930_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM
   CALL g_nnx.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " nnw01 = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
   ELSE
   INITIALIZE g_nnw.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON nnw01,nnw02,nnw03,nnw04,nnw05,nnw20,
                                nnw06,nnw07,nnw08,nnw09,nnw10,nnw11,
                                nnw12,nnw121,nnw31,nnw13,nnw14,nnw15,nnw16,nnw17,   #No.FUN-680088 add nnw121 #No.FUN-690090 add nnw31
                                nnw18,nnw19,nnw191,nnw21,nnw22,nnw23,nnw24,    #No.FUN-680088 add nnw191
                                nnw25,nnw26,nnw27,nnw271,nnw32,nnw28,nnw29,nnwconf,  #No.FUN-680088 add nnw271 #No.FUN-690090 add nnw32
                                nnwacti,nnwuser,nnwgrup,nnwmodu,nnwdate
                                ,nnwud01,nnwud02,nnwud03,nnwud04,nnwud05,
                                nnwud06,nnwud07,nnwud08,nnwud09,nnwud10,
                                nnwud11,nnwud12,nnwud13,nnwud14,nnwud15
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         ON ACTION CONTROLP
            CASE
                 WHEN INFIELD(nnw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nnw"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw01
                     NEXT FIELD nnw01
                  WHEN INFIELD(nnw03) # 部門
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw03
                     NEXT FIELD nnw03
                  WHEN INFIELD(nnw04) #現金變動碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nml"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw04
                     NEXT FIELD nnw04
                  #==>撥出*****************************************
                  WHEN INFIELD(nnw05) #撥出營運中心
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azp"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw05
                     NEXT FIELD nnw05
                  WHEN INFIELD(nnw06) #撥出銀行代號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nma"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw06
                     NEXT FIELD nnw06
                 WHEN INFIELD(nnw07) #撥出異動碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nmc01"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw07
                     NEXT FIELD nnw07
                  WHEN INFIELD(nnw08) #撥出幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi1"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw08
                     NEXT FIELD nnw08
                  WHEN INFIELD(nnw12) #撥出科目
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw12,'23',g_bookno1)  #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw12
                     NEXT FIELD nnw12
                  WHEN INFIELD(nnw121)
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw121,'23',g_bookno2)  #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw121
                     NEXT FIELD nnw121
                  #==>手續費**************************************
                  WHEN INFIELD(nnw13) #手續費銀行代號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nma"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw13
                     NEXT FIELD nnw13
                 WHEN INFIELD(nnw14) #手續費異動碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nmc01"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw14
                     NEXT FIELD nnw14
                  WHEN INFIELD(nnw15) #手續費幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi1"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw15
                     NEXT FIELD nnw15
                  WHEN INFIELD(nnw19) #手續費科目
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw19,'23',g_bookno1)  #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw19
                     NEXT FIELD nnw19
                  WHEN INFIELD(nnw191)
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw191,'23',g_bookno2)   #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw191
                     NEXT FIELD nnw191
                  #==>撥入*****************************************
                  WHEN INFIELD(nnw20) #撥入營運中心
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azp"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw20
                     NEXT FIELD nnw20
                  WHEN INFIELD(nnw21) #撥入銀行代號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nma"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw21
                     NEXT FIELD nnw21
                 WHEN INFIELD(nnw22) #撥入異動碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_m_nmc01"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw22
                     NEXT FIELD nnw22
                  WHEN INFIELD(nnw23) #撥入幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi1"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw23
                     NEXT FIELD nnw23
                  WHEN INFIELD(nnw27) #撥入科目
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2    #FUN-980020 
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw27,'23',g_bookno1)  #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw27
                     NEXT FIELD nnw27
                  WHEN INFIELD(nnw271)
                     CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                     CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnw.nnw271,'23',g_bookno2)  #No.FUN-980025
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw271
                     NEXT FIELD nnw271
                  WHEN INFIELD(nnw31)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma3"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw31
                     NEXT FIELD nnw31
                  WHEN INFIELD(nnw32)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nma3"
                     LET g_qryparam.plant = g_plant_curr  #No.FUN-980025 add 
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnw32
                     NEXT FIELD nnw32
                  OTHERWISE 
                     EXIT CASE
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
      
      CONSTRUCT g_wc2 ON nnx02,nnx03,nnx04,nnx05,nnx06,nnx07,nnx08,
                         nnx09,nnx10,nnx11,nnx12,nnx13,         #anmt930用
                         nnx14,nnx15,nnx16,nnx17,nnx18,nnx19    #anmt940用
                        ,nnx20,nnx201,nnx21,nnx211   #NO.FUN-640185 #No.FUN-680088 add nnx201,nnx211
                        ,nnxud01,nnxud02,nnxud03,nnxud04,nnxud05
                        ,nnxud06,nnxud07,nnxud08,nnxud09,nnxud10
                        ,nnxud11,nnxud12,nnxud13,nnxud14,nnxud15
           FROM s_nnx[1].nnx02,s_nnx[1].nnx03,s_nnx[1].nnx04,s_nnx[1].nnx05,
                s_nnx[1].nnx06,s_nnx[1].nnx07,s_nnx[1].nnx08,
                s_nnx[1].nnx09,s_nnx[1].nnx10,s_nnx[1].nnx11,s_nnx[1].nnx12,s_nnx[1].nnx13,
                s_nnx[1].nnx14,s_nnx[1].nnx15,s_nnx[1].nnx16,s_nnx[1].nnx17,s_nnx[1].nnx18,s_nnx[1].nnx19
               ,s_nnx[1].nnx20,s_nnx[1].nnx201,s_nnx[1].nnx21,s_nnx[1].nnx211  #No.FUN-680088
               ,s_nnx[1].nnxud01,s_nnx[1].nnxud02,s_nnx[1].nnxud03
               ,s_nnx[1].nnxud04,s_nnx[1].nnxud05,s_nnx[1].nnxud06
               ,s_nnx[1].nnxud07,s_nnx[1].nnxud08,s_nnx[1].nnxud09
               ,s_nnx[1].nnxud10,s_nnx[1].nnxud11,s_nnx[1].nnxud12
               ,s_nnx[1].nnxud13,s_nnx[1].nnxud14,s_nnx[1].nnxud15
 
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
 
 END IF
   CALL t930_fetch_cur() #TQC-640113 add
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql= "SELECT COUNT(*) FROM nnw_file WHERE ",g_wc CLIPPED,
                 "   AND nnw00 = '",g_nnw00,"'"
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nnw01) FROM nnw_file,nnx_file ",
                " WHERE nnw01=nnx01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t930_precount FROM g_sql
   DECLARE t930_count CURSOR FOR t930_precount
END FUNCTION
 
FUNCTION t930_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t930_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t930_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t930_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t930_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t930_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t930_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_wc) THEN
                  IF g_nnw00 = "1" THEN
                     LET g_msg = 'anmr930 "',g_today,'" "',g_user,
                                 '" "',g_lang,'" ',' "Y" " " "1" "',g_wc,'" "N"'   #No.MOD-740397
                  ELSE
                     LET g_msg = 'anmr940  "',g_today,'" "',g_user,
                                 '" "',g_lang,'" ',' "Y" " " "1" "',g_wc,'" "N"'   #No.MOD-740397
                  END IF
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #分錄底稿產生
         WHEN "gen_entry_sheet"
             IF cl_chk_act_auth() THEN
                  CALL t930_gen_entry_sheet()
             END IF
         
         #撥出分錄底稿維護
         WHEN "maintain_entry_sheet_out"
             IF cl_chk_act_auth() THEN
                  CALL t930_main_out()
             END IF
         
         WHEN "maintain_entry_sheet_out_2"
             IF cl_chk_act_auth() THEN
                  CALL t930_main_out_1()
             END IF
 
         #撥入分錄底稿維護
         WHEN "maintain_entry_sheet_in"
             IF cl_chk_act_auth() THEN
                  CALL t930_main_in()
             END IF
         
         WHEN "maintain_entry_sheet_in_2"
             IF cl_chk_act_auth() THEN
                  CALL t930_main_in_1()
             END IF
 
         #作廢
         WHEN "void"
             IF cl_chk_act_auth() THEN
                     CALL t930_x()
                 IF g_nnw.nnwconf = 'X' THEN
                    LET g_void = 'Y'
                 ELSE
                    LET g_void = 'N'
                 END IF
                 CALL cl_set_field_pic(g_nnw.nnwconf,"","","",g_void,"")
             END IF
         #確認
         WHEN "confirm"
             IF cl_chk_act_auth() THEN
                 CALL t930_y()
                 IF g_nnw.nnwconf = 'X' THEN
                    LET g_void = 'Y'
                 ELSE
                    LET g_void = 'N'
                 END IF
                 CALL cl_set_field_pic(g_nnw.nnwconf,"","","",g_void,"")
             END IF
         #取消確認
         WHEN "undo_confirm"
             IF cl_chk_act_auth() THEN
                 CALL t930_z()
                 IF g_nnw.nnwconf = 'X' THEN
                    LET g_void = 'Y'
                 ELSE
                    LET g_void = 'N'
                 END IF
                 CALL cl_set_field_pic(g_nnw.nnwconf,"","","",g_void,"")
             END IF
         WHEN "carry_voucher"                                                                                                    
            IF cl_chk_act_auth() THEN
               IF g_nnw.nnwconf = 'Y' THEN                                                                                             
                  CALL t930_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF
 
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN                                                                                               
               IF g_nnw.nnwconf = 'Y' THEN                                                                                             
                  CALL t930_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnx),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nnw.nnw01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnw01"
                 LET g_doc.value1 = g_nnw.nnw01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
    CLOSE t930_cs
END FUNCTION
 
FUNCTION t930_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_nnx.clear()
   INITIALIZE g_nnw.* LIKE nnw_file.*
   LET g_nnw_t.* = g_nnw.*
   LET g_nnw_o.* = g_nnw.*
   LET g_nnw01_t = NULL
   LET g_nnw.nnw02 = g_today
   LET g_nnw.nnwconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_nnw.nnw00 = g_nnw00 #1:還本 2:還息
      LET g_nnw.nnw02 = g_today
      LET g_nnw.nnw03 = g_grup
      LET g_nnw.nnw05 = g_plant
      LET g_nnw.nnw10 = 0
      LET g_nnw.nnw11 = 0
      LET g_nnw.nnw25 = 0
      LET g_nnw.nnw26 = 0
      LET g_nnw.nnwconf = 'N'
      LET g_nnw.nnwacti = 'Y'
      LET g_nnw.nnwuser = g_user
      LET g_nnw.nnworiu = g_user #FUN-980030
      LET g_nnw.nnworig = g_grup #FUN-980030
      LET g_nnw.nnwgrup = g_grup               #使用者所屬群
      LET g_nnw.nnwdate = g_today
 
      LET g_nnw.nnwlegal= g_legal
      IF g_nnw00='1' THEN
          LET g_nnw.nnw12 = g_nmq22 #改default 集團資金調撥(撥入)科目 
          LET g_nnw.nnw27 = g_nmq21 #改default 集團資金調撥(撥出)科目 
          IF g_aza.aza63 = 'Y' THEN
             LET g_nnw.nnw121 = g_nmq221
             LET g_nnw.nnw271 = g_nmq211
          END IF
      ELSE
          LET g_nnw.nnw12 = g_nmq24 #改default 集團資金調撥利息(撥入)科目 
          LET g_nnw.nnw27 = g_nmq23 #改default 集團資金調撥利息(撥出)科目 
          IF g_aza.aza63 = 'Y' THEN
             LET g_nnw.nnw121 = g_nmq241
             LET g_nnw.nnw271 = g_nmq231
          END IF
      END IF
      CALL t930_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          INITIALIZE g_nnw.* TO NULL
          CALL cl_err('',9001,0)
          CLEAR FORM
          CALL g_nnx.clear()
          EXIT WHILE
      END IF
      IF g_nnw.nnw01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
 
      CALL s_auto_assign_no("anm",g_nnw.nnw01,g_nnw.nnw02,"I","nnw_file","nnw01","","","")
           RETURNING li_result,g_nnw.nnw01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_nnw.nnw01
 
      INSERT INTO nnw_file VALUES(g_nnw.*)     # DISK WRITE IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","nnw_file",g_nnw.nnw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148    #FUN-B80035  ADD
         ROLLBACK WORK
      #   CALL cl_err3("ins","nnw_file",g_nnw.nnw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148    #FUN-B80035  MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_nnw.nnw01,'I')
         LET g_nnw_t.* = g_nnw.*               # 保存上筆資料
         SELECT nnw01 INTO g_nnw.nnw01 FROM nnw_file
                WHERE nnw01 = g_nnw.nnw01
      END IF
      CALL g_nnx.clear()
      CALL SET_COUNT(0)
      LET g_rec_b = 0 
      CALL t930_b()
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t930_i(p_cmd)
    DEFINE l_buf        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
    DEFINE
        l_nmd01         LIKE nmd_file.nmd01,
        p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
        l_t             LIKE oay_file.oayslip,  #No.FUN-690090
        l_dept          LIKE cre_file.cre09,    #No.FUN-680107 VARCHAR(10) #Dept
        l_n             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_nma37         LIKE nma_file.nma37,    #No.FUN-690090
        l_nma37_2       LIKE nma_file.nma37,    #No.FUN-690090
        l_nmc03_1       LIKE nmc_file.nmc03,    #No.FUN-690090
        l_nmc03_2       LIKE nmc_file.nmc03     #No.FUN-690090
DEFINE  li_result       LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_nnw.nnworiu,g_nnw.nnworig,
        g_nnw.nnw01,g_nnw.nnw02,g_nnw.nnw03,g_nnw.nnw04,g_nnw.nnw05,g_nnw.nnw20,
        g_nnw.nnw06,g_nnw.nnw07,g_nnw.nnw08,g_nnw.nnw09,g_nnw.nnw10,
        g_nnw.nnw11,g_nnw.nnw12,g_nnw.nnw121,g_nnw.nnw31,g_nnw.nnw13,g_nnw.nnw14,g_nnw.nnw15, #No.FUN-680088 g_nnw.nnw121 #No.FUN-690090 add nnw31
        g_nnw.nnw16,g_nnw.nnw17,g_nnw.nnw18,g_nnw.nnw19,g_nnw.nnw191,  #No.FUN-680088 g_nnw.nnw191
        g_nnw.nnw21,g_nnw.nnw22,g_nnw.nnw23,g_nnw.nnw24,g_nnw.nnw25,
        g_nnw.nnw26,g_nnw.nnw27,g_nnw.nnw271,g_nnw.nnw32,g_nnw.nnw28,g_nnw.nnw29,  #No.FUN-680088 g_nnw.nnw271  #No.FUN-690090 add nnw32
        g_nnw.nnwconf,g_nnw.nnwacti,
        g_nnw.nnwuser,g_nnw.nnwgrup,g_nnw.nnwmodu,g_nnw.nnwdate
       ,g_nnw.nnwud01,g_nnw.nnwud02,g_nnw.nnwud03,g_nnw.nnwud04,
        g_nnw.nnwud05,g_nnw.nnwud06,g_nnw.nnwud07,g_nnw.nnwud08,
        g_nnw.nnwud09,g_nnw.nnwud10,g_nnw.nnwud11,g_nnw.nnwud12,
        g_nnw.nnwud13,g_nnw.nnwud14,g_nnw.nnwud15 
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t930_set_entry_a()       #MOD-640344 add
            CALL t930_set_no_entry_a()    #MOD-640344 add
            CALL t930_no_required_a()     #MOD-640344 add
            CALL t930_required_a()        #MOD-640344 add
            CALL t930_set_entry(p_cmd)    #TQC-740024 
            CALL t930_set_no_entry(p_cmd) #TQC-740024
            LET g_before_input_done = TRUE
 
        AFTER FIELD nnw01 #還款單號
           IF NOT cl_null(g_nnw.nnw01) THEN
               IF g_nnw_o.nnw01 != g_nnw.nnw01 OR cl_null(g_nnw_o.nnw01) THEN
                   CALL s_check_no("anm",g_nnw.nnw01,g_nnw01_t,"I","nnw_file","nnw01","")
                   RETURNING li_result,g_nnw.nnw01
                   DISPLAY BY NAME g_nnw.nnw01
                   IF (NOT li_result) THEN
                       NEXT FIELD nnw01
                   END IF
                   LET l_buf = s_get_doc_no(g_nnw.nnw01)
                   SELECT nmydesc INTO l_buf FROM nmy_file
                    WHERE nmyslip=l_buf
                   DISPLAY l_buf TO FORMONLY.nmydesc
               END IF
               LET l_t = s_get_doc_no(g_nnw.nnw01)
               SELECT nmydmy6 INTO g_nmy.nmydmy6 FROM nmy_file WHERE nmyslip = l_t
               CALL t930_set_entry_a()
               CALL t930_set_no_entry_a()
           END IF
           LET g_nnw_o.nnw01 = g_nnw.nnw01
        AFTER FIELD nnw03 #部門
            IF NOT cl_null(g_nnw.nnw03) THEN
                CALL t930_nnw03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw03,g_errno,1)
                    LET g_nnw.nnw03 = g_nnw_t.nnw03
                    DISPLAY BY NAME g_nnw.nnw03
                    NEXT FIELD nnw03
                END IF
            END IF
            LET g_nnw_o.nnw03 = g_nnw.nnw03
        AFTER FIELD nnw04 #現金變動碼
            IF NOT cl_null(g_nnw.nnw04) THEN
                CALL t930_nnw04(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw04,g_errno,1)
                    LET g_nnw.nnw04 = g_nnw_t.nnw04
                    DISPLAY BY NAME g_nnw.nnw04
                    NEXT FIELD nnw04
                END IF
            END IF
            LET g_nnw_o.nnw04 = g_nnw.nnw04
#==>撥出**********************************************
        AFTER FIELD nnw05 #還款營運中心
            IF NOT cl_null(g_nnw.nnw05) THEN
                CALL t930_plantnam(p_cmd,'1',g_nnw.nnw05)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw05,g_errno,1)
                    LET g_nnw.nnw05 = g_nnw_t.nnw05
                    DISPLAY BY NAME g_nnw.nnw05
                    NEXT FIELD nnw05
                END IF
                IF NOT cl_null(g_nnw.nnw20) THEN
                   IF g_nnw.nnw05 = g_nnw.nnw20 THEN
                      CALL cl_err("","apm-101",0)
                      NEXT FIELD nnw05
                   END IF
                END IF
                #CALL t930_aza17(g_dbs_out) RETURNING g_aza17_out
                CALL t930_aza17(g_plant_out) RETURNING g_aza17_out  #FUN-A50102
                IF g_nnw_o.nnw05 != g_nnw.nnw05 THEN
                    IF NOT cl_null(g_nnw.nnw06) THEN
                        #CALL t930_nma01(p_cmd,'1',g_dbs_out,g_nnw.nnw06)
                        CALL t930_nma01(p_cmd,'1',g_plant_out,g_nnw.nnw06) #FUN-A50102
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_nnw.nnw06,g_errno,1)
                            LET g_nnw.nnw06 = g_nnw_t.nnw06
                            DISPLAY BY NAME g_nnw.nnw06
                            NEXT FIELD nnw06
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw05 = g_nnw.nnw05
 
        AFTER FIELD nnw06 #撥出銀行
            IF cl_null(g_nnw.nnw06) THEN
               LET g_nnw.nnw08 = NULL
               DISPLAY g_nnw.nnw08 TO nnw08
               DISPLAY NULL TO nma02_1
            END IF
            IF NOT cl_null(g_nnw.nnw06) THEN
                IF g_nnw_o.nnw06 != g_nnw.nnw06 OR cl_null(g_nnw_o.nnw06) THEN
                    #CALL t930_nma01(p_cmd,'1',g_dbs_out,g_nnw.nnw06)
                    CALL t930_nma01(p_cmd,'1',g_plant_out,g_nnw.nnw06)  #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnw.nnw06,g_errno,1)
                        LET g_nnw.nnw06 = g_nnw_t.nnw06
                        DISPLAY BY NAME g_nnw.nnw06
                        NEXT FIELD nnw06
                    END IF
                END IF
                IF p_cmd='a' THEN #MOD-640344 add if 判斷
                    IF cl_null(g_nnw.nnw13) THEN
                       LET g_nnw.nnw13 = g_nnw.nnw06
                       DISPLAY BY NAME g_nnw.nnw13
                    END IF
                END IF
                CALL t930_set_entry_a()       #MOD-640344 add
                CALL t930_set_no_entry_a()    #MOD-640344 add
                CALL t930_no_required_a()     #MOD-640344 add
                CALL t930_required_a()        #MOD-640344 add
            END IF
            LET g_nnw_o.nnw06 = g_nnw.nnw06
            IF NOT cl_null(g_nnw.nnw08) AND NOT cl_null(g_nnw.nnw23) THEN
                IF g_nnw.nnw08 <>g_nnw.nnw23 THEN
                    #撥出銀行的存款幣別需=撥入銀行的存款幣別
                    CALL cl_err('','anm-924',1) 
                    LET g_nnw.nnw06 = g_nnw_t.nnw06
                    LET g_nnw.nnw08 = g_nnw_t.nnw08
                    LET g_nnw.nnw09 = g_nnw_t.nnw09
                    DISPLAY BY NAME g_nnw.nnw06
                    DISPLAY BY NAME g_nnw.nnw08
                    DISPLAY BY NAME g_nnw.nnw09
                    DISPLAY '' TO FORMONLY.nma02_1
                    NEXT FIELD nnw06
                END IF
            END IF
            LET l_nma37 = NULL
            LET l_nma37_2 = NULL
            #LET g_sql = "SELECT nma37 FROM ",g_dbs_out,"nma_file",
            LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                        " WHERE nma01 = '",g_nnw.nnw06,"'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
            PREPARE nma37_p1 FROM g_sql
            DECLARE nma37_c1 CURSOR FOR nma37_p1
            OPEN nma37_c1
            FETCH nma37_c1 INTO l_nma37
            IF NOT cl_null(g_nnw.nnw01) THEN
               IF g_nmy.nmydmy6 = 'Y' THEN
                  IF l_nma37 = '0' THEN
                     CALL cl_err(g_nnw.nnw06,'anm-991',1)
                     NEXT FIELD nnw06
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_nnw.nnw21) THEN
               #LET g_sql = "SELECT nma37 FROM ",g_dbs_in,"nma_file",
               LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                           " WHERE nma01 = '",g_nnw.nnw21,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
               PREPARE nma37_p2 FROM g_sql
               DECLARE nma37_c2 CURSOR FOR nma37_p2
               OPEN nma37_c2
               FETCH nma37_c2 INTO l_nma37_2
               IF l_nma37 <> l_nma37_2 THEN
                  CALL cl_err(g_nnw.nnw06,'anm-990',1)
                  NEXT FIELD nnw06
               END IF
            END IF
 
        AFTER FIELD nnw07 #撥出異動碼
            IF NOT cl_null(g_nnw.nnw07) THEN
                #CALL t930_nmc01(p_cmd,'1',g_dbs_out,g_nnw.nnw07,'2')
                CALL t930_nmc01(p_cmd,'1',g_plant_out,g_nnw.nnw07,'2')  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw07,g_errno,1)
                    LET g_nnw.nnw07 = g_nnw_t.nnw07
                    DISPLAY BY NAME g_nnw.nnw07
                    NEXT FIELD nnw07
                END IF
                IF NOT cl_null(g_nnw.nnw32) THEN
                   LET l_nmc03_1 = NULL
                   LET l_nmc03_2 = NULL
                   #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
                   LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                               " WHERE nmc01 = '",g_nnw.nnw07,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
                   PREPARE nmc03_p1 FROM g_sql
                   DECLARE nmc03_c1 CURSOR FOR nmc03_p1
                   OPEN nmc03_c1
                   FETCH nmc03_c1 INTO l_nmc03_1
                   IF cl_null(l_nmc03_1) THEN
                      CALL cl_err(g_nnw.nnw07,'anm-987',1)
                      NEXT FIELD nnw07
                   ELSE
                      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
                      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                                  " WHERE nmc01 = '",g_nnw.nnw07,"'"
 	                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                      CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                      PREPARE nmc03_p2 FROM g_sql
                      DECLARE nmc03_c2 CURSOR FOR nmc03_p2
                      OPEN nmc03_c2
                      FETCH nmc03_c2 INTO l_nmc03_2
                      IF l_nmc03_1 <> l_nmc03_2 THEN
                         CALL cl_err(g_nnw.nnw07,'anm-986',1)
                         NEXT FIELD nnw07
                      END IF
                   END IF
                END IF
            END IF
            LET g_nnw_o.nnw07 = g_nnw.nnw07
        BEFORE FIELD nnw09 #撥出幣別/匯率
            IF NOT cl_null(g_nnw.nnw08) THEN
                #CALL t930_azi01(p_cmd,'1',g_dbs_out,g_nnw.nnw08)  #幣別
                CALL t930_azi01(p_cmd,'1',g_plant_out,g_nnw.nnw08)  #幣別  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw08,g_errno,1)
                    LET g_nnw.nnw08 = g_nnw_t.nnw08
                    DISPLAY BY NAME g_nnw.nnw08
                    NEXT FIELD nnw08
                END IF
                IF g_nnw_o.nnw08 != g_nnw.nnw08 OR cl_null(g_nnw_o.nnw08) THEN
                    CALL s_currm(g_nnw.nnw08,g_nnw.nnw02,'S',g_plant_out) #FUN-980020
                         RETURNING g_nnw.nnw09
                    DISPLAY BY NAME g_nnw.nnw09
                    #預設撥入幣別同撥出幣別(撥入幣別nnw23不可修正)
                    IF cl_null(g_nnw.nnw23) THEN
                        LET g_nnw.nnw23 = g_nnw.nnw08
                        DISPLAY BY NAME g_nnw.nnw23
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw08 = g_nnw.nnw08
 
        AFTER FIELD nnw09  #匯率
            IF NOT cl_null(g_nnw.nnw09) THEN
                IF g_nnw.nnw09 <=0 THEN
                    NEXT FIELD nnw09
                END IF
                IF g_nnw.nnw08 = g_aza17_out AND g_nnw.nnw09 != 1 THEN
                    NEXT FIELD nnw09
                END IF
            END IF
            LET g_nnw_o.nnw09 = g_nnw.nnw09
 
        BEFORE FIELD nnw12 #撥出科目
            IF cl_null(g_nnw.nnw12) THEN
                IF g_nnw00='1' THEN
                    LET g_nnw.nnw12 = g_nmq22 #MOD-640288 #改default集團資金調撥(撥入)科目 
                ELSE
                    LET g_nnw.nnw12 = g_nmq24 #MOD-640288 #改default集團資金調撥利息(撥入)科目 
                END IF
                DISPLAY BY NAME g_nnw.nnw12
            END IF
        AFTER FIELD nnw12 #撥出科目
            IF NOT cl_null(g_nnw.nnw12) THEN
                CALL t930_aag(g_nnw.nnw12,g_plant_out) RETURNING g_aag02_1   #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw12,g_errno,1)
                    LET g_nnw.nnw12 = g_nnw_t.nnw12
                    DISPLAY BY NAME g_nnw.nnw12
                    NEXT FIELD nnw12
                END IF
                DISPLAY g_aag02_1  TO FORMONLY.aag02_1
            END IF
            LET g_nnw_o.nnw12 = g_nnw.nnw12
 
        BEFORE FIELD nnw121
            IF cl_null(g_nnw.nnw121) THEN
                IF g_nnw00='1' THEN
                    LET g_nnw.nnw121 = g_nmq221
                ELSE
                    LET g_nnw.nnw121 = g_nmq241
                END IF
                DISPLAY BY NAME g_nnw.nnw121
            END IF
        AFTER FIELD nnw121
            IF NOT cl_null(g_nnw.nnw121) THEN
                CALL t930_aag(g_nnw.nnw121,g_plant_out) RETURNING g_aag02_4   #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw121,g_errno,1)
                    LET g_nnw.nnw121 = g_nnw_t.nnw121
                    DISPLAY BY NAME g_nnw.nnw121
                    NEXT FIELD nnw121
                END IF
                DISPLAY g_aag02_4  TO FORMONLY.aag02_4
            END IF
            LET g_nnw_o.nnw121 = g_nnw.nnw121
 
#==>手續費*********************************************
        BEFORE FIELD nnw13 #手續費銀行
            CALL t930_set_entry_a()       #MOD-640344 add
        AFTER FIELD nnw13 #手續費銀行
            IF NOT cl_null(g_nnw.nnw13) THEN
                IF g_nnw_o.nnw13 != g_nnw.nnw13 OR cl_null(g_nnw_o.nnw13) THEN
                    #CALL t930_nma01(p_cmd,'3',g_dbs_out,g_nnw.nnw13)
                    CALL t930_nma01(p_cmd,'3',g_plant_out,g_nnw.nnw13) #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnw.nnw13,g_errno,1)
                        LET g_nnw.nnw13 = g_nnw_t.nnw13
                        DISPLAY BY NAME g_nnw.nnw13
                        NEXT FIELD nnw13
                    END IF
                    #手續費銀行異動後,會自動帶出幣別,匯率,所以手續費本幣也應重算
                    IF NOT cl_null(g_nnw.nnw16) AND g_nnw.nnw16 != 0 THEN
                        IF NOT cl_null(g_nnw.nnw17) AND g_nnw.nnw17 != 0 THEN
                            LET g_nnw.nnw18=g_nnw.nnw17 * g_nnw.nnw16
                            CALL cl_digcut(g_nnw.nnw18,g_azi04) RETURNING g_nnw.nnw18  #No.FUN-640142
                            DISPLAY BY NAME g_nnw.nnw18
                        END IF
                    END IF
                END IF
            END IF
            CALL t930_set_no_entry_a()    #MOD-640344 add
            CALL t930_no_required_a()     #MOD-640344 add
            CALL t930_required_a()        #MOD-640344 add
            LET g_nnw_o.nnw13 = g_nnw.nnw13
        AFTER FIELD nnw14 #手續費異動碼
            IF NOT cl_null(g_nnw.nnw14) THEN
                #CALL t930_nmc01(p_cmd,'3',g_dbs_out,g_nnw.nnw14,'2')
                CALL t930_nmc01(p_cmd,'3',g_plant_out,g_nnw.nnw14,'2')  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw14,g_errno,1)
                    LET g_nnw.nnw14 = g_nnw_t.nnw14
                    DISPLAY BY NAME g_nnw.nnw14
                    NEXT FIELD nnw14
                END IF
            END IF
            LET g_nnw_o.nnw14 = g_nnw.nnw14
        AFTER FIELD nnw15 #手續費幣別
            IF NOT cl_null(g_nnw.nnw15) THEN
                #CALL t930_azi01(p_cmd,'3',g_dbs_out,g_nnw.nnw15)  #幣別
                CALL t930_azi01(p_cmd,'3',g_plant_out,g_nnw.nnw15)  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw15,g_errno,1)
                    LET g_nnw.nnw15 = g_nnw_t.nnw15
                    DISPLAY BY NAME g_nnw.nnw15
                    NEXT FIELD nnw15
                END IF
                IF g_nnw_o.nnw15 != g_nnw.nnw15 OR cl_null(g_nnw_o.nnw15) THEN
                    CALL s_currm(g_nnw.nnw15,g_nnw.nnw02,'S',g_plant_out)  #TQC-9C0099
                         RETURNING g_nnw.nnw16
                    DISPLAY BY NAME g_nnw.nnw16
                    IF NOT cl_null(g_nnw.nnw16) AND g_nnw.nnw16 != 0 THEN
                        IF NOT cl_null(g_nnw.nnw17) AND g_nnw.nnw17 != 0 THEN
                            LET g_nnw.nnw18=g_nnw.nnw17 * g_nnw.nnw16
                            CALL cl_digcut(g_nnw.nnw18,g_azi04) RETURNING g_nnw.nnw18  #No.FUN-640142
                            DISPLAY BY NAME g_nnw.nnw18
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw15 = g_nnw.nnw15
 
        AFTER FIELD nnw16  #匯率
            IF NOT cl_null(g_nnw.nnw16) THEN
                IF g_nnw.nnw16 <=0 THEN
                    NEXT FIELD nnw16
                END IF
                IF g_nnw.nnw15 = g_aza17_out AND g_nnw.nnw16 != 1 THEN
                    NEXT FIELD nnw16
                END IF
                IF g_nnw_o.nnw16 != g_nnw.nnw16 OR cl_null(g_nnw_o.nnw16) THEN
                    IF NOT cl_null(g_nnw.nnw16) AND g_nnw.nnw16 != 0 THEN
                        IF NOT cl_null(g_nnw.nnw17) AND g_nnw.nnw17 != 0 THEN
                            LET g_nnw.nnw18=g_nnw.nnw17 * g_nnw.nnw16
                            CALL cl_digcut(g_nnw.nnw18,g_azi04) RETURNING g_nnw.nnw18  #No.FUN-640142
                            DISPLAY BY NAME g_nnw.nnw18
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw16 = g_nnw.nnw16
 
        AFTER FIELD nnw17 #手續費原幣
            IF NOT cl_null(g_nnw.nnw17) THEN
               CALL cl_digcut(g_nnw.nnw17,c_azi04) RETURNING g_nnw.nnw17  #No.FUN-640142
               DISPLAY BY NAME g_nnw.nnw17
                IF g_nnw.nnw17 < 0 THEN
                    CALL cl_err(g_nnw.nnw17,'aim-391',1)
                    LET g_nnw.nnw17 = g_nnw_t.nnw17
                    DISPLAY BY NAME g_nnw.nnw17
                    NEXT FIELD nnw17
                END IF
                IF g_nnw_o.nnw17 != g_nnw.nnw17 OR cl_null(g_nnw_o.nnw17) THEN
                    IF NOT cl_null(g_nnw.nnw16) AND g_nnw.nnw16 != 0 THEN
                        IF NOT cl_null(g_nnw.nnw17) AND g_nnw.nnw17 != 0 THEN
                            LET g_nnw.nnw18=g_nnw.nnw17 * g_nnw.nnw16
                            CALL cl_digcut(g_nnw.nnw18,g_azi04) RETURNING g_nnw.nnw18  #No.FUN-640142
                            DISPLAY BY NAME g_nnw.nnw18
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw17 = g_nnw.nnw17
        AFTER FIELD nnw18 #手續費本幣
            IF NOT cl_null(g_nnw.nnw18) THEN
               CALL cl_digcut(g_nnw.nnw18,g_azi04) RETURNING g_nnw.nnw18  #No.FUN-640142
               DISPLAY BY NAME g_nnw.nnw18
                IF g_nnw.nnw18 < 0 THEN
                    CALL cl_err(g_nnw.nnw18,'aim-391',1)
                    LET g_nnw.nnw18 = g_nnw_t.nnw18
                    DISPLAY BY NAME g_nnw.nnw18
                    NEXT FIELD nnw18
                END IF
            END IF
            LET g_nnw_o.nnw18 = g_nnw.nnw18
        BEFORE FIELD nnw19 #手續費科目
            IF cl_null(g_nnw.nnw19) THEN
                LET g_sql =
                           #"SELECT nms58 FROM ",g_dbs_out CLIPPED,"nms_file",
                           "SELECT nms58 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                           " WHERE nms01 = '",g_nnw.nnw03,"'"
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                PREPARE nms_pre1 FROM g_sql
                DECLARE nms_cur1 CURSOR FOR nms_pre1
                OPEN nms_cur1
                FETCH nms_cur1 INTO g_nnw.nnw19
                IF STATUS = 100 THEN
                    LET g_sql =
                               #"SELECT nms58 FROM ",g_dbs_out CLIPPED,"nms_file",
                               "SELECT nms58 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                               " WHERE nms01 = ' ' "
 	                CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                    CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                    PREPARE nms_pre2 FROM g_sql
                    DECLARE nms_cur2 CURSOR FOR nms_pre2
                    OPEN nms_cur2
                    FETCH nms_cur2 INTO g_nnw.nnw19
                END IF
                DISPLAY BY NAME g_nnw.nnw19
            END IF
        AFTER FIELD nnw19 #手續費科目
            IF NOT cl_null(g_nnw.nnw19) THEN
                CALL t930_aag(g_nnw.nnw19,g_plant_out) RETURNING g_aag02_3   #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw19,g_errno,1)
                    LET g_nnw.nnw19 = g_nnw_t.nnw19
                    DISPLAY BY NAME g_nnw.nnw19
                    NEXT FIELD nnw19
                END IF
                DISPLAY g_aag02_3  TO FORMONLY.aag02_3
            END IF
            LET g_nnw_o.nnw19 = g_nnw.nnw19
 
        BEFORE FIELD nnw191
            IF cl_null(g_nnw.nnw191) THEN
                LET g_sql =
                           #"SELECT nms581 FROM ",g_dbs_out CLIPPED,"nms_file",
                           "SELECT nms581 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                           " WHERE nms01 = '",g_nnw.nnw03,"'"
 	            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                PREPARE nms_pre3 FROM g_sql
                DECLARE nms_cur3 CURSOR FOR nms_pre3
                OPEN nms_cur3
                FETCH nms_cur3 INTO g_nnw.nnw191
                IF STATUS = 100 THEN
                    LET g_sql =
                               #"SELECT nms581 FROM ",g_dbs_out CLIPPED,"nms_file",
                               "SELECT nms581 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                               " WHERE nms01 = ' ' "
 	                CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                    CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                    PREPARE nms_pre4 FROM g_sql
                    DECLARE nms_cur4 CURSOR FOR nms_pre4
                    OPEN nms_cur4
                    FETCH nms_cur4 INTO g_nnw.nnw191
                END IF
                DISPLAY BY NAME g_nnw.nnw191
            END IF
        AFTER FIELD nnw191
            IF NOT cl_null(g_nnw.nnw191) THEN
                CALL t930_aag(g_nnw.nnw191,g_plant_out) RETURNING g_aag02_6  #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw191,g_errno,1)
                    LET g_nnw.nnw191 = g_nnw_t.nnw191
                    DISPLAY BY NAME g_nnw.nnw191
                    NEXT FIELD nnw191
                END IF
                DISPLAY g_aag02_6  TO FORMONLY.aag02_6
            END IF
            LET g_nnw_o.nnw191 = g_nnw.nnw191
 
#==>撥入**********************************************
        AFTER FIELD nnw20 #撥入營運中心
            IF NOT cl_null(g_nnw.nnw20) THEN
                CALL t930_plantnam(p_cmd,'2',g_nnw.nnw20)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw20,g_errno,1)
                    LET g_nnw.nnw20 = g_nnw_t.nnw20
                    DISPLAY BY NAME g_nnw.nnw20
                    NEXT FIELD nnw20
                END IF
                IF NOT cl_null(g_nnw.nnw05) THEN
                   IF g_nnw.nnw05 = g_nnw.nnw20 THEN
                      CALL cl_err("","apm-101",0)
                      NEXT FIELD nnw20
                   END IF
                END IF
                #CALL t930_aza17(g_dbs_in) RETURNING g_aza17_in
                CALL t930_aza17(g_plant_in) RETURNING g_aza17_in  #FUN-A50102
                IF g_nnw_o.nnw20 != g_nnw.nnw20 OR cl_null(g_nnw_o.nnw20) THEN
                    IF NOT cl_null(g_nnw.nnw21) THEN
                        #CALL t930_nma01(p_cmd,'2',g_dbs_in,g_nnw.nnw21)
                        CALL t930_nma01(p_cmd,'2',g_plant_in,g_nnw.nnw21)  #FUN-A50102
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_nnw.nnw21,g_errno,1)
                            LET g_nnw.nnw21 = g_nnw_t.nnw21
                            DISPLAY BY NAME g_nnw.nnw21
                            NEXT FIELD nnw21
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw20 = g_nnw.nnw20
 
        AFTER FIELD nnw21 #撥入銀行
            IF cl_null(g_nnw.nnw21) THEN
               LET g_nnw.nnw23 = NULL
               DISPLAY g_nnw.nnw23 TO nnw23
               DISPLAY NULL TO nma02_2
            END IF
            IF NOT cl_null(g_nnw.nnw21) THEN
                IF g_nnw_o.nnw21 != g_nnw.nnw21 OR cl_null(g_nnw_o.nnw21) THEN
                    #CALL t930_nma01(p_cmd,'2',g_dbs_in,g_nnw.nnw21)
                    CALL t930_nma01(p_cmd,'2',g_plant_in,g_nnw.nnw21)  #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnw.nnw21,g_errno,1)
                        LET g_nnw.nnw21 = g_nnw_t.nnw21
                        DISPLAY BY NAME g_nnw.nnw21
                        NEXT FIELD nnw21
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw21 = g_nnw.nnw21
            IF NOT cl_null(g_nnw.nnw08) AND NOT cl_null(g_nnw.nnw23) THEN
                IF g_nnw.nnw08 <>g_nnw.nnw23 THEN
                    #撥出銀行的存款幣別需=撥入銀行的存款幣別
                    CALL cl_err('','anm-924',1) 
                    LET g_nnw.nnw21 = g_nnw_t.nnw21
                    LET g_nnw.nnw23 = g_nnw_t.nnw23
                    LET g_nnw.nnw24 = g_nnw_t.nnw24
                    DISPLAY BY NAME g_nnw.nnw21
                    DISPLAY BY NAME g_nnw.nnw23
                    DISPLAY BY NAME g_nnw.nnw24
                    DISPLAY '' TO FORMONLY.nma02_2
                    NEXT FIELD nnw21
                END IF
            END IF
            LET l_nma37 = NULL
            LET l_nma37_2 = NULL
            #LET g_sql = "SELECT nma37 FROM ",g_dbs_in,"nma_file",
            LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                        " WHERE nma01 = '",g_nnw.nnw21,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
            PREPARE nma37_p3 FROM g_sql
            DECLARE nma37_c3 CURSOR FOR nma37_p3
            OPEN nma37_c3
            FETCH nma37_c3 INTO l_nma37
            IF NOT cl_null(g_nnw.nnw01) THEN
               IF g_nmy.nmydmy6 = 'Y' THEN
                  IF l_nma37 = '0' THEN
                     CALL cl_err(g_nnw.nnw21,'anm-991',1)
                     NEXT FIELD nnw21
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_nnw.nnw06) THEN
               #LET g_sql = "SELECT nma37 FROM ",g_dbs_out,"nma_file",
               LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                           " WHERE nma01 = '",g_nnw.nnw06,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
               PREPARE nma37_p4 FROM g_sql
               DECLARE nma37_c4 CURSOR FOR nma37_p4
               OPEN nma37_c4
               FETCH nma37_c4 INTO l_nma37_2
               IF l_nma37 <> l_nma37_2 THEN
                  CALL cl_err(g_nnw.nnw21,'anm-990',1)
                  NEXT FIELD nnw21
               END IF
            END IF
 
        AFTER FIELD nnw22 #撥入異動碼
            IF NOT cl_null(g_nnw.nnw22) THEN
                #CALL t930_nmc01(p_cmd,'2',g_dbs_in,g_nnw.nnw22,'1') #MOD-640250
                CALL t930_nmc01(p_cmd,'2',g_plant_in,g_nnw.nnw22,'1')  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw22,g_errno,1)
                    LET g_nnw.nnw22 = g_nnw_t.nnw22
                    DISPLAY BY NAME g_nnw.nnw22
                    NEXT FIELD nnw22
                END IF
                IF NOT cl_null(g_nnw.nnw31) THEN
                   LET l_nmc03_1 = NULL
                   LET l_nmc03_2 = NULL
                   #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
                   LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                               " WHERE nmc01 = '",g_nnw.nnw22,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                   PREPARE nmc03_p3 FROM g_sql
                   DECLARE nmc03_c3 CURSOR FOR nmc03_p3
                   OPEN nmc03_c3
                   FETCH nmc03_c3 INTO l_nmc03_1
                   IF cl_null(l_nmc03_1) THEN
                      CALL cl_err(g_nnw.nnw22,'anm-985',1)
                      NEXT FIELD nnw22
                   ELSE
                      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
                      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                                  " WHERE nmc01 = '",g_nnw.nnw22,"'"
 	                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                      CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
                      PREPARE nmc03_p4 FROM g_sql
                      DECLARE nmc03_c4 CURSOR FOR nmc03_p4
                      OPEN nmc03_c4
                      FETCH nmc03_c4 INTO l_nmc03_2
                      IF l_nmc03_1 <> l_nmc03_2 THEN
                         CALL cl_err(g_nnw.nnw22,'anm-984',1)
                         NEXT FIELD nnw22
                      END IF
                   END IF
                END IF
            END IF
            LET g_nnw_o.nnw22 = g_nnw.nnw22
 
        AFTER FIELD nnw24  #匯率
            IF NOT cl_null(g_nnw.nnw24) THEN
                IF g_nnw.nnw24 <=0 THEN
                    NEXT FIELD nnw24
                END IF
                IF g_nnw.nnw23 = g_aza17_in AND g_nnw.nnw24 != 1 THEN
                    NEXT FIELD nnw24
                END IF
                IF g_nnw_o.nnw24 != g_nnw.nnw24 OR cl_null(g_nnw_o.nnw24) THEN
                    IF NOT cl_null(g_nnw.nnw24) AND g_nnw.nnw24 != 0 THEN
                        IF NOT cl_null(g_nnw.nnw25) AND g_nnw.nnw25 != 0 THEN
                            LET g_nnw.nnw26=g_nnw.nnw25 * g_nnw.nnw24
                            CALL cl_digcut(g_nnw.nnw26,g_azi04) RETURNING g_nnw.nnw26  #No.FUN-640142
                            DISPLAY BY NAME g_nnw.nnw26
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnw_o.nnw24 = g_nnw.nnw24
 
        AFTER FIELD nnw26 #撥入本幣金額
            IF NOT cl_null(g_nnw.nnw26) THEN
               CALL cl_digcut(g_nnw.nnw26,g_azi04) RETURNING g_nnw.nnw26  #No.FUN-640142
               DISPLAY BY NAME g_nnw.nnw26
                IF g_nnw.nnw26 < 0 THEN
                    CALL cl_err(g_nnw.nnw26,'aim-391',1)
                    LET g_nnw.nnw26 = g_nnw_o.nnw26
                    DISPLAY BY NAME g_nnw.nnw26
                    NEXT FIELD nnw26
                END IF
            END IF
            LET g_nnw_o.nnw26 = g_nnw.nnw26
        BEFORE FIELD nnw27 #撥入科目
            IF cl_null(g_nnw.nnw27) THEN
                IF g_nnw00='1' THEN
                    LET g_nnw.nnw27 = g_nmq21 #MOD-640288 #改default 集團資金調撥(撥出)科目 
                ELSE
                    LET g_nnw.nnw27 = g_nmq23 #MOD-640288 #改default 集團資金調撥利息(撥出)科目 
                END IF
                DISPLAY BY NAME g_nnw.nnw27
            END IF
        AFTER FIELD nnw27 #撥入科目
            IF NOT cl_null(g_nnw.nnw27) THEN
                CALL t930_aag(g_nnw.nnw27,g_plant_in) RETURNING g_aag02_2    #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw27,g_errno,1)
                    LET g_nnw.nnw27 = g_nnw_t.nnw27
                    DISPLAY BY NAME g_nnw.nnw27
                    NEXT FIELD nnw27
                END IF
                DISPLAY g_aag02_2  TO FORMONLY.aag02_2
            END IF
            LET g_nnw_o.nnw27 = g_nnw.nnw27
 
        BEFORE FIELD nnw271
            IF cl_null(g_nnw.nnw271) THEN
                IF g_nnw00='1' THEN
                    LET g_nnw.nnw271 = g_nmq211
                ELSE
                    LET g_nnw.nnw271 = g_nmq231
                END IF
                DISPLAY BY NAME g_nnw.nnw271
            END IF
        AFTER FIELD nnw271
            IF NOT cl_null(g_nnw.nnw271) THEN
                CALL t930_aag(g_nnw.nnw271,g_plant_in) RETURNING g_aag02_5   #FUN-980020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnw.nnw271,g_errno,1)
                    LET g_nnw.nnw271 = g_nnw_t.nnw271
                    DISPLAY BY NAME g_nnw.nnw271
                    NEXT FIELD nnw271
                END IF
                DISPLAY g_aag02_5  TO FORMONLY.aag02_5
            END IF
            LET g_nnw_o.nnw27 = g_nnw.nnw27
 
        AFTER FIELD nnw10
           IF NOT cl_null(g_nnw.nnw10) THEN
              CALL cl_digcut(g_nnw.nnw10,o_azi04) RETURNING g_nnw.nnw10
              DISPLAY BY NAME g_nnw.nnw10
           END IF   
 
        AFTER FIELD nnw11
           IF NOT cl_null(g_nnw.nnw11) THEN
              CALL cl_digcut(g_nnw.nnw11,g_azi04) RETURNING g_nnw.nnw11
              DISPLAY BY NAME g_nnw.nnw11
           END IF   
 
        AFTER FIELD nnw25
           IF NOT cl_null(g_nnw.nnw25) THEN
              CALL cl_digcut(g_nnw.nnw25,i_azi04) RETURNING g_nnw.nnw25
              DISPLAY BY NAME g_nnw.nnw25
           END IF   
 
        BEFORE FIELD nnw31
           IF cl_null(g_nnw.nnw08) THEN
              CALL cl_err('','anm-989',0)
              NEXT FIELD nnw06
           END IF
 
        AFTER FIELD nnw31
           IF NOT cl_null(g_nnw.nnw31) THEN
              LET g_nma01 = NULL
              LET g_nnw31_nma02 = NULL
              #LET g_sql = "SELECT nma01,nma02 FROM ",g_dbs_out,"nma_file ",
              LET g_sql = "SELECT nma01,nma02 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                          " WHERE nma01 = '",g_nnw.nnw31,"'",
                          "   AND nma10 = '",g_nnw.nnw08,"'",
                          "   AND nma37 = '0'",
                          "   AND nmaacti = 'Y'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
              PREPARE nnw31_p1 FROM g_sql
              DECLARE nnw31_c1 CURSOR FOR nnw31_p1
              OPEN nnw31_c1
              FETCH nnw31_c1 INTO g_nma01,g_nnw31_nma02
              IF cl_null(g_nma01) THEN
                 CALL cl_err(g_nnw.nnw31,'aap-007',1)
                 NEXT FIELD nnw31
              ELSE
                 DISPLAY g_nnw31_nma02 TO FORMONLY.nnw31_nma02
              END IF
           END IF
           LET g_nnw_o.nnw31 = g_nnw.nnw31
 
        BEFORE FIELD nnw32
           IF cl_null(g_nnw.nnw23) THEN
              CALL cl_err('','anm-988',0)
              NEXT FIELD nnw21
           END IF
 
        AFTER FIELD nnw32
           IF NOT cl_null(g_nnw.nnw32) THEN
              LET g_nma01 = NULL
              LET g_nnw32_nma02 = NULL
              #LET g_sql = "SELECT nma01,nma02 FROM ",g_dbs_in,"nma_file ",
              LET g_sql = "SELECT nma01,nma02 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                          " WHERE nma01 = '",g_nnw.nnw32,"'",
                          "   AND nma10 = '",g_nnw.nnw23,"'",
                          "   AND nma37 = '0'",
                          "   AND nmaacti = 'Y'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
              PREPARE nnw32_p1 FROM g_sql
              DECLARE nnw32_c1 CURSOR FOR nnw32_p1
              OPEN nnw32_c1
              FETCH nnw32_c1 INTO g_nma01,g_nnw32_nma02
              IF cl_null(g_nma01) THEN
                 CALL cl_err(g_nnw.nnw32,'aap-007',1)
                 NEXT FIELD nnw32
              ELSE
                 DISPLAY g_nnw32_nma02 TO FORMONLY.nnw32_nma02
              END IF
           END IF
           LET g_nnw_o.nnw32 = g_nnw.nnw32
 
        AFTER FIELD nnwud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnwud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nnw.nnwuser = s_get_data_owner("nnw_file") #FUN-C10039
           LET g_nnw.nnwgrup = s_get_data_group("nnw_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nnw01)
                 LET g_t1 = s_get_doc_no(g_nnw.nnw01)
                 CALL q_nmy(FALSE,TRUE,g_t1,'I',g_sys)
                      RETURNING g_t1 #票據性質:'I':集團調撥還款
                 LET g_nnw.nnw01 = g_t1
                 DISPLAY BY NAME g_nnw.nnw01
                 NEXT FIELD nnw01
               WHEN INFIELD(nnw03) # 部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_nnw.nnw03
                  CALL cl_create_qry() RETURNING g_nnw.nnw03
                  DISPLAY BY NAME g_nnw.nnw03
                  NEXT FIELD nnw03
               WHEN INFIELD(nnw04) #現金變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nnw.nnw04
                  CALL cl_create_qry() RETURNING g_nnw.nnw04
                  DISPLAY BY NAME g_nnw.nnw04
                  CALL t930_nnw04('d')
                  NEXT FIELD nnw04
               #==>撥出*****************************************
               WHEN INFIELD(nnw05) #撥出營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nnw.nnw05
                  CALL cl_create_qry() RETURNING g_nnw.nnw05
                  DISPLAY BY NAME g_nnw.nnw05
                  NEXT FIELD nnw05
               WHEN INFIELD(nnw06) #撥出銀行代號
                  CALL cl_init_qry_var()
                  IF g_nmy.nmydmy6 = 'N' THEN  #No.FUN-690090
                     LET g_qryparam.form = "q_m_nma"
                  ELSE
                     LET g_qryparam.form = "q_m_nma2"
                  END IF
                  LET g_qryparam.default1 = g_nnw.nnw06
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  LET g_qryparam.arg2 = "23"    #No.MOD-640271
                  CALL cl_create_qry() RETURNING g_nnw.nnw06
                  DISPLAY BY NAME g_nnw.nnw06
                  NEXT FIELD nnw06
              WHEN INFIELD(nnw07) #撥出異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnw.nnw07
                  LET g_qryparam.arg1 = '2'
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw07
                  DISPLAY BY NAME g_nnw.nnw07
                  NEXT FIELD nnw07
               WHEN INFIELD(nnw08) #撥出幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnw.nnw08
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw08
                  DISPLAY BY NAME g_nnw.nnw08
                  NEXT FIELD nnw08
               WHEN INFIELD(nnw09) #匯率
                    CALL s_rate(g_nnw.nnw08,g_nnw.nnw09) RETURNING g_nnw.nnw09
                    DISPLAY BY NAME g_nnw.nnw09
                    NEXT FIELD nnw09
               WHEN INFIELD(nnw12) #撥出科目
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnw.nnw12,'23',g_bookno1) #No.FUN-980025 
                       RETURNING g_nnw.nnw12
                  DISPLAY BY NAME g_nnw.nnw12
                  NEXT FIELD nnw12
               WHEN INFIELD(nnw121)
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnw.nnw121,'23',g_bookno2) #No.FUN-980025
                       RETURNING g_nnw.nnw121
                  DISPLAY BY NAME g_nnw.nnw121
                  NEXT FIELD nnw121
               #==>手續費**************************************
               WHEN INFIELD(nnw13) #手續費銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nma"
                  LET g_qryparam.default1 = g_nnw.nnw13
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  LET g_qryparam.arg2 = "23"    #No.MOD-640271
                  CALL cl_create_qry() RETURNING g_nnw.nnw13
                  DISPLAY BY NAME g_nnw.nnw13
                  NEXT FIELD nnw13
              WHEN INFIELD(nnw14) #手續費異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnw.nnw14
                  LET g_qryparam.arg1 = '2'
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw14
                  DISPLAY BY NAME g_nnw.nnw14
                  NEXT FIELD nnw14
               WHEN INFIELD(nnw15) #手續費幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnw.nnw15
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw15
                  DISPLAY BY NAME g_nnw.nnw15
                  NEXT FIELD nnw15
               WHEN INFIELD(nnw16) #匯率
                    CALL s_rate(g_nnw.nnw15,g_nnw.nnw16) RETURNING g_nnw.nnw16
                    DISPLAY BY NAME g_nnw.nnw16
                    NEXT FIELD nnw16
               WHEN INFIELD(nnw19) #手續費科目
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnw.nnw19,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_nnw.nnw19
                  DISPLAY BY NAME g_nnw.nnw19
                  NEXT FIELD nnw19
               WHEN INFIELD(nnw191)
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnw.nnw191,'23',g_bookno2) #No.FUN-980025
                       RETURNING g_nnw.nnw191
                  DISPLAY BY NAME g_nnw.nnw191
                  NEXT FIELD nnw191
               #==>撥入*****************************************
               WHEN INFIELD(nnw20) #撥入營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nnw.nnw20
                  CALL cl_create_qry() RETURNING g_nnw.nnw20
                  DISPLAY BY NAME g_nnw.nnw20
                  NEXT FIELD nnw20
               WHEN INFIELD(nnw21) #撥入銀行代號
                  CALL cl_init_qry_var()
                  IF g_nmy.nmydmy6 = 'N' THEN  #No.FUN-690090
                     LET g_qryparam.form = "q_m_nma"
                  ELSE
                     LET g_qryparam.form = "q_m_nma2"
                  END IF
                  LET g_qryparam.default1 = g_nnw.nnw21
                  LET g_qryparam.plant = g_plant_in   #No.FUN-980025 add 
                  LET g_qryparam.arg2 = "23"    #No.MOD-640271
                  CALL cl_create_qry() RETURNING g_nnw.nnw21
                  DISPLAY BY NAME g_nnw.nnw21
                  NEXT FIELD nnw21
              WHEN INFIELD(nnw22) #撥入異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnw.nnw22
                  LET g_qryparam.arg1 = '1' #MOD-640250
                  LET g_qryparam.plant = g_plant_in   #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw22
                  DISPLAY BY NAME g_nnw.nnw22
                  NEXT FIELD nnw22
               WHEN INFIELD(nnw23) #撥入幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnw.nnw23
                  LET g_qryparam.plant = g_plant_in   #No.FUN-980025 add 
                  CALL cl_create_qry() RETURNING g_nnw.nnw23
                  DISPLAY BY NAME g_nnw.nnw23
                  NEXT FIELD nnw23
               WHEN INFIELD(nnw24) #匯率
                    CALL s_rate(g_nnw.nnw23,g_nnw.nnw24) RETURNING g_nnw.nnw24
                    DISPLAY BY NAME g_nnw.nnw24
                    NEXT FIELD nnw24
               WHEN INFIELD(nnw27) #撥入科目
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_in) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
                  CALL q_m_aag(FALSE,TRUE,g_plant_in,g_nnw.nnw27,'23',g_bookno1) #No.FUN-980025 
                       RETURNING g_nnw.nnw27
                  DISPLAY BY NAME g_nnw.nnw27
                  NEXT FIELD nnw27
               WHEN INFIELD(nnw271)
                   CALL s_get_bookno1(YEAR(g_nnw.nnw02),g_plant_in) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020 
                  CALL q_m_aag(FALSE,TRUE,g_plant_in,g_nnw.nnw271,'23',g_bookno2) #No.FUN-980025  
                       RETURNING g_nnw.nnw271
                  DISPLAY BY NAME g_nnw.nnw271
                  NEXT FIELD nnw271
               WHEN INFIELD(nnw31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.default1 = g_nnw.nnw31
                  LET g_qryparam.plant = g_plant_out  #No.FUN-980025 add 
                  LET g_qryparam.arg2 = g_nnw.nnw08
                  CALL cl_create_qry() RETURNING g_nnw.nnw31
                  DISPLAY BY NAME g_nnw.nnw31
                  NEXT FIELD nnw31
               WHEN INFIELD(nnw32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.default1 = g_nnw.nnw32
                  LET g_qryparam.plant = g_plant_in   #No.FUN-980025 add 
                  LET g_qryparam.arg2 = g_nnw.nnw23
                  CALL cl_create_qry() RETURNING g_nnw.nnw32
                  DISPLAY BY NAME g_nnw.nnw32
                  NEXT FIELD nnw32
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
 
FUNCTION t930_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t930_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
   CALL g_nnx.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t930_count
   FETCH t930_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t930_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)
      INITIALIZE g_nnw.* TO NULL
   ELSE
      CALL t930_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t930_fetch(p_flnnw)
   DEFINE
       p_flnnw         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnnw
      WHEN 'N' FETCH NEXT     t930_cs INTO g_nnw.nnw01
      WHEN 'P' FETCH PREVIOUS t930_cs INTO g_nnw.nnw01
      WHEN 'F' FETCH FIRST    t930_cs INTO g_nnw.nnw01
      WHEN 'L' FETCH LAST     t930_cs INTO g_nnw.nnw01
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
            FETCH ABSOLUTE g_jump t930_cs INTO g_nnw.nnw01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)
      INITIALIZE g_nnw.* TO NULL   #NO.FUN-6B0079  add
      RETURN
   ELSE
      CASE p_flnnw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nnw.* FROM nnw_file       # 重讀DB,因TEMP有不被更新特性
    WHERE nnw01 = g_nnw.nnw01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nnw_file",g_nnw.nnw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
      INITIALIZE g_nnw.* TO NULL   #NO.FUN-6B0079  add
   ELSE
      LET g_data_owner = g_nnw.nnwuser     #No.FUN-4C0063
      LET g_data_group = g_nnw.nnwgrup     #No.FUN-4C0063
      CALL t930_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t930_show()
  DEFINE  l_buf        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
  DEFINE  g_t1         LIKE oay_file.oayslip  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
  DEFINE  li_result    LIKE type_file.num5    #No.FUN-560002  #No.FUN-680107 SMALLINT
 
    LET g_nnw_t.* = g_nnw.*
    DISPLAY BY NAME g_nnw.nnworiu,g_nnw.nnworig,
        g_nnw.nnw01,g_nnw.nnw02,g_nnw.nnw03,g_nnw.nnw04,g_nnw.nnw05,
        g_nnw.nnw06,g_nnw.nnw07,g_nnw.nnw08,g_nnw.nnw09,g_nnw.nnw10,
        g_nnw.nnw11,g_nnw.nnw12,g_nnw.nnw13,g_nnw.nnw14,g_nnw.nnw15,
        g_nnw.nnw16,g_nnw.nnw17,g_nnw.nnw18,g_nnw.nnw19,g_nnw.nnw20,
        g_nnw.nnw21,g_nnw.nnw22,g_nnw.nnw23,g_nnw.nnw24,g_nnw.nnw25,
        g_nnw.nnw26,g_nnw.nnw27,g_nnw.nnw28,g_nnw.nnw29,
        g_nnw.nnw121,g_nnw.nnw191,g_nnw.nnw271,   #No.FUN-680088
        g_nnw.nnw31,g_nnw.nnw32,  #No.FUN-690090
        g_nnw.nnwuser,g_nnw.nnwgrup,g_nnw.nnwmodu,g_nnw.nnwdate,g_nnw.nnwacti,g_nnw.nnwconf
       ,g_nnw.nnwud01,g_nnw.nnwud02,g_nnw.nnwud03,g_nnw.nnwud04,
        g_nnw.nnwud05,g_nnw.nnwud06,g_nnw.nnwud07,g_nnw.nnwud08,
        g_nnw.nnwud09,g_nnw.nnwud10,g_nnw.nnwud11,g_nnw.nnwud12,
        g_nnw.nnwud13,g_nnw.nnwud14,g_nnw.nnwud15 
        LET l_buf = s_get_doc_no(g_nnw.nnw01)
        SELECT nmydesc INTO l_buf FROM nmy_file
         WHERE nmyslip=l_buf
        DISPLAY l_buf TO FORMONLY.nmydesc
        CALL t930_nnw03('d')
        CALL t930_nnw04('d')
 
        CALL t930_plantnam('d','1',g_nnw.nnw05)
        #CALL t930_aza17(g_dbs_out) RETURNING g_aza17_out
        CALL t930_aza17(g_plant_out) RETURNING g_aza17_out  #FUN-A50102
        #CALL t930_nma01('d','1',g_dbs_out,g_nnw.nnw06)
        CALL t930_nma01('d','1',g_plant_out,g_nnw.nnw06)  #FUN-A50102
        #CALL t930_nmc01('d','1',g_dbs_out,g_nnw.nnw07,'2')
        CALL t930_nmc01('d','1',g_plant_out,g_nnw.nnw07,'2') #FUN-A50102
        #CALL t930_azi01('d','1',g_dbs_out,g_nnw.nnw08)
        CALL t930_azi01('d','1',g_plant_out,g_nnw.nnw08)  #FUN-A50102
        CALL t930_aag(g_nnw.nnw12,g_plant_out) RETURNING g_aag02_1   #FUN-980020
        DISPLAY g_aag02_1  TO FORMONLY.aag02_1
        IF g_aza.aza63 = 'Y' THEN
           CALL t930_aag(g_nnw.nnw121,g_plant_out) RETURNING g_aag02_4   #FUN-980020
           DISPLAY g_aag02_4  TO FORMONLY.aag02_4
        END IF
 
        #CALL t930_nma01('d','3',g_dbs_out,g_nnw.nnw13)
        CALL t930_nma01('d','3',g_plant_out,g_nnw.nnw13)  #FUN-A50102
        #CALL t930_nmc01('d','3',g_dbs_out,g_nnw.nnw14,'2')
        CALL t930_nmc01('d','3',g_plant_out,g_nnw.nnw14,'2')  #FUN-A50102
        #CALL t930_azi01('d','3',g_dbs_out,g_nnw.nnw15)  #幣別
        CALL t930_azi01('d','3',g_plant_out,g_nnw.nnw15)  #幣別  #FUN-A50102
        CALL t930_aag(g_nnw.nnw19,g_plant_out) RETURNING g_aag02_3    #FUN-980020
        DISPLAY g_aag02_3  TO FORMONLY.aag02_3
        IF g_aza.aza63 = 'Y' THEN
           CALL t930_aag(g_nnw.nnw191,g_plant_out) RETURNING g_aag02_6 #FUN-980020 
           DISPLAY g_aag02_6  TO FORMONLY.aag02_6
        END IF
 
        CALL t930_plantnam('d','2',g_nnw.nnw20)
        #CALL t930_aza17(g_dbs_in) RETURNING g_aza17_in
        CALL t930_aza17(g_plant_in) RETURNING g_aza17_in  #FUN-A50102
        #CALL t930_nma01('d','2',g_dbs_in,g_nnw.nnw21)
        CALL t930_nma01('d','2',g_plant_in,g_nnw.nnw21)    #FUN-A50102
        #CALL t930_nmc01('d','2',g_dbs_in,g_nnw.nnw22,'1') #MOD-640250
        CALL t930_nmc01('d','2',g_plant_in,g_nnw.nnw22,'1')  #FUN-A50102
        #CALL t930_azi01('d','2',g_dbs_in,g_nnw.nnw23)  #幣別
        CALL t930_azi01('d','2',g_plant_in,g_nnw.nnw23)  #幣別 #FUN-A50102
        CALL t930_aag(g_nnw.nnw27,g_plant_in) RETURNING g_aag02_2  #幣別  #FUN-980020
        DISPLAY g_aag02_2  TO FORMONLY.aag02_2
        IF g_aza.aza63 = 'Y' THEN
           CALL t930_aag(g_nnw.nnw271,g_plant_in) RETURNING g_aag02_5     #FUN-980020
           DISPLAY g_aag02_5  TO FORMONLY.aag02_5
        END IF
        LET g_nnw31_nma02 = NULL
        LET g_nnw32_nma02 = NULL
        #LET g_sql = "SELECT nma02 FROM ",g_dbs_out,"nma_file ",
        LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                    " WHERE nma01 = '",g_nnw.nnw31,"'",
                    "   AND nma37 = '0'",
                    "   AND nmaacti = 'Y'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
        PREPARE nnw31_p2 FROM g_sql
        DECLARE nnw31_c2 CURSOR FOR nnw31_p2
        OPEN nnw31_c2
        FETCH nnw31_c2 INTO g_nnw31_nma02
        DISPLAY g_nnw31_nma02 TO FORMONLY.nnw31_nma02
 
        #LET g_sql = "SELECT nma02 FROM ",g_dbs_in,"nma_file ",
        LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                    " WHERE nma01 = '",g_nnw.nnw32,"'",
                    "   AND nma37 = '0'",
                    "   AND nmaacti = 'Y'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
        PREPARE nnw32_p2 FROM g_sql
        DECLARE nnw32_c2 CURSOR FOR nnw32_p2
        OPEN nnw32_c2
        FETCH nnw32_c2 INTO g_nnw32_nma02
        DISPLAY g_nnw32_nma02 TO FORMONLY.nnw32_nma02
 
        CALL t930_set_entry_a()      
        CALL t930_set_no_entry_a()   
        CALL t930_no_required_a()    
        CALL t930_required_a()       
 
        IF g_nnw.nnwconf = 'X' THEN
           LET g_void = 'Y'
        ELSE
           LET g_void = 'N'
        END IF
        CALL cl_set_field_pic(g_nnw.nnwconf,"","","",g_void,"")
        CALL cl_show_fld_cont()                   
     
        CALL t930_b_fill(' 1=1')
        LET g_t1 = s_get_doc_no(g_nnw.nnw01)       
        CALL s_check_no("anm",g_nnw.nnw01,"","I","","","")
             RETURNING li_result,g_nnw.nnw01
END FUNCTION
 
FUNCTION t930_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nnw.nnw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nnw.* FROM nnw_file WHERE nnw01 = g_nnw.nnw01
   IF g_nnw.nnwconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_nnw.nnwacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nnw.nnw01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t930_cl USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t930_cl INTO g_nnw.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)
       RETURN
   END IF
   LET g_nnw01_t = g_nnw.nnw01
   LET g_nnw_o.*=g_nnw.*
   LET g_nnw_t.*=g_nnw.*
   LET g_nnw.nnwmodu=g_user                     #修改者
   LET g_nnw.nnwdate = g_today                  #修改日期
   CALL t930_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t930_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nnw.*=g_nnw_t.*
         CALL t930_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE nnw_file SET nnw_file.* = g_nnw.*    # 更新DB
       WHERE nnw01 = g_nnw01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","nnw_file",g_nnw01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t930_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nnw.nnw01,'U')
END FUNCTION
 
FUNCTION t930_r()
   DEFINE l_chr   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nnw.nnw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nnw.* FROM nnw_file WHERE nnw01 = g_nnw.nnw01
   IF g_nnw.nnwconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   BEGIN WORK
   OPEN t930_cl USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t930_cl INTO g_nnw.*
   IF SQLCA.sqlcode THEN CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0) RETURN END IF
   CALL t930_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nnw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nnw.nnw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM nnw_file WHERE nnw01 = g_nnw.nnw01
      IF STATUS THEN 
         CALL cl_err3("del","nnw_file",g_nnw.nnw01,"",STATUS,"","del nnw:",1) #FUN-660148
      ROLLBACK WORK RETURN END IF
      DELETE FROM nnx_file WHERE nnx01 = g_nnw.nnw01
      IF STATUS THEN 
         CALL cl_err3("del","nnx_file",g_nnw.nnw01,"",STATUS,"","del nnx:",1) #FUN-660148
      ROLLBACK WORK RETURN END IF
      INITIALIZE g_nnw.* TO NULL
      OPEN t930_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t930_cs
         CLOSE t930_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t930_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t930_cs
         CLOSE t930_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t930_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t930_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t930_fetch('/')
      END IF
   END IF
   CLOSE t930_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nnw.nnw01,'D')
   CLEAR FORM
   CALL g_nnx.clear()
END FUNCTION
 
FUNCTION t930_g_b()
   DEFINE l_nnv            RECORD LIKE nnv_file.*
   DEFINE l_nnx            RECORD LIKE nnx_file.*
   DEFINE tm               RECORD
                           wc LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(600)
                           END RECORD
   DEFINE p_row,p_col      LIKE type_file.num5       #No.FUN-680107 SMALLINT
   DEFINE l_cnt_day        LIKE type_file.num10      #No.FUN-680107 INTEGER #天數 
 
   LET p_row = 1 LET p_col = 6
 
   IF g_nnw.nnw01 IS NULL THEN RETURN END IF
   OPEN WINDOW t9301_w AT p_row,p_col
     WITH FORM "anm/42f/anmt9301"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
     CALL cl_ui_locale("anmt9301")
 
      CONSTRUCT BY NAME tm.wc ON nnv01,nnv02
 
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
 
      END CONSTRUCT
      IF INT_FLAG THEN
         CLOSE WINDOW t9301_w  #No.FUN-680088
         RETURN 
      END IF
 
    LET g_sql = " SELECT nnv_file.*",
                "  FROM nnv_file ",
                "  WHERE nnv05='",g_nnw.nnw20,"'",
                "    AND nnv20='",g_nnw.nnw05,"'",
                "    AND nnv08='",g_nnw.nnw08,"'",
                "    AND nnvacti IN ('Y','y') ",     #No.MOD-910034 
                "    AND ",tm.wc
 
    PREPARE t930_nnv_p FROM g_sql
    DECLARE t930_nnv_c CURSOR FOR t930_nnv_p
 
    BEGIN WORK LET g_success='Y'
    LET l_nnx.nnx07 = 0 
    LET l_nnx.nnx08 = 0 
    LET l_nnx.nnx09 = 0 
    LET l_nnx.nnx10 = 0 
    LET l_nnx.nnx11 = 0 
    LET l_nnx.nnx12 = 0 
    LET l_nnx.nnx18 = 0 
    LET l_nnx.nnx19 = 0 
 
    FOREACH t930_nnv_c INTO l_nnv.*
       IF STATUS THEN CALL cl_err('g_b()foreach',STATUS,1) EXIT FOREACH END IF
       LET l_nnx.nnx01 = g_nnw.nnw01
       IF cl_null(l_nnx.nnx02) OR l_nnx.nnx02 = 0 THEN
           LET l_nnx.nnx02 = 1 
       ELSE
           LET l_nnx.nnx02 = l_nnx.nnx02 + 1
       END IF
       LET l_nnx.nnx03 = l_nnv.nnv01
       LET l_nnx.nnx04 = l_nnv.nnv02
       LET l_nnx.nnx05 = l_nnv.nnv08
       LET l_nnx.nnx06 = l_nnv.nnv24    #MOD-740400
       LET l_nnx.nnx07 = l_nnv.nnv10
       CALL cl_digcut(l_nnx.nnx07,p_azi04) RETURNING l_nnx.nnx07  
       LET l_nnx.nnx08 = l_nnv.nnv11
 
       LET l_nnx.nnx20 = l_nnv.nnv12
       LET l_nnx.nnx21 = l_nnv.nnv27
       IF g_aza.aza63 = 'Y' THEN
          LET l_nnx.nnx201 = l_nnv.nnv121
          LET l_nnx.nnx211 = l_nnv.nnv271
       END IF
       IF g_nnw00 = '1' THEN
           LET l_nnx.nnx09 = l_nnv.nnv29
           LET l_nnx.nnx10 = l_nnv.nnv30
       ELSE
           LET l_nnx.nnx14 = l_nnv.nnv33
           LET l_nnx.nnx15 = l_nnv.nnv28
       END IF
       SELECT azi04 INTO p_azi04 FROM azi_file
        WHERE azi01 = l_nnx.nnx05
       LET l_nnx.nnx11 = l_nnx.nnx07- l_nnx.nnx09
       CALL cl_digcut(l_nnx.nnx11,p_azi04) RETURNING l_nnx.nnx11  
       LET l_nnx.nnx12 = l_nnx.nnx11 * l_nnx.nnx06
       CALL cl_digcut(l_nnx.nnx12,g_azi04) RETURNING l_nnx.nnx12  
       LET l_nnx.nnx13 = l_nnx.nnx08 - l_nnx.nnx10 - l_nnx.nnx12
       CALL cl_digcut(l_nnx.nnx13,g_azi04) RETURNING l_nnx.nnx13  
       LET l_nnx.nnx16 = g_today
       LET l_nnx.nnx17 = g_nnw.nnw02  
       LET l_cnt_day = l_nnx.nnx17 - l_nnx.nnx16 + 1
       LET l_nnx.nnx18 = (l_nnv.nnv25 - l_nnv.nnv29) * (l_nnx.nnx15/100/365) * l_cnt_day
       CALL cl_digcut(l_nnx.nnx18,p_azi04) RETURNING l_nnx.nnx18 
       LET l_nnx.nnx19 = l_nnx.nnx18 * g_nnw.nnw09
       CALL cl_digcut(l_nnx.nnx19,g_azi04) RETURNING l_nnx.nnx19  
 
       LET l_nnx.nnxlegal= g_legal
       INSERT INTO nnx_file VALUES(l_nnx.*)
       IF STATUS THEN
          CALL cl_err3("ins","nnx_file",l_nnx.nnx01,l_nnx.nnx02,STATUS,"","",1)
          LET g_success='N' EXIT FOREACH
       END IF
    END FOREACH
    IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
    CLOSE WINDOW t9301_w
END FUNCTION
 
FUNCTION t930_b()
DEFINE  l_nnw26     LIKE nnw_file.nnw26  #MOD-640448 add
DEFINE
    l_gxf           RECORD LIKE gxf_file.*,
    l_gxh           RECORD LIKE gxh_file.*,
    l_cnt_day       LIKE type_file.num10,   #No.FUN-680107 INTEGER #天數
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否    #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否    #No.FUN-680107 SMALLINT
 
    LET g_action_choice = ""
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_nnw.* FROM nnw_file WHERE nnw01 = g_nnw.nnw01
    IF g_nnw.nnwconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF cl_null(g_nnw.nnw01) THEN RETURN END IF
 
    SELECT COUNT(*) INTO l_n FROM nnx_file WHERE nnx01 = g_nnw.nnw01
    IF l_n = 0 THEN
       IF cl_confirm('aap-701') THEN
          CALL t930_g_b()
          CALL t930_b_fill('1=1')
          CALL t930_bp('G')
       END IF
    END IF
   
    CALL cl_opmsg('b')
 
    CALL t930_lock_cur_b() #LOCK單身的CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nnx WITHOUT DEFAULTS FROM s_nnx.*
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
           OPEN t930_cl USING g_nnw.nnw01                                                                                           
            IF STATUS THEN                                                                                                          
               CALL cl_err("OPEN t930_cl:", STATUS, 1)                                                                              
               CLOSE t930_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
            FETCH t930_cl INTO g_nnw.*            # 鎖住將被更改或取消的資料                                                        
            IF SQLCA.sqlcode THEN                                                                                                   
               CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)      # 資料被他人LOCK                                                       
               CLOSE t930_cl                                                                                                        
               ROLLBACK WORK                                                                                                        
               RETURN                                                                                                               
            END IF                                                                                                                  
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_nnx_t.* = g_nnx[l_ac].*  #BACKUP
              OPEN t930_bcl USING g_nnw.nnw01,g_nnx_t.nnx02
              IF STATUS THEN
                 CALL cl_err("OPEN t930_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE   #No.TQC-960419 
              FETCH t930_bcl INTO g_nnx[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_nnx_t.nnx02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              END IF #No.TQC-960419 
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nnx[l_ac].* TO NULL      #900423
           LET g_nnx[l_ac].nnx11 = 0
           LET g_nnx[l_ac].nnx12 = 0
           LET g_nnx[l_ac].nnx13 = 0
           LET g_nnx[l_ac].nnx18 = 0
           LET g_nnx[l_ac].nnx19 = 0
           LET g_nnx_t.* = g_nnx[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     
           NEXT FIELD nnx02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO nnx_file
                 (nnx01,nnx02,nnx03,nnx04,nnx05,
                  nnx06,nnx07,nnx08,nnx09,nnx10,
                  nnx11,nnx12,nnx13,nnx14,nnx15,nnx16,nnx17,nnx18,nnx19,
                  nnx20,nnx21,nnx201,nnx211 #NO.FUN-640185 #No.FUN-680088 add nnx201,nnx211
                 ,nnxud01,nnxud02,nnxud03, nnxud04,nnxud05,nnxud06,
                  nnxud07,nnxud08,nnxud09, nnxud10,nnxud11,nnxud12,
                  nnxud13,nnxud14,nnxud15,
                  nnxlegal)   #FUN-980005 add legal 
           VALUES(g_nnw.nnw01,g_nnx[l_ac].nnx02,
                  g_nnx[l_ac].nnx03,g_nnx[l_ac].nnx04,
                  g_nnx[l_ac].nnx05,g_nnx[l_ac].nnx06,
                  g_nnx[l_ac].nnx07,g_nnx[l_ac].nnx08,
                  g_nnx[l_ac].nnx09,g_nnx[l_ac].nnx10,
                  g_nnx[l_ac].nnx11,g_nnx[l_ac].nnx12,
                  g_nnx[l_ac].nnx13,g_nnx[l_ac].nnx14,
                  g_nnx[l_ac].nnx15,g_nnx[l_ac].nnx16,
                  g_nnx[l_ac].nnx17,g_nnx[l_ac].nnx18,
                  g_nnx[l_ac].nnx19,
                  g_nnx[l_ac].nnx20,g_nnx[l_ac].nnx21,g_nnx[l_ac].nnx201,g_nnx[l_ac].nnx211 #No.FUN-680088
                 ,g_nnx[l_ac].nnxud01, g_nnx[l_ac].nnxud02,
                  g_nnx[l_ac].nnxud03, g_nnx[l_ac].nnxud04,
                  g_nnx[l_ac].nnxud05, g_nnx[l_ac].nnxud06,
                  g_nnx[l_ac].nnxud07, g_nnx[l_ac].nnxud08,
                  g_nnx[l_ac].nnxud09, g_nnx[l_ac].nnxud10,
                  g_nnx[l_ac].nnxud11, g_nnx[l_ac].nnxud12,
                  g_nnx[l_ac].nnxud13, g_nnx[l_ac].nnxud14,
                  g_nnx[l_ac].nnxud15, g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nnx_file",g_nnw.nnw01,g_nnx[l_ac].nnx02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
           CALL t930_b_tot()
 
        BEFORE FIELD nnx02                        #default 序號
           IF cl_null(g_nnx[l_ac].nnx02) OR g_nnx[l_ac].nnx02 = 0 THEN
              SELECT max(nnx02)+1
                INTO g_nnx[l_ac].nnx02
                FROM nnx_file
               WHERE nnx01 = g_nnw.nnw01
              IF cl_null(g_nnx[l_ac].nnx02) THEN
                 LET g_nnx[l_ac].nnx02 = 1
              END IF
           END IF
 
        AFTER FIELD nnx02                        #check 序號是否重複
           IF NOT cl_null(g_nnx[l_ac].nnx02)  THEN
              IF g_nnx[l_ac].nnx02 != g_nnx_t.nnx02 OR
                 cl_null(g_nnx_t.nnx02) THEN
                 SELECT count(*) INTO l_n
                   FROM nnx_file
                  WHERE nnx01 = g_nnw.nnw01
                    AND nnx02 = g_nnx[l_ac].nnx02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,1)
                    LET g_nnx[l_ac].nnx02 = g_nnx_t.nnx02
                    NEXT FIELD nnx02
                 END IF
              END IF
           END IF
 
        AFTER FIELD nnx03 #調撥單號
            IF NOT cl_null(g_nnx[l_ac].nnx03) THEN
                IF g_nnx_t.nnx03 != g_nnx[l_ac].nnx03 OR cl_null(g_nnx_t.nnx03) THEN
                    LET g_errno = ' '
                    CALL t930_nnv(p_cmd)
                    IF cl_null(g_errno) THEN
                        #單身調撥單號不可重覆!-----------------
                        SELECT COUNT(*) INTO l_n FROM nnx_file
                         WHERE nnx01=g_nnw.nnw01
                           AND nnx03=g_nnx[l_ac].nnx03
                        IF l_n >=1 THEN
                            LET g_errno = 'anm-933'
                        END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnx[l_ac].nnx03,g_errno,1)
                        LET g_nnx[l_ac].nnx03 = g_nnx_t.nnx03
                        DISPLAY BY NAME g_nnx[l_ac].nnx03
                        NEXT FIELD nnx03
                    END IF
                END IF
            END IF
        BEFORE FIELD nnx11
            IF p_cmd = 'a' THEN
                LET g_nnx[l_ac].nnx11 = g_nnx[l_ac].nnx07- g_nnx[l_ac].nnx09
                DISPLAY BY NAME g_nnx[l_ac].nnx11
            END IF
        AFTER FIELD nnx11 #實還原幣金額
            IF NOT cl_null(g_nnx[l_ac].nnx11) THEN
               CALL cl_digcut(g_nnx[l_ac].nnx11,p_azi04) RETURNING g_nnx[l_ac].nnx11  #No.FUN-640142
               DISPLAY BY NAME g_nnx[l_ac].nnx11
                CALL t930_nnx11(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnx[l_ac].nnx11,g_errno,1)
                    LET g_nnx[l_ac].nnx11 = g_nnx_t.nnx11
                    DISPLAY BY NAME g_nnx[l_ac].nnx11
                    NEXT FIELD nnx11
                END IF
                LET g_nnx[l_ac].nnx12 = g_nnx[l_ac].nnx11 * g_nnx[l_ac].nnx06
                CALL cl_digcut(g_nnx[l_ac].nnx12,g_azi04) RETURNING g_nnx[l_ac].nnx12  #No.FUN-640142
                LET g_nnx[l_ac].nnx13 = g_nnx[l_ac].nnx08 - g_nnx[l_ac].nnx10 - g_nnx[l_ac].nnx12
                CALL cl_digcut(g_nnx[l_ac].nnx13,g_azi04) RETURNING g_nnx[l_ac].nnx13  #No.FUN-640142
                DISPLAY BY NAME g_nnx[l_ac].nnx12
                DISPLAY BY NAME g_nnx[l_ac].nnx13
            END IF
        AFTER FIELD nnx15 #還款利率
            IF NOT cl_null(g_nnx[l_ac].nnx15) THEN
                IF g_nnx[l_ac].nnx15 < 0 OR g_nnx[l_ac].nnx15 > 100 THEN
                    #利率需介於0~100
                    CALL cl_err(g_nnx[l_ac].nnx15,'anm-938',1)
                    LET g_nnx[l_ac].nnx15 = g_nnx_t.nnx15
                    DISPLAY BY NAME g_nnx[l_ac].nnx15
                    NEXT FIELD nnx15
                END IF
            END IF
        BEFORE FIELD nnx16 #利息起算日
            IF cl_null(g_nnx[l_ac].nnx16) THEN
                LET g_nnx[l_ac].nnx16 = g_today
                DISPLAY BY NAME g_nnx[l_ac].nnx16
            END IF
        BEFORE FIELD nnx17 #利息止算日
            IF cl_null(g_nnx[l_ac].nnx17) THEN
                LET g_nnx[l_ac].nnx17 = g_nnw.nnw02  #MOD-640354 add
                DISPLAY BY NAME g_nnx[l_ac].nnx17
            END IF
        AFTER FIELD nnx17 #利息止算日
            IF NOT cl_null(g_nnx[l_ac].nnx17) THEN
                IF g_nnx[l_ac].nnx17 < g_nnx[l_ac].nnx16 THEN
                    #止算日不可小於起算日
                    CALL cl_err(g_nnx[l_ac].nnx17,'anm-939',1)
                    LET g_nnx[l_ac].nnx17 = g_nnx_t.nnx17
                    DISPLAY BY NAME g_nnx[l_ac].nnx17
                    NEXT FIELD nnx17
                END IF
            END IF
        BEFORE FIELD nnx18
           IF (g_nnx[l_ac].nnx15 <> g_nnx_t.nnx15 OR cl_null(g_nnx_t.nnx15) ) OR
              (g_nnx[l_ac].nnx16 <> g_nnx_t.nnx16 OR cl_null(g_nnx_t.nnx16) ) OR
              (g_nnx[l_ac].nnx17 <> g_nnx_t.nnx17 OR cl_null(g_nnx_t.nnx17) ) THEN
               LET l_cnt_day = g_nnx[l_ac].nnx17 - g_nnx[l_ac].nnx16 + 1
               LET g_nnx[l_ac].nnx18 = (g_nnv.nnv25 - g_nnv.nnv29) * (g_nnx[l_ac].nnx15/100/365) * l_cnt_day
               CALL cl_digcut(g_nnx[l_ac].nnx18,p_azi04) RETURNING g_nnx[l_ac].nnx18  #No.FUN-640142
               DISPLAY BY NAME g_nnx[l_ac].nnx18
           END IF
        AFTER FIELD nnx18 #實還利息原幣
            IF NOT cl_null(g_nnx[l_ac].nnx18) THEN
               CALL cl_digcut(g_nnx[l_ac].nnx18,p_azi04) RETURNING g_nnx[l_ac].nnx18  #No.FUN-640142
               DISPLAY BY NAME g_nnx[l_ac].nnx18
                IF g_nnx[l_ac].nnx18 <0 THEN
                    CALL cl_err(g_nnx[l_ac].nnx18,'aim-391',1)
                    LET g_nnx[l_ac].nnx18 = g_nnx_t.nnx18
                    DISPLAY BY NAME g_nnx[l_ac].nnx18
                    NEXT FIELD nnx18
                END IF
                LET g_nnx[l_ac].nnx19 = g_nnx[l_ac].nnx18 * g_nnw.nnw09
                CALL cl_digcut(g_nnx[l_ac].nnx19,g_azi04) RETURNING g_nnx[l_ac].nnx19  #No.FUN-640142
                DISPLAY BY NAME g_nnx[l_ac].nnx19
            END IF
 
        AFTER FIELD nnx07
           IF NOT cl_null(g_nnx[l_ac].nnx07) THEN
              CALL cl_digcut(g_nnx[l_ac].nnx07,p_azi04) RETURNING g_nnx[l_ac].nnx07  #No.FUN-640142
              DISPLAY BY NAME g_nnx[l_ac].nnx07
           END IF
 
        AFTER FIELD nnx08
           IF NOT cl_null(g_nnx[l_ac].nnx08) THEN
              CALL cl_digcut(g_nnx[l_ac].nnx08,g_azi04) RETURNING g_nnx[l_ac].nnx08  #No.FUN-640142
              DISPLAY BY NAME g_nnx[l_ac].nnx08
           END IF
 
        AFTER FIELD nnx12
           IF NOT cl_null(g_nnx[l_ac].nnx12) THEN
              CALL cl_digcut(g_nnx[l_ac].nnx12,g_azi04) RETURNING g_nnx[l_ac].nnx12  #No.FUN-640142
              DISPLAY BY NAME g_nnx[l_ac].nnx12
           END IF
 
        AFTER FIELD nnx13
           IF NOT cl_null(g_nnx[l_ac].nnx13) THEN
              CALL cl_digcut(g_nnx[l_ac].nnx13,g_azi04) RETURNING g_nnx[l_ac].nnx13  #No.FUN-640142
              DISPLAY BY NAME g_nnx[l_ac].nnx13
           END IF
 
        AFTER FIELD nnx19
           IF NOT cl_null(g_nnx[l_ac].nnx19) THEN
              CALL cl_digcut(g_nnx[l_ac].nnx19,g_azi04) RETURNING g_nnx[l_ac].nnx19  #No.FUN-640142
              DISPLAY BY NAME g_nnx[l_ac].nnx19
           END IF
 
        AFTER FIELD nnxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_nnx_t.nnx02 > 0 AND g_nnx_t.nnx02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM nnx_file
               WHERE nnx01 = g_nnw.nnw01
                 AND nnx02 = g_nnx_t.nnx02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nnx_file",g_nnw.nnw01,g_nnx_t.nnx02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t930_b_tot()
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nnx[l_ac].* = g_nnx_t.*
              CLOSE t930_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nnx[l_ac].nnx02,-263,1)
              LET g_nnx[l_ac].* = g_nnx_t.*
           ELSE
              UPDATE nnx_file
                 SET nnx02 = g_nnx[l_ac].nnx02,
                     nnx03 = g_nnx[l_ac].nnx03,
                     nnx04 = g_nnx[l_ac].nnx04,
                     nnx05 = g_nnx[l_ac].nnx05,
                     nnx06 = g_nnx[l_ac].nnx06,
                     nnx07 = g_nnx[l_ac].nnx07,
                     nnx08 = g_nnx[l_ac].nnx08,
                     nnx09 = g_nnx[l_ac].nnx09,
                     nnx10 = g_nnx[l_ac].nnx10,
                     nnx11 = g_nnx[l_ac].nnx11,
                     nnx12 = g_nnx[l_ac].nnx12,
                     nnx13 = g_nnx[l_ac].nnx13,
                     nnx14 = g_nnx[l_ac].nnx14,
                     nnx15 = g_nnx[l_ac].nnx15,
                     nnx16 = g_nnx[l_ac].nnx16,
                     nnx17 = g_nnx[l_ac].nnx17,
                     nnx18 = g_nnx[l_ac].nnx18,
                     nnx19 = g_nnx[l_ac].nnx19,
                     nnx20 = g_nnx[l_ac].nnx20,   #NO.FUN-640185
                     nnx21 = g_nnx[l_ac].nnx21,   #NO.FUN-640185
                     nnx201= g_nnx[l_ac].nnx201,  #No.FUN-680088
                     nnx211= g_nnx[l_ac].nnx211   #No.FUN-680088
                    ,nnxud01 = g_nnx[l_ac].nnxud01,
                     nnxud02 = g_nnx[l_ac].nnxud02,
                     nnxud03 = g_nnx[l_ac].nnxud03,
                     nnxud04 = g_nnx[l_ac].nnxud04,
                     nnxud05 = g_nnx[l_ac].nnxud05,
                     nnxud06 = g_nnx[l_ac].nnxud06,
                     nnxud07 = g_nnx[l_ac].nnxud07,
                     nnxud08 = g_nnx[l_ac].nnxud08,
                     nnxud09 = g_nnx[l_ac].nnxud09,
                     nnxud10 = g_nnx[l_ac].nnxud10,
                     nnxud11 = g_nnx[l_ac].nnxud11,
                     nnxud12 = g_nnx[l_ac].nnxud12,
                     nnxud13 = g_nnx[l_ac].nnxud13,
                     nnxud14 = g_nnx[l_ac].nnxud14,
                     nnxud15 = g_nnx[l_ac].nnxud15
               WHERE nnx01=g_nnw.nnw01 
                 AND nnx02=g_nnx_t.nnx02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nnx_file",g_nnw.nnw01,g_nnx_t.nnx02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 LET g_nnx[l_ac].* = g_nnx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
           CALL t930_b_tot()
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_nnx[l_ac].* = g_nnx_t.*
               END IF
               CLOSE t930_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t930_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(nnx02) AND l_ac > 1 THEN
              LET g_nnx[l_ac].* = g_nnx[l_ac-1].*
              SELECT max(nnx02)+1
                INTO g_nnx[l_ac].nnx02
                FROM nnx_file
               WHERE nnx01 = g_nnw.nnw01
              IF cl_null(g_nnx[l_ac].nnx02) THEN
                 LET g_nnx[l_ac].nnx02 = 1
              END IF
              NEXT FIELD nnx02
           END IF
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nnx03) #調撥單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnv02"
                  LET g_qryparam.default1 = g_nnx[l_ac].nnx03
                  LET g_qryparam.arg1     = g_nnw.nnw20
                  LET g_qryparam.arg2     = g_nnw.nnw05
                  LET g_qryparam.arg3     = g_nnw.nnw08
                  IF g_nnw00 = '1' THEN
                      LET g_qryparam.where    = ' (nnv25-nnv29 > 0) ' #未償還金額 >0
                  END IF
                  CALL cl_create_qry() RETURNING g_nnx[l_ac].nnx03
                  DISPLAY BY NAME g_nnx[l_ac].nnx03
                  CALL t930_nnv(p_cmd)
                  NEXT FIELD nnx03
               OTHERWISE EXIT CASE
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
    CALL t930_b_tot()
    CLOSE t930_bcl
    COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t930_b_tot()
   DEFINE l_nnx11_sum LIKE nnx_file.nnx11 #實還原幣金額
   DEFINE l_nnx12_sum LIKE nnx_file.nnx12 #實還本幣金額
   DEFINE l_nnx18_sum LIKE nnx_file.nnx18 
   DEFINE l_nnx19_sum LIKE nnx_file.nnx19
   DEFINE l_nnw10     LIKE nnw_file.nnw10
   DEFINE l_nnw11     LIKE nnw_file.nnw11
   DEFINE l_nnw25     LIKE nnw_file.nnw25
 
   SELECT SUM(nnx11),SUM(nnx12),SUM(nnx18),SUM(nnx19)
     INTO l_nnx11_sum,l_nnx12_sum,l_nnx18_sum,l_nnx19_sum
     FROM nnx_file
    WHERE nnx01 = g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err3("sel","nnx_file",g_nnw.nnw01,"",STATUS,"","sel sum(nnx):",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   IF cl_null(l_nnx11_sum) THEN 
       LET l_nnx11_sum = 0 
   END IF
   IF cl_null(l_nnx12_sum) THEN 
       LET l_nnx12_sum = 0 
   END IF
   IF cl_null(l_nnx18_sum) THEN 
       LET l_nnx18_sum = 0 
   END IF
   IF cl_null(l_nnx19_sum) THEN 
       LET l_nnx19_sum = 0 
   END IF
   IF g_nnw00 = '1' THEN 
       #還本
       LET l_nnw10 = l_nnx11_sum               #撥出原幣
       LET l_nnw11 = l_nnx12_sum               #撥出本幣
       LET l_nnw25 = l_nnx11_sum               #撥入原幣
   ELSE
       #還息
       LET l_nnw10 = l_nnx18_sum                 #撥出原幣   
       LET l_nnw11 = l_nnx19_sum                 #撥出本幣
       LET l_nnw25 = l_nnx18_sum                 #撥入原幣
   END IF
   CALL cl_digcut(l_nnw10,p_azi04) RETURNING l_nnw10  #No.FUN-640142
   CALL cl_digcut(l_nnw11,g_azi04) RETURNING l_nnw11  #No.FUN-640142
   CALL cl_digcut(l_nnw25,p_azi04) RETURNING l_nnw25  #No.FUN-640142
   UPDATE nnw_file 
      SET nnw10 = l_nnw10, #撥出原幣   
          nnw11 = l_nnw11, #撥出本幣
          nnw25 = l_nnw25, #撥入原幣
          nnw26 = l_nnw25 * g_nnw.nnw24 #撥入本幣=撥入原幣*匯率
    WHERE nnw01=g_nnw.nnw01
 
   SELECT nnw10,nnw11,nnw25,nnw26
     INTO g_nnw.nnw10,g_nnw.nnw11,g_nnw.nnw25,g_nnw.nnw26
     FROM nnw_file
    WHERE nnw01=g_nnw.nnw01
   DISPLAY BY NAME g_nnw.nnw10,g_nnw.nnw11,g_nnw.nnw25,g_nnw.nnw26
 
END FUNCTION
 
 
FUNCTION t930_b_fill(p_wc2)                #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(200)
   l_date          LIKE type_file.dat      #No.FUN-680107 DATE
 
   LET g_sql = "SELECT nnx02,nnx03,nnx04,nnx05,nnx06,nnx07,nnx08, ",
               "       nnx09,nnx10,nnx11,nnx12,nnx13, ",      #anmt930用
               "       nnx14,nnx15,nnx16,nnx17,nnx18,nnx19 ", #anmt940用
               "      ,nnx20,nnx201,nnx21,nnx211 ",    #NO.FUN-640185 #No.FUN-680088
               ",nnxud01,nnxud02,nnxud03,nnxud04,nnxud05,",
               "nnxud06,nnxud07,nnxud08,nnxud09,nnxud10,",
               "nnxud11,nnxud12,nnxud13,nnxud14,nnxud15", 
               "  FROM nnx_file,nnw_file ",
               " WHERE nnx01 ='",g_nnw.nnw01,"'",
               "   AND ",p_wc2 CLIPPED,                     #單身
               "   AND nnw01 = nnx01 ",
               "   AND nnw00 = '",g_nnw00,"'",
               " ORDER BY 1"
   PREPARE t930_pb FROM g_sql
   DECLARE nnx_curs CURSOR FOR t930_pb
 
   CALL g_nnx.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH nnx_curs INTO g_nnx[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_nnx.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t930_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_act_visible("maintain_entry_sheet_out_2,maintain_entry_sheet_in_2", FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnx TO s_nnx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
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
         CALL t930_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t930_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t930_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t930_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t930_fetch('L')
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
         CALL t930_def_form()   
         IF g_nnw.nnwconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nnw.nnwconf,"","","",g_void,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #分錄底稿產生
      ON ACTION gen_entry_sheet
          LET g_action_choice="gen_entry_sheet"
          EXIT DISPLAY
 
      #撥出分錄底稿維護
      ON ACTION maintain_entry_sheet_out
          LET g_action_choice="maintain_entry_sheet_out"
          EXIT DISPLAY
 
      #No.FUN-680088 --start--
      ON ACTION maintain_entry_sheet_out_2
          LET g_action_choice="maintain_entry_sheet_out_2"
          EXIT DISPLAY
      #No.FUN-680088 --end--
 
      #撥入分錄底稿維護
      ON ACTION maintain_entry_sheet_in
          LET g_action_choice="maintain_entry_sheet_in"
          EXIT DISPLAY
 
      ON ACTION maintain_entry_sheet_in_2
          LET g_action_choice="maintain_entry_sheet_in_2"
          EXIT DISPLAY
 
      #作廢
      ON ACTION void
          LET g_action_choice="void"
          EXIT DISPLAY
 
      #確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
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
         LET INT_FLAG=FALSE          #MOD-570244 mars
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
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t930_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nnw01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t930_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nnw01",FALSE)
    END IF
 
END FUNCTION
 
#欄位正確性的檢查#begin------------------------------------------------------------
FUNCTION t930_plantnam(p_cmd,p_code,p_plant)
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
          p_plant   LIKE nnw_file.nnw05,
          l_azp01   LIKE azp_file.azp01,
          l_azp02   LIKE azp_file.azp02,
          l_azp03   LIKE azp_file.azp03
 
   LET g_errno = ' '
 
   SELECT azp01,azp02,azp03 INTO l_azp01,l_azp02,l_azp03  FROM azp_file
    WHERE azp01 = p_plant
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                           LET l_azp02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(l_azp03) THEN RETURN END IF   #No.TQC-9B0171 add 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE p_code
         WHEN '1' #撥出
            DISPLAY l_azp02 TO FORMONLY.azp02_1
            LET g_azp01_out = l_azp01
            LET g_azp03_out = l_azp03
            LET g_plant_out = l_azp01        #FUN-980020
            LET g_dbs_out = s_dbstring(l_azp03) CLIPPED
         WHEN '2' #撥入
            DISPLAY l_azp02 TO FORMONLY.azp02_2
            LET g_azp01_in = l_azp01
            LET g_azp03_in = l_azp03
            LET g_plant_in = l_azp01         #FUN-980020
            LET g_dbs_in = s_dbstring(l_azp03) CLIPPED
         WHEN '3' #現在
            LET g_azp01_curr = l_azp01
            LET g_azp03_curr = l_azp03
            LET g_plant_curr = l_azp01      #FUN-980020
            LET g_dbs_curr = s_dbstring(l_azp03) CLIPPED
      END CASE
   END IF
 
END FUNCTION
 
#FUNCTION t930_nma01(p_cmd,p_code,p_dbs,p_nma01)  #銀行代號
FUNCTION t930_nma01(p_cmd,p_code,l_plant,p_nma01) #FUN-A50102
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
          p_nma01   LIKE nma_file.nma01,
          #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
          l_plant   LIKE type_file.chr21,    #FUN-A50102
          l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
          l_nma02   LIKE nma_file.nma02,
          l_nma05   LIKE nma_file.nma05,
          l_nma10   LIKE nma_file.nma10,
          l_nma28   LIKE nma_file.nma28,
          l_nmaacti LIKE nma_file.nmaacti
 
   LET g_errno = ' '
   LET l_sql=
             #"SELECT nma02,nma05,nma10,nmaacti,nma28 FROM ",p_dbs CLIPPED,"nma_file",
             "SELECT nma02,nma05,nma10,nmaacti,nma28 FROM ",cl_get_target_table(l_plant,'nma_file'), #FUN-A50102
             " WHERE nma01 = '",p_nma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE nma_pre FROM l_sql
   DECLARE nma_cur CURSOR FOR nma_pre
   OPEN nma_cur
   FETCH nma_cur INTO l_nma02,l_nma05,l_nma10,l_nmaacti,l_nma28
   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'anm-013'
                           LET l_nma02 = NULL
                           LET l_nma28 = NULL
        WHEN l_nmaacti='N' LET g_errno = '9028'
        WHEN l_nma28 = "1" LET g_errno = "aap-804"  #No.MOD-640330 add#該銀行存款種類有誤
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
       CASE p_code
           WHEN '1' #撥出銀行
                 IF p_cmd <> 'd' THEN
                     LET g_nnw.nnw08 = l_nma10   #幣別
                     IF g_nnw.nnw08 = g_aza17_out THEN
                        CALL cl_set_comp_entry("nnw09",FALSE)
                        LET g_nnw.nnw09 = 1
                     ELSE
                        CALL cl_set_comp_entry("nnw09",TRUE)
                        CALL s_currm(g_nnw.nnw08,g_nnw.nnw02,'S',g_plant_out)  #FUN-980020
                             RETURNING g_nnw.nnw09
                     END IF
                     DISPLAY BY NAME g_nnw.nnw08,g_nnw.nnw09
                 END IF
                 SELECT azi04 INTO o_azi04 FROM azi_file
                  WHERE azi01 = g_nnw.nnw08
                 DISPLAY l_nma02 TO FORMONLY.nma02_1
           WHEN '2' #撥入銀行
                 IF p_cmd <> 'd' THEN
                     LET g_nnw.nnw23 = l_nma10   #幣別
                     IF g_nnw.nnw23 = g_aza17_in THEN
                        CALL cl_set_comp_entry("nnw24",FALSE)
                        LET g_nnw.nnw24 = 1
                     ELSE
                        CALL cl_set_comp_entry("nnw24",TRUE)
                        CALL s_currm(g_nnw.nnw15,g_nnw.nnw02,'S',g_plant_out) #FUN-980020
                             RETURNING g_nnw.nnw24
                     END IF
                     DISPLAY BY NAME g_nnw.nnw23,g_nnw.nnw24
                 END IF
                 SELECT azi04 INTO i_azi04 FROM azi_file
                  WHERE azi01 = g_nnw.nnw23
                 DISPLAY l_nma02 TO FORMONLY.nma02_2
           WHEN '3' #手續費銀行
                 IF p_cmd <> 'd' THEN
                     LET g_nnw.nnw15 = l_nma10   #幣別
                     IF g_nnw.nnw15 = g_aza17_out THEN
                        CALL cl_set_comp_entry("nnw16",FALSE)
                        LET g_nnw.nnw16 = 1
                     ELSE
                        CALL cl_set_comp_entry("nnw16",TRUE)
                        CALL s_currm(g_nnw.nnw15,g_nnw.nnw02,'S',g_plant_out)   #FUN-980020
                             RETURNING g_nnw.nnw16
                     END IF
                     DISPLAY BY NAME g_nnw.nnw15,g_nnw.nnw16
                 END IF
                 SELECT azi04 INTO c_azi04 FROM azi_file
                  WHERE azi01 = g_nnw.nnw15
                 DISPLAY l_nma02 TO FORMONLY.nma02_3
       END CASE
   END IF
 
END FUNCTION
 
#FUNCTION t930_nmc01(p_cmd,p_code,p_dbs,p_nmc01,p_nmc03)  #銀行存提異動碼
FUNCTION t930_nmc01(p_cmd,p_code,l_plant,p_nmc01,p_nmc03)  #FUN-A50102
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
          p_nmc01   LIKE nmc_file.nmc01,
          p_nmc03   LIKE nmc_file.nmc03,    #存提別: 1:存(借)  2:提(貸)
          #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
          l_plant   LIKE type_file.chr21,  #FUN-A50102
          l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
          l_nmc02   LIKE nmc_file.nmc02,
          l_nmc03   LIKE nmc_file.nmc03,
          l_nmcacti LIKE nmc_file.nmcacti
 
   LET g_errno = ' '
 
   #LET l_sql= "SELECT nmc02,nmc03,nmcacti FROM ",p_dbs CLIPPED,"nmc_file",
   LET l_sql= "SELECT nmc02,nmc03,nmcacti FROM ",cl_get_target_table(l_plant,'nmc_file'), #FUN-A50102
              " WHERE nmc01 = '",p_nmc01,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE nmc_pre FROM l_sql
   DECLARE nmc_cur CURSOR FOR nmc_pre
 
   OPEN nmc_cur
   FETCH nmc_cur INTO l_nmc02,l_nmc03,l_nmcacti
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'anm-024' #無此異動碼資料，請重新輸入
         LET l_nmc03 = NULL
         LET l_nmcacti = NULL
      WHEN l_nmc03 <> p_nmc03
         LET g_errno = "anm-019"   #No.MOD-640250 add
      WHEN l_nmcacti = 'N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE p_code
         WHEN '1' #撥出異動碼
            DISPLAY l_nmc02 TO FORMONLY.nmc02_1
         WHEN '2' #撥入異動碼
            DISPLAY l_nmc02 TO FORMONLY.nmc02_2
         WHEN '3' #手續費異動碼
            DISPLAY l_nmc02 TO FORMONLY.nmc02_3
      END CASE
   END IF
 
END FUNCTION
 
#FUNCTION t930_azi01(p_cmd,p_code,p_dbs,p_azi01)  #幣別
FUNCTION t930_azi01(p_cmd,p_code,l_plant,p_azi01) #FUN-A50102
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant   LIKE type_file.chr21,    #FUN-A50102
           p_azi01   LIKE azi_file.azi01,
           l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
           l_aziacti LIKE azi_file.aziacti
 
    LET g_errno = ' '
    LET l_sql=
              #"SELECT aziacti FROM ",p_dbs CLIPPED,"azi_file",
              "SELECT aziacti FROM ",cl_get_target_table(l_plant,'azi_file'), #FUN-A50102
              " WHERE azi01 = '",p_azi01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE azi_pre FROM l_sql
    DECLARE azi_cur CURSOR FOR azi_pre
    OPEN azi_cur
    FETCH azi_cur INTO l_aziacti
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'aap-002' #無此幣別，請重新輸入
                            LET l_aziacti = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
#FUNCTION t930_aza17(p_dbs)  #本幣幣別
FUNCTION t930_aza17(l_plant)  #FUN-A50102
   DEFINE #p_dbs   LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
          l_plant LIKE type_file.chr21,  #FUN-A50102
          l_sql   LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
          l_aza17 LIKE aza_file.aza17
 
   LET g_errno = ' '
 
   #LET l_sql= "SELECT aza17 FROM ",p_dbs CLIPPED,"aza_file",
   LET l_sql= "SELECT aza17 FROM ",cl_get_target_table(l_plant,'aza_file'), #FUN-A50102
              " WHERE aza01 = '0' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE aza_pre FROM l_sql
   DECLARE aza_cur CURSOR FOR aza_pre
 
   OPEN aza_cur
   FETCH aza_cur INTO l_aza17
   CLOSE aza_cur
 
   RETURN l_aza17
 
END FUNCTION
 
FUNCTION t930_aag(p_key,p_plant)             #FUN-980020
   DEFINE l_sql      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
          l_aagacti  LIKE aag_file.aagacti,
          l_aag02    LIKE aag_file.aag02,
          l_aag07    LIKE aag_file.aag07,
          l_aag03    LIKE aag_file.aag03,
          l_aag09    LIKE aag_file.aag09,
          p_key      LIKE aag_file.aag01,
          p_dbs      LIKE type_file.chr21    #No.FUN-680107 VARCHAR(21)
DEFINE  l_flag1      LIKE type_file.chr1     #No.FUN-730032
DEFINE  l_bookno1    LIKE aza_file.aza81     #No.FUN-730032
DEFINE  l_bookno2    LIKE aza_file.aza82     #No.FUN-730032
DEFINE  p_plant      LIKE type_file.chr10    #FUN-980020
 
   IF cl_null(p_plant) THEN
      LET p_dbs = NULL
   ELSE
      LET g_plant_new = p_plant
      CALL s_getdbs()
      LET p_dbs = g_dbs_new
   END IF
 
   CALL s_get_bookno1(YEAR(g_nnw.nnw02),p_plant) RETURNING l_flag1,l_bookno1,l_bookno2  #FUN-980020
   IF l_flag1 = '1' THEN
       LET g_errno = 'aoo-081'
       RETURN ' '
   END IF
 
   LET g_errno = " "
 
   LET l_sql = "SELECT aag02,aagacti,aag07,aag03,aag09",
               #"  FROM ",p_dbs CLIPPED,"aag_file",
               "  FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
               " WHERE aag01 = '",p_key,"'",
               "   AND aag00 = '",l_bookno1,"'"  #No.FUN-730032
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE aag_pre FROM l_sql
   DECLARE aag_cur CURSOR FOR aag_pre
 
   OPEN aag_cur
   FETCH aag_cur INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
 
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
 
FUNCTION t930_nnw03(p_cmd)  #部門代號
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno = ' '
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_nnw.nnw03
 
   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'anm-071'
                           LET l_gem02 = NULL
        WHEN l_gemacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
 
END FUNCTION
 
FUNCTION t930_nnw04(p_cmd) #現金變動碼
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmlacti LIKE nml_file.nmlacti
   DEFINE l_nml02   LIKE nml_file.nml02
 
   SELECT nmlacti,nml02 INTO l_nmlacti,l_nml02 FROM nml_file
    WHERE nml01 = g_nnw.nnw04
 
   LET g_errno = ' '
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_nmlacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   DISPLAY l_nml02 TO nml02
 
END FUNCTION
 
FUNCTION t930_nnv(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_unpaid   LIKE nnv_file.nnv25     #未償還金額
 
   LET g_errno = ' '
 
   SELECT nnv_file.* ,(nnv25-nnv29) 
     INTO g_nnv.*, l_unpaid
     FROM nnv_file
    WHERE nnv01 = g_nnx[l_ac].nnx03
 
   CASE WHEN SQLCA.SQLCODE = 100
                                               LET g_errno = 'anm-071'
        WHEN g_nnv.nnvacti ='N'                LET g_errno = '9028'
        WHEN g_nnv.nnvconf ='N'                LET g_errno = '9029'
        WHEN g_nnv.nnvconf ='X'                LET g_errno = 'aap-165'
        WHEN (l_unpaid <= 0 AND g_nnw00 = '1') LET g_errno = 'anm-930' #此筆帳款已全部償還完畢!
        WHEN g_nnv.nnv20 <> g_nnw.nnw05        LET g_errno = 'anm-934' #原調撥單號的撥入營運中心和還本單頭的還款營運中心不同,需選擇相同的營運中心!
        WHEN g_nnv.nnv05 <> g_nnw.nnw20        LET g_errno = 'anm-935' #原調撥單號的撥出營運中心和還本單頭的撥入營運中心不同,需選擇相同的營運中心!
        WHEN g_nnv.nnv08 <> g_nnw.nnw08        LET g_errno = 'anm-932' #原調撥單號的撥出幣別和還本單頭的撥出幣別不同,需選擇相同的幣別!
        OTHERWISE                              LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_nnx[l_ac].nnx04 = g_nnv.nnv02
       LET g_nnx[l_ac].nnx05 = g_nnv.nnv08
       LET g_nnx[l_ac].nnx06 = g_nnv.nnv24    #MOD-740400
       LET g_nnx[l_ac].nnx07 = g_nnv.nnv10
       LET g_nnx[l_ac].nnx08 = g_nnv.nnv11
       LET g_nnx[l_ac].nnx20 = g_nnv.nnv12
       LET g_nnx[l_ac].nnx21 = g_nnv.nnv27
       IF g_aza.aza63 = 'Y' THEN
          LET g_nnx[l_ac].nnx201= g_nnv.nnv121
          LET g_nnx[l_ac].nnx211= g_nnv.nnv271
       END IF
       DISPLAY BY NAME g_nnx[l_ac].nnx04
       DISPLAY BY NAME g_nnx[l_ac].nnx05
       DISPLAY BY NAME g_nnx[l_ac].nnx06
       DISPLAY BY NAME g_nnx[l_ac].nnx07
       DISPLAY BY NAME g_nnx[l_ac].nnx08
       DISPLAY BY NAME g_nnx[l_ac].nnx20
       DISPLAY BY NAME g_nnx[l_ac].nnx21
       DISPLAY BY NAME g_nnx[l_ac].nnx201
       DISPLAY BY NAME g_nnx[l_ac].nnx211
       SELECT azi04 INTO p_azi04 FROM azi_file
        WHERE azi01 = g_nnx[l_ac].nnx05
       IF g_nnw00 = '1' THEN
           LET g_nnx[l_ac].nnx09 = g_nnv.nnv29
           LET g_nnx[l_ac].nnx10 = g_nnv.nnv30
           DISPLAY BY NAME g_nnx[l_ac].nnx09
           DISPLAY BY NAME g_nnx[l_ac].nnx10
       ELSE
           LET g_nnx[l_ac].nnx14 = g_nnv.nnv33
           LET g_nnx[l_ac].nnx15 = g_nnv.nnv28
           DISPLAY BY NAME g_nnx[l_ac].nnx14
           DISPLAY BY NAME g_nnx[l_ac].nnx15
       END IF
   END IF
 
END FUNCTION
 
FUNCTION t930_nnx11(p_cmd) #
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_unpaid   LIKE nnv_file.nnv25     #未償還金額
 
   LET l_unpaid = g_nnx[l_ac].nnx07-g_nnx[l_ac].nnx09
 
   LET g_errno = ' '
 
   CASE 
      WHEN g_nnx[l_ac].nnx11 < 0
         LET g_errno = 'aim-391' #輸入值不可小於零!
      WHEN g_nnx[l_ac].nnx11 > l_unpaid
         LET g_errno = 'anm-931' #實還原幣金額不可大於未還金額!
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
#欄位正確性的檢查#end------------------------------------------------------------
 
FUNCTION t930_y() #when g_nnw.nnwconf='N' (Turn to 'Y')
   DEFINE l_t         LIKE nmy_file.nmyslip     #No.FUN-680107 VARCHAR(05)
   DEFINE l_nmydmy3   LIKE nmy_file.nmydmy3
   DEFINE l_n1        LIKE type_file.num5       #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_n2        LIKE type_file.num5       #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_nmc03_1   LIKE nmc_file.nmc03       #No.FUN-690090
   DEFINE l_nmc03_2   LIKE nmc_file.nmc03       #No.FUN-690090
 
   IF g_nnw.nnw01 IS NULL THEN
      CALL cl_err('',-400,0) 
      RETURN
   END IF
 
   SELECT * INTO g_nnw.* FROM nnw_file
    WHERE nnw01 = g_nnw.nnw01
 
   IF g_nnw.nnwconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
 
   IF g_nnw.nnwconf = 'X' THEN 
      CALL cl_err('',9024,0)
      RETURN
   END IF
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(g_nnw.nnw01)
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = l_t              #No.FUN-670060
   IF STATUS OR cl_null(g_nmy.nmydmy3) THEN                             #No.FUN-670060
       LET g_nmy.nmydmy3 = 'N'                                          #No.FUN-670060
   END IF
 
   IF g_nmy.nmydmy6 = 'Y' THEN
      LET l_nmc03_1 = NULL
      LET l_nmc03_2 = NULL
      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",g_nnw.nnw07,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
      PREPARE nmc03_p5 FROM g_sql
      DECLARE nmc03_c5 CURSOR FOR nmc03_p5
      OPEN nmc03_c5
      FETCH nmc03_c5 INTO l_nmc03_1
      IF cl_null(l_nmc03_1) THEN
         CALL cl_err(g_nnw.nnw07,'anm-987',1)
         RETURN
      ELSE
         #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
         LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                     " WHERE nmc01 = '",g_nnw.nnw07,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
         PREPARE nmc03_p6 FROM g_sql
         DECLARE nmc03_c6 CURSOR FOR nmc03_p6
         OPEN nmc03_c6
         FETCH nmc03_c6 INTO l_nmc03_2
         IF l_nmc03_1 <> l_nmc03_2 THEN
            CALL cl_err(g_nnw.nnw07,'anm-986',1)
            RETURN
         END IF
      END IF
      LET l_nmc03_1 = NULL
      LET l_nmc03_2 = NULL
      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",g_nnw.nnw22,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
      PREPARE nmc03_p7 FROM g_sql
      DECLARE nmc03_c7 CURSOR FOR nmc03_p7
      OPEN nmc03_c7
      FETCH nmc03_c7 INTO l_nmc03_1
      IF cl_null(l_nmc03_1) THEN
         CALL cl_err(g_nnw.nnw22,'anm-985',1)
         RETURN
      ELSE
         #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
         LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                     " WHERE nmc01 = '",g_nnw.nnw22,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
         PREPARE nmc03_p8 FROM g_sql
         DECLARE nmc03_c8 CURSOR FOR nmc03_p8
         OPEN nmc03_c8
         FETCH nmc03_c8 INTO l_nmc03_2
         IF l_nmc03_1 <> l_nmc03_2 THEN
            CALL cl_err(g_nnw.nnw22,'anm-984',1)
            RETURN
         END IF
      END IF
   END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr ='N' THEN                   #No.FUN-670060
      #檢查撥出的若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      CALL t930_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069 add g_plant_out
      CALL s_get_bookno(YEAR(g_nnw.nnw02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(g_nnw.nnw02,'aoo-081',1)
         LET g_success='N'
         RETURN
      END IF
      CALL s_chknpq(g_nnw.nnw01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'#No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_nnw.nnw01,'NM',9,'1',g_bookno2)  #No.FUN-730032
      END IF
      IF g_success ='N' THEN RETURN END IF
      CALL t930_chgdbs(g_azp03_curr,g_plant_curr)    #FUN-990069 add g_plant_curr
      CALL t930_lock_cur_a()
      CALL t930_lock_cur_b()
 
      CALL t930_fetch_cur() 
      OPEN t930_cs          
      FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
 
      IF g_success = 'Y' THEN
         #檢查撥入的若單別須拋轉總帳, 檢查分錄底稿平衡正確否
         CALL t930_chgdbs(g_azp03_in,g_plant_in)    #FUN-990069 add g_plant_in
         CALL s_get_bookno(YEAR(g_nnw.nnw02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(g_nnw.nnw02,'aoo-081',1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_chknpq(g_nnw.nnw01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0' #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnw.nnw01,'NM',9,'1',g_bookno2) #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
         CALL t930_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069 add g_plant_curr
         CALL t930_lock_cur_a()
         CALL t930_lock_cur_b()
 
         CALL t930_fetch_cur() 
         OPEN t930_cs          
         FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
      END IF
   END IF
 
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success ='Y'          #FUN-8A0086
   CALL s_showmsg_init()                       #No.FUN-710024
   OPEN t930_cl USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      LET g_success ='N'          #FUN-8A0086
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t930_cl INTO g_nnw.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t930_cl
      LET g_success ='N'          #FUN-8A0086
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                           
      CALL t930_chgdbs(g_azp03_in,g_plant_in)  #FUN-990069  add g_plant_in
      IF g_nnw00 = '1' THEN
         SELECT COUNT(*) INTO l_n1 FROM npq_file                                                                                     
          WHERE npqsys= 'NM'                                                                                                        
            AND npq00=22                                                                                                            
            AND npq01 = g_nnw.nnw01                                                                                                 
            AND npq011=9                                                                                                            
      ELSE
         SELECT COUNT(*) INTO l_n1 FROM npq_file                                                                                     
          WHERE npqsys= 'NM'                                                                                                        
            AND npq00=23                                                                                                            
            AND npq01 = g_nnw.nnw01                                                                                                 
            AND npq011=9                                                                                                            
      END IF
      IF l_n1 = 0 THEN                                                                                                            
         CALL t930_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
         CALL t930_g_gl(g_nnw.nnw01,'2',g_dbs_in,'0',g_azp01_in) #撥入 #No.FUN-680088 add '0'
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL t930_g_gl(g_nnw.nnw01,'2',g_dbs_in,'1',g_azp01_in)
         END IF
         CALL t930_chgdbs(g_azp03_in,g_plant_in) #FUN-990069 add g_plant_in
      END IF                                                                                                                     
      IF g_success = 'Y' THEN                                                                                                    
         CALL s_get_bookno(YEAR(g_nnw.nnw02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(g_nnw.nnw02,'aoo-081',1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_chknpq(g_nnw.nnw01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'  #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnw.nnw01,'NM',9,'1',g_bookno2)  #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF                                                                                                                     
      CALL t930_chgdbs(g_azp03_curr,g_plant_curr)   #FUN-990069   add g_plant_curr
      CALL t930_lock_cur_a()
      CALL t930_lock_cur_b()
      CALL t930_fetch_cur() 
      OPEN t930_cs          
      FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
 
      CALL t930_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
      IF g_nnw00 = '1' THEN
         SELECT COUNT(*) INTO l_n2 FROM npq_file                                                                                     
          WHERE npqsys= 'NM'                                                                                                        
            AND npq00=22                                                                                                            
            AND npq01 = g_nnw.nnw01                                                                                                 
            AND npq011=9                                                                                                            
      ELSE
         SELECT COUNT(*) INTO l_n2 FROM npq_file                                                                                     
          WHERE npqsys= 'NM'                                                                                                        
            AND npq00=23                                                                                                            
            AND npq01 = g_nnw.nnw01                                                                                                 
            AND npq011=9                                                                                                            
      END IF
      IF l_n2 = 0 THEN                                                                                                            
         CALL t930_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr  
         CALL t930_g_gl(g_nnw.nnw01,'1',g_dbs_out,'0',g_azp01_out) #撥出  #No.FUN-680088 add '0'
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL t930_g_gl(g_nnw.nnw01,'1',g_dbs_out,'1',g_azp01_out)
         END IF
         CALL t930_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
      END IF                                                                                                                     
      IF g_success = 'Y' THEN                                                                                                    
         CALL s_get_bookno(YEAR(g_nnw.nnw02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(g_nnw.nnw02,'aoo-081',1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_chknpq(g_nnw.nnw01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'  #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnw.nnw01,'NM',9,'1',g_bookno2)  #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF                                                                                                                     
      CALL t930_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
      CALL t930_lock_cur_a()
      CALL t930_lock_cur_b()
      CALL t930_fetch_cur() 
      OPEN t930_cs          
      FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
   END IF                                                                                                                        
   IF g_success = 'N' THEN 
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL t930_ins_nme('1',g_dbs_out,g_azp01_out) #撥出營運中心insert into 一筆nme_file銀行異動資料
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t930_ins_nme('2',g_dbs_in,g_azp01_in)  #撥入營運中心insert into 一筆nme_file銀行異動資料  #TQC-9B0185
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
 
   IF NOT cl_null(g_nnw.nnw13) THEN #MOD-640344 add if 判斷----------
      CALL t930_ins_nme('3',g_dbs_out,g_azp01_out) #撥出營運中心insert into 一筆nme_file銀行異動資料 for 手續費
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF g_nmy.nmydmy6 = 'Y' THEN
      CALL t930_ins_nme('4',g_dbs_out,g_azp01_out)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
      CALL t930_ins_nme('5',g_dbs_in,g_azp01_in)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      UPDATE nnw_file SET nnwconf = 'Y'
       WHERE nnw01 = g_nnw.nnw01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg("nnw01",g_nnw.nnw01,"UPD mmw_file",SQLCA.sqlcode,1)             #No.FUN-710024
         LET g_success ='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      CALL t930_upd_nnv('Y') #每筆單身update nnv_file
                             #           set nnv29(已還原幣)=nnv29+nnx11
                             #               nnv30(已還本幣)=nnv30+nnx12
   END IF
   CALL s_showmsg()                          #No.FUN-710024
   IF g_success = 'Y' THEN
      CALL cl_flow_notify(g_nnw.nnw01,'Y')
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN                                                          
      LET g_wc_gl = 'nnv01 = "',g_nnw.nnw01,'" AND nnv02 = "',g_nnw.nnw02,'"'                                                                      
      IF g_nnw00 = '1' THEN
         LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '2' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'" #No.FUN-680088#FUN-860040
      ELSE
         LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '3' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'" #No.FUN-680088#FUN-860040
      END IF
      CALL cl_cmdrun_wait(g_str)                                                                                                    
   END IF                                                                                                                           
   SELECT * INTO g_nnw.* FROM nnw_file
    WHERE nnw01 = g_nnw.nnw01
 
   CALL t930_show()
 
END FUNCTION
 
FUNCTION t930_ins_nme(p_code,p_dbs,p_azp01)
   DEFINE p_code   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #1:撥出, 2:撥入 , 3:手續費  4:撥出內部  5:撥入內部
   DEFINE p_dbs    LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
          l_sql    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
   DEFINE p_azp01  LIKE azp_file.azp01    #FUN-980005 
   DEFINE l_legal  LIKE nme_file.nmelegal #FUN-980005 

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"nme_file",
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_azp01,'nme_file'), #FUN-A50102
               " (nme00   , ",
               "  nme01   , ",
               "  nme02   , ",
               "  nme021  , ",
               "  nme03   , ",
               "  nme04   , ",
               "  nme05   , ",
               "  nme06   , ",
               "  nme07   , ",
               "  nme08   , ",
               "  nme09   , ",
               "  nme10   , ",
               "  nme11   , ",
               "  nme12   , ",
               "  nme13   , ",
               "  nme14   , ",
               "  nme15   , ",
               "  nme16   , ",
               "  nme17   , ",
               "  nme18   , ",
               "  nme19   , ",
               "  nme20   , ",
               "  nmeacti , ",
               "  nmeuser , ",
               "  nmegrup , ",
               "  nmemodu , ",
               "  nmedate , ",
               "  nme061, ",  #No.FUN-680088
               "  nme21, ",   #FUN-730032
               "  nme22, ",   #FUN-730032
               "  nme23, ",   #FUN-730032
               "  nme24, ",   #FUN-730032
               "  nme25, ",   #FUN-730032
               "  nme27, ",   #FUN-B30166
               "  nmeoriu, ",  #TQC-A10060  add
               "  nmeorig, ",  #TQC-A10060  add
               "  nmelegal) ",  #FUN-980005 #TQC-9B0182
               "   VALUES(?,?,?,?,?,?,?,?,?,?, ",
               "          ?,?,?,?,?,?,?,?,?,?, ",
               "          ?,?,?,?,?,?,?,?,?,?,?,?,?, ",     #No.FUN-680088 add ? #FUN-730032
#              "          ?,?,?)"    #FUN-980005  ##TQC-A10060  add ?,?      #FUN-B30166 Mark
               "          ?,?,?,?)"  #FUN-B30166
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
   PREPARE nme_ins_pre FROM l_sql
 
   INITIALIZE g_nme.* TO NULL
   LET g_nme.nme00  = 0
   LET g_nme.nme02  = g_nnw.nnw02
   LET g_nme.nme12  = g_nnw.nnw01
   LET g_nme.nme14  = g_nnw.nnw04
   LET g_nme.nme15  = g_nnw.nnw03
   LET g_nme.nme16  = g_nnw.nnw02
   LET g_nme.nme20  = 'N'
   LET g_nme.nmeacti = 'Y'
   LET g_nme.nmeuser = g_user
   LET g_nme.nmegrup = g_grup               #使用者所屬群
   LET g_nme.nmedate = g_today
 
   CASE p_code
      WHEN '1' #撥出
         LET g_nme.nme01  = g_nnw.nnw06
         LET g_nme.nme03  = g_nnw.nnw07
         LET g_nme.nme04  = g_nnw.nnw10
         LET g_nme.nme06  = g_nnw.nnw12
         IF g_aza.aza63 = 'Y' THEN
            LET g_nme.nme061  = g_nnw.nnw121
         END IF
         LET g_nme.nme07  = g_nnw.nnw09
         LET g_nme.nme08  = g_nnw.nnw11
         LET g_nme.nme13  = g_nnw.nnw20
      WHEN '2' #撥入
         LET g_nme.nme01  = g_nnw.nnw21
         LET g_nme.nme03  = g_nnw.nnw22
         LET g_nme.nme04  = g_nnw.nnw25
         LET g_nme.nme06  = g_nnw.nnw27
         IF g_aza.aza63 = 'Y' THEN
            LET g_nme.nme061  = g_nnw.nnw271
         END IF
         LET g_nme.nme07  = g_nnw.nnw24
         LET g_nme.nme08  = g_nnw.nnw26
         LET g_nme.nme13  = g_nnw.nnw05
      WHEN '3' #手續費
         LET g_nme.nme01  = g_nnw.nnw13
         LET g_nme.nme03  = g_nnw.nnw14
         LET g_nme.nme04  = g_nnw.nnw17
         LET g_nme.nme06  = g_nnw.nnw19
         IF g_aza.aza63 = 'Y' THEN
            LET g_nme.nme061  = g_nnw.nnw191
         END IF
         LET g_nme.nme07  = g_nnw.nnw16
         LET g_nme.nme08  = g_nnw.nnw18
         LET g_nme.nme13  = g_nnw.nnw20
      WHEN '4' 
           LET g_nme.nme01  = g_nnw.nnw31
           LET g_nme.nme03  = g_nnw.nnw22
           LET g_nme.nme04  = g_nnw.nnw10
           LET g_nme.nme06  = g_nnw.nnw12
           IF g_aza.aza63 = 'Y' THEN
              LET g_nme.nme061  = g_nnw.nnw121
           END IF
           LET g_nme.nme07  = g_nnw.nnw09
           LET g_nme.nme08  = g_nnw.nnw11
           LET g_nme.nme13  = g_nnw.nnw20
      WHEN '5' 
           LET g_nme.nme01  = g_nnw.nnw32
           LET g_nme.nme03  = g_nnw.nnw07
           LET g_nme.nme04  = g_nnw.nnw25
           LET g_nme.nme06  = g_nnw.nnw27
           IF g_aza.aza63 = 'Y' THEN
              LET g_nme.nme061  = g_nnw.nnw271
           END IF
           LET g_nme.nme07  = g_nnw.nnw24
           LET g_nme.nme08  = g_nnw.nnw26
           LET g_nme.nme13  = g_nnw.nnw05
   END CASE
 
   LET g_nme.nme21 = 1
   LET g_nme.nme22 = '06'
   LET g_nme.nme23 = '01'
   LET g_nme.nme24 = '9'
   LET g_nme.nme25 = g_nme.nme13
   CALL s_getlegal(p_azp01) RETURNING l_legal  
   LET g_nme.nmelegal = l_legal
   LET g_nme.nmeoriu = g_user  #TQC-A10060  add
   LET g_nme.nmeorig = g_grup  #TQC-A10060  add 
 
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

   EXECUTE nme_ins_pre USING
             g_nme.nme00   ,
             g_nme.nme01   ,
             g_nme.nme02   ,
             g_nme.nme021  ,
             g_nme.nme03   ,
             g_nme.nme04   ,
             g_nme.nme05   ,
             g_nme.nme06   ,
             g_nme.nme07   ,
             g_nme.nme08   ,
             g_nme.nme09   ,
             g_nme.nme10   ,
             g_nme.nme11   ,
             g_nme.nme12   ,
             g_nme.nme13   ,
             g_nme.nme14   ,
             g_nme.nme15   ,
             g_nme.nme16   ,
             g_nme.nme17   ,
             g_nme.nme18   ,
             g_nme.nme19   ,
             g_nme.nme20   ,
             g_nme.nmeacti ,
             g_nme.nmeuser ,
             g_nme.nmegrup ,
             g_nme.nmemodu ,
             g_nme.nmedate ,
             g_nme.nme061,   #No.FUN-680088
             g_nme.nme21,    #No.FUN-730032
             g_nme.nme22,    #No.FUN-730032
             g_nme.nme23,    #No.FUN-730032
             g_nme.nme24,    #No.FUN-730032
             g_nme.nme25,    #No.FUN-730032
             g_nme.nme27,    #No.FUN-B30166
             g_nme.nmeoriu,  #TQC-A10060  add
             g_nme.nmeorig,  #TQC-A10060  add
             g_nme.nmelegal  #FUN-980005 
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins nme',STATUS,1)   
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t930_z() #when g_nnw.nnwconf='Y' (Turn to 'N')
  DEFINE l_sql      STRING               #No.FUN-670060
  DEFINE l_aba19    LIKE aba_file.aba19  #No.FUN-670060
 
   IF g_nnw.nnw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_nnw.* FROM nnw_file WHERE nnw01 = g_nnw.nnw01
 
   IF g_nnw.nnwconf = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
 
   IF g_nnw.nnwconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
   CALL s_get_doc_no(g_nnw.nnw01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nnw.nnw28) OR NOT cl_null(g_nnw.nnw29) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nnw.nnw01,'axr-370',0) RETURN 
      END IF 
   END IF 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                              
      #LET l_sql = " SELECT aba19 FROM ",g_dbs_in,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_in,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnw.nnw29,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_in) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnw.nnw29,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
      #LET l_sql = " SELECT aba19 FROM ",g_dbs_out,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_out,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnw.nnw28,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_out) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre2 FROM l_sql
      DECLARE aba_cs2 CURSOR FOR aba_pre2
      OPEN aba_cs2
      FETCH aba_cs2 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnw.nnw28,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t930_cl USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t930_cl INTO g_nnw.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
  
   IF g_nmy.nmyglcr = 'N' THEN
      #CALL t930_del_nme(g_dbs_out) #撥出營運中心DELETE二筆nme_file銀行異動資料
      CALL t930_del_nme(g_plant_out)  #FUN-A50102
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
 
      #CALL t930_del_nme(g_dbs_in)  #撥入營運中心DELETE 一筆nme_file銀行異動資料
      CALL t930_del_nme(g_plant_in)   #FUN-A50102
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   IF g_success = 'Y' THEN
      UPDATE nnw_file SET nnwconf = 'N'
       WHERE nnw01 = g_nnw.nnw01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","nnw_file",g_nnw.nnw01,"",SQLCA.sqlcode,"","upd nmd_file",1)  #No.FUN-660148
         LET g_success ='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      CALL s_showmsg_init()                     #No.FUN-710024
      CALL t930_upd_nnv('N') #每筆單身update nnv_file
                             #           set nnv29(已還原幣)=nnv29+nnx11
                             #               nnv30(已還本幣)=nnv30+nnx12
   END IF
   CALL s_showmsg()                             #No.FUN-710024
   IF g_success = 'Y' THEN
      CALL cl_flow_notify(g_nnw.nnw01,'N')
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
      IF g_nnw00 = '1' THEN
         LET g_str="anmp940 '2' '",g_nmz.nmz02b,"' '",g_nnw.nnw01,"' 'Y'"
      ELSE
         LET g_str="anmp940 '3' '",g_nmz.nmz02b,"' '",g_nnw.nnw01,"' 'Y'"
      END IF
      CALL cl_cmdrun_wait(g_str) 
      SELECT nnw28,nnw29 INTO g_nnw.nnw28,g_nnw.nnw29 FROM nnw_file 
       WHERE nnw01 = g_nnw.nnw01
      DISPLAY BY NAME g_nnw.nnw28
      DISPLAY BY NAME g_nnw.nnw29
      #CALL t930_del_nme(g_dbs_in)
      #CALL t930_del_nme(g_dbs_out)
      CALL t930_del_nme(g_plant_in)   #FUN-A50102
      CALL t930_del_nme(g_plant_out)  #FUN-A50102
   END IF 
   SELECT * INTO g_nnw.* FROM nnw_file
    WHERE nnw01 = g_nnw.nnw01
 
   CALL t930_show()
 
END FUNCTION
 
#FUNCTION t930_del_nme(p_dbs)
FUNCTION t930_del_nme(l_plant)   #FUN-A50102
   DEFINE #p_dbs   LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
          l_plant LIKE type_file.chr21,   #FUN-A50102
          l_sql   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
   DEFINE l_nme24 LIKE nme_file.nme24   #FUN-730032
   DEFINE l_aza73 LIKE aza_file.aza73   #No.MOD-740346
 
   #LET g_sql="SELECT aza73 FROM ",p_dbs CLIPPED,"aza_file"
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(l_plant,'aza_file') #FUN-A50102
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
   PREPARE t930_aza_p FROM g_sql
   DECLARE t930_aza_c CURSOR FOR t930_aza_p
   OPEN t930_aza_c
   FETCH t930_aza_c INTO l_aza73
   IF l_aza73 = 'Y' THEN
      #LET g_sql="SELECT nme24 FROM ",p_dbs CLIPPED,"nme_file",
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
                " WHERE nme12='",g_nnw.nnw01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
      PREPARE del_nme24_p FROM g_sql
      DECLARE del_nme24_cs CURSOR FOR del_nme24_p
      FOREACH del_nme24_cs INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nnw.nnw01,'anm-043',1)
            LET g_success='N'        #No.MOD-740346
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346
   #LET l_sql = "DELETE FROM  ",p_dbs CLIPPED,"nme_file",
   LET l_sql = "DELETE FROM  ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
               " WHERE nme12 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
   PREPARE nme_del_pre FROM l_sql
 
   EXECUTE nme_del_pre USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err('del nme',STATUS,1) 
      LET g_success='N'
      RETURN
   END IF
   #FUN-B40056  --begin
   LET l_sql = "DELETE FROM  ",cl_get_target_table(l_plant,'tic_file'),
               " WHERE tic04 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
   PREPARE tic_del_pre FROM l_sql
 
   EXECUTE tic_del_pre USING g_nnw.nnw01
   IF STATUS THEN
      CALL cl_err('del tic',STATUS,1) 
      LET g_success='N'
      RETURN
   END IF
   #FUN-B40056  --end
 
END FUNCTION
 
FUNCTION t930_upd_nnv(p_yn)
#anmt930----------------------------------------------
#for 確認時
#每筆單身update nnv_file
#           set nnv29(已還原幣)=nnv29+nnx11
#               nnv30(已還本幣)=nnv30+nnx12
#for 取消確認時
#每筆單身update nnv_file
#           set nnv29(已還原幣)=nnv29-nnx11
#               nnv30(已還本幣)=nnv30-nnx12
#anmt930----------------------------------------------
 
#anmt940----------------------------------------------
#for 確認時
#每筆單身update nnv_file
#           set nnv31(已還原幣利息)=nnv31+nnx18
#               nnv32(已還本幣利息)=nnv32+nnx19
#               nnv33(最後還息日) =nnw02
#for 取消確認時
#每筆單身update nnv_file
#           set nnv31(已還原幣利息)=nnv31-nnx18
#               nnv32(已還本幣利息)=nnv32-nnx19
#               nnv33(最後還息日) =除本身該筆之外
#                                  同調撥單號己存在還息單
#                                  且確認碼='Y'的最大單日期(nnw02)
#anmt940----------------------------------------------
 
   DEFINE l_nnv     RECORD LIKE nnv_file.*
   DEFINE l_nnx     RECORD LIKE nnx_file.*
   DEFINE l_nnw02   LIKE nnw_file.nnw02
   DEFINE p_yn      LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01) #Y:確認  N:取消確認
 
   DECLARE t930_nnx CURSOR FOR  
     SELECT * FROM nnx_file
      WHERE nnx01 = g_nnw.nnw01
 
   FOREACH t930_nnx INTO l_nnx.*
      IF STATUS THEN
         CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)   #No.FUN-710024
         LET g_success = 'N'
         EXIT FOREACH
      END IF
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
      SELECT * INTO l_nnv.*
        FROM nnv_file
       WHERE nnv01 = l_nnx.nnx03
      IF STATUS THEN
         CALL s_errmsg("nnv01",l_nnx.nnx03,"SEL nnv_file",SQLCA.sqlcode,1)     #No.FUN-710024
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      IF cl_null(l_nnx.nnx11) THEN LET l_nnx.nnx11 = 0 END IF
      IF cl_null(l_nnx.nnx12) THEN LET l_nnx.nnx12 = 0 END IF
      IF cl_null(l_nnx.nnx18) THEN LET l_nnx.nnx18 = 0 END IF
      IF cl_null(l_nnx.nnx19) THEN LET l_nnx.nnx19 = 0 END IF
      IF cl_null(l_nnv.nnv29) THEN LET l_nnv.nnv29 = 0 END IF
      IF cl_null(l_nnv.nnv30) THEN LET l_nnv.nnv30 = 0 END IF
      IF cl_null(l_nnv.nnv31) THEN LET l_nnv.nnv31 = 0 END IF
      IF cl_null(l_nnv.nnv32) THEN LET l_nnv.nnv32 = 0 END IF
 
      IF g_nnw00 = '1' THEN
         IF p_yn = 'Y' THEN
            UPDATE nnv_file
               SET nnv29 = l_nnv.nnv29 + l_nnx.nnx11,
                   nnv30 = l_nnv.nnv30 + l_nnx.nnx12
             WHERE nnv01 = l_nnx.nnx03
         ELSE
            UPDATE nnv_file
               SET nnv29 = l_nnv.nnv29 - l_nnx.nnx11,
                   nnv30 = l_nnv.nnv30 - l_nnx.nnx12
             WHERE nnv01 = l_nnx.nnx03
         END IF
      ELSE
         IF p_yn = 'Y' THEN
            UPDATE nnv_file
               SET nnv31 = l_nnv.nnv31 + l_nnx.nnx18,
                   nnv32 = l_nnv.nnv32 + l_nnx.nnx19,
                   nnv33 = g_nnw.nnw02
             WHERE nnv01 = l_nnx.nnx03
         ELSE
            SELECT MAX(nnw02) 
              INTO l_nnw02
              FROM nnw_file,nnx_file
             WHERE nnw01 = nnx01
               AND nnwconf = 'Y'
               AND nnw01 <> g_nnw.nnw01
               AND nnx03 = l_nnx.nnx03
               AND nnw00 = g_nnw00
 
            UPDATE nnv_file
               SET nnv31 = l_nnv.nnv31 - l_nnx.nnx18,
                   nnv32 = l_nnv.nnv32 - l_nnx.nnx19,
                   nnv33 = l_nnw02
             WHERE nnv01 = l_nnx.nnx03
         END IF
      END IF
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg("nnv01",l_nnx.nnx03,"UPD nnv_file",SQLCA.sqlcode,1)            #No.FUN-710024
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH 
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
 
END FUNCTION
 
#分錄底稿產生
FUNCTION t930_gen_entry_sheet()  
 
   BEGIN WORK
 
   LET g_success = 'Y'
   CALL s_showmsg_init()              #No.FUN-710024
   CALL t930_g_gl(g_nnw.nnw01,'1',g_dbs_out,'0',g_azp01_out) #撥出  #No.FUN-680088 add '0'
   CALL s_showmsg()                   #No.FUN-710024
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      CALL t930_g_gl(g_nnw.nnw01,'2',g_dbs_in,'0',g_azp01_in) #撥入 #No.FUN-680088 add '0'
      IF g_success = 'N' THEN
         ROLLBACK WORK
      ELSE
         IF g_aza.aza63 = 'Y' THEN
            CALL t930_g_gl(g_nnw.nnw01,'1',g_dbs_out,'1',g_azp01_out)
            IF g_success = 'N' THEN
               ROLLBACK WORK
            ELSE
               CALL t930_g_gl(g_nnw.nnw01,'2',g_dbs_in,'1',g_azp01_in)
               IF g_success = 'N' THEN
                  ROLLBACK WORK
               ELSE
                  CALL cl_err('','aap-055',1)
                  COMMIT WORK
               END IF
            END IF
         ELSE
            #分錄底稿產生完畢 !
            CALL cl_err('','aap-055',1)
            COMMIT WORK
         END IF  #No.FUN-680088
      END IF
   END IF
 
END FUNCTION
 
#撥出分錄底稿維護
FUNCTION t930_main_out()  
 
   CALL t930_chgdbs(g_azp03_out,g_plant_out) #FUN-990069  add g_plant_out
 
   SELECT nmz02p,nmz02b INTO g_nmz.nmz02p,g_nmz.nmz02b  #No.FUN-680088 add nmz02p
     FROM nmz_file
    WHERE nmz00 = '0'
   CALL s_showmsg_init()                       #No.FUN-710024
   CALL s_fsgl('NM',g_npp00,g_nnw.nnw01,0,g_nmz.nmz02b,9,g_nnw.nnwconf,'0',g_nmz.nmz02p) #No.FUN-680088 add '0',g_nmz.nmz02p
   CALL t930_npp02('1','0')  #No.FUN-680088 add '0'
   CALL s_showmsg()                            #No.FUN-710024
   CALL t930_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
   CALL t930_lock_cur_a()
   CALL t930_lock_cur_b()
 
   CALL t930_fetch_cur() 
   OPEN t930_cs          
   FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
 
END FUNCTION
 
FUNCTION t930_main_out_1()  
 
   CALL t930_chgdbs(g_azp03_out,g_plant_out) #FUN-990069  add g_plant_out
 
   SELECT nmz02p,nmz02c INTO g_nmz.nmz02p,g_nmz.nmz02c
     FROM nmz_file
    WHERE nmz00 = '0'
 
   CALL s_showmsg_init()                       #No.FUN-710024
   CALL s_fsgl('NM',g_npp00,g_nnw.nnw01,0,g_nmz.nmz02c,9,g_nnw.nnwconf,'1',g_nmz.nmz02p)
   CALL t930_npp02('1','1')
   CALL s_showmsg()                       #No.FUN-710024
   CALL t930_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
   CALL t930_lock_cur_a()
   CALL t930_lock_cur_b()
   CALL t930_fetch_cur() 
   OPEN t930_cs          
   FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
END FUNCTION
 
#撥入分錄底稿維護
FUNCTION t930_main_in()  
 
   CALL t930_chgdbs(g_azp03_in,g_plant_in)   #FUN-990069  add g_plant_in
 
   SELECT nmz02p,nmz02b INTO g_nmz.nmz02p,g_nmz.nmz02b  #No.FUN-680088 add nmz02p
     FROM nmz_file
    WHERE nmz00 = '0'
 
   CALL s_showmsg_init()                       #No.FUN-710024
   CALL s_fsgl('NM',g_npp00,g_nnw.nnw01,0,g_nmz.nmz02b,9,g_nnw.nnwconf,'0',g_nmz.nmz02p) #No.FUN-680088 add g_nmz.nmz02p
   CALL t930_npp02('2','0')   #No.FUN-680088 add '0'
   CALL s_showmsg()                       #No.FUN-710024
   CALL t930_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
   CALL t930_lock_cur_a()
   CALL t930_lock_cur_b()
 
   CALL t930_fetch_cur() 
   OPEN t930_cs          
   FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
 
END FUNCTION
 
FUNCTION t930_main_in_1()  
 
   CALL t930_chgdbs(g_azp03_in,g_plant_in) #FUN-990069  add g_plant_in
 
   SELECT nmz02p,nmz02c INTO g_nmz.nmz02p,g_nmz.nmz02c 
     FROM nmz_file
    WHERE nmz00 = '0'
 
   CALL s_showmsg_init()                       #No.FUN-710024
   CALL s_fsgl('NM',g_npp00,g_nnw.nnw01,0,g_nmz.nmz02c,9,g_nnw.nnwconf,'1',g_nmz.nmz02p) 
   CALL t930_npp02('2','1')
   CALL s_showmsg()                       #No.FUN-710024
   CALL t930_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
   CALL t930_lock_cur_a()
   CALL t930_lock_cur_b()
   CALL t930_fetch_cur() 
   OPEN t930_cs          
   FETCH ABSOLUTE g_curs_index t930_cs INTO g_nnw.nnw01 
END FUNCTION
 
FUNCTION t930_g_gl(p_trno,p_code,p_dbs,p_npptype,p_azp01) #No.FUN-680088 add p_npptype
   DEFINE p_trno      LIKE nnw_file.nnw01
   DEFINE p_npptype   LIKE npp_file.npptype       #No.FUN-680088
   DEFINE l_err_cd    LIKE ze_file.ze01
   DEFINE p_code      LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1) #1:撥出, 2:撥入
   DEFINE p_dbs       LIKE type_file.chr21        #No.FUN-680107 VARCHAR(21)
   DEFINE l_buf       LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(70)
   DEFINE l_n         LIKE type_file.num5,        #No.FUN-680107 SMALLINT
          l_t         LIKE nmy_file.nmyslip,      #No.FUN-680107 VARCHAR(05)
          l_nmydmy3   LIKE nmy_file.nmydmy3,
          l_sql       LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(500)
   DEFINE p_azp01     LIKE azp_file.azp01         #FUN-980005 
   DEFINE l_legal     LIKE npp_file.npplegal      #FUN-980005 
 
   SELECT * INTO g_nnw.*
     FROM nnw_file
    WHERE nnw01 = g_nnw.nnw01
 
   IF p_trno IS NULL THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_nnw.nnwconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err(g_nnw.nnw01,'anm-232',1)
      RETURN
   END IF
 
   IF g_nnw.nnwconf='X' THEN
      LET g_success = 'N'
      CALL cl_err(g_nnw.nnw01,'apm-267',1)
      RETURN
   END IF
 
   IF NOT cl_null(g_nnw.nnw28) OR NOT cl_null(g_nnw.nnw29) THEN
      #該分錄底稿已拋轉總帳系統, 不允許重新產生 !
      LET g_success = 'N'
      CALL cl_err(g_nnw.nnw01,'aap-122',1)
      RETURN
   END IF
 
   #-->立帳日期不可小於關帳日期
   IF g_nnw.nnw02 <= g_nmz.nmz10 THEN 
      LET g_success = 'N'
      CALL cl_err(g_nnw.nnw01,'aap-176',1)
      RETURN
   END IF
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN
      LET l_nmydmy3 = 'N'
   END IF
 
   IF l_nmydmy3 = 'N' THEN
      LET g_success = 'N'
      #單別設定不需拋轉傳票!
      CALL cl_err(g_nnw.nnw01,'anm-936',1)
      RETURN
   END IF
 
   IF p_npptype = '0' THEN  #No.FUN-680088
      #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs CLIPPED,"npq_file",
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_azp01,'npq_file'), #FUN-A50102
                  " WHERE npqsys='NM' ",
                  "   AND npq00 =",g_npq00,
                  "   AND npq01 ='",p_trno,"'",
                  "   AND npq011=9 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
      PREPARE npq_cnt_pre FROM l_sql
      DECLARE npq_cnt_cur CURSOR FOR npq_cnt_pre
   
      OPEN npq_cnt_cur
      FETCH npq_cnt_cur INTO l_n
   
      IF l_n > 0 THEN
         IF p_code = '1' THEN
            #此單據撥出分錄底稿已存在，是否重新產生撥出分錄底稿 ?
            LET l_err_cd = 'anm-944'
         ELSE
            #此單據撥入分錄底稿已存在，是否重新產生撥入分錄底稿 ?
            LET l_err_cd = 'anm-945'
         END IF
   
         IF NOT cl_confirm(l_err_cd) THEN
            LET g_success = 'N'
            RETURN
         END IF
   
         #LET l_sql = "DELETE FROM ",p_dbs CLIPPED,"npq_file",
         LET l_sql = "DELETE FROM ",cl_get_target_table(p_azp01,'npq_file'), #FUN-A50102
                     " WHERE npqsys='NM' ",
                     "   AND npq00 =",g_npq00,
                     "   AND npq01 ='",p_trno,"'",
                     "   AND npq011=9 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
         PREPARE npq_del_pre FROM l_sql
         EXECUTE npq_del_pre
      END IF
   END IF  #No.FUN-680088
 
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =g_npp00
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=9
   LET g_npp.npp02 =g_nnw.nnw02
   LET g_npp.npptype = p_npptype  #No.FUN-680088
 
   #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"npp_file",
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_azp01,'npp_file'), #FUN-A50102
               "  (nppsys , ",
               "   npp00  , ",
               "   npp01  , ",
               "   npp011 , ",
               "   npp02  , ",
               "   npp03  , ",
               "   npp04  , ",
               "   npp05  , ",
               "   npp06  , ",
               "   npp07  , ",
               "   nppglno, ",
               "   npptype, ",  #No.FUN-680088 #TQC-9B0179 mod
               "   npplegal) ",  #FUN-980005   #TQC-9B0179 mod
               "   VALUES(?,?,?,?,?,?,?,?,?,?,?,?, ", #No.FUN-680088 add ?
               "          ? )" #FUN-980005  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
   PREPARE npp_ins_pre FROM l_sql
 
   CALL s_getlegal(p_azp01) RETURNING l_legal  
   LET g_npp.npplegal = l_legal 
   EXECUTE npp_ins_pre USING g_npp.nppsys,
                             g_npp.npp00,
                             g_npp.npp01,
                             g_npp.npp011,
                             g_npp.npp02,
                             g_npp.npp03,
                             g_npp.npp04,
                             g_npp.npp05,
                             g_npp.npp06,
                             g_npp.npp07,
                             g_npp.nppglno,
                             g_npp.npptype,  #No.FUN-680088
                             g_npp.npplegal   #FUN-980005 
 
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
      #LET l_sql = "UPDATE ",p_dbs CLIPPED,"npp_file",
      LET l_sql = "UPDATE ",cl_get_target_table(p_azp01,'npp_file'), #FUN-A50102
                  "   SET npp02 =? ",
                  " WHERE nppsys='NM' ",
                  "   AND npp00 =",g_npp00,
                  "   AND npp01 ='",p_trno,"'",
                  "   AND npp011=9 ",
                  "   AND npptype = '",p_npptype,"'"  #No.FUN-680088
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
      PREPARE npp_upd_pre FROM l_sql
 
      EXECUTE npp_upd_pre USING g_npp.npp02
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd npp:',STATUS,1)
         RETURN
      END IF
   END IF
 
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL cl_err('ins npp:',STATUS,1)
      RETURN
   END IF
 
   CALL t930_g_gl_1(p_trno,p_code,p_dbs,p_npptype,p_azp01)  #No.FUN-680088 add p_npptype
 
END FUNCTION
 
FUNCTION t930_g_gl_1(p_trno,p_code,p_dbs,p_npqtype,p_azp01)   #INSERT 分錄底稿單身檔 #No.FUN-680088 add p_npqtype
   DEFINE p_trno      LIKE nnw_file.nnw01
   DEFINE p_npqtype   LIKE npq_file.npqtype  #No.FUN-680088
   DEFINE p_code      LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)             #1:撥出, 2:撥入
   DEFINE p_dbs       LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
          l_nma05     LIKE nma_file.nma05,
          l_aag05     LIKE aag_file.aag05,
          l_axz08     LIKE axz_file.axz08,
          l_npq07_a   LIKE npq_file.npq07,   #借1
          l_npq07_b   LIKE npq_file.npq07,   #借2
          l_npq07_c   LIKE npq_file.npq07,   #貸1
          l_npq07_d   LIKE npq_file.npq07,   #貸2
          l_npq07f    LIKE npq_file.npq07f,
          l_sql       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
   DEFINE l_nnx       RECORD LIKE nnx_file.* #NO.FUN-640185
   DEFINE l_npq02     LIKE npq_file.npq02    #NO.FUN-640185
   DEFINE l_npq07_amt LIKE npq_file.npq07    #NO.FUN-640185 
   DEFINE p_azp01     LIKE azp_file.azp01    #FUN-980005 
   DEFINE l_legal     LIKE npq_file.npqlegal #FUN-980005 
   DEFINE p_plant     LIKE type_file.chr10   #FUN-980020
 
 
   LET p_plant = p_azp01                     #FUN-980020
 
   #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"npq_file",
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
               " (npqsys  , ",
               "  npq00   , ",
               "  npq01   , ",
               "  npq011  , ",
               "  npq02   , ",
               "  npq03   , ",
               "  npq04   , ",
               "  npq05   , ",
               "  npq06   , ",
               "  npq07f  , ",
               "  npq07   , ",
               "  npq08   , ",
               "  npq11   , ",
               "  npq12   , ",
               "  npq13   , ",
               "  npq14   , ",
               "  npq15   , ",
               "  npq21   , ",
               "  npq22   , ",
               "  npq23   , ",
               "  npq24   , ",
               "  npq25   , ",
               "  npq26   , ",
               "  npq27   , ",
               "  npq28   , ",
               "  npq29   , ",
               "  npq30   , ",
               "  npq31   , ",
               "  npq32   , ",
               "  npq33   , ",
               "  npq34   , ",
               "  npq35   , ",
               "  npq36   , ",
               "  npq37   , ",
               "  npqtype , ",  #No.FUN-680088
               "  npqlegal) ",  #FUN-980005 
               "   VALUES(?,?,?,?,?,?,?,?,?,?, ",
               "          ?,?,?,?,?,?,?,?,?,?, ",
               "          ?,?,?,?,?,?,?,?,?,?, ",
               "          ?,?,?,?,?,?) "  #No.FUN-680088 add ?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE npq_ins_pre FROM l_sql
 
      LET l_sql =
                 #"SELECT aag05 FROM ",p_dbs CLIPPED,"aag_file",
                 "SELECT aag05 FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 = ? ",
                 "   AND aag00 = ? "  #No.FUN-730032
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE aag05_pre FROM l_sql
      DECLARE aag05_cur CURSOR FOR aag05_pre
 
      IF p_npqtype = '0' THEN  #No.FUN-680088 
         LET l_sql =
                    #"SELECT nma05 FROM ",p_dbs CLIPPED,"nma_file",
                    "SELECT nma05 FROM ",cl_get_target_table(p_plant,'nma_file'), #FUN-A50102
                    " WHERE nma01 = ? "
      ELSE
         LET l_sql =
                    #"SELECT nma051 FROM ",p_dbs CLIPPED,"nma_file",
                    "SELECT nma051 FROM ",cl_get_target_table(p_plant,'nma_file'), #FUN-A50102
                    " WHERE nma01 = ? "
      END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE nma05_pre FROM l_sql
      DECLARE nma05_cur CURSOR FOR nma05_pre
 
      LET l_sql =
                 #"SELECT axz08 FROM ",g_dbs_curr CLIPPED,"axz_file",
                 "SELECT axz08 FROM ",cl_get_target_table(g_plant_curr,'axz_file'), #FUN-A50102
                 " WHERE axz01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_curr) RETURNING l_sql #FUN-A50102
      PREPARE axz08_pre FROM l_sql
      DECLARE axz08_cur CURSOR FOR axz08_pre
      LET l_npq02 = 0            #NO.FUN-640266
      LET g_npq.npq02 = 0        #NO.FUN-640266
 
      #LET l_sql = "SELECT * FROM ",g_dbs_curr CLIPPED,"nnx_file", 
      LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_curr,'nnx_file'), #FUN-A50102
                  " WHERE nnx01 = ? "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_curr) RETURNING l_sql #FUN-A50102
      PREPARE t930_gl_p FROM l_sql
      DECLARE t930_gl_curs CURSOR FOR t930_gl_p
      CALL s_get_bookno1(YEAR(g_npp.npp02),p_plant) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020 
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(p_dbs || ' ' || g_npp.npp02,'aoo-081',1)
      END IF
      IF p_npqtype = '0' THEN
         LET g_bookno3=g_bookno1
      ELSE
         LET g_bookno3=g_bookno2
      END IF
 
      INITIALIZE g_npq.* TO NULL
      LET g_npq.npqsys = g_npp.nppsys
      LET g_npq.npq00  = g_npq00
      LET g_npq.npq01  = g_npp.npp01
      LET g_npq.npq011 = g_npp.npp011
      LET g_npq.npq05  = g_nnw.nnw03 #部門
      LET g_npq.npqtype= p_npqtype   #No.FUN-680088
      LET l_npq07_amt  = 0           #NO.FUN-640185 ADD
 
      #anmt930:-------begin--------------------------------------
      #==>撥出
      #借:集團借款(nnw12,(nnx06*nnx11))                #NO.FUN-640185
      #   手續費  (nnw19,nnw18)
      #貸:銀行存款(nma05,(nnw09*nnx11))               #NO.FUN-640185
      #   手費費出帳銀行的銀存科目(nma05,nnw18)
      #==>撥入
      #借:銀行存款(nma05,nnw26)                     #NO.FUN-640185
      #貸:集團暫付(nnw27,(nnx11*nnv24))
      #anmt930:------end-----------------------------------------
 
      #anmt940:------begin---------------------------------------
      #==>撥出
      #借:利息費用(nnw12,nnw11)
      #   手續費  (nnw19,nnw18)
      #貸:銀行存款(nma05,nnw11)
      #   手續費出帳銀行的銀存科目(nma05,nnw18)
      #==>撥入
      #借:銀行存款(nma05,nnw26)
      #貸:利息收入(nnw27,nnw26)
      #anmt940:------end-----------------------------------------
      IF p_code = '1' THEN
#NO.FUN-640185 手續費只有產生一次 拉出來迴圈外面做----
          #借:手續費  (nnw19,nnw18)-------------------------------------------
          IF cl_null(g_nnw.nnw13) THEN  #手續費銀行
             LET l_npq07_b = 0
          ELSE
             LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
             LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
             #LET g_npq.npq02 = g_npq.npq02+1 #項次
             LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
             LET l_npq07_b   = g_nnw.nnw18   #本幣金額
             LET g_npq.npq07 = g_nnw.nnw18   #本幣金額
             LET g_npq.npq07f= g_nnw.nnw17   #原幣金額
             LET g_npq.npq24 = g_nnw.nnw15   #原幣幣別
             LET g_npq.npq25 = g_nnw.nnw16   #匯率
             IF p_npqtype = '0' THEN  #No.FUN-680088
                LET g_npq.npq03 = g_nnw.nnw19   #科目
             ELSE
                LET g_npq.npq03 = g_nnw.nnw191
             END IF
             #==>本科目是否作部門明細管理
             OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
             FETCH aag05_cur INTO l_aag05
             IF l_aag05='N' THEN
                 LET g_npq.npq05 = ''
             ELSE
                 LET g_npq.npq05 = g_nnw.nnw03
             END IF
             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
             RETURNING  g_npq.*
             CALL s_getlegal(p_azp01) RETURNING l_legal  
             LET g_npq.npqlegal = l_legal 
             EXECUTE npq_ins_pre USING
                       g_npq.npqsys  ,
                       g_npq.npq00   ,
                       g_npq.npq01   ,
                       g_npq.npq011  ,
                       g_npq.npq02   ,
                       g_npq.npq03   ,
                       g_npq.npq04   ,
                       g_npq.npq05   ,
                       g_npq.npq06   ,
                       g_npq.npq07f  ,
                       g_npq.npq07   ,
                       g_npq.npq08   ,
                       g_npq.npq11   ,
                       g_npq.npq12   ,
                       g_npq.npq13   ,
                       g_npq.npq14   ,
                       g_npq.npq15   ,
                       g_npq.npq21   ,
                       g_npq.npq22   ,
                       g_npq.npq23   ,
                       g_npq.npq24   ,
                       g_npq.npq25   ,
                       g_npq.npq26   ,
                       g_npq.npq27   ,
                       g_npq.npq28   ,
                       g_npq.npq29   ,
                       g_npq.npq30   ,
                       g_npq.npq31   ,
                       g_npq.npq32   ,
                       g_npq.npq33   ,
                       g_npq.npq34   ,
                       g_npq.npq35   ,
                       g_npq.npq36   ,
                       g_npq.npq37   ,
                       g_npq.npqtype ,  #No.FUN-680088
                       g_npq.npqlegal   #FUN980005 
             IF STATUS THEN
                 CALL cl_err('ins npq_d2:',STATUS,1)
                 LET g_success='N'
                 RETURN
             END IF
          END IF
 
          #貸:手費費出帳銀行的銀存科目(nma05,nnw18)------------------------
          IF cl_null(g_nnw.nnw13) THEN
              LET l_npq07_d = 0
          ELSE
              LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
              LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
              LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
              LET l_npq07_d = g_nnw.nnw18
              LET g_npq.npq07 = l_npq07_d                     #本幣金額
              LET g_npq.npq07f= g_nnw.nnw17                   #原幣金額
              LET g_npq.npq24 = g_nnw.nnw15                   #原幣幣別
              LET g_npq.npq25 = g_nnw.nnw16                   #匯率
              OPEN nma05_cur USING g_nnw.nnw13
              FETCH nma05_cur INTO l_nma05
              LET g_npq.npq03 = l_nma05                      #科目
              #==>本科目是否作部門明細管理
              OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
              FETCH aag05_cur INTO l_aag05
              IF l_aag05='N' THEN
                  LET g_npq.npq05 = ''
              ELSE
                  LET g_npq.npq05 = g_nnw.nnw03
              END IF
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
              RETURNING  g_npq.*
              CALL s_getlegal(p_azp01) RETURNING l_legal  
              LET g_npq.npqlegal = l_legal 
              EXECUTE npq_ins_pre USING
                       g_npq.npqsys  ,
                       g_npq.npq00   ,
                       g_npq.npq01   ,
                       g_npq.npq011  ,
                       g_npq.npq02   ,
                       g_npq.npq03   ,
                       g_npq.npq04   ,
                       g_npq.npq05   ,
                       g_npq.npq06   ,
                       g_npq.npq07f  ,
                       g_npq.npq07   ,
                       g_npq.npq08   ,
                       g_npq.npq11   ,
                       g_npq.npq12   ,
                       g_npq.npq13   ,
                       g_npq.npq14   ,
                       g_npq.npq15   ,
                       g_npq.npq21   ,
                       g_npq.npq22   ,
                       g_npq.npq23   ,
                       g_npq.npq24   ,
                       g_npq.npq25   ,
                       g_npq.npq26   ,
                       g_npq.npq27   ,
                       g_npq.npq28   ,
                       g_npq.npq29   ,
                       g_npq.npq30   ,
                       g_npq.npq31   ,
                       g_npq.npq32   ,
                       g_npq.npq33   ,
                       g_npq.npq34   ,
                       g_npq.npq35   ,
                       g_npq.npq36   ,
                       g_npq.npq37   ,
                       g_npq.npqtype ,  #No.FUN-680088
                       g_npq.npqlegal   #FUN-980005 
             IF STATUS THEN
                 CALL cl_err('ins npq_d3:',STATUS,1)
                 LET g_success='N'
                 RETURN
             END IF
          END IF
      END IF
 
#NO.FUN-64018 銀行存款只有產生一次 拉出來迴圈外面做----
      IF p_code = '2' THEN
         #==>撥入
         OPEN axz08_cur USING g_nnw.nnw20
         FETCH axz08_cur INTO l_axz08
         IF cl_null(l_axz08) THEN
             LET g_npq.npq37 = g_nnw.nnw20
         ELSE
             LET g_npq.npq37 = l_axz08
         END IF
         #借:銀行存款(nma05,nnw26) #-------------------------------------------
         LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
         LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
         LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
         LET l_npq07_a   = g_nnw.nnw26   #本幣金額
         LET g_npq.npq07 = g_nnw.nnw26   #本幣金額
         LET g_npq.npq07f= g_nnw.nnw25   #原幣金額
         LET g_npq.npq24 = g_nnw.nnw23   #原幣幣別
         LET g_npq.npq25 = g_nnw.nnw24   #匯率
         OPEN nma05_cur USING g_nnw.nnw21
         FETCH nma05_cur INTO l_nma05
         LET g_npq.npq03 = l_nma05   #科目
         #==>本科目是否作部門明細管理
         OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
         FETCH aag05_cur INTO l_aag05
         IF l_aag05='N' THEN
             LET g_npq.npq05 = ''
         ELSE
             LET g_npq.npq05 = g_nnw.nnw03
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
         RETURNING  g_npq.*
         CALL s_getlegal(p_azp01) RETURNING l_legal  
         LET g_npq.npqlegal = l_legal 
         EXECUTE npq_ins_pre USING
                   g_npq.npqsys  ,
                   g_npq.npq00   ,
                   g_npq.npq01   ,
                   g_npq.npq011  ,
                   g_npq.npq02   ,
                   g_npq.npq03   ,
                   g_npq.npq04   ,
                   g_npq.npq05   ,
                   g_npq.npq06   ,
                   g_npq.npq07f  ,
                   g_npq.npq07   ,
                   g_npq.npq08   ,
                   g_npq.npq11   ,
                   g_npq.npq12   ,
                   g_npq.npq13   ,
                   g_npq.npq14   ,
                   g_npq.npq15   ,
                   g_npq.npq21   ,
                   g_npq.npq22   ,
                   g_npq.npq23   ,
                   g_npq.npq24   ,
                   g_npq.npq25   ,
                   g_npq.npq26   ,
                   g_npq.npq27   ,
                   g_npq.npq28   ,
                   g_npq.npq29   ,
                   g_npq.npq30   ,
                   g_npq.npq31   ,
                   g_npq.npq32   ,
                   g_npq.npq33   ,
                   g_npq.npq34   ,
                   g_npq.npq35   ,
                   g_npq.npq36   ,
                   g_npq.npq37   ,
                   g_npq.npqtype ,  #No.FUN-680088
                   g_npq.npqlegal   #FUN-980005 
         IF STATUS THEN
             CALL cl_err('ins npq_d4:',STATUS,1)
             LET g_success='N'
             RETURN
         END IF
      END IF
      IF p_code = '1' THEN
#NO.FUN-640185 start--  #依單身產生多筆借貸分錄
          FOREACH t930_gl_curs USING p_trno INTO l_nnx.* 
          IF SQLCA.sqlcode THEN
              CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  #No.FUN-710024
              LET g_success = 'N'
          END IF
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
              #==>撥出
#NO.FUN-640185 end--  #依單身產生多筆借貸分錄
              OPEN axz08_cur USING g_nnw.nnw05
              FETCH axz08_cur INTO l_axz08
              IF cl_null(l_axz08) THEN
                  LET g_npq.npq37 = g_nnw.nnw05
              ELSE
                  LET g_npq.npq37 = l_axz08
              END IF
              #anmt930:借:集團借款(nnw12,(nnx06*nnx11))----------------------------
              #anmt940:借:利息費用(nnw12,nnw11)
              IF cl_null(l_npq02) OR l_npq02 = 0 THEN 
                  LET l_npq02 = 1
              ELSE
                  LET l_npq02 = l_npq02 + 1
              END IF
              LET g_npq.npq02 = l_npq02         #項次  
              LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
              LET l_npq07_a = l_nnx.nnx06 * l_nnx.nnx11
              LET l_npq07f  = l_nnx.nnx11
              IF cl_null(l_npq07_a) THEN LET l_npq07_a = 0 END IF
              IF cl_null(l_npq07f)  THEN LET l_npq07f  = 0 END IF
              IF g_nnw00 = '1' THEN
                  LET g_npq.npq07 = l_npq07_a     #本幣金額
                  LET g_npq.npq07f= l_npq07f      #原幣金額
              ELSE
                  LET g_npq.npq07 = g_nnw.nnw11   #本幣金額
                  LET g_npq.npq07f= g_nnw.nnw10   #原幣金額
              END IF
              LET g_npq.npq24 = g_nnw.nnw08   #原幣幣別
              LET g_npq.npq25 = g_nnw.nnw09   #匯率
              IF p_npqtype = '0' THEN  #No.FUN-680088
                 LET g_npq.npq03 = l_nnx.nnx21   #科目         #NO.FUN-640185 add
              ELSE
                 LET g_npq.npq03 = l_nnx.nnx211
              END IF
              #==>本科目是否作部門明細管理
              SELECT aag05
                INTO l_aag05
                FROM aag_file
               WHERE aag01=g_npq.npq03
                 AND aag00=g_bookno3  #No.FUN-730032
              IF l_aag05='N' THEN
                  LET g_npq.npq05 = ''
              ELSE
                  LET g_npq.npq05 = g_nnw.nnw03
              END IF
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
              RETURNING  g_npq.*
              CALL s_getlegal(p_azp01) RETURNING l_legal  
              LET g_npq.npqlegal = l_legal 
              EXECUTE npq_ins_pre USING
                        g_npq.npqsys  ,
                        g_npq.npq00   ,
                        g_npq.npq01   ,
                        g_npq.npq011  ,
                        g_npq.npq02   ,
                        g_npq.npq03   ,
                        g_npq.npq04   ,
                        g_npq.npq05   ,
                        g_npq.npq06   ,
                        g_npq.npq07f  ,
                        g_npq.npq07   ,
                        g_npq.npq08   ,
                        g_npq.npq11   ,
                        g_npq.npq12   ,
                        g_npq.npq13   ,
                        g_npq.npq14   ,
                        g_npq.npq15   ,
                        g_npq.npq21   ,
                        g_npq.npq22   ,
                        g_npq.npq23   ,
                        g_npq.npq24   ,
                        g_npq.npq25   ,
                        g_npq.npq26   ,
                        g_npq.npq27   ,
                        g_npq.npq28   ,
                        g_npq.npq29   ,
                        g_npq.npq30   ,
                        g_npq.npq31   ,
                        g_npq.npq32   ,
                        g_npq.npq33   ,
                        g_npq.npq34   ,
                        g_npq.npq35   ,
                        g_npq.npq36   ,
                        g_npq.npq37   ,
                        g_npq.npqtype ,  #No.FUN-680088
                        g_npq.npqlegal   #FUN-980005 
              IF STATUS THEN
                  CALL s_errmsg('','',"INS npq_d1:",SQLCA.sqlcode,1)   #No.FUN-710024
                  LET g_success='N'
                  CONTINUE FOREACH       #No.FUN-710024
              END IF
              #anmt930:貸:銀行存款(nma05,(nnw09*nnx11))--------------------------------
              #anmt940:貸:銀行存款(nma05,nnw11)
              LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
              LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
              LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
              IF g_nnw00 = '1' THEN
               LET l_npq07_c = l_npq07_c * g_nnw.nnw09
                  LET l_npq07_c = l_nnx.nnx11 * g_nnw.nnw09     #NO.FUN-640185 add
                  IF cl_null(l_npq07_c) THEN LET l_npq07_c = 0 END IF
               ELSE
                  LET l_npq07_c = g_nnw.nnw11
               END IF
               LET g_npq.npq07 = l_npq07_c                     #本幣金額
               LET g_npq.npq07f= g_nnw.nnw10                   #原幣金額
               LET g_npq.npq24 = g_nnw.nnw08                   #原幣幣別
               LET g_npq.npq25 = g_nnw.nnw09                   #匯率
               OPEN nma05_cur USING g_nnw.nnw06
               FETCH nma05_cur INTO l_nma05
               LET g_npq.npq03 = l_nma05                      #科目
               #==>本科目是否作部門明細管理
               OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
               FETCH aag05_cur INTO l_aag05
               IF l_aag05='N' THEN
                   LET g_npq.npq05 = ''
               ELSE
                   LET g_npq.npq05 = g_nnw.nnw03
               END IF
               CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
               RETURNING  g_npq.*
               CALL s_getlegal(p_azp01) RETURNING l_legal  
               LET g_npq.npqlegal = l_legal 
               EXECUTE npq_ins_pre USING
                         g_npq.npqsys  ,
                         g_npq.npq00   ,
                         g_npq.npq01   ,
                         g_npq.npq011  ,
                         g_npq.npq02   ,
                         g_npq.npq03   ,
                         g_npq.npq04   ,
                         g_npq.npq05   ,
                         g_npq.npq06   ,
                         g_npq.npq07f  ,
                         g_npq.npq07   ,
                         g_npq.npq08   ,
                         g_npq.npq11   ,
                         g_npq.npq12   ,
                         g_npq.npq13   ,
                         g_npq.npq14   ,
                         g_npq.npq15   ,
                         g_npq.npq21   ,
                         g_npq.npq22   ,
                         g_npq.npq23   ,
                         g_npq.npq24   ,
                         g_npq.npq25   ,
                         g_npq.npq26   ,
                         g_npq.npq27   ,
                         g_npq.npq28   ,
                         g_npq.npq29   ,
                         g_npq.npq30   ,
                         g_npq.npq31   ,
                         g_npq.npq32   ,
                         g_npq.npq33   ,
                         g_npq.npq34   ,
                         g_npq.npq35   ,
                         g_npq.npq36   ,
                         g_npq.npq37   ,
                         g_npq.npqtype ,  #No.FUN-680088
                         g_npq.npqlegal   #FUN-980005 
               IF STATUS THEN
                   CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  #No.FUN-710024
                   LET g_success='N'  
                   CONTINUE FOREACH              #No.FUN-710024
               END IF
 
               #借貸方的差異歸入匯差科目------------------------------------------------
               #借:匯兌損失科目(nms13)
               #貸:匯兌收益科目(nms12)
               IF (l_npq07_a + l_npq07_b  <> l_npq07_c + l_npq07_d) AND g_nnw00 = '1' THEN
                   LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
                   LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
                   #CALL t930_nms(g_dbs_out,p_npqtype) RETURNING g_nms12_out,g_nms13_out  #No.FUN-680088 add p_npqtype
                   CALL t930_nms(g_plant_out,p_npqtype) RETURNING g_nms12_out,g_nms13_out   #FUN-A50102
                   IF l_npq07_a + l_npq07_b  > l_npq07_c + l_npq07_d THEN
                       LET g_npq.npq03 = g_nms12_out                         #科目
                       LET g_npq.npq06 = '2'                                 #借貸別 (1.借 2.貸)
                       LET g_npq.npq07 = (l_npq07_a + l_npq07_b) - (l_npq07_c + l_npq07_d)
                   ELSE
                       LET g_npq.npq03 = g_nms13_out                         #科目
                       LET g_npq.npq06 = '1'                                 #借貸別 (1.借 2.貸)
                       LET g_npq.npq07 = (l_npq07_c + l_npq07_d) - (l_npq07_a + l_npq07_b) #本幣金額
                   END IF
                   LET g_npq.npq07f= 0                                       #原幣金額    #MOD-740400
                   LET g_npq.npq24 = g_aza17_out                             #原幣幣別
                   LET g_npq.npq25 = 1                                       #匯率
                   #==>本科目是否作部門明細管理
                   OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
                   FETCH aag05_cur INTO l_aag05
                   IF l_aag05='N' THEN
                       LET g_npq.npq05 = ''
                   ELSE
                       LET g_npq.npq05 = g_nnw.nnw03
                   END IF
                   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
                   RETURNING  g_npq.*
                   CALL s_getlegal(p_azp01) RETURNING l_legal  
                   LET g_npq.npqlegal = l_legal 
                   EXECUTE npq_ins_pre USING
                             g_npq.npqsys  ,
                             g_npq.npq00   ,
                             g_npq.npq01   ,
                             g_npq.npq011  ,
                             g_npq.npq02   ,
                             g_npq.npq03   ,
                             g_npq.npq04   ,
                             g_npq.npq05   ,
                             g_npq.npq06   ,
                             g_npq.npq07f  ,
                             g_npq.npq07   ,
                             g_npq.npq08   ,
                             g_npq.npq11   ,
                             g_npq.npq12   ,
                             g_npq.npq13   ,
                             g_npq.npq14   ,
                             g_npq.npq15   ,
                             g_npq.npq21   ,
                             g_npq.npq22   ,
                             g_npq.npq23   ,
                             g_npq.npq24   ,
                             g_npq.npq25   ,
                             g_npq.npq26   ,
                             g_npq.npq27   ,
                             g_npq.npq28   ,
                             g_npq.npq29   ,
                             g_npq.npq30   ,
                             g_npq.npq31   ,
                             g_npq.npq32   ,
                             g_npq.npq33   ,
                             g_npq.npq34   ,
                             g_npq.npq35   ,
                             g_npq.npq36   ,
                             g_npq.npq37   ,
                             g_npq.npqtype ,  #No.FUN-680088
                             g_npq.npqlegal   #FUN-980005 
                   IF STATUS THEN
                       CALL s_errmsg('','',"INS npq_d3:",SQLCA.sqlcode,1) #No.FUN-710024
                       LET g_success='N'
                       CONTINUE FOREACH              #No.FUN-710024
                   END IF
               END IF
          END FOREACH
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
      ELSE
 
#依單身產生多筆借貸分錄
          FOREACH t930_gl_curs USING p_trno  INTO l_nnx.* 
          IF SQLCA.sqlcode THEN
              CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1) #No.FUN-710024
              LET g_success = 'N'
          END IF
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
               #anmt930:貸:集團暫付(nnw27,(nnx11*nnv24)#----------------------------------
               #anmt940:貸:利息收入(nnw27,nnw26)
               LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
               LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
               LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
               CALL t930_get_amt(l_nnx.nnx01,l_nnx.nnx02) RETURNING l_npq07_b       #計算nnx11*nnv24  FUN-640185
               IF g_success = 0 THEN RETURN END IF
               IF cl_null(l_npq07_b) THEN LET l_npq07_b = 0 END IF
               IF g_nnw00 = '1' THEN
                   LET g_npq.npq07 = l_npq07_b                   #本幣金額
                   LET g_npq.npq07f= l_npq07_b                   #原幣金額
               ELSE
                   LET g_npq.npq07 = g_nnw.nnw26                 #本幣金額
                   LET g_npq.npq07f= g_nnw.nnw26                 #原幣金額
               END IF
               LET l_npq07_amt = l_npq07_amt + l_npq07_b     #NO.FUN-640185 ADD
               LET g_npq.npq24 = g_aza17_in                  #原幣幣別
               LET g_npq.npq25 = 1                           #匯率
               IF p_npqtype = '0' THEN  #No.FUN-680088
                  LET g_npq.npq03 = l_nnx.nnx20                  #科目   #NO.FUN-640185 
               ELSE
                  LET g_npq.npq03 = l_nnx.nnx201
               END IF
               #==>本科目是否作部門明細管理
               SELECT aag05
                 INTO l_aag05
                 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3  #No.FUN-730032
               IF l_aag05='N' THEN
                   LET g_npq.npq05 = ''
               ELSE
                   LET g_npq.npq05 = g_nnw.nnw03
               END IF
               CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
               RETURNING  g_npq.*
               CALL s_getlegal(p_azp01) RETURNING l_legal  
               LET g_npq.npqlegal = l_legal 
               EXECUTE npq_ins_pre USING
                         g_npq.npqsys  ,
                         g_npq.npq00   ,
                         g_npq.npq01   ,
                         g_npq.npq011  ,
                         g_npq.npq02   ,
                         g_npq.npq03   ,
                         g_npq.npq04   ,
                         g_npq.npq05   ,
                         g_npq.npq06   ,
                         g_npq.npq07f  ,
                         g_npq.npq07   ,
                         g_npq.npq08   ,
                         g_npq.npq11   ,
                         g_npq.npq12   ,
                         g_npq.npq13   ,
                         g_npq.npq14   ,
                         g_npq.npq15   ,
                         g_npq.npq21   ,
                         g_npq.npq22   ,
                         g_npq.npq23   ,
                         g_npq.npq24   ,
                         g_npq.npq25   ,
                         g_npq.npq26   ,
                         g_npq.npq27   ,
                         g_npq.npq28   ,
                         g_npq.npq29   ,
                         g_npq.npq30   ,
                         g_npq.npq31   ,
                         g_npq.npq32   ,
                         g_npq.npq33   ,
                         g_npq.npq34   ,
                         g_npq.npq35   ,
                         g_npq.npq36   ,
                         g_npq.npq37   ,
                         g_npq.npqtype ,  #No.FUN-680088
                         g_npq.npqlegal   #FUN-980005 
               IF STATUS THEN
                   CALL s_errmsg('','',"INS npq_d5",SQLCA.sqlcode,1)   #No.FUN-710024
                   LET g_success='N'
                   CONTINUE FOREACH                   #No.FUN-710024
               END IF
          END FOREACH      #NO.FUN-640185
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
          #借貸方的差異歸入匯差科目------------------------------------------------
          #借:匯兌損失科目(nms13)
          #貸:匯兌收益科目(nms12)
          IF (l_npq07_a <> l_npq07_amt) AND g_nnw00 = '1' THEN   #NO.FUN-640185 
              LET l_npq02 = l_npq02 + 1         #NO.FUN-640266
              LET g_npq.npq02 = l_npq02         #項次  #NO.FUN-640266 
              #CALL t930_nms(g_dbs_in,p_npqtype) RETURNING g_nms12_in ,g_nms13_in  #No.FUN-680088 add p_npqtype
              CALL t930_nms(g_plant_in,p_npqtype) RETURNING g_nms12_in ,g_nms13_in  #FUN-A50102
              IF l_npq07_a > l_npq07_b THEN
                  LET g_npq.npq03 = g_nms12_in                          #科目
                  LET g_npq.npq06 = '2'                                 #借貸別 (1.借 2.貸)
                  LET g_npq.npq07 = l_npq07_a - l_npq07_b               #本幣金額
              ELSE
                  LET g_npq.npq03 = g_nms13_in                          #科目
                  LET g_npq.npq06 = '1'                                 #借貸別 (1.借 2.貸)
                  LET g_npq.npq07 = l_npq07_b - l_npq07_a               #本幣金額
              END IF
              LET g_npq.npq07f= g_npq.npq07                             #原幣金額
              LET g_npq.npq24 = g_aza17_in                              #原幣幣別
              LET g_npq.npq25 = 1                                       #匯率
              #==>本科目是否作部門明細管理
              OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
              FETCH aag05_cur INTO l_aag05
              IF l_aag05='N' THEN
                  LET g_npq.npq05 = ''
              ELSE
                  LET g_npq.npq05 = g_nnw.nnw03
              END IF
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
              RETURNING  g_npq.*
              CALL s_getlegal(p_azp01) RETURNING l_legal  
              LET g_npq.npqlegal = l_legal 
              EXECUTE npq_ins_pre USING
                        g_npq.npqsys  ,
                        g_npq.npq00   ,
                        g_npq.npq01   ,
                        g_npq.npq011  ,
                        g_npq.npq02   ,
                        g_npq.npq03   ,
                        g_npq.npq04   ,
                        g_npq.npq05   ,
                        g_npq.npq06   ,
                        g_npq.npq07f  ,
                        g_npq.npq07   ,
                        g_npq.npq08   ,
                        g_npq.npq11   ,
                        g_npq.npq12   ,
                        g_npq.npq13   ,
                        g_npq.npq14   ,
                        g_npq.npq15   ,
                        g_npq.npq21   ,
                        g_npq.npq22   ,
                        g_npq.npq23   ,
                        g_npq.npq24   ,
                        g_npq.npq25   ,
                        g_npq.npq26   ,
                        g_npq.npq27   ,
                        g_npq.npq28   ,
                        g_npq.npq29   ,
                        g_npq.npq30   ,
                        g_npq.npq31   ,
                        g_npq.npq32   ,
                        g_npq.npq33   ,
                        g_npq.npq34   ,
                        g_npq.npq35   ,
                        g_npq.npq36   ,
                        g_npq.npq37   ,
                        g_npq.npqtype ,  #No.FUN-680088
                        g_npq.npqlegal   #FUN-980005
              IF STATUS THEN
                  CALL s_errmsg('','',"INS npq_d3:",SQLCA.sqlcode,1)       #No.FUN-710024
                  LET g_success='N'
                  RETURN          
              END IF
          END IF
       END IF
END FUNCTION
 
FUNCTION t930_npp02(p_code,p_npptype)      #No.FUN-680088 add p_npptype
   DEFINE p_code    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE p_npptype LIKE npp_file.npptype  #No.FUN-680088
 
   IF p_code = '1' THEN
       IF cl_null(g_nnw.nnw28) THEN
          UPDATE npp_file SET npp02=g_nnw.nnw02
           WHERE npp01=g_nnw.nnw01
             AND npp00=g_npp00
             AND npp011=9
             AND nppsys= 'NM'
             AND npptype = p_npptype  #No.FUN-680088
       END IF
   ELSE
       IF cl_null(g_nnw.nnw29) THEN
          UPDATE npp_file SET npp02=g_nnw.nnw02
           WHERE npp01=g_nnw.nnw01
             AND npp00=g_npp00
             AND npp011=9
             AND nppsys= 'NM'
             AND npptype = p_npptype  #No.FUN-680088
       END IF
   END IF
   IF SQLCA.sqlcode THEN  #No.FUN-680088
       LET g_showmsg=g_nnw.nnw01,"/",g_npp00,"/",p_npptype                 #No.FUN-710024
       CALL s_errmsg("npp01,npp00,npptype",g_showmsg,"UPD npp_file",SQLCA.sqlcode,0)  #No.FUN-710024
   END IF
END FUNCTION
 
FUNCTION t930_chgdbs(p_dbs,p_plant)  #FUN-990069 add p_plant
  DEFINE p_dbs   LIKE azp_file.azp03
  DEFINE p_plant LIKE azp_file.azp01  #FUN-990069
 
   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
   CLOSE DATABASE    #MOD-740401
   DATABASE p_dbs
   CALL cl_ins_del_sid(1,p_plant) #FUN-980030   #FUN-990069
   IF STATUS THEN ERROR 'open database error!' RETURN END IF
   CURRENT WINDOW IS SCREEN
   CALL cl_dsmark(0)
END FUNCTION
 
#FUNCTION t930_nms(p_dbs,p_npptype)           #科目  #No.FUN-680088 add p_npptype
FUNCTION t930_nms(l_plant,p_npptype)   #FUN-A50102
    DEFINE #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant   LIKE type_file.chr21, 
           l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
           l_nms12   LIKE nms_file.nms12,
           l_nms13   LIKE nms_file.nms13
    DEFINE p_npptype LIKE npp_file.npptype   #No.FUN-680088
 
    LET g_errno = ' '
    IF p_npptype = '0' THEN  #No.FUN-680088
       LET l_sql=
                 #"SELECT nms12,nms13 FROM ",p_dbs CLIPPED,"nms_file",
                 "SELECT nms12,nms13 FROM ",cl_get_target_table(l_plant,'nms_file'), #FUN-A50102
                 " WHERE (nms01 = ' ' OR nms01 IS NULL) "
    ELSE
       LET l_sql=
                 #"SELECT nms121,nms131 FROM ",p_dbs CLIPPED,"nms_file",
                 "SELECT nms121,nms131 FROM ",cl_get_target_table(l_plant,'nms_file'), #FUN-A50102
                 " WHERE (nms01 = ' ' OR nms01 IS NULL) "
    END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE nms_pre FROM l_sql
    DECLARE nms_cur CURSOR FOR nms_pre
    OPEN nms_cur
    FETCH nms_cur INTO l_nms12,l_nms13
    CLOSE nms_cur
    RETURN l_nms12,l_nms13
END FUNCTION

FUNCTION t930_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_nnw.nnw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nnw.* FROM nnw_file WHERE nnw01 = g_nnw.nnw01
    IF g_nnw.nnwconf='Y' THEN CALL cl_err('','apm-267',1)  RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t930_cl USING g_nnw.nnw01
    IF STATUS THEN
       CALL cl_err("OPEN t930_cl:", STATUS, 1)
       CLOSE t930_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t930_cl INTO g_nnw.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnw.nnw01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t930_show()
    IF cl_void(0,0,g_nnw.nnwconf) THEN
       IF g_nnw.nnwconf='N' THEN    #切換為作廢
          LET g_nnw.nnwconf='X'
       ELSE                       #取消作廢
          LET g_nnw.nnwconf='N'
       END IF
       UPDATE nnw_file
          SET nnwconf = g_nnw.nnwconf
        WHERE nnw01 = g_nnw.nnw01
       IF STATUS THEN
           CALL cl_err3("upd","nnw_file",g_nnw.nnw01,"",STATUS,"","",1)  #No.FUN-660148
           LET g_success='N'
       END IF
       IF SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('','aap-161',0)
           LET g_success='N'
       END IF
    END IF
    SELECT nnwconf INTO g_nnw.nnwconf FROM nnw_file
     WHERE nnw01 = g_nnw.nnw01
    DISPLAY BY NAME g_nnw.nnwconf
    CLOSE t930_cl
    IF g_success = 'Y' THEN
        CALL cl_cmmsg(1)
        COMMIT WORK
        CALL cl_flow_notify(g_nnw.nnw01,'V')
    ELSE
        CALL cl_rbmsg(1)
        ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t930_get_amt(g_nnx01,g_nnx02) #計算集團暫付金額   #NO.FUN-640185
  DEFINE     l_nnv            RECORD LIKE nnv_file.*
  DEFINE     l_nnx            RECORD LIKE nnx_file.*
  DEFINE     l_paid_amt       LIKE nnx_file.nnx11
  DEFINE     l_paid_amt_all   LIKE nnx_file.nnx11
  DEFINE     g_nnx01          LIKE nnx_file.nnx01     #NO.FUN-640185
  DEFINE     g_nnx02          LIKE nnx_file.nnx02     #NO.FUN-640185
 
    SELECT * INTO l_nnx.*
      FROM nnx_file
     WHERE nnx01 = g_nnx01
       AND nnx02 = g_nnx02
 
   LET l_paid_amt     = 0
 
       SELECT * INTO l_nnv.*
         FROM nnv_file
        WHERE nnv01 = l_nnx.nnx03
          AND nnvacti IN ('y','Y') #No.MOD-910034
       IF STATUS THEN
          CALL cl_err3("sel","nnv_file",l_nnx.nnx03,"",STATUS,"","sel nnv:",1)  #No.FUN-660148
          LET g_success = 'N'
       END IF
       IF cl_null(l_nnx.nnx11) THEN LET l_nnx.nnx11 = 0 END IF
       IF cl_null(l_nnv.nnv24) THEN LET l_nnv.nnv24 = 1 END IF
       LET l_paid_amt     = l_nnx.nnx11 * l_nnv.nnv24
    RETURN l_paid_amt              #NO.FUN-640185 ADD
END FUNCTION
 
FUNCTION t930_def_form()
    CALL cl_set_comp_visible("nnw12,nnw27,aag02_1,aag02_2",FALSE)
    CALL cl_set_comp_visible("nnw121,nnw271,aag02_4,aag02_5",FALSE)  #No.FUN-680088
   IF g_nnw00 = '1' THEN #還本
      CALL cl_set_comp_visible("nnx14,nnx15,nnx16,nnx17,nnx18,nnx19",FALSE) #還息的欄位隱藏
      CALL cl_getmsg('anm-920',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw01",g_msg CLIPPED)
      CALL cl_getmsg('anm-921',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw12",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("nnx09,nnx10,nnx11,nnx12,nnx13,nnx20,nnx21,nnx201,nnx211",FALSE)  #No.FUN-680088
      CALL cl_getmsg('anm-922',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw01",g_msg CLIPPED)
      CALL cl_getmsg('anm-923',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw12",g_msg CLIPPED)
   END IF
   
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("nnw191,aag02_6,nnx201,nnx211",FALSE)
   END IF
END FUNCTION
#欄位控制
#   條件欄位         被影響欄位                       REQUIRED成立條件
#   ------------     -------------------------------  -----------------------------
#   nnw13手續費銀行  nnw14手續費異動碼                not cl_null(g_nnw.nnw13)
#                    nnw16手續費匯率  
#                    nnw17手續費原幣  
#                    nnw18手續費本幣  
#                    nnw19手續費科目  
FUNCTION t930_required_a()
     IF NOT cl_null(g_nnw.nnw13) THEN
         CALL cl_set_comp_required("nnw14,nnw16,nnw17,nnw18,nnw19",TRUE) 
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_comp_required("nnw191",TRUE) 
         END IF
     END IF
END FUNCTION
FUNCTION t930_no_required_a()
     IF cl_null(g_nnw.nnw13) THEN
         CALL cl_set_comp_required("nnw14,nnw16,nnw17,nnw18,nnw19,nnw191",FALSE) #No.FUN-680088
         LET g_nnw.nnw14 = NULL
         LET g_nnw.nnw15 = NULL
         LET g_nnw.nnw16 = NULL
         LET g_nnw.nnw17 = NULL
         LET g_nnw.nnw18 = NULL
         LET g_nnw.nnw19 = NULL
         LET g_nnw.nnw191 = NULL  #No.FUN-680088
         DISPLAY BY NAME g_nnw.nnw14,g_nnw.nnw15,g_nnw.nnw16,g_nnw.nnw17,g_nnw.nnw18,g_nnw.nnw19
         DISPLAY '' TO FORMONLY.nma02_3
         DISPLAY '' TO FORMONLY.nmc03_3
         DISPLAY '' TO FORMONLY.aag02_3
         DISPLAY '' TO FORMONLY.aag02_6  #No.FUN-680088
     END IF
END FUNCTION
FUNCTION t930_set_entry_a()
      CALL cl_set_comp_entry("nnw14,nnw16,nnw17,nnw18,nnw19,nnw191",TRUE) #No.FUN-680088
      IF g_nmy.nmydmy6 = 'Y' THEN
          CALL cl_set_comp_entry("nnw31,nnw32",TRUE)
      END IF
END FUNCTION
FUNCTION t930_set_no_entry_a()
    IF cl_null(g_nnw.nnw13) THEN
        CALL cl_set_comp_entry("nnw14,nnw16,nnw17,nnw18,nnw19,nnw191",FALSE) #No.FUN-680088
    END IF
    IF g_nmy.nmydmy6 <> 'Y' THEN
        LET g_nnw.nnw31 = NULL
        LET g_nnw.nnw32 = NULL
        DISPLAY NULL TO nnw31
        DISPLAY NULL TO nnw32
        DISPLAY NULL TO FORMONLY.nnw31_nma02
        DISPLAY NULL TO FORMONLY.nnw32_nma02
        CALL cl_set_comp_entry("nnw31,nnw32",FALSE)
    END IF
END FUNCTION
 
FUNCTION t930_carry_voucher()
  DEFINE l_nmygslp_in   LIKE nmy_file.nmygslp
  DEFINE l_nmygslp_out  LIKE nmy_file.nmygslp
  DEFINE li_result      LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs          STRING
  DEFINE l_sql          STRING
  DEFINE l_n            LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nnw.nnw28) AND NOT cl_null(g_nnw.nnw29) THEN
       CALL cl_err('','aap-618',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnw.nnw01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF   
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnw.nnw28,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre5 FROM l_sql
    DECLARE aba_cs5 CURSOR FOR aba_pre5
    OPEN aba_cs5
    FETCH aba_cs5 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_nnw.nnw28,'aap-991',1)
       RETURN
    END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnw.nnw29,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102 
    PREPARE aba_pre6 FROM l_sql
    DECLARE aba_cs6 CURSOR FOR aba_pre6
    OPEN aba_cs6
    FETCH aba_cs6 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_nnw.nnw29,'aap-991',1)
       RETURN
    END IF
    LET g_wc_gl = 'nnv01 = "',g_nnw.nnw01,'" AND nnv02 = "',g_nnw.nnw02,'"'                                                                      
    IF g_nnw00 = '1' THEN
       LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '2' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'" #No.FUN-680088#FUN-860040
    ELSE
       LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '3' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'" #No.FUN-680088#FUN-860040
    END IF
    CALL cl_cmdrun_wait(g_str)
    SELECT nnw28,nnw29 INTO g_nnw.nnw28,g_nnw.nnw29 FROM nnw_file
     WHERE nnw01 = g_nnw.nnw01
    DISPLAY BY NAME g_nnw.nnw28
    DISPLAY BY NAME g_nnw.nnw29
    
END FUNCTION
 
FUNCTION t930_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      STRING
  DEFINE l_n1       LIKE type_file.num5       #No.FUN-680107 SMALLINT
  DEFINE l_n2       LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
    IF cl_null(g_nnw.nnw28) AND cl_null(g_nnw.nnw29) THEN
       CALL cl_err('','aap-619',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnw.nnw01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET l_sql = " SELECT aba19 FROM ",g_dbs_in,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_in,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnw.nnw29,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_in) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre3 FROM l_sql
    DECLARE aba_cs3 CURSOR FOR aba_pre3
    OPEN aba_cs3
    FETCH aba_cs3 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnw.nnw29,'axr-071',1)
       RETURN                                                                                                                     
    END IF                                                                                                                        
    #LET l_sql = " SELECT aba19 FROM ",g_dbs_out,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_out,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnw.nnw28,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_out) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre4 FROM l_sql
    DECLARE aba_cs4 CURSOR FOR aba_pre4
    OPEN aba_cs4
    FETCH aba_cs4 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnw.nnw28,'axr-071',1)
       RETURN                                                                                                                     
    END IF                                                                                                                        
    IF g_nnw00 = '1' THEN
       LET g_str="anmp940 '2' '",g_nmz.nmz02b,"' '",g_nnw.nnw01,"' 'Y'"
    ELSE
       LET g_str="anmp940 '3' '",g_nmz.nmz02b,"' '",g_nnw.nnw01,"' 'Y'"
    END IF
    CALL cl_cmdrun_wait(g_str)
    SELECT nnw28,nnw29 INTO g_nnw.nnw28,g_nnw.nnw29 FROM nnw_file
     WHERE nnw01 = g_nnw.nnw01
    DISPLAY BY NAME g_nnw.nnw28
    DISPLAY BY NAME g_nnw.nnw29
END FUNCTION
#No.FUN-9C0072 精簡程式碼    

